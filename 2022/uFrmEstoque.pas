unit uFrmEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls, WinInet,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo, System.IniFiles, Vcl.Grids, Vcl.DBGrids, Videocap,
  Vcl.Imaging.jpeg, Vcl.Clipbrd, Vcl.OleCtrls, SHDocVw, Vcl.ExtDlgs,
  Winapi.ShellAPI, uframePesquisaPadrao, uframePesquisaProduto;

type
  TFrmEstoque = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    lblCodigo: TLabel;
    edtCodigo: TSMALL_DBEdit;
    lblCodBarras: TLabel;
    edtCodBarras: TSMALL_DBEdit;
    lblDescricao: TLabel;
    edtDescricao: TSMALL_DBEdit;
    lblGrupo: TLabel;
    lblUndMed: TLabel;
    lblPreco: TLabel;
    edtPreco: TSMALL_DBEdit;
    lblPrecoUS: TLabel;
    edtPrecoUS: TSMALL_DBEdit;
    lblCustoCompra: TLabel;
    edtCustoCompra: TSMALL_DBEdit;
    edtUltCompra: TSMALL_DBEdit;
    lblUltCompra: TLabel;
    lblCustoMedio: TLabel;
    edtCustoMedio: TSMALL_DBEdit;
    lblQuantidade: TLabel;
    edtQuantidade: TSMALL_DBEdit;
    lblQtdMinima: TLabel;
    edtQtdMinima: TSMALL_DBEdit;
    lblUltVenda: TLabel;
    edtUltVenda: TSMALL_DBEdit;
    lblLocalizacao: TLabel;
    edtLocalizacao: TSMALL_DBEdit;
    lblPeso: TLabel;
    edtPeso: TSMALL_DBEdit;
    tbsICMS: TTabSheet;
    fraGrupo: TfFrameCampo;
    fraUndMed: TfFrameCampo;
    Label18: TLabel;
    edtIdentificador1: TSMALL_DBEdit;
    Label19: TLabel;
    edtIdentificador2: TSMALL_DBEdit;
    Label20: TLabel;
    edtIdentificador3: TSMALL_DBEdit;
    Label21: TLabel;
    edtIdentificador4: TSMALL_DBEdit;
    lblAplicacao: TLabel;
    memAtivacao: TDBMemo;
    lblComissao: TLabel;
    edtComissao: TSMALL_DBEdit;
    edtLucroBruto: TSMALL_DBEdit;
    lblLucroBruto: TLabel;
    tbsIPI: TTabSheet;
    tbsGrade: TTabSheet;
    tbsSerial: TTabSheet;
    tbsComposicao: TTabSheet;
    tbsFoto: TTabSheet;
    tbsPreco: TTabSheet;
    tbsPromocao: TTabSheet;
    tbsConversao: TTabSheet;
    tbsCodBarras: TTabSheet;
    tbsTags: TTabSheet;
    RichEdit1: TRichEdit;
    dbgCodBar: TDBGrid;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    lblExemploConversao: TLabel;
    SMALL_DBEdit64: TSMALL_DBEdit;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    StringGrid2: TStringGrid;
    Label106: TLabel;
    Memo1: TMemo;
    memTags: TDBMemo;
    StringGrid1: TStringGrid;
    GroupBox3: TGroupBox;
    Label44: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    SMALL_DBEdit45: TSMALL_DBEdit;
    SMALL_DBEdit46: TSMALL_DBEdit;
    SMALL_DBEdit50: TSMALL_DBEdit;
    SMALL_DBEdit51: TSMALL_DBEdit;
    GroupBox4: TGroupBox;
    Label99: TLabel;
    Label102: TLabel;
    Label101: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    SMALL_DBEdit69: TSMALL_DBEdit;
    SMALL_DBEdit71: TSMALL_DBEdit;
    SMALL_DBEdit70: TSMALL_DBEdit;
    SMALL_DBEdit72: TSMALL_DBEdit;
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
    btnPrecoIgual: TBitBtn;
    Edit18: TEdit;
    SMALL_DBEdit40: TSMALL_DBEdit;
    Edit19: TEdit;
    SMALL_DBEdit42: TSMALL_DBEdit;
    Edit20: TEdit;
    SMALL_DBEdit43: TSMALL_DBEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    btnPreco: TBitBtn;
    btnPrecoTodos: TBitBtn;
    Image3: TImage;
    Image5: TImage;
    VideoCap1: TVideoCap;
    Button13: TBitBtn;
    Button7: TBitBtn;
    Button22: TBitBtn;
    WebBrowser1: TWebBrowser;
    OpenPictureDialog1: TOpenPictureDialog;
    Label39: TLabel;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Button3: TBitBtn;
    Edit5: TEdit;
    Edit6: TEdit;
    dbgComposicao: TDBGrid;
    SMALL_DBEdit33: TSMALL_DBEdit;
    SMALL_DBEdit34: TSMALL_DBEdit;
    Button8: TBitBtn;
    Button10: TBitBtn;
    Button11: TBitBtn;
    framePesquisaProdComposicao: TframePesquisaProduto;
    edtTitulo1: TEdit;
    edtTitulo2: TEdit;
    edtTitulo4: TEdit;
    edtTitulo3: TEdit;
    edtTitulo5: TEdit;
    edtTitulo6: TEdit;
    edtTitulo7: TEdit;
    chkControlaSerial: TCheckBox;
    btnProcurarSer: TBitBtn;
    btnHistoricoItemSer: TBitBtn;
    btnHistoricoSer: TBitBtn;
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
    Label72: TLabel;
    Label84: TLabel;
    Label92: TLabel;
    Label71: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label118: TLabel;
    SMALL_DBEdit31: TSMALL_DBEdit;
    SMALL_DBEdit37: TSMALL_DBEdit;
    SMALL_DBEdit38: TSMALL_DBEdit;
    cboCST_Prod: TComboBox;
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
    ComboBox9: TComboBox;
    ComboBox6: TComboBox;
    cboOrigemProd: TComboBox;
    cboCSOSN_Prod: TComboBox;
    ComboBox11: TComboBox;
    ComboBox14: TComboBox;
    ComboBox15: TComboBox;
    SMALL_DBEdit66: TSMALL_DBEdit;
    SMALL_DBEdit52: TSMALL_DBEdit;
    SMALL_DBEdit63: TSMALL_DBEdit;
    SMALL_DBEdit65: TSMALL_DBEdit;
    SMALL_DBEdit67: TSMALL_DBEdit;
    fraPerfilTrib: TfFrameCampo;
    ComboBox5: TComboBox;
    chkMarketplace: TCheckBox;
    GroupBox1: TGroupBox;
    Label41: TLabel;
    Label40: TLabel;
    Label98: TLabel;
    ComboBox1: TComboBox;
    SMALL_DBEdit41: TSMALL_DBEdit;
    SMALL_DBEdit68: TSMALL_DBEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label42: TLabel;
    ComboBox7: TComboBox;
    dbepPisSaida: TSMALL_DBEdit;
    Label43: TLabel;
    Label49: TLabel;
    dbepCofinsSaida: TSMALL_DBEdit;
    dbeIcmBCPISCOFINS: TSMALL_DBEdit;
    lbBCPISCOFINS: TLabel;
    Label38: TLabel;
    ComboBox10: TComboBox;
    Label50: TLabel;
    dbepPisEntrada: TSMALL_DBEdit;
    Label54: TLabel;
    dbepCofinsEntrada: TSMALL_DBEdit;
    dbgSerial: TDBGrid;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure FormActivate(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label18MouseLeave(Sender: TObject);
    procedure Label18MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure edtCodBarrasKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDescricaoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDescricaoExit(Sender: TObject);
    procedure chkMarketplaceClick(Sender: TObject);
    procedure dbgCodBarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox12Change(Sender: TObject);
    procedure ComboBox13Change(Sender: TObject);
    procedure SMALL_DBEdit64Change(Sender: TObject);
    procedure SMALL_DBEdit64Exit(Sender: TObject);
    procedure tbsCodBarrasEnter(Sender: TObject);
    procedure tbsConversaoEnter(Sender: TObject);
    procedure tbsTagsExit(Sender: TObject);
    procedure tbsTagsShow(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnPrecoTodosClick(Sender: TObject);
    procedure btnPrecoClick(Sender: TObject);
    procedure tbsPrecoShow(Sender: TObject);
    procedure SMALL_DBEdit32Exit(Sender: TObject);
    procedure btnPrecoIgualClick(Sender: TObject);
    procedure SMALL_DBEdit32KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button13Click(Sender: TObject);
    procedure tbsFotoShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tbsGradeShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure tbsComposicaoShow(Sender: TObject);
    procedure dbgComposicaoColEnter(Sender: TObject);
    procedure dbgComposicaoColExit(Sender: TObject);
    procedure dbgComposicaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgComposicaoKeyPress(Sender: TObject; var Key: Char);
    procedure dbgComposicaoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure framePesquisaProdComposicaodbgItensPesqKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure framePesquisaProdComposicaodbgItensPesqKeyPress(Sender: TObject;
      var Key: Char);
    procedure framePesquisaProdComposicaodbgItensPesqCellClick(Column: TColumn);
    procedure Edit6Enter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure tbsSerialShow(Sender: TObject);
    procedure chkControlaSerialClick(Sender: TObject);
    procedure chkControlaSerialExit(Sender: TObject);
    procedure dbgSerialKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgSerialKeyPress(Sender: TObject; var Key: Char);
    procedure btnProcurarSerClick(Sender: TObject);
    procedure btnHistoricoItemSerClick(Sender: TObject);
    procedure btnHistoricoSerClick(Sender: TObject);
    procedure tbsICMSShow(Sender: TObject);
    procedure tbsIPIShow(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox10Change(Sender: TObject);
    procedure ComboBox10Enter(Sender: TObject);
    procedure tbsIPIEnter(Sender: TObject);
    procedure ComboBox9Change(Sender: TObject);
    procedure SMALL_DBEdit31Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure cboOrigemProdChange(Sender: TObject);
    procedure SMALL_DBEdit38Exit(Sender: TObject);
    procedure ComboBox11Change(Sender: TObject);
    procedure ComboBox15Change(Sender: TObject);
    procedure ComboBox14Change(Sender: TObject);
    procedure cboCSOSN_ProdChange(Sender: TObject);
    procedure cboCST_ProdChange(Sender: TObject);
    procedure SMALL_DBEditYExit(Sender: TObject);
    procedure _RRClick(Sender: TObject);
    procedure fraPerfilTribExit(Sender: TObject);
    procedure fraPerfilTribtxtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    function CarregaValoresObjeto : boolean;
    procedure lblAnteriorClick(Sender: TObject);
    procedure lblProximoClick(Sender: TObject);
    procedure lblProcurarClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
  private
    { Private declarations }
    cCadJaValidado: String;
    sNomeDoJPG  : String;
    rCusto : Real;
    fQuantidade : Real;
    FotoOld : String;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure AtualizaObjComValorDoBanco;
    procedure AjustaCampoPrecoQuandoEmPromocao;
    function EmPeriodoPromocional: Boolean;
    function Exemplo(sP1: boolean): Boolean;
    function RetornarDescrCaracTagsObs: String;
    procedure ibDataSet28DESCRICAOChange(Sender: TField);
    procedure DefinirVisibleConsultaProdComposicao;
    procedure AtribuirItemPesquisaComposicao;
    procedure CarregaCit;
    function GravaImagemEstoque: Boolean;
  public
    { Public declarations }
  end;

var
  FrmEstoque: TFrmEstoque;

implementation

{$R *.dfm}

uses unit7, MAIS, smallfunc_xe, uDialogs, uPermissaoUsuario, MAIS3,
     uTestaProdutoExiste, uITestaProdutoExiste, Unit19;

{ TFrmEstoque }



procedure TFrmEstoque.dbgCodBarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26

  if bSomenteLeitura then
    Exit;

  if Key = VK_DELETE then
  begin
    if (not Form7.IBDataSet6.IsEmpty) then
      Form7.IBDataSet6.Delete;
  end;
end;

procedure TFrmEstoque.dbgComposicaoColEnter(Sender: TObject);
begin
  framePesquisaProdComposicao.Visible := False;
end;

procedure TFrmEstoque.dbgComposicaoColExit(Sender: TObject);
begin
  ibDataSet28DESCRICAOChange(Form7.ibDataSet28DESCRICAO);
end;

procedure TFrmEstoque.dbgComposicaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sCodigo: String;
  oTestaProd: ITestaProdutoExiste;
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26

  try
    if bSomenteLeitura then
    begin
      // Se esta somente leitura não pode apagar registros
      if (Shift = [SsCtrl]) and (key = vk_delete) then
        Key := 0;
    end;
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
        //if DbGrid1.SelectedIndex = 0 then Mauricio Parizotto 2024-07-16
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
              MensagemSistema('Você esta tentando criar uma referência circular. Esta composição não'+Chr(10)+'pode ser feita'+ chr(10)+ chr(10)+oTestaProd.getQuery.FieldByname('CODIGO').AsString +chr(10)+ sCodigo
                              ,msgAtencao);
            end;
          end else
          begin
            Form7.ibDataSet28.FieldByName('DESCRICAO').AsString := EmptyStr;
            MensagemSistema('Produto não cadastrado.',msgAtencao);
          end;

          dbgComposicao.Update;
        end;
      end;

      tbsComposicaoShow(Sender);
    end;

    DefinirVisibleConsultaProdComposicao;
  except
  end;
end;

procedure TFrmEstoque.dbgComposicaoKeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if TipoCampoFloat(dbgComposicao.SelectedField) then //Sandro Silva Silva 024-04-29 if dbgComposicao.SelectedField.DataType = ftFloat then
    if Key = chr(46) then
      key := chr(44);

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

procedure TFrmEstoque.dbgComposicaoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if dbgComposicao.SelectedIndex = 0 then
  begin
    if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) and (Key <> VK_DELETE) then
    begin
      if (not framePesquisaProdComposicao.Visible) and (framePesquisaProdComposicao.Enabled) then
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

procedure TFrmEstoque.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  if bGravandoRegistro then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmEstoque.Edit6Enter(Sender: TObject);
begin
  if dbgComposicao.CanFocus then
    dbgComposicao.SetFocus;
end;

procedure TFrmEstoque.edtCodBarrasKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  //(f-7225)
  if ((Form7.ibDataSet4DESCRICAO.AsString = EmptyStr) or ((cCadJaValidado <> Form7.ibDataSet4DESCRICAO.AsString) and (not Form7.TestarProdutoExiste(Form7.ibDataSet4DESCRICAO.AsString)))) then
  begin
    if (Copy(TSMALL_DBEdit(Sender).Text,1,1) = ' ') then
      TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
  end else
    cCadJaValidado := Form7.ibDataSet4DESCRICAO.AsString;
end;

procedure TFrmEstoque.edtDescricaoExit(Sender: TObject);
begin
  if (Form7.ibDataSet4DESCRICAO.AsString = '') then
  begin
    if edtDescricao.Focused then
    begin
      MensagemSistema('Descrição inválida.',msgAtencao);
      edtDescricao.SetFocus;
      Exit;
    end;
  end;
end;

procedure TFrmEstoque.edtDescricaoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Trim(TSMALL_DBEdit(Sender).Text) = '') and (TSMALL_DBEdit(Sender).Field.OldValue <> '') then
  begin
    if not (TSMALL_DBEdit(Sender).Field.DataSet.State in [dsEdit, dsInsert]) then
      TSMALL_DBEdit(Sender).Field.DataSet.Edit;
    TSMALL_DBEdit(Sender).Text := TSMALL_DBEdit(Sender).Field.AsString;
  end;

  //(f-7225)
  if ((Form7.ibDataSet4DESCRICAO.AsString = EmptyStr) or ((cCadJaValidado <> Form7.ibDataSet4DESCRICAO.AsString) and (not Form7.TestarProdutoExiste(Form7.ibDataSet4DESCRICAO.AsString)))) then
  begin
    if (Copy(TSMALL_DBEdit(Sender).Text,1,1) = ' ') then
      TSMALL_DBEdit(Sender).Text := AllTrim(TSMALL_DBEdit(Sender).Text);
  end else
    cCadJaValidado := Form7.ibDataSet4DESCRICAO.AsString;
end;

procedure TFrmEstoque.FormActivate(Sender: TObject);
begin
  inherited;

  pgcFicha.ActivePage := tbsCadastro;

  Image5.Left     := 20;
  Image5.Top      := 80;
  Image5.Width    := 640 div 2;
  Image5.Height   := 480 div 2;

  AtualizaObjComValorDoBanco;
end;

procedure TFrmEstoque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  framePesquisaProdComposicao.Visible := False;
  framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.Close;
end;

procedure TFrmEstoque.FormCreate(Sender: TObject);
begin
  inherited;

  WebBrowser1.Left := -20000;

  framePesquisaProdComposicao.setDataBase(Form7.IBDatabase1);

  StringGrid2.DrawingStyle       := gdsGradient;
  StringGrid2.GradientStartColor := $00F0F0F0;
  StringGrid2.GradientEndColor   := $00F0F0F0;

  Form7.ibDataSet28DESCRICAO.OnChange := ibDataSet28DESCRICAOChange;
end;

procedure TFrmEstoque.FormDeactivate(Sender: TObject);
begin
  try
    if AllTrim(form7.ibDataSet4DESCRICAO.AsString) = '' then
      Form7.ibDataSet4.Delete;
  except
  end;
end;

procedure TFrmEstoque.FormShow(Sender: TObject);
begin
  inherited;

  try
    Label18.Caption := DSCadastro.DataSet.FieldByName('LIVRE1').DisplayLabel;
    Label19.Caption := DSCadastro.DataSet.FieldByName('LIVRE2').DisplayLabel;
    Label20.Caption := DSCadastro.DataSet.FieldByName('LIVRE3').DisplayLabel;
    Label21.Caption := DSCadastro.DataSet.FieldByName('LIVRE4').DisplayLabel;
  except
  end;

  pgcFicha.ActivePage := tbsCadastro;

  if edtCodBarras.CanFocus then
    edtCodBarras.SetFocus;

  AjustaCampoPrecoQuandoEmPromocao;
end;

procedure TFrmEstoque.framePesquisaProdComposicaodbgItensPesqCellClick(
  Column: TColumn);
begin
  AtribuirItemPesquisaComposicao;
end;

procedure TFrmEstoque.framePesquisaProdComposicaodbgItensPesqKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  framePesquisaProdComposicao.dbgItensPesqKeyDown(Sender, Key, Shift);
end;

procedure TFrmEstoque.framePesquisaProdComposicaodbgItensPesqKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
    AtribuirItemPesquisaComposicao;
end;

procedure TFrmEstoque.fraPerfilTribExit(Sender: TObject);
begin
  fraPerfilTrib.FrameExit(Sender);
end;

procedure TFrmEstoque.fraPerfilTribtxtCampoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  fraPerfilTrib.txtCampoKeyDown(Sender, Key, Shift);
end;

function TFrmEstoque.GetPaginaAjuda: string;
begin
  Result := 'estoque.htm';
end;

procedure TFrmEstoque.Image5Click(Sender: TObject);
begin
  try
    while FileExists(pChar(sNomeDoJPG)) do
    begin
      DeleteFile(pChar(sNomeDoJPG));
    end;

    Image5.Picture.SaveToFile(sNomeDoJPG);

    Sleep(1000);

    ShellExecute( 0, 'Open',pChar(sNomeDoJPG),'','', SW_SHOWMAXIMIZED);

    MensagemSistema('Tecle <enter> para que a nova imagem seja exibida.');
//    AtualizaTela(True);
    CarregaValoresObjeto;
  except
  end;
end;

procedure TFrmEstoque.Label18Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  with Sender as TLabel do
  begin
    sNome   := StrTran(Trim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
    Caption := sNome+':';
    Repaint;

    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString(Form7.sModulo,NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TFrmEstoque.Label18MouseLeave(Sender: TObject);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmEstoque.Label18MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmEstoque.lblAnteriorClick(Sender: TObject);
begin
  pgcFicha.ActivePage := tbsCadastro;

  inherited;
end;

procedure TFrmEstoque.lblNovoClick(Sender: TObject);
begin
  //Mauricio Parizotto 2024-07-17
  if (AllTrim(Form7.ibDataSet4CODIGO.AsString) <> '')
    and (AllTrim(Form7.ibDataSet4DESCRICAO.AsString) = '') then
  begin
    Exit;
  end;

  inherited;

  pgcFicha.ActivePage := tbsCadastro;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  try
    if edtCodBarras.CanFocus then
      edtCodBarras.SetFocus;
  except
  end;
end;

procedure TFrmEstoque.lblProcurarClick(Sender: TObject);
begin
  pgcFicha.ActivePage := tbsCadastro;

  inherited;
end;

procedure TFrmEstoque.lblProximoClick(Sender: TObject);
begin
  pgcFicha.ActivePage := tbsCadastro;

  inherited;
end;

procedure TFrmEstoque.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  chkMarketplace.Enabled              := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memTags.Enabled                     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnPrecoTodos.Enabled               := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnPreco.Enabled                    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnPrecoIgual.Enabled               := not(bEstaSendoUsado) and not (bSomenteLeitura);
  framePesquisaProdComposicao.Enabled := not(bEstaSendoUsado) and not (bSomenteLeitura);

  if bSomenteLeitura then
    tbsPreco.TabVisible := False;

  //Tags
  StringGrid2.EditorMode := not(bSomenteLeitura);
  if bSomenteLeitura then
    StringGrid2.Options := StringGrid2.Options - [goEditing]
  else
    StringGrid2.Options := StringGrid2.Options + [goEditing];

  //Grade
  StringGrid1.EditorMode := not(bSomenteLeitura);
  if bSomenteLeitura then
    StringGrid1.Options := StringGrid1.Options - [goEditing]
  else
    StringGrid1.Options := StringGrid1.Options + [goEditing];

  //Composição
  if bSomenteLeitura then
    dbgComposicao.Options := dbgComposicao.Options - [dgEditing]
  else
    dbgComposicao.Options := dbgComposicao.Options + [dgEditing];
end;


procedure TFrmEstoque.SMALL_DBEdit31Change(Sender: TObject);
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select * from IBPT_ where char_length(CODIGO) >= 8 and CODIGO='+QuotedStr(Form7.ibDataSet4CF.AsString));
  Form1.ibQuery1.Open;

  if Form1.ibQuery1.FieldByName('DESCRICAO').AsString <> '' then
  begin
    LabelDescricaoNCM.Caption := Copy(Form1.ibQuery1.FieldByName('DESCRICAO').AsString+Replicate(' ',50),1,50);
  end else
  begin
    LabelDescricaoNCM.Caption := 'Código NCM não cadastrado na tabela do IBPT';
  end;

  Form1.ibQuery1.Close;
end;

procedure TFrmEstoque.SMALL_DBEdit32Exit(Sender: TObject);
var
  CustoDeAquisicao : Real;
  PercentualCalcul : Real;
  PrecoDeVenda : Real;
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
      CustoDeAquisicao := Form7.ibDataSet4CUSTOCOMPR.AsFloat - ( rCusto * (Form7.ibDataSet13ICME.AsFloat / 100));

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
      MensagemSistema('Não foi possível efetuar o calculo. Verifique os percentuais usados.'+Chr(10)+'Ou calcule manualmente o preço deste produto.',msgAtencao);
    end;
  except
  end;
end;

procedure TFrmEstoque.SMALL_DBEdit32KeyDown(Sender: TObject; var Key: Word;
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

procedure TFrmEstoque.SMALL_DBEdit38Exit(Sender: TObject);
begin
  CarregaCit;
end;

procedure TFrmEstoque.SMALL_DBEdit64Change(Sender: TObject);
begin
  Exemplo(True);
end;

procedure TFrmEstoque.SMALL_DBEdit64Exit(Sender: TObject);
begin
  if Form7.IbDataSet4FATORC.AsFloat = 0 then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset4.Edit;
    Form7.ibDataSet4FATORC.AsFloat := 1;
  end;
  Exemplo(True);
end;

procedure TFrmEstoque.SMALL_DBEditYExit(Sender: TObject);
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

procedure TFrmEstoque.StringGrid1Click(Sender: TObject);
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

procedure TFrmEstoque.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rQtd : Real;
  I, J : Integer;
begin
  rQtd := 0;

  for I := 0 to 19 do
    for J := 0 to 19 do
      if AllTrim(StringGrid1.Cells[I,J]) <> '' then
        try
          if (I <> 0) and (J <> 0) then
            rQtd := rQtd + StrToFloat(AllTrim(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[I,J])));
        except
          StringGrid1.Cells[I,J] := '0,00'
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
    StringGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2, StringGrid1.Cells[aCol,aRow])
  else
    StringGrid1.Canvas.TextOut(Rect.Right - StringGrid1.Canvas.TextWidth(StringGrid1.Cells[aCol,aRow]) -2 ,Rect.Top+2,  StringGrid1.Cells[aCol,aRow]);
end;

procedure TFrmEstoque.StringGrid1KeyPress(Sender: TObject; var Key: Char);
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
  except
  end;
end;

procedure TFrmEstoque.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (StringGrid1.Col = 0) and (StringGrid1.Row = 0) then
    StringGrid1.Row := 1;
end;

procedure TFrmEstoque.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ACol > 1) and not (gdSelected in State) and (ARow > 0) then
  begin
    {Dailon Parisotto (f-7704) 2023-12-26 INICIO}
    StringGrid2.Canvas.Brush.Color  := clBtnFace;
    StringGrid2.Canvas.Font.Color  := clBlack;
    {Dailon Parisotto (f-7704) 2023-12-26 FIM}
    StringGrid2.Canvas.FillRect(Rect);
    StringGrid2.Canvas.TextOut(Rect.Left+2, Rect.Top+2, StringGrid2.Cells[Acol,Arow]);
  end;
end;

procedure TFrmEstoque.StringGrid2SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if StringGrid2.EditorMode then
  begin
    if ACol = 1 then
      StringGrid2.Options := StringGrid1.Options + [goEditing]
    else
      StringGrid2.Options := StringGrid1.Options - [goEditing];
  end;
end;

procedure TFrmEstoque.tbsCodBarrasEnter(Sender: TObject);
begin
  Form7.IBDataSet6.Close;
  Form7.IBDataSet6.SelectSQL.Clear;
  Form7.IBDataSet6.SelectSQL.Add('select * from CODEBAR where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
  Form7.IBDataSet6.Open;
end;

procedure TFrmEstoque.tbsComposicaoShow(Sender: TObject);
var
  sCodigo : STring;
  fCusto  : Real;
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
  except
  end;

  Form7.ibDataSet28.EnableControls;
end;

procedure TFrmEstoque.tbsConversaoEnter(Sender: TObject);
var
  I : Integer;
begin
  ComboBox12.Items.Clear;
  ComboBox13.Items.Clear;

  Form7.IBDataSet49.Close;
  Form7.IBDataSet49.SelectSQL.Text := ' Select * '+
                                      ' From MEDIDA '+
                                      ' Order by SIGLA';
  Form7.IBDataSet49.Open;

  while not Form7.IBDataSet49.Eof do
  begin
    ComboBox12.Items.Add(Form7.IBDataSet49SIGLA.AsString);
    ComboBox13.Items.Add(Form7.IBDataSet49SIGLA.AsString);
    Form7.IBDataSet49.Next;
  end;

  if AllTrim(Form7.IbDataSet4MEDIDAE.AsString) = '' then
  begin
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then Form7.ibDataset4.Edit;
    if AllTrim(Form7.IbDataSet4MEDIDA.AsString) <> '' then Form7.ibDataSet4MEDIDAE.AsString := Form7.ibDataSet4MEDIDA.AsString else
    begin
      Form7.ibDataSet4MEDIDAE.AsString := 'UND';
      Form7.ibDataSet4MEDIDA.AsString  := 'UND';
    end;
  end;

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

procedure TFrmEstoque.tbsFotoShow(Sender: TObject);
begin
  // Nome certo da imagem
  sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet4REGISTRO.AsString+'.jpg';

  Button13.Caption       := '&Webcam';
  VideoCap1.visible      := False;
  Image5.Visible         := True;
//  AtualizaTela(False);
//  if not Form7.bSoLeitura then
//  begin
//    Orelhas.ActivePage := orelha_cadastro;
//    if dbgComposicao.CanFocus then dbgComposicao.SetFocus;
//  end;
end;

procedure TFrmEstoque.tbsGradeShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
  I, J : Integer;
  bChave : Boolean;
begin
  StringGrid1.Col := 0;
  StringGrid1.Row := 0;

  begin
    StringGrid1.RowCount := 20;

    StringGrid1.Col := 1;
    StringGrid1.Row := 1;

    for I := 0 to 19 do
     for J := 0 to 19 do
       StringGrid1.Cells[I,J] := '';

    FrmEstoque.Caption := form7.ibDataSet4DESCRICAO.AsString;
    StringGrid1.Repaint;

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
          StringGrid1.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
          bChave := False;
        end;
      end;
      Form7.ibDataSet10.Next;
    end;

    if bChave then
    begin
      // Lê os dados a partir de um .ini
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      for I := 1 to 19 do StringGrid1.Cells[0,I] := Mais1Ini.ReadString('Grade',pChar('X'+StrZero(I,2,0)),'');
      for I := 1 to 19 do StringGrid1.Cells[I,0] := Mais1Ini.ReadString('Grade',pChar('Y'+StrZero(I,2,0)),'');
      Mais1ini.Free;
    end;
  end;
end;

procedure TFrmEstoque.tbsICMSShow(Sender: TObject);
begin
  if fraPerfilTrib.txtCampo.CanFocus then
    fraPerfilTrib.txtCampo.SetFocus;

  CarregaValoresObjeto;
end;

procedure TFrmEstoque.tbsIPIEnter(Sender: TObject);
begin
  if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset4.Edit;
end;

procedure TFrmEstoque.tbsIPIShow(Sender: TObject);
begin
  CarregaValoresObjeto;
end;

procedure TFrmEstoque.tbsPrecoShow(Sender: TObject);
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
  except
  end;

  // Procura no arquivo de compras o custo da última compra
  Form7.ibQuery14.DisableControls;
  Form7.ibQuery14.Close;
  Form7.ibQuery14.SQL.Clear;
  Form7.ibQuery14.SQL.Add('select * from ITENS002 where DESCRICAO='+QuotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' order by REGISTRO');
  Form7.ibQuery14.Open;
  Form7.ibQuery14.Last;

  Form7.ibDataSet13ICME.AsFloat := Form7.ibQuery14.FieldByname('ICM').AsFloat;
  rCusto := Form7.ibQuery14.FieldByname('UNITARIO').AsFloat;

  if rCusto = 0 then rCusto := Form7.ibDataSet4CUSTOCOMPR.AsFloat;

  Label58.Caption :=   '+R$ '+Format('%9.2n',[rCusto]);
  Label60.Caption :=  '+R$ '+Format('%9.2n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat - rCusto]);

  Edit15.Text := '=R$ '+Format('%9.2n',[Form7.ibDataSet4CUSTOCOMPR.AsFloat]);

  SMALL_DBEdit32Exit(Sender);
end;

procedure TFrmEstoque.tbsSerialShow(Sender: TObject);
begin
  if chkControlaSerial.CanFocus then
    chkControlaSerial.SetFocus;

  if Form7.bSoLeitura or Form7.bEstaSendoUsado then
  begin
    dbgSerial.ReadOnly          := True;
    chkControlaSerial.Enabled   := False;
  end else
  begin
    dbgSerial.ReadOnly          := False;
    chkControlaSerial.Enabled   := True;
  end;


  if (FrmEstoque.Caption <> Form7.ibDataSet4DESCRICAO.AsString) or (AllTrim(form7.ibDataSet4DESCRICAO.AsString) = '')  then
  begin
    FrmEstoque.Caption := Form7.ibDataSet4DESCRICAO.AsString;
  end;

  if Form7.ibDataSet4.FieldByname('SERIE').Value = 1 then
  begin
    chkControlaSerial.Checked    := True;
    Form7.ibDataSet30.Active     := False;
    Form7.ibDataSet30.Active     := True;
    dbgSerial.Enabled            := True;
    btnHistoricoItemSer.Enabled  := True;
    btnHistoricoSer.Enabled      := True;
    btnProcurarSer.Enabled       := True;
    edtTitulo1.Enabled           := True;
    edtTitulo2.Enabled           := True;
    edtTitulo3.Enabled           := True;
    edtTitulo4.Enabled           := True;
    edtTitulo5.Enabled           := True;
    edtTitulo6.Enabled           := True;
    edtTitulo7.Enabled           := True;
  end else
  begin
    chkControlaSerial.Checked    := False;
    Form7.ibDataSet30.Active     := False;
    Form7.ibDataSet30.Active     := True;
    dbgSerial.Enabled            := False;
    btnHistoricoItemSer.Enabled  := False;
    btnHistoricoSer.Enabled      := False;
    btnProcurarSer.Enabled       := False;
    edtTitulo1.Enabled           := False;
    edtTitulo2.Enabled           := False;
    edtTitulo3.Enabled           := False;
    edtTitulo4.Enabled           := False;
    edtTitulo5.Enabled           := False;
    edtTitulo6.Enabled           := False;
    edtTitulo7.Enabled           := False;
  end;

  Form7.ibDataSet30.Last;
end;

procedure TFrmEstoque.tbsTagsExit(Sender: TObject);
const
  _cCamposObs = ';OBS1;OBS2;OBS3;OBS4;OBS5;OBS6;OBS7;OBS8;OBS9;';
var
  I : Integer;
  sEx : String;
  cValor: String;
begin
  for I := 1 to 100 do
  begin
    if (AllTrim(StringGrid2.Cells[0,I])<>'') and (AllTrim(StringGrid2.Cells[1,I])<>'') then
    begin
      cValor := AllTrim(StringGrid2.Cells[1,I]);

      if Pos(';' + AnsiUpperCase(Copy(AllTrim(StringGrid2.Cells[0,I]),1,4)) + ';', _cCamposObs) > 0 then
        cValor := Copy(cValor, 1, Form7.ibDataSet4DESCRICAO.Size);

      sEx := sEx + '<'+AllTrim(StringGrid2.Cells[0,I])+'>'+cValor+'</'+AllTrim(StringGrid2.Cells[0,I])+'>'+chr(10);
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

procedure TFrmEstoque.tbsTagsShow(Sender: TObject);
var
  I : Integer;
  sEx, sTag, sValor, sExemplo, sDescricao : String;
begin
  StringGrid2.ColWidths[0] := 150;
  StringGrid2.ColWidths[1] := 150;
  StringGrid2.ColWidths[2] := 150;
  StringGrid2.ColWidths[3] := 670;

  Memo1.Width   := 800;
  memTags.Width := 1000;

  sEx := '';

  for I := 0 to memTags.Lines.Count + 1 do
  begin
    if pos('<',memTags.Lines.Strings[I]) <> 0 then
    begin
      sEx := sEx + StringReplace(memTags.Lines.Strings[I], #$D#$A, '', [rfReplaceAll])+chr(10);
    end;
  end;

  Memo1.Lines.Clear;

  Memo1.Lines.Add('<Tributavel>0 "Situações tributárias obtidas na prefeitura"</Tributavel>');
  Memo1.Lines.Add('<CodigoTributacaoMunicipio>000 "Código do item da lista de serviço. Obtido na prefeitura"</CodigoTributacaoMunicipio>');
  Memo1.Lines.Add('<cServico>000 "Código do serviço prestado dentro do município. Obtido na prefeitura"</cServico>');
  Memo1.Lines.Add('<cListServ>14.01 "Item da lista de serviços; Padrão ABRASF"</cListServ>');

  Memo1.Lines.Add('<AliquotaPIS>0,00 "Aliquota PIS para emissão de NFS-e"   </AliquotaPIS>');
  Memo1.Lines.Add('<AliquotaCOFINS>0,00 "Aliquota COFINS para emissão de NFS-e"</AliquotaCOFINS>');
  Memo1.Lines.Add('<AliquotaINSS>0,00 "Aliquota INSS para emissão de NFS-e (Ex: 100*35%*11%=3,85)"  </AliquotaINSS>');
  Memo1.Lines.Add('<AliquotaIR>0,00 "Aliquota IR para emissão de NFS-e"    </AliquotaIR>');
  Memo1.Lines.Add('<AliquotaCSLL>0,00 "Aliquota CSLL para emissão de NFS-e"  </AliquotaCSLL>');

  Memo1.Lines.Add('<cProdANVISA>0000000000000 "Código de Produto da ANVISA"</cProdANVISA>');
  Memo1.Lines.Add('<xMotivoIsencao>"Motivo da isenção da ANVISA"</xMotivoIsencao>');

  // Informar os campos de rastreabilidade na emissão de NF-e
  Memo1.Lines.Add('<rastro>Sim"Informar grupo Rastreamento de Produto"</rastro>');

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
  Memo1.Lines.Add('<Obs1>Observação 1 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS1>');
  Memo1.Lines.Add('<Obs2>Observação 2 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS2>');
  Memo1.Lines.Add('<Obs3>Observação 3 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS3>');
  Memo1.Lines.Add('<Obs4>Observação 4 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS4>');
  Memo1.Lines.Add('<Obs5>Observação 5 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS5>');
  Memo1.Lines.Add('<Obs6>Observação 6 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS6>');
  Memo1.Lines.Add('<Obs7>Observação 7 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS7>');
  Memo1.Lines.Add('<Obs8>Observação 8 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS8>');
  Memo1.Lines.Add('<Obs9>Observação 9 "Esta observação será mostrada no corpo da NF'+RetornarDescrCaracTagsObs+'"</OBS9>');

  // JA. Detalhamento Específico de Veículos Novos
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

  StringGrid2.Cells[0,0] := 'Nome';
  StringGrid2.Cells[1,0] := 'Valor';
  StringGrid2.Cells[2,0] := 'Exemplo';
  StringGrid2.Cells[3,0] := 'Descrição';

  //Ajustar a quantidade de linhas no grid ao número de linhas a serem preenchidas com as tags
  if StringGrid2.RowCount <= Memo1.Lines.Count + 1 then
    StringGrid2.RowCount := Memo1.Lines.Count + 1;


  for I := 0 to Memo1.Lines.Count + 1 do
  begin
    sTag       := AllTrim(Copy(Memo1.Lines.Strings[I],(pos('<',Memo1.Lines.Strings[I])+1), (pos('>',Memo1.Lines.Strings[I])-(pos('<',Memo1.Lines.Strings[I])+1))));
    sExemplo   := AllTrim(Copy(Memo1.Lines.Strings[I],Pos('<' + sTag + '>', Memo1.Lines.Strings[I]) + Length('<' + sTag + '>'),(Pos('</', Memo1.Lines.Strings[I])-(Pos('<' + sTag + '>', Memo1.Lines.Strings[I])+Length('<' + sTag + '>')))));

    if Pos('"',sExemplo) <> 0 then
    begin
      sDescricao := AllTrim(Copy(sExemplo+Replicate(' ',200),Pos('"',sExemplo),200));
      sExemplo   := StrTran(sExemplo,sDescricao,'');
      sDescricao := StrTran(sDescricao,'"','');
    end else
    begin
      sDescricao := '';
    end;

    if Pos('<' + sTag + '>', sEx)<> 0 then
    begin
      sValor := RetornaValorDaTagNoCampo(sTag,sEx);
      sEx := StrTran(sEx,'<'+sTag+'>'+sValor+'</'+sTag+'>','');
    end else
    begin
      sValor   := '';
    end;

    StringGrid2.Cells[0,I+1] := sTag;
    StringGrid2.Cells[1,I+1] := sValor;
    StringGrid2.Cells[2,I+1] := sExemplo;
    StringGrid2.Cells[3,I+1] := sDescricao;
  end;
end;

procedure TFrmEstoque.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  FrmEstoque.Tag := FrmEstoque.Tag + 1;
end;

procedure TFrmEstoque.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  FrmEstoque.Tag := 33;
end;

procedure TFrmEstoque._RRClick(Sender: TObject);
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

    if SMALL_DBEDITY.CanFocus then
    begin
      SMALL_DBEDITY.SetFocus;
    end;
  end;
end;

procedure TFrmEstoque.AtualizaObjComValorDoBanco;
var
  i : integer;
begin
  //Se não estiver ativo não carrega informações
  if not FormularioAtivo(Self) then
    Exit;

  Self.Caption := form7.ibDataSet4DESCRICAO.AsString;

  //Marketplace
  if Form7.ibDataSet4MARKETPLACE.AsString = '1' then
    chkMarketplace.Checked := True
  else
    chkMarketplace.Checked := False;

  //Grupo
  try
    fraGrupo.TipoDePesquisa               := tpLocate;
    fraGrupo.GravarSomenteTextoEncontrato := True;
    fraGrupo.CampoVazioAbrirGridPesquisa  := True;
    fraGrupo.CampoCodigo                  := Form7.ibDataSet4NOME;
    fraGrupo.CampoCodigoPesquisa          := 'NOME';
    fraGrupo.sCampoDescricao              := 'NOME';
    fraGrupo.sTabela                      := 'GRUPO';
    fraGrupo.CarregaDescricao;
  except
  end;

  //Unidade
  try
    fraUndMed.TipoDePesquisa               := tpLocate;
    fraUndMed.GravarSomenteTextoEncontrato := True;
    fraUndMed.CampoVazioAbrirGridPesquisa  := True;
    fraUndMed.CampoCodigo                  := Form7.ibDataSet4MEDIDA;
    fraUndMed.CampoCodigoPesquisa          := 'SIGLA';
    fraUndMed.sCampoDescricao              := 'SIGLA';
    fraUndMed.sTabela                      := 'MEDIDA';
    fraUndMed.CampoAuxExiber               := ',DESCRICAO';
    fraUndMed.CarregaDescricao;
  except
  end;

  //Perfil trib
  try
    fraPerfilTrib.TipoDePesquisa  := tpLocate; //Mauricio Parizotto 2023-10-31
    fraPerfilTrib.GravarSomenteTextoEncontrato := True;
    fraPerfilTrib.CampoCodigo     := Form7.ibDataSet4IDPERFILTRIBUTACAO;
    fraPerfilTrib.sCampoDescricao := 'DESCRICAO';
    fraPerfilTrib.sTabela         := 'PERFILTRIBUTACAO';
    fraPerfilTrib.CarregaDescricao;
  except
  end;

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

  // 1 - Simples nacional 2 - Simples Nacional excesso 3 - Regime normal
  begin
    CarregaCit;
  end;

  if Form7.ibDataSet13CRT.AsString = '1' then
  begin
    Label36.Visible          := True;
    cboCSOSN_Prod.Visible           := True;
    Label37.Visible          := False;
    cboCST_Prod.Visible             := False;

    Label72.Visible          := True;
    ComboBox15.Visible       := True;
    Label84.Visible          := False;
    ComboBox14.Visible       := False;
  end else
  begin
    Label36.Visible          := False;
    cboCSOSN_Prod.Visible           := False;
    Label37.Visible          := True;
    cboCST_Prod.Visible             := True;

    Label72.Visible          := False;
    ComboBox15.Visible       := False;
    Label84.Visible          := True;
    ComboBox14.Visible       := True;
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

  Form7.ibDataSet4.Edit;
  // P - Produção própria
  // T - Produção por terceiros
  for I := 0 to ComboBox5.Items.Count -1 do
  begin
    if Copy(ComboBox5.Items[I],1,1) = UpperCase(AllTrim(Form7.ibDataSet4IPPT.AsString)) then
    begin
      ComboBox5.ItemIndex := I;
      Break; // Sandro Silva 2024-01-15
    end;
  end;

  // A - Arredondamento
  // T - Truncamento
  for I := 0 to ComboBox6.Items.Count -1 do
  begin
    if Copy(ComboBox6.Items[I],1,1) = UpperCase(AllTrim(Form7.ibDataSet4IAT.AsString)) then
    begin
      ComboBox6.ItemIndex := I;
      Break; // Sandro Silva 2024-01-15
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
  if AllTrim(Form7.ibDataSet4CSOSN.AsString)<>'' then
  begin
    for I := 0 to cboCSOSN_Prod.Items.Count -1 do
    begin
      // Com a inclusão do valor 61 - Tributação monofásica sobre combustíveis cobrado anteriormente nos CSOSN precisa mudar aqui onde seleciona o valor do combo
      if Trim(Form7.ibDataSet4CSOSN.AsString) <> '' then
      begin
        if Copy(cboCSOSN_Prod.Items[I],1, Length(Trim(Form7.ibDataSet4CSOSN.AsString))) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN.AsString)) then
        begin
          cboCSOSN_Prod.ItemIndex := I;
          Break; // Sandro Silva 2024-01-15
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
  if AllTrim(Form7.ibDataSet4CSOSN_NFCE.AsString)<>'' then
  begin
    for I := 0 to ComboBox15.Items.Count -1 do
    begin
      // Com a inclusão do valor 61 - Tributação monofásica sobre combustíveis cobrado anteriormente nos CSOSN precisa mudar aqui onde seleciona o valor do combo
      if Trim(Form7.ibDataSet4CSOSN_NFCE.AsString) <> '' then
      begin
        if Copy(ComboBox15.Items[I],1,Length(Trim(Form7.ibDataSet4CSOSN_NFCE.AsString))) = UpperCase(AllTrim(Form7.ibDataSet4CSOSN_NFCE.AsString)) then
        begin
          ComboBox15.ItemIndex := I;
          Break; // Sandro Silva 2024-01-15
        end;
      end;
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
      if Copy(cboOrigemProd.Items[I],1,1) = Copy(Form7.ibDataSet4CST.AsString+'000',1,1) then
      begin
        cboOrigemProd.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
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
      if Copy(cboCST_Prod.Items[I],1,2) = Copy(Form7.ibDataSet4CST.AsString+'000',2,2) then
      begin
        cboCST_Prod.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
      end;
    end;
  end;

  if AllTrim(Form7.ibDataSet4CST_NFCE.AsString)<>'' then
  begin
    for I := 0 to ComboBox14.Items.Count -1 do
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
      if Copy(ComboBox14.Items[I],1,2) = Copy(Form7.ibDataSet4CST_NFCE.AsString+'000',2,2) then
      begin
        ComboBox14.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
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
    for I := 0 to ComboBox1.Items.Count -1 do
    begin
      if Copy(ComboBox1.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_IPI.AsString)) then
      begin
        ComboBox1.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
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
    for I := 0 to ComboBox7.Items.Count -1 do
    begin
      if Copy(ComboBox7.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString)) then
      begin
        ComboBox7.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
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
  if AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString)<>'' then
  begin
    for I := 0 to ComboBox10.Items.Count -1 do
    begin
      if Copy(ComboBox10.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString)) then
      begin
        ComboBox10.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
      end;
    end;
  end;

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
  if AllTrim(Form7.ibDataSet4TIPO_ITEM.AsString)<>'' then
  begin
    for I := 0 to ComboBox9.Items.Count -1 do
    begin
      if Copy(ComboBox9.Items[I],1,2) = UpperCase(AllTrim(Form7.ibDataSet4TIPO_ITEM.AsString)) then
      begin
        ComboBox9.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
      end;
    end;
  end;
           {
  if Form7.StatusTrocaPerfil <> 'PR' then //Mauricio Parizotto 2024-01-15
    if fraPerfilTrib.txtCampo.CanFocus then
      fraPerfilTrib.txtCampo.SetFocus;
           }

  if SMALL_DBEDITY.CanFocus then
    SMALL_DBEDITY.SetFocus;

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
    for I := 0 to ComboBox11.Items.Count -1 do
    begin
      if Copy(ComboBox11.Items[I],1,4) = UpperCase(AllTrim(Form7.ibDataSet4CFOP.AsString)) then
      begin
        ComboBox11.ItemIndex := I;
        Break; // Sandro Silva 2024-01-15
      end;
    end;
  end;


  GravaImagemEstoque;
