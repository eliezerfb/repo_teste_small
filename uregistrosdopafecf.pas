unit uregistrosdopafecf;

interface

uses
  Controls
  , IniFiles
  , Classes
  , StrUtils
  , SysUtils
  , IBQuery
  , DBClient
  , DB
  , Forms
  ;

procedure RegistrosDoPafEcfEstoquetotal;
procedure RegistrosDoPafEstoqueparcial;

implementation

uses
  SmallFunc
  , ufuncoesfrente
  , fiscal
  , unit7
  , unit22
  , urequisitospafnfce
  ;

procedure RegistrosDoPafEcfEstoquetotal;
const SELECT_ECF =
  'select distinct R1.SERIE ' +
  ',(select first 1 R3.PDV from REDUCOES R3 where R3.SERIE = R1.SERIE and coalesce(R3.PDV, ''XX'') <> ''XX'' order by R3.REGISTRO desc) as PDV ' +
  ',(select first 1 R4.MODELOECF from REDUCOES R4 where R4.SERIE = R1.SERIE order by R4.REGISTRO desc) as MODELOECF ' +
  'from REDUCOES R1 ' +
  ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' and R1.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' ' +
  ' and coalesce(R1.SERIE, ''XX'') <> ''XX'' ' +
  ' and coalesce(R1.PDV, ''XX'') <> ''XX'' ' +
  ' group by R1.SERIE ' +
  'order by PDV';

  type
    TJ1 = record
      Tipo: String; // "J1"
      CNPJEmissor: String; // CNPJ do emissor do Documento Fiscal
      DataEmissao: TDate; // Data de emissão do documento fiscal
      SubTotal: Currency; // Valor total do documento, com duas casas decimais.
      DescontoSubTotal: Currency; // Valor do desconto ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
      IndicadorTipoDesconto: String; // Informar “V” para valor monetário ou “P” para percentual
      AcrescimoSubTotal: Currency; // Valor do acréscimo ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
      IndicadorTipoAcrescimo: String; // Informar “V” para valor monetário ou “P” para percentual
      ValorTotalLiquido: Currency; // Valor total do Cupom Fiscal após desconto/acréscimo, com duas casas decimais.
      IndicadorCancelamento: String; // Informar "S" ou "N", conforme tenha ocorrido ou não, o cancelamento do documento.
      CancelamentoAcrescimoSubtotal: Currency; // Valor do cancelamento de acréscimo no subtotal
      OrdemAplicacaoDescAcres: String; // Indicador de ordem de aplicação de desconto/acréscimo em Subtotal. ‘D’ ou ‘A’ caso tenha ocorrido primeiro desconto ou acréscimo, respectivamente
      NomeAdquirente: String; // Nome do Cliente
      CPFCNPJAdquirente: String; // CPF ou CNPJ do adquirente
      NumeroNF: String; // Número da Nota Fiscal, manual ou eletrônica
      SerieNF: String; // Série da Nota Fiscal, manual ou eletrônica
      SubSerie: String;
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletrônica
      TipoDocumento: String; // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
      Evidencia: String; // Controlar se está evidenciado
    end;
    
    TJ2 = record
      Tipo: String; // J2
      CNPJEmissor: String; // CNPJ do emissor do Documento Fiscal
      DataEmissao: TDate; // Data de emissão do documento fiscal
      NumeroItem: String; // Número do item registrado no documento
      CodigoProduto: String; // Código do produto ou serviço registrado no documento.
      Descricao: String; // Descrição do produto ou serviço constante no Cupom Fiscal
      Quantidade: Double; // Quantidade comercializada, sem a separação das casas decimais
      Unidade: String; // Unidade de medida
      ValorUnitario: Currency; // Valor unitário do produto ou serviço, sem a separação das casas decimais.
      DescontoItem: Currency; // Valor do desconto incidente sobre o valor do item, com duas casas decimais.
      AcrescimoItem: Currency; // Valor do acréscimo incidente sobre o valor do item, com duas casas decimais.
      ValorTotalLiquido: Currency; // Valor total líquido do item, com duas casas decimais.
      TotalizadorParcial: String; // Código do totalizador relativo ao produto ou serviço conforme tabela abaixo.
      CasasDecimaisQuantidade: String; // Parâmetro de número de casas decimais da quantidade
      CasasDecimaisValorUnitario: String; // Parâmetro de número de casas decimais de valor unitário
      NumeroNF: String; // Número da Nota Fiscal, manual ou eletrônica
      SerieNF: String; // Série da Nota Fiscal, manual ou eletrônica
      SubSerie: String;
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletrônica
      TipoDocumento: String; // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
      Evidencia: String; // Controlar se está evidenciado      
    end;

    TA2 = record
      Data: TDate;
      CodigoForma: String;
      Forma: String;
      TipoDocumento: String;
      Valor: Double;
      Evidencia: String;
    end;

