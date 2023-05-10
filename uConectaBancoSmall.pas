{Mauricio Parizotto 2022-11-22 Padronizado conexão com banco de dados}
unit uConectaBancoSmall;

interface

uses
  IBX.IBDatabase, System.IniFiles, System.SysUtils, Vcl.Dialogs, Vcl.Forms,
  IBX.IBQuery;

  function Conectar_SMALL(DataBase1 : TIBDatabase): Boolean;
  function CriaIBTransaction(IBDatabase: TIBDatabase): TIBTransaction;
  function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;

implementation

function Conectar_SMALL(DataBase1 : TIBDatabase): Boolean;
var
  sbanco, sAlias,sIP,sURL : String;
  arq_ini: TIniFile;
  LocalINI : string;
begin
  Result := False;
  //LOCAL do banco
  sBanco :='';
  sAlias :='';
  LocalINI := ExtractFilePath(application.exeName)+'SMALL.INI';
  //
  if not FileExists(LocalINI) then
  begin
    Showmessage('Não existe o arquivo de configuração do banco de dados para Small');
    Exit;
  end else
  begin
    arq_ini := TIniFile.create(LocalINI);
    sIP     := arq_ini.ReadString('Firebird','Server IP','');
    sURL    := arq_ini.ReadString('Firebird','Server URL','');
    sAlias  := arq_ini.ReadString('Firebird','Alias','');
    arq_ini.Free;
  end;

  if (sAlias='') then
  begin
    sURL := sURL+'\small.fdb'; //2015-10-06 Alceu Foppa Jr.
    sBanco := sIP+':'+sURL
  end else
  begin
    sBanco := sIP+':'+sAlias;
  end;

  if (sBanco <> '') then
  begin
    try
     {Sandro Silva 2014-05-23 inicio
     Evitar problema de não ter um ip configurado em small.ini}
     if Pos(':', sBanco) = 1 then
       sBanco := Copy(sBanco, 2, Length(sBanco));
     {Sandro Silva 2014-05-23 final}
      DataBase1.Close;
      DataBase1.LoginPrompt := false;
      DataBase1.DatabaseName := sBanco;
      DataBase1.Params.Clear;
      DataBase1.Params.Add('user_name=SYSDBA');
      DataBase1.Params.Add('password=masterkey');
      DataBase1.Open;
    except
    on e:exception do
      begin
        Showmessage('Erro ao abrir banco Small:'
                    +chr(13)+'String do Banco: '+sbanco
                    +chr(13)+chr(13)+'Erro:'
                    +chr(13)+e.Message);
      end;
    end;

    Result := DataBase1.Connected;
  end;
end;


function CriaIBTransaction(IBDatabase: TIBDatabase): TIBTransaction;
begin
  Result := nil;
  try
    Result := TIBTransaction.Create(nil);
    Result.Params.Add('read_committed');
    Result.Params.Add('rec_version');
    Result.Params.Add('nowait');
    Result.DefaultDatabase := IBDatabase;
    Result.Active := True;  // 2013-10-15 Evitar invalid transaction handle (expecting explicit transaction start)
  except
    on E: Exception do
    begin
      //2013-09-27 ShowMessage(E.Message);
    end
  end;
end;

function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
begin
  Result := nil;
  try
    Result := TIBQuery.Create(nil);
    Result.Database    := IBTRANSACTION.DefaultDatabase;
    Result.Transaction := IBTRANSACTION;
    if Result.Transaction.Active = False then // 2013-10-15 Evitar invalid transaction handle (expecting explicit transaction start)
      Result.Transaction.Active := True;
  except
    on E: Exception do
    begin
      //2013-09-27 ShowMessage(E.Message);
    end
  end;
end;

end.
