unit uSectionUsoINF;

interface

uses
  uSectionDATPadrao;

type
  TSectionUso = class(TSectionDATPadrao)
  private
    function getUso: String;
    procedure setUso(const Value: String);
  public
    property Uso: String read getUso write setUso; 
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionUso }

function TSectionUso.getUso: String;
begin
  Result := FoIni.ReadString(Section, _cIdentUso, '1');
end;

function TSectionUso.Section: String;
begin
  Result := _cSectionUso;
end;

procedure TSectionUso.setUso(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentUso, Value);
end;

end.
