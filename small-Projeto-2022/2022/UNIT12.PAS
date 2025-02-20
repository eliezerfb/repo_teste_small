unit Unit12;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls, Mask, variants,
  DBCtrls, SMALL_DBEdit, smallfunc_xe, Menus, IniFiles, shellapi, Buttons,
  System.Generics.Collections, jpeg, Vcl.ComCtrls, IBX.IBCustomDataSet, IBX.IBQuery,

  uNotaFiscalEletronicaCalc, Vcl.AppEvnts;

function Retributa(pP1:Boolean):Boolean;
function ApagaIntegracaoComOCaixa(pP1:Boolean):Boolean;

type
  TForm12 = class(TForm)
    Label44: TLabel;
    Label55: TLabel;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    PopupMenuInsert: TPopupMenu;
    Emitirnotafiscaldevendasnobalco1: TMenuItem;
    Importaroramentos1: TMenuItem;
    ImportarOS2: TMenuItem;
    Panel6: TPanel;
    Button1: TBitBtn;
    Button2: TBitBtn;
    N1: TMenuItem;
    Incluirnovoitemnoestoque1: TMenuItem;
    Incluirnovocliente1: TMenuItem;
    Panel9: TPanel;
    Image5: TImage;
    PanelAtencao: TPanel;
    Image1: TImage;
    Label2: TLabel;
    BitBtnAtorInteressado: TBitBtn;
    PageControlAddressMktp: TPageControl;
    TabSheetEnderecoCliente: TTabSheet;
    tbsLocalEntrega: TTabSheet;
    TabSheetMktplace: TTabSheet;
    IBQuery1: TIBQuery;
    DataSource1: TDataSource;
    IBQueryRecebedor: TIBQuery;
    dsRecebedor: TDataSource;
    IBQueryAddress: TIBQuery;
    dsAddress: TDataSource;
    PanelRecebedor: TPanel;
    LabelRecebedor: TLabel;
    LabelEnderecoRecebedor: TLabel;
    DBLookupComboBoxEnderReceb: TDBLookupComboBox;
    PanelMtplace: TPanel;
    ComboBoxMarktplace: TComboBox;
    LabelMktplace: TLabel;
    PanelEnderecoCliente: TPanel;
    LabelEnderecoCliente: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    SMALL_DBEditRua: TSMALL_DBEdit;
    SMALL_DBEditBairro: TSMALL_DBEdit;
    SMALL_DBEditCEP: TSMALL_DBEdit;
    SMALL_DBEditMunicipio: TSMALL_DBEdit;
    SMALL_DBEditUF: TSMALL_DBEdit;
    SMALL_DBEditTelefone: TSMALL_DBEdit;
    SMALL_DBEditIE: TSMALL_DBEdit;
    EditRecebedorNome: TEdit;
    DBGridRecebedor: TDBGrid;
    PanelTop: TPanel;
    Label64: TLabel;
    Label4: TLabel;
    LabelRazao: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label9: TLabel;
    Label71: TLabel;
    imgLogoNFe: TImage;
    Label10: TLabel;
    Label25: TLabel;
    Label24: TLabel;
    Label56: TLabel;
    Label3: TLabel;
    lblHomologacao: TLabel;
    LabelNFVendaTitulo: TLabel;
    SMALL_DBEdit43: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit39: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    SMALL_DBEdit14: TSMALL_DBEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit6: TEdit;
    SMALL_DBEdit40: TSMALL_DBEdit;
    DBGrid2: TDBGrid;
    PanelProdutos: TPanel;
    DBGrid1: TDBGrid;
    DBGrid3: TDBGrid;
    PanelICMS: TPanel;
    Label29: TLabel;
    Label23: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label69: TLabel;
    SMALL_DBEdit17: TSMALL_DBEdit;
    SMALL_DBEdit45: TSMALL_DBEdit;
    SMALL_DBEdit44: TSMALL_DBEdit;
    SMALL_DBEdit21: TSMALL_DBEdit;
    SMALL_DBEdit20: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    PanelServico: TPanel;
    Label30: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label57: TLabel;
    Label59: TLabel;
    Label62: TLabel;
    SMALL_DBEdit18: TSMALL_DBEdit;
    SMALL_DBEdit19: TSMALL_DBEdit;
    DBGrid4: TDBGrid;
    PanelIdentificadorTransp: TPanel;
    SMALL_DBEdit42: TSMALL_DBEdit;
    SMALL_DBEdit22: TSMALL_DBEdit;
    SMALL_DBEdit23: TSMALL_DBEdit;
    SMALL_DBEdit24: TSMALL_DBEdit;
    SMALL_DBEdit25: TSMALL_DBEdit;
    edtTotalNota: TSMALL_DBEdit;
    Label38: TLabel;
    Label37: TLabel;
    Label36: TLabel;
    Label35: TLabel;
    Label34: TLabel;
    Label28: TLabel;
    SMALL_DBEdit41: TSMALL_DBEdit;
    Edit1: TEdit;
    SMALL_DBEdit28: TSMALL_DBEdit;
    SMALL_DBEdit29: TSMALL_DBEdit;
    SMALL_DBEdit30: TSMALL_DBEdit;
    Label43: TLabel;
    Label42: TLabel;
    Label41: TLabel;
    Label40: TLabel;
    Label39: TLabel;
    PanelEnderecoTransp: TPanel;
    SMALL_DBEdit31: TSMALL_DBEdit;
    SMALL_DBEdit32: TSMALL_DBEdit;
    SMALL_DBEdit33: TSMALL_DBEdit;
    SMALL_DBEdit26: TSMALL_DBEdit;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label45: TLabel;
    PanelObs: TPanel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label5: TLabel;
    SMALL_DBEdit38: TSMALL_DBEdit;
    SMALL_DBEdit37: TSMALL_DBEdit;
    SMALL_DBEdit36: TSMALL_DBEdit;
    SMALL_DBEdit35: TSMALL_DBEdit;
    SMALL_DBEdit34: TSMALL_DBEdit;
    SMALL_DBEdit15: TSMALL_DBEdit;
    DBMemo1: TDBMemo;
    SMALL_DBEdit27: TSMALL_DBEdit;
    ListBox2: TListBox;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBLookupComboBox2Exit(Sender: TObject);
    procedure imgLogoNFeClick(Sender: TObject);
    procedure SMALL_DBEditUFExit(Sender: TObject);
    procedure SMALL_DBEdit39Exit(Sender: TObject);
    procedure SMALL_DBEdit39Change(Sender: TObject);
    procedure SMALL_DBEdit39Enter(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit40Enter(Sender: TObject);
    procedure SMALL_DBEdit40Exit(Sender: TObject);
    procedure SMALL_DBEdit40Change(Sender: TObject);
    procedure SMALL_DBEdit41Change(Sender: TObject);
    procedure SMALL_DBEdit41Enter(Sender: TObject);
    procedure SMALL_DBEdit41Exit(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit22Enter(Sender: TObject);
    procedure SMALL_DBEdit43Change(Sender: TObject);
    procedure SMALL_DBEdit43Enter(Sender: TObject);
    procedure SMALL_DBEdit43Exit(Sender: TObject);
    procedure SMALL_DBEdit44Exit(Sender: TObject);
    procedure SMALL_DBEdit45Exit(Sender: TObject);
    procedure SMALL_DBEdit17Enter(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit48Enter(Sender: TObject);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure SMALL_DBEdit17KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit17Exit(Sender: TObject);
    procedure SMALL_DBEdit22Exit(Sender: TObject);
    procedure SMALL_DBEditBairroEnter(Sender: TObject);
    procedure SMALL_DBEdit52KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit41KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1Enter(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2Exit(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure SMALL_DBEdit4Exit(Sender: TObject);
    procedure SMALL_DBEditIEExit(Sender: TObject);
    procedure SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure Label64Click(Sender: TObject);
    procedure SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit9Exit(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ImportarOS2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid4KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid4KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit38Exit(Sender: TObject);
    procedure Emitirnotafiscaldevendasnobalco1Click(Sender: TObject);
    procedure Importaroramentos1Click(Sender: TObject);
    procedure Label28Click(Sender: TObject);
    procedure Label28MouseLeave(Sender: TObject);
    procedure Label28MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid4Enter(Sender: TObject);
    procedure DBGrid4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid4ColEnter(Sender: TObject);
    procedure Button2Enter(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Incluirnovoitemnoestoque1Click(Sender: TObject);
    procedure Incluirnovocliente1Click(Sender: TObject);
    procedure DBGrid3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit39KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo1Enter(Sender: TObject);
    procedure SMALL_DBEdit41KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Enter(Sender: TObject);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure Edit6Click(Sender: TObject);
    procedure PopupMenuInsertChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure ComboBoxMarktplaceExit(Sender: TObject);
    procedure SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit40Click(Sender: TObject);
    procedure SMALL_DBEdit43Click(Sender: TObject);
    procedure SMALL_DBEdit39Click(Sender: TObject);
    procedure SMALL_DBEdit41Click(Sender: TObject);
    procedure edtTotalNotaChange(Sender: TObject);
    procedure BitBtnAtorInteressadoClick(Sender: TObject);
    procedure tbsLocalEntregaShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditRecebedorNomeEnter(Sender: TObject);
    procedure DBGridRecebedorCellClick(Column: TColumn);
    procedure EditRecebedorNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridRecebedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditRecebedorNomeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBoxEnderRecebKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure LoadRecebedor(AFilterByNome: String = '');
    procedure SetRecebedor(AClear: Boolean = False);
    procedure LoadAddress();
    procedure ShowMarketplaceTab();
    procedure AtivaPesquisaNaturezaOP;
    procedure AtivaPesquisaVendedor;
    procedure AtivaPesquisaCliente;
    procedure AtivaPesquisaTransportadora;
    procedure ExibeColunasFCP(bOculta: Boolean);
    function getPodeFecharTela: Boolean;
    function TestarLimiteDisponivel: Boolean;
    procedure DefineVisibleHomologacao;
    procedure AjustaTamnhoColunasGridProduto;
    procedure ControlaColunasGridImpostos(AbNatOperManual: Boolean = False);
    procedure CarregaTipoConsumidor(sTipo : string);
    function IsConsumidorFinal: boolean;
    procedure AdjustLayout();
    procedure ShowPopupMenuInsert();
  public
    { Public declarations }
    vNotaFiscal : TNotaFiscalEletronicaCalc;
    fVelho      : Real;
    sOperacaoAntiga, sObservacaoAntiga, sSistema, sNovoNumero : String;
    bOk         : Boolean;
    fPrecoDoServico : array[0..99999] of real;
    procedure ExibeColunasFCPST(bExibe: Boolean);
    procedure ExibeColunaCSOSN(bExibe: Boolean);
    procedure ExibeColunaCSTICMS(FINNFE: String; CRT: String); // procedure ExibeColunaCSTICMS(bExibe: Boolean);
    procedure CriaVariavelCalcNota;

    property PodeFecharTela: Boolean read getPodeFecharTela;
  end;

var
  Form12: TForm12;
  MyBookmark: TBookmark;

implementation

uses
  Unit7, Mais, uFrmParcelas, Unit41, Unit43, Unit19,
  Unit24, Unit48, uFuncoesRetaguarda, uFuncoesFiscais, Windows,
  uFrmPesquisaOrcamento, uImportaOrcamento, uImportaOrdemServico,
  ufrmPesquisaOrdemServico, uDialogs, uAtorInteressado, uSmallConsts;

procedure TForm12.ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (DBLookupComboBoxEnderReceb.Focused()) then
  begin
    DBLookupComboBoxEnderReceb.Perform(WM_KEYDOWN, VK_DOWN, 0);
    Handled := True;
  end;
end;

procedure TForm12.ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if (DBLookupComboBoxEnderReceb.Focused()) then
  begin
    DBLookupComboBoxEnderReceb.Perform(WM_KEYDOWN, VK_UP, 0);
    Handled := True;
  end;
end;

procedure TForm12.SetRecebedor(AClear: Boolean);
begin
  if AClear then
  begin
    EditRecebedorNome.Text := '';
    Form7.DataSource15.DataSet.FieldByName('IDRECEBEDOR').AsVariant := Null;
    Form7.DataSource15.DataSet.FieldByName('LOCALENTREGA_END_PRINCIPAL').Value := Null;
    Form7.DataSource15.DataSet.FieldByName('IDLOCALENTREGA').Value := Null;
    DBGrid1.SetFocus;
    Exit;
  end;

  EditRecebedorNome.Text := IBQueryRecebedor.FieldByName('NOME').AsString;

  if not(Form7.DataSource15.DataSet.FieldByName('IDRECEBEDOR').Value =
    IBQueryRecebedor.FieldByName('IDCLIFOR').Value) then
  begin
    Form7.DataSource15.DataSet.FieldByName('IDLOCALENTREGA').Value := -1;
    Form7.DataSource15.DataSet.FieldByName('LOCALENTREGA_END_PRINCIPAL').Value := Null;
  end;

  Form7.DataSource15.DataSet.FieldByName('IDRECEBEDOR').Value :=
    IBQueryRecebedor.FieldByName('IDCLIFOR').Value;

  DBGridRecebedor.Visible := False;
  LoadAddress();

  DBLookupComboBoxEnderReceb.DropDown();
  DBLookupComboBoxEnderReceb.SetFocus();
end;

procedure TForm12.ShowMarketplaceTab();
begin
  TabSheetMktplace.TabVisible := False;

  if (Form7.ibDataSet15INDPRES.AsString = '2')
  or (Form7.ibDataSet15INDPRES.AsString = '3')
  or (Form7.ibDataSet15INDPRES.AsString = '4')
  or (Form7.ibDataSet15INDPRES.AsString = '9') then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.IBDataSet99.SelectSQL.Add(
      'select NOME from CLIFOR where CLIFOR='+QuotedStr('Marketplace')+
      ' order by NOME'
    );
    Form7.ibDataSet99.Open;

    if Form7.ibDataSet99.FieldByname('NOME').AsString <> '' then
    begin

      ComboBoxMarktplace.Text := AllTrim(Form7.ibDataSet15.FieldByname('MARKETPLACE').AsString);
      ComboBoxMarktplace.Items.Clear;
      ComboBoxMarktplace.Items.Add('');

      while not Form7.ibDataSet99.Eof do
      begin
        ComboBoxMarktplace.Items.Add(AllTrim(Form7.ibDataSet99.FieldByname('NOME').AsString));
        Form7.ibDataSet99.Next;
      end;
    end;
    TabSheetMktplace.TabVisible := True;
  end;
end;

procedure TForm12.ShowPopupMenuInsert();
begin
  var lPoint := LabelRazao.ClientToScreen(Point(0,0));
  PopUpMenuInsert.Popup(lPoint.X, lPoint.Y);
end;

function MostraFoto(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
  bMostrarImage: Boolean;
begin
  //
  {Sandro Silva 2022-10-10 inicio
  if Form7.ibDataset4FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form12.Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form12.Image5.Picture.Width > Form12.Image5.Picture.Height then
    begin
      Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
      Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
    end else
    begin
      Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
      Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
    end;
    Form12.Image5.Left := (Form12.Panel9.Width  - Form12.Image5.Width) div 2;
    Form12.Image5.Top  := (Form12.Panel9.Height - Form12.Image5.Height) div 2;
    Form12.Image5.Repaint;
    Form12.Panel9.Visible := True;
    Form12.Image5.Visible := True;
  end else
  begin
    Form12.Image5.Picture := nil;
    Form12.Image5.Visible := False;
    Form12.Panel9.Visible := False;
  end;

  Result := True;
  }
  bMostrarImage := False;
  Form12.Image5.Picture := nil;
  Form12.Image5.Visible := False;
  Form12.Panel9.Visible := False;

  if Form7.ibDataset4FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      try
        jp2.LoadFromStream(BlobStream);
        Form12.Image5.Picture.Assign(jp2);

        if Form12.Image5.Picture.Width > Form12.Image5.Picture.Height then
        begin
          Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
          Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
        end else
        begin
          Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
          Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
        end;
        Form12.Image5.Left := (Form12.Panel9.Width  - Form12.Image5.Width) div 2;
        Form12.Image5.Top  := (Form12.Panel9.Height - Form12.Image5.Height) div 2;
        Form12.Image5.Repaint;
        Form12.Panel9.Visible := True;
        Form12.Image5.Visible := True;

      except
      end;
    finally
      BlobStream.Free;
      jp2.Free;
    end;
  end;

  Result := True;
  {Sandro Silva 2022-10-10 fim}
end;

function ResizeLogoDanfe(P1:Boolean): Boolean;
var
  Rect  : tRect;
  vWidth, vHeight : integer;
begin
  {Mauricio Parizotto 2024-01-31 Inicio}
  vWidth := 140*3;
  vHeight := 88*3;
  {
  if (Form12.imgLogoNFe.Picture.Width <> vWidth) or  (Form12.imgLogoNFe.Picture.Height <> vHeight) then
  begin
    Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP');

    Rect.Top := 0;
    Rect.Left := 0;

    if (Form1.Image1.Picture.Width div vWidth) >= (Form1.Image1.Picture.Height div vHeight) then
    begin
      Rect.Right  := Form1.Image1.Picture.Width div ((Form1.Image1.Picture.Width div vWidth)+1);
      Rect.Bottom := Form1.Image1.Picture.Height div ((Form1.Image1.Picture.Width div vWidth)+1);
    end else
    begin
      Rect.Right  := Form1.Image1.Picture.Width div ((Form1.Image1.Picture.Height div vHeight)+1);
      Rect.Bottom := Form1.Image1.Picture.Height div ((Form1.Image1.Picture.Height div vHeight)+1);
    end;

    Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);

    Form1.Image1.Picture.Bitmap.Width  := Rect.Right;
    Form1.Image1.Picture.Bitmap.Height := Rect.Bottom;

    Form1.Image1.Picture.Bitmap.Width  := vWidth;
    Form1.Image1.Picture.Bitmap.Height := vHeight;

    Form1.Image1.Picture.SaveToFile(Form1.sAtual+'\LOGONFE.BMP');
  end;

  form12.imgLogoNFe.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP');

  Result := True;
  }

  if (Form12.imgLogoNFe.Picture.Width > vWidth) or  (Form12.imgLogoNFe.Picture.Height > vHeight) then
  begin
    Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP');

    Rect.Top := 0;
    Rect.Left := 0;

    if trunc( Form1.Image1.Picture.Height / ((Form1.Image1.Picture.Width / vWidth)) ) <= vHeight  then
    begin
      Rect.Right  := vWidth;
      Rect.Bottom := trunc( Form1.Image1.Picture.Height / ((Form1.Image1.Picture.Width / vWidth)) );
    end else
    begin
      Rect.Right  := trunc( Form1.Image1.Picture.Width / ((Form1.Image1.Picture.Height / vHeight)) );
      Rect.Bottom := vHeight;
    end;

    Form1.Image1.Canvas.stretchdraw(Rect,Form1.Image1.Picture.Graphic);

    Form1.Image1.Picture.Bitmap.Width  := Rect.Right;
    Form1.Image1.Picture.Bitmap.Height := Rect.Bottom;

    Form1.Image1.Picture.Bitmap.Width  := vWidth;
    Form1.Image1.Picture.Bitmap.Height := vHeight;

    Form1.Image1.Picture.SaveToFile(Form1.sAtual+'\LOGONFE.BMP');
  end;

  form12.imgLogoNFe.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP');

  Result := True;

  {Mauricio Parizotto 2024-01-31 Fim}
end;


function MostraFoto2(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
begin
  //
  if Form7.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2.FieldByname('FOTO'),bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form12.Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form12.Image5.Picture.Width > Form12.Image5.Picture.Height then
    begin
      Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
      Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Width / 2 / Form12.Image5.Picture.Width)),10,0)))*2;
    end else
    begin
      Form12.Image5.Width  := (StrToInt(StrZero((Form12.Image5.Picture.Width * (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
      Form12.Image5.Height := (StrToInt(StrZero((Form12.Image5.Picture.Height* (Form12.Panel9.Height / 2 / Form12.Image5.Picture.Height)),10,0)))*2;
    end;
    Form12.Image5.Left := (Form12.Panel9.Width  - Form12.Image5.Width) div 2;
    Form12.Image5.Top  := (Form12.Panel9.Height - Form12.Image5.Height) div 2;
    Form12.Image5.Repaint;
    Form12.Panel9.Visible := True;
    Form12.Image5.Visible := True;
  end else
  begin
    Form12.Image5.Picture := nil;
    Form12.Image5.Visible := False;
    Form12.Panel9.Visible := False;
  end;
  Result := True;
end;

function ApagaAsDuplicatasAnteriores(pP1:Boolean):Boolean;
begin
  //
  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    if Form7.ibDataSet7NUMERONF.AsString = Form7.ibDataSet15NUMERONF.AsString then
      Form7.ibDataSet7.Delete
    else
      Form7.ibDataSet7.Next;
  end;
  //
  Result := True;
  //
end;

function ApagaIntegracaoComOCaixa(pP1:Boolean):Boolean;
begin
  // Apaga lançamento anterior no livro caixa
  //
  Form7.ibDataSet100.Close;
  Form7.ibDataSet100.SelectSQL.Clear;
  Form7.ibDataSet100.SelectSQL.Add('delete from CAIXA where substring(HISTORICO from 1 for 22)='+QuotedStr('Nota Fiscal: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9))+' and DATA = '+QuotedStr(DateToStrInvertida(Form7.ibDataSet15EMISSAO.AsDateTime))+' ');
  Form7.IBDataSet100.Open;
  //
  Result := True;
end;

function Retributa(pP1:Boolean):Boolean;
var
  sReg16 : String;
begin
  Form7.sModulo := 'RETRIBUTA';

  try
    begin
      sReg16 := Form7.ibDataSet16REGISTRO.AsString;
      Form7.ibDataSet16.DisableControls;

      if Form7.ibDataSet16.Modified then Form7.ibDataSet16.Post;

      Form7.ibDataSet16.First;
      while not Form7.ibDataSet16.EOF do // Disable
      begin
        Form1.bFlag := True;
        Form7.ibDataSet16DESCRICAOChange(Form7.ibDataSet16DESCRICAO);
        Form7.ibDataSet16.Next;
      end;

      Form7.ibDataSet16.Locate('REGISTRO',sReg16,[]);
    end;
  except
  end;

  Form7.ibDataSet16.Edit;

  // não voltar Form7.ibDataSet16.EnableControls;  // Retributa

  Form7.sModulo := 'VENDA';
  Result := True;
end;

{$R *.DFM}

procedure TForm12.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if TipoCampoFloat(dbGrid1.SelectedField) then // Sandro Silva 2024-04-29 if dbGrid1.SelectedField.DataType = ftFloat then
    if Key = chr(46) then
      Key := chr(44);
end;


procedure TForm12.DBLookupComboBox2Exit(Sender: TObject);
begin
  try
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15.Post;
    Form7.ibDataSet18.Edit;
  except
  end;
end;

procedure TForm12.DBLookupComboBoxEnderRecebKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    DBLookupComboBoxEnderReceb
      .DataSource
        .DataSet
          .FieldByName(DBLookupComboBoxEnderReceb.DataField).Value := Null;
    Key := 0;
  end;

  if Key = VK_RETURN then
  begin
    DBGrid1.SetFocus;
    Key := 0;
  end;
end;

procedure TForm12.imgLogoNFeClick(Sender: TObject);
begin
  if FileExists(Form1.sAtual+'\LOGONFE.BMP') then
    imgLogoNFe.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP');

  if not FileExists(Form1.sAtual+'\LOGONFE.BMP') then
     imgLogoNFe.Picture.SaveToFile('LOGONFE.BMP');

  ShellExecute( 0, 'Open','pbrush.exe','LOGONFE.BMP', '', SW_SHOW);

  //ShowMessage('Tecle <enter> para que a nova imagem seja exibida.'); Mauricio Parizotto 2023-10-25
  MensagemSistema('Tecle <enter> para que a nova imagem seja exibida.');

  if FileExists(Form1.sAtual+'\LOGONFE.BMP') then
    imgLogoNFe.Picture.LoadFromFile('LOGONFE.BMP');

  imgLogoNFe.Picture.SaveToFile('LOGONFE.BMP');

  ResizeLogoDanfe(True);
end;

procedure TForm12.SMALL_DBEditUFExit(Sender: TObject);
begin
  Retributa(True);
  if form7.ibDataSet16.Modified then
    Form7.ibDataSet16.Post;
  dbGrid1.SetFocus;
end;

procedure TForm12.SMALL_DBEdit39Exit(Sender: TObject);
begin
  Form1.bChaveSelecionaCliente := False;
  // CPF/CGC
  if Form7.ibDataSet15CLIENTE.AsString <> Form7.ibDataSet2NOME.AsString then
  begin
    {Dailon Parisotto (f-20023) 2024-07-29 Inicio

    if AllTrim(LimpaNumero(SMALL_DBEdit39.Text))<>'' then
    begin
      if Length(LimpaNumero(Copy(SMALL_DBEdit39.Text,1,3)))=3 then
      begin
        if CpfCgc(LimpaNumero(SMALL_DBEdit39.Text)) then
        begin
          // CAAD9
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEdit39.Text))))+'');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;

          Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
        end;
      end;
    end;
    // CPF/CGC
    if AllTrim(SMALL_DBEdit39.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
    begin
      Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
    end;

    try
      Form7.ibDataSet15TOTALChange(Form7.ibDataSet15TOTAL);
    except end;

    Retributa(True);
    if form7.ibDataSet16.Modified then
      Form7.ibDataset16.Post;

    }
    Form7.bPesqProdNFPorConsulta := True;
    try
      // Fica muito lento devido a recalcular o total em todos os itens
      // Irá recalcular 1 unica vez ao final deste processo
      FreeAndNil(vNotaFiscal);

      if AllTrim(LimpaNumero(SMALL_DBEdit39.Text))<>'' then
      begin
        if Length(LimpaNumero(Copy(SMALL_DBEdit39.Text,1,3)))=3 then
        begin
          if CpfCgc(LimpaNumero(SMALL_DBEdit39.Text)) then
          begin
            // CAAD9
            Form7.ibDataSet2.DisableControls;
            Form7.ibDataSet2.Close;
            Form7.ibDataSet2.SelectSQL.Clear;
            Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEdit39.Text))))+'');
            Form7.ibDataSet2.Open;
            Form7.ibDataSet2.EnableControls;

            Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
          end;
        end;
      end;
      // CPF/CGC
      if AllTrim(SMALL_DBEdit39.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
      begin
        Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
      end;

      try
        Form7.ibDataSet15TOTALChange(Form7.ibDataSet15TOTAL);
      except end;

      vNotaFiscal := TNotaFiscalEletronicaCalc.Create;
      vNotaFiscal.CalculaValores(Form7.ibDataSet15,Form7.ibDataSet16);

      Retributa(True);
      if form7.ibDataSet16.Modified then
        Form7.ibDataset16.Post;

      //Mauricio Parizotto 2024-09-19
      if IsConsumidorFinal then
        CarregaTipoConsumidor('1')
      else
        CarregaTipoConsumidor('0');
    finally
      if (not Assigned(vNotaFiscal)) then
        vNotaFiscal := TNotaFiscalEletronicaCalc.Create;

      Form7.bPesqProdNFPorConsulta := False;
    end;
    {Dailon Parisotto (f-20023) 2024-07-29 Fim}
  end;
  // Cliente atrasado em vermelho
  if Form7.ibDataSet2MOSTRAR.AsString = '1' then SMALL_DBEdit39.Font.Color := clRed else SMALL_DBEdit39.Font.Color := clBlack;

  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    if (Form7.ibDataSet7NOME.AsString <> Form7.IBDataSet2NOME.AsString) and (Form7.ibDataSet7NUMERONF.AsString = Form7.ibDataSet15NUMERONF.AsString) then
    begin
      Form7.ibDataSet7.Edit;
      Form7.ibDataSet7NOME.AsString := Form7.IBDataSet2NOME.AsString;
      Form7.ibDataSet7.Post;
    end;
    Form7.ibDataSet7.Next;
  end;

  if SMALL_DBEdit39.Text = Form7.ibDataSet2.fieldByName('NOME').AsString then
    MostraFoto2(True);

  // Cliente atrasado em vermelho
  Form7.ibDataSet16.EnableControls;
end;

procedure TForm12.SMALL_DBEdit39Change(Sender: TObject);
begin
  if (Form12.Visible) and (Form7.ibDataSet2.Active) then
  begin
    if Form1.bChaveSelecionaCliente then
    begin
      dBGrid2.Visible    := True;
//      Form7.ibDataSet2.DisableControls;
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.SelectSQL.Clear;
      Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit39.Text)+'%')+' and coalesce(ATIVO,0)=0 order by NOME');
      Form7.ibDataSet2.Open;
