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
  , SmallFunc
  , Mais
  , unit19
  ;

type
  TBackup = class
  private
    FArquivoBKP: String;
    procedure Backup(sArquivo: String);
  public
    constructor Create;
    destructor Destroy; override;
    function FazerBackup(Sender: TObject): Integer;
  end;


implementation

uses Unit7;

procedure TBackup.Backup(sArquivo: String);
begin

  if FileExists(Trim(sArquivo)) then
  begin
    //
    ShellExecute( 0, 'Open', 'szip.exe', pChar('backup "' + Trim(sArquivo) + '" "' + FArquivoBKP + '"'), '', SW_SHOWMAXIMIZED);
    //
    while ConsultaProcesso('szip.exe') do
    begin
      Sleep(100);
    end;
    //
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

function TBackup.FazerBackup(Sender: TObject): Integer;
var
  Mais1Ini: TIniFile;
  //sArquivoBKP: String;
  bButton: Integer;
begin
  Result := IDCANCEL;
  SelectDirectory('Selecione um dispositivo de armazenamento externo que seja seguro para fazer uma cópia do banco de dados.', '', FArquivoBKP);
  //
  if FArquivoBKP <> '' then
  begin
    //
    FArquivoBKP := StrTran(FArquivoBKP + '\' + Limpanumero(Form7.ibDataset13CGC.AsString) + '_' + Alltrim(DiaDaSemana(date)) + '.zip', '\\', '\');
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    try
      Commitatudo(True); // SQL - Commando
    except end;
    try
      FechaTudo(Form1.bFechaTudo);
      Form7.ibDataSet13.Close;
    except end;
    //
    Winexec('TASKKILL /F /IM "mobile.exe"' , SW_HIDE ); // // Form1Close
    Winexec('TASKKILL /F /IM "mkp.exe"' , SW_HIDE ); // Timer2Timer

    while Form7.ibDataSet13.Active do
      Sleep(100);

    if FileExists(Alltrim(Form1.sAtual + '\small.fdb')) then
    begin

      while FileExists(FArquivoBKP) do
      begin
        DeleteFile(pChar(FArquivoBKP));
        Sleep(100);
      end;

      Backup(Form1.sAtual + '\small.fdb');
      Backup(Form1.sAtual + '\nfe.ini');
      Backup(Form1.sAtual + '\smallcom.inf');
      Backup(Form1.sAtual + '\est0que.dat');
      Backup(Form1.sAtual + '\ANVISA.FDB');
      Backup(Form1.sAtual + '\nfseConfig.ini');
      Backup(Form1.sAtual + '\logo*.bmp');
      Backup(Form1.sAtual + '\etiquetas.inf');
      Backup(Form1.sAtual + '\etiquetase.ini');

      while not FileExists(FArquivoBKP) do
      begin
        Sleep(100);
      end;

      Screen.Cursor := crDefault; // Cursor de Aguardo

      if FileExists(FArquivoBKP) then
      begin
        if (Copy(UpperCase(Form1.sAtual), 1, 2) = Copy(UpperCase(FArquivoBKP), 1, 2)) and (Copy(FArquivoBKP, 2, 1) = ':') then
        begin
          Application.MessageBox(Pchar(
            'O Sistema fez uma cópia compactada do banco de dados em: ' + chr(10) + chr(10) + FArquivoBKP + chr(10) + chr(10)+
            'Está cópia não está segura em caso de defeito de equipamento, roubo, formatação indevida ou em outra eventualidade. Faça uma cópia em um dispositivo externo.'+Chr(10)+Chr(10)+Chr(10))
            , 'Atenção', mb_Ok + MB_ICONWARNING);

          Result := IDIGNORE;
        end else
        begin
          Result := Application.MessageBox(Pchar(
            'O Sistema fez uma cópia compactada do banco de dados em: ' + chr(10) + chr(10) + FArquivoBKP + chr(10) + chr(10) +
            'Em caso de defeito de equipamento, roubo, formatação indevida do seu servidor ou em outra eventualidade está copia está realmente segura?'+Chr(10)+Chr(10)+Chr(10))
            ,'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

          if Result = IDYES then
          begin
            Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
            Mais1Ini.WriteString('Backup','Último backup',DateToStr(date));
          end;

        end;

      end
      else
      begin
        Result := IDCANCEL;
        Application.MessageBox(Pchar(
          'Erro não foi possível fazer o backup. Aquivo: ' + chr(10) + chr(10) + Alltrim(Form1.sAtual + '\small.fdb') + chr(10) + chr(10) + 'não encontrado')
          , 'Atenção', mb_Ok + MB_ICONWARNING);

      end;
    end;
  end;
end;

end.
