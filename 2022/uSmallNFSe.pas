unit uSmallNFSe;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ShellAPI, XMLIntf, XMLDoc, zlib, System.IniFiles, System.Math,
  Winapi.ActiveX, System.StrUtils,
  uDialogs,
  Data.DB, IBX.IBCustomDataSet, IBX.IBDatabase,
  IBX.IBQuery,
  pcnConversao,
  blcksock,
  ACBrDFeSSL,
  ACBrBase,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrDFe,
  ACBrDFeReport,
  ACBrMail,
  ACBrNFSeX,
  ACBrNFSeXConversao,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXDANFSeClass,
  ACBrNFSeXDANFSeFR,
  ACBrNFSeXWebserviceBase,
  ACBrNFSeXDANFSeRLClass,
  ACBrNFSeXClass

  , uFuncoesBancoDados

  , Pkg.Json.DTO,
  nfse.search.nfserps,
  nfse.classes.helpers,
  nfse.classes.nfse,
  nfse.classe.retorno,
  nfse.classe.configura_componente,
  nfse.configura_componente,
  nfse.checa_resposta,
  nfse.checaservico,
  nfse.retorna_filaws,
  nfse.constants,
  nfse.envia_xml,
  controller.send,
  nfse.funcoes

  ;

type
  TNFS = class(TComponent)
  public
  private
    FIniNFSe: TIniFile;
    FACBrNFSeX1: TACBrNFSeX;
    FACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL;
    FACBrNFSeXDANFSeFR1: TACBrNFSeXDANFSeFR;
    FIBTRANSACTION: TIBTransaction;
    FIBQNFSE: TIBQuery;
    FIBQEMITENTE: TIBQuery;
    FslLog: TStringList;
    procedure SetIBTRANSACTION(const Value: TIBTransaction);
    procedure ImportaConfiguracaoTecnospeed;
  public
    property ACBrNFSeX: TACBrNFSeX read FACBrNFSeX1 write FACBrNFSeX1;
    property IBTRANSACTION: TIBTransaction read FIBTRANSACTION write SetIBTRANSACTION;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;
    function ConfigurarComponente(TipoEnvio: Integer = 0): Boolean;
    function TransmiteNFSe: Boolean;
  end;

implementation

uses
  Frm_Status, smallfunc_xe, uConectaBancoSmall, uArquivosDAT, uListaToJson;

