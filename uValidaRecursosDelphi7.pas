unit uValidaRecursosDelphi7;

interface

uses
  Classes
  , SysUtils
  , StrUtils
  , Controls
  , Variants
  , Windows
  , IniFiles
  , IBDatabase
  , IBQuery
  , LbCipher
  , LbClass
  , uconstantes_chaves_privadas
  , uRecursosSistema
  //, uConectaBancoSmall
  , uCriptografia
  , uTypesRecursos
  , uLkJSON
  ;

type
  TValidaRecurso = class
  private
    FIBDatabase: TIBDatabase;
    FsRecurso: String;
    FsCNPJ: string;
    FrsRecursoSistema: TRecursosSistema;
    procedure InformacoesBD();
    procedure SetIBDatabase(const Value: TIBDatabase);
    function CriaIBTransaction(IBDatabase: TIBDatabase): TIBTransaction;
    function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
    function CampoExisteFB(Banco: TIBDatabase; sTabela: String; sCampo: String): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LeRecursos();
    function SistemaSerial(): String;
    function SistemaLimiteUsuarios(): Integer;
    function RecursoLiberado(sRecurso: TRecursos; out DataLimite: TDate): Boolean;
    function RecursoData(sRecurso: TRecursos): TDate;
    function PermiteRecursoParaProduto: Boolean;
    function ValidaQtdDocumentoFrente: Boolean;
    function ValidaQtdDocumentoRetaguarda: Boolean;
    function RecursoQuantidade(sRecurso: TRecursos): Integer;
    function RecursoQtd(sRecurso: TRecursos): Integer;
    property IBDATABASE: TIBDatabase read FIBDatabase write SetIBDatabase;
    property rsRecursoSistema: TRecursosSistema read FrsRecursoSistema write FrsRecursoSistema;
  end;

implementation

{ TValidaRecurso }

procedure TValidaRecurso.LeRecursos();
const sDataLimitePadrao = '01/01/1900';
var
  Mais1ini: tIniFile;
  js: TlkJSONobject;
  iTemRc: TlkJSONobject;
  s: String;
  i: Integer;
  function DataJsonToDate(Value: Variant): TDate;
  var
    sData: String;
  begin
    try
      sData := VarToStrDef(Value, '1900-01-01');
      sData := Copy(sData, 9, 2) + '/' + Copy(sData, 6, 2) + '/' + Copy(sData, 1, 4);
      Result := StrToDateDef(sData, StrToDate(sDataLimitePadrao));
    except
      Result := StrToDate(sDataLimitePadrao);
    end;
  end;
