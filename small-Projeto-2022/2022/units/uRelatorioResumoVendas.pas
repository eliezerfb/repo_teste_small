unit uRelatorioResumoVendas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, CheckLst,
  ComCtrls, uIEstruturaTipoRelatorioPadrao, DB, IBQuery, smallfunc_xe,
  uIEstruturaRelatorioPadrao, IBCustomDataSet, DBClient;

type
  TTipoRelatorioResumoVenda = (trrvResumoVendas, trrvRankingProdVendido);

  TfrmRelResumoVendas = class(TfrmRelatorioPadrao)
    pnlPrincipal: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    cbAgruparGrupo: TCheckBox;
    pnlSelOperacoes: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    chkOperacoes: TCheckListBox;
    btnMarcarTodosOper: TBitBtn;
    btnDesmarcarTodosOper: TBitBtn;
    cdsExcluidos: TClientDataSet;
    cdsExcluidosNOME: TStringField;
    cdsExcluidosVALOR: TBCDField;
    cdsTotalGrupo: TClientDataSet;
    cdsTotalGrupoOrdem: TIntegerField;
    cdsTotalGrupoGrupo: TStringField;
    cdsTotalGrupoCustocompra: TFMTBCDField;
    cdsTotalGrupoVendidopor: TFMTBCDField;
    cdsTotalGrupoLucrobruto: TFMTBCDField;
    cdsTotalGrupoQuantidade: TFMTBCDField;
    cbxOrdenadoPor: TComboBox;
    lblOrdenadoPor: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnMarcarTodosOperClick(Sender: TObject);
    procedure btnDesmarcarTodosOperClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    QryProdutos: TIBQuery;
    FoDataSetEstoque: TIBDataSet;
    FnCasasDecimais: Integer;
    FnCasasDecimaisQtde: Integer;
    FcWhereEstoque: String;
    FcSqlTraduzido: String;
    FcOrderBy: String;
    FenTipoRelatorio: TTipoRelatorioResumoVenda;
    procedure AjustaLayout;
    function FazValidacoes: Boolean;
    function RetornarWhereOperacoes: String;
    procedure CarregaDadosProdutos(AcGrupo: String = '');
    procedure CarrregarDadosTotalGrupos;
    function RetornarDescrFiltroData: string;
    procedure MontarFiltrosRodape(AoEstruturaCat: IEstruturaRelatorioPadrao);
    procedure FazUpdateValores;
    function RetornarTotalDescontoAcresc: Currency;
    procedure DesativarColunas(AqryReg: TIBQuery);
    function RetornarTotalNaoRelacionados: Currency;
    function RetornaFormatoValorSQL(AnValor: Currency): String;
    procedure GerarImpressaoNaoRelacionados;
    procedure MapearQueryParaClientDataSet(AqryOrigem: TIBQuery;
      AcdsDestino: TClientDataSet);
    procedure AjustaCasasDecimais;
    function RetornarApenasData(AdDataHora: TDateTime): TDate;
    function RetornaWhereNota: String;
    procedure setTipoRelatiorio(const Value: TTipoRelatorioResumoVenda);
  public
    property DataSetEstoque: TIBDataSet read FoDataSetEstoque write FoDataSetEstoque;
    property CasasDecimaisPreco: Integer read FnCasasDecimais write FnCasasDecimais;
    property CasasDecimaisQtde: Integer read FnCasasDecimaisQtde write FnCasasDecimaisQtde;
    property WhereEstoque: String read FcWhereEstoque write FcWhereEstoque;
    property SqlTraduzido: String read FcSqlTraduzido write FcSqlTraduzido;
    property OrderBy: String read FcOrderBy write FcOrderBy;
    property TipoRelatorio: TTipoRelatorioResumoVenda read FenTipoRelatorio write setTipoRelatiorio;
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelResumoVendas: TfrmRelResumoVendas;

implementation

uses
  uRetornaOperacoesRelatorio, uSmallResourceString, uEstruturaTipoRelatorioPadrao, uEstruturaRelResumoVendas,
  uDadosRelatorioPadraoDAO, uFuncoesBancoDados, uSmallEnumerados, uEstruturaRelResumoVendasNaoList,
  uDialogs, uEstruturaRelRankingProdutosVendidos;

{$R *.dfm}

const
  _cSemGrupo = 'Sem grupo associado';
  _cNomeArqNaoListado = 'naolistados.htm';
  _cItensNaoRelacionados = 'Itens n�o relacionados';
  _cItensNaoRelacionadosHTML = '<a href="' + _cNomeArqNaoListado + '">' + _cItensNaoRelacionados + '</a>';
  _cDescontoAcrescimo = 'Descontos/Acr�scimos';

procedure TfrmRelResumoVendas.FormShow(Sender: TObject);
begin
  inherited;
  AjustaLayout;

  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

