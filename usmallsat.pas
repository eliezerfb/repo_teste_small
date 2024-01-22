{ *********************************************************************** }
{ Interfaceamento e comunicação com equipamento SAT                       }
{ Compatível com Delphi 7 ou superior                                     }
{                                                                         }
{ Equipamento compatíveis:                                                }
{ DIMEP, SWEDA, TANCA, GERTEC, URANO, BEMATECH, ELGIN, KRYPTUS, NITERE,   }
{ DARUMA, EPSON, CONTROL ID                                               }
{ DIMEP:                                                                  }
{ - Caminho FTP: ftp://dsat.dimep.com.br/dsat                             }
{ - Usuário: dsat                                                         }
{ - Senha: dsat@dimep                                                     }
{                                                                         }
{ Autor: Sandro Luis da Silva                                             }
{ *********************************************************************** }

unit usmallsat;

interface

uses
  {$IFDEF VER150}
  Windows, Messages, Variants, Classes, Dialogs, Controls, Forms, Graphics,
  SysUtils, StdCtrls, ComCtrls, Math, Printers, IniFiles, ExtCtrls, JPEG,
  Winspool, RichEdit,
  ShellApi, Types, StrUtils, DateUtils,
  xmldom, XMLIntf, MsXml, msxmldom, XMLDoc,
  DB,
  IBQuery, IBDatabase, IBCustomDataSet,
  base64code,
  //SmallFunc
  {$ELSE}
  WinApi.Windows, Winapi.Messages, Winapi.ShellAPI, Winapi.RichEdit,
  Winapi.WinSpool,
  System.Variants, System.Classes, System.Types, System.StrUtils,
  System.SysUtils, System.Math, System.IniFiles, System.DateUtils,
  Vcl.Dialogs, Vcl.Controls, VCL.Forms, Vcl.Graphics, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Printers, Vcl.ExtCtrls, vcl.Imaging.jpeg,
  Xml.xmldom, Xml.XMLIntf, Winapi.msxml, Xml.Win.msxmldom, Xml.XMLDoc,
  Data.DB,
  IBX.IBQuery, IBX.IBDatabase, IBX.IBCustomDataSet,
  smallfunc_xe
  {$ENDIF}
  , CAPICOM_TLB
  , DelphiZXIngQRCode
  , tnpdf
  , umfe

  ;

const FABRICANTE_EMULADOR   = '00'; // SAT.DLL
const FABRICANTE_DIMEP      = '01'; // dllsat.dll
const FABRICANTE_SWEDA      = '02'; // SATDLL.DLL E SATSWEDA.INF
const FABRICANTE_TANCA      = '03'; // SAT.DLL e TANCA_SAT.INF
const FABRICANTE_GERTEC     = '04'; // GERSAT.DLL
const FABRICANTE_URANO      = '05'; // SAT.DLL, SAT64.DLL, cdm+v2.12.00+whql+certified.exe”
const FABRICANTE_BEMATECH   = '06'; // BemaSAT.dll
const FABRICANTE_ELGIN      = '07'; // dllsat.dll, linker II libstdc++-6.dll
const FABRICANTE_KRYPTUS    = '08'; // SAT.dll // 2015-10-04
const FABRICANTE_NITERE     = '09'; // dllsat.dll
const FABRICANTE_DARUMA     = '10'; // DarumaSat.dll
const FABRICANTE_EPSON      = '11'; // SAT-A10.dll Sandro Silva 2017-07-17
const FABRICANTE_CONTROLID  = '12'; // SAT.dll Sandro Silva 2018-03-29
const FABRICANTE_CS_DEVICES = '13'; // dllsat.dll Sandro Silva 2019-06-25

/// Modelos equipamento
const FABRICANTE_EMULADOR_GENERICO   = '00'; // SAT.DLL
const FABRICANTE_DIMEP_DSAT          = '01'; // dllsat.dll
const FABRICANTE_DIMEP_DSAT20        = '02'; //
const FABRICANTE_SWEDA_SS1000        = '01'; // SATDLL.DLL E SATSWEDA.INF
const FABRICANTE_SWEDA_SS2000        = '02'; //
const FABRICANTE_TANCA_TS1000        = '01'; // SAT.DLL e TANCA_SAT.INF
const FABRICANTE_GERTEC_GERSAT       = '01'; // GERSAT.DLL
const FABRICANTE_GERTEC_GERSATW      = '02'; //
const FABRICANTE_URANO_SATUR         = '01'; // SAT.DLL, SAT64.DLL, cdm+v2.12.00+whql+certified.exe”
const FABRICANTE_URANO_USAT          = '02'; //
const FABRICANTE_BEMATECH_RB1000     = '01'; // BemaSAT.dll
const FABRICANTE_BEMATECH_RB2000     = '02'; //
const FABRICANTE_BEMATECH_SAT_GO     = '03'; // bemasat32.dll
const FABRICANTE_ELGIN_LINKER        = '01'; // dllsat.dll, linker II libstdc++-6.dll
const FABRICANTE_ELGIN_LINKER_II     = '02'; //
const FABRICANTE_ELGIN_SMART         = '03'; //
const FABRICANTE_KRYPTUS_EASYSAT     = '01'; // SAT.dll // 2015-10-04
const FABRICANTE_NITERE_NSAT4200     = '01'; // dllsat.dll
const FABRICANTE_DARUMA_DS100I       = '01'; // DarumaSat.dll
const FABRICANTE_EPSON_A10           = '01'; // SAT-A10.dll
const FABRICANTE_CONTROLID_SATID     = '01'; // SAT.dll Sandro Silva 2018-03-29
const FABRICANTE_CS_DEVICES_SATCR_A1 = '01'; // SAT.dll Sandro Silva 2018-03-29

const TIPO_EQUIPAMENTO_SAT = 'SAT';
const TIPO_EQUIPAMENTO_MFE = 'MFE';

const SIGLA_CFOP_ST_ECF                                 = 'CFOPECF';
const SIGLA_CLISTSERV                                   = 'CLISTSERV';
const _59_CFE_EMITIDO_COM_SUCESSO                       = 'CF-e-SAT Emitido com sucesso'; //Se alterar aqui precisa alterar na tabela NFCE e revisar as regras de validação de CF-e emitidos
const _59_CANCELAMENTO_COM_SUCESSO_MAIS_CONTEUDO_NOTAS  = 'Cancelado com sucesso + conteúdo notas';
const CRT_SIMPLES_NACIONAL                              = '1';
const CRT_SIMPLES_NACIONAL_EXCESSO_LIMITE_RECEITA_BRUTA = '2';
const CRT_REGIME_NORMAL                                 = '3';

const _59_CHAVE_CAMINHO_SERVIDOR       = 'Caminho Servidor';
const _59_CHAVE_VERSAO_DRIVER_MFE_1_05 = 'Driver MFE 1.05';

const _59_CHAVE_ASSINATURA_ASSOCIADA  = 'Assinatura Associada';

const _59_ASSINATURA_ASSOCIADA_INTEGRADOR  = 'MD2Nof/O0tQMPKiYeeAydSjYt7YV9kU0nWKZGXHVdYIzR2W9Z6tgXni/Y5bnjmUAk8MkqlBJIiOOIskKCjJ086k7vAP0EU5cBRYj/nzHUiRdu9AVD7WRfVs00BDyb5fsnnKg7gAXXH6SBgCx'+
                                             'G9yjAkxJ0l2E2idsWBAJ5peQEBZqtHytRUC+FLaSfd3+66QNxIBlDwQIRzUGPaU6fvErVDSfMUf8WpkwnPz36fCQnyLypqe/5mbox9pt3RCbbXcYqnR/4poYGr9M9Kymj4/PyX9xGeiXwbgzOOHNIU5M/aAs0rulXz948bZla0eXABgEcp6mDkTzweLPZTbmOhX+eA==';
const _59_ASSINATURA_ASSOCIADA_MFE         = 'CODIGO DE VINCULACAO AC DO MFE-CFE';
const _59_ASSINATURA_ASSOCIADA_SAT         = 'SGR-SAT SISTEMA DE GESTAO E RETAGUARDA DO SAT';
const _59_ASSINATURA_ASSOCIADA_EMULADOR_SP = '111111111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111111111222222222222221111' +
                                             '11111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111';

const FONT_NAME_DEFAULT = 'FontB88'; //2016-01-14 'Calibri';//'Arial Narrow';//'Sans Serif';//'Cambria';//'MS Sans Serif';// 'Calibri';
const FONT_SIZE_DEFAULT = 7; // 2015-06-29 8;//7;
const ALTURA_PAGINA_PDF = 2448;// 3508; // Sandro Silva 2017-04-17  2374;

// Comando padrões do Sat
const CMD_CONFIGURACAO               = 'Configuracao';
const CMD_ASSOCIARASSINATURA         = 'AssociarAssinatura';
const CMD_ATIVARSAT                  = 'AtivarSAT';
const CMD_BLOQUEARSAT                = 'BloquearSAT';
const CMD_CANCELARULTIMAVENDA        = 'CancelarUltimaVenda';
const CMD_CONSULTARNUMEROSESSAO      = 'ConsultarNumeroSessao';
const CMD_CONSULTARSAT               = 'ConsultarSAT';
const CMD_CONSULTARSTATUSOPERACIONAL = 'ConsultarStatusOperacional';
const CMD_DESBLOQUEARSAT             = 'DesbloquearSAT';
const CMD_DESLIGARSAT                = 'DesligarSAT';
const CMD_ENVIARDADOSVENDA           = 'EnviarDadosVenda';
const CMD_EXTRAIRLOGS                = 'ExtrairLogs';
const CMD_TESTEFIMAFIM               = 'TesteFimAFim';
const CMD_TROCARCODIGODEATIVACAO     = 'TrocarCodigoDeAtivacao';
const CMD_CONSULTARULTIMASESSAOFISCAL = 'ConsultarUltimaSessaoFiscal';

function LoadLibrarySS(lpFileName: pAnsiChar): LongWord; stdcall; external 'kernel32.dll' name 'LoadLibraryW';

type
  TAlinhamento = (poLeft, poRight, poCenter, poJustify);

  TAmbiente = (taProducao, taTeste);

  TDestinoExtrato = (toPrinter, toImage);

  TTipoExtrato = (tVenda, tCancelamento);

  // moAlone: Comunicação do PDV direta como equipamento SAT
  // moClient: Comunicação do PDV através do servidorsat.exe
  // moIntegradorMFe: Comunicação do PDV através do Integrador Fiscal da Sefaz (Ceará)
  // moServer: Servidor que recepciona solicitações do PDV usando moClient
  TModoOperacao = (moAlone, moClient, moIntegradorMFE, moServer);

  TMetodoChamadaDLL = (mcStdCall, mcCdecl);

  TRetornoSAT = array of String;

  TRetorno = class
    private
      FEEEEE: String;
      FnumeroSessao: String;
      Fcod: String;
      FmensagemSEFAZ: String;
      Fmensagem: String;
    procedure setFmensagem(const Value: String);
    procedure SetFmensagemSEFAZ(const Value: String);
    published
      property numeroSessao: String read FnumeroSessao write FnumeroSessao;
      property EEEEE: String read FEEEEE write FEEEEE;
      property mensagem: String read Fmensagem write setFmensagem;
      property cod: String read Fcod write Fcod;
      property mensagemSEFAZ: String read FmensagemSEFAZ write SetFmensagemSEFAZ;
  end;

  TRetornoFiscal = class(TRetorno)
    private
      FCCCC: String;
      FArquivoCFeBase64: String;
      FChaveConsulta: String;
      FvalorTotalCFe: String;
      FassinaturaQRCODE: String;
      FtimeStamp: String;
      FCPFCNPJAdquirente: String;
    published
      property CCCC: String read FCCCC write FCCCC;
      property ArquivoCFeBase64: String read FArquivoCFeBase64 write FArquivoCFeBase64;
      property ChaveConsulta: String read FChaveConsulta write FChaveConsulta;
      property timeStamp: String read FtimeStamp write FtimeStamp;
      property valorTotalCFe: String read FvalorTotalCFe write FvalorTotalCFe;
      property CPFCNPJAdquirente: String read FCPFCNPJAdquirente write FCPFCNPJAdquirente;
      property assinaturaQRCODE: String read FassinaturaQRCODE write FassinaturaQRCODE;
  end;

  TConsultarSATRetorno = class(TRetorno)
  end;

  TRetornoExtrairLogs = class(TRetorno)
    private
      FArquivoLogBase64: String;
    public
      constructor Create;
      destructor Destroy; override;
      property ArquivoLogBase64: String read FArquivoLogBase64 write FArquivoLogBase64;
  end;

  TRetornoEnviarDadosVenda = class(TRetornoFiscal)
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

  TRetornoCancelarUltimaVenda = class(TRetornoFiscal)
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

  TRetornoConsultarStatusOperacional = class(TRetorno)
    private
      FConteudoRetorno: String;
      FNumeroSerie: String;
    public
      property ConteudoRetorno: String read FConteudoRetorno write FConteudoRetorno;
      property NumeroSerie: String read FNumeroSerie write FNumeroSerie;
      constructor Create;
      destructor Destroy; override;
  end;

  TRetornoTesteFimaFim = class(TRetornoFiscal)
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

  TEmitente = class
  private
    FIM: String;
    FIE: String;
    FCNPJ: String;
    FUF: String;
    procedure SetCNPJ(const Value: String);
    procedure SetIE(const Value: String);
    procedure SetIM(const Value: String);
    procedure SetFUF(const Value: String);
    published
      property CNPJ: String read FCNPJ write SetCNPJ;
      property IE: String read FIE write SetIE;
      property IM: String read FIM write SetIM;
      property UF: String read FUF write SetFUF;
  end;

  TRequisicao = class
  private
    FCaixa: String;
    FComando: String;
    FDadosVenda: String;
    FDadosCancelamento: String;
    FDiretorioAtual: String;
    FCaminhoComunicacao: String;
    function GerarRequisicao(sConteudo: String): String;
  public
  published
    procedure Clear;
    function Enviar: String;
    property DiretorioAtual: String read FDiretorioAtual write FDiretorioAtual;
    property CaminhoComunicacao: String read FCaminhoComunicacao write FCaminhoComunicacao;
    property Caixa: String read FCaixa write FCaixa;
    property Comando: String read FComando write FComando;
    property DadosVenda: String read FDadosVenda write FDadosVenda;
    property DadosCancelamento: String read FDadosCancelamento write FDadosCancelamento;
  end;

  TSmall59 = class(TComponent)
  private
    //Chamadas usando stdcall
    _AssociarAssinatura_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; CNPJvalue: PAnsiChar; assinaturaCNPJs: PAnsiChar): PAnsiChar; stdcall;
    _AtivarSAT_stdcall: function(numeroSessao: Longint; subComando: Longint; codigoDeAtivacao: PAnsiChar; CNPJ: PAnsiChar; cUF: Longint): PAnsiChar; stdcall;
    _BloquearSAT_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; stdcall;
    _CancelarUltimaVenda_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; chave: PAnsiChar; dadosCancelamento: PAnsiChar): PAnsiChar; stdcall;
    _ConsultarNumeroSessao_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; cNumeroDeSessao: Longint): PAnsiChar; stdcall;
    _ConsultarSAT_stdcall: function(numeroSessao: Longint): PAnsiChar; stdcall;
    _ConsultarStatusOperacional_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; stdcall;
    _DesbloquearSAT_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; stdcall;
    _DesligarSAT_stdcall: function: PAnsiChar; stdcall;
    _EnviarDadosVenda_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; dadosVenda: PAnsiChar): PAnsiChar; stdcall;
    _ExtrairLogs_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; stdcall;
    _TesteFimAFim_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; dadosVenda: PAnsiChar): PAnsiChar; stdcall;
    _TrocarCodigoDeAtivacao_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; opcao: Longint; novoCodigo: PAnsiChar; confNovoCodigo: PAnsiChar): PAnsiChar; stdcall;
    _ConsultarUltimaSessaoFiscal_stdcall: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; stdcall;  // Não testada

    // Chamadas usando cdecl (Emulador e Gertec)
    _AssociarAssinatura_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; CNPJvalue: PAnsiChar; assinaturaCNPJs: PAnsiChar): PAnsiChar; cdecl;
    _AtivarSAT_cdecl: function(numeroSessao: Longint; subComando: Longint; codigoDeAtivacao: PAnsiChar; CNPJ: PAnsiChar; cUF: Longint): PAnsiChar; cdecl;
    _BloquearSAT_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; cdecl;
    _CancelarUltimaVenda_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; chave: PAnsiChar; dadosCancelamento: PAnsiChar): PAnsiChar; cdecl;
    _ConsultarNumeroSessao_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; cNumeroDeSessao: Longint): PAnsiChar; cdecl;
    _ConsultarSAT_cdecl: function(numeroSessao: Longint): PAnsiChar; cdecl;
    _ConsultarStatusOperacional_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; cdecl;
    _DesbloquearSAT_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; cdecl;
    _DesligarSAT_cdecl: function: PAnsiChar; cdecl;
    _EnviarDadosVenda_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; dadosVenda: PAnsiChar): PAnsiChar; cdecl;
    _ExtrairLogs_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; cdecl;
    _TesteFimAFim_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; dadosVenda: PAnsiChar): PAnsiChar; cdecl;
    _TrocarCodigoDeAtivacao_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar; opcao: Longint; novoCodigo: PAnsiChar; confNovoCodigo: PAnsiChar): PAnsiChar; cdecl;
    _ConsultarUltimaSessaoFiscal_cdecl: function(numeroSessao: Longint; codigoDeAtivacao: PAnsiChar): PAnsiChar; cdecl; // Não testada

    FIBDATABASE: TIBDatabase;
    FhDLL: THandle;
    //FDLLSatName: AnsiString; // Sandro Silva 2021-06-25
    FDLLSatName: String;
    FCaminhoInstalado: String; // caminho onde está instalado o Small, usado para ler arquivos da pasta de instalação
    FNumeroSerie: String;// 2013-01-22
    FExtratoDetalhado: Boolean;
    FRetornoVenda: TRetornoEnviarDadosVenda;
    FRetornoStatusOperacional: TRetornoConsultarStatusOperacional;
    FRetornoCancelamento: TRetornoCancelarUltimaVenda;
    FRetornoTesteFimAFim: TRetornoTesteFimaFim;
    FRetornoExtrairLogs: TRetornoExtrairLogs;
    FCodigoAtivacao: AnsiString; // Sandro Silva 2021-06-23 FCodigoAtivacao: String;
    FAssinaturaAssociada: String;
    aGerado: Array[1..100] of Integer;
    iPosicaoSessaoDuplicada: Integer;
    FCursor: TCursor;
    FCFeXML: String;
    FCFeID: String;
    FCFeStatus: String;
    FAmbiente: String;
    FRespostaSAT: String;
    FFabricante: String;
    FEmitente: TEmitente;
    FModeloDocumento: String;
    FArquivoAssinatura: String;
    FnCFe: String;
    FImprimirExtrato: Boolean;
    FVisualizarExtrato: Boolean;
    FCFehEmi: String;
    FCFedEmi: TDate;
    FVersaoDadosEnt: String;
    FCNPJSoftwareHouse: String;
    FCodigoRetornoConsultarSAT: String;
    FTributosMunicipais: Double;
    FTributosEstaduais: Double;
    FTributosFederais: Double;
    FMensagemPromocional: String;
    FEmOperacao: Boolean;
    FUltimoNumeroCupom: String;
    FLogComando: String;
    FIBDATASET27: TIBDataSet;
    FCaixa: String;
    FBloqueioAutonomo: Boolean;
    FCodigoRetornoSAT: String;
    FDescricaoRetornoSAT: String;
    FMensagemSEFAZ: String;
    FDiretorioAtual: String;
    FXMLDadosVenda: AnsiString; // Sandro Silva 2021-06-25 FXMLDadosVenda: String;
    FLogRetornoMobile: String;
    FAvancoPapel: Integer;
    FModoOperacao: TModoOperacao;
    FCaminhoComunicacao: String;
    FSessao: Integer;
    FMensagemSAT: String;
    FMedotoChamadaDLL: TMetodoChamadaDLL;
    FRequisicao: TRequisicao;
    FConteudoStatusOperacional: String;
    FConfiguracaoCasasDecimaisQtd: String;
    FConfiguracaoCasasDecimaisPreco: String;
    FIntegradorMFE: TIntegradorFiscal;
    FTipoEquipamento: String;
    FOrientacaoConsultarQRCode: String;
    FFabricanteModelo: String;
    FFabricanteCodigo: String;
    FTamanhoPapel: String;
    FForcarComunicacaoComSat: Boolean;
    FVersaoLeiauteTabelaInformacoes: String;
    //FKitDesenvolvimento: Boolean;
    FDriverMFE01_05_15_Superior: Boolean;
    function Chamadacdecl: Boolean;
    function Explode(Texto, Separador: String): TStrings; overload;
    function TiraQuebraLinha(sTexto: String): String;
    function EliminarEspaco(sTexto: String): String;
    function ExplodeRetorno(Texto: String): TRetornoSAT;
    procedure Import(var Proc: pointer; Name: PAnsiChar);
    function idSessao: Integer;
    function DescRetornoErroVenda(CCCC: String): String;
    procedure CarregaSATDLL;
    procedure SetFCaminhoSATDLL(const Value: String);
    function DescRetornoErroCancelamentoVenda(CCCC: String): String;
    function DescFormaPagamento(sCodigoForma: String): String;
    function GeraNumero: Integer;
    function GetAssinaturaAssociada: String;
    function GetAmbiente: String;
    procedure SetAmbiente(const Value: String);
    function GetRetorno: String;
    procedure ImagemQRCode(QRCodeData: String; APict: TBitMap);
    procedure SetFabricante(const Value: String);
    procedure SetCFehEmi(const Value: String);
    procedure SetCFedEmi(const Value: TDate);
    procedure SetVersaoDadosEnt(const Value: String);
    procedure SetCNPJSoftwareHouse(const Value: String);
    procedure SetCodigoRetornoStatus(const Value: String);
    procedure SetTributosEstaduais(const Value: Double);
    procedure SetTributosFederais(const Value: Double);
    procedure SetTributosMunicipais(const Value: Double);
    procedure SetMensagemPromocional(const Value: String);
    procedure SetEmOperacao(const Value: Boolean);
    procedure SetUltimoNumeroCupom(const Value: String);
    procedure SetLogComando(const Value: String);
    function GetDescricaoRetornoSAT: String;
    procedure SetDadosXML(const Value: AnsiString);
    procedure GravaLog(sLog: String);
    function GetFabricanteNome: String;
    procedure SetFMensagemSAT(const Value: String);
    procedure SetFDiretorioAtual(const Value: String);
    procedure SetCaminhoComunicacao(const Value: String);
    function GetCaminhoRequisicao: String;
    function GetCaminhoRetorno: String;
    procedure SetConteudoStatusOperacional(const Value: String);
    procedure SetFRespostaSAT(const Value: String);
    procedure SetConfiguracaoCasasDecimaisQtd(const Value: String);
    procedure SetConfiguracaoCasasDecimaisPreco(const Value: String);
    procedure SetCaixa(const Value: String);
    procedure SetFModoOperacao(const Value: TModoOperacao);
  protected
    FCaminhoSATDLL: String;
  public
    property CaminhoSATDLL: String read FCaminhoSATDLL write SetFCaminhoSATDLL; //nao carregar dll quando moCliente
    property IBDATABASE: TIBDatabase read FIBDATABASE write FIBDATABASE;
    property IBDATASET27: TIBDataSet read FIBDATASET27 write FIBDATASET27;
    property CodigoAtivacao: AnsiString read FCodigoAtivacao write FCodigoAtivacao; // Sandro Silva 2021-06-23 property CodigoAtivacao: String read FCodigoAtivacao write FCodigoAtivacao;
    property AssinaturaAssociada: String read GetAssinaturaAssociada;
    property NumeroSerieSAT: String read FNumeroSerie;
    property RetornoExtrairLogs: TRetornoExtrairLogs read FRetornoExtrairLogs;
    property RetornoVenda: TRetornoEnviarDadosVenda read FRetornoVenda;
    property RetornoCancelamento: TRetornoCancelarUltimaVenda read FRetornoCancelamento;
    property RetornoStatusOperacional: TRetornoConsultarStatusOperacional read FRetornoStatusOperacional;
    property RetornoTesteFimAFim: TRetornoTesteFimaFim read FRetornoTesteFimAFim;
    property RespostaSAT: String read FRespostaSAT write SetFRespostaSAT;
    property CaminhoInstalado: String read FCaminhoInstalado write FCaminhoInstalado;
    property Cursor: TCursor read FCursor write FCursor;
    property ExtratoDetalhado: Boolean read FExtratoDetalhado write FExtratoDetalhado;
    property CFeXML: String read FCFeXML write FCFeXML;
    property CFeID: String read FCFeID write FCFeID;
    property CFeStatus: String read FCFeStatus write FCFeStatus;
    property CFedEmi: TDate read FCFedEmi write SetCFedEmi;
    property CFehEmi: String read FCFehEmi write SetCFehEmi;
    property Ambiente: String read GetAmbiente write SetAmbiente;
    property Retorno: String read GetRetorno;
    property CodigoRetornoConsultarSAT: String read FCodigoRetornoConsultarSAT write SetCodigoRetornoStatus;
    property CodigoRetornoSAT: String read FCodigoRetornoSAT write FCodigoRetornoSAT;
    property DescricaoRetornoSAT: String read GetDescricaoRetornoSAT write FDescricaoRetornoSAT;
    property MensagemSEFAZ: String read FMensagemSEFAZ write FMensagemSEFAZ;
    property MensagemSat: String read FMensagemSAT write SetFMensagemSAT;
    property ConteudoStatusOperacional: String read FConteudoStatusOperacional write SetConteudoStatusOperacional;
    property nCFe: String read FnCFe write FnCFe; // 2014-10-22
    property ArquivoAssinatura: String read FArquivoAssinatura write FArquivoAssinatura; //2014-10-22
    property ImprimirExtrato: Boolean read FImprimirExtrato write FImprimirExtrato; // 2014-10-22
    property ModeloDocumento: String read FModeloDocumento write FModeloDocumento;
    property VisualizarExtrato: Boolean read FVisualizarExtrato write FVisualizarExtrato;
    property Fabricante: String read FFabricante write SetFabricante;
    property FabricanteCodigo: String read FFabricanteCodigo; // Sandro Silva 2017-07-11
    property FabricanteModelo: String read FFabricanteModelo;
    property FabricanteNome: String read GetFabricanteNome;
    property VersaoDadosEnt: String read FVersaoDadosEnt write SetVersaoDadosEnt;
    property Emitente: TEmitente read FEmitente;
    property Requisicao: TRequisicao read FRequisicao write FRequisicao;
    property CNPJSoftwareHouse: String read FCNPJSoftwareHouse write SetCNPJSoftwareHouse;
    property TributosFederais: Double read FTributosFederais write SetTributosFederais;
    property TributosEstaduais: Double read FTributosEstaduais write SetTributosEstaduais;
    property TributosMunicipais: Double read FTributosMunicipais write SetTributosMunicipais;
    property MensagemPromocional: String read FMensagemPromocional write SetMensagemPromocional;
    property EmOperacao: Boolean read FEmOperacao write SetEmOperacao;
    property UltimoNumeroCupom: String read FUltimoNumeroCupom write SetUltimoNumeroCupom;
    property LogComando: String read FLogComando write SetLogComando;
    property Caixa: String read FCaixa write SetCaixa;
    property BloqueioAutonomo: Boolean read FBloqueioAutonomo write FBloqueioAutonomo;
    property DiretorioAtual: String read FDiretorioAtual write SetFDiretorioAtual;
    //property XMLDadosVenda: String read FXMLDadosVenda write SetDadosXML;  // Sandro Silva 2016-08-25
    property XMLDadosVenda: AnsiString read FXMLDadosVenda write SetDadosXML;  // Sandro Silva 2016-08-25
    property AvancoPapel: Integer read FAvancoPapel write FAvancoPapel; // Sandro Silva 2016-08-25
    property ConfiguracaoCasasDecimaisQtd: String read FConfiguracaoCasasDecimaisQtd write SetConfiguracaoCasasDecimaisQtd;
    property ConfiguracaoCasasDecimaisPreco: String read FConfiguracaoCasasDecimaisPreco write SetConfiguracaoCasasDecimaisPreco;
    property LogRetornoMobile: String read FLogRetornoMobile write FLogRetornoMobile; {Sandro Silva 2016-08-25 inicio}
    property ModoOperacao: TModoOperacao read FModoOperacao write SetFModoOperacao; // Sandro Silva 2021-08-23 property ModoOperacao: TModoOperacao read FModoOperacao write FModoOperacao; // Sandro Silva 2016-08-25
    property CaminhoComunicacao: String read FCaminhoComunicacao write SetCaminhoComunicacao;
    property CaminhoRequisicao: String read GetCaminhoRequisicao;
    property CaminhoRetorno: String read GetCaminhoRetorno;
    property Sessao: Integer read FSessao write FSessao;
    property MetodoChamadaDLL: TMetodoChamadaDLL read FMedotoChamadaDLL write FMedotoChamadaDLL; // Sandro Silva 2017-01-09
    property IntegradorMFE: TIntegradorFiscal read FIntegradorMFE write FIntegradorMFE;
    property TipoEquipamento: String read FTipoEquipamento write FTipoEquipamento;
    property OrientacaoConsultarQRCode: String read FOrientacaoConsultarQRCode write FOrientacaoConsultarQRCode;
    property TamanhoPapel: String read FTamanhoPapel write FTamanhoPapel;
    property ForcarComunicacaoComSat: Boolean read FForcarComunicacaoComSat write FForcarComunicacaoComSat; // Sandro Silva 2019-02-27
    property VersaoLeiauteTabelaInformacoes: String read FVersaoLeiauteTabelaInformacoes write FVersaoLeiauteTabelaInformacoes; // Sandro Silva 2019-06-04
    property DriverMFE01_05_15_Superior: Boolean read FDriverMFE01_05_15_Superior write FDriverMFE01_05_15_Superior; // Sandro Silva 2021-08-23

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Inicializa;
    procedure Desinicializa;
    function SATAssociarAssinatura(codigoDeAtivacao: AnsiString;
      CNPJEmitente: AnsiString; assinaturaCNPJs: AnsiString;
      mmLog: TMemo = nil): String;
    function SATAtivarSAT(subComando: Integer; codigoDeAtivacao: AnsiString;
      CNPJ: String; cUF: String; mmLog: TMemo = nil): String;
    function SATBloquear(codigoDeAtivacao: AnsiString; mmLog: TMemo = nil): String;
    function SATCancelarUltimaVenda(XMLVenda: AnsiString;
      mmLog: TMemo = nil): Boolean; // Sandro Silva 2017-02-10  String; // Sandro Silva 2017-01-13 Acertar qdo testado com kryptus  Boolean;
    function SATConsultarNumeroSessao(codigoDeAtivacao: AnsiString;
      cNumeroDeSessao: Integer; mmLog: TMemo = nil): String;
    function SATConsultar(bExibeRetorno: Boolean;
      bExibirMensagemSefaz: Boolean; mmLog: TMemo = nil): Boolean;
    function SATConsultarStatusOperacional(mmLog: TMemo = nil;
      bExibeRetorno: Boolean = False): Boolean;
    function SATDesbloquear(codigoDeAtivacao: AnsiString; mmLog: TMemo = nil): String;
    function SATDesligar(mmLog: TMemo = nil): String;
    function SATEnviarDadosVenda(mmLog: TMemo): Boolean; // Sandro Silva 2017-02-20  var mmLog: TMemo): Boolean;
    function SATExtrairLogs(bExibir: Boolean = True;
      mmLog: TMemo = nil): String;
    function SATTesteFimAFim(mmLog: TMemo = nil): Boolean;// String;
    function SATTrocarCodigoDeAtivacao(codigoDeAtivacao: AnsiString;
      novoCodigo: AnsiString; confNovoCodigo: AnsiString; mmLog: TMemo = nil): String;
    function SATConsultarUltimaSessaoFiscal(): String; // Não testada
    function xmlNodeValue(sXML, sNode: String): String;
    function xmlNodeValueToDate(sXML, sNode: String): TDate;
    function xmlNodeValueToTime(sXML, sNode: String): TTime;
    function xmlNodeValueToFloat(sXML, sNode: String;
      sDecimalSeparator: String = '.'): Double;
    function ImprimirCupomDinamico(sCFeXML: String;
      Destino: TDestinoExtrato; Ambiente: String; sFileExport: String = ''): Boolean;
    function StatusRetornoSAT(sRetorno: String;
      bApenasRetorno: Boolean = False): String;
    function UFCodigo(sUF: String): String;
    function SalvaXML(xml: String): Boolean;
    procedure SalvaLogDadosEnviados(sTexto: String);
    function ConfiguracaoSATServidor: String;
  published

  end;

