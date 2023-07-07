unit uSectionOutrosUsuarioINF;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionOutrosUsuario = class(TSectionDATPadrao)
  private
    function getPeriodoInicial: TDateTime;
    procedure setPeriodoInicial(const Value: TDateTime);
    function getPeriodoFinal: TDateTime;
    procedure setPeriodoFinal(const Value: TDateTime);
  public
    property PeriodoInicial: TDateTime read getPeriodoInicial write setPeriodoInicial;
    property PeriodoFinal: TDateTime read getPeriodoFinal write setPeriodoFinal;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts, IniFiles;

{ TSectionOutrosUsuario }

function TSectionOutrosUsuario.getPeriodoFinal: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentPeriodoFinal, DateToStr(Date)));
end;

function TSectionOutrosUsuario.getPeriodoInicial: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentPeriodoInicial, DateToStr(Date-360)));
end;

function TSectionOutrosUsuario.Section: String;
begin
  Result := _cSectionOutros;
end;

procedure TSectionOutrosUsuario.setPeriodoFinal(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentPeriodoFinal, DateToStr(Value));
end;

procedure TSectionOutrosUsuario.setPeriodoInicial(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentPeriodoInicial, DateToStr(Value));
end;

end.
