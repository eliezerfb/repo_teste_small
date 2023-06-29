unit uSectionHTMLUsuarioINF;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionHTMLUsuario = class(TSectionDATPadrao)
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

implementation

uses SysUtils, uSmallConsts, IniFiles;

{ TSectionHTMLUsuario }

function TSectionHTMLUsuario.getCor: String;
begin
  Result := FoIni.ReadString(Section, _cIdentHtmlCor, 'EBEBEB');

  Result := Copy(Result,5,2)+
            Copy(Result,3,2)+
            Copy(Result,1,2);
end;

function TSectionHTMLUsuario.getTipoRelatorio: tTipoRelatorio;
begin
  Result := tTipoRelatorio(FoIni.ReadInteger(Section, _cIdentHtmlHtml1, 1));
end;

function TSectionHTMLUsuario.Section: String;
begin
  Result := _cSectionHtml;
end;

procedure TSectionHTMLUsuario.setCor(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentHtmlCor, Value);
end;

procedure TSectionHTMLUsuario.setTipoRelatorio(const Value: tTipoRelatorio);
begin
  FoIni.WriteInteger(Section, _cIdentHtmlHtml1, Ord(Value));
end;

end.
