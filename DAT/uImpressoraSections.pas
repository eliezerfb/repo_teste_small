unit uImpressoraSections;

interface

uses
  uSectionDATPadrao, System.SysUtils
  ;

type
  TSectionImpressora = class(TSectionBD)
  private
    function getImpressoraOS: string;
    procedure setImpressoraOS(const Value: string);
  public
    property ImpressoraOS: string read getImpressoraOS write setImpressoraOS;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionImpressora }


function TSectionImpressora.getImpressoraOS: string;
begin
  Result := getValorBD(_cIpressoraOS);

  if Result = '' then
    Result := 'HTML';
end;

procedure TSectionImpressora.setImpressoraOS(const Value: string);
begin
  setValorBD(_cIpressoraOS,
             'Impressão da Ordem de Serviço',
             Value);
end;

end.
