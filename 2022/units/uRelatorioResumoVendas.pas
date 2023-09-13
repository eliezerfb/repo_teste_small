unit uRelatorioResumoVendas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, CheckLst,
  ComCtrls, uIEstruturaTipoRelatorioPadrao, DB, IBQuery, SmallFunc,
  uIEstruturaRelatorioPadrao, IBCustomDataSet, DBClient;

type
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
    procedure FormShow(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnMarcarTodosOperClick(Sender: TObject);
    procedure btnDesmarcarTodosOperClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FoDataSetEstoque: TIBDataSet;
    procedure AjustaLayout;
    function FazValidacoes: Boolean;
    function RetornarDataSetGrupos: TIBQuery;
    function RetornarWhere: string;
    function RetornarWhereOperacoes: String;
    function RetornarDataSetProdutos(AcGrupo: String = ''): TIBQuery;
    function RetornarDataSetTotalGrupos: TIBQuery;
    function RetornarDescrFiltroData: string;
    procedure MontarFiltrosRodape(AoEstruturaCat: IEstruturaRelatorioPadrao);
    procedure FazUpdateValores;
    function RetornarTotalDescontoAcresc: Currency;
    procedure DesativarColunas(AqryReg: TIBQuery);
    function RetornarTotalNaoRelacionados: Currency;
    function RetornaFormatoValorSQL(AnValor: Currency): String;
  public
    property DataSetEstoque: TIBDataSet read FoDataSetEstoque write FoDataSetEstoque;  
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelResumoVendas: TfrmRelResumoVendas;

implementation

uses
  uRetornaOperacoesRelatorio, uSmallResourceString, uEstruturaTipoRelatorioPadrao, uEstruturaRelResumoVendas,
  uDadosRelatorioPadraoDAO, uFuncoesBancoDados;

{$R *.dfm}

const
  _cSemGrupo = 'Sem grupo associado';
  _cItensNaoRelacionados = 'Itens não relacionados';
  _cDescontoAcrescimo = 'Descontos/Acréscimos';

procedure TfrmRelResumoVendas.FormShow(Sender: TObject);
begin
  inherited;
  AjustaLayout;  
  dtInicial.Date := FoArquivoDAT.Usuario.Outros.PeriodoInicial;
  dtFinal.Date   := FoArquivoDAT.Usuario.Outros.PeriodoFinal;
end;

procedure TfrmRelResumoVendas.AjustaLayout;
begin
  pnlPrincipal.Top := 16;
  pnlSelOperacoes.Left := 184;
  pnlSelOperacoes.Top  := pnlPrincipal.Top;
  pnlSelOperacoes.Left := pnlPrincipal.Left;
end;

function TfrmRelResumoVendas.Estrutura: IEstruturaTipoRelatorioPadrao;
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
  qryGrupo: TIBQuery;
  qryTotGrupo: TIBQuery;
  qryProduto: TIBQuery;
begin
  Result := TEstruturaTipoRelatorioPadrao.New
                                         .setUsuario(Usuario);
  FazUpdateValores;
  if cbAgruparGrupo.Checked then
  begin
    // Pega todo os grupos
    qryGrupo := RetornarDataSetGrupos;
    try
      // Gera o cabeçalho do relatório
      Estrutura.GerarImpressaoCabecalho(TEstruturaRelResumoVendas.New
                                                                 .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                                 .setDataBase(DataBase)
                                                             ));
      while not qryGrupo.Eof do
      begin
        // Gera a impressão agrupada por grupo
        qryProduto := RetornarDataSetProdutos(qryGrupo.FieldByName('GRUPO').AsString);
        try
          oEstruturaCat := TEstruturaRelResumoVendas.New
                                                    .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                    .setDataBase(DataBase)
                                                                                    .CarregarDados(qryProduto)
                                                           );

          Estrutura.GerarImpressaoAgrupado(oEstruturaCat, qryGrupo.FieldByName('GRUPO').AsString);
        finally
          FreeAndNil(qryProduto);
        end;

        qryGrupo.Next;
        // Totalizador
        if qryGrupo.Eof then
        begin
          qryTotGrupo := RetornarDataSetTotalGrupos;

          oEstruturaCat := TEstruturaRelResumoVendas.New
                                                    .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                    .setDataBase(DataBase)
                                                                                    .CarregarDados(qryTotGrupo)
                                                           );

          // Totalizador
          Estrutura.GerarImpressaoAgrupado(oEstruturaCat, 'TOTALIZADOR POR GRUPO');


        end;
      end;
    finally
      FreeAndNil(qryGrupo);
    end;
  end
  else
  begin
    qryProduto := RetornarDataSetProdutos;
    try
      oEstruturaCat := TEstruturaRelResumoVendas.New
                                                .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                .setDataBase(DataBase)
                                                                                .CarregarDados(qryProduto)
                                                       );

      Estrutura.GerarImpressao(oEstruturaCat);
    finally
      FreeAndNil(qryProduto);
    end;
  end;
  if not cdsExcluidos.IsEmpty then
  begin
    oEstruturaCat := TEstruturaRelResumoVendas.New
                                              .setDAO(TDadosRelatorioPadraoDAO.New
                                                                              .setDataBase(DataBase)
                                                                              .CarregarDados(cdsExcluidos)
                                                     );

    MontarFiltrosRodape(oEstruturaCat);

    Estrutura.GerarImpressaoAgrupado(oEstruturaCat, _cItensNaoRelacionados+' (1 - Não faz parte do filtro | 2 - Foi APAGADO | 3 - Foi RENOMEADO)');
  end;  
