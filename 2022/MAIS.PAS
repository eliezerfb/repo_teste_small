unit Mais;

interface

uses


  Windows, SysUtils, Messages, Classes, Controls, Graphics,
  DBTables, Menus, StdCtrls, Buttons, ExtCtrls, Forms, Dialogs, shellapi,
  mais3, unit2,unit3, IniFiles, Unit4, Unit10, SmallFunc, Registry, HtmlHelp,
  DBGrids, Grids, OleCtrls, SHDocVw, IBCustomDataSet, IBDatabase, Winsock,
  IBQuery, jpeg, Gauges, SpdNFeDataSets, IBServices, FileCtrl, xmldom, XMLIntf,
  oxmldom, XMLDoc, URLMON, pngimage, ComCtrls, clipbrd, MD5, DB, DateUtils,
  WinTypes, WinProcs,
  LbCipher, LbClass, Tlhelp32, Psapi, strutils, ShlObj, ComObj, ActiveX
  , DBCtrls
  , SMALL_DBEdit
  ;

  function LeLabels(sP1: Boolean): Boolean;
  function MostraLabels(tSp1: tImage; tSp2: TLabel): Boolean;
  function FechaTudo(bP1: Boolean): Boolean;
  function MontaTela(sP1: Boolean): Boolean;
  function DownloadDoArquivo(pP1: String; pP2: String): Boolean;
  function mensagem22(sP1 : String) : Boolean;
//  procedure DropViewProcedure;

const VALOR_SISTEMA_BLOQUEADO = '19670926'; // Mudando aqui precisa mudar no Frente PAF Homologado
const BUILD_DO_BANCO = '2023010'; // Sandro Silva 2023-04-11 const BUILD_DO_BANCO = '2023008'; // Sandro Silva 2023-04-10 const BUILD_DO_BANCO = '2023004';
const CNPJ_SMALLSOFT = '03.916.076/0006-64'; // Sandro Silva 2022-12-02 Unochapeco '07.426.598/0001-24';
const RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF = 'ZUCCHETTI SOFTWARE E SISTEMAS LTDA'; // Sandro Silva 2023-01-18 const RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF = 'Smallsoft Tecnologia em Informática EIRELI';
const RAZAO_SOCIAL_SOFTWARE_HOUSE = 'ZUCCHETTI SOFTWARE E SISTEMAS LTDA'; // Sandro Silva 2022-12-02 Unochapeco 'Smallsoft Tecnologia em Informática EIRELI';

const NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF = 'arquivoauxiliarcriptografadopafecfsmallsoft.ini'; // usado também pelo SAT

const IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO = 999;  // Sandro Silva 2022-09-12
const ValidacaoNova = True; //False;

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
    Image201: TImage;
    Image201_: TImage;
    Image202: TImage;
    Image203: TImage;
    Image204: TImage;
    Image210: TImage;
    Image205: TImage;
    Image206: TImage;
    Image207: TImage;
    Image208: TImage;
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
    Image200: TImage;
    Image200_R: TImage;
    Image200_X: TImage;
    PopupMenu2: TPopupMenu;
    N13: TMenuItem;
    Image_raio_2: TImage;
    Image_raio_1: TImage;
    CNPJdacontabilidade1: TMenuItem;
    Instalarpackcomasltimasalteraes1: TMenuItem;
    FileListBox1: TFileListBox;
    Panel3: TPanel;
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
    N7: TMenuItem;
    WebBrowser2: TWebBrowser;
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
    Image201C: TImage;
    Label201S: TLabel;
    Image201S: TImage;
    Image201C_X: TImage;
    Image201S_X: TImage;
    Image201C_R: TImage;
    Image201S_R: TImage;
    Layoutpreenchimento1: TMenuItem;
    Simples1: TMenuItem;
    Complexo1: TMenuItem;
    N16: TMenuItem;
    ConverterosdadosparaSmallSaaS1: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    ConfiguraesdaNFSe2: TMenuItem;
    Debug1: TMenuItem;

    procedure NovoFormExit(Sender:TObject);
    procedure Image205Click(Sender: TObject);
    procedure Sobreoprograma1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ConsultadepreosporCdigodeBarras1Click(Sender: TObject);
    procedure EscolheOBanco(Sender: TObject);
    procedure EscolheOclifor(Sender: TObject);
    procedure EscolheOBloqueto(Sender: TObject);
    procedure EscolheCNAB400(Sender:TObject);
    procedure EscolheCNAB240(Sender:TObject);
    procedure ExecutaOPlugin(Sender:TObject);
    procedure TabeladeICMparatodososestados1Click(Sender: TObject);
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
    procedure Image203Click(Sender: TObject);
    procedure Image202Click(Sender: TObject);
    procedure Image206Click(Sender: TObject);
    procedure Image201Click(Sender: TObject);
    procedure Image208Click(Sender: TObject);
    procedure Image207Click(Sender: TObject);
    procedure wwwsmallsoftcombr1Click(Sender: TObject);
    procedure Image204Click(Sender: TObject);
    procedure Image210Click(Sender: TObject);
    procedure Image201_Click(Sender: TObject);
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
    procedure Edit200DblClick(Sender: TObject);
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
    procedure Image205MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
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
    procedure Image200Click(Sender: TObject);
    procedure CNPJdacontabilidade1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N4001Click(Sender: TObject);
    procedure Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel_0DblClick(Sender: TObject);
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
    procedure Image201CClick(Sender: TObject);
    procedure LAbel201CMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label201SMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image201SClick(Sender: TObject);
    procedure Simples1Click(Sender: TObject);
    procedure Complexo1Click(Sender: TObject);
    procedure ConverterosdadosparaSmallSaaS1Click(Sender: TObject);
    procedure ConfiguraesdaNFSe2Click(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure Image_bola_cliforClick(Sender: TObject);


  private
    { Private declarations }
    procedure ExibeRazaoSocialNoCaptionDoForm;

  public

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
    sPropaganda : String;
    iReduzida, iTempo, iAvisosEstoque, iAvisosNFECompra, iAvisosCaixa, iAvisosBanco, iAvisosPagar, iAvisosReceber, iAvisosCliFor, iAvisosOS, iAvisosIndicadores, iAvisosConfig: Integer;
    sEscolhido: String;
    ConfCFOP: String;
    CFOP5124: String;
    ConfCasas : String;
    ConfCasasServ : String;
    ConfPreco : String;
    ConfAceitaCGCDuplo: String;
    ConfDupl1, ConfDupl2, ConfDupl3, ConfCusto, Confduplo,ConfNegat, ConfFoto, ConfMArca, ConfEspecie: String;
    ConfSvc, ConfItens   : Integer;
    ConfLimite  : Real;
    ConfIR      : Real;
    bChaveSelecionaCliente : Boolean;
    bMediaPonderadaFixa    : Boolean;
    bMKP : Boolean;

    { Public declarations }
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
    function Small_InputForm_Dados(sP1: String) : Boolean;
    function NcmDeMedicamentos(sNcm: String): Boolean;
    function BloqueiaCtrlXTField(Sender: TObject; var Key: Word;
      Shift: TShiftState): Word; // Sandro Silva 2022-10-18
    function ValidaEmitenteMunicipio: Boolean;
    procedure ConfiguraCredencialTecnospeed;
    function DisponivelSomenteParaNos: Boolean;
    function CampoDisponivelParaUsuario(sModulo, sCampo: String): Boolean;
    function ExisteNfseExe(sDiretorio: String): Boolean;
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
  Unit16, Unit8, Unit38, Unit28, Unit43, Unit30, SelecionaCertificado,
  Unit26, Unit5, Unit37, Unit29, Unit42, Unit44, Unit13, Unit48,
  uconstantes_chaves_privadas, ucredencialtecnospeed, uAtualizaBancoDados;

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


function ApagaArquivoNoDeskTop(sP1:String): boolean;
begin
  DeleteFile(pChar(GetSystemPath(0)+'\'+sP1));
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
      end; // if (iNINI > 0) and (iNFIN > 0) then
    end; // if xmlNodeValue(sXML, '//infInut/cStat') = '102' then
  except
  end;
end;


function Aviso2(sP1: String) : Boolean;
begin
  //  Form42.Show;
  
  Form29.Button1.Visible := False;
  Form29.Label1.Caption  := sP1;
  Form29.Show;
  Form29.Repaint;
  Result := True;
end;


function Aviso(sP1: String) : Boolean;
begin
  //  Form42.Show;
  Form29.Label1.Caption := sP1;
  Form29.ShowModal;
  
  Result := True;
end;

function tForm1.Small_InputForm_Dados(sP1: String) : boolean;
begin
  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  form29.Label3.Caption := sP1;
  Form29.Panel_Dados.Visible  := True;

  Form29.ShowModal;

  Form29.Panel_Dados.Visible  := False;
  Form7.AlphaBlendValue := 255;
  Form29.Edit1.Text     := '';
  
  Result                := True;
end;

function tForm1.Small_InputForm(sP1, sP2, sP3: String) : String;
begin
  Form7.AlphaBlend      := True;
  Form7.AlphaBlendValue := 0;

  Form29.Label1.Font.Size := 18;
  Form29.Label1.Caption := sP1+chr(10)+chr(10)+sP2;

  Form29.Edit1.Visible  := True;
  Form29.Edit1.Text     := sP3;
  Form29.Edit1.Left     := Form29.Label1.Left;

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
//  Form1.ibQuery2.SQL.Add('select count(NUMERONF)as NN from COMPRAS where coalesce(NFEID,''0000000000000000000000000000000000000000000'')<>''0000000000000000000000000000000000000000000'' and coalesce(NFEXML,''X.X'')=''X.X'' and MERCADORIA=0');
  Form1.ibQuery2.SQL.Add('select count(NUMERONF)as NN from COMPRAS where Coalesce(MDESTINXML,''~'') like ''%<tpEvento>210210%'' and MERCADORIA=0');
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
  Form1.ibQuery2.SQL.Add('select count(REGISTRO)as NN from RECEBER where VALOR_RECE=0 and VENCIMENTO=CURRENT_DATE');
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
  //
  // LEGAL
  //
  try
    //
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_LEGAL,0) from rdb$database');
    Form1.ibDataset200.Open;
    //
    // ShowMessage(Form1.ibDataSet200.FieldByname('GEN_ID').AsString);
    //
    if Form1.ibDataSet200.FieldByname('GEN_ID').AsString <> '0' then
    begin
      Result := False;
    end else
    begin
      Result := True;
    end;
    //
  except
    //
    Result := True;
    //
  end;
  //
end;


function Regularize(sP1: boolean): boolean;
var
  Mais1ini: tIniFile;
  documentoAtivo: variant;
  sSerie, sInicio, s: String;
  bButton: Integer;
  CredencialTecnospeed: TCredenciaisTecnospeed;
begin
  //
  Result := False;
  //
  try
    //
    documentoAtivo := Form1.WebBrowser1.Document;
    s := documentoAtivo.Body.OuterHTML;

    {Sandro Silva 2022-12-15 inicio}
    CredencialTecnospeed := TCredenciaisTecnospeed.Create; // Sandro Silva 2022-12-15
    CredencialTecnospeed.PrivateKey := Form1.sPasta;
    CredencialTecnospeed.SalvaCredencial(Form1.sAtual, s);
    CredencialTecnospeed.Free;
    {Sandro Silva 2022-12-15 fim}


//      ShowMessage(s);
//      s := '[INICIO=15/08/2018]' + s;
    //
    if ValidaHostsWindows then
    begin
      s := '[PARATUDO]';
    end;
    //
    // ShowMessage(s);
    //
    if pos('[INICIO', S) <> 0 then
    begin
      try
        //
        sInicio := Copy(S, pos('[INICIO', S) + 8, 10);
        //
//          ShowMessage(sInicio);
        //
        Form7.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta
        //
        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('update EMITENTE set LICENCA='+QuotedStr(Form7.LbBlowfish1.EncryptString(  Copy(sInicio,7,4)+Copy(sInicio,4,2)+Copy(sInicio,1,2))));
        Form1.ibQuery2.ExecSQL;
        //
        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('commit');
        Form1.ibQuery2.ExecSQL;
        //
      except
      end;
    end;

    {Sandro Silva 2022-11-11 inicio}
    if ValidacaoNova then
    begin

      if pos('[LIMITE', S) <> 0 then
      begin

        try
          //
          sInicio := Copy(S, pos('[LIMITE', S) + 8, 10);  // Contem a data limite de uso do sistema
          //
  //          ShowMessage(sInicio);
          //
          Form7.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta
          //
          Form1.ibQuery2.Close;
          Form1.ibQuery2.SQL.Clear;
          Form1.ibQuery2.SQL.Add('update EMITENTE set LICENCA='+QuotedStr(Form7.LbBlowfish1.EncryptString(  Copy(sInicio,7,4)+Copy(sInicio,4,2)+Copy(sInicio,1,2))));
          Form1.ibQuery2.ExecSQL;
          //
          Form1.ibQuery2.Close;
          Form1.ibQuery2.SQL.Clear;
          Form1.ibQuery2.SQL.Add('commit');
          Form1.ibQuery2.ExecSQL;
          //
        except
        end;

      end;

    end;
    {Sandro Silva 2022-11-11 fim}

    //
    if pos('[SERIE',S) <> 0 then
    begin
      try
        //
        sSerie := Copy(S,pos('[SERIE',S)+7,13);
        //
//          ShowMessage(sSerie);
        //
        if sSerie <> '' then
        begin
          //
          if sSerie <> Form1.sSerial then
          begin
            //
            Mais1ini := TIniFile.Create('WIND0WS.L0G');
            Mais1Ini.WriteString('LICENCA','Ser',sSerie); // Cadastro Licença de uso
            Mais1Ini.WriteString('RR','Ser',sSerie); // Cadastro Licença de uso
            Mais1Ini.Free;
            //
//            ShowMessage('Nova licença de uso instalada com sucesso.');
            //
          end;
          //
        end;
        //
      except
      end;
    end;
    //
    if (pos('REGULARIZE',UpperCase(S)) <> 0) or (pos('[BLOQUEADO1]',UpperCase(S)) <> 0) or (pos('[BLOQUEADO2]',UpperCase(S)) <> 0) or (pos('[PARATUDO]',UpperCase(S)) <> 0) then
    begin
      //
      // ShowMessage('TESTE REGULARIZE OK');
      //
      if (pos('[PARATUDO]',UpperCase(S)) <> 0) then
      begin
        if Legal_ok(True) then
        begin
          try
            //
            Form1.ibDataset200.Close;
            Form1.ibDataset200.SelectSql.Clear;
            Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
            Form1.ibDataset200.Open;
            //
            ShowMessage('Este sistema foi bloqueado');
            //
          except
          end;
        end;
      end else
      begin
        //
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
        //
      end;
      //
    end else
    begin
      //
      if pos('LEGAL',UpperCase(S)) <> 0 then
      begin
        //
        try
          Form1.ibDataset200.Close;
          Form1.ibDataset200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 0');
          Form1.ibDataset200.Open;
        except
        end;
        //
        Result := True;
        //
      end else
      begin
        //
        if Legal_ok(True) then
        begin
          //
          // ShowMessage('Não foi possível acessar o servidor da Smallsoft para validar esta número de série.');
          //
//          if Assigned(Form1.WebBrowser2.Document) then
//          begin
            //
//            documentoAtivo := Form1.WebBrowser2.Document;
//            s := documentoAtivo.Body.OuterHTML;
            //
            // ShowMessage(s);
            //
//            if (pos('GOOGLE',UpperCase(S)) <> 0) or (pos('PESQUISAR',UpperCase(S)) <> 0) then // Conseguiu assesar o google ou o youtube
//            begin
          try
            Form1.ibDataset200.Close;
            Form1.ibDataset200.SelectSql.Clear;
            Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to ' + Copy(dateToStr(Date),7,4) + Copy(dateToStr(Date),4,2) + Copy(dateToStr(Date),1,2));
            Form1.ibDataset200.Open;
          except
          end;
//            end;
           //
//            end;
          //
        end;
        //
      end;
      //
      if (pos('[BUILD]',UpperCase(S)) <> 0) or (pos('[VERSAO]',UpperCase(S)) <> 0) then
      begin
        //
        bButton := Application.MessageBox(Pchar(
          'Uma nova versão do Small Commerce está disponível para download (este procedimento demora apenas alguns minutos).'+
          Chr(10) +
          Chr(10) +
          'Continuar?' +
          Chr(10))
          ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
        //
        if bButton = IDYES then
        begin
          //
          if FileExists(Form1.sAtual+'\smallcon.exe') then
          begin
            //
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

            //
          end
          else
            ShowMessage('Arquivo smallcon.exe não encontrado.');
          //
          Winexec('TASKKILL /F /IM "smallcdf.exe"', SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mobile.exe"', SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mkp.exe"', SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "Small Commerce.exe"', SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe', SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe', SW_HIDE );
          //
        end;
        //
      end;

      (*
      if (pos('[BUILD]',UpperCase(S)) <> 0) then
      begin
        //
        bButton := Application.MessageBox(Pchar(
        'Uma nova Build do Small Commerce está disponível para download (este procedimento demora apenas alguns minutos).'+
        Chr(10) +
        Chr(10) +
        'Continuar?' +
        Chr(10))
        ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
        //
        if bButton = IDYES then
        begin
          //
          if FileExists(Form1.sAtual+'\smallcon.exe') then
          begin
            //
            ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20221001.sma '+
                                                           '20221002.sma '+
                                                           '20221003.sma '+
                                                           '20221004.sma '+
                                                           '20221005.sma '+
                                                           '20221006.sma '+
                                                           '20221007.sma '+
                                                           '20221008.sma '+
                                                           '20221009.sma '+
                                                           'nfce2022.sma '+
                                                           '2022_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma ')
                                                           , '', SW_SHOW);

            //
          end else ShowMessage('Arquivo smallcon.exe não encontrado.');
          //
          Winexec('TASKKILL /F /IM "smallcdf.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          //
        end;
        //
      end;

      if (pos('[VERSAO]',UpperCase(S)) <> 0) then
      begin
        //
        bButton := Application.MessageBox(Pchar(
        'Uma nova Versão do Small Commerce está disponível para download (este procedimento demora apenas alguns minutos).'+
        Chr(10) +
        Chr(10) +
        'Continuar?' +
        Chr(10))
        ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
        //
        if bButton = IDYES then
        begin
          //
          if FileExists(Form1.sAtual+'\smallcon.exe') then
          begin
            //
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

            //
          end else ShowMessage('Arquivo smallcon.exe não encontrado.');
          //
          Winexec('TASKKILL /F /IM "smallcdf.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          //
        end;
        //
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
        Application.MessageBox(Pchar(
          'Este sistema não está liberado.'+
          Chr(10) +
          Chr(10) +
          'Continuar?' +
          Chr(10))
          ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
      end;
    end;
  except end;
end;

{
function JpgResize(sP1: String; iP2: Integer): boolean;
var
  _bmp:    TBitmap;
  Picture: TPicture;
  jp    : TJPEGImage;
  Rect  : tRect;
begin
  //
  //  while FileExists(Form1.sAtual+'\tempo.bmp') do DeleteFile(Form1.sAtual+'\tempo.bmp');
  //
  if FileExists(sP1) then
  begin
    //
    Picture := graphics.TPicture.Create;
    _bmp    := graphics.TBitmap.Create;
    Picture.LoadFromFile(sP1);
    //
    try
      _bmp.Assign(Picture.Graphic);
      _bmp.SavetoFile('tempo.bmp');
    except end;
    //
    _bmp.Free;
    Picture.Free;
    //
  end;
  //
  if FileExists(Form1.sAtual+'\tempo.bmp') then
  begin
    //
    Form10.Image5.Picture.LoadFromFile('tempo.bmp');
    //
    Rect.Top := 0;
    Rect.Left := 0;
    //
    Form10.Image5.AutoSize := True;
    //
    if Form10.Image5.Picture.Width > Form10.Image5.Picture.Height then
    begin
      Form10.Image5.Picture.Bitmap.Height := Form10.Image5.Picture.Bitmap.Width;
      Rect.Right  := StrToInt(StrZero((Form10.Image5.Picture.Width   * (iP2 / Form10.Image5.Picture.Width)),4,0));
      Rect.Bottom := StrToInt(StrZero((Form10.Image5.Picture.Height  * (iP2 / Form10.Image5.Picture.Width)),4,0));
    end else
    begin
      Form10.Image5.Picture.Bitmap.Width := Form10.Image5.Picture.Bitmap.Height;
      Rect.Right  := StrToInt(StrZero((Form10.Image5.Picture.Width   * (iP2 / Form10.Image5.Picture.Height)),4,0));
      Rect.Bottom := StrToInt(StrZero((Form10.Image5.Picture.Height  * (iP2 / Form10.Image5.Picture.Height)),4,0));
    end;
    //
    Form10.Image5.Canvas.stretchdraw(Rect,Form10.Image5.Picture.Graphic);
    //
    Form10.Image5.Picture.Bitmap.Width  := Rect.Right;
    Form10.Image5.Picture.Bitmap.Height := Rect.Bottom;
    //
    jp := TJPEGImage.Create;
    //
    try
      jp.Assign(Form10.Image5.Picture.Bitmap);
      jp.CompressionQuality := 50;
      jp.SaveToFile(sP1);
    except end;
    //
    jp.Free;
    //
  end;
  //
  REsult := True;
  //
end;



function PngResize(sP1: String; iP2: Integer; iP3: Integer): boolean;
var
  _bmp:    TBitmap;
  Picture: TPicture;
//  jp    : TJPEGImage;
  Rect  : tRect;
begin
  //
  if FileExists(sP1) then
  begin
    //
    Picture := graphics.TPicture.Create;
    _bmp    := graphics.TBitmap.Create;
    Picture.LoadFromFile(sP1);
    //
    try
      _bmp.Assign(Picture.Graphic);
      _bmp.SavetoFile('tempo.bmp');
    except end;
    //
    _bmp.Free;
    Picture.Free;
    //
    Form10.Image5.Picture.LoadFromFile('tempo.bmp');
    //
    Rect.Top := 0;
    Rect.Left := 0;
    //
    Form10.Image5.Picture.Bitmap.Height := Form10.Image5.Picture.Bitmap.Width;
    //
    Rect.Right  := iP2;
    Rect.Bottom := iP3;
    //
    Form10.Image5.Canvas.stretchdraw(Rect,Form10.Image5.Picture.Graphic);
    //
    Form10.Image5.Picture.Bitmap.Width  := Rect.Right;
    Form10.Image5.Picture.Bitmap.Height := Rect.Bottom;
    //
    Form10.Image5.Picture.SaveToFile(sP1);
    //
  end;
  //
  REsult := True;
  //
end;
}

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
      WinExec(PChar('taskkill /PID ' + IntToStr(FProcessEntry32.th32ProcessID) + ' /F'), SW_HIDE);
      // Break;
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
      //
//      if FileExists(Form1.sAtual+'\'+pP1+'.EXE') then ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\'+pP1+'.exe'),'/verysilent','', SW_SHOWNORMAL);
      if FileExists(Form1.sAtual+'\'+pP1+'.EXE') then Winexec(pChar(Form1.sAtual+'\'+pP1+'.exe /verysilent'), SW_HIDE );

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
   // on E: Exception do  ShowMessage('Erro ao baixar arquivo: '+chr(10)+pP1+chr(10)+E.Message);
  end;

  Result :=True;
end;

procedure TForm1.ScrollMouse(var Msg: TMsg; var Handled: Boolean);
var
  iParam: Smallint;
begin
  if Msg.message = WM_MOUSEWHEEL then
  begin
    Msg.message := WM_KEYDOWN;
    Msg.lParam  := 0;
    iParam := HiWord(Msg.wParam) ;
    if iParam > 0 then
      Msg.wParam := VK_UP
    else
      Msg.wParam := VK_DOWN;
    Handled := False;
  end;
end;

function Titulo(sP1, sP2: String): Boolean;
begin
  Form1.Panel4.Visible  := False;
  Form1.Panel_3.Visible := False;

  Form1.Label1.Caption      := sP1;

  Form1.Label3.Top := Form1.Label1.Top + Form1.Label1.Height + 35;

  Form1.Label3.Caption      := sP2;

  if (Form1.iReduzida = 1) and
    ((sP1 = 'MONITORE AS CONTAS'+chr(10)+'A RECEBER') or
    (sP1 = 'ORGANIZE AS CONTAS'+chr(10)+'A PAGAR') or
    (sP1 = 'CONTROLE O '+chr(10)+'CAIXA') or
    (sP1 = 'FIQUE DE OLHO NOS '+chr(10)+'BANCOS'))
  then
  begin
    Form1.Panel3.Left     := Form1.Label3.Left;
//    Form1.Panel3.Top      := Form1.Label_2.Top + Form1.Label_2.Height + 30;
    Form1.Panel3.Top      := Form1.Panel_3.Height - Form1.Panel3.Height - 70;
    Form1.Label3.Caption := Form1.Label3.Caption + chr(10) + chr(10) + 'Este módulo não está liberado'+chr(10)+'no Small Start';
    Form1.Panel3.Visible := True;
    //
  end else
  begin
    Form1.Panel3.Visible := False;
  end;
  //
//  Form1.Label_1.BringToFront;
//  Form1.Label_2.BringToFront;
  //
  Form1.Panel_3.Visible := True;
  //
  Result := True;
  //
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
//  Screen.Cursor := scCursor;
end;


{
procedure ListaDeArquivos(sAtual: String; var tsL: tStringList);
var
  S: TSearchREc;
  I : Integer;
begin
  //
  tsL.Clear;
  //
  I := SysUtils.FindFirst(pChar(sAtual + '\' + '*.*'),faAnyFile, S );  // Culpado
  //
  while I = 0 do
  begin
    tsL.Add(S.Name);
    I := SysUtils.FindNext(S);
  end;
  //
  SysUtils.FindClose(S);
  //
end;
}

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
    //
    // Ativa todos os indices
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select i.rdb$index_name,i.rdb$unique_flag,i.rdb$relation_name,s.rdb$field_name from rdb$indices i join rdb$index_segments s on (i.rdb$index_name = s.rdb$index_name) where i.rdb$index_name not like '+QuotedStr('RDB$%')+' ');
    Form1.ibQuery1.Open;
    //
    while not Form1.ibQuery1.Eof do
    begin
      try
        //
        // Mensagem22('Ativando indice '+AllTrim(Form1.ibQuery1.Fields[0].asString));
        //
        Form1.ibQuery2.Close;
        Form1.ibQuery2.SQL.Clear;
        Form1.ibQuery2.SQL.Add('alter index '+Form1.ibQuery1.Fields[0].asString+' active');
        Form1.ibQuery2.ExecSQL;
      except end;
      //
      Form1.ibQuery1.Next;
      //
    end;
    //
    Form1.ibQuery1.Close;
    //
  except end;
  Result := True;
end;

function Estatistica(sp1: String; sp2 : String): String;
begin
  //
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
//        ShowMessage(sLinha);
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
  sQtd     ,
  sTot     ,
  sIPI     ,
  sICMS    ,
  spICMS   ,
  sBC      ,
  sICMSST  ,
  sBCST    : String;
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
            // ICM
            sICMS   := '0';
            sBC     := '0';
            sICMSST := '0';
            sBCST   := '0';
            spICMS  := '0';

            for I := 0 to 100 do
            begin
              if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0))) then
              begin
                try sICMS   := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0)).ChildNodes['vICMS'].Text);   except end;
                try sBC     := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0)).ChildNodes['vBC'].Text);     except end;
                try sICMSST := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0)).ChildNodes['vICMSST'].Text); except end;
                try sBCST   := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0)).ChildNodes['vBCST'].Text);   except end;
                try spICMS  := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('ICMS').ChildNodes.FindNode('ICMS'+StrZero(I,2,0)).ChildNodes['pICMS'].Text);  except end;
              end;
            end;

            try sDesc := NodeTmp.ChildNodes['xProd'].Text; except end;
            try sQtd  := NodeTmp.ChildNodes['qCom'].Text;  except end;
            try sTot  := NodeTmp.ChildNodes['vProd'].Text; except end;

            sIPI    := '0';
            
            if Assigned(NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI')) then
            begin
               try sIPI  := LimpaNumeroDeixandoOPonto('0'+NodeSec.ChildNodes.FindNode('imposto').ChildNodes.FindNode('IPI').ChildNodes.FindNode('IPITrib').ChildNodes['vIPI'].Text);  except end;
            end;
{
            ShowMessage(
            sICMS   + Chr(10)+
            sBC     + Chr(10)+
            sICMSST + Chr(10)+
            sBCST   + Chr(10)+
            spICMS  + Chr(10)+
            sIPI);
         }
            
            Form7.ibQuery1.Close;
            Form7.ibQuery1.Sql.Clear;
            Form7.ibQuery1.Sql.Add('update ITENS001 set vICMS='+QuotedStr(sICMS)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
            Form7.ibQuery1.Open;

            try
              Form1.ibQuery1.Close;
              Form1.ibQuery1.Sql.Clear;
              Form1.ibQuery1.Sql.Add('update ITENS001 set vICMS='+QuotedStr(sICMS)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
              Form1.ibQuery1.Open;
            except
            end;

            try
              Form1.ibQuery1.Close;
              Form1.ibQuery1.Sql.Clear;
              Form1.ibQuery1.Sql.Add('update ITENS001 set vBC='+QuotedStr(sBC)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
              Form1.ibQuery1.Open;
            except end;

            try
              Form1.ibQuery1.Close;
              Form1.ibQuery1.Sql.Clear;
              Form1.ibQuery1.Sql.Add('update ITENS001 set vBCST='+QuotedStr(sBCST)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
              Form1.ibQuery1.Open;
            except
            end;

            try
              Form1.ibQuery1.Close;
              Form1.ibQuery1.Sql.Clear;
              Form1.ibQuery1.Sql.Add('update ITENS001 set vICMSST='+QuotedStr(sICMSST)+' where NUMERONF='+QuotedStr(Form1.ibQuery2.FieldByname('NUMERONF').AsString)+' and DESCRICAO='+QuotedStr(sDesc)+'');
              Form1.ibQuery1.Open;
            except end;
            
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


function MontaTela(sP1 : boolean):Boolean;
var
  iTop, iFix, iFixL, iLeft : Integer;
begin
  Form1.Align    := alClient;
  
{
  Form1.Panel_2.Left   := (Screen.Width) div 2;
  Form1.Panel_2.Width  := (Screen.Width) div 2;
  Form1.Panel_2.Height := (Screen.Width) div 2;
  //
  if (Form1.Width - Form1.Panel_2.Left) <= (Form1.Height - Form1.Panel_2.Top) then
  begin
    Form1.Panel_2.Top    := Form1.Height - Form1.Panel_2.Height + 5;
  end else
  begin
    Form1.Panel_2.Top    := Form1.Panel_0.Top + Form1.Panel_0.Height + 5 + 5;
  end;
}

  Form1.Panel_3.Left   := 0; // (Screen.Width - (1000)) div 2;
  Form1.Panel_3.Top    := Form1.Panel_0.Top + Form1.Panel_0.Height;
  Form1.Panel_3.Height := Form1.Height - Form1.Panel_3.Top;
  Form1.Panel_3.Width  := Screen.Width;
  Form1.Panel4.Width   := Screen.Width;
  Form1.Panel4.Top     := Form1.Panel_3.Top;
  form1.Panel4.Height  := Screen.Height;

  Form7.Top    := Form1.Panel_3.Top + 30;
  Form7.Left   := 0;
  Form7.Width  := Form1.Width -6;
  Form7.Height := Form1.Height - Form7.Top -6;
  
  iTop := 6;
  iFix := 0;
  iFixL := 70;
  iLeft := 5+5;

  // ------ //
  // Vendas //
  // ------ //
  if Form1.Image201.Visible = True then
  begin
    Form1.Image201.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image201.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image201,Form1.Label201);
  end;

  // ------- //
  // Compras //
  // ------- //
  if Form1.Image201C.Visible = True then
  begin
    Form1.Image201C.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image201C.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image201C,Form1.Label201C);

    // Avisos no NFe
    if Form1.iAvisosNFeCompra >= 100 then
    begin
      Form1.Image_Bola_NFe.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosNFeCompra >= 10 then
      begin
        Form1.Image_Bola_NFe.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_NFe.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_NFe.Top     := Form1.Image201C.Top -6+1-1;
    Form1.Image_Bola_NFe.Left    := Form1.Image201C.Left + Form1.Image201C.Width - 20;
    Form1.Label_Bola_NFe.Caption := AllTrim(IntToStr(Form1.iAvisosNFeCompra));
    Form1.Label_Bola_NFe.Width   := Form1.Image_Bola_NFe.Width;

    Form1.Label_Bola_NFe.Left    := Form1.Image_Bola_NFe.Left;
    Form1.Label_Bola_NFe.Top     := Form1.Image_Bola_NFe.Top +1-1;
    
    if Form1.iAvisosNFeCompra <> 0 then
    begin
      Form1.Image_Bola_NFe.visible  := True;
      Form1.Label_Bola_NFe.Visible  := True;
    end else
    begin
      Form1.Image_Bola_NFe.visible  := False;
      Form1.Label_Bola_NFe.Visible  := False;
    end;
  end;
  // --------- //
  // Serviços  //
  // --------- //
  if Form1.Image201S.Visible = True then
  begin
    Form1.Image201S.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image201S.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image201S,Form1.Label201S);
  end;
  // ----------------- //
  // Ordem de serviços //
  // ----------------- //
  if Form1.Image201_.Visible = True then
  begin
    Form1.Image201_.Top     := iTop;
    iTop              := iTop + iFix;
    Form1.Image201_.Left    := iLeft;
    iLeft             := iLeft + iFixL;
    MostraLabels(Form1.Image201_,Form1.Label201_);

    // Avisos no OS
    if Form1.iAvisosOS >= 100 then
    begin
      Form1.Image_Bola_OS.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosOS >= 10 then
      begin
        Form1.Image_Bola_OS.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_OS.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_OS.Top     := Form1.Image201_.Top -6+1-1;
    Form1.Image_Bola_OS.Left    := Form1.Image201_.Left + Form1.Image201_.Width - 20;
    Form1.Label_Bola_OS.Caption := AllTrim(IntToStr(Form1.iAvisosOS));

    Form1.Label_Bola_OS.Width   := Form1.Image_Bola_OS.Width;
    Form1.Label_Bola_OS.Left    := Form1.Image_Bola_OS.Left;
    Form1.Label_Bola_OS.Top     := Form1.Image_Bola_OS.Top +1-1;

    if Form1.iAvisosOS <> 0 then
    begin
      Form1.Image_Bola_OS.visible  := True;
      Form1.Label_Bola_OS.Visible  := True;
    end else
    begin
      Form1.Image_Bola_OS.visible  := False;
      Form1.Label_Bola_OS.Visible  := False;
    end;
  end;

  // -------- //
  // Estoque  //
  // -------- //
  if Form1.Image202.Visible = True then
  begin
    Form1.Image202.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image202.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image202,Form1.Label202);
    
    // Avisos no Estoque
    if Form1.iAvisosEstoque >= 100 then
    begin
      Form1.Image_Bola_Estoque.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosEstoque >= 10 then
      begin
        Form1.Image_Bola_Estoque.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Estoque.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_Estoque.Top     := Form1.Image201.Top -6+1-1;
    Form1.Image_Bola_Estoque.Left    := Form1.Image202.Left + Form1.Image202.Width - 20;
    Form1.Label_Bola_Estoque.Caption := AllTrim(IntToStr(Form1.iAvisosEstoque));

    Form1.Label_Bola_Estoque.Width   := Form1.Image_Bola_Estoque.Width;
    Form1.Label_Bola_Estoque.Left    := Form1.Image_Bola_Estoque.Left;
    Form1.Label_Bola_Estoque.Top     := Form1.Image_Bola_Estoque.Top +1-1;

    if Form1.iAvisosEstoque <> 0 then
    begin
      Form1.Image_Bola_Estoque.visible  := True;
      Form1.Label_Bola_Estoque.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Estoque.visible  := False;
      Form1.Label_Bola_Estoque.Visible  := False;
    end;
  end;

  // ----------------------- //
  // Clientes e Fornecedores //
  // ----------------------- //
  if Form1.Image203.Visible = True then
  begin
    Form1.Image203.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image203.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image203,Form1.Label203);

    // Avisos no CliFor
    if Form1.iAvisosCliFor >= 100 then
    begin
      Form1.Image_Bola_CliFor.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosCliFor >= 10 then
      begin
        Form1.Image_Bola_CliFor.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_CliFor.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_CliFor.Top     := Form1.Image203.Top -6+1-1;
    Form1.Image_Bola_CliFor.Left    := Form1.Image203.Left + Form1.Image203.Width - 20;
    Form1.Label_Bola_CliFor.Caption := AllTrim(IntToStr(Form1.iAvisosCliFor));

    Form1.Label_Bola_CliFor.Width   := Form1.Image_Bola_CliFor.Width;
    Form1.Label_Bola_CliFor.Left    := Form1.Image_Bola_CliFor.Left;
    Form1.Label_Bola_CliFor.Top     := Form1.Image_Bola_CliFor.Top +1-1;

    if Form1.iAvisosCliFor <> 0 then
    begin
      Form1.Image_Bola_CliFor.visible  := True;
      Form1.Label_Bola_CliFor.Visible  := True;
    end else
    begin
      Form1.Image_Bola_CliFor.visible  := False;
      Form1.Label_Bola_CliFor.Visible  := False;
    end;
  end;

  // -------- //
  // Receber  //
  // -------- //
  if Form1.Image204.Visible = True then
  begin
    Form1.Image204.Top     := iTop;
    iTop                   := iTop + iFix;
    Form1.Image204.Left    := iLeft;
    iLeft                  := iLeft + iFixL;
    MostraLabels(Form1.Image204,Form1.Label204);

    // Avisos no Receber
    if Form1.iAvisosReceber >= 100 then
    begin
      Form1.Image_Bola_Receber.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosReceber >= 10 then
      begin
        Form1.Image_Bola_Receber.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Receber.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_Receber.Top     := Form1.Image204.Top -6+1-1;
    Form1.Image_Bola_Receber.Left    := Form1.Image204.Left + Form1.Image204.Width - 20;
    Form1.Label_Bola_Receber.Caption := AllTrim(IntToStr(Form1.iAvisosReceber));

    Form1.Label_Bola_Receber.Width   := Form1.Image_Bola_Receber.Width;
    Form1.Label_Bola_Receber.Top     := Form1.Image_Bola_Receber.Top +1-1;
    Form1.Label_Bola_Receber.Left    := Form1.Image_Bola_Receber.Left;

    if Form1.iAvisosReceber <> 0 then
    begin
      Form1.Image_Bola_Receber.visible  := True;
      Form1.Label_Bola_Receber.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Receber.visible  := False;
      Form1.Label_Bola_Receber.Visible  := False;
    end;
  end;

  // -------- //
  // Pagar    //
  // -------- //
  if Form1.Image210.Visible = True then
  begin
    Form1.Image210.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image210.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image210,Form1.Label210);

    // Avisos no Pagar
    if Form1.iAvisosPagar >= 100 then
    begin
      Form1.Image_Bola_Pagar.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosPagar >= 10 then
      begin
        Form1.Image_Bola_Pagar.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Pagar.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_Pagar.Top     := Form1.Image210.Top -6+1-1;
    Form1.Image_Bola_Pagar.Left    := Form1.Image210.Left + Form1.Image210.Width - 20;
    Form1.Label_Bola_Pagar.Caption := AllTrim(IntToStr(Form1.iAvisosPagar));
    
    Form1.Label_Bola_Pagar.Width   := Form1.Image_Bola_Pagar.Width;
    Form1.Label_Bola_Pagar.Left    := Form1.Image_Bola_Pagar.Left;
    Form1.Label_Bola_Pagar.Top     := Form1.Image_Bola_Pagar.Top +1-1;

    if Form1.iAvisosPagar <> 0 then
    begin
      Form1.Image_Bola_Pagar.visible  := True;
      Form1.Label_Bola_Pagar.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Pagar.visible  := False;
      Form1.Label_Bola_Pagar.Visible  := False;
    end;
  end;

  // ----- //
  // Caixa //
  // ----- //
  if Form1.Image205.Visible = True then
  begin
    Form1.Image205.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image205.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image205,Form1.Label205);

    // Avisos no Caixa
    if Form1.iAvisosCaixa >= 100 then
    begin
      Form1.Image_Bola_Caixa.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosCaixa >= 10 then
      begin
        Form1.Image_Bola_Caixa.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Caixa.Picture := Form1.ImageBola.Picture;
      end;
    end;
    
    Form1.Image_Bola_caixa.Top     := Form1.Image205.Top -6+1-1;
    Form1.Image_Bola_Caixa.Left    := Form1.Image205.Left + Form1.Image205.Width - 20;
    Form1.Label_Bola_Caixa.Caption := AllTrim(IntToStr(Form1.iAvisosCaixa));

    Form1.Label_Bola_Caixa.Width   := Form1.Image_Bola_Caixa.Width;
    Form1.Label_Bola_Caixa.Left    := Form1.Image_Bola_Caixa.Left;
    Form1.Label_Bola_Caixa.Top     := Form1.Image_Bola_Caixa.Top +1-1;
    
    if Form1.iAvisosCaixa <> 0 then
    begin
      Form1.Image_Bola_Caixa.visible  := True;
      Form1.Label_Bola_Caixa.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Caixa.visible  := False;
      Form1.Label_Bola_Caixa.Visible  := False;
    end;
  end;

  // ------- //
  // Bancos  //
  // ------- //
  if Form1.Image206.Visible = True then
  begin
    Form1.Image206.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image206.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image206,Form1.Label206);

    // Avisos no banco
    if Form1.iAvisosBanco >= 100 then
    begin
      Form1.Image_Bola_Banco.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosBanco >= 10 then
      begin
        Form1.Image_Bola_Banco.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Banco.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_banco.Top     := Form1.Image206.Top -6+1-1;
    Form1.Image_Bola_banco.Left    := Form1.Image206.Left + Form1.Image206.Width - 20;
    Form1.Label_Bola_banco.Caption := AllTrim(IntToStr(Form1.iAvisosbanco));

    Form1.Label_Bola_Banco.Width   := Form1.Image_Bola_Banco.Width;
    Form1.Label_Bola_banco.Left    := Form1.Image_Bola_banco.Left;
    Form1.Label_Bola_banco.Top     := Form1.Image_Bola_banco.Top +1-1;

    if Form1.iAvisosbanco <> 0 then
    begin
      Form1.Image_Bola_banco.visible  := True;
      Form1.Label_Bola_banco.Visible  := True;
    end else
    begin
      Form1.Image_Bola_banco.visible  := False;
      Form1.Label_Bola_banco.Visible  := False;
    end;
  end;

  // ---------------- //
  // Indicadores     //
  // ---------------- //
  if Form1.Image200.Visible = True then
  begin
    Form1.Image200.Top     := iTop;
    iTop             := iTop + iFix;
    Form1.Image200.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image200,Form1.Label200);

    // Avisos no Indicadores
    if Form1.iAvisosIndicadores >= 100 then
    begin
      Form1.Image_Bola_Indicadores.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosIndicadores >= 10 then
      begin
        Form1.Image_Bola_Indicadores.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Indicadores.Picture := Form1.ImageBola.Picture;
      end;
    end;
    
    Form1.Image_Bola_Indicadores.Top     := Form1.Image200.Top -6+1-1;
    Form1.Image_Bola_Indicadores.Left    := Form1.Image200.Left + Form1.Image200.Width - 20;
    Form1.Label_Bola_Indicadores.Caption := AllTrim(IntToStr(Form1.iAvisosIndicadores));

    Form1.Label_Bola_Indicadores.Width   := Form1.Image_Bola_Indicadores.Width;
    Form1.Label_Bola_Indicadores.Left    := Form1.Image_Bola_Indicadores.Left;
    Form1.Label_Bola_Indicadores.Top     := Form1.Image_Bola_Indicadores.Top +1-1;

    if Form1.iAvisosIndicadores <> 0 then
    begin
      Form1.Image_Bola_Indicadores.visible  := True;
      Form1.Label_Bola_Indicadores.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Indicadores.visible  := False;
      Form1.Label_Bola_Indicadores.Visible  := False;
    end;
  end;

  // CONFIG
  if Form1.Image207.Visible = True then
  begin
    Form1.Image207.Top     := iTop;
    iTop             := iTop  + iFix;
    Form1.Image207.Left    := iLeft;
    iLeft            := iLeft + iFixL;
    MostraLabels(Form1.Image207,Form1.Label207);

    // Avisos no Config
    if Form1.iAvisosConfig >= 100 then
    begin
      Form1.Image_Bola_Config.Picture := Form1.ImageBola3.Picture;
    end else
    begin
      if Form1.iAvisosConfig >= 10 then
      begin
        Form1.Image_Bola_Config.Picture := Form1.ImageBola2.Picture;
      end else
      begin
        Form1.Image_Bola_Config.Picture := Form1.ImageBola.Picture;
      end;
    end;

    Form1.Image_Bola_Config.Top     := Form1.Image207.Top -6+1-1;
    Form1.Image_Bola_Config.Left    := Form1.Image207.Left + Form1.Image207.Width - 20;
    Form1.Label_Bola_Config.Caption := AllTrim(IntToStr(Form1.iAvisosConfig));

    Form1.Label_Bola_Config.Width   := Form1.Image_Bola_Config.Width;
    Form1.Label_Bola_Config.Left    := Form1.Image_Bola_Config.Left;
    Form1.Label_Bola_Config.Top     := Form1.Image_Bola_Config.Top +1-1;
    
    if Form1.iAvisosConfig <> 0 then
    begin
      Form1.Image_Bola_Config.visible  := True;
      Form1.Label_Bola_Config.Visible  := True;
    end else
    begin
      Form1.Image_Bola_Config.visible  := False;
      Form1.Label_Bola_Config.Visible  := False;
    end;
  end;

  // --------- //
  // Cópias   //
  // ------- //
  if Form1.Image208.Visible = True then
  begin
    Form1.Image208.Top     := iTop;
    Form1.Image208.Left    := iLeft;
    MostraLabels(Form1.Image208,Form1.Label208);
  end else
  begin
