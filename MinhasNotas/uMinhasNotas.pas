unit uMinhasNotas;

interface

uses
  Forms
  , Data.DB
  , Classes
  , IBX.IBDatabase
  , System.SysUtils
  , IBX.IBQuery
  , DateUtils
  , Winapi.ShellAPI
  , Winapi.Windows
  , Rest.Types
  ;

  procedure GeraEnvioMinhasNotas(IBDatabase: TIBDatabase; out bCompletado : boolean);
  function GeraXmlMinhasNotas(Transaction: TIBTransaction; out sDir : string; out bCompletado : boolean):boolean;
  procedure SalvaXML(sDir, sChave, sXML : string);
  procedure CompactaXMLs(sDir:string);
  procedure ApagarArquivosXML(sDir:string);
  function EnviaZipMinhasNotas(sFile:string):boolean;

implementation

uses uFuncoesBancoDados
  , smallfunc_xe
  , uFuncoesRetaguarda
  , uLogSistema
  , uWebServiceMinhasNotas
  , uconstantes_chaves_privadas
  , uSistema
  ;

procedure GeraEnvioMinhasNotas(IBDatabase: TIBDatabase; out bCompletado : boolean);
var
  Transaction: TIBTransaction;
  IBDatabaseNotas: TIBDatabase;
  bEnviado : boolean;
  sDir : string;
begin
  bCompletado := False;
  bEnviado    := False;

  try
    try
      //Cria Conexão para thread clonando da principal
      IBDatabaseNotas := CriaConexaoClone(IBDatabase);
      Transaction := TIBTransaction.Create(nil);
      Transaction.Params.Add('isc_tpb_concurrency');
      Transaction.Params.Add('isc_tpb_nowait');
      Transaction.DefaultDatabase := IBDatabaseNotas;
      IBDatabaseNotas.DefaultTransaction := Transaction;
      IBDatabaseNotas.Connected := True;

      //Bloqueia/Valida tabela
      if not ExecutaComando(' Insert into MINHASNOTAS	'+
                            ' Values(''LOCK'') ',
                            Transaction) then
        Exit;

      //Gera XMLs
      if not GeraXmlMinhasNotas(Transaction, sDir, bCompletado) then
        Exit;

      //Zipa Arquivos
      CompactaXMLs(sDir);
      ApagarArquivosXML(sDir);
      RemoveDir(sDir);

      //Realiza envio Minhas Notas
      bEnviado := EnviaZipMinhasNotas(sDir+'.zip');

      //Commita dados
      if bEnviado then
      begin
        //Desbloqueia tabela
        ExecutaComando(' Delete From MINHASNOTAS '+
                       ' Where CHAVE = ''LOCK'' ',
                       Transaction);

        Transaction.Commit;

        LogSistema('Envio realizado Minhas Notas '+ExtractFileName(sDir),lgInformacao);
      end else
      begin
        LogSistema('Erro ao enviar Minhas Notas '+ExtractFileName(sDir),lgErro);
      end;
    finally
      if Transaction.Active then
        Transaction.Rollback;

      FreeAndNil(Transaction);
      FreeAndNil(IBDatabaseNotas);

      //Apaga arquivos
      //DeleteFile(pchar(sDir+'.zip'));
    end;
  except
  end;
end;

function GeraXmlMinhasNotas(Transaction: TIBTransaction; out sDir : string; out bCompletado : boolean):boolean;
var
  sChave, sXML, sDataRef  : string;
  qryAux: TIBQuery;
  DataRef : TDateTime;