procedure Register;

var
  iLarguraPapel: Integer;
  iMargemEsq: Integer;

implementation

uses AJBarcode
  //, DelphiZXingQRCode
  ;

procedure Register;
begin
  RegisterComponents('Smallsoft', [TSmall59]);
end;

function TamanhoArquivo(Arquivo: String): Integer;
begin
  Result := 0;
  try
    if FileExists(Arquivo) then
    begin
      with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
        try
          Result := Size;
        finally
          Free;
        end;
    end;
  except
  end;
end;

procedure RenameLog(Arquivo: String);
var
  sFile: String;
  sExtensao: String;
begin
  try
    sFile := ExtractFileName(Arquivo);
    sExtensao := ExtractFileExt(Arquivo);
    RenameFile(Arquivo, ExtractFilePath(Arquivo) + StringReplace(sFile, sExtensao, '_' + FormatDateTime('yyyymmddHHnnss', Now) + sExtensao , [rfReplaceAll]));
  except

  end;
end;

function UFDescricao(sCodigo: String): String;
begin
  //Norte
  if sCodigo = '11' then Result := 'Rondônia';
  if sCodigo = '12' then Result := 'Acre';
  if sCodigo = '13' then Result := 'Amazonas';
  if sCodigo = '14' then Result := 'Roraima';
  if sCodigo = '15' then Result := 'Pará';
  if sCodigo = '16' then Result := 'Amapá';
  if sCodigo = '17' then Result := 'Tocantins';

  //Nordeste
  if sCodigo = '21' then Result := 'Maranhão';
  if sCodigo = '22' then Result := 'Piauí';
  if sCodigo = '23' then Result := 'Ceará';
  if sCodigo = '24' then Result := 'Rio Grande do Norte';
  if sCodigo = '25' then Result := 'Paraíba';
  if sCodigo = '26' then Result := 'Pernambuco';
  if sCodigo = '27' then Result := 'Alagoas';
  if sCodigo = '28' then Result := 'Sergipe';
  if sCodigo = '29' then Result := 'Bahia';

  //Sudeste
  if sCodigo = '31' then Result := 'Minas Gerais';
  if sCodigo = '32' then Result := 'Espírito Santo';
  if sCodigo = '33' then Result := 'Rio de Janeiro';
  if sCodigo = '35' then Result := 'São Paulo';

  //Sul
  if sCodigo = '41' then Result := 'Paraná';
  if sCodigo = '42' then Result := 'Santa Catarina';
  if sCodigo = '43' then Result := 'Rio Grande do Sul';

  //Centro' then Result := 'oeste
  if sCodigo = '50' then Result := 'Mato Grosso do Sul';
  if sCodigo = '51' then Result := 'Mato Grosso';
  if sCodigo = '52' then Result := 'Goiás';
  if sCodigo = '53' then Result := 'Distrito Federal';
end;

function UFSigla(sCodigo: String): String;
begin
  //Norte
  if sCodigo = '11' then Result := 'RO';
  if sCodigo = '12' then Result := 'AC';
  if sCodigo = '13' then Result := 'AM';
  if sCodigo = '14' then Result := 'RR';
  if sCodigo = '15' then Result := 'PA';
  if sCodigo = '16' then Result := 'AM';
  if sCodigo = '17' then Result := 'TO';

  //Nordeste
  if sCodigo = '21' then Result := 'MA';
  if sCodigo = '22' then Result := 'PI';
  if sCodigo = '23' then Result := 'CE';
  if sCodigo = '24' then Result := 'RN';
  if sCodigo = '25' then Result := 'PB';
  if sCodigo = '26' then Result := 'PE';
  if sCodigo = '27' then Result := 'AL';
  if sCodigo = '28' then Result := 'SE';
  if sCodigo = '29' then Result := 'BA';

  //Sudeste
  if sCodigo = '31' then Result := 'MG';
  if sCodigo = '32' then Result := 'ES';
  if sCodigo = '33' then Result := 'RJ';
  if sCodigo = '35' then Result := 'SP';

  //Sul
  if sCodigo = '41' then Result := 'PR';
  if sCodigo = '42' then Result := 'SC';
  if sCodigo = '43' then Result := 'RS';

  //Centro' then Result := 'oeste
  if sCodigo = '50' then Result := 'MS';
  if sCodigo = '51' then Result := 'MT';
  if sCodigo = '52' then Result := 'GO';
  if sCodigo = '53' then Result := 'DF';
end;

function TSmall59.UFCodigo(sUF: String): String;
begin
  //Norte
  if sUF = 'RO' then Result := '11';
  if sUF = 'AC' then Result := '12';
  if sUF = 'AM' then Result := '13';
  if sUF = 'RR' then Result := '14';
  if sUF = 'PA' then Result := '15';
  if sUF = 'AM' then Result := '16';
  if sUF = 'TO' then Result := '17';

  //Nordeste
  if sUF = 'MA' then Result := '21';
  if sUF = 'PI' then Result := '22';
  if sUF = 'CE' then Result := '23';
  if sUF = 'RN' then Result := '24';
  if sUF = 'PB' then Result := '25';
  if sUF = 'PE' then Result := '26';
  if sUF = 'AL' then Result := '27';
  if sUF = 'SE' then Result := '28';
  if sUF = 'BA' then Result := '29';

  //Sudeste
  if sUF = 'MG' then Result := '31';
  if sUF = 'ES' then Result := '32';
  if sUF = 'RJ' then Result := '33';
  if sUF = 'SP' then Result := '35';

  //Sul
  if sUF = 'PR' then Result := '41';
  if sUF = 'SC' then Result := '42';
  if sUF = 'RS' then Result := '43';

  //Centro' then Result := 'oeste
  if sUF = 'MS' then Result := '50';
  if sUF = 'MT' then Result := '51';
  if sUF = 'GO' then Result := '52';
  if sUF = 'DF' then Result := '53';
end;

function ValueXmlToFloat(Value: String): Double;
begin
  Result := StrToFloatDef(StringReplace(Value, '.', ',', [rfReplaceAll]), 0);
end;

function ExtraiDataXml(Value: String): String;
begin
  Result := Value;
  if Result <> '' then
    Result := Copy(Result, 7, 2) + '/' + Copy(Result, 5, 2) + '/' + Copy(Result, 1, 4);
end;

function ExtraiHoraXml(Value: String): String;
begin
  Result := Value;
  if Result <> '' then
    Result := Copy(Result, 1, 2) + ':' + Copy(Result, 3, 2) + ':' + Copy(Result, 5, 2);
end;