end;

function TfrmRelResumoVendas.RetornarTotalDescontoAcresc: Currency;
var
  qryDados: TIBQuery;
begin
  Result := 0;

  qryDados := CriaIBQuery(DataSetEstoque.Transaction);
  try
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('select');
    qryDados.SQL.Add('sum(DESCONTO)');
    qryDados.SQL.Add('from VENDAS');
    qryDados.SQL.Add('where');
    qryDados.SQL.Add('EMITIDA=''S''');
    qryDados.SQL.Add('and EMISSAO between '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+' ');
    qryDados.Open;
    Result := Result + (qryDados.FieldByname('SUM').AsFloat*-1);

    // Desconto nas Vendas ECF
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+' and DESCRICAO='+QuotedStr('Desconto')+' and TIPO<>''CANCEL'' ');
    qryDados.Open;
    Result := Result + (qryDados.FieldByname('SUM').AsFloat);
    qryDados.Close;

    // Desconto nas Vendas ECF
    qryDados.SQL.Clear;
    qryDados.SQL.Add('select sum(TOTAL) from ALTERACA where DATA between '+QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal.Date))+' and DESCRICAO='+QuotedStr('Acréscimo')+' and TIPO<>''CANCEL'' ');
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
    AoEstruturaCat.FiltrosRodape.AddItem('Agrupado por grupo');
    AoEstruturaCat.FiltrosRodape.AddItem(EmptyStr);
  end;

  AoEstruturaCat.FiltrosRodape.AddItem('Operações listadas:');
  for i := 0 to Pred(chkOperacoes.Items.Count) do
  begin
    if chkOperacoes.Checked[I] then
      AoEstruturaCat.FiltrosRodape.AddItem(chkOperacoes.Items[i]);
  end;
end;

function TfrmRelResumoVendas.RetornarDescrFiltroData: string;
begin
  Result := 'Período analisado, de '+DateToStr(dtInicial.Date)+' até ' + DateToStr(dtFinal.Date);
end;

function TfrmRelResumoVendas.RetornarDataSetGrupos: TIBQuery;
begin
  Result := CriaIBQuery(DataSetEstoque.Transaction);

  Result.Close;
  Result.Database := DataBase;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    1 as ORD');
  Result.SQL.Add('    , COALESCE(GRUPO.NOME, '+QuotedStr(_cSemGrupo)+') AS GRUPO');
  Result.SQL.Add('FROM GRUPO');
  Result.SQL.Add('UNION ALL');
  Result.SQL.Add('SELECT FIRST 1');
  Result.SQL.Add('    2 as ORD');
  Result.SQL.Add('    , '+QuotedStr(_cSemGrupo)+' AS GRUPO');
  Result.SQL.Add('FROM GRUPO');
  Result.SQL.Add('ORDER BY 1, 2');
  Result.Open;
  Result.First;
end;

