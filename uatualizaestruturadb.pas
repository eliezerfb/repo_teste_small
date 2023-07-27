unit uatualizaestruturadb;

(*
// Campos que devem ser alterados caso necessário aumentar para atender númeração da NFC-e
// Conversar com Ronei para ajustar no Small (relatórios, importações)
// Revisar se existem outros campos
// Revisar código fonte onde são utilizados os campos aumentados
// Revisar registros do paf se precisa ajustes
// Aumentar tamanho dos campos declarados nos IBDataSet

ALTER TABLE ALTERACA ALTER PEDIDO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE ALTERACA ALTER COO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE ALTERACA ALTER CCF TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE DEMAIS ALTER COO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE DEMAIS ALTER CCF TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE NFCE ALTER NUMERONF TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE ORCAMENT ALTER COO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE PAGAMENT ALTER PEDIDO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE PAGAMENT ALTER CCF TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE PAGAMENT ALTER COO TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE REDUCOES ALTER CUPOMI TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE REDUCOES ALTER CUPOMF TYPE VARCHAR(9) CHARACTER SET NONE;
ALTER TABLE VFPE ALTER PEDIDO TYPE VARCHAR(9) CHARACTER SET NONE;
*)

interface

uses
  Classes, Dialogs, SysUtils, Forms, StrUtils
  , IBDatabase, IBQuery, IBCustomDataSet
  , smallfunc, ufuncoesfrente;

type
  TAtualizaBase = class(TComponent)
  private
    FIBDATABASE: TIBDatabase;
    FModeloECF_Reserva: String;
    FIBDataSet150: TIBDataSet;
    procedure SetIBDATABASE(const Value: TIBDatabase);
    procedure AtualizaBase(IBDATABASE: TIBDatabase);
    procedure SetModeloECF_Reserva(const Value: String);
    procedure SetIBDataSet150(const Value: TIBDataSet);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Atualizar;
    property IBDATABASE: TIBDatabase read FIBDATABASE write SetIBDATABASE;
    property sModeloECF_Reserva: String read FModeloECF_Reserva write SetModeloECF_Reserva;
    property IBDataSet150: TIBDataSet read FIBDataSet150 write SetIBDataSet150;
  end;

implementation

{ TAtualizaBase }

procedure TAtualizaBase.AtualizaBase(IBDATABASE: TIBDatabase);
//Sandro Silva 2015-04-23 Ronei Orientou a atualizar estrutura da base para o frente por aqui e não no Small Commerce
var
  IBQBASE: TIBQuery;
  IBQuery1: TIBQuery;