end;



procedure TFrmEstoque.btnPrecoTodosClick(Sender: TObject);
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
      tbsPrecoShow(Sender);
      btnPrecoClick(Sender);
      Form7.ibDataSet4.Next;
    end;
  end;
end;

procedure TFrmEstoque.Button10Click(Sender: TObject);
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
    end else
      MensagemSistema('Não é possível desmontar essa quantidade.',msgAtencao);
  end;
end;

procedure TFrmEstoque.Button11Click(Sender: TObject);
begin
  lblVisualizarClick(Sender);
end;

procedure TFrmEstoque.Button13Click(Sender: TObject);
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
      jp.Assign(Image5.Picture.Bitmap);
      jp.CompressionQuality := 100;

      jp.SaveToFile(sNomeDoJPG);

      Button13.Caption     := '&Webcam';
      Image5.Visible       := True;

      while not FileExists(pChar(sNomeDoJPG)) do
      begin
        Sleep(100);
      end;

      Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
      Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

//      AtualizaTela(True);
      CarregaValoresObjeto;
    except end;
  end;
end;

procedure TFrmEstoque.btnHistoricoItemSerClick(Sender: TObject);
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

procedure TFrmEstoque.btnHistoricoSerClick(Sender: TObject);
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

procedure TFrmEstoque.btnProcurarSerClick(Sender: TObject);
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
    if (AllTrim(Form7.ibDataSet30SERIAL.AsString) <> AllTrim(sSerial)) then
      MensagemSistema('Não encontrado.');
  end;

  if dbgSerial.CanFocus then
    dbgSerial.SetFocus;