//      Form7.ibDataSet2.EnableControls;
      dBGrid2.Repaint;
    end;
  end;
end;

procedure TForm12.SMALL_DBEdit39Enter(Sender: TObject);
begin
  Form1.bChaveSelecionaCliente := True;

  if SMALL_DBEdit39.Text = Form7.ibDataSet2.fieldByName('NOME').AsString then
    MostraFoto2(True);

  AtivaPesquisaCliente;

  SMALL_DBEdit39.SelectAll;
end;

procedure TForm12.DBGrid2DblClick(Sender: TObject);
begin
  Form7.ibDataSet15.Edit;
  {Dailon Parisotto (f-18425) 2024-05-02 Inicio

  Form7.ibDataSet15OPERACAO.AsString   := form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet15CLIENTE.AsString    := form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet15TRANSPORTA.AsString := form7.ibDataSet18NOME.AsString;
  Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;

  }
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet14 then
    Form7.ibDataSet15OPERACAO.AsString   := form7.ibDataSet14NOME.AsString;
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet2 then
  begin
    Form7.ibDataSet15CLIENTE.AsString    := form7.ibDataSet2NOME.AsString;

    //Mauricio Parizotto 2024-09-19
    if IsConsumidorFinal then
      CarregaTipoConsumidor('1')
    else
      CarregaTipoConsumidor('0');
  end;
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet18 then
    Form7.ibDataSet15TRANSPORTA.AsString := form7.ibDataSet18NOME.AsString;
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet9 then
    Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;
  {Dailon Parisotto (f-18425) 2024-05-02 Fim}

  if dbGrid2.Top = (SMALL_DBEdit39.Top + SMALL_DBEdit39.Height -1) then
    SMALL_DBEdit39.SetFocus;

  if dbGrid2.Top = (SMALL_DBEdit40.Top + SMALL_DBEdit40.Height -1) then
    SMALL_DBEdit40.SetFocus;

  if dbGrid2.Top = (SMALL_DBEdit41.Top + SMALL_DBEdit41.Height -1) then
    SMALL_DBEdit41.SetFocus;

  if dbGrid2.Top = (SMALL_DBEdit43.Top + SMALL_DBEdit43.Height -1) then
    SMALL_DBEdit43.SetFocus;
    
  dBGrid2.Visible := False;
end;

procedure TForm12.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MostraFoto2(True);
end;

