unit Instal;


interface

uses

  IniFiles, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DdeMan, Gauges, ShellApi,
  LzExpand, FileCtrl, Registry, SmallFunc, TLHelp32, PsAPI, ShlObj, ComObj, ActiveX,
  LbCipher, LbClass;


type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Panel6: TPanel;
    Edit2: TEdit;
    Label5: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    Image2: TImage;
    LbBlowfish1: TLbBlowfish;
    Image1: TImage;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    ScrollBox1: TScrollBox;
    RadioButtonSemImpressora: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton49: TRadioButton;
    RadioButton48: TRadioButton;
    RadioButton47: TRadioButton;
    RadioButton46: TRadioButton;
    RadioButton45: TRadioButton;
    RadioButton43: TRadioButton;
    RadioButton42: TRadioButton;
    RadioButton41: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton23: TRadioButton;
    RadioButton22: TRadioButton;
    RadioButton21: TRadioButton;
    RadioButton20: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton18: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton1: TRadioButton;
    Label8: TLabel;
    Label6: TLabel;
    Button3: TButton;
    Button1: TButton;
    Button2: TButton;
    RadioButton24: TRadioButton;
    RadioButton25: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Enter(Sender: TObject);
    procedure RadioButtonSemImpressoraKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RadioButtonSemImpressoraEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sPasta, sNumero, sServer, sModelo, sNome, sAtual : String;
    iGiro : Integer;
  end;

var
  Form1: TForm1;
  SAvancar : String;

implementation


{$R *.DFM}

function GetSystemPath(Folder: Integer): string;
var
  PIDL: PItemIDList;
  Path: LPSTR;
  AMalloc: IMalloc;
begin

  Path := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);

  if SHGetPathFromIDList(PIDL, Path) then Result := Path;

  SHGetMalloc(AMalloc);
  AMalloc.Free(PIDL);
  StrDispose(Path);
end;


