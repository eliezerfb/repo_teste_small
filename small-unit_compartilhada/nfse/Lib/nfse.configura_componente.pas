unit nfse.configura_componente;

interface

uses
  System.SysUtils,
  ACBrNFSeX,
  ACBrDFeSSL,
  pcnConversao,
  ACBrNFSeXConversao,
  ACBrDFeUtil,
  blcksock,
  nfse.classe.retorno,
  nfse.classe.configura_componente,
  nfse.funcoes;


procedure configuraComponente(ClassProvedor : TConfiguracaoProvedor; AcbrNFSe : TACBrNFSeX);


implementation

procedure configuraComponente(ClassProvedor : TConfiguracaoProvedor; AcbrNFSe : TACBrNFSeX);
begin
  ClassProvedor.PathLocal := ExtractFilePath(ParamStr(0));
  AcbrNFSe.LerCidades;
  AcbrNFSe.Configuracoes.Geral.LayoutNFSe := TLayoutNFSe(ClassProvedor.Layout);

  AcbrNFSe.Configuracoes.Geral.CodigoMunicipio := ClassProvedor.CodigoMunicipio;
  AcbrNFSe.Configuracoes.Geral.CNPJPrefeitura := '37465556000163';


  AcbrNFSe.Configuracoes.Geral.SSLLib       :=  libOpenSSL;
  AcbrNFSe.Configuracoes.Geral.SSLHttpLib   :=  httpOpenSSL;
  AcbrNFSe.Configuracoes.Geral.SSLCryptLib  :=  cryOpenSSL;

  var arquivoPfx := getArquivoPfx();
  if arquivoPfx <> EmptyStr then
    AcbrNFSe.Configuracoes.Certificados.ArquivoPFX  := arquivoPfx
  else
    AcbrNFSe.Configuracoes.Certificados.URLPFX  := ClassProvedor.UrlCertificado;

  AcbrNFSe.Configuracoes.Certificados.Senha := ClassProvedor.SenhaCertificado;
  AcbrNFSe.SSL.CarregarCertificado;

  AcbrNFSe.Configuracoes.Certificados.VerificarValidade :=True;
  AcbrNFSe.Configuracoes.Arquivos.AdicionarLiteral := True;
  AcbrNFSe.Configuracoes.Arquivos.EmissaoPathNFSe := True;
  AcbrNFSe.Configuracoes.Arquivos.SepararPorMes := false;
  AcbrNFSe.Configuracoes.Arquivos.SepararPorCNPJ := True;
  AcbrNFSe.Configuracoes.Arquivos.PathGer := ClassProvedor.PathLocal;
  AcbrNFSe.Configuracoes.Arquivos.PathRPS := ClassProvedor.PathLocal;
  AcbrNFSe.Configuracoes.Arquivos.PathNFSe := ClassProvedor.PathLocal;
  AcbrNFSe.Configuracoes.Arquivos.NomeLongoNFSe := False;

  AcbrNFSe.Configuracoes.Arquivos.PathSchemas := getPathSchemas();

  var PathMensal := AcbrNFSe.Configuracoes.Arquivos.GetPathRPS(0);
  AcbrNFSe.Configuracoes.Arquivos.PathCan := PathMensal;
  AcbrNFSe.Configuracoes.Arquivos.PathSalvar := PathMensal;
  AcbrNFSe.Configuracoes.Arquivos.Salvar := True;

  AcbrNFSe.Configuracoes.Geral.Salvar := True;
  AcbrNFSe.Configuracoes.Geral.Emitente.CNPJ := ClassProvedor.EmitenteCnpj;
  AcbrNFSe.Configuracoes.Geral.Emitente.InscMun := ClassProvedor.EmitenteInscricaoMunicipal;
  AcbrNFSe.Configuracoes.Geral.Emitente.RazSocial := ClassProvedor.EmitenteRazaoSocial;
  AcbrNFSe.Configuracoes.Geral.Emitente.WSUser := ClassProvedor.EmitenteUsuario;
  AcbrNFSe.Configuracoes.Geral.Emitente.WSSenha := ClassProvedor.EmitenteSenha;
  AcbrNFSe.Configuracoes.Geral.Emitente.WSChaveAcesso := ClassProvedor.ChaveAcesso;
  AcbrNFSe.Configuracoes.Geral.Emitente.WSChaveAutoriz:= ClassProvedor.ChaveAutorizacao;
  AcbrNFSe.Configuracoes.Geral.Emitente.WSFraseSecr := ClassProvedor.FraseSecreta;
  AcbrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio := True;
  if (AcbrNFSe.Configuracoes.Geral.Provedor = proSiapSistemas) then
    AcbrNFSe.Configuracoes.Geral.ConsultaLoteAposEnvio := False;
  AcbrNFSe.Configuracoes.Geral.ConsultaAposCancelar := True;
  AcbrNFSe.Configuracoes.WebServices.Salvar := ClassProvedor.SalvarArquivoSoap;
  if ClassProvedor.Producao then
    AcbrNFSe.Configuracoes.WebServices.Ambiente := taProducao
  else
    AcbrNFSe.Configuracoes.WebServices.Ambiente := taHomologacao;
  AcbrNFSe.Configuracoes.WebServices.Visualizar := True;
  AcbrNFSe.Configuracoes.WebServices.UF := ClassProvedor.UF;
//  AcbrNFSe.Configuracoes.WebServices.SSLType           := TSSLType(LT_TLSv1_2);
  AcbrNFSe.Configuracoes.WebServices.QuebradeLinha := '|';
  AcbrNFSe.Configuracoes.WebServices.Tentativas := 5;
  AcbrNFSe.Configuracoes.WebServices.IntervaloTentativas := 5000;

  if AcbrNFSe.Configuracoes.Geral.Provedor in ([proSigCorp, proSimplISS]) then
    AcbrNFSe.Configuracoes.WebServices.TimeOut := 60000;

  AcbrNFSe.Configuracoes.WebServices.AjustaAguardaConsultaRet := True;

  AcbrNFSe.Configuracoes.Geral.RetirarAcentos := True;
  AcbrNFSe.Configuracoes.Geral.RetirarEspacos := True;
  AcbrNFSe.Configuracoes.Geral.ValidarDigest  := True;

end;

end.