procedure TForm12.DBGrid2CellClick(Column: TColumn);
begin
  Form7.ibDataSet15.Edit;
  {Dailon Parisotto (f-18425) 2024-05-02 Inicio

  Form7.ibDataSet15OPERACAO.AsString   := Form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet15CLIENTE.AsString    := Form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet15TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
  Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;

  }
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet14 then
    Form7.ibDataSet15OPERACAO.AsString   := Form7.ibDataSet14NOME.AsString;

  if DBGrid2.DataSource.DataSet = Form7.ibDataSet2 then
  begin
    Form7.ibDataSet15CLIENTE.AsString    := Form7.ibDataSet2NOME.AsString;

    //Mauricio Parizotto 2024-09-19
    if IsConsumidorFinal then
      CarregaTipoConsumidor('1')
    else
      CarregaTipoConsumidor('0');
  end;

  if DBGrid2.DataSource.DataSet = Form7.ibDataSet18 then
    Form7.ibDataSet15TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
  if DBGrid2.DataSource.DataSet = Form7.ibDataSet9 then
    Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;
  {Dailon Parisotto (f-18425) 2024-05-02 Fim}
end;

procedure TForm12.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    Form12.DBGrid2DblClick(Sender);
  end;
end;

procedure TForm12.SMALL_DBEdit40Enter(Sender: TObject);
var
  nRecNo: Integer;
  cObsAnt: String;
begin
  ShowMarketplaceTab();
  {Dailon Parisotto (smal-593) 2024-07-31 Inicio

  if (LimpaNumero(Edit2.Text) = '4') then
  begin
    // Devolução de mercadoria
    Form7.ibDataSet16IPI.Visible            := True;
    Form7.ibDataSet16CST_IPI.Visible        := True;
    Form7.ibDataSet16CST_ICMS.Visible       := True;
    Form7.ibDataSet16VICMS.Visible          := True;
    Form7.ibDataSet16VBC.Visible            := True;
    Form7.ibDataSet16ICM.Visible            := True;
    Form7.ibDataSet16VBCST.Visible          := True;
    Form7.ibDataSet16VICMSST.Visible        := True;
    Form7.ibDataSet16VIPI.Visible           := True;
    Form7.ibDataSet16XPED.Visible           := False;
    Form7.ibDataSet16NITEMPED.Visible       := False;
    Panel2.Visible := True;
    Panel2.Top     := Panel1.Top  + dbGrid1.Top  + 100;
    Panel2.Left    := Panel1.Left + dbGrid1.Left + dbGrid1.Width + 20;

    //if Form7.ibDataSet13CRT.AsString = '1' then Mauricio Parizotto 2024-08-07
    if (Form7.ibDataSet13CRT.AsString = '1')
      or (Form7.ibDataSet13CRT.AsString = '4') then
    begin
      ExibeColunaCSOSN(True);
      ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString); //ExibeColunaCSTICMS(False);
    end;

    Form12.Label2.Caption := 'Atenção!'+chr(10)+chr(10)+'Quando não for contribuinte do IPI'+chr(10)+
                                                        'deixar o campo CST IPI em branco (vai'+chr(10)+
                                                        'criar grupo IPIDevol).'+chr(10)+chr(10)+
                                                        'Quando for contribuinte do IPI deve preencher'+chr(10)+
                                                        'o campo CST IPI (vai criar grupo do IPI normal)'
  end else
  begin
    Form7.ibDataSet16IPI.Visible            := False;
    Form7.ibDataSet16CST_IPI.Visible        := False;
    Form7.ibDataSet16CST_ICMS.Visible       := False;
    Form7.ibDataSet16VICMS.Visible          := False;
    Form7.ibDataSet16VBC.Visible            := False;
    Form7.ibDataSet16ICM.Visible            := False;
    Form7.ibDataSet16VBCST.Visible          := False;
    Form7.ibDataSet16VICMSST.Visible        := False;
    Form7.ibDataSet16VIPI.Visible           := False;
    Form7.ibDataSet16XPED.Visible           := True;
    Form7.ibDataSet16NITEMPED.Visible       := True;
    Panel2.Visible := False;
  end;

  }
  ControlaColunasGridImpostos(Form7.ibDataSet14IMPOSTOMANUAL.AsString = 'S');
  {Dailon Parisotto (smal-593) 2024-07-31 Fim}

  if not dBGrid2.Visible then
  begin
    sOperacaoAntiga   := Form7.ibDAtaSet15OPERACAO.AsString;

    // Roda o evento MERCADORIACHANGE para seta a variavel sObservacaoAnt com os valores corretos.
    if Form7.ibDataSet15COMPLEMENTO.AsString <> EmptyStr then
    begin
      cObsAnt := Form7.ibDataSet15COMPLEMENTO.AsString;
      try
        Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
      finally
        {Sandro Silva 2024-09-09 inicio
        Identificado na revisão, com banco novo, em branco ocorre Not in Edit Mode
        Form7.ibDataSet15COMPLEMENTO.AsString := cObsAnt;
        }
        if not (Form7.ibDataSet15.State in [dsEdit, dsInsert]) then
          Form7.ibDataSet15.Edit;
        Form7.ibDataSet15COMPLEMENTO.AsString := cObsAnt;
        {Sandro Silva 2024-09-09 fim}
      end;
    end;
  end;

  if Form7.sModulo <> 'RETRIBUTA' then
  begin
    {Dailon Parisotto (f-18604) 2024-05-10 Inicio

    Form7.ibDataSet16.EnableControls;

    Por algum motivo ocorre o erro, se setar para o primeiro não ocorre problema
    }

    if Form7.ibDataSet16.ControlsDisabled then
    begin
      nRecNo := Form7.ibDataSet16.RecNo;
      DBGrid1.DataSource := nil;
      try
          Form7.ibDataSet16.First;
          Form7.ibDataSet16.EnableControls;

      finally
        Form7.ibDataSet16.RecNo := nRecNo;
        DBGrid1.DataSource := Form7.DataSource16;
      end;
    end;
    {Dailon Parisotto (f-18604) 2024-05-10 Fim}
  end;
  Form7.ibDataSet15.Enablecontrols;

  AtivaPesquisaNaturezaOP;

  AjustaTamnhoColunasGridProduto;

  SMALL_DBEdit40.SelectAll;
end;

procedure TForm12.AdjustLayout();
const
  DEFAULT_PANEL1_HEIGHT = 823;
  DEFAULT_PANELPRODUTOS_HEIGHT = 145;
begin
  var LayoutTela: String;
  with TIniFile.Create(Form1.sAtual+'\nfe.ini') do
  begin
    try
      LayoutTela := ReadString('NFE','Preenchimento','Simples');
    finally
      Free;
    end;
  end;

  PanelProdutos.Height := DEFAULT_PANELPRODUTOS_HEIGHT;

  Panel1.Height := PanelTop.Height
    + PageControlAddressMktp.Height
    + PanelProdutos.Height
    + PanelICMS.Height
    + PanelServico.Height
    + PanelIdentificadorTransp.Height
    + PanelEnderecoTransp.Height
    + PanelObs.Height;

  if LayoutTela = 'Simples' then
  begin
    PageControlAddressMktp.Visible := False;
    PanelServico.Visible := False;
    PanelEnderecoTransp.Visible := False;

    Panel1.Height := DEFAULT_PANEL1_HEIGHT
      - PanelEnderecoTransp.Height
      - PanelServico.Height
      - PanelEnderecoTransp.Height;
  end;

  if Panel1.Height < Panel6.Top then
    Panel1.Height := Panel6.Top;

  PanelProdutos.Height := DEFAULT_PANELPRODUTOS_HEIGHT
    + Panel6.Top - (PanelObs.Top + PanelObs.Height);

  while (PanelProdutos.Height >= DEFAULT_PANELPRODUTOS_HEIGHT) and
    ScrollBox1.VertScrollBar.IsScrollBarVisible do
  begin
    PanelProdutos.Height := PanelProdutos.Height - 1;
    Panel1.Height := Panel1.Height - 1;
  end;
end;

procedure TForm12.AjustaTamnhoColunasGridProduto;
var
  i: Integer;
begin
  for i := 0 to Pred(DBGrid1.Columns.Count) do
  begin
    // Valores até 999999,99
    if (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VBC.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VICMS.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VBCST.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VICMSST.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VIPI.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VBCFCPST.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16VFCPST.FieldName) then
      DBGrid1.Columns[i].Width := 80;
    // Percentual
    if (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16ICM.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16IPI.FieldName)
       or (DBGrid1.Columns[i].FieldName = Form7.ibDataSet16PFCPST.FieldName) then
      DBGrid1.Columns[i].Width := 50;
  end;
end;

procedure TForm12.SMALL_DBEdit40Exit(Sender: TObject);
begin
  // Joga p/obs a obs na tabela de icm  Limpando o que tinha
  Form7.ibDataSet14.Locate('NOME',AllTrim(SMALL_DBEdit40.Text),[]);

  if AllTrim(sOperacaoAntiga) <> AllTrim(Form7.ibDataSet14NOME.AsString) then
  begin
    Form7.ibQuery1.Close;
    Form7.ibQuery1.SQL.Clear;
    Form7.ibQuery1.SQL.Add('select * from ICM where NOME='+QuotedStr(sOperacaoAntiga)+' ');
    Form7.ibQuery1.Open;

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet16.First;
    Form7.bPesqProdNFPorConsulta := True;

    try
      // Fica muito lento devido a recalcular o total em todos os itens
      // Irá recalcular 1 unica vez ao final deste processo
      FreeAndNil(vNotaFiscal);
      while not Form7.ibDataSet16.EOF do // Disable
      begin
        if Form7.ibDataSet16TOTAL.AsString <> '' then
        begin
          if Form7.ibDataSet16CFOP.AsString = Form7.ibQuery1.FieldByName('CFOP').AsString then
          begin
            Form7.ibDataSet16.Edit;
            Form7.ibDataSet16CFOP.AsString := '';
          end;
        end;

        Form7.ibDataSet16.Next;
      end;
      vNotaFiscal := TNotaFiscalEletronicaCalc.Create;
      vNotaFiscal.CalculaValores(Form7.ibDataSet15,Form7.ibDataSet16);

      Retributa(True);

      if Form7.ibDataSet16.Modified then
        Form7.ibDataSet16.Post;

    finally
      if (not Assigned(vNotaFiscal)) then
        vNotaFiscal := TNotaFiscalEletronicaCalc.Create;

      Form7.bPesqProdNFPorConsulta := False;
    end;
  end;

  {Dailon Parisotto (f-20023) 2024-07-26 Fim}

  if SMALL_DBEdit40.Text <> '' then
  begin
    if (Pos( AnsiUpperCase(AllTrim(SMALL_DBEdit40.Text)), AnsiUpperCase(AllTrim(Form7.ibDataSet14NOME.AsString))) <> 0) then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;

      {Sandro Silva 2023-05-10 inicio}
      if pos('DEVOLUÇÃO',AnsiUpperCase(SMALL_DBEdit40.Text)) <> 0 then
      begin
        Form12.Edit2.Text := '4-Devolução de mercadoria';
        Form7.ibDataSet15FINNFE.AsString   := '4';
        ExibeColunasFCPST(True);
        //if Form7.ibDataSet13CRT.AsString = '1' then // Mauricio Parizotto 2024-08-07
        if (Form7.ibDataSet13CRT.AsString = '1')
          or (Form7.ibDataSet13CRT.AsString = '4') then
        begin
          ExibeColunaCSOSN(True); // Sandro Silva 2023-05-24
          ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString);
        end;
        SMALL_DBEdit40Enter(Sender);
      end;
      {Sandro Silva 2023-05-10 fim}

      Form7.ibDataSet14.Locate('NOME',AllTrim( Form7.ibDataSet15OPERACAO.AsString  ),[loCaseInsensitive, loPartialKey]); //Mauricio Parizotto 2024-02-05

      ObservacaoOperacao(False);
    end else
    begin
      if AllTrim(SMALL_DBEdit40.Text)<>AllTrim(Form7.ibDataSet14NOME.AsString) then
      begin
        if SMALL_DBEdit40.CanFocus then
          SMALL_DBEdit40.SetFocus;
      end;
    end;
  end;

  ControlaColunasGridImpostos(Form7.ibDataSet14IMPOSTOMANUAL.AsString = 'S'); // Dailon Parisotto 2024-07-31

  Form7.ibDataSet16.EnableControls;
end;

procedure TForm12.SMALL_DBEdit40Change(Sender: TObject);
begin
  if (Form12.Visible) and (Form7.ibDataSet14.Active) then
  begin
    dBGrid2.Visible := True;
    DBGridRecebedor.Visible := False;
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM ICM where ((CFOP like '+QuotedStr('5%')+') or (CFOP like '+QuotedStr('6%')+') or (CFOP like '+QuotedStr('7%')+')) and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit40.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet14.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    Form7.IBDataSet99.EnableControls;
    
    Form7.ibDataSet15.Enablecontrols;
    dBGrid2.DataSource := Form7.DataSource14;
    Form7.ibDataSet14.EnableControls;
  end;
end;


procedure TForm12.SMALL_DBEdit41Change(Sender: TObject);
begin
  if (Form12.Visible) and (Form7.ibDataSet18.Active) then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM TRANSPOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit41.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet18.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TForm12.SMALL_DBEdit41Enter(Sender: TObject);
begin
  AtivaPesquisaTransportadora;
  
  SMALL_DBEdit41.SelectAll;
end;

procedure TForm12.SMALL_DBEdit41Exit(Sender: TObject);
begin
  if SMALL_DBEdit41.Text <> '' then
  begin
    if Pos( AnsiUpperCase(AllTrim(SMALL_DBEdit41.Text)), AnsiUpperCase(AllTrim(Form7.ibDataSet18NOME.AsString))) <> 0 then
    begin
      //
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
      // if AllTrim(Form7.ibDataSet15PLACA.AsString) = '' then
      Form7.ibDataSet15PLACA.AsString := Form7.ibDataSet18PLACA.AsString;
      //
    end else
    begin
      if SMALL_DBEdit41.CanFocus then SMALL_DBEdit41.SetFocus;
    end;
  end;
  //
  if SMALL_DBEdit41.Text = '' then Form7.ibDataSet18.Append;
  //
end;


procedure TForm12.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    if allTrim(form7.ibDataSet4DESCRICAO.AsString) <> '' then
    begin
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16DESCRICAO.AsString := form7.ibDataSet4DESCRICAO.AsString;
      dbGrid1.SetFocus;
    end;
  end;
end;

procedure TForm12.SMALL_DBEdit22Enter(Sender: TObject);
begin
  ListBox2.Visible := False;
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
end;

procedure TForm12.SMALL_DBEdit43Change(Sender: TObject);
begin
  if (Form12.Visible) and (Form7.ibDataSet9.Active) then
  begin
    dBGrid2.Visible    := True;

    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit43.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TForm12.SMALL_DBEdit43Enter(Sender: TObject);
begin
  Form7.ibDataSet15.Enablecontrols;
  if Form7.sModulo <> 'RETRIBUTA' then
    Form7.ibDataSet16.EnableControls;

  AtivaPesquisaVendedor;

  SMALL_DBEdit43.SelectAll;
end;

procedure TForm12.SMALL_DBEdit43Exit(Sender: TObject);
begin
  if SMALL_DBEdit43.Text <> '' then
  begin
    if Pos(
      AnsiUpperCase(SMALL_DBEdit43.Text),
      AnsiUpperCase(AllTrim(Form7.ibDataSet9NOME.AsString))) <> 0 then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15VENDEDOR.AsString := Form7.ibDataSet9NOME.AsString;
    end else
    begin
      if SMALL_DBEdit43.CanFocus then
        SMALL_DBEdit43.SetFocus;
    end;
  end;
end;

procedure TForm12.SMALL_DBEdit44Exit(Sender: TObject);
begin
  SMALL_DBEdit45.Setfocus;
end;

procedure TForm12.SMALL_DBEdit45Exit(Sender: TObject);
begin
  SMALL_DBEdit41.Setfocus;
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
end;

procedure TForm12.SMALL_DBEdit17Enter(Sender: TObject);
begin
  fVELHO := Form7.ibDataSet15MERCADORIA.AsFloat;
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
  Form7.sModulo := 'DESCONTO';
end;

