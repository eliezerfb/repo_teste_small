unit uNFSeSections;

interface

uses
  uSectionDATPadrao, uSmallEnumerados
  , REST.Json.Types, REST.Json
  , uListaToJson
  ;

type
  TSectionNFSE = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFSe;
    procedure setAmbiente(const Value: tAmbienteNFSe);
  public
    function AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
    property Ambiente: tAmbienteNFSe read getAmbiente write setAmbiente;
  protected
    function Section: String; override;
  end;

  TSectionInformacoesObtidasNaPrefeitura = class(TSectionDATPadrao)
  private
    function getPadraoProvedor: String;
  public
    property PadraoProvedor: String read getPadraoProvedor;
  protected
    function Section: String; override;
  end;

type

  TSectionNFSeCertificado_BD = class(TSectionBD)
  private
    procedure SetSSLLib(Value: String);
    function GetSSLLib: String;
    function GetHttpLib: String;
    procedure SetHttpLib(Value: String);
    function GetXmlSignLib: String;
    procedure SetXmlSignLib(Value: String);
    function GetNumSerie: String;
    procedure SetNumSerie(const Value: String);
    function GetNomeCertificado: String;
    procedure SetNomeCertificado(const Value: String);
    function GetCryptLib: String;
    procedure SetCryptLib(Value: String);
  public
    property SSLLib: String read GetSSLLib write SetSSLLib;
    property CryptLib: String read GetCryptLib write SetCryptLib;
    property HttpLib: String read GetHttpLib write SetHttpLib;
    property XmlSignLib: String read GetXmlSignLib write SetXmlSignLib;
    property NumSerie: String read GetNumSerie write SetNumSerie;
    property NomeCertificado: String read GetNomeCertificado write SetNomeCertificado;
  protected
  end;

  TSectionNFSeWebService_BD = class(TSectionBD)
  private
    function GetSSLType: String;
    procedure SetSSLType(Value: String);
    function GetSenhaWeb: String;
    procedure SetSenhaWeb(const Value: String);
    function GetUserWeb: String;
    procedure SetUserWeb(const Value: String);
    function GetFraseSecWeb: String;
    procedure SetFraseSecWeb(const Value: String);
    function GetChAcessoWeb: String;
    procedure SetChAcessoWeb(const Value: String);
    function GetChAutorizWeb: String;
    procedure SetChAutorizWeb(const Value: String);
    function GetAmbiente: String;
    procedure SetAmbiente(Value: String);
  public
    property SSLType: String read GetSSLType write SetSSLType;
    property SenhaWeb: String read GetSenhaWeb write SetSenhaWeb;
    property UserWeb: String read GetUserWeb write SetUserWeb;
    property FraseSecWeb: String read GetFraseSecWeb write SetFraseSecWeb;
    property ChAcessoWeb: String read GetChAcessoWeb write SetChAcessoWeb;
    property ChAutorizWeb: String read GetChAutorizWeb write SetChAutorizWeb;
    property Ambiente: String read GetAmbiente write SetAmbiente;
  protected
  end;

  TSectionNFSeInformacoesObtidasNaPrefeitura_BD = class(TSectionBD)
  private
    FParametros: TParametros;
    function getParametros: TParametros;
    procedure SetInformacoes(const Value: TParametros);
  public
    property Informacoes: TParametros read getParametros write SetInformacoes;
  protected
  end;

  TSectionNFSE_BD = class(TSectionBD)
  private
    FSectionNFSeCertificado_BD: TSectionNFSeCertificado_BD;
    FSectionNFSeWebService_BD: TSectionNFSeWebService_BD;
    FInformacoesObtidasPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD;
    function getObsNaDescricao: Boolean;
    function getConfObsNaDescricao: string;
    procedure setObsNaDescricao(const Value: Boolean);
    function getCalculoDoDescontoPeloProvedor: string;
    procedure setCalculoDoDescontoPeloProvedor(const Value: string);
    function getNaoDescontarIssQuandoRetido: String;
    procedure SetNaoDescontarIssQuandoRetido(const Value: String);
    function GetLayoutNFSe: String;
    procedure SetLayoutNFSe(Value: String);
    function GetPadrao: String;
    procedure SetPadrao(const Value: String);
    function GetSectionNFSeCertificado_BD: TSectionNFSeCertificado_BD;
    function GetSectionNFSeWebService_BD: TSectionNFSeWebService_BD;
    function getNFSeInformacoesObtidasNaPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD;
  public
    property ObsNaDescricao: Boolean read getObsNaDescricao write setObsNaDescricao;
    property ConfObsNaDescricao: string read getConfObsNaDescricao;
    property CalculoDoDescontoPeloProvedor: string read getCalculoDoDescontoPeloProvedor write setCalculoDoDescontoPeloProvedor;
    property NaoDescontarIssQuandoRetido: String read getNaoDescontarIssQuandoRetido write SetNaoDescontarIssQuandoRetido;
    property LayoutNFSe: String read GetLayoutNFSe write SetLayoutNFSe;
    property Padrao: String read GetPadrao write SetPadrao;
    property Certificado: TSectionNFSeCertificado_BD read GetSectionNFSeCertificado_BD;
    property WebService: TSectionNFSeWebService_BD read GetSectionNFSeWebService_BD;
    property InformacoesObtidasPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD read getNFSeInformacoesObtidasNaPrefeitura;
  protected
  end;


