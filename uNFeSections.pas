unit uNFeSections;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFE = class(TSectionDATPadrao)
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
    function getEnvioAutomatico: Boolean;
    procedure setEnvioAutomatico(const Value: Boolean);
    function getNFeSaida: Boolean;
    procedure setNFeSaida(const Value: Boolean);
    function getNFeEntrada: Boolean;
    procedure setNFeEntrada(const Value: Boolean);
    function getNFCe: Boolean;
    procedure setNFCe(const Value: Boolean);
    function getDataUltimoEnvio: TDateTime;
    procedure setDataUltimoEnvio(const Value: TDateTime);
  public
    property PeriodoInicial: TDateTime read getPeriodoInicial write setPeriodoInicial;
    property PeriodoFinal: TDateTime read getPeriodoFinal write setPeriodoFinal;
    property EmailContabilidade: String read getEmailContabilidade write setEmailContabilidade;
    property EnvioAutomatico: Boolean read getEnvioAutomatico write setEnvioAutomatico;
    property NFeSaida: Boolean read getNFeSaida write setNFeSaida;
    property NFeEntrada: Boolean read getNFeEntrada write setNFeEntrada;
    property NFCe: Boolean read getNFCe write setNFCe;
    property DataUltimoEnvio: TDateTime read getDataUltimoEnvio write setDataUltimoEnvio;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts, IniFiles;

{ TSectionNFE }

function TSectionNFE.AmbienteStrToEnum(AcAmbiente: String): tAmbienteNFe;
begin
  Result := tanfHomologacao;
  if AcAmbiente = _cAmbienteProducao then
    Result := tanfProducao;
end;

function TSectionNFE.AmbienteToStr(AenAmbiente: tAmbienteNFe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfProducao then
    Result := _cAmbienteProducao;
end;

function TSectionNFE.getAmbiente: tAmbienteNFe;
begin
  Result := tanfHomologacao;

  if AnsiUpperCase(FoIni.ReadString(Section, _cIdentNFEAmbiente, _cAmbienteHomologacao)) = AnsiUpperCase(_cAmbienteProducao) then
    Result := tanfProducao;
end;

function TSectionNFE.Section: String;
begin
  Result := _cSectionNFE;
end;

procedure TSectionNFE.setAmbiente(const Value: tAmbienteNFe);
var
  cAmbiente: String;
begin
  cAmbiente := _cAmbienteHomologacao;
  if Value = tanfProducao then
    cAmbiente := _cAmbienteProducao;

  FoIni.WriteString(Section, _cIdentNFEAmbiente, cAmbiente);
end;

{ TSectionXML }

function TSectionXML.getDataUltimoEnvio: TDateTime;
begin
  Result := FoIni.ReadDate(Section, _cIdentDataUltimoEnvio, 0);
end;

function TSectionXML.getEmailContabilidade: String;
begin
  Result := FoIni.ReadString(Section, _cIdentXMLEmailContabilidade, EmptyStr);
end;

function TSectionXML.getEnvioAutomatico: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentEnvioAutomatico, _cNao) = _cSim);
end;

function TSectionXML.getNFCe: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentNFCe, _cNao) = _cSim);
end;

function TSectionXML.getNFeEntrada: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentNFeEntrada, _cNao) = _cSim);
end;

function TSectionXML.getNFeSaida: Boolean;
begin
  Result := (FoIni.ReadString(Section, _cIdentNFeSaida, _cNao) = _cSim);
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

procedure TSectionXML.setDataUltimoEnvio(const Value: TDateTime);
begin
  FoIni.WriteDate(Section, _cIdentDataUltimoEnvio, Value);
end;

procedure TSectionXML.setEmailContabilidade(const Value: String);
begin
  FoIni.WriteString(Section, _cIdentXMLEmailContabilidade, Value);
end;

procedure TSectionXML.setEnvioAutomatico(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;
  FoIni.WriteString(Section, _cIdentEnvioAutomatico, cValor);
end;

procedure TSectionXML.setNFCe(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;
  FoIni.WriteString(Section, _cIdentNFCe, cValor);
end;

procedure TSectionXML.setNFeEntrada(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;
  FoIni.WriteString(Section, _cIdentNFeEntrada, cValor);
end;

procedure TSectionXML.setNFeSaida(const Value: Boolean);
var
  cValor: String;
begin
  cValor := _cNao;
  if Value then
    cValor := _cSim;
  FoIni.WriteString(Section, _cIdentNFeSaida, cValor);
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
