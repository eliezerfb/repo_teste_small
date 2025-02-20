unit uClassesDashboard;


interface

uses
  System.Generics.Collections
  , REST.Json.Types
  , System.UITypes
  , Vcl.Graphics
  , IBX.IBDatabase
  , IBX.IBQuery
  , System.SysUtils
  , DateUtils
  ;

{$M+}

type
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
    FIdForma : integer;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Double read FValor write FValor;
    property IdForma: integer read FIdForma write FIdForma;
  end;

  TVendasVendedor = class
  private
    FValor: Double;
    FVendedor: string;
  published
    property Valor: Double read FValor write FValor;
    property Vendedor: string read FVendedor write FVendedor;
  end;

  TContasPagar = class
  private
    FPagarDia: Double;
    FPagarMes: Double;
    FPagasDia: Double;
    FPagasMes: Double;
    FVencidasMes: integer;
    FValorVencidasMes: Double;
  published
    property PagarDia: Double read FPagarDia write FPagarDia;
    property PagarMes: Double read FPagarMes write FPagarMes;
    property PagasDia: Double read FPagasDia write FPagasDia;
    property PagasMes: Double read FPagasMes write FPagasMes;
    property VencidasMes: integer read FVencidasMes write FVencidasMes;
    property ValorVencidasMes: Double read FValorVencidasMes write FValorVencidasMes;
  end;

  TContasReceber = class
  private
    FReceberDia: Double;
    FReceberMes: Double;
    FRecebidasDia: Double;
    FRecebidasMes: Double;
    FVencidasMes: integer;
    FValorVencidasMes: Double;
  published
    property ReceberDia: Double read FReceberDia write FReceberDia;
    property ReceberMes: Double read FReceberMes write FReceberMes;
    property RecebidasDia: Double read FRecebidasDia write FRecebidasDia;
    property RecebidasMes: Double read FRecebidasMes write FRecebidasMes;
    property VencidasMes: integer read FVencidasMes write FVencidasMes;
    property ValorVencidasMes: Double read FValorVencidasMes write FValorVencidasMes;
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
    [JSONMarshalled(False)]
    FTransaction : TIBTransaction;
    [JSONMarshalled(False)]
    FFiltroNatVendas : string;
    procedure GetVendasDia;
    procedure GetVendasMes(iPeriodo:integer);
    procedure GetSaldoCaixa;
    procedure GetVendasDiarias(iPeriodo:integer);
    procedure GetVendasVendedor(iPeriodo:integer);
    procedure GetVendasFormaPgto(iPeriodo:integer);
    procedure GetInadimplencia;
    procedure GetContasReceber;
    procedure GetContasPagar;
    procedure GetContasBancarias;
  published
    property VendasDia: Double read FVendasDia write FVendasDia;
    property VendasPeriodo: TArray<TVendasPeriodo> read FVendasPeriodo write FVendasPeriodo;
    property SaldoCaixa: Double read FSaldoCaixa write FSaldoCaixa;
    property Inadimplencia: TInadimplencia read FInadimplencia;
    property ContasReceber: TContasReceber read FContasReceber;
    property ContasPagar: TContasPagar read FContasPagar;
    property ContasBancarias: TArray<TContasBancarias> read FContasBancarias write FContasBancarias;
    property FiltroNatVendas : string read FFiltroNatVendas write FFiltroNatVendas;
  public
    procedure setTransaction(Transaction : TIBTransaction);
    procedure GetDados;
    destructor Destroy; override;
    constructor Create;
  end;

implementation

{ TRootDadosDTO }

uses uFuncoesBancoDados, smallfunc_xe;

constructor TRootDadosDTO.Create;
begin
  SetLength(FVendasPeriodo,2);
  FVendasPeriodo[0] := TVendasPeriodo.Create;
  FVendasPeriodo[1] := TVendasPeriodo.Create;

  FInadimplencia := TInadimplencia.Create;
  FContasReceber := TContasReceber.Create;
  FContasPagar   := TContasPagar.Create;
end;

destructor TRootDadosDTO.Destroy;
begin
  FInadimplencia.Free;
  FContasReceber.Free;
  FContasPagar.Free;

  try
    FVendasPeriodo[0].Free;
    FVendasPeriodo[1].Free;
  except
  end;

  inherited;
end;


procedure TRootDadosDTO.GetVendasDia;
var
  qryAux: TIBQuery;
