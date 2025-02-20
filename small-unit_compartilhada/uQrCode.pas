unit uQrCode;

interface

uses
  Winapi.Windows, DelphiZXingQRCode, Vcl.Graphics;

  procedure GeraImagemQRCode(QRCodeData: String; APict: TBitMap);

implementation


procedure GeraImagemQRCode(QRCodeData: String; APict: TBitMap);
var
  QRCode: TDelphiZXingQRCode;
  QRCodeBitmap: TBitmap;
  Row, Column: Integer;
begin
  QRCode       := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    QRCode.QuietZone := 2; // Sandro Silva 2018-03-16  1;
    QRCode.Encoding  := qrUTF8BOM;// Aplicativo De olho na Nota 4.1.1 P não consegue ler QRCode com qrUTF8NoBOM Sandro Silva 2022-11-01 qrUTF8NoBOM;
    QRCode.Data      := widestring(QRCodeData);// Sandro Silva 2022-11-01 QRCodeData;

    QRCodeBitmap.Width  := QRCode.Columns;
    QRCodeBitmap.Height := QRCode.Rows;

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
        else
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
      end;
    end;

    APict.Assign(QRCodeBitmap);
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
  end;
end;

end.
