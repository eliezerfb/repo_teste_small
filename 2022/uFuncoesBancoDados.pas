unit uFuncoesBancoDados;

interface

uses
  SysUtils
  , Dialogs
  , IBDatabase
  , IBQuery
;

function TabelaExisteFB(Banco: TIBDatabase; sTabela: String): Boolean;
function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
function GeneratorExisteFB(Banco: TIBDatabase; sGenerator: String): Boolean;
function TamanhoCampo(IBTransaction: TIBTransaction; Tabela: String;
  Campo: String): Integer;
function ExecutaComando(comando:string):Boolean;
function ExecutaComandoEscalar(Banco: TIBDatabase; vSQL : string): Variant;

implementation

uses
  mais
  , DB;

function TabelaExisteFB(Banco: TIBDatabase; sTabela: String): Boolean;
{Sandro Silva 2015-10-01 inicio
Retorna True se encontrar a tabela informada}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select distinct F.RDB$RELATION_NAME as TABELA ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and upper(F.RDB$RELATION_NAME) = upper(' + QuotedStr(sTabela) + ')';
    IBQUERY.Open;
    Result := (IBQUERY.FieldByName('TABELA').AsString <> '');
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
{Sandro Silva 2011-04-15 inicio
Retorna True se encontrar a tabela e o campo informado}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and upper(F.RDB$RELATION_NAME) = upper(' + QuotedStr(sTabela) + ') ' +
      ' and upper(F.RDB$FIELD_NAME) = upper(' + QuotedStr(sCampo) + ')';
    IBQUERY.Open;
    Result := (IBQUERY.IsEmpty = False);
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
{Sandro Silva 2011-04-12 inicio
Cria um objeto TIBTransaction}
begin
  try
    Result := TIBTransaction.Create(nil); // Sandro Silva 2019-06-18 Result := TIBTransaction.Create(Application);
    Result.Params.Add('read_committed');
    Result.Params.Add('rec_version');
    Result.Params.Add('nowait');
    Result.DefaultDatabase := IBDATABASE;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Result := nil;
    end
  end;
end;

function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
// Sandro Silva 2011-04-12 inicio Cria um objeto TIBQuery
begin
  try
    Result := TIBQuery.Create(nil); // Sandro Silva 2019-06-18 Result := TIBQuery.Create(Application);
    Result.Database    := IBTRANSACTION.DefaultDataBase;
    Result.Transaction := IBTRANSACTION;
    Result.BufferChunks := 100; // 2014-02-26 Erro de out of memory
  except
    on E: Exception do
    begin
      Result := nil;
    end
  end;
end;

function GeneratorExisteFB(Banco: TIBDatabase; sGenerator: String): Boolean;
{Sandro Silva 2023-04-19 inicio
Retorna True se encontrar o generator informado}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select RDB$GENERATOR_NAME as GENERATOR ' +
      'from RDB$GENERATORS ' +
      'where upper(RDB$GENERATOR_NAME) = upper(:GENERATOR) ';
    IBQUERY.ParamByName('GENERATOR').AsString := sGenerator;
    IBQUERY.Open;
    Result := (IBQUERY.FieldByName('GENERATOR').AsString <> '');
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function TamanhoCampo(IBTransaction: TIBTransaction; Tabela: String;
  Campo: String): Integer;
// Sandro Silva 2018-07-26 Retorna o tamanho do campo na tabela do banco.
// Usado para evitar tentativa de gravar mais caracteres que o campo suporta
var
  IBQTABELA: TIBQuery;
begin
  Result := 0;
  IBQTABELA := CriaIBQuery(IBTransaction);
  try
    IBQTABELA.Close;
    IBQTABELA.SQL.Text :=
      'select first 1 ' + Campo +
      ' from ' + Tabela +
      ' where REGISTRO = ''xxx'' ';
    IBQTABELA.Open;
    Result := IBQTABELA.FieldByName(Campo).Size;
  except

  end;
  FreeAndNil(IBQTABELA);
end;

function ExecutaComando(comando:string):Boolean;
begin
  Result := False;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add(comando);
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;

    Result := True;
  except
  end;
end;


function ExecutaComandoEscalar(Banco: TIBDatabase; vSQL : string): Variant;
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);

  try
    IBQUERY.Close;
    IBQUERY.SQL.Text := vSQL;
    IBQUERY.Open;
    Result := IBQUERY.Fields[0].AsVariant;
  finally
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;



end.