begin
  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text := ' Select'+
                       ' 	 Coalesce(SUM(TOTAL),0) TOTAL'+
                       ' From	'+
                       ' 	 (Select '+
                       ' 	 	 TOTAL'+
                       ' 	 From ALTERACA'+
                       ' 	 Where (TIPO=''BALCAO'' or TIPO=''VENDA'')'+
                       ' 	 	 and DATA = CURRENT_DATE		'+
                       ' 	 Union All			'+
                       ' 	 Select '+
                       ' 	 	 MERCADORIA+SERVICOS-DESCONTO TOTAL '+
                       ' 	 From VENDAS '+
                       ' 	 Where EMITIDA=''S'' '+
                       ' 	 	 and EMISSAO = CURRENT_DATE'+
                       FFiltroNatVendas+
                       ' 	 )';
    qryAux.Open;

    FVendasDia := qryAux.FieldByName('TOTAL').AsFloat;
  finally
    FreeAndNil(qryAux);
  end;
end;


procedure TRootDadosDTO.GetVendasMes(iPeriodo:integer);
var
  qryAux: TIBQuery;
  sData : string;
begin
  sData := 'DATEADD(-'+iPeriodo.ToString+'  month TO CURRENT_DATE)';

  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text := ' Select'+
                       ' 	 Coalesce(SUM(TOTAL),0) TOTAL'+
                       ' From	'+
                       ' 	 (Select '+
                       ' 		 TOTAL'+
                       ' 	 From ALTERACA'+
                       ' 	 Where (TIPO=''BALCAO'' or TIPO=''VENDA'')'+
                       ' 		 and EXTRACT(MONTH from DATA) = EXTRACT(MONTH from '+sData+' )'+
                       ' 		 and EXTRACT(YEAR from DATA) = EXTRACT(YEAR from '+sData+')'+
                       ' 	 Union All			'+
                       ' 	 Select '+
                       ' 		 MERCADORIA+SERVICOS-DESCONTO TOTAL '+
                       ' 	 From VENDAS '+
                       ' 	 Where EMITIDA=''S'' '+
                       ' 		 and EXTRACT(MONTH from EMISSAO) = EXTRACT(MONTH from '+sData+')'+
                       ' 	 	 and EXTRACT(YEAR from EMISSAO) = EXTRACT(YEAR from '+sData+')'+
                       FFiltroNatVendas+
                       ' 	 )';
    qryAux.Open;

    FVendasPeriodo[iPeriodo].VendasMes := qryAux.FieldByName('TOTAL').AsFloat;
  finally
    FreeAndNil(qryAux);
  end;
end;

procedure TRootDadosDTO.GetSaldoCaixa;
var
  qryAux: TIBQuery;
begin
  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(Sum(Coalesce(ENTRADA,0)) - Sum(Coalesce(SAIDA,0)) as numeric(18,2) ) SALDO'+
                        ' From CAIXA';
    qryAux.Open;

    FSaldoCaixa := qryAux.FieldByName('SALDO').AsFloat;
  finally
    FreeAndNil(qryAux);
  end;
end;


procedure TRootDadosDTO.GetVendasDiarias(iPeriodo:integer);
var
  qryAux: TIBQuery;
  VendasDiariasAr : TArray<TVendasDiarias>;
  i : integer;
  sData, sData2 : string;
