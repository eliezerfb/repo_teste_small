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
    chkSmallCommerce1001sma: TCheckBox;
    chkDiversos1002sma: TCheckBox;
    Panel3: TPanel;
    Panel4: TPanel;
    chknfcesetup1004sma: TCheckBox;
    chkPastaNFCe1005sma: TCheckBox;
    chkNFCeCompletonfcesma: TCheckBox;
    ckbIBPT: TCheckBox;
    Panel5: TPanel;
    chkPastaNFSe1007sma: TCheckBox;
    chknfsesetup1008sma: TCheckBox;
    chknfse1009sma: TCheckBox;
    Image1: TImage;
    chknfesetup1003sma: TCheckBox;
    chkPastaNFE1006sma: TCheckBox;
    edVersao: TEdit;
    Label1: TLabel;
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
  Writeln(F,'put "c:\Projeto ' + edVersao.Text + '\' + edVersao.Text + '\log.txt"');
  Writeln(F,'');
  //
  if chkSmallCommerce1001sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1001.sma');
  if chkDiversos1002sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1002.sma');
  if chknfesetup1003sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1003.sma');
  if chknfcesetup1004sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1004.sma');
  if chkPastaNFCe1005sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1005.sma');
  if chkPastaNFE1006sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1006.sma');
  if chkPastaNFSe1007sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1007.sma');
  if chknfsesetup1008sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1008.sma');
  if chknfse1009sma.Checked then Writeln(F,'put c:\reduzida\' + edVersao.Text + '1009.sma');
  //
  if chkSmallCommerce1001sma.Checked then Writeln(F,'put c:\reduzida\20221001.sma');
  if chkDiversos1002sma.Checked then Writeln(F,'put c:\reduzida\20221002.sma');
  if chknfesetup1003sma.Checked then Writeln(F,'put c:\reduzida\20221003.sma');
  if chknfcesetup1004sma.Checked then Writeln(F,'put c:\reduzida\20221004.sma');
  if chkPastaNFCe1005sma.Checked then Writeln(F,'put c:\reduzida\20221005.sma');
  if chkPastaNFE1006sma.Checked then Writeln(F,'put c:\reduzida\20221006.sma');
  if chkPastaNFSe1007sma.Checked then Writeln(F,'put c:\reduzida\20221007.sma');
  if chknfsesetup1008sma.Checked then Writeln(F,'put c:\reduzida\20221008.sma');
  if chknfse1009sma.Checked then Writeln(F,'put c:\reduzida\20221009.sma');
  //
  if chkSmallCommerce1001sma.Checked then Writeln(F,'put c:\reduzida\20211001.sma');
  if chkDiversos1002sma.Checked then Writeln(F,'put c:\reduzida\20211002.sma');
  if chknfesetup1003sma.Checked then Writeln(F,'put c:\reduzida\20211003.sma');
  if chknfcesetup1004sma.Checked then Writeln(F,'put c:\reduzida\20211004.sma');
  if chkPastaNFCe1005sma.Checked then Writeln(F,'put c:\reduzida\20211005.sma');
  if chkPastaNFE1006sma.Checked then Writeln(F,'put c:\reduzida\20211006.sma');
  if chkPastaNFSe1007sma.Checked then Writeln(F,'put c:\reduzida\20211007.sma');
  if chknfsesetup1008sma.Checked then Writeln(F,'put c:\reduzida\20211008.sma');
  if chknfse1009sma.Checked then Writeln(F,'put c:\reduzida\20211009.sma');
  //
  if chkNFCeCompletonfcesma.Checked then
  begin
    Writeln(F,'put c:\reduzida\nfce' + edVersao.Text + '.sma');
    Writeln(F,'put c:\reduzida\nfce2021.sma'); // Sandro Silva 2022-12-22
  end;
  //
  if ckbIBPT.Checked then
  begin
    //
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ac.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_al.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_am.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ap.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ba.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ce.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_df.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_es.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_go.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ma.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_mg.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ms.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_mt.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_pa.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_pb.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_pe.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_pi.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_pr.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_rj.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_rn.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_ro.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_rr.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_rs.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_sc.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_se.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_sp.sma');
    Writeln(F,'put c:\reduzida\' + edVersao.Text + '_to.sma');
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
  ShellExecute( Application.Handle, 'Open',pChar('C:\Program Files (x86)\InstallShield\Professional 7.0\Program\BIN\ISPIde.exe'),pChar('C:\My Installations\My Installations\_Small Commerce ' + edVersao.Text + '_\_Small Commerce ' + edVersao.Text + '_.ipr'),'', SW_SHOWNORMAL);
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



