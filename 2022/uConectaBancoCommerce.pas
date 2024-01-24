(* Unit para tratar exitência ou não do banco e conectar*)
unit uConectaBancoCommerce;

interface

uses
  Controls
  , SysUtils
  , Forms
  , Dialogs
  , Windows
  , IniFiles
  , ShellAPI
  ;

function ConectaBancoCommerce: Boolean;

implementation

uses
  Unit7
  , Mais
  , uFuncoesRetaguarda
  , Unit22
  , smallfunc_xe
  , uValidaRecursosDelphi7
  , uDialogs;

function ConectaBancoCommerce: Boolean;
var
  Mais1Ini: TIniFile;
  IP, url, Alias, sConve, sOrigem: String;
  sCertificado: String;
begin
  Result := True;
  begin
    Form7.bFlag := True;
    // Cria os arquivos no diretório atual //
    Form7.sProcura := '';
    Screen.Cursor := crHourGlass;                  // Cursor de Aguardo

    try
      Screen.Cursor := crHourGlass;    // Cursor de Aguardo

      if (not FileExists(Form1.sAtual+'\'+'small.fdb'))   and (FileExists(Form1.sAtual+'\'+'small.gdb'))   then RenameFile(pchar(Form1.sAtual+'\'+'small.gdb'),pchar(Form1.sAtual+'\'+'small.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'exemplo.fdb')) and (FileExists(Form1.sAtual+'\'+'exemplo.gdb')) then RenameFile(pchar(Form1.sAtual+'\'+'exemplo.gdb'),pchar(Form1.sAtual+'\'+'exemplo.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'padrao.fdb'))  and (FileExists(Form1.sAtual+'\'+'padrao.gdb'))  then RenameFile(pchar(Form1.sAtual+'\'+'padrao.gdb'),pchar(Form1.sAtual+'\'+'padrao.fdb'));
      if (not FileExists(Form1.sAtual+'\'+'off.fdb'))     and (FileExists(Form1.sAtual+'\'+'off.gdb'))     then RenameFile(pchar(Form1.sAtual+'\'+'off.gdb'),pchar(Form1.sAtual+'\'+'off.fdb'));

      if (not FileExists(Form1.sAtual+'\'+'small.fdb'))   and (FileExists(Form1.sAtual+'\'+'small.gdb'))   then
      begin

        Result := False;

        Screen.Cursor := crDefault;
        {
        ShowMessage('Não foi possível renomear o arquivo SMALL.GDB para SMALL.FDB'+Chr(10)+Chr(10)+
          ' 1 - Feche todos os programas que usam o SMALL.GDB em todos os terminais'+Chr(10)+
          ' 2 - Execute o Small Commerce novamente');
        Mauricio Parizotto 2023-10-25}
        MensagemSistema('Não foi possível renomear o arquivo SMALL.GDB para SMALL.FDB'+Chr(10)+Chr(10)+
                        ' 1 - Feche todos os programas que usam o SMALL.GDB em todos os terminais'+Chr(10)+
                        ' 2 - Execute o Small Commerce novamente'
                        ,msgAtencao);

        Application.Terminate;
        // Sandro Silva 2023-05-31 Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
        FecharAplicacao(ExtractFileName(Application.ExeName));
      end;

      Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
      Url      := Mais1Ini.ReadString('Firebird','Server url','');
      IP       := Trim(Mais1Ini.ReadString('Firebird','Server IP',''));
      Alias    := Trim(Mais1Ini.ReadString('Firebird','Alias',''));
      sConve   := Trim(Mais1Ini.ReadString('T','Tempo','00:00:00'));
      sOrigem  := Trim(Mais1Ini.ReadString('T','Origem','00'));

      if IP = '' then
        IP := GetIp;

      if IP <> '' then
        Url := IP+':'+Url+'\small.fdb' else Url:= Url+'\small.fdb';

      if Trim(Alias) <> '' then
      begin
        Url := IP+':'+Alias;
      end;

      Mais1Ini.Free;

      Mensagem22(Form1.sAtual);
      Form22.sIniciandoEm   := 'Iniciando em: '+Form1.sAtual;
      Form22.sUrlDoGdb      := 'Url do FDB:   '+Trim(Url);

      // Se não existe cria o arquivo GDB
      try
        Form7.IBDatabase1.Close;
        Form7.IBDatabase1.Params.Clear;
        Form7.IbDatabase1.DatabaseName := Url;
        Form7.IBDatabase1.Params.Add('USER_NAME=SYSDBA');
        Form7.IBDatabase1.Params.Add('PASSWORD=masterkey');
        Form7.IbDatabase1.Open;
        Form7.IBTransaction1.Active := True;
      except
        Mensagem22('Aguarde instalando arquivos de atualização (10)...');

        while FileExists(Form1.sAtual+'\firebird.exe') do
        begin
          DeleteFile(pChar(Form1.sAtual+'\firebird.exe'));
          Sleep(1000);
        end;

        if not FileExists(pChar(Form1.sAtual+'\firebird.~~1')) then
        begin

          Result := False;

          //ShowMessage('Reinstale o sistema.'); Mauricio Parizotto 2023-10-25
          MensagemSistema('Reinstale o sistema.',msgAtencao);

          // Sandro Silva 2023-05-31 Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          FecharAplicacao(ExtractFileName(Application.ExeName));
        end;

        while not FileExists(Form1.sAtual+'\firebird.exe') do
        begin
          CopyFile(pChar(Form1.sAtual+'\firebird.~~1'),pChar(Form1.sAtual+'\firebird.exe'),False);
          Sleep(100);
        end;

        {
        Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
        sCertificado := Trim(Mais1ini.ReadString('NFE','Certificado',''));
        Mais1ini.Free;

        if Trim(sCertificado) = '' then
        begin
          if (Copy(Form1.sSerial,4,1) <> 'N') and
             (Copy(Form1.sSerial,4,1) <> 'O') and
             (Copy(Form1.sSerial,4,1) <> 'P') and
             (Copy(Form1.sSerial,4,1) <> 'Q') and
             (Copy(Form1.sSerial,4,1) <> 'R') and
             (Copy(Form1.sSerial,4,1) <> 'M') then
          begin
            Form1.SelecionarCertificadoDigital1Click(Form1.SelecionarCertificadoDigital1); // Sandro Silva 2023-05-31 Form1.SelecionarCertificadoDigital1Click(Sender);
          end;
        end;
        }

        Form22.Image1.Visible := False;
        Mensagem22('');
        Form22.Repaint;
        Sleep(1000);

        ShellExecute( 0, 'Open', pChar(Form1.sAtual+'\firebird.exe'),'', '', SW_SHOW);

        while ConsultaProcesso('firebird.exe') do
        begin
          sleep(1000);
        end;

        if FileExists(Form1.sAtual+'\firebird.exe') then
        begin
          DeleteFile(pChar(Form1.sAtual+'\firebird.exe'));
          Sleep(1000);
        end;

        Form22.Image1.Visible := True;
        Form22.Repaint;

        try
          Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
          Url := Mais1Ini.ReadString('Firebird','Server url','');
          if Trim(Mais1Ini.ReadString('Firebird','Server IP','')) <> '' then
            Url := Mais1Ini.ReadString('Firebird','Server IP','')+':'+Url;
          Mais1Ini.Free;
          Form7.IBDatabase1.Close;
          Form7.IBDatabase1.Params.Clear;
          Form7.IbDatabase1.DatabaseName := Url+'\small.fdb';
          Form7.IBDatabase1.Params.Add('USER_NAME=SYSDBA');
          Form7.IBDatabase1.Params.Add('PASSWORD=masterkey');
          Form7.IbDatabase1.Open;
          Form7.IBTransaction1.Active := True;
        except
          Result := False;

          Screen.Cursor := crDefault;
          {
          ShowMessage('Verifique:'+Chr(10)+Chr(10)+
            ' 1 - Se o servidor firebird está instalado (reinicie o windows).'+Chr(10)+
            ' 2 - Se o IP e a URL do servidor estão configurados corretamente.'+Chr(10)+
            ' 3 - Se a sua conexão de rede está disponível.'+Chr(10)+
            ' 4 - Se a porta 3050 está liberada no firewal do windows.'+Chr(10)+
            ' 5 - Se for necessário, reinstale o sistema...');
          Mauricio Parizotto 2023-10-25}
          MensagemSistema('Verifique:'+Chr(10)+Chr(10)+
                          ' 1 - Se o servidor firebird está instalado (reinicie o windows).'+Chr(10)+
                          ' 2 - Se o IP e a URL do servidor estão configurados corretamente.'+Chr(10)+
                          ' 3 - Se a sua conexão de rede está disponível.'+Chr(10)+
                          ' 4 - Se a porta 3050 está liberada no firewal do windows.'+Chr(10)+
                          ' 5 - Se for necessário, reinstale o sistema...'
                          ,msgAtencao);

          Application.Terminate;
          // Sandro Silva 2023-05-31 Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
          FecharAplicacao(ExtractFileName(Application.ExeName));
        end;
      end;

      Form7.IBQuery1.Close;
      Form7.IBQuery1.SQL.Clear;
      Form7.IBQuery1.SQL.Add('select current_time,current_date from rdb$database');
      Form7.IBQuery1.Open;

      Form1.tSgdb := StrToTime(Form7.IBQuery1.FieldByname('CURRENT_TIME').AsString) - Time;
    except
      Result := False;

      Screen.Cursor := crDefault;
      //Application.MessageBox(Pchar('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.'),'Atenção',mb_IconError+mb_Ok);Mauricio Parizotto 2023-10-25
      MensagemSistema('Não foi possível ativar os arquivos do banco de dados "Client Server" o programa vai ser fechado.',msgAtencao);

      Application.Terminate;
      // Sandro Silva 2023-05-31 Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
      FecharAplicacao(ExtractFileName(Application.ExeName));
    end;
  end;

  Form1.ValidaRecursos.IBDATABASE := Form7.IBDatabase1;

  Form1.sSerial := Form1.ValidaRecursos.SistemaSerial; // Sandro Silva 2023-05-31
end;

end.
