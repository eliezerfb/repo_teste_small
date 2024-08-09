unit uSmallNFSe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ShellAPI, XMLIntf, XMLDoc, zlib, System.IniFiles, System.Math,
  Winapi.ActiveX, System.StrUtils,
  Data.DB, IBX.IBCustomDataSet, IBX.IBDatabase,
  IBX.IBQuery,
  pcnConversao,
  blcksock,
  ACBrDFeSSL,
  ACBrBase,
  ACBrUtil.Base,
  ACBrUtil.DateTime, ACBrUtil.FilesIO,
  ACBrDFe, ACBrDFeReport, ACBrMail, ACBrNFSeX,
  ACBrNFSeXConversao, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXDANFSeFR,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXDANFSeRLClass, ACBrNFSeXClass
  , uDialogs, uFuncoesBancoDados
  ;

const DADO_SIM = 'Sim';

type
  TNFSeEmitente = class
  private
    Fiid_Cidade: String;
    FsCnae: String;
    FsEnd_Cep: String;
    FsSimples_Nacional: String;
    FsFone_Comer: String;
    FsTelefone: String;
  public
    property iid_Cidade: String read Fiid_Cidade write Fiid_Cidade;
    property sCnae: String read FsCnae write FsCnae;
    property sEnd_Cep: String read FsEnd_Cep write FsEnd_Cep;
    property sSimples_Nacional: String read FsSimples_Nacional write FsSimples_Nacional;
    property sFone_Comer: String read FsFone_Comer write FsFone_Comer;
    property sTelefone: String read FsTelefone write FsTelefone;
  end;

  TNFSe_Dados = class
  private
    FsCNAEZerado: String;
  public
    property sCNAEZerado: String read FsCNAEZerado write FsCNAEZerado;
  end;
(*
  TNFS = class(TComponent)
  public
    class var
      //FACBrNFSeX1: TACBrNFSeX;
//      Protocolo,
//      Mensagem,
//      Correcao,
//      Situacao,
//      Nfse_Numero,
//      Nfse_Serie,
//      Nfse_Identidade_Tomador,
//      Nfse_Modelo,
//      Nfse_OBS,
//      Link_Nfse,
//      CodVerificacao,
//      mensagemCompleta,
//      Nfse_Numero_Origem,
//      Protocolo_Origem   : string;
//      cancelada          : Boolean;
//      data               : TDate;
      TipoEnvio          :  TmodoEnvio; //Integer;
//      Nfse_Nf_Numero: integer;
  private
    FIniNFSe: TIniFile;
    FACBrNFSeX1: TACBrNFSeX;
    //FACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL;
    FACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR;
    FACBrMail1: TACBrMail;
    FIBTRANSACTION: TIBTransaction;
    FIBQNFSE: TIBQuery;
    FIBQEMITENTE: TIBQuery;
    procedure ACBrNFSeX1GerarLog(const ALogLine: string; var Tratado: Boolean);
    procedure ACBrNFSeX1StatusChange(Sender: TObject);
    function GetCodigoMunicipioServico: String;
    function GetCidade_Goiania(id_cidade: string): string;
    procedure SetIBTRANSACTION(const Value: TIBTransaction);
    procedure SelecionarDadosEmitente;
  public
    property ACBrNFSeX: TACBrNFSeX read FACBrNFSeX1 write FACBrNFSeX1;
    //property ACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL read FACBrNFSeXDANFSeRL1 write FACBrNFSeXDANFSeRL1;
    property ACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR read FACBrNFSeXDANFSeFR1 write FACBrNFSeXDANFSeFR1;
    property ACBrMail1: TACBrMail read FACBrMail1 write FACBrMail1;
    property IBTRANSACTION: TIBTransaction read FIBTRANSACTION write SetIBTRANSACTION;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;
//    class function ConfigurarComponente(ACBrNFSe: TACBrNFSeX;
//      IBTRANSACTIONBASE: TIBTransaction): TACBrNFSeX;
    function ConfigurarComponente: Boolean;
    //class procedure SelecionarDadosEmitente(var IBQEMITENTE: TIBQuery);
  end;
*)

TVar_Dados_novo  = class
  Public
    class var Protocolo,
              Mensagem,
              Correcao,
              Situacao,
              Nfse_Numero,
              Nfse_Serie,
              Nfse_Identidade_Tomador,
              Nfse_Modelo,
              Nfse_OBS,
              Link_Nfse,
              CodVerificacao,
              mensagemCompleta,
              Nfse_Numero_Origem,
              Protocolo_Origem   : string;
              cancelada          : Boolean;
              data               : TDate;
              TipoEnvio          :  Integer;
              Nfse_Nf_Numero: integer;

    class procedure fLimpa_VarDados;
  end;

  TDataModuleNFSeX = class(TComponent)
    OpenDialog1: TOpenDialog;
    constructor create(Sender: TObject; ConexaoVar: TIBDatabase; IBTRANSACTION: TIBTransaction);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FPathLogNFSe: String;
    FPathGeral: String;
    FPathLocalExe: String;
    FPathXMLs: String;
    mostraMensagem,
    envioNFSe               : boolean;
    tentativasConsultaLote,
    FID_NFVenda  : integer;
    FConexaoTemp: TIBDatabase;
    FFDQueryV_NFSe: TIBQuery;
    FFDQueryV_NFSeItem: TIBQuery;
    FFDQueryNFSeItemDiscriminacao: TIBQuery;
    FFDQueryCliente: TIBQuery;

    FIBTRANSACTION: TIBTransaction;
    FIBQNFSE: TIBQuery;
    FIBQEMITENTE: TIBQuery;

    FACBrNFSeX1: TACBrNFSeX;
    FACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL;
    FACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR;
    TNFSe_Emitente: TNFSeEmitente;
    TNFSeDados: TNFSe_Dados;
    procedure AlimentaNFSe(AID_NFVenda: Integer; Emei : Boolean);
    procedure Carrega_NFSe(FID_NFVenda: Integer);
    function GetCidade_Goiania(id_cidade: string): string;
    function GetCodigoMunicipioServico: String;
    function GetCodigoCNAE: String;
    function getCodigoTributacaoMunicipio: string;
    function getIdentificacaoRpsSerie(ADefaultSerie: String): String;
    function getRegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
    function getRegimeApuracaoSN: TRegimeApuracaoSN;
    function StrToRegimeApuracaoSN(out ok: boolean; const s: String): TRegimeApuracaoSN;
    function getTipoEnvio(tipoEnvio: integer) : TmodoEnvio;
    function getTipoCliente(ACnpjCPF: String): TTipoPessoa;
    function getNumeroNfse: String;
    function AjustaDiscriminacao(discriminacao : string): String;
    function getSituacao: String;
    procedure LoadXML(RetWS: String; MyWebBrowser: TWebBrowser; NomeArq: string);
    procedure ChecarResposta(aMetodo: TMetodo; id_nfvenda : integer);
    procedure StatusChange(Sender: TObject);
    function StrToRegimeEspecialTributacao(out ok: boolean; const s: String): TnfseRegimeEspecialTributacao;
    procedure CarregaInfManual(AIEProdutorRural : string);
    procedure AtualizaPathXML;
    function ErroLote_AssessorPublico: Boolean;
    function SucessoLote_AssessorPublico: Boolean;
    procedure Cancelar_AssessorPublico;
    procedure Cancelar_retorno;
    procedure Cancelar_EloTech;
    function CopiarChaveXML(sXML, sChave: string): string;
    procedure VerificaStatusNFSeBrasil;
    procedure CorrigeEcomercial;
    Function fGrava_Retorno(iId_nfvenda, sprotocolo, ssituacao, smensagem, sNfse_Numero : string; slink : string = ''): boolean;
    procedure SetConexaoTemp(const Value: TIBDataBase);
    procedure SetFDQueryV_NFSe(const Value: TIBQuery);
    procedure SetFDQueryV_NFSeItem(const Value: TIBQuery);
    procedure SetFDQueryNFSeItemDiscriminacao(const Value: TIBQuery);
    procedure SetFDQueryCliente(const Value: TIBQuery);
    procedure SetACBrNFSeX1(const Value: TACBrNFSeX);
    procedure SetACBrNFSeXDANFSeRL1(const Value: TACBrNFSeXDANFSeRL);
    procedure SetACBrNFSeXDANFSeFR1(const Value: TACBrNFSeXDANFSeFR);
    Function ConverteEComercial(AConverter : string) : string;

  public
    { Public declarations }
    EnviaThread : Boolean;
    function ConfigurarComponente(TipoEnvio : integer) : Boolean;
    procedure FixIPMGravataiUrl(var AUrl: string);
    function AutorizaNFSe(AID_NFVenda, metodoEnvio : Integer;
     eThread : boolean = False; Emei : Boolean = False) : boolean;
    procedure ConsultaSituacao(id_nfvenda,protocolo,num_lote : string);
    function ConsultaNFSeRPS(NumeroRps, SerieRps, CodVerificacao: String; consultaAposTransmissao: String = 'N'; AID_NFVenda: Integer = 0) : boolean;
    procedure ConsultaLote(protocolo, Lote : string);
    procedure Cancelar(aID_NFVenda: Integer; NumNFSe, Codigo, Motivo, NumLote, CodVerif, SerNFSe,
      NumRps, ValNFSe, dataEmissao: string);
    function fImprime_Danfsex(sNumero, sSerie, sNumero_Lote: string;
      dataEmissao: TDate; bVisualiza : boolean; AObservacao, AOutrasInformacoes,
      AIEProdutorRural: String;
      iNumCopias: integer = 1;
      AImprime : boolean = True) : boolean;
    function validadeCertificado(): Boolean;
    property ConexaoTemp : TIBDataBase read FConexaoTemp write SetConexaoTemp;
    property FDQueryV_NFSe : TIBQuery read FFDQueryV_NFSe write SetFDQueryV_NFSe;
    property FDQueryV_NFSeItem : TIBQuery read FFDQueryV_NFSeItem write SetFDQueryV_NFSeItem;
    property FDQueryNFSeItemDiscriminacao :TIBQuery read FFDQueryNFSeItemDiscriminacao write SetFDQueryNFSeItemDiscriminacao;
    property FDQueryCliente : TIBQuery read FFDQueryCliente write SetFDQueryCliente;
    property ACBrNFSeX1 : TACBrNFSeX read FACBrNFSeX1 write SetACBrNFSeX1;
    property ACBrNFSeXDANFSeFR1 : TACBrNFSeXDANFSeFR read FACBrNFSeXDANFSeFR1 write SetACBrNFSeXDANFSeFR1;
  end;

//var
//  DataModuleNFSeX: TDataModuleNFSeX;

const
  Lucas_Do_Rio_Verde = '5105259';
  Ponta_Grossa = '4119905';


  SIT_Lote_Processamento = '2';
  SIT_Erro = '3';
  SIT_Sucesso = '4';
  PROC_Sucesso = 'Processado com sucesso';

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  //uFuncoesC4, C4Funcoes30, uConstantes, blcksock, UFuncNFSe, ufrmStatus, udm;

  Frm_Status, smallfunc_xe, uConectaBancoSmall;

