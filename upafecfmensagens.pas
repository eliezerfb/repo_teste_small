{ *********************************************************************** }
{ Comunicação com webservice do blocox na SEFAZ                           }
{ Autor: Sandro Luis da Silva                                             }
{                                                                         }
{ Inicialmente eram webservices diferentes para cada serviço. Foi criado  }
{ uma classe para cada webservice. Posteriormente a especificação mudou   }
{ foi definido um único webservice com serviços distintos, foi alterado   }
{ a estrutura dos xml. Devido a falta de tempo as classes foram somente   }
{ adaptadas para a nova especificação. No futuro as classes devem ser     }
{ refatoradas para uma melhor clareza e compreensão                       }
{                                                                         }
{ *********************************************************************** }

unit upafecfmensagens;

interface

uses Classes, CAPICOM_TLB, MSXML2_TLB, ActiveX, ComObj, SysUtils, Dialogs,
  SmallFunc, Windows, Forms
  , base64code, SynZip, usmallwebservice //FileCtrl
  , MD5
  ,ufuncoesfrente // Sandro Silva 2018-07-03 
  ;

const P_DLLNAME = 'dll_1.DLL';
const PASTA_REDUCOES_BLOCO_X                  = 'c:\BlocoX\Arquivos com Informações da Redução Z';
const PASTA_ESTOQUE_BLOCO_X                   = 'c:\BlocoX\Arquivos com Informações do Estoque';
const PASTA_RECIBOS_REDUCOES_BLOCO_X          = 'c:\BlocoX\Recibos - Bloco X\Redução Z'; // Sandro Silva 2019-06-21 ER 02.06 'c:\BlocoX\Recibos dos Arquivos com Informações da Redução Z do PAF-ECF';
const PASTA_RECIBOS_ESTOQUE_BLOCO_X           = 'c:\BlocoX\Recibos - Bloco X\Estoque Mensal'; // Sandro Silva 2019-06-21 ER 02.06 'c:\BlocoX\Recibos dos Arquivos com Informações do Estoque Mensal do Estabelecimento';
const PASTA_VALIDACAO_BLOCO_X                 = 'c:\BlocoX\Validacao';
const PREFIXO_ALERTA_ARQUIVOS_RZ_BLOCO_X      = 'Arquivos com Informações da Redução Z do PAF-ECF';
const PREFIXO_ALERTA_ARQUIVOS_ESTOQUE_BLOCO_X = 'Arquivos com Informações do Estoque Mensal do Estabelecimento';
const PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X         = 'Redução Z '; // Sandro Silva 2019-06-21 ER 02.06 'ARQUIVO COM INFORMACOES DA REDUCAO DO PAF-ECF RZ_';
const PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X    = 'Estoque Mensal '; // Sandro Silva 2019-06-21 ER 02.06 'ARQUIVO COM INFORMACOES DO ESTOQUE MENSAL DO ESTABELECIMENTO estoque_';
const PREFIXO_ARQUIVOS_RECIBO_REDUCAO_BLOCO_X = 'RECIBO_REDUCAO_';
const PREFIXO_ARQUIVOS_RECIBO_ESTOQUE_BLOCO_X = 'RECIBO_ESTOQUE_';

const BLOCOX_ESPECIFICACAO_XML                    = '<?xml version="1.0" encoding="utf-8" ?>'; // Sandro Silva 2017-04-28
const BLOCOX_VERSAO_LEIAUTE                       = '1.0'; // Sandro Silva 2017-04-28
const SITUACAO_TRIBUTARIA_ISENTO                  = 'Isento';
const SITUACAO_TRIBUTARIA_NAO_TRIBUTADO           = 'Nao tributado';
const SITUACAO_TRIBUTARIA_SUBSTITUICAO_TRIBUTARIA = 'Substituicao tributaria';
const SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ICMS     = 'Tributado pelo ICMS';
const SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ISSQN    = 'Tributado pelo ISSQN';


const XML_CONSULTAR_PROCESSAMENTO_ARQUIVO =
  BLOCOX_ESPECIFICACAO_XML +
  '<Manutencao Versao="1.0">' +
      '<Mensagem>' +
          '<Recibo>%s</Recibo>' +
      '</Mensagem>' +
      '<Signature />' +
  '</Manutencao>';

const XML_CANCELAR_ARQUIVO =
  BLOCOX_ESPECIFICACAO_XML +
  '<Manutencao Versao="1.0">' +
      '<Mensagem>' +
          '<Recibo>%s</Recibo>' +
          '<Motivo>%s</Motivo>' +
      '</Mensagem>' +
      '<Signature />' +
  '</Manutencao>';

const XML_REPROCESSAR_ARQUIVO =
  BLOCOX_ESPECIFICACAO_XML +
  '<Manutencao Versao="1.0">' +
      '<Mensagem>' +
          '<Recibo>%s</Recibo>' +
          '<Motivo>%s</Motivo>' +
      '</Mensagem>' +
      '<Signature />' +
  '</Manutencao>';

const XML_CONSULTAR_PENDENCIAS_CONTRIBUINTE =
  BLOCOX_ESPECIFICACAO_XML +
  '<ConsultarPendenciasContribuinte Versao="1.0">' +
      '<Mensagem>' +
          '<IE>%s</IE>'+
      '</Mensagem>' +
      '<Signature />' +
  '</ConsultarPendenciasContribuinte>';

const XML_CONSULTAR_PENDENCIAS_DESENVOLVEDOR_PAF_ECF =
  BLOCOX_ESPECIFICACAO_XML +
  '<ConsultarPendenciasDesenvolvedorPafEcf Versao="1.0">' +
    '<Mensagem>' +
        '<CNPJ>%s</CNPJ>' +
    '</Mensagem>' +
      '<Signature />' +
  '</ConsultarPendenciasDesenvolvedorPafEcf>';


const INI_SECAO_ECF = 'ECF';
const INI_CHAVE_NUMERO_CREDENCIAMENTO_PAF = 'CRED';
const INI_CHAVE_NUMERO_CREDENCIAMENTO_ECF = 'CRED ECF';

(*
type
  TArquivo = class
  private
    FTexto: String;
    FArquivo: TextFile;
  protected
  public
    property Texto: String read FTexto write FTexto;
    procedure SalvarArquivo(FileName: TFileName);
    procedure LerArquivo(FileName: TFileName);
  published
  end;
*)

type
   TRetornoBlocoX = class
   private
    FMensagem: String;                     // Elemento que identifica a resposta ao envio de uma Redução Z
    FRecibo: String;                       // Redução Z ou Estoque
    FTipo: String;                         // Redução Z: aaaa-MM-dd Exemplo: 2016-05-10; Estoque: aaaa-MM-dd a aaaa-MM-dd Exemplo: 2016-04-09 a 2016-05-08
    FEstadoProcessamentoDescricao: String; // Código do estado do processamento: 0 - Aguardando; 1 - Sucesso; 2 - Erro.
    FEstadoProcessamentoCodigo: String;    // Descrição do estado: Aguardando, Sucesso, Erro
    FDataReferencia: String;               // Mensagem descritiva, caso haja erro no processamento
    FXmlResposta: String;
    FTagResposta: String;
    FmsResposta: TMemoryStream;
    FSOAPResposta: String;
    FSerieECF: String;
    FSituacaoProcessamentoCodigo: String;
    FSituacaoProcessamentoDescricao: String;
    procedure SetFXmlResposta(const Value: String);
    procedure SetFmsResposta(const Value: TMemoryStream);
   protected
   public
     constructor Create;
     //destructor Destroy; // Sandro Silva 2017-06-02 causa access violation ao fechar aplicação override;
     destructor Destroy; override; // Sandro Silva 2020-04-14
     procedure Clear;
     property SerieECF: String read FSerieECF write FSerieECF;
     property Recibo: String read FRecibo write FRecibo;
     property Tipo: String read FTipo write FTipo;
     property DataReferencia: String read FDataReferencia write FDataReferencia;
     property EstadoProcessamentoCodigo: String read FEstadoProcessamentoCodigo write FEstadoProcessamentoCodigo;
     property EstadoProcessamentoDescricao: String read FEstadoProcessamentoDescricao write FEstadoProcessamentoDescricao;
     property Mensagem: String read FMensagem write FMensagem;
     property SituacaoProcessamentoCodigo: String read FSituacaoProcessamentoCodigo write FSituacaoProcessamentoCodigo;
     property SituacaoProcessamentoDescricao: String read FSituacaoProcessamentoDescricao write FSituacaoProcessamentoDescricao;
     property XmlResposta: String read FXmlResposta write SetFXmlResposta;
     property TagResposta: String read FTagResposta write FTagResposta;
     property msResposta: TMemoryStream read FmsResposta write SetFmsResposta;
     property SOAPResposta: String read FSOAPResposta write FSOAPResposta;
   published
   end;