end;

procedure TFrmEstoque.Button1Click(Sender: TObject);
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
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('X'+StrZero(I,2,0)),StringGrid1.Cells[0,I]);
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('Y'+StrZero(I,2,0)),StringGrid1.Cells[I,0]);
      Mais1ini.Free;
    end;
  end;
end;

procedure TFrmEstoque.Button22Click(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  CHDir(Form1.sAtual);

  if FileExists(OpenPictureDialog1.FileName) then
  begin
    Screen.Cursor             := crHourGlass;              // Cursor de Aguardo

    while FileExists(pChar(sNomeDoJPG)) do
    begin
      DeleteFile(pChar(sNomeDoJPG));
    end;

    CopyFile(pChar(OpenPictureDialog1.FileName),pChar(sNomeDoJPG),True);

    while not FileExists(pChar(sNomeDoJPG)) do
    begin
      Sleep(100);
    end;

    Screen.Cursor             := crDefault;              // Cursor de Aguardo

    Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
    Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

//    AtualizaTela(True);
    CarregaValoresObjeto;
  end;
end;

procedure TFrmEstoque.Button2Click(Sender: TObject);
begin
  tbsGradeShow(Sender);
  FrmEstoque.Repaint;
end;

procedure TFrmEstoque.Button3Click(Sender: TObject);
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
        if AllTrim(StringGrid1.Cells[I,J]) <> '' then
          if (I <> 0) and (J <> 0) then rQtd := rQtd + StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[I,J]));

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
            if (AllTrim(StringGrid1.Cells[I,0]) <> '') and (AllTrim(StringGrid1.Cells[0,J]) <> '') and (StringGrid1.Cells[I,J] = '') then StringGrid1.Cells[I,J] := '0,00';

            if AllTrim(StringGrid1.Cells[I,J]) <> '' then
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
                  Form7.ibDataSet10QTD.AsString  := StringGrid1.Cells[I,J];
                  Form7.ibDataSet10.Post;
                end else
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString  := LimpaNumeroDeixandoAVirgula(Format('%12.'+Form1.ConfCasas+'n',[(StrToFloat(LimpaNumeroDeixandoAvirgula(StringGrid1.Cells[I,J])))]));
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
                  Form7.ibDataSet10QTD.AsString  := StringGrid1.Cells[I,J];
                  Form7.ibDataSet10.Post;
                end else
                begin
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10QTD.AsString := LimpaNumeroDeixandoAVirgula(Format('%12.'+Form1.ConfCasas+'n',[(StrToFloat(LimpaNumeroDeixandoAvirgula(StringGrid1.Cells[I,J])))]));
                  Form7.ibDataSet10.Post;
                  Form7.ibDataSet10.Edit;
                  Form7.ibDataSet10ENTRADAS.AsString := Form7.ibDataSet10QTD.AsString;
                  Form7.ibDataSet10.Post;
                end;
              end;
            end;
          end;
        end;

        pgcFicha.ActivePage := tbsCadastro;
      end else
      begin
        try
          MensagemSistema('Diferença: '+Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet4QTD_ATUAL.AsFloat - rQtd])+chr(10)+chr(10)+'Acerte a quantidade.',msgAtencao);
          Abort;
        except
        end;
      end;

      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('X'+StrZero(I,2,0)),StringGrid1.Cells[0,I]);
      for I := 1 to 19 do Mais1Ini.WriteString('Grade',pChar('Y'+StrZero(I,2,0)),StringGrid1.Cells[I,0]);
      Mais1ini.Free;
    end else
    begin
      pgcFicha.ActivePage := tbsCadastro;
    end;

    if (AllTrim(StringGrid1.Cells[0,1]) = '') and (AllTrim(StringGrid1.Cells[1,0]) = '') then
    begin
      Form7.ibDataSet10.Close;
      Form7.ibDataSet10.SelectSQL.Clear;
      Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by CODIGO, COR, TAMANHO');
      Form7.ibDataSet10.Open;
      Form7.ibDataSet10.First;
      while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (not Form7.ibDataSet10.EOF) do
        if Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then Form7.ibDataSet10.Delete else Form7.ibDataSet10.Next;
    end;
  except
  end;

  Screen.Cursor             := crDefault;
