// Cadastro de produtos/clientes/fornecedores
unit Unit10;

interface

uses
  Windows,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, IniFiles, Mask, DBCtrls, SMALL_DBEdit,
  Buttons, SmallFunc, DB, shellapi, ComCtrls, Grids,
  DBGrids, Printers, HtmlHelp, JPEG, Videocap, Clipbrd, OleCtrls, SHDocVw,
  xmldom, XMLIntf, DBClient, msxmldom, XMLDoc, ExtDlgs,
  uframePesquisaPadrao, uframePesquisaProduto, IBCustomDataSet, IBQuery;

const TEXTO_NAO_MOVIMENTA_ESTOQUE          = '= Não movimenta o Estoque';
const TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS = '0 Usar o custo de compra nas notas';

const ID_CONSULTANDO_INSTITUICAO_FINANCEIRA = 1;
const ID_CONSULTANDO_FORMA_DE_PAGAMENTO     = 2;
const ID_CONSULTANDO_CFOP                   = 3; //Mauricio Parizotto 2023-08-25

type

  TForm10 = class(TForm)
    Panel_branco: TPanel;
    orelhas: TPageControl;
    orelha_cadastro: TTabSheet;
    Label45: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    pnRelacaoComercial: TPanel;
    Label56: TLabel;
    ComboBox8: TComboBox;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit6: TSMALL_DBEdit;
    SMALL_DBEdit7: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    SMALL_DBEdit10: TSMALL_DBEdit;
    SMALL_DBEdit11: TSMALL_DBEdit;
    SMALL_DBEdit12: TSMALL_DBEdit;
    SMALL_DBEdit13: TSMALL_DBEdit;
    SMALL_DBEdit14: TSMALL_DBEdit;
    SMALL_DBEdit15: TSMALL_DBEdit;
    SMALL_DBEdit16: TSMALL_DBEdit;
    SMALL_DBEdit17: TSMALL_DBEdit;
    SMALL_DBEdit18: TSMALL_DBEdit;
    SMALL_DBEdit19: TSMALL_DBEdit;
    SMALL_DBEdit20: TSMALL_DBEdit;
    SMALL_DBEdit21: TSMALL_DBEdit;
    SMALL_DBEdit22: TSMALL_DBEdit;
    SMALL_DBEdit23: TSMALL_DBEdit;
    SMALL_DBEdit24: TSMALL_DBEdit;
    SMALL_DBEdit25: TSMALL_DBEdit;
    SMALL_DBEdit26: TSMALL_DBEdit;
    SMALL_DBEdit27: TSMALL_DBEdit;
    SMALL_DBEdit28: TSMALL_DBEdit;
    SMALL_DBEdit29: TSMALL_DBEdit;
    SMALL_DBEdit30: TSMALL_DBEdit;
    DBMemo2: TDBMemo;
    DBMemo1: TDBMemo;
    DBGrid1: TDBGrid;
    DBGrid3: TDBGrid;
    orelha_ICMS: TTabSheet;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label53: TLabel;
    Label51: TLabel;
    lblCIT: TLabel;
    LabelDescricaoNCM: TLabel;
    Label83: TLabel;
    SMALL_DBEdit31: TSMALL_DBEdit;
    SMALL_DBEdit37: TSMALL_DBEdit;
    SMALL_DBEdit38: TSMALL_DBEdit;
    ComboBox9: TComboBox;
    cboCST_Prod: TComboBox;
    cboOrigemProd: TComboBox;
    cboCSOSN_Prod: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    pnlMapaICMS: TPanel;
    Image4: TImage;
    Label52: TLabel;
    _AP: TLabel;
    _RR: TLabel;
    _AM: TLabel;
    _AC: TLabel;
    _RO: TLabel;
    _PA: TLabel;
    _MA: TLabel;
    _CE: TLabel;
    _RN: TLabel;
    _PB: TLabel;
    _PE: TLabel;
    _AL: TLabel;
    _SE: TLabel;
    _PI: TLabel;
    _TO: TLabel;
    _MT: TLabel;
    _DF: TLabel;
    _BA: TLabel;
    _GO: TLabel;
    _MG: TLabel;
    _ES: TLabel;
    _RJ: TLabel;
    _SP: TLabel;
    _MS: TLabel;
    _PR: TLabel;
    _SC: TLabel;
    _RS: TLabel;
    SMALL_DBEditY: TSMALL_DBEdit;
    ComboBox11: TComboBox;
    Orelha_IPI: TTabSheet;
    Label41: TLabel;
    Label40: TLabel;
    ComboBox1: TComboBox;
    SMALL_DBEdit41: TSMALL_DBEdit;
    Orelha_PISCOFINS: TTabSheet;
    gbPisCofinsSaida: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Label49: TLabel;
    ComboBox7: TComboBox;
    dbepPisSaida: TSMALL_DBEdit;
    dbepCofinsSaida: TSMALL_DBEdit;
    gbPisCofinsEntrada: TGroupBox;
    Label38: TLabel;
    Label50: TLabel;
    Label54: TLabel;
    ComboBox10: TComboBox;
    dbepPisEntrada: TSMALL_DBEdit;
    dbepCofinsEntrada: TSMALL_DBEdit;
    Orelha_grade: TTabSheet;
    Label39: TLabel;
    StringGrid1: TStringGrid;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Button3: TBitBtn;
    orelha_serial: TTabSheet;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit11: TEdit;
    Edit3: TEdit;
    Edit10: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    DBGrid4: TDBGrid;
    CheckBox1: TCheckBox;
    Button17: TBitBtn;
    Button15: TBitBtn;
    Button16: TBitBtn;
    orelha_composicao: TTabSheet;
    Edit5: TEdit;
    Edit6: TEdit;
    dbgComposicao: TDBGrid;
    SMALL_DBEdit33: TSMALL_DBEdit;
    SMALL_DBEdit34: TSMALL_DBEdit;
    SMALL_DBEdit35: TSMALL_DBEdit;
    Button8: TBitBtn;
    Button10: TBitBtn;
    Button11: TBitBtn;
    orelha_foto: TTabSheet;
    Image3: TImage;
    Image5: TImage;
    VideoCap1: TVideoCap;
    Button13: TBitBtn;
    Button7: TBitBtn;
    WebBrowser1: TWebBrowser;
    Orelha_preco: TTabSheet;
    Image6: TImage;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label70: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Edit15: TEdit;
    SMALL_DBEdit32: TSMALL_DBEdit;
    Edit16: TEdit;
    SMALL_DBEdit36: TSMALL_DBEdit;
    Edit17: TEdit;
    SMALL_DBEdit39: TSMALL_DBEdit;
    Button20: TBitBtn;
    Edit18: TEdit;
    SMALL_DBEdit40: TSMALL_DBEdit;
    Edit19: TEdit;
    SMALL_DBEdit42: TSMALL_DBEdit;
    Edit20: TEdit;
    SMALL_DBEdit43: TSMALL_DBEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Button18: TBitBtn;
    Button14: TBitBtn;
    Orelha_promo: TTabSheet;
    ORELHA_CFOP: TTabSheet;
    Image7: TImage;
    __RR: TLabel;
    __AP: TLabel;
    __AM: TLabel;
    __AC: TLabel;
    __RO: TLabel;
    __PA: TLabel;
    __MT: TLabel;
    __MA: TLabel;
    __CE: TLabel;
    __RN: TLabel;
    __PB: TLabel;
    __PE: TLabel;
    __AL: TLabel;
    __SE: TLabel;
    __BA: TLabel;
    __PI: TLabel;
    __TO: TLabel;
    __DF: TLabel;
    __GO: TLabel;
    __MS: TLabel;
    __SP: TLabel;
    __MG: TLabel;
    __ES: TLabel;
    __RJ: TLabel;
    __PR: TLabel;
    __SC: TLabel;
    __RS: TLabel;
    Label100: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    dbeIcmCFOP: TSMALL_DBEdit;
    SMALL_DBEdit54: TSMALL_DBEdit;
    SMALL_DBEdit55: TSMALL_DBEdit;
    SMALL_DBEdit56: TSMALL_DBEdit;
    SMALL_DBEdit57: TSMALL_DBEdit;
    SMALL_DBEdit58: TSMALL_DBEdit;
    SMALL_DBEdit59: TSMALL_DBEdit;
    SMALL_DBEdit60: TSMALL_DBEdit;
    SMALL_DBEditX: TSMALL_DBEdit;
    ORELHA_COMISSAO: TTabSheet;
    Label81: TLabel;
    Label82: TLabel;
    SMALL_DBEdit61: TSMALL_DBEdit;
    SMALL_DBEdit62: TSMALL_DBEdit;
    Panel5: TPanel;
    Image201: TImage;
    Image202: TImage;
    Image203: TImage;
    Image204: TImage;
    Image205: TImage;
    Panel2: TPanel;
    btnOK: TBitBtn;
    Button9: TBitBtn;
    Button12: TBitBtn;
    Panel1: TPanel;
    Button4: TBitBtn;
    Panel8: TPanel;
    Button19: TBitBtn;
    Label201: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    Label204: TLabel;
    Label205: TLabel;
    Panel9: TPanel;
    Image201_X: TImage;
    Image202_X: TImage;
    Image203_X: TImage;
    Image204_X: TImage;
    Image205_X: TImage;
    Panel10: TPanel;
    Image201_R: TImage;
    Image202_R: TImage;
    Image203_R: TImage;
    Image204_R: TImage;
    Image205_R: TImage;
    Orelha_CONVERSAO: TTabSheet;
    Label85: TLabel;
    Label86: TLabel;
    SMALL_DBEdit64: TSMALL_DBEdit;
    Label87: TLabel;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    Label88: TLabel;
    Label89: TLabel;
    Orelha_codebar: TTabSheet;
    DBGrid5: TDBGrid;
    RichEdit1: TRichEdit;
    Label72: TLabel;
    ComboBox14: TComboBox;
    Label84: TLabel;
    ComboBox15: TComboBox;
    Label92: TLabel;
    SMALL_DBEdit66: TSMALL_DBEdit;
    Label71: TLabel;
    Label90: TLabel;
    SMALL_DBEdit52: TSMALL_DBEdit;
    Label91: TLabel;
    SMALL_DBEdit63: TSMALL_DBEdit;
    Label93: TLabel;
    SMALL_DBEdit65: TSMALL_DBEdit;
    Label94: TLabel;
    Label95: TLabel;
    SMALL_DBEdit67: TSMALL_DBEdit;
    Label96: TLabel;
    Label97: TLabel;
    btnRenogiarDivida: TBitBtn;
    Label98: TLabel;
    SMALL_DBEdit68: TSMALL_DBEdit;
    GroupBox3: TGroupBox;
    Label44: TLabel;
    SMALL_DBEdit45: TSMALL_DBEdit;
    Label46: TLabel;
    SMALL_DBEdit46: TSMALL_DBEdit;
    Label47: TLabel;
    SMALL_DBEdit50: TSMALL_DBEdit;
    Label48: TLabel;
    SMALL_DBEdit51: TSMALL_DBEdit;
    GroupBox4: TGroupBox;
    Label99: TLabel;
    SMALL_DBEdit69: TSMALL_DBEdit;
    Label102: TLabel;
    SMALL_DBEdit71: TSMALL_DBEdit;
    Label101: TLabel;
    Label103: TLabel;
    SMALL_DBEdit70: TSMALL_DBEdit;
    Label104: TLabel;
    SMALL_DBEdit72: TSMALL_DBEdit;
    Label105: TLabel;
    Orelha_TAGS: TTabSheet;
    DBMemo3: TDBMemo;
    Label106: TLabel;
    Memo1: TMemo;
    StringGrid2: TStringGrid;
    Image1: TImage;
    Orelha_MKT: TTabSheet;
    CheckBox2: TCheckBox;
    Button22: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    SMALL_DBEdit73: TSMALL_DBEdit;
    Label107: TLabel;
    framePesquisaProdComposicao: TframePesquisaProduto;
    lblLimiteCredDisponivel: TLabel;
    eLimiteCredDisponivel: TEdit;
    Label108: TLabel;
    SMALL_DBEdit44: TSMALL_DBEdit;
    Label109: TLabel;
    SMALL_DBEdit47: TSMALL_DBEdit;
    DBCheckSobreIPI: TDBCheckBox;
    DBCheckSobreOutras: TDBCheckBox;
    DBCheckFRETESOBREIPI: TDBCheckBox;
    Label110: TLabel;
    DBMemo4: TDBMemo;
    cbMovimentacaoEstoque: TComboBox;
    Label111: TLabel;
    IBQPLANOCONTAS: TIBQuery;
    cbIntegracaoFinanceira: TComboBox;
    orelha_PerfilTrib: TTabSheet;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    lblCSOSNPerfilTrib: TLabel;
    lblCSTPerfilTrib: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    lblCitPerfilTrib: TLabel;
    lblCFOPNfce: TLabel;
    lblCSOSN_NFCePerfilTrib: TLabel;
    lblCST_NFCePerfilTrib: TLabel;
    SMALL_DBEdit49: TSMALL_DBEdit;
    SMALL_DBEdit53: TSMALL_DBEdit;
    cboCSTPerfilTrib: TComboBox;
    cboTipoItemPerfTrib: TComboBox;
    cboIPPTPerfTrib: TComboBox;
    cboIATPerfTrib: TComboBox;
    cboOrigemPerfTrib: TComboBox;
    cboCSOSNPerfilTrib: TComboBox;
    cboCFOP_NFCePerfTrib: TComboBox;
    cboCST_NFCePerfilTrib: TComboBox;
    cboCSOSN_NFCePerfilTrib: TComboBox;
    lblAliqNFCEPerfilTrib: TLabel;
    SMALL_DBEdit75: TSMALL_DBEdit;
    Label128: TLabel;
    edtDescricaoPerfilTrib: TSMALL_DBEdit;
    Label129: TLabel;
    orelha_PerfilTrib_IPI: TTabSheet;
    orelha_PerfilTrib_PISCOFINS: TTabSheet;
    GroupBox1: TGroupBox;
    Label112: TLabel;
    lblCST_PIS_S_PerTrib: TLabel;
    lblCST_COFINS_S_PerTrib: TLabel;
    cboCST_PISCOFINS_S_PerTrib: TComboBox;
    SMALL_DBEdit48: TSMALL_DBEdit;
    SMALL_DBEdit74: TSMALL_DBEdit;
    GroupBox2: TGroupBox;
    Label131: TLabel;
    lblCST_PIS_E_PerTrib: TLabel;
    lblCST_COFINS_E_PerTrib: TLabel;
    cboCST_PISCOFINS_E_PerTrib: TComboBox;
    SMALL_DBEdit77: TSMALL_DBEdit;
    SMALL_DBEdit78: TSMALL_DBEdit;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    cboCST_IPI_PerTrib: TComboBox;
    SMALL_DBEdit79: TSMALL_DBEdit;
    SMALL_DBEdit80: TSMALL_DBEdit;
    lbBCPISCOFINS: TLabel;
    dbeIcmBCPISCOFINS: TSMALL_DBEdit;
    procedure Image204Click(Sender: TObject);
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure SMALL_DBEdit1Exi(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1Click(Sender: TObject);
    procedure dbgComposicaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgComposicaoKeyPress(Sender: TObject; var Key: Char);
    procedure TabSheet4Show(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit23KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox1Exit(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure DBGrid4KeyPress(Sender: TObject; var Key: Char);
    procedure Button17Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure DBGrid5KeyPress(Sender: TObject; var Key: Char);
    procedure Label45Click(Sender: TObject);
    procedure Image201Click(Sender: TObject);
    procedure Image205Click(Sender: TObject);
    procedure Panel_1Enter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label36MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image202Click(Sender: TObject);
    procedure Label37MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label37MouseLeave(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Label40MouseLeave(Sender: TObject);
    procedure Label40MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label42MouseLeave(Sender: TObject);
    procedure Label42MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label43Click(Sender: TObject);
    procedure Label43MouseLeave(Sender: TObject);
    procedure Label43MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Label52MouseLeave(Sender: TObject);
    procedure Label52MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label51MouseLeave(Sender: TObject);
    procedure Label51MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label44MouseLeave(Sender: TObject);
    procedure Label44MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label53MouseLeave(Sender: TObject);
    procedure Label53MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label36MouseLeave(Sender: TObject);
    procedure Label35MouseLeave(Sender: TObject);
    procedure Label55MouseLeave(Sender: TObject);
    procedure Label55MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image_FechaClick(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label19MouseLeave(Sender: TObject);
    procedure Label23MouseLeave(Sender: TObject);
    procedure Label23MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image20Click(Sender: TObject);
    procedure Label54Click(Sender: TObject);
    procedure Image23Click(Sender: TObject);
    procedure SMALL_DBEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DBMemo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo2Enter(Sender: TObject);
    procedure DBMemo2Exit(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure Label25MouseLeave(Sender: TObject);
    procedure Label25MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SMALL_DBEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image5Click(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormShow(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Image203Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Label18MouseLeave(Sender: TObject);
    procedure Label18MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label18Click(Sender: TObject);
    procedure Orelha_gradeShow(Sender: TObject);
    procedure orelha_serialShow(Sender: TObject);
    procedure orelha_fotoShow(Sender: TObject);
    procedure orelha_composicaoShow(Sender: TObject);
    procedure orelha_ICMSShow(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure cboOrigemProdChange(Sender: TObject);
    procedure cboCST_ProdChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure cboCSOSN_ProdChange(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox9Change(Sender: TObject);
    procedure SMALL_DBEdit38Exit(Sender: TObject);
    procedure ComboBox9KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orelha_cadastroShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Orelha_precoShow(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure SMALL_DBEdit32KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit32Exit(Sender: TObject);
    procedure ComboBox10Change(Sender: TObject);
    procedure Orelha_PISCOFINSEnter(Sender: TObject);
    procedure Orelha_IPIEnter(Sender: TObject);
    procedure orelha_cadastroExit(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure Orelha_promoEnter(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SMALL_DBEdit31Change(Sender: TObject);
    procedure ORELHA_CFOPShow(Sender: TObject);
    procedure __RRClick(Sender: TObject);
    procedure SMALL_DBEditXExit(Sender: TObject);
    procedure _RRClick(Sender: TObject);
    procedure SMALL_DBEditYExit(Sender: TObject);
    procedure ORELHA_COMISSAOEnter(Sender: TObject);
    procedure ComboBox11Change(Sender: TObject);
    procedure Label201MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label202MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label203MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label204MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label205MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label201MouseLeave(Sender: TObject);
    procedure Label202MouseLeave(Sender: TObject);
    procedure Label203MouseLeave(Sender: TObject);
    procedure Label204MouseLeave(Sender: TObject);
    procedure Label205MouseLeave(Sender: TObject);
    procedure Orelha_CONVERSAOEnter(Sender: TObject);
    procedure SMALL_DBEdit64Change(Sender: TObject);
    procedure ComboBox12Change(Sender: TObject);
    procedure ComboBox13Change(Sender: TObject);
    procedure SMALL_DBEdit64Exit(Sender: TObject);
    procedure cboOrigemProdEnter(Sender: TObject);
    procedure Orelha_codebarEnter(Sender: TObject);
    procedure DBGrid5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox14Change(Sender: TObject);
    procedure ComboBox15Change(Sender: TObject);
    procedure btnRenogiarDividaClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure Orelha_TAGSShow(Sender: TObject);
    procedure Orelha_TAGSExit(Sender: TObject);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Image1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ButtoOpenPictureDialog1n22Click(Sender: TObject);
    procedure dbgComposicaoColEnter(Sender: TObject);
    procedure dbgComposicaoColExit(Sender: TObject);
    procedure dbgComposicaoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure framePesquisaProdComposicaodbgItensPesqCellClick(
      Column: TColumn);
    procedure framePesquisaProdComposicaodbgItensPesqKeyPress(
      Sender: TObject; var Key: Char);
    procedure framePesquisaProdComposicaodbgItensPesqKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure cbIntegracaoFinanceiraExit(Sender: TObject);
    procedure cbMovimentacaoEstoqueExit(Sender: TObject);
    procedure DBMemo4Enter(Sender: TObject);
    procedure ComboBoxEnter(Sender: TObject);
    procedure DBMemo4KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure cboCST_IPI_PerTribChange(Sender: TObject);
    procedure orelha_PerfilTrib_IPIShow(Sender: TObject);
    procedure orelha_PerfilTrib_IPIEnter(Sender: TObject);
    procedure cboCST_PISCOFINS_S_PerTribChange(Sender: TObject);
    procedure cboCST_PISCOFINS_E_PerTribChange(Sender: TObject);
    procedure edtDescricaoPerfilTribMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure cboTipoItemPerfTribChange(Sender: TObject);
    procedure cboIPPTPerfTribChange(Sender: TObject);
    procedure cboIATPerfTribChange(Sender: TObject);
    procedure cboOrigemPerfTribChange(Sender: TObject);
    procedure cboCFOP_NFCePerfTribChange(Sender: TObject);
    procedure cboCSTPerfilTribChange(Sender: TObject);
    procedure cboCST_NFCePerfilTribChange(Sender: TObject);
    procedure cboCSOSN_NFCePerfilTribChange(Sender: TObject);
    procedure cboCSOSNPerfilTribChange(Sender: TObject);
    procedure SMALL_DBEdit53Exit(Sender: TObject);
  private
    cCadJaValidado: String;
    procedure ibDataSet28DESCRICAOChange(Sender: TField);
    procedure DefinirVisibleConsultaProdComposicao;
    procedure AtribuirItemPesquisaComposicao;
    procedure DefinirLimiteDisponivel;
    procedure AlteracaoInstituicaoFinanceira;
    procedure AtualizaObjComValorDoBanco;
    { Private declarations }
    function MostraImagemEstoque: Boolean;
    procedure CarregaCit;
    procedure CarregaCitPerfilTrib;
  public
    { Public declarations }

    fQuantidade : Real;
    sNomeDoJPG, sSistema  : String;
    sLinha : String;
    sColuna : String;
    sRegistroVolta : String;
    bNovo : boolean;
    sNomeDoArquivoParaSalvar : String;
    bGravaEscolha : boolean;
    rCusto : Real;

    function JpgResize(sP1: String; iP2: Integer): boolean;
    function AtualizaMobile(sP1: Boolean) : Boolean;

  end;

var

  Form10   : TForm10;
  tProcura : TDataSet;
  bProximo : Boolean;
  sText    : String;
  sContatos : String;

implementation

uses Unit7, Mais, Unit38, Unit16, Unit12, unit24, Unit22,
  preco1, Unit20, Unit19, Mais3, Unit18, StrUtils, uTestaProdutoExiste,
  uITestaProdutoExiste
  {Sandro Silva 2022-09-26 inicio}
  , WinInet
  {Sandro Silva 2022-09-26 fim}
  , uRetornaLimiteDisponivel
  , uFuncoesBancoDados
  , uFuncoesRetaguarda
  ;
  
{$R *.DFM}

function TForm10.JpgResize(sP1: String; iP2: Integer): boolean;
var
  _bmp:    TBitmap;
  Picture: TPicture;
  jp    : TJPEGImage;
  Rect  : tRect;
begin
  //
  while FileExists(pChar(Form1.sAtual+'\tempo.bmp')) do DeleteFile(pChar(Form1.sAtual+'\tempo.bmp'));
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
  if FileExists('tempo.bmp') then
  begin
    //
    Form10.Image5.Picture.LoadFromFile('tempo.bmp');
    //
    Rect.Top := 0;
    Rect.Left := 0;
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

function GravaRegistro(sP1 : boolean):Boolean;
begin
  if Form7.bEstaSendoUsado then
  begin
    Form7.ArquivoAberto.Cancel;
  end else
  begin
    if Form7.ArquivoAberto.Modified then
    begin
      Form7.ArquivoAberto.Post;
    end else
    begin
      Form7.ArquivoAberto.Cancel;
    end;
  end;

  if Form7.sModulo = 'RECEBER' then
  begin
    try
      if Form7.ibDataSet2.Modified then
      begin
        Form7.IBDataSet2.Post;
      end;
    except
    end;
  end;

  try
    if Form7.ibDataSet13.Modified then
    begin
      Form7.IBDataSet13.Post;
    end;
  except
  end;

  Form7.IBTransaction1.CommitRetaining;
  Result := True;
end;

function Exemplo(sP1 : boolean):Boolean;
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDAE.AsString)+' ');
  Form1.ibQuery1.Open;

  Form10.Label89.Caption := 'Compra 1 '+Form1.IBQuery1.FieldByname('DESCRICAO').AsString+' e vende'+chr(10);

  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDA.AsString)+' ');
  Form1.ibQuery1.Open;

  Form10.Label89.Caption := Form10.Label89.Caption + FloatToStr(Form7.ibDataSet4FATORC.AsFloat) + ' ' + Form1.IBQuery1.FieldByname('DESCRICAO').AsString;

  Result := True;
end;

function AtualizaTela(sP1 : boolean):Boolean;
var
  I : Integer;
  FileStream : TFileStream;
  BlobStream : TStream;
  sTotal     : string;
  JP2         : TJPEGImage;
begin
  // Posiciona o foco quando ativa
  Result := True;
  try
    if Form7.sModulo = 'ESTOQUE' then
    begin
      if (Date >= Form7.ibDataSet4PROMOINI.AsDateTime) and (Date <= Form7.ibDataSet4PROMOFIM.AsDateTime) then
      begin
        Form7.ibDataSet4PRECO.ReadOnly := True;
        Form10.SMALL_DBEdit6.Font.Color := clGrayText;
        Form10.Label6.Caption := 'Preço promocional:';
      end else
      begin
        try
          if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
            Form7.ibDataset4.Edit;
          if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
          begin
            Form7.ibDataSet4OFFPROMO.AsFloat := Form7.ibDataSet4PRECO.AsFloat;
          end;
          Form7.ibDataSet4PRECO.ReadOnly := False;
          Form10.SMALL_DBEdit6.Font.Color := clblack;
        except
        end;
      end;
    end;
  except end;

  try
    if Form7.sModulo = 'CAIXA' then
    begin
      Form7.IBDataSet99.Close;
      Form7.IBDataSet99.SelectSQL.Clear;
      Form7.IBDataSet99.SelectSQL.Add('select count(REGISTRO) from caixa '+Form7.sWhere);
      Form7.IBDataSet99.Open;
      sTotal := Form7.IBDataSet99.fieldByname('COUNT').AsString;
      Form7.IBDataSet99.Close;
    end else
    begin
      Form7.IBDataSet99.Close;
      Form7.IBDataSet99.SelectSQL.Clear;
      Form7.IBDataSet99.SelectSQL.Add(StrTran(Form7.sSelect,'*','count(REGISTRO)')+' '+Form7.sWhere);
      Form7.IBDataSet99.Open;
      sTotal := Form7.IBDataSet99.fieldByname('COUNT').AsString;
      Form7.IBDataSet99.Close;
    end;

    Form10.orelha_cadastro.Caption := 'Ficha '+IntToStr(Form7.ArquivoAberto.Recno)+' de '+IntToStr(StrToInt(sTotal));

    if sP1 then
    begin
      if Form10.SMALL_DBEdit1.CanFocus then
        Form10.SMALL_DBEdit1.SetFocus
      else if Form10.SMALL_DBEdit2.CanFocus then
         Form10.SMALL_DBEdit2.SetFocus
      else if Form10.SMALL_DBEdit3.CanFocus then
        Form10.SMALL_DBEdit3.SetFocus
      else if Form10.SMALL_DBEdit4.CanFocus then
        Form10.SMALL_DBEdit4.SetFocus
      else if Form10.SMALL_DBEdit5.CanFocus then
        Form10.SMALL_DBEdit5.SetFocus;
    end;

    Form10.Caption := 'Ficha';

    if Form7.sModulo = 'CLIENTES' then
    begin
      if AllTrim(Form7.ArquivoAberto.FieldByName('CLIFOR').AsString)<>'' then
      begin
        for I := 0 to Form10.ComboBox8.Items.Count -1 do
        begin
          if Form10.ComboBox8.Items[I] = Form7.ArquivoAberto.FieldByName('CLIFOR').AsString then
          begin
            Form10.ComboBox8.ItemIndex := I;
          end;
        end;
      end else
      begin
        if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
        begin
          Form10.ComboBox8.ItemIndex := 8;
        end else
        begin
          Form10.ComboBox8.ItemIndex := 0;
        end;
      end;

      Form10.Caption := form7.ibDataSet2NOME.AsString;
    end;

    if Form7.sModulo = 'PERFILTRIBUTACAO' then
    begin
      Form10.Caption := form7.ibdPerfilTributaDESCRICAO.AsString;
    end;

    if Form7.sModulo = 'RECEBER' then
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
      Form7.ibDataSet2.Open;
    end;

    if (Form7.sModulo = 'CLIENTES') then
    begin
      Form10.Image5.Picture := nil;
      Form10.Image3.Picture := nil;

      if FileExists(Form10.sNomeDoJPG) then
      begin
        if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
          Form7.ibDataset2.Edit;
        FileStream := TFileStream.Create(Form10.sNomeDoJPG,fmOpenRead or fmShareDenyWrite);
        BlobStream := Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmWrite);
        try
          BlobStream.CopyFrom(FileStream,FileStream.Size);
        finally
          FileStream.Free;
          BlobStream.Free;
        end;

        Deletefile(pChar(Form10.sNomeDoJPG));
      end;

      if Form7.ibDataset2FOTO.BlobSize <> 0 then
      begin
        BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmRead);
        jp2 := TJPEGImage.Create;
        try
          jp2.LoadFromStream(BlobStream);
          Form10.Image5.Picture.Assign(jp2);
        finally
          BlobStream.Free;
          jp2.Free;
        end;
      end
      else
        Form10.Image5.Picture := Form10.Image3.Picture;
    end
    else
      Form10.Image5.Picture := Form10.Image3.Picture;

    if (Form7.sModulo = 'ESTOQUE') then
    begin
      Form10.Caption := Form7.ibDataSet4DESCRICAO.AsString;

      Form10.Image5.Picture := nil;
      Form10.Image3.Picture := nil;

      if AllTrim(Form7.ibDataSet4DESCRICAO.AsString) <> '' then
      begin
        // FOTOS ANTIGAS
        if FileExists(Form10.sNomeDoJPG) then
        begin
          if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
            Form7.ibDataset4.Edit;
          FileStream := TFileStream.Create(pChar(Form10.sNomeDoJPG),fmOpenRead or fmShareDenyWrite);
          BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmWrite);
          try
            BlobStream.CopyFrom(FileStream, FileStream.Size);
          finally
            FileStream.Free;
            BlobStream.Free;
          end;
          // Form7.ibDataset4.Post;
          Deletefile(pChar(Form10.sNomeDoJPG));
        end;

        if Form7.ibDataset4FOTO.BlobSize <> 0 then
        begin
          BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmRead);
          jp2 := TJPEGImage.Create;
          try
            try
              jp2.LoadFromStream(BlobStream);
              Form10.Image5.Picture.Assign(jp2);
              Form10.Image5.Repaint;

            except
              Result := False;
            end;
          finally
            BlobStream.Free;
            jp2.Free;
          end;
        end
        else
          Form10.Image5.Picture := Form10.Image3.Picture;
      end
      else
        Form10.Image5.Picture := Form10.Image3.Picture;
    end;

    if Form7.sModulo = 'GRUPOS' then
    begin
      Form10.Image5.Picture := nil;
      Form10.Image3.Picture := nil;

      if AllTrim(Form7.ibDataSet21NOME.AsString) <> '' then
      begin
        if FileExists(Form10.sNomeDoJPG) then
        begin
          if not (Form7.ibDataset21.State in ([dsEdit, dsInsert])) then Form7.ibDataset21.Edit;
          FileStream := TFileStream.Create(Form10.sNomeDoJPG,fmOpenRead or fmShareDenyWrite);
          BlobStream := Form7.ibDataset21.CreateBlobStream(Form7.ibDataset21FOTO,bmWrite);
          try
            BlobStream.CopyFrom(FileStream,FileStream.Size);
          finally
            FileStream.Free;
            BlobStream.Free;
          end;
          // Form7.ibDataset21.Post;
          Deletefile(pChar(Form10.sNomeDoJPG));
        end;
        
        if Form7.ibDataset21FOTO.BlobSize <> 0 then
        begin
          BlobStream:= Form7.ibDataset21.CreateBlobStream(Form7.ibDataset21FOTO,bmRead);
          jp2 := TJPEGImage.Create;
          try
            jp2.LoadFromStream(BlobStream);
            Form10.Image5.Picture.Assign(jp2);
            Form10.Image5.Repaint;
          finally
            BlobStream.Free;
            jp2.Free;
          end;
        end
        else
          Form10.Image5.Picture := Form10.Image3.Picture;
      end
      else
        Form10.Image5.Picture := Form10.Image3.Picture;
    end;


    // Mantem a proporção da imagem
    try
      if Form10.Image5.Picture.Width <> 0 then
      begin
        Form10.Image5.Width   := 256;
        Form10.Image5.Height  := 256;

        if Form10.Image5.Picture.Width > Form10.Image5.Picture.Height then
        begin
          Form10.Image5.Width  := StrToInt(StrZero((Form10.Image5.Picture.Width * (Form10.Image5.Width / Form10.Image5.Picture.Width)),10,0));
          Form10.Image5.Height := StrToInt(StrZero((Form10.Image5.Picture.Height* (Form10.Image5.Width / Form10.Image5.Picture.Width)),10,0));
        end else
        begin
          Form10.Image5.Width  := StrToInt(StrZero((Form10.Image5.Picture.Width * (Form10.Image5.Height / Form10.Image5.Picture.Height)),10,0));
          Form10.Image5.Height := StrToInt(StrZero((Form10.Image5.Picture.Height* (Form10.Image5.Height / Form10.Image5.Picture.Height)),10,0));
        end;

        Form10.Image5.Picture := Form10.Image5.Picture;
        Form10.Image5.Repaint; // Sandro Silva 2023-08-21
      end;
    except
    end;

  except
  end;
  Form10.DefinirLimiteDisponivel;
  //
  // Sandro Silva 2022-09-27 Result := True;
end;

function tForm10.AtualizaMobile(sP1: Boolean): Boolean;
var
  s, sSenha: String;

  Mais1Ini: TIniFile;
  sSecoes: TStrings;
  I, iI: Integer;
  sCNPJ: String;
  _bmp: TBitmap;
  Picture: TPicture;

  jp: TJPEGImage;
  F: TExtFile;
  Rect: tRect;
  BlobStream: TStream;
  fDesconto: Real;
begin
  try
    DownloadDoArquivo(PChar('http://www.smallsoft.com.br/2.php'),PChar('2.php'));
  except end;

  Form1.DownloadSmallMobile1Click(Form1.SincronizarSmallMobile1);

  DeleteFile(pChar(Form1.sAtual+'\estoque.sql'));
  DeleteFile(pChar(Form1.sAtual+'\clifor.sql'));
  DeleteFile(pChar(Form1.sAtual+'\usuarios.sql'));

  sCNPJ := AllTrim(LimpaNumero(Form7.ibDataSet13.FieldByname('CGC').AsString));

  try
    if sCNPJ <> '' then
    begin
      try
        //
        // estoque.sql
        //
        Form7.IBDataSet4.DisableControls;
        Form7.IBDataSet4.Close;
        Form7.IBDataSet4.SelectSQL.Clear;
        Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 order by CODIGO');
        Form7.IBDataSet4.Open;
        //
        AssignFile(F,pchar(Form1.sAtual+'\estoque.sql'));
        Rewrite(F);
        WriteLN(F,'delete from estoque where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
        //
        Form7.IBDataSet4.First;
        //
        while not Form7.IBDataSet4.Eof do
        begin
          //
          try
            //
            try
              DeleteFile(pChar(Form1.sAtual+'\tempo.bmp'));
              DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            except
            end;
            //
            if sP1 then
            begin
              //
              try
                //
                if Form7.IBDataSet4FOTO.BlobSize <> 0 then
                begin
                  //
                  BlobStream:= Form7.IBDataSet4.CreateBlobStream(Form7.IBDataSet4FOTO,bmRead);
                  jp := TJPEGImage.Create;
                  try
                    jp.LoadFromStream(BlobStream);
                    Form10.Image5.Picture.Assign(jp);
                  except
                  end;
                  //
                  BlobStream.Free;
                  jp.Free;
                  //
                  Form10.Image5.Picture.SaveToFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg');
                  //
                  // JPG para BMP
                  //
                  if FileExists(Form1.sAtual+'\_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg') then
                  begin
                    //
                    Picture := graphics.TPicture.Create;
                    _bmp    := graphics.TBitmap.Create;
                    Picture.LoadFromFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg');
                    //
                    try
                      _bmp.Assign(Picture.Graphic);
                      _bmp.SavetoFile('tempo.bmp');
                      Form1.Image1.Picture.LoadFromFile('tempo.bmp');
                    except
                    end;
                    //
                    _bmp.Free;
                    Picture.Free;
                    //
                  end;
                  //
                  if FileExists(Form1.sAtual+'\tempo.bmp') then
                  begin
                    //
                    Form1.Image1.Picture.LoadFromFile('tempo.bmp');
                    //
                    Rect.Top := 0;
                    Rect.Left := 0;
                    //
                    if Form1.Image1.Picture.Width > Form1.Image1.Picture.Height then
                    begin
                      Form1.Image1.Picture.Bitmap.Height := Form1.Image1.Picture.Bitmap.Width;
                      Rect.Right  := StrToInt(StrZero((Form1.Image1.Picture.Width   * (100 / Form1.Image1.Picture.Width)),4,0));
                      Rect.Bottom := StrToInt(StrZero((Form1.Image1.Picture.Height  * (100 / Form1.Image1.Picture.Width)),4,0));
                    end else
                    begin
                      Form1.Image1.Picture.Bitmap.Width := Form1.Image1.Picture.Bitmap.Height;
                      Rect.Right  := StrToInt(StrZero((Form1.Image1.Picture.Width   * (100 / Form1.Image1.Picture.Height)),4,0));
                      Rect.Bottom := StrToInt(StrZero((Form1.Image1.Picture.Height  * (100 / Form1.Image1.Picture.Height)),4,0));
                    end;
                    //
                    Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);
                    //
                    Form1.Image1.Picture.Bitmap.Width  := Rect.Right;
                    Form1.Image1.Picture.Bitmap.Height := Rect.Bottom;
                    //
                    try
                      jp := TJPEGImage.Create;
                      jp.Assign(Form1.Image1.Picture.Bitmap);
                      jp.CompressionQuality := 80;
                      jp.SaveToFile('_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg');
                    except
                    end;
                    //
                    jp.Free;
                    //
                  end;
                  //
                  try
                    DeleteFile(pChar(Form1.sAtual+'\tempo.bmp'));
                    DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
                  except
                  end;
                  //
                end;
                //
              except
              end;
              //
            end;
            //
            WriteLN(F,'insert into estoque (EMITENTE, CODIGO, CST, DESCRICAO, MEDIDA, PRECO, QTD_ATUAL, ST) values ('
              +QuotedStr(sCNPJ)+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('CODIGO').AsString,'''',''))+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('CST').AsString,'''',''))+', '
              +QuotedStr(ConverteAcentosPHP(Form7.IBDataSet4.FieldByname('DESCRICAO').AsString)) +', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('MEDIDA').AsString,'''',''))+', '
              +QuotedStr(StrTRan(Form7.IBDataSet4.FieldByname('PRECO').AsString,',','.'))+', '
              +QuotedStr(StrTRan(Form7.IBDataSet4.FieldByname('QTD_ATUAL').AsString,',','.'))+', '
              +QuotedStr(StrTran(Form7.IBDataSet4.FieldByname('ST').AsString,'''',''))+' ); ');
            //
          except
          end;
          //
          Form7.IBDataSet4.Next;
          //
          // Form1.Label1.Caption := Form7.IBDataSet4.FieldByname('CODIGO').AsString;
          // Form1.Label1.Repaint;
          //
        end;
        //

        //
        CloseFile(F);
        //
      except
        try
          CloseFile(F);
        except
        end;
      end;
      try
        //
        // clifor.off
        //
        Form1.IBQuery1.Close;
        Form1.IBQuery1.SQL.Clear;
        Form1.IBQuery1.SQL.Add('select * from CLIFOR');
        Form1.IBQuery1.Open;
        //
        AssignFile(F,pchar(Form1.sAtual+'\clifor.sql'));
        Rewrite(F);
        WriteLN(F,'delete from clifor where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
        Form1.ibQuery1.First;
        //
        while not Form1.ibQuery1.Eof do
        begin
          try
            if LimpaNumero(Form1.ibQuery1.FieldByname('CGC').AsString) <> '' then
            begin
              //
              if AllTrim(Form1.ibQuery1.FieldByname('CONVENIO').AsString) <> '' then
              begin
                Form7.ibDataSet29.Locate('NOME',Form1.ibQuery1.FieldByname('CONVENIO').AsString,[]);
                fDesconto := Form7.ibDataSet29DESCONTO.AsFloat;
              end else fDesconto := 0;
              //
              WriteLN(F,'insert into clifor (EMITENTE, NOME, CGC, IE, CEP, EMAIL, CIDADE, COMPLE, ENDERE, ESTADO, FONE, DESCONTO_CONVENIO) values ('
                +QuotedStr(sCNPJ)+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('NOME').AsString))+', '
                +QuotedStr(LimpaNumero(Form1.ibQuery1.FieldByname('CGC').AsString))+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('IE').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('CEP').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('EMAIL').AsString)+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('CIDADE').AsString))+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('COMPLE').AsString))+', '
                +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByname('ENDERE').AsString))+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('ESTADO').AsString)+', '
                +QuotedStr(Form1.ibQuery1.FieldByname('FONE').AsString)+','
                +QuotedStr(StrTRan(FloatToStr(fDesconto),',','.'))+' ); ');
              //
            end;
            //
          except
          end;
          //
          Form1.ibQuery1.Next;
          //
        end;
        //
        CloseFile(F);
        //
      except
        try
          CloseFile(F);
        except
        end;
      end;
      try
        //
        // usuarios.off
        //
        AssignFile(F,pchar(Form1.sAtual+'\usuarios.sql'));
        Rewrite(F);
        WriteLN(F,'delete from usuarios where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
        //
        sSecoes := TStringList.Create;
        //
        Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
        Mais1Ini.ReadSections(sSecoes);
        //
        for I := 0 to (sSecoes.Count - 1) do
        begin
          s := '';
          if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
          begin
            if AllTrim(sSecoes[I]) <> 'Administrador' then
            begin
              //
              sSenha   := Mais1Ini.ReadString(sSecoes[I],'Chave','15706143431572013809150491382314104');
              // ----------------------------- //
              // Fórmula para ler a nova senha //
              // ----------------------------- //
              for iI := 1 to (Length(sSenha) div 5) do
              begin
                s := Chr((StrToInt(
                              Copy(sSenha,(iI*5)-4,5)
                              )+((Length(sSenha) div 5)-iI+1)*7) div 137) + s;
              end;
              //
              if Mais1Ini.ReadString(sSecoes[I],'Chave','') <> '' then
              begin
                //
                WriteLN(F,'insert into usuarios (EMITENTE, NOME, SENHA, STATUS) values ('
                  +QuotedStr(sCNPJ)+', '
                  +QuotedStr(sSecoes[I])+', '
                  +QuotedStr(s)+', '
                  +QuotedStr(
                    //
                    StrTran(StrTran(StrTran(
                    Mais1Ini.ReadString(sSecoes[I],'B1','1')+  // NFCE/NFE/Orçamento
                    Mais1Ini.ReadString(sSecoes[I],'B2','1')+  // Estoque
                    Mais1Ini.ReadString(sSecoes[I],'B3','1')+  // Cadastro
                    Mais1Ini.ReadString(sSecoes[I],'B5','1')       // Caixa
                    ,'1','X'),'0','1'),'X','0') // Xoor - Inverte 0 pra um e 1 pra zero
                    )+');');
                //
              end;
              //
            end;
          end;
        end;
        //
        CloseFile(F);
        //
      except
        try
          CloseFile(F);
        except
        end;
      end;
      //
      Form7.LbBlowfish1.GenerateKey(Form1.sPasta);
      //
      // Envia os arquivos
      //
      // logo.jpg
      //
      if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
      begin
        //
        Rect.Top := 0;
        Rect.Left := 0;
        Rect.Right := 360;
        Rect.Bottom := 90;
        //
        Form1.Image1.Picture.LoadFromFile('LOGOTIP.BMP');
        Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);
        //
        Form1.Image1.Picture.Bitmap.Width  := 360;
        Form1.Image1.Picture.Bitmap.Height := 90;
        //
        jp := TJPEGImage.Create;
        jp.Assign(Form1.Image1.Picture.Bitmap);
        jp.CompressionQuality := 100;
        jp.SaveToFile('logo.jpg');
        //
      end;
      //
      if sP1 then
      begin
        //
        try
          Form7.ibDataSet4.First;
          while not Form7.ibDAtaSet4.Eof do
          begin
            if FileExists(Form1.sAtual+'\_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg') then
              UploadMobile(pChar('_m_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            DeleteFile(pChar('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'));
            Form7.ibDataSet4.Next;
          end;
        except
        end;
        //
      end;
      //
      UploadMobile(pChar('clifor.sql'));
      UploadMobile(pChar('usuarios.sql'));
      UploadMobile(pChar('estoque.sql'));
      UploadMobile(pChar('logo.jpg'));
      //
      DeleteFile(pChar(Form1.sAtual+'\usuarios.sql'));
      //
    end else
    begin
      ShowMessage('CNPJ do emitente inválido.');
    end;
    //
  except
  end;
  //
  //    DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  //    ShowMessage('Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10));
  //
  Result := True;
  //
end;

procedure GravaEscolha;
begin
  try
    // Caixa
    if Form7.sModulo = 'CAIXA' then
    begin
      Form7.ibDataSet1.Edit;
      Form7.ibDataSet1NOME.AsString := Form7.ibDataSet12NOME.AsString;     // contas bancárias
    end;

    // Contas a receber
    if Form7.sModulo = 'RECEBER' then
    begin
      Form7.ibDataSet7.Edit;

      if (Form10.dBGrid1.Visible) then
      begin
        if Form10.dBGrid1.Height = 300 then
          Form7.ibDataSet7CONTA.AsString := Form7.ibDataSet12NOME.AsString
        else
          Form7.ibDataSet7NOME.AsString  := Form7.ibDataSet2NOME.AsString;
      end;

      {Sandro Silva 2023-07-24 inicio
      // Forma De Pagamento
      if (Form10.dBGrid3.Visible) and (Form10.dBGrid3.DataSource.Name = 'DSConsulta') then
      begin
        Form7.ibDataSet7FORMADEPAGAMENTO.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;
        Form10.dBGrid3.Visible := False;
      end;

      //Mauricio Parizotto 2023-05-29
      // Instituição Financeira
      if (Form10.dBGrid3.Visible) and (Form10.dBGrid3.DataSource.Name = 'DSConsulta') then
      begin
        Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;
        Form10.dBGrid3.Visible := False;
      end;
      }
      if (Form10.dBGrid3.Visible) then
      begin
        // Forma De Pagamento
        if Form10.dBGrid3.Tag = ID_CONSULTANDO_FORMA_DE_PAGAMENTO then
          Form7.ibDataSet7FORMADEPAGAMENTO.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;

        //Mauricio Parizotto 2023-05-29
        // Instituição Financeira
        if Form10.dBGrid3.Tag = ID_CONSULTANDO_INSTITUICAO_FINANCEIRA then
          Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;

        Form10.dBGrid3.Visible := False;
      end;
    end;

    // Contas a Pagar
    if Form7.sModulo = 'PAGAR' then
    begin
      Form7.ibDataSet8.Edit;

      if Form10.dBGrid1.Height = 300 then
        Form7.ibDataSet8CONTA.AsString := Form7.ibDataSet12NOME.AsString
      else
        Form7.ibDataSet8NOME.AsString  := Form7.ibDataSet2NOME.AsString;
    end;

    // Estoque, Nota Fiscal de venda ou compra quando cadastra um produto novo pelo formulário
    if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
    begin
      // Medida
      if Form10.dBGrid3.Height = 260 then
      begin
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4MEDIDA.AsString := Form7.ibDataSet49SIGLA.AsString;
        Form7.ibDataSet4.Post;
      end;

      // Grupos
      if Form10.dBGrid1.Height = 145 then
      begin
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4NOME.AsString := Form7.ibDataSet21NOME.AsString;
        Form7.ibDataSet4.Post;
      end;
    end;

    if Form7.sModulo = 'CLIENTES' then
    begin
      Form7.ibDataSet2.Edit;
      if Form10.dBGrid3.Height = 260 then
      begin
        Form7.ibDataSet2CIDADE.AsString := Form7.ibDataSet39NOME.AsString;  
      end else
      begin
        Form7.ibDataSet2CONVENIO.AsString := Form7.ibDataSet29NOME.AsString;
      end;

      Form7.dBGrid3.Visible := False;
    end;

    //Mauricio Parizotto 2023-05-16
    if Form7.sModulo = 'TRANSPORT' then
    begin
      Form7.ibDataSet18.Edit;
      if Form10.dBGrid3.Height = 260 then
      begin
        Form7.ibDataSet18MUNICIPIO.AsString := Form7.ibDataSet39NOME.AsString;
      end;

      Form7.dBGrid3.Visible := False;
    end;

    //Mauricio Parizotto 2023-06-16
    if Form7.sModulo = '2CONTAS' then
    begin
      Form7.ibDataSet11.Edit;

      // Instituição Financeira
      if (Form10.dBGrid3.Visible) and (Form10.dBGrid3.DataSource.Name = 'DSConsulta') then
      begin
        Form7.ibDataSet11INSTITUICAOFINANCEIRA.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;
        Form10.dBGrid3.Visible := False;
      end;
    end;

    {Sandro Silva 2023-06-28 inicio}
    // Contas a receber
    if Form7.sModulo = 'ICM' then
    begin
      Form7.ibDataSet14.Edit;

      if (Form10.dBGrid3.Visible) and (Form10.dBGrid3.DataSource.Name = 'DSConsulta') then
      begin
        Form7.ibDataSet14CONTA.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;
        Form10.dBGrid3.Visible := False;
      end;
    end;
    {Sandro Silva 2023-06-28 fim}
  except
  end;
end;


procedure TForm10.Image204Click(Sender: TObject);
begin
  try
    Form7.ArquivoAberto.MoveBy(-1);
  except
  end;  

  AtualizaObjComValorDoBanco; // Sandro Silva 2023-06-28
    
  try
    Form7.IBTransaction1.CommitRetaining;
    VerificaSeEstaSendoUsado(False);
    Form10.FormShow(Sender);
    Form10.FormActivate(Sender);
    if ((Form7.ArquivoAberto.eof) or (bNovo)) then
      Form10.Image201Click(Sender)
    else
      bNovo := False;

  except
  end;

  MostraImagemEstoque
  
end;

procedure TForm10.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    bGravaEscolha := False;

    if Form7.bFlag = True then
    begin
      if Key = VK_RETURN then
      begin
        bGravaEscolha := True;
        Perform(Wm_NextDlgCtl,0,0);
      end;
      
      if dBgrid1.Visible then
      begin
        if (Key = VK_UP) or (Key = VK_DOWN) then
        begin
          if dBgrid1.CanFocus then
            dBgrid1.SetFocus;
        end;
      end else
      begin
        if dBGrid3.Visible then
        begin
          if (Key = VK_UP) or (Key = VK_DOWN) then
          begin
            if dBgrid3.CanFocus then
              dBgrid3.SetFocus;
          end else
          begin
            if Key = VK_UP then
              Perform(Wm_NextDlgCtl,1,0);
            if Key = VK_DOWN then
              Perform(Wm_NextDlgCtl,0,0);
          end;
        end;
      end;
    end
    else
      Form7.bFlag := True;
  except
    ShowMessage('Erro 10/6 comunique o suporte técnico.')
  end;
end;

procedure TForm10.SMALL_DBEdit1Enter(Sender: TObject);
var
  vDataField : string;
begin
  //Mauricio Parizotto 2023-05-29
  bGravaEscolha := False;
  
  dBGrid3.Tag := 0;

  dBGrid3.Visible := False;

  dBGrid3.Parent := TSMALL_DBEdit(Sender).Parent; // Sandro Silva 2023-06-28

  try
    if (Form7.sModulo = 'CAIXA') then
    begin
      SMALL_DBEdit1.SelStart  := 0;
      SMALL_DBEdit1.SelLength := 2;
    end;
 
    with Sender as TSMALL_DBEdit do
    begin
      dBgrid3.Columns.Items[0].FieldName := 'NOME';
      dBgrid3.Columns.Items[0].Width     := 204;

      vDataField := DataField;

      dBGrid1.Visible := False;
      if (vDataField = 'NOME') and
                       (
                        (Form7.sModulo = 'CAIXA') or
                        (Form7.sModulo = 'RECEBER') or
                        (Form7.sModulo = 'PAGAR') or
                        (Form7.sModulo = 'VENDA') or
                        (Form7.sModulo = 'COMPRA') or
                        (Form7.sModulo = 'ESTOQUE')
                       ) then
        dBGrid1.Visible := True;

      if ((vDataField = 'CONTA') and (Form7.sModulo = 'RECEBER')) or ((vDataField = 'CONTA') and (Form7.sModulo = 'PAGAR')) then
      begin
        dBGrid1.Visible    := True;
        dBGrid1.Top        := Top + 19;
        dBGrid1.Left       := Left;
        dBGrid1.Height     := 300;
        dBGrid1.Width      := Width;
        dBGrid1.Font       := Font;
        dBGrid1.DataSource := Form7.DataSource12; // Convênios
      end;
 
      if ((vDataField = 'NOME') and (Form7.sModulo = 'RECEBER'))
        or ((vDataField = 'NOME') and (Form7.sModulo = 'PAGAR'  )) then
      begin
        dBGrid1.Visible    := True;
        dBGrid1.Top        := Top + 19;
        dBGrid1.Left       := Left;
        dBGrid1.Height     := 200;
        dBGrid1.Width      := Width;
        dBGrid1.Font       := Font;
        dBGrid1.DataSource := Form7.DataSource2; // Clifor
      end;
 
      dBgrid3.Columns.Items[1].Visible   := False;
 
      if (vDataField = 'CONVENIO') and (Form7.sModulo = 'CLIENTES') then
      begin
        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 200;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DataSource29; // Convênios
      end;

      if vDataField = 'CIDADE' then
      begin
        if Length(AllTrim(Form7.IBDataSet2ESTADO.AsString)) <> 2 then
        begin
          Form7.IBDataSet39.Close;
          Form7.IBDataSet39.SelectSQL.Clear;
          Form7.IBDataSet39.SelectSQL.Add('select * from MUNICIPIOS order by NOME'); // Procura em todo o Pais o estado está em branco
          Form7.IBDataSet39.Open;
        end else
        begin
          Form7.IBDataSet39.Close;
          Form7.IBDataSet39.SelectSQL.Clear;
          Form7.IBDataSet39.SelectSQL.Add('select * from MUNICIPIOS where UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString)+ ' order by NOME'); // Procura dentro do estado
          Form7.IBDataSet39.Open;
        end;

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 260;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DataSource39; // Municipios
      end;

      if (vDataField = 'MEDIDA') then
      begin
        Form7.IBDataSet49.Close;
        Form7.IBDataSet49.SelectSQL.Clear;
        Form7.IBDataSet49.SelectSQL.Add('select * from MEDIDA order by SIGLA');
        Form7.IBDataSet49.Open;

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 260;
        dBGrid3.Width      := Width+300;

        dBgrid3.Columns.Items[0].FieldName := 'SIGLA';
        dBgrid3.Columns.Items[0].Width     := 30;

        dBgrid3.Columns.Items[1].FieldName := 'DESCRICAO';
        dBgrid3.Columns.Items[1].Width     := 100;
        dBgrid3.Columns.Items[1].Visible   := True;

        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DataSource49; // Medida
      end;

      if Form7.sModulo = 'CLIENTES' then
      begin
        pnRelacaoComercial.Visible := True;
        pnRelacaoComercial.Top     := Form10.DBMemo2.Top + Form10.DBMemo2.Height + 5;
        pnRelacaoComercial.Left    := Form10.Label23.Left;
      end
      else
        pnRelacaoComercial.Visible := False;

      //Mauricio Parizotto 2023-05-03
      if (vDataField = 'MUNICIPIO') and (Form7.sModulo = 'TRANSPORT') then
      begin
        if Length(AllTrim(Form7.ibDataSet18UF.AsString)) <> 2 then
        begin
          // Procura em todo o Pais o estado está em branco
          Form7.IBDataSet39.Close;
          Form7.IBDataSet39.SelectSQL.Text := ' Select * from MUNICIPIOS order by NOME';
          Form7.IBDataSet39.Open;
        end else
        begin
          // Procura dentro do estado
          Form7.IBDataSet39.Close;
          Form7.IBDataSet39.SelectSQL.Text := ' Select * '+
                                              ' From MUNICIPIOS'+
                                              ' Where UF='+QuotedStr(Form7.ibDataSet18UF.AsString)+
                                              ' Order by NOME';
          Form7.IBDataSet39.Open;
        end;

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 260;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DataSource39; // Municipios
      end;

      {Sandro Silva 2023-06-22 inicio}
      if (vDataField = 'FORMADEPAGAMENTO') and (Form7.sModulo = 'RECEBER') then
      begin
        // Procura
        Form7.ibqConsulta.Close;
        Form7.ibqConsulta.SelectSQL.Text := SELECT_TABELA_VIRTUAL_FORMAS_DE_PAGAMENTO;
        Form7.ibqConsulta.Open;

        Form7.ibqConsulta.Locate('NOME', Trim(Text), [loCaseInsensitive, loPartialKey]);

        dBGrid3.Tag        := ID_CONSULTANDO_FORMA_DE_PAGAMENTO;
        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 100;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DSConsulta;
        dBGrid3.Columns[0].Width := 310;
      end;
      {Sandro Silva 2023-06-22 fim}

      //Mauricio Parizotto 2023-05-29
      if (vDataField = 'INSTITUICAOFINANCEIRA') and (Form7.sModulo = 'RECEBER') then
      begin
        // Procura
        Form7.ibqConsulta.Close;
        Form7.ibqConsulta.SelectSQL.Text := ' Select * '+
                                            ' From CLIFOR'+
                                            ' Where CLIFOR in (''Instituição financeira'',''Credenciadora de cartão'') '+
                                            ' Order by NOME';
        Form7.ibqConsulta.Open;

        Form7.ibqConsulta.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);

        dBGrid3.Tag        := ID_CONSULTANDO_INSTITUICAO_FINANCEIRA;
        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top - 100;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 100;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DSConsulta;
        dBGrid3.Columns[0].Width := 310;
      end;

      //Mauricio Parizotto 2023-06-16
      if (vDataField = 'INSTITUICAOFINANCEIRA') and (Form7.sModulo = '2CONTAS') then
      begin
        // Procura
        Form7.ibqConsulta.Close;
        Form7.ibqConsulta.SelectSQL.Text := ' Select * '+
                                            ' From CLIFOR'+
                                            ' Where CLIFOR = ''Instituição financeira'' '+
                                            ' Order by NOME';
        Form7.ibqConsulta.Open;

        Form7.ibqConsulta.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 100;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DSConsulta;
        dBGrid3.Columns[0].Width := 310;
      end;

      {Sandro Silva 2023-06-21 inicio}
      if (vDataField = 'FORMADEPAGAMENTO') and (Form7.sModulo = 'RECEBER') then
      begin
        // Procura
        Form7.ibqConsulta.Close;
        Form7.ibqConsulta.SelectSQL.Text := SELECT_TABELA_VIRTUAL_FORMAS_DE_PAGAMENTO;
        Form7.ibqConsulta.Open;

        Form7.ibqConsulta.Locate('NOME', Trim(Text), [loCaseInsensitive, loPartialKey]);

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 100;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DSConsulta;
        dBgrid3.Columns.Items[0].FieldName := 'NOME';        
        dBGrid3.Columns[0].Width := 310;
      end;
      {Sandro Silva 2023-06-21 fim}
      {Sandro Silva 2023-06-28 inicio}
      if (vDataField = 'CONTA') and (Form7.sModulo = 'ICM') then
      begin
        // Procura
        Form7.ibqConsulta.Close;
        Form7.ibqConsulta.SelectSQL.Text :=
          ' Select * '+
          ' From CONTAS'+
          ' Order by CONTA';
        Form7.ibqConsulta.Open;

        Form7.ibqConsulta.Locate('NOME', Trim(Text), [loCaseInsensitive, loPartialKey]);

        dBgrid3.Columns.Items[0].FieldName := 'CONTA';
        dBgrid3.Columns.Items[0].Width     := 40;

        dBgrid3.Columns.Items[1].FieldName := 'NOME';
        dBgrid3.Columns.Items[1].Width     := 245;
        dBgrid3.Columns.Items[1].Visible   := True;

        dBGrid3.Visible    := True;
        dBGrid3.Top        := Top + 19;
        dBGrid3.Left       := Left;
        dBGrid3.Height     := 100;
        dBGrid3.Width      := Width;
        dBGrid3.Font       := Font;
        dBGrid3.DataSource := Form7.DSConsulta;
        //dBGrid3.Columns[0].Width := 310;
      end;

      if (vDataField = 'CFOP') and (Form7.sModulo = 'ICM') then
        TSMALL_DBEdit(Sender).SelStart := 1;
      {Sandro Silva 2023-06-28 fim}

    end;
  except
    ShowMessage('Erro 10/77 comunique o suporte técnico.')
  end;
end;

procedure TForm10.SMALL_DBEdit1Exi(Sender: TObject);
begin

  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') then
    sNomeDoArquivoParaSalvar := 'contatos\'+AllTrim(LimpaLetrasPor_(Form7.ibDataSet2NOME.AsString))+'.txt'; // Lendo o arquivo para mostrar na tela

  try
    sText := '';

    with Sender as TSMALL_DBEdit do
    begin
      if (Form7.sModulo = 'ESTOQUE') and (Datafield = 'DESCRICAO') and (Form7.ibDataSet4DESCRICAO.AsString = '') then
      begin
        if SMALL_DBEdit5.Focused then
        begin
          ShowMessage('Descrição inválida.');
          SMALL_DBEdit3.SetFocus;
          Abort;
        end;
      end;

      if ((DataField = 'NOME') or (DataField = 'CREDITO')) then
        DefinirLimiteDisponivel;

      if ((DataField = 'NOME') or (DataField = 'CONTA') or (DataField = 'CIDADE') or (DataField = 'CONVENIO')) and
       ((Form7.sModulo = 'CAIXA' ) or
        (Form7.sModulo = 'RECEBER') or
         (Form7.sModulo = 'PAGAR') or
          (Form7.sModulo = 'VENDA') or
           (Form7.sModulo = 'COMPRA') or
            (Form7.sModulo = 'CLIENTES') or
             (Form7.sModulo = 'ESTOQUE')
              //(Form7.sModulo = 'ICM')
             ) then
      begin
 
        // Caixa
        if ((DataField = 'NOME')  and (Form7.sModulo = 'CAIXA'  ))
        or ((DataField = 'CONTA') and (Form7.sModulo = 'RECEBER'))
        or ((DataField = 'CONTA') and (Form7.sModulo = 'PAGAR')) then
        begin
          // Procura pela conta //
          try
            if (LengTh(AllTrim(Text)) <= 5) and (LengTh(AllTrim(Text)) >1) then
            begin
              if StrToInt(Text) <> 0 then
              begin
                if Form7.ibDataSet12CONTA.AsString = AllTrim(Text) then

                if Form7.sModulo = 'CAIXA' then
                  Form7.ibDataSet1NOME.AsString := form7.ibDataSet12NOME.AsString
                else
                  Form7.ibDataSet7CONTA.AsString := form7.ibDataSet12NOME.AsString;


              end;
            end;
         except end;
        end;
  
        sText := AllTrim(Text);
  
        if sText <> '' then
        begin
          tProcura := Form7.ibDataSet12;
          if Form7.sModulo = 'CAIXA' then
            tProcura := Form7.ibDataSet12;
  
          if (Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR') then
          begin
            if DataField = 'NOME' then
              tProcura := Form7.ibDataSet2
            else
              tProcura := Form7.ibDataSet12;
          end;
  
          if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
            tProcura := Form7.ibDataSet21;
  
          if bGravaEscolha then
          begin
            if Pos(AnsiUpperCase(sText), AnsiUpperCase(AllTrim(tProcura.FieldByName('NOME').AsString))) <> 0 then
              GravaEscolha
            else
            begin
              if (Form7.sModulo <> 'CLIENTES') then
              begin
                Text := '';
                Abort;
              end;
            end;
          end;
        end;
      end;

      {Sandro Silva 2023-06-22 inicio}
      if (DataField = 'FORMADEPAGAMENTO') and (Form7.sModulo = 'RECEBER') and (bGravaEscolha) then
      begin
        if Pos(AnsiUpperCase(Text), AnsiUpperCase(Trim(Form7.ibqConsulta.FieldByName('NOME').AsString))) <> 0 then
        begin
          GravaEscolha;
        end else
        begin
          DataSource.DataSet.Edit;
          DataSource.DataSet.FieldByName(DataField).AsString := '';
          Form10.dBGrid3.Visible := False;
          Exit;
        end;
      end;
      {Sandro Silva 2023-06-22 fim}
      
      
      {Mauricio Parizotto 2023-05-29 Inicio}
      if (DataField = 'INSTITUICAOFINANCEIRA') and (Form7.sModulo = 'RECEBER') and (bGravaEscolha) then
      begin
        if Pos(AnsiUpperCase(Text), AnsiUpperCase(AllTrim(Form7.ibqConsulta.FieldByName('NOME').AsString))) <> 0 then
        begin
          GravaEscolha;
        end else
        begin
          DataSource.DataSet.Edit;
          DataSource.DataSet.FieldByName(DataField).AsString := '';
          Form10.dBGrid3.Visible := False;
          Exit;
        end;
      end;
      {Mauricio Parizotto 2023-05-29 Inicio}

      {Mauricio Parizotto 2023-06-16 Inicio}
      if (DataField = 'INSTITUICAOFINANCEIRA') and (Form7.sModulo = '2CONTAS') and (bGravaEscolha) then
      begin
        if Pos(AnsiUpperCase(Text), AnsiUpperCase(AllTrim(Form7.ibqConsulta.FieldByName('NOME').AsString))) <> 0 then
        begin
          GravaEscolha;
        end else
        begin
          DataSource.DataSet.Edit;
          DataSource.DataSet.FieldByName(DataField).AsString := '';
          Form10.dBGrid3.Visible := False;

          Exit;
        end;
      end;
      {Mauricio Parizotto 2023-06-16 Inicio}

      {Sandro Silva 2023-06-28 inicio}
      if (DataField = 'CONTA') and (Form7.sModulo = 'ICM') and (bGravaEscolha) then
      begin
        if Pos(AnsiUpperCase(Text), AnsiUpperCase(AllTrim(Form7.ibqConsulta.FieldByName('NOME').AsString))) <> 0 then
        begin
          GravaEscolha;
        end else
        begin
          DataSource.DataSet.Edit;
          DataSource.DataSet.FieldByName(DataField).AsString := '';
          Form10.dBGrid3.Visible := False;

          Exit;
        end;
      end;
      if (DataField = 'CFOP') and (Form7.sModulo = 'ICM')then
        DataSource.DataSet.FieldByName(DataField).AsString := Trim(TSMALL_DBEdit(Sender).Text);
      {Sandro Silva 2023-06-28 fim}

      {Dailon (f-7224) 2023-08-22 inicio}
      if Form7.sModulo = 'CLIENTES' then
      begin
        if ((DataField = 'ENDERE')
            or (DataField = 'COMPLE')
            or (DataField = 'EMAIL')) then
        begin
          if (Copy(TSMALL_DBEdit(Sender).Text,1,1) = ' ') then
          begin
            if not (TSMALL_DBEdit(Sender).Field.DataSet.State in [dsEdit, dsInsert]) then
            begin
              TSMALL_DBEdit(Sender).Field.DataSet.Edit;
              TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
              TSMALL_DBEdit(Sender).Field.DataSet.Post;
            end else
              TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);            
          end;
        end;
      end;
      {Dailon (f-7224) 2023-08-22 fim}
    end;
  except
  end;
end;

procedure TForm10.DBGrid1CellClick(Column: TColumn);
begin
  GravaEscolha(); // Ok
end;

procedure TForm10.DBGrid1DblClick(Sender: TObject);
begin
  GravaEscolha(); // Ok
  if Form7.sModulo = 'CAIXA'   then
  begin
  	if SMALL_DBEdit3.CanFocus then
  		SMALL_DBEdit3.SetFocus;
  end;

  if Form7.sModulo = 'RECEBER' then
  begin
    if (dBGrid1.DataSource.Name = 'DataSource12')  then
    begin
      if SMALL_DBEdit3.CanFocus then
        SMALL_DBEdit3.SetFocus;
    end;

    if (dBGrid1.DataSource.Name = 'DataSource2') then
    begin
      if SMALL_DBEdit5.CanFocus then
        SMALL_DBEdit5.SetFocus;
    end;

  end;

  if Form7.sModulo = 'PAGAR'   then
  begin
    if (dBGrid1.DataSource.Name = 'DataSource12')  then
      if SMALL_DBEdit3.CanFocus  then
        SMALL_DBEdit3.SetFocus;
    if (dBGrid1.DataSource.Name = 'DataSource2') then
      if SMALL_DBEdit5.CanFocus  then
        SMALL_DBEdit5.SetFocus;
  end;

  if Form7.sModulo = 'ESTOQUE' then
  begin
    if SMALL_DBEdit6.CanFocus then
      SMALL_DBEdit6.SetFocus;
  end;

  {Sandro Silva 2023-06-28 inicio}
  if Form7.sModulo = 'ICM' then
  begin
    if (dBGrid1.DataSource.Name = 'DataSource2') then
      if SMALL_DBEdit56.CanFocus then
        SMALL_DBEdit56.SetFocus;
  end;
  {Sandro Silva 2023-06-28 fim}

  dBGrid1.Visible := False;
end;

procedure TForm10.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    Form10.DBGrid1DblClick(Sender);
  end;
end;

procedure TForm10.SMALL_DBEdit1Change(Sender: TObject);
var
  vDataField : string;
begin
  try
    if Form10.Visible then
    begin
      with Sender as TSMALL_DBEdit do
      begin
        vDataField := DataField;

        if (vDataField = 'CONTA')
          and ((Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR'))
          and (Form7.ibDataSet12.Active) then
        begin
          Form7.ibDataSet12.Locate('NOME', Trim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        if (vDataField = 'CONVENIO')
          and (Form7.sModulo = 'CLIENTES')
          and (Form7.ibDataSet29.Active) then
        begin
          Form7.ibDataSet29.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        if (vDataField = 'CIDADE')
          and (Form7.sModulo = 'CLIENTES')
          and (Form7.ibDataSet39.Active) then
        begin
          Form7.ibDataSet39.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        //Mauricio Parizotto
        if (vDataField = 'MUNICIPIO')
          and (Form7.sModulo = 'TRANSPORT')
          and (Form7.ibDataSet39.Active) then
        begin
          Form7.ibDataSet39.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        if (Form7.sModulo = 'CAIXA')
          and (vDataField = 'NOME')
          and (Form7.ibDataSet12.Active) then
        begin
          Form7.ibDataSet12.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        if (Form7.sModulo = 'PAGAR')
          and (vDataField = 'NOME')
          and (Form7.ibDataSet2.Active ) then
        begin
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like ' + QuotedStr('%' + UpperCase(Text) + '%') + ' and coalesce(ATIVO,0)=0 order by NOME');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;
        end;

        if (Form7.sModulo = 'RECEBER')
          and (vDataField = 'NOME')
          and (Form7.ibDataSet2.Active ) then
        begin
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(Text)+'%')+' and coalesce(ATIVO,0)=0 order by NOME');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;
        end;

        {Sandro Silva 2023-06-22 inicio}
        if (vDataField = 'FORMADEPAGAMENTO')
          and (Form7.sModulo = 'RECEBER')
          and (Form7.ibqConsulta.Active) then
        begin
          Form7.ibqConsulta.Locate('NOME', Trim(Text), [loCaseInsensitive, loPartialKey]);
        end;
        {Sandro Silva 2023-06-22 fim}

        //Mauricio Parizotto 2023-05-29
        if (vDataField = 'INSTITUICAOFINANCEIRA')
          and (Form7.sModulo = 'RECEBER')
          and (Form7.ibqConsulta.Active) then
        begin
          Form7.ibqConsulta.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        //Mauricio Parizotto 2023-06-16
        if (vDataField = 'INSTITUICAOFINANCEIRA')
          and (Form7.sModulo = '2CONTAS')
          and (Form7.ibqConsulta.Active) then
        begin
          Form7.ibqConsulta.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        {Sandro Silva 2023-06-28 inicio}
        if (vDataField = 'CONTA')
          and (Form7.sModulo = 'ICM')
          and (Form7.ibqConsulta.Active) then
        begin
          if Trim(TSMALL_DBEdit(Sender).Text) <> '' then
            Form7.ibqConsulta.Locate('NOME', Trim(Text), [loCaseInsensitive, loPartialKey]);
        end;
        {Sandro Silva 2023-06-28 fim}

        if (Form7.sModulo = 'ESTOQUE')
          and (vDataField = 'NOME')
          and (Form7.ibDataSet21.Active) then
        begin
          Form7.ibDataSet21.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;

        if (Form7.sModulo = 'ESTOQUE')
          and (vDataField = 'MEDIDA')
          and (Form7.ibDataSet49.Active) then
        begin
          Form7.IBDataSet49.Locate('SIGLA',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
        end;
      end;
    end;
  except end;

  if (Form7.sModulo = 'ESTOQUE') and (Form10.orelhas.ActivePage = Orelha_promo) then
    AtualizaTela(False);
end;

procedure TForm10.DefinirLimiteDisponivel;
var
  nValor: Currency;
begin
  eLimiteCredDisponivel.Text := EmptyStr;
  if not Self.Showing then
    Exit;
  
  if (Form7.sModulo = 'CLIENTES') and (Form7.IBDataSet2CREDITO.AsCurrency > 0) then
  begin
    nValor := TRetornaLimiteDisponivel.New
                                      .SetDatabase(Form7.IBDatabase1)
                                      .SetCliente(Form7.IBDataSet2NOME.AsString)
                                      .setLimiteCredito(Form7.IBDataSet2CREDITO.AsCurrency)
                                      .CarregarDados
                                      .RetornarValor;



    eLimiteCredDisponivel.Text := FormatFloat(',0.00', nValor);
  end;
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I : Integer;
  vRegistro : string;
begin
  framePesquisaProdComposicao.Visible := False;
  framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.Close;
  try
    for I := 0 to 29 do
    begin
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).DataSource := nil;
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).DataField  := '';
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).Visible    := False;
      TLAbel(Form10.Components[I+Label1.ComponentIndex]).Visible := False;
    end;
  except
  end;
  
  if Form7.sModulo <> 'ICM' then
  begin
    Orelhas.ActivePage := Orelha_cadastro;
  end else
  begin
    Orelhas.ActivePage := Orelha_CFOP;
  end;

  Form10.DBMemo1.Visible := False;
  Form10.DBMemo2.Visible := False;
  
  sRegistroVolta := Form7.ArquivoAberto.FieldByname('REGISTRO').AsString;
  
  if Form7.Visible then
  begin
    if Form7.DBGrid1.CanFocus then Form7.DBGrid1.SetFocus;
  end;
  
  Form10.Hide;
  GravaRegistro(True);

  //Mauricio Parizotto 2023-05-31
  if Form7.sModulo = 'RECEBER' then
  begin
    //Fas refresh do grid e volta para o registro atual
    try
      vRegistro := Form7.ibDataSet7REGISTRO.AsString;
      Form7.ibDataSet7.DisableControls;
      Form7.ibDataSet7.Close;
      Form7.ibDataSet7.Open;
      Form7.ibDataSet7.Locate('REGISTRO',vRegistro,[]);
    except
    end;

    Form7.ibDataSet7.EnableControls;
  end;
end;

procedure TForm10.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then
    Key := 0;
end;

procedure TForm10.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rQtd : Real;
  I, J : Integer;
begin
  rQtd := 0;
  
  for I := 0 to 19 do
    for J := 0 to 19 do
      if AllTrim(Form10.StringGrid1.Cells[I,J]) <> '' then
        try
          if (I <> 0) and (J <> 0) then
            rQtd := rQtd + StrToFloat(AllTrim(LimpaNumeroDeixandoAVirgula(Form10.StringGrid1.Cells[I,J])));
        except
          Form10.StringGrid1.Cells[I,J] := '0,00'
        end;

  Label39.Caption := 'Diferença: '+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat - rQtd]);

  try
    if StringGrid1.Cells[aCol,aRow] <> '' then
    begin
      if (aCol <> 0) and (aRow <> 0) then
      begin
        if StringGrid1.Cells[aCol,aRow] <> Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))]) then
        begin
          StringGrid1.Cells[aCol,aRow] := Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))]);
        end;
      end;
    end;
  except StringGrid1.Cells[aCol,aRow] := '' end;
  
  if ACol = 0 then
    StringGrid1.Canvas.Font.Color := clREd
    else
      if ARow = 0 then
        StringGrid1.Canvas.Font.Color := clBlue
          else StringGrid1.Canvas.Font.Color := clBlack;

  StringGrid1.Canvas.FillRect(Rect);


  if ARow = 0 then
    StringGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2, Form10.StringGrid1.Cells[aCol,aRow])
  else
    StringGrid1.Canvas.TextOut(Rect.Right - StringGrid1.Canvas.TextWidth(Form10.StringGrid1.Cells[aCol,aRow]) -2 ,Rect.Top+2,  Form10.StringGrid1.Cells[aCol,aRow]);
end;

procedure TForm10.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  try
    if Key = chr(13) then
    begin
      try
        StringGrid1.Col := StringGrid1.Col + 1;
      except
      end;
      if (StringGrid1.Row <> 0) and (StringGrid1.Cells[StringGrid1.Col,0] = '') then
      begin
        StringGrid1.Row := StringGrid1.Row + 1;
        StringGrid1.Col := 0;
      end;
    end;
  except end;
end;

procedure TForm10.StringGrid1Click(Sender: TObject);
var
  i, iColunas, iLinhas: Integer;
begin
  if (StringGrid1.Col = 0) and (StringGrid1.Row = 0) then
    StringGrid1.Row := 1;
  
  if (StringGrid1.Col <> 0) and (StringGrid1.Row <> 0) then
  begin
    iColunas := 0;
    iLinhas  := 0;
    for I := 0 to 20 do if AllTrim(StringGrid1.Cells[I,0]) <> '' then
      iColunas := I;
    for I := 0 to 20 do if AllTrim(StringGrid1.Cells[0,I]) <> '' then
      iLinhas  := I;
    if StringGrid1.Col > iColunas then StringGrid1.Col :=
      iColunas;
    if StringGrid1.Row > iLinhas  then StringGrid1.Row :=
      iLinhas;
  end;
end;

procedure TForm10.dbgComposicaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sCodigo: String;
  oTestaProd: ITestaProdutoExiste;
begin
  try
    if ((Key = VK_DOWN) or (Key = VK_UP)) and (framePesquisaProdComposicao.dbgItensPesq.CanFocus) then
    begin
      Key := VK_SHIFT;
      framePesquisaProdComposicao.dbgItensPesq.SetFocus;
    end;
    if Key = VK_F1     then
      HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('composto.htm')));
    if Key = VK_DOWN   then
    begin
      if dbgComposicao.CanFocus then
        dbgComposicao.SetFocus;
    end;
    if Key = VK_ESCAPE then
      begin
      Key := VK_RETURN;
      framePesquisaProdComposicao.Visible := False;
    end;
    if (Key = VK_RETURN) or (Key = VK_TAB) or (Key = VK_DOWN) or (Key = VK_UP) then
    begin
      Form7.ibDataSet28.Edit;
      Form7.ibDataSet28.UpdateRecord;

      if Alltrim(Form7.ibDataSet28DESCRICAO.AsString) <> EmptyStr then
      begin
        if DbGrid1.SelectedIndex = 0 then
        begin
          sCodigo := Form7.ibDataSet4CODIGO.AsString;
          oTestaProd := TTestaProdutoExiste.New
                                           .setDataBase(Form7.IBDatabase1)
                                           .setTextoPesquisar(Form7.ibDataSet28DESCRICAO.AsString);

          if oTestaProd.Testar then
          begin
            Form7.ibDataSet28.Edit;
            if oTestaProd.getQuery.FieldByname('CODIGO').AsString <> sCodigo then
            begin
              Form7.ibDataSet28.FieldByName('DESCRICAO').AsString := oTestaProd.getQuery.FieldByname('DESCRICAO').AsString;
              if Form7.ibDataSet28.FieldByName('QUANTIDADE').AsFloat <= 0 then
                Form7.ibDataSet28.FieldByName('QUANTIDADE').AsFloat := 1;
              Form7.ibDataSet28.Post;
              Form7.ibDataSet28.Edit;
            end else
            begin
              Form7.ibDataSet28.FieldByName('DESCRICAO').AsString  := EmptyStr;
              Form7.ibDataSet28.FieldByName('QUANTIDADE').AsString := EmptyStr;
              ShowMessage('Você esta tentando criar uma referência circular. Esta composição não'+Chr(10)+'pode ser feita'+ chr(10)+ chr(10)+oTestaProd.getQuery.FieldByname('CODIGO').AsString +chr(10)+ sCodigo);
            end;
          end else
          begin
            Form7.ibDataSet28.FieldByName('DESCRICAO').AsString := EmptyStr;
            ShowMessage('Produto não cadastrado.');
          end;

          dbgComposicao.Update;
        end;
      end;
      Self.orelha_composicaoShow(Sender);
    end;
    DefinirVisibleConsultaProdComposicao;
  except
  end;
end;

procedure TForm10.Button8Click(Sender: TObject);
var
  sCodigo: String;
  F: TextFile;
begin
  if Button8.CanFocus then
  begin
    Button8.SetFocus;
    if Form7.ibDataSet25ACUMULADO1.AsFloat <= fQuantidade then
    begin      
      Form7.bFabrica := True;
      
      sCodigo := Form7.ibDataSet4CODIGO.AsString;
      
      Form7.ibDataSet4.DisableControls;
      
      Form7.IBDataSet4.Close;
      Form7.IBDataSet4.SelectSQL.Clear;
      Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE');
      Form7.IBDataSet4.Open;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      Form7.ibDataSet4.EnableControls;
      
      Form7.ibDataSet28.First;
      while not Form7.ibDataSet28.Eof do
      begin
        Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);
        
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat - (Form7.ibDataSet28QUANTIDADE.AsFloat * Form7.ibDataSet25ACUMULADO1.AsFloat );
        Form7.ibDataSet4.Post;
        
        Form7.ibDataSet28.Next;        
      end;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet25ACUMULADO1.AsFloat;
      
      if Form1.bHtml1 then
      begin
        AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);
        Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - '+Form7.sModulo+'</title></head>');
        WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
        WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
        WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font><p><p>');
        
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=3><b>ORDEM DE PRODUÇÃO</b>');
        Writeln(F,'<br>');
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>FABRICAR '+FloatToStr(Form7.ibDataSet25ACUMULADO1.AsFloat)+ ' ' +UpperCase(Form7.ibDataSet4DESCRICAO.AsSTring)+'</b>');
        Writeln(F,'<br>');
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>COMPOSIÇÃO DO PRODUTO</b>');
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Código</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Qtd X '+FloatToStr(Form7.ibDataSet25ACUMULADO1.AsFloat)+'</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet28.First;
        while not Form7.ibDataSet28.Eof do
        begin
          Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);

          if  Form7.ibDataSet4DESCRICAO.AsString = Form7.ibDataSet28DESCRICAO.AsString then
          begin
            WriteLn(F,' <tr>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet28DESCRICAO.AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat*Form7.ibDataSet25ACUMULADO1.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
          end;
          
          Form7.ibDataSet28.Next;
        end;
        
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        WriteLn(F,'<br>');
        WriteLn(F,'</center><center><br><font face="Microsoft Sans Serif" size=1></b>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
        + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
        + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');
        
        // WWW
        
        if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
        begin
          WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
        end else
        begin
          WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
        end;
        
        if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
        WriteLn(F,'</html>');
        
        CloseFile(F);
        
        AbreArquivoNoFormatoCerto(pChar(Senhas.UsuarioPub+'.HTM'));        
      end else
      begin
        Form7.ibDataSet28.First;
        if Form7.ibDataSet28CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
        begin
          AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
          Rewrite(F);                   //
          Writeln(F,'ORDEM DE PRODUÇÃO');
          Writeln(F,'');
          Writeln(F,'FABRICAR '+FloatToStr(Form7.ibDataSet25ACUMULADO1.AsFloat)+ ' ' +UpperCase(Form7.ibDataSet4DESCRICAO.AsSTring));
          Writeln(F,'');
          Writeln(F,'COMPOSIÇÃO DO PRODUTO');
          Writeln(F,'');
          Writeln(F,'Cód   Descrição                               Qtd        Qtd X '+FloatToStr(Form7.ibDataSet25ACUMULADO1.AsFloat));
          Writeln(F,'----- --------------------------------------- ---------- --------------');
          
          Form7.ibDataSet28.First;
          while not Form7.ibDataSet28.Eof do
          begin
            
            Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);
            
            if  Form7.ibDataSet4DESCRICAO.AsString = Form7.ibDataSet28DESCRICAO.AsString then
            begin
              Writeln(F,Form7.ibDataSet4CODIGO.AsString+' '
                       +Copy(Form7.ibDataSet28DESCRICAO.AsString+Replicate(' ',40),1,40)
                       +Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat])+' '
                       +Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat*Form7.ibDataSet25ACUMULADO1.AsFloat]));
            end;
            
            Form7.ibDataSet28.Next;
          end;
          
          // Totalizador
          Writeln(F,'----- --------------------------------------- ---------- --------------');
          Writeln(F,'');
          Writeln(F,'');
          WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
          + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
          + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time));
          Writeln(F,'');
          WriteLn(F,'Relatório gerado pelo sistema Smallsoft');
          WriteLn(F,'www.smallsoft.com.br');
          CloseFile(F);
          ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOWMAXIMIZED);
        end;       
      end;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      Form7.ibDataSet4.EnableControls;
      
      Form7.bFabrica := False;
      
    end else 
    	ShowMEssage('Não é possível fabricar essa quantidade.');    
  end;
end;

procedure TForm10.Button10Click(Sender: TObject);
var
  sCodigo : String;
  F: TextFile;
begin
  if Button10.CanFocus then
  Begin
    Button10.SetFocus;
    if Form7.ibDataSet25ACUMULADO2.AsFloat <= Form7.ibDataSet4QTD_ATUAL.AsFloat then
    begin
      Form7.bFabrica := True;
      
      sCodigo := Form7.ibDataSet4CODIGO.AsString;
      Form7.ibDataSet4.DisableControls;
      
      Form7.IBDataSet4.Close;
      Form7.IBDataSet4.SelectSQL.Clear;
      Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE');
      Form7.IBDataSet4.Open;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      
      Form7.ibDataSet28.First;
      while not Form7.ibDataSet28.Eof do
      begin
        Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);
        
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + (Form7.ibDataSet28QUANTIDADE.AsFloat * Form7.ibDataSet25ACUMULADO2.AsFloat );
        Form7.ibDataSet4.Post;
        Form7.ibDataSet28.Next;
      end;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      Form7.ibDataSet4.Edit;
      Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet25ACUMULADO2.AsFloat;
      
      if Form1.bHtml1 then
      begin
        AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);
        Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - '+Form7.sModulo+'</title></head>');
        WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
        WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
        WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font><p><p>');
        
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=3><b>ORDEM DE PRODUÇÃO</b>');
        Writeln(F,'<br>');
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>DESMONTAR '+FloatToStr(Form7.ibDataSet25ACUMULADO2.AsFloat)+ ' ' +UpperCase(Form7.ibDataSet4DESCRICAO.AsSTring)+'</b>');
        Writeln(F,'<br>');
        Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>COMPOSIÇÃO DO PRODUTO</b>');
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Código</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Qtd X '+FloatToStr(Form7.ibDataSet25ACUMULADO2.AsFloat)+'</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet28.First;
        while not Form7.ibDataSet28.Eof do
        begin
          Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);
          
          if  Form7.ibDataSet4DESCRICAO.AsString = Form7.ibDataSet28DESCRICAO.AsString then
          begin
            WriteLn(F,' <tr>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet28DESCRICAO.AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat*Form7.ibDataSet25ACUMULADO2.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
          end;
          
          Form7.ibDataSet28.Next;
        end;
        
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        WriteLn(F,'<br>');
        WriteLn(F,'</center><center><br><font face="Microsoft Sans Serif" size=1></b>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
        + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
        + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');
        
        // WWW
        if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
        begin
          WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
        end else
        begin
          WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
        end;
        
        if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
        WriteLn(F,'</html>');
        
        CloseFile(F);
        
        AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
      end else
      begin
        Form7.ibDataSet28.First;
        if Form7.ibDataSet28CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
        begin
          AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
          Rewrite(F);                   //
          Writeln(F,'ORDEM DE PRODUÇÃO');
          Writeln(F,'');
          Writeln(F,'DESMONTAR '+FloatToStr(Form7.ibDataSet25ACUMULADO2.AsFloat)+ ' ' +UpperCase(Form7.ibDataSet4DESCRICAO.AsSTring));
          Writeln(F,'');
          Writeln(F,'COMPOSIÇÃO DO PRODUTO');
          Writeln(F,'');
          Writeln(F,'Cód   Descrição                               Qtd        Qtd X '+FloatToStr(Form7.ibDataSet25ACUMULADO2.AsFloat));
          Writeln(F,'----- --------------------------------------- ---------- --------------');
          
          Form7.ibDataSet28.First;
          while not Form7.ibDataSet28.Eof do
          begin
            Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);
            
            if  Form7.ibDataSet4DESCRICAO.AsString = Form7.ibDataSet28DESCRICAO.AsString then
            begin
              Writeln(F,Form7.ibDataSet4CODIGO.AsString+' '
                       +Copy(Form7.ibDataSet28DESCRICAO.AsString+Replicate(' ',40),1,40)
                       +Format('%10.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat])+' '
                       +Format('%14.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat*Form7.ibDataSet25ACUMULADO2.AsFloat]));
            end;
            
            Form7.ibDataSet28.Next;
          end;
          
          // Totalizador
          Writeln(F,'----- --------------------------------------- ---------- --------------');
          Writeln(F,'');
          Writeln(F,'');
          WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
          + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
          + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time));
          Writeln(F,'');
          WriteLn(F,'Relatório gerado pelo sistema Smallsoft');
          WriteLn(F,'www.smallsoft.com.br');
          CloseFile(F);
          ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOWMAXIMIZED);          
        end;        
      end;
      
      Form7.ibDataSet4.Locate('CODIGO',sCodigo,[]);
      Form7.ibDataSet4.EnableControls;
      
      Form7.bFabrica := False;      
    end else ShowMEssage('Não é possível desmontar essa quantidade.');
  end;
end;

procedure TForm10.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (StringGrid1.Col = 0) and (StringGrid1.Row = 0) then StringGrid1.Row := 1;
end;

procedure TForm10.dbgComposicaoKeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if dbgComposicao.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);

  if AllTrim(Form7.ibDataSet28.FieldByName('DESCRICAO').AsString) = '' then
  begin
    if Key = Chr(13) then Key := Chr(0);
  end else
  begin
    if dbgComposicao.DataSource.DataSet.State in [dsEdit, dsInsert] then
      framePesquisaProdComposicao.CarregarProdutos(Form7.ibDataSet28.FieldByName('DESCRICAO').AsString);
  end;

  if Key = chr(13) then
  begin
    I := dbgComposicao.SelectedIndex;
    dbgComposicao.SelectedIndex := dbgComposicao.SelectedIndex  + 1;
    if (I = dbgComposicao.SelectedIndex) then
    begin
      dbgComposicao.SelectedIndex := 0;
      Form7.ibDataSet28.Next;
      if Form7.ibDataSet28.EOF then Form7.ibDataSet28.Append;
    end;
  end;
end;

procedure TForm10.TabSheet4Show(Sender: TObject);
begin
  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
  begin
    dbgComposicao.Enabled  := False;
    Button8.Enabled  := False;
    Button10.Enabled := False;
    Button11.Enabled := False;
  end else
  begin
    dbgComposicao.Enabled  := True;
    Button8.Enabled  := True;
    Button10.Enabled := True;
    Button11.Enabled := True;
  end;
end;

procedure TForm10.DBGrid3DblClick(Sender: TObject);
  function LocalizaDBEditPosicionar(FieldName: String): TDBEdit;
  var
    I: Integer;
  begin
    Result := nil;
    for i := 0 to Form10.ComponentCount -1 do
    begin
      if (Form10.Components[i].ClassType = TDBEdit) or (Form10.Components[i].ClassType = TSMALL_DBEdit) then
      begin
        if AnsiUpperCase(TDBEDit(Form10.Components[i]).DataField) = AnsiUpperCase(FieldName) then
        begin
          Result := TDBEDit(Form10.Components[i]);
          Break;
        end;
      end;
    end;
  end;
begin
  GravaEscolha();

  {Mauricio Parizotto 2023-05-16 Inicio}
  if Form7.sModulo = 'TRANSPORT' then
  begin
    Form7.ibDataSet18UF.FocusControl;
    Exit;
  end;

  if Form7.sModulo = 'CLIENTES' then
  begin
    if Form10.dBGrid3.Height = 260 then
    begin
      Form7.IBDataSet2ESTADO.FocusControl;
    end else
    begin
      if Form10.SMALL_DBEdit19.CanFocus then
        Form10.SMALL_DBEdit19.SetFocus;
    end;

    Exit;
  end;
  {Mauricio Parizotto 2023-05-16 Fim}

  if Form10.dBGrid3.Height = 260 then
  begin
    if Form10.SMALL_DBEdit6.CanFocus then
      Form10.SMALL_DBEdit6.SetFocus
  end else
  begin
    {Sandro Silva 2023-07-24 inicio
    if Form10.SMALL_DBEdit19.CanFocus then
      Form10.SMALL_DBEdit19.SetFocus;
    }
    if (Form7.sModulo = 'RECEBER') then
    begin

      if (DBGrid3.Tag = ID_CONSULTANDO_INSTITUICAO_FINANCEIRA) then
      begin
        if LocalizaDBEditPosicionar('FORMADEPAGAMENTO') <> nil then
          LocalizaDBEditPosicionar('FORMADEPAGAMENTO').SetFocus;//Form10.SMALL_DBEdit26.SetFocus;
      end
      else if (DBGrid3.Tag = ID_CONSULTANDO_FORMA_DE_PAGAMENTO) then
      begin
        if LocalizaDBEditPosicionar('AUTORIZACAOTRANSACAO') <> nil then
          LocalizaDBEditPosicionar('AUTORIZACAOTRANSACAO').SetFocus;
      end
      else
        if Form10.SMALL_DBEdit19.CanFocus then
          Form10.SMALL_DBEdit19.SetFocus;
    end
    else
    begin
      if Form10.SMALL_DBEdit19.CanFocus then
        Form10.SMALL_DBEdit19.SetFocus;
    end;
    {Sandro Silva 2023-07-24 fim}

  end;

  {Mauricio Parizotto 2023-05-29 Inicio}
  {Sandro Silva 2023-07-24 inicio
  if (Form7.sModulo = 'RECEBER') and (DBGrid3.DataSource.Name = 'DSConsulta') then
  begin
    Form10.SMALL_DBEdit26.SetFocus;
    Exit;
  end;
  }
  if (Form7.sModulo = 'RECEBER') then
  begin

    if (DBGrid3.Tag = ID_CONSULTANDO_INSTITUICAO_FINANCEIRA) then
      LocalizaDBEditPosicionar('FORMADEPAGAMENTO').SetFocus//Form10.SMALL_DBEdit26.SetFocus;
    else if (DBGrid3.Tag = ID_CONSULTANDO_FORMA_DE_PAGAMENTO) then
      LocalizaDBEditPosicionar('AUTORIZACAOTRANSACAO').SetFocus;

    Exit;

  end;
  {Sandro Silva 2023-07-24 fim}
  {Mauricio Parizotto 2023-05-29 Fim}

  {Mauricio Parizotto 2023-06-20 Inicio}
  if (Form7.sModulo = '2CONTAS') and (DBGrid3.DataSource.Name = 'DSConsulta') then
  begin
    if btnOK.CanFocus then
      btnOK.SetFocus;
  end;
  {Mauricio Parizotto 2023-06-20 Fim}

  {Sandro Silva 2023-06-28 inicio}
  if (Form7.sModulo = 'ICM') and (DBGrid3.DataSource.Name = 'DSConsulta') then
  begin
    Form10.SMALL_DBEdit56.SetFocus;
    Exit;
  end;
  {Sandro Silva 2023-06-28 fim}

end;

procedure TForm10.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then Form10.DBGrid3DblClick(Sender);
end;

procedure TForm10.SMALL_DBEdit23KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Form7.bFlag = True then
    begin
      if Key = VK_RETURN then
        Perform(Wm_NextDlgCtl,0,0);
      if dBgrid3.Visible = True then
      begin
        if (Key = VK_UP) or (Key = VK_DOWN) then
          if dBgrid3.CanFocus then
            dBgrid3.SetFocus;
      end
      else
      begin
        if Key = VK_UP then
          Perform(Wm_NextDlgCtl,1,0);
        if Key = VK_DOWN then
          Perform(Wm_NextDlgCtl,0,0);
      end;
    end
    else
      Form7.bFlag := True;
  except
    ShowMessage('Erro 10/66 comunique o suporte técnico.')
  end;
end;

procedure TForm10.CheckBox1Exit(Sender: TObject);
begin
  Form7.ibDataSet4.Edit;
  if Form10.CheckBox1.Checked then
  begin
    Form7.ibDataSet4.FieldByname('SERIE').Value := 1;
  end else
  begin
    Form7.ibDataSet4.FieldByname('SERIE').Value := 0;
  end;
  Form7.ibDataSet4.Post;
end;

procedure TForm10.CheckBox1Click(Sender: TObject);
begin
  if Form7.ibDataSet30.Modified then
  begin
    Form7.ibDataSet30.Edit;
    Form7.ibDataSet30.Post;
  end;
  
  if Form10.CheckBox1.Checked then
  begin
    Form10.CheckBox1.Checked := True;
    DBGrid4.Visible          := True;
    Button15.Visible         := True;
    Button16.Visible         := True;
    Button17.Visible         := True;
  end else
  begin
    Form10.CheckBox1.Checked := False;
    DBGrid4.Visible          := False;
    Button15.Visible         := False;
    Button16.Visible         := False;
    Button17.Visible         := False;
  end;
end;

procedure TForm10.DBGrid4KeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if Key = chr(13) then
  begin
    I := DbGrid4.SelectedIndex;
    DbGrid4.SelectedIndex := DbGrid4.SelectedIndex  + 1;
    if (I = DbGrid4.SelectedIndex) then
    begin
      DbGrid4.SelectedIndex := 0;
      Form7.ibDataSet30.Next;
      if Form7.ibDataSet30.EOF then Form7.ibDataSet30.Append;
    end;
  end;
end;

procedure TForm10.Button17Click(Sender: TObject);
var
  sSerial : String;
begin
  sSerial := AllTrim(Form1.Small_InputForm('Procura','Número de série:',''));
  if (AllTrim(Form7.ibDataSet30SERIAL.AsString) = AllTrim(sSerial)) then Form7.ibDataSet30.Next else Form7.ibDataSet30.First;
  if AllTrim(sSerial) <> '' then
  begin
    while (not Form7.ibDataSet30.Eof) and (AllTrim(Form7.ibDataSet30SERIAL.AsString) <> AllTrim(sSerial)) do
    begin
      Form7.ibDataSet30.Next;
    end;
    if (AllTrim(Form7.ibDataSet30SERIAL.AsString) <> AllTrim(sSerial)) then ShowMessage('Não encontrado.');
  end;
  if dBgrid4.CanFocus then dbGrid4.SetFocus;
end;

procedure TForm10.Button15Click(Sender: TObject);
var
  F: TextFile;
begin
  if Form1.bHtml1 then
  begin
    CriaJpg('logotip.jpg');
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - Controle de seriais</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
    WriteLn(F,'<br><br><font size=3 color=#000000><b>'+Form7.ibDataSet4DESCRICAO.AsString+'</b></font><p>');
    WriteLn(F,'<table border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Número de série</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF compra</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Pago</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data compra</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF venda</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Recebido</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data venda</td>');
    WriteLn(F,' </tr>');
  end else
  begin
    AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'Controle de seriais');
    WriteLn(F,'');
    WriteLn(F,Form7.ibDataSet4DESCRICAO.AsString);
    WriteLn(F,'');
    WriteLn(F,'N série       NF Comp Pago           Data Comp  NF vend Recebido       Data venda');
    WriteLn(F,'------------- ------- -------------- ---------- ------- -------------- ----------');
  end;
  
  Form7.ibDataSet15.DisableControls;
  
  Form7.ibDataSet24.DisableControls;
  
  Form7.ibDataSet30.First;
  while not Form7.ibDataSet30.EOF do
  begin
    if Form1.bHtml1 then
    begin
      // NF de Compra
      WriteLn(F,' <tr>');
      Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30SERIAL.AsString+'</td>');
      Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30NFCOMPRA.AsString+'</td>');
      Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet30VALCOMPRA.AsFloat])+'</td>'); // Valor
      Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30DATCOMPRA.AsString+'</td>');
      
      // NF de venda
      Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet30NFVENDA.AsString,1,6)+'</td>');
      Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet30VALVENDA.AsFloat])+'</td>'); // Valor
      Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30DATVENDA.AsString+'</td>');
      WriteLn(F,' </tr>');
    end else
    begin
      // NF de Compra
      Write(F,Copy(Form7.ibDataSet30SERIAL.AsString+Replicate(' ',13),1,13)+' ');
      Write(F,Copy(Form7.ibDataSet30NFCOMPRA.AsString+Replicate(' ',7),1,7)+' ');
      Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet30VALCOMPRA.AsFloat])+' '); // Valor
      Write(F,Form7.ibDataSet30DATCOMPRA.AsString+' ');
      
      // NF de venda      
      Write(F,Copy(Copy(Form7.ibDataSet30NFVENDA.AsString,1,6)+Replicate(' ',7),1,7)+' ');
      Write(F,Format('%14.'+Form1.ConfPreco+'n',[Form7.ibDataSet30VALVENDA.AsFloat])+' '); // Valor
      WriteLn(F,Form7.ibDataSet30DATVENDA.AsString+' ');
    end;

    Form7.ibDataSet30.Next;
  end;

  if Form1.bHtml1 then
  begin
    WriteLn(F,' </tr>');
    WriteLn(F,'</table><p><p>');
    WriteLn(F,'<center><br><font face="Microsoft Sans Serif" size=1></b>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');
    
    // WWW
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;
    
    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');
    CloseFile(F);
    
    AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);    
  end else
  begin
    WriteLn(F,'');
    WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'');
    CloseFile(F);
    ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOWMAXIMIZED);
  end;
  
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet24.EnableControls;
end;

procedure TForm10.Button16Click(Sender: TObject);
var
  F: TextFile;
begin
  if Form1.bHtml1 then
  begin
    CriaJpg('logotip.jpg');
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - Controle de seriais</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font size=3 color=#000000><b>'+AllTrim(Form7.ibDataSet13NOME.AsString)+'</b></font>');
    WriteLn(F,'<br><br><font size=3 color=#000000><b>'+Form7.ibDataSet4DESCRICAO.AsString+'</b></font><p>');
    WriteLn(F,'<table border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Número de série</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF COMPRA</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>DATA COMPRA</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF VENDA</td>');
    WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>DATA VENDA</td>');
    WriteLn(F,' </tr>');
    WriteLn(F,' <tr>');
    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30SERIAL.AsString+'</td>');
    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30NFCOMPRA.AsString+'</td>');
    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30DATCOMPRA.AsString+'</td>');
    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30NFVENDA.AsString+'</td>');
    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet30DATVENDA.AsString+'</td>');
  end else
  begin
    AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'Controle de seriais');
    WriteLn(F,'');
    WriteLn(F,Form7.ibDataSet4DESCRICAO.AsString);
    WriteLn(F,'');
    WriteLn(F,'N de série    NF Comp Data Comp  NF Vend Data Venda');
    WriteLn(F,'------------- ------- ---------- ------- ----------');
    Write(F,Copy(Form7.ibDataSet30SERIAL.AsString+Replicate(' ',13),1,13)+' ');
    Write(F,Copy(Form7.ibDataSet30NFCOMPRA.AsString+Replicate(' ',7),1,7)+' ');
    Write(F,Form7.ibDataSet30DATCOMPRA.AsString+' ');
    Write(F,Copy(Form7.ibDataSet30NFVENDA.AsString+Replicate(' ',7),1,7)+' ');
    Writeln(F,Form7.ibDataSet30DATVENDA.AsString+' ');
  end;
  
  if Form1.bHtml1 then
  begin
    WriteLn(F,' </tr>');
    WriteLn(F,'</table><p><p>');
    WriteLn(F,'<center><br><font face="Microsoft Sans Serif" size=1></b>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');
    //
    // WWW
    //
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;
    
    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');
    CloseFile(F);
    
    AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);    
  end else
  begin
    WriteLn(F,'');
    WriteLn(F,'Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'');
    
    CloseFile(F);
    ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'', '', SW_SHOWMAXIMIZED);
  end;
  
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet24.EnableControls;
end;

procedure TForm10.DBGrid5KeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if Key = chr(13) then
  begin
    I := DbGrid4.SelectedIndex;
    DbGrid4.SelectedIndex := DbGrid4.SelectedIndex  + 1;
    if (I = DbGrid4.SelectedIndex) then
    begin
      DbGrid4.SelectedIndex := 0;
      Form7.ibDataSet30.Next;
      if Form7.ibDataSet30.EOF then Form7.ibDataSet30.Append;
    end;
  end;
end;

procedure TForm10.Label45Click(Sender: TObject);
begin
  ShowMessage('Este campo não pode ser alterado'+Chr(10)+
                                    'o nome do fornecedor é preenchido'+Chr(10)+
                                    'no evento da compra.');

end;

procedure TForm10.Image201Click(Sender: TObject);
begin
  Form10.Button4.SetFocus;
  Form10.Button4Click(Sender);
 
  if not Form7.bSoLeitura then
  begin
    if Form7.sModulo = 'ESTOQUE' then
    begin
      if (AllTrim(Form7.ibDataSet4CODIGO.AsString) <> '') and (AllTrim(Form7.ibDataSet4DESCRICAO.AsString) = '') then
      begin

      end else
      begin
         Form7.ArquivoAberto.Append;
      end;
    end else
    begin
      try
         Form7.ArquivoAberto.Append;
      except end;  
    end;
  end;

  Form7.IBTransaction1.CommitRetaining;
  VerificaSeEstaSendoUsado(False);
  Form10.Show;
end;

procedure TForm10.Image205Click(Sender: TObject);
begin
  try
    Form7.ArquivoAberto.MoveBy(1);
  except 
  end;   
 
  AtualizaObjComValorDoBanco; // Sandro Silva 2023-06-28

  try
    Form7.IBTransaction1.CommitRetaining;
    VerificaSeEstaSendoUsado(False);
    Form10.FormShow(Sender);
    Form10.FormActivate(Sender);
    if ((Form7.ArquivoAberto.eof) or (bNovo)) then
      Form10.Image201Click(Sender)
    else
      bNovo := False;

  except 
  end;

  if (Form7.sModulo = 'ESTOQUE') then
    MostraImagemEstoque; // Sandro Silva 2023-08-22
end;

procedure TForm10.Panel_1Enter(Sender: TObject);
begin
  AtualizaTela(True);
end;

procedure TForm10.Edit2Enter(Sender: TObject);
begin
  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm10.FormCreate(Sender: TObject);
begin
  {Sandro Silva 2023-06-21 inicio}
  pnRelacaoComercial.BorderStyle := bsNone;
  pnRelacaoComercial.BevelOuter  := bvNone;
  {Sandro Silva 2023-06-21 fim}

  sNomeDoArquivoParaSalvar := 'Small Commerce.Txt';

  orelhas.ActivePage := orelha_cadastro; // Sandro Silva 2023-06-27

  framePesquisaProdComposicao.setDataBase(Form7.IBDatabase1);
  Form7.ibDataSet28DESCRICAO.OnChange := ibDataSet28DESCRICAOChange;

  //Mauricio Parizotto 2023-06-01
  Image201.Transparent := False;
  Image202.Transparent := False;
  Image203.Transparent := False;
  Image205.Transparent := False;
  Image204.Transparent := False;

  //Mauricio Parizotto 2023-06-19
  DBGrid3.TabStop := False;

  cbMovimentacaoEstoque.Items.Clear;
  cbMovimentacaoEstoque.Items.Add('');
  cbMovimentacaoEstoque.Items.Add(TEXTO_NAO_MOVIMENTA_ESTOQUE);
  cbMovimentacaoEstoque.Items.Add(TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS);

  {$IFDEF VER150}
  {$ELSE}
  StringGrid2.DrawingStyle       := gdsGradient;
  StringGrid2.GradientStartColor := $00F0F0F0;
  StringGrid2.GradientEndColor   := $00F0F0F0;
  {$ENDIF}
end;

procedure TForm10.Label36MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Button1Click(Sender: TObject);
var
  I, J : Integer;
  Mais1Ini: TIniFile;
begin
  if not Form7.bSoLeitura then
  begin
    I := Application.MessageBox(Pchar('Tem certeza que quer excluir as informações'
                            + chr(10)+'da grade deste produto?'+ Chr(10)
                      + Chr(10))
                      ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
    if I = IDYES then
    begin
      for I := 0 to 19 do
       for J := 0 to 19 do
         StringGrid1.Cells[I,J] := '';
      
      Form7.ibDataSet10.DisableControls;
      Form7.ibDataSet10.First;
      
      while not Form7.ibDataSet10.EOF do
        if Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then Form7.ibDataSet10.Delete else Form7.ibDataSet10.Next;
      
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('X'+StrZero(I,2,0)),Form10.StringGrid1.Cells[0,I]);
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('Y'+StrZero(I,2,0)),Form10.StringGrid1.Cells[I,0]);
      Mais1ini.Free;
    end;    
  end;
end;

procedure TForm10.Button2Click(Sender: TObject);
begin
  Form10.Orelha_gradeShow(Sender);
  Form10.Repaint;
end;

procedure TForm10.Button3Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  I, J : Integer;
  rQtd : Real;
begin
  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
  try
    rQtd := 0;
    
    for I := 0 to 19 do
      for J := 0 to 19 do
        if AllTrim(Form10.StringGrid1.Cells[I,J]) <> '' then
          if (I <> 0) and (J <> 0) then rQtd := rQtd + StrToFloat(LimpaNumeroDeixandoAVirgula(Form10.StringGrid1.Cells[I,J]));
    
    if rQtd <> 0 then
    begin
      if StrToFloat(Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat - rQtd])) = 0 then
      begin
        // Fecha sempre qtd atual com grade
        Form7.ibDataSet10.Close;
        Form7.ibDataSet10.SelectSQL.Clear;
        Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
        Form7.ibDataSet10.Open;
        
        for I := 0 to 19 do
        begin
          for J := 0 to 19 do
          begin
            if (AllTrim(Form10.StringGrid1.Cells[I,0]) <> '') and (AllTrim(Form10.StringGrid1.Cells[0,J]) <> '') and (Form10.StringGrid1.Cells[I,J] = '') then Form10.StringGrid1.Cells[I,J] := '0,00';
            
            if AllTrim(form10.StringGrid1.Cells[I,J]) <> '' then
            begin
              Form7.ibDataSet10.First;
              while (not Form7.ibDataSet10.Eof) and not ((Form7.ibDataSet10COR.AsString = StrZero(I,2,0)) and (Form7.ibDataSet10TAMANHO.AsString = StrZero(J,2,0))) do
              begin
                Form7.ibDataSet10.Next;
              end;

              if (Form7.ibDataSet10COR.AsString = StrZero(I,2,0)) and (Form7.ibDataSet10TAMANHO.AsString = StrZero(J,2,0)) then
              begin
                if (I = 0) or (J = 0) then
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString  := Form10.StringGrid1.Cells[I,J];
                  Form7.ibDataSet10.Post;
                end else
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString  := LimpaNumeroDeixandoAVirgula(Format('%12.'+Form1.ConfCasas+'n',[(StrToFloat(LimpaNumeroDeixandoAvirgula(form10.StringGrid1.Cells[I,J])))]));
                  Form7.ibDataSet10.Post;
                end;
              end else
              begin
                Form7.ibDataSet10.Append;
                Form7.ibDataSet10CODIGO.AsString  := Form7.ibDataSet4CODIGO.AsString;
                Form7.ibDataSet10COR.AsString     := StrZero(I,2,0);
                Form7.ibDataSet10TAMANHO.AsString := StrZero(J,2,0);
                //
                // Quando I=0 e J=0 São as legendas não é a qtd
                //
                if (I = 0) or (J = 0) then
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString  := Form10.StringGrid1.Cells[I,J];
                  Form7.ibDataSet10.Post;
                end else
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString := LimpaNumeroDeixandoAVirgula(Format('%12.'+Form1.ConfCasas+'n',[(StrToFloat(LimpaNumeroDeixandoAvirgula(form10.StringGrid1.Cells[I,J])))]));
                  Form7.ibDataSet10.Post;
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10ENTRADAS.AsString := Form7.ibDataSet10QTD.AsString;
                  Form7.ibDataSet10.Post;
                end;
              end;
            end;
          end;
        end;
        
        if Form7.sModulo <> 'ICM' then
        begin
          Orelhas.ActivePage := Orelha_cadastro;
        end else
        begin
          Orelhas.ActivePage := Orelha_CFOP;
        end;
      end else
      begin
        try
          ShowMessage('Diferença: '+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat - rQtd])+chr(10)+chr(10)+'Acerte a quantidade.');
          Abort;
        except end;
      end;
      
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('X'+StrZero(I,2,0)),Form10.StringGrid1.Cells[0,I]);
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('Y'+StrZero(I,2,0)),Form10.StringGrid1.Cells[I,0]);
      Mais1ini.Free;
    end else
    begin
      if Form7.sModulo <> 'ICM' then
      begin
        Orelhas.ActivePage := Orelha_cadastro;
      end else
      begin
        Orelhas.ActivePage := Orelha_CFOP;
      end;
    end;

    if (AllTrim(Form10.StringGrid1.Cells[0,1]) = '') and (AllTrim(Form10.StringGrid1.Cells[1,0]) = '') then
    begin
      Form7.ibDataSet10.Close;
      Form7.ibDataSet10.SelectSQL.Clear;
      Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by CODIGO, COR, TAMANHO');
      Form7.ibDataSet10.Open;
      Form7.ibDataSet10.First;
      while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (not Form7.ibDataSet10.EOF) do
        if Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then Form7.ibDataSet10.Delete else Form7.ibDataSet10.Next;
    end;
  except end;
 
  Screen.Cursor             := crDefault;
end;

procedure TForm10.Image202Click(Sender: TObject);
begin
  Form20.ShowModal;
  
  Form7.iFoco := 0;
  Form10.Paint;
  
  if Form7.sModulo <> 'ICM' then
  begin
    Orelhas.ActivePage := orelha_cadastro;
    Form10.Panel_1Enter(Sender);
  end else
  begin
    Orelhas.ActivePage := Orelha_CFOP;
  end;
end;

procedure TForm10.Label37MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label37MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Image9Click(Sender: TObject);
begin
  if not Form7.bSoLeitura then
  begin
    if Form7.sModulo <> 'ICM' then
    begin
      Orelhas.ActivePage := orelha_cadastro;
      if dbgComposicao.CanFocus then dbgComposicao.SetFocus;
    end else
    begin
      Orelhas.ActivePage := Orelha_CFOP;
    end;
  end;
end;

procedure TForm10.Label40MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label40MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label42MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label42MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label43Click(Sender: TObject);
begin
  Orelhas.ActivePage := orelha_cadastro;
  if CheckBox1.CanFocus then CheckBox1.SetFocus;
end;

procedure TForm10.Label43MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label43MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Edit5Enter(Sender: TObject);
begin
  if DBGrid4.CanFocus then DBGrid4.SetFocus;
end;

procedure TForm10.Edit6Enter(Sender: TObject);
begin
  if dbgComposicao.CanFocus then dbgComposicao.SetFocus;
end;

procedure TForm10.FormActivate(Sender: TObject);
var
  iWidthCampos: Integer;
begin
  if Form7.sModulo = 'ESTOQUE' then
  begin
    if Form7.ibDataSet4MARKETPLACE.AsString = '1' then
      CheckBox2.Checked := True
    else
      CheckBox2.Checked := False;
  end;
  
  if Form7.sModulo = 'CLIENTES' then
  begin
    Form10.Image1.Visible := True;
  end else
  begin
    Form10.Image1.Visible := False;
  end;
  
  Image4.Picture.Bitmap := Image7.Picture.Bitmap;
  
  Image5.Left     := 20;
  Image5.Top      := 80;
  Image5.Width    := 640 div 2;
  Image5.Height   := 480 div 2;
  
  orelha_cadastro.TabVisible   := True;
  orelha_serial.TabVisible     := False;
  orelha_composicao.TabVisible := False;
  orelha_foto.TabVisible       := False;
  orelha_grade.TabVisible      := False;
  orelha_ICMS.TabVisible       := False;
  orelha_IPI.TabVisible        := False;
  orelha_PISCOFINS.TabVisible  := False;
  orelha_preco.TabVisible      := False;
  orelha_PROMO.TabVisible      := False;
  orelha_CONVERSAO.TabVisible  := False;
  orelha_CFOP.TabVisible       := False;
  orelha_COMISSAO.TabVisible   := False;
  orelha_CODEBAR.TabVisible    := False;
  orelha_TAGS.TabVisible       := False;
  orelha_MKT.TabVisible        := False;
  orelha_PerfilTrib.TabVisible            := False; //Mauricio Parizotto 2023-08-31
  orelha_PerfilTrib_IPI.TabVisible        := False; //Mauricio Parizotto 2023-08-31
  orelha_PerfilTrib_PISCOFINS.TabVisible  := False; //Mauricio Parizotto 2023-08-31

  {Sandro Silva 2023-06-28 inicio}
  dbepPisSaida.DataField  := '';
  dbepPisSaida.DataSource := Form7.DataSource4;
  dbepPisSaida.DataField  := 'ALIQ_PIS_SAIDA';

  dbepCofinsSaida.DataField  := '';
  dbepCofinsSaida.DataSource := Form7.DataSource4;
  dbepCofinsSaida.DataField  := 'ALIQ_COFINS_SAIDA';

  gbPisCofinsEntrada.Visible := True;
  gbPisCofinsSaida.Caption := 'Saída';
  dbeIcmBCPISCOFINS.Visible := False;
  lbBCPISCOFINS.Visible     := False;
  {Sandro Silva 2023-06-28 fim}

  if Form7.sModulo = 'ICM' then
  begin
    dbepPisSaida.DataField  := '';
    dbepPisSaida.DataSource := Form7.DataSource14;
    dbepPisSaida.DataField  := 'PPIS';

    dbepCofinsSaida.DataField  := '';
    dbepCofinsSaida.DataSource := Form7.DataSource14;
    dbepCofinsSaida.DataField  := 'PCOFINS';

    gbPisCofinsSaida.Caption := '';//'PIS/COFINS';
    gbPisCofinsEntrada.Visible := False;

    dbeIcmBCPISCOFINS.Visible := True;
    lbBCPISCOFINS.Visible     := True;

    Form10.orelha_cadastro.TabVisible   := False;
    Form10.orelha_CFOP.TabVisible       := True;
    Form10.Orelha_PISCOFINS.TabVisible  := True; // Sandro Silva 2023-06-27
  end;
 
  if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
  begin
    orelha_cadastro.TabVisible   := True;
    orelha_serial.TabVisible     := True;
    orelha_composicao.TabVisible := True;
    orelha_foto.TabVisible       := True;
    orelha_grade.TabVisible      := True;
    orelha_ICMS.TabVisible       := True;
    orelha_IPI.TabVisible        := True;
    orelha_preco.TabVisible      := True;
    orelha_PISCOFINS.TabVisible  := True;
    orelha_PROMO.TabVisible      := True;
    orelha_CONVERSAO.TabVisible  := True;
    orelha_CODEBAR.TabVisible    := True;
    orelha_TAGS.TabVisible       := True;
    orelha_MKT.TabVisible        := True;
  end;


  //Mauricio Parizotto 2023-08-31
  if (Form7.sModulo = 'PERFILTRIBUTACAO') then
  begin
    orelha_cadastro.TabVisible              := False;
    orelha_PerfilTrib.TabVisible            := True;
    orelha_PerfilTrib_IPI.TabVisible        := True;
    orelha_PerfilTrib_PISCOFINS.TabVisible  := True;
  end;


  if Form7.sModulo = 'CLIENTES' then
  begin
    Form10.orelha_cadastro.TabVisible   := True;
    Form10.orelha_foto.TabVisible       := True;
    
    if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
    begin
      Form10.orelha_COMISSAO.TabVisible       := True;
    end;
  end;

  //{Sandro Silva 2023-08-21 inicio
  Image5.Picture  := Image3.Picture;
  {
  if Image3.Picture.Graphic <> nil then
  begin
    if Image5.Picture.Graphic <> nil then
    begin
      //Form10.Image3.Picture.Width  := Form10.Image5.Picture.Width; // Sandro Silva 2023-08-22
      //Form10.Image3.Picture.Height := Form10.Image5.Picture.Height; // Sandro Silva 2023-08-22

      // Mantem a proporção da imagem
      try
        if Form10.Image3.Picture.Width <> 0 then
        begin
          Form10.Image3.Width   := 256;
          Form10.Image3.Height  := 256;

          if Form10.Image3.Picture.Width > Form10.Image3.Picture.Height then
          begin
            Form10.Image3.Width  := StrToInt(StrZero((Form10.Image3.Picture.Width * (Form10.Image3.Width / Form10.Image3.Picture.Width)),10,0));
            Form10.Image3.Height := StrToInt(StrZero((Form10.Image3.Picture.Height* (Form10.Image3.Width / Form10.Image3.Picture.Width)),10,0));
          end else
          begin
            Form10.Image3.Width  := StrToInt(StrZero((Form10.Image3.Picture.Width * (Form10.Image3.Height / Form10.Image3.Picture.Height)),10,0));
            Form10.Image3.Height := StrToInt(StrZero((Form10.Image3.Picture.Height* (Form10.Image3.Height / Form10.Image3.Picture.Height)),10,0));
          end;

          Form10.Image3.Picture := Form10.Image3.Picture;
          Form10.Image3.Repaint; // Sandro Silva 2023-08-21
        end;
      except
      end;

      Form10.Image5.Picture.Graphic.Assign(Form10.Image3.Picture.Graphic); /// aqui está limpando form10.image5.picture
    end;

  end;
  {Sandro Silva 2023-08-21 fim}
  
  bNovo := False;
  
  if Form7.sModulo = 'RECEBER' then
  begin
    {Sandro Silva 2023-06-22 inicio
    // Campo CONTATO no cadastro de clientes
    Form10.SMALL_DBEdit26.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit26.DataField  := 'CONTATO';
    Form10.SMALL_DBEdit26.Top        := SMALL_DBEdit2.Top;
    Form10.SMALL_DBEdit26.Left       := SMALL_DBEdit1.Left + 450;
    Form10.SMALL_DBEdit26.Visible    := True;
    Form10.SMALL_DBEdit26.Width      := 240;
    Form10.SMALL_DBEdit26.MaxLength  := Form7.IBDataSet2CONTATO.Size;

    Form10.Label26.Top        := Label2.Top;
    Form10.Label26.Left       := Label2.Left + 450;
    Form10.Label26.Visible    := True;
    Form10.Label26.Caption    := 'Contato:';

    // Campo TELEFONE no cadastro de clientes
    Form10.SMALL_DBEdit27.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit27.DataField  := 'FONE';
    Form10.SMALL_DBEdit27.Top        := SMALL_DBEdit3.Top;
    Form10.SMALL_DBEdit27.Left       := SMALL_DBEdit3.Left + 450;
    Form10.SMALL_DBEdit27.Visible    := True;
    Form10.SMALL_DBEdit27.Width      := 240;

    Form10.Label27.Top        := Label3.Top;
    Form10.Label27.Left       := Label3.Left + 450;
    Form10.Label27.Visible    := True;
    Form10.Label27.Caption    := 'Telefone:';

    // Campo CELULAR no cadastro de clientes
    Form10.SMALL_DBEdit28.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit28.DataField  := 'CELULAR';
    Form10.SMALL_DBEdit28.Top        := SMALL_DBEdit4.Top;
    Form10.SMALL_DBEdit28.Left       := SMALL_DBEdit4.Left + 450;
    Form10.SMALL_DBEdit28.Visible    := True;
    Form10.SMALL_DBEdit28.Width      := 240;

    Form10.Label28.Top        := Label4.Top;
    Form10.Label28.Left       := Label4.Left + 450;
    Form10.Label28.Visible    := True;
    Form10.Label28.Caption    := 'Celular:';

    // Campo EMAIL no cadastro de clientes
    Form10.SMALL_DBEdit29.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit29.DataField  := 'EMAIL';
    Form10.SMALL_DBEdit29.Top        := SMALL_DBEdit5.Top;
    Form10.SMALL_DBEdit29.Left       := SMALL_DBEdit5.Left + 450;
    Form10.SMALL_DBEdit29.Visible    := True;
    Form10.SMALL_DBEdit29.Width      := 240;

    Form10.Label29.Top        := Label5.Top;
    Form10.Label29.Left       := Label5.Left + 450;
    Form10.Label29.Visible    := True;
    Form10.Label29.Caption    := 'E-mail:';

    // Contatos
    Form10.dbMemo2.DataSource := Form7.DataSource2;
    Form10.dbMemo2.DataField  := 'CONTATOS';
    Form10.dbMemo2.TabOrder   := Form10.SMALL_DBEdit29.TabOrder + 1;
    Form10.dbMemo2.Width      := 240;
    Form10.dbMemo2.Height     := 320 - 50;
    Form10.dbMemo2.Top        := SMALL_DBEdit6.Top;
    Form10.dbMemo2.Left       := SMALL_DBEdit6.Left + 450;
    Form10.dbMemo2.Visible    := True;

    Form10.Label23.Caption    := 'Contatos:';
    Form10.Label23.Visible    := True;
    Form10.Label23.Top        := Label6.Top;
    Form10.Label23.Left       := Label6.Left + 450;
    Form10.Label23.Width      := Label6.Width;
    }

    iWidthCampos := 325;

    // Campo CONTATO no cadastro de clientes
    Form10.SMALL_DBEdit26.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit26.DataField  := 'CONTATO';
    Form10.SMALL_DBEdit26.Top        := SMALL_DBEdit5.Top;
    Form10.SMALL_DBEdit26.Left       := SMALL_DBEdit5.Left + 460; //450;
    Form10.SMALL_DBEdit26.Visible    := True;
    Form10.SMALL_DBEdit26.Width      := iWidthCampos;
    Form10.SMALL_DBEdit26.MaxLength  := Form7.IBDataSet2CONTATO.Size;

    Form10.Label26.Top        := Label5.Top;
    Form10.Label26.Left       := Label5.Left + 460; //450;
    Form10.Label26.Visible    := True;
    Form10.Label26.Caption    := 'Contato:';

    // Campo TELEFONE no cadastro de clientes
    Form10.SMALL_DBEdit27.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit27.DataField  := 'FONE';
    Form10.SMALL_DBEdit27.Top        := SMALL_DBEdit6.Top;
    Form10.SMALL_DBEdit27.Left       := SMALL_DBEdit6.Left + 460; //450;
    Form10.SMALL_DBEdit27.Visible    := True;
    Form10.SMALL_DBEdit27.Width      := iWidthCampos;

    Form10.Label27.Top        := Label6.Top;
    Form10.Label27.Left       := Label6.Left + 460; //450;
    Form10.Label27.Visible    := True;
    Form10.Label27.Caption    := 'Telefone:';

    // Campo CELULAR no cadastro de clientes
    Form10.SMALL_DBEdit28.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit28.DataField  := 'CELULAR';
    Form10.SMALL_DBEdit28.Top        := SMALL_DBEdit7.Top;
    Form10.SMALL_DBEdit28.Left       := SMALL_DBEdit7.Left + 460; //450;
    Form10.SMALL_DBEdit28.Visible    := True;
    Form10.SMALL_DBEdit28.Width      := iWidthCampos;

    Form10.Label28.Top        := Label7.Top;
    Form10.Label28.Left       := Label7.Left + 460; //450;
    Form10.Label28.Visible    := True;
    Form10.Label28.Caption    := 'Celular:';

    // Campo EMAIL no cadastro de clientes
    Form10.SMALL_DBEdit29.DataSource := Form7.DataSource2;
    Form10.SMALL_DBEdit29.DataField  := 'EMAIL';
    Form10.SMALL_DBEdit29.Top        := SMALL_DBEdit8.Top;
    Form10.SMALL_DBEdit29.Left       := SMALL_DBEdit8.Left + 460; //450;
    Form10.SMALL_DBEdit29.Visible    := True;
    Form10.SMALL_DBEdit29.Width      := iWidthCampos;

    Form10.Label29.Top        := Label8.Top;
    Form10.Label29.Left       := Label8.Left + 460; //450;
    Form10.Label29.Visible    := True;
    Form10.Label29.Caption    := 'E-mail:';

    // Contatos
    Form10.dbMemo2.DataSource := Form7.DataSource2;
    Form10.dbMemo2.DataField  := 'CONTATOS';
    Form10.dbMemo2.TabOrder   := Form10.SMALL_DBEdit29.TabOrder + 1;
    Form10.dbMemo2.Width      := iWidthCampos;
    Form10.dbMemo2.Height     := 320 - 100;
    Form10.dbMemo2.Top        := SMALL_DBEdit9.Top;
    Form10.dbMemo2.Left       := SMALL_DBEdit9.Left + 460; //450;
    Form10.dbMemo2.Visible    := True;

    Form10.Label23.Caption    := 'Contatos:';
    Form10.Label23.Visible    := True;
    Form10.Label23.Top        := Label9.Top;
    Form10.Label23.Left       := Label9.Left + 460; //450;
    Form10.Label23.Width      := Label9.Width;
    {Sandro Silva 2023-06-22 fim}

    if Form7.bSoLeitura or Form7.bEstaSendoUsado then
    begin
      Form10.SMALL_DBEdit26.ReadOnly := True;
      Form10.SMALL_DBEdit27.ReadOnly := True;
      Form10.SMALL_DBEdit28.ReadOnly := True;
      Form10.SMALL_DBEdit29.ReadOnly := True;

      Form10.SMALL_DBEdit26.Font.Color := clGrayText;
      Form10.SMALL_DBEdit27.Font.Color := clGrayText;
      Form10.SMALL_DBEdit28.Font.Color := clGrayText;
      Form10.SMALL_DBEdit29.Font.Color := clGrayText;
    end else
    begin
      Form10.SMALL_DBEdit26.ReadOnly := False;
      Form10.SMALL_DBEdit27.ReadOnly := False;
      Form10.SMALL_DBEdit28.ReadOnly := False;
      Form10.SMALL_DBEdit29.ReadOnly := False;
      
      Form10.SMALL_DBEdit26.Font.Color := clWindowText;
      Form10.SMALL_DBEdit27.Font.Color := clWindowText;
      Form10.SMALL_DBEdit28.Font.Color := clWindowText;
      Form10.SMALL_DBEdit29.Font.Color := clWindowText;
      
      try
        Form7.IBDataSet2.Edit;
      except
        Form10.SMALL_DBEdit26.ReadOnly := True;
        Form10.SMALL_DBEdit27.ReadOnly := True;
        Form10.SMALL_DBEdit28.ReadOnly := True;
        Form10.SMALL_DBEdit29.ReadOnly := True;
        
        Form10.SMALL_DBEdit26.Font.Color := clGrayText;
        Form10.SMALL_DBEdit27.Font.Color := clGrayText;
        Form10.SMALL_DBEdit28.Font.Color := clGrayText;
        Form10.SMALL_DBEdit29.Font.Color := clGrayText;
      end;
    end;

  end;
end;

procedure TForm10.Label52MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label52MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label51MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label51MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label44MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label44MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label53MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label53MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Label36MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label35MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label55MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label55MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Image_FechaClick(Sender: TObject);
begin
  Close;
end;

procedure TForm10.Label19Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      if not ((Form7.sModulo = 'ESTOQUE') and (Name='Label22')) then
      begin
        sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
        Caption := sNome+':';
        Repaint;
        
        SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
        SmallIni.WriteString(Form7.sModulo,NAME,sNome);
        SmallIni.Free;
      end;     
    end;
    
    Mais.LeLabels(True);    
  end;
end;

procedure TForm10.Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      if not ((Form7.sModulo = 'ESTOQUE') and (Name='Label22')) then
      begin
        Font.Style := [fsBold,fsUnderline];
        Font.Color := clBlue;
        Repaint;
      end;  
    end;
  end;
end;

procedure TForm10.Label19MouseLeave(Sender: TObject);
begin
  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      if not ((Form7.sModulo = 'ESTOQUE') and (Name='Label22')) then
      begin
        Font.Style := [];
        Font.Color := clBlack;
        Repaint;
      end;
    end;
  end;
end;

procedure TForm10.Label23MouseLeave(Sender: TObject);
begin
  if (Form7.sModulo = 'CLIENTES') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  end;
end;

procedure TForm10.Label23MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Form7.sModulo = 'CLIENTES') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  end;
end;

procedure TForm10.Image20Click(Sender: TObject);
begin
  Close;
end;

procedure TForm10.Label54Click(Sender: TObject);
begin
  if Form7.ArquivoAberto.Modified then
  begin
    try Form7.ArquivoAberto.Post; except end;
    AgendaCommit(True);
    Form7.Close;
    Form7.Show;
    AgendaCommit(True);
  end;
  
  Form10.close;
end;

procedure TForm10.Image23Click(Sender: TObject);
begin
  try
    if Form7.sModulo = 'ESTOQUE' then
    begin
      if not Form7.bSoLeitura then
      begin
        Image5.Picture.SaveToFile(Form10.sNomeDoJPG);
        
        ShellExecute( 0, 'Open','pbrush.exe',pChar(Form10.sNomeDoJPG),'', SW_SHOWMAXIMIZED);
        ShowMessage('Tecle <enter> para que a nova imagem seja exibida.');
        Form10.Panel_1Enter(Sender);
      end;
    end;
    
    if Form7.sModulo = 'GRUPOS' then
    begin
      if not Form7.bSoLeitura then
      begin        
        Image5.Picture.SaveToFile(Form10.sNomeDoJPG);
        
        ShellExecute( 0, 'Open','pbrush.exe',pChar(Form10.sNomeDoJPG),'', SW_SHOWMAXIMIZED);
        ShowMessage('Tecle <enter> para que a nova imagem seja exibida.');
        Form10.Panel_1Enter(Sender);
      end;
    end;
  except 
  end;
end;

procedure TForm10.SMALL_DBEdit1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with Sender as TSMALL_DBEdit do
  begin
    Hint := Field.DisplayLabel;
    ShowHint := True;
  end;
end;

procedure TForm10.DBMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end
    else
      bProximo := True;
  end
  else
    bProximo := False;
end;

procedure TForm10.DBMemo2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Quando da 2 ENTER seguidos
  if Key = VK_INSERT then
  begin
    if FileExists(Form1.sAtual+'\contatos\'+AllTrim(LimpaLetrasPor_(Form7.ibDataSet2NOME.AsString))+'.txt') then // Lê o arquivo
    begin
      Form7.IBDataSet2CONTATOS.Clear;
      try
        if Form7.IBDataSet2.Modified then
          Form7.IBDataSet2.Post;
        Form7.IBDataSet2.Edit;
        Form7.IBDataSet2CONTATOS.LoadFromFile(pChar('contatos\'+AllTrim(LimpaLetrasPor_(Form7.ibDataSet2NOME.AsString))+'.txt'));
        Deletefile(pchar('contatos\'+AllTrim(LimpaLetrasPor_(Form7.ibDataSet2NOME.AsString))+'.txt'));
      except end;
    end;
  end;

  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end
    else
      bProximo := True;
  end
  else
  	bProximo := False;
end;

procedure TForm10.DBMemo2Enter(Sender: TObject);
begin
  sContatos := Form7.IBDataSet2CONTATOS.AsString;
  
  if Form7.sModulo = 'RECEBER' then
  begin
    try
      if Form7.IBDataSet2.Modified then Form7.IBDataSet2.Post;
      Form7.IBDataSet2.Edit;
    except
      ShowMessage('Este registro esá sendo usado por outro usuário.');
      DBMemo2.Visible := False;
    end;
  end else
  begin
    if Form7.ArquivoAberto.Modified then Form7.ArquivoAberto.Post;
    Form7.ArquivoAberto.Edit;
  end;
  
  SendMessage(dbMemo2.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(dbMemo2.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  dbMemo2.SelStart := Length(dbMemo2.Text); //move o cursor pra o final da ultima linha
  dbMemo2.SetFocus;
end;

procedure TForm10.DBMemo2Exit(Sender: TObject);
begin
  if StrTran(StrTran(StrTran(Form7.IBDataSet2CONTATOS.AsString,chr(10),''),chr(13),''),' ','') <> StrTran(StrTran(StrTran(sContatos,chr(10),''),chr(13),''),' ','') then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2CONTATOS.AsString := Form7.IBDataSet2CONTATOS.AsString +chr(10) +'('+Senhas.UsuarioPub+') '+StrZero(Year(Date),4,0)+'-'+StrZero(Month(Date),2,0)+'-'+StrZero(day(Date),2,0)+' '+TimeToStr(Time);

    /////////////////////////////////////////////// 2022-07-21
    // Comercial da Small está perdendo dados de contatos
    if Form7.ibDataSet13CGC.AsString = CNPJ_SMALLSOFT then
      Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy(Form7.IBDataSet2NOME.AsString, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
    /////////////////////////////////////////////// 2022-07-21
  end;
  
  if Form7.sModulo = 'RECEBER' then
  begin
    try
      if Form7.IBDataSet2.Modified then Form7.IBDataSet2.Post;
    except
      ShowMessage('Não foi possível gravar o assunto do contato - Este registro está sendo usado por outro usuário.');
      Form7.IBDataSet2.Cancel;
    end;
  end else
  begin
    try
      if Form7.ArquivoAberto.Modified then Form7.ArquivoAberto.Post;
    except
      on E: Exception do
      begin
        /////////////////////////////////////////////// 2022-07-18
        // Comercial da Small está perdendo dados de contatos
        if AnsiContainsText(E.Message, 'deadlock') then
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, 'Conflito L3729 ' + RightStr(E.Message, 50),0,0) // Ato, Modulo, Usuário, Histórico, Valor
        else
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy('Salvar contatos L3731 ' + E.Message, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
        /////////////////////////////////////////////// 2022-07-18
        ShowMessage('Não foi possível gravar o assunto do contato - Este registro está sendo usado por outro usuário.');
        Form7.ArquivoAberto.Cancel;
      end;
    end;

    Form7.ArquivoAberto.Edit;
  end;
end;

procedure TForm10.FormDeactivate(Sender: TObject);
begin
  try
    if form7.sModulo = 'ESTOQUE' then
    begin
      if AllTrim(form7.ibDataSet4DESCRICAO.AsString) = '' then
        Form7.ibDataSet4.Delete;
    end;
  except
  end;
end;

procedure TForm10.Label25Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  if Form7.sModulo = 'ESTOQUE' then
  begin
    with Sender as TLabel do
    begin
      sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
      Caption := sNome+':';
      Repaint;
      
      SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
      SmallIni.WriteString(Form7.sModulo,NAME,sNome);
      SmallIni.Free;
    end;
    
    Mais.LeLabels(True);
  end;
end;

procedure TForm10.Label25MouseLeave(Sender: TObject);
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  end;
end;

procedure TForm10.Label25MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  end;
end;

procedure TForm10.SMALL_DBEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form7.sAjuda)));

  if Sender.ClassType = TSMALL_DBEdit then
  begin
     if (((TSMALL_DBEdit(Sender).DataField = 'NOME')
          or (TSMALL_DBEdit(Sender).DataField = 'CGC')
          or (TSMALL_DBEdit(Sender).DataField = 'DESCRICAO'))
        and ((Form7.sModulo = 'RECEBER') or
             (Form7.sModulo = 'PAGAR') or
             (Form7.sModulo = 'CLIENTES') or
             (Form7.sModulo = 'ESTOQUE'))) then
    begin
      if (Trim(TSMALL_DBEdit(Sender).Text) = '') and (TSMALL_DBEdit(Sender).Field.OldValue <> '') then
      begin
        if not (TSMALL_DBEdit(Sender).Field.DataSet.State in [dsEdit, dsInsert]) then
          TSMALL_DBEdit(Sender).Field.DataSet.Edit;
        TSMALL_DBEdit(Sender).Text := TSMALL_DBEdit(Sender).Field.AsString;
      end;
    end;
    {Dailon (f-7225) 2023-08-17 inicio}
    if Form7.sModulo = 'ESTOQUE' then
    begin
      if ((TSMALL_DBEdit(Sender).DataField = 'REFERENCIA')
          or (TSMALL_DBEdit(Sender).DataField = 'DESCRICAO')) then
      begin
        if ((Form7.ibDataSet4DESCRICAO.AsString = EmptyStr) or ((cCadJaValidado <> Form7.ibDataSet4DESCRICAO.AsString) and (not Form7.TestarProdutoExiste(Form7.ibDataSet4DESCRICAO.AsString)))) then
        begin
          if (Copy(TSMALL_DBEdit(Sender).Text,1,1) = ' ') then
            TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
        end else
          cCadJaValidado := Form7.ibDataSet4DESCRICAO.AsString;
      end;
    end;
    {Dailon (f-7225) 2023-08-17 fim}
    {Dailon (f-7224) 2023-08-17 inicio}
    if Form7.sModulo = 'CLIENTES' then
    begin
      if ((TSMALL_DBEdit(Sender).DataField = 'ENDERE')
          or (TSMALL_DBEdit(Sender).DataField = 'COMPLE')
          or (TSMALL_DBEdit(Sender).DataField = 'EMAIL')) then
      begin
        if (Copy(TSMALL_DBEdit(Sender).Text,1,1) = ' ') then
        begin
          if not (TSMALL_DBEdit(Sender).Field.DataSet.State in [dsEdit, dsInsert]) then
          begin
            TSMALL_DBEdit(Sender).Field.DataSet.Edit;
            TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
            TSMALL_DBEdit(Sender).Field.DataSet.Post;
          end else
            TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
        end;
      end;
    end;
    {Dailon (f-7224) 2023-08-17 fim}
  end;
end;

procedure TForm10.Image5Click(Sender: TObject);
begin
  try
    while FileExists(pChar(Form10.sNomeDoJPG)) do
    begin
      DeleteFile(pChar(Form10.sNomeDoJPG));
    end;
    
    Image5.Picture.SaveToFile(Form10.sNomeDoJPG);
    
    Sleep(1000);
    
    ShellExecute( 0, 'Open',pChar(Form10.sNomeDoJPG),'','', SW_SHOWMAXIMIZED);
    
    ShowMessage('Tecle <enter> para que a nova imagem seja exibida.');
    AtualizaTela(True);    
  except
  end;
end;

procedure TForm10.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Form10.Tag := 33;
end;

procedure TForm10.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  Form10.Tag := Form10.Tag + 1;
end;

procedure TForm10.FormShow(Sender: TObject);
var
  I : Integer;
  iTop : Integer;
  tInicio : tTime;
  Hora, Min, Seg, cent : Word;
  iContadorCampoEstoque: Integer; // Sandro Silva 2022-12-20
  iTopSegundaColuna: Integer; // Sandro Silva 2022-12-20
  iTopPrimeiraColuna: Integer;
begin
  Form10.sNomeDoJPG := Form1.sAtual+'\tempo0000000000.jpg';

  Panel_branco.Width := 840; // Sandro Silva 2023-06-22

  tInicio := time;
  Form10.orelhas.Visible := False;

  eLimiteCredDisponivel.Visible   := False;
  lblLimiteCredDisponivel.Visible := False;

  try
    Form7.ibDataSet13.Edit;
  except
  end;

  Orelhas.ActivePage := Orelha_cadastro;

  Form10.Width  := 845;
  Form10.Height := 650;

  btnOK.Left  := Panel2.Width - btnOK.Width - 10;
  btnRenogiarDivida.Left  := btnOK.Left - 10 - btnRenogiarDivida.Width;

  Form7.ArquivoAberto.DisableControls;
  Form7.TabelaAberta.DisableControls;

  {Sandro Silva 2023-06-27 inicio}
  orelha_cadastro.PageIndex  :=  0;
  Orelha_PISCOFINS.PageIndex :=  3;
  ORELHA_CFOP.PageIndex      := 10;
  {Sandro Silva 2023-06-27 fim}

  Orelhas.Left   := 5;
  Orelhas.Top    := 75;
  Orelhas.Width  := Form10.Width - 15;
  Orelhas.Height := Form10.Height - Orelhas.Top - 40 + (Form1.iVista*2);

  if Screen.Width <= 800 then
  begin
    Form10.Top    := 0 + Form1.iVista;
  end;

  sRegistroVolta := Form7.ArquivoAberto.FieldByname('REGISTRO').AsString;
  sLinha         := StrZero(tStringGrid(Form7.DBGrid1).Row,4,0);
  sColuna        := StrZero(Form7.DbGrid1.SelectedIndex,2,0);

  Edit5.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit6.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit8.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit9.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit3.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit11.Color := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit10.Color := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit12.Color := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
  Edit13.Color := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];

  if Form7.sModulo = 'CLIENTES' then
  begin
    pnRelacaoComercial.Visible := True;
    pnRelacaoComercial.Top     := SMALL_DBEdit14.Top + 15;
    pnRelacaoComercial.Left    := 250;
  end else
    pnRelacaoComercial.Visible := False;

  Form10.Label45.Visible := False;

  dBGrid3.Left := 100;
  iTop         := -5;
  iTopPrimeiraColuna := iTop; // Sandro Silva 2023-07-25

  try
    VerificaSeEstaSendoUsado(True);

    bProximo := False;

    if Form7.bSoLeitura then
      dbMemo1.Enabled := False
    else
      dbMemo1.Enabled := True;
    if Form7.bSoLeitura then
      dbMemo2.Enabled := False
    else
      dbMemo2.Enabled := True;
    if Form7.bSoLeitura then
      dbMemo3.Enabled := False
    else
      dbMemo3.Enabled := True;
    if Form7.bSoLeitura then
      Form10.orelha_preco.TabVisible := False;

    if Form7.bSoLeitura then
    begin
      dbMemo1.Enabled := False;
      dbMemo2.Enabled := False;
      dbMemo3.Enabled := False;
    end else
    begin
      dbMemo1.Enabled := True;
      dbMemo2.Enabled := True;
      dbMemo3.Enabled := True;
    end;

    //------------------------------
    //Todos os LAbel não visíveis
    //-------------------------------
    for I := 0 to 30 do
      TLabel(Form10.Components[I+Label1.ComponentIndex]).Visible := False;
    for I := 0 to 30 do
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).Visible := False;

    DbGrid1.visible := False;
    DbGrid3.visible := False;
    DBMemo1.Visible := False;
    DBMemo2.Visible := False;
    //-------------------------------------------------------------------//
    //ComponentIndex descobre qual o valor do primeiro LAbel no indice   //
    //Components acessa diretamente o indice do componente é possível    //
    //inclusive mudar o valor das suas propriedades                      //
    //-------------------------------------------------------------------//
    //
    {Sandro Silva 2022-12-20 inicio}
    // Tela é dividida em abas
    // A primeira aba tem os campos distribuídos em 2 colunas
    // Dependendo do número de campos disponívies para o usuário é preciso setar a quantidade de campos que serão exibidos na tela
    iContadorCampoEstoque := 23;
    iTopSegundaColuna := 16;
    if Form7.sModulo = 'ESTOQUE' then
    begin
      iContadorCampoEstoque := 23; // Sandro Silva 2023-01-18 iContadorCampoEstoque := 24;
      iTopSegundaColuna := 16;
    end;
    {Sandro Silva 2022-12-20 fim}    
    {Sandro Silva 2023-06-22 inicio}
    if Form7.sModulo = 'RECEBER' then
      iTopSegundaColuna := 18;
    {Sandro Silva 2023-06-22 fim}
    
    if Form7.sModulo <> 'ICM' then // Não entrar no "For to do" se estiver editando o módulo ICM, o mesmo tem uma aba somente para ele, com os campos fixos, diferente dos demais módulos que monta a tela dinamicamente
    begin
      for I := 1 to Form7.iCampos do
      begin
        if Form1.CampoDisponivelParaUsuario(Form7.sModulo, Form7.ArquivoAberto.Fields[I - 1].FieldName) then
        begin
          if AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel) <> '...' then
          begin
            if not ((Form7.sModulo = 'CLIENTES') and (I >= 27)) then
            begin
              if not ((Form7.sModulo = 'ESTOQUE') and (I >= iContadorCampoEstoque)) then // Sandro Silva 2022-12-20 if not ((Form7.sModulo = 'ESTOQUE') and (I >= 23)) then
              begin

                if Form7.sModulo = 'CLIENTES' then
                  iTop := iTop + 24
                else
                  iTop := iTop + 25;

                if iTopPrimeiraColuna < 0 then
                  iTopPrimeiraColuna := iTop;

                if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') or (Form7.sModulo = 'RECEBER') then // Sandro Silva 2023-06-22 if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
                begin
                  {Sandro Silva 2023-06-22 inicio
                  if I = iTopSegundaColuna then
                    iTop := 170 - 25;
                  }
                  if I = iTopSegundaColuna then
                  begin
                    if (Form7.sModulo = 'RECEBER') then
                      iTop := iTopPrimeiraColuna // Sandro Silva 2023-07-25 iTop := iTop - 400
                    else
                      iTop := 170 - 25;
                  end;
                  {Sandro Silva 2023-06-22 fim}

                  if I = 26 then
                    iTop := 20;
                end
                else if I = 18 then
                  iTop := 15;

                if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
                begin
                  if I > 25 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 380 + 100
                  else if I > 15 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 200 + 100
                  else
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                end else if (Form7.sModulo = 'RECEBER') then // Sandro Silva 2023-06-22
                begin
                  if I > 17 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 360 + 100
                  else
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                end else
                begin
                  if I > 17 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 360 + 70
                  else
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                end;

                TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Top     := iTop;
                TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Visible := True;
                TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Caption := AllTrim(Form7.TabelaAberta.Fields[I - 1].DisplayLabel) + ':';
                TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Repaint;

                {Sandro Silva 2023-06-20 inicio}
                if (Form7.sModulo = 'RECEBER') and (Form7.TabelaAberta.Fields[I-1].FieldName = 'FORMADEPAGAMENTO') then
                  TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Caption := 'Forma de Pag.:';
                {Sandro Silva 2023-06-20 fim}

                {Sandro Silva 2023-07-24 inicio
                if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
                begin
                  if I > 25 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 380 + 100
                  else if I > 15 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 200 + 100
                  else
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                  end else if (Form7.sModulo = 'RECEBER') then // Sandro Silva 2023-06-22
                  begin
                    if I > 17 then
                      TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 360 + 100
                    else
                      TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                end else
                begin
                  if I > 17 then
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 360 + 70
                  else
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left := 0;
                end;
                }
                if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
                begin
                  if I > 25 then
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 480 + 100
                  else if I > 15 then
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 300 + 100
                  else
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 100;
                end else if (Form7.sModulo = 'RECEBER') then // Sandro Silva 2023-06-22
                begin
                  if I > 17 then
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 460 + 100
                  else
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 100;
                end else
                begin
                  if I > 17 then
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 460 + 70
                  else
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 100;

                end;
                {Sandro Silva 2023-07-24 fim}

                {Sandro Silva 2022-12-20 inicio}
                if (Form7.sModulo = 'ESTOQUE') then
                begin
                  if Form7.TabelaAberta.Fields[I-1].DisplayLabel+':' = 'Identificador Contábil:' then
                  begin
                    iTop := iTop - 25;
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Top      := iTop;
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left     := 300;
                    TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).AutoSize := True;
                  end;
                end;
                
                {Sandro Silva 2022-12-20 fim}
                if Form7.TabelaAberta.Fields[I-1].DisplayLabel+':' = 'UF:' then
                begin
                  iTop := iTop - 25;
                  TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Top                := iTop;
                  TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left               := 214;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 314;
                end;

                if (Form7.sModulo = 'CLIENTES') and (Form7.TabelaAberta.Fields[I-1].DisplayLabel+':' = 'Limite de crédito:') then
                begin
                  eLimiteCredDisponivel.Visible   := True;
                  lblLimiteCredDisponivel.Visible := True;
                  eLimiteCredDisponivel.Top       := iTop;
                  lblLimiteCredDisponivel.Top     := iTop + 1;
                end;
                
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top        :=  iTop;
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).DataField  := ''; // Evita problemas
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).DataSource := Form7.DataSourceAtual;
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).DataField  := Form7.ArquivoAberto.Fields[I - 1].Fieldname;
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Visible    := True;
                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Repaint;

                // Só leitura
                if (Form7.bSoLeitura) or (Form7.bEstaSendoUsado) or (Form7.ArquivoAberto.Fields[I-1].ReadOnly) then
                begin
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Enabled    := False;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).ReadOnly   := True;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Font.Color := clGrayText;
                end else
                begin
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Enabled    := True;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).ReadOnly   := False;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Font.Color := clWindowText;
                end;



                TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Width := (Form7.ArquivoAberto.Fields[I - 1].Displaywidth * 9) + 10;

                if TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Width > 340 then
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Width := 340;
                if (Form7.ArquivoAberto.Fields[I-1].DataType <> ftFloat) then
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).MaxLength := Form7.ArquivoAberto.Fields[I - 1].Size
                else
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).MaxLength := 22;

                if (Form7.TabelaAberta.Fields[I-1].Fieldname = 'NOME') and
                                 ((Form7.ArquivoAberto.Name = 'ibDataSet1') or
                                  (Form7.ArquivoAberto.Name = 'ibDataSet4') or
                                  (Form7.ArquivoAberto.Name = 'ibDataSet7') or
                                  (Form7.ArquivoAberto.Name = 'ibDataSet8')) then
                begin
                  try
                    dBGrid1.Top     := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top + TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Height -1;
                    dBGrid1.Font    := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Font;
                    dBGrid1.Height  := (Form7.iCampos * 25 - dBGrid1.Top) + 10;
                    if dBGrid1.Height > 145 then
                      dBGrid1.Height := 145;
                    dBGrid1.Width   := (Form7.TabelaAberta.Fields[I - 1].Displaywidth * 8) + 25; // teria que saber a largura do Scroll bar
                    // caixa
                    if Form7.sModulo = 'CAIXA' then
                    begin
                      dBGrid1.DataSource := Form7.DataSource12; // contas bancárias
                    end;

                    // contas a receber
                    if Form7.sModulo = 'RECEBER' then
                    begin
                      dBGrid1.DataSource := Form7.DataSource2; // Clientes
                    end;

                    // Contas a pagar
                    if Form7.sModulo = 'PAGAR' then
                    begin
                      dBGrid1.DataSource := Form7.DataSource2; // Fornecedores
                    end;

                    // Estoque
                    if (Form7.sModulo = 'VENDA') or
                        (Form7.sModulo = 'COMPRA') or
                         (Form7.sModulo = 'ESTOQUE') then
                    begin
                      dBGrid1.DataSource := Form7.DataSource21; // Grupos
                    end;
                  except ShowMessage('Erro 2 comunique o suporte técnico.') end;
                end;

                //Mauricio Parizotto 2023-05-29
                //Se foi setado para ReadOnly para o grid remove para editar pela tela
                if Form7.ArquivoAberto.Fields[I - 1].Tag = CAMPO_SOMENTE_LEITURA_NO_GRID then
                  Form7.ArquivoAberto.Fields[I - 1].ReadOnly := False;

                try
                  if (Form7.ArquivoAberto.Fields[I - 1].ReadOnly = True) or (Form7.bSoLeitura) or (Form7.bEstaSendoUsado) then
                  begin
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Enabled    := False;
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).ReadOnly   := True;
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Font.Color := clGrayText //clSilver//;
                  end
                  else
                  begin
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Enabled    := True;
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).ReadOnly   := False;
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Font.Color := clWindowText;
                  end;
                except
                  ShowMessage('Erro 3 comunique o suporte técnico.')
                end;

                if Form7.ArquivoAberto.Fields[I-1].Name = 'ibDataSet4FORNECEDOR' then
                begin
                  Form10.Label45.Visible := True;
                  Form10.Label45.Left    := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left + 2;
                  Form10.Label45.Top     := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top + 2;
                  Form10.Label45.Hint    := 'Este campo não pode ser alterado'+Chr(10)+
                                            'o nome do fornecedor e preenchido'+Chr(10)+
                                            'no evento da compra.';
                end;

                if Form7.ArquivoAberto.Fields[I - 1].Fieldname = 'CONTATOS' then
                begin
                  Form10.dbMemo2.DataSource := Form7.DataSourceAtual;
                  Form10.dbMemo2.DataField  := Form7.ArquivoAberto.Fields[I - 1].Fieldname;
                  Form10.dbMemo2.TabOrder   := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).TabOrder;
                  Form10.dbMemo2.Width      := 240 + 22;
                  Form10.dbMemo2.Height     := 105;
                  Form10.dbMemo2.Top        := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top;
                  Form10.dbMemo2.Left       := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left;

                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Visible := False;
                  Form10.dbMemo2.Visible    := True;


                  // Só leitura ou quando está sendo usado
                  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
                  begin
                    dbMemo2.Enabled    := False;
                    dbMemo2.Font.Color := clGrayText;
                  end else
                  begin
                    dbMemo2.Enabled := True;
                    dbMemo2.Font.Color := clWindowText;
                  end;

                  iTop := iTop + 95;
                  Form10.dbMemo1.Height := 105;
                end;

                if Form7.ArquivoAberto.Fields[I - 1].Displaywidth >= 200 then
                begin
                  Form10.dbMemo1.DataSource := Form7.DataSourceAtual;
                  Form10.dbMemo1.DataField  := Form7.ArquivoAberto.Fields[I - 1].Fieldname;
                  Form10.dbMemo1.TabOrder   := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).TabOrder;

                  if Form7.sModulo = 'ESTOQUE' then
                    Form10.dbMemo1.Width := 280
                  else
                    Form10.dbMemo1.Width := 240 + 22;

                  Form10.dbMemo1.Height := 95;
                  Form10.dbMemo1.Top    := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top;
                  Form10.dbMemo1.Left   := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left;

                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Visible := False;
                  Form10.dbMemo1.Visible := True;

                  // Só leitura ou quando está sendo usado
                  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
                  begin
                    dbMemo1.Enabled    := False;
                    dbMemo1.Font.Color := clGrayText;
                  end else
                  begin
                    dbMemo1.Enabled    := True;
                    dbMemo1.Font.Color := clWindowText;
                  end;

                  iTop := iTop + 85;
                end;
              end;
            end;
          end;
        end;
      end; // for I := 1 to Form7.iCampos do
    end; // if Form7.sModulo <> 'ICM' then

  except
    ShowMessage('Erro número  13 comunique o suporte técnico.');
  end;

  // if (Form7.sModulo = 'CLIENTES') then iTop := iTop + 15 else iTop := iTop + 30;
  Button9.Visible  := False;
  Button12.Visible := False;
  btnRenogiarDivida.Visible  := False;

  if Form7.sModulo = 'CLIENTES' then
  begin
    // Recibo
    Form7.ibQuery1.Close;
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add('select sum(VALOR_DUPL) as TOTAL from RECEBER  where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and coalesce(ATIVO,9)<>1  and Coalesce(VALOR_RECE,999999999)=0');
    Form7.IBQuery1.Open;

    if Form7.IBQuery1.FieldByname('TOTAL').AsFloat <> 0 then
    begin
      if Form1.imgVendas.Visible then
      begin
        btnRenogiarDivida.Visible := True;
      end;
    end;
  end;

  if (Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR') then
  begin
    if Form7.sModulo = 'RECEBER' then
    begin
      {Sandro Silva 2023-06-22 inicio}
      Form10.Width  := 945;
      Panel_branco.Width  := Form10.Width - 15;
      {Sandro Silva 2023-06-22 fim}      
      // Recibo
      Button9.Visible := True;
    end;

    // Replicar
    Button12.Visible := True;

    if Form7.bSoLeitura or Form7.bEstaSendoUsado then
    begin
      Button12.Enabled := False;
    end else
    begin
      Button12.Enabled := True;
    end;
  end else
  begin
    Button9.Visible := False;
    Button12.Visible := False;
  end;

  if Form7.sModulo <> 'ICM' then
  begin
    Orelhas.ActivePage := orelha_cadastro;
    if dbgComposicao.CanFocus then
      dbgComposicao.SetFocus;
  end else
  begin
    {Sandro Silva 2023-06-27 inicio}
    ORELHA_CFOP.PageIndex      := 0;
    Orelha_PISCOFINS.PageIndex := 1;
    {Sandro Silva 2023-06-27 fim}

    Orelhas.ActivePage := Orelha_CFOP;
  end;

  {Sandro Silva 2022-11-14 inicio}
  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'VENDEDOR') then
  begin
    if Form7.ibDataSet13CGC.AsString = CNPJ_SMALLSOFT then
    begin
      //Add as relações comerciais
      ComboBox8.Clear;
      ComboBox8.Items.Add('');
      ComboBox8.Items.Add('Cliente');
      ComboBox8.Items.Add('Fornecedor');
      ComboBox8.Items.Add('Cliente/Fornecedor');
      ComboBox8.Items.Add('Funcionário');
      ComboBox8.Items.Add('Revenda');
      ComboBox8.Items.Add('Representante');
      ComboBox8.Items.Add('Distribuidor');
      ComboBox8.Items.Add('Vendedor');
      ComboBox8.Items.Add('Credenciadora de cartão');
      ComboBox8.Items.Add('Instituição financeira');
      ComboBox8.Items.Add('Marketplace');
      ComboBox8.Items.Add('Revenda Inativa'); // adicionadas para uso na Smallsoft
      ComboBox8.Items.Add('Cliente Inativo'); // adicionadas para uso na Smallsoft
      ComboBox8.Sorted := True;
    end;
  end;
  {Sandro Silva 2022-11-14 fim}

  Form7.ArquivoAberto.EnableControls;
  Form7.TabelaAberta.EnableControls;

  Form10.orelhas.Visible := True;

  AtualizaTela(True);

  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);

  Label201.Hint := 'Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10);
  Label201.ShowHint := True;

  {Sandro Silva 2023-06-22 inicio} 
  Form10.Left := (Form7.Width - Form10.Width) div 2;
  Form10.Repaint;
  {Sandro Silva 2023-06-22 inicio}

  //Mauricio Parizotto 2023-08-31
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
  begin
    if edtDescricaoPerfilTrib.CanFocus then
      edtDescricaoPerfilTrib.SetFocus;
  end;
end;

procedure TForm10.Button9Click(Sender: TObject);
begin
  if Form7.ibDataSet7.FieldByName('VALOR_RECE').AsFloat <> 0 then
    Form7.fTotalDoRecibo := Form7.ibDataSet7.FieldByName('VALOR_RECE').AsFloat
  else
    Form7.fTotalDoRecibo := Form7.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat;
  Form7.sReciboProvenienteDe := 'Proveniente: dp. ' + Form7.ibDataSet7.FieldByName('DOCUMENTO').AsString + ', Referente ' + AllTrim(Form7.ibDataSet7.FieldByName('HISTORICO').AsString);
  Form7.sReciboRecebemosDe   := Form7.ibDataSet7.FieldByName('NOME').AsString;
  Form7.RECIBOClick(Sender);
end;

procedure TForm10.Button12Click(Sender: TObject);
var
  // Sandro Silva 2023-01-06 vCampo: array [1..7] of Variant; // Cria uma matriz com 6 elementos
  vCampo: array [1..7] of Variant; // Cria uma matriz com 6 elementos
  sDocumentoBaseParaSequencia: String; // Sandro Silva 2023-01-06
  //sNumeroNF: String; // Sandro Silva 2023-01-06
  sParcelaReplicada: String; // Sandro Silva 2023-01-06
begin
  Form7.iFoco := 0;
  
  with Form7 do
  begin
    if Form7.sModulo = 'RECEBER' then
    begin
      if AllTrim(ibDataSet7DOCUMENTO.AsString) <> '' then
      begin

        {Sandro Silva 2023-01-06 inicio
        if Copy(ibDataSet7DOCUMENTO.AsString,Length(Trim(ibDataSet7DOCUMENTO.AsString)),1) = '9' then
          vCampo[1] := Copy(ibDataSet7DOCUMENTO.AsString,1,Length(Trim(ibDataSet7DOCUMENTO.AsString))-1)+'A'
        else if copy(ibDataSet7DOCUMENTO.AsString,Length(Trim(ibDataSet7DOCUMENTO.AsString)),1) = 'Z' then
          vCampo[1] := Copy(ibDataSet7DOCUMENTO.AsString,1,Length(Trim(ibDataSet7DOCUMENTO.AsString))-1)+'a'
        else if copy(ibDataSet7DOCUMENTO.AsString,Length(Trim(ibDataSet7DOCUMENTO.AsString)),1) = 'z' then
          vCampo[1] := chr(Ord(ibDataSet7DOCUMENTO.AsString[1])+1)+copy(ibDataSet7DOCUMENTO.AsString,2,Length(Trim(ibDataSet7DOCUMENTO.AsString))-2)+'A'
        else
          vCampo[1] := copy(ibDataSet7DOCUMENTO.AsString,1,Length(Trim(ibDataSet7DOCUMENTO.AsString))-1) + chr(Ord(ibDataSet7DOCUMENTO.AsString[Length(Trim(ibDataSet7DOCUMENTO.AsString))])+1); // documento
        }
        sDocumentoBaseParaSequencia := Form7.ibDataSet7DOCUMENTO.AsString; // Sandro Silva 2023-01-06
        sParcelaReplicada := Form7.ibDataSet7DOCUMENTO.AsString; // Sandro Silva 2023-01-09
        {Sandro Silva 2023-01-09 inicio
        if Form1.DisponivelSomenteParaNos then
        begin
          // Identifica a última sequência de documento da nota para usar como base para definir a próxima letra do documento replicado
          if (Form7.ibDataSet7NUMERONF.AsString) <> '' then
            if UltimaParcelaReceberDaNF(Form7.ibDataSet7NUMERONF.AsString) <> '' then
            begin
              sDocumentoBaseParaSequencia := UltimaParcelaReceberDaNF(Form7.ibDataSet7NUMERONF.AsString);
              sNumeroNF := Form7.ibDataSet7NUMERONF.AsString;
            end;
        end;
        }

        if Copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = '9' then
          vCampo[1] := Copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1)+'A'
        else if copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = 'Z' then
          vCampo[1] := Copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1)+'a'
        else if copy(sDocumentoBaseParaSequencia,Length(Trim(sDocumentoBaseParaSequencia)),1) = 'z' then
          vCampo[1] := chr(Ord(sDocumentoBaseParaSequencia[1])+1)+copy(sDocumentoBaseParaSequencia,2,Length(Trim(sDocumentoBaseParaSequencia))-2)+'A'
        else
          vCampo[1] := copy(sDocumentoBaseParaSequencia,1,Length(Trim(sDocumentoBaseParaSequencia))-1) + chr(Ord(sDocumentoBaseParaSequencia[Length(Trim(sDocumentoBaseParaSequencia))])+1); // documento
        {Sandro Silva 2023-01-06 fim}

      end else
      begin
        vCampo[1] := 'A';
      end;
      vCampo[2] := ibDataSet7HISTORICO.AsString;                 // Histórico
      vCampo[3] := ibDataSet7VALOR_DUPL.AsFloat;                 // Valor
      vCampo[4] := ibDataSet7EMISSAO.AsDateTime;                 // Emissão
      vCampo[5] := SomaDias(ibDataSet7VENCIMENTO.AsDateTime,30); // Vencimento
      vCampo[6] := ibDataSet7NOME.AsString;                      // Nome do Cliente
      vCampo[7] := ibDataSet7CONTA.AsString;                     // Plano de contas
      { Incrementa o mês no historico }
      if Pos('dezembro',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'dezembro'  ,'janeiro') else
        if Pos('DEZEMBRO',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'DEZEMBRO'  ,'JANEIRO') else
          if Pos(' DEZ ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ '  ,' JAN ') else
            if Pos(' DEZ.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ.'  ,' JAN.') else
              if Pos(' dez ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez '  ,' jan ') else
                if Pos(' dez.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez.'  ,' jan.') else
                begin
                  //
                  vCampo[2] := strtran(vCampo[2],'novembro'  ,'dezembro');
                  vCampo[2] := strtran(vCampo[2],'outubro'   ,'novembro');
                  vCampo[2] := strtran(vCampo[2],'setembro'  ,'outubro');
                  vCampo[2] := strtran(vCampo[2],'agosto'    ,'setembro');
                  vCampo[2] := strtran(vCampo[2],'julho'     ,'agosto');
                  vCampo[2] := strtran(vCampo[2],'junho'     ,'julho');
                  vCampo[2] := strtran(vCampo[2],'maio'      ,'junho');
                  vCampo[2] := strtran(vCampo[2],'abril'     ,'maio');
                  vCampo[2] := strtran(vCampo[2],'março'     ,'abril');
                  vCampo[2] := strtran(vCampo[2],'fevereiro' ,'março');
                  vCampo[2] := strtran(vCampo[2],'janeiro'   ,'fevereiro');
                  //
                  vCampo[2] := strtran(vCampo[2],'NOVEMBRO'  ,'DEZEMBRO');
                  vCampo[2] := strtran(vCampo[2],'OUTUBRO'   ,'NOVEMBRO');
                  vCampo[2] := strtran(vCampo[2],'SETEMBRO'  ,'OUTUBRO');
                  vCampo[2] := strtran(vCampo[2],'AGOSTO'    ,'SETEMBRO');
                  vCampo[2] := strtran(vCampo[2],'JULHO'     ,'AGOSTO');
                  vCampo[2] := strtran(vCampo[2],'JUNHO'     ,'JULHO');
                  vCampo[2] := strtran(vCampo[2],'MAIO'      ,'JUNHO');
                  vCampo[2] := strtran(vCampo[2],'ABRIL'     ,'MAIO');
                  vCampo[2] := strtran(vCampo[2],'MARÇO'     ,'ABRIL');
                  vCampo[2] := strtran(vCampo[2],'FEVEREIRO' ,'MARÇO');
                  vCampo[2] := strtran(vCampo[2],'JANEIRO'   ,'FEVEREIRO');
                  //
                  vCampo[2] := strtran(vCampo[2],' NOV '  ,' DEZ ');
                  vCampo[2] := strtran(vCampo[2],' OUT '  ,' NOV ');
                  vCampo[2] := strtran(vCampo[2],' SET '  ,' OUT ');
                  vCampo[2] := strtran(vCampo[2],' AGO '  ,' SET ');
                  vCampo[2] := strtran(vCampo[2],' JUL '  ,' AGO ');
                  vCampo[2] := strtran(vCampo[2],' JUN '  ,' JUL ');
                  vCampo[2] := strtran(vCampo[2],' MAI '  ,' JUN ');
                  vCampo[2] := strtran(vCampo[2],' ABR '  ,' MAI ');
                  vCampo[2] := strtran(vCampo[2],' MAR '  ,' ABR ');
                  vCampo[2] := strtran(vCampo[2],' FEV '  ,' MAR ');
                  vCampo[2] := strtran(vCampo[2],' JAN '  ,' FEV ');
                  //
                  vCampo[2] := strtran(vCampo[2],' NOV.'  ,' DEZ.');
                  vCampo[2] := strtran(vCampo[2],' OUT.'  ,' NOV.');
                  vCampo[2] := strtran(vCampo[2],' SET.'  ,' OUT.');
                  vCampo[2] := strtran(vCampo[2],' AGO.'  ,' SET.');
                  vCampo[2] := strtran(vCampo[2],' JUL.'  ,' AGO.');
                  vCampo[2] := strtran(vCampo[2],' JUN.'  ,' JUL.');
                  vCampo[2] := strtran(vCampo[2],' MAI.'  ,' JUN.');
                  vCampo[2] := strtran(vCampo[2],' ABR.'  ,' MAI.');
                  vCampo[2] := strtran(vCampo[2],' MAR.'  ,' ABR.');
                  vCampo[2] := strtran(vCampo[2],' FEV.'  ,' MAR.');
                  vCampo[2] := strtran(vCampo[2],' JAN.'  ,' FEV.');
                  //
                  vCampo[2] := strtran(vCampo[2],' nov.'  ,' dez.');
                  vCampo[2] := strtran(vCampo[2],' out.'  ,' nov.');
                  vCampo[2] := strtran(vCampo[2],' set.'  ,' out.');
                  vCampo[2] := strtran(vCampo[2],' ago.'  ,' set.');
                  vCampo[2] := strtran(vCampo[2],' jul.'  ,' ago.');
                  vCampo[2] := strtran(vCampo[2],' jun.'  ,' jul.');
                  vCampo[2] := strtran(vCampo[2],' mai.'  ,' jun.');
                  vCampo[2] := strtran(vCampo[2],' abr.'  ,' mai.');
                  vCampo[2] := strtran(vCampo[2],' mar.'  ,' abr.');
                  vCampo[2] := strtran(vCampo[2],' fev.'  ,' mar.');
                  vCampo[2] := strtran(vCampo[2],' jan.'  ,' fev.');
                end;
      //
      ibDataSet7.Append;                            // Registro Novo
      ibDataSet7DOCUMENTO.asString    := vCampo[1]; // documento
      ibDataSet7HISTORICO.AsString    := vCampo[2]; // Histórico
      ibDataSet7VALOR_DUPL.AsFloat    := vCampo[3]; // Valor
      ibDataSet7EMISSAO.AsDateTime    := vCampo[4]; // Emissão
      ibDataSet7VENCIMENTO.AsDAtetime := vCampo[5]; // Vencimento
      ibDataSet7NOME.AsString         := vCampo[6]; // Nome do Cliente
      ibDataSet7CONTA.AsString        := vCampo[7]; // Plano de contas

      {Sandro Silva 2023-01-06 inicio
      if Form1.DisponivelSomenteParaNos then
      begin
        Form7.ibDataSet7NUMERONF.AsString  := sNumeroNF;
        Form7.ibDataSet7HISTORICO.AsString := Copy(Form7.ibDataSet7HISTORICO.AsString, 1, 22) + ' (ref parc ' + RightStr(sParcelaReplicada, 1) + ')';
      end;
      {Sandro Silva 2023-01-06 fim}

      ibDataSet7.Post;                              // Grava
    end;
    
    if sModulo = 'PAGAR' then
    begin
      if AllTrim(ibDataSet8DOCUMENTO.AsString) <> '' then
      begin
        if copy(ibDataSet8DOCUMENTO.AsString,Length(Trim(ibDataSet8DOCUMENTO.AsString)),1) = '9' then
          vCampo[1] := copy(ibDataSet8DOCUMENTO.AsString,1,Length(Trim(ibDataSet8DOCUMENTO.AsString))-1)+'A' else
           if copy(ibDataSet8DOCUMENTO.AsString,Length(Trim(ibDataSet8DOCUMENTO.AsString)),1) = 'Z' then
             vCampo[1] := copy(ibDataSet8DOCUMENTO.AsString,1,Length(Trim(ibDataSet8DOCUMENTO.AsString))-1)+'a'
                else vCampo[1] := copy(ibDataSet8DOCUMENTO.AsString,1,Length(Trim(ibDataSet8DOCUMENTO.AsString))-1)+ chr(Ord(ibDataSet8DOCUMENTO.AsString[Length(Trim(ibDataSet8DOCUMENTO.AsString))])+1); // documento


      end else
      begin
        vCampo[1] := 'A';
      end;
      vCampo[2] := ibDataSet8HISTORICO.AsString;                 // Histórico
      vCampo[3] := ibDataSet8VALOR_DUPL.AsFloat;                 // Valor
      vCampo[4] := ibDataSet8EMISSAO.AsDateTime;                 // Emissão
      vCampo[5] := SomaDias(ibDataSet8VENCIMENTO.AsDateTime,30); // Vencimento
      vCampo[6] := ibDataSet8NOME.AsString;                      // Nome do Cliente
      vCampo[7] := ibDataSet8CONTA.AsString;                     // Portador
      { Incrementa o mês no historico }
      if Pos('dezembro',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'dezembro'  ,'janeiro') else
        if Pos('DEZEMBRO',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],'DEZEMBRO'  ,'JANEIRO') else
          if Pos(' DEZ ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ '  ,' JAN ') else
            if Pos(' DEZ.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' DEZ.'  ,' JAN.') else
              if Pos(' dez ',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez '  ,' jan ') else
                if Pos(' dez.',vCampo[2]) <> 0 then vCampo[2] := strtran(vCampo[2],' dez.'  ,' jan.') else
                begin
                  //
                  vCampo[2] := strtran(vCampo[2],'novembro'  ,'dezembro');
                  vCampo[2] := strtran(vCampo[2],'outubro'   ,'novembro');
                  vCampo[2] := strtran(vCampo[2],'setembro'  ,'outubro');
                  vCampo[2] := strtran(vCampo[2],'agosto'    ,'setembro');
                  vCampo[2] := strtran(vCampo[2],'julho'     ,'agosto');
                  vCampo[2] := strtran(vCampo[2],'junho'     ,'julho');
                  vCampo[2] := strtran(vCampo[2],'maio'      ,'junho');
                  vCampo[2] := strtran(vCampo[2],'abril'     ,'maio');
                  vCampo[2] := strtran(vCampo[2],'março'     ,'abril');
                  vCampo[2] := strtran(vCampo[2],'fevereiro' ,'março');
                  vCampo[2] := strtran(vCampo[2],'janeiro'   ,'fevereiro');
                  //
                  vCampo[2] := strtran(vCampo[2],'NOVEMBRO'  ,'DEZEMBRO');
                  vCampo[2] := strtran(vCampo[2],'OUTUBRO'   ,'NOVEMBRO');
                  vCampo[2] := strtran(vCampo[2],'SETEMBRO'  ,'OUTUBRO');
                  vCampo[2] := strtran(vCampo[2],'AGOSTO'    ,'SETEMBRO');
                  vCampo[2] := strtran(vCampo[2],'JULHO'     ,'AGOSTO');
                  vCampo[2] := strtran(vCampo[2],'JUNHO'     ,'JULHO');
                  vCampo[2] := strtran(vCampo[2],'MAIO'      ,'JUNHO');
                  vCampo[2] := strtran(vCampo[2],'ABRIL'     ,'MAIO');
                  vCampo[2] := strtran(vCampo[2],'MARÇO'     ,'ABRIL');
                  vCampo[2] := strtran(vCampo[2],'FEVEREIRO' ,'MARÇO');
                  vCampo[2] := strtran(vCampo[2],'JANEIRO'   ,'FEVEREIRO');
                  //
                  vCampo[2] := strtran(vCampo[2],' NOV '  ,' DEZ ');
                  vCampo[2] := strtran(vCampo[2],' OUT '  ,' NOV ');
                  vCampo[2] := strtran(vCampo[2],' SET '  ,' OUT ');
                  vCampo[2] := strtran(vCampo[2],' AGO '  ,' SET ');
                  vCampo[2] := strtran(vCampo[2],' JUL '  ,' AGO ');
                  vCampo[2] := strtran(vCampo[2],' JUN '  ,' JUL ');
                  vCampo[2] := strtran(vCampo[2],' MAI '  ,' JUN ');
                  vCampo[2] := strtran(vCampo[2],' ABR '  ,' MAI ');
                  vCampo[2] := strtran(vCampo[2],' MAR '  ,' ABR ');
                  vCampo[2] := strtran(vCampo[2],' FEV '  ,' MAR ');
                  vCampo[2] := strtran(vCampo[2],' JAN '  ,' FEV ');
                  //
                  vCampo[2] := strtran(vCampo[2],' NOV.'  ,' DEZ.');
                  vCampo[2] := strtran(vCampo[2],' OUT.'  ,' NOV.');
                  vCampo[2] := strtran(vCampo[2],' SET.'  ,' OUT.');
                  vCampo[2] := strtran(vCampo[2],' AGO.'  ,' SET.');
                  vCampo[2] := strtran(vCampo[2],' JUL.'  ,' AGO.');
                  vCampo[2] := strtran(vCampo[2],' JUN.'  ,' JUL.');
                  vCampo[2] := strtran(vCampo[2],' MAI.'  ,' JUN.');
                  vCampo[2] := strtran(vCampo[2],' ABR.'  ,' MAI.');
                  vCampo[2] := strtran(vCampo[2],' MAR.'  ,' ABR.');
                  vCampo[2] := strtran(vCampo[2],' FEV.'  ,' MAR.');
                  vCampo[2] := strtran(vCampo[2],' JAN.'  ,' FEV.');
                  //
                  vCampo[2] := strtran(vCampo[2],' nov.'  ,' dez.');
                  vCampo[2] := strtran(vCampo[2],' out.'  ,' nov.');
                  vCampo[2] := strtran(vCampo[2],' set.'  ,' out.');
                  vCampo[2] := strtran(vCampo[2],' ago.'  ,' set.');
                  vCampo[2] := strtran(vCampo[2],' jul.'  ,' ago.');
                  vCampo[2] := strtran(vCampo[2],' jun.'  ,' jul.');
                  vCampo[2] := strtran(vCampo[2],' mai.'  ,' jun.');
                  vCampo[2] := strtran(vCampo[2],' abr.'  ,' mai.');
                  vCampo[2] := strtran(vCampo[2],' mar.'  ,' abr.');
                  vCampo[2] := strtran(vCampo[2],' fev.'  ,' mar.');
                  vCampo[2] := strtran(vCampo[2],' jan.'  ,' fev.');
                end;
      
      ibDataSet8.Append;                            // Registro Novo
      ibDataSet8DOCUMENTO.asString    := vCampo[1]; // documento
      ibDataSet8HISTORICO.AsString    := vCampo[2]; // Histórico
      ibDataSet8VALOR_DUPL.AsFloat    := vCampo[3]; // Valor
      ibDataSet8EMISSAO.AsDateTime    := vCampo[4]; // Emissão
      ibDataSet8VENCIMENTO.AsDAtetime := vCampo[5]; // Vencimento
      ibDataSet8NOME.AsString         := vCampo[6]; // Nome do Fornecedor
      ibDataSet8CONTA.AsString        := vCampo[7]; // Portador
      ibDataSet8.Post;                              // Grava
    end;
  end;
  
  if SMALL_DBEdit1.Visible = True then
  begin
    if SMALL_DBEdit1.CanFocus then
      SMALL_DBEdit1.SetFocus;
  end;
end;

procedure TForm10.Image203Click(Sender: TObject);
var
  F: TextFile;
  I, J: Integer;
  sA : sTring;
  fTotal1, fTotal, vQtdInicial : Double;
  dInicio, dFinal : TdateTime;
  vGrade    : array [0..19,0..19] of String; // Cria uma matriz com 100 elementos
  vCompra   : array [0..19,0..19] of String; // Cria uma matriz com 100 elementos
  bChave    : Boolean;
  iCamposVisualizar: Integer;
  vDescricaoProduto : string;

  IBQProdutoComp: TIBQuery; // Mauricio Parizotto 2023-08-07
begin
  // Não exporta se o cliente estiver em branco
  if (Form7.sModulo = 'ESTOQUE') and (AllTrim(Form7.ibDataSet4DESCRICAO.AsString) = '') then Abort;
  if (Form7.sModulo = 'CLIENTES') and (AllTrim(Form7.ibDataSet2NOME.AsString) = '') then Abort;
  if (Form7.sModulo = 'FORNECED') and (AllTrim(Form7.ibDataSet2NOME.AsString) = '') then Abort;
 
  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
 
  try
    if (Form7.sModulo = 'PAGAR') then
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet8NOME.AsString)+' ');  //
      Form7.ibDataSet2.Open;
    end;
    
    if (Form7.sModulo = 'RECEBER') then
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet7NOME.AsString)+' ');  //
      Form7.ibDataSet2.Open;
    end;
    
    if Form7.ArquivoAberto.Modified then
    begin
      Form7.ArquivoAberto.Edit;
      Form7.ArquivoAberto.Post;
      Form7.ArquivoAberto.Edit;
    end;
    
    Form7.iFoco := 0;
    
    Form7.ArquivoAberto.DisableControls;
    Form7.ibDataSet27.DisableControls;
    Form7.ibDataSet26.DisableControls;
    Form7.ibDataSet24.DisableControls;
    Form7.ibDataSet23.DisableControls;
    Form7.ibDataSet28.DisableControls;
    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet15.DisableControls;
    Form7.ibDataSet10.DisableControls;
    Form7.ibDataSet1.DisableControls;
    Form7.ibDataSet8.DisableControls;
    Form7.ibDataSet7.DisableControls;
 
    CriaJpg('logotip.jpg');
 
    Deletefile(pChar(Senhas.UsuarioPub+'.HTM'));
 
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - '+Form7.sModulo+'</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font face="Microsoft Sans Serif" size=2><b>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString))+'</b></font>');
    WriteLn(F,'<br><font face="Microsoft Sans Serif" size=2><b>'+AnsiUpperCase(Form7.Caption)+'</b></font>');
    //    WriteLn(F,'<table border=0 cellpadding=10 cellspacing=0><tr><td>');
    WriteLn(F,'<table border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td>');
    
    // Exportar
    if (Form10.Visible) or (DateToStr(Form38.DateTimePicker1.Date) = '31/12/1899') then
    begin
      dInicio := StrToDate('31/12/1899');
      dFinal  := StrToDate('30/12/2899');
    end else
    begin
      dInicio :=  Form38.DateTimePicker1.Date;
      dFinal  :=  Form38.DateTimePicker2.Date;
      dInicio := StrToDate(DateToStr(dInicio));
      dFinal  := StrToDate(DateToStr(dFinal ));
    end;

    if (Form7.sModulo = 'KARDEX') then
      Form7.IBDataSet4.First;

    bChave := True;

    while bChave do
    begin
      Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
 
      // Processa o movimento antes de imprimir a ficha pois pode alterar a qtd inicial//
      if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'KARDEX') then
      begin
        {
        Form7.ibDataSet26.Open;
        Form7.ibDataSet26.First;
        while not Form7.ibDataSet26.EOF do
        begin
          Form7.ibDataSet26.Delete;
          Form7.ibDataSet26.First;
        end;
        Form7.ibDataSet26.Append;
        Form7.ibDataSet26.FieldByName('HISTORICO').AsString := 'Quantidade inicial';


        // Compras
        Form7.ibDataSet23.Close;
        Form7.ibDataSet23.SelectSQL.Clear;
        Form7.ibDataSet23.SelectSQL.Add('select * from ITENS002 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+'');
        Form7.ibDataSet23.Open;
        Form7.ibDataSet23.First;
        
        while not Form7.ibDataSet23.EOF do
        begin
          Form7.ibDataSet24.Close;
          Form7.ibDataSet24.SelectSQL.Clear;
          Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where NUMERONF='+QuotedStr(Form7.ibDataSet23NUMERONF.AsString)+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet23FORNECEDOR.AsString) ); //+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet23FORNECEDOR.AsString)+'');
          Form7.ibDataSet24.Open;

          if Form7.ibDataSet24NUMERONF.AsString = Form7.ibDataSet23NUMERONF.AsSTring then
          begin
            if Form7.ibDataSet23QUANTIDADE.AsFloat <> 0 then
            begin
              // Posiciona a operação
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where NOME='+QuotedStr(Form7.ibDataSet24OPERACAO.AsString)+' ');
              Form7.ibDataSet14.Open;

              if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
              begin
                Form7.ibDataSet26.Append;
                Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := Form7.ibDataSet24EMISSAO.AsDateTime;
                Form7.ibDataSet26.FieldByName('DOCUMENTO').AsString  := Form7.ibDataSet24NUMERONF.AsString;
                Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Entrada de '+Form7.ibDataSet24FORNECEDOR.AsString;
                Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := Form7.ibDataSet23QUANTIDADE.AsFloat;
                Form7.ibDataSet26.FieldByName('VALOR').AsFloat       := Form7.ibDataSet23TOTAL.AsFloat;
                Form7.ibDataSet26.Post;
              end;
            end;
          end;
          Form7.ibDataSet23.Next;
        end;

        
        Form7.ibDataSet27.Close;

        Form7.ibDataSet27.SelectSQL.Text := ' Select *'+
                                            ' From ALTERACA '+
                                            ' Where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString);

        Form7.ibDataSet27.Open;
        Form7.ibDataSet27.First;

        while not Form7.ibDataSet27.Eof do
        begin
          if  (Copy(Form7.ibDataSet27TIPO.AsString,1,6) <> 'ORCAME')
          and (Copy(Form7.ibDataSet27TIPO.AsString,1,3) <> 'KIT')
          and (Copy(Form7.ibDataSet27TIPO.AsString,1,6) <> 'CANCEL') then
          begin
            if Form7.ibDataSet27VALORICM.AsFloat = 0 then
            begin
              Form7.ibDataSet26.Append;
              Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := Form7.ibDataSet27DATA.AsDateTime;
              Form7.ibDataSet26.FieldByName('DOCUMENTO').AsString  := '000'+Form7.ibDataSet27PEDIDO.AsString+'000';
              Form7.ibDataSet26.FieldByName('VALOR').AsFloat       := Form7.ibDataSet27TOTAL.AsFloat;
              
              // Venda no balcao
              if (Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'BALCAO')
                or (Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'VENDA') then
                Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := Form7.ibDataSet27QUANTIDADE.AsFloat * -1
              else
                Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := Form7.ibDataSet27QUANTIDADE.AsFloat;
              
              if Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'BALCAO' then
              begin
                if AllTrim(Form7.ibDataSet27CLIFOR.AsString) <> '' then
                  Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Venda para '+Form7.ibDataSet27CLIFOR.AsString
                else
                  Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Venda direta ao consumidor CF'+Form7.ibDataSet27PEDIDO.AsString;
              end;

              if Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'VENDA' then
              begin
                if AllTrim(Form7.ibDataSet27CLIFOR.AsString) <> '' then
                  Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'NF venda modelo 2 para '+Form7.ibDataSet27CLIFOR.AsString
                else
                  Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'NF venda Modelo 2 N: '+Form7.ibDataSet27PEDIDO.AsString;
              end;
              
              // Alteraca
              if Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'ALTERA' then
                Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Alteração na ficha do item';
              if Copy(Form7.ibDataSet27TIPO.AsString,1,6) = 'FABRIC' then
                Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Alteração na composição do item';
              // Resumo
              Form7.ibDataSet26.Post;
            end;
          end;
          Form7.ibDataSet27.Next;
        end;


        // Serviços
        Form7.ibDataSet35.Close;
        Form7.ibDataSet35.SelectSQL.Clear;
        Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+'');
        Form7.ibDataSet35.Open;
        Form7.ibDataSet35.First;

        while not Form7.ibDataSet35.Eof do
        begin
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSQL.Clear;
          Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where NUMERONF='+QuotedStr(Form7.ibDataSet35NUMERONF.AsString)+' and EMITIDA=''S'' ');
          Form7.ibDataSet15.Open;

          if Form7.ibDataSet15NUMERONF.AsString = Form7.ibDataSet35NUMERONF.AsString then
          begin
            Form7.ibDataSet26.Append;
            Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := Form7.ibDataSet15EMISSAO.AsDateTime;
            Form7.ibDataSet26.FieldByName('DOCUMENTO').AsString  := Form7.ibDataSet15NUMERONF.AsString;
            Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Saída para '+Form7.ibDataSet15CLIENTE.AsString;
            Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := (Form7.ibDataSet35QUANTIDADE.AsFloat * -1);
            Form7.ibDataSet26.FieldByName('VALOR').AsFloat       := Form7.ibDataSet35TOTAL.AsFloat;
            Form7.ibDataSet26.Post;
          end;

          Form7.ibDataSet35.Next;
        end;

        // OS
        Form7.ibDataSet16.Close;
        Form7.ibDataSet16.SelectSQL.Clear;
        Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
        Form7.ibDataSet16.Open;
        Form7.ibDataSet16.First;
        
        while not Form7.ibDataSet16.Eof do
        begin
          if AllTrim(Form7.ibDataSet16NUMERONF.AsString) = '' then
          begin
            Form7.ibDataSet26.Append;
            Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := Date;
            Form7.ibDataSet26.FieldByName('DOCUMENTO').AsString  := Right('00000000'+Form7.ibDataSet16NUMEROOS.AsString,9)+'000';
            Form7.ibDataSet26.FieldByName('VALOR').AsFloat       := Form7.ibDataSet16TOTAL.AsFloat;
            Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := Form7.ibDataSet16QUANTIDADE.AsFloat * -1;
            Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Reservado na OS aberta';
            // Tempo
            Form7.ibDataSet26.Post;
          end else
          begin
            Form7.ibDataSet15.Close;
            Form7.ibDataSet15.SelectSQL.Clear;
            Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where NUMERONF='+QuotedStr(Form7.ibDataSet16NUMERONF.AsString)+' and EMITIDA=''S'' ');
            Form7.ibDataSet15.Open;
            
            if Form7.ibDataSet15NUMERONF.AsString = Form7.ibDataSet16NUMERONF.AsSTring then
            begin
              // Posiciona a operação
              Form7.ibDataSet14.DisableControls;
              Form7.ibDataSet14.Close;
              Form7.ibDataSet14.SelectSQL.Clear;
              Form7.ibDataSet14.SelectSQL.Add('select * from ICM where NOME='+QuotedStr(Form7.ibDataSet15OPERACAO.AsString)+' ');
              Form7.ibDataSet14.Open;
              Form7.ibDataSet14.EnableControls;

              if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
              begin
                Form7.ibDataSet26.Append;
                Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := Form7.ibDataSet15EMISSAO.AsDateTime;
                Form7.ibDataSet26.FieldByName('DOCUMENTO').AsString  := Form7.ibDataSet15NUMERONF.AsString;
                Form7.ibDataSet26.FieldByName('HISTORICO').AsString  := 'Saída para '+Form7.ibDataSet15CLIENTE.AsString;
                Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := (Form7.ibDataSet16QUANTIDADE.AsFloat * -1);
                Form7.ibDataSet26.FieldByName('VALOR').AsFloat       := Form7.ibDataSet16TOTAL.AsFloat;
                Form7.ibDataSet26.Post;
              end;
            end;            
          end;
          Form7.ibDataSet16.Next;          
        end;

        // Total
        try
          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4QTD_INICIO.AsFloat := 0;
          Form7.ibDataSet4.Post;
        except
        end;

        Form7.ibDataSet26.First;

        while not Form7.ibDataSet26.EOF do
        begin
          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4QTD_INICIO.AsFloat := Form7.ibDataSet4QTD_INICIO.AsFloat + Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat;
          Form7.ibDataSet4.Post;
          Form7.ibDataSet26.Next;
        end;

        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4QTD_INICIO.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat  - Form7.ibDataSet4QTD_INICIO.AsFloat;
        Form7.ibDataSet4.Post;

        Form7.ibDataSet26.Locate('HISTORICO','Quantidade inicial',[]);
        Form7.ibDataSet26.Edit;
        Form7.ibDataSet26.FieldByName('DATA').AsDateTime     := StrToDate('01/01/1900');
        Form7.ibDataSet26.FieldByName('QUANTIDADE').AsFloat  := Form7.ibDataSet4QTD_INICIO.AsFloat;
        Form7.ibDataSet26.Post;

        }

      end;

      if (Form7.sModulo <> 'KARDEX') then
      begin
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');

        {Sandro Silva 2023-07-03 inicio} 
        iCamposVisualizar := Form7.iCampos;
        if Form7.sModulo = 'ICM' then
          iCamposVisualizar := 46; // Não dá para usar Form7.iCampos porque está definido 5 campos, aumentar pode afetar em outras rotinas. Altera aqui para ficar isolado
        {Sandro Silva 2023-07-03 fim}
        for I := 1 to iCamposVisualizar do // Sandro Silva 2023-07-03 for I := 1 to Form7.iCampos do
        begin
          if AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel) <> '...' then
          begin
            if (UpperCase(AllTrim(Form7.TabelaAberta.Fields[I-1].Name)) <> 'IBDATASET2CONTATOS') then
            begin
              if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4QTD_ATUAL') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4QTD_MINIM') then
              begin
                sA := Format('%10.'+Form1.ConfCasas+'n',[Form7.TabelaAberta.Fields[I-1].AsFloat]);
              end else
              begin
                if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4PRECO') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4CUSTOCOMPR') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4CUSTOMEDIO') then
                begin
                  sA := Format('%10.'+Form1.ConfPreco+'n',[Form7.TabelaAberta.Fields[I-1].AsFloat])
                end else
                begin
                  if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4INDEXADOR') then
                  begin
                    sA := Format('%10.4n',[Form7.TabelaAberta.Fields[I-1].AsFloat])
                  end else
                  begin
                    {Sandro Silva 2023-07-04 inicio
                    if Form7.TabelaAberta.Fields[I-1].DataType = ftString   then
                      sA := Form7.TabelaAberta.Fields[I-1].AsSTring
                    else if Form7.TabelaAberta.Fields[I-1].DataType = ftFloat then
                      sA := Format('%10.2n',[Form7.TabelaAberta.Fields[I-1].AsFloat])
                    else if Form7.TabelaAberta.Fields[I-1].DataType = ftDatetime then
                      sA := Form7.TabelaAberta.Fields[I-1].AsSTring
                    else if Form7.TabelaAberta.Fields[I-1].DataType = ftDate then
                      sA := Form7.TabelaAberta.Fields[I-1].AsSTring
                    else
                      sA := '';
                    }
                    case Form7.TabelaAberta.Fields[I-1].DataType of
                      ftString:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                      //Mauricio Parizotto 2023-07-26 Migração Alexandria
                      ftWideString:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                      ftFloat, ftBCD:
                        sA := Format('%10.2n',[Form7.TabelaAberta.Fields[I-1].AsFloat]);
                      ftDatetime, ftDate:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                    else
                      sA := '';
                    end;
                    {Sandro Silva 2023-07-04 fim}
                  end;
                end;
              end;
              
              WriteLn(F,' <tr>');
              Writeln(F,'  <td width=120 align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel)+':</td>');
              Writeln(F,'  <td width=300 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+sA+'</td>');
              Writeln(F,' </tr>');
            end;
          end;
        end;
      end;
      
      if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') then
      begin
        WriteLn(F,' <tr>');
        Writeln(F,'  <td width=120 align=Right valign=top bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Contatos:</td>');
        Writeln(F,'  <td width=300 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>');
        Writeln(F,StrTran(Form7.ibDataSet2CONTATOS.AsString,Char(10),'<br>')+'<br>');
        Writeln(F,'  </td>');
        Writeln(F,' </tr>');
      end;
      
      Writeln(F,'</table><p><p>');
      
      if Form7.sModulo = 'RECEBER' then
      begin
        if not ((Form7.sModulo = 'RECEBER')  and (AllTrim(Form7.ibDataSet7NOME.AsString) = '')) then
        begin
          WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
          for I := 1 to 23 do
          begin
            if Form7.ibDataSet2.Fields[I-1].DataType = ftString   then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            //Mauricio Parizotto 2023-07-26 Migração Alexandria
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftWideString then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftFloat then
              sA := Format('%10.2n',[Form7.ibDataSet2.Fields[I-1].AsFloat])
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftDatetime then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftDate then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else
              sA := '';
            
            WriteLn(F,' <tr>');
            Writeln(F,'  <td width=150 align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.ibDataSet2.Fields[I-1].DisplayLabel)+':</td>');
            Writeln(F,'  <td width=450 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+sA+'</td>');
            Writeln(F,' </tr><p>');
          end;
          WriteLn(F,'</table>');
        end;
      end;

      if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR') then
      begin
        if (Form7.sModulo = 'RECEBER') then
        begin
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.Selectsql.Clear;
          Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet7NOME.AsString)+' ');  //
          Form7.ibDataSet2.Open;
        end;
        
        if not ((Form7.sModulo = 'RECEBER') and (Form7.sModulo = 'PAGAR') and (AllTrim(Form7.ibDataSet7NOME.AsString) = '')) then
        begin
          fTotal := 0;
          
          // HISTÓRICO DAS VENDAS
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSQL.Clear;
          Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMITIDA=''S'' order by EMISSAO, REGISTRO');
          Form7.ibDataSet15.Open;
          
          if not Form7.ibDataSet15.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DAS VENDAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            while not (Form7.ibDataSet15.EOF) do
            begin
              if (Form7.ibDataSet15EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet15EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet16.Close;
                Form7.ibDataSet16.SelectSQL.Clear;
                Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
                Form7.ibDataSet16.Open;
                Form7.ibDataSet16.First;
                
                while not (Form7.ibDataSet16.EOF) do
                begin
                  if Form7.ibDataSet16QUANTIDADE.AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3)+'</td>'+  // Doc
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>'); // Valor
                    WriteLn(F,' </tr>');
                    fTotal := fTotal + Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat;
                  end else
                  begin
                    // Descrição no corpo da NF
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Doc
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
                    WriteLn(F,' </tr>');
                  end;
                  Form7.ibDataSet16.Next;
                end;
              end;
              Form7.ibDataSet15.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // HISTÓRICO DOS SERVICOS          
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSQL.Clear;
          Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMITIDA=''S'' ORDER BY EMISSAO, REGISTRO');
          Form7.ibDataSet15.Open;
          
          if not Form7.ibDataSet15.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DOS SERVIÇOS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>OS</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
            WriteLn(F,' </tr>');
            
            fTotal := 0;
            
            while not (Form7.ibDataSet15.EOF) do
            begin
              if (Form7.ibDataSet15EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet15EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet35.Close;
                Form7.ibDataSet35.SelectSQL.Clear;
                Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'');
                Form7.ibDataSet35.Open;
                Form7.ibDataSet35.First;
                
                while not (Form7.ibDataSet35.EOF) do
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDAtaSet15NFEPROTOCOLO.AsString+'</td>'+  // Doc
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Copy(Form7.ibDataSet35NUMEROOS.AsString,1,10)+Replicate(' ',8),1,8)    +'</td>'+  // Doc
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat])+'</td>'); // Valor
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + Form7.ibDataSet35TOTAL.AsFloat;
                  Form7.ibDataSet35.Next;
                end;
              end;
              Form7.ibDataSet15.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // vendas no balcão
          Form7.ibDataSet27.Close;
          Form7.ibDataSet27.SelectSQL.Clear;
          Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA where (CLIFOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet27.SelectSQL.Add('and (DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') and (DATA>='+QuotedStr(DateToStrInvertida(dInicio))+')');
          Form7.ibDataSet27.SelectSQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+'))');
          Form7.ibDataSet27.SelectSQL.Add('ORDER BY DATA, PEDIDO');
          Form7.ibDataSet27.Open;
          
          if not Form7.ibDataSet27.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>VENDAS NO BALCÃO</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');

            fTotal := 0;

            while not Form7.ibDataSet27.EOF do
            begin
              WriteLn(F,' <tr>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+'</td>');  // Data
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27PEDIDO.AsString+'</td>'); // Doc
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Quantidade
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27UNITARIO.AsFloat* Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Valor
              WriteLn(F,' </tr>');
              fTotal := fTotal + Form7.ibDataSet27UNITARIO.AsFloat * Form7.ibDataSet27QUANTIDADE.AsFloat;
              
              Form7.ibDataSet27.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;

          // Orçamentos
          Form7.ibDataSet37.Close;
          Form7.ibDataSet37.SelectSQL.Clear;
          Form7.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where (CLIFOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet37.SelectSQL.Add('and (DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') and (DATA>='+QuotedStr(DateToStrInvertida(dInicio))+') and (coalesce(VALORICM,0)=0)');
          Form7.ibDataSet37.Open;
          
          if not Form7.ibDataSet37.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>ORÇAMENTOS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Orçamento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            fTotal := 0;
                        
            while not Form7.ibDataSet37.EOF do
            begin
              if Form7.ibDataSet37QUANTIDADE.AsFloat <> 0 then
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet37DATA.AsDateTime)+'</td>');  // Data
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37PEDIDO.AsString+'</td>'); // Doc
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet37DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat])+'</td>'); // Quantidade
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet37UNITARIO.AsFloat* Form7.ibDataSet37QUANTIDADE.AsFloat])+'</td>'); // Valor
                WriteLn(F,' </tr>');
                fTotal := fTotal + Form7.ibDataSet37UNITARIO.AsFloat * Form7.ibDataSet37QUANTIDADE.AsFloat;
              end else
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet37DATA.AsDateTime)+'</td>');  // Data
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37PEDIDO.AsString+'</td>'); // Doc
                Writeln(F,'  <td  nowrap colspan=3 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet37DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao
                WriteLn(F,' </tr>');
              end;
              
              Form7.ibDataSet37.Next;              
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // CONTAS A RECEBER
          if not (Form1.iReduzida = 1) then
          begin
            if Form1.imgContaReceber.Visible then
            begin
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              Form7.ibDataSet99.SelectSQL.Add('select * from RECEBER where (NOME='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
              Form7.ibDataSet99.SelectSQL.Add('and (coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'') and (coalesce(ATIVO,9)<>1)');
              Form7.ibDataSet99.SelectSQL.Add('ORDER BY VENCIMENTO, DOCUMENTO');
              Form7.ibDataSet99.Open;
              
              if not Form7.ibDataSet99.Eof then
              begin
                // Contas a receber esta liberada
                fTotal  := 0;
                fTotal1 := 0;
                
                Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>CONTAS A RECEBER</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor Atual</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                
                while not Form7.ibDataSet99.Eof do
                begin
                  if Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat = 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_DUPL').AsFloat])+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_JURO').AsFloat])+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByName('VALOR_DUPL').AsFloat;
                    fTotal1 := fTotal1 + Form7.ibDataSet99.FieldByName('VALOR_JURO').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // Totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal1])+'</td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
                fTotal  := 0;
                
                // CONTAS JA RECEBIDAS
                Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>CONTAS JÁ RECEBIDAS</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor recebido</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Recebido em</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not Form7.ibDataSet99.Eof do
                begin
                  if Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat])+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('RECEBIMENT').AsDateTime)+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // Totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
              end;
            end;
          end;
          
          // COMPRAS
          fTotal := 0;
          
          // HISTÓRICO DAS COMPRAS
          Form7.ibDataSet24.Close;
          Form7.ibDataSet24.SelectSQL.Clear;
          Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where (FORNECEDOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet24.Open;
          
          if not Form7.ibDataSet24.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DAS COMPRAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            while not (Form7.ibDataSet24.EOF) do
            begin
              if (Form7.ibDataSet24EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet24EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet23.Close;
                Form7.ibDataSet23.SelectSQL.Clear;
                Form7.ibDataSet23.SelectSQL.Add('select * from ITENS002 where NUMERONF='+QuotedStr(Form7.ibDataSet24NUMERONF.AsString)+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+'');
                Form7.ibDataSet23.Open;
                Form7.ibDataSet23.First;
                
                while not (Form7.ibDataSet23.EOF) do
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet24EMISSAO.AsDateTime)      +'</td>'+  // Data
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet24NUMERONF.AsString,10,3)+'</td>'+  // Doc
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat])+'</td>'); // Valor
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat;
                  Form7.ibDataSet23.Next;
                end;
              end;
              Form7.ibDataSet24.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // Contas a Pagar
          if not (Form1.iReduzida = 1) then
          begin
            if Form1.imgContaPagar.Visible then
            begin
              // Contas a pagar esta liberada
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              Form7.ibDataSet99.SelectSQL.Add('select * from PAGAR where (NOME='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
              Form7.ibDataSet99.SelectSQL.Add('ORDER BY VENCIMENTO, DOCUMENTO');
              Form7.ibDataSet99.Open;
              
              if not Form7.IBDataSet99.Eof then
              begin
                fTotal := 0;
                Writeln(F,'<p><font face="Verdana" size=2><b>CONTAS A PAGAR</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Valor</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not (Form7.ibDataSet99.Eof) do
                begin
                  if Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat = 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat])+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
                
                // contas Pagas          
                fTotal := 0;
                Writeln(F,'<p><font face="Verdana" size=2><b>CONTAS PAGAS</b>');          
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Valor pago</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Pago em</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not (Form7.ibDataSet99.Eof) do
                begin
                  if Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat])+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('PAGAMENTO').AsDateTime)+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
              end;
            end;
          end;
        end;
      end;

      if ((Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'KARDEX')) and (Form7.ibDataSet4DESCRICAO.AsString <> '') then
      begin
        vDescricaoProduto := Form7.ibDataSet4DESCRICAO.AsString; //Mauricio Parizotto 2023-08-22

        if Form7.sModulo <> 'KARDEX' then
        begin
          //vDescricaoProduto := Form7.ibDataSet4DESCRICAO.AsString; //Mauricio Parizotto 2023-08-04

          Form7.ibDataSet10.Close;
          Form7.ibDataSet10.SelectSQL.Clear;
          Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+
                                          ' order by CODIGO, COR, TAMANHO');
          Form7.ibDataSet10.Open;
          Form7.ibDataSet10.First;

          
          if Form7.ibDataSet4CODIGO.AsString = Form7.ibDataSet10CODIGO.AsString then
          begin
            for I := 0 to 19 do for J := 0 to 19 do vGrade[I,J] := '';
            for I := 0 to 19 do for J := 0 to 19 do vCompra[I,J] := '';
            
            while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and not (Form7.ibDataSet10.EOF) do
            begin
              if AllTrim(Form7.ibDataSet10QTD.AsString) <> '' then
              begin
                if StrToInt(Form7.ibDataSet10COR.AsString) + strtoInt(Form7.ibDataSet10TAMANHO.AsString) <> 0 then
                begin
                  vGrade[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
                  vCompra[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10ENTRADAS.AsString;
                end;
              end;
              Form7.ibDataSet10.Next;
            end;
            
            WriteLn(F,'  </td><td vAlign=TOP>');
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE DAS ENTRADAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vCompra[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </table>');
            
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE DAS SAÍDAS</b>');
                
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vCompra[I,J])) - StrToFloat(LimpaNumeroDeixandoAVirgula(vGrade[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </table>');
            
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE EM ESTOQUE</b>');

            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vGrade[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </tr></table></td>');
            WriteLn(F,'    </tr>');
            WriteLn(F,'   </table></td>');
          end;
          
          // Composição
          {
          Form7.ibDataSet28.Filter   := 'CODIGO='+Form7.ibDataSet4CODIGO.AsString;
          Form7.ibDataSet28.First;

          Form7.ibDataSet28.Close;
          Form7.ibDataSet28.SelectSQL.Clear;
          Form7.ibDataSet28.SelectSQL.Add('select * from COMPOSTO where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
          Form7.ibDataSet28.Open;
          Mauricio Parizotto 2023-08-09}

          try
            IBQProdutoComp := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);
            IBQProdutoComp.Close;
            IBQProdutoComp.SQL.Text := ' Select'+
                                       '   C.DESCRICAO,'+
                                       '   C.QUANTIDADE,'+
                                       '   E.CODIGO,'+
                                       '   E.CUSTOCOMPR'+
                                       ' From COMPOSTO C'+
                                       '   Left Join ESTOQUE E on E.DESCRICAO = C.DESCRICAO'+
                                       ' Where C.CODIGO = '+QuotedStr(Form7.ibDataSet4CODIGO.AsString);
            IBQProdutoComp.Open;
          
            //if Form7.ibDataSet28CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            if not IBQProdutoComp.IsEmpty then
            begin
              Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>COMPOSIÇÃO DO PRODUTO</b>');
              WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Código</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Custo</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Custo X Qtd</td>');
              WriteLn(F,' </tr>');

              fTotal := 0;
            
              IBQProdutoComp.First;
              while not IBQProdutoComp.Eof do
              begin
                {Mauricio Parizotto 2023-08-07 Inicio
                Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet28DESCRICAO.AsString,[]);

                if  Form7.ibDataSet4DESCRICAO.AsString = Form7.ibDataSet28DESCRICAO.AsString then
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4CODIGO.AsString+'</td>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet28DESCRICAO.AsString+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet28QUANTIDADE.AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat * Form7.ibDataSet28QUANTIDADE.AsFloat])+'</td>');
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + (Form7.ibDataSet4CUSTOCOMPR.AsFloat * Form7.ibDataSet28QUANTIDADE.AsFloat);
                end;
                }

                if not IBQProdutoComp.IsEmpty then
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+IBQProdutoComp.FieldByName('CODIGO').Asstring +'</td>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+IBQProdutoComp.FieldByName('DESCRICAO').AsString+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat * IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat])+'</td>');
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + (IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat * IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat);
                end;

                IBQProdutoComp.Next;
              end;

              // Totalizador
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
              WriteLn(F,' </tr>');
              WriteLn(F,'</table>');
            end;

          finally
            FreeAndNil(IBQProdutoComp);
          end;

          //Form7.ibDataSet4.Locate('DESCRICAO',Alltrim(Form10.Caption),[]); se a tela está fechada, localiza produto errado (produto anterior)

          {Mauricio Parizotto 2023-08-07 Fim}
          
          // Imprime o arquivo em ordem de data          
          Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>MOVIMENTAÇÃO DO ITEM</b>');
        end else
        begin
          Writeln(F,'<table width=590 border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4><tr>');
          Writeln(F,'<td><font face="Microsoft Sans Serif" size=2><b>'+Form7.ibDataSet4CODIGO.AsString +' - '+ Form7.ibDataSet4DESCRICAO.AsString +'</b>');
          Writeln(F,'</tr></table>');
        end;
  
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
        WriteLn(F,'  <td Width=300 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Saldo do Estoque</td>');
        WriteLn(F,' </tr>');
        
        {Form7.ibDataSet26.Close;
        Form7.ibDataSet26.SelectSql.Clear;
        Form7.ibDataSet26.Selectsql.Add('select * from RESUMO order by DATA, REGISTRO');
        Form7.ibDataSet26.Open;}

        //Mauricio Parizotto 2023-07-17

        //Calcula quantidade inicial
        try
          vQtdInicial := ExecutaComandoEscalar(Form7.IBDatabase1,
                                               ' Select Coalesce(sum(quantidade),0) '+
                                               //' From ('+SqlSelectMovimentacaoItem(Form7.ibDataSet4DESCRICAO.AsString)+') A'); Mauricio Parizotto 2023-08-04
                                               ' From ('+SqlSelectMovimentacaoItem(vDescricaoProduto)+') A');


          vQtdInicial := Form7.ibDataSet4QTD_ATUAL.AsFloat - vQtdInicial;

          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4QTD_INICIO.AsFloat := vQtdInicial;
          Form7.ibDataSet4.Post;
        except
          vQtdInicial := 0;
        end;

        Form7.IBDataSet97.Close;
        //Form7.IBDataSet97.SelectSQL.Text := SqlSelectMovimentacaoItem(Form7.ibDataSet4DESCRICAO.AsString);  Mauricio Parizotto 2023-08-04
        Form7.IBDataSet97.SelectSQL.Text := SqlSelectMovimentacaoItem(vDescricaoProduto);
        Form7.IBDataSet97.DisableControls;
        Form7.IBDataSet97.Open;


        fTotal := vQtdInicial;

        while not Form7.IBDataSet97.EOF do
        begin
          fTotal := fTotal + Form7.IBDataSet97.FieldByName('QUANTIDADE').AsFloat;
          if Form7.IBDataSet97.FieldByName('HISTORICO').AsString <> 'Quantidade inicial' then
          begin
            WriteLn(F,' <tr>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.IBDataSet97.FieldByName('DATA').AsDateTime)+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.IBDataSet97.FieldByname('DOCUMENTO').AsString,1,9)+'/'+Copy(Form7.IBDataSet97.FieldByname('DOCUMENTO').AsString,10,3)+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.IBDataSet97.FieldByName('HISTORICO').AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.IBDataSet97.FieldByName('VALOR').AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.IBDataSet97.FieldByName('QUANTIDADE').AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
          end;
          Form7.IBDataSet97.Next;
        end;

        // Totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');


        Form7.IBDataSet97.EnableControls;
      end;

      // Fecha o arquivo
      if Form7.sModulo = 'CONTAS' then
      begin
        Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
        Writeln(F,Form7.ibDataSet12NOME.AsString);
        if Form7.dbGrid1.SelectedField.FieldName = 'CONTA' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'NOME' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'SALDO' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'DIA' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO DIA '+DateToStr(Form38.MonthCalendar1.Date)+'</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'MES' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO MÊS '+IntToStr(Month(Form38.MonthCalendar1.Date))+'/'+IntToStr(Year(Form38.MonthCalendar1.Date))+'</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'ANO' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO ANO DE '+IntToStr(Year(Form38.MonthCalendar1.Date))+'</b>');

        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Entrada</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Saída</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet1.First;
        
        fTotal  := 0; fTotal1 := 0;
        
        while not Form7.ibDataSet1.EOF do
        begin
          if Form7.ibDataSet12NOME.AsString = Form7.ibDataSet1NOME.AsString then
          begin
            if
            (((Form7.dbGrid1.SelectedField.FieldName = 'DIA') and (Form7.ibDataSet1DATA.AsDateTime = Form38.MonthCalendar1.Date)))
            or
            (((Form7.dbGrid1.SelectedField.FieldName = 'MES') and (Month(Form7.ibDataSet1DATA.AsDateTime) = Month(Form38.MonthCalendar1.Date)))
                   and (Year(Form7.ibDataSet1DATA.AsDateTime) = Year(Date)))
            or
            (((Form7.dbGrid1.SelectedField.FieldName = 'ANO') and (Year(Form7.ibDataSet1DATA.AsDateTime) = Year(Form38.MonthCalendar1.Date))))
            or
            (Form7.dbGrid1.SelectedField.FieldName = 'CONTA')
            or
            (Form7.dbGrid1.SelectedField.FieldName = 'NOME') then
            begin
              WriteLn(F,' <tr>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet1DATA.AsDateTime)+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.ibDataSet1HISTORICO.AsString)+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[Form7.ibDataSet1ENTRADA.AsFloat])+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[Form7.ibDataSet1SAIDA.AsFloat])+'</td>');
              WriteLn(F,' </tr>');
              fTotal  := fTotal + Form7.ibDataSet1ENTRADA.AsFloat;
              fTotal1 := fTotal1 + Form7.ibDataSet1SAIDA.AsFloat;
            end;
          end;
          
          Form7.ibDataSet1.Next;
        end;
        
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal])+'</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal1])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        
        Screen.Cursor := crDefault; // Cursor normal
        Form7.sModulo := 'CONTAS';
        Form7.DBGrid1.Repaint;
      end;
      
      if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'OS') then
      begin
        fTotal := 0;
        
        // Descrição dos itens
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos itens</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Unitário</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet16.First;
        
        while not (Form7.ibDataSet16.EOF) do
        begin
          if Form7.ibDataSet16QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet16QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat]  ) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          Form7.ibDataSet16.Next;
        end;
        
        // totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table><br>');
        
        fTotal := 0;
        
        // Descrição dos serviços
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos serviços</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+ Form7.ibDataSet35TECNICO.DisplayLabel +'</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet35.First;
        
        while not (Form7.ibDataSet35.EOF) do
        begin
          if Form7.ibDataSet35QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35TECNICO.AsString+Replicate(' ',20),1,20)                       +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet35QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35UNITARIO.AsFloat * Form7.ibDataSet35QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet35UNITARIO.AsFloat * Form7.ibDataSet35QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          
          Form7.ibDataSet35.Next;
        end;
        
        // totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
      end;
      
      if (Form7.sModulo = 'COMPRA') then
      begin
        fTotal := 0;
        
        // Descrição dos itens
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos itens</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Unitário</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet23.First;
        
        while not (Form7.ibDataSet23.EOF) do
        begin
          if Form7.ibDataSet23QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet23QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat]  ) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          Form7.ibDataSet23.Next;
        end;

        // totalizador        
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table><br>');
      end;
      
      if (Form7.sModulo = 'KARDEX') then
      begin
        Form7.IBDataSet4.Next;
        if Form7.ibDataSet4.Eof then bChave := False;
      end else
      begin
        bChave := False;
      end;
    end;
    
    if dInicio <> StrToDate('31/12/1899') then if (Form7.sModulo <> 'ESTOQUE') and (Form7.sModulo <> 'KARDEX') then Writeln(F,'<center><font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br></center>');
    WriteLn(F,'</center><center><br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');

    // WWW
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;

    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');

    CloseFile(F);
  except
    CloseFile(F);
  end;
  
  try
    Form7.ArquivoAberto.EnableControls;
    Form7.ibDataSet4.EnableControls;
    Form7.ibDataSet27.EnableControls;
    Form7.ibDataSet26.EnableControls;
    Form7.ibDataSet24.EnableControls;
    Form7.ibDataSet23.EnableControls;
    Form7.ibDataSet28.EnableControls;
    Form7.ibDataSet16.EnableControls;
    Form7.ibDataSet15.EnableControls;
    Form7.ibDataSet10.EnableControls;
    Form7.ibDataSet1.EnableControls;
    Form7.ibDataSet8.EnableControls;
    Form7.ibDataSet7.EnableControls;
  except 
  end;
  
  if ((Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'KARDEX')) then
  begin
    {Form7.ibDataSet26.Open;
    Form7.ibDataSet26.First;
    while not Form7.ibDataSet26.EOF do
    begin
      Form7.ibDataSet26.Delete;
      Form7.ibDataSet26.First;
    end;}
    
    Form7.Close;
    Form7.Show;
    
    try
      Form7.ibDataSet28.Open;
      Form7.ibDataSet4.EnableControls;
    except end;
  end;
  
  AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
  
  Screen.Cursor             := crDefault;              // Cursor de Aguardo
end;

procedure TForm10.Button11Click(Sender: TObject);
begin
  Form10.Image203Click(Sender);
end;

procedure TForm10.Button13Click(Sender: TObject);
var
  jp : TJPEGImage;
begin
  if Button13.Caption <> '&Captura' then
  begin
    try
      VideoCap1.visible    := True;
      Image5.Visible       := False;
      VideoCAp1.Left       := 5;
      VideoCAp1.Top        := 5;
      
      VideoCAp1.Width      := 640;
      VideoCAp1.Height     := 480;
      
      VideoCap1.visible    := True;
      
      try
        Videocap1.DriverIndex := 0;
      except 
      end;
      
      try
        VideoCap1.VideoPreview := True;
        VideoCap1.CapAudio     := False;
      except end;
      
      Button13.Caption := '&Captura';      
    except 
    end;
  end else
  begin
    try
      VideoCap1.SaveToClipboard;
      Image5.Picture.Bitmap.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
      VideoCap1.VideoPreview := False;
      VideoCap1.visible      := False;
      
      jp := TJPEGImage.Create;
      jp.Assign(Form10.Image5.Picture.Bitmap);
      jp.CompressionQuality := 100;
      
      jp.SaveToFile(Form10.sNomeDoJPG);
      
      Button13.Caption     := '&Webcam';
      Image5.Visible       := True;

      {Sandro Silva 2023-01-24 inicio}
      while not FileExists(pChar(Form10.sNomeDoJPG)) do
      begin
        Sleep(100);
      end;

      Form10.Image3.Picture.LoadFromFile(pChar(Form10.sNomeDoJPG));
      Form10.Image5.Picture.LoadFromFile(pChar(Form10.sNomeDoJPG));
      //
      AtualizaTela(True);
      {Sandro Silva 2023-01-24 fim}
    except end;
  end;
end;

procedure TForm10.Label18MouseLeave(Sender: TObject);
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  end;
end;

procedure TForm10.Label18MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  end;
end;

procedure TForm10.Label18Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    with Sender as TLabel do
    begin
      sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
      Caption := sNome+':';
      Repaint;
      
      SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
      SmallIni.WriteString(Form7.sModulo,NAME,sNome);
      SmallIni.Free;
    end;
    
    Mais.LeLabels(True);    
  end;
end;

procedure TForm10.Orelha_gradeShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
  I, J : Integer;
  bChave : Boolean;
begin
  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
  begin
    StringGrid1.Enabled := False;
  end else
  begin
    StringGrid1.Enabled := True;
  end;
  
  StringGrid1.Col := 0;
  StringGrid1.Row := 0;

  begin
    StringGrid1.RowCount := 20;
    
    StringGrid1.Col := 1;
    StringGrid1.Row := 1;
    
    for I := 0 to 19 do
     for J := 0 to 19 do
       StringGrid1.Cells[I,J] := '';
    
    Form10.Caption := form7.ibDataSet4DESCRICAO.AsString;
    Form10.StringGrid1.Repaint;
    
    bChave := True;
    
    Form7.ibDataSet10.DisableControls;
    Form7.ibDataSet10.Close;
    Form7.ibDataSet10.SelectSQL.Clear;
    Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by CODIGO, COR, TAMANHO');
    Form7.ibDataSet10.Open;
    Form7.ibDataSet10.First;
    
    while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and not (Form7.ibDataSet10.EOF) do
    begin
      if AllTrim(Form7.ibDataSet10QTD.AsString) <> '' then
      begin
        if StrToInt(Form7.ibDataSet10COR.AsString) + strtoInt(Form7.ibDataSet10TAMANHO.AsString) <> 0 then
        begin
          Form10.StringGrid1.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
          bChave := False;
        end;
      end;
      Form7.ibDataSet10.Next;
    end;
    
    if bChave then
    begin
      // Lê os dados a partir de um .ini
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      for I := 1 to 19 do Form10.StringGrid1.Cells[0,I] := Mais1Ini.ReadString('Grade',pChar('X'+StrZero(I,2,0)),'');
      for I := 1 to 19 do Form10.StringGrid1.Cells[I,0] := Mais1Ini.ReadString('Grade',pChar('Y'+StrZero(I,2,0)),'');
      Mais1ini.Free;
    end;
  end;
end;

procedure TForm10.orelha_serialShow(Sender: TObject);
begin
  if CheckBox1.CanFocus then CheckBox1.SetFocus;
  
  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
  begin
    dbGrid4.ReadOnly    := True;
    CheckBox1.Enabled   := False;
  end else
  begin
    dbGrid4.ReadOnly    := False;
    CheckBox1.Enabled   := True;
  end;
  
  StringGrid1.Col := 0;
  StringGrid1.Row := 0;
  
  if (Form10.Caption <> Form7.ibDataSet4DESCRICAO.AsString) or (AllTrim(form7.ibDataSet4DESCRICAO.AsString) = '')  then
  begin
    Form10.Caption := Form7.ibDataSet4DESCRICAO.AsString;
  end;
  
  if Form7.ibDataSet4.FieldByname('SERIE').Value = 1 then
  begin
    Form10.CheckBox1.Checked := True;
    Form7.ibDataSet30.Active     := False;
    Form7.ibDataSet30.Active     := True;
    DBGrid4.Visible          := True;
    Button15.Visible         := True;
    Button16.Visible         := True;
    Button17.Visible         := True;
  end else
  begin
    Form10.CheckBox1.Checked := False;
    Form7.ibDataSet30.Active     := False;
    Form7.ibDataSet30.Active     := True;
    DBGrid4.Visible          := False;
    Button15.Visible         := False;
    Button16.Visible         := False;
    Button17.Visible         := False;
  end;
  
  Form7.ibDataSet30.Last;
end;

procedure TForm10.orelha_fotoShow(Sender: TObject);
begin
  // Nome certo da imagem
  if Form7.sModulo = 'ESTOQUE' then
  begin
    Form10.sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet4REGISTRO.AsString+'.jpg';
  end else
  begin
    if Form7.sModulo = 'GRUPOS' then
    begin
      Form10.sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet21REGISTRO.AsString+'.jpg';
    end else
    begin
      Form10.sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet2REGISTRO.AsString+'.jpg';
    end;
  end;
  
  Button13.Caption       := '&Webcam';
  VideoCap1.visible      := False;
  Image5.Visible         := True;

  if not Form7.bSoLeitura then
  begin
    Orelhas.ActivePage := orelha_cadastro;
    if dbgComposicao.CanFocus then dbgComposicao.SetFocus;
  end;
  
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    Button7.Visible := True;
  end else
  begin
    Button7.Visible := False;
  end;
end;

procedure TForm10.orelha_composicaoShow(Sender: TObject);
var
  sCodigo : STring;
  fCusto  : Real;
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    try
      sCodigo := Form7.ibDataSet4CODIGO.AsString;
      
      Form7.ibDataSet25ACUMULADO1.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet25ACUMULADO1.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      Form7.ibDataSet25ACUMULADO2.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
      Form7.ibDataSet25ACUMULADO2.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
      
      Form7.ibDataSet28.DisableControls;
      
      Form7.ibDataSet28.Close;
      Form7.ibDataSet28.SelectSQL.Clear;
      Form7.ibDataSet28.SelectSQL.Add('select * from COMPOSTO where CODIGO='+QuotedStr(sCodigo)+' ');
      Form7.ibDataSet28.Open;
      
      Form7.ibDataSet25.Append;
      Form7.ibDataSet25ACUMULADO2.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat; // them que calcular o menor quantidade dividido pelo que vai
      
      fQuantidade      := 9999999999;
      fCusto           := 0;
      
      Button10.Enabled := False;
      Button8.Enabled  := False;
      
      Form7.ibDataSet28.First;
      while not Form7.ibDataSet28.Eof do
      begin
        Form7.ibQuery4.Close;
        Form7.ibQuery4.Sql.Clear;
        Form7.ibQuery4.SQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet28DESCRICAO.AsString)+' ');
        Form7.ibQuery4.Open;
        
        if (Form7.ibQuery4.FieldByName('DESCRICAO').AsString = Form7.ibDataSet28DESCRICAO.AsString) and (AllTrim(Form7.ibDataSet28DESCRICAO.AsString) <> '') then
        begin
          if fQuantidade > (Form7.ibQuery4.FieldByName('QTD_ATUAL').AsFloat / Form7.ibDataSet28QUANTIDADE.AsFloat)  then
          begin
            Form7.ibDataSet25.Edit;
            fQuantidade := Form7.ibQuery4.FieldByName('QTD_ATUAL').AsFloat / Form7.ibDataSet28QUANTIDADE.AsFloat;
          end;
        
          fCusto := fCusto + (Form7.ibQuery4.FieldByName('CUSTOCOMPR').AsFloat * Form7.ibDataSet28QUANTIDADE.AsFloat);
        
          if Form7.bSoLeitura or Form7.bEstaSendoUsado then
          begin
            Button10.Enabled := False;
            Button8.Enabled  := False;
          end else
          begin
            Button10.Enabled := True;
            Button8.Enabled  := True;
          end;          
        end else
        begin
          Form7.ibDataSet28.Edit;
          Form7.ibDataSet28DESCRICAO.AsString := '';
          Form7.ibDataSet28CODIGO.AsString    := '';
        end;
        
        Form7.ibDataSet28.Next;
      end;
      
      Form7.ibDataSet25.Edit;
      if fQuantidade = 9999999999 then Form7.ibDataSet25ACUMULADO1.AsFloat := 0 else Form7.ibDataSet25ACUMULADO1.AsFloat := fQuantidade;
      
      if Button10.Enabled then
      begin
        try
          if not (Form7.bSoLeitura or Form7.bEstaSendoUsado) then
          begin
            Form7.ibDataSet4.Edit;
            Form7.ibDataSet4CUSTOCOMPR.AsFloat := fCusto; // Só atualiza o custo de produtos compostos
          end;
        except end;
      end;
    except end;
    
    Form7.ibDataSet28.EnableControls;
  end;
end;

procedure TForm10.orelha_ICMSShow(Sender: TObject);
var
  I : Integer;
begin
  // Antes de tudo Zera os combos
  ComboBox1.ItemIndex := -1;
  cboCST_Prod.ItemIndex := -1;
  cboOrigemProd.ItemIndex := -1;
  cboCSOSN_Prod.ItemIndex := -1;
  ComboBox5.ItemIndex := -1;
  ComboBox6.ItemIndex := -1;
  ComboBox7.ItemIndex := -1;
  ComboBox9.ItemIndex := -1;
  ComboBox10.ItemIndex := -1;
  ComboBox11.ItemIndex := -1;
  
  ComboBox14.ItemIndex := -1;
  ComboBox15.ItemIndex := -1;
  
  VerificaSeEstaSendoUsado(True);
  
  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
  begin
    ComboBox1.Enabled := False;
    cboCST_Prod.Enabled := False;
    cboOrigemProd.Enabled := False;
    cboCSOSN_Prod.Enabled := False;
    ComboBox5.Enabled := False;
    ComboBox6.Enabled := False;
    ComboBox7.Enabled := False;
    ComboBox9.Enabled := False;
    ComboBox10.Enabled := False;
    ComboBox11.Enabled := False;
    
    ComboBox14.Enabled := False;
    ComboBox15.Enabled := False;
    
    SMALL_DBEdit31.Enabled    := False;
    SMALL_DBEdit37.Enabled    := False;
    SMALL_DBEdit38.Enabled    := False;
    SMALL_DBEdit41.Enabled    := False;
    dbepPisSaida.Enabled      := False;
    dbepPisEntrada.Enabled    := False;
    dbepCofinsSaida.Enabled   := False;
    dbepCofinsEntrada.Enabled    := False;

    SMALL_DBEdit31.ReadOnly   := true;
    SMALL_DBEdit37.ReadOnly   := true;
    SMALL_DBEdit38.ReadOnly   := true;
    SMALL_DBEdit41.ReadOnly   := true;
    dbepPisSaida.ReadOnly     := true;
    dbepPisEntrada.ReadOnly   := true;
    dbepCofinsSaida.ReadOnly  := true;
    dbepCofinsEntrada.ReadOnly   := true;

    SMALL_DBEdit31.Font.Color := clGrayText;
    SMALL_DBEdit37.Font.Color := clGrayText;
    SMALL_DBEdit38.Font.Color := clGrayText;
    SMALL_DBEdit41.Font.Color := clGrayText;
    dbepPisSaida.Font.Color   := clGrayText;
    dbepPisEntrada.Font.Color := clGrayText;
    dbepCofinsSaida.Font.Color := clGrayText;
    dbepCofinsEntrada.Font.Color := clGrayText;
  end else
  begin
    ComboBox1.Enabled := True;
    cboCST_Prod.Enabled := True;
    cboOrigemProd.Enabled := True;
    cboCSOSN_Prod.Enabled := True;
    ComboBox5.Enabled := True;
    ComboBox6.Enabled := True;
    ComboBox7.Enabled := True;
    ComboBox9.Enabled := True;
    ComboBox10.Enabled := True;
    ComboBox11.Enabled := True;
    
    ComboBox14.Enabled := True;
    ComboBox15.Enabled := True;
    
    SMALL_DBEdit31.Enabled    := True;
    SMALL_DBEdit37.Enabled    := True;
    SMALL_DBEdit38.Enabled    := True;
    SMALL_DBEdit41.Enabled    := True;
    dbepPisSaida.Enabled      := True;
    dbepPisEntrada.Enabled    := True;
    dbepCofinsSaida.Enabled   := True;
    dbepCofinsEntrada.Enabled    := True;
    
    SMALL_DBEdit31.ReadOnly   := False;
    SMALL_DBEdit37.ReadOnly   := False;
    SMALL_DBEdit38.ReadOnly   := False;
    SMALL_DBEdit41.ReadOnly   := False;
    dbepPisSaida.ReadOnly     := False;
    dbepPisEntrada.ReadOnly   := False;
    dbepCofinsSaida.ReadOnly  := False;
    dbepCofinsEntrada.ReadOnly   := False;
    
    SMALL_DBEdit31.Font.Color  := ClWindowText;
    SMALL_DBEdit37.Font.Color  := ClWindowText;
    SMALL_DBEdit38.Font.Color  := ClWindowText;
    SMALL_DBEdit41.Font.Color  := ClWindowText;
    dbepPisSaida.Font.Color    := ClWindowText;
    dbepPisEntrada.Font.Color  := ClWindowText;
    dbepCofinsSaida.Font.Color := ClWindowText;
    dbepCofinsEntrada.Font.Color  := ClWindowText;
  end;
  
  // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
  begin
    {Mauricio Parizotto 2023-09-04 Inicio
    if Form7.sModulo = 'ESTOQUE' then
    begin
      if AllTrim(Form7.IbDataSet4ST.AsString) <> '' then
      begin
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Clear;
        Form7.ibDataSet14.SelectSQL.Add('select * FROM ICM where ST='+QuotedStr(Form7.IbDataSet4ST.AsString)+' ');
        Form7.ibDataSet14.Open;
      end else
      begin
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Clear;
        Form7.ibDataSet14.SelectSQL.Add('select * FROM ICM where CFOP='+QuotedStr('5102')+' or CFOP='+QuotedStr('5101')+' ');
        Form7.ibDataSet14.Open;
      end;

      if Alltrim(Form7.ibDataSet14CFOP.AsString) <> '' then
      begin
        lblCIT.Caption := Form7.ibDataSet14CFOP.AsString + ' - ' + Form7.ibDataSet14NOME.AsString;
      end else
      begin
        lblCIT.Caption := Form7.ibDataSet14NOME.AsString;
      end;
    end;
 
    Form7.ibDataSet14.Edit;

    _RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
    _AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
    _AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
    _PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
    _MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
    _AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
    _RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
    _MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
    _TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
    _CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
    _RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
    _PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
    _PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
    _PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
    _AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
    _SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
    _BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
    _GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
    _DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
    _MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
    _ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
    _MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
    _SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
    _RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
    _PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
    _SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
    _RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
 
    _RR.font.size := 8;
    _AP.font.size := 8;
    _AM.font.size := 8;
    _PA.font.size := 8;
    _MA.font.size := 8;
    _AC.font.size := 8;
    _RO.font.size := 8;
    _MT.font.size := 8;
    _TO.font.size := 8;
    _CE.font.size := 8;
    _RN.font.size := 8;
    _PI.font.size := 8;
    _PB.font.size := 8;
    _PE.font.size := 8;
    _AL.font.size := 8;
    _SE.font.size := 8;
    _BA.font.size := 8;
    _GO.font.size := 8;
    _DF.font.size := 8;
    _MG.font.size := 8;
    _ES.font.size := 8;
    _MS.font.size := 8;
    _SP.font.size := 8;
    _RJ.font.size := 8;
    _PR.font.size := 8;
    _SC.font.size := 8;
    _RS.font.size := 8;
 
    if Form7.ibDataSet13ESTADO.AsString = 'RR' then _RR.Font.Color := clRed else _RR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AP' then _AP.Font.Color := clRed else _AP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AM' then _AM.Font.Color := clRed else _AM.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PA' then _PA.Font.Color := clRed else _PA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MA' then _MA.Font.Color := clRed else _MA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AC' then _AC.Font.Color := clRed else _AC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RO' then _RO.Font.Color := clRed else _RO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MT' then _MT.Font.Color := clRed else _MT.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'TO' then _TO.Font.Color := clRed else _TO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'CE' then _CE.Font.Color := clRed else _CE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RN' then _RN.Font.Color := clRed else _RN.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PI' then _PI.Font.Color := clRed else _PI.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PB' then _PB.Font.Color := clRed else _PB.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PE' then _PE.Font.Color := clRed else _PE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AL' then _AL.Font.Color := clRed else _AL.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SE' then _SE.Font.Color := clRed else _SE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'BA' then _BA.Font.Color := clRed else _BA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'GO' then _GO.Font.Color := clRed else _GO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'DF' then _DF.Font.Color := clRed else _DF.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MG' then _MG.Font.Color := clRed else _MG.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'ES' then _ES.Font.Color := clRed else _ES.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MS' then _MS.Font.Color := clRed else _MS.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then _SP.Font.Color := clRed else _SP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RJ' then _RJ.Font.Color := clRed else _RJ.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PR' then _PR.Font.Color := clRed else _PR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then _SC.Font.Color := clRed else _SC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RS' then _RS.Font.Color := clRed else _RS.Font.Color := clSilver;
    }

    CarregaCit;

    {Mauricio Parizotto 2023-09-04 Fim}
  end;
 
  if Form7.ibDataSet13CRT.AsString = '1' then
  begin
    Form10.Label36.Visible          := True;
    cboCSOSN_Prod.Visible        := True;
    Form10.Label37.Visible          := False;
    cboCST_Prod.Visible        := False;
 
    Form10.Label72.Visible          := True;
    Form10.ComboBox15.Visible       := True;
    Form10.Label84.Visible          := False;
    Form10.ComboBox14.Visible       := False;
  end else
  begin
    Form10.Label36.Visible          := False;
    cboCSOSN_Prod.Visible        := False;
    Form10.Label37.Visible          := True;
    cboCST_Prod.Visible        := True;
  
    Form10.Label72.Visible          := False;
    Form10.ComboBox15.Visible       := False;
    Form10.Label84.Visible          := True;
    Form10.ComboBox14.Visible       := True;
  end;
  
  if Form7.ibDataSet13ESTADO.AsString = 'SP' then
  begin
    Label83.Caption := StrTran(Label83.Caption,'NFC-e','SAT');
    Label84.Caption := StrTran(Label84.Caption,'NFC-e','SAT');
    Label92.Caption := StrTran(Label92.Caption,'NFC-e','SAT');
    Label72.Caption := StrTran(Label72.Caption,'NFC-e','SAT');
  end else
  begin
    Label83.Caption := StrTran(Label83.Caption,'SAT','NFC-e');
    Label84.Caption := StrTran(Label84.Caption,'SAT','NFC-e');
    Label92.Caption := StrTran(Label92.Caption,'SAT','NFC-e');
    Label72.Caption := StrTran(Label72.Caption,'SAT','NFC-e');
  end;

  if Form7.sModulo = 'ESTOQUE' then
  begin
    Form7.ibDataSet4.Edit;
    // P - Produção própria
    // T - Produção por terceiros

    for I := 0 to Form10.ComboBox5.Items.Count -1 do
    begin
      if Copy(Form10.ComboBox5.Items[I],1,1) = UpperCase(AllTrim(Form7.ibDataSet4IPPT.AsString)) then
      begin
        Form10.ComboBox5.ItemIndex := I;
      end;
    end;

    // A - Arredondamento
    // T - Truncamento

    for I := 0 to Form10.ComboBox6.Items.Count -1 do
    begin
      if Copy(Form10.ComboBox6.Items[I],1,1) = UpperCase(AllTrim(Form7.ibDataSet4IAT.AsString)) then
      begin
        Form10.ComboBox6.ItemIndex := I;
      end;
    end;





    // 101 - Tributada pelo Simples Nacional com permissão de crédito
    // 102 - Tributada pelo Simples Nacional sem permissão de crédito
    // 103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta
    // 201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária
    // 202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária
    // 203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária
    // 300 - Imune
    // 400 - Não tributada pelo Simples Nacional
    // 500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
    // 900 - Outros
    //
    if AllTrim(Form7.ibDataSet4CSOSN.AsString)<>'' then
    begin
      for I := 0 to cboCSOSN_Prod.Items.Count -1 do
      begin

        {Sandro Silva 2023-05-09 inicio
        if Copy(Form10.ComboBox4.Items[I],1,3) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN.AsString)) then
        begin
          Form10.ComboBox4.ItemIndex := I;
        end;
        }




        // Com a inclusão do valor 61 - Tributação monofásica sobre combustíveis cobrado anteriormente nos CSOSN precisa mudar aqui onde seleciona o valor do combo
        if Trim(Form7.ibDataSet4CSOSN.AsString) <> '' then
        begin
          if Copy(cboCSOSN_Prod.Items[I],1, Length(Trim(Form7.ibDataSet4CSOSN.AsString))) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN.AsString)) then
          begin
            cboCSOSN_Prod.ItemIndex := I;
          end;
        end;

      end;
    end;






    // 101 - Tributada pelo Simples Nacional com permissão de crédito
    // 102 - Tributada pelo Simples Nacional sem permissão de crédito
    // 103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta
    // 201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária
    // 202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária
    // 203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária
    // 300 - Imune
    // 400 - Não tributada pelo Simples Nacional
    // 500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
    // 900 - Outros
    //
    if AllTrim(Form7.ibDataSet4CSOSN_NFCE.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox15.Items.Count -1 do
      begin
        //
        {Sandro Silva 2023-05-09 inicio
        if Copy(Form10.ComboBox15.Items[I],1,3) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN_NFCE.AsString)) then
        begin
          Form10.ComboBox15.ItemIndex := I;
        end;
        }


        // Com a inclusão do valor 61 - Tributação monofásica sobre combustíveis cobrado anteriormente nos CSOSN precisa mudar aqui onde seleciona o valor do combo
        if Trim(Form7.ibDataSet4CSOSN_NFCE.AsString) <> '' then
        begin


          if Copy(Form10.ComboBox15.Items[I],1,Length(Trim(Form7.ibDataSet4CSOSN_NFCE.AsString))) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN_NFCE.AsString)) then
          begin
            Form10.ComboBox15.ItemIndex := I;
          end;
        end;
        {Sandro Silva 2023-05-09 fim}
      end;
    end;



    if AllTrim(Form7.ibDataSet4CST.AsString)<>'' then
    begin
      for I := 0 to cboOrigemProd.Items.Count -1 do
      begin
        // 0 - Nacional, exceto as indicadas nos códigos 3 a 5
        // 1 - Estrangeira - Importação direta, exceto a indicada no código 6
        // 2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7
        // 3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento)
        // 4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam o Decreto-Lei nº 288/1967, e as Leis nºs 8.248/1991, 8.387/1991, 10.176/2001 e 11.484/2007;
        // 5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40% (quarenta por cento)
        // 6 - Estrangeira - Importação direta, sem similar nacional, constante em lista de Resolução CAMEX;
        // 7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista de Resolução CAMEX.
        // 8 - Nacional, mercadoria ou bem com Conteúdo de Importação sup. a 70%
        //
        //if Copy(cboOrigemProd.Items[I],1,1) = Copy(AllTrim(Form7.ibDataSet4CST.AsString)+'000',1,1) then  Mauricio Parizotto 2023-09-01
        if Copy(cboOrigemProd.Items[I],1,1) = Copy(Form7.ibDataSet4CST.AsString+'000',1,1) then
        begin
          cboOrigemProd.ItemIndex := I;
        end;
      end;
    end;


    if AllTrim(Form7.ibDataSet4CST.AsString)<>'' then
    begin
      for I := 0 to cboCST_Prod.Items.Count -1 do
      begin
        // 00 - Tributada integralmente
        // 10 - Tributada e com cobrança de ICMS por substituição tributária
        // 20 - Com redução de base de cálculo
        // 30 - Isenta e não tributada de ICMS por substituição tributária
        // 40 - Isenta
        // 41 - Não tributada
        // 50 - Suspensão
        // 51 - Diferimento
        // 60 - ICMS Cobrado anteriormente por substituição tributária
        // 70 - Com red. de base de calculo e cob. do ICMS por subs. tributária
        // 90 - Outras
        //if Copy(cboCST_Prod.Items[I],1,2) = Copy(AllTrim(Form7.ibDataSet4CST.AsString)+'000',2,2) then Mauricio Parizotto 2023-09-01
        if Copy(cboCST_Prod.Items[I],1,2) = Copy(Form7.ibDataSet4CST.AsString+'000',2,2) then
        begin
          cboCST_Prod.ItemIndex := I;
        end;
      end;
    end;

    if AllTrim(Form7.ibDataSet4CST_NFCE.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox14.Items.Count -1 do
      begin
        // 00 - Tributada integralmente
        // 10 - Tributada e com cobrança de ICMS por substituição tributária
        // 20 - Com redução de base de cálculo
        // 30 - Isenta e não tributada de ICMS por substituição tributária
        // 40 - Isenta
        // 41 - Não tributada
        // 50 - Suspensão
        // 51 - Diferimento
        // 60 - ICMS Cobrado anteriormente por substituição tributária
        // 70 - Com red. de base de calculo e cob. do ICMS por subs. tributária
        // 90 - Outras
        //if Copy(Form10.ComboBox14.Items[I],1,2) = Copy(AllTrim(Form7.ibDataSet4CST_NFCE.AsString)+'000',2,2) then Mauricio Parizotto 2023-09-01
        if Copy(Form10.ComboBox14.Items[I],1,2) = Copy(Form7.ibDataSet4CST_NFCE.AsString+'000',2,2) then
        begin
          Form10.ComboBox14.ItemIndex := I;
        end;
      end;
    end;


    // 50 - Saída Tributada
    // 51 - Saída Tributável com Alíquota Zero
    // 52 - Saída Isenta
    // 53 - Saída Não-Tributada
    // 54 - Saída Imune
    // 55 - Saída com Suspensão
    // 99 - Outras Saídas
    if AllTrim(Form7.ibDataSet4CST_IPI.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox1.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox1.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_IPI.AsString)) then
        begin
          Form10.ComboBox1.ItemIndex := I;
        end;
      end;
    end;

    // 01-Operação Tributável com Alíquota Básica
    // 02-Operação Tributável com Alíquota Diferenciada
    // 03-Operação Tributável com Alíquota por Unidade de Medida de Produto
    // 04-Operação Tributável Monofásica - Revenda a Alíquota Zero
    // 05-Operação Tributável por Substituição Tributária
    // 06-Operação Tributável a Alíquota Zero
    // 07-Operação Isenta da Contribuição
    // 08-Operação sem Incidência da Contribuição
    // 09-Operação com Suspensão da Contribuição
    // 49-Outras Operações de Saída
    // 50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 51-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
    // 52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
    // 53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
    // 62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
    // 63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 67-Crédito Presumido - Outras Operações
    // 70-Operação de Aquisição sem Direito a Crédito
    // 71-Operação de Aquisição com Isenção
    // 72-Operação de Aquisição com Suspensão
    // 73-Operação de Aquisição a Alíquota Zero
    // 74-Operação de Aquisição sem Incidência da Contribuição
    // 75-Operação de Aquisição por Substituição Tributária
    // 98-Outras Operações de Entrada
    // 99-Outras Operações

    if AllTrim(Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox7.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox7.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString)) then
        begin
          Form10.ComboBox7.ItemIndex := I;
        end;
      end;
    end;

    // 01-Operação Tributável com Alíquota Básica
    // 02-Operação Tributável com Alíquota Diferenciada
    // 03-Operação Tributável com Alíquota por Unidade de Medida de Produto
    // 04-Operação Tributável Monofásica - Revenda a Alíquota Zero
    // 05-Operação Tributável por Substituição Tributária
    // 06-Operação Tributável a Alíquota Zero
    // 07-Operação Isenta da Contribuição
    // 08-Operação sem Incidência da Contribuição
    // 09-Operação com Suspensão da Contribuição
    // 49-Outras Operações de Saída
    // 50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 51-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
    // 52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
    // 53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
    // 62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
    // 63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 67-Crédito Presumido - Outras Operações
    // 70-Operação de Aquisição sem Direito a Crédito
    // 71-Operação de Aquisição com Isenção
    // 72-Operação de Aquisição com Suspensão
    // 73-Operação de Aquisição a Alíquota Zero
    // 74-Operação de Aquisição sem Incidência da Contribuição
    // 75-Operação de Aquisição por Substituição Tributária
    // 98-Outras Operações de Entrada
    // 99-Outras Operações
    //
    if AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox10.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox10.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString)) then
        begin
          Form10.ComboBox10.ItemIndex := I;
        end;
      end;
    end;
    //
    // 00 - Mercadoria para Revenda
    // 01 - Matéria-Prima
    // 02 - Embalagem
    // 03 - Produto em Processo
    // 04 - Produto Acabado
    // 05 - Subproduto
    // 06 - Produto Intermediário
    // 07 - Material de Uso e Consumo
    // 08 - Ativo Imobilizado
    // 09 - Serviços
    // 10 - Outros insumos
    // 99 - Outras
    //
    if AllTrim(Form7.ibDataSet4TIPO_ITEM.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox9.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox9.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4TIPO_ITEM.AsString)) then
        begin
          Form10.ComboBox9.ItemIndex := I;
        end;
      end;
    end;

    if ComboBox9.CanFocus then
      ComboBox9.SetFocus;
    if Form10.SMALL_DBEDITY.CanFocus then
      Form10.SMALL_DBEDITY.SetFocus;

    // 5101 - Venda de produção do estabelecimento;
    // 5102 - Venda de mercadoria de terceiros;
    // 5103 - Venda de produção do estabelecimento efetuada fora do estabelecimento;
    // 5104 - Venda de mercadoria adquirida ou recebida de terceiros, efetuada fora do estabelecimento;
    // 5115 - Venda de mercadoria de terceiros, recebida anteriormente em consignação mercantil;
    // 5405 - Venda de mercadoria de terceiros, sujeita a ST, como contribuinte substituído;
    // 5656 - Venda de combustível ou lubrificante de terceiros, destinados a consumidor final;
    // 5667 - Venda de combustível ou lubrificante a consumidor ou usuário final estabelecido em outra Unidade da Federação;
    // 5933 - Prestação de serviço tributado pelo ISSQN (Nota Fiscal conjugada);

    if AllTrim(Form7.ibDataSet4CFOP.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox11.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox11.Items[I],1,4) = UpperCase(AllTrim(Form7.ibDataSet4CFOP.AsString)) then
        begin
          Form10.ComboBox11.ItemIndex := I;
        end;
      end;
    end;

    {Sandro Silva 2023-06-28 inicio
    if Copy(Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString,1,3) = '03' then
    begin
      Label43.Caption := 'R$ PIS:';
      Label49.Caption := 'R$ COFINS:';
    end else
    begin
      Label43.Caption := '% PIS:';
      Label49.Caption := '% COFINS:';
    end;
    }
  end;

  if Form7.sModulo = 'ICM' then
  begin
      // 01-Operação Tributável com Alíquota Básica
    // 02-Operação Tributável com Alíquota Diferenciada
    // 03-Operação Tributável com Alíquota por Unidade de Medida de Produto
    // 04-Operação Tributável Monofásica - Revenda a Alíquota Zero
    // 05-Operação Tributável por Substituição Tributária
    // 06-Operação Tributável a Alíquota Zero
    // 07-Operação Isenta da Contribuição
    // 08-Operação sem Incidência da Contribuição
    // 09-Operação com Suspensão da Contribuição
    // 49-Outras Operações de Saída
    // 50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 51-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
    // 52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
    // 53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
    // 61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
    // 62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
    // 63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
    // 64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
    // 65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
    // 66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
    // 67-Crédito Presumido - Outras Operações
    // 70-Operação de Aquisição sem Direito a Crédito
    // 71-Operação de Aquisição com Isenção
    // 72-Operação de Aquisição com Suspensão
    // 73-Operação de Aquisição a Alíquota Zero
    // 74-Operação de Aquisição sem Incidência da Contribuição
    // 75-Operação de Aquisição por Substituição Tributária
    // 98-Outras Operações de Entrada
    // 99-Outras Operações

    if AllTrim(Form7.ibDataSet14CSTPISCOFINS.AsString)<>'' then
    begin
      for I := 0 to Form10.ComboBox7.Items.Count -1 do
      begin
        if Copy(Form10.ComboBox7.Items[I], 1, 2) = UpperCase(AllTrim(Form7.ibDataSet14CSTPISCOFINS.AsString)) then
        begin
          Form10.ComboBox7.ItemIndex := I;
        end;
      end;
    end;

  end;

  if Copy(Form10.ComboBox7.Text, 1, 2) = '03' then
  begin
    Label43.Caption := 'R$ PIS:';
    Label49.Caption := 'R$ COFINS:';
  end else
  begin
    Label43.Caption := '% PIS:';
    Label49.Caption := '% COFINS:';
  end;


end;

procedure TForm10.ComboBox5Change(Sender: TObject);
begin
  // P - Produção própria
  // T - Produção por terceiros

  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4IPPT.AsString := Copy(Form10.ComboBox5.Items[Form10.ComboBox5.ItemIndex]+' ',1,1);
  end;
end;

procedure TForm10.ComboBox6Change(Sender: TObject);
begin
  // A - Arredondamento
  // T - Truncamento

  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4IAT.AsString := Copy(Form10.ComboBox6.Items[Form10.ComboBox6.ItemIndex]+' ',1,1);
  end;
end;

procedure TForm10.cboOrigemProdChange(Sender: TObject);
begin
  // 0 - Nacional, exceto as indicadas nos códigos 3 a 5
  // 1 - Estrangeira - Importação direta, exceto a indicada no código 6
  // 2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7
  // 3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento)
  // 4 - Nacional, cuja produção tenha sido feita em conformidade com os processos produtivos básicos de que tratam o Decreto-Lei nº 288/1967, e as Leis nºs 8.248/1991, 8.387/1991, 10.176/2001 e 11.484/2007;
  // 5 - Nacional, mercadoria ou bem com Conteúdo de Importação inferior ou igual a 40% (quarenta por cento)
  // 6 - Estrangeira - Importação direta, sem similar nacional, constante em lista de Resolução CAMEX;
  // 7 - Estrangeira - Adquirida no mercado interno, sem similar nacional, constante em lista de Resolução CAMEX.
  // 8 - Nacional, mercadoria ou bem com Conteúdo de Importação sup. a 70%

  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CST.AsString := Copy(cboOrigemProd.Items[cboOrigemProd.ItemIndex]+' ',1,1)+Copy(Form7.ibDataSet4CST.AsString+'  ',2,2);
    Form7.ibDataSet4CST_NFCE.AsString := Copy(cboOrigemProd.Items[cboOrigemProd.ItemIndex]+' ',1,1)+Copy(Form7.ibDataSet4CST_NFCE.AsString+'  ',2,2); // Mauricio Parizotto 2023-09-06
  end;
end;

procedure TForm10.cboCST_ProdChange(Sender: TObject);
begin
  // 00 - Tributada integralmente
  // 10 - Tributada e com cobrança de ICMS por substituição tributária
  // 20 - Com redução de base de cálculo
  // 30 - Isenta e não tributada de ICMS por substituição tributária
  // 40 - Isenta
  // 41 - Não tributada
  // 50 - Suspensão
  // 51 - Diferimento
  // 60 - ICMS Cobrado anteriormente por substituição tributária
  // 70 - Com red. de base de calculo e cob. do ICMS por subs. tributária
  // 90 - Outras
  //
  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CST.AsString := Copy(Form7.ibDataSet4CST.AsString+' ',1,1)+Copy(cboCST_Prod.Items[cboCST_Prod.ItemIndex]+'   ',1,2);
  end;
end;

procedure TForm10.ComboBox1Change(Sender: TObject);
begin
  // 50 - Saída Tributada
  // 51 - Saída Tributável com Alíquota Zero
  // 52 - Saída Isenta
  // 53 - Saída Não-Tributada
  // 54 - Saída Imune
  // 55 - Saída com Suspensão
  // 99 - Outras Saídas
  
  if Form10.caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CST_IPI.AsString := Copy(Form10.ComboBox1.Items[Form10.ComboBox1.ItemIndex]+'  ',1,2);
  end;
end;

procedure TForm10.cboCSOSN_ProdChange(Sender: TObject);
begin
  // 101 - Tributada pelo Simples Nacional com permissão de crédito
  // 102 - Tributada pelo Simples Nacional sem permissão de crédito
  // 103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta
  // 201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária
  // 202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária
  // 203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária
  // 300 - Imune
  // 400 - Não tributada pelo Simples Nacional
  // 500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
  // 900 - Outros

  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    // Sandro Silva 2023-05-09 Form7.ibDataSet4CSOSN.AsString := Copy(Form10.ComboBox4.Items[Form10.ComboBox4.ItemIndex]+'   ',1,3);
    Form7.ibDataSet4CSOSN.AsString := Trim(Copy(cboCSOSN_Prod.Items[cboCSOSN_Prod.ItemIndex]+'   ',1,3));
  end;
end;

procedure TForm10.ComboBox7Change(Sender: TObject);
begin
  //
  // 01-Operação Tributável com Alíquota Básica
  // 02-Operação Tributável com Alíquota Diferenciada
  // 03-Operação Tributável com Alíquota por Unidade de Medida de Produto
  // 04-Operação Tributável Monofásica - Revenda a Alíquota Zero
  // 05-Operação Tributável por Substituição Tributária
  // 06-Operação Tributável a Alíquota Zero
  // 07-Operação Isenta da Contribuição
  // 08-Operação sem Incidência da Contribuição
  // 09-Operação com Suspensão da Contribuição
  // 49-Outras Operações de Saída
  // 50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  // 51-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
  // 52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
  // 53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
  // 54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
  // 55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
  // 56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
  // 60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  // 61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
  // 62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
  // 63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
  // 64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
  // 65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
  // 66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
  // 67-Crédito Presumido - Outras Operações
  // 70-Operação de Aquisição sem Direito a Crédito
  // 71-Operação de Aquisição com Isenção
  // 72-Operação de Aquisição com Suspensão
  // 73-Operação de Aquisição a Alíquota Zero
  // 74-Operação de Aquisição sem Incidência da Contribuição
  // 75-Operação de Aquisição por Substituição Tributária
  // 98-Outras Operações de Entrada
  // 99-Outras Operações
  //
  {Sandro Silva 2023-06-27 inicio
  if Form10.Caption = Form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString := Copy(Form10.ComboBox7.Items[Form10.ComboBox7.ItemIndex]+'  ',1,2);
  end;

  if Copy(Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString,1,3) = '03' then
  begin
    Label43.Caption := 'R$ PIS:';
    Label49.Caption := 'R$ COFINS:';
  end else
  begin
    Label43.Caption := '% PIS:';
    Label49.Caption := '% COFINS:';
  end;
  }
  if Form7.sModulo = 'ESTOQUE' then
  begin
    if Form10.Caption = Form7.ibDataSet4DESCRICAO.AsString then
    begin
      Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString := Copy(Form10.ComboBox7.Items[Form10.ComboBox7.ItemIndex]+'  ',1,2);
    end;
  end;

  if Form7.sModulo = 'ICM' then
  begin
      Form7.ibDataSet14CSTPISCOFINS.AsString := Copy(Form10.ComboBox7.Items[Form10.ComboBox7.ItemIndex]+'  ',1,2);
  end;


  if Copy(Form10.ComboBox7.Items[Form10.ComboBox7.ItemIndex]+'  ',1,2) = '03' then
  begin
    Label43.Caption := 'R$ PIS:';
    Label49.Caption := 'R$ COFINS:';
  end else
  begin
    Label43.Caption := '% PIS:';
    Label49.Caption := '% COFINS:';
  end;
  {Sandro Silva 2023-06-27 fim}
end;

procedure TForm10.ComboBox9Change(Sender: TObject);
begin
  // 00 - Mercadoria para Revenda
  // 01 - Matéria-Prima
  // 02 - Embalagem
  // 03 - Produto em Processo
  // 04 - Produto Acabado
  // 05 - Subproduto
  // 06 - Produto Intermediário
  // 07 - Material de Uso e Consumo
  // 08 - Ativo Imobilizado
  // 09 - Serviços
  // 10 - Outros insumos
  // 99 - Outras
  
  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4TIPO_ITEM.AsString := Copy(Form10.ComboBox9.Items[Form10.ComboBox9.ItemIndex]+'  ',1,2);
  end;
end;

procedure TForm10.SMALL_DBEdit38Exit(Sender: TObject);
begin
//  Form10.orelha_ICMSShow(Sender); Mauricio Parizotto 2023-08-10
  CarregaCit; //Mauricio Parizotto 2023-09-04
end;

procedure TForm10.ComboBox9KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form7.sAjuda)));
end;

procedure TForm10.orelha_cadastroShow(Sender: TObject);
begin
  if SMALL_DBEdit1.CanFocus then
    SMALL_DBEdit2.SetFocus
  else if SMALL_DBEdit2.CanFocus then
    SMALL_DBEdit2.SetFocus
  else if SMALL_DBEdit3.CanFocus then
    SMALL_DBEdit3.SetFocus
  else if SMALL_DBEdit4.CanFocus then
    SMALL_DBEdit4.SetFocus;
end;

procedure TForm10.Button4Click(Sender: TObject);
begin
  //Mauricio Parizotto 2023-05-31
  if Form7.sModulo = 'RECEBER' then
    AlteracaoInstituicaoFinanceira;

  //Valida Campos - se um tiver preenchido valida o outro
  if Form7.sModulo = 'CONVERSAOCFOP' then
  begin
    if (Trim(Form7.ibdConversaoCFOPCFOP_CONVERSAO.AsString) <> '') or (Trim(Form7.ibdConversaoCFOPCFOP_ORIGEM.AsString) <> '') then
    begin
      if Length(Form7.ibdConversaoCFOPCFOP_ORIGEM.AsString) <> 4 then
      begin
        Form7.ibdConversaoCFOPCFOP_ORIGEM.FocusControl;
        Exit;
      end;

      if Length(Form7.ibdConversaoCFOPCFOP_CONVERSAO.AsString) <> 4 then
      begin
        Form7.ibdConversaoCFOPCFOP_CONVERSAO.FocusControl;
        Exit;
      end;
    end;
  end;

  Orelha_cadastro.Visible := True;
  Orelhas.ActivePage := Orelha_cadastro;
  Close;
end;

procedure TForm10.Button14Click(Sender: TObject);
var
  bbutton : Integer;
begin
  bButton := Application.MessageBox(Pchar('Este procedimento pode alterar o preço de todos os produtos'+Chr(10)+
                                          'cadastrados no estoque.'+
             Chr(10) +
             Chr(10) +
             'Continuar?' +
             Chr(10))
             ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
  if bButton = IDYES then
  begin
    Form7.ibDataSet4.First;
    while not Form7.ibDataSet4.Eof do
    begin
      Form10.Orelha_precoShow(Sender);
      Form10.Button18Click(Sender);
      Form7.ibDataSet4.Next;
    end;
  end;
end;

procedure TForm10.Button18Click(Sender: TObject);
begin
  Form7.ibDataSet4.Edit;
  Form7.ibDataSet4MARGEMLB.AsFloat := Form7.ibDataSet13RESE.AsFloat;
  Form7.ibDataSet4.Post;
end;

procedure TForm10.Orelha_precoShow(Sender: TObject);
begin
  // Descrobre o percentual de Comissao
  
  Image6.Picture := Form1.imgEstoque.Picture;
  
  if not (Form7.ibDataset13.State in ([dsEdit, dsInsert])) then Form7.ibDataset13.Edit;
  
  Form7.ibDataSet13CVEN.AsFloat := 0;
  if Form7.ibDataSet4COMISSAO.AsFloat <> 0 then
  begin
    Form7.ibDataSet13CVEN.AsFloat := Form7.ibDataSet4COMISSAO.AsFloat;
  end else
  begin
    Form7.ibDataSet9.First;
    while not Form7.ibDataSet9.Eof do
    begin
      if Form7.ibDataSet13CVEN.AsFloat <= Form7.ibDataSet9COMISSA1.AsFloat  then Form7.ibDataSet13CVEN.AsFloat := Form7.ibDataSet9COMISSA1.AsFloat;
      if Form7.ibDataSet13CVEN.AsFloat <= Form7.ibDataSet9COMISSA2.AsFloat  then Form7.ibDataSet13CVEN.AsFloat := Form7.ibDataSet9COMISSA2.AsFloat;
      Form7.ibDataSet9.Next;
    end;
  end;
  
  Form7.ibDataSet13ICMS.AsFloat := 0;
  
  try
    if Form7.ibDataSet13ICMS.AsFloat = 0 then
    begin
      Form7.ibDataSet14.First;
      while not Form7.ibDataSet14.EOF do           // Procura pela operação padrão venda À vista ou //
      begin                                        // venda a prazo 512 ou 612 ou 5102 ou 6102      //
        if Form7.ibDataSet13ICMS.AsFloat = 0 then
        begin
          if (AllTrim(Form7.ibDataSet14.FieldByName('CFOP').AsString) = '5102')
          or (AllTrim(Form7.ibDataSet14.FieldByName('CFOP').AsString) = '6102')
          or (AllTrim(Form7.ibDataSet14.FieldByName('CFOP').AsString) = '512')
          or (AllTrim(Form7.ibDataSet14.FieldByName('CFOP').AsString) = '612') then
          begin
            Form7.ibDataSet13ICMS.AsFloat := Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 * Form7.ibDataSet14.FieldByname('BASE').AsFloat;
          end;
        end;
        Form7.ibDataSet14.Next;
      end;
    end;
    
    if AllTrim(Form7.ibDataSet4ST.AsSTring) <> '' then
    begin
      Form7.ibDataSet14.First;
      while (Form7.ibDataSet4ST.Value <> Form7.ibDataSet14ST.Value) and not (Form7.ibDataSet14.Eof) do Form7.ibDataSet14.Next;
      if (Form7.ibDataSet4ST.Value = Form7.ibDataSet14ST.Value) then
        if (Form7.ibDataSet13ICMS.AsFloat) > (Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 * Form7.ibDataSet14.FieldByname('BASE').AsFloat) then
          Form7.ibDataSet13ICMS.AsFloat := Form7.ibDataSet14.FieldByname(UpperCase(Form7.ibDataSet13ESTADO.AsString)+'_').AsFloat / 100 * Form7.ibDataSet14.FieldByname('BASE').AsFloat;
    end;
    //
  except end;
  //
  // Procura no arquivo de compras o custo da última compra
  //
  Form7.ibQuery14.DisableControls;
  Form7.ibQuery14.Close;
  Form7.ibQuery14.SQL.Clear;
  Form7.ibQuery14.SQL.Add('select * from ITENS002 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' order by REGISTRO');
  Form7.ibQuery14.Open;
  Form7.ibQuery14.Last;
  //
  Form7.ibDataSet13ICME.AsFloat := Form7.ibQuery14.FieldByname('ICM').AsFloat;
  rCusto := Form7.ibQuery14.FieldByname('UNITARIO').AsFloat;
  //
  if rCusto = 0 then rCusto := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
  //
  Label58.Caption :=   '+R$ '+Format('%9.2n',[rCusto]);
  Label60.Caption :=  '+R$ '+Format('%9.2n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat - rCusto]);
  //
  Edit15.Text := '=R$ '+Format('%9.2n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat]);
  //
  Form10.SMALL_DBEdit32Exit(Sender);
  //
end;

procedure TForm10.Button20Click(Sender: TObject);
var
  rReceitas : Real;
  rDespesas : Real;
  dCOPE: Double; // Sandro Silva 2023-08-07
begin
  try
    rReceitas := 0;
    rDespesas := 0;
    Form7.ibDataSet12.First;
    while not Form7.ibDataSet12.Eof do
    begin
      if Copy(Form7.ibDataSet12CONTA.AsString,1,2) = '11' then rReceitas := rReceitas + Form7.ibDataSet12ANO.AsFloat;
      if Copy(Form7.ibDataSet12CONTA.AsString,1,2) = '32' then rDespesas := rDespesas + (Form7.ibDataSet12ANO.AsFloat * -1);
      Form7.ibDataSet12.Next;
    end;
    {Sandro Silva 2023-08-07 inicio
    try
      Form7.ibDataSet13COPE.AsFloat := rDespesas * 100 / rReceitas;
    except
      Form7.ibDataSet13COPE.AsFloat := 0;
    end;
    }
    dCOPE := 0;
    if rReceitas > 0 then
    begin
      try
        dCOPE := rDespesas * 100 / rReceitas;
      except
        dCOPE := 0;
      end;
    end;
    Form7.ibDataSet13COPE.AsFloat := dCOPE;
    {Sandro Silva 2023-08-07 fim}
    ShowMessage('O sistema calculou o "custo operacional" da'+Chr(10)+
                'seguinte forma:'+Chr(10)+Chr(10)+

                'Analisando no plano de contas'+Chr(10)+Chr(10)+
                '11??? - Receitas'+Chr(10)+
                '32??? - Despesas Operacionais'+Chr(10)+Chr(10)+

                'Custo Operacional = Despesas Operacionais * 100 / Receitas'+Chr(10)+Chr(10)+
                'Custo Operacional = '+AllTrim(Format('%12.2n',[rDespesas]))+' * 100 / '+AllTrim(Format('%12.2n',[rReceitas]))+Chr(10)+Chr(10)+
                'Custo Operacional = '+AllTrim(Format('%12.2n',[dCOPE]))+'%'+Chr(10)+Chr(10)); // Sandro Silva 2023-08-07 'Custo Operacional = '+AllTrim(Format('%12.2n',[rDespesas * 100 / rReceitas]))+'%'+Chr(10)+Chr(10));
  except
    ShowMessage('O sistema calcula o "custo operacional" da'+Chr(10)+
                'seguinte forma:'+Chr(10)+Chr(10)+

                'Analisando no plano de contas'+Chr(10)+Chr(10)+
                '11??? - Receitas'+Chr(10)+
                '32??? - Despesas Operacionais'+Chr(10)+Chr(10)+

                'Custo Operacional = Despesas Operacionais * 100 / Receitas'+Chr(10)+Chr(10)+
                'Não foi possível calcular o Custo Operacional,'+Chr(10)+
                'Verifique os valores no plano de contas.'+Chr(10));

  end;
end;

procedure TForm10.SMALL_DBEdit32KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm10.SMALL_DBEdit32Exit(Sender: TObject);
var
  CustoDeAquisicao : Real;
  PercentualCalcul : Real;
  PrecoDeVenda : Real;
begin
  if Form7.sModulo = 'ESTOQUE' then
  begin
    try
      Form7.ibDataSet4.Edit;

      PercentualCalcul := 100 - ((
      Form7.ibDataSet13COPE.AsFloat +
      Form7.ibDataSet13ICMS.AsFloat +
      Form7.ibDataSet13IMPO.AsFloat +
      Form7.ibDataSet13CVEN.AsFloat +
      Form7.ibDataSet13LUCR.AsFloat));

      if PercentualCalcul >= 0 then
      begin
        //  CustoDeAquisicao := Form7.ibDataSet4CUSTOCOMPR.AsFloat - ( Form7.ibDataSet4CUSTOCOMPR.AsFloat * (Form7.ibDataSet4ICME.AsFloat / 100));

        CustoDeAquisicao := Form7.ibDataSet4CUSTOCOMPR.AsFloat - ( rCusto * (Form7.ibDataSet13ICME.AsFloat / 100));
        //
        // CustoDeAquisicao := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
        // CustoDeAquisicao := 118.8;

        Edit16.Text := '-R$ '+Format('%9.2n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat - CustoDeAquisicao]);

        if PercentualCalcul <> 0 then PrecoDeVenda := CustoDeAquisicao * 100 / PercentualCalcul else PrecoDeVenda := 0;

        Edit22.Text := '=R$ '+Format('%9.2n',[PrecoDeVenda]);
        Edit18.Text := '+R$ '+Format('%9.2n',[PrecoDeVenda * Form7.ibDataSet13COPE.AsFloat / 100]);
        Edit17.Text := '+R$ '+Format('%9.2n',[PrecoDeVenda * Form7.ibDataSet13ICMS.AsFloat / 100]);
        Edit19.Text := '+R$ '+Format('%9.2n',[PrecoDeVenda * Form7.ibDataSet13IMPO.AsFloat / 100]);
        Edit20.Text := '+R$ '+Format('%9.2n',[PrecoDeVenda * Form7.ibDataSet13CVEN.AsFloat / 100]);
        Edit21.Text := '+R$ '+Format('%9.2n',[PrecoDeVenda * Form7.ibDataSet13LUCR.AsFloat / 100]);

        if not (Form7.ibDataset13.State in ([dsEdit, dsInsert])) then Form7.ibDataset13.Edit;
        if Form7.ibDataSet4CUSTOCOMPR.AsFloat <> 0 then Form7.ibDataSet13RESE.AsFloat :=  ((PrecoDeVenda / Form7.ibDataSet4CUSTOCOMPR.AsFloat) * 100) - 100 else Form7.ibDataSet13RESE.AsFloat := 0;
      end else
      begin
        ShowMessage('Não foi possível efetuar o calculo. Verifique os percentuais usados.'+Chr(10)+'Ou calcule manualmente o preço deste produto.');
      end;
    except end;
  end;
end;

procedure TForm10.ComboBox10Change(Sender: TObject);
begin
  // 01-Operação Tributável com Alíquota Básica
  // 02-Operação Tributável com Alíquota Diferenciada
  // 03-Operação Tributável com Alíquota por Unidade de Medida de Produto
  // 04-Operação Tributável Monofásica - Revenda a Alíquota Zero
  // 05-Operação Tributável por Substituição Tributária
  // 06-Operação Tributável a Alíquota Zero
  // 07-Operação Isenta da Contribuição
  // 08-Operação sem Incidência da Contribuição
  // 09-Operação com Suspensão da Contribuição
  // 49-Outras Operações de Saída
  // 50-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  // 51-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
  // 52-Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
  // 53-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
  // 54-Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
  // 55-Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
  // 56-Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
  // 60-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
  // 61-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
  // 62-Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
  // 63-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
  // 64-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
  // 65-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
  // 66-Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
  // 67-Crédito Presumido - Outras Operações
  // 70-Operação de Aquisição sem Direito a Crédito
  // 71-Operação de Aquisição com Isenção
  // 72-Operação de Aquisição com Suspensão
  // 73-Operação de Aquisição a Alíquota Zero
  // 74-Operação de Aquisição sem Incidência da Contribuição
  // 75-Operação de Aquisição por Substituição Tributária
  // 98-Outras Operações de Entrada
  // 99-Outras Operações
  //
  if AllTrim(Form10.Caption) = AllTrim(Form7.ibDataSet4DESCRICAO.AsString) then
  begin
    Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString := Copy(Form10.ComboBox10.Items[Form10.ComboBox10.ItemIndex]+'  ',1,2);
  end;
end;

procedure TForm10.Orelha_PISCOFINSEnter(Sender: TObject);
begin
  {Sandro Silva 2023-06-28 inicio
  if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset4.Edit;
  }
  if Form7.sModulo = 'ESTOQUE' then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset4.Edit;
  end;
  {Sandro Silva 2023-06-28 fim}
end;

procedure TForm10.Orelha_IPIEnter(Sender: TObject);
begin
  if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset4.Edit;
end;

procedure TForm10.orelha_cadastroExit(Sender: TObject);
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    Form10.Caption := form7.ibDataSet4DESCRICAO.AsString;
  end;
end;

procedure TForm10.ComboBox8Change(Sender: TObject);
begin
  Form7.ArquivoAberto.Edit;
  Form7.ArquivoAberto.FieldByName('CLIFOR').AsString := Form10.ComboBox8.Text;

  if Form7.ibDataSet9NOME.AsString =  Form7.ibDataSet2NOME.AsString then
  begin
    if Form7.ibDataSet2CLIFOR.AsString <> 'Vendedor' then
    begin
      Form7.ibDataSet9.Delete;
    end else
    begin
      Form7.ibDataSet9.Append;
      Form7.IBDataSet9NOME.AsString := Form7.IBDataSet2NOME.AsString;
      Form7.ibDataSet9.Post;
    end;
  end;

  if Form7.ibDataSet2CLIFOR.AsString = 'Marketplace' then
  begin
    if AllTrim(RetornaValorDaTagNoCampo('idCadIntTran',Form7.ibDataSet2OBS.AsString)) = '' then
    begin
      Form7.ibDataSet2OBS.AsString := AllTrim(Form7.ibDataSet2OBS.AsString) + '<idCadIntTran>0000</idCadIntTran>'
    end;
  end else
  begin
    Form7.ibDataSet2OBS.AsString := StrTran(Form7.ibDataSet2OBS.AsString,'<idCadIntTran>0000</idCadIntTran>','');
  end;
end;

procedure TForm10.Orelha_promoEnter(Sender: TObject);
begin
  if Form7.bSoLeitura then
  begin
    SMALL_DBEdit45.ReadOnly := True;
    SMALL_DBEdit46.ReadOnly := True;
    SMALL_DBEdit50.ReadOnly := True;
  end else
  begin
    SMALL_DBEdit45.ReadOnly := False;
    SMALL_DBEdit46.ReadOnly := False;
    SMALL_DBEdit50.ReadOnly := False;
  end;
end;

procedure TForm10.Button7Click(Sender: TObject);
var
  sLinkDaFoto, s: String;
  documentoAtivo : variant;
  J , I : Integer;
  iSrc: Integer;
  vDescricaoBusca : string;

  function DownloadArquivoImg(const AOrigem: String; ADestino: String): Boolean;
  const BufferSize = 1024;
  var
    hSession, hURL: HInternet;
    Buffer: array[1..BufferSize] of Byte;
    BufferLen: DWORD;
    f: File;
    sAppName: string;
  begin
    Result := False;
    sAppName := ExtractFileName(Application.ExeName);
    hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    try
      hURL := InternetOpenURL(hSession, PChar(AOrigem), nil, 0, 0, 0);
      try
        if Assigned(hURL) then
        begin
          AssignFile(f, ADestino);
          Rewrite(f,1);
          repeat
            InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
            BlockWrite(f, Buffer, BufferLen)
          until BufferLen = 0;
          CloseFile(f);
          Result := True;
        end;
      finally
        InternetCloseHandle(hURL);
      end
    finally
      InternetCloseHandle(hSession);
    end
  end;

begin
  // Procura pelo código de barras no no google
  
  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
  
  Image5.Picture.SaveToFile('res'+Form7.IBDataSet4REGISTRO.AsString+'.jpg');
  
  try
    begin
      begin
        Form10.Tag       := 0;
        if (Length(Limpanumero(Form7.ibDataSet4REFERENCIA.AsString)) >= 12) and (Copy(Form7.ibDataSet4REFERENCIA.AsString,1,1)<>'2') then
        begin
          WebBrowser1.Navigate(pChar('http://www.google.com/search?um=1&hl=pt-BR&biw=1920&bih=955&q='+Form7.ibDataSet4REFERENCIA.AsString+'&ie=UTF-8&tbm=isch&source=og&sa=N&tab=wi'));
        end else
        begin
          vDescricaoBusca := UTF8Encode(Form7.ibDataSet4DESCRICAO.AsString);

          //WebBrowser1.Navigate(pChar('http://www.google.com/search?um=1&hl=pt-BR&biw=1920&bih=955&q='+Form7.ibDataSet4DESCRICAO.AsString+'&ie=UTF-8&tbm=isch&source=og&sa=N&tab=wi'));
          WebBrowser1.Navigate(pChar('http://www.google.com/search?um=1&hl=pt-BR&biw=1920&bih=955&q='+vDescricaoBusca+'&ie=UTF-8&tbm=isch&source=og&sa=N&tab=wi'));
        end;
        
        while (Form10.Tag < 33) do
        begin
          Application.ProcessMessages;
          sleep(100);
        end;
        
        for I := 1 to 50 do
        begin
          Application.ProcessMessages;
          if Form10.Tag < 35 then
            sleep(100);
        end;
        
        WebBrowser1.Left := -20000;
        
        Screen.Cursor             := crDefault;              // Cursor de Aguardo
                
        documentoAtivo := WebBrowser1.Document;
        s := documentoAtivo.Body.OuterHTML;
        
        // Adicionando o código HTML ao MEMO
        
        try
          // Exemplo: 737052683522  3380814050918   884116107460  7894900010015
          
          Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
          J := 0;
          {Sandro Silva 2022-09-26 inicio
          //
          while Pos('http://',Lowercase(s)) <> 0 do
          begin
            if (Pos('http://',Lowercase(s)) < Pos('.jpg',Lowercase(s))) then
            begin
              sLinkDaFoto := Copy(s, Pos('http://',Lowercase(s)),Pos('.jpg',Lowercase(s))+3);
              if (Pos('>',sLinkDaFoto)=0) and (Pos('=',sLinkDaFoto)=0) and (Pos('%',sLinkDaFoto)=0)  then
              begin
                try
                  // Faz o download dA Imagem sLinkDaFoto e salva no 'c:\tempo.jpg'
                  try
                    DownloadDoArquivo(PChar(sLinkDaFoto),PChar(Form10.sNomeDoJPG));
                  finally
                    //
                    if FileExists(Form10.sNomeDoJPG) then
                    begin
                      //
                      try
                        AtualizaTela(True);
                      finally
                        //
                        if Form7.ibDataset4FOTO.BlobSize <> 0 then
                        begin
                          J := J + 1;
                          if J >= 7 then
                          begin
                            CopyFile(pChar('res'+Form7.IBDataSet4REGISTRO.AsString+'.jpg'),pChar(Form10.sNomeDoJPG),false);
                            AtualizaTela(True);
                            s := '';
                          end else
                          begin
                            I := Application.MessageBox(Pchar('Quer usar esta foto para este produto'),'?',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
                            if I = IDYES then
                            begin
                              DeleteFile(pChar('res'+Form7.IBDataSet4REGISTRO.AsString+'.jpg'));
                              s := '';
                            end;
                          end;
                        end;
                      end;
                    end;
                    //
                  end;
                  //
                except
                  ShowMessage('Download falhou!!!');
                end;
                //
                // Foto do produto OK
                //
              end;
            end;
            //
            s := Copy(Copy(s,7,Length(s)-7), Pos('http://',Copy(Lowercase(s),7,Length(s)-7)), Length(Copy(s,7,Length(s)-7))-Pos('http://',Copy(Lowercase(s),7,Length(s)-7))+7);
            //
          end;
          }
          for iSrc := 0 to WebBrowser1.OleObject.Document.Images.Length - 1 do
          begin
            sLinkDaFoto := WebBrowser1.OleObject.Document.Images.Item(iSrc).Src;
            if (sLinkDaFoto <> '') then
            begin
              try
                // Faz o download dA Imagem sLinkDaFoto e salva no 'c:\tempo.jpg'
                  DownloadArquivoImg(PChar(sLinkDaFoto), PChar(Form10.sNomeDoJPG));
                  if FileExists(Form10.sNomeDoJPG) then
                  begin
                    //try
                      // Sandro Silva 2022-09-27 AtualizaTela(True);
                    if AtualizaTela(True) then
                    begin
                    //finally
                      //
                      if Form7.ibDataset4FOTO.BlobSize <> 0 then
                      begin
                        J := J + 1;
                        if J >= 7 then
                        begin
                          {Sandro Silva 2022-09-27 inicio
                          CopyFile(pChar('res' + Form7.IBDataSet4REGISTRO.AsString + '.jpg'), pChar(Form10.sNomeDoJPG), False);
                          AtualizaTela(True);
                          }
                          Form7.ibDataset4FOTO.Value := Form7.ibDataset4FOTO.OldValue;
                          AtualizaTela(True);
                          {Sandro Silva 2022-09-27 fim}
                          //s := '';
                          Break;
                        end else
                        begin
                          // Sandro Silva 2022-09-27 I := Application.MessageBox(Pchar('Quer usar esta foto para este produto'), '?', mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
                          I := Application.MessageBox(Pchar('Quer usar esta foto para este produto?'), Pchar('Sugestão ' + IntToStr(J) + ' de 6'), MB_YESNOCANCEL + mb_DefButton2 + MB_ICONQUESTION);
                          if (I = IDYES) then
                          begin
                            DeleteFile(pChar('res' + Form7.IBDataSet4REGISTRO.AsString + '.jpg'));
                            //s := '';
                            Break;
                          end;
                          if I = IDCANCEL then
                          begin
                            Form7.ibDataset4FOTO.Value := Form7.ibDataset4FOTO.OldValue;
                            AtualizaTela(True);
                            Break;
                          end;
                        end;
                      end;
                    end;
                  end;
              except
                ShowMessage('Download falhou!!!');
              end;

            end;
          end;
          {
          if FileExists(pChar('res' + Form7.IBDataSet4REGISTRO.AsString + '.jpg')) then
          begin
            CopyFile(PChar('res' + Form7.IBDataSet4REGISTRO.AsString + '.jpg'), PChar(Form10.sNomeDoJPG), False);
            AtualizaTela(True);
          end;
          }
          {Sandro Silva 2022-09-26 fim}

          Screen.Cursor             := crDefault;              // Cursor de Aguardo
        except end;
      end;
    end;
  except end;
  Screen.Cursor             := crDefault;              // Cursor de Aguardo
end;

procedure TForm10.SMALL_DBEdit31Change(Sender: TObject);
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select * from IBPT_ where char_length(CODIGO) >= 8 and CODIGO='+QuotedStr(Form7.ibDataSet4CF.AsString));
  Form1.ibQuery1.Open;

  if Form1.ibQuery1.FieldByName('DESCRICAO').AsString <> '' then
  begin
    Form10.LabelDescricaoNCM.Caption := Copy(Form1.ibQuery1.FieldByName('DESCRICAO').AsString+Replicate(' ',50),1,50);
  end else
  begin
    Form10.LabelDescricaoNCM.Caption := 'Código NCM não cadastrado na tabela do IBPT';
  end;

  Form1.ibQuery1.Close;
end;

procedure TForm10.ORELHA_CFOPShow(Sender: TObject);
begin
    //
    __RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
    __AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
    __AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
    __PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
    __MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
    __AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
    __RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
    __MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
    __TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
    __CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
    __RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
    __PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
    __PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
    __PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
    __AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
    __SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
    __BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
    __GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
    __DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
    __MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
    __ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
    __MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
    __SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
    __RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
    __PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
    __SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
    __RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
    //
    __RR.font.size := 8;
    __AP.font.size := 8;
    __AM.font.size := 8;
    __PA.font.size := 8;
    __MA.font.size := 8;
    __AC.font.size := 8;
    __RO.font.size := 8;
    __MT.font.size := 8;
    __TO.font.size := 8;
    __CE.font.size := 8;
    __RN.font.size := 8;
    __PI.font.size := 8;
    __PB.font.size := 8;
    __PE.font.size := 8;
    __AL.font.size := 8;
    __SE.font.size := 8;
    __BA.font.size := 8;
    __GO.font.size := 8;
    __DF.font.size := 8;
    __MG.font.size := 8;
    __ES.font.size := 8;
    __MS.font.size := 8;
    __SP.font.size := 8;
    __RJ.font.size := 8;
    __PR.font.size := 8;
    __SC.font.size := 8;
    __RS.font.size := 8;
    //
    //
    if Form7.ibDataSet13ESTADO.AsString = 'RR' then __RR.Font.Color := clRed else __RR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AP' then __AP.Font.Color := clRed else __AP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AM' then __AM.Font.Color := clRed else __AM.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PA' then __PA.Font.Color := clRed else __PA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MA' then __MA.Font.Color := clRed else __MA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AC' then __AC.Font.Color := clRed else __AC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RO' then __RO.Font.Color := clRed else __RO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MT' then __MT.Font.Color := clRed else __MT.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'TO' then __TO.Font.Color := clRed else __TO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'CE' then __CE.Font.Color := clRed else __CE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RN' then __RN.Font.Color := clRed else __RN.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PI' then __PI.Font.Color := clRed else __PI.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PB' then __PB.Font.Color := clRed else __PB.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PE' then __PE.Font.Color := clRed else __PE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AL' then __AL.Font.Color := clRed else __AL.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SE' then __SE.Font.Color := clRed else __SE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'BA' then __BA.Font.Color := clRed else __BA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'GO' then __GO.Font.Color := clRed else __GO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'DF' then __DF.Font.Color := clRed else __DF.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MG' then __MG.Font.Color := clRed else __MG.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'ES' then __ES.Font.Color := clRed else __ES.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MS' then __MS.Font.Color := clRed else __MS.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then __SP.Font.Color := clRed else __SP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RJ' then __RJ.Font.Color := clRed else __RJ.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PR' then __PR.Font.Color := clRed else __PR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then __SC.Font.Color := clRed else __SC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RS' then __RS.Font.Color := clRed else __RS.Font.Color := clSilver;
    //

  AtualizaObjComValorDoBanco; // Sandro Silva 2023-06-28

  IBQPLANOCONTAS.Close;
  IBQPLANOCONTAS.SQL.Text :=
    'select REGISTRO, CONTA, NOME ' +
    'from CONTAS ' +
    'order by NOME';
  IBQPLANOCONTAS.Open;
end;

procedure TForm10.__RRClick(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    SMALL_DBEditX.DataField := Copy(Caption,1,2)+'_';
    SMALL_DBEditX.Top       := Top;
    SMALL_DBEditX.Left      := Left;
    SMALL_DBEditX.Visible   := True;
    SMALL_DBEditX.SetFocus;
    SMALL_DBEditX.SetFocus;
  end;
end;

procedure TForm10.SMALL_DBEditXExit(Sender: TObject);
begin
  SMALL_DBEditX.Visible   := False;

  __RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
  __AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
  __AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
  __PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
  __MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
  __AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
  __RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
  __MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
  __TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
  __CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
  __RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
  __PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
  __PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
  __PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
  __AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
  __SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
  __BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
  __GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
  __DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
  __MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
  __ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
  __MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
  __SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
  __RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
  __PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
  __SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
  __RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
end;

procedure TForm10._RRClick(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    if AllTrim(Form7.IbDataSet4ST.AsString) <> '' then
    begin
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * FROM ICM where ST='+QuotedStr(Form7.IbDataSet4ST.AsString)+' ');
      Form7.ibDataSet14.Open;
    end else
    begin
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Clear;
      Form7.ibDataSet14.SelectSQL.Add('select * FROM ICM where CFOP='+QuotedStr('5102')+' or CFOP='+QuotedStr('5101')+' ');
      Form7.ibDataSet14.Open;
    end;
    
    if Alltrim(Form7.IbDataSet4ST.AsString) <> '' then
    begin
      if AllTrim(Form7.IbDataSet4ST.AsString) <> AllTrim(Form7.IbDataSet14ST.AsString) then
      begin
        Form7.IbDataSet14.Append;
        Form7.ibDataSet14ST.AsString   := Form7.ibDataSet4ST.AsString;
        Form7.ibDataSet14BASE.Asfloat  := 100;
        Form7.ibDataSet14NOME.AsString := 'Código Interno de Tributação '+Form7.ibDataSet4ST.AsString;
        Form7.IbDataSet14.Post;
      end;
    end;
    
    Form7.IbDataSet14.EnableControls;
    Form7.IbDataSet14.Edit;
    
    SMALL_DBEDITY.DataField := Copy(Caption,1,2)+'_';
    SMALL_DBEDITY.Top       := Top;
    SMALL_DBEDITY.Left      := Left;
    SMALL_DBEDITY.Visible   := True;
    SMALL_DBEDITY.Refresh;
    
    if Form10.SMALL_DBEDITY.CanFocus then
    begin
      Form10.SMALL_DBEDITY.SetFocus;
    end;
  end;
end;

procedure TForm10.SMALL_DBEditYExit(Sender: TObject);
begin
  try Form7.ibDataSet14.Post; except end;
  try Form7.ibDataSet14.Edit; except end;

  SMALL_DBEDITY.Visible   := False;

  _RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
  _AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
  _AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
  _PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
  _MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
  _AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
  _RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
  _MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
  _TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
  _CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
  _RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
  _PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
  _PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
  _PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
  _AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
  _SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
  _BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
  _GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
  _DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
  _MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
  _ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
  _MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
  _SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
  _RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
  _PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
  _SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
  _RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
end;

procedure TForm10.ORELHA_COMISSAOEnter(Sender: TObject);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2.Post;
    Form7.IBDataSet2.Edit;
  except end;
end;

procedure TForm10.ComboBox11Change(Sender: TObject);
begin
  //
  // 5101 - Venda de produção do estabelecimento;
  // 5102 - Venda de mercadoria de terceiros;
  // 5103 - Venda de produção do estabelecimento efetuada fora do estabelecimento;
  // 5104 - Venda de mercadoria adquirida ou recebida de terceiros, efetuada fora do estabelecimento;
  // 5115 - Venda de mercadoria de terceiros, recebida anteriormente em consignação mercantil;
  // 5405 - Venda de mercadoria de terceiros, sujeita a ST, como contribuinte substituído;
  // 5656 - Venda de combustível ou lubrificante de terceiros, destinados a consumidor final;
  // 5667 - Venda de combustível ou lubrificante a consumidor ou usuário final estabelecido em outra Unidade da Federação;
  // 5933 - Prestação de serviço tributado pelo ISSQN (Nota Fiscal conjugada);
  //
  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CFOP.AsString := Copy(Form10.ComboBox11.Items[Form10.ComboBox11.ItemIndex]+'    ',1,4);
  end;
  //
end;

procedure TForm10.Label201MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form10.Label201.Font.Style <> [fsBold] then
  begin
    Form10.Image201.Picture    := Form10.Image201_X.Picture;
    Form10.Label201.Font.Style := [fsBold];
  end;
end;

procedure TForm10.Label202MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form10.Label202.Font.Style <> [fsBold] then
  begin
    Form10.Image202.Picture    := Form10.Image202_X.Picture;
    Form10.Label202.Font.Style := [fsBold];
  end;
end;

procedure TForm10.Label203MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form10.Label203.Font.Style <> [fsBold] then
  begin
    Form10.Image203.Picture    := Form10.Image203_X.Picture;
    Form10.Label203.Font.Style := [fsBold];
  end;
end;

procedure TForm10.Label204MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form10.Label204.Font.Style <> [fsBold] then
  begin
    Form10.Image204.Picture    := Form10.Image204_X.Picture;
    Form10.Label204.Font.Style := [fsBold];
  end;
end;

procedure TForm10.Label205MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if Form10.Label205.Font.Style <> [fsBold] then
  begin
    Form10.Image205.Picture    := Form10.Image205_X.Picture;
    Form10.Label205.Font.Style := [fsBold];
  end;
end;

procedure TForm10.Label201MouseLeave(Sender: TObject);
begin
  if Form10.Label201.Font.Style <> [] then
  begin
    Form10.Image201.Picture    := Form10.Image201_R.Picture;
    Form10.Label201.Font.Style := [];
  end;
end;

procedure TForm10.Label202MouseLeave(Sender: TObject);
begin
  if Form10.Label202.Font.Style <> [] then
  begin
    Form10.Image202.Picture    := Form10.Image202_R.Picture;
    Form10.Label202.Font.Style := [];
  end;
end;

procedure TForm10.Label203MouseLeave(Sender: TObject);
begin
  if Form10.Label203.Font.Style <> [] then
  begin
    Form10.Image203.Picture    := Form10.Image203_R.Picture;
    Form10.Label203.Font.Style := [];
  end;
end;

procedure TForm10.Label204MouseLeave(Sender: TObject);
begin
  if Form10.Label204.Font.Style <> [] then
  begin
    Form10.Image204.Picture    := Form10.Image204_R.Picture;
    Form10.Label204.Font.Style := [];
  end;
end;

procedure TForm10.Label205MouseLeave(Sender: TObject);
begin
  if Form10.Label205.Font.Style <> [] then
  begin
    Form10.Image205.Picture    := Form10.Image205_R.Picture;
    Form10.Label205.Font.Style := [];
  end;
end;

procedure TForm10.Orelha_CONVERSAOEnter(Sender: TObject);
var
  I : Integer;
begin
  ComboBox12.Items.Clear;
  ComboBox13.Items.Clear;
  //
  Form7.IBDataSet49.Close;
  Form7.IBDataSet49.SelectSQL.Clear;
  Form7.IBDataSet49.SelectSQL.Add('select * from MEDIDA order by SIGLA');
  Form7.IBDataSet49.Open;
  //
  while not Form7.IBDataSet49.Eof do
  begin
    ComboBox12.Items.Add(Form7.IBDataSet49SIGLA.AsString);
    ComboBox13.Items.Add(Form7.IBDataSet49SIGLA.AsString);
    Form7.IBDataSet49.Next;
  end;
  //
  if AllTrim(Form7.IbDataSet4MEDIDAE.AsString) = '' then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then Form7.ibDataset4.Edit;
    if AllTrim(Form7.IbDataSet4MEDIDA.AsString) <> '' then Form7.ibDataSet4MEDIDAE.AsString := Form7.ibDataSet4MEDIDA.AsString else
    begin
      Form7.ibDataSet4MEDIDAE.AsString := 'UND';
      Form7.ibDataSet4MEDIDA.AsString := 'UND';
    end;
  end;
  //
  for I := 0 to ComboBox12.Items.Count do
  begin
    if Form7.ibDataSet4MEDIDAE.AsString = ComboBox12.Items[I] then
    begin
      ComboBox12.ItemIndex := I;
    end;
    
    if Form7.ibDataSet4MEDIDA.AsString = ComboBox13.Items[I] then
    begin
      ComboBox13.ItemIndex := I;
    end;
  end;
  
  if Form7.IbDataSet4FATORC.AsFloat = 0 then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then Form7.ibDataset4.Edit;
    Form7.ibDataSet4FATORC.AsFloat := 1;
  end;
  
  Exemplo(True);
end;

procedure TForm10.SMALL_DBEdit64Change(Sender: TObject);
begin
  Exemplo(True);
end;

procedure TForm10.ComboBox12Change(Sender: TObject);
begin
  if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset4.Edit;
  Form7.ibDataSet4MEDIDAE.AsString :=  ComboBox12.Text;
  Exemplo(True);
end;

procedure TForm10.ComboBox13Change(Sender: TObject);
begin
  Form7.ibDataSet4MEDIDA.AsString  :=  ComboBox13.Text;
  Exemplo(True);
end;

procedure TForm10.SMALL_DBEdit64Exit(Sender: TObject);
begin
  if Form7.IbDataSet4FATORC.AsFloat = 0 then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset4.Edit;
    Form7.ibDataSet4FATORC.AsFloat := 1;
  end;
  Exemplo(True);
end;

procedure TForm10.cboOrigemProdEnter(Sender: TObject);
begin
  with Sender as tComboBox do
    SendMessage(Handle, CB_SETDROPPEDWIDTH, Form10.Width - Left - 30, 0);
end;

procedure TForm10.Orelha_codebarEnter(Sender: TObject);
begin
  Form7.IBDataSet6.Close;
  Form7.IBDataSet6.SelectSQL.Clear;
  Form7.IBDataSet6.SelectSQL.Add('select * from CODEBAR where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
  Form7.IBDataSet6.Open;
end;

procedure TForm10.DBGrid5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
     Form7.IBDataSet6.Delete;
  end;
end;

procedure TForm10.ComboBox14Change(Sender: TObject);
begin
  //
  // 00 - Tributada integralmente
  // 10 - Tributada e com cobrança de ICMS por substituição tributária
  // 20 - Com redução de base de cálculo
  // 30 - Isenta e não tributada de ICMS por substituição tributária
  // 40 - Isenta
  // 41 - Não tributada
  // 50 - Suspensão
  // 51 - Diferimento
  // 60 - ICMS Cobrado anteriormente por substituição tributária
  // 70 - Com red. de base de calculo e cob. do ICMS por subs. tributária
  // 90 - Outras
  //
  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    Form7.ibDataSet4CST_NFCE.AsString := Copy(Form7.ibDataSet4CST.AsString+' ',1,1)+Copy(Form10.ComboBox14.Items[Form10.ComboBox14.ItemIndex]+'   ',1,2);
  end;
end;

procedure TForm10.ComboBox15Change(Sender: TObject);
begin
  //
  // 101 - Tributada pelo Simples Nacional com permissão de crédito
  // 102 - Tributada pelo Simples Nacional sem permissão de crédito
  // 103 - Isenção do ICMS no Simples Nacional para faixa de receita bruta
  // 201 - Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por substituição tributária
  // 202 - Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por substituição tributária
  // 203 - Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por substituição tributária
  // 300 - Imune
  // 400 - Não tributada pelo Simples Nacional
  // 500 - ICMS cobrado anteriormente por substituição tributária (substituído) ou por antecipação
  // 900 - Outros
  //
  if Form10.Caption = form7.ibDataSet4DESCRICAO.AsString then
  begin
    // Sandro Silva 2023-05-09 Form7.ibDataSet4CSOSN_NFCE.AsString := Copy(Form10.ComboBox15.Items[Form10.ComboBox15.ItemIndex]+'   ',1,3);
    Form7.ibDataSet4CSOSN_NFCE.AsString := Trim(Copy(Form10.ComboBox15.Items[Form10.ComboBox15.ItemIndex]+'   ',1,3));
  end;
end;

procedure TForm10.btnRenogiarDividaClick(Sender: TObject);
var
  ftotal1, fTotal2 : Real;
  bButton : Integer;
  sNumeroNF : String;
begin
  try
    Form1.ibQuery2.Close;
    Form1.ibQuery2.SQL.Clear;
    Form1.ibQuery2.SQL.Add('create generator G_RENEGOCIACAO');
    Form1.ibQuery2.ExecSQL;
  except
  end;

  Form7.sTextoDoAcordo := '';

  Form7.ibDataSet7.Close;
  Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                     ' Where SubString(DOCUMENTO from 1 for 2)=''RE'' '+
                                     '   and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                     '   and coalesce(ATIVO,9)<>1 '+
                                     '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                     ' Order by VENCIMENTO';
  Form7.ibDataSet7.Open;
  Form7.ibDataSet7.Last;

  if Copy(Form7.ibDataSet7DOCUMENTO.AsString,1,2) = 'RE' then
  begin
    // Abre uma negociação já existente    
    sNumeroNF := LimpaNumero(Form7.ibDataSet7HISTORICO.AsString);

    Form7.ibQuery1.Close;
    Form7.IBQuery1.SQL.Clear;
    Form7.IBQuery1.SQL.Add(' update RECEBER set PORTADOR='''', ATIVO=0 '+
                           ' where PORTADOR=' + QuotedStr('ACORDO '+sNumeroNF) +
                           ' and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
    Form7.IBQuery1.Open;

    Form7.IBDataSet2.Edit;
    Form7.IBDataSet2MOSTRAR.AsFloat := 1;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Clear;
    Form7.ibDataSet7.Selectsql.Add(' Select * from RECEBER '+
                                   ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                   '   and coalesce(ATIVO,9)<>1 and SubString(DOCUMENTO from 1 for 2)<>''RE'' and Coalesce(VALOR_RECE,999999999)=0 '+
                                   ' Order by VENCIMENTO');
    Form7.ibDataSet7.Open;
  end else
  begin
    // Nova negociação
    try
      Form7.ibQuery2.Close;
      Form7.ibQuery2.SQL.Clear;
      Form7.ibQuery2.SQL.Add('select gen_id(G_RENEGOCIACAO,1) from rdb$database');
      Form7.ibQuery2.Open;

      sNumeroNF := strZero(StrToInt(Form7.ibQuery2.FieldByname('GEN_ID').AsString),12,0);
    except
    end;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                       ' Order by VENCIMENTO';
    Form7.ibDataSet7.Open;
  end;
  
  Form7.sTextoDoAcordo := 'Parcela    Vencimento   Valor R$      Atualizado R$ '+chr(13)+chr(10)+
                          '---------- ------------ ------------- --------------'+chr(13)+chr(10);
  fTotal1 := 0;
  fTotal2 := 0;
  
  while not Form7.ibDataSet7.Eof do
  begin
    Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat])+chr(13)+chr(10);
    fTotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
    fTotal2 := fTotal2 + Form7.ibDataSet7VALOR_JURO.AsFloat;
    Form7.ibDataSet7.Next;
  end;

  Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                          '                        ------------- ---------------'+chr(13)+chr(10)+
                          '                       '+Format('%15.2n',[fTotal1])+Format('%15.2n',[ftotal2])+chr(13)+chr(10);  
  if fTotal1 <> 0 then
  begin
    bButton := Application.MessageBox(Pchar('Considerar o valor atualizado com juros?'),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);

    if bButton = IDYES then
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia.'+chr(13)+chr(10);
      fTotal1 := fTotal2;
    end else
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia foi desconsiderado.'+chr(13)+chr(10);
    end;
    
    {Form7.ibDataSet15.Close;
    Form7.ibDataSet15.SelectSql.Clear;
    Form7.ibDataset15.SelectSql.Add('select first 1 * from VENDAS order by NUMERONF');
    Form7.ibDataset15.Open;
    //
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15DUPLICATAS.AsFloat  := 0;
    Form7.ibDataSet15TOTAL.AsFloat       := fTotal1;
    Form7.ibDataSet15CLIENTE.AsString    := Form7.IBDataSet2NOME.AsString;
    Form7.ibDataSet15NUMERONF.AsString   := sNumeroNF; Mauricio Parizotto 2023-06-30}

    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Clear;
    Form7.ibDataSet7.Selectsql.Add(' Select * from RECEBER '+
                                   ' Where NUMERONF='+QuotedStr(sNumeroNF)+
                                   '   and  NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                   ' Order by REGISTRO');
    Form7.ibDataSet7.Open;


    {while not Form7.ibDataSet7.Eof do
    begin
      Form7.ibDataSet15DUPLICATAS.AsFloat := Form7.ibDataSet15DUPLICATAS.AsFloat + 1;
      Form7.ibDataSet7.Next;
    end;
    //
    if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      Form7.ibDataSet15DUPLICATAS.AsFloat  := 1;
    //
    Form7.ibDataset7.First; Mauricio Parizotto 2023-06-30}

    Form18.Caption := 'Renegociação de dívida';
    Form18.vlrRenegociacao := fTotal1;
    Form18.nrRenegociacao := sNumeroNF;
    Form18.ShowModal;
    Form18.Caption := 'Desdobramento das duplicatas';

    //Form7.ibDataSet15.Cancel;
  end;
end;

procedure TForm10.Panel2DblClick(Sender: TObject);
begin
  Form10.Panel2.ShowHint := True;
end;

procedure TForm10.Orelha_TAGSShow(Sender: TObject);
var
  I : Integer;
  sEx, sTag, sValor, sExemplo, sDescricao : String;
begin
  StringGrid2.ColWidths[0] := 150;
  StringGrid2.ColWidths[1] := 150;
  StringGrid2.ColWidths[2] := 150;
  StringGrid2.ColWidths[3] := 670;
  
  Memo1.Width   := 800;
  dbMemo3.Width := 1000;
  
  sEx := '';
  
  for I := 0 to Form10.DBMemo3.Lines.Count + 1 do
  begin
    if pos('<',dbMemo3.Lines.Strings[I]) <> 0 then
    begin
      sEx := sEx + StringReplace(dbMemo3.Lines.Strings[I], #$D#$A, '', [rfReplaceAll])+chr(10);
    end;
  end;
  
  Memo1.Lines.Clear;
  
  Memo1.Lines.Add('<Tributavel>0 "Situações tributárias obtidas na prefeitura"</Tributavel>');
  Memo1.Lines.Add('<CodigoTributacaoMunicipio>000 "Código do item da lista de serviço. Obtido na prefeitura"</CodigoTributacaoMunicipio>');
  Memo1.Lines.Add('<cServico>000 "Código do serviço prestado dentro do município. Obtido na prefeitura"</cServico>');
  Memo1.Lines.Add('<cListServ>14.01 "Item da lista de serviços; Padrão ABRASF"</cListServ>');
  //
  Memo1.Lines.Add('<AliquotaPIS>0,00 "Aliquota PIS para emissão de NFS-e"   </AliquotaPIS>');
  Memo1.Lines.Add('<AliquotaCOFINS>0,00 "Aliquota COFINS para emissão de NFS-e"</AliquotaCOFINS>');
  Memo1.Lines.Add('<AliquotaINSS>0,00 "Aliquota INSS para emissão de NFS-e (Ex: 100*35%*11%=3,85)"  </AliquotaINSS>');
  Memo1.Lines.Add('<AliquotaIR>0,00 "Aliquota IR para emissão de NFS-e"    </AliquotaIR>');
  Memo1.Lines.Add('<AliquotaCSLL>0,00 "Aliquota CSLL para emissão de NFS-e"  </AliquotaCSLL>');
  //
  Memo1.Lines.Add('<cProdANVISA>0000000000000 "Código de Produto da ANVISA"</cProdANVISA>');
  Memo1.Lines.Add('<xMotivoIsencao>"Motivo da isenção da ANVISA"</xMotivoIsencao>');
  {Sandro Silva 2022-09-12 inicio}
  // ficha 6224 NT 2021.004 v1.33
  //
  // Informar os campos de rastreabilidade na emissão de NF-e
  //
  Memo1.Lines.Add('<rastro>Sim"Informar grupo Rastreamento de Produto"</rastro>');
  {Sandro Silva 2022-09-12 fim}
  //
  Memo1.Lines.Add('<cBenef>0000000000 "Código de Benefício Fiscal na UF aplicado ao item"</cBenef>');
  Memo1.Lines.Add('<motDesICMS>00 "Motivo da desoneração do ICMS"</motDesICMS>');
  Memo1.Lines.Add('<FCP>0,00 "Fundo de Combate a Pobreza"</FCP>');
  Memo1.Lines.Add('<FCPST>0,00 "Fundo de Combate a Pobreza ST"</FCPST>');
  Memo1.Lines.Add('<descANP>ANP "Descrição do produto conforme ANP"</descANP>');
  Memo1.Lines.Add('<pGLP>0,0000 "Informar em número decimal o % do GLP derivado de petróleo"</pGLP>');
  Memo1.Lines.Add('<pGNn>0,0000 "Informar em número decimal o % do Gás Natural Nacional"</pGNn>');
  Memo1.Lines.Add('<pGNi>0,0000 "Informar em número decimal o % do Gás Natural Importado"</pGNi>');
  Memo1.Lines.Add('<adRemICMSRet>0,0000 "Alíquota ad rem retido anteriormente"</adRemICMSRet>'); // Ficha 6906 Sandro Silva 2023-05-09
  Memo1.Lines.Add('<vPart>0,00  "Valor de partida"</vPart>');
  Memo1.Lines.Add('<uTrib>UN    "Unidade tributável"</uTrib>');
  Memo1.Lines.Add('<qTrib>0     "Quantidade tributável"</qTrib>');
  Memo1.Lines.Add('<cEAN>       "EAN do produto à ser informado no XML"</cEAN>');
  Memo1.Lines.Add('<cEANTrib>   "EAN tributável do Produto"</cEANTrib>');
  Memo1.Lines.Add('<cProd>      "Código Original do fornecdor do Produto ou Serviço"</cProd>');
  Memo1.Lines.Add('<vUnid>0,99  "Valor do IPI por Unidade"</vUnid>');
  Memo1.Lines.Add('<BCPISCOFINS>0,00  "Valor da Base de Cálculo PIS/COFINS"</BCPISCOFINS>');
  Memo1.Lines.Add('<cProdANP>000000001 "Código de produto da ANP"</cProdANP>');
  Memo1.Lines.Add('<pRedBC>0,00 "Percentual da redução de BC na NFC-e"</pRedBC>');
  Memo1.Lines.Add('<VAL>007 "Validade do produto em dias"</VAL>');
  Memo1.Lines.Add('<Obs1>Observação 1 "Esta observação será mostrada no corpo da NF"</OBS1>');
  Memo1.Lines.Add('<Obs2>Observação 2 "Esta observação será mostrada no corpo da NF"</OBS2>');
  Memo1.Lines.Add('<Obs3>Observação 3 "Esta observação será mostrada no corpo da NF"</OBS3>');
  Memo1.Lines.Add('<Obs4>Observação 4 "Esta observação será mostrada no corpo da NF"</OBS4>');
  Memo1.Lines.Add('<Obs5>Observação 5 "Esta observação será mostrada no corpo da NF"</OBS5>');
  Memo1.Lines.Add('<Obs6>Observação 6 "Esta observação será mostrada no corpo da NF"</OBS6>');
  Memo1.Lines.Add('<Obs7>Observação 7 "Esta observação será mostrada no corpo da NF"</OBS7>');
  Memo1.Lines.Add('<Obs8>Observação 8 "Esta observação será mostrada no corpo da NF"</OBS8>');
  Memo1.Lines.Add('<Obs9>Observação 9 "Esta observação será mostrada no corpo da NF"</OBS9>');
  //
  // JA. Detalhamento Específico de Veículos Novos
  //
  Memo1.Lines.Add('<tpOp>2"1=Venda concessionária, 2=Faturamento direto para consumidor final 3=Venda direta(frotista, governo, ...) 0=Outros"</tpOp>');
  Memo1.Lines.Add('<pot>40 "Potência Motor (CV) Potência máxima do motor do veículo em cavalo vapor"</pot>');
  Memo1.Lines.Add('<cilin>4 "Cilindradas Capacidade voluntária do motor expressa em centímetros cúbicos (CC). (cilindradas) (v2.0)"</cilin>');
  Memo1.Lines.Add('<pesoL>9.9999 "Peso Líquido Em toneladas - 4 casas decimais "</pesoL>');
  Memo1.Lines.Add('<pesoB>9.9999 "Peso Bruto Peso Bruto Total - em tonelada - 4 casas decimais "</pesoB>');
  Memo1.Lines.Add('<tpComb> 02 "Tipo de combustível"</tpComb>');
  Memo1.Lines.Add('<CMT>9.999 "Capacidade Máxima de Tração CMT-Capacidade Máxima de Tração - em Toneladas 4 casas decimais (v2.0)"</CMT>');
  Memo1.Lines.Add('<dist>99 "Distância entre eixos"</dist>');
  Memo1.Lines.Add('<anoMod>2020 "Ano Modelo de Fabricação"</anoMod>');
  Memo1.Lines.Add('<anoFab>2020 "Ano de Fabricação"</anoFab>');
  Memo1.Lines.Add('<tpPint>"Tipo de Pintura "</tpPint>');

  Memo1.Lines.Add('<tpVeic>01"Tipo de Veículo Utilizar Tabela RENAVAM"</tpVeic>');
  Memo1.Lines.Add('<espVeic>1"Espécie de Veículo Utilizar Tabela RENAVAM"</espVeic>');
  Memo1.Lines.Add('<VIN>N"Condição do VIN Informa-se o veículo tem VIN (chassi) remarcado. R=Remarcado; N=Normal"</VIN>');
  Memo1.Lines.Add('<condVeic>1"Condição do Veículo 1=Acabado; 2=Inacabado; 3=Semiacabado "</condVeic>');
  Memo1.Lines.Add('<cMod>"Código Marca Modelo Utilizar Tabela RENAVAM "</cMod>');
  Memo1.Lines.Add('<lota>5"Capacidade máxima de lotação Quantidade máxima permitida de passageiros sentados, inclusive o motorista. (v2.0) "</lota>');
  Memo1.Lines.Add('<CNAEISSQN>"CNAE compatível com este serviço na prefeitura"</CNAEISSQN>'); // Sandro Silva 2023-02-28

  //
  StringGrid2.Cells[0,0] := 'Nome';
  StringGrid2.Cells[1,0] := 'Valor';
  StringGrid2.Cells[2,0] := 'Exemplo';
  StringGrid2.Cells[3,0] := 'Descrição';

  {Sandro Silva 2022-09-12 inicio}
  //Ajustar a quantidade de linhas no grid ao número de linhas a serem preenchidas com as tags
  if StringGrid2.RowCount <= Form10.Memo1.Lines.Count + 1 then
    StringGrid2.RowCount := Form10.Memo1.Lines.Count + 1;
  {Sandro Silva 2022-09-12 fim}

  
  for I := 0 to Form10.Memo1.Lines.Count + 1 do
  begin    
    sTag       := AllTrim(Copy(Memo1.Lines.Strings[I],(pos('<',Memo1.Lines.Strings[I])+1), (pos('>',Memo1.Lines.Strings[I])-(pos('<',Memo1.Lines.Strings[I])+1))));
    sExemplo   := AllTrim(Copy(Memo1.Lines.Strings[I],Pos('<' + sTag + '>', Memo1.Lines.Strings[I]) + Length('<' + sTag + '>'),(Pos('</', Memo1.Lines.Strings[I])-(Pos('<' + sTag + '>', Memo1.Lines.Strings[I])+Length('<' + sTag + '>')))));
    //
    if Pos('"',sExemplo) <> 0 then
    begin
      sDescricao := AllTrim(Copy(sExemplo+Replicate(' ',200),Pos('"',sExemplo),200));
      sExemplo   := StrTran(sExemplo,sDescricao,'');
      sDescricao := StrTran(sDescricao,'"','');
    end else
    begin
      sDescricao := '';
    end;
    //
    if Pos('<' + sTag + '>', sEx)<> 0 then
    begin
      // sValor := AllTrim(Copy(sEx,Pos('<' + sTag + '>', sEx) + Length('<' + sTag + '>'),(Pos('</', sEx)-(Pos('<' + sTag + '>', sEx)+Length('<' + sTag + '>')))));
      sValor := RetornaValorDaTagNoCampo(sTag,sEx);
      sEx := StrTran(sEx,'<'+sTag+'>'+sValor+'</'+sTag+'>','');
    end else
    begin
      sValor   := '';
    end;
    //
    StringGrid2.Cells[0,I+1] := sTag;
    StringGrid2.Cells[1,I+1] := sValor;
    StringGrid2.Cells[2,I+1] := sExemplo;
    StringGrid2.Cells[3,I+1] := sDescricao;
    //
  end;
  //
  StringGrid2.EditorMode := True;
end;

procedure TForm10.Orelha_TAGSExit(Sender: TObject);
var
  I : Integer;
  sEx : String;
begin
  for I := 1 to 100 do
  begin
    if (AllTrim(StringGrid2.Cells[0,I])<>'') and (AllTrim(StringGrid2.Cells[1,I])<>'') then
    begin
      sEx := sEx + '<'+AllTrim(StringGrid2.Cells[0,I])+'>'+AllTrim(StringGrid2.Cells[1,I])+'</'+AllTrim(StringGrid2.Cells[0,I])+'>'+chr(10);
    end;
  end;

  try
    if Form7.ibDataSet4TAGS_.AsString <> sEx then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      Form7.ibDataSet4TAGS_.AsString := sEx;
      Form7.ibDataSet4.Post;
      Form7.ibDataset4.Edit;
    end;
  except end;
end;

procedure TForm10.StringGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ACol = 1 then
    StringGrid2.Options := StringGrid1.Options + [goEditing]
  else
    StringGrid2.Options := StringGrid1.Options - [goEditing];
end;

procedure TForm10.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  {$IFDEF VER150}
  if ACol <> 1 then
  begin
    StringGrid2.Canvas.Font.Color  := clGray;
    if gdSelected in State then
      StringGrid2.Canvas.Font.Color  := clBlack; // Sandro Silva 2023-05-15
    StringGrid2.Canvas.FillRect(Rect);
  end;

  StringGrid2.Canvas.FillRect(Rect);
  StringGrid2.Canvas.TextOut(Rect.Left+2, Rect.Top+2, StringGrid2.Cells[Acol,Arow]);
  {$ELSE}
  if (ACol > 1) and not (gdSelected in State) and (ARow > 0) then
  begin
    StringGrid2.Canvas.Font.Color  := clGray;
    StringGrid2.Canvas.FillRect(Rect);
    StringGrid2.Canvas.TextOut(Rect.Left+2, Rect.Top+2, StringGrid2.Cells[Acol,Arow]);
  end;
  {$ENDIF}
end;

procedure TForm10.Image1Click(Sender: TObject);
begin
  begin
    ShellExecute( 0, 'Open',pChar('https://www.google.com.br/maps/dir//'+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2COMPLE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2CEP.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2ESTADO.AsString))+' '
    ),'', '', SW_SHOWMAXIMIZED);
  end;
end;

procedure TForm10.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    if ProdutoValidoParaMarketplace(True) = '' then
    begin
      CheckBox2.Checked := True;
    end else
    begin
      CheckBox2.Checked := False;
      ShowMessage('Para vender este produto através de Marketplace'+chr(10)+'preencha pelo menos os seguintes campos: '+chr(10)+chr(10)+ProdutoValidoParaMarketplace(True));
    end;
  end;
  //
  try
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then Form7.ibDataset4.Edit;
    //
    if CheckBox2.Checked then
    begin
      Form7.ibDataSet4MARKETPLACE.AsString  := '1';
    end else
    begin
      Form7.ibDataSet4MARKETPLACE.AsString  := '';
    end;
    //
    Form7.ibDataset4.Post;
    Form7.ibDataset4.Edit;
    //
  except end;
end;

procedure TForm10.ButtoOpenPictureDialog1n22Click(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  CHDir(Form1.sAtual);
  
  if FileExists(OpenPictureDialog1.FileName) then
  begin
    Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
    
    while FileExists(pChar(Form10.sNomeDoJPG)) do
    begin
      DeleteFile(pChar(Form10.sNomeDoJPG));
    end;
    
    CopyFile(pChar(OpenPictureDialog1.FileName),pChar(Form10.sNomeDoJPG),True);
    
    while not FileExists(pChar(Form10.sNomeDoJPG)) do
    begin
      Sleep(100);
    end;
    
    Screen.Cursor             := crDefault;              // Cursor de Aguardo
    
    Form10.Image3.Picture.LoadFromFile(pChar(Form10.sNomeDoJPG));
    Form10.Image5.Picture.LoadFromFile(pChar(Form10.sNomeDoJPG));
    
    AtualizaTela(True);
  end;
end;

procedure TForm10.dbgComposicaoColEnter(Sender: TObject);
begin
  framePesquisaProdComposicao.Visible := False;
end;

procedure TForm10.ibDataSet28DESCRICAOChange(Sender: TField);
begin
  if Sender = Form7.ibDataSet28DESCRICAO then
  begin
    if (Trim(dbgComposicao.DataSource.DataSet.fieldbyname('DESCRICAO').AsString) = EmptyStr) then
    begin
      framePesquisaProdComposicao.Visible := False;
      Exit;
    end;

    framePesquisaProdComposicao.CarregarProdutos(dbgComposicao.DataSource.DataSet.fieldbyname('DESCRICAO').AsString);
  end;
end;

procedure TForm10.DefinirVisibleConsultaProdComposicao;
begin
  Form7.ibDataSet28.Edit;
  Form7.ibDataSet28.UpdateRecord;
  Form7.ibDataSet28.Edit;

  framePesquisaProdComposicao.Visible := (Form7.ibDataSet28.State in [dsEdit, dsInsert])
                                         and (dbgComposicao.Columns.Grid.SelectedField.FieldName = Form7.ibDataSet28DESCRICAO.FieldName)
                                         and (Form7.ibDataSet28DESCRICAO.AsString <> EmptyStr);
end;

procedure TForm10.dbgComposicaoColExit(Sender: TObject);
begin
  ibDataSet28DESCRICAOChange(Form7.ibDataSet28DESCRICAO);
end;

procedure TForm10.dbgComposicaoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if dbgComposicao.SelectedIndex = 0 then
  begin
    if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) and (Key <> VK_DELETE) then
    begin
      if not framePesquisaProdComposicao.Visible then
        framePesquisaProdComposicao.Visible := True
      else
        Form7.bFlag := False;

      Form7.ibDataSet28.Edit;
      Form7.ibDataSet28.UpdateRecord;
      Form7.ibDataSet28.Edit;
      Form7.bFlag := True;
    end;
  end;
end;

procedure TForm10.framePesquisaProdComposicaodbgItensPesqCellClick(
  Column: TColumn);
begin
  AtribuirItemPesquisaComposicao;
end;

procedure TForm10.framePesquisaProdComposicaodbgItensPesqKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
    AtribuirItemPesquisaComposicao;
end;

procedure TForm10.AtribuirItemPesquisaComposicao;
begin
  if allTrim(framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString) <> EmptyStr then
  begin
    Form7.ibDataSet28.Edit;
    Form7.ibDataSet28DESCRICAO.AsString := framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString;
    dbgComposicao.SetFocus;
  end;
end;

procedure TForm10.framePesquisaProdComposicaodbgItensPesqKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  framePesquisaProdComposicao.dbgItensPesqKeyDown(Sender, Key, Shift);
end;

procedure TForm10.DBGrid3CellClick(Column: TColumn);
begin
  DBGrid3DblClick(nil);
end;

procedure TForm10.AlteracaoInstituicaoFinanceira;
var
  vDescricaoAntes : string;
  vQtdParcelas : integer;
begin
  //Mauricio Parizotto 2023-05-29
  try
    //Verifica se mudou
    vDescricaoAntes := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction.DefaultDatabase,
                                             ' Select Coalesce(INSTITUICAOFINANCEIRA,'''')  '+
                                             ' From RECEBER'+
                                             ' Where REGISTRO ='+QuotedStr(Form7.ibDataSet7REGISTRO.AsString));

    if Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString <> vDescricaoAntes then
    begin
      if Trim(Form7.ibDataSet7NUMERONF.AsString) = '' then
        Exit;

      vQtdParcelas := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction.DefaultDatabase,
                                           ' Select count(*)  '+
                                           ' From RECEBER'+
                                           ' Where NUMERONF ='+QuotedStr(Form7.ibDataSet7NUMERONF.AsString));

      if vQtdParcelas > 1 then
      begin
        if Application.MessageBox(PChar('Deseja atribuir essa mesma Instituição financeira para os demais registros dessa venda?'),
                                  'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = id_Yes then
        begin
          ExecutaComando(' Update RECEBER'+
                         '   set INSTITUICAOFINANCEIRA ='+QuotedStr(Form7.ibDataSet7INSTITUICAOFINANCEIRA.AsString)+
                         ' Where NUMERONF ='+QuotedStr(Form7.ibDataSet7NUMERONF.AsString),
                         Form7.ibDataSet7.Transaction );
        end;
      end;
    end;
  except
  end;
end;

procedure TForm10.AtualizaObjComValorDoBanco;
begin
  if (Form7.sModulo = 'ICM') {and (orelhas.ActivePage = ORELHA_CFOP)} and Form10.Active {and (Form7.ibDataSet14.State in [dsEdit, dsInsert])} then
  begin

    Form7.ibDataSet14.Edit;
    if Form7.ibDataSet14SOBREIPI.AsString <> 'S' then
      Form7.ibDataSet14SOBREIPI.AsString := 'N';
    if Form7.ibDataSet14SOBREOUTRAS.AsString <> 'S' then
      Form7.ibDataSet14SOBREOUTRAS.AsString := 'N';
    if Form7.ibDataSet14FRETESOBREIPI.AsString <> 'S' then
      Form7.ibDataSet14FRETESOBREIPI.AsString := 'N';

    DBCheckSobreIPI.Checked       := Form7.ibDataSet14SOBREIPI.AsString = 'S';
    DBCheckSobreOutras.Checked    := Form7.ibDataSet14SOBREOUTRAS.AsString = 'S';
    DBCheckFRETESOBREIPI.Checked  := Form7.ibDataSet14FRETESOBREIPI.AsString = 'S';

    cbIntegracaoFinanceira.ItemIndex := 0;
    cbMovimentacaoEstoque.ItemIndex  := 0;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'CAIXA') then
      cbIntegracaoFinanceira.ItemIndex := 1;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'PAGAR') then
      cbIntegracaoFinanceira.ItemIndex := 2;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'RECEBER') then
      cbIntegracaoFinanceira.ItemIndex := 3;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), '=') then
      cbMovimentacaoEstoque.ItemIndex := 1;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), '0') then
      cbMovimentacaoEstoque.ItemIndex := 2;
  end;
end;

procedure TForm10.cbIntegracaoFinanceiraExit(Sender: TObject);
begin
  if (Form7.sModulo = 'ICM') and Form10.Active then
  begin
    Form7.ibDataSet14.Edit;
    if cbIntegracaoFinanceira.Text = '' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
    end
    else if cbIntegracaoFinanceira.Text = 'Caixa' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Caixa';
    end
    else if cbIntegracaoFinanceira.Text = 'Pagar' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Pagar';
    end
    else if cbIntegracaoFinanceira.Text = 'Receber' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Receber';
    end;
  end;
end;

procedure TForm10.cbMovimentacaoEstoqueExit(Sender: TObject);
begin
  if (Form7.sModulo = 'ICM') and Form10.Active then
  begin
    Form7.ibDataSet14.Edit;
    if cbMovimentacaoEstoque.Text = '' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
    end else if cbMovimentacaoEstoque.Text = TEXTO_NAO_MOVIMENTA_ESTOQUE then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + '=';
    end else if cbMovimentacaoEstoque.Text = TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + '0';
    end;
  end;
end;

procedure TForm10.DBMemo4Enter(Sender: TObject);
begin
  DBMemo4.MaxLength := Form7.ibDataSet14OBS.Size;
  
  SendMessage(DBMemo4.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(DBMemo4.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  DBMemo4.SelStart := Length(DBMemo4.Text); //move o cursor pra o final da ultima linha
  DBMemo4.SetFocus;

end;

procedure TForm10.ComboBoxEnter(Sender: TObject);
begin
  dBGrid3.Visible := False;
  dBGrid1.Visible := False;
end;

procedure TForm10.DBMemo4KeyPress(Sender: TObject; var Key: Char);
begin
  {Sandro Silva 2023-06-29 inicio}
  if Length(DBMemo4.Text) >= Form7.ibDataSet14OBS.Size then
  begin
    if not (Ord(Key) in [VK_BACK, VK_RETURN, 27..43]) then
      Key := #0;
  end;
  {Sandro Silva 2023-06-29 fim}
end;

function TForm10.MostraImagemEstoque: Boolean;
var
  FileStream : TFileStream;
  BlobStream : TStream;
  JP2         : TJPEGImage;

begin
  Form10.Image5.Picture := nil;
  Form10.Image3.Picture := nil;

  if AllTrim(Form7.ibDataSet4DESCRICAO.AsString) <> '' then
  begin
    // FOTOS ANTIGAS
    if FileExists(Form10.sNomeDoJPG) then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      FileStream := TFileStream.Create(pChar(Form10.sNomeDoJPG),fmOpenRead or fmShareDenyWrite);
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmWrite);
      try
        BlobStream.CopyFrom(FileStream, FileStream.Size);
      finally
        FileStream.Free;
        BlobStream.Free;
      end;
      // Form7.ibDataset4.Post;
      Deletefile(pChar(Form10.sNomeDoJPG));
    end;

    if Form7.ibDataset4FOTO.BlobSize <> 0 then
    begin
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmRead);
      jp2 := TJPEGImage.Create;
      try
        try
          jp2.LoadFromStream(BlobStream);
          Form10.Image5.Picture.Assign(jp2);
          Form10.Image5.Repaint;

        except
          Result := False;
        end;
      finally
        BlobStream.Free;
        jp2.Free;
      end;
    end
    else
      Form10.Image5.Picture := Form10.Image3.Picture;
  end
  else
    Form10.Image5.Picture := Form10.Image3.Picture;

  // Mantem a proporção da imagem
  try
    if Form10.Image5.Picture.Width <> 0 then
    begin
      Form10.Image5.Width   := 256;
      Form10.Image5.Height  := 256;

      if Form10.Image5.Picture.Width > Form10.Image5.Picture.Height then
      begin
        Form10.Image5.Width  := StrToInt(StrZero((Form10.Image5.Picture.Width * (Form10.Image5.Width / Form10.Image5.Picture.Width)),10,0));
        Form10.Image5.Height := StrToInt(StrZero((Form10.Image5.Picture.Height* (Form10.Image5.Width / Form10.Image5.Picture.Width)),10,0));
      end else
      begin
        Form10.Image5.Width  := StrToInt(StrZero((Form10.Image5.Picture.Width * (Form10.Image5.Height / Form10.Image5.Picture.Height)),10,0));
        Form10.Image5.Height := StrToInt(StrZero((Form10.Image5.Picture.Height* (Form10.Image5.Height / Form10.Image5.Picture.Height)),10,0));
      end;

      Form10.Image5.Picture := Form10.Image5.Picture;
      Form10.Image5.Repaint; // Sandro Silva 2023-08-21
    end;
  except
  end;
        
end;

procedure TForm10.SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Form7.sModulo = 'CONVERSAOCFOP' then
    ValidaValor(Sender,Key,'I');
end;

procedure TForm10.cboCST_IPI_PerTribChange(Sender: TObject);
begin
  if Form10.caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCST_IPI.AsString := Copy(cboCST_IPI_PerTrib.Items[cboCST_IPI_PerTrib.ItemIndex]+'  ',1,2);
  end;
end;

procedure TForm10.orelha_PerfilTrib_IPIShow(Sender: TObject);
var
  I : integer;
begin
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
  begin
    Form10.Caption := form7.ibdPerfilTributaDESCRICAO.AsString;

    // Antes de tudo Zera os combos
    cboCST_IPI_PerTrib.ItemIndex := -1;
    cboCST_PISCOFINS_S_PerTrib.ItemIndex := -1;
    cboCST_PISCOFINS_E_PerTrib.ItemIndex := -1;
    cboTipoItemPerfTrib.ItemIndex := -1;
    cboIPPTPerfTrib.ItemIndex := -1;
    cboIATPerfTrib.ItemIndex := -1;
    cboOrigemPerfTrib.ItemIndex := -1;
    cboCFOP_NFCePerfTrib.ItemIndex := -1;
    cboCSTPerfilTrib.ItemIndex := -1;
    cboCSOSNPerfilTrib.ItemIndex := -1;
    cboCST_NFCePerfilTrib.ItemIndex := -1;
    cboCSOSN_NFCePerfilTrib.ItemIndex := -1;

    if Form7.bSoLeitura or Form7.bEstaSendoUsado then
    begin
      cboCST_IPI_PerTrib.Enabled := False;
      cboCST_PISCOFINS_S_PerTrib.Enabled  := False;
      cboCST_PISCOFINS_E_PerTrib.Enabled  := False;
      cboTipoItemPerfTrib.Enabled         := False;
      cboIPPTPerfTrib.Enabled             := False;
      cboIATPerfTrib.Enabled              := False;
      cboOrigemPerfTrib.Enabled           := False;
      cboCFOP_NFCePerfTrib.Enabled        := False;
      cboCSTPerfilTrib.Enabled            := False;
      cboCSOSNPerfilTrib.Enabled          := False;
      cboCST_NFCePerfilTrib.Enabled       := False;
      cboCSOSN_NFCePerfilTrib.Enabled     := False;
    end else
    begin
      cboCST_IPI_PerTrib.Enabled          := True;
      cboCST_PISCOFINS_S_PerTrib.Enabled  := True;
      cboCST_PISCOFINS_E_PerTrib.Enabled  := True;
      cboTipoItemPerfTrib.Enabled         := True;
      cboIPPTPerfTrib.Enabled             := True;
      cboIATPerfTrib.Enabled              := True;
      cboOrigemPerfTrib.Enabled           := True;
      cboCFOP_NFCePerfTrib.Enabled        := True;
      cboCSTPerfilTrib.Enabled            := True;
      cboCSOSNPerfilTrib.Enabled          := True;
      cboCST_NFCePerfilTrib.Enabled       := True;
      cboCSOSN_NFCePerfilTrib.Enabled     := True;
    end;

    if not (Form7.ibdPerfilTributa.State in ([dsEdit, dsInsert])) then
      Form7.ibdPerfilTributa.Edit;


    //Tipo Item
    if AllTrim(Form7.ibdPerfilTributaTIPO_ITEM.AsString)<>'' then
    begin
      for I := 0 to cboTipoItemPerfTrib.Items.Count -1 do
      begin
        if Copy(cboTipoItemPerfTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaTIPO_ITEM.AsString)) then
        begin
          cboTipoItemPerfTrib.ItemIndex := I;
        end;
      end;
    end;

    //CST IPI
    if AllTrim(Form7.ibdPerfilTributaCST_IPI.AsString)<>'' then
    begin
      for I := 0 to cboCST_IPI_PerTrib.Items.Count -1 do
      begin
        if Copy(cboCST_IPI_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_IPI.AsString)) then
        begin
          cboCST_IPI_PerTrib.ItemIndex := I;
        end;
      end;
    end;

    //IPPT
    for I := 0 to cboIPPTPerfTrib.Items.Count -1 do
    begin
      if Copy(cboIPPTPerfTrib.Items[I],1,1) = UpperCase(AllTrim(Form7.ibdPerfilTributaIPPT.AsString)) then
      begin
        cboIPPTPerfTrib.ItemIndex := I;
      end;
    end;

    //IAT
    for I := 0 to cboIATPerfTrib.Items.Count -1 do
    begin
      if Copy(cboIATPerfTrib.Items[I],1,1) = UpperCase(AllTrim(Form7.ibdPerfilTributaIAT.AsString)) then
      begin
        cboIATPerfTrib.ItemIndex := I;
      end;
    end;

    //Origem
    if AllTrim(Form7.ibdPerfilTributaCST.AsString)<>'' then
    begin
      for I := 0 to cboOrigemPerfTrib.Items.Count -1 do
      begin
        if Copy(cboOrigemPerfTrib.Items[I],1,1) = Copy(Form7.ibdPerfilTributaCST.AsString+'000',1,1) then
        begin
          cboOrigemPerfTrib.ItemIndex := I;
        end;
      end;
    end;

    //CFOP NFCe
    if AllTrim(Form7.ibdPerfilTributaCFOP.AsString)<>'' then
    begin
      for I := 0 to cboCFOP_NFCePerfTrib.Items.Count -1 do
      begin
        if Copy(cboCFOP_NFCePerfTrib.Items[I],1,4) = UpperCase(AllTrim(Form7.ibdPerfilTributaCFOP.AsString)) then
        begin
          cboCFOP_NFCePerfTrib.ItemIndex := I;
        end;
      end;
    end;

    //CST
    if AllTrim(Form7.ibdPerfilTributaCST.AsString)<>'' then
    begin
      for I := 0 to cboCSTPerfilTrib.Items.Count -1 do
      begin
        if Copy(cboCSTPerfilTrib.Items[I],1,2) = Copy(Form7.ibdPerfilTributaCST.AsString+'000',2,2) then
        begin
          cboCSTPerfilTrib.ItemIndex := I;
        end;
      end;
    end;

    //CSOSN
    if AllTrim(Form7.ibdPerfilTributaCSOSN.AsString)<>'' then
    begin
      for I := 0 to cboCSOSNPerfilTrib.Items.Count -1 do
      begin
        if Copy(cboCSOSNPerfilTrib.Items[I],1, Length(Trim(Form7.ibdPerfilTributaCSOSN.AsString))) = UpperCase(AllTrim(Form7.ibdPerfilTributaCSOSN.AsString)) then
        begin
          cboCSOSNPerfilTrib.ItemIndex := I;
        end;
      end;
    end;

    //CST NFCE
    if AllTrim(Form7.ibdPerfilTributaCST_NFCE.AsString)<>'' then
    begin
      for I := 0 to cboCST_NFCePerfilTrib.Items.Count -1 do
      begin
        if Copy(cboCST_NFCePerfilTrib.Items[I],1,2) = Copy(Form7.ibdPerfilTributaCST_NFCE.AsString+'000',2,2) then
        begin
          cboCST_NFCePerfilTrib.ItemIndex := I;
        end;
      end;
    end;

    //CSOSN NFCE
    if AllTrim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString)<>'' then
    begin
      for I := 0 to cboCSOSN_NFCePerfilTrib.Items.Count -1 do
      begin
        if Copy(cboCSOSN_NFCePerfilTrib.Items[I],1,Length(Trim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString))) = UpperCase(AllTrim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString)) then
        begin
          cboCSOSN_NFCePerfilTrib.ItemIndex := I;
        end;
      end;
    end;


    //Pis-Cofins Saída
    if AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString)<>'' then
    begin
      for I := 0 to cboCST_PISCOFINS_S_PerTrib.Items.Count -1 do
      begin
        if Copy(cboCST_PISCOFINS_S_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString)) then
        begin
          cboCST_PISCOFINS_S_PerTrib.ItemIndex := I;
        end;
      end;
    end;

    //Pis-Cofins Entrada
    if AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString)<>'' then
    begin
      for I := 0 to cboCST_PISCOFINS_E_PerTrib.Items.Count -1 do
      begin
        if Copy(cboCST_PISCOFINS_E_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString)) then
        begin
          cboCST_PISCOFINS_E_PerTrib.ItemIndex := I;
        end;
      end;
    end;


    //CST-CSOCN
    if Form7.ibDataSet13CRT.AsString = '1' then
    begin
      lblCSOSNPerfilTrib.Visible       := True;
      cboCSOSNPerfilTrib.Visible       := True;
      lblCSTPerfilTrib.Visible         := False;
      cboCSTPerfilTrib.Visible         := False;

      lblCSOSN_NFCePerfilTrib.Visible  := True;
      cboCSOSN_NFCePerfilTrib.Visible  := True;
      lblCST_NFCePerfilTrib.Visible    := False;
      cboCST_NFCePerfilTrib.Visible    := False;
    end else
    begin
      lblCSOSNPerfilTrib.Visible       := False;
      cboCSOSNPerfilTrib.Visible       := False;
      lblCSTPerfilTrib.Visible         := True;
      cboCSTPerfilTrib.Visible         := True;

      lblCSOSN_NFCePerfilTrib.Visible  := False;
      cboCSOSN_NFCePerfilTrib.Visible  := False;
      lblCST_NFCePerfilTrib.Visible    := True;
      cboCST_NFCePerfilTrib.Visible    := True;
    end;

    //NFC-e ou SAT
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then
    begin
      lblCFOPNfce.Caption             := StrTran(Label83.Caption,'NFC-e','SAT');
      lblCST_NFCePerfilTrib.Caption   := StrTran(Label84.Caption,'NFC-e','SAT');
      lblCSOSN_NFCePerfilTrib.Caption := StrTran(Label92.Caption,'NFC-e','SAT');
      lblAliqNFCEPerfilTrib.Caption   := StrTran(Label72.Caption,'NFC-e','SAT');
    end else
    begin
      lblCFOPNfce.Caption             := StrTran(Label83.Caption,'SAT','NFC-e');
      lblCST_NFCePerfilTrib.Caption   := StrTran(Label84.Caption,'SAT','NFC-e');
      lblCSOSN_NFCePerfilTrib.Caption := StrTran(Label92.Caption,'SAT','NFC-e');
      lblAliqNFCEPerfilTrib.Caption   := StrTran(Label72.Caption,'SAT','NFC-e');
    end;

    //CIT
    CarregaCitPerfilTrib;

  end;
end;

procedure TForm10.orelha_PerfilTrib_IPIEnter(Sender: TObject);
begin
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
  begin
    if not (Form7.ibdPerfilTributa.State in ([dsEdit, dsInsert])) then
      Form7.ibdPerfilTributa.Edit;
  end;
end;

procedure TForm10.cboCST_PISCOFINS_S_PerTribChange(Sender: TObject);
begin
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
  begin
    if Form10.Caption = Form7.ibdPerfilTributaDESCRICAO.AsString then
    begin
      Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString := Copy(cboCST_PISCOFINS_S_PerTrib.Items[cboCST_PISCOFINS_S_PerTrib.ItemIndex]+'  ',1,2);
    end;

    if Copy(cboCST_PISCOFINS_S_PerTrib.Items[cboCST_PISCOFINS_S_PerTrib.ItemIndex]+'  ',1,2) = '03' then
    begin
      lblCST_PIS_S_PerTrib.Caption    := 'R$ PIS:';
      lblCST_COFINS_S_PerTrib.Caption := 'R$ COFINS:';
    end else
    begin
      lblCST_PIS_S_PerTrib.Caption    := '% PIS:';
      lblCST_COFINS_S_PerTrib.Caption := '% COFINS:';
    end;
  end;
end;

procedure TForm10.cboCST_PISCOFINS_E_PerTribChange(Sender: TObject);
begin
  if Form7.sModulo = 'PERFILTRIBUTACAO' then
  begin
    if AllTrim(Form10.Caption) = AllTrim(Form7.ibdPerfilTributaDESCRICAO.AsString) then
    begin
      Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString := Copy(cboCST_PISCOFINS_E_PerTrib.Items[cboCST_PISCOFINS_E_PerTrib.ItemIndex]+'  ',1,2);
    end;
  end;
end;

procedure TForm10.edtDescricaoPerfilTribMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TSMALL_DBEdit do
  begin
    Hint := Field.DisplayLabel;
    ShowHint := True;
  end;
end;

procedure TForm10.cboTipoItemPerfTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaTIPO_ITEM.AsString := Copy(cboTipoItemPerfTrib.Items[cboTipoItemPerfTrib.ItemIndex]+'  ',1,2);
  end;
end;

procedure TForm10.cboIPPTPerfTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaIPPT.AsString := Copy(cboIPPTPerfTrib.Items[cboIPPTPerfTrib.ItemIndex]+' ',1,1);
  end;
end;

procedure TForm10.cboIATPerfTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaIAT.AsString := Copy(cboIATPerfTrib.Items[cboIATPerfTrib.ItemIndex]+' ',1,1);
  end;
end;

procedure TForm10.cboOrigemPerfTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCST.AsString := Copy(cboOrigemPerfTrib.Items[cboOrigemPerfTrib.ItemIndex]+' ',1,1)+Copy(Form7.ibdPerfilTributaCST.AsString+'  ',2,2);
    Form7.ibdPerfilTributaCST_NFCE.AsString := Copy(cboOrigemPerfTrib.Items[cboOrigemPerfTrib.ItemIndex]+' ',1,1)+Copy(Form7.ibdPerfilTributaCST_NFCE.AsString+'  ',2,2); // Mauricio Parizotto 2023-09-06
  end;
end;

procedure TForm10.cboCFOP_NFCePerfTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCFOP.AsString := Copy(cboCFOP_NFCePerfTrib.Items[cboCFOP_NFCePerfTrib.ItemIndex]+'    ',1,4);
  end;
end;

procedure TForm10.cboCSTPerfilTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCST.AsString := Copy(Form7.ibdPerfilTributaCST.AsString+' ',1,1)+Copy(cboCSTPerfilTrib.Items[cboCSTPerfilTrib.ItemIndex]+'   ',1,2);
  end;
end;

procedure TForm10.cboCST_NFCePerfilTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCST_NFCE.AsString := Copy(Form7.ibdPerfilTributaCST.AsString+' ',1,1)+Copy(cboCST_NFCePerfilTrib.Items[cboCST_NFCePerfilTrib.ItemIndex]+'   ',1,2);
  end;
end;

procedure TForm10.cboCSOSN_NFCePerfilTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCSOSN_NFCE.AsString := Trim(Copy(cboCSOSN_NFCePerfilTrib.Items[cboCSOSN_NFCePerfilTrib.ItemIndex]+'   ',1,3));
  end;
end;

procedure TForm10.cboCSOSNPerfilTribChange(Sender: TObject);
begin
  if Form10.Caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCSOSN.AsString := Trim(Copy(cboCSOSNPerfilTrib.Items[cboCSOSNPerfilTrib.ItemIndex]+'   ',1,3));
  end;
end;

procedure TForm10.CarregaCit;
var
  Localizado : boolean;
begin
  try
    Localizado := False;

    if AllTrim(Form7.IbDataSet4ST.AsString) <> '' then
    begin
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Text := ' Select * FROM ICM '+
                                          ' Where ST='+QuotedStr(Form7.IbDataSet4ST.AsString);
      Form7.ibDataSet14.Open;

      if Alltrim(Form7.ibDataSet14CFOP.AsString) <> '' then
      begin
        Localizado := True;
      end;
    end;

    if Localizado then
    begin
      lblCIT.Caption := Form7.ibDataSet14CFOP.AsString + ' - ' + Form7.ibDataSet14NOME.AsString;
      pnlMapaICMS.Visible := True;

      Form7.ibDataSet14.Edit;

      _RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
      _AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
      _AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
      _PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
      _MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
      _AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
      _RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
      _MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
      _TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
      _CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
      _RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
      _PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
      _PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
      _PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
      _AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
      _SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
      _BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
      _GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
      _DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
      _MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
      _ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
      _MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
      _SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
      _RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
      _PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
      _SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
      _RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
 
      _RR.font.size := 8;
      _AP.font.size := 8;
      _AM.font.size := 8;
      _PA.font.size := 8;
      _MA.font.size := 8;
      _AC.font.size := 8;
      _RO.font.size := 8;
      _MT.font.size := 8;
      _TO.font.size := 8;
      _CE.font.size := 8;
      _RN.font.size := 8;
      _PI.font.size := 8;
      _PB.font.size := 8;
      _PE.font.size := 8;
      _AL.font.size := 8;
      _SE.font.size := 8;
      _BA.font.size := 8;
      _GO.font.size := 8;
      _DF.font.size := 8;
      _MG.font.size := 8;
      _ES.font.size := 8;
      _MS.font.size := 8;
      _SP.font.size := 8;
      _RJ.font.size := 8;
      _PR.font.size := 8;
      _SC.font.size := 8;
      _RS.font.size := 8;
 
      if Form7.ibDataSet13ESTADO.AsString = 'RR' then _RR.Font.Color := clRed else _RR.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'AP' then _AP.Font.Color := clRed else _AP.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'AM' then _AM.Font.Color := clRed else _AM.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'PA' then _PA.Font.Color := clRed else _PA.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'MA' then _MA.Font.Color := clRed else _MA.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'AC' then _AC.Font.Color := clRed else _AC.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'RO' then _RO.Font.Color := clRed else _RO.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'MT' then _MT.Font.Color := clRed else _MT.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'TO' then _TO.Font.Color := clRed else _TO.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'CE' then _CE.Font.Color := clRed else _CE.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'RN' then _RN.Font.Color := clRed else _RN.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'PI' then _PI.Font.Color := clRed else _PI.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'PB' then _PB.Font.Color := clRed else _PB.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'PE' then _PE.Font.Color := clRed else _PE.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'AL' then _AL.Font.Color := clRed else _AL.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'SE' then _SE.Font.Color := clRed else _SE.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'BA' then _BA.Font.Color := clRed else _BA.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'GO' then _GO.Font.Color := clRed else _GO.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'DF' then _DF.Font.Color := clRed else _DF.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'MG' then _MG.Font.Color := clRed else _MG.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'ES' then _ES.Font.Color := clRed else _ES.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'MS' then _MS.Font.Color := clRed else _MS.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'SP' then _SP.Font.Color := clRed else _SP.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'RJ' then _RJ.Font.Color := clRed else _RJ.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'PR' then _PR.Font.Color := clRed else _PR.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'SC' then _SC.Font.Color := clRed else _SC.Font.Color := clSilver;
      if Form7.ibDataSet13ESTADO.AsString = 'RS' then _RS.Font.Color := clRed else _RS.Font.Color := clSilver;
    end else
    begin
      lblCIT.Caption      := '';
      pnlMapaICMS.Visible := False;
    end;
  except
  end;
end;



procedure TForm10.CarregaCitPerfilTrib;
begin
  if AllTrim(Form7.ibdPerfilTributaST.AsString) <> '' then
  begin
    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Text := ' Select * FROM ICM '+
                                        ' Where ST='+QuotedStr(Form7.ibdPerfilTributaST.AsString);
    Form7.ibDataSet14.Open;

    if Alltrim(Form7.ibDataSet14CFOP.AsString) <> '' then
    begin
      lblCitPerfilTrib.Caption := Form7.ibDataSet14CFOP.AsString + ' - ' + Form7.ibDataSet14NOME.AsString;
    end else
    begin
      lblCitPerfilTrib.Caption := '';
    end;
  end else
  begin
    lblCitPerfilTrib.Caption := '';
  end;
end;

procedure TForm10.SMALL_DBEdit53Exit(Sender: TObject);
begin
  CarregaCitPerfilTrib;
end;

end.