type
  TServiceBlocoXBase = class(TComponent)

  private
    FHttpReqResp: TSmallHTTPReqResp;
    FEncodeDataToUTF8: Boolean;
    FMimeType: String;
    FSOAPAction: String;
    FUrl: String;
    FXmlFile: String;
    FCharSets: String;
    FServico: String;
    FEnvelopeSoap: String;
    FRetorno: TRetornoBlocoX;
    FXML: String;
    FUF: String;
    FmsResposta: TMemoryStream;
    FslResposta: TStringList;
    FArquivoBase64Zip: String;
    FCertificado: ICertificate2;
    FDTRefe: String;
    FECF: String;
    procedure SetFXmlFile(const Value: String);
  protected
    procedure SalvaXMLRecibo(sCaminho: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; virtual;
    procedure SalvaArquivo(FileName: TFileName; sTexto: String);
    property HttpReqResp: TSmallHTTPReqResp read FHttpReqResp write FHttpReqResp;
    property Url: String read FUrl write FUrl;
    property SOAPAction: String read FSOAPAction write FSOAPAction;
    property Servico: String read FServico write FServico;
    property MimeType: String read FMimeType write FMimeType;
    property Charsets: String read FCharSets write FCharSets;
    property EncodeDataToUTF8: Boolean read FEncodeDataToUTF8 write FEncodeDataToUTF8;
    property EnvelopeSoap: String read FEnvelopeSoap write FEnvelopeSoap;
    property Retorno: TRetornoBlocoX read FRetorno write FRetorno;
    property XmlFile: String read FXmlFile write SetFXmlFile;
    property Xml: String read FXML write FXML; //SetFXML;
    property UF: String read FUF write FUF;
    property Certificado: ICertificate2 read FCertificado write FCertificado; // Sandro Silva 2017-10-19
    property ECF: String read FECF write FECF;
    property DTRefe: String read FDTRefe write FDTRefe;
  published

  end;

type
  TEnvioReducaoZ = class(TServiceBlocoXBase)
  private
    // Sandro Silva 2018-09-25  FDataReferencia: String;
    // Sandro Silva 2018-09-25  FSerieECF: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
  published

  end;

type
  TEnvioEstoque = class(TServiceBlocoXBase)
  private
    FDataReferenciaInicial: String;
    FDataReferenciaFinal: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
  published

  end;

type
  TConsultaRecibo = class(TServiceBlocoXBase)
  private
    FRecibo: String;
    FSerieECF: String;
    FDataReferenciaInicial: String;
    FDataReferenciaFinal: String;
    FDataReferencia: String;
    FTipo: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property Recibo: String read FRecibo write FRecibo;
    property SerieECF: String read FSerieECF write FSerieECF;
    property DataReferenciaInicial: String read FDataReferenciaInicial write FDataReferenciaInicial;
    property DataReferenciaFinal: String read FDataReferenciaFinal write FDataReferenciaFinal;
    property DataReferencia: String read FDataReferencia write FDataReferencia;
    property Tipo: String read FTipo write FTipo;
  published

  end;

type
  TConsultarProcessamentoArquivo  = class(TServiceBlocoXBase)
  private
    FRecibo: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property Recibo: String read FRecibo write FRecibo;
  published

  end;

type
  TConsultaPendenciaContribuinte = class(TServiceBlocoXBase)
  private
    FIEContribuinte: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property IEContribuinte: String read FIEContribuinte write FIEContribuinte;
  published

  end;

type
  TConsultarPendenciasDesenvolvedorPafEcf = class(TServiceBlocoXBase)
  private
    FCNPJDesenvolvedor: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property CNPJDesenvolvedor: String read FCNPJDesenvolvedor write FCNPJDesenvolvedor;
  published

  end;

type
  TReprocessarArquivo  = class(TServiceBlocoXBase)// Sandro Silva 2019-11-05 
  private
    FRecibo: String;
    //FMotivo: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property Recibo: String read FRecibo write FRecibo;
    //property Motivo: String read FMotivo write FMotivo;
  published

  end;

type
  TValidarXMLBlocoX = class(TServiceBlocoXBase)
  private
    FpValidarPafEcfEEcf: String;
    FpValidarAssinaturaDigital: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property pValidarPafEcfEEcf: String read FpValidarPafEcfEEcf write FpValidarPafEcfEEcf;
    property pValidarAssinaturaDigital: String read FpValidarAssinaturaDigital write FpValidarAssinaturaDigital;

  published

  end;

type
  TTransmitirReducaoZ = class(TServiceBlocoXBase)
  private
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
  published

  end;

type
  TCancelarArquivo  = class(TServiceBlocoXBase)// Sandro Silva 2019-11-05
  private
    FRecibo: String;
    FMotivo: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Enviar: Boolean; override;
    property Recibo: String read FRecibo write FRecibo;
    property Motivo: String read FMotivo write FMotivo;
  published

  end;


type
  TBlocoXBase = class
  private
    FCertificadoSubjectName: String;
    FCertificado: ICertificate2;
    FXML: String;
    FUF: String;
    FEnvioEstoque: TEnvioEstoque;
    FEnvioReducaoZ: TEnvioReducaoZ;
    FValidarXml: TValidarXMLBlocoX;
    FConsultarRecibo: TConsultaRecibo;
    FXmlSalvo: String;
    FConsultarPendenciaContribuinte: TConsultaPendenciaContribuinte;
    FConsultarPendenciasDesenvolvedorPafEcf: TConsultarPendenciasDesenvolvedorPafEcf;
    FConsultarProcessamentoArquivo: TConsultarProcessamentoArquivo;
    FDiretorioAtual: String;
    FTransmitirArquivoRZ: TTransmitirReducaoZ;
    FReprocessarArquivo: TReprocessarArquivo;
    FCancelarArquivo: TCancelarArquivo; // Sandro Silva 2019-11-05
    procedure SetFCertificadoSubjectName(const Value: String);
    procedure SetCertificado(const Value: ICertificate2); // Sandro Silva 2018-02-06
  public
    property Certificado: ICertificate2 read FCertificado write SetCertificado; // Sandro Silva 2018-02-06 FCertificado;
    property CertificadoSubjectName: String read FCertificadoSubjectName write SetFCertificadoSubjectName;
    property Xml: String read FXML write FXML;
    property UF: String read FUF write FUF;
    property EnvioEstoque: TEnvioEstoque read FEnvioEstoque write FEnvioEstoque;
    property EnvioReducaoZ: TEnvioReducaoZ read FEnvioReducaoZ write FEnvioReducaoZ;
    property ValidarXml: TValidarXMLBlocoX read FValidarXml write FValidarXml;
    property ConsultarRecibo: TConsultaRecibo read FConsultarRecibo write FConsultarRecibo;
    property ConsultarPendenciaContribuinte: TConsultaPendenciaContribuinte read FConsultarPendenciaContribuinte write FConsultarPendenciaContribuinte;
    property ConsultarPendenciasDesenvolvedorPafEcf: TConsultarPendenciasDesenvolvedorPafEcf read FConsultarPendenciasDesenvolvedorPafEcf write FConsultarPendenciasDesenvolvedorPafEcf;
    property ConsultarProcessamentoArquivo: TConsultarProcessamentoArquivo read FConsultarProcessamentoArquivo write FConsultarProcessamentoArquivo;
    property ReprocessarArquivo: TReprocessarArquivo read FReprocessarArquivo write FReprocessarArquivo;
    property CancelarArquivo: TCancelarArquivo read FCancelarArquivo write FCancelarArquivo;    
    property TransmitirArquivoRZ: TTransmitirReducaoZ read FTransmitirArquivoRZ write FTransmitirArquivoRZ; // Sandro Silva 2019-07-22
    property XmlSalvo: String read FXmlSalvo write FXmlSalvo;
    property DiretorioAtual: String read FDiretorioAtual write FDiretorioAtual;

    constructor Create(AOwner: TComponent);
    //destructor Destroy; // Sandro Silva 2017-06-02 causa access violation ao fechar aplicação  override;
    destructor Destroy; override; // Sandro Silva 2020-04-14  
    function GetCertificado(bPermitirSelecionar: Boolean): ICertificate2;// Sandro Silva 2018-02-06  function GetCertificado: ICertificate2;
    function AssinaXML: String;
    function SalvaArquivo(sArquivo: String): Boolean;
    function Transmitir(sXml: String): String;
    procedure TransmitirBlocoX(sUF: String; sTipo: String; sFileXml: String);
  private
  published

  end;

type
  TBlocoXEstoque = class(TBlocoXBase)
  private

  public

  published

  end;

type
  TBlocoXReducaoZ = class(TBlocoXBase)
  private

  public

  published

  end;

type
  TBlocoXValidarXML = class(TBlocoXBase)
  private

  public

  published

  end;

type
  TBlocoXConsultaRecibo = class(TBlocoXBase)
  private

  public

  published

  end;

type
  TBlocoXConsultarProcessamentoArquivo = class(TBlocoXBase)
  private

  public

  published

  end;

type TBlocoXConsultaPendenciaContribuinte = class(TBlocoXBase)
  private

  public

  published

  end;

type TBlocoXConsultarPendenciasDesenvolvedorPafEcf = class(TBlocoXBase)
  private

  public

  published

  end;

type
  TBlocoXTransmitirArquivo = class(TBlocoXBase)
  private

  public

  published

  end;

type TBlocoXReprocessarArquivo = class(TBlocoXBase)
  private

  public

  published

  end;

type TBlocoXCancelarArquivo = class(TBlocoXBase)
  private

  public

  published

  end;
  
function LoadFileToString(const FileName: TFileName): String;
function ZipFile(const aSourceFilename, aTargetFilename: String;
  bDeleteAfterZip: Boolean = True): String;
function AssinarMSXML(XML: String; wNumSerieCertificado: String;
  Certificado: ICertificate2; URI: String): String;
function LoadEnvelopeSoap(sArquivo: String): String;
function ProcessaResposta(sResposta: String; sTagResposta: String): String;
function MD5Pasta(sPasta: String; sExtensao: String): String;
function SalvarHashPasta(sTipo: String; sPasta: String;
  sExtensao: String): Boolean;
function BlocoxValidarHashPasta(sTipo: String; sPasta: String;
  sExtensao: String): Boolean;
function DiretorioLog: String;
function DiretorioLogBlocoX: String;
function DiretorioConfigBlocoX: String;
function GetCNPJCertificado(SubjectName: String): String;
procedure MensagemAlertaCertificado;
procedure CriaDiretoriosBlocoX;

implementation

uses StrUtils;

procedure MensagemAlertaCertificado;
begin
  Application.MessageBox(PChar({'Selecione um certificado digital para ser usado com o PAF' + #13 + #13 +
                               'O certificado digital é necessário para assinar os arquivos gerados ' + #13 +
                               'conforme descrito nos requisitos LVIII e LIX, do Bloco X, da E.R. vigente'}
                               'Selecione um certificado digital para ser usado com o PAF' + #13 + #13 +
                               'O certificado digital é necessário para assinar os arquivos gerados conforme descrito nos requisitos LVIII e LIX, do Bloco X, da E.R. vigente'
                                +chr(10)+ ''
                                +chr(10)+'1 - Verifique se o seu certificado está instalado'
                                +chr(10)+'2 - Verifique se o seu certificado está selecionado'
                                +chr(10)+'3 - Seu certificado pode estar vencido'
                                +chr(10)+'4 - Seu certificado pode ser inválido'
                                +chr(10)
                                +chr(10)+'Certificados recomendados' // Sandro Silva 2022-12-02 Unochapeco +chr(10)+'Certificados recomendados pela Smallsoft®'
                                +chr(10)+''
                                +chr(10)+'1. Certificados SERASA'
                                +chr(10)+'    * A1'
                                +chr(10)+'    * SmartCard'
                                +chr(10)+'    * E-CNPJ'
                                +chr(10)+'2. Certificados Certisign A1 e A3'
                                +chr(10)+'3. Certificados dos Correios A1 e A3'
                                +chr(10)+'4. Certificados A3 PRONOVA ACOS5'
                                +chr(10)
                                +chr(10)+'Selecione um certificado acessando'
                                +chr(10)+'F10 Menu Gerencial/Configurações/Selecionar certificado digital'
                                +chr(10)
                                +chr(10)
                                +chr(10)
                                +'OBS: Não ligue para o suporte técnico da Zucchetti® por este motivo.'), // Sandro Silva 2022-12-02 Unochapeco +'OBS: Não ligue para o suporte técnico da Smallsoft® por este motivo.'),
                                    'Atenção', MB_ICONWARNING + MB_OK);
end;

function GetCNPJCertificado(SubjectName: String): String;
var
  iComposicao: Integer;
  sl: TStringList;
begin
  Result := '';
  sl := TStringList.Create;
  try
    sl.DelimitedText := '"' + StringReplace(SubjectName, ', ', '","', [rfReplaceAll]) + '"';
    sl.Delimiter := ',';
    for iComposicao := 0 to sl.Count - 1 do
    begin
      if AnsiUpperCase(Copy(sl.Strings[iComposicao], 1, 3)) = 'CN=' then
      begin
        Result := RightStr(LimpaNumero(sl.Strings[iComposicao]), 14);
        Break;
      end;
    end;
  except
  
  end;
  sl.Free;
end;

function DiretorioConfigBlocoX: String;
begin
  //Result := ExtractFilePath(Application.ExeName) +  'BlocoX';
  Result := ExtractFilePath(ParamStr(0)) +  'BlocoX';
end;

function DiretorioLog: String;
begin
  //Result := ExtractFilePath(Application.ExeName) +  'log';
  Result := ExtractFilePath(ParamStr(0)) +  'log';
end;

function DiretorioLogBlocoX: String;
begin
  //Result := ExtractFilePath(Application.ExeName) +  'log\BlocoX';
    Result := ExtractFilePath(ParamStr(0)) +  'log\BlocoX';
end;

function MD5Pasta(sPasta: String; sExtensao: String): String;
var
  sMD5: String;
  sMD5Nome: String;
  iFile: Integer;
  I: Integer;
  SearchRec: TSearchRec;
  aArq: array of String;
begin
  SetLength(aArq, 0);
  try
    I := FindFirst(sPasta + sExtensao, 0, SearchRec);
    while I = 0 do
    begin
      SetLength(aArq, Length(aArq) + 1);
      aArq[High(aArq)]{.Nome} := SearchRec.Name;
      I := FindNext(SearchRec);
    end;
  except
    raise;
  end;

  for iFile := 0 to Length(aArq) - 1 do
  begin
    sMD5     := sMD5 + MD5Print(MD5File(aArq[iFile]));
    sMD5Nome := sMD5Nome + MD5Print(MD5String(aArq[iFile]));
  end;

  Result := MD5Print(MD5String(sMD5 + sMD5Nome));

  aArq := nil;

end;

function SalvarHashPasta(sTipo: String; sPasta: String;
  sExtensao: String): Boolean;
var
  ArqMD5: TArquivo;
  sMD5Novo: String;
  //sPastaInicio: String; // Sandro Silva 2018-03-13
begin
  //sPastaInicio := ExtractFilePath(Application.ExeName); // Salva a pasta atual que está apontando Sandro Silva 2018-03-13
  Result := False;
  sMD5Novo := MD5Pasta(sPasta, sExtensao);
  ArqMD5 := TArquivo.Create;
  try
    //ArqMD5.LerArquivo(sPasta + '\' + sTipo + '.bx');
    ArqMD5.Texto := sMD5Novo;
    ArqMD5.SalvarArquivo(sPasta + '\' + sTipo + '.bx');
    Result := True;
  except
  end;
  FreeAndNil(ArqMD5); // Sandro Silva 2019-06-19 ArqMD5.Free; 

  {Sandro Silva 2018-03-13 inicio
  try
    Chdir(sPastaInicio); // Restaura a pasta que o executável deve apontar
  except

  end;
  {Sandro Silva 2018-03-13 fim}
end;

function BlocoxValidarHashPasta(sTipo: String; sPasta: String;
  sExtensao: String): Boolean;
var
  ArqMD5: TArquivo;
  sMD5Novo: String;
begin
  Result := False;
  sMD5Novo := MD5Pasta(sPasta, sExtensao);
  ArqMD5 := TArquivo.Create;
  try
    ArqMD5.LerArquivo(sPasta + '\' + sTipo + '.bx');
    Result := ArqMD5.Texto = sMD5Novo;
  except
  end;
  FreeAndNil(ArqMD5); // Sandro Silva 2019-06-19 ArqMD5.Free; 
end;

function ProcessaResposta(sResposta: String; sTagResposta: String): String;
var
  iPosI, iPosF: Integer;
  sTagValue: String;
  sRespostaOriginal: String; // Sandro Silva 2019-02-25
begin

  sRespostaOriginal := sResposta; // Sandro Silva 2019-02-25
  sResposta := StringReplace(sResposta, '&gt;', '>', [rfReplaceAll]);
  sResposta := StringReplace(sResposta, '&lt;', '<', [rfReplaceAll]);//xmlNodeValue(StringReplace(mmResponse.Text, '&lt;', '<', [rfReplaceAll]), '//ConsultarResult');
  sResposta := StringReplace(sResposta, #$D#$A, '', [rfReplaceAll]); // Sandro Silva 2019-07-19
  iPosI := Pos('<' + sTagResposta + '>', sResposta);
  iPosF := Pos('</' + sTagResposta + '>', sResposta);
  sTagValue := Copy(sResposta, iPosI, iPosF - iPosI);
  sTagValue := StringReplace(sTagValue, '<' + sTagResposta + '>', '', [rfReplaceAll]);
  Result := Utf8ToAnsi(sTagValue);
  if (Result = '') and (sTagValue <> '') then // Utf8ToAnsi() Falhou e retornou vazio, mas tinha valor na tag
    Result := sTagValue;

  if (Result = '') then
    Result := sRespostaOriginal;
  
end;

function LoadFileToString(const FileName: TFileName): String;
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(Filename);
    Stream.Position := 0;
    SetString(Result, PAnsiChar(Stream.Memory), Stream.Size);
  finally
    FreeAndNil(Stream); // Sandro Silva 2019-06-19 Stream.Free;
  end;
end;

function ZipFile(const aSourceFilename, aTargetFilename: String;
  bDeleteAfterZip: Boolean = True): String;
var
  Zip: TZipWrite;
begin
  if (FileExists(aTargetFilename)) then
  begin
    DeleteFile(PChar(aTargetFilename));
    Sleep(10); // Sandro Silva 2019-07-22 
  end;

  try
    Zip := TZipWrite.Create(aTargetFilename);
    try
      Zip.AddDeflated(aSourceFilename);

    finally
      Zip.Free;
    end;

    Result := LoadFileToString(aTargetFilename);

    if bDeleteAfterZip then
      DeleteFile(PChar(aTargetFilename));
  except
  
  end;
end;

function LoadEnvelopeSoap(sArquivo: String): String;
var
  Arquivo: TArquivo;
begin
  Arquivo := TArquivo.Create;
  try
    Arquivo.LerArquivo(sArquivo);
    Result := Arquivo.Texto;
  except
  end;
  FreeAndNil(Arquivo); // Sandro Silva 2019-06-19 Arquivo.Free;
end;

function AssinarMSXML(XML: String; wNumSerieCertificado: String;
  Certificado: ICertificate2; URI: String): String;
const
  DSIGNS = 'xmlns:ds="http://www.w3.org/2000/09/xmldsig#"';
  SignatureNodes =
    '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
      '<SignedInfo>' +
        '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>' +
        '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />' +
        '<Reference URI="">' +
          '<Transforms>' +
            '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />' +
            // Sandro Silva 2019-02-28 '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
          '</Transforms>' +
          '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />' +
          '<DigestValue></DigestValue>' +
        '</Reference>' +
      '</SignedInfo>' +
      '<SignatureValue></SignatureValue>' +
      '<KeyInfo></KeyInfo>' +
    '</Signature>';
var
  iCert: Integer;
  XMLAssinado: String;
  XMLBody: String;

  xmldoc: IXMLDOMDocument3;
  xmldsig: IXMLDigitalSignature;
  dsigKey: IXMLDSigKey;
  signedKey: IXMLDSigKey;

  CertStore: IStore3;
  CertStoreMem: IStore3;
  PrivateKey: IPrivateKey;
  NumCertCarregado: String;
  Certs{, Store}: OleVariant;
  CertificadoAssina: ICertificate2;
begin
  Result := XML;

  CoInitialize(nil); // PERMITE O USO DE THREAD // Sandro Silva 2019-04-17

  xmldoc  := CoDOMDocument50.Create;// capicom.dll e msxml5.dll copiar e registrar (como administrador) para system32 e syswow64
  xmldsig := CoMXDigitalSignature50.Create;

  try
    XMLBody := XML;

    if AnsiContainsText(XMLBody, '<SignedInfo>') then
    begin
      // xml já está assinado
      XMLBody := Copy(XMLBody, 1, Pos('<Signature', XMLBody) - 1) + '<Signature />' + Copy(XMLBody, Pos('</Signature>', XMLBody) + Length('</Signature>'), Length(XMLBody));
    end;

    XMLBody := StringReplace(XMLBody, '<Signature />', SignatureNodes, [rfReplaceAll]);

    // Lendo Header antes de assinar //
    //XMLBodyHeaderAntes := '' ;
    //I := pos('?>',XMLBody) ;
    //if I > 0 then
    //  XMLBodyHeaderAntes := copy(XMLBody,1,I+1) ;

    xmldoc.async              := False;
    xmldoc.validateOnParse    := False;
    xmldoc.preserveWhiteSpace := True;

    StringReplace(XMLBody, '#D3#D4', '', [rfReplaceAll]);

    if (not xmldoc.loadXML(XMLBody)) then
      raise Exception.Create('Não foi possível carregar o arquivo: ' + XML);

    if XMLBody <> '' then
    begin
      XMLBody := StringReplace(XMLBody, #10, '', [rfReplaceAll]);
      XMLBody := StringReplace(XMLBody, #13, '', [rfReplaceAll]);
    end;

    xmldoc.setProperty('SelectionNamespaces', DSIGNS);

    xmldsig.signature := xmldoc.selectSingleNode('.//ds:Signature');

    if (xmldsig.signature = nil) then
      raise Exception.Create('É preciso carregar o template antes de assinar.');

    if CertStoreMem = nil then
    begin
      CertStore := CoStore.Create;
      CertStore.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

      CertStoreMem := CoStore.Create;
      CertStoreMem.Open(CAPICOM_MEMORY_STORE, 'Memoria', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

      Certs := CertStore.Certificates as ICertificates2;
      for iCert := 1 to Certs.Count do
      begin
        CertificadoAssina := IInterface(Certs.Item[iCert]) as ICertificate2;
        if CertificadoAssina.Thumbprint = wNumSerieCertificado then
        begin
          CertStoreMem.Add(CertificadoAssina);
          NumCertCarregado := CertificadoAssina.Thumbprint;
          Break; // 2016-02-05  Sandro Silva
        end;
      end;
    end;

    //ShowMessage('Teste Num certificado: ' + NumCertCarregado); // Sandro Silva 2022-02-22

    OleCheck(IDispatch(Certificado.PrivateKey).QueryInterface(IPrivateKey, PrivateKey));
    xmldsig.store := CertStoreMem;

    try

      dsigKey := xmldsig.createKeyFromCSP(PrivateKey.ProviderType, PrivateKey.ProviderName, PrivateKey.ContainerName, 0);

      if (dsigKey = nil) then
        raise Exception.Create('Erro ao criar a chave do CSP.');

      // Deve usar CERTIFICATES = $00000002 para gerar todos grupos tags de assinatura (SignatureValue, X509Certificate). Outro valor não gera todas as tags
      signedKey := xmldsig.sign(dsigKey, CERTIFICATES);

      if (signedKey <> nil) then
      begin

        //ShowMessage('Teste adicionando assinatura no xml '); // Sandro Silva 2022-02-22

        XMLAssinado := xmldoc.xml;
        XMLAssinado := StringReplace(XMLAssinado, '<?xml version="1.0"?>', BLOCOX_ESPECIFICACAO_XML, [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, #13#10, '', [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, #13, '', [rfReplaceAll]); // Sandro Silva 2019-04-22         
        XMLAssinado := StringReplace(XMLAssinado, '<KeyInfo><X509Data><X509Certificate></X509Certificate></X509Data></KeyInfo>', '', [rfReplaceAll]);
        // 2016-02-05 Sandro Silva Elimina Espaços em branco nas tags de assinatura
        XMLAssinado := StringReplace(XMLAssinado, xmlNodeValue(XMLAssinado, '//SignatureValue'), Trim(StringReplace(xmlNodeValue(XMLAssinado, '//SignatureValue'), #32, '', [rfReplaceAll])), [rfReplaceAll]);
        XMLAssinado := StringReplace(XMLAssinado, xmlNodeValue(XMLAssinado, '//X509Certificate'), Trim(StringReplace(xmlNodeValue(XMLAssinado, '//X509Certificate'), #32, '', [rfReplaceAll])), [rfReplaceAll]);
        {Sandro Silva 2019-02-26 inicio}
        while AnsiContainsText(XMLAssinado, '<SignatureValue> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<SignatureValue> ', '<SignatureValue>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </SignatureValue>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </SignatureValue>', '</SignatureValue>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<X509Certificate>  ') do
          XMLAssinado := StringReplace(XMLAssinado, '<X509Certificate>  ', '<X509Certificate>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </X509Certificate>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </X509Certificate>', '</X509Certificate>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<X509Data> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<X509Data> ', '<X509Data>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </X509Data>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </X509Data>', '</X509Data>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, '<KeyInfo> ') do
          XMLAssinado := StringReplace(XMLAssinado, '<KeyInfo> ', '<KeyInfo>', [rfReplaceAll]);

        while AnsiContainsText(XMLAssinado, ' </KeyInfo>') do
          XMLAssinado := StringReplace(XMLAssinado, ' </KeyInfo>', '</KeyInfo>', [rfReplaceAll]);
        {Sandro Silva 2019-02-26 fim}
      end
      else
        raise Exception.Create('Assinatura Falhou.');
    except
      on E: Exception do
      begin
        if DirectoryExists('log') then
        begin
          with TArquivo.Create do
          begin
            Texto := FormatDateTime('dd/mm/yyyy HH:nn:ss.zzz', Now) + E.Message;
            SalvarArquivo('log\BlocoX\log_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.txt');// Sandro Silva 2021-02-19 SalvarArquivo('log_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.txt');
            Free;
          end;
        end;
      end;
    end;

    Result := XMLAssinado;

  finally
    if dsigKey <> nil then
      dsigKey := nil;
    if signedKey <> nil then
      signedKey := nil;
    if xmldoc <> nil then
      xmldoc := nil;
    if xmldsig <> nil then
      xmldsig := nil;
    if CertStore <> nil then
      CertStore := nil;
    if CertStoreMem <> nil then
      CertStoreMem := nil;
    {Sandro Silva 2019-06-19 inicio}
    if CertificadoAssina <> nil then
      CertificadoAssina := nil;
    {Sandro Silva 2019-06-19 fim}
  end;
end;

procedure CriaDiretoriosBlocoX;
// Sandro Silva 2019-06-21 Cria os diretórios usados para gravar arquivos relacionados ao Bloco X do PAF
begin
  ForceDirectories(DiretorioConfigBlocoX);
  ForceDirectories(DiretorioLog);
  ForceDirectories(DiretorioLogBlocoX);

  //ForceDirectories(PASTA_REDUCOES_BLOCO_X);
  //ForceDirectories(PASTA_ESTOQUE_BLOCO_X);
  //CreateDir(PChar(PASTA_RECIBOS_ESTOQUE_BLOCO_X));
  //CreateDir(PChar(PASTA_RECIBOS_REDUCOES_BLOCO_X));

  CreateDir(PAnsiChar('c:\BlocoX'));
  CreateDir(PAnsiChar(PASTA_REDUCOES_BLOCO_X));
  CreateDir(PAnsiChar(PASTA_ESTOQUE_BLOCO_X));
  CreateDir(PAnsiChar('c:\BlocoX\Recibos - Bloco X'));
  CreateDir(PAnsiChar(PASTA_RECIBOS_ESTOQUE_BLOCO_X));
  CreateDir(PAnsiChar(PASTA_RECIBOS_REDUCOES_BLOCO_X));

end;

//////////////////////////////////////////////////////////////////////

{ TBlocoXBase }

function TBlocoXBase.AssinaXML: String;
var
  sXMLAssinado: String;
  ArqLog: TArquivo;
begin
  if FCertificado <> nil then
  begin
    try

      //ShowMessage('Teste 01 995'); // Sandro Silva 2021-01-04

      sXMLAssinado := AssinarMSXML(FXML, FCertificado.Thumbprint, Certificado, '""');
      if Trim(sXMLAssinado) <> '' then
        FXML := sXMLAssinado;

    except
      on E: Exception do
      begin
        ArqLog := TArquivo.Create;
        ArqLog.Texto := FormatDateTime('dd/mm/yyyy HH:nn:ss.zzz', Now) + ' ' + E.Message;
        ArqLog.SalvarArquivo('log\BlocoX\log_assinatura_' + FormatDateTime('dd-mm-yyyy_HHnnsszzz', Now) + '.txt');
        FreeAndNil(ArqLog); // Sandro Silva 2019-06-19 ArqLog.Free;
        ChDir(DiretorioAtual);
      end;
    end;
  end;
  Result := FXML;
end;

constructor TBlocoXBase.Create(AOwner: TComponent);
begin
  FEnvioEstoque                           := TEnvioEstoque.Create(AOwner); // Sandro Silva 2018-09-19 TEnvioEstoque.Create(Application);
  FEnvioReducaoZ                          := TEnvioReducaoZ.Create(AOwner); // Sandro Silva 2018-09-19 TEnvioReducaoZ.Create(Application);
  FValidarXml                             := TValidarXMLBlocoX.Create(AOwner); // Sandro Silva 2018-09-19 TValidarXMLBlocoX.Create(Application);
  FConsultarRecibo                        := TConsultaRecibo.Create(AOwner); // Sandro Silva 2018-09-19 TConsultaRecibo.Create(Application);
  FConsultarPendenciaContribuinte         := TConsultaPendenciaContribuinte.Create(AOwner); // Sandro Silva 2019-02-22
  FConsultarPendenciasDesenvolvedorPafEcf := TConsultarPendenciasDesenvolvedorPafEcf.Create(AOwner); // Sandro Silva 2019-02-22
  FConsultarProcessamentoArquivo          := TConsultarProcessamentoArquivo.Create(AOwner);// Sandro Silva 2019-03-26
  FTransmitirArquivoRZ                    := TTransmitirReducaoZ.Create(AOwner); // Sandro Silva 2019-07-22
  FReprocessarArquivo                     := TReprocessarArquivo.Create(AOwner); // Sandro Silva 2019-11-05
  FCancelarArquivo                        := TCancelarArquivo.Create(AOwner); // Sandro Silva 2022-03-11
end;

destructor TBlocoXBase.Destroy;
begin
  try
    FEnvioEstoque.Free;
    FEnvioReducaoZ.Free;
    FValidarXml.Free;
    FConsultarRecibo.Free;

    FConsultarPendenciaContribuinte.Free; // Sandro Silva 2019-02-22
    //FConsultarPendenciasDesenvolvedorPafEcf.Free; // Sandro Silva 2019-02-22
    FConsultarProcessamentoArquivo.Free; // Sandro Silva 2019-03-26
    FTransmitirArquivoRZ.Free; // Sandro Silva 2019-07-22
    FReprocessarArquivo.Free; // Sandro Silva 2019-11-05
    FCancelarArquivo.Free; // Sandro Silva 2022-03-11

  //inherited Destroy;
  // Sandro Silva 2017-06-02 causa access violation ao fechar aplicação  inherited; // Sandro Silva 2017-06-01 Igual TSmallSat
  // causando invalid pointer operation quando FConsultarRecibo.Free; inherited; // Sandro Silva 2018-09-27
  except

  end;
end;

// Sandro Silva 2018-02-06  function TBlocoXBase.GetCertificado: ICertificate2;
function TBlocoXBase.GetCertificado(bPermitirSelecionar: Boolean): ICertificate2;
var
  Store: IStore3;
  CertsLista: ICertificates2;
  CertsSelecionado: ICertificates2;
  CertDados: ICertificate;
  iCert: Integer;
  bAchou: Boolean;
begin
  Store := CoStore.Create;
  Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

  bAchou := False;

  if FCertificadoSubjectName = '' then
  begin
    if bPermitirSelecionar then // Sandro Silva 2018-02-06 
    begin

      MensagemAlertaCertificado;

      try
        CertsLista := Store.Certificates as ICertificates2;
        CertsSelecionado := CertsLista.Select('Certificado(s) Digital(is) disponível(is)', #13 + 'Selecione o Certificado Digital para uso no aplicativo PAF' + #13 + #13, False);
        if not (CertsSelecionado.Count = 0) then
        begin
          CertDados := IInterface(CertsSelecionado.Item[1]) as ICertificate2;
          FCertificadoSubjectName := CertDados.SubjectName;
          bAchou := True;
        end;
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Não foi possível selecionar o certificado digital' + #13 + E.Message), 'Atenção', MB_ICONWARNING + MB_OK);
        end;
      end;
    end;
  end
  else
  begin
    try
      CertsLista := Store.Certificates as ICertificates2;
      for iCert := 1 to CertsLista.Count do
      begin
        CertDados := ICertificate2(IInterface(CertsLista.Item[iCert]));
        if CertDados.SubjectName = FCertificadoSubjectName then
        begin
          bAchou := True;
          Break;
        end;
      end;
    except

    end;
  end;
  Result := CertDados as ICertificate2;

  if bAChou = False then
    Result := nil;

  FCertificado := Result;

  {Sandro Silva 2019-06-19 inicio}
  if CertsLista <> nil then
    CertsLista := nil;

  if CertsSelecionado <> nil then
    CertsSelecionado := nil;

  // causa exception "Privileged instruction" Store.Close; // Sandro Silva 2018-08-30
  Store := nil;// Sandro Silva 2018-08-30
end;

function TBlocoXBase.SalvaArquivo(sArquivo: String): Boolean;
var
  Arquivo: TArquivo;
begin
  Result    := False;
  FXmlSalvo := '';
  Arquivo := TArquivo.Create;
  try
    Arquivo.Texto := FXML;
    Arquivo.SalvarArquivo(sArquivo);
  except
  end;
  FreeAndNil(Arquivo); // Sandro Silva 2019-06-19 Arquivo.Free; 
  if FileExists(sArquivo) then
  begin
    FXmlSalvo := sArquivo;
    Result    := True;
  end;
end;

procedure TBlocoXBase.SetFCertificadoSubjectName(const Value: String);
begin
  FCertificadoSubjectName := Value;
  try
    if GetCertificado((Trim(Value) <> '')) <> nil then
    begin
      FEnvioEstoque.Certificado    := FCertificado;
      FEnvioReducaoZ.Certificado   := FCertificado;
      FConsultarRecibo.Certificado := FCertificado;
      
      FConsultarPendenciaContribuinte.Certificado         := FCertificado; // Sandro Silva 2019-02-22
      FConsultarPendenciasDesenvolvedorPafEcf.Certificado := FCertificado; // Sandro Silva 2019-02-22
      FConsultarProcessamentoArquivo.Certificado          := FCertificado; // Sandro Silva 2019-03-26
      FTransmitirArquivoRZ.Certificado                    := FCertificado; // Sandro Silva 2019-07-22
      FReprocessarArquivo.Certificado                     := FCertificado; // Sandro Silva 2019-11-05
      FCancelarArquivo.Certificado                        := FCertificado; // Sandro Silva 2019-11-05
    end;
  except

  end;
end;

procedure TBlocoXBase.SetCertificado(const Value: ICertificate2); // Sandro Silva 2018-02-06
begin
  if Value <> nil then
    FCertificadoSubjectName := Value.SubjectName;
end;

function TBlocoXBase.Transmitir(sXml: String): String;
var
  hnd: THandle;
  Transmitir: function(sXML: String): String; stdcall;
begin
  Result := '';
  if FileExists(P_DLLNAME) then
  begin
    Hnd := LoadLibrary(P_DLLNAME);
    if Hnd > 0 then
    begin
      @Transmitir := GetProcAddress(Hnd, 'Transmitir');
      if @Transmitir <> nil then
      begin
        Result := Transmitir(sXML);
      end;
      Freelibrary(GetModuleHandle(P_DLLNAME));
    end;
  end;
end;

procedure TBlocoXBase.TransmitirBlocoX(sUF: String; sTipo: String;
  sFileXml: String);
begin

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    if AnsiUpperCase(sTipo) = 'ESTOQUE' then
    begin
      FEnvioEstoque.MimeType            := 'text/xml'; // Sandro Silva 2020-02-05  'application/soap+xml';
      FEnvioEstoque.Charsets            := 'utf-8';
      FEnvioEstoque.EncodeDataToUTF8    := True;
      FEnvioEstoque.UF                  := sUF;
      FEnvioEstoque.XmlFile             := sFileXml;
      FEnvioEstoque.Servico             := 'TransmitirArquivo'; // Sandro Silva 2020-02-05  'Enviar'; // Sandro Silva 2017-09-27  'EnviarEstoque';
      FEnvioEstoque.Certificado         := FCertificado;
      FEnvioEstoque.Enviar;
    end;

    if AnsiUpperCase(sTipo) = 'REDUCAO' then
    begin
      FEnvioReducaoZ.MimeType            := 'text/xml'; // Sandro Silva 2020-02-05  'application/soap+xml';
      FEnvioReducaoZ.Charsets            := 'utf-8';
      FEnvioReducaoZ.EncodeDataToUTF8    := True;
      FEnvioReducaoZ.UF                  := sUF;
      FEnvioReducaoZ.XmlFile             := sFileXml;
      FEnvioReducaoZ.Servico             := 'TransmitirArquivo'; // Sandro Silva 2020-02-05  'Enviar';// Sandro Silva 2017-09-27  'EnviarReducaoZ';
      FEnvioReducaoZ.Certificado         := FCertificado;
      FEnvioReducaoZ.Enviar;
    end;

  end;

end;

{ TServiceBlocoXBase }

constructor TServiceBlocoXBase.Create(AOwner: TComponent);
begin
  FHttpReqResp := TSmallHTTPReqResp.Create;
  FmsResposta  := TMemoryStream.Create;
  FslResposta  := TStringList.Create;

  FRetorno          := TRetornoBlocoX.Create;
  FMimeType         := 'application/soap+xml';
  FCharsets         := 'utf-8';
  FEncodeDataToUTF8 := True;
  CriaDiretoriosBlocoX;
  inherited;

end;

destructor TServiceBlocoXBase.Destroy;
begin
  FHttpReqResp.Free;
  FmsResposta.Free;
  FslResposta.Free;
  FRetorno.Free;
  inherited;
end;

function TServiceBlocoXBase.Enviar: Boolean;
var
  arqDadosServidor: TArquivo;
  sSubjectName: String;
begin
  FRetorno.Clear;
  arqDadosServidor := TArquivo.Create;

  sSubjectName := '';
  try
    sSubjectName := FCertificado.SubjectName;
  except

  end;
  if (AnsiContainsText(sSubjectName, Trim(CNPJ_SOFTWARE_HOUSE_PAF))) then
  {Sandro Silva 2018-02-05 fim}
  begin
    // Sandro Silva 2018-02-01 Não é certificado da Smallsoft usa homologação
    if FileExists(DiretorioConfigBlocoX + '\blocox_servidores_homologacao.xml') = False then
    begin
      arqDadosServidor.Texto :=
        '<?xml version="1.0" encoding="utf-8"?>' +
        '<Smallsoft>' +
          '<BlocoX>' +
            '<UF nome="SC">' +
              '<Servico acao="Consultar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>ConsultarResult</TagResposta>' +
              '</Servico>' +
              '<Servico acao="Enviar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>EnviarResult</TagResposta>' +
              '</Servico>' +
              '<Servico acao="Validar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>ValidarResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="CancelarArquivo">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/CancelarArquivo</SOAPAction>' +
                  '<TagResposta>CancelarArquivoResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="ConsultarPendenciasContribuinte">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/ConsultarPendenciasContribuinte</SOAPAction>' +
                  '<TagResposta>ConsultarPendenciasContribuinteResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="ConsultarPendenciasDesenvolvedorPafEcf">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/ConsultarPendenciasDesenvolvedorPafEcf</SOAPAction>' +
                  '<TagResposta>ConsultarPendenciasDesenvolvedorPafEcfResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="ConsultarProcessamentoArquivo">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/ConsultarProcessamentoArquivo</SOAPAction>' +
                  '<TagResposta>ConsultarProcessamentoArquivoResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="ReprocessarArquivo">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/ReprocessarArquivo</SOAPAction>' +
                  '<TagResposta>ReprocessarArquivoResult</TagResposta>' +
              '</Servico>' +

              '<Servico acao="TransmitirArquivo">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                  '<SOAPAction>http://webservices.sef.sc.gov.br/wsDfeSiv/TransmitirArquivo</SOAPAction>' +
                  '<TagResposta>TransmitirArquivoResult</TagResposta>' +
              '</Servico>' +

            '</UF>' +
          '</BlocoX>' +
        '</Smallsoft>';
    end
    else
      arqDadosServidor.LerArquivo(DiretorioConfigBlocoX + '\blocox_servidores_homologacao.xml');
  end
  else
  begin
    arqDadosServidor.LerArquivo(DiretorioConfigBlocoX + '\blocox_servidores.xml');
  end;

  FUrl                 := xmlNodeValue(arqDadosServidor.Texto, '//UF[@nome="' + FUF + '"]/Servico[@acao="' + FServico + '"]/Url'); // 'http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx'; // ini
  FSOAPAction          := xmlNodeValue(arqDadosServidor.Texto, '//UF[@nome="' + FUF + '"]/Servico[@acao="' + FServico + '"]/SOAPAction'); // 'http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx'; // ini
  FRetorno.TagResposta := xmlNodeValue(arqDadosServidor.Texto, '//UF[@nome="' + FUF + '"]/Servico[@acao="' + FServico + '"]/TagResposta');
  FEnvelopeSoap        := DiretorioConfigBlocoX + '\templates\' + FUF + '\ped_' + FServico + '.xml';
  if xmlNodeValue(arqDadosServidor.Texto, '//UF[@nome="' + FUF + '"]/Servico[@acao="' + FServico + '"]/TimeOut') <> '' then
    FHttpReqResp.TimeOut := StrToIntDef(xmlNodeValue(arqDadosServidor.Texto, '//UF[@nome="' + FUF + '"]/Servico[@acao="' + FServico + '"]/TimeOut'), 3000);

  FreeAndNil(arqDadosServidor); // Sandro Silva 2019-06-19 arqDadosServidor.Free; 
  Result := True;
end;

procedure TServiceBlocoXBase.SalvaArquivo(FileName: TFileName; sTexto: String);
var
  Arquivo: TArquivo;
begin
  Arquivo := TArquivo.Create;
  try
    Arquivo.Texto := sTexto;
    Arquivo.SalvarArquivo(FileName);
  except
  end;
  FreeAndNil(Arquivo); // Sandro Silva 2019-06-19 Arquivo.Free; 
end;

procedure TServiceBlocoXBase.SalvaXMLRecibo(sCaminho: String);
begin
  if FRetorno.Recibo <> '' then
  begin
    SalvaArquivo(sCaminho, FRetorno.XmlResposta);
  end;
end;

procedure TServiceBlocoXBase.SetFXmlFile(const Value: String);
var
  Arquivo: TArquivo;
begin
  FXmlFile := Value;
  Arquivo := TArquivo.Create;
  try
    Arquivo.LerArquivo(FXmlFile);
    FXML := Arquivo.Texto;
  except
  end;
  FreeAndNil(Arquivo); // Sandro Silva 2019-06-19   Arquivo.Free; 
end;

{ TEnvioReducaoZ }

constructor TEnvioReducaoZ.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TEnvioReducaoZ.Destroy;
begin

  inherited;
end;

function TEnvioReducaoZ.Enviar: Boolean;
var
  sArquivoResposta: String;
begin
  inherited Enviar;
  Result := False;
  try // Sandro Silva 2018-01-23
    FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FECF + '_' + LimpaNumero(FDTRefe) + '_' + FormatDateTime('yyyymmddHHnnss', Now))); // Sandro Silva 2018-11-22 FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FormatDateTime('yyyymmddHHnnss', Now)));

    FHttpReqResp.Url              := FUrl;
    FHttpReqResp.SOAPAction       := FSOAPAction;
    FHttpReqResp.MimeType         := FMimeType;
    FHttpReqResp.Charsets         := FCharSets;
    FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;
    FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FArquivoBase64Zip]);// Sandro Silva 2017-09-27  FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FCNPJ, FDataReferencia, FArquivoBase64Zip]);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) + '-env-reducaoz.xml', FHttpReqResp.Data);// Sandro Silva 2018-06-06  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-env-reducaoz.xml', FHttpReqResp.Data);

    FHttpReqResp.Execute(FmsResposta);
    FRetorno.msResposta := FmsResposta;

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) + '-ret-reducaoz.xml', FRetorno.XmlResposta);// Sandro Silva 2018-06-07  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-reducaoz.xml', FRetorno.XmlResposta);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) +'-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);// Sandro Silva 2018-06-07  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);

    sArquivoResposta := PASTA_RECIBOS_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + FECF + '_' + LimpaNumero(FDTRefe);
    if FRetorno.Recibo <> '' then
      sArquivoResposta := sArquivoResposta + '_Recibo_' + FRetorno.Recibo;
    sArquivoResposta := sArquivoResposta + '.xml';
    SalvaXMLRecibo(sArquivoResposta);

    Result := True;
  except

  end;
end;

{ TRetornoBlocoX }

procedure TRetornoBlocoX.Clear;
begin
  FmsResposta.Clear;
  FMensagem                       := '';
  FRecibo                         := '';
  FTipo                           := '';
  FEstadoProcessamentoDescricao   := '';
  FEstadoProcessamentoCodigo      := '';
  FSituacaoProcessamentoCodigo    := '';
  FSituacaoProcessamentoDescricao := '';
  FDataReferencia                 := '';
  FXmlResposta                    := '';
  FTagResposta                    := '';
  FSOAPResposta                   := '';
  inherited; // Sandro Silva 2018-09-27
end;

constructor TRetornoBlocoX.Create;
begin
  FmsResposta := TMemoryStream.Create;
end;

destructor TRetornoBlocoX.Destroy;
begin
  // Sandro Silva 2020-06-04 Causando Runtime error 216 a FmsResposta.Free;
  // Sandro Silva 2020-06-04
  inherited Destroy;// Sandro Silva 2020-04-14
  // inherited Destroy;
  //inherited; // Sandro Silva 2017-06-01
end;

procedure TRetornoBlocoX.SetFmsResposta(const Value: TMemoryStream);
var
  FslResposta: TStringList;
begin
  FslResposta := TStringList.Create;
  try
    FmsResposta := Value;
    FslResposta.LoadFromStream(FmsResposta);
    FSOAPResposta := FslResposta.Text;

    FSOAPResposta := StringReplace(FSOAPResposta, '&gt;', '>', [rfReplaceAll]);
    FSOAPResposta := StringReplace(FSOAPResposta, '&lt;', '<', [rfReplaceAll]);//xmlNodeValue(StringReplace(mmResponse.Text, '&lt;', '<', [rfReplaceAll]), '//ConsultarResult');

    FSOAPResposta := StringReplace(FSOAPResposta, #$D#$A, '', [rfReplaceAll]); // Sandro Silva 2019-07-19

    FslResposta.Text := ProcessaResposta(FslResposta.Text, FTagResposta);

    SetFXmlResposta(FslResposta.Text);
  except
  end;
  FreeAndNil(FslResposta); // Sandro Silva 2019-07-19 FslResposta.Free;
end;

procedure TRetornoBlocoX.SetFXmlResposta(const Value: String);
begin
  FXmlResposta := Value;

  if Pos(' ', Trim(xmlNodeValue(FXmlResposta, '//Recibo'))) = 0 then
    FRecibo                       := xmlNodeValue(FXmlResposta, '//Recibo');
  FTipo                           := xmlNodeValue(FXmlResposta, '//Tipo');
  FDataReferencia                 := xmlNodeValue(FXmlResposta, '//DataReferencia');
  FEstadoProcessamentoCodigo      := xmlNodeValue(FXmlResposta, '//EstadoProcessamentoCodigo');
  FEstadoProcessamentoDescricao   := xmlNodeValue(FXmlResposta, '//EstadoProcessamentoDescricao');
  FMensagem                       := xmlNodeValue(FXmlResposta, '//Mensagem');
  FSituacaoProcessamentoCodigo    := xmlNodeValue(FXmlResposta, '//SituacaoProcessamentoCodigo');
  FSituacaoProcessamentoDescricao := xmlNodeValue(FXmlResposta, '//SituacaoProcessamentoDescricao');

  {Sandro Silva 2019-07-19 inicio}
  if FSituacaoProcessamentoCodigo = '' then
    FSituacaoProcessamentoCodigo     := xmlNodeValue(FXmlResposta, '//SituacaoOperacaoCodigo');

  if FSituacaoProcessamentoDescricao = '' then
    FSituacaoProcessamentoDescricao := xmlNodeValue(FXmlResposta, '//SituacaoOperacaoDescricao');

  if FMensagem = '' then
    FMensagem := FSituacaoProcessamentoDescricao;
  {Sandro Silva 2019-07-19 fim}
end;

{ TEnvioEstoque }

constructor TEnvioEstoque.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TEnvioEstoque.Destroy;
begin

  inherited;
end;

function TEnvioEstoque.Enviar: Boolean;
var
  sArquivoResposta: String;
begin
  inherited Enviar;

  Result := False;
  try // Sandro Silva 2018-01-23
    FArquivoBase64Zip      := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FormatDateTime('yyyymmddHHnnss', Now)));

    FHttpReqResp.Url              := FUrl;
    FHttpReqResp.SOAPAction       := FSOAPAction;
    FHttpReqResp.MimeType         := FMimeType;
    FHttpReqResp.Charsets         := FCharSets;
    FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;
    FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FArquivoBase64Zip]);// Sandro Silva 2017-09-27  FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FCNPJ, FDataReferenciaInicial, FDataReferenciaFinal, FArquivoBase64Zip]);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + LimpaNumero(FDataReferenciaInicial) + '_' + LimpaNumero(FDataReferenciaFinal) + '-env-estoque.xml', FHttpReqResp.Data);

    FHttpReqResp.Execute(FmsResposta);
    FRetorno.msResposta := FmsResposta;

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + LimpaNumero(FDataReferenciaInicial) + '_' + LimpaNumero(FDataReferenciaFinal) + '-ret-estoque.xml', FRetorno.XmlResposta);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + LimpaNumero(FDataReferenciaInicial) + '_' + LimpaNumero(FDataReferenciaFinal) + '-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);

    sArquivoResposta := PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + Copy(LimpaNumero(FDTRefe), 5, 2) + Copy(LimpaNumero(FDTRefe), 1, 4); // Sandro Silva 2019-06-21 ER 02.06 sArquivoResposta := PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + Copy(LimpaNumero(FDTRefe), 1, 6) + '01_' + LimpaNumero(FDTRefe);
    if FRetorno.Recibo <> '' then
      sArquivoResposta := sArquivoResposta + '_Recibo_' + FRetorno.Recibo;
    sArquivoResposta := sArquivoResposta + '.xml';
    SalvaXMLRecibo(sArquivoResposta);// Sandro Silva 2018-02-06  SalvaXMLRecibo(PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + LimpaNumero(FDTRefe) + '.xml');
    Result := True;
  except

  end;
end;

{ TConsulta }

constructor TConsultaRecibo.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TConsultaRecibo.Destroy;
begin

  inherited;
end;

function TConsultaRecibo.Enviar: Boolean;
var
  sNomeArquivoXmlSalvo: String;
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;
      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FRecibo, FArquivoBase64Zip]);

      if FSerieECF <> '' then
        sNomeArquivoLog := FRecibo + '_' + FSerieECF + '_' + FDataReferencia
      else
        sNomeArquivoLog := FRecibo + '_' + FDataReferencia;

      // Sandro Silva 2018-11-23  if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
        SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-consulta.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      // Sandro Silva 2018-11-23 if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-consulta.xml', FRetorno.XmlResposta);

      if FTipo = 'ESTOQUE' then
      begin
        FSerieECF := '';
        {Sandro Silva 2019-06-21 inicio ER 02.06
        if (LimpaNumero(FDataReferenciaInicial) <> '') and (LimpaNumero(FDataReferenciaFinal) <> '') then
        begin
          sNomeArquivoXmlSalvo := PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + LimpaNumero(FDataReferenciaInicial) + '_' + LimpaNumero(FDataReferenciaFinal);
        end;
        }
        if (LimpaNumero(FDataReferenciaFinal) <> '') then
        begin
          sNomeArquivoXmlSalvo := PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + Copy(LimpaNumero(FDataReferenciaFinal), 1, 4) + Copy(LimpaNumero(FDataReferenciaFinal), 5, 2);
        end;
        {Sandro Silva 2019-06-21 fim}
      end;

      if FTipo = 'REDUCAO' then
      begin
        if xmlNodeValue(FXML, '//Ecf/NumeroFabricacao') <> '' then // Sandro Silva 2017-12-27 Polimig Consulta de recibo não tem o número do ECF
          FSerieECF := xmlNodeValue(FXML, '//Ecf/NumeroFabricacao');
        sNomeArquivoXmlSalvo := PASTA_RECIBOS_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + FSerieECF + '_' + LimpaNumero(FDataReferencia);
      end;

      sNomeArquivoXmlSalvo := sNomeArquivoXmlSalvo + '_Recibo_' + FRecibo + '.xml';
      SalvaXMLRecibo(sNomeArquivoXmlSalvo);
      Result := True;
    except

    end;

  end; // if FCertificado <> nil then
end;

(*
{ TArquivo }

procedure TArquivo.LerArquivo(FileName: TFileName);
var
  sLinha: String;
begin
  FTexto := '';
  if FileExists(FileName) then
  begin
    try
      AssignFile(FArquivo, FileName);
      Reset(FArquivo); //abre o arquivo para leitura;
      while not Eof(FArquivo) do
      begin
        Readln(FArquivo, slinha); //lê do arquivo e desce uma linha. O conteúdo lido é transferido para a variável linha
        if FTexto <> '' then
          FTexto := FTexto + #10 + #13;
        FTexto := FTexto + sLinha; //adiciona a um campo Memo
      end;
    except

    end;
    Closefile(FArquivo);
  end;
end;

procedure TArquivo.SalvarArquivo(FileName: TFileName);
begin
  try
    AssignFile(FArquivo, pChar(FileName));
    Rewrite(FArquivo);
    Writeln(FArquivo, FTexto);
    CloseFile(FArquivo);                                    // Fecha o arquivo
  except

  end;
end;
*)
{ TValidarXMLBlocoX }

constructor TValidarXMLBlocoX.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TValidarXMLBlocoX.Destroy;
begin

  inherited;
end;

function TValidarXMLBlocoX.Enviar: Boolean;
var
  spValidarPafEcfEEcf, spValidarAssinaturaDigital: String;
begin
  inherited Enviar;

  Result := False;  
  try // Sandro Silva 2018-01-23
    spValidarPafEcfEEcf := 'false';
    if FpValidarPafEcfEEcf = '1' then
     spValidarPafEcfEEcf := 'true';
    spValidarAssinaturaDigital := 'false';
    if FpValidarAssinaturaDigital = '1' then
      spValidarAssinaturaDigital := 'true';

    FArquivoBase64Zip             := '<![CDATA[' + FXML + ']]>';// Base64Encode(ZipFile(FXmlFile, 'BlocoX\' + FormatDateTime('yyyymmddHHnnss', Now)));
    FHttpReqResp.Url              := FUrl;
    FHttpReqResp.SOAPAction       := FSOAPAction;
    FHttpReqResp.MimeType         := FMimeType;
    FHttpReqResp.Charsets         := FCharSets;
    FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;
    FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [spValidarPafEcfEEcf, spValidarAssinaturaDigital, FArquivoBase64Zip]);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-env-' + FServico + '.xml', FHttpReqResp.Data);

    FHttpReqResp.Execute(FmsResposta);
    FRetorno.msResposta := FmsResposta;

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-' + FServico + '.xml', FRetorno.XmlResposta);

    if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);

    SalvaXMLRecibo(PASTA_VALIDACAO_BLOCO_X);
    Result := True;
  except

  end;
end;

{ TConsultaPendenciaContribuinte }

constructor TConsultaPendenciaContribuinte.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TConsultaPendenciaContribuinte.Destroy;
begin

  inherited;
end;

function TConsultaPendenciaContribuinte.Enviar: Boolean;
var
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      //FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FIEContribuinte + '_' + FormatDateTime('yyyymmddHHnnss', Now))); // Sandro Silva 2018-11-22 FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FormatDateTime('yyyymmddHHnnss', Now)));

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FXML]);

      sNomeArquivoLog := FIEContribuinte;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-consultapendenciacontribuinte.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-consultapendenciacontribuinte.xml', FRetorno.XmlResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then
end;

{ TConsultarPendenciasDesenvolvedorPafEcf }

constructor TConsultarPendenciasDesenvolvedorPafEcf.Create(
  AOwner: TComponent);
begin
  inherited;

end;

destructor TConsultarPendenciasDesenvolvedorPafEcf.Destroy;
begin

  inherited;
end;

function TConsultarPendenciasDesenvolvedorPafEcf.Enviar: Boolean;
var
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FXML]);

      sNomeArquivoLog := FCNPJDesenvolvedor;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-' + AnsiLowerCase(FServico) + '.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-' + AnsiLowerCase(FServico) + '.xml', FRetorno.XmlResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then