procedure TfrmRelResumoVendas.AjustaLayout;
begin
  pnlPrincipal.Top := 15;
  pnlSelOperacoes.Left := 180;
  pnlSelOperacoes.Top  := pnlPrincipal.Top;
  pnlSelOperacoes.Left := pnlPrincipal.Left;

  {Dailon Parisotto (smal-704) 2024-09-17 Inicio}
  if TipoRelatorio = trrvRankingProdVendido then
  begin
    lblOrdenadoPor.Left := 0;
    cbxOrdenadoPor.Left := 0;

    lblOrdenadoPor.Top := cbAgruparGrupo.Top + 1;
    cbxOrdenadoPor.Top := lblOrdenadoPor.Top + lblOrdenadoPor.Height + 3;
    cbxOrdenadoPor.Width := dtInicial.Width;

    cbxOrdenadoPor.ItemIndex := 0;

    Self.Caption := 'Ranking de produtos vendidos';
  end;
  cbAgruparGrupo.Visible := (TipoRelatorio <> trrvRankingProdVendido);

  if (TipoRelatorio = trrvRankingProdVendido) then
    cbAgruparGrupo.Checked := False;
  lblOrdenadoPor.Visible := (TipoRelatorio = trrvRankingProdVendido);
  cbxOrdenadoPor.Visible := (TipoRelatorio = trrvRankingProdVendido);
  {Dailon Parisotto (smal-704) 2024-09-17 Fim}

  AjustaCasasDecimais;
end;

procedure TfrmRelResumoVendas.AjustaCasasDecimais;
begin
  // cdsProdutos
  {
  cdsProdutos.FieldDefs.Items[cdsProdutos.FieldDefs.IndexOf(cdsProdutosQuantidade.FieldName)].Size := FnCasasDecimaisQtde;
  cdsProdutosQuantidade.Size := FnCasasDecimaisQtde;
  cdsProdutos.FieldDefs.Items[cdsProdutos.FieldDefs.IndexOf(cdsProdutosCustocompra.FieldName)].Size := FnCasasDecimais;
  cdsProdutosCustocompra.Size := FnCasasDecimais;
  cdsProdutos.FieldDefs.Items[cdsProdutos.FieldDefs.IndexOf(cdsProdutosVendidopor.FieldName)].Size := FnCasasDecimais;
  cdsProdutosVendidopor.Size := FnCasasDecimais;
  cdsProdutos.FieldDefs.Items[cdsProdutos.FieldDefs.IndexOf(cdsProdutosLucrobruto.FieldName)].Size := FnCasasDecimais;
  cdsProdutosLucrobruto.Size := FnCasasDecimais;
  cdsProdutos.FieldDefs.Items[cdsProdutos.FieldDefs.IndexOf(cdsProdutosCDSDesigner.FieldName)].Size := FnCasasDecimais;
  cdsProdutosCDSDesigner.Size := FnCasasDecimais;
  Mauricio Parizotto 2023-12-21}

  // cdsTotalGrupo
  cdsTotalGrupo.FieldDefs.Items[cdsTotalGrupo.FieldDefs.IndexOf(cdsTotalGrupoCustocompra.FieldName)].Size := FnCasasDecimais;
  cdsTotalGrupoCustocompra.Size := FnCasasDecimais;
  cdsTotalGrupo.FieldDefs.Items[cdsTotalGrupo.FieldDefs.IndexOf(cdsTotalGrupoVendidopor.FieldName)].Size := FnCasasDecimais;
  cdsTotalGrupoVendidopor.Size := FnCasasDecimais;
  cdsTotalGrupo.FieldDefs.Items[cdsTotalGrupo.FieldDefs.IndexOf(cdsTotalGrupoLucrobruto.FieldName)].Size := FnCasasDecimais;
  cdsTotalGrupoLucrobruto.Size := FnCasasDecimais;
  //Mauricio Parizotto 2024-05-20
  cdsTotalGrupo.FieldDefs.Items[cdsTotalGrupo.FieldDefs.IndexOf(cdsTotalGrupoQuantidade.FieldName)].Size := FnCasasDecimaisQtde;
  cdsTotalGrupoQuantidade.Size := FnCasasDecimaisQtde;



  // cdsExcluidos
  cdsExcluidos.FieldDefs.Items[cdsExcluidos.FieldDefs.IndexOf(cdsExcluidosVALOR.FieldName)].Size := FnCasasDecimais;
  cdsExcluidosVALOR.Size := FnCasasDecimais;
end;

function TfrmRelResumoVendas.Estrutura: IEstruturaTipoRelatorioPadrao;
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  Result := TEstruturaTipoRelatorioPadrao.New
                                         .setUsuario(Usuario);
  FazUpdateValores;
  if cbAgruparGrupo.Checked then
  begin
    CarrregarDadosTotalGrupos;
    // Gera o cabe�alho do relat�rio
    Estrutura.GerarImpressaoCabecalho(TEstruturaRelResumoVendas.New
                                                               .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                               .setDataBase(DataBase)
                                                           ));
    while not cdsTotalGrupo.Eof do
    begin
      if cdsTotalGrupoOrdem.AsInteger > 0 then
      begin
        // Gera a impress�o agrupada por grupo
        try

        CarregaDadosProdutos(cdsTotalGrupo.FieldByName('Grupo').AsString);

        oEstruturaCat := TEstruturaRelResumoVendas.New
                                                  .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                  .setDataBase(DataBase)
                                                                                  //.CarregarDados(cdsProdutos) Mauricio Parizotto 2023-12-21
                                                                                  .CarregarDados(QryProdutos)
                                                         );

        Estrutura.GerarImpressaoAgrupado(oEstruturaCat, cdsTotalGrupo.FieldByName('Grupo').AsString);

        finally
          FreeAndNil(QryProdutos);
        end;
      end;

      cdsTotalGrupo.Next;
      // Totalizador
      if cdsTotalGrupo.Eof then
      begin
        cdsTotalGrupo.First;

        oEstruturaCat := TEstruturaRelResumoVendas.New
                                                  .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                  .setDataBase(DataBase)
                                                                                  .CarregarDados(cdsTotalGrupo)
                                                         );

        MontarFiltrosRodape(oEstruturaCat);

        // Totalizador
        Estrutura.GerarImpressaoAgrupado(oEstruturaCat, 'TOTALIZADOR POR GRUPO');
      end;
    end;
  end else
  begin
    try

      CarregaDadosProdutos;

      if FenTipoRelatorio = trrvRankingProdVendido then
        oEstruturaCat := TEstruturaRelRankingProdutosVendidos.New
      else
        oEstruturaCat := TEstruturaRelResumoVendas.New;

      oEstruturaCat.setDAO(TDadosRelatorioPadraoDAO.New
                                                   .setDataBase(DataBase)
                                                   .CarregarDados(QryProdutos)
                          );

      MontarFiltrosRodape(oEstruturaCat);

      Estrutura.GerarImpressao(oEstruturaCat);

    finally
      FreeAndNil(QryProdutos);
    end;
  end;
    
  GerarImpressaoNaoRelacionados;