//    Form1.Label_Perigo.Visible       := False;
  end;
  
  Result := True;
end;




function GetIP:string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^  do
  begin
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;


function ExecutaSql(sP1 : boolean):Boolean;
var
  f: TextFile;
  sDelete, sUpdate,
  sArquivo, sCaminho, sSelectSql : String;
  I : Integer;
  sLinha, sCampos, sValores : String;
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
            ShowMessage('Erro de sintaxe no comando IMPORT FROM.');
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
    //        ShowMessage(sArquivo+chr(10)+sCaminho);
          //
          if FileExists(sCaminho+'.SQL') then DeleteFile(pChar(sCaminho+'.SQL'));
          
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
  // ShowMessage(dbGrid200.Fields[I].DisplayName+chr(10)+FieldTypeNames[IBDataSet200.FieldByName(dbGrid200.Fields[I].DisplayName).DataType]);
                  //
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
            ShowMessage(sArquivo+' não é uma tabéla válida.');
          end;

          Screen.Cursor := crDefault;
        end else
        begin
          ShowMessage('Erro de sintaxe no comando EXPORT FROM.');
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
            
            sDelete := 'delete from '+sArquivo+' where REGISTRO=:OLD_REGISTRO';
            sUpdate := 'update '+sArquivo+' set ';

            for I := 0 to ibDataSet200.FieldCount -1 do
            begin
              sUpdate := sUpdate + ibDataSet200.Fields[I].FieldName + '=:'+ibDataSet200.Fields[I].FieldName;
              if I = ibDataSet200.FieldCount -1 then sUpdate := sUpdate + ' ' else sUpdate := sUpdate + ', ';
            end;

            sUpdate := sUpdate + ' where REGISTRO=:OLD_REGISTRO';

            ibDataSet200.Close;
            ibDataSet200.DeleteSQL.Add(sDelete);
            ibDataSet200.ModifySql.Add(sUpdate);
            ibDataSet200.Open;
          except end;
        end;

        Edit200.Text := '';
      except
        ibDataSet200.Close;
        ibDataSet200.DeleteSQL.Clear;
        ibDataSet200.SelectSQL.Clear;
        ibDataSet200.SelectSQL.Add(sSelectSql);
        ibDataSet200.Open;

        ShowMessage('Erro no comando SQL: '+Edit200.Text);
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
        ShowMessage('Conectado');
      except
        ShowMessage('Não foi possível conectar');
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

      ShowMessage('Erro no comando SQL: '+Edit1.Text);
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

    // ShowMessage(Form1.ibDataSet200.FieldByname('GEN_ID').AsString);
    if Form1.ibDataSet200.FieldByname('GEN_ID').AsString <> '0' then
    begin
      // ShowMessage(
      // DateToStr(Date+5) +chr(10)+ DateToStr(StrToDate(Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,7,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,5,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,1,4)))
      // );
      if Date >= StrToDate(Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,7,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,5,2)+'/'+Copy(Form1.ibDataSet200.FieldByname('GEN_ID').AsString,1,4))+31 then
      begin
        try
          Form1.ibDataset200.Close;
          Form1.ibDataset200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
          Form1.ibDataset200.Open;
        except end;

        // Pega os dados do Emitente
        try
          Form7.ibDataSet13.Active := True;
          // Sandro Silva 2022-10-31 if Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0 then
          if (Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0)
            or (Form1.ValidaEmitenteMunicipio = False) then
          begin
            Form17.ShowModal;
            if Form1.CanFocus then Form1.SetFocus;
          end;
        except end;
        
        Form1.RegistrodoProgramaonline1Click(Form1);

        for I := 1 to 10 do
        begin
          if not Regularize(True) then Sleep(200);
        end;

        if not Regularize(True) then
        begin
          Application.MessageBox(pChar('Não foi possível liberar o sistema para uso neste computador'+chr(10)+
                                    'com o número de série '+ Form1.sSerial +' para: '+chr(10)+chr(10)+
                                     AllTrim(Form7.ibDataSet13NOME.AsString)+chr(10)+chr(10)+
                                     AllTrim(Form7.ibDataSet13CGC.AsString)+chr(10)+chr(10)+
                                     'Código: 2022 '+chr(10)+chr(10)+
                                     'Adquirir uma licença de uso atualizada?'),
                                     'Atenção', MB_ICONQUESTION + MB_YESNO);

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
    Result := True;
  end;
end;

function AtualizaPromocao(sP1 : Boolean):Boolean;
begin
  Form22.Repaint;
  Mensagem22('Atualizando promoção...');

  try
    // Volta o preco fora da promoção
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('update ESTOQUE set PRECO=OFFPROMO where (CURRENT_DATE not between PROMOINI and PROMOFIM) and (PRECO=ONPROMO) ');
    Form7.ibDataSet99.Open;
  except end;
  
  try
    // Guarda o preço anterior (normal) fora da promoção
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('update ESTOQUE set OFFPROMO=PRECO where (CURRENT_DATE not between PROMOINI and PROMOFIM) and (OFFPROMO<>PRECO)');
    Form7.ibDataSet99.Open;
  except end;

  try
    // Altera para o preço promocional
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('update ESTOQUE set PRECO=ONPROMO where (CURRENT_DATE between PROMOINI and PROMOFIM) and (PRECO<>ONPROMO) ');
    Form7.ibDataSet99.Open;
  except end;

  Mensagem22('Aguarde...');

  Result := True;
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
      ShowMessage('Erro ao criar REGISTRO em: '+sP1);
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
        ShowMessage('Erro ao criar Chave Primaria em: '+sP1);
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
  if Form5.Visible then Form5.Close;
  if Form5.Visible then Form10.Close;

  if Form1.bFechaTudo then
  begin
    if Form24.Visible then Form24.Close;
    if Form12.Visible then Form12.Close;
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
  //
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
        Fields[I-1].Displaywidth := 21;
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
    //
    if not Form19.CheckBox8.Checked then
    begin
      tSp2.Caption := Replicate(' ',100)+AllTrim(tSp2.Caption);
    end else
    begin
      tSp2.Caption := AllTrim(tSp2.Caption);
    end;
    //
    tSp2.visible     := True;
    tsP2.Repaint;
    //
  end;
  //
 // tSp2.visible     := False;
  //
  if tSp2.Caption = 'Backup' then
  begin
    //
    if Form1.Image208.Visible then
    begin
      //
      try
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        if (StrtoDate(Mais1Ini.ReadString('Backup','Último backup','26/09/1967')) + 1) < Date then
        begin
          if Mais1Ini.ReadString('Backup','Último backup','?') = '?' then
          begin
            Form1.Image208.Hint := 'Banco de dados em risco,'+chr(10)+'sem backup seguro';
          end else
          begin
            Form1.Image208.Hint := 'Banco de dados em risco, último'+chr(10)+'backup em '+Alltrim(Mais1Ini.ReadString('Backup','Último backup','?'));
          end;
        end else
        begin
          Form1.Image208.Hint := 'Último backup em '+Mais1Ini.ReadString('Backup','Último backup','?');
        end;
      except
        Form1.Image208.Hint := 'Banco de dados em risco,'+chr(10)+'sem backup seguro';
      end;
      //
    end;
    //
  end;
  //
  Result := True;
  //
end;

procedure Tform1.NovoFormExit(Sender:TObject);
begin
  Screen.ActiveForm.Visible := False;
end;

procedure TForm1.WMUser (var msg: TMessage);
begin
  Application.Restore;
end;

procedure TForm1.Image205Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  if not (Form1.iReduzida = 1) then
  begin
    try
      FechaTudo(bFechaTudo);
      Form7.sModulo := 'CAIXA';
      Form1.Label201MouseLeave(Sender);
      Form7.sTitulo := 'Livro caixa';
      Form7.sRPS := 'N';
      Form7.Show;
    except end;
  end;
end;

procedure TForm1.Sobreoprograma1Click(Sender: TObject);
begin
  //
  Form22.Close;
  //
  try
    if Form7.IBDatabaseInfo1.UserNames.Count = 1
      then Form22.sAtivos :=  AllTrim(InttoStr(Form7.IBDatabaseInfo1.UserNames.Count))+' usuário ativo'
        else Form22.sAtivos :=  AllTrim(InttoStr(Form7.IBDatabaseInfo1.UserNames.Count))+' usuários ativos';
  except
    Form22.sAtivos := '? usuários ativos';
  end;
  //
  with Form22.RichEdit1 do
  begin
    //
    Lines.Clear;
    SelAttributes.Name := 'Microsoft Sans Serif';
    SelAttributes.Style := [fsBold];
    SelAttributes.Color := clWhite;
//    SelAttributes.Color := clBlack;
    SelAttributes.Height := 30;
    Lines.Add(Form22.sTitulo);
    //
    SelStart := Length(Text)-1;
    SelAttributes.Style := [];
    SelAttributes.Height := 16;
    //
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_LEGAL,0) from rdb$database');
    Form1.ibDataset200.Open;
    //
    // ShowMessage(Form1.ibDataSet200.FieldByname('GEN_ID').AsString);
    //
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
    //
  end;
  //
  Form22.RichEdit1.Left  := Form22.Image1.Left -100-20;
  Form22.RichEdit1.Top   := Form22.Image1.Top + Form22.Image1.Height + 20;
  Form22.RichEdit1.Width := 700;
  //
  //
  Form22.Label6.Visible    := False;
  Form22.Image1.Visible    := True;
  Form22.RichEdit1.Visible := True;
  Form22.Button1.Visible   := True;
  //
  //Mensagem22('Copyright© SmallSoft® 2005 - 2022'); Form22.Button1.Visible := True;
  Mensagem22('Copyright© Zucchetti® 2005 - 2023'); Form22.Button1.Visible := True;
  Form22.ShowModal;
  //
  Form22.Label6.Visible    := True;
  Form22.Image1.Visible    := True;
  Form22.RichEdit1.Visible := False;
  //
end;

procedure Tform1.EscolheOBanco(Sender:TObject);
var
  Mais1Ini : TIniFile;
