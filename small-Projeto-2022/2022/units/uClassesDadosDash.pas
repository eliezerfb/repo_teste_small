unit uClassesDadosDash;


interface

uses
  System.Generics.Collections
  , REST.Json.Types
  , System.UITypes
  , Vcl.Graphics
  ;

{$M+}

type
  TAnaliseIA = class
  private
    FAnalise: string;
    FPeriodo: TDate;
  published
    property Analise: string read FAnalise write FAnalise;
    property Periodo: TDate read FPeriodo write FPeriodo;
  end;

  TContasBancarias = class
  private
    FDescricao: string;
    FValor: Double;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Double read FValor write FValor;
  end;

  TVendasFormaPgto = class
  private
    FDescricao: string;
    FValor: Double;
    FPercentual: Double;
    FCor: TalphaColor;
    FIdForma : integer;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Double read FValor write FValor;
    property Percentual: Double read FPercentual write FPercentual;
    property Cor: TalphaColor read FCor write FCor;
    property IdForma: integer read FIdForma write FIdForma;
  end;

  TVendasVendedor = class
  private
    FValor: Double;
    FVendedor: string;
    FCor: TalphaColor;
  published
    property Valor: Double read FValor write FValor;
    property Vendedor: string read FVendedor write FVendedor;
    property Cor: TalphaColor read FCor write FCor;
  end;

  TContasPagar = class
  private
    FPagarDia: Double;
    FPagarMes: Double;
    FPagarVencidasMes: Double;
    FPagasDia: Double;
    FPagasMes: Double;
    FVencidasMes: integer;
    FValorVencidasMes: Double;
    function getPercPagDia: Double;
    function getPercPagMes: Double;
  published
    property PagarDia: Double read FPagarDia write FPagarDia;
    property PagarMes: Double read FPagarMes write FPagarMes;
    property PagarVencidasMes: Double read FPagarVencidasMes write FPagarVencidasMes;
    property PagasDia: Double read FPagasDia write FPagasDia;
    property PagasMes: Double read FPagasMes write FPagasMes;
    property VencidasMes: integer read FVencidasMes write FVencidasMes;
    property ValorVencidasMes: Double read FValorVencidasMes write FValorVencidasMes;
    property PercPagDia : Double read getPercPagDia;
    property PercPagMes : Double read getPercPagMes;
  end;

  TContasReceber = class
  private
    FReceberDia: Double;
    FReceberMes: Double;
    FRecebidasDia: Double;
    FRecebidasMes: Double;
    FVencidasMes: integer;
    FValorVencidasMes: Double;
    function getPercRecDia: Double;
    function getPercRecMes: Double;
  published
    property ReceberDia: Double read FReceberDia write FReceberDia;
    property ReceberMes: Double read FReceberMes write FReceberMes;
    property RecebidasDia: Double read FRecebidasDia write FRecebidasDia;
    property RecebidasMes: Double read FRecebidasMes write FRecebidasMes;
    property VencidasMes: integer read FVencidasMes write FVencidasMes;
    property ValorVencidasMes: Double read FValorVencidasMes write FValorVencidasMes;
    property PercRecDia : Double read getPercRecDia;
    property PercRecMes : Double read getPercRecMes;
  end;

  TVendasDiarias = class
  private
    FDia: string;
    FValor: Double;
  published
    property Dia: string read FDia write FDia;
    property Valor: Double read FValor write FValor;
  end;

  TInadimplencia = class
  private
    FAno: Double;
    FTotal: Double;
    FTrimestre: Double;
  published
    property Ano: Double read FAno write FAno;
    property Total: Double read FTotal write FTotal;
    property Trimestre: Double read FTrimestre write FTrimestre;
  end;

  TVendasPeriodo = class
  private
    FPeriodo: string;
    FVendasMes: Double;
    [JSONName('VendasDiarias')]
    FVendasDiarias: TArray<TVendasDiarias>;
    [JSONName('VendasVendedor')]
    FVendasVendedor: TArray<TVendasVendedor>;
    [JSONName('VendasFormaPgto')]
    FVendasFormaPgto: TArray<TVendasFormaPgto>;
  published
    property Periodo: string read FPeriodo write FPeriodo;
    property VendasMes: Double read FVendasMes write FVendasMes;
    property VendasDiarias: TArray<TVendasDiarias> read FVendasDiarias write FVendasDiarias;
    property VendasVendedor: TArray<TVendasVendedor> read FVendasVendedor write FVendasVendedor;
    property VendasFormaPgto: TArray<TVendasFormaPgto> read FVendasFormaPgto write FVendasFormaPgto;
  end;

  TRootDadosDTO = class
  private
    FVendasDia: Double;
    [JSONName('VendasPeriodo')]
    FVendasPeriodo: TArray<TVendasPeriodo>;
    FSaldoCaixa: Double;
    FInadimplencia: TInadimplencia;
    FContasReceber: TContasReceber;
    FContasPagar: TContasPagar;
    [JSONName('ContasBancarias')]
    FContasBancarias: TArray<TContasBancarias>;
    [JSONName('AnaliseIA')]
    FAnaliseIA : TArray<TAnaliseIA>;
  published
    property VendasDia: Double read FVendasDia write FVendasDia;
    property VendasPeriodo: TArray<TVendasPeriodo> read FVendasPeriodo write FVendasPeriodo;
    property SaldoCaixa: Double read FSaldoCaixa write FSaldoCaixa;
    property Inadimplencia: TInadimplencia read FInadimplencia;
    property ContasReceber: TContasReceber read FContasReceber;
    property ContasPagar: TContasPagar read FContasPagar;
    property ContasBancarias: TArray<TContasBancarias> read FContasBancarias write FContasBancarias;
    property AnaliseIA : TArray<TAnaliseIA> read FAnaliseIA write FAnaliseIA;
  public
    procedure SetCorVendedor;
    procedure SetCorFormasPgto;
    procedure CalcPercentualPgto;
    destructor Destroy; override;
  end;

