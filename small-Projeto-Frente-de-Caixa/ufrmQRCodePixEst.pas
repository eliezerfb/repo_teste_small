unit ufrmQRCodePixEst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Printers;

  function PagamentoQRCodePIX(ChaveQrPIX:string; Valor : double) : Boolean;

type
  TFrmQRCodePixEst = class(TForm)
    btnCancel: TBitBtn;
    lblValor: TLabel;
    lblInfo: TLabel;
    Label1: TLabel;
    btnConfirmar: TBitBtn;
    btnImprimir: TBitBtn;
    imgQrCode: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
    PixConfirmado : Boolean;
  public
    { Public declarations }
  end;

var
  FrmQRCodePixEst: TFrmQRCodePixEst;

implementation

{$R *.dfm}

uses uQrCode, FISCAL, uSmallConsts, ufuncoesfrente;

function PagamentoQRCodePIX(ChaveQrPIX:string; Valor : double) : Boolean;
begin
  Result := False;

  try
    FrmQRCodePixEst := TFrmQRCodePixEst.Create(nil);
    GeraImagemQRCode(ChaveQrPIX, FrmQRCodePixEst.imgQrCode.Picture.Bitmap);
    FrmQRCodePixEst.lblValor.Caption := 'R$ '+ FormatFloat( '#,##0.00', Valor);
    FrmQRCodePixEst.ShowModal;
    Result := FrmQRCodePixEst.PixConfirmado;
  finally
    FreeAndNil(FrmQRCodePixEst);
  end;
end;


procedure TFrmQRCodePixEst.btnCancelClick(Sender: TObject);
begin
  PixConfirmado := False;
  Close;
end;

procedure TFrmQRCodePixEst.btnConfirmarClick(Sender: TObject);
begin
  PixConfirmado := True;
  Close;
end;

procedure TFrmQRCodePixEst.btnImprimirClick(Sender: TObject);
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

procedure TFrmQRCodePixEst.FormShow(Sender: TObject);
begin
  btnConfirmar.SetFocus;
end;

end.