end;

procedure TfrmRelResumoVendas.GerarImpressaoNaoRelacionados;
var
  oEstrutura: IEstruturaTipoRelatorioPadrao;
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  if FoArquivoDAT.Usuario.Html.TipoRelatorio <> ttiHTML then
    Exit;

  if Trim(FcWhereEstoque) <> EmptyStr then
    Exit;

  oEstrutura := TEstruturaTipoRelatorioPadrao.New
                                             .setUsuario(Usuario);

  oEstruturaCat := TEstruturaRelResumoVendasNaoList.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(DataBase)
                                                                                   .CarregarDados(cdsExcluidos)
                                                          );

  oEstrutura.GerarImpressao(oEstruturaCat)
            .Salvar;
  Sleep(200);
  if FileExists(_cNomeArqNaoListado) then
    DeleteFile(_cNomeArqNaoListado);
  Sleep(100);
  if FileExists(Usuario + '.htm') then
    RenameFile(Usuario + '.htm', _cNomeArqNaoListado);
  Sleep(300);
end;

function TfrmRelResumoVendas.RetornarTotalDescontoAcresc: Currency;
var
  qryDados: TIBQuery;
begin
  Result := 0;

  qryDados := CriaIBQuery(DataSetEstoque.Transaction);
  try
    {Sandro Silva 2023-12-14 inicio
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('SELECT');
    qryDados.SQL.Add('    SUM(DESCONTO)');
    qryDados.SQL.Add('FROM VENDAS');
    qryDados.SQL.Add('INNER JOIN ITENS001');
    qryDados.SQL.Add('    ON (ITENS001.NUMERONF=VENDAS.NUMERONF)');
    if Trim(FcWhereEstoque) <> EmptyStr then
      QryDados.SQL.Add(StringReplace(AnsiUpperCase(FcWhereEstoque), 'WHERE ', 'WHERE (', []) + ') AND')
    else
      QryDados.SQL.Add('WHERE');
    qryDados.SQL.Add('(EMITIDA=''S'')');
    qryDados.SQL.Add('and (EMISSAO BETWEEN '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' AND ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+')');
    qryDados.Open;

    Result := Result + (qryDados.FieldByname('SUM').AsFloat*-1);
    }
    qryDados.Close;
    qryDados.SQL.Text :=
      'select sum(VENDAS.DESCONTO) as DESCONTOS ' +
      'from VENDAS ' +
      'where ' + RetornaWhereNota; // Dailon Parisotto (f-19509) 2024-07-02
    qryDados.Open;

    Result := Result + (qryDados.FieldByname('DESCONTOS').AsFloat*-1);
    {Sandro Silva 2023-12-14 fim}

    // Desconto nas Vendas ECF
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('SELECT');
    qryDados.SQL.Add('SUM(TOTAL)');
    qryDados.SQL.Add('FROM ALTERACA');
    if Trim(FcWhereEstoque) <> EmptyStr then
      QryDados.SQL.Add(StringReplace(AnsiUpperCase(FcWhereEstoque), 'WHERE ', 'WHERE (', []) + ') AND')
    else
      QryDados.SQL.Add('WHERE');
    qryDados.SQL.Add('(DATA BETWEEN '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' AND ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+') AND (DESCRICAO='+QuotedStr('Desconto')+') AND (TIPO<>''CANCEL'')');
    qryDados.Open;
    Result := Result + (qryDados.FieldByname('SUM').AsFloat);
    qryDados.Close;

    // Desconto nas Vendas ECF
    qryDados.SQL.Clear;
    qryDados.SQL.Add('SELECT');
    qryDados.SQL.Add('SUM(TOTAL)');
    qryDados.SQL.Add('FROM ALTERACA');
    if Trim(FcWhereEstoque) <> EmptyStr then
      QryDados.SQL.Add(StringReplace(AnsiUpperCase(FcWhereEstoque), 'WHERE ', 'WHERE (', []) + ') AND')
    else
      QryDados.SQL.Add('WHERE');
    qryDados.SQL.Add('(DATA BETWEEN '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' AND ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+') AND (DESCRICAO='+QuotedStr('Acr�scimo')+') AND (TIPO<>''CANCEL'')');
    qryDados.Open;
    Result := Result + (qryDados.FieldByname('SUM').AsFloat);
    qryDados.Close;
  finally
    FreeAndNil(qryDados);
  end;
end;

procedure TfrmRelResumoVendas.MontarFiltrosRodape(AoEstruturaCat: IEstruturaRelatorioPadrao);
var
  i: Integer;