implementation

{ TRootDadosDTO }

procedure TRootDadosDTO.CalcPercentualPgto;
var
  i, iPeriodo : integer;
  dTotal : double;
begin
  for iPeriodo := Low(VendasPeriodo) to High(VendasPeriodo) do
  begin
    try
      dTotal := 0;
      for I := Low(VendasPeriodo[iPeriodo].VendasFormaPgto) to High(VendasPeriodo[iPeriodo].VendasFormaPgto) do
      begin
        dTotal:= dTotal + VendasPeriodo[iPeriodo].VendasFormaPgto[i].Valor;
      end;

      for I := Low(VendasPeriodo[iPeriodo].VendasFormaPgto) to High(VendasPeriodo[iPeriodo].VendasFormaPgto) do
      begin
        VendasPeriodo[iPeriodo].VendasFormaPgto[i].Percentual := VendasPeriodo[iPeriodo].VendasFormaPgto[i].Valor / (dTotal / 100);
      end;
    except
    end;
  end;
end;

destructor TRootDadosDTO.Destroy;
begin
  FInadimplencia.Free;
  FContasReceber.Free;
  FContasPagar.Free;
  inherited;
end;

procedure TRootDadosDTO.SetCorFormasPgto;
var
  i, iPeriodo : integer;
begin
  for iPeriodo := Low(VendasPeriodo) to High(VendasPeriodo) do
  begin
    for I := Low(VendasPeriodo[iPeriodo].VendasFormaPgto) to High(VendasPeriodo[iPeriodo].VendasFormaPgto) do
    begin
      case VendasPeriodo[iPeriodo].VendasFormaPgto[i].IdForma of
        1  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF69C28C; //Dinheiro
        2  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF7EFFD4; //Cheque
        3  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFF2496C; //Cartão de Crédito
        4  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFF1B44C; //Cartão de Débito
        5  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFFFBC85; //Crédito de Loja
        6  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF0A476C; //Vale Alimentação
        7  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFD4681F; //Vale Refeição
        8  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFEA85FF; //Vale Presente
        9  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF595959; //Vale Combustível
        10 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF607D8B; //Duplicata Mercantil
        11 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF96A3F3; //Boleto Bancário
        12 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF5E9EA0; //Depósito Bancário
        13 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF0069B4; //Pagamento Instantâneo (PIX) Dinâmico
        14 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFB186FD; //Transfer.bancária, Carteira Digital
        15 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FFC7DE72; //Progr.de fidelidade, Cashback, Crédito Virtual
        16 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF85D4FF; //Pagamento Instantâneo (PIX) Estático
        17 : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF7C49F2; //Outros
        0  : VendasPeriodo[iPeriodo].VendasFormaPgto[i].FCor := $FF7C49F2; //Outros
      end;
    end;
  end;
