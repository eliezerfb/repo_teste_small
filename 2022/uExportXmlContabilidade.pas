unit uExportXmlContabilidade;

interface

uses
  SysUtils
  , StrUtils
  , Controls
  , Windows
  , IniFiles
  , ShellApi
  , Forms
  , Dialogs
  , IBDatabase
  , IBQuery
  , Classes
  , uFuncoesBancoDados
  ;

procedure ExportaXmlParaAContabilidade;
function DistribuicaoDFe6559(dtDataI: TDate; dtDataF: TDate; Diretorio: String;
  IBTRANSACTION: TIBTransaction): Boolean;

implementation

uses Mais, Unit7, Unit28, Smallfunc;

procedure ExportaXmlParaAContabilidade;
var
  bTem   : Boolean;
  sEmail  : string;
  Mais1Ini : tIniFile;
  SearchRec : tSearchREC;
  Encontrou  : Integer;
begin
  //
  // Form só para pedir o período e o e-mail do contador.
  //
  Form28.ShowModal;
  //
  if Form28.DateTimePicker1.Date <> StrToDate('01/01/1998') then
  begin
    //
    if ValidaEmail(Form28.Edit1.Text) then
    begin
      //
      Form7.Close;
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
      Mais1Ini.WriteString('XML','e-mail contabilidade',AllTrim(Form28.Edit1.Text));
      Mais1Ini.WriteString('XML','Periodo Inicial',DateToStr(Form28.DateTimePicker1.Date));
      Mais1Ini.WriteString('XML','Periodo Final',DateToStr(Form28.DateTimePicker2.Date));
      Mais1ini.Free;
      //



      Form7.ibDataSet15.Close;
      Form7.ibDataSet15.SelectSql.Clear;
