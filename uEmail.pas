unit uEmail;

interface

uses
  System.IniFiles
  , Winapi.Mapi
  , System.SysUtils
  , Winapi.ShellAPI
  , Winapi.Windows
  , Vcl.Forms
  , System.Classes
  , Dialogs
  ;

function ValidaEmail(email: String): Boolean;
//function EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo: String; bConfirma: Boolean): Integer;
function EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, cAnexo: string; bConfirma: Boolean): Integer;
function EnviarEmailMapi(
            const Subject, MessageText, MailFromName, MailFromAddress,
                  MailToName, MailToAddress: String;
            const AttachmentFileNames: array of String; bConfirma: Boolean): Integer;


implementation

uses
  uITestaEmail
  , uTestaEmail
  , SmallFunc_XE
  ;

function ValidaEmail(email: String): Boolean;
begin
  Result := TTestaEmail.New.setEmail(email).Testar;
end;

function EnviarEmailMapi(
            const Subject, MessageText, MailFromName, MailFromAddress,
                  MailToName, MailToAddress: String;
            const AttachmentFileNames: array of String; bConfirma: Boolean): Integer;
//Originally by Brian Long: The Delphi Magazine issue 60 - Delphi And Email
const
  _cNomeMailEXE = 'email.exe';

var
  MAPIError: DWord;
  MapiMessage: TMapiMessage;
  Originator, Recipient: TMapiRecipDesc;
  Files, FilesTmp: PMapiFileDesc;
  FilesCount: Integer;

  MAPIModule: HModule;
  Flags: Cardinal;
  SM: TFNMapiSendMail;

begin

   FillChar(MapiMessage, Sizeof(TMapiMessage), 0);

   MapiMessage.lpszSubject := PAnsiChar(AnsiString(Subject));
   MapiMessage.lpszNoteText := PAnsiChar(AnsiString(MessageText));

   FillChar(Originator, Sizeof(TMapiRecipDesc), 0);

   Originator.lpszName := PAnsiChar(AnsiString(MailFromName));
   Originator.lpszAddress := PAnsiChar(AnsiString(MailFromAddress));
//   MapiMessage.lpOriginator := @Originator;
   MapiMessage.lpOriginator := nil;


   MapiMessage.nRecipCount := 1;
   FillChar(Recipient, Sizeof(TMapiRecipDesc), 0);
   Recipient.ulRecipClass := MAPI_TO;
   Recipient.lpszName := PAnsiChar(AnsiString(MailToName));
   Recipient.lpszAddress := PAnsiChar(AnsiString(MailToAddress));
   MapiMessage.lpRecips := @Recipient;

   MapiMessage.nFileCount := High(AttachmentFileNames) - Low(AttachmentFileNames) + 1;
   Files := AllocMem(SizeOf(TMapiFileDesc) * MapiMessage.nFileCount);
   MapiMessage.lpFiles := Files;
   FilesTmp := Files;
   for FilesCount := Low(AttachmentFileNames) to High(AttachmentFileNames) do
   begin
     FilesTmp.nPosition := $FFFFFFFF;
     FilesTmp.lpszPathName := PAnsiChar(AnsiString(AttachmentFileNames[FilesCount]));
     Inc(FilesTmp)
   end;

   // carrega dll e o método sPara envio do email
   MAPIModule := LoadLibrary(PChar(MAPIDLL));
   if MAPIModule = 0 then
   begin
     Result := -1
   end else
   begin
     try
       if bConfirma then
       begin
         Flags := MAPI_DIALOG or MAPI_LOGON_UI;
       end else
       begin
         Flags := 0;
       end;
       //
       @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
       if @SM <> nil then
       begin
         Result := SM(0, Application.Handle, MapiMessage, Flags, 0);
       end else
       begin
         Result := 1;
       end;
     finally
       //FreeLibrary(MAPIModule);
     end;
   end;
   FreeLibrary(MAPIModule);


end;

function EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, cAnexo: string; bConfirma: Boolean): Integer;
const
  _cNomeMailEXE = 'email.exe';
var
  Mais1Ini : tIniFile;
  sAtual : String;
  slAnexos: TStringList;
  i: Integer;
  FileNames: array of string;
begin
  //
  GetDir(0,sAtual);
  //
  Mais1ini := TIniFile.Create('frente.ini');
  //
  if FileExists(pChar('mail.exe')) and (Mais1Ini.ReadString('mail','Host','') <> '') then
  begin
    //
    while FileExists(pChar('email.exe')) do
    begin
      DeleteFile(pChar(sAtual+'\email.exe'));
      sleep(10);
    end;
    //
    while not FileExists(pChar('email.exe')) do
    begin
      CopyFile(pChar(sAtual+'\mail.exe'), pChar(sAtual+'\email.exe'),True);
      sleep(10);
    end;
    //
    ShellExecute( 0, 'Open', pChar(sAtual+'\'+_cNomeMailEXE) , pChar(sPara+' '+'"'+sAssunto+'"'+' '+'"'+sTexto+'"'+' '+'"'+cAnexo+'"'), PChar(''), SW_Show);
    // Deve aguardar o processo do mail finalizar o processo de envio
    while processExists(_cNomeMailEXE) do
    begin
      Sleep(250);
    end;
    //
    Result := 1;
  end else
  begin

    slAnexos := TStringList.Create;
    slAnexos.Clear;

    slAnexos :=RetornaListaQuebraLinha(cAnexo);

    SetLength(FileNames, slAnexos.Count);

    for i := 0 to slAnexos.Count -1 do
      FileNames[i] := PChar(slAnexos.Strings[i]);

    FreeAndNil(slAnexos);

    EnviarEmailMapi(sAssunto, sTexto, sDe, sDe, sPara, sPara, FileNames, bConfirma);

    FileNames := nil;

  end;

  Mais1Ini.Free;

  CHDir(sAtual);
end;

end.