var
  //
  Mais1Ini : tIniFile;
  NumRead, I : Integer;
  sTexto: String;
  Buf: array[1..524288] of Char;
  //
  sMensuracao, sUnd : String;
  F : TextFile;
  FNovo : file;
  sCodigo : String;
  sDataUltimaZ, sModelo_ECF, sSituacaoTributaria, sAliquota, sEvidenciaA2, sEvidenciaReducoes, sEvidencia, sEvidenciaDeExclusao : String;
  rDesconto, rAcrescimo : Real;
  dDescontoItem: Double; // 2015-09-19
  dItemCancelado: Double; // 2015-11-05
  sDescricaoItem: String; // 2015-09-19
  sTabela, sCancel : String;
  fQTD_CANCEL, fVAL_CANCEL : Real;
  sPDV, sStituacao : String;
  sDATASB: String;
  //IBQREQUISITO: TIBQuery;
  sAliqISSQN: String;
  IBQECF: TIBQuery;
  IBQECFISCAL: TIBQuery;
  //IBQCOMPOSTO:  TIBQuery;
  IBQALIQUOTASR05: TIBQuery; // Sandro Silva 2019-05-03

  IBQVENDAS: TIBQuery;
  IBQCOMPRAS: TIBQuery;
  IBQFABRICA: TIBQuery;
  IBQBALCAO: TIBQuery;
  IBQRESERVA: TIBQuery;
  IBQR03: TIBQuery; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR04: TIBQuery; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR06: TIBQuery; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR07: TIBQuery; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco

  sECFSerie: String;
  sDataPrimeiro: String;
  sHoraPrimeiro: String;
  sGRG: String;
  sCDC: String;
  sGNF: String;
  sR03DataReducao: String;
  sTipoDocumentoPAF: String;
  sEvidenciaP2: String; // Sandro Silva 2016-03-08 POLIMIG
  sEvidenciaR01: String;
  sEcfEvidenciado: String;
  sDTMoviReducao: String;
  sEcfReducao: String;
  sEvidenciaS2: String;
  sEvidenciaS2Ecf: String; // Sandro Silva 2016-03-08 POLIMIG
  sEvidenciaS3: String; // Sandro Silva 2016-03-08 POLIMIG
  sEvidenciaR02: String; // Sandro Silva 2016-03-08 POLIMIG
  dEstorno: Double; // Sandro Silva 2016-03-01
  dEstornoCancelado: Double; // Sandro Silva 2017-11-08 Polimig
  sTipoAcrescimo: String;
  sTipoDesconto: String;
  sDescontoOuAcrescimo: String;
  bGerarRegistro: Boolean;
  dtImpressao: TDate;
  dtMicro: TDate;

  sChaveAcessoDocumento: String;
  sNumeroNF: String;
  sSerieNF: String;
  aJ1: array of TJ1;
  iJ1: Integer;
  bJ1: Boolean;
  iJ1Posicao: Integer;

  aJ2: array of TJ2;
  iJ2: Integer;
  bJ2: Boolean;
  iJ2Posicao: Integer;

  aA2: array of TA2;
  iA2: Integer;
  bA2: Boolean;
  iA2Posicao: Integer;

  dVenda: Double;
  dCompra: Double;
  dAltera: Double;
  dBalcao: Double;
  dRese: Double;
  dQtd: Double;
  sQtd: String;

  //iEstoqueDia: Integer;
  slArq: TStringList;
  sArqEstoqueAtual: String;

  sDataEmissaoRZR2: String; // Sandro Silva 2017-10-05
  sHoraEmissaoRZR2: String; // Sandro Silva 2017-10-05

  sFormaR07: String; // Sandro Silva 2017-11-07 Polimig
  dA2Cancelado: Double; // Sandro Silva 2017-11-09 Polimig
  dA2CupomImporta: Double; // Sandro Silva 2017-11-09 Polimig
  dA2Reclassifica: Double; // Sandro Silva 2017-11-09 Polimig
  dA2Total: Double;// Sandro Silva 2017-11-09 Polimig
  dA2Descontar: Double; // Sandro Silva 2019-09-09 ER 02.06 UnoChapeco

  dR03Acrescimo: Double; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  dR03OPNF: Double; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco

  dS2Total: Double; // Sandro Silva 2017-11-09 Polimig
  sR05CasasQtd: String; // Sandro Silva 2017-11-09 Polimig
  sR05Quantidade: String; // Sandro Silva 2017-11-09 Polimig
  dR05Total: Double; // Sandro Silva 2017-11-09 Polimig
  sR05AlteracaCOO: String; // Sandro Silva 2018-02-08 
  dR04SubTotal: Currency;// Double; // Sandro Silva 2017-11-09 Polimig
  dR04TotalLiquido: Currency; // Sandro Silva 2018-06-14
  sS2Conta: String; // Sandro Silva 2017-11-09 Polimig
  sJ2Quantidade: String; // Sandro Silva 2017-11-09 Polimig
  sA2Forma: String; // Sandro Silva 2017-11-10 Polimig
  sMarcaE3: String; // Sandro Silva 2017-11-10 Polimig
  sModeloEcfE3: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017
  sNumeroSerieEcfE3: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017
  sTipoECFE3: String; // Sandro Silva 2017-11-28 Polimig
  sMarcaR01: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017
  sTipoECFR01: String; // Sandro Silva 2017-11-28 Polimig
  sModeloECFR01: String; // Sandro Silva 2017-11-28 Polimig
  sSequencialR01: String; // Sandro Silva 2017-11-28 Polimig
  sCRZR01: String; // Sandro Silva 2017-11-28 Polimig
  sMarcaE3Evidenciado: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017
  sModeloE3Evidenciado: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017
  sRPModeloECF: String; // Sandro Silva 2017-11-13  HOMOLOGA 2017 Estava conflitando com variável pública sModeloECF
  sEmitenteEvidenciado: String; // Sandro Silva 2017-11-28 Polimig
  sCRZEvidenciadoR02: String; // Sandro Silva 2017-11-28 Polimig
  CDSPRIMEIRAIMPRESSAO: TClientDataSet;
  sDadosItemE2: String; // Sandro Silva 2019-09-13 ER 02.06 UnoChapeco
  sHashItemE2: String; // Sandro Silva 2019-09-13 ER 02.06 UnoChapeco
  sA2FiltroCaixa: String; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  sMarcaR03Acrescimo: String; // Sandro Silva 2022-12-03 Unochapeco
  sMarcaR03OPNF: String; // Sandro Silva 2022-12-03 Unochapeco
  //

  function LimpaNomeForma(sForma: String): String;
  begin
    sForma := ConverteAcentos(Copy(sForma, 4, 25));
    Result := sForma;
    if AnsiContainsText(sForma, 'Dinheiro') then
      Result := 'Dinheiro';
    if AnsiContainsText(sForma, 'Prazo') then
      Result := 'Prazo';
    if AnsiContainsText(sForma, 'Cartao') and AnsiContainsText(sForma, 'Credito') then
      Result := 'Cartao Credito';
    if AnsiContainsText(sForma, 'Cartao') and AnsiContainsText(sForma, 'Debito') then
      Result := 'Cartao Debito';
  end;

  procedure AdicionaImpressao(sSerieEcf: String; dtDataImpressao: TDate;
    sHoraImpressao: String);
  begin
    if sSerieEcf <> '' then
    begin
      CDSPRIMEIRAIMPRESSAO.Append;
      CDSPRIMEIRAIMPRESSAO.FieldByName('SERIEECF').AsString := sSerieEcf;
      CDSPRIMEIRAIMPRESSAO.FieldByName('DATA').AsDateTime   := dtDataImpressao;
      CDSPRIMEIRAIMPRESSAO.FieldByName('HORA').AsString     := sHoraImpressao;
      CDSPRIMEIRAIMPRESSAO.FieldByName('DATAHORA').AsString := FormatDateTime('dd/mm/yyyy', dtDataImpressao)+ ' ' + sHoraImpressao;
      CDSPRIMEIRAIMPRESSAO.Post;
    end;
  end;

  procedure CarregaEstoqueDoDia(sData: String);
  // sData deve ser passado no formato dd/mm/yyyy
  var
    iEstoqueDia: Integer;
    I: Integer;
  begin
    ListaDeArquivos(slArq, pchar(Form1.sAtualOnLine + '\estoquedia\'), '*.dia');

    sArqEstoqueAtual := '';

    slArq.Sort;
    if slArq.Count > 0 then
    begin
      sData := FormatDateTime('yyyymmdd', StrToDate(sData));
      for iEstoqueDia := 0 to slArq.Count -1 do
      begin
        if slArq.Count > 1 then
        begin
          if AnsiUpperCase(ExtractFileName(slArq.Strings[iEstoqueDia])) = AnsiUpperCase(sData + '.dia') then
          begin
            sArqEstoqueAtual := ExtractFileName(slArq.Strings[iEstoqueDia]);
            Break;
          end;
        end
        else
          sArqEstoqueAtual := ExtractFileName(slArq.Strings[slArq.Count - 1]);
      end;
    end;

    if sArqEstoqueAtual <> '' then
    begin
      if FileExists(Form1.sAtualOnLine + '\estoquedia\' + sArqEstoqueAtual) then
      begin
        //
        AssignFile(FNovo, Form1.sAtualOnLine + '\estoquedia\' + sArqEstoqueAtual);
        Reset(FNovo, 1);
        sTexto := '';
        //
        for I := 1 to (Filesize(FNovo) div 524288)+1 do
        begin
          BlockRead(FNovo, Buf, 524288, NumRead);
          sTexto := sTexto + Copy(Buf,1,NumRead);
        end;
        //
        CloseFile(FNovo);       // Fecha o arquivo
        //
      end;
    end;

  end;
begin
  Commitatudo2(True); // Estoquetotal1Click // 2015-11-18
  CommitaTudo(True);// Estoquetotal1Click 2015-09-12

  //IBQREQUISITO := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQECF          := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQECFISCAL     := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQVENDAS       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQCOMPRAS      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQFABRICA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQBALCAO       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQRESERVA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQALIQUOTASR05 := CriaIBQuery(Form1.IBQuery5.Transaction); // Sandro Silva 2019-05-03
  IBQR03          := CriaIBQuery(Form1.IBQuery5.Transaction); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR04          := CriaIBQuery(Form1.IBQuery5.Transaction); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR06          := CriaIBQuery(Form1.IBQuery5.Transaction); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR07          := CriaIBQuery(Form1.IBQuery5.Transaction); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco

  IBQR03.BufferChunks := 100; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR04.BufferChunks := 100; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR06.BufferChunks := 100; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  IBQR07.BufferChunks := 100; // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco

  Form1.CDSR01.EmptyDataSet; // Sandro Silva 2017-11-28 Polimig

  slArq := TStringList.Create;

  //
  Form1.sAjuda := 'ecf_cotepe.htm#Estoque';
  try
    //
    Form7.sMfd  := '9';
    Form7.Label1.Caption          := 'Informe o período para o relatório Registros do ' +
                                     'PAF-ECF e clique em <Avançar> para continuar.';
    Form7.DateTimePicker1.Top     := Form7.Label3.BoundsRect.Bottom + 3;
    Form7.DateTimePicker2.Top     := Form7.Label5.BoundsRect.Bottom + 3;

    Form7.DateTimePicker1.Visible := True;
    Form7.DateTimePicker2.Visible := True;
    Form7.MaskEdit1.Visible       := False;
    Form7.MaskEdit2.Visible       := False;
    Form7.CheckBox1.Visible       := False;
    Form7.Label3.Caption          := 'Data inicial:';
    Form7.Label5.Caption          := 'Data final:';
    //
    if AllTrim(Form1.sNumeroDeSerieDaImpressora) <> '' then
    begin
      Form7.ComboBox1.Text := Form1.sNumeroDeSerieDaImpressora;
    end else
    begin
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSql.Clear;
      //Form1.ibDataSet99.SelectSQL.Add('select SERIE from REDUCOES group by SERIE');
      Form1.IbDataSet99.SelectSQL.Add('select SERIE from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' group by SERIE'); // Sandro Silva 2021-08-11 Form1.IbDataSet99.SelectSQL.Add('select SERIE from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' group by SERIE');
      Form1.ibDataSet99.Open;
      //
      while not Form1.ibDataSet99.Eof do
      begin
        //
        if AllTrim(Form1.ibDataSet99.FieldByName('SERIE').AsString) <> '' then
        begin
          Form7.ComboBox1.Items.Add(Form1.ibDataSet99.FieldByName('SERIE').AsString);
          Form7.ComboBox1.Text := Form1.ibDataSet99.FieldByName('SERIE').AsString;
        end;
        //
        Form1.ibDataSet99.Next;
        //
      end;
      //
      Form1.ibDataSet99.Close;
      //
    end;
    //

    if Form1.bData then
    begin
      //
      Form7.Caption := 'Registros do PAF-ECF';
      Form7.ShowModal;

      if Form7.ModalResult <> mrOK then // 2015-07-29
        Exit;

      Form1.Repaint;
      //
      Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\REGISTROS_DO_PAF_ECF_MENU_FISCAL.TXT';

      Form1.Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF”');
      //
    end else
    begin
      Form1.Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF”');
      //
      Form1.ibQuery5.Close;
      Form1.ibQuery5.SQL.Clear;
      Form1.ibQuery5.SQL.Add('select max(DATA) from REDUCOES where SERIE='+QuotedStr(Alltrim(Form7.ComboBox1.Text))+' ');
      Form1.ibQuery5.Open;

      //
      if Form1.ibQuery5.FieldByName('MAX').AsString <> '' then
      begin
        //
        Form7.DateTimePicker1.Date := StrToDate(Form1.ibQuery5.FieldByName('MAX').AsString);
        Form7.DateTimePicker2.Date := StrToDate(Form1.ibQuery5.FieldByName('MAX').AsString);
        //
      end;
      //
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSql.Clear;
      Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where DATA='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+' and SERIE='+QuotedStr(Alltrim(Form7.ComboBox1.Text))+' order by PDV, DATA');
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
      //

      Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\'+Form1.ibDataSet88.FieldByName('CODIGOECF').AsString + Right(Form1.ibDataSet88.FieldByName('SERIE').AsString,14) +FormatDateTime('DDMMYYYY', Form1.ibDataSet88.FieldByName('DATA').AsDateTime)+'.txt';
      //
    end;

    //
    Screen.Cursor             := crHourGlass;    // Cursor de Aguardo

    Form1.ibQuery5.Close;                         // saber qual a aliquota associada //
    Form1.ibQuery5.SQL.Text :=
      'select * from ICM where coalesce(ISS, 0) <> 0';
    Form1.ibQuery5.Open;
    //
    sAliqISSQN := '';
    while Form1.ibQuery5.Eof = False do
    begin
      if Form1.ibQuery5.FieldByName('ISS').AsFloat <> 0 then
      begin
        sAliqISSQN := Alltrim(StrZero(Form1.ibQuery5.FieldByName('ISS').AsFloat*100,4,0));
        Break;
      end;
      Form1.ibQuery5.Next;
    end;
    //
    //  if Form1.SaveDialog1.Execute then
    //
    DeleteFile(Form1.SaveDialog1.FileName);
    AssignFile(F, Form1.SaveDialog1.FileName);
    Rewrite(F);                           // Abre para gravação
    //
    // Evidência de exclusao de registros
    //
    // c) A exclusão/inclusão de dados no banco de dados dos arquivos eletrônicos deverá ser evidenciada mediante a substituição de brancos pelo caractere “?” no campo:
    // c.1) “Razão Social” no caso do registro D1 constante no Anexo III;
    // c.2) “Razão Social” no caso do registro E1 constante no Anexo IV;
    // c.3) “Razão Social” no caso do registro P1 constante no Anexo V;
    // c.5) “Razão Social” no caso do registro C1 constante no Anexo IX;
    // c.4) “Denominação da empresa desenvolvedora” no caso do registro R01 constante no Anexo VI;
    // d) Para os registros evidenciados é vedada a eliminação destas evidências por menus ou rotinas automáticas do sistema.
    //
    sEvidenciaDeExclusao := '';
    //
    if not HASHs('DEMAIS',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('REDUCOES',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('PAGAMENT',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ALTERACA',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ESTOQUE',False)  then sEvidenciaDeExclusao := '?';
    //
    if sEvidenciaDeExclusao = '?' then
    begin
      sEvidenciaDeExclusao := StrTran(Copy(Form1.ibDataSet13.FieldByName('NOME').AsString+replicate(' ', 50), 1, 50),' ','?');
  //      SmallMsg('Violado');

      if not HASHs('DEMAIS',False) then LogFrente('Teste 01: Evidência Demais');
      if not HASHs('REDUCOES',False) then LogFrente('Teste 01: Evidência Reducoes');
      if not HASHs('PAGAMENT',False) then LogFrente('Teste 01: Evidência Pagament');
      if not HASHs('ALTERACA',False) then LogFrente('Teste 01: Evidência Alteraca');
      if not HASHs('ESTOQUE',False)  then LogFrente('Teste 01: Evidência Estoque');

    end else
    begin
      sEvidenciaDeExclusao := Copy(Form1.ibDataSet13.FieldByName('NOME').AsString+replicate(' ', 50), 1, 50);
  //      SmallMsg('Ok');
    end;

    sEmitenteEvidenciado := '';
    if not AssinaRegistro('EMITENTE',Form1.ibDataSet13, False) then
      sEmitenteEvidenciado := '?';

    //
    Form1.ibDataSet88.Close;
    Form1.ibDataSet88.SelectSQL.Clear;
    Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where DATA>='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' and SERIE='+QuotedStr(Alltrim(Form7.ComboBox1.Text))+' order by PDV, DATA');
    Form1.ibDataSet88.Open;
    Form1.ibDataSet88.Last;
    //
    Form1.ibDataSet88.First;
    //
    sEvidenciaReducoes := ' ';
    //
    Form1.ibDataSet88.First;
    while not Form1.ibDataSet88.Eof do
    begin
      if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
        sEvidenciaReducoes := '?';
      Form1.ibDataSet88.Next;
    end;

    //
    //
    Writeln(F, 'U1' +
               Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
               Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) +
               Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) +
               sEvidenciaDeExclusao);
    //
    // A2
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - A2');

    sA2FiltroCaixa := '';
    if Form1.bData = False then // Está gerando na RZ
      sA2FiltroCaixa := ' and P.CAIXA = ' + QuotedStr(Form1.sCaixa) + ' ';

    Form1.ibQuery5.Close;
    Form1.ibQuery5.SQL.Text :=
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from REDUCOES R ' +
      'left join PAGAMENT P on (P.PEDIDO between R.CUPOMI and R.CUPOMF and P.DATA between R.DATA and R.DATA + 1 and P.CAIXA = R.PDV) ' +
      'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      sA2FiltroCaixa +
      ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
      ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
      ' and P.FORMA not containing ''NF-e'' ' +
      ' and P.FORMA not containing ''NFC-e'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' + 
      ' and P.REGISTRO is not null ' +
      ' union ' +
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from PAGAMENT P ' +
      'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      sA2FiltroCaixa +
      ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
      ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
      ' and P.FORMA not containing ''NF-e'' ' +
      ' and P.FORMA not containing ''NFC-e'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
      ' and P.REGISTRO is not null ' +
      ' union ' +
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from PAGAMENT P ' +
      'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      ' and P.CAIXA is null ' +
      ' order by 2, 1 ';
    Form1.ibQuery5.Open;


    //
    while not Form1.ibQuery5.Eof do
    begin
      //
      // Tipo = 1   Cupom fiscal
      //
      // Não agrupar para identificar evidências
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSql.Text :=
        'select P.REGISTRO, P.PEDIDO, P.DATA, P.FORMA, P.VALOR, ''1'' as TIPODOCUMENTO ' +
        'from PAGAMENT P ' +
        'where P.PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
        ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
        ' and P.FORMA not containing ''NF-e'' ' +
        ' and P.FORMA not containing ''NFC-e'' ' +
        ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
        ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
        ' and P.CAIXA = ' + QuotedStr(Form1.ibQuery5.FieldByName('CAIXA').AsString) + // dos cupons fiscais só do caixa
        ' order by P.FORMA';
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      Form1.fTotal := 0;
      //
      //Acumula os valores das formas de pagamento e identifica se está evidenciado
      while not Form1.ibDataSet99.Eof do
      begin

        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
          ' and CAIXA = ' + QuotedStr(Form1.ibQuery5.FieldByName('CAIXA').AsString) + // dos cupons fiscais só do caixa
          ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
          ' and DESCRICAO <> ''Desconto'' ' +
          ' and DESCRICAO <> ''Acréscimo'' ';
        Form1.ibDataSet27.Open;

        // Apenas de cupons não cancelados
        if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then
        begin

          bA2 := False;
          iA2Posicao := -1; // Sandro Silva 2018-08-29
          for iA2 := 0 to Length(aA2) - 1 do
          begin
            if (aA2[iA2].Data = Form1.ibDataSet99.FieldByName('DATA').AsDateTime)
              and (aA2[iA2].Forma = LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString))
              and (aA2[iA2].TipoDocumento = Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString) then
            begin
              bA2 := True;
              iA2Posicao := iA2;
            end;
          end;

          if bA2 = False then
          begin
            SetLength(aA2, Length(aA2) + 1);
            iA2Posicao := High(aA2);

            aA2[iA2Posicao].Data          := Form1.ibDataSet99.FieldByName('DATA').AsDateTime;
            aA2[iA2Posicao].TipoDocumento := Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString; // NF emitida Manualmente
            aA2[iA2Posicao].Forma         := LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString);
            aA2[iA2Posicao].CodigoForma   := Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 1, 2);
          end;
          aA2[iA2Posicao].Valor := aA2[iA2Posicao].Valor + Form1.ibDataSet99.FieldByName('VALOR').AsFloat;

          Form1.ibDataSet28.Close;
          Form1.ibDataSet28.SelectSQL.Text :=
            'select * ' +
            'from PAGAMENT ' +
            'where REGISTRO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('REGISTRO').AsString);
          Form1.ibDataSet28.Open;

          if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
            aA2[iA2Posicao].Evidencia := '?';

        end;

        Form1.ibDataSet99.Next;
        //
      end;

      //
      // Tipo = 3 Nota NF-e
      //
      // Não agrupar para identificar evidências
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSql.Text :=
        'select P.REGISTRO, P.CLIFOR, P.PEDIDO, P.DATA, P.FORMA, P.VALOR, ''3'' as TIPODOCUMENTO ' +
        'from PAGAMENT P ' +
        'where P.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibQuery5.FieldByName('DATA').AsDateTime)) +
        ' and P.PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
        'and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
        'and P.FORMA containing ''NF-e'' ' +
        //'and P.FORMA containing ''NFC-e'' ' +
        'and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
        'and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
        'and (coalesce(P.CAIXA, '''') = ''''  and coalesce(P.COO, '''') = '''')' +
        ' order by P.FORMA';
      Form1.ibDataSet99.Open;

      Form1.ibDataSet99.First;
      //
      Form1.fTotal := 0;
      //
      while not Form1.ibDataSet99.Eof do
      begin
        dA2Descontar := 0.00;

        // Localiza NF-e emitidas que podem duplicar o valor em PAGAMENT
        // Desconta cancelamentos, importação cupons, reclassificação
        // NF-e cancelada
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''cancelada'') ' +
          //' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.EMISSAO = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibQuery5.FieldByName('DATA').AsDateTime)) +
          ' and COMPLEMENTO containing ''MD-5'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2Cancelado := 0.00;
        while IBQECF.Eof = False do
        begin
          dA2Cancelado := dA2Cancelado + IBQECF.FieldByName('TOTAL').AsFloat;
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Cancelado));

        // Cupons Importados
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.XPED starting ''CF'' ' +  // Ex.: CF007502CX006
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          //' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.EMISSAO = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibQuery5.FieldByName('DATA').AsDateTime)) +
          ' and VENDAS.COMPLEMENTO containing ''MD-5'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2CupomImporta := 0.00;
        while IBQECF.Eof = False do
        begin
          dA2CupomImporta := dA2CupomImporta + IBQECF.FieldByName('TOTAL').AsFloat;
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2CupomImporta));

        // NF-e CFOP 5926 Reclassificação de estoque
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.CFOP starting ''5926'' ' +  // Ex.: CF007502CX006 // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco 'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.CFOP = ''5926'' ' +  // Ex.: CF007502CX006
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          ' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.COMPLEMENTO containing ''MD-5'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2Reclassifica := 0.00;
        while IBQECF.Eof = False do
        begin
          //ShowMessage('Teste 01 5926 ' + IBQECF.FieldByName('NUMERONF').AsString + ' ' + IBQECF.FieldByName('TOTAL').AsString);

          dA2Reclassifica := dA2Reclassifica + IBQECF.FieldByName('TOTAL').AsFloat;

          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Reclassifica));

        // NF-e Entrada CFOP 1926 Reclassificação de estoque
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS002 on ITENS002.NUMERONF = VENDAS.NUMERONF and VENDAS.CLIENTE = ITENS002.FORNECEDOR and ITENS002.CFOP starting ''1926'' ' +  // Ex.: CF007502CX006 // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco 'join ITENS002 on ITENS002.NUMERONF = VENDAS.NUMERONF and VENDAS.CLIENTE = ITENS002.FORNECEDOR and ITENS002.CFOP = ''1926'' ' +  // Ex.: CF007502CX006
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          ' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.COMPLEMENTO containing ''ENTRADA'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;

        dA2Reclassifica := 0.00;
        while IBQECF.Eof = False do
        begin
          IBQCOMPRAS.Close;
          IBQCOMPRAS.SQL.Text :=
            'select * ' +
            'from COMPRAS ' +
            'where NUMERONF = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
            ' and FORNECEDOR = ' + QuotedStr(IBQECF.FieldByName('CLIENTE').AsString);
          IBQCOMPRAS.Open;

          //ShowMessage('Teste 01 1926 ' + IBQECF.FieldByName('NUMERONF').AsString + ' ' + IBQCOMPRAS.FieldByName('TOTAL').AsString);

          dA2Reclassifica := dA2Reclassifica + IBQCOMPRAS.FieldByName('TOTAL').AsFloat; // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco dA2Reclassifica := dA2Reclassifica + IBQECF.FieldByName('TOTAL').AsFloat;
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Reclassifica));

        bA2 := False;
        iA2Posicao := -1; // Sandro Silva 2018-08-29
        for iA2 := 0 to Length(aA2) - 1 do
        begin
          if (aA2[iA2].Data = Form1.ibDataSet99.FieldByName('DATA').AsDateTime)
            and (aA2[iA2].Forma = LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString))
            and (aA2[iA2].TipoDocumento = Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString) then
          begin
            bA2 := True;
            iA2Posicao := iA2;
          end;
        end;

        if bA2 = False then
        begin
          SetLength(aA2, Length(aA2) + 1);
          iA2Posicao := High(aA2);

          aA2[iA2Posicao].Data          := Form1.ibDataSet99.FieldByName('DATA').AsDateTime;
          aA2[iA2Posicao].TipoDocumento := Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString; // NF emitida Manualmente
          aA2[iA2Posicao].Forma         := LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString);
          aA2[iA2Posicao].CodigoForma   := Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 1, 2);
        end;
        aA2[iA2Posicao].Valor := aA2[iA2Posicao].Valor + Form1.ibDataSet99.FieldByName('VALOR').AsFloat - dA2Descontar;

        //ShowMessage('Teste 01 Total que não conta no A2 ' + floattostr(dA2Descontar));

        if aA2[iA2Posicao].Valor < 0 then
          aA2[iA2Posicao].Valor := 0.00;

        Form1.ibDataSet28.Close;
        Form1.ibDataSet28.SelectSQL.Text :=
          'select * ' +
          'from PAGAMENT ' +
          'where REGISTRO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('REGISTRO').AsString);
        Form1.ibDataSet28.Open;

        if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
          aA2[iA2Posicao].Evidencia := '?';

        Form1.ibDataSet99.Next;
        //
      end;

      //
      Form1.ibQuery5.Next;
      //
    end;


    for iA2Posicao := 0 to Length(aA2) - 1 do
    begin
      if aA2[iA2Posicao].Valor > 0 then
      begin
        //
        // Valida se o registro evidenciado não entrou na soma da forma de pagamento
        Form1.ibDataSet28.Close;
        Form1.ibDataSet28.SelectSQL.Text :=
          'select * ' +
          'from PAGAMENT ' +
          'where DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', aA2[iA2Posicao].Data)) +
          ' and substring(FORMA from 1 for 2) = ' + QuotedStr(aA2[iA2Posicao].CodigoForma);
        Form1.ibDataSet28.Open;

        while Form1.ibDataSet28.Eof = False do
        begin
          if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
            aA2[iA2Posicao].Evidencia := '?';
          Form1.ibDataSet28.Next;
        end;


        sEvidenciaA2 := Copy(aA2[iA2Posicao].Forma + DupeString(' ', 25), 1, 25);
        if aA2[iA2Posicao].Evidencia = '?' then
          sEvidenciaA2 := StringReplace(sEvidenciaA2, ' ', '?', [rfReplaceAll]);
        Writeln(F, 'A2'
                      + FormatDateTime('yyyymmdd', aA2[iA2Posicao].Data)
                      + sEvidenciaA2
                      + aA2[iA2Posicao].TipoDocumento
                      + StrZero(aA2[iA2Posicao].Valor*100,12,0));// Sandro Silva 2017-11-09 Polimig  + StrZero(Form1.ibDataSet99.FieldByName('VTOT').AsFloat*100,12,0));
      end;

    end; // for iA2Posicao := 0 to Length(aA2) - 1 do

    ///////////////// FIM A2 ////////////////////////
    /////////////////////////////////////////////////
    ////

    //
    //
    // asdfsdf
    //


    // P2 só gerada quando for pelo menu fiscal ou da geração automática da primeira impressora a realizar a Redução Z

    if Form1.bData = False then
    begin
      Form1.IbDataSet100.Close;
      Form1.IbDataSet100.SelectSQL.Text :=
        'select max(DATA) as DATA ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora);
      Form1.IbDataSet100.Open;

      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 SERIE ' +
        'from REDUCOES ' +
        'where DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
        'order by DATA, HORA';
        //' and SERIE <> ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora);
      IBQECF.Open;
      //bGerarRegistro := (IBQECF.FieldByName('SERIE').AsString = '');
      bGerarRegistro := (IBQECF.FieldByName('SERIE').AsString = Form1.sNumeroDeSerieDaImpressora);
    end
    else
      bGerarRegistro := True;

    if bGerarRegistro then
    begin

      //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - P2');

      Form1.IbDataSet4.Close;
      Form1.IbDataSet4.SelectSQL.Clear;
      Form1.IbDataSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
      Form1.IbDataSet4.Open;
      //
      Form1.IbDataSet4.First;
      while not Form1.IbDataSet4.EOF do
      begin
        //
        if not (Form1.IbDataSet4.FieldByName('ATIVO').AsString='1') then
        begin
          //
          //2015-11-13 DEVE GERAR TODOS, APENAS REGISTRO "E" QUE DEVE FILTRAR
          // if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.IbDataSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
          begin
            //
            sAliquota := '';
            if AllTrim(Form1.IbDataSet4.FieldByName('ST').AsString) <> '' then // Se o ST não estiver em branco   //
            begin                                    // Procurar na tabela de ICM para  //
              Form1.IbDataSet14.First;                         // saber qual a aliquota associada //
              while not Form1.IbDataSet14.EOF do
              begin
                if Form1.IbDataSet14.FieldByName('ST').AsString = Form1.IbDataSet4.FieldByName('ST').AsString then  // Pode ocorrer um erro    //
                begin                                           // se o estado do emitente //
                  try                                             // Não estiver cadastrado  //
                    if Form1.IbDataSet14.FieldByName('ISS').AsFloat > 0 then
                    begin
                      sAliquota := StrZero(Form1.IbDataSet14.FieldByName('ISS').AsFloat * 100,4,0);
                      sSituacaoTributaria := 'S';
                    end else
                    begin
                      sAliquota := StrZero( (Form1.IbDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100) / 100 * Form1.IbDataSet14.FieldByName('BASE').AsFloat,4,0);
                      sSituacaoTributaria := 'T';
                    end;
                  except sAliquota  := '' end;
                end;
                Form1.IbDataSet14.Next;
              end;
            end else sSituacaoTributaria := 'T';
            //
            if sAliquota = '' then // Se o sAliquota continuar em branco é porque não estava cadastrado //
            begin            // na tabela de ICM ou estava em branco                        //
              Form1.IbDataSet14.First;
              while not Form1.IbDataSet14.EOF do  // Procura pela operação padrão venda À vista ou //
              begin                     // venda a prazo 512 ou 612 ou 5102 ou 6102      //
                if (AllTrim(Form1.IbDataSet14.FieldByName('CFOP').AsString) = '5102') or (AllTrim(Form1.IbDataSet14.FieldByName('CFOP').AsString) = '6102') then
                begin
                  try
                    sAliquota := StrZero( (Form1.IbDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100) / 100 * Form1.IbDataSet14.FieldByName('BASE').AsFloat ,4,0);
                  except sAliquota  := '' end;
                end;
                Form1.IbDataSet14.Next;
              end;
            end;
            //
            if Copy(allTrim(Form1.IbDataSet4.FieldByName('ST').AsString),1,1) = 'I' then sSituacaoTributaria := 'I' else
              if Copy(allTrim(Form1.IbDataSet4.FieldByName('ST').AsString),1,1) = 'F' then sSituacaoTributaria := 'F' else
                if Copy(allTrim(Form1.IbDataSet4.FieldByName('ST').AsString),1,1) = 'N' then sSituacaoTributaria := 'N';
            //
            if (sSituacaoTributaria = 'I') or (sSituacaoTributaria = 'F') or (sSituacaoTributaria = 'N') then sAliquota := '0000';
            //
            sCodigo := Right('00000000000000' + Form1.IbDataSet4.FieldByName('CODIGO').AsString, 14);

            if Trim(Form1.IbDataSet4.FieldByName('REFERENCIA').AsString) <> '' then
            begin
              sCodigo := Right('00000000000000' + Form1.IbDataSet4.FieldByName('REFERENCIA').AsString, 14);
            end;
            //
            sUnd := Copy(Form1.IbDataSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);
            if not AssinaRegistro('ESTOQUE',Form1.IbDataSet4, False) then
            begin
              //LogFrente('P2 ' + sCodigo + ' ESTOQUE EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
              LogFrente('31449 P2 ' + sCodigo + ' ESTOQUE EVIDENCIADO');
              sUnd := StrTran(sUnd,' ','?');
              sEvidenciaP2 := '?'; // Sandro Silva 2016-03-08 POLIMIG
            end;

            if Pos(sEmitenteEvidenciado, '?') > 0 then
            begin
              //LogFrente('P2 ' + sCodigo + ' EMITENTE EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
              sUnd := StrTran(sUnd,' ','?');
            end;
            //
            //
            Writeln(F, 'P2' +
                    Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)
                    + sCodigo
                    + Copy(LimpaNumero(Form1.IbDataSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7) // Sandro Silva 2017-09-05
                    + Copy(LimpaNumero(Form1.IbDataSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)   // Sandro Silva 2017-09-05
                    + Copy(Form1.IbDataSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)
                    + sUnd
                    + RightStr('T' + AllTrim(Form1.IbDataSet4.FieldByName('IAT').AsString), 1) // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco AllTrim(Form1.IbDataSet4.FieldByName('IAT').AsString)
                    + RightStr('T' + AllTrim(Form1.IbDataSet4.FieldByName('IPPT').AsString), 1) // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco AllTrim(Form1.IbDataSet4.FieldByName('IPPT').AsString)
                    + RightStr('T' + sSituacaoTributaria, 1) // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco sSituacaoTributaria
                    + sAliquota
                    + StrZero(Form1.IbDataSet4.FieldByName('PRECO').AsFloat*100,12,0));

          end;
        end;
        //
        Form1.IbDataSet4.Next;
        //
      end;

    end;//

    // O primeiro ECF que efetuou impressão na data final do período
    // Se na data final do período não houve impressão retroage 1 dia na data final do período até encontrar o ECF

    CDSPRIMEIRAIMPRESSAO := TClientDataSet.Create(nil);
    CDSPRIMEIRAIMPRESSAO.FieldDefs.Add('SERIEECF', ftString, 30);
    CDSPRIMEIRAIMPRESSAO.FieldDefs.Add('DATA', ftDateTime);
    CDSPRIMEIRAIMPRESSAO.FieldDefs.Add('HORA', ftString, 8);
    CDSPRIMEIRAIMPRESSAO.FieldDefs.Add('DATAHORA', ftDateTime);
    CDSPRIMEIRAIMPRESSAO.CreateDataSet;
    // Localiza a menor data/hora que houve impressão, dentro do período selecionado

    // DEMAIS
    Form1.IBQuery1.Close;
    Form1.IBQuery1.SQL.Text :=
      'select D.ECF, D.DATA, D.HORA ' + // Sandro Silva 2019-09-16 ER 02.06 UnoChapeco 'select D.ECF, min(D.DATA) as DATA, min(D.HORA) as HORA ' +
      'from DEMAIS D ' +
      'where D.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) + ' ' +
      ' group by D.ECF, D.DATA, D.HORA ' +// Sandro Silva 2019-09-16 ER 02.06 UnoChapeco ' group by D.ECF ' +
      ' order by DATA, HORA';
    Form1.IBQuery1.Open;

    AdicionaImpressao(Form1.IBQuery1.FieldByName('ECF').AsString, Form1.IBQuery1.FieldByName('DATA').AsDateTime, Form1.IBQuery1.FieldByName('HORA').AsString);


    // ALTERACA
    Form1.IBQuery1.Close;
    Form1.IBQuery1.SQL.Text :=
      'select A.CAIXA, A.DATA, A.HORA ' + // Sandro Silva 2019-09-16 ER 02.06 UnoChapeco 'select A.CAIXA, min(A.DATA) as DATA, min(A.HORA) as HORA ' +
      'from ALTERACA A ' +
      'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) + ' ' +
      'and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
      'group by A.CAIXA, A.DATA, A.HORA ' + // Sandro Silva 2019-09- ER 02.06 UnoChapeco 'group by A.CAIXA ' +
      'order by DATA, HORA';
    Form1.IBQuery1.Open;
    if Form1.IBQuery1.FieldByName('CAIXA').AsString <> '' then
    begin
      // Identifica o ECF que emitiu o cupom fiscal
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSQL.Text :=
        'select * ' +
        'from REDUCOES ' +
        'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
        'and PDV = ' + QuotedStr(Form1.IBQuery1.FieldByName('CAIXA').AsString) +
        ' order by DATA desc';
      Form1.ibDataSet88.Open;

      AdicionaImpressao(Form1.ibDataSet88.FieldByName('SERIE').AsString, Form1.IBQuery1.FieldByName('DATA').AsDateTime, Form1.IBQuery1.FieldByName('HORA').AsString) ;

    end;

    CDSPRIMEIRAIMPRESSAO.IndexFieldNames := 'DATAHORA';
    CDSPRIMEIRAIMPRESSAO.First;
    if CDSPRIMEIRAIMPRESSAO.IsEmpty = False then
    begin
      sDataPrimeiro := CDSPRIMEIRAIMPRESSAO.FieldByName('DATA').AsString;
      sHoraPrimeiro := CDSPRIMEIRAIMPRESSAO.FieldByName('HORA').AsString;
      sECFSerie     := CDSPRIMEIRAIMPRESSAO.FieldByName('SERIEECF').AsString;
    end;

    if (sDataPrimeiro <> '') or (sECFSerie = '') then // Houve impressão ou não
    begin

      if (sDataPrimeiro <> '') then
      begin
        // Houve impressão no estabelecimento dentro do período selecionado
        CarregaEstoqueDoDia(sDataPrimeiro);
      end
      else
      begin
        // Não houve tem impressão no estabelecimento dentro do período selecionado
        // Localizar quando houve impressão em data mais próxima do início do período selecionado que atualiou o estoque do dia
        Form1.IBQuery1.Close;
        Form1.IBQuery1.SQL.Text :=
          'select A.DATA, A.HORA, ''ALTERACA'' ' +
          'from ALTERACA A ' +
          'where (A.TIPO = ''BALCAO'' or A.TIPO = ''CANCEL'') ' +
          ' and A.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) +
          ' union ' +
          'select D.DATA as DATA, D.HORA as HORA, ''DEMAIS  '' ' +
          'from DEMAIS D ' +
          'where D.DATA <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) +
          ' order by 1 desc, 2';
        Form1.IBQuery1.Open;
        if (Form1.IBQuery1.FieldByName('DATA').AsString <> '') then
          CarregaEstoqueDoDia(FormatDateTime('dd/mm/yyyy', Form1.IBQuery1.FieldByName('DATA').AsDateTime));
      end;

      // Identificar a marca e modelo do ECF se evidenciado
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSQL.Text :=
        'select * ' +
        'from REDUCOES ' +
        'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11         'where SMALL <> ''59'' and SMALL <> ''65'' ' +
        'and SERIE = ' + QuotedStr(sECFSerie) +
        'order by REGISTRO';
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
      while Form1.ibDataSet88.Eof = False do
      begin
        if Form1.ibDataSet88.FieldByName('REGISTRO').AsString <> '' then
        begin
          if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
          begin
            sEvidencia := '?';
            if sMarcaE3Evidenciado = '' then
            begin
              sMarcaE3Evidenciado  := Trim(Form1.ibDataSet88.FieldByName('MARCAECF').AsString); // Sandro Silva 2017-11-13  HOMOLOGA 2017
              sModeloE3Evidenciado := Trim(Form1.ibDataSet88.FieldByName('MODELOECF').AsString); // Sandro Silva 2017-11-13  HOMOLOGA 2017
            end;
            Break; // Sandro Silva 2017-11-13  HOMOLOGA 2017 Identificou evidência sai do loop 2017-11-27
          end;
        end;
        Form1.ibDataSet88.Next;
      end;

      Form1.ibDataSet88.Last;
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSQL.Text :=
        'select first 1 * ' +
        'from REDUCOES ' +
        'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
        'and SERIE = ' + QuotedStr(sECFSerie) +
        'order by REGISTRO desc';
      Form1.ibDataSet88.Open;

      if bGerarRegistro then // Sandro Silva 2017-11-10 Polimig Eliziane Listar E2 apenas quando lista o P2  REQUISITO XXVI 7. Os registros P2 e E2 somente deverão constar do arquivo a que se refere o item 5, quando gerado em função da Redução Z do primeiro ECF que tiver seu movimento encerrado no dia.
      begin

        if Trim(sTexto) <> '' then // Sandro Silva 2019-09-13 ER 02.06 UnoChapeco     if Form1.ibDataSet88.FieldByName('REGISTRO').AsString <> '' then
        begin
          //
          Form1.IbDataSet4.Close;
          Form1.IbDataSet4.SelectSQL.Clear;
          Form1.IbDataSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
          Form1.IbDataSet4.Open;
          //
          Form1.IbDataSet4.First;
          while not Form1.IbDataSet4.EOF do
          begin
            //
            if Form1.IbDataSet4.FieldByName('ST').AsString <> '005' then
            begin
              if not (Form1.IbDataSet4.FieldByName('ATIVO').AsString='1') then
              begin
                //
                if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.IbDataSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
                begin
                  //
                  //
                  //
                  sCodigo := Right('00000000000000' + Form1.IbDataSet4.FieldByName('CODIGO').AsString, 14);
                  if Trim(Form1.IbDataSet4.FieldByName('REFERENCIA').AsString) <> '' then
                  begin
                    sCodigo := Right('00000000000000' + Form1.IbDataSet4.FieldByName('REFERENCIA').AsString, 14);
                  end;
                  //
                  sUnd := copy(Form1.IbDataSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);
                  sQtd := Copy(sTexto,Pos('['+sCodigo,sTexto+']')+16,10);  // Quantidade com sinal +/-

                  if not AssinaRegistro('ESTOQUE',Form1.IbDataSet4, False) then
                  begin
                    sUnd := StrTran(sUnd,' ','?');
                  end;

                  sHashItemE2  := Copy(sTexto,Pos('['+sCodigo,sTexto+']') + 26, 56);
                  sDadosItemE2 := Copy(sTexto,Pos('['+sCodigo,sTexto+']'), 26);
                  sDadosItemE2 := StringReplace(sDadosItemE2, '[', '', [rfReplaceAll]);
                  sDadosItemE2 := StringReplace(sDadosItemE2, ']', '', [rfReplaceAll]);
                  if (AssinaRegistroE2(sDadosItemE2) <> sHashItemE2) then
                  begin
                    sUnd := StrTran(sUnd,' ','?');
                  end;

                  if Pos(sEmitenteEvidenciado, '?') > 0 then
                  begin
                    sUnd := StrTran(sUnd,' ','?');
                  end;
                  //
                  if Pos('['+sCodigo,sTexto+']') <> 0 then
                  begin
                    if Trim(Form1.IbDataSet4.FieldByName('REFERENCIA').AsString) <> '' then
                    begin
                      sCodigo := Right('00000000000000' + Form1.IbDataSet4.FieldByName('REFERENCIA').AsString, 14);
                    end;

                    Writeln(F, 'E2' +
                            Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)
                            + sCodigo
                            + Copy(LimpaNumero(Form1.IbDataSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7) // Sandro Silva 2017-09-05
                            + Copy(LimpaNumero(Form1.IbDataSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)   // Sandro Silva 2017-09-05
                            + Copy(Form1.IbDataSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)
                            + sUnd
                            + sQtd // Pega a quantidade do inicio do dia
                            );
                  end;

                end; // if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.IbDataSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
              end; // if not (Form1.IbDataSet4ATIVO.AsString='1') then
            end; // if Form1.IbDataSet4ST.AsString <> '005' then
            //
            Form1.IbDataSet4.Next;
            //
          end; // while not Form1.IbDataSet4.EOF do

        end; // if Trim(sTexto) <> '' then // Sandro Silva 2019-09-13 ER 02.06 UnoChapeco     if Form1.ibDataSet88.FieldByName('REGISTRO').AsString <> '' then

      end; //     if bGerarRegistro then

      Form1.ibDataSet88.First; // Sandro Silva 2019-09-20 ER 02.06 UnoChapeco
      
      while Form1.ibDataSet88.Eof = False do
      begin

        if Form1.ibDataSet88.FieldByName('REGISTRO').AsString <> '' then
        begin
          if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
             sEvidencia := '?';
        end;

        Form1.IBDataSet38.Close;
        Form1.IBDataSet38.SelectSQL.Text :=
          'select * ' +
          'from DEMAIS ' +
          'where ECF = ' + QuotedStr(Form1.ibDataSet88.FieldByName('SERIE').AsString) +
          ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDateDef(sDataPrimeiro, Date))) +
          ' and HORA = ' + QuotedStr(sHoraPrimeiro);
        Form1.IBDataSet38.Open;

        while Form1.IBDataSet38.Eof = False do
        begin
          if Form1.IBDataSet38.FieldByName('REGISTRO').AsString <> '' then
          begin
            if not AssinaRegistro('DEMAIS',Form1.IBDataSet38, False) then
              sEvidencia := '?';
          end;
          Form1.IBDataSet38.Next;
        end;

        //
        if sEvidencia = '?' then
        begin
          sEvidencia := Copy(StrTran(Form1.ibDataSet88.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ','?'),1,20);
        end else
        begin
          sEvidencia := Copy(AllTrim(Form1.ibDataSet88.FieldByName('MODELOECF').AsString)+Replicate(' ',20),1,20);
        end;
        sMarcaE3          := AllTrim(Form1.ibDataSet88.FieldByName('MARCAECF').AsString); // Sandro Silva 2017-11-10 Polimig
        sModeloEcfE3      := sEvidencia; // Sandro Silva 2017-11-13  HOMOLOGA 2017
        sNumeroSerieEcfE3 := Trim(Form1.ibDataSet88.FieldByName('SERIE').AsString); // Sandro Silva 2017-11-13  HOMOLOGA 2017 Saber o ecf do E3 e exibir fabricante e modelo nos demais registros relacionados (R01 Fabricante, R02..R07 Modelo)
        sTipoECFE3        := Trim(Form1.ibDataSet88.FieldByName('TIPOECF').AsString); // Sandro Silva 2017-11-28 Polimig

        // Marca do ECF evidenciado
        if sMarcaE3Evidenciado <> '' then
        begin
          sMarcaE3 := AllTrim(sMarcaE3Evidenciado); // Sandro Silva 2017-11-10 Polimig
        end;
        if sModeloE3Evidenciado <> '' then
        begin
          sEvidencia   := Copy(StrTran(sModeloE3Evidenciado+Replicate(' ',20),' ','?'),1,20);
          sModeloEcfE3 := sEvidencia; // Sandro Silva 2017-11-13  HOMOLOGA 2017
        end;
        //
        if sDataPrimeiro <> '' then
          sDataPrimeiro := FormatDateTime('yyyymmdd', StrToDateDef(sDataPrimeiro, Date));

        Writeln(F,  'E3' +                                                          // Tipo R01
                    Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20)+    // Número de fabricação do ECF Ok
                    ' '+                                                             // Letra indicativa de memória adicional
                    Copy(AllTrim(sTipoECFE3)+Replicate(' ',7),1,7)+       // Tipo de ECF // Sandro Silva 2017-11-28 Polimig  Copy(AllTrim(Form1.ibDataSet88.FieldByName('TIPOECF').AsString)+Replicate(' ',7),1,7)+       // Tipo de ECF
                    Copy(sMarcaE3+Replicate(' ',20),1,20)+    // Marca do ECF// Sandro Silva 2017-11-13  HOMOLOGA 2017 Copy(AllTrim(Form1.ibDataSet88.FieldByName('MARCAECF').AsString)+Replicate(' ',20),1,20)+    // Marca do ECF
                    sEvidencia+                                                                                  // Modelo do ECF
                    // 2015-09-21 Copy(Form1.ibDataSet88.FieldByName('ESTOQUE').AsString, 5, 4) + Copy(Form1.ibDataSet88.FieldByName('ESTOQUE').AsString, 3, 2) + Copy(Form1.ibDataSet88.FieldByName('ESTOQUE').AsString, 1, 2) + // Data Ex.:28082015161245
                    // 2015-09-21 RightStr(Form1.ibDataSet88.FieldByName('ESTOQUE').AsString, 6) // Hora Ex.: 28082015161245
                    // 2015-11-18 FormatDateTime('yyyymmdd', StrToDateDef(sDataPrimeiro, Date)) + // Data do estoque
                    Copy(sDataPrimeiro + '        ', 1, 8) + // Data do estoque
                    Copy(LimpaNumero(sHoraPrimeiro) + '      ', 1, 6) // Hora do estoque
                    ); // Data do estoque gravado no reducoes
        Form1.ibDataSet88.Next;
      end;
    end; // if sDataPrimeiro <> '' then]

    //if (Copy(Form1.sConcomitante, 1, 2) <> 'OS') then
    if (Pos('DAV',Form1.sConcomitante) = 0) then
    begin

      // Mesas abertas S2 e S3
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select PEDIDO, min(DATA) as DATA ' +
        'from ALTERACA ' +
        'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
        'group by PEDIDO ' +
        'order by PEDIDO';
      IBQECF.Open;

      while IBQECF.Eof = False do
      begin

        if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////
          // S2
          /////////////////////

          //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - S2');

          // Seleciona as mesas com data de lançamento no período selecionado

          Form1.ibQuery5.Close;
          Form1.ibQuery5.SQL.Clear;
          Form1.ibQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL)as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA, max(coalesce(COO,'''')) as COO ' + // Sandro Silva 2017-12-15  'select PEDIDO, sum(TOTAL)as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA, max(coalesce(COO,'''')) as COO ' + // Sandro Silva 2017-12-22  'select PEDIDO, sum(TOTAL)as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA, max(coalesce(COO,'''')) as COO ' +
            'from ALTERACA ' +
            'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
            //  Deve ser criado um registro tipo S2 para cada mesa ou conta de cliente que se encontre aberta quando da geração do arquivo.
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('PEDIDO').AsString) + // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco Lista os totais da mesa selecionada
            ' and DESCRICAO <> ''<CANCELADO>'' ' +
            'group by PEDIDO ' +
            'order by IDATAHORA ';
          Form1.ibQuery5.Open;
          //
          while not Form1.ibQuery5.Eof do
          begin
            //
            sEvidenciaS2Ecf := '';
            if AllTrim(Form1.ibQuery5.FieldByName('COO').AsString) <> '' then
            begin
              Form1.ibDataSet27.Close;
              Form1.ibDataSet27.SelectSQL.Text :=
               'select * ' +
               'from ALTERACA ' +
               'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
               ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' + // Sandro Silva 2018-11-09 ' and TIPO = ''MESA'' ' +
               ' and COO = ' + AllTrim(Form1.ibQuery5.FieldByName('COO').AsString);
              Form1.ibDataSet27.Open;

              Form1.ibDataSet88.Close;
              Form1.ibDataSet88.SelectSQL.Text :=
                'select first 1 * from REDUCOES ' +
                'where PDV = ' + QuotedStr(Form1.ibDataSet27.FieldByName('CAIXA').AsString) +
                ' order by DATA desc';
              Form1.ibDataSet88.Open;

              sStituacao := Right('000000000' + Form1.ibQuery5.FieldByName('COO').AsString, 9) +
                            Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString + Replicate(' ', 20), 1, 20);
              if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then // Sandro Silva 2016-03-08 POLIMIG
                sEvidenciaS2Ecf := '?';
            end else
            begin
              sStituacao := Replicate(' ', 29); // Na ER o campo COO é alfanumérico
            end;

            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') '; // Sandro Silva 2018-11-09 ' ' and TIPO = ''MESA'' ';
            Form1.ibDataSet27.Open;

            sEvidenciaS2 := '';
            while Form1.ibDataSet27.Eof = False do
            begin
              if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) {or (sEvidenciaP2 = '?')} or (sEvidenciaS2Ecf = '?') then // Sandro Silva 2016-03-08 POLIMIG
              begin
                sEvidenciaS2 := '??????????';
              end;
              Form1.IbDataSet27.Next;
            end;

            dS2Total := 0.00;
            Form1.IbDataSet27.Close;
            Form1.IbDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
             ' and coalesce(VENDEDOR, '''') <> ''<cancelado>'' ' +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') '; // Sandro Silva 2018-11-09 ' ' and TIPO = ''MESA'' ';
            Form1.IbDataSet27.Open;

            while Form1.IbDataSet27.Eof = False do
            begin
              dS2Total := dS2Total + Form1.IbDataSet27.FieldByName('TOTAL').AsFloat;
              Form1.IbDataSet27.Next;
            end;

            sS2Conta := Copy(RightStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString, 3) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);  // Número da mesa/Conta cliente
            if Copy(Form1.sConcomitante,1,2) = 'OS' then
              sS2Conta := Copy(Right(Form1.ibQuery5.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);   // Conta cliente OS // Sandro Silva 2017-12-15  sS2Conta := Copy(Right(Replicate('0', 10) + RightStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString, 3), 10) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);   // Conta cliente OS

            if Pos(sEmitenteEvidenciado, '?') > 0 then
            begin
              sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]);  // Conta cliente OS// Sandro Silva 2017-12-15  sS2Conta := Copy(Right(Replicate('0', 10) + RightStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString, 3), 10) + '?????????????????' + Replicate(' ', 10), 1, 13);   // Conta cliente OS
            end;

            Writeln(F,  'S2' +                                                          // Tipo S2
                        Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                        FormatDateTime('yyyymmdd', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // DD
                        FormatDateTime('HHnnss', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // HORA
                        sS2Conta + // Sandro Silva 2017-11-09 Polimig  Copy(RightStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString, 3) + sEvidenciaS2 + Replicate(' ', 10), 1, 13) +  // Número da mesa/Conta cliente // Sandro Silva 2016-03-08 POLIMIG
                        StrZero(dS2Total * 100, 13, 0) +// Sandro Silva 2017-11-09 Polimig  StrZero(Form1.ibQuery5.FieldByName('VTOT').AsFloat * 100, 13, 0) +
                        sStituacao);
                        //
            Form1.ibQuery5.Next;
          end;

        end; // if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date)))

        IBQECF.Next;
      end;

      //Volta para a primeira mesa para lista os itens
      IBQECF.First;
      while IBQECF.Eof = False do
      begin

        if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////////
          // S3
          /////////////////////////
          //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - S3');

          Form1.ibQuery5.Close;
          Form1.ibQuery5.SQL.Clear;
          // 2015-09-21 6.20.1.1. Deve ser criado um registro tipo S3 para cada item registrado na mesa ou conta de cliente,
          // somente no caso de Mesa ou Conta de Cliente com situação “aberta”, mesmo que ele tenha sido marcado para cancelamento.
          Form1.ibQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL) as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA ' +
            'from ALTERACA ' +
            'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('PEDIDO').AsString) + // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco Lista os itens da mesa selecionada
            ' and DESCRICAO<>''<CANCELADO>'' ' +
            'group by PEDIDO order by IDATAHORA ';
          Form1.ibQuery5.Open;
          //

          while not Form1.ibQuery5.Eof do
          begin
            //
            Form1.ibQuery6.Close;
            Form1.ibQuery6.SQL.Clear;
            Form1.ibQuery6.SQL.Add('select * from ALTERACA where PEDIDO='+QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString)+' and DESCRICAO<>''<CANCELADO>'' and (TIPO = ''MESA'' or TIPO = ''DEKOL'' ) order by REGISTRO'); // Sandro Silva 2018-11-09 Form1.ibQuery6.SQL.Add('select * from ALTERACA where PEDIDO='+QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString)+' and DESCRICAO<>''<CANCELADO>'' and TIPO = ''MESA'' order by REGISTRO');
            Form1.ibQuery6.Open;
            //
            while not Form1.ibQuery6.Eof do
            begin
              Form1.IbDataSet27.Close;
              Form1.IbDataSet27.SelectSQL.Text :=
               'select * ' +
               'from ALTERACA ' +
               'where PEDIDO = ' + QuotedStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString) +
               ' and ITEM = ' + QuotedStr(Form1.ibQuery6.FieldByName('ITEM').AsString) +
               ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') '; // Sandro Silva 2018-11-09 ' ' and TIPO = ''MESA'' ';
              Form1.IbDataSet27.Open;

              sEvidenciaS3 := '';
              while Form1.IbDataSet27.Eof = False do
              begin
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) {or (sEvidenciaP2 = '?')} then
                begin
                  sEvidenciaS3 := '??????????';
                end;
                Form1.IbDataSet27.Next;
              end;

              sCodigo := Form1.ibQuery6.FieldByName('CODIGO').AsString;
              if Trim(Form1.ibQuery6.FieldByName('REFERENCIA').AsString) <> '' then
              begin
                sCodigo := Right('00000000000000' + Form1.ibQuery6.FieldByName('REFERENCIA').AsString, 14);
              end;

              sS2Conta := Copy(RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3)+ sEvidenciaS3 + Replicate(' ', 10), 1, 13);  // Número da mesa/Conta cliente
              if Copy(Form1.sConcomitante,1,2) = 'OS' then
                sS2Conta := Copy(Right(Form1.ibQuery6.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS3 + Replicate(' ', 10), 1, 13);   // Conta cliente OS// Sandro Silva 2017-12-15  sS2Conta := Copy(Right(Replicate('0', 10) + RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3), 10) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);   // Conta cliente OS


              if Pos(sEmitenteEvidenciado, '?') > 0 then
              begin
                sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]); // Conta cliente OS// Sandro Silva 2017-12-15  sS2Conta := Copy(Right(Replicate('0', 10) + RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3), 10) + '??????????' + Replicate(' ', 10), 1, 13);   // Conta cliente OS
              end;

              Writeln(F,  'S3' +                                                          // Tipo S3
                          right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                          FormatDateTime('yyyymmdd', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // Data de abertura
                          FormatDateTime('HHnnss', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime)+ // Hora de abertura
                          sS2Conta + // Sandro Silva 2017-11-09 Polimig  Copy(RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3)+ sEvidenciaS3 + Replicate(' ', 10), 1, 13) + // Número da Mesa/Conta de Cliente // Sandro Silva 2016-03-08 POLIMIG
                          Right('000000000'+sCodigo, 14)+ // Código do produto ou serviço// Sandro Silva 2017-11-07 Polimig  '000000000'+Form1.ibQuery6.FieldByName('CODIGO').AsString+ // Código do produto ou serviço
                          Copy(Form1.ibQuery6.FieldByName('DESCRICAO').AsString+Replicate(' ',100),1,100)+ // Descrição
                          StrZero(Form1.ibQuery6.FieldByName('QUANTIDADE').AsFloat*1000,7,0)+ // Quantidade
                          Copy(Form1.ibQuery6.FieldByName('MEDIDA').AsString+'   ',1,3)+ // Unidade de medida
                          StrZero(Form1.ibQuery6.FieldByName('UNITARIO').AsFloat*100,8,0)+ // Valor unitário
                          '3'+ // Casas decimais da quantidade
                          '2' // Casas decimais de valor unitário
                          );

              Form1.ibQuery6.Next;
            end;
            //
            Form1.ibQuery5.Next;
            //
          end;

        end; // if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date)))

        IBQECF.Next;

      end; // mesas aberta


    end; // if (Copy(Form1.sConcomitante, 1, 2) <> 'OS') then

    //
    // R01
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R01');

    if Form1.bData = False then
    begin

      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 DATA ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' order by DATA desc';
      IBQECF.Open;

      sDataUltimaZ := DateToStr(Date);
      //
      while not IBQECF.EOF do
      begin
        sDataUltimaZ := DatetoStr(IBQECF.FieldByName('DATA').AsDateTime);
        IBQECF.Next;
      end;

    end;

    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select SERIE, TIPOECF, MARCAECF, MODELOECF, max(VERSAOSB) as VERSAOSB, max(DATASB) DATASB, max(HORASB) as HORASB, PDV ' + //, max(ADICIONAL) as ADICIONAL ' +
        'from REDUCOES ' +
        'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
        'and coalesce(SERIE,''XX'') <> ''XX'' ' +
        'group by SERIE, TIPOECF, MARCAECF, MODELOECF, PDV';
      IBQECF.Open;
    end
    else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select SERIE, TIPOECF, MARCAECF, MODELOECF, max(VERSAOSB) as VERSAOSB, max(DATASB) as DATASB, max(HORASB) as HORASB, PDV ' + //, max(ADICIONAL) as ADICIONAL ' +
        'from REDUCOES ' +
        'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
        'and coalesce(SERIE,''XX'') <> ''XX'' ' +
        ' and SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' group by SERIE, TIPOECF, MARCAECF, MODELOECF, PDV';
      IBQECF.Open;
    end;
    IBQECF.First;

    //
    sPDV := 'XXX';
    //
    while not IBQECF.EOF do
    begin
      //
      if IBQECF.FieldByName('SERIE').AsString <> sPDV then
      begin

        Form1.ibDataSet88.Close;
        Form1.ibDataSet88.SelectSql.Clear;
        Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SERIE='+QuotedStr(IBQECF.FieldByName('SERIE').AsString)
        );
        Form1.ibDataSet88.Open;
        Form1.ibDataSet88.First;

        sEvidenciaR01 := '';
        sModeloECFR01 := ''; // Sandro Silva 2017-11-28 Polimig
        sSequencialR01 := IBQECF.FieldByName('PDV').AsString; // Sandro Silva 2017-11-28 Polimig

        while Form1.ibDataSet88.Eof = False do
        begin
          if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then // or (sEvidenciaP2 = '?') then
          begin
            LogFrente('R01 ' + Trim(IBQECF.FieldByName('SERIE').AsString) + ' ECF REDUCOES EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01

            sEvidenciaR01 := '?????????';
            sEcfEvidenciado := sEcfEvidenciado + Trim(IBQECF.FieldByName('SERIE').AsString) + '?';// Sandro Silva 2017-11-13  HOMOLOGA 2017 sEcfEvidenciado := IBQECF.FieldByName('SERIE').AsString + '?';
            sModeloECFR01   := Copy(StrTran(Form1.ibDataSet88.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);// Sandro Silva 2017-11-28 Polimig
            sCRZR01         := LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString);// Sandro Silva 2018-05-28  Form1.ibDataSet88.FieldByName('CONTADORZ').AsString; // Sandro Silva 2017-11-28 Polimig
            sSequencialR01  := Form1.ibDataSet88.FieldByName('PDV').AsString; // Sandro Silva 2017-11-28 Polimig
            Break; // Sandro Silva 2017-11-13  HOMOLOGA 2017  Identificou evidência sai do loop 2017-11-27
          end;
          Form1.ibDataSet88.Next;
        end;

        //
        Form1.LbBlowfish1.GenerateKey(Form1.sPasta);
        Mais1ini := TIniFile.Create(Form1.sArquivo);

        Form1.ibDataSet88.Close;
        Form1.ibDataSet88.SelectSql.Clear;
        Form1.ibDataSet88.SelectSQL.Text :=
          'select first 1 * ' +
          'from REDUCOES ' +
          'where coalesce(DATASB, '''') <> '''' ' +
          ' and SERIE = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' order by DATA desc';
        Form1.ibDataSet88.Open;
        Form1.ibDataSet88.First;

        sDATASB := ''; // Sandro Silva 2019-07-02

        if Length(Form1.ibDataSet88.FieldByName('DATASB').AsString) = 6 then
          sDATASB := Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 1, 2) + '/' + Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 3, 2) + '/' + '20' + Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 5, 2)
        else
          if Length(Form1.ibDataSet88.FieldByName('DATASB').AsString) = 8 then
            sDATASB := Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 1, 2) + '/' + Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 3, 2) + '/' + Copy(Form1.ibDataSet88.FieldByName('DATASB').AsString, 5, 4);
        try
          sDATASB := FormatDateTime('yyyymmdd', StrToDateDef(sDATASB, StrToDate('01/01/2000'))); // Sandro Silva 2021-08-11 sDATASB := FormatDateTime('yyyymmdd', StrToDate(sDATASB));
        except
          sDATASB := '20000101';
        end;


        //sMarcaE3  listar a marca da ecf do E3
        // Marca do ECF para R01 que listado no E3
        sMarcaR01   := Trim(IBQECF.FieldByName('MARCAECF').AsString);
        sTipoECFR01 := Trim(IBQECF.FieldByName('TIPOECF').AsString); // Sandro Silva 2017-11-28 Polimig
        if sNumeroSerieEcfE3 = IBQECF.FieldByName('SERIE').AsString then
        begin
          sMarcaR01 := sMarcaE3; // Marca ecf do R1 igual a marca do ecf em E3
          sTipoECFR01 := sTipoECFE3; // Sandro Silva 2017-11-28 Polimig
        end;

        sRPModeloECF := Copy(AllTrim(IBQECF.FieldByName('MODELOECF').AsString)+Replicate(' ',20),1,20);// Sandro Silva 2017-11-13  HOMOLOGA 2017 sModeloECF := Copy(AllTrim(IBQECF.FieldByName('MODELOECF').AsString)+Replicate(' ',20),1,20);
        if Pos('?', sEvidenciaR01) > 0 then
        begin
          //LogFrente('R01 ' + IBQECF.FieldByName('SERIE').AsString + ' sEvidenciaR01 EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
          sRPModeloECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);// Sandro Silva 2017-11-13  HOMOLOGA 2017 sModeloECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);
        end;
        if Pos('?', sModeloECFR01) > 0 then
        begin
          //LogFrente('R01 ' + IBQECF.FieldByName('SERIE').AsString + ' sModeloECFR01 EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
          sRPModeloECF := Copy(StrTran(sModeloECFR01, ' ', '?')+Replicate(' ',20),1,20);; // Sandro Silva 2017-11-28 Polimig
        end;

        Form1.CDSR01.Append;
        Form1.CDSR01SERIE.AsString      := IBQECF.FieldByName('SERIE').AsString;
        Form1.CDSR01MODELOECF.AsString  := sRPModeloECF;
        Form1.CDSR01CRZ.AsString        := sCRZR01;
        Form1.CDSR01SEQUENCIAL.AsString := sSequencialR01;
        Form1.CDSR01.Post;

        //
        Writeln(F,  'R01' +                                                          // Tipo R01
                    Copy(IBQECF.FieldByName('SERIE').AsString+Replicate(' ',20),1,20)+    // Número de fabricação do ECF Ok
                    ' '+                                                             // Letra indicativa de memória adicional
                    Copy(AllTrim(sTipoECFR01)+Replicate(' ',7),1,7)+       // Tipo de ECF// Sandro Silva 2017-11-10 Polimig  Copy(AllTrim(IBQECF.FieldByName('TIPOECF').AsString)+sEvidenciaR01+Replicate(' ',7),1,7)+       // Tipo de ECF// Sandro Silva 2017-11-28 Polimig  Copy(AllTrim(IBQECF.FieldByName('TIPOECF').AsString)+Replicate(' ',7),1,7)+       // Tipo de ECF// Sandro Silva 2017-11-10 Polimig  Copy(AllTrim(IBQECF.FieldByName('TIPOECF').AsString)+sEvidenciaR01+Replicate(' ',7),1,7)+       // Tipo de ECF
                    Copy(AllTrim(sMarcaR01)+Replicate(' ',20),1,20)+ // MARCA ECF Sandro Silva 2017-11-13  HOMOLOGA 2017  Copy(AllTrim(IBQECF.FieldByName('MARCAECF').AsString)+Replicate(' ',20),1,20)+// Sandro Silva 2017-11-10 Polimig  Copy(AllTrim(IBQECF.FieldByName('MARCAECF').AsString)+sEvidenciaR01+Replicate(' ',20),1,20)+    // Marca do ECF
                    Copy(AllTrim(sRPModeloECF)+Replicate(' ',20),1,20)+ // Modelo do ECF // Sandro Silva 2017-11-13  HOMOLOGA 2017 Copy(AllTrim(IBQECF.FieldByName('MODELOECF').AsString)+sEvidenciaR01+Replicate(' ',20),1,20) +   // Modelo do ECF
                    Copy(IBQECF.FieldByName('VERSAOSB').AsString+Replicate(' ',10),1,10)+// Sandro Silva 2017-11-10 Polimig  Copy(IBQECF.FieldByName('VERSAOSB').AsString+sEvidenciaR01+Replicate(' ',10),1,10)+ // Versão do Software Basico
                    sDATASB+     // Data de instalação do SB AAAA    AAAAMMDD
                    Copy(IBQECF.FieldByName('HORASB').AsString+Replicate(' ',6),1,6)+     // Hora de instalação do SB
                    RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)+        // Número sequencial do ECF
                    RightStr('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do usuário
                    Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) +  // IE do usuário
                    Right(Replicate('0',14)+ LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF),14) + // CNPJ da desenvolvedora 2015-11-13 independente do cripta
                    Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // IE da desenvolvedora 2015-11-13
                    Copy(IM_SOFTWARE_HOUSE_PAF + Replicate(' ',14), 1, 14) + // IM da desenvolvedora 2015-11-13
                    Copy(Form1.sRazaoSocialSmallsoft+Replicate(' ',40),1,40) + // Denominação da empresa desenvolvedora
                    Copy('SMALL COMMERCE'+Replicate(' ',40),1,40) + // Nome do PAF ECF
                    Copy(StrTran(Form22.sBuild,'Versão e Build: ','')+Replicate(' ',10),1,10) + // Versão do PAF ECF
                    Copy(Form1.sMD5DaLista+Replicate(' ',32),1,32) + // MD5 da lista
                    FormatDateTime('yyyymmdd', Form7.DateTimePicker1.Date) + // AAAAMMDD  Inicial
                    FormatDateTime('yyyymmdd', Form7.DateTimePicker2.Date) + // AAAAMMDD Final
                    LimpaNumero(VERSAO_ER_PAF_ECF)
                    );
                    //
                    // Ok
                    //

        Mais1Ini.Free;
        //
        sPDV := IBQECF.FieldByName('SERIE').AsString;
        //
      end;
      //
      IBQECF.Next;
      //
    end;

    //
    // R02
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R02');
    if Form1.bData then
    begin
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSql.Clear;
      // Sandro Silva 2021-08-11 Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and coalesce(SERIE,''XX'')<>''XX'' and DATA>='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' order by SERIE, PDV, DATA');
      Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' and coalesce(SERIE,''XX'')<>''XX'' and DATA>='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' order by SERIE, PDV, DATA');
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
    end else
    begin
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSql.Clear;
      Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SERIE='+QuotedStr(Form1.sNumeroDeSerieDaImpressora)+' and DATA='+QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ');
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
    end;
    //
    // sPDV := 'XXX';
    //
    sDTMoviReducao := '';
    sEcfReducao    := '';
    while not Form1.ibDataSet88.EOF do
    begin
      //
      if (Form1.ibDataSet88.FieldByName('DATA').AsString <> sDTMoviReducao)
        or (Form1.ibDataSet88.FieldByName('SERIE').AsString <> sEcfReducao) then
      begin
        sDTMoviReducao := Form1.ibDataSet88.FieldByName('DATA').AsString;
        sEcfReducao    := Form1.ibDataSet88.FieldByName('SERIE').AsString;
        //
        try
          if Form1.ibDataSet88.FieldByName('CUPOMF').AsString <> '' then
          begin
            //
            sEvidencia := ' ';
            //
            if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
              sEvidencia := '?';

            // ECF esta evidenciada
            Form1.IBDataSet38.Close;
            Form1.IBDataSet38.SelectSQL.Text :=
              'select first 1 * ' +
              'from DEMAIS ' +
              'where ECF = ' + QuotedStr(Form1.ibDataSet88.FieldByName('SERIE').AsString) +
              ' and COO >= ' + QuotedStr(Form1.ibDataSet88.FieldByName('CUPOMF').AsString) +
              ' and DENOMINACAO = ''RZ'' ' +
              ' order by DATA, HORA';
            Form1.IBDataSet38.Open;

            if Form1.ibDataSet38.FieldByName('REGISTRO').AsString <> '' then // Sandro Silva 2016-09-01
            begin
              if not AssinaRegistro('DEMAIS',Form1.ibDataSet38, False) then
                sEvidencia := '?';
            end;

            if sEvidencia = '?' then
              sModelo_ECF := Copy(StrTran(Form1.ibDataSet88.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
            else
              sModelo_ECF := Copy(Form1.ibDataSet88.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

            sSequencialR01 := Trim(Form1.ibDataSet88.FieldByName('PDV').AsString);
            if Form1.CDSR01.Locate('SERIE', Form1.ibDataSet88.FieldByName('SERIE').AsString, []) then
            begin
              if (Pos('?', Form1.CDSR01.FieldByName('MODELOECF').AsString) > 0) and (Trim(Form1.CDSR01.FieldByName('CRZ').AsString) = LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)) then // Sandro Silva 2018-05-28  if (Pos('?', Form1.CDSR01MODELOECF.AsString) > 0) and (Trim(Form1.CDSR01CRZ.AsString) = Trim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)) then
                sModelo_ECF := Copy(StrTran(Form1.CDSR01.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);
              if (Pos('?', Form1.CDSR01.FieldByName('MODELOECF').AsString) > 0) and (sSequencialR01 <> Trim(Form1.CDSR01.FieldByName('SEQUENCIAL').AsString)) then // Sandro Silva 2018-05-28 Assim evidencia quando ECF tem o número do caixa trocado depois de fazer vendas em um período //if sSequencialR01 <> Trim(Form1.CDSR01SEQUENCIAL.AsString) then
                sModelo_ECF := Copy(StrTran(Form1.CDSR01.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);
              sSequencialR01 := Trim(Form1.CDSR01.FieldByName('SEQUENCIAL').AsString);
            end;

            if Pos('?', sModelo_ECF) > 0 then
              sCRZEvidenciadoR02 := sCRZEvidenciadoR02 + Form1.ibDataSet88.FieldByName('SERIE').AsString + LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?';// Sandro Silva 2018-05-28  sCRZEvidenciadoR02 := sCRZEvidenciadoR02 + Form1.ibDataSet88.FieldByName('SERIE').AsString + Trim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?';

            if Form1.IBDataSet38.FieldByName('DATA').AsString = '' then
              sDataEmissaoRZR2 := FormatDateTime('yyyymmdd', Form1.ibDataSet88.FieldByName('DATA').AsDateTime) // Sandro Silva 2017-10-05
            else
              sDataEmissaoRZR2 := FormatDateTime('yyyymmdd', Form1.IBDataSet38.FieldByName('DATA').AsDateTime); // Sandro Silva 2017-10-05

            if LimpaNumero(Form1.IBDataSet38.FieldByName('HORA').AsString) = '' then
              sHoraEmissaoRZR2 := LimpaNumero(Form1.ibDataSet88.FieldByName('HORA').AsString) // Sandro Silva 2017-10-05
            else
              sHoraEmissaoRZR2 := LimpaNumero(Form1.IBDataSet38.FieldByName('HORA').AsString); // Sandro Silva 2017-10-05

            //
            Writeln(F,  'R02' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+          // MF Adidional
                        sModelo_ECF+   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário// Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 Right('000' + '01', 2) + // Número do usuário// Sandro Silva 2017-11-10 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z// Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CUPOMF').AsString)),9,0)     +  // COO - Cupom Final
                        StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('ALIQUOTA16').AsString)),6,0) +  // CRO - Número de intervenções técnicas
                        //
                        FormatDateTime('yyyymmdd', Form1.ibDataSet88.FieldByName('DATA').AsDateTime) + // AAAAMMDD Data da Reducao
                        //
                        sDataEmissaoRZR2 + // Sandro Silva 2017-10-05  FormatDateTime('yyyymmdd', Form1.IBDataSet38.FieldByName('DATA').AsDateTime) + // AAAAMMDD  Data da emissão da RZ
                        //
                        sHoraEmissaoRZR2 + // Sandro Silva 2017-10-05  LimpaNumero(Form1.IBDataSet38.FieldByName('HORA').AsString) + // HHMMSS HORA da emissão da RZ
                        //
                        StrZero(((Form1.ibDataSet88.FieldByName('TOTALF').AsFloat - Form1.ibDataSet88.FieldByName('TOTALI').AsFloat)*100),14,0)+ // Venda Bruta Diária
                        'N'); // Desconto no ISQN
                        //
                        // OK
                        //
          end;
        except end;
        //
        //
      end;
      //
      Form1.ibDataSet88.Next;
      //
    end;

    //
    // R03
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R03');
        
    if Form1.bData then
    begin
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSql.Clear;
      // Sandro Silva 2021-08-11 Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and coalesce(SERIE,''XX'')<>''XX'' and DATA>='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' order by SERIE, PDV, DATA');
      Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' and coalesce(SERIE,''XX'')<>''XX'' and DATA>='+QuotedStr(DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' order by SERIE, PDV, DATA');
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
    end else
    begin
      Form1.ibDataSet88.Close;
      Form1.ibDataSet88.SelectSql.Clear;
      Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SERIE='+QuotedStr(Form1.sNumeroDeSerieDaImpressora)+' and DATA='+QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ');
      Form1.ibDataSet88.Open;
      Form1.ibDataSet88.First;
    end;
    //

    // 6.23.1.1. Deve ser criado um registro tipo R03 para cada totalizador parcial constante na Redução Z emitida pelo ECF no período
    // informado no arquivo, observando-se o disposto no item 2 do requisito XXVI.

    sPDV := 'XXX';
    sR03DataReducao := 'dd/mm/yyyy';
    //
    while not Form1.ibDataSet88.EOF do
    begin
      //
      if (Form1.ibDataSet88.FieldByName('SERIE').AsString + Form1.ibDataSet88.FieldByName('PDV').AsString <> sPDV) // Sandro Silva 2018-05-28  if (Form1.ibDataSet88.FieldByName('PDV').AsString <> sPDV)
        or (FormatDateTime('dd/mm/yyyy', Form1.ibDataSet88.FieldByName('DATA').AsDateTime) <> sR03DataReducao) then
      begin
        //
        if Form1.ibDataSet88.FieldByName('CUPOMF').AsString <> '' then
        begin
          //
          sEvidencia := ' ';
          //
          if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
            sEvidencia := '?';

          if sEvidencia = '?' then
            sModelo_ECF := Copy(StrTran(Form1.ibDataSet88.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
          else
            sModelo_ECF := Copy(Form1.ibDataSet88.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

          sSequencialR01 := Trim(Form1.ibDataSet88.FieldByName('PDV').AsString);
          if Form1.CDSR01.Locate('SERIE', Form1.ibDataSet88.FieldByName('SERIE').AsString, []) then
          begin
            if (Pos('?', Form1.CDSR01.FieldByName('MODELOECF').AsString) > 0) and (Trim(Form1.CDSR01.FieldByName('CRZ').AsString) = LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)) then// Sandro Silva 2018-05-28  if (Pos('?', Form1.CDSR01MODELOECF.AsString) > 0) and (Trim(Form1.CDSR01CRZ.AsString) = Trim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)) then
              sModelo_ECF := Copy(StrTran(Form1.CDSR01.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);
            if (Pos('?', Form1.CDSR01.FieldByName('MODELOECF').AsString) > 0) and (sSequencialR01 <> Trim(Form1.CDSR01.FieldByName('SEQUENCIAL').AsString)) then// Sandro Silva 2018-05-28 Assim evidencia quando ECF tem o número do caixa trocado depois de fazer vendas em um período //if sSequencialR01 <> Trim(Form1.CDSR01SEQUENCIAL.AsString) then
              sModelo_ECF := Copy(StrTran(Form1.CDSR01.FieldByName('MODELOECF').AsString, ' ', '?')+Replicate(' ',20),1,20);
            sSequencialR01 := Trim(Form1.CDSR01.FieldByName('SEQUENCIAL').AsString);
          end;

          //
          for I := 1 to 15 do
          begin
            //
            if Form1.ibDataSet88.FieldByName('ALIQUOTA'+StrZero(I,2,0)).AsFloat <> 0 then
            begin
              if sAliqISSQN <> Form1.ibDataSet88.FieldByName('ALIQU'+StrZero(I,2,0)).AsString then // 2015-09-17
              begin // Não é ISS
                //
                Writeln(F,  'R03' + // Tipo
                            Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                            ' '+ // MF Adidional
                            sModelo_ECF +   // Modelo do ECF
                            Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                            StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z// Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                            Strzero(I,2,0)+'T'+Form1.ibDataSet88.FieldByName('ALIQU'+Strzero(I,2,0)).AsString + // totalizador parcial
                            StrZero(Form1.ibDataSet88.FieldByName('ALIQUOTA'+Strzero(I,2,0)).AsFloat*100,13,0)); // Valor Acumulado
              end;
            end;
          end;
          //
          if Form1.ibDataSet88.FieldByName('CANCELAMEN').AsFloat <> 0 then  // Descontos
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'Can-T  ' + // totalizador parcial
                        StrZero(Form1.ibDataSet88.FieldByName('CANCELAMEN').AsFloat*100,13,0)); // Valor Acumulado
          end;
          //
          if Form1.ibDataSet88.FieldByName('DESCONTOS').AsFloat <> 0 then  // Descontos
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'DT     ' + // totalizador parcial
                        StrZero(Form1.ibDataSet88.FieldByName('DESCONTOS').AsFloat*100,13,0)); // Valor Acumulado
          end;
          //
          if Form1.ibDataSet88.FieldByName('ALIQUOTA19').AsFloat <> 0 then  // Substituição
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'F1     ' + // totalizador parcial
                        StrZero(Form1.ibDataSet88.FieldByName('ALIQUOTA19').AsFloat*100,13,0)); // Valor Acumulado
          end;
          //
          if Form1.ibDataSet88.FieldByName('ALIQUOTA17').Asfloat <> 0 then  // Isenção
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'I1     ' + // totalizador parcial
                        StrZero(Form1.ibDataSet88.FieldByName('ALIQUOTA17').AsFloat*100,13,0)); // Valor Acumulado
          end;
          //
          if Form1.ibDataSet88.FieldByName('ALIQUOTA18').AsFloat <> 0 then  // Não Incidência
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z// Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'N1     ' + // totalizador parcial
                        StrZero(Form1.ibDataSet88.FieldByName('ALIQUOTA18').AsFloat*100,13,0)); // Valor Acumulado
          end;

          {Sandro Silva 2022-12-03 Início Unochapeco
          //
          // Acréscimo
          IBQR03.Close;
          IBQR03.SQL.Text :=
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from REDUCOES R ' +
            'left join ALTERACA A on (A.PEDIDO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'')) ' +
            'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and A.DESCRICAO = ''Acréscimo'' ' +
            ' and A.TIPO <> ''CANCEL'' ' +
            ' and coalesce(A.ALIQUICM, '''') <> ''ISS'' ' +
            ' and A.REGISTRO is not null ' +
            'union ' +
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from ALTERACA A ' +
            'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
            ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and A.DESCRICAO = ''Acréscimo'' ' +
            ' and A.TIPO <> ''CANCEL'' ' +
            ' and coalesce(A.ALIQUICM, '''') <> ''ISS'' ' +
            ' and A.REGISTRO is not null ' +
            'order by 2, 1';
          IBQR03.Open;

          dR03Acrescimo := 0;

          while IBQR03.Eof = False do
          begin

            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select sum(TOTAL) as ACRESCIMO ' +
              'from ALTERACA ' +
              'where DESCRICAO = ''Acréscimo'' ' +
              ' and TIPO <> ''CANCEL'' ' +
              ' and coalesce(ALIQUICM, '''') <> ''ISS'' ' +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString) +
              ' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString);
            IBQECF.Open;

            dR03Acrescimo := dR03Acrescimo + IBQECF.FieldByName('ACRESCIMO').AsFloat;

            IBQR03.Next;
          end;

          if dR03Acrescimo > 0 then
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        IfThen(Pos('?', sMarcaR03Acrescimo) > 0, StringReplace(sModelo_ECF, ' ', '?', [rfReplaceAll]) , sModelo_ECF)  +   // Modelo do // Sandro Silva 2022-12-03 Unochapeco sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z// Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'AT     '+ // Acréscimo ICMS
                        StrZero(dR03Acrescimo*100,13,0)); // Valor Acumulado
          end;
          }

          //
          // Acréscimo R03
          //
          //Seleciona os pedidos com acréscimo
          IBQR03.Close;
          IBQR03.SQL.Text :=
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from REDUCOES R ' +
            'left join ALTERACA A on (A.PEDIDO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'')) ' +
            //'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            'where R.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet88.FieldByName('DATA').AsDateTime)) + ' and R.SERIE = ' + QuotedStr(Form1.ibDataSet88.FieldByName('SERIE').AsString) +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and A.DESCRICAO = ''Acréscimo'' ' +
            ' and A.TIPO <> ''CANCEL'' ' +
            ' and coalesce(A.ALIQUICM, '''') <> ''ISS'' ' +
            ' and A.REGISTRO is not null ' +
            'union ' +
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from ALTERACA A ' +
            // 'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            'where A.PEDIDO between ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMI').AsString), 6)) + ' and ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMF').AsString), 6)) +
            ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
            ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and A.DESCRICAO = ''Acréscimo'' ' +
            ' and A.TIPO <> ''CANCEL'' ' +
            ' and coalesce(A.ALIQUICM, '''') <> ''ISS'' ' +
            ' and A.REGISTRO is not null ' +
            'order by 2, 1';
          IBQR03.Open;

          dR03Acrescimo := 0;
          sMarcaR03Acrescimo := ''; // Sandro Silva 2022-12-03 Unochapeco

          while IBQR03.Eof = False do
          begin

            {
            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select sum(TOTAL) as ACRESCIMO ' +
              'from ALTERACA ' +
              'where DESCRICAO = ''Acréscimo'' ' +
              ' and TIPO <> ''CANCEL'' ' +
              ' and coalesce(ALIQUICM, '''') <> ''ISS'' ' +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString) +
              ' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString);
            IBQECF.Open;

            dR03Acrescimo := dR03Acrescimo + IBQECF.FieldByName('ACRESCIMO').AsFloat;
            }


            // seleciona cada acréscimos para analisar assinatura
            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              //'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
              'where PEDIDO between ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMI').AsString), 6)) + ' and ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMF').AsString), 6)) +
              ' and DESCRICAO = ''Acréscimo'' ' +
              ' and TIPO <> ''CANCEL'' ' +
              ' and coalesce(ALIQUICM, '''') <> ''ISS'' ' +
              //' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString);
            IBQECF.Open;

            while IBQECF.Eof = False do
            begin
              if not AssinaRegistro('ALTERACA', IBQECF, False) then
                 sMarcaR03Acrescimo := '?';
              dR03Acrescimo := dR03Acrescimo + IBQECF.FieldByName('TOTAL').AsFloat;

              IBQECF.Next;
            end;

            IBQR03.Next;
          end;

          if dR03Acrescimo > 0 then
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        IfThen(Pos('?', sMarcaR03Acrescimo) > 0, StringReplace(sModelo_ECF, ' ', '?', [rfReplaceAll]) , sModelo_ECF)  +   // Modelo do ECF // Sandro Silva 2022-12-03 Unochapeco sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z// Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'AT     '+ // Acréscimo ICMS
                        StrZero(dR03Acrescimo*100,13,0)); // Valor Acumulado
          end;
          sMarcaR03Acrescimo := '';
          {Sandro Silva 2022-12-03 Final Unochapeco}

          {Sandro Silva 2022-12-03 Início Unochapeco
          //
          // SANGRIA SUPRIMENTO
          //
          IBQR03.Close;
          IBQR03.SQL.Text :=
            'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
            'from REDUCOES R ' +
            'left join PAGAMENT P on (P.PEDIDO between R.CUPOMI and R.CUPOMF and P.DATA between R.DATA and R.DATA + 1 and P.CAIXA = R.PDV) ' +
            'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and P.REGISTRO is not null ' +
            ' union ' +
            'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
            'from PAGAMENT P ' +
            'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
            ' and P.REGISTRO is not null ' +
            ' order by 2, 1 ';
          IBQR03.Open;

          dR03OPNF := 0.00;
          while IBQR03.Eof = False do
          begin

            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select sum(P.VALOR) as OPNF ' +
              'from PAGAMENT P ' +
              'where (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString) +
              ' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString);
            IBQECF.Open;
            dR03OPNF := dR03OPNF + IBQECF.FieldByName('OPNF').AsFloat;

            IBQR03.Next;
          end; // while IBQ.Eof = False do


          if dR03OPNF > 0 then
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'OPNF   '+ // Operações não fiscais
                        StrZero(dR03OPNF*100,13,0)); // Valor Acumulado
          end;
          }

          //
          // SANGRIA SUPRIMENTO
          //
          IBQR03.Close;
          IBQR03.SQL.Text :=
            'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
            'from REDUCOES R ' +
            'left join PAGAMENT P on (P.PEDIDO between R.CUPOMI and R.CUPOMF and P.DATA between R.DATA and R.DATA + 1 and P.CAIXA = R.PDV) ' +
            //'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            'where R.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet88.FieldByName('DATA').AsDateTime)) + ' and R.SERIE = ' + QuotedStr(Form1.ibDataSet88.FieldByName('SERIE').AsString) +
            ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and P.REGISTRO is not null ' +
            ' union ' +
            'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
            'from PAGAMENT P ' +
            //'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            'where P.PEDIDO between ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMI').AsString), 6)) + ' and ' + QuotedStr(RightStr('000000' + Trim(Form1.ibDataSet88.FieldByName('CUPOMF').AsString), 6)) +
            ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 3)) +
            ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
            ' and P.REGISTRO is not null ' +
            ' order by 2, 1 ';
          IBQR03.Open;

          dR03OPNF := 0.00;
          sMarcaR03OPNF := ''; // Sandro Silva 2022-12-03 Unochapeco
          while IBQR03.Eof = False do
          begin
            {
            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select sum(P.VALOR) as OPNF ' +
              'from PAGAMENT P ' +
              'where (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString) +
              ' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString);
            IBQECF.Open;
            dR03OPNF := dR03OPNF + IBQECF.FieldByName('OPNF').AsFloat;
            }
            IBQECF.Close;
            IBQECF.SQL.Text :=
              'select P.* ' +
              'from PAGAMENT P ' +
              'where (coalesce(P.CLIFOR, ''X'') = ''Sangria'' or coalesce(P.CLIFOR, ''X'') = ''Suprimento'') ' +
              ' and CAIXA = ' + QuotedStr(Form1.ibDataSet88.FieldByName('PDV').AsString) +
              ' and PEDIDO = ' + QuotedStr(IBQR03.FieldByName('PEDIDO').AsString);
            IBQECF.Open;
            while IBQECF.Eof = False do
            begin
              if not AssinaRegistro('PAGAMENT', IBQECF, False) then
                 sMarcaR03OPNF := '?';

              dR03OPNF := dR03OPNF + IBQECF.FieldByName('VALOR').AsFloat;
              IBQECF.Next;
            end;                                              

            IBQR03.Next;
          end; // while IBQ.Eof = False do


          if dR03OPNF > 0 then
          begin
            Writeln(F,  'R03' + // Tipo
                        Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        IfThen(Pos('?', sMarcaR03OPNF) > 0, StringReplace(sModelo_ECF, ' ', '?', [rfReplaceAll]) , sModelo_ECF)  +   // Modelo do ECF // Sandro Silva 2022-12-03 Unochapeco sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                        'OPNF   '+ // Operações não fiscais
                        StrZero(dR03OPNF*100,13,0)); // Valor Acumulado
          end;
          sMarcaR03OPNF := '';
          {Sandro Silva 2022-12-03 Final Unochapeco}

          for I := 1 to 15 do
          begin
            //
            if Form1.ibDataSet88.FieldByName('ALIQUOTA'+StrZero(I,2,0)).AsFloat <> 0 then
            begin
              if sAliqISSQN = Form1.ibDataSet88.FieldByName('ALIQU'+StrZero(I,2,0)).AsString then // 2015-09-17
              begin // Não é ISS
                //
                Writeln(F,  'R03' + // Tipo
                            Copy(Form1.ibDataSet88.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                            ' '+ // MF Adidional
                            sModelo_ECF +   // Modelo do ECF
                            Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.ibDataSet88.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                            StrZero(StrToInt('0'+LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z // Sandro Silva 2018-05-28  StrZero(StrToInt('0'+Alltrim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString)),6,0)  +  // Contador Z
                            '01S'+Form1.ibDataSet88.FieldByName('ALIQU'+Strzero(I,2,0)).AsString + // totalizador parcial
                            StrZero(Form1.ibDataSet88.FieldByName('ALIQUOTA'+Strzero(I,2,0)).AsFloat*100,13,0)); // Valor Acumulado
              end;
            end;
          end;

        end;
        //
        sPDV := Form1.ibDataSet88.FieldByName('SERIE').AsString + Form1.ibDataSet88.FieldByName('PDV').AsString;// Sandro Silva 2018-05-28  sPDV := Form1.ibDataSet88.FieldByName('PDV').AsString;
        sR03DataReducao := FormatDateTime('dd/mm/yyyy', Form1.ibDataSet88.FieldByName('DATA').AsDateTime);
        //
      end;
      //
      Form1.ibDataSet88.Next;
      //
    end;

    //********************
    //
    // R04 INÍCIO
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R04');

    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text := SELECT_ECF;
      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    //
    sPDV := 'XXX';
    //
    while not IBQECF.EOF do
    begin
      //
      if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then // Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
      begin

        // R04 dos cupons abertos e cancelados sem nenhum item
        Form1.IbDataSet100.Close;
        Form1.IbDataSet100.SelectSql.Clear;
        Form1.IbDataSet100.SelectSQL.Text :=
          'select distinct D.REGISTRO, D.COO, D.DATA, D.ECF, D.CCF, D.DENOMINACAO ' +
          'from REDUCOES R ' +
          'left join DEMAIS D on (D.COO between R.CUPOMI and R.CUPOMF and D.DATA between R.DATA and R.DATA + 1 and D.ECF = R.SERIE) ' +
          'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
          ' and D.ECF = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' and D.DENOMINACAO = ''NC'' ' +
          ' and D.REGISTRO is not null ' +
          'union ' +
          'select distinct D.REGISTRO, D.COO, D.DATA, D.ECF, D.CCF, D.DENOMINACAO ' +
          'from DEMAIS D ' +
          'where D.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and D.COO > coalesce((select max(R.CUPOMF) from REDUCOES R where R.SERIE= D.ECF and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99''), '''') ' + // Sandro Silva 2021-08-11 ' and D.COO > coalesce((select max(R.CUPOMF) from REDUCOES R where R.SERIE= D.ECF and R.SMALL <> ''59'' and R.SMALL <> ''65''), '''') ' +
          ' and D.ECF = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' and D.DENOMINACAO = ''NC'' ' +
          ' and D.REGISTRO is not null ' +
          ' order by 4, 2'; // ordena por ECF e COO
        Form1.IbDataSet100.Open;
        Form1.IbDataSet100.First;

        while Form1.IbDataSet100.Eof = False do
        begin

          // Dados da RZ
          Form1.ibDataSet88.Close;
          Form1.ibDataSet88.SelectSQL.Text :=
            'select * ' +
            'from REDUCOES ' +
            'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
            ' and cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) + ' as integer) between cast(CUPOMI as integer) and cast(CUPOMF as integer) + 1 ';
          Form1.ibDataSet88.Open;

          Form1.IbDataSet27.Close;
          Form1.IbDataSet27.SelectSQL.Clear;
          Form1.IbDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where (TIPO = ''BALCAO'' or TIPO = ''LOKED'' or TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02 'where (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
            ' and PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3));// + ' ' +
          Form1.IbDataSet27.Open;

          if Form1.IbDataSet27.FieldByName('PEDIDO').AsString = '' then
          begin // Cupom cancelado sem itens lançados
            sCancel := 'S';
            sTipoDesconto := ' ';
            sTipoAcrescimo := ' ';
            sDescontoOuAcrescimo := ' ';

            sModelo_ECF := Copy(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

            //////
            ////// Registro referente ao cupom aberto e fechado sem item que foi cancelado, denominação 'NC'
            /////

            Form1.IBDataSet38.Close;
            Form1.IBDataSet38.SelectSQL.Text :=
              'select * ' +
              'from DEMAIS ' +
              'where REGISTRO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('REGISTRO').AsString);
            Form1.IBDataSet38.Open;

            if Form1.ibDataSet38.FieldByName('REGISTRO').AsString <> '' then // Sandro Silva 2016-09-01
            begin
              if not AssinaRegistro('DEMAIS',Form1.ibDataSet38, False) then
                sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20), ' ', '?'),1,20);
            end;

            sSequencialR01 := Trim(IBQECF.FieldByName('PDV').AsString);

            if Pos(IBQECF.FieldByName('SERIE').AsString + LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then // Sandro Silva 2018-05-28  if Pos(IBQECF.FieldByName('SERIE').AsString + Trim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then
              sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);

            //
            Writeln(F,  'R04' + // Tipo
                        Copy(IBQECF.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// CUPONS CANCELADOS NÃO TEM REGISTROS NO ALTERACA Número do usuário// Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 2) +// CUPONS CANCELADOS NÃO TEM REGISTROS NO ALTERACA Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+Form1.IbDataSet100.FieldByName('CCF').AsString),9,0)+ // CCF, ?CVC ou CBP conforme o documento emitido
                        StrZero(StrToInt('0'+Form1.IbDataSet100.FieldByName('COO').AsString),9,0)+ // COO relativo ao respectivo documento
                        FormatDateTime('yyyymmdd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime) + // AAAAMMDD Data da emissao
                        StrZero(0, 14, 0)+ // SubTotal
                        StrZero(0, 13, 0)+ // Desconto
                        sTipoDesconto+ // Sandro Silva 2016-03-01 'V'+ // Tipo de desconto
                        StrZero(0, 13, 0)+ // Acréscimo
                        sTipoAcrescimo + // Sandro Silva 2016-03-01 'V'+ // Tipo de Acréscimo
                        StrZero(0, 14, 0)+ // Valor total liquido
                        sCancel+ // Indicador de cancelamento
                        StrZero(0, 13,0)+ // Cancelamento de acréscimo
                        sDescontoOuAcrescimo + // Sandro Silva 2016-03-01 'D'+
                        Replicate(' ', 40) + // Nom do Cliente Cliente
                        Replicate('0',14) // CNPJ do Cliente
                        );
          end;
          Form1.IbDataSet100.Next;
        end; // while Form1.IbDataSet100.Eof = False do

        // Cupons aberto com itens lançados
        IBQR04.Close;
        IBQR04.SQL.Text :=
          'select distinct A.PEDIDO, A.CAIXA ' +
          'from REDUCOES R ' +
          'left join ALTERACA A on (A.PEDIDO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'')) ' +
          'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
          ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and A.REGISTRO is not null ' +
          'union ' +
          'select distinct A.PEDIDO, A.CAIXA ' +
          'from ALTERACA A ' +
          'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
          ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
          ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and A.REGISTRO is not null ' +
          'order by 2, 1';
        IBQR04.Open;

        while IBQR04.Eof = False do
        begin

          Form1.IbDataSet100.Close;
          Form1.IbDataSet100.SelectSql.Clear;
          Form1.IbDataSet100.SelectSQL.Text :=
            'select cast(sum(A1.TOTAL) as numeric(15,3)) as SUBTOTAL, A1.DATA, A1.PEDIDO, A1.CCF, max(coalesce(A1.CLIFOR, '''')) as CLIFOR, max(coalesce(A1.CNPJ, '''')) as CNPJ ' +
            ', A1.CAIXA ' + // Sandro Silva 2017-11-13  HOMOLOGA 2017
            'from ALTERACA A1 ' +
            'where (A1.TIPO = ''BALCAO'' or A1.TIPO = ''LOKED'' or A1.TIPO = ''CANCEL'' or A1.TIPO = ''CANLOK'' or A1.TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02 'where (A1.TIPO = ''BALCAO'' or A1.TIPO = ''CANCEL'') ' +
            ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and A1.PEDIDO = ' + QuotedStr(IBQR04.FieldByName('PEDIDO').AsString) +
            ' and A1.DESCRICAO <> ''Desconto'' ' +
            ' and A1.DESCRICAO <> ''Acréscimo'' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' +  // 2015-11-05 Não listar os descontos dos itens cancelados
            ' group by A1.DATA, A1.PEDIDO, A1.CCF ' +
            ', A1.CAIXA ' + // Sandro Silva 2017-11-13  HOMOLOGA 2017
            'order by DATA';
          Form1.IbDataSet100.Open;

          Form1.IbDataSet100.First;
          //
          // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
          //
          while not Form1.IbDataSet100.Eof do
          begin

            // Dados da RZ
            Form1.ibDataSet88.Close;
            Form1.ibDataSet88.SelectSQL.Text :=
              'select * ' +
              'from REDUCOES ' +
              'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
              ' and cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) + ' as integer) between cast(CUPOMI as integer) and cast(CUPOMF as integer) + 1 ';
            Form1.ibDataSet88.Open;

            // Itens cancelados no cupom
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as CANCELADOS ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and (TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02
              ' and DESCRICAO = ''<CANCELADO>'' ' +
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
            Form1.ibDataSet999.Open;

            dItemCancelado := Form1.ibDataSet999.FieldByName('CANCELADOS').AsFloat;

            //
            // Desconto no total do cupom
            //
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as DESCONTO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)); // + ' ' +
            Form1.ibDataSet999.Open;
            //
            //
            rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

            //
            // Desconto nos itens
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as DESCONTO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
              ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)); // + ' ' +
            Form1.ibDataSet999.Open;

            dDescontoItem := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

            //
            // Acréscimo
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as ACRESCIMO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)); // + ' ' +
            Form1.ibDataSet999.Open;
            //
            rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
            //
            Form1.IbDataSet27.Close;
            Form1.IbDataSet27.SelectSQL.Clear;
            Form1.IbDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'' or TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3));// + ' ' +
            Form1.IbDataSet27.Open;
            Form1.IbDataSet27.DisableControls;
            //
            sEvidencia := ' ';
            //
            Form1.IbDataSet27.First;
            while not Form1.IbDataSet27.Eof do
            begin
              if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
              begin
                //          SmallMsg('Registro: '+Form1.IbDataSet27.FieldByName('REGISTRO').AsString);
                sEvidencia := '?';
              end;
              Form1.IbDataSet27.Next;
            end;
            Form1.IbDataSet27.EnableControls; // Sandro Silva 2020-11-06

            if Pos(AnsiUpperCase(Trim(IBQECF.FieldByName('SERIE').AsString) + '?'), AnsiUpperCase(sEcfEvidenciado)) > 0 then
              sEvidencia := '?';

            //
            if sEvidencia = '?' then
              sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20) // Sandro Silva 2017-11-13  HOMOLOGA 2017 sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
            else
              sModelo_ECF := Copy(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

            sSequencialR01 := Trim(Form1.IbDataSet100.FieldByName('CAIXA').AsString);

            if Pos(IBQECF.FieldByName('SERIE').AsString + LimpaNumero(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then // Sandro Silva 2018-05-28  if Pos(IBQECF.FieldByName('SERIE').AsString + Trim(Form1.ibDataSet88.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then
              sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);

            //Identificar em qual RZ o COO do CUPOM Pertence
            if Pos('?', sModelo_ECF) = 0 then
            begin
              Form1.ibDataSet88.Close;
              Form1.ibDataSet88.SelectSQL.Text :=
                'select * ' +
                'from REDUCOES ' +
                'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
                'and ( (cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) + ' as integer) between cast(CUPOMI as integer) and cast(CUPOMF as integer)) ' +
                  'or  (cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) + ' as integer) between cast(CUPOMI as integer) and cast(CUPOMF as integer) + 1))';
              Form1.ibDataSet88.Open;
              while Form1.ibDataSet88.Eof = False do
              begin
                if (StrToIntDef(Form1.IbDataSet100.FieldByName('PEDIDO').AsString, 0) >= StrToIntDef(Form1.ibDataSet88.FieldByName('CUPOMI').AsString, 0))
                  and (StrToIntDef(Form1.IbDataSet100.FieldByName('PEDIDO').AsString, 0) <= StrToIntDef(Form1.ibDataSet88.FieldByName('CUPOMF').AsString, 0)) then
                begin
                  if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
                  begin
                    sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);
                  end;
                end;
                Form1.ibDataSet88.Next;
              end;
            end;

            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
            'select first 1 TIPO ' +
            'from ALTERACA A1 ' +
            'where (A1.TIPO = ''BALCAO'' or A1.TIPO = ''LOKED'' or A1.TIPO = ''CANCEL'' or A1.TIPO = ''CANLOK'' or A1.TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02 'where A1.TIPO = ''BALCAO'' ' +
            ' and A1.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
            ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and A1.PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
            ' and A1.DESCRICAO <> ''Desconto'' ' +
            ' and A1.DESCRICAO <> ''Acréscimo'' ';
            Form1.ibDataSet999.Open;

            if (Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'BALCAO') or  (Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'LOKED') then // Sandro Silva 2019-05-02 if Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'BALCAO' then
              sCancel := 'N'
            else
              sCancel := 'S';

            sDescontoOuAcrescimo := ' ';
            sTipoAcrescimo := ' ';
            if rAcrescimo > 0 then
            begin
              sTipoAcrescimo := 'V';
              sDescontoOuAcrescimo := 'A';
            end;

            sTipoDesconto := ' ';
            if rDesconto > 0 then
            begin
              sTipoDesconto := 'V';
              sDescontoOuAcrescimo := 'D';
            end;

            //
            if Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat = 0 then
              sCancel := 'S';

            dR04SubTotal := Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat*100; // Sandro Silva 2017-11-09 Polimig Truncar valor para sair igual total item no cupom (ecf truncando)
            dR04SubTotal := int(dR04SubTotal) / 100; // Sandro Silva 2017-11-09 Polimig Truncar valor para sair igual total item no cupom (ecf truncando)
            dR04TotalLiquido := dR04SubTotal - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado; // Sandro Silva 2018-06-14
            if dR04TotalLiquido < 0 then // Sandro Silva 2018-06-14
              dR04TotalLiquido := 0;

            //aqui antes de gerar no arquivo
            dR04SubTotal := dR04SubTotal - dDescontoItem - dItemCancelado;
            if dR04SubTotal < 0 then
              dR04SubTotal := 0.00;

            //
            Writeln(F,  'R04' + // Tipo
                        Copy(IBQECF.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                        ' '+ // MF Adidional
                        sModelo_ECF +   // Modelo do ECF
                        Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.IbDataSet100.FieldByName('CAIXA').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                        StrZero(StrToInt('0'+Form1.IbDataSet100.FieldByName('CCF').AsString),9,0)+ // CCF, ?CVC ou CBP conforme o documento emitido
                        StrZero(StrToInt('0'+Form1.IbDataSet100.FieldByName('PEDIDO').AsString),9,0)+ // COO relativo ao respectivo documento
                        FormatDateTime('yyyymmdd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime) + // AAAAMMDD Data da emissao
                        StrZero((dR04SubTotal * 100), 14, 0)+ // SubTotal// Sandro Silva 2019-09-10 ER 02.06 UnoChapeco StrZero(((dR04SubTotal - dDescontoItem - dItemCancelado) * 100), 14, 0)+ // SubTotal// Sandro Silva 2017-11-09 Polimig  StrZero(((Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado) * 100), 14, 0)+ // SubTotal
                        StrZero(((rDesconto) * 100), 13, 0)+ // Desconto
                        sTipoDesconto+ // Sandro Silva 2016-03-01 'V'+ // Tipo de desconto
                        StrZero(((rAcrescimo) * 100), 13, 0)+ // Acréscimo
                        sTipoAcrescimo + // Sandro Silva 2016-03-01 'V'+ // Tipo de Acréscimo
                        StrZero((dR04TotalLiquido * 100), 14, 0)+ // Sandro Silva 2018-06-14  StrZero((((dR04SubTotal - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado)) * 100), 14, 0)+ // Valor total liquido// Sandro Silva 2017-11-09 Polimig  StrZero((((Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado)) * 100), 14, 0)+ // Valor total liquido
                        sCancel+ // Indicador de cancelamento
                        StrZero(((0)*100),13,0)+ // Cancelamento de acréscimo
                        sDescontoOuAcrescimo + // Sandro Silva 2016-03-01 'D'+
                        Copy(Form1.IbDataSet100.FieldByName('CLIFOR').AsString+Replicate(' ',40),1,40) + // Nom do Cliente Cliente
                        Right(Replicate('0',14)+Limpanumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString),14)); // CNPJ do Cliente
            Form1.IbDataSet100.Next;
          end;
          IBQR04.Next;
        end; // while IBQR04.Eof = False do
        //
        sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString; // Sandro Silva 2018-05-28   sPDV := IBQECF.FieldByName('PDV').AsString;
        //
      end;
      //
      IBQECF.Next;
      //
    end;

    //
    // R04 FIM
    //
    //************************


    //************************
    //
    // R05 INÍCIO
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R05');    
    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text := SELECT_ECF;

      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    //
    sPDV := 'XXX';
    //

    while not IBQECF.EOF do
    begin
      //
      if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then // Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
      begin
        IBQALIQUOTASR05.Close;
        IBQALIQUOTASR05.SQL.Text :=
          'select * ' +
          'from REDUCOES ' +
          'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
          ' and coalesce(SERIE, ''XX'') = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' and DATA <= ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
          ' order by DATA desc';
        IBQALIQUOTASR05.Open;
        IBQALIQUOTASR05.First;
        //

        IBQR04.Close;
        IBQR04.SQL.Text :=
          'select distinct A.PEDIDO, A.CAIXA ' +
          'from REDUCOES R ' +
          'left join ALTERACA A on (A.PEDIDO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'')) ' +
          'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
          ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and A.REGISTRO is not null ' +
          'union ' +
          'select distinct A.PEDIDO, A.CAIXA ' +
          'from ALTERACA A ' +
          'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'' or A.TIPO = ''CANCEL'' or A.TIPO = ''CANLOK'' or A.TIPO = ''KOLNAC'') ' +
          ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
          ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and A.REGISTRO is not null ' +
          ' order by 2, 1';
        IBQR04.Open;

        while IBQR04.Eof = False do
        begin

          Form1.IbDataSet27.Close;
          Form1.IbDataSet27.SelectSql.Clear;
          Form1.IbDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where PEDIDO = ' + QuotedStr(IBQR04.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'' or TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02 ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
            ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
            'order by DATA, CCF, ITEM';
          Form1.IbDataSet27.Open;

          Form1.IbDataSet27.First;
          //
          while not Form1.IbDataSet27.Eof do
          begin
            //
            if (Alltrim(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) <> '')
              and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
              and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
            begin
              //
              fQTD_CANCEL := 0;
              fVAL_CANCEL := 0;
              //
              sTabela := 'I1     ';
              //
              for I := 1 to 15 do
              begin
                //
                if IBQALIQUOTASR05.FieldByName( 'ALIQU'+StrZero(I,2,0) ).AsString = Form1.IbDataSet27.FieldByName( 'ALIQUICM').AsString then
                begin
                  sTabela := Strzero(I,2,0)+'T'+IBQALIQUOTASR05.FieldByName('ALIQU'+Strzero(I,2,0)).AsString;  // totalizador parcial
                end;
              end;

              //
              if Pos('I',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'I1     ';
              if Pos('F',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'F1     ';
              if Pos('N',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'N1     ';

              if Copy(Form1.IbDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
              begin
                sTabela := '01S' + sAliqISSQN;
              end;

              //
              sCancel := 'N';
              if (Pos('<CANCELADO>', Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
              begin
                // Se o cupom foi cancelado o item deve ficar como "N"
                // Se o item foi cancelado deve ficar como "S"
                sCancel := 'S';
                fQTD_CANCEL := 0.00;
                fVAL_CANCEL := 0.00;
              end;

              sEvidencia := ' ';
              if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                sEvidencia := '?';

              // Desconto do item
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select * ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) +
                ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                ' and ITEM = ' + QuotedStr(Form1.IbDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet27.FieldByName('DATA').AsDateTime)) +
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3));// + ' ' +
              Form1.ibDataSet999.Open;
              //
              //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
              //
              dDescontoItem := 0.00;
              if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then // Sandro Silva 2016-03-08 POLIMIG
                dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1; // Sandro Silva 2016-03-08 POLIMIG

              if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                   sEvidencia := '?';


              if sEvidencia <> '?' then
              begin
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + // + ' ' +
                  ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'' or TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') ' + // Sandro Silva 2019-05-02
                  ' and coalesce(CODIGO, '''') = '''' ';
                Form1.ibDataSet999.Open;
                while Form1.ibDataSet999.Eof = False do
                begin
                  if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                  begin
                    // DESCONTO DO ITEM ou DO CUPOM
                    if (Form1.ibDataSet999.FieldByName('ITEM').AsString = '') or (Form1.ibDataSet999.FieldByName('ITEM').AsString = Form1.IbDataSet27.FieldByName('ITEM').AsString) then
                      sEvidencia := '?';
                   Break;
                  end;
                  Form1.ibDataSet999.Next;
                end;

              end;

              sDescricaoItem := Form1.IbDataSet27.FieldByName('DESCRICAO').AsString;

              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select DESCRICAO, CEST, CF ' +
                'from ESTOQUE ' +
                'where CODIGO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('CODIGO').AsString);
              Form1.ibDataSet999.Open;

              if (Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
              begin
                sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
              end;

              if Form1.sImprimirCEST = 'Sim' then // Sandro Silva 2019-09-11 ER 02.06 UnoChapeco
                sDescricaoItem := '#' + Trim(Form1.ibDataSet999.FieldByName('CEST').AsString) + '#' + Trim(Form1.ibDataSet999.FieldByName('CF').AsString) + '#' + sDescricaoItem; // Sandro Silva 2017-11-07 Polimig
              //

              if Pos(AnsiUpperCase(Trim(IBQECF.FieldByName('SERIE').AsString) + '?'), AnsiUpperCase(sEcfEvidenciado)) > 0 then
                sEvidencia := '?';

              // Para IAT se evidenciar o estoque, evidencia aqui também
              Form1.IbDataSet4.Close;
              Form1.IbDataSet4.SelectSQL.Text :=
                'select * ' +
                'from ESTOQUE ' +
                'where CODIGO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('CODIGO').AsString);
              Form1.IbDataSet4.Open;

              if Form1.IbDataSet4.FieldByName('REGISTRO').AsString <> '' then
              begin
                if not AssinaRegistro('ESTOQUE',Form1.IbDataSet4, False) then
                  sEvidencia := '?';
              end;

              if sEvidencia = '?' then
                sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
              else
                sModelo_ECF := Copy(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

              // Modelo do ECF listado no E3 para lista no R05
              //
              try

                sR05CasasQtd   := '2';
                sR05Quantidade := StrZero((( Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat )*100),7,0);
                if AnsiUpperCase(Form1.IbDataSet27.FieldByName('MEDIDA').AsString) = 'KG' then
                begin
                  sR05CasasQtd   := '3';
                  sR05Quantidade := StrZero((( Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat )*1000),7,0)
                end;

                dR05Total := int((Form1.IbDataSet27.FieldByName('TOTAL').AsFloat * 100)) / 100; // Sandro Silva 2017-11-09 Polimig Truncar valor para sair igual total item no cupom (ecf truncando)

                Writeln(F,  'R05' + // Tipo
                            Copy(IBQECF.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                            ' '+ // MF Adidional
                            sModelo_ECF +   // Modelo do ECF
                            Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(Form1.IbDataSet27.FieldByName('CAIXA').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                            StrZero(StrToInt('0'+Form1.IbDataSet27.FieldByName('PEDIDO').AsString),9,0)+ // COO relativo ao respectivo documento
                            StrZero(StrToInt('0'+Form1.IbDataSet27.FieldByName('CCF').AsString),9,0)+ // CCF, ?CVC ou CBP conforme o documento emitido
                            StrZero(StrToInt('0'+Form1.IbDataSet27.FieldByName('ITEM').AsString),3,0)  + // Número do iten
                            Copy(Form1.IbDataSet27.FieldByName('REFERENCIA').AsString+Replicate(' ',14),1,14)  + // Referencia
                            Copy(sDescricaoItem+Replicate(' ',100),1,100) + // Descricao
                            sR05Quantidade + // Quantidade // Sandro Silva 2017-11-09 Polimig  StrZero((( Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat )*100),7,0)  + // Quantidade
                            Copy(Form1.IbDataSet27.FieldByName('MEDIDA').AsString+Replicate(' ',3),1,3) + // Medida
                            StrZero((( Form1.IbDataSet27.FieldByName('UNITARIO').AsFloat )*100),8,0)+ // Unitário
                            StrZero(((dDescontoItem )*100),8,0)+ // Desconto do item
                            StrZero(0,8,0)+ // Acréscimo
                            StrZero(((dR05Total - dDescontoItem)*100),14,0)+ // Total// Sandro Silva 2017-11-09 Polimig  StrZero(((Form1.IbDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem)*100),14,0)+ // Total
                            sTabela + // Tabela totalizador Parcial
                            sCancel + // Indicador de cancelamento
                            StrZero(((fQTD_CANCEL  )*100),7,0)+ // Quantidade cancelada
                            StrZero(((fVAL_CANCEL  )*100),13,0)+ // Valor cancelado
                            StrZero((( 0  )*100),13,0)+ // Acréscimo cancelado
                            Copy(Alltrim(Form1.IbDataSet4.FieldByName('IAT').AsString)+Replicate('T',1),1,1) + // Indicador de arredondamento ou truncamento
                            Copy(AllTrim(Form1.IbDataSet4.FieldByName('IPPT').AsString)+Replicate('T',1),1,1) + // Indicador de arredondamento ou truncamento
                            sR05CasasQtd+ // Sandro Silva 2017-11-09 Polimig  '2'+ // Casas decimais na quantidade
                            '2'); // Casas decimais no valor unitário
                //
                //          R5 := R5 + 1;
                //
              except
                SmallMsg('Erro ao criar registro R5');
              end;
            end;

            Form1.IbDataSet27.Next;

          end; // while not Form1.IbDataSet27.Eof do

          IBQR04.Next;
          
        end; // while IBQR04.Eof = False do
        //
        sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString; // Sandro Silva 2018-05-28  sPDV := IBQECF.FieldByName('PDV').AsString;
        //
      end;
      //
      IBQECF.Next;
      //
    end;
    //
    // R05 FINAL
    //
    //****************

    //****************
    //
    // R06 INÍCIO
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R06');
    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct R1.SERIE ' +
        ',(select first 1 R3.PDV from REDUCOES R3 where R3.SERIE = R1.SERIE and coalesce(R3.PDV, ''XX'') <> ''XX'' order by R3.REGISTRO desc) as PDV ' +
        ',(select first 1 R4.MODELOECF from REDUCOES R4 where R4.SERIE = R1.SERIE order by R4.REGISTRO desc) as MODELOECF ' +
        'from REDUCOES R1 ' +
        ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' and R1.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' where R1.SMALL <> ''59''  and R1.SMALL <> ''65'' ' +
        ' and coalesce(R1.SERIE, ''XX'') <> ''XX'' ' +
        ' and coalesce(R1.PDV, ''XX'') <> ''XX'' ' +
        ' group by R1.SERIE ' +
        'order by PDV';
      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    //
    sPDV := 'XXX';
    //
    while not IBQECF.EOF do
    begin
      //
      if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then// Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
      begin

        IBQR06.Close;
        IBQR06.SQL.Text :=
          'select distinct D.COO, D.DATA, D.ECF, D.DENOMINACAO ' +
          'from REDUCOES R ' +
          'left join DEMAIS D on (D.COO between R.CUPOMI and R.CUPOMF and D.DATA between R.DATA and R.DATA + 1 and D.ECF = R.SERIE) ' +
          ' where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11    ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
          ' and D.ECF = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' and D.REGISTRO is not null ' +
          ' union ' +
          'select distinct D.COO, D.DATA, D.ECF, D.DENOMINACAO ' +
          'from DEMAIS D ' +
          'where D.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and D.COO >= coalesce((select first 1 R.CUPOMF from REDUCOES R where R.SERIE= D.ECF and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and D.COO >= coalesce((select first 1 R.CUPOMF from REDUCOES R where R.SERIE= D.ECF and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
          ' and D.ECF = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
          ' and D.REGISTRO is not null ' +
          ' order by  3, 1';
        IBQR06.Open;

        while IBQR06.Eof = False do
        begin
          //
          Form1.IbDataSet100.Close;
          Form1.IbDataSet100.SelectSQL.Clear;
          Form1.IbDataSet100.SelectSql.Add(
            'select * ' +
            'from DEMAIS ' +
            'where ECF = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString)+
            ' and COO = ' + QuotedStr(IBQR06.FieldByName('COO').AsString)+
            ' and DENOMINACAO <> ''NC'' ' + //não gerar registro 'NC' quando cancelar cupom fiscal emitido por completo
            ' order by COO'); //
          Form1.IbDataSet100.Open;

          Form1.IbDataSet100.First;
          //
          while not Form1.IbDataSet100.Eof do
          begin
            //
            sEvidencia := ' ';
            if not AssinaRegistro('DEMAIS',Form1.IbDataSet100, False) then
              sEvidencia := '?';

        //      SmallMsg('Teste '+sEvidencia);
            if sEvidencia = '?' then
              sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20)
            else
              sModelo_ECF := Copy(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

             // Dados da RZ
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select * ' +
              'from REDUCOES ' +
              'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
              ' and cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) + ' as integer) between cast(CUPOMI as integer) and cast(CUPOMF as integer) + 1 ';
            Form1.ibDataSet999.Open;

            sSequencialR01 := Trim(IBQECF.FieldByName('PDV').AsString);

            if Pos(IBQECF.FieldByName('SERIE').AsString + LimpaNumero(Form1.ibDataSet999.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then// Sandro Silva 2018-05-28  if Pos(IBQECF.FieldByName('SERIE').AsString + Trim(Form1.ibDataSet999.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then
              sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);

            //
            try
              sGRG := Form1.IbDataSet100.FieldByName('GRG').AsString;
              if StrToIntDef(Copy(Form1.IbDataSet100.FieldByName('CDC').AsString, 1, 2), 90)> 0 then
                sCDC := Copy(Form1.IbDataSet100.FieldByName('CDC').AsString, 1, 2) + Right(Form1.IbDataSet100.FieldByName('CDC').AsString, 2)
              else
                sCDC := Right(Form1.IbDataSet100.FieldByName('CDC').AsString, 4);
              sGNF := Form1.IbDataSet100.FieldByName('GNF').AsString; // 2015-10-06
              if (Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) <> 'RG')
                and (Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) <> 'CM') then
                sGRG := '000000';

              if Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) <> 'CC' then
                sCDC := '0000';

              // 2015-10-06 GNF deve ser 000000 para LX, RZ e MF
              if (Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) = 'LX')
                or (Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) = 'RZ')
                or (Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) = 'MF') then
                sGNF := '000000';

              //não gerar registro 'NC' quando cancelar cupom fiscal emitido por completo
              Writeln(F,  'R06' + // Tipo
                          Copy(IBQECF.FieldByName('SERIE').AsString+Replicate(' ',20),1,20) + // Número de fabricação
                          ' '+ // MF Adidional
                          sModelo_ECF +   // Modelo do ECF
                          Right('000' + Trim(sSequencialR01), 2) +// Número do usuário // Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                          StrZero(Abs(StrToIntDef(Form1.IbDataSet100.FieldByName('COO').AsString, 0)), 9, 0) + // Contador de Ordem de Operacao
                          StrZero(Abs(StrToIntDef(sGNF, 0)), 6, 0) + // Contador Geral de Operação Não Fiscal
                          StrZero(Abs(StrToIntDef(sGRG, 0)), 6, 0) + // Contador Geral de Relatório Gerencial
                          StrZero(Abs(StrToIntDef(sCDC, 0)), 4, 0) + // Contador de Comprovante Debito e Credito
                          Copy(Form1.IbDataSet100.FieldByName('DENOMINACAO').AsString, 1, 2) + // Simbolo referente a denominação do documento fiscal
                          FormatDateTime('yyyymmdd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime) + // AAAAMMDD Data Final da Emissão
                          LimpaNumero(Form1.IbDataSet100.FieldByName('HORA').AsString)); // Hora Final da emissão
            except
              SmallMsg('Erro ao criar registro R06');
            end;
            //
            Form1.IbDataSet100.Next;
            //
          end; // while not Form1.IbDataSet100.Eof do

          IBQR06.Next;

        end; // while IBQR06.Eof = False do
        //
        sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString; // Sandro Silva 2018-05-28  sPDV := IBQECF.FieldByName('PDV').AsString;
        //
      end;
      //
      IBQECF.Next;
      //
    end;
    //
    // R06 FINAL
    //
    //*********************

    //*********************
    //
    // R07   INICIO
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-ECF” - R07');
    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text := SELECT_ECF;
      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    //
    sPDV := 'XXX';
    //
    while not IBQECF.EOF do
    begin
      //
      if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then// Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
      begin

        IBQR07.Close;
        IBQR07.SQL.Text :=
          'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
          'from REDUCOES R ' +
          'left join PAGAMENT P on (P.PEDIDO between R.CUPOMI and R.CUPOMF and P.DATA between R.DATA and R.DATA + 1 and P.CAIXA = R.PDV) ' +
          'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
          ' and P.REGISTRO is not null ' +
          ' union ' +
          'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
          'from PAGAMENT P ' +
          'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and P.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and P.PEDIDO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = P.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
          ' and P.REGISTRO is not null ' +
          ' order by 2, 1 ';
        IBQR07.Open;

        while IBQR07.Eof = False do
        begin
          //
          Form1.IbDataSet100.Close;
          Form1.IbDataSet100.SelectSQL.Clear;
          Form1.IbDataSet100.SelectSql.Text :=
            'select * ' +
            'from PAGAMENT ' +
            'where CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and PEDIDO = ' + QuotedStr(IBQR07.FieldByName('PEDIDO').AsString) +
            ' order by CAIXA, PEDIDO'; // and caixa = dsad juntar os valore
          Form1.IbDataSet100.Open;
          Form1.IbDataSet100.First;
          //
          while not Form1.IbDataSet100.Eof do
          begin
            //
            if (UpperCase(AllTrim(Copy(Form1.IbDataSet100.FieldByName('FORMA').AsString+Replicate(' ',40),4,27) )) <> 'TOTAL')
              and (UpperCase(AllTrim(Copy(Form1.IbDataSet100.FieldByName('FORMA').AsString+Replicate(' ',40),4,27) )) <> 'TROCO')
              and (UpperCase(AllTrim(Form1.IbDataSet100.FieldByName('CLIFOR').AsString)) <> 'SUPRIMENTO')
              and (UpperCase(AllTrim(Form1.IbDataSet100.FieldByName('CLIFOR').AsString)) <> 'SANGRIA')
              then
            begin
              //
              // Procura pra ver se não foi cancelado
              //

              //
              sEvidencia := ' ';
              if not AssinaRegistro('PAGAMENT',Form1.IbDataSet100, False) then
                sEvidencia := '?';

              Form1.IbDataSet27.Close;
              Form1.IbDataSet27.SelectSQL.Clear;
              Form1.IbDataSet27.SelectSQL.Add('select * from ALTERACA where PEDIDO='+QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString)+'');
              Form1.IbDataSet27.Open;
              //
              Form1.ibDataSet99.Close;
              Form1.ibDataSet99.SelectSQL.Clear;
              Form1.ibDataSet99.SelectSql.Text :=
                'select sum(TOTAL) as TOTAL ' +
                'from ALTERACA ' +
                'where PEDIDO='+QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString)+
                ' and (TIPO = ''CANCEL'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'') '; // Sandro Silva 2019-05-02               ' and TIPO = ''CANCEL'' ';
              Form1.ibDataSet99.Open;
              Form1.ibDataSet99.First;
              dEstornoCancelado := Form1.ibDataSet99.FieldByName('TOTAL').AsFloat;

              Form1.ibDataSet99.Close;
              Form1.ibDataSet99.SelectSQL.Clear;
              Form1.ibDataSet99.SelectSql.Text :=
                'select sum(TOTAL) as TOTAL ' +
                'from ALTERACA ' +
                'where PEDIDO='+QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString)+
                ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') '; // Sandro Silva 2019-05-02               ' and TIPO = ''BALCAO'' ';
              Form1.ibDataSet99.Open;
              Form1.ibDataSet99.First;

              sCancel := 'N';
              dEstorno := 0.00;
              if Form1.ibDataSet99.FieldByName('TOTAL').AsFloat = 0 then
              begin
                sCancel := 'S';
                dEstorno := dEstornoCancelado;
              end;

              while Form1.IbDataSet27.Eof = False do
              begin
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then // Sandro Silva 2016-03-08 POLIMIG
                begin
                  sEvidencia := '?';
                  Break;
                end;
                Form1.IbDataSet27.Next
              end;

              if Pos(AnsiUpperCase(Trim(IBQECF.FieldByName('SERIE').AsString) + '?'), AnsiUpperCase(sEcfEvidenciado)) > 0 then
                sEvidencia := '?';

              if sEvidencia = '?' then sModelo_ECF := Copy(StrTran(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),' ',sEvidencia),1,20) else
                                       sModelo_ECF := Copy(IBQECF.FieldByName('MODELOECF').AsString+Replicate(' ',20),1,20);

              // Dados da RZ
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select * ' +
                'from REDUCOES ' +
                'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
                ' and cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) + ' as integer) between cast(coalesce(CUPOMI, ''000001'') as integer) and cast(CUPOMF as integer) + 1 ';
              Form1.ibDataSet999.Open;

              sSequencialR01 := Trim(IBQECF.FieldByName('PDV').AsString);

              if Pos(IBQECF.FieldByName('SERIE').AsString + LimpaNumero(Form1.ibDataSet999.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then// Sandro Silva 2018-05-28  if Pos(IBQECF.FieldByName('SERIE').AsString + Trim(Form1.ibDataSet999.FieldByName('CONTADORZ').AsString) + '?', sCRZEvidenciadoR02) > 0 then
                sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);

              //Identificar em qual RZ o COO do CUPOM Pertence
              if Pos('?', sModelo_ECF) = 0 then
              begin
                Form1.ibDataSet88.Close;
                Form1.ibDataSet88.SelectSQL.Text :=
                  'select * ' +
                  'from REDUCOES ' +
                  'where SERIE = ' + QuotedStr(Trim(IBQECF.FieldByName('SERIE').AsString)) +
                  'and ( (cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) + ' as integer) between cast(coalesce(CUPOMI, ''000001'') as integer) and cast(CUPOMF as integer)) ' +
                    'or  (cast(' + QuotedStr(Form1.IbDataSet100.FieldByName('COO').AsString) + ' as integer) between cast(coalesce(CUPOMI, ''000001'') as integer) and cast(CUPOMF as integer) + 1))';
                Form1.ibDataSet88.Open;
                while Form1.ibDataSet88.Eof = False do
                begin
                  if (StrToIntDef(Form1.IbDataSet100.FieldByName('COO').AsString, 0) >= StrToIntDef(Form1.ibDataSet88.FieldByName('CUPOMI').AsString, 0))
                    and (StrToIntDef(Form1.IbDataSet100.FieldByName('COO').AsString, 0) <= StrToIntDef(Form1.ibDataSet88.FieldByName('CUPOMF').AsString, 0)) then
                  begin
                    if not AssinaRegistro('REDUCOES',Form1.ibDataSet88, False) then
                    begin
                      sModelo_ECF := Copy(StrTran(sModelo_ECF, ' ', '?')+Replicate(' ',20),1,20);
                    end;
                  end;
                  Form1.ibDataSet88.Next;
                end;
              end;

              //
              try
                sGNF := Form1.IbDataSet100.FieldByName('GNF').AsString;

                sFormaR07 := StringReplace(AnsiUpperCase(Form1.IbDataSet100.FieldByName('FORMA').AsString), 'A PRAZO', 'PRAZO', [rfReplaceAll]);
                sFormaR07 := StringReplace(AnsiUpperCase(sFormaR07), 'CREDITO', '', [rfReplaceAll]);
                sFormaR07 := StringReplace(AnsiUpperCase(sFormaR07), 'DEBITO', '', [rfReplaceAll]);

                Writeln(F,  'R07' + // Tipo
                            Copy(IBQECF.FieldByName('SERIE').AsString + Replicate(' ', 20), 1, 20) + // Número de fabricação
                            ' ' + // MF Adidional
                            sModelo_ECF +   // Modelo do ECF
                            Right('000' + Trim(sSequencialR01), 2) +// Número do usuário// Sandro Silva 2017-11-28 Polimig  Right('000' + Trim(IBQECF.FieldByName('PDV').AsString)+Trim(Form1.IbDataSet100.FieldByName('CAIXA').AsString), 2) +// Número do usuário // Sandro Silva 2017-11-13  HOMOLOGA 2017 '01' + // Número do usuário
                            StrZero(StrToIntDef(Form1.IbDataSet100.FieldByName('COO').AsString, 0), 9, 0) + // COO relativo ao respectivo documento
                            StrZero(StrToIntDef(Form1.IbDataSet100.FieldByName('CCF').AsString, 0), 9, 0) + // CCF, ?CVC ou CBP conforme o documento emitido
                            StrZero(StrToIntDef(sGNF, 0), 6, 0)+ // GNF
                            Copy(sFormaR07+Replicate(' ',15),4,15) + // Meio de pagamento// Sandro Silva 2017-11-07 Polimig  Copy(Form1.IbDataSet100.FieldByName('FORMA').AsString+Replicate(' ',15),4,15) + // Meio de pagamento
                            StrZero(((Form1.IbDataSet100.FieldByName('VALOR').AsFloat) * 100), 13, 0) + // Valor pago
                            sCancel + // Indicador de estorno
                            StrZero(((dEstorno) * 100), 13, 0) // Valor estorno
                            );

              except
                SmallMsg('Erro ao criar registro R07');
              end;
            end;
            //
            Form1.IbDataSet100.Next;
            //
          end;
          //
          IBQR07.Next;
        end; // while IBQR07.Eof = False do
        //
        sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString;// Sandro Silva 2018-05-28  sPDV := IBQECF.FieldByName('PDV').AsString;
        //
      end;
      //
      IBQECF.Next;
      //
    end;
    //
    //
    // R07   FINAL
    //
    //******************************


    //**********************
    //
    // J1 INÍCIO
    //

    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text := SELECT_ECF;
      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    try
      //
      sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
         //
        if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then // Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
        begin

          IBQR04.Close;
          IBQR04.SQL.Text :=
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from REDUCOES R ' +
            'left join ALTERACA A on (A.COO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''VENDA'' or A.TIPO = ''CANCEL'')) ' +
            'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and coalesce(A.SERIE, '''') <> '''' and coalesce(A.COO, '''') <> '''' ' +
            ' and A.REGISTRO is not null ' +
            'union ' +
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from ALTERACA A ' +
            'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and (A.TIPO = ''VENDA'' or A.TIPO = ''CANCEL'') ' +
            ' and A.COO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.COO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and coalesce(A.SERIE, '''') <> '''' and coalesce(A.COO, '''') <> '''' ' +
            ' and A.REGISTRO is not null ' +
            'order by 2, 1';
          IBQR04.Open;

          while IBQR04.Eof = False do
          begin

            //J1 Referente as notas manuais impressas no ecf

            Form1.IbDataSet100.Close;
            Form1.IbDataSet100.SelectSql.Clear;
            Form1.IbDataSet100.SelectSQL.Text :=
              'select sum(A1.TOTAL) as SUBTOTAL, A1.DATA, A1.PEDIDO, A1.SERIE, A1.SUBSERIE, A1.CCF, max(coalesce(A1.CLIFOR, '''')) as CLIFOR, max(coalesce(A1.CNPJ, '''')) as CNPJ ' +
              'from ALTERACA A1 ' +
              'where (A1.TIPO = ''VENDA'' or A1.TIPO = ''CANCEL'') ' +
              ' and coalesce(A1.SERIE, '''') <> '''' and coalesce(A1.COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
              ' and A1.PEDIDO = ' + QuotedStr(IBQR04.FieldByName('PEDIDO').AsString) +
              ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
              ' and A1.DESCRICAO <> ''Desconto'' ' +
              ' and A1.DESCRICAO <> ''Acréscimo'' ' +
              ' and coalesce(CODIGO, '''') <> '''' ' +  // 2015-11-05 Não listar os descontos dos itens cancelados
              ' group by A1.DATA, A1.PEDIDO, A1.SERIE, A1.SUBSERIE, A1.CCF ' +
              'order by DATA';
            Form1.IbDataSet100.Open;

            Form1.IbDataSet100.First;
            //
            // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
            //
            while not Form1.IbDataSet100.Eof do
            begin
              try
                // Itens cancelados no cupom
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select sum(TOTAL) as CANCELADOS ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                  ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                  ' and DESCRICAO = ''<CANCELADO>'' ' +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;

                dItemCancelado := Form1.ibDataSet999.FieldByName('CANCELADOS').AsFloat;

                //
                // Desconto no total do cupom
                //
                //
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select sum(TOTAL) as DESCONTO ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                  ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                  ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                  ' and DESCRICAO = ''Desconto'' ' +
                  ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;
                //
                //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                //
                rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

                //
                // Desconto nos itens
                //
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select sum(TOTAL) as DESCONTO ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                  ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                  ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                  ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
                  ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;

                dDescontoItem := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

                //
                // Acréscimo
                //
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select sum(TOTAL) as ACRESCIMO ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                  ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                  ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                  ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
                  ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + '';
                Form1.ibDataSet999.Open;
                //
                rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
                //
                Form1.IbDataSet27.Close;
                Form1.IbDataSet27.SelectSQL.Clear;
                Form1.IbDataSet27.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                  ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                  ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                  ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + '';
                Form1.IbDataSet27.Open;
                Form1.IbDataSet27.DisableControls;
                //
                sEvidencia := ' ';
                //
                Form1.IbDataSet27.First;
                while not Form1.IbDataSet27.Eof do
                begin
                  if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                  begin
                    //          SmallMsg('Registro: '+Form1.IbDataSet27.FieldByName('REGISTRO').AsString);
                    sEvidencia := '?';
                  end;
                  Form1.IbDataSet27.Next;
                end;
                Form1.IbDataSet27.EnableControls; // Sandro Silva 2020-11-06 

                //Sandro Silva 2017-11-28 inicio Polimig
                if Pos(sEmitenteEvidenciado, '?') > 0 then
                begin
                  sEvidencia := '?';
                end;
                //Sandro Silva 2017-11-28 final Polimig


                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                'select first 1 TIPO ' +
                'from ALTERACA A1 ' +
                'where A1.TIPO = ''VENDA'' ' +
                ' and coalesce(A1.SERIE, '''') <> '''' and coalesce(A1.COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
                ' and A1.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
                ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
                ' and A1.PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and A1.DESCRICAO <> ''Desconto'' ' +
                ' and A1.DESCRICAO <> ''Acréscimo'' ';
                Form1.ibDataSet999.Open;

                if Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'VENDA' then
                  sCancel := 'N'
                else
                  sCancel := 'S';

                sDescontoOuAcrescimo := ' ';
                sTipoAcrescimo       := ' ';
                if rAcrescimo > 0 then
                begin
                  sTipoAcrescimo       := 'V';
                  sDescontoOuAcrescimo := 'A';
                end;

                sTipoDesconto := ' ';
                if rDesconto > 0 then
                begin
                  sTipoDesconto        := 'V';
                  sDescontoOuAcrescimo := 'D';
                end;

                //
                if Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat = 0 then
                  sCancel := 'S';
                //

                bJ1 := False;
                iJ1Posicao := -1; // Sandro Silva 2018-08-29
                for iJ1 := 0 to Length(aJ1) - 1 do
                begin
                  if (aJ1[iJ1].NumeroNF = Form1.IbDataSet100.FieldByName('PEDIDO').AsString)
                    and (aJ1[iJ1].SerieNF = Form1.IbDataSet100.FieldByName('SERIE').AsString)
                    and (aJ1[iJ1].SubSerie = Form1.IbDataSet100.FieldByName('SUBSERIE').AsString)
                    and (aJ1[iJ1].TipoDocumento = '1') then
                  begin
                    bJ1 := True;
                    iJ1Posicao := iJ1;
                  end;
                end;

                if bJ1 = False then
                begin
                  SetLength(aJ1, Length(aJ1) + 1);
                  iJ1Posicao := High(aJ1);

                  aJ1[iJ1Posicao].Tipo                          := 'J1';
                  aJ1[iJ1Posicao].CNPJEmissor                   := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                  aJ1[iJ1Posicao].DataEmissao                   := Form1.IbDataSet100.FieldByName('DATA').AsDateTime;
                  aJ1[iJ1Posicao].DescontoSubTotal              := rDesconto;
                  aJ1[iJ1Posicao].IndicadorTipoDesconto         := sTipoDesconto;
                  aJ1[iJ1Posicao].AcrescimoSubTotal             := rAcrescimo;
                  aJ1[iJ1Posicao].IndicadorTipoAcrescimo        := sTipoAcrescimo;
                  aJ1[iJ1Posicao].IndicadorCancelamento         := sCancel;
                  aJ1[iJ1Posicao].CancelamentoAcrescimoSubtotal := 0.00;
                  aJ1[iJ1Posicao].OrdemAplicacaoDescAcres       := ' ';
                  aJ1[iJ1Posicao].NomeAdquirente                := Form1.IbDataSet100.FieldByName('CLIFOR').AsString;
                  aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString);
                  aJ1[iJ1Posicao].NumeroNF                      := Form1.IbDataSet100.FieldByName('PEDIDO').AsString;
                  aJ1[iJ1Posicao].SerieNF                       := Form1.IbDataSet100.FieldByName('SERIE').AsString;
                  aJ1[iJ1Posicao].SubSerie                      := Form1.IbDataSet100.FieldByName('SUBSERIE').AsString;
                  aJ1[iJ1Posicao].TipoDocumento                 := '1'; // NF emitida Manualmente
                  aJ1[iJ1Posicao].ChaveAcesso                   := DupeString('0', 44);
                end;
                aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado);
                aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
                aJ1[iJ1Posicao].Evidencia         := sEvidencia;

              except
                SmallMsg('Erro ao criar registro J1 NF manual');
              end;

              Form1.IbDataSet100.Next;
            end;

            IBQR04.Next;
          end; // while IBQR04.Eof = False do

          {
          ///////////////////////////////////////////////////////////////////////////////////
          //J1 Referente as notas manuais tela adversa

          Form1.IbDataSet100.Close;
          Form1.IbDataSet100.SelectSql.Clear;
          Form1.IbDataSet100.SelectSQL.Text :=
            'select cast(sum(A1.TOTAL) as numeric(15,3)) as SUBTOTAL, A1.DATA, A1.PEDIDO, A1.SERIE, A1.SUBSERIE, A1.CCF, max(coalesce(A1.CLIFOR, '''')) as CLIFOR, max(coalesce(A1.CNPJ, '''')) as CNPJ ' +
            'from ALTERACA A1 ' +
            'where (A1.TIPO = ''VENDA'' or A1.TIPO = ''CANCEL'') ' +
            ' and coalesce(A1.SERIE, '''') <> '''' and coalesce(A1.COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
            ' and A1.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and A1.DESCRICAO <> ''Desconto'' ' +
            ' and A1.DESCRICAO <> ''Acréscimo'' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' +  // 2015-11-05 Não listar os descontos dos itens cancelados
            ' group by A1.DATA, A1.PEDIDO, A1.SERIE, A1.SUBSERIE, A1.CCF ' +
            'order by DATA';
          Form1.IbDataSet100.Open;
          Form1.IbDataSet100.First;
          //
          // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
          //
          while not Form1.IbDataSet100.Eof do
          begin
            try
              // Itens cancelados no cupom
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as CANCELADOS ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
                ' and DESCRICAO = ''<CANCELADO>'' ' +
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
              Form1.ibDataSet999.Open;

              dItemCancelado := Form1.ibDataSet999.FieldByName('CANCELADOS').AsFloat;

              //
              // Desconto no total do cupom
              //
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as DESCONTO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
                ' and DESCRICAO = ''Desconto'' ' +
                ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
              Form1.ibDataSet999.Open;
              //
              //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
              //
              rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

              //
              // Desconto nos itens
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as DESCONTO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
                ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
                ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
              Form1.ibDataSet999.Open;

              dDescontoItem := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

              //
              // Acréscimo
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as ACRESCIMO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
                ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
                ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + '';
              Form1.ibDataSet999.Open;
              //
              rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
              //
              Form1.IbDataSet27.Close;
              Form1.IbDataSet27.SelectSQL.Clear;
              Form1.IbDataSet27.SelectSQL.Text :=
                'select * ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' + // Sandro Silva 2017-08-08
                ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
                ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + '';
              Form1.IbDataSet27.Open;
              Form1.IbDataSet27.DisableControls;
              //
              sEvidencia := ' ';
              //
              Form1.IbDataSet27.First;
              while not Form1.IbDataSet27.Eof do
              begin
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                begin
                  //          SmallMsg('Registro: '+Form1.IbDataSet27.FieldByName('REGISTRO').AsString);
                  sEvidencia := '?';
                end;
                Form1.IbDataSet27.Next;
              end;


              //Sandro Silva 2017-11-28 inicio Polimig
              if Pos(sEmitenteEvidenciado, '?') > 0 then
              begin
                sEvidencia := '?';
              end;
              //Sandro Silva 2017-11-28 final Polimig


              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
              'select first 1 TIPO ' +
              'from ALTERACA A1 ' +
              'where A1.TIPO = ''VENDA'' ' +
              ' and coalesce(A1.SERIE, '''') <> '''' and coalesce(A1.COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
              ' and A1.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
              ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
              ' and A1.PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and A1.DESCRICAO <> ''Desconto'' ' +
              ' and A1.DESCRICAO <> ''Acréscimo'' ';
              Form1.ibDataSet999.Open;

              if Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'VENDA' then
                sCancel := 'N'
              else
                sCancel := 'S';

              sDescontoOuAcrescimo := ' ';
              sTipoAcrescimo       := ' ';
              if rAcrescimo > 0 then
              begin
                sTipoAcrescimo       := 'V';
                sDescontoOuAcrescimo := 'A';
              end;

              sTipoDesconto := ' ';
              if rDesconto > 0 then
              begin
                sTipoDesconto        := 'V';
                sDescontoOuAcrescimo := 'D';
              end;

              //
              if Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat = 0 then
                sCancel := 'S';
              //

              bJ1 := False;
              iJ1Posicao := -1; // Sandro Silva 2018-08-29
              for iJ1 := 0 to Length(aJ1) - 1 do
              begin
                if (aJ1[iJ1].NumeroNF = Form1.IbDataSet100.FieldByName('PEDIDO').AsString)
                  and (aJ1[iJ1].SerieNF = Form1.IbDataSet100.FieldByName('SERIE').AsString)
                  and (aJ1[iJ1].SubSerie = Form1.IbDataSet100.FieldByName('SUBSERIE').AsString)
                  and (aJ1[iJ1].TipoDocumento = '1') then
                begin
                  bJ1 := True;
                  iJ1Posicao := iJ1;
                end;
              end;

              if bJ1 = False then
              begin
                SetLength(aJ1, Length(aJ1) + 1);
                iJ1Posicao := High(aJ1);

                aJ1[iJ1Posicao].Tipo                          := 'J1';
                aJ1[iJ1Posicao].CNPJEmissor                   := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ1[iJ1Posicao].DataEmissao                   := Form1.IbDataSet100.FieldByName('DATA').AsDateTime;
                aJ1[iJ1Posicao].DescontoSubTotal              := rDesconto;
                aJ1[iJ1Posicao].IndicadorTipoDesconto         := sTipoDesconto;
                aJ1[iJ1Posicao].AcrescimoSubTotal             := rAcrescimo;
                aJ1[iJ1Posicao].IndicadorTipoAcrescimo        := sTipoAcrescimo;
                aJ1[iJ1Posicao].IndicadorCancelamento         := sCancel;
                aJ1[iJ1Posicao].CancelamentoAcrescimoSubtotal := 0.00;
                aJ1[iJ1Posicao].OrdemAplicacaoDescAcres       := ' ';
                aJ1[iJ1Posicao].NomeAdquirente                := Form1.IbDataSet100.FieldByName('CLIFOR').AsString;
                aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString);
                aJ1[iJ1Posicao].NumeroNF                      := Form1.IbDataSet100.FieldByName('PEDIDO').AsString;
                aJ1[iJ1Posicao].SerieNF                       := Form1.IbDataSet100.FieldByName('SERIE').AsString;
                aJ1[iJ1Posicao].SubSerie                      := Form1.IbDataSet100.FieldByName('SUBSERIE').AsString;
                aJ1[iJ1Posicao].TipoDocumento                 := '1'; // NF emitida Manualmente
                aJ1[iJ1Posicao].ChaveAcesso                   := DupeString('0', 44);
              end;
              //aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado);
              //aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
              dR04SubTotal := int((Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat*100)) / 100; // Sandro Silva 2017-11-09 Polimig Truncar valor para sair igual total item no cupom (ecf truncando)
              aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (dR04SubTotal - dDescontoItem - dItemCancelado);
              aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (dR04SubTotal - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
              aJ1[iJ1Posicao].Evidencia         := sEvidencia;

            except
              SmallMsg('Erro ao criar registro J1 NF manual');
            end;

            Form1.IbDataSet100.Next;
          end;
          ///////////////////////////////////////////////////////////////////////////////////
          }
          //
          sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString;// Sandro Silva 2018-05-28  sPDV := IBQECF.FieldByName('PDV').AsString;
          //
        end;
        //
        IBQECF.Next;
        //
      end;

      //
      //J1 Referente as NF-e: 55
      //
      Form1.IbDataSet100.Close;
      Form1.IbDataSet100.SelectSql.Clear;
      Form1.IbDataSet100.SelectSQL.Text :=
        'select VENDAS.*, VENDAS.CLIENTE as CLIFOR ' +
        'from VENDAS ' +
        'where VENDAS.MODELO = ''55'' ' +
        ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
        ' and (VENDAS.STATUS containing ''Autorizad'' or VENDAS.STATUS containing ''cancelada'') ' +
        ' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and VENDAS.COMPLEMENTO containing ''MD-5'' ' +// Sandro Silva 2017-11-13  HOMOLOGA 2017 NF-e geradas pelo PAF
        ' order by VENDAS.NUMERONF';
      Form1.IbDataSet100.Open;
      Form1.IbDataSet100.First;
      //
      // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
      //
      while not Form1.IbDataSet100.Eof do
      begin

        // VER CASO DE ENTRADA BUSCAR DE ITENS002 CONTROLAR EVIDENCIAS
        try
          //
          sEvidencia := ' ';

          //Itens NF-e
          Form1.ibDataSet999.Close;
          Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
          Form1.ibDataSet999.SelectSql.Clear;
          Form1.ibDataSet999.SelectSQL.Text :=
            'select * ' +
            'from ITENS001 ' +
            'where NUMERONF = ' + QuotedStr(Form1.IbDataSet100.FieldByName('NUMERONF').AsString) +
            ' and coalesce(CODIGO, '''') <> '''' ';               // Não listar obs
            // Sandro Silva 2017-11-09 Polimig  ' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)'; // Autorizados
            if AnsiContainsText(Form1.IbDataSet100.FieldByName('STATUS').AsString, 'Autoriza') then
              Form1.ibDataSet999.SelectSQL.Add(' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)') // Autorizados
            else
              Form1.ibDataSet999.SelectSQL.Add(' and coalesce(SINCRONIA,0) = 0'); // Canceladas
          Form1.ibDataSet999.Open;

          Form1.ibDataSet999.First;
          if Form1.ibDataSet999.IsEmpty = False then // Se não tiver itens nõa lista
          begin

            // Identifica evidência para J1
            if not AssinaRegistro('VENDAS', Form1.IbDataSet100, False) then
              sEvidencia := '?';

            if Pos(sEmitenteEvidenciado, '?') > 0 then
            begin
              sEvidencia := '?';
            end;

            // CNPJ Cliente
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select CGC as CNPJ ' +
              'from CLIFOR ' +
              'where NOME = ' + QuotedStr(Form1.IbDataSet100.FieldByName('CLIFOR').AsString);
            Form1.ibDataSet999.Open;

            rDesconto  := Form1.IbDataSet100.FieldByName('DESCONTO').AsFloat;

            sTipoDesconto := ' ';
            if rDesconto > 0 then
              sTipoDesconto := 'V';

            rAcrescimo := Form1.IbDataSet100.FieldByName('SEGURO').AsFloat + Form1.IbDataSet100.FieldByName('DESPESAS').AsFloat;

            sChaveAcessoDocumento := Copy(Form1.IbDataSet100.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
            sNumeroNF             := Copy(FormatFloat('000000000000', Form1.IbDataSet100.FieldByName('NUMERONF').AsFloat), 1, 9);
            sSerieNF              := Right(FormatFloat('000000000000', Form1.IbDataSet100.FieldByName('NUMERONF').AsFloat), 3);

            sCancel := 'N';
            if AnsiContainsText(Form1.IbDataSet100.FieldByName('STATUS').AsString, 'cancelada') then
            begin
              // Se o cupom foi cancelado o item deve ficar como "N"
              // Se o item foi cancelado deve ficar como "S"
              sCancel := 'S';
              // Sandro Silva 2017-08-16  fQTD_CANCEL := 0.00;
              // Sandro Silva 2017-08-16  fVAL_CANCEL := 0.00;
            end;

            SetLength(aJ1, Length(aJ1) + 1);
            iJ1Posicao := High(aJ1);

            aJ1[iJ1Posicao].Tipo                          := 'J1';
            aJ1[iJ1Posicao].CNPJEmissor                   := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
            aJ1[iJ1Posicao].DataEmissao                   := Form1.IbDataSet100.FieldByName('EMISSAO').AsDateTime;
            aJ1[iJ1Posicao].DescontoSubTotal              := rDesconto;
            aJ1[iJ1Posicao].IndicadorTipoDesconto         := sTipoDesconto; // Sandro Silva 2017-11-08 Polimig  ' ';
            aJ1[iJ1Posicao].AcrescimoSubTotal             := rAcrescimo;
            aJ1[iJ1Posicao].IndicadorTipoAcrescimo        := ' ';
            aJ1[iJ1Posicao].IndicadorCancelamento         := sCancel;
            aJ1[iJ1Posicao].CancelamentoAcrescimoSubtotal := 0.00;
            aJ1[iJ1Posicao].OrdemAplicacaoDescAcres       := ' ';
            aJ1[iJ1Posicao].NomeAdquirente                := Form1.IbDataSet100.FieldByName('CLIFOR').AsString;
            aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.ibDataSet999.FieldByName('CNPJ').AsString);
            aJ1[iJ1Posicao].NumeroNF                      := sNumeroNF;
            aJ1[iJ1Posicao].SerieNF                       := sSerieNF;
            aJ1[iJ1Posicao].SubSerie                      := '';
            aJ1[iJ1Posicao].ChaveAcesso                   := sChaveAcessoDocumento;
            aJ1[iJ1Posicao].TipoDocumento                 := '2'; // NF-e emitida
            aJ1[iJ1Posicao].SubTotal                      := (Form1.IbDataSet100.FieldByName('MERCADORIA').AsFloat + Form1.IbDataSet100.FieldByName('SERVICOS').AsFloat);
            aJ1[iJ1Posicao].ValorTotalLiquido             := Form1.IbDataSet100.FieldByName('TOTAL').AsFloat;
            aJ1[iJ1Posicao].Evidencia                     := sEvidencia;
          end;

        except
          SmallMsg('Erro ao criar registro J1 NF-e');
        end;
        Form1.IbDataSet100.Next;
      end;

      { ajustar e ativar se precisar
      //J1 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no período
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, substring(NFEID from 23 for 3) as SERIE, NUMERONF ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        ' and coalesce(NFEID, '''') <> '''' '  +
        ' and DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and NFEXML containing ''MD-5'' ' +
        ' order by PDV';
      IBQECF.Open;
      IBQECF.First;

      //
      sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //
        if IBQECF.FieldByName('PDV').AsString <> sPDV then
        begin

          //J1 Referente as NF-e: 65
          //ALTERACA.VALORICM = Número+Serie NF-e e ALTERACA.SERIE = ''
          Form1.IbDataSet100.Close;
          Form1.IbDataSet100.SelectSql.Clear;
          Form1.IbDataSet100.SelectSQL.Text :=
            'select sum(A1.TOTAL) as SUBTOTAL, A1.DATA, A1.PEDIDO, A1.VALORICM, A1.SERIE, A1.SUBSERIE, A1.CCF, max(coalesce(A1.CLIFOR, '''')) as CLIFOR, max(coalesce(A1.CNPJ, '''')) as CNPJ ' +
            'from ALTERACA A1 ' +
            'where (A1.TIPO = ''BALCAO'' or A1.TIPO = ''CANCEL'') ' +
            //' and coalesce(A1.SERIE, '''') = '''' and coalesce(A1.VALORICM, '''') <> '''' ' + // NF-e que foi registrada em cupom fiscal
            ' and A1.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and A1.PEDIDO = ' + QuotedStr(Trim(IBQECF.FieldByName('NUMERONF').AsString)) +
            ' and A1.DESCRICAO <> ''Desconto'' ' +
            ' and A1.DESCRICAO <> ''Acréscimo'' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' +  // 2015-11-05 Não listar os descontos dos itens cancelados
            ' group by A1.DATA, A1.PEDIDO, A1.VALORICM, A1.SERIE, A1.SUBSERIE, A1.CCF ' +
            'order by DATA';
          Form1.IbDataSet100.Open;
          Form1.IbDataSet100.First;
          //
          // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
          //
          while not Form1.IbDataSet100.Eof do
          begin
            try
              // Itens cancelados no cupom
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as CANCELADOS ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
                ' and DESCRICAO = ''<CANCELADO>'' ' +
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
              Form1.ibDataSet999.Open;

              dItemCancelado := Form1.ibDataSet999.FieldByName('CANCELADOS').AsFloat;

              //
              // Desconto no total do cupom
              //
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as DESCONTO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
                ' and DESCRICAO = ''Desconto'' ' +
                ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
                ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              Form1.ibDataSet999.Open;
              //
              //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
              //
              rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

              //
              // Desconto nos itens
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as DESCONTO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
                ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
                ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
                ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
                ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              Form1.ibDataSet999.Open;

              dDescontoItem := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

              //
              // Acréscimo
              //
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select sum(TOTAL) as ACRESCIMO ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
                ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
                ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
                ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              Form1.ibDataSet999.Open;
              //
              rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
              //
              Form1.IbDataSet27.Close;
              Form1.IbDataSet27.SelectSQL.Clear;
              Form1.IbDataSet27.SelectSQL.Text :=
                'select * ' +
                'from ALTERACA ' +
                'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
                //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
                ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
                ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              Form1.IbDataSet27.Open;
              Form1.IbDataSet27.DisableControls;
              //
              sEvidencia := ' ';
              //
              Form1.IbDataSet27.First;
              while not Form1.IbDataSet27.Eof do
              begin
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                begin
                  //          SmallMsg('Registro: '+Form1.IbDataSet27.FieldByName('REGISTRO').AsString);
                  sEvidencia := '?';
                end;
                Form1.IbDataSet27.Next;
              end;

              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
              'select first 1 TIPO ' +
              'from ALTERACA A1 ' +
              'where A1.TIPO = ''BALCAO'' ' +
              //' and coalesce(A1.SERIE, '''') = '''' and A1.VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
              ' and A1.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
              ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
              ' and A1.PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and A1.DESCRICAO <> ''Desconto'' ' +
              ' and A1.DESCRICAO <> ''Acréscimo'' ';
              Form1.ibDataSet999.Open;

              if Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'BALCAO' then
                sCancel := 'N'
              else
                sCancel := 'S';

              sDescontoOuAcrescimo := ' ';
              sTipoAcrescimo       := ' ';
              if rAcrescimo > 0 then
              begin
                sTipoAcrescimo       := 'V';
                sDescontoOuAcrescimo := 'A';
              end;

              sTipoDesconto := ' ';
              if rDesconto > 0 then
              begin
                sTipoDesconto        := 'V';
                sDescontoOuAcrescimo := 'D';
              end;

              //
              if Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat = 0 then
                sCancel := 'S';
              //

              // Seleciona NFEID
              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
              'select first 1 * ' +
              'from NFCE ' +
              'where NUMERONF = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3));
              Form1.ibDataSet999.Open;

              sChaveAcessoDocumento := Copy(Form1.ibDataSet999.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
              sNumeroNF             := Right('000000000000' + Form1.IbDataSet100.FieldByName('PEDIDO').AsString, 9);
              sSerieNF              := Copy(Copy(Form1.ibDataSet999.FieldByName('NFEID').AsString, 23, 3) + '   ', 1, 3);

              bJ1 := False;
              for iJ1 := 0 to Length(aJ1) - 1 do
              begin
                if (aJ1[iJ1].NumeroNF = sNumeroNF)
                  and (aJ1[iJ1].SerieNF = sSerieNF)
                  and (aJ1[iJ1].SubSerie = Form1.IbDataSet100.FieldByName('SUBSERIE').AsString)
                  and (aJ1[iJ1].TipoDocumento = '3') then
                begin
                  bJ1 := True;
                  iJ1Posicao := iJ1;
                end;
              end;

              if bJ1 = False then
              begin
                SetLength(aJ1, Length(aJ1) + 1);
                iJ1Posicao := High(aJ1);

                aJ1[iJ1Posicao].Tipo                          := 'J1';
                aJ1[iJ1Posicao].CNPJEmissor                   := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ1[iJ1Posicao].DataEmissao                   := Form1.IbDataSet100.FieldByName('DATA').AsDateTime;
                aJ1[iJ1Posicao].DescontoSubTotal              := rDesconto;
                aJ1[iJ1Posicao].IndicadorTipoDesconto         := 'V';
                aJ1[iJ1Posicao].AcrescimoSubTotal             := rAcrescimo;
                aJ1[iJ1Posicao].IndicadorTipoAcrescimo        := 'V';
                aJ1[iJ1Posicao].IndicadorCancelamento         := sCancel;
                aJ1[iJ1Posicao].CancelamentoAcrescimoSubtotal := 0.00;
                aJ1[iJ1Posicao].OrdemAplicacaoDescAcres       := ' ';
                aJ1[iJ1Posicao].NomeAdquirente                := Form1.IbDataSet100.FieldByName('CLIFOR').AsString;
                aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString);
                aJ1[iJ1Posicao].NumeroNF                      := sNumeroNF;
                aJ1[iJ1Posicao].SerieNF                       := sSerieNF;
                aJ1[iJ1Posicao].SubSerie                      := Form1.IbDataSet100.FieldByName('SUBSERIE').AsString;
                aJ1[iJ1Posicao].ChaveAcesso                   := sChaveAcessoDocumento;
                aJ1[iJ1Posicao].TipoDocumento                 := '3'; // NFC-E emitida
              end;
              aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado);
              aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
              aJ1[iJ1Posicao].Evidencia         := sEvidencia;

            except
              SmallMsg('Erro ao criar registro J1 NFC-e');
            end;

            Form1.IbDataSet100.Next;
          end;

          //
          sPDV := IBQECF.FieldByName('PDV').AsString;
          //
        end;
        //
        IBQECF.Next;
        //
      end;
      }

      // Salvando J1 no arquivo
      for iJ1 := 0 to Length(aJ1) - 1 do
      begin
        try
          Writeln(F,  'J1' + // Tipo
                       Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                       FormatDateTime('yyyymmdd', aJ1[iJ1].DataEmissao) + // Data de emissão do documento fiscal
                       StrZero(((aJ1[iJ1].SubTotal) * 100), 14, 0) + // Valor total do documento, com duas casas decimais.
                       StrZero(((aJ1[iJ1].DescontoSubTotal) * 100), 13, 0) + // Valor do desconto ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                       aJ1[iJ1].IndicadorTipoDesconto + // Informar “V” para valor monetário ou “P” para percentual
                       StrZero(((aJ1[iJ1].AcrescimoSubTotal) * 100), 13, 0) + // Valor do acréscimo ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                       aJ1[iJ1].IndicadorTipoAcrescimo +  // Informar “V” para valor monetário ou “P” para percentual
                       StrZero(((aJ1[iJ1].ValorTotalLiquido) * 100), 14, 0) + // Valor total do Cupom Fiscal após desconto/acréscimo, com duas casas decimais.
                       aJ1[iJ1].IndicadorCancelamento + // Informar "S" ou "N", conforme tenha ocorrido ou não, o cancelamento do documento.
                       StrZero(((aJ1[iJ1].CancelamentoAcrescimoSubtotal) * 100), 13, 0) + // Valor do cancelamento de acréscimo no subtotal
                       aJ1[iJ1].OrdemAplicacaoDescAcres + // Indicador de ordem de aplicação de desconto/acréscimo em Subtotal. ‘D’ ou ‘A’ caso tenha ocorrido primeiro desconto ou acréscimo, respectivamente
                       Copy(aJ1[iJ1].NomeAdquirente + DupeString(' ', 40), 1, 40) + // Nome do Cliente
                       Right(Replicate('0',14) + aJ1[iJ1].CPFCNPJAdquirente, 14) +  // CPF ou CNPJ do adquirente
                       Right('0000000000' + aJ1[iJ1].NumeroNF, 10) + // Número da Nota Fiscal, manual ou eletrônica
                       Copy(aJ1[iJ1].SerieNF + '   ', 1, 3) + // Série da Nota Fiscal, manual ou eletrônica
                       Copy(aJ1[iJ1].ChaveAcesso + DupeString(' ', 44), 1, 44) + // Chave de Acesso da Nota Fiscal Eletrônica
                       //2019-08-23 UnoChapeco IfThen((aJ1[iJ1].Evidencia = '?'), '?', aJ1[iJ1].TipoDocumento)  // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e) // Sandro Silva 2017-11-13  HOMOLOGA 2017 IfThen((aJ1[iJ1Posicao].Evidencia = '?'), '?', aJ1[iJ1Posicao].TipoDocumento)  // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
                       IfThen((aJ1[iJ1].Evidencia = '?'), aJ1[iJ1].TipoDocumento + '?', aJ1[iJ1].TipoDocumento + ' ')  // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e) // Sandro Silva 2017-11-13  HOMOLOGA 2017 IfThen((aJ1[iJ1Posicao].Evidencia = '?'), '?', aJ1[iJ1Posicao].TipoDocumento)  // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
                      );

        except
          SmallMsg('Erro ao criar registro J1');
        end;
      end;
    except
      SmallMsg('Erro ao criar registro J1');
    end;

    //
    // J1 FINAL
    //
    //**********************

    //**********************
    //
    // J2 INÍCIO
    //
    if Form1.bData then
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct R1.SERIE ' +
        ',(select first 1 R3.PDV from REDUCOES R3 where R3.SERIE = R1.SERIE and coalesce(R3.PDV, ''XX'') <> ''XX'' order by R3.REGISTRO desc) as PDV ' +
        ',(select first 1 R4.MODELOECF from REDUCOES R4 where R4.SERIE = R1.SERIE order by R4.REGISTRO desc) as MODELOECF ' +
        'from REDUCOES R1 ' +
        ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' and R1.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' where R1.SMALL <> ''59''  and R1.SMALL <> ''65'' ' +
        ' and coalesce(R1.SERIE, ''XX'') <> ''XX'' ' +
        ' and char_length(trim(R1.PDV)) = 3 ' +
        ' group by R1.SERIE ' +
        'order by PDV';
      {Sandro Silva 2018-05-28 fim}

      IBQECF.Open;
      IBQECF.First;
    end else
    begin
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select first 1 PDV, SERIE, MODELOECF ' +
        'from REDUCOES ' +
        'where SERIE = ' + QuotedStr(Form1.sNumeroDeSerieDaImpressora) +
        ' and DATA = ' + QuotedStr(DateToStrInvertida(StrToDate(sDataUltimaZ)))+' ';
      IBQECF.Open;
    end;

    try
      //
      sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //
        if IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString <> sPDV then// Sandro Silva 2018-05-28  if IBQECF.FieldByName('PDV').AsString <> sPDV then
        begin

          ///////////////////////////////////////////////////
          //J2 Referente as notas manuais impressas no ecf
          ///////////////////////////////////////////////////

          Form1.ibDataSet88.Close;
          Form1.ibDataSet88.SelectSQL.Text :=
            'select * ' +
            'from REDUCOES ' +
            'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 'where SMALL <> ''59'' and SMALL <> ''65'' ' +
            ' and coalesce(SERIE, ''XX'') = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
            ' and DATA <= ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
            ' order by DATA desc';
          Form1.ibDataSet88.Open;
          Form1.ibDataSet88.First;

          IBQR04.Close;
          IBQR04.SQL.Text :=
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from REDUCOES R ' +
            'left join ALTERACA A on (A.COO between R.CUPOMI and R.CUPOMF and A.DATA between R.DATA and R.DATA + 1 and A.CAIXA = R.PDV and (A.TIPO = ''VENDA'' or A.TIPO = ''CANCEL'')) ' +
            'where R.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' ' + // Sandro Silva 2021-08-11 ' and R.SMALL <> ''59'' and R.SMALL <> ''65'' ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and coalesce(A.SERIE, '''') <> '''' and coalesce(A.COO, '''') <> '''' ' +
            ' and A.REGISTRO is not null ' +
            'union ' +
            'select distinct A.PEDIDO, A.CAIXA ' +
            'from ALTERACA A ' +
            'where A.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and (A.TIPO = ''VENDA'' or A.TIPO = ''CANCEL'') ' +
            ' and A.COO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'' order by R.DATA desc), '''') ' + // Sandro Silva 2021-08-11 ' and A.COO > coalesce((select first 1 R.CUPOMF from REDUCOES R where R.PDV = A.CAIXA and R.SMALL <> ''59'' and R.SMALL <> ''65'' order by R.DATA desc), '''') ' +
            ' and A.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and coalesce(A.SERIE, '''') <> '''' and coalesce(A.COO, '''') <> '''' ' +
            ' and A.REGISTRO is not null ' +
            'order by 2, 1';
          IBQR04.Open;

          while IBQR04.Eof = False do
          begin

            //
            Form1.IbDataSet27.Close;
            Form1.IbDataSet27.SelectSql.Clear;
            Form1.IbDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(IBQR04.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
              ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' +
              ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') <> '''' ' + // Nota manual que foi registrada em cupom fiscal
              ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
              'order by DATA, CCF, ITEM';
            Form1.IbDataSet27.Open;

            Form1.IbDataSet27.First;
            //
            while not Form1.IbDataSet27.Eof do
            begin
              //
              try
                if (Alltrim(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) <> '')
                  and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
                  and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
                begin
                  //
                  //
                  sTabela := 'I1     ';
                  //
                  for I := 1 to 15 do
                  begin
                    //
                    if Form1.ibDataSet88.FieldByName( 'ALIQU'+StrZero(I,2,0) ).AsString = Form1.IbDataSet27.FieldByName( 'ALIQUICM').AsString then
                    begin
                      sTabela := Strzero(I,2,0)+'T'+Form1.ibDataSet88.FieldByName('ALIQU'+Strzero(I,2,0)).AsString;  // totalizador parcial
                    end;
                  end;
                  //
                  if Pos('I',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'I1     ';
                  if Pos('F',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'F1     ';
                  if Pos('N',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'N1     ';

                  if Copy(Form1.IbDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
                  begin
                    sTabela := '01S' + sAliqISSQN;
                  end;

                  //
                  sCancel := 'N';
                  if (Pos('<CANCELADO>', Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
                  begin
                    // Se o cupom foi cancelado o item deve ficar como "N"
                    // Se o item foi cancelado deve ficar como "S"
                    sCancel := 'S';
                  end;

                  sEvidencia := ' ';
                  if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                    sEvidencia := '?';

                  //Sandro Silva 2017-11-28 inicio Polimig
                  if Pos(sEmitenteEvidenciado, '?') > 0 then
                  begin
                    sEvidencia := '?';
                  end;
                  //Sandro Silva 2017-11-28 final Polimig

                  // Desconto do item
                  Form1.ibDataSet999.Close;
                  Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                  Form1.ibDataSet999.SelectSql.Clear;
                  Form1.ibDataSet999.SelectSQL.Text :=
                    'select * ' +
                    'from ALTERACA ' +
                    'where PEDIDO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) +
                    ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                    ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' +
                    ' and ITEM = ' + QuotedStr(Form1.IbDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                    ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet27.FieldByName('DATA').AsDateTime)) +
                    ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                  Form1.ibDataSet999.Open;
                  //
                  //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                  //
                  dDescontoItem := 0.00;
                  if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then // Sandro Silva 2016-03-08 POLIMIG
                    dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1; // Sandro Silva 2016-03-08 POLIMIG

                  if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                    if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                       sEvidencia := '?';

                  sDescricaoItem := Form1.IbDataSet27.FieldByName('DESCRICAO').AsString;

                  Form1.ibDataSet999.Close;
                  Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                  Form1.ibDataSet999.SelectSql.Clear;
                  Form1.ibDataSet999.SelectSQL.Text :=
                    'select DESCRICAO, CEST, CF ' +
                    'from ESTOQUE ' +
                    'where CODIGO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('CODIGO').AsString);
                  Form1.ibDataSet999.Open;

                  if (Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
                  begin
                    sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
                  end;
                  if Form1.sImprimirCEST = 'Sim' then // Sandro Silva 2019-09-11 ER 02.06 UnoChapeco
                    sDescricaoItem := '#' + Form1.ibDataSet999.FieldByName('CEST').AsString + '#' + Form1.ibDataSet999.FieldByName('CF').AsString + '#' + sDescricaoItem;

                  {Sandro Silva 2017-11-13 inicio HOMOLOGA 2017}
                  sR05CasasQtd   := '2';
                  if AnsiUpperCase(Form1.IbDataSet27.FieldByName('MEDIDA').AsString) = 'KG' then
                  begin
                    sR05CasasQtd   := '3';
                  end;
                  {Sandro Silva 2017-11-13 final HOMOLOGA 2017}

                  SetLength(aJ2, Length(aJ2) + 1);
                  iJ2Posicao := High(aJ2);

                  aJ2[iJ2Posicao].Tipo                       := 'J2';
                  aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                  aJ2[iJ2Posicao].DataEmissao                := Form1.IbDataSet27.FieldByName('DATA').AsDateTime;
                  aJ2[iJ2Posicao].NumeroItem                 := Form1.IbDataSet27.FieldByName('ITEM').AsString;
                  aJ2[iJ2Posicao].CodigoProduto              := Form1.IbDataSet27.FieldByName('REFERENCIA').AsString;
                  aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
                  aJ2[iJ2Posicao].Quantidade                 := Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat;
                  aJ2[iJ2Posicao].Unidade                    := Form1.IbDataSet27.FieldByName('MEDIDA').AsString;
                  aJ2[iJ2Posicao].ValorUnitario              := Form1.IbDataSet27.FieldByName('UNITARIO').AsFloat;
                  aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
                  aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
                  aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.IbDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem;
                  aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
                  aJ2[iJ2Posicao].CasasDecimaisQuantidade    := sR05CasasQtd; // Sandro Silva 2017-11-13  HOMOLOGA 2017 '2';
                  aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
                  aJ2[iJ2Posicao].NumeroNF                   := Form1.IbDataSet27.FieldByName('PEDIDO').AsString;
                  aJ2[iJ2Posicao].SerieNF                    := Form1.IbDataSet27.FieldByName('SERIE').AsString;
                  aJ2[iJ2Posicao].SubSerie                   := Form1.IbDataSet27.FieldByName('SUBSERIE').AsString;
                  aJ2[iJ2Posicao].TipoDocumento              := '1'; // NF emitida Manualmente
                  aJ2[iJ2Posicao].Evidencia                  := sEvidencia;
                  aJ2[iJ2Posicao].ChaveAcesso                := DupeString('0', 44); // Sandro Silva 2017-11-07 Polimig
                end;
              except
                SmallMsg('Erro ao criar registro J2 NF manual');
              end;

              Form1.IbDataSet27.Next;
            end; // while not Form1.IbDataSet27.Eof do

            IBQR04.Next;

          end; //while IBQR04.Eof = False do

          {
          //////////////////////////////////////////////////////////////////////
          //J2 Referente as notas manuais tela adversa

          Form1.ibDataSet88.Close;
          Form1.ibDataSet88.SelectSQL.Text :=
            'select * ' +
            'from REDUCOES ' +
            'where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' ' +
            ' and coalesce(SERIE, ''XX'') = ' + QuotedStr(IBQECF.FieldByName('SERIE').AsString) +
            ' and DATA <= ' + QuotedStr(DateToStrInvertida(Form7.DateTimePicker2.Date)) +
            ' order by DATA desc';
          Form1.ibDataSet88.Open;
          Form1.ibDataSet88.First;

          //
          Form1.IbDataSet27.Close;
          Form1.IbDataSet27.SelectSql.Clear;
          Form1.IbDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' +
            ' and coalesce(SERIE, '''') <> '''' and coalesce(COO, '''') = '''' ' + // Nota manual que NÃO foi registrada em cupom fiscal
            ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
            'order by DATA, PEDIDO, ITEM';// Sandro Silva 2017-11-10 Polimig Ordem dos itens na nota
          Form1.IbDataSet27.Open;
          Form1.IbDataSet27.First;
          //
          while not Form1.IbDataSet27.Eof do
          begin
            //
            try
              if (Alltrim(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) <> '')
                and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
                and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
              begin
                //
                // Sandro Silva 2017-08-16  fQTD_CANCEL := 0;
                // Sandro Silva 2017-08-16  fVAL_CANCEL := 0;
                //
                sTabela := 'I1     ';
                //
                for I := 1 to 15 do
                begin
                  //
                  if Form1.ibDataSet88.FieldByName( 'ALIQU'+StrZero(I,2,0) ).AsString = Form1.IbDataSet27.FieldByName( 'ALIQUICM').AsString then
                  begin
                    sTabela := Strzero(I,2,0)+'T'+Form1.ibDataSet88.FieldByName('ALIQU'+Strzero(I,2,0)).AsString;  // totalizador parcial
                  end;
                end;
                //
                if Pos('I',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'I1     ';
                if Pos('F',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'F1     ';
                if Pos('N',Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then sTabela := 'N1     ';

                if Copy(Form1.IbDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
                begin
                  sTabela := '01S' + sAliqISSQN;
                end;

                //
                sCancel := 'N';
                if (Pos('<CANCELADO>', Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
                begin
                  // Se o cupom foi cancelado o item deve ficar como "N"
                  // Se o item foi cancelado deve ficar como "S"
                  sCancel := 'S';
                  // Sandro Silva 2017-08-16  fQTD_CANCEL := 0.00;
                  // Sandro Silva 2017-08-16  fVAL_CANCEL := 0.00;
                end;

                sEvidencia := ' ';
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                  sEvidencia := '?';

                // Desconto do item
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) +
                  ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                  ' and (TIPO = ''VENDA'' or TIPO = ''CANCEL'') ' +
                  ' and ITEM = ' + QuotedStr(Form1.IbDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                  ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet27.FieldByName('DATA').AsDateTime)) +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;
                //
                //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                //
                dDescontoItem := 0.00;
                if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then // Sandro Silva 2016-03-08 POLIMIG
                  dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1; // Sandro Silva 2016-03-08 POLIMIG

                if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                  if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                     sEvidencia := '?';

                sDescricaoItem := Form1.IbDataSet27.FieldByName('DESCRICAO').AsString;

                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select DESCRICAO, CEST, CF ' +
                  'from ESTOQUE ' +
                  'where CODIGO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('CODIGO').AsString);
                Form1.ibDataSet999.Open;

                if (Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
                begin
                  sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
                end;
                //sDescricaoItem := sDescricaoItem;

                //
                //Sandro Silva 2017-11-29 inicio Polimig
                //if sEvidencia = '?' then
                //  sDescricaoItem := Copy(StrTran(sDescricaoItem+Replicate(' ',100),' ',sEvidencia),1,100);
                //
                //

                //Sandro Silva 2017-11-28 inicio Polimig
                if Pos(sEmitenteEvidenciado, '?') > 0 then
                begin
                  sEvidencia := '?';
                end;
                //Sandro Silva 2017-11-28 final Polimig

                SetLength(aJ2, Length(aJ2) + 1);
                iJ2Posicao := High(aJ2);

                aJ2[iJ2Posicao].Tipo                       := 'J2';
                aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ2[iJ2Posicao].DataEmissao                := Form1.IbDataSet27.FieldByName('DATA').AsDateTime;
                aJ2[iJ2Posicao].NumeroItem                 := Form1.IbDataSet27.FieldByName('ITEM').AsString;
                if Trim(Form1.IbDataSet27.FieldByName('REFERENCIA').AsString) = '' then
                  aJ2[iJ2Posicao].CodigoProduto              := Form1.IbDataSet27.FieldByName('CODIGO').AsString
                else
                  aJ2[iJ2Posicao].CodigoProduto              := Form1.IbDataSet27.FieldByName('REFERENCIA').AsString;
                aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
                aJ2[iJ2Posicao].Quantidade                 := Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat;
                aJ2[iJ2Posicao].Unidade                    := Form1.IbDataSet27.FieldByName('MEDIDA').AsString;
                aJ2[iJ2Posicao].ValorUnitario              := Form1.IbDataSet27.FieldByName('UNITARIO').AsFloat;
                aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
                aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
                aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.IbDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem;
                aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
                if AnsiUpperCase(Form1.IbDataSet27.FieldByName('MEDIDA').AsString) = 'KG' then
                begin
                  aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '3';
                  dR04SubTotal := int(((Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.IbDataSet27.FieldByName('UNITARIO').AsFloat)*100)) / 100;
                  aJ2[iJ2Posicao].ValorTotalLiquido          := dR04SubTotal - dDescontoItem;
                end
                else
                  aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
                aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
                aJ2[iJ2Posicao].NumeroNF                   := Form1.IbDataSet27.FieldByName('PEDIDO').AsString;
                aJ2[iJ2Posicao].SerieNF                    := Form1.IbDataSet27.FieldByName('SERIE').AsString;
                aJ2[iJ2Posicao].SubSerie                   := Form1.IbDataSet27.FieldByName('SUBSERIE').AsString;
                aJ2[iJ2Posicao].TipoDocumento              := '1'; // NF emitida Manualmente
                aJ2[iJ2Posicao].Evidencia                  := sEvidencia;
                aJ2[iJ2Posicao].ChaveAcesso                := DupeString('0', 44); // Sandro Silva 2017-11-07 Polimig
              end;
            except
              SmallMsg('Erro ao criar registro J2 NF manual');
            end;

            Form1.IbDataSet27.Next;
          end;
          //////////////////////////////////////////////////////////////////////
          }
          //
          sPDV := IBQECF.FieldByName('SERIE').AsString + IBQECF.FieldByName('PDV').AsString;// Sandro Silva 2018-05-28  sPDV := IBQECF.FieldByName('PDV').AsString;
          //
        end;
        //
        IBQECF.Next;
        //
      end;

      //J2 Referente as NF-e: 55
      // Seleciona os caixa que emitiram NFC-e no período
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select VENDAS.*, substring(NFEID from 23 for 3) as SERIE ' +
        'from VENDAS ' +
        'where MODELO = ''55'' ' +
        ' and coalesce(NFEID, '''') <> '''' ' +
        ' and (STATUS containing ''Autorizad'' or STATUS containing ''cancelada'') ' + // Sandro Silva 2017-11-09 Polimig
        ' and EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and COMPLEMENTO containing ''MD-5'' ' + // Sandro Silva 2017-11-13  HOMOLOGA 2017 ESTAVA GERANDO J2 SEM TER J1
        ' order by NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      while not IBQECF.EOF do
      begin

        // Produtos
        Form1.IbDataSet100.Close;
        Form1.IbDataSet100.SelectSql.Clear;
        Form1.IbDataSet100.SelectSQL.Text :=
          'select * ' +
          'from ITENS001 ' +
          'where NUMERONF = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
          ' and coalesce(CODIGO, '''') <> '''' '; // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
          if AnsiContainsText(IBQECF.FieldByName('STATUS').AsString, 'Autoriza') then
            Form1.IbDataSet100.SelectSQL.Add(' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)') // Autorizados
          else
            Form1.IbDataSet100.SelectSQL.Add(' and coalesce(SINCRONIA,0) = 0'); // Canceladas
          Form1.IbDataSet100.SelectSQL.Add(' order by REGISTRO');
        Form1.IbDataSet100.Open;
        Form1.IbDataSet100.First;
        //
        while not Form1.IbDataSet100.Eof do
        begin
          //
          try
            if (Alltrim(Form1.IbDataSet100.FieldByName('NUMERONF').AsString) <> '')
              and (Alltrim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString) <> 'Desconto')
              and (Alltrim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
            begin
              //
              //
              if (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '00')   // 00 - Tributada integralmente
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '20') // 20 - Com redução de base de cálculo
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '90') // 90 - Outras
                then
              begin
                if Form1.IbDataSet100.FieldByName('ICM').AsFloat > 0 then
                begin
                  sTabela := LimpaNumero(FormatFloat('00.00', Form1.IbDataSet100.FieldByName('ICM').AsFloat));
                end
                else
                begin
                  if Trim(Form1.IbDataSet100.FieldByName('ST').AsString) <> '' then
                    sTabela := LimpaNumero(FormatFloat('00.00', StrToFloatDef(Trim(Form1.IbDataSet100.FieldByName('ST').AsString), 0)));
                end;

                if sTabela = '' then
                   sTabela := 'I1     '
                else
                  sTabela := '00T' + Right('0000' + sTabela, 4);
              end;

              if (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '10')   // 10 - Tributada e com cobrança do ICMS por substituição tributária
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '30') // 30 - Isenta ou não tributada e com cobrança do ICMS por substituição tributária
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '60') // 60 - ICMS cobrado anteriormente por substituição tributária
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '70') // 70 - Com redução de base de cálculo e cobrança do ICMS por substituição tributária
                then
                sTabela := 'F1     ';

              if (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '40')   // 40 - Isenta
                then
                sTabela := 'I1     ';

              if (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '41')   // 41 - Não tributada
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '50') // 50 - Suspensão
                or (Right('000' + Form1.IbDataSet100.FieldByName('CST_ICMS').AsString, 2) = '51') // 51 - Diferimento
                then
                sTabela := 'N1     ';

              if Copy(Form1.IbDataSet100.FieldByName('ICM').AsString,1,3) = 'ISS' then
              begin
                sTabela := '00S' + sAliqISSQN;
              end;

              //
              sCancel := 'N';
              if (Trim(Form1.IbDataSet100.FieldByName('SINCRONIA').AsString) = '0') then
              begin
                // Se o cupom foi cancelado o item deve ficar como "N"
                // Se o item foi cancelado deve ficar como "S"
                sCancel := 'S';
              end;

              sEvidencia := ' ';
              // Identificar evidência nos itens NF-e para o J2
              if not AssinaRegistro('ITENS001',Form1.IbDataSet100, False) then
                sEvidencia := '?';

              dDescontoItem := 0.00;
              sDescricaoItem := Form1.IbDataSet100.FieldByName('DESCRICAO').AsString;
              //

              if Pos(sEmitenteEvidenciado, '?') > 0 then
              begin
                sEvidencia := '?';
              end;

              //

              sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
              sNumeroNF             := Right('000000000000' + Copy(IBQECF.FieldByName('NUMERONF').AsString, 1, 9), 9);
              sSerieNF              := Copy(Copy(IBQECF.FieldByName('NFEID').AsString, 23, 3) + '   ', 1, 3);

              if not AssinaRegistro('VENDAS',IBQECF, False) then
                sEvidencia := '?';

              Form1.ibDataSet999.Close;
              Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
              Form1.ibDataSet999.SelectSql.Clear;
              Form1.ibDataSet999.SelectSQL.Text :=
                'select DESCRICAO, CEST, CF, REFERENCIA ' +
                'from ESTOQUE ' +
                'where CODIGO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('CODIGO').AsString);
              Form1.ibDataSet999.Open;
              sCodigo := Form1.IbDataSet100.FieldByName('CODIGO').AsString;
              if Trim(Form1.ibDataSet999.FieldByName('REFERENCIA').AsString) <> '' then
                sCodigo := Form1.ibDataSet999.FieldByName('REFERENCIA').AsString;

              SetLength(aJ2, Length(aJ2) + 1);
              iJ2Posicao := High(aJ2);

              aJ2[iJ2Posicao].Tipo                       := 'J2';
              aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
              aJ2[iJ2Posicao].DataEmissao                := IBQECF.FieldByName('EMISSAO').AsDateTime;
              aJ2[iJ2Posicao].NumeroItem                 := FormatFloat('000', Form1.IbDataSet100.RecNo);
              aJ2[iJ2Posicao].CodigoProduto              := Right('00000000000000' + sCodigo, 14); // Sandro Silva 2017-11-08 Polimig  Form1.IbDataSet100.FieldByName('CODIGO').AsString;
              aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
              aJ2[iJ2Posicao].Quantidade                 := Form1.IbDataSet100.FieldByName('QUANTIDADE').AsFloat;
              aJ2[iJ2Posicao].Unidade                    := Form1.IbDataSet100.FieldByName('MEDIDA').AsString;
              aJ2[iJ2Posicao].ValorUnitario              := Form1.IbDataSet100.FieldByName('UNITARIO').AsFloat;
              aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
              aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
              aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.IbDataSet100.FieldByName('TOTAL').AsFloat - dDescontoItem;
              aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
              aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
              aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
              aJ2[iJ2Posicao].ChaveAcesso                := sChaveAcessoDocumento;
              aJ2[iJ2Posicao].NumeroNF                   := sNumeroNF;
              aJ2[iJ2Posicao].SerieNF                    := sSerieNF;
              aJ2[iJ2Posicao].SubSerie                   := '';
              aJ2[iJ2Posicao].TipoDocumento              := '2'; // NF-e emitida
              aJ2[iJ2Posicao].Evidencia                  := sEvidencia;

            end;
          except
            SmallMsg('Erro ao criar registro J2 NF-e');
          end;
          Form1.IbDataSet100.Next;
        end;
        //

        { ajustar e ativar se precisar
        // Seriços
        Form1.IbDataSet100.Close;
        Form1.IbDataSet100.SelectSql.Clear;
        Form1.IbDataSet100.SelectSQL.Text :=
          'select * ' +
          'from ITENS003 ' +
          'where NUMERONF = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
          ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
          'order by REGISTRO';
        Form1.IbDataSet100.Open;
        Form1.IbDataSet100.First;
        //
        while not Form1.IbDataSet100.Eof do
        begin
          //
          try
            if (Alltrim(Form1.IbDataSet100.FieldByName('NUMERONF').AsString) <> '')
              and (Alltrim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString) <> 'Desconto')
              and (Alltrim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
            begin
              //
              // Sandro Silva 2017-08-16  fQTD_CANCEL := 0;
              // Sandro Silva 2017-08-16  fVAL_CANCEL := 0;
              //
              sTabela := '00S' + sAliqISSQN;

              //
              sCancel := 'N';
              if (Pos('<CANCELADO>', Trim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString)) > 0) then
              begin
                // Se o cupom foi cancelado o item deve ficar como "N"
                // Se o item foi cancelado deve ficar como "S"
                sCancel := 'S';
                // Sandro Silva 2017-08-16  fQTD_CANCEL := 0.00;
                // Sandro Silva 2017-08-16  fVAL_CANCEL := 0.00;
              end;

              sEvidencia := ' ';

              //if not AssinaRegistro('ITENS001',Form1.IbDataSet100, False) then
              //  sEvidencia := '?';

              dDescontoItem := 0.00;
              if IBQECF.FieldByName('DESCONTO').AsFloat > 0 then
              begin
                dDescontoItem := (Form1.IbDataSet100.FieldByName('TOTAL').AsFloat / IBQECF.FieldByName('SERVICOS').AsFloat) * IBQECF.FieldByName('DESCONTO').AsFloat;
              end;

              sDescricaoItem := Form1.IbDataSet100.FieldByName('DESCRICAO').AsString;

              if (Trim(Form1.IbDataSet100.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
              begin
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select DESCRICAO ' +
                  'from ESTOQUE ' +
                  'where CODIGO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('CODIGO').AsString) +
                  ' and coalesce(DESCRICAO, '''') <> '''' ';
                Form1.ibDataSet999.Open;
                sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
              end;
              //
              if sEvidencia = '?' then
                sDescricaoItem := Copy(StrTran(sDescricaoItem+Replicate(' ',100),' ',sEvidencia),1,100);
              //

              sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
              sNumeroNF             := Right('000000000000' + Copy(IBQECF.FieldByName('NUMERONF').AsString, 1, 9), 9);
              sSerieNF              := Copy(Copy(IBQECF.FieldByName('NFEID').AsString, 23, 3) + '   ', 1, 3);

              SetLength(aJ2, Length(aJ2) + 1);
              iJ2Posicao := High(aJ2);

              aJ2[iJ2Posicao].Tipo                       := 'J2';
              aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
              aJ2[iJ2Posicao].DataEmissao                := IBQECF.FieldByName('EMISSAO').AsDateTime;
              aJ2[iJ2Posicao].NumeroItem                 := FormatFloat('000', Form1.IbDataSet100.RecNo);
              aJ2[iJ2Posicao].CodigoProduto              := Form1.IbDataSet100.FieldByName('CODIGO').AsString;
              aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
              aJ2[iJ2Posicao].Quantidade                 := Form1.IbDataSet100.FieldByName('QUANTIDADE').AsFloat;
              aJ2[iJ2Posicao].Unidade                    := Form1.IbDataSet100.FieldByName('MEDIDA').AsString;
              aJ2[iJ2Posicao].ValorUnitario              := Form1.IbDataSet100.FieldByName('UNITARIO').AsFloat;
              aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
              aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
              aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.IbDataSet100.FieldByName('TOTAL').AsFloat - dDescontoItem;
              aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
              aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
              aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
              aJ2[iJ2Posicao].ChaveAcesso                := sChaveAcessoDocumento;
              aJ2[iJ2Posicao].NumeroNF                   := sNumeroNF;
              aJ2[iJ2Posicao].SerieNF                    := sSerieNF;
              aJ2[iJ2Posicao].SubSerie                   := '';
              aJ2[iJ2Posicao].TipoDocumento              := '2'; // NF-e emitida
              aJ2[iJ2Posicao].Evidencia                  := sEvidencia;

            end;
          except
            SmallMsg('Erro ao criar registro J2 NF-e');
          end;
          Form1.IbDataSet100.Next;
        end;
        }

        IBQECF.Next;
      end;

      { ajustar e ativar se precisar
      //J2 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no período
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, substring(NFEID from 23 for 3) as SERIE, NUMERONF, NFEID ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        ' and coalesce(NFEID, '''') <> '''' '  +
        ' and STATUS containing ''Autorizad'' ' +
        ' and DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and NFEXML containing ''MD-5'' ' +
        ' order by PDV, NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //
        if IBQECF.FieldByName('PDV').AsString <> sPDV then
        begin
          //
          Form1.IbDataSet27.Close;
          Form1.IbDataSet27.SelectSql.Clear;
          Form1.IbDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
            ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
            ' and coalesce(SERIE, '''') = '''' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
            'order by DATA, CCF, ITEM';
          Form1.IbDataSet27.Open;
          Form1.IbDataSet27.First;
          //
          while not Form1.IbDataSet27.Eof do
          begin
            //
            try
              if (Alltrim(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) <> '')
                and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
                and (Alltrim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
              begin
                //
                // Sandro Silva 2017-08-16  fQTD_CANCEL := 0;
                // Sandro Silva 2017-08-16  fVAL_CANCEL := 0;
                //
                if Pos('I', Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                  sTabela := 'I1     '
                else
                  if Pos('F', Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                    sTabela := 'F1     '
                  else
                    if Pos('N', Form1.IbDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                      sTabela := 'N1     '
                    else
                    begin
                      sTabela := LimpaNumero(Form1.IbDataSet27.FieldByName('ALIQUICM').AsString);
                      if sTabela = '' then
                        sTabela := 'I1     '
                      else
                        sTabela := '00T' + Right('0000' + sTabela, 4);
                    end;

                if Copy(Form1.IbDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
                begin
                  sTabela := '00S' + sAliqISSQN;
                end;

                //
                sCancel := 'N';
                if (Pos('<CANCELADO>', Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
                begin
                  // Se o cupom foi cancelado o item deve ficar como "N"
                  // Se o item foi cancelado deve ficar como "S"
                  sCancel := 'S';
                  // Sandro Silva 2017-08-16  fQTD_CANCEL := 0.00;
                  // Sandro Silva 2017-08-16  fVAL_CANCEL := 0.00;
                end;

                sEvidencia := ' ';
                if not AssinaRegistro('ALTERACA',Form1.IbDataSet27, False) then
                  sEvidencia := '?';

                // Desconto do item
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('PEDIDO').AsString) +
                  ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                  ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
                  ' and ITEM = ' + QuotedStr(Form1.IbDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                  ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet27.FieldByName('DATA').AsDateTime)) +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;
                //
                //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                //
                dDescontoItem := 0.00;
                if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then // Sandro Silva 2016-03-08 POLIMIG
                  dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1; // Sandro Silva 2016-03-08 POLIMIG

                if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                  if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                     sEvidencia := '?';

                sDescricaoItem := Form1.IbDataSet27.FieldByName('DESCRICAO').AsString;

                if (Trim(Form1.IbDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
                begin
                  Form1.ibDataSet999.Close;
                  Form1.ibDataSet999.Transaction := IBTransaction1;
                  Form1.ibDataSet999.SelectSql.Clear;
                  Form1.ibDataSet999.SelectSQL.Text :=
                    'select DESCRICAO ' +
                    'from ESTOQUE ' +
                    'where CODIGO = ' + QuotedStr(Form1.IbDataSet27.FieldByName('CODIGO').AsString);
                  Form1.ibDataSet999.Open;
                  sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
                end;
                //
                if sEvidencia = '?' then
                  sDescricaoItem := Copy(StrTran(sDescricaoItem+Replicate(' ',100),' ',sEvidencia),1,100);
                //

                sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
                sNumeroNF             := Right('000000000000' + IBQECF.FieldByName('NUMERONF').AsString, 9);
                sSerieNF              := Copy(Copy(IBQECF.FieldByName('NFEID').AsString, 23, 3) + '   ', 1, 3);

                SetLength(aJ2, Length(aJ2) + 1);
                iJ2Posicao := High(aJ2);

                aJ2[iJ2Posicao].Tipo                       := 'J2';
                aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ2[iJ2Posicao].DataEmissao                := Form1.IbDataSet27.FieldByName('DATA').AsDateTime;
                aJ2[iJ2Posicao].NumeroItem                 := Form1.IbDataSet27.FieldByName('ITEM').AsString;
                aJ2[iJ2Posicao].CodigoProduto              := Form1.IbDataSet27.FieldByName('REFERENCIA').AsString;
                aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
                aJ2[iJ2Posicao].Quantidade                 := Form1.IbDataSet27.FieldByName('QUANTIDADE').AsFloat;
                aJ2[iJ2Posicao].Unidade                    := Form1.IbDataSet27.FieldByName('MEDIDA').AsString;
                aJ2[iJ2Posicao].ValorUnitario              := Form1.IbDataSet27.FieldByName('UNITARIO').AsFloat;
                aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
                aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
                aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.IbDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem;
                aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
                aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
                aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
                aJ2[iJ2Posicao].ChaveAcesso                := sChaveAcessoDocumento;
                aJ2[iJ2Posicao].NumeroNF                   := sNumeroNF;
                aJ2[iJ2Posicao].SerieNF                    := sSerieNF;
                aJ2[iJ2Posicao].SubSerie                   := '';
                aJ2[iJ2Posicao].TipoDocumento              := '3'; // NFC-e emitida
                aJ2[iJ2Posicao].Evidencia                  := sEvidencia;

              end;
            except
              SmallMsg('Erro ao criar registro J2 NFC-e');
            end;
            Form1.IbDataSet27.Next;
          end;
          //
          sPDV := IBQECF.FieldByName('PDV').AsString;
          //
        end;
        //
        IBQECF.Next;
      end;
      }
      
      // Salvando J2 no arquivo
      for iJ2 := 0 to Length(aJ2) - 1 do
      begin
        try
          if AnsiUpperCase(aJ2[iJ2].Unidade) = 'KG' then
            sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 1000), 7, 0)
          else
            sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 100), 7, 0);

          Writeln(F,  'J2' +                                                                                // J2
                       Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                       FormatDateTime('yyyymmdd', aJ2[iJ2].DataEmissao) +                                   // Data de emissão do documento fiscal
                       Right('000' + aJ2[iJ2].NumeroItem, 3) +                                              // Número do item registrado no documento
                       Right(DupeString('0', 14) + aJ2[iJ2].CodigoProduto, 14) +                          // Código do produto ou serviço registrado no documento. // Sandro Silva 2017-11-10 Polimig  Copy(aJ2[iJ2].CodigoProduto + DupeString(' ', 14), 1, 14) +                          // Código do produto ou serviço registrado no documento.
                       Copy(aJ2[iJ2].Descricao + DupeString(' ', 100), 1, 100) +                            // Descrição do produto ou serviço constante no Cupom Fiscal
                       sJ2Quantidade + // StrZero(((aJ2[iJ2].Quantidade) * 100), 7, 0) +                                       // Quantidade comercializada, sem a separação das casas decimais
                       Copy(aJ2[iJ2].Unidade + Replicate(' ', 3), 1, 3) +                                   // Unidade de medida
                       StrZero(((aJ2[iJ2].ValorUnitario) * 100), 8, 0) +                                    // Valor unitário do produto ou serviço, sem a separação das casas decimais.
                       StrZero(((aJ2[iJ2].DescontoItem) * 100), 8, 0) +                                     // Valor do desconto incidente sobre o valor do item, com duas casas decimais.
                       StrZero(((aJ2[iJ2].AcrescimoItem) * 100), 8, 0) +                                    // Valor do acréscimo incidente sobre o valor do item, com duas casas decimais.
                       StrZero(((aJ2[iJ2].ValorTotalLiquido) * 100), 14, 0)+                                // Valor total líquido do item, com duas casas decimais.
                       aJ2[iJ2].TotalizadorParcial +                                                        // Código do totalizador relativo ao produto ou serviço conforme tabela abaixo.
                       aJ2[iJ2].CasasDecimaisQuantidade +                                                   // Parâmetro de número de casas decimais da quantidade
                       aJ2[iJ2].CasasDecimaisValorUnitario +                                                // Parâmetro de número de casas decimais de valor unitário
                       Right('0000000000' + aJ2[iJ2].NumeroNF, 10) +                                        // Número da Nota Fiscal, manual ou eletrônica
                       Copy(aJ2[iJ2].SerieNF + '   ', 1, 3) +                                               // Série da Nota Fiscal, manual ou eletrônica
                       Copy(aJ2[iJ2].ChaveAcesso + DupeString(' ', 44), 1, 44) +                            // Chave de Acesso da Nota Fiscal Eletrônica
                       // 2019-08-23 UnoChapeco IfThen((aJ2[iJ2].Evidencia = '?'), '?', aJ2[iJ2].TipoDocumento)        // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
                       IfThen((aJ2[iJ2].Evidencia = '?'), aJ2[iJ2].TipoDocumento + '?', aJ2[iJ2].TipoDocumento + ' ')  // Tipo de documento emitido (1-Nota Fiscal manual, 2-Nota Fiscal modelo 55 – NF-e, 3-Nota Fiscal modelo 65 – NFC-e)
                  );

        except
          SmallMsg('Erro ao criar registro J2');
        end;
      end;


      aJ1 := nil; // Sandro Silva 2019-09-10 ER 02.06 UnoChapeco
      aJ2 := nil; // Sandro Silva 2019-09-10 ER 02.06 UnoChapeco

    except
      SmallMsg('Erro ao criar registro J2');
    end;
    
    //
    // J2 FINAL
    //
    //**********************

    aA2 := nil; // Sandro Silva 2019-09-10 ER 02.06 UnoChapeco
    //aR04 := nil; // Sandro Silva 2019-09-18 ER 02.06 UnoChapeco

    FreeAndNil(CDSPRIMEIRAIMPRESSAO);

    CloseFile(F);                                    // Fecha o arquivo
    AssinaturaDigital(pChar(Form1.SaveDialog1.FileName));
    CHDir(Form1.sAtual);
    //
    Form1.ibDataSet88.Close;
    Form1.ibDataSet88.SelectSQL.Clear;
    Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SERIE='+QuotedStr(Form1.sNumeroDeSerieDaImpressora)+' order by DATA');
    Form1.ibDataSet88.Open;
    //
  finally
    Screen.Cursor             := crDefault;    // Cursor de Aguardo
    //
    if AnsiLowerCase(ExtractFileName(Application.ExeName)) = 'pafdief.exe' then
    begin
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Abort;
    end;
  end;
  FreeAndNil(IBQECF);                                          
  FreeAndNil(IBQVENDAS);                                       
  FreeAndNil(IBQCOMPRAS);
  FreeAndNil(IBQFABRICA);                                      
  FreeAndNil(IBQBALCAO);
  FreeAndNil(IBQRESERVA);
  FreeAndNil(IBQALIQUOTASR05); // Sandro Silva 2019-05-03
  FreeAndNil(IBQR03); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  FreeAndNil(IBQR04); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  FreeAndNil(IBQR06); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco
  FreeAndNil(IBQR07); // Sandro Silva 2019-09-19 ER 02.06 UnoChapeco

  FreeAndNil(slArq);

end;

procedure RegistrosDoPafEstoqueparcial;
var
  sCodigo : String;
  sDescri : String;
  bAchou: Boolean;
begin
  CommitaTudo(True);// Estoqueparcial1Click 2015-09-12
  //
  Form1.sSuperCodigo := '';
  sCodigo := 'XXX';
  //
  while sCodigo <> '' do
  begin
    //
    sCodigo := '';
    sCodigo := Form1.Small_InputBox('Estoque parcial','Itens escolhidos: '+chr(10)+sDescri+chr(10)+chr(10)+'Digite o Código ou <Enter> em branco para finalizar:','');
    //
    if AllTrim(sCodigo)<>'' then
    begin
      //
      if LimpaNumero(Trim(sCodigo)) <> Trim(sCodigo) then
      begin
        Form1.ibQuery1.Close;
        Form1.ibQuery1.SQL.Clear;
        Form1.ibQuery1.SQL.Add('select CODIGO, DESCRICAO, REFERENCIA from ESTOQUE where upper(DESCRICAO) like '+QuotedStr(UpperCase(sCodigo)+'%')+' ');
        Form1.ibQuery1.Open;
        //
        bAchou := Pos(AnsiUpperCase(sCodigo), AnsiUpperCase(Form1.ibQuery1.FieldByName('DESCRICAO').AsString)) > 0;
      end
      else
      begin
        if Length(Trim(sCodigo)) > 5 then // Procura pela referência
        begin
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('select CODIGO, DESCRICAO, REFERENCIA from ESTOQUE where REFERENCIA='+QuotedStr(LimpaNumero(sCodigo))+' ');
          Form1.ibQuery1.Open;
          //
          bAchou := Form1.ibQuery1.FieldByName('REFERENCIA').AsString = LimpaNumero(sCodigo);
        end
        else
        begin
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('select CODIGO, DESCRICAO from ESTOQUE where CODIGO='+QuotedStr(StrZero(StrToInt('0'+LimpaNumero(sCodigo)),5,0))+' ');
          Form1.ibQuery1.Open;
          bAchou := Form1.ibQuery1.FieldByName('CODIGO').AsString = StrZero(StrToInt('0'+LimpaNumero(sCodigo)),5,0);
        end;
      end;

      if bAchou then
      begin
        sCodigo := Form1.ibQuery1.FieldByName('CODIGO').AsString;
        Form1.sSuperCodigo := Form1.sSuperCodigo + '|' + StrZero(StrToInt('0'+LimpaNumero(sCodigo)),5,0);
        sDescri := sDescri + StrZero(StrToInt('0'+LimpaNumero(sCodigo)),5,0) + ' ' + Form1.ibQuery1.FieldByName('DESCRICAO').AsString + chr(10);
        // SmallMsg(Form1.ibQuery1.FieldByName('DESCRICAO').AsString);
      end else
      begin
        SmallMsg('Não cadastrado no estoque.');
      end;

      //
    end;
  end;
  //
  if Alltrim(Form1.sSuperCodigo) <> '' then
  begin
    if PAFNFCe then
      RegistrosDoPAFNFCe
    else
      RegistrosDoPafEcfEstoquetotal; // Form1.Estoquetotal1Click(Sender);
  end;
  //
  Form1.sSuperCodigo := '';
  Form1.ibQuery1.Close;
  //
end;

end.