begin
  sData := 'DATEADD(-'+iPeriodo.ToString+'  month TO CURRENT_DATE)';

  if iPeriodo = 0 then
    sData2 := 'CURRENT_DATE'
  else
    sData2 := 'DATEADD(0 - EXTRACT(DAY FROM CURRENT_DATE) DAY TO CURRENT_DATE )'; //�ltimo dia do m�s

  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text :=  ' WITH RECURSIVE DATAHORA AS('+
                        ' SELECT 1 AS id,'+
                        '    DATEADD(1 - EXTRACT(DAY FROM '+sData+') DAY TO '+sData+' ) tempo'+
                        ' FROM RDB$DATABASE'+
                        ' UNION ALL'+
                        ' SELECT '+
                        '  	DATAHORA.id +1 AS id,'+
                        '   DATEADD(+1 DAY TO DATAHORA.tempo) as tempo'+
                        ' FROM DATAHORA'+
                        ' WHERE DATAHORA.tempo < '+sData2+''+
                        ' )	'+
                        ' Select '+
                        '  	Extract(day from D.Tempo) DIA,'+
                        '  	Coalesce(V.TOTAL,0) VALOR'+
                        ' From DATAHORA D'+
                        '  	Left Join ( Select'+
                        ' 					DATA,'+
                        ' 					Coalesce(SUM( Cast( TOTAL as decimal(18,2)) ),0) TOTAL	'+
                        ' 				From	'+
                        ' 					(Select '+
                        ' 						 DATA,'+
                        ' 						 TOTAL		'+
                        ' 					From ALTERACA'+
                        ' 					Where (TIPO=''BALCAO'' or TIPO=''VENDA'')'+
                        ' 						 and EXTRACT(MONTH from DATA) = EXTRACT(MONTH from '+sData+')'+
                        ' 						 and EXTRACT(YEAR from DATA) = EXTRACT(YEAR from '+sData+')'+
                        ' 					Union All			'+
                        ' 					Select '+
                        ' 						 EMISSAO DATA,'+
                        ' 						 MERCADORIA+SERVICOS-DESCONTO TOTAL '+
                        ' 					From VENDAS '+
                        ' 					Where EMITIDA=''S'' '+
                        ' 						 and EXTRACT(MONTH from EMISSAO) = EXTRACT(MONTH from '+sData+')'+
                        ' 						 and EXTRACT(YEAR from EMISSAO) = EXTRACT(YEAR from '+sData+')'+
                        FFiltroNatVendas+
                        ' 					)'+
                        ' 				Group by'+
                        ' 					DATA'+
                        '  				) V on V.DATA = D.Tempo';
    qryAux.Open;

    i := 0;
    while not qryAux.Eof do
    begin
      SetLength(VendasDiariasAr,i+1);

      VendasDiariasAr[i] := TVendasDiarias.Create;
      VendasDiariasAr[i].Dia   := qryAux.FieldByName('DIA').AsString;
      VendasDiariasAr[i].Valor := qryAux.FieldByName('VALOR').AsFloat;

      inc(i);
      qryAux.Next;
    end;

    FVendasPeriodo[iPeriodo].VendasDiarias := VendasDiariasAr;
  finally
    FreeAndNil(qryAux);
  end;
end;

procedure TRootDadosDTO.GetVendasVendedor(iPeriodo:integer);
var
  qryAux: TIBQuery;
  VendasVendedorAr : TArray<TVendasVendedor>;
  i : integer;
  sData : string;
begin
  sData := 'DATEADD(-'+iPeriodo.ToString+'  month TO CURRENT_DATE)';

  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text :=  ' Select'+
                        ' 	VENDEDOR,'+
                        ' 	Coalesce(SUM( Cast( TOTAL as decimal(18,2) ) ),0)  TOTAL'+
                        ' From	'+
                        ' 	(Select '+
                        ' 		Coalesce(VENDEDOR,''N�o Informado'') VENDEDOR,'+
                        ' 		TOTAL'+
                        ' 	From ALTERACA'+
                        ' 	Where (TIPO=''BALCAO'' or TIPO=''VENDA'')'+
                        ' 		and EXTRACT(MONTH from DATA) = EXTRACT(MONTH from '+sData+')  '+
                        ' 		and EXTRACT(YEAR from DATA) = EXTRACT(YEAR from '+sData+')'+
                        ' 	Union All			'+
                        ' 	Select '+
                        ' 		Coalesce(VENDEDOR,''N�o Informado'') VENDEDOR, '+
                        ' 		MERCADORIA+SERVICOS-DESCONTO TOTAL '+
                        ' 	From VENDAS '+
                        ' 	Where EMITIDA=''S'' '+
                        ' 		and EXTRACT(MONTH from EMISSAO) = EXTRACT(MONTH from '+sData+')  '+
                        ' 		and EXTRACT(YEAR from EMISSAO) = EXTRACT(YEAR from '+sData+')'+
                        FFiltroNatVendas+
                        ' 	)'+
                        ' Group By'+
                        ' 	VENDEDOR'+
                        ' Order By 2 ';
    qryAux.Open;

    i := 0;
    while not qryAux.Eof do
    begin
      SetLength(VendasVendedorAr,i+1);

      VendasVendedorAr[i] := TVendasVendedor.Create;
      VendasVendedorAr[i].Vendedor := qryAux.FieldByName('VENDEDOR').AsString;
      VendasVendedorAr[i].Valor    := qryAux.FieldByName('TOTAL').AsFloat;

      inc(i);
      qryAux.Next;
    end;

    FVendasPeriodo[iPeriodo].VendasVendedor := VendasVendedorAr;
  finally
    FreeAndNil(qryAux);
  end;
