unit uRateioVendasBalcao;

interface

uses
  IBDatabase
  , IBQuery
  , Dialogs
  ;

type
  TCSTPISCOFINS = class
    CST: String;
    Valor: Double;
  end;

type
  TCFOP = class
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
    CFOP: String;
    CSTPISCOFINS: String;
  end;

type
  TCSTCSOSN = class
    CSTCSOSN: String;
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
    CSTPISCOFINS: String;
  end;

type
  TRateioBalcao = class
  private
    FIBTransaction: TIBTransaction;
    FIBQDESCONTOITEM: TIBQuery;
    FIBQDESCONTOCUPOM: TIBQuery;
    FIBQACRESCIMOCUPOM: TIBQuery;
    FIBQTOTALCUPOM: TIBQuery;
    FIBQTOTALITENS: TIBQuery;
    FIBQALTERACA: TIBQuery;
    FDescontoItem: Double;
    FRateioDescontoItem: Double;
    FRateioAcrescimoItem: Double;
    procedure SetIBTransaction(const Value: TIBTransaction);
  public
    constructor Create;
    destructor Destroy; override;
    procedure CalcularRateio(Caixa: String; NumeroNF: String; Item: String);
    property IBTransaction: TIBTransaction read FIBTransaction write SetIBTransaction;
    property DescontoItem: Double read FDescontoItem write FDescontoItem;
    property RateioDescontoItem: Double read FRateioDescontoItem write FRateioDescontoItem;
    property RateioAcrescimoItem: Double read FRateioAcrescimoItem write FRateioAcrescimoItem;

  end;

implementation

uses SysUtils;

{ TRateioBalcao }

procedure TRateioBalcao.CalcularRateio(Caixa: String; NumeroNF: String;
  Item: String);
