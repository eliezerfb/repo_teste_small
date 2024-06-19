unit ufrmQRCodePixDin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Printers, IBX.IBDatabase, Vcl.Imaging.pngimage;

  function PagamentoQRCodePIXDin(ChaveQrPIX,order_id:string; Valor : double; IBDatabase: TIBDatabase) : Boolean;

type
  TFrmQRCodePixDin = class(TForm)
    btnCancel: TBitBtn;
    lblValor: TLabel;
    lblInfo: TLabel;
    btnImprimir: TBitBtn;
    imgQrCode: TImage;
    tmrConsultaPgto: TTimer;
    imgLogo: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure tmrConsultaPgtoTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    PixConfirmado : Boolean;
    OrderID : string;
  public
    { Public declarations }
  end;

var
  FrmQRCodePixDin: TFrmQRCodePixDin;

implementation

{$R *.dfm}

uses uQrCode, FISCAL, uSmallConsts, ufuncoesfrente, uIntegracaoItau,
  uPagamentoPix;

function PagamentoQRCodePIXDin(ChaveQrPIX,order_id:string; Valor : double; IBDatabase: TIBDatabase) : Boolean;
begin
  Result := False;

  try
    FrmQRCodePixDin := TFrmQRCodePixDin.Create(nil);
    GeraImagemQRCode(ChaveQrPIX, FrmQRCodePixDin.imgQrCode.Picture.Bitmap);
    FrmQRCodePixDin.lblValor.Caption := 'R$ '+ FormatFloat( '#,##0.00', Valor);
    FrmQRCodePixDin.OrderID          := order_id;
    FrmQRCodePixDin.ShowModal;
    Result := FrmQRCodePixDin.PixConfirmado;

    if FrmQRCodePixDin.PixConfirmado then
    begin
      AtualizaStatusTransacaoItau(order_id, 'Aprovado', IBDatabase);
    end else
    begin
      if CancelOrder(order_id) then
        AtualizaStatusTransacaoItau(order_id, 'Cancelado', IBDatabase);
    end;
  finally
    FreeAndNil(FrmQRCodePixDin);
  end;
end;


procedure TFrmQRCodePixDin.btnCancelClick(Sender: TObject);
begin
  PixConfirmado := False;
  Close;
end;

procedure TFrmQRCodePixDin.btnImprimirClick(Sender: TObject);
var
  iLarguraPapel, iAlturaQRCode, iLinha : integer;

  QRCodeBMP: TBitmap;
  FTamanhoPapel : string;
begin
  //Define impressora
  if Printer.Printers.Count > 0 then
  begin
    Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);

    if Trim(Form1.sImpressoraDestino) <> '' then
    begin
      try
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraDestino);
      except
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
      end;
    end;

    try
      iLarguraPapel  := Printer.PageWidth;

      FTamanhoPapel := Form1.sTamanhoPapel;

      if FTamanhoPapel <> '' then
      begin
        if FTamanhoPapel = '58' then
          iLarguraPapel := 384;
        if FTamanhoPapel = '76' then
          iLarguraPapel := 512;
        if FTamanhoPapel = '80' then
          iLarguraPapel := 576;
        if FTamanhoPapel = 'A4' then
          iLarguraPapel := 4961;
      end;

      iAlturaQRCode := 360;
      iLinha := 5;

      QRCodeBMP := imgQrCode.Picture.Bitmap;

      ResizeBitmap(QRCodeBMP, iAlturaQRCode, iAlturaQRCode, clWhite);

      try
        Printer.BeginDoc;

        Printer.Canvas.Font.Size := 12;
        Printer.Canvas.Font.Name := FONT_NAME_DEFAULT;
        SetTextAlign(Printer.Canvas.Handle, TA_CENTER);
        Printer.Canvas.TextOut((iLarguraPapel div 2) , iLinha, lblValor.Caption);

        iLinha := iLinha + Printer.Canvas.TextHeight('$') + 5;
        Printer.Canvas.Draw(((iLarguraPapel - iAlturaQRCode) div 2) + 14, iLinha, imgQrCode.Picture.Graphic);
        iLinha := iLinha + iAlturaQRCode;

        Printer.Canvas.Font.Size := 2;
        Printer.Canvas.TextOut((iLarguraPapel div 2) , iLinha+ 20, '.');
        Printer.Canvas.Font.Size := FONT_SIZE_DEFAULT;
        Printer.EndDoc;
      except
      end;


      if Trim(Form1.sImpressoraDestino) <> '' then
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
    except
    end;
  end
  else
    ShowMessage('Instale uma impressora no Windows');

end;

procedure TFrmQRCodePixDin.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
  begin
    PixConfirmado := False;
    Close;
  end;
end;

procedure TFrmQRCodePixDin.FormShow(Sender: TObject);
begin
  btnImprimir.SetFocus;
end;

procedure TFrmQRCodePixDin.tmrConsultaPgtoTimer(Sender: TObject);
var
  Status : string;
begin
  Status := GetStatusOrder(OrderID);

  if Status = 'approved' then
  begin
    PixConfirmado := True;
    Close;
  end;
end;


end.
