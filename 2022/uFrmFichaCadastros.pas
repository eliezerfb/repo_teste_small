unit uFrmFichaCadastros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  Videocap, Vcl.Imaging.jpeg, Vcl.ExtDlgs
  , Clipbrd, uframeCampo, IBX.IBCustomDataSet;

type
  TFrmFichaCadastros = class(TFrmFichaPadrao)
    tsCadastro: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    Label4: TLabel;
    SMALL_DBEdit4: TSMALL_DBEdit;
    Label5: TLabel;
    Label6: TLabel;
    SMALL_DBEdit5: TSMALL_DBEdit;
    Label7: TLabel;
    SMALL_DBEdit6: TSMALL_DBEdit;
    Label8: TLabel;
    SMALL_DBEdit7: TSMALL_DBEdit;
    Label9: TLabel;
    SMALL_DBEdit8: TSMALL_DBEdit;
    Label10: TLabel;
    SMALL_DBEdit9: TSMALL_DBEdit;
    Label11: TLabel;
    SMALL_DBEdit10: TSMALL_DBEdit;
    Label12: TLabel;
    SMALL_DBEdit11: TSMALL_DBEdit;
    Label13: TLabel;
    SMALL_DBEdit12: TSMALL_DBEdit;
    Label14: TLabel;
    SMALL_DBEdit13: TSMALL_DBEdit;
    Label15: TLabel;
    SMALL_DBEdit14: TSMALL_DBEdit;
    Label16: TLabel;
    SMALL_DBEdit15: TSMALL_DBEdit;
    Label17: TLabel;
    SMALL_DBEdit16: TSMALL_DBEdit;
    eLimiteCredDisponivel: TEdit;
    lblLimiteCredDisponivel: TLabel;
    Label18: TLabel;
    SMALL_DBEdit17: TSMALL_DBEdit;
    Label19: TLabel;
    SMALL_DBEdit18: TSMALL_DBEdit;
    SMALL_DBEdit19: TSMALL_DBEdit;
    Label20: TLabel;
    Label21: TLabel;
    SMALL_DBEdit20: TSMALL_DBEdit;
    Label22: TLabel;
    SMALL_DBEdit21: TSMALL_DBEdit;
    Label23: TLabel;
    SMALL_DBEdit22: TSMALL_DBEdit;
    Label24: TLabel;
    SMALL_DBEdit23: TSMALL_DBEdit;
    DBMemo1: TDBMemo;
    Label25: TLabel;
    Label26: TLabel;
    SMALL_DBEdit24: TSMALL_DBEdit;
    DBMemo2: TDBMemo;
    Label27: TLabel;
    pnRelacaoComercial: TPanel;
    Label56: TLabel;
    ComboBox8: TComboBox;
    DBEControleDeNavegacao: TSMALL_DBEdit;
    tsFoto: TTabSheet;
    Image3: TImage;
    Image5: TImage;
    VideoCap1: TVideoCap;
    Button13: TBitBtn;
    Button22: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    Image1: TImage;
    fraPerfilTrib: TfFrameCampo;
    DSPerfilTrib: TDataSource;
    ibdPerfilTrib: TIBDataSet;
    ibdPerfilTribTIPO_ITEM: TIBStringField;
    ibdPerfilTribIPPT: TIBStringField;
    ibdPerfilTribIAT: TIBStringField;
    ibdPerfilTribORIGEM: TIBStringField;
    ibdPerfilTribPIVA: TFloatField;
    ibdPerfilTribCST: TIBStringField;
    ibdPerfilTribCSOSN: TIBStringField;
    ibdPerfilTribST: TIBStringField;
    ibdPerfilTribCFOP: TIBStringField;
    ibdPerfilTribCST_NFCE: TIBStringField;
    ibdPerfilTribCSOSN_NFCE: TIBStringField;
    ibdPerfilTribALIQUOTA_NFCE: TIBBCDField;
    ibdPerfilTribCST_IPI: TIBStringField;
    ibdPerfilTribIPI: TFloatField;
    ibdPerfilTribENQ_IPI: TIBStringField;
    ibdPerfilTribCST_PIS_COFINS_SAIDA: TIBStringField;
    ibdPerfilTribALIQ_PIS_SAIDA: TIBBCDField;
    ibdPerfilTribALIQ_COFINS_SAIDA: TIBBCDField;
    ibdPerfilTribCST_PIS_COFINS_ENTRADA: TIBStringField;
    ibdPerfilTribALIQ_PIS_ENTRADA: TIBBCDField;
    ibdPerfilTribALIQ_COFINS_ENTRADA: TIBBCDField;
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure SMALL_DBEdit5KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit13KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit6KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBEControleDeNavegacaoChange(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure lblProcurarClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure tsFotoShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SMALL_DBEdit7Change(Sender: TObject);
    procedure SMALL_DBEdit18Change(Sender: TObject);
    procedure fraPerfilTribgdRegistrosDblClick(Sender: TObject);
    procedure fraPerfilTribExit(Sender: TObject);
  private
    { Private declarations }
    sNomeDoArquivoParaSalvar : String;
    sNomeDoJPG: String;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure DefinirLimiteDisponivel;
    procedure RemoveEspacoNoInicio(Sender: TObject);
    procedure AtualizaTela(sP1: Boolean);
  public
    { Public declarations }
  end;

var
  FrmFichaCadastros: TFrmFichaCadastros;

implementation

{$R *.dfm}

uses unit7, uRetornaLimiteDisponivel, smallfunc_xe, MAIS, uDialogs,
  Winapi.ShellAPI;

{ TFrmFichaCadastros }

procedure TFrmFichaCadastros.AtualizaTela(sP1: Boolean);
var
  I : Integer;
  FileStream : TFileStream;
  BlobStream : TStream;
  sTotal     : string;
  JP2         : TJPEGImage;
begin

  if sP1 then
  begin
    // tenta focar num edit
    if SMALL_DBEdit1.CanFocus then
      SMALL_DBEdit1.SetFocus
    else if SMALL_DBEdit2.CanFocus then
       SMALL_DBEdit2.SetFocus
    else if SMALL_DBEdit3.CanFocus then
      SMALL_DBEdit3.SetFocus
    else if SMALL_DBEdit4.CanFocus then
      SMALL_DBEdit4.SetFocus
    else if SMALL_DBEdit5.CanFocus then
      SMALL_DBEdit5.SetFocus;
  end;

  if AllTrim(Form7.ArquivoAberto.FieldByName('CLIFOR').AsString)<>'' then
  begin
    for I := 0 to ComboBox8.Items.Count -1 do
    begin
      if ComboBox8.Items[I] = Form7.ArquivoAberto.FieldByName('CLIFOR').AsString then
      begin
        ComboBox8.ItemIndex := I;
        Break;
      end;
    end;
  end else
  begin
    if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
    begin
      ComboBox8.ItemIndex := 8;
    end else
    begin
      ComboBox8.ItemIndex := 0;
    end;
  end;

  Caption := form7.ibDataSet2NOME.AsString;

  Image5.Picture := nil;
  Image3.Picture := nil;

  if FileExists(sNomeDoJPG) then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;
    FileStream := TFileStream.Create(sNomeDoJPG,fmOpenRead or fmShareDenyWrite);
    BlobStream := Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmWrite);
    try
      BlobStream.CopyFrom(FileStream,FileStream.Size);
    finally
      FileStream.Free;
      BlobStream.Free;
    end;

    Deletefile(pChar(sNomeDoJPG));
  end;

  if Form7.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
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