begin
  //
  Form16.Button3Click(Sender);
  with Sender as TMenuItem do sEscolhido := Caption;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais1Ini.WriteString('BANCOS','BANCO',sEscolhido);
  Mais1Ini.Free;
  Form7.sTitulo := sEscolhido;
  Form7.sRPS := 'N';
  //
  Form7.Close;
  Form7.Show;
  //
end;

procedure Tform1.EscolheOclifor(Sender:TObject);
begin
  //
  with Sender as TMenuItem do
  begin
    Form7.sWhere  := 'where CLIFOR='+QuotedStr( Copy(Caption,4,Length(Caption)-2))+ ' ';
    Checked := True;
  end;
  //
  Form7.Close;
  Form7.Show;
  //
end;

procedure Tform1.EscolheOBloqueto(Sender:TObject);
begin
  { as é um operador usado com o wiht}
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  //with Sender as TMenuItem do sEscolhido := Caption;
  with Sender as TMenuItem do
    sEscolhido := Caption;
  sEscolhido := 'Boleto de cobrança do '+Form1.sEscolhido;
  Form25.ShowModal;
  //
end;

procedure Tform1.EscolheCNAB400(Sender:TObject);
begin
  { as é um operador usado com o wiht}
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  //with Sender as TMenuItem do sEscolhido := Caption;
  with Sender as TMenuItem do
    sEscolhido := Caption;
  sEscolhido := 'Boleto de cobrança do '+Form1.sEscolhido;
  Form25.Show;
  //Form25.Button9.Click;
  Form25.btnCNAB400.Click; // Sandro Silva 2022-12-23 Form25.Button9.Click;
  Form25.Close;
  //
  if Form1.sArquivoRemessa <> '' then
  begin
    ShowMessage('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 400 para o BANCO '+
    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
    Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+
    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10));
  end;
  //
end;

procedure Tform1.EscolheCNAB240(Sender:TObject);
begin
  { as é um operador usado com o wiht}
  // Elimina o & que o delphi 6 e 7 colocam automaticamente
  //with Sender as TMenuItem do sEscolhido := Caption;
  with Sender as TMenuItem do
    sEscolhido := Caption;
  sEscolhido := 'Boleto de cobrança do '+Form1.sEscolhido;
  Form25.Show;
  //Form25.Button10.Click;
  Form25.btnCNAB240.Click; // Sandro Silva 2022-12-23 Form25.Button10.Click;
  Form25.Close;
  //
  if Form1.sArquivoRemessa <> '' then
  begin
    ShowMessage('Atenção'+chr(10)+chr(10)+'O arquivo abaixo foi gerado no padrão CNAB 240 para o BANCO '+
    Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+ '.'+
    Chr(10)+'Este arquivo devera ser transmitido conforme orientação específica do banco.'+
    chr(10)+chr(10)+Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa+chr(10)+chr(10)+chr(10));
  end;
  //
end;

procedure Tform1.ExecutaOPlugin(Sender:TObject);
begin
  with Sender as TMenuItem do
    ShellExecute( 0, 'Open',pChar('Plug-in\'+Caption+'.exe'),'', '', SW_SHOW);
end;

procedure TForm1.FormActivate(Sender: TObject);
var
//  Hora, Min, Seg, cent : Word;
//  tInicio : tTime;
  Mais1Ini: TIniFile;
  sPastaDoPaf : String;
begin
  //
  Form1.sConsultaNfse   := 'NAO';
  Timer2.Interval       := 10000;
  Form1.Image4.Width    := 1024;
  Form1.Image4.Height   := 768;
  //
  if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) then
  begin
    ConfiguraodaNFemformulrionumerado1.Visible := True;
  end else
  begin
    ConfiguraodaNFemformulrionumerado1.Visible := False;
  end;
  //
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
  except end;
  //
  //  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  //  ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10));
  //
  CHDir(Form1.sAtual);
  //
  if (DecimalSeparator <> ',') or (DateSeparator <> '/') then
  begin
    Application.MessageBox(Pchar('As propriedades das configurações regionais do seu sistema não estão'     + Chr(10) +
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
                                 'o separador de data que deve ser "/".')

                                 ,'Atenção',mb_Ok + MB_ICONWARNING);
//    // Form1.DestroyWindowHandle;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
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
  //
  // Ativa o verificador de rede
  //
  bChaveDoTempo := True;
  //
  // Limpar movimento
  //
  Form2.Top  := Form7.Top;
  Form2.Left := (Form1.Width div 2) - (Form2.Width div 2);
  //
  if FileExists(Form1.sAtual+'\smallzip_.exe') then
  begin
    while FileExists(Form1.sAtual+'\smallzip.exe') do DeleteFile(pChar(Form1.sAtual+'\smallzip.exe'));
    RenameFile(pChar(Form1.sAtual+'\smallzip_.exe'),pChar(Form1.sAtual+'\smallzip.exe'));
  end;
  //
  if FileExists(Form1.sAtual+'\smallcon_.exe') then
  begin
    while FileExists(Form1.sAtual+'\smallcon.exe') do DeleteFile(pChar(Form1.sAtual+'\smallcon.exe'));
    RenameFile(pChar(Form1.sAtual+'\smallcon_.exe'),pChar(Form1.sAtual+'\smallcon.exe'));
  end;
  //
  if (sModeloPAF <> '65') and (sModeloPAF <> '01') and (sModeloPAF <> '59') and (sModeloPAF <> '99') then
  begin
    //
    {Sandro Silva 2022-12-28 inicio
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then
      sPastaDoPaf := 'paf2022'
    else
      sPastaDoPaf := 'paf2022'; //Sandro Silva 2018-11-29 if Form7.ibDataSet13ESTADO.AsString = 'SC' then sPastaDoPaf := 'paf2018_8' else  sPastaDoPaf := 'paf2018';
    }
    sPastaDoPaf := 'paf2023';
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then
      sPastaDoPaf := 'paf2023';
    {Sandro Silva 2022-12-28 inicio}

    if not FileExists(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\bematech2\bemafi32.ini')) then
      sPastaDoPaf := 'paf2023'; // Sandro Silva 2022-12-28 sPastaDoPaf := 'paf2021';
    //
    if FileExists(Form1.sAtual+'\'+sPastaDoPaf+'\paf.txt') then
    begin
      //
      try
        //
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
          //
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
        //
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
        //
        // Testar esta lógica
        //
        if not ((FileExists(pChar(Form1.sAtual+'\BlocoX\templates\SC\ped_enviar.xml'))) and (not FileExists(pChar(Form1.sAtual+'\BlocoX\blocox_servidores.xml')))) then
        begin
          ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C xcopy "' + sPastaDoPaf + '\BlocoX" BlocoX/S/Y'), nil, SW_HIDE); // Sandro Silva 2022-12-28 ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C xcopy "PAF2020\BlocoX" BlocoX/S/Y'), nil, SW_HIDE);
        end;
        //
        ShowMessage('Software PAF-ECF para modelo do ECF '+sNomePAF+' configurado com sucesso.'+chr(10)+'Imprima uma identificação do PAF-ECF e confira o MD5 credenciado no seu estado.');
        DeleteFile(pChar(Form1.sAtual+'\'+sPastaDoPaf+'\paf.txt'));
        //
        ShellExecute( 0, 'Open','http://www.smallsoft.com.br/md5paf','', '', SW_SHOWMAXIMIZED);
        //
      except
        on E: Exception do  ShowMessage('Erro ao instalar os arquivos do PAF-ECF: '+E.Message);
      end;
    end;
  end;
  //
  Mais1ini.Free;
  Form1.SetFocus;
  //
  try
    // Sandro Silva 2022-10-31 if Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0 then
    if (Pos('1'+UpperCase(UpperCase(Form7.ibDataSet13ESTADO.AsString))+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21mg2') = 0)
      or (ValidaEmitenteMunicipio = False) then
    begin
      Form17.ShowModal;
      if Form1.CanFocus then Form1.SetFocus;
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
  except end;
  //
  if Form1.iREduzida = 99 then
  begin
    Form17.ShowModal;
  end;
  //
  if (Image201S.Visible) then
  begin
    //
    // Libera NFSE.EXE
    //
    Form1.ConfiguraesdaNFSe1.Visible := True;
    Form7.GerarNotaFiscaldeServio1.Visible := True;
    Form7.GerarNotaFiscaldeServio2.Visible := True;
    //
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

procedure TForm1.TabeladeICMparatodososestados1Click(Sender: TObject);
begin
  Form7.Close;
  Form7.sModulo := 'ICM';
  Form7.sTitulo := 'Operações de venda e tabela de ICMS dos estados';
  Form7.DBGrid1.Options := [dgEditing,dgTitles,dgColLines,dgRowLines,dgTabs]; // Tabela de ICMS
  Form7.Show;
end;

procedure TForm1.Cadastrodetransportadoras1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  Form7.Close;
  Form7.sModulo := 'TRANSPORT';
  Form7.sTitulo := 'Cadastro de transportadoras';
  Form7.sRPS := 'N';
  Form7.Show;
  //
end;

procedure TForm1.Opes1Click(Sender: TObject);
begin
  Form7.Close;
  Form19.ShowModal;
end;

procedure TForm1.Planodecontas1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  //
  Form7.sModuloAnterior := Form7.sModulo;
  Form7.sModulo := 'CONTAS';
  Form7.sTitulo := 'Plano de contas';
  Form7.sRPS := 'N';
  //
//  Form7.Close;
  Form7.Show;
  //
  Form38.Panel5.Visible := True;
  Form38.Button2.Visible := False;
  Form38.ShowModal; // Ok
  Form38.Panel5.Visible := False;
  Form38.Button2.Visible := True;
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
//  if Form38.Caption <> 'Cancelar' then
  begin
    //
    Form7.ibDataSet12DIA.ReadOnly := False;
    Form7.ibDataSet12MES.ReadOnly := False;
    Form7.ibDataSet12ANO.ReadOnly := False;
    Form7.ibDataSet12SALDO.ReadOnly := False;
    //
    Form7.ibDataSet12.Close;
    Form7.ibDataSet12.SelectSQL.Clear;
    Form7.ibDataSet12.SelectSQL.Add('select * from CONTAS order by upper(NOME)');
    Form7.ibDataSet12.Open;
    Form7.ibDataSet12.First;
    //
    Form7.ibDataSet12.DisableControls;
    //
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
    //
    // Saldo
    //
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;
    //
    while not Form7.IBDataSet100.Eof do
    begin
      if Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString) <> '' then
      begin
        Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
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
      //
      Form7.IBDataSet100.Next;
      //
    end;
    //
    // ANO
    //
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    // Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' and DATA<='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4)+'/'+Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2)+'/'+Copy(DateTimeToStr(Form38.MonthCalendar1.Date),1,2))+' group by NOME');
    // ShowMessage(Form7.ibDataSet100.SelectSQL.TExt);
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;
    //
    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12ANO.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;
      //
      Form7.IBDataSet100.Next;
      //
    end;
    //
    // MES
    //
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( month from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2))+' and extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;
    //
    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12MES.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;
      //
      Form7.IBDataSet100.Next;
      //
    end;
    //
    // DIA
    //
    Form7.IBDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('select NOME, sum(ENTRADA)as VENTRADA, sum(SAIDA)as VSAIDA from CAIXA where extract( day from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),1,2))+' and extract( month from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),4,2))+' and extract( year from DATA )='+QuotedStr(Copy(DateTimeToStr(Form38.MonthCalendar1.Date),7,4))+' group by NOME');
    Form7.ibDataSet100.Open;
    Form7.ibDataSet100.First;
    //
    while not Form7.IBDataSet100.Eof do
    begin
      Form7.ibDataSet12.Locate('NOME',Alltrim(Form7.IBDataSet100.FieldByname('NOME').AsString),[]);
      Form7.ibDataSet12.Edit;
      Form7.ibDataSet12DIA.Asfloat := Form7.IBDataSet100.FieldByname('VENTRADA').AsFloat - Form7.IBDataSet100.FieldByname('VSAIDA').AsFloat;
      Form7.ibDataSet12.Post;
      //
      Form7.IBDataSet100.Next;
      //
    end;
  end;
  //
  Form7.ibDataSet12.EnableControls;
  //
  Screen.Cursor := crDefault;
  Form7.Close;
  Form7.sModulo := 'CONTAS';
  Form7.Show;
  //
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  //
  // LEGAL
  //
  if FileExists(Form1.sAtual+'\leia-me.txt') then
  begin
    //
    DeleteFile(pChar(Form1.sAtual+'\leia-me.txt'));
    //
  end;
  //
  Regularize(True);
  FechaTudo(bFechaTudo);
  //
  if form1.DBGrid200.Visible then
  begin
    //
    ibDataSet200.Close;
    dbGrid200.Visible := False;
    Edit200.Visible   := False;
    //
    Commitatudo(True); // SQL - Commando
    AbreArquivos(False);
    MontaTela(True);
    //
    Abort;
    //
  end;
  //
  // Form7.IBTransaction1.Commit;
  //
  begin
    //
    CommitaTudo(True); // Quando fecha o programa
    //
    try
      Mais1ini  := TIniFile.Create('ENERGIA.INI');
      Mais1Ini.WriteString('Outros','Houve queda de energia','Não'); // On close
      Mais1Ini.Free;
    except end;
    //
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.WriteString(AllTrim(Usuario),'Ativo','Não');
      Mais1Ini.WriteString(AllTrim(Usuario),'End',DateToStr(Date)+' '+TimeToStr(Time));
      Mais1Ini.UpdateFile;
      Mais1Ini.Free;
    except end;
    //
  end;
  //
  Mais1ini := TIniFile.Create(sAtual+'\smallcom.inf');
  //
  Mais1Ini.WriteString('Nota Fiscal','Especie',ConfEspecie);
  Mais1Ini.WriteString('Nota Fiscal','Marca',ConfMarca);
  Mais1Ini.Free;
  //
  Form7.IBTransaction1.Active := False;
  Form7.IbDatabase1.Close;
  //
  //
  Form1.Hide;
  //
  Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
  Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
  //
//  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Mais1ini : tIniFile;
begin
  //
  Form1.bMKP    := False;
  Form1.sPasta  := CHAVE_CIFRAR; // Sandro Silva 2022-09-19
  //
  try
    DownloadDoArquivo(PChar('http://www.smallsoft.com.br/imagens/small_aviso_promocao_1.bmp?fakevariable=%rand%, out.dat'),PChar('small_aviso_promocao_1.bmp'));
  except end;
  //
  Application.OnMessage := ScrollMouse;
  //
  Mais1ini := TIniFile.Create('WIND0WS.L0G');
  Form1.sSerial := Mais1Ini.ReadString('LICENCA','Ser','');
  Mais1ini.Free;
  //
//  Form22.Image1.Left    := ((Screen.Width - Form22.Image1.Width ) div 2)+55 - 120;
//  Form22.Image1.Top     := (Screen.Height - Form22.Image1.Height ) div 2 - 150 -100;
  //
  Form22.Image1.Left    := ((Screen.Width - Form22.Image1.Width ) div 2);
  Form22.Image1.Top     := ((Screen.Height - Form22.Image1.Height ) div 2) - 220;
//  Form22.Image1.Left    := 50;
//  Form22.Image1.Top     := 50;


//  Form22.Image1.Left    := ((Screen.Width - 750) div 2) + 60;
//  Form22.Image1.Top     := (Screen.Height - Form22.Image1.Height ) div 2 -250;

  Form22.Image1.Visible := True;
  //
  Form22.Button1.Left    := (Screen.Width - Form22.Button1.Width ) div 2;
  Form22.Button1.Top     := (Screen.Height - Form22.Button1.Height ) div 2 - 160 + 370;
  //
  Form22.Label6.Top     := Form22.Image1.Top + Form22.Image1.Height + 40;
  Form22.Label6.Width   := Screen.Width;
  Form22.Label6.Left    := 0;
  //
  Form1.WebBrowser1.Left := -2000;
  Form1.WebBrowser2.Left := -2000;
  //
  //
  // ChDIR('C:\Program Files (x86)\SmallSoft\Small Commerce');
  //
  GetDir(0,sAtual);
  Form1.BorderIcons := [biSystemMenu,biMinimize,biMaximize];
  tCrono               := Time;
  bFechaTudo           := True;
  //
  bChaveSelecionaCliente := False;
  bModoScan              := False;
  bModoSVC               := False;
  Form1.bChave16         := True;
  Form1.bFlag16Change    := True;
  //
  try
    if FileExists(Form1.sAtual+'\leia-me.txt') then ShellExecute( 0, 'Open', pChar(Form1.sAtual+'\leia-me.txt'),'', '', SW_SHOW);
    if FileExists(Form1.sAtual+'\danferb.dll') then DeleteFile(pChar(Form1.sAtual+'\danferb.dll'));
  except end;
  //
{
  try
    if FileExists(Form1.sAtual+'\nfe\nfeServidoresHom.ini')      then CopyFile(pChar(Form1.sAtual+'\nfe\nfeServidoresHom.ini'),     pChar(Form1.sAtual+'\nfeServidoresHom.ini'),false);
    if FileExists(Form1.sAtual+'\nfe\nfeServidoresHomScan.ini')  then CopyFile(pChar(Form1.sAtual+'\nfe\nfeServidoresHomScan.ini'), pChar(Form1.sAtual+'\nfeServidoresHomScan.ini'),false);
    if FileExists(Form1.sAtual+'\nfe\nfeServidoresProd.ini')     then CopyFile(pChar(Form1.sAtual+'\nfe\nfeServidoresProd.ini'),    pChar(Form1.sAtual+'\nfeServidoresProd.ini'),false);
    if FileExists(Form1.sAtual+'\nfe\nfeServidoresProdScan.ini') then CopyFile(pChar(Form1.sAtual+'\nfe\nfeServidoresProdScan.ini'),pChar(Form1.sAtual+'\nfeServidoresProdScan.ini'),false);
  except end;
}
  //
  //
  GetDir(0,sAtual);
  //
  // Atualização de arquivos
  //
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
  //
  if FileExists(Form1.sAtual+'\small.saas') then
  begin
    //
    ShellExecute( 0, 'Open',pChar('http://www.smallsaas.com.br'),'', '', SW_SHOWMAXIMIZED);
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    //
  end;
  //
  // then end
  //
end;

procedure TForm1.DadosdoEmitente1Click(Sender: TObject);
begin
  FechaTudo(bFechaTudo);
  Form17.ShowModal;
  ExibeRazaoSocialNoCaptionDoForm; // Sandro Silva 2022-12-15 
end;

procedure TForm1.Ajustararquivos1Click(Sender: TObject);
var
  sCertificado, sSerieS, sBuild, sLicenca  : String;
  SmallIni, Mais1Ini, Mais2Ini : TIniFile;
  I, J, iR, II : Integer;
  bLegal : Boolean;
  fJuro : Real;
begin
  //
  // controle de licenças de uso
  //
  Form22.Inicio := Time;
  bLegal := True;
  Form1.bMediaPonderadaFixa := False;
  //
  try
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.WriteString('Uso','Uso','1');
    Mais1Ini.Free;
    //
  except
    //
    ShowMessage('Execute este programa como administrador. Altere o atalho na aba compatibilidade.');
    // Form1.DestroyWindowHandle;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    //
  end;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  //
  try
    //
    // verifica se o susário tem direito de leitura e gravação
    //
    Mais1Ini.WriteString('Geral','Rede','OK');
    //
  except
    //
    // Não tem
    //
    ShowMessage('Verifique se o usuário do windows tem direito '+chr(10)+
                'de leitura e gravação em '+Form1.sAtual+'. Erro 1170');
//    // Form1.DestroyWindowHandle;
    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
  //
  {Sandro Silva 2022-12-28 inicio
  if (StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2022','2022.0.0.0'))) > StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:','')))) then
  begin
    ShowMessage('A build: '+Mais1Ini.ReadString('Geral','Build 2022','2022.0.0.0')+' já foi instalada na pasta: '+ sAtual+' você esta tentando'+Chr(10)+' rodar a build: '+StrTran(Form22.sBuild,'Versão e Build:','')+', este programa vai ser fechado.');
    Instalarpackcomasltimasalteraes1Click(Sender);
    // Form1.DestroyWindowHandle;
    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
  //
  if StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2020','2020.0.0.0'))) <> StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:',''))) then
  begin
    Mais1Ini.WriteString('Geral','Build 2022',StrTran(Form22.sBuild,'Versão e Build:',''));
  end;
  }
  if (StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2023','2023.0.0.0'))) > StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:','')))) then
  begin
    ShowMessage('A build: '+Mais1Ini.ReadString('Geral','Build 2023','2023.0.0.0')+' já foi instalada na pasta: '+ sAtual+' você esta tentando'+Chr(10)+' rodar a build: '+StrTran(Form22.sBuild,'Versão e Build:','')+', este programa vai ser fechado.');
    Instalarpackcomasltimasalteraes1Click(Sender);
    // Form1.DestroyWindowHandle;
    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;
  //
  if StrToFloat(LimpaNumero(Mais1Ini.ReadString('Geral','Build 2020','2020.0.0.0'))) <> StrToFloat(LimpaNumero(StrTran(Form22.sBuild,'Versão e Build:',''))) then
  begin
    Mais1Ini.WriteString('Geral','Build 2023',StrTran(Form22.sBuild,'Versão e Build:',''));
  end;
  {Sandro Silva 2022-12-28 fim}
  //
  //
  if sLicenca = '' then iR := 2 else iR := 12;
  //
  if Form1.sSerial = '' then
  begin
    Form1.sSerial  := Mais1Ini.ReadString('RR','Ser','');
  end;
  //
  if Form1.sSerial = '' then
  begin
    Form1.sSerial  := Mais1Ini.ReadString('SC','Ser','');
  end;
  //
  if Form1.sSerial = '' then
  begin
    Form1.sSerial  := Mais1Ini.ReadString('RJ','Ser','');
  end;
  //
  //[RR]
  //Ser=S14A80020025M
  //hash=8qZDzLGjgfGRp0W4xJOxxg==
  //[SC]
  //Ser=S13A80020025M
  //hash=8qZEzLGjgfGRp0W4xJOxxg==
  //[RJ]
  //Ser=S12A80020025M
  //
  //
  if Form1.sSerial = '' then
  begin
    ShowMessage('Este sistema não foi totalmente instalado nesta pasta ou'+Chr(10)+
                'não está liberado para uso neste computador, instale'+Chr(10)+
                'novamente o sistema informando o número serial da'+Chr(10)+
                'sua licença de uso.'+Chr(10)+Chr(10)+
                'Código: 001 '+sLicenca);
    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end else
  begin
    //
    iR := 2;
    //
    if Copy(Form1.sSerial,4,1) = 'A'  then iR := 12; // 12 Usuários + OS
    if Copy(Form1.sSerial,4,1) = 'B'  then iR := 07; // 07 Usuários + OS
    if Copy(Form1.sSerial,4,1) = 'C'  then iR := 02; // 02 Usuários + OS
    //
    if Copy(Form1.sSerial,4,1) = 'D' then iR := 12; // 12 Usuários
    if Copy(Form1.sSerial,4,1) = 'E' then iR := 07; // 07 Usuários
    if Copy(Form1.sSerial,4,1) = 'F' then iR := 02; // 02 Usuários
    //
    if Copy(Form1.sSerial,4,1) = 'N' then iR := 12; // 12 Usuários Small Mei + OS
    if Copy(Form1.sSerial,4,1) = 'O' then iR := 07; // 07 Usuários Small Mei + OS
    if Copy(Form1.sSerial,4,1) = 'P' then iR := 02; // 02 Usuários Small Mei + OS
    //
    if Copy(Form1.sSerial,4,1) = 'Q' then iR := 12; // 12 Usuários Small Mei
    if Copy(Form1.sSerial,4,1) = 'R' then iR := 07; // 07 Usuários Small Mei
    if Copy(Form1.sSerial,4,1) = 'M' then iR := 02; // 02 Usuários Small Mei
    //
    if Copy(Form1.sSerial,4,1) = 'S' then iR := 02;  // 02 Usuários Small Start
    if Copy(Form1.sSerial,4,1) = 'W' then iR := 256; // 256 Usuários Small Commerce
    //
    iReduzida := 0;
    //
    // Quando iReduzida for 2 é Mei
    //
    if Copy(Form1.sSerial,4,1) = 'N' then  iReduzida := 2; // 12 Usuários Small Mei + OS
    if Copy(Form1.sSerial,4,1) = 'O' then  iReduzida := 2; // 07 Usuários Small Mei + OS
    if Copy(Form1.sSerial,4,1) = 'P' then  iReduzida := 2; // 02 Usuários Small Mei + OS
    if Copy(Form1.sSerial,4,1) = 'Q' then  iReduzida := 2; // 12 Usuários Small Mei
    if Copy(Form1.sSerial,4,1) = 'R' then  iReduzida := 2; // 07 Usuários Small Mei
    if Copy(Form1.sSerial,4,1) = 'M' then  iReduzida := 2; // 02 Usuários Small Mei
    //
    if Copy(Form1.sSerial,4,1) = 'S' then  iReduzida := 1; // 02 Usuários Small Start
    //
    Form22.sTitulo := 'Small Commerce';
    //
    if (Copy(Form1.sSerial,4,1) = 'A') or
       (Copy(Form1.sSerial,4,1) = 'B') or
       (Copy(Form1.sSerial,4,1) = 'C') or
       (Copy(Form1.sSerial,4,1) = 'W') then Form22.sTitulo := 'Small Commerce + Ordem de Serviço';
    //
    if (Copy(Form1.sSerial,4,1) = 'N') or
       (Copy(Form1.sSerial,4,1) = 'O') or
       (Copy(Form1.sSerial,4,1) = 'P') then Form22.sTitulo := 'Small Mei + Ordem de Serviço';

    if (Copy(Form1.sSerial,4,1) = 'Q') or
       (Copy(Form1.sSerial,4,1) = 'R') or
       (Copy(Form1.sSerial,4,1) = 'M') then Form22.sTitulo := 'Small Mei';
    //
    // Empresas MEI
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    //
    if Mais1Ini.ReadString('LICENCA','MEI','NAO') = 'SIM' then
    begin
      Form1.iReduzida := 2;
    end else
    begin
      //
      if Mais1Ini.ReadString('LICENCA','MEI','NAO') = 'NAO' then
      begin
        Form1.iReduzida := 0;
      end;
      //
      // Note que agora é no WIND0WS.L0G individual em cada maquina
      //
      Mais2ini := TIniFile.Create('WIND0WS.L0G');
      //
      if (Mais2Ini.ReadString('LICENCA','MEI','NAO') = 'SIM') or (Length(Mais2Ini.ReadString('LICENCA','MEI','')) > 8) then
      begin
        Mais2Ini.WriteString('LICENCA','MEI','OK');
        Form1.iReduzida := 2;
      end;
      Mais2Ini.Free;
      //
      if Form1.iReduzida = 2 then
      begin
        Mais1Ini.WriteString('LICENCA','MEI','SIM');
      end;
      //
    end;
    //
    //
    if (Form1.iReduzida = 2) then
    begin
      Form22.sTitulo := StrTran(StrTran(Form22.sTitulo,'Commerce','Mei'),'Start','Mei');
    end;
    //
    if (Form1.iReduzida = 1) then
    begin
      Form1.Planodecontas1.Enabled := False;
      Form7.SPEDFiscal1.Enabled := False;
      Form7.SPEDPISCOFINS1.Enabled := False;
      Form7.RegistroFiscal1.Enabled := False;
      Form7.ImportarOS1.Enabled := False;
    end;
    //
    Form22.sLicenca := 'Licenciado para '+AllTrim(InttoStr(iR))+' usuários';
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
    then
    begin
      //
      Form22.sSerie := 'Número de série: ' + Form1.sSerial;
      //
    end else
    begin
      //
