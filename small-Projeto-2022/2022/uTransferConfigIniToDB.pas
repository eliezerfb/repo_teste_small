unit uTransferConfigIniToDB;

interface

uses
  RTTI, System.IniFiles, IBX.IBDatabase, IBX.IBQuery, System.Variants,
  System.SysUtils,

  uArquivosDAT, uSmallConsts;

type
(*TO-DO: A ideia aqui é converter outros tipos de dados, daí vai ser necessário
mudar um pouco a lógica, usando algum map ou outra forma de converter os tipos
de dados*)
  TTransferConfigIniToDB = class
  const
    MIGRATED = 'migrated';
  private
    FIBTransaction: TIBTransaction;
    FIBDataBase: TIBDataBase;
    FIniFile: TIniFile;
    FConfSistema: TArquivosDAT;
    function ConvertStringToBoolean(AValueToConvert: String): Boolean;
    function FieldHasValue(AFieldDB: String): Boolean;
    procedure SetMigrated(ASectionIni, AIdentIni: String);
  public
    constructor Create(AIBDataBase: TIBDataBase;
      AIBTransaction: TIBTransaction);
    destructor Destroy;
    property IniFile: TIniFile read FIniFile write FIniFile;
    procedure ConvertBooleanIniToBD(ASectionIni, AIdentIni, ADefaultIni,
      AConfigName: string);
  end;

implementation

{ TTransferConfigIniToDB }

procedure TTransferConfigIniToDB.ConvertBooleanIniToBD(ASectionIni, AIdentIni,
  ADefaultIni, AConfigName: string);
begin
  var IniValue := FIniFile.ReadString(ASectionIni, AIdentIni, ADefaultIni);
  if IniValue = MIGRATED then
    Exit;

  var QryConfig := TIBQuery.Create(nil);
  try
    if FieldHasValue(AConfigName) then
    begin
      SetMigrated(ASectionIni, AIdentIni);
      Exit;
    end;

    var Obj := FConfSistema.BD.Outras;
    var Context := TRttiContext.Create;
    try
      var RttiType := Context.GetType(Obj.ClassType);
      var RttiProperty := RttiType.GetProperty(AConfigName);
      if Assigned(RttiProperty) then
        RttiProperty.SetValue(Obj, ConvertStringToBoolean(IniValue));
    finally
      Context.Free;
    end;
    FIBTransaction.Commit;
    SetMigrated(ASectionIni, AIdentIni);
  finally
    QryConfig.Free;
  end;
end;

function TTransferConfigIniToDB.ConvertStringToBoolean(
  AValueToConvert: String): Boolean;
begin
  AValueToConvert := LowerCase(AValueToConvert);
  Result := (AValueToConvert = 'sim') or (AValueToConvert = 's')
    or (AValueToConvert = '1')
end;

constructor TTransferConfigIniToDB.Create(AIBDataBase: TIBDataBase;
  AIBTransaction: TIBTransaction);
begin
  inherited Create;
  FIBTransaction := AIBTransaction;
  FIBDataBase := AIBDataBase;
  FConfSistema := TArquivosDAT.Create('', FIBTransaction);
end;

destructor TTransferConfigIniToDB.Destroy;
begin
  FConfSistema.Free;
  FIBTransaction.Free;
  FIBDataBase.Free;
  inherited Destroy;
end;

function TTransferConfigIniToDB.FieldHasValue(AFieldDB: String): Boolean;
begin
  var QryConfig := TIBQuery.Create(nil);
  try
    QryConfig.Database := FIBDataBase;
    QryConfig.Transaction := FIBTransaction;
    QryConfig.SQL.Text := 'select 1 from rdb$database '+
      'where exists(select idconfiguracaosistema from configuracaosistema '+
      'where nome = :nome)';
    QryConfig.Prepare;
    QryConfig.ParamByName('nome').AsString := AFieldDB;
    QryConfig.Open();
    Result := QryConfig.Fields[0].AsInteger = 1;
  finally
    QryConfig.Free;
  end;
end;

procedure TTransferConfigIniToDB.SetMigrated(ASectionIni, AIdentIni: String);
begin
  FIniFile.WriteString(ASectionIni, AIdentIni, MIGRATED);
end;

end.