begin
  AoEstruturaCat.FiltrosRodape.setFiltroData(RetornarDescrFiltroData);
  if cbAgruparGrupo.Checked then
  begin
    AoEstruturaCat.FiltrosRodape.AddItem(cbAgruparGrupo.Caption);
    AoEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;

  if TipoRelatorio = trrvRankingProdVendido then
    SqlTraduzido := SqlTraduzido + AnsiLowerCase(cbxOrdenadoPor.Text);

  AoEstruturaCat.FiltrosRodape.AddItem(SqlTraduzido);
  AoEstruturaCat.FiltrosRodape.AddItem(EmptyStr);  
    
  if FoArquivoDAT.Usuario.Html.TipoRelatorio in [ttiHTML, ttiPDF] then
    AoEstruturaCat.FiltrosRodape.AddItem('<b>Opera��es listadas:</b>')
  else
    AoEstruturaCat.FiltrosRodape.AddItem('Opera��es listadas:');
  AoEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  
  for i := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if chkOperacoes.Checked[I] then
      AoEstruturaCat.FiltrosRodape.AddItem(chkOperacoes.Items[i]);
  end;
  AoEstruturaCat.FiltrosRodape.AddItem('Vendas por ECF, NFC-e ou SAT');
end;

function TfrmRelResumoVendas.RetornarDescrFiltroData: string;
begin
  Result := 'Per�odo analisado, de '+DateToStr(dtInicial.Date)+' at� ' + DateToStr(dtFinal.Date);
end;

procedure TfrmRelResumoVendas.CarregaDadosProdutos(AcGrupo: String = '');
//var
//  QryDados: TIBQuery; Mauricio Parizotto 2023-12-21
begin
  AcGrupo := Copy(AcGrupo,1,25);
  QryProdutos := CriaIBQuery(DataSetEstoque.Transaction);
  try
    {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
    {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
    {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}

    QryProdutos.Close;
    QryProdutos.Database := DataBase;
    QryProdutos.SQL.Clear;
    QryProdutos.SQL.Add('SELECT');
    QryProdutos.SQL.Add('    0 as "Ord"');
    QryProdutos.SQL.Add('    , ESTOQUE.CODIGO AS "C�digo"');
    QryProdutos.SQL.Add('    , ESTOQUE.DESCRICAO AS "Descri��o"');
    QryProdutos.SQL.Add('    , CAST(ESTOQUE.QTD_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimaisQtde)+')) AS "Quantidade"');
    QryProdutos.SQL.Add('    , CAST(ESTOQUE.CUS_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Custo compra"');
    QryProdutos.SQL.Add('    , CAST(ESTOQUE.VAL_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Vendido por"');
    QryProdutos.SQL.Add('    , CAST(ESTOQUE.LUC_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Lucro bruto"');
    QryProdutos.SQL.Add('    , CASE WHEN COALESCE(ESTOQUE.CUS_VEND,0) > 0 THEN');
    QryProdutos.SQL.Add('      CAST(((ESTOQUE.VAL_VEND / ESTOQUE.CUS_VEND * 100) - 100) AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+'))');
    QryProdutos.SQL.Add('      ELSE 0 END AS "%"');
    QryProdutos.SQL.Add('FROM ESTOQUE');
    if Trim(FcWhereEstoque) <> EmptyStr then
      QryProdutos.SQL.Add(StringReplace(AnsiUpperCase(FcWhereEstoque), 'WHERE ', 'WHERE (', []) + ') AND')
    else
      QryProdutos.SQL.Add('WHERE');
    QryProdutos.SQL.Add('(COALESCE(ESTOQUE.QTD_VEND,0) <> 0)');
    QryProdutos.SQL.Add('AND (ESTOQUE.ULT_VENDA >= :XDATAINI)');
    if AcGrupo <> EmptyStr then
      QryProdutos.SQL.Add('AND (CASE WHEN COALESCE(ESTOQUE.NOME,'''') = '''' THEN ' + QuotedStr(_cSemGrupo) + ' ELSE ESTOQUE.NOME END = :XGRUPO)');
    if (AcGrupo = EmptyStr) then
    begin
      {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
      {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
      {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
      if (Trim(FcWhereEstoque) = EmptyStr) then
      begin
        QryProdutos.SQL.Add('UNION ALL');
        QryProdutos.SQL.Add('SELECT FIRST 1');
        QryProdutos.SQL.Add('    1 as "Ord"');
        QryProdutos.SQL.Add('    , '''' AS "C�digo"');
        QryProdutos.SQL.Add('    , ' + QuotedStr(_cDescontoAcrescimo) + ' AS "Descri��o"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimaisQtde)+')) AS "Quantidade"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Custo compra"');
        QryProdutos.SQL.Add('    , CAST(' + RetornaFormatoValorSQL(RetornarTotalDescontoAcresc) + ' AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Vendido por"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Lucro bruto"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "%"');
        QryProdutos.SQL.Add('FROM EMITENTE');

        {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
        {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}
        {ATEN��O!!!!! SE ADICIONAR OU REMOVER COLUNAS DA CONSULTA VERIFIQUE OS ORDER BY!!!!}

        QryProdutos.SQL.Add('UNION ALL');
        QryProdutos.SQL.Add('SELECT FIRST 1');
        QryProdutos.SQL.Add('    2 as "Ord"');
        QryProdutos.SQL.Add('    , '''' AS "C�digo"');
        if FoArquivoDAT.Usuario.Html.TipoRelatorio = ttiHTML then
          QryProdutos.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionadosHTML) + ' AS "Descri��o"')
        else
          QryProdutos.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionados) + ' AS "Descri��o"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimaisQtde)+')) AS "Quantidade"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Custo compra"');
        QryProdutos.SQL.Add('    , CAST(' + RetornaFormatoValorSQL(RetornarTotalNaoRelacionados) + ' AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Vendido por"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Lucro bruto"');
        QryProdutos.SQL.Add('    , CAST(0 AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "%"');
        QryProdutos.SQL.Add('FROM EMITENTE');
      end;
    end;
    if TipoRelatorio = trrvRankingProdVendido then
    begin
      case cbxOrdenadoPor.ItemIndex of
        0: QryProdutos.SQL.Add('ORDER BY 1,4 DESC');
        1: QryProdutos.SQL.Add('ORDER BY 1,6 DESC');
        2: QryProdutos.SQL.Add('ORDER BY 1,7 DESC');
      end;
    end else
      QryProdutos.SQL.Add('ORDER BY 1,7 DESC');
    QryProdutos.ParamByName('XDATAINI').AsDate := dtInicial.Date;
    if AcGrupo <> EmptyStr then
      QryProdutos.ParamByName('XGRUPO').AsString := AcGrupo;
    QryProdutos.Open;
    QryProdutos.First;

    DesativarColunas(QryProdutos);

    //MapearQueryParaClientDataSet(QryProdutos, cdsProdutos); Mauricio Parizotto 2023-12-21
  finally
    //FreeAndNil(QryProdutos); Mauricio Parizotto 2023-12-21
  end;