(*
{ TNFS }

procedure TNFS.ACBrNFSeX1GerarLog(const ALogLine: string; var Tratado: Boolean);
begin
  //memoLog.Lines.Add(ALogLine);
  Tratado := False;
end;

procedure TNFS.ACBrNFSeX1StatusChange(Sender: TObject);
begin
  case TACBrNFSeX(Sender).Status of
    stNFSeIdle:
      begin
        if (frmStatus <> nil) then
          frmStatus.Hide;
      end;

    stNFSeRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando RPS...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsultaSituacao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando a Situação...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsulta:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeCancelamento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Cancelando NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeSubstituicao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Substituindo NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeEmail:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Email...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeAguardaProcesso:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Aguardando o Processo...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeEnvioWebService:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando para o WebService...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
  end;

  Application.ProcessMessages;

end;

function TNFS.ConfigurarComponente: Boolean;
var
  Ok: Boolean;
  PathMensal: String;
  FIniNFSe: TIniFile;
  StreamMemo: TMemoryStream;
  iAguardar: Integer;
  iIntervalo: Integer;
begin
  Result := True;

  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');


  SelecionarDadosEmitente;

  FACBrNFSeX1.LerCidades;

  if FIniNFSe.ReadString('NFSE', 'Ambiente', '2') = '1' then
    FACBrNFSeX1.Configuracoes.WebServices.Ambiente := taProducao
  else
    FACBrNFSeX1.Configuracoes.WebServices.Ambiente := taHomologacao;


  FACBrNFSeX1.Configuracoes.Certificados.ArquivoPFX  := '';
  FACBrNFSeX1.Configuracoes.Certificados.Senha       := '';
  FACBrNFSeX1.Configuracoes.Certificados.NumeroSerie := '';

  FACBrNFSeX1.Configuracoes.Certificados.ArquivoPFX  := FIniNFSe.ReadString( 'Certificado', 'Caminho',    '');
  FACBrNFSeX1.Configuracoes.Certificados.Senha       := FIniNFSe.ReadString( 'Certificado', 'Senha',      '');
  FACBrNFSeX1.Configuracoes.Certificados.NumeroSerie := FIniNFSe.ReadString( 'Certificado', 'NumSerie',   '');

  //FACBrNFSeX1.SSL.DescarregarCertificado;

  //with FACBrNFSeX1.Configuracoes.Geral do
  begin
    FACBrNFSeX1.Configuracoes.Geral.SSLLib        := TSSLLib(FIniNFSe.ReadInteger('Certificado', 'SSLLib',     4));
    FACBrNFSeX1.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib(FIniNFSe.ReadInteger('Certificado', 'CryptLib',   3));
    FACBrNFSeX1.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib(FIniNFSe.ReadInteger('Certificado', 'HttpLib',    2));
    FACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(FIniNFSe.ReadInteger('Certificado', 'XmlSignLib', 0));

    //AtualizarSSLLibsCombo;

    FACBrNFSeX1.Configuracoes.Geral.Salvar           := FIniNFSe.ReadBool('Geral', 'Salvar',         True);
    FACBrNFSeX1.Configuracoes.Geral.ExibirErroSchema := FIniNFSe.ReadBool('Geral', 'ExibirErroSchema', True);
    FACBrNFSeX1.Configuracoes.Geral.RetirarAcentos   := FIniNFSe.ReadBool('Geral', 'RetirarAcentos', True);
    FACBrNFSeX1.Configuracoes.Geral.FormatoAlerta    := FIniNFSe.ReadString('Geral', 'FormatoAlerta', 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
    FACBrNFSeX1.Configuracoes.Geral.FormaEmissao     := TpcnTipoEmissao(FIniNFSe.ReadInteger('Geral', 'FormaEmissao', 0)); // 0-Normal

    //FACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio := FIniNFSe.ReadBool('Geral', 'ConsultaAposEnvio',    False);

    if (TipoEnvio = meLoteAssincrono) or (FACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM]) then//if (getTipoEnvio(TipoEnvio) = meLoteAssincrono) or (FACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM]) then
      FACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio  := True;

    if FACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSiapSistemas, profintelISS, proNFSeBrasil]) then
      FACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio  := False;

    //FACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar  := FIniNFSe.ReadBool('Geral', 'ConsultaAposCancelar', False);
    FACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar   := True;

    if FACBrNFSeX1.Configuracoes.Geral.Provedor in
      [proPronim, profintelISS, proEl, proISSNet]
    then
      FACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar := False;

    FACBrNFSeX1.Configuracoes.Geral.MontarPathSchema      := FIniNFSe.ReadBool('Geral', 'MontarPathSchemas',    True);

    FACBrNFSeX1.Configuracoes.Geral.CNPJPrefeitura := FIniNFSe.ReadString('Emitente', 'CNPJPref',    '');

    FACBrNFSeX1.Configuracoes.Geral.Emitente.CNPJ           := LimpaNumero(FIBQEMITENTE.FieldByName('CGC').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.InscMun        := LimpaNumero(FIBQEMITENTE.FieldByName('IM').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.RazSocial      := FIBQEMITENTE.FieldByName('NOME').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.WSUser         := FIniNFSe.ReadString( 'WebService', 'UserWeb',      '');
    FACBrNFSeX1.Configuracoes.Geral.Emitente.WSSenha        := FIniNFSe.ReadString( 'WebService', 'SenhaWeb',     '');
    FACBrNFSeX1.Configuracoes.Geral.Emitente.WSFraseSecr    := FIniNFSe.ReadString( 'WebService', 'FraseSecWeb',  '');
    FACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAcesso  := FIniNFSe.ReadString( 'WebService', 'ChAcessoWeb',  '');
    FACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAutoriz := FIniNFSe.ReadString( 'WebService', 'ChAutorizWeb', '');

    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.NomeFantasia      := FIBQEMITENTE.FieldByName('NOME').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.InscricaoEstadual := LimpaNumero(FIBQEMITENTE.FieldByName('IE').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Endereco          := ExtraiEnderecoSemONumero(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Numero            := ExtraiNumeroSemOEndereco(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.CEP               := LimpaNumero(FIBQEMITENTE.FieldByName('CEP').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Bairro            := FIBQEMITENTE.FieldByName('COMPLE').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Complemento       := '';
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Municipio         := FIBQEMITENTE.FieldByName('MUNICIPIO').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.UF                := FIBQEMITENTE.FieldByName('ESTADO').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.CodigoMunicipio   := FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString;
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Telefone          := LimpaNumero(FIBQEMITENTE.FieldByName('TELEFO').AsString);
    FACBrNFSeX1.Configuracoes.Geral.Emitente.DadosEmitente.Email             := FIBQEMITENTE.FieldByName('EMAIL').AsString;

    {
      Para o provedor ADM, utilizar as seguintes propriedades de configurações:
      WSChaveAcesso  para o Key
      WSChaveAutoriz para o Auth
      WSUser         para o RequestId

      O Key, Auth e RequestId são gerados pelo provedor quando o emitente se cadastra.
    }
  end;

  //with FACBrNFSeX1.Configuracoes.WebServices do
  begin
    //FACBrNFSeX1.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok, FIniNFSe.ReadString('NFSE', 'Ambiente', '2')); // StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
    FACBrNFSeX1.Configuracoes.WebServices.Visualizar := FIniNFSe.ReadBool('WebService', 'Visualizar', True);;//cbxVisualizar.Checked;
    FACBrNFSeX1.Configuracoes.WebServices.Salvar     := FIniNFSe.ReadBool('WebService', 'SalvarSOAP', True);//chkSalvarSOAP.Checked;
    FACBrNFSeX1.Configuracoes.WebServices.UF         := FIBQEMITENTE.FieldByName('ESTADO').AsString;// edtEmitUF.Text;

    FACBrNFSeX1.Configuracoes.WebServices.AjustaAguardaConsultaRet := True;// cbxAjustarAut.Checked;


    iAguardar := FIniNFSe.ReadInteger('WebService', 'Aguardar', 3000);
    if iAguardar > 0 then //if NaoEstaVazio(edtAguardar.Text) then
      FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := ifThen(iAguardar < 1000, iAguardar * 1000, iAguardar); //FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text) < 1000, StrToInt(edtAguardar.Text) * 1000, StrToInt(edtAguardar.Text))
    //else
    //  edtAguardar.Text := IntToStr(FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet);

    //if FIniNFSe.ReadInteger('WebService', 'Tentativas', 5) > 0 then //if NaoEstaVazio(edtTentativas.Text) then
      FACBrNFSeX1.Configuracoes.WebServices.Tentativas := FIniNFSe.ReadInteger('WebService', 'Tentativas', 5);// StrToInt(edtTentativas.Text)
    //else
    //  edtTentativas.Text := IntToStr(FACBrNFSeX1.Configuracoes.WebServices.Tentativas);

    iIntervalo := FIniNFSe.ReadInteger('WebService', 'Intervalo', 5000);
    if iIntervalo > 0 then //if NaoEstaVazio(edtIntervalo.Text) then
      FACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas := ifThen(iIntervalo < 1000, iIntervalo * 1000, iIntervalo);//FACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text) < 1000, StrToInt(edtIntervalo.Text) * 1000, StrToInt(edtIntervalo.Text))
    //else
    //  edtIntervalo.Text := IntToStr(FACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas);

    FACBrNFSeX1.Configuracoes.WebServices.TimeOut   := FIniNFSe.ReadInteger('WebService', 'TimeOut', 5000);//seTimeOut.Value;
    FACBrNFSeX1.Configuracoes.WebServices.ProxyHost := FIniNFSe.ReadString('Proxy', 'Host', '');//edtProxyHost.Text;
    FACBrNFSeX1.Configuracoes.WebServices.ProxyPort := FIniNFSe.ReadString('Proxy', 'Porta', '');//edtProxyPorta.Text;
    FACBrNFSeX1.Configuracoes.WebServices.ProxyUser := FIniNFSe.ReadString('Proxy', 'User', '');//edtProxyUser.Text;
    FACBrNFSeX1.Configuracoes.WebServices.ProxyPass := FIniNFSe.ReadString('Proxy', 'Pass', '');//edtProxySenha.Text;
  end;

  FACBrNFSeX1.SSL.SSLType := TSSLType(FIniNFSe.ReadInteger('WebService', 'SSLType',      5));// TSSLType(cbSSLType.ItemIndex);

  //with FACBrNFSeX1.Configuracoes.Arquivos do
  begin
    FACBrNFSeX1.Configuracoes.Arquivos.NomeLongoNFSe    := True;
    FACBrNFSeX1.Configuracoes.Arquivos.Salvar           := FIniNFSe.ReadBool('Arquivos', 'Salvar',          False);//chkSalvarArq.Checked;
    FACBrNFSeX1.Configuracoes.Arquivos.SepararPorMes    := FIniNFSe.ReadBool('Arquivos', 'PastaMensal',     False);//cbxPastaMensal.Checked;
    FACBrNFSeX1.Configuracoes.Arquivos.AdicionarLiteral := FIniNFSe.ReadBool('Arquivos', 'AddLiteral',    False);//cbxAdicionaLiteral.Checked;
    FACBrNFSeX1.Configuracoes.Arquivos.EmissaoPathNFSe  := FIniNFSe.ReadBool('Arquivos', 'EmissaoPathNFSe', False);//cbxEmissaoPathNFSe.Checked;
    FACBrNFSeX1.Configuracoes.Arquivos.SepararPorCNPJ   := FIniNFSe.ReadBool('Arquivos', 'SepararPorCNPJ',  False);//cbxSepararPorCNPJ.Checked;
    FACBrNFSeX1.Configuracoes.Arquivos.PathSchemas      := ExtractFilePath(Application.ExeName) + 'ArquivosNFSe';// edtPathSchemas.Text;
    FACBrNFSeX1.Configuracoes.Arquivos.PathGer          := ExtractFilePath(Application.ExeName) + 'log\nfse'; //edtPathLogs.Text;
    PathMensal       := FACBrNFSeX1.Configuracoes.Arquivos.GetPathGer(0);
    FACBrNFSeX1.Configuracoes.Arquivos.PathSalvar       := PathMensal;
  end;
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log');
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log\nfse') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log\nsfe');

  if FACBrNFSeX1.DANFSE <> nil then
  begin
    // TTipoDANFSE = ( tpPadrao, tpIssDSF, tpFiorilli );
    FACBrNFSeX1.DANFSE.TipoDANFSE := tpPadrao;
    FACBrNFSeX1.DANFSE.Logo       := ExtractFilePath(Application.ExeName) + 'logonsfe'; //edtLogoMarca.Text;
    FACBrNFSeX1.DANFSE.Prefeitura := ExtractFilePath(Application.ExeName) + 'logoprefeitura'; //edtPrefeitura.Text;
    FACBrNFSeX1.DANFSE.PathPDF    := ExtractFilePath(Application.ExeName) + 'xmldestinatario\nfse\pdf'; //edtPathPDF.Text;

    FACBrNFSeX1.DANFSE.Prestador.Logo := ExtractFilePath(Application.ExeName) + 'logonsfe'; //edtPrestLogo.Text;

    FACBrNFSeX1.DANFSE.MargemDireita  := 5;
    FACBrNFSeX1.DANFSE.MargemEsquerda := 5;
    FACBrNFSeX1.DANFSE.MargemSuperior := 5;
    FACBrNFSeX1.DANFSE.MargemInferior := 5;

    FACBrNFSeX1.DANFSE.ImprimeCanhoto := True;

    // Defini a quantidade de casas decimais para o campo aliquota
    FACBrNFSeX1.DANFSE.CasasDecimais.Aliquota := 2;
  end;

  {Usar mail.exe
  //with FACBrNFSeX1.MAIL do
  begin
    FACBrNFSeX1.MAIL.Host      := edtSmtpHost.Text;
    FACBrNFSeX1.MAIL.Port      := edtSmtpPort.Text;
    FACBrNFSeX1.MAIL.Username  := edtSmtpUser.Text;
    FACBrNFSeX1.MAIL.Password  := edtSmtpPass.Text;
    FACBrNFSeX1.MAIL.From      := edtEmailRemetente.Text;
    FACBrNFSeX1.MAIL.FromName  := edtEmitRazao.Text;
    FACBrNFSeX1.MAIL.SetTLS    := cbEmailTLS.Checked;
    FACBrNFSeX1.MAIL.SetSSL    := cbEmailSSL.Checked;
    FACBrNFSeX1.MAIL.UseThread := False;

    FACBrNFSeX1.MAIL.ReadingConfirmation := False;
  end;
  }

  try
  // A propriedade CodigoMunicipio tem que ser a ultima a receber o seu valor
  // Pois ela se utiliza das demais configurações
    FACBrNFSeX1.Configuracoes.Geral.LayoutNFSe := TLayoutNFSe(FIniNFSe.ReadInteger('Geral', 'LayoutNFSe',     0));// TLayoutNFSe(cbLayoutNFSe.ItemIndex);
    FACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToInt64Def(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString, 0);// StrToIntDef(edtCodCidade.Text, -1);
  except
    on E: Exception do
    begin

//      if Enviathread then
//      begin
//        TVar_Dados_novo.Mensagem := e.Message;
//      end
//      else
//        if Pos('"pro" não é um valor TnfseProvedor válido', E.Message) > 0  then
//          raise Exception.Create('Verifique as configurações da NFSe!');

      Result := False;
      exit
    end;
  end;

  //lblSchemas.Caption := FACBrNFSeX1.Configuracoes.Geral.xProvedor;

  //  if FACBrNFSeX1.Configuracoes.Geral.Layout = loABRASF then
  //    lblLayout.Caption := 'ABRASF'
  //  else
  //    lblLayout.Caption := 'Próprio';
  //
  //  lblVersaoSchemas.Caption := VersaoNFSeToStr(FACBrNFSeX1.Configuracoes.Geral.Versao);
  //
  //  if FACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
  //  begin
  //    pgcProvedores.Pages[0].TabVisible := False;
  //    pgcProvedores.Pages[1].TabVisible := True;
  //  end
  //  else
  //  begin
  //    pgcProvedores.Pages[0].TabVisible := True;
  //    pgcProvedores.Pages[1].TabVisible := False;
  //  end

end;

constructor TNFS.Create(AOwner: TComponent);
begin
  inherited;
  CoInitialize(nil);

  FACBrNFSeX1 := TACBrNFSeX.Create(AOwner);
  //FACBrNFSeXDANFSeRL1 := TACBrNFSeXDANFSeRL.Create(AOwner);
  FACBrNFSeXDANFSeFR1 := TACBrNFSeXDANFSeFR.Create(nil);
  FACBrMail1 := TACBrMail.Create(AOwner);
  FACBrNFSeX1.OnGerarLog := ACBrNFSeX1GerarLog;
  FACBrNFSeX1.OnStatusChange := ACBrNFSeX1StatusChange;
  FACBrNFSeX1.DANFSE := FACBrNFSeXDANFSeFR1;//FACBrNFSeXDANFSeRL1;
  FACBrNFSeX1.MAIL := FACBrMail1;
  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfseConfig.ini');
  TipoEnvio := meLoteAssincrono;

  //FACBrNFSeX1 := TACBrNFSeX.Create(nil);
  FACBrNFSeX1.Configuracoes.Geral.SSLLib := libNone;
  FACBrNFSeX1.Configuracoes.Geral.SSLCryptLib := cryNone;
  FACBrNFSeX1.Configuracoes.Geral.SSLHttpLib := httpNone;
  FACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := xsNone;
  FACBrNFSeX1.Configuracoes.Geral.FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
  FACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := 0;
  FACBrNFSeX1.Configuracoes.Geral.Provedor := proNenhum;
  FACBrNFSeX1.Configuracoes.Geral.Versao := ve100;
  FACBrNFSeX1.Configuracoes.WebServices.UF := 'SP';
  FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := 0;
  FACBrNFSeX1.Configuracoes.WebServices.QuebradeLinha := '|';
  FACBrNFSeX1.Configuracoes.Geral.Assinaturas := taConfigProvedor;
  FACBrNFSeX1.Configuracoes.Geral.ExibirErroSchema := True;
  FACBrNFSeX1.Configuracoes.Geral.FormaEmissao := teNormal;
  FACBrNFSeX1.Configuracoes.Geral.RetirarAcentos := True;
  FACBrNFSeX1.Configuracoes.Geral.RetirarEspacos := True;
  FACBrNFSeX1.Configuracoes.Geral.Salvar := True;
  FACBrNFSeX1.Configuracoes.Geral.ValidarDigest := True;

  FACBrNFSeXDANFSeFR1 := TACBrNFSeXDANFSeFR.Create(nil);
  FACBrNFSeXDANFSeFR1.Sistema := 'Zuccheti Sistemas';
  ACBrNFSeXDANFSeFR1.MargemInferior := 8.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemSuperior := 8.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemEsquerda := 6.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemDireita := 5.100000000000000000;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Altura := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esquerda := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Topo := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Largura := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Dimensionar := False;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esticar := True;
  ACBrNFSeXDANFSeFR1.CasasDecimais.Formato := tdetInteger;
  ACBrNFSeXDANFSeFR1.CasasDecimais.qCom := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.vUnCom := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskqCom := ',0.00';
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskvUnCom := ',0.00';
  ACBrNFSeXDANFSeFR1.CasasDecimais.Aliquota := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskAliquota := ',0.00';
  ACBrNFSeXDANFSeFR1.ACBrNFSe := FACBrNFSeX1;
  ACBrNFSeXDANFSeFR1.Cancelada := False;
  ACBrNFSeXDANFSeFR1.Provedor := proNenhum;
  ACBrNFSeXDANFSeFR1.TamanhoFonte := 6;
  ACBrNFSeXDANFSeFR1.FormatarNumeroDocumentoNFSe := True;
  ACBrNFSeXDANFSeFR1.Producao := snSim;
  ACBrNFSeXDANFSeFR1.EspessuraBorda := 1;
  ACBrNFSeXDANFSeFR1.IncorporarFontesPdf := False;
  ACBrNFSeXDANFSeFR1.IncorporarBackgroundPdf := False;

end;

destructor TNFS.Destroy;
begin
  //FreeAndNil(FACBrNFSeXDANFSeRL1);
  FreeAndNil(FACBrNFSeXDANFSeFR1);
  FreeAndNil(FACBrMail1);
  FreeAndNil(FACBrNFSeX1);
  FreeAndNil(FIniNFSe);
  inherited;
end;

function TNFS.GetCidade_Goiania(id_cidade: string): string;
//var
//  qryConsulta : TIBQuery;
begin
  {
  //Goiânia utiliza código específico - Emitente
  QryConsulta := CriaIBQuery(FIBQNFSE.Transaction);
  try
    //QryConsulta.Connection := ConexaoTemp;
    QryConsulta.Close;
    QryConsulta.SQL.Text :=
    //  'select CODIGO_SEDETEC from TB_CIDADE_SIS where ID_CIDADE = '+QuotedStr(id_cidade);
    QryConsulta.Open;
    if QryConsulta.IsEmpty then
      Exit(id_cidade);

    Exit(QryConsulta.FieldByName('CODIGO_SEDETEC').AsString);
  finally
    QryConsulta.Free;
  end;
  }
  FIniNFSe.ReadString('NFSE', 'CODIGOCIDADE', '');
end;

function TNFS.GetCodigoMunicipioServico: String;
begin
  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNET) and (FACBrNFSeX1.Configuracoes.WebServices.Ambiente = taHomologacao) then
    Exit('999'); // Para o provedor ISS.NET em ambiente de Homologação  o Codigo do Municipio tem que ser '999'

  if not(FIBQEMITENTE.FieldByName('MUNICIPIO').IsNull) then //if not(FIBDQueryV_NFSe.FieldByName('ID_CIDADE').IsNull) then
  begin
    if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
      Exit(GetCidade_Goiania(''));//Exit(GetCidade_Goiania(FDQueryV_NFSe.FieldByName('ID_CIDADE').AsString));

    Exit(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString);
  end;


  //  if FDQueryV_NFSe.FieldByName('CODIGO_NATOPE').AsString = '2' then
  //  begin
  //    if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
  //      Exit(GetCidade_Goiania(FDQueryCliente.FieldByName('ID_CIDADE').AsString));
  //
  //    Exit(FDQueryCliente.FieldByName('ID_CIDADE').AsString);
  //  end;

  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
    Exit(GetCidade_Goiania(''));// Exit(GetCidade_Goiania(TNFSe_Emitente.iid_Cidade));

  Exit(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString); //Exit(TNFSe_Emitente.iid_Cidade);
end;

//class procedure TNFS.SelecionarDadosEmitente(var IBQEMITENTE: TIBQuery);
//begin
//  FIBQEMITENTE   := CriaIBQuery(FIBTRANSACTION);
//  IBQEMITENTE.Close;
//  IBQEMITENTE.SQL.Text :=
//    'select E.CGC, E.IM, E.NOME, E.IE, E.ENDERECO, E.CEP, E.COMPLE, E.MUNICIPIO, E.ESTADO, ' +
//    'E.TELEFO, E.EMAIL, ' +
//    'M.CODIGO as CODIGO_IBGE ' +
//    'from EMITENTE E ' +
//    'left join MUNICIPIOS M on M.NOME = E.MUNICIPIO and M.UF = E.ESTADO';
//  IBQEMITENTE.Open;
//
//end;

procedure TNFS.SelecionarDadosEmitente;
begin

  if FIBQEMITENTE = nil then
    FIBQEMITENTE   := CriaIBQuery(FIBTRANSACTION);

  FIBQEMITENTE.Close;
  FIBQEMITENTE.SQL.Text :=
    'select E.CGC, E.IM, E.NOME, E.IE, E.ENDERECO, E.CEP, E.COMPLE, E.MUNICIPIO, E.ESTADO, ' +
    'E.TELEFO, E.EMAIL, ' +
    'M.CODIGO as CODIGO_IBGE, M.CODIGO_SEDETEC ' +
    'from EMITENTE E ' +
    'left join MUNICIPIOS M on M.NOME = E.MUNICIPIO and M.UF = E.ESTADO';
  FIBQEMITENTE.Open;

  TNFSe_Emitente.iid_Cidade := FIBQEMITENTE.FieldByName('CODIGO_SEDETEC').AsString;

end;

procedure TNFS.SetIBTRANSACTION(const Value: TIBTransaction);
begin
  FIBTRANSACTION := Value;

  FIBQNFSE := CriaIBQuery(FIBTRANSACTION);
end;

*)
///////////////////////////////////////////////////
///////////////////////////////////////////////////

procedure MensagemAlerta(sTexto: String);
begin
  MensagemSistema(sTexto);
end;

procedure TDataModuleNFSeX.SetACBrNFSeX1(const Value: TACBrNFSeX);
begin
  FACBrNFSeX1 := Value;
end;

procedure TDataModuleNFSeX.SetACBrNFSeXDANFSeFR1(
  const Value: TACBrNFSeXDANFSeFR);
begin
  FACBrNFSeXDANFSeFR1 := Value;
end;

procedure TDataModuleNFSeX.SetACBrNFSeXDANFSeRL1(
  const Value: TACBrNFSeXDANFSeRL);
begin
  FACBrNFSeXDANFSeRL1 := Value;
end;

procedure TDataModuleNFSeX.SetConexaoTemp(const Value: TIBDataBase);
begin
  FConexaoTemp := Value;
end;

procedure TDataModuleNFSeX.SetFDQueryCliente(const Value: TIBQuery);
begin
  FFDQueryCliente := Value;
end;

procedure TDataModuleNFSeX.SetFDQueryNFSeItemDiscriminacao(
  const Value: TIBQuery);
begin
  FFDQueryNFSeItemDiscriminacao := Value;
end;

procedure TDataModuleNFSeX.SetFDQueryV_NFSe(const Value: TIBQuery);
begin
  FFDQueryV_NFSe := Value;
end;

procedure TDataModuleNFSeX.SetFDQueryV_NFSeItem(const Value: TIBQuery);
begin
  FFDQueryV_NFSeItem := Value;
end;

procedure TDataModuleNFSeX.StatusChange(Sender: TObject);
begin
  case ACBrNFSeX1.Status of
    stNFSeIdle:
      begin
        if (frmStatus <> nil) then
          frmStatus.Hide;
      end;

    stNFSeRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando RPS...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsultaSituacao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando a Situação...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsulta:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeCancelamento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Cancelando NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeSubstituicao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Substituindo NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeEmail:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Email...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    //#17859 - Anderson
    //depois que montou o XML e antes de enviar para o WebService
    //garante que fica provedor+município correto para fazer o envio correto
    stNFSeEnvioWebService:
    begin
      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSIntel) and
         (ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio <> StrToIntDef(TNFSe_Emitente.iid_Cidade, 0)) then
        ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToIntDef(TNFSe_Emitente.iid_Cidade, 0);
    end;
  end;

  Application.ProcessMessages;
end;

function TDataModuleNFSeX.StrToRegimeApuracaoSN(out ok: boolean;
  const s: String): TRegimeApuracaoSN;
begin
  result := StrToEnumerado(ok, s,
                          ['0','1','2'],
                          [raFederaisMunicipalpeloSN, raFederaisSN, raFederaisMunicipalforaSN]);
end;

function TDataModuleNFSeX.StrToRegimeEspecialTributacao(out ok: boolean;
  const s: String): TnfseRegimeEspecialTributacao;
begin
  result := StrToEnumerado(ok, s,
                          ['0','1','2','3','4','5','6','7','8','9','10', '11', '12',
                           '13', '14'],
                          [retNenhum, retMicroempresaMunicipal, retEstimativa,
                           retSociedadeProfissionais, retCooperativa,
                           retMicroempresarioIndividual, retMicroempresarioEmpresaPP,
                           retLucroReal, retLucroPresumido, retSimplesNacional, retImune,
                           retEmpresaIndividualRELI, retEmpresaPP, retMicroEmpresario,
                           retOutros]);
end;

function TDataModuleNFSeX.SucessoLote_AssessorPublico: Boolean;
var
  sRetorno: string;
begin
  Result := False;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proAssessorPublico then
    Exit;

  if not ACBrNFSeX1.WebService.ConsultaLoteRps.Sucesso then
    Exit;

  sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.ConsultaLoteRps.ArquivoRetorno);

  if CopiarChaveXML(sRetorno, 'CANCELADA') = DADO_SIM then
  begin
    MensagemAlerta('Nota cancelada na prefeitura.' + sLineBreak +
                   'Utilize a opção Cancelamento para cancelar no sistema também.');
  end;

  TVar_Dados_novo.Protocolo   := ACBrNFSeX1.WebService.ConsultaLoteRps.Protocolo;
  TVar_Dados_novo.Link_Nfse   := CopiarChaveXML(sRetorno, 'LINK');
  TVar_Dados_novo.Nfse_Numero := CopiarChaveXML(sRetorno, 'COD');
  TVar_Dados_novo.Situacao    := SIT_Sucesso;
  TVar_Dados_novo.Mensagem    := PROC_Sucesso;
  Result := True;
end;

function TDataModuleNFSeX.validadeCertificado: Boolean;
begin
  result := True;
  try
    if ACBrNFSeX1.SSL.CertDataVenc <> 0 then
    begin
      //TFuncao.Gravacao.GravarValidadeCertificado('VALIDADE_CERTIFICADO_NFSE', DateToStr(ACBrNFSeX1.SSL.CertDataVenc));
    end;
  except //NFse pode nao ter certificado, usa apenas usuario e senha
    on e : exception do
    begin
      TVar_Dados_novo.Mensagem := 'Erro ao validar certificado '+e.Message;
      TVar_Dados_novo.Situacao := '3';
      result := False;
      if not EnviaThread then
        //TFuncao.Mensagens.MensagemAlerta('Erro ao validar certificado '+e.Message);
    end;
  end;
end;

procedure TDataModuleNFSeX.VerificaStatusNFSeBrasil;
begin
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proNFSeBrasil then
    if Pos('fila de processamento',TVar_Dados_novo.Mensagem) > 0 then
      TVar_Dados_novo.Situacao := SIT_Lote_Processamento;
end;

function TDataModuleNFSeX.GetCidade_Goiania(id_cidade :string) : string;
var
  qryConsulta : TIBQuery;
begin
  //Goiânia utiliza código específico - Emitente
  QryConsulta := TIBQuery.Create(Self);
  try
//    QryConsulta.Connection := ConexaoTemp;
//    QryConsulta.Open(
//      'select CODIGO_SEDETEC from TB_CIDADE_SIS where ID_CIDADE = '+QuotedStr(id_cidade)
//    );
    QryConsulta.Transaction := FIBTRANSACTION;
    QryConsulta.SQL.Text :=
      'select CODIGO_SEDETEC from MUNICIPIOS where CODIGO = ' + QuotedStr(id_cidade);
    QryConsulta.Open;
    if QryConsulta.FieldByName('CODIGO_SEDETEC').AsString = '' then // if QryConsulta.IsEmpty then
      Exit(id_cidade);

    Exit(QryConsulta.FieldByName('CODIGO_SEDETEC').AsString);
  finally
    QryConsulta.Free;
  end;
end;

function TDataModuleNFSeX.GetCodigoCNAE: String;
begin
  if not(ACBrNFSeX1.Configuracoes.Geral.Provedor = proSystemPro) then
    Result := TNFSe_Emitente.sCnae;

  //#10208 - Anderson - Betha e Lucas do Rio Verde não pode enviar CNAE
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) and
     (GetCodigoMunicipioServico = Lucas_Do_Rio_Verde) or
     (StrToBoolDef(TNFSeDados.sCNAEZerado, false) = true) then
    Result := EmptyStr;

  //#14273 - Anderson
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) and
     (FDQueryV_NFSeItem.FieldByName('CNAE').AsString <> EmptyStr) then
    Result := FDQueryV_NFSeItem.FieldByName('CNAE').AsString;


  //#13997 - Anderson > internamente na AssessorPublico.GravarXml é convertido para ATIVIDADE
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico, proSoftPlan] then
	  Result := FDQueryV_NFSe.FieldByName('cod_lst').AsString;


end;

function TDataModuleNFSeX.GetCodigoMunicipioServico: String;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNET) and (ACBrNFSeX1.Configuracoes.WebServices.Ambiente = taHomologacao) then
    Exit('999'); // Para o provedor ISS.NET em ambiente de Homologação  o Codigo do Municipio tem que ser '999'

  if not(FDQueryV_NFSe.FieldByName('ID_CIDADE').IsNull) then
  begin
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
      Exit(GetCidade_Goiania(FDQueryV_NFSe.FieldByName('ID_CIDADE').AsString));

    Exit(FDQueryV_NFSe.FieldByName('ID_CIDADE').AsString);
  end;

  if FDQueryV_NFSe.FieldByName('CODIGO_NATOPE').AsString = '2' then
  begin
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
      Exit(GetCidade_Goiania(FDQueryCliente.FieldByName('ID_CIDADE').AsString));

    Exit(FDQueryCliente.FieldByName('ID_CIDADE').AsString);
  end;

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
    Exit(GetCidade_Goiania(TNFSe_Emitente.iid_Cidade));

  Exit(TNFSe_Emitente.iid_Cidade);
end;



function TDataModuleNFSeX.AjustaDiscriminacao(Discriminacao : string): string;
var
  vDiscriminacao, vSub, vDescricao, vItemServico, vQuantidade, vValorUnitario : string;
  TipoConteudo : Integer;
