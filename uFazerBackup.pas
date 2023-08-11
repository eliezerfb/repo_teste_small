unit uFazerBackup;

interface

uses
  SysUtils
  , Controls
  , Forms
  , IniFiles
  , FileCtrl
  , Windows
  , ShellAPI
  {$IFDEF VER150}
  , SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
//  , Mais
//  , unit19
  ;

type
  TBackup = class
  private
    //FArquivoBKP: String;
    procedure Backup(sArquivo: String);
  public
    FDiretorioBKP: String;
    FNomeArquivoBKP : string; // Mauricio Parizotto 2023-08-09
    FMostraDialogs : Boolean;// Mauricio Parizotto 2023-08-09
    constructor Create;
    destructor Destroy; override;
    function FazerBackup: Integer;
  end;


implementation

//uses Unit7;

procedure TBackup.Backup(sArquivo: String);
var
  vContador : integer;
  vDirSistema : string; // Mauricio Parizotto 2023-08-09
begin
  vContador := 0; //Mauricio Parizotto 2023-08-10
  vDirSistema := ExtractFilePath(Application.ExeName);

  if FileExists(Trim(sArquivo)) then
  begin
    //ShellExecute( 0, 'Open', 'szip.exe', pChar('backup "' + Trim(sArquivo) + '" "' + FDiretorioBKP + '"'), '', SW_SHOWMAXIMIZED);
    //ShellExecute( 0, 'Open', pChar(vDirSistema+'szip.exe'), pChar('backup "' + Trim(sArquivo) + '" "' + FDiretorioBKP + '"'), '', SW_SHOWMAXIMIZED);
    ShellExecute( 0, 'Open', pChar(vDirSistema+'szip.exe'), pChar('backup "' + Trim(sArquivo) + '" "' + FDiretorioBKP + '"'), '', SW_SHOWMAXIMIZED);

    while ConsultaProcesso('szip.exe') do
    begin
      //Sleep(100);
      Sleep(1000);

      Inc(vContador);

      //Timeout 10 min
      if vContador > 600 then
        Winexec('TASKKILL /F /IM "szip.exe"' , SW_HIDE ); // Mauricio Parizotto 2023-08-10
    end;
  end;
end;

constructor TBackup.Create;
begin
  inherited;

end;

destructor TBackup.Destroy;
begin

  inherited;
end;

function TBackup.FazerBackup: Integer;
var
  Mais1Ini: TIniFile;
  bButton: Integer;
  vDirSistema : string; // Mauricio Parizotto 2023-08-09
