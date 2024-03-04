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
function EnviarMAPIEmail2(const Assunto, Corpo, DeNome, DeEmail: string; //const ShowDialog: Boolean;
                         Para, CC, Anexos, AnexosNome: array of string; bConfirma: Boolean): Integer;


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

   MapiMessage.lpszSubject  := PAnsiChar(AnsiString(Subject));
   MapiMessage.lpszNoteText := PAnsiChar(AnsiString(MessageText));

   FillChar(Originator, Sizeof(TMapiRecipDesc), 0);

   Originator.lpszName    := PAnsiChar(AnsiString(MailFromName));
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


   ShowMessage(IntToStr(MapiMessage.nFileCount));


   Files := AllocMem(SizeOf(TMapiFileDesc) * MapiMessage.nFileCount);
   MapiMessage.lpFiles := Files;
   {
   FilesTmp := Files;
   for FilesCount := Low(AttachmentFileNames) to High(AttachmentFileNames) do
   begin
     FilesTmp.nPosition := Cardinal(-1);//$FFFFFFFF;
     FilesTmp.lpszPathName := PAnsiChar(AnsiString(AttachmentFileNames[FilesCount]));

     //Showmessage(AttachmentFileNames[FilesCount] + #13 +  FilesTmp.lpszPathName);

     Inc(FilesTmp)
   end;
   }
   for FilesCount := Low(AttachmentFileNames) to High(AttachmentFileNames) do
   begin
     Files.nPosition := Cardinal(FilesCount - 1);//$FFFFFFFF;
     Files.lpszPathName := PAnsiChar(AnsiString(AttachmentFileNames[FilesCount]));

     //Showmessage(AttachmentFileNames[FilesCount] + #13 +  FilesTmp.lpszPathName);

     Inc(Files)
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
    //EnviarMAPIEmail2(sAssunto, sTexto, sDe, sDe, ['sandro.silva@zucchetti.com'], [''], FileNames, FileNames, bConfirma);

    FileNames := nil;

  end;

  Mais1Ini.Free;

  CHDir(sAtual);
end;

function EnviarMAPIEmail2(const Assunto, Corpo, DeNome, DeEmail: string; //const ShowDialog: Boolean;
                         Para, CC, Anexos, AnexosNome: array of string; bConfirma: Boolean): Integer;
var
  MapiMessage        : TMapiMessage;
  MError             : Cardinal;
  Sender             : TMapiRecipDesc;
  PRecip, Recipients : PMapiRecipDesc;
  PFiles, Attachments: PMapiFileDesc;
  I                  : Integer;
  AppHandle          : THandle;
  FTOAdr, FCCAdr,
  FAttachedFileName,
  FDisplayFileName   : TStringList;

  MAPIModule: HModule;
  Flags: Cardinal;
  SM: TFNMapiSendMail;