end;

procedure TRootDadosDTO.setTransaction(Transaction: TIBTransaction);
begin
  FTransaction := Transaction;
end;

procedure TRootDadosDTO.GetVendasFormaPgto(iPeriodo:integer);
var
  qryAux: TIBQuery;
  VendasFormaPgtoAr : TArray<TVendasFormaPgto>;
  i : integer;
  sData : string;
begin
  sData := 'DATEADD(-'+iPeriodo.ToString+'  month TO CURRENT_DATE)';

  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text :=  ' Select'+
                        ' 	DESCRICAO,'+
                        ' 	IDFORMA,'+
                        ' 	Coalesce(SUM(VALOR),0) TOTAL'+
                        ' From	'+
                        ' 	(Select'+
                        ' 		F.DESCRICAO,'+
                        ' 		F.IDFORMA,'+
                        ' 		Coalesce(P.VALOR,0) VALOR'+
                        ' 	From NFCE N'+
                        ' 		Inner Join PAGAMENT P on (P.PEDIDO = N.NUMERONF) '+
                        '       and (P.CAIXA = N.CAIXA) and (P.DATA = N.DATA) '+
                        '       and (substring(FORMA from 1 for 2) <> ''00'')'+
                        ' 		Inner Join FORMAPAGAMENTO F on F.IDFORMA = Coalesce(P.IDFORMA,17) '+
                        ' 	Where (N.STATUS containing ''Autoriza'' '+
                        ' 			or N.STATUS containing ''Emitido com sucesso'' '+
                        ' 			or N.STATUS containing ''NFC-e emitida em modo de conting�ncia'' '+
                        ' 			or N.STATUS containing ''Finalizada - Aguardando Documento Fiscal'' '+
                        ' 			or N.STATUS containing ''Finalizada'' )'+
                        ' 		and (N.STATUS not containing ''Rejei'')'+
                        ' 		and coalesce(P.VALOR, 0) > 0'+
                        ' 		and EXTRACT(MONTH from N.DATA) = EXTRACT(MONTH from '+sData+')  '+
                        ' 		and EXTRACT(YEAR from N.DATA) = EXTRACT(YEAR from '+sData+')'+
                        ' 	Union All			'+
                        ' 	Select '+
                        ' 		Coalesce(F.DESCRICAO,''Outros'') DESCRICAO,'+
                        ' 		Coalesce(F.IDFORMA,17) IDFORMA,'+
                        ' 		SUM(COALESCE(COALESCE(R.VALOR_DUPL, P.VALOR), V.TOTAL)) AS TOTAL'+
                        ' 	From VENDAS V'+
                        ' 		Left Join RECEBER R on R.NUMERONF=V.NUMERONF'+
                        ' 		Left Join PAGAMENT P on P.DATA=V.EMISSAO and P.CLIFOR=V.CLIENTE and P.PEDIDO=(SUBSTRING(V.NUMERONF FROM 4 FOR 6))'+
                        ' 		Left Join FORMAPAGAMENTO F on F.DESCRICAO = TRIM(COALESCE(COALESCE(R.FORMADEPAGAMENTO, TRIM(REPLACE(REPLACE(SUBSTRING(P.FORMA FROM 4 FOR 30), ''NFC-e'', ''''), ''NF-e'', ''''))), ''Outros''))'+
                        ' 	Where EMITIDA=''S'' '+
                        ' 		and EXTRACT(MONTH from V.EMISSAO) = EXTRACT(MONTH from '+sData+')  '+
                        ' 		and EXTRACT(YEAR from V.EMISSAO) = EXTRACT(YEAR from '+sData+') '+
                        FFiltroNatVendas+
                        ' 	Group by'+
                        ' 		F.DESCRICAO,'+
                        ' 		Coalesce(F.IDFORMA,17)'+
                        ' 	)'+
                        ' Group By'+
                        ' 	DESCRICAO,'+
                        ' 	IDFORMA'+
                        ' Order By 3 desc ';
    qryAux.Open;

    i := 0;
    while not qryAux.Eof do
    begin
      SetLength(VendasFormaPgtoAr,i+1);

      VendasFormaPgtoAr[i] := TVendasFormaPgto.Create;
      VendasFormaPgtoAr[i].Descricao := qryAux.FieldByName('DESCRICAO').AsString;
      VendasFormaPgtoAr[i].IdForma   := qryAux.FieldByName('IDFORMA').AsInteger;
      VendasFormaPgtoAr[i].Valor     := qryAux.FieldByName('TOTAL').AsFloat;

      inc(i);
      qryAux.Next;
    end;

    FVendasPeriodo[iPeriodo].VendasFormaPgto := VendasFormaPgtoAr;
  finally
    FreeAndNil(qryAux);
  end;