function TfrmRelResumoVendas.RetornarDataSetProdutos(AcGrupo: String = ''): TIBQuery;
begin
  Result := CriaIBQuery(DataSetEstoque.Transaction);

  Result.Close;
  Result.Database := DataBase;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    0 as "Ord"');
  Result.SQL.Add('    , ESTOQUE.CODIGO AS "Cód"');
  Result.SQL.Add('    , ESTOQUE.DESCRICAO AS "Descrição"');
  Result.SQL.Add('    , CAST(ESTOQUE.QTD_VEND AS NUMERIC(18,2)) AS "Quantidade"');
  Result.SQL.Add('    , CAST(ESTOQUE.CUS_VEND AS NUMERIC(18,2)) AS "Custo compra"');
  Result.SQL.Add('    , CAST(ESTOQUE.VAL_VEND AS NUMERIC(18,2)) AS "Vendido por"');
  Result.SQL.Add('    , CAST(ESTOQUE.LUC_VEND AS NUMERIC(18,2)) AS "Lucro bruto"');
  Result.SQL.Add('    , CASE WHEN COALESCE(ESTOQUE.CUS_VEND,0) > 0 THEN');
  Result.SQL.Add('      CAST(((ESTOQUE.VAL_VEND / ESTOQUE.CUS_VEND * 100) - 100) AS NUMERIC(18,2))');
  Result.SQL.Add('      ELSE 0 END AS "%"');
  Result.SQL.Add('FROM ESTOQUE');
  Result.SQL.Add('WHERE');
  Result.SQL.Add('(COALESCE(ESTOQUE.QTD_VEND,0) <> 0)');
  Result.SQL.Add('AND (ESTOQUE.ULT_VENDA >= :XDATAINI)');
  if AcGrupo <> EmptyStr then
    Result.SQL.Add('AND (COALESCE(ESTOQUE.NOME, '+QuotedStr(_cSemGrupo)+') = :XGRUPO)');
  if AcGrupo = EmptyStr then
  begin
    Result.SQL.Add('UNION ALL');
    Result.SQL.Add('SELECT FIRST 1');
    Result.SQL.Add('    1 as "Ord"');
    Result.SQL.Add('    , '''' AS "Cód"');
    Result.SQL.Add('    , ' + QuotedStr(_cDescontoAcrescimo) + ' AS "Descrição"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Quantidade"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Custo compra"');
    Result.SQL.Add('    , CAST(' + RetornaFormatoValorSQL(RetornarTotalDescontoAcresc) + ' AS NUMERIC(18,2)) AS "Vendido por"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Lucro bruto"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "%"');
    Result.SQL.Add('FROM EMITENTE');

    Result.SQL.Add('UNION ALL');
    Result.SQL.Add('SELECT FIRST 1');
    Result.SQL.Add('    2 as "Ord"');
    Result.SQL.Add('    , '''' AS "Cód"');
    Result.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionados) + ' AS "Descrição"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Quantidade"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Custo compra"');
    Result.SQL.Add('    , CAST(' + RetornaFormatoValorSQL(RetornarTotalNaoRelacionados) + ' AS NUMERIC(18,2)) AS "Vendido por"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "Lucro bruto"');
    Result.SQL.Add('    , CAST(0 AS NUMERIC(18,2)) AS "%"');
    Result.SQL.Add('FROM EMITENTE');

    Result.SQL.Add('ORDER BY 1,7 DESC');
  end;
  Result.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  if AcGrupo <> EmptyStr then
    Result.ParamByName('XGRUPO').AsString := AcGrupo;
  Result.Open;
  Result.First;

  DesativarColunas(Result);
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

