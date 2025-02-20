unit uEstruturaRelVendasPorCliente;

interface

uses
  uIEstruturaRelVendasPorCliente, uIEstruturaTipoRelatorioPadrao, IBDatabase,
  Classes, SysUtils, SmallFunc, IBQuery;

type
  TEstruturaRelVendasPorCliente = class(TInterfacedObject, IEstruturaRelVendasPorCliente)
  private
    FbItemAItem: Boolean;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FoDataBase: TIBDatabase;
    FlsOperacoes: TStringList;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    constructor Create;
    function RetornarWhereNota: String;
    function RetornarWhereCupom: String;
    function RetornarDescricaoFiltroData: String;
    function RetornarSQLNota: String;
    function RetornarSQLCupom: String;
  public
    destructor Destroy; override;
    class function New: IEstruturaRelVendasPorCliente;
    function setUsuario(AcUsuario: String): IEstruturaRelVendasPorCliente;
    function setDataBase(AoDataBase: TIBDatabase): IEstruturaRelVendasPorCliente;
    function setItemAItem(AbItemAItem: Boolean): IEstruturaRelVendasPorCliente;
    function setDataInicial(AdData: TDateTime): IEstruturaRelVendasPorCliente;
    function setDataFinal(AdData: TDateTime): IEstruturaRelVendasPorCliente;
    function setOperacoes(AslItens: TStringList): IEstruturaRelVendasPorCliente;
    function ImprimeNota(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
    function ImprimeCupom(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
    function Estrutura: IEstruturaTipoRelatorioPadrao;
  end;

implementation

uses
  uEstruturaTipoRelatorioPadrao, uEstruturaRelVendasPorClienteNota,
  uEstruturaRelVendasPorClienteCupom, uIEstruturaRelatorioPadrao,
  uDadosRelatorioPadraoDAO;

{ TEstruturaRelVendasPorCliente }

constructor TEstruturaRelVendasPorCliente.Create;
begin
  FlsOperacoes := TStringList.Create;

  FoEstrutura := TEstruturaTipoRelatorioPadrao.New;
end;

function TEstruturaRelVendasPorCliente.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

function TEstruturaRelVendasPorCliente.ImprimeNota(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
var
  i: Integer;
  oEstruturaClienteNota: IEstruturaRelatorioPadrao;
  oQry: TIBQuery;
begin
  Result := Self;

  if not AbImprime then
    Exit;

  oQry := TIBQuery.Create(nil);
  try
    oQry.Close;
    oQry.Database := FoDataBase;
    oQry.SQL.Text := RetornarSQLNota;
    oQry.Open;

    oEstruturaClienteNota := TEstruturaRelVendasPorClienteNota.New
                                                              .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                              .setDataBase(FoDataBase)                                                              
                                                                                              .CarregarDados(oQry)

                                                                     );

    oEstruturaClienteNota.FiltrosRodape.setFiltroData(RetornarDescricaoFiltroData);

    for i := 0 to Pred(FlsOperacoes.Count) do
      oEstruturaClienteNota.FiltrosRodape.AddItem(FlsOperacoes[i]);

    FoEstrutura.GerarImpressao(oEstruturaClienteNota);
  finally
    FreeAndNil(oQry);
  end;
end;

function TEstruturaRelVendasPorCliente.RetornarSQLNota: String;
var
  lsSQL: TStringList;
begin
  lsSQL := TStringList.Create;
  try
    lsSQL.Add('SELECT');
    lsSQL.Add('    VENDAS.EMISSAO AS "Data"');
    lsSQL.Add('    , SUBSTRING(VENDAS.NUMERONF FROM 1 FOR 9) ||''/''||SUBSTRING(VENDAS.NUMERONF FROM 10 FOR 3) AS "Número da NF"');
    lsSQL.Add('    , VENDAS.CLIENTE AS "Cliente"');
    if FbItemAItem then
    begin
      lsSQL.Add('    , ITENS001.CODIGO AS "Código"');
      lsSQL.Add('    , ITENS001.DESCRICAO AS "Descrição"');
      lsSQL.Add('    , CAST(ITENS001.TOTAL AS NUMERIC(18,2)) AS "Valor"');
      lsSQL.Add('FROM VENDAS');
      lsSQL.Add('INNER JOIN ITENS001');
      lsSQL.Add('    ON (ITENS001.NUMERONF=VENDAS.NUMERONF)');
    end
    else
    begin
      lsSQL.Add('    , CAST(VENDAS.TOTAL AS NUMERIC(18,2)) AS "Total"');
      lsSQL.Add('FROM VENDAS');
    end;
    lsSQL.Add('WHERE');
    lsSQL.Add(RetornarWhereNota);
    lsSQL.Add('ORDER BY VENDAS.CLIENTE, VENDAS.EMISSAO, VENDAS.NUMERONF');

    Result := lsSQL.Text;
  finally
    FreeAndNil(lsSQL);
  end;
end;

function TEstruturaRelVendasPorCliente.ImprimeCupom(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
var
  oEstruturaClienteCupom: IEstruturaRelatorioPadrao;
  oQry: TIBQuery;
begin
  Result := Self;

  if not AbImprime then
    Exit;

  oQry := TIBQuery.Create(nil);
  try
    oQry.Close;
    oQry.Database := FoDataBase;
    oQry.SQL.Text := RetornarSQLCupom;
    oQry.Open;

    oEstruturaClienteCupom := TEstruturaRelVendasPorClienteCupom.New
                                                                .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                                .setDataBase(FoDataBase)
                                                                                                .CarregarDados(oQry)                                                                                                     
                                                                       );

    oEstruturaClienteCupom.FiltrosRodape.setFiltroData(RetornarDescricaoFiltroData);

    FoEstrutura.GerarImpressao(oEstruturaClienteCupom);
  finally
    FreeAndNil(oQry);
  end;
end;

function TEstruturaRelVendasPorCliente.RetornarSQLCupom: String;
var
  lsSQL: TStringList;
begin
  lsSQL := TStringList.Create;
  try
    if FbItemAItem then
    begin
      lsSQL.Add('SELECT');
      lsSQL.Add('    ALTERACA.DATA AS "Data"');
      lsSQL.Add('    , ALTERACA.PEDIDO AS "Número"');
      lsSQL.Add('    , COALESCE(ALTERACA.CLIFOR,'''') AS "Cliente"');
      lsSQL.Add('    , ALTERACA.ITEM AS "Código"');
      lsSQL.Add('    , ALTERACA.DESCRICAO AS "Descrição"');
      lsSQL.Add('    , CAST(ALTERACA.TOTAL AS NUMERIC(18,2)) AS "Valor"');
      lsSQL.Add('FROM ALTERACA');
      lsSQL.Add('WHERE');
      lsSQL.Add(RetornarWhereCupom);
      lsSQL.Add('ORDER BY COALESCE(ALTERACA.CLIFOR,''''), ALTERACA.DATA, ALTERACA.PEDIDO');
    end
    else
    begin
      lsSQL.Add('WITH DADOSAGRUPADOS AS(');
      lsSQL.Add('SELECT');
      lsSQL.Add('    ALTERACA.PEDIDO');
      lsSQL.Add('    , COALESCE(ALTERACA.CLIFOR,'''') AS CLIFOR');
      lsSQL.Add('    , CAST(SUM(ALTERACA.TOTAL) AS NUMERIC(18,2)) AS VALOR');
      lsSQL.Add('FROM ALTERACA');
      lsSQL.Add('WHERE');
      lsSQL.Add(RetornarWhereCupom);
      lsSQL.Add('GROUP BY ALTERACA.PEDIDO, COALESCE(ALTERACA.CLIFOR,'''')');
      lsSQL.Add(')');
      lsSQL.Add('SELECT');
      lsSQL.Add('    MIN(ALTERACA.DATA) AS "Data"');
      lsSQL.Add('    , ALTERACA.PEDIDO AS "Número"');
      lsSQL.Add('    , ALTERACA.CLIFOR AS "Cliente"');
      lsSQL.Add('    , DADOSAGRUPADOS.VALOR AS "Total"');
      lsSQL.Add('FROM ALTERACA');
      lsSQL.Add('INNER JOIN DADOSAGRUPADOS');
      lsSQL.Add('    ON (DADOSAGRUPADOS.PEDIDO=ALTERACA.PEDIDO)');
      lsSQL.Add('    AND (DADOSAGRUPADOS.CLIFOR=COALESCE(ALTERACA.CLIFOR,''''))');
      lsSQL.Add('WHERE');
      lsSQL.Add(RetornarWhereCupom);
      lsSQL.Add('GROUP BY ALTERACA.PEDIDO, ALTERACA.CLIFOR, DADOSAGRUPADOS.VALOR');
      lsSQL.Add('ORDER BY ALTERACA.CLIFOR, ALTERACA.PEDIDO, MIN(ALTERACA.DATA)');
    end;
    
    Result := lsSQL.Text;
  finally
    FreeAndNil(lsSQL);
  end;
end;

function TEstruturaRelVendasPorCliente.RetornarDescricaoFiltroData: String;
begin
  Result := 'Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim);
end;

function TEstruturaRelVendasPorCliente.RetornarWhereNota: String;
var
  i: Integer;
  AStr: TStringList;
  cOperacao: String;
begin
  AStr := TStringList.Create;
  try
    if (FdDataIni <= FdDataFim) then
      AStr.Add('(VENDAS.EMITIDA=''S'') AND (VENDAS.EMISSAO BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
    if Assigned(FlsOperacoes) and (FlsOperacoes.Count > 0) then
    begin
      AStr.Add('AND (');
      for i := 0 to Pred(FlsOperacoes.Count) do
      begin
        cOperacao := EmptyStr;
        if i > 0 then
          cOperacao := 'OR ';
        cOperacao := cOperacao + '(VENDAS.OPERACAO='+QuotedStr(FlsOperacoes[i])+')';

        AStr.Add(cOperacao);
      end;
      AStr.Add(')');
    end else
      AStr.Add('AND (VENDAS.OPERACAO='''')');
    Result := AStr.Text;
  finally
    FreeAndNil(AStr);
  end;
end;

function TEstruturaRelVendasPorCliente.RetornarWhereCupom: String;
var
  AStr: TStringList;
begin
  AStr := TStringList.Create;
  try
    if (FdDataIni <= FdDataFim) then
      AStr.Add('(ALTERACA.TIPO IN (''BALCAO'', ''VENDA'')) AND (ALTERACA.DATA BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
    Result := AStr.Text;
  finally
    FreeAndNil(AStr);
  end;
end;

class function TEstruturaRelVendasPorCliente.New: IEstruturaRelVendasPorCliente;
begin
  Result := Self.Create;
end;

function TEstruturaRelVendasPorCliente.setDataBase(AoDataBase: TIBDatabase): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FoDataBase := AoDataBase;
end;

function TEstruturaRelVendasPorCliente.setDataFinal(AdData: TDateTime): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FdDataFim := AdData;
end;

function TEstruturaRelVendasPorCliente.setDataInicial(AdData: TDateTime): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FdDataIni := AdData;
end;

function TEstruturaRelVendasPorCliente.setItemAItem(AbItemAItem: Boolean): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FbItemAItem := AbItemAItem;
end;

function TEstruturaRelVendasPorCliente.setUsuario(AcUsuario: String): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FoEstrutura.setUsuario(AcUsuario);
end;

function TEstruturaRelVendasPorCliente.setOperacoes(AslItens: TStringList): IEstruturaRelVendasPorCliente;
var
  i: Integer;
begin
  Result := Self;

  for i := 0 to Pred(AslItens.Count) do
    FlsOperacoes.Add(AslItens[i]);
end;

destructor TEstruturaRelVendasPorCliente.Destroy;
begin
  FreeAndNil(FlsOperacoes);
  inherited;
end;

end.