end;

{ TConsultarProcessamentoArquivo }

constructor TConsultarProcessamentoArquivo.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TConsultarProcessamentoArquivo.Destroy;
begin

  inherited;
end;

function TConsultarProcessamentoArquivo.Enviar: Boolean;
var
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FXML]);

      sNomeArquivoLog := FRecibo;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-consultarprocessamentoarquivo.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-consultarprocessamentoarquivo.xml', FRetorno.XmlResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then

end;

{ TTransmitirReducaoZ }

constructor TTransmitirReducaoZ.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TTransmitirReducaoZ.Destroy;
begin

  inherited;
end;

function TTransmitirReducaoZ.Enviar: Boolean;
var
  //sNomeArquivoLog: String;
  sArquivoResposta: String;
begin
  inherited Enviar;

// Retorna erro: The server cannot service the request because the media type is unsupported.

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23

      FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FECF + '_' + LimpaNumero(FDTRefe) + '_' + FormatDateTime('yyyymmddHHnnss', Now))); // Sandro Silva 2018-11-22 FArquivoBase64Zip := Base64Encode(ZipFile(FXmlFile, DiretorioLogBlocoX + '\' + FormatDateTime('yyyymmddHHnnss', Now)));

      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FArquivoBase64Zip]);// Sandro Silva 2017-09-27  FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FCNPJ, FDataReferencia, FArquivoBase64Zip]);

      if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
        SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) + '-env-reducaoz.xml', FHttpReqResp.Data);// Sandro Silva 2018-06-06  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-env-reducaoz.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
        SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) + '-ret-reducaoz.xml', FRetorno.XmlResposta);// Sandro Silva 2018-06-07  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-reducaoz.xml', FRetorno.XmlResposta);

      if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then // Sandro Silva 2018-10-19
        SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FECF + '_' + LimpaNumero(FDTRefe) +'-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);// Sandro Silva 2018-06-07  SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-ret-soap-' + FServico + '.xml', FRetorno.SOAPResposta);

      sArquivoResposta := PASTA_RECIBOS_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + FECF + '_' + LimpaNumero(FDTRefe);
      if FRetorno.Recibo <> '' then
        sArquivoResposta := sArquivoResposta + '_Recibo_' + FRetorno.Recibo;
      sArquivoResposta := sArquivoResposta + '.xml';
      SalvaXMLRecibo(sArquivoResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then

end;

{ TReprocessarArquivo }

constructor TReprocessarArquivo.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TReprocessarArquivo.Destroy;
begin

  inherited;
end;

function TReprocessarArquivo.Enviar: Boolean;
var
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FXML]);

      sNomeArquivoLog := FRecibo;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-reprocessararquivo.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-reprocessararquivo.xml', FRetorno.XmlResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then


