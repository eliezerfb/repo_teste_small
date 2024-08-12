unit uSmallNFSe;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics, Controls, Forms,
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
    FsCNPJ: String;
    FsInscricao_Municipal: String;
    FsRazao_Social: String;
    FsNome_Fantasia: String;
    FsUF: String;
    FsEnd_Logradouro: String;
    FsEnd_Numero: String;
    FsEnd_Bairro: String;
    Fcidade: String;
    FsEmail: String;
    FendComplemento: String;
  public
    property iid_Cidade: String read Fiid_Cidade write Fiid_Cidade;
    property sCnae: String read FsCnae write FsCnae;
    property sEnd_Cep: String read FsEnd_Cep write FsEnd_Cep;
    property sSimples_Nacional: String read FsSimples_Nacional write FsSimples_Nacional;
    property sFone_Comer: String read FsFone_Comer write FsFone_Comer;
    property sTelefone: String read FsTelefone write FsTelefone;
    property sCNPJ: String read FsCNPJ write FsCNPJ;
    property sInscricao_Municipal: String read FsInscricao_Municipal write FsInscricao_Municipal;
    property sRazao_Social: String read FsRazao_Social write FsRazao_Social;
    property sNome_Fantasia: String read FsNome_Fantasia write FsNome_Fantasia;
    property sUF: String read FsUF write FsUF;
    property sEnd_Logradouro: String read FsEnd_Logradouro write FsEnd_Logradouro;
    property sEnd_Numero: String read FsEnd_Numero write FsEnd_Numero;
    property sEnd_Bairro: String read FsEnd_Bairro write FsEnd_Bairro;
    property cidade: String read Fcidade write Fcidade;
    property sEmail: String read FsEmail write FsEmail;
    property endComplemento: String read FendComplemento write FendComplemento;
  end;

  {
  NFSe_Dados = class
  private
    FsCNAEZerado: String;
    FsForma_Recolhimento: String;
    FsBCISS_Zerado: String;
    FsListaServ: String;
    FsImprime_Danfse: String;
    FiNum_Copias: Integer;
    FimpPrefeitura: String;
  public
    property sCNAEZerado: String read FsCNAEZerado write FsCNAEZerado;
  end;
  }

  TNFSeDados = class
  public
    //Variaveis
    class var sarqIni,
              sLogo_Marca_Prefeitura,
              sPrefeitura,
              sSenhaWeb,
              sUser_Web,
              sFraseSecreta,
              sChaveAcesso,
              sChaveAutorizacao,
              sProxyPorta,
              sProxyHost,
              sProxy_User,
              sProxy_Senha,
              sEnviar_nota,
              sImprime_Danfse,
              sEnvia_Email   : string;
              sEnvia_Whats,
              sEnvia_Messenger,
              sExigeISS,
              iListaServ,
              sListaServ,
              sIncent_Cultural,
              sRegime_Tributacao,
              sRegime_Recolhimento,
              sForma_Recolhimento,
              sRegime_ApuracaoSN,
              sCod_Tributacao,
              sProvedor_Selecionado,
              //Certificado
              sSenha_Certificado,
              sNumero_serie,
              sCaminhoCertificado,
              sAmbiente,
              //tributos
              sPerc_INSS,
              sPerc_csll,
              sPerc_COFINS,
              sPerc_PIS,
              sPerc_IR,
              sValor_Tributos,
              sParcela_Diveregente,
              sBCISS_Zerado,
              //Limites para tributa  o
              sTeto_INSS,
              sTeto_COFINS,
              sTeto_PIS,
              sTeto_IR,
              steto_CSLL,
              sVisualizar_Mensagem,
              sDiminuir_Impostos,
              Diminuir_ISS,
              sInformar_ISSRetido_normal,
              STipoImpressao,
              sSalvar_Soap,
              sCNAEZerado,
              infCidadePrefeitura,
              impPrefeitura,
              CodLST_CodTributacao,
              SchemasManual,
              CaminhoSchemasManual,
              NovoComponente,
              ConsideraDescontoBaseISS ,
              Layout,
              ConsideraBCISSImpostosFederais,
              CodAutorizacaoRPS: String;

              //Impress o
              SSLLIB,
              CRYPTLIB,
              HTTPLIB,
              XMLSIGNLIB,
              SSLTYPE,
              iNum_Copias: integer;
              imprimirCanhoto,
              AddQtdVlUnitDiscriminacao,
              AdicionaObsNosItens : Boolean;
    //Fun  es e procedures
    class procedure Carrega_ConfigIni;