procedure TFrmFichaCadastros.DefinirLimiteDisponivel;
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

procedure TFrmFichaCadastros.RemoveEspacoNoInicio(Sender: TObject);
begin
  if (Copy(TSMALL_DBEdit(Sender).Text, 1, 1) = ' ') then
  begin
    if not (TSMALL_DBEdit(Sender).Field.DataSet.State in [dsEdit, dsInsert]) then
    begin
      TSMALL_DBEdit(Sender).Field.DataSet.Edit;
      TSMALL_DBEdit(Sender).Text := Trim(TSMALL_DBEdit(Sender).Text);
      TSMALL_DBEdit(Sender).Field.DataSet.Post;
    end
    else
      TSMALL_DBEdit(Sender).Text := Trim(TSMALL_DBEdit(Sender).Text);
  end;
end;

procedure TFrmFichaCadastros.FormCreate(Sender: TObject);
begin
  inherited;
  {Sandro Silva 2023-06-21 inicio}
  pnRelacaoComercial.BorderStyle := bsNone;
  pnRelacaoComercial.BevelOuter  := bvNone;
  {Sandro Silva 2023-06-21 fim}

end;

procedure TFrmFichaCadastros.FormShow(Sender: TObject);
begin
  pgcFicha.ActivePage := tsCadastro;

  bSomenteLeitura := Form7.bSoLeitura;
  sNomeDoJPG := Form1.sAtual+'\tempo0000000000.jpg';

  inherited;

  AtualizaTela(True);
end;

procedure TFrmFichaCadastros.fraPerfilTribExit(Sender: TObject);
begin
  inherited;
  fraPerfilTrib.FrameExit(Sender);

  ibdPerfilTrib.Close;
  ibdPerfilTrib.Open;

end;

procedure TFrmFichaCadastros.fraPerfilTribgdRegistrosDblClick(Sender: TObject);
begin
  inherited;
  fraPerfilTrib.gdRegistrosDblClick(Sender);

  ibdPerfilTrib.Close;
  ibdPerfilTrib.Open;

end;

function TFrmFichaCadastros.GetPaginaAjuda: string;
begin
  Result := 'clifor.htm';
end;