begin

  if FrsRecursoSistema = nil then
    FrsRecursoSistema := TRecursosSistema.Create;

  InformacoesBD;
  FsRecurso := SmallDecrypt(CHAVE_CIFRAR_NOVA, FsRecurso);

  FrsRecursoSistema.Serial   := '';
  FrsRecursoSistema.CNPJ     := '';
  FrsRecursoSistema.Usuarios := 1;

  js := TlkJSON.ParseText(FsRecurso) as TlkJSONobject;
  {
  if not assigned(js) then
  begin

    // Quando não tiver preenchido EMITENTE.RECURSO usará o serial do wind0ws.l0g
    // Necessário para permitir a instalação e primeira abertura do sistema


  end
  else
  }
  if assigned(js) then
  begin
    FrsRecursoSistema.Serial   := '';
    FrsRecursoSistema.CNPJ     := '';

    if js.Field['Serial'] <> nil then
      if js.Field['Serial'].Value <> null then
        FrsRecursoSistema.Serial   := js.Field['Serial'].Value;

    if js.Field['CNPJ'] <> nil then
      if js.Field['CNPJ'].Value <> null then
        FrsRecursoSistema.CNPJ     := js.Field['CNPJ'].Value;

    if (FrsRecursoSistema.Serial <> '') and (FrsRecursoSistema.CNPJ <> '') then
    begin

      if js.Field['Usuarios'] <> nil then
        FrsRecursoSistema.Usuarios := StrToInt(VarToStrDef(js.Field['Usuarios'].Value, '0'));

      if js.Field['Produto'] <> nil then
        FrsRecursoSistema.Produto  := js.Field['Produto'].Value;

      if js.Field['Recursos'] <> nil then
      begin
        iTemRc := js.Field['Recursos'] as TlkJSONobject;

        if iTemRc.Field['LimiteUso'] <> nil then
        begin

          if iTemRc.Field['LimiteUso'] <> nil then
            FrsRecursoSistema.Recursos.LimiteUso := DataJsonToDate(iTemRc.Field['LimiteUso'].Value);

          if iTemRc.Field['OS'] <> nil then
            FrsRecursoSistema.Recursos.OS        := DataJsonToDate(iTemRc.Field['OS'].Value);

          if iTemRc.Field['Sped'] <> nil then
            FrsRecursoSistema.Recursos.Sped      := DataJsonToDate(iTemRc.Field['Sped'].Value);

          if iTemRc.Field['SpedPisCofins'] <> nil then
            FrsRecursoSistema.Recursos.SpedPisCofins := DataJsonToDate(iTemRc.Field['SpedPisCofins'].Value);

          if iTemRc.Field['Anvisa'] <> nil then
            FrsRecursoSistema.Recursos.Anvisa := DataJsonToDate(iTemRc.Field['Anvisa'].Value);

          if iTemRc.Field['Sintegra'] <> nil then
            FrsRecursoSistema.Recursos.Sintegra := DataJsonToDate(iTemRc.Field['Sintegra'].Value);

          if iTemRc.Field['Comandas'] <> nil then
            FrsRecursoSistema.Recursos.Comandas := DataJsonToDate(iTemRc.Field['Comandas'].Value);

          if iTemRc.Field['MDFE'] <> nil then
            FrsRecursoSistema.Recursos.MDFE := DataJsonToDate(iTemRc.Field['MDFE'].Value);

          if iTemRc.Field['Mobile'] <> nil then
            FrsRecursoSistema.Recursos.Mobile := DataJsonToDate(iTemRc.Field['Mobile'].Value);

          if iTemRc.Field['Etiquetas'] <> nil then
            FrsRecursoSistema.Recursos.Etiquetas := DataJsonToDate(iTemRc.Field['Etiquetas'].Value);

          if iTemRc.Field['Orcamento'] <> nil then
            FrsRecursoSistema.Recursos.Orcamento := DataJsonToDate(iTemRc.Field['Orcamento'].Value);

          if iTemRc.Field['MKP'] <> nil then
            FrsRecursoSistema.Recursos.MKP := DataJsonToDate(iTemRc.Field['MKP'].Value);

          if iTemRc.Field['ContasPagar'] <> nil then
            FrsRecursoSistema.Recursos.ContasPagar := DataJsonToDate(iTemRc.Field['ContasPagar'].Value);

          if iTemRc.Field['ContasReceber'] <> nil then
            FrsRecursoSistema.Recursos.ContasReceber := DataJsonToDate(iTemRc.Field['ContasReceber'].Value);

          if iTemRc.Field['Caixa'] <> nil then
            FrsRecursoSistema.Recursos.Caixa := DataJsonToDate(iTemRc.Field['Caixa'].Value);

          if iTemRc.Field['Bancos'] <> nil then
            FrsRecursoSistema.Recursos.Bancos := DataJsonToDate(iTemRc.Field['Bancos'].Value);

          if iTemRc.Field['Indicadores'] <> nil then
            FrsRecursoSistema.Recursos.Indicadores := DataJsonToDate(iTemRc.Field['Indicadores'].Value);

          if iTemRc.Field['InventarioP7'] <> nil then
            FrsRecursoSistema.Recursos.InventarioP7 := DataJsonToDate(iTemRc.Field['InventarioP7'].Value);

          if iTemRc.Field['QtdNFE'] <> nil then
            FrsRecursoSistema.Recursos.QtdNFE:= StrToInt(VarToStrDef(iTemRc.Field['QtdNFE'].Value, '0'));

          if iTemRc.Field['QtdNFCE'] <> nil then
            FrsRecursoSistema.Recursos.QtdNFCE := StrToInt(VarToStrDef(iTemRc.Field['QtdNFCE'].Value, '0'));

        end;

      end;

    end
    else
    begin
      FrsRecursoSistema.Usuarios := 1;
      FrsRecursoSistema.Produto  := 'Small Commerce';

      FrsRecursoSistema.Recursos.LimiteUso     := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.OS            := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Sped          := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.SpedPisCofins := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Anvisa        := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Sintegra      := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Comandas      := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.MDFE          := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Mobile        := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Etiquetas     := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Orcamento     := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.MKP           := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.ContasPagar   := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.ContasReceber := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Caixa         := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Bancos        := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.Indicadores   := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.InventarioP7  := StrToDate(sDataLimitePadrao);
      FrsRecursoSistema.Recursos.QtdNFE        := 0;
      FrsRecursoSistema.Recursos.QtdNFCE       := 0;
    end; //if (FrsRecursoSistema.Serial <> '') and (FrsRecursoSistema.CNPJ <> '') then

  end;

  if Trim(FrsRecursoSistema.Serial) = '' then
  begin
    Mais1ini := TIniFile.Create('WIND0WS.L0G');
    FrsRecursoSistema.Serial := Mais1Ini.ReadString('LICENCA','Ser','');
    Mais1ini.Free;
  end;