function TNFS.ConfigurarComponente(TipoEnvio: Integer = 0): Boolean;
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

  ImportaConfiguracaoTecnospeed;

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

  FACBrNFSeX1.Configuracoes.Geral.SSLLib        := TSSLLib(FIniNFSe.ReadInteger('Certificado', 'SSLLib',     4));
  FACBrNFSeX1.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib(FIniNFSe.ReadInteger('Certificado', 'CryptLib',   3));
  FACBrNFSeX1.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib(FIniNFSe.ReadInteger('Certificado', 'HttpLib',    2));
  FACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(FIniNFSe.ReadInteger('Certificado', 'XmlSignLib', 0));

  FACBrNFSeX1.Configuracoes.Geral.Salvar           := FIniNFSe.ReadBool('Geral', 'Salvar',         True);
  FACBrNFSeX1.Configuracoes.Geral.ExibirErroSchema := FIniNFSe.ReadBool('Geral', 'ExibirErroSchema', True);
  FACBrNFSeX1.Configuracoes.Geral.RetirarAcentos   := FIniNFSe.ReadBool('Geral', 'RetirarAcentos', True);
  FACBrNFSeX1.Configuracoes.Geral.FormatoAlerta    := FIniNFSe.ReadString('Geral', 'FormatoAlerta', 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
  FACBrNFSeX1.Configuracoes.Geral.FormaEmissao     := TpcnTipoEmissao(FIniNFSe.ReadInteger('Geral', 'FormaEmissao', 0)); // 0-Normal

  if FACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSiapSistemas, profintelISS, proNFSeBrasil]) then
    FACBrNFSeX1.Configuracoes.Geral.ConsultaLoteAposEnvio  := False;

  FACBrNFSeX1.Configuracoes.Geral.ConsultaAposCancelar   := True;

  if FACBrNFSeX1.Configuracoes.Geral.Provedor in [proPronim, profintelISS, proEl, proISSNet] then
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

  //FACBrNFSeX1.Configuracoes.WebServices.Ambiente   := StrToTpAmb(Ok, FIniNFSe.ReadString('NFSE', 'Ambiente', '2')); // StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
  FACBrNFSeX1.Configuracoes.WebServices.Visualizar := FIniNFSe.ReadBool('WebService', 'Visualizar', True);//cbxVisualizar.Checked;
  FACBrNFSeX1.Configuracoes.WebServices.Salvar     := FIniNFSe.ReadBool('WebService', 'SalvarSOAP', True);//chkSalvarSOAP.Checked;
  FACBrNFSeX1.Configuracoes.WebServices.UF         := FIBQEMITENTE.FieldByName('ESTADO').AsString;// edtEmitUF.Text;

  FACBrNFSeX1.Configuracoes.WebServices.AjustaAguardaConsultaRet := True;// cbxAjustarAut.Checked;


  iAguardar := FIniNFSe.ReadInteger('WebService', 'Aguardar', 3000);
  if iAguardar > 0 then //if NaoEstaVazio(edtAguardar.Text) then
    FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := ifThen(iAguardar < 1000, iAguardar * 1000, iAguardar); //FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text) < 1000, StrToInt(edtAguardar.Text) * 1000, StrToInt(edtAguardar.Text))

  if FACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfisc, proWebISS, proNFSeBrasil, proPronim, proAssessorPublico] then
    FACBrNFSeX1.Configuracoes.WebServices.AguardarConsultaRet := 5000;

  FACBrNFSeX1.Configuracoes.WebServices.Tentativas := FIniNFSe.ReadInteger('WebService', 'Tentativas', 5);// StrToInt(edtTentativas.Text)

  iIntervalo := FIniNFSe.ReadInteger('WebService', 'Intervalo', 5000);
  if iIntervalo > 0 then //if NaoEstaVazio(edtIntervalo.Text) then
    FACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas := ifThen(iIntervalo < 1000, iIntervalo * 1000, iIntervalo);//FACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text) < 1000, StrToInt(edtIntervalo.Text) * 1000, StrToInt(edtIntervalo.Text))

  FACBrNFSeX1.Configuracoes.WebServices.TimeOut   := FIniNFSe.ReadInteger('WebService', 'TimeOut', 5000);//seTimeOut.Value;
  if FACBrNFSeX1.Configuracoes.Geral.Provedor in ([proSigCorp, proSimplISS, proTecnos, proNFSeBrasil, proPronim]) then
    FACBrNFSeX1.Configuracoes.WebServices.TimeOut := 60000;
  FACBrNFSeX1.Configuracoes.WebServices.ProxyHost := FIniNFSe.ReadString('Proxy', 'Host', '');//edtProxyHost.Text;
  FACBrNFSeX1.Configuracoes.WebServices.ProxyPort := FIniNFSe.ReadString('Proxy', 'Porta', '');//edtProxyPorta.Text;
  FACBrNFSeX1.Configuracoes.WebServices.ProxyUser := FIniNFSe.ReadString('Proxy', 'User', '');//edtProxyUser.Text;
  FACBrNFSeX1.Configuracoes.WebServices.ProxyPass := FIniNFSe.ReadString('Proxy', 'Pass', '');//edtProxySenha.Text;

  FACBrNFSeX1.SSL.SSLType := TSSLType(FIniNFSe.ReadInteger('WebService', 'SSLType',      5));// TSSLType(cbSSLType.ItemIndex);

  FACBrNFSeX1.DANFSe.Sistema := 'Zucchetti';

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
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log');
  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'log\nfse') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'log\nsfe');


  {Explicação sobre uso de Reports do Acbr no sistema

  Reports do Acbr   X Descricao no sitema X Nome do report enviado no Pack
  DANFSE.fr3        X Padrão              X DANFSE.fr3
  DANFSeNovo.fr3    X Detalhada           X DANFSEDetalhada.fr3
  DANFSEPadrao.fr3  X Detalhada com itens X DANFSEDetalhada_itens.fr3
  }

  try
  // A propriedade CodigoMunicipio tem que ser a ultima a receber o seu valor
  // Pois ela se utiliza das demais configurações
    FACBrNFSeX1.Configuracoes.Geral.LayoutNFSe := TLayoutNFSe(FIniNFSe.ReadInteger('Geral', 'LayoutNFSe',     0));// TLayoutNFSe(cbLayoutNFSe.ItemIndex);
    FACBrNFSeX1.Configuracoes.Geral.CodigoMunicipio := StrToInt64Def(FIBQEMITENTE.FieldByName('CODIGO_IBGE').AsString, 0);// StrToIntDef(edtCodCidade.Text, -1);
  except
    on E: Exception do
    begin
      Result := False;
      exit
    end;
  end;

