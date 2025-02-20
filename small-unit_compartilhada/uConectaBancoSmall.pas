{Mauricio Parizotto 2022-11-22 Padronizado conexão com banco de dados}
unit uConectaBancoSmall;

interface

uses
  {$IFDEF VER150}
  IBDatabase, IniFiles, SysUtils, Dialogs, Forms, IBQuery;
  {$ELSE}
  IBX.IBDatabase, System.IniFiles, System.SysUtils, Vcl.Dialogs, Vcl.Forms,
  IBX.IBQuery;
  {$ENDIF }

  //IBX
  function Conectar_SMALL(DataBase1 : TIBDatabase; Aviso : Boolean = True): Boolean;
  function CriaIBTransaction(IBDatabase: TIBDatabase): TIBTransaction;
  function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
  function CampoExisteFB(Banco: TIBDatabase; sTabela: String; sCampo: String): Boolean;
  function ExecutaComando(IBTRANSACTION: TIBTransaction; vSql : string) : Boolean;
  function ExecutaComandoScalar(IBTRANSACTION: TIBTransaction; vSql : string) : Variant;

implementation

uses uDialogs;

function Conectar_SMALL(DataBase1 : TIBDatabase; Aviso : Boolean = True): Boolean;
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
    //Showmessage('Não existe o arquivo de configuração do banco de dados para Small'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Não existe o arquivo de configuração do banco de dados para Small',msgAtencao);
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
        if Aviso then // Mauricio Parizotto 2023-08-08
          {
          Showmessage('Erro ao abrir banco Small:'
                      +chr(13)+'String do Banco: '+sbanco
                      +chr(13)+chr(13)+'Erro:'
                      +chr(13)+e.Message);
          Mauricio Parizotto 2023-10-25}
          MensagemSistema('Erro ao abrir banco Small:'
                          +chr(13)+'String do Banco: '+sbanco
                          +chr(13)+chr(13)+'Erro:'
                          +chr(13)+e.Message
                          ,msgErro);
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
    end
  end;
end;


function CampoExisteFB(Banco: TIBDatabase; sTabela: String; sCampo: String): Boolean;
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
                        ' Select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
                        ' From RDB$RELATION_FIELDS F ' +
                        '   Join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
                        '     and R.RDB$VIEW_BLR is null ' +
                        '     and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
                        '     and F.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
                        '     and F.RDB$FIELD_NAME = ' + QuotedStr(sCampo);
    IBQUERY.Open;
    Result := (IBQUERY.IsEmpty = False);
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function ExecutaComando(IBTRANSACTION: TIBTransaction; vSql : string) : Boolean;
var
  qryAux: TIBQuery;
begin
  Result := False;

  qryAux := CriaIBQuery(IBTransaction);

  try
    try
      qryAux.SQL.Text := vSql;
      qryAux.ExecSQL;

      Result := True;
    finally
      FreeAndNil(qryAux);
    end;
  except
  end;
end;


function ExecutaComandoScalar(IBTRANSACTION: TIBTransaction; vSql : string) : Variant;
var
  qryAux: TIBQuery;
begin
  qryAux := CriaIBQuery(IBTransaction);

  try
    try
      qryAux.SQL.Text := vSql;
      qryAux.Open;

      Result := qryAux.Fields[0].Value;
    finally
      FreeAndNil(qryAux);
    end;
  except
  end;

end;

end.
