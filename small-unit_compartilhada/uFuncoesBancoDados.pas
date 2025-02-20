unit uFuncoesBancoDados;

interface

uses
  SysUtils
  , Dialogs
  , IBDatabase
  , IBQuery
  , DB
  , uSmallConsts
  , IBCustomDataSet
;

const SELECT_TABELA_VIRTUAL_FORMAS_DE_PAGAMENTO =
  //Mauricio Parizotto 2024-04-16
  //'select NOME ' +
  //'from (' +
  ' (' +
  'select cast(''01'' as varchar(2)) as ID, cast(''Dinheiro'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''02'' as varchar(2)) as ID, cast(''Cheque'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''03'' as varchar(2)) as ID, cast(''Cartão de Crédito'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''04'' as varchar(2)) as ID, cast(''Cartão de Débito'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''05'' as varchar(2)) as ID, cast(''Crédito de Loja'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''10'' as varchar(2)) as ID, cast(''Vale Alimentação'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''11'' as varchar(2)) as ID, cast(''Vale Refeição'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''12'' as varchar(2)) as ID, cast(''Vale Presente'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''13'' as varchar(2)) as ID, cast(''Vale Combustível'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''14'' as varchar(2)) as ID, cast(''Duplicata Mercanti'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''15'' as varchar(2)) as ID, cast(''Boleto Bancário'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''16'' as varchar(2)) as ID, cast(''Depósito Bancário'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  {Mauricio Parizotto 204-07-10 Inicio}
  //'select cast(''17'' as varchar(2)) as ID, cast(''Pagamento Instantâneo (PIX)'' as varchar(60)) as NOME from rdb$database ' +
  'select cast(''20'' as varchar(2)) as ID, cast('+''''+ _FormaPixEstatico+''''+' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''17'' as varchar(2)) as ID, cast('+''''+ _FormaPixDinamico+''''+' as varchar(60)) as NOME from rdb$database ' +
  {Mauricio Parizotto 204-07-10 Fim}
  'union ' +
  'select cast(''18'' as varchar(2)) as ID, cast(''Transferência bancária, Carteira Digital'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''19'' as varchar(2)) as ID, cast(''Programa de fidelidade, Cashback, Crédito Virtual'' as varchar(60)) as NOME from rdb$database ' +
  'union ' +
  'select cast(''99'' as varchar(2)) as ID, cast(''Outros'' as varchar(60)) as NOME from rdb$database ' +
  ') q ';
  //'order by NOME';

function TabelaExisteFB(Banco: TIBDatabase; sTabela: String): Boolean;
function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
function TamanhoCampoFB(Banco: TIBDatabase; sTabela: String; sCampo: String): integer;
function TipoCampoFB(Banco: TIBDatabase; sTabela: String; sCampo: String): String;
function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
function CriaIDataSet(IBTRANSACTION: TIBTransaction): TIBDataSet; // Mauricio Parizotto 2023-09-12
{$IFDEF VER150}
function ExecutaComando(comando: String): Boolean;  overload;
{$ENDIF}
function ExecutaComando(comando: String; IBTRANSACTION: TIBTransaction): Boolean; overload;
function ExecutaComandoEscalar(Banco: TIBDatabase; vSQL : string; vNull : string = ''): Variant; overload;
function ExecutaComandoEscalar(Transaction: TIBTransaction; vSQL : string; vNull : string = ''): Variant; overload;// Mauricio Parizotto 2023-09-12
function GeneratorExisteFB(Banco: TIBDatabase; sGenerator: String): Boolean;
function TamanhoCampo(IBTransaction: TIBTransaction; Tabela: String;
  Campo: String): Integer;
function IndiceExiste(Banco: TIBDatabase; sTabela: String;
  sIndice: String): Boolean;
function IncGenerator(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): String;
function GetCampoPKTabela(Banco: TIBDatabase; vTabela : string): String;
function FloatToBD(valor:Double):string;
function DateToBD(data:TDateTime):string;
function CriaConexaoClone(IBDatabase: TIBDatabase) : TIBDatabase; //Mauricio Parizotto 2014-12-23
function ConexoesAtivas(AIBDatabase: TIBDatabase): Integer;

implementation

uses
  {$IFDEF VER150}
  mais,
  {$ENDIF}
  uDialogs;

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

