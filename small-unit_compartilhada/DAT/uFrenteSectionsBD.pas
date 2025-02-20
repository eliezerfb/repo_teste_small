unit uFrenteSectionsBD;

interface

uses
  uSectionDATPadrao
  ;

type
  TSectionFrenteBD = class(TSectionBD)
  private
    function getTransmitirContingenciaAbertura: Boolean;
    procedure setTransmitirContingenciaAbertura(const Value: Boolean);
  public
    property TransmitirContingenciaAbertura: Boolean read getTransmitirContingenciaAbertura write setTransmitirContingenciaAbertura;
  protected
  end;

implementation

uses uSmallConsts;

{ TSectionOS }

function TSectionFrenteBD.getTransmitirContingenciaAbertura: Boolean;
var
  cValor: String;
begin
  // Necessário esse tratamento para que retorne como TRUE quando não tem registro
  Result :=  False;
  cValor := getValorBD(_cTransmiteContingenciaAbertura);
  if cValor <> '0' then
    Result :=  True;

end;

procedure TSectionFrenteBD.setTransmitirContingenciaAbertura(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cTransmiteContingenciaAbertura,
             'Trasmitir Contingência na Abertura (NFC-e)',
             valorBD);
end;

end.