procedure TForm12.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_TAB    then
    Key := VK_RETURN;
  if Key = VK_ESCAPE then
    Key := VK_RETURN;
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_venda.htm')));

  if DbGrid1.SelectedIndex = 0 then
  begin
    if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and
    (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
    begin
      if not dBGrid3.Visible then
        dBgrid3.Visible := True;

      Form1.bFlag := False;
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16.UpdateRecord;
      Form7.ibDataSet16.Edit;
      Form1.bFlag := True;
    end;
  end;

  if AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '' then
  begin
    if Form7.ibDataSet16CODIGO.AsString <> Form7.ibDataSet4CODIGO.AsString then
    begin
      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
    end;
  end;

  MostraFoto(True);
end;

procedure TForm12.SMALL_DBEdit48Enter(Sender: TObject);
begin
  ListBox2.Visible := False;
  DbGrid2.Visible := False;
  DbGrid3.Visible := False;
end;

procedure TForm12.DBGrid1ColEnter(Sender: TObject);
begin
  //Form7.ibDataSet16.EnableControls;
  //dbGrid1.Update;
  dBGrid3.Visible := False;
end;

procedure TForm12.SMALL_DBEdit17KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(
      handle,
      PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'),
      HH_Display_Topic, Longint(PChar('nf_venda.htm'))
    );

  if Form7.sModulo <> 'DESCONTO' then
  begin
    try
      if Key = VK_RETURN then
      begin
        if dBgrid4.CanFocus then
          dBgrid4.SetFocus
        else
          SMALL_DBEdit22.SetFocus;
      end;
      if Key = VK_DOWN then
      begin
        if dBgrid2.CanFocus then
          dBgrid2.SetFocus
        else
          SMALL_DBEdit22.SetFocus;
      end;
      if Key = VK_UP then
        DBGrid1.SetFocus;
    except
    end;
  end else
  begin
    Form7.sModulo := 'DESCONTO1';
  end;
end;

procedure TForm12.SMALL_DBEdit17Exit(Sender: TObject);
begin
  if (Form12.Edit2.Text <> '2-Complementar') then
  begin
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15MERCADORIA.AsFloat := fVELHO;

    Form7.sModulo := 'VENDA';
    Form7.ibDataSet16AfterPost(Form7.ibDataSet16);
  end;
end;

procedure TForm12.SMALL_DBEdit22Exit(Sender: TObject);
begin
  Form7.ibDataSet16AfterPost(Form7.ibDataSet16);
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
  //
  SMALL_DBEdit41.SetFocus;
end;

procedure TForm12.SMALL_DBEditBairroEnter(Sender: TObject);
begin
  dBGrid2.Visible    := False;
  dBGrid3.Visible    := False;
end;

procedure TForm12.SMALL_DBEdit52KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Button2.SetFocus;
  if Key = VK_TAB    then Button2.SetFocus;
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
end;

procedure TForm12.SMALL_DBEdit41KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN:
    begin
      if (dBgrid2.Visible) then
        dBgrid2.SetFocus
      else
        DBMemo1.SetFocus;
    end;
    VK_UP:
    begin
      if (dBgrid2.Visible) then
        dBgrid2.SetFocus
      else
        Perform(Wm_NextDlgCtl,1,0);
    end;
  end;
end;

procedure TForm12.DBGrid1Enter(Sender: TObject);
begin
  if Form7.sModulo <> 'RETRIBUTA' then
    Form7.ibDataSet16.EnableControls;

  dBGrid2.Visible    := False;
  dBGrid3.Visible    := False;

  try
    Form7.bChave := True;
    if (DbGrid1.SelectedIndex = 0) then
      if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '' then
        if AllTrim(Form7.ibDataSet16UNITARIO.AsString) <> '' then Form7.ibDataSet16.Delete;
    Form7.bChave := False;
  except
  end;
end;

procedure TForm12.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle,
       PChar(extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'),
       HH_Display_Topic,
       Longint(PChar('nf_venda.htm'))
    );

  if Form7.sModulo <> 'DESCONTO' then
  begin
    if Key = VK_RETURN then
      Perform(Wm_NextDlgCtl, 0, 0);

    if Key = VK_DOWN then
    begin
      if dBgrid2.Visible then
        dBgrid2.SetFocus
      else
        Perform(Wm_NextDlgCtl, 0, 0);
    end;

    if Key = VK_UP then
    begin
      if dBgrid2.Visible then
        dBgrid2.SetFocus
      else
        Perform(Wm_NextDlgCtl, 1, 0);
    end;

    Key := VK_SHIFT;
  end else
  begin
    Form7.sModulo := 'VENDA';
  end;
end;


procedure TForm12.DBGrid3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then
    Key := 0;
end;

procedure TForm12.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then
    Key := 0;
end;

procedure TForm12.DBGrid2Exit(Sender: TObject);
begin
  if (dbGrid2.Top = SMALL_DBEdit41.Top + SMALL_DBEdit41.Height) then
    SMALL_DBEdit41.SetFocus
  else if (dbGrid2.Top = SMALL_DBEdit39.Top + SMALL_DBEdit39.Height) then
      SMALL_DBEdit39.SetFocus;
end;

procedure TForm12.DBGrid3CellClick(Column: TColumn);
begin
  if allTrim(form7.ibDataSet4DESCRICAO.AsString) <> '' then
  begin
    try
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
      dbGrid1.SetFocus;
    except
    end;
  end;
end;

procedure TForm12.DBGrid1ColExit(Sender: TObject);
//var
//  Sreg1: String;
begin
  Form7.ibDataSet15TOTAL.OnChange := nil;
  try
    if UpperCase(Form1.ConfDuplo) <> 'SIM' then
    begin
      Jatem(Form7.ibDataSet16,Form7.ibDataSet16DESCRICAO,True);
    end  else
    begin
      {Form7.ibDataSet16.DisableControls;
      sReg1 := Form7.ibDataSet16.FieldByname('REGISTRO').AsString;
      Form7.ibDataSet16.First;
      Form7.ibDataSet16.Locate('REGISTRO',sREg1,[]);
      if Form7.sModulo <> 'RETRIBUTA' then
        Form7.ibDataSet16.EnableControls; Mauricio Parizotto 2023-04-26 sem uso aparente}
    end;
  finally
    Form7.ibDataSet15TOTAL.OnChange := Form7.ibDataSet15TOTALChange;
  end;
end;

procedure TForm12.SMALL_DBEdit4Exit(Sender: TObject);
begin
  Retributa(True);
  dbGrid1.SetFocus;
end;

procedure TForm12.SMALL_DBEditIEExit(Sender: TObject);
begin
  Retributa(True);
  if form7.ibDataSet16.Modified then Form7.ibDataSet16.Post;
  dbGrid1.SetFocus;
end;

procedure TForm12.SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_venda.htm')));

  if Key = VK_INSERT then
    ShowPopupMenuInsert();
end;

procedure TForm12.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
  if Field.Name = 'ibDataSet16DESCRICAO' then
  begin
    //if Form7.ibDataSet16QUANTIDADE.AsFloat = 0 then Mauricio Parizotto 2023-06-05
    if (Form7.ibDataSet16QUANTIDADE.AsFloat = 0) and not (NFeFinalidadeComplemento(Form7.ibDataSet15FINNFE.AsString)) then
      DBGrid1.Canvas.Font.Color := clSilver
    else
      DBGrid1.Canvas.Font.Color := clBlack;
    dbGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Field.AsString);
  end;
end;

procedure TForm12.Label64Click(Sender: TObject);
begin
  Form7.ibDataSet15.Edit;
  Form7.ibDataSet15MODELO.AsString := LimpaNumero(Form1.Small_InputForm('Modelo da Nota Fiscal','',Form7.ibDataSet15MODELO.AsString));
  Label64.Caption := 'Mod: '+StrZero(StrToInt('0'+Form7.ibDataSet15MODELO.AsString),2,0);
end;

procedure TForm12.SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then
    ShowPopupMenuInsert();

  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_venda.htm')));
end;

procedure TForm12.SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then
    ShowPopupMenuInsert();

  if Key = VK_F1     then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_venda.htm')));
end;

procedure TForm12.SMALL_DBEdit9Exit(Sender: TObject);
begin
  dBGrid1.SetFocus;
end;

procedure TForm12.Button1Enter(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 200;
end;

procedure TForm12.BitBtnAtorInteressadoClick(Sender: TObject);
begin
  var IdentificationsNotAllowed := TList<TIdentification>.Create;

  IdentificationsNotAllowed.AddRange([
    TIdentification.Create(
      Form7.ibDataSet13.FieldByname('CGC').AsString, 'Emitente'),
    TIdentification.Create(
      Form7.ibDAtaset2.FieldByname('CGC').AsString, 'Cliente'),
    TIdentification.Create(
      Form7.ibDAtaset18.FieldByname('CGC').AsString, 'Transportadora')
  ]);

  var CNPJContabilidade := form7.sCNPJContabilidade;
  if (Form7.ibDataSet13ESTADO.AsString = 'BA') and
    (Trim(LimpaNumero(Form7.sCNPJContabilidade)) = '') then
    CNPJContabilidade := CNPJ_SEFAZ_BAHIA;

  TfmAtorInteressado.Execute(
    Form7.IBDatabase1,
    Form7.IBTransaction1,
    Form7.ibDataSet15NUMERONF.AsString,
    Form7.ibDataSet15MODELO.AsString,
    form7.sCNPJContabilidade,
    IdentificationsNotAllowed
  );
end;

procedure TForm12.Button1Click(Sender: TObject);
begin
  bOk := True;
  Form12.Close;
end;

procedure TForm12.ImportarOS2Click(Sender: TObject);
var
  NumeroOS : string;
  Origem : TOrigemImpOS;
begin
  if Form7.sRPS = 'N' then
    Origem := orNFE
  else
    Origem := orNFSE;

  NumeroOS := PesquisaNumeroOrdemServico('Importar Ordem de Serviço',Origem);
  if NumeroOS <> '' then
  begin
    Form7.sModulo := 'OS';
    ImportaOS(NumeroOS);
    Form7.sModulo := 'VENDA';

    Form7.ibDataSet16.First;
    Form7.ibDataSet16.Edit;
    Form7.ibDataSet16.Post;
    Retributa(True);
  end;
end;

procedure TForm12.DefineVisibleHomologacao;
begin
  lblHomologacao.Visible := Form7.TestarNFeHomologacao;
end;

procedure TForm12.FormShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Form12.Tag := 1;
  DBGridRecebedor.Visible := False;
  PageControlAddressMktp.ActivePage := TabSheetEnderecoCliente;
  Application.OnMessage := AppMessage;

  Form12.ActiveControl := Nil;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  DefineVisibleHomologacao;
  if not Form7.ibDAtaSet18.Active then
    Form7.ibDAtaSet18.Active := True;

  Form7.ibDataSet16.DisableControls;
  Form7.ibDataSet14.DisableControls;
  Form7.ibDataSet15.DisableControls;
  Form7.ibDataSet35.DisableControls;
  Form7.ibDataSet2.DisableControls;

  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
  Form7.ibDataSet2.Open;

  Form7.ibDataSet2.EnableControls;

  bOk := False;

  if not FileExists(Form1.sAtual+'\LOGONFE.BMP') then
  begin
    Form24.ImageFixa.Picture.SaveToFile(Form1.sAtual+'\LOGONFE.BMP');
  end;

  if FileExists(Form1.sAtual+'\LOGONFE.BMP') then
    imgLogoNFe.Picture.LoadFromFile(Form1.sAtual+'\LOGONFE.BMP')
  else
    imgLogoNFe.Picture := Form24.ImageFixa.Picture;

  ResizeLogoDanfe(True);

  // Logotipo

  {$IFDEF VER150}
  ShortDateFormat := 'dd/mm/yyyy';
  {$ELSE}
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  {$ENDIF}

  Label71.Caption := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3);

  Panel1.Left     := 10; // (ScrollBox1.Width - Panel1.Width) div 2;
  Panel6.Left     := 5;
  Panel6.Top      := Panel1.Top + Panel1.Height + 5;
  try
    try
      // Libera ou não Clientes e Estoque //
      Mais1Ini   := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
      if AllTrim(Mais1Ini.ReadString(Usuario,'B3','0')) <> '1' then
      begin
        SMALL_DBEdit4.Enabled := False;
        SMALL_DBEditRua.Enabled := False;
        SMALL_DBEditBairro.Enabled := False;
        SMALL_DBEditCEP.Enabled := False;
        SMALL_DBEditMunicipio.Enabled := False;
        SMALL_DBEditUF.Enabled := False;
        SMALL_DBEditTelefone.Enabled := False;
        SMALL_DBEditIE.Enabled := False;
      end else
      begin
        SMALL_DBEdit4.Enabled := True;
        SMALL_DBEditRua.Enabled := True;
        SMALL_DBEditBairro.Enabled := True;
        SMALL_DBEditCEP.Enabled := True;
        SMALL_DBEditMunicipio.Enabled := True;
        SMALL_DBEditUF.Enabled := True;
        SMALL_DBEditTelefone.Enabled := True;
        SMALL_DBEditIE.Enabled := True;
      end;
    except
      //ShowMessage('Erro 1947') Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 1947',msgErro);
    end;
    
    // se n tem vendedores cadastrados se não tiver n pede
    Form7.ibDataSet9.DisableControls;
    Form7.ibDataSet9.First;
    while not Form7.ibDataSet9.EOF do
    begin
      if AllTrim(form7.ibDataSet9NOME.AsString) <> '' then
      begin
        SMALL_DBEdit43.Visible := True;
        Label9.Visible     := True;
      end;
      Form7.ibDataSet9.Next;
    end;
    Form7.ibDataSet9.EnableControls;
    
    dBGrid3.Visible := False;
    dBGrid2.Visible := False;
  except
    {
    Application.MessageBox('O módulo de emissão de Nota Fiscal está sendo' + Chr(10) +
              'utilizado por outro usuário neste momento.'    + chr(10) +
              Chr(10) +
              'Aguarde a liberação do próximo número da Nota Fiscal. Erro 2120'
              ,'Atenção',mb_IconError+mb_Ok);
    Mauricio Parizotto 2023-10-24}

    MensagemSistema('O módulo de emissão de Nota Fiscal está sendo' + Chr(10) +
                    'utilizado por outro usuário neste momento.'    + chr(10) +
                    Chr(10) +
                    'Aguarde a liberação do próximo número da Nota Fiscal. Erro 2120'
                    ,msgErro);

    Form12.Close;
  end;

  Form7.sModulo := 'VENDA';

  // Relaciona a natureza da operação com o arquivo de vendas
  if AllTrim(Form7.ibDataSet15OPERACAO.AsString) = ''
    then Form7.ibDataSet14.Append
       else Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

  // Relaciona os clientes com o arquivo de vendas
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');
  Form7.ibDataSet2.Open;

  Form7.ibDataSet9.Locate('NOME',Form7.ibDataSet15VENDEDOR.AsString,[]);       
  Form7.ibDataSet18.Locate('NOME',Form7.ibDataSet15TRANSPORTA.AsString,[]);

  // Abre o arquivo de clientes para edição
  try Form7.ibDataSet2.Edit except end;
  //
  try
    if not (AllTrim(Form7.ibDataSet15TRANSPORTA.AsString) = AllTrim(Form7.ibDataSet18NOME.AsString)) then
    begin
      if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then Form7.ibDataset15.Edit;
      Form7.ibDataSet15TRANSPORTA.AsString := '';
      Form7.ibDataSet18.Append;
    end;
  except end;
  //
  try
    if AllTrim(Form7.ibDataSet15MODELO.AsString) = '' then
    begin
      if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then Form7.ibDataset15.Edit;
      Form7.ibDataSet15MODELO.AsString := Right(Label64.Caption,2);
    end;
    //
    Label64.Caption := 'Mod: '+StrZero(StrToInt(Form7.ibDataSet15MODELO.AsString),2,0);
  except end;
  //
  {Dailon Parisotto (f-18201) 2024-05-08 Inicio

  if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) or (Form1.iReduzida = 2)  then

  }
  if (TestarUFMovimentaEstoqueFinanceiroSemFaturar(Form7.ibDataSet13ESTADO.AsString)) or (Form1.iReduzida = 2)  then
  {Dailon Parisotto (f-18201) 2024-05-08 Fim}
  begin
    // Atenção a rotina abaixo altera a quantidade no estoque
    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.Eof do // disable
    begin
      // Procura o produto no estoque
      Screen.Cursor := crHourGlass; // Cursor de Aguardo
      //
      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
      //
      if (Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet16CODIGO.AsString)<>'') then
      begin
        if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then    // Resolvi este problema as 4 da madrugada no NoteBook em casa
        begin
          try
            if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
            begin
              if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
              begin
                Screen.Cursor := crHourGlass; // Cursor de Aguardo
                Form7.ibDataSet4.Edit;
                Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet16QUANTIDADE.AsFloat; // Retorna a quantidade ao estoque quando entra na NF
                Form7.ibDataSet4.Edit;
                Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                Form7.ibDataSet4.Post;
                Screen.Cursor := crHourGlass; // Cursor de Aguardo
              end;
            end;
            //
            Form7.sModulo := 'NAO';
            Form7.ibDataSet16.Edit;                                                     //
            Form7.ibDataSet16SINCRONIA.AsFloat := 0;                                    // Resolvi este problema as 4 da madrugada no NoteBook em casa
          except end;
        end;
      end;
      Form7.ibDataSet16.Next;
    end;
    //
    Form7.sModulo := 'VENDA';
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
    Form7.ibDataSet4.Open;

    if Form7.sModulo <> 'RETRIBUTA' then Form7.ibDataSet16.EnableControls;

    // Atenção a rotina acima altera a quantidade no estoque
  end;

  Form7.sModulo := 'VENDA';

  Form7.ibDataSet14.EnableControls;
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet35.EnableControls;
  Form7.ibDataSet2.EnableControls;

  // Foco no vendedor ou no cliente
  if Form12.SMALL_DBEdit40.CanFocus then Form12.SMALL_DBEdit40.SetFocus;
  ScrollBox1.VertScrollBar.Position := 1;

  // Altera o Grid de mercadorias para mostrar na NF
  Form7.ibDataSet16UNITARIO.Visible       := True;
  Form7.ibDataSet16CFOP.Visible           := True;
  Form7.ibDataSet16XPED.Visible           := True;
  Form7.ibDataSet16NITEMPED.Visible       := True;
  Form7.ibDataSet16DESCRICAO.DisplayWidth := 45;
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 33;
  Form7.ibDataSet35TECNICO.Visible        := False;

  if Form7.ibDataSet15FRETE12.AsString = '0' then Edit1.Text := '0-Emitente' else
    if Form7.ibDataSet15FRETE12.AsString = '1' then Edit1.Text := '1-Destinatário' else
      if Form7.ibDataSet15FRETE12.AsString = '2' then Edit1.Text := '2-Terceiros' else
        if Form7.ibDataSet15FRETE12.AsString = '9' then Edit1.Text := '9-Sem frete' else Edit1.Text := '';

  Form12.Edit1.Visible := True;

  AdjustLayout();

  Form7.AtualizarListaItensAuxiliar;
  
  Screen.Cursor := crDefault; // Cursor de Aguardo

  vNotaFiscal := TNotaFiscalEletronicaCalc.create;

  PanelAtencao.Top := Panel1.Top + PanelProdutos.Top + 100;
  PanelAtencao.Left := Panel1.Left + dbGrid1.Left + dbGrid1.Width + 20;

  Form7.SetFilterOcultaUsoConsumoVenda();

  if Boolean(Form7.ibDataSet15LOCALENTREGA_END_PRINCIPAL.AsInteger) then
  begin
    Form7.ibDataSet15IDLOCALENTREGA.AsInteger := ENDERECO_PRINCIPAL_ENTREGA;
    Form7.ibDataSet15LOCALENTREGA_END_PRINCIPAL.AsInteger := Integer(False);
  end;

  dBGrid3.Top := PanelProdutos.Top
    + PanelProdutos.Height
    - PanelProdutos.Padding.Top
    - PanelProdutos.Padding.Bottom;
  dBGrid3.Height := Panel6.Top - PanelICMS.Top;
  dBGrid3.Left := Panel1.Left + DBGrid1.Left;
  dBGrid3.Width := DBGrid1.Width;

