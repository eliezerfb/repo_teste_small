unit smallftp;
(*
O componente IdHTTP precisa estar com a propriedade HandleRedirects = True
  essa propriedade é necessária para que o redicionamento na pagina funcione
  senão retorna erro "302 not found"
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, SmallFunc, Db, DBTables, ShellApi,
  Grids, DBGrids, Gauges, IdBaseComponent, jpeg, IdTCPConnection,  XPMan,
  URLMON, IniFiles, IdComponent, IdTCPClient, IdHTTP, IdGlobal, LbClass,
  LbCipher, IdHashMessageDigest;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Gauge1: TGauge;
    Label6: TLabel;
    XPManifest1: TXPManifest;
    Button1: TButton;
    Button2: TButton;
    LbBlowfish1: TLbBlowfish;
    IdHTTP: TIdHTTP;
    Image1: TImage;
    procedure IdFTP1Connected(Sender: TObject);
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label16MouseLeave(Sender: TObject);
    procedure Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label16MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdHTTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdHTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sArquivo : String;
    sPasta, sAtual : String;
    STime: TDateTime;
    AverageSpeed: Double;
    BytesParaTransferir : Integer;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

//
// no link atual incluir hash=2C6DF307DF6F6D911FFB4972C7FBE483
//
function MD5Arquivo(const FileName: String): String;
// uses IdHashMessageDigest
var
   Arquivo: TMemoryStream;
   MD5: TIdHashMessageDigest5;
begin
   Arquivo := TMemoryStream.Create;
   Arquivo.LoadFromFile(FileName);

   MD5 := TIdHashMessageDigest5.Create;
   Result := MD5.AsHex(MD5.HashValue(Arquivo));
   FreeAndNil(Arquivo);
   FreeAndNil(MD5);
end;

function DownloadDoArquivo(pP1: String; pP2: String) : Boolean;
begin
  try
    UrlDownloadToFile(nil, PChar(pP1),PChar(pP2), 0, nil);
  except end;
  Result :=True;
end;

procedure TForm1.IdFTP1Connected(Sender: TObject);
begin
  Label6.Caption := 'Conectado';
end;

procedure TForm1.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
//  StatusBar1.SimpleText := AStatusText;
end;

procedure TForm1.IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
//Var
//  H, M, S, MS: Word;
begin
 (* //
  DecodeTime((Now - sTime), H, M, S, MS);
  if (S + M * 60 + H * 3600) <> 0 then AverageSpeed := AWorkCount / 1024 / ((S + M * 60 + H * 3600 + MS / 1000));
  //
  try
    if (100 * AWorkCount div BytesParaTransferir)  > 0 then
    begin
      Gauge1.Progress := (100 * AWorkCount div BytesParaTransferir);
    end;
  except end;
  //
  try
    if Gauge1.Progress > 0 then
    begin
      Label6.Caption :='Velocidade de transmissão: ' + FormatFloat('0.00 KB/s', AverageSpeed) + '; tempo restante: ' + TimeToStr(((Now - sTime)/ Gauge1.Progress) * (Gauge1.MaxValue - Gauge1.Progress));
    end else
    begin
      Label6.Caption :='Velocidade de transmissão: ' + FormatFloat('0.00 KB/s', AverageSpeed) + '; tempo restante: ' + TimeToStr(((Now - sTime)/ Gauge1.Progress) * (Gauge1.MaxValue - Gauge1.Progress));
  //    Label6.Caption  := 'Velocidade de transmissão: ' + FormatFloat('0.00 KB/s', AverageSpeed);
    end;
  except end;
  //
  Application.ProcessMessages;
  if Button1.Tag = 1 then Abort;
  //       *)
end;

procedure TForm1.IdFTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
 (* STime := Now;
//  if AWorkCountMax > 0 then ProgressBar1.Max := AWorkCountMax
//  else
//  ProgressBar1.Max := AWorkCountMax;
  AverageSpeed := 0;  *)
end;

procedure TForm1.Label2MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm1.Label16MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm1.Label2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm1.Label16MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //
  Button1.Tag := 1;
  Close;
  //
  if Button1.Caption = 'Finalizar' then
  begin
    ShellExecute( 0, 'Open','Small Commerce.exe',pChar('restore-o '+sARquivo),'',SW_HIDE);
  end;
  //
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   iI    : Integer;
//   bOk      : Boolean;
   SmallIni : tIniFile;
   sHost, sSenha: String;
   MS: TMemoryStream;
begin
  //
  try
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small21.exe' , SW_HIDE );
  except end;
  //
  try
    //
    Form1.LbBlowfish1.GenerateKey(sPasta);
    Screen.Cursor             := crHourGlass;                   // Cursor de Aguardo
    //
    if FileExists(sAtual+'\'+'1.php') then
    begin
      SmallIni := TIniFile.Create(sAtual+'\'+'1.php');
      sHost := LbBlowfish1.DecryptString(SmallIni.ReadString('3','1',''))+LbBlowfish1.DecryptString(SmallIni.ReadString('3','4',''));
      sSenha := LbBlowfish1.DecryptString(SmallIni.ReadString('3','3',''));
    end;
    //
    //
  except
    //
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      Form1.DestroyWindowHandle;
      //
      Screen.Cursor := crDefault;
      ShellExecute( 0, 'Open','http://www.smallsoft.com.br/atualiza.htm','','',SW_SHOW);
      //
      Halt(1);
      Abort;
      //
    end;
    //
  end;

  Button2.Visible := False;

  try
    for iI := 1 to ParamCount do
    begin
      //
      sArquivo := LowerCase(ParamStr(iI));
      Label1.Caption  := 'Verificando o arquivo '+sArquivo+', aguarde ...';
      Label6.Caption  := '';
      Label1.Repaint;
      Label6.Repaint;
      //
      //bOk := False;
      //
(*      if FileExists(sArquivo) then
      begin
        if IdFTP1.Size(sArquivo) = FileSizeByName(sArquivo) then
        begin
          bOk := True;
        end;
      end;*)
      MS := TMemoryStream.Create;

      if FileExists(sArquivo) then
        IdHTTP.Get(sHost+'/redirectdownload.php?pw='+sSenha+
                                              '&arquivo='+sArquivo+
                                              '&hash='+MD5Arquivo(sArquivo)+
                                              '&tamanho='+IntToStr(FileSizeByName(sArquivo))+
                                              '&data='+ FormatDateTime('yyyymmddhhnnss',FileDateToDateTime(FileAge(sArquivo))),MS)
      else
        IdHTTP.Get(sHost+'/redirectdownload.php?pw='+sSenha+'&arquivo='+sArquivo,MS); //
      if MS.Size > 0 then
      begin
        //
        MS.SaveToFile(sArquivo);
        //
        Screen.Cursor             := crDefault;
        Label6.Caption := 'O arquivo '+pChar(sArquivo)+chr(10)+' foi instalado com sucesso.';
        Gauge1.Progress := 100;
        //
        Label1.Caption  := 'Descompactando o arquivo '+sArquivo+', aguarde ...';
        Label6.Caption  := 'Aguarde descompactando o arquivo: '+chr(10)+sArquivo;
        Gauge1.Progress := 0;
        //
        Label6.Repaint;
        Label1.Repaint;
        Gauge1.Repaint;
        //
        if Pos('.sma',sArquivo) <> 0 then
        begin
          ShellExecute( 0, 'Open','smallzip.exe',pChar('restore-o '+sARquivo),'',SW_HIDE);
        end;
        Label1.Caption := '';
        //
      end;
      MS.Free;
    end;
    //
    Label1.Caption  := 'Todos os arquivos do Small Commerce, estão atualizados'+Chr(10)+'com a "release" mais recente disponível.';
    Button1.Caption := 'Finalizar';
    //
    //
  except
    //
    if Button1.Tag <> 1 then
    begin
      ShowMessage('Não foi possível fazer o download do arquivo '+sArquivo+', se for necessário'+Chr(10)+'atualize o seu programa.');
      Screen.Cursor             := crDefault;
      ShellExecute( 0, 'Open','http://www.smallsoft.com.br/atualiza.htm','','',SW_SHOW);
    end;
    Close;
  end;
  //
  Close;
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  I, Z : Integer;
begin
  //
  GetDir(0,Form1.sAtual);
  I := Random(12);
  //
  try
    //
    for Z := 0 to StrToInt(Copy(TimetoStr(Time),7,2)) do
    begin
      I := Random(12);
    end;
    //
    if FileExists(Form1.sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp') then
    begin
      Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp');
      Form1.Image1.Repaint;
    end;
    //
  except end;
  //
  try
    DownloadDoArquivo(PChar('http://www.smallsoft.com.br/1.php'),PChar('1.php'));
  except end;
  //
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sPasta  := 'FFEAA766654488992624076BDF9907FBBDEFF3CF616D352280FD6F0E13A59109D7761E3E0492EAB3DF38EB6D125451C36662933A3AC0D5AAC6AC4F926E89'+
             'F717DFB1F4CB28B1D11CD44517DDDC1A3D21AA1004C13FC87E952322E73E2A969A7240A51F324E11EC8D9B9367B1C28A69035EABD45C33FD522C21A798BE4F49B95B';
  Form1.WindowState := wsMaximized;
end;

procedure TForm1.IdHTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
Var
  H, M, S, MS: Word;
begin
  //
  DecodeTime((Now - sTime), H, M, S, MS);
  if (S + M * 60 + H * 3600) <> 0 then AverageSpeed := AWorkCount / 1024 / ((S + M * 60 + H * 3600 + MS / 1000));
  //
  Gauge1.Progress := AWorkCount;
  //
  try
    Label6.Caption := 'Velocidade de transmissão: ' + FormatFloat('0.00 MB/s', (AverageSpeed / 1024) ) + chr(10) +
                      'Tempo restante: ' + TimeToStr(((Now - sTime)/ Gauge1.Progress) * (Gauge1.MaxValue - Gauge1.Progress));
  except end;
  //
  Application.ProcessMessages;
  if Button1.Tag = 1 then Abort;
end;

procedure TForm1.IdHTTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  STime := Now;
  Label1.Caption  := 'Atualizando arquivo '+sArquivo+', aguarde ...';
  Label6.Caption  := 'Aguarde fazendo o download do arquivo '+sArquivo;

  Gauge1.MaxValue := AWorkCountMax;
  Gauge1.Progress := 0;

  Label6.Repaint;
  Label1.Repaint;
  Gauge1.Repaint;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Button2.SetFocus;
//  Button2Click(Sender);
end;

end.