end;

constructor TNFS.Create(AOwner: TComponent);
begin
  inherited;
  CoInitialize(nil);

  FslLog := TStringList.Create;

  FACBrNFSeX1 := TACBrNFSeX.Create(nil);
  FACBrNFSeXDANFSeRL1 := TACBrNFSeXDANFSeRL.Create(nil);
  FACBrNFSeXDANFSeFR1 := TACBrNFSeXDANFSeFR.Create(nil);
  FACBrNFSeX1.DANFSE := FACBrNFSeXDANFSeFR1;//FACBrNFSeXDANFSeRL1;
  FIniNFSe := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

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
  FreeAndNil(FACBrNFSeX1);
  FreeAndNil(FIniNFSe);
  FreeAndNil(FslLog);
  inherited;
end;

procedure TNFS.ImportaConfiguracaoTecnospeed;
var
  I: Integer;
  Ini: TIniFile;
  sUsuario: String;
  sSenha: String;
  config: TArquivosDAT;
  stringsSection: TStringList;
  Parametros: TParametros;
begin

  if not FileExists(ExtractFilePath(Application.ExeName) + 'nfseConfig.ini') then
    Exit;

  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfseConfig.ini');

  if Ini.ReadString('NFSE', 'Migrado', '') = 'Sim' then
    Exit;

  config := TArquivosDAT.Create('', FIBTRANSACTION);

  try
    if Ini.ReadString('NFSE', 'NomeCertificado', '') <> '' then
    begin

      config.BD.NFSe.Certificado.SSLLib     := FIniNFSe.ReadString('Certificado', 'SSLLib',     '4');
      config.BD.NFSe.Certificado.CryptLib   := FIniNFSe.ReadString('Certificado', 'CryptLib',   '3');
      config.BD.NFSe.Certificado.HttpLib    := FIniNFSe.ReadString('Certificado', 'HttpLib',    '2');
      config.BD.NFSe.Certificado.XmlSignLib := FIniNFSe.ReadString('Certificado', 'XmlSignLib', '0');

      FACBrNFSeX1.Configuracoes.Geral.SSLLib        := TSSLLib(FIniNFSe.ReadInteger('Certificado', 'SSLLib',     4));
      FACBrNFSeX1.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib(FIniNFSe.ReadInteger('Certificado', 'CryptLib',   3));
      FACBrNFSeX1.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib(FIniNFSe.ReadInteger('Certificado', 'HttpLib',    2));
      FACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(FIniNFSe.ReadInteger('Certificado', 'XmlSignLib', 0));

      FACBrNFSeX1.SSL.LerCertificadosStore;
      for I := 0 to FACBrNFSeX1.SSL.ListaCertificados.Count-1 do
      begin

        if (FACBrNFSeX1.SSL.ListaCertificados[I].CNPJ <> '') then
        begin

          if Pos(LimpaNumero(FACBrNFSeX1.SSL.ListaCertificados[I].CNPJ), Ini.ReadString('NFSE', 'NomeCertificado', '')) > 0 then
          begin

            if FACBrNFSeX1.SSL.ListaCertificados[I].DataVenc >= Now then
            begin
              FIniNFSe.WriteString('Certificado', 'NomeCertificado', FACBrNFSeX1.SSL.ListaCertificados[I].SubjectName);
              FIniNFSe.WriteString('Certificado', 'NumSerie', FACBrNFSeX1.SSL.ListaCertificados[I].NumeroSerie);

              config.BD.NFSe.Certificado.NomeCertificado := FACBrNFSeX1.SSL.ListaCertificados[I].SubjectName;
              config.BD.NFSe.Certificado.NumSerie := FACBrNFSeX1.SSL.ListaCertificados[I].NumeroSerie;

              Break;
            end;

          end;

        end;

      end;

    end;

    if Ini.ReadString('NFSE', 'ParametrosExtras', '') <> '' then
    begin
      sUsuario := Ini.ReadString('NFSE', 'ParametrosExtras', '');
      sUsuario := Copy(sUsuario, 7, Pos(';', sUsuario) - 7);

      sSenha := Ini.ReadString('NFSE', 'ParametrosExtras', '');
      sSenha := Copy(sSenha, Pos(';', sSenha) + 7, 1000);

      config.BD.NFSe.Webservice.UserWeb := sUsuario;
      config.BD.NFSe.Webservice.SenhaWeb := sSenha;

      FIniNFSe.WriteString( 'WebService', 'SenhaWeb',     sSenha);
      FIniNFSe.WriteString( 'WebService', 'UserWeb',      sUsuario);
    end;

    config.BD.NFSe.Webservice.Ambiente := Ini.ReadString('NFSE', 'Ambiente', '2');

    FIniNFSe.WriteString('WebService', 'Ambiente', Ini.ReadString('NFSE', 'Ambiente', '2'));

    stringsSection := TStringList.Create;

    Ini.ReadSectionValues('Informacoes obtidas na prefeitura', stringsSection);
    Parametros := TParametros.Create;
    Parametros.IniToJson(stringsSection);

    config.BD.NFSe.InformacoesObtidasPrefeitura.Informacoes := Parametros;

    Parametros.Free;
    FreeAndNil(stringsSection);

  except

  end;
  Ini.WriteString('NFSE', 'Migrado', 'Sim');

  Ini.Free;

  config.Free;