//    class procedure Carrega_base;
//    class procedure Carrega_Dados_Envio;
//    class procedure pFvalida_Nfse;
//    function RoundTo5(Valor: Double; Casas: Integer): Double;
//    class function Codigo_UF(UF: String) : integer;
//    class function Zeros_Direita(sEntrada : string; iQtdZeros : integer) : string;
//    class procedure ResizeComp(aComp: Tcomponent); // redimesiona apenas um component - Maiquel 11/11/2016
//    class procedure ResizeCompAll(aComp: Tcomponent); // redimesiona todos os componentes - Maiquel 11/11/2016
//    class procedure pChamaGrid(component_Grid, componente_parametro : TComponent);//mostra o grid com um outro componente como par metro - Maiquel 11/11/2016
//    class Function AtribuiCFPS(aIdCidade : string; ConexaoTemp : TFDConnection) : string;
//    class Function AtribuiNatOp(cfps : string) : integer;
  end;



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
    FACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL;
    FACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR;
    FACBrMail1: TACBrMail;
    FIBTRANSACTION: TIBTransaction;
    FIBQNFSE: TIBQuery;
    FIBQEMITENTE: TIBQuery;
    TNFSe_Emitente: TNFSeEmitente;
    procedure ACBrNFSeX1GerarLog(const ALogLine: string; var Tratado: Boolean);
    procedure ACBrNFSeX1StatusChange(Sender: TObject);
    function GetCodigoMunicipioServico: String;
    function GetCidade_Goiania(id_cidade: string): string;
    function GetCodigoCNAE: String;
    procedure SetIBTRANSACTION(const Value: TIBTransaction);
    procedure SelecionarDadosEmitente;
  public
    property ACBrNFSeX: TACBrNFSeX read FACBrNFSeX1 write FACBrNFSeX1;
    //property ACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL read FACBrNFSeXDANFSeRL1 write FACBrNFSeXDANFSeRL1;
    //property ACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR read FACBrNFSeXDANFSeFR1 write FACBrNFSeXDANFSeFR1;
    property ACBrMail1: TACBrMail read FACBrMail1 write FACBrMail1;
    property IBTRANSACTION: TIBTransaction read FIBTRANSACTION write SetIBTRANSACTION;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;
    function ConfigurarComponente: Boolean;
  end;

const
  Lucas_Do_Rio_Verde = '5105259';
  Ponta_Grossa = '4119905';


//  SIT_Lote_Processamento = '2';
//  SIT_Erro = '3';
//  SIT_Sucesso = '4';
//  PROC_Sucesso = 'Processado com sucesso';

implementation

