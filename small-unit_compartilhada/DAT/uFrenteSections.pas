unit uFrenteSections;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionFrentedeCaixa = class(TSectionDATPadrao)
  private
    function getTipoEtiqueta: String;
    procedure setTipoEtiqueta(const Value: String);
  public
    property TipoEtiqueta: String read getTipoEtiqueta write setTipoEtiqueta;
  protected
    function Section: String; override;
  end;

type
  TSectionOrcamento = class(TSectionDATPadrao)
  private
    function getPorta: tTipoImpressaoOrcamento;
    procedure setPorta(const Value: tTipoImpressaoOrcamento);
  public
    property Porta: tTipoImpressaoOrcamento read getPorta write setPorta;
  protected
    function Section: String; override;
  end;


implementation

uses SysUtils, uSmallConsts;

{ TSectionFrentedeCaixa }

function TSectionFrentedeCaixa.getTipoEtiqueta: String;
begin
  Result := FoIni.ReadString(Section, _cIdentFrenteCaixaTipoEtiqueta, 'KG');
end;

function TSectionFrentedeCaixa.Section: String;
begin
  Result := _cSectionFrenteCaixa;
end;

procedure TSectionFrentedeCaixa.setTipoEtiqueta(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentFrenteCaixaTipoEtiqueta, Value);
end;

{ TSectionOrcamento }

function TSectionOrcamento.getPorta: tTipoImpressaoOrcamento;
var
  cPorta: string;
begin
  //Result := ttioPadraoWindows; Mauricio Parizotto 2024-06-06
  Result := ttioHTML;

  //cPorta := FoIni.ReadString(Section, _cIdentPorta, _cImpressoraPadrao); Mauricio Parizotto 2024-06-06
  cPorta := FoIni.ReadString(Section, _cIdentPorta, 'HTML');

  if cPorta = 'HTML' then
    Result := ttioHTML;
  if cPorta = 'PDF' then
    Result := ttioPDF;
  if cPorta = 'TXT' then
    Result := ttioTXT;
  if cPorta = _cImpressoraPadrao then
    Result := ttioPadraoWindows;
end;

function TSectionOrcamento.Section: String;
begin
  Result := _cSectionOrcamento;
end;

procedure TSectionOrcamento.setPorta(const Value: tTipoImpressaoOrcamento);
var
  cPorta: string;
begin
  case Value of
    ttioPDF: cPorta := 'PDF';
    ttioHTML: cPorta := 'HTML';
    ttioTXT: cPorta := 'TXT';
    else cPorta := _cImpressoraPadrao;
  end;

  FoIni.WriteString(Section, _cIdentPorta, cPorta);
end;

end.