begin
  FTOAdr            := TStringList.Create;
  FCCAdr            := TStringList.Create;
  FAttachedFileName := TStringList.Create;
  FDisplayFileName  := TStringList.Create;

  for I := Low(Para)       to High(Para)       do FTOAdr.Add(Para[I]);
  for I := Low(CC)         to High(CC)         do FCCAdr.Add(CC[I]);
  for I := Low(Anexos)     to High(Anexos)     do FAttachedFileName.Add(Anexos[I]);
  for I := Low(AnexosNome) to High(AnexosNome) do FDisplayFileName.Add(AnexosNome[I]);

  // First we store the Application Handle, if not the Component might fail to send the Email or

  // your calling Program gets locked up.

  AppHandle := Application.Handle;
  PFiles    := nil;  // Initialize the Attachment Pointer, to keep Delphi quiet

  MapiMessage.nRecipCount := FTOAdr.Count + FCCAdr.Count; //  + fBCCAdr.Count We need all recipients to alloc the memory
  GetMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));

  try
    with MapiMessage do
      begin
        ulReserved         := 0;
        lpszSubject        := PAnsiChar(AnsiString(Assunto));
        lpszNoteText       := PAnsiChar(AnsiString(Corpo));
        lpszMessageType    := nil;
        lpszDateReceived   := nil;
        lpszConversationID := nil;
        flFlags := 0;

        // and the sender: (MAPI_ORIG)

        Sender.ulReserved := 0;
        Sender.ulRecipClass := MAPI_ORIG;
        Sender.lpszName := PAnsiChar(AnsiString(DeNome));
        Sender.lpszAddress := PAnsiChar(AnsiString(DeEmail));
        Sender.ulEIDSize := 0;
        Sender.lpEntryID := nil;
        lpOriginator := @Sender;
        PRecip := Recipients;

        // We have multiple recipients: (MAPI_TO) and setting up each: }

        if nRecipCount > 0 then
          begin
            for i := 1 to FTOAdr.Count do
              begin
                PRecip^.ulReserved   := 0;
                PRecip^.ulRecipClass := MAPI_TO;

                { lpszName should carry the Name like in the
                  contacts or the adress book, I will take the
                  email adress to keep it short: }

                PRecip^.lpszName := PAnsiChar(AnsiString(FTOAdr.Strings[i - 1]));

                { If you use this component with Outlook97 or 2000
                  and not some of Express versions you will have to set
                  'SMTP:' in front of each (email-) adress. Otherwise
                  Outlook/Mapi will try to handle the Email on itself.
                  Sounds strange, just erease the 'SMTP:', compile, compose
                  a mail and take a look at the resulting email adresses
                  (right click).
                }

                PRecip^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + FTOAdr.Strings[i - 1])));
                PRecip^.ulEIDSize   := 0;
                PRecip^.lpEntryID   := nil;
                Inc(PRecip);
              end;

            // Same with the carbon copy recipients: (CC, MAPI_CC)
            for i := 1 to FCCAdr.Count do
              begin
                PRecip^.ulReserved   := 0;
                PRecip^.ulRecipClass := MAPI_CC;
                PRecip^.lpszName     := PAnsiChar(AnsiString(FCCAdr.Strings[i - 1]));
                PRecip^.lpszAddress  := StrNew(PAnsiChar(AnsiString('SMTP:' + FCCAdr.Strings[i - 1])));
                PRecip^.ulEIDSize    := 0;
                PRecip^.lpEntryID    := nil;
                Inc(PRecip);
              end;

            { Copia oculta:
            for i := 1 to FBCCAdr.Count do
              begin
                PRecip^.ulReserved   := 0;
                PRecip^.ulRecipClass := MAPI_BCC;
                PRecip^.lpszName     := PChar(FBCCAdr.Strings[i - 1]);
                PRecip^.lpszAddress  := StrNew(PChar('SMTP:' + FBCCAdr.Strings[i - 1]));
                PRecip^.ulEIDSize    := 0;
                PRecip^.lpEntryID    := nil;
                Inc(PRecip);
              end; }
          end;

        lpRecips := Recipients;

        // Now we process the attachments:
        nFileCount := FAttachedFileName.Count;
        if nFileCount > 0 then
          begin
            GetMem(Attachments, nFileCount * sizeof(TMapiFileDesc));
            PFiles := Attachments;

            // Fist setting up the display names (without path):
            FDisplayFileName.Clear;
            for i := 1 to FAttachedFileName.Count do
              FDisplayFileName.Add(ExtractFileName(FAttachedFileName[i - 1]));
            if nFileCount > 0 then
              begin

                // Now we pass the attached file (their paths) to the structure:
                for i := 1 to FAttachedFileName.Count do
                  begin

                    // Setting the complete Path
                    Attachments^.lpszPathName := PAnsiChar(AnsiString(FAttachedFileName.Strings[i - 1]));
                    // ... and the displayname:
                    Attachments^.lpszFileName := PAnsiChar(AnsiString(FDisplayFileName.Strings[i - 1]));
                    Attachments^.ulReserved   := 0;
                    Attachments^.flFlags      := 0;
                    // Position has to be -1, please see the WinApi Help for details.
                    Attachments^.nPosition    := Cardinal(-1);
                    Attachments^.lpFileType   := nil;
                    Inc(Attachments);
                  end;
              end;

            lpFiles := PFiles;
          end
        else
          begin
            nFileCount := 0;
            lpFiles := nil;
          end;
      end;
    (*
    { Send the Mail, silent or verbose:
      Verbose means in Express a Mail is composed and shown as setup.
      In non-Express versions we show the Login-Dialog for a new
      session and after we have choosen the profile to use, the
      composed email is shown before sending

      Silent does currently not work for non-Express version. We have
      no Session, no Login Dialog so the system refuses to compose a
      new email. In Express Versions the email is sent in the
      background.

      Please Note: It seems that your success on the delivery depends
      on a combination of MAPI-Flags (MAPI_DIALOG, MAPI_LOGON_UI, ...)
      and your used OS and Office Version. I am currently using
      Win2K SP1 and Office 2K SP2 with no problems at all.

      If you experience problems on another versions, please try
      a different combination of flags for each purpose (Dialog or not).
      I would be glad to setup a table with working flags on
      each OS/Office combination, just drop me a line.

      Possible combinations are also (with Dialog):
      1. MAPI_DIALOG or MAPI_LOGON_UI MAPI_NEW_SESSION or MAPI_USE_DEFAULT
      2. MAPI_SIMPLE_DEFAULT
      See MAPI.PAS or MAPI.H (SDK) for more...
     }
     if bConfirma then
     begin
       Flags := MAPI_DIALOG or MAPI_LOGON_UI;
     end else
     begin
       Flags := 0;
     end;

    //if ShowDialog then
    //  MError := MapiSendMail(0, AppHandle, MapiMessage, MAPI_DIALOG or MAPI_LOGON_UI, 0)
    //else
    //  MError := MapiSendMail(0, AppHandle, MapiMessage, 0, 0);
    MError := MapiSendMail(0, AppHandle, MapiMessage, Flags, 0);

    { Now we have to process the error messages. There are some
      defined in the MAPI unit please take a look at the unit to get
      familiar with it.
      I decided to handle USER_ABORT and SUCCESS as special and leave
      the rest to fire the "new" error event defined at the top (as
      generic error)

      Not treated as special (constants from mapi.pas):

      MAPI_E_FAILURE = 2;

      MAPI_E_LOGON_FAILURE = 3;

      MAPI_E_LOGIN_FAILURE = MAPI_E_LOGON_FAILURE;

      MAPI_E_DISK_FULL = 4;

      MAPI_E_INSUFFICIENT_MEMORY = 5;

      MAPI_E_ACCESS_DENIED = 6;

      MAPI_E_TOO_MANY_SESSIONS = 8;

      MAPI_E_TOO_MANY_FILES = 9;

      MAPI_E_TOO_MANY_RECIPIENTS = 10;

      MAPI_E_ATTACHMENT_NOT_FOUND = 11;

      MAPI_E_ATTACHMENT_OPEN_FAILURE = 12;

      MAPI_E_ATTACHMENT_WRITE_FAILURE = 13;

      MAPI_E_UNKNOWN_RECIPIENT = 14;

      MAPI_E_BAD_RECIPTYPE = 15;

      MAPI_E_NO_MESSAGES = 16;

      MAPI_E_INVALID_MESSAGE = 17;

      MAPI_E_TEXT_TOO_LARGE = 18;

      MAPI_E_INVALID_SESSION = 19;

      MAPI_E_TYPE_NOT_SUPPORTED = 20;

      MAPI_E_AMBIGUOUS_RECIPIENT = 21;

      MAPI_E_AMBIG_RECIP = MAPI_E_AMBIGUOUS_RECIPIENT;

      MAPI_E_MESSAGE_IN_USE = 22;

      MAPI_E_NETWORK_FAILURE = 23;

      MAPI_E_INVALID_EDITFIELDS = 24;

      MAPI_E_INVALID_RECIPS = 25;

      MAPI_E_NOT_SUPPORTED = 26;

    }

    Result := MError;
    *)

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

  finally

    FTOAdr.Free;
    FCCAdr.Free;
    FAttachedFileName.Free;
    FDisplayFileName.Free;
    PRecip := Recipients;
    for i := 1 to MapiMessage.nRecipCount do
    begin
      StrDispose(PRecip^.lpszAddress);
      Inc(PRecip)
    end;

    FreeMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));
    if Assigned(PFiles) then
      FreeMem(PFiles, MapiMessage.nFileCount * sizeof(TMapiFileDesc));
  end;

