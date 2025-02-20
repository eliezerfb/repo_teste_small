unit uDashboardSections;

interface

uses
  uSectionDATPadrao
  , System.SysUtils
  ;

type
  TSectionDashboar = class(TSectionBD)
  private
    function getAberturaSistema: Boolean;
    procedure setAberturaSistema(const Value: Boolean);
    function getNaturezasVenda : string;
    procedure setNaturezasVenda(const Value: string);
  public
    property AberturaSistema: Boolean read getAberturaSistema write setAberturaSistema;
    property NaturezasVenda: string read getNaturezasVenda write setNaturezasVenda;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionOutras }


function TSectionDashboar.getAberturaSistema: Boolean;
begin
  Result := getValorBD(_DashAbertura) <> _cNao;
end;


function TSectionDashboar.getNaturezasVenda: string;
begin
  Result := getValorBD(_DashNaturezas);
end;

procedure TSectionDashboar.setAberturaSistema(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := _cSim
  else
    valorBD := _cNao;

  setValorBD(_DashAbertura,
             'Exibe dashboard na abertura do sistema',
             valorBD);
end;



procedure TSectionDashboar.setNaturezasVenda(const Value: string);
begin
  setValorBD(_DashNaturezas,
             'Filtro de naturezas de venda dashboard',
             Value);

end;

end.