procedure ResizeBitmap(var Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if assigned(Bitmap) then
  begin
    B:= TBitmap.Create;
    try
      if Bitmap.Width > Bitmap.Height then
      begin
        R.Right:= Width;
        R.Bottom:= ((Width * Bitmap.Height) div Bitmap.Width);
        X:= 0;
        Y:= (Height div 2) - (R.Bottom div 2);
      end
      else
      begin
        R.Right:= ((Height * Bitmap.Width) div Bitmap.Height);
        R.Bottom:= Height;
        X:= (Width div 2) - (R.Right div 2);
        Y:= 0;
      end;
      R.Left:= 0;
      R.Top:= 0;
      B.PixelFormat:= Bitmap.PixelFormat;
      B.Width:= Width;
      B.Height:= Height;
      B.Canvas.Brush.Color:= Background;
      B.Canvas.FillRect(B.Canvas.ClipRect);
      B.Canvas.StretchDraw(R, Bitmap);
      Bitmap.Width:= Width;
      Bitmap.Height:= Height;
      Bitmap.Canvas.Brush.Color:= Background;
      Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
      Bitmap.Canvas.Draw(X, Y, B);
    finally
      B.Free;
    end;
  end;
end;

procedure QrCode(ATexto:String; bitmap: TBitmap);
var
  qr: TDelphiZXingQRCode;
  r: Integer;
  c: Integer;
begin
  try
    qr := TDelphiZXingQRCode.create;
    try
      qr.QuietZone := 2;
      qr.Encoding  := qrUTF8NoBOM;
      qr.Data := ATexto;

      // ajuta o tamanho do bitmap para o tamanho do qrcode
      //bitmap.SetSize(qr.Rows, qr.Columns);
      bitmap.Height := qr.Rows;
      bitmap.Width  := qr.Columns;

      // copia o qrcode para o bitmap
      for r := 0 to qr.Rows - 1 do
        for c := 0 to qr.Columns - 1 do
          if qr.IsBlack[r, c] then
            bitmap.Canvas.Pixels[c, r] := clBlack
          else
            bitmap.Canvas.Pixels[c, r] := clWhite;
    finally
      qr.Free;
    end;
  finally
  end;
end;

function EscalaPrinterQrCodeToCanvas(AWidth, AHeight: Integer; bitmap: TBitmap): Double;
var
  scala: Double;
begin
  try
    // prepara para redimensionar o qrcode para o tamanho do canvas
    if (AWidth < bitmap.Height) then
    begin
      scala := AWidth / bitmap.Width;
    end
    else
    begin
      scala := AHeight / bitmap.Height;
    end;

    Result := scala;
  finally
  end;
end;


{ TSmall59 }

constructor TSmall59.Create(AOwner: TComponent);
begin
  FEmitente                 := TEmitente.Create;
  FRetornoVenda             := TRetornoEnviarDadosVenda.Create;  // Sandro Silva 2016-11-24
  FRetornoCancelamento      := TRetornoCancelarUltimaVenda.Create; // Sandro Silva 2016-11-24
  FRetornoStatusOperacional := TRetornoConsultarStatusOperacional.Create; // Sandro Silva 2016-11-24
  FRetornoTesteFimAFim      := TRetornoTesteFimaFim.Create; // Sandro Silva 2016-11-24
  FRetornoExtrairLogs       := TRetornoExtrairLogs.Create;
  FRequisicao               := TRequisicao.Create; // Sandro Silva 2017-02-14
  //FIntegradorMFE            := TIntegradorFiscal.Create; // Sandro Silva 2017-05-08

  FVisualizarExtrato        := False;

  FModoOperacao             := moAlone; // Sandro Silva 2016-08-25

  FCaminhoComunicacao       := ExtractFilePath(Application.ExeName) + 'SAT'; // Sandro Silva 2017-03-03 '.\Sat';
  FOrientacaoConsultarQRCode := ''; // Sandro Silva 2017-05-20

  FForcarComunicacaoComSat := True; // Sempre começar com True Sandro Silva 2019-02-27

  FCursor := Screen.Cursor;

  // Sandro Silva 2016-11-10  Mobile_59 := TMobile.Create(nil);

  inherited Create(AOwner);
end;

destructor TSmall59.Destroy;
begin
  {Sandro Silva 2016-11-24 inicio}
  FreeAndNil(FRetornoVenda);
  FreeAndNil(FRetornoCancelamento);
  FreeAndNil(FRetornoStatusOperacional);
  FreeAndNil(FRetornoTesteFimAFim);
  FreeAndNil(FEmitente);
  FreeAndNil(FRequisicao);
  FreeAndNil(FRetornoExtrairLogs);

  Desinicializa;
  inherited;
end;

procedure TSmall59.CarregaSATDLL;
begin
  // Sandro Silva 2021-08-27 if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or FDriverMFE01_05_15_Superior then // Sandro Silva 2021-08-23 if (FModoOperacao = moAlone) or (FModoOperacao = moServer) then
  if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or (FDriverMFE01_05_15_Superior and (FModoOperacao <> moClient)) then
  begin
    if FhDLL = 0 then //Sandro Silva 2021-06-25
    begin

      try
        FDLLSatName := FCaminhoSATDLL; //informar o nome da dll

        if (FModoOperacao = moAlone) or (FModoOperacao = moServer) then // Sandro Silva 2021-08-23
        begin

          if FileExists(FDLLSatName) = False then
          begin

            FLogRetornoMobile := 'DLL para comunicação com o equipamento ' + FTipoEquipamento + ' não encontrada: ' + #13 + // Sandro Silva 2018-07-09  FLogRetornoMobile := 'DLL para comunicação com o equipamento SAT não encontrada ' + #13 + #13 +
                               FDLLSatName + #13 + #13;
            if Emitente.UF = 'CE' then
              FLogRetornoMobile := FLogRetornoMobile +
                                  'Execute os procedimentos:' + #13 +
                                  ' 1 - Acesse site https://cfe.sefaz.ce.gov.br/mfe/informacoes/downloads#/ ' + #13 +
                                  ' 2 - Faça o download do Instalador Driver MFE - 01.05.17 - Comunicação Direta - Windows ' + #13 +
                                  ' 3 - Execute o Instalador do Driver MFE' + #13 +
                                  ' 4 - Reinicie o ' + AnsiUpperCase(ExtractFileName(Application.ExeName));

            {Sandro Silva 2022-05-17 inicio
            //ShowMessage(FLogRetornoMobile);

            FecharAplicacao(ExtractFileName(Application.ExeName));
            FecharAplicacao(ExtractFileName(Application.ExeName));
            Abort;
            }

            MessageDlg(FLogRetornoMobile, mtWarning,[mbOk], 0);
            Exit;


          end
          else
          begin
            if Emitente.UF <> 'CE' then
            begin
              //Outras DLL usadas por FDLLSatName
              if FFabricanteCodigo = FABRICANTE_DIMEP then
              begin
                if FileExists(FDiretorioAtual + '\zlib.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'zlib.dll'), PChar(FDiretorioAtual + '\' + 'zlib.dll'), False);
                if FileExists(FDiretorioAtual + '\zlib.dll') = False then
                  ShowMessage('Copie o arquivo ZLIB.DLL para a pasta do ' + Application.ExeName);
              end;

              if FFabricanteCodigo = FABRICANTE_SWEDA then
              begin
                if FileExists(FDiretorioAtual + '\iconv.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'iconv.dll'), PChar(FDiretorioAtual + '\' + 'iconv.dll'), False);
                if FileExists(FDiretorioAtual + '\iconv.dll') = False then
                  ShowMessage('Copie o arquivo ICONV.DLL para a pasta do ' + Application.ExeName);

                if FileExists(FDiretorioAtual + '\libxml2.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'libxml2.dll'), PChar(FDiretorioAtual + '\' + 'libxml2.dll'), False);
                if FileExists(FDiretorioAtual + '\libxml2.dll') = False then
                  ShowMessage('Copie o arquivo LIBXML2.DLL para a pasta do ' + Application.ExeName);

                if FileExists(FDiretorioAtual + '\msvcp100.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'msvcp100.dll'), PChar(FDiretorioAtual + '\' + 'msvcp100.dll'), False);
                if FileExists(FDiretorioAtual + '\msvcp100.dll') = False then
                  ShowMessage('Copie o arquivo MSVCP100.DLL para a pasta do ' + Application.ExeName);

                if FileExists(FDiretorioAtual + '\msvcr100.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'msvcr100.dll'), PChar(FDiretorioAtual + '\' + 'msvcr100.dll'), False);
                if FileExists(FDiretorioAtual + '\msvcr100.dll') = False then
                  ShowMessage('Copie o arquivo MSVCR100.DLL para a pasta do ' + Application.ExeName);

                if FileExists(FDiretorioAtual + '\zlib1.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'zlib1.dll'), PChar(FDiretorioAtual + '\' + 'zlib1.dll'), False);
                if FileExists(FDiretorioAtual + '\zlib1.dll') = False then
                  ShowMessage('Copie o arquivo ZLIB1.DLL para a pasta do ' + Application.ExeName);
              end;

              if FFabricanteCodigo = FABRICANTE_ELGIN then
              begin
                if FileExists(FDiretorioAtual + '\zlib.dll') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'zlib.dll'), PChar(FDiretorioAtual + '\' + 'zlib.dll'), False);
                if FileExists(FDiretorioAtual + '\zlib.dll') = False then
                  ShowMessage('Copie o arquivo ZLIB.DLL para a pasta do ' + Application.ExeName);
              end;

              if FFabricanteCodigo = FABRICANTE_BEMATECH then
              begin
                if FileExists(FDiretorioAtual + '\bemasat.xml') = False then
                  CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'bemasat.xml'), PChar(FDiretorioAtual + '\' + 'bemasat.xml'), False);
                if FileExists(FDiretorioAtual + '\bemasat.xml') = False then
                  ShowMessage('Copie o arquivo bemasat.xml para a pasta do ' + Application.ExeName);
              end;
            end;
          end;
        end;

        {$IFDEF VER150}
        FhDLL := LoadLibrary(PChar(FDLLSatName)); //carregando dll
        {$ELSE}

        if AnsiContainsText(ExtractFileName(FDLLSatName), 'mfe.dll') then
        begin
          // Misteriosamente no Delphi Alexandria a função LoadLibrary(PChar(FDLLSatName)) retorna 0 se na pasta
          // de instalação do Small não tiver as DLL que a SEFAZ distribui com a MFE.DLL
          if FileExists(PChar(FDiretorioAtual + '\' + 'libgcc_s_dw2-1.dll')) = False then
            CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'libgcc_s_dw2-1.dll'), PChar(FDiretorioAtual + '\' + 'libgcc_s_dw2-1.dll'), False);
          if FileExists(PChar(FDiretorioAtual + '\' + 'libstdc++-6.dll')) = False then
            CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'libstdc++-6.dll'), PChar(FDiretorioAtual + '\' + 'libstdc++-6.dll'), False);
          if FileExists(PChar(FDiretorioAtual + '\' + 'libwinpthread-1.dll')) = False then
            CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'libwinpthread-1.dll'), PChar(FDiretorioAtual + '\' + 'libwinpthread-1.dll'), False);
          if FileExists(PChar(FDiretorioAtual + '\' + 'Qt5Core.dll')) = False then
            CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'Qt5Core.dll'), PChar(FDiretorioAtual + '\' + 'Qt5Core.dll'), False);
          if FileExists(PChar(FDiretorioAtual + '\' + 'Qt5Network.dll')) = False then
            CopyFile(PChar(ExtractFilePath(FCaminhoSATDLL) + 'Qt5Network.dll'), PChar(FDiretorioAtual + '\' + 'Qt5Network.dll'), False);
          Sleep(1000);
        end;

        FhDLL := LoadLibrary(PChar(FDLLSatName)); //carregando dll

        if FhDLL = 0 then
        begin
          if FFabricanteCodigo = FABRICANTE_ELGIN then
          begin
            //FhDLL := LoadLibraryA(PAnsiChar(FDLLSatName)); //carregando dll
            FhDLL := SafeLoadLibrary(FDLLSatName);
          end;
        end;
        {$ENDIF}

        if FhDLL = 0 then
          RaiseLastOSError; //raise Exception.Create('Não foi possível carregar a biblioteca ' + FDLLSatName);

        //importando métodos dinamicamente
        if Chamadacdecl then
        begin // Emulador e Gertec usam convenção cdecl
          Import(@_AtivarSat_cdecl, 'AtivarSAT');
          Import(@_AssociarAssinatura_cdecl, 'AssociarAssinatura');
          Import(@_BloquearSAT_cdecl, 'BloquearSAT');
          Import(@_CancelarUltimaVenda_cdecl, 'CancelarUltimaVenda');
          Import(@_ConsultarNumeroSessao_cdecl, 'ConsultarNumeroSessao');
          Import(@_ConsultarSAT_cdecl, 'ConsultarSAT');
          Import(@_ConsultarStatusOperacional_cdecl, 'ConsultarStatusOperacional');
          Import(@_DesbloquearSAT_cdecl, 'DesbloquearSAT');
          //Import(@_DesligarSAT_cdecl, 'DesligarSAT'); Alguns fabricantes não implementaram na sua dll
          Import(@_EnviarDadosVenda_cdecl, 'EnviarDadosVenda');
          Import(@_ExtrairLogs_cdecl, 'ExtrairLogs');
          Import(@_TesteFimAFim_cdecl, 'TesteFimAFim');
          Import(@_TrocarCodigoDeAtivacao_cdecl, 'TrocarCodigoDeAtivacao');
          if FDriverMFE01_05_15_Superior then
            Import(@_ConsultarUltimaSessaoFiscal_cdecl, 'ConsultarUltimaSessaoFiscal');
        end
        else
        begin // Demais fabricantes usam convenção STDCALL
          Import(@_AtivarSat_stdcall, 'AtivarSAT');
          Import(@_AssociarAssinatura_stdcall, 'AssociarAssinatura');
          Import(@_BloquearSAT_stdcall, 'BloquearSAT');
          Import(@_CancelarUltimaVenda_stdcall, 'CancelarUltimaVenda');
          Import(@_ConsultarNumeroSessao_stdcall, 'ConsultarNumeroSessao');
          Import(@_ConsultarSAT_stdcall, 'ConsultarSAT');
          Import(@_ConsultarStatusOperacional_stdcall, 'ConsultarStatusOperacional');
          Import(@_DesbloquearSAT_stdcall, 'DesbloquearSAT');
          //Import(@_DesligarSAT_stdcall, 'DesligarSAT');  Alguns fabricantes não implementaram na sua dll
          Import(@_EnviarDadosVenda_stdcall, 'EnviarDadosVenda');
          Import(@_ExtrairLogs_stdcall, 'ExtrairLogs');
          Import(@_TesteFimAFim_stdcall, 'TesteFimAFim');
          Import(@_TrocarCodigoDeAtivacao_stdcall, 'TrocarCodigoDeAtivacao');
          if FDriverMFE01_05_15_Superior then
            Import(@_ConsultarUltimaSessaoFiscal_stdcall, 'ConsultarUltimaSessaoFiscal');
        end;

      except
        on E: Exception do
        begin
          ShowMessage('Erro ao carregar comandos SAT' + #13 +
                      FDLLSatName + #13 + E.Message);
        end;
      end;
    end; // if FhDLL = 0 then
  end;
end;

function TSmall59.GeraNumero: Integer;
const MAXPOSICAO = 100;
var
  aArray: Array[1..MAXPOSICAO] of Integer;
  iNumero: Integer;
  iPosicao: Integer;
begin
  Randomize;
  for iPosicao := 1 to High(aGerado) do
    aArray[iPosicao] := aGerado[iPosicao];

  iNumero := 0;
  while iNumero <= 0 do
    iNumero := StrToIntDef(RightStr(StringReplace(StringReplace(FormatFloat('0.0000000000', Now), ',', '', [rfReplaceAll]), '.', '', [rfReplaceAll]), 6), RandomRange(1, 999999));  // Sandro Silva 2019-05-14  iNumero := RandomRange(1, 999999);

  Result := 0;
  for iPosicao := 1 to MAXPOSICAO do // Verifica se o número de sessão gerado está entre os 100 últimos gerados
  begin

    if aArray[iPosicao] = iNumero then
    begin
      iPosicaoSessaoDuplicada := iPosicao;
      iNumero := GeraNumero; // Executa novamente a geração do número de sessão
      Result := iNumero;
      Break;
    end;

    if aArray[iPosicao] = 0 then
    begin
      Result := iNumero;
      aArray[iPosicao] := Result;
      Break;
    end;

    if (iPosicao = MAXPOSICAO) and
      (aArray[iPosicao] <> Result) then
    begin
      Result := iNumero;
      if iPosicaoSessaoDuplicada + 1 > MAXPOSICAO then
        iPosicaoSessaoDuplicada := 0;

      aArray[iPosicaoSessaoDuplicada + 1] := Result;
      Break;
    end;

  end; // for iPosicao := 1 to MAXPOSICAO do

  for iPosicao := 1 to High(aArray) do
    aGerado[iPosicao] := aArray[iPosicao];
    
end;

function TSmall59.idSessao: Integer;
begin
  Result  := GeraNumero;
  FSessao := Result;
end;

function TSmall59.DescFormaPagamento(sCodigoForma: String): String;
begin
  case StrToIntDef(sCodigoForma, 7) of
    01://  01 - Dinheiro
      Result := 'Dinheiro';
    02://  02 - Cheque
      Result := 'Cheque';
    03://  03 - Cartão de Crédito
      Result := 'Cartão de Crédito';
    04://  04 - Cartão de Débito
      Result := 'Cartão de Débito';
    05://  05 - Crédito Loja
      Result := 'Crédito Loja';
    10://  10 - Vale Alimentação
      Result := 'Vale Alimentação';
    11://  11 - Vale Refeição
      Result := 'Vale Refeição';
    12://  12 - Vale Presente
      Result := 'Vale Presente';
    13://  13 - Vale Combustível
      Result := 'Vale Combustível';
    {Sandro Silva 2021-11-23 inicio}
    16:// 16 - Depósito Bancário
      Result := 'Depósito Bancário';
    17:// 17 - Pagamento Instantâneo (PIX)
      Result := 'Pagamento Instantâneo (PIX)';
    18:// 18 - Transferência bancária, Carteira Digital
      Result := 'Transferência bancária, Carteira Digital';
    19:// 19 - Programa de fidelidade, Cashback, Crédito Virtual
      Result := 'Programa de fidelidade, Cashback, Crédito Virtual';
    {Sandro Silva 2021-11-23 fim}
  else
    //99 - Outros
    Result := 'Outros';
  end;
end;

function TSmall59.Explode(Texto, Separador: String): TStrings;
{Sandro Silva 2012-12-04 inicio
Função que particiona o texto conforme o separador informado e retorna em um TString }
var
  strItem:          String;
  ListaAuxUTILS:    TStrings;
  NumCaracteres:    Integer;
  TamanhoSeparador: Integer;
  I:                Integer;
begin
  ListaAuxUTILS    := TStringList.Create;
  strItem          := '';
  NumCaracteres    := Length(Texto);
  TamanhoSeparador := Length(Separador);
  I                := 1;
  while I <= NumCaracteres do
  begin
    if (Copy(Texto, I, TamanhoSeparador) = Separador) or (I = NumCaracteres) then
    begin
      if (I = NumCaracteres) then
        strItem := strItem + Texto[I];
      ListaAuxUTILS.Add(Trim(strItem));
      strItem := '';
      I := I + (TamanhoSeparador - 1);
    end
    else
      strItem := strItem + Texto[I];

    I := I + 1;
  end;
  Result := ListaAuxUTILS;
  {Sandro Silva 2017-01-23 inicio
  // destruindo causa access violation
  //FreeAndNil(ListaAuxUTILS); // Sandro Silva 2016-12-08
  }
end;

function TSmall59.ExplodeRetorno(Texto: String): TRetornoSAT;
{Sandro Silva 2012-12-04 inicio
Função que particiona o texto informado e retorna em um array of string }
var
  iConfig: Integer;
begin
  with TStringList.Create do
  begin
    while Pos(' |', Texto) > 0 do
      Texto := StringReplace(Texto, ' |', '|', [rfReplaceAll]);

    Text := StringReplace(Texto + '|', '|', #$D#$A, [rfReplaceAll]);

    Result := nil;
    for iConfig := 0 to Count - 1 do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Strings[iConfig];
    end;
    Free;
  end;
end;

procedure TSmall59.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FhDLL, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + FDLLSatName);
  end;
end;

function TSmall59.StatusRetornoSAT(sRetorno: String;
  bApenasRetorno: Boolean = False): String;
var
  sCodigoRetorno: String;
  aRetorno: TRetornoSAT;
begin
  Result := '';
  aRetorno := nil;
  if sRetorno <> '' then
  begin
    try
      if Explode(sRetorno, '|').Count > 1 then
      begin

        sCodigoRetorno := Explode(sRetorno, '|')[1];

        try
          if Explode(sRetorno, '|').Count > 2 then
          begin
            if Explode(sRetorno, '|')[2] <> '' then
              Result := Explode(sRetorno, '|')[2];
          end;
        except

        end;

        if Result = '' then // Sandro Silva 2017-07-26
        begin
          // AtivarSAT
          if sCodigoRetorno = '04000' then
            Result := 'Ativado corretamente';
          if sCodigoRetorno = '04001' then
            Result := 'Erro na criação do certificado';
          if sCodigoRetorno = '04002' then
            Result := 'SEFAZ não reconhece este SAT (CNPJ inválido). Verificar junto a SEFAZ o CNPJ cadastrado';
          if sCodigoRetorno = '04003' then
            Result := 'SAT já ativado';
          if sCodigoRetorno = '04004' then
            Result := 'SAT com uso cessado/bloqueado';
          if sCodigoRetorno = '04005' then
            Result := 'Erro de comunicação com a SEFAZ. Tentar novamente';
          if sCodigoRetorno = '04006' then
            Result := 'CSR ICP-BRASIL criado com sucesso';
          if sCodigoRetorno = '04007' then
            Result := 'Erro na criação do CSR ICP-BRASIL';
          if sCodigoRetorno = '04098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '04099' then
            Result := 'Erro desconhecido na ativação';// Informar ao administrador.

          // ComunicarCertificadoICPBRASIL
          if sCodigoRetorno = '05000' then
            Result := 'Certificado transmitido com Sucesso';
          if sCodigoRetorno = '05001' then
            Result := 'Erro de comunicação com a SEFAZ';
          if sCodigoRetorno = '05002' then
            Result := 'Certificado Inválido';
          if sCodigoRetorno = '05098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '05099' then
            Result := 'Erro desconhecido';

          // EnviarDadosVenda
          if sCodigoRetorno = '06000' then
            Result := 'Emitido com sucesso + conteúdo notas';
          if sCodigoRetorno = '06001' then
            Result := 'Código de ativação inválido';
          if sCodigoRetorno = '06002' then
            Result := 'SAT ainda não ativado. Efetuar ativação';
          if sCodigoRetorno = '06003' then
            Result := 'SAT não vinculado ao AC';
          if sCodigoRetorno = '06004' then
            Result := 'Vinculação do AC não confere';
          if sCodigoRetorno = '06005' then
            Result := 'Tamanho do CF-e superior a 1.500KB';// Sandro Silva 2018-08-01
          if sCodigoRetorno = '06006' then
            Result := 'SAT bloqueado pelo contribuinte';
          if sCodigoRetorno = '06007' then
            Result := 'SAT bloqueado pela SEFAZ';
          if sCodigoRetorno = '06008' then
            Result := 'SAT bloqueado por falta de comunicação';
          if sCodigoRetorno = '06009' then
            Result := 'SAT bloqueado, código de ativação incorreto';
          if sCodigoRetorno = '06010' then
            Result := 'Erro de validação do conteúdo';
          if sCodigoRetorno = '06098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '06099' then
            Result := 'Erro desconhecido na emissão';

          // CancelarUltimaVenda
          if sCodigoRetorno = '07000' then
            Result := 'Cupom cancelado com sucesso + conteúdo CF-e-SAT cancelado';
          if sCodigoRetorno = '07001' then
            Result := 'Código ativação inválido';
          if sCodigoRetorno = '07002' then
            Result := 'Cupom inválido';
          if sCodigoRetorno = '07003' then
            Result := 'SAT bloqueado pelo contribuinte';
          if sCodigoRetorno = '07004' then
            Result := 'SAT bloqueado pela SEFAZ';
          if sCodigoRetorno = '07005' then
            Result := 'SAT bloqueado por falta de comunicação';
          if sCodigoRetorno = '07006' then
            Result := 'SAT bloqueado, código de ativação incorreto';
          if sCodigoRetorno = '07007' then
            Result := 'Erro de validação do conteúdo';
          if sCodigoRetorno = '07098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '07099' then
            Result := 'Erro desconhecido no cancelamento';

          // ConsultarSAT
          if sCodigoRetorno = '08000' then
            Result := 'SAT em operação';
          if sCodigoRetorno = '08098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '08099' then
            Result := 'Erro desconhecido';

          // TesteFimAFim
          if sCodigoRetorno = '09000' then
            Result := 'Emitido com sucesso';
          if sCodigoRetorno = '09001' then
            Result := 'Código ativação inválido';
          if sCodigoRetorno = '09002' then
            Result := 'SAT ainda não ativado';
          if sCodigoRetorno = '09098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '09099' then
            Result := 'Erro desconhecido';

          //ConsultaStatusOperacional
          if sCodigoRetorno = '10000' then
            Result := 'Resposta com Sucesso';
          if sCodigoRetorno = '10098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '10099' then
            Result := 'Erro desconhecido';// Informar o administrador.'

          // ConsultarNumeroSessao
          if sCodigoRetorno = '11000' then
            Result := 'Emitido com sucesso';
          if sCodigoRetorno = '11001' then
            Result := 'Código ativação inválido';
          if sCodigoRetorno = '11002' then
            Result := 'SAT ainda não ativado';
          if sCodigoRetorno = '11003' then
            Result := 'Sessão não existe';
          if sCodigoRetorno = '11098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '11099' then
            Result := 'Erro desconhecido';

          // ConfigurarInterfaceDeRede
          if sCodigoRetorno = '12000' then
            Result := 'Rede Configurada com Sucesso';
          if sCodigoRetorno = '12001' then
            Result := 'Código ativação inválido';
          if sCodigoRetorno = '12002' then
            Result := 'Dados fora do padrão a ser informado';
          if sCodigoRetorno = '12098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '12099' then
            Result := 'Erro desconhecido';

          // AssociarAssinatura
          if sCodigoRetorno = '13000' then
            Result := 'Assinatura do AC Registrada';
          if sCodigoRetorno = '13001' then
            Result := 'Código ativação inválido';
          if sCodigoRetorno = '13002' then
            Result := 'Erro de comunicação com a SEFAZ';
          if sCodigoRetorno = '13003' then
            Result := 'Assinatura fora do padrão informado';
          if sCodigoRetorno = '13098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '13099' then
            Result := 'Erro desconhecido';

          // AtualizarSoftwareSAT
          if sCodigoRetorno = '14000' then
            Result := 'Software Atualizado com Sucesso';
          if sCodigoRetorno = '14001' then
            Result := 'Atualização em Andamento. SAT em processo de Atualização. Aguardar..';
          if sCodigoRetorno = '14002' then
            Result := 'Erro na atualização';
          if sCodigoRetorno = '14003' then
            Result := 'Arquivo de atualização inválido';
          if sCodigoRetorno = '14098' then
            Result := 'SAT em processamento. Tente novamente';
          if sCodigoRetorno = '14099' then
            Result := 'Erro desconhecido';

          // ExtrairLogs
          if sCodigoRetorno = '15000' then
            Result := 'Transferência completa';
          if sCodigoRetorno = '15001' then
            Result := 'Transferência em andamento';
          if sCodigoRetorno = '15098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '15099' then
            Result := 'Erro desconhecido';

          //BloquearSAT
          if sCodigoRetorno = '16000' then
            Result := 'Equipamento SAT bloqueado com sucesso';
          if sCodigoRetorno = '16001' then
            Result := 'Equipamento SAT já está bloqueado';
          if sCodigoRetorno = '16002' then
            Result := 'Erro de comunicação com a SEFAZ';
          if sCodigoRetorno = '16098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '16099' then
            Result := 'Erro desconhecido';

          //DesbloquearSAT
          if sCodigoRetorno = '17000' then
            Result := 'Equipamento SAT desbloqueado com sucesso';
          if sCodigoRetorno = '17001' then
            Result := 'SAT bloqueado pelo contribuinte';
          if sCodigoRetorno = '17002' then
            Result := 'SAT bloqueado pela SEFAZ';
          if sCodigoRetorno = '17003' then
            Result := 'Erro de comunicação com a SEFAZ';
          if sCodigoRetorno = '17098' then
            Result := 'SAT em processamento';
          if sCodigoRetorno = '17099' then
            Result := 'Erro desconhecido';

          //TrocarCodigoDeAtivacao
          if sCodigoRetorno = '18000' then
            Result := 'Código de ativação alterado com sucesso'; //Confirmação de troca do código de ativação.
          if sCodigoRetorno = '18001' then
            Result := 'Código de ativação Incorreto'; //Não foi possível alterar o código de ativação.
          if sCodigoRetorno = '18002' then
            Result := 'Código de ativação de emergência Incorreto'; //Não foi possível alterar o código de ativação.
          if sCodigoRetorno = '18098' then
            Result := 'SAT em processamento. Tente novamente'; //Em casos onde o SAT estiver processando outra função
          if sCodigoRetorno = '18099' then
            Result := 'Erro desconhecido'; // Informar o administrador.
        end;

        if Result = '' then
        begin
          try
            aRetorno := ExplodeRetorno(sRetorno);

            try

              if Length(aRetorno) >= 3 then
                Result := aRetorno[2];
            except
            end;

            if Trim(Result) <> '' then
              Result := Result + #13;

            try

              if Length(aRetorno) >= 5 then
                Result := Result + aRetorno[4]
              else
                Result := Result + sRetorno;
            except
            end;

          except
          end;
        end;

      end
      else
        Result := sRetorno;
    except
      Result := sRetorno;
    end;
    if bApenasRetorno then
      Result := Result
    else
      Result := FTipoEquipamento + ' retornou: ' + #13 + #10 + Result; // Sandro Silva 2018-07-09  'SAT retornou: ' + #13 + #10 + Result;
  end
  else
    Result := 'Sem retorno de comunicação com o equipamento';
  aRetorno := nil;    
end;

function TSmall59.SATAssociarAssinatura(codigoDeAtivacao: AnsiString;
  CNPJEmitente: AnsiString; assinaturaCNPJs: AnsiString; mmLog: TMemo = nil): String;
var
  sRetorno: String;
  aRetorno: TRetornoSAT;
begin
  Result := '';
  aRetorno := nil;

  if FModoOperacao = moClient then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
  end
  else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
  begin
    sRetorno := FIntegradorMFE.AssociarAssinatura(IntToStr(idSessao), PAnsiChar(FCNPJSoftwareHouse + CNPJEmitente), PAnsiChar(Trim(assinaturaCNPJs))); // Sandro Silva 2017-05-09
  end
  else if (FModoOperacao = moAlone) or (FModoOperacao =  moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
  begin
    if FhDLL > 0 then // Sandro Silva 2022-05-17
    begin
      if Chamadacdecl then
        sRetorno := String(_AssociarAssinatura_cdecl(idSessao, PAnsiChar(codigodeAtivacao), PAnsiChar(FCNPJSoftwareHouse + CNPJEmitente), PAnsiChar(Trim(assinaturaCNPJs))))
      else
        sRetorno := String(_AssociarAssinatura_stdcall(idSessao, PAnsiChar(codigodeAtivacao), PAnsiChar(FCNPJSoftwareHouse + CNPJEmitente), PAnsiChar(Trim(assinaturaCNPJs))));
    end;
  end;

  sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

  FRespostaSAT      := sRetorno;
  FMensagemSAT      := ''; // Sandro Silva 2016-11-17
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  if mmLog <> nil then
    mmLog.Lines.Add('Retorno ' + sRetorno);
  GravaLog('Associar Assinatura|' + sRetorno);
  if Trim(sRetorno) <> '' then
  begin
    //13000
    try
      aRetorno := ExplodeRetorno(sRetorno);
      if aRetorno <> nil then
      begin
        if Explode(sRetorno, '|').Count > 1 then
        begin
          Result := aRetorno[1];
          FCodigoRetornoSAT := aRetorno[1];

          try
            FMensagemSAT := aRetorno[2];
          except
          end;

          try
            FMensagemSEFAZ := aRetorno[4];
          except
          end;

          if aRetorno[1] <> '13000' then
          begin
            // Sandro Silva 2016-09-20  SmallMsgBox(PChar(sRetorno), 'Atenção', MB_ICONWARNING + MB_OK);
            Application.MessageBox(PChar(StatusRetornoSAT(sRetorno)), 'Atenção', MB_ICONWARNING + MB_OK);
          end;
        end;
      end;
    except
    end;
  end;

  aRetorno := nil; // Sandro Silva 2016-06-14
  if Result = '' then
    Application.MessageBox(PChar(FTipoEquipamento + ' retornou: ' + #13 + #10 + sRetorno), 'Atenção', MB_ICONWARNING + MB_OK);// Sandro Silva 2018-07-09  Application.MessageBox(PChar('SAT retornou: ' + #13 + #10 + sRetorno), 'Atenção', MB_ICONWARNING + MB_OK);
end;

function TSmall59.SATAtivarSAT(subComando: Integer; codigoDeAtivacao: AnsiString;
  CNPJ: String; cUF: String; mmLog: TMemo = nil): String;
var
  sRetorno: String;
  aRetorno: TRetornoSAT;
  iUF: Smallint;
begin
  Result := '';
  aRetorno := nil;

  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16
  {Sandro Silva 2021-08-23 inicio
  case FModoOperacao of
    moClient:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
      end;
    moIntegradorMFE:
      begin
        iUF := StrToInt(UFCodigo(cUF));
        sRetorno := FIntegradorMFE.AtivarMFe(IntToStr(idSessao), IntToStr(subComando), PAnsiChar(CNPJ), IntToStr(iUF));
      end;
    moAlone, moServer:
      begin
        iUF := StrToInt(UFCodigo(cUF));

        if Chamadacdecl then
          sRetorno := String(_AtivarSAT_cdecl(idSessao, subComando, PAnsiChar(CodigoDeAtivacao), PAnsiChar(CNPJ), iUF))
        else
          sRetorno := String(_AtivarSAT_stdcall(idSessao, subComando, PAnsiChar(CodigoDeAtivacao), PAnsiChar(CNPJ), iUF));

      end;
  end;
  }
  if FModoOperacao = moClient then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
  end
  else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
  begin
    iUF := StrToInt(UFCodigo(cUF));
    sRetorno := FIntegradorMFE.AtivarMFe(IntToStr(idSessao), IntToStr(subComando), PAnsiChar(CNPJ), IntToStr(iUF));
  end
  else if (FModoOperacao = moAlone) or (FModoOperacao =  moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
  begin
    iUF := StrToInt(UFCodigo(cUF));

    if FhDLL > 0 then // Sandro Silva 2022-05-17
    begin
      if Chamadacdecl then
        sRetorno := String(_AtivarSAT_cdecl(idSessao, subComando, PAnsiChar(CodigoDeAtivacao), PAnsiChar(CNPJ), iUF))
      else
        sRetorno := String(_AtivarSAT_stdcall(idSessao, subComando, PAnsiChar(CodigoDeAtivacao), PAnsiChar(CNPJ), iUF));
    end;

  end;
  {Sandro Silva 2021-08-23 fim} 

  sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

  FRespostaSAT := sRetorno;
  if Trim(sRetorno) <> '' then
  begin
    try
      aRetorno := ExplodeRetorno(sRetorno);
      if aRetorno <> nil then
      begin
        if Explode(sRetorno, '|').Count > 1 then
        begin
          Result := aRetorno[1];
          FCodigoRetornoSAT := aRetorno[1];

          try
            FMensagemSAT := aRetorno[2];
          except
          end;
          
          try
            FMensagemSEFAZ := aRetorno[4];
          except

          end;

          if (FCodigoRetornoSAT <> '04000') and (FCodigoRetornoSAT <> '04003') then
          begin
            Application.MessageBox(PChar(StatusRetornoSAT(sRetorno)), 'Atenção', MB_ICONWARNING + MB_OK);
          end;
        end;
      end;
    except
    end;
  end;
  //Result := sRetorno;
  aRetorno := nil; // Sandro Silva 2016-06-14
  if Result = '' then
    Application.MessageBox(PChar(FTipoEquipamento + ' retornou: ' + #13 + #10 + sRetorno), 'Atenção', MB_ICONWARNING + MB_OK);// Sandro Silva 2018-07-09  Application.MessageBox(PChar('SAT retornou: ' + #13 + #10 + sRetorno), 'Atenção', MB_ICONWARNING + MB_OK);
end;

function TSmall59.SATBloquear(codigoDeAtivacao: AnsiString;
  mmLog: TMemo = nil): String;
begin
  case FModoOperacao of
    moClient:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
      end;
    moIntegradorMFE:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
      end;
    moAlone, moServer:
      begin
        {Sandro Silva 2021-06-22 inicio
        if Chamadacdecl then
          Result := _BloquearSAT_cdecl(idSessao, PAnsiChar(codigoAtivacao))
        else
          Result := _BloquearSAT_stdcall(idSessao, PAnsiChar(codigoAtivacao));
        }
        ShowMessage('Função não disponível para o PDV');
        {Sandro Silva 2021-06-22 final}
      end;
  end;

  {Sandro Silva 2021-06-22 inicio
  FRespostaSAT      := Result;
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  if mmLog <> nil then
  begin
    mmLog.Lines.Add('Retorno ' + Result);
   mmLog.Lines.Add(StatusRetornoSAT(Result));
  end;
  GravaLog('Bloquear SAT|' + Result);
  }
end;

function TSmall59.SATCancelarUltimaVenda(XMLVenda: AnsiString;
  mmLog: TMemo = nil): Boolean; // Sandro Silva 2017-02-10  String; // Sandro Silva 2017-01-13 Acertar qdo testado com kryptus  Boolean;
var
  aRetorno: TRetornoSAT;
  iItem: Integer;
  sRetorno: String;
  sDadosEmitente: AnsiString; //   sDadosEmitente: String;
  sDadosDestinatario: AnsiString; // sDadosDestinatario: String;
  sDados: AnsiString; // sDados: String;
  CNPJCPFDestinatario: AnsiString; // CNPJCPFDestinatario: String;
  sChaveVenda: AnsiString; // sChaveVenda: String;
  sCFeSATXML: AnsiString; // sCFeSATXML: String;
  snumeroCaixa: AnsiString; // snumeroCaixa: String;
begin
  Result := False; // Sandro Silva 2017-02-10  ''; // Sandro Silva 2017-01-13 Acertar qdo testado com kryptus  False;
  FMensagemSEFAZ    := ''; // Sandro Silva 2016-10-31
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  try

    FRetornoCancelamento.numeroSessao      := '';
    FRetornoCancelamento.EEEEE             := '';
    FRetornoCancelamento.CCCC              := '';
    FRetornoCancelamento.mensagem          := '';
    FRetornoCancelamento.cod               := '';
    FRetornoCancelamento.mensagemSEFAZ     := '';
    FRetornoCancelamento.ArquivoCFeBase64  := '';
    FRetornoCancelamento.timeStamp         := '';
    FRetornoCancelamento.ChaveConsulta     := '';
    FRetornoCancelamento.valorTotalCFe     := '';
    FRetornoCancelamento.CPFCNPJAdquirente := '';
    FRetornoCancelamento.assinaturaQRCODE  := '';

    CNPJCPFDestinatario := xmlNodeValue(XMLVenda, '//dest/CPF');
    if Trim(LimpaNumero(CNPJCPFDestinatario)) = '' then
      CNPJCPFDestinatario := xmlNodeValue(XMLVenda, '//dest/CNPJ');

    sChaveVenda  := xmlNodeValue(XMLVenda, '//infCFe/@Id');
    snumeroCaixa := xmlNodeValue(XMLVenda, '//ide/numeroCaixa');

    sDadosEmitente     := '<emit/>'; // Sandro Silva 2017-04-03
    sDadosDestinatario := '<dest/>'; // Sandro Silva 2017-04-03

    if FVersaoDadosEnt < '0.07' then {Sandro Silva 2017-04-03 inicio}
    begin
      sDadosEmitente := '<emit/>'; // Sandro Silva 2017-04-03

      if Trim(LimpaNumero(CNPJCPFDestinatario)) <> '' then
      begin
        sDadosDestinatario := '<dest>';

        if Length(Trim(LimpaNumero(CNPJCPFDestinatario))) > 11 then
          sDadosDestinatario := sDadosDestinatario + '<CNPJ>' + Trim(LimpaNumero(CNPJCPFDestinatario)) + '</CNPJ>'
        else
          sDadosDestinatario := sDadosDestinatario + '<CPF>' + Trim(LimpaNumero(CNPJCPFDestinatario)) + '</CPF>';

        sDadosDestinatario := sDadosDestinatario + '</dest>';
      end
      else
      begin
        sDadosDestinatario := '<dest/>';
      end;
    end;

    sDados := '<?xml version="1.0" encoding="UTF-8"?>' +
                '<CFeCanc>' +
                  '<infCFe chCanc="' + schaveVenda + '">' +
                    '<ide>' +
                      '<CNPJ>' + FCNPJSoftwareHouse + '</CNPJ>' + // CNPJ Software House
                      '<signAC>' + AssinaturaAssociada + '</signAC>' +
                      '<numeroCaixa>' + snumeroCaixa + '</numeroCaixa>' + // equipamento ou emulador com versão 2.3.13 ou superior
                    '</ide>' +
                    sDadosEmitente + // Sandro Silva 2017-04-03
                    sDadosDestinatario +
                    '<total/>' +
                  '</infCFe>' +
                '</CFeCanc>';

    SalvaLogDadosEnviados(sDados);

    {Sandro Silva 2021-08-23 inicio
    case FModoOperacao of
      moClient:
        begin
          FRequisicao.Clear;
          FRequisicao.Caixa             := FCaixa;
          FRequisicao.Comando           := CMD_CANCELARULTIMAVENDA; // 'CancelarUltimaVenda';
          FRequisicao.DadosCancelamento := XMLVenda; //sDados;
          sRetorno := FRequisicao.Enviar;
        end;
      moIntegradorMFE:
        begin
          sRetorno := FIntegradorMFE.CancelarUltimaVenda(IntToStr(idSessao), PAnsiChar(sDados));
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            sRetorno := String(_CancelarUltimaVenda_cdecl(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(schaveVenda), PAnsiChar(sDados)))
          else
            sRetorno := String(_CancelarUltimaVenda_stdcall(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(schaveVenda), PAnsiChar(sDados)));

        end;
    end;
    }
    if FModoOperacao = moClient then
    begin
      FRequisicao.Clear;
      FRequisicao.Caixa             := FCaixa;
      FRequisicao.Comando           := CMD_CANCELARULTIMAVENDA; // 'CancelarUltimaVenda';
      FRequisicao.DadosCancelamento := XMLVenda; //sDados;
      sRetorno := FRequisicao.Enviar;
    end
    else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
    begin
      sRetorno := FIntegradorMFE.CancelarUltimaVenda(IntToStr(idSessao), PAnsiChar(sDados));
    end
    else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
    begin

      if FhDLL > 0 then // Sandro Silva 2022-05-17
      begin
        if Chamadacdecl then
          sRetorno := String(_CancelarUltimaVenda_cdecl(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(schaveVenda), PAnsiChar(sDados)))
        else
          sRetorno := String(_CancelarUltimaVenda_stdcall(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(schaveVenda), PAnsiChar(sDados)));
      end;

    end;
    {Sandro Silva 2021-08-23 fim}

    sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

    if   (FFabricanteCodigo = FABRICANTE_SWEDA)
      or (FFabricanteCodigo = FABRICANTE_EMULADOR)
      or (Pos(#13#10, sRetorno) > 0)
      or (Pos(#$D#$A, sRetorno) > 0)
      or (Pos(#$A, sRetorno) > 0)
      then
    begin
      sRetorno := TiraQuebraLinha(sRetorno);
    end;

    FRespostaSAT := sRetorno;

    if Trim(sRetorno) = '' then
    begin
      if FModoOperacao <> moClient then
        sRetorno := SATConsultarNumeroSessao(CodigoAtivacao, FSessao, mmLog);

      if   (FFabricanteCodigo = FABRICANTE_SWEDA)
        or (FFabricanteCodigo = FABRICANTE_EMULADOR)
        or (Pos(#13#10, sRetorno) > 0)
        or (Pos(#$D#$A, sRetorno) > 0)
        or (Pos(#$A, sRetorno) > 0)
        then
      begin
        sRetorno := TiraQuebraLinha(sRetorno);
      end;
      FRespostaSAT := sRetorno;

    end;

    if mmLog <> nil then
    begin
      mmLog.Lines.Add('XML CANCELAMENTO');
      mmLog.Lines.Add(sDados);

      mmLog.Lines.Add('Retorno ' + sRetorno);
      mmLog.Lines.Add(StatusRetornoSAT(sRetorno));

      mmLog.Lines.Add(sDados);
    end;

    // Particiona o retorno
    aRetorno := ExplodeRetorno(sRetorno);

    if aRetorno <> nil then
    begin
      // Repassa a partes para o campo
      for iItem := 0 to High(aRetorno) do
      begin
        case iItem of
          0: FRetornoCancelamento.numeroSessao       := aRetorno[iItem];
          1: FRetornoCancelamento.EEEEE              := aRetorno[iItem];
          2: FRetornoCancelamento.CCCC               := aRetorno[iItem];
          3: FRetornoCancelamento.mensagem           := aRetorno[iItem];
          4: FRetornoCancelamento.cod                := aRetorno[iItem];
          5: FRetornoCancelamento.mensagemSEFAZ      := aRetorno[iItem];
          6: FRetornoCancelamento.ArquivoCFeBase64   := aRetorno[iItem];
          7: FRetornoCancelamento.timeStamp          := aRetorno[iItem];
          8: FRetornoCancelamento.ChaveConsulta      := aRetorno[iItem];
          9: FRetornoCancelamento.valorTotalCFe      := aRetorno[iItem];
          10: FRetornoCancelamento.CPFCNPJAdquirente := aRetorno[iItem];
          11: FRetornoCancelamento.assinaturaQRCODE  := aRetorno[iItem];
        end;

        if mmLog <> nil then
          mmLog.Lines.Add(IntToStr(iItem + 1) + ' ' + aRetorno[iItem]);

      end;

      FCodigoRetornoSAT := FRetornoCancelamento.EEEEE; // Sandro Silva 2017-02-16
      FMensagemSAT      := FRetornoCancelamento.mensagem;

      GravaLog('Cancelar Ultima Venda|' +
          FRetornoCancelamento.numeroSessao  + '|' +
          FRetornoCancelamento.EEEEE         + '|' +
          FRetornoCancelamento.CCCC          + '|' +
          FRetornoCancelamento.mensagem      + '|' +
          FRetornoCancelamento.cod           + '|' +
          FRetornoCancelamento.mensagemSEFAZ + '|' +
          FRetornoCancelamento.timeStamp     + '|' +
          FRetornoCancelamento.ChaveConsulta + '|' +
          FRetornoCancelamento.valorTotalCFe + '|' +
          FRetornoCancelamento.CPFCNPJAdquirente
      );

      try
        FMensagemSEFAZ := FRetornoCancelamento.mensagemSEFAZ;
      except

      end;

      if (FRetornoCancelamento.EEEEE <> '07000') then
      begin
        if mmLog <> nil then
          mmLog.Lines.Add('Erro retornado ' + DescRetornoErroCancelamentoVenda(FRetornoCancelamento.CCCC));
        FLogRetornoMobile := FRetornoCancelamento.mensagem + #13 + FRetornoCancelamento.CCCC + ' - ' + DescRetornoErroCancelamentoVenda(FRetornoCancelamento.CCCC) + #13 + StatusRetornoSAT('|' + sRetorno);
      end;

      if FRetornoCancelamento.EEEEE = '07000' then
      begin
        sCFeSATXML := Base64Decode(FRetornoCancelamento.ArquivoCFeBase64);

        SalvaXML(sCFeSATXML);

        if sCFeSATXML <> '' then
        begin
          FCFeXML    := sCFeSATXML;
          FCFeID     := LimpaNumero(FRetornoCancelamento.ChaveConsulta);
          FCFeStatus := _59_CANCELAMENTO_COM_SUCESSO_MAIS_CONTEUDO_NOTAS;
          FnCFe      := xmlNodeValue(sCfeSATXML, '//ide/nCFe'); //2014-10-22

          SetUltimoNumeroCupom(FnCFe); // 2015-06-23

        end;

      end;

    end;
    Result := True; // Sandro Silva 2017-02-10  FRetornoCancelamento.EEEEE; // Sandro Silva 2017-01-13 Acertar qdo testado com kryptus  True;
  except

  end;
  aRetorno := nil; // Sandro Silva 2016-06-14
end;

function TSmall59.SATConsultarNumeroSessao(codigoDeAtivacao: AnsiString;
  cNumeroDeSessao: Integer; mmLog: TMemo = nil): String;
begin
  {Sandro Silva 2021-08-23 inicio
  case FModoOperacao of
    moClient:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente SAT');
      end;
    moIntegradorMFE:
      begin
        Result := FIntegradorMFE.ConsultarNumeroSessao(IntToStr(idSessao), IntToStr(cNumeroDeSessao));
      end;
    moAlone, moServer:
      begin

        if Chamadacdecl then
          Result := String(_ConsultarNumeroSessao_cdecl(idSessao, PAnsiChar(codigoAtivacao), cNumeroDeSessao))
        else
          Result := String(_ConsultarNumeroSessao_stdcall(idSessao, PAnsiChar(codigoAtivacao), cNumeroDeSessao));

      end;
  end;
  }

  if FModoOperacao = moClient then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
  end;

  if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
  begin
    Result := FIntegradorMFE.ConsultarNumeroSessao(IntToStr(idSessao), IntToStr(cNumeroDeSessao));
  end;

  if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
  begin

    if FhDLL > 0 then // Sandro Silva 2022-05-17
    begin
      if Chamadacdecl then
        Result := String(_ConsultarNumeroSessao_cdecl(idSessao, PAnsiChar(codigoAtivacao), cNumeroDeSessao))
      else
        Result := String(_ConsultarNumeroSessao_stdcall(idSessao, PAnsiChar(codigoAtivacao), cNumeroDeSessao));
    end;

  end;
  {Sandro Silva 2021-08-23 inicio}
  Result := EliminarEspaco(Result); // Sandro Silva 2017-02-10

  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16
  FRespostaSAT      := Result;

  if mmLog <> nil then
  begin
    mmLog.Lines.Add('Retorno ' + Result);
    mmLog.Lines.Add(StatusRetornoSAT(Result));
  end;
  GravaLog('Consultar Numero Sessao|' + Result);
end;

function TSmall59.SATConsultar(bExibeRetorno: Boolean;
  bExibirMensagemSefaz: Boolean; mmLog: TMemo = nil): Boolean;
var
  aRetorno: TRetornoSAT;
  iItem: Integer;
  sRetorno: String;
  Retorno: TConsultarSATRetorno;
begin
  Retorno := TConsultarSATRetorno.Create;
  Result  := False;

  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  try

    {Sandro Silva 2021-08-23 inicio
    case FModoOperacao of
      moClient:
        begin
          FRequisicao.Clear;
          FRequisicao.Caixa   := FCaixa;
          FRequisicao.Comando := CMD_CONSULTARSAT; // 'ConsultarSAT';

          sRetorno := FRequisicao.Enviar;
        end;
      moIntegradorMFE:
        begin
          sRetorno := FIntegradorMFE.ConsultaMFe(IntToStr(idSessao));
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            sRetorno := String(_ConsultarSAT_cdecl(idSessao))
          else
            sRetorno := String(_ConsultarSAT_stdcall(idSessao));

        end;
    end;
    }
    if FModoOperacao = moClient then
    begin
      FRequisicao.Clear;
      FRequisicao.Caixa   := FCaixa;
      FRequisicao.Comando := CMD_CONSULTARSAT; // 'ConsultarSAT';

      sRetorno := FRequisicao.Enviar;
    end
    else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
    begin
      sRetorno := FIntegradorMFE.ConsultaMFe(IntToStr(idSessao));
    end
    else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
    begin

      if FhDLL > 0 then // Sandro Silva 2022-05-17
      begin
        if Chamadacdecl then
          sRetorno := String(_ConsultarSAT_cdecl(idSessao))
        else
          sRetorno := String(_ConsultarSAT_stdcall(idSessao));
      end;

    end;
    {Sandro Silva 2021-08-23 fim}

    sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

    if Utf8ToAnsi(sRetorno) <> '' then
      sRetorno := Utf8ToAnsi(sRetorno);

    FRespostaSAT := sRetorno;

    if mmLog <> nil then
    begin
      mmLog.Lines.Add('Retorno ' + sRetorno);
      mmLog.Lines.Add(StatusRetornoSAT(sRetorno));
    end;
    GravaLog('Consultar SAT|' + sRetorno);

    // Particiona o retorno
    aRetorno := ExplodeRetorno(sRetorno);

    if aRetorno <> nil then
    begin
      // Repassa a partes para o campo
      for iItem := 0 to High(aRetorno) do
      begin

        if iItem < 5 then
        begin
          case iItem of
            0: Retorno.numeroSessao  := aRetorno[iItem];
            1: Retorno.EEEEE         := aRetorno[iItem];
            2: Retorno.mensagem      := aRetorno[iItem];
            3: Retorno.cod           := aRetorno[iItem];
            4: Retorno.mensagemSEFAZ := aRetorno[iItem];
          end;
        end;

        if mmLog <> nil then
          mmLog.Lines.Add(IntToStr(iItem + 1) + ' ' + aRetorno[iItem]);
      end;

      FCodigoRetornoSAT := Retorno.EEEEE;

      FMensagemSAT := Retorno.mensagem;

      try
        FMensagemSEFAZ := Retorno.mensagemSEFAZ;
      except

      end;

      if bExibeRetorno then
      begin
        if Retorno.EEEEE <> '08000' then
        begin
          if Retorno.EEEEE <> '' then
            Application.MessageBox(PChar(Retorno.EEEEE + ' ' + Retorno.mensagem),'Atenção', MB_ICONWARNING + MB_OK);
        end;
      end;

      if Retorno.EEEEE = '08000' then
      begin
        FEmOperacao := True;
      end
      else
        FEmOperacao := False;
      FCodigoRetornoConsultarSAT := Retorno.EEEEE;
    end;
    Result := True;
  except

  end;
  aRetorno := nil;// Sandro Silva 2016-06-14
  FreeAndNil(Retorno);
end;

function TSmall59.SATConsultarStatusOperacional(mmLog: TMemo = nil;
  bExibeRetorno: Boolean = False): Boolean; //TConsultarStatusOperacionalRetorno;// String;
var
  aRetorno: TRetornoSAT;
  iItem: Integer;
  sRetorno: String;
  sStatusOperacional: String;
begin
  FCursor       := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  
  FBloqueioAutonomo := False;
  Result := False;
  FMensagemSEFAZ    := ''; // Sandro Silva 2016-10-31
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  try

    FRetornoStatusOperacional.numeroSessao    := '';
    FRetornoStatusOperacional.EEEEE           := '';
    FRetornoStatusOperacional.mensagem        := '';
    FRetornoStatusOperacional.cod             := '';
    FRetornoStatusOperacional.mensagemSEFAZ   := '';
    FRetornoStatusOperacional.ConteudoRetorno := '';

    {Sandro Silva 2021-08-23 inicio
    case FModoOperacao of
      moClient:
        begin
          FRequisicao.Clear;
          FRequisicao.Caixa   := FCaixa;
          FRequisicao.Comando := CMD_CONSULTARSTATUSOPERACIONAL;// 'ConsultarStatusOperacional';
          sRetorno := FRequisicao.Enviar;
        end;
      moIntegradorMFE:
        begin
          sRetorno := FIntegradorMFE.ConsultarStatusOperacional(IntToStr(idSessao));
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            sRetorno := String(_ConsultarStatusOperacional_cdecl(idSessao, PAnsiChar(FCodigoAtivacao)))
          else
            sRetorno := String(_ConsultarStatusOperacional_stdcall(idSessao, PAnsiChar(FCodigoAtivacao)));

        end;
    end;
    }

    sRetorno := '';

    if FModoOperacao = moClient then
    begin
      FRequisicao.Clear;
      FRequisicao.Caixa   := FCaixa;
      FRequisicao.Comando := CMD_CONSULTARSTATUSOPERACIONAL;// 'ConsultarStatusOperacional';
      sRetorno := FRequisicao.Enviar;
    end
    else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
    begin
      sRetorno := FIntegradorMFE.ConsultarStatusOperacional(IntToStr(idSessao));
    end
    else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
    begin

      if FhDLL > 0 then // Sandro Silva 2022-05-17
      begin
        if Chamadacdecl then
          sRetorno := String(_ConsultarStatusOperacional_cdecl(idSessao, PAnsiChar(FCodigoAtivacao)))
        else
          sRetorno := String(_ConsultarStatusOperacional_stdcall(idSessao, PAnsiChar(FCodigoAtivacao)));
      end;

    end;

    if Utf8ToAnsi(sRetorno) <> '' then
      sRetorno := Utf8ToAnsi(sRetorno);

    {Sandro Silva 2021-08-23 fim}

    sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

    FRespostaSAT := sRetorno;

    if mmLog <> nil then
    begin
      mmLog.Lines.Add('Retorno ' + sRetorno);
      mmLog.Lines.Add(StatusRetornoSAT(sRetorno));
    end;
    GravaLog('Consultar Status Operacional|' + sRetorno);

    // Particiona o retorno
    aRetorno := ExplodeRetorno(sRetorno);

    if aRetorno <> nil then
    begin
      sStatusOperacional := '';
      // Repassa a partes para o campo
      for iItem := 0 to High(aRetorno) do
      begin
        case iItem of
          0: FRetornoStatusOperacional.numeroSessao  := aRetorno[iItem];
          1: FRetornoStatusOperacional.EEEEE         := aRetorno[iItem];
          2: FRetornoStatusOperacional.mensagem      := aRetorno[iItem];
          3: FRetornoStatusOperacional.cod           := aRetorno[iItem];
          4: FRetornoStatusOperacional.mensagemSEFAZ := aRetorno[iItem];
          5:
            begin
              FRetornoStatusOperacional.ConteudoRetorno := aRetorno[5];
              sStatusOperacional := sStatusOperacional + #13 + #10 + 'Número de Série: ' + aRetorno[iItem];
            end;
          6: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Tipo de Rede: ' + aRetorno[iItem];
          7: sStatusOperacional := sStatusOperacional + #13 + #10 + 'IP: ' + aRetorno[iItem];
          8: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Endereço MAC: ' + aRetorno[iItem];
          9: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Máscara de Rede: ' + aRetorno[iItem];
         10: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Gateway: ' + aRetorno[iItem];
         11: sStatusOperacional := sStatusOperacional + #13 + #10 + 'DNS 1: ' + aRetorno[iItem];
         12: sStatusOperacional := sStatusOperacional + #13 + #10 + 'DNS 2: ' + aRetorno[iItem];
         13: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Status da Rede: ' + aRetorno[iItem];
         14: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Nível da Bateria: ' + aRetorno[iItem];
         15: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Memória de Trabalho Total: ' + aRetorno[iItem];
         16: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Memória de Trabalho Usada: ' + aRetorno[iItem];
         17:
            begin
              if Length(aRetorno[iItem]) = 14 then
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Data e Hora Atual: ' +
                  Copy(aRetorno[iItem], 7, 2) + '/' + Copy(aRetorno[iItem], 5, 2) + '/' + Copy(aRetorno[iItem], 1, 4) + ' ' +
                  Copy(aRetorno[iItem], 9, 2) + ':' + Copy(aRetorno[iItem], 11, 2) + ':' + Copy(aRetorno[iItem], 13, 2)
              else
               sStatusOperacional := sStatusOperacional + #13 + #10 + 'Data e Hora Atual: ' + aRetorno[iItem];
            end;
         18: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Versão do Software Básico: ' + aRetorno[iItem];
         19: begin
               FVersaoLeiauteTabelaInformacoes := aRetorno[iItem];
               sStatusOperacional := sStatusOperacional + #13 + #10 + 'Versão do Leiaute da tabela de informações: ' + aRetorno[iItem];
             end;
         20:
            begin
              sStatusOperacional := sStatusOperacional + #13 + #10 + 'Último CF-e Emitido: ' + aRetorno[iItem]; // Sandro Silva 2018-08-01
              SetUltimoNumeroCupom(Copy(aRetorno[iItem], 32, 6));// 2015-06-23
            end;
         21: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Primeiro CF-e armazenado na memória de trabalho: ' + aRetorno[iItem]; // Sandro Silva 2018-08-01
         22: sStatusOperacional := sStatusOperacional + #13 + #10 + 'Último CF-e armazenado na memória de trabalho: ' + aRetorno[iItem]; // Sandro Silva 2018-08-01
         23:
            begin
              if Length(aRetorno[iItem]) = 14 then
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Última transmissão de CF-e para SEFAZ: ' + // Sandro Silva 2018-08-01
                  Copy(aRetorno[iItem], 7, 2) + '/' + Copy(aRetorno[iItem], 5, 2) + '/' + Copy(aRetorno[iItem], 1, 4) + ' ' +
                  Copy(aRetorno[iItem], 9, 2) + ':' + Copy(aRetorno[iItem], 11, 2) + ':' + Copy(aRetorno[iItem], 13, 2)
              else
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Última transmissão de CF-e para SEFAZ: ' + aRetorno[iItem]; // Sandro Silva 2018-08-01
            end;
         24:
            begin
              if Length(aRetorno[iItem]) = 14 then
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Última comunicação com a SEFAZ: ' +
                  Copy(aRetorno[iItem], 7, 2) + '/' + Copy(aRetorno[iItem], 5, 2) + '/' + Copy(aRetorno[iItem], 1, 4) + ' ' +
                  Copy(aRetorno[iItem], 9, 2) + ':' + Copy(aRetorno[iItem], 11, 2) + ':' + Copy(aRetorno[iItem], 13, 2)
              else
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Última comunicação com a SEFAZ: ' + aRetorno[iItem];
            end;
         25:
            begin
              if Length(aRetorno[iItem]) = 8 then
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Emissão do certificado instalado: ' +
                  Copy(aRetorno[iItem], 7, 2) + '/' + Copy(aRetorno[iItem], 5, 2) + '/' + Copy(aRetorno[iItem], 1, 4)
              else
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Emissão do certificado instalado: ' + aRetorno[iItem];
            end;
         26:
            begin
              if Length(aRetorno[iItem]) = 8 then
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Vencimento do certificado instalado: ' +
                  Copy(aRetorno[iItem], 7, 2) + '/' + Copy(aRetorno[iItem], 5, 2) + '/' + Copy(aRetorno[iItem], 1, 4)
              else
                sStatusOperacional := sStatusOperacional + #13 + #10 + 'Vencimento do certificado instalado: ' + aRetorno[iItem];
            end;
         27:
            begin
              sStatusOperacional := sStatusOperacional + #13 + #10 + 'Estado de Operação do SAT: ';
              if aRetorno[iItem] = '0' then
                sStatusOperacional := sStatusOperacional + 'DESBLOQUEADO';
              if aRetorno[iItem] = '1' then
                sStatusOperacional := sStatusOperacional + 'BLOQUEIO SEFAZ';
              if aRetorno[iItem] = '2' then
                sStatusOperacional := sStatusOperacional + 'BLOQUEIO CONTRIBUINTE';
              if aRetorno[iItem] = '3' then
              begin
                sStatusOperacional := sStatusOperacional + 'BLOQUEIO AUTÔNOMO';
                FBloqueioAutonomo  := True;
              end;
              if aRetorno[iItem] = '4' then
                sStatusOperacional := sStatusOperacional + 'BLOQUEIO PARA DESATIVAÇÃO';
            end;
        end;
      end;

      FCodigoRetornoSAT := FRetornoStatusOperacional.EEEEE; // Sandro Silva 2017-02-16
      FMensagemSAT      := FRetornoStatusOperacional.mensagem;

      try
        FMensagemSEFAZ := FRetornoStatusOperacional.mensagemSEFAZ;
      except

      end;

      if sStatusOperacional = '' then
        sStatusOperacional := sRetorno;

      if FRetornoStatusOperacional.ConteudoRetorno <> '' then
      begin
        FRetornoStatusOperacional.NumeroSerie := aRetorno[5];
        FNumeroSerie                          := FRetornoStatusOperacional.NumeroSerie;
        FConteudoStatusOperacional            := sStatusOperacional;
      end;
    end; // if aRetorno <> nil then

    if FUltimoNumeroCupom = '' then
      SetUltimoNumeroCupom('000000'); // 2015-06-23

    Result := True;
  except
  end;
  aRetorno := nil; // Sandro Silva 2016-06-14

  if FModoOperacao = moIntegradorMFE then
  begin
    // Integrador não retornou mensagem formatada com PIPE. Repassa o texto da resposta recebida do Integrador
    if Pos('|', sRetorno) = 0 then
    begin
      FMensagemSEFAZ := sRetorno;
    end;
  end;

  Screen.Cursor := FCursor;
end;

function TSmall59.SATConsultarUltimaSessaoFiscal(): String;
// Não testada
var
  sRetorno: String;
begin
  if FModoOperacao = moClient then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
  end
  else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
  end
  else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
  begin

    if FhDLL > 0 then
    begin
      if Chamadacdecl then
        sRetorno := String(_ConsultarUltimaSessaoFiscal_cdecl(idSessao, PAnsiChar(FCodigoAtivacao)))
      else
        sRetorno := String(_ConsultarUltimaSessaoFiscal_stdcall(idSessao, PAnsiChar(FCodigoAtivacao)));
    end;

  end;
  {Sandro Silva 2021-08-23 fim}

  sRetorno := EliminarEspaco(sRetorno);

  FRespostaSAT      := sRetorno;
  FCodigoRetornoSAT := '';

  GravaLog('Consultar Última Sessao Fiscal|' + sRetorno);
end;

procedure TSmall59.SetFCaminhoSATDLL(const Value: String);
begin
  FCaminhoSATDLL := Value;
end;

function TSmall59.SATDesbloquear(codigoDeAtivacao: AnsiString;
  mmLog: TMemo): String;
begin
  {Sandro Silva 2021-08-23 inicio
  try

    case FModoOperacao of
      moClient:
        begin
          ShowMessage('Função não disponível para PDV em modo Cliente SAT');
        end;
      moIntegradorMFE:
        begin
          ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            Result := String(_DesbloquearSAT_cdecl(idSessao, PAnsiChar(codigoAtivacao)))
          else
            Result := String(_DesbloquearSAT_stdcall(idSessao, PAnsiChar(codigoAtivacao)));

        end;
    end;
  except

  end;
  Result := EliminarEspaco(Result); // Sandro Silva 2017-02-10

  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16
  FRespostaSAT      := Result;

  if mmLog <> nil then
  begin
    mmLog.Lines.Add('Retorno ' + Result);
    mmLog.Lines.Add(StatusRetornoSAT(Result));
  end;
  GravaLog('Desbloquear SAT|' + Result);
  }
  ShowMessage('Função não disponível');
  {Sandro Silva 2021-08-23 fim}
end;

function TSmall59.SATDesligar(mmLog: TMemo = nil): String;
begin

  try

    case FModoOperacao of
      moClient:
        begin
          ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
        end;
      moIntegradorMFE:
        begin
          ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
        end;
      moAlone, moServer:
        begin

          if FhDLL > 0 then // Sandro Silva 2022-05-17
          begin
            if Chamadacdecl then
              Result := String(_DesligarSAT_cdecl)
            else
              Result := String(_DesligarSAT_stdcall);
          end;

        end;
    end;

  except

  end;
  Result := EliminarEspaco(Result); // Sandro Silva 2017-02-10

  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16
  FRespostaSAT      := Result;

  GravaLog('Desligar SAT|' + Result);
end;

function TSmall59.SATEnviarDadosVenda(mmLog: TMemo): Boolean; // Sandro Silva 2017-02-20  var mmLog: TMemo): Boolean;
var
  aRetorno: TRetornoSAT;
  iItem: Integer;
  sRetorno: String;
  sCFeSATXML: String;
  sLogErro: String; // Sandro Silva 2015-06-30
  iNumeroSessao: Integer;
begin
  Result   := False;
  aRetorno := nil;

  sLogErro := '';
  FMensagemSEFAZ    := '';
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  try // Finally

    FRetornoVenda.numeroSessao      := '';
    FRetornoVenda.EEEEE             := '';
    FRetornoVenda.CCCC              := '';
    FRetornoVenda.mensagem          := '';
    FRetornoVenda.cod               := '';
    FRetornoVenda.mensagemSEFAZ     := '';
    FRetornoVenda.ArquivoCFeBase64  := '';
    FRetornoVenda.timeStamp         := '';
    FRetornoVenda.ChaveConsulta     := '';
    FRetornoVenda.valorTotalCFe     := '';
    FRetornoVenda.CPFCNPJAdquirente := '';
    FRetornoVenda.assinaturaQRCODE  := '';
    iNumeroSessao := idSessao; // Sandro Silva 2019-06-05
    try
      {Sandro Silva 2021-08-23 inicio
      case FModoOperacao of
        moClient:
          begin
            FRequisicao.Clear;
            FRequisicao.Caixa      := FCaixa;
            FRequisicao.Comando    := CMD_ENVIARDADOSVENDA;// 'EnviarDadosVenda';
            FRequisicao.DadosVenda := FXMLDadosVenda;
            sRetorno := FRequisicao.Enviar;
            //GravaLog(FRequisicao.Comando + ' Retorno Servidor: ' + sRetorno); // Sandro Silva 2019-06-04
          end;
        moIntegradorMFE:
          begin
            sRetorno := FIntegradorMFE.EnviarDadosVenda(IntToStr(idSessao), FXMLDadosVenda, '');
          end;
        moAlone, moServer:
          begin

            if Chamadacdecl then
              sRetorno := String(_EnviarDadosVenda_cdecl(iNumeroSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(FXMLDadosVenda))) // Sandro Silva 2019-06-05 sRetorno := String(_EnviarDadosVenda_cdecl(idSessao, PChar(CodigoAtivacao), PChar(FXMLDadosVenda)))
            else
              sRetorno := String(_EnviarDadosVenda_stdcall(iNumeroSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(FXMLDadosVenda))); // Sandro Silva 2019-06-05 sRetorno := String(_EnviarDadosVenda_stdcall(idSessao, PChar(CodigoAtivacao), PChar(FXMLDadosVenda)));

            sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

            //GravaLog('EnviarDadosVenda Retorno SAT: ' + sRetorno); // Sandro Silva 2019-06-04

          end;
      end; // case FModoOperacao of
      }
      if FModoOperacao = moClient then
      begin
        FRequisicao.Clear;
        FRequisicao.Caixa      := FCaixa;
        FRequisicao.Comando    := CMD_ENVIARDADOSVENDA;// 'EnviarDadosVenda';
        FRequisicao.DadosVenda := FXMLDadosVenda;
        sRetorno := FRequisicao.Enviar;
      end;

      if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
      begin
        sRetorno := FIntegradorMFE.EnviarDadosVenda(IntToStr(idSessao), FXMLDadosVenda, '');
      end;

      if (FModoOperacao = moAlone) or (FModoOperacao =  moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
      begin

        if FhDLL > 0 then // Sandro Silva 2022-05-17
        begin
          if Chamadacdecl then
            sRetorno := String(_EnviarDadosVenda_cdecl(iNumeroSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(FXMLDadosVenda))) // Sandro Silva 2019-06-05 sRetorno := String(_EnviarDadosVenda_cdecl(idSessao, PChar(CodigoAtivacao), PChar(FXMLDadosVenda)))
          else
            sRetorno := String(_EnviarDadosVenda_stdcall(iNumeroSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(FXMLDadosVenda))); // Sandro Silva 2019-06-05 sRetorno := String(_EnviarDadosVenda_stdcall(idSessao, PChar(CodigoAtivacao), PChar(FXMLDadosVenda)));
        end;

        sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

      end;
      {Sandro Silva 2021-08-23 fim}
      if Utf8ToAnsi(sRetorno) <> '' then
        sRetorno := Utf8ToAnsi(sRetorno);

      if   (FFabricanteCodigo = FABRICANTE_SWEDA)
        or (FFabricanteCodigo = FABRICANTE_EMULADOR)
        or (Pos(#13#10, sRetorno) > 0)
        or (Pos(#$D#$A, sRetorno) > 0)
        or (Pos(#$A, sRetorno) > 0)
        then
      begin
        sRetorno := TiraQuebraLinha(sRetorno);
      end;

      FRespostaSAT := sRetorno;

      if (FModoOperacao = moAlone) or (FModoOperacao = moServer) then
      begin
        if Trim(sRetorno) = '' then
        begin

          sRetorno := SATConsultarNumeroSessao(CodigoAtivacao, iNumeroSessao, mmLog);

          if   (FFabricanteCodigo = FABRICANTE_SWEDA)
            or (FFabricanteCodigo = FABRICANTE_EMULADOR)
            or (Pos(#13#10, sRetorno) > 0)
            or (Pos(#$D#$A, sRetorno) > 0)
            or (Pos(#$A, sRetorno) > 0)
            then
          begin
            sRetorno := TiraQuebraLinha(sRetorno);
          end;
          FRespostaSAT := sRetorno;

        end;
      end;

      if mmLog <> nil then
      begin
        mmLog.Lines.Add('');
        mmLog.Lines.Add('XML enviado');
        mmLog.Lines.Add(FXMLDadosVenda);

        mmLog.Lines.Add('');
        mmLog.Lines.Add('Status.: ' + StatusRetornoSAT(sRetorno));
      end;

      // Particiona o retorno
      aRetorno := ExplodeRetorno(sRetorno);

      if aRetorno <> nil then
      begin

        if mmLog <> nil then
        begin
          mmLog.Lines.Add('');
          mmLog.Lines.Add('Parâmetros retornados');
        end;

        // Repassa a partes para o campo
        for iItem := 0 to High(aRetorno) do
        begin
          case iItem of
            0: FRetornoVenda.numeroSessao      := aRetorno[iItem];
            1: FRetornoVenda.EEEEE             := aRetorno[iItem];
            2: FRetornoVenda.CCCC              := aRetorno[iItem];
            3: FRetornoVenda.mensagem          := aRetorno[iItem];
            4: FRetornoVenda.cod               := aRetorno[iItem];
            5: FRetornoVenda.mensagemSEFAZ     := aRetorno[iItem];
            6: FRetornoVenda.ArquivoCFeBase64  := aRetorno[iItem];
            7: FRetornoVenda.timeStamp         := aRetorno[iItem];
            8: FRetornoVenda.ChaveConsulta     := aRetorno[iItem];
            9: FRetornoVenda.valorTotalCFe     := aRetorno[iItem];
           10: FRetornoVenda.CPFCNPJAdquirente := aRetorno[iItem];
           11: FRetornoVenda.assinaturaQRCODE  := aRetorno[iItem];
          end;
          if mmLog <> nil then
            mmLog.Lines.Add(IntToStr(iItem + 1) + ' ' + aRetorno[iItem]);
        end;

        FCodigoRetornoSAT := FRetornoVenda.EEEEE; // Sandro Silva 2017-02-16
        FMensagemSAT      := FRetornoVenda.mensagem;

        FMensagemSEFAZ := FRetornoVenda.mensagemSEFAZ; // Sandro Silva 2016-10-31

        GravaLog('Enviar Dados Venda|' +
              FRetornoVenda.numeroSessao  + '|' +
              FRetornoVenda.EEEEE         + '|' +
              FRetornoVenda.CCCC          + '|' +
              FRetornoVenda.mensagem      + '|' +
              FRetornoVenda.cod           + '|' +
              FRetornoVenda.mensagemSEFAZ + '|' +
              //FRetornoVenda.ArquivoCFeSATbase64 + '|' +
              FRetornoVenda.timeStamp     + '|' +
              FRetornoVenda.ChaveConsulta + '|' +
              FRetornoVenda.valorTotalCFe + '|' +
              FRetornoVenda.CPFCNPJAdquirente //+ '|' +
              //FRetornoVenda.assinaturaQRCODE
              );

        if (FRetornoVenda.EEEEE <> '06000') then
        begin
          if mmLog <> nil then
            mmLog.Lines.Add('Erro retornado ' + DescRetornoErroVenda(FRetornoVenda.CCCC) + ' ' + FRetornoVenda.mensagem);
          sLogErro := 'Código: ' + FRetornoVenda.CCCC + #13 + #10 + FRetornoVenda.mensagem;

          if AnsiContainsText(sRetorno, 'Porta invalida ou em uso.Tente novamente') or AnsiContainsText(sRetorno, 'Porta inválida ou em uso.Tente novamente') then
          begin
            sLogErro := sRetorno;
            SATEnviarDadosVenda(mmLog);
            Exit;
          end;
          {Sandro Silva 2019-04-03 fim}
        end;

        if FRetornoVenda.EEEEE = '06000' then
        begin

          sCFeSATXML := Base64Decode(FRetornoVenda.ArquivoCFeBase64);

          if sCFeSATXML <> '' then
          begin
            FCFeXML    := sCFeSATXML;
            FCFeID     := LimpaNumero(FRetornoVenda.ChaveConsulta);
            FCFeStatus := _59_CFE_EMITIDO_COM_SUCESSO;//'Emitido com sucesso';
            FnCFe      := xmlNodeValue(sCfeSATXML, '//ide/nCFe'); //2014-10-22
            FCFedEmi   := xmlNodeValueToDate(sCfeSATXML, '//ide/dEmi');
            FCFehEmi   := FormatDateTime('HH:nn:ss', xmlNodeValueToTime(sCfeSATXML, '//ide/hEmi'));

            SetUltimoNumeroCupom(FnCFe); // 2015-06-23

            with TArquivo.Create do
            begin
              Texto := FCFeXML;
              SalvarArquivo(ExtractFilePath(Application.ExeName) + 'log\CFe' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Date + Time) + '-' + FCaixa + '-' + FCFeID + '-ret.xml');
              Free;
            end;

          end; // if sCFeSATXML <> '' then

          SalvaXML(sCFeSATXML); // Salva em xmldestinatario

          FLogComando := FRetornoVenda.EEEEE + ' ' + FRetornoVenda.mensagem;
          {Sandro Silva 2013-01-14 final}

          RetornoVenda.ChaveConsulta := FRetornoVenda.ChaveConsulta;
          // Sandro Silva 2018-08-24  FUltimaChave := FRetornoVenda.ChaveConsulta;
        end
        else
        begin
          // Não foi emitido com sucesso
          // Cancela venda

          FLogComando := sLogErro;

          //Grava o xml para identidicar o problema
          CFeXML    := FXMLDadosVenda; // Sandro Silva 2016-11-09  sDados;
          CFeID     := '';
          CFeStatus := FRetornoVenda.mensagem; // 2015-07-09 '';

        end;

      end;
      Result := True;
    except

    end;
  finally
    aRetorno := nil; // Sandro Silva 2016-06-14 
  end;
end;

function TSmall59.SATExtrairLogs(bExibir: Boolean = True;
  mmLog: TMemo = nil): String;
var
  sRetorno: String; // WideString;
  aRetorno: TRetornoSAT;
  sFile: String;
  MS: TStringStream; // Sandro Silva 2021-06-23 MS: TMemoryStream; // Sandro Silva 2016-10-07
  SL: TStringList; // Sandro Silva 2016-10-07
  sTextoLog: String;
  iItem: Integer;
begin
  aRetorno := nil;

  try

    {Sandro Silva 2021-08-23 inicio
    case FModoOperacao of
      moClient:
        begin
          FRequisicao.Clear;
          FRequisicao.Caixa   := FCaixa;
          FRequisicao.Comando := CMD_EXTRAIRLOGS;
          sRetorno := FRequisicao.Enviar;
        end;
      moIntegradorMFE:
        begin
          sRetorno := FIntegradorMFE.ExtrairLogs(IntToStr(idSessao));
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            sRetorno := _ExtrairLogs_cdecl(idSessao, PAnsiChar(FCodigoAtivacao))
          else
            sRetorno := _ExtrairLogs_stdcall(idSessao, PAnsiChar(FCodigoAtivacao));

        end;
    end;
    }
    if FModoOperacao = moClient then
    begin
      FRequisicao.Clear;
      FRequisicao.Caixa   := FCaixa;
      FRequisicao.Comando := CMD_EXTRAIRLOGS;
      sRetorno := FRequisicao.Enviar;
    end
    else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
    begin
      sRetorno := FIntegradorMFE.ExtrairLogs(IntToStr(idSessao));
    end
    else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior) then
    begin

      if Chamadacdecl then
        sRetorno := _ExtrairLogs_cdecl(idSessao, PAnsiChar(FCodigoAtivacao))
      else
        sRetorno := _ExtrairLogs_stdcall(idSessao, PAnsiChar(FCodigoAtivacao));

    end;
    {Sandro Silva 2021-08-23 fim}

    if FFabricanteCodigo = FABRICANTE_SWEDA then
    begin
      sRetorno := TiraQuebraLinha(sRetorno);
    end;

    FRetornoExtrairLogs.numeroSessao     := '';
    FRetornoExtrairLogs.EEEEE            := '';
    FRetornoExtrairLogs.mensagem         := '';
    FRetornoExtrairLogs.cod              := '';
    FRetornoExtrairLogs.mensagemSEFAZ    := '';
    FRetornoExtrairLogs.ArquivoLogBase64 := '';

    FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16
    FRespostaSAT      := sRetorno;

    GravaLog('Extrair Logs|' + sRetorno);

    // Particiona o retorno
    aRetorno := ExplodeRetorno(sRetorno);

    if aRetorno <> nil then
    begin
      // Repassa a partes para o campo
      for iItem := 0 to High(aRetorno) do
      begin
        case iItem of
          0: FRetornoExtrairLogs.numeroSessao     := aRetorno[iItem];
          1: FRetornoExtrairLogs.EEEEE            := aRetorno[iItem];
          2: FRetornoExtrairLogs.mensagem         := aRetorno[iItem];
          3: FRetornoExtrairLogs.cod              := aRetorno[iItem];
          4: FRetornoExtrairLogs.mensagemSEFAZ    := aRetorno[iItem];
          5: FRetornoExtrairLogs.ArquivoLogBase64 := aRetorno[iItem];
        end;
      end;

      FCodigoRetornoSAT := FRetornoExtrairLogs.EEEEE; // Sandro Silva 2017-02-16
      FMensagemSAT      := FRetornoExtrairLogs.mensagem;

      try
        FMensagemSEFAZ := FRetornoExtrairLogs.mensagemSEFAZ;
      except

      end;

      try
        if FRetornoExtrairLogs.ArquivoLogBase64 <> '' then
        begin

          if FRetornoExtrairLogs.EEEEE = '15000' then
          begin
            sTextoLog := Base64Decode(FRetornoExtrairLogs.ArquivoLogBase64);

            sFile := ExtractFilePath(Application.ExeName) + 'log\' + FNumeroSerie + '_' + FCaixa + '_log_sat.txt';

            if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log') = False then
              ForceDirectories(ExtractFilePath(Application.ExeName) + 'log');

            SL := TStringList.Create;
            MS := TStringStream.Create('');
            try

              if Utf8ToAnsi(sTextoLog) <> '' then
                sTextoLog := Utf8ToAnsi(sTextoLog);

              MS.Size := 0;
              MS.WriteBuffer(Pointer(sTextoLog)^, Length(sTextoLog)*SizeOf(Char));

              MS.Seek(0, soBeginning);

              {$IFDEF VER150}
              SL.Clear;
              SL.LoadFromStream(MS);
              SL.SaveToFile(sfile);
              if mmLog <> nil then
                mmLog.Lines.AddStrings(SL);
              {$ELSE}
              TCustomMemoryStream(MS).SaveToFile(sfile);
              if mmLog <> nil then
                mmLog.Lines.Add(MS.DataString);
              {$ENDIF}

              Sleep(1000); // 2021-06-23 Sleep(5000);

            finally
              SL.Free;
              ms.Free;
            end;

            Result := sFile;
            if bExibir then
            begin
              try
                ShellExecute(0, 'open', pChar(sFile), '', '', SW_NORMAL);
              except
              end;
            end;
          end;
        end;
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Não foi possível gerar arquivo de log' + #13 + #13 + E.Message), 'Atenção', MB_ICONWARNING + MB_OK)
        end;
      end;      
    end; // if aRetorno <> nil then

  except

  end;
  aRetorno := nil; // Sandro Silva 2016-06-14
  ChDir(FDiretorioAtual); // Sandro Silva 2017-05-20 
end;

function TSmall59.SATTesteFimAFim(mmLog: TMemo = nil): Boolean;// String;
var
  aRetorno: TRetornoSAT;
  sRetorno: String;
  RetornoTeste: TRetornoTesteFimaFim;
  sDadosTeste: String;
begin
  FCursor := Screen.Cursor;
  Result := False;
  aRetorno := nil;
  try
    RetornoTeste := FRetornoTesteFimaFim;

    FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

    sDadosTeste :=
    // Exemplo xml retirado dos fontes em java do AC demo fornecido pela sefaz
        '<?xml version="1.0" encoding="UTF-8"?>' +
          '<CFe>' +
            '<infCFe versaoDadosEnt="' + FVersaoDadosEnt +'">' +
              '<ide>' +
                '<CNPJ>' + FCNPJSoftwareHouse + '</CNPJ>' +
                '<signAC>' + FAssinaturaAssociada + '</signAC>' +
              '</ide>' +
              '<emit>' +
                '<CNPJ>' + FEmitente.CNPJ + '</CNPJ>' +
                '<IE>' + FEmitente.IE + '</IE>' +
                '<IM>' + FEmitente.IM + '</IM>' +
                '<xFant>teste</xFant>' +
                '<cRegTribISSQN>1</cRegTribISSQN>' +
                '<indRatISSQN>N</indRatISSQN>' +
              '</emit>' +
              '<dest/>' +
              '<det nItem="1">' +
                '<prod>' +
                  '<cProd>00001</cProd>' +
                  '<xProd>Produto X</xProd>' +
                  '<CFOP>0001</CFOP>' +
                  '<uCom>un</uCom>' +
                  '<qCom>1.0000</qCom>' +
                  '<vUnCom>2.100</vUnCom>' +
                  '<indRegra>A</indRegra>' +
                '</prod>' +
                '<imposto>' +
                  '<ICMS>' +
                    '<ICMS40>' +
                      '<Orig>1</Orig>' +
                      '<CST>41</CST>' +
                    '</ICMS40>' +
                  '</ICMS>' +
                  '<PIS>' +
                    '<PISAliq>' +
                      '<CST>01</CST>' +
                      '<vBC>2.10</vBC>' +
                      '<pPIS>0.0165</pPIS>' +
                    '</PISAliq>' +
                  '</PIS>' +
                  {
                  '<PISST>' +
                    '<vBC>1.00</vBC>' +
                  '</PISST>' +
                  }
                  '<COFINS>' +
                    '<COFINSAliq>' +
                      '<CST>01</CST>' +
                      '<vBC>2.10</vBC>' +
                      '<pCOFINS>0.0760</pCOFINS>' +
                    '</COFINSAliq>' +
                  '</COFINS>' +
                  {
                  '<COFINSST>' +
                    '<pCOFINS>1.0000</pCOFINS>' +
                  '</COFINSST>' +
                  }
                '</imposto>' +
              '</det>' +
              '<pgto>' +
                '<MP>' +
                  '<cMP>01</cMP>' +
                  '<vMP>2.10</vMP>' +
                  '</MP>' +
              '</pgto>' +
              '<total/>' +
            '</infCFe>' +
          '</CFe>';

    {Sandro Silva 2021-08-23 inicio
    case FModoOperacao of
      moClient:
        begin
          FRequisicao.Clear;
          FRequisicao.Caixa      := FCaixa;
          FRequisicao.Comando    := CMD_TESTEFIMAFIM;// 'TesteFimAFim';
          sRetorno := FRequisicao.Enviar;
        end;
      moIntegradorMFE:
        begin
          sRetorno := FIntegradorMFE.TesteFimaFim(IntToStr(idSessao), PAnsiChar(sDadosTeste));
        end;
      moAlone, moServer:
        begin

          if Chamadacdecl then
            sRetorno := String(_TesteFimAFim_cdecl(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(sDadosTeste)))
          else
            sRetorno := String(_TesteFimAFim_stdcall(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(sDadosTeste)));

        end;
    end;
    }
    if FModoOperacao = moClient then
    begin
      FRequisicao.Clear;
      FRequisicao.Caixa      := FCaixa;
      FRequisicao.Comando    := CMD_TESTEFIMAFIM;// 'TesteFimAFim';
      sRetorno := FRequisicao.Enviar;
    end
    else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
    begin
      sRetorno := FIntegradorMFE.TesteFimaFim(IntToStr(idSessao), PAnsiChar(sDadosTeste));
    end
    else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
    begin

      if FhDLL > 0 then // Sandro Silva 2022-05-17
      begin
        if Chamadacdecl then
          sRetorno := String(_TesteFimAFim_cdecl(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(sDadosTeste)))
        else
          sRetorno := String(_TesteFimAFim_stdcall(idSessao, PAnsiChar(CodigoAtivacao), PAnsiChar(sDadosTeste)));
      end;

    end;
    {Sandro Silva 2021-08-23 fim}

    {Sandro Silva 2017-05-08 final}

    sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

    sRetorno := TiraQuebraLinha(sRetorno);

    FRespostaSAT := sRetorno;

    if mmLog <> nil then
    begin
      mmLog.Lines.Add('Retorno ' + sRetorno);
      mmLog.Lines.Add(StatusRetornoSAT(sRetorno));
    end;
    GravaLog('Teste Fim a Fim|' + sRetorno);
  except
    Result := False;
  end;
  Screen.Cursor := FCursor;
  FreeAndNil(RetornoTeste);
end;

function TSmall59.SATTrocarCodigoDeAtivacao(codigoDeAtivacao, novoCodigo,
  confNovoCodigo: AnsiString; mmLog: TMemo = nil): String;
var
  sRetorno: String;
begin
  {Sandro Silva 2021-08-23 inicio
  case FModoOperacao of
    moClient:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente SAT');
      end;
    moIntegradorMFE:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
      end;
    moAlone, moServer:
      begin

        if Chamadacdecl then
          sRetorno := String(_TrocarCodigoDeAtivacao_cdecl(idSessao, PAnsiChar(codigoDeAtivacao), 2, PAnsiChar(novoCodigo), PAnsiChar(confNovoCodigo)))
        else
          sRetorno := String(_TrocarCodigoDeAtivacao_stdcall(idSessao, PAnsiChar(codigoDeAtivacao), 2, PAnsiChar(novoCodigo), PAnsiChar(confNovoCodigo)));

      end;
  end;
  }
  if FModoOperacao = moClient then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente ' + IfThen(Emitente.UF = 'CE', 'MFE', 'SAT'));
  end
  else if (FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior = False) then
  begin
    ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
  end
  else if (FModoOperacao = moAlone) or (FModoOperacao = moServer) or ((FModoOperacao = moIntegradorMFE) and (FDriverMFE01_05_15_Superior)) then
  begin

    if FhDLL > 0 then // Sandro Silva 2022-05-17
    begin
      if Chamadacdecl then
        sRetorno := String(_TrocarCodigoDeAtivacao_cdecl(idSessao, PAnsiChar(codigoDeAtivacao), 2, PAnsiChar(novoCodigo), PAnsiChar(confNovoCodigo)))
      else
        sRetorno := String(_TrocarCodigoDeAtivacao_stdcall(idSessao, PAnsiChar(codigoDeAtivacao), 2, PAnsiChar(novoCodigo), PAnsiChar(confNovoCodigo)));
    end;

  end;
  {Sandro Silva 2021-08-23 fim}

  sRetorno := EliminarEspaco(sRetorno); // Sandro Silva 2017-02-10

  FRespostaSAT      := sRetorno;
  FCodigoRetornoSAT := ''; // Sandro Silva 2017-02-16

  if mmLog <> nil then
  begin
    mmLog.Lines.Add('Retorno ' + Result);
    mmLog.Lines.Add(StatusRetornoSAT(Result));
  end;
  GravaLog('Trocar Código Ativação|' + sRetorno);
end;

function TSmall59.DescRetornoErroVenda(CCCC: String): String;
begin
  while Length(CCCC) < 5 do
    CCCC := '0' + CCCC;

  if CCCC = '01001' then
    Result := 'Sem conexão com a Internet ou sítio da SEFAZ fora do Ar';
  if CCCC = '01002' then
    Result := 'Código da UF não confere com a Tabela do IBGE';
  if CCCC = '01003' then
    Result := 'Erro Código da UF diferente da UF registrada no SAT';
  if CCCC = '01004' then
    Result := 'Rejeição: Versão do leiaute do arquivo de entrada do SAT não é válida';
  if CCCC = '01005' then
    Result := 'Alerta: Versão do leiaute do arquivo de entrada do SAT não é a mais atual';
  if CCCC = '01226' then
    Result := 'Rejeição: Código da UF do Emitente diverge da UF receptora';
  if CCCC = '01450' then
    Result := 'Rejeição: Código de modelo de documento fiscal diferente de 59';
  if CCCC = '01258' then
    Result := 'Rejeição: Data/hora inválida. Problemas com o relógio interno do SAT-CF-e';
  if CCCC = '01224' then
    Result := 'Rejeição: CNPJ da Software House inválido';
  if CCCC = '01222' then
    Result := 'Rejeição: Assinatura do Aplicativo Comercial não é válida';
  if CCCC = '01207' then
    Result := 'Rejeição: CNPJ do emitente inválido';
  if CCCC = '01203' then
    Result := 'Rejeição: Emitente não autorizado para uso do SAT.';
  if CCCC = '01229' then
    Result := 'Rejeição: IE do emitente não informada';
  if CCCC = '01209' then
    Result := 'Rejeição: IE do emitente inválida';
  if CCCC = '01230' then
    Result := 'Rejeição: IE do emitente diferente da IE do contribuinte autorizado para uso do SAT';
  if CCCC = '01456' then
    Result := 'Rejeição: Código de Regime Tributário inválido';
  if CCCC = '01457' then
    Result := 'Rejeição: Código de Natureza da Operação para ISSQN inválido';
  if CCCC = '01507' then
    Result := 'Rejeição: Indicador de rateio para ISSQN inválido';
  if CCCC = '01235' then
    Result := 'Rejeição: CNPJ do destinatário inválido';
  if CCCC = '01237' then
    Result := 'Rejeição: CPF do destinatário inválido';
  if CCCC = '01234' then
    Result := 'Alerta: Razão Social/Nome do destinatário em branco';
  if CCCC = '01019' then
    Result := 'Rejeição: numeração dos itens não é sequencial crescente';
  if CCCC = '01459' then
    Result := 'Rejeição: Código do produto ou serviço em branco';
  if CCCC = '01460' then
    Result := 'Rejeição: GTIN do item (N) inválido';
  if CCCC = '01461' then
    Result := 'Rejeição: Descrição do produto ou serviço em branco';
  if CCCC = '01462' then
    Result := 'Rejeição: CFOP não é de Operação de saída prevista para CF-e'; // Sandro Silva 2018-08-01
  if CCCC = '01463' then
    Result := 'Rejeição: Unidade Comercia do produto ou serviço em branco';
  if CCCC = '01464' then
    Result := 'Rejeição: Quantidade Comercial do item (N) inválido';
  if CCCC = '01465' then
    Result := 'Rejeição: Valor Unitário do item (N) inválido';
  if CCCC = '01467' then
    Result := 'Rejeição: Regra de cálculo do Item (N) inválido (diferente de "A" e "T")';
  if CCCC = '01468' then
    Result := 'Rejeição: Valor do Desconto do item (N) inválido';
  if CCCC = '01469' then
    Result := 'Rejeição: Valor de outras despesas acessórias do item (N) inválido';
  if CCCC = '01220' then
    Result := 'Rejeição: Valor do rateio do desconto sobre subtotal do item (N) inválido';
  if CCCC = '01228' then
    Result := 'Rejeição: Valor do rateio do acréscimo sobre subtotal do item (N) inválido';
  if CCCC = '01471' then
    Result := 'Rejeição:Origem da mercadoria do Item (N) inválido (diferente de 0, 1 e 2)';
  if CCCC = '01472' then
    Result := 'Rejeição:CST do Item (N) inválido (diferente de 00, 20, 90)';
  if CCCC = '01473' then
    Result := 'Rejeição: Alíquota efetiva do ICMS do item (N) não é maior ou igual a zero';
  if CCCC = '01471' then
    Result := 'Rejeição:Origem da mercadoria do Item (N) inválido (diferente de 0, 1 e 2)';
  if CCCC = '01475' then
    Result := 'Rejeição:CST do Item (N) inválido (diferente de 40 e 41 e 50 e 60)';
  if CCCC = '01471' then
    Result := 'Rejeição:Origem da mercadoria do Item (N) inválido (diferente de 0, 1 e 2)';
  if CCCC = '01476' then
    Result := 'Rejeição:Código de situação da operação - Simples Nacional - do Item (N) inválido (diferente de 102, 300 e 500)';
  if CCCC = '01471' then
    Result := 'Rejeição:Origem da mercadoria do Item (N) inválido (diferente de 0, 1 e 2)';
  if CCCC = '01477' then
    Result := 'Rejeição:Código de situação da operação - Simples Nacional - do Item (N) inválido (diferente de 900)';
  if CCCC = '01473' then
    Result := 'Rejeição: Alíquota efetiva do ICMS do item (N) não é maior ou igual a zero';
  if CCCC = '01478' then
    Result := 'Rejeição: Código de Situação Tributária do PIS Inválido (diferente de 01 e 02)';
  if CCCC = '01479' then
    Result := 'Rejeição: Base de cálculo do PIS do item (N) inválido';
  if CCCC = '01480' then
    Result := 'Rejeição: Alíquota do PIS do item (N) não é maior ou igual a zero';
  if CCCC = '01482' then
    Result := 'Rejeição: Código de Situação Tributária do PIS Inválido (diferente de 03)';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) não é maior ou igual a zero';
  if CCCC = '01484' then
    Result := 'Rejeição: Alíquota do PIS em R$ do item (N) não é maior ou igual a zero';
  if CCCC = '01486' then
    Result := 'Rejeição: Código de Situação Tributária do PIS Inválido (diferente de 04, 06, 07, 08 e 09)';
  if CCCC = '01487' then
    Result := 'Rejeição: Código de Situação Tributária do PIS inválido (diferente de 49)';
  if CCCC = '01488' then
    Result := 'Rejeição: Código de Situação Tributária do PIS Inválido (diferente de 99)';
  if CCCC = '01479' then
    Result := 'Rejeição: Base de cálculo do PIS do item (N) inválido';
  if CCCC = '01480' then
    Result := 'Rejeição: Alíquota do PIS do item (N) inválido';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) inválido';
  if CCCC = '01484' then
    Result := 'Rejeição: Alíquota do PIS em R$ do item (N) inválido';
  if CCCC = '01479' then
    Result := 'Rejeição: Base de cálculo do PIS do item (N) inválido';
  if CCCC = '01480' then
    Result := 'Rejeição: Alíquota do PIS do item (N) inválida';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) inválida';
  if CCCC = '01484' then
    Result := 'Rejeição: Alíquota do PIS em R$ do item (N) inválida';
  if CCCC = '01490' then
    Result := 'Rejeição: Código de Situação Tributária da COFINS Inválido (diferente de 01 e 02)';
  if CCCC = '01491' then
    Result := 'Rejeição: Base de cálculo do COFINS do item (N) inválido';
  if CCCC = '01492' then
    Result := 'Rejeição: Alíquota da COFINS do item (N) não é maior ou igual a zero';
  if CCCC = '01494' then
    Result := 'Rejeição: Código de Situação Tributária da COFINS Inválido (diferente de 03)';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) não é maior ou igual a zero';
  if CCCC = '01496' then
    Result := 'Rejeição: Alíquota da COFINS em R$ do item (N) não é maior ou igual a zero';
  if CCCC = '01498' then
    Result := 'Rejeição: Código de Situação Tributária da COFINS Inválido (diferente de 04, 06, 07, 08 e 09)';
  if CCCC = '01499' then
    Result := 'Rejeição: Código de Situação Tributária da COFINS Inválido (diferente de 49)';
  if CCCC = '01500' then
    Result := 'Rejeição: Código de Situação Tributária da COFINS Inválido (diferente de 99)';
  if CCCC = '01491' then
    Result := 'Rejeição: Base de cálculo da COFINS do item (N) inválido';
  if CCCC = '01492' then
    Result := 'Rejeição: Alíquota da COFINS do item (N) não é maior ou igual a zero';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) não é maior ou igual a zero';
  if CCCC = '01496' then
    Result := 'Rejeição: Alíquota da COFINS em R$ do item (N) não é maior ou igual a zero';
  if CCCC = '01491' then
    Result := 'Rejeição: Base de cálculo da COFINS do item (N) inválido';
  if CCCC = '01492' then
    Result := 'Rejeição: Alíquota da COFINS do item (N) não é maior ou igual a zero';
  if CCCC = '01483' then
    Result := 'Rejeição: Qtde Vendida do item (N) não é maior ou igual a zero';
  if CCCC = '01496' then
    Result := 'Rejeição: Alíquota da COFINS em R$ do item (N) não é maior ou igual a zero';
  if CCCC = '01501' then
    Result := 'Rejeição: Operação com tributação de ISSQN sem informar a Inscrição Municipal';
  if CCCC = '01503' then
    Result := 'Rejeição: Valor das deduções para o ISSQN do item (N) não é maior ou igual a zero';
  if CCCC = '01505' then
    Result := 'Rejeição: Alíquota efetiva do ISSQN do item (N) não é maior ou igual a 2,00 (2%) e menor ou igual a 5,00 (5%)';
  if CCCC = '01287' then
    Result := 'Rejeição: Código Município do FG - ISSQN: dígito inválido. Exceto os códigos descritos no Anexo 2 que apresentam dígito inválido';
  if CCCC = '01508' then
    Result := 'Rejeição: Item da lista de Serviços do ISSQN do item (N) não é maior ou igual a zero';
  if CCCC = '01509' then
    Result := 'Rejeição:Código municipal de Tributação do ISSQN do Item (N) em branco';
  if CCCC = '01510' then
    Result := 'Rejeição: Código de Natureza da Operação para ISSQN inválido';
  if CCCC = '01511' then
    Result := 'Rejeição: Indicador de Incentivo Fiscal do ISSQN do item (N) inválido (diferente de 1 e 2)';
  if CCCC = '01527' then
    Result := 'Rejeição: Código do Meio de Pagamento inválido';
  if CCCC = '01528' then
    Result := 'Rejeição: Valor do Meio de Pagamento inválido';
  if CCCC = '01408' then
    Result := 'Rejeição: Valor total do CF-e maior que o somatório dos valores de Meio de Pagamento empregados em seu pagamento';// Sandro Silva 2018-08-01
  if CCCC = '01409' then
    Result := 'Rejeição: Valor total do CF-e supera o máximo permitido no arquivo de Parametrização de Uso'; // Sandro Silva 2018-08-01
  if CCCC = '01073' then
    Result := 'Rejeição: Valor de Desconto sobre total não é maior ou igual a zero';
  if CCCC = '01074' then
    Result := 'Rejeição: Valor de Acréscimo sobre total não é maior ou igual a zero';
  if CCCC = '01218' then
    Result := 'Chave de acesso do CF-e já consta como cancelado'; // Sandro Silva 2018-08-01
  if CCCC = '01221' then
    Result := 'Aplicativo Comercial não vinculado ao SAT';
  if CCCC = '01083' then
    Result := 'Sem conexão com a Rede Local';
  if CCCC = '01084' then
    Result := 'Formatação do Certificado não é válido';
  if CCCC = '01085' then
    Result := 'Assinatura do Aplicativo Comercial não confere com o registro do SAT';
  if CCCC = '01999' then
   Result := 'Rejeição: Erro não identificado';
end;

function TSmall59.xmlNodeValue(sXML: String; sNode: String): String;
{Sandro Silva 2012-02-08 inicio
Extrai valor do elemento no xml}
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
  function utf8Fix(sTexto: String): String;
  const
    acento : array[1..46] of string = ('á', 'à', 'â', 'ã', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï', 'ó', 'ò', 'ô', 'õ', 'ö', 'ú', 'ù', 'û', 'ü', 'ç', 'Á', 'À', 'Â', 'Ã', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï', 'Ó', 'Ò', 'Ô', 'Õ', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç');
    utf8: array[1..46] of string = ('Ã¡','Ã ','Ã¢','Ã£','Ã¤','Ã©','Ã¨','Ãª','Ã«','Ã­','Ã¬','Ã®','Ã¯','Ã³','Ã²','Ã´','Ãµ','Ã¶','Ãº','Ã¹','Ã»','Ã¼','Ã§','Ã','Ã€','Ã‚','Ãƒ','Ã„','Ã‰','Ãˆ','ÃŠ','Ã‹','Ã','ÃŒ','ÃŽ','Ã','Ã“','Ã’','Ã”','Ã•','Ã–','Ãš','Ã™','Ã›','Ãœ','Ã‡');
  var
    iLetra: Integer;
  begin
    Result := sTexto;
    for iLetra := 1 to length(utf8) do
    begin
      if Pos(utf8[iLetra], Result) > 0 then
        Result := StringReplace(Result, utf8[iLetra], acento[iLetra], [rfReplaceAll]);
    end;
  end;
begin
  XMLDOM := CoDOMDocument.Create;
  XMLDOM.loadXML(sXML);

  Result := '';
  xNodes := XMLDOM.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := utf8fix(xNodes.item[iNode].text);

  end;
  XMLDOM := nil;
end;

function TSmall59.DescRetornoErroCancelamentoVenda(CCCC: String): String;
var
  iCCCC: Integer;
begin
  iCCCC := StrToIntDef(CCCC, 1999);
  if iCCCC = StrToInt('01270') then
    Result := 'Rejeição: Chave de acesso do CFe a ser cancelado inválido';
  if iCCCC = StrToInt('01412') then
    Result := 'Rejeição: CFe de cancelamento não corresponde ao CFe anteriormente gerado';
  if iCCCC = StrToInt('01258') then
    Result := 'Rejeição: Data/hora inválida. Problemas com o relógio interno do SAT-CF-e';
  if iCCCC = StrToInt('01210') then
    Result := 'Rejeição: Intervalo de tempo entre a emissão do CF-e a ser cancelado e a emissão do respectivo CF-e de cancelamento é maior que 30 (trinta) minutos';
  if iCCCC = StrToInt('01454') then
    Result := 'Rejeição: CNPJ da Software House inválido';
  if iCCCC = StrToInt('01455') then
    Result := 'Rejeição: Assinatura do Aplicativo Comercial não é válida';
  if iCCCC = StrToInt('01232') then
    Result := 'Rejeição: CNPJ do destinatário do CF-e de cancelamento diferente daquele do CF-e a ser cancelado';
  if iCCCC = StrToInt('01233') then
    Result := 'Rejeição: CPF do destinatário do CF-e de cancelamento diferente daquele do CF-e a ser cancelado';
  if iCCCC = StrToInt('01999') then
    Result := 'Erro de validação do conteúdo';
end;

function TSmall59.ImprimirCupomDinamico(sCFeXML: String;
  Destino: TDestinoExtrato; Ambiente: String; sFileExport: String = ''): Boolean;
const PERCENTUAL_LARGURA_LOGO_X_LARGURA_PAPEL = 0.2721518987341772;
const LARGURA_REFERENCIA_PAPEL_BOBINA = 640; //639
const LARGURA_IMPRESSAO_VALOR_FORMAS_PAGAMENTO = 80;
var
  Tipo: TTipoExtrato;
  QRCodeBMP: TBitmap;
  Logotipo: TBitmap;
  iPrimeiraLinhaPapel: Integer; // Posição onde pode ser impresso a primeira linha em cada página
  iLinha: Integer;
  iMargemRazaoSocial: Integer;
  iAlturaFonte: Integer;
  iLarguraFonte: Integer;
  sTracos: String;
  iNode: Integer;
  sCNPJCPFDestinatario: String;
  sItem: String;
  dDescSobreItem: Double;
  dDescRateioSubTotalItem: Double;
  dAcreRateioSubTotalItem: Double;
  dItemvDeducISSQN: Double;
  dItemvBCISSQN: Double;
  dTotalDescSobreItem: Double;
  dTotalBrutoItens: Double;
  sChaveConsulta: String;
  snserieSAT: String;
  xNodeItens: IXMLDOMNodeList;
  XMLCFe: IXMLDOMDocument;
  dTotal: Double;
  dDescontoNoTotalCupom: Double;
  dAcrescimoNoTotalCupom: Double;

  Canvas: TCanvas;
  sinfCFeId: String;
  iLarguraFisica: Integer;
  iPixelsPerInch: Integer;
  iPageHeight: Integer;
  sFileCFeSAT: String;
  Pagina: Array of TImage; // Imagem que receberá os textos e outras imagem
  iAlturaPDF: Integer;
  PDF: TPrintPDF;
  iPagina: Integer;
  sRazaoEmitente: String;
  iLinhasFinal: Integer;
  iPrinterPhysicalWidth: Integer; // Sandro Silva 2017-09-12
  tpAmbiente: TAmbiente;

  sRetornoGeraPDF: String;
  function GetPrinterPhysicalWidth: Integer;
  begin
    Result := GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// Sandro Silva 2018-06-15  Result := GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH);
  end;

  function FormataChaveConsulta(sChaveConsulta: String): String;
  begin
    // Para facilitar a consulta, as 44 posições que compõem a chave de consulta deverão ser
    // divididas em 11 blocos de 4 posições cada, com 2 espaços entre cada bloco.
    // Obs.: Usando 2 espaços entre blocos o texto não cabe em 1 linha
    while sChaveConsulta <> '' do
    begin
      Result := Result + Copy(sChaveConsulta, 1, 4) + ' ';
      sChaveConsulta := StringReplace(sChaveConsulta, Copy(sChaveConsulta, 1, 4), '', []);
    end;

  end;

  function CriaPagina: TImage;
  var
    iPages: Integer;
    procedure NumerarPagina(Canvas: TCanvas; iNumero: Integer);
    begin
      Canvas.Font.Size := Canvas.Font.Size - 2;
      SetTextAlign(Canvas.Handle, TA_RIGHT);
      Canvas.TextOut(iLarguraPapel, iAlturaPDF - iAlturaFonte, 'Página ' + IntToStr(iNumero));
      SetTextAlign(Canvas.Handle, TA_LEFT);
      Canvas.Font.Size := Canvas.Font.Size + 2;
    end;
  begin
    try
      SetLength(Pagina, Length(Pagina) + 1);
      iPages := High(Pagina);
      Pagina[iPages]              := TImage.Create(Application);
      Pagina[iPages].Parent       := Application.MainForm;//  Form1;
      Pagina[iPages].Proportional := True;
      Pagina[iPages].Visible      := False;
      Pagina[iPages].Height       := iAlturaPDF;
      if iPages = 0 then
        Pagina[iPages].Top := 0
      else
        Pagina[iPages].Top := Pagina[iPages -1 ].BoundsRect.Bottom + 10;
      Pagina[iPages].Left                       := 0;
      Pagina[iPages].Width                      := iLarguraPapel;// Sandro Silva 2017-04-17  iLarguraFisica;
      Pagina[iPages].Canvas.Brush.Color         := clWhite;
      Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 * 2;// 14;
      Pagina[iPages].Canvas.Font.Style          := [fsBold];
      Pagina[iPages].Picture.Bitmap.PixelFormat := pf32bit; // 2015-05-15 pf24bit; // pf32bit; //2014-04-30
      Pagina[iPages].Picture.Bitmap.Height      := Pagina[iPages].Height;
      Pagina[iPages].Picture.Bitmap.Width       := Pagina[iPages].Width;
      Canvas := Pagina[iPages].Canvas;
      Canvas.Font.PixelsPerInch := 215; // Sandro Silva 2017-04-13  203;
      Canvas.Font.Size          := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 Acertar a fonte depois de Canvas.Font.PixelsPerInch, que deixa a fonte menor
      iMargemEsq          := 10;
      iLinha              := 50;
      iAlturaFonte        := Pagina[iPages].Canvas.TextHeight('Ég');// - 3; // Sandro Silva 2017-04-17 ; // Calcula a altura ocupada pelo texto, inclusive acentuados ou caracteres como "jgyqçp";
      iLarguraFonte       := Pagina[iPages].Canvas.TextWidth('W');
      iPrimeiraLinhaPapel := iLinha + iAlturaFonte;
      Pagina[iPages].Canvas.Font.Style := [];
      Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; //14;

      if iPages > 0 then
        iLinha := iPrimeiraLinhaPapel;

      iPageHeight := Pagina[iPages].Height;

      // Numerando as páginas
      NumerarPagina(Pagina[iPages].Canvas, iPages + 1);
      Result := Pagina[iPages];
    except
      Result := nil
    end;
  end;

  function CanvasLinha(var iPosicao: Integer; mm: Double; iTopo: Integer): Integer;
  {Sandro Silva 2013-01-10 inicio
  Avança a posição verticar do Canvas para impressão}
  begin

    iPosicao := iPosicao + Round(mm);

    if Destino = toImage then
    begin
      if iPosicao + Trunc(mm / 3) > (iAlturaPDF - (iAlturaFonte * 2)) then
        CriaPagina;
    end
    else
    begin
      if iPosicao >= (iPageHeight - (iAlturaFonte * 2)) then // Controla avanço de páginas // Sandro Silva 2018-03-20  if iPosicao >= (Printer.PageHeight - (iAlturaFonte * 2)) then // Controla avanço de páginas
      begin
        Printer.NewPage;
        iPosicao := iTopo;
      end;
    end;
    Result := iPosicao;
  end;

  procedure PrinterTexto(iLinha: Integer; iColuna: Integer;
    Texto: String; Alinhamento: TAlinhamento = poLeft; FontName: String = FONT_NAME_DEFAULT);
  begin
    Canvas.Font.Name := FontName; // 2016-01-14

    case Alinhamento of
      poCenter:
        begin
          if Destino = toImage then
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2) + iMargemEsq // 2014-05-09
          else
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2);
        end;
      poRight:
        begin
          iColuna := iLarguraPapel;
          SetTextAlign(Canvas.Handle, TA_RIGHT);
        end;
    end;

    Canvas.TextOut(iColuna, iLinha, Texto);

    SetTextAlign(Canvas.Handle, TA_LEFT);
  end;

  procedure PrinterTextoMemo(var iLinha: Integer; iColuna: Integer;
    const iLargura: Integer; Texto: String; Alinhamento: TAlinhamento = poLeft);
  var
    iMemoLine: Integer;
    sTextoLinha: String;
    reTexto: TMemo;
    slTexto: TStringList;
    sTextoOrig: String;
    sTexto: String;

    function sBreakApart(BaseString, BreakString: String; StringList: TStringList): TStringList;
    var
      EndOfCurrentString: Byte;
    begin
      repeat
        EndOfCurrentString := Pos(BreakString, BaseString);
        if EndOfCurrentString = 0 then
          StringList.Add(BaseString)
        else
          StringList.Add(Copy(BaseString, 1, EndOfCurrentString - 1));
        BaseString := Copy(BaseString, EndOfCurrentString + Length(BreakString), Length(BaseString) - EndOfCurrentString);

      until EndOfCurrentString = 0;
      Result := StringList;
    end;

    procedure CanvasTextOut;
    begin

      if Destino = toImage then
      begin
        if (iLinha + Canvas.TextHeight(sTextoLinha)) > iAlturaPDF then
          CriaPagina;
      end;

      case Alinhamento of
        poCenter:
          begin
            iColuna := Round((iLargura - Canvas.TextWidth(sTextoLinha)) / 2);
          end;
        poRight:
          begin
            iColuna := iLargura;
            SetTextAlign(Canvas.Handle, TA_RIGHT);
          end;
      end;

      Canvas.TextOut(iColuna, iLinha, Trim(sTextoLinha));

      SetTextAlign(Canvas.Handle, TA_LEFT);

    end;
  begin
    reTexto := TMemo.Create(nil);
    reTexto.Left       := -1000;
    reTexto.Top        := -1000;
    reTexto.Visible    := False;
    reTexto.Parent     := Application.MainForm; // Sandro Silva 2017-04-27  Screen.ActiveForm;
    reTexto.ParentFont := False;
    reTexto.Font       := Canvas.Font;
    reTexto.Width      := iLargura;
    reTexto.Repaint;

    slTexto    := TStringList.create;
    sTextoOrig := Texto;
    sTexto     := sTextoOrig;
    reTexto.Lines.Assign(sBreakApart(sTextoOrig, ' ', slTexto));

    sTextoOrig := StringReplace(sTextoOrig, #$D#$A, '', [rfReplaceAll]);
    {Sandro Silva 2018-03-16 inicio
    sTextoOrig := StringReplace(sTextoOrig, '  ', ' ', [rfReplaceAll]);
    }
    while AnsiContainsText(sTextoOrig, '  ') do
      sTextoOrig := StringReplace(sTextoOrig, '  ', ' ', [rfReplaceAll]);
    {Sandro Silva 2018-03- fim}
    iMemoLine := 0;
    while (sTextoOrig <> '') do
    begin
      sTexto := reTexto.Lines.Strings[iMemoLine] + ' ';
      if (Canvas.TextWidth(sTextoLinha + sTexto) <= iLargura) and (iMemoLine <= reTexto.Lines.Count) then
      begin
        sTextoLinha := StringReplace(sTextoLinha + sTexto, '  ', ' ', [rfReplaceAll]);
      end
      else
      begin
        sTextoOrig := StringReplace(StringReplace(sTextoOrig, StringReplace(sTextoLinha, '  ', ' ', [rfReplaceAll]), '', [rfIgnoreCase]), #$D#$A, '', [rfIgnoreCase]);

        CanvasTextOut;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        sTextoLinha := sTexto + ' ';
      end;

      Inc(iMemoLine);

      if iMemoLine >= reTexto.Lines.Count then
        Break;

    end;

    if (Trim(sTextoOrig) <> '') then
    begin

      sTextoLinha := sTextoOrig;

      CanvasTextOut;

    end;

  end;

  procedure PrinterTraco(var iLinha: Integer; iColuna: Integer; iComprimento: Integer; Color: TColor = clBlack);
  begin
    Inc(iLinha, 10); // 2014-10-22
    Canvas.Pen.Color := Color;
    Canvas.MoveTo(iColuna, iLinha);
    Canvas.LineTo(iComprimento, iLinha);
  end;

  procedure ImprimeMensagemTeste;
  var
    iVezes: Integer;
  begin
    // Imprimir quando em ambiente de teste. Texto obrigatório
    if tpAmbiente = taTeste then  //[1-Produção 2-Testes]
    begin
      //https://portal.fazenda.sp.gov.br/servicos/sat/Downloads/Manual_Orientacao_SAT_v_MO_2_12_02.pdf
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      Canvas.Font.Style := [fsItalic, fsBold];
      PrinterTexto(iLinha, iMargemEsq, '= T E S T E =', poCenter);
      Canvas.Font.Style := [];
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      for iVezes := 1 to 3 do
      begin
        PrinterTexto(iLinha, iMargemEsq, DupeString('>', Trunc(iLarguraPapel div Canvas.TextWidth('>') -1))); // Sandro Silva 2016-12-07
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      end;
    end;

  end;

  procedure Cabecalho;
  var
    iLogoheight: Integer;
    sNumeroExtrato: String; // Sandro Silva 2017-10-26
  begin
    iLogoheight := 0;
    if FileExists('logofrente.bmp') then
    begin
      try

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        Logotipo := TBitmap.Create;
        Logotipo.PixelFormat := pf32bit; //2014-04-30

        Logotipo.LoadFromFile('logofrente.bmp');

        iLogoheight := Round(PERCENTUAL_LARGURA_LOGO_X_LARGURA_PAPEL * iLarguraPapel);
        if iLarguraPapel <= 464 then
        begin
          iLogoheight := (iLarguraPapel - iMargemEsq) div 2;
        end;

        if Destino = toImage then
        begin
          if iLarguraFisica > LARGURA_REFERENCIA_PAPEL_BOBINA then
            iLogoheight := Round(iLogoheight * 0.5);
        end
        else
        begin
          if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then // Sandro Silva 2017-09-12
            iLogoheight := Round(iLogoheight * 2);
        end;

        ResizeBitmap(Logotipo, iLogoheight, iLogoheight, clWhite);

        if iLarguraPapel <= 464 then
        begin
          Canvas.Draw((iLarguraPapel - iMargemEsq - iLogoheight) div 2, iLinha, Logotipo);
          iMargemRazaoSocial := iMargemEsq;
          iLinha := iLinha + iLogoheight;
        end
        else
        begin
          Canvas.Draw(iMargemEsq, iLinha, Logotipo);
          iMargemRazaoSocial := Logotipo.Width + iMargemEsq + 26;
        end;

      except

      end;
    end;

    if Logotipo <> nil then
      FreeAndNil(Logotipo);

    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    sRazaoEmitente := xmlNodeValue(sCFeXML, '//emit/xNome');
    if iLarguraPapel <= 464 then
    begin
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, sRazaoEmitente, poCenter);

      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      if xmlNodeValue(sCFeXML, '//emit/enderEmit/xCpl') = '' then
        PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xLgr') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/nro'), poCenter)
      else
        PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xLgr') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/nro') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/xCpl'), poCenter);//, poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xBairro'), poCenter); //, poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

      // O emulador não retornou no xml o estado do contribuinte
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, Trim(xmlNodeValue(sCFeXML, '//emit/enderEmit/xMun') + ' - ' + UFSigla(xmlNodeValue(sCFeXML, '//ide/cUF'))), poCenter); // Sandro Silva 2018-03-15

    end
    else
    begin
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, sRazaoEmitente);

      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      if xmlNodeValue(sCFeXML, '//emit/enderEmit/xCpl') = '' then
        PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xLgr') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/nro'))
      else
        PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xLgr') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/nro') + ', ' + xmlNodeValue(sCFeXML, '//emit/enderEmit/xCpl'));//, poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, xmlNodeValue(sCFeXML, '//emit/enderEmit/xBairro')); //, poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

      // O emulador não retornou no xml o estado do contribuinte
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, Trim(xmlNodeValue(sCFeXML, '//emit/enderEmit/xMun') + ' - ' + UFSigla(xmlNodeValue(sCFeXML, '//ide/cUF'))), poLeft); // Sandro Silva 2018-03-15
    end;

    if (iPrimeiraLinhaPapel + iLogoheight) > Canvas.PenPos.Y then
    begin
      CanvasLinha(iLinha, (((iPrimeiraLinhaPapel + iLogoheight) - Canvas.PenPos.Y) + iAlturaFonte), iPrimeiraLinhaPapel);
    end
    else
    begin
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    end;

    if (Canvas.TextWidth('CNPJ ' + FormataCpfCgc(xmlNodeValue(sCFeXML, '//emit/CNPJ')) + ' IE ' + xmlNodeValue(sCFeXML, '//emit/IE') + ' IM ' + xmlNodeValue(sCFeXML, '//emit/IM')) > (iLarguraPapel - iMargemEsq)) then
    begin
      PrinterTexto(iLinha, iMargemEsq, 'CNPJ ' + FormataCpfCgc(xmlNodeValue(sCFeXML, '//emit/CNPJ')), poCenter);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTexto(iLinha, iMargemEsq, 'IE ' + xmlNodeValue(sCFeXML, '//emit/IE'), poCenter);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTexto(iLinha, iMargemEsq, 'IM ' + xmlNodeValue(sCFeXML, '//emit/IM'), poCenter);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    end
    else
    begin
      PrinterTexto(iLinha, iMargemEsq, 'CNPJ ' + FormataCpfCgc(xmlNodeValue(sCFeXML, '//emit/CNPJ')) + ' IE ' + xmlNodeValue(sCFeXML, '//emit/IE') + ' IM ' + xmlNodeValue(sCFeXML, '//emit/IM'), poCenter);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    end;

    PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
    CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

    Canvas.Font.Style := [fsBold];
    if tpAmbiente <> taProducao then  //[1-Produção 2-Testes]
      sNumeroExtrato := '000000' //  “I – TÍTULO”, por meio da impressão do texto “=   T E S T E  =” e de 3 linhas de caracteres “>”. O número do Extrato deverá constar como “000000”.
    else
      sNumeroExtrato := xmlNodeValue(sCFeXML, '//ide/nCFe');
    PrinterTexto(iLinha, iMargemEsq, 'Extrato Nº ' + sNumeroExtrato, poCenter);

    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    PrinterTexto(iLinha, iMargemEsq, 'CUPOM FISCAL ELETRÔNICO - SAT', poCenter);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    Canvas.Font.Style := [];

    ImprimeMensagemTeste; // Sandro Silva 2017-10-26

  end;

  function ImpressaoCodigoBarras(sChaveConsulta, sQRCode: String): Integer;
  var
    iAlturaQRCode: Integer;
    iAlturaCode128: Integer;
    iLarguraCode128: Integer;
    iMargemEsquerdaCode128: Integer;
    iVerticalCode128: Integer;
    bChave2Linhas: Boolean;
    Code128C: TAsBarcode;

    procedure PosicaoCODE128;
    begin
      // Mudou a página recalcula a posição da impressão do código de barras
      iAlturaCode128         := iLinha + 20;
      iLarguraCode128        := 2;
      iMargemEsquerdaCode128 := iMargemEsq + 10;
      iVerticalCode128       := iLinha + 100;// 2014-04-29 50;// 2014-04-28 100;
    end;
  begin
    iAlturaQRCode := 360; // Sandro Silva 2016-04-01
    try
      // Impressão barras CODE128

      iAlturaCode128         := iLinha + 20;
      iLarguraCode128        := 2;
      iMargemEsquerdaCode128 := iMargemEsq + 10;
      iVerticalCode128       := iLinha + 100;

      if Destino = toImage then
      begin

        // Code128 caberá na página atual
        if iAlturaPDF <= iAlturaCode128 then
        begin
          CriaPagina;

          PosicaoCODE128; // Mudou a página recalcula a posição da impressão do código de barras
        end;

        if iVerticalCode128 >= iAlturaPDF then // Controla avanço de páginas
        begin
          CriaPagina;

          PosicaoCODE128; // Mudou a página recalcula a posição da impressão do código de barras
        end;

        // Impressora padrão tem largura de papel maior que a largura de bobina. Ex. A4
        if iLarguraFisica > LARGURA_REFERENCIA_PAPEL_BOBINA then
        begin
          iLarguraCode128        := 2;
          iMargemEsquerdaCode128 := Round((iLarguraPapel - (280 * iLarguraCode128)) / 2);// + 14; //Round((iLarguraPapel - 560) / 2) + 14; //(iMargemEsq + 10) * iLarguraCode128;//Round((iLarguraPapel - iMargemEsq - Image.Canvas.TextWidth(sChaveConsulta)) / 2) - 50;
          iVerticalCode128       := iLinha + 100;
        end;

      end
      else
      begin // Impressora

        if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then // Sandro Silva 2017-09-12
        begin
          iLarguraCode128        := 6;
          iMargemEsquerdaCode128 := Round((iLarguraPapel - (280 * iLarguraCode128)) / 2) + 14; //Round((iLarguraPapel - 560) / 2) + 14; //Round((iLarguraPapel - iMargemEsq - Printer.Canvas.TextWidth(sChaveConsulta)) / 2) - 50;
          iVerticalCode128       := iLinha + 250;// 300; //200; //100;
        end;

        if (iVerticalCode128) >= iPageHeight then // Controla avanço de páginas // Sandro Silva 2018-03-20  if (iVerticalCode128) >= Printer.PageHeight then // Controla avanço de páginas
        begin
          Printer.NewPage;
          iLinha := iPrimeiraLinhaPapel;//50;
        end;

      end; // if Destino = toImage then

      bChave2Linhas := False;
      if Canvas.TextWidth(FormataChaveConsulta(sChaveConsulta)) > (iLarguraPapel - iMargemEsq) then
      begin

        bChave2Linhas := True;
                                                        //280
        iMargemEsquerdaCode128 := iMargemEsq + 30; //(((iLarguraPapel - iMargemEsq) - (200 * iLarguraCode128)) div 2) + 14;//Round(((iLarguraPapel - iMargemEsq) - (190 * iLarguraCode128)) / 2) + 14;

        if (iPrinterPhysicalWidth > 464) and (iPrinterPhysicalWidth < 576) then
          iMargemEsquerdaCode128 := iMargemEsq + 110;

        iAlturaCode128         := iLinha + 20;
        iVerticalCode128       := iLinha + 100;// 300; //200; //100;

        //
        // Adaptar para imprimir barras code128c usando classe delphi, eliminar componente instalado TCJVBarCode
        //

        CanvasLinha(iLinha, iAlturaFonte div 2, iPrimeiraLinhaPapel);

        Code128C        := TAsBarcode.Create(Application);
        Code128C.Typ    := bcCode128C;

        Code128C.Top    := iLinha;
        Code128C.Width  := 340; // Sandro Silva 2018-06-18   380;

        Code128C.Height := 80;
        Code128C.Modul  := 2;
        Code128C.Text   := Copy(sChaveConsulta, 1, 22);

        if (FTamanhoPapel = '76') then // Sandro Silva 2018-06-18
          Code128C.Left   := ((iLarguraPapel - Code128C.Width - iMargemEsquerdaCode128) div 2) + 70
        else
          Code128C.Left   := ((iLarguraPapel - iMargemEsquerdaCode128 - Code128C.Width) div 2) + 30;// Sandro Silva 2018-06-18  iMargemEsq + 30;

        Code128C.DrawBarcode(Canvas);

        CanvasLinha(iLinha, Code128C.Height + (iAlturaFonte div 4), iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18  iLinha := iLinha + Code128C.Height; // Sandro Silva 2018-03-22

        Code128C.Top    := iLinha;
        Code128C.Text   := Copy(sChaveConsulta, 23, 22);

        Code128C.DrawBarcode(Canvas);

        CanvasLinha(iLinha, Code128C.Height + (iAlturaFonte div 2), iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18  CanvasLinha(iLinha, Code128C.Height + iAlturaFonte, iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18  iLinha := iLinha + Code128C.Height; // Sandro Silva 2018-03-22

        Code128C.Free;

      end
      else
      begin
        //
        // Adaptar para imprimir barras code128c usando classe delphi, eliminar componente instalado TCJVBarCode
        //
        CanvasLinha(iLinha, iAlturaFonte div 2, iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18

        Code128C        := TAsBarcode.Create(Application);
        Code128C.Typ    := bcCode128C;

        Code128C.Text   := sChaveConsulta;
        Code128C.Top    := iLinha;
        if (FTamanhoPapel <> 'A4') then // Sandro Silva 2018-06-18
          Code128C.Height := 80 // Sandro Silva 2018-06-18
        else
          Code128C.Height := 240; // Sandro Silva 2018-06-18  80;
        if (Destino = toImage) or (FTamanhoPapel <> 'A4') then // Sandro Silva 2018-06-18
          Code128C.Modul  := 2
        else
          Code128C.Modul  := 4;// Sandro Silva 2018-06-18
        if (FTamanhoPapel <> 'A4') then // Sandro Silva 2018-06-18
          Code128C.Width  := iLarguraPapel - Code128C.Left - iMargemEsquerdaCode128; // Sandro Silva 2018-06-18

        Code128C.Left   := (iLarguraPapel - Code128C.Width - iMargemEsquerdaCode128) div 2;
        Code128C.DrawBarcode(Canvas);

        CanvasLinha(iLinha, Code128C.Height + (iAlturaFonte), iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18 iLinha := iLinha + Code128C.Height; // Sandro Silva 2018-03-22

        Code128C.Free; // Sandro Silva 2022-03-14        
      end;

      if Destino = toPrinter then
      begin
        // Corrige a posição vertical para impressão do qrcode

        if FTamanhoPapel = 'A4' then
          CanvasLinha(iLinha, iAlturaFonte div 6, iPrimeiraLinhaPapel);

      end
      else
        CanvasLinha(iLinha, iAlturaFonte div 6, iPrimeiraLinhaPapel); // Sandro Silva 2018-06-18  iLinha := iAlturaCode128; // 2014-05-12

      if (bChave2Linhas = False) then
        if Destino = toImage then // Sandro Silva 2018-06-18
          CanvasLinha(iLinha, iAlturaFonte * 1.1, iPrimeiraLinhaPapel);// CanvasLinha(iLinha, iAlturaFonte * 3, iPrimeiraLinhaPapel);  

      QRCodeBMP             := TBitmap.Create;
      QRCodeBMP.PixelFormat := pf32bit; //2014-04-30

      ImagemQRCode(sQRCode, QRCodeBMP);

      if Destino = toPrinter then
      begin

        // Sandro Silva 2017-09-12  if GetPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
        if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then // Sandro Silva 2017-09-12
        begin
          iAlturaQRCode := 900;
        end;

        if bChave2Linhas = False then // Sandro Silva 2018-06-18
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        if (iLinha + iAlturaQRCode) >= iPageHeight then // Controla avanço de páginas // Sandro Silva 2018-03-20  if (iLinha + iAlturaQRCode) >= Printer.PageHeight then // Controla avanço de páginas
        begin
          Printer.NewPage;
          iLinha := iPrimeiraLinhaPapel;//50;
        end;

      end
      else
      begin // Imagem
        if iAlturaPDF <= (iLinha + iAlturaQRCode) then
          CriaPagina;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      end;

      ResizeBitmap(QRCodeBMP, iAlturaQRCode, iAlturaQRCode, clWhite);
      if Destino = toImage then
      begin
        Canvas.Draw(((iLarguraPapel - iAlturaQRCode) div 2), iLinha, QRCodeBMP)//Canvas.Draw(Round((iLarguraPapel - (iAlturaQRCode)) / 2), iLinha, QRCodeBMP)
      end
      else // Impressora
      begin
        Canvas.Draw(((iLarguraPapel - iAlturaQRCode) div 2) + 14, iLinha, QRCodeBMP);//Canvas.Draw(Round((iLarguraPapel - (iAlturaQRCode)) / 2) + 14, iLinha, QRCodeBMP);
      end;
      {Sandro Silva 2018-03-15 fim}

      CanvasLinha(iLinha, 6, iPrimeiraLinhaPapel);

      CanvasLinha(iLinha, iAlturaQRCode, iPrimeiraLinhaPapel);

    except

    end;
    Result := iAlturaQRCode; // Sandro Silva 2016-03-21

    if QRCodeBMP <> nil then
      FreeAndNil(QRCodeBMP);
  end;

  procedure ImpressaoChaveConsulta(sChaveConsulta: String);
  begin
    if Destino = toImage then
    begin
      if iAlturaPDF <= (iLinha + (iAlturaFonte * 1.5)) then
        CriaPagina;
    end;

    sChaveConsulta := FormataChaveConsulta(sChaveConsulta);

    if Destino = toImage then
    begin
      if Canvas.TextWidth(sChaveConsulta) > (iLarguraPapel - iMargemEsq) then
      begin
        //3518 0311 1111 1111 1111 5912 3456 7890 0004 6770 3292
        PrinterTexto(iLinha, iMargemEsq, Copy(sChaveConsulta, 1, 29), poCenter, 'Tahoma');
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, Copy(sChaveConsulta, 30, 25), poCenter, 'Tahoma');
      end
      else
      begin
        PrinterTexto(iLinha, iMargemEsq, sChaveConsulta, poCenter, 'Tahoma');
      end;

    end
    else
    begin
      Canvas.Font.Style := [fsBold];
      if Canvas.TextWidth(sChaveConsulta) > (iLarguraPapel - iMargemEsq) then
      begin
        //3518 0311 1111 1111 1111 5912 3456 7890 0004 6770 3292
        PrinterTexto(iLinha, iMargemEsq, Copy(sChaveConsulta, 1, 29), poCenter);
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, Copy(sChaveConsulta, 30, 25), poCenter);
      end
      else
      begin
        PrinterTexto(iLinha, iMargemEsq, sChaveConsulta, poCenter);
      end;
    end;
    Canvas.Font.Style := [];

    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
  end;

  procedure ImpressaoObsFisco;
  var
    iNodeObsFisco: Integer;
    xNodeObsFisco: IXMLDOMNodeList;
  begin
    xNodeObsFisco := XMLCFe.selectNodes('//obsFisco');
    for iNodeObsFisco := 0 to xNodeObsFisco.length -1 do
    begin
      PrinterTextoMemo(iLinha, iMargemEsq, iLarguraPapel - 20, xmlNodeValue(sCFeXML, '//obsFisco[' + IntToStr(iNodeObsFisco) + ']/@xCampo') + ': ' +
                                                               xmlNodeValue(sCFeXML, '//obsFisco[' + IntToStr(iNodeObsFisco) + ']/xTexto'), poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    end;
    xNodeObsFisco := nil; // Sandro Silva 2016-06-14
  end;

begin
  FCursor       := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Tipo := tVenda;
  try
    try

      XMLCFe := CoDOMDocument.Create;
      XMLCFe.loadXML(sCFeXML);

      // XML de cancelamento não tem a tag <tpamb>
      if xmlNodeValue(sCFeXML, '//ide/tpAmb') <> '' then
      begin
        if xmlNodeValue(sCFeXML, '//ide/tpAmb') = '1' then
          tpAmbiente := taProducao
        else
          tpAmbiente := taTeste;
      end
      else
      begin
        if Ambiente = 'PRODUCAO' then
          tpAmbiente := taProducao
        else
          tpAmbiente := taTeste;
      end;

      Tipo := tVenda;
      if LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@chCanc')) <> '' then
        Tipo := tCancelamento;

      Canvas := TCanvas.Create;

      Printer.Title := xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id');
      Printer.BeginDoc;

      Canvas := Printer.Canvas; // Sandro Silva 2017-09-12

      if Destino = toImage then
      begin
        iAlturaPDF     := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  3508; // Sandro Silva 2017-04-13  2350;
        iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;
        iPixelsPerInch := 600; // Sandro Silva 2017-04-11  103;
      end
      else
      begin
        iLarguraFisica := GetPrinterPhysicalWidth;

        if FTamanhoPapel <> '' then
        begin
          if FTamanhoPapel = '58' then
            iLarguraFisica := 384;
          if FTamanhoPapel = '76' then
            iLarguraFisica := 512;
          if FTamanhoPapel = '80' then
            iLarguraFisica := 576; //588;
          if FTamanhoPapel = 'A4' then
            iLarguraFisica := 4961;
        end;

        if (FTamanhoPapel <> 'A4') and (iLarguraFisica > LARGURA_REFERENCIA_PAPEL_BOBINA) then// Sandro Silva 2018-06-15  if GetPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
        begin
          iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;// 1678;
        end;

        iPixelsPerInch := 600; // Sandro Silva 2016-12-07
        iPageHeight  := Printer.PageHeight;  //nops xxxx 2448
      end;

      if Destino = toPrinter then
      begin
        Printer.Canvas.Font.Name          := FONT_NAME_DEFAULT;
        Printer.Canvas.Font.Size          := FONT_SIZE_DEFAULT;
        Printer.Canvas.Font.Style         := [fsBold];
        Printer.Canvas.Font.PixelsPerInch := iPixelsPerInch; // 2014-05-09
        Canvas.Font.PixelsPerInch         := iPixelsPerInch;// GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSX);
        iMargemEsq                        := 2;// Sandro Silva 2018-03-20  5;// 2015-05-07 0;
        iLinha                            := 50;

        iAlturaFonte                      := Printer.Canvas.TextHeight('Ég') - 1;// Sandro Silva 2017-04-18  Printer.Canvas.TextHeight('Ég') - 3; // Calcula a altura ocupada pelo texto;
        iLarguraFonte                     := Printer.Canvas.TextWidth('W');

        iPrinterPhysicalWidth := iLarguraFisica;// Sandro Silva 2018-06-15  GetPrinterPhysicalWidth; // Sandro Silva 2017-09-12

        if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
          iLarguraPapel := 1678
        else
          if iPrinterPhysicalWidth > 464 then
          begin
            if iPrinterPhysicalWidth < 576 then // Sandro Silva 2018-06-15
              iLarguraPapel := 512
            else
              iLarguraPapel := iPrinterPhysicalWidth //512 - Sweda SI-300  // Sandro Silva 2018-06-13  576
          end
          else
            iLarguraPapel := iPrinterPhysicalWidth;// Sandro Silva 2018-06-14  GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// Área de impressão descontando margens Sandro Silva 2016-12-07   Printer.PageWidth;

        Printer.Canvas.Font.Style := [];
        Printer.Canvas.Font.Name  := FONT_NAME_DEFAULT;
        Printer.Canvas.Font.Size  := FONT_SIZE_DEFAULT;

        iPrimeiraLinhaPapel       := 50 + iAlturaFonte;// Sandro Silva 2017-04-18  40 + iAlturaFonte;
      end
      else
      begin
        iLarguraPapel             := 588; // Sandro Silva 2017-04-18  576;// LARGURA_REFERENCIA_PAPEL_BOBINA; // Sandro Silva 2017-04-10
        CriaPagina; // Cria nova página no array
      end;

      sTracos := DupeString('_', Trunc(iLarguraPapel / Canvas.TextWidth('_')));

      Cabecalho;

      if Tipo = tCancelamento then
      begin

        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

        Canvas.Font.Style := [fsBold];
        PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), 'DADOS DO CUPOM FISCAL ELETRÔNICO CANCELADO', poCenter);// Sandro Silva 2018-03-15  PrinterTexto(iLinha, iMargemEsq, 'DADOS DO CUPOM FISCAL ELETRÔNICO CANCELADO', poCenter);
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        Canvas.Font.Style := [];

      end;

      if (xmlNodeValue(sCFeXML, '//dest/CNPJ') <> '') then
        sCNPJCPFDestinatario := Trim(xmlNodeValue(sCFeXML, '//dest/CNPJ'))
      else
        sCNPJCPFDestinatario := Trim(xmlNodeValue(sCFeXML, '//dest/CPF'));

      if (sCNPJCPFDestinatario <> '') or (xmlNodeValue(sCFeXML, '//dest/xNome') <> '') then // Ficha 4251 Sandro Silva 2018-10-01 if (sCNPJCPFDestinatario <> '') then
      begin
        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

        if (sCNPJCPFDestinatario <> '') then // Ficha 4251 Sandro Silva 2018-10-01
        begin
          sCNPJCPFDestinatario := FormataCpfCgc(sCNPJCPFDestinatario);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), 'CPF/CNPJ do consumidor: ' + sCNPJCPFDestinatario); //, poLeft);
        end;

        if (xmlNodeValue(sCFeXML, '//dest/xNome') <> '') then
        begin
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), 'Razão social/Nome: ' + xmlNodeValue(sCFeXML, '//dest/xNome'));
        end;

        if (Tipo = tCancelamento) then
        begin
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        end
        else
        begin
          if FExtratoDetalhado then
          begin
            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
            CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
          end;
        end;
      end
      else
      begin
        if FExtratoDetalhado = False then
        begin
          PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
          CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
        end;
      end;

      if Tipo = tVenda then
      begin

        if FExtratoDetalhado then
        begin
          if (sCNPJCPFDestinatario = '') then
          begin
            PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
            CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
          end;

          Canvas.Font.Size := FONT_SIZE_DEFAULT - 1; // 2016-01-19
          if Destino = toImage then
          begin
            PrinterTexto(iLinha, iMargemEsq, '# | COD | DESC | QTD | UN | VL UN R$ | VL TR R$ | VL ITEM R$', poLeft, 'Tahoma')
          end
          else
          begin
            Canvas.Font.Name := FONT_NAME_DEFAULT; //'Verdana';
            PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), '# | COD | DESC | QTD | UN | VL UN R$ | VL TR R$ | VL ITEM R$', poLeft);
          end;
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          Canvas.Font.Size := FONT_SIZE_DEFAULT;
          Canvas.Font.Name := FONT_NAME_DEFAULT;


          PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
          CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

          dTotalDescSobreItem := 0.00; // Sandro Silva 2017-04-13
          dTotalBrutoItens    := 0.00; // Sandro Silva 2017-04-13

          xNodeItens := XMLCFe.selectNodes('//det');
          for iNode := 0 to xNodeItens.length -1 do
          begin

            sItem := xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/@nItem');
            if xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/cEAN') <> '' then
              sItem := sItem  + ' ' + xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/cEAN')
            else
              sItem := sItem + ' ' + xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/cProd');

            sItem := sItem + ' ' + xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/xProd');

            if (iLinha + (iAlturaFonte * 3) >= iPageHeight) then
            begin
              CanvasLinha(iLinha, (iAlturaFonte * 3), iPrimeiraLinhaPapel);
            end;

            if Canvas.TextWidth(sItem) > (iLarguraPapel - iMargemEsq) then
            begin
              PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), sItem);//, poLeft);
            end
            else
            begin
              PrinterTexto(iLinha, iMargemEsq, sItem);//, poLeft);
            end;

            dDescSobreItem          := 0.00;
            dDescRateioSubTotalItem := 0.00;
            dAcreRateioSubTotalItem := 0.00;

            sItem := '';
            if Frac(ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/qCom'))) = 0 then
              sItem := sItem + ' ' + FloatToStr(ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/qCom'))) // Quantidade Comercializada do Item
            else
              if Trim(FConfiguracaoCasasDecimaisQtd) <> '' then
                sItem := sItem + ' ' + FormatFloat(',0.' + DupeString('0', StrToIntDef(Trim(FConfiguracaoCasasDecimaisQtd), 3)), ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/qCom'))) // Quantidade Comercializada do Item
              else
                sItem := sItem + ' ' + FormatFloat(',0.00', ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/qCom'))); // Quantidade Comercializada do Item

            sItem := sItem + ' ' + xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/uCom');
            // Está sempre formatando com 2 casas decimais. Buscar da configuração das casas decimais definido no retaguarda
            if Trim(FConfiguracaoCasasDecimaisPreco) <> '' then
              sItem := sItem + ' X ' + FormatFloat(',0.' + DupeString('0', StrToIntDef(Trim(FConfiguracaoCasasDecimaisPreco), 3)), ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vUnCom')))
            else
              sItem := sItem + ' X ' + FormatFloat(',0.00', ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vUnCom')));

            sItem := sItem + '(' + StrZero(ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/imposto/vItem12741')), 1, 2) + ')';

            sItem := sItem + ' ' + FormatFloat(',0.00', ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vProd')));

            if (Canvas.TextWidth(sItem) + iLarguraFonte + Canvas.PenPos.X) > iLarguraPapel then
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

            PrinterTexto(iLinha, iMargemEsq, sItem, poRight);

            dTotalBrutoItens := dTotalBrutoItens + ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vProd'));

            //Descontos/Acréscimos
            if xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vDesc') <> '' then
              dDescSobreItem := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vDesc'));
            if xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vRatDesc') <> '' then
              dDescRateioSubTotalItem := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vRatDesc'));

            if xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vRatAcr') <> '' then
              dAcreRateioSubTotalItem := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vRatAcr'));

            dItemvDeducISSQN := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vDeducISSQN'));

            if (dDescSobreItem > 0) or (dDescRateioSubTotalItem > 0) or (dAcreRateioSubTotalItem > 0) or (dItemvDeducISSQN > 0) then
            begin

              if dItemvDeducISSQN > 0 then
              begin
                CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
                PrinterTexto(iLinha, iMargemEsq, ' dedução para ISSQN');
                PrinterTexto(iLinha, iMargemEsq, '-' + StrZero(dItemvDeducISSQN, 1, 2), poRight);
              end;

              if (dDescSobreItem > 0) then
              begin
                CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
                PrinterTexto(iLinha, iMargemEsq, ' desconto sobre item');
                PrinterTexto(iLinha, iMargemEsq, '-' + StrZero(dDescSobreItem, 1, 2), poRight);
              end;
              if (dDescRateioSubTotalItem > 0) then
              begin
                CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
                PrinterTexto(iLinha, iMargemEsq, ' rateio de desconto sobre subtotal');
                PrinterTexto(iLinha, iMargemEsq, '-' + StrZero(dDescRateioSubTotalItem, 1, 2), poRight);
              end;
              if (dAcreRateioSubTotalItem > 0) then
              begin
                CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
                PrinterTexto(iLinha, iMargemEsq, ' rateio de acréscimo sobre subtotal');
                PrinterTexto(iLinha, iMargemEsq, '+' + StrZero(dAcreRateioSubTotalItem, 1, 2), poRight);
              end;

              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
              PrinterTexto(iLinha, iMargemEsq, 'valor líquido');
              PrinterTexto(iLinha, iMargemEsq, StrZero(ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/prod/vProd'))
                                                                + dAcreRateioSubTotalItem
                                                                - dItemvDeducISSQN
                                                                - dDescSobreItem
                                                                - dDescRateioSubTotalItem, 1, 2), poRight);
            end;

            dItemvBCISSQN := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vBC'));
            if (xmlNodeValue(sCFeXML, '//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vBC') <> '') then
            begin
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
              PrinterTexto(iLinha, iMargemEsq, ' base de cálculo ISSQN');
              PrinterTexto(iLinha, iMargemEsq, StrZero(dItemvBCISSQN, 1, 2), poRight);
            end;
            CanvasLinha(iLinha, iAlturaFonte / 2, iPrimeiraLinhaPapel); // Sandro Silva 2017-04-13

            dTotalDescSobreItem := dTotalDescSobreItem + dDescSobreItem;

            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

          end; // for iNode := 0 to xNodeItens.length -1 do

          // Primeiro identifica o valor do desconto/acrescimo
          dDescontoNoTotalCupom  := 0.00;
          dAcrescimoNoTotalCupom := 0.00;

          if ValueXmlToFloat(xmlNodeValue(sCFeXML, '//total/DescAcrEntr/vDescSubtot')) > 0 then
          begin
            dDescontoNoTotalCupom := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//total/DescAcrEntr/vDescSubtot'));
          end;
          if ValueXmlToFloat(xmlNodeValue(sCFeXML, '//total/DescAcrEntr/vAcresSubtot')) > 0 then
          begin
            dAcrescimoNoTotalCupom := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//total/DescAcrEntr/vAcresSubtot'));
          end;

          CanvasLinha(iLinha, iAlturaFonte / 2, iPrimeiraLinhaPapel);

          if (dTotalDescSobreItem > 0) or
            (dDescontoNoTotalCupom > 0) or
            (dAcrescimoNoTotalCupom > 0) then
          begin

            if (dTotalBrutoItens > 0) then
            begin
              PrinterTexto(iLinha, iMargemEsq, 'Total bruto de itens', poLeft);
              PrinterTexto(iLinha, iMargemEsq, StrZero(dTotalBrutoItens, 1, 2), poRight);
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            end;

            if (dTotalDescSobreItem > 0 ) then
            begin
              PrinterTexto(iLinha, iMargemEsq, 'Total desconto/acréscimo sobre item', poLeft);
              PrinterTexto(iLinha, iMargemEsq, '-' + StrZero(dTotalDescSobreItem, 1, 2), poRight);
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            end;

            if dDescontoNoTotalCupom > 0 then
            begin
              PrinterTexto(iLinha, iMargemEsq, 'Desconto sobre subtotal', poLeft);
              PrinterTexto(iLinha, iMargemEsq, '-' + StrZero(dDescontoNoTotalCupom, 1, 2), poRight);
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            end;

            if dAcrescimoNoTotalCupom > 0 then
            begin
              PrinterTexto(iLinha, iMargemEsq, 'Acréscimo sobre subtotal', poLeft);
              PrinterTexto(iLinha, iMargemEsq, '+' + StrZero(dAcrescimoNoTotalCupom, 1, 2), poRight);
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            end;
          end;

        end
        else
        begin
          if (sCNPJCPFDestinatario <> '') then
            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        end; // if sExtratoResumido <> 'Sim' then

      end; //if Tipo = tVenda then

      Canvas.Font.Style := [fsBold];
      PrinterTexto(iLinha, iMargemEsq, 'Total R$', poLeft);
      dTotal := ValueXmlToFloat(xmlNodeValue(sCFeXML, '//total/vCFe'));

      if (FExtratoDetalhado) and (Tipo = tVenda) then
        PrinterTexto(iLinha, iMargemEsq, StrZero(dTotal, 1, 2), poRight)
      else
        PrinterTexto(iLinha, Canvas.PenPos.X + 10, StrZero(dTotal, 1, 2), poLeft);
      Canvas.Font.Style := [];

      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      CanvasLinha(iLinha, iAlturaFonte / 2, iPrimeiraLinhaPapel);

      if Tipo = tVenda then
      begin
        if FExtratoDetalhado then
        begin

          xNodeItens := XMLCFe.selectNodes('//MP');
          for iNode := 0 to xNodeItens.length -1 do
          begin
            {Sandro Silva 2021-11-23 inicio
            PrinterTexto(iLinha, iMargemEsq, DescFormaPagamento(xmlNodeValue(sCFeXML, '//MP[' + IntToStr(iNode) + ']/cMP')), poLeft);
            }

            if Canvas.TextWidth(DescFormaPagamento(xmlNodeValue(sCFeXML, '//MP[' + IntToStr(iNode) + ']/cMP'))) > (iLarguraPapel - iMargemEsq - LARGURA_IMPRESSAO_VALOR_FORMAS_PAGAMENTO) then
            begin
              PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq - LARGURA_IMPRESSAO_VALOR_FORMAS_PAGAMENTO), DescFormaPagamento(xmlNodeValue(sCFeXML, '//MP[' + IntToStr(iNode) + ']/cMP')));//, poLeft);
            end
            else
            begin
              PrinterTexto(iLinha, iMargemEsq, DescFormaPagamento(xmlNodeValue(sCFeXML, '//MP[' + IntToStr(iNode) + ']/cMP')));
            end;
            {Sandro Silva 2021-11-23 fim}
            
            PrinterTexto(iLinha, iMargemEsq, StrZero(ValueXmlToFloat(xmlNodeValue(sCFeXML, '//MP[' + IntToStr(iNode) + ']/vMP')), 1, 2), poRight);
            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          end;

          // Sempre imprimir tag troco
          PrinterTexto(iLinha, iMargemEsq, 'Troco R$', poLeft);
          PrinterTexto(iLinha, iMargemEsq, StrZero(ValueXmlToFloat('0' + xmlNodeValue(sCFeXML, '//pgto/vTroco')), 1, 2), poRight);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

          CanvasLinha(iLinha, iAlturaFonte / 2, iPrimeiraLinhaPapel);

        end;// if sExtratoResumido <> 'Sim' then

        //Grupo do campo de uso livre do Fisco
        ImpressaoObsFisco;

        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

        sChaveConsulta := LimpaNumero(xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id'));
        sinfCFeId := xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id');

        if xmlNodeValue(sCFeXML, '//entrega/xLgr') <> '' then
        begin
          PrinterTexto(iLinha, iMargemEsq, 'DADOS PARA ENTREGA', poLeft);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), xmlNodeValue(sCFeXML, '//entrega/xLgr') + ', ' +
                                                                             xmlNodeValue(sCFeXML, '//entrega/nro') + ', ' +
                                                                             xmlNodeValue(sCFeXML, '//entrega/xBairro') + ', ' +
                                                                             xmlNodeValue(sCFeXML, '//entrega/xMun') + '-' + xmlNodeValue(sCFeXML, '//entrega/UF'), poLeft);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTraco(iLinha, iMargemEsq, iLarguraPapel); // Sandro Silva 2016-10-04
          CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel); // Sandro Silva 2016-10-04
        end;

        // Observações do contribuinte: Nome do aplicativo, versão, nº caixa, operador, mensagem promocional...
        if Trim(xmlNodeValue(sCFeXML, '//infAdic/infCpl')) <> '' then
        begin
          PrinterTexto(iLinha, iMargemEsq, 'OBSERVAÇÕES DO CONTRIBUINTE', poLeft);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTextoMemo(iLinha, iMargemEsq, iLarguraPapel, Trim(xmlNodeValue(sCFeXML, '//infAdic/infCpl')), poLeft);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        end;

        // Valor dos impostos (Lei da Dilma)
        if Canvas.TextWidth('Valor total aproximado dos tributos deste cupom*') > (iLarguraPapel - iMargemEsq) then
        begin
          PrinterTextoMemo(iLinha, iMargemEsq, iLarguraPapel - iMargemEsq, 'Valor total aproximado dos tributos deste cupom*');
          PrinterTexto(iLinha, iMargemEsq, 'R$ ' + StrZero(ValueXmlToFloat('0' + xmlNodeValue(sCFeXML, '//total/vCFeLei12741')), 1, 2), poRight);
        end
        else
        begin
          PrinterTexto(iLinha, iMargemEsq, 'Valor total aproximado dos tributos deste cupom*', poLeft);
          PrinterTexto(iLinha, iMargemEsq, 'R$ ' + StrZero(ValueXmlToFloat('0' + xmlNodeValue(sCFeXML, '//total/vCFeLei12741')), 1, 2), poRight);
        end;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, '(conforme Lei Fed.12.741/2012)', poLeft);
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

        Canvas.Font.Style := [fsBold];
        snserieSAT := xmlNodeValue(sCFeXML, '//ide/nserieSAT');
        snserieSAT := Copy(snserieSAT, 1, 3) + '.' + Copy(snserieSAT, 4, 3) + '.' + Copy(snserieSAT, 7, 3);
        PrinterTexto(iLinha, iMargemEsq, 'SAT Nº ' + snserieSAT, poCenter);
        Canvas.Font.Style := [];

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, ExtraiDataXml(xmlNodeValue(sCFeXML, '//ide/dEmi')) + ' - ' + ExtraiHoraXml(xmlNodeValue(sCFeXML, '//ide/hEmi')), poCenter);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        ImpressaoChaveConsulta(sChaveConsulta); // 2014-01-24

        ImpressaoCodigoBarras(LimpaNumero(xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id')),
                              LimpaNumero(xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id')) + '|' +
                                          xmlNodeValue(sCFeXML, '//ide/dEmi') + xmlNodeValue(sCFeXML, '//ide/hEmi') + '|' +
                                          xmlNodeValue(sCFeXML, '//total/vCFe') + '|' +
                                          LimpaNumero(sCNPJCPFDestinatario) + '|' +
                                          xmlNodeValue(sCFeXML, '//ide/assinaturaQRCODE'));
      end; // if Tipo = tVenda then

      if Tipo = tCancelamento then
      begin

        Canvas.Font.Style := [fsBold];
        snserieSAT := xmlNodeValue(sCFeXML, '//ide/nserieSAT');
        snserieSAT := Copy(snserieSAT, 1, 3) + '.' + Copy(snserieSAT, 4, 3) + '.' + Copy(snserieSAT, 7, 3);
        PrinterTexto(iLinha, iMargemEsq, 'SAT Nº ' + snserieSAT, poCenter);
        Canvas.Font.Style := [];
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, ExtraiDataXml(xmlNodeValue(sCFeXML, '//infCFe/dEmi')) + ' - ' + ExtraiHoraXml(xmlNodeValue(sCFeXML, '//infCFe/hEmi')), poCenter);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        sChaveConsulta := LimpaNumero(xmlNodeValue(sCFeXML, '//infCFe/@chCanc'));
        ImpressaoChaveConsulta(sChaveConsulta); // 2014-01-24
        //pulando linha
        ImpressaoCodigoBarras(LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@chCanc')),
                              LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@chCanc')) + '|' +
                                          xmlNodeValue(sCFeXML, '//ide/dEmi') + xmlNodeValue(sCFeXML, '//ide/hEmi') + '|' +
                                          xmlNodeValue(sCFeXML, '//total/vCFe') + '|' +
                                          LimpaNumero(sCNPJCPFDestinatario) + '|' +
                                          xmlNodeValue(sCFeXML, '//ide/assinaturaQRCODE'));
        Canvas.Font.Name := FONT_NAME_DEFAULT;
        Canvas.Font.Size := FONT_SIZE_DEFAULT;
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);

        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

        Canvas.Font.Style := [fsBold];
        PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), 'DADOS DO CUPOM FISCAL ELETRÔNICO CANCELAMENTO', poCenter);// Sandro Silva 2018-03-15  PrinterTexto(iLinha, iMargemEsq, 'DADOS DO CUPOM FISCAL ELETRÔNICO CANCELAMENTO', poCenter);
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        Canvas.Font.Style := [];

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        Canvas.Font.Style := [fsBold];
        snserieSAT := xmlNodeValue(sCFeXML, '//ide/nserieSAT');
        snserieSAT := Copy(snserieSAT, 1, 3) + '.' + Copy(snserieSAT, 4, 3) + '.' + Copy(snserieSAT, 7, 3);
        PrinterTexto(iLinha, iMargemEsq, 'SAT Nº ' + snserieSAT, poCenter);
        Canvas.Font.Style := [];

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemEsq, ExtraiDataXml(xmlNodeValue(sCFeXML, '//infCFe/ide/dEmi')) + ' - ' + ExtraiHoraXml(xmlNodeValue(sCFeXML, '//infCFe/ide/hEmi')), poCenter);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        sChaveConsulta := LimpaNumero(xmlNodeValue(sCFeXML, '//infCFe/@Id'));
        ImpressaoChaveConsulta(sChaveConsulta); // 2014-01-24

        ImpressaoCodigoBarras(LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@Id')),
                                                 LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@Id')) + '|' +
                                                            xmlNodeValue(sCFeXML, '//ide/dEmi') + xmlNodeValue(sCFeXML, '//ide/hEmi') + '|' +
                                                            xmlNodeValue(sCFeXML, '//total/vCFe') + '|' +
                                                            LimpaNumero(sCNPJCPFDestinatario) + '|' +
                                                            xmlNodeValue(sCFeXML, '//ide/assinaturaQRCODE'));

        sinfCFeId := xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id');

      end;// if Tipo = tCancelamento then

      if (Destino = toPrinter) then
      begin
        PrinterTexto(iLinha, iMargemEsq, '.');
      end;

      if iLinha < Canvas.PenPos.Y then
        iLinha := Canvas.PenPos.Y;

      CanvasLinha(iLinha, 5, iPrimeiraLinhaPapel);

      if FOrientacaoConsultarQRCode <> '' then
      begin
        Canvas.Font.Name := FONT_NAME_DEFAULT;
        Canvas.Font.Size := FONT_SIZE_DEFAULT;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq), FOrientacaoConsultarQRCode, poCenter); // Sandro Silva 2018-03-20  PrinterTextoMemo(iLinha, iMargemEsq, iLarguraPapel - 20, FOrientacaoConsultarQRCode, poCenter);
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      end;

      if Destino = toPrinter then
      begin // Avanço de papel para impressoras que não possuem configuração no driver e corte automático de papel. Bistec solicitou
        iLinhasFinal := FAvancoPapel; // Sandro Silva 2016-11-09  StrToIntDef(LerParametroIni('Frente.ini', SECAO_59, CHAVE_INI_AVANCO_PAPEL, '0'), 0);

        if iLinhasFinal > 0 then
        begin
          if Destino = toPrinter then
          begin
            if iLinha + (iLinhasFinal * iAlturaFonte) < iPageHeight then// Sandro Silva 2018-03-20  if iLinha + (iLinhasFinal * iAlturaFonte) < Printer.PageHeight then
            begin
              CanvasLinha(iLinha, iLinhasFinal * iAlturaFonte, iPrimeiraLinhaPapel);
              Canvas.Font.Size := FONT_SIZE_DEFAULT - 3;
              PrinterTexto(iLinha, iMargemEsq, '.', poLeft);
              Canvas.Font.Size := FONT_SIZE_DEFAULT;
            end;
          end;
        end;
      end;

      Result := True;
    except
      Result := False;
    end;

  finally
    if Destino = toImage then
    begin
      try

        Printer.Abort;

        try
          if sFileExport = '' then // 2015-06-30
          begin
            if Tipo = tVenda then
              sFileCFeSAT := 'AD' + LimpaNumero(xmlNodeValue(sCFeXML, '//CFe/infCFe/@Id'))
            else
              sFileCFeSAT := 'ADC' + LimpaNumero(xmlNodeValue(sCFeXML, '//CFeCanc/infCFe/@Id'));
            if DirectoryExists(ExtractFilePath(Application.ExeName) + 'CFeSAT') = False then
              ForceDirectories(ExtractFilePath(Application.ExeName) + 'CFeSAT');
          end;

          // Cria o PDF

          {Create TPrintPDF VCL}
          PDF := TPrintPDF.Create(Self);

          {Set Doc Info}
          PDF.TITLE       := ExtractFileName(sFileCFeSAT);
          PDF.Creator     := 'Zucchetti - ' + ExtractFileName(Application.ExeName); // Sandro Silva 2022-12-02 Unochapeco
          PDF.Author      := xmlNodeValue(sCFeXML, '//emit/xNome');
          if FEmitente.UF = 'CE' then
            PDF.Keywords    := 'Cupom Fiscal Eletrônico, CF-e, MFE' // Sandro Silva 2018-08-01
          else
            PDF.Keywords    := 'Cupom Fiscal Eletrônico, CF-e-SAT, SAT';
          PDF.Producer    := 'Zucchetti - ' + ExtractFileName(Application.ExeName); // Sandro Silva 2022-12-02 Unochapeco
          {Set Filename to save}
          if sFileExport = '' then // 2015-06-30
            PDF.Subject     := ExtractFileName(sFileCFeSAT)
          else
            PDF.Subject     := sFileExport;

          PDF.JPEGQuality := 100; //2015-05-15 50;

          {Use Compression: VCL Must compile with ZLIB comes with D3 above}
          PDF.Compress    := False; // Sandro Silva 2017-04-11  True;

          {Set Page Size}
          PDF.PageWidth   := iLarguraFisica;
          PDF.PageHeight  := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  2374;

          {Set Filename to save}
          if sFileExport = '' then // 2015-06-30
            PDF.FileName  := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf'
          else
            PDF.FileName  := sFileExport;

          {Start Printing...}
          PDF.BeginDoc;

          for iPagina := 0 to Length(Pagina) -1 do
          begin

            {Print Image}
            PDF.DrawJPEG(0, 0, Pagina[iPagina].Picture.Bitmap);

            if iPagina < Length(Pagina) -1 then
              {Add New Page}
              PDF.NewPage;
            FreeAndNil(Pagina[iPagina]);
          end;

          {End Printing}
          sRetornoGeraPDF := PDF.EndDoc;
          if sRetornoGeraPDF <> '' then
            FLogRetornoMobile := sRetornoGeraPDF;// Sandro Silva 2016-11-09  SmallMsgBox(PChar(sRetornoGeraPDF), 'Atenção', MB_ICONWARNING + MB_OK);

          Sleep(500 * Length(Pagina) -1);
        except
          on E: Exception do
          begin
            sRetornoGeraPDF := PDF.FileName + ' já está aberto';
          end;
        end;

        {FREE TPrintPDF VCL}
        if PDF <> nil then
          FreeAndNil(PDF);//.Free;

        Pagina := nil;

      finally

      end;
    end
    else
    begin
      Printer.EndDoc;
    end;

    if Printer.Printing then
      Printer.Abort;

    XMLCFe := nil;

    xNodeItens := nil; // Sandro Silva 2016-06-14

    Screen.Cursor := FCursor;
  end;
end;

constructor TRetornoConsultarStatusOperacional.Create;
begin

end;


destructor TRetornoConsultarStatusOperacional.Destroy;
begin

  inherited;
end;

function TSmall59.GetAssinaturaAssociada: String;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FArquivoAssinatura);
  try
    Result := Trim(Ini.ReadString('SAT-CFe',_59_CHAVE_ASSINATURA_ASSOCIADA, ''));
  except
    Result := FAssinaturaAssociada;
  end;
  Ini.Free;
  FAssinaturaAssociada := Result;
end;

function TSmall59.GetAmbiente: String;
begin
  Result := FAmbiente;
end;

procedure TSmall59.SetAmbiente(const Value: String);
begin
  FAmbiente := AnsiUpperCase(ConverteAcentos(Value));
end;

function TSmall59.GetRetorno: String;
begin
  Result := FRespostaSAT;
end;

function TSmall59.SalvaXML(xml: String): Boolean;
var
  sFile: String;
  sCaminhoXML: String;
begin
  sCaminhoXML := ExtractFilePath(Application.ExeName);
  if Copy(sCaminhoXML, Length(sCaminhoXML), 1) <> '\' then
    sCaminhoXML := sCaminhoXML + '\';
  sCaminhoXML := sCaminhoXML + 'XmlDestinatario\CFeSAT\';
  try
    ForceDirectories(sCaminhoXML);
  except
  end;
  if xmlNodeValue(xml, '//CFeCanc/infCFe/@chCanc') <> '' then
    sFile := sCaminhoXML + 'ADC' + LimpaNumero(xmlNodeValue(xml, '//CFeCanc/infCFe/@chCanc')) + '.xml'// cancelamento
  else
    sFile := sCaminhoXML + 'AD' + LimpaNumero(xmlNodeValue(xml, '//CFe/infCFe/@Id')) + '.xml'; // venda

  try
    with TStringList.Create do
    begin
      Text := xml;
      SaveToFile(sFile);
      Sleep(250); // Tempo salvar // Sandro Silva 2021-06-28 Sleep(500); // Tempo salvar
      Free;
    end;
  except

  end;
  Result := FileExists(sFile);
  ChDir(FDiretorioAtual); // Sandro Silva 2017-05-20 
end;

procedure TSmall59.ImagemQRCode(QRCodeData: String; APict: TBitMap);
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap: TBitmap;
  Row, Column: Integer;
begin
  QRCode       := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    QRCode.QuietZone := 2; // Sandro Silva 2018-03-16  1;
    QRCode.Encoding  := qrUTF8BOM;// Aplicativo De olho na Nota 4.1.1 P não consegue ler QRCode com qrUTF8NoBOM Sandro Silva 2022-11-01 qrUTF8NoBOM;
    QRCode.Data      := widestring(QRCodeData);// Sandro Silva 2022-11-01 QRCodeData;

    QRCodeBitmap.Width  := QRCode.Columns;
    QRCodeBitmap.Height := QRCode.Rows;

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
        else
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;

    APict.Assign(QRCodeBitmap);
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
  end;
end;

procedure TSmall59.SetFabricante(const Value: String);
begin
  FFabricante := Value;
  if Length(FFabricante) < 4 then
    FFabricanteModelo := '01'
  else
    FFabricanteModelo := Copy(FFabricante, 3, 2);
  FFabricanteCodigo := Copy(FFabricante, 1, 2);
  if FFabricanteCodigo = FABRICANTE_EMULADOR then // SAT.DLL
    SetFCaminhoSATDLL('c:\SAT\sat.dll');
  if FFabricanteCodigo = FABRICANTE_DIMEP    then // dllsat.dll
    SetFCaminhoSATDLL('DLLSAT\DIMEP\dllsat.dll');
  if FFabricanteCodigo = FABRICANTE_SWEDA    then // SATDLL.DLL E SATSWEDA.INF
    SetFCaminhoSATDLL('DLLSAT\SWEDA\satdll.dll');
  if FFabricanteCodigo = FABRICANTE_TANCA    then // SAT.DLL e TANCA_SAT.INF
    SetFCaminhoSATDLL('DLLSAT\TANCA\sat.dll');
  if FFabricanteCodigo = FABRICANTE_GERTEC   then // GERSAT.DLL
    SetFCaminhoSATDLL('DLLSAT\GERTEC\gersat.dll');
  if FFabricanteCodigo = FABRICANTE_URANO    then // SAT.DLL, SAT64.DLL, cdm+v2.12.00+whql+certified.exe”
    SetFCaminhoSATDLL('DLLSAT\URANO\sat.dll');
  if FFabricanteCodigo = FABRICANTE_BEMATECH then // BemaSAT32.dll
    SetFCaminhoSATDLL('DLLSAT\BEMATECH\BemaSAT32.dll');
  if FFabricanteCodigo = FABRICANTE_ELGIN    then // dllsat.dll
  begin
    if FFabricanteModelo = '01' then
      SetFCaminhoSATDLL('DLLSAT\ELGIN\Linker\dllsat.dll');
    if FFabricanteModelo = '02' then
      SetFCaminhoSATDLL('DLLSAT\ELGIN\LinkerII\dllsat.dll');
    if FFabricanteModelo = FABRICANTE_ELGIN_SMART then
      SetFCaminhoSATDLL('DLLSAT\ELGIN\Smart\dllsat.dll');
  end;
  if FFabricanteCodigo = FABRICANTE_KRYPTUS  then // SAT.dll // 2015-10-04
    SetFCaminhoSATDLL('DLLSAT\KRYPTUS\SAT.dll');
  if FFabricanteCodigo = FABRICANTE_NITERE   then // SAT.dll // 2015-10-04
    SetFCaminhoSATDLL('DLLSAT\NITERE\dllsat.dll');
  if FFabricanteCodigo = FABRICANTE_DARUMA   then // DarumaSat.dll // 2016-09-06
    SetFCaminhoSATDLL('DLLSAT\DARUMA\dllsat.dll');
  if FFabricanteCodigo = FABRICANTE_EPSON then
    SetFCaminhoSATDLL('DLLSAT\EPSON\SAT-A10.dll'); // Sandro Silva 2017-09-21

  if FFabricanteCodigo = FABRICANTE_CONTROLID then
    SetFCaminhoSATDLL('DLLSAT\CONTROLID\SAT.dll'); // Sandro Silva 2018-03-29

  if FFabricanteCodigo = FABRICANTE_CS_DEVICES then
    SetFCaminhoSATDLL('DLLSAT\CSDEVICES\dllsat.dll'); // Sandro Silva 2018-03-29
    
  {Sandro Silva 2021-08-25 inicio}
  // Sandro Silva 2022-05-17 if FDriverMFE01_05_15_Superior then
  if Emitente.UF = 'CE' then
  begin
    if FileExists('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') then
      SetFCaminhoSATDLL('c:\Program Files (x86)\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll')
    else
      if FileExists('c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll') then
        SetFCaminhoSATDLL('c:\Program Files\SEFAZ-CE\Driver MFE\Biblioteca de funções\mfe.dll');
  end;
  {Sandro Silva 2021-08-25 fim}

end;

procedure TSmall59.SetCFehEmi(const Value: String);
begin
  FCFehEmi := Value;
end;

procedure TSmall59.SetCFedEmi(const Value: TDate);
begin
  FCFedEmi := Value;
end;

function TSmall59.xmlNodeValueToDate(sXML, sNode: String): TDate;
{Sandro Silva 2015-04-14 inicio
Retorna a data da emissão do CF-e-SAT
<dEmi>20150414</dEmi>
}
var
  sData: String;
begin
  sData := xmlNodeValue(sXML, sNode);
  sData := LimpaNumero(sData);
  sData := Copy(sData, 7, 2) + '/' + Copy(sData, 5, 2) + '/' + Copy(sData, 1, 4);
  if StrToDateDef(sData, StrToDate('30/12/1899')) <> StrToDate('30/12/1899') then
    Result := StrToDate(sData)
  else
    Result := StrToDate('30/12/1899');
end;

function TSmall59.TiraQuebraLinha(sTexto: String): String;
begin
  Result := sTexto;
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #$D#$A, '', [rfReplaceAll]);
  Result := StringReplace(Result, #$A, '', [rfReplaceAll]); // Sandro Silva 2016-06-15 Emulador 2.9.1
end;

function TSmall59.xmlNodeValueToTime(sXML, sNode: String): TTime;
{Sandro Silva 2015-04-14 inicio
Retorna a hora da emissão do CF-e-SAT
<hEmi>100151</hEmi>
}
var
  sHora: String;
  sH: String;
  sM: String;
  sS: String;
begin
  sHora := xmlNodeValue(sXML, sNode);

  sHora := LimpaNumero(sHora);
  sH := RightStr('00' + Copy(sHora, 1, 2), 2); //Copy(sHora, 1, 2) + ':' + Copy(sHora, 3, 2) + ':' + Copy(sHora, 5, 2);
  sM := RightStr('00' + Copy(sHora, 3, 2), 2);
  sS := RightStr('00' + Copy(sHora, 5, 2), 2);
  //sMS := RightStr('000' + Copy(sHora, 7, 3), 3);

  if IsValidTime(StrToInt(sH), StrToInt(sM), StrToInt(sS), 0) then
    Result := StrToTime(sH + ':' + sM + ':' + sS)
  else
    Result := StrToTime('00:00:00');
end;

function TSmall59.xmlNodeValueToFloat(sXML, sNode: String;
  sDecimalSeparator: String = '.'): Double;
{Sandro Silva 2017-05-23 inicio
Converte valor no xml para Float
sDecimalSeparator: Deve ser ',' ou '.'
}
var
  sValor: String;
begin
  sValor := xmlNodeValue(sXML, sNode);
  if sDecimalSeparator = '.' then
  begin
   sValor := StringReplace(sValor, ',', '', [rfReplaceAll]);
   sValor := StringReplace(sValor, '.', ',', [rfReplaceAll]);
  end
  else
   sValor := StringReplace(sValor, '.', '', [rfReplaceAll]);

  Result := StrToFloatDef(sValor, 0);
end;

procedure TSmall59.SetVersaoDadosEnt(const Value: String);
begin
  FVersaoDadosEnt := Value;
end;

procedure TSmall59.SetCNPJSoftwareHouse(const Value: String);
begin
  FCNPJSoftwareHouse := Trim(Value);
end;

procedure TSmall59.SetCodigoRetornoStatus(const Value: String);
begin
  FCodigoRetornoConsultarSAT := Value;
end;

procedure TSmall59.SetTributosEstaduais(const Value: Double);
begin
  FTributosEstaduais := Value;
end;

procedure TSmall59.SetTributosFederais(const Value: Double);
begin
  FTributosFederais := Value;
end;

procedure TSmall59.SetTributosMunicipais(const Value: Double);
begin
  FTributosMunicipais := Value;
end;

procedure TSmall59.SetMensagemPromocional(const Value: String);
begin
  FMensagemPromocional := Value;
end;

procedure TSmall59.SetEmOperacao(const Value: Boolean);
begin
  FEmOperacao := Value;
end;

procedure TSmall59.SetUltimoNumeroCupom(const Value: String);
begin
  FUltimoNumeroCupom := Value;
end;

procedure TSmall59.SetLogComando(const Value: String);
begin
  FLogComando := Value;
end;

procedure TSmall59.SalvaLogDadosEnviados(sTexto: String);
var
  re: TRichEdit;
begin
  re := TRichEdit.Create(Application);
  try
    re.Visible   := False;
    re.Left      := -1000;
    re.Parent    := Application.MainForm;
    re.PlainText := True;
    re.Text      := sTexto;
    re.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'log\CFe' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Date + Time) + '-' + FCaixa + '-env.xml');
  except
  end;
  FreeAndNil(re);
  ChDir(FDiretorioAtual);// Sandro Silva 2017-05-20
end;

function TSmall59.GetDescricaoRetornoSAT: String;
begin
  Result := StatusRetornoSAT(FRespostaSAT);
end;

procedure TSmall59.SetDadosXML(const Value: AnsiString);
begin
  FCFeXML    := '';
  FCFeID     := '';
  FCFeStatus := '';
  FXMLDadosVenda  := Value;
end;

procedure TSmall59.GravaLog(sLog: String);
var
  LogFile: TextFile;
  sFile: String;
begin
  try

    sFile := ExtractFilePath(Application.ExeName) + 'log\log_sat_' + FCaixa + '_' + FormatDateTime('yyyy-mm-dd', Date) + '.txt';

    if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log') = False then
      ForceDirectories(ExtractFilePath(Application.ExeName) + 'log');

    if FileExists(sFile) then
    begin
      if StrToInt(FormatFloat('0', TamanhoArquivo(sFile) / 1024)) >= 1024 then
        RenameLog(sFile);
    end;

    AssignFile(LogFile, sFile);
    if FileExists(sFile) = False then
      ReWrite(LogFile)
    else
      Append(LogFile);
    WriteLn(LogFile, FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + '|' + sLog);
    CloseFile(LogFile);
  except

  end;
end;

function TSmall59.GetFabricanteNome: String;
begin
  if FFabricanteCodigo = FABRICANTE_EMULADOR then // SAT.DLL
    Result := 'EMULADOR';
  if FFabricanteCodigo = FABRICANTE_DIMEP    then // dllsat.dll
    Result := 'DIMEP';
  if FFabricanteCodigo = FABRICANTE_SWEDA    then // SATDLL.DLL E SATSWEDA.INF
    Result := 'SWEDA';
  if FFabricanteCodigo = FABRICANTE_TANCA    then // SAT.DLL e TANCA_SAT.INF
    Result := 'TANCA';
  if FFabricanteCodigo = FABRICANTE_GERTEC   then // GERSAT.DLL
    Result := 'GERTEC';
  if FFabricanteCodigo = FABRICANTE_URANO    then // SAT.DLL, SAT64.DLL, cdm+v2.12.00+whql+certified.exe”
    Result := 'URANO';
  if FFabricanteCodigo = FABRICANTE_BEMATECH then // BemaSAT32.dll
    Result := 'BEMATECH';
  if FFabricanteCodigo = FABRICANTE_ELGIN    then // dllsat.dll
    Result := 'ELGIN';
  if FFabricanteCodigo = FABRICANTE_KRYPTUS  then // SAT.dll // 2015-10-04
    Result := 'KRYPTUS';
  if FFabricanteCodigo = FABRICANTE_NITERE  then // SAT.dll // 2015-10-04
    Result := 'NITERE';
  if FFabricanteCodigo = FABRICANTE_DARUMA  then // DarumaSat.dll // 2016-09-06
    Result := 'DARUMA';
  if FFabricanteCodigo = FABRICANTE_EPSON  then // SAT-A10.dll // 2016-09-06
    Result := 'EPSON';
  if FFabricanteCodigo = FABRICANTE_CONTROLID  then // 3_19012018_libsatidlib.dll  Sandro Silva 2018-03-29
    Result := 'CONTROL ID';

  if FFabricanteCodigo = FABRICANTE_CS_DEVICES then
    Result := 'CS DEVICES';

end;

function TSmall59.Chamadacdecl: Boolean;
begin
  Result := FMedotoChamadaDLL = mcCdecl;
end;

procedure TSmall59.SetFMensagemSAT(const Value: String);
begin
  FMensagemSAT := Trim(Value);
end;

function TSmall59.EliminarEspaco(sTexto: String): String;
// Elimina espaços em branco antes do pipe (" |")
begin
  while Pos(' |', sTexto) > 0 do
    sTexto := StringReplace(sTexto, ' |', '|', [rfReplaceAll]);
  Result := sTexto;
end;

procedure TSmall59.SetFDiretorioAtual(const Value: String);
begin
  FDiretorioAtual := Value;
  FRequisicao.DiretorioAtual := FDiretorioAtual;
end;

procedure TSmall59.SetCaminhoComunicacao(const Value: String);
begin
  FCaminhoComunicacao := Value;
  FRequisicao.FCaminhoComunicacao := FCaminhoComunicacao;
  if FModoOperacao <> moAlone then
  begin
    try
      ForceDirectories(FCaminhoComunicacao + '\Requisicao');
      ForceDirectories(FCaminhoComunicacao + '\Retorno');
    except

    end;
  end;
end;

function TSmall59.GetCaminhoRequisicao: String;
begin
  Result := FCaminhoComunicacao + '\Requisicao';
end;

function TSmall59.GetCaminhoRetorno: String;
begin
  Result := FCaminhoComunicacao + '\Retorno';
end;

procedure TSmall59.SetConteudoStatusOperacional(const Value: String);
begin
  FConteudoStatusOperacional := Value;
end;

function TSmall59.ConfiguracaoSATServidor: String;
// Obtem a configuração do SAT servidor (fabricante, codigo de ativação, etc...)
begin
  case FModoOperacao of
    moClient:
      begin
        FRequisicao.Clear;
        FRequisicao.Caixa   := FCaixa;
        FRequisicao.Comando := CMD_CONFIGURACAO;// 'ConsultarStatusOperacional';
        Result := FRequisicao.Enviar;
      end;
    moIntegradorMFE:
      begin
        ShowMessage('Função não disponível para PDV em modo Cliente Integrador Fiscal');
      end;
    moAlone, moServer:
      begin

        //ShowMessage('Teste 01 ' + FAmbiente); // Sandro Silva 2017-09-08

        Result := '<?xml version="1.0" encoding="UTF-8"?>' +
                  '<configuracao>' +
                    '<assinaturaassociada>' + FAssinaturaAssociada + '</assinaturaassociada>' +
                    '<codigoativacao>' + FCodigoAtivacao + '</codigoativacao>' +
                    '<cnpjsh>' + FCNPJSoftwareHouse + '</cnpjsh>' +
                    '<codigofabricante>' + FFabricante + '</codigofabricante>' +
                    '<dllfabricante>' + FCaminhoSATDLL + '</dllfabricante>' + // Sandro Silva 2017-09-08
                    '<versaodadosentrada>' + FVersaoDadosEnt + '</versaodadosentrada>' + // Sandro Silva 2017-09-08
                    '<ambiente>' + FAmbiente + '</ambiente>' + // Sandro Silva 2017-09-08
                  '</configuracao>';
      end;
  end;

end;

procedure TSmall59.SetFRespostaSAT(const Value: String);
begin
  FRespostaSAT := Value;
  if Utf8ToAnsi(Value) <> '' then
    FRespostaSAT := Utf8ToAnsi(Value);
end;

procedure TSmall59.Inicializa;
begin
  // Controla a inicialização da DLL
  CarregaSATDLL;
end;

procedure TSmall59.Desinicializa;
begin
  // Controla descarregamento da DLL
  try
    FreeLibrary(FhDLL); //descarregando dll

    if Chamadacdecl then
    begin
      _AtivarSAT_cdecl                  := nil;
      _AssociarAssinatura_cdecl         := nil;
      // 2021-06-22_BloquearSAT_cdecl                := nil;
      _CancelarUltimaVenda_cdecl        := nil;
      _ConsultarNumeroSessao_cdecl      := nil;
      _ConsultarSAT_cdecl               := nil;
      _ConsultarStatusOperacional_cdecl := nil;
      _DesbloquearSAT_cdecl             := nil;
      //_DesligarSAT_stdcall              := nil;  Alguns fabricantes não implementaram na sua dll
      _EnviarDadosVenda_cdecl           := nil;
      _ExtrairLogs_cdecl                := nil;
      _TesteFimAFim_cdecl               := nil;
      _TrocarCodigoDeAtivacao_cdecl     := nil;
    end
    else
    begin
      _AtivarSAT_stdcall                  := nil;
      _AssociarAssinatura_stdcall         := nil;
      _BloquearSAT_stdcall                := nil;
      _CancelarUltimaVenda_stdcall        := nil;
      _ConsultarNumeroSessao_stdcall      := nil;
      _ConsultarSAT_stdcall               := nil;
      _ConsultarStatusOperacional_stdcall := nil;
      _DesbloquearSAT_stdcall             := nil;
      //_DesligarSAT_stdcall                := nil;  Alguns fabricantes não implementaram na sua dll
      _EnviarDadosVenda_stdcall           := nil;
      _ExtrairLogs_stdcall                := nil;
      _TesteFimAFim_stdcall               := nil;
      _TrocarCodigoDeAtivacao_stdcall     := nil;
    end;
  except
  end;

end;

procedure TSmall59.SetConfiguracaoCasasDecimaisQtd(const Value: String);
begin
  FConfiguracaoCasasDecimaisQtd := Value;
end;

procedure TSmall59.SetConfiguracaoCasasDecimaisPreco(const Value: String);
begin
  FConfiguracaoCasasDecimaisPreco := Value;
end;

procedure TSmall59.SetCaixa(const Value: String);
begin
  FCaixa := Value;
  if FModoOperacao = moIntegradorMFE then // Sandro Silva 2018-07-18
    FIntegradorMFE.Caixa := FCaixa;
end;

procedure TSmall59.SetFModoOperacao(const Value: TModoOperacao);
begin
  FModoOperacao := Value;
end;

{ TRetornoEnviarDadosVenda }

constructor TRetornoEnviarDadosVenda.Create;
begin

end;

destructor TRetornoEnviarDadosVenda.Destroy;
begin

  inherited;
end;

{ TRetornoTesteFimaFim }

constructor TRetornoTesteFimaFim.Create;
begin

end;

destructor TRetornoTesteFimaFim.Destroy;
begin

  inherited;
end;

{ TRetornoCancelarUltimaVenda }

constructor TRetornoCancelarUltimaVenda.Create;
begin

end;

destructor TRetornoCancelarUltimaVenda.Destroy;
begin

  inherited;
end;

{ TEmitente }

procedure TEmitente.SetCNPJ(const Value: String);
begin
  FCNPJ := Value;
end;

procedure TEmitente.SetFUF(const Value: String);
begin
  FUF := Value;
end;

procedure TEmitente.SetIE(const Value: String);
begin
  FIE := Value;
end;

procedure TEmitente.SetIM(const Value: String);
begin
  FIM := Value;
end;

{ TRetorno }

procedure TRetorno.setFmensagem(const Value: String);
begin
  Fmensagem := Trim(Value);
  if Utf8ToAnsi(Value) <> '' then
    Fmensagem := Utf8ToAnsi(Value);
end;

procedure TRetorno.SetFmensagemSEFAZ(const Value: String);
begin
  FmensagemSEFAZ := Trim(Value);
  if Utf8ToAnsi(Value) <> '' then
    FmensagemSEFAZ := Utf8ToAnsi(Value);
end;

{ TRequisicao }

procedure TRequisicao.Clear;
begin
  FCaixa             := '';
  FComando           := '';
  FDadosVenda        := '';
  FDadosCancelamento := '';
end;

function TRequisicao.Enviar: String;
var
  sRequisicao: String;
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  sRequisicao := '<?xml version="1.0" encoding="UTF-8"?>' +
            '<requisicao>' +
               // Sandro Silva 2017-02-15 Precisa da data e hora no xml?  '<datahora>' + FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + '</datahora>' +
               '<comando>' + FComando + '</comando>' +
               '<caixa>' + FCaixa + '</caixa>';

  if FComando = 'EnviarDadosVenda' then
    sRequisicao := sRequisicao + '<dadosvenda>' + Base64Encode(FDadosVenda) + '</dadosvenda>';

  if FComando = 'CancelarUltimaVenda' then
    sRequisicao := sRequisicao + '<xmlvenda>' + Base64Encode(FDadosCancelamento) + '</xmlvenda>';

  sRequisicao := sRequisicao + '</requisicao>';

  Result := GerarRequisicao(sRequisicao);

  Screen.Cursor := Cursor;
end;

function TRequisicao.GerarRequisicao(sConteudo: String): String;
var
  sArqRequisicao: String;
  sArqResposta: String;
  sComandoEnviado: String;
  dtTempo: TDate;
  sl: TStringList;
  iTimeOutSeg: Integer;
  sCaminhoRequisicao: String;
  sCaminhoRetorno: String;
  sDataHora: String;
begin
  Result             := '';
  sl                 := TStringList.Create;
  sCaminhoRequisicao := FCaminhoComunicacao + '\Requisicao';
  sCaminhoRetorno    := FCaminhoComunicacao + '\Retorno';

  if DirectoryExists(sCaminhoRequisicao) = False then
    ForceDirectories(sCaminhoRequisicao);
  if DirectoryExists(sCaminhoRetorno) = False then
    ForceDirectories(sCaminhoRetorno);

  if DirectoryExists(sCaminhoRequisicao) and DirectoryExists(sCaminhoRetorno) then
  begin
    sComandoEnviado := xmlNodeValue(sConteudo, '//comando'); // Comando enviado // Sandro Silva 2019-06-05

    sDataHora := FormatDateTime('yyyymmddHHnnsszzz', Now);

    sArqRequisicao := FCaixa + '_' + sComandoEnviado + '_' + sDataHora + '.req';
    sArqResposta   := FCaixa + '_' + sComandoEnviado + '_' + sDataHora + '.xml';

    // Ficha 4656 Todos os comando devem ter o timeout de 90 segundos. Timeout menor causou problemas em alguns clientes
    iTimeOutSeg := 90;// Sandro Silva 2017-02-24  20;

    Inc(iTimeOutSeg, 3);

    sl.Text := sConteudo;
    sl.SaveToFile(PChar(sCaminhoRequisicao + '\' + sArqRequisicao));
    Sleep(100); // Sandro Silva 2017-02-23
    RenameFile(PChar(sCaminhoRequisicao + '\' + sArqRequisicao), PChar(sCaminhoRequisicao + '\' + sArqResposta)); // Sandro Silva 2019-06-04 RenameFile(sCaminhoRequisicao + '\' + sArqRequisicao, sCaminhoRequisicao + '\' + sArqResposta);
    Sleep(100); // Sandro Silva 2019-06-04  Ficha 4656
    sl.Clear;

    dtTempo := Now;

    while (SecondsBetween(Now, dtTempo) < iTimeOutSeg) do
    begin

      if FileExists(PChar(sCaminhoRetorno + '\' + sArqResposta)) then // Sandro Silva 2019-06-04 Ficha 4656 if FileExists(sCaminhoRetorno + '\' + sArqResposta) then
      begin
        try
          Sleep(500);// Tempo para gravação em disco
          while Trim(sl.Text) = '' do
          begin
            sl.LoadFromFile(sCaminhoRetorno + '\' + sArqResposta); // Sandro Silva 2019-06-04  Ficha 4656 sl.LoadFromFile(sCaminhoRetorno + '\' + sArqResposta);
            Sleep(500);// Tempo para gravação em disco
          end;

          DeleteFile(PChar(sCaminhoRetorno + '\' + sArqResposta)); // Sandro Silva 2019-06-04  Ficha 4656 DeleteFile(pChar(sCaminhoRetorno + '\' + sArqResposta));

          if xmlNodeValue(sl.Text, '//comando') = sComandoEnviado then // Se o comando retornado é o mesmo enviado sai do loop
          begin
            Break;
          end;

        except

        end;
      end
      else
      begin
        Sleep(250);
      end;

    end;

    Result := xmlNodeValue(sl.Text, '//retorno');

  end; // if DirectoryExists(sCaminhoRequisicao) and DirectoryExists(sCaminhoRetorno) then

  if Trim(Result) <> '' then
  begin
    Result := Base64Decode(Result);
  end
  else
  begin
    DeleteFile(PChar(sCaminhoRequisicao + '\' + sArqRequisicao)); // Sandro Silva 2019-06-04  Ficha 4656 DeleteFile(pChar(sCaminhoRequisicao + '\' + sArqRequisicao));  // Sandro Silva 2017-03-01
    DeleteFile(PChar(sCaminhoRequisicao + '\' + sArqResposta)); // Sandro Silva 2019-06-04  Ficha 4656 DeleteFile(pChar(sCaminhoRequisicao + '\' + sArqResposta));  // Sandro Silva 2017-03-01
    Result := 'Tempo limite atingido. Servidor SAT não respondeu. Verifique se o Servidor está ativo';
  end;

  FreeAndNil(sl);

  if Trim(FDiretorioAtual) <> '' then // Sandro Silva 2017-09-08
  begin
    if DirectoryExists(FDiretorioAtual) = False then
      //ShowMessage('Teste 01 5899' + #13 + '"'+FDiretorioAtual+'"') // Sandro Silva 2017-09-08
    else
      ChDir(FDiretorioAtual); // Sandro Silva 2017-05-20
  end;
end;

{ TRetornoExtrairLogs }

constructor TRetornoExtrairLogs.Create;
begin

end;

destructor TRetornoExtrairLogs.Destroy;
begin

  inherited;
end;

end.