end;

function TValidaRecurso.SistemaSerial(): String;
begin
  Result := '';

  try

    LeRecursos;

    if Trim(FsRecurso) <> '' then
    begin
      try
        try
          //Conteudo Criptografado deve bater com dados do emitente
          if FrsRecursoSistema.CNPJ <> FsCNPJ then
            Exit;

          Result := FrsRecursoSistema.Serial;
        finally
        end;
      except
      end;
    end
    else
    begin
      Result := FrsRecursoSistema.Serial;
    end;
  except
  end;

end;

function TValidaRecurso.SistemaLimiteUsuarios(): Integer;
begin
  Result := 1;

  try

    LeRecursos;

    if Trim(FsRecurso) <> '' then
    begin
      try
        try
          if FrsRecursoSistema.CNPJ <> FsCNPJ then
            Exit;

          Result := FrsRecursoSistema.Usuarios;
        finally
        end;
      except
      end;
    end;
  except
  end;

end;

function TValidaRecurso.RecursoLiberado(sRecurso : TRecursos; out DataLimite : TDate): Boolean;
begin
  Result := False;
  DataLimite := StrToDate('01/01/1900');

  try

    LeRecursos;
    
    if Trim(FsRecurso) <> '' then
    begin
      try
        try
          //Conteudo Criptografado deve bater com dados do emitente
          if FrsRecursoSistema.CNPJ <> FsCNPJ then
            Exit;

          DataLimite := RecursoData(sRecurso) ;
          Result     := DataLimite >= Date;
        finally
        end;
      except
      end;
    end;
  except
  end;
end;

function TValidaRecurso.RecursoQuantidade(sRecurso: TRecursos): Integer;
begin
  Result := 0;

  try

    LeRecursos;
      
    if Trim(FsRecurso) <> '' then
    begin
      try
        try

          //Conteudo Criptografado deve bater com dados do emitente
          if FrsRecursoSistema.CNPJ <> FSCNPJ then
            Exit;

          Result := RecursoQtd(sRecurso) ;
        finally

        end;
      except
      end;
    end;
  except
  end;
end;

