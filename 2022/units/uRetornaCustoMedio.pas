unit uRetornaCustoMedio;

interface

uses
  uIRetornaCustoMedio, IBX.IBDatabase, IBX.IBQuery, System.SysUtils,
  System.StrUtils, System.Classes;

type
  TRetornaCustoMedio = class(TInterfacedObject, IRetornaCustoMedio)
  private
    FqryDados: TIBQuery;
    FcCodigo: String;
    FoTransaction: TIBTransaction;
    FnDecimais: Integer;
    function RetornaCustoCompraNota: Double;
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
  FqryDados.SQL.Add('    , ESTOQUE.CUSTOCOMPR AS CUSTO');
  FqryDados.SQL.Add('    , coalesce(ITENS002.CUSTO, ITENS002.UNITARIO) as CUSTONOTA');
  FqryDados.SQL.Add('    , coalesce(ITENS002.VICMS,0) as VICMS');
  FqryDados.SQL.Add('    , ITENS002.UNITARIO');
  FqryDados.SQL.Add('    , ITENS002.VICMSST');
  FqryDados.SQL.Add('    , ITENS002.VIPI');
  FqryDados.SQL.Add('    , ITENS002.VFCPST');
  FqryDados.SQL.Add('    , ITENS002.QUANTIDADE');
  FqryDados.SQL.Add('    , COMPRAS.MERCADORIA');
  FqryDados.SQL.Add('    , COMPRAS.FRETE');
  FqryDados.SQL.Add('    , COMPRAS.SEGURO');
  FqryDados.SQL.Add('    , COMPRAS.DESPESAS');
  FqryDados.SQL.Add('    , COMPRAS.DESCONTO');
  FqryDados.SQL.Add('    , ICM.INTEGRACAO');
  FqryDados.SQL.Add('from ITENS002');
  FqryDados.SQL.Add('inner join COMPRAS');
  FqryDados.SQL.Add('    on (COMPRAS.NUMERONF=ITENS002.NUMERONF)');
  FqryDados.SQL.Add('    and (COMPRAS.FORNECEDOR=ITENS002.FORNECEDOR)');
  FqryDados.SQL.Add('inner join ESTOQUE');
  FqryDados.SQL.Add('    on (ESTOQUE.CODIGO=ITENS002.CODIGO)');
  FqryDados.SQL.Add('inner join ICM');
  FqryDados.SQL.Add('    on (ICM.NOME=COMPRAS.OPERACAO)');
  FqryDados.SQL.Add('where');
  FqryDados.SQL.Add('    (ITENS002.CODIGO=:XCODIGO)');
  FqryDados.SQL.Add('order by COMPRAS.EMISSAO, COMPRAS.SAIDAH');
  FqryDados.ParamByName('XCODIGO').AsString := FcCodigo;
  FqryDados.Open;

  FqryDados.First;
end;

function TRetornaCustoMedio.CustoMedio: Double;
var
  nQuantidade: Currency;
  nCustoCompra: Double;
  nVICMS: Double;
  nSaldoAtual: Currency;  // Saldo do momento da nota
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

  Result      := 0;
  nSaldoAtual := 0;

  while not FqryDados.Eof do
  begin
    if (AnsiContainsText(AnsiUpperCase(FqryDados.FieldByName('INTEGRACAO').AsString),'PAGAR'))
      or (AnsiContainsText(AnsiUpperCase(FqryDados.FieldByName('INTEGRACAO').AsString),'CAIXA')) then
    begin
      nQuantidade  := FqryDados.FieldByName('QUANTIDADE').AsFloat;
      nCustoCompra := FqryDados.FieldByName('CUSTO').AsFloat;
      nVICMS       := FqryDados.FieldByName('VICMS').AsFloat;

      if Result = 0 then
      begin
        nCustoCompra := FqryDados.FieldByName('UNITARIO').AsFloat;
        Result := nCustoCompra - (nVICMS / nQuantidade)
      end else
      begin

        nCustoCompra := RetornaCustoCompraNota;

        Result := ((nSaldoAtual * Result) +
                  (nQuantidade * (nCustoCompra - (nVICMS / nQuantidade)))) /
                  (nQuantidade + nSaldoAtual);
      end;
      nSaldoAtual := nSaldoAtual + nQuantidade;
    end;

    FqryDados.Next;
  end;

  if AnsiContainsText(Result.ToString, 'INF') then
    Result := 0;

  Result := Arredonda(Result, FnDecimais);
end;

function TRetornaCustoMedio.RetornaCustoCompraNota: Double;
begin
  //Se alterar aqui, alerar sql da tela FrmPrecificacaoProduto e Unit24
  Result := (FqryDados.FieldByName('UNITARIO').AsFloat + ((FqryDados.FieldByName('VICMSST').AsFloat + FqryDados.FieldByName('VIPI').AsFloat + FqryDados.FieldByName('VFCPST').AsFloat)/FqryDados.FieldByName('QUANTIDADE').AsFloat) ) // Unitário + ICMSST + IPI + FCP ST
                                        + (( FqryDados.FieldByName('UNITARIO').AsFloat     // Rateio   //
                                           / FqryDados.FieldByName('MERCADORIA').AsFloat ) * //          //
                                          ( FqryDados.FieldByName('FRETE').AsFloat +         // o frete  //
                                             FqryDados.FieldByName('SEGURO').AsFloat +       // o seguro //
                                             FqryDados.FieldByName('DESPESAS').AsFloat -     // outras   //
                                             FqryDados.FieldByName('DESCONTO').AsFloat       // desconto //
                                          ));
end;

destructor TRetornaCustoMedio.Destroy;
begin
  if Assigned(FqryDados) then
    FreeAndNil(FqryDados);

  inherited;
end;

end.