end;

procedure TFrmEstoque.Button7Click(Sender: TObject);
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
  FotoOld := Form7.ibDataset4FOTO.AsString; // Mauricio Parizotto 2024-01-26

  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo

  Image5.Picture.SaveToFile('res'+Form7.IBDataSet4REGISTRO.AsString+'.jpg');

  try
    begin
      begin
        FrmEstoque.Tag       := 0;
        if (Length(Limpanumero(Form7.ibDataSet4REFERENCIA.AsString)) >= 12) and (Copy(Form7.ibDataSet4REFERENCIA.AsString,1,1)<>'2') then
        begin
          WebBrowser1.Navigate(pChar('http://www.google.com/search?um=1&hl=pt-BR&biw=1920&bih=955&q='+Form7.ibDataSet4REFERENCIA.AsString+'&ie=UTF-8&tbm=isch&source=og&sa=N&tab=wi'));
        end else
        begin
          vDescricaoBusca := UTF8Encode(Form7.ibDataSet4DESCRICAO.AsString);

          WebBrowser1.Navigate(pChar('http://www.google.com/search?um=1&hl=pt-BR&biw=1920&bih=955&q='+vDescricaoBusca+'&ie=UTF-8&tbm=isch&source=og&sa=N&tab=wi'));
        end;

        while (FrmEstoque.Tag < 33) do
        begin
          Application.ProcessMessages;
          sleep(100);
        end;

        for I := 1 to 50 do
        begin
          Application.ProcessMessages;
          if FrmEstoque.Tag < 35 then
            sleep(100);
        end;



        Screen.Cursor             := crDefault;              // Cursor de Aguardo

        documentoAtivo := WebBrowser1.Document;
        s := documentoAtivo.Body.OuterHTML;

        // Adicionando o código HTML ao MEMO

        try
          Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
          J := 0;

          for iSrc := 0 to WebBrowser1.OleObject.Document.Images.Length - 1 do
          begin
            sLinkDaFoto := WebBrowser1.OleObject.Document.Images.Item(iSrc).Src;
            if (sLinkDaFoto <> '') then
            begin
              try
                // Faz o download dA Imagem sLinkDaFoto e salva no 'c:\tempo.jpg'
                  DownloadArquivoImg(PChar(sLinkDaFoto), PChar(sNomeDoJPG));
                  if FileExists(sNomeDoJPG) then
                  begin
