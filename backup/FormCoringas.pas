unit FormCoringas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses backup, smallbac;

{$R *.DFM}

procedure TForm2.Button2Click(Sender: TObject);
begin
   Form1.FileListBox.items.add(Form2.Edit1.Text);
   Form2.Close;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  Dir:String;
begin
   Dir:='';
   if SelectDirectory('Selecione o Diretório:','',Dir) then
//   if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],0) then //, sdPrompt],0) then
      Form2.Edit1.Text := Dir+'\*.*';
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
   Form2.Close;
end;

end.
