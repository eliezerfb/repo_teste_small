unit urequisitospafnfce;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  IBQuery, DBClient, Db, IniFiles, StrUtils, DateUtils
  , IBDatabase
  , StdVCL
  ;

const PARAMETRO_PAFNFCE = 'PAFNFCE';

procedure ClassificaAliquotaSituacaoTributaria(var sAliquota: String; var sSituacaoTributaria: String);
procedure RegistrosDoPAFNFCe;

implementation

uses fiscal
  , unit7
  , ufuncoesfrente
  , SmallFunc_xe
//  , uassinaxmlpafnfce
  ;

procedure ClassificaAliquotaSituacaoTributaria(var sAliquota: String; var sSituacaoTributaria: String);
begin

  sAliquota := '';
  if AllTrim(Form1.ibDAtaSet4.FieldByName('ST').AsString) <> '' then // Se o ST não estiver em branco   //
  begin                                    // Procurar na tabela de ICM para  //
    Form1.ibDataSet14.First;                         // saber qual a aliquota associada //
    while not Form1.ibDataSet14.EOF do
    begin
      if Form1.ibDataSet14.FieldByName('ST').AsString = Form1.ibDAtaSet4.FieldByName('ST').AsString then  // Pode ocorrer um erro    //
      begin                                           // se o estado do emitente //
        try                                             // Não estiver cadastrado  //
          if Form1.ibDataSet14.FieldByName('ISS').AsFloat > 0 then
          begin
            sAliquota := StrZero(Form1.ibDataSet14.FieldByName('ISS').AsFloat * 100,4,0);
            sSituacaoTributaria := 'S';
          end else
          begin
            sAliquota := StrZero( (Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100) ,4,0);
            sSituacaoTributaria := 'T';
          end;
        except sAliquota  := '' end;
      end;
      Form1.ibDataSet14.Next;
    end;
  end else sSituacaoTributaria := 'T';

  if Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09' then // 09-Serviço
    sSituacaoTributaria := 'S';

  //
  if sAliquota = '' then // Se o sAliquota continuar em branco é porque não estava cadastrado //
  begin            // na tabela de ICM ou estava em branco                        //
    Form1.ibDataSet14.First;
    while not Form1.ibDataSet14.EOF do  // Procura pela operação padrão venda À vista ou //
    begin                     // venda a prazo 512 ou 612 ou 5102 ou 6102      //
      if (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) = '5102') or (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) = '6102') then
      begin
        try
          sAliquota := StrZero( (Form1.ibDataSet14.FieldByName(Form1.ibDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100),4,0);
        except
          sAliquota  := ''
        end;
      end;
      Form1.ibDataSet14.Next;
    end;
  end;

  if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then // Sandro Silva 2019-03-12 if Form1.ibDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
  begin
    sAliquota := LimpaNumero(FormatFloat('00.00', Form1.ibDataSet4.FieldByName('ALIQUOTA_NFCE').AsFloat));

    if Form1.ibDataSet4.FieldByName('TIPO_ITEM').AsString = '09' then // 09-Serviço
      sSituacaoTributaria := 'S'
    else
      sSituacaoTributaria := 'T';
  end
  else
  begin
    //
    if Copy(allTrim(Form1.ibDAtaSet4.FieldByName('ST').AsString),1,1) = 'I' then sSituacaoTributaria := 'I' else
      if Copy(allTrim(Form1.ibDAtaSet4.FieldByName('ST').AsString),1,1) = 'F' then sSituacaoTributaria := 'F' else
        if Copy(allTrim(Form1.ibDAtaSet4.FieldByName('ST').AsString),1,1) = 'N' then sSituacaoTributaria := 'N';
  end;

  //if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) = '1') then Mauricio Parizotto 2024-08-15
  if (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) = '1')
    or (LimpaNumero(Form1.ibDataSet13.FieldByname('CRT').AsString) = '4') then
  begin // NÃO É SIMPLES NACIONAL
    if Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString) <> '' then // Se existir CSOSN para NFC-e usa a configuração
    begin
      if (RightStr(Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString), 3) = '102') or (RightStr(Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '103') or (RightStr(Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '300') then
        sSituacaoTributaria := 'I';
      if RightStr(Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '400' then
        sSituacaoTributaria := 'N';
      if RightStr(Trim(Form1.ibDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '500' then
        sSituacaoTributaria := 'F';
    end;
  end
  else
  begin
    if Length(LimpaNumero(Form1.ibDataSet4.FieldByname('CST_NFCE').AsString)) > 1 then
    begin
      if (RightStr('000' + Form1.ibDataSet4.FieldByname('CST_NFCE').AsString, 2) = '60') then
        sSituacaoTributaria := 'F';
      if RightStr('000' + Form1.ibDataSet4.FieldByname('CST_NFCE').AsString, 2) = '40' then
        sSituacaoTributaria := 'I';
      if RightStr('000' + Form1.ibDataSet4.FieldByname('CST_NFCE').AsString, 2) = '41' then
        sSituacaoTributaria := 'N';
    end;
  end;

  if (sSituacaoTributaria = 'I') or (sSituacaoTributaria = 'F') or (sSituacaoTributaria = 'N') then sAliquota := '0000';
end;

procedure RegistrosDoPAFNFCe;
const SELECT_ECF =
  'select distinct R1.SERIE ' +
  ',(select first 1 R3.PDV from REDUCOES R3 where R3.SERIE = R1.SERIE and coalesce(R3.PDV, ''XX'') <> ''XX'' order by R3.REGISTRO desc) as PDV ' +
  ',(select first 1 R4.MODELOECF from REDUCOES R4 where R4.SERIE = R1.SERIE order by R4.REGISTRO desc) as MODELOECF ' +
  'from REDUCOES R1 ' +
  ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' and R1.SMALL <> ''99'' ' +
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
      TipoDeEmissao: String; // Tipo de emissão do documento (<tpEmis>)
      CPFCNPJAdquirente: String; // CPF ou CNPJ do adquirente
      NumeroNF: String; // Número da Nota Fiscal, manual ou eletrônica
      SerieNF: String; // Série da Nota Fiscal, manual ou eletrônica
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletrônica
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
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletrônica
      Evidencia: String; // Controlar se está evidenciado
    end;

    TA2 = record
      Data: TDate;
      CodigoForma: String;
      Forma: String;
      TipoDocumento: String;
      Valor: Double;
      CPFCNPJClienteTipo3: String;
      DocumentoTipo3: String;
      Evidencia: String;
    end;

var
  //
  Mais1Ini : TIniFile;
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
  sAliqISSQN: String;
  IBQECF: TIBQuery;
  IBQALIQUOTASR05: TIBQuery;

  IBQVENDAS: TIBQuery;
  IBQCOMPRAS: TIBQuery;
  IBQFABRICA: TIBQuery;
  IBQBALCAO: TIBQuery;
  IBQRESERVA: TIBQuery;
  IBQR04: TIBQuery;

  sECFSerie: String;
  sDataPrimeiro: String;
  sHoraPrimeiro: String;
  sTipoDocumentoPAF: String;
  sEvidenciaP2: String;
  sEvidenciaR01: String;
  sEcfEvidenciado: String;
  sEvidenciaS2: String;
  sEvidenciaS2Ecf: String;
  sEvidenciaS3: String;
  dEstorno: Double;
  dEstornoCancelado: Double;
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

  slArq: TStringList;
  sArqEstoqueAtual: String;

  sDataEmissaoRZR2: String;
  sHoraEmissaoRZR2: String;

  dA2Cancelado: Double;
  dA2CupomImporta: Double;
  dA2Reclassifica: Double;
  dA2Total: Double;
  dA2Descontar: Double;

  dD2Desconto: Double;
  dD2Total: Double;

  iD3Item: Integer;
  sD3Codigo: String;

  dS2Total: Double;
  sR05CasasQtd: String;
  dR04SubTotal: Currency;
  sS2Conta: String;
  sJ2Quantidade: String;
  sA2Forma: String;
  sMarcaE3: String;
  sModeloEcfE3: String;
  sNumeroSerieEcfE3: String;
  sTipoECFE3: String;
  sMarcaR01: String;
  sTipoECFR01: String;
  sModeloECFR01: String;
  sSequencialR01: String;
  sCRZR01: String;
  sMarcaE3Evidenciado: String;
  sModeloE3Evidenciado: String;
  sEmitenteEvidenciado: String;
  sCRZEvidenciadoR02: String;
  CDSPRIMEIRAIMPRESSAO: TClientDataSet;
  sDadosItemE2: String;
  sHashItemE2: String;
  sA2FiltroCaixa: String;
  sMedidaD3: String;
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

  IBQECF          := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQVENDAS       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQCOMPRAS      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQFABRICA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQBALCAO       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQRESERVA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQALIQUOTASR05 := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQR04          := CriaIBQuery(Form1.IBQuery5.Transaction);

  IBQR04.BufferChunks := 100;

  slArq := TStringList.Create;

  //
  //  sAjuda := 'ecf_cotepe.htm#Estoque';
  try
    //
    Form7.sMfd  := '9';
    Form7.Label1.Caption          := 'Informe o período para o relatório Registros do ' +
                                     'PAF-NFC-e e clique em <Avançar> para continuar.';
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
    {Sandro Silva 2023-02-13 inicio
    if AllTrim(Form1.sNumeroDeSerieDaImpressora) <> '' then
    begin
      Form7.ComboBox1.Text := Form1.sNumeroDeSerieDaImpressora;
    end else
    begin
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSql.Clear;
      //Form1.ibDataSet99.SelectSQL.Add('select SERIE from REDUCOES group by SERIE');
      Form1.IbDataSet99.SelectSQL.Add('select SERIE from REDUCOES where SMALL <> ''59'' and SMALL <> ''65'' and SMALL <> ''99'' group by SERIE');
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
    }

    if Form1.bData then
    begin
      //
      Form7.Caption := 'Registros do PAF-NFC-e - ' + MSG_ALERTA_MENU_FISCAL_INACESSIVEL;
      Form7.ShowModal;

      if Form7.ModalResult <> mrOK then // 2015-07-29
        Exit;

      Form1.Repaint;
      //
      Form1.SaveDialog1.FileName := Form1.sPAstaDoExecutavel+'\REGISTROS_DO_PAF_NFC_e_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss', Now) + '.TXT';

      Form1.Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-NFC-e”');

      Form1.ExibePanelMensagem('Aguarde... Gerando arquivo “Registros do PAF-NFC-e”');
      //
    end;
    //
    Screen.Cursor             := crHourGlass;    // Cursor de Aguardo

    Form1.IBQuery5.Close;                         // saber qual a aliquota associada //
    Form1.IBQuery5.SQL.Text :=
      'select * from ICM where coalesce(ISS, 0) <> 0';
    Form1.IBQuery5.Open;
    //
    sAliqISSQN := '';
    while Form1.IBQuery5.Eof = False do
    begin
      if Form1.IBQuery5.FieldByName('ISS').AsFloat <> 0 then
      begin
        sAliqISSQN := Alltrim(StrZero(Form1.IBQuery5.FieldByName('ISS').AsFloat*100,4,0));
        Break;
      end;
      Form1.IBQuery5.Next;
    end;
    //
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
    { ATIVAR quando houver homologação
    //if not HASHs('DEMAIS',False) then sEvidenciaDeExclusao := '?';
    //if not HASHs('REDUCOES',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('PAGAMENT',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ALTERACA',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ESTOQUE',False)  then sEvidenciaDeExclusao := '?';
    if not HASHs('ORCAMENT',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('NFCE',False)  then sEvidenciaDeExclusao    := '?';
    // Sandro Silva 2017-10-30 if not HASHs('VENDAS',False) then sEvidenciaDeExclusao := '?'; // Sandro Silva 2017-10-30
    // Sandro Silva 2017-10-30 if not HASHs('ITENS001',False)  then sEvidenciaDeExclusao := '?'; // Sandro Silva 2017-10-30
    //
    }
    if sEvidenciaDeExclusao = '?' then
    begin
      sEvidenciaDeExclusao := StrTran(Copy(Form1.ibDataSet13.FieldByName('NOME').AsString+replicate(' ', 50), 1, 50),' ','?');

      //if not HASHs('DEMAIS',False) then LogFrente('Teste 01: Evidência Demais');
      //if not HASHs('REDUCOES',False) then LogFrente('Teste 01: Evidência Reducoes');
      if not HASHs('PAGAMENT',False) then LogFrente('Teste 01: Evidência Pagament');
      if not HASHs('ALTERACA',False) then LogFrente('Teste 01: Evidência Alteraca');
      if not HASHs('ESTOQUE',False)  then LogFrente('Teste 01: Evidência Estoque');
      if not HASHs('ORCAMENT',False) then LogFrente('Teste 01: Evidência Orcament');
      if not HASHs('NFCE',False)     then LogFrente('Teste 01: Evidência NFCE');


    end else
    begin
      sEvidenciaDeExclusao := Copy(Form1.ibDataSet13.FieldByName('NOME').AsString+replicate(' ', 50), 1, 50);
    end;

    {
    sEmitenteEvidenciado := '';
    if not AssinaRegistro('EMITENTE',Form1.ibDataSet13, False) then
      sEmitenteEvidenciado := '?';
    }
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
    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-NFC-e” - A2');

    sA2FiltroCaixa := '';
    if Form1.bData = False then // Está gerando na RZ
      sA2FiltroCaixa := ' and P.CAIXA = ' + QuotedStr(Form1.sCaixa) + ' ';

    Form1.ibQuery5.Close;
    Form1.ibQuery5.SQL.Text :=
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from PAGAMENT P ' +
      'join NFCE on NFCE.NUMERONF = P.PEDIDO and NFCE.CAIXA = P.CAIXA ' +
      'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      sA2FiltroCaixa +
      ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
      ' and P.FORMA not containing ''NF-e'' ' +
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
          iA2Posicao := -1; 
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
        'select P.REGISTRO, P.CLIFOR, P.PEDIDO, P.DATA, P.FORMA, P.VALOR, ''2'' as TIPODOCUMENTO ' +
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
          ' and COMPLEMENTO containing ''' + PARAMETRO_PAFNFCE + ''' ' +
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
          'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.CFOP starting ''5926'' ' +  
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
          'join ITENS002 on ITENS002.NUMERONF = VENDAS.NUMERONF and VENDAS.CLIENTE = ITENS002.FORNECEDOR and ITENS002.CFOP starting ''1926'' ' +  
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

          dA2Reclassifica := dA2Reclassifica + IBQCOMPRAS.FieldByName('TOTAL').AsFloat; 
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Reclassifica));

        bA2 := False;
        iA2Posicao := -1;
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
        { ATIVAR quando houver homologação
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
        }

        sEvidenciaA2 := Copy(aA2[iA2Posicao].Forma + DupeString(' ', 25), 1, 25);
        if aA2[iA2Posicao].Evidencia = '?' then
          sEvidenciaA2 := StringReplace(sEvidenciaA2, ' ', '?', [rfReplaceAll]);
        Writeln(F, 'A2'
                      + FormatDateTime('yyyymmdd', aA2[iA2Posicao].Data)
                      + sEvidenciaA2
                      + aA2[iA2Posicao].TipoDocumento
                      + StrZero(aA2[iA2Posicao].Valor*100,12,0)
                      + Copy(aA2[iA2posicao].CPFCNPJClienteTipo3 + Replicate(' ', 14), 1, 14)
                      + Copy(aA2[iA2posicao].DocumentoTipo3 + Replicate(' ', 10), 1, 10)
                      );
      end;

    end; // for iA2Posicao := 0 to Length(aA2) - 1 do

    ///////////////// FIM A2 ////////////////////////
    /////////////////////////////////////////////////

    //

    Form1.ibDAtaSet4.Close;
    Form1.ibDAtaSet4.SelectSQL.Clear;
    Form1.ibDAtaSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
    Form1.ibDAtaSet4.Open;
    //
    Form1.ibDAtaSet4.First;
    while not Form1.ibDAtaSet4.EOF do
    begin
      //
      if not (Form1.ibDataSet4.FieldByName('ATIVO').AsString='1') then
      begin
        //
        ClassificaAliquotaSituacaoTributaria(sAliquota, sSituacaoTributaria);
        //
        sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('CODIGO').AsString, 14);
        if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
        begin
          sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
        end;
        //
        sUnd := Copy(Form1.ibDAtaSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);

        { ATIVAR quando houver homologação
        if not AssinaRegistro('ESTOQUE',Form1.ibDAtaSet4, False) then
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
        }
        //
        //
        Writeln(F, 'P2' +
                Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)
                + sCodigo
                + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7)
                + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)
                + Copy(Form1.ibDAtaSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)
                + sUnd
                + RightStr('T' + AllTrim(Form1.ibDAtaSet4.FieldByName('IAT').AsString), 1)
                + RightStr('T' + AllTrim(Form1.ibDAtaSet4.FieldByName('IPPT').AsString), 1)
                + RightStr('T' + sSituacaoTributaria, 1) 
                + sAliquota
                + StrZero(Form1.ibDAtaSet4.FieldByName('PRECO').AsFloat*100,12,0));
      end;
      //
      Form1.ibDAtaSet4.Next;
      //
    end;



    ///////////////////////////////////////////////

    //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-NFC-e” - E2');

    //
    Form1.ibDAtaSet4.Close;
    Form1.ibDAtaSet4.SelectSQL.Clear;
    Form1.ibDAtaSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
    Form1.ibDAtaSet4.Open;
    //
    Form1.ibDAtaSet4.First;
    while not Form1.ibDAtaSet4.EOF do
    begin
      //
      if Form1.ibDataSet4.FieldByName('ST').AsString <> '005' then
      begin
        if not (Form1.ibDataSet4.FieldByName('ATIVO').AsString='1') then
        begin
          //
          if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.ibDAtaSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
          begin
            //
            //
            if Form1.ibDAtaSet4.FieldByName('QTD_ATUAL').AsFloat >= 0 then
              sMensuracao := '+'
            else
              sMensuracao := '-';
            //
            sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('CODIGO').AsString, 14);
            if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
            begin
              sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
            end;

            //
            sUnd := copy(Form1.ibDAtaSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);
            //sQtd := Copy(sTexto,Pos('['+sCodigo,sTexto+']')+16,10);  // Quantidade com sinal +/-
            sQtd := RightStr(StrTran(Strzero(Form1.ibDAtaSet4.FieldByName('QTD_ATUAL').AsFloat*1000,9,0),'-','0'), 9);

            if not AssinaRegistro('ESTOQUE',Form1.ibDAtaSet4, False) then
            begin
              sUnd := StrTran(sUnd,' ','?');
            end;

            //
            if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
            begin
              sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
            end;

            Writeln(F, 'E2' +
                    Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)     //CNPJ estabelecimento
                    + sCodigo                                                                                    //Código da mercadoria/serviço
                    + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7) //CEST
                    + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)   //NCM/SH
                    + Copy(Form1.ibDAtaSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)       //Descrição mercadoria
                    + sUnd                                                                                       //Unidade de medida
                    + sMensuracao                                                                                //Mensuração
                    + sQtd                                                                                       //Quantidade em estoque no momento da geração
                    + FormatDateTime('yyyymmdd', Date)                                                           //Data de emissão, que o arquivo foi solicitado
                    + FormatDateTime('yyyymmdd', Date)                                                           //Data da posição do estoque
                    );
          end; // if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.ibDAtaSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
        end; // if not (ibDataSet4ATIVO.AsString='1') then
      end; // if ibDataSet4ST.AsString <> '005' then
      //
      Form1.ibDAtaSet4.Next;
      //
    end; // while not Form1.ibDAtaSet4.EOF do


    /////////////////////////////////////// D2 e D3 INICIO

    //
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSQL.Clear;
    Form1.ibDataSet99.SelectSQL.Add('select PEDIDO, CAIXA, DATA, NUMERONF, COO, sum(TOTAL) as TOTAL, CLIFOR from ORCAMENT where DESCRICAO<>'+QuotedStr('Desconto')+' and DATA>='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' and (TIPO = ''ORCAME'') group by PEDIDO, CAIXA, DATA, NUMERONF, COO, CLIFOR order by PEDIDO');
    Form1.ibDataSet99.Open;
    Form1.ibDataSet99.First;
    //
    Form1.ibDataSet37.DisableControls;
    //
    while not Form1.ibDataSet99.EOF do
    begin
      //

      Form1.ibDataSet37.Close;
      Form1.ibDataSet37.SelectSQL.Clear;
      Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where DESCRICAO = ''Desconto'' and PEDIDO='+QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString)+' ');
      Form1.ibDataSet37.Open;

      dD2Desconto := Form1.ibDataSet37.FieldByName('TOTAL').AsFloat;

      sEvidencia := ' ';
      { ATIVAR quando houver homologação
      Form1.ibDataSet37.Close;
      Form1.ibDataSet37.SelectSQL.Clear;
      Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString)+' ');
      Form1.ibDataSet37.Open;
      // Sandro Silva 2020-11-06  Form1.ibDataSet37.DisableControls;
      //
      sEvidencia := ' ';
      //
      while not Form1.ibDataSet37.Eof do
      begin
        if not AssinaRegistro('ORCAMENT', Form1.ibDataSet37, False) then
          sEvidencia := '?';
        Form1.ibDataSet37.Next;
      end;
      }
      //
      //
      // Sandro Silva 2020-12-14  if Alltrim(Form1.ibDataSet99.FieldByName('CAIXA').AsString) <> '' then
      begin
        Form1.ibDataSet2.Close;
        Form1.ibDataSet2.SelectSQL.Text :=
          'select * ' +// Sandro Silva 2018-02-08  'select CGC, NOME ' +
          'from CLIFOR ' +
          'where NOME = ' + QuotedStr(Trim(Form1.ibDataSet99.FieldByName('CLIFOR').AsString)) +
          ' and coalesce(CGC, '''') <> '''' ';
        Form1.ibDataSet2.Open;

        dD2Total := Form1.ibDataSet99.FieldByName('TOTAL').AsFloat - dD2Desconto;
        if dD2Total < 0 then
          dD2Total := 0;

        Writeln(F, 'D2' +
                   Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                   Right('0000000000000' + Form1.ibDataSet99.FieldByName('PEDIDO').AsString, 13) + // Número do DAV
                   FormatDateTime('YYYYMMDD', Form1.ibDataSet99.FieldByName('DATA').AsDateTime) + // Data do DAV
                   Copy('ORCAMENTO'+Replicate(' ',30),1,30) + // Título
                   StrZero(dD2Total*100,8,0)+  // Valor total do DAV // Sandro Silva 2021-01-12 StrZero(Form1.ibDataSet99.FieldByName('TOTAL').AsFloat*100,8,0)+  // Valor total do DAV
                   Copy(Form1.ibDataSet99.FieldByName('CLIFOR').AsString + Replicate(' ',40), 1, 40)+ // Nome do cliente
                   Right('00000000000000' + LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString), 14) // CPF ou CNPJ do adquirente
                   );
      end;
      //
      Form1.ibDataSet99.Next;
      //
    end;
    //

    Form1.ibDataSet99.First;

    while not Form1.ibDataSet99.EOF do
    begin
      //
      //
      // Sandro Silva 2020-12-14  if Alltrim(Form1.ibDataSet99.FieldByName('CAIXA').AsString) <> '' then
      begin
        //
        // Desconto no total
        //
        //
        Form1.ibDataSet999.Close;
        Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
        Form1.ibDataSet999.SelectSql.Clear;
        Form1.ibDataSet999.SelectSQL.Text :=
          'select sum(TOTAL) as DESCONTO ' +
          'from ORCAMENT ' +
          'where PEDIDO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' and DESCRICAO = ''Desconto'' ' +
          ' and (TIPO = ''ORCAME'') ';
        Form1.ibDataSet999.Open;
        //
        //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
        //
        rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat;

        dD2Total := Form1.ibDataSet99.FieldByName('TOTAL').AsFloat - dD2Desconto;

        Form1.ibDataSet37.Close;
        Form1.ibDataSet37.SelectSQL.Clear;
        Form1.ibDataSet37.SelectSQL.Text :=
          'select * ' +
          'from ORCAMENT ' +
          'where PEDIDO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' and coalesce(CODIGO, '''') <> '''' ' +
          ' and (TIPO = ''ORCAME'') ' +
          ' order by REGISTRO';
        Form1.ibDataSet37.Open;

        //
        iD3Item := 0; // Sandro Silva 2021-01-12
        while not Form1.ibDataSet37.Eof do
        begin
          sEvidencia := ' ';
          { ATIVAR quando houver homologação
          if not AssinaRegistro('ORCAMENT', Form1.ibDataSet37, False) then
            sEvidencia := '?';
          }
          //
          // Sandro Silva 2021-01-13  dDescontoItem := StrToFloat(FormatFloat('0.00', (Form1.ibDataSet37.FieldByName('UNITARIO').AsFloat / Form1.ibDataSet99.FieldByName('TOTAL').AsFloat) * Form1.ibDataSet37.FieldByName('TOTAL').AsFloat));
          dDescontoItem := StrToFloat(FormatFloat('0.00', (Form1.ibDataSet37.FieldByName('TOTAL').AsFloat / Form1.ibDataSet99.FieldByName('TOTAL').AsFloat) * rDesconto));

          sD3Codigo := Form1.ibDataSet37.FieldByName('CODIGO').AsString;

          Form1.ibDataSet4.Close;
          Form1.ibDataSet4.SelectSQL.Text :=
            'select * ' +
            'from ESTOQUE ' +
            'where CODIGO = ' + QuotedStr(Form1.ibDataSet37.FieldByName('CODIGO').AsString);
          Form1.ibDataSet4.Open;

          if Form1.ibDataSet4.FieldByName('REFERENCIA').AsString <> '' then
            sD3Codigo := Form1.ibDataSet4.FieldByName('REFERENCIA').AsString;

          { ATIVAR quando houver homologação
          if not AssinaRegistro('ESTOQUE', Form1.ibDataSet4, False) then
            sEvidencia := '?';
          }

          sMedidaD3 := Form1.ibDataSet37.FieldByName('MEDIDA').AsString;
          if Trim(sMedidaD3) = '' then
            sMedidaD3 := Form1.ibDataSet4.FieldByName('MEDIDA').AsString;
          ClassificaAliquotaSituacaoTributaria(sAliquota, sSituacaoTributaria);

          sDescricaoItem := Form1.ibDataSet37.FieldByName('DESCRICAO').AsString + DupeString(' ',100);
          { ATIVAR quando houver homologação
          if sEvidencia = '?' then
            sDescricaoItem := StringReplace(sDescricaoItem, ' ', '?', [rfReplaceAll]);
          }

          if Form1.ibDataSet37.FieldByName('DESCRICAO').AsString <> 'Descricao' then
            Inc(iD3Item);

          Writeln(F, 'D3' +
                     Right('0000000000000' + Form1.ibDataSet99.FieldByName('PEDIDO').AsString, 13) + // Número do DAV
                     FormatDateTime('YYYYMMDD', Form1.ibDataSet37.FieldByName('DATA').AsDateTime) + // Data do DAV
                     Right('000' + FormatFloat('000', iD3Item), 3) + // Numero do item 3 // Sandro Silva 2021-01-12 Right('000' + Form1.ibDataSet37.FieldByName('ITEM').AsString, 3) + // Numero do item 3
                     Right('00000000000000' + sD3Codigo, 14) + // Codigo do produto 14 // Sandro Silva 2021-01-12 Right('00000000000000' + Form1.ibDataSet37.FieldByName('CODIGO').AsString, 14) + // Codigo do produto 14
                     Copy(sDescricaoItem, 1, 100) + // Descricao 100
                     StrZero(Form1.ibDataSet37.FieldByName('QUANTIDADE').AsFloat*1000,7,0)+ // Quantidade 7
                     Copy(sMedidaD3+'   ',1,3)+ // Unidade 3
                     StrZero(Form1.ibDataSet37.FieldByName('UNITARIO').AsFloat*100,8,0)+ // valor unitario 8
                     StrZero(dDescontoItem*100,8,0)+ // Desconto sobre o item 8
                     StrZero(0.00,8,0)+ // Acrescimo sobre o item 8
                     StrZero((Form1.ibDataSet37.FieldByName('TOTAL').AsFloat - dDescontoItem) *100,14,0)+ //  Valor total liquido 14
                     sSituacaoTributaria + // Situacao tributaria 1
                     sAliquota + // Aliquita 4
                     'N' + // Indicador de cancelamento 1
                     '3'+ // Casas decimais da quantidade
                     '2' // Casas decimais de valor unitário
                     );
          Form1.ibDataSet37.Next;
        end; // if Form1.ibDataSet37.EOF = False do

      end;
      //
      Form1.ibDataSet99.Next;
      //
    end;


    Form1.ibDataSet37.EnableControls; // Sandro Silva 2020-11-06



    /////////////////////////////////////// D2 e D3 FIM

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

        //Não encontrei limite para listar mesas abertas if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////
          // S2
          /////////////////////

          //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-NFC-e” - S2');

          // Seleciona as mesas com data de lançamento no período selecionado

          Form1.ibQuery5.Close;
          Form1.ibQuery5.SQL.Clear;
          Form1.ibQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL)as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA, max(coalesce(COO,'''')) as COO ' +
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
              sStituacao := Right('000000000' + Form1.ibQuery5.FieldByName('COO').AsString, 9);
            end else
            begin
              sStituacao := Replicate(' ', 9); // Na ER o campo COO é alfanumérico
            end;

            sEvidenciaS2 := '';
            { ATIVAR quando houver homologação
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
            Form1.ibDataSet27.Open;

            sEvidenciaS2 := '';
            while Form1.ibDataSet27.Eof = False do
            begin
              if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) or (sEvidenciaS2Ecf = '?') then
              begin
                sEvidenciaS2 := '??????????';
              end;
              Form1.ibDataSet27.Next;
            end;
            }

            dS2Total := 0.00;
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString) +
             ' and coalesce(VENDEDOR, '''') <> ''<cancelado>'' ' +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
            Form1.ibDataSet27.Open;

            while Form1.ibDataSet27.Eof = False do
            begin
              dS2Total := dS2Total + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;
              Form1.ibDataSet27.Next;
            end;

            sS2Conta := Copy(RightStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString, 3) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);  // Número da mesa/Conta cliente
            if Copy(Form1.sConcomitante,1,2) = 'OS' then
              sS2Conta := Copy(Right(Form1.ibQuery5.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);   // Conta cliente OS

            if Pos(sEmitenteEvidenciado, '?') > 0 then
            begin
              sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]);  // Conta cliente OS
            end;

            Writeln(F,  'S2' +                                                          // Tipo S2
                        Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                        FormatDateTime('yyyymmdd', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // DD
                        FormatDateTime('HHnnss', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // HORA
                        sS2Conta +
                        StrZero(dS2Total * 100, 13, 0) +
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

        //Não encontrei limite para listar mesas abertas if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////////
          // S3
          /////////////////////////
          //Display('Aguarde...', 'Aguarde... Gerando arquivo “Registros do PAF-NFC-e” - S3');

          Form1.ibQuery5.Close;
          Form1.ibQuery5.SQL.Clear;
          // somente no caso de Mesa ou Conta de Cliente com situação “aberta”, mesmo que ele tenha sido marcado para cancelamento.
          Form1.ibQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL) as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA ' +
            'from ALTERACA ' +
            'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('PEDIDO').AsString) +
            ' and DESCRICAO<>''<CANCELADO>'' ' +
            'group by PEDIDO order by IDATAHORA ';
          Form1.ibQuery5.Open;
          //

          while not Form1.ibQuery5.Eof do
          begin
            //
            Form1.ibQuery6.Close;
            Form1.ibQuery6.SQL.Clear;
            Form1.ibQuery6.SQL.Add('select * from ALTERACA where PEDIDO='+QuotedStr(Form1.ibQuery5.FieldByName('PEDIDO').AsString)+' and DESCRICAO<>''<CANCELADO>'' and (TIPO = ''MESA'' or TIPO = ''DEKOL'' ) order by REGISTRO');
            Form1.ibQuery6.Open;
            //
            while not Form1.ibQuery6.Eof do
            begin
              sEvidenciaS3 := '';
              { ATIVAR quando houver homologação
              Form1.ibDataSet27.Close;
              Form1.ibDataSet27.SelectSQL.Text :=
               'select * ' +
               'from ALTERACA ' +
               'where PEDIDO = ' + QuotedStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString) +
               ' and ITEM = ' + QuotedStr(Form1.ibQuery6.FieldByName('ITEM').AsString) +
               ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
              Form1.ibDataSet27.Open;

              sEvidenciaS3 := '';
              while Form1.ibDataSet27.Eof = False do
              begin
                if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
                begin
                  sEvidenciaS3 := '??????????';
                end;
                Form1.ibDataSet27.Next;
              end;
              }

              sCodigo := Form1.ibQuery6.FieldByName('CODIGO').AsString;
              if Trim(Form1.ibQuery6.FieldByName('REFERENCIA').AsString) <> '' then
              begin
                sCodigo := Right('00000000000000' + Form1.ibQuery6.FieldByName('REFERENCIA').AsString, 14);
              end;

              sS2Conta := Copy(RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3)+ sEvidenciaS3 + Replicate(' ', 10), 1, 13);  // Número da mesa/Conta cliente
              if Copy(Form1.sConcomitante,1,2) = 'OS' then
                sS2Conta := Copy(Right(Form1.ibQuery6.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS3 + Replicate(' ', 10), 1, 13);   // Conta cliente OS

              if Pos(sEmitenteEvidenciado, '?') > 0 then
              begin
                sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]); // Conta cliente OS
              end;

              Writeln(F,  'S3' +                                                          // Tipo S3
                          right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                          FormatDateTime('yyyymmdd', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime) + // Data de abertura
                          FormatDateTime('HHnnss', Form1.ibQuery5.FieldByName('IDATAHORA').AsDateTime)+ // Hora de abertura
                          sS2Conta +  // Número da Mesa/Conta de Cliente
                          Right('000000000'+sCodigo, 14)+ // Código do produto ou serviço
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

    //**********************
    //
    // J1 INÍCIO
    //

    try
      //
      //J1 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no período
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, NFEXML, NFEID, NUMERONF ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        ' and ((coalesce(NFEID, '''') <> '''') or (coalesce(NFEXML, '''') containing ''Id="'') ) '  + // Sandro Silva 2021-01-15  ' and coalesce(NFEID, '''') <> '''' '  +
        ' and DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and (coalesce(NFEXML, '''') containing ''<tpAmb>1</tpAmb>'' or (coalesce(NFEXML, '''') containing ''<CNPJ>07426598000124</CNPJ>'' and coalesce(NFEXML, '''') containing ''<tpAmb>2</tpAmb>'')) ' + // Somente em produção ou emitente seja Smallsoft
        // Sandro Silva 2021-01-12  ' and (status containing ''Autorizad'' or status containing ''Cancelad'') ' +
        ' order by PDV, NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      //sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //

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
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
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
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as DESCONTO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
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
              ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
              ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
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
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet999.Open;
            //
            rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
            //
            sEvidencia := ' ';
            { ATIVAR quando houver homologação
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Clear;
            Form1.ibDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              // Sandro Silva 2020-12-10  ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet27.Open;
            Form1.ibDataSet27.DisableControls;
            //
            sEvidencia := ' ';
            //
            Form1.ibDataSet27.First;
            while not Form1.ibDataSet27.Eof do
            begin
              if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
              begin
                //          SmallMsg('Registro: '+Form1.Form1.ibDataSet27.FieldByName('REGISTRO').AsString);
                sEvidencia := '?';
              end;
              Form1.ibDataSet27.Next;
            end;
            }

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
            ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and MODELO = ''65'' ';
            Form1.ibDataSet999.Open;

            { ATIVAR quando houver homologação
            if not AssinaRegistro('NFCE',Form1.ibDataSet999, False) then
            begin
              //          SmallMsg('Registro: '+Form1.Form1.ibDataSet27.FieldByName('REGISTRO').AsString);
              sEvidencia := '?';
            end;
            }

            if IBQECF.FieldByName('NFEID').AsString <> '' then 
            begin
              sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
            end
            else
            begin
              sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//chNFe')) + DupeString(' ', 44), 1, 44);
              if Trim(sChaveAcessoDocumento) = '' then
                sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//infNFe/@Id')) + DupeString(' ', 44), 1, 44);
            end;
            sNumeroNF             := Copy(sChaveAcessoDocumento, 26, 9);
            sSerieNF              := Copy(sChaveAcessoDocumento, 23, 3);
            if Trim(sSerieNF) <> '' then
              sSerieNF := Copy(IntToStr(StrToInt(sSerieNF)) + '   ', 1, 3)
            else
              sSerieNF := '   ';

            bJ1 := False;
            iJ1Posicao := -1;
            for iJ1 := 0 to Length(aJ1) - 1 do
            begin
              if (aJ1[iJ1].NumeroNF = sNumeroNF)
                and (aJ1[iJ1].SerieNF = sSerieNF)
              then
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
              aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString);
              aJ1[iJ1Posicao].NumeroNF                      := sNumeroNF;
              aJ1[iJ1Posicao].SerieNF                       := sSerieNF;
              aJ1[iJ1Posicao].ChaveAcesso                   := sChaveAcessoDocumento;
              aJ1[iJ1Posicao].TipoDeEmissao                 := Copy(sChaveAcessoDocumento, 35, 1);
            end;
            aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado);
            aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
            aJ1[iJ1Posicao].Evidencia         := sEvidencia;

            if aJ1[iJ1Posicao].Evidencia = '?' then
              aJ1[iJ1Posicao].SerieNF := StringReplace(aJ1[iJ1Posicao].SerieNF, ' ', '?',[rfReplaceAll]);

          except
            SmallMsg('Erro ao criar registro J1 NFC-e');
          end;

          Form1.IbDataSet100.Next;
        end;
        //
        //sPDV := IBQECF.FieldByName('PDV').AsString;
        //
        //
        IBQECF.Next;
        //
      end;

      // Salvando J1 no arquivo
      for iJ1 := 0 to Length(aJ1) - 1 do
      begin
        try
          Writeln(F, 'J1' + // Tipo
                     Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                     FormatDateTime('yyyymmdd', aJ1[iJ1].DataEmissao) +           // Data de emissão do documento fiscal
                     StrZero(((aJ1[iJ1].SubTotal) * 100), 14, 0) +                // Valor total do documento, com duas casas decimais.
                     StrZero(((aJ1[iJ1].DescontoSubTotal) * 100), 13, 0) +        // Valor do desconto ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                     aJ1[iJ1].IndicadorTipoDesconto +                             // Informar “V” para valor monetário ou “P” para percentual
                     StrZero(((aJ1[iJ1].AcrescimoSubTotal) * 100), 13, 0) +       // Valor do acréscimo ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                     aJ1[iJ1].IndicadorTipoAcrescimo +                            // Informar “V” para valor monetário ou “P” para percentual
                     StrZero(((aJ1[iJ1].ValorTotalLiquido) * 100), 14, 0) +       // Valor total do Cupom Fiscal após desconto/acréscimo, com duas casas decimais.
                     aJ1[iJ1].TipoDeEmissao +                              // Tipo de emissão
                     Copy(aJ1[iJ1].ChaveAcesso + DupeString('0', 44), 1, 44) +    // Chave de Acesso da Nota Fiscal Eletrônica
                     Right('0000000000' + aJ1[iJ1].NumeroNF, 10) +                // Número da Nota Fiscal, manual ou eletrônica
                     aJ1[iJ1].SerieNF +                                           // Série da Nota Fiscal, manual ou eletrônica
                     Right(Replicate('0',14) + aJ1[iJ1].CPFCNPJAdquirente, 14)    // CPF ou CNPJ do adquirente
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

    try
      //
      //sPDV := 'XXX';
      //

      //J2 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no período
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, NFEID, NFEXML, NUMERONF ' +
        'from NFCE ' +
        'where (MODELO = ''65'') ' +
        ' and ((coalesce(NFEID, '''') <> '''') or (coalesce(NFEXML, '''') containing ''Id="'')) '  +
        ' and (DATA between  ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) + ') ' +
        ' and (coalesce(NFEXML, '''') containing ''<tpAmb>1</tpAmb>'' or (coalesce(NFEXML, '''') containing ''<CNPJ>07426598000124</CNPJ>'' and coalesce(NFEXML, '''') containing ''<tpAmb>2</tpAmb>'')) ' + // Somente em produção ou emitente seja Smallsoft
        ' and ((substring(coalesce(NFEID, '''') from 35 for 1) = ''9'') or (coalesce(NFEXML, '''') containing ''<tpEmis>9</tpEmis>'')) ' + // 9-tipo emissão em contingência // Sandro Silva 2021-01-13 ' and substring(NFEID from 35 for 1) = ''9'' ' + // 9-tipo emissão em contingência
        ' order by PDV, NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      //sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //
        begin
          //
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSql.Clear;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
            ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
            ' and coalesce(SERIE, '''') = '''' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 Não exibir os cancelamentos dos descontos dos itens cancelados
            'order by DATA, CCF, ITEM';
          Form1.ibDataSet27.Open;
          Form1.ibDataSet27.First;
          //
          while not Form1.ibDataSet27.Eof do
          begin
            //
            try
              if (Alltrim(Form1.ibDataSet27.FieldByName('PEDIDO').AsString) <> '')
                and (Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
                and (Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acréscimo') then
              begin
                //
                //
                if Pos('I', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                  sTabela := 'I'
                else
                  if Pos('F', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                    sTabela := 'F'
                  else
                    if Pos('N', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                      sTabela := 'N'
                    else
                    begin
                      sTabela := LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString);
                      if sTabela = '' then
                        sTabela := 'I'
                      else
                        sTabela := 'T' + Right('0000' + sTabela, 4);
                    end;

                if Copy(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
                begin
                  sTabela := 'S' + sAliqISSQN;
                end;

                sTabela := Copy(sTabela + '       ', 1, 7);

                //
                sCancel := 'N';
                if (Pos('<CANCELADO>', Trim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
                begin
                  // Se o cupom foi cancelado o item deve ficar como "N"
                  // Se o item foi cancelado deve ficar como "S"
                  sCancel := 'S';
                end;

                sEvidencia := ' ';
                { ATIVAR quando houver homologação
                if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
                  sEvidencia := '?';
                }

                // Desconto do item
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('PEDIDO').AsString) +
                  ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                  ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
                  ' and ITEM = ' + QuotedStr(Form1.ibDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                  ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet27.FieldByName('DATA').AsDateTime)) +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;
                //
                //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                //
                dDescontoItem := 0.00;
                if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then
                  dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1;

                { ATIVAR quando houver homologação
                if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                  if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                     sEvidencia := '?';
                }

                sDescricaoItem := Form1.ibDataSet27.FieldByName('DESCRICAO').AsString;

                if (Trim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
                begin
                  Form1.ibDataSet999.Close;
                  Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                  Form1.ibDataSet999.SelectSql.Clear;
                  Form1.ibDataSet999.SelectSQL.Text :=
                    'select DESCRICAO ' +
                    'from ESTOQUE ' +
                    'where CODIGO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString);
                  Form1.ibDataSet999.Open;
                  sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
                end;
                //
                //
                { ATIVAR quando houver homologação
                if not AssinaRegistro('NFCE',IBQECF, False) then
                begin
                  sEvidencia := '?';
                end;
                }

                if IBQECF.FieldByName('NFEID').AsString <> '' then // Sandro Silva 2021-01-13
                begin
                  sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
                end
                else
                begin
                  sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//chNFe')) + DupeString(' ', 44), 1, 44);
                  if Trim(sChaveAcessoDocumento) = '' then
                    sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//infNFe/@Id')) + DupeString(' ', 44), 1, 44);
                end;
                sNumeroNF             := Copy(sChaveAcessoDocumento, 26, 9);
                sSerieNF              := Copy(sChaveAcessoDocumento, 23, 3);

                if Trim(sSerieNF) <> '' then
                  sSerieNF := Copy(IntToStr(StrToInt(sSerieNF)) + '   ', 1, 3)
                else
                  sSerieNF := '   ';

                if sEvidencia = '?' then
                  sSerieNF := StringReplace(sSerieNF, ' ', '?', [rfReplaceAll]);

                SetLength(aJ2, Length(aJ2) + 1);
                iJ2Posicao := High(aJ2);

                aJ2[iJ2Posicao].Tipo                       := 'J2';
                aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ2[iJ2Posicao].DataEmissao                := Form1.ibDataSet27.FieldByName('DATA').AsDateTime;
                aJ2[iJ2Posicao].NumeroItem                 := Form1.ibDataSet27.FieldByName('ITEM').AsString;
                aJ2[iJ2Posicao].CodigoProduto              := Form1.ibDataSet27.FieldByName('REFERENCIA').AsString;
                aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
                aJ2[iJ2Posicao].Quantidade                 := Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat;
                aJ2[iJ2Posicao].Unidade                    := Form1.ibDataSet27.FieldByName('MEDIDA').AsString;
                aJ2[iJ2Posicao].ValorUnitario              := Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat;
                aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
                aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
                aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.ibDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem;
                aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
                aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
                aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
                aJ2[iJ2Posicao].ChaveAcesso                := sChaveAcessoDocumento;
                aJ2[iJ2Posicao].NumeroNF                   := sNumeroNF;
                aJ2[iJ2Posicao].SerieNF                    := sSerieNF;
                aJ2[iJ2Posicao].Evidencia                  := sEvidencia;
              end;
            except
              SmallMsg('Erro ao criar registro J2 NFC-e');
            end;
            Form1.ibDataSet27.Next;
          end;
          //
          //
        end;
        //
        IBQECF.Next;
      end;

      // Salvando J2 no arquivo
      for iJ2 := 0 to Length(aJ2) - 1 do
      begin
        try
          sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 100), 7, 0);
          if AnsiUpperCase(aJ2[iJ2].Unidade) = 'KG' then
          begin
            sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 1000), 7, 0);
            aJ2[iJ2].CasasDecimaisQuantidade    := '3';
          end;

          Writeln(F,  'J2' +                                                                                // J2
                       Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                       FormatDateTime('yyyymmdd', aJ2[iJ2].DataEmissao) +                                   // Data de emissão do documento fiscal
                       Right('000' + aJ2[iJ2].NumeroItem, 3) +                                              // Número do item registrado no documento
                       Right(DupeString('0', 14) + aJ2[iJ2].CodigoProduto, 14) +                            // Código do produto ou serviço registrado no documento. 
                       Copy(aJ2[iJ2].Descricao + DupeString(' ', 100), 1, 100) +                            // Descrição do produto ou serviço constante no Cupom Fiscal
                       sJ2Quantidade +                                                                      // Quantidade comercializada, sem a separação das casas decimais
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
                       Copy(aJ2[iJ2].ChaveAcesso + DupeString(' ', 44), 1, 44)                              // Chave de Acesso da Nota Fiscal Eletrônica
                  );

        except
          SmallMsg('Erro ao criar registro J2');
        end;
      end;

      aJ1 := nil;
      aJ2 := nil; 
      
    except
      SmallMsg('Erro ao criar registro J2');
    end;
    
    //
    // J2 FINAL
    //
    //**********************

    aA2 := nil;

    FreeAndNil(CDSPRIMEIRAIMPRESSAO);

    Form1.OcultaPanelMensagem;

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
  end;
  FreeAndNil(IBQECF);
  FreeAndNil(IBQVENDAS);
  FreeAndNil(IBQCOMPRAS);
  FreeAndNil(IBQFABRICA);
  FreeAndNil(IBQBALCAO);
  FreeAndNil(IBQRESERVA);
  FreeAndNil(IBQALIQUOTASR05);
  FreeAndNil(IBQR04); 

  FreeAndNil(slArq);



  Form1.OcultaPanelMensagem
end;

end.