begin
  Result := '';
  {2022-08-15 - #11597 - Ficha 12940 - Impressao Betha - Remover ponto e virgula para nao quebrar linha - Renan}
  vDiscriminacao := StringReplace(Discriminacao, '; ; ;', '/', [rfReplaceAll]);

  if PosEx('Descricao={[[DESCRICAO', vDiscriminacao) > 0 then
    TipoConteudo:= 0  // Conteudo com 2 Descricoes no XML "Descricao={[[DESCRICAO"
  else
    TipoConteudo:= 1; // Conteudo com 1 Descricao no XML "Descricao={"

  while (pos(']]', vDiscriminacao)>0) do
  begin
    vSub := Copy(vDiscriminacao, 1, pos(']]', vDiscriminacao)-1);
    Delete(vDiscriminacao, 1, pos(']]', vDiscriminacao));

    if TipoConteudo = 0 then
    begin
      if PosEx('Descricao={', vSub) > 0 then
        Delete(vSub, 1, PosEx('Descricao={', vSub)+11);
      Delete(vSub, 1, PosEx('DESCRICAO=', vSub)-1);
      vDescricao := Copy(vSub, (PosEx('DESCRICAO=', vSub) + 10), (PosEx(']', vSub) - (PosEx('DESCRICAO=', vSub) + 10)));
      Delete(vSub, 1, PosEx('QUANTIDADE=', vSub)-1);
      vQuantidade := Copy(vSub, (PosEx('QUANTIDADE=', vSub) + 11), (PosEx(']', vSub) - (PosEx('QUANTIDADE=', vSub) + 11)));
      Delete(vSub, 1, PosEx('VALORUNITARIO=', vSub)-1);
      vValorUnitario := Copy(vSub, (PosEx('VALORUNITARIO=', vSub) + 14), (PosEx(']', vSub) - (PosEx('VALORUNITARIO=', vSub) + 14)));
      vSub := 'Descrição:' + vDescricao + {' Item:' + vItemServico +} ' Qtd:' + vQuantidade + ' Valor Unit:' + vValorUnitario;
    end
    else
    begin
      Delete(vSub, 1, PosEx('Descricao=', vSub)-1);
      vDescricao := Copy(vSub, (PosEx('Descricao=', vSub) + 10), (PosEx(']', vSub) - (PosEx('Descricao=', vSub) + 10)));
      vDescricao := vDescricao + StringOfChar(' ', (60 - Length(vDescricao)));
      Delete(vSub, 1, PosEx('itemservico=', LowerCase(vSub))-1);
      vItemServico := Copy(vSub, (PosEx('itemservico=', LowerCase(vSub)) + 12), (PosEx(']', vSub) - (PosEx('itemservico=', LowerCase(vSub)) + 12)));
      Delete(vSub, 1, PosEx('Quantidade=', vSub)-1);
      vQuantidade := Copy(vSub, (PosEx('Quantidade=', vSub) + 11), (PosEx(']', vSub) - (PosEx('Quantidade=', vSub) + 11)));
      vQuantidade := StringOfChar(' ', (10 - Length(vQuantidade))) + vQuantidade;
      Delete(vSub, 1, PosEx('ValorUnitario=', vSub)-1);
      vValorUnitario := Copy(vSub, (PosEx('ValorUnitario=', vSub) + 14), (PosEx(']', vSub) - (PosEx('ValorUnitario=', vSub) + 14)));
      vValorUnitario := StringOfChar(' ', (15 - Length(vValorUnitario))) + vValorUnitario;
      vSub := 'Descrição:' + vDescricao + ' Item:' + vItemServico + ' Qtd:' + vQuantidade + ' Valor Unit:' + vValorUnitario;
    end;

    if (Trim(vDescricao) <> EmptyStr) then
    begin
      if Trim(Result) = '' then
         Result := vSub
      else
         Result := Result + sLineBreak + vSub;
    end;
  end;
  if Result = '' then
    Result := discriminacao;
end;

procedure TDataModuleNFSeX.AlimentaNFSe(AID_NFVenda: Integer; Emei : Boolean);
var
  Ok: Boolean;
  ValorISS: Double;
  Num_lote  : integer;
  qryUpdate, QryLSTExtra: TIBQuery;
  ObservacaoItem, LSTExtra: String;
  cSomaRet_INSS, cSomaRet_IRRF, cSomaRet_COFINS, cSomaRet_PIS, cSomaRet_CSLL: Currency;

  function getCepPrestador : string;
  begin
    if ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1 then
      Result := ''
    else if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEloTech, proInfisc]) then
      Result := LimpaNumero(TNFSe_Emitente.sEnd_Cep)
    else
      Result := TNFSe_Emitente.sEnd_Cep;
  end;

  function getCepTomador : string;
  begin
    if (ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1) or
       (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proGoverna,
       proInfisc,
       proSoftPlan]) then
      Result := LimpaNumero(FDQueryCliente.FieldByName('END_CEP').AsString)
    else
      Result := FDQueryCliente.FieldByName('END_CEP').AsString;
  end;

  function ProdutoTributavel : TnfseSimNao;
  begin
    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEloTech] then
    begin
      if FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsString = '1' then
        result := snSim
      else
        result := snNao;
    end;
    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF] then
    begin
      if (FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsString = '1') or
        (FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsString = '2')
       then
        result := snSim
      else
        result := snNao;
    end;
  end;
  function GetExigibilidadeISS: TnfseExigibilidadeISS;
  begin
    if FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsString <> '' then
    begin
      case FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsInteger of
        1 : Exit(exiExigivel);
        2 : Exit(exiNaoIncidencia);
        3 : Exit(exiIsencao);
        4 : Exit(exiExportacao);
        5 : Exit(exiImunidade);
        6 : Exit(exiSuspensaDecisaoJudicial);
        7 : Exit(exiSuspensaProcessoAdministrativo);
        8 : Exit(exiISSFixo);
      end;
    end;
  end;
  function GetTributacaoISS: TTributacao;
  begin
    if FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsString <> '' then
    begin
      if  (TNFSe_Emitente.sSimples_Nacional = DADO_SIM) and
          (FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsInteger = 1) then
        Exit(ttTributavelSN);
      case FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsInteger of
        1 : Exit(ttTributavel);
        2 : Exit(ttNaoIncidencianoMunic);
        3 : Exit(ttIsentaISS);
        4 : Exit(ttTributavel);
        5 : Exit(ttImune);
        6 : Exit(ttTributavelSN);
      end;
    end;
  end;

  function getVlr_RetencaoItem(var cSoma: Currency; cTot_Item, cTot_Retido: Currency): Currency;
  var
    cAux: Currency;
  begin
    if FDQueryV_NFSeItem.RecNo = FDQueryV_NFSeItem.RecordCount then
      Result := cTot_Retido - cSoma
    else
    begin
      cAux := cTot_Item / FDQueryV_NFSe.FieldByName('TOT_SERVICO').AsCurrency;
      cAux := cTot_Retido * cAux;
      cAux := RoundTo(cAux, -2);

      Result := cAux;
      cSoma := cSoma + cAux;
    end;
  end;

  function getTelefoneCliente : string;
  begin
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
      Result := LimpaNumero(
        FDQueryCliente.FieldByName('DDD_RESID').AsString +
        FDQueryCliente.FieldByName('FONE_RESID').AsString
      )
    else
    begin
      if LimpaNumero(FDQueryCliente.FieldByName('FONE_RESID').AsString) <> '' then
        Result := LimpaNumero(
          FDQueryCliente.FieldByName('DDD_RESID').AsString +
          FDQueryCliente.FieldByName('FONE_RESID').AsString
        )
      else if LimpaNumero(FDQueryCliente.FieldByName('FONE_COMER').AsString) <> '' then
        Result := LimpaNumero(
          FDQueryCliente.FieldByName('DDD_COMER').AsString +
          FDQueryCliente.FieldByName('FONE_COMER').AsString)
        else
          Result := LimpaNumero(
          FDQueryCliente.FieldByName('DDD_CELUL').AsString +
          FDQueryCliente.FieldByName('FONE_CELUL').AsString);
    end;
  end;
  function getTelefonePrestador : string;
  begin
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
    begin
      Result := trim(LimpaNumero(TNFSe_Emitente.sFone_Comer));
      exit;
    end;
    if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proGoverna then
      result := TNFSe_Emitente.sTelefone;
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
    begin
      result := LimpaNumero(result);
    end;
  end;

  function getEmailCliente : string;
  begin
    if Trim(FDQueryCliente.FieldByName('EMAIL_CONT').AsString) <> '' then
      Result := FDQueryCliente.FieldByName('EMAIL_CONT').AsString
    else
      if Trim(FDQueryCliente.FieldByName('EMAIL_NFE').AsString) <> '' then
        Result := FDQueryCliente.FieldByName('EMAIL_NFE').AsString
      else
        Result := FDQueryCliente.FieldByName('EMAIL_ADIC').AsString
  end;


  function GetItemDiscriminacao(): String;
  const
    BETHA_DESCRIMINACAO_ITENS = '[[DESCRICAO=%s][ITEMSERVICO=%s][ALIQUOTA=%.4f]'+
      '[QUANTIDADE=%.4f][VALORUNITARIO=%.2f][DEDUCOES=0.00]'+
      '[DESCONTOCONDICIONADO=0.00][DESCONTOINCONDICIONADO=%.2f]'+
      ']';
  var
    Qtd: Currency;
    DiscriminacaoItensBetha: String;
  begin
    if not(ACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) then
      Exit(FDQueryNFSeItemDiscriminacao.FieldByName('description_list').AsString);

    FDQueryV_NFSeItem.First;
    while not(FDQueryV_NFSeItem.Eof) do
    begin
      qtd := FDQueryV_NFSeItem.FieldByName('QTD_ITEM').AsCurrency;
      if qtd = 0 then
        qtd := 1;

      var ItemBetha: String := Format(
        BETHA_DESCRIMINACAO_ITENS,
          [
           FDQueryV_NFSeItem.FieldByName('PRODUTO').AsString +
           ifthen(FDQueryV_NFSeItem.FieldByName('OBSERVACAO').AsString <> '', ' - ' + FDQueryV_NFSeItem.FieldByName('OBSERVACAO').AsString, ''),
           LimpaNumero(getCodigoTributacaoMunicipio()),
           FDQueryV_NFSeItem.FieldByName('ALIQ_ISS').AsCurrency / 100,
           qtd,
           RoundTo(FDQueryV_NFSeItem.FieldByName('VLR_TOTAL').AsCurrency / qtd, -2),
           RoundTo(FDQueryV_NFSeItem.FieldByName('VLR_DESC').AsCurrency, -2)
          ],
          TFormatSettings.Create('en-US')
      );
      DiscriminacaoItensBetha := DiscriminacaoItensBetha + ItemBetha;
      FDQueryV_NFSeItem.Next;
    end;
    Result := ('{'+DiscriminacaoItensBetha+'}');
  end;

