unit ufrmSobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TfrmSobre = class(TForm)
    pnlFundo: TPanel;
    pnlCarregamento: TPanel;
    imgFundo: TImage;
    Image1: TImage;
    imgOK: TImage;
    lblOK: TLabel;
    lblLicenca: TLabel;
    redtSobre: TRichEdit;
    Image2: TImage;
    procedure lblOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
  end;

var
  frmSobre: TfrmSobre;

implementation

{$R *.dfm}

procedure TfrmSobre.FormCreate(Sender: TObject);
begin
  Self.Align := AlNone;
  Self.AutoSize := False;
  Self.WindowState := wsNormal;
  Self.Top := 0;
  Self.Left := 0;
  Self.Width := Screen.Width;
  Self.Height := Screen.Height;

  pnlCarregamento.Visible := False;
  redtSobre.Width    := 623;
end;

procedure TfrmSobre.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    Close;
end;

procedure TfrmSobre.FormResize(Sender: TObject);
begin
  pnlCarregamento.Left    := (Self.Width div 2) - (pnlCarregamento.Width div 2) ;
  pnlCarregamento.Top     := (Self.Height div 2) - (pnlCarregamento.Height div 2);
  pnlCarregamento.Visible := True;
end;

procedure TfrmSobre.lblOKClick(Sender: TObject);
begin
  Self.Close;
end;

end.
