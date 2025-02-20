unit uUsuarioSections;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionGeral = class(TSectionDATPadrao)
  private
    function getMarketplaceAtivo: Boolean;
    procedure setMarketplaceAtivo(const Value: Boolean);
    function getMobileAtivo: Boolean;
    procedure setMobileAtivo(const Value: Boolean);
  public
    property MarketplaceAtivo: Boolean read getMarketplaceAtivo write setMarketplaceAtivo;
    property MobileAtivo: Boolean read getMobileAtivo write setMobileAtivo;
  protected
    function Section: String; override;
  end;

  TSectionHTML = class(TSectionDATPadrao)
  private
    function getTipoRelatorio: tTipoRelatorio;
    procedure setTipoRelatorio(const Value: tTipoRelatorio);
    function getCor: String;
    procedure setCor(const Value: String);
  public
    property TipoRelatorio: tTipoRelatorio read getTipoRelatorio write setTipoRelatorio;
    property Cor: String Read getCor write setCor;
  protected
    function Section: String; override;
  end;

  TSectionOutros = class(TSectionDATPadrao)
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

uses SysUtils, uSmallConsts;

{ TSectionGeral }

function TSectionGeral.getMarketplaceAtivo: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentGeralUsuMarketPlaceAtivo, _cNao) = _cSim);
end;

function TSectionGeral.getMobileAtivo: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentGeralUsuMobileAtivo, _cNao) = _cSim);
end;

function TSectionGeral.Section: String;
begin
  Result := _cSectionGeralUsuario;
end;

procedure TSectionGeral.setMarketplaceAtivo(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;

  FoIni.WriteString(Section, _cIdentGeralUsuMarketPlaceAtivo, cValor);
end;

procedure TSectionGeral.setMobileAtivo(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;

  FoIni.WriteString(Section, _cIdentGeralUsuMobileAtivo, cValor);
end;

{ TSectionHTMLUsuario }

function TSectionHTML.getCor: String;
begin
  Result := FoIni.ReadString(Section, _cIdentHtmlCor, 'EBEBEB');

  Result := Copy(Result,5,2)+
            Copy(Result,3,2)+
            Copy(Result,1,2);
end;

function TSectionHTML.getTipoRelatorio: tTipoRelatorio;
begin
  Result := tTipoRelatorio(FoIni.ReadInteger(Section, _cIdentHtmlHtml1, 1));
end;

function TSectionHTML.Section: String;
begin
  Result := _cSectionHtml;
end;

procedure TSectionHTML.setCor(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentHtmlCor, Value);
end;

procedure TSectionHTML.setTipoRelatorio(const Value: tTipoRelatorio);
begin
  FoIni.WriteInteger(Section, _cIdentHtmlHtml1, Ord(Value));
end;

{ TSectionOutrosUsuario }

function TSectionOutros.getPeriodoFinal: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentPeriodoFinal, DateToStr(Date)));
end;

function TSectionOutros.getPeriodoInicial: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentPeriodoInicial, DateToStr(Date-360)));
end;

function TSectionOutros.Section: String;
begin
  Result := _cSectionOutros;
end;

procedure TSectionOutros.setPeriodoFinal(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentPeriodoFinal, DateToStr(Value));
end;

procedure TSectionOutros.setPeriodoInicial(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentPeriodoInicial, DateToStr(Value));
end;

end.