begin

  FDescontoItem        := 0.00;
  FRateioDescontoItem  := 0.00;
  FRateioAcrescimoItem := 0.00;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transação não informada');
    Exit;
  end;

  try
    // Calcula o rateio pertencente ao caixa, pedido e item informados

    // Seleciona o total bruto do item
    FIBQALTERACA.Close;
    FIBQALTERACA.SQL.Text :=
      'select A.PEDIDO, A.ITEM, A.CODIGO, A.CST_ICMS, coalesce(A.ALIQUICM, '''') as ALIQUICM, A.CST_PIS_COFINS, ' +
      'A.ALIQ_PIS, A.ALIQ_COFINS, A.CFOP, coalesce(A.TOTAL, 0) as VL_ITEM, A.CSOSN, ' +
      'E.CSOSN as ESTOQUE_CSOSN, E.CFOP as ESTOQUE_CFOP, E.ALIQUOTA_NFCE, E.CSOSN_NFCE, E.CST_NFCE, E.CEST ' +
      'from ALTERACA A ' +
      'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
      'where A.CAIXA = ' + QuotedStr(Caixa) +
      ' and A.PEDIDO = ' + QuotedStr(NumeroNF) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
      ' and A.DESCRICAO <> ''Desconto'' ' +
      ' and A.DESCRICAO <> ''Acréscimo'') ' +
      ' and A.ITEM = ' + QuotedStr(Item) + // Que tenha número do item informado no campo ALTERACA.ITEM
      ' order by A.REGISTRO';
    FIBQALTERACA.Open;

    //Seleciona o total dos itens menos os seus descontos, para usar no rateio
    FIBQTOTALITENS.Close;
    FIBQTOTALITENS.SQL.Text :=
        'select sum(cast(TOTAL as numeric(18,2))) as TOTAL ' +
        'from ALTERACA ' +
        'where PEDIDO = ' + QuotedStr(NUMERONF) +
        ' and CAIXA = ' + QuotedStr(CAIXA) +
        ' and DESCRICAO <> ''<CANCELADO>'' ' +
        ' and TIPO <> ''KOLNAC'' ' + // Sandro Silva 2019-03-26 Registro fica em dead lock, com TIPO = KOLNAC até que seja destravado e processado
        ' and coalesce(ITEM,'''') <> '''' ';
    FIBQTOTALITENS.Open;

    // Seleciona os descontos concedidos específicos aos itens
    FIBQDESCONTOITEM.Close;
    FIBQDESCONTOITEM.SQL.Text :=
      'select A.PEDIDO, A.CODIGO, A.ALIQUICM, A.ITEM, A.TOTAL as DESCONTO ' +
      'from ALTERACA A ' +
      'where A.CAIXA = ' + QuotedStr(Caixa) +
      ' and A.PEDIDO = ' + QuotedStr(NumeroNF) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO = ''Desconto'' ' +
      ' and ITEM = ' + QuotedStr(ITEM) +
      //' and coalesce(A.ITEM, '''') <> '''' ' +
      ' order by A.ITEM'; // Que tenha número do item informado no campo ALTERACA.ITEM
    FIBQDESCONTOITEM.Open;

    // Seleciona os descontos lançados para o cupom
    FIBQDESCONTOCUPOM.Close;
    FIBQDESCONTOCUPOM.SQL.Text :=
      'select A.PEDIDO, sum(A.TOTAL) as DESCONTOCUPOM ' +
      'from ALTERACA A ' +
      'where A.CAIXA = ' + QuotedStr(Caixa) +
      ' and A.PEDIDO = ' + QuotedStr(NUMERONF) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO = ''Desconto'' ' +
      ' and coalesce(A.ITEM, '''') = '''' ' +
      ' group by A.PEDIDO ' +
      ' order by PEDIDO';
    FIBQDESCONTOCUPOM.Open;

    // Seleciona os acréscimos lançados para o cupom
    FIBQACRESCIMOCUPOM.Close;
    FIBQACRESCIMOCUPOM.SQL.Text :=
      'select A.PEDIDO, sum(A.TOTAL) as ACRESCIMOCUPOM ' +
      'from ALTERACA A ' +
      'where A.CAIXA = ' + QuotedStr(Caixa) +
      ' and A.PEDIDO = ' + QuotedStr(NumeroNF) +
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
      ' and A.DESCRICAO = ''Acréscimo'' ' +
      ' and coalesce(A.ITEM, '''') = '''' ' +
      ' group by A.PEDIDO ' +
      ' order by PEDIDO';
    FIBQACRESCIMOCUPOM.Open;

    FDescontoItem        := FIBQDESCONTOITEM.FieldByName('DESCONTO').AsFloat;
    FRateioDescontoItem  := (FIBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat / FIBQTOTALITENS.FieldByName('TOTAL').AsFloat) * (FIBQALTERACA.FieldByName('VL_ITEM').AsFloat + FDescontoItem);
    FRateioAcrescimoItem := (FIBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat / FIBQTOTALITENS.FieldByName('TOTAL').AsFloat) * (FIBQALTERACA.FieldByName('VL_ITEM').AsFloat + FDescontoItem);
  except
    on E: Exception do
    begin
      ShowMessage('Não foi possível calcular o rateio' + #13 + E.Message);
    end;
  end;

end;

constructor TRateioBalcao.Create;
begin
  // Cria as querys e atribui a transação
  FIBQALTERACA       := TIBQuery.Create(nil);
  FIBQDESCONTOITEM   := TIBQuery.Create(nil);
  FIBQDESCONTOCUPOM  := TIBQuery.Create(nil);
  FIBQACRESCIMOCUPOM := TIBQuery.Create(nil);
  FIBQTOTALCUPOM     := TIBQuery.Create(nil);
  FIBQTOTALITENS     := TIBQuery.Create(nil);

  FIBQALTERACA.DisableControls;
  FIBQDESCONTOITEM.DisableControls;
  FIBQDESCONTOCUPOM.DisableControls;
  FIBQACRESCIMOCUPOM.DisableControls;
  FIBQTOTALCUPOM.DisableControls;
  FIBQTOTALITENS.DisableControls;

end;

destructor TRateioBalcao.Destroy;
begin
  FreeAndNil(FIBQALTERACA);
  FreeAndNil(FIBQDESCONTOITEM);
  FreeAndNil(FIBQDESCONTOCUPOM);
  FreeAndNil(FIBQACRESCIMOCUPOM);
  FreeAndNil(FIBQTOTALCUPOM);
  FreeAndNil(FIBQTOTALITENS);
    
  inherited;
end;

procedure TRateioBalcao.SetIBTransaction(const Value: TIBTransaction);
var
  iItem: Integer;
begin
  FIBTransaction := Value;

  FIBQALTERACA.Transaction       := FIBTransaction;
  FIBQDESCONTOITEM.Transaction   := FIBTransaction;
  FIBQDESCONTOCUPOM.Transaction  := FIBTransaction;
  FIBQACRESCIMOCUPOM.Transaction := FIBTransaction;
  FIBQTOTALCUPOM.Transaction     := FIBTransaction;
  FIBQTOTALITENS.Transaction     := FIBTransaction;

end;

end.