end;

procedure TNFS.SetIBTRANSACTION(const Value: TIBTransaction);
begin
  FIBTRANSACTION := Value;

  FIBQNFSE := CriaIBQuery(FIBTRANSACTION);
end;

function TNFS.TransmiteNFSe: Boolean;
var
  AcbrNFSe: TACBrNFSeX;
  ConfiguracaoProvedor: TConfiguracaoProvedor;
  NFSeJsonDTO: TNFSe;
  ResponseDTO: TNFSeRetorno;
  Sender: TControllerSend;
begin
  //var NFSeJsonDTO := TNFSe.Create;
  //var ResponseDTO := TNFSeRetorno.create;
  //var ConfiguracaoProvedor := TConfiguracaoProvedor.Create;

  Sender := TControllerSend.Create;

  NFSeJsonDTO := TNFSe.Create;
  ResponseDTO := TNFSeRetorno.create;
  ConfiguracaoProvedor := TConfiguracaoProvedor.Create;

  AcbrNFSe := TACBrNFSeX.Create(nil);

  try

    (*
    try
      {$IFDEF LINUX}
      NFSeJsonDTO.AsJson := TEncoding.UTF8.GetString(TEncoding.Default.GetBytes(Req.Body));
      {$ENDIF}

      {$IFDEF MSWINDOWS}
      NFSeJsonDTO.AsJson := Req.Body;
      {$ENDIF}

      ResponseDTO.nfseId := NFSeJsonDTO.nfseId;
      NFSeJsonDTO.tokenid  := Req.Headers['Authorization-Compufacil'];
      NFSeJsonDTO.socketId := Req.Headers['Socket-Id'];
    Except
      on e : exception do begin
        ResponseDTO.Exception := e.Message;
        Exit;
      end;
    end;
    *)

    ConfiguracaoProvedor.Layout := NFSeJsonDTO.Provedor.Layout;
    ConfiguracaoProvedor.MetodoEnvio := NFSeJsonDTO.Provedor.MetodoEnvio;
    ConfiguracaoProvedor.CodigoMunicipio := NFSeJsonDTO.Provedor.CodigoMunicipio;
    ConfiguracaoProvedor.EmitenteCnpj := NFSeJsonDTO.Provedor.EmitenteCnpj;
    ConfiguracaoProvedor.EmitenteIE := NFSeJsonDTO.Provedor.EmitenteIE;
    ConfiguracaoProvedor.EmitenteInscricaoMunicipal  := NFSeJsonDTO.Prestador.InscricaoMunicipal;
    ConfiguracaoProvedor.EmitenteRazaoSocial := NFSeJsonDTO.Provedor.EmitenteRazaoSocial;
    ConfiguracaoProvedor.EmitenteSenha := NFSeJsonDTO.Provedor.EmitenteSenha;
    ConfiguracaoProvedor.EmitenteUsuario  := NFSeJsonDTO.Provedor.EmitenteUsuario;
    ConfiguracaoProvedor.Producao := NFSeJsonDTO.Provedor.Producao;
    ConfiguracaoProvedor.SenhaCertificado := NFSeJsonDTO.Provedor.SenhaCertificado;
    ConfiguracaoProvedor.UF := NFSeJsonDTO.Provedor.UF;
    ConfiguracaoProvedor.UrlCertificado := NFSeJsonDTO.Provedor.UrlCertificado;
    ConfiguracaoProvedor.FraseSecreta := NFSeJsonDTO.Provedor.FraseSecreta;
    ConfiguracaoProvedor.ChaveAcesso := NFSeJsonDTO.Provedor.ChaveAcesso;
    ConfiguracaoProvedor.ChaveAutorizacao := NFSeJsonDTO.Provedor.ChaveAutorizacao;
    ConfiguracaoProvedor.SalvarArquivoSoap := NFSeJsonDTO.Provedor.SalvarArquivoSoap;
    ConfiguracaoProvedor.PathLocal := NFSeJsonDTO.Provedor.PathLocal;

    try
      nfse.configura_componente.configuraComponente(
        ConfiguracaoProvedor,
        AcbrNFSe
      );
    except
      on e: Exception do
      begin
        {
        ResponseDTO.Correcao := 'Verifique os parâmetros de envio.';
        ResponseDTO.Situacao := 0;
        ResponseDTO.MensagemCompleta :=
          'Exceção ao configurar componente : '+ e.Message;
        }
      end;
    end;
(*

ajustar

    AlimentaNota(AcbrNFSe, NFSeJsonDTO);

    try
      SendNFSe(AcbrNFSe, NFSeJsonDTO, ResponseDTO, ConfiguracaoProvedor);
    except
      on e : exception do
      begin
        ResponseDTO.Exception := e.Message;
        exit;
      end;
    end;
*)
  finally
    if not (NFSeJsonDTO.IndependentNfse) then
    begin
      try
        var RetornoFila := TRetornoFila.Create;
        try
          RetornoFila.tokenid := NFSeJsonDTO.tokenid;
          RetornoFila.socketId := NFSeJsonDTO.socketId;
          RetornoFila.endpoint := getEndPointSend;
          RetornoFila.Enviaretorno(ResponseDTO);
        finally
          FreeAndNil(retornoFila);
        end;
      except
      end;
    end;
    //Res.Send(ResponseDTO.AsJson);
    FreeAndNil(AcbrNFSe);
  end;
end;

end.