function TamanhoCampoFB(Banco: TIBDatabase; sTabela: String; sCampo: String): integer;
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  Result := 0;
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text := ' SELECT'+
                        '   A.RDB$FIELD_LENGTH TAMANHO'+
                        ' FROM RDB$FIELDS A '+
                        '   Left Join RDB$RELATION_FIELDS B on b.RDB$FIELD_SOURCE = A.RDB$FIELD_NAME '+
                        ' WHERE B.RDB$RELATION_NAME = ' + QuotedStr(sTabela)+
                        '  AND B.RDB$FIELD_NAME = ' + QuotedStr(sCampo);
    IBQUERY.Open;
    Result := IBQUERY.FieldByName('TAMANHO').AsInteger;
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

{Sandro Silva 2024-11-24 inicio}
function TipoCampoFB(Banco: TIBDatabase; sTabela: String; sCampo: String): String;
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  Result := '';
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    {
    IBQUERY.DisableControls;
    IBQUERY.UniDirectional := True;
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select ' +
      'upper(trim(T.RDB$TYPE_NAME)) as TIPO ' +
      ', B.RDB$FIELD_LENGTH as TAMANHO ' +
      ', B.RDB$FIELD_SCALE as ESCALA ' +
      'from RDB$RELATION_FIELDS A ' +
      'join RDB$FIELDS B ' +
      '    on (A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME) ' +
      'join RDB$TYPES T on T.RDB$TYPE = B.RDB$FIELD_TYPE and T.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'' ' +
      'where (upper(A.RDB$RELATION_NAME) = uppet(:TABELA)) ' +
      'and (upper(A.RDB$FIELD_NAME) = upper(:CAMPO))';
    IBQUERY.ParamByName('TABELA').AsString := sTabela;
    IBQUERY.ParamByName('CAMPO').AsString  := sCampo;
    IBQUERY.Open;
    Result := IBQUERY.FieldByName('TIPO').AsString;
    if IBQUERY.FieldByName('TIPO').AsString = 'INT64' then
    begin
      if IBQUERY.FieldByName('ESCALA').AsInteger <> 0 then
        Result := 'NUMERIC';
    end;
    }
    IBQUERY.DisableControls;
    IBQUERY.UniDirectional := True;
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'SELECT ' +
      '  RF.RDB$RELATION_NAME, ' +
      '  RF.RDB$FIELD_NAME FIELD_NAME, ' +
      '  RF.RDB$FIELD_POSITION FIELD_POSITION, ' +
      '  CASE F.RDB$FIELD_TYPE ' +
      '    WHEN 7 THEN ' +
      '      CASE F.RDB$FIELD_SUB_TYPE ' +
      '        WHEN 0 THEN ''SMALLINT'' ' +
      '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ' +
      '        WHEN 2 THEN ''DECIMAL'' ' +
      '      END ' +
      '    WHEN 8 THEN ' +
      '      CASE F.RDB$FIELD_SUB_TYPE ' +
      '        WHEN 0 THEN ''INTEGER'' ' +
      '        WHEN 1 THEN ''NUMERIC(''  || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ' +
      '        WHEN 2 THEN ''DECIMAL'' ' +
      '      END ' +
      '    WHEN 9 THEN ''QUAD'' ' +
      '    WHEN 10 THEN ''FLOAT'' ' +
      '    WHEN 12 THEN ''DATE'' ' +
      '    WHEN 13 THEN ''TIME'' ' +
      '    WHEN 14 THEN ''CHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '')''  ' +
      '    WHEN 16 THEN ' +
      '      CASE F.RDB$FIELD_SUB_TYPE ' +
      '        WHEN 0 THEN ''BIGINT'' ' +
      '        WHEN 1 THEN ''NUMERIC('' || F.RDB$FIELD_PRECISION || '', '' || (-F.RDB$FIELD_SCALE) || '')'' ' +
      '        WHEN 2 THEN ''DECIMAL'' ' +
      '      END ' +
      '    WHEN 27 THEN ''DOUBLE'' ' +
      '    WHEN 35 THEN ''TIMESTAMP'' ' +
      '    WHEN 37 THEN ' +
      '     IIF (COALESCE(f.RDB$COMPUTED_SOURCE, '''') <> '''', ' +
      '      ''COMPUTED BY '' || CAST(f.RDB$COMPUTED_SOURCE AS VARCHAR(250)), ' +
      '      ''VARCHAR('' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '')'') ' +
      '    WHEN 40 THEN ''CSTRING'' || (TRUNC(F.RDB$FIELD_LENGTH / CH.RDB$BYTES_PER_CHARACTER)) || '')'' ' +
      '    WHEN 45 THEN ''BLOB_ID'' ' +
      '    WHEN 261 THEN ''BLOB SUB_TYPE '' || F.RDB$FIELD_SUB_TYPE ' +
      '    ELSE ''RDB$FIELD_TYPE: '' || F.RDB$FIELD_TYPE || ''?'' ' +
      '  END FIELD_TYPE, ' +
      '  IIF(COALESCE(RF.RDB$NULL_FLAG, 0) = 0, NULL, ''NOT NULL'') FIELD_NULL, ' +
      '  CH.RDB$CHARACTER_SET_NAME FIELD_CHARSET, ' +
      '  DCO.RDB$COLLATION_NAME FIELD_COLLATION, ' +
      '  COALESCE(RF.RDB$DEFAULT_SOURCE, F.RDB$DEFAULT_SOURCE) FIELD_DEFAULT, ' +
      '  F.RDB$VALIDATION_SOURCE FIELD_CHECK, ' +
      '  RF.RDB$DESCRIPTION FIELD_DESCRIPTION ' +
      'FROM RDB$RELATION_FIELDS RF ' +
      'JOIN RDB$FIELDS F ON (F.RDB$FIELD_NAME = RF.RDB$FIELD_SOURCE) ' +
      'LEFT OUTER JOIN RDB$CHARACTER_SETS CH ON (CH.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID) ' +
      'LEFT OUTER JOIN RDB$COLLATIONS DCO ON ((DCO.RDB$COLLATION_ID = F.RDB$COLLATION_ID) AND (DCO.RDB$CHARACTER_SET_ID = F.RDB$CHARACTER_SET_ID)) ' +
      'WHERE (COALESCE(RF.RDB$SYSTEM_FLAG, 0) = 0) ' +
      'and (upper(RF.RDB$RELATION_NAME) = upper(:TABELA)) ' +
      'and (upper(RF.RDB$FIELD_NAME ) = upper(:CAMPO)) ' +
      'ORDER BY RF.RDB$FIELD_POSITION';
    IBQUERY.ParamByName('TABELA').AsString := sTabela;
    IBQUERY.ParamByName('CAMPO').AsString  := sCampo;
    IBQUERY.Open;
    Result := AnsiUpperCase(IBQUERY.FieldByName('FIELD_TYPE').AsString);
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;