//                    if AtualizaTela(True) then
                    if CarregaValoresObjeto then
                    begin
                      if Form7.ibDataset4FOTO.BlobSize <> 0 then
                      begin
                        J := J + 1;
                        if J >= 7 then
                        begin
                          if VarIsNull(Form7.ibDataset4FOTO.OldValue) then
                            Form7.ibDataset4FOTO.Clear
                          else
                            Form7.ibDataset4FOTO.Value := FotoOld; //Usando variavel pois valor do OldValue não estava correto

                            CarregaValoresObjeto;
//                          AtualizaTela(True);
                          Break;
                        end else
                        begin
                          I := Application.MessageBox(Pchar('Quer usar esta foto para este produto?'), Pchar('Sugestão ' + IntToStr(J) + ' de 6'), MB_YESNOCANCEL + mb_DefButton2 + MB_ICONQUESTION);
                          if (I = IDYES) then
                          begin
                            DeleteFile(pChar('res' + Form7.IBDataSet4REGISTRO.AsString + '.jpg'));
                            //s := '';
                            Break;
                          end;

                          if I = IDCANCEL then
                          begin
                            if VarIsNull(Form7.ibDataset4FOTO.OldValue) then
                              Form7.ibDataset4FOTO.Clear
                            else
                              Form7.ibDataset4FOTO.Value := FotoOld; //Usando variavel pois valor do OldValue não estava correto

