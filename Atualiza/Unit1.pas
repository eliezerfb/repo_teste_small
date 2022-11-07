unit Unit1;

interface

uses

  IniFiles, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DdeMan, Gauges, ShellApi,
  LzExpand, Registry, SmallFunc, TLHelp32, PsAPI, ShlObj, ComObj, ActiveX,
  LbCipher, LbClass;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel3: TPanel;
    Panel4: TPanel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox10: TCheckBox;
    ckbIBPT: TCheckBox;
    Panel5: TPanel;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Image1: TImage;
    CheckBox3: TCheckBox;
    CheckBox6: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ConsultaProcesso(sP1:String): boolean;
var
  Snapshot: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  //
  Result   := False;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (Snapshot = Cardinal(-1)) then exit;
  //
  ProcessEntry32.dwSize := SizeOf(TProcessEntry32);
  //
  // pesquisa pela lista de processos
  //
  if (Process32First(Snapshot, ProcessEntry32)) then
  repeat
    //
    // enquanto houver processos
    //
    // SubItems.Add(IntToStr(ProcessEntry32.th32ParentPro cessID));
    if ProcessEntry32.szExeFile = sP1 then Result := True;
    //
  until not Process32Next(Snapshot, ProcessEntry32);
  //
  CloseHandle (Snapshot);
  //
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  F: TextFile;
  sAtual : String;
