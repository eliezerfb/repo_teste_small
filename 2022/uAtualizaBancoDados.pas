unit uAtualizaBancoDados;

//Mauricio Parizotto 2023-03-28

interface

uses
  Mais
  , SysUtils
  , StrUtils
  , Classes
  , Forms
  , Controls
  , Windows
  , Dialogs
  , DB
  , IBQuery
  , SmallFunc
  , unit7
  ;

  procedure DropViewProcedure;  
  procedure AtualizaBancoDeDados(sBuild : string);
  function ExecutaComando(comando:string):Boolean;

implementation

uses Unit22, Unit13, uFuncoesBancoDados, uFuncoesRetaguarda;

procedure DropViewProcedure;
begin
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$relation_name as OBJETO ' +
      'from rdb$relations ' +
      'where rdb$view_blr is not null ' +
      'and (rdb$system_flag is null or rdb$system_flag = 0)';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop view ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$procedure_name as OBJETO ' +
      'from rdb$procedures ' +
      'where rdb$system_flag is null or rdb$system_flag = 0';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop procedure ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
  try
    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Text :=
      'select rdb$trigger_name  as OBJETO ' +
      'from rdb$triggers ' +
      'where (rdb$system_flag = 0 or rdb$system_flag is null)';
    Form1.ibQuery1.Open;
    if Form1.ibQuery1.FieldByName('OBJETO').AsString <> '' then
    begin
      Application.ProcessMessages;
      ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)');
    end;
    while Form1.ibQuery1.Eof = False do
    begin
      Form1.ibQuery2.Close;
      Form1.ibQuery2.SQL.Text := 'drop trigger ' + Form1.ibQuery1.FieldByName('OBJETO').AsString;
      Form1.ibQuery2.ExecSQL;
      Form1.ibQuery1.Next;
    end;
  except
  end;
end;

procedure AtualizaBancoDeDados(sBuild : string);
var
  II : integer;
  QryAuxiliar: TIBQuery;