implementation

uses
  SysUtils, uSmallConsts
  ;

{ TSectionNFEINI }

function TSectionNFSE.getAmbiente: tAmbienteNFSe;
begin
  Result := tAmbienteNFSe(FoIni.ReadInteger(Section, _cIdentNFSEAmbiente, Ord(tanfsHomologacao)));
end;

function TSectionNFSE.Section: String;
begin
  Result := _cSectionNFSE;
end;

procedure TSectionNFSE.setAmbiente(const Value: tAmbienteNFSe);
begin
  FoIni.WriteInteger(Section, _cIdentNFEAmbiente, Ord(Value));
end;

function TSectionNFSE.AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfsProducao then
    Result := _cAmbienteProducao;
end;

{ TSectionInformacoesObtidasNaPrefeitura }

function TSectionInformacoesObtidasNaPrefeitura.Section: String;
begin
  Result := _cSectionNFSE_InformacoesObtidasPrefeitura;
end;

function TSectionInformacoesObtidasNaPrefeitura.getPadraoProvedor: String;
begin
  Result := FoIni.ReadString(_cSectionNFSE_InformacoesObtidasPrefeitura, _cIdentiPadraoCidade, '');
end;

{ TSectionNFSE_BD }

function TSectionNFSE_BD.getCalculoDoDescontoPeloProvedor: string;
begin
  Result := getValorBD(_cCalculoDoDescontoPeloProvedor);
end;

function TSectionNFSE_BD.getConfObsNaDescricao: string;
begin
  Result := getValorBD(_cObsNaDescricaoNFSE);
end;

function TSectionNFSE_BD.GetLayoutNFSe: String;
begin
  Result := getValorBD(_cNFSeLayoutNFSe);
  if Result = '' then
    Result := '0';
end;

function TSectionNFSE_BD.getNaoDescontarIssQuandoRetido: String;
begin
  Result := getValorBD(_cNaoDescontarIssQuandoRetido);
end;

function TSectionNFSE_BD.getNFSeInformacoesObtidasNaPrefeitura: TSectionNFSeInformacoesObtidasNaPrefeitura_BD;
begin
  if not Assigned(FInformacoesObtidasPrefeitura) then
    FInformacoesObtidasPrefeitura := TSectionNFSeInformacoesObtidasNaPrefeitura_BD.Create(Transaction, _cSectionNFSeInformacoesObtidasNaPrefeitura);

  Result := FInformacoesObtidasPrefeitura;
end;

function TSectionNFSE_BD.getObsNaDescricao: Boolean;
begin
  Result := getValorBD(_cObsNaDescricaoNFSE) = '1';
