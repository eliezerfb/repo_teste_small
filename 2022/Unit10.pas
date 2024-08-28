// Cadastro de produtos/clientes/fornecedores
unit Unit10;

interface

uses
  Windows,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, IniFiles, Mask, DBCtrls, SMALL_DBEdit,
  Buttons
  , SmallFunc_XE
  , DB, shellapi, ComCtrls, Grids,
  DBGrids, Printers, JPEG, Videocap, Clipbrd, OleCtrls, SHDocVw,
  xmldom, XMLIntf, DBClient, msxmldom, XMLDoc, ExtDlgs,
  uframePesquisaPadrao, uframePesquisaProduto, IBCustomDataSet, IBQuery,
  uframeCampo, uObjetoConsultaCEP, uConsultaCEP;

const ID_CONSULTANDO_INSTITUICAO_FINANCEIRA = 1;
const ID_CONSULTANDO_FORMA_DE_PAGAMENTO     = 2;
const ID_CONSULTANDO_CFOP                   = 3; //Mauricio Parizotto 2023-08-25

type

  TForm10 = class(TForm)
    Panel_branco: TPanel;
    orelhas: TPageControl;
    orelha_cadastro: TTabSheet;
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
    DBGrid3: TDBGrid;
    Panel5: TPanel;
    Image201: TImage;
    Image202: TImage;
    Image203: TImage;
    Image204: TImage;
    Image205: TImage;
    Panel2: TPanel;
    btnOK: TBitBtn;
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
    SMALL_DBEdit73: TSMALL_DBEdit;
    DBMemo1: TDBMemo;
    procedure Image204Click(Sender: TObject);
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure SMALL_DBEdit1Exi(Sender: TObject);
    procedure SMALL_DBEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit23KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Image201Click(Sender: TObject);
    procedure Image205Click(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label36MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image202Click(Sender: TObject);
    procedure Label37MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label37MouseLeave(Sender: TObject);
    procedure Label40MouseLeave(Sender: TObject);
    procedure Label40MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label42MouseLeave(Sender: TObject);
    procedure Label42MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label43MouseLeave(Sender: TObject);
    procedure Label43MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
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
    procedure Image20Click(Sender: TObject);
    procedure Label54Click(Sender: TObject);
    procedure SMALL_DBEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SMALL_DBEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure ComboBox9KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure orelha_cadastroShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure orelha_cadastroExit(Sender: TObject);
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
    procedure Panel2DblClick(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure ComboBoxEnter(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure fraPerfilTribtxtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FcCEPAnterior: String;
    cCadJaValidado: String;
    FotoOld : String;
    function TestarSomenteLeitura: Boolean;
  public
    { Public declarations }

    sNomeDoJPG, sSistema  : String;
    sLinha : String;
    sColuna : String;
    sRegistroVolta : String;
    bNovo : boolean;
//    bGravaEscolha : boolean;
    rCusto : Real;


//    procedure AjustaCampoPrecoQuandoEmPromocao;
//    function JpgResize(sP1: String; iP2: Integer): boolean;
  end;

var

  Form10   : TForm10;
  tProcura : TDataSet;
  sText    : String;

implementation

uses Unit7, Mais, Unit38, Unit16, Unit12, unit24, Unit22,
  preco1, uFrmAssistenteProcura, Unit19, Mais3, uFrmParcelas, StrUtils, uTestaProdutoExiste,
  uITestaProdutoExiste
  , WinInet
  , uRetornaLimiteDisponivel
  , uFuncoesBancoDados
  , uFuncoesRetaguarda
  , Variants, uVisualizaCadastro, uDialogs;
  
{$R *.DFM}

{
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
end;

}

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



function AtualizaTela(sP1 : boolean):Boolean;
var
  I : Integer;
  FileStream : TFileStream;
  BlobStream : TStream;
  sTotal     : string;
  JP2         : TJPEGImage;
  sRegistroOld: String;
begin
  // Posiciona o foco quando ativa
  Result := True;
  try
    begin
      {$Region'/// Atualiza Layout demais tela ////'}
      Form7.IBDataSet99.Close;
      Form7.IBDataSet99.SelectSQL.Clear;
      Form7.IBDataSet99.SelectSQL.Add(StrTran(Form7.sSelect,'*','count(REGISTRO)')+' '+Form7.sWhere);
      Form7.IBDataSet99.Open;
      sTotal := Form7.IBDataSet99.fieldByname('COUNT').AsString;
      Form7.IBDataSet99.Close;
      {$EndRegion}
    end;

    if Form7.ArquivoAberto.Recno > StrToIntDef(sTotal, 0) then
      Form10.orelha_cadastro.Caption := 'Ficha '+IntToStr(Form7.ArquivoAberto.Recno)+' de '+IntToStr(Form7.ArquivoAberto.Recno)
    else
      Form10.orelha_cadastro.Caption := 'Ficha '+IntToStr(Form7.ArquivoAberto.Recno)+' de '+IntToStr(StrToInt(sTotal));

    {$Region '/// Foca o campo disponível ///'}
    if sP1 then
    begin
      // tenta focar num edit
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
    {$EndRegion}

    Form10.Caption := 'Ficha';

//    Form10.Image5.Picture := Form10.Image3.Picture;


  except
  end;
end;


 (*
procedure GravaEscolha;
begin
  {
  try
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
  except
  end;
  Mauricio Parizotto 2024-07-16 }
end;
*)

procedure TForm10.Image204Click(Sender: TObject);
begin
  try
    Form7.ArquivoAberto.MoveBy(-1);
  except
  end;
    
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
end;

procedure TForm10.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
//    bGravaEscolha := False;

    if Form7.bFlag = True then
    begin
      if Key = VK_RETURN then
      begin
//        bGravaEscolha := True;
        Perform(Wm_NextDlgCtl,0,0);
      end;
      
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
    MensagemSistema('Erro 10/6 comunique o suporte técnico.',msgErro);
  end;
end;

procedure TForm10.SMALL_DBEdit1Enter(Sender: TObject);
var
  vDataField : string;
begin
  //Mauricio Parizotto 2023-05-29
//  bGravaEscolha := False;

  dBGrid3.Tag := 0;

  dBGrid3.Visible := False;

  dBGrid3.Parent := TSMALL_DBEdit(Sender).Parent; // Sandro Silva 2023-06-28

  {Mauricio Parizotto 2024-07-16
  try
    with Sender as TSMALL_DBEdit do
    begin
      dBgrid3.Columns.Items[0].FieldName := 'NOME';
      dBgrid3.Columns.Items[0].Width     := 204;

      vDataField := DataField;

      dBGrid1.Visible := False;
      if (vDataField = 'NOME') and
                       (
                        (Form7.sModulo = 'VENDA') or
                        (Form7.sModulo = 'COMPRA') or
                        (Form7.sModulo = 'ESTOQUE')
                       ) then
        dBGrid1.Visible := True;

      dBgrid3.Columns.Items[1].Visible   := False;

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
    end;
  except
    MensagemSistema('Erro 10/77 comunique o suporte técnico.',msgErro);
  end;

  }

  SMALL_DBEdit1Change(Sender); //Mauricio Parizotto 2024-01-23
end;

procedure TForm10.SMALL_DBEdit1Exi(Sender: TObject);
begin
  try
    sText := '';

    with Sender as TSMALL_DBEdit do
    begin
      {
      if (Form7.sModulo = 'ESTOQUE') and (Datafield = 'DESCRICAO') and (Form7.ibDataSet4DESCRICAO.AsString = '') then
      begin
        if SMALL_DBEdit5.Focused then
        begin
          MensagemSistema('Descrição inválida.',msgAtencao);
          SMALL_DBEdit3.SetFocus;
          Abort;
        end;
      end;
      Mauricio Parizotto 2024-07-16}

      (* Mauricio Parizotto 2024-07-16
      if ((DataField = 'NOME') or (DataField = 'CONTA') or (DataField = 'CIDADE') or (DataField = 'CONVENIO')) and
       (
          (Form7.sModulo = 'VENDA') or
           (Form7.sModulo = 'COMPRA') or
             (Form7.sModulo = 'ESTOQUE')
             ) then
      begin
        sText := AllTrim(Text);

        if sText <> '' then
        begin
          tProcura := Form7.ibDataSet12;

          if (Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'COMPRA') then
            tProcura := Form7.ibDataSet21;

          if bGravaEscolha then
          begin
            if Pos(AnsiUpperCase(sText), AnsiUpperCase(AllTrim(tProcura.FieldByName('NOME').AsString))) <> 0 then
              GravaEscolha
            else
            begin
              begin
                Text := '';
                Abort;
              end;
            end;
          end;
        end;
      end;

      *)

    end;
  except
  end;
end;

procedure TForm10.SMALL_DBEdit1Change(Sender: TObject);
var
  vDataField : string;
begin
  {Mauricio Parizotto 2024-07-16
  try

    if Form10.Visible then
    begin
      with Sender as TSMALL_DBEdit do
      begin
        vDataField := DataField;

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
  }

//  if (Form7.sModulo = 'ESTOQUE') and (Form10.orelhas.ActivePage = Orelha_promo) then
//    AtualizaTela(False);

//  AjustaCampoPrecoQuandoEmPromocao; // Sandro Silva 2024-06-12

end;


procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I : Integer;
  vRegistro : string;
  t: TTime;
  iRecno: Integer; // Sandro Silva 2023-09-12
begin


  Orelhas.ActivePage := Orelha_cadastro;

  Form10.DBMemo1.Visible := False;

  if Form7.ArquivoAberto <> nil then
  begin
    sRegistroVolta := Form7.ArquivoAberto.FieldByname('REGISTRO').AsString;

    {
    if Form7.Visible then
    begin
      if Form7.DBGrid1.CanFocus then Form7.DBGrid1.SetFocus;
    end;
    Mauricio Parizotto 2024-07-16}

    GravaRegistro(True);
  end;

  Form10.Hide;

//  Image5.Picture  := Image3.Picture;
end;

procedure TForm10.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  Form10.Tag := Form10.Tag + 1;
end;

procedure TForm10.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  Form10.Tag := 33;
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
//  GravaEscolha();

  if Form10.dBGrid3.Height = 260 then
  begin
    if Form10.SMALL_DBEdit6.CanFocus then
      Form10.SMALL_DBEdit6.SetFocus
  end else
  begin
    begin
      if Form10.SMALL_DBEdit19.CanFocus then
        Form10.SMALL_DBEdit19.SetFocus;
    end;
  end;
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
    MensagemSistema('Erro 10/66 comunique o suporte técnico.',msgErro);
  end;
end;

procedure TForm10.Image201Click(Sender: TObject);
begin
  Form10.Button4.SetFocus;
  Form10.Button4Click(Sender);

  if not Form7.bSoLeitura then
  begin
    begin
      try
         Form7.ArquivoAberto.Append;
      except
      end;
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
end;

procedure TForm10.Edit2Enter(Sender: TObject);
begin
  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm10.FormCreate(Sender: TObject);
begin
  orelhas.ActivePage := orelha_cadastro; // Sandro Silva 2023-06-27


  //Mauricio Parizotto 2023-06-01
  Image201.Transparent := False;
  Image202.Transparent := False;
  Image203.Transparent := False;
  Image205.Transparent := False;
  Image204.Transparent := False;

  //Mauricio Parizotto 2023-06-19
  DBGrid3.TabStop := False;


end;

procedure TForm10.Label36MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.Image202Click(Sender: TObject);
begin
  FrmAssistenteProcura.ShowModal;

  //Form7.iFoco := 0;
  Form10.Paint;

  Orelhas.ActivePage := orelha_cadastro;
  AtualizaTela(True);// Form10.Panel_1Enter(Sender);
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

procedure TForm10.Label43MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm10.Label43MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm10.FormActivate(Sender: TObject);
var
  iWidthCampos: Integer;
begin
  orelha_cadastro.TabVisible   := True;

  bNovo := False;
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

procedure TForm10.SMALL_DBEdit1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with Sender as TSMALL_DBEdit do
  begin
    Hint := Field.DisplayLabel;
    ShowHint := True;
  end;
end;

procedure TForm10.SMALL_DBEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form7.sAjuda)));

  if Sender.ClassType = TSMALL_DBEdit then
  begin
    {
     if ((((TSMALL_DBEdit(Sender).DataField = 'NOME') and (Form7.sModulo <> 'ESTOQUE'))
          or (TSMALL_DBEdit(Sender).DataField = 'CGC')
          or (TSMALL_DBEdit(Sender).DataField = 'DESCRICAO'))
        and (//(Form7.sModulo = 'RECEBER') or Mauricio Parizotto 2024-04-15
             //(Form7.sModulo = 'PAGAR') or Mauricio Parizotto 2024-04-15
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
    Mauricio Parizotto 2024-07-16}

    {Dailon (f-7225) 2023-08-17 inicio}
    {
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
    Mauricio Parizotto 2024-07-16 }
  end;
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

//  Image5.Picture  := Image3.Picture; // Dailon parisotto 2023-12-28

  tInicio := time;
  Form10.orelhas.Visible := False;

  try
    Form7.ibDataSet13.Edit;
  except
  end;

  Orelhas.ActivePage := Orelha_cadastro;

  Form10.Width  := 855; // 845;
  Form10.Height := 655; // 650;

  btnOK.Left  := Panel2.Width - btnOK.Width - 10;

  Form7.ArquivoAberto.DisableControls;
  Form7.TabelaAberta.DisableControls;

  orelha_cadastro.PageIndex  :=  0;

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


  dBGrid3.Left := 100;
  iTop         := -5;
  iTopPrimeiraColuna := iTop; // Sandro Silva 2023-07-25

  try
    VerificaSeEstaSendoUsado(True);


    if Form7.bSoLeitura then
      dbMemo1.Enabled := False
    else
      dbMemo1.Enabled := True;


    if Form7.bSoLeitura then
    begin
      dbMemo1.Enabled := False;
    end else
    begin
      dbMemo1.Enabled := True;
    end;

    //------------------------------
    //Todos os LAbel não visíveis
    //-------------------------------
    for I := 0 to 30 do
      TLabel(Form10.Components[I+Label1.ComponentIndex]).Visible := False;
    for I := 0 to 30 do
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).Visible := False;

    DbGrid3.visible := False;
    DBMemo1.Visible := False;
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

    {Sandro Silva 2024-01-10 inicio}
    for I := 0 to 29 do // mantido 29 que é o mesmo número de campos que são configurados na sequência da rotina
    begin
      TSMALL_DBEdit(Form10.Components[I+SMALL_DBEdit1.ComponentIndex]).DataField  := '';
    end;
    {Sandro Silva 2024-01-10 fim}

    //if Form7.sModulo <> 'ICM' then // Não entrar no "For to do" se estiver editando o módulo ICM, o mesmo tem uma aba somente para ele, com os campos fixos, diferente dos demais módulos que monta a tela dinamicamente Mauricio Parizotto 2024-04-09
    begin
      for I := 1 to Form7.iCampos do
      begin
        //if Form1.CampoDisponivelParaUsuario(Form7.sModulo, Form7.ArquivoAberto.Fields[I - 1].FieldName) then
        begin
          if AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel) <> '...' then
          begin
            //if not ((Form7.sModulo = 'CLIENTES') and (I >= 27)) then
            begin
              if not ((I >= iContadorCampoEstoque)) then // Sandro Silva 2022-12-20 if not ((Form7.sModulo = 'ESTOQUE') and (I >= 23)) then
              begin
                  iTop := iTop + 25;

                if iTopPrimeiraColuna < 0 then
                  iTopPrimeiraColuna := iTop;

                  iTop := 15;

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


                begin
                  if I > 17 then
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 460 + 70
                  else
                    TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 100;

                end;

                
                if Form7.TabelaAberta.Fields[I-1].DisplayLabel+':' = 'UF:' then
                begin
                  iTop := iTop - 25;
                  TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Top                := iTop;
                  TLabel(Form10.Components[I - 1 + Label1.ComponentIndex]).Left               := 214;
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left := 314;
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

                //Mauricio Parizotto 2023-12-19
                //Campo descrição produto
                if (Form7.TabelaAberta.Fields[I-1].Fieldname = 'DESCRICAO') and (Form7.ArquivoAberto.Name = 'ibDataSet4') then
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Width := 580;


                if TipoCampoFloat(Form7.ArquivoAberto.Fields[I-1]) = False then // Sandro Silva 2024-04-29 if (Form7.ArquivoAberto.Fields[I-1].DataType <> ftFloat) then
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).MaxLength := Form7.ArquivoAberto.Fields[I - 1].Size
                else
                  TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).MaxLength := 22;

                {
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

                    // Estoque
                    if (Form7.sModulo = 'VENDA') or
                        (Form7.sModulo = 'COMPRA') or
                         (Form7.sModulo = 'ESTOQUE') then
                    begin
                      dBGrid1.DataSource := Form7.DataSource21; // Grupos
                    end;
                  except
                    //ShowMessage('Erro 2 comunique o suporte técnico.')Mauricio Parizotto 2023-10-25
                    MensagemSistema('Erro 2 comunique o suporte técnico.',msgErro);
                  end;
                end;
                Mauricio Parizotto 2024-07-16 }

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
                  MensagemSistema('Erro 3 comunique o suporte técnico.',msgErro);
                end;

                {Mauricio Parizotto 2024-07-16
                if Form7.ArquivoAberto.Fields[I-1].Name = 'ibDataSet4FORNECEDOR' then
                begin
                  Form10.Label45.Visible := True;
                  Form10.Label45.Left    := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Left + 2;
                  Form10.Label45.Top     := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).Top + 2;
                  Form10.Label45.Hint    := 'Este campo não pode ser alterado'+Chr(10)+
                                            'o nome do fornecedor e preenchido'+Chr(10)+
                                            'no evento da compra.';
                end;
                }

                if Form7.ArquivoAberto.Fields[I - 1].Displaywidth >= 200 then
                begin
                  Form10.dbMemo1.DataSource := Form7.DataSourceAtual;
                  Form10.dbMemo1.DataField  := Form7.ArquivoAberto.Fields[I - 1].Fieldname;
                  Form10.dbMemo1.TabOrder   := TSMALL_DBEdit(Form10.Components[I - 1 + SMALL_DBEdit1.ComponentIndex]).TabOrder;

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
      end;
    end;
  except
    MensagemSistema('Erro número  13 comunique o suporte técnico.',msgErro);
  end;

  Orelhas.ActivePage := orelha_cadastro;

  Form7.ArquivoAberto.EnableControls;
  Form7.TabelaAberta.EnableControls;

  Form10.orelhas.Visible := True;

  AtualizaTela(True);

  DecodeTime((Time - tInicio), Hora, Min, Seg, cent);

  Label201.Hint := 'Tempo: '+TimeToStr(Time - tInicio)+' ´ '+StrZero(cent,3,0)+chr(10);
  Label201.ShowHint := True;

  Form10.Left := (Form7.Width - Form10.Width) div 2;
  Form10.Repaint;

  orelha_cadastroShow(orelha_cadastro); // Sandro Silva 2024-06-12
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
  {Sandro Silva 2024-06-12 inicio}