end;


procedure TRootDadosDTO.GetInadimplencia;
var
  qryAux: TIBQuery;
begin
  try
    qryAux := CriaIBQuery(FTransaction);

    //3 Meses
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(sum(VALOR_DUPL) as numeric(18,2))as VALOR, '+
                        ' 	cast(sum(VALOR_RECE) as numeric(18,2))as RECE '+
                        ' From RECEBER '+
                        ' Where (VENCIMENTO>=(CURRENT_DATE-90)) and VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1';
    qryAux.Open;
    try
      FInadimplencia.Trimestre := 100-(qryAux.FieldByname('RECE').AsFloat/qryAux.FieldByname('VALOR').AsFloat)*100;
    except
    end;

    //12 Meses
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(sum(VALOR_DUPL)as numeric(18,2))as VALOR, '+
                        ' 	cast(sum(VALOR_RECE)as numeric(18,2))as RECE '+
                        ' From RECEBER '+
                        ' Where (VENCIMENTO>=(CURRENT_DATE-360)) and VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1';
    qryAux.Open;
    try
      FInadimplencia.Ano := 100-(qryAux.FieldByname('RECE').AsFloat/qryAux.FieldByname('VALOR').AsFloat)*100;
    except
    end;

    //Total
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select  '+
                        ' 	cast(sum(VALOR_DUPL)as numeric(18,2))as VALOR, '+
                        ' 	cast(sum(VALOR_RECE)as numeric(18,2))as RECE  '+
                        ' From RECEBER '+
                        ' Where VENCIMENTO<CURRENT_DATE and coalesce(ATIVO,9)<>1';
    qryAux.Open;
    try
      FInadimplencia.Total := 100-(qryAux.FieldByname('RECE').AsFloat/qryAux.FieldByname('VALOR').AsFloat)*100;
    except
    end;

  finally
    FreeAndNil(qryAux);
  end;
end;

procedure TRootDadosDTO.GetContasReceber;
var
  qryAux: TIBQuery;
begin
  try
    qryAux := CriaIBQuery(FTransaction);

    //Hoje
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR,'+
                        ' 	cast(Coalesce(sum(VALOR_RECE),0) as numeric(18,2))as RECE'+
                        ' From RECEBER'+
                        ' Where VENCIMENTO = CURRENT_DATE'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasReceber.ReceberDia   := qryAux.FieldByName('VALOR').AsFloat;
    FContasReceber.RecebidasDia := qryAux.FieldByName('RECE').AsFloat;

    //M�s
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR, '+
                        ' 	cast(Coalesce(sum(VALOR_RECE),0) as numeric(18,2))as RECE 	 '+
                        ' From RECEBER'+
                        ' Where EXTRACT(MONTH from VENCIMENTO) = EXTRACT(MONTH from CURRENT_DATE)  '+
                        ' 	and EXTRACT(YEAR from VENCIMENTO) = EXTRACT(YEAR from CURRENT_DATE)'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasReceber.ReceberMes   := qryAux.FieldByName('VALOR').AsFloat;
    FContasReceber.RecebidasMes := qryAux.FieldByName('RECE').AsFloat;

    //Vencidas
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	Count(*) QTD,'+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR'+
                        ' From RECEBER'+
                        ' Where Coalesce(VALOR_RECE,0) = 0 '+
                        ' 	and VENCIMENTO < CURRENT_DATE'+
                        ' 	and EXTRACT(MONTH from VENCIMENTO) = EXTRACT(MONTH from CURRENT_DATE)  '+
                        ' 	and EXTRACT(YEAR from VENCIMENTO) = EXTRACT(YEAR from CURRENT_DATE)		'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasReceber.VencidasMes      := qryAux.FieldByName('QTD').AsInteger;
    FContasReceber.ValorVencidasMes := qryAux.FieldByName('VALOR').AsFloat;
  finally
    FreeAndNil(qryAux);
  end;