end;

procedure TForm12.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
  ConsultaImprimeDanfe : Boolean;
begin
  Application.OnMessage := nil;

  {Dailon Parisotto (f-21050) 2024-09-26 Inicio}
  if (not bOk) and (Button1.Enabled) then
    Button1.SetFocus;
  {Dailon Parisotto (f-21050) 2024-09-26 Fim}

   // Apaga ítens em branco
  try
    Form7.IBQuery99.Close;
    Form7.IBQuery99.SQL.Clear;
    Form7.IBQuery99.SQL.Add('delete from ITENS001 where Coalesce(DESCRICAO,'''')='+QuotedStr('')+'');
    Form7.IBQuery99.Open;
  except
  end;

  //Confere valores preenchidos
  try
    Form7.ibDataSet15.Edit;
    
    if Form7.ibDataSet15FINNFE.AsString   <> LimpaNumero(Edit2.Text) then
      Form7.ibDataSet15FINNFE.AsString   := LimpaNumero(Edit2.Text);

    if Form7.ibDataSet15INDFINAL.AsString <> LimpaNumero(Edit3.Text) then
      Form7.ibDataSet15INDFINAL.AsString := LimpaNumero(Edit3.Text);

    if Form7.ibDataSet15INDPRES.AsString  <> LimpaNumero(Edit6.Text) then
      Form7.ibDataSet15INDPRES.AsString  := LimpaNumero(Edit6.Text);
  except
    on E: Exception do
    begin
      //ShowMessage('Erro ao gravar NF-e: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro ao gravar NF-e: '+chr(10)+E.Message,msgErro);
    end;
  end;

  //Roda cálculo Final
  try
    Form7.ibDataSet15.Edit;

    // LogRetaguarda('TForm12.FormClose('); // Sandro Silva 2023-05-08

    Form7.ibDataSet15TOTAL.OnChange := nil;

    if vNotaFiscal = nil then
    begin
      vNotaFiscal := TNotaFiscalEletronicaCalc.Create;
      vNotaFiscal.Calculando := False;
    end;

    try
      //vNotaFiscal.CalculaValores(Form7.ibDataSet15,Form7.ibDataSet16); Mauricio Parizotto 2023-06-26
      vNotaFiscal.CalculaValores(Form7.ibDataSet15,Form7.ibDataSet16, False);

      if not TestarLimiteDisponivel then
      begin
        Action := caNone;
        Exit;
      end;
    finally
      Form7.ibDataSet15TOTAL.OnChange := Form7.ibDataSet15TOTALChange;
      if  Action <> caNone then
        FreeAndNil(vNotaFiscal);
    end;
  except
  end;


  //Retributa
  try
    Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
    //
    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet4.DisableControls;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet15.DisableControls;
    Form12.Hide;

    Form7.sModulo := 'RETRIBUTA';
    
    if Form7.ibDataSet15.Modified then
      Form7.ibDataSet15.Post;

    if (AllTrim(Form7.ibDataSet15CLIENTE.AsString)) <> '' then
    begin
      {Dailon Parisotto (f-18201) 2024-05-08 Inicio

      if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) or (Form1.iReduzida = 2)  then

      }
      if (TestarUFMovimentaEstoqueFinanceiroSemFaturar(Form7.ibDataSet13ESTADO.AsString)) or (Form1.iReduzida = 2)  then
      {Dailon Parisotto (f-18201) 2024-05-08 Fim}
      begin
        // Atenção a rotina abaixo altera a quantidade no estoque
        Form7.ibDataSet16.DisableControls;
        Form7.ibDataSet16.First;
        while not Form7.ibDataSet16.Eof do // disable
        begin
          // Procura o produto no estoque
          try
            Form7.ibDataSet4.Close;                                                
            Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
            Form7.ibDataSet4.Open;

            if Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            begin
              if Form7.ibDataSet16SINCRONIA.AsFloat <> Form7.ibDataSet16QUANTIDADE.AsFloat then
              begin
                if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
                begin
                  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
                  begin

                    {Sandro Silva 2023-11-07 inicio}
                    try
                      Form7.bFabrica := True;
                      if (Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet16QUANTIDADE.AsFloat) < 0 then // Sandro Silva 2023-12-08
                        FabricaComposto(Form7.ibDataSet4CODIGO.AsString, Form7.ibDataSet4, Abs(Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet16QUANTIDADE.AsFloat), Form7.bFabrica, 1, Form7.sModulo); // Sandro Silva 2023-12-08 FabricaComposto(Form7.ibDataSet4CODIGO.AsString, Form7.ibDataSet4, Form7.ibDataSet16QUANTIDADE.AsFloat, Form7.bFabrica, 1, Form7.sModulo);
                    finally
                      Form7.bFabrica := False;
                    end;
                    {Sandro Silva 2023-11-07 fim}

                    Form7.ibDataSet4.Edit;
                    Form7.ibDataSet4QTD_ATUAL.AsFloat    := Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet16QUANTIDADE.AsFloat; // Baixa a quantidade no estoque quando fecha a NF
                    Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                    Form7.ibDataSet4.Post;
                  end;
                end;

                Form7.sModulo := 'FECHAVENDA';
                Form7.ibDataSet16.Edit;
                Form7.ibDataSet16SINCRONIA.AsFloat := Form7.ibDataSet16QUANTIDADE.AsFloat; // Resolvi este problema as 4 da madrugada no NoteBook em casa
                Form7.ibDataSet16.Post;
              end;
            end;
          except end;

          Form7.sModulo := 'VENDA';
          Form7.ibDataSet16.Next;
        end;
        // Atenção a rotina acima altera a quantidade no estoque
      end;

      // Desdobramento das duplicatas
      Form7.sModulo := 'VENDA';
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

      ApagaIntegracaoComOCaixa(True); // Apaga no caixa os registros relativos a nota em questão

      if (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString),1,7) = 'RECEBER') and (Form7.ibDataSet15TOTAL.AsFloat > 0) then
      begin
        //Form18.ShowModal; Mauricio Parizotto 2024-01-24
        try
          FrmParcelas := TFrmParcelas.Create(Self);
          FrmParcelas.ShowModal;
        finally
          FreeAndNil(FrmParcelas);
        end;
      end else
      begin
        ApagaAsDuplicatasAnteriores(True);
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 0;
        Form7.ibDataSet15.Post;

        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
          ConsultaImprimeDanfe := True
        else
          ConsultaImprimeDanfe := False;
        Mais1Ini.Free;

        if ConsultaImprimeDanfe then
        begin
          Form7.bProximas := True;
          Form7.N6EnviarNFeConsultareImprimirDANFE1Click(Sender);
          Form7.bProximas := False;
        end;
      end;
    end else
    begin
      // Se o cliente estiver em branco apaga
      Form7.ibDataSet15.Delete;
    end;
  except end;

  // Lay-Out no form7
  Form7.ibDataSet16UNITARIO.Visible       := False;
  Form7.ibDataSet16CFOP.Visible           := False;
  Form7.ibDataSet16XPED.Visible           := False;
  Form7.ibDataSet16NITEMPED.Visible       := False;
  Form7.ibDataSet16DESCRICAO.DisplayWidth := 41;
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 29;
  Form7.ibDataSet35TECNICO.Visible        := True;
  //    Form7.ibDataSet35UNITARIO.Visible       := False;

  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
  Form7.ibDataSet4.Open;

  Form7.sModulo := 'VENDA';

  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet4.EnableControls;
  Form7.ibDataSet14.EnableControls;
  Form7.ibDataSet15.EnableControls;

  BaixaEstoqueDaNFeAutorizada('');

  Form7.Close;
  Form7.Show;

  // Para atender o PAF
  if ParamCount > 0 then
  begin
    if AllTrim(Copy(UpperCase(ParamStr(1)),1,3)) = 'URB' then
    begin
//      Form1.Close;
    end;
  end;

  Form1.ConfEspecie := Form7.ibDataSet15ESPECIE.AsString;
  Form1.ConfMarca   := Form7.ibDataSet15MARCA.AsString;

  //Mauricio Parizotto 2023-07-26  Tem que ter duas vezes para funcionar (motivo desconhecido...)
  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet16.EnableControls;
end;


procedure TForm12.FormCreate(Sender: TObject);
begin
  var ListOfPanels := TList<TPanel>.Create;
  ListOfPanels.AddRange(
    [PanelRecebedor, PanelMtplace, PanelEnderecoCliente, PanelTop, PanelICMS,
     PanelIdentificadorTransp, PanelEnderecoTransp, PanelObs, PanelServico,
     PanelProdutos]
  );

  for var Panel in ListOfPanels do
  begin
    Panel.Caption := '';
    Panel.BorderStyle := bsNone;
    Panel.Color := Form12.Color;
    Panel.BevelOuter := bvNone;
  end;
end;

procedure TForm12.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
  bUsouDownUp: Boolean;
begin
  bUsouDownUp := (Key = VK_DOWN) or (Key = VK_UP);
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26

  Form7.ibDataSet16.EnableControls;

  if Key = VK_INSERT then
  begin
    ShowPopupMenuInsert();
    Key := VK_SHIFT;
    dbGrid1.SetFocus;
    Abort;
  end;

  if ((Key = VK_DOWN) or (Key = VK_UP)) and (dBgrid3.CanFocus) then
  begin
    Key := VK_SHIFT;
    dBgrid3.SetFocus;
  end;
  
  if Key = VK_TAB    then
    Key := VK_RETURN;
  if Key = VK_ESCAPE then
    Key := VK_RETURN;
  try
    begin
      if Key = VK_RETURN then
      begin
        Form1.bFlag := True;

        if not (Form7.ibDataSet16.State in ([dsEdit, dsInsert])) then
          Form7.ibDataSet16.Edit;

        if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
        begin
          if DbGrid1.SelectedIndex = 0 then
          begin
            Form1.bFlag := True;

            if Alltrim(Form7.ibDataSet16DESCRICAO.AsString) = AllTrim(Form7.ibDataSet4DESCRICAO.AsString) then
            begin
              Form7.ibDataSet16DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
            end else
            begin
              Form7.ibDataSet16DESCRICAO.AsString := AllTrim(Form7.ibDataSet16DESCRICAO.AsString);
            end;

          end;

          I := DbGrid1.SelectedIndex;
          DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
          if I = DbGrid1.SelectedIndex  then
          begin
            DbGrid1.SelectedIndex := 0;
            Form7.ibDataSet16.Next;
            if Form7.ibDataSet16.EOF then Form7.ibDataSet16.Append;
          end;

        end else
        begin
          //Sai do Grid
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16.Post;
          SMALL_DBEdit17.SetFocus;
          SMALL_DBEdit17.SelectAll;
        end;
      end else
      begin
        if (Key = VK_DELETE) or (bUsouDownUp) then
          Form1.bFlag := True
        else
          Form1.bFlag := False;
      end;
    end;
  except
  end;
  
  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '') then
    DbGrid1.SelectedIndex := 0;
end;

procedure TForm12.DBGrid4KeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if DbGrid4.SelectedIndex = 0 then
  begin
    if not ListBox2.Visible then
    begin
      ListBox2.Left := PanelServico.Left + DBGrid4.Left;
      ListBox2.Top := PanelServico.Top + PanelServico.Height - 4;
      ListBox2.Height := 200;
      ListBox2.Width := dbGrid4.Width + 2;

      ListBox2.Visible := True;
    end;

    Form7.ibDataSet35.Edit;
    Form7.ibDataSet35.UpdateRecord;

    for I := 0 to ListBox2.Items.Count -1 do
    begin
      if AnsiUpperCase(AllTrim(Form7.ibDataSet35DESCRICAO.AsString)+Key) = AnSiUpperCase(Copy(ListBox2.Items[i],1,LenGth( AllTrim(Form7.ibDataSet35DESCRICAO.AsString)+Key ))) then ListBox2.ItemIndex := I;
    end;

    ListBox2.Update;
  end else
    ListBox2.Visible  := False;

  if TipoCampoFloat(dbGrid1.SelectedField) then // Sandro Silva 2024-04-29 if dbGrid1.SelectedField.DataType = ftFloat then
    if Key = chr(46) then key := chr(44);
end;

procedure TForm12.DBGrid4KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  try
    begin
      if Key = VK_RETURN then
      begin
        Form7.ibDataSet35.Edit;
        Form7.ibDataSet35.UpdateRecord;
        
        if AllTrim(Form7.ibDataSet35DESCRICAO.AsString) <> '' then
        begin
          I := DbGrid4.SelectedIndex;
          DbGrid4.SelectedIndex := DbGrid4.SelectedIndex  + 1;
          if I = DbGrid4.SelectedIndex  then
          begin
            DbGrid4.SelectedIndex := 0;
            Form7.ibDataSet35.Next;
            if Form7.ibDataSet35.EOF then Form7.ibDataSet35.Append;
          end;
        end else
        begin
          Form7.ibDataSet35.Edit;
          Form7.ibDataSet35.Post;
          SMALL_DBEdit22.SetFocus;
        end;
      end;
    end;
  except
  end;

  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '') then
    DbGrid4.SelectedIndex := 0;
end;

procedure TForm12.DBGridRecebedorCellClick(Column: TColumn);
begin
  SetRecebedor();
end;

procedure TForm12.DBGridRecebedorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SetRecebedor();
end;

procedure TForm12.SMALL_DBEdit38Exit(Sender: TObject);
begin
  if Form1.sVersaoLayout = '4.00' then
  begin
    if (Form7.ibDataSet15FRETE12.AsString <> '0')
    and (Form7.ibDataSet15FRETE12.AsString <> '1')
    and (Form7.ibDataSet15FRETE12.AsString <> '2')
    and (Form7.ibDataSet15FRETE12.AsString <> '3')
    and (Form7.ibDataSet15FRETE12.AsString <> '4')
    and (Form7.ibDataSet15FRETE12.AsString <> '9') then
    begin
      {
      Application.MessageBox('Valores válidos:' + Chr(10) +
                            Chr(10) +
                            '0 - Contratação do Frete por conta do Remetente (CIF);' + Chr(10) +
                            '1 - Contratação do Frete por conta do destinatário/remetente (FOB);' + Chr(10) +
                            '2 - Contratação do Frete por conta de terceiros;' + Chr(10) +
                            '3 - Transporte próprio por conta do remetente;' + Chr(10) +
                            '4 - Transporte próprio por conta do destinatário;' + Chr(10) +
                            '9 - Sem Ocorrência de transporte.'
                ,'Valor inválido',mb_IconError+mb_Ok);
      Mauricio Parizotto 2023-10-24}

      MensagemSistema('Valores válidos:' + Chr(10) +
                      Chr(10) +
                      '0 - Contratação do Frete por conta do Remetente (CIF);' + Chr(10) +
                      '1 - Contratação do Frete por conta do destinatário/remetente (FOB);' + Chr(10) +
                      '2 - Contratação do Frete por conta de terceiros;' + Chr(10) +
                      '3 - Transporte próprio por conta do remetente;' + Chr(10) +
                      '4 - Transporte próprio por conta do destinatário;' + Chr(10) +
                      '9 - Sem Ocorrência de transporte.'
                      ,msgErro);

      Form7.ibDataSet15FRETE12.AsString := '0';
    end;

    if Form7.ibDataSet15FRETE12.AsString = '0' then Edit1.Text := '0-Remetente' else
      if Form7.ibDataSet15FRETE12.AsString = '1' then Edit1.Text := '1-Destinatário' else
        if Form7.ibDataSet15FRETE12.AsString = '2' then Edit1.Text := '2-Terceiros' else
          if Form7.ibDataSet15FRETE12.AsString = '3' then Edit1.Text := '3-Próprio remetente' else
            if Form7.ibDataSet15FRETE12.AsString = '4' then Edit1.Text := '4-Próprio destinatário' else
             if Form7.ibDataSet15FRETE12.AsString = '9' then Edit1.Text := '9-Sem frete' else Edit1.Text := '';
  end else
  begin
    if (Form7.ibDataSet15FRETE12.AsString <> '0')
    and (Form7.ibDataSet15FRETE12.AsString <> '1')
    and (Form7.ibDataSet15FRETE12.AsString <> '2')
    and (Form7.ibDataSet15FRETE12.AsString <> '9') then
    begin
      {
      Application.MessageBox('Valores válidos:' + Chr(10) +
                Chr(10) +
                '0 - Por conta do emitente'+ Chr(10) +
                '1 - Por conta do destinatário/remetente'+ Chr(10) +
                '2 - Por conta de terceiros'+ Chr(10) +
                '9 - Sem frete'
                ,'Valor inválido',mb_IconError+mb_Ok);
      Mauricio Parizotto 2023-10-24}

      MensagemSistema('Valores válidos:' + Chr(10) +
                      Chr(10) +
                      '0 - Por conta do emitente'+ Chr(10) +
                      '1 - Por conta do destinatário/remetente'+ Chr(10) +
                      '2 - Por conta de terceiros'+ Chr(10) +
                      '9 - Sem frete'
                      ,msgErro);

      Form7.ibDataSet15FRETE12.AsString := '0';
    end;

    if Form7.ibDataSet15FRETE12.AsString = '0' then Edit1.Text := '0-Emitente' else
      if Form7.ibDataSet15FRETE12.AsString = '1' then Edit1.Text := '1-Destinatário' else
        if Form7.ibDataSet15FRETE12.AsString = '2' then Edit1.Text := '2-Terceiros' else
          if Form7.ibDataSet15FRETE12.AsString = '9' then Edit1.Text := '9-Sem frete' else Edit1.Text := '';
  end;

  Form12.Edit1.Visible := True;
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);

  if not DBMemo1.Focused then
  begin
    dbGrid1.SetFocus;
    DBMemo1.SetFocus;
  end;
end;

procedure TForm12.Emitirnotafiscaldevendasnobalco1Click(Sender: TObject);
begin
  // Atualiza as ECF's que estão em uso
  {Mauricio Parizotto 2023-07-19 Inicio
  Form7.ibDataSet14.DisableControls;
  Form7.ibDataSet14.Close;
  Form7.ibDataSet14.SelectSQL.Clear;
  Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or SubString(CFOP from 1 for 1) = ''7'' order by upper(NOME)');
  Form7.ibDataSet14.Open;
  Form7.ibDataSet14.EnableControls;

  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
    Form7.ibDataSet14.Locate('CFOP','5929',[]);
  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
    Form7.ibDataSet14.Locate('CFOP','6929',[]);

  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
  begin
    Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;

    Form7.sModulo := 'BALCAO';
    Form41.ShowModal;
    Form7.sModulo := 'VENDA';

    Form7.ibDataSet16.First;

    if form7.ibDataSet16.Modified then
      Form7.ibDataSet16.Post;
    Retributa(True);
  end else
  begin
    ShowMEssage('A importação do Cupom Fiscal só poderá ser concluída com o CFOP 5929 ou 6929');
  end;

  Com importação do gerencial, essa validação vai ficar em outro local }

  //Mauricio Parizotto 2023-07-26
  Form7.ibDataSet16.EnableControls;

  Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;

  Form7.sModulo := 'BALCAO';
  Form41.ShowModal;
  Form7.sModulo := 'VENDA';

  Form7.ibDataSet16.First;

  if form7.ibDataSet16.Modified then
    Form7.ibDataSet16.Post
  else
    Form7.ibDataSet16AfterPost(Form7.ibDataSet16);

  Form7.bPesqProdNFPorConsulta := True;
  try
    Retributa(True);
  finally
    Form7.bPesqProdNFPorConsulta := False;
  end;

  {Mauricio Parizotto 2023-07-19 Fim}

  //Mauricio Parizotto 2023-07-26
  Form7.ibDataSet16.EnableControls;
end;

procedure TForm12.Importaroramentos1Click(Sender: TObject);
var
  NumeroOrcamento : String;
begin
  (*
  Form7.sModulo := 'ORCAMENTO';
  Form41.ShowModal;
  Form7.sModulo := 'VENDA';

  Form7.ibDataSet16.First;
  {Sandro Silva 2023-08-17 inicio
  Form7.ibDataSet16.Edit;
  Form7.ibDataSet16.Post;
  }
  Retributa(True);
  Mauricio Parizotto 2023-10-16*)

  NumeroOrcamento := PesquisaNumeroOrcamento('Importar Orçamento');
  if NumeroOrcamento <> '' then
  begin
    Form7.sModulo := 'ORCAMENTO';
    ImportaOrcamento(NumeroOrcamento,Form7.sModulo);
    Form7.sModulo := 'VENDA';
  end;
end;

procedure TForm12.Label28Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  with Sender as TLabel do
  begin
    sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),'','');
    if AllTrim(sNome) <> '' then Caption := sNome else sNome := Caption;
    Repaint;

    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString('VENDAS',NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TForm12.Label28MouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Font.Style := [];
    Font.Color := clSilver;
    Repaint;
  end;
end;

procedure TForm12.Label28MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as TLabel do
  begin
    Font.Style := [fsBold,fsUnderline];
    Font.Color := clBlue;
    Repaint;
  end;
end;

procedure TForm12.FormActivate(Sender: TObject);
begin
  // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria);
  Form1.bFlag  := True;

  ConfiguraNFE;

  if Form12.Tag = 1 then
  begin
    form12.Tag := 0;

    try
      ExibeColunasFCP(False);
      ExibeColunasFCPST(False);
      ExibeColunaCSOSN(False); // Sandro Silva 2023-05-24
      ExibeColunaCSTICMS(Form7.ibDataSet15FINNFE.AsString, Form7.ibDataSet13CRT.AsString); //Form12.ExibeColunaCSTICMS(False); // Sandro Silva 2023-05-24

      if Form7.ibDataSet15FINNFE.AsString = '1' then
      begin
        Edit2.Text := '1-Normal';
      end else
      begin
        if Form7.ibDataSet15FINNFE.AsString = '2' then
        begin
          Edit2.Text := '2-Complementar';
          Form12.edtTotalNota.ReadOnly := False;
        end else
        begin
          if Form7.ibDataSet15FINNFE.AsString = '3' then
          begin
            Edit2.Text := '3-de Ajuste';
          end else
          begin
            if Form7.ibDataSet15FINNFE.AsString = '4' then // Devolucao Devolução
            begin
              Edit2.Text := '4-Devolução de mercadoria';
              ExibeColunasFCPST(True);
              //if Form7.ibDataSet13CRT.AsString = '1' then // Mauricio Parizotto 2024-08-07
              if (Form7.ibDataSet13CRT.AsString = '1')
                or (Form7.ibDataSet13CRT.AsString = '4') then
              begin
                ExibeColunaCSOSN(True); // Sandro Silva 2023-05-24
                ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString); //ExibeColunaCSTICMS(False); // Sandro Silva 2023-05-24
              end;
            end else
            begin
              Edit2.Text := '1-Normal';
            end;
          end;
        end;
      end;
    except end;

    // Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final
    try
      if Form7.ibDataSet15INDFINAL.AsString = '1' then
      begin
        Edit3.Text := '1-Consumidor Final';

        if (Form7.ibDataSet13ESTADO.AsString <> Form7.ibDataSet2ESTADO.AsString) and (Form7.ibDataSet2ESTADO.AsString <> 'EX') then
        begin
          Form7.ibDataSet16PFCPUFDEST.Visible := True;
          Form7.ibDataSet16PICMSUFDEST.Visible := True;
        end else
        begin
          Form7.ibDataSet16PFCPUFDEST.Visible := False;
          Form7.ibDataSet16PICMSUFDEST.Visible := False;
        end;
      end else
      begin
        Edit3.Text := '0-Normal';

        Form7.ibDataSet16PFCPUFDEST.Visible := False;
        Form7.ibDataSet16PICMSUFDEST.Visible := False;
      end;

      if AllTrim(Form7.ibDataSet2ESTADO.AsString)='EX' then
      begin
        Form7.ibDataSet16PFCPUFDEST.Visible := False;
        Form7.ibDataSet16PICMSUFDEST.Visible := False;
      end;
    except
    end;

    // Indicador de presença do comprador no estabelecimento comercial no momento da operação:
    //  0=Não se aplica (por exemplo, para a Nota Fiscal complementar ou de ajuste)
    //  1=Operação presencial
    //  2=Operação não presencial, pela Internet
    //  3=Operação não presencial, Teleatendimento
    //  4=NFC-e em operação com entrega em domicílio
    //  9=Operação não presencial, outros.
    //
    try
      if AllTrim(Form7.ibDataSet15INDPRES.AsString) = '' then
      begin
        try
          Form7.ibQuery1.Close;
          Form7.ibQuery1.SQL.Clear;
          Form7.ibQuery1.SQL.Add('select first 1 INDPRES from VENDAS where coalesce(INDPRES,''X'')<>''X'' order by NUMERONF desc');
          Form7.ibQuery1.Open;

          Form7.ibDataSet15INDPRES.AsString := Form7.ibQuery1.FieldByName('INDPRES').AsString;
        except
        end;
      end;

      if Form7.ibDataSet15INDPRES.AsString = '0' then
      begin
        Edit6.Text := '0=Não se aplica';
      end else
      begin
        if Form7.ibDataSet15INDPRES.AsString = '1' then
        begin
          Edit6.Text := '1=Operação presencial';
        end else
        begin
          if Form7.ibDataSet15INDPRES.AsString = '2' then
          begin
            Edit6.Text := '2=Operação não presencial, pela Internet';
          end else
          begin
            if Form7.ibDataSet15INDPRES.AsString = '3' then
            begin
              Edit6.Text := '3=Operação não presencial, Teleatendimento';
            end else
            begin
              if Form7.ibDataSet15INDPRES.AsString = '4' then
              begin
                Edit6.Text := '4=NFC-e em operação com entrega em domicílio';
              end else
              begin
                if Form7.ibDataSet15INDPRES.AsString = '5' then
                begin
                  Edit6.Text := '5=Operação presencial fora do estabelecimento;';
                end else
                begin
                  if Form7.ibDataSet15INDPRES.AsString = '9' then
                  begin
                    Edit6.Text := '9=Operação não presencial, outros';
                  end else
                  begin
                    Edit6.Text := '1=Operação presencial';
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      ShowMarketplaceTab();
    except
    end;

    // THE END;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Close;
    {Mauricio Parizotto 2024-09-24 Inicio
    Form7.ibDataSet14.SelectSQL.Clear;
    Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or SubString(CFOP from 1 for 1) = ''7'' order by upper(NOME)');
    }
    Form7.ibDataSet14.SelectSQL.Text := ' Select * '+
                                        ' From ICM '+
                                        ' Where (SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or SubString(CFOP from 1 for 1) = ''7'' ) '+
                                        '   and (Coalesce(LISTAR,''S'') = ''S''  or NOME = '+QuotedStr(Form7.ibDAtaSet15OPERACAO.AsString)+')'+
                                        ' Order by upper(NOME)';
    {Mauricio Parizotto 2024-09-24 Fim}
    Form7.ibDataSet14.Open;
    Form7.ibDataSet14.EnableControls;

    if Alltrim(Form7.ibDAtaSet15OPERACAO.AsString) <> '' then
    begin
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Locate('NOME',AllTrim(Form7.ibDAtaSet15OPERACAO.AsString),[]);
      Form7.ibDataSet14.EnableControls;
    end;

    Form12.Image5.Picture := nil;
    Form12.Image5.Visible := False;
    Form12.Panel9.Visible := False;

    Form1.bFlag := False;

    Form12.Top     := Form7.Top;
    Form12.Left    := Form7.Left;
    Form12.Width   := Form7.Width;
    Form12.Height  := Form7.Height;

    Form7.ibDataSet16UNITARIO.Visible := True;
    Form7.ibDataSet35UNITARIO.Visible := True;
    ScrollBox1.VertScrollBar.Position := 1;

    // FOTO
    Panel9.Top    := Form12.Panel1.Top;
    Panel9.Left   := Panel1.Left + Panel1.Width + 5;
    Panel9.Width  := Screen.Width - Panel9.Left - 10;
    Panel9.Height := 300;

    if Panel9.Width  > 300 then Panel9.Width := 300;
    if Panel9.Height > 300 then Panel9.Height := 300;

    if ParamCount > 0 then
    begin
      if AllTrim(Copy(UpperCase(ParamStr(1)),1,3)) = 'URB' then
      begin
  //      Form7.Top := 0 - form7.Height - 10;
      end;
    end;

    try
      Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
    except
    end;
  end;
end;

procedure TForm12.DBGrid4Enter(Sender: TObject);
var
  I          : Integer;
begin
  // Autocompletar serviços
  ListBox2.Visible := False;
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
  ListBox2.Items.Clear;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select DESCRICAO, PRECO from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' order by DESCRICAO'); // Ok
  Form7.ibDataSet99.Open;

  for I := 1 to 9999 do fPrecoDoServico[I] := 0;
  I := 0;

  if Form7.ibDataSet99.FieldByname('DESCRICAO').AsString <> '' then
  begin
    while not Form7.ibDataSet99.Eof do
    begin
      ListBox2.Items.Add(AllTrim(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString));
      fPrecoDoServico[I] := Form7.ibDataSet99.FieldByname('PRECO').AsFloat;
      I := I + 1;

      Form7.ibDataSet99.Next;
    end;
  end;

  ListBox2.Visible := False;
end;

procedure TForm12.DBGrid4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN  then
  begin
    if ListBox2.Visible then
    begin
      ListBox2.SetFocus;
      Abort;
    end;
  end;
  
  if Key = VK_UP then
  begin
    if ListBox2.Visible then
    begin
      ListBox2.SetFocus;
      Abort;
    end;
  end;

  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26
end;

procedure TForm12.ListBox2Click(Sender: TObject);
begin
  if ListBox2.Items.Count <= 0 then
    Exit;

  Form7.ibDataSet35.DisableControls;
  Form7.ibDataSet35.Edit;
  Form7.ibDataSet35DESCRICAO.AsString := ListBox2.Items[ListBox2.ItemIndex];
  Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
  Form7.ibDataSet35UNITARIO.AsFloat   := fPrecoDoServico[ListBox2.ItemIndex];
  dbGrid4.SetFocus;
  Form7.ibDataSet35.EnableControls;
end;

procedure TForm12.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then
  begin
    ListBox2.ItemIndex := ListBox2.ItemIndex + 1;
    Abort;
  end;

  if Key = VK_UP     then
  begin
    ListBox2.ItemIndex := ListBox2.ItemIndex - 1;
    Abort;
  end;

  if Key = vK_return then
    Form12.ListBox2Click(Sender);
end;

procedure TForm12.LoadAddress();
begin
  IBQueryAddress.DisableControls;
  try
    IBQueryAddress.Close();
    IBQueryAddress.SQL.Text := Format(Get_SQL_CliforAddress(), ['']);
    IBQueryAddress.ParamByName('IDCLIFOR').AsInteger :=
      IBQueryRecebedor.FieldByName('IDCLIFOR').AsInteger;
    IBQueryAddress.Open();
    IBQueryAddress.FetchAll();
  finally
    IBQueryAddress.EnableControls;
  end;
end;

procedure TForm12.LoadRecebedor(AFilterByNome: String);
begin
  IBQueryRecebedor.Close();
  var NullUnion := 'SELECT '+
    '  NULL AS idclifor, '+
    '  CAST(NULL AS VARCHAR(100)) AS nome '+
    ' FROM '+
    '  RDB$DATABASE '+
    ' UNION ALL ';

  var Filter := 'where coalesce(ATIVO, 0) = 0 and not(NOME = '+QuotedStr('')+')';
  if not(Trim(AFilterByNome) = '') then
  begin
    Filter := Filter + Format(
      ' and upper(NOME) LIKE ''%%%s%%''', [UpperCase(Trim(AFilterByNome))]
    );
    NullUnion := '';
  end;

  if not(Form7.ibDataSet15IDRECEBEDOR.IsNull) then
    Filter := Filter + ' or idclifor = '+Form7.ibDataSet15IDRECEBEDOR.AsString;

  IBQueryRecebedor.SQL.Text :=
    NullUnion +
    ' SELECT '+
    '  idclifor, '+
    '  nome '+
    ' FROM '+
    '  clifor '+
    '  '+
    Filter +
    ' ORDER BY '+
    '  2;';

  IBQueryRecebedor.DisableControls;
  try
    IBQueryRecebedor.Open();
    IBQueryRecebedor.FetchAll();
  finally
    IBQueryRecebedor.EnableControls;
  end;