end;
{Sandro Silva 2024-11-24 fim}

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
      //ShowMessage(E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message,msgErro);
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

function CriaIDataSet(IBTRANSACTION: TIBTransaction): TIBDataSet;
//Mauricio Parizotto 2023-09-12
begin
  try
    Result := TIBDataSet.Create(nil);
    Result.Database    := IBTRANSACTION.DefaultDataBase;
    Result.Transaction := IBTRANSACTION;
    Result.BufferChunks := 100; // Evitar Erro de out of memory
  except
    on E: Exception do
    begin
      //ShowMessage(E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message,msgErro);
      Result := nil;
    end
  end;
end;

{$IFDEF VER150}
function ExecutaComando(comando:string):Boolean;  overload;
begin
  Result := False;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Text := comando;
    Form1.ibDataset200.ExecSQL;
    Form1.ibDataset200.Close;

    Result := True;
  except
  end;
end;
{$ENDIF}


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
  {Sandro Silva 2024-11-19 inicio
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
  }
  TamanhoCampoFB(IBTransaction.DefaultDatabase, Tabela, campo);
  {Sandro Silva 2024-11-19 fim}
end;

function IndiceExiste(Banco: TIBDatabase; sTabela: String;
  sIndice: String): Boolean;
{Sandro Silva 2012-02-23 inicio
Pesquisa na base se o índice existe na tabela, retornando True/False}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);

  IBQUERY.Close;
  IBQUERY.SQL.Text :=
    'select I.RDB$INDEX_NAME as NOMEINDICE ' +
    'from RDB$INDICES I ' +
    'where I.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
    ' and I.RDB$INDEX_NAME = ' + QuotedStr(sIndice);
  IBQUERY.Open;

  Result := (Trim(IBQUERY.FieldByName('NOMEINDICE').AsString) <> '');
