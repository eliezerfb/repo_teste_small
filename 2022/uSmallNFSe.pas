unit uSmallNFSe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ShellAPI, XMLIntf, XMLDoc, zlib, System.IniFiles, System.Math,
  Winapi.ActiveX,
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
  //ACBrNFSeXDANFSeRLClass,
  ACBrNFSeXDANFSeFR,
  ACBrNFSeXWebserviceBase

  ;

type
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

implementation

uses
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

(*
class function TNFS.ConfigurarComponente(ACBrNFSe: TACBrNFSeX;
  IBTRANSACTIONBASE: TIBTransaction): TACBrNFSeX;
var
  Ok: Boolean;
  PathMensal: String;
  FIniNFSe: TIniFile;
  StreamMemo: TMemoryStream;
  iAguardar: Integer;
  iIntervalo: Integer;
  FIBQEMITENTE: TIBQuery;
  FIBQMUNICIPIO: TIBQuery;
begin

  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

  FIBQEMITENTE   := CriaIBQuery(IBTRANSACTIONBASE);
  SelecionarDadosEmitente(FIBQEMITENTE);
  {
  FIBQEMITENTE.SQL.Text :=
    'select E.CGC, E.IM, E.NOME, E.IE, E.ENDERECO, E.CEP, E.COMPLE, E.MUNICIPIO, E.ESTADO, ' +
    'E.TELEFO, E.EMAIL, ' +
    'M.CODIGO as CODIGO_IBGE ' +
    'from EMITENTE E ' +
    'left join MUNICIPIOS M on M.NOME = E.MUNICIPIO and M.UF = E.ESTADO';
  FIBQEMITENTE.Open;
  }
  FIBQMUNICIPIO   := CriaIBQuery(IBTRANSACTIONBASE);
  {
  FIBQMUNICIPIO.SQL.Text :=
    'select M.CODIGO as CODIGO_IBGE ' +
    'from MUNICIPIOS M ' +
    'where M.NOME = ' + QuotedStr(FIBQEMITENTE.FieldByName('MUNICIPIO').AsString) + ' and M.UF = ' + QuotedStr(FIBQEMITENTE.FieldByName('MUNICIPIO').AsString);
  FIBQMUNICIPIO.Open;
  }


  ACBrNFSe.Configuracoes.Certificados.ArquivoPFX  := '';
  ACBrNFSe.Configuracoes.Certificados.Senha       := '';
  ACBrNFSe.Configuracoes.Certificados.NumeroSerie := '';

  ACBrNFSe.Configuracoes.Certificados.ArquivoPFX  := FIniNFSe.ReadString( 'Certificado', 'Caminho',    '');
  ACBrNFSe.Configuracoes.Certificados.Senha       := FIniNFSe.ReadString( 'Certificado', 'Senha',      '');
  ACBrNFSe.Configuracoes.Certificados.NumeroSerie := FIniNFSe.ReadString( 'Certificado', 'NumSerie',   '');

  //ACBrNFSe.SSL.DescarregarCertificado;

  //with ACBrNFSe.Configuracoes.Geral do
  begin
    ACBrNFSe.Configuracoes.Geral.SSLLib        := TSSLLib(FIniNFSe.ReadInteger('Certificado', 'SSLLib',     4));
    ACBrNFSe.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib(FIniNFSe.ReadInteger('Certificado', 'CryptLib',   3));
    ACBrNFSe.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib(FIniNFSe.ReadInteger('Certificado', 'HttpLib',    2));
    ACBrNFSe.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(FIniNFSe.ReadInteger('Certificado', 'XmlSignLib', 0));

    //AtualizarSSLLibsCombo;

    ACBrNFSe.Configuracoes.Geral.Salvar           := FIniNFSe.ReadBool('Geral', 'Salvar',         True);
    ACBrNFSe.Configuracoes.Geral.ExibirErroSchema := FIniNFSe.ReadBool('Geral', 'ExibirErroSchema', True);
    ACBrNFSe.Configuracoes.Geral.RetirarAcentos   := FIniNFSe.ReadBool('Geral', 'RetirarAcentos', True);
    ACBrNFSe.Configuracoes.Geral.FormatoAlerta    := FIniNFSe.ReadString('Geral', 'FormatoAlerta', 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
    ACBrNFSe.Configuracoes.Geral.FormaEmissao     := TpcnTipoEmissao(FIniNFSe.ReadInteger('Geral', 'FormaEmissao', 0)); // 0-Normal

    //ACBrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio := FIniNFSe.ReadBool('Geral', 'ConsultaAposEnvio',    False);

    if (TipoEnvio = meLoteAssincrono) or (ACBrNFSe.Configuracoes.Geral.Provedor in [proIPM]) then//if (getTipoEnvio(TipoEnvio) = meLoteAssincrono) or (ACBrNFSe.Configuracoes.Geral.Provedor in [proIPM]) then
      ACBrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio  := True;

    if ACBrNFSe.Configuracoes.Geral.Provedor in ([proSiapSistemas, profintelISS, proNFSeBrasil]) then
      ACBrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio  := False;

    ACBrNFSe.Configuracoes.Geral.ConsultaAposCancelar  := FIniNFSe.ReadBool('Geral', 'ConsultaAposCancelar', False);
    ACBrNFSe.Configuracoes.Geral.MontarPathSchema      := FIniNFSe.ReadBool('Geral', 'MontarPathSchemas',    True);

    ACBrNFSe.Configuracoes.Geral.CNPJPrefeitura := FIniNFSe.ReadString('Emitente', 'CNPJPref',    '');

    ACBrNFSe.Configuracoes.Geral.Emitente.CNPJ           := LimpaNumero(FIBQEMITENTE.FieldByName('CGC').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.InscMun        := LimpaNumero(FIBQEMITENTE.FieldByName('IM').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.RazSocial      := FIBQEMITENTE.FieldByName('NOME').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.WSUser         := FIniNFSe.ReadString( 'WebService', 'UserWeb',      '');
    ACBrNFSe.Configuracoes.Geral.Emitente.WSSenha        := FIniNFSe.ReadString( 'WebService', 'SenhaWeb',     '');
    ACBrNFSe.Configuracoes.Geral.Emitente.WSFraseSecr    := FIniNFSe.ReadString( 'WebService', 'FraseSecWeb',  '');
    ACBrNFSe.Configuracoes.Geral.Emitente.WSChaveAcesso  := FIniNFSe.ReadString( 'WebService', 'ChAcessoWeb',  '');
    ACBrNFSe.Configuracoes.Geral.Emitente.WSChaveAutoriz := FIniNFSe.ReadString( 'WebService', 'ChAutorizWeb', '');

    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.NomeFantasia      := FIBQEMITENTE.FieldByName('NOME').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.InscricaoEstadual := LimpaNumero(FIBQEMITENTE.FieldByName('IE').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Endereco          := ExtraiEnderecoSemONumero(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Numero            := ExtraiNumeroSemOEndereco(FIBQEMITENTE.FieldByName('ENDERECO').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.CEP               := LimpaNumero(FIBQEMITENTE.FieldByName('CEP').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Bairro            := FIBQEMITENTE.FieldByName('COMPLE').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Complemento       := '';
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Municipio         := FIBQEMITENTE.FieldByName('MUNICIPIO').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.UF                := FIBQEMITENTE.FieldByName('ESTADO').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.CodigoMunicipio   := FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString;
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Telefone          := LimpaNumero(FIBQEMITENTE.FieldByName('TELEFO').AsString);
    ACBrNFSe.Configuracoes.Geral.Emitente.DadosEmitente.Email             := FIBQEMITENTE.FieldByName('EMAIL').AsString;

    {
      Para o provedor ADM, utilizar as seguintes propriedades de configurações:
      WSChaveAcesso  para o Key
      WSChaveAutoriz para o Auth
      WSUser         para o RequestId

      O Key, Auth e RequestId são gerados pelo provedor quando o emitente se cadastra.
    }
  end;

  //with ACBrNFSe.Configuracoes.WebServices do
  begin
    ACBrNFSe.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok, FIniNFSe.ReadString('NFSE', 'Ambiente', '2')); // StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
    ACBrNFSe.Configuracoes.WebServices.Visualizar := FIniNFSe.ReadBool('WebService', 'Visualizar', True);;//cbxVisualizar.Checked;
    ACBrNFSe.Configuracoes.WebServices.Salvar     := FIniNFSe.ReadBool('WebService', 'SalvarSOAP', True);//chkSalvarSOAP.Checked;
    ACBrNFSe.Configuracoes.WebServices.UF         := FIBQEMITENTE.FieldByName('ESTADO').AsString;// edtEmitUF.Text;

    ACBrNFSe.Configuracoes.WebServices.AjustaAguardaConsultaRet := True;// cbxAjustarAut.Checked;


    iAguardar := FIniNFSe.ReadInteger('WebService', 'Aguardar', 3000);
    if iAguardar > 0 then //if NaoEstaVazio(edtAguardar.Text) then
      ACBrNFSe.Configuracoes.WebServices.AguardarConsultaRet := ifThen(iAguardar < 1000, iAguardar * 1000, iAguardar); //ACBrNFSe.Configuracoes.WebServices.AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text) < 1000, StrToInt(edtAguardar.Text) * 1000, StrToInt(edtAguardar.Text))
    //else
    //  edtAguardar.Text := IntToStr(ACBrNFSe.Configuracoes.WebServices.AguardarConsultaRet);

    //if FIniNFSe.ReadInteger('WebService', 'Tentativas', 5) > 0 then //if NaoEstaVazio(edtTentativas.Text) then
      ACBrNFSe.Configuracoes.WebServices.Tentativas := FIniNFSe.ReadInteger('WebService', 'Tentativas', 5);// StrToInt(edtTentativas.Text)
    //else
    //  edtTentativas.Text := IntToStr(ACBrNFSe.Configuracoes.WebServices.Tentativas);

    iIntervalo := FIniNFSe.ReadInteger('WebService', 'Intervalo', 5000);
    if iIntervalo > 0 then //if NaoEstaVazio(edtIntervalo.Text) then
      ACBrNFSe.Configuracoes.WebServices.IntervaloTentativas := ifThen(iIntervalo < 1000, iIntervalo * 1000, iIntervalo);//ACBrNFSe.Configuracoes.WebServices.IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text) < 1000, StrToInt(edtIntervalo.Text) * 1000, StrToInt(edtIntervalo.Text))
    //else
    //  edtIntervalo.Text := IntToStr(ACBrNFSe.Configuracoes.WebServices.IntervaloTentativas);

    ACBrNFSe.Configuracoes.WebServices.TimeOut   := FIniNFSe.ReadInteger('WebService', 'TimeOut', 5000);//seTimeOut.Value;
    ACBrNFSe.Configuracoes.WebServices.ProxyHost := FIniNFSe.ReadString('Proxy', 'Host', '');//edtProxyHost.Text;
    ACBrNFSe.Configuracoes.WebServices.ProxyPort := FIniNFSe.ReadString('Proxy', 'Porta', '');//edtProxyPorta.Text;
    ACBrNFSe.Configuracoes.WebServices.ProxyUser := FIniNFSe.ReadString('Proxy', 'User', '');//edtProxyUser.Text;
    ACBrNFSe.Configuracoes.WebServices.ProxyPass := FIniNFSe.ReadString('Proxy', 'Pass', '');//edtProxySenha.Text;
  end;

  ACBrNFSe.SSL.SSLType := TSSLType(FIniNFSe.ReadInteger('WebService', 'SSLType',      5));// TSSLType(cbSSLType.ItemIndex);

  //with ACBrNFSe.Configuracoes.Arquivos do
  begin
    ACBrNFSe.Configuracoes.Arquivos.NomeLongoNFSe    := True;
    ACBrNFSe.Configuracoes.Arquivos.Salvar           := FIniNFSe.ReadBool('Arquivos', 'Salvar',          False);//chkSalvarArq.Checked;
    ACBrNFSe.Configuracoes.Arquivos.SepararPorMes    := FIniNFSe.ReadBool('Arquivos', 'PastaMensal',     False);//cbxPastaMensal.Checked;
    ACBrNFSe.Configuracoes.Arquivos.AdicionarLiteral := FIniNFSe.ReadBool('Arquivos', 'AddLiteral',    False);//cbxAdicionaLiteral.Checked;
    ACBrNFSe.Configuracoes.Arquivos.EmissaoPathNFSe  := FIniNFSe.ReadBool('Arquivos', 'EmissaoPathNFSe', False);//cbxEmissaoPathNFSe.Checked;
    ACBrNFSe.Configuracoes.Arquivos.SepararPorCNPJ   := FIniNFSe.ReadBool('Arquivos', 'SepararPorCNPJ',  False);//cbxSepararPorCNPJ.Checked;
    ACBrNFSe.Configuracoes.Arquivos.PathSchemas      := ExtractFilePath(Application.ExeName) + 'ArquivosNFSe';// edtPathSchemas.Text;
    ACBrNFSe.Configuracoes.Arquivos.PathGer          := ExtractFilePath(Application.ExeName) + 'log\nfse'; //edtPathLogs.Text;
    PathMensal       := ACBrNFSe.Configuracoes.Arquivos.GetPathGer(0);
    ACBrNFSe.Configuracoes.Arquivos.PathSalvar       := PathMensal;
  end;
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log');
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log\nfse') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log\nsfe');

  if ACBrNFSe.DANFSE <> nil then
  begin
    // TTipoDANFSE = ( tpPadrao, tpIssDSF, tpFiorilli );
    ACBrNFSe.DANFSE.TipoDANFSE := tpPadrao;
    ACBrNFSe.DANFSE.Logo       := ExtractFilePath(Application.ExeName) + 'logonsfe'; //edtLogoMarca.Text;
    ACBrNFSe.DANFSE.Prefeitura := ExtractFilePath(Application.ExeName) + 'logoprefeitura'; //edtPrefeitura.Text;
    ACBrNFSe.DANFSE.PathPDF    := ExtractFilePath(Application.ExeName) + 'xmldestinatario\nfse\pdf'; //edtPathPDF.Text;

    ACBrNFSe.DANFSE.Prestador.Logo := ExtractFilePath(Application.ExeName) + 'logonsfe'; //edtPrestLogo.Text;

    ACBrNFSe.DANFSE.MargemDireita  := 5;
    ACBrNFSe.DANFSE.MargemEsquerda := 5;
    ACBrNFSe.DANFSE.MargemSuperior := 5;
    ACBrNFSe.DANFSE.MargemInferior := 5;

    ACBrNFSe.DANFSE.ImprimeCanhoto := True;

    // Defini a quantidade de casas decimais para o campo aliquota
    ACBrNFSe.DANFSE.CasasDecimais.Aliquota := 2;
  end;

  {Usar mail.exe
  //with ACBrNFSe.MAIL do
  begin
    ACBrNFSe.MAIL.Host      := edtSmtpHost.Text;
    ACBrNFSe.MAIL.Port      := edtSmtpPort.Text;
    ACBrNFSe.MAIL.Username  := edtSmtpUser.Text;
    ACBrNFSe.MAIL.Password  := edtSmtpPass.Text;
    ACBrNFSe.MAIL.From      := edtEmailRemetente.Text;
    ACBrNFSe.MAIL.FromName  := edtEmitRazao.Text;
    ACBrNFSe.MAIL.SetTLS    := cbEmailTLS.Checked;
    ACBrNFSe.MAIL.SetSSL    := cbEmailSSL.Checked;
    ACBrNFSe.MAIL.UseThread := False;

    ACBrNFSe.MAIL.ReadingConfirmation := False;
  end;
  }

  // A propriedade CodigoMunicipio tem que ser a ultima a receber o seu valor
  // Pois ela se utiliza das demais configurações
  //with ACBrNFSe.Configuracoes.Geral do
  begin
    ACBrNFSe.Configuracoes.Geral.LayoutNFSe := TLayoutNFSe(FIniNFSe.ReadInteger('Geral', 'LayoutNFSe',     0));// TLayoutNFSe(cbLayoutNFSe.ItemIndex);
    ACBrNFSe.Configuracoes.Geral.CodigoMunicipio := StrToInt64Def(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString, 0);// StrToIntDef(edtCodCidade.Text, -1);
  end;

  //lblSchemas.Caption := ACBrNFSe.Configuracoes.Geral.xProvedor;

  //  if ACBrNFSe.Configuracoes.Geral.Layout = loABRASF then
  //    lblLayout.Caption := 'ABRASF'
  //  else
  //    lblLayout.Caption := 'Próprio';
  //
  //  lblVersaoSchemas.Caption := VersaoNFSeToStr(ACBrNFSe.Configuracoes.Geral.Versao);
  //
  //  if ACBrNFSe.Configuracoes.Geral.Provedor = proPadraoNacional then
  //  begin
  //    pgcProvedores.Pages[0].TabVisible := False;
  //    pgcProvedores.Pages[1].TabVisible := True;
  //  end
  //  else
  //  begin
  //    pgcProvedores.Pages[0].TabVisible := True;
  //    pgcProvedores.Pages[1].TabVisible := False;
  //  end

  Result := ACBrNFSe;
end;
*)

function TNFS.ConfigurarComponente: Boolean;
var
  Ok: Boolean;
  PathMensal: String;
  FIniNFSe: TIniFile;
  StreamMemo: TMemoryStream;
  iAguardar: Integer;
  iIntervalo: Integer;
//  FIBQEMITENTE: TIBQuery;
//  FIBQMUNICIPIO: TIBQuery;
begin
  Result := True;

  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

  //FIBQEMITENTE   := CriaIBQuery(FIBTRANSACTION);

  //SelecionarDadosEmitente(FIBQEMITENTE);

  //FIBQMUNICIPIO   := CriaIBQuery(FIBTRANSACTION);

  SelecionarDadosEmitente;

  FACBrNFSeX1.LerCidades;

  //if LeParametrizacao(ConexaoTemp, 'NFSE_AMBIENTE', 0) = '0' then
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
    'M.CODIGO as CODIGO_IBGE ' +
    'from EMITENTE E ' +
    'left join MUNICIPIOS M on M.NOME = E.MUNICIPIO and M.UF = E.ESTADO';
  FIBQEMITENTE.Open;

end;

procedure TNFS.SetIBTRANSACTION(const Value: TIBTransaction);
begin
  FIBTRANSACTION := Value;

  FIBQNFSE := CriaIBQuery(FIBTRANSACTION);
end;

end.