//                            AtualizaTela(True);
                              CarregaValoresObjeto;
                            Break;
                          end;
                        end;
                      end;
                    end;
                  end;
              except
                MensagemSistema('Download falhou!!!',msgErro);
              end;
            end;
          end;

          Screen.Cursor             := crDefault;              // Cursor de Aguardo
        except
        end;
      end;
    end;
  except
  end;

  Screen.Cursor             := crDefault;              // Cursor de Aguardo
end;

procedure TFrmEstoque.Button8Click(Sender: TObject);
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
      MensagemSistema('Não é possível fabricar essa quantidade.',msgAtencao);
  end;
end;

procedure TFrmEstoque.chkControlaSerialClick(Sender: TObject);
begin
  if Form7.ibDataSet30.Modified then
  begin
    Form7.ibDataSet30.Edit;
    Form7.ibDataSet30.Post;
  end;

  if chkControlaSerial.Checked then
  begin
    dbgSerial.Enabled            := True;
    btnHistoricoItemSer.Enabled  := True;
    btnHistoricoSer.Enabled      := True;
    btnProcurarSer.Enabled       := True;
    edtTitulo1.Enabled           := True;
    edtTitulo2.Enabled           := True;
    edtTitulo3.Enabled           := True;
    edtTitulo4.Enabled           := True;
    edtTitulo5.Enabled           := True;
    edtTitulo6.Enabled           := True;
    edtTitulo7.Enabled           := True;
  end else
  begin
    dbgSerial.Enabled            := False;
    btnHistoricoItemSer.Enabled  := False;
    btnHistoricoSer.Enabled      := False;
    btnProcurarSer.Enabled       := False;
    edtTitulo1.Enabled           := False;
    edtTitulo2.Enabled           := False;
    edtTitulo3.Enabled           := False;
    edtTitulo4.Enabled           := False;
    edtTitulo5.Enabled           := False;
    edtTitulo6.Enabled           := False;
    edtTitulo7.Enabled           := False;
  end;