end;

procedure TfrmRelResumoVendas.MapearQueryParaClientDataSet(AqryOrigem: TIBQuery; AcdsDestino: TClientDataSet);
var
  i: Integer;
begin
  AqryOrigem.First;
  if AcdsDestino.Active then
    AcdsDestino.Close;

  AcdsDestino.CreateDataSet;

  while not AqryOrigem.eof do
  begin
    AcdsDestino.Append;
    if AqryOrigem.FieldByName('Ord').AsInteger = 0 then
      AcdsDestino.FieldByName('ORDEM').AsInteger := AqryOrigem.RecNo;
    
    for i := 0 to Pred(AqryOrigem.FieldCount) do
    begin
      if not AqryOrigem.Fields[i].Visible then
        Continue;

      if Assigned(AcdsDestino.FieldByName(AqryOrigem.Fields[i].FieldName)) then
      begin
        case AcdsDestino.FieldByName(AqryOrigem.Fields[i].FieldName).DataType of
          ftString, ftWideString: AcdsDestino.FieldByName(AqryOrigem.Fields[i].FieldName).AsString := AqryOrigem.FieldByName(AqryOrigem.Fields[i].FieldName).AsString;
          ftInteger, ftSmallint, ftLargeint: AcdsDestino.FieldByName(AqryOrigem.Fields[i].FieldName).AsInteger := AqryOrigem.FieldByName(AqryOrigem.Fields[i].FieldName).AsInteger;
          ftFMTBcd, ftFloat, ftCurrency, ftBCD: AcdsDestino.FieldByName(AqryOrigem.Fields[i].FieldName).AsFloat := AqryOrigem.FieldByName(AqryOrigem.Fields[i].FieldName).AsFloat;
        end;
      end;
    end;

    AcdsDestino.Post;    
    AqryOrigem.Next;
  end;
  AcdsDestino.First;
end;

function TfrmRelResumoVendas.RetornaFormatoValorSQL(AnValor: Currency): String;
begin
  Result := CurrToStr(AnValor);
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, ',', '.', [rfReplaceAll]);
end;

procedure TfrmRelResumoVendas.DesativarColunas(AqryReg: TIBQuery);
var
  i: Integer;
begin
  for i := 0 to Pred(AqryReg.FieldCount) do
    AqryReg.Fields[i].Visible := (AqryReg.Fields[i].FieldName <> 'Ord');
end;

procedure TfrmRelResumoVendas.CarrregarDadosTotalGrupos;
var
  QryDados: TIBQuery;