//
//      Form7.ibDataSet15.Selectsql.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker2.Date))+
//      ' and EMISSAO>='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker1.Date))+' and coalesce(NFERECIBO,'''')<>'''' order by EMISSAO, NUMERONF');
//      Form7.ibDataset15.Open;
//
      //
      Form7.ibDataSet15.Selectsql.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker2.Date))+
      ' and EMISSAO>='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker1.Date))+' order by EMISSAO, NUMERONF');
      //
      Form7.ibDataset15.Open;
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
      sEmail := Alltrim(Mais1Ini.ReadString('XML','e-mail contabilidade',''));
      Mais1ini.Free;
      //
      // Apaga todos os arquivos .XML da pasta CONTABIL
      //
      FindFirst(Form1.sAtual+'\CONTABIL\*.xml', faAnyFile, SearchRec);
      Encontrou :=0;
      while Encontrou = 0 do
      begin
        DeleteFile(pChar(Form1.sAtual+'\CONTABIL\'+Searchrec.Name));
        Encontrou := FindNext(SearchRec);
      end;
      //
      bTem := False;
      //
      // NFE e CANCELADAS
      //
      Form7.ibDataSet15.First;
      while not Form7.ibDataSet15.Eof do
      begin
        DistribuicaoNFe('CONTABIL');
        Form7.ibDataSet15.Next;
        bTem := True;
      end;
      //
      // INUTILIZADAS
      //
      Form7.IBQuery99.Close;
      Form7.IBQuery99.SQL.Clear;
      Form7.IBQuery99.SQL.Add('select XML, DATA, REGISTRO from INUTILIZACAO where MODELO = ''55'' and DATA<='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker2.Date))+
      ' and DATA>='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker1.Date))+' order by DATA');
      Form7.IBQuery99.Open;
      //
      Form7.IBQuery99.First;
      while not Form7.IBQuery99.Eof do
      begin
        DistribuicaoNFeINUTILIZADA('CONTABIL');
        Form7.IBQuery99.Next;
        bTem := True;
      end;

      //
      // NFC-e/SAT
      //

      DistribuicaoDFe6559(Form28.DateTimePicker1.Date, Form28.DateTimePicker2.Date, Form1.sAtual + '\CONTABIL', Form7.ibDataSet15.Transaction);

      //
      // COMPRAS
      //

      Form7.ibDataSet24.Close;
      Form7.ibDataSet24.SelectSql.Clear;
      //
      Form7.ibDataSet24.Selectsql.Add('select * from COMPRAS where EMISSAO<='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker2.Date))+
      ' and EMISSAO>='+QuotedStr(DateToStrInvertida(Form28.DateTimePicker1.Date))+' order by EMISSAO, NUMERONF');
      //
      Form7.ibDataSet24.Open;
      {// Sandro Silva 2023-10-06
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
      sEmail := Alltrim(Mais1Ini.ReadString('XML','e-mail contabilidade',''));
      Mais1ini.Free;
      //
      // Apaga todos os arquivos .XML da pasta CONTABIL
      //
      FindFirst(Form1.sAtual+'\CONTABIL\*.xml', faAnyFile, SearchRec);
      Encontrou :=0;
      while Encontrou = 0 do
      begin
        DeleteFile(pChar(Form1.sAtual+'\CONTABIL\'+Searchrec.Name));
        Encontrou := FindNext(SearchRec);
      end;
      }

      Form7.ibDataSet24.First;
      while not Form7.ibDataSet24.Eof do
      begin
        if DistribuicaoNFeCompra('CONTABIL') then
          bTem   := True;
        Form7.ibDataSet24.Next;
      end;

      if bTem then
      begin
        //
        // Apaga o ZIP anterior
        //
        while FileExists(pChar(Form1.sAtual + '\CONTABIL\'+ LimpaNumero(Form7.ibDataSet13CGC.AsString) + '_'+StrTRan(DateToStr(date),'/','_')+'.zip')) do
        begin
          DeleteFile(pChar(Form1.sAtual + '\CONTABIL\'+ LimpaNumero(Form7.ibDataSet13CGC.AsString) + '_'+StrTRan(DateToStr(date),'/','_')+'.zip'));
          Sleep(1000);
        end;
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\CONTABIL\*.xml')+'" "'+Alltrim(Form1.sAtual + '\CONTABIL\'+ LimpaNumero(Form7.ibDataSet13CGC.AsString) + '_'+StrTRan(DateToStr(date),'/','_')+'.zip')+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          Application.ProcessMessages;
          sleep(100);
        end;
        //
        while not FileExists(pChar(Form1.sAtual+'\CONTABIL\'+ LimpaNumero(Form7.ibDataSet13CGC.AsString) + '_'+StrTRan(DateToStr(date),'/','_')+'.zip')) do
        begin
          sleep(100);
        end;
        //
        // Apaga todos os arquivos .XML da pasta CONTABIL
        //
        FindFirst(Form1.sAtual+'\CONTABIL\*.xml', faAnyFile, SearchRec);
        Encontrou :=0;
        while Encontrou = 0 do
        begin
          DeleteFile(pChar(Form1.sAtual+'\CONTABIL\'+Searchrec.Name));
          Encontrou := FindNext(SearchRec);
        end;
        //
        Unit7.EnviarEMail('',Form28.Edit1.Text,'','NF-e´s (Notas Fiscais Eletrônicas)',
          pchar('Segue em anexo arquivo zipado com as NF-e´s de saída da empresa '+AllTrim(Form7.ibDataSet13NOME.AsString)+'.'
          +' Período de '+DateToStr(Form28.DateTimePicker1.Date)+' até '+DateToStr(Form28.DateTimePicker2.Date)+'.'
          +chr(10)
          +Form1.sPropaganda)
          ,pChar(Form1.sAtual + '\CONTABIL\'+ LimpaNumero(Form7.ibDataSet13CGC.AsString) + '_'+StrTRan(DateToStr(date),'/','_')+'.zip'),False);
        //
      end else
      begin
        ShowMessage('Não encontrado XML para contabilidade neste período.');
      end;
    end;
  end;
  //
  try
    Form7.Close;
    Form7.ShowModal;
  except end;  
  //

end;

function DistribuicaoDFe6559(dtDataI: TDate; dtDataF: TDate; Diretorio: String;
  IBTRANSACTION: TIBTransaction): Boolean;
// Sandro Silva 2021-01-28 Exporta xml de NFC-e/SAT e Inutilização de NFC-e
var
  IBQDFE: TIBQuery;
  SearchRec: tSearchREC;
  Encontrou : Integer;
  bTemCFeSAT: Boolean;
  F : TExtfile;
  fNFe : String;
  sFileExporta: String;
  function TamanhoArquivo(Arquivo: string): Integer;
  begin
    with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
    try
      Result := Size;
    finally
     Free;
    end;
  end;
begin
  IBQDFE := CriaIBQuery(IBTRANSACTION);
  Result := True;
  try

    ForceDirectories(Diretorio);
    {// Sandro Silva 2023-10-06
    //
    // Apaga todos os arquivos .XML da pasta CONTABIL
    //
    FindFirst(Diretorio + '\*.xml', faAnyFile, SearchRec);
    Encontrou := 0;
    while Encontrou = 0 do
    begin
      DeleteFile(pChar(Diretorio + '\'+Searchrec.Name));
      Encontrou := FindNext(SearchRec);
    end;
    }
    // Seleciona NFC-e e SAT
    IBQDFE.DisableControls;
    IBQDFE.Close;
    IBQDFE.SQL.Text :=
      'select * ' +
      'from NFCE ' +
      'where DATA between '+QuotedStr(DateToStrInvertida(dtDataI))+ ' and '+QuotedStr(DateToStrInvertida(dtDataF))+
      ' and coalesce(NFEXML,'''')<>'''' ' +
      ' and (STATUS containing ''Autoriza'' or STATUS containing ''Cancel'' or STATUS containing ''conting'' or STATUS containing ''Sucesso'') ' +
      ' order by DATA, NFEID';
    IBQDFE.Open;

    bTemCFeSAT := False;
    IBQDFE.First;

    while not IBQDFE.Eof do
    begin

      sFileExporta := '';

      if bTemCFeSAT = False then // Para agilizar o processamento. Depois que identificou existência de CF-e-SAT não precisa processar os demais xml
      begin
        if AnsiContainsText(IBQDFE.FieldByName('NFEXML').AsString, '<mod>59</mod>') then // Sandro Silva 2020-08-24 if (xmlNodeValue(Form1.ibDataSet150.FieldByName('NFEXML').AsString, '//ide/mod') = '59') then
          bTemCFeSAT := True;
      end;

      if ((Pos('<nfeProc',IBQDFE.FieldByName('NFEXML').AsString) <> 0) // NFC-e emitida
          or ((Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0)) // NFC-e cancelada
         )
        or ((xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//infCFe/@Id') <> '')  //CF-e-SAT de venda com ID
            and (xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//Signature/SignatureValue') <> '')  //CF-e-SAT assinado
           )
        then
      begin
        try
          // ------------------------------------------ //
          // Cria um diretório com uma cópias dos dados //
          // ------------------------------------------ //
          //ForceDirectories(Diretorio);
          fNFe := IBQDFE.FieldByName('NFEXML').AsString;
          // Componente NFCe está gerando os xml com 'ï»¿' no início do arquivo e causa erro ao exportar para contabilidade
          fNFe := StringReplace(fNFe, 'ï»¿','', [rfReplaceAll]); // Sandro Silva 2016-03-21

          if (Copy(xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//chNFe'), 21, 2) = '65') then  // Assim para identificar xml de cancelamento de NFC-e
          begin
            sFileExporta := PansiChar(Diretorio+'\'+IBQDFE.FieldByName('NFEID').AsString+'-nfce.xml');  // Direciona o arquivo F para EXPORTA.TXT
            if (Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0) then
              sFileExporta := PansiChar(Diretorio+'\'+IBQDFE.FieldByName('NFEID').AsString+'-caneve.xml');  // Direciona o arquivo F para EXPORTA.TXT
          end;
          if (xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//ide/mod') = '59') then
          begin
            sFileExporta := PansiChar(Diretorio+'\AD'+IBQDFE.FieldByName('NFEID').AsString+'.xml');  // Direciona o arquivo F para EXPORTA.TXT
            if (Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0) then
              sFileExporta := PansiChar(Diretorio+'\ADC'+IBQDFE.FieldByName('NFEID').AsString+'.xml');  // Direciona o arquivo F para EXPORTA.TXT
          end;

          //
        except
          Result := False;
        end;

      end;

      if Trim(sFileExporta) <> '' then
      begin
        AssignFile(F,PansiChar(Trim(sFileExporta)));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);                  // Abre para gravação
        WriteLn(F,fNFe);
        CloseFile(F); // Fecha o arquivo
      end;

      IBQDFE.Next;
    end;

    // Seleciona NFC-e inutilizadas
    IBQDFE.DisableControls;
    IBQDFE.Close;
    IBQDFE.SQL.Text :=
      'select XML ' +
      'from INUTILIZACAO ' +
      'where DATA between '+QuotedStr(DateToStrInvertida(dtDataI))+ ' and '+QuotedStr(DateToStrInvertida(dtDataF))+
      ' and coalesce(XML,'''')<>'''' ' +
      ' and MODELO = ''65'' ' +
      ' order by DATA, NPROT';
    IBQDFE.Open;

    IBQDFE.First;

    while not IBQDFE.Eof do
    begin

      sFileExporta := '';

      if (Pos('<nProt>',IBQDFE.FieldByName('XML').AsString) <> 0) then // NFC-e Inutilizada
      begin
        try
          // ------------------------------------------ //
          // Cria um diretório com uma cópias dos dados //
          // ------------------------------------------ //
          //ForceDirectories(Diretorio);
          
          fNFe := IBQDFE.FieldByName('XML').AsString;
          // Componente NFCe está gerando os xml com 'ï»¿' no início do arquivo e causa erro ao exportar para contabilidade
          fNFe := StringReplace(fNFe, 'ï»¿','', [rfReplaceAll]); // Sandro Silva 2016-03-21

          sFileExporta := PansiChar(Diretorio+'\'+
            xmlNodeValue(fNFe, '//cUF') +
            xmlNodeValue(fNFe, '//ano') +
            xmlNodeValue(fNFe, '//CNPJ') +
            xmlNodeValue(fNFe, '//mod') +
            RightStr('000' + xmlNodeValue(fNFe, '//serie'), 3) +
            RightStr('000000000' + xmlNodeValue(fNFe, '//nNFIni'), 9) +
            RightStr('000000000' + xmlNodeValue(fNFe, '//nNFFin'), 9) +
            '-inut.xml');  // Direciona o arquivo F para EXPORTA.TXT

          //
        except
          Result := False;
        end;

      end;

      if Trim(sFileExporta) <> '' then
      begin
        AssignFile(F,PansiChar(Trim(sFileExporta)));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);                  // Abre para gravação
        WriteLn(F,fNFe);
        CloseFile(F); // Fecha o arquivo
      end;

      IBQDFE.Next;
    end;

  except
    Result := False;
  end;

  FreeAndNil(IBQDFE);
end;


end.