end;

procedure TFrmEstoque.chkControlaSerialExit(Sender: TObject);
begin
  Form7.ibDataSet4.Edit;
  if chkControlaSerial.Checked then
  begin
    Form7.ibDataSet4.FieldByname('SERIE').Value := 1;
  end else
  begin
    Form7.ibDataSet4.FieldByname('SERIE').Value := 0;
  end;
  Form7.ibDataSet4.Post;
end;

procedure TFrmEstoque.btnPrecoIgualClick(Sender: TObject);
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

    MensagemSistema('O sistema calculou o "custo operacional" da'+Chr(10)+
                  'seguinte forma:'+Chr(10)+Chr(10)+

                  'Analisando no plano de contas'+Chr(10)+Chr(10)+
                  '11??? - Receitas'+Chr(10)+
                  '32??? - Despesas Operacionais'+Chr(10)+Chr(10)+

                  'Custo Operacional = Despesas Operacionais * 100 / Receitas'+Chr(10)+Chr(10)+
                  'Custo Operacional = '+AllTrim(Format('%12.2n',[rDespesas]))+' * 100 / '+AllTrim(Format('%12.2n',[rReceitas]))+Chr(10)+Chr(10)+
                  'Custo Operacional = '+AllTrim(Format('%12.2n',[dCOPE]))+'%'+Chr(10)+Chr(10)
                  ,msgAtencao);

  except
    MensagemSistema('O sistema calcula o "custo operacional" da'+Chr(10)+
                'seguinte forma:'+Chr(10)+Chr(10)+

                'Analisando no plano de contas'+Chr(10)+Chr(10)+
                '11??? - Receitas'+Chr(10)+
                '32??? - Despesas Operacionais'+Chr(10)+Chr(10)+

                'Custo Operacional = Despesas Operacionais * 100 / Receitas'+Chr(10)+Chr(10)+
                'Não foi possível calcular o Custo Operacional,'+Chr(10)+
                'Verifique os valores no plano de contas.'+Chr(10)
                ,msgAtencao);
  end;
end;

procedure TFrmEstoque.btnPrecoClick(Sender: TObject);
begin
  Form7.ibDataSet4.Edit;
  Form7.ibDataSet4MARGEMLB.AsFloat := Form7.ibDataSet13RESE.AsFloat;
  Form7.ibDataSet4.Post;
end;

procedure TFrmEstoque.chkMarketplaceClick(Sender: TObject);
begin
  if chkMarketplace.Checked then
  begin
    if ProdutoValidoParaMarketplace(True) = '' then
    begin
      chkMarketplace.Checked := True;
    end else
    begin
      chkMarketplace.Checked := False;
      MensagemSistema('Para vender este produto através de Marketplace'+chr(10)+'preencha pelo menos os seguintes campos: '+chr(10)+chr(10)+ProdutoValidoParaMarketplace(True));
    end;
  end;

  try
    if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset4.Edit;

    if chkMarketplace.Checked then
    begin
      Form7.ibDataSet4MARKETPLACE.AsString  := '1';
    end else
    begin
      Form7.ibDataSet4MARKETPLACE.AsString  := '';
    end;

    Form7.ibDataset4.Post;
    Form7.ibDataset4.Edit;
  except
  end;
end;

procedure TFrmEstoque.ComboBox10Change(Sender: TObject);
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
  Form7.ibDataSet4CST_PIS_COFINS_ENTRADA.AsString := Copy(ComboBox10.Items[ComboBox10.ItemIndex]+'  ',1,2);
end;

procedure TFrmEstoque.ComboBox10Enter(Sender: TObject);
begin
  with Sender as tComboBox do
    SendMessage(Handle, CB_SETDROPPEDWIDTH, FrmEstoque.Width - Left - 30, 0);
end;

procedure TFrmEstoque.ComboBox11Change(Sender: TObject);
begin
  // 5101 - Venda de produção do estabelecimento;
  // 5102 - Venda de mercadoria de terceiros;
  // 5103 - Venda de produção do estabelecimento efetuada fora do estabelecimento;
  // 5104 - Venda de mercadoria adquirida ou recebida de terceiros, efetuada fora do estabelecimento;
  // 5115 - Venda de mercadoria de terceiros, recebida anteriormente em consignação mercantil;
  // 5405 - Venda de mercadoria de terceiros, sujeita a ST, como contribuinte substituído;
  // 5656 - Venda de combustível ou lubrificante de terceiros, destinados a consumidor final;
  // 5667 - Venda de combustível ou lubrificante a consumidor ou usuário final estabelecido em outra Unidade da Federação;
  // 5933 - Prestação de serviço tributado pelo ISSQN (Nota Fiscal conjugada);
  Form7.ibDataSet4CFOP.AsString := Copy(ComboBox11.Items[ComboBox11.ItemIndex]+'    ',1,4);
end;

procedure TFrmEstoque.ComboBox12Change(Sender: TObject);
begin
  if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset4.Edit;
  Form7.ibDataSet4MEDIDAE.AsString :=  ComboBox12.Text;

  Exemplo(True);
end;

procedure TFrmEstoque.ComboBox13Change(Sender: TObject);
begin
  Form7.ibDataSet4MEDIDA.AsString  :=  ComboBox13.Text;
  Exemplo(True);
end;

procedure TFrmEstoque.ComboBox14Change(Sender: TObject);
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
  Form7.ibDataSet4CST_NFCE.AsString := Copy(Form7.ibDataSet4CST.AsString+' ',1,1)+Copy(ComboBox14.Items[ComboBox14.ItemIndex]+'   ',1,2);
end;

procedure TFrmEstoque.ComboBox15Change(Sender: TObject);
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
  Form7.ibDataSet4CSOSN_NFCE.AsString := Trim(Copy(ComboBox15.Items[ComboBox15.ItemIndex]+'   ',1,3));
end;

procedure TFrmEstoque.ComboBox1Change(Sender: TObject);
begin
  // 50 - Saída Tributada
  // 51 - Saída Tributável com Alíquota Zero
  // 52 - Saída Isenta
  // 53 - Saída Não-Tributada
  // 54 - Saída Imune
  // 55 - Saída com Suspensão
  // 99 - Outras Saídas
  Form7.ibDataSet4CST_IPI.AsString := Copy(ComboBox1.Items[ComboBox1.ItemIndex]+'  ',1,2);
end;

procedure TFrmEstoque.ComboBox5Change(Sender: TObject);
begin
  inherited;
  // P - Produção própria
  // T - Produção por terceiros
  Form7.ibDataSet4IPPT.AsString := Copy(ComboBox5.Items[ComboBox5.ItemIndex]+' ',1,1);
end;

procedure TFrmEstoque.ComboBox6Change(Sender: TObject);
begin
  // A - Arredondamento
  // T - Truncamento
  Form7.ibDataSet4IAT.AsString := Copy(ComboBox6.Items[ComboBox6.ItemIndex]+' ',1,1);
end;

procedure TFrmEstoque.ComboBox7Change(Sender: TObject);
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
  Form7.ibDataSet4CST_PIS_COFINS_SAIDA.AsString := Copy(ComboBox7.Items[ComboBox7.ItemIndex]+'  ',1,2);

  if Copy(ComboBox7.Items[ComboBox7.ItemIndex]+'  ',1,2) = '03' then
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

procedure TFrmEstoque.ComboBox9Change(Sender: TObject);
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
  Form7.ibDataSet4TIPO_ITEM.AsString := Copy(ComboBox9.Items[ComboBox9.ItemIndex]+'  ',1,2);
end;

procedure TFrmEstoque.AjustaCampoPrecoQuandoEmPromocao;
var
  iObj: Integer;
  sRegistroOld: String;
begin
  edtPreco.Enabled    := not EmPeriodoPromocional;
  edtPreco.ReadOnly   := EmPeriodoPromocional;
  if not EmPeriodoPromocional then
    edtPreco.Font.Color := clWindowText;

  if Form7.sSelect <> '' then
  begin
    if Form7.ibDataSet4.Active then
    begin
      sRegistroOld := Form7.sRegistro;  // Sandro Silva 2024-06-18
      if EmPeriodoPromocional then
      begin
        if Form7.ibDataSet4.FieldByName('PRECO').AsFloat <> Form7.ibDataSet4.FieldByName('ONPROMO').AsFloat then
        begin
          try
            Form7.ibDataSet4.Refresh;

            if sRegistroOld <> Form7.sRegistro then
            begin
              Form7.sRegistro := sRegistroOld;
              Form7.ibDataSet4.Locate('REGSITRO', Form7.SREGISTRO, []);
            end;

            Form7.ibDataSet4.Edit;
          except

          end;
        end;
      end;
    end;
  end;
end;

function TFrmEstoque.EmPeriodoPromocional: Boolean;
begin
  Result := (Date >= Form7.ibDataSet4PROMOINI.AsDateTime) and (Date <= Form7.ibDataSet4PROMOFIM.AsDateTime);
