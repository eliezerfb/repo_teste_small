unit uSectionsNFeINI;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFEINI = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFe;
    procedure setAmbiente(const Value: tAmbienteNFe);
  public
    property Ambiente: tAmbienteNFe read getAmbiente write setAmbiente;
    function AmbienteToStr(AenAmbiente: tAmbienteNFe): String;
    function AmbienteStrToEnum(AcAmbiente: String): tAmbienteNFe;
  protected
    function Section: String; override;
  end;

  TSectionXML = class(TSectionDATPadrao)
  private
    function getPeriodoInicial: TDateTime;
    procedure setPeriodoInicial(const Value: TDateTime);
    function getPeriodoFinal: TDateTime;
    procedure setPeriodoFinal(const Value: TDateTime);
    function getEmailContabilidade: String;
    procedure setEmailContabilidade(const Value: String);
  public
    property PeriodoInicial: TDateTime read getPeriodoInicial write setPeriodoInicial;
    property PeriodoFinal: TDateTime read getPeriodoFinal write setPeriodoFinal;
    property EmailContabilidade: String read getEmailContabilidade write setEmailContabilidade;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionNFE }

function TSectionNFEINI.AmbienteStrToEnum(AcAmbiente: String): tAmbienteNFe;
begin
  Result := tanfHomologacao;
  if AcAmbiente = _cAmbienteProducao then
    Result := tanfProducao;
end;

function TSectionNFEINI.AmbienteToStr(AenAmbiente: tAmbienteNFe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfProducao then
    Result := _cAmbienteProducao;
end;

function TSectionNFEINI.getAmbiente: tAmbienteNFe;
begin
  Result := tanfHomologacao;

  if AnsiUpperCase(FoIni.ReadString(Section, _cIdentNFEAmbiente, _cAmbienteHomologacao)) = AnsiUpperCase(_cAmbienteProducao) then
    Result := tanfProducao;
end;

function TSectionNFEINI.Section: String;
begin
  Result := _cSectionNFE;
end;

procedure TSectionNFEINI.setAmbiente(const Value: tAmbienteNFe);
var
  cAmbiente: String;
begin
  cAmbiente := _cAmbienteHomologacao;
  if Value = tanfProducao then
    cAmbiente := _cAmbienteProducao;

  FoIni.WriteString(Section, _cIdentNFEAmbiente, cAmbiente);
end;

{ TSectionXML }

function TSectionXML.getEmailContabilidade: String;
begin
  Result := FoIni.ReadString(Section, _cIdentXMLEmailContabilidade, EmptyStr);
end;

function TSectionXML.getPeriodoFinal: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentXMLPeriodoFinal, DateToStr(Date)));
end;

function TSectionXML.getPeriodoInicial: TDateTime;
begin
  Result := StrToDate(FoIni.ReadString(Section, _cIdentXMLPeriodoInicial, DateToStr(Date-30)));
end;

function TSectionXML.Section: String;
begin
  Result := _cSectionXML;
end;

procedure TSectionXML.setEmailContabilidade(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentXMLEmailContabilidade, Value);
end;

procedure TSectionXML.setPeriodoFinal(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentXMLPeriodoFinal, DateToStr(Value));
end;

procedure TSectionXML.setPeriodoInicial(const Value: TDateTime);
begin
  FoIni.WriteString(Section, _cIdentXMLPeriodoInicial, DateToStr(Value));
end;

end.
