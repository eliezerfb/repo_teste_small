unit Mais;

interface

uses
  Windows, SysUtils, Messages, Classes, Controls, Graphics,
  Menus, StdCtrls, Buttons, ExtCtrls, Forms, Dialogs, shellapi,
  mais3, unit2,unit3, IniFiles, Unit4
//  , Unit10
  , Registry,
  DBGrids, Grids, OleCtrls, SHDocVw, IBCustomDataSet, IBDatabase, Winsock,
  IBQuery, jpeg, Gauges, SpdNFeDataSets, IBServices, FileCtrl, xmldom, XMLIntf,
  {$IFDEF VER150}
  oxmldom,
  SmallFunc,
  {$ELSE}
  smallfunc_xe,
  {$ENDIF}
  XMLDoc, URLMON, pngimage, ComCtrls, clipbrd, DB, DateUtils,
  WinTypes, WinProcs, uFuncoesBancoDados,
  LbCipher, LbClass, Tlhelp32, Psapi, strutils, ShlObj, ComObj, ActiveX
  , REST.Json
  , DBCtrls
  , SMALL_DBEdit
  , uValidaRecursosDelphi7
  , uLogSistema
  , uSmallEnumerados
  ;

  function LeLabels(sP1: Boolean): Boolean;
  function MostraLabels(tSp1: tImage; tSp2: TLabel): Boolean;
  function FechaTudo(bP1: Boolean): Boolean;
  function DownloadDoArquivo(pP1: String; pP2: String): Boolean;
  function mensagem22(sP1 : String) : Boolean;
//  procedure DropViewProcedure;

  function ExecutaComando(comando:string):Boolean;  overload;
  procedure VencimentoCertificadoDigital;

const VALOR_SISTEMA_BLOQUEADO = '19670926'; // Mudando aqui precisa mudar no Frente PAF Homologado
const BUILD_DO_BANCO = '2024026'; //Sandro Silva 2024-07-19 const BUILD_DO_BANCO = '2024024'; //Mauricio Parizotto 2024-07-15 const BUILD_DO_BANCO = '2024022'; // Sandro Silva 2024-07-05 const BUILD_DO_BANCO = '2024020'; // Sandro Silva 2024-06-28 const BUILD_DO_BANCO = '2024018'; // Sandro Silva 2024-05-29 const BUILD_DO_BANCO = '2024016'; // Sandro Silva 2024-05-09 const BUILD_DO_BANCO = '2024014';
const CNPJ_SMALLSOFT = '03.916.076/0006-64'; // Sandro Silva 2022-12-02 Unochapeco '07.426.598/0001-24';

const NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF = 'arquivoauxiliarcriptografadopafecfsmallsoft.ini'; // usado também pelo SAT

const IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO = 999;  // Sandro Silva 2022-09-12
const PRAZO_MANIFESTAR = '180';
const SQL_CONDICAO_RECEBER_HOJE = ' coalesce(VALOR_RECE, 0)=0 and VENCIMENTO=CURRENT_DATE';
const NOME_NFE_SETUP = 'nfe_setup.exe';

const SECAO_INI_NFE = 'NFE';
const CHAVE_INI_BUILD_NFE_SETUP_EXE = 'BUILD NF-e Setup';

type 
    TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    TabeladeICMparatodososestados1: TMenuItem;

    Limparmovimento1: TMenuItem;
    Opes1: TMenuItem;
    Cadastrodetransportadoras1: TMenuItem;
    Planodecontas1: TMenuItem;
    Cadastrodoemitente1: TMenuItem;
    Comissodevendedores1: TMenuItem;
    Grupos1: TMenuItem;
    N2: TMenuItem;
    Cadastrarlicenasdeuso1: TMenuItem;
    UsuriosAtivos1: TMenuItem;
    Cadastrodeconvnios1: TMenuItem;
    Cadastrodetcnicos1: TMenuItem;
    ibDataSet200: TIBDataSet;
    DataSource200: TDataSource;
    DBGrid200: TDBGrid;
    SQLMododecomando1: TMenuItem;
    Edit200: TEdit;
    este1: TMenuItem;
    estardesempenho1: TMenuItem;
    Plugin1: TMenuItem;
    Liberarosmdulosparaesteusurio1: TMenuItem;
    Calendrio1: TMenuItem;
    wwwsmallsoftcombr1: TMenuItem;
    SobreoPrograma1: TMenuItem;
    Botao_titulo: TImage;
    Image1: TImage;
    estarservidorNFE1: TMenuItem;
    ConfiguraodaNFe2: TMenuItem;
    ContrasenhaparaliberarcrditosparaemitirNFe1: TMenuItem;
    VerificarcrditosparaemissodeNFe1: TMenuItem;
    InutilizarNFe1: TMenuItem;
    estarDisponibilidadedeServiosdasSecretariasdeFazenda1: TMenuItem;
    Verificarcadastro1: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    CAdastros1: TMenuItem;
    Configuraes1: TMenuItem;
    Comandos1: TMenuItem;
    Usurios1: TMenuItem;
    IBDataSet201: TIBDataSet;
    IBQuery1: TIBQuery;
    ImageLogo: TImage;
    SCANSistemadeContingnciadoAmbienteNacional1: TMenuItem;
    N6: TMenuItem;
    Formatododanfe1: TMenuItem;
    N8: TMenuItem;
    Ambiente1: TMenuItem;
    SelecionarCertificadoDigital1: TMenuItem;
    ConfigurarlogotipodoDANFE1: TMenuItem;
    ConfiguraodoDANFEparaNFe1: TMenuItem;
    ConfigurarServidoresHomologao1: TMenuItem;
    ConfigurarServidoresProduo1: TMenuItem;
    ConfigurarNFEINI1: TMenuItem;
    N3: TMenuItem;
    Edit1: TEdit;
    DBGrid1: TDBGrid;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    DataSource1: TDataSource;
    IBDataSet1: TIBDataSet;
    SQLCommandoexterno1: TMenuItem;
    Timer1: TTimer;
    IBQuery2: TIBQuery;
    IBQuery3: TIBQuery;
    XMLDocument1: TXMLDocument;
    N9: TMenuItem;
    ZiparXMLnoenvioporemail1: TMenuItem;
    Enviardanfeporemail1: TMenuItem;
    AtualizartabelaIBPT1: TMenuItem;
    Image_Perigo_1: TImage;
    Image_Perigo_2: TImage;
    Estatisticas1: TMenuItem;
    Timer2: TTimer;
    ConfiguraodaNFemformulrionumerado1: TMenuItem;
    N11: TMenuItem;
    VersodolayoutdaNFE1: TMenuItem;
    N301: TMenuItem;
    N3101: TMenuItem;
    SVCSefazVirtualdeContingncia1: TMenuItem;
    WebBrowser1: TWebBrowser;
    Panel_00: TPanel;
    Image201_X: TImage;
    Image201__X: TImage;
    Image202_X: TImage;
    Image203_X: TImage;
    Image204_X: TImage;
    Image210_X: TImage;
    Image205_X: TImage;
    Image206_X: TImage;
    Image207_X: TImage;
    Image208_X: TImage;
    Panel2: TPanel;
    Image201_R: TImage;
    Image201__R: TImage;
    Image202_R: TImage;
    Image203_R: TImage;
    Image204_R: TImage;
    Image210_R: TImage;
    Image205_R: TImage;
    Image206_R: TImage;
    Image207_R: TImage;
    Image208_R: TImage;
    Panel_3: TPanel;
    Edit2: TEdit;
    N12: TMenuItem;
    Fuso1: TMenuItem;
    Image4: TImage;
    Panel4: TPanel;
    Panel_0: TPanel;
    imgVendas: TImage;
    imgOrdemServico: TImage;
    imgEstoque: TImage;
    imgCliFor: TImage;
    imgContaReceber: TImage;
    imgContaPagar: TImage;
    imgCaixa: TImage;
    imgBancos: TImage;
    imgConfiguracoes: TImage;
    imgBackup: TImage;
    Label201: TLabel;
    Label201_: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    Label204: TLabel;
    Label210: TLabel;
    Label205: TLabel;
    Label206: TLabel;
    Label207: TLabel;
    Label208: TLabel;
    Label200: TLabel;
    imgIndicadores: TImage;
    Image200_R: TImage;
    Image200_X: TImage;
    ppmBackup: TPopupMenu;
    Image_raio_2: TImage;
    Image_raio_1: TImage;
    CNPJdacontabilidade1: TMenuItem;
    Instalarpackcomasltimasalteraes1: TMenuItem;
    FileListBox1: TFileListBox;
    pnInformacaoObterSmallComFuncoes: TPanel;
    Label4: TLabel;
    LbBlowfish1: TLbBlowfish;
    Button1: TButton;
    N4001: TMenuItem;
    IBQueryGrafico: TIBQuery;
    Smallmobile1: TMenuItem;
    AutoSmallMobile1: TMenuItem;
    SincronizarSmallMobile1: TMenuItem;
    DownloadSmallMobile1: TMenuItem;
    IBTransaction2: TIBTransaction;
    IBDataSetGrafico1: TIBDataSet;
    IBDataSetGrafico2: TIBDataSet;
    IBDataSetGrafico3: TIBDataSet;
    Registrodoprogramaonline1: TMenuItem;
    Label_bola_NFE: TLabel;
    Image_bola_caixa: TImage;
    Label_bola_caixa: TLabel;
    Image_Bola_NFe: TImage;
    Image_bola_banco: TImage;
    Label_bola_banco: TLabel;
    ImageBola: TImage;
    ImageBola2: TImage;
    ImageBola3: TImage;
    Image_bola_pagar: TImage;
    Label_bola_pagar: TLabel;
    Label_bola_clifor: TLabel;
    Image_bola_clifor: TImage;
    Image_bola_receber: TImage;
    Label_bola_receber: TLabel;
    Image_Bola_Estoque: TImage;
    Label_Bola_estoque: TLabel;
    Image2: TImage;
    Label2: TLabel;
    Image_bola_OS: TImage;
    Label_bola_OS: TLabel;
    Image_Bola_indicadores: TImage;
    Label_bola_indicadores: TLabel;
    Image_bola_config: TImage;
    Label_Bola_Config: TLabel;
    HorarioDeVerao: TMenuItem;
    N10: TMenuItem;
    ConsultarNFesemitidas1: TMenuItem;
    N14: TMenuItem;
    Modoinventrio1: TMenuItem;
    Label1: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ConfiguraesdaNFSe1: TMenuItem;
    Marketplace1: TMenuItem;
    AutoMarketplace1: TMenuItem;
    Selecionarprodutosparamarketplace1: TMenuItem;
    Hub1: TMenuItem;
    N15: TMenuItem;
    LAbel201C: TLabel;
    imgCompras: TImage;
    Label201S: TLabel;
    imgServicos: TImage;
    Image201C_X: TImage;
    Image201S_X: TImage;
    Image201C_R: TImage;
    Image201S_R: TImage;
    Layoutpreenchimento1: TMenuItem;
    Simples1: TMenuItem;
    Complexo1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    ConfiguraesdaNFSe2: TMenuItem;
    Debug1: TMenuItem;
    Mensagemparaenviodeemail1: TMenuItem;
    Image3: TImage;
    Image_bola_vendas: TImage;
    Label_Bola_vendas: TLabel;
    FazerBackupAgora1: TMenuItem;
    BackupAutomtico1: TMenuItem;
    Perfisdetribitao1: TMenuItem;
    NaturezaseCFOPs1: TMenuItem;
    ConversodeCFOP1: TMenuItem;
    Parmetrosdetributao1: TMenuItem;
    EnvioautomticodeXML1: TMenuItem;
    Observaonadescriodosservios1: TMenuItem;
    ConfiguraoTEF1: TMenuItem;
    N7: TMenuItem;
    Clculododescontopeloprovedor1: TMenuItem;
    miProd120Carac: TMenuItem;
    NaoDescontarIssQuandoRetido1: TMenuItem;
    N13: TMenuItem;
    timerLegal: TTimer;
    Integraes1: TMenuItem;
    IntegraoIta1: TMenuItem;

    procedure NovoFormExit(Sender:TObject);
    procedure imgCaixaClick(Sender: TObject);
    procedure Sobreoprograma1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ConsultadepreosporCdigodeBarras1Click(Sender: TObject);
    procedure EscolheOBanco(Sender: TObject);
    procedure EscolheOBloqueto(Sender: TObject);
    procedure EscolheCNAB400(Sender:TObject);
    procedure EscolheCNAB240(Sender:TObject);
    procedure ExecutaOPlugin(Sender:TObject);
    procedure Cadastrodetransportadoras1Click(Sender: TObject);
    procedure Opes1Click(Sender: TObject);
    procedure Planodecontas1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DadosdoEmitente1Click(Sender: TObject);
    procedure Ajustararquivos1Click(Sender: TObject);
    procedure Image17Click(Sender: TObject);
    procedure Comissodevendedores1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Grupos1Click(Sender: TObject);
    procedure Cadastrarlicenasdeuso1Click(Sender: TObject);
    procedure UsuriosAtivos1Click(Sender: TObject);
    procedure Instalarpackcomasltimasalteraes1Click(Sender: TObject);
    procedure Postit1Click(Sender: TObject);
    procedure Cadastrodeconvnios1Click(Sender: TObject);
    procedure imgCliForClick(Sender: TObject);
    procedure imgEstoqueClick(Sender: TObject);
    procedure imgBancosClick(Sender: TObject);
    procedure imgVendasClick(Sender: TObject);
    procedure imgBackupClick(Sender: TObject);
    procedure imgConfiguracoesClick(Sender: TObject);
    procedure wwwsmallsoftcombr1Click(Sender: TObject);
    procedure imgContaReceberClick(Sender: TObject);
    procedure imgContaPagarClick(Sender: TObject);
    procedure imgOrdemServicoClick(Sender: TObject);
    procedure Cadastrodetcnicos1Click(Sender: TObject);
    procedure Calendrio1Click(Sender: TObject);
    procedure Label201MouseLeave(Sender: TObject);
    procedure Label201MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SQLMododecomando1Click(Sender: TObject);
    procedure Edit200KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure este1Click(Sender: TObject);
    procedure DBGrid200KeyPress(Sender: TObject; var Key: Char);
    procedure estardesempenho1Click(Sender: TObject);
    procedure PopupMenu1Change(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure Liberarosmdulosparaesteusurio1Click(Sender: TObject);
    procedure RegistrodoProgramaonline1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid200KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelecionarCertificadoDigital1Click(Sender: TObject);
    procedure estarservidorNFE1Click(Sender: TObject);
    procedure ConfigurarlogotipodoDANFE1Click(Sender: TObject);
    procedure ConfigurarServidoresHomologao1Click(Sender: TObject);
    procedure ConfigurarServidoresProduo1Click(Sender: TObject);
    procedure ConfigurarNFEINI1Click(Sender: TObject);
    procedure InutilizarNFe1Click(Sender: TObject);
    procedure estarDisponibilidadedeServiosdasSecretariasdeFazenda1Click(
      Sender: TObject);
    procedure Verificarcadastro1Click(Sender: TObject);
    procedure SincronizarSmallMobile1Click(Sender: TObject);
    procedure SCANSistemadeContingnciadoAmbienteNacional1Click(
      Sender: TObject);
    procedure DownloadSmallMobile1Click(Sender: TObject);
    procedure Formatododanfe1Click(Sender: TObject);
    procedure Ambiente1Click(Sender: TObject);
    procedure ConfiguraodoDANFEparaNFe1Click(Sender: TObject);
    procedure ConfiguraodaNFe2Click(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SQLCommandoexterno1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ZiparXMLnoenvioporemail1Click(Sender: TObject);
    procedure Enviardanfeporemail1Click(Sender: TObject);
    procedure Comandos1Click(Sender: TObject);
    procedure AtualizartabelaIBPT1Click(Sender: TObject);
    procedure Estatisticas1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ConfiguraodaNFemformulrionumerado1Click(Sender: TObject);
    procedure N3101Click(Sender: TObject);
    procedure SVCSefazVirtualdeContingncia1Click(Sender: TObject);
    procedure imgCaixaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label202MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label201_MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label203MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label204MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label205MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label206MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label207MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label208MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label210MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure RichEdit1Enter(Sender: TObject);

    procedure ScrollMouse(var Msg: TMsg; var Handled: Boolean);
    procedure Fuso1Click(Sender: TObject);
    procedure Label200MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AutoSmallMobile1Click(Sender: TObject);
    procedure imgIndicadoresClick(Sender: TObject);
    procedure CNPJdacontabilidade1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N4001Click(Sender: TObject);
    procedure Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label_bola_NFEClick(Sender: TObject);
    procedure Label_bola_caixaClick(Sender: TObject);
    procedure Label_bola_bancoClick(Sender: TObject);
    procedure Label_bola_pagarClick(Sender: TObject);
    procedure Label_bola_cliforClick(Sender: TObject);
    procedure Label_bola_receberClick(Sender: TObject);
    procedure Label_Bola_estoqueClick(Sender: TObject);
    procedure Label_Bola_ConfigClick(Sender: TObject);
    procedure Label_bola_OSClick(Sender: TObject);
    procedure Label_bola_indicadoresClick(Sender: TObject);
    procedure HorarioDeVeraoClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ConsultarNFesemitidas1Click(Sender: TObject);
    procedure Modoinventrio1Click(Sender: TObject);
    procedure AutoMarketplace1Click(Sender: TObject);
    procedure Hub1Click(Sender: TObject);
    procedure imgComprasClick(Sender: TObject);
    procedure LAbel201CMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label201SMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgServicosClick(Sender: TObject);
    procedure Simples1Click(Sender: TObject);
    procedure Complexo1Click(Sender: TObject);
    procedure ConfiguraesdaNFSe2Click(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure Image_bola_cliforClick(Sender: TObject);
    procedure Mensagemparaenviodeemail1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure Label_Bola_vendasClick(Sender: TObject);
    procedure FazerBackupAgora1Click(Sender: TObject);
    procedure BackupAutomtico1Click(Sender: TObject);
    procedure Perfisdetribitao1Click(Sender: TObject);
    procedure NaturezaseCFOPs1Click(Sender: TObject);
    procedure ConversodeCFOP1Click(Sender: TObject);
    procedure Parmetrosdetributao1Click(Sender: TObject);
    procedure EnvioautomticodeXML1Click(Sender: TObject);
    procedure Observaonadescriodosservios1Click(Sender: TObject);
    procedure ConfiguraesdaNFSe1Click(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure FormDestroy(Sender: TObject);
    procedure ConfiguraoTEF1Click(Sender: TObject);
    procedure Clculododescontopeloprovedor1Click(Sender: TObject);
    procedure miProd120CaracClick(Sender: TObject);
    procedure NaoDescontarIssQuandoRetido1Click(Sender: TObject);
    procedure IntegraoIta1Click(Sender: TObject);
    procedure timerLegalTimer(Sender: TObject);


  private
    procedure ExibeRazaoSocialNoCaptionDoForm;
    function getPropaganda: String;
    function RetornarWhereNotasManifestar: String;
    procedure DefinirBuildEXEDAT;
    procedure EnviarXMLContabilidadeAut;
    procedure ClickOKInformacoesInutilizacao(Sender: TObject);
    procedure CarregaConfiguracoes;
    //Sandro Silva 2024-04-08 procedure AjustarDataSetCamposProduto;

  public
    { Public declarations }
    fDias : Real;
    sSerial, sMei, sModeloPAF , sNomePAF : String;
    dtStatusMonitorAberto: TDateTime;
    fAliqICMdoCliente: Double;
    AverageSpeed: Double;
    iDias, BytesParaTransferir, BytesJaTransFeridos : Integer;
    fRetencaoIR : Real;
    fRetencoes : Real;
    tCrono, tSgdb : tTime;
    iVista : Integer;
    IP, url, Alias, sConve, sOrigem : String;
    fTaxa  : Real;
    rReserva : Real;
    sPublicCheck, sSistema  : String;
    sConsultaNfse, sSerieEspecial, sArquivoRemessa, sVersaoLayout, sModoDbug, sModeloDocumentoFiscal, sRelogio, sAtual, sHtmlCor, sContrasteCor, sGrade : String;
    bHomologacao, bNotaVendaLiberada, bNotaCompraLiberada, bNotaServicoLiberada, bClientesLiberados, bFornecedoresLiberados, bFlag16Change, bChave16,
    bFlag, bChaveDoTempo, bHtml1, bPDF, bConsultarNFesEmitidas, bFechaTudo, bChaveSemaforo: Boolean;
    bModoScan : Boolean;
    bModoSVC : Boolean;
    CopiaHora: String;
    CopiaSair: String;
    sPasta   : String;
    iReduzida, iTempo, iAvisosEstoque, iAvisosNFECompra, iAvisosCaixa, iAvisosBanco, iAvisosPagar, iAvisosReceber, iAvisosCliFor, iAvisosOS, iAvisosIndicadores, iAvisosConfig: Integer;
    sEscolhido: String;
    sBancoBoleto: String;
    ConfCFOP: String;
    CFOP5124: String;
    ConfCasas : String;
    ConfCasasServ : String;
    ConfPreco : String;
    ConfAceitaCGCDuplo: String;
    ConfDupl1, ConfDupl2, ConfDupl3, ConfCusto, Confduplo,ConfNegat, ConfFoto, ConfMArca, ConfEspecie: String;
    ConfPermitFabricarSemQtd : Boolean;
    bNaoDescontarIssQuandoRetido: Boolean; // Sandro Silva 2024-04-24
    ConfSvc, ConfItens   : Integer;
    ConfLimite  : Real;
    ConfIR      : Real;
    bChaveSelecionaCliente : Boolean;
    bMediaPonderadaFixa    : Boolean;
    bMKP : Boolean;
    bPrimeiraAberturaDia : boolean;
    ValidaRecursos: TValidaRecurso; // Sandro Silva 2023-05-31
    procedure AjustarDataSetCamposProduto;// Sandro Silva 2024-04-08
    procedure RegistrodoPrograma(TermoAceito: boolean);
    procedure WMUser (var msg: TMessage); message wm_User;
    function AvisoNFECompra(bP1 : Boolean):Boolean;
    function AvisoOS(bP1 : Boolean):Boolean;
    function AvisoCaixa(bP1 : Boolean):Boolean;
    function AvisoEstoque(bP1 : Boolean):Boolean;
    function AvisoPagar(bP1 : Boolean):Boolean;
    function AvisoReceber(bP1 : Boolean):Boolean;
    function AvisoBanco(bP1 : Boolean):Boolean;
    function AvisoClifor(bP1 : Boolean):Boolean;
    function AvisoIndicadores(bP1 : Boolean):Boolean;
    function AvisoConfig(bP1 : Boolean):Boolean;
    function GetCNPJCertificado(SubjectName: String): String;
    function Small_InputForm(sP1, sP2, sP3: String) : String;
    function Small_InputFormMemo(sP1, sP3: String; MaxLength : integer) : String;
    function Small_InputForm_Dados(sP1: String) : Boolean;
    function Small_InputForm_ApenasNumeros(sP1, sP2, sP3: String; AnMaxLength: Integer = 0): String;
    function NcmDeMedicamentos(sNcm: String): Boolean;
    function BloqueiaCtrlXTField(Sender: TObject; var Key: Word;
      Shift: TShiftState): Word; // Sandro Silva 2022-10-18
    function ValidaEmitenteMunicipio: Boolean;
    procedure ConfiguraCredencialTecnospeed;
    function DisponivelSomenteParaNos: Boolean;
//    function CampoDisponivelParaUsuario(sModulo, sCampo: String): Boolean; Mauricio Parizotto 2024-05-15
    function ExisteNfseExe(sDiretorio: String): Boolean;
    procedure MensagemRecursoIndisponivel(sMensagem: String);
    function ValidaRecursoExibeMensagemIndisponivel: Boolean;
    procedure DefineAmbienteNFe(AcAmbiente, AcRotina: String);
    function Aplicar120CaracteresProduto(bExibirMensagemSucesso: Boolean): Boolean;
    function Comandos120CaracteresProd: Boolean; // Sandro Silva 2024-04-08 procedure Comandos120CaracteresProd;

    property sPropaganda: String read getPropaganda;
    function MontaTela(sP1: Boolean): Boolean;
    procedure ValidaBuildNFe_Setup;
  end;
  //
  function UploadMobile(sFile: TFileName): boolean;
  function PegaImpostosDoXML(sP1: String):Boolean;
  function AtualizaPromocao(sP1 : boolean):Boolean;
  //

var
  Form1: TForm1;
  Senha: String;
  Senha2: String;
  Usuario: String;

implementation

uses Unit11, Unit7, Unit12, Unit19, Unit24, Unit25, Unit17, Unit22,
  Unit16, Unit8, Unit38, uExportaXML, Unit43, Unit30, SelecionaCertificado,
  Unit26, Unit5, Unit37, Unit29, Unit44, Unit13, Unit48,
  uconstantes_chaves_privadas
  , ucredencialtecnospeed
  , uAtualizaBancoDados
  , uFazerBackup
  , uRetornaBuildEXE
  , uCriptografia
  , uFrmTermosUso
  , uSmallConsts
  , uConectaBancoCommerce
  , uTypesRecursos
  , uGeraCNAB240
  , uGeraCNAB400
  , uArquivosDAT
  , uMobile
  , uIconesSistema
  , uFrmConfigEmailAutContabilidade
  , uDialogs
  , uFuncoesRetaguarda
  , uRecursosSistema
  , uSmallResourceString
  , uSistema
  , uValidaRecursos
  , uFrmIntegracaoItau
  , uConfiguracaoTEFCommerce
  , uFrmContaPagar
  , uFrmContaReceber
  , uFrmCadastro
  , uFrmEstoque
  ; 

{$R *.DFM}


function GeraCheck: String;
var
  sCheck: String;
  sAno: String;
  ArqINI: TIniFile;
  slEtiquetas: TStringList;
begin

  sCheck := '';
  sAno := IntToStr(YearOf(Date) - 1);

  // 11100000000000
  // |||||||||||||||_
  // ||||||||||||||__ Small Comandas
  // |||||||||||||___ TEF
  // ||||||||||||____ NFSe
  // |||||||||||_____ OS
  // ||||||||||______ Etiquetas
  // |||||||||_______ Anvisa
  // ||||||||________ MFE - Ceará
  // |||||||_________ SPED PIS COFINS
  // ||||||__________ MDFE
  // |||||___________ CERTIFICADO A3
  // ||||____________ PAF-ECF
  // |||_____________ Serie
  // ||______________ Grade
  // |_______________ Boletos


  try

    //
    // Emite boletos nos últimos 90 dias?
    //
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from RECEBER where SubString(PORTADOR from 1 for 7) = ''BANCO ('' and EMISSAO >= (current_date - 90)');
      Form7.ibQuery1.Open;
      //
      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;
    //
    // Usa GRADE?
    //
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(distinct CODIGO) from GRADE');
      Form7.ibQuery1.Open;
      //
      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;
    //
    // Usa SERIE no último ANO?
    //
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(distinct CODIGO) from SERIE where DATVENDA >= (current_date - 90)');
      Form7.ibQuery1.Open;
      //
      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;
    //
    // Usa ECF?
    // REDUCOES SMALL <> 65 59 99 DATA no período
    //
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from REDUCOES where coalesce(SMALL, '''') <> '''' and coalesce(SMALL, ''0'') <> ''59'' and coalesce(SMALL, ''0'') <> ''65'' and coalesce(SMALL, ''0'') <> ''99'' and (TOTALF - TOTALI > 0) and DATA >= (current_date - 90)');
      Form7.ibQuery1.Open;
      //
      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;


    // Usa Certificado A3?
    //Certificado=CN=SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI:07426598000124, OU=RFB e-CNPJ A1, O=ICP-Brasil, C=BR, S=SC, L=Concordia, E=, SE=10 1E 65 E5 C5 1E 1A B1 5C 6E 62 64 85 C5 43 FC
    try
      ArqINI := TIniFile.Create(Form1.sAtual + '\nfe.ini');
      if (Pos('E-CNPJ A3', AnsiUpperCase(ArqINI.ReadString('NFE', 'Certificado', ''))) > 0) or (Pos('E-CPF A3', AnsiUpperCase(ArqINI.ReadString('NFE', 'Certificado', ''))) > 0) then sCheck := sCheck + '1' else sCheck := sCheck + '0';
      ArqIni.Free;
    except
      sCheck := sCheck + '0';
    end;


    // Usa MDF-e?
    //Verifica se a tabela MDFE existe
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select distinct F.RDB$RELATION_NAME as TABELA ');
      Form7.ibQuery1.Sql.Add('from RDB$RELATION_FIELDS F ');
      Form7.ibQuery1.Sql.Add('join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ');
      Form7.ibQuery1.Sql.Add('and R.RDB$VIEW_BLR is null ');
      Form7.ibQuery1.Sql.Add('and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ');
      Form7.ibQuery1.Sql.Add('and F.RDB$RELATION_NAME = ' + QuotedStr('MDFE'));
      Form7.ibQuery1.Open;

      if (Form7.ibQuery1.FieldByName('TABELA').AsString <> '') then
      begin
        // tem a tabela, agora verifica se emitiu MDF-e no período definido
        Form7.ibQuery1.Close;
        Form7.ibQuery1.Sql.Clear;
        Form7.ibQuery1.Sql.Add('select count(REGISTRO) from MDFE where coalesce(MDFEXML, '''') like ''%<tpAmb>1</tpAmb>%'' and (STATUS like ''%encerrado'' or STATUS like ''Autorizado%'') and EMISSAO >= (current_date - 90)'); // 16 milisegundos para banco 600MB
        Form7.ibQuery1.Open;

        if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';

      end
      else
      begin
        sCheck := sCheck + '0';
      end;
    except
      sCheck := sCheck + '0';
    end;

    // Usa SPED PIS COFINS?
    // gerou sped pis cofins nos últimos 365 dias
    try
      ArqINI := TIniFile.Create(Form1.sAtual + '\SPED.ITF');
      if StrToDate(ArqINI.ReadString('SPED_PIS_COFINS', 'DATAF', '01/01/2011')) >= (Date - 90) then sCheck := sCheck + '1' else sCheck := sCheck + '0';
      ArqINI.Free;
    except
      sCheck := sCheck + '0';
    end;


    // Usa MFE Ceará?
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from NFCE where (select upper(ESTADO) from emitente) = ''CE'' and MODELO = ''59'' and STATUS like ''%Emitid%'' and NFEXML containing ''<tpAmb>1</tpAmb>'' and DATA >= (current_date - 90)'); // 16 milisegundos banco 600MB
      Form7.ibQuery1.Open;
      //
      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;

    // Usa Anvisa?
    // Tem que ter COMPRAS.ANVISA, estar preenchi com 1 e a data da compra dentro dos  últimos 60 dias
    // primeiro ver se tem o campo ANVISA na tabela COMPRAS
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select distinct F.RDB$RELATION_NAME as TABELA ');
      Form7.ibQuery1.Sql.Add('from RDB$RELATION_FIELDS F ');
      Form7.ibQuery1.Sql.Add('join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ');
      Form7.ibQuery1.Sql.Add('and R.RDB$VIEW_BLR is null ');
      Form7.ibQuery1.Sql.Add('and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ');
      Form7.ibQuery1.Sql.Add('and F.RDB$RELATION_NAME = ' + QuotedStr('COMPRAS'));
      Form7.ibQuery1.Sql.Add('and F.RDB$FIELD_NAME = ' + QuotedStr('ANVISA'));
      Form7.ibQuery1.Open;
      if (Form7.ibQuery1.FieldByName('TABELA').AsString <> '') then
      begin
        // tem o campo na tabela, agora verifica se tem movimento no período que foi transmitido para avisa
        Form7.ibQuery1.Close;
        Form7.ibQuery1.Sql.Clear;
        Form7.ibQuery1.Sql.Add('select count(REGISTRO) from COMPRAS where coalesce(ANVISA, '''') = ''1'' and EMISSAO >= (current_date - 90)');
        Form7.ibQuery1.Open;
        if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
      end
      else
      begin
        sCheck := sCheck + '0';
      end;
    except
      sCheck := sCheck + '0';
    end;
    // Etiqueta termica bobina Zebra/Argox
    // Procura se tem configurado uma etiqueta
    try
      if FileExists(Form1.sAtual + '\etiquetase.ini') then
      begin
        slEtiquetas := TStringList.Create;
        slEtiquetas.LoadFromFile(Form1.sAtual + '\etiquetase.ini');
        if AnsiContainsText(slEtiquetas.Text, 'IMPRESSORA=') and AnsiContainsText(slEtiquetas.Text, 'PADRAOIMPRESSAO=') then sCheck := sCheck + '1' else sCheck := sCheck + '0';
        slEtiquetas.Free;
      end else
      begin
        sCheck := sCheck + '0';
      end;
    except
      sCheck := sCheck + '0';
    end;
    // Usa OS?
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      //Form7.ibQuery1.Sql.Add('select count(REGISTRO) from OS where coalesce(NF, '''') <> '''' and DATA >= (current_date - 90)'); OS faturadas?
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from OS where DATA >= (current_date - 90)');
      Form7.ibQuery1.Open;

      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;

    // Usa NFSE?
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from VENDAS where STATUS = ''AUTORIZADA'' and MODELO = ''SV'' and EMISSAO >= current_date - 90');
      Form7.ibQuery1.Open;

      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;

    // Usa TEF?
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from RECEBER where HISTORICO like ''Cartão%'' and HISTORICO like ''%trans%'' and EMISSAO >= current_date - 90');
      Form7.ibQuery1.Open;

      if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 10 then sCheck := sCheck + '1' else sCheck := sCheck + '0';
    except
      sCheck := sCheck + '0';
    end;

    // Usa Small Comandas
    // Tem que ter na tabela GRUPO.DESTINO configurada com os destinos de impressão dos pedidos
    // primeiro ver se tem a tabela GRUPO.DESTINO
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select distinct F.RDB$RELATION_NAME as TABELA ');
      Form7.ibQuery1.Sql.Add('from RDB$RELATION_FIELDS F ');
      Form7.ibQuery1.Sql.Add('join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ');
      Form7.ibQuery1.Sql.Add('and R.RDB$VIEW_BLR is null ');
      Form7.ibQuery1.Sql.Add('and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ');
      Form7.ibQuery1.Sql.Add('and F.RDB$RELATION_NAME = ' + QuotedStr('GRUPO'));
      Form7.ibQuery1.Sql.Add('and F.RDB$FIELD_NAME = ' + QuotedStr('DESTINO'));
      Form7.ibQuery1.Open;

      if (Form7.ibQuery1.FieldByName('TABELA').AsString <> '') then
      begin
        // tem o campo na tabela, agora verifica se tem movimento no período que foi transmitido para avisa
        Form7.ibQuery1.Close;
        Form7.ibQuery1.Sql.Clear;
        Form7.ibQuery1.Sql.Add('select count(REGISTRO) from GRUPO where coalesce(DESTINO, '''') <> '''' ');
        Form7.ibQuery1.Open;

        if Form7.ibQuery1.FieldByname('COUNT').AsFloat > 0 then
          sCheck := sCheck + '1' else sCheck := sCheck + '0';
      end else
      begin
        sCheck := sCheck + '0';
      end;
    except
      sCheck := sCheck + '0';
    end;
  except
    sCheck := '';
  end;
  Result := sCheck;
end;


{ Mauricio Parizotto 2023-12-29
function GetSystemPath(Folder: Integer): string;
var
  PIDL: PItemIDList;
  Path: LPSTR;
  AMalloc: IMalloc;
begin
  Path := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);

  if SHGetPathFromIDList(PIDL, Path) then Result := Path;

  SHGetMalloc(AMalloc);
  AMalloc.Free(PIDL);
  StrDispose(Path);
end;
}


function ApagaArquivoNoDeskTop(sP1:String): boolean;
begin
  //DeleteFile(pChar(GetSystemPath(0)+'\'+sP1)); Mauricio Parizotto 2023-12-29
  DeleteFile(ExtractFilePath(Application.ExeName)+'sP1');
  DeleteFile(pChar('c:\Users\Public\Desktop\'+Sp1));
  DeleteFile(pChar('c:\Documents and Settings\All Users\Desktop\'+sP1));

  Result := True;
end;

procedure CreateShortcut(FileName, Parameters, InitialDir, ShortcutName, ShortcutFolder : String);
var
  MyObject : IUnknown;
  MySLink : IShellLink;
  MyPFile : IPersistFile;
  Directory : String;
  WFileName : WideString;
  MyReg : TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
    SetArguments(pChar(Parameters));
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(InitialDir));
  end;
  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  Directory := MyReg.ReadString ('Shell Folders','Desktop','');
  WFileName := Directory + '\' + ShortcutName + '.lnk';
  MyPFile.Save (PWChar (WFileName), False);
  MyReg.Free;
end;


function GravarInutilizacao(sXML: String; IBQuery: TIBQuery): Boolean;
var
  sModelo: String;
  sAno: String;
  sSerie: String;
  iNINI: Integer;
  iNFIN: Integer;
  sNPROT: String;
  sData: String;
begin
  Result := False;

  try
    if xmlNodeValue(sXML, '//infInut/cStat') = '102' then
    begin
      sModelo := xmlNodeValue(sXML, '//infInut/mod');
      sAno    := xmlNodeValue(sXML, '//infInut/ano');
      sSerie  := xmlNodeValue(sXML, '//infInut/serie');

      if sModelo = '57' then
      begin
        iNINI := StrToIntDef(xmlNodeValue(sXML, '//infInut/nCTIni'), 0);
        iNFIN := StrToIntDef(xmlNodeValue(sXML, '//infInut/nCTFin'), 0);
      end else
      begin
        iNINI := StrToIntDef(xmlNodeValue(sXML, '//infInut/nNFIni'), 0);
        iNFIN := StrToIntDef(xmlNodeValue(sXML, '//infInut/nNFFin'), 0);
      end;
      sNPROT := xmlNodeValue(sXML, '//infInut/nProt');
      sData  := Copy(xmlNodeValue(sXML, '//infInut/dhRecbto'), 1, 10);
      sData  := Copy(sData, 9, 2) + '/' + Copy(sData, 6, 2) + '/' + Copy(sData, 1, 4);
      if (iNINI > 0) and (iNFIN > 0) then
      begin

        IBQuery.Close;
        IBQuery.SQL.Text :=
          'insert into INUTILIZACAO (REGISTRO, MODELO, ANO, SERIE, NINI, NFIN, XML, NPROT, DATA) ' +
          'values (right(''0000000000''||gen_id(G_INUTILIZACAO, 1), 10), :MODELO, :ANO, :SERIE, :NINI, :NFIN, :XML, :NPROT, :DATA)';
        IBQuery.ParamByName('MODELO').AsString   := sModelo;
        IBQuery.ParamByName('ANO').AsString      := sAno;
        IBQuery.ParamByName('SERIE').AsString    := sSerie;
        IBQuery.ParamByName('NINI').AsInteger    := iNINI;
        IBQuery.ParamByName('NFIN').AsInteger    := iNFIN;
        IBQuery.ParamByName('XML').AsString      := sXML;
        IBQuery.ParamByName('NPROT').AsString    := sNPROT;
        IBQuery.ParamByName('DATA').AsString     := sData;
        IBQuery.ExecSQL;
        Result := True
      end;
    end;
  except
  end;
end;


function Aviso2(sP1: String) : Boolean;
begin
  Form29.EscondeComponentesPadrao;
  Form29.btnOK.Visible := False;
  Form29.lblTitulo2.Caption  := sP1;
  Form29.Show;
  Form29.Repaint;
  Result := True;
end;


function Aviso(sP1: String) : Boolean;
begin
  Form29.EscondeComponentesPadrao;
  Form29.lblTitulo2.Caption := sP1;
  Form29.ShowModal;

  Result := True;
end;

function tForm1.Small_InputForm_Dados(sP1: String) : boolean;
begin
  Form29.EscondeComponentesPadrao;

  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  form29.Label3.Caption := sP1;
  Form29.Panel_Dados.Visible  := True;
  Form29.btnCancelar.Visible  := True;

  Form29.ShowModal;

  Form29.Panel_Dados.Visible  := False;
  Form7.AlphaBlendValue := 255;
  Form29.Edit1.Text     := '';

  if Form29.btnCancelar.Visible then
    Result := Form29.ClicouOK
  else
    Result := True;
end;

function tForm1.Small_InputForm(sP1, sP2, sP3: String) : String;
begin
  Form29.EscondeComponentesPadrao;
  Form29.btnCancelar.Visible      := True;

  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  Form29.lblTitulo2.Caption := sP1+chr(10)+chr(10)+sP2;

  Form29.Edit1.Visible  := True;
  Form29.Edit1.Text     := sP3;
  Form29.Edit1.Left     := Form29.lblTitulo2.Left;

  Form29.ShowModal;

  //Result                := Form29.Edit1.Text; Mauricio Parizotto 2023-11-22
  if Form29.ClicouOK then
    Result := Form29.Edit1.Text
  else
    Result := sP3;

  Form29.Edit1.Visible  := False;
  Form7.AlphaBlendValue := 255;
  Form29.Edit1.Text     := '';
end;

function tForm1.Small_InputFormMemo(sP1, sP3: String; MaxLength : integer) : String;
begin
  Form29.EscondeComponentesPadrao;
  Form29.btnCancelar.Visible  := True;

  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  Form29.lblTitulo2.Caption := sP1;

  Form29.memTexto.Visible         := True;
  Form29.lblCaracteresMax.Visible := True;
  Form29.memTexto.Text            := sP3;
  Form29.memTexto.Left            := 60;
  Form29.memTexto.Height          := 210;
  Form29.memTexto.Top             := 170;
  Form29.memTexto.Width           := 910;
  Form29.memTexto.MaxLength       := MaxLength;
  Form29.lblCaracteresMax.Left    := 60;
  Form29.lblCaracteresMax.top     := 390;

  Form29.ShowModal;

  if Form29.ClicouOK then
    Result := Form29.memTexto.Text
  else
    Result := sP3;

  Form29.memTexto.Visible  := False;
  Form7.AlphaBlendValue := 255;
  Form29.memTexto.Text     := '';
end;

function tForm1.Small_InputForm_ApenasNumeros(sP1, sP2, sP3: String; AnMaxLength: Integer = 0) : String;
begin
  Form29.EscondeComponentesPadrao;
  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  Form29.lblTitulo2.Caption := sP1+chr(10)+chr(10)+sP2;

  Form29.Edit1.Visible  := True;
  Form29.Edit1.Text     := sP3;
  Form29.Edit1.Left     := Form29.lblTitulo2.Left;

  Form29.MaxLength := AnMaxLength;
  Form29.DefinirSomenteNumeros;

  Form29.ShowModal;

  Result                := Form29.Edit1.Text;

  Form29.Edit1.Visible  := False;
  Form7.AlphaBlendValue := 255;
  Form29.Edit1.Text     := '';
end;


function tForm1.GetCNPJCertificado(SubjectName: String): String;
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


function tForm1.AvisoNFECompra(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  {Sandro Silva 2023-06-20 inicio
  Form1.ibQuery2.SQL.Add('select count(NUMERONF)as NN');
  Form1.ibQuery2.SQL.Add('from COMPRAS');
  Form1.ibQuery2.SQL.Add('where ' + RetornarWhereNotasManifestar);
  }
  Form1.ibQuery2.SQL.Text :=
    'select count(NUMERONF)as NN ' +
    'from COMPRAS ' +
    'where ' + RetornarWhereNotasManifestar;

  {Sandro Silva 2023-06-20 fim}
  Form1.ibQuery2.Open;
  Form1.iAvisosNFECompra := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoCaixa(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from CAIXA where coalesce(NOME,'+QuotedStr('')+')='+QuotedStr('')+' ');
  Form1.ibQuery2.Open;
  Form1.iAvisosCaixa := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoClifor(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from CLIFOR where PROXDATA=CURRENT_DATE');
  Form1.ibQuery2.Open;
  Form1.iAvisosClifor := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoReceber(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  // Sandro Silva 2023-09-11 Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from RECEBER where VALOR_RECE=0 and VENCIMENTO=CURRENT_DATE');
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from RECEBER where ' + SQL_CONDICAO_RECEBER_HOJE); // Define zero para VALOR_RECE nulo
  Form1.ibQuery2.Open;
  Form1.iAvisosReceber := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoEstoque(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from ESTOQUE where QTD_ATUAL<QTD_MINIM and coalesce(ATIVO,0)<>1');
  Form1.ibQuery2.Open;
  Form1.iAvisosEstoque := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoOS(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from OS where DATA_PRO=CURRENT_DATE');
  Form1.ibQuery2.Open;
  Form1.iAvisosOS := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function tForm1.AvisoIndicadores(bP1 : Boolean):Boolean;
begin
  try
    iAvisosIndicadores := 0;

    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_RECEBER,0) from rdb$database');
    Form1.ibQuery2.Open;

    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
      iAvisosIndicadores := iAvisosIndicadores + 1;

    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_VENDAS,0) from rdb$database');
    Form1.ibQuery2.Open;

    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
      iAvisosIndicadores := iAvisosIndicadores + 1;

    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('select gen_id(G_GRAFICO_CAIXA,0) from rdb$database');
    Form1.ibQuery2.Open;

    if Form1.ibQuery2.FieldByname('GEN_ID').AsString <> '1' then
      iAvisosIndicadores := iAvisosIndicadores + 1;
  except
  end;

  Result := True;
end;

function tForm1.AvisoPagar(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from PAGAR where VALOR_PAGO=0 and VENCIMENTO=CURRENT_DATE');
  Form1.ibQuery2.Open;
  Form1.iAvisosPagar := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);
  //
  Result := True;
end;

function tForm1.AvisoConfig(bP1 : Boolean):Boolean;
begin
  Form1.iAvisosConfig := 0;
  if Pos('@',Form7.ibDataSet13EMAIL.AsString) = 0        then
    Form1.iAvisosConfig := Form1.iAvisosConfig + 1;
  if LimpaNumero(Form7.ibDataSet13TELEFO.AsString) = ''  then
    Form1.iAvisosConfig := Form1.iAvisosConfig + 1;
  if AllTrim(Form7.ibDataSet13ESTADO.AsString) = ''      then
    Form1.iAvisosConfig := Form1.iAvisosConfig + 1;
  if AllTrim(Form7.sCNPJContabilidade) = ''              then
    Form1.iAvisosConfig := Form1.iAvisosConfig + 1;
  Result := True;
end;

function tForm1.AvisoBanco(bP1 : Boolean):Boolean;
begin
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Clear;
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from MOVIMENT where coalesce(COMPENS,'+QuotedStr('26/09/1967')+')='+QuotedStr('26/09/1967')+' ');
  Form1.ibQuery2.Open;
  Form1.iAvisosBanco := StrToInt(Form1.IBQuery2.FieldByName('NN').AsString);

  Result := True;
end;

function GetWinDir: string;
var
  dir: array [0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(dir, MAX_PATH);
  Result := StrPas(dir);
end;

function ValidaHostsWindows: Boolean;
var
  sl: TStringList;
  i: Integer;
  scaminhoHosts: String;
  bBlock: Boolean;
begin
  sl := TStringList.Create;
  bBlock := False;
  try
    scaminhoHosts := GetWinDir + '\System32\drivers\etc\hosts'; // Win 7, 8, 8.1, 10
    if scaminhoHosts <> '' then
    begin
      sl.LoadFromFile(scaminhoHosts);
      if AnsiContainsText(sl.Text, 'smallsoft.com.br') then
      begin
        for i := 0 to sl.Count -1 do
        begin
          if (Copy(sl.Strings[i], 1, 1) <> '#') and (AnsiContainsText(sl.Strings[i], 'smallsoft.com.br')) then
          begin
            bBlock := True;
            Break;
          end;
        end;
      end;
    end;
  except

  end;
  sl.Free;
  Result := bBlock;
end;


function Legal_ok(sP1 : Boolean):Boolean;
begin
  // LEGAL
  try
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_LEGAL,0) from rdb$database');
    Form1.ibDataset200.Open;

    if Form1.ibDataSet200.FieldByname('GEN_ID').AsString <> '0' then
    begin
      Result := False;
    end else
    begin
      Result := True;
    end;
  except
    Result := True;
  end;
end;


function Regularize: boolean;
var
  Mais1ini: tIniFile;
  documentoAtivo: variant;
  sSerie, sInicio, s: String;
  CredencialTecnospeed: TCredenciaisTecnospeed;

  GeraAviso: boolean;
begin
  Result := False;

  try
    documentoAtivo := Form1.WebBrowser1.Document;
    s := documentoAtivo.Body.OuterHTML;

    {Sandro Silva 2022-12-15 inicio}
    CredencialTecnospeed := TCredenciaisTecnospeed.Create; // Sandro Silva 2022-12-15
    CredencialTecnospeed.PrivateKey := Form1.sPasta;
    CredencialTecnospeed.SalvaCredencial(Form1.sAtual, s);
    CredencialTecnospeed.Free;
    {Sandro Silva 2022-12-15 fim}

    if ValidaHostsWindows then
    begin
      s := '[PARATUDO]';
    end;

    if pos('[INICIO', S) <> 0 then
    begin
      try
        sInicio := Copy(S, pos('[INICIO', S) + 8, 10);
        Form7.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta

        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('update EMITENTE set LICENCA='+QuotedStr(Form7.LbBlowfish1.EncryptString(  Copy(sInicio,7,4)+Copy(sInicio,4,2)+Copy(sInicio,1,2))));
        Form1.ibQuery2.ExecSQL;

        AgendaCommit(true);
      except
      end;
    end;

    if pos('[LIMITE', S) <> 0 then
    begin
      try
        sInicio := Copy(S, pos('[LIMITE', S) + 8, 10);  // Contem a data limite de uso do sistema
        Form7.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta

        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('update EMITENTE set LICENCA='+QuotedStr(Form7.LbBlowfish1.EncryptString(  Copy(sInicio,7,4)+Copy(sInicio,4,2)+Copy(sInicio,1,2))));
        Form1.ibQuery2.ExecSQL;

        AgendaCommit(true);
      except
      end;
    end;

    if pos('[SERIE',S) <> 0 then
    begin
      try
        sSerie := Copy(S,pos('[SERIE',S)+7,13);

        if sSerie <> '' then
        begin
          if sSerie <> Form1.sSerial then
          begin
            Mais1ini := TIniFile.Create('WIND0WS.L0G');
            Mais1Ini.WriteString('LICENCA','Ser',sSerie); // Cadastro Licença de uso
            Mais1Ini.WriteString('RR','Ser',sSerie); // Cadastro Licença de uso
            Mais1Ini.Free;
          end;
        end;
      except
      end;
    end;

    if (pos('REGULARIZE',UpperCase(S)) <> 0)
      or (pos('[BLOQUEADO1]',UpperCase(S)) <> 0)
      or (pos('[BLOQUEADO2]',UpperCase(S)) <> 0)
      or (pos('[PARATUDO]',UpperCase(S)) <> 0) then
    begin
      {
      if (pos('[PARATUDO]',UpperCase(S)) <> 0) then
      begin
        if Legal_ok(True) then
        begin
          try
            Form1.ibDataset200.Close;
            Form1.ibDataset200.SelectSql.Clear;
            Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
            Form1.ibDataset200.Open;

            MensagemSistema('Este sistema foi bloqueado');
          except
          end;
        end;
      end else
      begin
        if Legal_ok(True) then
        begin
          try
            Form1.ibDataset200.Close;
            Form1.ibDataset200.SelectSql.Clear;
            Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to ' + Copy(dateToStr(Date),7,4) + Copy(dateToStr(Date),4,2) + Copy(dateToStr(Date),1,2) );
            Form1.ibDataset200.Open;
          except
          end;
        end;
      end;
      }
      try
        //Estava liberado e vai ser bloqueado
        GeraAviso := Legal_ok(True);

        Form1.ibDataset200.Close;
        Form1.ibDataset200.SelectSql.Clear;
        Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
        Form1.ibDataset200.Open;

        if GeraAviso then
          MensagemSistema('Este sistema foi bloqueado');
      except
      end;
    end else
    begin
      if pos('LEGAL',UpperCase(S)) <> 0 then
      begin
        try
          Form1.ibDataset200.Close;
          Form1.ibDataset200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 0');
          Form1.ibDataset200.Open;
        except
        end;

        Result := True;
      end else
      begin
        //Sem retorno nenhum
        if Legal_ok(True) then
        begin
          try
            Form1.ibDataset200.Close;
            Form1.ibDataset200.SelectSql.Clear;
            Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to ' + Copy(dateToStr(Date),7,4) + Copy(dateToStr(Date),4,2) + Copy(dateToStr(Date),1,2));
            Form1.ibDataset200.Open;
          except
          end;
        end;
      end;

      (* Mauricio Parizotto 2024-05-20
      if (pos('[BUILD]',UpperCase(S)) <> 0) or (pos('[VERSAO]',UpperCase(S)) <> 0) then
      begin
        //Verifica se só tem um usuário conectado
        vQtdConexoes := ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase,
                                              'Select Count( * ) From MON$ATTACHMENTS');
        if vQtdConexoes = 1 then
        begin
          bButton := Application.MessageBox(Pchar(
                                            'Uma nova versão do Small Commerce está disponível para download (este procedimento demora apenas alguns minutos).'+
                                            Chr(10) +
                                            Chr(10) +
                                            'Continuar?' +
                                            Chr(10))
                                            ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);

          if bButton = IDYES then
          begin
            if FileExists(Form1.sAtual+'\smallcon.exe') then
            begin
              {Sandro Silva 2024-01-12 inicio
              ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20231001.sma '+
                                                             '20231002.sma '+
                                                             '20231003.sma '+
                                                             '20231004.sma '+
                                                             '20231005.sma '+
                                                             '20231006.sma '+
                                                             '20231007.sma '+
                                                             '20231008.sma '+
                                                             '20231009.sma '+
                                                             'nfce2023.sma '+
                                                             '2023_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma ')
                                                             , '', SW_SHOW);
              }
              ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20241001.sma '+
                                                             '20241002.sma '+
                                                             '20241003.sma '+
                                                             '20241004.sma '+
                                                             '20241005.sma '+
                                                             '20241006.sma '+
                                                             '20241007.sma '+
                                                             '20241008.sma '+
                                                             '20241009.sma '+
                                                             'nfce2024.sma '+
                                                             '2024_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma ')
                                                             , '', SW_SHOW);
              {Sandro Silva 2024-01-12 fim}

            end
            else
              MensagemSistema('Arquivo smallcon.exe não encontrado.');

            Winexec('TASKKILL /F /IM "smallcdf.exe"', SW_HIDE );
            Winexec('TASKKILL /F /IM "mobile.exe"', SW_HIDE );
            Winexec('TASKKILL /F /IM "mkp.exe"', SW_HIDE );
            Winexec('TASKKILL /F /IM "Small Commerce.exe"', SW_HIDE );
            Winexec('TASKKILL /F /IM small22.exe', SW_HIDE );
            Winexec('TASKKILL /F /IM nfe.exe', SW_HIDE );
            FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
          end;
        end;
      end;

      *)

      if pos('[LOJA]',UpperCase(S)) <> 0 then
      begin
        ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br/loja/atualiza-via-small?serial='
          +AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))
          +'&cnpj='+LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString))
          ,'', '', SW_SHOWMAXIMIZED);
      end;

      if pos('[REVENDA]',UpperCase(S)) <> 0 then
      begin
        ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br/loja/atualiza-via-small?serial='
          +AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))
          +'&cnpj='+LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString))
          ,'', '', SW_SHOWMAXIMIZED);
      end;

      if pos('[AVISO]',UpperCase(S)) <> 0 then
      begin
        ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br/loja/aviso-via-small?serial='
          +AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))
          +'&cnpj='+LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString))
          ,'', '', SW_SHOWMAXIMIZED);
      end;

      if (pos('[BLOQUEADO1]',UpperCase(S)) <> 0) or (pos('[BLOQUEADO2]',UpperCase(S)) <> 0) then
      begin
        MensagemSistema('Este sistema não está liberado.'
                        ,msgAtencao);
      end;
    end;
  except
  end;
end;

procedure VerificaNovaBuild;
var
  s: String;
  vQtdConexoes : integer;
  documentoAtivo: variant;
  bButton: Integer;
begin
  try
    documentoAtivo := Form1.WebBrowser1.Document;
    s := documentoAtivo.Body.OuterHTML;

    if (pos('[BUILD]',UpperCase(S)) <> 0) or (pos('[VERSAO]',UpperCase(S)) <> 0) then
    begin
      //Verifica se só tem um usuário conectado
      vQtdConexoes := ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase,
                                            'Select Count(*) From MON$ATTACHMENTS');
      if vQtdConexoes = 1 then
      begin
        bButton := Application.MessageBox(Pchar(
                                          'Uma nova versão do Small Commerce está disponível para download (este procedimento demora apenas alguns minutos).'+
                                          Chr(10) +
                                          Chr(10) +
                                          'Continuar?' +
                                          Chr(10))
                                          ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);

        if bButton = IDYES then
        begin
          if FileExists(Form1.sAtual+'\smallcon.exe') then
          begin
            ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20241001.sma '+
                                                           '20241002.sma '+
                                                           '20241003.sma '+
                                                           '20241004.sma '+
                                                           '20241005.sma '+
                                                           '20241006.sma '+
                                                           '20241007.sma '+
                                                           '20241008.sma '+
                                                           '20241009.sma '+
                                                           'nfce2024.sma '+
                                                           '2024_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma ')
                                                           , '', SW_SHOW);
          end
          else
            MensagemSistema('Arquivo smallcon.exe não encontrado.');

          Winexec('TASKKILL /F /IM "smallcdf.exe"', SW_HIDE );
          Winexec('TASKKILL /F /IM "mobile.exe"', SW_HIDE );
          Winexec('TASKKILL /F /IM "mkp.exe"', SW_HIDE );
          Winexec('TASKKILL /F /IM "Small Commerce.exe"', SW_HIDE );
          Winexec('TASKKILL /F /IM small22.exe', SW_HIDE );
          Winexec('TASKKILL /F /IM nfe.exe', SW_HIDE );
          FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
        end;
      end;
    end;
  except

  end;
end;


function GetComputerNameFunc : String;
//Sandro Silva 2015-04-06 inicio
// Retorna o nome do computador usado para gravar em REDUCOES quando NFC-e ou CF-e-SAT
var
  sIpBuffer : String;
  dwSize : DWord;
begin
  dwSize := 255;
  SetLength(sIpBuffer, dwSize);
  if GetComputerName(PChar(sIpBuffer),dwSize) then
    Result := PChar(sIpBuffer);
end;

function ProcessFileName(PID: DWORD): string;
var
  Handle: THandle;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
  begin
    try
      SetLength(Result, MAX_PATH);
      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
      else
        Result := '';
    finally
      CloseHandle(Handle);
    end;
  end;
end;

procedure FecharAplicacaoPID(sNomeExeComCaminho: String);
const
   PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if AnsiUpperCase(ProcessFileName(FProcessEntry32.th32ProcessID)) = AnsiUpperCase(sNomeExeComCaminho)  then
    begin
      //WinExec(PChar('taskkill /PID ' + IntToStr(FProcessEntry32.th32ProcessID) + ' /F'), SW_HIDE); Mauricio Parizotto 2023-12-29
      WinExec(PAnsiChar(AnsiString('taskkill /PID ' + IntToStr(FProcessEntry32.th32ProcessID) + ' /F')), SW_HIDE);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{Sandro Silva 2023-04-12 inicio
procedure DropViewProcedure;
begin
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$relation_name as OBJETO ' +
      'from rdb$relations ' +
      'where rdb$view_blr is not null ' +
      'and (rdb$system_flag is null or rdb$system_flag = 0)';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop view ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$procedure_name as OBJETO ' +
      'from rdb$procedures ' +
      'where rdb$system_flag is null or rdb$system_flag = 0';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop procedure ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$trigger_name  as OBJETO ' +
      'from rdb$triggers ' +
      'where (rdb$system_flag = 0 or rdb$system_flag is null)';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop trigger ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
end;
}

procedure ValidaRazaoSmall;
var
  Mais2Ini: TIniFile;
  sRazao: String;
begin
  try
    //Mais2ini := TIniFile.Create('arquivoauxiliarcriptografadopafecfsmallsoft.ini');
    Mais2ini := TIniFile.Create(NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF); // Sandro Silva 2022-12-02 Unochapeco Mais2ini := TIniFile.Create('arquivoauxiliarcriptografadopafecfsmallsoft.ini');
    Form7.LbBlowfish1.GenerateKey(Form1.sPasta);
    sRazao := Form7.LbBlowfish1.DecryptString(Mais2Ini.ReadString('R01','17',RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF));
    if AnsiContainsText(AnsiUpperCase(Trim(sRazao)), 'SMALLSOFT') then // Sandro Silva 2023-01-02 if AnsiUpperCase(Right(Trim(sRazao), 4)) = 'LTDA' then
      Mais2Ini.WriteString('R01','17',Form7.LbBlowfish1.EncryptString(RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF));
    Mais2Ini.Free;
  except
  end;
end;

function mensagem22(sP1 : String) : Boolean;
begin
  Form22.Label6.Caption := sP1;
  Form22.Label6.Width   := Screen.Width;
  Form22.Label6.Repaint;

  Result := True;
end;

function InstalaAtualizacao(pP1, pP2: String) : Boolean;
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  try
    if FileExists(Form1.sAtual+'\'+pP1+'.~~1') then
    begin
      if pP2 = '7' then
      begin
        try
          FecharAplicacaoPID(ExtractFilePath(Application.ExeName) + 'cdf_to\jre\bin\javaw.exe'); // fecha aplicação da SEFAZ
          Sleep(1000); //tempo de aplicação fechar
        except end;
      end;

      Form1.Timer1.Enabled := False;
      Form1.Timer2.Enabled := False;

      Mensagem22('Aguarde instalando arquivos de atualização ('+pP2+')...');

      while FileExists(Form1.sAtual+'\'+pP1+'.exe') do
      begin
        DeleteFile(pChar(Form1.sAtual+'\'+pP1+'.exe'));
        Sleep(1000);
      end;

      while not FileExists(Form1.sAtual+'\'+pP1+'.exe') do
      begin
        CopyFile(pChar(Form1.sAtual+'\'+pP1+'.~~1'),pChar(Form1.sAtual+'\'+pP1+'.exe'),false);
        Sleep(100);
      end;

      if FileExists(Form1.sAtual+'\'+pP1+'.EXE') then
        //Winexec(pChar(Form1.sAtual+'\'+pP1+'.exe /verysilent'), SW_HIDE );
        WinExec(PAnsiChar(AnsiString( Form1.sAtual+'\'+pP1+'.exe /verysilent' )), SW_HIDE);

      while FileExists(Form1.sAtual+'\'+pP1+'.~~1') do
      begin
        DeleteFile(pChar(Form1.sAtual+'\'+pP1+'.~~1'));
        Sleep(100);
      end;

      while ConsultaProcesso(''+pP1+'.exe') do
      begin
        Application.ProcessMessages;
        sleep(100);
      end;

      if pP2 = '3' then
      begin
        try
          ShellExecute( 0, 'Open', 'ie4uinit.exe'  ,'-ClearIconCache'                                 ,'',SW_HIDE);

          if FileExists('c:\windows\explorer.exe') then
          begin
            Winexec('TASKKILL /F /IM explorer.exe' , SW_HIDE );
            Sleep(1000);
            Winexec('c:\windows\explorer.exe' , SW_SHOW );
          end;
        except end;
      end;
    end;
  except end;

  Screen.Cursor := crDefault;

  Result := True;
end;

function DownloadDoArquivo(pP1: String; pP2: String) : Boolean;
begin
  try
    UrlDownloadToFile(nil, PChar(pP1),PChar(pP2), 1, nil);
  except
  end;

  Result :=True;
end;

procedure TForm1.ScrollMouse(var Msg: TMsg; var Handled: Boolean);
var
  {$IFDEF VER150}
  iParam: Smallint;
  {$ELSE}
  iParam: integer;
  {$ENDIF}
begin
  if Msg.message = WM_MOUSEWHEEL then
  begin
    Msg.message := WM_KEYDOWN;
    Msg.lParam  := 0;
    {$IFDEF VER150}
    iParam := HiWord(Msg.wParam) ;
    if iParam > 0 then
      Msg.wParam := VK_UP
    else
      Msg.wParam := VK_DOWN;
    {$ELSE}
    iParam := HiWord(Msg.wParam) ;
    if iParam <= 120 then
      Msg.wParam := VK_UP
    else
      Msg.wParam := VK_DOWN;
    {$ENDIF}

    Handled := False;
  end;
end;

function Titulo(sP1, sP2: String; const sModulo: String = ''): Boolean;
begin
  Form1.Panel4.Visible  := False;
  //Form1.Panel_3.Visible := False;

  Form1.Label1.Caption      := sP1;

  Form1.Label3.Top := Form1.Label1.Top + Form1.Label1.Height + 35;

  Form1.Label3.Caption      := sP2;

  {Sandro Silva 2023-06-01 inicio
  if (Form1.iReduzida = 1) and
    ((sP1 = 'MONITORE AS CONTAS'+chr(10)+'A RECEBER') or
    (sP1 = 'ORGANIZE AS CONTAS'+chr(10)+'A PAGAR') or
    (sP1 = 'CONTROLE O '+chr(10)+'CAIXA') or
    (sP1 = 'FIQUE DE OLHO NOS '+chr(10)+'BANCOS'))
  then
  }
  if (Form1.ValidaRecursos.PermiteRecursoParaProduto = False) and
    ((sModulo = 'RECEBER') or
     (sModulo = 'PAGAR') or
     (sModulo = 'CAIXA') or
     (sModulo = 'BANCOS') or
     (sModulo = 'INDICADORES') or
     (sModulo = 'SERVIÇO')
    )
  then
  begin
    Form1.pnInformacaoObterSmallComFuncoes.Left     := Form1.Label3.Left;
    Form1.pnInformacaoObterSmallComFuncoes.Top      := Form1.Panel_3.Height - Form1.pnInformacaoObterSmallComFuncoes.Height - 70;
    Form1.Label3.Caption := Form1.Label3.Caption + chr(10) + chr(10) + 'Este módulo não está liberado'; // Sandro Silva 2023-06-01 Form1.Label3.Caption := Form1.Label3.Caption + chr(10) + chr(10) + 'Este módulo não está liberado'+chr(10)+'no Small Start';
    Form1.pnInformacaoObterSmallComFuncoes.Visible := True;
  end else
  begin
    Form1.pnInformacaoObterSmallComFuncoes.Visible := False;
  end;

  Form1.Panel_3.Visible := True;

  Result := True;
end;


procedure ListaArq(sCaminho: String; slArq: TStringList);
// var
//  scCursor: TCursor;
//  sAtua: String;

begin
//  GetDir(0,sAtua);
//  scCursor := Screen.Cursor;
  try
    Form1.FileListBox1.Directory := sCaminho;
    slArq.AddStrings(Form1.FileListBox1.Items);
    CHDir(Form1.sAtual);
  except end;
end;


function UploadMobile(sFile: TFileName): boolean;
begin
  if FileExists(pchar(Form1.sAtual+'\'+sFile)) then
  begin
    CopyFile(pchar(Form1.sAtual+'\'+sFile),pChar(Form1.sAtual+'\mobile\upload\'+sFile),false);
    while not FileExists(pChar(Form1.sAtual+'\mobile\upload\'+sFile)) do
    begin
      Sleep(100);
    end;
    DeleteFile(pchar(Form1.sAtual+'\'+sFile));
  end;

  Result := True;
end;

procedure StatusMonitorAberto(sFileMob: String);
begin
  try
    with TStringList.Create do
    begin
      Add('[Monitor]');
      Add('PC-NOME=' + GetComputerNameFunc);
      Add('DATA=' + FormatDateTime('yyyy-mm-dd HH:nn:ss', Now));
      Add('SERIAL=' + Form22.sSerie);
      SaveToFile(sFileMob);
      Free;
    end;
    if FileExists(sFileMob) then UploadMobile(pChar(sFileMob));
  finally
    DeleteFile(pchar(sFileMob));
  end;
end;


function DownloadMobile(sEmitente: String; sExtensao: String; slArquivos: TStringList): String;
var
  tsL : TStringList;
  I : Integer;
  sArquivo : String;
begin
  tSl := tStringList.Create;

  ListaArq(Form1.sAtual+'\mobile\download\'+sExtensao,tsL); // Inocente

  for I := 0 to tsL.Count -1 do
  begin
    sArquivo := Form1.sAtual + '\mobile\download\' + AllTrim(tsL[I]);

    if (pos(LowerCase(Copy(sExtensao,2,4)),LowerCase(sArquivo)) <> 0) then
    begin
      slArquivos.Add(sArquivo);
    end;
  end;

  tSl.Free;
end;


function AtivaTodosOsIndices(pP1: Boolean) : Boolean;
begin
  try
    // Ativa todos os indices
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select i.rdb$index_name,i.rdb$unique_flag,i.rdb$relation_name,s.rdb$field_name from rdb$indices i join rdb$index_segments s on (i.rdb$index_name = s.rdb$index_name) where i.rdb$index_name not like '+QuotedStr('RDB$%')+' ');
    Form1.ibQuery1.Open;

    while not Form1.ibQuery1.Eof do
    begin
      try
        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('alter index '+Form1.ibQuery1.Fields[0].asString+' active');
        Form1.ibQuery2.ExecSQL;
      except
      end;

      Form1.ibQuery1.Next;
    end;
    Form1.ibQuery1.Close;
  except
  end;

  Result := True;
end;

function Estatistica(sp1: String; sp2 : String): String;
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.Sql.Clear;
  Form1.ibQuery1.Sql.Add('select count(REGISTRO) from '+sP1+' ');
  Form1.ibQuery1.Open;
  //
  Result := '<tr><td vAlign=Top align=Left><font face="Verdana, Microsoft Sans Serif, Helvetica" size="1" color="#000000">'+sP2+
            '</td><td vAlign=Top align=Right><font face="Verdana, Microsoft Sans Serif, Helvetica" size="1" color="#000000">'+Form1.ibQuery1.FieldByname('COUNT').AsString+'</td></tr>';
  Form1.ibQuery1.Close;
end;


function SmallScript(sP1: String):Boolean;
var
  f: TextFile;
  sLinha : String;
begin
  if FileExists(sP1) then
  begin
    AssignFile(f,sP1);
    Reset(f);

    while not eof(f) Do
    begin
      ReadLn(f,sLinha);

      // Executa o comando
      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add(sLinha);
        Form1.ibQuery1.Open;
      except
      end;
    end;
  end;

  Result := True;
end;


function PegaImpostosDoXML(sP1: String):Boolean;
var
  I : Integer;
  NodePrim, NodePai, NodeSec, NodeTmp: IXMLNode; // Node é um nó do XML

  sDesc    ,
  sIPI
  : String;
begin
  Form1.ibQuery2.close;
  Form1.ibQuery2.Sql.Clear;
  Form1.ibQuery2.SQL.Add('select * from VENDAS where NUMERONF='+QuotedStr(sP1)); // Somente a nota atual
  Form1.ibQuery2.Open;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  while not Form1.ibQuery2.Eof do
  begin
    // Metodo XML
    Mensagem22('Lendo XML da NFe '+Form1.ibQuery2.FieldByname('NUMERONF').AsString);

    if (Pos('<nfeProc',Form1.ibQuery2.FieldByname('NFEXML').AsString) <> 0) and (Form7.ibDataSet15EMITIDA.AsString <> 'X') then
    begin
      try
        Form1.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
        Form1.XMLDocument1.XML.Text  := pchar(Form1.ibQuery2.FieldByname('NFEXML').AsString);
        Form1.XMLDocument1.Active    := True;

        NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
        NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
        NodeSec  := NodePai.ChildNodes.FindNode('det');

        NodeSec.ChildNodes.First;

        repeat
          NodeTmp  := NodeSec.ChildNodes['prod']; // tag <prod> dentro de <det>
          NodeTmp.ChildNodes.First;

          if Alltrim(NodeTmp.ChildNodes['xProd'].Text) <> '' then
          begin
            try
              sDesc := NodeTmp.ChildNodes['xProd'].Text;
            except
            end;

            sIPI    := '0';

            if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI')) then
            begin
               try sIPI  := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['vIPI'].Text);  except end;
            end;

            try
              Form1.ibQuery1.Close;
              Form1.ibQuery1.Sql.Clear;
              Form1.ibQuery1.Sql.Add('update ITENS001 set vIPI='+QuotedStr(sIPI)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
              Form1.ibQuery1.Open;
            except
            end;
          end;

          NodeSec := NodeSec.NextSibling; // Next
        until NodeSec = nil;
      except
        // Passa tudo com valor Zerado
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.Sql.Clear;
          Form1.ibQuery1.Sql.Add('update ITENS001 set vICMS=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
          Form1.ibQuery1.Open;
        except end;

        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.Sql.Clear;
          Form1.ibQuery1.Sql.Add('update ITENS001 set vBC=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
          Form1.ibQuery1.Open;
        except end;

        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.Sql.Clear;
          Form1.ibQuery1.Sql.Add('update ITENS001 set vBCST=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
          Form1.ibQuery1.Open;
        except end;

        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.Sql.Clear;
          Form1.ibQuery1.Sql.Add('update ITENS001 set vICMSST=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
          Form1.ibQuery1.Open;
        except end;

        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.Sql.Clear;
          Form1.ibQuery1.Sql.Add('update ITENS001 set vIPI=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
          Form1.ibQuery1.Open;
        except end;
      end;
    end else
    begin
      // Passa tudo com valor Zerado
      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add('update ITENS001 set vICMS=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
        Form1.ibQuery1.Open;
      except end;

      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add('update ITENS001 set vBC=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
        Form1.ibQuery1.Open;
      except end;

      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add('update ITENS001 set vBCST=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
        Form1.ibQuery1.Open;
      except end;

      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add('update ITENS001 set vICMSST=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
        Form1.ibQuery1.Open;
      except end;

      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.Sql.Clear;
        Form1.ibQuery1.Sql.Add('update ITENS001 set vIPI=''0'' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString));
        Form1.ibQuery1.Open;
      except end;
    end;

    Form1.ibQuery2.Next;
  end;

  Screen.Cursor := crDefault; // Cursor de Aguardo
  Result := True;
end;


function TForm1.MontaTela(sP1 : boolean):Boolean;
var
  iTop, iFix, iFixL, iLeft : Integer;
begin
  Form1.Align    := alClient;

  Panel_3.Left   := 0; // (Screen.Width - (1000)) div 2;
  Panel_3.Top    := Panel_0.Top + Form1.Panel_0.Height;
  Panel_3.Height := Form1.Height - Form1.Panel_3.Top;
  Panel_3.Width  := Screen.Width;
  Panel4.Width   := Screen.Width;
  Panel4.Top     := Panel_3.Top;
  Panel4.Height  := Screen.Height;

  Form7.Top    := Form1.Panel_3.Top + 30;
  {Dailon Parisotto (f-7757) 2023-01-03 Inicio}
  {$IFDEF VER150}
  Form7.Left   := 0;
  Form7.Width  := Form1.Width -6;
  Form7.Height := Form1.Height - Form7.Top -6;
  {$ELSE}
  Form7.Left   := Form1.Left;
  Form7.Width  := Form1.Width;
  Form7.Height := (Form1.Height - 9) - Form7.Top;
  {$ENDIF}
  {Dailon Parisotto (f-7757) 2023-01-03 Fim}

  iTop := 6;
  iFix := 0;
  iFixL := 70;
  iLeft := 5+5;

  // ------ //
  // Vendas //
  // ------ //
  if imgVendas.Visible = True then
  begin
    imgVendas.Top     := iTop;
    iTop             := iTop + iFix;
    imgVendas.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgVendas,Label201);

    {Mauricio Parizotto 2023-07-13 Inicio}
    Image_bola_vendas.Top     := imgVendas.Top -6+1-1;
    Image_bola_vendas.Left    := imgVendas.Left + imgVendas.Width - 20;

    Label_Bola_vendas.Caption := AllTrim(IntToStr(1));
    Label_Bola_vendas.Width   := Image_Bola_NFe.Width;
    Label_Bola_vendas.Left    := Image_bola_vendas.Left;
    Label_Bola_vendas.Top     := Image_bola_vendas.Top +1-1;

    //Avisos
    Image_bola_vendas.Picture := ImageBola.Picture;

    if Form7.GetMensagemCertificado <> '' then
    begin
      Image_bola_vendas.visible  := True;
      Label_Bola_vendas.Visible  := True;
    end else
    begin
      Image_bola_vendas.visible  := False;
      Label_Bola_vendas.Visible  := False;
    end;
    {Mauricio Parizotto 2023-07-13 Fim}
  end;

  // ------- //
  // Compras //
  // ------- //
  if imgCompras.Visible = True then
  begin
    imgCompras.Top     := iTop;
    iTop             := iTop + iFix;
    imgCompras.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgCompras,Form1.Label201C);

    // Avisos no NFe
    if Form1.iAvisosNFeCompra >= 100 then
    begin
      Image_Bola_NFe.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosNFeCompra >= 10 then
      begin
        Image_Bola_NFe.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_NFe.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_NFe.Top     := imgCompras.Top -6+1-1;
    Image_Bola_NFe.Left    := imgCompras.Left + imgCompras.Width - 20;

    Label_Bola_NFe.Caption := AllTrim(IntToStr(iAvisosNFeCompra));
    Label_Bola_NFe.Width   := Image_Bola_NFe.Width;
    Label_Bola_NFe.Left    := Image_Bola_NFe.Left;
    Label_Bola_NFe.Top     := Image_Bola_NFe.Top +1-1;

    if iAvisosNFeCompra <> 0 then
    begin
      Image_Bola_NFe.visible  := True;
      Label_Bola_NFe.Visible  := True;
    end else
    begin
      Image_Bola_NFe.visible  := False;
      Label_Bola_NFe.Visible  := False;
    end;
  end;

  // --------- //
  // Serviços  //
  // --------- //
  if imgServicos.Visible = True then
  begin
    imgServicos.Top     := iTop;
    iTop             := iTop + iFix;
    imgServicos.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgServicos,Label201S);
  end;

  // ----------------- //
  // Ordem de serviços //
  // ----------------- //
  if imgOrdemServico.Visible = True then
  begin
    imgOrdemServico.Top     := iTop;
    iTop              := iTop + iFix;
    imgOrdemServico.Left    := iLeft;
    iLeft             := iLeft + iFixL;
    MostraLabels(imgOrdemServico,Label201_);

    // Avisos no OS
    if iAvisosOS >= 100 then
    begin
      Image_Bola_OS.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosOS >= 10 then
      begin
        Image_Bola_OS.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_OS.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_OS.Top     := imgOrdemServico.Top -6+1-1;
    Image_Bola_OS.Left    := imgOrdemServico.Left + imgOrdemServico.Width - 20;
    Label_Bola_OS.Caption := AllTrim(IntToStr(Form1.iAvisosOS));

    Label_Bola_OS.Width   := Image_Bola_OS.Width;
    Label_Bola_OS.Left    := Image_Bola_OS.Left;
    Label_Bola_OS.Top     := Image_Bola_OS.Top +1-1;

    if iAvisosOS <> 0 then
    begin
      Image_Bola_OS.visible  := True;
      Label_Bola_OS.Visible  := True;
    end else
    begin
      Image_Bola_OS.visible  := False;
      Label_Bola_OS.Visible  := False;
    end;
  end;

  // -------- //
  // Estoque  //
  // -------- //
  if imgEstoque.Visible = True then
  begin
    imgEstoque.Top     := iTop;
    iTop             := iTop + iFix;
    imgEstoque.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgEstoque,Label202);

    // Avisos no Estoque
    if Form1.iAvisosEstoque >= 100 then
    begin
      Image_Bola_Estoque.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosEstoque >= 10 then
      begin
        Image_Bola_Estoque.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Estoque.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_Estoque.Top     := imgEstoque.Top -6+1-1;
    Image_Bola_Estoque.Left    := imgEstoque.Left + imgVendas.Width - 20;
    Label_Bola_Estoque.Caption := AllTrim(IntToStr(iAvisosEstoque));

    Label_Bola_Estoque.Width   := Image_Bola_Estoque.Width;
    Label_Bola_Estoque.Left    := Image_Bola_Estoque.Left;
    Label_Bola_Estoque.Top     := Image_Bola_Estoque.Top +1-1;

    if iAvisosEstoque <> 0 then
    begin
      Image_Bola_Estoque.visible  := True;
      Label_Bola_Estoque.Visible  := True;
    end else
    begin
      Image_Bola_Estoque.visible  := False;
      Label_Bola_Estoque.Visible  := False;
    end;
  end;

  // ----------------------- //
  // Clientes e Fornecedores //
  // ----------------------- //
  if imgCliFor.Visible = True then
  begin
    imgCliFor.Top     := iTop;
    iTop             := iTop + iFix;
    imgCliFor.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgCliFor,Form1.Label203);

    // Avisos no CliFor
    if Form1.iAvisosCliFor >= 100 then
    begin
      Image_Bola_CliFor.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if iAvisosCliFor >= 10 then
      begin
        Image_Bola_CliFor.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_CliFor.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_CliFor.Top     := imgCliFor.Top -6+1-1;
    Image_Bola_CliFor.Left    := imgCliFor.Left + imgCliFor.Width - 20;
    Label_Bola_CliFor.Caption := AllTrim(IntToStr(iAvisosCliFor));

    Label_Bola_CliFor.Width   := Image_Bola_CliFor.Width;
    Label_Bola_CliFor.Left    := Image_Bola_CliFor.Left;
    Label_Bola_CliFor.Top     := Image_Bola_CliFor.Top +1-1;

    if iAvisosCliFor <> 0 then
    begin
      Image_Bola_CliFor.visible  := True;
      Label_Bola_CliFor.Visible  := True;
    end else
    begin
      Image_Bola_CliFor.visible  := False;
      Label_Bola_CliFor.Visible  := False;
    end;
  end;

  // -------- //
  // Receber  //
  // -------- //
  if imgContaReceber.Visible = True then
  begin
    imgContaReceber.Top     := iTop;
    iTop                   := iTop + iFix;
    imgContaReceber.Left    := iLeft;
    iLeft                  := iLeft + iFixL;
    MostraLabels(imgContaReceber,Label204);

    // Avisos no Receber
    if iAvisosReceber >= 100 then
    begin
      Image_Bola_Receber.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosReceber >= 10 then
      begin
        Image_Bola_Receber.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Receber.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_Receber.Top     := imgContaReceber.Top -6+1-1;
    Image_Bola_Receber.Left    := imgContaReceber.Left + imgContaReceber.Width - 20;
    Label_Bola_Receber.Caption := AllTrim(IntToStr(iAvisosReceber));

    Label_Bola_Receber.Width   := Image_Bola_Receber.Width;
    Label_Bola_Receber.Top     := Image_Bola_Receber.Top +1-1;
    Label_Bola_Receber.Left    := Image_Bola_Receber.Left;

    if iAvisosReceber <> 0 then
    begin
      Image_Bola_Receber.visible  := True;
      Label_Bola_Receber.Visible  := True;
    end else
    begin
      Image_Bola_Receber.visible  := False;
      Label_Bola_Receber.Visible  := False;
    end;
  end;

  // -------- //
  // Pagar    //
  // -------- //
  if imgContaPagar.Visible = True then
  begin
    imgContaPagar.Top     := iTop;
    iTop             := iTop + iFix;
    imgContaPagar.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgContaPagar,Label210);

    // Avisos no Pagar
    if iAvisosPagar >= 100 then
    begin
      Image_Bola_Pagar.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosPagar >= 10 then
      begin
        Image_Bola_Pagar.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Pagar.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_Pagar.Top     := imgContaPagar.Top -6+1-1;
    Image_Bola_Pagar.Left    := imgContaPagar.Left + imgContaPagar.Width - 20;
    Label_Bola_Pagar.Caption := AllTrim(IntToStr(iAvisosPagar));

    Label_Bola_Pagar.Width   := Image_Bola_Pagar.Width;
    Label_Bola_Pagar.Left    := Image_Bola_Pagar.Left;
    Label_Bola_Pagar.Top     := Image_Bola_Pagar.Top +1-1;

    if iAvisosPagar <> 0 then
    begin
      Image_Bola_Pagar.visible  := True;
      Label_Bola_Pagar.Visible  := True;
    end else
    begin
      Image_Bola_Pagar.visible  := False;
      Label_Bola_Pagar.Visible  := False;
    end;
  end;

  // ----- //
  // Caixa //
  // ----- //
  if imgCaixa.Visible = True then
  begin
    imgCaixa.Top     := iTop;
    iTop             := iTop + iFix;
    imgCaixa.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgCaixa,Label205);

    // Avisos no Caixa
    if Form1.iAvisosCaixa >= 100 then
    begin
      Image_Bola_Caixa.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosCaixa >= 10 then
      begin
        Image_Bola_Caixa.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Caixa.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_caixa.Top     := imgCaixa.Top -6+1-1;
    Image_Bola_Caixa.Left    := imgCaixa.Left + imgCaixa.Width - 20;
    Label_Bola_Caixa.Caption := AllTrim(IntToStr(Form1.iAvisosCaixa));

    Label_Bola_Caixa.Width   := Image_Bola_Caixa.Width;
    Label_Bola_Caixa.Left    := Image_Bola_Caixa.Left;
    Label_Bola_Caixa.Top     := Image_Bola_Caixa.Top +1-1;

    if iAvisosCaixa <> 0 then
    begin
      Image_Bola_Caixa.visible  := True;
      Label_Bola_Caixa.Visible  := True;
    end else
    begin
      Image_Bola_Caixa.visible  := False;
      Label_Bola_Caixa.Visible  := False;
    end;
  end;

  // ------- //
  // Bancos  //
  // ------- //
  if imgBancos.Visible = True then
  begin
    imgBancos.Top     := iTop;
    iTop             := iTop + iFix;
    imgBancos.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgBancos,Label206);

    // Avisos no banco
    if iAvisosBanco >= 100 then
    begin
      Image_Bola_Banco.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosBanco >= 10 then
      begin
        Image_Bola_Banco.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Banco.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_banco.Top     := imgBancos.Top -6+1-1;
    Image_Bola_banco.Left    := imgBancos.Left + imgBancos.Width - 20;
    Label_Bola_banco.Caption := AllTrim(IntToStr(iAvisosbanco));

    Label_Bola_Banco.Width   := Image_Bola_Banco.Width;
    Label_Bola_banco.Left    := Image_Bola_banco.Left;
    Label_Bola_banco.Top     := Image_Bola_banco.Top +1-1;

    if iAvisosbanco <> 0 then
    begin
      Image_Bola_banco.visible  := True;
      Label_Bola_banco.Visible  := True;
    end else
    begin
      Image_Bola_banco.visible  := False;
      Label_Bola_banco.Visible  := False;
    end;
  end;

  // ---------------- //
  // Indicadores     //
  // ---------------- //
  if imgIndicadores.Visible = True then
  begin
    imgIndicadores.Top     := iTop;
    iTop             := iTop + iFix;
    imgIndicadores.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgIndicadores,Label200);

    // Avisos no Indicadores
    if iAvisosIndicadores >= 100 then
    begin
      Image_Bola_Indicadores.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosIndicadores >= 10 then
      begin
        Image_Bola_Indicadores.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Indicadores.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_Indicadores.Top     := imgIndicadores.Top -6+1-1;
    Image_Bola_Indicadores.Left    := imgIndicadores.Left + imgIndicadores.Width - 20;
    Label_Bola_Indicadores.Caption := AllTrim(IntToStr(iAvisosIndicadores));

    Label_Bola_Indicadores.Width   := Image_Bola_Indicadores.Width;
    Label_Bola_Indicadores.Left    := Image_Bola_Indicadores.Left;
    Label_Bola_Indicadores.Top     := Image_Bola_Indicadores.Top +1-1;

    if iAvisosIndicadores <> 0 then
    begin
      Image_Bola_Indicadores.visible  := True;
      Label_Bola_Indicadores.Visible  := True;
    end else
    begin
      Image_Bola_Indicadores.visible  := False;
      Label_Bola_Indicadores.Visible  := False;
    end;
  end;

  // CONFIG
  if imgConfiguracoes.Visible = True then
  begin
    imgConfiguracoes.Top     := iTop;
    iTop             := iTop  + iFix;
    imgConfiguracoes.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(imgConfiguracoes,Label207);

    // Avisos no Config
    if Form1.iAvisosConfig >= 100 then
    begin
      Image_Bola_Config.Picture := ImageBola3.Picture;
    end else
    begin
      if iAvisosConfig >= 10 then
      begin
        Image_Bola_Config.Picture := ImageBola2.Picture;
      end else
      begin
        Image_Bola_Config.Picture := ImageBola.Picture;
      end;
    end;

    Image_Bola_Config.Top     := imgConfiguracoes.Top -6+1-1;
    Image_Bola_Config.Left    := imgConfiguracoes.Left + imgConfiguracoes.Width - 20;
    Label_Bola_Config.Caption := AllTrim(IntToStr(iAvisosConfig));

    Label_Bola_Config.Width   := Image_Bola_Config.Width;
    Label_Bola_Config.Left    := Image_Bola_Config.Left;
    Label_Bola_Config.Top     := Image_Bola_Config.Top +1-1;

    if iAvisosConfig <> 0 then
    begin
      Image_Bola_Config.visible  := True;
      Label_Bola_Config.Visible  := True;
    end else
    begin
      Image_Bola_Config.visible  := False;
      Label_Bola_Config.Visible  := False;
    end;
  end;

  // --------- //
  // Cópias   //
  // ------- //
  if imgBackup.Visible = True then
  begin
    imgBackup.Top     := iTop;
    imgBackup.Left    := iLeft;
    MostraLabels(imgBackup,Label208);
  end else
  begin
//    Label_Perigo.Visible       := False;
  end;

  Result := True;
end;

function ExecutaSql(sP1 : boolean):Boolean;
var
  f: TextFile;
  sDelete, sUpdate,
  sArquivo, sCaminho, sSelectSql : String;
  I : Integer;
  sLinha, sCampos, sValores : String;
  CampoPK : string; // Mauricio Parizotto 2023-08-07
begin
  try
    with Form1 do
    begin
      if copy(UpperCase(Edit200.Text),1,10)= 'CONNECT TO' then
      begin
        Edit1.Text := Edit200.Text;
        try
          ibDataSet200.Close;
          dbGrid200.Visible := False;
          Edit200.Visible   := False;

          Commitatudo(True); // SQL - Commando
          AbreArquivos(False);

          MontaTela(True);
        except end;

        Form1.SQLCommandoexterno1Click(SQLCommandoexterno1);
        Abort;
      end;

      if copy(UpperCase(Edit200.Text),1,11)= 'IMPORT FROM' then
      begin
        Edit200.Text := Alltrim(StrTran(UpperCase(Edit200.Text),'IMPORT FROM',''));
        sCaminho     := Copy(Edit200.Text+' ',1,Pos(' ',Edit200.Text+' ')-1);

        if FileExists(sCaminho) then
        begin
          try
            if (Form1.iReduzida<>2) then
            begin
              Form29.Panel1.Visible  := True;
              Aviso2('Atualizando tabela de municípios'+chr(10)+'e unidades de medida');

              Screen.Cursor := crHourGlass; // Cursor de Aguardo
              AssignFile(f,sCAminho);
              Reset(f);

              I := 0;

              while not eof(f) Do
              begin
                ReadLn(f,sLinha);

                // Executa o comando
                try
                  ibDataSet200.Close;
                  ibDataSet200.SelectSQL.Clear;
                  ibDataSet200.SelectSQL.Add(sLinha);
                  ibDataSet200.Open;
                except end;

                I := I + 1;
                Form29.Gauge1.Progress := 100 * I div 5650;
                Form29.Gauge1.Repaint;
              end;

              CloseFile(f);

              Form29.Close;
            end;

            Screen.Cursor        := crDefault;
          except
            //ShowMessage('Erro de sintaxe no comando IMPORT FROM.'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Erro de sintaxe no comando IMPORT FROM.',msgAtencao);
          end;

          if FileExists(Form1.sAtual+'\executa.sql') then
            DeleteFile(pChar(Form1.sAtual+'\executa.sql'));
        end;

        Screen.Cursor := crDefault;
        Edit200.Text := '';
        if Edit200.CanFocus then Edit200.SetFocus;

        Commitatudo(True); // SQL - Commando
        AbreArquivos(False);

        Abort;
      end;

      if copy(UpperCase(Edit200.Text),1,11)= 'EXPORT FROM' then
      begin
        Edit200.Text := Alltrim(StrTran(UpperCase(Edit200.Text),'EXPORT FROM',''));
        sArquivo     := Copy(Edit200.Text,1,Pos(' ',Edit200.Text)-1);
        sCaminho     := Alltrim(StrTran(UpperCase(Edit200.Text),sArquivo+' ',''));

        if Pos('TO ',sCaminho) <> 0 then
        begin
          sCaminho := StrTran(sCaminho,'TO ','');

          if FileExists(sCaminho+'.SQL') then
            DeleteFile(pChar(sCaminho+'.SQL'));

          try
            Screen.Cursor := crHourGlass; // Cursor de Aguardo

            ibDataSet200.Close;
            ibDataSet200.SelectSQL.Clear;
            ibDataSet200.SelectSQL.Add('select * from '+sArquivo);
            ibDataSet200.Open;

            AssignFile(f,sCAminho+'.SQL');
            Rewrite(f);
            Writeln(f,'delete from '+sArquivo);

            while not ibDataSet200.Eof do
            begin
              sCampos  := '';
              sValores := '';

              for I := 0 to dbGrid200.FieldCount -1 do
              begin
                if (Alltrim(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString) <> '')
                and (Alltrim(dbGrid200.Fields[I].DisplayName) <> 'FOTO') then
                begin
                  if sCampos  <> '' then sCampos  := sCampos+',';
                  if sVAlores <> '' then sValores := sValores+',';
                  //
                  sCampos  := sCampos + dbGrid200.Fields[I].DisplayName;
                  // Integer
                  if (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='SmallInt')
                  or (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='Integer')
                  or (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='LargeInt')
                  or (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='Boolean') then
                  begin
                    sValores := sValores + QuotedStr(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString);
                  end else
                  begin
                    // Float
                    if (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='Float')
                    or (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='Currency') then
                    begin
                      sValores := sValores + QuotedStr(StrTran(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString,',','.'));
                    end else
                    begin
                      // Date
                      if (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='Date')
                      or (FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]='DateTime') then
                      begin
                        sValores := sValores + QuotedStr(
                        Copy(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString,7,4)
                        +'/'+Copy(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString,4,2)
                        +'/'+Copy(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString,1,2));
                      end else
                      begin
                        // String e demais
                        begin
                          sValores := sValores + QuotedStr(IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).AsString);
                        end;
                      end;
                    end;
                  end;
                end;
              end;

              Writeln(f,'insert into '+sArquivo+' ('+sCampos+') '+'values ('+StrTran(StrTran(sValores,Chr(10),''),Chr(13),'')+')');

              ibDataSet200.Next;
            end;

            Writeln(f,'select * from '+sArquivo);

            CloseFile(F);
          except
            //ShowMessage(sArquivo+' não é uma tabéla válida.'); Mauricio Parizotto 2023-10-25
            MensagemSistema(sArquivo+' não é uma tabéla válida.',msgAtencao);
          end;

          Screen.Cursor := crDefault;
        end else
        begin
          //ShowMessage('Erro de sintaxe no comando EXPORT FROM.'); Mauricio Parizotto 2023-10-25
          MensagemSistema(sArquivo+' não é uma tabéla válida.',msgAtencao);
        end;

        Edit200.Text := '';
        Abort;
      end;

      try
        Screen.Cursor := crHourGlass; // Cursor de Aguardo

        if Pos('SELECT',UpperCase(ibDataSet200.SelectSQL.Text))<>0 then
          sSelectSql := ibDataSet200.SelectSQL.Text;

        ibDataSet200.Close;
        ibDataSet200.SelectSQL.Clear;
        ibDataSet200.DeleteSQL.Clear;
        ibDataSet200.ModifySQL.Clear;
        ibDataSet200.SelectSQL.Add(Edit200.Text);
        ibDataSet200.Open;

        if (Pos('SELECT',UpperCase(ibDataSet200.SelectSQL.Text)) = 0) and (Pos('SELECT',UpperCase(sSelectSql)) <> 0) then
        begin
          ibDataSet200.Close;
          ibDataSet200.SelectSQL.Clear;
          ibDataSet200.SelectSQL.Add(sSelectSql);
          ibDataSet200.Open;
        end;

        if (Pos('SELECT',UpperCase(ibDataSet200.SelectSQL.Text)) <> 0)
        and (Pos('SUM(',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        and (Pos('COUNT(',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        and (Pos('GROUP BY',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        and (Pos('$',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        and (Pos(',',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        and (Pos('.',UpperCase(ibDataSet200.SelectSQL.Text)) = 0)
        then
        begin
          try
            sArquivo := Copy(ibDataSet200.SelectSQL.Text+Replicate(' ',2000),pos('from',LowerCase(ibDataSet200.SelectSQL.Text))+5,2000);
            sArquivo := strTran(Copy(sArquivo,1,Pos(' ',sArquivo)),',','');
            sArquivo := UpperCase(trim(sArquivo));

            {Mauricio Parizotto 2023-08-07 inicio}
            CampoPK := 'REGISTRO';

            try
              if ibDataSet200.FindField('REGISTRO') = nil then
                CampoPK := GetCampoPKTabela(ibDataSet200.Database,sArquivo);
            except
            end;

            //sDelete := 'delete from '+sArquivo+' where REGISTRO=:OLD_REGISTRO';
            sDelete := 'delete from '+sArquivo+' where '+CampoPK+'=:OLD_'+CampoPK;
            sUpdate := 'update '+sArquivo+' set ';

            for I := 0 to ibDataSet200.FieldCount -1 do
            begin
              sUpdate := sUpdate + ibDataSet200.Fields[I].FieldName + '=:'+ibDataSet200.Fields[I].FieldName;
              if I = ibDataSet200.FieldCount -1 then sUpdate := sUpdate + ' ' else sUpdate := sUpdate + ', ';
            end;

            //sUpdate := sUpdate + ' where REGISTRO=:OLD_REGISTRO';
            sUpdate := sUpdate + ' where '+CampoPK+'=:OLD_'+CampoPK;

            {Mauricio Parizotto 2023-08-07 fim}

            ibDataSet200.Close;
            ibDataSet200.DeleteSQL.Add(sDelete);
            ibDataSet200.ModifySql.Add(sUpdate);
            ibDataSet200.Open;
          except
          end;
        end;

        Edit200.Text := '';
      except
        ibDataSet200.Close;
        ibDataSet200.DeleteSQL.Clear;
        ibDataSet200.SelectSQL.Clear;
        ibDataSet200.SelectSQL.Add(sSelectSql);
        ibDataSet200.Open;

        //ShowMessage('Erro no comando SQL: '+Edit200.Text); Mauricio Parizotto 2023-10-25
        MensagemSistema('Erro no comando SQL: '+Edit200.Text,msgErro);
      end;
    end;
  except end;

  Result := True;
end;


function ExecutaSql2(sP1 : boolean):Boolean;
var
  sSelectSql : String;
begin
  with Form1 do
  begin
    if copy(UpperCase(Form1.Edit1.Text),1,10)= 'CONNECT TO' then
    begin
      Edit1.Text := Alltrim(StrTran(UpperCase(Edit1.Text),'CONNECT TO',''));

      try
        Form1.IBDatabase1.Close;
        Form1.IBDatabase1.Params.Clear;
        Form1.IbDatabase1.DatabaseName := Edit1.Text;
        Form1.IBDatabase1.Params.Add('USER_NAME=SYSDBA');
        Form1.IBDatabase1.Params.Add('PASSWORD=masterkey');
        Form1.IbDatabase1.Open;
        Form1.IBTransaction1.Active := True;
        //ShowMessage('Conectado'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Conectado');
      except
        //ShowMessage('Não foi possível conectar'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Não foi possível conectar',msgAtencao);
      end;

      Screen.Cursor := crDefault;
      Edit1.Text := '';
      Edit1.SetFocus;
      Abort;
    end;

    try
      Screen.Cursor := crHourGlass; // Cursor de Aguardo

      if Pos('SELECT',UpperCase(ibDataSet1.SelectSQL.Text))<>0 then sSelectSql := ibDataSet1.SelectSQL.Text;

      ibDataSet1.Close;
      ibDataSet1.SelectSQL.Clear;
      ibDataSet1.DeleteSQL.Clear;
      ibDataSet1.ModifySQL.Clear;
      ibDataSet1.SelectSQL.Add(Edit1.Text);
      ibDataSet1.Open;

      if (Pos('SELECT',UpperCase(ibDataSet1.SelectSQL.Text)) = 0) and (Pos('SELECT',UpperCase(sSelectSql)) <> 0) then
      begin
        ibDataSet1.Close;
        ibDataSet1.SelectSQL.Clear;
        ibDataSet1.SelectSQL.Add(sSelectSql);
        ibDataSet1.Open;
      end;

      Edit1.Text := '';
    except
      ibDataSet1.Close;
      ibDataSet1.DeleteSQL.Clear;
      ibDataSet1.SelectSQL.Clear;
      ibDataSet1.SelectSQL.Add(sSelectSql);
      ibDataSet1.Open;

      //ShowMessage('Erro no comando SQL: '+Edit1.Text); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro no comando SQL: '+Edit1.Text,msgErro);
    end;
  end;
  Result := True;
end;

function Legal(sP1 : Boolean):Boolean;
var
  I : Integer;
begin
  // LEGAL
  Result := True;

  try
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_LEGAL,0) from rdb$database');
    Form1.ibDataset200.Open;

    if Form1.ibDataSet200.FieldByname('GEN_ID').AsString <> '0' then
    begin
      if Date >= StrToDate(Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,7,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,5,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,1,4))+31 then
      begin
        try
          Form1.ibDataset200.Close;
          Form1.ibDataset200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
          Form1.ibDataset200.Open;
        except
        end;

        // Pega os dados do Emitente
        try
          Form7.ibDataSet13.Active := True;
          // Sandro Silva 2022-10-31 if Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0 then
          if (Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0)
            or (Form1.ValidaEmitenteMunicipio = False) then
          begin
            try
              Form17 := TForm17.Create(nil);
              Form17.ShowModal;
            finally
              FreeAndNil(Form17);
            end;

            if Form1.CanFocus then
              Form1.SetFocus;
          end;
        except
        end;

        Form1.RegistrodoPrograma(False);

        for I := 1 to 5 do
        begin
          if not Regularize then
            Sleep(400);
        end;

        if not Regularize then
        begin
          if Application.MessageBox(pChar('Não foi possível liberar o sistema para uso neste computador'+chr(10)+
                                      'com o número de série '+ Form1.sSerial +' para: '+chr(10)+chr(10)+
                                       AllTrim(Form7.ibDataSet13NOME.AsString)+chr(10)+chr(10)+
                                       AllTrim(Form7.ibDataSet13CGC.AsString)+chr(10)+chr(10)+
                                       'Código: 2022 '+chr(10)+chr(10)+
                                       'Adquirir uma licença de uso atualizada?'),
                                       'Atenção', MB_ICONQUESTION + MB_YESNO) = IDYES then
            ShellExecute(Application.Handle, nil, PChar('http://www.smallsoft.com.br/loja/atualiza-via-small?serial=' + Form1.sSerial + '&cnpj=' + LimpaNumero(form7.ibDataSet13.FieldByName('CGC').AsString)), nil, nil, SW_SHOWMAXIMIZED);

          Result := False;
        end;
      end else
      begin
        Result := True;
      end;
    end else
    begin
      Result := True;
    end;

    Form1.ibDataset200.Close;
  except
    //Result := True; Mauricio Parizotto 2024-05-24
    on e:exception do
    begin
      Result := False;
      MensagemSistema('Erro ao liberar. '+e.Message,msgErro);
    end;
  end;
end;

function AtualizaPromocao(sP1 : Boolean):Boolean;
var
  qryUpdate: TIBQuery;
begin
  Form22.Repaint;
  Mensagem22('Atualizando promoção...');
  qryUpdate := CriaIBQuery(Form7.IBTransaction1);
  try
    try
      // Volta o preco fora da promoção
      qryUpdate.Close;
      qryUpdate.SQL.Clear;
      qryUpdate.SQL.Add('update ESTOQUE set PRECO=OFFPROMO where (CURRENT_DATE not between PROMOINI and PROMOFIM) and (PRECO=ONPROMO) ');
      qryUpdate.Open;
      {Sandro Silva 2024-04-22 inicio}
      if qryUpdate.RowsAffected > 0 then
        Result := True;
      {Sandro Silva 2024-04-22 fim}
    except end;

    try
      // Guarda o preço anterior (normal) fora da promoção
      qryUpdate.Close;
      qryUpdate.SQL.Clear;
      qryUpdate.SQL.Add('update ESTOQUE set OFFPROMO=PRECO where (CURRENT_DATE not between PROMOINI and PROMOFIM) and (OFFPROMO<>PRECO)');
      qryUpdate.Open;
      {Sandro Silva 2024-04-22 inicio}
      if qryUpdate.RowsAffected > 0 then
        Result := True;
      {Sandro Silva 2024-04-22 fim}
    except end;

    try
      // Altera para o preço promocional
      qryUpdate.Close;
      qryUpdate.SQL.Clear;
      qryUpdate.SQL.Add('update ESTOQUE set PRECO=ONPROMO where (CURRENT_DATE between PROMOINI and PROMOFIM) and (PRECO<>ONPROMO) ');
      qryUpdate.Open;
      {Sandro Silva 2024-04-22 inicio}
      if qryUpdate.RowsAffected > 0 then
        Result := True;
      {Sandro Silva 2024-04-22 fim}
    except end;
  finally
    FreeAndNil(qryUpdate);
    Mensagem22('Aguarde...');
  end;

  // Sandro Silva 2024-04-22 Result := True;
end;

function AjustaRegistro(sP0, sP1: String):Boolean;
var
  sReg, sMax: String;
begin
  Mensagem22('Aguarde ajustando arquivos '+sP0+'...');

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('create generator G_'+sP1+' ');
    Form1.ibDataset200.Open;
  except
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('create generator G_HASH_'+sP1+' ');
    Form1.ibDataset200.Open;
  except
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('set generator G_'+sP1+' to 0');
    Form1.ibDataset200.Open;
  except
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('update '+sP1+' set REGISTRO= substring(10000000000 +  Cast(gen_id(G_'+sP1+',1) as decimal) from 2 for 10) order by REGISTRO');
    Form1.ibDataset200.Open;

    try
      Form1.ibDataSet200.Close;
      Form1.ibDataSet200.SelectSQL.Clear;
      Form1.ibDataSet200.SelectSQL.Add('select gen_id(G_'+sP1+',0) as TOTALREG from rdb$database');
      Form1.ibDataSet200.Open;

      sReg := Form1.ibDataSet200.FieldByname('TOTALREG').AsString;
    except
    end;

    try
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_HASH_'+sP1+' to '+sReg+' ');
      Form1.ibDataset200.Open;
    except
    end;

    try
      if Form7.IBTransaction1.Active then
        Form7.IBTransaction1.Commit;
    except
      //ShowMessage('Erro ao criar REGISTRO em: '+sP1);Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro ao criar REGISTRO em: '+sP1,msgErro);
    end;

    // chaves primárias
    try
      try
        Form1.ibDataset200.Close;
        Form1.ibDataset200.SelectSql.Clear;
        Form1.ibDataset200.SelectSql.Add('update rdb$relation_fields set rdb$null_flag = 1 where (rdb$field_name = '+QuotedStr('REGISTRO')+') and (rdb$relation_name = '+QuotedStr(sP1)+')');
        Form1.ibDataset200.Open;
      except
      end;

      try
        Form1.ibDataset200.Close;
        Form1.ibDataset200.SelectSql.Clear;
        Form1.ibDataset200.SelectSql.Add('alter table '+sP1+' add constraint PK_'+sP1+' primary key (REGISTRO)');
        Form1.ibDataset200.Open;
      except
      end;

      try
        if Form7.IBTransaction1.Active then
          Form7.IBTransaction1.Commit;
      except
        //ShowMessage('Erro ao criar Chave Primaria em: '+sP1); Mauricio Parizotto 2023-10-25
        MensagemSistema('Erro ao criar Chave Primaria em: '+sP1,msgErro);
      end;
    except
    end;
  except
    // Está sendo usado volta o GENERATOR
    try
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSQL.Clear;
      Form1.ibDataset200.SelectSQL.Add('select max(REGISTRO) from '+Sp1+' ');
      Form1.ibDataset200.Open;
      sMax := Form1.IBDataSet200.fieldByname('MAX').AsString;
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_'+sP1+' to '+sMax);
      Form1.ibDataset200.Open;
    except
    end;
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('create index '+sp1+'REGISTRO on '+sp1+'(REGISTRO)');
    Form1.ibDataset200.Open;
  except
  end;

  Result := True;
end;

function FechaTudo(bP1 : Boolean):Boolean;
begin
  Result := False;

  if Form5.Visible then Form5.Close;
//  if Form5.Visible then Form10.Close;

  if Form1.bFechaTudo then
  begin
    if Form24.Visible then Form24.Close;
    if (Form12.Visible) then
    begin
      if (Form12.PodeFecharTela) then
        Form12.Close
      else
      begin
        if not Form12.Showing then
          Form12.Show;
        Exit;
      end;
    end;
    if Form30.Visible then Form30.Close;
    if Form48.Visible then Form48.Close;
  end;

  if Form7.Visible  then Form7.Close;
  if Form19.Visible then Form19.Close;

  if Form7.sModulo <> 'INDICADORES' then Form7.sModulo := '';

  Result := True;
end;


function Calendario(dP1: tDateTime; iP2, ip3 : Integer):Boolean;
var
  J, I, OldBkMode : Integer;
  dContador : tDateTime;
begin
  /////////////////////////
  // C A L E N D A R I O //
  /////////////////////////
  OldBkMode := SetBkMode(Form1.Canvas.Handle, TRANSPARENT);
  dContador  := StrToDate('01/'+StrZero(Month(dP1),2,0)+'/'+StrZero(Year(dP1),4,0));
  //
  Form1.Canvas.Font.Name  := 'verdana';
//  Form1.Canvas.Font.Style := [fsBold];
  Form1.Canvas.Font.Style := [];
  Form1.Canvas.Font.Size  := 6;
  //
  if Form1.sContrasteCor <> 'BRANCO' then Form1.Canvas.Font.Color := clSilver else Form1.Canvas.Font.Color := clWhite;
  Form1.Canvas.TextOut((iP2) + 30,iP3,AllTrim(MesExtenso(Month(dP1))));
  //
  J := 0;
  for I := 1 to DiasPorMes(Year(Date),Month(Date)) do
  begin
//    if (DayOfWeek(dContador) = 7) or (DayOfWeek(dContador) = 1) or (Date = dContador) then Form1.Canvas.Font.Style := [fsBold] else Form1.Canvas.Font.Style := [];
    if (DayOfWeek(dContador) = 7) or (DayOfWeek(dContador) = 1) or (Date = dContador) then Form1.Canvas.Font.Color := clRed else  Form1.Canvas.Font.Color := clBlack;
    Form1.Canvas.TextOut((iP2) + (30 * DayOfWeek(dContador)),iP3+12,Copy(DiaDaSemana(dContador),1,3));                 // Cabeçalho
    if Form1.sContrasteCor <> 'BRANCO' then Form1.Canvas.Font.Color := clSilver else Form1.Canvas.Font.Color := clWhite;
    Form1.Canvas.TextOut((iP2) + (30 * DayOfWeek(dContador)),iP3+24+J, Right('   '+IntToStr(Day(dContador)),4)  );     // Dias
    if DayOfWeek(dContador) = 7 then J := J + 12;
    dContador := dContador + 1;
  end;
  SetBkMode(Form1.Canvas.Handle, OldBkMode);
  /////////////////////////
  // C A L E N D A R I O //
  /////////////////////////
  Result := True;
end;

function LeLabels(sP1: Boolean):Boolean;
var
  SmallIni : tIniFile;
  I : Integer;
begin
  //
  SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
  //
  Form7.ibDataSet2IDENTIFICADOR1.DisplayLabel := SmallIni.ReadString('CLIENTES','Label19','Identificador 1');
  Form7.ibDataSet2IDENTIFICADOR2.DisplayLabel := SmallIni.ReadString('CLIENTES','Label20','Identificador 2');
  Form7.ibDataSet2IDENTIFICADOR3.DisplayLabel := SmallIni.ReadString('CLIENTES','Label21','Identificador 3');
  Form7.ibDataSet2IDENTIFICADOR4.DisplayLabel := SmallIni.ReadString('CLIENTES','Label22','Identificador 4');
  Form7.ibDataSet2IDENTIFICADOR5.DisplayLabel := SmallIni.ReadString('CLIENTES','Label23','Identificador 5');
  //
  Form7.ibDataSet15IDENTIFICADOR1.DisplayLabel := SmallIni.ReadString('VENDAS','Label28','Identificador 1');
  //
  Form7.ibDataSet4LIVRE1.DisplayLabel := SmallIni.ReadString('ESTOQUE','Label18','Identificador 1');
  Form7.ibDataSet4LIVRE2.DisplayLabel := SmallIni.ReadString('ESTOQUE','Label19','Identificador 2');
  Form7.ibDataSet4LIVRE3.DisplayLabel := SmallIni.ReadString('ESTOQUE','Label20','Identificador 3');
  Form7.ibDataSet4LIVRE4.DisplayLabel := SmallIni.ReadString('ESTOQUE','Label21','Identificador 4');
  //
  Form30.Label14.Caption := SmallIni.ReadString('OS','Label14','Descrição do objeto');
  Form30.Label15.Caption := SmallIni.ReadString('OS','Label15','Identificador 1');
  Form30.Label16.Caption := SmallIni.ReadString('OS','Label16','Identificador 2');
  Form30.Label17.Caption := SmallIni.ReadString('OS','Label17','Identificador 3');
  Form30.Label18.Caption := SmallIni.ReadString('OS','Label18','Identificador 4');
  Form30.Label30.Caption := SmallIni.ReadString('OS','Label30','Garantia');
  Form30.Label19.Caption := SmallIni.ReadString('OS','Label19','Problema reclamado');
  Form30.Label10.Caption := SmallIni.ReadString('OS','Label10','Frete');
  Form30.Label34.Caption := SmallIni.ReadString('OS','Label34','Técnico');

  Form12.Label28.Caption := SmallIni.ReadString('VENDAS','Label28','Identificador 1');
  //
  Form7.ibDataSet3TOTAL_FRET.DisplayLabel := Form30.Label10.Caption;
  //
  Form7.ibDataSet3DESCRICAO.DisplayLabel := SmallIni.ReadString('OS','Label14','Descrição do objeto');
  Form7.ibDataSet3IDENTIFI1.DisplayLabel := SmallIni.ReadString('OS','Label15','Identificador 1');
  Form7.ibDataSet3IDENTIFI2.DisplayLabel := SmallIni.ReadString('OS','Label16','Identificador 2');
  Form7.ibDataSet3IDENTIFI3.DisplayLabel := SmallIni.ReadString('OS','Label17','Identificador 3');
  Form7.ibDataSet3IDENTIFI4.DisplayLabel := SmallIni.ReadString('OS','Label18','Identificador 4');
  Form7.ibDataSet3GARANTIA.DisplayLabel  := SmallIni.ReadString('OS','Label30','Garantia');
  Form7.ibDataSet3PROBLEMA.DisplayLabel  := SmallIni.ReadString('OS','Label19','Problema reclamado');
  //
  with Form7.ibDataSet2 do
  begin
    //
    for I := 1 to FieldCount do
    begin
      if Pos('$',Fields[I-1].DisplayLabel) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
        Fields[I-1].Alignment    := taRightJustify;
      end;
      if Pos('data',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
      end;
//      if Pos('e-mail',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
//      begin
//        Fields[I-1].Displaywidth := 21;
//      end;
      if (Pos('telefone',LowerCase(Fields[I-1].DisplayLabel)) <> 0)
      or (Pos('celular',LowerCase(Fields[I-1].DisplayLabel)) <> 0)
      or (Pos('fax',LowerCase(Fields[I-1].DisplayLabel)) <> 0) then
      begin
        Fields[I-1].Displaywidth := 18;
      end;
    end;
  end;
  //
  with Form7.ibDataSet3 do
  begin
    //
    for I := 1 to FieldCount do
    begin
      if Pos('$',Fields[I-1].DisplayLabel) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
        Fields[I-1].Alignment    := taRightJustify;
      end;
      if Pos('data',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
      end;
//      if Pos('e-mail',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
//      begin
//        Fields[I-1].Displaywidth := 21;
//      end;
    end;
  end;
  //
  with Form7.ibDataSet4 do
  begin
    //
    for I := 1 to FieldCount do
    begin
      if Pos('$',Fields[I-1].DisplayLabel) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
        Fields[I-1].Alignment    := taRightJustify;
      end;
      if Pos('data',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
      begin
        Fields[I-1].Displaywidth := 10;
      end;
//      if Pos('e-mail',LowerCase(Fields[I-1].DisplayLabel)) <> 0 then
//      begin
//        Fields[I-1].Displaywidth := 21;
//      end;
    end;
  end;
  //
  SmallIni.Free;
  //
  Result := True;
  //
end;


function MostraLabels(tSp1: tImage; tSp2: TLabel): Boolean;
var
  Mais1Ini : tIniFile;
begin
  //
  with Form1 do
  begin
    //
    tSp2.OnClick     := tSp1.OnClick;
    //
    tSp2.Top         := 0; // tSp1.Top + tSp1.Height -20;
    tSp2.Alignment   := taCenter;
    tSP2.Left        := tSp1.Left;
    tSp2.Width       := tSp1.Width;
    //
    // Não mostrar as legendas
    {Mauricio Parizotto 2024-04-23
    if not Form19.CheckBox8.Checked then
    begin
      tSp2.Caption := Replicate(' ',100)+AllTrim(tSp2.Caption);
    end else}
    begin
      tSp2.Caption := AllTrim(tSp2.Caption);
    end;

    tSp2.visible     := True;
    tsP2.Repaint;
  end;

  if tSp2.Caption = 'Backup' then
  begin
    if Form1.imgBackup.Visible then
    begin
      try
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        if (StrtoDate(Mais1Ini.ReadString('Backup','Último backup','26/09/1967')) + 1) < Date then
        begin
          if Mais1Ini.ReadString('Backup','Último backup','?') = '?' then
          begin
            Form1.imgBackup.Hint := 'Banco de dados em risco,'+chr(10)+'sem backup seguro';
          end else
          begin
            Form1.imgBackup.Hint := 'Banco de dados em risco, último'+chr(10)+'backup em '+Alltrim(Mais1Ini.ReadString('Backup','Último backup','?'));
          end;
        end else
        begin
          Form1.imgBackup.Hint := 'Último backup em '+Mais1Ini.ReadString('Backup','Último backup','?');
        end;
      except
        Form1.imgBackup.Hint := 'Banco de dados em risco,'+chr(10)+'sem backup seguro';
      end;
    end;
  end;

  Result := True;
end;

procedure TForm1.NaoDescontarIssQuandoRetido1Click(Sender: TObject);  // Sandro Silva 2024-04-24
var
  ConfSistema: TArquivosDAT;
  IBTransaction: TIBTransaction;
begin
  try
    IBTransaction := CriaIBTransaction(Form7.ibDataSet13.Transaction.DefaultDatabase);
    ConfSistema := TArquivosDAT.Create(Usuario, IBTransaction);
    try
      ConfSistema.BD.NFSE.NaoDescontarIssQuandoRetido := IfThen(NaoDescontarIssQuandoRetido1.Checked, 'Não', 'Sim');
      IBTransaction.Commit;
      bNaoDescontarIssQuandoRetido := ConfSistema.BD.NFSE.NaoDescontarIssQuandoRetido = 'Sim';// NaoDescontarIssQuandoRetido1.Checked;
      NaoDescontarIssQuandoRetido1.Checked := bNaoDescontarIssQuandoRetido;
    except
      on E: Exception do
      begin
        IBTransaction.Rollback;
        MensagemSistema('Não foi possível configurar', msgAtencao);
      end;
    end;
  finally
    FreeAndNil(ConfSistema);
    FreeAndNil(IBTransaction);
  end;
  {Sandro Silva 2024-04-23 inicio}
  // Precisa para atualizar a conexão
  Commitatudo(True);
  AbreArquivos(False);
  {Sandro Silva 2024-04-23 fim}
end;

procedure Tform1.NovoFormExit(Sender:TObject);
begin
  Screen.ActiveForm.Visible := False;
end;

procedure TForm1.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  vBody : string;
  vRecurso : string;
  documentoAtivo: variant;
begin
  try
    documentoAtivo := WebBrowser1.Document;
    vBody := documentoAtivo.Body.OuterHTML;

    vBody := Trim(StringReplace(StringReplace(vBody,'<body>','',[rfReplaceAll]) ,'</body>','',[rfReplaceAll]));
    vBody := Trim(StringReplace(StringReplace(vBody,'<BODY>','',[rfReplaceAll]) ,'</BODY>','',[rfReplaceAll]));

	  //Mauricio Parizotto 2023-05-29
    if AnsiContainsText(vBody,'Serial') then
    begin
      vRecurso := SmallEncrypt(CHAVE_CIFRAR_NOVA,vBody);
      ExecutaComando('Update emitente set RECURSO ='+QuotedStr(vRecurso));
      //ExecutaComando('Commit;'); Mauricio Parizotto 2024-04-16 tentativa resolver invalid transaction handle
      AgendaCommit(true);
	  end;

    //Mauricio Parizotto 2024-05-24 f 159
    Regularize;
  except
  end;
end;

procedure TForm1.WMUser (var msg: TMessage);
begin
  Application.Restore;
end;

procedure TForm1.imgCaixaClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  if ValidaRecursoExibeMensagemIndisponivel then
  begin

    if not (Form1.iReduzida = 1) then
    begin
      try
        if not FechaTudo(bFechaTudo) then
          Exit;
        Form7.sModulo := 'CAIXA';
        Form1.Label201MouseLeave(Sender);
        Form7.sTitulo := 'Livro caixa';
        Form7.sRPS := 'N';
        Form7.Show;
      except end;
    end;
  end;
end;

procedure TForm1.Sobreoprograma1Click(Sender: TObject);
begin
  //
  Form22.Close;
  //
  try
    {
    if Form7.IBDatabaseInfo1.UserNames.Count = 1
      then Form22.sAtivos :=  AllTrim(InttoStr(Form7.IBDatabaseInfo1.UserNames.Count))+' usuário ativo'
        else Form22.sAtivos :=  AllTrim(InttoStr(Form7.IBDatabaseInfo1.UserNames.Count))+' usuários ativos';
    }
    Form22.sAtivos :=  AllTrim(InttoStr(Form7.IBDatabaseInfo1.UserNames.Count)) + IfThen(Form7.IBDatabaseInfo1.UserNames.Count = 1, ' usuário ativo', ' usuários ativos');
  except
    Form22.sAtivos := '? usuários ativos';
  end;
  //
  with Form22.RichEdit1 do
  begin
    Lines.Clear;
    SelAttributes.Name := 'Microsoft Sans Serif';
    SelAttributes.Style := [fsBold];
    SelAttributes.Color := clWhite;

    SelAttributes.Height := 30;
    Lines.Add(Form22.sTitulo);

    SelStart := Length(Text)-1;
    SelAttributes.Style := [];
    SelAttributes.Height := 16;
    SelAttributes.Color := clWhite; // 2024-01-05

    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_LEGAL,0) from rdb$database');
    Form1.ibDataset200.Open;

    if Form1.ibDataSet200.FieldByname('GEN_ID').AsString <> '0' then
    begin
      if Date >= StrToDate(Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,7,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,5,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,1,4))+31 then
      begin
        SelText := chr(10) + chr(10) +
                   Form22.sBuild + chr(10) +
                   'Usuário: ' + Usuario + chr(10) +
                   Form22.sLicenca + chr(10) +
                   Form22.sSerie + chr(10) +
                   Form22.sIniciandoEm  + chr(10) +
                   Form22.sUrlDoGdb + chr(10) +
                   Form22.sAtivos  + chr(10) +
                   Chr(10) + 'Sistema bloqueado';
      end else
      begin
        SelText := chr(10) + chr(10) +
                   Form22.sBuild + chr(10) +
                   'Usuário: ' + Usuario + chr(10) +
                   Form22.sLicenca + chr(10) +
                   Form22.sSerie + chr(10) +
                   Form22.sIniciandoEm  + chr(10) +
                   Form22.sUrlDoGdb + chr(10) +
                   Form22.sAtivos  + chr(10) +
                   Chr(10) + 'Uso indevido sistema liberado por + ' +
                   IntToStr(DaysBetween(StrToDate(Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,7,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,5,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,1,4))+31,Date))
                   + ' dias';
      end;
    end else
    begin
      SelText := chr(10) + chr(10) +
                 Form22.sBuild + chr(10) +
                 'Usuário: ' + Usuario + chr(10) +
                 Form22.sLicenca + chr(10) +
                 Form22.sSerie + chr(10) +
                 Form22.sIniciandoEm  + chr(10) +
                 Form22.sUrlDoGdb + chr(10) +
                 Form22.sAtivos  + chr(10) +
                 'Seu sistema está devidamente licenciado para mais ' + AllTrim(FloatToStr(Form1.fDias)) + ' dias';

    end;
  end;

  Form22.RichEdit1.Left  := Form22.Image1.Left -100-20;
  Form22.RichEdit1.Top   := Form22.Image1.Top + Form22.Image1.Height + 20;
  Form22.RichEdit1.Width := 700;

  Form22.Label6.Visible    := False;
  Form22.Image1.Visible    := True;
  Form22.RichEdit1.Visible := True;
  Form22.Button1.Visible   := True;

  Mensagem22('Copyright© Zucchetti® 2005 - 2023'); Form22.Button1.Visible := True;
  Form22.ShowModal;

  Form22.Label6.Visible    := True;
  Form22.Image1.Visible    := True;
  Form22.RichEdit1.Visible := False;
end;

procedure Tform1.EscolheOBanco(Sender:TObject);
var
  Mais1Ini : TIniFile;
begin
  Form16.Button3Click(Sender);
  with Sender as TMenuItem do sEscolhido := Caption;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais1Ini.WriteString('BANCOS','BANCO',sEscolhido);
  Mais1Ini.Free;
  Form7.sTitulo := sEscolhido;
  Form7.sRPS := 'N';

  Form7.Close;
  Form7.Show;
end;

procedure Tform1.EscolheOBloqueto(Sender:TObject);
begin
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  with Sender as TMenuItem do
  //  sEscolhido := Caption;
    sBancoBoleto := Caption;

  //sEscolhido := 'Boleto de cobrança do '+sEscolhido;
  sEscolhido := 'Boleto de cobrança do '+sBancoBoleto;
  Form25.ShowModal;
end;

procedure Tform1.EscolheCNAB400(Sender:TObject);
begin
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  with Sender as TMenuItem do
  //  sEscolhido := Caption;
    sBancoBoleto := Caption;

  //sEscolhido := 'Boleto de cobrança do '+Form1.sEscolhido;
  sEscolhido := 'Boleto de cobrança do '+sBancoBoleto;
  Form25.Show;

  //Form25.btnCNAB400.Click; Mauricio Parizotto 2023-10-03 uGeraCNAB400 // Sandro Silva 2022-12-23 Form25.Button9.Click;
  GeraCNAB400;
  Form25.Close;

  if Form1.sArquivoRemessa <> '' then
  begin
    {
    ShowMessage('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 400 para o BANCO '+
    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
    Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+
    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10));
    Mauricio Parizotto 2023-10-25}
    MensagemSistema('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 400 para o BANCO '+
                    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
                    //Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+ Mauricio Parizotto 2023-11-07
                    Chr(10)+'Este arquivo deverá ser transmitido conforme orientação específica do banco.'+
                    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10)
                    ,msgAtencao);
  end;
end;

procedure Tform1.EscolheCNAB240(Sender:TObject);
begin
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  with Sender as TMenuItem do
  //  sEscolhido := Caption;
      sBancoBoleto := Caption;

  //sEscolhido := 'Boleto de cobrança do '+Form1.sEscolhido;
  sEscolhido := 'Boleto de cobrança do '+sBancoBoleto;
  Form25.Show;

  //Form25.btnCNAB240.Click; Mauricio Parizotto 2023-10-03 // Sandro Silva 2022-12-23 Form25.Button10.Click;
  GeraCNAB240;
  Form25.Close;

  if Form1.sArquivoRemessa <> '' then
  begin
    {
    ShowMessage('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 240 para o BANCO '+
    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
    Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+
    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10));
    Mauricio Parizotto 2023-10-25}
    MensagemSistema('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 240 para o BANCO '+
                    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
                    //Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+ Mauricio Parizotto 2023-11-07
                    Chr(10)+'Este arquivo deverá ser transmitido conforme orientação específica do banco.'+
                    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10)
                    ,msgAtencao);
  end;
end;

procedure Tform1.ExecutaOPlugin(Sender:TObject);
begin
  with Sender as TMenuItem do
    ShellExecute( 0, 'Open',pChar('Plug-in\'+Caption+'.exe'),'', '', SW_SHOW);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sPastaDoPaf : String;
begin
  Form1.sConsultaNfse   := 'NAO';
  Timer2.Interval       := 10000;
  Form1.Image4.Width    := 1024;
  Form1.Image4.Height   := 768;
  //
  {Dailon Parisotto (f-18201) 2024-05-08 Inicio

  if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) then

  }
  if TestarUFMovimentaEstoqueFinanceiroSemFaturar(Form7.ibDataSet13ESTADO.AsString) then
  {Dailon Parisotto (f-18201) 2024-05-08 Fim}
  begin
    ConfiguraodaNFemformulrionumerado1.Visible := True;
  end else
  begin
    ConfiguraodaNFemformulrionumerado1.Visible := False;
  end;

  try
    if Form7.ibDataSet39.Active then
    begin
      Form1.Repaint;
      if FileExists(Form1.sAtual+'\autoexec.sql') then
      begin
        RenameFile('autoexec.sql','executa.sql');
        Form1.Edit200.Text := 'import from EXECUTA.SQL';
        ExecutaSql(True);
      end;
    end;
  except
  end;

  CHDir(Form1.sAtual);

  {$IFDEF VER150}
  if (DecimalSeparator <> ',') or (DateSeparator <> '/') then
  {$ELSE}
  if (FormatSettings.DecimalSeparator <> ',') or (FormatSettings.DateSeparator <> '/') then
  {$ENDIF}
  begin
     MensagemSistema('As propriedades das configurações regionais do seu sistema não estão'     + Chr(10) +
                     'de acordo com o padrão utilizado no Brasil.'                              + Chr(10) +
                     Chr(10) +
                     'Estas configurações regionais alteram o modo como números, moedas, datas' + Chr(10) +
                     'e horas são exibidos.'                                                    + Chr(10) +
                     Chr(10) +
                     'Altere estas configurações para:' + Chr(10) +
                     Chr(10) +
                     Chr(10) +
                     '                  Português (Brasileiro)' + Chr(10) +
                     Chr(10)+
                     'Verifique também o separador decimal, que deve ser "," e ' + chr(10)+
                     'o separador de data que deve ser "/".'
                      ,msgAtencao);


    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
  end;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  if AllTrim(Mais1Ini.ReadString('Html','Html1','1')) = '1' then
    Form1.bHtml1 := True
  else
    Form1.bHtml1 := False;
  if AllTrim(Mais1Ini.ReadString('Html','Html1','1')) = '3' then
  begin
    Form1.bHtml1 := True;
    Form1.bPDF   := True;
  end else
  begin
    Form1.bPDF   := False;
  end;

  AutoMarketplace1.Checked := False;
  if ValidaRecursos.PermiteRecursoParaProduto then
  begin

    if Mais1Ini.ReadString('GERAL','MARKETPLACE ATIVO','Não') = 'Sim' then
    begin
      AutoMarketplace1.Checked := True;

      if not ConsultaProcesso('mkp.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mkp.exe','', '', SW_SHOW); // Form1Ativate
      end;
    end else
    begin
      AutoMarketplace1.Checked := False;
    end;
  end
  else
  begin
    Marketplace1.Enabled := False;
  end;

  AutoSmallMobile1.Checked := False;
  if ValidaRecursos.PermiteRecursoParaProduto then
  begin
    if Mais1Ini.ReadString('GERAL','MOBILE ATIVO','Não') = 'Sim' then
    begin
      AutoSmallMobile1.Checked := True;

      if not ConsultaProcesso('mobile.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mobile.exe', pChar(Form7.ibDataSet13CGC.AsString) , '', SW_SHOW); // Form1Ativate
      end;
    end else
    begin
      AutoSmallMobile1.Checked := False;
    end;
  end
  else
  begin
    Smallmobile1.Enabled := False;
  end;

  Form19.Edit7.Color := StrToInt('$'+AllTrim(Mais1Ini.ReadString('Html','Cor','EBEBEB')));
  Form19.Edit8.Color := StrToInt('$'+AllTrim(Mais1Ini.ReadString('Html','Cor','EBEBEB')));
  //
  Form1.sHtmlCor := Copy(Mais1Ini.ReadString('Html','Cor','EBEBEB'),5,2)+
                    Copy(Mais1Ini.ReadString('Html','Cor','EBEBEB'),3,2)+
                    Copy(Mais1Ini.ReadString('Html','Cor','EBEBEB'),1,2);
  //
  //
  if (Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Commerce + Ordem de Serviço') or (Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Mei + Ordem de Serviço')  then
  begin
    Cadastrodetcnicos1.Visible           := False;
  end else
  begin
    Cadastrodetcnicos1.Visible           := True;
  end;
  //
  Mais.LeLabels(True);

  // Ativa o verificador de rede
  bChaveDoTempo := True;

  // Limpar movimento
  Form2.Top  := Form7.Top;
  Form2.Left := (Form1.Width div 2) - (Form2.Width div 2);

  if FileExists(Form1.sAtual+'\smallzip_.exe') then
  begin
    while FileExists(Form1.sAtual+'\smallzip.exe') do DeleteFile(pChar(Form1.sAtual+'\smallzip.exe'));
    RenameFile(pChar(Form1.sAtual+'\smallzip_.exe'),pChar(Form1.sAtual+'\smallzip.exe'));
  end;

  if FileExists(Form1.sAtual+'\smallcon_.exe') then
  begin
    while FileExists(Form1.sAtual+'\smallcon.exe') do DeleteFile(pChar(Form1.sAtual+'\smallcon.exe'));
    RenameFile(pChar(Form1.sAtual+'\smallcon_.exe'),pChar(Form1.sAtual+'\smallcon.exe'));
  end;

  {Dailon (f-7308) 2023-08-28 inicio}
  if FileExists(Form1.sAtual+'\mei_.exe') then
    DeleteFile(pChar(Form1.sAtual+'\mei_.exe'));

  if FileExists(Form1.sAtual+'\mei.exe') then
    DeleteFile(pChar(Form1.sAtual+'\mei.exe'));
  {Dailon (f-7308) 2023-08-28 fim}

  {Dailon Parisotto (f-164) 2024-02-26 Inicio}
  if FileExists(Form1.sAtual+'\saas_.exe') then
    DeleteFile(pChar(Form1.sAtual+'\saas_.exe'));
  {Dailon Parisotto (f-164) 2024-02-26 Fim}

  //Mauricio Parizotto 2023-12-27
  if (FileExists(Form1.sAtual+'\backup_.exe')) and (FileExists(Form1.sAtual+'\backup.exe')) then
  begin
    RenameFile(pChar(Form1.sAtual+'\backup.exe'),pChar(Form1.sAtual+'\backup_o.exe'));
    RenameFile(pChar(Form1.sAtual+'\backup_.exe'),pChar(Form1.sAtual+'\backup.exe'));
  end;

  {Sandro Silva 2024-05-02 inicio}
  // Artifício para possíbilitar atualizar o servidorsat.exe via arquivos de atualização
  // Dentro do arquivo de atualização deve existir o servidorsat_exe
  if (FileExists(Form1.sAtual+'\servidorsat_.exe')) and (FileExists(Form1.sAtual+'\servidorsat.exe')) then
  begin
    RenameFile(pChar(Form1.sAtual+'\servidorsat.exe'),pChar(Form1.sAtual+'\servidorsat_o.exe'));// Renomeia o servidorsat.exe antigo para servidorsat_o.exe
    RenameFile(pChar(Form1.sAtual+'\servidorsat_.exe'),pChar(Form1.sAtual+'\servidorsat.exe')); // Renomeia o novo servidorsat_.exe para servidorsat.exe
  end;
  {Sandro Silva 2024-05-02 fim}

  if (sModeloPAF <> '65') and (sModeloPAF <> '01') and (sModeloPAF <> '59') and (sModeloPAF <> '99') then
  begin
    //
    sPastaDoPaf := 'paf2023';
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then
      sPastaDoPaf := 'paf2023';

    if not FileExists(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\bematech2\bemafi32.ini')) then
      sPastaDoPaf := 'paf2023'; // Sandro Silva 2022-12-28 sPastaDoPaf := 'paf2021';
    //
    if FileExists(Form1.sAtual+'\'+sPastaDoPaf+'\paf.txt') then
    begin
      try
        begin
          if AllTrim(sModeloPAF) = '02' then
          begin
            if (allTrim(sNomePAF) = 'Bematech MP4200 TH FI II') or (allTrim(sNomePAF) = 'Bematech MP4200 TH FI') then
            begin
              CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\bematech2\bemafi32.ini'),          pChar(Form1.sAtual+'\bemafi32.ini'),true);
            end else
            begin
              CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\bematech1\bemafi32.ini'),          pChar(Form1.sAtual+'\bemafi32.ini'),true);
            end;
          end;

          if (sModeloPAF = '17') or (sModeloPAF = '03') then
          begin
            if sNomePAF = AllTrim('Daruma FS800i') then
            begin
              CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\daruma2\darumaframework.xml'),          pChar(Form1.sAtual+'\darumaframework.xml'),true);
            end else
            begin
              CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\daruma1\darumaframework.xml'),          pChar(Form1.sAtual+'\darumaframework.xml'),true);
            end;
          end;
        end;

        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\APF_DLL2.DLL'),          pChar(Form1.sAtual+'\APF_DLL2.DLL'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\BemaFI32.dll'),          pChar(Form1.sAtual+'\BemaFI32.dll'),false);
        //CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\blocox.exe'),            pChar(Form1.sAtual+'\blocox.exe'),false);
        // Sandro Silva 2022-12-02 Unochapeco CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\blocox.exe'),            pChar(Form1.sAtual+'\blocox.exe'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\CONSULTA.exe'),          pChar(Form1.sAtual+'\CONSULTA.exe'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\CONVECF.dll'),           pChar(Form1.sAtual+'\CONVECF.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\daruma1'),               pChar(Form1.sAtual+'\daruma1'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\daruma2'),               pChar(Form1.sAtual+'\daruma2'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\Daruma32.dll'),          pChar(Form1.sAtual+'\Daruma32.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\DarumaFrameWork.dll'),   pChar(Form1.sAtual+'\DarumaFrameWork.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\DLL1EFC3.DLL'),          pChar(Form1.sAtual+'\DLL1EFC3.DLL'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\dll32phi.dll'),          pChar(Form1.sAtual+'\dll32phi.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\DLLG2.dll'),             pChar(Form1.sAtual+'\DLLG2.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\FRENTE.exe'),            pChar(Form1.sAtual+'\FRENTE.exe'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\general32.dll'),         pChar(Form1.sAtual+'\general32.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\iCash.dll'),             pChar(Form1.sAtual+'\iCash.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\InterfaceEpson.dll'),    pChar(Form1.sAtual+'\InterfaceEpson.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\InterfaceEpson.xml'),    pChar(Form1.sAtual+'\InterfaceEpson.xml'),true);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\msgws.dll'),             pChar(Form1.sAtual+'\msgws.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\nfe.exe'),               pChar(Form1.sAtual+'\nfe.exe'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\pesado.exe'),            pChar(Form1.sAtual+'\pesado.exe'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\SWecf.dll'),             pChar(Form1.sAtual+'\SWecf.dll'),false);
        CopyFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\TRDECF32.dll'),          pChar(Form1.sAtual+'\TRDECF32.dll'),false);

        if not ((FileExists(pChar(Form1.sAtual+'\BlocoX\templates\SC\ped_enviar.xml'))) and (not FileExists(pChar(Form1.sAtual+'\BlocoX\blocox_servidores.xml')))) then
        begin
          ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C xcopy "' + sPastaDoPaf + '\BlocoX" BlocoX/S/Y'), nil, SW_HIDE); // Sandro Silva 2022-12-28 ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C xcopy "PAF2020\BlocoX" BlocoX/S/Y'), nil, SW_HIDE);
        end;

        //ShowMessage('Software PAF-ECF para modelo do ECF '+sNomePAF+' configurado com sucesso.'+chr(10)+'Imprima uma identificação do PAF-ECF e confira o MD5 credenciado no seu estado.');Mauricio Parizotto 2023-10-25
        MensagemSistema('Software PAF-ECF para modelo do ECF '+sNomePAF+' configurado com sucesso.'+chr(10)+'Imprima uma identificação do PAF-ECF e confira o MD5 credenciado no seu estado.');

        DeleteFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\paf.txt'));

        ShellExecute( 0, 'Open','http://www.smallsoft.com.br/md5paf','', '', SW_SHOWMAXIMIZED);
      except
        on E: Exception do
          MensagemSistema('Erro ao instalar os arquivos do PAF-ECF: '+E.Message,msgErro);
      end;
    end;
  end;

  Mais1ini.Free;
  Form1.SetFocus;

  try
    // Sandro Silva 2022-10-31 if Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0 then
    if (Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0)
      or (ValidaEmitenteMunicipio = False) then
    begin
      try
        Form17 := TForm17.Create(nil);
        Form17.ShowModal;
      finally
        FreeAndNil(Form17);
      end;

      if Form1.CanFocus then
        Form1.SetFocus;
    end else
    begin
      //
      if Form7.ibDataSet39.Active then
      begin
        if FileExists(pChar('ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.txt')) then
        begin
          if FileExists(Form1.sAtual+'\ibpt.imp') then DeleteFile(pChar(Form1.sAtual+'\ibpt.imp'));
          if FileExists(Form1.sAtual+'\ibpt.txt') then DeleteFile(pChar(Form1.sAtual+'\ibpt.txt'));
          if FileExists(pChar('ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp')) then DeleteFile(pChar('ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp'));
          sleep(500);
          RenameFile(pChar('ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.txt'),pChar('ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp'));
          Form1.AtualizartabelaIBPT1Click(Sender);
        end;
      end;
    end;
  except
  end;

  if Form1.iREduzida = 99 then
  begin
    try
      Form17 := TForm17.Create(nil);
      Form17.ShowModal;
    finally
      FreeAndNil(Form17);
    end;
  end;

  if (imgServicos.Visible) then
  begin
    // Libera NFSE.EXE
    Form1.ConfiguraesdaNFSe1.Visible := True;
    Form7.GerarNotaFiscaldeServio1.Visible := True;
    Form7.GerarNotaFiscaldeServio2.Visible := True;
  end else
  begin
    Form1.ConfiguraesdaNFSe1.Visible := False;
    Form7.GerarNotaFiscaldeServio1.Visible := False;
    Form7.GerarNotaFiscaldeServio2.Visible := False;
  end;

  if Form1.bMKP then
  begin
    if not AutoMarketplace1.Checked then
    begin
      Form1.AutoMarketplace1Click(Sender);
    end;
  end;
end;

procedure TForm1.ConsultadepreosporCdigodeBarras1Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.Cadastrodetransportadoras1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  //Form7.Close; Mauricio Parizotto 2023-06-27 causa erro invalid transaction handle
  Form7.sModulo := 'TRANSPORT';
  Form7.sTitulo := 'Cadastro de transportadoras';
  Form7.sRPS := 'N';
  Form7.Show;
end;

procedure TForm1.Opes1Click(Sender: TObject);
begin
  Form7.Close;
  Form19.ShowModal;
end;

procedure TForm1.Planodecontas1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form7.sModuloAnterior := Form7.sModulo;
  Form7.sModulo := 'CONTAS';
  Form7.sTitulo := 'Plano de contas';
  Form7.sRPS := 'N';

  Form7.Show;

  Form7.sModuloAnterior := Form7.sModulo; //Mauricio Parizotto 2024-01-22

  Form38.Panel5.Visible := True;
  Form38.btnCancelar.Visible := False;
  Form38.ShowModal; // Ok
  Form38.Panel5.Visible := False;
  Form38.btnCancelar.Visible := True;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  begin
    Form7.ibDataSet12DIA.ReadOnly := False;
    Form7.ibDataSet12MES.ReadOnly := False;
    Form7.ibDataSet12ANO.ReadOnly := False;
    Form7.ibDataSet12SALDO.ReadOnly := False;

    Form7.ibDataSet12.Close;
    Form7.ibDataSet12.SelectSQL.Clear;
    Form7.ibDataSet12.SelectSQL.Add('select * from CONTAS order by upper(NOME)');
    Form7.ibDataSet12.Open;
    Form7.ibDataSet12.First;

    Form7.ibDataSet12.DisableControls;

    while not Form7.ibDataSet12.EOF do
    begin
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12DIA.Asfloat   := 0;
      Form7.ibDataSet12MES.Asfloat   := 0;
      Form7.ibDataSet12ANO.Asfloat   := 0;
      Form7.ibDataSet12SALDO.Asfloat := 0;
      Form7.ibDataSet12.Post;
      Form7.ibDataSet12.Next;
    end;

    // Saldo
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;

    while not Form7.IBDataSet100.Eof do
    begin
      if Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString) <> '' then
      begin
        {Sandro Silva 2024-03-15 inicio
        Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
        }
        Form7.ibDataSet12. First;
        while Form7.ibDataSet12.Eof = False do
        begin
          if Trim(Form7.ibDataSet12NOME.AsString) = Trim(Form7.IBDataSet100.FieldByname('NOME').AsString) then
            Break;
          Form7.ibDataSet12.Next;
        end;
        {Sandro Silva 2024-03-15 final}

        if (Alltrim(Form7.ibDataSet12NOME.AsString) <> Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString)) then
        begin
          Form7.ibDataSet12.Append;
          Form7.ibDataSet12NOME.AsString := Form7.IBDataSet100.FieldByname('NOME').AsString;
          Form7.ibDataSet12.Post;
        end;
        Form7.ibDataSet12.Edit;
        Form7.ibDataSet12SALDO.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
        Form7.ibDataSet12.Post;
      end;

      Form7.IBDataSet100.Next;
    end;

    // ANO
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    // Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' and DATA<='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4)+'/'+Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2)+'/'+Copy(DateTimeToStr(Form38.MonthCalendar1.Date),1,2))+' group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;

    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12ANO.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;

      Form7.IBDataSet100.Next;
    end;

    // MES
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( month from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2))+' and extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;

    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12MES.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;

      Form7.IBDataSet100.Next;
    end;

    // DIA
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( day from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),1,2))+' and extract( month from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2))+' and extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;

    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12DIA.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;

      Form7.IBDataSet100.Next;
    end;
  end;

  Form7.ibDataSet12.EnableControls;

  Screen.Cursor := crDefault;
  Form7.Close;
  Form7.sModulo := 'CONTAS';
  Form7.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  // LEGAL
  if FileExists(Form1.sAtual+'\leia-me.txt') then
  begin
    DeleteFile(pChar(Form1.sAtual+'\leia-me.txt'));
  end;

  //Mauricio Parizotto 2024-05-20
  Regularize;
  VerificaNovaBuild;

  if not FechaTudo(bFechaTudo) then
    Exit;

  if form1.DBGrid200.Visible then
  begin
    ibDataSet200.Close;
    dbGrid200.Visible := False;
    Edit200.Visible   := False;

    Commitatudo(True); // SQL - Commando
    AbreArquivos(False);
    MontaTela(True);

    Abort;
  end;

  begin
    CommitaTudo(True); // Quando fecha o programa

    try
      Mais1ini  := TIniFile.Create('ENERGIA.INI');
      Mais1Ini.WriteString('Outros','Houve queda de energia','Não'); // On close
      Mais1Ini.Free;
    except
    end;

    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.WriteString(AllTrim(Usuario),'Ativo','Não');
      Mais1Ini.WriteString(AllTrim(Usuario),'End',DateToStr(Date)+' '+TimeToStr(Time));
      Mais1Ini.UpdateFile;
      Mais1Ini.Free;
    except
    end;
  end;

  Mais1ini := TIniFile.Create(sAtual+'\smallcom.inf');

  Mais1Ini.WriteString('Nota Fiscal','Especie',ConfEspecie);
  Mais1Ini.WriteString('Nota Fiscal','Marca',ConfMarca);
  Mais1Ini.Free;

  Form7.IBTransaction1.Active := False;
  Form7.IbDatabase1.Close;

  Form1.Hide;

  Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
  Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer

  ValidaRecursos.Free; // Sandro Silva 2023-05-31

  Form7.IBDatabase1.Close;
  IBDatabase1.Close;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  bTemAtuaNFeSetup: Boolean;
begin
  //Mauricio Parizotto 2024-06-03
  timerLegal.Interval := 3600000; // 1h
  timerLegal.Enabled  := True;

  bPrimeiraAberturaDia := False; // Mauricio Parizotto 2024-07-05

  Form1.bMKP    := False;
  Form1.sPasta  := CHAVE_CIFRAR; // Sandro Silva 2022-09-19

  Application.OnMessage := ScrollMouse;

  ValidaRecursos := TValidaRecurso.Create; // Sandro Silva 2023-05-31

  Form22.Image1.Left    := ((Screen.Width - Form22.Image1.Width ) div 2);
  Form22.Image1.Top     := ((Screen.Height - Form22.Image1.Height ) div 2) - 220;

  Form22.Image1.Visible := True;

  Form22.Button1.Left    := (Screen.Width - Form22.Button1.Width ) div 2;
  Form22.Button1.Top     := (Screen.Height - Form22.Button1.Height ) div 2 - 160 + 370;

  Form22.Label6.Top     := Form22.Image1.Top + Form22.Image1.Height + 40;
  Form22.Label6.Width   := Screen.Width;
  Form22.Label6.Left    := 0;

  Form1.WebBrowser1.Left := -2000;

  GetDir(0,sAtual);
  Form1.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  tCrono               := Time;
  bFechaTudo           := True;

  bChaveSelecionaCliente := False;
  bModoScan              := False;
  bModoSVC               := False;
  Form1.bChave16         := True;
  Form1.bFlag16Change    := True;

  try
    if FileExists(Form1.sAtual+'\leia-me.txt') then ShellExecute( 0, 'Open', pChar(Form1.sAtual+'\leia-me.txt'),'', '', SW_SHOW);
    if FileExists(Form1.sAtual+'\danferb.dll') then DeleteFile(pChar(Form1.sAtual+'\danferb.dll'));
  except
  end;

  GetDir(0,sAtual);

  // Atualização de arquivos
  {Sandro Silva 2024-05-06 inicio}
  bTemAtuaNFeSetup := False;
  if FileExists(Form1.sAtual+'\nfe_setup.~~1') then
  begin
    bTemAtuaNFeSetup := True; // Controlar que não execute 2x o nfe_setup.exe devido a build salva no frente.ini diferente do build do NFE_SETUP.EXE
  end;
  {Sandro Silva 2024-05-06 fim}
  InstalaAtualizacao('nfe_setup','1');
  InstalaAtualizacao('nfse_setup','2');
  InstalaAtualizacao('nfce_setup','3');
  InstalaAtualizacao('fundo','4');
  InstalaAtualizacao('pastanfe','5');
  InstalaAtualizacao('pastanfse','6');
  InstalaAtualizacao('pastanfce','7');
  InstalaAtualizacao('pastadllsat','8');
  InstalaAtualizacao('pastaopenssl','2');
  // Sandro Silva 2022-12-28 InstalaAtualizacao('cdf_to','9');
  InstalaAtualizacao('paf2022_','10');
  InstalaAtualizacao('paf2023_','10');// Sandro Silva 2022-12-28

  if FileExists(Form1.sAtual+'\small.saas') then
  begin
    ShellExecute( 0, 'Open',pChar('http://www.smallsaas.com.br'),'', '', SW_SHOWMAXIMIZED);
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
  end;

  {Sandro Silva 2024-06 inicio}
  if bTemAtuaNFeSetup then
  begin
    Sleep(250);
    GravarParametroIni('FRENTE.INI', SECAO_INI_NFE, CHAVE_INI_BUILD_NFE_SETUP_EXE, VersaoBuild(ExtractFilePath(Application.ExeName) + NOME_NFE_SETUP));
  end
  else
  begin
    if LerParametroIni('FRENTE.INI', SECAO_INI_NFE, CHAVE_INI_BUILD_NFE_SETUP_EXE, '') = '' then
      GravarParametroIni('FRENTE.INI', SECAO_INI_NFE, CHAVE_INI_BUILD_NFE_SETUP_EXE, '12.1.76.6495');// 12.1.76.6495 É última versão instalada antes desta validação
  end;
  ValidaBuildNFe_Setup;
  {Sandro Silva 2024-05-06 fim}

  {Mauricio Parizotto 2023-05-31 Inicio}
  //Alterado para não gerar piscação dos icones ao passar o moues
  imgIndicadores.Transparent := False;
  imgVendas.Transparent := False;
  imgOrdemServico.Transparent := False;
  imgEstoque.Transparent := False;
  imgCliFor.Transparent := False;
  imgContaReceber.Transparent := False;
  imgContaPagar.Transparent := False;
  imgCaixa.Transparent := False;
  imgBancos.Transparent := False;
  imgConfiguracoes.Transparent := False;
  imgBackup.Transparent := False;
  imgCompras.Transparent := False;
  imgServicos.Transparent := False;

  Image_Bola_indicadores.Transparent := False;
  Image_Bola_NFe.Transparent := False;
  Image_bola_OS.Transparent := False;
  Image_Bola_Estoque.Transparent := False;
  Image_bola_clifor.Transparent := False;
  Image_bola_receber.Transparent := False;
  Image_bola_pagar.Transparent := False;
  Image_bola_caixa.Transparent := False;
  Image_bola_banco.Transparent := False;
  Image_bola_config.Transparent := False;
  Image_bola_vendas.Transparent := False;

  Image4.Transparent := False;
  {Mauricio Parizotto 2023-05-31 Fim}

  //Mauricio Parizotto 2023-09-22
  CarregaIconesSistema;

  //Mauricio Parizotto 2024-03-19
  VersodolayoutdaNFE1.Visible  := False;
  HorarioDeVerao.Visible       := False;
  Enviardanfeporemail1.Visible := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TSistema.destroy;
end;

procedure TForm1.DadosdoEmitente1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  try
    Form17 := TForm17.Create(nil);
    Form17.ShowModal;
  finally
    FreeAndNil(Form17);
  end;

  ExibeRazaoSocialNoCaptionDoForm; // Sandro Silva 2022-12-15
end;

procedure TForm1.DefinirBuildEXEDAT;
var
  oIni: TIniFile;
begin
  oIni := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  try
    if StrToFloat(LimpaNumero(oIni.ReadString('Geral','Build 2020','2020.0.0.0'))) <> StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:',''))) then
      oIni.WriteString('Geral','Build 2023',StrTran(Form22.sBuild,'Versão e Build:',''));
  finally
    oIni.Free;
  end;
end;

procedure TForm1.Ajustararquivos1Click(Sender: TObject);
var
  sCertificado, sSerieS, sBuild, sLicenca  : String;
  SmallIni, Mais1Ini, Mais2Ini : TIniFile;
  I, iUsuariosConectados, iLimiteUsuariosSimultaneos, II : Integer;
  bLegal : Boolean;
  fJuro, fMulta : Real;
  dtLimite: TDate;
  bEmpresaMei: Boolean;
  SizeDescricaoProd : integer;
begin
  // controle de licenças de uso
  Form22.Inicio := Time;
  bLegal := True;
  Form1.bMediaPonderadaFixa := False;

  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.WriteString('Uso','Uso','1');
    Mais1Ini.Free;
  except
    //ShowMessage('Execute este programa como administrador. Altere o atalho na aba compatibilidade.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Execute este programa como administrador. Altere o atalho na aba compatibilidade.',msgAtencao);
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

  try
    // verifica se o susário tem direito de leitura e gravação
    Mais1Ini.WriteString('Geral','Rede','OK');
  except
    // Não tem
    {
    ShowMessage('Verifique se o usuário do windows tem direito '+chr(10)+
                'de leitura e gravação em '+Form1.sAtual+'. Erro 1170');
    Mauricio Parizotto 2023-10-25}
    MensagemSistema('Verifique se o usuário do windows tem direito '+chr(10)+
                    'de leitura e gravação em '+Form1.sAtual+'. Erro 1170'
                    ,msgErro);

    Application.Terminate;
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;

  {Sandro Silva 2024-01-12 inicio
  if (StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2023','2023.0.0.0'))) > StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:','')))) then
  begin
    //ShowMessage('A build: '+Mais1Ini.ReadString('Geral','Build 2023','2023.0.0.0')+' já foi instalada na pasta: '+ sAtual+' você esta tentando'+Chr(10)+' rodar a build: '+StrTran(Form22.sBuild,'Versão e Build:','')+', este programa vai ser fechado.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('A build: '+Mais1Ini.ReadString('Geral','Build 2023','2023.0.0.0')+' já foi instalada na pasta: '+ sAtual+' você esta tentando'+Chr(10)+' rodar a build: '+
                    StrTran(Form22.sBuild,'Versão e Build:','')+', este programa vai ser fechado.'
                    ,msgAtencao);
  }
  if (StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2024','2024.0.0.0'))) > StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:','')))) then
  begin
    MensagemSistema('A build: '+Mais1Ini.ReadString('Geral','Build 2024','2024.0.0.0')+' já foi instalada na pasta: '+ sAtual+' você esta tentando'+Chr(10)+' rodar a build: '+
                    StrTran(Form22.sBuild,'Versão e Build:','')+', este programa vai ser fechado.'
                    ,msgAtencao);


    DefinirBuildEXEDAT;
    Instalarpackcomasltimasalteraes1Click(Sender);

    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;

  DefinirBuildEXEDAT;

  ConectaBancoCommerce; // Sandro Silva 2023-05-31

  {Mauricio Parizotto 2023-12-19 Inicio}
{  SizeDescricaoProd := TamanhoCampoFB(Form7.IBDatabase1,'ESTOQUE','DESCRICAO');
  Form7.ibDataSet4DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet16DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet23DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet27DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet28DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet35DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataset40DESCRICAO.Size := SizeDescricaoProd;
  Form7.ibDataSet37DESCRICAO.Size := SizeDescricaoProd;
  Form24.ibDataSet44DESCRICAO.Size := SizeDescricaoProd;}
  AjustarDataSetCamposProduto;
  {Mauricio Parizotto 2023-12-19 Fim}

  if Form1.sSerial = '' then
  begin
    MensagemSistema('Este sistema não foi totalmente instalado nesta pasta ou'+Chr(10)+
                    'não está liberado para uso neste computador, instale'+Chr(10)+
                    'novamente o sistema informando o número serial da'+Chr(10)+
                    'sua licença de uso.'+Chr(10)+Chr(10)+
                    'Código: 001 '+sLicenca
                    ,msgAtencao);


    Application.Terminate;
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end else
  begin
    iLimiteUsuariosSimultaneos := ValidaRecursos.SistemaLimiteUsuarios; // Sandro Silva 2023-05-31

    iReduzida := 0;

    Form22.sTitulo := ValidaRecursos.rsRecursoSistema.Produto;

    if AnsiContainsText(ValidaRecursos.rsRecursoSistema.Produto, ' Go') then
      iReduzida := 1;

    if ValidaRecursos.RecursoLiberado(rcOS, dtLimite) then
      Form22.sTitulo := ValidaRecursos.rsRecursoSistema.Produto + ' + Ordem de Serviço';

    // Empresas MEI
    bEmpresaMei := False;
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');

    if Mais1Ini.ReadString('LICENCA','MEI','NAO') = 'SIM' then
    begin
      Form1.iReduzida := 2;
      Form22.sTitulo := Form22.sTitulo + ' - Mei';
      bEmpresaMei := True;
    end else
    begin
      // Note que agora é no WIND0WS.L0G individual em cada maquina
      Mais2ini := TIniFile.Create('WIND0WS.L0G');

      if (Mais2Ini.ReadString('LICENCA','MEI','NAO') = 'SIM') or (Length(Mais2Ini.ReadString('LICENCA','MEI','')) > 8) then
      begin
        Mais2Ini.WriteString('LICENCA','MEI','OK');
        Form1.iReduzida := 2;
      end;
      Mais2Ini.Free;

      if Form1.iReduzida = 2 then
      begin
        Mais1Ini.WriteString('LICENCA','MEI','SIM');

        Form22.sTitulo := Form22.sTitulo + ' - Mei';
        bEmpresaMei := True;
      end;

    end;

    Form22.sLicenca := 'Licenciado para '+AllTrim(InttoStr(iLimiteUsuariosSimultaneos))+' usuários';
    //
    // é arqui a chave pra resolver os controles de seriais                                 X
    //
    // S15A80020025M
    //
    I := StrToInt('0'+LimpaNumero(Copy(Form1.sSerial,6,6)));
    //
    if (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('A'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('B'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('C'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('D'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('E'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('F'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('N'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('O'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('P'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('Q'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('R'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('M'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('S'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Start
    //Mauricio Parizotto 2023-05-22
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('T'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 01 Usuários Small Go
    then
    begin
      Form22.sSerie := 'Número de série: ' + Form1.sSerial;
    end else
    begin
      MensagemSistema('Este sistema não foi totalmente instalado nesta pasta ou'+Chr(10)+
                      'não está liberado para uso neste computador, instale'+Chr(10)+
                      'novamente o sistema informando o número serial da'+Chr(10)+
                      'sua licença de uso.'+Chr(10)+Chr(10)+
                      'Código: 002 '+sLicenca
                      ,msgAtencao);

      Application.Terminate;
      FecharAplicacao(ExtractFileName(Application.ExeName));
    end;

    sSerieS := StrTran(Form22.sSerie,'Número de série: ','');

    AutoSmallMobile1.Visible        := True;
    SincronizarSmallMobile1.Visible := True;
  end;

  if FileExists(Form1.sAtual+'\inicial\fundo\_small_6.bmp') then
    Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_6.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp');

  if (Form1.iReduzida = 1) then
  begin

    Form1.Caption     := 'Small Go';
    Application.Title := 'Small Go';

    Titulo(
           'SMALL GO, SIMPLES'+chr(10)+
           'FÁCIL E VERSÁTIL',

           'O Small Go é fácil de instalar,'+chr(10)+
           'simples de usar e atende a'+chr(10)+
           'necessidade de emissão de'+chr(10)+
           'NF-e, NFC-e e SAT.');

  end;

  if (Form1.iReduzida = 0) then
  begin
    Form1.Caption := 'Small Commerce';
    Titulo(
         'SMALL COMMERCE, '+chr(10)+
         'COMPLETO, SIMPLES E'+chr(10)+
         'VERSÁTIL',

         'O Small Commerce é fácil de'+chr(10)+
         'instalar, simples de usar'+chr(10)+
         'e atende as necessidades'+chr(10)+
         'das mais variadas'+chr(10)+
         'empresas de'+chr(10)+
         'comércio');
  end;

  // Sandro Silva 2023-06-02 if (Form1.iReduzida = 2) then
  if bEmpresaMei then
  begin
    Form1.Caption := 'Small Commerce (MEI)';
    Titulo(
         'SMALL Mei, '+chr(10)+
         'COMPLETO, SIMPLES E'+chr(10)+
         'VERSÁTIL',

         'O Small Mei é fácil de'+chr(10)+
         'instalar, simples de usar'+chr(10)+
         'e atende a legislação'+chr(10)+
         'do MEI');
  end;

  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  Mais1Ini.Free;
  Form22.sLicenca           := 'Licenciado para '+AllTrim(InttoStr(iLimiteUsuariosSimultaneos))+' usuários';
  Mensagem22('Aguarde abrindo arquivos...');
  Form22.Show;
  Form22.Repaint;

  //ConectaBancoCommerce; // Sandro Silva 2023-05-31

  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  sCertificado := Trim(Mais1ini.ReadString('NFE','Certificado',''));
  Mais1ini.Free;

  if Trim(sCertificado) = '' then
  begin
    if (not bEmpresaMei) and (ExecutaComandoEscalar(Form7.IBDatabase1,
                                                    ' Select Coalesce(E.CGC,'''') '+
                                                    ' From RDB$DATABASE R '+
                                                    '   Left Join EMITENTE E on 1=1') = '' ) then
    begin
      Form1.SelecionarCertificadoDigital1Click(nil); // Sandro Silva 2023-05-31 Form1.SelecionarCertificadoDigital1Click(Sender);
    end;
  end;

  iUsuariosConectados := Form7.IBDatabaseInfo1.UserNames.Count;

  if iUsuariosConectados > iLimiteUsuariosSimultaneos then
  begin
    Screen.Cursor := crDefault;
    Form1.MensagemRecursoIndisponivel('Este sistema está licenciado somente para '+IntToStr(iLimiteUsuariosSimultaneos)+' usuário(s)'+Chr(10)+
                'neste momento '+IntToStr(iUsuariosConectados)+' estão tentando usar o sistema.');

    Application.Terminate;
    // Sandro Silva 2023-05-31 Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;

  sBuild := '';

  try
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_BUILD,0) from rdb$database');
    Form1.ibDataset200.Open;
    sBuild := ibDataSet200.FieldByname('GEN_ID').AsString;
    Form1.ibDataset200.Close;

    if sBuild = '999' then
      DefineAmbienteNFe(_cAmbienteProducao, 'Mais.Ajustararquivo1Click');
  except
  end;

  // Genarator G_NSU_DOWNLOAD_XML
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_NSU_DOWNLOAD_XML');
  Form1.ibQuery2.Open;

  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_NSU_DOWNLOAD_XML');
    Form1.ibQuery2.ExecSQL;
  end;

  // Genarator G_GRAFICO_RECEBER
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_RECEBER');
  Form1.ibQuery2.Open;

  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_RECEBER');
    Form1.ibQuery2.ExecSQL;
  end;

  // Genarator G_GRAFICO_VENDAS
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_VENDAS');
  Form1.ibQuery2.Open;

  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_VENDAS');
    Form1.ibQuery2.ExecSQL;
  end;

  // Genarator G_GRAFICO_CAIXA
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_CAIXA');
  Form1.ibQuery2.Open;

  if Form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_CAIXA');
    Form1.ibQuery2.ExecSQL;
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select NFEPROTOCOLO from VENDAS where NUMERONF=''999999'' ');
    Form1.ibDataset200.Open;
    //
    if Form1.ibDataSet200.FieldByName('NFEPROTOCOLO').Size <= 15 then
    begin
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('alter table VENDAS alter NFEPROTOCOLO type varchar(80)');
      Form1.ibDataset200.Open;
      Form1.ibDataset200.Close;
      //
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('update VENDAS set NFEPROTOCOLO=SubString(NFEPROTOCOLO from 1 for 9)||'+QuotedStr('/001')+', MODELO=''SV'' where SubString(NUMERONF from 10 for 3)=''RPS''');
      Form1.ibDataset200.Open;

      {Mauricio Parizotto 2024-04-19
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('commit');
      Form1.ibDataset200.Open;
      }
      AgendaCommit(true);
    end;
  except
  end;



  //Mauricio Parizotto 2023-03-27
  // Atualiza a estrutura do banco de dados
  AtualizaBancoDeDados(sBuild);

  SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');

  if SmallIni.ReadString('ESTOQUE','Label28','Identificador 4')='IVA' then
  begin
    SmallIni.WriteString('ESTOQUE','Label28','Livre 4');
  end;

  SmallIni.Free;

  Mensagem22('Aguarde...');

  try
    try
      Mensagem22('Aguarde.');
      CommitaTudo(True);
      Mensagem22('Aguarde..');

      (*
      {Sandro Silva 2024-04-09 inicio}
      if TamanhoCampo(Form7.ibDataSet4.Transaction, 'ESTOQUE', 'DESCRICAO') = 120 then
      begin
        //Fechatudo(True);
        {
        try
          Form7.ibDataSet4.Transaction.DefaultDatabase.Close;
          Form7.ibDataSet4.Transaction.DefaultDatabase.Open;
        except

        end;
        }
        {Sandro Silva 2024-04-08 inicio}
        try
          ConectaBancoCommerce;
        except

        end;
        {Sandro Silva 2024-04-08 fim}
        AjustarDataSetCamposProduto;
      end;
      {Sandro Silva 2024-04-09 fim}
      *)
      AbreArquivos(True);
      Mensagem22('Aguarde...');
    except
      Screen.Cursor := crDefault;
      {
      Application.MessageBox(Pchar('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.'),'Atenção',mb_IconError+mb_Ok);
      Mauricio Parizotto 2023-10-24}
      MensagemSistema('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.', msgErro);

      Application.Terminate;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
    end;

    Mensagem22('Aguarde atualizando promoção.');
    AtualizaPromocao(True);

    {Sandro Silva 2022-12-15 inicio}
    ExibeRazaoSocialNoCaptionDoForm;
    {Sandro Silva 2022-12-15 fim}

    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    //
    if not (Form1.iReduzida = 1) then
    begin
      try
        if StrtoDate(Mais1Ini.ReadString('Outros','Data','26/09/1967')) <> Date then
        begin
          bPrimeiraAberturaDia := True; // Mauricio Parizotto 2024-07-05

          try
            Mais1Ini.WriteString('Outros','Data',DateToStr(Date));
            Mais1Ini.Free;
          except
          end;

          //Mauricio Parizotto 2024-06-27
          //Ajusta se é produto rural
          ExecutaComando(' Update CLIFOR set PRODUTORRURAL = ''S'' '+
                         ' Where Substring( Upper(Coalesce(IE,'''')) from 1 for 2) = ''PR'' '+
                         '   and CHAR_LENGTH(CGC) = 14 ');


          Form22.Repaint;
          Mensagem22('Atualizando valores no contas a receber...');

          if Form19.rbJurosSimples.Checked then
          begin
            try
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              {Mauricio Parizotto 2023-10-04 Inicio}
              //Form7.ibDataSet99.SelectSQL.Add('update RECEBER set VALOR_JURO=Cast((VALOR_DUPL * (((  Cast((CURRENT_DATE - VENCIMENTO)as decimal(12,2)) ) * '+ StrTran(FloatToStr(Form1.ftaxa),',','.') +'/100)+1.00)) as decimal(12,2)) where VALOR_RECE = 0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1');
              Form7.ibDataSet99.SelectSQL.Add(' Update RECEBER '+
                                              '   set VALOR_JURO = Cast((VALOR_DUPL * (((  Cast((CURRENT_DATE - VENCIMENTO)as decimal(12,2)) ) * '+ StrTran(FloatToStr(Form1.ftaxa),',','.') +'/100)+1.00)) as decimal(12,2)) '+
                                              // Soma o valor da multa se tiver
                                              ' + COALESCE(VALOR_MULTA,0) '+
                                              ' + Cast( (VALOR_DUPL / 100) * COALESCE( PERCENTUAL_MULTA,0) as decimal(18,2)) '+
                                              ' Where COALESCE(VALOR_RECE,0) = 0 '+
                                              '   and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9) <> 1 ');
              {Mauricio Parizotto 2023-10-04 Fim}
              Form7.ibDataSet99.Open;
            except
            end;
          end else
          begin
            try
              Form7.ibDataSet7.Close;
              Form7.ibDataSet7.SelectSQL.Clear;
              Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where VALOR_RECE = 0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1');
              Form7.ibDataSet7.Open;
              Form7.ibDataSet7.First;

              while not Form7.ibDataSet7.Eof do
              begin
                fJuro := Form7.ibDataSet7VALOR_DUPL.AsFloat;
                for I := 1 to  Trunc(Date - Form7.ibDataSet7VENCIMENTO.AsDateTime) do
                  fJuro  := fJuro * ((Form1.fTaxa / 100)+1);

                {Mauricio Parizotto 2023-10-04 Inicio}
                fMulta := 0;

                if Form7.ibDataSet7.FieldByName('PERCENTUAL_MULTA').AsFloat > 0 then
                begin
                  fMulta := (Form7.ibDataSet7VALOR_DUPL.AsFloat / 100) *  Form7.ibDataSet7.FieldByName('PERCENTUAL_MULTA').AsFloat;
                end;

                if Form7.ibDataSet7.FieldByName('VALOR_MULTA').AsFloat > 0 then
                begin
                  fMulta := Form7.ibDataSet7.FieldByName('VALOR_MULTA').AsFloat;
                end;

                if fJuro <> Form7.ibDataSet7VALOR_DUPL.AsFloat then
                begin
                  Form7.ibDataSet7.Edit;
                  //Form7.ibDataSet7VALOR_JURO.AsFloat  := fJuro;
                  Form7.ibDataSet7VALOR_JURO.AsFloat  := fJuro + fMulta;
                end;
                {Mauricio Parizotto 2023-10-04 Fim}

                Form7.ibDataSet7.Next;
              end;
            except
            end;
          end;

          // Dias de atrazo = 'CURRENT_DATE - VENCIMENTO'
          // fJuro  := fJuro * ((Form1.fTaxa / 100)+1);
          //         if fJuro <> ibDataSet7VALOR_DUPL.AsFloat then ibDataSet7VALOR_JURO.AsFloat  := fJuro;
          try
            Form22.Repaint;
            Mensagem22('Verificando clientes atrasados...');

            Form7.ibQuery2.Close;
            Form7.ibQuery2.Sql.Clear;
            Form7.ibQuery2.Sql.Add('update CLIFOR set MOSTRAR='+QuotedStr('0')+' where MOSTRAR<>'+QuotedStr('0')+' ');
            Form7.ibQuery2.Open;

            Form7.ibQuery1.Close;
            Form7.ibQuery1.Sql.Clear;
            Form7.ibQuery1.Sql.Add('select NOME, sum(VALOR_RECE) from RECEBER where coalesce(VALOR_RECE,0)=0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1 group by NOME');
            Form7.ibQuery1.Open;

            while not Form7.ibQuery1.eof do
            begin
              Form7.ibQuery2.Close;
              Form7.ibQuery2.Sql.Clear;
              Form7.ibQuery2.Sql.Add('update CLIFOR set MOSTRAR='+QuotedStr('1')+' where NOME='+QuotedStr(Form7.ibQuery1.FieldByName('NOME').AsString )+' ');
              Form7.ibQuery2.Open;

              Form7.ibQuery1.Next;
            end;

            Form22.Repaint;
            Mensagem22('Pronto...');
          except
          end;
        end;

        Form7.ibDataSet7.EnableControls;

        AgendaCommit(True);
        Commitatudo(True); // SQL - Commando
        AbreArquivos(False);
      except
        //ShowMessage('Provável falha no Banco de Dados. Erro 4412');  Mauricio Parizotto 2023-10-25
        MensagemSistema('Provável falha no Banco de Dados. Erro 4412',msgErro);
        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
        Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
        Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
      end;
    end;
  except
    MensagemSistema('Para solucionar o problema siga os seguintes passos:'+chr(10)
                    +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista, 7, 8)'
                    +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
                    +chr(10)+'3 - Arquivo "smallcom.zzz" pode estar danificado (O arquivo deve ser excluido)'
                    +chr(10)+'4 - Reinstale o programa'
                    ,msgAtencao);

    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
  end;

  EnviarXMLContabilidadeAut;

  // Legal
  {Mauricio Parizotto 2024-05-24
  if not bLegal then
  begin
    if Legal_ok(True) then
    begin
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to ' + Copy(dateToStr(Date),7,4) + Copy(dateToStr(Date),4,2) + Copy(dateToStr(Date),1,2) );
      Form1.ibDataset200.Open;
    end;
  end;
  }

  // Licença
  try
    try
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Clear;
      Form1.ibQuery2.SQL.Add('select LICENCA from EMITENTE');
      Form1.ibQuery2.Open;
      //
      Form7.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta
      //
      {Sandro Silva 2022-11-11 inicio
      if AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) <> '' then
      begin
        fDias := 365 - (Date - StrToDate(Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),7,2)
                 +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),5,2)
                 +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),1,4)));
      end else
      begin
        fDias := -1;
      end;
      }

      {if ValidacaoNova = False then
      begin

        if AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) <> '' then
        begin
          // Calcula o número de dias restantes para usar o sistema
          // 365 - (Data do PC - Data do registro)
          fDias := 365 - (Date - StrToDate(Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),7,2)
                   +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),5,2)
                   +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),1,4)));
        end else
        begin
          fDias := -1;
        end;

      end
      else Mauricio Parizotto 2024-05-24}
      begin
        if AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) <> '' then
        begin
          // Calcula o número de dias restantes para usar o sistema
          // Data limite - data atual do PC
          fDias := (StrToDate(Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),7,2)
                   +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),5,2)
                   +'/'+Copy(Form7.LbBlowfish1.DecryptString( AllTrim(Form1.ibQuery2.FieldByname('LICENCA').AsString) ),1,4))
                   - Date);
        end else
        begin
          fDias := -1;
        end;

      end;
      {Sandro Silva 2022-11-11 fim}
      //
    except
      fDias := -1;
    end;

    if fdias <= 0 then
    begin
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
      Form1.ibDataset200.Open;
    end else
    begin
      if fDias <= 20 then
      begin
        //ShowMessage('Número de série: ' + Form1.sSerial + ' licenciado para mais ' + FloatToStr(fDias) + ' dias'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Número de série: ' + Form1.sSerial + ' licenciado para mais ' + FloatToStr(fDias) + ' dias');
      end;

      {Sandro Silva 2023-03-15 inicio
      if fDias <= 40 then
      begin
        //
        if fDias <> 0 then
        begin
          for I := 1 to (40 - StrToInt(FloatToStr(fDias)) ) do
          begin
            //
            Mensagem22('Número de série: ' + Form1.sSerial +  chr(10) + ' licenciado para mais ' + FloatToStr(fDias) + ' dias' + chr(10) + chr(10) + Replicate('_',( (40 - StrToInt(FloatToStr(fDias)) ) +1 - I)));
            //
            //if I = 1 then Sleep(2000) else Sleep(200);
            if I = 1 then
              Sleep(2000)
            else
              Sleep(200);
            //
          end;
        end;
        //
      end;
      }

      //fDias := 7;

      if fDias <= 8 then
      begin
        if fDias <> 0 then
        begin
          // Exibe mensagem de alerta dos dias restantes por 5 segundos
          for I := 1 to 5 do
          begin
            Mensagem22('Número de série: ' + Form1.sSerial +  chr(10) + ' licenciado para mais ' + FloatToStr(fDias) + ' dias');

            Sleep(1000);
          end;
        end;
      end;
      {Sandro Silva 2023-03-15 fim}
    end;
  except
  end;

  Screen.Cursor := crDefault;
end;

procedure TForm1.EnviarXMLContabilidadeAut;
var
  oArqDat: TArquivosDAT;
  bDataAnt: TDate;
begin
  oArqDat := TArquivosDAT.Create(EmptyStr);
  try
    if not oArqDat.NFe.XML.EnvioAutomatico then
      Exit;

    bDataAnt := oArqDat.NFe.XML.DataUltimoEnvio;
    if (MonthOf(bDataAnt) = MonthOf(Date))
       and (YearOf(bDataAnt) = YearOf(Date)) then
      Exit;

    frmExportaXML := TfrmExportaXML.Create(nil);
    try
      Mensagem22('Enviando arquivos XML para a contabilidade...');
      // Seta data atual para não ocorrer dois envios simultaneos.
      oArqDat.NFe.XML.DataUltimoEnvio := Date;

      if not frmExportaXML.EnviarMesAnterior(oArqDat.NFe.XML.NFeSaida, oArqDat.NFe.XML.NFeEntrada, oArqDat.NFe.XML.NFCe,
                                             oArqDat.NFe.XML.EmailContabilidade) then
      begin
        // Caso não seja enviado setar a data anterior para que na proxima abertura ocorra nova tentativa.
        oArqDat.NFe.XML.DataUltimoEnvio := bDataAnt;
      end;
    finally
      Mensagem22('Pronto...');
      FreeAndNil(frmExportaXML);
    end;
  finally
    FreeAndNil(oArqDat);
  end;
end;

procedure TForm1.Image17Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.Comissodevendedores1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  //Form7.Close; Mauricio Parizotto 2023-06-27 causa erro invalid transaction handle
  Form7.sModulo := 'VENDEDOR';
  Form7.sTitulo := 'Cadastro dos vendedores';
  Form7.sRPS := 'N';
  Form7.Show;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('liberar_modulos.htm')));
end;

procedure TForm1.Grupos1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  //Form7.Close; Mauricio Parizotto 2023-06-27 causa erro invalid transaction handle
  Form7.sModulo := 'GRUPOS';
  Form7.sTitulo := 'Grupos de mercadorias no estoque';
  Form7.sRPS := 'N';
  Form7.Close;
  Form7.Show;
end;

procedure TForm1.Cadastrarlicenasdeuso1Click(Sender: TObject);
var
  sSerieS  : String;
  sSerial  : String;
  Mais1Ini : TIniFile;
  I        : Integer;
begin
  sSerial := StrTran(UpperCase(AllTrim(Small_InputForm('Cadastro de licenças de uso','Número da licença:',sSerial))),'.','');
  //
  if (Length(alltrim(sSerial)) = 13) then //sistema novo
  begin
    I := StrToInt('0'+LimpaNumero(Copy(sSerial,6,6)));

    // é arqui a chave pra resolver os controles de seriais                                 X
    if (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('A'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('B'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('C'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('D'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('E'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('F'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('N'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('O'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('P'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários Small Mei + OS
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('Q'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('R'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('M'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Mei
    or (Copy(Form1.sSerial,4,10) = StrTran(StrTran(UpperCase('S'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Start
    then
    begin
      I := StrToInt('0'+LimpaNumero(Copy(sSerial,7,5)));

      if I = StrToInt('0'+LimpaNumero(Copy(Alltrim(Form22.sSerie),7+17,5))) then
      begin
        Mais1ini := TIniFile.Create('WIND0WS.L0G');
        Mais1Ini.WriteString('LICENCA','Ser',sSerial); // 2019 - Cadastro Licença de uso de 2019
        Mais1Ini.Free;

        //ShowMessage('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.'); Mauricio Parizotto 2023-10-25}
        MensagemSistema('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.');

        Application.Terminate;

        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
        Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
      end else
      begin
        //ShowMessage('Este número de licença não foi liberado para este serial.'); Mauricio Parizotto 2023-10-25}
        MensagemSistema('Este número de licença não foi liberado para este serial.', msgAtencao);
      end;
    end;
  end else
  begin
    if (Length(alltrim(sSerial)) = 11) then //sistema novo
    begin
      sSerieS := StrTran(Form22.sSerie,'Número de série: ','');
      if sSerial = Copy(sSerieS,1,3) + Copy(sSerieS,6,6) + IntToStr(StrToInt(Modulo_11(Copy(sSerieS,2,2)+Copy(sSerieS,6,6)))+57) then
      begin
        Mais1ini := TIniFile.Create('WIND0WS.L0G');
        Mais1Ini.WriteString('SC','Mob',sSerial); // Small Mobile
        Mais1Ini.Free;
        //ShowMessage('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.');

        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
        Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
      end else
      begin
        if alltrim(sSerial) <> '' then
          MensagemSistema('Número de licença inválido.',msgAtencao);
      end;
    end else
    begin
      if alltrim(sSerial) <> '' then
        MensagemSistema('Número de licença inválido.',msgAtencao);
    end;
  end;
end;

procedure TForm1.UsuriosAtivos1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', 'usuarios.exe','', '', SW_SHOW);
end;

procedure TForm1.Instalarpackcomasltimasalteraes1Click(Sender: TObject);
var
  vQtdConexoes : integer;
begin
  // Necessario conectar com o BD antes, caso contrario ira usar o caminho definido na propriedade (dfm) do IBDataBase (unit7) - Dailon - 2023/06/07 (FICHA - 7019)
  if (not Form1.ibDataSet200.Transaction.DefaultDatabase.Connected) then
    ConectaBancoCommerce;

  vQtdConexoes := ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase,
                                        'Select Count(*) From MON$ATTACHMENTS');

  if vQtdConexoes > 1 then
  begin
    MensagemSistema('Não foi possível iniciar a atualização.'+#13#10+
                    'Existem outros usuários com o sistema aberto.'+#13#10+
                    'Feche o sistema em todos os computadores e tente novamente.'
                    ,msgAtencao);

    Exit;
  end;


  if FileExists(Form1.sAtual+'\smallcon.exe') then
  begin
    {Sandro Silva 2024-01-12 inicio
    ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20231001.sma '+
                                                   '20231002.sma '+
                                                   '20231003.sma '+
                                                   '20231004.sma '+
                                                   '20231005.sma '+
                                                   '20231006.sma '+
                                                   '20231007.sma '+
                                                   '20231008.sma '+
                                                   '20231009.sma '+
                                                   'nfce2023.sma '+
                                                   '2023_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma '),
                                              '',
                                              SW_SHOW);
    }
    ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20241001.sma '+
                                                   '20241002.sma '+
                                                   '20241003.sma '+
                                                   '20241004.sma '+
                                                   '20241005.sma '+
                                                   '20241006.sma '+
                                                   '20241007.sma '+
                                                   '20241008.sma '+
                                                   '20241009.sma '+
                                                   'nfce2024.sma '+
                                                   '2024_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma '),
                                              '',
                                              SW_SHOW);
    {Sandro Silva 2024-01-12 fim}
  end;
  {Sandro Silva 2022-12-28 fim}

  Winexec('TASKKILL /F /IM "smallcdf.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  {Sandro Silva 2023-11-06 inicio}
  //Alguns lugares da acesso negado no TASKKILL Ficha 7556
  Application.Terminate;
  {Dailon Parisotto (f-7599) 2023-12-11 inicio}
  Sleep(200);
  {Dailon Parisotto (f-7599) 2023-12-11 fim}
  Halt(1);
  {Sandro Silva 2023-11-06 fim}
end;

procedure TForm1.IntegraoIta1Click(Sender: TObject);
var
  bLiberado : Boolean;
  dLimiteRecurso : Tdate;
begin
  bLiberado := (RecursoLiberado(Form7.IBDatabase1,rcIntegracaoItau,dLimiteRecurso));

  if not bLiberado then
  begin
    MensagemRecursoIndisponivel('Integração Itaú não está disponível para esta licença');
    Exit;
  end;

  try
    FrmIntegracaoItau := TFrmIntegracaoItau.Create(self);
    FrmIntegracaoItau.ShowModal;
  finally
    FreeAndNil(FrmIntegracaoItau);
  end;
end;

procedure TForm1.Postit1Click(Sender: TObject);
begin
  frmExportaXML := TfrmExportaXML.Create(nil);
  try
    frmExportaXML.SetImagem(imgVendas.Picture);
    frmExportaXML.ShowModal;
  finally
    FreeAndNil(frmExportaXML);
  end;
end;

procedure TForm1.Cadastrodeconvnios1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  //Form7.Close; Mauricio Parizotto 2023-06-27
  Form7.sModulo := 'CONVENIO';
  Form7.sTitulo := 'Cadastro de convênios';
  Form7.sRPS := 'N';
  Form7.Show;
end;

procedure TForm1.imgCliForClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  try
    if not FechaTudo(bFechaTudo) then
      Exit;

    Form7.sModulo := 'CLIENTES';
    Form1.Label201MouseLeave(Sender);
    Form7.sTitulo := 'Cadastro';
    Form7.sRPS := 'N';
    Form7.Show;

    if not bClientesLiberados then
    begin
      Form7.sTitulo := 'Cadastro fornecedores';
      Form7.sRPS := 'N';
      Form7.Caption := Form7.sTitulo;
    end;

    if not bFornecedoresLiberados then
    begin
      Form7.sTitulo := 'Cadastro de clientes';
      Form7.sRPS := 'N';
      Form7.Caption := Form7.sTitulo;
    end;
  except
  end;
end;

procedure TForm1.imgEstoqueClick(Sender: TObject);
var
  I : Integer;
begin
  if not (Form13.Tag = 99) then
  begin
    if not Legal(True) then
      Exit;
  end;

  // Teste
  try
    if not FechaTudo(bFechaTudo) then
      Exit;
    Form7.sModulo  := 'ESTOQUE';
    Form1.Label201MouseLeave(Sender);
    Form7.sTitulo  := 'Controle de estoque';
    Form7.sRPS := 'N';
    Form7.Show;
  except end;

  if Form13.Tag = 99 then
  begin
    for I := 1 to 5 do
    begin
      Form7.Close;
      Form7.Show;
    end;
    Form13.Tag := 0;
  end;
end;

procedure TForm1.imgBancosClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  if ValidaRecursoExibeMensagemIndisponivel then
  begin

    if not (Form1.iReduzida = 1) then
    begin
      try
        if not FechaTudo(bFechaTudo) then
          Exit;
        Form7.sModulo := 'BANCOS';
        Form1.Label201MouseLeave(Sender);
        Form7.sTitulo := 'Controle bancário';
        Form7.sRPS := 'N';
        Form7.Show;
      except end;
    end;
  end;
end;

procedure TForm1.imgVendasClick(Sender: TObject);
var
  Mais1ini : tIniFile;
begin
  try
    if not Legal(True) then
      Exit;

    if not FechaTudo(bFechaTudo) then
      Exit;

    // NFe com CPF
    if Length(LimpaNumero(Form7.ibDataSet13CGC.AsString)) = 11 then
    begin
      if Form1.bNotaVendaLiberada  then Form7.Notasfiscaisdesadavendassrie9201.Enabled := True       else Form7.Notasfiscaisdesadavendassrie9201.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := True else Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := False;

      Form7.Vendas_1.Enabled                         := False;
      Form7.NotasfiscaisdesadavendasSrie11.Enabled   := False;
      Form7.NotasfiscaisdesadavendasSrie21.Enabled   := False;

      try
        if (StrToIntDef(LimpaNumero(Form1.sSerieEspecial), -1) > 920) and (StrToIntDef(LimpaNumero(Form1.sSerieEspecial), -1) <= 969) then // Sandro Silva 2023-05-31 if (StrToInt(LimpaNumero(Form1.sSerieEspecial)) > 920) and (StrToInt(LimpaNumero(Form1.sSerieEspecial)) <= 969) then
        begin
          Form7.Vendas_XXX.Enabled                       := True;
          Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := True;
        end else
        begin
          Form7.Vendas_XXX.Enabled                       := False;
          Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := False;
        end;
      except
        Form7.Vendas_XXX.Enabled                       := False;
        Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := False;
      end;

      Form7.Vendas2.Enabled := False;
    end else
    begin
      {Sandro Silva 2023-05-08 inicio
      if Form1.bNotaVendaLiberada  then Form7.Vendas_1.Enabled := True else Form7.Vendas_1.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendasSrie11.Enabled := True else Form7.NotasfiscaisdesadavendasSrie11.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Notasfiscaisdesadavendassrie21.Enabled := True else Form7.NotasfiscaisdesadavendasSrie21.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Vendas_XXX.Enabled := True else Form7.Vendas_XXX.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := True else Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Vendas2.Enabled := True else Form7.Vendas2.Enabled := False;
      }
      Form7.Vendas_1.Enabled                         := Form1.bNotaVendaLiberada;
      Form7.NotasfiscaisdesadavendasSrie11.Enabled   := Form1.bNotaVendaLiberada;
      Form7.Notasfiscaisdesadavendassrie21.Enabled   := Form1.bNotaVendaLiberada;
      Form7.Vendas_XXX.Enabled                       := Form1.bNotaVendaLiberada;
      Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := Form1.bNotaVendaLiberada;
      Form7.Vendas2.Enabled                          := Form1.bNotaVendaLiberada;
      {Sandro Silva 2023-05-08 fim}

      Form7.Notasfiscaisdesadavendassrie9201.Enabled       := False;
      Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := False;
      //
    end;

    {Sandro Silva 2023-05-08 inicio
    if Form1.bNotaCompraLiberada then Form7.Compras_1.Enabled := True else Form7.Compras_1.Enabled := False;
    if Form1.bNotaCompraLiberada then Form7.Compras2.Enabled := True else Form7.Compras2.Enabled := False;
    }
    Form7.Compras_1.Enabled := Form1.bNotaCompraLiberada;
    Form7.Compras2.Enabled  := Form1.bNotaCompraLiberada;
    {Sandro Silva 2023-05-08 fim}

    if Form1.sSerieEspecial <> 'XXX' then
    begin
      if AllTrim(Form1.sSerieEspecial) <> '' then
      begin
        Form7.Vendas_XXX.Visible                           := True;
        Form7.Vendas_XXX.Caption                           := 'Notas fiscais de saída (vendas) série '+StrZero(StrToInt(LimpaNumero(Form1.sSerieEspecial)),3,0);
        Form7.NotasfiscaisdesadavendassrieXXX1.Caption     := 'Notas fiscais de saída (vendas) série '+StrZero(StrToInt(LimpaNumero(Form1.sSerieEspecial)),3,0);
        Form7.NotasfiscaisdesadavendassrieXXX1.Visible     := True;
      end;
    end;
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
    //
    if Form1.bNotaVendaLiberada  then
    begin
      //
      if Length(LimpaNumero(Form7.ibDataSet13CGC.AsString)) = 11 then
      begin
        if Form1.bNotaVendaLiberada  then
        begin
          if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE XXX' then
          begin
            Form7.Vendas_XXXClick(Sender);
          end else
          begin
            Form7.Notasfiscaisdesadavendassrie9201Click(Sender);
          end;
        end;
      end else
      begin
        if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE 1'   then
          Form7.Vendas_1Click(Sender)
        else if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE 2'   then
          Form7.NotasfiscaisdesadavendasSrie11Click(Sender)
        else if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE XXX' then
          Form7.Vendas_XXXClick(Sender)
        else if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'COMPRA'    then
          Form7.Vendas_1Click(Sender)
        else if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE RPS' then
          Form7.Vendas_1Click(Sender)
        else if Mais1Ini.ReadString('NOTAS','default','SERIE 1') = 'SERIE 920' then
          Form7.Vendas_1Click(Sender);
      end;
    end;

    Form1.Label201MouseLeave(Sender);

    if Form12.Visible then
      Form12.Show;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-24
      MensagemSistema(E.Message,msgAtencao);
    end;
  end;
end;


procedure TForm1.imgBackupClick(Sender: TObject);
{
var
  Backup: TBackup;
}
begin
(*
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form7.sModulo := 'BACKUP';
  Form1.Label201MouseLeave(Sender);

  Backup := TBackup.Create;
  {Mauricio parizotto 2023-08-09 Inicio}

  Backup.FMostraDialogs := True;
  SelectDirectory('Selecione um dispositivo de armazenamento externo que seja seguro para fazer uma cópia do banco de dados.', '', Backup.FDiretorioBKP);
  Backup.FNomeArquivoBKP := Limpanumero(Form7.ibDataset13CGC.AsString) + '_' + Alltrim(DiaDaSemana(date));

  try
    Commitatudo(True);
  except
  end;

  try
    FechaTudo(Form1.bFechaTudo);
    Form7.ibDataSet13.Close;
  except
  end;

  {Mauricio parizotto 2023-08-09 Fim}

  if Backup.FazerBackup = IDYES then
    Form19.Button1Click(Sender);

  FreeAndNil(Backup);

  if Form7.sModulo <> 'INDICADORES' then
    Form7.sModulo := '';
Mauricio Parizotto 2023-08-10*)

  ppmBackup.Popup(Form1.imgBackup.Left,Form1.imgBackup.Top + Form1.imgBackup.Height + 35);
end;

procedure TForm1.imgConfiguracoesClick(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form7.sAjuda := 'config.htm';
  Form7.sModulo := 'CONFIG';
  Form1.Label201MouseLeave(Sender);

  try
    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    if Form24.Visible then Form24.Close;
    if Form12.Visible then Form12.Close;
    if Form7.Visible then Form7.Close;
    if Form30.Visible then Form30.Close;
    if Form48.Visible then Form48.Close;

    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

    if AllTrim(Mais1Ini.ReadString(Usuario,'B7','0')) <> '1' then
    begin
      Comissodevendedores1.Enabled := False;
      Cadastrodeconvnios1.Enabled  := False;
      TabeladeICMparatodososestados1.Enabled := False;
      Limparmovimento1.Enabled := False;
      Cadastrarlicenasdeuso1.Enabled := False;
      UsuriosAtivos1.Enabled := False;
      Instalarpackcomasltimasalteraes1.Enabled := False;
      Cadastrodoemitente1.Enabled := False;
      Cadastrodetcnicos1.Enabled := False;
      Planodecontas1.Enabled := False;
      Cadastrodetransportadoras1.Enabled := False;
      Grupos1.Enabled := False;
      SQLMododecomando1.Enabled := False;
      ConfiguraodaNFe2.Enabled := False;
    end else
    begin
      Comissodevendedores1.Enabled := True;
      Cadastrodeconvnios1.Enabled  := True;
      TabeladeICMparatodososestados1.Enabled := True;
      Limparmovimento1.Enabled := True;
      Cadastrarlicenasdeuso1.Enabled := True;
      UsuriosAtivos1.Enabled := True;
      Instalarpackcomasltimasalteraes1.Enabled := True;
      Cadastrodoemitente1.Enabled := True;
      Cadastrodetcnicos1.Enabled := True;

      if (Form1.iReduzida = 1) then
      begin
        Planodecontas1.Enabled := False;
      end else
      begin
        Planodecontas1.Enabled := True;
      end;

      Cadastrodetransportadoras1.Enabled := True;
      Grupos1.Enabled                    := True;
      SQLMododecomando1.Enabled          := True;
      ConfiguraodaNFe2.Enabled           := True;
    end;

    PopupMenu1.Popup(Form1.imgConfiguracoes.Left,Form1.imgConfiguracoes.Top + Form1.imgConfiguracoes.Height + 35);

    Mais1Ini.Free;
  except
  end;

  Screen.Cursor := crDefault; // Cursor de Aguardo
end;

procedure TForm1.wwwsmallsoftcombr1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open','http://www.smallsoft.com.br','', '', SW_SHOWMAXIMIZED);
end;

procedure TForm1.imgContaReceberClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  if ValidaRecursoExibeMensagemIndisponivel then
  begin

    if not (Form1.iReduzida = 1) then
    begin
      try
        if not FechaTudo(bFechaTudo) then
          Exit;
        Form7.sModulo := 'RECEBER';
        Form1.Label201MouseLeave(Sender);
        Form7.sTitulo := 'Contas a receber';
        Form7.sRPS := 'N';
        Form7.Show;
      except end;
    end;
  end;
end;

procedure TForm1.imgContaPagarClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  if ValidaRecursoExibeMensagemIndisponivel then
  begin

    if not (Form1.iReduzida = 1) then
    begin
      try
        if not FechaTudo(bFechaTudo) then
          Exit;
        Form7.sModulo := 'PAGAR';
        Form1.Label201MouseLeave(Sender);
        Form7.sTitulo := 'Contas a pagar';
        Form7.sRPS := 'N';
        Form7.Show;
      except end;
    end;
  end;
end;

procedure TForm1.imgOrdemServicoClick(Sender: TObject);
begin
  if not Legal(True) then
    Exit;

  try
    if not FechaTudo(bFechaTudo) then
      Exit;
    Form7.sModulo := 'OS';
    Form1.Label201MouseLeave(Sender);
    Form7.sTitulo := 'Ordem de serviço';
    Form7.sRPS := 'N';
    Form7.Show;
  except end;

  if Form30.Visible then
    Form30.Show;
end;

procedure TForm1.Cadastrodetcnicos1Click(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  //Form7.Close; Mauricio Parizotto 2023-06-27
  Form7.sModulo := 'TECNICO';
  Form7.sTitulo := 'Cadastro de técnicos';
  Form7.sRPS := 'N';
  Form7.Show;
end;

procedure TForm1.Calendrio1Click(Sender: TObject);
var
  F : TextFile;
  dContador : TdateTime;
  I, J : Integer;
begin
  /////////////////////////
  // C A L E N D A R I O //
  /////////////////////////
  CriaJpg('logotip.jpg');
  DeleteFile(pChar(Senhas.UsuarioPub+'.HTM'));
  AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
  Rewrite(F);                             // Abre para gravação
  Writeln(F,'<html><head><title>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString))+' - CALENDÁRIO '+IntToStr(Year(Date))+'</title></head>');
  WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0">');
  WriteLn(F,'<center><img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
  WriteLn(F,'<br><font face="verdana" size=1 color=#c0c0c0><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font><br>');
  WriteLn(F,'<br><font face="verdana" size=1 color=#000000><b>CALENDÁRIO</font>');
  WriteLn(F,'<br><font face="verdana" size=7 color=#c0c0c0>'+IntToStr(Year(Date))+'</b></font>');
  //
  WriteLn(F,'<table border=0 bgcolor=#FFFFFF cellspacing=5 cellpadding=5>');
  WriteLn(F,' <tr  align=left>');
  //
  for J := 1 to 12 do
  begin
    //
    if (J = 4) or (J=7) or (J=10)  then
    begin
      WriteLn(F,' </tr>');
      WriteLn(F,'</table>');
      WriteLn(F,'<table border=0 bgcolor=#FFFFFF cellspacing=5 cellpadding=5>');
      WriteLn(F,' <tr  align=left>');
    end;
    //
    WriteLn(F,'  <td>');
    WriteLn(F,'   <font face="verdana" size=1><center><b>'+MesExtenso(J)+'</b></center><br>'); // Mês e ano
    WriteLn(F,'   <table border=0 bgcolor=#FFFFFF cellspacing=0 cellpadding=0>');
    WriteLn(F,'    <tr  align=left>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1 color=FF0000>Dom</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1>Seg</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1>Ter</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1>Qua</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1>Qui</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1>Sex</font></td>');
    WriteLn(F,'     <td '+{nowrap}' align=Right width=30><font face="verdana" size=1 color=FF0000>Sab</font></td>');
    WriteLn(F,'    </tr>');
    //
    WriteLn(F,'    <tr bgcolor=#FFFFFF>');
    //
    dContador  := StrToDate('01/'+StrZero(J,2,0)+'/'+StrZero(Year(Date),4,0));
    //
    for I := 1 to DayOfWeek(dContador)-1 do WriteLn(F,'     <td '+{nowrap}' align=left><font face="verdana" size=1></td>');
    //
    for I := 1 to DiasPorMes(Year(Date),J) do
    begin
      if DayOfWeek(dContador) = 1 then WriteLn(F,'    <tr bgcolor=#FFFFFF>');
      WriteLn(F,'     <td '+{nowrap}'  align=Right><font face="verdana" size=1 color=c0c0c0>'+IntToStr(Day(dContador))+'</td>');
      if DayOfWeek(dContador) = 7 then WriteLn(F,'    </tr>');
      dContador := SomaDias(dContador, 1);                // Incrementa o contador
    end;
    //
    WriteLn(F,'    </tr>');
    WriteLn(F,'   </table>');
    WriteLn(F,'  </td>');
    //
  end;
  //
  WriteLn(F,' </tr>');
  WriteLn(F,'</table>');
  //
  WriteLn(F,'<br><font face="verdana" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
  + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
  + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');
  //
  WriteLn(F,'<br>');              // Linha em branco
  //
  // WWW
  //
  if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
  begin
    //WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Small, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
  end else
  begin
    WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
  end;
  //
  if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
  WriteLn(F,'</center>');
  //
  WriteLn(F,'</html>');
  CloseFile(F);                                    // Fecha o arquivo
  //
  AbreArquivoNoFormatoCerto(pChar(Senhas.UsuarioPub+'.HTM'));
  //
  //
/////////////////////////
// C A L E N D A R I O //
/////////////////////////
  //
end;

procedure TForm1.Label201MouseLeave(Sender: TObject);
begin
  // Nota
  if not ((Form7.sModulo = 'NOTA') or (Form7.sModulo = 'CONFOS') or (Form7.sModulo = 'CONFRECIBO')) then
  begin
    Form1.Panel_3.Visible := True;
  end;

  // Vendas
  if Label201.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'VENDA') then
    begin
      imgVendas.Picture := Image201_R.Picture;
      Label201.Font.Style := [];
      Label201.Font.Color := clBlack;

      imgServicos.Picture    := Image201S_R.Picture;
      Label201S.Font.Style := [];
      Label201S.Font.Color := clBlack;
    end;

    if (Form7.sRPS = 'S') then
    begin
      imgVendas.Picture := Image201_R.Picture;
      Label201.Font.Style := [];
      Label201.Font.Color := clBlack;
    end;
  end;

  // Compras
  if Label201C.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'COMPRA') then
    begin
      imgCompras.Picture    := Image201C_R.Picture;
      Label201C.Font.Style := [];
      Label201C.Font.Color := clBlack;
    end;
  end;

  // Serviços
  if Label201S.Font.Style <> [] then
  begin
    if (Form7.sRPS <> 'S') then
    begin
      imgServicos.Picture    := Image201S_R.Picture;
      Label201S.Font.Style := [];
      Label201S.Font.Color := clBlack;
    end;
  end;

  // INDICADORES
  if Label200.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'INDICADORES') then
    begin
      imgIndicadores.Picture := Image200_R.Picture;
      Label200.Font.Style := [];
      Label200.Font.Color := clBlack;
    end;
  end;

  // OS
  if Label201_.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'OS') then
    begin
      imgOrdemServico.Picture := Image201__R.Picture;
      Label201_.Font.Style := [];
      Label201_.Font.Color := clBlack;
    end;
  end;

  // ESTOQUE
  if Label202.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'ESTOQUE') then
    begin
      imgEstoque.Picture := Image202_R.Picture;
      Label202.Font.Style := [];
      Label202.Font.Color := clBlack;
    end;
  end;

  // CADATRO
  if Label203.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'CLIENTES') then
    begin
      imgCliFor.Picture := Image203_R.Picture;
      Label203.Font.Style := [];
      Label203.Font.Color := clBlack;
    end;
  end;

  // RECEBER
  if Label204.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'RECEBER') then
    begin
      imgContaReceber.Picture := Image204_R.Picture;
      Label204.Font.Style := [];
      Label204.Font.Color := clBlack;
    end;
  end;

  // PAGAR
  if Label210.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'PAGAR') then
    begin
      imgContaPagar.Picture := Image210_R.Picture;
      Label210.Font.Style := [];
      Label210.Font.Color := clBlack;
    end;
  end;

  // CAIXA
  if Label205.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'CAIXA') then
    begin
      imgCaixa.Picture := Image205_R.Picture;
      Label205.Font.Style := [];
      Label205.Font.Color := clBlack;
    end;
  end;

  // BANCOS
  if Label206.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'BANCOS') then
    begin
      imgBancos.Picture := Image206_R.Picture;
      Label206.Font.Style := [];
      Label206.Font.Color := clBlack;
    end;
  end;

  // CONFIG
  if Label207.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'CONFIG') then
    begin
      imgConfiguracoes.Picture := Image207_R.Picture;
      Label207.Font.Style := [];
      Label207.Font.Color := clBlack;
    end;
  end;

  // BACKUP
  if Label208.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'BACKUP') then
    begin
      imgBackup.Picture := Image208_R.Picture;
      Label208.Font.Style := [];
      Label208.Font.Color := clBlack;
    end;
  end;

  MontaTela(True);
end;

procedure TForm1.Label201MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone NF-e
  if Label201.Font.Style <> [fsBold] then
  begin
    imgVendas.Picture    := Image201_X.Picture;
    Label201.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_10.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_10.bmp');

      Titulo(

            'EMITA A NF-e DE'+chr(10)+'VENDA',

            'A Nota Fiscal Eletrônica além de'+chr(10)+
            'atender a legislação controla as'+chr(10)+
            'vendas da sua empresa'+chr(10)+
            'de forma automática'

            );
    end;
  end;
end;

procedure TForm1.SQLMododecomando1Click(Sender: TObject);
var
  Retangulo : tRect;
  wndHandle : THandle;
  wndClass  : array[0..50] of char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0],nil);
  GetWindowRect(wndHandle,Retangulo);
  //
  try
    //
    dbGrid200.Visible := False;
    Edit200.Visible   := False;
    //
    ibDataSet200.Close;
    ibDataSet200.SelectSQL.Clear;
    //
    Edit200.Align   := AlTop;
    dbGrid200.Align := AlClient;
    //
    Edit200.Top       := 0;
    Edit200.Left      := 0;
    Edit200.Width     := Screen.Width-16;
    dbGrid200.Left    := 0;
    dbGrid200.Top     := 20;
    dbGrid200.Height  := Form1.Height-56;
    dbGrid200.Width   := Screen.Width-16;
    dbGrid200.Visible := True;
    Edit200.Visible   := True;
    Edit200.SetFocus;
    //
  except
  end;
  //
  try
    Form7.ibDataSet101.Close;
    Form7.ibDataSet101.SelectSql.Clear;
    Form7.ibDataset101.SelectSql.Add('select gen_id(G_MUTADO,1) from rdb$database');
    Form7.ibDataset101.Open;
  except end;
  //
end;

procedure TForm1.Edit200KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_sql.htm')));
  if KEY = VK_RETURN then
  begin
    Audita('SQL','SMALL', Senhas.UsuarioPub, Copy(Edit200.Text+replicate(' ',80),1,80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
    ExecutaSql(True);
  end;

  if Key = VK_ESCAPE then
  begin
    try
      ibDataSet200.Close;
      dbGrid200.Visible := False;
      Edit200.Visible   := False;

      Commitatudo(True); // SQL - Commando
      AbreArquivos(False);

      MontaTela(True);
    except
    end;
  end;

  Screen.Cursor := crDefault;
end;

procedure TForm1.este1Click(Sender: TObject);
var
  Result : String;
  sMax   : String;
  sMensagem2, sMensagem : String;
  iUsuariosAtivos: Integer;
  sResponsavelTecnico : String;
  Mais1ini : tIniFile;
  iNumeroArquivo: Integer;
  function NumeroArquivo(): String;
  begin
    Inc(iNumeroArquivo, 1);
    Result := IntToStr(iNumeroArquivo);
  end;
begin
  iNumeroArquivo := -1; // Sandro Silva 2022-12-28
  //
  Form22.Show;
  Form22.Repaint;
  sMensagem := 'Arquivos ajustados com sucesso';
  //
  Screen.Cursor := crHourGlass;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    if Form7.ibDataSet39.Active then
    begin
      if FileExists(Form1.sAtual+'\autoexec.sql') then
      begin
        RenameFile('autoexec.sql','executa.sql');
        Form1.Edit200.Text := 'import from EXECUTA.SQL';
        ExecutaSql(True);
      end;
    end;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message+'.. Ao executar EXECUTA.SQL.'),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-24
      MensagemSistema(E.Message+'.. Ao executar EXECUTA.SQL.',msgAtencao);
    end;
  end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  CommitaTudo(True); // bakcup Ok
  {Sandro Silva 2023-04-17 inicio
  //Não é prudente excluir índice
  //Não está funcionando o loop abaixo. dbGrid200.DataSource.DataSet não está ativo!
  try
    //
    // Apaga todos os indices
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select i.rdb$index_name,i.rdb$unique_flag,i.rdb$relation_name,s.rdb$field_name from rdb$indices i join rdb$index_segments s on (i.rdb$index_name = s.rdb$index_name) where i.rdb$index_name not like '+QuotedStr('RDB$%')+' ');
    Form1.ibQuery1.Open;
    //
    while not Form1.ibQuery1.Eof do
    begin
      //
      try
        //
        // Mensagem22('Removendo indice '+AllTrim(Form1.ibQuery1.Fields[0].asString));
        //
        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('drop index '+dbGrid200.Fields[0].asString+' ');
        Form1.ibQuery2.ExecSQL;
      except end;
      //
      Form1.ibQuery1.Next;
      //
    end;
    //
    Form1.ibQuery1.Close;

  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message+'.. Ao remover índices.'),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
  }
  iUsuariosAtivos := Form7.IBDatabaseInfo1.UserNames.Count;
  //
  if iUsuariosAtivos = 1 then
  begin
    Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
    //
    try
      Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
      //
      Form7.IBDatabase1.Connected := False;
      //
      Form7.IBBackupService1.Attach;
      Form7.IBBackupService1.ServerName      := 'localhost';
      Form7.IBBackupService1.DatabaseName    := Form1.sAtual+'\small.fdb';
      Form7.IBBackupService1.BackupFile.Text := 'backup.gbak';
      Form7.IBBackupService1.Options         := [];
      Form7.IBBackupService1.Active          := True;
      Form7.IBBackupService1.ServiceStart;
      //
      Result := '';
      while ( not Form7.IBBackupService1.Eof ) do
      begin
        Result := Form7.IBBackupService1.GetNextLine;
        Application.ProcessMessages;
      end;
      //
      Form7.IBBackupService1.Active := False;
      //
      Form7.IBRestoreService1.ServerName          := 'localhost';
      Form7.IBRestoreService1.BackupFile.Clear;
      Form7.IBRestoreService1.DatabaseName.Clear;
      //
      Form7.IBRestoreService1.BackupFile.Text   := 'backup.gbak';
      Form7.IBRestoreService1.DatabaseName.Text := Form1.sAtual+'\small.fdb';
      Form7.IBRestoreService1.Attach;
      Form7.IBRestoreService1.Active := True;
      Form7.IBRestoreService1.ServiceStart;
      //
      Result := '';
      while not Form7.IBRestoreService1.Eof do
      Begin
        Result := Form7.IBRestoreService1.GetNextLine;
        Application.ProcessMessages;
      End;
      //
      Form7.IBRestoreService1.Active := False;
      sMensagem := sMensagem + ' com liberação de espaço';
      //
    except end;
    //
    Form7.IBDatabase1.Connected := True;
    Form7.IBTransaction1.Active := True;
  end;
  //
  try
    Form7.IBDatabase1.Connected := False;

    Form7.IBBackupService1.Attach;
    Form7.IBBackupService1.ServerName      := 'localhost';
    Form7.IBBackupService1.DatabaseName    := Form1.sAtual+'\small.fdb';
    Form7.IBBackupService1.BackupFile.Text := 'off13.gbak';

    Form7.IBBackupService1.Options := [MetadataOnly];

    Form7.IBBackupService1.Active          := True;
    Form7.IBBackupService1.ServiceStart;

    Result := '';
    while ( not Form7.IBBackupService1.Eof ) do
    begin
      Result := Form7.IBBackupService1.GetNextLine;
      if AllTrim(Result) <> '' then
        //ShowMessage(Result); Mauricio Parizotto 2023-10-25
        MensagemSistema(Result);
    end;

    Form7.IBBackupService1.Active := False;

    Form7.IBRestoreService1.ServerName          := 'localhost';
    Form7.IBRestoreService1.BackupFile.Clear;
    Form7.IBRestoreService1.DatabaseName.Clear;

    Form7.IBRestoreService1.BackupFile.Text   := 'off13.gbak';
    Form7.IBRestoreService1.DatabaseName.Text := Form1.sAtual+'\off13.fdb';
    Form7.IBRestoreService1.Attach;
    Form7.IBRestoreService1.Active := True;
    Form7.IBRestoreService1.ServiceStart;

    Result := '';
    while not Form7.IBRestoreService1.Eof do
    Begin
      Result := Form7.IBRestoreService1.GetNextLine;
      Application.ProcessMessages;
      if AllTrim(Result) <> '' then
        //ShowMessage(Result); Mauricio Parizotto 2023-10-25
        MensagemSistema(Result);
    End;

    Form7.IBRestoreService1.Active := False;
  except
  end;

  AjustaRegistro(NumeroArquivo(),'CAIXA');
  AjustaRegistro(NumeroArquivo(),'ALTERACA');
  AjustaRegistro(NumeroArquivo(),'ORCAMENT');
  AjustaRegistro(NumeroArquivo(),'FLUXO');
  AjustaRegistro(NumeroArquivo(),'ITENSETI');
  AjustaRegistro(NumeroArquivo(),'GRUPO');
  AjustaRegistro(NumeroArquivo(),'GRADE');
  AjustaRegistro(NumeroArquivo(),'SERIE');
  AjustaRegistro(NumeroArquivo(),'COMPOSTO');
  AjustaRegistro(NumeroArquivo(),'USUARIOS');
  AjustaRegistro(NumeroArquivo(),'NOTA');
  AjustaRegistro(NumeroArquivo(),'CONFOS');
  AjustaRegistro(NumeroArquivo(),'TRANSPOR');
  AjustaRegistro(NumeroArquivo(),'ITENS001');
  AjustaRegistro(NumeroArquivo(),'VENDAS');
  AjustaRegistro(NumeroArquivo(),'ITENS002');
  AjustaRegistro(NumeroArquivo(),'COMPRAS');
  AjustaRegistro(NumeroArquivo(),'ITENS003');
  AjustaRegistro(NumeroArquivo(),'EMITENTE');
  AjustaRegistro(NumeroArquivo(),'ICM');
  AjustaRegistro(NumeroArquivo(),'BANCOS');
  AjustaRegistro(NumeroArquivo(),'MOVIMENT');
  AjustaRegistro(NumeroArquivo(),'RESUMO');
  AjustaRegistro(NumeroArquivo(),'VENDEDOR');
  AjustaRegistro(NumeroArquivo(),'CONVENIO');
  AjustaRegistro(NumeroArquivo(),'CONTAS');
  AjustaRegistro(NumeroArquivo(),'PAGAR');
  AjustaRegistro(NumeroArquivo(),'RECEBER');
  AjustaRegistro(NumeroArquivo(),'CLIFOR');
  AjustaRegistro(NumeroArquivo(),'OS');
  AjustaRegistro(NumeroArquivo(),'REDUCOES');
  AjustaRegistro(NumeroArquivo(),'ESTOQUE');
  AjustaRegistro(NumeroArquivo(),'PAGAMENT');
  AjustaRegistro(NumeroArquivo(),'DEMAIS');
  AjustaRegistro(NumeroArquivo(),'MUNICIPIOS');
  AjustaRegistro(NumeroArquivo(),'AUDIT0RIA');
  AjustaRegistro(NumeroArquivo(),'CODEBAR');
  AjustaRegistro(NumeroArquivo(),'NFCE');

  //Mauricio Parizotot 2023-08-07 Tabela BACKUP e BACKUPHORARIOS não tem campo Registro

  {Sandro Silva 2022-12-28 inicio}
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  // Ajusta generator para PK_SERIE da tabela SERIE, onde armazena o número de série usado no cadastro de produtos
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(REGISTRO) from SERIE');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;

    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIE to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
  except
    on E: Exception do
    begin
    end;
  end;
  {Sandro Silva 2022-12-28 fim}

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_ORCAMENTO ');
    Form1.ibQuery1.ExecSQL;
    Form1.ibQuery1.Close;
  except end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(PEDIDO) from ORCAMENT');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;

    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_ORCAMENTO to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  // NSU
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_NSU ');
    Form1.ibQuery1.ExecSQL;
  except end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NSU) from VENDAS');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_NSU to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
  except end;

  // NF SERIE 1
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIE1 ');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%001')+' ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIE1 to 0'+copy(sMax,1,9)+' ');
    Form1.ibQuery1.ExecSQL;
  except end;

  // NF SERIE 2
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIERPS ');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%RPS')+' ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIERPS to 0'+copy(sMax,1,9)+' ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIE2 ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%002')+' ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIE2 to 0'+copy(sMax,1,9)+' ');
    Form1.ibQuery1.ExecSQL;
  except
  end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  if Trim(form1.sSerieEspecial) <> '' then // Sandro Silva 2022-12-22
  begin
    // Serie especial precisa existir. Do contrário irá alterar o generator errado, alterará o generator da tabela SERIE g_serie
    try
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      Form1.ibQuery1.SQL.Add('create generator G_SERIE'+Form1.sSerieEspecial);
      Form1.ibQuery1.ExecSQL;
    except
    end;

    try
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%')+form1.sSerieEspecial+' ');
      Form1.ibQuery1.Open;
      sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      Form1.ibQuery1.SQL.Add('set generator G_SERIE'+Form1.sSerieEspecial+' to 0'+copy(sMax,1,9)+' ');
      Form1.ibQuery1.ExecSQL;
    except
    end;
  end;

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIE920');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%920')+' ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIE920 to 0'+copy(sMax,1,9)+' ');
    Form1.ibQuery1.ExecSQL;
  except end;

  // OS
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_NUMEROOS ');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(NUMERO) from OS ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_NUMEROOS to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
  except end;

  // CODIGO Código do produto no estoque
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_CODIGO ');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  // Créditos para liberação da NF-e
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_C0DIG0 ');
    Form1.ibQuery1.ExecSQL;

    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_C0DIG0 to 500');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(CODIGO) from ESTOQUE ');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_CODIGO to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
  except end;

  // Indices
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_CODIGO ON ALTERACA (CODIGO)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_PEDIDO_ITEM ON ALTERACA (PEDIDO, ITEM)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_PEDIDODATACX ON ALTERACA (PEDIDO, DATA, CAIXA)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  // Indices
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND1MOVIMENT on MOVIMENT(PREDATA)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND2MOVIMENT on MOVIMENT(EMISSAO)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND3MOVIMENT on MOVIMENT(COMPENS)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND1DATA on CAIXA(DATA)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  // Indices
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_NFCE_DATA ON NFCE (DATA)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_NFCE_NUMERONF ON NFCE (NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND2NOME on CLIFOR(NOME)');
    Form1.ibQuery1.ExecSQL;
  except
  end;

{
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_CLIFOR_UPPERNOME ON CLIFOR COMPUTED BY (UPPER(NOME));');
    Form1.ibQuery1.ExecSQL;
  except end;
}
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IDX_ORCAMENT_PEDIDO on ORCAMENT (PEDIDO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IDX_ORCAMENT_DESCRICAO on ORCAMENT (DESCRICAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND7NOME on RECEBER(NOME)');
    Form1.ibQuery1.ExecSQL;
  except end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND7VENCIMENTO on RECEBER(VENCIMENTO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND15NUMERONF on VENDAS(NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_COMPOSTO_CODIGO ON COMPOSTO (CODIGO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND16NUMERONF on ITENS001(NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND35NUMERONF on ITENS003(NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND15CLIENTE on VENDAS(CLIENTE)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND15EMISSAO on VENDAS(EMISSAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND24NUMERONF on COMPRAS(NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND23NUMERONF on ITENS002(NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND4CODIGO on ESTOQUE(CODIGO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND4REFERENCIA on ESTOQUE(REFERENCIA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND4DESCRICAO on ESTOQUE(DESCRICAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ESTOQUE_UPPERDESCRICAO ON ESTOQUE COMPUTED BY (UPPER(DESCRICAO));');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ESTOQUE_UPPERNOME ON ESTOQUE COMPUTED BY (UPPER(NOME));');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND24EMISSAO on COMPRAS(EMISSAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND14NOME on ICM(NOME)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND3NUMERO on OS(NUMERO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND16NUMEROOS on ITENS001(NUMEROOS)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND35NUMEROOS on ITENS003(NUMEROOS)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  // ALTERACA
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_DATA ON ALTERACA (DATA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_DESCRICAO ON ALTERACA (DESCRICAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_PEDIDO ON ALTERACA (PEDIDO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_CAIXA ON ALTERACA (CAIXA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAMENT_PEDIDO ON PAGAMENT (PEDIDO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAMENT_CAIXA ON PAGAMENT (CAIXA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_RECEBER_NUMERONF ON RECEBER (NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_RECEBER_RECEBIMENT ON RECEBER (RECEBIMENT)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAR_VENCIMENTO ON PAGAR (VENCIMENTO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAR_NOME ON PAGAR (NOME)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAR_NUMERONF ON PAGAR (NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_PAGAR_PAGAMENTO ON PAGAR (PAGAMENTO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_OS_DATA ON OS (DATA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ITENS002_DESCRICAO ON ITENS002 (DESCRICAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ITENS002_FORNECEDOR ON ITENS002 (FORNECEDOR)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Commitatudo(True);
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    AtivaTodosOsIndices(True);
  except end;

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Commitatudo(True);

  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');

  try
    // Ativa todos os indices
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select i.rdb$index_name,i.rdb$unique_flag,i.rdb$relation_name,s.rdb$field_name from rdb$indices i join rdb$index_segments s on (i.rdb$index_name = s.rdb$index_name) where i.rdb$index_name not like '+QuotedStr('RDB$%')+' and i.rdb$index_inactive=1');
    Form1.ibQuery1.Open;

    sMensagem2 := '';

    while not Form1.ibQuery1.Eof do
    begin
      try
        sMensagem2 := sMensagem2 + AllTrim(Form1.ibQuery1.Fields[0].asString)+', ';
        Form1.ibQuery1.Next;
      except end;
    end;

    if AllTrim(sMensagem2)<>'' then
    begin
      //ShowMessage('Não foi possível ativar os seguintes indices: '+chr(10)+chr(10)+sMensagem2+chr(10)+chr(10)+'Feche o sistema nas outras máquinas e tente novamente.' ); Mauricio Parizotto 2023-10-25
      MensagemSistema('Não foi possível ativar os seguintes indices: '+chr(10)+chr(10)+sMensagem2+chr(10)+chr(10)+'Feche o sistema nas outras máquinas e tente novamente.' ,msgAtencao);
    end else
    begin
      sMensagem := sMensagem + ' e indíces ativados';
    end;

    Form1.ibQuery1.Close;
  except
  end;

  sResponsavelTecnico := '';

  begin
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    // Sandro Silva 2023-01-03 Form1.ibQuery1.SQL.Add('select NFEXML, EMISSAO from VENDAS where EMITIDA=''S'' and NFEXML not like ''%<infRespTec><CNPJ>43728245000142</CNPJ>%'' and NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO');
    // Listar xml com responsável diferente da Smallsoft ou Zucchetti
    Form1.ibQuery1.SQL.Text :=
      'select NFEXML, EMISSAO ' +
      'from VENDAS ' +
      'where EMITIDA=''S'' ' +
      ' and NFEXML not like ''%<infRespTec><CNPJ>43728245000142</CNPJ>%'' ' + // Sebrae/SP
      ' and NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' ' + // Smallsoft
      ' and NFEXML not like ''%<infRespTec><CNPJ>03916076000664</CNPJ>%'' ' + // Zucchetti
      ' and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO';
    Form1.ibQuery1.Open;
    Form1.ibQuery1.Last;
    //
    sResponsavelTecnico := xmlNodeValue(Form1.ibQuery1.FieldByname('NFEXML').AsString, '//infRespTec/CNPJ');
    //
    if sResponsavelTecnico <> '' then
    begin
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      // Sandro Silva 2023-01-03 Form1.ibQuery1.SQL.Add('select NFEXML, EMISSAO from VENDAS where EMITIDA=''S'' and NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO');
      // Listar xml com responsável diferente da Smallsoft ou Zucchetti
      Form1.ibQuery1.SQL.Add('select NFEXML, EMISSAO from VENDAS where EMITIDA=''S'' and (NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' and NFEXML not like ''%<infRespTec><CNPJ>03916076000664</CNPJ>%'') and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO');
      Form1.ibQuery1.Open;
      Form1.ibQuery1.Last;
      //
      sResponsavelTecnico := xmlNodeValue(Form1.ibQuery1.FieldByname('NFEXML').AsString, '//infRespTec/CNPJ');
    end;

    if sResponsavelTecnico <> '' then
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\small.ini');
      Mais1Ini.WriteString('T','Origem',sResponsavelTecnico); // Cadastro Licença de uso

      if sConve = '00:00:00' then
      begin
        Mais1Ini.WriteString('T','Tempo','00:05:'+StrZero(Random(50),2,0)); // Cadastro Licença de uso
      end;

      Mais1Ini.Free;
    end;
  end;

  {Sandro Silva 2023-03-01 inicio}
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select first 1 CODIGO ' +
      'from ESTOQUE ' +
      'where cast(CUSTOMEDIO as varchar(1000)) containing ''INF'' ' +
      ' or upper(cast(CUSTOMEDIO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('CODIGO').AsString <> '' then
    begin

      Mensagem22('validando o custo médio do estoque');

      CommitaTudo(True);
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Text :=
        'update ESTOQUE set CUSTOMEDIO = 0.00 ' +
        'where cast(CUSTOMEDIO as varchar(1000)) containing ''INF'' ' +
        ' or upper(cast(CUSTOMEDIO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
      Form1.ibQuery1.ExecSQL;
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(Form1.IBQuery1.SQL.Text + #13 + E.Message,msgErro);
    end;
  end;
  {Sandro Silva 2023-03-01 fim}


  {Sandro Silva 2023-03-02 inicio}
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select first 1 CODIGO ' +
      'from ESTOQUE ' +
      'where cast(CUSTOCOMPR as varchar(1000)) containing ''INF'' ' +
      ' or upper(cast(CUSTOCOMPR as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('CODIGO').AsString <> '' then
    begin

      Mensagem22('validando o custo médio do estoque');

      CommitaTudo(True);
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Text :=
        'update ESTOQUE set CUSTOCOMPR = 0.00 ' +
        'where cast(CUSTOCOMPR as varchar(1000)) containing ''INF'' ' +
        ' or upper(cast(CUSTOCOMPR as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
      Form1.ibQuery1.ExecSQL;
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(Form1.IBQuery1.SQL.Text + #13 + E.Message,msgErro);
    end;
  end;
  {Sandro Silva 2023-03-02 fim}

  {Sandro Silva 2023-03-29 inicio}
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select first 1 CODIGO ' +
      'from ITENS002 ' +
      'where cast(CUSTO as varchar(1000)) containing ''INF'' ' +
      ' or upper(cast(CUSTO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('CODIGO').AsString <> '' then
    begin

      Mensagem22('validando o custo os itens das compras');

      CommitaTudo(True);
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Text :=
        'update ITENS002 set CUSTO = 0.00 ' +
        'where cast(CUSTO as varchar(1000)) containing ''INF'' ' +
        ' or upper(cast(CUSTO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
      Form1.ibQuery1.ExecSQL;
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(Form1.IBQuery1.SQL.Text + #13 + E.Message,msgErro);
    end;
  end;

  {Sandro Silva 2023-03-29 fim}
  // F7709 - Caso do banco onde existia registro com VALOR_DUPL e VALOR_PAGO armazenando o valor "INF"
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select first 1 VALOR_DUPL ' +
      'from PAGAR ' +
      'where cast(VALOR_DUPL as varchar(1000)) containing ''INF'' ' +
      ' or upper(cast(VALOR_DUPL as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('VALOR_DUPL').AsString <> '' then
    begin

      Mensagem22('validando o valor das contas a pagar');

      CommitaTudo(True);
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Text :=
        'update PAGAR set VALOR_DUPL = 0.00 ' +
        'where cast(VALOR_DUPL as varchar(1000)) containing ''INF'' ' +
        ' or upper(cast(VALOR_DUPL as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
      Form1.ibQuery1.ExecSQL;
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(Form1.IBQuery1.SQL.Text + #13 + E.Message,msgErro);
    end;
  end;

  // F7709 - Caso do banco onde existia registro com VALOR_DUPL e VALOR_PAGO armazenando o valor "INF"
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select first 1 VALOR_PAGO ' +
      'from PAGAR ' +
      'where cast(VALOR_PAGO as varchar(1000)) containing ''INF'' ' +
      ' or upper(cast(VALOR_PAGO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('VALOR_PAGO').AsString <> '' then
    begin

      Mensagem22('validando o valor pago das contas a pagar');

      CommitaTudo(True);
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Text :=
        'update PAGAR set VALOR_PAGO = 0.00 ' +
        'where cast(VALOR_PAGO as varchar(1000)) containing ''INF'' ' +
        ' or upper(cast(VALOR_PAGO as varchar(1000))) containing ''1.#IND00000000000'' '; // NAN
      Form1.ibQuery1.ExecSQL;
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(Form1.IBQuery1.SQL.Text + #13 + E.Message,msgErro);
    end;
  end;

  {Sandro Silva 2023-12-27 inicio}

  {Sandro Silva 2023-12-27 fim}

  Form7.Caption := sMensagem + '...';
  //
  Mensagem22('Abrindo arquivos. Aguarde...');
  Form22.Button1.Visible := True;
  //
  CommitaTudo(True); // bakcup Ok
  AbreArquivos(True); // bakcup Ok
  Audita('AJUSTOU','SMALL', Senhas.UsuarioPub, sMensagem,0,0); // Ato, Modulo, Usuário, Histórico, Valor
  Screen.Cursor        := crDefault;
  //
  Mensagem22(sMensagem+'...');
  Form22.Label6.Width   := Screen.Width;
  Form22.Label6.Repaint;
  //
end;

procedure TForm1.DBGrid200KeyPress(Sender: TObject; var Key: Char);
var
  I, J : Integer;
  F : TextFile;
  vTotal: array [0..200] of Double;  // Cria uma matriz com 100 elementos
begin
  if Key = chr(16) then
  begin
    if Form1.bHtml1 then
    begin
      AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));
      Rewrite(F);
      CriaJpg('logotip.jpg');
      Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - SQL COMANDO</title></head>');
      WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
      WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
      WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font><br><br>');
      //
      WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F,' <tr bgcolor=#'+Form1.sHtmlCor+' align=left>');
      //
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].DisplayName+'</font></th>');
      end;
      WriteLn(F,' </tr>');
    end else
    begin
      AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));
      Rewrite(F);
      WriteLn(F,AllTrim(Form7.ibDataSet13NOME.AsString));
      WriteLn(F,'');
      //
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        Write(F,Copy(dbGrid200.Fields[I].DisplayName+Replicate(' ',dbGrid200.Fields[I].DisplayWidth),1,dbGrid200.Fields[I].DisplayWidth)+' ');
      end;
      WriteLn(F,'');
      //
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        Write(F,Replicate('-',dbGrid200.Fields[I].DisplayWidth)+' ');
      end;
      WriteLn(F,'');
    end;
    //
    J := 0;
    for I := 1 to 200 do vTotal[I] := 0;
    //
    ibDataSet200.DisableControls;
    ibDataSet200.First;
    while not Form1.ibDataSet200.Eof do
    begin
      J := J + 1;
      //
      if Form1.bHtml1 then
      begin
        WriteLn(F,' <tr>');
        for I := 0 to dbGrid200.FieldCount -1 do
        begin
          if TipoCampoFloat(dbGrid200.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid200.Fields[I].DataType = ftFloat then
          begin
            WriteLn(F,'  <td '+{nowrap}' align=right><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].asString+'</font></td>');
            vTotal[I] := vTotal[I] + dbGrid200.Fields[I].AsFloat;
          end else
          begin
            if dbGrid200.Fields[I].DisplayName =  'FOTO' then
            begin
              WriteLn(F,'  <td '+{nowrap}'><font face="Microsoft Sans Serif" size=1>FOTO</font></td>');
            end else
            begin
              WriteLn(F,'  <td '+{nowrap}'><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].asString+'</font></td>');
            end;
          end;
        end;
        WriteLn(F,' </tr>');
      end else
      begin
        for I := 0 to dbGrid200.FieldCount -1 do
        begin
          if TipoCampoFloat(dbGrid200.Fields[I]) then //2024-04-29 if dbGrid200.Fields[I].DataType = ftFloat then
          begin
            Write(F,Format('%'+IntToStr(dbGrid200.Fields[I].DisplayWidth)+'.'+Form1.ConfCasas+'n',[dbGrid200.Fields[I].asFloat])+' ');
            vTotal[I] := vTotal[I] + dbGrid200.Fields[I].AsFloat;
          end else
          begin
            if dbGrid200.Fields[I].DisplayName =  'FOTO' then
            begin
              Write(F,'FOTO');
            end else
            begin
              Write(F,Copy(dbGrid200.Fields[I].asString+Replicate(' ',250),1,dbGrid200.Fields[I].DisplayWidth)+' ');
            end;
          end;
        end;
        //
        WriteLn(F,'');
      end;
      //
      Form1.ibDataSet200.Next;
    end;
    ibDataSet200.EnableControls;
    //
    if Form1.bHtml1 then
    begin
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid200.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid200.Fields[I].DataType = ftFloat then
        begin
          WriteLn(F,'  <td '+{nowrap}' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[vTotal[I]])+'</font></td>');
        end else
        begin
          WriteLn(F,'  <td '+{nowrap}'></td>');
        end;
      end;
      //
      WriteLn(F,' </table');
      //
      WriteLn(F,'<center><br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
      + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
      + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br>');

      if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
      begin
        WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Small, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
      end else
      begin
        WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
      end;
      //
      WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>Através do seguinte comando SQL digitado pelo operador: <br>'+Form1.ibDataSet200.SelectSQL.Text+'</center>');
      WriteLn(F,'<font size=1><center>Número de registros: '+IntToStr(J)+'</font></center>');
      if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
      WriteLn(F,'</html>');
      CloseFile(F);                                    // Fecha o arquivo
      Screen.Cursor  := crDefault; // Cursor de Aguardo
      if FileExists(Senhas.UsuarioPub+'.HTM') then AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
    end else
    begin
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid200.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid200.Fields[I].DataType = ftFloat then
        begin
          Write(F,Replicate('-',dbGrid200.Fields[I].DisplayWidth)+' ');
        end else
        begin
          Write(F,Replicate(' ',dbGrid200.Fields[I].DisplayWidth)+' ');
        end;
      end;
      WriteLn(F,'');
      //
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid200.Fields[I]) then //Sandro Silva 2024-04-29 if dbGrid200.Fields[I].DataType = ftFloat then
        begin
          Write(F,Format('%'+IntToStr(dbGrid200.Fields[I].DisplayWidth)+'.'+Form1.ConfCasas+'n',[vTotal[I]])+' ');
        end else
        begin
          Write(F,Replicate(' ',dbGrid200.Fields[I].DisplayWidth)+' ');
        end;
      end;
      WriteLn(F,'');

      WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
      + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
      + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'');

      WriteLn(F,'Relatório gerado pelo sistema Small, www.smallsoft.com.br'); // Ok
      WriteLn(F,'Através do seguinte comando SQL digitado pelo operador: '+Form1.ibDataSet200.SelectSQL.Text+' ');
      WriteLn(F,'Número de registros: '+IntToStr(J)+'');
      CloseFile(F);                                    // Fecha o arquivo
      if FileExists(Senhas.UsuarioPub+'.txt') then ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOW);
    end;
  end;
end;

procedure TForm1.estardesempenho1Click(Sender: TObject);
var
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
begin
  Screen.Cursor            := crHourGlass;

  tInicio := time;
  with form7 do
  begin
    Form1.imgCaixaClick(Sender); // Caixa
    Form7.Vendas_1Click(Sender); // Vendas
    Form1.imgEstoqueClick(Sender); // Estoque
    Form1.imgCliForClick(Sender); // Clientes
    Form1.imgContaReceberClick(Sender); // Receber
    Form1.imgContaPagarClick(Sender); // Pagar
    Form1.imgBancosClick(Sender); // Bancos
    Form7.Close;
  end;

  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  Screen.Cursor            := crDefault;

  MensagemSistema('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10)+' Nota: '+ StrZero(10-(((Time - tInicio)*10000*2)),5,2));

  Audita('TESTOU','SMALL', Senhas.UsuarioPub,'Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10)+' Nota: '+ StrZero(10-(((Time - tInicio)*10000*2)),5,2),0,0); // Ato, Modulo, Usuário, Histórico, Valor

  if (10-(((Time - tInicio)*10000*2))) < 0 then
  begin
    MensagemSistema('Seu sistema está muito lento.'+chr(10)+
                    chr(10)+
                    'Verifique'+chr(10)+
                    chr(10)+
                    '1 - Base de dados muito grande (Limpar movimento desnecessário).'+chr(10)+
                    '2 - Desempenho do ambiente de rede (Todas as placas configuradas no mínimo a 100 Mbps)'+chr(10)+
                    '3 - Memória e processamento (Quanto mais memória e processador melhor).'+chr(10)+
                    '4 - Vírus, spywere ou outro malwere (Atualize seu antivirus).'+chr(10)+
                    '5 - Outro software processando em segundo plano (Verifique os processos no gerenciador de tarefas).'+chr(10)+
                    chr(10)+
                    ' Nota: '+ StrZero(10-(((Time - tInicio)*10000*2)),5,2)
                    ,msgAtencao);
  end;
end;

procedure TForm1.PopupMenu1Change(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
var
  S       : TSearchREc;
  NewItem : tMenuItem;
  JaTem   : Boolean;
  I   : Integer;
begin
  try
    I := FindFirst(sAtual + '\Plug-in\' + '*.exe' ,faAnyFile, S);
    Plugin1.Visible := False;

    while I = 0 do
    begin
      JaTem := False;
      for I := 0 to Plugin1.Count -1 do
      begin
        if Alltrim(Plugin1.Items[I].Caption) = StrTran(AllTrim(S.Name),'.exe','') then
        begin
          JaTem := True;
        end;
      end;

      if not Jatem then
      begin
        NewItem         := TMenuItem.Create(Plugin1);
        NewItem.Caption := Alltrim(StrTran(AllTrim(S.Name),'.exe',''));
        NewItem.OnClick := Form1.ExecutaOPlugin;
        Plugin1.Add(NewItem);
        Plugin1.Visible := True;
      end;

      I := FindNext(S);
    end;
  except
  end;
end;

procedure TForm1.Liberarosmdulosparaesteusurio1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
begin
  //Form7.Close; Mauricio Parizotto 2023-08-14 causa erro invalid transaction handle f-7258
  Form22.Show;
  Mensagem22('');
  Senhas2.ShowModal;
  Form22.Close;
  //
  Senha2:=Senhas2.SenhaPub2;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  sSenha := '';
  // ----------------------------- //
  // Fórmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //
  if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
  begin
    Form1.Label207.Tag     := 0;
    Form2.ShowModal;
  end else
  begin
    MensagemSistema('Senha do administrador inválida.',msgAtencao);
  end;

  Form1.FormShow(Sender);
  Form1.Activate;
  Mais1Ini.Free;
end;

procedure TForm1.RegistrodoProgramaonline1Click(Sender: TObject);
begin
  RegistrodoPrograma(False);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  sTag, sValor : String;
  I, J, iSenha : Integer;
  Mais1Ini: TIniFile;
  sSenha, sSenhaX: String;
  Retangulo : tRect;
  wndHandle : THandle;
  wndClass  : array[0..50] of char;
  InfTermo : Boolean;
begin
  //Termos de Uso - Deve ficar no inicio antes de criar o arquivo smallcom.inf
  InfTermo := GetTermoUso;

  try
    Mais1ini        := TIniFile.Create('FRENTE.INI');
    sModeloPAF      := Mais1Ini.ReadString('Frente de caixa','Modelo do ECF','02');
    sNomePAF        := Mais1Ini.ReadString('Frente de caixa','Nome do ECF','02');
    Mais1ini.Free;

    if (not FileExists(Form1.sAtual+'\graficos.exe')) or (not FileExists(Form1.sAtual+'\retaguarda.chm') or (not FileExists(Form1.sAtual+'\inicial\small_22_.bmp')) ) then
    begin
      MensagemSistema('Não foi possível iniciar o sistema'+chr(10)+
                      chr(10)+
                      chr(10)+'Verifique:'+
                      chr(10)+
                      chr(10)+'1 - Se o servidor está ligado.'+
                      chr(10)+'2 - Se a rede está acessível.'+
                      chr(10)+'3 - Se o sistema foi instalado na pasta:'+
                      chr(10)+
                      chr(10)+'       '+sAtual+
                      chr(10)
                      ,msgAtencao);

      if (not FileExists(Form1.sAtual+'\graficos.exe')) then
        //ShowMessage('O arquivo GRAFICOS.EXE não foi encontrado na pasta.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('O arquivo GRAFICOS.EXE não foi encontrado na pasta.',msgAtencao);
      if (not FileExists(Form1.sAtual+'\retaguarda.chm')) then
        //ShowMessage('O arquivo RETAGUARDA.CHM não foi encontrado na pasta.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('O arquivo RETAGUARDA.CHM não foi encontrado na pasta.',msgAtencao);
      if (not FileExists(Form1.sAtual+'\inicial\small_22_.bmp')) then
        //ShowMessage('O arquivo \inicial\small_22_.bmp não foi encontrado.');  Mauricio Parizotto 2023-10-25
        MensagemSistema('O arquivo \inicial\small_22_.bmp não foi encontrado.',msgAtencao);

      Form1.Instalarpackcomasltimasalteraes1Click(Instalarpackcomasltimasalteraes1);

      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
    end;

    try
      if StrToInt(Copy(WinVersion,1,3))>=6 then iVista := 5 else iVista := 0;
      StrPCopy(@wndClass[0], 'Shell_TrayWnd');
      wndHandle:=FindWindow(@wndClass[0],nil);
      GetWindowRect(wndHandle,Retangulo);
    except
    end;

    // cópia Automatica
    try
      Mais1ini                     := TIniFile.Create('FRENTE.INI');
      Form1.sModeloDocumentoFiscal := Mais1Ini.ReadString('Frente de caixa'  , 'Modelo do ECF'           ,'01');
      Mais1ini.Free;

      Mais1ini           := TIniFile.Create(sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Outros','CFOP Que Nao Soma Mercadoria','XXXX') = 'XXXX' then Mais1Ini.WriteString('Outros','CFOP Que Nao Soma Mercadoria','(CFOP='+QuotedStr('5124')+' or CFOP='+QuotedStr('6124')+' or CFOP='+QuotedStr('6125')+' or CFOP='+QuotedStr('5125')+')');
      CFOP5124           := Mais1Ini.ReadString('Outros','CFOP Que Nao Soma Mercadoria','');

      //    CFOP5124           := '';
      Form1.fAliqICMdoCliente := Mais1Ini.ReadFloat('Outros','ICMSSTInterno',0);

      CopiaSair          := Mais1Ini.ReadString('Cópia','Sair','9');
      ConfAceitaCGCDuplo := Mais1Ini.ReadString('Outros','Aceita CGC','Não');
      ConfCFOP           := Mais1Ini.ReadString('Outros','CFOP','5102');

      ConfItens      := 16;
      ConfSvc        := 16;

      ConfDupl1      := Mais1Ini.ReadString('Nota Fiscal','Intervalo1','7');
      ConfDupl2      := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','14');
      ConfDupl3      := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','21');
      ConfEspecie    := Mais1Ini.ReadString('Nota Fiscal','Especie','Caixas');
      ConfMarca      := Mais1Ini.ReadString('Nota Fiscal','Marca','Varias');
      SSerieEspecial := Mais1Ini.ReadString('Nota Fiscal','Serie','XXX');
      ConfCusto      := Mais1Ini.ReadString('Permitir','Vendas abaixo do custo','Sim');
      ConfDuplo      := Mais1Ini.ReadString('Permitir','Duplos','Não');
      ConfNegat      := Mais1Ini.ReadString('Permitir','Estoque negativo','Sim');

      ConfFoto    := Mais1Ini.ReadString('Mobile','Fotos','Sim');
      //
      ConfLimite  := StrTofloat(StrTran(StrTran(StrTran(StrTran(Mais1Ini.ReadString('Outros','Teto limite para tributação de IR sobre serviços','R$ 1.000,00'),'R$ ',''),'.',''),'.',''),'.',''));
      ConfIR      := StrTofloat(StrTran(StrTran(StrTran(StrTran(Mais1Ini.ReadString('Outros','Aliquota de IR','1,50 %'),' %',''),'.',''),'.',''),'.',''));

      if ConfItens < 3 then Form1.ConfItens := 3;
      if ConfLimite < 0 then ConfLimite := 10.000;
      fTaxa := StrToFloat(LimpaNumeroDeixandoAVirgula(Mais1Ini.ReadString('Outros','Taxa de juros','0')));

      // Casas Decimais
      ConfPreco := Mais1Ini.ReadString('Outros','Casas decimais no preço','2');
      if ConfPreco = '0' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0';
      if ConfPreco = '1' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0';
      if ConfPreco = '2' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00';
      if ConfPreco = '3' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000';
      if ConfPreco = '4' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0000';
      if ConfPreco = '5' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00000';
      if ConfPreco = '6' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000000';
      if ConfPreco = '7' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0000000';
      if ConfPreco = '8' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00000000';
      if ConfPreco = '9' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000000000';

      ConfCasas      := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
      ConfCasasServ  := Mais1Ini.ReadString('Outros','Casas decimais na quantidade de serviços','0');

      if ConfCasas = '0' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0';
      if ConfCasas = '1' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0';
      if ConfCasas = '2' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00';
      if ConfCasas = '3' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000';
      if ConfCasas = '4' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000';
      if ConfCasas = '5' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00000';
      if ConfCasas = '6' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000000';
      if ConfCasas = '7' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000000';
      if ConfCasas = '8' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00000000';
      if ConfCasas = '9' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000000000';

      Form7.ibDataSet4QTD_ATUAL.EditFormat      := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);
      Form7.ibDataSet4PRECO.EditFormat          := copy(Form7.ibDataSet4PRECO.DisplayFormat,3,10);
      Form7.ibDataSet16QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet16QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      Form7.ibDataSet16UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet16UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet16TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet16TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;

      Form7.ibDataSet4CUSTOCOMPR.DisplayFormat  := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet4CUSTOCOMPR.EditFormat     := Form7.ibDataSet4PRECO.EditFormat;

      Form7.ibDataSet4CUSTOMEDIO.DisplayFormat  := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet4CUSTOMEDIO.EditFormat     := Form7.ibDataSet4PRECO.EditFormat;

      // Compra
      Form7.ibDataSet23QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet23QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      Form7.ibDataSet23UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet23TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;

      Form7.ibDataSet23UNITARIO_O.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23UNITARIO_O.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;

      Form7.ibDataSet23QTD_ORIGINAL.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet23QTD_ORIGINAL.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;

      Form7.ibDataSet28QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet28QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;

      // Servicos OS
      Form7.ibDataSet35UNITARIO.EditFormat := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet35TOTAL.DisplayFormat := Form7.ibDataSet4PRECO.EditFormat;
    except
      MensagemSistema('Para solucionar o problema siga os seguintes passos:'+chr(10)
                      +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista)'
                      +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
                      +chr(10)+'3 - Arquivo "smallcom.inf" pode estar danificado (O arquivo deve ser excluido)'
                      +chr(10)+'4 - Reinstale o programa'
                      ,msgAtencao);

      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
    end;

    FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    if Senha = '' then
    begin
      iSenha := 0;

      while iSenha < 6 do
      begin
        Form22.Close;
        Form22.Show;

        Mensagem22('');

        Senhas.Position := poScreenCenter;
        Senhas.ShowModal;

        if not Form2.bFlag then
          Form1.Ajustararquivos1Click(Sender);

        Audita('ACESSOU','SMALL', Senhas.UsuarioPub,
               'ACESSOU O SISTEMA - BUILD: ' + TRetornarBuildEXE.New
                                                                .Retornar(True),
               0,0); // Ato, Modulo, Usuário, Histórico, Valor

        Senha   := Senhas.SenhaPub;
        Usuario := Senhas.UsuarioPub;

        Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
        Mais1Ini.UpdateFile;
        sSenhaX := Mais1Ini.ReadString(Usuario,'Chave','15706143431572013809150491382314104');

        sSenha := '';
        // ----------------------------- //
        // Fórmula para ler a nova senha //
        // ----------------------------- //
        for I := 1 to (Length(sSenhaX) div 5) do
          sSenha := Chr((StrToInt(
                        Copy(sSenhaX,(I*5)-4,5)
                        )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
        // ----------------------------- //
        if (AnsiUpperCase(sSenha) = AnsiUpperCase(Senha)) then
        begin
          iSenha := 6;
        end else
        begin
          iSenha := iSenha + 1;
        end;
      end;
    end;

    try
      Senha   := Senhas.SenhaPub;
      Usuario := Senhas.UsuarioPub;

      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.UpdateFile;
      sSenhaX := Mais1Ini.ReadString(Usuario,'Chave','15706143431572013809150491382314104');

      sSenha := '';
      // ----------------------------- //
      // Fórmula para ler a nova senha //
      // ----------------------------- //
      for I := 1 to (Length(sSenhaX) div 5) do
        sSenha := Chr((StrToInt(
                      Copy(sSenhaX,(I*5)-4,5)
                      )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
      // ----------------------------- //


      if (AnsiUpperCase(sSenha) = AnsiUpperCase(Senha)) then
      begin
        //
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B3','0'))  > 0 then
        begin
          if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B9','9')) = 9 then
          begin
            Mais1Ini.WriteString(Senhas.UsuarioPub,'B9','1');
          end;
        end;

        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1','0'))   > 0) then imgVendas.Visible   := True else imgVendas.Visible   := False;
        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_E','0')) > 0) then imgCompras.Visible  := True else imgCompras.Visible  := False;
        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_S','0')) > 0) then imgServicos.Visible  := True else imgServicos.Visible  := False;

        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B_','0'))  > 0 then imgOrdemServico.Visible := True else imgOrdemServico.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B2','0'))  > 0 then imgEstoque.Visible  := True else imgEstoque.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B3','0'))  > 0 then imgCliFor.Visible  := True else imgCliFor.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B4','0'))  > 0 then imgContaReceber.Visible  := True else imgContaReceber.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B5','0'))  > 0 then imgCaixa.Visible  := True else imgCaixa.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B6','0'))  > 0 then imgBancos.Visible  := True else imgBancos.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B7','0'))  > 0 then imgConfiguracoes.Visible  := True else imgConfiguracoes.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B8','0'))  > 0 then imgBackup.Visible  := True else imgBackup.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B10','0')) > 0 then imgContaPagar.Visible  := True else imgContaPagar.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B11','0')) > 0 then imgIndicadores.Visible  := True else imgIndicadores.Visible := False;

        // Indicadores
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I01','0')) > 0 then Form5.Panel1.Visible  := True else Form5.Panel1.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I02','0')) > 0 then Form5.Panel2.Visible  := True else Form5.Panel2.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I03','0')) > 0 then Form5.Panel3.Visible  := True else Form5.Panel3.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I04','0')) > 0 then Form5.Panel4.Visible  := True else Form5.Panel4.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I05','0')) > 0 then Form5.Panel5.Visible  := True else Form5.Panel5.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I06','0')) > 0 then Form5.Panel6.Visible  := True else Form5.Panel6.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I07','0')) > 0 then Form5.Panel7.Visible  := True else Form5.Panel7.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I08','0')) > 0 then Form5.Panel8.Visible  := True else Form5.Panel8.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I09','0')) > 0 then Form5.Panel9.Visible  := True else Form5.Panel9.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I10','0')) > 0 then Form5.Panel10.Visible  := True else Form5.Panel10.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I11','0')) > 0 then Form5.Panel11.Visible  := True else Form5.Panel11.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I12','0')) > 0 then Form5.Panel12.Visible  := True else Form5.Panel12.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I13','0')) > 0 then Form5.Panel13.Visible  := True else Form5.Panel13.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I14','0')) > 0 then Form5.Panel14.Visible  := True else Form5.Panel14.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I15','0')) > 0 then Form5.Panel15.Visible  := True else Form5.Panel15.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I16','0')) > 0 then Form5.Panel16.Visible  := True else Form5.Panel16.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I17','0')) > 0 then Form5.Panel17.Visible  := True else Form5.Panel17.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I18','0')) > 0 then Form5.Panel18.Visible  := True else Form5.Panel18.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I19','0')) > 0 then Form5.Panel19.Visible  := True else Form5.Panel19.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I20','0')) > 0 then Form5.Panel20.Visible  := True else Form5.Panel20.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I21','0')) > 0 then Form5.Panel21.Visible  := True else Form5.Panel21.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I22','0')) > 0 then Form5.Panel22.Visible  := True else Form5.Panel22.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I23','0')) > 0 then Form5.Panel23.Visible  := True else Form5.Panel23.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'I24','0')) > 0 then Form5.Panel24.Visible  := True else Form5.Panel24.Visible := False;

        // Ordem de apresentaçao dos indicadores
        Form5.Panel1.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I01ORDEM','0'));
        Form5.Panel2.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I02ORDEM','0'));
        Form5.Panel3.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I03ORDEM','0'));
        Form5.Panel4.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I04ORDEM','0'));
        Form5.Panel5.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I05ORDEM','0'));
        Form5.Panel6.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I06ORDEM','0'));
        Form5.Panel7.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I07ORDEM','0'));
        Form5.Panel8.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I08ORDEM','0'));
        Form5.Panel9.Tag   := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I09ORDEM','0'));
        Form5.Panel10.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I10ORDEM','0'));
        Form5.Panel11.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I11ORDEM','0'));
        Form5.Panel12.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I12ORDEM','0'));
        Form5.Panel13.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I13ORDEM','0'));
        Form5.Panel14.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I14ORDEM','0'));
        Form5.Panel15.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I15ORDEM','0'));
        Form5.Panel16.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I16ORDEM','0'));
        Form5.Panel17.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I17ORDEM','0'));
        Form5.Panel18.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I18ORDEM','0'));
        Form5.Panel19.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I19ORDEM','0'));
        Form5.Panel20.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I20ORDEM','0'));
        Form5.Panel21.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I21ORDEM','0'));
        Form5.Panel22.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I22ORDEM','0'));
        Form5.Panel23.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I23ORDEM','0'));
        Form5.Panel24.Tag  := StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'I24ORDEM','0'));

        // E Importante fazer na ordem certa ai o taborder acerta
        J := 0;

        for I := 23 downto 0 do
        begin
          if Form5.Panel1.Tag  = I then if Form5.Panel1.Visible  then Form5.Panel1.TabOrder  := 0;
          if Form5.Panel2.Tag  = I then if Form5.Panel2.Visible  then Form5.Panel2.TabOrder  := 0;
          if Form5.Panel3.Tag  = I then if Form5.Panel3.Visible  then Form5.Panel3.TabOrder  := 0;
          if Form5.Panel4.Tag  = I then if Form5.Panel4.Visible  then Form5.Panel4.TabOrder  := 0;
          if Form5.Panel5.Tag  = I then if Form5.Panel5.Visible  then Form5.Panel5.TabOrder  := 0;
          if Form5.Panel6.Tag  = I then if Form5.Panel6.Visible  then Form5.Panel6.TabOrder  := 0;
          if Form5.Panel7.Tag  = I then if Form5.Panel7.Visible  then Form5.Panel7.TabOrder  := 0;
          if Form5.Panel8.Tag  = I then if Form5.Panel8.Visible  then Form5.Panel8.TabOrder  := 0;
          if Form5.Panel9.Tag  = I then if Form5.Panel9.Visible  then Form5.Panel9.TabOrder  := 0;
          if Form5.Panel10.Tag = I then if Form5.Panel10.Visible then Form5.Panel10.TabOrder := 0;
          if Form5.Panel11.Tag = I then if Form5.Panel11.Visible then Form5.Panel11.TabOrder := 0;
          if Form5.Panel12.Tag = I then if Form5.Panel12.Visible then Form5.Panel12.TabOrder := 0;
          if Form5.Panel13.Tag = I then if Form5.Panel13.Visible then Form5.Panel13.TabOrder := 0;
          if Form5.Panel14.Tag = I then if Form5.Panel14.Visible then Form5.Panel14.TabOrder := 0;
          if Form5.Panel15.Tag = I then if Form5.Panel15.Visible then Form5.Panel15.TabOrder := 0;
          if Form5.Panel16.Tag = I then if Form5.Panel16.Visible then Form5.Panel16.TabOrder := 0;
          if Form5.Panel17.Tag = I then if Form5.Panel17.Visible then Form5.Panel17.TabOrder := 0;
          if Form5.Panel18.Tag = I then if Form5.Panel18.Visible then Form5.Panel18.TabOrder := 0;
          if Form5.Panel19.Tag = I then if Form5.Panel19.Visible then Form5.Panel19.TabOrder := 0;
          if Form5.Panel20.Tag = I then if Form5.Panel20.Visible then Form5.Panel20.TabOrder := 0;
          if Form5.Panel21.Tag = I then if Form5.Panel21.Visible then Form5.Panel21.TabOrder := 0;
          if Form5.Panel22.Tag = I then if Form5.Panel22.Visible then Form5.Panel22.TabOrder := 0;
          if Form5.Panel23.Tag = I then if Form5.Panel23.Visible then Form5.Panel23.TabOrder := 0;
          if Form5.Panel24.Tag = I then if Form5.Panel24.Visible then Form5.Panel24.TabOrder := 0;
        end;
        // ---------- //
        // Configura //
        // -------- //
        if (not Form1.imgConfiguracoes.Visible) or (Form1.Label207.Tag = 1) then
        begin
          Form1.imgConfiguracoes.OnClick          := Form1.Liberarosmdulosparaesteusurio1Click;
          Form1.Label207.OnClick          := Form1.Liberarosmdulosparaesteusurio1Click;
          Form1.Label_bola_config.OnClick := Form1.imgConfiguracoesClick;
          Form1.Label207.Tag              := 1;
          Form1.imgConfiguracoes.Visible          := True;
        end else
        begin
          Form1.imgConfiguracoes.OnClick          := Form1.imgConfiguracoesClick;
          Form1.Label207.OnClick          := Form1.imgConfiguracoesClick;
          Form1.Label_bola_config.OnClick := Form1.Label_Bola_ConfigClick;
        end;

        Form7.Label208.Caption  := 'Liberar';

        if Pos('Ordem de Serviço',Form22.sTitulo) = 0 then
        begin
          imgOrdemServico.Visible := False;
        end;

        if (sModeloPAF <> '65') and (sModeloPAF <> '01') and (sModeloPAF <> '59') and (sModeloPAF <> '99')  then
        begin
          if (Form7.ibDataSet13ESTADO.AsString = 'TO') then // or (Form7.ibDataSet13ESTADO.AsString = 'SC') then
          begin
            imgOrdemServico.Visible := False; // Sem OS
          end;
        end;

        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1','0'))   > 0  then bNotaVendaLiberada   := True  else bNotaVendaLiberada  := False; // Venda
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_E','0')) > 0  then bNotaCompraLiberada  := True else bNotaCompraLiberada  := False; // compra
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_S','0')) > 0  then bNotaServicoLiberada := True else bNotaServicoLiberada := False; // compra

        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B3','0')) > 0  then bClientesLiberados := True else bClientesLiberados := False; // Clientes
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B9','0')) > 0  then bFornecedoresLiberados := True else bFornecedoresLiberados := False; // Fornecedores

        Form7.Exibir1.Visible := True;
        //2024-01-10 Form7.Mostrartodososclientesefornecedores1.Visible := True;
        Form7.N10.Visible := True;

        Label200.Visible   := False;
        Label201.Visible   := False;
        Label201C.Visible  := False;
        Label201S.Visible  := False;
        Label201_.Visible  := False;
        Label202.Visible   := False;
        Label203.Visible   := False;
        Label204.Visible   := False;
        Label205.Visible   := False;
        Label206.Visible   := False;
        Label207.Visible   := False;
        Label208.Visible   := False;
        Label210.Visible   := False;

        if Form5.Panel1.Visible
        or Form5.Panel2.Visible
        or Form5.Panel3.Visible
        or Form5.Panel4.Visible
        or Form5.Panel5.Visible
        or Form5.Panel6.Visible
        or Form5.Panel7.Visible
        or Form5.Panel8.Visible
        or Form5.Panel9.Visible
        or Form5.Panel10.Visible
        or Form5.Panel11.Visible
        or Form5.Panel12.Visible
        or Form5.Panel13.Visible
        or Form5.Panel14.Visible
        or Form5.Panel15.Visible
        or Form5.Panel16.Visible then Form5.Tag := 1 else Form5.Tag := 0;

        if not Form1.bNotaVendaLiberada then
        begin
          Form7.Gerarnotafiscalsrie11.Enabled := False;
          Form7.Gerarnotafiscalsrie21.Enabled := False;
        end else
        begin
          Form7.Gerarnotafiscalsrie11.Enabled := True;
          Form7.Gerarnotafiscalsrie21.Enabled := True;
        end;
      end else
      begin
        if Senha = '#####' then
        begin
          // Form1.DestroyWindowHandle;
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
        end else
        begin
          { Quando a senha não é válida }
          //
          Audita('SENHA','SMALL', Senhas.UsuarioPub,'SENHA INVÁLIDA: '+Senha,0,0); // Ato, Modulo, Usuário, Histórico, Valor

          Form1.ShowHint := True;
          Form1.Hint := chr(10)+
                         ' '+Usuario+chr(10)+chr(10)+
                         ' Sua senha não é válida, portanto os' + chr(10)+
                         ' módulos não podem ser liberados.'+ chr(10)+
                         ' Entre novamente no programa digitando '+ chr(10)+
                         ' a sua senha correta.'+ chr(10);

          MensagemSistema(' '+Usuario+chr(10)+chr(10)+
                          ' Sua senha não é válida, portanto os' + chr(10)+
                          ' módulos não podem ser liberados.'+ chr(10)+
                          ' Entre novamente no programa digitando'+ chr(10)+
                          ' a sua senha correta.'+ chr(10)
                          ,msgAtencao);

          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
          Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
          Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
        end;
      end;

      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.WriteString(AllTrim(Usuario),'Ativo','Sim');
      Mais1Ini.UpdateFile;
      Mais1Ini.Free;
    except
      MensagemSistema('Para solucionar o problema siga os seguintes passos:'+chr(10)
                      +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista)'
                      +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
                      +chr(10)+'3 - Arquivo EST0QUE.DAT pode estar danificado (O arquivo deve ser excluido)'
                      +chr(10)+'4 - Reinstale o programa'
                      ,msgAtencao);

      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
    end;

    try
      //Mauricio Parizotto 2024-02-22
      CarregaConfiguracoes;
      ConfiguraNFE;
    except
    end;

    //Verifica Certificado Digital Mauricio Parizotto 2024-07-05
    if bPrimeiraAberturaDia then
      VencimentoCertificadoDigital;

    MontaTela(True);

    Form8.Width          := 310;
    Form8.Top            := Form1.Top + Form1.Height + 1 + (iVista*2);
    Form8.Left           := Screen.Width - 310 - (iVista);
    Form8.Height         := 120;

    // Para atender o PAF
    if ParamCount > 0 then
    begin
      if AllTrim(Copy(UpperCase(ParamStr(1)),1,3)) = 'URB' then
      begin
        Form1.imgVendasClick(Form1.imgVendas);
        Form7.Image101Click(Form7.imgNovo);
      end;
    end;

    if (Copy(Form7.ibDataSet13CNAE.AsString,1,2) = '56') or // Restaurantes e similares
       (Form7.ibDataSet13CNAE.AsString = '4721101') or      // Padarias
       (Form7.ibDataSet13CNAE.AsString = '4721102') then
    begin
      Form7.ibDataSet4OBS.DisplayLabel := 'Receita';
      Form7.Cardpio1.Visible           := True;
      Form7.Livrodereceitas1.Visible   := True;
    end else
    begin
      //Form7.ibDataSet4OBS.DisplayLabel    := 'Aplicação';
      Form7.ibDataSet4OBS.DisplayLabel    := 'Observação';
      Form7.Cardpio1.Visible              := False;
      Form7.Livrodereceitas1.Visible      := True;
      Form7.Livrodereceitas1.Caption      := 'Relatório de composição';
    end;

    // LEGAL
    try
      if Form7.ibDataSet39.Active then
      begin
        if FileExists(Form1.sAtual+'\leia-me.txt') then
        begin
          RegistrodoPrograma(InfTermo);
          ValidaRazaoSmall; // Corrige o nome da small no arquio arquivoauxiliarcriptografadopafecfsmallsoft.ini de LTDA para EIRELI
        end;
      end;
    except end;

    // LEGAL
    try
      if Form7.ibDataSet39.Active then
      begin
        // Verificar se é mei aqui
        begin
          RegistrodoPrograma(InfTermo);
        end;
      end;
    except end;

    // NF-e
    if imgVendas.Visible  then
    begin
      if not form2.Visible then
      begin
        ConfiguraNFE;

        if Form1.bConsultarNFesEmitidas then
        begin
          if Form1.ValidaRecursos.PermiteRecursoParaProduto then // Sandro Silva 2023-05-31
          begin
            //Mensagem22('Consultando NF-e´s emitidas para o CNPJ: '+Form7.ibDataSet13CGC.AsString); Mauricio Parizotto 2023-07-12
            Mensagem22('Consultando NF-e´s emitidas para o CNPJ: '+Form7.ibDataSet13CGC.AsString+
                       Form7.GetMensagemCertificado('ABERTURA'));

            Form7.ConsultarNFesemitidasparameuCNPJ1Click(Form7.MenuItem1);
            AvisoNFECompra(True);
            Sleep(1000*2);
            Mensagem22('');
          end;
        end;
      end;
    end;

    // OS
    if imgOrdemServico.Visible  then
    begin
      Mensagem22('Consultando OS agendadas para hoje');
      AvisoOS(True);
      Mensagem22('');
    end;

    // CLIFOR
    if imgCliFor.Visible  then
    begin
      Mensagem22('Consultando agendamentos no cadastro');
      AvisoClifor(True);
      Mensagem22('');
    end;

    // CAIXA
    if imgCaixa.Visible  then
    begin
      Mensagem22('Consultando pendências no caixa');
      AvisoCaixa(True);
      Mensagem22('');
    end;

    // BANCO
    if imgBancos.Visible  then
    begin
      Mensagem22('Consultando pendências no banco');
      AvisoBanco(True);
      Mensagem22('');
    end;

    // Receber
    if imgContaReceber.Visible  then
    begin
      Mensagem22('Consultando contas a receber para hoje');
      AvisoReceber(True);
      Mensagem22('');
    end;

    // Estoque
    if imgEstoque.Visible  then
    begin
      Mensagem22('Consultando produtos com quantidade minima no estoque');
      AvisoEstoque(True);
      Mensagem22('');
    end;

    // PAGAR
    if imgContaPagar.Visible  then
    begin
      Mensagem22('Consultando contas a pagar para hoje');
      AvisoPagar(True);
      Mensagem22('');
    end;

    // INDICADORES
    if imgIndicadores.Visible  then
    begin
      Mensagem22('Consultando indicadores');
      AvisoIndicadores(True);
      Mensagem22('');
    end;

    // CONFIG
    if imgContaPagar.Visible  then
    begin
      Mensagem22('Consultando suas configurações');
      AvisoConfig(True);
      Mensagem22('');
    end;

    if Form7.ibDataSet4.Tag = IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO then // Sandro Silva 2022-09-12 if Form7.ibDataSet4.Tag = 999 then
    begin
      Form7.ibDataset4.Close;
      Form7.ibDataset4.SelectSql.Clear;
      Form7.ibDataset4.SelectSql.Add('select * from ESTOQUE');
      Form7.ibDataset4.Open;

      Form7.ibDataSet4.DisableControls;

      while not Form7.ibDataset4.Eof do
      begin
        for I := 1 to 30 do
        begin
          if pos('<',Form7.ibDataset4OBS.AsString) <> 0 then
          begin
            try
              sTag   := Copy(Form7.ibDataset4OBS.AsString,(pos('<',Form7.ibDataset4OBS.AsString)+1), (pos('>',Form7.ibDataset4OBS.AsString)-(pos('<',Form7.ibDataset4OBS.AsString)+1)));
              sValor := Copy(Form7.ibDataset4OBS.AsString,Pos('<' + sTag + '>', Form7.ibDataset4OBS.AsString) + Length('<' + sTag + '>'),(Pos('</', Form7.ibDataset4OBS.AsString)-(Pos('<' + sTag + '>', Form7.ibDataset4OBS.AsString)+Length('<' + sTag + '>'))));
              Form7.ibDataset4.Edit;
              Form7.ibDataset4TAGS_.AsString := Form7.ibDataset4TAGS_.AsString + '<' + sTag + '>' + sValor +  '</' + sTag + '>' + chr(10);
              Form7.ibDataset4OBS.AsString := StrTran(Form7.ibDataset4OBS.AsString,('<' + sTag + '>' + sValor +  '</' + sTag + '>'),'');
              Form7.ibDataset4.Post;
            except end;
          end;
        end;

        {Sandro Silva 2023-11-20 inicio
        // cProdANP
        if (Length(LimpaNumero(Form7.ibDataset4LIVRE1.AsString)) = 9) and (Length(AllTrim(Form7.ibDataset4LIVRE1.AsString)) = 9) then
        begin
          try
            Form7.ibDataset4.Edit;
            Form7.ibDataset4TAGS_.AsString := Form7.ibDataset4TAGS_.AsString + '<cProdANP>' + Form7.ibDataset4LIVRE1.AsString +  '</cProdANP>' + chr(10);
            Form7.ibDataSet4LIVRE1.AsString := '';
            Form7.ibDataset4.Post;
          except end;
        end;
        }

        // vUnid
        if (Copy(Form7.ibDataSet4LIVRE3.AsString,1,7) = '<vUnid=') then // Pereti trib ipi por valor unitário engarafados bebidas
        begin
          try
            Form7.ibDataset4.Edit;
            Form7.ibDataset4TAGS_.AsString  := Form7.ibDataset4TAGS_.AsString + '<vUnid>' + LimpaNumeroDeixandoAvirgula(Form7.ibDataSet4LIVRE3.AsString) +  '</vUnid>' + chr(10);
            Form7.ibDataSet4LIVRE3.AsString := '';
            Form7.ibDataset4.Post;
          except end;
        end;

        if Pos('VAL',Form7.ibDataSet4OBS.AsString) <> 0 then
        begin
          if LimpaNumero(Copy(Form7.ibDataSet4OBS.AsString,Pos('VAL',Form7.ibDataSet4OBS.AsString)+3,3)) <> '' then
          begin
            try
              Form7.ibDataset4.Edit;
              Form7.ibDataset4TAGS_.AsString  := Form7.ibDataset4TAGS_.AsString + '<VAL>' + Copy(Form7.ibDataSet4OBS.AsString,Pos('VAL',Form7.ibDataSet4OBS.AsString)+3,3) +  '</VAL>' + chr(10);
              Form7.ibDataSet4OBS.AsString    := sTrTran(Form7.ibDataSet4OBS.AsString,'VAL'+Copy(Form7.ibDataSet4OBS.AsString,Pos('VAL',Form7.ibDataSet4OBS.AsString)+3,3),'');
              Form7.ibDataset4.Post;
            except end;
          end;
        end;

        Form7.ibDataset4.Next;
      end;

      Form7.ibDataSet4.EnableControls;
    end;

    Screen.Cursor := crDefault; // Cursor
    Form22.Close;
  except
  end;

  if Form1.Tag = 99 then
  begin
    Form7.EnvioaoFISCOREDUOZ1Click(Sender);
    Form1.Tag := 0;
  end;

  frmConfiguracaoTEFCommerce := TfrmConfiguracaoTEFCommerce.Create(nil);
  try
    frmConfiguracaoTEFCommerce.IBDataBase := Form7.IBDatabase1;
    // No Create vai atualizar TEM TEF
    frmConfiguracaoTEFCommerce.AtualizaTEMTEF;
  finally
    FreeAndNil(frmConfiguracaoTEFCommerce);
  end;
end;

procedure TForm1.DBGrid200KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_sql.htm')));

  if KEY = VK_RETURN then
  begin
   I := DbGrid200.SelectedIndex;
   DbGrid200.SelectedIndex := DbGrid200.SelectedIndex  + 1;
   if I = DbGrid200.SelectedIndex then
   begin
     DbGrid200.SelectedIndex := 0;
     ibDAtaSet200.Next;
   end;
  end;

  if Key = VK_ESCAPE then
  begin
    ibDataSet200.Close;
    dbGrid200.Visible := False;
    Edit200.Visible   := False;

    Commitatudo(True); // SQL - Commando
    AbreArquivos(False);

    MontaTela(True);
  end;

  Screen.Cursor := crDefault;
end;

procedure TForm1.SelecionarCertificadoDigital1Click(Sender: TObject);
var
  Mais1ini: TIniFile;
  sCertificado: String;
begin
  Form7.CriarComponenteNFeRunTime; //Sandro Silva 2024-04-08

  Form1.ConfiguraCredencialTecnospeed;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
  Mais1ini.Free;

  Form7.spdNFe.ListarCertificados(frmSelectCertificate.lbList.Items);
  Application.ProcessMessages; //Mauricio Parizotto 2023-06-13 - Para tela não abrir por trás
  frmSelectCertificate.ShowModal;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
  Mais1ini.Free;

  if AllTrim(sCertificado) = '' then
  begin
    if Application.MessageBox(Pchar('Para emitir Documentos Fiscais é necessário instalar um'+#13+
                                    'Certificado Digital.'+#13+#13+
                                    'Continuar sem instalar o Certificado Digital não é'+#13+
                                    'recomendável.'+#13+#13+
                                    'Continuar sem certificado digital?')
                                    ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING) <> IDYES then
    begin
      //Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      //Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName));
    end;
  end;
end;

procedure TForm1.estarservidorNFE1Click(Sender: TObject);
begin
  Form7.N0TestarservidorNFe1Click(Sender);
end;

procedure TForm1.ConfigurarlogotipodoDANFE1Click(Sender: TObject);
begin
  Form12.imgLogoNFeClick(Sender);
end;

procedure TForm1.ConfigurarServidoresHomologao1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open',Pchar(sAtual+'\NFE\nfeServidoresHom.ini'),'', '', SW_SHOW);
end;

procedure TForm1.ConfigurarServidoresProduo1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open',Pchar(sAtual+'\NFE\nfeServidoresProd.ini'),'', '', SW_SHOW);
end;

procedure TForm1.ConfigurarNFEINI1Click(Sender: TObject);
var
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  Mais1Ini : tIniFile;
begin
  Form22.Show;
  Mensagem22('');
  Senhas2.ShowModal;
  Form22.Close;
  Senha2:=Senhas2.SenhaPub2;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  sSenha := '';
  // ----------------------------- //
  // Fórmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //
  if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    //
    if Alltrim(Mais1Ini.ReadString('NFE','Certificado',''))                 = '' then
      Mais1Ini.WriteString('NFE','Certificado','');
    if Alltrim(Mais1Ini.ReadString('NFE','Ambiente',''))                    = '' then
      DefineAmbienteNFe(_cAmbienteHomologacao, 'Mais.ConfigurarNFEINI1Click');
    if Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','XXXXX'))     = 'XXXXX' then
      Mais1Ini.WriteString('DANFE','Formato do DANFE','Retrato');
    if Alltrim(Mais1Ini.ReadString('XML','Pasta da contabilidade','XXXXX')) = 'XXXXX' then
      Mais1Ini.WriteString('XML','Pasta da contabilidade','');

    Mais1ini.Free;
    ShellExecute( 0, 'Open',Pchar(sAtual+'\nfe.ini'),'', '', SW_SHOW);
  end else
    //ShowMessage('Senha do administrador inválida.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Senha do administrador inválida.');
end;

{Dailon Parisotto (f-7540) 2023-11-06 inicio

procedure TForm1.InutilizarNFe1Click(Sender: TObject);
var
  sID, sRetorno, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa: string;
begin
  ConfiguraNFE;

  aAno := Small_InputForm('NFe', 'Insira o ano da NF-e a ser inutilizada', '');

  if aAno <> '' then
  begin
    aModelo := Small_InputForm('NFe', 'Insira o modelo da NF-e a ser inutilizada', '');
    if aModelo <> '' then
    begin
      aSerie := Small_InputForm('NFe', 'Insira a série da NF-e a ser inutilizada', '');
      if aSerie <> '' then
      begin
        aIni := Small_InputForm('NFe', 'Insira o número da NF-e inicial a ser inutilizada', '');
        if aIni <> '' then
        begin
          aFim := Small_InputForm('NFe', 'Insira o número da NF-e final a ser inutilizada', '');
          if aFim <> '' then
          begin
            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet13MUNICIPIO.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+' ');
            Form7.ibDataset99.Open;
            //
            sID := Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,2) + LimpaNumero(Form7.ibDAtaSet13CGC.AsString) + aModelo + StrZero(StrToInt(aSerie),3,0) + StrZero(StrToInt(aIni),9,0) + StrZero(StrToInt(aFim),9,0);
            //
            txtJustificativa := ConverteAcentos(Small_InputForm('NF-e', 'Insira a justificativa (min. 15 caracteres)', 'Exemplo de inutilizacao da NF-e'));

            try
              Screen.Cursor := crHourGlass; // Cursor de Aguardo

              Form7.ibDataset15.Locate('NFEID','55',[loPartialKey]);

              sRetorno := Form7.spdNFe.InutilizarNF('',aAno, LimpaNumero(Form7.ibDataSet13CGC.AsString), aModelo, aSerie, aIni, aFim, txtJustificativa);
              Screen.Cursor := crDefault;

              if GravarInutilizacao(sRetorno, Form1.ibQuery2) then
              begin
                sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
                //ShowMessage(sRetorno); Mauricio Parizotto 2023-10-25
                MensagemSistema(sRetorno);
              end else
              begin
                sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
                //ShowMessage('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno); Mauricio Parizotto 2023-10-25
                MensagemSistema('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno,msgAtencao);
              end;
            except
              sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
              //ShowMessage('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno); Mauricio Parizotto 2023-10-25
              MensagemSistema('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno,msgAtencao);
            end;
                                        }
//            {$IFDEF VER150}
//            DecimalSeparator := ',';
//            DateSeparator    := '/';
//            {$ELSE}
//            FormatSettings.DecimalSeparator := ',';
//            FormatSettings.DateSeparator    := '/';
//            {$ENDIF}
{          end;
        end;
      end;
    end;
  end;
  Screen.Cursor            := crDefault;
end;                                       }

procedure TForm1.InutilizarNFe1Click(Sender: TObject);
var
  nLengthEdit1, nLengthEdit2, nLengthEdit3,
  nLengthEdit4, nLengthEdit5 : Integer;
  cRetorno: String;
begin
  nLengthEdit1 := Form29.Edit_01.MaxLength;
  nLengthEdit2 := Form29.Edit_02.MaxLength;
  nLengthEdit3 := Form29.Edit_03.MaxLength;
  nLengthEdit4 := Form29.Edit_04.MaxLength;
  nLengthEdit5 := Form29.Edit_05.MaxLength;
  try
    Form29.Label_01.Visible := True;
    Form29.Label_02.Visible := True;
    Form29.Label_03.Visible := True;
    Form29.Label_04.Visible := True;
    Form29.Label_05.Visible := True;
    Form29.btnCancelar.Visible := True;

    Form29.Edit_01.MaxLength := 4;
    Form29.Edit_02.MaxLength := 3;
    Form29.Edit_03.MaxLength := 9;
    Form29.Edit_04.MaxLength := 9;
    Form29.Edit_05.MaxLength := 0;

    Form29.Edit_01.Visible := True;
    Form29.Edit_01.OnKeyPress := Form29.SomenteNumerosKeyPress;
    Form29.Edit_01.OnChange   := Form29.SomenteNumerosChange;
    Form29.Edit_02.Visible := True;
    Form29.Edit_02.OnKeyPress := Form29.SomenteNumerosKeyPress;
    Form29.Edit_02.OnChange   := Form29.SomenteNumerosChange;
    Form29.Edit_03.Visible := True;
    Form29.Edit_03.OnKeyPress := Form29.SomenteNumerosKeyPress;
    Form29.Edit_03.OnChange   := Form29.SomenteNumerosChange;
    Form29.Edit_04.Visible := True;
    Form29.Edit_04.OnKeyPress := Form29.SomenteNumerosKeyPress;
    Form29.Edit_04.OnChange   := Form29.SomenteNumerosChange;
    Form29.Edit_05.Visible := True;

    Form29.Label_01.Caption := 'Insira o ano da nota a ser inutilizada:';
    Form29.Label_02.Caption := 'Insira a série da nota a ser inutilizada:';
    Form29.Label_03.Caption := 'Insira o número da nota inicial a ser inutilizada:';
    Form29.Label_04.Caption := 'Insira o número da nota final a ser inutilizada:';
    Form29.Label_05.Caption := 'Insira a justificativa com no mínimo 15 caracteres:';

    Form29.Edit_01.Text := EmptyStr;
    Form29.Edit_02.Text := EmptyStr;
    Form29.Edit_03.Text := EmptyStr;
    Form29.Edit_04.Text := EmptyStr;
    Form29.Edit_05.Text := 'Exemplo de inutilizacao da NF-e';

    Form29.btnOK.OnClick := ClickOKInformacoesInutilizacao;

    if not Form1.Small_InputForm_Dados('Inutilização de NF-e') then
      Exit;

    Screen.Cursor := crHourGlass;
    try
      Form29.Edit_01.Text := Copy(Form29.Edit_01.Text, Length(Form29.Edit_01.Text)-1, 2);

      if StrToIntDef(Form29.Edit_02.Text,0) > 0 then
        Form29.Edit_02.Text := IntToStr(StrToIntDef(Form29.Edit_02.Text,0));

      if StrToIntDef(Form29.Edit_03.Text,0) > 0 then
        Form29.Edit_03.Text := IntToStr(StrToIntDef(Form29.Edit_03.Text,0));
      if StrToIntDef(Form29.Edit_04.Text,0) > 0 then
        Form29.Edit_04.Text := IntToStr(StrToIntDef(Form29.Edit_04.Text,0));

      Form29.Edit_05.Text := ConverteAcentos(Form29.Edit_05.Text);

      if Application.MessageBox(Pchar('Será inutilizada da numeração ' + Form29.Edit_03.Text + ' à ' + Form29.Edit_04.Text + ' da série ' + Form29.Edit_02.Text + '.'), Pchar(_cTituloMsg), MB_OKCANCEL + MB_ICONWARNING) = mrCancel then
        Exit;

      ConfiguraNFE;

      try
        Form7.ibDataset15.Locate('NFEID','55',[loPartialKey]);

        cRetorno := Form7.spdNFe.InutilizarNF(EmptyStr, Form29.Edit_01.Text,
                                              LimpaNumero(Form7.ibDataSet13CGC.AsString), '55',
                                              Form29.Edit_02.Text, Form29.Edit_03.Text,
                                              Form29.Edit_04.Text, Form29.Edit_05.Text
                                             );

        if GravarInutilizacao(cRetorno, Form1.ibQuery2) then
        begin
          cRetorno := Copy(cRetorno+'   ',Pos('<xMotivo>',cRetorno)+9,Pos('</xMotivo>',cRetorno)-Pos('<xMotivo>',cRetorno)-9);
          MensagemSistema(cRetorno);
        end else
        begin
          cRetorno := Copy(cRetorno+'   ',Pos('<xMotivo>',cRetorno)+9,Pos('</xMotivo>',cRetorno)-Pos('<xMotivo>',cRetorno)-9);
          MensagemSistema('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+cRetorno,msgAtencao);
        end;
      except
        cRetorno := Copy(cRetorno+'   ',Pos('<xMotivo>',cRetorno)+9,Pos('</xMotivo>',cRetorno)-Pos('<xMotivo>',cRetorno)-9);
        MensagemSistema('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+cRetorno,msgAtencao);
      end;

      {$IFDEF VER150}
      DecimalSeparator := ',';
      DateSeparator    := '/';
      {$ELSE}
      FormatSettings.DecimalSeparator := ',';
      FormatSettings.DateSeparator    := '/';
      {$ENDIF}
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    Form29.Edit_01.OnKeyPress := nil;
    Form29.Edit_01.OnChange   := nil;
    Form29.Edit_02.OnKeyPress := nil;
    Form29.Edit_02.OnChange   := nil;
    Form29.Edit_03.OnKeyPress := nil;
    Form29.Edit_03.OnChange   := nil;
    Form29.Edit_04.OnKeyPress := nil;
    Form29.Edit_04.OnChange   := nil;

    Form29.Edit_01.Text := EmptyStr;
    Form29.Edit_02.Text := EmptyStr;
    Form29.Edit_03.Text := EmptyStr;
    Form29.Edit_04.Text := EmptyStr;
    Form29.Edit_05.Text := EmptyStr;

    Form29.Edit_01.MaxLength := nLengthEdit1;
    Form29.Edit_02.MaxLength := nLengthEdit2;
    Form29.Edit_03.MaxLength := nLengthEdit3;
    Form29.Edit_04.MaxLength := nLengthEdit4;
    Form29.btnCancelar.Visible := False;
    Form29.btnOK.OnClick := Form29.btnOKClick;
  end;
end;

procedure TForm1.Clculododescontopeloprovedor1Click(Sender: TObject); // Sandro Silva 2024-04-23
var
  ConfSistema: TArquivosDAT;
  IBTransaction: TIBTransaction;
begin
  try
    IBTransaction := CriaIBTransaction(Form7.ibDataSet13.Transaction.DefaultDatabase);
    ConfSistema := TArquivosDAT.Create(Usuario, IBTransaction);
    try
      ConfSistema.BD.NFSE.CalculoDoDescontoPeloProvedor := IfThen(Clculododescontopeloprovedor1.Checked, 'Não', 'Sim');
      IBTransaction.Commit;
      Clculododescontopeloprovedor1.Checked := ConfSistema.BD.NFSE.CalculoDoDescontoPeloProvedor = 'Sim'; // Sandro Silva 2024-04-24
    except
      on E: Exception do
      begin
        IBTransaction.Rollback;
        MensagemSistema('Não foi possível configurar', msgAtencao);
      end;
    end;
  finally
    FreeAndNil(ConfSistema);
    FreeAndNil(IBTransaction);
  end;
  {Sandro Silva 2024-04-23 inicio}
  // Precisa para atualizar a conexão
  Commitatudo(True);
  AbreArquivos(False);
  {Sandro Silva 2024-04-23 fim}
end;

procedure TForm1.ClickOKInformacoesInutilizacao(Sender: TObject);
begin
  if StrToIntDef(Form29.Edit_01.Text,0) = 0 then
  begin
    MensagemSistema('Informe o ano da nota.', msgAtencao);
    Form29.Edit_01.SetFocus;
    Exit;
  end;
  if (Length(Form29.Edit_01.Text) <= 1) then
  begin
    MensagemSistema('O ano informado é inválido.', msgAtencao);
    Form29.Edit_01.SetFocus;
    Exit;
  end;
  if StrToIntDef(Form29.Edit_02.Text,0) = 0 then
  begin
    MensagemSistema('Informe a série da nota.', msgAtencao);
    Form29.Edit_02.SetFocus;
    Exit;
  end;
  if StrToIntDef(Form29.Edit_03.Text,0) = 0 then
  begin
    MensagemSistema('Informe o número da nota inicial.', msgAtencao);
    Form29.Edit_03.SetFocus;
    Exit;
  end;
  if StrToIntDef(Form29.Edit_04.Text,0) = 0 then
  begin
    MensagemSistema('Informe o número da nota final.', msgAtencao);
    Form29.Edit_04.SetFocus;
    Exit;
  end;
  if Trim(Form29.Edit_05.Text) = EmptyStr then
  begin
    MensagemSistema('Informe a justificativa.', msgAtencao);
    Form29.Edit_05.SetFocus;
    Exit;
  end;
  if Length(Trim(Form29.Edit_05.Text)) < 15 then
  begin
    MensagemSistema('Informe pelo menos 15 caracteres na justificativa.', msgAtencao);
    Form29.Edit_05.SetFocus;
    Exit;
  end;

  Form29.btnOKClick(Form29);
end;
{Dailon Parisotto (f-7540) 2023-11-06 fim}

procedure TForm1.estarDisponibilidadedeServiosdasSecretariasdeFazenda1Click(
  Sender: TObject);
var
  Mais1ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  if (Mais1Ini.ReadString('NFE','Ambiente',_cAmbienteHomologacao) <> _cAmbienteProducao) then
  begin
    ShellExecute( 0, 'Open', 'http://hom.nfe.fazenda.gov.br/PORTAL/disponibilidade.aspx?versao=0.00&tipoConteudo=Skeuqr8PQBY=','', '', SW_SHOW);
  end else
  begin
    ShellExecute( 0, 'Open', 'http://www.nfe.fazenda.gov.br/portal/disponibilidade.aspx','', '', SW_SHOW);
  end;

  Mais1ini.Free;
end;


procedure TForm1.Verificarcadastro1Click(Sender: TObject);
begin
  Form7.XConsultarcadastro1Click(Sender);
end;

procedure TForm1.SincronizarSmallMobile1Click(Sender: TObject);
var
 bButton : Integer;
 Mais1Ini : tIniFile;
begin
  Timer2.Enabled := False;
  begin
    bButton := Application.MessageBox(Pchar(
    'A tecnologia de acesso móvel “Small Mobile” é protegida'+chr(10)+'pela senha de cada usuário do sistema.'+chr(10)+chr(10)+

    'Para evitar acessos indevidos aos dados da sua empresa certifique-se de que as senhas de acesso '+
    'e os módulos liberados para seus usuários estão seguras.'+chr(10)+chr(10)+

    'Clicando no botão <Sim> os usuários poderão acessar em www.smallmobile.com.br através de suas '+
    'senhas alguns módulos liberados independente de sistema operacional em qualquer lugar, '+
    'inclusive no seu Smart Phone ou outro dispositivo para internet.'+
    Chr(10) +
    Chr(10) +
    'Continuar?' +
    Chr(10))
    ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
    //
    if bButton = IDYES then
    begin
      if not AutoSmallMobile1.Checked then
      begin
        try
          AutoSmallMobile1.Checked := True;
          Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
          Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Sim');
          Form1.Timer2.Enabled := True;
          Mais1Ini.Free;
        except end;
      end;

      bButton := Application.MessageBox(Pchar(
      'É necessário atualizar as fotos dos produtos?')
      ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

      Form1.Label200.Tag    := 1;
      Form1.Repaint;
      Screen.Cursor := crAppStart; // Cursor de Aguardo

      if bButton = IDYES then
      begin
        AtualizaMobile(True);
      end else
      begin
        AtualizaMobile(False);
      end;

      Form1.Label200.Tag    := 0;
      Screen.Cursor := crDefault; // Cursor de Aguardo
    end;
  end;

  Timer2.Enabled := True;
end;

procedure TForm1.SCANSistemadeContingnciadoAmbienteNacional1Click(
  Sender: TObject);
begin
  if bModoScan then bModoScan := False else bModoScan := True;
  if bModoScan then SCANSistemadeContingnciadoAmbienteNacional1.Checked := True else SCANSistemadeContingnciadoAmbienteNacional1.Checked := False;
end;

procedure TForm1.DownloadSmallMobile1Click(Sender: TObject);
var
  sTLista,sTSessions : TStringList;
  sCnpj,sDirAtual,sCONTATOS:String;
  I,J,iRegistro,iPedido : Integer;
  ArqIni : TIniFile;
begin
  // Pega o Diretório Atual
  sTLista := TStringList.Create();
  sTLista.Clear;
  sTSessions := TStringList.Create();
  sTSessions.Clear;
  //
  try
    GetDir(0,sDirAtual);
    // Cria a String List e limpa
    try
      // Cnpj do Emitente somente os números
      sCnpj:= LimpaNumero(Form7.ibDataSet13.fieldByName('CGC').AsString);
      //
      // Conecta ao FTP
      Form7.LbBlowfish1.GenerateKey(sPasta);
      //
      DownloadMobile(sCNPJ, '*.ped', sTLista);
      //
      // Repassa todos os arquivos .PED
      for I := 0 to sTLista.Count -1 do
      begin
        //
        Screen.Cursor             := crAppStart;                   // Cursor de Aguardo
        Application.ProcessMessages;
        //
        // Ao Concluir o download abre o arquivo e le como se fosse um ini
        ArqIni := TIniFile.Create(sTLista[I]); //abre
        ArqIni.ReadSections(sTSessions); //conta o número de itens
        //
        // Generator PEDIDO
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSql.Clear;
        Form1.ibDataset200.SelectSql.Add('select gen_id(G_ORCAMENTO,1) from rdb$database');
        Form1.ibDataset200.Open;
        //
        iPedido := StrtoInt('0'+Form1.IBDataSet200.fieldByname('GEN_ID').AsString);
        //
        // le os itens do ORCAMENTO
        for J := 0 to sTSessions.Count-1 do
        begin
          // Generator REGISTRO
          Form1.ibDataSet200.Close;
          Form1.ibDataSet200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('select gen_id(G_ORCAMENT,1) from rdb$database');
          Form1.ibDataset200.Open;
          //
          iRegistro := StrtoInt('0'+Form1.IBDataSet200.fieldByname('GEN_ID').AsString);
          //
          // Salva o orçamento

          IBQuery1.Close;
          IBQuery1.SQL.Clear;
          IBQuery1.SQL.Add('insert into ORCAMENT ('
          +' CODIGO'
          +',DESCRICAO'
          +',QUANTIDADE'
          +',MEDIDA'
          +',UNITARIO'
          +',TOTAL'
          +',DATA'
          +',TIPO'
          +',PEDIDO'
          +',ITEM'
          +',CLIFOR'
          +',VENDEDOR'
          +',REGISTRO'
          +') values ('
          +' :CODIGO'
          +',:DESCRICAO'
          +',:QUANTIDADE'
          +',:MEDIDA'
          +',:UNITARIO'
          +',:TOTAL'
          +',:DATA'
          +',:TIPO'
          +',:PEDIDO'
          +',:ITEM'
          +',:CLIFOR'
          +',:VENDEDOR'
          +',:REGISTRO'
          +')'
          );
          //
          Form7.ibQuery1.Close;
          Form7.ibQuery1.Sql.Clear;
          Form7.ibQuery1.Sql.Add('select DESCRICAO from ESTOQUE where CODIGO='+QuotedStr(ArqIni.ReadString(sTSessions[J],'CODIGO','')));
          Form7.ibQuery1.Open;
          //
          Form7.ibQuery2.Close;
          Form7.ibQuery2.Sql.Clear;
          Form7.ibQuery2.Sql.Add('select NOME from CLIFOR where CGC='+QuotedStr(FormataCpfCgc(ArqIni.ReadString(sTSessions[J],'CNPJ',''))));
          Form7.ibQuery2.Open;

          IBQuery1.Prepare;
          IBQuery1.ParamByName('CODIGO').AsString     := ArqIni.ReadString(sTSessions[J],'CODIGO','');

          if AllTrim(Form7.IBQuery1.FieldByname('DESCRICAO').AsString) <> '' then
          begin
            IBQuery1.ParamByName('DESCRICAO').AsString  := Form7.IBQuery1.FieldByname('DESCRICAO').AsString;
            IBQuery1.ParamByName('QUANTIDADE').AsString := ArqIni.ReadString(sTSessions[J],'QUANTIDADE','');
            IBQuery1.ParamByName('MEDIDA').AsString     := ArqIni.ReadString(sTSessions[J],'MEDIDA','');
            IBQuery1.ParamByName('UNITARIO').AsString   := ArqIni.ReadString(sTSessions[J],'UNITARIO','');
            IBQuery1.ParamByName('TOTAL').AsString      := ArqIni.ReadString(sTSessions[J],'TOTAL','');
          end else
          begin
            IBQuery1.ParamByName('DESCRICAO').AsString  := ArqIni.ReadString(sTSessions[J],'DESCRICAO','');
          end;

          IBQuery1.ParamByName('DATA').AsString       := ArqIni.ReadString(sTSessions[0],'DATA','');
          IBQuery1.ParamByName('TIPO').AsString       := 'ORCAME';
          IBQuery1.ParamByName('PEDIDO').AsString     := StrZero(iPedido,10,0);
          IBQuery1.ParamByName('ITEM').AsString       := StrZero(ArqIni.ReadInteger(sTSessions[0],'ITEM',0),3,0);
          IBQuery1.ParamByName('CLIFOR').AsString     := Form7.IBQuery2.FieldByname('NOME').AsString;
          IBQuery1.ParamByName('VENDEDOR').AsString   := ArqIni.ReadString(sTSessions[0],'VENDEDOR','');
          IBQuery1.ParamByName('REGISTRO').AsString   := StrZero(iRegistro,10,0);
          ibQuery1.ExecSQL;
        end;

        ArqIni.Free; ///Limpa variavel do INI

        // Terminado apaga o arquivo local e no FTP
        DeleteFile(pChar(sTLista[I]));
      end;
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-24
        MensagemSistema(E.Message,msgErro);
      end;
    end;

    // The End Importar ORÇAMENTOS
    //

    //
    //Inicio de Importar CLIENTES
    //

    //
    // Lista os clientes
    //
    DownloadMobile(sCNPJ, '*.cli', sTLista);
    //
    // Passa todos os arquivos da lista
    //
    for I := 0 to sTLista.Count -1 do
    begin
      Application.ProcessMessages;
      // Download do Arquivo

      // Ao Concluir o download abre o arquivo e le como se fosse um ini
      //
      ArqIni := TIniFile.Create(sTLista[I]);
      //
      // Salva o cliente
      //
      IBQuery1.Close;
      IBQuery1.SQL.Clear;
      IBQuery1.SQL.Add('Select CGC,CONTATOS from CLIFOR where CGC='+QuotedStr( FormataCpfCgc(ArqIni.ReadString('CLIENTE','CGC',''))));
      IBQuery1.Open;
      //
      if (IBQuery1.FieldByName('CGC').AsString = FormataCpfCgc(ArqIni.ReadString('CLIENTE','CGC','')) )then
      begin
        //
        sCONTATOS := IBQuery1.FieldByName('CONTATOS').AsString; ///COPIA O CONTEUDO DOS CONTATOS ATUAIS
        //
        Application.ProcessMessages;
        //
        IBQuery1.Close;
        IBQuery1.SQL.Clear;
        IBQuery1.SQL.Add('Update CLIFOR set '
        +'NOME=:NOME'
        +',IE=:IE'
        +',CEP=:CEP'
        +',COMPLE=:COMPLE'
        +',ENDERE=:ENDERE'
        +',CIDADE=:CIDADE'
        +',ESTADO=:ESTADO'
        +',FONE=:FONE'
        +',CONTATOS=:CONTATOS'
        +',EMAIL=:EMAIL'
        +' where CGC='+QuotedStr( FormataCpfCgc(ArqIni.ReadString('CLIENTE','CGC',''))));
        //
        //      +' where CGC='+QuotedStr( FormataCpfCgc(ArqIni.ReadString('CLIENTE','CGC','')) ) );
        //
        IBQuery1.Prepare;
        IBQuery1.ParamByName('CONTATOS').AsString := sCONTATOS+CHR(13)+'-------------------- '+CHR(13)+'Cadastro alterado no Small Mobile pelo vendedor '+ArqIni.ReadString('CLIENTE','VENDEDOR','')+' no dia '+ArqIni.ReadString('CLIENTE','DATA','')+' as '+ArqIni.ReadString('CLIENTE','HORA','');
        //
      end else
      begin
        // Não foi encontrado um CGC igual então cadastro NOVO
        //
        Application.ProcessMessages;
        //
        // Generator
        //
        ibDataSet200.Close;
        ibDataSet200.SelectSql.Clear;
        ibDataset200.SelectSql.Add('select gen_id(G_CLIFOR,1) from rdb$database');
        ibDataset200.Open;
        iRegistro := StrToInt('0'+ibDataSet200.FieldByname('GEN_ID').AsString);
        ibDataset200.Close;
        //
        IBQuery1.Close;
        IBQuery1.SQL.Clear;
        IBQuery1.SQL.Add('insert into CLIFOR ('
        +'NOME'
        +',CGC'
        +',IE'
        +',CEP'
        +',COMPLE'
        +',ENDERE'
        +',CIDADE'
        +',ESTADO'
        +',FONE'
        +',EMAIL'
        +',CONTATOS'
        +',CADASTRO'
        +',REGISTRO'
        +') values ('
        +':NOME'
        +',:CGC'
        +',:IE'
        +',:CEP'
        +',:COMPLE'
        +',:ENDERE'
        +',:CIDADE'
        +',:ESTADO'
        +',:FONE'
        +',:EMAIL'
        +',:CONTATOS'
        +',:CADASTRO'
        +',:REGISTRO'
        +')'
        );
        //
        IBQuery1.Prepare;
        //
        IBQuery1.ParamByName('REGISTRO').AsString := StrZero(iRegistro,10,0);
        IBQuery1.ParamByName('CGC').AsString      := FormataCpfCgc(ArqIni.ReadString('CLIENTE','CGC',''));
        IBQuery1.ParamByName('CADASTRO').AsString := ArqIni.ReadString('CLIENTE','DATA','');
        IBQuery1.ParamByName('CONTATOS').AsString := CHR(13)+'-------------------- '+CHR(13)+'Cadastro feito pelo Small Mobile pelo vendedor '+ArqIni.ReadString('CLIENTE','VENDEDOR','')+' no dia '+ArqIni.ReadString('CLIENTE','DATA','')+' as '+ArqIni.ReadString('CLIENTE','HORA','');
        //
      end;
      //
      IBQuery1.ParamByName('NOME').AsString     := ArqIni.ReadString('CLIENTE','NOME','');
      IBQuery1.ParamByName('IE').AsString       := ArqIni.ReadString('CLIENTE','IE','');
      IBQuery1.ParamByName('CEP').AsString      := FormataCEP(ArqIni.ReadString('CLIENTE','CEP',''));
      IBQuery1.ParamByName('COMPLE').AsString   := ArqIni.ReadString('CLIENTE','COMPLE','');
      IBQuery1.ParamByName('ENDERE').AsString   := ArqIni.ReadString('CLIENTE','ENDERE','');
      IBQuery1.ParamByName('ESTADO').AsString   := ArqIni.ReadString('CLIENTE','ESTADO','');
      IBQuery1.ParamByName('CIDADE').AsString   := ArqIni.ReadString('CLIENTE','CIDADE','');
      IBQuery1.ParamByName('FONE').AsString     := FORMATA_TELEFONE(ArqIni.ReadString('CLIENTE','FONE',''));
      IBQuery1.ParamByName('EMAIL').AsString    := ArqIni.ReadString('CLIENTE','EMAIL','');
      //
      try
        ibQuery1.ExecSQL;
      except  on e:exception do
      end;
      //
      ArqIni.Free; ///Limpa variavel do INI
      //
      // terminado apaga o arquivo local e no FTP
      //
      DeleteFile(pChar(sTLista[I])); // Apaga local
      //
      if {(not Form10.visible) and} (not Form12.visible) and (not Form24.visible) and (not Form30.visible) then
      begin
        //
        if Form7.Visible then
        begin
          Form7.Close;
          Commitatudo(True); // SQL - Commando
          AbreArquivos(False);
          Form7.Show;
        end else
        begin
          Commitatudo(True); // SQL - Commando
          AbreArquivos(False);
        end;
      end;
      //
    end;
  except end;
  //
  sTLista.Free;
  sTSessions.Free;
end;

procedure TForm1.Formatododanfe1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

  if Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','XXXXX')) <> 'Retrato' then
  begin
    Mais1Ini.WriteString('DANFE','Formato do DANFE','Retrato');
    //ShowMessage('Formato do DANFE definido como: Retrato'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Formato do DANFE definido como: Retrato');
  end else
  begin
    Mais1Ini.WriteString('DANFE','Formato do DANFE','Paisagem');
    //ShowMessage('Formato do DANFE definido como: Paisagem'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Formato do DANFE definido como: Paisagem');
  end;

  Mais1ini.Free;
end;

procedure TForm1.Ambiente1Click(Sender: TObject);
var
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  Mais1Ini : tIniFile;
begin
  Form22.Show;
  Mensagem22('');
  Senhas2.ShowModal;
  Form22.Close;
  Senha2:=Senhas2.SenhaPub2;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  sSenha := '';
  // ----------------------------- //
  // Fórmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //
  if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
  begin
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    //
    if Alltrim(Mais1Ini.ReadString('NFE','Ambiente','')) = _cAmbienteProducao then
    begin
      //
      I := Application.MessageBox(Pchar('Tem certeza que quer mudar para o ambiente de HOMOLOGAÇÃO?'
                              + chr(10)
                              +' Se estiver em dúvida clique no botão <Não>'
                              + Chr(10))
                              ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
      if I = IDYES then
      begin
        DefineAmbienteNFe(_cAmbienteHomologacao, 'Mais.Ambiente1Click1');
        //ShowMessage('Definido ambiente: Homologação'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Definido ambiente: Homologação');
      end;
    end else
    begin
      I := Application.MessageBox(Pchar('Tem certeza que quer mudar para o ambiente de PRODUÇÃO?'
                              + chr(10)
                              +' Se estiver em dúvida clique no botão <Não>'
                              + Chr(10))
                              ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
      if I = IDYES then
      begin
        DefineAmbienteNFe(_cAmbienteProducao, 'Mais.Ambiente1Click2');
        //ShowMessage('Definido ambiente: Produção'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Definido ambiente: Produção');
      end;
    end;
  end else
    //ShowMessage('Senha do administrador inválida.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Senha do administrador inválida.',msgAtencao);

  Mais1ini.Free;
end;

procedure TForm1.DefineAmbienteNFe(AcAmbiente, AcRotina: String);
var
  oArq: TArquivosDAT;
  enAmbienteAnt: tAmbienteNFe;
  cMsgPadrao: String;
begin
  // Não precisa passar usuário.
  oArq := TArquivosDAT.Create(EmptyStr);
  try
    enAmbienteAnt := oArq.NFe.NFE.Ambiente;
    if enAmbienteAnt = oArq.NFe.NFE.AmbienteStrToEnum(AcAmbiente) then
      Exit;

    oArq.NFe.NFE.Ambiente := oArq.NFe.NFE.AmbienteStrToEnum(AcAmbiente);

    cMsgPadrao := 'Alterou Ambiente NFe - DE: ' + oArq.NFe.NFE.AmbienteToStr(enAmbienteAnt) +
                  ' PARA: ' + oArq.NFe.NFE.AmbienteToStr(oArq.NFe.NFE.Ambiente);

    cMsgPadrao := Copy(AcRotina, 1, (80 - length(cMsgPadrao) - 2)) + ', ' + cMsgPadrao;

    Audita('ALTEROU','SMALL', Senhas.UsuarioPub, AnsiUpperCase(cMsgPadrao),0,0);

    Form7.IBDataSet100.Transaction.CommitRetaining;
  finally
    FreeAndNil(oArq);
  end;
end;

procedure TForm1.ConfiguraodoDANFEparaNFe1Click(Sender: TObject);
var
  I : Integer;
  sLote : String;
begin
  Screen.Cursor            := crHourGlass;
  ConfiguraNFE;

  try
    sLote      := '00001';

    Form7.ibDataSet15.Close;
    Form7.ibDataSet15.SelectSql.Clear;
    Form7.ibDataset15.SelectSql.Add('select * from VENDAS where EMITIDA=''S'' and EMISSAO=CURRENT_DATE order by NUMERONF');
    Form7.ibDataset15.Open;

    Form7.ibDataset15.Last;

    for I := 1 to 100 do if (Alltrim(Form7.ibDataSet15NFEPROTOCOLO.AsString) ='') then Form7.ibDataSet15.MoveBy(-1);

    if (Alltrim(Form7.ibDataSet15NFEPROTOCOLO.AsString) <> '') then
    begin
      Form7.fNFE :=  Form7.ibDataSet15NFEXML.AsString;

      if Form1.sVersaoLayout = '4.00' then
      begin
        Form7.spdNFe.EditarModeloDanfe(sLote, Form7.fNFe,Form1.sAtual + '\nfe\Templates\vm60\danfe\'+Form7.sFormatoDoDanfe+'.rtm');
      end else
      begin
        Form7.spdNFe.EditarModeloDanfe(sLote, Form7.fNFe,Form1.sAtual + '\nfe\Templates\vm50a\danfe\'+Form7.sFormatoDoDanfe+'.rtm');
      end;
    end;
  except
    //ShowMessage('Falha ao configurar o DANFE. Para configurar o DANFE é necessário ter uma NF-e transmitida.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Falha ao configurar o DANFE. Para configurar o DANFE é necessário ter uma NF-e transmitida.',msgAtencao);
  end;
  Screen.Cursor            := crDefault;
end;

procedure TForm1.ConfiguraoTEF1Click(Sender: TObject);
begin
  frmConfiguracaoTEFCommerce := TfrmConfiguracaoTEFCommerce.Create(nil);
  try
    frmConfiguracaoTEFCommerce.IBDataBase := Form7.IBDatabase1;
    frmConfiguracaoTEFCommerce.ShowModal;

    ConfiguraoTEF1.Checked := TestarTEFConfigurado;
  finally
    FreeAndNil(frmConfiguracaoTEFCommerce);
  end;
end;

procedure TForm1.ConfiguraodaNFe2Click(Sender: TObject);
var
  oArq: TArquivosDAT;
  Mais1Ini : tIniFile;
begin
  Formatododanfe1.Checked := True;
  Ambiente1.Checked       := True;
  //
  if bModoScan then SCANSistemadeContingnciadoAmbienteNacional1.Checked := True else SCANSistemadeContingnciadoAmbienteNacional1.Checked := False;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  oArq := TArquivosDAT.Create(Usuario);
  try
    Formatododanfe1.Checked := True;
    Ambiente1.Checked       := True;
    //
    if bModoScan then SCANSistemadeContingnciadoAmbienteNacional1.Checked := True else SCANSistemadeContingnciadoAmbienteNacional1.Checked := False;
    //
    Formatododanfe1.Caption := 'Formato do DANFE: '+Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','Retrato'));
    Ambiente1.Caption       := 'Ambiente: '+Alltrim(Mais1Ini.ReadString('NFE','Ambiente',_cAmbienteHomologacao));
    //
    if Alltrim(Mais1Ini.ReadString('DANFE','Configurar',''))      = '' then Mais1Ini.WriteString('DANFE','Configurar','Não');
    if Alltrim(Mais1Ini.ReadString('DANFE','Configurar',''))      = 'Sim' then ConfiguraodoDANFEparaNFe1.Visible := True else ConfiguraodoDANFEparaNFe1.Visible := False;
    if Mais1Ini.ReadString('ENVIO','Zipar XML','N')               = 'S'   then Form1.ZiparXMLnoenvioporemail1.Checked := True else Form1.ZiparXMLnoenvioporemail1.Checked := False;
    if Mais1Ini.ReadString('ENVIO','Enviar danfe por e-mail','S') = 'S'   then Form1.Enviardanfeporemail1.Checked := True else Form1.Enviardanfeporemail1.Checked := False;
    if Mais1Ini.ReadString('NFE','Consultar Nfes Emitidas','Sim') = 'Sim' then Form1.ConsultarNFesemitidas1.Checked := True else Form1.ConsultarNFesemitidas1.Checked := False;

    EnvioautomticodeXML1.Checked := oArq.NFe.XML.EnvioAutomatico;

    {Sandro Silva 2023-06-01 inicio}
    if Form1.ValidaRecursos.PermiteRecursoParaProduto = False then
    begin
      Form1.ConsultarNFesemitidas1.Checked := False;
      Form1.ConsultarNFesemitidas1.Enabled := False;
    end;
    {Sandro Silva 2023-06-01 fim}

    {Sandro Silva 2023-03-14 inicio
    //
    if Mais1Ini.ReadString('NFE','Layout','4.00')               = '4.00' then
    begin
      Form1.N301.Checked   := False;
      Form1.N3101.Checked  := False;
      Form1.N4001.Checked  := True;
    end else
    begin
      Form1.N301.Checked   := False;
      Form1.N3101.Checked  := True;
      Form1.N4001.Checked  := False;
    end;
    }
    if Mais1Ini.ReadString('NFE','Layout','4.00') <> '4.00' then
    begin
      Mais1Ini.WriteString('NFE','Layout','4.00');
    end;
    Form1.N301.Checked   := False;
    Form1.N3101.Checked  := False;
    //
    if Mais1Ini.ReadString('NFE','Layout','4.00') = '4.00' then
    begin
      Form1.N301.Checked   := False;
      Form1.N3101.Checked  := False;
      Form1.N4001.Checked  := True;
    end;
    {Sandro Silva 2023-03-14 fim}
    //
    if Mais1Ini.ReadString('NFE','Preenchimento','Simples') = 'Simples' then
    begin
      Form1.Simples1.Checked := True;
      Form1.Complexo1.Checked := False;
    end else
    begin
      Form1.Simples1.Checked := False;
      Form1.Complexo1.Checked := True;
    end;

    ConfiguraoTEF1.Checked := TestarTEFConfigurado;
  finally
    Mais1ini.Free;
    FreeAndNil(oArq);
  end;
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if KEY = VK_RETURN then
  begin
   I := DbGrid1.SelectedIndex;
   DbGrid1.SelectedIndex := DbGrid200.SelectedIndex  + 1;
   if I = DbGrid1.SelectedIndex then
   begin
     DbGrid1.SelectedIndex := 0;
     ibDAtaSet1.Next;
   end;
  end;

  if Key = VK_ESCAPE then
  begin
    dbGrid1.Visible := False;
    Edit1.Visible   := False;

    MontaTela(True);
  end;

  Screen.Cursor := crDefault;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if KEY = VK_RETURN then
  begin
    ExecutaSql2(True);
  end;

  Screen.Cursor := crDefault;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  I, J : Integer;
  F : TextFile;
  vTotal: array [0..200] of Double;  // Cria uma matriz com 100 elementos
begin
  //
  if Key = chr(16) then
  begin
    //
    if Form1.bHtml1 then
    begin
      AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));
      Rewrite(F);
      CriaJpg('logotip.jpg');
      Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - SQL COMANDO</title></head>');
      WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
      WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
      WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font><br><br>');
      //
      WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F,' <tr bgcolor=#'+Form1.sHtmlCor+' align=left>');
      //
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        WriteLn(F,'  <th '+{nowrap}'><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].DisplayName+'</font></th>');
      end;
      WriteLn(F,' </tr>');
      //
    end else
    begin
      //
      AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));
      Rewrite(F);
      WriteLn(F,AllTrim(Form7.ibDataSet13NOME.AsString));
      WriteLn(F,'');
      //
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        Write(F,Copy(dbGrid1.Fields[I].DisplayName+Replicate(' ',dbGrid1.Fields[I].DisplayWidth),1,dbGrid1.Fields[I].DisplayWidth)+' ');
      end;
      WriteLn(F,'');
      //
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        Write(F,Replicate('-',dbGrid1.Fields[I].DisplayWidth)+' ');
      end;
      WriteLn(F,'');
      //
    end;
    //
    J := 0;
    for I := 1 to 200 do vTotal[I] := 0;
    //
    ibDataSet1.DisableControls;
    ibDataSet1.First;
    while not Form1.ibDataSet1.Eof do
    begin
      //
      J := J + 1;
      //
      if Form1.bHtml1 then
      begin
        WriteLn(F,' <tr>');
        for I := 0 to dbGrid1.FieldCount -1 do
        begin
          if TipoCampoFloat(dbGrid1.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid1.Fields[I].DataType = ftFloat then
          begin
            WriteLn(F,'  <td '+{nowrap}' align=right><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].asString+'</font></td>');
            vTotal[I] := vTotal[I] + dbGrid1.Fields[I].AsFloat;
          end else
          begin
            if dbGrid1.Fields[I].DisplayName =  'FOTO' then
            begin
              WriteLn(F,'  <td '+{nowrap}'><font face="Microsoft Sans Serif" size=1>FOTO</font></td>');
            end else
            begin
              WriteLn(F,'  <td '+{nowrap}'><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].asString+'</font></td>');
            end;
          end;
        end;
        WriteLn(F,' </tr>');
      end else
      begin
        for I := 0 to dbGrid1.FieldCount -1 do
        begin
          if TipoCampoFloat(dbGrid1.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid1.Fields[I].DataType = ftFloat then
          begin
            Write(F,Format('%'+IntToStr(dbGrid1.Fields[I].DisplayWidth)+'.'+Form1.ConfCasas+'n',[dbGrid1.Fields[I].asFloat])+' ');
            vTotal[I] := vTotal[I] + dbGrid1.Fields[I].AsFloat;
          end else
          begin
            if dbGrid1.Fields[I].DisplayName =  'FOTO' then
            begin
              Write(F,'FOTO');
            end else
            begin
              Write(F,Copy(dbGrid1.Fields[I].asString+Replicate(' ',250),1,dbGrid1.Fields[I].DisplayWidth)+' ');
            end;
          end;
        end;
        //
        WriteLn(F,'');
        //
      end;
      //
      Form1.ibDataSet1.Next;
      //
    end;
    ibDataSet1.EnableControls;
    //
    if Form1.bHtml1 then
    begin
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid1.Fields[I]) then //Sandro Silva 2024-04-29 if dbGrid1.Fields[I].DataType = ftFloat then
        begin
          WriteLn(F,'  <td '+{nowrap}' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[vTotal[I]])+'</font></td>');
        end else
        begin
          WriteLn(F,'  <td '+{nowrap}'></td>');
        end;
      end;
      //
      WriteLn(F,' </table');
      //
      WriteLn(F,'<center><br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
      + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
      + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br>');
      //
      // WWW
      //
      if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
      begin
        WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Small, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
      end else
      begin
        WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
      end;
      //
      WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>Através do seguinte comando SQL digitado pelo operador: <br>'+Form1.ibDataSet1.SelectSQL.Text+'</center>');
      WriteLn(F,'<font size=1><center>Número de registros: '+IntToStr(J)+'</font></center>');
      if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
      WriteLn(F,'</html>');
      CloseFile(F);                                    // Fecha o arquivo
      Screen.Cursor  := crDefault; // Cursor de Aguardo
      if FileExists(Senhas.UsuarioPub+'.HTM') then AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
      //
    end else
    begin
      //
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid1.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid1.Fields[I].DataType = ftFloat then
        begin
          Write(F,Replicate('-',dbGrid1.Fields[I].DisplayWidth)+' ');
        end else
        begin
          Write(F,Replicate(' ',dbGrid1.Fields[I].DisplayWidth)+' ');
        end;
      end;
      WriteLn(F,'');
      //
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        if TipoCampoFloat(dbGrid1.Fields[I]) then // Sandro Silva 2024-04-29 if dbGrid1.Fields[I].DataType = ftFloat then
        begin
          Write(F,Format('%'+IntToStr(dbGrid1.Fields[I].DisplayWidth)+'.'+Form1.ConfCasas+'n',[vTotal[I]])+' ');
        end else
        begin
          Write(F,Replicate(' ',dbGrid1.Fields[I].DisplayWidth)+' ');
        end;
      end;
      WriteLn(F,'');
      //
      //
      WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
      + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
      + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'');
      //
      // WWW
      //
      WriteLn(F,'Relatório gerado pelo sistema Small, www.smallsoft.com.br'); // Ok
      WriteLn(F,'Através do seguinte comando SQL CONNECT digitado pelo operador: '+Form1.ibDataSet1.SelectSQL.Text+' ');
      WriteLn(F,'Número de registros: '+IntToStr(J)+'');
      CloseFile(F);                                    // Fecha o arquivo
      if FileExists(Senhas.UsuarioPub+'.txt') then ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOW);
      //
    end;
    //
  end;
  //
end;

procedure TForm1.SQLCommandoexterno1Click(Sender: TObject);
var
  Retangulo : tRect;
  wndHandle : THandle;
  wndClass  : array[0..50] of char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0],nil);
  GetWindowRect(wndHandle,Retangulo);

  try
    Form1.Height      := Screen.Height - (Retangulo.Bottom - Retangulo.Top);
    dbGrid1.Visible := False;
    Edit1.Visible   := False;

    ibDataSet1.Close;
    ibDataSet1.SelectSQL.Clear;

    Edit1.Align   := AlTop;
    dbGrid1.Align := AlClient;

    Edit1.Top       := 0;
    Edit1.Left      := 0;
    Edit1.Width     := Screen.Width-16;
    dbGrid1.Left    := 0;
    dbGrid1.Top     := 20;
    dbGrid1.Height  := Form1.Height-56;
    dbGrid1.Width   := Screen.Width-16;
    dbGrid1.Visible := True;
    Edit1.Visible   := True;
    Edit1.SetFocus;
  except
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Label208.Font.Style <> [fsBold] then
  begin
    if Copy(Form1.imgBackup.Hint,1,23) = 'Banco de dados em risco' then
    begin
      if Form1.Image_Perigo_2.Tag = 0 then
      begin
        Form1.imgBackup.Picture    := Form1.Image_Perigo_1.Picture;
        Form1.Image_Perigo_2.Tag  := 1;
        Form1.Label208.Font.Color := $00F0F0F0;
      end else
      begin
        Form1.imgBackup.Picture    := Form1.Image_Perigo_2.Picture;
        Form1.Label208.Font.Color := clBlack;
        Form1.Image_Perigo_2.Tag  := 0;
      end;

      Form1.imgBackup.Repaint;
    end;
  end;
end;

procedure TForm1.ZiparXMLnoenvioporemail1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

  if Mais1Ini.ReadString('ENVIO','Zipar XML','N') = 'S'
    then Mais1Ini.WriteString('ENVIO','Zipar XML','N')
      else Mais1Ini.WriteString('ENVIO','Zipar XML','S');

  Mais1Ini.Free;
end;

procedure TForm1.Enviardanfeporemail1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

  if Mais1Ini.ReadString('ENVIO','Enviar danfe por e-mail','S') = 'S' then
    Mais1Ini.WriteString('ENVIO','Enviar danfe por e-mail','N')
  else
    Mais1Ini.WriteString('ENVIO','Enviar danfe por e-mail','S');

  Mais1Ini.Free;
end;

procedure TForm1.Comandos1Click(Sender: TObject);
begin
  if (Form7.ibDataSet13ESTADO.AsString = 'XZ') then
  begin
    SQLMododecomando1.Visible := False;
  end else
  begin
    SQLMododecomando1.Visible := True;
  end;
end;

procedure TForm1.AtualizartabelaIBPT1Click(Sender: TObject);
var
  F : TExtFile;
  I, J : Integer;
  sLinha : String;
begin
  if (AllTrim(Form7.ibDataSet13ESTADO.AsString) <> '') and (Form1.iReduzida<>2) then
  begin
    Form29.Panel1.Visible  := True;
    Aviso2('Atualizando tabela IBPT (Instituto Brasileiro de'+chr(10)+
           'Planejamento Tributário) para o estado de '+Form7.ibDataSet13ESTADO.AsString);
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    if FileExists(pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp')) then
    begin
      //
      AssignFile(f,pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp'));
      Reset(f);
      //
      I := 0;
      //
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      Form1.ibQuery1.SQL.Add('delete from IBPT_');
      Form1.ibQuery1.Open;
      //
      while not eof(f) do
      begin
         //
         ReadLn(f,sLinha);
         //
         try
           if Copy(sLinha,1,3)<>'cod' then
           begin
              //
              sLinha := ConverteAcentosIBPT(StrTran(sLinha,Chr(39),' '));
              sLinha := StrTran(sLinha,';',Chr(39)+','+chr(39));
              //
              try
                Form1.ibQuery1.Close;
                Form1.ibQuery1.SQL.Clear;
                Form1.ibQuery1.SQL.Add('insert into IBPT_ (CODIGO, EX, TIPO, DESCRICAO, NACIONALFEDERAL, IMPORTADOFEDERAL, ESTADUAL, MUNICIPAL, VIGENCIAINICIO, VIGENCIAFIM, CHAVE, VERSAO, FONTE, REGISTRO) values ('+chr(39)+sLinha+QuoTedStr(', ')+StrZero(I,10,0)+chr(39)+')');
                Form1.ibQuery1.Open;
              except
                on E: Exception do
                  //ShowMEssage('Erro (' + E.Message + ') ao atualizar a tabela do IBPT. '+chr(10)+chr(10)+Form1.ibQuery1.SQL.Text); Mauricio Parizotto 2023-10-25
                  MensagemSistema('Erro (' + E.Message + ') ao atualizar a tabela do IBPT. '+chr(10)+chr(10)+Form1.ibQuery1.SQL.Text,msgErro);
              end;
           end;
         except end;
         try
           I := I + 1;
           Form29.Gauge1.Progress := 100 * I div 9000;// 11641;
           Form29.Gauge1.Repaint;
         except end;
      end;

      CloseFile(f);

      if FileExists(pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp')) then
        DeleteFile(pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp'));

      Form29.Panel1.Visible  := True;
      Aviso2('Atualizando indice IBPT (Instituto Brasileiro de'+chr(10)+
             'Planejamento Tributário) na tabela de produtos');


      Form7.ibQuery99.Close;
      Form7.ibQuery99.SQL.Clear;
      Form7.ibQuery99.SQL.Add('select count(distinct CF) from estoque');
      Form7.ibQuery99.Open;

      J := StrToInt(Form7.IBQuery99.FieldByname('COUNT').AsString);
      I := 0;

      Form7.ibQuery99.Close;
      Form7.ibQuery99.SQL.Clear;
      Form7.ibQuery99.SQL.Add('select CF from estoque group by CF');
      Form7.ibQuery99.Open;

      while not Form7.ibQuery99.Eof do
      begin
        try
          I := I + 1;
          Form29.Gauge1.Progress := 100 * I div J;
          Form29.Gauge1.Repaint;
        except
        end;

        try
          if AllTrim(Form7.ibQuery99.FieldByname('CF').AsString) <> '' then
          begin
            try
              Form7.ibQuery1.Close;
              Form7.ibQuery1.SQL.Clear;

              Form7.ibQuery1.SQL.Add('select ESTADUAL, MUNICIPAL, IMPORTADOFEDERAL, NACIONALFEDERAL from IBPT_ where (char_length(CODIGO) >= 8) and '+QuotedStr(Form7.ibQuery99.FieldByname('CF').AsString)+'=CODIGO');
              Form7.ibQuery1.Open;

              begin
                if AllTrim(Form7.ibQuery1.FieldByname('ESTADUAL').AsString) <> '' then
                begin
                  try
                    // 1 - Estrangeira - Importação direta, exceto a indicada no código 6
                    // 2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7
                    // 6 - Estrangeira - Importação direta, sem similar nacional, constante em lista de Resolução CAMEX;
                    // 7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista de Resolução CAMEX.
                    // 8 - Nacional, mercadoria ou bem com Conteúdo de Importação sup. a 70%
                    //
                    Form7.ibQuery2.Close;
                    Form7.ibQuery2.SQL.Clear;
                    Form7.ibQuery2.SQL.Add('update ESTOQUE set'+
                    ' IIA_UF='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('ESTADUAL').AsString,',','.'))+
                    ', IIA_MUNI='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('MUNICIPAL').AsString,',','.'))+
                    ', IIA='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('IMPORTADOFEDERAL').AsString,',','.'))+
                    ' where CF='+QuotedStr(Form7.ibQuery99.FieldByname('CF').AsString)+' and ((SubString(CST from 1 for 1) = ''1'') or (SubString(CST from 1 for 1) = ''2'') or (SubString(CST from 1 for 1) = ''6'') or (SubString(CST from 1 for 1) = ''7'') or (SubString(CST from 1 for 1) = ''8''))');
                    Form7.ibQuery2.Open;
                    //
                    // 0 - Nacional, exceto as indicadas nos códigos 3 a 5
                    // 3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento)
                    // 4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam o Decreto-Lei nº 288/1967, e as Leis nºs 8.248/1991, 8.387/1991, 10.176/2001 e 11.484/2007;
                    // 5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40% (quarenta por cento)
                    //
                    Form7.ibQuery2.Close;
                    Form7.ibQuery2.SQL.Clear;
                    Form7.ibQuery2.SQL.Add('update ESTOQUE set'+
                    ' IIA_UF='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('ESTADUAL').AsString,',','.'))+
                    ', IIA_MUNI='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('MUNICIPAL').AsString,',','.'))+
                    ', IIA='+QuotedStr( StrTran(Form7.ibQuery1.FieldByname('NACIONALFEDERAL').AsString,',','.'))+
                    ' where CF='+QuotedStr(Form7.ibQuery99.FieldByname('CF').AsString)+' and ((SubString(CST from 1 for 1) = ''0'') or (SubString(CST from 1 for 1) = ''3'') or (SubString(CST from 1 for 1) = ''4'')  or (SubString(CST from 1 for 1) = ''5''))');
                    Form7.ibQuery2.Open;
                  except
                    //ShowMessage(Form7.ibQuery2.SQL.Text); Mauricio Parizotto 2023-10-25
                    MensagemSistema(Form7.ibQuery2.SQL.Text,msgErro);
                  end;
                end;
              end;
            except end;
            Form7.ibQuery1.Close;
          end;
        except
        end;

        Form7.ibQuery99.Next;
      end;

      try
        Commitatudo(True); // SQL - Commando
        AbreArquivos(False);
      except
      end;
    end;

    Form29.Close;

    Screen.Cursor        := crDefault;
  end;
end;

procedure TForm1.Estatisticas1Click(Sender: TObject);
var
  F: TextFile;
begin
  // ESTATISTICAS
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));         // Direciona o arquivo F para RELATO.TXT
  Rewrite(F);                           // Abre para gravação
  Writeln(F,'<html><head><title>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString)+' - INADIMPLÊNCIA')+'</title></head>');
  WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
  WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#c0c0c0><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
  //
  // Estatisticas
  //
  WriteLn(F,'<br>');              // Linha em branco
  WriteLn(F,'<br>');              // Linha em branco
  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>Estatísticas</b></font>');
  WriteLn(F,'<br><br>');              // Linha em branco
  //
  WriteLn(F,' <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=3 width=500>');
  //
  // ùltimos três meses
  //
  WriteLn(F,Estatistica('CLIFOR','Clientes e fornecedores'));
  WriteLn(F,Estatistica('ESTOQUE','Itens no estoque'));
  WriteLn(F,Estatistica('RECEBER','Contas a receber'));
  WriteLn(F,Estatistica('PAGAR','Contas a pagar'));
  WriteLn(F,Estatistica('ALTERACA','Itens de venda no varejo'));
  WriteLn(F,Estatistica('PAGAMENT','Registros de pagamentos no varejo'));
  WriteLn(F,Estatistica('ITENS001','Itens de venda NF-e'));
  WriteLn(F,Estatistica('ITENS002','Itens de compra'));
  WriteLn(F,Estatistica('CAIXA','Registros no livro caixa'));
  WriteLn(F,Estatistica('VENDEDOR','Vendedores'));
  WriteLn(F,Estatistica('GRUPO','Grupos de produtos no estoque'));
  WriteLn(F,Estatistica('BANCOS','Bancos'));
  WriteLn(F,Estatistica('MOVIMENT','Registros no movimento bancário'));
  WriteLn(F,Estatistica('GRADE','Ítens na grade de produtos'));

  //
  WriteLn(F,'</table>');              // Linha em branco
  WriteLn(F,'<br>');              // Linha em branco
  //
  WriteLn(F,'<center><br><font face="verdana" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
  + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
  + Copy(DateTimeToStr(Date),7,4) +', '+ LowerCase(DiaDaSemana(Date)) + ' às ' + TimeToStr(Time)+'</font></center>');
  //
  WriteLn(F,'<br>');              // Linha em branco

  //
  // WWW
  //
  if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
  begin
    WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Small, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
  end else
  begin
    WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
  end;
  //
  if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
  WriteLn(F,'</html>');
  //
  CloseFile(F);                                    // Fecha o arquivo
  //
  Screen.Cursor := crDefault; // Cursor de Aguardo
  //
  AbreArquivoNoFormatoCerto(pChar(Senhas.UsuarioPub+'.HTM'));
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  sTLista : TStringList;
  I, III : Integer;
  ArqIni : tIniFile;
  sRelatorio, sUsuario, sNome : String;
  F : TextFile;
  dInicio, dFinal: tDate;
  fTotal, fTotal1, fTotal2 : Real;
  Mais1Ini : tIniFile;
begin
  if AllTrim(Form7.ibDataSet13.fieldByName('CGC').AsString) <> '' then
  begin
    if AutoMarketplace1.Checked then
    begin
      if not ConsultaProcesso('mkp.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mkp.exe','', '', SW_HIDE); // Form1Ativate
      end;
    end;

    if AutoSmallMobile1.Checked then
    begin
      if not ConsultaProcesso('mobile.exe') then // Timer2Timer
      begin
        ShellExecute( 0, 'Open', 'mobile.exe', pChar(Form7.ibDataSet13CGC.AsString) , '', SW_SHOW); // Timer2Timer
      end;
    end;

    if AutoSmallMobile1.Checked then
    begin
      Timer2.Enabled            := False;

      if not ConsultaProcesso('mobile.exe') then // Timer2Timer
      begin
        ShellExecute( 0, 'Open', 'mobile.exe', pChar(Form7.ibDataSet13CGC.AsString) , '', SW_SHOW); // Timer2Timer
      end;

      try
        sTLista := TStringList.Create();
        sTLista.Clear;
        Form1.DownloadSmallMobile1Click(DownloadSmallMobile1);
        //
//        if (not Form10.visible) and (not Form12.visible) and (not Form24.visible) and (not Form30.visible) then
        begin
          DownloadMobile(LimpaNumero(Form7.ibDataSet13.fieldByName('CGC').AsString), '*.mob', sTLista);
          //
          for I := 0 to sTLista.Count -1 do
          begin
            if Pos('.mob',Lowercase(sTLista[I])) <> 0 then
            begin
              // Cursor
              Screen.Cursor             := crAppStart;                   // Cursor de Aguardo
              Form1.Label200.Tag        := 1;

              Application.ProcessMessages;

              try
                AtualizaMobile(False);
              except
              end;

              DeleteFile(pChar(sTLista[I]));    // Apaga local

              Screen.Cursor             := crDefault;                   // Cursor normal
            end;
          end;
        end;

        DownloadMobile(LimpaNumero(Form7.ibDataSet13.fieldByName('CGC').AsString), '*.rel', sTLista);

        for I := 0 to sTLista.Count -1 do
        begin
          if Pos('.rel',Lowercase(sTLista[I])) <> 0 then
          begin
            // Cursor
            Screen.Cursor             := crAppStart;                   // Cursor de Aguardo

            Form1.Label200.Tag        := 1;

            Application.ProcessMessages;

            // Download do Arquivo
            ArqIni := TIniFile.Create(sTLista[I]);

            // Salva o cliente
            sRelatorio := ArqIni.ReadString('RELATORIO','TITULO','');
            sUsuario   := ArqIni.ReadString('RELATORIO','USUARIO','');
            sNome      := ArqIni.ReadString('RELATORIO','NOME','');

            ArqIni.Free;

            if (AllTrim(sRelatorio) <> '') and
               (AllTrim(sUsuario) <> '') and
               (AllTrim(sNome) <> '') then
            begin
              // terminado apaga o arquivo local e no FTP
              DeleteFile(pChar(sTLista[I]));    // Apaga local

              try
                DeleteFile(pChar(sNome+'.HTM'));
                AssignFile(F,pChar(sNome+'.HTM'));         // Direciona o arquivo F para RELATO.TXT
                Rewrite(F);                           // Abre para gravação

                Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - SMALL MOBILE</title></head>');
                WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0">');
                WriteLn(F,'<br><br><center><img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
                WriteLn(F,'<br><br>');

                if (sRelatorio <> 'MINHAS VENDAS') and (sRelatorio <> 'MEUS ORÇAMENTOS') and (sRelatorio <> 'CONTAS A PAGAR') and (sRelatorio <> 'CONTAS A RECEBER') then
                begin
                  // Cria os gráficos padrão no form5
                  Form5.Caption := sRelatorio;

                  Form7.sModuloAnterior := Form7.sModulo;

                  if Form5.Visible then
                  begin
                    Form5.Close;
                    Form5.Show;
                  end else
                  begin
                    Form5.Close;
                    Form5.Show;
                    Form5.Close;
                  end;

                  if Form1.WindowState = wsMinimized then
                  begin
                    Form5.WindowState := wsMinimized;
                  end;

                  Form7.sModulo := Form7.sModuloAnterior;
                end;

                Form5.Caption := '';

                if sRelatorio = 'INDICADORES' then
                begin
                  // WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>'+ sRelatorio +'</b></font>');
                  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
                  Mais1Ini.UpdateFile;

                  // Indicadores
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I03','0')) > 0 then WriteLn(F,'<br><img src="FluxoDeCaixaG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I02','0')) > 0 then WriteLn(F,'<br><img src="Inadimplencia90DiasG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I08','0')) > 0 then WriteLn(F,'<br><img src="Inadimplencia360DiasG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I09','0')) > 0 then WriteLn(F,'<br><img src="InadimplenciaTotalDiasG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I21','0')) > 0 then WriteLn(F,'<br><img src="VendasG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I22','0')) > 0 then WriteLn(F,'<br><img src="VendasMesG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I23','0')) > 0 then WriteLn(F,'<br><img src="VendasAnoG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I04','0')) > 0 then WriteLn(F,'<br><img src="FaturamentoMesG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I05','0')) > 0 then WriteLn(F,'<br><img src="DespesasMesG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I06','0')) > 0 then WriteLn(F,'<br><img src="LucroMesG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I10','0')) > 0 then WriteLn(F,'<br><img src="FaturamentoUltimosAnosG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I11','0')) > 0 then WriteLn(F,'<br><img src="DespesasUltimosAnosG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I12','0')) > 0 then WriteLn(F,'<br><img src="LucroUltimosAnosG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I07','0')) > 0 then WriteLn(F,'<br><img src="VendasPorVendedorG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I19','0')) > 0 then WriteLn(F,'<br><img src="VendasPorVendedorMesAnteriorG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I13','0')) > 0 then WriteLn(F,'<br><img src="CurvaABCClientesG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I14','0')) > 0 then WriteLn(F,'<br><img src="CurvaABCEstoqueG.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I16','0')) > 0 then WriteLn(F,'<br><img src="CurvaABCFornecedoresG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I17','0')) > 0 then WriteLn(F,'<br><img src="RelacaoDespesas360G.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I18','0')) > 0 then WriteLn(F,'<br><img src="RelacaoReceitas360G.png" border="0" width=500 height=250>');
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I20','0')) > 0 then WriteLn(F,'<br><img src="RelacaoDespesasMesAnteriorG.png" border="0" width=500 height=250>');
                  //
                  if StrToInt('0'+Mais1Ini.ReadString(sUsuario,'I15','0')) > 0 then WriteLn(F,'<br><img src="RegistrosNoCadastroG.png" border="0" width=500 height=250>');
                  //
                  Mais1Ini.Free;
                end;

                if sRelatorio = 'FLUXO DE CAIXA' then
                begin
                  WriteLn(F,'<br><img src="FluxoDeCaixaG.png" border="0" width=500 height=250>');
                end;

                if sRelatorio = 'VENDAS POR VENDEDOR' then
                begin
                  WriteLn(F,'<br><img src="VendasPorVendedorG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="VendasPorVendedorMesAnteriorG.png" border="0" width=500 height=250>');
                end;

                // INADIMPLÊNCIA
                if sRelatorio = 'INADIMPLÊNCIA' then
                begin
                  WriteLn(F,'<br><img src="Inadimplencia90DiasG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="Inadimplencia360DiasG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="InadimplenciaTotalDiasG.png" border="0" width=500 height=250>');
                end;

                // Lucro
                if sRelatorio = 'LUCRO' then
                begin
                  WriteLn(F,'<br><img src="FaturamentoMesG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="DespesasMesG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="LucroMesG.png" border="0" width=500 height=250>');
                  //
                  WriteLn(F,'<br><img src="FaturamentoUltimosAnosG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="DespesasUltimosAnosG.png" border="0" width=500 height=250>');
                  WriteLn(F,'<br><img src="LucroUltimosAnosG.png" border="0" width=500 height=250>');
                end;

                // Minhas vendas
                if sRelatorio = 'MINHAS VENDAS' then
                begin
                  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>'+ sRelatorio +'</b></font><br>');
                  try
                    dInicio := StrToDate('01/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));
                    dFinal  := StrToDate(StrZero(DiasDesteMes,2,0)+'/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));

                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select EMISSAO, CLIENTE, TOTAL, NUMERONF from VENDAS where (VENDEDOR= '+QuotedStr( sUsuario )+') and EMISSAO<='+QuotedStr(DateToStrInvertida(dFinal))+' and EMISSAO>='+QuotedStr(DateToStrInvertida(dInicio))+' order by EMISSAO');
                    Form1.ibQuery1.Open;

                    WriteLn(F,'<br>');
                    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Data<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Cliente<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Total<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">NF<br></th>');

                    WriteLn(F,'  </tr>');

                    fTotal  := 0;

                    while not Form1.IBQuery1.Eof do
                    begin
                      Application.ProcessMessages;
                      WriteLn(F,'   <tr>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('EMISSAO').AsString+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('CLIENTE').AsString+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form1.ibQuery1.FieldByname('TOTAL').AsFloat])+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('NUMERONF').AsString+'<br></font></td>');
                      WriteLn(F,'   </tr>');

                      fTotal  := fTotal + Form1.ibQuery1.FieldByname('TOTAL').AsFloat;

                      Form1.ibQuery1.Next;
                    end;

                    WriteLn(F,'   <tr>');

                    if fTotal = 0 then
                    begin
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br>O vendedor: '+sUsuario+' não possui nenhuma NF-e registrada no banco de dados</font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    end else
                    begin
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotal])+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    end;

                    WriteLn(F,'   </tr>');
                    WriteLn(F,'  </table>');
                  except
                    on E: Exception do
                    begin
                      WriteLn(F,'  <br>Erro nos dados: '+E.Message);
                    end;
                  end;
                end;

                // Minhas vendas
                if sRelatorio = 'MEUS ORÇAMENTOS' then
                begin
                  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>'+ sRelatorio +'</b></font>');

                  try
                    // GRAFICO
                    DeleteFile(pChar(Form1.sAtual+'\orcamentos.png'));
                    DeleteFile(pChar(Form1.sAtual+'\orcamentos.gra'));

                    // cria o gráfico de fluxo de caixa orçamentos.png //
                    Mais1ini := TIniFile.Create(Form1.sAtual+'\orcamentos.gra');

                    // Titulo
                    Mais1Ini.WriteString('DADOS','3D','1');
                    Mais1Ini.WriteString('DADOS','MarcasS1','1');
                    Mais1Ini.WriteString('DADOS','Legenda','0');
                    Mais1Ini.WriteString('DADOS','TipoS1','4');
                    Mais1Ini.WriteString('DADOS','AlturaBmp','1000');
                    Mais1Ini.WriteString('DADOS','LarguraBmp','2000');

                    Mais1Ini.WriteString('DADOS','Titulo','');
                    Mais1Ini.WriteString('DADOS','NomeBmp','orcamentos.png');
                    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C');

                    dInicio := StrToDate('01/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));
                    dFinal  := StrToDate(StrZero(DiasDesteMes,2,0)+'/'+StrZero(Month(Date),2,0)+'/'+StrZero(Year(Date),4,0));

                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select DATA, CLIFOR, sum(TOTAL) as VTOT, NUMERONF from ORCAMENT where (VENDEDOR= '+QuotedStr( sUsuario )+') and DATA<='+QuotedStr(DateToStrInvertida(dFinal))+' and DATA>='+QuotedStr(DateToStrInvertida(dInicio))+' group by DATA, CLIFOR, NUMERONF order by DATA');
                    Form1.ibQuery1.Open;

                    WriteLn(F,'<center><a href="'+Form1.sAtual+'\orcamentos.png"><img src="orcamentos.png" border="0" width=800 height=400></a>');
                    WriteLn(F,'<br>');
                    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                    WriteLn(F,' <tr  bgcolor=#'+Form1.sHtmlCor+' align=left>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Data<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Cliente<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">Total<br></th>');
                    WriteLn(F,'   <th   bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif, Helvetica" size="1" color="#000000">NF<br></th>');

                    WriteLn(F,'  </tr>');

                    III     := 0;
                    fTotal  := 0;
                    fTotal1 := 0;
                    fTotal2 := 0;

                    while not Form1.IBQuery1.Eof do
                    begin
                      Application.ProcessMessages;

                      WriteLn(F,'   <tr>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('DATA').AsString+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('CLIFOR').AsString+'<br></font></td>'); // Sandro Silva 2024-05-13 WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('CLIENTE').AsString+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form1.ibQuery1.FieldByname('VTOT').AsFloat])+'<br></font></td>');
                      WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('NUMERONF').AsString+'<br></font></td>');
                      WriteLn(F,'   </tr>');

                      fTotal  := fTotal + Form1.ibQuery1.FieldByname('VTOT').AsFloat;

                      if AllTrim(Form1.ibQuery1.FieldByname('NUMERONF').AsString)<>'' then
                      begin
                        fTotal1  := fTotal1 + Form1.ibQuery1.FieldByname('VTOT').AsFloat;
                      end else
                      begin
                        fTotal2  := fTotal2 + Form1.ibQuery1.FieldByname('VTOT').AsFloat;
                      end;

                      Form1.ibQuery1.Next;
                    end;

                    WriteLn(F,'   <tr>');
                    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotal])+'<br></font></td>');
                    WriteLn(F,'    <td '+{nowrap}' valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    WriteLn(F,'   </tr>');
                    WriteLn(F,'  </table>');

                    Mais1Ini.WriteString('DADOS','XY'+StrZero(1,2,0),'S1<'+
                      StrTran(Format('%15.2n',[ftotal1]),'.','')
                        +'>S2<'+'0,00'+'>VX<'+StrZero(III,2,0)+'>LX<Faturados>');
                    Mais1Ini.WriteString('DADOS','XY'+StrZero(2,2,0),'S1<'+
                      StrTran(Format('%15.2n',[ftotal2]),'.','')
                        +'>S2<'+'0,00'+'>VX<'+StrZero(III,2,0)+'>LX< >');

                    Mais1Ini.Free;
                    ShellExecute( 0, 'Open', 'graficos.exe', 'orcamentos.gra SMALL', '', SW_SHOWMINNOACTIVE);
                    while not FileExists(Form1.sAtual+'\orcamentos.png') do sleep(100);
                  except
                    on E: Exception do
                    begin
                      WriteLn(F,'  <br>Erro nos dados: '+E.Message);
                    end;
                  end;
                end;

                // Contas a PAGAR
                if sRelatorio = 'CONTAS A PAGAR' then
                begin
                  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>'+ sRelatorio +'</b></font>');

                  try
                    dInicio :=  Date -1;
                    dFinal  :=  Date + 30;

                    dInicio := StrToDate(DateToStr(dInicio));
                    dFinal  := StrToDate(DateToStr(dFinal ));

                    // GRAFICO
                    DeleteFile(pChar(Form1.sAtual+'\PAGAR.png'));
                    DeleteFile(pChar(Form1.sAtual+'\PAGAR.gra'));

                    // cria o gráfico de receeber PAGAR.png
                    Mais1ini := TIniFile.Create(Form1.sAtual+'\PAGAR.gra');
                    Mais1Ini.WriteString('DADOS','3D','0');
                    Mais1Ini.WriteString('DADOS','Titulo','');
                    Mais1Ini.WriteString('DADOS','NomeBmp','PAGAR.png');
                    Mais1Ini.WriteString('DADOS','TituloY','R$');
                    Mais1Ini.WriteString('DADOS','TipoS1','0');
                    Mais1Ini.WriteString('DADOS','Titulo','');
                    Mais1Ini.WriteString('DADOS','Legenda','0');
                    Mais1Ini.WriteString('DADOS','Legenda','0');
                    Mais1Ini.WriteString('DADOS','MarcasS1','1');
                    Mais1Ini.WriteString('DADOS','TituloX','Dia');
                    Mais1Ini.WriteString('DADOS','AlturaBmp','1000');
                    Mais1Ini.WriteString('DADOS','LarguraBmp','2000');
                    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde

                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select sum(VALOR_DUPL) as TOTAL, VENCIMENTO from PAGAR where VENCIMENTO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENCIMENTO>='+QuotedStr(DateToStrInvertida(dInicio))+'group by VENCIMENTO order by VENCIMENTO');
                    Form1.ibQuery1.Open;

                    III := 0;

                    Form1.ibQuery1.First;
                    while not Form1.ibQuery1.EOF do
                    begin
                      Application.ProcessMessages;

                      III := III + 1;
                      Mais1Ini.WriteString('DADOS','XY'+StrZero(III,2,0),'S1<'+
                      StrTran(Format('%15.2n',[Form1.ibQuery1.FieldByname('TOTAL').AsFloat]),'.','')
                        +'>S2<'+'0,00'
                                        +'>VX<'+StrZero(III,2,0)+'>LX<'+Copy(Form1.ibQuery1.FieldByname('VENCIMENTO').AsString,1,5)+'>');
                      Form1.ibQuery1.Next;
                    end;

                    WriteLn(F,'     <center><a href="'+Form1.sAtual+'\PAGAR.png"><img src="PAGAR.png" border="0" width=800 height=400></a>');

                    Mais1Ini.Free;

                    ShellExecute( 0, 'Open', 'graficos.exe', 'PAGAR.gra SMALL', '', SW_SHOWMINNOACTIVE);
                    while not FileExists(Form1.sAtual+'\PAGAR.png') do sleep(100);

                    Writeln(F,'<br><br><font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br>');
                    WriteLn(F,'</center>');
                  except
                    on E: Exception do
                    begin
                      WriteLn(F,'  <br>Erro nos dados: '+E.Message);
                    end;
                  end;
                end;

                // Contas a RECEBER
                if sRelatorio = 'CONTAS A RECEBER' then
                begin
                  WriteLn(F,'<br><font face="Microsoft Sans Serif" size=3 color=#000000><b>'+ sRelatorio +'</b></font>');

                  try
                    dInicio :=  Date -1;
                    dFinal  :=  Date + 30;

                    dInicio := StrToDate(DateToStr(dInicio));
                    dFinal  := StrToDate(DateToStr(dFinal ));

                    // GRAFICO
                    DeleteFile(pChar(Form1.sAtual+'\RECEBER.png'));
                    DeleteFile(pChar(Form1.sAtual+'\RECEBER.gra'));

                    // cria o gráfico de receeber RECEBER.png //
                    Mais1ini := TIniFile.Create(Form1.sAtual+'\RECEBER.gra');
                    Mais1Ini.WriteString('DADOS','3D','0');
                    Mais1Ini.WriteString('DADOS','Titulo','');
                    Mais1Ini.WriteString('DADOS','NomeBmp','RECEBER.png');
                    Mais1Ini.WriteString('DADOS','TituloY','R$');
                    Mais1Ini.WriteString('DADOS','TipoS1','0');
                    Mais1Ini.WriteString('DADOS','Titulo','');
                    Mais1Ini.WriteString('DADOS','Legenda','0');
                    Mais1Ini.WriteString('DADOS','Legenda','0');
                    Mais1Ini.WriteString('DADOS','MarcasS1','1');
                    Mais1Ini.WriteString('DADOS','TituloX','Dia');
                    Mais1Ini.WriteString('DADOS','AlturaBmp','1000');
                    Mais1Ini.WriteString('DADOS','LarguraBmp','2000');
                    Mais1Ini.WriteString('DADOS','CorS1','$008FC26C'); // Verde

                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select sum(VALOR_DUPL) as TOTAL, VENCIMENTO from RECEBER where VENCIMENTO<='+QuotedStr(DateToStrInvertida(dFinal))+' and VENCIMENTO>='+QuotedStr(DateToStrInvertida(dInicio))+'group by VENCIMENTO order by VENCIMENTO');
                    Form1.ibQuery1.Open;

                    III := 0;

                    Form1.ibQuery1.First;
                    while not Form1.ibQuery1.EOF do
                    begin
                      Application.ProcessMessages;

                      III := III + 1;
                      Mais1Ini.WriteString('DADOS','XY'+StrZero(III,2,0),'S1<'+
                      StrTran(Format('%15.2n',[Form1.ibQuery1.FieldByname('TOTAL').AsFloat]),'.','')
                        +'>S2<'+'0,00'
                                        +'>VX<'+StrZero(III,2,0)+'>LX<'+Copy(Form1.ibQuery1.FieldByname('VENCIMENTO').AsString,1,5)+'>');

                      Form1.ibQuery1.Next;
                    end;

                    WriteLn(F,'     <center><a href="'+Form1.sAtual+'\RECEBER.png"><img src="RECEBER.png" border="0" width=800 height=400></a>');

                    Mais1Ini.Free;

                    ShellExecute( 0, 'Open', 'graficos.exe', 'RECEBER.gra SMALL', '', SW_SHOWMINNOACTIVE);
                    while not FileExists(Form1.sAtual+'\RECEBER.png') do sleep(100);

                    Writeln(F,'<br><br><font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br>');
                    WriteLn(F,'</center>');
                  except
                    on E: Exception do
                    begin
                      WriteLn(F,'  <br>Erro nos dados: '+E.Message);
                    end;
                  end;
                end;

                // The end
                WriteLn(F,'<br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
                + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
                + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');

                WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>Relatório gerado pelo sistema Small, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
                WriteLn(F,'</html>');

                CloseFile(F);                                    // Fecha o arquivo

                HtmlParaPdf(pChar(sNome));
                UploadMobile(pChar(sNome+'.pdf'));
              except
              end;
            end;
            Screen.Cursor             := crDefault;                   // Cursor normal
          end;
          sTLista.Clear;
          sTLista.Free;
        end;
      except
      end;

      // The End Importar Relatorios
      Form1.Label200.Tag    := 0;
      Timer2.Enabled        := True;
    end;
  end;

  if FileExists(Form1.sAtual+'\fechatudo.txt') then
  begin
    Form1.Close;
    sleep(1000);
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
  end;
end;


procedure TForm1.timerLegalTimer(Sender: TObject);
begin
  try
    //Só consulta se sistema estiver liberado
    if ExecutaComandoEscalar(Form7.IBTransaction1,
                            'Select gen_id(G_LEGAL,0) From rdb$database') = 0 then
    begin
      RegistrodoPrograma(False);
    end;
  except
  end;
end;

procedure TForm1.ConfiguraodaNFemformulrionumerado1Click(Sender: TObject);
begin
  Form7.sTitulo         := 'Configuração da NF';
  Form7.sRPS := 'N';
  Form7.Close;
  Form7.sModulo         := 'NOTA';
  Form7.Show;
end;

procedure TForm1.N3101Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Form1.N301.Checked  := False;
  Form1.N3101.Checked := True;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Layout','3.10');
  Form1.sVersaoLayout := '3.10';
  Mais1ini.Free;

  ConfiguraNFE;
end;

procedure TForm1.SVCSefazVirtualdeContingncia1Click(Sender: TObject);
begin
  if bModoSVC then bModoSVC := False else bModoSVC := True;
  if bModoSVC then SVCSefazVirtualdeContingncia1.Checked := True else SVCSefazVirtualdeContingncia1.Checked := False;
end;

procedure TForm1.imgCaixaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FileExists(Form1.sAtual+'\inicial\fundo\_small_4.bmp') then
    Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_4.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp');
end;


procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Mauricio Parizotto 2023-09-26
  if Form7.sModulo = 'PARAMETROTRIBUTACAO' then
    Exit;

  //Mauricio Parizotto 2023-11-17
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
    Exit;

  //Mauricio Parizotto 2023-11-17
  if Form7.sModulo = 'ICM' then
    Exit;

  //Mauricio Parizotto 2024-03-21
  if Form7.sModulo = 'CONVERSAOCFOP' then
    Exit;
  {Mauricio Parizotto 2024-04-05 Inicio}
  if Form7.sModulo = 'CONVENIO' then
    Exit;

  if Form7.sModulo = 'CAIXA' then
    Exit;

  if Form7.sModulo = 'GRUPOS' then
    Exit;

  if Form7.sModulo = 'TRANSPORT' then
    Exit;

  if Form7.sModulo = 'CONTAS' then
    Exit;

  if Form7.sModulo = 'BANCOS' then
    Exit;

  if Form7.sModulo = '2CONTAS' then
    Exit;
  {Mauricio Parizotto 2024-04-05 Fim}

  {Mauricio Parizotto 2024-04-16 Inicio}
  if Form7.sModulo = 'PAGAR' then
    Exit;

  if Form7.sModulo = 'RECEBER' then
    Exit;
  {Mauricio Parizotto 2024-04-16 Fim}

  if Form7.sModulo = 'CLIENTES' then
   Exit;

  //Mauricio Parizotto 2024-07-17
  if Form7.sModulo = 'ESTOQUE' then
   Exit;


  if AllTrim(Form7.sModulo) <> '' then
  begin
    if ((Form7.sModulo = 'VENDA') or (Form7.sModulo = 'DESCONTO') or (Form7.sModulo = 'DESCONTO1')) or ((Form7.sModulo = 'COMPRA') or (Form7.sModulo = 'FRETE')) then
    begin
      if ((Form7.sModulo = 'VENDA') or (Form7.sModulo = 'DESCONTO') or (Form7.sModulo = 'DESCONTO1')) then
      begin
        if (Form12.Visible) then
          Form12.BringToFront
        else
          Form7.BringToFront;
      end;

      if ((Form7.sModulo = 'COMPRA') or (Form7.sModulo = 'FRETE')) then
      begin
        if (Form24.Visible) then
          Form24.BringToFront
        else
          Form7.BringToFront;
      end;
    end else
    begin
      if (Form7.sModulo = 'OS') then
      begin
        if (Form30.Visible) then
          Form30.BringToFront
        else
          Form7.BringToFront;
      end else
      begin
        {Mauricio Parizotto 2024-07-17
        if Form10.Visible then
        begin
          Form10.BringToFront;
        end else}
        begin
          if (Form7.sModulo = 'NOTA') or (Form7.sModulo = 'CONFOS') or (Form7.sModulo = 'CONFRECIBO') then
          begin
            Form1.Panel_3.Visible := False;
            Form7.BringToFront;
            Form4.BringToFront;
          end else
          begin
            Form7.BringToFront;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.Label202MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone ESTOQUE
  if Label202.Font.Style <> [fsBold] then
  begin
    imgEstoque.Picture    := Image202_X.Picture;
    Label202.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_8.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_8.bmp') ;

      Titulo('CONTROLE O '+chr(10)+
             'ESTOQUE'
             ,
             'O controle de estoque bem'+chr(10)+
             'organizado evita prejuízos'+chr(10)+
             'e garante uma maior'+chr(10)+
             'margem de lucro'
            );
    end;
  end;
end;

procedure TForm1.Label201_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone OS
  if Label201_.Font.Style <> [fsBold] then
  begin
    imgOrdemServico.Picture    := Image201__X.Picture;
    Label201_.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_9.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_9.bmp') ;

      Titulo(
            'UTILIZE A ORDEM '+chr(10)+
            'DE SERVIÇOS'
            ,
            'A Ordem de Serviços facilita'+chr(10)+
            'o atendimento ao cliente'+chr(10)+
            'e organiza e mantém todo'+chr(10)+
            'o trabalho documentado'
            , 'SERVIÇO'
            );
    end;
  end;
end;

procedure TForm1.Label203MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone CADASTRO
  if Label203.Font.Style <> [fsBold] then
  begin
    imgCliFor.Picture    := Image203_X.Picture;
    Label203.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_1.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_1.bmp') ;

      Titulo('MANTENHA O CADASTRO'+chr(10)+'ATUALIZADO',
             'O cadastro com as informações'+chr(10)+
             'corretamente registradas'+chr(10)+
             'conserva seus canais de'+chr(10)+
             'comunicação com clientes,'+chr(10)+
             'fornecedores, funcionários,'+chr(10)+
             'entre outros'
             );
    end;
  end;
end;

procedure TForm1.Label204MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move RECEBER
  if Label204.Font.Style <> [fsBold] then
  begin
    imgContaReceber.Picture    := Image204_X.Picture;
    Label204.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_2.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_2.bmp') ;

      Titulo(
             'MONITORE AS CONTAS'+chr(10)+
             'A RECEBER'
             ,
             'As contas a receber bem controladas'+chr(10)+
             'diminuem o impacto que a inadimplência'+chr(10)+
             'pode ter em seu negócio'
             , 'RECEBER'
             );
    end;
  end;
end;

procedure TForm1.Label205MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move CAIXA
  if Label205.Font.Style <> [fsBold] then
  begin
    imgCaixa.Picture    := Image205_X.Picture;
    Label205.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_4.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_4.bmp') ;

      Titulo(
            'CONTROLE O '+chr(10)+
            'CAIXA'
            ,
            'O fechamento exato do caixa permite'+chr(10)+
            'total controle financeiro'+chr(10)+
            'auxiliando na tomadas de'+chr(10)+
            'decisões através da'+chr(10)+
            'análise das contas'
            , 'CAIXA'
            );
    end;
  end;
end;

procedure TForm1.Label206MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move BANCOS
  if Label206.Font.Style <> [fsBold] then
  begin
    imgBancos.Picture    := Image206_X.Picture;
    Label206.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_5.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_5.bmp') ;

      Titulo(
            'FIQUE DE OLHO NOS '+chr(10)+
            'BANCOS'
            ,
            'O controle rigoroso das contas'+chr(10)+
            'bancárias previne o pagamento'+chr(10)+
            'de juros e permite um'+chr(10)+
            'planejamento dos'+chr(10)+
            'investimentos'
            , 'BANCOS'
            );
    end;
  end;
end;

procedure TForm1.Label207MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move CONFIG
  if Label207.Font.Style <> [fsBold] then
  begin
    imgConfiguracoes.Picture    := Image207_X.Picture;
    Label207.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_6.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_6.bmp') ;

      Titulo(
            'CONFIGURE'+chr(10)+
            'O SISTEMA'
            ,
            'A configuração correta, ajusta'+chr(10)+
            'o sistema de acordo com as'+chr(10)+
            'particularidades da'+chr(10)+
            'sua empresa'
            );
    end;
  end;
end;

procedure TForm1.Label208MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move BACKUP
  if Label208.Font.Style <> [fsBold] then
  begin
    imgBackup.Picture    := Image208_X.Picture;
    Label208.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_7.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_7.bmp') ;

      Titulo(
            'FAÇA BACKUP'+chr(10)+
            'TODOS OS'+chr(10)+
            'DIAS'
            ,
            'O Backup é a única forma de'+chr(10)+
            'manter seus dados'+chr(10)+
            'seguros'+chr(10)+chr(10)+
            Form1.imgBackup.Hint
            );
    end;
  end;
end;

procedure TForm1.Label210MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move PAGAR
  if Label210.Font.Style <> [fsBold] then
  begin
    imgContaPagar.Picture    := Image210_X.Picture;
    Label210.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_3.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_3.bmp') ;

      Titulo(
            'ORGANIZE AS CONTAS'+chr(10)+
            'A PAGAR'
            ,
            'As contas a pagar bem organizadas geram'+chr(10)+
            'uma previsão dos compromissos'+chr(10)+
            'financeiros facilitando o'+chr(10)+
            'controle do fluxo'+chr(10)+
            'de caixa'
            , 'PAGAR'
            );
    end;
  end;
end;

procedure TForm1.Label_fecha_0Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.RichEdit1Enter(Sender: TObject);
begin
  Edit2.SetFocus;
end;

procedure TForm1.Fuso1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
  sMensagem : STring;
begin
  sMensagem := 'Fuso normal em '+Form7.ibDataSet13ESTADO.AsString+': -03:00';

  if Form7.ibDataSet13ESTADO.AsString = 'SC' then
  begin
   sMensagem := 'Fuso normal em SC: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'RS' then
  begin
   sMensagem := 'Fuso normal em RS: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'PR' then
  begin
   sMensagem := 'Fuso normal em PR: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'SP' then
  begin
   sMensagem := 'Fuso normal em SP: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'RJ' then
  begin
   sMensagem := 'Fuso normal em RJ: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'MG' then
  begin
   sMensagem := 'Fuso normal em MG: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'ES' then
  begin
   sMensagem := 'Fuso normal em ES: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'GO' then
  begin
   sMensagem := 'Fuso normal em GO: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'MT' then
  begin
   sMensagem := 'Fuso normal em MT: -04:00'+chr(10)+'Fuso horário de verão: -03:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'MS' then
  begin
   sMensagem := 'Fuso normal em MS: -04:00'+chr(10)+'Fuso horário de verão: -03:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'DF' then
  begin
   sMensagem := 'Fuso normal em DF: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'TO' then
  begin
   sMensagem := 'Fuso normal em TO: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;

  Form7.sFuso := Small_InputForm('Fuso horário',sMensagem+Chr(10)+Chr(10)+Chr(10)+'Informe o fuso horário:',Form7.sFuso);

  if (Form7.sFuso = '-03:00') or (Form7.sFuso = '-02:00') or (Form7.sFuso = '-04:00') then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    Mais1Ini.WriteString('NFE','FUSO',Form7.sFuso);
    Mais1Ini.Free;

    //ShowMessage('Novo fuso horário gravado: '+Form7.sFuso); Mauricio Parizotto 2023-10-25
    MensagemSistema('Novo fuso horário gravado: '+Form7.sFuso);
  end else
  begin
    //ShowMessage('Fuso horário inválido: '+chr(10)+chr(10)+chr(10)+sMensagem); Mauricio Parizotto 2023-10-25
    MensagemSistema('Novo fuso horário gravado: '+Form7.sFuso,msgAtencao);
  end;
end;

procedure TForm1.Label200MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone MOBILE
  if Label200.Font.Style <> [fsBold] then
  begin
    imgIndicadores.Picture    := Image200_X.Picture;
    Label200.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_0.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_0.bmp') ;

      Titulo(
            'ACOMPANHE OS'+chr(10)+
            'INDICADORES'
            ,
            'Configure um painel de indicadores'+chr(10)+
            'personalizado por usuário de'+chr(10)+
            'acordo com as necessidades'+chr(10)+
            'gerenciais da sua empresa'+chr(10)
            , 'INDICADORES'
            );
    end;
  end;
end;

procedure TForm1.AutoSmallMobile1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  //
  if AutoSmallMobile1.Checked then
  begin
    Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Não');
    AutoSmallMobile1.Checked := False;
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // AutoSmallMobile1Click
  end else
  begin
    AutoSmallMobile1.Checked := True;
    Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Sim');
    Form1.Timer2.Enabled := True;

    if Legal(True) then
    begin
      if not ConsultaProcesso('mobile.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mobile.exe', pChar(Form7.ibDataSet13CGC.AsString) , '', SW_SHOW); // AutoSmallMobile1Click
      end;
    end;
  end;

  Mais1ini.Free;
end;

procedure TForm1.imgIndicadoresClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  if ValidaRecursoExibeMensagemIndisponivel then
  begin
    Form7.sModulo := 'INDICADORES';
    Form1.Label201MouseLeave(Sender);
    //
    try
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      //
      if not FechaTudo(bFechaTudo) then
        Exit;
      try
        if form7.Visible then Form7.Close;
//        if form10.Visible then Form10.Close;
      except end;
    except end;

    try
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      //
      if Form24.Visible then Form24.Close;
      if Form12.Visible then Form12.Close;
      if Form7.Visible then Form7.Close;
      if Form30.Visible then Form30.Close;
      if Form48.Visible then Form48.Close;
      //
      Form1.Enabled := False;
      Form5.Enabled := False;
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      Form5.Show;
      Form5.Repaint;
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      //
      try
        // Só se for necessário
        Form7.ibDataSet101.Close;
        Form7.ibDataSet101.SelectSql.Clear;
        Form7.ibDataset101.SelectSql.Add('select gen_id(G_MUTADO,0) from rdb$database');
        Form7.ibDataset101.Open;
        //
        if (Form7.ibDataSet101.FieldByname('GEN_ID').AsFloat <> Form5.fMutado) then // or (Form7.ibDataSet100.FieldByname('GEN_ID').AsFloat = 0) then
        begin
          Form5.fMutado := Form7.ibDataSet101.FieldByname('GEN_ID').AsFloat;
          //
          AgendaCommit(True);
          Commitatudo(True); // SQL - Commando
          AbreArquivos(False);
          if not Form1.IBTransaction2.Active then
            Form1.IBTransaction2.Active := True;
          Form1.IBTransaction2.Commit;
          //
          Form5.BringToFront;
          Form5.ScrollBox1DblClick(Sender);
        end;
      except
      end;

      Screen.Cursor := crDefault; // Cursor de Aguardo
      Form5.Enabled := True;
      Form1.Enabled := True;
    except
    end;

    Screen.Cursor := crDefault; // Cursor de Aguardo
  end;
end;

procedure TForm1.CNPJdacontabilidade1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

  Form7.sCNPJContabilidade := Small_InputForm('','Informe o CNPJ do Escritório de Contabilidade'+chr(10)+'(Isso dará a ele acesso aos XML da NF-e´s emitidas):',Form7.sCNPJContabilidade);

  if CPFCGC(Form7.sCNPJContabilidade) then
  begin
    Mais1Ini.WriteString('XML','CNPJ da Contabilidade',Form7.sCNPJContabilidade);
  end else
  begin
    //ShowMessage('CNPJ/CPF inválido'); Mauricio Parizotto 2023-10-25
    MensagemSistema('CNPJ/CPF inválido',msgAtencao);
  end;

  Mais1Ini.Free;
  Form1.AvisoConfig(True);
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br/loja/atualiza-via-small?serial='
  +AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))
  +'&cnpj='+LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString))
  ,'', '', SW_SHOWMAXIMIZED);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sS : sTring;
begin
  Timer2.Enabled            := False;
  Timer1.Enabled            := False;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  Form7.ibDataSet2.Disablecontrols;
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where Upper(OBS) like ''%REVENDA%''');  //
  Form7.ibDataSet2.Open;

  Form7.ibDataset2.First;

  while not Form7.ibDataset2.Eof do
  begin
    try
      if Pos('{',Form7.ibDataset2OBS.AsString) <> 0 then
      begin
        sS := Copy(Form7.ibDataset2OBS.AsString,Pos('{',Form7.ibDataset2OBS.AsString)+1,Pos('}',Form7.ibDataset2OBS.AsString)-Pos('{',Form7.ibDataset2OBS.AsString)-1);
      end else
      begin
        sS := '';
      end;

      Form7.ibDataset2.Edit;
      Form7.ibDataset2CONTATOS.AsString := '';
      Form7.ibDataset2OBS.AsString := 'REVENDA {'+sS+'}';
      Form7.ibDataset2.Post;
    except
    end;

    Form7.ibDataset2.Next;
  end;

  Form7.ibDataSet2.EnableControls;
  Screen.Cursor := crDefault;
end;

procedure TForm1.N4001Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Form1.N301.Checked  := False;
  Form1.N3101.Checked := True;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Layout','4.00');
  Form1.sVersaoLayout := '4.00';
  Mais1ini.Free;

  ConfiguraNFE;
end;

procedure TForm1.Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //Mauricio Parizotto 2023-09-26
  if Form7.sModulo = 'PARAMETROTRIBUTACAO' then
    Exit;

  //Mauricio Parizotto 2023-11-17
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
    Exit;

  //Mauricio Parizotto 2023-11-17
  if Form7.sModulo = 'ICM' then
    Exit;
  {Mauricio Parizotto 2024-04-05 Inicio}
  if Form7.sModulo = 'CONVENIO' then
    Exit;

  if Form7.sModulo = 'CAIXA' then
    Exit;

  if Form7.sModulo = 'GRUPOS' then
    Exit;

  if Form7.sModulo = 'TRANSPORT' then
    Exit;

  if Form7.sModulo = 'CONTAS' then
    Exit;

  if Form7.sModulo = 'BANCOS' then
    Exit;

  if Form7.sModulo = '2CONTAS' then
    Exit;
  {Mauricio Parizotto 2024-04-05 Fim}
  
  //Mauricio Parizotto 2024-03-21
  if Form7.sModulo = 'CONVERSAOCFOP' then
    Exit;

  {Mauricio Parizotto 2024-04-16 Inicio}
  if Form7.sModulo = 'PAGAR' then
  begin
    if FrmContaPagar <> nil then
    begin
      if FrmContaPagar.Visible then
      begin
        FrmContaPagar.BringToFront;
        Exit;
      end;
    end;
  end;

  if Form7.sModulo = 'RECEBER' then
  begin
    if FrmContaReceber <> nil then
    begin
      if FrmContaReceber.Visible then
      begin
        FrmContaReceber.BringToFront;
        Exit;
      end;
    end;
  end;
  {Mauricio Parizotto 2024-04-16 Fim}


  {Mauricio Parizotto 2024-05-15 Inicio}
  if Form7.sModulo = 'CLIENTES' then
  begin
    if FrmCadastro <> nil then
    begin
      if FrmCadastro.Visible then
      begin
        FrmCadastro.BringToFront;
        Exit;
      end;
    end;
  end;

  //Mauricio Parizotto 2024-04-17
  if Form7.sModulo = 'ESTOQUE' then
  begin
    if FrmEstoque <> nil then
    begin
      if FrmEstoque.Visible then
      begin
        FrmEstoque.BringToFront;
        Exit;
      end;
    end;
  end;

  if Form5.Visible then
  begin
    Form5.BringToFront;
    Exit;
  end;

  {Mauricio Parizotto 2024-07-17
  if Form7.Visible and Form10.Visible then
  begin
    Form10.BringToFront;
    Exit;
  end;
  }

  if Form12.Visible then
  begin
    Form12.BringToFront;
    Exit;
  end;

  if Form24.Visible then
  begin
    Form24.BringToFront;
    Exit;
  end;

  if Form48.Visible then
  begin
    Form48.BringToFront;
    Exit;
  end;

  {Sandro Silva 2023-08-07 inicio}
  if Form30.Visible then
  begin
    // Se estiver com tela de lançamento de OS aberta e movimentar o mouse, mantem a tela de lançamento sobre as demais
    Form30.BringToFront;
    Exit;
  end;
  {Sandro Silva 2023-08-07 fim}

  if Form7.Visible then
  begin
    Form7.BringToFront;
    Exit;
  end;
end;

function TForm1.RetornarWhereNotasManifestar: String;
begin
  {Sandro Silva 2023-06-15 inicio
  Result := '((Coalesce(MDESTINXML,''~'') like ''%<tpEvento>210210%'') and (MERCADORIA=0))' + sLineBreak +
            'OR ((Coalesce(MDESTINXML,'''')='''') AND (COALESCE(REPLACE(NFEID, ''0'', ''''),'''')<>''''))';
  }
  Result :=
    'EMISSAO >= (current_date - ' + PRAZO_MANIFESTAR + ') and ' + // emitida dentro de limite de tempo para fazer o manifesto
    'substring(NFEID from 21 for 2) = ''55'' and ' +  // listar apenas 55=NF-e
    '(' +
    '  (' +
    '    (coalesce(MDESTINXML, ''~'') like ''%<tpEvento>210210%'') and (MERCADORIA = 0)' +
    '  )' +
    '  or' +
    '  (' +
    '    (coalesce(MDESTINXML, '''') = '''') and (coalesce(replace(NFEID, ''0'', ''''), '''') <> '''')' +
    '  )' +
    ')';
end;

procedure TForm1.Label_bola_NFEClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  if Form1.bNotaCompraLiberada then
  begin
    Form1.imgVendasClick(Sender);
    Form7.Compras_1Click(Sender);

    Form7.ibDataSet24.DisableControls;

    //LogRetaguarda('Form7.ibDataSet24.DisableControls 11712'); // Sandro Silva 2023-11-27

    try
      Form7.ibDataSet24.Close;
      Form7.ibDataSet24.SelectSQL.Clear;
      // Sandro Silva 2023-06-15 Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where ' + RetornarWhereNotasManifestar);
      Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where ' + RetornarWhereNotasManifestar + ' order by EMISSAO, FORNECEDOR');
      Form7.ibDataSet24.Open;
    except end;

    Form7.ibDataSet24.EnableControls;
    //LogRetaguarda('Form7.ibDataSet24.EnableControls; 11723'); // Sandro Silva 2023-11-27
  end;

  Aviso('Temos '+InttoStr(Form1.iAvisosNFECompra)+' NF-e´s de entrada para manifestar ciência'+chr(10)+'e importar o XML nos últimos ' + PRAZO_MANIFESTAR + ' dias.'); // Sandro Silva 2023-06-20 Aviso('Temos '+InttoStr(Form1.iAvisosNFECompra)+' NF-e´s de entrada para manifestar ciência'+chr(10)+'e importar o XML.');
end;

procedure TForm1.Label_bola_caixaClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  Form1.imgCaixaClick(Sender);

  Form7.ibDataSet1.DisableControls;

  try
    Form7.ibDataSet1.Close;
    Form7.ibDataSet1.SelectSQL.Clear;
    Form7.ibDataSet1.SelectSQL.Add('select * from CAIXA  where coalesce(NOME,'+QuotedStr('')+')='+QuotedStr('')+' ');
    Form7.ibDataSet1.Open;
  except end;

  Form7.ibDataSet1.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosCaixa)+' lançamentos no caixa não identificados'+chr(10)+'no (Plano De contas).');
end;

procedure TForm1.Label_bola_bancoClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  Form1.imgBancosClick(Sender);
  Form7.Lanamentosnocompensados1Click(Sender);
  Aviso('Temos '+InttoStr(Form1.iAvisosBanco)+' lançamentos não conciliados.');
  Screen.Cursor            := crDefault;
end;

procedure TForm1.Label_bola_pagarClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  Form1.imgContaPagarClick(Sender);

  Form7.ibDataSet8.DisableControls;

  try
    Form7.ibDataSet8.Close;
    Form7.ibDataSet8.SelectSQL.Clear;
    Form7.ibDataSet8.SelectSQL.Add('select * from PAGAR where VALOR_PAGO=0 and VENCIMENTO=CURRENT_DATE');
    Form7.ibDataSet8.Open;
  except
  end;

  Form7.ibDataSet8.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosPagar)+' contas para pagar hoje.');
end;

procedure TForm1.Label_bola_cliforClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form1.imgCliForClick(Sender);

  Form7.ibDataSet2.DisableControls;

  try
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.SelectSQL.Clear;
    Form7.ibDataSet2.SelectSQL.Add('select * from CLIFOR where PROXDATA=CURRENT_DATE');
    Form7.ibDataSet2.Open;
  except
  end;

  Form7.ibDataSet2.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosClifor)+' clientes agendados para hoje.');
end;

procedure TForm1.Label_bola_receberClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  Form1.imgContaReceberClick(Sender);

  Form7.ibDataSet7.DisableControls;

  try
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.SelectSQL.Clear;
    Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where ' + SQL_CONDICAO_RECEBER_HOJE); // Sandro Silva 2023-09-12 Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where VALOR_RECE=0 and VENCIMENTO=CURRENT_DATE');
    Form7.ibDataSet7.Open;
  except
  end;

  Form7.ibDataSet7.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosReceber)+' contas para receber hoje.');
end;

procedure TForm1.Label_Bola_estoqueClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form1.imgEstoqueClick(Sender);

  Form7.ibDataSet4.DisableControls;

  try
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.SelectSQL.Clear;
    Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where QTD_ATUAL<QTD_MINIM and  coalesce(ATIVO,0)<>1');
    Form7.ibDataSet4.Open;
  except end;

  Form7.ibDataSet4.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosEstoque)+' itens abaixo da quantidade mínima.');
end;

procedure TForm1.Label_Bola_ConfigClick(Sender: TObject);
var
  sMSG : String;
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  if Form7.Visible then Form7.Close;
//  if Form10.Visible then Form10.Close;

  try
    sMSG := '';
    if Pos('@',Form7.ibDataSet13EMAIL.AsString)      = 0    then
      sMSG := sMSG + 'Configure o e-mail no cadastro do emitente.'+chr(10);
    if LimpaNumero(Form7.ibDataSet13TELEFO.AsString) = ''   then
      sMSG := sMSG + 'Configure o telefone no cadastro do emitente.'+chr(10);
    if AllTrim(Form7.ibDataSet13ESTADO.AsString)     = ''   then
      sMSG := sMSG + 'Configure a UF no cadastro do emitente.'+chr(10);
    {Sandro Silva 2022-10-31 inicio}
    if (Form1.ValidaEmitenteMunicipio = False) then
      sMSG := sMSG + 'Configure o Município no cadastro do emitente.'+chr(10);
    {Sandro Silva 2022-10-31 fim}
    if AllTrim(Form7.sCNPJContabilidade)             = ''   then
      sMSG := sMSG + 'Configure o CNPJ da contabilidade.'+chr(10);
  except
  end;

  if AllTrim(sMSG) <> '' then
  begin
    sMSG := 'Temos que acertar isso: '+ chr(10) + chr(10) + sMSG +chr(10);
  end;

  Aviso(sMSG);

  try
    if (Pos('@',Form7.ibDataSet13EMAIL.AsString)=0) or
       (LimpaNumero(Form7.ibDataSet13TELEFO.AsString)='') or
       (AllTrim(Form7.ibDataSet13ESTADO.AsString)='')
      or (Form1.ValidaEmitenteMunicipio = False)
    then
    begin
      try
        Form17 := TForm17.Create(nil);
        Form17.ShowModal;
      finally
        FreeAndNil(Form17);
      end;
    end;
    if AllTrim(Form7.sCNPJContabilidade) = '' then
    begin
      Form1.CNPJdacontabilidade1Click(Sender);
    end;
  except
  end;
end;

procedure TForm1.Label_bola_OSClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  imgOrdemServicoClick(Sender);

  Form7.ibDataSet3.DisableControls;

  try
    Form7.ibDataSet3.Close;
    Form7.ibDataSet3.SelectSQL.Clear;
    Form7.ibDataSet3.SelectSQL.Add('select * from OS where DATA_PRO=CURRENT_DATE ');
    Form7.ibDataSet3.Open;
  except
  end;

  Form7.ibDataSet3.EnableControls;

  Aviso('Temos '+InttoStr(Form1.iAvisosOS)+' OS agendadas para hoje.');
end;

procedure TForm1.Label_bola_indicadoresClick(Sender: TObject);
begin
  imgIndicadoresClick(Sender);
end;

procedure TForm1.HorarioDeVeraoClick(Sender: TObject);
begin
  if Form1.HorarioDeVerao.Checked then
  begin
    Form7.sFuso := HabilitaHorarioVerao(Form1.sAtual+'\nfe.ini', 'NFE', 'FUSO', Form7.ibDataSet13ESTADO.AsString, False);
  end else
  begin
    Form7.sFuso := HabilitaHorarioVerao(Form1.sAtual+'\nfe.ini', 'NFE', 'FUSO', Form7.ibDataSet13ESTADO.AsString, True);
  end;
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  try
    ConfiguraNFE;
  except
  end;
end;

procedure TForm1.ConsultarNFesemitidas1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

  if Mais1Ini.ReadString('NFE','Consultar Nfes Emitidas','Sim') = 'Sim' then
    Mais1Ini.WriteString('NFE','Consultar Nfes Emitidas','Não')
  else
    Mais1Ini.WriteString('NFE','Consultar Nfes Emitidas','Sim');

  Mais1Ini.Free;
end;

procedure TForm1.Modoinventrio1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
begin
  if not Modoinventrio1.Checked then
  begin
    try
      //Form7.Close; //Mauricio Parizotto 2023-08-14 causa erro invalid transaction handle f-7258
      Form22.Show;
      Mensagem22('');
      Senhas2.ShowModal;
      Form22.Close;

      Senha2:=Senhas2.SenhaPub2;
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
      sSenha := '';

      // Fórmula para ler a nova senha //
      for I := 1 to (Length(sSenhaX) div 5) do
        sSenha := Chr((StrToInt(
                      Copy(sSenhaX,(I*5)-4,5)
                      )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;

      if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
      begin
        Modoinventrio1.Checked := True;
        MensagemSistema('Liberado a alteração na quantidade dos itens do estoque.');
      end else
      begin
        MensagemSistema('Senha inválida.',msgAtencao);
      end;
    finally
      FreeAndNil(Mais1Ini);
    end;
  end else
  begin
    Modoinventrio1.Checked := False;
  end;
end;

procedure TForm1.AutoMarketplace1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
  sMostra  : string;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');

  if AutoMarketplace1.Checked then
  begin
    Mais1Ini.WriteString('GERAL','MARKETPLACE ATIVO','Não');
    AutoMarketplace1.Checked := False;
    Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // AutoSmallMobile1Click

    {Sandro Silva 2023-01-04 inicio}
    Form1.bMKP := False;
    {Sandro Silva 2023-01-04 fim}
  end else
  begin
    AutoMarketplace1.Checked := True;
    Mais1Ini.WriteString('GERAL','MARKETPLACE ATIVO','Sim');

    //Ativa Coluna Marktplace para o usuário
    sMostra   := Mais1Ini.ReadString('ESTOQUE', 'Mostrar', 'TTTFTTFTFFT'+Replicate('F', 41));
    sMostra  := Copy(sMostra,1,49)+'T'+Copy(sMostra,51,10);
    Mais1Ini.WriteString('ESTOQUE','Mostrar',sMostra);

    Form1.Timer2.Enabled := True;

    if Legal(True) then
    begin
      if not ConsultaProcesso('mkp.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mkp.exe','','', SW_SHOW); // AutoSmallMobile1Click
      end;
    end;

    Form1.bMKP := True;

    Form1.imgEstoqueClick(Sender);
    MensagemSistema('Ative agora os produtos para marketplace');
  end;

  Mais1ini.Free;
end;

procedure TForm1.Hub1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', pChar('https://www.smallhub.com.br/login?doc='+Limpanumero(Form7.ibDAtaSet13CGC.AsString)),'', '', SW_SHOW); // MArketPlace
end;

procedure TForm1.imgComprasClick(Sender: TObject);
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  if not Legal(True) then
    Exit;

  try
    // NFe com CPF
    if Form1.bNotaCompraLiberada then Form7.Compras_1.Enabled := True else Form7.Compras_1.Enabled := False;
    if Form1.bNotaCompraLiberada then Form7.Compras2.Enabled := True else Form7.Compras2.Enabled := False;

    if Form1.bNotaCompraLiberada then
    begin
      Form7.Compras_1Click(Sender);
    end;

    Form1.Label201MouseLeave(Sender);

    if Form24.Visible then
      Form24.Show;
  except
    on E: Exception do
    begin
      MensagemSistema(E.Message,msgErro);
    end;
  end;
end;

procedure TForm1.LAbel201CMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone NF-e
  if Label201C.Font.Style <> [fsBold] then
  begin
    imgCompras.Picture    := Image201C_X.Picture;
    Label201C.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_11.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_11.bmp') ;

      Titulo(
            'CONTROLE AS NOTAS'+Chr(10)+'DE COMPRAS',
            'Controle as entradas de '+chr(10)+
            'mercadoria da sua'+chr(10)+
            'empresa de forma'+chr(10)+
            'automática'
            );
    end;
  end;
end;

procedure TForm1.Label201SMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // Mouse move icone NF-e
  if Label201S.Font.Style <> [fsBold] then
  begin
    imgServicos.Picture    := Image201S_X.Picture;
    Label201S.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_12.bmp') then
        Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_12.bmp');

      Titulo(
            'EMITA A NFS-e DE'+chr(10)+'SERVIÇOS',
            'A Nota Fiscal Eletrônica de Serviços além'+chr(10)+
            'de atender a legislação controla os'+chr(10)+
            'serviços prestados pela sua'+chr(10)+
            'empresa'
            , 'SERVIÇO'
            );
    end;
  end;
end;

procedure TForm1.imgServicosClick(Sender: TObject);
begin
  try
    if Form1.ValidaRecursos.PermiteRecursoParaProduto then
    begin
      if not Legal(True) then
        Exit;

      // NFS-e
      if Form1.bNotaServicoLiberada then
      begin
        Screen.Cursor := crHourGlass; // Cursor de Aguardo
        try
          if not FechaTudo(bFechaTudo) then
            Exit;

          Form7.sModulo := 'VENDA';
          Form7.sTitulo := 'Nota Fiscal de Serviço Eletronica (NFS-e) e Recibo Provisório de Serviços (RPS) RPS';
          Form7.sRPS    := 'S';

          Form7.Show;
        finally
          Screen.Cursor := crDefault; // Cursor de Aguardo
        end;
      end;

      Form1.Label201MouseLeave(Sender);

      if Form48.Visible then
        Form48.Show;
    end
    else
    begin
      MensagemRecursoIndisponivel('NFS-e não está disponível para esta licença');
    end;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-24
      MensagemSistema(E.Message,msgErro);
    end;
  end;
end;

procedure TForm1.Simples1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Preenchimento','Simples');
  //ShowMessage('Layoute de preenchimento definido como simples. Este programa vai ser fechado.'); Mauricio Parizotto 2023-10-25
  MensagemSistema('Layoute de preenchimento definido como simples. Este programa vai ser fechado.');
  Mais1ini.Free;

  Application.Terminate;
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
end;

procedure TForm1.Complexo1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Preenchimento','Comleto');
  //ShowMessage('Layoute de preenchimento definido como completo. Este programa vai ser fechado.');Mauricio Parizotto 2023-10-25
  MensagemSistema('Layoute de preenchimento definido como completo. Este programa vai ser fechado.');
  Mais1ini.Free;

  Application.Terminate;
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
end;

procedure TForm1.ConfiguraesdaNFSe2Click(Sender: TObject);
var
  sPadraoCidade : String;
  _file : TStringList;
  F: TextFile;
  Mais1Ini : tIniFile;
  oArqDAT: TArquivosDAT;
  enAmbienteAnt: tAmbienteNFSe;
  cMsgPadrao: string;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');

  Mais1Ini.WriteString('NFSE','CIDADE',UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString));
  Mais1Ini.WriteString('NFSE','CNPJ',LimpaNumero(Form7.ibDAtaset13CGC.AsString));
  Mais1Ini.WriteString('NFSE','InscricaoMunicipal',LimpaNumero(Form7.ibDAtaset13IM.AsString));
  Mais1ini.Free;

  if Form1.ExisteNfseExe(Form1.sAtual) then
  begin
    oArqDAT := TArquivosDAT.Create(EmptyStr);
    try
      enAmbienteAnt := oArqDAT.NFSe.NFSE.Ambiente;

      while FileExists(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
      begin
        DeleteFile(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2'));
        Sleep(1000);
      end;

      AssignFile(F,pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
      Rewrite(F);

      Writeln(F,'Config=Sim');

      CloseFile(F);

      // Aguarda até criar o arquivo
      while not FileExists(pChar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
      begin
        Sleep(1000);
      end;
      //
      ShellExecute( 0, 'Open',pChar('NFSE.EXE'),'', '', SW_SHOW);
      while processExists('NFSE.EXE') do
      begin
        Sleep(250);
      end;

      if oArqDAT.NFSe.NFSE.Ambiente <> enAmbienteAnt then
      begin
        cMsgPadrao := 'Alterou Ambiente NFSe - DE: ' + oArqDAT.NFSe.NFSe.AmbienteToStr(enAmbienteAnt) +
                      ' PARA: ' + oArqDAT.NFSe.NFSe.AmbienteToStr(oArqDAT.NFSe.NFSe.Ambiente);

        cMsgPadrao := Copy('ConfiguraesdaNFSe2Click', 1, (80 - length(cMsgPadrao) - 2)) + ', ' + cMsgPadrao;

        Audita('ALTEROU','SMALL', Senhas.UsuarioPub, AnsiUpperCase(cMsgPadrao),0,0);

        Form7.IBDataSet100.Transaction.CommitRetaining;
      end;

    finally
      FreeAndNil(oArqDAT);
    end;
  end;

  if FileExists(pChar(Form1.sAtual+'\NFSE\CidadesHomologadas.XML')) then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');
    //
    try
      _file := TStringList.Create;
      _file.LoadFromFile(pChar(Form1.sAtual+'\NFSE\CidadesHomologadas.XML'));
      //
      sPadraoCidade        := RetornaValorDaTagNoCampo(UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString),_File.Text);
      //
      if pos('<Multiservicos>False</Multiservicos>',sPadraoCidade) <> 0 then
      begin
        Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','NAO');
      end else
      begin
        Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','SIM');
      end;
      //
      Mais1Ini.WriteString('Informacoes obtidas na prefeitura','Padrao',RetornaValorDaTagNoCampo('Padrao',sPadraoCidade));
    except
      Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','NAO');
    end;
    Mais1ini.Free;
  end;
end;

procedure TForm1.Debug1Click(Sender: TObject);
begin
  if Form1.Debug1.Checked then Form1.Debug1.Checked := False else Form1.Debug1.Checked := True;
end;

procedure TForm1.Image_bola_cliforClick(Sender: TObject);
begin
  Form1.imgCliForClick(Sender);

  Form7.ibDataSet2.DisableControls;

  try
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.SelectSQL.Clear;
    Form7.ibDataSet2.SelectSQL.Add('select * from CLIFOR where PROXDATA=CURRENT_DATE');
    Form7.ibDataSet2.Open;
  except
  end;

  Form7.ibDataSet4.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosClifor)+' clientes agendados para hoje.');
end;

function TForm1.NcmDeMedicamentos(sNcm: String): Boolean;
begin
  // Valida se o NCM informado pertence a faixa de NCM de medicamentos
  // NCMs que começam com 3001, 3002, 3003, 3004, 3005 e 3006
  Result := False;
  if (Copy(sNcm, 1, 4) = '3001')
    or (Copy(sNcm, 1, 4) = '3002')
    or (Copy(sNcm, 1, 4) = '3003')
    or (Copy(sNcm, 1, 4) = '3004')
    or (Copy(sNcm, 1, 4) = '3005')
    or (Copy(sNcm, 1, 4) = '3006')
  then
    Result := True;
end;

function TForm1.BloqueiaCtrlXTField(Sender: TObject; var Key: Word;
  Shift: TShiftState): Word;
// Bloqueia o CTRL + X (Recortar) em componentes de edição, acessando campos NOME, CGC, DESCRICAO
// Funcionando com TSmall_DBEdit, TDBEdit, TDBMemo, TDBGrid
// Avaliar necessidade de extender a outros tipos de edição
var
  Field: TField;
begin
  {Sandro Silva 2022-10-18 inicio}
  Result := Key;
  try
    if Sender <> nil then
    begin
      Field := nil;
      if Sender.ClassType = TSmall_DBEdit then
        Field := TSmall_DBEdit(Sender).Field;
      if Sender.ClassType = TDBEdit then
        Field := TDBEdit(Sender).Field;
      if Sender.ClassType = TDBMemo then
        Field := TDBMemo(Sender).Field;
      if Sender.ClassType = TDBGrid then
        Field := TDBGrid(Sender).SelectedField;

      if Field <> nil then
      begin
        if ((Field.FieldName = 'NOME') or (Field.FieldName = 'CGC') or (Field.FieldName = 'DESCRICAO'))  and
          (
            (Form7.sModulo = 'RECEBER') or
            (Form7.sModulo = 'PAGAR') or
            (Form7.sModulo = 'CLIENTES') or
            (Form7.sModulo = 'ESTOQUE')
          )
         then
        begin
          if ((Key = Ord('X')) or (Key = Ord('x'))) and (ssCtrl in Shift) then
          begin

            Result := 0;

            if not (Field.DataSet.State in [dsEdit, dsInsert]) then
              Field.DataSet.Edit;

            if Sender.ClassType = TSmall_DBEdit then
              TSmall_DBEdit(Sender).Text := Field.OldValue
            else if Sender.ClassType = TDBEdit then
              TDBEdit(Sender).Text := Field.OldValue
            else if Sender.ClassType = TDBGrid then
              TDBGrid(Sender).SelectedField.Text := Field.OldValue;

          end;
        end;
      end;
    end;
  except
  end;
  {Sandro Silva 2022-10-18 fim}
end;

function TForm1.ValidaEmitenteMunicipio: Boolean;
// Sandro Silva 2022-10-31
// Valida se foi preenchido um município que existe na tabela MUNICIPIOS
var
  IBQMUNICIPIO: TIBQuery;
begin
  Result := True;
  IBQMUNICIPIO := TIBQuery.Create(nil);
  IBQMUNICIPIO.Transaction := Form7.ibDataSet13.Transaction;
  try
    //
    IBQMUNICIPIO.Close;
    IBQMUNICIPIO.SQL.Text :=
      'select M.NOME ' +
      'from MUNICIPIOS M ' +
      'where M.UF = :UF ' +
      'and M.NOME = :MUNICIPIO';
    IBQMUNICIPIO.ParamByName('UF').AsString        := Form7.ibDataSet13ESTADO.AsString;
    IBQMUNICIPIO.ParamByName('MUNICIPIO').AsString := Form7.ibDataSet13MUNICIPIO.AsString;
    IBQMUNICIPIO.Open;
    if IBQMUNICIPIO.FieldByName('NOME').AsString = '' then
      Result := False;
    //
  except
  end;
  FreeAndNil(IBQMUNICIPIO);
end;

procedure TForm1.ValidaBuildNFe_Setup;
var
  sBuildNFe_Setup: String;
begin
  if FileExists('nfe_setup.exe') then
  begin

    sBuildNFe_Setup := VersaoBuild(ExtractFilePath(Application.ExeName) + NOME_NFE_SETUP);

    if LerParametroIni('FRENTE.INI', SECAO_INI_NFE, CHAVE_INI_BUILD_NFE_SETUP_EXE, '') <> sBuildNFe_Setup then
    begin
      mensagem22('Instalando dependências para NF-e');

      ShellExecute( 0, 'Open', pchar(NOME_NFE_SETUP), ' /verysilent', '', SW_HIDE);
      while ConsultaProcesso('nfe_setup.exe') do
      begin
        Sleep(2000);
      end;

      GravarParametroIni('FRENTE.INI', SECAO_INI_NFE, CHAVE_INI_BUILD_NFE_SETUP_EXE, sBuildNFe_Setup);
      mensagem22('');
    end;

  end;
end;

procedure TForm1.ConfiguraCredencialTecnospeed;
begin
  Form7.spdNFe.ConfigurarSoftwareHouse('03916076000664', '5236f0fc4fb818efe845ebff0d0457af');// Sandro Silva 2023-02-27
end;

procedure TForm1.ExibeRazaoSocialNoCaptionDoForm;
var
  sCaption: String;
  sEmpresa: String;
begin
  if Form7.ibDataSet13.Active then
  begin
    {Dailon Parisotto 2023-10-18 (f-7267) Inicio

    if (Form7.ibDataSet13.FieldByName('CGC').AsString = '07.426.598/0001-24') or (Form7.ibDataSet13.FieldByName('CGC').AsString = '03.916.076/0006-64') then
    begin
      sEmpresa := ' - [ ' + Form7.ibDataSet13.FieldByName('NOME').AsString + ' ' + Form7.ibDataSet13.FieldByName('CGC').AsString + ' ]';
      sCaption := Form1.Caption;
      if Pos(' - [', sCaption) > 0 then
        sCaption := Copy(sCaption, 1, Pos(' - [', sCaption) - 1);
      Form1.Caption := sCaption + sEmpresa;
    end;

    }

    //**************************************************//
    //______________________ATENÇÃO______________________//
    //SE ALTERAR o CAPTION abaixo verifique o método//
    //FindWindowCaptionParcial no SOURCE do projeto, para//
    //não permitir abrir duas instancias.//

    sCaption := Form1.Caption;
    sEmpresa := ' - [ ' + Form7.ibDataSet13.FieldByName('NOME').AsString + ' ' + Form7.ibDataSet13.FieldByName('CGC').AsString + ' ]';
    sCaption := Form1.Caption;
    if Pos(' - [', sCaption) > 0 then
      sCaption := Copy(sCaption, 1, Pos(' - [', sCaption) - 1);
    Form1.Caption := sCaption + sEmpresa + ' Usuário: ' + Senhas.UsuarioPub;
    {Dailon Parisotto 2023-10-18 (f-7267) Fim}
  end;
end;

function TForm1.DisponivelSomenteParaNos: Boolean;
// Controla campos, informações, colunas, dados, etc que ficam visíveis somente para uso interno
var
  IBQEMITENTE: TIBQuery;
begin
  Result := False;
  IBQEMITENTE := Form7.CriaIBQuery(Form7.ibDataSet13.Transaction);
  try
    IBQEMITENTE.Close;
    IBQEMITENTE.SQL.Text :=
      'select CGC from EMITENTE';
    IBQEMITENTE.Open;
    Result := ((IBQEMITENTE.FieldByName('CGC').AsString = '07.426.598/0001-24') or (IBQEMITENTE.FieldByName('CGC').AsString = '03.916.076/0006-64'));
  except
  end;
end;


function TForm1.ExisteNfseExe(sDiretorio: String): Boolean;
// Sandro Silva 2023-01-11
// Verifica se existe o nfse.exe
begin
  Result := True;
  if not FileExists(pChar(sDiretorio + '\NFSE.EXE')) then
  begin
    Result := False;
    //ShowMessage('Módulo de transmissão de NFS-e não instalado'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Módulo de transmissão de NFS-e não instalado',msgAtencao);
  end;
end;

procedure TForm1.Mensagemparaenviodeemail1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
  cMsg: string;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\SMALLCOM.INF');
  try
    cMsg := Form1.Small_InputForm('Mensagem para envio de e-mail',
                                  EmptyStr,
                                  Mais1Ini.ReadString('OUTROS','Propaganda',EmptyStr)
                                 );

    Mais1Ini.WriteString('OUTROS', 'Propaganda', cMsg);
  finally
    Mais1Ini.Free;
  end;
end;

function TForm1.getPropaganda: String;
var
  Mais1Ini : TiniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\SMALLCOM.INF');
  try
    //Result := Mais1Ini.ReadString('OUTROS','Propaganda','Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br'); Mauricio Parizotto 2024-03-19
    Result := Mais1Ini.ReadString('OUTROS','Propaganda','');
  finally
    Mais1Ini.Free;
  end;
end;


procedure TForm1.RegistrodoPrograma(TermoAceito:boolean);
var
  sNFCE :String;
  sTermoUso, sCertificado : string;
  sCertificadoValidade : string;
  sURL : string;
begin
  sPublicCheck := GeraCheck;

  try
    try
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from NFCE');
      Form7.ibQuery1.Open;
      //
      sNFCE := Form7.ibQuery1.FieldByname('COUNT').AsString;
    except
    end;

    if LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString) <> '' then
    begin
      //Mauricio Parizotto 2023-05-15
      //Campo termo_uso_aceito no site
      if TermoAceito then
      begin
        sTermoUso := '&termo_uso=' +  FormatDateTime('yyyy-MM-dd hh:mm:ss',now);
      end;

      {Mauricio Parizotto 2024-02-23 Inicio
      Form1.WebBrowser1.Navigate(pChar('http://www.smallsoft.com.br/legal.php?'+
                                    'serial='    + AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))+
                                    '&cnpj='      + LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString)+
                                    '&telefone='  + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('TELEFO').AsString))+
                                    '&nome='      + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('NOME').AsString))+
                                    '&contato='   + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CONTATO').AsString))+
                                    '&endereco='  + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('ENDERECO').AsString))+
                                    '&municipio=' + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('MUNICIPIO').AsString))+
                                    '&bairro='    + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('COMPLE').AsString))+
                                    '&cep='       + AllTrim(Form7.ibDataSet13.FieldByname('CEP').AsString)+
                                    '&estado='    + AllTrim(Uppercase(Form7.ibDataSet13.FieldByname('ESTADO').AsString))+
                                    '&email='     + AllTrim(Form7.ibDataSet13.FieldByname('EMAIL').AsString)+
                                    '&nfce='      + sNFCE +
                                    '&crt='       + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CRT').AsString)) +
                                    '&cnae='      + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CNAE').AsString)) +
                                    '&conve='     + sConve  +
                                    '&origem='    + sOrigem +
                                    '&Check='     + Form1.sPublicCheck +
                                    '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20)))+
                                    sTermoUso
                                    //+ '&retorno=json' // opção para quando tiver mudado o componente e usar recurso de API propriamente dito. Retornará somente o JSON
                                    );

      }

      //Mauricio Parizotto 2024-02-29
      if TSistema.GetInstance.CertificadoTipo <> '' then
      begin
        sCertificadoValidade := FormatDateTime('yyyy-MM-dd',TSistema.GetInstance.CertificadoDtVal);

        sCertificado := '&certificado_tp='+TSistema.GetInstance.CertificadoTipo+
                        '&certificado_vl='+sCertificadoValidade;
      end;
      {Dailon Parisotto (f-19325) 2024-06-12 Inicio}
      // Busca do INI as informações faltantes
      sOrigem := LerParametroIni(Form1.sAtual+'\small.ini', 'T','Origem', EmptyStr);
      sConve  := LerParametroIni(Form1.sAtual+'\small.ini', 'T','Tempo', '00:05:' + SecondOf(Now).ToString);
      {Dailon Parisotto (f-19325) 2024-06-12 Fim}

      sURL := 'http://www.smallsoft.com.br/legal.php?'+
              'serial='    + AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))+
              '&cnpj='      + LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString)+
              '&telefone='  + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('TELEFO').AsString))+
              '&nome='      + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('NOME').AsString))+
              '&contato='   + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CONTATO').AsString))+
              '&endereco='  + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('ENDERECO').AsString))+
              '&municipio=' + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('MUNICIPIO').AsString))+
              '&bairro='    + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('COMPLE').AsString))+
              '&cep='       + AllTrim(Form7.ibDataSet13.FieldByname('CEP').AsString)+
              '&estado='    + AllTrim(Uppercase(Form7.ibDataSet13.FieldByname('ESTADO').AsString))+
              '&email='     + AllTrim(Form7.ibDataSet13.FieldByname('EMAIL').AsString)+
              '&nfce='      + sNFCE +
              '&crt='       + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CRT').AsString)) +
              '&cnae='      + ConverteAcentosIBPT(AllTrim(Form7.ibDataSet13.FieldByname('CNAE').AsString)) +
              '&conve='     + sConve  +
              '&origem='    + sOrigem +
              '&Check='     + Form1.sPublicCheck +
              '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20))+
              sCertificado+
              sTermoUso;
              //+ '&retorno=json' // opção para quando tiver mudado o componente e usar recurso de API propriamente dito. Retornará somente o JSON

      Form1.WebBrowser1.Navigate(pChar(sURL));

      LogSistema(sURL,lgInformacao);
    end;
  except
  end;

  Screen.Cursor             := crDefault;
end;

procedure TForm1.MensagemRecursoIndisponivel(sMensagem: String);
begin
   MensagemSistema(sMensagem + Chr(10) + Chr(10) +
                  'Para ter acesso à esse recurso, procure seu revendedor ou' + Chr(10) +
                  'entre em contato com a Zucchetti pelo telefone 0800 645 2008'
                  ,msgAtencao);
end;

procedure TForm1.AjustarDataSetCamposProduto;
var
  nSizeDescricaoProd: Integer;
begin
  try
    nSizeDescricaoProd               := TamanhoCampoFB(Form7.IBDatabase1,'ESTOQUE','DESCRICAO');
    Form7.ibDataSet4DESCRICAO.Size   := nSizeDescricaoProd;
    Form7.ibDataSet16DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataSet23DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataSet27DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataSet28DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataSet35DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataset40DESCRICAO.Size  := nSizeDescricaoProd;
    Form7.ibDataSet37DESCRICAO.Size  := nSizeDescricaoProd;
    Form24.ibDataSet44DESCRICAO.Size := nSizeDescricaoProd;
  except

  end;
end;

procedure TForm1.miProd120CaracClick(Sender: TObject);
begin
  // Se já for 120 não faz nada
  // Se for estado diferente de SC não faz nada
  //Sandro Silva 2024-04-11 if (Form7.ibDataSet4DESCRICAO.Size = 120) or ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Trim(Form7.ibDataSet13ESTADO.AsString) <> EmptyStr)) then
  if (Form7.ibDataSet4DESCRICAO.Size = 120) or (Trim(Form7.ibDataSet13ESTADO.AsString) = EmptyStr) then
    Exit;

  // Verifica se só tem 1 pessoa conectada
  if (not Form1.ibDataSet200.Transaction.DefaultDatabase.Connected) then
    ConectaBancoCommerce;

  {Sandro Silva 2024-04-08 inicio
  if ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase, 'Select Count(*) From MON$ATTACHMENTS') > 1 then
  begin
    MensagemSistema('Não é possível ativar o recurso de 120 caracteres.'+#13#10+
                    'Existem outros usuários com o sistema aberto.'+#13#10+
                    'Feche o sistema em todos os computadores e tente novamente.'
                    ,msgAtencao);

    Exit;
  end;

  if uDialogs.MensagemSistemaPergunta('Sua empresa ainda usa impressora fiscal? Faz Redução Z?', [mb_YesNo]) = mrYes then
  begin
    uDialogs.MensagemSistema('O recurso de 120 caracteres na descrição do produto não poderá ser usado com impressora fiscal. Considere migrar para NFC-e.', msgAtencao);
    Exit;
  end;

  if uDialogs.MensagemSistemaPergunta('O uso de 120 caracteres na descrição do produto só poderá ser usada por emissores de NF-e ou NFC-e.' + sLineBreak + sLineBreak +
                                      'Deseja prosseguir?', [mb_YesNo]) = mrNo then
    Exit;
  }
  // Se for UF = SC o usuário deve confirmar que deseja alterar
  if (Form7.ibDataSet13ESTADO.AsString = 'SC') then
  begin

    if uDialogs.MensagemSistemaPergunta('Sua empresa ainda usa impressora fiscal?' + sLineBreak +
                                        'Faz Redução Z?', [mb_YesNo]) = mrYes then
    begin
      uDialogs.MensagemSistema('O recurso de 120 caracteres na descrição do produto não poderá ser usado com impressora fiscal. Considere migrar para NFC-e.', msgAtencao);
      Exit;
    end;

    if uDialogs.MensagemSistemaPergunta('O uso de 120 caracteres na descrição do produto só poderá ser usada por emissores de NF-e ou NFC-e.' + sLineBreak + sLineBreak +
                                        'Deseja prosseguir?', [mb_YesNo]) = mrNo then
      Exit;
  end;

  // Por último valida se tem mais usuários logados
  if ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase, 'Select Count(*) From MON$ATTACHMENTS') > 1 then
  begin
    MensagemSistema('Não é possível ativar o recurso de 120 caracteres.'+#13#10+
                    'Existem outros usuários com o sistema aberto.'+#13#10+
                    'Feche o sistema em todos os computadores e tente novamente.'
                    ,msgAtencao);

    Exit;
  end;
  {Sandro Silva 2024-04-08 fim}

  if Aplicar120CaracteresProduto(False) then // 2024-04-11 Aplicar120CaracteresProduto(True);
  begin
    MensagemSistema('Ativado o recurso de 120 caracteres' + #13#10 + #13#10 +
                    'Esse aplicativo será fechado'
                    , msgInformacao);

    FecharAplicacao(ExtractFileName(Application.ExeName));
    Halt(1);
  end
  else
  begin
    MensagemSistema('Não é possível ativar o recurso de 120 caracteres.'+#13#10+
                    'Feche o sistema em todos os computadores e tente novamente.'
                    , msgAtencao);
  end;

end;

function TForm1.Comandos120CaracteresProd: Boolean;// Sandro Silva 2024-04-08 procedure TForm1.Comandos120CaracteresProd;
begin
  {Sandro Silva 2024-04-08 inicio
  if ExecutaComando('ALTER TABLE ALTERACA ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE COMPOSTO ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ESTOQUE ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ITENS001 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ITENS002 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ITENS003 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ITENSETI ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  if ExecutaComando('ALTER TABLE ORCAMENT ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    ExecutaComando('Commit');
  }
  Result := False;
  if ExecutaComando('ALTER TABLE ESTOQUE ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
    if ExecutaComando('ALTER TABLE ALTERACA ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
      if ExecutaComando('ALTER TABLE COMPOSTO ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
        if ExecutaComando('ALTER TABLE ITENS001 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
          if ExecutaComando('ALTER TABLE ITENS002 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
            if ExecutaComando('ALTER TABLE ITENS003 ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
              if ExecutaComando('ALTER TABLE ITENSETI ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
                if ExecutaComando('ALTER TABLE ORCAMENT ALTER COLUMN DESCRICAO TYPE VARCHAR(120)') then
                begin
                  //ExecutaComando('Commit'); Mauricio Parizotto 2024-04-19
                  AgendaCommit(true);
                  Result := True;
                end;
  if Result = False then
    ExecutaComando('Rollback');
  {Sandro Silva 2024-04-08 fim}
end;

function TForm1.Aplicar120CaracteresProduto(bExibirMensagemSucesso: Boolean): Boolean;
var
  bRetorno: Boolean;
  IBQTEMP: TIBQuery;
begin
  if (Form7.ibDataSet4DESCRICAO.Size = 120) then
    Exit;

  IBQTEMP := CriaIBQuery(Form7.ibDataSet4.Transaction);
  try
    IBQTEMP.Close;
    IBQTEMP.SQL.Text := 'Select Count(*) as ATIVOS From MON$ATTACHMENTS';
    IBQTEMP.Open;
    if IBQTEMP.FieldByName('ATIVOS').AsInteger > 1 then
      Exit;
  except
    Exit;
  end;
  FreeAndNil(IBQTEMP);
  //Sandro Silva 2024-04-08 Comandos120CaracteresProd;

  Commitatudo(True); // Grava alterações pendentes

  bRetorno := Comandos120CaracteresProd;
  if bExibirMensagemSucesso then
  begin
    if bRetorno = False then
      MensagemSistema('Não é possível ativar o recurso de 120 caracteres.'+#13#10+
                      'Feche o sistema em todos os computadores e tente novamente.'
                      , msgAtencao)
    else
      MensagemSistema('Ativado o recurso de 120 caracteres.', msgInformacao);
  end;

  try
    AgendaCommit(True);
    Commitatudo(True);
    // Necessario fechar e abrir novamente para não abrir a tela de empresa
    // Dailon 2024-04-10
    {    Form7.ibDataSet13.Close;
    Form7.ibDataSet13.Open;  }
    try
      {2024-04-10
      Form7.ibDataSet4.Close;
      Form7.ibDataSet16.Close;
      Form7.ibDataSet23.Close;
      Form7.ibDataSet27.Close;
      Form7.ibDataSet28.Close;
      Form7.ibDataSet35.Close;
      Form7.ibDataset40.Close;
      Form7.ibDataSet37.Close;
      Form24.ibDataSet44.Close;
      }

      {Sandro Silva 2024-04-08 inicio}
      try
        ConectaBancoCommerce;
      except

      end;
      {Sandro Silva 2024-04-08 fim}

      AjustarDataSetCamposProduto;

      {Sandro Silva 2024-04-10 inicio}
      // Para conseguir validar os dados do emitente com o LEGAL
      Form7.ibDataSet13.Close;
      Form7.ibDataSet13.Open;
      {Sandro Silva 2024-04-10 fim}

      //Commitatudo(True); //2024-04-09

    finally
      {2024-04-10
      Form7.ibDataSet4.Open;
      Form7.ibDataSet16.Open;
      Form7.ibDataSet23.Open;
      Form7.ibDataSet27.Open;
      Form7.ibDataSet28.Open;
      Form7.ibDataSet35.Open;
      Form7.ibDataset40.Open;
      Form7.ibDataSet37.Open;
      Form24.ibDataSet44.Open;
      }
      AbreArquivos(False); //2024-04-10
      Screen.Cursor := crDefault;
    end;
  except
  end;
  Result := bRetorno;
end;

function TForm1.ValidaRecursoExibeMensagemIndisponivel: Boolean;
begin
  Result := False;
  if Form1.ValidaRecursos.PermiteRecursoParaProduto = False then
  begin
    Form1.MensagemRecursoIndisponivel('Não disponível para esta versão do sistema');
  end
  else
    Result := True;
end;

procedure TForm1.Configuraes1Click(Sender: TObject);
begin
  {Sandro Silva 2023-06-01 inicio}
  if Form1.ValidaRecursos.PermiteRecursoParaProduto = False then
  begin
    ConfiguraesdaNFSe1.Enabled := False;
  end;
  {Sandro Silva 2023-06-01 fim}

  {Dailon Parisotto (f-17787) 2024-03-27 Inicio}
  // 2024-04-11 miProd120Carac.Visible := (Form7.ibDataSet13ESTADO.AsString = 'SC') and (Trim(Form7.ibDataSet13ESTADO.AsString) <> EmptyStr) and (Form7.ibDataSet4DESCRICAO.Size <> 120);
  miProd120Carac.Visible := (Trim(Form7.ibDataSet13ESTADO.AsString) <> EmptyStr) and (Form7.ibDataSet4DESCRICAO.Size <> 120);
  {Dailon Parisotto (f-17787) 2024-03-27 Fim}
end;

procedure TForm1.Label_Bola_vendasClick(Sender: TObject);
var
  sMSG : String;
begin
  if not FechaTudo(bFechaTudo) then
    Exit;
  
  if Form7.Visible then Form7.Close;
//  if Form10.Visible then Form10.Close;

  sMSG := Form7.GetMensagemCertificado;

  if AllTrim(sMSG) <> '' then
  begin
    sMSG := sMSG +chr(10);
  end;

  Aviso(sMSG);
end;

procedure TForm1.FazerBackupAgora1Click(Sender: TObject);
var
  Backup: TBackup;
begin
  if not FechaTudo(bFechaTudo) then
    Exit;

  Form7.sModulo := 'BACKUP';
  Form1.Label201MouseLeave(Sender);

  Backup := TBackup.Create;
  {Mauricio parizotto 2023-08-09 Inicio}

  Backup.FMostraDialogs := True;
  SelectDirectory('Selecione um dispositivo de armazenamento externo que seja seguro para fazer uma cópia do banco de dados.', '', Backup.FDiretorioBKP);
  Backup.FNomeArquivoBKP := Limpanumero(Form7.ibDataset13CGC.AsString) + '_' + Alltrim(DiaDaSemana(date));

  try
    Commitatudo(True);
  except
  end;

  try
    FechaTudo(Form1.bFechaTudo);
    Form7.ibDataSet13.Close;
  except
  end;

  {Mauricio parizotto 2023-08-09 Fim}

  if Backup.FazerBackup = IDYES then
    Form19.Button1Click(Sender);

  FreeAndNil(Backup);

  if Form7.sModulo <> 'INDICADORES' then
    Form7.sModulo := '';
end;

procedure TForm1.BackupAutomtico1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', 'backup.exe','A', '', SW_SHOW);
end;

procedure TForm1.Perfisdetribitao1Click(Sender: TObject);
begin
  Form7.sModulo := 'PERFILTRIBUTACAO';
  Form7.sTitulo := 'Perfil de tributação';

  {$IFDEF VER150}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs];
  {$ELSE}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs,dgTitleClick];
  {$ENDIF}

  Form7.Show;
end;

procedure TForm1.NaturezaseCFOPs1Click(Sender: TObject);
begin
  //Form7.Close; Mauricio Parizotto 2023-06-27 causa erro invalid transaction handle
  Form7.sModulo := 'ICM';
  Form7.sTitulo := 'Operações de venda e tabela de ICMS dos estados';

  {$IFDEF VER150}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs];
  {$ELSE}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs,dgTitleClick];
  {$ENDIF}

  Form7.Show;
end;

procedure TForm1.ConversodeCFOP1Click(Sender: TObject);
begin
  Form7.sModulo := 'CONVERSAOCFOP';
  Form7.sTitulo := 'Conversão de CFOP';
  
  {$IFDEF VER150}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs];
  {$ELSE}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs,dgTitleClick];
  {$ENDIF}
  
  Form7.Show;
end;

procedure TForm1.Parmetrosdetributao1Click(Sender: TObject);
begin
  Form7.sModulo := 'PARAMETROTRIBUTACAO';
  Form7.sTitulo := 'Parâmetros de tributação';

  {$IFDEF VER150}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs];
  {$ELSE}
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs,dgTitleClick];
  {$ENDIF}

  Form7.Show;
end;

procedure TForm1.EnvioautomticodeXML1Click(Sender: TObject);
begin
  frmConfigEmailAutContab := TfrmConfigEmailAutContab.Create(nil);
  try
    frmConfigEmailAutContab.SetImagem(imgVendas.Picture);
    frmConfigEmailAutContab.ShowModal;
  finally
    FreeAndNil(frmConfigEmailAutContab);
  end;
end;

procedure TForm1.Observaonadescriodosservios1Click(Sender: TObject);
var
  ConfSistema : TArquivosDAT;
  IBTransaction: TIBTransaction;
begin
  try
    IBTransaction := CriaIBTransaction(Form7.ibDataSet13.Transaction.DefaultDatabase);
    ConfSistema := TArquivosDAT.Create(Usuario, IBTransaction); // Transação isolada para alteração ficar visível aos outros usuários Sandro Silva 2024-03-26 ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet3.Transaction);
    try
      ConfSistema.BD.NFSE.ObsNaDescricao := not(ConfSistema.BD.NFSE.ObsNaDescricao);
      IBTransaction.Commit;

      Observaonadescriodosservios1.Checked := ConfSistema.BD.NFSE.ObsNaDescricao; /// Sandro Silva 2024-04-24
    except
      on E: Exception do
      begin
        IBTransaction.Rollback;
        MensagemSistema('Não foi possível configurar', msgAtencao);
      end;
    end;
  finally
    FreeAndNil(ConfSistema);
    FreeAndNil(IBTransaction);
  end;
  {Sandro Silva 2024-04-23 inicio}
  // Precisa para atualizar a conexão
  Commitatudo(True);
  AbreArquivos(False);
  {Sandro Silva 2024-04-23 fim}
end;

procedure TForm1.CarregaConfiguracoes;
var
  ConfSistema : TArquivosDAT;
begin
  //Carrega coniguraçõs do sistema
  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);

    GeraLogSistema               := ConfSistema.BD.Outras.LogSistema;
    ConfPermitFabricarSemQtd     := ConfSistema.BD.Outras.FabricaProdutoSemQtd; //Mauricio Parizotto 2024-02-02
    bNaoDescontarIssQuandoRetido := ConfSistema.BD.NFSE.NaoDescontarIssQuandoRetido = 'Sim'; // Sandro Silva 2024-04-24
    {Sandro Silva 2024-04-24 inicio}
    Observaonadescriodosservios1.Checked  := ConfSistema.BD.NFSE.ObsNaDescricao;
    Clculododescontopeloprovedor1.Checked := ConfSistema.BD.NFSE.CalculoDoDescontoPeloProvedor = 'Sim';
    NaoDescontarIssQuandoRetido1.Checked  := ConfSistema.BD.NFSE.NaoDescontarIssQuandoRetido = 'Sim'; // Sandro Silva 2024-04-23
    {Sandro Silva 2024-04-24 fim}
  finally
    FreeAndNil(ConfSistema);
  end;
end;

procedure TForm1.ConfiguraesdaNFSe1Click(Sender: TObject);
var
  ConfSistema : TArquivosDAT;
begin
  {Sandro Silva 2024-04-24 inicio
  try
    //Sandro Silva 2024-04-24 ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet3.Transaction);
    ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet13.Transaction);
    Observaonadescriodosservios1.Checked  := ConfSistema.BD.NFSE.ObsNaDescricao;
    Clculododescontopeloprovedor1.Checked := ConfSistema.BD.NFSE.CalculoDoDescontoPeloProvedor = 'Sim';
    NaoDescontarIssQuandoRetido1.Checked  := ConfSistema.BD.NFSE.NaoDescontarIssQuandoRetido = 'Sim'; // Sandro Silva 2024-04-23
  finally
    FreeAndNil(ConfSistema);
  end;
  }
end;

function ExecutaComando(comando:string):Boolean;  overload;
begin
  Result := False;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Text := comando;
    Form1.ibDataset200.ExecSQL;
    Form1.ibDataset200.Close;

    Result := True;
  except
  end;
end;


procedure VencimentoCertificadoDigital;
var
  Recuros : TRecursosSistema;
  sJsonRecurso :string;
  sMensagem, sMensagem2, sURL, sTipoCertificado : string;
begin
  try
    if TSistema.GetInstance.CertificadoTipo = '' then
      Exit;

    if TSistema.GetInstance.CertificadoDtVal < Now + 30 then
    begin
      try
        sJsonRecurso := ExecutaComandoEscalar(Form7.IBTransaction1,
                                              'Select RECURSO From EMITENTE');

        sJsonRecurso := SmallDecrypt(CHAVE_CIFRAR_NOVA,sJsonRecurso);

        Recuros := TJson.JsonToObject<TRecursosSistema>(sJsonRecurso);

        if Recuros.TipoCliente = 'USUARIO' then
        begin
          sMensagem  := 'irá vencer';
          sMensagem2 := 'Após essa data não será possível';

          if TSistema.GetInstance.CertificadoDtVal < Now  then
          begin
            sMensagem := 'venceu';
            sMensagem2 := 'Não é possível';
          end;

          if MensagemSistemaPerguntaCustom('O sistema identificou que seu certificado digital '+sMensagem+' no dia '+DateToStr(TSistema.GetInstance.CertificadoDtVal)+'.'+#13#10+
                                           sMensagem2+' assinar documentos fiscais (NF-e NFC-e) com este certificado.'+#13#10+
                                           #13#10+
                                           'Clique em Comprar e você será direcionado para o Parceiro Certificador.',
                                           mtInformation, [mbOK, mbCancel],
                                           ['Comprar','Cancelar']) = 1 then
          begin
            sTipoCertificado := TSistema.GetInstance.CertificadoTipo;

            if sTipoCertificado = 'NI' then
              sTipoCertificado := 'A1';

            sURL := 'https://inovacoes.compufour.com.br/certificado/contador?word=wNm743'+
                    '&cnpj_cpf='+Form7.ibDataSet13CGC.AsString+
                    '&produto=small-commerce'+
                    '&expira_em='+FormatDateTime('YYYY-MM-DD',TSistema.GetInstance.CertificadoDtVal)+
                    '&modelo_atual='+sTipoCertificado;

            ShellExecute(0, 'Open', pChar(sURL),'', '', SW_SHOW);
          end;
        end;
      finally
        FreeAndNil(Recuros);
      end;
    end;
  except
  end;
end;

end.
// set generator G_SERIE1 to 0
// set generator G_SERIERPS to 40
//                                                                     //
//                                                                     //
//   _____  __  __  _____  __     __     _____  _____  _____  ______   //
//  /  ___>|  \/  |/  _  \|  |   |  |   /  ___>/     \|  ___||_    _|  //
//  \___  \|      ||  _  ||  |__ |  |__ \___  \|  |  ||  __|   |  |    //
//  <_____/|_|\/|_|\_/ \_/|_____||_____|<_____/\_____/|__|     |__|    //
//                                                                     //
//  All rights reserved                                                //
//                                                                     //