//ShowMessage(
//(Copy(Form1.sSerial,4,10) +chr(10)+ StrTran(StrTran(UpperCase('M'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')));


      ShowMessage('Este sistema não foi totalmente instalado nesta pasta ou'+Chr(10)+
                  'não está liberado para uso neste computador, instale'+Chr(10)+
                  'novamente o sistema informando o número serial da'+Chr(10)+
                  'sua licença de uso.'+Chr(10)+Chr(10)+
                  'Código: 002 '+sLicenca);

      // Form1.DestroyWindowHandle;
      Application.Terminate;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    end;
    //
    sSerieS := StrTran(Form22.sSerie,'Número de série: ','');
    //
    AutoSmallMobile1.Visible        := True;
    SincronizarSmallMobile1.Visible := True;
    //
  end;
  //
  if FileExists(Form1.sAtual+'\inicial\fundo\_small_6.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_6.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp');
  //
  if (Form1.iReduzida = 1) then
  begin
    Form1.Caption     := 'Small Commerce (START)';
    Application.Title := 'SMALL START';

    Titulo(
           'SMALL START, SIMPLES'+chr(10)+
           'FÁCIL E VERSÁTIL',

           'O Small Start é fácil de instalar,'+chr(10)+
           'simples de usar e atende a'+chr(10)+
           'necessidade de emissão de'+chr(10)+
           'NF-e, NFC-e e SAT.');
  end;
  //
  if (Form1.iReduzida = 0) then
  begin
    //
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
  //
  if (Form1.iReduzida = 2) then
  begin
    //
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

  //
  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  Mais1Ini.Free;
  Form22.sLicenca           := 'Licenciado para '+AllTrim(InttoStr(iR))+' usuários';
  Mensagem22('Aguarde abrindo arquivos...');
  Form22.Show;
  Form22.Repaint;
  //
  with Form7 do
  begin
    bFlag := True;
    //                                     //
    // Cria os arquivos no diretório atual //
    //                                     //
    form7.sProcura := '';
    Screen.Cursor             := crHourGlass;                  // Cursor de Aguardo
    //
    try
      //
      Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
      //
      if (not FileExists(Form1.sAtual+'\'+'small.fdb'))   and (FileExists(Form1.sAtual+'\'+'small.gdb'))   then RenameFile(pchar(Form1.sAtual+'\'+'small.gdb'),pchar(Form1.sAtual+'\'+'small.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'exemplo.fdb')) and (FileExists(Form1.sAtual+'\'+'exemplo.gdb')) then RenameFile(pchar(Form1.sAtual+'\'+'exemplo.gdb'),pchar(Form1.sAtual+'\'+'exemplo.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'padrao.fdb'))  and (FileExists(Form1.sAtual+'\'+'padrao.gdb'))  then RenameFile(pchar(Form1.sAtual+'\'+'padrao.gdb'),pchar(Form1.sAtual+'\'+'padrao.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'off.fdb'))     and (FileExists(Form1.sAtual+'\'+'off.gdb'))     then RenameFile(pchar(Form1.sAtual+'\'+'off.gdb'),pchar(Form1.sAtual+'\'+'off.fdb'));
      //
      if (not FileExists(Form1.sAtual+'\'+'small.fdb'))   and (FileExists(Form1.sAtual+'\'+'small.gdb'))   then
      begin
        Screen.Cursor := crDefault;
        ShowMessage('Não foi possível renomear o arquivo SMALL.GDB para SMALL.FDB'+Chr(10)+Chr(10)+
        ' 1 - Feche todos os programas que usam o SMALL.GDB em todos os terminais'+Chr(10)+
        ' 2 - Execute o Small Commerce novamente');
        // Form1.DestroyWindowHandle;
        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        //
      end;
      //
      Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
      Url      := Mais1Ini.ReadString('Firebird','Server url','');
      IP       := AllTrim(Mais1Ini.ReadString('Firebird','Server IP',''));
      Alias    := AllTrim(Mais1Ini.ReadString('Firebird','Alias',''));
      sConve   := AllTrim(Mais1Ini.ReadString('T','Tempo','00:00:00'));
      sOrigem  := AllTrim(Mais1Ini.ReadString('T','Origem','00'));
      //
      if IP = '' then IP := GetIp;
      //
      if IP <> '' then Url := IP+':'+Url+'\small.fdb' else Url:= Url+'\small.fdb';
      //
      if Alltrim(Alias) <> '' then
      begin
        Url := IP+':'+Alias;
      end;
      //
      Mais1Ini.Free;
      //
      Mensagem22(sAtual);
      Form22.sIniciandoEm   := 'Iniciando em: '+Form1.sAtual;
      Form22.sUrlDoGdb      := 'Url do FDB:   '+AllTrim(Url);
      //
      // Se não existe cria o arquivo GDB
      //
      try
        IBDatabase1.Close;
        IBDatabase1.Params.Clear;
        IbDatabase1.DatabaseName := Url;
        IBDatabase1.Params.Add('USER_NAME=SYSDBA');
        IBDatabase1.Params.Add('PASSWORD=masterkey');
        IbDatabase1.Open;
        IBTransaction1.Active := True;
        //
        // AtivaTodosOsIndices(True);
        //
      except
        //
        Mensagem22('Aguarde instalando arquivos de atualização (10)...');
        //
        while FileExists(Form1.sAtual+'\firebird.exe') do
        begin
          DeleteFile(pChar(Form1.sAtual+'\firebird.exe'));
          Sleep(1000);
        end;
        //
        if not FileExists(pChar(Form1.sAtual+'\firebird.~~1')) then
        begin
          ShowMessage('Reinstale o sistema.');
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        end;
        //
        while not FileExists(Form1.sAtual+'\firebird.exe') do
        begin
          CopyFile(pChar(Form1.sAtual+'\firebird.~~1'),pChar(Form1.sAtual+'\firebird.exe'),False);
          Sleep(100);
        end;
        //
        Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
        sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
        Mais1ini.Free;
        //
        if AllTrim(sCertificado) = '' then
        begin
          if (Copy(Form1.sSerial,4,1) <> 'N') and
             (Copy(Form1.sSerial,4,1) <> 'O') and
             (Copy(Form1.sSerial,4,1) <> 'P') and
             (Copy(Form1.sSerial,4,1) <> 'Q') and
             (Copy(Form1.sSerial,4,1) <> 'R') and
             (Copy(Form1.sSerial,4,1) <> 'M') then
          begin
            Form1.SelecionarCertificadoDigital1Click(Sender);
          end;
        end;
        //
        Form22.Image1.Visible := False;
        Mensagem22('');
        Form22.Repaint;
        Sleep(1000);
        //
        ShellExecute( 0, 'Open', pChar(Form1.sAtual+'\firebird.exe'),'', '', SW_SHOW);
        //
        while ConsultaProcesso('firebird.exe') do
        begin
          sleep(1000);
        end;
        //
        if FileExists(Form1.sAtual+'\firebird.exe') then
        begin
          DeleteFile(pChar(Form1.sAtual+'\firebird.exe'));
          Sleep(1000);
        end;
        //
        Form22.Image1.Visible := True;
        Form22.Repaint;
        //
        try
          //
          Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
          Url := Mais1Ini.ReadString('Firebird','Server url','');
          if AllTrim(Mais1Ini.ReadString('Firebird','Server IP','')) <> '' then Url := Mais1Ini.ReadString('Firebird','Server IP','')+':'+Url;
          Mais1Ini.Free;
          IBDatabase1.Close;
          IBDatabase1.Params.Clear;
          IbDatabase1.DatabaseName := Url+'\small.fdb';
          IBDatabase1.Params.Add('USER_NAME=SYSDBA');
          IBDatabase1.Params.Add('PASSWORD=masterkey');
          IbDatabase1.Open;
          IBTransaction1.Active := True;
          //
          // AtivaTodosOsIndices(True);
          //
//          Form1.este1Click(Sender); // TESTE rONEI vOLTO
          //
        except
          Screen.Cursor := crDefault;
          ShowMessage('Verifique:'+Chr(10)+Chr(10)+
          ' 1 - Se o servidor firebird está instalado (reinicie o windows).'+Chr(10)+
          ' 2 - Se o IP e a URL do servidor estão configurados corretamente.'+Chr(10)+
          ' 3 - Se a sua conexão de rede está disponível.'+Chr(10)+
          ' 4 - Se a porta 3050 está liberada no firewal do windows.'+Chr(10)+
          ' 5 - Se for necessário, reinstale o sistema...');
          // Form1.DestroyWindowHandle;
          Application.Terminate;
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        end;
        //
      end;
      //
      Form7.IBQuery1.Close;
      Form7.IBQuery1.SQL.Clear;
      Form7.IBQuery1.SQL.Add('select current_time,current_date from rdb$database');
      Form7.IBQuery1.Open;
      //
      Form1.tSgdb := StrToTime(Form7.IBQuery1.FieldByname('CURRENT_TIME').AsString) - Time;
      //
      // Abrindo os arquivos
      //
//    AbreArquivos(True);
      //
    except
      //
      Screen.Cursor := crDefault;
      Application.MessageBox(Pchar('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.'),'Atenção',mb_IconError+mb_Ok);
      // Form1.DestroyWindowHandle;
      Application.Terminate;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      //
    end;
  end;
  //
  J := Form7.IBDatabaseInfo1.UserNames.Count;
  //
  //  ShowMessage('Neste momento '+IntToStr(Form7.IBDatabaseInfo1.UserNames.Count)+' usuários estão usando o sistema.');
  //
  if J > iR then
  begin
    Screen.Cursor := crDefault;
    ShowMessage('Este sistema está licenciado somente para '+IntToStr(iR)+' usuários'+Chr(10)+
                'neste momento '+IntToStr(J)+' estão tentando usar o sistema.'+Chr(10)+chr(10)+
                'Você pode adquirir licenças de uso adicionais entrando'+Chr(10)+
                //'em contato com a SmallSoft.');
                'em contato com a Zucchetti pelo 0800.645.2008');
    // Form1.DestroyWindowHandle;
    Application.Terminate;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
  //
  sBuild := '';
  //
  try
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select gen_id(G_BUILD,0) from rdb$database');
    Form1.ibDataset200.Open;
    sBuild := ibDataSet200.FieldByname('GEN_ID').AsString;
    Form1.ibDataset200.Close;
    //
    if sBuild = '999' then
    begin
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
      Mais1Ini.WriteString('NFE','Ambiente','Producao');
      Mais1Ini.Free;
      //
    end;
    //
  except end;
  //
  // Genarator G_NSU_DOWNLOAD_XML
  //
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_NSU_DOWNLOAD_XML');
  Form1.ibQuery2.Open;
  //
  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_NSU_DOWNLOAD_XML');
    Form1.ibQuery2.ExecSQL;
  end;
  //
  // Genarator G_GRAFICO_RECEBER
  //
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_RECEBER');
  Form1.ibQuery2.Open;
  //
  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_RECEBER');
    Form1.ibQuery2.ExecSQL;
  end;
  //
  // Genarator G_GRAFICO_VENDAS
  //
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_VENDAS');
  Form1.ibQuery2.Open;
  //
  if form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_VENDAS');
    Form1.ibQuery2.ExecSQL;
  end;
  //
  // Genarator G_GRAFICO_CAIXA
  //
  Form1.ibQuery2.Close;
  Form1.ibQuery2.SQL.Text := 'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_GRAFICO_CAIXA');
  Form1.ibQuery2.Open;
  //
  if Form1.IBQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
  begin
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_GRAFICO_CAIXA');
    Form1.ibQuery2.ExecSQL;
  end;
  //
  try
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select NFEPROTOCOLO from VENDAS where NUMERONF=''999999'' ');
    Form1.ibDataset200.Open;
    //
    if Form1.ibDataSet200.FieldByName('NFEPROTOCOLO').Size <= 15 then
    begin
      //
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
      //
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('commit');
      Form1.ibDataset200.Open;
    end;
  except
  end;

  //Mauricio Parizotto 2023-03-27
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
      AbreArquivos(True);
      Mensagem22('Aguarde...');
    except
      Screen.Cursor := crDefault;
      Application.MessageBox(Pchar('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.'),'Atenção',mb_IconError+mb_Ok);
      // Form1.DestroyWindowHandle;
      Application.Terminate;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    end;
    //
    Mensagem22('Aguarde atualizando promoção.');
    AtualizaPromocao(True);

    {Sandro Silva 2022-12-15 inicio}
    ExibeRazaoSocialNoCaptionDoForm;
    {Sandro Silva 2022-12-15 fim}

    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    //
    if not (Form1.iReduzida = 1) then
    begin
      //
      try
        if StrtoDate(Mais1Ini.ReadString('Outros','Data','26/09/1967')) <> Date then
        begin
          //
          try
            Mais1Ini.WriteString('Outros','Data',DateToStr(Date));
            Mais1Ini.Free;
          except end;
          //
          Form22.Repaint;
          Mensagem22('Atualizando valores no contas a receber...');
          //
//          Form1.RegistrodoProgramaonline1Click(Sender);
          //
          if Form19.RadioButton1.Checked then
          begin
            try
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              Form7.ibDataSet99.SelectSQL.Add('update RECEBER set VALOR_JURO=Cast((VALOR_DUPL * (((  Cast((CURRENT_DATE - VENCIMENTO)as decimal(12,2)) ) * '+ StrTran(FloatToStr(Form1.ftaxa),',','.') +'/100)+1.00)) as decimal(12,2)) where VALOR_RECE = 0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1');
              Form7.ibDataSet99.Open;
            except end;
          end else
          begin
            try
              //
              Form7.ibDataSet7.Close;
              Form7.ibDataSet7.SelectSQL.Clear;
              Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where VALOR_RECE = 0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1');
              Form7.ibDataSet7.Open;
              Form7.ibDataSet7.First;
              //
              while not Form7.ibDataSet7.Eof do
              begin
                //
                // ShowMessage(Form7.ibDataSet7DOCUMENTO.AsString+chr(10)+Form7.ibDataSet7VALOR_JURO.AsString+Chr(10));
                //
                fJuro := Form7.ibDataSet7VALOR_DUPL.AsFloat;
                for I := 1 to  Trunc(Date - Form7.ibDataSet7VENCIMENTO.AsDateTime) do fJuro  := fJuro * ((Form1.fTaxa / 100)+1);
                if fJuro <> Form7.ibDataSet7VALOR_DUPL.AsFloat then
                begin
                  Form7.ibDataSet7.Edit;
                  Form7.ibDataSet7VALOR_JURO.AsFloat  := fJuro;
                end;
                //
                Form7.ibDataSet7.Next;
                //
              end;
              //
            except end;
          end;
          //
          // Dias de atrazo = 'CURRENT_DATE - VENCIMENTO'
          // fJuro  := fJuro * ((Form1.fTaxa / 100)+1);
          //         if fJuro <> ibDataSet7VALOR_DUPL.AsFloat then ibDataSet7VALOR_JURO.AsFloat  := fJuro;
          //
          try
            //
            Form22.Repaint;
            Mensagem22('Verificando clientes atrasados...');
            //
            Form7.ibQuery2.Close;
            Form7.ibQuery2.Sql.Clear;
            Form7.ibQuery2.Sql.Add('update CLIFOR set MOSTRAR='+QuotedStr('0')+' where MOSTRAR<>'+QuotedStr('0')+' ');
            Form7.ibQuery2.Open;
            //
            Form7.ibQuery1.Close;
            Form7.ibQuery1.Sql.Clear;
            Form7.ibQuery1.Sql.Add('select NOME, sum(VALOR_RECE) from RECEBER where coalesce(VALOR_RECE,0)=0 and VENCIMENTO < CURRENT_DATE and coalesce(ATIVO,9)<>1 group by NOME');
            Form7.ibQuery1.Open;
            //
            while not Form7.ibQuery1.eof do
            begin
              //
              Form7.ibQuery2.Close;
              Form7.ibQuery2.Sql.Clear;
              Form7.ibQuery2.Sql.Add('update CLIFOR set MOSTRAR='+QuotedStr('1')+' where NOME='+QuotedStr(Form7.ibQuery1.FieldByName('NOME').AsString )+' ');
              Form7.ibQuery2.Open;
              //
              Form7.ibQuery1.Next;
              //
            end;
            //
            Form22.Repaint;
            Mensagem22('Pronto...');
            //
            //
          except end;
          //
        end;
        //
        Form7.ibDataSet7.EnableControls;
        //
        AgendaCommit(True);
        Commitatudo(True); // SQL - Commando
        AbreArquivos(False);
        //
      except
        //
        ShowMessage('Provável falha no Banco de Dados. Erro 4412');
        // Form1.DestroyWindowHandle;
        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        //
      end;
    end;
    //
  except
    //
    ShowMessage('Para solucionar o problema siga os seguintes passos:'+chr(10)
    +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista, 7, 8)'
    +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
    +chr(10)+'3 - Arquivo "smallcom.zzz" pode estar danificado (O arquivo deve ser excluido)'
    +chr(10)+'4 - Reinstale o programa');
    // Form1.DestroyWindowHandle;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    //
  end;
  //
  // Legal
  //
  if not bLegal then
  begin
    //
    if Legal_ok(True) then
    begin
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to ' + Copy(dateToStr(Date),7,4) + Copy(dateToStr(Date),4,2) + Copy(dateToStr(Date),1,2) );
      Form1.ibDataset200.Open;
    end;
    //
  end;
  //
  //
  // Licença
  //
  try
    //
    try
      //
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
      if ValidacaoNova = False then
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
      else
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
      //
      fDias := -1;
      //
    end;
    //
    if fdias <= 0 then
    begin
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('set generator G_LEGAL to 19670926');
      Form1.ibDataset200.Open;
    end else
    begin
      //
      if fDias <= 20 then
      begin
        ShowMessage('Número de série: ' + Form1.sSerial + ' licenciado para mais ' + FloatToStr(fDias) + ' dias');
      end;
      //

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
        //
        if fDias <> 0 then
        begin
          // Exibe mensagem de alerta dos dias restantes por 5 segundos
          for I := 1 to 5 do
          begin
            //
            Mensagem22('Número de série: ' + Form1.sSerial +  chr(10) + ' licenciado para mais ' + FloatToStr(fDias) + ' dias');
            //
            Sleep(1000);
            //
          end;
        end;
        //
      end;
      {Sandro Silva 2023-03-15 fim}
    end;
  except
  end;
  //
  Screen.Cursor := crDefault;
  //
end;

procedure TForm1.Image17Click(Sender: TObject);
begin
  Form4.ShowModal;
end;

procedure TForm1.Comissodevendedores1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  Form7.Close;
  Form7.sModulo := 'VENDEDOR';
  Form7.sTitulo := 'Cadastro dos vendedores';
  Form7.sRPS := 'N';
  Form7.Show;
  //
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('liberar_modulos.htm')));
end;

procedure TForm1.Grupos1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  Form7.Close;
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
  //
  sSerial := StrTran(UpperCase(AllTrim(Small_InputForm('Cadastro de licenças de uso','Número da licença:',sSerial))),'.','');
  //
  if (Length(alltrim(sSerial)) = 13) then //sistema novo
  begin
    //
    I := StrToInt('0'+LimpaNumero(Copy(sSerial,6,6)));
    //
    // é arqui a chave pra resolver os controles de seriais                                 X
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
    then
    begin
      //
      I := StrToInt('0'+LimpaNumero(Copy(sSerial,7,5)));
      //
      if I = StrToInt('0'+LimpaNumero(Copy(Alltrim(Form22.sSerie),7+17,5))) then
      begin
        //
        Mais1ini := TIniFile.Create('WIND0WS.L0G');
        Mais1Ini.WriteString('LICENCA','Ser',sSerial); // 2019 - Cadastro Licença de uso de 2019
        Mais1Ini.Free;
        //
        ShowMessage('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.');
        // Form1.DestroyWindowHandle;
        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        //
      end else
      begin
        ShowMessage('Este número de licença não foi liberado para este serial.');
      end;
    end;
    //
  end else
  begin
    //
    if (Length(alltrim(sSerial)) = 11) then //sistema novo
    begin
      //
      sSerieS := StrTran(Form22.sSerie,'Número de série: ','');
      //
      // ShowMEssage(
      // sSerial + chr(10) +
      // Copy(sSerieS,1,3) + Copy(sSerieS,6,6) + IntToStr(StrToInt(Modulo_11(Copy(sSerieS,2,2)+Copy(sSerieS,6,6)))+57));
      //
      // S1000200257
      //
      if sSerial = Copy(sSerieS,1,3) + Copy(sSerieS,6,6) + IntToStr(StrToInt(Modulo_11(Copy(sSerieS,2,2)+Copy(sSerieS,6,6)))+57) then
      begin
        Mais1ini := TIniFile.Create('WIND0WS.L0G');
        Mais1Ini.WriteString('SC','Mob',sSerial); // Small Mobile
        Mais1Ini.Free;
        ShowMessage('Licença de uso cadastrada com sucesso. Este programa vai ser fechado.');
        // Form1.DestroyWindowHandle;
        Application.Terminate;
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      end else
      begin
        if alltrim(sSerial) <> '' then ShoWMessage('Número de licença inválido.');
      end;
      //
    end else
    begin
      if alltrim(sSerial) <> '' then ShoWMessage('Número de licença inválido.');
    end;
    //
  end;
  //
end;

procedure TForm1.UsuriosAtivos1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', 'usuarios.exe','', '', SW_SHOW);
end;