uses
  //uFuncoesC4, C4Funcoes30, uConstantes, blcksock, UFuncNFSe, ufrmStatus, udm;

  Frm_Status, smallfunc_xe, uConectaBancoSmall;

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
  FastFile: String;
  sCaminhoXMLs: String;
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


  {Explicação sobre uso de Reports do Acbr no sistema

  Reports do Acbr   X Descricao no sitema X Nome do report enviado no Pack
  DANFSE.fr3        X Padrão              X DANFSE.fr3
  DANFSeNovo.fr3    X Detalhada           X DANFSEDetalhada.fr3
  DANFSEPadrao.fr3  X Detalhada com itens X DANFSEDetalhada_itens.fr3}

  FACBrNFSeXDANFSeFR1.ACBrNFSe := ACBrNFSeX;
  {
  if TNFSeDados.STipoImpressao = 'Padrão' then
    ACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSE'
  else if TNFSeDados.STipoImpressao = 'Detalhada com itens' then
     ACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSEDetalhada_itens'
  else
  }
    FACBrNFSeXDANFSeFR1.FastFile := ExtractFilePath(Application.ExeName)+'DANFSEDetalhada';

  FastFile := FACBrNFSeXDANFSeFR1.FastFile +
     LimpaNumero(FIBQEMITENTE.FieldByName('CGC').AsString)+'.fr3';

  if FileExists(FastFile) then
    FACBrNFSeXDANFSeFR1.FastFile := FastFile
  else
    FACBrNFSeXDANFSeFR1.FastFile := FACBrNFSeXDANFSeFR1.FastFile+'.fr3';


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

  TNFSe_Emitente := TNFSeEmitente.Create;

  FACBrNFSeX1 := TACBrNFSeX.Create(nil);
  FACBrNFSeXDANFSeRL1 := TACBrNFSeXDANFSeRL.Create(nil);
  FACBrNFSeXDANFSeFR1 := TACBrNFSeXDANFSeFR.Create(nil);
  FACBrMail1 := TACBrMail.Create(nil);
  FACBrNFSeX1.OnGerarLog := ACBrNFSeX1GerarLog;
  FACBrNFSeX1.OnStatusChange := ACBrNFSeX1StatusChange;
  FACBrNFSeX1.DANFSE := FACBrNFSeXDANFSeFR1;//FACBrNFSeXDANFSeRL1;
  FACBrNFSeX1.MAIL := FACBrMail1;
  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfseConfig.ini');
  TipoEnvio := meLoteAssincrono;

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
  FACBrNFSeXDANFSeFR1.MargemInferior := 8.000000000000000000;
  FACBrNFSeXDANFSeFR1.MargemSuperior := 8.000000000000000000;
  FACBrNFSeXDANFSeFR1.MargemEsquerda := 6.000000000000000000;
  FACBrNFSeXDANFSeFR1.MargemDireita := 5.100000000000000000;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Altura := 0;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esquerda := 0;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Topo := 0;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Largura := 0;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Dimensionar := False;
  FACBrNFSeXDANFSeFR1.ExpandeLogoMarcaConfig.Esticar := True;
  FACBrNFSeXDANFSeFR1.CasasDecimais.Formato := tdetInteger;
  FACBrNFSeXDANFSeFR1.CasasDecimais.qCom := 2;
  FACBrNFSeXDANFSeFR1.CasasDecimais.vUnCom := 2;
  FACBrNFSeXDANFSeFR1.CasasDecimais.MaskqCom := ',0.00';
  FACBrNFSeXDANFSeFR1.CasasDecimais.MaskvUnCom := ',0.00';
  FACBrNFSeXDANFSeFR1.CasasDecimais.Aliquota := 2;
  FACBrNFSeXDANFSeFR1.CasasDecimais.MaskAliquota := ',0.00';
  FACBrNFSeXDANFSeFR1.ACBrNFSe := FACBrNFSeX1;
  FACBrNFSeXDANFSeFR1.Cancelada := False;
  FACBrNFSeXDANFSeFR1.Provedor := proNenhum;
  FACBrNFSeXDANFSeFR1.TamanhoFonte := 6;
  FACBrNFSeXDANFSeFR1.FormatarNumeroDocumentoNFSe := True;
  FACBrNFSeXDANFSeFR1.Producao := snSim;
  FACBrNFSeXDANFSeFR1.EspessuraBorda := 1;
  FACBrNFSeXDANFSeFR1.IncorporarFontesPdf := False;
  FACBrNFSeXDANFSeFR1.IncorporarBackgroundPdf := False;
end;

destructor TNFS.Destroy;
begin
  FreeAndNil(FACBrNFSeXDANFSeRL1);
  FreeAndNil(FACBrNFSeXDANFSeFR1);
  FreeAndNil(FACBrMail1);
  FreeAndNil(FACBrNFSeX1);
  FreeAndNil(FIniNFSe);
  TNFSe_Emitente.Free;

  inherited;
end;

function TNFS.GetCidade_Goiania(id_cidade: string): string;
var
  qryConsulta : TIBQuery;
begin

  //Goiânia utiliza código específico - Emitente
  QryConsulta := CriaIBQuery(FIBQNFSE.Transaction);
  try
    //QryConsulta.Connection := ConexaoTemp;
    QryConsulta.Close;
    QryConsulta.SQL.Text :=
      'select CODIGO_SEDETEC from MUNICIPIOS where CODIGO = '+QuotedStr(id_cidade);
    QryConsulta.Open;
    if QryConsulta.IsEmpty then
      Exit(id_cidade);

    Exit(QryConsulta.FieldByName('CODIGO_SEDETEC').AsString);
  finally
    QryConsulta.Free;
  end;