end;


procedure TRootDadosDTO.GetDados;
begin
  GetVendasDia;
  GetSaldoCaixa;
  GetInadimplencia;
  GetContasReceber;
  GetContasPagar;
  GetContasBancarias;

  //M�s Atual
  FVendasPeriodo[0].Periodo := Trim(MesExtenso( Month(now)));
  GetVendasMes(0);
  GetVendasDiarias(0);
  GetVendasVendedor(0);
  GetVendasFormaPgto(0);

  //M�s Anterior
  FVendasPeriodo[1].Periodo := Trim(MesExtenso( Month( IncMonth(now,-1) ) ));
  GetVendasMes(1);
  GetVendasDiarias(1);
  GetVendasVendedor(1);
  GetVendasFormaPgto(1);
end;

procedure TRootDadosDTO.GetContasPagar;
var
  qryAux: TIBQuery;
begin
  try
    qryAux := CriaIBQuery(FTransaction);

    //Hoje
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR, '+
                        ' 	cast(Coalesce(sum(VALOR_PAGO),0) as numeric(18,2))as PAGO 	 '+
                        ' From PAGAR'+
                        ' Where VENCIMENTO = CURRENT_DATE'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasPagar.PagarDia := qryAux.FieldByName('VALOR').AsFloat;
    FContasPagar.PagasDia := qryAux.FieldByName('PAGO').AsFloat;

    //M�s
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR, '+
                        ' 	cast(Coalesce(sum(VALOR_PAGO),0) as numeric(18,2))as PAGO 	 '+
                        ' From PAGAR'+
                        ' Where EXTRACT(MONTH from VENCIMENTO) = EXTRACT(MONTH from CURRENT_DATE)  '+
                        ' 	and EXTRACT(YEAR from VENCIMENTO) = EXTRACT(YEAR from CURRENT_DATE)'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasPagar.PagarMes := qryAux.FieldByName('VALOR').AsFloat;
    FContasPagar.PagasMes := qryAux.FieldByName('PAGO').AsFloat;

    //Vencidas
    qryAux.Close;
    qryAux.SQL.Text :=  ' Select '+
                        ' 	Count(*) QTD,'+
                        ' 	cast(Coalesce(sum(VALOR_DUPL),0) as numeric(18,2))as VALOR'+
                        ' From PAGAR'+
                        ' Where Coalesce(VALOR_PAGO,0) = 0 '+
                        ' 	and VENCIMENTO < CURRENT_DATE'+
                        ' 	and EXTRACT(MONTH from VENCIMENTO) = EXTRACT(MONTH from CURRENT_DATE)  '+
                        ' 	and EXTRACT(YEAR from VENCIMENTO) = EXTRACT(YEAR from CURRENT_DATE)		'+
                        ' 	and coalesce(ATIVO,9)<>1';
    qryAux.Open;

    FContasPagar.VencidasMes      := qryAux.FieldByName('QTD').AsInteger;
    FContasPagar.ValorVencidasMes := qryAux.FieldByName('VALOR').AsFloat;
  finally
    FreeAndNil(qryAux);
  end;
end;


procedure TRootDadosDTO.GetContasBancarias;
var
  qryAux: TIBQuery;
  ContasBancariasAr : TArray<TContasBancarias>;
  i : integer;
begin
  try
    qryAux := CriaIBQuery(FTransaction);
    qryAux.SQL.Text :=  ' Select '+
                        ' 	NOME,'+
                        ' 	Coalesce(SALDO3,0) SALDO '+
                        ' From BANCOS';
    qryAux.Open;

    i := 0;
    while not qryAux.Eof do
    begin
      SetLength(ContasBancariasAr,i+1);

      ContasBancariasAr[i] := TContasBancarias.Create;
      ContasBancariasAr[i].Descricao := qryAux.FieldByName('NOME').AsString;
      ContasBancariasAr[i].Valor     := qryAux.FieldByName('SALDO').AsFloat;

      inc(i);
      qryAux.Next;
    end;

    FContasBancarias := ContasBancariasAr;
  finally
    FreeAndNil(qryAux);
  end;
end;




end.