procedure TForm1.Instalarpackcomasltimasalteraes1Click(Sender: TObject);
begin
  //
  {Sandro Silva 2022-12-28 inicio
  if FileExists(Form1.sAtual+'\smallcon.exe') then
  begin
    //
    ShellExecute( 0, 'Open', 'smallcon.exe', pChar('20221001.sma '+
                                             '20221002.sma '+
                                             '20221003.sma '+
                                             '20221004.sma '+
                                             '20221005.sma '+
                                             '20221006.sma '+
                                             '20221007.sma '+
                                             '20221008.sma '+
                                             '20221009.sma '+
                                             'nfce2022.sma '+
                                             '2022_'+LowerCase(Form7.ibDataSet13ESTADO.AsString)+'.sma ')
                                             , '', SW_SHOW);
                                             //
  end;
  }
  if FileExists(Form1.sAtual+'\smallcon.exe') then
  begin
    //
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
                                             //
  end;
  {Sandro Silva 2022-12-28 fim}
  //
  Winexec('TASKKILL /F /IM "smallcdf.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  //
end;

procedure TForm1.Postit1Click(Sender: TObject);
begin
  Form28.ShowModal;
end;

procedure TForm1.Cadastrodeconvnios1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  Form7.Close;
  Form7.sModulo := 'CONVENIO';
  Form7.sTitulo := 'Cadastro de convênios';
  Form7.sRPS := 'N';
  Form7.Show;
  //
end;

procedure TForm1.Image203Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  try
    FechaTudo(bFechaTudo);
    Form7.sModulo := 'CLIENTES';
    Form1.Label201MouseLeave(Sender);
    Form7.sTitulo := 'Cadastro';
    Form7.sRPS := 'N';
    Form7.Show;
    //
    if not bClientesLiberados then
    begin
      Form7.sTitulo := 'Cadastro fornecedores';
      Form7.sRPS := 'N';
      Form7.Caption := Form7.sTitulo;
    end;
    //
    if not bFornecedoresLiberados then
    begin
      Form7.sTitulo := 'Cadastro de clientes';
      Form7.sRPS := 'N';
      Form7.Caption := Form7.sTitulo;
    end;
    //
  except

  end;
  //
  //
end;

procedure TForm1.Image202Click(Sender: TObject);
var
  I : Integer;
begin
  if not (Form13.Tag = 99) then
  begin
    if not Legal(True) then Abort;
  end;

  // Teste
  try
    FechaTudo(bFechaTudo);
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

procedure TForm1.Image206Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  if not (Form1.iReduzida = 1) then
  begin
    try
      FechaTudo(bFechaTudo);
      Form7.sModulo := 'BANCOS';
      Form1.Label201MouseLeave(Sender);
      Form7.sTitulo := 'Controle bancário';
      Form7.sRPS := 'N';
      Form7.Show;
    except end;
  end;
end;

procedure TForm1.Image201Click(Sender: TObject);
var
  Mais1ini : tIniFile;
begin
  //
  try
    //
    if not Legal(True) then Abort;
    //
    // NFe com CPF
    //
    if Length(LimpaNumero(Form7.ibDataSet13CGC.AsString)) = 11 then
    begin
      //
      if Form1.bNotaVendaLiberada  then Form7.Notasfiscaisdesadavendassrie9201.Enabled := True       else Form7.Notasfiscaisdesadavendassrie9201.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := True else Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := False;
      //
      Form7.Vendas_1.Enabled                         := False;
      Form7.NotasfiscaisdesadavendasSrie11.Enabled   := False;
      Form7.NotasfiscaisdesadavendasSrie21.Enabled   := False;
      //
      try
        if (StrToInt(LimpaNumero(Form1.sSerieEspecial)) > 920) and (StrToInt(LimpaNumero(Form1.sSerieEspecial)) <= 969) then
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
      //
      Form7.Vendas2.Enabled := False;
      //
    end else
    begin
      //
      if Form1.bNotaVendaLiberada  then Form7.Vendas_1.Enabled := True else Form7.Vendas_1.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendasSrie11.Enabled := True else Form7.NotasfiscaisdesadavendasSrie11.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Notasfiscaisdesadavendassrie21.Enabled := True else Form7.NotasfiscaisdesadavendasSrie21.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Vendas_XXX.Enabled := True else Form7.Vendas_XXX.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := True else Form7.NotasfiscaisdesadavendassrieXXX1.Enabled := False;
      if Form1.bNotaVendaLiberada  then Form7.Vendas2.Enabled := True else Form7.Vendas2.Enabled := False;
      //
      Form7.Notasfiscaisdesadavendassrie9201.Enabled := False;
      Form7.NotasfiscaisdesadavendascomCPFsrie9201.Enabled := False;
      //
    end;
    //
    if Form1.bNotaCompraLiberada then Form7.Compras_1.Enabled := True else Form7.Compras_1.Enabled := False;
    if Form1.bNotaCompraLiberada then Form7.Compras2.Enabled := True else Form7.Compras2.Enabled := False;
    //
    if Form1.sSerieEspecial <> 'XXX' then
    begin
      if AllTrim(Form1.sSerieEspecial) <> '' then
      begin
        //
        Form7.Vendas_XXX.Visible                           := True;
        Form7.Vendas_XXX.Caption                           := 'Notas fiscais de saída (vendas) série '+StrZero(StrToInt(LimpaNumero(Form1.sSerieEspecial)),3,0);
        Form7.NotasfiscaisdesadavendassrieXXX1.Caption     := 'Notas fiscais de saída (vendas) série '+StrZero(StrToInt(LimpaNumero(Form1.sSerieEspecial)),3,0);
        Form7.NotasfiscaisdesadavendassrieXXX1.Visible     := True;
        //
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
    //
    Form1.Label201MouseLeave(Sender);
    //
    if Form12.Visible then Form12.Show;
    //
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
end;


procedure TForm1.Image208Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
  sArquivo : String;
  bButton : Integer;
begin
  //
  Form7.sModulo := 'BACKUP';
  Form1.Label201MouseLeave(Sender);
  SelectDirectory('Selecione um dispositivo de armazenamento externo que seja seguro para fazer uma cópia do banco de dados.', '', sArquivo);
  //
  if sArquivo <> '' then
  begin
    //
    sArquivo := StrTran(sArquivo+'\'+Limpanumero(Form7.ibDataset13CGC.AsString)+'_'+Alltrim(DiaDaSemana(date))+'.zip','\\','\');
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    try
      Commitatudo(True); // SQL - Commando
    except end;
    try
      FechaTudo(bFechaTudo);
      Form7.ibDataSet13.Close;
    except end;
    //
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
    Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
    //
    while Form7.ibDataSet13.Active do
      Sleep(100);
    //
    if FileExists(Alltrim(Form1.sAtual + '\small.fdb')) then
    begin
      //
      while FileExists(sArquivo) do
      begin
        deletefile(pChar(sArquivo));
        sleep(100);
      end;
      //
      if FileExists(Alltrim(Form1.sAtual + '\small.fdb')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\small.fdb')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
        //
      end;
      //
      if FileExists(Alltrim(Form1.sAtual + '\nfe.ini')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\nfe.ini')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
      end;
      //
      if FileExists(Alltrim(Form1.sAtual + '\smallcom.inf')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\smallcom.inf')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
        //
      end;
      //
      if FileExists(Alltrim(Form1.sAtual + '\est0que.dat')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\est0que.dat')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
        //
      end;
      //
      if FileExists(Alltrim(Form1.sAtual + '\ANVISA.FDB')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\ANVISA.FDB')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
        //
      end;
      {Sandro Silva 2023-03-14 inicio - Ficha 6517}
      // Backup configurações da NFS-e
      if FileExists(Alltrim(Form1.sAtual + '\nfseConfig.ini')) then
      begin
        //
        ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\nfseConfig.ini')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
        //
        while ConsultaProcesso('szip.exe') do
        begin
          sleep(100);
        end;
        //
      end;

      {Sandro Silva 2023-03-14 fim}
      //
      ShellExecute( 0, 'Open','szip.exe',pChar('backup "'+Alltrim(Form1.sAtual + '\logo*.bmp')+'" "'+sArquivo+'"'), '', SW_SHOWMAXIMIZED);
      //
      while ConsultaProcesso('szip.exe') do
      begin
        sleep(100);
      end;
      //
      while not FileExists(sArquivo) do
      begin
        sleep(100);
      end;
      //
      Screen.Cursor := crDefault; // Cursor de Aguardo
      //
      if FileExists(sArquivo) then
      begin
        //
        if (Copy(UpperCase(Form1.sAtual),1,2) = Copy(UpperCase(sArquivo),1,2)) and (Copy(sArquivo,2,1)=':') then
        begin
          Application.MessageBox(Pchar(
          'O Sistema fez uma cópia compactada do banco de dados em: '+chr(10)+chr(10)+ sArquivo +chr(10)+chr(10)+
          'Está cópia não está segura em caso de defeito de equipamento, roubo, formatação indevida ou em outra eventualidade. Faça uma cópia em um dispositivo externo.'+Chr(10)+Chr(10)+Chr(10))
          ,'Atenção',mb_Ok + MB_ICONWARNING);
        end else
        begin
          //
          bButton := Application.MessageBox(Pchar(
          'O Sistema fez uma cópia compactada do banco de dados em: '+chr(10)+chr(10)+ sArquivo +chr(10)+chr(10)+
          'Em caso de defeito de equipamento, roubo, formatação indevida do seu servidor ou em outra eventualidade está copia está realmente segura?'+Chr(10)+Chr(10)+Chr(10))
          ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
          //
          if bButton = IDYES then
          begin
            //
            Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
            Mais1Ini.WriteString('Backup','Último backup',DateToStr(date));
            Form19.Button1Click(Sender);
            //
          end;
        end;
      end else
      begin
        Application.MessageBox(Pchar(
        'Erro ao criar o arquivo: '+chr(10)+chr(10)+ sArquivo +chr(10)+chr(10))
        ,'Atenção',mb_Ok + MB_ICONWARNING);
      end;
      //
    end else
    begin
      Application.MessageBox(Pchar(
      'Erro não foi possível fazer o backup. Aquivo: '+chr(10)+chr(10)+ Alltrim(Form1.sAtual + '\small.fdb') +chr(10)+chr(10)+'não encontrado')
      ,'Atenção',mb_Ok + MB_ICONWARNING);
    end;
    //
    try
      AbreArquivos(True);
    except
    end;
    //

   // se o tamanho do zip for menor de 10% do fdb
   // entao
   //    mensagem('Este bk nao parece estar completo.  ')
   // end



    //
  end;
  //
  if Form7.sModulo <> 'INDICADORES' then
    Form7.sModulo := '';
  //
  //iUsuariosAtivos := Form7.IBDatabaseInfo1.UserNames.Count;
  //
  // if iUsuariosAtivos = 1 then
  //
end;

procedure TForm1.Image207Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  //
  Form7.sAjuda := 'config.htm';
  Form7.sModulo := 'CONFIG';
  Form1.Label201MouseLeave(Sender);
  //
  try
    FechaTudo(bFechaTudo);
  except end;
  //
  try
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    if Form24.Visible then Form24.Close;
    if Form12.Visible then Form12.Close;
    if Form7.Visible then Form7.Close;
    if Form30.Visible then Form30.Close;
    if Form48.Visible then Form48.Close;
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    //
    if AllTrim(Mais1Ini.ReadString(Usuario,'B7','0')) <> '1' then
    begin
      //
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
      //
    end else
    begin
      //
      Comissodevendedores1.Enabled := True;
      Cadastrodeconvnios1.Enabled  := True;
      TabeladeICMparatodososestados1.Enabled := True;
      Limparmovimento1.Enabled := True;
      Cadastrarlicenasdeuso1.Enabled := True;
      UsuriosAtivos1.Enabled := True;
      Instalarpackcomasltimasalteraes1.Enabled := True;
      Cadastrodoemitente1.Enabled := True;
      Cadastrodetcnicos1.Enabled := True;
      //
      if (Form1.iReduzida = 1) then
      begin
        Planodecontas1.Enabled := False;
      end else
      begin
        Planodecontas1.Enabled := True;
      end;
      //
      Cadastrodetransportadoras1.Enabled := True;
      Grupos1.Enabled                    := True;
      SQLMododecomando1.Enabled          := True;
      ConfiguraodaNFe2.Enabled           := True;
      //
    end;
    //
    PopupMenu1.Popup(Form1.Image207.Left,Form1.Image207.Top + Form1.Image207.Height + 35);
    //
    Mais1Ini.Free;
    //
  except end;
  //
  Screen.Cursor := crDefault; // Cursor de Aguardo
  //
end;

procedure TForm1.wwwsmallsoftcombr1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open','http://www.smallsoft.com.br','', '', SW_SHOWMAXIMIZED);
end;

procedure TForm1.Image204Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  if not (Form1.iReduzida = 1) then
  begin
    try
      FechaTudo(bFechaTudo);
      Form7.sModulo := 'RECEBER';
      Form1.Label201MouseLeave(Sender);
      Form7.sTitulo := 'Contas a receber';
      Form7.sRPS := 'N';
      Form7.Show;
    except end;
  end;
end;

procedure TForm1.Image210Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  if not (Form1.iReduzida = 1) then
  begin
    try
      FechaTudo(bFechaTudo);
      Form7.sModulo := 'PAGAR';
      Form1.Label201MouseLeave(Sender);
      Form7.sTitulo := 'Contas a pagar';
      Form7.sRPS := 'N';
      Form7.Show;
    except end;
  end;  
end;

procedure TForm1.Image201_Click(Sender: TObject);
begin
  //
  if not Legal(True) then Abort;
  //
  try
    FechaTudo(bFechaTudo);
    Form7.sModulo := 'OS';
    Form1.Label201MouseLeave(Sender);
    Form7.sTitulo := 'Ordem de serviço';
    Form7.sRPS := 'N';
    Form7.Show;
  except end;
  //
  if Form30.Visible then Form30.Show;
  //
end;

procedure TForm1.Cadastrodetcnicos1Click(Sender: TObject);
begin
  //
  FechaTudo(bFechaTudo);
  Form7.Close;
  Form7.sModulo := 'TECNICO';
  Form7.sTitulo := 'Cadastro de técnicos';
  Form7.sRPS := 'N';
  Form7.Show;
  //
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
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1 color=FF0000>Dom</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1>Seg</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1>Ter</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1>Qua</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1>Qui</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1>Sex</font></td>');
    WriteLn(F,'     <td nowrap align=Right width=30><font face="verdana" size=1 color=FF0000>Sab</font></td>');
    WriteLn(F,'    </tr>');
    //
    WriteLn(F,'    <tr bgcolor=#FFFFFF>');
    //
    dContador  := StrToDate('01/'+StrZero(J,2,0)+'/'+StrZero(Year(Date),4,0));
    //
    for I := 1 to DayOfWeek(dContador)-1 do WriteLn(F,'     <td nowrap align=left><font face="verdana" size=1></td>');
    //
    for I := 1 to DiasPorMes(Year(Date),J) do
    begin
      if DayOfWeek(dContador) = 1 then WriteLn(F,'    <tr bgcolor=#FFFFFF>');
      WriteLn(F,'     <td nowrap  align=Right><font face="verdana" size=1 color=c0c0c0>'+IntToStr(Day(dContador))+'</td>');
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
  //
  // Nota
  //
  Form44.Close;
  //
  if not ((Form7.sModulo = 'NOTA') or (Form7.sModulo = 'CONFOS') or (Form7.sModulo = 'CONFRECIBO')) then
  begin
    Form1.Panel_3.Visible := True;
  end;
  //
  // Vendas
  //
  if Label201.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'VENDA') then
    begin
      //
      Image201.Picture := Image201_R.Picture;
      Label201.Font.Style := [];
      Label201.Font.Color := clBlack;
      //
      Image201S.Picture    := Image201S_R.Picture;
      Label201S.Font.Style := [];
      Label201S.Font.Color := clBlack;
      //
    end;
    //
    if (Form7.sRPS = 'S') then
    begin
      Image201.Picture := Image201_R.Picture;
      Label201.Font.Style := [];
      Label201.Font.Color := clBlack;
    end;
    //
  end;
  //
  // Compras
  //
  if Label201C.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'COMPRA') then
    begin
      Image201C.Picture    := Image201C_R.Picture;
      Label201C.Font.Style := [];
      Label201C.Font.Color := clBlack;
    end;
    //
  end;
  //
  // Serviços
  //
  if Label201S.Font.Style <> [] then
  begin
    //
    if (Form7.sRPS <> 'S') then
    begin
      Image201S.Picture    := Image201S_R.Picture;
      Label201S.Font.Style := [];
      Label201S.Font.Color := clBlack;
    end;
    //
  end;
  //
  // INDICADORES
  //
  if Label200.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'INDICADORES') then
    begin
      Image200.Picture := Image200_R.Picture;
      Label200.Font.Style := [];
      Label200.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
  end;
  //
  // OS
  //
  if Label201_.Font.Style <> [] then
  begin
    if (Form7.sModulo <> 'OS') then
    begin
      Image201_.Picture := Image201__R.Picture;
      Label201_.Font.Style := [];
      Label201_.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
  end;
  //
  // ESTOQUE
  //
  if Label202.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'ESTOQUE') then
    begin
      Image202.Picture := Image202_R.Picture;
      Label202.Font.Style := [];
      Label202.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // CADATRO
  //
  if Label203.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'CLIENTES') then
    begin
      Image203.Picture := Image203_R.Picture;
      Label203.Font.Style := [];
      Label203.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // RECEBER
  //
  if Label204.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'RECEBER') then
    begin
      Image204.Picture := Image204_R.Picture;
      Label204.Font.Style := [];
      Label204.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // PAGAR
  //
  if Label210.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'PAGAR') then
    begin
      Image210.Picture := Image210_R.Picture;
      Label210.Font.Style := [];
      Label210.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // CAIXA
  //
  if Label205.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'CAIXA') then
    begin
      Image205.Picture := Image205_R.Picture;
      Label205.Font.Style := [];
      Label205.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // BANCOS
  //
  if Label206.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'BANCOS') then
    begin
      Image206.Picture := Image206_R.Picture;
      Label206.Font.Style := [];
      Label206.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // CONFIG
  //
  if Label207.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'CONFIG') then
    begin
      Image207.Picture := Image207_R.Picture;
      Label207.Font.Style := [];
      Label207.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  // BACKUP
  //
  if Label208.Font.Style <> [] then
  begin
    //
    if (Form7.sModulo <> 'BACKUP') then
    begin
      Image208.Picture := Image208_R.Picture;
      Label208.Font.Style := [];
      Label208.Font.Color := clBlack;
      // Form1.Panel_0.Repaint;
    end;
    //
  end;
  //
  MontaTela(True);
  //
end;

procedure TForm1.Label201MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone NF-e
  //
  if Label201.Font.Style <> [fsBold] then
  begin
    Image201.Picture    := Image201_X.Picture;
    Label201.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      //
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_10.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_10.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_10.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_10.bmp');
      //
      Titulo(

            'EMITA A NF-e DE'+chr(10)+'VENDA',

            'A Nota Fiscal Eletrônica além de'+chr(10)+
            'atender a legislação controla as'+chr(10)+
            'vendas da sua empresa'+chr(10)+
            'de forma automática'

            );
      //
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.SQLMododecomando1Click(Sender: TObject);
var
  Retangulo : tRect;
  wndHandle : THandle;
  wndClass  : array[0..50] of char;
begin
  //
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
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_sql.htm')));
  if KEY = VK_RETURN then
  begin
    Audita('SQL','SMALL', Senhas.UsuarioPub, Copy(Edit200.Text+replicate(' ',80),1,80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
    ExecutaSql(True);
  end;
  //
  if Key = VK_ESCAPE then
  begin
    //
    try
      ibDataSet200.Close;
      dbGrid200.Visible := False;
      Edit200.Visible   := False;
      //
      Commitatudo(True); // SQL - Commando
      AbreArquivos(False); 
      //
      MontaTela(True);
      //
    except end;
    //
  end;
  //
  Screen.Cursor := crDefault;
  //
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
      Application.MessageBox(pChar(E.Message+'.. Ao executar EXECUTA.SQL.'),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  CommitaTudo(True); // bakcup Ok
  //{Sandro Silva 2023-04-17 inicio
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
  //}
  iUsuariosAtivos := Form7.IBDatabaseInfo1.UserNames.Count;
  //
  if iUsuariosAtivos = 1 then
  begin
    //
    Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
    //
    try
      //
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
    //
  end;
  //
  try
    //
    Form7.IBDatabase1.Connected := False;
    //
    Form7.IBBackupService1.Attach;
    Form7.IBBackupService1.ServerName      := 'localhost';
    Form7.IBBackupService1.DatabaseName    := Form1.sAtual+'\small.fdb';
    Form7.IBBackupService1.BackupFile.Text := 'off13.gbak';
    //
    Form7.IBBackupService1.Options := [MetadataOnly];
    //
    Form7.IBBackupService1.Active          := True;
    Form7.IBBackupService1.ServiceStart;
    //
    Result := '';
    while ( not Form7.IBBackupService1.Eof ) do
    begin
      Result := Form7.IBBackupService1.GetNextLine;
      if AllTrim(Result) <> '' then
        ShowMessage(Result);
    end;
    //
    Form7.IBBackupService1.Active := False;
    //
    Form7.IBRestoreService1.ServerName          := 'localhost';
    Form7.IBRestoreService1.BackupFile.Clear;
    Form7.IBRestoreService1.DatabaseName.Clear;
    //
    Form7.IBRestoreService1.BackupFile.Text   := 'off13.gbak';
    Form7.IBRestoreService1.DatabaseName.Text := Form1.sAtual+'\off13.fdb';
    Form7.IBRestoreService1.Attach;
    Form7.IBRestoreService1.Active := True;
    Form7.IBRestoreService1.ServiceStart;
    //
    Result := '';
    while not Form7.IBRestoreService1.Eof do
    Begin
      Result := Form7.IBRestoreService1.GetNextLine;
      Application.ProcessMessages;
      if AllTrim(Result) <> '' then
        ShowMessage(Result);
    End;
    //
    Form7.IBRestoreService1.Active := False;
    //
  except
  end;
  //
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
  //
  {Sandro Silva 2022-12-28 inicio}
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  // Ajusta generator para PK_SERIE da tabela SERIE, onde armazena o número de série usado no cadastro de produtos
  try
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(REGISTRO) from SERIE');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_SERIE to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;

    //ShowMessage('Teste 10243 ' + Form1.ibQuery1.SQL.Text);
    //
  except
    on E: Exception do
    begin
      //ShowMessage('Teste 10243 ' + E.Message);
    end;
  end;
  {Sandro Silva 2022-12-28 fim}
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_ORCAMENTO ');
    Form1.ibQuery1.ExecSQL;
    Form1.ibQuery1.Close;
  except end;
  try
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select max(PEDIDO) from ORCAMENT');
    Form1.ibQuery1.Open;
    sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_ORCAMENTO to 0'+sMax+' ');
    Form1.ibQuery1.ExecSQL;
    //
  except end;
  //
  // NSU
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_NSU ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
  //
  // NF SERIE 1
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIE1 ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
  //
  // NF SERIE 2
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIERPS ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
    //
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

      //ShowMessage('TESTE 10364 SERIE ESPECIAL "' + FORM1.sSerieEspecial + '" ' + Form1.ibQuery1.SQL.Text );

    except
    end;
  end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_SERIE920');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
  //
  // OS
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_NUMEROOS ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
  //
  // CODIGO Código do produto no estoque
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_CODIGO ');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  // Créditos para liberação da NF-e
  //
  try
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create generator G_C0DIG0 ');
    Form1.ibQuery1.ExecSQL;
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('set generator G_C0DIG0 to 500');
    Form1.ibQuery1.ExecSQL;
    //
  except end;
  //
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
  //
  // Indices
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_CODIGO ON ALTERACA (CODIGO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_PEDIDO_ITEM ON ALTERACA (PEDIDO, ITEM)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_ALTERACA_PEDIDODATACX ON ALTERACA (PEDIDO, DATA, CAIXA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  // Indices
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND1MOVIMENT on MOVIMENT(PREDATA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND2MOVIMENT on MOVIMENT(EMISSAO)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND3MOVIMENT on MOVIMENT(COMPENS)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND1DATA on CAIXA(DATA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  // Indices
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_NFCE_DATA ON NFCE (DATA)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_NFCE_NUMERONF ON NFCE (NUMERONF)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  //
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('create index IND2NOME on CLIFOR(NOME)');
    Form1.ibQuery1.ExecSQL;
  except end;
  //
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
  //
  Mensagem22('Aguarde ajustando arquivos ' + NumeroArquivo() + '...');
  Commitatudo(True);
  //
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
  //
  try
    //
    // Ativa todos os indices
    //
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select i.rdb$index_name,i.rdb$unique_flag,i.rdb$relation_name,s.rdb$field_name from rdb$indices i join rdb$index_segments s on (i.rdb$index_name = s.rdb$index_name) where i.rdb$index_name not like '+QuotedStr('RDB$%')+' and i.rdb$index_inactive=1');
    Form1.ibQuery1.Open;
    //
    sMensagem2 := '';
    //
    while not Form1.ibQuery1.Eof do
    begin
      try
        sMensagem2 := sMensagem2 + AllTrim(Form1.ibQuery1.Fields[0].asString)+', ';
        Form1.ibQuery1.Next;
      except end;
    end;
    //
    if AllTrim(sMensagem2)<>'' then
    begin
      ShowMessage('Não foi possível ativar os seguintes indices: '+chr(10)+chr(10)+sMensagem2+chr(10)+chr(10)+'Feche o sistema nas outras máquinas e tente novamente.' );
    end else
    begin
      sMensagem := sMensagem + ' e indíces ativados';
    end;
    //
    Form1.ibQuery1.Close;
    //
  except end;
  //
  sResponsavelTecnico := '';
  //
  try
//    Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
//    sOrigem  := AllTrim(Mais1Ini.ReadString('T','Origem','00'));
  except end;
  //
//  ShowMessage(sOrigem);
  //
//  if (Form1.sOrigem = '00') or (Form1.sOrigem = '') then
  begin
    //
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
      //
      Form1.ibQuery1.Close;
      Form1.ibQuery1.SQL.Clear;
      // Sandro Silva 2023-01-03 Form1.ibQuery1.SQL.Add('select NFEXML, EMISSAO from VENDAS where EMITIDA=''S'' and NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO');
      // Listar xml com responsável diferente da Smallsoft ou Zucchetti
      Form1.ibQuery1.SQL.Add('select NFEXML, EMISSAO from VENDAS where EMITIDA=''S'' and (NFEXML not like ''%<infRespTec><CNPJ>07426598000124</CNPJ>%'' and NFEXML not like ''%<infRespTec><CNPJ>03916076000664</CNPJ>%'') and NFEXML like ''%<infRespTec><CNPJ%'' order by EMISSAO');
      Form1.ibQuery1.Open;
      Form1.ibQuery1.Last;
      //
      sResponsavelTecnico := xmlNodeValue(Form1.ibQuery1.FieldByname('NFEXML').AsString, '//infRespTec/CNPJ');
      //
    end;
    //
//    ShowMessage('Teste: '+sResponsavelTecnico);
    //
    if sResponsavelTecnico <> '' then
    begin
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\small.ini');
      Mais1Ini.WriteString('T','Origem',sResponsavelTecnico); // Cadastro Licença de uso
      //
      if sConve = '00:00:00' then
      begin
        Mais1Ini.WriteString('T','Tempo','00:05:'+StrZero(Random(50),2,0)); // Cadastro Licença de uso
      end;
      //
      Mais1Ini.Free;
      //
    end;
    //
  end;
  //

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
      ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message);
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
      ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message);
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
      ShowMessage(Form1.IBQuery1.SQL.Text + #13 + E.Message);
    end;
  end;
  {Sandro Silva 2023-03-29 fim}

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
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        WriteLn(F,'  <th nowrap><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].DisplayName+'</font></th>');
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
      //
    end;
    //
    J := 0;
    for I := 1 to 200 do vTotal[I] := 0;
    //
    ibDataSet200.DisableControls;
    ibDataSet200.First;
    while not Form1.ibDataSet200.Eof do
    begin
      //
      J := J + 1;
      //
      if Form1.bHtml1 then
      begin
        WriteLn(F,' <tr>');
        for I := 0 to dbGrid200.FieldCount -1 do
        begin
          if dbGrid200.Fields[I].DataType = ftFloat then
          begin
            WriteLn(F,'  <td nowrap align=right><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].asString+'</font></td>');
            vTotal[I] := vTotal[I] + dbGrid200.Fields[I].AsFloat;
          end else
          begin
            if dbGrid200.Fields[I].DisplayName =  'FOTO' then
            begin
              WriteLn(F,'  <td nowrap><font face="Microsoft Sans Serif" size=1>FOTO</font></td>');
            end else
            begin
              WriteLn(F,'  <td nowrap><font face="Microsoft Sans Serif" size=1>'+dbGrid200.Fields[I].asString+'</font></td>');
            end;
          end;
        end;
        WriteLn(F,' </tr>');
      end else
      begin
        for I := 0 to dbGrid200.FieldCount -1 do
        begin
          if dbGrid200.Fields[I].DataType = ftFloat then
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
        //
      end;
      //
      Form1.ibDataSet200.Next;
      //
    end;
    ibDataSet200.EnableControls;
    //
    if Form1.bHtml1 then
    begin
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        if dbGrid200.Fields[I].DataType = ftFloat then
        begin
          WriteLn(F,'  <td nowrap align=right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[vTotal[I]])+'</font></td>');
        end else
        begin
          WriteLn(F,'  <td nowrap></td>');
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
      WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>Através do seguinte comando SQL digitado pelo operador: <br>'+Form1.ibDataSet200.SelectSQL.Text+'</center>');
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
      for I := 0 to dbGrid200.FieldCount -1 do
      begin
        if dbGrid200.Fields[I].DataType = ftFloat then
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
        if dbGrid200.Fields[I].DataType = ftFloat then
        begin
          Write(F,Format('%'+IntToStr(dbGrid200.Fields[I].DisplayWidth)+'.'+Form1.ConfCasas+'n',[vTotal[I]])+' ');
        end else
        begin
          Write(F,Replicate(' ',dbGrid200.Fields[I].DisplayWidth)+' ');
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
      WriteLn(F,'Através do seguinte comando SQL digitado pelo operador: '+Form1.ibDataSet200.SelectSQL.Text+' ');
      WriteLn(F,'Número de registros: '+IntToStr(J)+'');
      CloseFile(F);                                    // Fecha o arquivo
      if FileExists(Senhas.UsuarioPub+'.txt') then ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOW);
      //
    end;
    //
  end;
  //
end;

procedure TForm1.estardesempenho1Click(Sender: TObject);
var
  Hora, Min, Seg, cent : Word;
  tInicio : tTime;
begin
  //
  Screen.Cursor            := crHourGlass;
  //
  tInicio := time;
  with form7 do
  begin
    //
    Form1.Image205Click(Sender); // Caixa
    Form7.Vendas_1Click(Sender); // Vendas
    Form1.Image202Click(Sender); // Estoque
    Form1.Image203Click(Sender); // Clientes
    Form1.Image204Click(Sender); // Receber
    Form1.Image210Click(Sender); // Pagar
    Form1.Image206Click(Sender); // Bancos
    Form7.Close;
    //
  end;
  //
  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  Screen.Cursor            := crDefault;
  //
  ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10)+' Nota: '+ StrZero(10-(((Time - tInicio)*10000*2)),5,2));
  //
  Audita('TESTOU','SMALL', Senhas.UsuarioPub,'Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10)+' Nota: '+ StrZero(10-(((Time - tInicio)*10000*2)),5,2),0,0); // Ato, Modulo, Usuário, Histórico, Valor
  //
  if (10-(((Time - tInicio)*10000*2))) < 0 then
  begin
    //
    ShowMessage('Seu sistema está muito lento.'+chr(10)+
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
      );
    //
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
  //
  try
    I := FindFirst(sAtual + '\Plug-in\' + '*.exe' ,faAnyFile, S);
    Plugin1.Visible := False;
    //
    while I = 0 do
    begin
      //
      JaTem := False;
      for I := 0 to Plugin1.Count -1 do
      begin
        if Alltrim(Plugin1.Items[I].Caption) = StrTran(AllTrim(S.Name),'.exe','') then
        begin
          JaTem := True;
        end;
      end;
      //
      if not Jatem then
      begin
        NewItem         := TMenuItem.Create(Plugin1);
        NewItem.Caption := Alltrim(StrTran(AllTrim(S.Name),'.exe',''));
        NewItem.OnClick := Form1.ExecutaOPlugin;
        Plugin1.Add(NewItem);
        Plugin1.Visible := True;
      end;
      //
      I := FindNext(S);
      //
    end;
    //
    // FindClose(S);
    //
  except end;
  //  
end;

procedure TForm1.Liberarosmdulosparaesteusurio1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
begin
  //
  Form7.Close;
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
    //
    Form1.Label207.Tag     := 0;
    Form2.ShowModal;
    //
  end else
  begin
    ShowMessage('Senha do administrador inválida.');
  end;
  //
  Form1.FormShow(Sender);
  Form1.Activate;
  Mais1Ini.Free;
  //
end;

procedure TForm1.RegistrodoProgramaonline1Click(Sender: TObject);
var
  sNFCE :String;
begin
  //
  sPublicCheck := GeraCheck;
  //
  try
    //
    try
      //
      Form7.ibQuery1.Close;
      Form7.ibQuery1.Sql.Clear;
      Form7.ibQuery1.Sql.Add('select count(REGISTRO) from NFCE');
      Form7.ibQuery1.Open;
      //
      sNFCE := Form7.ibQuery1.FieldByname('COUNT').AsString;
      //
    except end;
    //
//    if ParamCount = 0 then
    begin
      //
     {
     Form1.WebBrowser1.Navigate(pChar('http://www.smallsoft.com.br/legal.php'+
                                    '?serial='    + AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))+
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
                                    '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20)))
                                    //'&retorno=json'
                                    );
      }
      if ValidacaoNova = False then
      begin

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
                                      '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20)))
                                      );

        {
        Form1.WebBrowser1.Navigate(pChar('http://www.smallsoft.com.br/legal2.php'+
                                      '?serial='    + AllTrim(Copy(Form22.sSerie+Replicate(' ',50),18,20))+
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
                                      '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20)))
                                      );
        }
      end
      else
      begin

        //Form1.WebBrowser1.Navigate(pChar('http://192.168.210.29/legal.php?'+
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
                                      '&build='     + AllTrim(Copy(Form22.sBuild+Replicate(' ',10),16,20)))
                                      //+ '&retorno=json'
                                      );

      end;
      //
    end;
    //
//    Form1.WebBrowser2.Navigate(pChar('http://www.google.com'));
    //
    //
  except end;
  //
  Screen.Cursor             := crDefault;              // Cursor de Aguardo
  //
end;

procedure TForm1.FormShow(Sender: TObject);
var
//  bFechaOPrograma : Boolean;
  sTag, sValor : String;
  I, J, iSenha : Integer;
  Mais1Ini: TIniFile;
  sSenha, sSenhaX: String;
  Retangulo : tRect;
  wndHandle : THandle;
  wndClass  : array[0..50] of char;
begin
  //
  try
    //
    Mais1ini        := TIniFile.Create('FRENTE.INI');
    sModeloPAF      := Mais1Ini.ReadString('Frente de caixa','Modelo do ECF','02');
    sNomePAF        := Mais1Ini.ReadString('Frente de caixa','Nome do ECF','02');
    Mais1ini.Free;
    //
    if (not FileExists(Form1.sAtual+'\graficos.exe')) or (not FileExists(Form1.sAtual+'\retaguarda.chm') or (not FileExists(Form1.sAtual+'\inicial\small_22_.bmp')) ) then
    begin
      //
      ShowMessage('Não foi possível iniciar o sistema'+chr(10)+
      chr(10)+
      chr(10)+'Verifique:'+
      chr(10)+
      chr(10)+'1 - Se o servidor está ligado.'+
      chr(10)+'2 - Se a rede está acessível.'+
      chr(10)+'3 - Se o sistema foi instalado na pasta:'+
      chr(10)+
      chr(10)+'       '+sAtual+
      chr(10));
      //
      if (not FileExists(Form1.sAtual+'\graficos.exe')) then ShowMessage('O arquivo GRAFICOS.EXE não foi encontrado na pasta.');
      if (not FileExists(Form1.sAtual+'\retaguarda.chm')) then ShowMessage('O arquivo RETAGUARDA.CHM não foi encontrado na pasta.');
      if (not FileExists(Form1.sAtual+'\inicial\small_22_.bmp')) then ShowMessage('O arquivo \inicial\small_22_.bmp não foi encontrado.');
      //
      Form1.Instalarpackcomasltimasalteraes1Click(Instalarpackcomasltimasalteraes1);
      //
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      //
    end;
    //
    try
      if StrToInt(Copy(WinVersion,1,3))>=6 then iVista := 5 else iVista := 0;
      StrPCopy(@wndClass[0], 'Shell_TrayWnd');
      wndHandle:=FindWindow(@wndClass[0],nil);
      GetWindowRect(wndHandle,Retangulo);
    except end;
    //
    // cópia Automatica
    //
    try
      //
      Mais1ini                     := TIniFile.Create('FRENTE.INI');
      Form1.sModeloDocumentoFiscal := Mais1Ini.ReadString('Frente de caixa'  , 'Modelo do ECF'           ,'01');
      Mais1ini.Free;
      //
      Mais1ini           := TIniFile.Create(sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Outros','CFOP Que Nao Soma Mercadoria','XXXX') = 'XXXX' then Mais1Ini.WriteString('Outros','CFOP Que Nao Soma Mercadoria','(CFOP='+QuotedStr('5124')+' or CFOP='+QuotedStr('6124')+' or CFOP='+QuotedStr('6125')+' or CFOP='+QuotedStr('5125')+')');
      CFOP5124           := Mais1Ini.ReadString('Outros','CFOP Que Nao Soma Mercadoria','');
      //
      //    CFOP5124           := '';
      //
      Form1.fAliqICMdoCliente := Mais1Ini.ReadFloat('Outros','ICMSSTInterno',0);
      //
      CopiaSair          := Mais1Ini.ReadString('Cópia','Sair','9');
      ConfAceitaCGCDuplo := Mais1Ini.ReadString('Outros','Aceita CGC','Não');
      ConfCFOP           := Mais1Ini.ReadString('Outros','CFOP','5102');
      //
      ConfItens      := 16;
      ConfSvc        := 16;
      //
      ConfDupl1      := Mais1Ini.ReadString('Nota Fiscal','Intervalo1','7');
      ConfDupl2      := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','14');
      ConfDupl3      := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','21');
      ConfEspecie    := Mais1Ini.ReadString('Nota Fiscal','Especie','Caixas');
      ConfMarca      := Mais1Ini.ReadString('Nota Fiscal','Marca','Varias');
      SSerieEspecial := Mais1Ini.ReadString('Nota Fiscal','Serie','XXX');
      ConfCusto      := Mais1Ini.ReadString('Permitir','Vendas abaixo do custo','Sim');
      ConfDuplo      := Mais1Ini.ReadString('Permitir','Duplos','Não');
      ConfNegat      := Mais1Ini.ReadString('Permitir','Estoque negativo','Sim');
      //
      ConfFoto    := Mais1Ini.ReadString('Mobile','Fotos','Sim');
      //
      sPropaganda := Mais1Ini.ReadString('Outros','Propaganda','Este e-mail foi enviado automaticamente pelo sistema Small.'+chr(10)+'www.smallsoft.com.br');
      //
      ConfLimite  := StrTofloat(StrTran(StrTran(StrTran(StrTran(Mais1Ini.ReadString('Outros','Teto limite para tributação de IR sobre serviços','R$ 1.000,00'),'R$ ',''),'.',''),'.',''),'.',''));
      ConfIR      := StrTofloat(StrTran(StrTran(StrTran(StrTran(Mais1Ini.ReadString('Outros','Aliquota de IR','1,50 %'),' %',''),'.',''),'.',''),'.',''));
      //
      if ConfItens < 3 then Form1.ConfItens := 3;
      if ConfLimite < 0 then ConfLimite := 10.000;
      fTaxa := StrToFloat(LimpaNumeroDeixandoAVirgula(Mais1Ini.ReadString('Outros','Taxa de juros','0')));
      //
      // Casas Decimais
      //
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
      //
      ConfCasas      := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
      ConfCasasServ  := Mais1Ini.ReadString('Outros','Casas decimais na quantidade de serviços','0');
      //
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
      //
      Form7.ibDataSet4QTD_ATUAL.EditFormat      := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);
      Form7.ibDataSet4PRECO.EditFormat          := copy(Form7.ibDataSet4PRECO.DisplayFormat,3,10);
      Form7.ibDataSet16QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet16QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      Form7.ibDataSet16UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet16UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet16TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet16TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;
      //
      Form7.ibDataSet4CUSTOCOMPR.DisplayFormat  := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet4CUSTOCOMPR.EditFormat     := Form7.ibDataSet4PRECO.EditFormat;
      //
      Form7.ibDataSet4CUSTOMEDIO.DisplayFormat  := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet4CUSTOMEDIO.EditFormat     := Form7.ibDataSet4PRECO.EditFormat;
      //
      // Compra
      //
      Form7.ibDataSet23QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet23QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      Form7.ibDataSet23UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
      Form7.ibDataSet23TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;
      //
      Form7.ibDataSet23UNITARIO_O.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet23UNITARIO_O.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
      //
      Form7.ibDataSet23QTD_ORIGINAL.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet23QTD_ORIGINAL.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      //
      Form7.ibDataSet28QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet28QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      //
      // Servicos OS
      //
      Form7.ibDataSet35UNITARIO.EditFormat := Form7.ibDataSet4PRECO.EditFormat;
      Form7.ibDataSet35TOTAL.DisplayFormat := Form7.ibDataSet4PRECO.EditFormat;
      //
    except
      //
      ShowMessage('Para solucionar o problema siga os seguintes passos:'+chr(10)
      +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista)'
      +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
      +chr(10)+'3 - Arquivo "smallcom.inf" pode estar danificado (O arquivo deve ser excluido)'
      +chr(10)+'4 - Reinstale o programa');
      // Form1.DestroyWindowHandle;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      //
    end;
    //
  //  if not Form2.bFlag then Form1.Ajustararquivos1Click(Sender);
    //
    ShortDateFormat := 'dd/mm/yyyy';
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    if Senha = '' then
    begin
      //
      iSenha := 0;
      //
  //    if bFechaOPrograma then Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      //
      while iSenha < 6 do
      begin
        //
        Form22.Close;
        Form22.Show;
        //
        Mensagem22('');
        //
        Senhas.Position := poScreenCenter;
        Senhas.ShowModal;
        //
        if not Form2.bFlag then Form1.Ajustararquivos1Click(Sender);
        //
        Audita('ACESSOU','SMALL', Senhas.UsuarioPub,'ACESSOU O SISTEMA',0,0); // Ato, Modulo, Usuário, Histórico, Valor
        //
        Senha   := Senhas.SenhaPub;
        Usuario := Senhas.UsuarioPub;
        //
        Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
        Mais1Ini.UpdateFile;
        sSenhaX := Mais1Ini.ReadString(Usuario,'Chave','15706143431572013809150491382314104');
        //
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
          //
          iSenha := iSenha + 1;
          //
  //        if iSenha < 4 then
  //        begin
  //          ShowMessage(' '+Usuario+' esta senha é inválida.'+ chr(10)+
  //                      ' Tente novamente digitando sua senha correta.'+ chr(10));
  //        end;
          //
        end;
      end;
      //
    end;
    //
    try
      //
      //
      Senha   := Senhas.SenhaPub;
      Usuario := Senhas.UsuarioPub;
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.UpdateFile;
      sSenhaX := Mais1Ini.ReadString(Usuario,'Chave','15706143431572013809150491382314104');
      //
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
        //
        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1','0'))   > 0) then Image201.Visible   := True else Image201.Visible   := False;
        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_E','0')) > 0) then Image201C.Visible  := True else Image201C.Visible  := False;
        if (StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_S','0')) > 0) then Image201S.Visible  := True else Image201S.Visible  := False;
        //
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B_','0'))  > 0 then Image201_.Visible := True else Image201_.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B2','0'))  > 0 then Image202.Visible  := True else Image202.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B3','0'))  > 0 then Image203.Visible  := True else Image203.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B4','0'))  > 0 then Image204.Visible  := True else Image204.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B5','0'))  > 0 then Image205.Visible  := True else Image205.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B6','0'))  > 0 then Image206.Visible  := True else Image206.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B7','0'))  > 0 then Image207.Visible  := True else Image207.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B8','0'))  > 0 then Image208.Visible  := True else Image208.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B10','0')) > 0 then Image210.Visible  := True else Image210.Visible := False;
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B11','0')) > 0 then Image200.Visible  := True else Image200.Visible := False;
        //
        // Indicadores
        //
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
        //
        // Ordem de apresentaçao dos indicadores
        //
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
        //
        // E Importante fazer na ordem certa ai o taborder acerta
        //
        J := 0;
        //
        for I := 23 downto 0 do
        begin
          //
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
          //
        end;
        // ---------- //
        // Configura //
        // -------- //
        if (not Form1.Image207.Visible) or (Form1.Label207.Tag = 1) then
        begin
          Form1.Image207.OnClick          := Form1.Liberarosmdulosparaesteusurio1Click;
          Form1.Label207.OnClick          := Form1.Liberarosmdulosparaesteusurio1Click;
          Form1.Label_bola_config.OnClick := Form1.Image207Click;
          Form1.Label207.Tag              := 1;
          Form1.Image207.Visible          := True;
        end else
        begin
          //
          Form1.Image207.OnClick          := Form1.Image207Click;
          Form1.Label207.OnClick          := Form1.Image207Click;
          Form1.Label_bola_config.OnClick := Form1.Label_Bola_ConfigClick;
          //
        end;
        //
        Form7.Label208.Caption  := 'Liberar';
        //
        if Pos('Ordem de Serviço',Form22.sTitulo) = 0 then
