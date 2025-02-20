unit uSectionFrentedeCaixaINI;

interface

uses
  uSectionDATPadrao;

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

end.