end;

function TSectionNFSE_BD.GetPadrao: String;
begin
  Result := getValorBD(_cIdentiPadraoCidade);
end;

function TSectionNFSE_BD.GetSectionNFSeCertificado_BD: TSectionNFSeCertificado_BD;
begin
  if FSectionNFSeCertificado_BD = nil then
    FSectionNFSeCertificado_BD := TSectionNFSeCertificado_BD.Create(Transaction, _cSectionNFSeCertificado);
  Result := FSectionNFSeCertificado_BD;
end;

function TSectionNFSE_BD.GetSectionNFSeWebService_BD: TSectionNFSeWebService_BD;
begin
  if FSectionNFSeWebService_BD = nil then
    FSectionNFSeWebService_BD := TSectionNFSeWebService_BD.Create(Transaction, _cSectionNFSeWebService);
  Result := FSectionNFSeWebService_BD;
end;

procedure TSectionNFSE_BD.setCalculoDoDescontoPeloProvedor(const Value: string);
begin
  setValorBD(_cCalculoDoDescontoPeloProvedor,
             'Algumas prefeitura calculam o desconto ao autorizarem a NFSe',
             Value);
end;

procedure TSectionNFSE_BD.SetLayoutNFSe(Value: String);
begin
  if Value = '' then
    Value := '0';
  setValorBD(_cNFSeLayoutNFSe, 'Layout da NFS-e', Value);
end;

procedure TSectionNFSE_BD.SetNaoDescontarIssQuandoRetido(const Value: String);
begin
  setValorBD(_cNaoDescontarIssQuandoRetido,
             'Algumas prefeituras não descontam o valor do ISS quando é retido',
             Value);
end;

procedure TSectionNFSE_BD.setObsNaDescricao(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cObsNaDescricaoNFSE,
             'Gera observa  o junto com a descri  o dos servi os',
             valorBD);

end;

procedure TSectionNFSE_BD.SetPadrao(const Value: String);
begin
  setValorBD(_cIdentiPadraoCidade, 'Padrão', Value);
end;

{ TSectionNFSeCertificado_BD }

function TSectionNFSeCertificado_BD.GetCryptLib: String;
begin
  Result := getValorBD(_cCertificadoNFSeCryptLib);
  if Result = '' then
    Result := '3';
end;

function TSectionNFSeCertificado_BD.GetHttpLib: String;
begin
  Result := getValorBD(_cCertificadoNFSeHttpLib);
  if Result = '' then
    Result := '2';
end;

function TSectionNFSeCertificado_BD.GetNomeCertificado: String;
begin
  Result := getValorBD(_cCertificadoNFSeNomeCertificado);
end;

function TSectionNFSeCertificado_BD.GetNumSerie: String;
begin
  Result := getValorBD(_cCertificadoNFSeNumSerie);
end;

function TSectionNFSeCertificado_BD.GetSSLLib: String;
begin
  try
    Result := getValorBD(_cCertificadoNFSeSSLLib);
  except

  end;
  if Result = '' then
    Result := '4';
end;

function TSectionNFSeCertificado_BD.GetXmlSignLib: String;
begin
  Result := getValorBD(_cCertificadoNFSeXmlSignLib);
  if Result = '' then
    Result := '0';
end;

procedure TSectionNFSeCertificado_BD.SetCryptLib(Value: String);
begin
  if Value = '' then
    Value := '3';
  setValorBD(_cCertificadoNFSeCryptLib, 'CryptLib', Value);
end;

procedure TSectionNFSeCertificado_BD.SetHttpLib(Value: String);
begin
  if Value = '' then
    Value := '2';
  setValorBD(_cCertificadoNFSeHttpLib, 'HttpLib', Value);
end;

procedure TSectionNFSeCertificado_BD.SetNomeCertificado(const Value: String);
begin
  setValorBD(_cCertificadoNFSeNomeCertificado, 'Nome do certificado', Value);
end;