//        if not ((Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Commerce + Ordem de Serviço') or
//               (Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Mei + Ordem de Serviço'))  then
        begin
          Image201_.Visible := False;
        end;
        //
        if (sModeloPAF <> '65') and (sModeloPAF <> '01') and (sModeloPAF <> '59') and (sModeloPAF <> '99')  then
        begin
          if (Form7.ibDataSet13ESTADO.AsString = 'TO') then // or (Form7.ibDataSet13ESTADO.AsString = 'SC') then
          begin
            Image201_.Visible := False; // Sem OS
          end;
        end;
        //
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1','0'))   > 0  then bNotaVendaLiberada   := True  else bNotaVendaLiberada  := False; // Venda
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_E','0')) > 0  then bNotaCompraLiberada  := True else bNotaCompraLiberada  := False; // compra
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B1_S','0')) > 0  then bNotaServicoLiberada := True else bNotaServicoLiberada := False; // compra

        //
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B3','0')) > 0  then bClientesLiberados := True else bClientesLiberados := False; // Clientes
        if StrToInt('0'+Mais1Ini.ReadString(Usuario,'B9','0')) > 0  then bFornecedoresLiberados := True else bFornecedoresLiberados := False; // Fornecedores
        //
        Form7.Exibir1.Visible := True;
        Form7.Mostrartodososclientesefornecedores1.Visible := True;
        Form7.N10.Visible := True;
        //
//        if Image200.Visible  then Label200.Visible  := False  else Label200.Visible   := False;
//        if Image201.Visible  then Label201.Visible  := False  else Label201.Visible   := False;
//        if Image201_.Visible then Label201_.Visible := False  else Label201_.Visible  := False;
//        if Image202.Visible  then Label202.Visible  := False  else Label202.Visible   := False;
//        if Image203.Visible  then Label203.Visible  := False  else Label203.Visible   := False;
//        if Image204.Visible  then Label204.Visible  := False  else Label204.Visible   := False;
//        if Image205.Visible  then Label205.Visible  := False  else Label205.Visible   := False;
//        if Image206.Visible  then Label206.Visible  := False  else Label206.Visible   := False;
//        if Image207.Visible  then Label207.Visible  := False  else Label207.Visible   := False;
//        if Image208.Visible  then Label208.Visible  := False  else Label208.Visible   := False;
//        if Image210.Visible  then Label210.Visible  := False  else Label210.Visible   := False;
        //
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
        //
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
        //
        if not Form1.bNotaVendaLiberada then
        begin
          Form7.Gerarnotafiscalsrie11.Enabled := False;
          Form7.Gerarnotafiscalsrie21.Enabled := False;
        end else
        begin
          Form7.Gerarnotafiscalsrie11.Enabled := True;
          Form7.Gerarnotafiscalsrie21.Enabled := True;
        end;
        //
      end else
      begin
        //
        if Senha = '#####' then
        begin
          // Form1.DestroyWindowHandle;
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        end else
        begin
          //
          { Quando a senha não é válida }
          //
          Audita('SENHA','SMALL', Senhas.UsuarioPub,'SENHA INVÁLIDA: '+Senha,0,0); // Ato, Modulo, Usuário, Histórico, Valor
          //
          Form1.ShowHint := True;
          Form1.Hint := chr(10)+
                         ' '+Usuario+chr(10)+chr(10)+
                         ' Sua senha não é válida, portanto os' + chr(10)+
                         ' módulos não podem ser liberados.'+ chr(10)+
                         ' Entre novamente no programa digitando '+ chr(10)+
                         ' a sua senha correta.'+ chr(10);

          ShowMessage(' '+Usuario+chr(10)+chr(10)+
                      ' Sua senha não é válida, portanto os' + chr(10)+
                      ' módulos não podem ser liberados.'+ chr(10)+
                      ' Entre novamente no programa digitando'+ chr(10)+
                      ' a sua senha correta.'+ chr(10));

  //        // Form1.DestroyWindowHandle;
          Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        end;
      end;
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      Mais1Ini.WriteString(AllTrim(Usuario),'Ativo','Sim');
      Mais1Ini.UpdateFile;
      Mais1Ini.Free;
      //
    except
      ShowMessage('Para solucionar o problema siga os seguintes passos:'+chr(10)
      +chr(10)+'1 - Desative controle de conta do usuario (Windows Vista)'
      +chr(10)+'2 - Execute este programa como administrador. Altere o atalho na aba compatibilidade (Windows 8)'
      +chr(10)+'3 - Arquivo EST0QUE.DAT pode estar danificado (O arquivo deve ser excluido)'
      +chr(10)+'4 - Reinstale o programa');
      // Form1.DestroyWindowHandle;
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    end;
    //
    MontaTela(True);
    //
    Form8.Width          := 310;
    Form8.Top            := Form1.Top + Form1.Height + 1 + (iVista*2);
    Form8.Left           := Screen.Width - 310 - (iVista);
    Form8.Height         := 120;
    //
    // Para atender o PAF
    //
    if ParamCount > 0 then
    begin
      if AllTrim(Copy(UpperCase(ParamStr(1)),1,3)) = 'URB' then
      begin
  //      Form1.Top := 0 - Form1.Height - 5;
        Form1.Image201Click(Form1.Image201);
        Form7.Image101Click(Form7.Image201);
      end;
    end;
    //
    if (Copy(Form7.ibDataSet13CNAE.AsString,1,2) = '56') or // Restaurantes e similares
       (Form7.ibDataSet13CNAE.AsString = '4721101') or      // Padarias
       (Form7.ibDataSet13CNAE.AsString = '4721102') then
    begin
      Form7.ibDataSet4OBS.DisplayLabel := 'Receita';
      Form7.N56.Visible                := True;
      Form7.Cardpio1.Visible           := True;
      Form7.Livrodereceitas1.Visible   := True;
    end else
    begin
      Form7.ibDataSet4OBS.DisplayLabel    := 'Aplicação';
      Form7.N56.Visible                   := False;
      Form7.Cardpio1.Visible              := False;
      Form7.Livrodereceitas1.Visible      := True;
      Form7.Livrodereceitas1.Caption      := 'Relatório de composição...';
    end;
    //
    // LEGAL
    //
    try
      if Form7.ibDataSet39.Active then
      begin
        if FileExists(Form1.sAtual+'\leia-me.txt') then
        begin
          Form1.RegistrodoProgramaonline1Click(Sender);
          ValidaRazaoSmall; // Corrige o nome da small no arquio arquivoauxiliarcriptografadopafecfsmallsoft.ini de LTDA para EIRELI
        end;
      end;
    except end;
    //
    // LEGAL
    //
    //  tInicio := Time;
    //
    try
      if Form7.ibDataSet39.Active then
      begin
        //
        // Verificar se é mei aqui
        //
        // if StrToInt(Copy(TimeToStr(Time),7,2)) > 58 then
        //
        begin
          Form1.RegistrodoProgramaonline1Click(Sender);
        end;
      end;
    except end;
    //
    // NF-e
    //
    if Image201.Visible  then
    begin
      if not form2.Visible then
      begin
        //
        ConfiguraNFE(True);
        //
        if Form1.bConsultarNFesEmitidas then
        begin
          //
          // ShowMessage('Consultando NF-e´s emitidas para o CNPJ: '+Form7.ibDataSet13CGC.AsString);
          //
          Mensagem22('Consultando NF-e´s emitidas para o CNPJ: '+Form7.ibDataSet13CGC.AsString);
          Form7.ConsultarNFesemitidasparameuCNPJ1Click(Form7.MenuItem1);
          AvisoNFECompra(True);
          Sleep(1000*2);
          Mensagem22('');
        end;
      end;
    end;
    //
    // OS
    //
    if Image201_.Visible  then
    begin
      Mensagem22('Consultando OS agendadas para hoje');
      AvisoOS(True);
      Mensagem22('');
    end;
    //
    // CLIFOR
    //
    if Image203.Visible  then
    begin
      Mensagem22('Consultando agendamentos no cadastro');
      AvisoClifor(True);
      Mensagem22('');
    end;
    //
    // CAIXA
    //
    if Image205.Visible  then
    begin
      Mensagem22('Consultando pendências no caixa');
      AvisoCaixa(True);
      Mensagem22('');
    end;
    //
    // BANCO
    //
    if Image206.Visible  then
    begin
      Mensagem22('Consultando pendências no banco');
      AvisoBanco(True);
      Mensagem22('');
    end;
    //
    // Receber
    //
    if Image204.Visible  then
    begin
      Mensagem22('Consultando contas a receber para hoje');
      AvisoReceber(True);
      Mensagem22('');
    end;
    //
    // Estoque
    //
    if Image202.Visible  then
    begin
      Mensagem22('Consultando produtos com quantidade minima no estoque');
      AvisoEstoque(True);
      Mensagem22('');
    end;
    //
    // PAGAR
    //
    if Image210.Visible  then
    begin
      Mensagem22('Consultando contas a pagar para hoje');
      AvisoPagar(True);
      Mensagem22('');
    end;
    //
    // INDICADORES
    //
    if Image200.Visible  then
    begin
      Mensagem22('Consultando indicadores');
      AvisoIndicadores(True);
      Mensagem22('');
    end;
    //
    // CONFIG
    //
    if Image210.Visible  then
    begin
      Mensagem22('Consultando suas configurações');
      AvisoConfig(True);
      Mensagem22('');
    end;
    //
    if Form7.ibDataSet4.Tag = IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO then // Sandro Silva 2022-09-12 if Form7.ibDataSet4.Tag = 999 then
    begin
      //
      Form7.ibDataset4.Close;
      Form7.ibDataset4.SelectSql.Clear;
      Form7.ibDataset4.SelectSql.Add('select * from ESTOQUE');
      Form7.ibDataset4.Open;
      //
      Form7.ibDataSet4.DisableControls;
      //
      while not Form7.ibDataset4.Eof do
      begin
        //
        for I := 1 to 30 do
        begin
          if pos('<',Form7.ibDataset4OBS.AsString) <> 0 then
          begin
            //
            try
              sTag   := Copy(Form7.ibDataset4OBS.AsString,(pos('<',Form7.ibDataset4OBS.AsString)+1), (pos('>',Form7.ibDataset4OBS.AsString)-(pos('<',Form7.ibDataset4OBS.AsString)+1)));
              sValor := Copy(Form7.ibDataset4OBS.AsString,Pos('<' + sTag + '>', Form7.ibDataset4OBS.AsString) + Length('<' + sTag + '>'),(Pos('</', Form7.ibDataset4OBS.AsString)-(Pos('<' + sTag + '>', Form7.ibDataset4OBS.AsString)+Length('<' + sTag + '>'))));
              Form7.ibDataset4.Edit;
              Form7.ibDataset4TAGS_.AsString := Form7.ibDataset4TAGS_.AsString + '<' + sTag + '>' + sValor +  '</' + sTag + '>' + chr(10);
              Form7.ibDataset4OBS.AsString := StrTran(Form7.ibDataset4OBS.AsString,('<' + sTag + '>' + sValor +  '</' + sTag + '>'),'');
              Form7.ibDataset4.Post;
            except end;
            //
          end;
        end;
        //
        // cProdANP
        //
        if (Length(LimpaNumero(Form7.ibDataset4LIVRE1.AsString)) = 9) and (Length(AllTrim(Form7.ibDataset4LIVRE1.AsString)) = 9) then
        begin
          try
            Form7.ibDataset4.Edit;
            Form7.ibDataset4TAGS_.AsString := Form7.ibDataset4TAGS_.AsString + '<cProdANP>' + Form7.ibDataset4LIVRE1.AsString +  '</cProdANP>' + chr(10);
            Form7.ibDataSet4LIVRE1.AsString := '';
            Form7.ibDataset4.Post;
          except end;
        end;
        //
        // vUnid
        //
        if (Copy(Form7.ibDataSet4LIVRE3.AsString,1,7) = '<vUnid=') then // Pereti trib ipi por valor unitário engarafados bebidas
        begin
          try
            Form7.ibDataset4.Edit;
            Form7.ibDataset4TAGS_.AsString  := Form7.ibDataset4TAGS_.AsString + '<vUnid>' + LimpaNumeroDeixandoAvirgula(Form7.ibDataSet4LIVRE3.AsString) +  '</vUnid>' + chr(10);
            Form7.ibDataSet4LIVRE3.AsString := '';
            Form7.ibDataset4.Post;
          except end;
        end;
        //
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
        //
        Form7.ibDataset4.Next;
        //
      end;
      //
      Form7.ibDataSet4.EnableControls;
      //
    end;
    //
    Screen.Cursor := crDefault; // Cursor
    Form22.Close;
    //
    //
    // ------- //
    // The end //
    // ------- //
  except

  end;
  //
  if Form1.Tag = 99 then
  begin
    Form7.EnvioaoFISCOREDUOZ1Click(Sender);
    Form1.Tag := 0;
  end;
  //
end;

procedure TForm1.Edit200DblClick(Sender: TObject);
begin
  //
//  ShowMEssage(ibDataSet200.ModifySql.Text);
  //
end;

procedure TForm1.DBGrid200KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_sql.htm')));
  //
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
  //
  if Key = VK_ESCAPE then
  begin
    //
    ibDataSet200.Close;
    dbGrid200.Visible := False;
    Edit200.Visible   := False;
    //
    Commitatudo(True); // SQL - Commando
    AbreArquivos(False);
    //
    MontaTela(True);
    //
  end;
  //
  Screen.Cursor := crDefault;
  //
end;

procedure TForm1.SelecionarCertificadoDigital1Click(Sender: TObject);
var
  //
  Mais1ini: TIniFile;
  sCertificado: String;
  //
begin
  //
  {Sandro Silva 2022-12-15 inicio
  Form7.spdNFe.ConfigurarSoftwareHouse('07426598000124','9830b685216a9c4613bc76c84098272d');
  }
  Form1.ConfiguraCredencialTecnospeed;
  {Sandro Silva 2022-12-15 fim}
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
  Mais1ini.Free;
  //
  Form17.Hide;
  Form7.spdNFe.ListarCertificados(frmSelectCertificate.lbList.Items);
  frmSelectCertificate.ShowModal;
  Form17.Hide;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
  Mais1ini.Free;
  //
  if AllTrim(sCertificado) = '' then
  begin
    //
    if Application.MessageBox(Pchar('Para emitir Documentos Fiscais é necessário instalar um'+#13+
                                    'Certificado Digital.'+#13+#13+
                                    'Continuar sem instalar o Certificado Digital não é'+#13+
                                    'recomendavel.'+#13+#13+
                                    'Se não estiver instalado recomendamos sair do programa'+#13+
                                    'e instalar antes de cadastrar o emitente.')
    ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING) = IDYES then
    begin
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    end;
  end;
  //
end;

procedure TForm1.estarservidorNFE1Click(Sender: TObject);
begin
  Form7.N0TestarservidorNFe1Click(Sender);
end;

procedure TForm1.ConfigurarlogotipodoDANFE1Click(Sender: TObject);
begin
  //
  Form12.Image2Click(Sender);
  //
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
  //
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
    if Alltrim(Mais1Ini.ReadString('NFE','Certificado',''))                 = '' then Mais1Ini.WriteString('NFE','Certificado','');
    if Alltrim(Mais1Ini.ReadString('NFE','Ambiente',''))                    = '' then Mais1Ini.WriteString('NFE','Ambiente','Homologacao');
    if Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','XXXXX'))     = 'XXXXX' then Mais1Ini.WriteString('DANFE','Formato do DANFE','Retrato');
    if Alltrim(Mais1Ini.ReadString('XML','Pasta da contabilidade','XXXXX')) = 'XXXXX' then Mais1Ini.WriteString('XML','Pasta da contabilidade','');
    //
    // if Alltrim(Mais1Ini.ReadString('NFE','Limite','100'))          = '100' then Mais1Ini.WriteString('NFE','Limite','100');
    //
    Mais1ini.Free;
    //
    ShellExecute( 0, 'Open',Pchar(sAtual+'\nfe.ini'),'', '', SW_SHOW);
  end else ShowMessage('Senha do administrador inválida.');
  //
end;

procedure TForm1.InutilizarNFe1Click(Sender: TObject);
var
  sID, sRetorno, aAno, aModelo, aSerie, aIni, aFim, txtJustificativa: string;