end;

procedure TRootDadosDTO.SetCorVendedor;
var
  dTotal, dMedia : double;
  i, iPeriodo, iQtdT, iQtdUp, iQtdDw, iRangUp, iRangDw : integer;
  ColorUp, ColorDw : TAlphaColor;
begin
  for iPeriodo := Low(VendasPeriodo) to High(VendasPeriodo) do
  begin
    dTotal := 0;
    dMedia := 0;
    iQtdT  := 0;
    iQtdUp := 0;
    iQtdDw := 0;

    ColorUp := $FF6BC18E;
    ColorDw := $FFEDA10D;

    if High(VendasPeriodo[iPeriodo].VendasVendedor) < 0 then
      Continue;

    for I := Low(VendasPeriodo[iPeriodo].VendasVendedor) to High(VendasPeriodo[iPeriodo].VendasVendedor) do
    begin
      dTotal := dTotal + VendasPeriodo[iPeriodo].VendasVendedor[i].FValor;
      Inc(iQtdT);
    end;

    dMedia := dTotal / iQtdT;

    for I := Low(VendasPeriodo[iPeriodo].VendasVendedor) to High(VendasPeriodo[iPeriodo].VendasVendedor) do
    begin
      if VendasPeriodo[iPeriodo].VendasVendedor[i].FValor < dMedia then
        Inc(iQtdDw)
      else
        Inc(iQtdUp);
    end;

    //Define Range
    if iQtdUp > 0 then
      iRangUp :=  Round(150 / iQtdUp);
    if iQtdDw > 0 then
      iRangDw :=  Round(150 / iQtdDw);

    iQtdDw  := 0;
    TAlphaColorRec(ColorUp).a := 100;

    for I := Low(VendasPeriodo[iPeriodo].VendasVendedor) to High(VendasPeriodo[iPeriodo].VendasVendedor) do
    begin
      if VendasPeriodo[iPeriodo].VendasVendedor[i].FValor < dMedia then
      begin
        TAlphaColorRec(ColorDw).a := 250 - (iRangDw * iQtdDw);
        Inc(iQtdDw);
        VendasPeriodo[iPeriodo].VendasVendedor[i].FCor    := ColorDw;
      end else
      begin
        TAlphaColorRec(ColorUp).a := TAlphaColorRec(ColorUp).a + iRangUP;
        VendasPeriodo[iPeriodo].VendasVendedor[i].FCor    := ColorUp;
      end;
    end;
  end;
end;

{ TContasPagar }

function TContasPagar.getPercPagDia: Double;
begin
  try
    Result := FPagasDia / (FPagarDia / 100);
  except
    Result := 0;
  end;

  if Result > 100 then
    Result := 100;
end;

function TContasPagar.getPercPagMes: Double;
begin
  try
    Result := FPagasMes / (FPagarMes / 100);
  except
    Result := 0;
  end;

  if Result > 100 then
    Result := 100;
end;



{ TContasReceber }

function TContasReceber.getPercRecDia: Double;
begin
  try
    Result := FRecebidasDia / (FReceberDia / 100);
  except
    Result := 0;
  end;

  if Result > 100 then
    Result := 100;
end;

function TContasReceber.getPercRecMes: Double;
begin
  try
    Result := FRecebidasMes / (FReceberMes / 100);
  except
    Result := 0;
  end;

  if Result > 100 then
    Result := 100;
end;

end.
