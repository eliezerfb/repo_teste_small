unit uFrmAnexosOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Buttons, Grids, DBGrids, DB, JPEG, pngimage,
  IBCustomDataSet, ExtCtrls, ImgList, ShellAPI, Videocap, Clipbrd;

type
  TFrmAnexosOS = class(TFrmPadrao)
    dbgPrincipal: TDBGrid;
    Button22: TBitBtn;
    Button13: TBitBtn;
    DSAnexosOS: TDataSource;
    ibdAnexosOS: TIBDataSet;
    ibdAnexosOSIDANEXO: TIntegerField;
    ibdAnexosOSIDOS: TIntegerField;
    ibdAnexosOSNOME: TIBStringField;
    ibdAnexosOSANEXO: TMemoField;
    ImageList: TImageList;
    pnlArquivo: TPanel;
    imgAnexoOS: TImage;
    OpenDlgAnexo: TOpenDialog;
    memAnexoOS: TMemo;
    VideoCap1: TVideoCap;
    procedure dbgPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgPrincipalCellClick(Column: TColumn);
    procedure Button22Click(Sender: TObject);
    procedure DSAnexosOSDataChange(Sender: TObject; Field: TField);
    procedure dbgPrincipalDblClick(Sender: TObject);
    procedure memAnexoOSDblClick(Sender: TObject);
    procedure pnlArquivoDblClick(Sender: TObject);
    procedure imgAnexoOSDblClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
  private
    procedure CarregaVisualizacao;
    procedure AbreAnexo;
    procedure SalvaImagemBD(dirImagem: string; Numerado : boolean = false);
    { Private declarations }
  public
    { Public declarations }
    IDOS : integer;
  end;

var
  FrmAnexosOS: TFrmAnexosOS;

implementation

uses Unit7, uDialogs, uFuncoesBancoDados, StrUtils;

{$R *.dfm}

procedure TFrmAnexosOS.dbgPrincipalDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with (Sender as TDBGrid).Canvas do
  begin
    if (gdSelected in State) then
    begin
      FillRect(Rect);
      Font.Color := clBlack;
      Brush.Color := clWhite;
     end;
  end;

  (Sender as TDBGrid).Canvas.FillRect(Rect);
  (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);

  if UpperCase(Column.Title.Caption) = '' then
  begin
    (Sender as TDBGrid).Canvas.FillRect(Rect);

    (Sender as TDBGrid).Canvas.Font.Color := clWindow;
    (Sender as TDBGrid).Canvas.Brush.Color := clBlack;

    ImageList.Draw((Sender as TDBGrid).Canvas, Rect.Left + 6, Rect.Top + 1, 0);
  end;
end;

procedure TFrmAnexosOS.FormShow(Sender: TObject);
begin
  inherited;
  
  ibdAnexosOS.ParamByName('IDOS').AsInteger := IDOS;
  ibdAnexosOS.Open;
end;

procedure TFrmAnexosOS.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ibdAnexosOS.Close;
end;

procedure TFrmAnexosOS.dbgPrincipalCellClick(Column: TColumn);
begin
  if UpperCase(Column.Title.Caption) = '' then
  begin
    if ibdAnexosOS.IsEmpty then
      Exit;

    if Application.MessageBox(PChar('Deseja excluir este registro?'),PChar('Aviso'),20) = IDYES then
    begin
      ibdAnexosOS.Delete;
      ibdAnexosOS.Close;
      ibdAnexosOS.Open;
    end;
  end;
end;

procedure TFrmAnexosOS.Button22Click(Sender: TObject);
begin
  OpenDlgAnexo.Execute;

  if FileExists(OpenDlgAnexo.FileName) then
  begin
    SalvaImagemBD(OpenDlgAnexo.FileName);
  end;
end;

procedure TFrmAnexosOS.DSAnexosOSDataChange(Sender: TObject;
  Field: TField);
begin
  CarregaVisualizacao;
end;

procedure TFrmAnexosOS.CarregaVisualizacao;
var
  Stream : TMemoryStream;
  JPEGImage: TJPEGImage;
begin
  try
    imgAnexoOS.Visible := False;
    memAnexoOS.Visible := False;
    pnlArquivo.Caption := ibdAnexosOSNOME.AsString;

    //Imagem
    if AnsiContainsText(ibdAnexosOSNOME.AsString,'.jpg') then
    begin
      try
        Stream := TMemoryStream.Create;
        JPEGImage := TJPEGImage.Create;
        TBlobField(ibdAnexosOSANEXO).SaveToStream(Stream);
        Stream.Position := 0;
        JPEGImage.LoadFromStream(Stream);

        imgAnexoOS.Picture.Assign(JPEGImage);
      finally
        FreeAndNil(Stream);
        FreeAndNil(JPEGImage);
      end;

      //imgAnexoOS
      imgAnexoOS.Visible := True;
    end;

    //Texto
    if (AnsiContainsText(ibdAnexosOSNOME.AsString,'.txt')) then
    begin
      memAnexoOS.Visible := True;
      memAnexoOS.Lines.Text := UTF8Decode(ibdAnexosOSANEXO.AsString);
      if memAnexoOS.Lines.Text = '' then
        memAnexoOS.Lines.Text := ibdAnexosOSANEXO.AsString;
    end;
  except
  end;