end;

{ TCancelarArquivo }

constructor TCancelarArquivo.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCancelarArquivo.Destroy;
begin

  inherited;
end;

function TCancelarArquivo.Enviar: Boolean;
var
  sNomeArquivoLog: String;
begin
  inherited Enviar;

  Result := False;

  if FCertificado <> nil then // Sandro Silva 2018-02-01
  begin

    try // Sandro Silva 2018-01-23
      FHttpReqResp.Url              := FUrl;
      FHttpReqResp.SOAPAction       := FSOAPAction;
      FHttpReqResp.MimeType         := FMimeType;
      FHttpReqResp.Charsets         := FCharSets;
      FHttpReqResp.EncodeDataToUTF8 := FEncodeDataToUTF8;

      FHttpReqResp.Data             := Format(LoadEnvelopeSoap(FEnvelopeSoap), [FXML]);

      sNomeArquivoLog := FRecibo;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-env-cancelararquivo.xml', FHttpReqResp.Data);

      FHttpReqResp.Execute(FmsResposta);
      FRetorno.msResposta := FmsResposta;

      SalvaArquivo(DiretorioLogBlocoX + '\' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '_' + sNomeArquivoLog + '-ret-cancelararquivo.xml', FRetorno.XmlResposta);

      Result := True;
    except

    end;

  end; // if FCertificado <> nil then

end;

end.