end;



function TFrmEstoque.Exemplo(sP1 : boolean):Boolean;
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDAE.AsString)+' ');
  Form1.ibQuery1.Open;

  lblExemploConversao.Caption := 'Compra 1 '+Form1.IBQuery1.FieldByname('DESCRICAO').AsString+' e vende'+chr(10);

  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDA.AsString)+' ');
  Form1.ibQuery1.Open;

  lblExemploConversao.Caption := lblExemploConversao.Caption + FloatToStr(Form7.ibDataSet4FATORC.AsFloat) + ' ' + Form1.IBQuery1.FieldByname('DESCRICAO').AsString;

  Result := True;
end;


function TFrmEstoque.RetornarDescrCaracTagsObs: String;
begin
  Result := ' (' + Form7.ibDataSet4DESCRICAO.Size.ToString + ' caracteres)';
end;


procedure TFrmEstoque.ibDataSet28DESCRICAOChange(Sender: TField);
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

procedure TFrmEstoque.dbgSerialKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26
end;

procedure TFrmEstoque.dbgSerialKeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
  if Key = chr(13) then
  begin
    I := dbgSerial.SelectedIndex;
    dbgSerial.SelectedIndex := dbgSerial.SelectedIndex  + 1;
    if (I = dbgSerial.SelectedIndex) then
    begin
      dbgSerial.SelectedIndex := 0;
      Form7.ibDataSet30.Next;
      if Form7.ibDataSet30.EOF then Form7.ibDataSet30.Append;
    end;
  end;
end;

procedure TFrmEstoque.DefinirVisibleConsultaProdComposicao;
begin
  Form7.ibDataSet28.Edit;
  Form7.ibDataSet28.UpdateRecord;
  Form7.ibDataSet28.Edit;

  framePesquisaProdComposicao.Visible := (framePesquisaProdComposicao.Enabled)
                                         and (Form7.ibDataSet28.State in [dsEdit, dsInsert])
                                         and (dbgComposicao.Columns.Grid.SelectedField.FieldName = Form7.ibDataSet28DESCRICAO.FieldName)
                                         and (Form7.ibDataSet28DESCRICAO.AsString <> EmptyStr);
end;


procedure TFrmEstoque.AtribuirItemPesquisaComposicao;
begin
  if allTrim(framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString) <> EmptyStr then
  begin
    Form7.ibDataSet28.Edit;
    Form7.ibDataSet28DESCRICAO.AsString := framePesquisaProdComposicao.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString;
    dbgComposicao.SetFocus;
  end;
end;

function TFrmEstoque.CarregaValoresObjeto : boolean;
var
  I : Integer;

  FileStream : TFileStream;
  BlobStream : TStream;
  JP2        : TJPEGImage;
  sRegistroOld: String;
begin
  Result := True;

  if Copy(ComboBox7.Text, 1, 2) = '03' then
  begin
    Label43.Caption := 'R$ PIS:';
    Label49.Caption := 'R$ COFINS:';
  end else
  begin
    Label43.Caption := '% PIS:';
    Label49.Caption := '% COFINS:';
  end;

  {$Region'/// Atualiza Layout Estoque ////'}
  try
    if EmPeriodoPromocional then
    begin
      Form7.ibDataSet4PRECO.ReadOnly := True;
      edtPreco.Font.Color := clGrayText;
      lblPreco.Caption := 'Preço promocional:';
    end else
    begin
      try
        if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
          Form7.ibDataset4.Edit;
        if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        begin
          sRegistroOld := Form7.sRegistro;
          Form7.ibDataSet4OFFPROMO.AsFloat := Form7.ibDataSet4PRECO.AsFloat;
          if sRegistroOld <> Form7.sRegistro then
            Form7.sRegistro := sRegistroOld;
        end;

        Form7.ibDataSet4PRECO.ReadOnly := False;
        edtPreco.Font.Color := clblack;
        lblPreco.Caption := 'Preço';
      except
      end;
    end;
  except
  end;
  {$Endregion}

  {$Region '////  Atualiza Layout Estoque Foto ////'}

  Image5.Picture := nil;
  Image3.Picture := nil;

  if AllTrim(Form7.ibDataSet4DESCRICAO.AsString) <> '' then
  begin
    // FOTOS ANTIGAS
    if FileExists(sNomeDoJPG) then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      FileStream := TFileStream.Create(pChar(sNomeDoJPG),fmOpenRead or fmShareDenyWrite);
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmWrite);
      try
        BlobStream.CopyFrom(FileStream, FileStream.Size);
      finally
        FileStream.Free;
        BlobStream.Free;
      end;
      // Form7.ibDataset4.Post;
      Deletefile(pChar(sNomeDoJPG));
    end;

    if Form7.ibDataset4FOTO.BlobSize <> 0 then
    begin
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmRead);
      jp2 := TJPEGImage.Create;
      try
        try
          jp2.LoadFromStream(BlobStream);
          Image5.Picture.Assign(jp2);
          Image5.Repaint;
        except
          Result := False;
        end;
      finally
        BlobStream.Free;
        jp2.Free;
      end;
    end
    else
      Image5.Picture := Image3.Picture;
  end
  else
    Image5.Picture := Image3.Picture;
  {$EndRegion}

  {$Region '/// Ajusta proporção imagem da foto ///'}
  // Mantem a proporção da imagem
  try
    if Image5.Picture.Width <> 0 then
    begin
      Image5.Width   := 256;
      Image5.Height  := 256;

      if Image5.Picture.Width > Image5.Picture.Height then
      begin
        Image5.Width  := StrToInt(StrZero((Image5.Picture.Width * (Image5.Width / Image5.Picture.Width)),10,0));
        Image5.Height := StrToInt(StrZero((Image5.Picture.Height* (Image5.Width / Image5.Picture.Width)),10,0));
      end else
      begin
        Image5.Width  := StrToInt(StrZero((Image5.Picture.Width * (Image5.Height / Image5.Picture.Height)),10,0));
        Image5.Height := StrToInt(StrZero((Image5.Picture.Height* (Image5.Height / Image5.Picture.Height)),10,0));
      end;

      Image5.Picture := Image5.Picture;
      Image5.Repaint; // Sandro Silva 2023-08-21
    end;
  except
  end;
  {$EndRegion}

end;

procedure TFrmEstoque.cboCSOSN_ProdChange(Sender: TObject);
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
  Form7.ibDataSet4CSOSN.AsString := Trim(Copy(cboCSOSN_Prod.Items[cboCSOSN_Prod.ItemIndex]+'   ',1,3));
end;

procedure TFrmEstoque.cboCST_ProdChange(Sender: TObject);
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
  Form7.ibDataSet4CST.AsString := Copy(Form7.ibDataSet4CST.AsString+' ',1,1)+Copy(cboCST_Prod.Items[cboCST_Prod.ItemIndex]+'   ',1,2);
end;

procedure TFrmEstoque.cboOrigemProdChange(Sender: TObject);
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

  Form7.ibDataSet4CST.AsString := Copy(cboOrigemProd.Items[cboOrigemProd.ItemIndex]+' ',1,1)+Copy(Form7.ibDataSet4CST.AsString+'  ',2,2);
  Form7.ibDataSet4CST_NFCE.AsString := Copy(cboOrigemProd.Items[cboOrigemProd.ItemIndex]+' ',1,1)+Copy(Form7.ibDataSet4CST_NFCE.AsString+'  ',2,2); // Mauricio Parizotto 2023-09-06
end;

procedure TFrmEstoque.CarregaCit;
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


function TFrmEstoque.GravaImagemEstoque: Boolean;
var
  FileStream : TFileStream;
  BlobStream : TStream;
  JP2        : TJPEGImage;
begin
  Image5.Picture := nil;
  Image3.Picture := nil;

  if AllTrim(Form7.ibDataSet4DESCRICAO.AsString) <> '' then
  begin
    // FOTOS ANTIGAS
    if FileExists(sNomeDoJPG) then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      FileStream := TFileStream.Create(pChar(sNomeDoJPG),fmOpenRead or fmShareDenyWrite);
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmWrite);
      try
        BlobStream.CopyFrom(FileStream, FileStream.Size);
      finally
        FileStream.Free;
        BlobStream.Free;
      end;
      // Form7.ibDataset4.Post;
      Deletefile(pChar(sNomeDoJPG));
    end;

    if Form7.ibDataset4FOTO.BlobSize <> 0 then
    begin
      BlobStream := Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO, bmRead);
      jp2 := TJPEGImage.Create;
      try
        try
          jp2.LoadFromStream(BlobStream);
          Image5.Picture.Assign(jp2);
          Image5.Repaint;

        except
          Result := False;
        end;
      finally
        BlobStream.Free;
        jp2.Free;
      end;
    end
    else
      Image5.Picture := Image3.Picture;
  end
  else
    Image5.Picture := Image3.Picture;

  // Mantem a proporção da imagem
  try
    if Image5.Picture.Width <> 0 then
    begin
      Image5.Width   := 256;
      Image5.Height  := 256;

      if Image5.Picture.Width > Image5.Picture.Height then
      begin
        Image5.Width  := StrToInt(StrZero((Image5.Picture.Width * (Image5.Width / Image5.Picture.Width)),10,0));
        Image5.Height := StrToInt(StrZero((Image5.Picture.Height* (Image5.Width / Image5.Picture.Width)),10,0));
      end else
      begin
        Image5.Width  := StrToInt(StrZero((Image5.Picture.Width * (Image5.Height / Image5.Picture.Height)),10,0));
        Image5.Height := StrToInt(StrZero((Image5.Picture.Height* (Image5.Height / Image5.Picture.Height)),10,0));
      end;

      Image5.Picture := Image5.Picture;
      Image5.Repaint; // Sandro Silva 2023-08-21
    end;
  except
  end;

end;

end.