begin
  if sBuild = BUILD_DO_BANCO then
    Exit;

  Form1.ibDataset200.Close;
  Form1.ibDataset200.SelectSql.Clear;
  Form1.ibDataset200.SelectSql.Add('select * from MON$ATTACHMENTS');
  Form1.ibDataset200.Open;
  Form1.ibDataset200.Last;

  if not (form1.ibDataSet200.RecordCount = 1) then
  begin
    ShowMessage('Não foi possível atualizar o banco de dados.'+Chr(10)+Chr(10)+
                'Ativos: '+ IntToStr( form1.ibDataSet200.RecordCount)+Chr(10)+Chr(10)+
                ' 1 - Feche todos os programas que usam o SMALL.FDB em todos os terminais'+Chr(10)+
                ' 2 - Execute o Small Commerce novamente');

    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );  Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    Exit;
  end;

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados...');

  DropViewProcedure;

  // MArketplace
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'MARKETPLACE') = False then
    ExecutaComando('alter table VENDAS add MARKETPLACE varchar(60)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'MARKETPLACE') = False then
    ExecutaComando('alter table ESTOQUE add MARKETPLACE VARCHAR(1)');

  // Alterando o tamanho da RAZAO SOCIAL
  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'AUDIT0RIA', 'USUARIO') < 60 then
    ExecutaComando('alter table AUDIT0RIA alter USUARIO type varchar(60)');

  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'OS', 'TECNICO') < 60 then
    ExecutaComando('alter table OS alter TECNICO type varchar(60)');

  ExecutaComando('alter table ITENS003 alter TECNICO type varchar(60)');

  ExecutaComando('alter table CLIFOR alter NOME type varchar(60)');

  ExecutaComando('alter table VENDAS alter CLIENTE type varchar(60)');

  ExecutaComando('alter table COMPRAS alter FORNECEDOR type varchar(60)');

  ExecutaComando('alter table VENDAS alter TRANSPORTA type varchar(60)');

  ExecutaComando('alter table COMPRAS alter TRANSPORTA type varchar(60)');

  ExecutaComando('alter table ITENS002 alter FORNECEDOR type varchar(60)');

  ExecutaComando('alter table OS alter CLIENTE type varchar(60)');

  ExecutaComando('alter table ESTOQUE alter FORNECEDOR type varchar(60)');

  ExecutaComando('alter table RECEBER alter NOME type varchar(60)');

  ExecutaComando('alter table PAGAR alter NOME type varchar(60)');

  ExecutaComando('alter table VENDEDOR alter NOME type varchar(60)');

  ExecutaComando('alter table TRANSPOR alter NOME type varchar(60)');

  ExecutaComando('alter table CONVENIO alter RAZAO type varchar(60)');

  ExecutaComando('alter table ALTERACA alter CLIFOR type varchar(60)');

  ExecutaComando('alter table ORCAMENT alter CLIFOR type varchar(60)');

  ExecutaComando('alter table CODEBAR alter FORNECEDOR type varchar(60)');

  ExecutaComando('alter table PAGAMENT alter CLIFOR type varchar(60)');

  ExecutaComando('alter table EMITENTE alter NOME type varchar(60)');

  ExecutaComando('alter table COMPRAS alter VENDEDOR type varchar(60)');

  ExecutaComando('alter table VENDAS alter VENDEDOR type varchar(60)');

  ExecutaComando('alter table PAGAMENT alter VENDEDOR type varchar(60)');

  ExecutaComando('alter table ALTERACA alter VENDEDOR type varchar(60)');

  ExecutaComando('alter table ORCAMENT alter VENDEDOR type varchar(60)');

  ExecutaComando('commit');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CODEBAR') = False then
    ExecutaComando('create table CODEBAR (REGISTRO VARCHAR(10), CODIGO VARCHAR(5),EAN VARCHAR(15), FORNECEDOR VARCHAR(60))');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'INUTILIZACAO') = False then
  begin
    ExecutaComando('create table INUTILIZACAO (REGISTRO VARCHAR(10) NOT NULL, MODELO VARCHAR(2), ANO INTEGER, SERIE SMALLINT, NINI INTEGER, NFIN INTEGER, NPROT VARCHAR(15), XML BLOB SUB_TYPE 1 SEGMENT SIZE 80, DATA Date)');
    ExecutaComando('ALTER TABLE INUTILIZACAO ADD CONSTRAINT PK_INUTILIZACAO PRIMARY KEY (REGISTRO)');
    ExecutaComando('CREATE SEQUENCE G_INUTILIZACAO');
  end;

  // ESTOQUE TAG para incluir qualquer campo
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'TAGS_') = False then
    ExecutaComando('alter table ESTOQUE add TAGS_ blob sub_type 1');
  Form7.ibDataSet4.Tag := IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO; // Sandro Silva 2022-09-12Form7.ibDataSet4.Tag := 999;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'QTD_PRO1') = False then
  begin
    ExecutaComando('alter table ESTOQUE add QTD_PRO1 DOUBLE PRECISION');
    ExecutaComando('alter table ESTOQUE add QTD_PRO2 DOUBLE PRECISION');
    ExecutaComando('alter table ESTOQUE add DESCONT1 DOUBLE PRECISION');
    ExecutaComando('alter table ESTOQUE add DESCONT2 DOUBLE PRECISION');
  end;

  // ESTOQUE CFOP para venda ao consumidor
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CFOP') = False then
    ExecutaComando('alter table ESTOQUE add CFOP VARCHAR(4)');

  // Fator de conversão
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'MEDIDAE') = False then
  begin
    ExecutaComando('alter table ESTOQUE add MEDIDAE VARCHAR(3)');
    ExecutaComando('alter table ESTOQUE add FATORC NUMERIC(18,2)');// Sandro Silva 2023-06-26 ExecutaComando('alter table ESTOQUE add FATORC NUMERIC(18,4)');
  end;

  // ESTOQUE FCI
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'VALOR_PARCELA_IMPORTADA_EXTERIO') = False then
  begin
    ExecutaComando('alter table ESTOQUE add VALOR_PARCELA_IMPORTADA_EXTERIO NUMERIC(18,2)');
    ExecutaComando('alter table ESTOQUE add CODIGO_FCI VARCHAR(36)');
  end;

  // REDUCOES
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'ESTOQUE') = False then
    ExecutaComando('alter table REDUCOES add ESTOQUE VARCHAR(14)');

  // ITENS001 B2B
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'XPED') = False then
    ExecutaComando('alter table ITENS001 add XPED VARCHAR(15)');

  // Percentual do ICMS relativo ao
  // Fundo de Combate à Pobreza
  // (FCP) na UF de destino
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'pFCPUFDest') = False then
    ExecutaComando('alter table ITENS001 add pFCPUFDest DOUBLE PRECISION');

  // Alíquota interna da UF de destino
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'pICMSUFDest') = False then
    ExecutaComando('alter table ITENS001 add pICMSUFDest DOUBLE PRECISION');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'NITEMPED') = False then
    ExecutaComando('alter table ITENS001 add NITEMPED VARCHAR(6)');


  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'HASHS') = False then
  begin
    if ExecutaComando('create table HASHS (TABELA VARCHAR(15), ENCRYPTHASH varchar(56))') then
    begin
      ExecutaComando('commit');
      ExecutaComando('insert into HASHS (TABELA) values (''ESTOQUE'')');
      ExecutaComando('insert into HASHS (TABELA) values (''REDUCOES'')');
      ExecutaComando('insert into HASHS (TABELA) values (''PAGAMENT'')');
      ExecutaComando('insert into HASHS (TABELA) values (''ALTERACA'')');
      ExecutaComando('insert into HASHS (TABELA) values (''ORCAMENT'')');
      ExecutaComando('insert into HASHS (TABELA) values (''VENDAS'')');
      ExecutaComando('insert into HASHS (TABELA) values (''ITENS001'')');
      ExecutaComando('commit');      
    end;
  end;


  // ESTOQUE INDICE DE IMPOSTO APROXIMADO - IIA
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'IIA') = False then
  begin
    ExecutaComando('alter table ESTOQUE add IIA DOUBLE PRECISION');
    ExecutaComando('alter table ESTOQUE add IIA_UF DOUBLE PRECISION');
    ExecutaComando('alter table ESTOQUE add IIA_MUNI DOUBLE PRECISION');
  end;

  // ESTOQUE PROMOCAO
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'ONPROMO') = False then
  begin
    ExecutaComando('alter table ESTOQUE add ONPROMO NUMERIC(18,4)');
    ExecutaComando('alter table ESTOQUE add OFFPROMO NUMERIC(18,4)');
    ExecutaComando('alter table ESTOQUE add PROMOINI date');
    ExecutaComando('alter table ESTOQUE add PROMOFIM date');
  end;

  // ESTOQUE IPI
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CST_IPI') = False then
  begin
    ExecutaComando('alter table ESTOQUE add CST_IPI VARCHAR(2)');
    ExecutaComando('alter table ESTOQUE add ENQ_IPI VARCHAR(3)');
    ExecutaComando('alter table ESTOQUE add TIPO_ITEM VARCHAR(2)');
  end;

  // ESTOQUE PIS / COFINS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CST_PIS_COFINS_ENTRADA') = False then
  begin
    ExecutaComando('alter table ESTOQUE add CST_PIS_COFINS_ENTRADA VARCHAR(2)');
    ExecutaComando('alter table ESTOQUE add ALIQ_PIS_ENTRADA NUMERIC(18,4)');
    ExecutaComando('alter table ESTOQUE add ALIQ_COFINS_ENTRADA NUMERIC(18,4)');
    ExecutaComando('alter table ESTOQUE add CST_PIS_COFINS_SAIDA VARCHAR(2)');
    ExecutaComando('alter table ESTOQUE add ALIQ_PIS_SAIDA NUMERIC(18,4)');
    ExecutaComando('alter table ESTOQUE add ALIQ_COFINS_SAIDA NUMERIC(18,4)');
  end;

  //  ITENS001 PIS COFINS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'CST_PIS_COFINS') = False then
  begin
    ExecutaComando('alter table ITENS001 add CST_PIS_COFINS VARCHAR(2)');
    ExecutaComando('alter table ITENS001 add ALIQ_PIS NUMERIC(18,4)');
    ExecutaComando('alter table ITENS001 add ALIQ_COFINS NUMERIC(18,4)');
    ExecutaComando('alter table ITENS001 add CST_IPI CHAR(3)');
    ExecutaComando('alter table ITENS001 add CST_ICMS CHAR(3)');
  end;

  // EAN13 do fornecedor
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'EAN_ORIGINAL') = False then
    ExecutaComando('alter table ITENS002 add EAN_ORIGINAL CHAR(15)');

  // Fator de conversão
  try
    // Cria UNITARIO_O_ double precision temporario
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 add UNITARIO_O_ double precision');
    Form1.ibDataset200.Open;
    
    // Cria QTD_ORIGINAL_ double precision temporario
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 add QTD_ORIGINAL_ double precision');
    Form1.ibDataset200.Open;

    // Grava
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('commit');
    Form1.ibDataset200.Open;

    try
      // Guarda UNITARIO_O e QTD_ORIGINAL nos campos temp
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('update ITENS002 set UNITARIO_O_=UNITARIO_O, QTD_ORIGINAL_=QTD_ORIGINAL');
      Form1.ibDataset200.Open;

      // Grava
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSql.Clear;
      Form1.ibDataset200.SelectSql.Add('commit');
      Form1.ibDataset200.Open;
      //
      II := 0;
    except
      II := 99;
    end;


    // Apaga o campo original UNITARIO_O
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 drop UNITARIO_O');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
    //
    // Apaga o campo original QTD_ORIGINAL
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 drop QTD_ORIGINAL');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;

    // Grava
    ExecutaComando('commit');

    // Cria o UNITARIO_ mas agora com double precision
    ExecutaComando('alter table ITENS002 add UNITARIO_O double precision');

    // Cria o QTD_ORIGINAL mas agora com double precision
    ExecutaComando('alter table ITENS002 add QTD_ORIGINAL double precision');

    // Grava
    ExecutaComando('commit');

    // Passa o valor guardado no campo tmp para o campo original UNITARIO_O e QTD_ORIGINAL
    try
      if II = 0 then
      begin
        ExecutaComando('update ITENS002 set UNITARIO_O=UNITARIO_O_, QTD_ORIGINAL=QTD_ORIGINAL_');
      end else
      begin
        ExecutaComando('update ITENS002 set UNITARIO_O=UNITARIO, QTD_ORIGINAL=QUANTIDADE');
      end;

      // Grava
      ExecutaComando('commit');
    except
    end;
  except
  end;

  // Apaga o campo temporario UNITARIO_O_
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O_') then
    ExecutaComando('alter table ITENS002 drop UNITARIO_O_');

  // Apaga o campo temporario QTD_ORIGINAL
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL_') then
    ExecutaComando('alter table ITENS002 drop QTD_ORIGINAL_');

  // Grava
  ExecutaComando('commit');

  {Sandro Silva 2023-04-19 inicio 
  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 add QTD_ORIGINAL NUMERIC(18,9)');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ITENS002 add UNITARIO_O NUMERIC(18,9)');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
    //
    ExecutaComando('commit');
    //
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('update ITENS002 set UNITARIO_O=UNITARIO, QTD_ORIGINAL=QUANTIDADE');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
  except
  end;
  }
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL') = False then
  begin
    // tenta criar os campos
    if ExecutaComando('alter table ITENS002 add QTD_ORIGINAL NUMERIC(18,9)') then
    begin
      if ExecutaComando('alter table ITENS002 add QTD_ORIGINAL NUMERIC(18,9)') then
      begin
        // Se conseguiu criar os 2 campos faz update
        ExecutaComando('commit');
        ExecutaComando('update ITENS002 set UNITARIO_O=UNITARIO, QTD_ORIGINAL=QUANTIDADE');
        ExecutaComando('commit');
      end;
    end;
  end;

  //  ITENS002 CST ICMS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'CST_ICMS') = False then
    ExecutaComando('alter table ITENS002 add CST_ICMS VARCHAR(3)');


  //  ITENS002 PIS COFINS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'CST_PIS_COFINS') = False then
    ExecutaComando('alter table ITENS002 add CST_PIS_COFINS VARCHAR(2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'ALIQ_PIS') = False then
    ExecutaComando('alter table ITENS002 add ALIQ_PIS NUMERIC(18,4)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'ALIQ_COFINS') = False then
    ExecutaComando('alter table ITENS002 add ALIQ_COFINS NUMERIC(18,4)');

  // GRAVAR? O HISTORICO DO CSOSN
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CSOSN') = False then
    ExecutaComando('ALTER TABLE ALTERACA ADD CSOSN VARCHAR(3)');

  // ALTERACA NF de venda a consumidor (modelo 02)
  ExecutaComando('alter table ALTERACA add SERIE CHAR(4)');

  ExecutaComando('alter table ALTERACA add SUBSERIE CHAR(3)');

  ExecutaComando('alter table ALTERACA add CFOP CHAR(4)');

  // ALTERACA PIS COFINS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CST_ICMS') = False then
    ExecutaComando('alter table ALTERACA add CST_ICMS CHAR(3)');

  ExecutaComando('alter table ALTERACA add CST_PIS_COFINS VARCHAR(2)');

  ExecutaComando('alter table ALTERACA add ALIQ_PIS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add ALIQ_COFINS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add OBS VARCHAR(40)');

  ExecutaComando('alter table ALTERACA add STATUS VARCHAR(1)');

  ExecutaComando('alter table REDUCOES add CODIGOECF varchar(6)');

  // Cancelamento extemporaneo
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DATA_CANCEL') = False then
  begin
    ExecutaComando('alter table VENDAS add DATA_CANCEL date');
    ExecutaComando('alter table VENDAS add HORA_CANCEL varchar(8)');
    ExecutaComando('alter table VENDAS add COD_SIT varchar(2)');
    ExecutaComando('commit');
  end;

  // Imformações complementares VENDA
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMENTO') = False then
    ExecutaComando('alter table VENDAS add COMPLEMENTO blob sub_type 1');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'PLACA') = False then
    ExecutaComando('alter table VENDAS add PLACA varchar(11)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMEN1') then
    ExecutaComando('alter table VENDAS drop COMPLEMEN1');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMEN2') then
    ExecutaComando('alter table VENDAS drop COMPLEMEN2');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMEN3') then
    ExecutaComando('alter table VENDAS drop COMPLEMEN3');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMEN4') then
    ExecutaComando('alter table VENDAS drop COMPLEMEN4');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'COMPLEMEN5') then
    ExecutaComando('alter table VENDAS drop COMPLEMEN5');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DESCRICAO1') then
    ExecutaComando('alter table VENDAS drop DESCRICAO1');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DESCRICAO2') then
    ExecutaComando('alter table VENDAS drop DESCRICAO2');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DESCRICAO3') then
    ExecutaComando('alter table VENDAS drop DESCRICAO3');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DESCRICAO4') then
    ExecutaComando('alter table VENDAS drop DESCRICAO4');

  // Imformações complementares COMPRAS
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (Imformações complementares COMPRAS)');

  try
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'COMPLEMENTO') = False then
    begin
      ExecutaComando('alter table COMPRAS add COMPLEMENTO blob sub_type 1');

      ExecutaComando('commit');

      ExecutaComando('update COMPRAS set COMPLEMENTO=COMPLEMEN1||COMPLEMEN2||COMPLEMEN3||COMPLEMEN4||COMPLEMEN5');
      ExecutaComando('commit');

      ExecutaComando('alter table COMPRAS drop COMPLEMEN1');

      ExecutaComando('alter table COMPRAS drop COMPLEMEN2');

      ExecutaComando('alter table COMPRAS drop COMPLEMEN3');

      ExecutaComando('alter table COMPRAS drop COMPLEMEN4');

      ExecutaComando('alter table COMPRAS drop COMPLEMEN5');
      ExecutaComando('commit');
    end;
  except
  end;

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (COMPRAS NFEID)');

  // COMPRAS NFEID
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'NFEID') = False then
    ExecutaComando('alter table COMPRAS add NFEID varchar(44)');

  //ANVISA
  // VENDAS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'ANVISA') = False then
    ExecutaComando('alter table VENDAS add ANVISA integer default 0');

  // COMPRAS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'ANVISA') = False then
    ExecutaComando('alter table COMPRAS add ANVISA integer default 0');

  // ITENS001
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'ANVISA') = False then
    ExecutaComando('alter table ITENS001 add ANVISA integer default 0');

  // ITENS002
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'ANVISA') = False then
    ExecutaComando('alter table ITENS002 add ANVISA integer default 0');

  // IVA
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (IVA)');

  try
    Mensagem22('Aguarde atualizando o campo IVA...');
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('alter table ESTOQUE add PIVA double precision');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
    //
    ExecutaComando('commit');
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select * from ESTOQUE where SubString(LIVRE4 from 1 for 5)='+QuotedStr('<pIVA')+' ');
    Form1.ibDataset200.Open;
    //
    while not Form1.ibDataSet200.Eof do
    begin
      Form1.ibDataset201.Close;
      Form1.ibDataset201.SelectSql.Clear;
      Form1.ibDataset201.SelectSql.Add('update ESTOQUE set PIVA='+  QuotedStr( StrTran(LimpaNumeroDeixandoAvirgula(Form1.ibDataSet200.FieldByname('LIVRE4').AsString),',','.')) +' where CODIGO='+QuotedStr(Form1.ibDataset200.FieldByname('CODIGO').AsString)+' ');
      Form1.ibDataset201.Open;
      //
      Form1.ibDataset200.Moveby(1);
    end;
    //
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('update ESTOQUE set LIVRE4='+QuotedStr('')+' where substring(LIVRE4 from 1 for 5)='+QuotedStr('<pIVA')+' ');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.Close;
    ExecutaComando('commit');
  except
  end;

  {Sandro Silva 2023-07-17 inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ECFS') = False then
  begin
    //Criando campo
    if ExecutaComando(
        'create table ECFS (' +
        'SERIE varchar(21), ' +
        'ENCRYPTHASH varchar(56))') then
      ExecutaComando('commit');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX') = False then
  begin
    if ExecutaComando('CREATE SEQUENCE G_BLOCOX') then
      ExecutaComando('commit');

    if ExecutaComando('CREATE SEQUENCE G_HASH_BLOCOX') then
      ExecutaComando('commit');

    //Criando campos
    if ExecutaComando(
      'CREATE TABLE BLOCOX (' +
      'REGISTRO VARCHAR(10) NOT NULL, ' +
      'TIPO VARCHAR(8), ' +
      'DATAHORA TIMESTAMP, ' +
      'RECIBO VARCHAR(100), ' +
      'XMLENVIO BLOB SUB_TYPE 1 SEGMENT SIZE 80)') then
      ExecutaComando('commit');

    if ExecutaComando('ALTER TABLE BLOCOX ADD CONSTRAINT PK_BLOCOX PRIMARY KEY (REGISTRO)') then
      ExecutaComando('commit');

  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'SERIE') = False then
  begin
    //Criando campo
    if ExecutaComando('ALTER TABLE BLOCOX ADD SERIE VARCHAR(20)') then
      ExecutaComando('commit');
  end;

  if (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAESTOQUE') = False) and
    (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAREFERENCIA') = False) then
  begin
    //Criando campo
    if ExecutaComando('ALTER TABLE BLOCOX ADD DATAESTOQUE DATE') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAESTOQUE') then
  begin
    //Criando campo
    if ExecutaComando('ALTER TABLE BLOCOX ALTER DATAESTOQUE TO DATAREFERENCIA') then
      ExecutaComando('commit');

    // Orientação Auditores Bruno Nogueira, Sérgio Pinetti: Deve-se gerar somente arquivos no layout final, qualquer outro layout não será aceito pelo Bloco X.
    if ExecutaComando('delete from BLOCOX') then
      ExecutaComando('commit');

  end
  else
  begin
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAREFERENCIA') = False then
    begin
      //Criando campo
      if ExecutaComando('ALTER TABLE BLOCOX ADD DATAREFERENCIA DATE') then
        ExecutaComando('commit');

      // Orientação Auditores Bruno Nogueira, Sérgio Pinetti: Deve-se gerar somente arquivos no layout final, qualquer outro layout não será aceito pelo Bloco X.
      if ExecutaComando('delete from BLOCOX') then
        ExecutaComando('commit');

    end;
  end;

  if (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAREFERENCIA'))
    and (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'DATAESTOQUE')) then
  begin
    //Criando campo
    if ExecutaComando('ALTER TABLE BLOCOX DROP DATAESTOQUE') then
      ExecutaComando('commit');

  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'XMLRESPOSTA') = False then
  begin
    //Criando campo
    if ExecutaComando('ALTER TABLE BLOCOX ADD XMLRESPOSTA  BLOB SUB_TYPE 1 SEGMENT SIZE 80') then
      ExecutaComando('commit');
  end;

  if ExecutaComando(
    'delete from BLOCOX ' +
    ' where RECIBO = ' + QuotedStr('Layout do arquivo conforme a ER02.03 é incompatível com a ER02.05')) then
    ExecutaComando('commit');

  if ExecutaComando(
      'delete from BLOCOX ' +
      'where XMLENVIO containing ''<NomeComercial>'' ' +
      ' and XMLENVIO containing ''<Versao>'' ' +
      ' and XMLENVIO containing ''<CnpjDesenvolvedor>'' ' +
      ' and XMLENVIO containing ''<NomeEmpresarialDesenvolvedor>'' ') then
    ExecutaComando('commit');

  if ExecutaComando(
    'delete from BLOCOX ' +
    ' where XMLENVIO containing ' + QuotedStr('<>')) then
    ExecutaComando('commit');

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'IDX_BLOCOX_DTREFER_TIPO_SERIE') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_BLOCOX_DTREFER_TIPO_SERIE ON BLOCOX (DATAREFERENCIA,TIPO,SERIE)') then
      ExecutaComando('commit');

  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'IDX_BLOCOX_RECIBO') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_BLOCOX_RECIBO ON BLOCOX (RECIBO)') then
      ExecutaComando('commit');

  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'IDX_BLOCOX_DATAHORA') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_BLOCOX_DATAHORA ON BLOCOX (DATAHORA)') then
      ExecutaComando('commit');
  end;

  {Sandro Silva 2023-07-17 fim}

  // NFC-e
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (NFC-e)');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE') = False then
  begin
    ExecutaComando('create table NFCE (REGISTRO VARCHAR(10), DATA date, NUMERONF VARCHAR(6), STATUS VARCHAR(128), NFEID VARCHAR(44), NFERECIBO VARCHAR(15), NFEXML blob sub_type 1)');

    ExecutaComando('create generator G_NFCE ');

    ExecutaComando('alter table NFCE add DATA date');

    if ExecutaComando('create generator G_NUMERONFCE ') then
      ExecutaComando('set generator G_NUMERONFCE to 0 ');

    ExecutaComando('commit');
  end;


  {Sandro Silva 2023-07-17 inicio}
  if ExecutaComando(
      'update RDB$RELATION_FIELDS set ' +
      'RDB$NULL_FLAG = 1 ' +
      'where (RDB$FIELD_NAME = ''REGISTRO'') and ' +
      '(RDB$RELATION_NAME = ''NFCE'')') then
    ExecutaComando('commit');

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'PK_NFCE') = False then
  begin
    if ExecutaComando(
        'ALTER TABLE NFCE ' +
        'ADD CONSTRAINT PK_NFCE '+
        'PRIMARY KEY (REGISTRO)') then
    ExecutaComando('commit');
  end;

  {Sandro Silva 2023-07-17 fim}


  {Sandro Silva 2023-07-03 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'CAIXA') = False then
  begin

    // Criando o campo
    if ExecutaComando('ALTER TABLE NFCE ADD CAIXA VARCHAR(3)') then
    begin
      ExecutaComando('commit');

      // Atualizando o campo criado
      if ExecutaComando('update NFCE set ' +
        'CAIXA = (select first 1 A.CAIXA from ALTERACA A where A.DATA = NFCE.DATA and A.PEDIDO = NFCE.NUMERONF) ' +
        'where coalesce(CAIXA, '''') = '''' ') then
        ExecutaComando('commit');

    end;

  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'MODELO') = False then
  begin

    //Criando campo
    if ExecutaComando('ALTER TABLE NFCE ADD MODELO VARCHAR(2)') then
    begin
      ExecutaComando('commit');

      // Atualizando o campo criado
      if ExecutaComando('update NFCE set ' +
        'MODELO = case when (NFEXML containing ''<infCFe'') and (NFEXML containing ''Id="CFe'') then ''59'' else ''65'' end ' +
        'where coalesce(MODELO, '''') = '''' ') then
        ExecutaComando('commit');

    end;

  end;
  {Sandro Silva 2023-07-03 fim}

  {Sandro Silva 2023-07-27 inicio}
  // Ficha 4302
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'TOTAL') = False then
  begin

    ExecutaComando('ALTER TABLE NFCE ADD TOTAL NUMERIC(18,2)');
    ExecutaComando('commit');    

    try
      Form1.ibDataset200.Close;
      Form1.ibDataset200.SelectSQL.Text :=
        'select * ' +
        'from NFCE ' +
        'where STATUS containing ''AUTORIZA'' or STATUS containing ''Emitido com sucesso'' ';
      Form1.ibDataset200.Open;

      while Form1.ibDataset200.Eof = False do
      begin

        Form1.ibDataset200.Edit;
        if xmlNodeValue(Form1.ibDataset200.FieldByName('NFEXML').AsString, '//mod') = '59' then
          Form1.ibDataset200.FieldByName('TOTAL').AsFloat := xmlNodeValueToFloat(Form1.ibDataset200.FieldByName('NFEXML').AsString, '//vCFe');
        if xmlNodeValue(Form1.ibDataset200.FieldByName('NFEXML').AsString, '//mod') = '65' then
          Form1.ibDataset200.FieldByName('TOTAL').AsFloat := xmlNodeValueToFloat(Form1.ibDataset200.FieldByName('NFEXML').AsString, '//vNF');
        Form1.ibDataset200.Post;

        Form1.ibDataset200.Next;
      end;

      ExecutaComando('commit');
    except

    end;
  end;

  {Sandro Silva 2023-07-27 fim}


  // VENDAS FINALIDADE
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'FINNFE') = False then
    ExecutaComando('alter table VENDAS add FINNFE varchar(1)');

  // VENDAS CONSUMIDOR FINAL
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'INDFINAL') = False then
    ExecutaComando('alter table VENDAS add INDFINAL varchar(1)');

  // VENDAS PRESENCIAL
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'INDPRES') = False then
    ExecutaComando('alter table VENDAS add INDPRES varchar(1)');

  // COMPRAS FINALIDADE
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'FINNFE') = False then
    ExecutaComando('alter table COMPRAS add FINNFE varchar(1)');

  // COMPRAS CONSUMIDOR FINAL
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'INDFINAL') = False then
    ExecutaComando('alter table COMPRAS add INDFINAL varchar(1)');

  // COMPRAS PRESENCIAL
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'INDPRES') = False then
    ExecutaComando('alter table COMPRAS add INDPRES varchar(1)');

  // PAF
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (PAF)');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'DEMAIS') = False then
  begin
    ExecutaComando('create table DEMAIS (REGISTRO VARCHAR(10), ECF VARCHAR(20), COO VARCHAR(6), GNF VARCHAR(6), GRG VARCHAR(6), CDC VARCHAR(6), DENOMINACAO VARCHAR(2), DATA date, HORA VARCHAR(8), ENCRYPTHASH varchar(56))');
    ExecutaComando('create generator G_DEMAIS ');
    ExecutaComando('commit');    
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAOS') = False then
    ExecutaComando('create table CONTAOS (CONTA VARCHAR(6), IDENTIFICADOR1 VARCHAR(15), IDENTIFICADOR2 VARCHAR(15), IDENTIFICADOR3 VARCHAR(15), IDENTIFICADOR4 VARCHAR(15), IDENTIFICADOR5 VARCHAR(15))');

  //ExecutaComando('create generator G_DEMAIS ');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'MEDIDA') = False then
    ExecutaComando('create table MEDIDA (REGISTRO VARCHAR(10), SIGLA VARCHAR(6), DESCRICAO VARCHAR(30), OBS VARCHAR(30), PRIMARY KEY (SIGLA) )');

  ExecutaComando('commit');
  
  // SPED
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (SPED)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VICMS') = False then
    ExecutaComando('alter table ITENS001 add VICMS numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VBC') = False then
    ExecutaComando('alter table ITENS001 add VBC numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VBCST') = False then
    ExecutaComando('alter table ITENS001 add VBCST numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VICMSST') = False then
    ExecutaComando('alter table ITENS001 add VICMSST numeric(18,2)');

  ExecutaComando('commit');
  // vIPI
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (vIPI)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'vIPI') = False then
    ExecutaComando('alter table ITENS001 add vIPI numeric(18,2)');

  ExecutaComando('commit');


  // SPED COMPRAS
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (vICMS)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'VICMS') = False then
    ExecutaComando('alter table ITENS002 add VICMS numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'VBC') = False then
    ExecutaComando('alter table ITENS002 add VBC numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'VBCST') = False then
    ExecutaComando('alter table ITENS002 add VBCST numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'VICMSST') = False then
    ExecutaComando('alter table ITENS002 add VICMSST numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'vIPI') = False then
    ExecutaComando('alter table ITENS002 add vIPI numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'CST_IPI') = False then
    ExecutaComando('alter table ITENS002 add CST_IPI varchar(2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'vPRECO') = False then
    ExecutaComando('alter table ITENS002 add vPRECO numeric(18,2)');

  ExecutaComando('commit');

  // SPED Desconto
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'DESCONTO') = False then
    ExecutaComando('alter table ALTERACA add DESCONTO numeric(18,2)');

  ExecutaComando('commit');

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (NUMERONF)');

  ExecutaComando('alter table RESUMO alter DOCUMENTO type varchar(12)');
  ExecutaComando('commit');

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select NUMERONF from COMPRAS where NUMERONF=''999999'' ');
    Form1.ibDataset200.Open;

    if Form1.ibDataSet200.FieldByName('NUMERONF').Size <= 7 then
    begin
      ExecutaComando('alter table COMPRAS alter NUMERONF type varchar(12)');

      ExecutaComando('alter table ITENS002 alter NUMERONF type varchar(12)');

      ExecutaComando('alter table PAGAR alter NUMERONF type varchar(12)');

      ExecutaComando('alter table PAGAR alter DOCUMENTO type varchar(10)');

      ExecutaComando('commit');

      ExecutaComando('update COMPRAS set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) '); // Ok

      ExecutaComando('update ITENS002 set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) '); // ok

      ExecutaComando('update PAGAR set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) ');  // ok

      ExecutaComando('update PAGAR set DOCUMENTO='+QuotedStr('000')+'||SubString(DOCUMENTO from 1 for 7)');  // ok

      ExecutaComando('commit');
    end;
  except
  end;

  // VENDAS E RECEBER
  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select NUMERONF from VENDAS where NUMERONF=''999999'' ');
    Form1.ibDataset200.Open;

    if Form1.ibDataSet200.FieldByName('NUMERONF').Size <= 7 then
    begin
      ExecutaComando('alter table VENDAS alter NUMERONF type varchar(12)');

      ExecutaComando('alter table ITENS001 alter NUMERONF type varchar(12)');

      ExecutaComando('alter table ITENS003 alter NUMERONF type varchar(12)');

      ExecutaComando('alter table RECEBER alter NUMERONF type varchar(12)');

      ExecutaComando('alter table RECEBER alter DOCUMENTO type varchar(10)');

      ExecutaComando('commit');

      ExecutaComando('update VENDAS set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) '); // Ok

      ExecutaComando('update ITENS001 set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) '); // ok

      ExecutaComando('update ITENS003 set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) '); // ok

      ExecutaComando('update RECEBER set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) ');  // ok

      ExecutaComando('update RECEBER set DOCUMENTO=SubString(DOCUMENTO from 1 for 1)||'+QuotedStr('000')+'||SubString(DOCUMENTO from 2 for 6)');  // ok

      ExecutaComando('commit');
    end;
  except
  end;

  try
    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSql.Clear;
    Form1.ibDataset200.SelectSql.Add('select NUMERONF from ORCAMENT where NUMERONF=''999999'' ');
    Form1.ibDataset200.Open;
    //
    if Form1.ibDataSet200.FieldByName('NUMERONF').Size <= 7 then
    begin
      ExecutaComando('alter table ORCAMENT alter NUMERONF type varchar(12)');
      ExecutaComando('commit');
      ExecutaComando('update ORCAMENT set NUMERONF='+QuotedStr('000')+'||SubString(NUMERONF from 1 for 6)||'+QuotedStr('00')+'||SubString(NUMERONF from 7 for 1) ');  // ok
      ExecutaComando('commit');
    end;
  except
  end;

  // Nosso Numero
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'NN') = False then
  begin
    ExecutaComando('alter table RECEBER add NN varchar(10)');
    ExecutaComando('create generator G_NN');
    ExecutaComando('commit');
  end;

  // Anvisa
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'ANVISA') = False then
    ExecutaComando('alter table COMPRAS add ANVISA integer default 0');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'ANVISA') = False then
    ExecutaComando('alter table ALTERACA add ANVISA integer default 0');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CSOSN') = False then
    ExecutaComando('alter table ESTOQUE add CSOSN varchar(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CEST') = False then
    ExecutaComando('alter table ESTOQUE add CEST varchar(7)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CSOSN_NFCE') = False then
    ExecutaComando('alter table ESTOQUE add CSOSN_NFCE varchar(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CST_NFCE') = False then
    ExecutaComando('alter table ESTOQUE add CST_NFCE varchar(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'ALIQUOTA_NFCE') = False then
    ExecutaComando('alter table ESTOQUE add ALIQUOTA_NFCE numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table EMITENTE add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table ESTOQUE add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table VENDAS add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table ITENS001 add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table ALTERACA add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table PAGAMENT add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ORCAMENT', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table ORCAMENT add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ORCAMENT', 'COO') = False then
    ExecutaComando('alter table ORCAMENT add COO varchar(6)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'ENCRYPTHASH') = False then
    ExecutaComando('alter table REDUCOES add ENCRYPTHASH varchar(56)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'STATUS') = False then
    ExecutaComando('alter table REDUCOES add STATUS varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'COO') = False then
    ExecutaComando('alter table ALTERACA add COO varchar(6)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CCF') = False then
    ExecutaComando('alter table ALTERACA add CCF varchar(6)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'CCF') = False then
    ExecutaComando('alter table PAGAMENT add CCF varchar(6)'); // Número de operações não fiscais executadas na impressora.

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'COO') = False then
    ExecutaComando('alter table PAGAMENT add COO varchar(6)'); // Número de operações não fiscais executadas na impressora.

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'GNF') = False then
    ExecutaComando('alter table PAGAMENT add GNF varchar(6)'); // Número de operações não fiscais executadas na impressora.

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'GRG') = False then
    ExecutaComando('alter table PAGAMENT add GRG varchar(6)'); //  Numero do Relatório Gerencial

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'CDC') = False then
    ExecutaComando('alter table PAGAMENT add CDC varchar(6)'); // Número de conprovante de debito e credito

  ExecutaComando('commit');

  {Sandro Silva 2023-07-17 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'IDPAGAMENTO') then
  begin
    // Criando o campo
    if ExecutaComando('ALTER TABLE PAGAMENT DROP IDPAGAMENTO') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'IDRESPOSTAFISCAL') then
  begin
    // Criando o campo
    if ExecutaComando('ALTER TABLE PAGAMENT DROP IDRESPOSTAFISCAL') then
      ExecutaComando('commit');

      // Elimina os dados de transações diferentes a cartão usadas com integrador fiscal
    if ExecutaComando(
      'delete from VFPE ' +
      'where substring(FORMA from 1 for 2) <> ''03'' ') then
      ExecutaComando('commit');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE') = False then
  begin
    // Tabela para usar com integrador fiscal do Ceará
    if ExecutaComando(
        'CREATE TABLE VFPE (' +
        'REGISTRO VARCHAR(10) NOT NULL, ' +
        'DATA DATE, ' +
        'PEDIDO VARCHAR(6), ' +
        'CAIXA VARCHAR(3), ' +
        'FORMA VARCHAR(30), ' +
        'VALOR NUMERIC(18,2), ' +
        'IDPAGAMENTO INTEGER, ' +
        'IDRESPOSTAFISCAL INTEGER, ' +
        'TRANSMITIDO VARCHAR(1))') then
      ExecutaComando('commit');

    // Chave primária
    if ExecutaComando('ALTER TABLE VFPE ADD CONSTRAINT PK_VFPE PRIMARY KEY (REGISTRO)') then
      ExecutaComando('commit');

    // Generator
    if ExecutaComando('CREATE SEQUENCE G_VFPE') then
      ExecutaComando('commit');

  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE') then
  begin
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'TRANSACAO') = False then
    begin
      if ExecutaComando('ALTER TABLE VFPE ADD TRANSACAO VARCHAR(20) ') then
        ExecutaComando('commit');
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'NOMEREDE') = False then
    begin
      if ExecutaComando('ALTER TABLE VFPE ADD NOMEREDE VARCHAR(30)') then
        ExecutaComando('commit');
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'IDPAGAMENTO') then
    begin
      if TamanhoCampo(Form1.ibDataSet200.Transaction, 'VFPE', 'IDPAGAMENTO') < 11 then
      begin
        if ExecutaComando('ALTER TABLE VFPE ALTER IDPAGAMENTO TYPE VARCHAR(11)') then
          ExecutaComando('commit');
      end;
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'IDRESPOSTAFISCAL') then
    begin
      if TamanhoCampo(Form1.ibDataSet200.Transaction, 'VFPE', 'IDRESPOSTAFISCAL') < 11 then
      begin
        if ExecutaComando('ALTER TABLE VFPE ALTER IDRESPOSTAFISCAL TYPE VARCHAR(11)') then
          ExecutaComando('commit');
      end;
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'AUTORIZACAO') = False then
    begin
      if ExecutaComando('ALTER TABLE VFPE ADD AUTORIZACAO VARCHAR(20)') then
        ExecutaComando('commit');
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'BANDEIRA') = False then
    begin
      if ExecutaComando('ALTER TABLE VFPE ADD BANDEIRA VARCHAR(30)') then
        ExecutaComando('commit');
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'IDPAGAMENTO') then
    begin // Aumentar tamanho campo
      if TamanhoCampo(Form1.ibDataSet200.Transaction, 'VFPE', 'IDPAGAMENTO') < 15 then
      begin
        if ExecutaComando('ALTER TABLE VFPE ALTER IDPAGAMENTO TYPE VARCHAR(15) CHARACTER SET NONE') then
          ExecutaComando('commit');
      end;
    end;
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VFPE', 'IDRESPOSTAFISCAL') then
    begin // Aumentar tamanho campo
      if TamanhoCampo(Form1.ibDataSet200.Transaction, 'VFPE', 'IDRESPOSTAFISCAL') < 15 then
      begin
        if ExecutaComando('ALTER TABLE VFPE ALTER IDRESPOSTAFISCAL TYPE VARCHAR(15) CHARACTER SET NONE') then
          ExecutaComando('commit');
      end;
    end;
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'DEMAIS', 'CCF') = False then
  begin
    if ExecutaComando('ALTER TABLE DEMAIS ADD CCF VARCHAR(6)') then
      ExecutaComando('commit');
  end;

  //Índices para otimizar banco
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'DEMAIS', 'IDX_DEMAIS_DATA') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_DEMAIS_DATA ON DEMAIS (DATA)') then
      ExecutaComando('commit');
  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'DEMAIS', 'IDX_DEMAIS_ECFCOO') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_DEMAIS_ECFCOO ON DEMAIS (ECF,COO)') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'SEQUENCIALCONTACLIENTEOS') = False then
  begin
    if ExecutaComando('ALTER TABLE ALTERACA ADD SEQUENCIALCONTACLIENTEOS VARCHAR(10)') then
      ExecutaComando('commit');

    // Generator
    if ExecutaComando('CREATE SEQUENCE G_SEQUENCIALCONTACLIENTEOS') then
      ExecutaComando('commit');
  end
  else
  begin
    try
      Form1.ibDataSet200.Close;
      Form1.ibDataSet200.SelectSQL.Text :=
        'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS from ALTERACA where (TIPO = ''MESA'' or TIPO = ''DEKOL'') group by PEDIDO ';
      Form1.ibDataSet200.Open;

      while Form1.ibDataSet200.Eof = False do
      begin
        if Form1.ibDataSet200.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString = '' then
        begin
          try
            ExecutaComando(
              'update ALTERACA set ' +
              'SEQUENCIALCONTACLIENTEOS = ' + QuotedStr(Right(DupeString('0', 10) + IncGenerator(Form1.ibDataSet200.Transaction.DefaultDatabase, 'G_SEQUENCIALCONTACLIENTEOS', 1), 10)) +
              ' where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
              ' and PEDIDO = ' + QuotedStr(Form1.ibDataSet200.FieldByName('PEDIDO').AsString));
          except
          end;
        end;
        Form1.ibDataSet200.Next;
      end;

    except
    end;

  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAOS', 'IDENTIFICADOR1') then
  begin // Aumentar o tamanho dos campos identificadores para uso na NFC-e e SAT
    try
      // Não usei a função TamanhoCampo() porque CONTAOS não tem campo REGISTRO
      if TamanhoCampo(Form1.ibDataSet200.Transaction, 'CONTAOS', 'IDENTIFICADOR1') = 15 then
      begin
        if ExecutaComando(
          'ALTER TABLE CONTAOS ' +
          'ALTER IDENTIFICADOR1 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
          'ALTER IDENTIFICADOR2 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
          'ALTER IDENTIFICADOR3 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
          'ALTER IDENTIFICADOR4 TYPE VARCHAR(40) CHARACTER SET NONE, ' +
          'ALTER IDENTIFICADOR5 TYPE VARCHAR(40) CHARACTER SET NONE ') then
          ExecutaComando('commit');
      end;
    except

    end;
  end;

  // Para poder controlar sangria e suprimento quando atende após meia-noite
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'HORA') = False then
  begin
    if ExecutaComando('ALTER TABLE PAGAMENT ADD HORA VARCHAR(8)') then
      ExecutaComando('commit');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PENDENCIA') = False then
  begin
    // Tabela para controlar as alterações que o frente não consegue realizar na tabela ALTERACA por DEAD LOCK com transações do Small
    // Identificado quando é realizado cancelamento de venda
    if ExecutaComando(
      'CREATE TABLE PENDENCIA ( ' +
      'CAIXA VARCHAR(3), ' +
      'PEDIDO VARCHAR(9), ' +
      'ITEM VARCHAR(6), ' +
      'TIPO VARCHAR(6))') then
      ExecutaComando('commit');
  end;

  //indices otimizar consultas relacionada ao bloco x e abertura cupom
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'IDX_REDUCOES_SERIE') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_REDUCOES_SERIE ON REDUCOES (SERIE)') then
      ExecutaComando('commit');
  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BLOCOX', 'IDX_BLOCOX_TIPO_RECIBO_SERIE') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_BLOCOX_TIPO_RECIBO_SERIE ON BLOCOX (TIPO, RECIBO, SERIE)') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'NFEIDSUBSTITUTO') = False then
  begin
    if ExecutaComando('ALTER TABLE NFCE ADD NFEIDSUBSTITUTO VARCHAR(44)') then
      ExecutaComando('commit');
  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'IDX_REDUCOES_CUPOMF') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_REDUCOES_CUPOMF ON REDUCOES (CUPOMF)') then
      ExecutaComando('commit');
  end;

  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'IDX_REDUCOES_PDV_SMALL') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_REDUCOES_PDV_SMALL ON REDUCOES (PDV, SMALL)') then
      ExecutaComando('commit');
  end;

  // Generator para vendas do MEI no frente
  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase,'G_NUMEROCUPOMMEI') = False then
  begin
    if ExecutaComando('CREATE SEQUENCE G_NUMEROCUPOMMEI') then
      ExecutaComando('commit');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE') then
  begin
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'ENCRYPTHASH') = False then
    begin

      // Controle de evidência do PAF-NFC-e J1 e J2
      if ExecutaComando('ALTER TABLE NFCE ADD ENCRYPTHASH VARCHAR(56)') then
        ExecutaComando('commit');

      if ExecutaComando('CREATE SEQUENCE G_HASH_NFCE') then
        ExecutaComando('commit');

    end;

  end;

  // Generator para série da NFC-e
  if GeneratorExisteFB(Form1.ibdataset200.Transaction.DefaultDatabase, 'G_SERIENFCE') = False then
  begin
    if ExecutaComando('CREATE SEQUENCE G_SERIENFCE') then
      ExecutaComando('commit');

    if ExecutaComando('ALTER SEQUENCE G_SERIENFCE RESTART WITH 1') then
      ExecutaComando('commit');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA') then
  begin
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'MARKETPLACE') = False then
    begin
      // Controle de evidência do PAF-NFC-e J1 e J2
      if ExecutaComando('ALTER TABLE ALTERACA ADD MARKETPLACE VARCHAR(60)') then
        ExecutaComando('commit');
    end;
  end;

  {Sandro Silva 2023-07-17 fim}

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'CRT') = False then
    ExecutaComando('alter table EMITENTE add CRT varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'CNAE') = False then
    ExecutaComando('alter table EMITENTE add CNAE varchar(7)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'LICENCA') = False then
    ExecutaComando('alter table EMITENTE add LICENCA varchar(56)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CSOSN') = False then
    ExecutaComando('alter table ICM add CSOSN varchar(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'NVOL') = False then
    ExecutaComando('alter table VENDAS add NVOL varchar(60)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'NVOL') = False then
    ExecutaComando('alter table COMPRAS add NVOL varchar(60)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'LOKED') = False then
    ExecutaComando('alter table VENDAS add LOKED varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'NFEPROTOCOLO') = False then
    ExecutaComando('alter table VENDAS add NFEPROTOCOLO varchar(80)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'STATUS') = False then
    ExecutaComando('alter table VENDAS add STATUS varchar(128)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'NFEID') = False then
    ExecutaComando('alter table VENDAS add NFEID varchar(44)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'NFERECIBO') = False then
    ExecutaComando('alter table VENDAS add NFERECIBO varchar(15)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'NFEXML') = False then
    ExecutaComando('alter table VENDAS add NFEXML blob sub_type 1');

  ExecutaComando('commit');
      
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'NFEXML') = False then
    ExecutaComando('alter table COMPRAS add NFEXML blob sub_type 1');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'MDESTINXML') = False then
    ExecutaComando('alter table COMPRAS add MDESTINXML blob sub_type 1');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'ICCE') = False then
    ExecutaComando('alter table VENDAS add ICCE integer');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'CCEXML') = False then
    ExecutaComando('alter table VENDAS add CCEXML blob sub_type 1');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'RECIBOXML') = False then
    ExecutaComando('alter table VENDAS add RECIBOXML blob sub_type 1');

  ExecutaComando('commit');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'AUDIT0RIA') = False then
    ExecutaComando('create table AUDIT0RIA (ATO varchar(10), MODULO varchar(10), USUARIO varchar(60), HISTORICO varchar(80), VALOR_DE numeric(18,2), VALOR_PARA numeric(18,2), DATA date, HORA varchar(8), REGISTRO varchar(10))');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'IAT') = False then
    ExecutaComando('alter table ESTOQUE add IAT varchar(01)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'IPPT') = False then
    ExecutaComando('alter table ESTOQUE add IPPT varchar(01)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'SMALL') = False then
    ExecutaComando('alter table REDUCOES add SMALL varchar(02)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'TIPOECF') = False then
    ExecutaComando('alter table REDUCOES add TIPOECF varchar(07)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'MARCAECF') = False then
    ExecutaComando('alter table REDUCOES add MARCAECF varchar(20)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'MODELOECF') = False then
    ExecutaComando('alter table REDUCOES add MODELOECF varchar(20)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'VERSAOSB') = False then
    ExecutaComando('alter table REDUCOES add VERSAOSB varchar(10)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'DATASB') = False then
    ExecutaComando('alter table REDUCOES add DATASB varchar(08)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'HORASB') = False then
    ExecutaComando('alter table REDUCOES add HORASB varchar(06)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CNPJ') = False then
    ExecutaComando('alter table ALTERACA add CNPJ varchar(19)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'MUNICIPIO') = False then
    ExecutaComando('alter table EMITENTE alter MUNICIPIO type varchar(40)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'TRANSPOR', 'ANTT') = False then
    ExecutaComando('alter table TRANSPOR add ANTT varchar(20)');

  ExecutaComando('alter table TRANSPOR alter MUNICIPIO type varchar(40)');

  ExecutaComando('alter table CLIFOR alter CIDADE type varchar(40)');

  ExecutaComando('commit');

  try

    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Text :=
      'select CLIFOR ' +
      'from CLIFOR';
    Form1.ibDataSet200.Open;

    if Form1.ibDataSet200.FieldByName('CLIFOR').Size < 40 then
    begin

      if ExecutaComando('alter table CLIFOR alter CLIFOR type varchar(40)') then
      begin
        ExecutaComando('commit');
        ExecutaComando('update CLIFOR set CLIFOR= ''Cliente'' where CLIFOR= ''C'' ');
        ExecutaComando('update CLIFOR set CLIFOR= ''Fornecedor'' where CLIFOR= ''F'' ');
        ExecutaComando('commit');
      end;

    end;
  except

  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CLIFOR', 'FOTO') = False then
    ExecutaComando('alter table CLIFOR add FOTO blob sub_type 0');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CLIFOR', 'WHATSAPP') = False then
  begin
    if ExecutaComando('alter table CLIFOR add WHATSAPP varchar(16)') then
    begin
      ExecutaComando('commit');
      ExecutaComando('update CLIFOR set WHATSAPP=CELULAR');
      ExecutaComando('commit');
    end;
  end;

  // PAF
  try

    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Text :=
      'select REFERENCIA ' +
      'from ESTOQUE';
    Form1.ibDataSet200.Open;

    if Form1.ibDataSet200.FieldByName('REFERENCIA').Size < 14 then
    begin
      ExecutaComando('alter table ESTOQUE alter REFERENCIA type varchar(14)');
      ExecutaComando('commit');
    end;
  except
  
  end;

  // NF-e
  try

    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Text :=
      'select CIDADE ' +
      'from CLIFOR';
    Form1.ibDataSet200.Open;

    if Form1.ibDataSet200.FieldByName('CIDADE').Size < 30 then
    begin
      ExecutaComando('alter table CLIFOR alter CIDADE type varchar(30)');
      ExecutaComando('commit');
    end;

  except
  end;

  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'G_LEGAL') = False then
  begin
    if ExecutaComando('create generator G_LEGAL ') then
      ExecutaComando('set generator G_LEGAL to 0');
    ExecutaComando('commit');      
  end;

  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'G_BUILD') = False then
    ExecutaComando('create generator G_BUILD ');

  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'G_MUTADO') = False then
    ExecutaComando('create generator G_MUTADO ');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ORCAMENT', 'NUMERONF') = False then
    ExecutaComando('alter table ORCAMENT add NUMERONF varchar(7)');

  if sBuild < '336' then
  begin
    Form22.Repaint;
    Mensagem22('Aguarde alterando estrutura do banco de dados... (336)');
    // Para atender o PAF o DAV tem que ter Número com 10 dígitos
    ExecutaComando('alter table ORCAMENT alter PEDIDO type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ORCAMENT set PEDIDO='+QuotedStr('0000')+'||SubString(PEDIDO  from 1 for 6) where SubString(PEDIDO from 7 for 3)='+QuotedStr('')+' ');
    ExecutaComando('commit');

    ExecutaComando('alter table OS alter NUMERO type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update OS set NUMERO='+QuotedStr('0000')+'||SubString(NUMERO from 1 for 6) where SubString(NUMERO from 7 for 3)='+QuotedStr('')+' ');
    ExecutaComando('commit');

    ExecutaComando('alter table OS alter NF type varchar(12)');

    ExecutaComando('alter table ITENS001 alter NUMEROOS type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ITENS001 set NUMEROOS='+QuotedStr('0000')+'||SubString(NUMEROOS from 1 for 6) where SubString(NUMEROOS from 7 for 3)='+QuotedStr('')+' ');
    ExecutaComando('commit');

    ExecutaComando('alter table ITENS003 alter NUMEROOS type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ITENS003 set NUMEROOS='+QuotedStr('0000')+'||SubString(NUMEROOS from 1 for 6) where SubString(NUMEROOS from 7 for 3)='+QuotedStr('')+' ');
    ExecutaComando('commit');    
  end;

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (337)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'IM') = False then
    ExecutaComando('alter table EMITENTE add IM varchar(16)');

  ExecutaComando('alter table ICM alter OBS type varchar(250)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CST') = False then
    ExecutaComando('alter table ICM add CST varchar(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CSTCOFINS') then
    ExecutaComando('alter table ICM drop CSTCOFINS');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CSTPISCOFINS') = False then
    ExecutaComando('alter table ICM add CSTPISCOFINS VARCHAR(2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CSTPIS') then
    ExecutaComando('alter table ICM drop CSTPIS');

  {Sandro Silva 2023-07-03 inicio
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCPIS') = False then
    ExecutaComando('alter table ICM add BCPIS numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCCOFINS') = False then
    ExecutaComando('alter table ICM add BCCOFINS numeric(18,2)');
  }

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCPISCOFINS') = False then
  begin

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCPIS') = False then
      ExecutaComando('alter table ICM add BCPIS numeric(18,2)');

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCCOFINS') = False then
      ExecutaComando('alter table ICM add BCCOFINS numeric(18,2)');

    if ExecutaComando('ALTER TABLE ICM ADD BCPISCOFINS NUMERIC(18,2)') then
    begin
      ExecutaComando('commit');

      ExecutaComando(' Update ICM set '+
                     '   BCPISCOFINS = '+
                     '         Case'+
                     '           When Coalesce(BCCOFINS,0) > Coalesce(BCPIS,0) then BCCOFINS'+
                     '           Else BCPIS'+
                     '         End');

      ExecutaComando('commit');

      ExecutaComando('ALTER TABLE ICM drop BCPIS');

      ExecutaComando('ALTER TABLE ICM drop BCCOFINS');

      ExecutaComando('commit');
    end;

  end
  else
  begin
    // Se existir ICM.BCPISCOFINS não deve existir ICM.BCPIS e ICM.BCCOFINS

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCPIS') then
    begin
      if ExecutaComando('alter table ICM drop BCPIS') then
        ExecutaComando('commit');
    end;

    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'BCCOFINS') then
    begin
      if ExecutaComando('alter table ICM drop BCCOFINS') then
        ExecutaComando('commit');
    end;

  end;
  {Sandro Silva 2023-07-03 fim}

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'PPIS') = False then
    ExecutaComando('alter table ICM add PPIS numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'PCOFINS') = False then
    ExecutaComando('alter table ICM add PCOFINS numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'SOBREIPI') = False then
    ExecutaComando('alter table ICM add SOBREIPI varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'SOBREFRETE') = False then
    ExecutaComando('alter table ICM add SOBREFRETE varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'SOBRESEGURO') = False then
    ExecutaComando('alter table ICM add SOBRESEGURO varchar(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'SOBREOUTRAS') = False then
    ExecutaComando('alter table ICM add SOBREOUTRAS varchar(1)');

  ExecutaComando('commit');

  ExecutaComando('alter table OS alter PROBLEMA type varchar(128)');

  ExecutaComando('alter table ALTERACA add HORA varchar(8)');

  ExecutaComando('alter table REDUCOES add HORA varchar(8)');

  ExecutaComando('alter table ALTERACA add DAV varchar(10)');

  ExecutaComando('alter table ALTERACA add TIPODAV varchar(10)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RESUMO', 'VALOR') = False then
    ExecutaComando('alter table RESUMO add VALOR numeric(18,2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAR', 'ATIVO') = False then
    ExecutaComando('alter table PAGAR add ATIVO integer');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'MUNICIPIOS') = False then
    ExecutaComando('create table MUNICIPIOS (CODIGO varchar(7), NOME varchar(40), UF varchar(2), REGISTRO varchar(10))');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'IBPT') = False then
    ExecutaComando('create table IBPT (CODIGO varchar(8), Ex varchar(2), Tabela varchar(2), AliqNac NUMERIC(18,4),AlicImp NUMERIC(18,4),REGISTRO varchar(10))');

  // Novo IBPT_
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'IBPT_') = False then
  begin
    ExecutaComando('create table IBPT_ (CODIGO varchar(10),'+
                  'EX varchar(2),'+
                  'TIPO varchar(2),'+
                  'DESCRICAO varchar(500),'+
                  'NACIONALFEDERAL Numeric(18,4),'+
                  'IMPORTADOFEDERAL Numeric(18,4),'+
                  'ESTADUAL Numeric(18,4),'+
                  'MUNICIPAL Numeric(18,4),'+
                  'VIGENCIAINICIO varchar(10),'+
                  'VIGENCIAFIM varchar(10),'+
                  'CHAVE varchar(10),'+
                  'VERSAO varchar(10),'+
                  'FONTE varchar(10),'+
                  'REGISTRO varchar(10))');
    ExecutaComando('commit');                  
  end;

  ExecutaComando('alter table IBPT_ alter FONTE type varchar(30)');

  ExecutaComando('alter table IBPT_ alter FONTE type varchar(20)');

  ExecutaComando('alter table VENDEDOR alter NOME type varchar(35)');

  ExecutaComando('alter table ALTERACA alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table VENDAS alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table ORCAMENT alter VENDEDOR type varchar(35)');

  ExecutaComando('commit');
  
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'CSOSN') = False then
  begin
    {Sandro Silva 2022-10-04 inicio}
    if ExecutaComando('ALTER TABLE ITENS001 ADD CSOSN VARCHAR(3)') then
      ExecutaComando('commit');
    {Sandro Silva 2022-10-04 fim}
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VBC_PIS_COFINS') = False then
  begin
    if ExecutaComando('ALTER TABLE ITENS001 ADD VBC_PIS_COFINS NUMERIC(18,2)') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'VBC_PIS_COFINS') = False then
  begin
    if ExecutaComando('ALTER TABLE ALTERACA ADD VBC_PIS_COFINS NUMERIC(18,2)') then
      ExecutaComando('commit');
  end;

  {Sandro Silva 2022-12-16 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'MOVIMENTO') = False then
  begin
    if ExecutaComando('ALTER TABLE RECEBER ADD MOVIMENTO DATE') then // Armazena a data que o valor foi creditado na conta banco
      ExecutaComando('commit');
  end;

  if ExecutaComando('alter table RECEBER alter DOCUMENTO type varchar(11)') then // Para poder marcar as parcelas migradas da Smallsoft para Zucchetti durante a incorporação
    ExecutaComando('commit');

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS') then
  begin
    if ExecutaComando('ALTER TABLE CONTAS ADD DESCRICAOCONTABIL VARCHAR(60), ADD IDENTIFICADOR VARCHAR(10), ADD CONTACONTABILIDADE VARCHAR(20)') then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'IDENTIFICADORPLANOCONTAS') = False then
  begin
    if ExecutaComando('ALTER TABLE COMPRAS ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)') then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'IDENTIFICADORPLANOCONTAS') = False then
  begin
    if ExecutaComando('ALTER TABLE ESTOQUE ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'IDENTIFICADORPLANOCONTAS') = False then
  begin
    if ExecutaComando('ALTER TABLE ITENS001 ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS003', 'IDENTIFICADORPLANOCONTAS') = False then
  begin
    if ExecutaComando('ALTER TABLE ITENS003 ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;
  {Sandro Silva 2022-12-16 fim}

  {Sandro Silva 2023-04-10 inicio
  ExecutaComando('alter table ICM add FRETESOBREIPI varchar(1)');
  }
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'FRETESOBREIPI') = False then
  begin
    if ExecutaComando('alter table ICM add FRETESOBREIPI varchar(1)') then // Mauricio Parizotto 2023-03-28
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'INSTITUICAOFINANCEIRA') = False then
  begin
    if ExecutaComando('alter table RECEBER add INSTITUICAOFINANCEIRA varchar(60), add FORMADEPAGAMENTO varchar(60)') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'VBCFCP') = False then
  begin
    if ExecutaComando('alter table ITENS001 add VBCFCP numeric(18, 2), ' +
                                           'add PFCP numeric(18, 4), ' +
                                           'add VFCP numeric(18, 2), ' +
                                           'add VBCFCPST numeric(18, 2), ' +
                                           'add PFCPST numeric(18, 4), ' +
                                           'add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'VBCFCP') = False then
  begin
    if ExecutaComando('alter table ITENS002 add VBCFCP numeric(18, 2), ' +
                                           'add PFCP numeric(18, 4), ' +
                                           'add VFCP numeric(18, 2), ' +
                                           'add VBCFCPST numeric(18, 2), ' +
                                           'add PFCPST numeric(18, 4), ' +
                                           'add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-04-10 fim}
  {Sandro Silva 2023-04-11 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'VFCPST') = False then
  begin
    if ExecutaComando('alter table COMPRAS add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-04-11 fim}

  if ExecutaComando('Update EMITENTE set CNAE = ''0''||trim(CNAE) Where char_length(trim(CNAE)) = 6') then // Mauricio Parizotto 2023-04-06
    ExecutaComando('commit');


  //Mauricio Parizotto 2023-05-08
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'RECURSO') = False then
  begin
    if ExecutaComando('alter table EMITENTE add RECURSO BLOB SUB_TYPE TEXT') then
      ExecutaComando('Commit');
  end;

  {Sandro Silva 2023-04-12 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'VFCPST') = False then
  begin
    if ExecutaComando('alter table VENDAS add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-04-12 fim}

  //Mauricio Parizotto 2023-06-16
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'INSTITUICAOFINANCEIRA') = False then
  begin
    if ExecutaComando('alter table BANCOS add INSTITUICAOFINANCEIRA varchar(60)') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'NFCE', 'GERENCIAL') = False then
  begin
    if ExecutaComando('alter table NFCE add GERENCIAL varchar(9)') then
      ExecutaComando('Commit');
  end;
  
{Sandro Silva 2023-06-22 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'AUTORIZACAOTRANSACAO') = False then
  begin
    if ExecutaComando('alter table RECEBER add AUTORIZACAOTRANSACAO varchar(20)') then
      ExecutaComando('Commit');
  end;
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'BANDEIRA') = False then
  begin
    if ExecutaComando('alter table RECEBER add BANDEIRA varchar(20)') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-06-22 fim}

  (* // Sandro Silva 2023-06-26
  No frente.exe paf não foi alterado porque necessita novo credenciamento
  Habilitar a mudança de tamanho nas casas decimais somente quando o frente estiver preparado

  {Dailon Parisotto 2023-06-15 inicio}
  if (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'FATORC')) then
  begin
    try
      try
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSQL.Clear;
        Form1.ibDataSet200.SelectSQL.Add('SELECT');
        Form1.ibDataSet200.SelectSQL.Add('    B.RDB$FIELD_SCALE*-1 AS DECIMAIS');
        Form1.ibDataSet200.SelectSQL.Add('FROM RDB$RELATION_FIELDS A');
        Form1.ibDataSet200.SelectSQL.Add('INNER JOIN RDB$FIELDS B');
        Form1.ibDataSet200.SelectSQL.Add('    ON (A.RDB$FIELD_SOURCE=B.RDB$FIELD_NAME)');
        Form1.ibDataSet200.SelectSQL.Add('WHERE (A.RDB$RELATION_NAME = ''ESTOQUE'')');
        Form1.ibDataSet200.SelectSQL.Add('AND (A.RDB$FIELD_NAME = ''FATORC'')');
        Form1.ibDataSet200.Open;

        if (Form1.ibDataSet200.FieldByName('DECIMAIS').AsInteger = 2) then
        begin

          if ExecutaComando('ALTER TABLE ESTOQUE ADD FATORCTEMP NUMERIC(18,2)') then
            ExecutaComando('Commit');

          ExecutaComando(' UPDATE ESTOQUE SET ' +
                         'FATORCTEMP=FATORC ' +
                         'WHERE (FATORC>0) ' +
                         'AND COALESCE(FATORCTEMP,0)=0');
          ExecutaComando('commit');

          if ExecutaComando('ALTER TABLE ESTOQUE DROP FATORC') then
            ExecutaComando('Commit');

          if ExecutaComando('ALTER TABLE ESTOQUE ADD FATORC NUMERIC(18,4)') then
            ExecutaComando('Commit');

          ExecutaComando(' UPDATE ESTOQUE SET ' +
                         'FATORC=FATORCTEMP ' +
                         'WHERE (COALESCE(FATORC,0)=0) ' +
                         'AND (FATORCTEMP > 0)');
          ExecutaComando('commit');

          if ExecutaComando('ALTER TABLE ESTOQUE DROP FATORCTEMP') then
            ExecutaComando('Commit');
        end;
      finally
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSQL.Clear;
      end;
    except
    end;
  end;
  {Dailon Parisotto 2023-06-15 fim}
  *)

  if (CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'FATORC')) then
  begin
    try
      try
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSQL.Clear;
        Form1.ibDataSet200.SelectSQL.Text :=
          'select ' +
          '    B.RDB$FIELD_SCALE * -1 as DECIMAIS ' +
          'from RDB$RELATION_FIELDS A ' +
          'inner join RDB$FIELDS B '  +
          '    on (A.RDB$FIELD_SOURCE = B.RDB$FIELD_NAME) ' +
          'where (A.RDB$RELATION_NAME = ''ESTOQUE'') ' +
          'and (A.RDB$FIELD_NAME = ''FATORC'') ';
        Form1.ibDataSet200.Open;

        if (Form1.ibDataSet200.FieldByName('DECIMAIS').AsInteger = 4) then
        begin

          if ExecutaComando('alter table ESTOQUE add FATORCTEMP numeric(18, 4)') then
            ExecutaComando('Commit');

          ExecutaComando('update ESTOQUE set ' +
                         'FATORCTEMP = FATORC ' +
                         'where (FATORC > 0) ' +
                         'and coalesce(FATORCTEMP, 0) = 0');
          ExecutaComando('commit');

          if ExecutaComando('alter table ESTOQUE drop FATORC') then
            ExecutaComando('Commit');

          if ExecutaComando('alter table ESTOQUE add FATORC numeric(18, 2)') then
            ExecutaComando('Commit');

          ExecutaComando('update ESTOQUE set ' +
                         'FATORC = cast(FATORCTEMP as numeric(18, 2)) ' +
                         'where (coalesce(FATORC, 0) = 0) ' +
                         'and (FATORCTEMP > 0)');
          ExecutaComando('commit');

          if ExecutaComando('alter table ESTOQUE drop FATORCTEMP') then
            ExecutaComando('Commit');
        end;
      finally
        Form1.ibDataSet200.Close;
        Form1.ibDataSet200.SelectSQL.Clear;
      end;
    except
    end;
  end;

  {Sandro Silva 2023-06-26 fim}



  {Mauricio Parizotto 2023-07-18 inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'ICMS_DESONERADO') = False then
  begin
    if ExecutaComando('alter table ITENS002 add ICMS_DESONERADO numeric(18,2)') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'ICMS_DESONERADO') = False then
  begin
    if ExecutaComando('alter table COMPRAS add ICMS_DESONERADO numeric(18,2)') then
      ExecutaComando('Commit');
  end;

  {Mauricio Parizotto 2023-07-18 fim}


  {Sandro Silva 2023-07-27 inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'TRANSACAOELETRONICA') = False then
  begin

    ExecutaComando('CREATE SEQUENCE G_GNF');

    ExecutaComando('CREATE SEQUENCE G_TRANSACAOELETRONICA');

    ExecutaComando(
      'CREATE TABLE TRANSACAOELETRONICA ( ' +
      'REGISTRO          VARCHAR(10) NOT NULL, ' +
      'DATA              DATE, ' +
      'PEDIDO            VARCHAR(6), ' +
      'CAIXA             VARCHAR(3), ' +
      'FORMA             VARCHAR(30), ' +
      'VALOR             NUMERIC(18,2), ' +
      'TRANSACAO         VARCHAR(20), ' +
      'NOMEREDE          VARCHAR(30), ' +
      'AUTORIZACAO       VARCHAR(20), ' +
      'BANDEIRA          VARCHAR(30), ' +
      'MODELO            VARCHAR(2), ' +
      'GNF               VARCHAR(9) ' +
      ')'
    );
    ExecutaComando('ALTER TABLE TRANSACAOELETRONICA ADD CONSTRAINT PK_TRANSACAOELETRONICA PRIMARY KEY (REGISTRO)');
    ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-07-27 fim}

  {Mauricio Parizotto 2023-08-07 Inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BACKUP') = False then
  begin
    ExecutaComando('Create table BACKUP('+
                   ' 	IDBACKUP INTEGER NOT NULL,'+
                   ' 	AUTOMATICO VARCHAR(1) NOT NULL,'+
                   ' 	NOMECOMPUTADOR VARCHAR(40),'+
                   ' 	DIRETORIO VARCHAR(200),'+
                   ' 	CONSTRAINT PK_BACKUP_IDBACKUP PRIMARY KEY (IDBACKUP) '+
                   ')');


    ExecutaComando('CREATE SEQUENCE G_BACKUP_IDBACKUP');
  end;

  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BACKUPHORARIOS') = False then
  begin
    ExecutaComando('Create table BACKUPHORARIOS('+
                   ' 	IDHORARIO INTEGER NOT NULL,'+
                   ' 	IDBACKUP INTEGER NOT NULL,'+
                   ' 	HORARIO TIME NOT NULL,	'+
                   ' 	CONSTRAINT PK_BACKUPHORARIOS_IDHORARIO PRIMARY KEY (IDHORARIO) '+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_BACKUPHORARIOS_IDHORARIO');
  end;
  {Mauricio Parizotto 2023-08-07 Fim}
  

  {Mauricio Parizotto 2023-08-30 Inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PERFILTRIBUTACAO') = False then
  begin
    ExecutaComando('Create table PERFILTRIBUTACAO('+
                   ' 	IDPERFILTRIBUTACAO INTEGER NOT NULL,'+
                   ' 	DESCRICAO VARCHAR(45),'+
                   ' 	TIPO_ITEM VARCHAR(2),'+
                   ' 	IPPT VARCHAR(1),'+
                   ' 	IAT VARCHAR(1),'+
                   ' 	PIVA DOUBLE PRECISION,'+
                   ' 	CST VARCHAR(3),'+
                   ' 	CSOSN VARCHAR(3),'+
                   ' 	ST VARCHAR(3),'+
                   ' 	CFOP VARCHAR(4),'+
                   ' 	CST_NFCE VARCHAR(3),'+
                   ' 	CSOSN_NFCE VARCHAR(3),'+
                   ' 	ALIQUOTA_NFCE NUMERIC(18,2),'+
                   ' 	CST_IPI VARCHAR(2),'+
                   ' 	IPI DOUBLE PRECISION,'+
                   ' 	ENQ_IPI VARCHAR(3),'+
                   ' 	CST_PIS_COFINS_SAIDA VARCHAR(2),'+
                   ' 	ALIQ_PIS_SAIDA NUMERIC(18,4),'+
                   ' 	ALIQ_COFINS_SAIDA NUMERIC(18,4),'+
                   ' 	CST_PIS_COFINS_ENTRADA VARCHAR(2),'+
                   ' 	ALIQ_PIS_ENTRADA NUMERIC(18,4),'+
                   ' 	ALIQ_COFINS_ENTRADA NUMERIC(18,4),'+
                   ' 	REGISTRO VARCHAR(10) NOT NULL,'+
                   ' 	CONSTRAINT PK_PERFILTRIBUTACAO PRIMARY KEY (REGISTRO)'+
                   ')');

    ExecutaComando('Alter Table ESTOQUE add IDPERFILTRIBUTACAO integer');

    ExecutaComando('CREATE SEQUENCE G_PERFILTRIBUTACAO');

    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-08-30 Fim}

  Form22.Repaint;
  Mensagem22('Aguarde...');

  try
    Form7.TabelaAberta           := Form7.ibDataSet2;

    ExecutaComando('delete from VENDEDOR where coalesce(NOME,''X.X.X'') =''X.X.X'' ');

    ExecutaComando('delete from CLIFOR where coalesce(NOME,''X.X.X'') =''X.X.X'' ');

    Form1.ibDataset200.Close;
    Form1.ibDataset200.SelectSQL.Clear;
    Form1.ibDataset200.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' order by upper(NOME)');
    Form1.ibDataset200.Open;
    Form1.ibDataset200.First;

    while not Form1.ibDataset200.Eof do
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form1.ibDataset200.FieldByname('NOME').AsString)+' ');  //
      Form7.ibDataSet2.Open;

      if AllTrim(Form7.ibDataSet2NOME.AsString) = AllTrim(Form1.ibDataset200.FieldByname('NOME').AsString) then
      begin
        Form7.ibDataSet2.Edit;
        Form7.ibDataSet2CLIFOR.AsString := 'Vendedor';
        Form7.ibDataSet2.Post;
      end else
      begin
        Form7.ibDataSet2.Append;
        Form7.ibDataSet2NOME.AsString   := Form1.ibDataset200.FieldByname('NOME').AsString;
        Form7.ibDataSet2CLIFOR.AsString := 'Vendedor';
        Form7.ibDataSet2.Post;
      end;

      Form1.ibDataset200.Next;
    end;
  except
  end;

  try
    AgendaCommit(True);
    Commitatudo(True);
  except
  end;

  try
    Form1.este1Click(nil);
    Form22.Button1.Visible := False;
    ExecutaComando('set generator G_BUILD to ' + BUILD_DO_BANCO); // Sandro Silva 2022-09-12 Form1.ibDataset200.SelectSql.Add('set generator G_BUILD to 2022004');
  except
  end;

  ExecutaComando('update COMPRAS set NFEXML = null where coalesce(NFEXML, '''') <> '''' and (NFEXML not like ''%<chNFe>''||NFEID||''</chNFe>%'')');

  ExecutaComando('commit');  

  Form13.Tag := 99;

  Mensagem22('Criando indicadores...');

  Form22.Repaint;
  Mensagem22('Alteração na estrutura Ok');
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