end;

(*
function EnviarEmail(Endereco: TStringList; Assunto: ansiString = ''; Texto: ansiString = '';
  stlAnexo: TStringList = nil; AEnviarDireto: boolean = False): Boolean;
type
  TAttachAccessArray = array [0..0] of TMapiFileDesc;
  PAttachAccessArray = ^TAttachAccessArray;
var
  MapiMessage: TMapiMessage;
  MError: Cardinal;
  Sender: TMapiRecipDesc;
  PRecip, Recipients: PMapiRecipDesc;

  Attachments: PAttachAccessArray;
  x: integer;
begin
  Result := False;
  MapiMessage.nRecipCount := Endereco.count;
  GetMem( Recipients, MapiMessage.nRecipCount * Sizeof(TMapiRecipDesc) );
  Attachments := nil;

  try
    with MapiMessage do
    begin
      { Assunto e Texto }
      ulReserved := 0;
      lpszSubject :=  PAnsichar(PChar( Assunto ));
      lpszNoteText := PAnsichar(PChar( Texto ));

      lpszMessageType := nil;
      lpszDateReceived := nil;
      lpszConversationID := nil;
      flFlags := 0;
      Sender.ulReserved := 0;
      Sender.ulRecipClass := MAPI_ORIG;
      Sender.lpszName := PAnsichar(PChar( '' ));
      Sender.lpszAddress := PAnsichar(PChar( '' ));
      Sender.ulEIDSize := 0;
      Sender.lpEntryID := nil;
      lpOriginator := @Sender;

      { Endereço }
      PRecip := Recipients;

      for x:=0 to Endereco.count-1 do begin
        PRecip^.ulReserved := 0;
        PRecip^.ulRecipClass := MAPI_TO;

        PRecip^.lpszName := StrNew(PAnsichar(ansistring( Endereco[x] )));
        PRecip^.lpszAddress := StrNew(PAnsichar(ansistring('SMTP:' + Endereco[x] ) ));

        PRecip^.ulEIDSize := 0;
        PRecip^.lpEntryID := nil;

        Inc( PRecip );
      end;

      lpRecips := Recipients;

      { Anexa os arquivos }
      if stlAnexo = nil then
      begin
        stlAnexo := TStringList.Create;
        stlAnexo.Clear;
      end;

      { Deleta do stlAnexo os arquivos que não existem }
      x:=0;
      while x <=stlAnexo.Count - 1 do begin
        if not FileExists( stlAnexo.Strings[x] ) then
          stlAnexo.Delete(x)
        else
          inc(x);
      end;

      { Anexa os arquivos }
      if stlAnexo.Count > 0 then
      begin
        GetMem(Attachments, SizeOf(TMapiFileDesc) * stlAnexo.Count);
        for x := 0 to stlAnexo.Count - 1 do
        begin
          Attachments[x].ulReserved := 0;
          Attachments[x].flFlags := 0;
          Attachments[x].nPosition := ULONG($FFFFFFFF);
          Attachments[x].lpszPathName := StrNew( PAnsichar(ansistring(stlAnexo.Strings[x]) ));
          Attachments[x].lpszFileName := StrNew( PAnsichar(ansistring( ExtractFileName(stlAnexo.Strings[x]) ) ));
          Attachments[x].lpFileType := nil;
        end;
      end
      {endif};
      nFileCount := stlAnexo.Count;
      lpFiles := @Attachments^;
    end;

    { Enviando o e-mail }
    if not AEnviarDireto then
      MError := MapiSendMail(0, Application.Handle, MapiMessage, MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0)
    else
      MError := MapiSendMail(0, Application.Handle, MapiMessage, MAPI_LOGON_UI or MAPI_NEW_SESSION or MAPI_SENT, 0);

    case MError of
      MAPI_E_USER_ABORT: ;
      { Mostra mensagem que o envio do e-mail foi abortado pelo usuário.
      Portanto, não será mostrado nada }

      SUCCESS_SUCCESS:
      Result := True;
    else
      MessageDlg( 'Ocorreu um erro inesperado!'#13'Código: ' +
      IntToStr(MError), mtError, [mbOk], 0);
    end;
  finally
    PRecip := Recipients;
    StrDispose( PRecip^.lpszAddress );
    //Inc( PRecip );

    FreeMem( Recipients, MapiMessage.nRecipCount * Sizeof(TMapiRecipDesc) );
    for x := 0 to stlAnexo.Count - 1 do
    begin
      StrDispose( Attachments[x].lpszPathName );
      StrDispose( Attachments[x].lpszFileName );
    end;
  end;
end;
*)


end.
