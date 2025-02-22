unit uRelatorioVendasNotaFiscal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, CheckLst,
  ComCtrls, uIEstruturaTipoRelatorioPadrao, uIEstruturaRelatorioPadrao,
  IBQuery, DB, DBClient, smallfunc_xe;

type
  TfrmRelVendasNotaFiscal = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    pnlSelOperacoes: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    chkOperacoes: TCheckListBox;
    btnMarcarTodosOper: TBitBtn;
    btnDesmarcarTodosOper: TBitBtn;
    rbRelatorioICMS: TRadioButton;
    rbItemPorITem: TRadioButton;
    cbListarCodigos: TCheckBox;
    cdsRelICMS: TClientDataSet;
    cdsItemPorItem: TClientDataSet;
    cdsItemPorItemNOTA: TStringField;
    cdsItemPorItemEMISSAO: TDateField;
    cdsItemPorItemQUANTIDADE: TFMTBCDField;
    cdsItemPorItemVENDIDOPOR: TFMTBCDField;
    cdsItemPorItemCUSTOCOMPRA: TFMTBCDField;
    cdsItemPorItemCODIGO: TStringField;
    cdsItemPorItemDESCRICAO: TStringField;
    cdsRelICMSNOTA: TStringField;
    cdsRelICMSEMISSAO: TDateField;
    cdsRelICMSCLIENTE: TStringField;
    cdsRelICMSMERCADORIA: TFMTBCDField;
    cdsRelICMSSERVICOS: TFMTBCDField;
    cdsRelICMSFRETE: TFMTBCDField;
    cdsRelICMSDESCONTO: TFMTBCDField;
    cdsRelICMSDESPESAS: TFMTBCDField;
    cdsRelICMSTOTAL: TFMTBCDField;
    cdsRelICMSICMS: TFMTBCDField;
    cbSubstituicaoTributICMS: TCheckBox;
    cdsRelICMSICMSSUBSTI: TFMTBCDField;
    cbSubstituicaoTributItem: TCheckBox;
    cdsItemPorItemNCM: TStringField;
    cdsItemPorItemVICMSST: TFMTBCDField;
    cbNCM: TCheckBox;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure rbRelatorioICMSClick(Sender: TObject);
    procedure rbItemPorITemClick(Sender: TObject);
    procedure btnMarcarTodosOperClick(Sender: TObject);
    procedure btnDesmarcarTodosOperClick(Sender: TObject);
  private
    FqryDados: TIBQuery;
    FnDecimaisValor: Integer;
    FnDecimaisQuantidade: Integer;
    function FazValidacoes: Boolean;
    procedure AjustaLayout;
    procedure CarregaDados;
    procedure CarregaDadosItemAItem;
    procedure CarregaDadosICMS;
    procedure DefinirEnabledListarCodigo;
    function RetornarDescrFiltroData: string;
    function RetornarWhereOperacoes: String;
    procedure AjustaCasasDecimais;
  public
    property DecimaisValor: Integer read FnDecimaisValor write FnDecimaisValor;
    property DecimaisQuantidade: Integer read FnDecimaisQuantidade write FnDecimaisQuantidade;
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelVendasNotaFiscal: TfrmRelVendasNotaFiscal;

implementation

uses
  uRetornaOperacoesRelatorio, uSmallResourceString, uEstruturaTipoRelatorioPadrao,
  uDadosRelatorioPadraoDAO, uFuncoesBancoDados, uSmallEnumerados, uDialogs,
  uEstruturaRelVendasNotaFiscal;

{$R *.dfm}

{ TfrmRelVendasNotaFiscal }

function TfrmRelVendasNotaFiscal.Estrutura: IEstruturaTipoRelatorioPadrao;
var
  i: Integer;
  cAux: String;
  oEstruturaCat: IEstruturaRelatorioPadrao;

  cdsImprimir: TClientDataSet;