begin
  //
  while FileExists(Pchar(sAtual+'\NFSE\smallnfse.tx2')) do
  begin
    DeleteFile(Pchar(sAtual+'\meuftp.txt'));
    Sleep(1000);
  end;
  //
  // Cria o arquivo meuftp.txt
  //
  GetDir(0,sAtual);
  AssignFile(F,pChar(sAtual+'\meuftp.txt'));  // Direciona o arquivo F para meuftp.txt
  Rewrite(F);
  //
  Writeln(F,'smallftp');
  Writeln(F,'q1OHjtEGhDeBsQkSk2+LJg==');
  Writeln(F,'cd /publico');
  Writeln(F,'');
  Writeln(F,'put "c:\Projeto 2022\2022\log.txt"');
  Writeln(F,'');
  //
  if CheckBox1.Checked then Writeln(F,'put c:\reduzida\20221001.sma');
  if CheckBox2.Checked then Writeln(F,'put c:\reduzida\20221002.sma');
  if CheckBox3.Checked then Writeln(F,'put c:\reduzida\20221003.sma');
  if CheckBox4.Checked then Writeln(F,'put c:\reduzida\20221004.sma');
  if CheckBox5.Checked then Writeln(F,'put c:\reduzida\20221005.sma');
  if CheckBox6.Checked then Writeln(F,'put c:\reduzida\20221006.sma');
  if CheckBox7.Checked then Writeln(F,'put c:\reduzida\20221007.sma');
  if CheckBox8.Checked then Writeln(F,'put c:\reduzida\20221008.sma');
  if CheckBox9.Checked then Writeln(F,'put c:\reduzida\20221009.sma');
  //
  if CheckBox1.Checked then Writeln(F,'put c:\reduzida\20211001.sma');
  if CheckBox2.Checked then Writeln(F,'put c:\reduzida\20211002.sma');
  if CheckBox3.Checked then Writeln(F,'put c:\reduzida\20211003.sma');
  if CheckBox4.Checked then Writeln(F,'put c:\reduzida\20211004.sma');
  if CheckBox5.Checked then Writeln(F,'put c:\reduzida\20211005.sma');
  if CheckBox6.Checked then Writeln(F,'put c:\reduzida\20211006.sma');
  if CheckBox7.Checked then Writeln(F,'put c:\reduzida\20211007.sma');
  if CheckBox8.Checked then Writeln(F,'put c:\reduzida\20211008.sma');
  if CheckBox9.Checked then Writeln(F,'put c:\reduzida\20211009.sma');
  //
  if CheckBox10.Checked then
  begin
    Writeln(F,'put c:\reduzida\nfce2022.sma');
    Writeln(F,'put c:\reduzida\nfce2021.sma');
  end;
  //
  if ckbIBPT.Checked then
  begin
    //
    Writeln(F,'put c:\reduzida\2022_ac.sma');
    Writeln(F,'put c:\reduzida\2022_al.sma');
    Writeln(F,'put c:\reduzida\2022_am.sma');
    Writeln(F,'put c:\reduzida\2022_ap.sma');
    Writeln(F,'put c:\reduzida\2022_ba.sma');
    Writeln(F,'put c:\reduzida\2022_ce.sma');
    Writeln(F,'put c:\reduzida\2022_df.sma');
    Writeln(F,'put c:\reduzida\2022_es.sma');
    Writeln(F,'put c:\reduzida\2022_go.sma');
    Writeln(F,'put c:\reduzida\2022_ma.sma');
    Writeln(F,'put c:\reduzida\2022_mg.sma');
    Writeln(F,'put c:\reduzida\2022_ms.sma');
    Writeln(F,'put c:\reduzida\2022_mt.sma');
    Writeln(F,'put c:\reduzida\2022_pa.sma');
    Writeln(F,'put c:\reduzida\2022_pb.sma');
    Writeln(F,'put c:\reduzida\2022_pe.sma');
    Writeln(F,'put c:\reduzida\2022_pi.sma');
    Writeln(F,'put c:\reduzida\2022_pr.sma');
    Writeln(F,'put c:\reduzida\2022_rj.sma');
    Writeln(F,'put c:\reduzida\2022_rn.sma');
    Writeln(F,'put c:\reduzida\2022_ro.sma');
    Writeln(F,'put c:\reduzida\2022_rr.sma');
    Writeln(F,'put c:\reduzida\2022_rs.sma');
    Writeln(F,'put c:\reduzida\2022_sc.sma');
    Writeln(F,'put c:\reduzida\2022_se.sma');
    Writeln(F,'put c:\reduzida\2022_sp.sma');
    Writeln(F,'put c:\reduzida\2022_to.sma');
  end;
  //
  Writeln(F,'quit');
  //
  CloseFile(F);
  //
  // Aguarda até criar o arquivo
  //
  while not FileExists(pChar(sAtual+'\meuftp.txt')) do
  begin
    Sleep(100);
  end;
  //
  if ckbIBPT.Checked then
  begin
    //
    ShellExecute( Application.Handle, 'runas',pChar(sAtual+'\ibpt\renomear.bat'),'','', SW_SHOWNORMAL);
    //
    while ConsultaProcesso('cmd.exe') do
    begin
      Application.ProcessMessages;
      sleep(100);
    end;
    //
  end;
  //
  if FileExists(sAtual+'\meuftp.txt') then
    ShellExecute( Application.Handle, 'runas',pChar(sAtual+'\atualiza_.bat'),'','', SW_SHOWNORMAL);
  //
  while ConsultaProcesso('cmd.exe') do
  begin
    Application.ProcessMessages;
    sleep(100);
  end;
  //
  // ShellExecute( 0, 'Open',pChar('C:\My Installations\My Installations\_Small Commerce 2022_.ipr'),'','', SW_SHOWNORMAL);
  //
  ShellExecute( Application.Handle, 'Open',pChar('C:\Program Files (x86)\InstallShield\Professional 7.0\Program\BIN\ISPIde.exe'),pChar('C:\My Installations\My Installations\_Small Commerce 2022_\_Small Commerce 2022_.ipr'),'', SW_SHOWNORMAL);
  //
  while ConsultaProcesso('ISPIde.exe') do
  begin
    Application.ProcessMessages;
    sleep(100);
  end;
  //
  ShellExecute( Application.Handle, 'Open',pChar(sAtual+'\cdzip_.bat'),'','', SW_SHOWNORMAL);
  //
  while ConsultaProcesso('cmd.exe') do
  begin
    Application.ProcessMessages;
    sleep(100);
  end;
  //
  Close;
  //
  // Falta automatizar isso
  //
  // quando ternimar rodar o 'C:\Users\Ronei Ivo Weber\Desktop\+ Usados\Instalação\InstallShield Pro 7\InstallShieldProfessional700.exe'
  // depois criar o cd2022_exe
  // depois rodar o cd_
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //
  Winexec('TASKKILL /F /IM "cmd.exe"' , SW_HIDE ); // Timer2Timer
  //
end;

end.