function TfrmRelResumoVendas.RetornarDataSetTotalGrupos: TIBQuery;
begin
  Result := CriaIBQuery(DataSetEstoque.Transaction);

  Result.Close;
  Result.Database := DataBase;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT');
  Result.SQL.Add('    0 as "Ord"');
  Result.SQL.Add('    ,COALESCE(GRUPO.NOME, '+QuotedStr(_cSemGrupo)+') AS "Grupo"');
  Result.SQL.Add('    , CAST(SUM(ESTOQUE.CUS_VEND) AS NUMERIC(18,2)) AS "Custo compra"');
  Result.SQL.Add('    , CAST(SUM(ESTOQUE.VAL_VEND) AS NUMERIC(18,2)) AS "Vendido por"');
  Result.SQL.Add('    , CAST(SUM(ESTOQUE.LUC_VEND) AS NUMERIC(18,2)) AS "Lucro bruto"');
  Result.SQL.Add('FROM ESTOQUE');
  Result.SQL.Add('LEFT JOIN GRUPO ON');
  Result.SQL.Add(' (GRUPO.NOME=ESTOQUE.NOME)');
  Result.SQL.Add('WHERE');
  Result.SQL.Add('(COALESCE(ESTOQUE.QTD_VEND,0) <> 0)');
  Result.SQL.Add('AND (ESTOQUE.ULT_VENDA >= :XDATAINI)');
  Result.SQL.Add('GROUP BY GRUPO.NOME');
  Result.SQL.Add('UNION ALL');
  Result.SQL.Add('SELECT FIRST 1');
  Result.SQL.Add('    1 as "Ord"');
  Result.SQL.Add('    , ' + QuotedStr(_cDescontoAcrescimo) + ' AS "Grupo"');
  Result.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Custo compra"');
  Result.SQL.Add('    , CAST(SUM(' + RetornaFormatoValorSQL(RetornarTotalDescontoAcresc) + ') AS NUMERIC(18,2)) AS "Vendido por"');
  Result.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Lucro bruto"');
  Result.SQL.Add('FROM EMITENTE');

  Result.SQL.Add('UNION ALL');
  Result.SQL.Add('SELECT FIRST 1');
  Result.SQL.Add('    2 as "Ord"');
  Result.SQL.Add('    , ' + QuotedStr(_cItensNaoRelacionados) + ' AS "Grupo"');
  Result.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Custo compra"');
  Result.SQL.Add('    , CAST(SUM(' + RetornaFormatoValorSQL(RetornarTotalNaoRelacionados) + ') AS NUMERIC(18,2)) AS "Vendido por"');
  Result.SQL.Add('    , CAST(SUM(0) AS NUMERIC(18,2)) AS "Lucro bruto"');
  Result.SQL.Add('FROM EMITENTE');
  Result.SQL.Add('ORDER BY 1');
  Result.ParamByName('XDATAINI').AsDate := dtInicial.Date;
  Result.Open;
  Result.First;

  DesativarColunas(Result);  
end;

function TfrmRelResumoVendas.RetornarWhere: string;
begin
  Result := Result + RetornarWhereOperacoes + ' ';
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
    ShowMessage(_cPeriodoDataInvalida);
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
  end;

  btnVoltar.Enabled := (not pnlPrincipal.Visible);
  inherited;
end;

procedure TfrmRelResumoVendas.FazUpdateValores;
var
  nRecNo: Integer;
  qryCons99, qryCons100: TIBQuery;