begin
  //
  ConfiguraNFE(True);
  //
  aAno := Small_InputForm('NFe', 'Insira o ano da NF-e a ser inutilizada', '');
  //
  if aAno <> '' then
  begin
    //
    aModelo := Small_InputForm('NFe', 'Insira o modelo da NF-e a ser inutilizada', '');
    if aModelo <> '' then
    begin
      //
      aSerie := Small_InputForm('NFe', 'Insira a série da NF-e a ser inutilizada', '');
      if aSerie <> '' then
      begin
        //
        aIni := Small_InputForm('NFe', 'Insira o número da NF-e inicial a ser inutilizada', '');
        if aIni <> '' then
        begin
          //
          aFim := Small_InputForm('NFe', 'Insira o número da NF-e final a ser inutilizada', '');
          if aFim <> '' then
          begin
            //
            // sID  := Small_InputForm('NFe', 'Confirme o ID',LimpaNumero(Form7.ibDataSet15NFEID.AsString));
            //
            Form7.ibDataset99.Close;
            Form7.ibDataset99.SelectSql.Clear;
            Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where NOME='+QuotedStr(Form7.ibDataSet13MUNICIPIO.AsString)+' '+' and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+' ');
            Form7.ibDataset99.Open;
            //
            sID := Copy(Form7.ibDAtaSet99.FieldByname('CODIGO').AsString,1,2) + LimpaNumero(Form7.ibDAtaSet13CGC.AsString) + aModelo + StrZero(StrToInt(aSerie),3,0) + StrZero(StrToInt(aIni),9,0) + StrZero(StrToInt(aFim),9,0);
            //
            txtJustificativa := ConverteAcentos(Small_InputForm('NF-e', 'Insira a justificativa (min. 15 caracteres)', 'Exemplo de inutilizacao da NF-e'));
            //
            try
              Screen.Cursor := crHourGlass; // Cursor de Aguardo
              //
              Form7.ibDataset15.Locate('NFEID','55',[loPartialKey]);
              //
              sRetorno := Form7.spdNFe.InutilizarNF('',aAno, LimpaNumero(Form7.ibDataSet13CGC.AsString), aModelo, aSerie, aIni, aFim, txtJustificativa);
              Screen.Cursor := crDefault;
              //
              if GravarInutilizacao(sRetorno, Form1.ibQuery2) then
              begin
                //
                sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
                ShowMessage(sRetorno);
                //
              end else
              begin
                sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
                ShowMessage('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno);
              end;
              //
            except
              sRetorno := Copy(sRetorno+'   ',Pos('<xMotivo>',sRetorno)+9,Pos('</xMotivo>',sRetorno)-Pos('<xMotivo>',sRetorno)-9);
              ShowMessage('Não foi possível inutilizar as Notas Fiscais Eletrônicas: '+sRetorno);
            end;
            //
            //
            DecimalSeparator := ',';
            DateSeparator    := '/';
          end;
        end;
      end;
    end;
  end;
  //
  Screen.Cursor            := crDefault;
  //
end;

procedure TForm1.estarDisponibilidadedeServiosdasSecretariasdeFazenda1Click(
  Sender: TObject);
var
  Mais1ini: TIniFile;
  //
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  if (Mais1Ini.ReadString('NFE','Ambiente','Homologacao') <> 'Producao') then
  begin
    ShellExecute( 0, 'Open', 'http://hom.nfe.fazenda.gov.br/PORTAL/disponibilidade.aspx?versao=0.00&tipoConteudo=Skeuqr8PQBY=','', '', SW_SHOW);
  end else
  begin
    ShellExecute( 0, 'Open', 'http://www.nfe.fazenda.gov.br/portal/disponibilidade.aspx','', '', SW_SHOW);
  end;
  //
  Mais1ini.Free;
  //
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
  //
  Timer2.Enabled := False;
  //
//  if Legal(True) then
  begin
    //
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
      //
      if not AutoSmallMobile1.Checked then
      begin
        try
          //
          AutoSmallMobile1.Checked := True;
          Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
          Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Sim');
          Form1.Timer2.Enabled := True;
          Mais1Ini.Free;
          //
        except end;
      end;
      //
      bButton := Application.MessageBox(Pchar(
      'É necessário atualizar as fotos dos produtos?')
      ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
      //
      Form1.Label200.Tag    := 1;
      Form1.Repaint;
      Screen.Cursor := crAppStart; // Cursor de Aguardo
      //
      //
      if bButton = IDYES then
      begin
        Form10.AtualizaMobile(True);
      end else
      begin
        Form10.AtualizaMobile(False);
      end;
      //
      Form1.Label200.Tag    := 0;
      Screen.Cursor := crDefault; // Cursor de Aguardo
      //
    end;
    //
  end;
  //
  Timer2.Enabled := True;
  //
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
  //
  // Pega o Diretório Atual
  //
  sTLista := TStringList.Create();
  sTLista.Clear;
  sTSessions := TStringList.Create();
  sTSessions.Clear;
  //
  try
    //
    GetDir(0,sDirAtual);
    //
    // Cria a String List e limpa
    //
    //
    try
      //
      // Cnpj do Emitente somente os números
      //
      sCnpj:= LimpaNumero(Form7.ibDataSet13.fieldByName('CGC').AsString);
      //
      // Conecta ao FTP
      //
      Form7.LbBlowfish1.GenerateKey(sPasta);
      //
      DownloadMobile(sCNPJ, '*.ped', sTLista);
      //
      // Repassa todos os arquivos .PED
      //
      for I := 0 to sTLista.Count -1 do
      begin
        //
        Screen.Cursor             := crAppStart;                   // Cursor de Aguardo
        Application.ProcessMessages;
        //
        // Ao Concluir o download abre o arquivo e le como se fosse um ini
        //
        ArqIni := TIniFile.Create(sTLista[I]); //abre
        ArqIni.ReadSections(sTSessions); //conta o número de itens
        //
        // Generator PEDIDO
        //
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSql.Clear;
        Form1.ibDataset200.SelectSql.Add('select gen_id(G_ORCAMENTO,1) from rdb$database');
        Form1.ibDataset200.Open;
        //
        iPedido := StrtoInt('0'+Form1.IBDataSet200.fieldByname('GEN_ID').AsString);
        //
        // le os itens do ORCAMENTO
        //
        for J := 0 to sTSessions.Count-1 do
        begin
          //
          // Generator REGISTRO
          //
          Form1.ibDataSet200.Close;
          Form1.ibDataSet200.SelectSql.Clear;
          Form1.ibDataset200.SelectSql.Add('select gen_id(G_ORCAMENT,1) from rdb$database');
          Form1.ibDataset200.Open;
          //
          iRegistro := StrtoInt('0'+Form1.IBDataSet200.fieldByname('GEN_ID').AsString);
          //
          // Salva o orçamento
          //

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
          //
          IBQuery1.Prepare;
          IBQuery1.ParamByName('CODIGO').AsString     := ArqIni.ReadString(sTSessions[J],'CODIGO','');
          //
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
          //
          IBQuery1.ParamByName('DATA').AsString       := ArqIni.ReadString(sTSessions[0],'DATA','');
          IBQuery1.ParamByName('TIPO').AsString       := 'ORCAME';
          IBQuery1.ParamByName('PEDIDO').AsString     := StrZero(iPedido,10,0);
          IBQuery1.ParamByName('ITEM').AsString       := StrZero(ArqIni.ReadInteger(sTSessions[0],'ITEM',0),3,0);
          IBQuery1.ParamByName('CLIFOR').AsString     := Form7.IBQuery2.FieldByname('NOME').AsString;
          IBQuery1.ParamByName('VENDEDOR').AsString   := ArqIni.ReadString(sTSessions[0],'VENDEDOR','');
          IBQuery1.ParamByName('REGISTRO').AsString   := StrZero(iRegistro,10,0);
          ibQuery1.ExecSQL;
          //
        end; // J
        //
        ArqIni.Free; ///Limpa variavel do INI
        //
        // Terminado apaga o arquivo local e no FTP
        //
        DeleteFile(pChar(sTLista[I]));
        //
      end; // I
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
//    sTLista.Free;
//    sTSessions.Free;
    //
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
      //
      Application.ProcessMessages;
      //
      // Download do Arquivo
      //

      //
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
        //
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
      if (not Form10.visible) and (not Form12.visible) and (not Form24.visible) and (not Form30.visible) then
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
  //
end;

procedure TForm1.Formatododanfe1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  if Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','XXXXX')) <> 'Retrato' then
  begin
    Mais1Ini.WriteString('DANFE','Formato do DANFE','Retrato');
    ShowMessage('Formato do DANFE definido como: Retrato');
  end else
  begin
    Mais1Ini.WriteString('DANFE','Formato do DANFE','Paisagem');
    ShowMessage('Formato do DANFE definido como: Paisagem');
  end;
  //
  Mais1ini.Free;
  //
end;

procedure TForm1.Ambiente1Click(Sender: TObject);
var
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  Mais1Ini : tIniFile;
begin
  //
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
    if Alltrim(Mais1Ini.ReadString('NFE','Ambiente','')) = 'Producao' then
    begin
      //
      I := Application.MessageBox(Pchar('Tem certeza que quer mudar para o ambiente de HOMOLOGAÇÃO?'
                              + chr(10)
                              +' Se estiver em dúvida clique no botão <Não>'
                              + Chr(10))
                              ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
      if I = IDYES then
      begin
        Mais1Ini.WriteString('NFE','Ambiente','Homologacao');
        ShowMessage('Definido ambiente: Homologação');
      end;
      //
    end else
    begin
      //
      I := Application.MessageBox(Pchar('Tem certeza que quer mudar para o ambiente de PRODUÇÃO?'
                              + chr(10)
                              +' Se estiver em dúvida clique no botão <Não>'
                              + Chr(10))
                              ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
      if I = IDYES then
      begin
        Mais1Ini.WriteString('NFE','Ambiente','Producao');
        ShowMessage('Definido ambiente: Produção');
      end;
      //
    end;
  end else ShowMessage('Senha do administrador inválida.');
  //
  Mais1ini.Free;
  //
end;

procedure TForm1.ConfiguraodoDANFEparaNFe1Click(Sender: TObject);
var
  I : Integer;
  sLote : String;
begin
  //
  Screen.Cursor            := crHourGlass;
  ConfiguraNFE(True);
  //
  try
    //
    sLote      := '00001';
    //
    Form7.ibDataSet15.Close;
    Form7.ibDataSet15.SelectSql.Clear;
    Form7.ibDataset15.SelectSql.Add('select * from VENDAS where EMITIDA=''S'' and EMISSAO=CURRENT_DATE order by NUMERONF');
    Form7.ibDataset15.Open;
    //
    Form7.ibDataset15.Last;
    //
    for I := 1 to 100 do if (Alltrim(Form7.ibDataSet15NFEPROTOCOLO.AsString) ='') then Form7.ibDataSet15.MoveBy(-1);
    //
    if (Alltrim(Form7.ibDataSet15NFEPROTOCOLO.AsString) <> '') then
    begin
      //
      // ShowMEssage(Form7.ibDataset15NUMERONF.AsString);
      //
      Form7.fNFE :=  Form7.ibDataSet15NFEXML.AsString;
      //
      if Form1.sVersaoLayout = '4.00' then
      begin
        Form7.spdNFe.EditarModeloDanfe(sLote, Form7.fNFe,Form1.sAtual + '\nfe\Templates\vm60\danfe\'+Form7.sFormatoDoDanfe+'.rtm');
      end else
      begin
        Form7.spdNFe.EditarModeloDanfe(sLote, Form7.fNFe,Form1.sAtual + '\nfe\Templates\vm50a\danfe\'+Form7.sFormatoDoDanfe+'.rtm');
      end;
      //
    end;
    //
  except
    ShowMessage('Falha ao configurar o DANFE. Para configurar o DANFE é necessário ter uma NF-e transmitida.');
  end;
  //
  Screen.Cursor            := crDefault;
  //
end;

procedure TForm1.ConfiguraodaNFe2Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  //
  Formatododanfe1.Checked := True;
  Ambiente1.Checked       := True;
  //
  if bModoScan then SCANSistemadeContingnciadoAmbienteNacional1.Checked := True else SCANSistemadeContingnciadoAmbienteNacional1.Checked := False;
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  Formatododanfe1.Caption := 'Formato do DANFE: '+Alltrim(Mais1Ini.ReadString('DANFE','Formato do DANFE','Retrato'));
  Ambiente1.Caption       := 'Ambiente: '+Alltrim(Mais1Ini.ReadString('NFE','Ambiente','Homologacao'));
  //
  if Alltrim(Mais1Ini.ReadString('DANFE','Configurar',''))      = '' then Mais1Ini.WriteString('DANFE','Configurar','Não');
  if Alltrim(Mais1Ini.ReadString('DANFE','Configurar',''))      = 'Sim' then ConfiguraodoDANFEparaNFe1.Visible := True else ConfiguraodoDANFEparaNFe1.Visible := False;
  if Mais1Ini.ReadString('ENVIO','Zipar XML','N')               = 'S'   then Form1.ZiparXMLnoenvioporemail1.Checked := True else Form1.ZiparXMLnoenvioporemail1.Checked := False;
  if Mais1Ini.ReadString('ENVIO','Enviar danfe por e-mail','N') = 'S'   then Form1.Enviardanfeporemail1.Checked := True else Form1.Enviardanfeporemail1.Checked := False;
  if Mais1Ini.ReadString('NFE','Consultar Nfes Emitidas','Sim') = 'Sim' then Form1.ConsultarNFesemitidas1.Checked := True else Form1.ConsultarNFesemitidas1.Checked := False;

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
  //
  Mais1ini.Free;
  //
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
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
  //
  if Key = VK_ESCAPE then
  begin
    //
    dbGrid1.Visible := False;
    Edit1.Visible   := False;
    //
    MontaTela(True);
    //
  end;
  //
  Screen.Cursor := crDefault;
  //
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if KEY = VK_RETURN then
  begin
    ExecutaSql2(True);
  end;
  //
  Screen.Cursor := crDefault;
  //
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
        WriteLn(F,'  <th nowrap><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].DisplayName+'</font></th>');
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
          if dbGrid1.Fields[I].DataType = ftFloat then
          begin
            WriteLn(F,'  <td nowrap align=right><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].asString+'</font></td>');
            vTotal[I] := vTotal[I] + dbGrid1.Fields[I].AsFloat;
          end else
          begin
            if dbGrid1.Fields[I].DisplayName =  'FOTO' then
            begin
              WriteLn(F,'  <td nowrap><font face="Microsoft Sans Serif" size=1>FOTO</font></td>');
            end else
            begin
              WriteLn(F,'  <td nowrap><font face="Microsoft Sans Serif" size=1>'+dbGrid1.Fields[I].asString+'</font></td>');
            end;
          end;
        end;
        WriteLn(F,' </tr>');
      end else
      begin
        for I := 0 to dbGrid1.FieldCount -1 do
        begin
          if dbGrid1.Fields[I].DataType = ftFloat then
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
        if dbGrid1.Fields[I].DataType = ftFloat then
        begin
          WriteLn(F,'  <td nowrap align=right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[vTotal[I]])+'</font></td>');
        end else
        begin
          WriteLn(F,'  <td nowrap></td>');
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
        if dbGrid1.Fields[I].DataType = ftFloat then
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
        if dbGrid1.Fields[I].DataType = ftFloat then
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
  //
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0],nil);
  GetWindowRect(wndHandle,Retangulo);
  //
  try
    //
    Form1.Height      := Screen.Height - (Retangulo.Bottom - Retangulo.Top);
    dbGrid1.Visible := False;
    Edit1.Visible   := False;
    //
    ibDataSet1.Close;
    ibDataSet1.SelectSQL.Clear;
    //
    Edit1.Align   := AlTop;
    dbGrid1.Align := AlClient;
    //
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
    //
  except end;
  //
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //
  if Label208.Font.Style <> [fsBold] then
  begin
    if Copy(Form1.Image208.Hint,1,23) = 'Banco de dados em risco' then
    begin
      if Form1.Image_Perigo_2.Tag = 0 then
      begin
        Form1.Image208.Picture    := Form1.Image_Perigo_1.Picture;
        Form1.Image_Perigo_2.Tag  := 1;
        Form1.Label208.Font.Color := $00F0F0F0;
      end else
      begin
        Form1.Image208.Picture    := Form1.Image_Perigo_2.Picture;
        Form1.Label208.Font.Color := clBlack;
        Form1.Image_Perigo_2.Tag  := 0;
      end;
      //
      Form1.Image208.Repaint;
      //
    end;
  end;
  //
end;

procedure TForm1.ZiparXMLnoenvioporemail1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  if Mais1Ini.ReadString('ENVIO','Zipar XML','N') = 'S'
    then Mais1Ini.WriteString('ENVIO','Zipar XML','N')
      else Mais1Ini.WriteString('ENVIO','Zipar XML','S');
  //
  Mais1Ini.Free;
  //
end;

procedure TForm1.Enviardanfeporemail1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  if Mais1Ini.ReadString('ENVIO','Enviar danfe por e-mail','N') = 'S'
    then Mais1Ini.WriteString('ENVIO','Enviar danfe por e-mail','N')
      else Mais1Ini.WriteString('ENVIO','Enviar danfe por e-mail','S');
  //
  Mais1Ini.Free;
  //
end;

procedure TForm1.Comandos1Click(Sender: TObject);
begin
  //
  if (Form7.ibDataSet13ESTADO.AsString = 'XZ') then
  begin
    SQLMododecomando1.Visible := False;
  end else
  begin
    SQLMododecomando1.Visible := True;
  end;
  //
end;

procedure TForm1.AtualizartabelaIBPT1Click(Sender: TObject);
var
  F : TExtFile;
  I, J : Integer;
  sLinha : String;
  //
//  Hora, Min, Seg, cent : Word;
//  tInicio : tTime;
  //
begin
  //
  if (AllTrim(Form7.ibDataSet13ESTADO.AsString) <> '') and (Form1.iReduzida<>2) then
  begin
    //
    //  tInicio := Time;
    //
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
                on E: Exception do ShowMEssage('Erro (' + E.Message + ') ao atualizar a tabela do IBPT. '+chr(10)+chr(10)+Form1.ibQuery1.SQL.Text);
              end;
              //
           end;
         except end;
         //
         try
           I := I + 1;
           Form29.Gauge1.Progress := 100 * I div 9000;// 11641;
           Form29.Gauge1.Repaint;
         except end;
         //
      end;
      //
      // ShowMessage(IntToStr(Y));
      //
      CloseFile(f);
      //
      //
      if FileExists(pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp')) then DeleteFile(pChar(Form1.sAtual+'\ibpt_'+Form7.ibDataSet13ESTADO.AsString+'.imp'));
      //
      Form29.Panel1.Visible  := True;
      Aviso2('Atualizando indice IBPT (Instituto Brasileiro de'+chr(10)+
             'Planejamento Tributário) na tabela de produtos');
      //
  {
  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10));
  }

      //
      Form7.ibQuery99.Close;
      Form7.ibQuery99.SQL.Clear;
      Form7.ibQuery99.SQL.Add('select count(distinct CF) from estoque');
      Form7.ibQuery99.Open;
      //
      J := StrToInt(Form7.IBQuery99.FieldByname('COUNT').AsString);
      I := 0;
      //
      //
      Form7.ibQuery99.Close;
      Form7.ibQuery99.SQL.Clear;
      Form7.ibQuery99.SQL.Add('select CF from estoque group by CF');
      Form7.ibQuery99.Open;
      //
      while not Form7.ibQuery99.Eof do
      begin
        //
        try
          I := I + 1;
          Form29.Gauge1.Progress := 100 * I div J;
          Form29.Gauge1.Repaint;
        except end;
        //
        try
          //
          if AllTrim(Form7.ibQuery99.FieldByname('CF').AsString) <> '' then
          begin
            //
            try
              //
              Form7.ibQuery1.Close;
              Form7.ibQuery1.SQL.Clear;
              //
              // Form7.ibQuery1.SQL.Add('select ESTADUAL, MUNICIPAL, IMPORTADOFEDERAL, NACIONALFEDERAL from IBPT_ where '+QuotedStr(Form7.ibQuery99.FieldByname('CF').AsString)+' like CODIGO||''%''');
              //
              Form7.ibQuery1.SQL.Add('select ESTADUAL, MUNICIPAL, IMPORTADOFEDERAL, NACIONALFEDERAL from IBPT_ where (char_length(CODIGO) >= 8) and '+QuotedStr(Form7.ibQuery99.FieldByname('CF').AsString)+'=CODIGO');
              Form7.ibQuery1.Open;
              //
//              if Form7.ibQuery99.FieldByname('CF').AsString = Form7.ibQuery1.FieldByname('CODIGO').AsString then
              begin
                if AllTrim(Form7.ibQuery1.FieldByname('ESTADUAL').AsString) <> '' then
                begin
                  try
                    //
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
                    //
                  except
                    ShowMessage(Form7.ibQuery2.SQL.Text);
                  end;
                end;
              end;
              //
            except end;
            //
            Form7.ibQuery1.Close;
            //
          end;
        except end;
        //
        Form7.ibQuery99.Next;
        //
      end;
      //
      // DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
      // ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10));
      //
      try
        Commitatudo(True); // SQL - Commando
        AbreArquivos(False);
      except end;
      //
    end;
    //
    Form29.Close;
    //
    Screen.Cursor        := crDefault;
    //
  end;
  //
end;

procedure TForm1.Estatisticas1Click(Sender: TObject);
var
  F: TextFile;
begin
  //
  // ESTATISTICAS
  //
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
  //
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  sTLista : TStringList;
  I, III : Integer;
  ArqIni : tIniFile;
  sRelatorio, sUsuario, sNome : String;
  F : TextFile;
//  tInicio : tTime;
  //
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
                Form10.AtualizaMobile(False);
              except end;

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
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('EMISSAO').AsString+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('CLIENTE').AsString+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form1.ibQuery1.FieldByname('TOTAL').AsFloat])+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('NUMERONF').AsString+'<br></font></td>');
                      WriteLn(F,'   </tr>');
                      
                      fTotal  := fTotal + Form1.ibQuery1.FieldByname('TOTAL').AsFloat;

                      Form1.ibQuery1.Next;
                    end;

                    WriteLn(F,'   <tr>');
                    
                    if fTotal = 0 then
                    begin
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br>O vendedor: '+sUsuario+' não possui nenhuma NF-e registrada no banco de dados</font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    end else
                    begin
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotal])+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
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
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('DATA').AsString+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('CLIENTE').AsString+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[Form1.ibQuery1.FieldByname('VTOT').AsFloat])+'<br></font></td>');
                      WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1>'+Form1.ibQuery1.FieldByname('NUMERONF').AsString+'<br></font></td>');
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
                    WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
                    WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=right><font face="Microsoft Sans Serif" size=1>'+Format('%7.'+Form1.ConfCasas+'n',[fTotal])+'<br></font></td>');
                    WriteLn(F,'    <td nowrap valign=top bgcolor=#FFFFFF align=left><font face="Microsoft Sans Serif" size=1><br></font></td>');
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
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
end;


procedure TForm1.ConfiguraodaNFemformulrionumerado1Click(Sender: TObject);
begin
  //
  Form7.sTitulo         := 'Configuração da NF';
  Form7.sRPS := 'N';
  Form7.Close;
  Form7.sModulo         := 'NOTA';
  Form7.Show;
  //
end;

procedure TForm1.N3101Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Form1.N301.Checked  := False;
  Form1.N3101.Checked := True;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Layout','3.10');
  Form1.sVersaoLayout := '3.10';
  Mais1ini.Free;
  //
  ConfiguraNFE(True);
  //
end;

procedure TForm1.SVCSefazVirtualdeContingncia1Click(Sender: TObject);
begin
  if bModoSVC then bModoSVC := False else bModoSVC := True;
  if bModoSVC then SVCSefazVirtualdeContingncia1.Checked := True else SVCSefazVirtualdeContingncia1.Checked := False;
end;

procedure TForm1.Image205MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{
  Form1.Label2.Caption := 'LIVRO CAIXA';
  Form1.Label3.Caption := 'Controle de Livro Caixa com Plano de Contas, Fluxo de Caixa, Balancete Gerencial Mensal e Anual.';
}
  //
  if FileExists(Form1.sAtual+'\inicial\fundo\_small_4.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_4.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp');
  //
end;


procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
{
  Form1.Label2.Caption := 'SMALL COMMERCE';
  Form1.Label3.Caption := 'Suíte de Aplicativos Integrados. Completo para  Pequenas Empresas de Comércio.';
}
  //
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  //
  if AllTrim(Form7.sModulo) <> '' then
  begin
    if ((Form7.sModulo = 'VENDA') or (Form7.sModulo = 'DESCONTO') or (Form7.sModulo = 'DESCONTO1')) or ((Form7.sModulo = 'COMPRA') or (Form7.sModulo = 'FRETE')) then
    begin
      //
      if ((Form7.sModulo = 'VENDA') or (Form7.sModulo = 'DESCONTO') or (Form7.sModulo = 'DESCONTO1')) then
      begin
        if (Form12.Visible) then
          Form12.BringToFront
        else
          Form7.BringToFront;
      end;
      //
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
        if Form10.Visible then
        begin
          Form10.BringToFront;
        end else
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
    //
  end;
  //
end;

