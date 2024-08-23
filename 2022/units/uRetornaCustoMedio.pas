unit uRetornaCustoMedio;

interface

uses
  uIRetornaCustoMedio, IBX.IBDatabase, IBX.IBQuery, System.SysUtils,
  System.StrUtils;

type
  TRetornaCustoMedio = class(TInterfacedObject, IRetornaCustoMedio)
  private
    FqryDados: TIBQuery;
    FcCodigo: String;
    FoTransaction: TIBTransaction;
    FnDecimais: Integer;
  public
    class function New: IRetornaCustoMedio;
    destructor Destroy; override;
    function setCodigo(AcCodigo: String): IRetornaCustoMedio;
    function setDecimaisCusto(AnDecimais: Integer): IRetornaCustoMedio;
    function setTransaction(AoTransaction: TIBTransaction): IRetornaCustoMedio;
    function ConsultaDados: IRetornaCustoMedio;
    function CustoMedio: Double;
  end;

implementation

uses
  uFuncoesBancoDados, smallfunc_xe;

{ TRetornaCustoMedio }

class function TRetornaCustoMedio.New: IRetornaCustoMedio;
begin
  Result := Self.Create;
end;

function TRetornaCustoMedio.setCodigo(AcCodigo: String): IRetornaCustoMedio;
begin
  Result := Self;

  FcCodigo := AcCodigo;
end;

function TRetornaCustoMedio.setDecimaisCusto(AnDecimais: Integer): IRetornaCustoMedio;
begin
  Result := Self;

  FnDecimais := AnDecimais;
end;

function TRetornaCustoMedio.setTransaction(AoTransaction: TIBTransaction): IRetornaCustoMedio;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

function TRetornaCustoMedio.ConsultaDados: IRetornaCustoMedio;
begin
  Result := Self;

  FqryDados := CriaIBQuery(FoTransaction);

  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('select');
  FqryDados.SQL.Add('    ITENS002.QUANTIDADE');
  FqryDados.SQL.Add('    , ESTOQUE.QTD_ATUAL');
  FqryDados.SQL.Add('    , coalesce(ITENS002.CUSTO, ITENS002.UNITARIO) as CUSTO');
  FqryDados.SQL.Add('    , coalesce(ITENS002.VICMS,0) as VICMS');
  FqryDados.SQL.Add('from ITENS002');
  FqryDados.SQL.Add('inner join COMPRAS');
  FqryDados.SQL.Add('    on (COMPRAS.NUMERONF=ITENS002.NUMERONF)');
  FqryDados.SQL.Add('    and (COMPRAS.FORNECEDOR=ITENS002.FORNECEDOR)');
  FqryDados.SQL.Add('inner join ESTOQUE');
  FqryDados.SQL.Add('    on (ESTOQUE.CODIGO=ITENS002.CODIGO)');
  FqryDados.SQL.Add('where');
  FqryDados.SQL.Add('    (ITENS002.CODIGO=:XCODIGO)');
  FqryDados.SQL.Add('order by COMPRAS.SAIDAD, COMPRAS.SAIDAH');
  FqryDados.ParamByName('XCODIGO').AsString := FcCodigo;
  FqryDados.Open;

  FqryDados.First;
end;

function TRetornaCustoMedio.CustoMedio: Double;
var
  nQuantidade: Currency;
begin
  // Fórmula do custo médio                                                                        //
  // * Primeiro                                                                                    //
  //    (Custo da primeira compra - (VICMS / Quantidade))                                          //
  // * Depois                                                                                      //
  //    Custo Médio = (( Quantidade Atual * Custo Médio ) +                                        //
  //                  ( Quantidade comprada * ( Custo Compra - (VICMS / Quantidade comprada)))     //
  //                  / (Quantidade comprada + Quantidade Atual)                                   //
  //                                                                                               //
  // Obs: O Custo Médio é a média ponderada entre o custo da mercadoria                            //
  // comprada menos o crédito de ICMS e o custo da mercadoria em estoque.                          //

  Result := 0;

  while not FqryDados.Eof do
  begin
    nQuantidade := FqryDados.FieldByName('QUANTIDADE').AsFloat;

    if Result = 0 then
    begin
      Result := FqryDados.FieldByName('CUSTO').AsFloat - (FqryDados.FieldByName('VICMS').AsFloat / nQuantidade);
    end else
    begin
      Result := ((FqryDados.FieldByName('QTD_ATUAL').AsFloat * Result) +
                (nQuantidade * (FqryDados.FieldByName('CUSTO').AsFloat - (FqryDados.FieldByName('VICMS').AsFloat / nQuantidade)))) /
                (nQuantidade + FqryDados.FieldByName('QTD_ATUAL').AsFloat);
    end;
    FqryDados.Next;
  end;

  if AnsiContainsText(Result.ToString, 'INF') then
    Result := 0;

  Result := Arredonda(Result, FnDecimais);
end;

destructor TRetornaCustoMedio.Destroy;
begin
  if Assigned(FqryDados) then
    FreeAndNil(FqryDados);

  inherited;
end;

end.