begin
  qryCons99 := CriaIBQuery(DataSetEstoque.Transaction);
  qryCons100 := CriaIBQuery(DataSetEstoque.Transaction);
  Application.ProcessMessages;
  Screen.Cursor  := crAppStart;
  DataSetEstoque.DisableControls;
  nRecNo := DataSetEstoque.RecNo;
  try
    cdsExcluidos.Close;
    cdsExcluidos.CreateDataSet;

    qryCons99.Close;
    qryCons99.Database := DataBase;
    qryCons99.SQL.Add('select');
    qryCons99.SQL.Add('ITENS001.DESCRICAO,');
    qryCons99.SQL.Add('sum(ITENS001.QUANTIDADE) as vQTD1,');
    qryCons99.SQL.Add('sum(ITENS001.TOTAL) as vTOT1,');
    qryCons99.SQL.Add('sum(ITENS001.CUSTO*ITENS001.QUANTIDADE) as vCUS1');
    qryCons99.SQL.Add('from ITENS001, VENDAS');
    qryCons99.SQL.Add('where');
    qryCons99.SQL.Add('(VENDAS.EMISSAO<='+QuotedStr(DateToStrInvertida(dtFinal.Date))+') and (VENDAS.EMISSAO>='+QuotedStr(DateToStrInvertida(dtInicial.Date))+')');
    qryCons99.SQL.Add('and (VENDAS.NUMERONF=ITENS001.NUMERONF) '+RetornarWhereOperacoes+' and (VENDAS.EMITIDA=''S'')');
    qryCons99.SQL.Add('group by DESCRICAO');
    qryCons99.Open;

    while not qryCons99.Eof do
    begin
      if (AllTrim(qryCons99.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(qryCons99.FieldByname('DESCRICAO').AsString) <> 'Acréscimo') then
      begin
        if not DataSetEstoque.Locate('DESCRICAO',AllTrim(qryCons99.FieldByname('DESCRICAO').AsString),[]) then
        begin
          if not cdsExcluidos.Locate('NOME', qryCons99.FieldByname('DESCRICAO').AsString, []) then
          begin
            cdsExcluidos.Append;
            cdsExcluidosNOME.AsString    := qryCons99.FieldByname('DESCRICAO').AsString;
            cdsExcluidosVALOR.AsCurrency := 0;
          end
          else
            cdsExcluidos.Edit;
            
          cdsExcluidosVALOR.AsCurrency := cdsExcluidosVALOR.AsCurrency + qryCons99.FieldByname('VTOT1').AsFloat;

          cdsExcluidos.Post;          
        end else
        begin
          if DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime < dtInicial.Date then
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
    qryCons100.SQL.Add('ALTERACA.DESCRICAO,');
    qryCons100.SQL.Add('sum(ALTERACA.QUANTIDADE) as vQTD2,');
    qryCons100.SQL.Add('sum(ALTERACA.TOTAL) as vTOT2');
    qryCons100.SQL.Add('from ALTERACA');
    qryCons100.SQL.Add('where (ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicial.Date)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal.Date)) + ')');
    qryCons100.SQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+'))');
    qryCons100.SQL.Add('group by DESCRICAO');
    qryCons100.Open;
    
    while not qryCons100.Eof do
    begin
      if (AllTrim(qryCons100.FieldByname('DESCRICAO').AsString) <> 'Desconto') and (AllTrim(qryCons100.FieldByname('DESCRICAO').AsString) <> 'Acréscimo') then
      begin
        if not DataSetEstoque.Locate('DESCRICAO',AllTrim(qryCons100.FieldByname('DESCRICAO').AsString),[]) then
        begin
          if not cdsExcluidos.Locate('NOME', qryCons100.FieldByname('DESCRICAO').AsString, []) then
          begin
            cdsExcluidos.Append;
            cdsExcluidosNOME.AsString    := qryCons100.FieldByname('DESCRICAO').AsString;
            cdsExcluidosVALOR.AsCurrency := 0;
          end
          else
            cdsExcluidos.Edit;

          cdsExcluidosVALOR.AsCurrency := cdsExcluidosVALOR.AsCurrency + qryCons100.FieldByname('VTOT2').AsFloat;

          cdsExcluidos.Post;
        end else
        begin
          if DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime < dtInicial.Date then
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
      if (DataSetEstoque.FieldByName('ULT_VENDA').AsDateTime >= dtInicial.Date) then
      begin
        DataSetEstoque.Edit;
        DataSetEstoque.FieldByName('QTD_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('CUS_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('VAL_VEND').AsFloat := 0;
        DataSetEstoque.FieldByName('LUC_VEND').AsFloat := 0;

        if qryCons99.Locate('DESCRICAO',AllTrim(DataSetEstoque.FieldByName('DESCRICAO').AsString),[]) then
        begin
          DataSetEstoque.FieldByName('QTD_VEND').AsFloat := DataSetEstoque.FieldByName('QTD_VEND').AsFloat + qryCons99.FieldByname('VQTD1').AsFloat;
          DataSetEstoque.FieldByName('VAL_VEND').AsFloat := DataSetEstoque.FieldByName('VAL_VEND').AsFloat + qryCons99.FieldByname('VTOT1').AsFloat;
          DataSetEstoque.FieldByName('CUS_VEND').AsFloat := DataSetEstoque.FieldByName('CUS_VEND').AsFloat + qryCons99.FieldByname('VCUS1').AsFloat;
        end;

        if qryCons100.Locate('DESCRICAO',AllTrim(DataSetEstoque.FieldByName('DESCRICAO').AsString),[]) then
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

end.
