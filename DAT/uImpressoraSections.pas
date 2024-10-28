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

    function getImpressoraOrcamento: string;
    procedure setImpressoraOrcamento(const Value: string);
    function getFormatoOrcamento: string;
    procedure setFormatoOrcamento(const Value: string);
  public
    property ImpressoraOS: string read getImpressoraOS write setImpressoraOS;
    property ImpressoraOrcamento: string read getImpressoraOrcamento write setImpressoraOrcamento;
    property FormatoOrcamento: string read getFormatoOrcamento write setFormatoOrcamento;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionImpressora }


function TSectionImpressora.getFormatoOrcamento: string;
begin
  Result := getValorBD(_cFormatoOrcamento);

  if Result = '' then
    Result := '80mm';
end;

function TSectionImpressora.getImpressoraOrcamento: string;
begin
  Result := getValorBD(_cIpressoraOrcamento);

  if Result = '' then
    Result := 'HTML';
end;

function TSectionImpressora.getImpressoraOS: string;
begin
  Result := getValorBD(_cIpressoraOS);

  if Result = '' then
    Result := 'HTML';
end;

procedure TSectionImpressora.setFormatoOrcamento(const Value: string);
begin
  setValorBD(_cFormatoOrcamento,
             'Formato de Impress�o do Or�amento',
             Value);
end;

procedure TSectionImpressora.setImpressoraOrcamento(const Value: string);
begin
  setValorBD(_cIpressoraOrcamento,
             'Impress�o do Or�amento',
             Value);
end;

procedure TSectionImpressora.setImpressoraOS(const Value: string);
begin
  setValorBD(_cIpressoraOS,
             'Impress�o da Ordem de Servi�o',
             Value);
end;

end.