begin
  IBQBASE := CriaIBQuery(IBDATABASE.DefaultTransaction);
  IBQuery1 := CriaIBQuery(IBDATABASE.DefaultTransaction);  
  try
    {Sandro Silva 2018-10-09 inicio}
    if CampoExisteFB(IBDATABASE, 'ESTOQUE', 'TAGS_') = False then
    begin
      ShowMessage('Essa aplicação é incompatível com o banco de dados' + #13 + 'Atualize o seu Small');
      FecharAplicacao(ExtractFileName(Application.ExeName));
      FecharAplicacao(ExtractFileName(Application.ExeName));
      Abort;
    end;
    {Sandro Silva 2018-10-09 fim}

    {Sandro Silva 2023-07-17 inicio
    try
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'update RDB$RELATION_FIELDS set ' +
        'RDB$NULL_FLAG = 1 ' +
        'where (RDB$FIELD_NAME = ''REGISTRO'') and ' +
        '(RDB$RELATION_NAME = ''NFCE'')';
      IBQBASE.ExecSQL;
      IBQBASE.Transaction.Commit;
    except

    end;

    if IndiceExiste(IBDATABASE, 'NFCE', 'PK_NFCE') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE NFCE ' +
          'ADD CONSTRAINT PK_NFCE '+
          'PRIMARY KEY (REGISTRO)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;
    end;

    if CampoExisteFB(IBDATABASE, 'NFCE', 'CAIXA') = False then
    begin
      try
        // Criando o campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE NFCE ADD CAIXA VARCHAR(3)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        try
          // Atualizando o campo criado
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'update NFCE set ' +
            'CAIXA = (select first 1 A.CAIXA from ALTERACA A where A.DATA = NFCE.DATA and A.PEDIDO = NFCE.NUMERONF) ' +
            'where coalesce(CAIXA, '''') = '''' ';
          IBQBASE.ExecSQL;
        except

        end;

        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);

      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'NFCE', 'MODELO') = False then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE NFCE ADD MODELO VARCHAR(2)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        try
          // Atualizando o campo criado
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'update NFCE set ' +
            'MODELO = case when (NFEXML containing ''<infCFe'') and (NFEXML containing ''Id="CFe'') then ''59'' else ''65'' end ' +
            'where coalesce(MODELO, '''') = '''' ';
          IBQBASE.ExecSQL;
        except

        end;

        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if TabelaExisteFB(IBDATABASE, 'ECFS') = False then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'create table ECFS (' +
          'SERIE varchar(21), ' +
          'ENCRYPTHASH varchar(56))';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if TabelaExisteFB(IBDATABASE, 'BLOCOX') = False then
    begin
      try

        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_BLOCOX';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_HASH_BLOCOX';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        //Criando campos
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE TABLE BLOCOX (' +
          'REGISTRO VARCHAR(10) NOT NULL, ' +
          'TIPO VARCHAR(8), ' +
          'DATAHORA TIMESTAMP, ' +
          'RECIBO VARCHAR(100), ' +
          'XMLENVIO BLOB SUB_TYPE 1 SEGMENT SIZE 80)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX ADD CONSTRAINT PK_BLOCOX PRIMARY KEY (REGISTRO)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'BLOCOX', 'SERIE') = False then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX ADD SERIE VARCHAR(20)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if (CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAESTOQUE') = False) and
      (CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAREFERENCIA') = False) then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX ADD DATAESTOQUE DATE';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAESTOQUE') then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX ALTER DATAESTOQUE TO DATAREFERENCIA';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        // Orientação Auditores Bruno Nogueira, Sérgio Pinetti: Deve-se gerar somente arquivos no layout final, qualquer outro layout não será aceito pelo Bloco X.
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'delete from BLOCOX';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

      except
        IBQBASE.Transaction.Rollback;
      end;
    end
    else
    begin
      if CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAREFERENCIA') = False then
      begin
        try
          //Criando campo
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE BLOCOX ADD DATAREFERENCIA DATE';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
          //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);

          // Orientação Auditores Bruno Nogueira, Sérgio Pinetti: Deve-se gerar somente arquivos no layout final, qualquer outro layout não será aceito pelo Bloco X.
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'delete from BLOCOX';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;

        except
          IBQBASE.Transaction.Rollback;
        end;
      end;
    end;

    if (CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAREFERENCIA'))
      and (CampoExisteFB(IBDATABASE, 'BLOCOX', 'DATAESTOQUE')) then
    begin

      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX DROP DATAESTOQUE';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);

      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    if CampoExisteFB(IBDATABASE, 'BLOCOX', 'XMLRESPOSTA') = False then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE BLOCOX ADD XMLRESPOSTA  BLOB SUB_TYPE 1 SEGMENT SIZE 80';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    try
      //Criando campo
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'delete from BLOCOX ' +
        ' where RECIBO = ' + QuotedStr('Layout do arquivo conforme a ER02.03 é incompatível com a ER02.05');
      IBQBASE.ExecSQL;
      IBQBASE.Transaction.Commit;
    except
      IBQBASE.Transaction.Rollback;
    end;

    try
      //Criando campo
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'delete from BLOCOX ' +
        'where XMLENVIO containing ''<NomeComercial>'' ' +
        ' and XMLENVIO containing ''<Versao>'' ' +
        ' and XMLENVIO containing ''<CnpjDesenvolvedor>'' ' +
        ' and XMLENVIO containing ''<NomeEmpresarialDesenvolvedor>'' ';
      IBQBASE.ExecSQL;
      IBQBASE.Transaction.Commit;
    except
      IBQBASE.Transaction.Rollback;
    end;

    try
      //Criando campo
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'delete from BLOCOX ' +
        ' where XMLENVIO containing ' + QuotedStr('<>');
      IBQBASE.ExecSQL;
      IBQBASE.Transaction.Commit;
    except
      IBQBASE.Transaction.Rollback;
    end;

    if IndiceExiste(IBDATABASE, 'BLOCOX', 'IDX_BLOCOX_DTREFER_TIPO_SERIE') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_BLOCOX_DTREFER_TIPO_SERIE ON BLOCOX (DATAREFERENCIA,TIPO,SERIE)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    if IndiceExiste(IBDATABASE, 'BLOCOX', 'IDX_BLOCOX_RECIBO') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_BLOCOX_RECIBO ON BLOCOX (RECIBO)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;


    {
    if IndiceExiste(IBDATABASE, 'BLOCOX', 'IDX_BLOCOX_DATAHORA') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_BLOCOX_DATAHORA ON BLOCOX (DATAHORA)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    if CampoExisteFB(IBDATABASE, 'ALTERACA', 'CSOSN') = False then
    begin
      try
        //Criando campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE ALTERACA ADD CSOSN VARCHAR(3)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
        //SmallMsg('Atualizado' + #13 + IBDATABASE.DatabaseName);
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'PAGAMENT', 'IDPAGAMENTO') then
    begin
      try
        // Criando o campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE PAGAMENT DROP IDPAGAMENTO';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'PAGAMENT', 'IDRESPOSTAFISCAL') then
    begin
      try
        // Criando o campo
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE PAGAMENT DROP IDRESPOSTAFISCAL';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

      try
        // Elimina os dados de transações diferentes a cartão usadas com integrador fiscal
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'delete from VFPE ' +
          'where substring(FORMA from 1 for 2) <> ''03'' ';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    if TabelaExisteFB(IBDATABASE, 'VFPE') = False then
    begin
      // Tabela para usar com integrador fiscal do Ceará
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE TABLE VFPE (' +
          'REGISTRO VARCHAR(10) NOT NULL, ' +
          'DATA DATE, ' +
          'PEDIDO VARCHAR(6), ' +
          'CAIXA VARCHAR(3), ' +
          'FORMA VARCHAR(30), ' +
          'VALOR NUMERIC(18,2), ' +
          'IDPAGAMENTO INTEGER, ' +
          'IDRESPOSTAFISCAL INTEGER, ' +
          'TRANSMITIDO VARCHAR(1))';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

      try
        // Chave primária
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE VFPE ADD CONSTRAINT PK_VFPE PRIMARY KEY (REGISTRO)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

      try
        // Generator
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_VFPE';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    if TabelaExisteFB(IBDATABASE, 'VFPE') then
    begin
      if CampoExisteFB(IBDATABASE, 'VFPE', 'TRANSACAO') = False then
      begin

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE VFPE ' +
            'ADD TRANSACAO VARCHAR(20) ';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;
      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'NOMEREDE') = False then
      begin

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE VFPE ' +
            'ADD NOMEREDE VARCHAR(30)';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;

      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'IDPAGAMENTO') then
      begin

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'select first 1 IDPAGAMENTO ' +
            'from VFPE ' +
            'where REGISTRO is null';
          IBQBASE.Open;
          if IBQBASE.FieldByName('IDPAGAMENTO').Size < 11 then
          begin

            IBQBASE.Close;
            IBQBASE.SQL.Text :=
              'ALTER TABLE VFPE ' +
              'ALTER IDPAGAMENTO TYPE VARCHAR(11)';
            IBQBASE.ExecSQL;
            IBQBASE.Transaction.Commit;

          end;
        except
          IBQBASE.Transaction.Rollback;
        end;

      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'IDRESPOSTAFISCAL') then
      begin

        try

          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'select first 1 IDRESPOSTAFISCAL ' +
            'from VFPE ' +
            'where REGISTRO is null';
          IBQBASE.Open;
          if IBQBASE.FieldByName('IDRESPOSTAFISCAL').Size < 11 then
          begin

            IBQBASE.Close;
            IBQBASE.SQL.Text :=
              'ALTER TABLE VFPE ' +
              'ALTER IDRESPOSTAFISCAL TYPE VARCHAR(11)';
            IBQBASE.ExecSQL;
            IBQBASE.Transaction.Commit;

          end;
        except
          IBQBASE.Transaction.Rollback;
        end;

      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'AUTORIZACAO') = False then
      begin

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE VFPE ' +
            'ADD AUTORIZACAO VARCHAR(20)';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;
      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'BANDEIRA') = False then
      begin

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE VFPE ' +
            'ADD BANDEIRA VARCHAR(30)';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;
      end;

      if CampoExisteFB(IBDATABASE, 'VFPE', 'IDPAGAMENTO') then
      begin // Aumentar tamanho campo
        try
          if TamanhoCampo(IBQBASE.Transaction, 'VFPE', 'IDPAGAMENTO') < 15 then
          begin
            IBQBASE.Close;
            IBQBASE.SQL.Text :=
              'ALTER TABLE VFPE ' +
              'ALTER IDPAGAMENTO TYPE VARCHAR(15) CHARACTER SET NONE';
            IBQBASE.ExecSQL;
            IBQBASE.Transaction.Commit;
          end;
        except
          if IBQBASE.Transaction.Active then
            IBQBASE.Transaction.Rollback;
        end;
      end;
      if CampoExisteFB(IBDATABASE, 'VFPE', 'IDRESPOSTAFISCAL') then
      begin // Aumentar tamanho campo
        try
          if TamanhoCampo(IBQBASE.Transaction, 'VFPE', 'IDRESPOSTAFISCAL') < 15 then
          begin
            IBQBASE.Close;
            IBQBASE.SQL.Text :=
              'ALTER TABLE VFPE ' +
              'ALTER IDRESPOSTAFISCAL TYPE VARCHAR(15) CHARACTER SET NONE';
            IBQBASE.ExecSQL;
            IBQBASE.Transaction.Commit;
          end;
        except
          if IBQBASE.Transaction.Active then
            IBQBASE.Transaction.Rollback;
        end;
      end;

    end;

    if CampoExisteFB(IBDATABASE, 'DEMAIS', 'CCF') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE DEMAIS ' +
          'ADD CCF VARCHAR(6)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;

    end;

    //Índices para otimizar banco
    if IndiceExiste(IBDATABASE, 'DEMAIS', 'IDX_DEMAIS_DATA') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_DEMAIS_DATA ON DEMAIS (DATA)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;
    end;

    if IndiceExiste(IBDATABASE, 'DEMAIS', 'IDX_DEMAIS_ECFCOO') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_DEMAIS_ECFCOO ON DEMAIS (ECF,COO)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;
    end;

    if CampoExisteFB(IBDATABASE, 'ALTERACA', 'SEQUENCIALCONTACLIENTEOS') = False then
    begin

      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE ALTERACA ADD SEQUENCIALCONTACLIENTEOS VARCHAR(10)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

      try
        // Generator
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_SEQUENCIALCONTACLIENTEOS';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end
    else
    begin
      try
        IBQuery1.Close;
        IBQuery1.SQL.Text :=
          'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO = ''MESA'' or TIPO = ''DEKOL'') group by PEDIDO ';
        IBQuery1.Open;

        while IBQuery1.Eof = False do
        begin
          if IBQuery1.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
          begin
            try
              IBQBASE.Close;
              IBQBASE.SQL.Text :=
                'update ALTERACA set ' +
                'SEQUENCIALCONTACLIENTEOS = ' + QuotedStr(Right(DupeString('0', 10) + IncGenerator(IBDatabase, 'G_SEQUENCIALCONTACLIENTEOS', 1), 10)) +
                ' where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
                ' and PEDIDO = ' + QuotedStr(IBQuery1.FieldByName('PEDIDO').AsString);
              IBQBASE.ExecSQL;
              //IBQBASE.Transaction.Commit;
            except
              //IBQBASE.Transaction.Rollback;
            end;
          end;
          IBQuery1.Next;
        end;

      except
      end;

    end;

    if (FModeloECF_Reserva = '59') or (FModeloECF_Reserva = '65') then
    begin
      if CampoExisteFB(IBDATABASE, 'CONTAOS', 'IDENTIFICADOR1') then
      begin // Aumentar o tamanho dos campos identificadores para uso na NFC-e e SAT
        try
          // Não usei a função TamanhoCampo() porque CONTAOS não tem campo REGISTRO
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'select first 1 * ' +
            'from CONTAOS ';
          IBQBASE.Open;

          if IBQBASE.FieldByName('IDENTIFICADOR1').Size = 15 then
          begin
            IBQBASE.Close;
            IBQBASE.SQL.Text :=
              'ALTER TABLE CONTAOS ' +
              'ALTER IDENTIFICADOR1 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
              'ALTER IDENTIFICADOR2 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
              'ALTER IDENTIFICADOR3 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
              'ALTER IDENTIFICADOR4 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
              'ALTER IDENTIFICADOR5 TYPE VARCHAR(40) CHARACTER SET NONE ';
            IBQBASE.ExecSQL;
            IBQBASE.Transaction.Commit;
          end;
        except
          if IBQBASE.Transaction.Active then
            IBQBASE.Transaction.Rollback;
        end;
      end;
    end;

    // Para poder controlar sangria e suprimento quando atende após meia-noite
    if CampoExisteFB(IBDATABASE, 'PAGAMENT', 'HORA') = False then
    begin

      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE PAGAMENT ADD HORA VARCHAR(8)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;
    end;
    }

    {Sandro Silva 2018-12-05 inicio}
    {Sandro Silva 2023-07-27 inicio 
    // Ficha 4302
    if CampoExisteFB(IBDATABASE, 'NFCE', 'TOTAL') = False then
    begin

      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE NFCE ADD TOTAL NUMERIC(18,2)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

      try
        FIBDATASET150.Close;
        FIBDATASET150.SelectSQL.Text :=
          'select * ' +
          'from NFCE ' +
          'where STATUS containing ''AUTORIZA'' or STATUS containing ''Emitido com sucesso'' ';
        FIBDATASET150.Open;

        while FIBDATASET150.Eof = False do
        begin

          FIBDATASET150.Edit;
          if xmlNodeValue(FIBDATASET150.FieldByName('NFEXML').AsString, '//mod') = '59' then
            FIBDATASET150.FieldByName('TOTAL').AsFloat := xmlNodeValueToFloat(FIBDATASET150.FieldByName('NFEXML').AsString, '//vCFe');
          if xmlNodeValue(FIBDATASET150.FieldByName('NFEXML').AsString, '//mod') = '65' then
            FIBDATASET150.FieldByName('TOTAL').AsFloat := xmlNodeValueToFloat(FIBDATASET150.FieldByName('NFEXML').AsString, '//vNF');
          FIBDATASET150.Post;

          FIBDATASET150.Next;
        end;

        FIBDATASET150.Transaction.Commit;
      except

      end;
    end;
    }
    {Sandro Silva 2018-12-05 fim}

    {Sandro Silva 2023-07-17 inicio
    if TabelaExisteFB(IBDATABASE, 'PENDENCIA') = False then
    begin
      // Tabela para controlar as alterações que o frente não consegue realizar na tabela ALTERACA por DEAD LOCK com transações do Small
      // Identificado quando é realizado cancelamento de venda
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE TABLE PENDENCIA ( ' +
          'CAIXA VARCHAR(3), ' +
          'PEDIDO VARCHAR(9), ' +
          'ITEM VARCHAR(6), ' +
          'TIPO VARCHAR(6))';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;
    end;

    //indices otimizar consultas relacionada ao bloco x e abertura cupom
    if IndiceExiste(IBDATABASE, 'REDUCOES', 'IDX_REDUCOES_SERIE') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_REDUCOES_SERIE ON REDUCOES (SERIE)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if IndiceExiste(IBDATABASE, 'BLOCOX', 'IDX_BLOCOX_TIPO_RECIBO_SERIE') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_BLOCOX_TIPO_RECIBO_SERIE ON BLOCOX (TIPO, RECIBO, SERIE)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if CampoExisteFB(IBDATABASE, 'NFCE', 'NFEIDSUBSTITUTO') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE NFCE ADD NFEIDSUBSTITUTO VARCHAR(44)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

    end;

    if IndiceExiste(IBDATABASE, 'REDUCOES', 'IDX_REDUCOES_CUPOMF') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_REDUCOES_CUPOMF ON REDUCOES (CUPOMF)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    if IndiceExiste(IBDATABASE, 'REDUCOES', 'IDX_REDUCOES_PDV_SMALL') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE INDEX IDX_REDUCOES_PDV_SMALL ON REDUCOES (PDV, SMALL)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except
        IBQBASE.Transaction.Rollback;
      end;
    end;

    // Generator para vendas do MEI no frente
    try
      // Generator
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'select RDB$GENERATOR_NAME as GENERATOR from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_NUMEROCUPOMMEI');
      IBQBASE.Open;

      if IBQBASE.FieldByName('GENERATOR').AsString = '' then
      begin
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_NUMEROCUPOMMEI';
        IBQBASE.ExecSQL;
      end;
      IBQBASE.Transaction.Commit;

    except
      IBQBASE.Transaction.Rollback;
    end;

    if TabelaExisteFB(IBDATABASE, 'NFCE') then
    begin
      if CampoExisteFB(IBDATABASE, 'NFCE', 'ENCRYPTHASH') = False then
      begin

        // Controle de evidência do PAF-NFC-e J1 e J2
        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE NFCE ADD ENCRYPTHASH VARCHAR(56)';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;

        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'CREATE SEQUENCE G_HASH_NFCE';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;

      end;

    end;

    // Generator para série da NFC-e
    try
      // Generator
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'select RDB$GENERATOR_NAME as GENERATOR from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_SERIENFCE');
      IBQBASE.Open;

      if IBQBASE.FieldByName('GENERATOR').AsString = '' then
      begin
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE SEQUENCE G_SERIENFCE';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;

        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER SEQUENCE G_SERIENFCE RESTART WITH 1';
        IBQBASE.ExecSQL;
      end;

      IBQBASE.Transaction.Commit;
    except
      IBQBASE.Transaction.Rollback;
    end;

    if TabelaExisteFB(IBDATABASE, 'ALTERACA') then
    begin
      if CampoExisteFB(IBDATABASE, 'ALTERACA', 'MARKETPLACE') = False then
      begin

        // Controle de evidência do PAF-NFC-e J1 e J2
        try
          IBQBASE.Close;
          IBQBASE.SQL.Text :=
            'ALTER TABLE ALTERACA ADD MARKETPLACE VARCHAR(60)';
          IBQBASE.ExecSQL;
          IBQBASE.Transaction.Commit;
        except
          IBQBASE.Transaction.Rollback;
        end;
      end;
    end;
    }

    {Sandro Silva 2019-08-20 inicio
    if CampoExisteFB(IBDATABASE, 'EMITENTE', 'CNAE') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE EMITENTE ADD CNAE VARCHAR(7)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

    end;

    if CampoExisteFB(IBDATABASE, 'EMITENTE', 'IM') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE EMITENTE ADD IM VARCHAR(16)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

    end;

    if CampoExisteFB(IBDATABASE, 'EMITENTE', 'ENCRYPTHASH') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE EMITENTE ADD ENCRYPTHASH VARCHAR(56)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

    end;

    if CampoExisteFB(IBDATABASE, 'EMITENTE', 'LICENCA') = False then
    begin
      try
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'ALTER TABLE EMITENTE ADD LICENCA VARCHAR(56)';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      except

      end;

    end;
    {Sandro Silva 2019-08-20 fim}

  finally
    FreeAndNil(IBQBASE);
    FreeAndNil(IBQuery1);
  end;


end;

procedure TAtualizaBase.Atualizar;
begin
  AtualizaBase(FIBDATABASE);
end;

constructor TAtualizaBase.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TAtualizaBase.Destroy;
begin
  //
  inherited;
end;

procedure TAtualizaBase.SetIBDATABASE(const Value: TIBDatabase);
begin
  FIBDATABASE := Value;
end;

procedure TAtualizaBase.SetIBDataSet150(const Value: TIBDataSet);
begin
  FIBDataSet150 := Value;
end;

procedure TAtualizaBase.SetModeloECF_Reserva(const Value: String);
begin
  FModeloECF_Reserva := Value;
end;

end.

