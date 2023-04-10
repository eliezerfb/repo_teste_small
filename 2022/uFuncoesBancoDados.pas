unit uFuncoesBancoDados;

interface

uses
  SysUtils
  , Dialogs
  , IBDatabase
  , IBQuery
;

function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
function ExecutaComando(comando:string):Boolean;

implementation

uses
  mais
  ;

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
      'and F.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
      ' and F.RDB$FIELD_NAME = ' + QuotedStr(sCampo);
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

end.