begin

  {Sandro Silva 2023-11-06 inicio}
  // no filtro salvo no m�dulo Estoque n�o fica salvo a tabela junto com o nome do campo na cl�usula where
  // Ex.: where upper( Coalesce(NOME,'~') ) like '%STIHL%'
  // Atribuir o nome da tabela junto ao campo
  FcWhereEstoque := StringReplace(FcWhereEstoque, 'Coalesce(NOME,''~'')', 'Coalesce(ESTOQUE.NOME,''~'')', [rfReplaceAll]);
  FcWhereEstoque := StringReplace(FcWhereEstoque, 'Coalesce(NOME, ''~'')', 'Coalesce(ESTOQUE.NOME, ''~'')', [rfReplaceAll]);
  {Sandro Silva 2023-11-06 fim}

  QryDados := CriaIBQuery(DataSetEstoque.Transaction);
  try
    QryDados.Close;
    QryDados.Database := DataBase;
    QryDados.SQL.Clear;
    QryDados.SQL.Add('SELECT');
    QryDados.SQL.Add('    0 as "Ord"');
    QryDados.SQL.Add('    , CASE WHEN COALESCE(GRUPO.NOME,'''') = '''' THEN ' + QuotedStr(_cSemGrupo) + ' ELSE GRUPO.NOME END AS "Grupo"');
    QryDados.SQL.Add('    , SUM(CAST(ESTOQUE.QTD_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimaisQtde)+'))) AS "Quantidade"'); //Mauricio Parizotto 2024-05-20
    QryDados.SQL.Add('    , SUM(CAST(ESTOQUE.CUS_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+'))) AS "Custo compra"');
    QryDados.SQL.Add('    , SUM(CAST(ESTOQUE.VAL_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+'))) AS "Vendido por"');
    QryDados.SQL.Add('    , SUM(CAST(ESTOQUE.LUC_VEND AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+'))) AS "Lucro bruto"');
    QryDados.SQL.Add('FROM ESTOQUE');
    QryDados.SQL.Add('LEFT JOIN GRUPO ON');
    QryDados.SQL.Add(' (GRUPO.NOME=ESTOQUE.NOME)');
    if Trim(FcWhereEstoque) <> EmptyStr then
      QryDados.SQL.Add(StringReplace(AnsiUpperCase(FcWhereEstoque), 'WHERE ', 'WHERE (', []) + ') AND')
    else
      QryDados.SQL.Add('WHERE');
    QryDados.SQL.Add('(COALESCE(ESTOQUE.QTD_VEND,0) <> 0)');
    QryDados.SQL.Add('AND (ESTOQUE.ULT_VENDA >= :XDATAINI)');
    QryDados.SQL.Add('GROUP BY GRUPO.NOME');

    if Trim(FcWhereEstoque) = EmptyStr then
    begin
      QryDados.SQL.Add('UNION ALL');
      QryDados.SQL.Add('SELECT FIRST 1');
      QryDados.SQL.Add('    1 as "Ord"');
      QryDados.SQL.Add('    , ' + QuotedStr(_cDescontoAcrescimo) + ' AS "Grupo"');
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,'+IntToStr(FnCasasDecimaisQtde)+')) AS "Quantidade"'); //Mauricio Parizotto 2024-05-20
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Custo compra"');
      QryDados.SQL.Add('    , CAST(SUM(' + RetornaFormatoValorSQL(RetornarTotalDescontoAcresc) + ') AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Vendido por"');
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Lucro bruto"');
      QryDados.SQL.Add('FROM EMITENTE');

      QryDados.SQL.Add('UNION ALL');

      QryDados.SQL.Add('SELECT FIRST 1');
      QryDados.SQL.Add('    2 as "Ord"');
      if FoArquivoDAT.Usuario.Html.TipoRelatorio = ttiHTML then
        QryDados.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionadosHTML) + ' AS "Grupo"')
      else
        QryDados.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionados) + ' AS "Grupo"');
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Quantidade"'); //Mauricio Parizotto 2024-05-20
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Custo compra"');
      QryDados.SQL.Add('    , CAST(SUM(' + RetornaFormatoValorSQL(RetornarTotalNaoRelacionados) + ') AS NUMERIC(18,'+IntToStr(FnCasasDecimais)+')) AS "Vendido por"');
      QryDados.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Lucro bruto"');
      QryDados.SQL.Add('FROM EMITENTE');
    end;

    //QryDados.SQL.Add('ORDER BY 1, 5 DESC');
    QryDados.SQL.Add('ORDER BY 1, 6 DESC');
    QryDados.ParamByName('XDATAINI').AsDate := dtInicial.Date;
    QryDados.Open;
    QryDados.First;

    DesativarColunas(QryDados);

    MapearQueryParaClientDataSet(QryDados, cdsTotalGrupo);
  finally
    FreeAndNil(QryDados);
  end;
end;

function TfrmRelResumoVendas.RetornarTotalNaoRelacionados: Currency;
begin
  Result := 0;
  
  cdsExcluidos.First;
  try
    while not cdsExcluidos.Eof do
    begin
      Result := Result + cdsExcluidosVALOR.AsCurrency;
      cdsExcluidos.Next;
    end;
  finally
    cdsExcluidos.First;
  end;
end;

function TfrmRelResumoVendas.RetornarWhereOperacoes: String;
var
  i: integer;
begin
  for I := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if not chkOperacoes.Checked[I] then
      Result := Result + ' AND (VENDAS.OPERACAO<>'+QuotedStr(chkOperacoes.Items[I])+') ';
  end;
end;

procedure TfrmRelResumoVendas.btnAvancarClick(Sender: TObject);
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
                                .setDataBase(DataBase)
                                .setOperacaoVenda
                                .CarregaDados
                                .DefineItens(chkOperacoes);
    end;
  end;
  btnVoltar.Enabled := (not pnlPrincipal.Visible);  
end;

function TfrmRelResumoVendas.FazValidacoes: Boolean;
begin
  Result := False;

  if ((dtInicial.Date = 0) or (dtFinal.Date = 0)) or (dtInicial.Date > dtFinal.Date) then
  begin
    //ShowMessage(_cPeriodoDataInvalida); Mauricio Parizotto 2023-10-25
    MensagemSistema(_cPeriodoDataInvalida,msgAtencao);
    dtInicial.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmRelResumoVendas.btnVoltarClick(Sender: TObject);
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

{Dailon Parisotto (f-19509) 2024-07-02 Inicio}
function TfrmRelResumoVendas.RetornaWhereNota: String;
begin
    Result := '(VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dtFinal.Date))+') and (VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dtInicial.Date))+')' + sLineBreak +
              RetornarWhereOperacoes+' and (VENDAS.EMITIDA=''S'')' + sLineBreak +
              'and (VENDAS.MODELO <> ''SV'')';
