unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TForm3 = class(TForm)
    Label3: TLabel;
    ComboBox3: TComboBox;
    ComboBox1: TComboBox;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses pesado1;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  //Inicializa Porta Serial
  ComboBox3.items.append('COM1');
  ComboBox3.items.append('COM2');
  ComboBox3.items.append('COM3');
  ComboBox3.items.append('COM4');
  ComboBox3.items.append('COM5');
  ComboBox3.items.append('COM6');
  ComboBox3.items.append('COM7');
  ComboBox3.items.append('COM8');
  ComboBox3.items.append('COM9');
  ComboBox3.items.append('COM10');
  ComboBox3.Text:= 'COM1';

  //Define Modelo da Balança
  ComboBox1.items.append('URANO 10 ou 11');
  ComboBox1.items.append('URANO 6');
  ComboBox1.items.append('URANO 12 Ou UDC POP');
  ComboBox1.items.append('US POP');
  ComboBox1.items.append('CP POP L0');
  ComboBox1.items.append('CP POP1');
  ComboBox1.items.append('URANO C');
  ComboBox1.Text := 'URANO 12 Ou UDC POP';
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  Mais1ini : TIniFile;
begin
  //
  Form1.sPorta    := ComboBox3.Text;
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('BALANCA','MARCA','URANO');
  Mais1ini.WriteString('URANO','Porta' ,Form1.sPorta);
  Mais1ini.WriteString('URANO','Modelo',Combobox1.Text);
  //
  Mais1ini.Free;
  //
  Close;
  Form1.FormActivate(Sender);
  //

end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Close;
  Form1.FormActivate(Sender);
end;

end.
