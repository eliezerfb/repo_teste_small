unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, smallfunc, IdTCPServer, IdFTPServer, IdTCPConnection,
  IdTCPClient, IdFTP, URLMON,
  //pngimage,
  ComCtrls, clipbrd, IdHTTP, IdMultipartFormData,
  //MD5,
  IniFiles,  ShellApi,
  LbAsym, LbRSA, LbCipher, LbClass, IdBaseComponent, IdComponent;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    baixa: TButton;
    LbBlowfish1: TLbBlowfish;
    LbRSASSA1: TLbRSASSA;
    IdHTTP1: TIdHTTP;
    mandaarquivos: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure baixaClick(Sender: TObject);
    procedure mandaarquivosClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    sHost, sChave, sPath, sAtual, sCNPJ : String;
    Lista: TStringList;
    tDataT : tDateTime; 
  end;

var
  Form1: TForm1;

implementation

uses DateUtils;

{$R *.dfm}

function ListaDeArquivos(sAtual: String): TStrings;
var
  S : TSearchREc;
  I : Integer;
begin
  //
//  Result := TStringList.Create;
  Form1.Lista.Clear;
  Result := Form1.Lista;
  //
  I := FindFirst(sAtual + '\' + '*.*' ,faAnyFile, S);
  //
  while I = 0 do
  begin
    Result.Add(S.Name);
    I := FindNext(S);
  end;
  //
end;


function DownloadDoArquivo(pP1: String; pP2: String) : Boolean;
begin
  //
  try
    UrlDownloadToFile(nil, PChar(pP1),PChar(pP2), 1, nil);
  except end;
  //
  Result :=True;
  //
end;

function ArquivoConexaoSmallmobile: Boolean;
begin
  //
  try
    DownloadDoArquivo(PChar('http://www.smallsoft.com.br/3.php'),PChar('3.php'));
  except end;
  //
  Result := FileExists(Form1.sAtual+'\3.php');
  //
end;

function UploadMobile(sFile: TFileName; sEmitente: String): String;
var
  Stream: TStringStream;
  Params: TIdMultipartFormDataStream;
begin
  //
  Result := '';
  //
  try
    //
    if FileExists(sFile) then
    begin
      //
      Stream := TStringStream.Create('');
      Params := TIdMultipartFormDataStream.Create;
      //
      try
        Form1.Memo1.Lines.Add(AllTrim(AllTrim('Upload....: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(sFile+Replicate(' ',100),1,100))));
        Params.AddFile('arquivo', sFile, 'multipart/form-data');
        Params.AddFormField('emitente', sEmitente);
        Params.AddFormField('pw', Form1.sChave);
        //Params.AddFormField('imagem', sImagem);
        Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'uploadmobile.php', Params, Stream);
        Result := Stream.DataString;
      except
        on E: Exception do
        begin
          Result := 'Erro ao enviar dados para Smallmobile: ' + E.Message;
          Form1.Memo1.Lines.Clear;
          Form1.Memo1.Lines.Add(AllTrim(AllTrim('Upload....: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(Result+Replicate(' ',100),1,100))));
        end;
      end;
      //
      Params.Free;
      Stream.Free;
      //
    end;
  except end;
  //
  try
//          Form1.IdHTTP1.ClearWriteBuffer;
//          Form1.IdHTTP1.CloseWriteBuffer;
//          Form1.IdHTTP1.SendBufferSize := 1234234134;
//          Form1.IdHTTP1.Socket.
    Form1.IdHTTP1.Disconnect;
  except end;
  //
end;

function DownloadMobile(sEmitente: String; sExtensao: String): String;
var
  Stream: TStringStream;
  StreamDownload: TMemoryStream;
  Params: TIdMultipartFormDataStream;
  ParamsDownload: TIdMultipartFormDataStream;
  slDownload: TStringList;
  I: Integer;
  sArquivo: String;
  sDirAtual: String;
begin
  //
  Result := '';
  //
  try
    getDir(0, sDirAtual);
    Stream := TStringStream.Create('');
    slDownload := TStringList.Create;
    // Recupera dados criptografados para acessar site
    if Trim(Form1.sPath) = '' then Form1.sPath := '/';
    Params := TIdMultipartFormDataStream.Create;
    //
    Params.AddFormField('emitente', sEmitente); //Parâmetro contendo cnpj
    Params.AddFormField('extensao', sExtensao); //Parâmetro contendo a extensao dos arquivos a serem listados
    Params.AddFormField('pw', Form1.sChave); //Parâmetro contendo a senha para acessar as informações
    //
    // Baixa a lista de arquivos para download e salva no Stream
    //
    Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'listaarquivos.php', Params, Stream);
    //
    if Stream.DataString <> '' then Result := Stream.DataString;
    //
    slDownload.Text := Result;
    //
    for I := 0 to slDownload.Count -1 do
    begin
      if Trim(slDownload[I]) <> '' then
      begin
        //
        ParamsDownload  := TIdMultiPartFormDataStream.Create;
        //
        try
          //
          sArquivo        := StringReplace(slDownload[I], '/', '\',[rfReplaceAll]); // troca "/" por "__" para evitar problemas
          sArquivo        := StringReplace(sArquivo, '..', '',[rfReplaceAll]); // troca "/" por "__" para evitar problemas
          sArquivo        := ExtractFileName(sArquivo);
          //
          ParamsDownload.AddFormField('emitente', sEmitente); //Parâmetro contendo cnpj
          //ParamsDownload.AddFormField('arquivo', sArquivo); // Parâmetro contendo o caminho completo e o nome do arquivo a ser baixado
          ParamsDownload.AddFormField('arquivo', slDownload[I]); // Parâmetro contendo o caminho completo e o nome do arquivo a ser baixado
          ParamsDownload.AddFormField('pw', Form1.sChave); //Parâmetro contendo a senha para acessar as informações
          //
          //  ShowMessage(
          //  'emitente: '+ sEmitente + chr(10)+
          //  'arquivo: '+ sArquivo + chr(10)+
          //  'pw: '+ Form1.sChave);
          //
          StreamDownload := TMemoryStream.Create;
          // Baixa o arquivo e salva em StreamDownload
          Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'downloadarquivosmallmobile.php', ParamsDownload, StreamDownload);
          //Define o local e nome que será salvo o arquivo
          sArquivo := sDirAtual+'\'+sArquivo;
          //  ShowMessage(sArquivo);
          // Salva o arquivo em disco
          StreamDownload.SaveToFile(sArquivo);
          //
          // -------------------------------------------------------
          //
          Form1.Memo1.Lines.Add(AllTrim(AllTrim('Download..: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(sArquivo+REplicate(' ',100),1,100))));
          //
          // -------------------------------------------------------
          //
          // Adiciona o arquivo na lista para ser processado pelo retaguarda
          //
          Params := TIdMultiPartFormDataStream.Create;
          //
          Params.AddFormField('emitente', sEmitente);
          Params.AddFormField('pw', Form1.sChave);
          //Params.AddFormField('arquivo', slDownload[I]);
          // 2015-10-30 Params.AddFormField('arquivo', sArquivo);
          Params.AddFormField('arquivo', ExtractFileName(sArquivo));
          Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'deletearquivomobile.php', Params, StreamDownload);
          //
        except
          on E: Exception do
          begin
            Result := 'Erro no download: ' + E.Message;
            Form1.Memo1.Lines.Clear;
            Form1.Memo1.Lines.Add(AllTrim(AllTrim('Download..: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(Result+REplicate(' ',100),1,100))));
          end;
        end;
        //
        ParamsDownload.Free;
        //
      end;
    end;
    //
    Params.Free;
    Stream.Free;
    slDownload.Free;
    //
  except end;
  //
  try
//          Form1.IdHTTP1.ClearWriteBuffer;
//          Form1.IdHTTP1.CloseWriteBuffer;
//          Form1.IdHTTP1.SendBufferSize := 1234234134;
//          Form1.IdHTTP1.Socket.
    Form1.IdHTTP1.Disconnect;
  except end;
  //
end;

{
function DownloadMobile(sEmitente: String; sExtensao: String; slArquivos: TStringList): String;
var
  Stream: TStringStream;
  StreamDownload: TMemoryStream;
  Params: TIdMultipartFormDataStream;
  ParamsDownload: TIdMultipartFormDataStream;
  slDownload: TStringList;
  I: Integer;
  sArquivo: String;
  sDirAtual: String;
begin
  //
  Result := '';
  //
  try
    getDir(0, sDirAtual);
    Stream := TStringStream.Create('');
    slDownload := TStringList.Create;
    // Recupera dados criptografados para acessar site
    if Trim(Form1.sPath) = '' then Form1.sPath := '/';
    Params := TIdMultipartFormDataStream.Create;
    //
    Params.AddFormField('emitente', sEmitente); //Parâmetro contendo cnpj
    Params.AddFormField('extensao', sExtensao); //Parâmetro contendo a extensao dos arquivos a serem listados
    Params.AddFormField('pw', Form1.sChave); //Parâmetro contendo a senha para acessar as informações
    //
    // Baixa a lista de arquivos para download e salva no Stream
    //
    Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'listaarquivos.php', Params, Stream);
    //
    if Stream.DataString <> '' then Result := Stream.DataString;
    //
    slDownload.Text := Result;
    slArquivos.Clear;
    //
    for I := 0 to slDownload.Count -1 do
    begin
      if Trim(slDownload[I]) <> '' then
      begin
        //
        ParamsDownload  := TIdMultiPartFormDataStream.Create;
        //
        try
          //
          sArquivo        := StringReplace(slDownload[I], '/', '\',[rfReplaceAll]); // troca "/" por "__" para evitar problemas
          sArquivo        := StringReplace(sArquivo, '..', '',[rfReplaceAll]); // troca "/" por "__" para evitar problemas
          sArquivo        := ExtractFileName(sArquivo);
          //
          ParamsDownload.AddFormField('emitente', sEmitente); //Parâmetro contendo cnpj
          //ParamsDownload.AddFormField('arquivo', sArquivo); // Parâmetro contendo o caminho completo e o nome do arquivo a ser baixado
          ParamsDownload.AddFormField('arquivo', slDownload[I]); // Parâmetro contendo o caminho completo e o nome do arquivo a ser baixado
          ParamsDownload.AddFormField('pw', Form1.sChave); //Parâmetro contendo a senha para acessar as informações
          //
          //  ShowMessage(
          //  'emitente: '+ sEmitente + chr(10)+
          //  'arquivo: '+ sArquivo + chr(10)+
          //  'pw: '+ Form1.sChave);
          //
          StreamDownload := TMemoryStream.Create;
          // Baixa o arquivo e salva em StreamDownload
          Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'downloadarquivosmallmobile.php', ParamsDownload, StreamDownload);
          //Define o local e nome que será salvo o arquivo
          sArquivo := sDirAtual+'\'+sArquivo;
          //  ShowMessage(sArquivo);
          // Salva o arquivo em disco
          StreamDownload.SaveToFile(sArquivo);
          //
          // -------------------------------------------------------
          //
          Form1.Memo1.Lines.Add(AllTrim(AllTrim('Download..: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(sArquivo+REplicate(' ',100),1,100))));
          //
          // -------------------------------------------------------
          //
          // Adiciona o arquivo na lista para ser processado pelo retaguarda
          slArquivos.Add(sArquivo);
          //
          Params := TIdMultiPartFormDataStream.Create;
          //
          Params.AddFormField('emitente', sEmitente);
          Params.AddFormField('pw', Form1.sChave);
          //Params.AddFormField('arquivo', slDownload[I]);
          // 2015-10-30 Params.AddFormField('arquivo', sArquivo);
          Params.AddFormField('arquivo', ExtractFileName(sArquivo));
          Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'deletearquivomobile.php', Params, StreamDownload);
          //
        except
          on E: Exception do
          begin
            Result := 'Erro no download: ' + E.Message;
            Form1.Memo1.Lines.Clear;
            Form1.Memo1.Lines.Add(AllTrim(AllTrim('Download..: '+DateToStr(Date)+' '+TimeToStr(Time)+' '+Copy(Result+REplicate(' ',100),1,100))));
          end;
        end;
        //
        ParamsDownload.Free;
        //
      end;
    end;
    //
    Params.Free;
    Stream.Free;
    slDownload.Free;
    //
  except end;
  //
  try
//          Form1.IdHTTP1.ClearWriteBuffer;
//          Form1.IdHTTP1.CloseWriteBuffer;
//          Form1.IdHTTP1.SendBufferSize := 1234234134;
//          Form1.IdHTTP1.Socket.
    Form1.IdHTTP1.Disconnect;
  except end;
  //
end;
}


function DeleteArquivoMobile(sEmitente: String;
  sArquivo: String): String;
var
  Stream: TStringStream;
  Params: TIdMultipartFormDataStream;
  scCursor: TCursor;
begin
  //
  Result := '';
  scCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  //
  Stream := TStringStream.Create('');
  Params := TIdMultipartFormDataStream.Create;
  //
  try
    Params.AddFormField('emitente', sEmitente);
    Params.AddFormField('pw', Form1.sChave);
    Params.AddFormField('arquivo', ExtractFileName(sArquivo));
    try
      Form1.IdHTTP1.Post(Form1.sHost+Form1.sPath+'deletearquivomobile.php', Params, Stream);
      Result := Stream.DataString;
    except
      on E: Exception do
        Result := 'Erro ao excluir arquivo ' + ExtractFileName(sArquivo) + ': ' + E.Message;
    end;
  except end;
  //
  try
//          Form1.IdHTTP1.ClearWriteBuffer;
//          Form1.IdHTTP1.CloseWriteBuffer;
//          Form1.IdHTTP1.SendBufferSize := 1234234134;
//          Form1.IdHTTP1.Socket.

    Form1.IdHTTP1.Disconnect;
  except end;
  //
  Params.Free;
  Stream.Free;
  //
  Screen.Cursor := scCursor;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Dia: Integer;
  Hora, Min, Seg, cent : Word;
  TAgora : TDateTime;
begin
  //
  Timer1.Enabled := False;
  //
  try
    baixaClick(Sender);
  except end;
  //
  try
    mandaarquivosClick(Sender);
  except end;
  //
  // Mostra o tempo que o mobile já esta ativo
  //
  try
    TAgora := Now;
    DecodeTime((TAgora - tDataT), Hora, Min, Seg, cent);
    Dia  := DaysBetween(TAgora,tDataT);
    Form1.Panel1.Caption := sCNPJ + ' ativo à: ' + IntToStr(Dia)+' Dias, '+IntToStr(Hora)+' Horas, '+IntToStr(Min)+' minutos e '+IntToStr(Seg)+' segundos';
    Form1.Panel1.Repaint;
  except end;
  //
  Timer1.Enabled := True;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  SmallIni: TIniFile;
begin
  //
  tDataT := Now;
  Lista := TStringList.Create;
  //
  sCNPJ := '';
  //
  if ParamCount = 1 then
  begin
    sCNPJ := AllTrim(LimpaNumero(ParamStr(1)));
  end;
  //
  if sCNPJ <> '' then
  begin
    //
    GetDir(0,Form1.sAtual);
    //
    chdir(pChar(Form1.sAtual));
    //
    if not DirectoryExists(pchar(Form1.sAtual+'\mobile\download')) then ForceDirectories(pchar(Form1.sAtual+'\mobile\download'));
    if not DirectoryExists(pchar(Form1.sAtual+'\mobile\upload')) then ForceDirectories(pchar(Form1.sAtual+'\mobile\upload'));
    //
    if ArquivoConexaoSmallmobile then
    begin
      SmallIni := TIniFile.Create(Form1.sAtual+'\3.php');
      // Recupera dados criptografados para acessar site
      Form1.LbBlowfish1.GenerateKey(
      'FFEAA766654488992624076BDF9907FBBDEFF3CF616D352280FD6F0E13A59109D7761E3E0492EAB3DF38EB6D125451C36662933A3AC0D5AAC6AC4F926E89'+
      'F717DFB1F4CB28B1D11CD44517DDDC1A3D21AA1004C13FC87E952322E73E2A969A7240A51F324E11EC8D9B9367B1C28A69035EABD45C33FD522C21A798BE4F49B95B');
      //
      try Form1.sHost  := Form1.LbBlowfish1.DecryptString(SmallIni.ReadString('4','1','')); except end;
      try Form1.sChave := Form1.LbBlowfish1.DecryptString(SmallIni.ReadString('4','3','')); except end;
      try Form1.sPath  := Form1.LbBlowfish1.DecryptString(SmallIni.ReadString('4','4','')); except end;
      //
      // Intervalo de acesso
      //
      try Form1.Timer1.Interval := StrToInt(LimpaNumero(SmallIni.ReadString('4','0','5000'))); except Form1.Timer1.Interval := 5000 end;
      //
      // ShowMessage(Form1.sHost + chr(10) + Form1.sChave  + chr(10) + Form1.sPath );
      //
      SmallIni.Free;
      //
    end;
  end else
  begin
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE );
  end;
  //
end;

procedure TForm1.baixaClick(Sender: TObject);
begin
  //
  try
    //
    chdir(pChar(Form1.sAtual+'\mobile\download'));
    //
    try
      //
      try DownloadMobile(sCNPJ, '*.cli'); except end;//Clientes
      try DownloadMobile(sCNPJ, '*.ped'); except end;//Orçamentos
      try DownloadMobile(sCNPJ, '*.nfc'); except end;//NFCe
      try DownloadMobile(sCNPJ, '*.rel'); except end;//Relatórios
      try DownloadMobile(sCNPJ, '*.mob'); except end;//Sincronizar com Small Commerce
      //
      chdir(pChar(Form1.sAtual));
      //
    except end;
    //
  except end;
end;
{
procedure TForm1.baixaClick(Sender: TObject);
var
  sTLista : TStringList;
begin
  //
  try
    //
    chdir(pChar(Form1.sAtual+'\mobile\download'));
    //
    try
      //
      sTLista := TStringList.Create();
      sTLista.Clear;
      //
      try DownloadMobile(sCNPJ, '*.cli', sTLista); except end;//Clientes
      try DownloadMobile(sCNPJ, '*.ped', sTLista); except end;//Orçamentos
      try DownloadMobile(sCNPJ, '*.nfc', sTLista); except end;//NFCe
      try DownloadMobile(sCNPJ, '*.rel', sTLista); except end;//Relatórios
      try DownloadMobile(sCNPJ, '*.mob', sTLista); except end;//Sincronizar com Small Commerce
      //
      sTLista.Free;
      //
      chdir(pChar(Form1.sAtual));
      //
    except end;
    //
  except end;
end;
}


procedure TForm1.mandaarquivosClick(Sender: TObject);
var
  tsListaDeArquivos : TStrings;
  I : Integer;
  sArquivo : String;
  bSQL: Boolean;
begin
  //
  try
    //
    chdir(pChar(Form1.sAtual+'\mobile\upload'));
    //
    try
      //
      tsListaDeArquivos   := ListaDeArquivos(pchar(sAtual+'\mobile\upload'));
      bSQL := False;
      //
      for I := 1 to tsListaDeArquivos.Count do
      begin
        //
        sArquivo := sAtual + '\mobile\upload\' + AllTrim(tsListaDeArquivos[I-1]);
        //
        if FileExists(sArquivo) then
        begin
          if (pos('.sql',sArquivo) <> 0) then
            bSQL := True;
          if (pos('.sql',sArquivo) <> 0) or
             (pos('.jpg',sArquivo) <> 0) or
             (pos('.pdf',sArquivo) <> 0) then
          begin
            //
            try
              UploadMobile(sArquivo,sCNPJ);
            except end;
            //
            DeleteFile(pchar(sArquivo));
            //
          end;
        end;
      end;
      //
      if bSQL then
      begin
        //
        try
          Form1.IdHTTP1.Get('http://mob.smallmobile.com.br/?xt=im&cgc='+sCNPJ);
        except end;
        //
  //      try
  //        DeleteArquivoMobile(sCNPJ, 'sincroniza.mob');/// Sandro Silva 2015-11-04
  //      except end;
        //
      end;
    except end;
    //
    chdir(pChar(Form1.sAtual));
    //
  except end;
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  //
  Form1.Memo1.Align := AlClient;
  Form1.Top         := 130;
  form1.Left        := 0;
  Form1.Height      := Screen.Height - form1.Top - 40;
  Form1.Width       := Screen.Width;
  //
end;

procedure TForm1.Memo1Click(Sender: TObject);
begin
  Timer1.Interval := 100;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE );
end;

end.
