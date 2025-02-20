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
    function getCalculaLucroAltVenda: Boolean;
    procedure setCalculaLucroAltVenda(const Value: Boolean);
    function getPermiteImportarMesmoOrc: Boolean;
    procedure setPermiteImportarMesmoOrc(const Value: Boolean);
    function getRecalculaCustoMedioRetroativo: Boolean;
    procedure setRecalculaCustoMedioRetroativo(const Value: Boolean);
    function getOcultaUsoConsumoVenda: Boolean;
    procedure setOcultaUsoConsumoVenda(const Value: Boolean);
    function getPermiteDuplicarCNPJ: Boolean;
    procedure setPermiteDuplicarCNPJ(const Value: Boolean);
  public
    property LogSistema: Boolean read getLogSistema write setLogSistema;
    property FabricaProdutoSemQtd: Boolean read getFabricaProdutoSemQtd write setFabricaProdutoSemQtd;
    property TipoPrazo: string read getTipoPrazo write setTipoPrazo;
    property DiaVencimento: integer read getDiaVencimento write setDiaVencimento;
    property TemaIcones: string read getTemaIcones write setTemaIcones;
    property CalculaLucroAltVenda: Boolean read getCalculaLucroAltVenda write setCalculaLucroAltVenda;
    property PermiteImportarMesmoOrc: Boolean read getPermiteImportarMesmoOrc write setPermiteImportarMesmoOrc; //Mauricio Parizotto 2024-08-26
    property RecalculaCustoMedioRetroativo: Boolean read getRecalculaCustoMedioRetroativo write setRecalculaCustoMedioRetroativo; //Dailon Parisotto 2024-09-02
    property OcultaUsoConsumoVenda: Boolean read getOcultaUsoConsumoVenda write setOcultaUsoConsumoVenda;
    property PermiteDuplicarCNPJ: Boolean read getPermiteDuplicarCNPJ write setPermiteDuplicarCNPJ;
  protected
  end;


implementation

uses uSmallConsts;

{ TSectionOutras }

function TSectionOutras.getCalculaLucroAltVenda: Boolean;
begin
  Result := getValorBD(_cCalculaLucroAltVenda) = '1';
end;

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

function TSectionOutras.getOcultaUsoConsumoVenda: Boolean;
begin
  Result := getValorBD(_OcultaUsoConsumoVenda) = '1';
end;

function TSectionOutras.getPermiteDuplicarCNPJ: Boolean;
begin
  var Value := UpperCase(Trim(getValorBD(_PermiteDuplicarCNPJ)));
  Result := (Value = 'SIM') or (Value = 'S') or (Value = '1');
end;

function TSectionOutras.getPermiteImportarMesmoOrc: Boolean;
begin
  Result := getValorBD(_PermiteImportaMesmoOrc) = 'Sim';
end;

function TSectionOutras.getRecalculaCustoMedioRetroativo: Boolean;
begin
  Result := getValorBD(_RecalculaCustoMedioRetroativo) = 'Sim';
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

procedure TSectionOutras.setCalculaLucroAltVenda(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cCalculaLucroAltVenda,
           'Cálculo do Lucro ao alterar Preço de venda no estoque',
           valorBD);
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

procedure TSectionOutras.setOcultaUsoConsumoVenda(const Value: Boolean);
begin
  setValorBD(
    _OcultaUsoConsumoVenda,
    'Oculta Uso Consumo na Venda',
    Value.ToInteger.ToString
  );
end;

procedure TSectionOutras.setPermiteDuplicarCNPJ(const Value: Boolean);
begin
  var YesNo := 'NAO';
  if Value then
    YesNo := 'SIM';

  setValorBD(_PermiteDuplicarCNPJ, 'Permite duplicar CNPJ no cadastro', YesNO);
end;

procedure TSectionOutras.setPermiteImportarMesmoOrc(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := 'Sim'
  else
    valorBD := 'Não';

  setValorBD(_PermiteImportaMesmoOrc,
             'Permite importar mesmo orçamento múltiplas vezes no cupom',
             valorBD);
end;

procedure TSectionOutras.setRecalculaCustoMedioRetroativo(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := 'Sim'
  else
    valorBD := 'Não';

  setValorBD(_RecalculaCustoMedioRetroativo,
             'Recalcular custo médio retroativo',
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
