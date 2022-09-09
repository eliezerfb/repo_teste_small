unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, iNiFiles, SmallFunc, jpeg;

type
  TForm2 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Label5: TLabel;
    ComboBox5: TComboBox;
    Label6: TLabel;
    ComboBox6: TComboBox;
    Image8: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses pesado1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  Mais1ini : TIniFile;
begin
  //
  if ComboBox4.Text = '2400' then  Form1.iBaudRate := 0;
  if ComboBox4.Text = '4800' then  Form1.iBaudRate := 1;
  if ComboBox4.Text = '9600' then  Form1.iBaudRate := 2;
  if ComboBox4.Text = '1200' then  Form1.iBaudRate := 3;
  if ComboBox4.Text = '19200' then Form1.iBaudRate := 4;
  if ComboBox2.Text = 'P05B' then Form1.sTipo := '1' else Form1.sTipo := '0';
  //
  Form1.sPorta    := ComboBox3.Text;
  Form1.iCasas    := StrToInt(LimpaNumero('0'+ComboBox5.Text));
  Form1.iSegundos := StrToInt(LimpaNumero('0'+ComboBox6.Text));
  //
  Mais1ini := TIniFile.Create('BALANCA.INI');
  Mais1ini.WriteString('BALANCA','MARCA','TOLEDO');
  Mais1ini.WriteInteger('TOLEDO','Casas'      ,Form1.iCasas);
  Mais1ini.WriteInteger('TOLEDO','Segundos'   ,Form1.iSegundos);
  Mais1ini.WriteInteger('TOLEDO','BaudRate',Form1.iBaudRate);
  Mais1ini.WriteString('TOLEDO','Porta'    ,Form1.sPorta);
  Mais1ini.WriteString('TOLEDO','Tipo'     ,Form1.sTipo);
  Mais1ini.WriteInteger('TOLEDO','BaudRate',Form1.iBaudRate);
  Mais1ini.WriteInteger('TOLEDO','Paridade',Form1.iParidade);
  Mais1ini.WriteInteger('TOLEDO','DataBits',Form1.iDataBits);
  Mais1ini.WriteString('TOLEDO','Modelo',Combobox1.Text);
  //
  Mais1ini.Free;
  //
  Close;
  Form1.FormActivate(Sender);
  //
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  //
  if Form1.iBaudRate = 0 then ComboBox4.Text := '2400';
  if Form1.iBaudRate = 1 then ComboBox4.Text := '4800';
  if Form1.iBaudRate = 2 then ComboBox4.Text := '9600';
  if Form1.iBaudRate = 3 then ComboBox4.Text := '1200';
  if Form1.iBaudRate = 4 then ComboBox4.Text := '19200';
  if Form1.sTipo = '1' then ComboBox2.Text := 'P05B' else ComboBox2.Text := 'P05';
  //
  ComboBox3.Text := Form1.sPorta;
  ComboBox1.Text := Form1.sModelo;
  Combobox5.Text := IntToStr(Form1.iCasas);
  Combobox6.Text := IntToStr(Form1.iSegundos);
  //
  //
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  Form2.FormShow(Sender);
  Form2.Repaint;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  //
  Image1.Visible := False;
  Image2.Visible := False;
  Image3.Visible := False;
  Image4.Visible := False;
  Image5.Visible := False;
  Image6.Visible := False;
  Image7.Visible := False;
  Image8.Visible := False;
  //
  if ComboBox1.Text = 'Balança Computadora Eletrônica modelo Prix III'          then Image1.Visible := True;
  if ComboBox1.Text = 'Balança Pesadora Eletrônica modelo 9094'                 then Image2.Visible := True;
  if ComboBox1.Text = 'Balança para check-out modelo 8217'                      then Image3.Visible := True;
  if ComboBox1.Text = 'Balança Pesadora com duplo display 2096DD'               then Image4.Visible := True;
  if ComboBox1.Text = 'Balança Pesadora Industrial 2096'                        then Image5.Visible := True;
  if ComboBox1.Text = 'Balança Pesadora, Contadora e Verificadora 2180 Carbono' then Image6.Visible := True;
  if ComboBox1.Text = 'Balança Pesadora, Contadora e Verificadora 2090 Carbono' then Image7.Visible := True;
  if ComboBox1.Text = 'Balança Computadora, Bematech SA-110'                    then Image8.Visible := True;
  //
end;

procedure TForm2.ComboBox1Click(Sender: TObject);
begin
  Form2.FormShow(Sender);
  Form2.Repaint;
end;

end.


