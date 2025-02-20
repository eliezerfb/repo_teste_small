unit uIMendesSections;

interface

uses
  uSectionDATPadrao
  , System.SysUtils
  , StrUtils
  ;

type
  TSectionIMendes = class(TSectionBD)
  private
    function getConsultarIPI: Boolean;
    procedure setConsultarIPI(const Value: Boolean);
    function getFaixaFaturamento: string;
    procedure setFaixaFaturamento(const Value: string);
  public
    property ConsultarIPI: Boolean read getConsultarIPI write setConsultarIPI;
    property FaixaFaturamento: string read getFaixaFaturamento write setFaixaFaturamento;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionImpressora }


function TSectionIMendes.getConsultarIPI: Boolean;
begin
  Result := getValorBD(_cConsultaIPI) = 'Sim';
end;

function TSectionIMendes.getFaixaFaturamento: string;
begin
  Result := getValorBD(_cFaixaFaturameto);
end;

procedure TSectionIMendes.setConsultarIPI(const Value: Boolean);
begin
  setValorBD(_cConsultaIPI,
             'Consular IPI no IMendes',
             IfThen(Value,'Sim','Não'));
end;

procedure TSectionIMendes.setFaixaFaturamento(const Value: string);
begin
  setValorBD(_cFaixaFaturameto,
             'Faixa de faturamento para IMendes',
             Value);
end;

end.
