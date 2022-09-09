unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SmallFunc;

type
  TForm1 = class(TForm)
    Discar: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label2: TLabel;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    Label5: TLabel;
    Button1: TButton;
    Label1: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    Label4: TLabel;
    Button2: TButton;
    TabSheet5: TTabSheet;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  hCommFile: THandle;
  NumberWritten: DWORD;
  s : String;
begin
  //
  // AT - Atenção, comandos serão enviados
  // D - Discar
  // T - Utilizar discagem tipo TOM
  // Edit1.Text - Número que se deseja discar
  // <cr> - Terminator informando o fim da string
  // &F - Configuração de fabrica
  //
  hCommFile:= CreateFile( PChar(AllTrim(Combobox1.text)), GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if hCommFile = INVALID_HANDLE_VALUE then //Verifica a abertura da porta
  begin
    memo1.lines.clear;
    memo1.lines.add('Não foi possível abrir a porta selecionada.');
    memo1.lines.add('Discagem não efetuada');
    CloseHandle(hCommFile);
  end
  else
  begin
    //
    memo1.lines.add('Discando...');
    //
    // Aguardar sinal antes de discar
    //
    if radiobutton2.checked then s:='ATDP' else s:='ATDT'; // Tom ou Pulos
    //
    s := s + StrTran(StrTran(StrTran(AllTrim(Edit1.text),'xx',AllTrim(Edit6.Text)),'(',''),')','');
    s := StrTran(s,Copy(Edit5.Text,1,1)+Edit6.Text+Copy(Edit5.Text,2,3),'');
    //
    ShowMessage(s);
    //
    Memo1.lines.add(s);
    NumberWritten:=0;
    WriteFile( hCommFile,PChar( s + #13#10)[0], Length(s)+2, NumberWritten, nil);
    memo1.lines.add('Aguardando Atendimento ...');
    MessageDlg('Retire o telefone do gancho e clique OK para desligar o modem',mtInformation,[mbok], 0);
    WriteFile(hCommFile,'ATH'#13#10,5,NumberWritten,nil); //Desconecta a ligação (Hangup)
    CloseHandle(hCommFile); //Fecha a porta de Comunicação
    Memo1.lines.add('Modem Desconectado.');
    //
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Form1.Top  := 95;
  Form1.Left := Screen.Width - Form1.Width;

  if ParamCount > 0 then
  begin
    Edit1.Text := ParamStr(1);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  hCommFile: THandle;
  NumberWritten: DWORD;
begin
  //
  hCommFile:= CreateFile( PChar(AllTrim(Combobox1.text)), GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  NumberWritten:=0;
  WriteFile( hCommFile,PChar( Edit2.Text + #13#10)[0], Length(AllTrim(Edit2.Text))+2, NumberWritten, nil);
  ShowMessage('Ok');
  WriteFile(hCommFile,'ATH',5,NumberWritten,nil); //Desconecta a ligação (Hangup)
  CloseHandle(hCommFile); //Fecha a porta de Comunicação
  //
end;

end.