procedure TSectionNFSeCertificado_BD.SetNumSerie(const Value: String);
begin
  setValorBD(_cCertificadoNFSeNumSerie, 'Número de série do certificado', Value);
end;

procedure TSectionNFSeCertificado_BD.SetSSLLib(Value: String);
begin
  if Value = '' then
    Value := '4';
  setValorBD(_cCertificadoNFSeSSLLib, 'SSLLib', Value);
end;

procedure TSectionNFSeCertificado_BD.SetXmlSignLib(Value: String);
begin
  if Value = '' then
    Value := '0';
  setValorBD(_cCertificadoNFSeXmlSignLib, 'XmlSignLib', Value);
end;

{ TSectionNFSeWebService_BD }

function TSectionNFSeWebService_BD.GetAmbiente: String;
begin
  Result := getValorBD(_cWebServiceNFSeAmbiente);
  if Result = '' then
    Result := '2';
end;

function TSectionNFSeWebService_BD.GetChAcessoWeb: String;
begin
  Result := getValorBD(_cWebServiceNFSeChAcessoWeb);
end;

function TSectionNFSeWebService_BD.GetChAutorizWeb: String;
begin
  Result := getValorBD(_cWebServiceNFSeChAutorizWeb);
end;

function TSectionNFSeWebService_BD.GetFraseSecWeb: String;
begin
  Result := getValorBD(_cWebServiceNFSeFraseSecWeb);
end;

function TSectionNFSeWebService_BD.GetSenhaWeb: String;
begin
  Result := getValorBD(_cWebServiceNFSeSenhaWeb);
end;

function TSectionNFSeWebService_BD.GetSSLType: String;
begin
  Result := getValorBD(_cWebServiceNFSeSSLType);
  if Result = '' then
    Result := '5';
end;

function TSectionNFSeWebService_BD.GetUserWeb: String;
begin
  Result := getValorBD(_cWebServiceNFSeUserWeb);
end;

procedure TSectionNFSeWebService_BD.SetAmbiente(Value: String);
begin
  if Value = '' then
    Value := '2';
  setValorBD(_cWebServiceNFSeAmbiente, 'Ambiente da NFSe', Value);
end;

procedure TSectionNFSeWebService_BD.SetChAcessoWeb(const Value: String);
begin
  setValorBD(_cWebServiceNFSeChAcessoWeb, 'Chave de Acesso', Value);
end;

procedure TSectionNFSeWebService_BD.SetChAutorizWeb(const Value: String);
begin
  setValorBD(_cWebServiceNFSeChAutorizWeb, 'Chave de Autorização', Value);
end;

procedure TSectionNFSeWebService_BD.SetFraseSecWeb(const Value: String);
begin
  setValorBD(_cWebServiceNFSeFraseSecWeb, 'Frase Secreta', Value);
end;

procedure TSectionNFSeWebService_BD.SetSenhaWeb(const Value: String);
begin
  setValorBD(_cWebServiceNFSeSenhaWeb, 'Senha', Value);
end;

procedure TSectionNFSeWebService_BD.SetSSLType(Value: String);
begin
  if Value = '' then
    Value := '5';
  setValorBD(_cWebServiceNFSeSSLType, 'SSLType', Value);
end;

procedure TSectionNFSeWebService_BD.SetUserWeb(const Value: String);
begin
  setValorBD(_cWebServiceNFSeUserWeb, 'Usuário', Value);
end;

{ TSectionNFSeInformacoesObtidasNaPrefeitura_BD }

function TSectionNFSeInformacoesObtidasNaPrefeitura_BD.getParametros: TParametros;
begin
  Result := TJson.JsonToObject<TParametros>(getValorBD(_cInformacoesObtidasNaPrefeitura));
end;

procedure TSectionNFSeInformacoesObtidasNaPrefeitura_BD.SetInformacoes(
  const Value: TParametros);
begin
  setValorBD(_cInformacoesObtidasNaPrefeitura, _cSectionNFSeInformacoesObtidasNaPrefeitura, Value.Json);
end;

end.
