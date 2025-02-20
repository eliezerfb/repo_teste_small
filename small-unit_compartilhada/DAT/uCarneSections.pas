unit uCarneSections;

interface

uses
  uSectionDATPadrao
  , System.SysUtils
  , StrUtils
  ;

type
  TSectionCarne = class(TSectionBD)
  private
    function getCarnePIX: Boolean;
    procedure setCarnePIX(const Value: Boolean);
    function getBancoPIX: string;
    procedure setBancoPIX(const Value: string);
  public
    property CarnePIX: Boolean read getCarnePIX write setCarnePIX;
    property BancoPIX: string read getBancoPIX write setBancoPIX;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionImpressora }


function TSectionCarne.getBancoPIX: string;
begin
  Result := getValorBD(_cCarneBancoPIX);
end;

function TSectionCarne.getCarnePIX: Boolean;
begin
  Result := getValorBD(_cCarnePIX) = 'Sim';
end;

procedure TSectionCarne.setBancoPIX(const Value: string);
begin
  setValorBD(_cCarneBancoPIX,
             'Banco para gerar QR Code Pix no Carnê',
             Value);
end;

procedure TSectionCarne.setCarnePIX(const Value: Boolean);
begin
  setValorBD(_cCarnePIX,
             'Habilita QR Code Pix no Carnê',
             IfThen(Value,'Sim','Não'));
end;

end.
