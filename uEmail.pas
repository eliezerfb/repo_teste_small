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
procedure EnviarMAPIEmail2;


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

    EnviarMAPIEmail2;
    //EnviarMAPIEmail2(sAssunto, sTexto, sDe, sDe, ['sandro.silva@zucchetti.com'], [''], FileNames, FileNames, bConfirma);

    FileNames := nil;

  end;

  Mais1Ini.Free;

  CHDir(sAtual);
end;

procedure EnviarMAPIEmail2;
var
  MapiMessage: TMapiMessage;
  Sender: TMapiRecipDesc;
  MError: Cardinal;
  i: Integer;
  AppHandle: THandle;
  PRecip, Recipients: PMapiRecipDesc;
  PFiles, Attachments: PMapiFileDesc;

  MAPIModule: HModule;
  SM: TFNMapiSendMail;//
  FShowDialog: Boolean;
  FUseAppHandle: Boolean;

  cTitulo: string;
  cCorpo: String;
  cEmail: String;
  slAnexos: TStringList;
  cCaminho: String;
begin
  cTitulo := 'Arquivos XML Maria Sandra Rodrigues Assunção Nev, 05.277.931/0001-55';
  cCorpo := 'Segue em anexo arquivos XML da empresa Maria Sandra Rodrigues Assunção, CNPJ 05.277.931/0001-55 do período de 01/02/2024 à 29/02/2024. ' + SLineBreak + SLineBreak +
                          'Este e-mail foi enviado automaticamente pelo sistema Small.' + SLineBreak + SLineBreak +
                          'http://www.smallsoft.com.br';
  cEmail := 'dailon.parisotto@smallsoft.com.br';

  FShowDialog := False;
  slAnexos := TStringList.Create;
  slAnexos.Clear;
  slAnexos.Add('D:\desenvolvimento\executaveis\Small Commerce\CONTABIL\05277931000155_XMLNFCeSAT_01_03_2024.zip');
  slAnexos.Add('D:\desenvolvimento\executaveis\Small Commerce\CONTABIL\05277931000155_XMLNFe_Saida_01_03_2024.zip');
  slAnexos.Add('D:\desenvolvimento\executaveis\Small Commerce\CONTABIL\Produtos monofásicos.pdf');
  slAnexos.Add('D:\desenvolvimento\executaveis\Small Commerce\CONTABIL\Totalizador de vendas.pdf');

  AppHandle := Application.Handle;

  PFiles := nil;

  MapiMessage.nRecipCount := 1;
  GetMem(Recipients, MapiMessage.nRecipCount * sizeof(TMapiRecipDesc));
  try
    with MapiMessage do
    begin
      ulReserved := 0;

      // Setting the Subject:
      lpszSubject := StrNew(PAnsiChar(AnsiString(cTitulo)));

      // the Body:
      lpszNoteText := StrNew(PAnsiChar(AnsiString(cCorpo)));

      lpszMessageType := nil;
      lpszDateReceived := nil;
      lpszConversationID := nil;
      flFlags := 0;

      // and the sender: (MAPI_ORIG)
      Sender.ulReserved := 0;
      Sender.ulRecipClass := MAPI_ORIG;
      Sender.lpszName := PAnsiChar(AnsiString(cEmail));
      Sender.lpszAddress := StrNew(PAnsiChar(AnsiString(cEmail)));
      Sender.ulEIDSize := 0;
      Sender.lpEntryID := nil;
      lpOriginator := @Sender;
      PRecip := Recipients;

      if nRecipCount > 0 then
      begin
        PRecip^.ulReserved := 0;
        PRecip^.ulRecipClass := MAPI_TO;
        PRecip^.lpszName := PAnsiChar(AnsiString(cEmail));
        PRecip^.lpszAddress := StrNew(PAnsiChar(AnsiString('SMTP:' + cEmail)));
        PRecip^.ulEIDSize := 0;
        PRecip^.lpEntryID := nil;
        Inc(PRecip);
      end;

      lpRecips := Recipients;

      nFileCount := slAnexos.Count;
      if nFileCount > 0 then
      begin
        GetMem(PFiles, nFileCount * sizeof(TMapiFileDesc));
        Attachments := PFiles;

        lpFiles := PFiles;

        if nFileCount > 0 then
        begin
          for i := 0 to Pred(slAnexos.Count) do
          begin
            cCaminho := slAnexos.Strings[i];
            Attachments^.lpszPathName := StrNew(PAnsiChar(AnsiString(cCaminho)));
            Attachments^.ulReserved := 0;
            Attachments^.flFlags := 0;
            Attachments^.nPosition := ULONG(-1);
            Attachments^.lpFileType := nil;

            cCaminho := EmptyStr;
            Inc(Attachments);
          end;
        end;
      end
      else
      begin
        nFileCount := 0;
        lpFiles := nil;
      end;

    end;

    // carrega dll e o método sPara envio do email
    MAPIModule := LoadLibrary(PChar(MAPIDLL));
    if MAPIModule > 0 then
    begin
      @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
      if @SM <> nil then
      begin
        //Result := SM(0, Application.Handle, MapiMessage, Flags, 0);
        if FShowDialog then
          MError := SM(0, Application.Handle, MapiMessage, MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0)
        else
          MError := SM(0, Application.Handle, MapiMessage, 0, 0);
      end else
      begin
        //Result := 1;
      end;
    end;
    FreeLibrary(MAPIModule);
  finally

    // Finally we do the cleanups, the message should be on its way
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

end.