end;
procedure TfrmRelResumoVendas.setTipoRelatiorio(
  const Value: TTipoRelatorioResumoVenda);
begin
  FenTipoRelatorio := Value;
end;

{Dailon Parisotto (f-19509) 2024-07-02 Fim}

procedure TfrmRelResumoVendas.FazUpdateValores;
var
  nRecNo: Integer;
  qryCons99, qryCons100: TIBQuery;
  function EscapeQuoted(Texto: String): String;
  begin
    Result := StringReplace(Texto, #39, #39#39, [rfReplaceAll]);
  end;
begin
  qryCons99 := CriaIBQuery(DataSetEstoque.Transaction);
  qryCons100 := CriaIBQuery(DataSetEstoque.Transaction);
  Application.ProcessMessages;
  Screen.Cursor  := crAppStart;
  DataSetEstoque.DisableControls;
  nRecNo := DataSetEstoque.RecNo;
  try
    if (Trim(FcWhereEstoque) = EmptyStr) or (DataSetEstoque.IsEmpty) then
    begin
      DataSetEstoque.Close;
      DataSetEstoque.SelectSQL.Text := 'SELECT * FROM ESTOQUE ' + OrderBy;
      DataSetEstoque.Open;
    end;

    cdsExcluidos.Close;
    cdsExcluidos.CreateDataSet;

    qryCons99.Close;
    qryCons99.Database := DataBase;
    qryCons99.SQL.Add('select');
    qryCons99.SQL.Add('ITENS001.CODIGO,'); // Sandro Silva 2024-04-08
    qryCons99.SQL.Add('ITENS001.DESCRICAO,');
    qryCons99.SQL.Add('sum(ITENS001.QUANTIDADE) as vQTD1,');
    qryCons99.SQL.Add('sum(ITENS001.TOTAL) as vTOT1,');
    qryCons99.SQL.Add('sum(ITENS001.CUSTO*ITENS001.QUANTIDADE) as vCUS1');
    qryCons99.SQL.Add('from ITENS001, VENDAS');
    qryCons99.SQL.Add('where');
    qryCons99.SQL.Add('(VENDAS.NUMERONF=ITENS001.NUMERONF)');
    qryCons99.SQL.Add('AND ' + RetornaWhereNota); // Dailon Parisotto (f-19509) 2024-07-02
    qryCons99.SQL.Add('group by DESCRICAO, CODIGO'); // Sandro Silva 2024-04-08 qryCons99.SQL.Add('group by DESCRICAO');
    qryCons99.Open;

    while not qryCons99.Eof do
    begin
      if (AllTrim(qryCons99.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(qryCons99.FieldByname('DESCRICAO').AsString) <> 'Acr�scimo') then
      begin
        if not DataSetEstoque.Locate('CODIGO',AllTrim(qryCons99.FieldByname('CODIGO').AsString),[]) then // Sandro Silva  2024-04-08 if not DataSetEstoque.Locate('DESCRICAO',AllTrim(qryCons99.FieldByname('DESCRICAO').AsString),[]) then
        begin
          if qryCons99.FieldByname('VTOT1').AsFloat > 0 then
          begin
            // Sandro Silva 2023-11-06 if not cdsExcluidos.Locate('NOME', qryCons99.FieldByname('DESCRICAO').AsString, []) then
            if not cdsExcluidos.Locate('NOME', EscapeQuoted(qryCons99.FieldByname('DESCRICAO').AsString), []) then
            begin
              cdsExcluidos.Append;
              cdsExcluidosNOME.AsString    := qryCons99.FieldByname('DESCRICAO').AsString;
              cdsExcluidosVALOR.AsCurrency := 0;
            end
            else
              cdsExcluidos.Edit;

            cdsExcluidosVALOR.AsCurrency := cdsExcluidosVALOR.AsCurrency + qryCons99.FieldByname('VTOT1').AsFloat;

            cdsExcluidos.Post;
          end;
        end else
        begin
          if RetornarApenasData(DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime) < RetornarApenasData(dtInicial.Date) then
          begin
            DataSetEstoque.Edit;
            DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime := dtInicial.Date;
            DataSetEstoque.Post;
          end;
        end;
      end;

      qryCons99.Next;
    end;

    qryCons100.Close;
    qryCons100.Database := DataBase;
    qryCons100.SQL.Add('select');
    qryCons100.SQL.Add('ALTERACA.CODIGO,'); // Sandro Silva 2024-04-08
    qryCons100.SQL.Add('ALTERACA.DESCRICAO,');
    qryCons100.SQL.Add('sum(ALTERACA.QUANTIDADE) as vQTD2,');
    qryCons100.SQL.Add('sum(ALTERACA.TOTAL) as vTOT2');
    qryCons100.SQL.Add('from ALTERACA');
    qryCons100.SQL.Add('where (ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal.Date)) + ')');
    qryCons100.SQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+'))');
    qryCons100.SQL.Add('group by DESCRICAO, CODIGO'); //2024-04-08 qryCons100.SQL.Add('group by DESCRICAO');
    qryCons100.Open;

    while not qryCons100.Eof do
    begin
      if (AllTrim(qryCons100.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(qryCons100.FieldByname('DESCRICAO').AsString) <> 'Acr�scimo') then
      begin
        if not DataSetEstoque.Locate('CODIGO',AllTrim(qryCons100.FieldByname('CODIGO').AsString),[]) then // 2024-04-08 if not DataSetEstoque.Locate('DESCRICAO',AllTrim(qryCons100.FieldByname('DESCRICAO').AsString),[]) then
        begin
          if qryCons100.FieldByname('VTOT2').AsFloat > 0 then
          begin
            // Sandro Silva 2023-11-06 if not cdsExcluidos.Locate('NOME', qryCons100.FieldByname('DESCRICAO').AsString, []) then
            if not cdsExcluidos.Locate('NOME', EscapeQuoted(qryCons100.FieldByname('DESCRICAO').AsString), []) then
            begin
              cdsExcluidos.Append;
              cdsExcluidosNOME.AsString    := qryCons100.FieldByname('DESCRICAO').AsString;
              cdsExcluidosVALOR.AsCurrency := 0;
            end
            else
              cdsExcluidos.Edit;

            cdsExcluidosVALOR.AsCurrency := cdsExcluidosVALOR.AsCurrency + qryCons100.FieldByname('VTOT2').AsFloat;

            cdsExcluidos.Post;
          end;
        end else
        begin
          if RetornarApenasData(DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime) < RetornarApenasData(dtInicial.Date) then
          begin
            DataSetEstoque.Edit;
            DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime := dtInicial.Date;
            DataSetEstoque.Post;
          end;
        end;
      end;

      qryCons100.Next;
    end;

    DataSetEstoque.First;

    while (not DataSetEstoque.EOF) do
    begin
      if (RetornarApenasData(DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime) >= RetornarApenasData(dtInicial.Date)) then
      begin
        DataSetEstoque.Edit;
        DataSetEstoque.FieldByName('QTD_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('CUS_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('VAL_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('LUC_VEND').AsFloat := 0;

        if qryCons99.Locate('CODIGO',AllTrim(DataSetEstoque.FieldByName('CODIGO').AsString),[]) then // Sandro Silva 2024-04-08 if qryCons99.Locate('DESCRICAO',AllTrim(DataSetEstoque.FieldByName('DESCRICAO').AsString),[]) then
        begin
          DataSetEstoque.FieldByName('QTD_VEND').AsFloat := DataSetEstoque.FieldByName('QTD_VEND').AsFloat + qryCons99.FieldByname('VQTD1').AsFloat;
          DataSetEstoque.FieldByName('VAL_VEND').AsFloat := DataSetEstoque.FieldByName('VAL_VEND').AsFloat + qryCons99.FieldByname('VTOT1').AsFloat;
          DataSetEstoque.FieldByName('CUS_VEND').AsFloat := DataSetEstoque.FieldByName('CUS_VEND').AsFloat + qryCons99.FieldByname('VCUS1').AsFloat;
        end;

        if qryCons100.Locate('CODIGO',AllTrim(DataSetEstoque.FieldByName('CODIGO').AsString),[]) then // Sandro Silva 2024-04-08 if qryCons100.Locate('DESCRICAO',AllTrim(DataSetEstoque.FieldByName('DESCRICAO').AsString),[]) then
        begin
          DataSetEstoque.FieldByName('QTD_VEND').AsFloat := DataSetEstoque.FieldByName('QTD_VEND').AsFloat + qryCons100.FieldByname('VQTD2').AsFloat;
          DataSetEstoque.FieldByName('VAL_VEND').AsFloat := DataSetEstoque.FieldByName('VAL_VEND').AsFloat + qryCons100.FieldByname('VTOT2').AsFloat;
          DataSetEstoque.FieldByName('CUS_VEND').AsFloat := DataSetEstoque.FieldByName('CUS_VEND').AsFloat + qryCons100.FieldByname('VQTD2').AsFloat * DataSetEstoque.FieldByName('CUSTOCOMPR').AsFloat;
        end;

        DataSetEstoque.FieldByName('LUC_VEND').AsFloat := DataSetEstoque.FieldByName('VAL_VEND').AsFloat - DataSetEstoque.FieldByName('CUS_VEND').AsFloat;
        DataSetEstoque.Post;
      end;

      DataSetEstoque.Next;
    end;
  finally
    cdsExcluidos.First;
    DataSetEstoque.RecNo := nRecNo;
    DataSetEstoque.EnableControls;
    Screen.Cursor  := crDefault;
    FreeAndNil(qryCons99);
    FreeAndNil(qryCons100);
  end;
end;

{Dailon Parisotto (f-7499) 2023-10-25 Inicio}
function TfrmRelResumoVendas.RetornarApenasData(AdDataHora: TDateTime): TDate;
begin
  // Necess�rio para garantir valida��o de datas q tem hora junto
  Result := StrToDate(DateToStr(AdDataHora));
end;
{Dailon Parisotto (f-7499) 2023-10-25 Fim}

procedure TfrmRelResumoVendas.btnMarcarTodosOperClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := True;
end;

procedure TfrmRelResumoVendas.btnDesmarcarTodosOperClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to chkOperacoes.Items.Count -1 do
    chkOperacoes.Checked[i] := False;
end;

procedure TfrmRelResumoVendas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FoArquivoDAT.Usuario.Outros.PeriodoInicial := dtInicial.Date;
  FoArquivoDAT.Usuario.Outros.PeriodoFinal   := dtFinal.Date;
  inherited;
end;

procedure TfrmRelResumoVendas.FormCreate(Sender: TObject);
begin
  inherited;
  FcWhereEstoque := EmptyStr;
  FnCasasDecimais := 2;
  FnCasasDecimaisQtde := 2;
end;

end.
