unit uRelatorioVendasNotaFiscal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, CheckLst,
  ComCtrls, uIEstruturaTipoRelatorioPadrao, uIEstruturaRelatorioPadrao,
  IBQuery;

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
    function RetornarCampoComFormatoDecimalValor(AcCampo: String): String;
    function RetornarCampoComFormatoDecimalQtde(AcCampo: String): String;
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
begin
  Result := TEstruturaTipoRelatorioPadrao.New
                                         .setUsuario(Usuario);

  CarregaDados;

  oEstruturaCat := TEstruturaRelVendasNotaFiscal.New
                                                .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                .setDataBase(Transaction.DefaultDatabase)
                                                                                .CarregarDados(FqryDados)
                                                       );

  // Monta os filtros
  oEstruturaCat.FiltrosRodape.setFiltroData(RetornarDescrFiltroData);

  if rbRelatorioICMS.Checked then
  begin
    oEstruturaCat.FiltrosRodape.AddItem(rbRelatorioICMS.Caption);
    oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;
  if rbItemPorITem.Checked then
  begin
    cAux := rbItemPorITem.Caption;
    if cbListarCodigos.Checked then
      cAux := cAux + ' (' + cbListarCodigos.Caption + ')';
    oEstruturaCat.FiltrosRodape.AddItem(cAux);
    oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;

  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
    oEstruturaCat.FiltrosRodape.AddItem('<b>Operações listadas:</b>')
  else
    oEstruturaCat.FiltrosRodape.AddItem('Operações listadas:');
  oEstruturaCat.FiltrosRodape.AddItem(EmptyStr);

  for i := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if chkOperacoes.Checked[I] then
      oEstruturaCat.FiltrosRodape.AddItem(chkOperacoes.Items[i]);
  end;
  // Gera o relatório
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
  Result := 'Período analisado, de '+DateToStr(dtInicial.Date)+' até ' + DateToStr(dtFinal.Date);
end;

procedure TfrmRelVendasNotaFiscal.btnVoltarClick(Sender: TObject);
begin
  if pnlSelOperacoes.Visible then
  begin
    pnlSelOperacoes.Visible := False;
    pnlPrincipal.Visible    := True;
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
    CarregaDadosICMS;
  if rbItemPorITem.Checked then
    CarregaDadosItemAItem;
end;

procedure TfrmRelVendasNotaFiscal.CarregaDadosItemAItem;
begin
  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('SELECT');
  FqryDados.SQL.Add('    SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9)||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS "Nota"');
  FqryDados.SQL.Add('    , VENDAS.EMISSAO AS "Data"');
  if cbListarCodigos.Checked then
    FqryDados.SQL.Add('    , ITENS001.CODIGO AS "Código"');
  FqryDados.SQL.Add('    , ITENS001.DESCRICAO AS "Descrição do item"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalQtde('ITENS001.QUANTIDADE') + ' AS "Quantidade"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('(ITENS001.QUANTIDADE * ITENS001.UNITARIO)') + ' AS "Vendido por"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('(ITENS001.QUANTIDADE * ITENS001.CUSTO)') + ' AS "Custo compra"');
  FqryDados.SQL.Add('FROM VENDAS');
  FqryDados.SQL.Add('INNER JOIN ITENS001');
  FqryDados.SQL.Add('    ON (ITENS001.NUMERONF=VENDAS.NUMERONF)');
  FqryDados.SQL.Add('WHERE');
  FqryDados.SQL.Add('    (EMITIDA=''S'')');
  FqryDados.SQL.Add('    AND (EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
  FqryDados.SQL.Add('    AND (COALESCE(VENDAS.TOTAL,0) > 0)');
  FqryDados.SQL.Add(RetornarWhereOperacoes);
  FqryDados.SQL.Add('ORDER BY VENDAS.EMISSAO, VENDAS.NUMERONF');
  FqryDados.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  FqryDados.ParamByName('XDATAFIM').AsDate := dtFinal.Date;
  FqryDados.Open;
end;

function TfrmRelVendasNotaFiscal.RetornarCampoComFormatoDecimalValor(AcCampo: String): String;
begin
  Result := 'CAST('+AcCampo+' AS NUMERIC(18,' + IntToStr(DecimaisValor) + '))';
end;

function TfrmRelVendasNotaFiscal.RetornarCampoComFormatoDecimalQtde(AcCampo: String): String;
begin
  Result := 'CAST('+AcCampo+' AS NUMERIC(18,' + IntToStr(DecimaisQuantidade) + '))';
end;

procedure TfrmRelVendasNotaFiscal.CarregaDadosICMS;
begin
  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('SELECT');
  FqryDados.SQL.Add('    SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9)||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS "Nota"');
  FqryDados.SQL.Add('    , VENDAS.EMISSAO AS "Data"');
  FqryDados.SQL.Add('    , VENDAS.CLIENTE AS "Cliente"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.MERCADORIA') + ' AS "Produtos R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.SERVICOS') + ' AS "Serviços R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.FRETE') + ' AS "Frete R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.DESCONTO') + ' AS "Desconto R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.DESPESAS') + ' AS "Outras R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.TOTAL') + ' AS "TOTAL R$"');
  FqryDados.SQL.Add('    , ' + RetornarCampoComFormatoDecimalValor('VENDAS.ICMS') + ' AS "ICMS R$"');
  FqryDados.SQL.Add('FROM VENDAS');
  FqryDados.SQL.Add('WHERE');
  FqryDados.SQL.Add('    (VENDAS.EMITIDA=''S'')');
  FqryDados.SQL.Add('    AND (VENDAS.EMISSAO BETWEEN :XDATAINI AND :XDATAFIM)');
  FqryDados.SQL.Add('    AND (COALESCE(VENDAS.TOTAL,0) > 0)');
  FqryDados.SQL.Add(RetornarWhereOperacoes);
  FqryDados.SQL.Add('ORDER BY VENDAS.EMISSAO, VENDAS.NUMERONF');
  FqryDados.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  FqryDados.ParamByName('XDATAFIM').AsDate := dtFinal.Date;
  FqryDados.Open;
end;

procedure TfrmRelVendasNotaFiscal.AjustaLayout;
begin
  pnlPrincipal.Top := 16;
  pnlSelOperacoes.Left := 184;
  pnlSelOperacoes.Top  := pnlPrincipal.Top;
  pnlSelOperacoes.Left := pnlPrincipal.Left;
end;

procedure TfrmRelVendasNotaFiscal.FormShow(Sender: TObject);
begin
  inherited;
  AjustaLayout;

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
  cbListarCodigos.Enabled := rbItemPorITem.Checked;
  cbListarCodigos.TabStop := cbListarCodigos.Enabled;
  if not cbListarCodigos.Enabled then
    cbListarCodigos.Checked := False;
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