function TValidaRecurso.RecursoData(sRecurso : TRecursos): TDate;
begin
  Result := StrToDate('01/01/1900');

  try

    LeRecursos;

    case sRecurso of
      rcOS            : Result := FrsRecursoSistema.Recursos.OS;
      rcSped          : Result := FrsRecursoSistema.Recursos.Sped;
      rcSpedPisCofins : Result := FrsRecursoSistema.Recursos.SpedPisCofins;
      rcAnvisa        : Result := FrsRecursoSistema.Recursos.Anvisa;
      rcSintegra      : Result := FrsRecursoSistema.Recursos.Sintegra;
      rcComandas      : Result := FrsRecursoSistema.Recursos.Comandas;
      rcMDFE          : Result := FrsRecursoSistema.Recursos.MDFE;
      rcMobile        : Result := FrsRecursoSistema.Recursos.Mobile;
      rcEtiquetas     : Result := FrsRecursoSistema.Recursos.Etiquetas;
      rcOrcamento     : Result := FrsRecursoSistema.Recursos.Orcamento;
      rcContasPagar   : Result := FrsRecursoSistema.Recursos.ContasPagar;
      rcContasReceber : Result := FrsRecursoSistema.Recursos.ContasReceber;
      rcCaixa         : Result := FrsRecursoSistema.Recursos.Caixa;
      rcBancos        : Result := FrsRecursoSistema.Recursos.Bancos;
      rcIndicadores   : Result := FrsRecursoSistema.Recursos.Indicadores;
      rcInventarioP7  : Result := FrsRecursoSistema.Recursos.InventarioP7;
      rcMKP           : Result := FrsRecursoSistema.Recursos.MKP;
    end;
  except
  end;
end;

function TValidaRecurso.RecursoQtd(sRecurso: TRecursos): Integer;
begin
  Result := 0;

  try

    LeRecursos;

    case sRecurso of
      rcQtdNFCE    : Result := FrsRecursoSistema.Recursos.QtdNFCE;
      rcQtdNFE     : Result := FrsRecursoSistema.Recursos.QtdNFE;
    end;
  except
  end;
end;

procedure TValidaRecurso.InformacoesBD();
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  function LimpaNumero(pP1:String):String;
  var
     I:Integer;
  begin
     Result:='';
     for I := 1 to length(pP1) do
     begin
       if Pos(Copy(pP1,I,1),'0123456789') > 0 then
          Result := Result+Copy(pP1,I,1);
     end;
  end;
begin
  try
    trAux := CriaIBTransaction(FIBDatabase);
    qyAux := CriaIBQuery(trAux);

    if CampoExisteFB(FIBDatabase, 'EMITENTE', 'RECURSO') then
    begin
      try
        if CampoExisteFB(FIBDatabase, 'EMITENTE', 'RECURSO') then
        begin
          //qyAux.Database := FIBDatabase;
          qyAux.SQL.Text := 'Select CGC, RECURSO from EMITENTE';
          qyAux.Open;

          FsRecurso := qyAux.FieldByName('RECURSO').AsString;
          FsCNPJ   := LimpaNumero(qyAux.FieldByName('CGC').AsString);
        end;
      except
        FsRecurso := '';
        FsCNPJ   := '';
      end;
    end;
  finally
    FreeAndNil(qyAux);
    FreeAndNil(trAux);
  end;
end;

constructor TValidaRecurso.Create;
begin
  inherited;

end;

destructor TValidaRecurso.Destroy;
begin

  inherited;
end;

procedure TValidaRecurso.SetIBDatabase(const Value: TIBDatabase);
begin
  FIBDatabase := Value;
  if FIBDatabase <> nil then
  begin
    LeRecursos;
  end;
end;

function TValidaRecurso.CampoExisteFB(Banco: TIBDatabase; sTabela,
  sCampo: String): Boolean;
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
                        ' Select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
                        ' From RDB$RELATION_FIELDS F ' +
                        '   Join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
                        '     and R.RDB$VIEW_BLR is null ' +
                        '     and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
                        '     and F.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
                        '     and F.RDB$FIELD_NAME = ' + QuotedStr(sCampo);
    IBQUERY.Open;
    Result := (IBQUERY.IsEmpty = False);
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function TValidaRecurso.CriaIBQuery(
  IBTRANSACTION: TIBTransaction): TIBQuery;