begin
  Result      := False;
  bCompletado := False;
  DataRef     := Now;
  DataRef     := IncMonth(DataRef,-3);
  sDataRef    := FormatDateTime('YYYY-MM',DataRef) + '-01';

  try
    sDir := ExtractFilePath(Application.ExeName)+'temp\';

    if not DirectoryExists(sDir) then
      CreateDir(sDir);

    sDir := sDir + 'MN_'+FormatDateTime('DDMMYYhhmm',now);

    qryAux := CriaIBQuery(Transaction);
    qryAux.SQL.Text := ' Select first 1000'+
                       ' 	 NFEID,'+
                       ' 	 NFEXML'+
                       ' From	'+
                       ' 	 (Select '+
                       ' 		 NFEID,'+
                       ' 		 NFEXML,'+
                       ' 		 EMISSAO'+
                       ' 	 From VENDAS V'+
                       ' 	 Where not exists (Select 1 From MINHASNOTAS N '+
                       ' 					           Where N.CHAVE = V.NFEID) '+
                       ' 		 and EMISSAO >= '+QuotedStr(sDataRef)+
                       ' 		 and NFEID is not null'+
                       ' 		 and NFEXML is not null'+
                       ' 		 and EMITIDA = ''S'' 	'+
                       ' 	 Union All			'+
                       ' 	 Select '+
                       ' 		 NFEID,'+
                       ' 		 NFEXML,'+
                       ' 		 DATA EMISSAO'+
                       ' 	 From NFCE V'+
                       ' 	 Where not exists (Select 1 From MINHASNOTAS N '+
                       ' 					           Where N.CHAVE = V.NFEID) '+
                       ' 		 and DATA >= '+QuotedStr(sDataRef)+
                       ' 		 and NFEID is not null'+
                       ' 		 and NFEXML is not null'+
                       SqlFiltroNFCEAutorizado('V')+
                       ' 	 ) A'+
                       ' Order By EMISSAO';
    qryAux.Open;
    qryAux.FetchAll;

    if qryAux.IsEmpty then
    begin
      bCompletado := True;
      Exit;
    end;

    CreateDir(sDir);

    while not qryAux.Eof do
    begin
      sChave := qryAux.FieldByName('NFEID').AsString;
      sXML   := qryAux.FieldByName('NFEXML').AsString;

      SalvaXML(sDir, sChave, sXML);

      ExecutaComando(' Insert into MINHASNOTAS(CHAVE)'+
                     ' Values('+QuotedStr(sChave)+')',
                    Transaction);

      qryAux.Next;
    end;

    Result      := True;
    bCompletado := qryAux.RecordCount < 1000;
  finally
    FreeAndNil(qryAux);
  end;
end;

procedure SalvaXML(sDir, sChave, sXML : string);
var
  slArq: TStringList;
begin
  try
    slArq := TStringList.Create;
    slArq.Text := sXML;
    slArq.SaveToFile(sDir+'\'+sChave+'.xml');
  finally
    FreeAndNil(slArq);
  end;
end;

procedure CompactaXMLs(sDir:string);
begin
  try
    ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Trim(sDir + '\*.xml')+'" "'+Trim(sDir+'.zip')+'"'), '', SW_SHOWMAXIMIZED);

    while ConsultaProcesso('szip.exe') do
    begin
      Application.ProcessMessages;
      sleep(100);
    end;

    while not FileExists(pChar(sDir+'.zip')) do
    begin
      sleep(100);
    end;
  except
  end;
end;

procedure ApagarArquivosXML(sDir:string);
var
  AnEncontrou: Integer;
  oSearchRec : tSearchREC;
begin
  FindFirst(sDir + '\*.xml', faAnyFile, oSearchRec);
  AnEncontrou := 0;
  while AnEncontrou = 0 do
  begin
    DeleteFile(pChar(sDir+'\'+oSearchRec.Name));
    AnEncontrou := FindNext(oSearchRec);
  end;
  Sleep(100);
end;


function EnviaZipMinhasNotas(sFile:string):boolean;
var
  Resposta : string;
  StatusCode : integer;
begin
  Result := False;

  try
    Result := RequisicaoMinhasNotas(rmPOST,
                                    'https://v2.staging.clippfacil.com.br/producer-document/send-invoice-collection',
                                    LimpaNumero(TSistema.GetInstance.CNPJEmitente),
                                    TOKEN_MINHAS_NOTAS,
                                    sFile,
                                    Resposta,
                                    StatusCode);
  except
  end;
end;


end.