end;

function IncGenerator(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): String;
var
  IBTTEMP: TIBTransaction;
  IBQTEMP: TIBQuery;
begin
  IBTTEMP := CriaIBTransaction(IBDataBase);
  IBQTEMP := CriaIBQuery(IBTTEMP);
  Result := '0';
  try
    IBQTEMP.Close;
    IBQTEMP.SQL.Text := 'select gen_id(' + sGenerator + ', '+ IntToStr(iQtd) +') as NUMERO from rdb$database';
    IBQTEMP.Open;
    Result := IBQTEMP.FieldByName('NUMERO').AsString;
    IBQTEMP.Transaction.Rollback;
  except
  end;
  FreeAndNil(IBQTEMP);
  FreeAndNil(IBTTEMP);
end;

function ExecutaComando(comando:string; IBTRANSACTION: TIBTransaction):Boolean;  overload;
var
  IBQUERY: TIBQuery;
begin
  Result := False;

  IBQUERY := CriaIBQuery(IBTRANSACTION);

  try
    IBQUERY.DisableControls;
    IBQUERY.Close;
    IBQUERY.SQL.Text := comando;
    IBQUERY.ExecSQL;

    Result := True;
  except
  end;

  FreeAndNil(IBQUERY);
end;


function ExecutaComandoEscalar(Banco: TIBDatabase; vSQL : string; vNull : string = ''): Variant; overload;
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
    //Result := IBQUERY.Fields[0].AsVariant; Mauricio Parizotto 2023-12-12
    if IBQUERY.Fields[0].IsNull then
      Result := vNull
    else
      Result := IBQUERY.Fields[0].AsVariant;
  finally
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function ExecutaComandoEscalar(Transaction: TIBTransaction; vSQL : string; vNull : string = ''): Variant; overload;
var
  IBQUERY: TIBQuery;
begin
  IBQUERY := CriaIBQuery(Transaction);

  try
    IBQUERY.Close;
    IBQUERY.SQL.Text := vSQL;
    IBQUERY.Open;
    //Result := IBQUERY.Fields[0].AsVariant; Mauricio Parizotto 2023-12-12
    if IBQUERY.Fields[0].IsNull then
      Result := vNull
    else
      Result := IBQUERY.Fields[0].AsVariant;
  finally
    FreeAndNil(IBQUERY);
  end;
end;


function GetCampoPKTabela(Banco: TIBDatabase; vTabela : string): String;
var
  SQL : string;
begin
  Result := '';

  try
    SQL := ' SELECT First 1 RDB$FIELD_NAME'+
           ' FROM'+
           '   RDB$RELATION_CONSTRAINTS C,'+
           '   RDB$INDEX_SEGMENTS S'+
           ' WHERE C.RDB$RELATION_NAME = '+QuotedStr(vTabela)+
           '   AND C.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' '+
           '   AND S.RDB$INDEX_NAME = C.RDB$INDEX_NAME';

    Result := Trim(ExecutaComandoEscalar(Banco, SQL));
  except
  end;
end;

function FloatToBD(valor:Double):string;
begin
  Result := StringReplace(FloatToStr(valor),',','.',[rfReplaceAll]);
end;

function DateToBD(data:TDateTime):string;
begin
  Result := FormatDateTime('YYYY-MM-DD',data);
end;

function CriaConexaoClone(IBDatabase: TIBDatabase) : TIBDatabase;
begin
  Result := TIBDatabase.Create(nil);
  Result.Params       := IBDatabase.Params;
  Result.DatabaseName := IBDatabase.DatabaseName;
  Result.ServerType   := IBDatabase.ServerType;
  Result.LoginPrompt  := False;
end;


function ConexoesAtivas(AIBDatabase: TIBDatabase): Integer;
begin
  Result := ExecutaComandoEscalar(
    AIBDatabase,
    'select count(*) from MON$ATTACHMENTS'
  );
end;

end.