end;

procedure TFrmAnexosOS.AbreAnexo;
var
  Stream : TMemoryStream;
  DirArquivo, NomeArquivo : string;

  DiretorioTemp : PChar;
  TempBuffer    : Dword;
begin
  try
    try
      Stream := TMemoryStream.Create;
      TBlobField(ibdAnexosOSANEXO).SaveToStream(Stream);
      Stream.Position := 0;
      NomeArquivo := ibdAnexosOSNOME.AsString;

      //Salva na pasta temporaria do windows
      TempBuffer := 255;
      GetMem(DiretorioTemp,255);
      GetTempPath(tempbuffer,diretoriotemp);
      DirArquivo := DiretorioTemp;

      if FileExists(DirArquivo+NomeArquivo) then
        DeleteFile(DirArquivo+NomeArquivo);

      Stream.SaveToFile(DirArquivo+NomeArquivo);

      ShellExecute( 0, 'Open', pChar(DirArquivo+NomeArquivo), '', '', SW_SHOWMAXIMIZED);

    finally
      FreeAndNil(Stream);
      FreeMem(diretoriotemp);
    end;
  except
  end;
end;


procedure TFrmAnexosOS.dbgPrincipalDblClick(Sender: TObject);
begin
  AbreAnexo;
end;

procedure TFrmAnexosOS.memAnexoOSDblClick(Sender: TObject);
begin
  AbreAnexo;
end;

procedure TFrmAnexosOS.pnlArquivoDblClick(Sender: TObject);
begin
  AbreAnexo;
end;

procedure TFrmAnexosOS.imgAnexoOSDblClick(Sender: TObject);
begin
  AbreAnexo;
end;

procedure TFrmAnexosOS.Button13Click(Sender: TObject);
var
  jp : TJPEGImage;

  DiretorioTemp : PChar;
  TempBuffer    : Dword;
  DirArquivo : string;
begin
  if Button13.Caption <> '&Captura' then
  begin
    try
      imgAnexoOS.Visible       := False;

      try
        Videocap1.DriverIndex := 0;
      except
      end;

      try
        VideoCap1.VideoPreview := True;
        VideoCap1.CapAudio     := False;

        VideoCap1.visible      := True;
        Button13.Caption       := '&Captura';
      except
        on e:exception do
        begin
          MensagemSistema(e.Message,msgAtencao);
        end;
      end;
    except
    end;
  end else
  begin
    try
      VideoCap1.SaveToClipboard;
      imgAnexoOS.Picture.Bitmap.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
      VideoCap1.VideoPreview := False;
      VideoCap1.visible      := False;
      
      jp := TJPEGImage.Create;
      jp.Assign(imgAnexoOS.Picture.Bitmap);
      jp.CompressionQuality := 100;

      //Salva na pasta temporaria do windows
      TempBuffer := 255;
      GetMem(DiretorioTemp,255);
      GetTempPath(tempbuffer,diretoriotemp);
      DirArquivo := DiretorioTemp+'ImagemOS.jpg';

      if FileExists(DirArquivo) then
        DeleteFile(DirArquivo);

      jp.SaveToFile(DirArquivo);
      
      Button13.Caption     := '&Webcam';
      imgAnexoOS.Visible       := True;

      SalvaImagemBD(DirArquivo,True);
    except
    end;
  end;
end;

procedure TFrmAnexosOS.SalvaImagemBD(dirImagem:string; Numerado : boolean = false);
begin
  try
    ibdAnexosOS.Append;
    ibdAnexosOSIDANEXO.AsString := IncGenerator(ibdAnexosOS.Database,'G_OSANEXOS');
    ibdAnexosOSIDOS.AsInteger := IDOS;

    if Numerado then
      ibdAnexosOSNOME.AsString := 'Captura'+ibdAnexosOSIDANEXO.AsString+'.jpg'
    else
      ibdAnexosOSNOME.AsString := ExtractFileName(dirImagem);

    TBlobField(ibdAnexosOSANEXO).LoadFromFile(dirImagem);
    ibdAnexosOS.Post;
  except
    MensagemSistema('Erro ao gravar anexo!',msgErro);
  end;
end;

end.