begin
  Result := TEstruturaTipoRelatorioPadrao.New
                                         .setUsuario(Usuario);

  CarregaDados;

  if rbRelatorioICMS.Checked then
    cdsImprimir := cdsRelICMS;
  if rbItemPorITem.Checked then
    cdsImprimir := cdsItemPorItem;

  oEstruturaCat := TEstruturaRelVendasNotaFiscal.New
                                                .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                .setDataBase(Transaction.DefaultDatabase)
                                                                                .CarregarDados(cdsImprimir)
                                                       );

  // Monta os filtros
  oEstruturaCat.FiltrosRodape.setFiltroData(RetornarDescrFiltroData);

  if rbRelatorioICMS.Checked then
  begin
    cAux := rbRelatorioICMS.Caption;
    if cbSubstituicaoTributICMS.Checked then
      cAux := cAux + ' (' + cbSubstituicaoTributICMS.Caption + ')';
    oEstruturaCat.FiltrosRodape.AddItem(cAux);
    oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;
  if rbItemPorITem.Checked then
  begin
    if cbListarCodigos.Checked then
      cAux := cbListarCodigos.Caption;
    if cbSubstituicaoTributItem.Checked then
    begin
      if cAux <> EmptyStr then
        cAux := cAux + ', ';
      cAux := cAux + cbSubstituicaoTributItem.Caption;
    end;
    if cbNCM.Checked then
    begin
      if cAux <> EmptyStr then
        cAux := cAux + ', ';
      cAux := cAux + cbNCM.Caption;
    end;
    if cAux <> EmptyStr then
      cAux := rbItemPorITem.Caption + ' (' + cAux + ')'
    else
      cAux := rbItemPorITem.Caption;

    oEstruturaCat.FiltrosRodape.AddItem(cAux);
    oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;

  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
    oEstruturaCat.FiltrosRodape.AddItem('<b>Opera��es listadas:</b>')
  else
    oEstruturaCat.FiltrosRodape.AddItem('Opera��es listadas:');
  oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);

  for i := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if chkOperacoes.Checked[I] then
      oEstruturaCat.FiltrosRodape.AddItem(chkOperacoes.Items[i]);
  end;
  // Gera o relat�rio
  Estrutura.GerarImpressao(oEstruturaCat);
end;

function TfrmRelVendasNotaFiscal.RetornarWhereOperacoes: String;
var
  i: integer;
begin
  for I := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if not chkOperacoes.Checked[I] then
      Result := Result + ' AND (VENDAS.OPERACAO<>'+QuotedStr(chkOperacoes.Items[I])+') ';
  end;
end;

function TfrmRelVendasNotaFiscal.RetornarDescrFiltroData: string;
begin
  Result := 'Per�odo analisado, de '+DateToStr(dtInicial.Date)+' at� ' + DateToStr(dtFinal.Date);
end;

procedure TfrmRelVendasNotaFiscal.btnVoltarClick(Sender: TObject);
begin
  if pnlSelOperacoes.Visible then
  begin
    pnlSelOperacoes.Visible := False;
    pnlPrincipal.Visible    := True;
    btnAvancar.Caption      := 'Avan�ar >'; // Mauricio Parizotto 2024-03-20
  end;

  btnVoltar.Enabled := (not pnlPrincipal.Visible);
  inherited;  
end;

procedure TfrmRelVendasNotaFiscal.btnAvancarClick(Sender: TObject);
begin
  if (pnlSelOperacoes.Visible) then
    inherited
  else
  begin
    if (pnlPrincipal.Visible) then
    begin
      if not FazValidacoes then
        Exit;
      pnlPrincipal.Visible := False;
      pnlSelOperacoes.Visible := True;
      btnAvancar.Caption      := 'Gerar'; // Mauricio Parizotto 2024-03-20

      TRetornaOperacoesRelatorio.New
                                .setDataBase(Transaction.DefaultDatabase)
                                .setOperacaoVenda
                                .CarregaDados
                                .DefineItens(chkOperacoes);
    end;
  end;
  btnVoltar.Enabled := (not pnlPrincipal.Visible);
end;

function TfrmRelVendasNotaFiscal.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    MensagemSistema(_cPeriodoDataInvalida,msgAtencao);
    dtInicial.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelVendasNotaFiscal.CarregaDados;
begin
  if not Assigned(FqryDados) then
    FqryDados := CriaIBQuery(Transaction);

  if rbRelatorioICMS.Checked then
  begin
    CarregaDadosICMS;
    cdsRelICMS.First;
  end;
  if rbItemPorITem.Checked then
  begin
    CarregaDadosItemAItem;
    cdsItemPorItem.First;    
  end;
end;

procedure TfrmRelVendasNotaFiscal.CarregaDadosItemAItem;
var
  i: Integer;