end;

procedure TForm12.DBGrid4ColEnter(Sender: TObject);
begin
  ListBox2.Visible := False;
end;

procedure TForm12.Button2Enter(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 200;
end;

procedure TForm12.tbsLocalEntregaShow(Sender: TObject);
begin
  EditRecebedorNome.Text := '';
  LoadRecebedor();

  if not(Form7.ibDataSet15IDRECEBEDOR.AsInteger = 0)  then
  begin
    if IBQueryRecebedor.Locate('IDCLIFOR', Form7.ibDataSet15IDRECEBEDOR.AsInteger, []) then
      EditRecebedorNome.Text := Trim(IBQueryRecebedor.FieldByName('NOME').AsString);
    LoadAddress();
    Exit;
  end;

end;

function TForm12.TestarLimiteDisponivel: Boolean;
begin
  Result := False;
  if not Form7.TestarLimiteDisponivel then
  begin
    SMALL_DBEdit40.SetFocus;
    Exit;
  end;
  Result := True;  
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
  if not TestarLimiteDisponivel then
    Exit;

  Form12.DBGrid1.SelectedIndex := 0;

  try
    bOk := True;
    Form12.Close;
    Form7.Image101Click(Sender);
  except
  end;
end;

procedure TForm12.Incluirnovoitemnoestoque1Click(Sender: TObject);
var
  sTitulo : String;
begin
  {

  Reativar quando estiver concluída a migração do cadastro de prdoutos usando a tela padrão de cadastro

  if Form1.imgEstoque.Visible then
  begin
    sTitulo := Form7.sTitulo;

    Form7.ibDataSet15.DisableControls;
    Form7.ibDataSet16.DisableControls;

    try
      try
        if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
          Form7.ibDataset4.Post;
      except
      end;

      Form1.bFechaTudo           := False;
      Form1.imgEstoqueClick(Sender);
      Form7.Close;
      Form7.iKey := 0;
      Form7.ibDataSet4.Append; // Incluir novo item pela nota de compra
      Form10.ShowModal;

      Form7.sModulo := 'VENDA';
      Form7.sTitulo := sTitulo;

      Form7.Show;

      if Form12.DBGrid1.CanFocus then
        Form12.DBGrid1.SetFocus;
      Form7.ibDataSet16.Last;
    except
    end;

    Form1.bFechaTudo           := True;
    Form7.ibDataSet15.EnableControls;
    if Form7.sModulo <> 'RETRIBUTA' then
      Form7.ibDataSet16.EnableControls;
  end;
  }
end;

procedure TForm12.Incluirnovocliente1Click(Sender: TObject);
var
  sTitulo : String;
begin
  {

  Reativar quando estiver concluída a migração do cadastro de clientes usando a tela padrão de cadastro

  if Form1.imgCliFor.Visible then
  begin
    sTitulo := Form7.sTitulo;

    Form7.ibDataSet15.DisableControls;
    Form7.ibDataSet16.DisableControls;
    try
      Form1.bFechaTudo           := False;

      Form1.imgCliForClick(Sender);
      Form7.ibDataSet2.Append;
      Form7.Close;

      Form7.SetDataSetCadastros(Form7.IniFileUsuarioLogado);

      //Form10.ShowModal;
      if FrmFichaCadastros = nil then
        FrmFichaCadastros := TFrmFichaCadastros.Create(Self);
      FrmFichaCadastros.ShowModal;
      FreeAndNil(FrmFichaCadastros);



      Form7.sModulo := 'VENDA';
      Form7.sTitulo := sTitulo;

      Form7.Show;

      if Form12.DBGrid1.CanFocus then
        Form12.DBGrid1.SetFocus;
      Form7.ibDataSet16.Last;
    except
    end;
    
    Form1.bFechaTudo           := True;
    Form7.ibDataSet15.EnableControls;
    if Form7.sModulo <> 'RETRIBUTA' then
      Form7.ibDataSet16.EnableControls;
  end;
  }
end;

procedure TForm12.DBGrid3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MostraFoto(True);
end;

procedure TForm12.DBMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Button2.SetFocus;
  if Key = VK_TAB    then
    Button2.SetFocus;
  if Key = VK_UP     then
    Perform(Wm_NextDlgCtl,1,0);
end;

procedure TForm12.SMALL_DBEdit39KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    DBGrid2.Visible := False;
    Form7.ibDataSet16.First;
    Form7.ibDataSet16.EnableControls;
    DBGrid1.SetFocus;
    DbGrid1.SelectedIndex := 1;
    DbGrid1.SelectedIndex := 0;
  end;

  if Key = VK_DOWN   then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,0,0);
  end;

  if Key = VK_UP     then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,1,0);
  end;

  Key := VK_SHIFT;
