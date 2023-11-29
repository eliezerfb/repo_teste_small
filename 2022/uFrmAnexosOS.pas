unit uFrmAnexosOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Buttons, Grids, DBGrids, DB, JPEG,
  IBCustomDataSet, ExtCtrls, ImgList;

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
    Panel1: TPanel;
    imgAnexoOS: TImage;
    OpenDlgAnexo: TOpenDialog;
    procedure dbgPrincipalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgPrincipalCellClick(Column: TColumn);
    procedure Button22Click(Sender: TObject);
    procedure DSAnexosOSDataChange(Sender: TObject; Field: TField);
  private
    procedure CarregaVisualizacao;
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
    try
      ibdAnexosOS.Append;
      ibdAnexosOSIDANEXO.AsString := IncGenerator(ibdAnexosOS.Database,'G_OSANEXOS');
      ibdAnexosOSIDOS.AsInteger := IDOS;
      ibdAnexosOSNOME.AsString := ExtractFileName(OpenDlgAnexo.FileName);
      TBlobField(ibdAnexosOSANEXO).LoadFromFile(OpenDlgAnexo.FileName);
      ibdAnexosOS.Post;
    except
      MensagemSistema('Erro ao gravar anexo!',msgErro);
    end;
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

    if AnsiContainsText(ibdAnexosOSNOME.AsString,'.png') then
    begin
      {
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
      }
    end;

    //Texto
    if AnsiContainsText(ibdAnexosOSNOME.AsString,'.txt') then
    begin

      
    end;
  except
  end;
end;

end.