begin
  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('SELECT');
  FqryDados.SQL.Add('    SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9)||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS NOTA');
  FqryDados.SQL.Add('    , VENDAS.EMISSAO AS EMISSAO');
  FqryDados.SQL.Add('    , ITENS001.CODIGO AS CODIGO');
  FqryDados.SQL.Add('    , ITENS001.DESCRICAO AS DESCRICAO');
  FqryDados.SQL.Add('    , ITENS001.QUANTIDADE AS QUANTIDADE');
  FqryDados.SQL.Add('    , (ITENS001.QUANTIDADE * ITENS001.UNITARIO) AS VENDIDOPOR');
  FqryDados.SQL.Add('    , (ITENS001.QUANTIDADE * ITENS001.CUSTO) AS CUSTOCOMPRA');
  FqryDados.SQL.Add('    , ITENS001.VICMSST AS VICMSST');
  FqryDados.SQL.Add('    , ESTOQUE.CF AS NCM');
  FqryDados.SQL.Add('FROM VENDAS');
  FqryDados.SQL.Add('INNER JOIN ITENS001');
  FqryDados.SQL.Add('    ON (ITENS001.NUMERONF=VENDAS.NUMERONF)');
  FqryDados.SQL.Add('LEFT JOIN ESTOQUE');
  FqryDados.SQL.Add('    ON (ESTOQUE.CODIGO=ITENS001.CODIGO)');
  FqryDados.SQL.Add('WHERE');
  FqryDados.SQL.Add('    (EMITIDA=''S'')');
  FqryDados.SQL.Add('    AND (EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
  FqryDados.SQL.Add(RetornarWhereOperacoes);
  FqryDados.SQL.Add('ORDER BY VENDAS.EMISSAO, VENDAS.NUMERONF, ITENS001.REGISTRO');
  FqryDados.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  FqryDados.ParamByName('XDATAFIM').AsDate := dtFinal.Date;
  FqryDados.Open;
  FqryDados.First;

  cdsItemPorItemCODIGO.Visible := cbListarCodigos.Checked;
  cdsItemPorItemVICMSST.Visible := cbSubstituicaoTributItem.Checked;
  cdsItemPorItemNCM.Visible     := cbNCM.Checked;

  cdsItemPorItem.Close;
  cdsItemPorItem.CreateDataSet;
  while not FqryDados.Eof do
  begin
    cdsItemPorItem.Append;

    for i := 0 to Pred(FqryDados.Fields.Count) do
    begin
      if TipoCampoFloat(FqryDados.Fields[i]) = False then // Sandro Silva 2024-04-29 if FqryDados.Fields[i].DataType <> ftFloat then
        cdsItemPorItem.FieldByName(FqryDados.Fields[i].FieldName).Value := FqryDados.Fields[i].Value
      else
      begin
        if AnsiUpperCase(FqryDados.Fields[i].FieldName) <> 'QUANTIDADE' then
          cdsItemPorItem.FieldByName(FqryDados.Fields[i].FieldName).AsFloat := Arredonda(FqryDados.Fields[i].AsFloat, FnDecimaisValor)
        else
          cdsItemPorItem.FieldByName(FqryDados.Fields[i].FieldName).AsFloat := Arredonda(FqryDados.Fields[i].AsFloat, FnDecimaisQuantidade);
      end;
    end;

    cdsItemPorItem.Post;    
    FqryDados.Next;
  end;
end;

procedure TfrmRelVendasNotaFiscal.AjustaCasasDecimais;
begin
  // cdsRelICMS
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSMERCADORIA.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSMERCADORIA.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSSERVICOS.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSSERVICOS.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSFRETE.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSFRETE.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSDESCONTO.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSDESCONTO.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSDESPESAS.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSDESPESAS.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSTOTAL.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSTOTAL.Size := FnDecimaisValor;
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSICMS.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSICMS.Size := FnDecimaisValor;  
  cdsRelICMS.FieldDefs.Items[cdsRelICMS.FieldDefs.IndexOf(cdsRelICMSICMSSUBSTI.FieldName)].Size := FnDecimaisValor;
  cdsRelICMSICMSSUBSTI.Size := FnDecimaisValor;

  // cdsItemPorItem
  cdsItemPorItem.FieldDefs.Items[cdsItemPorItem.FieldDefs.IndexOf(cdsItemPorItemQUANTIDADE.FieldName)].Size := FnDecimaisQuantidade;
  cdsItemPorItemQUANTIDADE.Size := FnDecimaisQuantidade;
  cdsItemPorItem.FieldDefs.Items[cdsItemPorItem.FieldDefs.IndexOf(cdsItemPorItemVENDIDOPOR.FieldName)].Size := FnDecimaisValor;
  cdsItemPorItemVENDIDOPOR.Size := FnDecimaisValor;
  cdsItemPorItem.FieldDefs.Items[cdsItemPorItem.FieldDefs.IndexOf(cdsItemPorItemCUSTOCOMPRA.FieldName)].Size := FnDecimaisValor;
  cdsItemPorItemCUSTOCOMPRA.Size := FnDecimaisValor;
  cdsItemPorItem.FieldDefs.Items[cdsItemPorItem.FieldDefs.IndexOf(cdsItemPorItemVICMSST.FieldName)].Size := FnDecimaisValor;
  cdsItemPorItemVICMSST.Size := FnDecimaisValor;
end;

procedure TfrmRelVendasNotaFiscal.CarregaDadosICMS;
var
  i: Integer;
begin
  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('SELECT');
  FqryDados.SQL.Add('    SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9)||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS NOTA');
  FqryDados.SQL.Add('    , VENDAS.EMISSAO AS EMISSAO');
  FqryDados.SQL.Add('    , VENDAS.CLIENTE AS CLIENTE');
  FqryDados.SQL.Add('    , VENDAS.MERCADORIA AS MERCADORIA');
  FqryDados.SQL.Add('    , VENDAS.SERVICOS AS SERVICOS');
  FqryDados.SQL.Add('    , VENDAS.FRETE AS FRETE');
  FqryDados.SQL.Add('    , VENDAS.DESCONTO AS DESCONTO');
  FqryDados.SQL.Add('    , VENDAS.DESPESAS AS DESPESAS');
  FqryDados.SQL.Add('    , VENDAS.TOTAL AS TOTAL');
  FqryDados.SQL.Add('    , VENDAS.ICMS AS ICMS');
  FqryDados.SQL.Add('    , VENDAS.ICMSSUBSTI AS ICMSSUBSTI');
  FqryDados.SQL.Add('FROM VENDAS');
  FqryDados.SQL.Add('WHERE');
  FqryDados.SQL.Add('    (VENDAS.EMITIDA=''S'')');
  FqryDados.SQL.Add('    AND (VENDAS.EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
  FqryDados.SQL.Add(RetornarWhereOperacoes);
  FqryDados.SQL.Add('ORDER BY VENDAS.EMISSAO, VENDAS.NUMERONF');
  FqryDados.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  FqryDados.ParamByName('XDATAFIM').AsDate := dtFinal.Date;
  FqryDados.Open;
  FqryDados.First;


  cdsRelICMSICMSSUBSTI.Visible  := cbSubstituicaoTributICMS.Checked;
  cdsRelICMS.Close;
  cdsRelICMS.CreateDataSet;
  while not FqryDados.Eof do
  begin
    cdsRelICMS.Append;

    for i := 0 to Pred(FqryDados.Fields.Count) do
    begin
      if TipoCampoFloat(FqryDados.Fields[i]) = False then //Sandro Silva 2024-04-29 if FqryDados.Fields[i].DataType <> ftFloat then
        cdsRelICMS.FieldByName(FqryDados.Fields[i].FieldName).Value := FqryDados.Fields[i].Value
      else
        cdsRelICMS.FieldByName(FqryDados.Fields[i].FieldName).AsFloat := Arredonda(FqryDados.Fields[i].AsFloat, FnDecimaisValor);
    end;

    cdsRelICMS.Post;
    FqryDados.Next;
  end;
end;

procedure TfrmRelVendasNotaFiscal.AjustaLayout;
begin
  pnlPrincipal.Top := 15;
  pnlSelOperacoes.Left := 180;
  pnlSelOperacoes.Top  := pnlPrincipal.Top;
  pnlSelOperacoes.Left := pnlPrincipal.Left;
end;

procedure TfrmRelVendasNotaFiscal.FormShow(Sender: TObject);
begin
  inherited;
  AjustaLayout;
  AjustaCasasDecimais;
  
  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

procedure TfrmRelVendasNotaFiscal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  inherited;
end;

procedure TfrmRelVendasNotaFiscal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FqryDados);
  inherited;
end;

procedure TfrmRelVendasNotaFiscal.DefinirEnabledListarCodigo;
begin
  cbSubstituicaoTributICMS.Enabled := rbRelatorioICMS.Checked;
  cbListarCodigos.Enabled          := rbItemPorITem.Checked;
  cbListarCodigos.TabStop          := cbListarCodigos.Enabled;
  cbSubstituicaoTributItem.Enabled := rbItemPorITem.Checked;
  cbNCM.Enabled                    := rbItemPorITem.Checked;
  if not cbSubstituicaoTributICMS.Enabled then
    cbSubstituicaoTributICMS.Checked := False;
  if not cbListarCodigos.Enabled then
    cbListarCodigos.Checked := False;
  if not cbSubstituicaoTributItem.Enabled then
    cbSubstituicaoTributItem.Checked := False;
  if not cbNCM.Enabled then
    cbNCM.Checked := False;
end;

procedure TfrmRelVendasNotaFiscal.rbRelatorioICMSClick(Sender: TObject);
begin
  DefinirEnabledListarCodigo;
end;

procedure TfrmRelVendasNotaFiscal.rbItemPorITemClick(Sender: TObject);
begin
  DefinirEnabledListarCodigo;
end;

procedure TfrmRelVendasNotaFiscal.btnMarcarTodosOperClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := True;
end;

procedure TfrmRelVendasNotaFiscal.btnDesmarcarTodosOperClick(
  Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := False;
end;

end.