begin
  TVar_Dados_novo.fLimpa_VarDados;

  //Num_lote := gen_id(ConexaoTemp, 'GEN_TB_NFSE_NUM_LOTE',0); //Informa o último número de lote e grava na tabela para posterior consulta.
  Num_lote := IncGenerator(ConexaoTemp, 'GEN_TB_NFSE_NUM_LOTE', 0).ToInteger; //Informa o último número de lote e grava na tabela para posterior consulta.
  try
    qryUpdate := CriaIBQuery(FIBTRANSACTION); // qryUpdate := CriaSQLQuery(nil, ConexaoTemp);
    qrYUpdate.Close;
    qrYUpdate.SQL.Text := 'update TB_NFSE set NUM_LOTE = '+IntToStr(Num_lote)+' where ID_NFVENDA = '+QuotedStr(IntToStr(AID_NFVenda));
    qrYUpdate.Open;
  finally
    FreeAndNil(qryUpdate);
  end;

  (*É o provedor que controla a numeração do lote. Só pode incrementar a numeração se a nota for autorizada.*)
  if not(ACBrNFSeX1.Configuracoes.Geral.Provedor = proSystemPro) then
    IncGenerator(ConexaoTemp, 'GEN_TB_NFSE_NUM_LOTE', 1); // gen_id(ConexaoTemp,'GEN_TB_NFSE_NUM_LOTE', 1);

  Carrega_NFSe(AID_NFVenda);

  //FDQueryV_NFSeItem.Connection := ConexaoTemp;
  FDQueryV_NFSeItem.Transaction := FIBTRANSACTION; //TransacaoLeitura;

  FDQueryV_NFSeItem.Close();
  FDQueryV_NFSeItem.SQL.Text := 'select V_NFSE_ITEM.* '+
    ' from V_NFSE_ITEM '+
    ' where ID_NFVENDA = :ID_NFVENDA';
  FDQueryV_NFSeItem.ParamByName('ID_NFVENDA').AsInteger := AID_NFVenda;
  FDQueryV_NFSeItem.Open();

  var Description_Prefix: String := '';
  var Description_Sufix: String := '';

  {???
  if TNFSeDados.AddQtdVlUnitDiscriminacao then ?????
  begin
    Description_Prefix :=
      'QTD_ITEM||'+QuotedStr(' ')+'||COALESCE(UNI_MEDIDA,'''')||'+QuotedStr(' - ')+'||';
    Description_Sufix :=
      '||'+QuotedStr(' Vlr. Unit. R$')+'||VLR_UNIT';
  end;
  }

  //FDQueryNFSeItemDiscriminacao.Connection := ConexaoTemp;
  FDQueryNFSeItemDiscriminacao.Transaction := FIBTRANSACTION; // TransacaoLeitura;

  FDQueryNFSeItemDiscriminacao.Close();
  FDQueryNFSeItemDiscriminacao.SQL.Text := 'select '+
    ' list('+Description_Prefix+'produto||'+QuotedStr(' ')+'||coalesce('+
    QuotedStr('(')+'||V_NFSE_ITEM.observacao||'+QuotedStr(')')+', '+
    QuotedStr('')+')'+Description_Sufix+', '+QuotedStr('; ')+') description_list '+
    ' from V_NFSE_ITEM '+
    ' where ID_NFVENDA = :ID_NFVENDA';
  FDQueryNFSeItemDiscriminacao.ParamByName('ID_NFVENDA').AsInteger := AID_NFVenda;
  FDQueryNFSeItemDiscriminacao.Open();

  {2022-05-16 - #10018 - Impressao apos autorizacao Novo metodo DANFSE - Renan}
  TVar_Dados_novo.Nfse_Serie := FDQueryV_NFSe.FieldByName('NF_SERIE').AsString;
  TVar_Dados_novo.Nfse_OBS := FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString;
  TVar_Dados_novo.Nfse_Identidade_Tomador := FDQueryV_NFSe.FieldByName('IDENTIDADE_TOMADOR').AsString;
  TVar_Dados_novo.Nfse_Modelo := FDQueryV_NFSe.FieldByName('NF_MODELO').AsString;
  TVar_Dados_novo.Nfse_Nf_Numero := FDQueryV_NFSe.FieldByName('NF_NUMERO').AsInteger;
  TVar_Dados_novo.data := FDQueryV_NFSe.FieldByName('DT_EMISSAO').AsDateTime;

  ACBrNFSeX1.NotasFiscais.Clear;

  with ACBrNFSeX1 do
  begin
    NotasFiscais.NumeroLote := FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString;
    NotasFiscais.Transacao := True;

    with NotasFiscais.New.NFSe do
    begin

      //#13997 - Anderson
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico then
        Situacao := StrToIntDef(FDQueryV_NFSe.FieldByName('ADICIONAL1').AsString, -1);

      SituacaoTrib := tsTributadaNoPrestador; // aki

      Numero := FDQueryV_NFSe.FieldByName('RPS').AsString;



      {????
      (*#16969 - 2023-07-07*)
      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proGoverna) and
        (TNFSe_Funcao.Geral.controlaCodAutorizacao) then
      begin
        CodigoVerificacao := FDQueryV_NFSe.FieldByName('COD_AUTORIZACAO_RPS').AsString;
        RegRec := regMovimento;//StrToRegRec(Ok,Copy(TNFSeDados.sRegime_Recolhimento,0,2));
        FrmRec := StrToFrmRec(Ok,Copy(TNFSeDados.sForma_Recolhimento,0,2));
      end;
      }


      // Provedor Infisc - Layout Proprio
      //??? cNFSe := GerarCodigoDFe(StrToIntDef(Numero, 0));
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
        ModeloNFSe := '90';
      //
      (*
        No Caso dos provedores abaixo o campo SeriePrestacao devemos informar:
        Número do equipamento emissor do RPS ou série de prestação.
        Caso não utilize a série, preencha o campo com o valor ‘99’ que indica
        modelo único. Caso queira utilizar o campo série para indicar o número do
        equipamento emissor do RPS deve-se solicitar liberação da prefeitura.
      *)
      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
        SeriePrestacao := '99'
      else if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
        SeriePrestacao := FDQueryV_NFSe.FieldByName('NF_SERIE').AsString
      else
        SeriePrestacao := '1';

      NumeroLote := FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString;

      IdentificacaoRps.Numero := FormatFloat('#########0', FDQueryV_NFSe.FieldByName('RPS').AsInteger);

      IdentificacaoRps.Serie := getIdentificacaoRpsSerie(FDQueryV_NFSe.FieldByName('NF_SERIE').AsString);

      IdentificacaoRps.Tipo := trRPS;


      DataEmissao := Now;
      DataEmissaoRps := Now;
      Competencia := Now;

      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM, proBetha] then
      begin
        (*#15259 - 2023-04-06*)
        if ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM then
          DataEmissaoRps := Now;
        if (ACBrNFSeX1.Configuracoes.Geral.Versao in [ve204]) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proBetha]) then
          Competencia := Now
        else
          Competencia := 0;
      end;

      NaturezaOperacao := StrToNaturezaOperacao(Ok, FDQueryV_NFSe.FieldByName('CODIGO_NATOPE').AsString);


      RegimeEspecialTributacao := getRegimeEspecialTributacao;
 (*????
      OptanteSimplesNacional := TFuncao.Condicao.ifthen(
                                                      TNFSe_Emitente.sSimples_Nacional = DADO_SIM, snSim, snNao
                                                      );

      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
      begin
        if emei then
        begin
          OptanteMEISimei        := snSim;
          OptanteSN              := osnOptanteMEI;
        end
        else
        begin
          OptanteMEISimei        := snNao;
          if OptanteSimplesNacional = snSim then
            OptanteSN := osnOptanteMEEPP
          else
            OptanteSN := osnNaoOptante;
        end;
        RegimeApuracaoSN       := getRegimeApuracaoSN;
        verAplic               := 'Zucchetti - 1.00';
      end
      else
        IncentivadorCultural := TFuncao.Condicao.ifthen(
                              LeParametrizacao(ConexaoTemp, 'NFSE_INCENT_CULTURAL', 0) = 'Sim', snSim, snNao
                              );

      IncentivadorCultural := TFuncao.Condicao.ifthen(
        LeParametrizacao(ConexaoTemp, 'NFSE_INCENT_CULTURAL', 0) = 'Sim', snSim, snNao
      );

      // Provedor Tecnos
      PercentualCargaTributaria := 0;
      ValorCargaTributaria := 0;
      PercentualCargaTributariaMunicipal := 0;
      ValorCargaTributariaMunicipal := 0;
      PercentualCargaTributariaEstadual := 0;
      ValorCargaTributariaEstadual := 0;

      Producao := TFuncao.Condicao.ifThen(
        Configuracoes.WebServices.Ambiente = taProducao, snSim, snNao
      );


      // TnfseStatusRPS = ( srNormal, srCancelado );
      StatusRPS := srNormal;

      // Somente Os provedores Betha, FISSLex e SimplISS permitem incluir no RPS
      // a TAG: OutrasInformacoes os demais essa TAG é gerada e preenchida pelo
      // WebService do provedor.
      OutrasInformacoes          := FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString;
      InformacoesComplementares  := FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString;
      // Usado quando o RPS for substituir outro
      {
       RpsSubstituido.Numero := FormatFloat('#########0', i);
       RpsSubstituido.Serie  := 'UNICA';
       // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
       RpsSubstituido.Tipo   := trRPS;
      }

      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech) then
        Servico.Valores.ValorServicos := FDQueryV_NFSe.FieldByName('TOT_SERVICO').AsCurrency -
          FDQueryV_NFSe.FieldByName('TOT_DESCONTO').AsCurrency
      else
        Servico.Valores.ValorServicos := FDQueryV_NFSe.FieldByName('TOT_SERVICO').AsCurrency;
      Servico.Valores.ValorDeducoes := FDQueryV_NFSe.FieldByName('TOT_DEDUCAO').AsCurrency;
      Servico.Valores.AliquotaPis := FDQueryV_NFSe.FieldByName('ALIQ_PIS').AsCurrency;
      Servico.Valores.ValorPis := FDQueryV_NFSe.FieldByName('TOT_PIS').AsCurrency;
      Servico.Valores.AliquotaCofins := FDQueryV_NFSe.FieldByName('ALIQ_COFINS').AsCurrency;;
      Servico.Valores.ValorCofins := FDQueryV_NFSe.FieldByName('TOT_COFINS').AsCurrency;
      Servico.Valores.ValorInss := FDQueryV_NFSe.FieldByName('TOT_RET_INSS').AsCurrency;
      Servico.Valores.ValorIr := FDQueryV_NFSe.FieldByName('TOT_RET_IRRF').AsCurrency;
      Servico.Valores.ValorCsll := FDQueryV_NFSe.FieldByName('TOT_RET_CSLL').AsCurrency;


      if FDQueryV_NFSe.FieldByName('ISS_RETIDO').AsString = 'S' then
      begin
        Servico.Valores.IssRetido := stRetencao;
        Servico.Valores.ValorIssRetido := FDQueryV_NFSe.FieldByName('TOT_ISS').AsCurrency;
      end
      else
      if FDQueryV_NFSe.FieldByName('ISS_RETIDO').AsString = 'T' then
      begin
        Servico.Valores.IssRetido := stSubstituicao;
        Servico.Valores.ValorIssRetido := FDQueryV_NFSe.FieldByName('TOT_ISS').AsCurrency;
      end
      else
      begin
        Servico.Valores.IssRetido := stNormal;
        Servico.Valores.ValorIssRetido := 0.00;
      end;

      Servico.ExigibilidadeISS := getExigibilidadeISS;

      Servico.Valores.OutrasRetencoes := 0.00;
      Servico.Valores.DescontoIncondicionado := FDQueryV_NFSe.FieldByName('TOT_DESCONTO').AsCurrency;
      Servico.Valores.DescontoCondicionado := 0.00;


      if (Servico.ExigibilidadeISS = exiIsencao) or (StrToBoolDef(TNFSeDados.sBCISS_Zerado,False) = True) then
        Servico.Valores.BaseCalculo := 0
      else
        Servico.Valores.BaseCalculo := Servico.Valores.ValorServicos -
          Servico.Valores.ValorDeducoes - Servico.Valores.DescontoIncondicionado;

      Servico.Valores.Aliquota := FDQueryV_NFSe.FieldByName('ALIQ_ISS').AsCurrency;

      ValorISS := FDQueryV_NFSe.FieldByName('TOT_ISS').AsCurrency;
      Servico.Valores.ValorISS := RoundTo(ValorISS, -2);

      Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
        Servico.Valores.ValorPis - Servico.Valores.ValorCofins -
        Servico.Valores.ValorInss - Servico.Valores.ValorIr -
        Servico.Valores.ValorCsll - Servico.Valores.OutrasRetencoes -
        Servico.Valores.ValorIssRetido - Servico.Valores.DescontoIncondicionado
        - Servico.Valores.DescontoCondicionado;

      if FDQueryV_NFSe.FieldByName('RESPONSAVEL_RETENCAO').AsString = RET_TOMADOR then
        Servico.ResponsavelRetencao := rtTomador
      else
        Servico.ResponsavelRetencao := rtPrestador;

      if ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proWebISS) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSystemPro) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSimplISS) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proPronim) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet)) and //#14273 - Anderson
         not(FDQueryV_NFSe.FieldByName('ISS_RETIDO').AsString = 'S') then
        Servico.ResponsavelRetencao := rtNenhum;


      Servico.ItemListaServico := FDQueryV_NFSe.FieldByName('COD_LST').AsString;
      Servico.CFPS := FDQueryV_NFSe.FieldByName('COD_LST').AsString;

      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSiapSistemas) then
      begin
        QryLSTExtra := TIBQuery.Create(nil);
        try
          QryLSTExtra.Connection := ConexaoTemp;
          QryLSTExtra.Open('select COD_LST_EXTRA '+
            ' from TB_EST_SERVICO_SIS '+
            ' where COD_LST = '+QuotedStr(TNFSeDados.sListaServ)
          );
          LSTExtra := QryLSTExtra.FieldByName('COD_LST_EXTRA').AsString;

          Servico.ItemListaServico := TNFSeDados.sListaServ;
          if not(LSTExtra = '') then
            Servico.ItemListaServico := Servico.ItemListaServico+'.'+LSTExtra;

        finally
          QryLSTExtra.Free;
        end;
      end;
	    Servico.CodigoCnae := GetCodigoCNAE;

      Servico.CodigoTributacaoMunicipio := getCodigoTributacaoMunicipio;
      Servico.Discriminacao := GetItemDiscriminacao();

      Servico.CodigoMunicipio := GetCodigoMunicipioServico;

      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSDSF) then
        Servico.Tributacao := GetTributacaoISS;

      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proCoplan) then
      begin
        if Servico.ExigibilidadeISS = exiExportacao then
          Tomador.Endereco.CodigoPais := PAIS_PADRAO_CODIGO;
      end
      else if (((ACBrNFSeX1.Configuracoes.Geral.Provedor = proPronim)and (ACBrNFSeX1.Configuracoes.Geral.Versao = ve202)) or
             ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proTiplan) and (ACBrNFSeX1.Configuracoes.Geral.Versao = ve202)) or
             (ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech)) then
      else
        Servico.CodigoPais := PAIS_PADRAO_CODIGO;

      if FDQueryV_NFSe.FieldByName('incidencia_iss').AsString = 'T' then
      begin
        if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania then
          Servico.MunicipioIncidencia := StrToIntDef(GetCidade_Goiania(FDQueryCliente.FieldByName('ID_CIDADE').AsString),0)
        else
          Servico.MunicipioIncidencia := StrToIntDef(FDQueryCliente.FieldByName('ID_CIDADE').AsString, 0);
      end else
      begin
        if ACBrNFSeX1.Configuracoes.Geral.Provedor = ProissGoiania then
          Servico.MunicipioIncidencia := StrToIntDef(GetCidade_Goiania(TNFSe_Emitente.iid_Cidade),0)
        else
          Servico.MunicipioIncidencia := StrToIntDef(TNFSe_Emitente.iid_Cidade, 0);
      end;

      cSomaRet_INSS := 0;
      cSomaRet_IRRF := 0;
      cSomaRet_COFINS := 0;
      cSomaRet_PIS := 0;
      cSomaRet_CSLL := 0;

      FDQueryV_NFSeItem.First;
      while not(FDQueryV_NFSeItem.Eof) do
      begin
        with Servico.ItemServico.New do
        begin
          TipoUnidade := tuQtde;
          if ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM then
          begin
            CodCNO := FDQueryV_NFSeItem.FieldByName('CNO').AsString;
            SituacaoTributaria := FDQueryV_NFSe.FieldByName('EXIGIBILIDADE').AsInteger;
            TipoUnidade := tuHora;
          end;
          Descricao := FDQueryV_NFSeItem.FieldByName('PRODUTO').AsString;
          if not(FDQueryV_NFSeItem.FieldByName('OBSERVACAO').AsString = '') then
            ObservacaoItem := ' ('+FDQueryV_NFSeItem.FieldByName('OBSERVACAO').AsString+')';

          if ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech then
            Descricao := Copy(Descricao+'  '+ObservacaoItem, 0, 20)
          else
            Descricao := Descricao+'  '+ObservacaoItem;


          ItemListaServico := FDQueryV_NFSe.FieldByName('COD_LST').AsString;

          CodigoCnae := FDQueryV_NFSeItem.FieldByName('CNAE').AsString;

          if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proSoftPlan] then
            CodServ := FDQueryV_NFSeItem.FieldByName('CST').AsString
          else
            CodServ := FDQueryV_NFSe.FieldByName('COD_TRIBUTACAO').AsString;


          if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEL] then
            codLCServ := FDQueryV_NFSe.FieldByName('COD_TRIBUTACAO').AsString
          else
          if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
            codLCServ := TFuncao.Numero.SoNumero(FDQueryV_NFSe.FieldByName('COD_LST').AsString);

          Unidade := 'UN';
          Quantidade := FDQueryV_NFSeItem.FieldByName('QTD_ITEM').AsCurrency;

          {#9405}
          CodMunPrestacao := GetCodigoMunicipioServico;

          if not(Quantidade = 0) then
            ValorUnitario := RoundTo(FDQueryV_NFSeItem.FieldByName('VLR_TOTAL').AsCurrency / Quantidade, -2)
          else
            ValorUnitario := FDQueryV_NFSeItem.FieldByName('VLR_TOTAL').AsCurrency;

          ValorTotal := Quantidade * ValorUnitario;

          if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEloTech]) and
            (FDQueryV_NFSeItem.FieldByName('VLR_DESC').AsCurrency > 0) then
          begin
            DescontoCondicionado := FDQueryV_NFSeItem.FieldByName('VLR_DESC').AsCurrency;
            ValorTotal := (Quantidade * ValorUnitario) - DescontoCondicionado;
          end;

          if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proBetha]) and
            (FDQueryV_NFSeItem.FieldByName('VLR_DESC').AsCurrency > 0) then
          begin
            DescontoIncondicionado := FDQueryV_NFSeItem.FieldByName('VLR_DESC').AsCurrency;
            ValorTotal := (Quantidade * ValorUnitario) - DescontoCondicionado;
          end;

          if (Servico.ExigibilidadeISS = exiIsencao) or (StrToBoolDef(TNFSeDados.sBCISS_Zerado,False) = True) then
            BaseCalculo := 0
          else
            BaseCalculo := ValorTotal - ValorDeducoes - DescontoIncondicionado;

          Aliquota := FDQueryV_NFSeItem.FieldByName('ALIQ_ISS').AsCurrency;

          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM)  and  (Servico.Tributacao in [ttImune,ttIsentaISS] ) then
            ValorISS := 0
          else
            ValorISS := FDQueryV_NFSeItem.FieldByName('VLR_ISS').AsCurrency;

          AliqISSST := 0;
          ValorISSST := 0;

          //#13840 - Anderson
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
             (FDQueryV_NFSe.FieldByName('TOT_RET_CSLL').AsCurrency > 0) then
          begin
            ValorBCCSLL := ValorTotal;
            AliqRetCSLL := FDQueryV_NFSe.FieldByName('ALIQ_CSLL').AsCurrency;
            ValorCSLL := getVlr_RetencaoItem(cSomaRet_CSLL, ValorTotal, FDQueryV_NFSe.FieldByName('TOT_RET_CSLL').AsCurrency)
          end
          else
          begin
            ValorBCCSLL := 0;
            AliqRetCSLL := 0;
            ValorCSLL := 0;
          end;

          //#13840 - Anderson
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
             (FDQueryV_NFSe.FieldByName('TOT_PIS').AsCurrency > 0) then
          begin
            ValorBCPIS := ValorTotal;
            AliqRetPIS := FDQueryV_NFSe.FieldByName('ALIQ_PIS').AsCurrency;
            ValorPIS := getVlr_RetencaoItem(cSomaRet_PIS, ValorTotal, FDQueryV_NFSe.FieldByName('TOT_PIS').AsCurrency)
          end
          else
          begin
            ValorBCPIS := 0;
            AliqRetPIS := 0;
            ValorPIS := 0;
          end;

          //#13840 - Anderson
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
             (FDQueryV_NFSe.FieldByName('TOT_COFINS').AsCurrency > 0) then
          begin
            ValorBCCOFINS := ValorTotal;
            AliqRetCOFINS := FDQueryV_NFSe.FieldByName('ALIQ_COFINS').AsCurrency;
            ValorCOFINS := getVlr_RetencaoItem(cSomaRet_COFINS, ValorTotal, FDQueryV_NFSe.FieldByName('TOT_COFINS').AsCurrency)
          end
          else
          begin
            ValorBCCOFINS := 0;
            AliqRetCOFINS := 0;
            ValorCOFINS := 0;
          end;

          //#13840 - Anderson
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
             (FDQueryV_NFSe.FieldByName('TOT_RET_INSS').AsCurrency > 0) then
          begin
            ValorBCINSS := ValorTotal;
            AliqRetINSS := FDQueryV_NFSe.FieldByName('ALIQ_INSS').AsCurrency;
            ValorINSS := getVlr_RetencaoItem(cSomaRet_INSS, ValorTotal, FDQueryV_NFSe.FieldByName('TOT_RET_INSS').AsCurrency)
          end
          else
          begin
            ValorBCINSS := 0;
            AliqRetINSS := 0;
            ValorINSS := 0;
          end;

          //#13840 - Anderson
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
             (FDQueryV_NFSe.FieldByName('TOT_RET_IRRF').AsCurrency > 0) then
          begin
            ValorBCRetIRRF := ValorTotal;
            AliqRetIRRF := FDQueryV_NFSe.FieldByName('ALIQ_IRRF').AsCurrency;
            ValorIRRF := getVlr_RetencaoItem(cSomaRet_IRRF, ValorTotal, FDQueryV_NFSe.FieldByName('TOT_RET_IRRF').AsCurrency)
          end
          else
          begin
            ValorBCRetIRRF := 0;
            AliqRetIRRF := 0;
            ValorIRRF := 0;
          end;


          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and
             (FDQueryV_NFSe.FieldByName('TOT_DEDUCAO').AsCurrency > 0) then
            ValorDeducoes := FDQueryV_NFSe.FieldByName('TOT_DEDUCAO').AsCurrency
          else
            ValorDeducoes := 0;

          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and
             (FDQueryV_NFSe.FieldByName('ISS_RETIDO').AsString = 'S') and
             (FDQueryV_NFSe.FieldByName('TOT_ISS').AsCurrency > 0) then
            ValorISSRetido := FDQueryV_NFSe.FieldByName('TOT_ISS').AsCurrency
          else
            ValorISSRetido := 0;

          // CPRO-1390 - Sergio - 09/07/24
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and
            (FDQueryV_NFSe.FieldByName('incidencia_iss').AsString = 'P') then
            TribMunPrestador:= snSim
          else
            TribMunPrestador:= snNao;

          if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEloTech, proISSDSF] then
            Tributavel := ProdutoTributavel;

          // CPRO-440 Sergio - 27/02/24
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) then
            ValorTributavel:= ValorUnitario * Quantidade;
        end;

        FDQueryV_NFSeItem.Next;
      end;

      if (Trim(FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString) <> '') then
      begin
        if LeParametrizacao(Conexao, 'NFSE_ADD_OBS_ITEM') = DADO_SIM then
          Servico.Discriminacao := Servico.Discriminacao + '| ' + TFuncao.Texto.Converte_Caractere(FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString) + '|';
      end;

      if ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1 then
      begin
        Servico.Valores.tribMun.tribISSQN := tiOperacaoTributavel;
        Servico.Valores.tribMun.cPaisResult := 0;

        Servico.Valores.tribFed.CST := cst01;


        if (FDQueryV_NFSe.FieldByName('ALIQ_PIS').AsCurrency > 0) or
          (FDQueryV_NFSe.FieldByName('ALIQ_COFINS').AsCurrency > 0) Then
        begin
          Servico.Valores.tribFed.vBCPisCofins := Servico.Valores.ValorLiquidoNfse;

          Servico.Valores.tribFed.pAliqPis := FDQueryV_NFSe.FieldByName('ALIQ_PIS').AsCurrency;
          Servico.Valores.tribFed.pAliqCofins := FDQueryV_NFSe.FieldByName('ALIQ_COFINS').AsCurrency;

          if (Servico.Valores.tribFed.vBCPisCofins > 0) then
          begin
          if Servico.Valores.tribFed.pAliqPis > 0 then
            Servico.Valores.tribFed.vPis := Servico.Valores.tribFed.vBCPisCofins *
                                           Servico.Valores.tribFed.pAliqPis / 100;

            if Servico.Valores.tribFed.pAliqCofins > 0 then
              Servico.Valores.tribFed.vCofins := Servico.Valores.tribFed.vBCPisCofins *
                                        Servico.Valores.tribFed.pAliqCofins / 100;
          end;
        end;
        Servico.Valores.tribFed.tpRetPisCofins := trpcNaoRetido;

        Servico.Valores.totTrib.vTotTribFed := Servico.Valores.tribFed.vPis;
        Servico.Valores.totTrib.vTotTribEst := 0;
        Servico.Valores.totTrib.vTotTribMun := Servico.Valores.tribFed.vCofins;
      end;

      Prestador.IdentificacaoPrestador.CNPJ := TFuncao.Numero.SoNumero(
        TNFSe_Emitente.sCNPJ
      );
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSDSF then
        Prestador.IdentificacaoPrestador.InscricaoMunicipal := LimpaNumero(TNFSe_Emitente.sInscricao_Municipal)
      else
        Prestador.IdentificacaoPrestador.InscricaoMunicipal := TNFSe_Emitente.sInscricao_Municipal;

      if not (ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional) then
      begin
        Prestador.RazaoSocial  := TFuncao.Texto.ConverteAcentos(TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sRazao_Social));
        Prestador.NomeFantasia := TFuncao.Texto.ConverteAcentos(TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sNome_Fantasia));
      end;
      // Para o provedor ISSDigital deve-se informar também:
      Prestador.cUF := UFtoCUF(TNFSe_Emitente.sUF);

      Prestador.Endereco.Endereco := TFuncao.Texto.ConverteAcentos(TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sEnd_Logradouro));
      Prestador.Endereco.Numero := TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sEnd_Numero);
      Prestador.Endereco.Bairro := TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sEnd_Bairro);
      Prestador.Endereco.CodigoMunicipio := TNFSe_Emitente.iid_Cidade;
      Prestador.Endereco.xMunicipio := TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.cidade);
      Prestador.Endereco.UF := TNFSe_Emitente.sUF;
      Prestador.Endereco.CEP := getCepPrestador;
      Prestador.Contato.Telefone := getTelefonePrestador;
      if not (ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech) then
      begin
        Prestador.Endereco.CodigoPais := PAIS_PADRAO_CODIGO;
        Prestador.Endereco.xPais := 'BRASIL';
      end;
      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proGoverna, proInfisc] then
        Prestador.Endereco.CEP := LimpaNumero(TNFSe_Emitente.sEnd_Cep);

      Prestador.Contato.Email := TNFSe_Emitente.sEmail;


      // Para o provedor IPM usar os valores:
      // tpPFNaoIdentificada ou tpPF para pessoa Fisica
      // tpPJdoMunicipio ou tpPJforaMunicipio ou tpPJforaPais para pessoa Juridica

      // Para o provedor SigISS usar os valores acima de forma adquada

      {#9405}
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM then
        Tomador.IdentificacaoTomador.Tipo := getTipoCliente(FDQueryCliente.FieldByName('CPF_CNPJ').AsString);

      Tomador.IdentificacaoTomador.CpfCnpj := TFuncao.Numero.SoNumero(
        FDQueryCliente.FieldByName('CPF_CNPJ').AsString
      );
      Tomador.IdentificacaoTomador.InscricaoMunicipal := FDQueryCliente.FieldByName('INSC_MUNIC').AsString;
      Tomador.RazaoSocial := TFuncao.Texto.ConverteAcentos(
                            TFuncao.Texto.Converte_Caractere(
                            ConverteEComercial(FDQueryCliente.FieldByName('NOME').AsString)));
      //#17107 - Sergio - 18/08/23
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proTecnos then
        Tomador.RazaoSocial:= StringReplace(Tomador.RazaoSocial, '&amp;', 'E', []);
      Tomador.Endereco.TipoLogradouro := UpperCase(TFuncao.Texto.Converte_Caractere(FDQueryCliente.FieldByName('END_TIPO').AsString));
      Tomador.Endereco.Endereco := TFuncao.Texto.ConverteAcentos(TFuncao.Texto.Converte_Caractere(FDQueryCliente.FieldByName('END_LOGRAD').AsString));
      Tomador.Endereco.Numero := FDQueryCliente.FieldByName('END_NUMERO').AsString;
      //#17107 - Sergio - 18/08/23
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proTecnos then
      begin
        Tomador.Endereco.Numero := TFuncao.Numero.SoNumero(Tomador.Endereco.Numero);
        if Tomador.Endereco.Numero = EmptyStr then
          Tomador.Endereco.Numero := '0';
      end;

      Tomador.Endereco.Complemento := TFuncao.Texto.Converte_Caractere(FDQueryCliente.FieldByName('END_COMPLE').AsString);
      Tomador.Endereco.TipoBairro := 'BAIRRO';
      Tomador.Endereco.Bairro := TFuncao.Texto.Converte_Caractere(FDQueryCliente.FieldByName('END_BAIRRO').AsString);
      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania then
        Tomador.Endereco.CodigoMunicipio :=  GetCidade_Goiania(FDQueryCliente.FieldByName('ID_CIDADE').AsString)
      else
        Tomador.Endereco.CodigoMunicipio := FDQueryCliente.FieldByName('ID_CIDADE').AsString;
      if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proSoftPlan then
        Tomador.Endereco.xMunicipio := FDQueryCliente.FieldByName('CIDADE').AsString;
      Tomador.Endereco.UF := FDQueryCliente.FieldByName('UF').AsString;
      // Para alguns provedores não devemos informar o código do país.
      Tomador.Endereco.CEP := getCepTomador;
      if not (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proPronim, proFiorilli,proTiplan, proEloTech]) then
        Tomador.Endereco.CodigoPais    := PAIS_PADRAO_CODIGO;
      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSJoinville] then
        Tomador.Endereco.CodigoPais := 076;

      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
      begin
        Prestador.Contato.Telefone := TFuncao.Numero.SoNumero(Prestador.Contato.Telefone);
      end;

      // Provedor Equiplano é obrigatório o pais e Insc. Est.
      Tomador.Endereco.xPais := FDQueryCliente.FieldByName('NOME_PAIS').AsString;

      Tomador.Contato.Telefone := getTelefoneCliente;
      Tomador.Contato.Email := getEmailCliente;
      Tomador.AtualizaTomador := snNao;
      Tomador.TomadorExterior := snNao;

      // Condição de Pagamento usado pelo provedor Betha versão 1 do Layout da ABRASF
      //CondicaoPagamento.QtdParcela := 1;
      //CondicaoPagamento.Condicao   := cpAPrazo;
      //CondicaoPagamento.Condicao   := cpAVista;
      {2022-05-11 - #9684 - Ficha 12332 - Necessario passar esse tipo de Condicao, pois provedor IPM 1.00 estava exigindo parcelas, porem
                                          o servidor aceita apenas uma forma de pagamento e no sistema temos multiplas - Renan}
      CondicaoPagamento.Condicao   := cpNaApresentacao;

      //for i := 1 to CondicaoPagamento.QtdParcela do
      //begin
      //  with CondicaoPagamento.Parcelas.New do
      //  begin
      //    Parcela := i;
      //    DataVencimento := Date + (30 * i);
      //    Valor := (Servico.Valores.ValorLiquidoNfse / CondicaoPagamento.QtdParcela);
      //  end;
      //end;


      ConstrucaoCivil.CodigoObra     := FDQueryV_NFSe.FieldByName('CODIGO_OBRA').AssTRING;
      ConstrucaoCivil.Art            := FDQueryV_NFSe.FieldByName('ART').AsString;
*)
    end;
  end;
end;

procedure TDataModuleNFSeX.AtualizaPathXML;
begin
(*???
  FPathLocalExe := ExtractFilePath(Application.ExeName);

  {2022-06-27 - #10376 - Ficha 11741 - definir pasta para salvar XML - Renan}
  FPathXMLs := TFuncao.Geral.CaminhoXML;

  FPathLogNFSe := FPathXMLs + 'logNFSe\NFSe';
  FPathGeral := FPathXMLs + 'logNFSe\Geral';
*)
end;

function TDataModuleNFSeX.AutorizaNFSe(AID_NFVenda, metodoEnvio: Integer;
eThread : boolean = False; Emei : Boolean = False) : boolean;
var
  i: Integer;
  sErro_Schema,
  Token: string;
begin
  result := False;
  FID_NFVenda := AID_NFVenda;
  sErro_Schema := EmptyStr;

  (*criei essa verificacao para conseguirmos pular o processo de autorizacao de NFSe em alguma situacao que precise simular os processos realizados apos a autorizacao
    usar apenas para testes internos*)
  var arqBloqLocal: TArqBloqLocal := TFuncao.Sistema.retornaDadosArqArtificio;
  if arqBloqLocal.testesNfseIgnoraTransmissao = DADO_SIM then
  begin
    TVar_Dados_novo.Protocolo := 'TESTE DADOS MOCK';
    TVar_Dados_novo.Situacao := '4';
    TVar_Dados_novo.Mensagem := 'Processado com sucesso';
    TVar_Dados_novo.Nfse_Numero := intToStr(AID_NFVenda);
    TVar_Dados_novo.CodVerificacao := '';
    TVar_Dados_novo.Link_Nfse := '';
    exit(True);
  end;

  if not(ConfigurarComponente(metodoEnvio)) then
    exit(false);

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proSoftPlan] then
    ACBrNFSeX1.GerarToken;
  tentativasConsultaLote := 0;
  AlimentaNFSe(AID_NFVenda, Emei);

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSoftPlan then
    ACBrNFSeX1.GerarToken;

  try
    if (metodoEnvio = 2) or (ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1) then
    begin
      ACBrNFSeX1.Emitir(FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString, meUnitario, False);
    end
    else
    begin
      Try
        ACBrNFSeX1.Emitir(FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString, getTipoEnvio(metodoEnvio), False);
      Except
        on e:Exception do
        begin
          if eThread then
            TVar_Dados_novo.Mensagem := e.Message
          else
            TFuncao.Mensagens.MensagemAlerta('Confira se os dados de envio estão corretos: ' +e.Message);
        end;
      End;
      if ACBrNFSeX1.NotasFiscais.Items[0].Confirmada then
      begin
        Result := True;
        ACBrNFSeX1.NotasFiscais.Items[0].NFSe.OutrasInformacoes := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.OutrasInformacoes+#13+
                                                                   FDQueryV_NFSe.FieldByName('OBSERVACAO').AsString;

        if not (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSGoiania, proInfisc]) then
        begin
          ACBrNFSeX1.NotasFiscais.Items[0].ImprimirPDF;
        end;
      end
      else
      begin
        //#13840 - Anderson >> quando dá erro na validação do Schema
        if ACBrNFSeX1.WebService.Emite.Erros.Count > 0 then
        begin
          for I := 0 to pred(ACBrNFSeX1.WebService.Emite.Erros.Count) do
          begin
            sErro_Schema := sErro_Schema + ACBrNFSeX1.WebService.Emite.Erros[i].Codigo + ' ' +
                           StringReplace(ACBrNFSeX1.WebService.Emite.Erros[i].Descricao,'Lista de NFSe não encontrada! (ListaNfse)','',[]) + sLineBreak;
          end;
          if not(eThread) then
          if (Trim(StringReplace(sErro_Schema,'Lista de NFSe não encontrada! (ListaNfse)','',[])) <> EmptyStr) and
             (Length(Trim(StringReplace(sErro_Schema,'Lista de NFSe não encontrada! (ListaNfse)','',[]))) > 10) then //Menor que 10 é somente códigos.
          begin
            if not bEnvioAuto then
              MensagemAlerta(Trim(sErro_Schema));
          end
          else
            fGrava_Retorno(IntToStr(AID_NFVenda),'','3',sErro_Schema,'','')
        end;
      end;
    end;
  finally
    if (frmStatus <> nil) then
      FreeAndNil(frmStatus);
  end;
  if TNFSeDados.sImprime_Danfse = 'S' then
  begin
    ACBrNFSeX1.DANFSE.MostraPreview  := False;
    ACBrNFSeX1.DANFSE.NumCopias := TNFSeDados.iNum_Copias;
  end;

//  if not bEnvioAuto then
//  begin
    if metodoEnvio = 2 then
      ChecarResposta(tmGerar, AID_NFVenda)
    else
      ChecarResposta(tmRecepcionar, AID_NFVenda);
//  end;

  if (TVar_Dados_novo.Mensagem = EmptyStr) and
     (Trim(sErro_Schema) <> EmptyStr) then
    TVar_Dados_novo.Mensagem := Trim(sErro_Schema);

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in[ proEquiplano,
      proIPM,
      proEL,
      proSimplISS,
      proNFSeBrasil,
      proTinus,
      proSmarAPD]) and
     (TVar_Dados_novo.Protocolo <> '') then
  begin
    envioNFSe := true;
    while ((pos('Lote aguardando processamento', TVar_Dados_novo.mensagemCompleta) > 0) and (tentativasConsultaLote <= 2)) or
          ((pos('ainda não processado', TVar_Dados_novo.mensagemCompleta) > 0) and (tentativasConsultaLote <= 2)) or
          ((tentativasConsultaLote = 0) and (TVar_Dados_novo.Situacao <> SIT_Sucesso)) do
    begin
      if (frmStatus = nil) then
        frmStatus := TfrmStatus.Create(Application);
      frmStatus.lblStatus.Caption := 'Aguardando resposta do servidor...';
      frmStatus.Show;
      frmStatus.BringToFront;
      Application.ProcessMessages;

      sleep(4500);
      frmStatus.Hide;
      FreeAndNil(frmStatus);
      ConsultaLote(TVar_Dados_novo.Protocolo, FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString);
      tentativasConsultaLote := tentativasConsultaLote + 1;
      if (TVar_Dados_novo.Situacao = SIT_Sucesso) and (TVar_Dados_novo.Nfse_Numero <> '') then
      begin
        if not StrToBoolDef(TNFSeDados.impPrefeitura,false) then
          ACBrNFSeX1.NotasFiscais.Items[0].ImprimirPDF;
      end;

    end;
  end;
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM]) and (tentativasConsultaLote = 0) then
  begin
    // CPRO-805 - Sergio - cod verificacao no lugar do protocolo ocorre erro no webservice ao consultar
    if Length(TVar_Dados_novo.Protocolo) < 40 then
      ConsultaLote(TVar_Dados_novo.Protocolo, FDQueryV_NFSe.FieldByName('NUM_LOTE').AsString);
  end;
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSJoinville, proABase, proSigep, proPronim, proTecnos,proGoverna]) or
     ((ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF]) and (TVar_Dados_novo.Situacao = SIT_Sucesso))  then
  begin
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proTecnos]) and (TVar_Dados_novo.Protocolo = '')  then
      exit;
    sleep(3500);
    var NumeroRps: String;
    NumeroRps := TFuncao.Condicao.ifthen(ACBrNFSeX1.Configuracoes.Geral.Provedor in [proPronim,proTecnos],
                                         ACBrNFSeX1.NotasFiscais.Items[0].NFSe.IdentificacaoRps.Numero,
                                         ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero);
    ConsultaNFSeRPS(NumeroRps,
                    FDQueryV_NFSe.FieldByName('NF_SERIE').AsString,
                    TVar_Dados_novo.Protocolo,
                    DADO_SIM,
                    AID_NFVenda);
  end;
  if TVar_Dados_novo.Situacao = '4' then
    Result := True;

end;

procedure TDataModuleNFSeX.Cancelar(aID_NFVenda: Integer; NumNFSe, Codigo, Motivo,
  NumLote, CodVerif, SerNFSe, NumRps, ValNFSe, dataEmissao: string);
var
  varNumNFSe,
  varCodigo,
  varMotivo,
  varNumLote,
  varCodVerif,
  varSerNFSe,
  varserRPS,
  varNumRps,
  varValNFSe,
  varChNFSe,
  RPSFile,
  CancelFile: String;

  CodCanc, OldTimeOut: integer;
  InfCancelamento: TInfCancelamento;

  ArqCancelamento: TStringList;
  FdataEmissao : TDate;
  InfEvento: TInfEvento;
  function SetCancelamentoPublicSoft: Boolean;
  begin
    if not(ACBrNFSeX1.Configuracoes.Geral.Provedor = proPublicSoft) then
      Exit(False);

    CancelFile := FPathXMLs+'LogNFSe\NFSe\Notas\'+NumNFSe+'-nfse.xml';

    if not(FileExists(CancelFile)) then
      raise Exception.Create('Nota fiscal não encontrada para cancelamento.');

    ConsultaNFSeRPS(NumRps, SerNFSe, '');

    ArqCancelamento := TStringList.Create;
    try
      ArqCancelamento.LoadFromFile(CancelFile);

      if pos('<Status>2</Status>', ArqCancelamento.Text) = 0 then
        raise Exception.Create(
          'Serviço de cancelamento não disponível para este provedor.'+#13+
          'É necessário cancelar o documento na prefeitura, em seguida cancelar '+
          'no sistema.'
        );

      TVar_Dados_novo.Mensagem := 'Nota cancelada';
      TVar_Dados_novo.Situacao := SIT_Sucesso;
      Exit(True);
    finally
      ArqCancelamento.Free;
    end;
  end;

begin
  // Codigo de Cancelamento
  // 1 - Erro de emissão
  // 2 - Serviço não concluido
  // 3 - RPS Cancelado na Emissão

  varNumNFSe  := '';
  varCodigo   := '';
  varMotivo   := '';
  varNumLote  := '';
  varCodVerif := '';
  varSerNFSe  := '';
  varNumRps   := '';
  varValNFSe  := '';
  varChNFSe   := '';
  varserRPS   := '';
  try
    FdataEmissao := StrToDate(dataEmissao);
  except
  end;

  ConfigurarComponente(TVar_Dados_novo.TipoEnvio);

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSoftPlan then
    ACBrNFSeX1.GerarToken;

  if SetCancelamentoPublicSoft() then
    Exit();

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPublicSoft then
  begin
    OldTimeOut := ACBrNFSeX1.Configuracoes.WebServices.TimeOut;
    ACBrNFSeX1.Configuracoes.WebServices.TimeOut := 30000;
  end;


  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSJoinville then
  begin
    if (NumNFSe = '0') then
    begin
      MessageDlg(
        'Antes de cancelar a NFSe é necessário efetuar a consulta da mesma.'+#13+
        'Em seguida efetue o cancelamento.', mtWarning, [mbOk], 0
      );
      Abort;
    end;
  end;

  varCodigo := Codigo;


  if ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
  (ACBrNFSeX1.Configuracoes.Geral.Versao in [ve100,ve101])) then
  begin
    RPSFile := FPathXMLs + 'logNFSe\Geral\Recibos\'+NumNFSe+SerNFSe+'-rps.xml';

    if not(FilesExists(RPSFile)) then
      raise Exception.Create('Não foi possível localizar o arquivo de recibo de RPS.');

    ACBrNFSeX1.NotasFiscais.LoadFromFile(RPSFile, False);

    varChNFSe := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.refNF;
  end
  else
  begin
    varNumNFSe := NumNFSe;
    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proWebFisco, proSimple,
      proFGMaiss, proiiBrasil, proIPM] then
    begin
      varSerNFSe := SerNFSe;
    end;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proConam then
    begin
      varSerNFSe  := SerNFSe;
      varNumRps   := NumRps;
      varSerRps   := '1';
      varValNFSe  := ValNFSe;
    end;

    (*#14952 - 203-05-23*)
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech then
    begin
      if (TNFSe_Emitente.iid_Cidade = Ponta_Grossa) then
        ACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar := False;

      varSerNFSe := SerNFSe;

      var PathXML : String := '';

      ACBrNFSeX1.NotasFiscais.Clear;
      if FilesExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(varNumNFSe) + varSerNFSe+'-nfse.xml') then
        PathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(varNumNFSe) + varSerNFSe+'-nfse.xml'
      else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+varSerNFSe+'-nfse.xml') then
        PathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+varSerNFSe+'-nfse.xml'
      else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+'00000-nfse.xml') then
        PathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+'00000-nfse.xml'
      else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+'1-nfse.xml') then
        PathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+varNumNFSe+'1-nfse.xml'
      else
        PathXML := FPathXMLs +'logNFSe\NFSe\Notas\'+LimpaNumero(varNumNFSe)+'-nfse.xml';

      ACBrNFSeX1.NotasFiscais.LoadFromFile(PathXML, False);

      varChNFSe  := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.ChaveAcesso;
      varNumLote := NumLote;
      varNumRps  := NumRps;
      varSerRps  := '1';
      varValNFSe := ValNFSe;
    end;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep then
  begin
    CodCanc := StrToIntDef(Codigo, 1);

    case CodCanc of
      1: varCodigo := 'EE';
      2: varCodigo := 'ED';
      3: varCodigo := 'OU';
      4: varCodigo := 'SB';
    end;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPronim then
  begin
    if ACBrNFSeX1.Configuracoes.Geral.Versao = ve202 then
      varCodigo := '2'
    else
    begin
      CodCanc := StrToIntDef(Codigo, 1);
      case CodCanc of
        1: varCodigo := 'CE37';
      end;
    end;
  end;


  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAgili, proAssessorPublico,
    proConam, proEquiplano, proGoverna, proIPM, proISSDSF, proISSLencois,
    proModernizacaoPublica, proPublica, proSiat, proSigISS, proSigep,
    proSmarAPD, proWebFisco, proTecnos, proSudoeste, proSimple,
    proFGMaiss, proEloTech, proSoftPlan] then
  begin
    varMotivo := motivo;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico then
  begin
    varNumLote := NumLote;

    //#13898 - Anderson
    varNumRps := NumRps;
    ACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar := False; //sempre vai retornar "não encontrada" e o correto para esse provedor é ConsultarLote
  end;

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proissLencois, proGoverna,
      proSiat, proSigep, proElotech, proPadraoNacional,
      proSoftPlan]) or
    ((ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc]) and (ACBrNFSeX1.Configuracoes.Geral.Versao in [ve100,ve101])) then
    varCodVerif := CodVerif;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
  begin
    InfEvento := TInfEvento.Create;
    try
      with InfEvento.pedRegEvento do
      begin
        tpAmb := ACBrNFSeX1.Configuracoes.WebServices.AmbienteCodigo;
        verAplic := 'Zucchetti-1.0';
        dhEvento := Now;
        chNFSe := varCodVerif;
        nPedRegEvento := 1;
        tpEvento := ACBrNFSeXConversao.teCancelamento;
        cMotivo := StrToIntDef(codigo, 1);
        xMotivo := Motivo;
      end;

      ACBrNFSeX1.EnviarEvento(InfEvento);
    finally
      InfEvento.Free;
    end;

    ChecarResposta(tmEnviarEvento,FID_NFVenda);
    exit;
  end;

  InfCancelamento := TInfCancelamento.Create;
  try
    with InfCancelamento do
    begin
      NumeroNFSe      := varNumNFSe;
      SerieNFSe       := varSerNFSe;
      ChaveNFSe       := varChNFSe;
      CodCancelamento := varCodigo;
      MotCancelamento := varMotivo;
      NumeroLote      := varNumLote;
      NumeroRps       := StrToIntDef(varNumRps, 0);
      SerieRps        := varSerRps;
      ValorNFSe       := StrToFloatDef(varValNFSe, 0);
      CodVerificacao  := varCodVerif;
      DataEmissaoNFSe := FdataEmissao;
    end;

    //#17859 - Anderson
    //no caso da prestação ser em outro município, no cancelamento devo informar o cód. IBGE desse município
    //no XML esse código é gerado a partir do cód. IBGE setado no ACbr
    //tem que fazer GAMBI pra contornar ACbr, pois ao mudar o cód. IBGE ele se configura para o provedor do nomo município
    //no meu caso eu preciso mudar pra gerar no XML mas mantendo o provedor do município do emissor
    //combino as alterações abaixo + o evento StatusChange para conseguir isso
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSIntel then
    begin
      Carrega_NFSe(aID_NFVenda);
      if GetCodigoMunicipioServico <> TNFSe_Emitente.iid_Cidade then
      begin
        //coloquei o try para não dar erro ao fazer a NFS-e para um município
        //que não tem provedor no ACBr, só esconder o erro o restante do processo faz certinho
        try
          ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToIntDef(GetCodigoMunicipioServico, 0); //município da prestação
        except
        end;
        ACBrNFSeX1.Configuracoes.Geral.Provedor := proISSIntel; //mantém o provedor do município do emissor
        ACBrNFSeX1.SetProvider; //ajusta provider para o município do emissor
        ACBrNFSeX1.Provider.ConfigSchemas.Validar := False; //não validar o Schema
      end;
    end;

    ACBrNFSeX1.CancelarNFSe(InfCancelamento);
  finally
    //#17859 - Anderson >> garante que fica provedor+município correto
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSIntel) and
       (ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio <> StrToIntDef(TNFSe_Emitente.iid_Cidade, 0)) then
      ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToIntDef(TNFSe_Emitente.iid_Cidade, 0);

    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPublicSoft then
      ACBrNFSeX1.Configuracoes.WebServices.TimeOut := OldTimeOut;

    InfCancelamento.Free;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
  begin
    CancelFile := FPathXMLs +
      'LogNFSe\Geral\Recibos\Can\'+
      FormatFloat('000000000', StrToInt(NumNFSe))+'-can.xml';
    if FileExists(CancelFile) then
    begin
      ArqCancelamento := TStringList.Create;
      try
        ArqCancelamento.LoadFromFile(CancelFile);
        if (pos('<sit>100</sit>', ArqCancelamento.Text) > 0) or
           (pos('estar cancelada', ArqCancelamento.Text) > 0) then
        begin
          TVar_Dados_novo.Mensagem := 'Nota cancelada';
          TVar_Dados_novo.Situacao := SIT_Sucesso;
          Exit();
        end;
      finally
        ArqCancelamento.Free;
      end;
    end;
  end;
  ChecarResposta(tmCancelarNFSe, FID_NFVenda);
end;

procedure TDataModuleNFSeX.CarregaInfManual(AIEProdutorRural : string);
var
  NFSe: TNFSe;
  qryInfoManual,
  qryitem : TIBQuery;
  sISSRetido,
  Busca : String;
  Acontador : Integer;
begin
  qryInfoManual := CriaSQLQuery(nil, ConexaoTemp);
  try
    NFSe := ACBrNFSeX1.NotasFiscais.Items[0].NFSe;
    sISSRetido := EmptyStr;

    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proPadraoNacional]) then
      Busca := ' v.protocolo '
    else
      Busca := ' v.nfs_numero ';

    qryInfoManual.SQL.Clear;
    qryInfoManual.SQL.Text := 'select first 1 v.cliente, v.ID_NFVENDA, v.rps, v.observacao, '+sLineBreak+
                       'v.id_cidade as municipio_prestador, v.dt_emissao, v.hr_saida, '+sLineBreak+
                       'v.TOT_NF, v.TOT_ISS, v.TOT_DESCONTO, v.ISS_RETIDO,  '+sLineBreak+
                       'v.nfs_numero, v.protocolo, tb_cli_pj.insc_estad, v.tot_nf, '+sLineBreak+
                       'tb_cli_pj.insc_munic, tb_cli_pj.cnpj, TB_CIDADE_SIS.nome as cidade_tomador, '+sLineBreak+
                       'TB_CIDADE_SIS.SIGLA_UF, tb_cliente.id_cidade as cod_cidade_tomador, '+sLineBreak+
                       'TB_CLI_PF.CPF, '+sLineBreak+
                       'tb_cliente.DDD_CELUL, tb_cliente.fone_CELUL, tb_cliente.EMAIL_NFE, '+sLineBreak+
                       'tb_cliente.END_LOGRAD, tb_cliente.END_BAIRRO, tb_cliente.END_NUMERO '+sLineBreak+
                       'from v_nfse v '+sLineBreak+
                       'left join tb_cli_pj on tb_cli_pj.id_cliente = v.id_cliente '+sLineBreak+
                       'left join TB_CLI_PF on TB_CLI_PF.id_cliente = v.id_cliente '+sLineBreak+
                       'left join tb_cliente on tb_cliente.id_cliente = v.id_cliente '+sLineBreak+
                       'left join TB_CIDADE_SIS on TB_CIDADE_SIS.id_cidade = tb_cliente.id_cidade '+sLineBreak+
                       'where '+Busca+' = '+ QuotedStr(TVar_Dados_novo.Nfse_Numero) +sLineBreak+
                       'and v.nf_serie = '+ QuotedStr(TVar_Dados_novo.Nfse_Serie);
    qryInfoManual.Open;
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEL,
      proIPM,
      proISSNet,
      proISSDSF,
      proGoverna,
      proTinus,
      proMegasoft]) then
    begin
      NFSE.OptanteSimplesNacional := TFuncao.Condicao.ifthen(
        TNFSe_Emitente.sSimples_Nacional = DADO_SIM, snSim, snNao
      );
      NFSe.Numero := qryInfoManual.FieldByName('NFS_NUMERO').AsString;
      NFSe.IdentificacaoRps.Numero := qryInfoManual.FieldByName('RPS').AsString;
      NFSe.Competencia := qryInfoManual.FieldByName('DT_EMISSAO').AsDateTime;

      if (NFSe.DataEmissao <= 0) or (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF]) then
        NFSe.DataEmissao := qryInfoManual.FieldByName('DT_EMISSAO').AsDateTime +qryInfoManual.FieldByName('HR_SAIDA').AsDateTime;
      if nfse.Servico.Tributacao in [ttImune,ttIsentaISS] then
        NFSe.Servico.Valores.ValorISS := 0;
      nfse.RegimeEspecialTributacao := getRegimeEspecialTributacao;

      NFSe.CodigoVerificacao := qryInfoManual.FieldByName('protocolo').AsString;
      NFSe.Servico.CodigoMunicipio := Tfuncao.Condicao.IfThen(qryInfoManual.FieldByName('MUNICIPIO_PRESTADOR').AsString = '',
                                                              TNFSe_Emitente.iid_Cidade,
                                                              qryInfoManual.FieldByName('MUNICIPIO_PRESTADOR').AsString);
    end;


    //#14026 - Anderson
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico,proGoverna, proSoftPlan]) then
    begin
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := qryInfoManual.FieldByName('insc_estad').AsString;
      NFSe.Competencia := qryInfoManual.FieldByName('DT_EMISSAO').AsDateTime;
      NFSe.Tomador.Contato.Telefone := qryInfoManual.FieldByName('DDD_CELUL').AsString+'-'+
        qryInfoManual.FieldByName('fone_CELUL').AsString;
    end;

    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proBetha]) and (TNFSeDados.STipoImpressao <> Impressao_Detalhada_Itens) then
    begin
      NFSe.Servico.Discriminacao := AjustaDiscriminacao(NFSe.Servico.Discriminacao);
      if (NFSe.Servico.ItemServico.Count > 0) then
        NFSe.Servico.ItemServico[0].Descricao :=  NFSe.Servico.Discriminacao;
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := qryInfoManual.FieldByName('insc_estad').AsString;
      NFSe.Servico.Valores.DescontoCondicionado := qryInfoManual.FieldByName('TOT_DESCONTO').AsCurrency;
    end;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSGoiania,
      proGoverna,
      proActcon,
      proSoftPlan] then
    begin
      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proSoftPlan] then
        NFSe.Tomador.Endereco.xMunicipio := qryInfoManual.FieldByName('cidade_tomador').AsString + '-'+
          qryInfoManual.FieldByName('SIGLA_UF').AsString
      else
        NFSe.Tomador.Endereco.xMunicipio := qryInfoManual.FieldByName('cidade_tomador').AsString;
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := qryInfoManual.FieldByName('insc_estad').AsString;
      NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal := qryInfoManual.FieldByName('insc_munic').AsString;
      NFSe.Servico.CodigoMunicipio := qryInfoManual.FieldByName('cod_cidade_tomador').AsString;
      NFSe.Tomador.Contato.Telefone := qryInfoManual.FieldByName('DDD_CELUL').AsString+'-'+
        qryInfoManual.FieldByName('fone_CELUL').AsString;
      NFSe.Tomador.Contato.Email := qryInfoManual.FieldByName('EMAIL_NFE').AsString;
      NFSe.Tomador.Endereco.Endereco := qryInfoManual.FieldByName('END_LOGRAD').AsString;
      NFSe.Tomador.Endereco.Bairro := qryInfoManual.FieldByName('END_BAIRRO').AsString;
      NFSe.Tomador.Endereco.Numero := qryInfoManual.FieldByName('END_NUMERO').AsString;
    end;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proEloTech] then
      NFSe.Servico.Valores.ValorLiquidoNfse := qryInfoManual.FieldByName('TOT_NF').AsCurrency;

    if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSGoiania,
      proIPM,
      proGoverna,
      proPadraoNacional,
      proBetha,
      proSoftPlan,
      proCoplan]) then
    begin
      if Trim(qryInfoManual.FieldByName('cpf').AsString) <> '' then
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj := qryInfoManual.FieldByName('cpf').AsString
      else
        NFSe.Tomador.IdentificacaoTomador.CpfCnpj := qryInfoManual.FieldByName('cnpj').AsString;
      NFSe.Tomador.Endereco.UF := qryInfoManual.FieldByName('SIGLA_UF').AsString;
      NFSe.Tomador.RazaoSocial := qryInfoManual.FieldByName('cliente').AsString;
      NFSe.Tomador.NomeFantasia := qryInfoManual.FieldByName('cliente').AsString;
      NFSe.Servico.Valores.ValorIss := qryInfoManual.FieldByName('TOT_ISS').AsCurrency;
      NFSe.Servico.Valores.ValorServicos := qryInfoManual.FieldByName('TOT_NF').AsCurrency;
      NFSe.Servico.Valores.ValorLiquidoNfse := qryInfoManual.FieldByName('TOT_NF').AsCurrency;
      NFSe.Servico.Valores.ValorTotalNotaFiscal := qryInfoManual.FieldByName('TOT_NF').AsCurrency;
      if qryInfoManual.FieldByName('ISS_RETIDO').AsString <> DADO_SIM then
      begin
        NFSe.Servico.Valores.IssRetido := stNormal;
        NFSe.Servico.Valores.ValorIssRetido := 0;
      end;
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := qryInfoManual.FieldByName('insc_estad').AsString;
      qryitem := TFuncao.SQL.CriarQuery(ConexaoTemp);
      try
        qryitem.Open('select QTD_ITEM, VLR_UNIT, VLR_TOTAL, VLR_ISS, PRODUTO, ALIQ_ISS, VLR_ISS, OBSERVACAO '+sLineBreak+
         'from V_NFSE_ITEM where id_nfvenda = '+QuotedStr(qryInfoManual.FieldByName('id_nfvenda').AsString));
          NFSe.Servico.ItemServico.Clear;
          Acontador := 0;
          while not qryitem.Eof do
          begin
            NFSe.Servico.ItemServico.New;
            NFSe.Servico.ItemServico[Acontador].Descricao :=  qryitem.FieldByName('PRODUTO').AsString;
            if qryitem.FieldByName('OBSERVACAO').AsString <> EmptyStr then
              NFSe.Servico.ItemServico[Acontador].Descricao := NFSe.Servico.ItemServico[Acontador].Descricao + #13+
               'Obs: '+qryitem.FieldByName('OBSERVACAO').AsString + #13;
            NFSe.Servico.ItemServico[Acontador].Quantidade := qryitem.FieldByName('QTD_ITEM').AsCurrency;
            NFSe.Servico.ItemServico[Acontador].ValorUnitario := qryitem.FieldByName('VLR_UNIT').AsCurrency;
            NFSe.Servico.ItemServico[Acontador].ValorTotal :=  qryitem.FieldByName('VLR_TOTAL').AsCurrency;
            NFSe.Servico.ItemServico[Acontador].Aliquota :=  qryitem.FieldByName('ALIQ_ISS').AsCurrency;
            NFSe.Servico.ItemServico[Acontador].ValorISS :=  qryitem.FieldByName('VLR_ISS').AsCurrency;
            Inc(Acontador);
            qryitem.Next;
          end;
      finally
        FreeAndNil(qryitem);
      end;

    end;
    NFSe.Prestador.RazaoSocial := TNFSe_Emitente.sRazao_Social;
    NFSe.Prestador.IdentificacaoPrestador.Cnpj := TNFSe_Emitente.sCNPJ;
    NFSe.Prestador.IdentificacaoPrestador.InscricaoEstadual := TNFSe_Emitente.sInscricao_Estadual;
    NFSe.Prestador.Endereco.UF := TNFSe_Emitente.sUF;
    NFSe.Prestador.Endereco.Endereco := TNFSe_Emitente.sEnd_Logradouro;
    NFSe.Prestador.Endereco.Numero := TNFSe_Emitente.sEnd_Numero;
    NFSe.Prestador.Endereco.Bairro := TNFSe_Emitente.sEnd_Bairro;
    NFSe.Prestador.Contato.Telefone := Trim(TNFSe_Emitente.sTelefone);
    NFSe.Prestador.Endereco.xMunicipio := TNFSe_Emitente.cidade;
    NFSe.Prestador.Endereco.Complemento := TNFSe_Emitente.endComplemento;
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := TNFSe_Emitente.sInscricao_Municipal;
    NFSe.Prestador.Endereco.CEP := TNFSe_Emitente.sEnd_Cep;
    NFSe.Prestador.Contato.Email := TNFSe_Emitente.sEmail;
    NFSe.Prestador.Endereco.CodigoMunicipio := TNFSe_Emitente.iid_Cidade;
  finally
    qryInfoManual.Free;
  end;
  if AIEProdutorRural <> '' then
  begin
    if trim(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual) = '' then
      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual := AIEProdutorRural;
  end;
end;

procedure TDataModuleNFSeX.Carrega_NFSe(FID_NFVenda: Integer);
begin
  FDQueryV_NFSe.Connection  := Conexao;
  FDQueryV_NFSe.Transaction := TransacaoLeitura;
  FDQueryV_NFSe.Close;
  FDQueryV_NFSe.SQL.Text := 'select V_NFSE.* '+
    ' from V_NFSE '+
    ' where ID_NFVENDA = :ID_NFVENDA';
  FDQueryV_NFSe.ParamByName('ID_NFVENDA').AsInteger := FID_NFVenda;
  FDQueryV_NFSe.Open();

  FDQueryCliente.Connection  := Conexao;
  FDQueryCliente.Transaction := TransacaoLeitura;
  FDQueryCliente.Close();
  FDQueryCliente.SQL.Text := 'select v_clientes.* from v_clientes '+
    'where id_cliente = :id_cliente';
  FDQueryCliente.ParamByName('ID_CLIENTE').AsInteger := FDQueryV_NFSe.FieldByName('ID_CLIENTE').AsInteger;
  FDQueryCliente.Open;

end;

procedure TDataModuleNFSeX.ChecarResposta(aMetodo: TMetodo; id_nfvenda : integer);
const
  StartTAG_XML = 'starttag: invalid element name';

var
  i: Integer;
  webBrowser : TWebBrowser;
  cancelamento, bVerACbr : boolean;
begin
  TVar_Dados_novo.fLimpa_VarDados;
  cancelamento := False;
  mostraMensagem := True;

  webBrowser := TWebBrowser.Create(nil);
  with ACBrNFSeX1.WebService do
  begin
    case aMetodo of
      tmRecepcionar,
      tmTeste:
        begin
          with Emite do
          begin
            TVar_Dados_novo.Protocolo          := Protocolo;
            TVar_Dados_novo.Protocolo_Origem   := Protocolo;
            TVar_Dados_novo.Nfse_Numero        := NumeroNota;
            TVar_Dados_novo.Nfse_Numero_Origem := NumeroNota;
            TVar_Dados_novo.Link_Nfse          := Link;
            TVar_Dados_novo.CodVerificacao     := CodigoVerificacao;
            TVar_Dados_novo.Mensagem           := DescSituacao;

            if (not(NumeroNota = '')) and (ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSiapSistemas,
              proSystemPro,
              profintelISS,
              proISSDSF,
              proFiorilli,
              proWebISS,
              proTecnos,
              proMegaSoft,
              proSmarAPD,
              proISSSaoPaulo,
              proActcon])) then
            begin
              TVar_Dados_novo.Situacao := SIT_Sucesso;
              TVar_Dados_novo.Mensagem := PROC_Sucesso;
            end;

            if (TVar_Dados_novo.Protocolo = EmptyStr) and
               (TVar_Dados_novo.CodVerificacao <> EmptyStr) and
               (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proISSIntel) and
               (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proPronim) then
              TVar_Dados_novo.Protocolo := TVar_Dados_novo.CodVerificacao;


            if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc]) and (aMetodo = tmRecepcionar) then
            begin
              ConsultaLote(TVar_Dados_novo.Protocolo, ACBrNFSeX1.WebService.Emite.NumeroLote);
              //Exit();
            end;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

            //#14273 - Anderson - provedor não retorna situação
            if (Sucesso) and
               (Erros.Count <= 0) and
               (NumeroNota <> EmptyStr) and
               (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSNet,
                  proIPM,
                  proSoftPlan,
                  proBetha,
                  proSmarAPD,
                  proISSSaoPaulo]) then
            begin
              TVar_Dados_novo.Situacao := '4';
              TVar_Dados_novo.Mensagem := 'Processado com sucesso';
              if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM]) then
                ConsultaLote(TVar_Dados_novo.Protocolo, ACBrNFSeX1.WebService.Emite.NumeroLote);
            end;

            if Erros.Count > 0 then
            begin
              for i := 0 to Erros.Count -1 do
              begin
                //#14273 - Anderson - gravar na base o primeiro erro, o último é sempre "Lista NFse não encontrada"
                if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) then
                begin
                  if (TVar_Dados_novo.Mensagem = EmptyStr) then
                  begin
                    TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                    TVar_Dados_novo.Correcao := Erros[i].Correcao;
                  end;
                end
                else
                begin
                  if (Erros[i].Descricao <> '') or (Erros[i].Correcao <> '') then
                  begin
                    TVar_Dados_novo.Situacao   := SIT_Erro;
                    TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                    TVar_Dados_novo.Correcao := Erros[i].Correcao;
                  end;
                end;
                //#10208 - Anderson >> qdo vem <> dentro da mensagem o ACBR não mapeia o XML de retorno
                if (Pos(StartTAG_XML, AnsiLowerCase(TVar_Dados_novo.Mensagem)) > 0) and
                   (ACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) then
                begin
                  TVar_Dados_novo.Correcao := Trim(TVar_Dados_novo.Correcao +
                                              ' Acesse o portal do provedor e consulte o resultado do processamento desse RPS');
                end;

                if (Erros[i].Descricao <> '') or (Erros[i].Correcao <> '') then
                  TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção:'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for i := 0 to Alertas.Count -1 do
              begin
                if (Alertas[i].Descricao = 'Operação efetuada com sucesso') or (pos(UpperCase(Alertas[i].Descricao),'SUCESSO') > 0) then
                  TVar_Dados_novo.mensagemCompleta := EmptyStr
                else
                begin
                  TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                  TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                  TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                  ' Erro: '+ Alertas[i].Descricao+#13+
                                                  ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;

          if (ACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio) and
             (ACBrNFSeX1.WebService.Emite.ModoEnvio = meLoteAssincrono) and //#14273 - Anderson mesma regra feito interno no ACBrNFSeX
             (Emite.Protocolo <> '') then
          begin
            if ACBrNFSeX1.Provider.ConfigGeral.ConsultaSitLote then
            begin
              with ConsultaSituacao do
              begin
                TVar_Dados_novo.Situacao        := Situacao;
                TVar_Dados_novo.Protocolo       := Protocolo;
                TVar_Dados_novo.Nfse_Numero     := NumeroNota;
                TVar_Dados_novo.Mensagem        := DescSituacao;
                if TVar_Dados_novo.Situacao = SIT_Sucesso then
                  TVar_Dados_novo.Mensagem      := PROC_Sucesso;
                LoadXML(XmlRetorno, webBrowser, 'temp2.xml');


                if Erros.Count > 0 then
                begin
                  for i := 0 to Erros.Count -1 do
                  begin
                    TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                    TVar_Dados_novo.Correcao := Erros[i].Correcao;
                    TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                        ' Erro: '+ Erros[i].Descricao+#13+
                                                        ' Correção :'+Erros[i].Correcao+#13;
                  end;
                end;

                if Alertas.Count > 0 then
                begin
                  for i := 0 to Alertas.Count -1 do
                  begin
                    TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                    TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                    TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                        ' Erro: '+ Alertas[i].Descricao+#13+
                                                        ' Correção :'+Alertas[i].Correcao+#13;
                  end;
                end;
              end;
            end;

            if ACBrNFSeX1.Provider.ConfigGeral.ConsultaLote then
            begin
              with ConsultaLoteRps do
              begin
                //#13862 - Anderson > a situação correta já retornou acima disso
                if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proGinfes) then
                begin
                  if (Situacao <> EmptyStr) or
                     (TVar_Dados_novo.Situacao <> SIT_Erro) then
                    TVar_Dados_novo.Situacao := Situacao;
                end
                else
                begin
                  if (TVar_Dados_novo.Situacao = SIT_Lote_Processamento) and (Trim(Situacao) = '') then
                    TVar_Dados_novo.mensagemCompleta := 'Lote em processamento  '+#13
                  else
                    TVar_Dados_novo.Situacao := Situacao;
                end;
                TVar_Dados_novo.Protocolo      := Protocolo;
                TVar_Dados_novo.Nfse_Numero    := NumeroNota;
                TVar_Dados_novo.Mensagem       := DescSituacao;
                TVar_Dados_novo.CodVerificacao := CodigoVerificacao;

                if TVar_Dados_novo.Situacao = SIT_Sucesso then
                  TVar_Dados_novo.Mensagem := PROC_Sucesso;

                //#13997 - Anderson
                if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico) and
                   (ConsultaLoteRps.Sucesso) then
                   SucessoLote_AssessorPublico;

                LoadXML(XmlRetorno, webBrowser, 'temp2.xml');
                if Erros.Count > 0 then
                begin
                  //#13997 - Anderson > tratamento específico para os erros do proAssessorPublico
                  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico) and
                     (ErroLote_AssessorPublico) then
                    bVerACbr := False
                  else
                    bVerACbr := True;

                  if bVerACbr then
                  begin
                    for i := 0 to erros.Count -1 do
                    begin
                      //#13862 - Anderson > Ignorar esse erro para exibir o correto
                      if (Pos('lista de nfse não encontrada', AnsiLowerCase(Erros[i].Descricao)) > 0) then
                         Continue;

                      TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                      TVar_Dados_novo.Correcao := Erros[i].Correcao;
                      TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                          ' Erro: '+ Erros[i].Descricao+#13+
                                                          ' Correção :'+Erros[i].Correcao+#13;
                    end;
                  end;
                end;

                if Alertas.Count > 0 then
                begin
                  for I := 0 to Alertas.count - 1 do
                  begin
                    if (Pos('lista de nfse não encontrada', AnsiLowerCase(Erros[i].Descricao)) > 0) then
                      Continue;
                    TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                    TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                    TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                        ' Erro: '+ Alertas[i].Descricao+#13+
                                                        ' Correção :'+Alertas[i].Correcao+#13;
                  end;
                end;
              end;
            end;
          end;
        end;
      tmRecepcionarSincrono,
      tmGerar:
        begin
          with Emite do
          begin
            TVar_Dados_novo.Protocolo       := Protocolo;
            TVar_Dados_novo.Nfse_Numero     := NumeroNota;
            TVar_Dados_novo.Link_Nfse       := Link;
            TVar_Dados_novo.CodVerificacao  := CodigoVerificacao;
            TVar_Dados_novo.Mensagem        := DescSituacao;
            if (Sucesso) and ((TVar_Dados_novo.CodVerificacao <> '') or (TVar_Dados_novo.Protocolo <> ''))then
            begin
              TVar_Dados_novo.Situacao        := SIT_Sucesso;
              TVar_Dados_novo.Mensagem      := PROC_Sucesso;
              ACBrNFSeX1.NotasFiscais.Items[0].ImprimirPDF;
            end
            else
              TVar_Dados_novo.Situacao        := SIT_Erro;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.count -1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmConsultarSituacao:
        begin
          with ConsultaSituacao do
          begin
            TVar_Dados_novo.Protocolo       := Protocolo;
            TVar_Dados_novo.Situacao        := situacao;
            if (LowerCase(TVar_Dados_novo.Situacao) = 'true') then
              TVar_Dados_novo.Situacao        := SIT_Sucesso;
            TVar_Dados_novo.Link_Nfse       := Link;
            TVar_Dados_novo.CodVerificacao  := CodigoVerificacao;
            TVar_Dados_novo.Mensagem        := DescSituacao;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');


            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmConsultarLote:
        begin
          with ConsultaLoteRps do
          begin
            TVar_Dados_novo.Protocolo       := Protocolo;
            TVar_Dados_novo.Nfse_Numero     := NumeroNota;
            TVar_Dados_novo.Link_Nfse       := Link;
            TVar_Dados_novo.CodVerificacao  := CodigoVerificacao;
            if Situacao <> EmptyStr then
              TVar_Dados_novo.Situacao        := Situacao;
            if (LowerCase(TVar_Dados_novo.Situacao) = 'true') then
              TVar_Dados_novo.Situacao        := SIT_Sucesso;
            TVar_Dados_novo.Mensagem        := DescSituacao;

            if ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc then
            begin
              if TVar_Dados_novo.Situacao = '200' then
                TVar_Dados_novo.Situacao := SIT_Erro
              else if TVar_Dados_novo.Situacao = '100' then
              begin
                TVar_Dados_novo.Situacao := SIT_Sucesso;
                mostraMensagem := False;
              end;
            end;
            if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSmarAPD) and (StrToIntDef(NumeroNota,0) > 0) then
              TVar_Dados_novo.Situacao := SIT_Sucesso;

            //#13997 - Anderson
            if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico) and
               (ConsultaLoteRps.Sucesso) and
               (SucessoLote_AssessorPublico) then
              mostraMensagem := False;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

            if Erros.Count > 0 then
            begin
              //#13997 - Anderson > tratamento específico para os erros do proAssessorPublico
              if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico) and
                 (ErroLote_AssessorPublico) then
                bVerACbr := False
              else
                bVerACbr := True;

              if bVerACbr then
              begin
                for I := 0 to Erros.Count - 1 do
                begin
                  if pos('Lista de NFSe não encontrada', Erros[i].Descricao) = 0 then
                  begin
                    if (Erros[i].Descricao <> '') or (Erros[i].Correcao <> '') then
                    begin
                      TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                      TVar_Dados_novo.Correcao := Erros[i].Correcao;
                      TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                          ' Erro: '+ Erros[i].Descricao+#13+
                                                          ' Correção :'+Erros[i].Correcao+#13;
                      if TVar_Dados_novo.Situacao = EmptyStr then
                      begin
                        if (pos('processamento', TVar_Dados_novo.mensagemCompleta) > 0) or
                          (pos('não processado', TVar_Dados_novo.mensagemCompleta) > 0)
                         then
                          TVar_Dados_novo.Situacao := SIT_Lote_Processamento
                        else
                          TVar_Dados_novo.Situacao := SIT_Erro;
                      end;
                    end;
                  end;
                end;

                if ((pos('Lote aguardando processamento', TVar_Dados_novo.mensagemCompleta) > 0) and
                    (tentativasConsultaLote <= 2) and
                    (envioNFSe)) then
                  mostraMensagem := False
                else
                  mostraMensagem := True;
              end;

            end;

            if (Alertas.Count > 0) and (pos(UpperCase(Alertas[i].Descricao),'SUCESSO') = 0) then
            begin
              for I := 0 to Alertas.Count -1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
            VerificaStatusNFSeBrasil;
          end;
        end;

      tmConsultarNFSePorRps:
        begin
          with ConsultaNFSeporRps do
          begin
            TVar_Dados_novo.Protocolo       := Protocolo;
            TVar_Dados_novo.Nfse_Numero     := NumeroNota;
            TVar_Dados_novo.Link_Nfse       := Link;
            if TVar_Dados_novo.Link_Nfse = EmptyStr then
            begin
              // CPRO-805 - sergio - Link esta dentro da nfse
              if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and (ACBrNFSeX1.NotasFiscais.Count > 0) then
                TVar_Dados_novo.Link_Nfse:= ACBrNFSeX1.NotasFiscais[0].NFSe.link;
            end;
            TVar_Dados_novo.CodVerificacao  := CodigoVerificacao;
            TVar_Dados_novo.Situacao        := Situacao;
            TVar_Dados_novo.Mensagem        := DescSituacao;
            if (Sucesso = true) and ((Protocolo <> '') or (StrToIntDef(NumeroNota,0) > 0) or
            (LowerCase(TVar_Dados_novo.Situacao) = 'true')) then
            begin
              TVar_Dados_novo.Situacao := SIT_Sucesso;
              TVar_Dados_novo.Mensagem := PROC_Sucesso;
            end;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');
            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;

            if (TVar_Dados_novo.Protocolo = EmptyStr) and
               (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proISSIntel) and
               (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proPronim) then
              TVar_Dados_novo.Protocolo  := CodigoVerificacao;
          end;
        end;

      tmConsultarNFSe,
      tmConsultarNFSePorFaixa,
      tmConsultarNFSeServicoPrestado,
      tmConsultarNFSeServicoTomado:
        begin
          with ConsultaNFSe do
          begin
            if Sucesso = true then
              TVar_Dados_novo.Situacao        := SIT_Sucesso
            else
              TVar_Dados_novo.Situacao        := SIT_Erro;

            LoadXML(XmlRetorno, WebBrowser, 'temp2.xml');

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmCancelarNFSe:
        begin
          cancelamento := true;
          with CancelaNFSe do
          begin
            if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico then
              Cancelar_AssessorPublico
            else if ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech then
              Cancelar_EloTech
            else
            begin
              TVar_Dados_novo.Link_Nfse       := RetCancelamento.Link;
              TVar_Dados_novo.Situacao        := RetCancelamento.Sucesso;
              TVar_Dados_novo.Data            := RetCancelamento.DataHora;
              TVar_Dados_novo.Mensagem        := RetCancelamento.MsgCanc;
              TVar_Dados_novo.Situacao        := RetCancelamento.Situacao;

              if Sucesso then
                TVar_Dados_novo.Situacao        := SIT_Sucesso
            end;
            if not(Sucesso) and (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM ) then
              Cancelar_retorno;

            LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

            if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [profintelISS, proEl, proISSNet, proIPM, proISSIntel, proTinus]) and
               (Erros.Count > 0) then
            begin
              if (copy(Erros[0].Descricao, 1, 23) = 'NFS-e já está cancelada') or
                 (Erros[0].Descricao = 'A Nota Fiscal que esta tentando requisitar o Cancelamento, já encontra-se Cancelada!') or
                 (Pos(AnsiLowerCase('NFS-e ja esta cancelada'), AnsiLowerCase(Erros[0].Descricao)) = 1) or
                 (Pos(AnsiLowerCase('A NFSe já encontra-se cancelada'), AnsiLowerCase(Erros[0].Descricao)) = 1) or
                 (Pos(AnsiLowerCase('Essa NFS-e já está cancelada'), AnsiLowerCase(Erros[0].Descricao)) = 1) or
                 (Pos(AnsiLowerCase('A NFSe já encontra-se cancelada'), AnsiLowerCase(Erros[0].Codigo)) > 0) then
              begin
                TVar_Dados_novo.Situacao := SIT_Sucesso;
                TVar_Dados_novo.Mensagem := 'NFS-e Cancelada';
                Sucesso := True;
                Erros.Clear;
              end;
            end;

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;

          if (ACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar and
             ACBrNFSeX1.Provider.ConfigGeral.ConsultaNFSe) and
             (not (ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proISSDSF, proISSIntel]))) then
          begin
            with ConsultaNFSe do
            begin
              //#13862 - Anderson > não cancela via WebService
              if ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proGinfes) and
                 (not StrToBool(CancelaNFSe.RetCancelamento.Sucesso)) and
                 (Pos('entre em contato com a prefeitura', AnsiLowerCase(TVar_Dados_novo.Mensagem)) > 0))
                 or
                 ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) and
                  (Pos('não permitir o cancelamento de notas fiscais',
                    AnsiLowerCase(TVar_Dados_novo.mensagemCompleta)) > 0)) then
              begin
                if MensagemConfirmacao(Application.Handle, 'Caso a prefeitura já tenho autorizado e efetuado o cancelamento' + sLineBreak +
                                    'dessa NFS-e, clique em Sim para cancelar no sistema também.'+sLineBreak +sLineBreak +
                                    'Caso ainda não tenha verificado com a prefeitura clique em Não.', 'Atenção', MB_YESNO or mb_DefButton2) = mrYes then
                  TVar_Dados_novo.Situacao        := SIT_Sucesso
                else
                  TVar_Dados_novo.Situacao        := SIT_Erro;
              end
              else
              begin
                if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc]) then
                begin
                  if (Pos(AnsiLowerCase('NFS-e já está cancelada'), AnsiLowerCase(TVar_Dados_novo.mensagemCompleta)) > 0) or
                    (Pos(AnsiLowerCase('Cancelado'), AnsiLowerCase(CancelaNFSe.RetCancelamento.Situacao)) > 0) then
                  begin
                    TVar_Dados_novo.Situacao := SIT_Sucesso;
                    TVar_Dados_novo.Mensagem := 'NFS-e Cancelada';
                    Sucesso := True;
                    Erros.Clear;
                  end;
                end;

                if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proBetha, proTinus,proSmarAPD]) then
                begin
                  if CancelaNFSe.Sucesso then
                    TVar_Dados_novo.Situacao := SIT_Sucesso
                  else
                    TVar_Dados_novo.Situacao := SIT_Erro;
                end
                else
                begin
                  if Sucesso then
                    TVar_Dados_novo.Situacao := SIT_Sucesso
                  else
                    TVar_Dados_novo.Situacao := SIT_Erro;
                end;
              end;

              LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

              if Erros.Count > 0 then
              begin
                 for I := 0 to Erros.Count - 1 do
                begin
                  //#13898 - Anderson
                  if (Erros[i].Descricao = EmptyStr) and
                     (Erros[i].Correcao = EmptyStr) then
                     Continue;

                  TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                  TVar_Dados_novo.Correcao := Erros[i].Correcao;
                  TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                      ' Erro: '+ Erros[i].Descricao+#13+
                                                      ' Correção :'+Erros[i].Correcao+#13;
                end;
              end;

              if Alertas.Count > 0 then
              begin
                for I := 0 to Alertas.Count - 1 do
                begin
                  TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                  TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                  TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                      ' Erro: '+ Alertas[i].Descricao+#13+
                                                      ' Correção :'+Alertas[i].Correcao+#13;
                end;
              end;
            end;
          end;
        end;

      tmSubstituirNFSe:
        begin
          with SubstituiNFSe do
          begin
            TVar_Dados_novo.Link_Nfse       := RetCancelamento.Link;
            TVar_Dados_novo.Situacao        := RetCancelamento.Situacao;
            TVar_Dados_novo.Mensagem        := DescSituacao;

            LoadXML(XmlRetorno, WebBrowser, 'temp2.xml');

            if Erros.Count > 0 then
            begin
              for I := 0 to Erros.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Erros[i].Descricao;
                TVar_Dados_novo.Correcao := Erros[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
              end;
            end;

            if Alertas.Count > 0 then
            begin
              for I := 0 to Alertas.Count - 1 do
              begin
                TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
                TVar_Dados_novo.Correcao := Alertas[i].Correcao;
                TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
              end;
            end;
          end;
        end;

      tmAbrirSessao:
        begin
        end;


      tmFecharSessao:
        begin
        end;
      tmEnviarEvento:
      begin
        with EnviarEvento do
        begin
          if Sucesso then
            TVar_Dados_novo.Situacao        := SIT_Sucesso;
          LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

          if Erros.Count > 0 then
          begin
            for i := 0 to Erros.Count -1 do
            begin
              TVar_Dados_novo.Mensagem := Erros[i].Descricao;
              TVar_Dados_novo.Correcao := Erros[i].Correcao;
              TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Erros[i].Descricao+#13+
                                                    ' Correção :'+Erros[i].Correcao+#13;
            end;
          end;

          if Alertas.Count > 0 then
          begin
            for i := 0 to Alertas.Count -1 do
            begin
              TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
              TVar_Dados_novo.Correcao := Alertas[i].Correcao;
              TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
            end;
          end;
        end;
      end;

    tmConsultarEvento:
      begin
        with ConsultarEvento do
        begin
          if Sucesso then
            TVar_Dados_novo.Situacao        := SIT_Sucesso;
          TVar_Dados_novo.Data            := Data;

          LoadXML(XmlRetorno, webBrowser, 'temp2.xml');

          if Erros.Count > 0 then
          begin
            for i := 0 to Erros.Count -1 do
            begin
              TVar_Dados_novo.Mensagem := Erros[i].Descricao;
              TVar_Dados_novo.Correcao := Erros[i].Correcao;
              TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                  ' Erro: '+ Erros[i].Descricao+#13+
                                                  ' Correção :'+Erros[i].Correcao+#13;
            end;
          end;

          if Alertas.Count > 0 then
          begin
            for i := 0 to Alertas.Count -1 do
            begin
              TVar_Dados_novo.Mensagem := Alertas[i].Descricao;
              TVar_Dados_novo.Correcao := Alertas[i].Correcao;
              TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                                    ' Erro: '+ Alertas[i].Descricao+#13+
                                                    ' Correção :'+Alertas[i].Correcao+#13;
            end;
          end;
        end;
      end;
    end;
  end;

  //#13862 - Anderson > Ignorar esse erro para exibir o correto
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proGinfes) then
  begin
    TVar_Dados_novo.Correcao := StringReplace(TVar_Dados_novo.Correcao, '¿', '-', [rfReplaceAll]);
    TVar_Dados_novo.mensagemCompleta := StringReplace(TVar_Dados_novo.mensagemCompleta, '¿', '-', [rfReplaceAll]);
  end;
  try
    if aMetodo in [tmRecepcionar, tmGerar, tmGerarLote, tmRecepcionarSincrono ] then
    begin
      if ((ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero <> '') and ((ACBrNFSeX1.WebService.Emite.Protocolo <> '') or (ACBrNFSeX1.NotasFiscais.Items[0].NFSe.CodigoVerificacao <> ''))) and
         ((not(ACBrNFSeX1.Configuracoes.Geral.Provedor in ([profintelISS, proBetha, proGinfes, proAssessorPublico, proISSDSF, proNFSeBrasil])) and (TVar_Dados_novo.Nfse_Numero = '')) and
          (not(ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSSJP, proISSIntel]) and (TVar_Dados_novo.situacao <> SIT_Sucesso)) and
		      (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proAssessorPublico)) or
          ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proEloTech) and (ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero <> '') and
          (ACBrNFSeX1.WebService.ConsultaLoteRps.Erros.Count = 0) and (TVar_Dados_novo.Situacao = '')) or
          ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proGoverna) and (TVar_Dados_novo.Mensagem = 'RPS Importado com sucesso.')) or
          ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proMegaSoft) and (TVar_Dados_novo.Mensagem = 'Processado com sucesso')) or
          ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and (TVar_Dados_novo.Mensagem = 'Processado com sucesso') and
            (ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Link <> EmptyStr) and (TVar_Dados_novo.Link_Nfse = EmptyStr) ) then
      begin
        TVar_Dados_novo.Protocolo       := ACBrNFSeX1.WebService.Emite.Protocolo;
        {#9405}
        //TVar_Dados_novo.Nfse_Numero     := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero;
        TVar_Dados_novo.Nfse_Numero     := getNumeroNfse;
        TVar_Dados_novo.Link_Nfse       := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Link;
        TVar_Dados_novo.CodVerificacao  := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.CodigoVerificacao;
        (*#14976 - 2023-03-21*)
        if (ACBrNFSeX1.WebService.ConsultaLoteRps.Erros.Count > 0) and
           ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proPronim) or (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet)) then
        begin
          TVar_Dados_novo.Situacao      := SIT_Erro;
          TVar_Dados_novo.Mensagem      := ACBrNFSeX1.WebService.ConsultaLoteRps.DescSituacao;
          (*#16283 - 2023-05-19*)
          if (TVar_Dados_novo.Mensagem = '') and (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) then
            TVar_Dados_novo.Mensagem := ACBrNFSeX1.WebService.ConsultaLoteRps.Erros[0].ToString;
        end
        else
        begin
          (*#16396 - 2023-05-26*)
          if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) and (TVar_Dados_novo.Situacao = SIT_ERRO) then
            TVar_Dados_novo.Situacao := SIT_ERRO
          else
          begin
            if ACBrNFSeX1.WebService.Emite.Erros.Count = 0 then
            begin
              TVar_Dados_novo.Situacao := SIT_Sucesso;
              TVar_Dados_novo.Mensagem := PROC_Sucesso;
            end;
          end;
        end;
        if (TVar_Dados_novo.Protocolo = '') and (TVar_Dados_novo.CodVerificacao <> '' ) then
          TVar_Dados_novo.Protocolo := TVar_Dados_novo.CodVerificacao;
        if ACBrNFSeX1.NotasFiscais.Items[0].XmlNfse = '' then
        begin
          ACBrNFSeX1.NotasFiscais.Items[0].GravarXML(TVar_Dados_novo.Nfse_Numero+'-nfse.xml',
                                                    ACBrNFSeX1.Configuracoes.Arquivos.PathNFSe+'\Notas',
                                                    txmlRPS);
        end;
      end;
    end;
  Except

  end;

  TVar_Dados_novo.Situacao := getSituacao;

  if not bEnvioAuto then
    mostraMensagem := True
  else
    mostraMensagem := false;

  if TVar_Dados_novo.situacao <> SIT_Sucesso then
  begin
    if not(TVar_Dados_novo.mensagemCompleta = '') and (mostraMensagem) and (not EnviaThread) then
      tfuncao.mensagens.MensagemAlerta(TVar_Dados_novo.mensagemCompleta)
  end
  else
  begin
    if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc) and
       (aMetodo <> tmCancelarNFSe)then
    begin
      TVar_Dados_novo.Protocolo_Origem := TVar_Dados_novo.Protocolo;
      if (pos('aceita', TVar_Dados_novo.Mensagem) > 0) or
         (pos('sucesso', TVar_Dados_novo.Mensagem) > 0)  then
      begin
        TVar_Dados_novo.Nfse_Numero := TFuncao.Texto.CopyPos(
          TVar_Dados_novo.Mensagem, 'Nota fiscal ', ' aceita.'
        );
        TVar_Dados_novo.Mensagem := PROC_Sucesso;
      end
      else
      begin
        if (aMetodo = tmConsultarLote) and (TVar_Dados_novo.Mensagem = EmptyStr) then
          TVar_Dados_novo.Mensagem := PROC_Sucesso
        else
          TVar_Dados_novo.situacao := SIT_Erro;
      end;

    end
    else
      TVar_Dados_novo.Mensagem := PROC_Sucesso;
  end;


  if (TVar_Dados_novo.situacao = SIT_Sucesso) and ((TVar_Dados_novo.Nfse_Numero = '') or (TVar_Dados_novo.Nfse_Numero = '0') and (cancelamento = false)) then
  begin
    try
      if ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSJoinville) or
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proABase) or
          {2022-07-01 - #10834 - Ficha 12740 - retorno provedor Sigep - Renan}
          (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep)) and (aMetodo = tmRecepcionar) then
      begin
        TVar_Dados_novo.Protocolo_Origem := TVar_Dados_novo.Protocolo;
        Exit();
      end;

      if ACBrNFSeX1.NotasFiscais.Count > 0 then
        TVar_Dados_novo.Nfse_Numero := ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero
    Except

    end;
  end;

  {#9405 - tratamento para consultar apos o envio}
  if ((ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSJoinville) or
      (ACBrNFSeX1.Configuracoes.Geral.Provedor = proABase) or
      {2022-07-01 - #10834 - Ficha 12740 - retorno provedor Sigep - Renan}
      (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep)) and
     (aMetodo = tmConsultarNFSePorRps) and
     (TVar_Dados_novo.Protocolo = '') then
  begin
    TVar_Dados_novo.Protocolo := TVar_Dados_novo.Protocolo_Origem;
    TVar_Dados_novo.Protocolo_Origem := '';
  end;

  if (TVar_Dados_novo.situacao = SIT_Sucesso) and
    (ACBrNFSeX1.Configuracoes.Geral.Provedor = proSystemPro) and
    (aMetodo = tmRecepcionar)
  then
    gen_id(ConexaoTemp,'GEN_TB_NFSE_NUM_LOTE', 1);

  fGrava_Retorno(IntToStr(id_nfvenda),
    TVar_Dados_novo.Protocolo,
    TVar_Dados_novo.Situacao,
    TVar_Dados_novo.Mensagem,
    TVar_Dados_novo.Nfse_Numero,
    TVar_Dados_novo.Link_Nfse);

end;

Function TDataModuleNFSeX.ConfigurarComponente(TipoEnvio : integer) : Boolean;
var
  PathMensal  : String;
  qryConsulta : TIBQuery;
  LogoStream  : TStringStream;
  LogoPrefeitura,
  FastFile,
  sCaminhoXMLs : String;
begin
  Result := True;
  ACBrNFSeX1.LerCidades;

  //#14338 - Anderson
  //onde estava (ao menos pro ISSNet) no 1º cancelamento ficava diferente WebServices.Ambiente x Provider.ConfigGeral.Ambiente
  if LeParametrizacao(ConexaoTemp, 'NFSE_AMBIENTE', 0) = '0' then
    ACBrNFSeX1.Configuracoes.WebServices.Ambiente := taProducao
  else
    ACBrNFSeX1.Configuracoes.WebServices.Ambiente := taHomologacao;

  try
    ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe := TLayoutNFSe(StrToIntDef(TNFSeDados.Layout,0));
    ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToIntDef(TNFSe_Emitente.iid_Cidade, 0);
  except
    on E: Exception do
    begin
      if Enviathread then
      begin
        TVar_Dados_novo.Mensagem := e.Message;
      end
      else
        if Pos('"pro" não é um valor TnfseProvedor válido', E.Message) > 0  then
          raise Exception.Create('Verifique as configurações da NFSe!');
      Result := False;
      exit
    end;
  end;
  AtualizaPathXML;

  ACBrNFSeX1.Configuracoes.Geral.SSLLib         := TSSLLib(TNFSeDados.SSLLIB);
  ACBrNFSeX1.Configuracoes.Geral.SSLCryptLib    := TSSLCryptLib(TNFSeDados.CRYPTLIB);
  ACBrNFSeX1.Configuracoes.Geral.SSLHttpLib     := TSSLHttpLib(TNFSeDados.HTTPLIB);
  ACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib  := TSSLXmlSignLib(TNFSeDados.XMLSIGNLIB);

  ACBrNFSeX1.SSL.ArquivoPFX  := TNFSeDados.sCaminhoCertificado;
  ACBrNFSeX1.SSL.NumeroSerie := LeParametrizacao(ConexaoTemp, 'NUMEROSERIE_CERTIFICADO', 0);
  ACBrNFSeX1.SSL.Senha := AnsiString(LeParametrizacao(ConexaoTemp, 'SENHA_CERTIFICADO', 0));

//  ACBrNFSeX1.SSL.DescarregarCertificado;

  ACBrNFSeX1.Configuracoes.Certificados.VerificarValidade :=True;
  ACBrNFSeX1.Configuracoes.Arquivos.AdicionarLiteral := True;
  ACBrNFSeX1.Configuracoes.Arquivos.EmissaoPathNFSe := True;
  ACBrNFSeX1.Configuracoes.Arquivos.SepararPorMes := false;
  ACBrNFSeX1.Configuracoes.Arquivos.SepararPorCNPJ := False;
  ACBrNFSeX1.Configuracoes.Arquivos.PathGer := FPathGeral;
  ACBrNFSeX1.Configuracoes.Arquivos.PathRPS := FPathGeral;
  ACBrNFSeX1.Configuracoes.Arquivos.PathNFSe := FPathLogNFSe;
  ACBrNFSeX1.Configuracoes.Arquivos.NomeLongoNFSe := False;
  ACBrNFSeX1.Configuracoes.Arquivos.PathSchemas := ExtractFilePath(Application.ExeName)+'SchemasNFSex\';

  if (not validadeCertificado()) then
    Exit(False);

  PathMensal := ACBrNFSeX1.Configuracoes.Arquivos.GetPathRPS(0);
  ACBrNFSeX1.Configuracoes.Arquivos.PathCan := PathMensal;
  ACBrNFSeX1.Configuracoes.Arquivos.PathSalvar := PathMensal;
  ACBrNFSeX1.Configuracoes.Arquivos.Salvar := True;

  ACBrNFSeX1.Configuracoes.Geral.Salvar                 := True;
  ACBrNFSeX1.Configuracoes.Geral.Emitente.CNPJ          := LimpaNumero(TNFSe_Emitente.sCNPJ);
  ACBrNFSeX1.Configuracoes.Geral.Emitente.InscMun       := TNFSe_Emitente.sInscricao_Municipal;
  ACBrNFSeX1.Configuracoes.Geral.Emitente.RazSocial     := TFuncao.Texto.ConverteAcentos(TFuncao.Texto.Converte_Caractere(TNFSe_Emitente.sRazao_Social));
  ACBrNFSeX1.Configuracoes.Geral.Emitente.WSUser        := TNFSeDados.sUser_Web;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proSoftPlan] then
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSSenha       := TFuncao.MD5.MD5String(TNFSeDados.sSenhaWeb)
  else
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSSenha       := TNFSeDados.sSenhaWeb;
  ACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAcesso := TNFSeDados.sChaveAcesso;
  ACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAutoriz:= TNFSeDados.sChaveAutorizacao;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSoftPlan]) then
  begin
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAcesso  := 'eadea1f3af663730d5c28091a565e18e';
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSFraseSecr    := '8137c9bbd4c8647c5bd263cf70aa4e32';
  end
  else
  begin
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSChaveAcesso := TNFSeDados.sChaveAcesso;
    ACBrNFSeX1.Configuracoes.Geral.Emitente.WSFraseSecr   := TNFSeDados.sFraseSecreta;
  end;

  if (getTipoEnvio(TipoEnvio) = meLoteAssincrono) or (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proIPM]) then
    ACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio  := True;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSiapSistemas, profintelISS, proNFSeBrasil]) then
    ACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio  := False;

  ACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar   := True;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in
    [proPronim, profintelISS, proEl, proISSNet]
  then
    ACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar := False;

  //#13986 - Anderson >> sem a espera cliente é obrigado a consultar lote
  ACBrNFSeX1.Configuracoes.WebServices.AjustaAguardaConsultaRet := True;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc,
   proWebISS,
   proNFSeBrasil,
   proPronim,
   proAssessorPublico] then
    ACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := 5000;

  ACBrNFSeX1.Configuracoes.WebServices.Salvar := StrToBoolDef(LeParametrizacao(ConexaoTemp, 'NFSE_SALVAR_SOAP', 0), False);

  ACBrNFSeX1.Configuracoes.WebServices.Visualizar := True;

  ACBrNFSeX1.Configuracoes.WebServices.ProxyHost := LeParametrizacao(ConexaoTemp,'NFSE_PROXY_HOST', 0);
  ACBrNFSeX1.Configuracoes.WebServices.ProxyPort := LeParametrizacao(ConexaoTemp, 'NFSE_PROXY_PORTA', 0);
  ACBrNFSeX1.Configuracoes.WebServices.ProxyUser := LeParametrizacao(ConexaoTemp,'NFSE_PROXY_USUARIO', 0);
  ACBrNFSeX1.Configuracoes.WebServices.ProxyPass := LeParametrizacao(ConexaoTemp,'NFSE_PROXY_SENHA', 0);
  ACBrNFSeX1.Configuracoes.WebServices.UF                  := TNFSe_Emitente.sUF;
  ACBrNFSeX1.Configuracoes.WebServices.SSLType             := TSSLType(TNFSeDados.SSLTYPE);
  ACBrNFSeX1.Configuracoes.WebServices.QuebradeLinha       := '|';
  ACBrNFSeX1.Configuracoes.WebServices.Tentativas          := 5;
  ACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas := 5000;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSigCorp,
    proSimplISS,
    proTecnos,
    proNFSeBrasil,
    proPronim]) then
    ACBrNFSeX1.Configuracoes.WebServices.TimeOut := 60000;

  ACBrNFSeX1.Configuracoes.Geral.RetirarAcentos := True;
  ACBrNFSeX1.Configuracoes.Geral.RetirarEspacos := True;
  ACBrNFSeX1.Configuracoes.Geral.ValidarDigest  := True;



  ACBrNFSeX1.DANFSe.Sistema  := SOFTHOUSE_NOME;
  qryConsulta := CriaSQLQuery(nil,ConexaoTemp);
  try
    qryConsulta.Open('select logo from TB_EMITENTE');
    if not qryConsulta.IsEmpty then
    begin
      LogoStream  := TStringStream.Create;
      LogoStream.WriteString(qryConsulta.FieldByName('LOGO').AsString);
      ACBrNFSeX1.DANFSe.Prestador.Logo       := LogoStream.DataString;
      FreeAndNil(LogoStream);
    end;
  Finally
    FreeAndNil(qryConsulta);
  end;

  {Explicação sobre uso de Reports do Acbr no sistema

  Reports do Acbr   X Descricao no sitema X Nome do report enviado no Pack
  DANFSE.fr3        X Padrão              X DANFSE.fr3
  DANFSeNovo.fr3    X Detalhada           X DANFSEDetalhada.fr3
  DANFSEPadrao.fr3  X Detalhada com itens X DANFSEDetalhada_itens.fr3}

  ACBrNFSeXDANFSeFR1.ACBrNFSe := ACBrNFSeX1;
  if TNFSeDados.STipoImpressao = 'Padrão' then
    ACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSE'
  else
    if TNFSeDados.STipoImpressao = 'Detalhada com itens' then
     ACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSEDetalhada_itens'
  else
    ACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSEDetalhada';

  FastFile := ACBrNFSeXDANFSeFR1.FastFile+
     TFuncao.Numero.SoNumero(TNFSe_Emitente.sCNPJ)+'.fr3';

  if FileExists(FastFile) then
    ACBrNFSeXDANFSeFR1.FastFile := FastFile
  else
    ACBrNFSeXDANFSeFR1.FastFile := ACBrNFSeXDANFSeFR1.FastFile+'.fr3';


  (*2020-03-24 - #ficha7222 issue#344*)
  ACBrNFSeX1.DANFSe.ImprimeCanhoto := TNFSeDados.imprimirCanhoto;

  LogoPrefeitura := ExtractFilePath(Application.ExeName)+'Imagens\'+TNFSeDados.sLogo_Marca_Prefeitura;
  if FileExists(LogoPrefeitura) then
    ACBrNFSeX1.DANFSe.Logo := LogoPrefeitura;
  ACBrNFSeX1.DANFSe.Prefeitura        := TNFSeDados.sPrefeitura;

  IF not FileExists(sCaminhoXMLs + 'logNFSe\NFSe\PDF\') then
    ForceDirectories(sCaminhoXMLs + 'logNFSe\NFSe\PDF\');
  ACBrNFSeX1.DANFSe.PathPDF           := sCaminhoXMLs + 'logNFSe\NFSe\PDF\';
  ACBrNFSeX1.DANFSe.ExpandeLogoMarca  := True;
  ACBrNFSeX1.DANFSe.TipoDANFSE        := tpPadrao;

  if not(EnviaThread) then
    ACBrNFSeX1.OnStatusChange  := StatusChange;
end;

procedure TDataModuleNFSeX.ConsultaLote(protocolo, Lote: string);
Var
  varLote : string;
begin
  ACBrNFSeX1.NotasFiscais.Clear;
  ConfigurarComponente(TVar_Dados_novo.TipoEnvio);
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico, proElotech,
    proIPM, proISSDSF, proEquiplano, proeGoverneISS, proGeisWeb,
    proSiat, proISSSaoPaulo, proISSSalvador, proPronim] then
  begin
    varlote := Lote;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc] then
    varLote := protocolo;

  ACBrNFSeX1.ConsultarLoteRps(Protocolo, varLote);

  ChecarResposta(tmConsultarLote, FID_NFVenda);
end;

Function TDataModuleNFSeX.ConsultaNFSeRPS(NumeroRps, SerieRps, CodVerificacao: String; consultaAposTransmissao: String = 'N'; AID_NFVenda: Integer = 0) : boolean ;
var
  iTipoRps : Integer;
  TipoRps  : string;
  qryConsulta: TIBQuery;
begin
  Result := True;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proTinus then
  begin
    Result := False;
    Exit;
  end;

  if consultaAposTransmissao = DADO_NAO then
  begin
    TVar_Dados_novo.fLimpa_VarDados;
    ConfigurarComponente(TVar_Dados_novo.TipoEnvio);
  end;

  TipoRps  := '1';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
    SerieRps := '99';

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);
    case iTipoRps of
      1: TipoRps := 'R1';
      2: TipoRps := 'R2';
      3: TipoRps := 'R3';
    end;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAgili then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);

    case iTipoRps of
      1: TipoRps := '-2';
      2: TipoRps := '-4';
      3: TipoRps := '-5';
    end;
  end;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proGiap, proGoverna] then
  begin
    (* #16969 - 2023-07-21 *)
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proGoverna then
    begin
      qryConsulta := CriaSQLQuery(ConexaoTemp);
      SelectQuery(qryConsulta, 'select COD_AUTORIZACAO_RPS from TB_NFSE ' +
        'where ID_NFVENDA = ' + AID_NFVenda.ToString);
      if qryConsulta.FieldByName('COD_AUTORIZACAO_RPS').AsString <> '' then
        CodVerificacao := qryConsulta.FieldByName
          ('COD_AUTORIZACAO_RPS').AsString;
      FreeAndNil(qryConsulta);
    end
    else
    begin
      CodVerificacao := '123';
    end;

    if consultaAposTransmissao = DADO_NAO then
    begin
      if not(InputQuery('Consultar NFSe por RPS', 'Codigo Verificação:',
        CodVerificacao)) then
        Exit;
    end;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
  begin
    ACBrNFSeX1.ConsultarNFSePorChave(CodVerificacao);
    ChecarResposta(tmConsultarNFSe,AID_NFVenda)
  end
  else
  begin
    ACBrNFSeX1.ConsultarNFSeporRps(NumeroRps, SerieRps, TipoRps,CodVerificacao);
    ChecarResposta(tmConsultarNFSePorRps,AID_NFVenda);
  end;
end;

procedure TDataModuleNFSeX.ConsultaSituacao(id_nfvenda, protocolo,
  num_lote: string);
begin
  ACBrNFSeX1.NotasFiscais.Clear;
  ConfigurarComponente(TVar_Dados_novo.TipoEnvio);
  ACBrNFSeX1.ConsultarSituacao(protocolo,num_lote);
  ChecarResposta(tmConsultarSituacao,FID_NFVenda);
end;

function TDataModuleNFSeX.ConverteEComercial(AConverter: string): string;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [
   proBetha,
   proSoftPlan]) then
  begin
    Result := StringReplace(AConverter, '&', 'E', [rfReplaceAll]);
  end
  else
    result := AConverter;
end;

function TDataModuleNFSeX.CopiarChaveXML(sXML, sChave: string): string;
begin
  Result := Copy(sXML,
                 Pos('<'+sChave+'>', sXML)+Length('<'+sChave+'>'),
                 Pos('</'+sChave+'>', sXML)-Pos('<'+sChave+'>', sXML)-Length('<'+sChave+'>'));
end;

procedure TDataModuleNFSeX.CorrigeEcomercial;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proActcon, proInfisc]) then
  begin
    ACBrNFSeX1.NotasFiscais[0].XmlNfse := StringReplace(ACBrNFSeX1.NotasFiscais[0].XmlNfse, '&amp;', '&', [rfReplaceAll]);
  end;
end;

constructor TDataModuleNFSeX.create(Sender: TObject; ConexaoVar: TFDConnection; IBTRANSACTION: TIBTransaction);
begin
  CoInitialize(nil);
  if ConexaoVar <> nil then
    ConexaoTemp := ConexaoVar;

  envioNFSe := False;
  AtualizaPathXML;

  if not DirectoryExists(FPathLogNFSe) then
    ForceDirectories(FPathLogNFSe);

  if not DirectoryExists(FPathGeral) then
    ForceDirectories(FPathGeral);

  TVar_Dados_novo.TipoEnvio := StrToIntDef(LeParametrizacao(ConexaoTemp, 'NFSE_METODO_PROVEDOR', 0), 0);
  //DataModuleCreate(Sender);
  TNFSe_Emitente := TNFSeEmitente.Create;
  TNFSeDados := TNFSe_Dados.Create;
  //TNFSeDados.s
end;


procedure TDataModuleNFSeX.DataModuleCreate(Sender: TObject);
begin


  if ConexaoTemp = nil then
    ConexaoTemp := Conexao;

  FDQueryV_NFSe := TIBQuery.Create(nil);
  FDQueryV_NFSe.Connection := ConexaoTemp;
  FDQueryV_NFSe.Transaction := DM.FDTransactionRead;

  FDQueryV_NFSeItem := TIBQuery.Create(nil);
  FDQueryV_NFSeItem.Connection := ConexaoTemp;
  FDQueryV_NFSeItem.Transaction := DM.FDTransactionRead;

  FDQueryNFSeItemDiscriminacao := TIBQuery.Create(nil);
  FDQueryNFSeItemDiscriminacao.Connection := ConexaoTemp;
  FDQueryNFSeItemDiscriminacao.Transaction := DM.FDTransactionRead;

  FDQueryCliente := TIBQuery.Create(nil);
  FDQueryCliente.Connection := ConexaoTemp;
  FDQueryCliente.Transaction := DM.FDTransactionRead;

  ACBrNFSeX1 := TACBrNFSeX.Create(nil);
  ACBrNFSeX1.Configuracoes.Geral.SSLLib := libNone;
  ACBrNFSeX1.Configuracoes.Geral.SSLCryptLib := cryNone;
  ACBrNFSeX1.Configuracoes.Geral.SSLHttpLib := httpNone;
  ACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := xsNone;
  ACBrNFSeX1.Configuracoes.Geral.FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';
  ACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := 0;
  ACBrNFSeX1.Configuracoes.Geral.Provedor := proNenhum;
  ACBrNFSeX1.Configuracoes.Geral.Versao := ve100;
  ACBrNFSeX1.Configuracoes.WebServices.UF := 'SP';
  ACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := 0;
  ACBrNFSeX1.Configuracoes.WebServices.QuebradeLinha := '|';
  ACBrNFSeX1.Configuracoes.Geral.Assinaturas := taConfigProvedor;
  ACBrNFSeX1.Configuracoes.Geral.ExibirErroSchema := True;
  ACBrNFSeX1.Configuracoes.Geral.FormaEmissao := teNormal;
  ACBrNFSeX1.Configuracoes.Geral.RetirarAcentos := True;
  ACBrNFSeX1.Configuracoes.Geral.RetirarEspacos := True;
  ACBrNFSeX1.Configuracoes.Geral.Salvar := True;
  ACBrNFSeX1.Configuracoes.Geral.ValidarDigest := True;


  ACBrNFSeXDANFSeFR1 := TACBrNFSeXDANFSeFR.Create(nil);
  ACBrNFSeXDANFSeFR1.Sistema := 'Zuccheti Sistemas';
  ACBrNFSeXDANFSeFR1.MargemInferior := 8.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemSuperior := 8.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemEsquerda := 6.000000000000000000;
  ACBrNFSeXDANFSeFR1.MargemDireita := 5.100000000000000000;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Altura := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esquerda := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Topo := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Largura := 0;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Dimensionar := False;
  ACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esticar := True;
  ACBrNFSeXDANFSeFR1.CasasDecimais.Formato := tdetInteger;
  ACBrNFSeXDANFSeFR1.CasasDecimais.qCom := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.vUnCom := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskqCom := ',0.00';
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskvUnCom := ',0.00';
  ACBrNFSeXDANFSeFR1.CasasDecimais.Aliquota := 2;
  ACBrNFSeXDANFSeFR1.CasasDecimais.MaskAliquota := ',0.00';
  ACBrNFSeXDANFSeFR1.ACBrNFSe := ACBrNFSeX1;
  ACBrNFSeXDANFSeFR1.Cancelada := False;
  ACBrNFSeXDANFSeFR1.Provedor := proNenhum;
  ACBrNFSeXDANFSeFR1.TamanhoFonte := 6;
  ACBrNFSeXDANFSeFR1.FormatarNumeroDocumentoNFSe := True;
  ACBrNFSeXDANFSeFR1.Producao := snSim;
  ACBrNFSeXDANFSeFR1.EspessuraBorda := 1;
  ACBrNFSeXDANFSeFR1.IncorporarFontesPdf := False;
  ACBrNFSeXDANFSeFR1.IncorporarBackgroundPdf := False;


  envioNFSe := False;
  AtualizaPathXML;

  if not DirectoryExists(FPathLogNFSe) then
    ForceDirectories(FPathLogNFSe);

  if not DirectoryExists(FPathGeral) then
    ForceDirectories(FPathGeral);

  TVar_Dados_novo.TipoEnvio := StrToIntDef(LeParametrizacao(Conexao, 'NFSE_METODO_PROVEDOR', 0), 0);
end;

procedure TDataModuleNFSeX.Cancelar_AssessorPublico;
var
  sRetorno: string;
  sMsg: String;
begin
  if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proAssessorPublico then
    Exit;

  sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.CancelaNFSe.ArquivoRetorno);
  sMsg := CopiarChaveXML(sRetorno, 'NOTA');

  if AnsiLowerCase(sMsg) = AnsiLowerCase('Nota Cancelada Com Sucesso') then
    TVar_Dados_novo.Situacao := SIT_Sucesso
  else
  begin
    //depois que cancelou retorna isso, ai é bom fazer consulta pelo lote
    if AnsiLowerCase(sMsg) = AnsiLowerCase('Nota Não Encontrada') then
    begin
      ACBrNFSeX1.ConsultarLoteRps(EmptyStr, ACBrNFSeX1.WebService.CancelaNFSe.InfCancelamento.NumeroLote);
      if (ACBrNFSeX1.WebService.ConsultaLoteRps.Sucesso) then
      begin
        sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.ConsultaLoteRps.ArquivoRetorno);
        sMsg := CopiarChaveXML(sRetorno, 'CANCELADA');
        if sMsg = DADO_SIM then
        begin
          TVar_Dados_novo.Situacao := SIT_Sucesso;
          Exit;
        end;
      end;
    end;

    TVar_Dados_novo.Situacao := SIT_Erro;
    TVar_Dados_novo.Mensagem := sMsg;
    TVar_Dados_novo.mensagemCompleta := sMsg;
  end;
end;

procedure TDataModuleNFSeX.Cancelar_EloTech;
var
  sRetorno: string;
  sMsg: String;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor <> proEloTech) and
     (TNFSe_Emitente.iid_Cidade <> Ponta_Grossa) then
    Exit;

  sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.CancelaNFSe.ArquivoRetorno);

  if Pos('ConfirmacaoCancelamento', sRetorno) > 0 then
  begin
    TVar_Dados_novo.Situacao := SIT_Sucesso;
    Exit;
  end;

  TVar_Dados_novo.Situacao := SIT_Erro;
  TVar_Dados_novo.Mensagem := sMsg;
  TVar_Dados_novo.mensagemCompleta := sMsg;
end;

procedure TDataModuleNFSeX.Cancelar_retorno;
var
  sRetorno: string;
  sMsg: String;
begin
  sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.CancelaNFSe.ArquivoRetorno);
  sMsg := CopiarChaveXML(sRetorno, 'situacao_descricao_nfse');

  if AnsiLowerCase(sMsg) = AnsiLowerCase('cancelada') then
    TVar_Dados_novo.Situacao := SIT_Sucesso
  else
  begin
    //depois que cancelou retorna isso, ai é bom fazer consulta pelo lote
    if AnsiLowerCase(sMsg) = AnsiLowerCase('Nota Não Encontrada') then
    begin
      ACBrNFSeX1.ConsultarLoteRps(EmptyStr, ACBrNFSeX1.WebService.CancelaNFSe.InfCancelamento.NumeroLote);
      if (ACBrNFSeX1.WebService.ConsultaLoteRps.Sucesso) then
      begin
        sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.ConsultaLoteRps.ArquivoRetorno);
        sMsg := CopiarChaveXML(sRetorno, 'CANCELADA');
        if sMsg = DADO_SIM then
        begin
          TVar_Dados_novo.Situacao := SIT_Sucesso;
          Exit;
        end;
      end;
    end;

    TVar_Dados_novo.Situacao := SIT_Erro;
    TVar_Dados_novo.Mensagem := sMsg;
    TVar_Dados_novo.mensagemCompleta := sMsg;
  end;
end;

function TDataModuleNFSeX.ErroLote_AssessorPublico: Boolean;
var
  sRetorno, sErro, sCorrecao: string;
  i, iOffset, iPosLink, iPosChave, iPosErro: Integer;
begin
  Result := False;
  if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proAssessorPublico then
    Exit;

  if ACBrNFSeX1.WebService.ConsultaLoteRps.Erros.Count <= 0 then
    Exit;

  sRetorno := Utf8ToAnsi(ACBrNFSeX1.WebService.ConsultaLoteRps.ArquivoRetorno);
  iOffset := 1;
  iPosLink := Pos('<LINK>', sRetorno, iOffset);

  if iPosLink > 0 then
  begin
    TVar_Dados_novo.Mensagem := EmptyStr;
    TVar_Dados_novo.Correcao := EmptyStr;
    TVar_Dados_novo.mensagemCompleta := EmptyStr;
    while iPosLink > 0 do
    begin
      iPosChave := Pos('<CHAVE>', sRetorno, iPosLink);
      iPosErro := Pos('<ERRO>', sRetorno, iPosLink);
      sErro := 'Campo ' + Copy(sRetorno,
                               iPosChave+Length('<CHAVE>'),
                               Pos('</CHAVE>', sRetorno, iPosLink)-iPosChave-Length('<CHAVE>')) + ' - ' +
                          Copy(sRetorno,
                               iPosErro+Length('<ERRO>'),
                               Pos('</ERRO>', sRetorno, iPosLink)-iPosErro-Length('<ERRO>'));
      TVar_Dados_novo.Mensagem := TVar_Dados_novo.Mensagem + ' ' + sErro;

      //ver se tem correção
      sCorrecao := EmptyStr;
      for I:=0 to pred(ACBrNFSeX1.WebService.ConsultaLoteRps.Erros.Count) do
      begin
        if Pos(ACBrNFSeX1.WebService.ConsultaLoteRps.Erros[i].Descricao, sErro) > 0 then
        begin
          if ACBrNFSeX1.WebService.ConsultaLoteRps.Erros[i].Correcao <> EmptyStr then
          begin
            sCorrecao := ACBrNFSeX1.WebService.ConsultaLoteRps.Erros[i].Correcao;
            TVar_Dados_novo.Correcao := TVar_Dados_novo.Correcao + ' ' + sCorrecao;
          end;

          Break;
        end;
      end;

      TVar_Dados_novo.mensagemCompleta := TVar_Dados_novo.mensagemCompleta +
                                          ' Erro: '+ sErro +sLineBreak+
                                          ' Correção :'+sCorrecao+sLineBreak;

      iOffset := iPosLink+1;
      iPosLink := Pos('<LINK>', sRetorno, iOffset);
    end;

    if TVar_Dados_novo.Situacao = EmptyStr then
      TVar_Dados_novo.Situacao := SIT_Erro; //para gravar o erro na base

    Result := True;
  end;
end;

function TDataModuleNFSeX.fGrava_Retorno(iId_nfvenda, sprotocolo, ssituacao,
  smensagem, sNfse_Numero, slink: string): boolean;
var QryUpdate : TIBQuery;
    param_protocolo : string;
begin
  if StrToBoolDef(TNFSeDados.NovoComponente, false) = True then
  begin
    if trim(sNfse_Numero) = '' then
      sNfse_Numero := '0';
    if Trim(sprotocolo) <> '' then
      param_protocolo := 'PROTOCOLO = :PROTOCOLO,';

    QryUpdate := CriaSQLQuery(nil,ConexaoTemp);
    QryUpdate.SQL.Text := 'update TB_NFSE set '+
                          'STATUS= :STATUS, STATUS_DESCRICAO = :STATUS_DESCRICAO, '+param_protocolo+' NFS_NUMERO = :NFS_NUMERO '+
                          'where ID_NFVENDA = '+QuotedStr(iId_nfvenda);

    QryUpdate.ParamByName('STATUS').AsString           := sSituacao;
    QryUpdate.ParamByName('STATUS_DESCRICAO').AsString := Copy(sMensagem,0,149);
    if trim(sProtocolo) <> '' then
      QryUpdate.ParamByName('PROTOCOLO').AsString        := sProtocolo;
    QryUpdate.ParamByName('NFS_NUMERO').AsString       := sNfse_Numero;
    QryUpdate.ExecSQL;
    FreeAndNil(QryUpdate);
    {2022-05-11 - #9684 - Ficha 12332 - Renan}
    if (TVar_Dados_Novo.Link_Nfse <> '') or (slink <> '') then
    begin
      qryUpdate := CriaSQLQuery(nil,ConexaoTemp);
      qryUpdate.ExecSQL('update TB_NFVENDA set INF_COMP_FIXA = '+QuotedStr(sLink)+' where ID_NFVENDA = '+QuotedStr(iId_NFvenda));
      FreeAndNil(qryUpdate);
    end;
  end
  else
  begin
    if trim(TVar_Dados_Novo.Nfse_Numero) = '' then
      TVar_Dados_Novo.Nfse_Numero := '0';

    QryUpdate := CriaSQLQuery(nil,ConexaoTemp);
    QryUpdate.SQL.Text := 'update TB_NFSE set '+
                          'STATUS= :STATUS, STATUS_DESCRICAO = :STATUS_DESCRICAO, PROTOCOLO = :PROTOCOLO, NFS_NUMERO = :NFS_NUMERO '+
                          'where ID_NFVENDA = '+QuotedStr(iId_nfvenda);

    QryUpdate.ParamByName('STATUS').AsString           := TVar_Dados_Novo.Situacao;
    QryUpdate.ParamByName('STATUS_DESCRICAO').AsString := Copy(TVar_Dados_Novo.Mensagem,0,149);
    QryUpdate.ParamByName('PROTOCOLO').AsString        := TVar_Dados_Novo.Protocolo;
    QryUpdate.ParamByName('NFS_NUMERO').AsString       := TVar_Dados_Novo.Nfse_Numero;
    QryUpdate.ExecSQL;
    FreeAndNil(QryUpdate);
    if TVar_Dados_Novo.Link_Nfse <> '' then
    begin
      qryUpdate := CriaSQLQuery(nil,ConexaoTemp);
      qryUpdate.ExecSQL('update TB_NFVENDA set INF_COMP_FIXA = '+QuotedStr(TVar_Dados_Novo.Link_Nfse)+' where ID_NFVENDA = '+QuotedStr(iId_NFvenda));
      FreeAndNil(qryUpdate);
    end;
  end;
end;

function TDataModuleNFSeX.fImprime_Danfsex(sNumero, sSerie, sNumero_Lote: string; dataEmissao: TDate;
  bVisualiza: boolean; AObservacao, AOutrasInformacoes, AIEProdutorRural: String;
  iNumCopias: integer = 1;
  AImprime : boolean = True): boolean;
var
  sPathXML: string;
begin
  ConfigurarComponente(TVar_Dados_novo.TipoEnvio);
  TVar_Dados_novo.Nfse_Numero := sNumero;
  TVar_Dados_novo.Nfse_Serie := sSerie;

  if (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(sNumero) + sSerie+'-nfse.xml', False)) and
     (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(sNumero)+'-nfse.xml', False)) and
     (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+sSerie+'-nfse.xml', False)) and
     (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'00000-nfse.xml', False)) and
     (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'1-nfse.xml', False)) and
     (not FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero_Lote+'-nfse.xml', False)) and
     (not (FilesExists(FPathXMLs + 'logNFSe\Geral\Recibos\'+sNumero+sSerie+'-rps.xml')) and
     (ACBrNFSeX1.Configuracoes.Geral.Provedor = proInfisc)) then
  begin
    OpenDialog1 := TOpenDialog.Create(nil);
    OpenDialog1.Title      := 'Selecione a NFSe';
    OpenDialog1.DefaultExt := '*-NFSe.xml';
    OpenDialog1.Filter     := 'Arquivos NFSe (*-NFSe.xml)|*-NFSe.xml|Arquivos XML (*.xml)|*.xml|Todos os Arquivos (*.*)|*.*';
    OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'logNFSe\';

    if OpenDialog1.Execute then
    begin
      if bVisualiza then
        ACBrNFSeXDANFSeFR1.MostraPreview := true
      else
        ACBrNFSeXDANFSeFR1.MostraPreview := False;
      ACBrNFSeX1.NotasFiscais.Clear;
      ACBrNFSeX1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

      if ACBrNFSeX1.Configuracoes.Geral.Provedor = proWebISS then
        ACBrNFSeXDANFSeFR1.Provedor := proWebISS;
      if ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Producao = snNao then
        ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes := 'NFSE EMITIDA NO AMBIENTE DE HOMOLOGAÇÃO – ESTA NOTA NÃO POSSUI VALIDADE FISCAL';

      if pos(AObservacao, ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes) = 0 then
        ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes :=
          ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes+#13+
          AObservacao;

      ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes :=
        ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes+#13+
        AOutrasInformacoes;

      CorrigeEcomercial;

      ACBrNFSeX1.NotasFiscais.Imprimir;
      ACBrNFSeX1.NotasFiscais.ImprimirPDF;
    end;
    FreeAndNil(OpenDialog1);
  end
  else
  begin
    ACBrNFSeX1.NotasFiscais.Clear;
    if FilesExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(sNumero) + sSerie+'-nfse.xml') then
      sPathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+LimpaNumero(sNumero) + sSerie+'-nfse.xml'
    else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+sSerie+'-nfse.xml') then
      sPathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+sSerie+'-nfse.xml'
    else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'00000-nfse.xml') then
      sPathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'00000-nfse.xml'
    else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'1-nfse.xml') then
      sPathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'1-nfse.xml'
    else if (FilesExists(FPathXMLs + 'logNFSe\Geral\Recibos\'+sNumero+sSerie+'-rps.xml')) and
       (ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc,proGoverna]) then
      sPathXML := FPathXMLs + 'logNFSe\Geral\Recibos\'+sNumero+sSerie+'-rps.xml'
    else if FileExists(FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'-nfse.xml') then
      sPathXML := FPathXMLs + 'logNFSe\NFSe\Notas\'+sNumero+'-nfse.xml'
    else
      sPathXML := FPathXMLs +'logNFSe\NFSe\Notas\'+LimpaNumero(sNumero)+'-nfse.xml';

    ACBrNFSeX1.NotasFiscais.LoadFromFile(sPathXML, False);

    CorrigeEcomercial;

    if bVisualiza then
      ACBrNFSeXDANFSeFR1.MostraPreview := true
    else
      ACBrNFSeXDANFSeFR1.MostraPreview := False;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proWebISS then
      ACBrNFSeXDANFSeFR1.Provedor := proWebISS;

    if ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Producao = snNao then
      ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes := 'NFSE EMITIDA NO AMBIENTE DE HOMOLOGAÇÃO – ESTA NOTA NÃO POSSUI VALIDADE FISCAL';

    (*#16619 - 2023-07-07*)
    //if ACBrNFSeX1.Configuracoes.Geral.Provedor <> proISSNet then
    //begin
      // #17638 - Sergio - 29/08/23
      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) then
      begin
        var ObsIPM, ObsXml : String;

        ObsIPM:= TFuncao.Texto.RemoveAcento(Copy(AObservacao,1,60));
        ObsIPM:= TFuncao.Texto.RetiraCaracteres(ObsIPM);
        ObsIPM:= TFuncao.Texto.SoLetrasENumeros(ObsIPM, False);

        ObsXml:= TFuncao.Texto.RemoveAcento(ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes);
        ObsXml:= TFuncao.Texto.RetiraCaracteres(ObsXml);
        ObsXml:= TFuncao.Texto.SoLetrasENumeros(ObsXml, False);

        if pos(ObsIPM, ObsXml) = 0 then
          ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes :=
            ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes+sLineBreak+
            AObservacao;
      end
      else
      begin
        if pos(trim(TFuncao.Texto.RemoveAcento(copy(AObservacao,0,40))),
               trim(TFuncao.Texto.RemoveAcento(copy(ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes,0,40)))) = 0 then
          ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes :=
            ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes+#13+
            AObservacao;
      end;
    //end;

    ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes :=
      ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes+#13+
      AOutrasInformacoes;

    ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes := StringReplace(ACBrNFSeX1.NotasFiscais[0].NFSe.OutrasInformacoes, '\s\n', '', [rfReplaceAll]);

    {2022-05-16 - #10018 - Impressao apos autorizacao Novo metodo DANFSE - Renan}
    ACBrNFSeXDANFSeFR1.NumCopias := iNumCopias;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSJoinville,
      proBetha,
      proEL,
      proIPM,
      proAssessorPublico,
      proISSNet,
      proISSDSF,
      proISSGoiania,
      proGoverna,
      proEloTech,
      proPadraoNacional,
      proSoftPlan,
      proTinus,
      proISSCuritiba,
      proMegaSoft,
      proCoplan]
    then
      CarregaInfManual(AIEProdutorRural);

    if (TVar_Dados_Novo.Nfse_Numero = '0') or (TVar_Dados_Novo.Nfse_Numero = EmptyStr) then
      MensagemAlerta('O provedor ainda não processou a nota, por isso o número da nota não foi gerado.' + #13 + #13 +
                     'Utilize a opção Consulta NFSe e faça a impressão. Caso o número da nota ainda não está disponível, faça nova consulta mais tarde.' + #13 + #13 +
                     'Obs: Notas sem número mas com número do RPS também são válidas.');


    if AImprime then
      ACBrNFSeX1.NotasFiscais.Imprimir;
    ACBrNFSeX1.NotasFiscais.ImprimirPDF;
  end;
end;

procedure TDataModuleNFSeX.FixIPMGravataiUrl(var AUrl: string);
begin
  if pos('gravatai', AUrl) = 0 then
    Exit;

  AUrl := StringReplace(AUrl,
    'https://ws-gravatai.atende.net', 'https://gravatai.atende.net', []
  );
end;

function TDataModuleNFSeX.getCodigoTributacaoMunicipio: string;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) and
     (StrToBoolDef(TNFSeDados.CodLST_CodTributacao,false) = True) then
    Exit(LimpaNumero(FDQueryV_NFSe.FieldByName('COD_LST').AsString));
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proPadraoNacional then
    Exit(EmptyStr);
  Exit(FDQueryV_NFSe.FieldByName('COD_TRIBUTACAO').AsString);
end;

function TDataModuleNFSeX.getIdentificacaoRpsSerie(
  ADefaultSerie: String): String;
begin
   if ACBrNFSeX1.Configuracoes.Geral.LayoutNFSe = lnfsPadraoNacionalv1 then
    Exit('1');

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proNFSeBrasil, proEquiplano]) then
    Exit('900');

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSudoeste then
    Exit('E');

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proNFSeBrasil, proEquiplano]) then
    Exit('1');

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in ([proISSDSF, proSiat]) then
    Exit('NF');

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) then
  begin
    //#10208 - Anderson - Lucas do Rio Verde usar o do cadastro da série (geralmente 1)
    if GetCodigoMunicipioServico <> Lucas_Do_Rio_Verde then
      Exit(ADefaultSerie);

    Exit('NF');
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet then
  begin
    if ACBrNFSeX1.Configuracoes.WebServices.Ambiente = taProducao then
      Exit(ADefaultSerie);   //#14273 - Anderson

    Exit('8');
  end;

  Exit(ADefaultSerie);
end;

function TDataModuleNFSeX.getNumeroNfse: String;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) or
     (ACBrNFSeX1.Configuracoes.Geral.Provedor = proGoverna) then
  begin
    (*#15259 - 2023-04-06*)
    if TVar_Dados_novo.Nfse_Numero_Origem <> '' then
      Exit(TVar_Dados_novo.Nfse_Numero_Origem);

    Exit(ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero);
  end;

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSJoinville) then
    Exit(TVar_Dados_novo.Nfse_Numero);

  Exit(ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero);
end;

function TDataModuleNFSeX.getRegimeApuracaoSN: TRegimeApuracaoSN;
  var
  CodigoRegimeApuracao: String;
  Ok: Boolean;
begin
  CodigoRegimeApuracao := LeParametrizacao(Conexao, 'NFSE_APURACAO_SN', 0);
  if CodigoRegimeApuracao = '' then
    Exit(StrToRegimeApuracaoSN(OK,'0'));

  CodigoRegimeApuracao := Copy(CodigoRegimeApuracao, 1, 1);

  Exit(StrToRegimeApuracaoSN(Ok, TFuncao.Numero.SoNumero(CodigoRegimeApuracao)));
end;

function TDataModuleNFSeX.getRegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
var
  CodigoRegimeTributacao: String;
  Ok: Boolean;
begin
  CodigoRegimeTributacao := LeParametrizacao(ConexaoTemp, 'NFSE_REGIME_TRIBUT', 0);
  if CodigoRegimeTributacao = '' then
    Exit(StrToRegimeEspecialTributacao(OK,'0'));

  CodigoRegimeTributacao := Copy(CodigoRegimeTributacao, 1, 3);

  Exit(StrToRegimeEspecialTributacao(Ok, TFuncao.Numero.SoNumero(CodigoRegimeTributacao)));
end;


function TDataModuleNFSeX.getSituacao: String;
begin
  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proIPM) and
     (TVar_Dados_novo.mensagemCompleta = '') and
     (TVar_Dados_novo.Situacao = '1') then
    Exit(SIT_Sucesso);

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proEL) and
     (TVar_Dados_novo.mensagemCompleta = '') and
     (TVar_Dados_novo.Situacao = 'A') then
    Exit(SIT_Sucesso);

  if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proPronim) and
     (TVar_Dados_novo.mensagemCompleta = '') and
     (TVar_Dados_novo.Situacao = '') then
    Exit(SIT_Sucesso);

  Exit(TVar_Dados_novo.Situacao);
end;

function TDataModuleNFSeX.getTipoCliente(ACnpjCPF: String): TTipoPessoa;
begin
  if Length(TFuncao.Numero.LimpaNumero(ACnpjCpf)) = CNPJ_TAMANHO then
    Exit(tpPJdoMunicipio)
  else
    Exit(tpPF);
end;

function TDataModuleNFSeX.getTipoEnvio(tipoEnvio: integer): TmodoEnvio;
begin
  result :=  meAutomatico;
  case tipoEnvio of
    0 : result :=  meAutomatico;
    1 : result :=  meLoteSincrono;
    2 : result :=  meUnitario;
    3 : result :=  meLoteAssincrono;
  end;
end;

procedure TDataModuleNFSeX.LoadXML(RetWS: String; MyWebBrowser: TWebBrowser;
  NomeArq: string);
begin
  ACBrUtil.WriteToTXT(PathWithDelim(ExtractFileDir(application.ExeName)) + NomeArq,AnsiString(RetWS), False, False);
  MyWebBrowser.Navigate(PathWithDelim(ExtractFileDir(application.ExeName)) + NomeArq);
  sleep(500);
end;

{ TVar_Dados }

class procedure TVar_Dados_novo.fLimpa_VarDados;
begin
  Protocolo      := '';
  Mensagem       := '';
  Correcao       := '';
  Situacao       := '';
  cancelada      := False;
  codverificacao := '';
  mensagemCompleta := '';
end;

end.