//  AjustaCampoPrecoQuandoEmPromocao;
  {Sandro Silva 2024-06-12 fim}
end;

procedure TForm10.Button4Click(Sender: TObject);
begin
  //Mauricio Parizotto 2024-04-16
  Orelha_cadastro.Visible := True;
  Orelhas.ActivePage := Orelha_cadastro;
  Close;
end;

procedure TForm10.orelha_cadastroExit(Sender: TObject);
begin
  {
  if (Form7.sModulo = 'ESTOQUE') then
  begin
    Form10.Caption := form7.ibDataSet4DESCRICAO.AsString;
  end;
  }
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

procedure TForm10.Panel2DblClick(Sender: TObject);
begin
  Form10.Panel2.ShowHint := True;
end;



procedure TForm10.fraPerfilTribtxtCampoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

(*Mauricio Parizotto 2024-07-16
procedure TForm10.AjustaCampoPrecoQuandoEmPromocao;
var
  iObj: Integer;
  sRegistroOld: String;
begin
  if (Form7.sModulo = 'ESTOQUE') then
  begin

    for iObj := 0 to Form10.ComponentCount - 1 do
    begin
      if Form10.Components[iObj].ClassType = TSMALL_DBEdit then
      begin
        if AnsiUpperCase(TSMALL_DBEdit(Form10.Components[iObj]).DataField) = 'PRECO' then
        begin
          TSMALL_DBEdit(Form10.Components[iObj]).Enabled    := not EmPeriodoPromocional;
          TSMALL_DBEdit(Form10.Components[iObj]).ReadOnly   := EmPeriodoPromocional;
          if not EmPeriodoPromocional then
            TSMALL_DBEdit(Form10.Components[iObj]).Font.Color := clWindowText;

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
            end; // if Form7.ibDataSet4.Active then
          end; // if Form7.sSelect <> '' then
        end;
      end;
    end;
  end;
end;

*)


procedure TForm10.DBGrid3CellClick(Column: TColumn);
begin
  DBGrid3DblClick(nil);
end;


procedure TForm10.ComboBoxEnter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;



function TForm10.TestarSomenteLeitura: Boolean;
begin
  Result := ((Form7.bSoLeitura) or (Form7.bEstaSendoUsado));
end;

end.