begin
  Result := IDCANCEL;
  //SelectDirectory('Selecione um dispositivo de armazenamento externo que seja seguro para fazer uma cópia do banco de dados.', '', FArquivoBKP);

  //if FArquivoBKP <> '' then
  if FDiretorioBKP <> '' then
  begin
    //FArquivoBKP := StrTran(FArquivoBKP + '\' + Limpanumero(Form7.ibDataset13CGC.AsString) + '_' + Alltrim(DiaDaSemana(date)) + '.zip', '\\', '\');
    FDiretorioBKP := StrTran(FDiretorioBKP + '\' + FNomeArquivoBKP + '.zip', '\\', '\');

    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    {
    try
      Commitatudo(True);
    except
    end;

    try
      FechaTudo(Form1.bFechaTudo);
      Form7.ibDataSet13.Close;
    except
    end;

    Mauricio Parizotto 2023-08-09}

    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
    Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer

    //while Form7.ibDataSet13.Active do
    //  Sleep(100);

    vDirSistema := ExtractFilePath(Application.ExeName);

    //if FileExists(Alltrim(Form1.sAtual + '\small.fdb')) then
    if FileExists(Alltrim(vDirSistema + 'small.fdb')) then
    begin
      while FileExists(FDiretorioBKP) do
      begin
        DeleteFile(pChar(FDiretorioBKP));
        Sleep(100);
      end;

      {
      Backup(Form1.sAtual + '\small.fdb');
      Backup(Form1.sAtual + '\nfe.ini');
      Backup(Form1.sAtual + '\smallcom.inf');
      Backup(Form1.sAtual + '\est0que.dat');
      Backup(Form1.sAtual + '\ANVISA.FDB');
      Backup(Form1.sAtual + '\nfseConfig.ini');
      Backup(Form1.sAtual + '\logo*.bmp');
      Backup(Form1.sAtual + '\etiquetas.inf');
      Backup(Form1.sAtual + '\etiquetase.ini');
      Mauricio Parizotto 2023-08-09}

      Backup(vDirSistema + 'small.fdb');
      Backup(vDirSistema + 'nfe.ini');
      Backup(vDirSistema + 'smallcom.inf');
      Backup(vDirSistema + 'est0que.dat');
      Backup(vDirSistema + 'ANVISA.FDB');
      Backup(vDirSistema + 'nfseConfig.ini');
      Backup(vDirSistema + 'logo*.bmp');
      Backup(vDirSistema + 'etiquetas.inf');
      Backup(vDirSistema + 'etiquetase.ini');

      //while not FileExists(FDiretorioBKP) do Mauricio Parizotto 2023-08-10 - se der algum erro vai ficar travado
      begin
        //Sleep(100);
        Sleep(1000);
      end;

      Screen.Cursor := crDefault; // Cursor de Aguardo

      if FileExists(FDiretorioBKP) then
      begin
        //if (Copy(UpperCase(Form1.sAtual), 1, 2) = Copy(UpperCase(FDiretorioBKP), 1, 2)) and (Copy(FDiretorioBKP, 2, 1) = ':') then Mauricio Parizotto 2023-08-09
        if (Copy(UpperCase(vDirSistema), 1, 2) = Copy(UpperCase(FDiretorioBKP), 1, 2)) and (Copy(FDiretorioBKP, 2, 1) = ':') then
        begin
          if FMostraDialogs then
          begin
            Application.MessageBox(Pchar(
                                        'O Sistema fez uma cópia compactada do banco de dados em: ' + chr(10) + chr(10) + FDiretorioBKP + chr(10) + chr(10)+
                                        'Está cópia não está segura em caso de defeito de equipamento, roubo, formatação indevida ou em outra eventualidade. Faça uma cópia em um dispositivo externo.'+Chr(10)+Chr(10)+Chr(10))
                                        , 'Atenção', mb_Ok + MB_ICONWARNING);
            Result := IDIGNORE;
          end else
          begin
            Result := IDYES;
          end;
        end else
        begin
          if FMostraDialogs then
          begin
            Result := Application.MessageBox(Pchar(
                                                  'O Sistema fez uma cópia compactada do banco de dados em: ' + chr(10) + chr(10) + FDiretorioBKP + chr(10) + chr(10) +
                                                  'Em caso de defeito de equipamento, roubo, formatação indevida do seu servidor ou em outra eventualidade está copia está realmente segura?'+Chr(10)+Chr(10)+Chr(10))
                                                  ,'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

            if Result = IDYES then
            begin
              //Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf'); Mauricio Parizotto 2023-08-09
              Mais1ini := TIniFile.Create(vDirSistema+'smallcom.inf');
              Mais1Ini.WriteString('Backup','Último backup',DateToStr(date));
            end;
          end else
          begin
            Result := IDYES;
          end;
        end;
      end  else
      begin
        Result := IDCANCEL;

        if FMostraDialogs then
        begin
          Application.MessageBox(Pchar(
                                      'Erro não foi possível fazer o backup. Aquivo: ' + chr(10) + chr(10) + Alltrim(vDirSistema + 'small.fdb') + chr(10) + chr(10) + 'não encontrado')
                                      , 'Atenção', mb_Ok + MB_ICONWARNING);
        end;
      end;
    end;
  end;
end;

end.
