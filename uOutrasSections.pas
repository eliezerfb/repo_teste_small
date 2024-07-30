unit uOutrasSections;

interface

uses
  uSectionDATPadrao, System.SysUtils
  ;

type
  TSectionOutras = class(TSectionBD)
  private
    function getLogSistema: Boolean;
    procedure setLogSistema(const Value: Boolean);
    function getFabricaProdutoSemQtd: Boolean;
    procedure setFabricaProdutoSemQtd(const Value: Boolean);
    function getTipoPrazo: string;
    procedure setTipoPrazo(const Value: string);
    function getDiaVencimento: integer;
    procedure setDiaVencimento(const Value: integer);
    function getTemaIcones: string;
    procedure setTemaIcones(const Value: string);
  public
    property LogSistema: Boolean read getLogSistema write setLogSistema;
    property FabricaProdutoSemQtd: Boolean read getFabricaProdutoSemQtd write setFabricaProdutoSemQtd;
    property TipoPrazo: string read getTipoPrazo write setTipoPrazo;
    property DiaVencimento: integer read getDiaVencimento write setDiaVencimento;
    property TemaIcones: string read getTemaIcones write setTemaIcones;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionOutras }

function TSectionOutras.getDiaVencimento: integer;
begin
  Result := StrToIntDef(getValorBD(_cDiaVencimento),1);
end;

function TSectionOutras.getFabricaProdutoSemQtd: Boolean;
begin
  Result := getValorBD(_cFabricaProdSemQtd) = '1';
end;

function TSectionOutras.getLogSistema: Boolean;
begin
  Result := getValorBD(_cOutrasLog) = '1';
end;

function TSectionOutras.getTemaIcones: string;
begin
  Result := getValorBD(_cTemaIcones);
end;

function TSectionOutras.getTipoPrazo: string;
begin
  Result := getValorBD(_cTipoPrazo);

  if Result = '' then
    Result := 'dias';
end;

procedure TSectionOutras.setDiaVencimento(const Value: integer);
begin
  setValorBD(_cDiaVencimento,
           'Dia fixo para vencimento das parcelas',
           Value.ToString);
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

procedure TSectionOutras.setTemaIcones(const Value: string);
begin
  setValorBD(_cTemaIcones,
             'Tema usado para ícones do sistema',
             Value);
end;

procedure TSectionOutras.setTipoPrazo(const Value: string);
begin
  setValorBD(_cTipoPrazo,
             'Tipo do prazo para recebimento (dias,fixo)',
             Value);
end;

end.