end;

procedure TForm12.DBMemo1Enter(Sender: TObject);
begin
  ListBox2.Visible := False;
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
end;

procedure TForm12.SMALL_DBEdit41KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then SMALL_DBEdit28.SetFocus;
end;

procedure TForm12.Edit1Enter(Sender: TObject);
begin
  Form12.SMALL_DBEdit27.SetFocus;
  Form12.Edit1.Visible := False;
end;

procedure TForm12.Label_fecha_0Click(Sender: TObject);
begin
  Form12.Close;
end;

procedure TForm12.Edit2Click(Sender: TObject);
begin
  Edit2.Text := LimpaNumero(Form1.Small_InputForm('Finalidade da NFe:','1-Normal'+chr(10)+'2-Complementar'+chr(10)+'3-de Ajuste'+chr(10)+'4-Devolução de mercadoria',LimpaNumero(Edit2.Text)));


  (* Dailon Parisotto (SMAL-593) 2024-07-31 Inicio

  ExibeColunasFCPST(False);
  ExibeColunasFCP(False);
  ExibeColunaCSOSN(False); // Sandro Silva 2023-05-24

  {Sandro Silva 2023-05-08 inicio
  if (LimpaNumero(Edit2.Text) = '1') then
  begin
    Edit2.Text := '1-Normal';
  end else
  begin
    if (LimpaNumero(Edit2.Text) = '2') then
    begin
      Edit2.Text := '2-Complementar';
//      Form12.SMALL_DBEdit16.ReadOnly := False;
    end else
    begin
      if (LimpaNumero(Edit2.Text) = '3') then
      begin
        Edit2.Text := '3-de Ajuste';
      end else
      begin
        if (LimpaNumero(Edit2.Text) = '4') then
        begin
          Edit2.Text := '4-Devolução de mercadoria';
          ExibeColunasFCPST(True);
        end else
        begin
          Edit2.Text := '1-Normal';
        end;
      end;
    end;
  end;
  }
  Edit2.Text := TextoIdentificadorFinalidadeNFe(Edit2.Text);
  if (LimpaNumero(Edit2.Text) = '4') then
  begin
    ExibeColunasFCPST(True);
    //if Form7.ibDataSet13CRT.AsString = '1' then // Mauricio Parizotto 2024-08-07
    if (Form7.ibDataSet13CRT.AsString = '1')
      or (Form7.ibDataSet13CRT.AsString = '4') then
    begin
      ExibeColunaCSOSN(True); // Sandro Silva 2023-05-24
      ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString); //ExibeColunaCSTICMS(False); // Sandro Silva 2023-05-24
    end;
  end;
  {Sandro Silva 2023-05-08 fim}               *)

  ControlaColunasGridImpostos(Form7.ibDataSet14IMPOSTOMANUAL.AsString = 'S');
  {Dailon Parisotto (SMAL-593) 2024-07-31 Fim}

  //
  if Form7.ibDataSet15FINNFE.AsString   <> LimpaNumero(Edit2.Text) then
    Form7.ibDataSet15FINNFE.AsString   := LimpaNumero(Edit2.Text);
  //
  try
    Form12.SMALL_DBEdit40.SetFocus;
  except end;
  //
  // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
  //
end;

{ Dailon Parisotto (SMAL-593) 2024-07-31 Inicio}
procedure TForm12.ControlaColunasGridImpostos(AbNatOperManual: Boolean = False);
begin
  ExibeColunasFCPST(False);
  ExibeColunasFCP(False);
  ExibeColunaCSOSN(False);

  Form7.ibDataSet16IPI.Visible            := False;
  Form7.ibDataSet16CST_IPI.Visible        := False;
  Form7.ibDataSet16CST_ICMS.Visible       := False;
  Form7.ibDataSet16VICMS.Visible          := False;
  Form7.ibDataSet16VBC.Visible            := False;
  Form7.ibDataSet16ICM.Visible            := False;
  Form7.ibDataSet16VBCST.Visible          := False;
  Form7.ibDataSet16VICMSST.Visible        := False;
  Form7.ibDataSet16VIPI.Visible           := False;
  Form7.ibDataSet16XPED.Visible           := True;
  Form7.ibDataSet16NITEMPED.Visible       := True;

  Edit2.Text := TextoIdentificadorFinalidadeNFe(Edit2.Text);
  PanelAtencao.Visible := False;
  if (LimpaNumero(Edit2.Text) = '4') or (AbNatOperManual) then
  begin
    if AbNatOperManual then
      ExibeColunasFCPST(True);

    ExibeColunasFCPST(True);
    //if Form7.ibDataSet13CRT.AsString = '1' then Mauricio Parizotto 2025-01-29
    if (Form7.ibDataSet13CRT.AsString = '1')
      or (Form7.ibDataSet13CRT.AsString = '4') then
    begin
      ExibeColunaCSOSN(True);
      ExibeColunaCSTICMS('4', Form7.ibDataSet13CRT.AsString);
    end;

    Form7.ibDataSet16IPI.Visible            := True;
    Form7.ibDataSet16CST_IPI.Visible        := True;
    Form7.ibDataSet16CST_ICMS.Visible       := True;
    Form7.ibDataSet16VICMS.Visible          := True;
    Form7.ibDataSet16VBC.Visible            := True;
    Form7.ibDataSet16ICM.Visible            := True;
    Form7.ibDataSet16VBCST.Visible          := True;
    Form7.ibDataSet16VICMSST.Visible        := True;
    Form7.ibDataSet16VIPI.Visible           := True;
    Form7.ibDataSet16XPED.Visible           := False;
    Form7.ibDataSet16NITEMPED.Visible       := False;

    PanelAtencao.Visible := (not AbNatOperManual);

    Label2.Caption := 'Atenção!'+chr(10)+chr(10)+
      'Quando não for contribuinte do IPI'+chr(10)+
      'deixar o campo CST IPI em branco (vai'+chr(10)+
      'criar grupo IPIDevol).'+chr(10)+chr(10)+
      'Quando for contribuinte do IPI deve preencher'+chr(10)+
      'o campo CST IPI (vai criar grupo do IPI normal)'
  end;