procedure TForm1.Label202MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone ESTOQUE
  //
  if Label202.Font.Style <> [fsBold] then
  begin
    Image202.Picture    := Image202_X.Picture;
    Label202.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_8.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_8.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_8.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_8.bmp');
      Titulo('CONTROLE O '+chr(10)+
             'ESTOQUE'
             ,
             'O controle de estoque bem'+chr(10)+
             'organizado evita prejuízos'+chr(10)+
             'e garante uma maior'+chr(10)+
             'margem de lucro'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.Label201_MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone OS
  //
  if Label201_.Font.Style <> [fsBold] then
  begin
    Image201_.Picture    := Image201__X.Picture;
    Label201_.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_9.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_9.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_9.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_9.bmp');
      Titulo(
            'UTILIZE A ORDEM '+chr(10)+
            'DE SERVIÇOS'
            ,
            'A Ordem de Serviços facilita'+chr(10)+
            'o atendimento ao cliente'+chr(10)+
            'e organiza e mantém todo'+chr(10)+
            'o trabalho documentado'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.Label203MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone CADASTRO
  //
  if Label203.Font.Style <> [fsBold] then
  begin
    Image203.Picture    := Image203_X.Picture;
    Label203.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_1.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_1.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_1.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_1.bmp');
      Titulo('MANTENHA O CADASTRO'+chr(10)+'ATUALIZADO',
             'O cadastro com as informações'+chr(10)+
             'corretamente registradas'+chr(10)+
             'conserva seus canais de'+chr(10)+
             'comunicação com clientes,'+chr(10)+
             'fornecedores, funcionários,'+chr(10)+
             'entre outros'
             );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
  //
end;

procedure TForm1.Label204MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move RECEBER
  //
  if Label204.Font.Style <> [fsBold] then
  begin
    Image204.Picture    := Image204_X.Picture;
    Label204.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_2.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_2.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_2.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_2.bmp');
      Titulo(
             'MONITORE AS CONTAS'+chr(10)+
             'A RECEBER'
             ,
             'As contas a receber bem controladas'+chr(10)+
             'diminuem o impacto que a inadimplência'+chr(10)+
             'pode ter em seu negócio'
             );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
  //
end;

procedure TForm1.Label205MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move CAIXA
  //
  if Label205.Font.Style <> [fsBold] then
  begin
    Image205.Picture    := Image205_X.Picture;
    Label205.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_4.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_4.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_4.bmp');
      Titulo(
            'CONTROLE O '+chr(10)+
            'CAIXA'
            ,
            'O fechamento exato do caixa permite'+chr(10)+
            'total controle financeiro'+chr(10)+
            'auxiliando na tomadas de'+chr(10)+
            'decisões através da'+chr(10)+
            'análise das contas'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.Label206MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move BANCOS
  //
  if Label206.Font.Style <> [fsBold] then
  begin
    Image206.Picture    := Image206_X.Picture;
    Label206.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_5.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_5.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_5.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_5.bmp');
      Titulo(
            'FIQUE DE OLHO NOS '+chr(10)+
            'BANCOS'
            ,
            'O controle rigoroso das contas'+chr(10)+
            'bancárias previne o pagamento'+chr(10)+
            'de juros e permite um'+chr(10)+
            'planejamento dos'+chr(10)+
            'investimentos'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.Label207MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move CONFIG
  //
  if Label207.Font.Style <> [fsBold] then
  begin
    Image207.Picture    := Image207_X.Picture;
    Label207.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_6.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_6.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_6.bmp');
      Titulo(
            'CONFIGURE'+chr(10)+
            'O SISTEMA'
            ,
            'A configuração correta, ajusta'+chr(10)+
            'o sistema de acordo com as'+chr(10)+
            'particularidades da'+chr(10)+
            'sua empresa'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
  //
end;

procedure TForm1.Label208MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move BACKUP
  //
  if Label208.Font.Style <> [fsBold] then
  begin
    Image208.Picture    := Image208_X.Picture;
    Label208.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_7.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_7.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_7.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_7.bmp');
      Titulo(
            'FAÇA BACKUP'+chr(10)+
            'TODOS OS'+chr(10)+
            'DIAS'
            ,
            'O Backup é a única forma de'+chr(10)+
            'manter seus dados'+chr(10)+
            'seguros'+chr(10)+chr(10)+
            Form1.Image208.Hint
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

    end;
  end;
end;

procedure TForm1.Label210MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move PAGAR
  //
  if Label210.Font.Style <> [fsBold] then
  begin
    Image210.Picture    := Image210_X.Picture;
    Label210.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_3.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_3.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_3.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_3.bmp');
      Titulo(
            'ORGANIZE AS CONTAS'+chr(10)+
            'A PAGAR'
            ,
            'As contas a pagar bem organizadas geram'+chr(10)+
            'uma previsão dos compromissos'+chr(10)+
            'financeiros facilitando o'+chr(10)+
            'controle do fluxo'+chr(10)+
            'de caixa'
            );
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;

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
  //
  sMensagem := 'Fuso normal em '+Form7.ibDataSet13ESTADO.AsString+': -03:00';
  //
  if Form7.ibDataSet13ESTADO.AsString = 'SC' then
  begin
   sMensagem := 'Fuso normal em SC: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'RS' then
  begin
   sMensagem := 'Fuso normal em RS: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'PR' then
  begin
   sMensagem := 'Fuso normal em PR: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'SP' then
  begin
   sMensagem := 'Fuso normal em SP: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'RJ' then
  begin
   sMensagem := 'Fuso normal em RJ: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'MG' then
  begin
   sMensagem := 'Fuso normal em MG: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'ES' then
  begin
   sMensagem := 'Fuso normal em ES: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'GO' then
  begin
   sMensagem := 'Fuso normal em GO: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'MT' then
  begin
   sMensagem := 'Fuso normal em MT: -04:00'+chr(10)+'Fuso horário de verão: -03:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'MS' then
  begin
   sMensagem := 'Fuso normal em MS: -04:00'+chr(10)+'Fuso horário de verão: -03:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'DF' then
  begin
   sMensagem := 'Fuso normal em DF: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  if Form7.ibDataSet13ESTADO.AsString = 'TO' then
  begin
   sMensagem := 'Fuso normal em TO: -03:00'+chr(10)+'Fuso horário de verão: -02:00';
  end;
  //
  Form7.sFuso := Small_InputForm('Fuso horário',sMensagem+Chr(10)+Chr(10)+Chr(10)+'Informe o fuso horário:',Form7.sFuso);
  //
  if (Form7.sFuso = '-03:00') or (Form7.sFuso = '-02:00') or (Form7.sFuso = '-04:00') then
  begin
    //
    // Grava
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    Mais1Ini.WriteString('NFE','FUSO',Form7.sFuso);
    Mais1Ini.Free;
    //
    ShowMessage('Novo fuso horário gravado: '+Form7.sFuso);
    //
  end else
  begin
    //
    ShowMessage('Fuso horário inválido: '+chr(10)+chr(10)+chr(10)+sMensagem);
    //
  end;
  //
end;

procedure TForm1.Label200MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone MOBILE
  //
  if Label200.Font.Style <> [fsBold] then
  begin
    Image200.Picture    := Image200_X.Picture;
    Label200.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_0.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_0.bmp') ;
      Titulo(
            'ACOMPANHE OS'+chr(10)+
            'INDICADORES'
            ,
            'Configure um painel de indicadores'+chr(10)+
            'personalizado por usuário de'+chr(10)+
            'acordo com as necessidades'+chr(10)+
            'gerenciais da sua empresa'+chr(10)
            );
      Form1.BringToFront;
      //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;
      //
    end;
  end;
  //
//  if Form5.Visible then Form5.BringToFront;
  //
end;

procedure TForm1.AutoSmallMobile1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  //
  if AutoSmallMobile1.Checked then
  begin
    Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Não');
    AutoSmallMobile1.Checked := False;
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // AutoSmallMobile1Click
  end else
  begin
    //
    AutoSmallMobile1.Checked := True;
    Mais1Ini.WriteString('GERAL','MOBILE ATIVO','Sim');
    Form1.Timer2.Enabled := True;
    //
    if Legal(True) then
    begin
      if not ConsultaProcesso('mobile.exe') then // Form1Ativate
      begin
        ShellExecute( 0, 'Open', 'mobile.exe', pChar(Form7.ibDataSet13CGC.AsString) , '', SW_SHOW); // AutoSmallMobile1Click
      end;
    end;
    //
  end;
  //
  Mais1ini.Free;
  //
end;

procedure TForm1.Image200Click(Sender: TObject);
begin
  //
  Form7.sModulo := 'INDICADORES';
  Form1.Label201MouseLeave(Sender);
  //
  try
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    FechaTudo(bFechaTudo);
    try
      if form7.Visible then Form7.Close;
      if form10.Visible then Form10.Close;
    except end;
    //
  except end;
  //
  try
    //
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
      //
      // Só se for necessário
      //
      Form7.ibDataSet101.Close;
      Form7.ibDataSet101.SelectSql.Clear;
      Form7.ibDataset101.SelectSql.Add('select gen_id(G_MUTADO,0) from rdb$database');
      Form7.ibDataset101.Open;
      //
      if (Form7.ibDataSet101.FieldByname('GEN_ID').AsFloat <> Form5.fMutado) then // or (Form7.ibDataSet100.FieldByname('GEN_ID').AsFloat = 0) then
      begin
        //
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
        //
      end;
      //
    except end;
    //
    Screen.Cursor := crDefault; // Cursor de Aguardo
    Form5.Enabled := True;
    Form1.Enabled := True;
    //
  except end;
  //
  Screen.Cursor := crDefault; // Cursor de Aguardo
  //
end;

procedure TForm1.CNPJdacontabilidade1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  Form7.sCNPJContabilidade := Small_InputForm('','Informe o CNPJ do Escritório de Contabilidade'+chr(10)+'(Isso dará a ele acesso aos XML da NF-e´s emitidas):',Form7.sCNPJContabilidade);
  //
  if CPFCGC(Form7.sCNPJContabilidade) then
  begin
    //
    // Grava
    //
    Mais1Ini.WriteString('XML','CNPJ da Contabilidade',Form7.sCNPJContabilidade);
    //
  end else
  begin
    //
    ShowMessage('CNPJ/CPF inválido');
    //
  end;
  //
  Mais1Ini.Free;
  Form1.AvisoConfig(True);
  //
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
  //
  Timer2.Enabled            := False;
  Timer1.Enabled            := False;
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  Form7.ibDataSet2.Disablecontrols;
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where Upper(OBS) like ''%REVENDA%''');  //
  Form7.ibDataSet2.Open;
  //
  Form7.ibDataset2.First;
  //
  while not Form7.ibDataset2.Eof do
  begin
    //
    try
      if Pos('{',Form7.ibDataset2OBS.AsString) <> 0 then
      begin
        sS := Copy(Form7.ibDataset2OBS.AsString,Pos('{',Form7.ibDataset2OBS.AsString)+1,Pos('}',Form7.ibDataset2OBS.AsString)-Pos('{',Form7.ibDataset2OBS.AsString)-1);
      end else
      begin
        sS := '';
      end;
      //
      Form7.ibDataset2.Edit;
      Form7.ibDataset2CONTATOS.AsString := '';
      Form7.ibDataset2OBS.AsString := 'REVENDA {'+sS+'}';
      Form7.ibDataset2.Post;
      //
    except end;
    //
    Form7.ibDataset2.Next;
    //
  end;
  //
  Form7.ibDataSet2.EnableControls;
  Screen.Cursor := crDefault;
  //
end;

procedure TForm1.N4001Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Form1.N301.Checked  := False;
  Form1.N3101.Checked := True;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Layout','4.00');
  Form1.sVersaoLayout := '4.00';
  Mais1ini.Free;
  //
  ConfiguraNFE(True);
  //
end;

procedure TForm1.Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form5.Visible then Form5.BringToFront;
  if Form7.Visible then Form7.BringToFront;
  if Form7.Visible and Form10.Visible then Form10.BringToFront;
  if Form12.Visible then Form12.BringToFront;
  if Form24.Visible then Form24.BringToFront;
  if Form48.Visible then Form48.BringToFront;
end;

procedure TForm1.Panel_0DblClick(Sender: TObject);
begin
//  Form5.Show;
end;

procedure TForm1.Label_bola_NFEClick(Sender: TObject);
begin
  //
  if Form1.bNotaCompraLiberada then
  begin
    Form1.Image201Click(Sender);
    Form7.Compras_1Click(Sender);
    //
    Form7.ibDataSet24.DisableControls;
    //
    try
      Form7.ibDataSet24.Close;
      Form7.ibDataSet24.SelectSQL.Clear;
      Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where Coalesce(MDESTINXML,''~'') like ''%<tpEvento>210210%'' and MERCADORIA=0');
//      Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where coalesce(NFEID,''0000000000000000000000000000000000000000000'')<>''0000000000000000000000000000000000000000000'' and coalesce(NFEXML,''X.X'')=''X.X'' and MERCADORIA=0');
      Form7.ibDataSet24.Open;
    except end;
    //
    Form7.ibDataSet24.EnableControls;
    //
  end;
  //
  Aviso('Temos '+InttoStr(Form1.iAvisosNFECompra)+' NF-e´s de entrada para manifestar ciência'+chr(10)+'e importar o XML.');
  //
end;

procedure TForm1.Label_bola_caixaClick(Sender: TObject);
begin
  //
  Form1.Image205Click(Sender);
  //
  Form7.ibDataSet1.DisableControls;
  //
  try
    Form7.ibDataSet1.Close;
    Form7.ibDataSet1.SelectSQL.Clear;
    Form7.ibDataSet1.SelectSQL.Add('select * from CAIXA  where coalesce(NOME,'+QuotedStr('')+')='+QuotedStr('')+' ');
    Form7.ibDataSet1.Open;
  except end;
  //
  Form7.ibDataSet1.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosCaixa)+' lançamentos no caixa não identificados'+chr(10)+'no (Plano De contas).');
  //
end;

procedure TForm1.Label_bola_bancoClick(Sender: TObject);
begin
  Form1.Image206Click(Sender);
  Form7.Lanamentosnocompensados1Click(Sender);
  Aviso('Temos '+InttoStr(Form1.iAvisosBanco)+' lançamentos não conciliados.');
  Screen.Cursor            := crDefault;
end;

procedure TForm1.Label_bola_pagarClick(Sender: TObject);
begin
  //
  Form1.Image210Click(Sender);
  //
  Form7.ibDataSet8.DisableControls;
  //
  try
    Form7.ibDataSet8.Close;
    Form7.ibDataSet8.SelectSQL.Clear;
    Form7.ibDataSet8.SelectSQL.Add('select * from PAGAR where VALOR_PAGO=0 and VENCIMENTO=CURRENT_DATE');
    Form7.ibDataSet8.Open;
  except end;
  //
  Form7.ibDataSet8.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosPagar)+' contas para pagar hoje.');
  //
end;

procedure TForm1.Label_bola_cliforClick(Sender: TObject);
begin
  //
  Form1.Image203Click(Sender);
  //
  Form7.ibDataSet2.DisableControls;
  //
  try
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.SelectSQL.Clear;
    Form7.ibDataSet2.SelectSQL.Add('select * from CLIFOR where PROXDATA=CURRENT_DATE');
    Form7.ibDataSet2.Open;
  except end;
  //
  Form7.ibDataSet2.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosClifor)+' clientes agendados para hoje.');
  //
end;

procedure TForm1.Label_bola_receberClick(Sender: TObject);
begin
  //
  Form1.Image204Click(Sender);
  //
  Form7.ibDataSet7.DisableControls;
  //
  try
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.SelectSQL.Clear;
    Form7.ibDataSet7.SelectSQL.Add('select * from RECEBER where VALOR_RECE=0 and VENCIMENTO=CURRENT_DATE');
    Form7.ibDataSet7.Open;
  except end;
  //
  Form7.ibDataSet7.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosReceber)+' contas para receber hoje.');
  //
end;

procedure TForm1.Label_Bola_estoqueClick(Sender: TObject);
begin
  //
  Form1.Image202Click(Sender);
  //
  Form7.ibDataSet4.DisableControls;
  //
  try
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.SelectSQL.Clear;
    Form7.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where QTD_ATUAL<QTD_MINIM and  coalesce(ATIVO,0)<>1');
    Form7.ibDataSet4.Open;
  except end;
  //
  Form7.ibDataSet4.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosEstoque)+' itens abaixo da quantidade mínima.');
  //
end;

procedure TForm1.Label_Bola_ConfigClick(Sender: TObject);
var
  sMSG : String;
begin
  //
  if Form7.Visible then Form7.Close;
  if Form10.Visible then Form10.Close;
  //
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
  //
  if AllTrim(sMSG) <> '' then
  begin
    sMSG := 'Temos que acertar isso: '+ chr(10) + chr(10) + sMSG +chr(10);
  end;
  //
  Aviso(sMSG);
  //
  try
    if (Pos('@',Form7.ibDataSet13EMAIL.AsString)=0) or
       (LimpaNumero(Form7.ibDataSet13TELEFO.AsString)='') or
       (AllTrim(Form7.ibDataSet13ESTADO.AsString)='')
      or (Form1.ValidaEmitenteMunicipio = False)
    then
    begin
      Form17.ShowModal;
    end;
    if AllTrim(Form7.sCNPJContabilidade) = '' then
    begin
      Form1.CNPJdacontabilidade1Click(Sender);
    end;
  except end;
  //
end;

procedure TForm1.Label_bola_OSClick(Sender: TObject);
begin
  //
  Image201_Click(Sender);
  //
  //
  Form7.ibDataSet3.DisableControls;
  //
  try
    Form7.ibDataSet3.Close;
    Form7.ibDataSet3.SelectSQL.Clear;
    Form7.ibDataSet3.SelectSQL.Add('select * from OS where DATA_PRO=CURRENT_DATE ');
    Form7.ibDataSet3.Open;
  except end;
  //
  Form7.ibDataSet3.EnableControls;
  //
  Aviso('Temos '+InttoStr(Form1.iAvisosOS)+' OS agendadas para hoje.');
  //
end;

procedure TForm1.Label_bola_indicadoresClick(Sender: TObject);
begin
  Image200Click(Sender);
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
    ConfiguraNFE(True);
  except end;  
end;

procedure TForm1.ConsultarNFesemitidas1Click(Sender: TObject);
var
  Mais1Ini : TiniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  //
  if Mais1Ini.ReadString('NFE','Consultar Nfes Emitidas','Sim') = 'Sim' then
    Mais1Ini.WriteString('NFE','Consultar Nfes Emitidas','Não')
  else
    Mais1Ini.WriteString('NFE','Consultar Nfes Emitidas','Sim');
  //
  Mais1Ini.Free;
  //
end;

procedure TForm1.Modoinventrio1Click(Sender: TObject);
var
  //
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  //
begin
  //
  if not Modoinventrio1.Checked then
  begin
    //
    Form7.Close;
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
      //
      Modoinventrio1.Checked := True;
      ShowMessage('Liberado a alteração na quantidade dos itens do estoque.');
      //
    end else
    begin
      ShowMessage('Senha inválida.');
    end;
  end else
  begin
    //
    Modoinventrio1.Checked := False;
    //
  end;
  //
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
    sMostra   := Mais1Ini.ReadString('ESTOQUE', 'Mostrar', 'TFTFFFTFFT'+Replicate('F', 42));
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

    Form1.Image202Click(Sender);
    ShowMessage('Ative agora os produtos para marketplace');
  end;

  Mais1ini.Free;
end;

procedure TForm1.Hub1Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', pChar('https://www.smallhub.com.br/login?doc='+Limpanumero(Form7.ibDAtaSet13CGC.AsString)),'', '', SW_SHOW); // MArketPlace
end;

procedure TForm1.Image201CClick(Sender: TObject);
begin
  //
  try
    //
    if not Legal(True) then Abort;
    //
    // NFe com CPF
    //
    if Form1.bNotaCompraLiberada then Form7.Compras_1.Enabled := True else Form7.Compras_1.Enabled := False;
    if Form1.bNotaCompraLiberada then Form7.Compras2.Enabled := True else Form7.Compras2.Enabled := False;
    //
    if Form1.bNotaCompraLiberada then
    begin
      Form7.Compras_1Click(Sender);
    end;
    //
    Form1.Label201MouseLeave(Sender);
    //
    if Form24.Visible then
      Form24.Show;
    //
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
end;

procedure TForm1.LAbel201CMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone NF-e
  //
  if Label201C.Font.Style <> [fsBold] then
  begin
    Image201C.Picture    := Image201C_X.Picture;
    Label201C.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      //
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_11.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_11.bmp') ; // else if FileExists(Form1.sAtual+'\inicial\fundo\512\_small_10.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\512\_small_10.bmp');
      //
      Titulo(
            'CONTROLE AS NOTAS'+Chr(10)+'DE COMPRAS',
            'Controle as entradas de '+chr(10)+
            'mercadoria da sua'+chr(10)+
            'empresa de forma'+chr(10)+
            'automática'
            );
      //
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;
      //
    end;
  end;

end;

procedure TForm1.Label201SMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //
  // Mouse move icone NF-e
  //
  if Label201S.Font.Style <> [fsBold] then
  begin
    Image201S.Picture    := Image201S_X.Picture;
    Label201S.Font.Style := [fsBold];
    if AllTrim(Form7.sModulo) = '' then
    begin
      //
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_12.bmp') then Form1.Image4.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_12.bmp');
      //
      Titulo(
            'EMITA A NFS-e DE'+chr(10)+'SERVIÇOS',
            'A Nota Fiscal Eletrônica de Serviços além'+chr(10)+
            'de atender a legislação controla os'+chr(10)+
            'serviços prestados pela sua'+chr(10)+
            'empresa'
            );
      //
      Form1.BringToFront;
            //
      Form44.Width  := Form7.Width;
      Form44.Top    := Form7.Top;
      Form44.Height := Form7.Height;
      Form44.LEft   := Form7.Left;
      //
      Form44.Close;
      Form44.Show;
      Form44.BringToFront;
      //
    end;
  end;
  //
end;

procedure TForm1.Image201SClick(Sender: TObject);
begin
  try
    if not Legal(True) then Abort;
    // NFS-e
    if Form1.bNotaServicoLiberada then
    begin
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      FechaTudo(Form1.bFechaTudo);

      Form7.sModulo := 'VENDA';
      Form7.sTitulo := 'Nota Fiscal de Serviço Eletronica (NFS-e) e Recibo Provisório de Serviços (RPS) RPS';
      Form7.sRPS    := 'S';

      Form7.Show;
      Screen.Cursor := crDefault; // Cursor de Aguardo
    end;

    Form1.Label201MouseLeave(Sender);

    if Form48.Visible then
      Form48.Show;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
end;

procedure TForm1.Simples1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Preenchimento','Simples');
  ShowMessage('Layoute de preenchimento definido como simples. Este programa vai ser fechado.');
  Mais1ini.Free;
  //
  Application.Terminate;
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  //
end;

procedure TForm1.Complexo1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Preenchimento','Comleto');
  ShowMessage('Layoute de preenchimento definido como completo. Este programa vai ser fechado.');
  Mais1ini.Free;
  //
  Application.Terminate;
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  //
  //
end;

procedure TForm1.ConverterosdadosparaSmallSaaS1Click(Sender: TObject);
var
  sCNPJ, sSenha  : String;
  sSenhaX : String;
  I : Integer;
  Mais1Ini : tIniFile;
  //
begin
  //
  sCNPJ := Form7.ibDataSet13CGC.AsString;
  //
  Form22.Show;
  Mensagem22('');
  Senhas2.ShowModal;
  Form22.Image1.Visible := False;
  Form22.Repaint;
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
    //
    I := Application.MessageBox(Pchar('Este procedimento vai converter os dados Small Commerce para o Small SaaS.'+ chr(10)
                            + Chr(10)
                            +'Confirma?'+ Chr(10)
                            + Chr(10)
                            +' Se estiver em dúvida clique no botão <Não>'+ Chr(10))
                            ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
    if I = IDYES then
    begin
      //
      if FileExists(Form1.sAtual+'\saas_.exe') then
      begin
        //
        try
          Commitatudo(True); // SQL - Commando
        except end;
        try
          FechaTudo(bFechaTudo);
          Form7.ibDataSet13.Close;
        except end;
        //
        Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
        Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer
        //
        while Form7.ibDataSet13.Active do Sleep(100);
        //
        if Form7.IBDatabaseInfo1.UserNames.Count = 1 then
        begin
          //
          try
            Form7.IBDatabase1.Connected := False;
          except end;
          //
          ShellExecute( 0, 'Open', pChar(Form1.sAtual+'\saas_.exe'),'', '', SW_SHOW);
          sleep(3000);
          //
          while ConsultaProcesso('saas_.exe') do
          begin
            sleep(1000);
          end;
          //
          if not FileExists(Form1.sAtual+'\small.fdb') then
          begin
            //
            if FileExists(Form1.sAtual+'\small.saas') then
            begin
              //
              try
                ApagaArquivoNoDeskTop('Small Commerce.lnk');
                ApagaArquivoNoDeskTop('Small Start.lnk');
                ApagaArquivoNoDeskTop('Small Mei.lnk');
                ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
                ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
                ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
                ApagaArquivoNoDeskTop('Orçamento (Documento Auxiliar de Venda).lnk');
                ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
                ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
                ApagaArquivoNoDeskTop('Consulta de Preços.lnk');
                ApagaArquivoNoDeskTop('Consulta.lnk');
              except end;
              //
              // Criar atalho no desktop
              //
//              try
//                CreateShortcut(PChar('https://www.smallsaas.com.br/entrar?credentials=' + f_encoding_base64('{"cpf_cnpj": "' + sCNPJ + '"}'),'','','Small Commerce (SAAS)','');
//                CreateShortcut(PChar('https://www.smallsaas.com.br'),'','','Small Commerce (SAAS)','');
//              except end;
              //
              ShowMessage('Sistema convertido para Small SaaS. Agora você poderá acessar seu sistema de'
              +chr(10)
              +'qualquer dispositivo em qualquer lugar pela internet.'
              +chr(10)
              +chr(10)
              +'Bem vindo ao Small SaaS!'
              +chr(10));
              //
//              ShellExecute( 0, 'Open',PChar('https://www.smallsaas.com.br/entrar?credentials=' + f_encoding_base64('{"cpf_cnpj": "' + sCNPJ + '"}'),'', '', SW_SHOWMAXIMIZED);
              ShellExecute( 0, 'Open',PChar('https://www.smallsaas.com.br'),'', '', SW_SHOWMAXIMIZED);
              //
            end else
            begin
              ShowMessage('Não foi possível converter os dados.');
            end;
            //
          end else
          begin
            ShowMessage('Não foi possível converter os dados.');
          end;
          //
        end else
        begin
          ShowMessage('Não foi possível converter os dados. Desconecte todos os usuários e tente novamente.');
        end;
        //
        Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        //
      end else
      begin
        ShowMessage('Não foi possível encontrar o programa de conversão. Atualize o sistema.');
      end;
      //
    end else
    begin
      ShowMessage('Nada foi convertido. Continue usando o Small Commerce.');
    end;
    //
  end else ShowMessage('Senha do administrador inválida.');
  //
  Form22.Close;
  //
end;

procedure TForm1.ConfiguraesdaNFSe2Click(Sender: TObject);
var
  sPadraoCidade : String;
  _file : TStringList;
  F: TextFile;
  Mais1Ini : tIniFile;
begin
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');
  //
//  if AllTrim(Mais1Ini.ReadString('NFSE','Arquivos',''))           = '' then Mais1Ini.WriteString('NFSE','Arquivos',Form1.sAtual+'\NFSE');
//  if AllTrim(Mais1Ini.ReadString('NFSE','DiretorioLog',''))       = '' then Mais1Ini.WriteString('NFSE','DiretorioLog',Form1.sAtual+'\NFSE\Log');
//  if AllTrim(Mais1Ini.ReadString('NFSE','DiretorioLogErro',''))   = '' then Mais1Ini.WriteString('NFSE','DiretorioLogErro',Form1.sAtual+'\NFSE\LogErro');
//  if AllTrim(Mais1Ini.ReadString('NFSE','CIDADE',''))             = '' then Mais1Ini.WriteString('NFSE','CIDADE',UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString));
//  if AllTrim(Mais1Ini.ReadString('NFSE','CNPJ',''))               = '' then Mais1Ini.WriteString('NFSE','CNPJ',LimpaNumero(Form7.ibDAtaset13CGC.AsString));
//  if AllTrim(Mais1Ini.ReadString('NFSE','InscricaoMunicipal','')) = '' then Mais1Ini.WriteString('NFSE','InscricaoMunicipal',LimpaNumero(Form7.ibDAtaset13IM.AsString));
  //
  Mais1Ini.WriteString('NFSE','CIDADE',UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString));
  Mais1Ini.WriteString('NFSE','CNPJ',LimpaNumero(Form7.ibDAtaset13CGC.AsString));
  Mais1Ini.WriteString('NFSE','InscricaoMunicipal',LimpaNumero(Form7.ibDAtaset13IM.AsString));
//  Mais1Ini.WriteString('Informacoes obtidas na prefeitura','Padrao','');
  Mais1ini.Free;
  //
  {Sandro Silva 2023-01-11 inicio
  if not FileExists(pChar(Form1.sAtual+'\NFSE.EXE')) then
  begin
    ShowMessage('Módulo de transmissão de NFS-e não instalado');
  end else
  }
  if Form1.ExisteNfseExe(Form1.sAtual) then
  begin
    //
    while FileExists(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
    begin
      DeleteFile(Pchar(Form1.sAtual+'\NFSE\smallnfse.tx2'));
      Sleep(1000);
    end;
    //
    AssignFile(F,pChar(Form1.sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    //
    Writeln(F,'Config=Sim');
    //
    CloseFile(F);
    //
    // Aguarda até criar o arquivo
    //
    while not FileExists(pChar(Form1.sAtual+'\NFSE\smallnfse.tx2')) do
    begin
      Sleep(1000);
    end;
    //
    ShellExecute( 0, 'Open',pChar('NFSE.EXE'),'', '', SW_SHOW);
    //
  end;
  //
  //
  //
  if FileExists(pChar(Form1.sAtual+'\NFSE\CidadesHomologadas.XML')) then
  begin
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfseConfig.ini');
    //
    try
      //
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
      //
    except
      Mais1Ini.WriteString('Informacoes obtidas na prefeitura','MultiplosServicos','NAO');
    end;
    //
    Mais1ini.Free;
    //
  end else
  //
end;

procedure TForm1.Debug1Click(Sender: TObject);
begin
  if Form1.Debug1.Checked then Form1.Debug1.Checked := False else Form1.Debug1.Checked := True;
end;

procedure TForm1.Image_bola_cliforClick(Sender: TObject);
begin
  //
  Form1.Image203Click(Sender);
  //
  Form7.ibDataSet2.DisableControls;
  //
  try
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.SelectSQL.Clear;
    Form7.ibDataSet2.SelectSQL.Add('select * from CLIFOR where PROXDATA=CURRENT_DATE');
    Form7.ibDataSet2.Open;
  except end;
  //
  Form7.ibDataSet4.EnableControls;
  Aviso('Temos '+InttoStr(Form1.iAvisosClifor)+' clientes agendados para hoje.');
  //
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
    // Isso influência e permitir abrir mais de uma instância do Small na mesma máquina
    // Não pode estar disponível para os clientes
    if (Form7.ibDataSet13.FieldByName('CGC').AsString = '07.426.598/0001-24') or (Form7.ibDataSet13.FieldByName('CGC').AsString = '03.916.076/0006-64') then
    begin
      sEmpresa := ' - [ ' + Form7.ibDataSet13.FieldByName('NOME').AsString + ' ' + Form7.ibDataSet13.FieldByName('CGC').AsString + ' ]';
      sCaption := Form1.Caption;
      if Pos(' - [', sCaption) > 0 then
        sCaption := Copy(sCaption, 1, Pos(' - [', sCaption) - 1);
      Form1.Caption := sCaption + sEmpresa;
    end;
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

function TForm1.CampoDisponivelParaUsuario(sModulo: String; sCampo: String): Boolean;
begin
  Result := True;

  if (sModulo = 'RECEBER') then
  begin
    if (AnsiUpperCase(sCampo) = 'MOVIMENTO') then
    begin
      Result := DisponivelSomenteParaNos;
    end;
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
    ShowMessage('Módulo de transmissão de NFS-e não instalado');
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


