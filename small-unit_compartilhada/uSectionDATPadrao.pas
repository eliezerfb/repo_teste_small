unit uSectionDATPadrao;

interface

uses
  IniFiles;

type
  TSectionDATPadrao = class
  private
  public
    constructor Create(AoArqIni: TIniFile);
  protected
    FoIni: TIniFile;
    function Section: String; virtual; abstract;
  end;

implementation

{ TSectionDATPadrao }

constructor TSectionDATPadrao.Create(AoArqIni: TIniFile);
begin
  FoIni := AoArqIni;
end;

end.
