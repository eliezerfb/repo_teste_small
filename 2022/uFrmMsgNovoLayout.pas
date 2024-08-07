unit uFrmMsgNovoLayout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TFrmMsgNovoLayout = class(TForm)
    imgFundo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    imgOK: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure imgOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMsgNovoLayout: TFrmMsgNovoLayout;

implementation

{$R *.dfm}

procedure TFrmMsgNovoLayout.imgOKClick(Sender: TObject);
begin
  Close;
end;

end.
