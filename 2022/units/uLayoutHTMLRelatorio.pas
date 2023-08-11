unit uLayoutHTMLRelatorio;

interface

uses
  SmallFunc, uSmallEnumerados;

type
  TLayoutHTMLRelatorio = class
  private
  public
    class function RetornarCabecalho(AcNomeEstabelecimento: String): String;
    class function RetornarRodape(AcMunicipio, AcHP, AcTempoGeracaoRel: String; AenTipoRelatorio: tTipoRelatorio): String;
  end;

implementation

uses
  SysUtils;

{ TLayoutHTMLRelatorio }

class function TLayoutHTMLRelatorio.RetornarCabecalho(AcNomeEstabelecimento: String): String;
begin
  Result := '<html><head><title>'+AllTrim(AcNomeEstabelecimento) + '</title></head>' +
            '<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>' +
            '<img src="logotip.jpg" alt="'+AllTrim(AcNomeEstabelecimento)+'">' +
            '<br><font size=3 color=#000000><b>'+AllTrim(AcNomeEstabelecimento)+'</b></font>';
end;

class function TLayoutHTMLRelatorio.RetornarRodape(AcMunicipio, AcHP, AcTempoGeracaoRel: String; AenTipoRelatorio: tTipoRelatorio): String;
var
  cDataExtenso: String;
begin
  cDataExtenso := Copy(DateTimeToStr(Date),1,2) + ' de '
                    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time);
                    
  Result := '<center><br><font face="Microsoft Sans Serif" size=1>Gerado em ' + Trim(AcMunicipio) + ', ' + cDataExtenso+'</font><br>';

  if (Alltrim(AcHP) = EmptyStr) then
  begin
    Result := Result + '<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>';
  end else
  begin
    Result := Result + '<font face="verdana" size=1><center><a href="http://' + AcHP + '">' + AcHP + '</a><font>';
  end;

  Result := Result + '<font face="Microsoft Sans Serif" size=1><center>Tempo para gerar este relatório: ' + AcTempoGeracaoRel + '</center>';
  if AenTipoRelatorio = ttiHTML then
    Result := Result + '<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>';

  Result := Result + '</html>';
end;

end.
