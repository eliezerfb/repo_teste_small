unit ufrmQRCodePixEst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Buttons;

  function PagamentoQRCodePIX(ChaveQrPIX:string; Valor : double) : Boolean;

type
  TFrmQRCodePixEst = class(TForm)
    btnCancel: TBitBtn;
    Memo1: TMemo;
    lblValor: TLabel;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmQRCodePixEst: TFrmQRCodePixEst;

implementation

{$R *.dfm}

function PagamentoQRCodePIX(ChaveQrPIX:string; Valor : double) : Boolean;
begin
  Result := False;

  try
    FrmQRCodePixEst := TFrmQRCodePixEst.Create(nil);
    FrmQRCodePixEst.Memo1.Lines.Text := ChaveQrPIX;
    FrmQRCodePixEst.lblValor.Caption := 'R$ '+ FormatFloat( '#,##0.00', Valor);
    FrmQRCodePixEst.ShowModal;
  finally
    FreeAndNil(FrmQRCodePixEst);
  end;
end;


procedure TFrmQRCodePixEst.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