end;

function TNFS.GetCodigoCNAE: String;
begin
  if not(FACBrNFSeX1.Configuracoes.Geral.Provedor = proSystemPro) then
    Result := TNFSe_Emitente.sCnae;

  //#10208 - Anderson - Betha e Lucas do Rio Verde não pode enviar CNAE
  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proBetha) and
     (GetCodigoMunicipioServico = Lucas_Do_Rio_Verde) or
     (StrToBoolDef(TNFSeDados.sCNAEZerado, false) = true) then
    Result := EmptyStr;

  //#14273 - Anderson
  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) and
     (FDQueryV_NFSeItem.FieldByName('CNAE').AsString <> EmptyStr) then
    Result := FDQueryV_NFSeItem.FieldByName('CNAE').AsString;


  //#13997 - Anderson > internamente na AssessorPublico.GravarXml é convertido para ATIVIDADE
  if FACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico, proSoftPlan] then
	  Result := FDQueryV_NFSe.FieldByName('cod_lst').AsString;

end;

function TNFS.GetCodigoMunicipioServico: String;
begin
  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNET) and (FACBrNFSeX1.Configuracoes.WebServices.Ambiente = taHomologacao) then
    Exit('999'); // Para o provedor ISS.NET em ambiente de Homologação  o Codigo do Municipio tem que ser '999'

  if not(FIBQEMITENTE.FieldByName('CODIGO_IBGE').IsNull) then
  begin
    if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
      Exit(GetCidade_Goiania(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString));

    Exit(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString);
  end;

//  if FIBQEMITENTE.FieldByName('CODIGO_NATOPE').AsString = '2' then
//  begin
//    if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
//      Exit(GetCidade_Goiania(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString));
//
//    Exit(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString);
//  end;

  if (FACBrNFSeX1.Configuracoes.Geral.Provedor = proISSGoiania) then
    Exit(GetCidade_Goiania(TNFSe_Emitente.iid_Cidade));

  Exit(TNFSe_Emitente.iid_Cidade);

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
    TNFSe_Emitente.sCnae  := FIBQEMITENTE.FieldByName('CNAE').AsString;
    TNFSe_Emitente.sEnd_Cep := FIBQEMITENTE.FieldByName('CEP').AsString;
    TNFSe_Emitente.sSimples_Nacional := IfThen(FIBQEMITENTE.FieldByName('CRT').AsString = '1', 'Sim', 'Não');
    TNFSe_Emitente.sFone_Comer := FIBQEMITENTE.FieldByName('TELEFO').AsString;
    TNFSe_Emitente.sTelefone := FIBQEMITENTE.FieldByName('TELEFO').AsString;
    TNFSe_Emitente.sCNPJ := FIBQEMITENTE.FieldByName('').AsString;
    TNFSe_Emitente.sInscricao_Municipal := FIBQEMITENTE.FieldByName('IM').AsString;
    TNFSe_Emitente.sRazao_Social := FIBQEMITENTE.FieldByName('NOME').AsString;
    TNFSe_Emitente.sNome_Fantasia := FIBQEMITENTE.FieldByName('NOME').AsString;
    TNFSe_Emitente.sUF := FIBQEMITENTE.FieldByName('ESTADO').AsString;
    TNFSe_Emitente.sEnd_Logradouro := ExtraiEnderecoSemONumero(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    TNFSe_Emitente.sEnd_Numero := ExtraiNumeroSemOEndereco(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    TNFSe_Emitente.sEnd_Bairro := FIBQEMITENTE.FieldByName('COMPLE').AsString;
    TNFSe_Emitente.cidade := FIBQEMITENTE.FieldByName('MUNICIPIO').AsString;
    TNFSe_Emitente.sEmail := FIBQEMITENTE.FieldByName('EMAIL').AsString;
    TNFSe_Emitente.endComplemento := '';
end;

procedure TNFS.SetIBTRANSACTION(const Value: TIBTransaction);
begin
  FIBTRANSACTION := Value;

  FIBQNFSE := CriaIBQuery(FIBTRANSACTION);
end;

{ TVar_Dados_novo }

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

{ TNFSeDados }

class procedure TNFSeDados.Carrega_ConfigIni;
begin

end;

end.