begin
  Result := nil;
  try
    Result := TIBQuery.Create(nil);
    Result.Database    := IBTRANSACTION.DefaultDatabase;
    Result.Transaction := IBTRANSACTION;
    if Result.Transaction.Active = False then // 2013-10-15 Evitar invalid transaction handle (expecting explicit transaction start)
      Result.Transaction.Active := True;
  except
    on E: Exception do
    begin
      //2013-09-27 ShowMessage(E.Message);
    end
  end;
end;

function TValidaRecurso.CriaIBTransaction(
  IBDatabase: TIBDatabase): TIBTransaction;
begin
  Result := nil;
  try
    Result := TIBTransaction.Create(nil);
    Result.Params.Add('read_committed');
    Result.Params.Add('rec_version');
    Result.Params.Add('nowait');
    Result.DefaultDatabase := IBDatabase;
    Result.Active := True;  // 2013-10-15 Evitar invalid transaction handle (expecting explicit transaction start)
  except
    on E: Exception do
    begin
      //2013-09-27 ShowMessage(E.Message);
    end
  end;
end;

function TValidaRecurso.PermiteRecursoParaProduto: Boolean;
begin
  Result := True;

  LeRecursos;
    
  //if (Copy(FrsRecursoSistema.Serial, 4, 1) = 'T') or (FrsRecursoSistema.CNPJ = '') then // Sandro Silva 2023-06-01 if (Copy(FrsRecursoSistema.Serial, 4, 1) = 'T') then
  if (Trim(FrsRecursoSistema.Produto) = '')
   or (AnsiContainsText(Trim(FrsRecursoSistema.Produto), ' Go'))
   or (Trim(FrsRecursoSistema.CNPJ) = '') then 
    Result := False;
end;

function TValidaRecurso.ValidaQtdDocumentoFrente: Boolean;
const SituacaoSatEmitidoOuCancelado  = ' (MODELO = ''59'' and coalesce(NFEXML, '''') containing ''Id="'' and coalesce(NFEXML, '''') containing ''versao="'' and coalesce(NFEXML, '''') containing ''<SignatureValue>'' and coalesce(NFEXML, '''') containing ''<DigestValue>'') ' ;
//const SituacaoNFCeEmitidoOuCancelado = ' (MODELO = ''65'' and coalesce(NFEXML, '''') containing ''<xMotivo>'' and coalesce(NFEIDSUBSTITUTO, '''') = '''' ) ';
const SituacaoNFCeEmitidoOuCancelado = ' (MODELO = ''65'' and ((coalesce(NFEXML, '''') containing ''<xMotivo>'' and coalesce(NFEIDSUBSTITUTO, '''') = '''') or (coalesce(NFEXML, '''') containing ''<tpEmis>9'') or (coalesce(STATUS, '''') containing ''NFC-e emitida em modo de contingência'') )) ';
const SituacaoMEIEmitidoOuCancelado  = ' (MODELO = ''99'' and (coalesce(STATUS, '''') containing ''Finalizada'' or coalesce(STATUS, '''') containing ''Cancelada'')) ';
var
  iQtdEmitido: Integer;
  iQtdPermitido: Integer;
  IBQDOC: TIBQuery;
  dtDataServidor: TDate;
  IBTRANSACTION: TIBTransaction;
begin
  Result := False;

  LeRecursos;  

  iQtdPermitido := FrsRecursoSistema.Recursos.QtdNFCE;

//  Result := False;

  if iQtdPermitido = -1 then
  begin
    Result := True;
  end
  else
  begin
    IBTRANSACTION := CriaIBTransaction(FIBDatabase);

    IBQDOC := CriaIBQuery(IBTRANSACTION);

    IBQDOC.Close;
    IBQDOC.SQL.Text := 'select current_date as DATAATUAL from RDB$DATABASE';
    IBQDOC.Open;
    dtDataServidor := IBQDOC.FieldByName('DATAATUAL').AsDateTime;

    IBQDOC.Close;
    IBQDOC.SQL.Text :=
      'select count(NUMERONF) as DOCUMENTOSEMITIDOS ' +
      'from NFCE ' +
      'where DATA >= :INI  ' + 
      'and ( ' + SituacaoSatEmitidoOuCancelado + '  or ' + SituacaoNFCeEmitidoOuCancelado + '  or ' + SituacaoMEIEmitidoOuCancelado + ' )';
    IBQDOC.ParamByName('INI').AsString := '01' + FormatDateTime('/mm/yyyy', dtDataServidor);
    IBQDOC.Open;

    iQtdEmitido := IBQDOC.FieldByName('DOCUMENTOSEMITIDOS').AsInteger;

    IBQDOC.Close;

    try
      FreeAndNil(IBQDOC);
      FreeAndNil(IBTRANSACTION);
    except
    end;

    if (iQtdPermitido - iQtdEmitido) > 0 then
      Result := True;

  end;

end;

function TValidaRecurso.ValidaQtdDocumentoRetaguarda: Boolean;
const SituacaoMeiLancado = ' (MODELO = ''01'') ';
const SituacaoNFeEmitidoOuCancelado = ' (MODELO = ''55'' and coalesce(NFEXML, '''') containing ''<xMotivo>'') ';
const SituacaoNFSeEmitidoOuCancelado  = ' (MODELO = ''SV'' and (coalesce(STATUS, '''') containing ''AUTORIZADA'' or coalesce(STATUS, '''') containing ''NFS-e cancelada'')) ';
var
  iQtdEmitido: Integer;
  iQtdPermitido: Integer;
  IBQDOC: TIBQuery;
  dtDataServidor: TDate;
  IBTRANSACTION: TIBTransaction;
