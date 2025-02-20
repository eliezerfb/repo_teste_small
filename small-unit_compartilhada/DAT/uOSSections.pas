unit uOSSections;

interface

uses
  uSectionDATPadrao
  ;

type
  TSectionOS = class(TSectionBD)
  private
    function getObservacaoOS: string;
    function getObservacaoReciboOS: string;
    procedure setObservacaoOS(const Value: string);
    procedure setObservacaoReciboOS(const Value: string);
  public
    property ObservacaoOS: string read getObservacaoOS write setObservacaoOS;
    property ObservacaoReciboOS: string read getObservacaoReciboOS write setObservacaoReciboOS;
  protected
  end;

implementation

uses uSmallConsts;

{ TSectionOS }


function TSectionOS.getObservacaoOS: string;
begin
  Result := getValorBD(_cOSObservacao);
end;

function TSectionOS.getObservacaoReciboOS: string;
begin
  Result := getValorBD(_cOSObservacaoRecibo);
end;

procedure TSectionOS.setObservacaoOS(const Value: string);
begin
  setValorBD(_cOSObservacao,
             'Observa��o da Ordem de Servi�o',
             Value);
end;

procedure TSectionOS.setObservacaoReciboOS(const Value: string);
begin
  setValorBD(_cOSObservacaoRecibo,
             'Observa��o do Recibo da Ordem de Servi�o',
             Value);
end;


end.
