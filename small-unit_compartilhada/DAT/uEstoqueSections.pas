unit uEstoqueSections;

interface

uses
  uSectionDATPadrao;

type
  TSectionGeral = class(TSectionDATPadrao)
  private
    function getRede: String;
    function getBuild: String;
    procedure setRede(const Value: String);
    procedure setBuild(const Value: String);
    function getBuild2020: String;
    procedure setBuild2020(const Value: String);
  public
    property Rede: String read getRede write setRede;
    property Build2020: String read getBuild2020 write setBuild2020;
    property Build: String read getBuild write setBuild;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionGeral }

function TSectionGeral.getBuild: String;
begin
  Result := FoIni.ReadString(Section, _cIdentGeralBuild2023, '2023.0.0.0');
end;

function TSectionGeral.getBuild2020: String;
begin
  Result := FoIni.ReadString(Section, _cIdentGeralBuild2020, '2020.0.0.0');
end;

function TSectionGeral.getRede: String;
begin
  Result := FoIni.ReadString(Section, _cIdentGeralRede, _cOKUpper);
end;

function TSectionGeral.Section: String;
begin
  Result := _cSectionGeral;
end;

procedure TSectionGeral.setBuild(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentGeralBuild2023, Value);
end;

procedure TSectionGeral.setBuild2020(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentGeralBuild2020, Value);
end;

procedure TSectionGeral.setRede(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentGeralRede, Value);
end;

end.
