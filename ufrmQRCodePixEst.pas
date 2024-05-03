unit ufrmQRCodePixEst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

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

uses uQrCode;

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

procedure TFrmQRCodePixEst.FormShow(Sender: TObject);
begin
  btnConfirmar.SetFocus;
end;

end.
