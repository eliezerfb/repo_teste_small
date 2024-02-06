unit uOutrasSections;

interface

uses
  uSectionDATPadrao
  ;

type
  TSectionOutras = class(TSectionBD)
  private
    function getLogSistema: Boolean;
    procedure setLogSistema(const Value: Boolean);
    function getFabricaProdutoSemQtd: Boolean;
    procedure setFabricaProdutoSemQtd(const Value: Boolean);
  public
    property LogSistema: Boolean read getLogSistema write setLogSistema;
    property FabricaProdutoSemQtd: Boolean read getFabricaProdutoSemQtd write setFabricaProdutoSemQtd;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionOutras }

function TSectionOutras.getFabricaProdutoSemQtd: Boolean;
begin
  Result := getValorBD(_cFabricaProdSemQtd) = '1';
end;

function TSectionOutras.getLogSistema: Boolean;
begin
  Result := getValorBD(_cOutrasLog) = '1';
end;

procedure TSectionOutras.setFabricaProdutoSemQtd(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cFabricaProdSemQtd,
             'Fabricação de produtos com quantidade insuficiente',
             valorBD);

end;

procedure TSectionOutras.setLogSistema(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cOutrasLog,
             'Ativa a geração de logs no sistema',
             valorBD);
end;

end.