procedure TFrmFichaCadastros.Image1Click(Sender: TObject);
begin
  inherited;
  ShellExecute( 0, 'Open',pChar('https://www.google.com.br/maps/dir//'+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2COMPLE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2CEP.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString))+' - '+
    AllTrim(ConverteAcentosPHP(Form7.ibDataSet2ESTADO.AsString))+' '
    ),'', '', SW_SHOWMAXIMIZED);

end;

procedure TFrmFichaCadastros.Image5Click(Sender: TObject);
begin
  inherited;
  try
    while FileExists(pChar(sNomeDoJPG)) do
    begin
      DeleteFile(pChar(sNomeDoJPG));
    end;

    Image5.Picture.SaveToFile(sNomeDoJPG);

    Sleep(1000);

    ShellExecute( 0, 'Open',pChar(sNomeDoJPG),'','', SW_SHOWMAXIMIZED);

    //ShowMessage('Tecle <enter> para que a nova imagem seja exibida.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Tecle <enter> para que a nova imagem seja exibida.');
    AtualizaTela(True);
  except
  end;

end;

procedure TFrmFichaCadastros.lblProcurarClick(Sender: TObject);
begin
  inherited;

  pgcFicha.ActivePage := tsCadastro;
  AtualizaTela(True);// Form10.Panel_1Enter(Sender);

end;

procedure TFrmFichaCadastros.SetaStatusUso;
begin
  inherited;
  SMALL_DBEdit1.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit2.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit1.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit2.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit3.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit4.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit5.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit6.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit7.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit8.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit9.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit10.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit11.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit12.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit13.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit14.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit15.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit16.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit17.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit18.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit19.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit20.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit21.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit22.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  SMALL_DBEdit23.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);
  SMALL_DBEdit24.Enabled      := not(bSomenteLeitura) and not(bEstaSendoUsado);

  fraPerfilTrib.Enabled := not(bSomenteLeitura) and not(bEstaSendoUsado);

  dbMemo1.Enabled := not(bSomenteLeitura) and not(bEstaSendoUsado);
  dbMemo2.Enabled := not(bSomenteLeitura) and not(bEstaSendoUsado);

  ComboBox8.Enabled := not(bSomenteLeitura) and not(bEstaSendoUsado);
  eLimiteCredDisponivel.Enabled := not(bSomenteLeitura) and not(bEstaSendoUsado);


end;

procedure TFrmFichaCadastros.SMALL_DBEdit13KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  RemoveEspacoNoInicio(Sender);
end;

procedure TFrmFichaCadastros.SMALL_DBEdit18Change(Sender: TObject);
begin
  inherited;
  if (Form7.ibDataSet29.Active) then
  begin
    Form7.ibDataSet29.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TFrmFichaCadastros.Button13Click(Sender: TObject);
var
  jp : TJPEGImage;
begin
  inherited;

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

      {Sandro Silva 2023-01-24 inicio}
      while not FileExists(pChar(sNomeDoJPG)) do
      begin
        Sleep(100);
      end;

      Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
      Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));
      //
      AtualizaTela(True);
      {Sandro Silva 2023-01-24 fim}
    except end;
  end;

end;

procedure TFrmFichaCadastros.Button22Click(Sender: TObject);
begin
  inherited;
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

    AtualizaTela(True);
  end;

end;

procedure TFrmFichaCadastros.DBEControleDeNavegacaoChange(Sender: TObject);
begin
  inherited;

  //Contador
  tsCadastro.Caption := GetDescritivoNavegacao;

  if DSCadastro.DataSet.State in [dsEdit, dsInsert] then
    Exit;

  fraPerfilTrib.CampoCodigo     := DSCadastro.DataSet.FieldByName('CIDADE');
  fraPerfilTrib.sCampoDescricao := 'NOME';
  fraPerfilTrib.sTabela         := 'MUNICIPIOS';
  fraPerfilTrib.CarregaDescricao;

end;

procedure TFrmFichaCadastros.SMALL_DBEdit2Exit(Sender: TObject);
begin
  inherited;
  if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') then
    sNomeDoArquivoParaSalvar := 'contatos\'+Trim(LimpaLetrasPor_(Form7.ibDataSet2NOME.AsString))+'.txt'; // Lendo o arquivo para mostrar na tela

  if ((TSMALL_DBEdit(Sender).DataField = 'NOME') or (TSMALL_DBEdit(Sender).DataField = 'CREDITO')) then
     DefinirLimiteDisponivel;
end;

procedure TFrmFichaCadastros.SMALL_DBEdit5KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  RemoveEspacoNoInicio(Sender);
end;

procedure TFrmFichaCadastros.SMALL_DBEdit6KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  RemoveEspacoNoInicio(Sender);
end;

procedure TFrmFichaCadastros.SMALL_DBEdit7Change(Sender: TObject);
begin
  inherited;
  if (Form7.ibDataSet39.Active) then
  begin
    Form7.ibDataSet39.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TFrmFichaCadastros.tsFotoShow(Sender: TObject);
begin
  inherited;
  sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet2REGISTRO.AsString+'.jpg';
end;

end.