begin
  Result := False;

  LeRecursos;

  iQtdPermitido := FrsRecursoSistema.Recursos.QtdNFE;

  Result := False;

  if iQtdPermitido = -1 then
  begin
    Result := True;
  end
  else
  begin
    IBTRANSACTION := CriaIBTransaction(FIBDatabase);

    IBQDOC := CriaIBQuery(IBTRANSACTION);

    IBQDOC.Close;
    IBQDOC.SQL.Text := 'select current_date as DATAATUAL from RDB$DATABASE';
    IBQDOC.Open;
    dtDataServidor := IBQDOC.FieldByName('DATAATUAL').AsDateTime;

    IBQDOC.Close;
    IBQDOC.SQL.Text :=
      'select count(NUMERONF) as DOCUMENTOSEMITIDOS ' +
      'from VENDAS ' +
      'where EMISSAO >= :INI  ' + // Sandro Silva 2023-05-30'where DATA between :INI and :FIM ' +
      'and ( ' + SituacaoMeiLancado + '  or ' + SituacaoNFeEmitidoOuCancelado + '  or ' + SituacaoNFSeEmitidoOuCancelado + ' )';
    IBQDOC.ParamByName('INI').AsString := '01' + FormatDateTime('/mm/yyyy', dtDataServidor);
    //IBQDOC.ParamByName('FIM').AsString := FormatFloat('00', DaysInAMonth(YearOf(dtDataServidor), MonthOf(dtDataServidor))) + FormatDateTime('/mm/yyyy', dtDataServidor);
    IBQDOC.Open;

    iQtdEmitido := IBQDOC.FieldByName('DOCUMENTOSEMITIDOS').AsInteger;

    IBQDOC.Close;

    try
      FreeAndNil(IBQDOC);
      FreeAndNil(IBTRANSACTION);
    except
    end;

    //if (iQtdEmitido >= 1) and (iQtdEmitido <= iQtdPermitido) then
    if (iQtdPermitido - iQtdEmitido) > 0 then
      Result := True;

  end;


end;

end.