function ApagaArquivoNoDeskTop(sP1:String): boolean;
begin
  //
  DeleteFile(pChar(GetSystemPath(0)+'\'+sP1));
  DeleteFile(pChar('c:\Users\Public\Desktop\'+Sp1));
  DeleteFile(pChar('c:\Documents and Settings\All Users\Desktop\'+sP1));
  //
  Result := True;
  //
end;


function RenomeiaArquivoNoDeskTop(sP1, sP2:String): boolean;
begin
  //
  RenameFile(pChar(GetSystemPath(0)+'\'+sP1),pChar(GetSystemPath(0)+'\'+sP2));
  RenameFile(pChar('c:\Users\Public\Desktop\'+Sp2),pChar('c:\Users\Public\Desktop\'+Sp2));
  RenameFile(pChar('c:\Documents and Settings\All Users\Desktop\'+sP1),pChar('c:\Documents and Settings\All Users\Desktop\'+sP2));
  //
  Result := True;
  //
end;


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



Function Modulo_11(pP1:String):String;
var
   Acumulado,I,Controle:integer;
begin
   {acumula a soma da multiplicação dos digitos}
   Pp1:=Alltrim(pP1);
   Controle:=2;
   Acumulado:=0;
   for I:=length(Pp1) downto 1 do
   begin
      Acumulado:=Acumulado + (StrToInt(Copy(Pp1,I,1))*Controle);
      Controle := Controle + 1;
      if Controle > 9 then Controle:=2;
   end;
   {calcula o digito}
   Acumulado:=11-(Acumulado mod 11);
   if (Acumulado = 10) or (Acumulado = 11)  then Acumulado:=0;
   {devolve o digito de controle}
   Result:=IntToStr(Acumulado);
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  Winexec('TASKKILL /F /IM setup.exe' , SW_HIDE );
  Abort;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
//  sWinDir : String;
//  aWinDir: array[0..200] of Char;
  I : integer;
begin
  //
  Form1.Tag := 1;
  //
  if Button1.Caption = 'Concluir' then
  begin
    Close;
    Abort;
  end;
  //
  if (Copy(Edit2.Text,4,1) = 'N') or
     (Copy(Edit2.Text,4,1) = 'O') or
     (Copy(Edit2.Text,4,1) = 'P') or
     (Copy(Edit2.Text,4,1) = 'Q') or
     (Copy(Edit2.Text,4,1) = 'R') or
     (Copy(Edit2.Text,4,1) = 'M') or
     (sModelo = '99') then
  begin
    //
    if Application.MessageBox(Pchar(

    'Ao confirmar a instalação você está afirmando que a'+chr(10)+
    'empresa está enquadrada na legislação do'+chr(10)+
    'Microempreendedor Individual (MEI).'+chr(10)+
    ''+chr(10)+
    'Confirma que a empresa está enquadrada no MEI?'
    ),'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING) = IDYES then

    begin
      //
      Mais1ini        := TIniFile.Create('FRENTE.INI');
      //
      sModelo         := '99';
      //
      Mais1Ini.WriteString('Frente de caixa','Modelo do ECF',sModelo);
      Mais1Ini.WriteString('Frente de caixa','Nome do ECF','MEI');
      //
      Mais1ini := TIniFile.Create('WIND0WS.L0G');
      Mais1Ini.WriteString('LICENCA','Ser',Alltrim(Edit2.Text));
      Mais1Ini.WriteString('LICENCA','MEI','SIM');
      Mais1Ini.Free;
      //
      Button1.Caption := 'Concluir';
      //
      Form1.Close;
      Abort;
      //
    end else
    begin
      //
      Winexec('TASKKILL /F /IM setup.exe' , SW_HIDE );
      Abort;
      //
    end;
    //
  end;
  //
  if Button1.Caption = 'Finalizar agora' then
  begin
    Form1.Hide;
    Winexec('TASKKILL /F /IM setup.exe' , SW_HIDE );
    Abort;
  end;
  //
  try
    //
    sServer := 'Sim';
    Edit2.Text := StrTran(UpperCase(Edit2.Text),'.','');
    //
    if Panel2.Visible then
    begin
      //
      Screen.Cursor   := crHourGlass;    // Cursor de Aguardo
      //
      try
        //
        Mais1ini := TIniFile.Create('arquivoauxiliarcriptografadopafecfsmallsoft.ini');
        //
        if Alltrim(Mais1Ini.ReadString('ECF','SERIE','X')) = 'X' then
        begin
          Mais1Ini.WriteString('ECF','SERIE','');
          Mais1Ini.WriteString('ECF','GT','');
          Mais1Ini.WriteString('ECF','CGC','kadZvbmjn/ORp1i9uaOc85GXd42Jk7HC');
          Mais1Ini.WriteString('DAV','I','56dHo7mjge2Rp0eiuaOB7pGnd42Jk7HB');
        end;
        //
        Mais1ini.Free;
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
        end;
      end;
      //
      try
        //
        Mais1ini        := TIniFile.Create('FRENTE.INI');
        //
        if sModelo = '650' then Mais1Ini.WriteString('Frente de caixa','Modelo do ECF','65') else Mais1Ini.WriteString('Frente de caixa','Modelo do ECF',sModelo);
        Mais1Ini.WriteString('Frente de caixa','Nome do ECF',sNome);
        Mais1Ini.WriteString('Retaguarda','Server',sServer);
        Mais1Ini.Free;
        //
        Mais1ini := TIniFile.Create('WIND0WS.L0G');
        Mais1Ini.WriteString('LICENCA','Ser',Alltrim(Edit2.Text));
        Mais1Ini.Free;
        //
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
        end;
      end;
      //
      Button1.Caption :='Concluir';
      Close;
      //
    end;
    //
    if Panel6.Visible then
    begin
      //
      try
        //
        if (Length(alltrim(Edit2.Text)) = 13) then //sistema novo
        begin
          //
          // S12F70020020X
          //
          I := StrToInt('0'+LimpaNumero(Copy(Edit2.Text,6,6)));
          //
          if (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('A'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('B'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('C'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('D'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('E'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('F'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários

          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('N'+Modulo_11(IntToStr(I+76))+StrZero(I,6,0)+'5'+ Chr(70+StrtoInt(Modulo_11(IntToStr(I+71))))),'I','X'),'L','Z')) // 12 Usuários Small Mei + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('O'+Modulo_11(IntToStr(I+75))+StrZero(I,6,0)+'4'+ Chr(69+StrtoInt(Modulo_11(IntToStr(I+72))))),'I','X'),'L','Z')) // 07 Usuários Small Mei + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('P'+Modulo_11(IntToStr(I+74))+StrZero(I,6,0)+'3'+ Chr(68+StrtoInt(Modulo_11(IntToStr(I+73))))),'I','X'),'L','Z')) // 02 Usuários Small Mei + OS
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('Q'+Modulo_11(IntToStr(I+73))+StrZero(I,6,0)+'2'+ Chr(67+StrtoInt(Modulo_11(IntToStr(I+74))))),'I','X'),'L','Z')) // 12 Usuários Small Mei
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('R'+Modulo_11(IntToStr(I+72))+StrZero(I,6,0)+'1'+ Chr(66+StrtoInt(Modulo_11(IntToStr(I+75))))),'I','X'),'L','Z')) // 07 Usuários Small Mei
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('M'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Mei
          or (Copy(Edit2.Text,4,10) = StrTran(StrTran(UpperCase('S'+Modulo_11(IntToStr(I+71))+StrZero(I,6,0)+'0'+ Chr(65+StrtoInt(Modulo_11(IntToStr(I+76))))),'I','X'),'L','Z')) // 02 Usuários Small Start
          //
          then
          begin
            //
            sNumero := '0';
            while StrToInt(sNumero) < 1 do
            begin
              for I := 1 to 10000 do sNumero := IntToStr(Random(StrToInt(StrTran(DateToStr(Date),'/',''))) * StrToInt(Copy(TimeToStr(Time),8,1)) + StrToInt(Copy(TimeToStr(Time),7,1)) + StrToInt(Copy(TimeToStr(Time),8,1)));
            end;
            if StrToInt(sNumero) < 100 then sNumero := IntToStr( 1000 + StrToInt(sNumero) * Day(Date) + StrToInt(Copy(TimeToStr(Time),8,1)));
            sNumero := Right('000000000000000'+AllTrim(sNumero),12);
            sNumero := Copy(sNumero,1,3)+'.'+Copy(sNumero,4,3)+'.'+Copy(sNumero,7,3)+'.'+Copy(sNumero,10,3);
            //
            Panel6.Visible  := False;
            Panel2.Top      := 170;
            Panel2.Left     := 70;
            //
            Panel2.Visible  := True;
            if RAdioButton9.CanFocus then RadioButton9.SetFocus;
            //
          end else Application.MessageBox('Número serial inválido.','Atenção',mb_Ok + mb_DefButton1);
        end else Application.MessageBox('Número serial inválido.','Atenção',mb_Ok + mb_DefButton1);
      except
        on E: Exception do
        begin
          Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      Form1.DestroyWindowHandle;
      Halt(1);
      Abort;
    end;
  end;
  //
  //
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return Then Button1.SetFocus;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  //
  Button1.Enabled := True;
  //
end;



procedure TForm1.Edit2Exit(Sender: TObject);
var
  sLicencaAnterior : String;
  Mais1ini : tIniFile;
begin
  //
  if form1.Tag <> 0 then
  begin
    //
    Edit2.Text := StrTran(UpperCase(Edit2.Text),'.','');
    //
    if Copy(Edit2.Text,4,1) = 'S' then // Small Start
    begin
      //
      Mais1ini := TIniFile.Create('WIND0WS.L0G');
      //
      // últimas verções
      //
      if sLicencaAnterior = '' then sLicencaAnterior := Mais1Ini.ReadString('RR','Ser','');
      if sLicencaAnterior = '' then sLicencaAnterior := Mais1Ini.ReadString('LICENCA','Ser','');
      //
      if sLicencaAnterior <> '' then
      begin
        if (copy(sLicencaAnterior,4,1) <> 'S') then
        begin
          Application.MessageBox(pChar('O software Small Start é apenas para usuários novos. Não pode ser instalado para atualizar o banco de dados de usuários com o Small Commerce.'+chr(10)+chr(10)+'Instale o Small Commerce.'),'Atenção',mb_Ok + MB_ICONWARNING);
          Form1.DestroyWindowHandle;
          Halt(1);
          Abort;
        end;
      end;
      //
      Form1.Label8.Visible := False;
      //
      RadioButton1.Visible  := False;
      RadioButton2.Visible  := False;
      RadioButton3.Visible  := False;
      RadioButton4.Visible  := False;
      RadioButton5.Visible  := False;
      RadioButton6.Visible  := False;
      RadioButton7.Visible  := False;
      RadioButton8.Visible  := False;
      RadioButton10.Visible := False;
      RadioButton11.Visible := False;
      RadioButton12.Visible := False;
      RadioButton13.Visible := False;
      RadioButton14.Visible := False;
      RadioButton15.Visible := False;
      RadioButton16.Visible := False;
      RadioButton17.Visible := False;
      RadioButton19.Visible := False;
      RadioButton20.Visible := False;
      RadioButton21.Visible := False;
      RadioButton22.Visible := False;
      RadioButton23.Visible := False;
      RadioButton41.Visible := False;
      RadioButton42.Visible := False;
      RadioButton43.Visible := False;
      RadioButton45.Visible := False;
      RadioButton46.Visible := False;
      RadioButton47.Visible := False;
      RadioButton48.Visible := False;
      RadioButton49.Visible := False;
      //
      ScrollBox1.VertScrollBar.Visible := False;
      //
    end else
    begin
      //
      Form1.Label8.Visible := True;
      //
      RadioButton1.Visible  := True;
      RadioButton2.Visible  := True;
      RadioButton3.Visible  := True;
      RadioButton4.Visible  := True;
      RadioButton5.Visible  := True;
      RadioButton6.Visible  := True;
      RadioButton7.Visible  := True;
      RadioButton8.Visible  := True;
      RadioButton10.Visible := True;
      RadioButton11.Visible := True;
      RadioButton12.Visible := True;
      RadioButton13.Visible := True;
      RadioButton14.Visible := True;
      RadioButton15.Visible := True;
      RadioButton16.Visible := True;
      RadioButton17.Visible := True;
      RadioButton19.Visible := True;
      RadioButton20.Visible := True;
      RadioButton21.Visible := True;
      RadioButton22.Visible := True;
      RadioButton23.Visible := True;
      RadioButton41.Visible := True;
      RadioButton42.Visible := True;
      RadioButton43.Visible := True;
      RadioButton45.Visible := True;
      RadioButton46.Visible := True;
      RadioButton47.Visible := True;
      RadioButton48.Visible := True;
      RadioButton49.Visible := True;
      //
      ScrollBox1.VertScrollBar.Visible := True;
      //
    end;
  end;  
  //
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Registro : TRegistry;
  sStringRegistro : String;
  sArquivo : String;
  I : Integer;
begin
  //
  if form1.Tag <> 0 then
  begin
    //
    Panel2.visible  := False;;
    sArquivo := '';
    //
    Label2.Caption := 'Instalando Small...';
    Panel1.Repaint;
    //
  //  Winexec('SMALL\DISK1\setup.exe' , sw_showmaximized);
    ShellExecute( 0, 'Open', 'SMALL\DISK1\setup.exe'  ,'','',sw_showmaximized);
    //
    Form1.Panel1.Width    := Form1.Panel6.Width;
    Form1.Panel1.Height   := Form1.Panel6.Height;
    Form1.Panel1.Top      := Form1.Panel6.Top;
    Form1.Panel1.Left     := Form1.Panel6.Left;
    //
    Form1.Panel1.Visible  := True;
    Form1.Button3.Enabled := False;
    Form1.Button2.Enabled := False;
    Form1.Button1.Enabled := False;
    //
    Screen.Cursor   := crAppStart;    // Cursor de Aguardo
    //
    Form1.Repaint;
    //
    // Verifica se o firebird ja esta rodando
    //
    try
      Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM cfesat.exe' , SW_HIDE );
      Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
      Winexec('TASKKILL /F /IM consulta.exe' , SW_HIDE );
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    try
      DeleteFile('C:\Windows\system32\libeay32.dll');
      DeleteFile('C:\Windows\system32\ssleay32.dll');
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    try
      //
      if (sModelo = '65') or (sModelo = '650') then
      begin
        //
        Label2.Caption := 'Instalando NFC-e...';
        Panel1.Repaint;
        //
        ShellExecute( 0, 'Open', 'install\nfce_setup.exe'  ,'/verysilent /s'                         ,'',SW_SHOW);
        //
        while ConsultaProcesso('nfce_setup.exe') do
        begin
          Application.ProcessMessages;
          sleep(100);
        end;
        //
      end else
      begin
        //
        if sModelo <> '01' then
        begin
          //
          Label2.Caption := 'Instalando nfce (paf)...';
          Panel1.Repaint;
          //
          ShellExecute( 0, 'Open', 'install\paf\nfce_setup.exe'  ,'/verysilent /s'                         ,'',SW_SHOW);
          //
          while ConsultaProcesso('nfce_setup.exe') do
          begin
            Application.ProcessMessages;
            sleep(100);
          end;
        end;
        //
      end;
      //
      Form1.Repaint;
      //
      Label2.Caption := 'Instalando NF-e...';
      Panel1.Repaint;
      //
      ShellExecute( 0, 'Open', 'install\nfe_setup.exe'  ,'/verysilent /s'                         ,'',SW_SHOW);
      //
      while ConsultaProcesso('nfe_setup.exe') do
      begin
        Application.ProcessMessages;
        sleep(100);
      end;
      //
      Label2.Caption := 'Instalando NFS-e...';
      Panel1.Repaint;
      //
      ShellExecute( 0, 'Open', 'install\nfse_setup.exe'  ,'/verysilent /s'                         ,'',SW_SHOW);
      //
      while ConsultaProcesso('nfse_setup.exe') do
      begin
        Application.ProcessMessages;
        sleep(100);
      end;
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    Form1.Repaint;
    //
    try
      //
      if not ConsultaProcesso('fbserver.exe') then
      begin
        //
        Label2.Caption := 'Instalando firebird...';
        Panel1.Repaint;
        //
        ShellExecute( 0, 'Open', 'install\smallfir.exe','/SP /VERYSILENT /NORESTART /FORCE /COPYFBCLIENT','',SW_SHOW);
        //
        // /FORCE /VERYSILENT /NORESTART /LOG="C:\LOGFB.TXT" /SAVEINF="C:\SAVEINF.TXT" /NOCANCEL
        //
        //
        while ConsultaProcesso('smallfir.exe') do
        begin
          Application.ProcessMessages;
          sleep(100);
        end;
        //
        Winexec('net start FirebirdGuardianDefaultInstance' , SW_HIDE );
        Label2.Caption := 'Firebird instalado...';
        Panel1.Repaint;
        //
      end;
      //
      try
        WinExec('netsh.exe "firewall add portopening protocol=TCP port=3050 name=""Firebird"" mode=ENABLE scope=SUBNET"', SW_HIDE);
      except end;
      //
      try
        WinExec('netsh.exe "firewall set allowedprogram ""c:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbserver.exe"" ""Firebird server (app)"" ENABLE SUBNET ALL"', SW_HIDE);
      except end;
      //
      try
        WinExec('netsh.exe "firewall set allowedprogram ""c:\Program Files\Firebird\Firebird_2_5\bin\fbserver.exe"" ""Firebird server (app)"" ENABLE SUBNET ALL"', SW_HIDE);
      except end;
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    Label2.Caption := 'Finalizando instalação do Small...';
    Panel1.Repaint;
    //
    for I := 1 to 20000 do
    begin
      //
      if (not FileExists(GetSystemPath(0)+'consulta.lnk'))
      and (not FileExists(pChar('c:\Users\Public\Desktop\consulta.lnk')))
      and (not FileExists(pChar('c:\Documents and Settings\All Users\Desktop\consulta.lnk'))) then
      begin
        Application.ProcessMessages;
        sleep(200);
      end;
      //
    end;
    //
    sleep(2000);
    //
    try
      //
      if Copy(Edit2.Text,4,1) = 'S' then // Small Start
      begin
        ApagaArquivoNoDeskTop('Small Commerce.lnk');
        ApagaArquivoNoDeskTop('Small Mei.lnk');
      end else
      begin
        if (Copy(Edit2.Text,4,1) = 'N') or
           (Copy(Edit2.Text,4,1) = 'O') or
           (Copy(Edit2.Text,4,1) = 'P') or
           (Copy(Edit2.Text,4,1) = 'Q') or
           (Copy(Edit2.Text,4,1) = 'R') or
           (Copy(Edit2.Text,4,1) = 'M') then
        begin
          ApagaArquivoNoDeskTop('Small Start.lnk');
          ApagaArquivoNoDeskTop('Small Commerce.lnk');
        end else
        begin
          ApagaArquivoNoDeskTop('Small Start.lnk');
          ApagaArquivoNoDeskTop('Small Mei.lnk');
        end;
      end;
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    try
      if sModelo = '650' then
      begin
        ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
        ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
        // ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
        ApagaArquivoNoDeskTop('NFCE (Nota Fiscal Consumidor Eletrônica).lnk');
        ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
        ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
      end else
      begin
        if sModelo = '65' then
        begin
          ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
          ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
          ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
          ApagaArquivoNoDeskTop('NFCE (Nota Fiscal Consumidor Eletrônica).lnk');
          // ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
          ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
        end else
        begin
          if sModelo = '59' then
          begin
            ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
            ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
            ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
            ApagaArquivoNoDeskTop('NFCE (Nota Fiscal Consumidor Eletrônica).lnk');
            ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
            // ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
          end else
          begin
            if sModelo = '99' then
            begin
              // ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
              ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
              ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
              ApagaArquivoNoDeskTop('NFCE (Nota Fiscal Consumidor Eletrônica).lnk');
              ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
              ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
            end else
            begin
              ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
              // ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
              ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
              ApagaArquivoNoDeskTop('NFCE (Nota Fiscal Consumidor Eletrônica).lnk');
              ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
              ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
            end;
          end;
        end;
      end;
      //
      if sModelo = '01' then
      begin
        ApagaArquivoNoDeskTop('Vendas (MEI).lnk');
        ApagaArquivoNoDeskTop('NFC-e (Nota Fiscal Consumidor Eletrônica).lnk');
        ApagaArquivoNoDeskTop('PAF-ECF (Programa Aplicativo Fiscal).lnk');
        ApagaArquivoNoDeskTop('CF-e-SAT (Sistema Autenticador e Transmissor de Cupons Fiscais Eletrônicos).lnk');
        ApagaArquivoNoDeskTop('PAF-NFC-e (Programa Aplicativo Fiscal).lnk');
      end;
      //
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    try
      ApagaArquivoNoDeskTop('Consulta.lnk');
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    Label2.Caption := 'Configurando sistema...';
    form1.Repaint;
    //
    // Modelo de impressora
    //
    try
      //
      Registro:= TRegistry.Create;
      Registro.Rootkey:=HKEY_LOCAL_MACHINE;
      Registro.Openkey('SOFTWARE\Daruma\ECF',False);
      sStringRegistro := Registro.ReadString('Produto');
      //
      if RadioButton2.Checked or RadioButton10.Checked or RadioButton11.Checked or RadioButton12.Checked then
      begin
        Registro.WriteString('Produto', 'FS345');
      end else
      begin
        Registro.WriteString('Produto', 'DS300');
      end;
      //
      Registro.Free;
      //
    except end;
    //
    try
      if Button1.Caption <> 'Concluir' then
      begin
        ShowMessage('O sistema não foi totalmente instalado.');
        Winexec('TASKKILL /F /IM setup.exe' , SW_HIDE );
        Abort;
      end;
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
      end;
    end;
    //
    ShellExecute( 0, 'Open', 'ie4uinit.exe'  ,'-ClearIconCache'                                 ,'',SW_HIDE);
    //
    if FileExists('c:\windows\explorer.exe') then
    begin
      //
      Winexec('TASKKILL /F /IM explorer.exe' , SW_HIDE );
      Sleep(5000);
      Winexec('c:\windows\explorer.exe' , SW_SHOW );
      //
    end;
    //
    Button3.Visible := False;
    Button1.Visible := False;
    Button2.Caption := 'Finalizar agora';
    Button2.Enabled := True;
    Button2.Left    := Button1.Left;
    //
    for I := 1 to 10 do
    begin
      //
      Label2.Caption := 'Finalizando automaticamente a'+chr(10)+'instalação do Small em '+(IntToStr(10-I));
      Panel1.Repaint;
      Application.ProcessMessages;
      Sleep(1000);
      //
    end;
    //
    form1.Hide;
    //
    Sleep(3000);
    keybd_event(VK_F5, 0, 0, 0);
    //
  end;
  //
end;

procedure TForm1.Button3Enter(Sender: TObject);
begin
  Label1.Font.Style := [fsBold];
end;

procedure TForm1.RadioButtonSemImpressoraKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_Return Then Button1.SetFocus;
end;

procedure TForm1.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
  begin
    Form1.Tag := 1;
    Button1.SetFocus;
  end;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  with Sender As tRadioButton do
  begin
    Form1.sModelo   := StrZero(Tag,2,0);
    Form1.sNome     := Caption;
  end;
end;


procedure TForm1.FormActivate(Sender: TObject);
var
  I, Z : Integer;
begin
  //
  I := Random(12);
  //
  try
    //
    for Z := 0 to StrToInt(Copy(TimetoStr(Time),7,2)) do
    begin
      I := Random(12);
    end;
    //
    if FileExists(Form1.sAtual+'\install\fundo\_small_'+IntToStr(I)+'.bmp') then
    begin
      Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\install\fundo\_small_'+IntToStr(I)+'.bmp');
      Form1.Image1.Repaint;
    end;
    //
  except end;
  //
  Image1.Top    := 100;
  Image1.Left   := 0;
  //
  sModelo := '01';
  //
  if Copy(Edit2.Text,1,31) = 'S' then
  begin
    Button1.SetFocus;
  end else
  begin
    Edit2.SetFocus;
  end;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Registro : TRegistry;
  Mais1Ini : tIniFile;
  //sHash,
  sAtual, sWindir : String;
  aWinDir: array[0..200] of Char;
begin
  //
  Form1.sPasta  := 'FFEAA766654488992624076BDF9907FBBDEFF3CF616D352280FD6F0E13A59109D7761E3E0492EAB3DF38EB6D125451C36662933A3AC0D5AAC6AC4F926E89'+
                   'F717DFB1F4CB28B1D11CD44517DDDC1A3D21AA1004C13FC87E952322E73E2A969A7240A51F324E11EC8D9B9367B1C28A69035EABD45C33FD522C21A798BE4F49B95B';
  //
  GetDir(0,sAtual);
  //
  {Sandro Silva 2023-01-04 inicio
  if FileExists(sAtual+'\cd2022_\setup.exe') then
  begin
    CHDir(sAtual+'\cd2022_');
  end;
  }
  if FileExists(sAtual+'\cd2023_\setup.exe') then
  begin
    CHDir(sAtual+'\cd2023_');
  end;
  {Sandro Silva 2023-01-04 fim}

  //
  GetDir(0,sAtual);
  //
  GetWindowsDirectory(aWinDir,200);
  sWinDir := AllTrim(StrPas(aWinDir));
  //
  //
  // Configurações REgionais
  //
  GetDir(0,Form1.sAtual);
  //
  try
    //
    Registro         := TRegistry.Create;
    Registro.RootKey := HKEY_CURRENT_USER;
    //
    // força para IE ficar trabalhando online
    //
    if Registro.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings', true) then
    begin
      Registro.WriteInteger('GlobalUserOffline', 0);
    end;
    //
    if Registro.OpenKey('Control Panel\International', False) then
    begin
      //
      Registro.WriteString('sYearMonth','MMMM'' de ''yyyy');
      Registro.WriteString('sTimeFormat','HH:mm:ss');
      Registro.WriteString('sTime',':');
      Registro.WriteString('sThousand','.');
      Registro.WriteString('sShortTime','HH:mm');
      Registro.WriteString('sShortDate','dd/MM/yyyy');
      Registro.WriteString('sPositiveSign','');
      Registro.WriteString('sNegativeSign','-');
      Registro.WriteString('sNativeDigits','0123456789');
      Registro.WriteString('sMonThousandSep','.');
      Registro.WriteString('sMonGrouping','3;0');
      Registro.WriteString('sMonDecimalSep',',');
      Registro.WriteString('sLongDate','dddd, d'' de ''MMMM'' de ''yyyy');
      Registro.WriteString('sList',';');
      Registro.WriteString('sLanguage','PTB');
      Registro.WriteString('sGrouping','3;0');
      Registro.WriteString('sDecimal',',');
      Registro.WriteString('sDate','/');
      Registro.WriteString('sCurrency','R$');
      Registro.WriteString('sCountry','Brasil');
      Registro.WriteString('s2359','');
      Registro.WriteString('s1159','');
      //
      Registro.WriteString('NumShape','1');
      Registro.WriteString('LocaleName','pt-BR');
      Registro.WriteString('Locale','00000416');
      Registro.WriteString('iTLZero','1');
      Registro.WriteString('iTimePrefix','0');
      Registro.WriteString('iTime','1');
      Registro.WriteString('iPaperSize','9');
      Registro.WriteString('iNegNumber','1');
      Registro.WriteString('iNegCurr','9');
      Registro.WriteString('iMeasure','0');
      Registro.WriteString('iLZero','1');
      Registro.WriteString('iFirstWeekOfYear','0');
      Registro.WriteString('iFirstDayOfWeek','6');
      Registro.WriteString('iDigits','2');
      Registro.WriteString('iDate','1');
      Registro.WriteString('iCurrency','2');
      Registro.WriteString('iCurrDigits','2');
      Registro.WriteString('iCountry','55');
      Registro.WriteString('iCalendarType','1');
      //
    end;
    //
    Registro.Free;
    //
  except end;
  //
  try
    //
    Mais1ini   := TIniFile.Create('WIND0WS.L0G');
    Edit2.Text := Mais1Ini.ReadString('LICENCA','Ser','');
    //
    if Edit2.Text = '' then Edit2.Text := Mais1Ini.ReadString('RR','Ser','');
    //
    Mais1Ini.Free;
    //
  except
    Edit2.Text := '';
  end;
  //
  Form1.Height := 380;
  Form1.Width  := 590;
  //
  try
    ApagaArquivoNoDeskTop('Consulta.lnk');
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
  //
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open',pChar('http://www.smallsoft.com.br'),'', '', SW_SHOWMAXIMIZED);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  ShellExecute( 0, 'Open', 'install\manual_small.pdf'  ,'','',sw_showmaximized);
end;

procedure TForm1.RadioButtonSemImpressoraEnter(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 1;
end;

end.



