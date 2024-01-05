unit uRetornaSQLGerencialInventario;

interface

uses
  uIRetornaSQLGerencialInventario
  {Sandro Silva 2024-01-03 inicio
  smallfunc_xe
  }
  {$IFDEF VER150}
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  {Sandro Silva 2024-01-03 fim}
  ;

type
  TRetornaSQLGerencialInventario = class(TInterfacedObject, IRetornaSQLGerencialInventario)
  private
    FbData: TDateTime;
  public
    class function New: IRetornaSQLGerencialInventario;
    function setData(AdData: TDateTime): IRetornaSQLGerencialInventario;
    function getSQL: String;
  end;

implementation

uses
  Classes, SysUtils;

{ TRetornaQueryGerencialInventario }

function TRetornaSQLGerencialInventario.getSQL: String;
var
  slSql: TStringList;
begin
  slSql := TStringList.Create;
  try
    slSql.Add('Select');
    slSql.Add('Sum(A.QUANTIDADE) vQTD_GERENCIAL');
    slSql.Add(',A.CODIGO');
    slSql.Add(',A.DESCRICAO');
    slSql.Add('From NFCE N');
    slSql.Add('Join ALTERACA A on (A.PEDIDO = N.NUMERONF) and (A.CAIXA = N.CAIXA)');
    slSql.Add('Where N.DATA <= ' + QuotedStr(DateToStrInvertida(FbData)));
    slSql.Add('and Coalesce(N.MODELO,'''') = ''99''');
    slSql.Add('and coalesce(A.VALORICM,''0'')= ''0''');
    slSql.Add('and (A.TIPO = ''BALCAO'' or TIPO = ''VENDA'')');
    slSql.Add('and Coalesce(A.CODIGO,'''') <> ''''');
    slSql.Add('and Coalesce(N.STATUS,'''') containing ''Finalizada''');
    slSql.Add('Group by A.CODIGO,A.DESCRICAO');

    Result := slSql.Text; 
  finally
    FreeAndNil(slSql);
  end;
end;

class function TRetornaSQLGerencialInventario.New: IRetornaSQLGerencialInventario;
begin
  Result := Self.Create;
end;

function TRetornaSQLGerencialInventario.setData(AdData: TDateTime): IRetornaSQLGerencialInventario;
begin
  Result := Self;
  
  FbData := AdData;
end;

end.
