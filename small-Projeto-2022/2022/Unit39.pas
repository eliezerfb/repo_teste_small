unit Unit39;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm39 = class(TForm)
    Panel1: TPanel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form39: TForm39;

implementation

uses Unit14;

{$R *.DFM}




procedure TForm39.FormShow(Sender: TObject);
begin
  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  CheckBox5.Checked := False;
  CheckBox6.Checked := False;
  Form39.Width := 180;
  Form39.Left  := Form14.Left + Form14.Width - Form39.Width;
  Form39.Top   := Form14.Top  + Form14.Height + 2;
end;


procedure TForm39.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckBox1.Visible := False;
  CheckBox2.Visible := False;
  CheckBox3.Visible := False;
  CheckBox4.Visible := False;
  CheckBox5.Visible := False;
  CheckBox6.Visible := False;
end;

end.