end;
{ Dailon Parisotto (SMAL-593) 2024-07-31 Fim}

procedure TForm12.Edit3Click(Sender: TObject);
begin
  //
  Edit3.Text := LimpaNumero(Form1.Small_InputForm('Indicador de operação com Consumidor Final:','0-Normal'+chr(10)+'1-Consumidor Final',LimpaNumero(Edit3.Text)));

  {Mauricio Parizotto 2024-09-19 Inicio}
  CarregaTipoConsumidor(LimpaNumero(Edit3.Text));

  try
    Form12.SMALL_DBEdit40.SetFocus;
  except
  end;

  {  
  if (LimpaNumero(Edit3.Text) = '1') then
  begin
    //
    Edit3.Text := '1-Consumidor Final';
    //
    if (Form7.ibDataSet13ESTADO.AsString <> Form7.ibDataSet2ESTADO.AsString) and (Form7.ibDataSet2ESTADO.AsString <> 'EX') then
    begin
      Form7.ibDataSet16PFCPUFDEST.Visible := True;
      Form7.ibDataSet16PICMSUFDEST.Visible := True;
    end else
    begin
      Form7.ibDataSet16PFCPUFDEST.Visible := False;
      Form7.ibDataSet16PICMSUFDEST.Visible := False;
    end;
    //
  end else
  begin
    //
    Edit3.Text := '0-Normal';
    //
    Form7.ibDataSet16PFCPUFDEST.Visible := False;
    Form7.ibDataSet16PICMSUFDEST.Visible := False;
    //
  end;
  //
  if Form7.ibDataSet15INDFINAL.AsString <> LimpaNumero(Edit3.Text) then Form7.ibDataSet15INDFINAL.AsString := LimpaNumero(Edit3.Text);
  //
  try
    Form12.SMALL_DBEdit40.SetFocus;
  except end;
  //
  //
  if AllTrim(Form7.ibDataSet2ESTADO.AsString)='EX' then
  begin
    Form7.ibDataSet16PFCPUFDEST.Visible := False;
    Form7.ibDataSet16PICMSUFDEST.Visible := False;
  end;
  //
  // Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final)
  //
  Mauricio Parizotto 2024-09-19 Fim}
end;

procedure TForm12.Edit6Click(Sender: TObject);
begin
  //Edit6.Text := LimpaNumero(Form1.Small_InputForm('Indicador de presença','Indicador de presença do comprador no estabelecimento comercial no momento da operação:'+chr(10)+chr(10)+ Mauricio Parizotto 2024-08-08
  Edit6.Text := LimpaNumero(Form1.Small_InputForm('Indicador de presença do comprador no estabelecimento comercial no momento da operação:',//+chr(10)+chr(10)+
                '0=Não se aplica (por exemplo, para a Nota Fiscal complementar ou de ajuste);'+chr(10)+
                '1=Operação presencial;'+chr(10)+
                '2=Operação não presencial, pela Internet;'+chr(10)+
                '3=Operação não presencial, Teleatendimento;'+chr(10)+
                '4=NFC-e em operação com entrega em domicílio;'+chr(10)+
                '5=Operação presencial fora do estabelecimento;'+chr(10)+
                '9=Operação não presencial, outros.',LimpaNumero(Edit6.Text)));

  if (LimpaNumero(Edit6.Text) = '0') then
  begin
    Edit6.Text := '0=Não se aplica';
  end else
  begin
    if (LimpaNumero(Edit6.Text) = '1') then
    begin
      Edit6.Text := '1=Operação presencial';
    end else
    begin
      if (LimpaNumero(Edit6.Text) = '2') then
      begin
        Edit6.Text := '2=Operação não presencial, pela Internet';
      end else
      begin
        if (LimpaNumero(Edit6.Text) = '3') then
        begin
          Edit6.Text := '3=Operação não presencial, Teleatendimento';
        end else
        begin
          if (LimpaNumero(Edit6.Text) = '4') then
          begin
            Edit6.Text := '4=NFC-e em operação com entrega em domicílio';
          end else
          begin 
            if (LimpaNumero(Edit6.Text) = '5') then
            begin
              Edit6.Text := '5=Operação presencial fora do estabelecimento;';
            end else
            begin
              Edit6.Text := '9=Operação não presencial, outros';
            end;
          end;
        end;
      end;
    end;
  end;

  ShowMarketplaceTab();

  if Form7.ibDataSet15INDPRES.AsString  <> LimpaNumero(Edit6.Text) then
    Form7.ibDataSet15INDPRES.AsString  := LimpaNumero(Edit6.Text);

  try
    Form12.SMALL_DBEdit40.SetFocus;
  except
  end;

  // Indicador de presença do comprador no estabelecimento comercial no momento da operação
end;

procedure TForm12.EditRecebedorNomeEnter(Sender: TObject);
begin
  DBGrid2.Visible := False;
  LoadRecebedor(EditRecebedorNome.Text);
  DBGridRecebedor.Parent := Panel1;
  DBGridRecebedor.Width := EditRecebedorNome.Width;
  DBGridRecebedor.Top := PageControlAddressMktp.Top + EditRecebedorNome.Top
    + EditRecebedorNome.Height + 25;
  DBGridRecebedor.Left := PageControlAddressMktp.Left
    + EditRecebedorNome.Left + 4;
  DBGridRecebedor.Height := 135;
  DBGridRecebedor.Visible := True;
end;

procedure TForm12.EditRecebedorNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) and (DBGridRecebedor.Visible) then
    DBGridRecebedor.SetFocus;

  if Key = VK_RETURN then
  begin
    if EditRecebedorNome.Text = '' then
      SetRecebedor(True);
    DBLookupComboBoxEnderReceb.SetFocus;
  end;
end;

procedure TForm12.EditRecebedorNomeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LoadRecebedor(EditRecebedorNome.Text);
  if not(DBGridRecebedor.Visible) then
    DBGridRecebedor.Visible := True;
end;

procedure TForm12.PopupMenuInsertChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  {
  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
  begin
    Emitirnotafiscaldevendasnobalco1.Enabled := True;
  end else
  begin
    Emitirnotafiscaldevendasnobalco1.Enabled := False;
  end;
  Mauricio Parizotto 2023-07-25 Vai validar depois}
  Emitirnotafiscaldevendasnobalco1.Enabled := True;
end;

procedure TForm12.ComboBoxMarktplaceExit(Sender: TObject);
begin
  try
    Form7.ibDataSet15MARKETPLACE.AsString := ComboBoxMarktplace.Text;
  except
  end;
end;


procedure TForm12.AtivaPesquisaNaturezaOP;
begin
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
  // ------------------------- //
  // Operação de venda ICM.DBF //
  // ------------------------- //
  dBGrid2.DataSource := Form7.DataSource14;
  //dBGrid2.Visible    := True;


  if AllTrim(SMALL_DBEdit40.Text) = '' then
  begin
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.First;
    while (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '5'+Copy(Form1.ConfCFOP,2,3))
      and (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '6'+Copy(Form1.ConfCFOP,2,3))
      and (not Form7.ibDataSet14.EOF) do
      Form7.ibDataSet14.Next;
      
    Form7.ibDataSet14.EnableControls;
    Form7.ibDataSet15.Edit;
    SMALL_DBEdit40.Text := Form7.ibDataSet14NOME.AsString;
  end else
  begin
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Locate('NOME',AllTrim(Form7.ibDAtaSet15OPERACAO.AsString),[]);
    Form7.ibDataSet14.EnableControls;
  end;

  Form7.ibDataSet14.EnableControls;

  dBGrid2.Left       := SMALL_DBEdit40.Left;
  dbGrid2.Top        := SMALL_DBEdit40.Top + SMALL_DBEdit40.Height -1;
  dbGrid2.Width      := SMALL_DBEdit40.Width;
  dBGrid2.Height     := 260; //Panel1.Height - dbGrid2.Top - 20;

  dbGrid2.Columns[0].Width   := 250;
  dbGrid2.Columns[1].Width   := 30;
  dbGrid2.Columns[1].Visible := True;
end;

procedure TForm12.AtivaPesquisaVendedor;
begin
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;

  dBGrid2.DataSource         := Form7.DataSource9;
  dBGrid2.Left               := SMALL_DBEdit43.Left;
  dbGrid2.Top                := SMALL_DBEdit43.Top + SMALL_DBEdit43.Height -1;
  dbGrid2.Width              := SMALL_DBEdit43.Width;
  dBGrid2.Height             := 161; //Panel1.Height - dbGrid2.Top - 20;

  dbGrid2.Columns[0].Width   := SMALL_DBEdit43.Width -10;
  dbGrid2.Columns[1].Visible := False;
end;

procedure TForm12.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = WM_LBUTTONDOWN) or (Msg.message = WM_RBUTTONDOWN)
    or (Msg.wParam = VK_RETURN) then
  begin
    if DBGrid2.Focused or DBGrid3.Focused or ListBox2.Focused then
    begin
      DBGridRecebedor.Visible := False;
      Exit();
    end;

    DBGridRecebedor.Visible := False;

    if not(SMALL_DBEdit40.Focused) and not(SMALL_DBEdit43.Focused) and
      not(SMALL_DBEdit41.Focused) then
      DBGrid2.Visible := False;

    if not(DBGrid1.Focused) then
      DBGrid3.Visible := False;

    if not(DBGrid4.Focused) then
      ListBox2.Visible := False;

  end;
end;

procedure TForm12.AtivaPesquisaCliente;
begin
  dBGrid3.Visible    := False;
  dBGrid2.DataSource := Form7.DataSource2;
  dBGrid2.Visible    := False;

  dBGrid2.Left       := SMALL_DBEdit39.Left;
  dbGrid2.Top        := SMALL_DBEdit39.Top + SMALL_DBEdit39.Height -1;
  dbGrid2.Width      := SMALL_DBEdit39.Width;
  dBGrid2.Height     := 225; // Panel1.Height - dbGrid2.Top - 20;
  
  dbGrid2.Columns[0].Width := dbGrid2.Width - 30;
  dbGrid2.Columns[0].Width := 250;
  dbGrid2.Columns[1].Visible := False;
end;

procedure TForm12.AtivaPesquisaTransportadora;
begin
  ListBox2.Visible := False;
  dBGrid2.DataSource := Form7.DataSource18;
  dBGrid2.Left := SMALL_DBEdit41.Left;
  dbGrid2.Top := PanelIdentificadorTransp.Top
    + SMALL_DBEdit41.Top
    + SMALL_DBEdit41.Height
    - 1;
  dbGrid2.Width := SMALL_DBEdit41.Width;
  dBGrid2.Height := Panel1.Height
    - dbGrid2.Top
    - 20;
end;

procedure TForm12.SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_venda.htm')));

  if Form7.sModulo <> 'DESCONTO' then
  begin
    if Key = VK_RETURN then
    begin
      if SMALL_DBEdit43.CanFocus then
        SMALL_DBEdit43.SetFocus;
    end;

    if Key = VK_DOWN   then
    begin
      if dBgrid2.Visible = True then
        dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,0,0);
    end;
    if Key = VK_UP     then
    begin
      if dBgrid2.Visible = True then
        dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,1,0);
    end;
    
    Key := VK_SHIFT;
  end else
  begin
    Form7.sModulo := 'VENDA';
  end;
end;

procedure TForm12.SMALL_DBEdit40Click(Sender: TObject);
begin
  dBgrid2.Visible := True;
end;

procedure TForm12.SMALL_DBEdit43Click(Sender: TObject);
begin
  dBgrid2.Visible := True;
end;

procedure TForm12.SMALL_DBEdit39Click(Sender: TObject);
begin
  dBgrid2.Visible := True;
end;

procedure TForm12.SMALL_DBEdit41Click(Sender: TObject);
begin
  dBGrid2.Visible := True;
  if not SMALL_DBEdit41.Focused then
  begin
    SMALL_DBEdit41.SetFocus;
    SMALL_DBEdit41.SelectAll;
    SMALL_DBEdit41Change(Self);    
  end;
end;

procedure TForm12.ExibeColunasFCP(bOculta: Boolean);
begin
  Form7.ibDataSet16VBCFCP.Visible := bOculta;
  Form7.ibDataSet16PFCP.Visible   := bOculta;
  Form7.ibDataSet16VFCP.Visible   := bOculta;
end;

procedure TForm12.ExibeColunasFCPST(bExibe: Boolean);
begin
  Form7.ibDataSet16VBCFCPST.Visible := bExibe;
  Form7.ibDataSet16PFCPST.Visible   := bExibe;
  Form7.ibDataSet16VFCPST.Visible   := bExibe;
end;

procedure TForm12.ExibeColunaCSOSN(bExibe: Boolean);
begin
  Form7.ibDataSet16CSOSN.Visible    := bExibe;
end;

procedure TForm12.ExibeColunaCSTICMS(FINNFE: String; CRT: String); //procedure TForm12.ExibeColunaCSTICMS(bExibe: Boolean);
begin
  //Form7.ibDataSet16CST_ICMS.Visible := bExibe;
  Form7.ibDataSet16CST_ICMS.DisplayLabel := 'CST ICMS';
  //if (FINNFE = '4') and (CRT = '1') then // Devolução e simples nacional Mauricio Parizotto 2024-08-07
  if (FINNFE = '4') and ( ( CRT = '1' ) or (CRT = '4' ) ) then // Devolução e simples nacional
    Form7.ibDataSet16CST_ICMS.DisplayLabel := 'Origem';
end;

function TForm12.getPodeFecharTela: Boolean;
begin
  Result := True;

  if not Self.Showing then
    Exit;
  if Form7.TestarLimiteDisponivel then
    Exit;

  Result := False;
end;

procedure TForm12.edtTotalNotaChange(Sender: TObject);
begin
  if (not Self.Showing) then
    Exit;
  if (not edtTotalNota.DataSource.DataSet.Active) then
    Exit;
  if Form7.TestarLimiteDisponivel then
    Exit;
end;

procedure TForm12.CriaVariavelCalcNota;
begin
  if (not Assigned(vNotaFiscal)) then
    vNotaFiscal := TNotaFiscalEletronicaCalc.Create;
end;


procedure TForm12.CarregaTipoConsumidor(sTipo : string); //Mauricio Parizotto 2024-09-19
begin
  // Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final)

  if (sTipo = '1') then
  begin
    Edit3.Text := '1-Consumidor Final';

    if (Form7.ibDataSet13ESTADO.AsString <> Form7.ibDataSet2ESTADO.AsString) and (Form7.ibDataSet2ESTADO.AsString <> 'EX') then
    begin
      Form7.ibDataSet16PFCPUFDEST.Visible := True;
      Form7.ibDataSet16PICMSUFDEST.Visible := True;
    end else
    begin
      Form7.ibDataSet16PFCPUFDEST.Visible := False;
      Form7.ibDataSet16PICMSUFDEST.Visible := False;
    end;
  end else
  begin
    Edit3.Text := '0-Normal';

    Form7.ibDataSet16PFCPUFDEST.Visible := False;
    Form7.ibDataSet16PICMSUFDEST.Visible := False;
  end;

  if Form7.ibDataSet15INDFINAL.AsString <> LimpaNumero(Edit3.Text) then
    Form7.ibDataSet15INDFINAL.AsString := LimpaNumero(Edit3.Text);

  if AllTrim(Form7.ibDataSet2ESTADO.AsString)='EX' then
  begin
    Form7.ibDataSet16PFCPUFDEST.Visible := False;
    Form7.ibDataSet16PICMSUFDEST.Visible := False;
  end;
end;

function TForm12.IsConsumidorFinal : boolean; //Mauricio Parizotto 2024-09-19
begin
  Result := (Length(LimpaNumero(Form7.IBDataSet2CGC.AsString)) = 11) and (Copy(Form7.IBDataSet2IE.AsString,1,2) <> 'PR');
end;


end.
