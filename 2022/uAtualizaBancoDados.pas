unit uAtualizaBancoDados;

//Mauricio Parizotto 2023-03-28

interface

uses
  Mais,
  SysUtils
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

  procedure AtualizaBancoDeDados(sBuild : string);
  function ExecutaComando(comando:string):Boolean;

implementation

uses Unit22, Unit13;


procedure AtualizaBancoDeDados(sBuild : string);
var
  II : integer;
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
  ExecutaComando('alter table VENDAS add MARKETPLACE varchar(60)');

  ExecutaComando('alter table ESTOQUE add MARKETPLACE VARCHAR(1)');

  // Alterando o tamanho da RAZAO SOCIAL
  ExecutaComando('alter table AUDIT0RIA alter USUARIO type varchar(60)');

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

  ExecutaComando('create table CODEBAR (REGISTRO VARCHAR(10), CODIGO VARCHAR(5),EAN VARCHAR(15), FORNECEDOR VARCHAR(60))');

  ExecutaComando('create table INUTILIZACAO (REGISTRO VARCHAR(10) NOT NULL, MODELO VARCHAR(2), ANO INTEGER, SERIE SMALLINT, NINI INTEGER, NFIN INTEGER, NPROT VARCHAR(15), XML BLOB SUB_TYPE 1 SEGMENT SIZE 80, DATA Date)');

  ExecutaComando('ALTER TABLE INUTILIZACAO ADD CONSTRAINT PK_INUTILIZACAO PRIMARY KEY (REGISTRO)');

  ExecutaComando('CREATE SEQUENCE G_INUTILIZACAO');

  // ESTOQUE TAG para incluir qualquer campo
  ExecutaComando('alter table ESTOQUE add TAGS_ blob sub_type 1');
  Form7.ibDataSet4.Tag := IDENTIFICADOR_CAMPO_ESTOQUE_TAGS_CRIADO; // Sandro Silva 2022-09-12Form7.ibDataSet4.Tag := 999;

  ExecutaComando('alter table ESTOQUE add QTD_PRO1 DOUBLE PRECISION');

  ExecutaComando('alter table ESTOQUE add QTD_PRO2 DOUBLE PRECISION');

  ExecutaComando('alter table ESTOQUE add DESCONT1 DOUBLE PRECISION');

  ExecutaComando('alter table ESTOQUE add DESCONT2 DOUBLE PRECISION');

  // ESTOQUE CFOP para venda ao consumidor
  ExecutaComando('alter table ESTOQUE add CFOP VARCHAR(4)');

  // Fator de conversão
  ExecutaComando('alter table ESTOQUE add MEDIDAE VARCHAR(3)');

  ExecutaComando('alter table ESTOQUE add FATORC NUMERIC(18,2)');

  // ESTOQUE FCI
  ExecutaComando('alter table ESTOQUE add VALOR_PARCELA_IMPORTADA_EXTERIO NUMERIC(18,2)');

  ExecutaComando('alter table ESTOQUE add CODIGO_FCI VARCHAR(36)');

  // REDUCOES
  ExecutaComando('alter table REDUCOES add ESTOQUE VARCHAR(14)');

  ExecutaComando('alter table REDUCOES add ESTOQUE VARCHAR(14)');

  // ITENS001 B2B
  ExecutaComando('alter table ITENS001 add XPED VARCHAR(15)');

  // Percentual do ICMS relativo ao
  // Fundo de Combate à Pobreza
  // (FCP) na UF de destino
  ExecutaComando('alter table ITENS001 add pFCPUFDest DOUBLE PRECISION');

  // Alíquota interna da UF de destino
  ExecutaComando('alter table ITENS001 add pICMSUFDest DOUBLE PRECISION');

  ExecutaComando('alter table ITENS001 add NITEMPED VARCHAR(6)');


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
  end;

  
  // ESTOQUE INDICE DE IMPOSTO APROXIMADO - IIA
  ExecutaComando('alter table ESTOQUE add IIA DOUBLE PRECISION');

  ExecutaComando('alter table ESTOQUE add IIA_UF DOUBLE PRECISION');

  ExecutaComando('alter table ESTOQUE add IIA_MUNI DOUBLE PRECISION');

  // ESTOQUE PROMOCAO
  ExecutaComando('alter table ESTOQUE add ONPROMO NUMERIC(18,4)');

  ExecutaComando('alter table ESTOQUE add OFFPROMO NUMERIC(18,4)');

  ExecutaComando('alter table ESTOQUE add PROMOINI date');

  ExecutaComando('alter table ESTOQUE add PROMOFIM date');

  // ESTOQUE IPI
  ExecutaComando('alter table ESTOQUE add CST_IPI VARCHAR(2)');

  ExecutaComando('alter table ESTOQUE add ENQ_IPI VARCHAR(3)');

  ExecutaComando('alter table ESTOQUE add TIPO_ITEM VARCHAR(2)');

  // ESTOQUE PIS / COFINS
  ExecutaComando('alter table ESTOQUE add CST_PIS_COFINS_ENTRADA VARCHAR(2)');

  ExecutaComando('alter table ESTOQUE add ALIQ_PIS_ENTRADA NUMERIC(18,4)');

  ExecutaComando('alter table ESTOQUE add ALIQ_COFINS_ENTRADA NUMERIC(18,4)');

  ExecutaComando('alter table ESTOQUE add CST_PIS_COFINS_SAIDA VARCHAR(2)');

  ExecutaComando('alter table ESTOQUE add ALIQ_PIS_SAIDA NUMERIC(18,4)');

  ExecutaComando('alter table ESTOQUE add ALIQ_COFINS_SAIDA NUMERIC(18,4)');

  //  ITENS001 PIS COFINS
  ExecutaComando('alter table ITENS001 add CST_PIS_COFINS VARCHAR(2)');

  ExecutaComando('alter table ITENS001 add ALIQ_PIS NUMERIC(18,4)');

  ExecutaComando('alter table ITENS001 add ALIQ_COFINS NUMERIC(18,4)');

  ExecutaComando('alter table ITENS001 add CST_IPI CHAR(3)');

  ExecutaComando('alter table ITENS001 add CST_ICMS CHAR(3)');

  // EAN13 do fornecedor
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
  ExecutaComando('alter table ITENS002 drop UNITARIO_O_');

  // Apaga o campo temporario QTD_ORIGINAL
  ExecutaComando('alter table ITENS002 drop QTD_ORIGINAL_');

  // Grava
  ExecutaComando('commit');

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

  //  ITENS002 CST ICMS
  ExecutaComando('alter table ITENS002 add CST_ICMS VARCHAR(3)');

  //  ITENS002 PIS COFINS
  ExecutaComando('alter table ITENS002 add CST_PIS_COFINS VARCHAR(2)');

  ExecutaComando('alter table ITENS002 add ALIQ_PIS NUMERIC(18,4)');

  ExecutaComando('alter table ITENS002 add ALIQ_COFINS NUMERIC(18,4)');

  // GRAVAR? O HISTORICO DO CSONS
  ExecutaComando('ALTER TABLE ALTERACA ADD CSOSN VARCHAR(3)');

  // ALTERACA NF de venda a consumidor (modelo 02)
  ExecutaComando('alter table ALTERACA add SERIE CHAR(4)');

  ExecutaComando('alter table ALTERACA add SUBSERIE CHAR(3)');

  ExecutaComando('alter table ALTERACA add CFOP CHAR(4)');

  // ALTERACA PIS COFINS
  ExecutaComando('alter table ALTERACA add CST_ICMS CHAR(3)');

  ExecutaComando('alter table ALTERACA add CST_PIS_COFINS VARCHAR(2)');

  ExecutaComando('alter table ALTERACA add ALIQ_PIS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add ALIQ_COFINS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add OBS VARCHAR(40)');

  ExecutaComando('alter table ALTERACA add STATUS VARCHAR(1)');

  ExecutaComando('alter table REDUCOES add CODIGOECF varchar(6)');

  // Cancelamento extemporaneo
  ExecutaComando('alter table VENDAS add DATA_CANCEL date');

  ExecutaComando('alter table VENDAS add HORA_CANCEL varchar(8)');

  ExecutaComando('alter table VENDAS add COD_SIT varchar(2)');

  // Imformações complementares VENDA
  ExecutaComando('alter table VENDAS add COMPLEMENTO blob sub_type 1');

  ExecutaComando('alter table VENDAS add PLACA varchar(11)');

  ExecutaComando('alter table VENDAS drop COMPLEMEN1');

  ExecutaComando('alter table VENDAS drop COMPLEMEN2');

  ExecutaComando('alter table VENDAS drop COMPLEMEN3');

  ExecutaComando('alter table VENDAS drop COMPLEMEN4');

  ExecutaComando('alter table VENDAS drop COMPLEMEN5');

  ExecutaComando('alter table VENDAS drop DESCRICAO1');

  ExecutaComando('alter table VENDAS drop DESCRICAO2');

  ExecutaComando('alter table VENDAS drop DESCRICAO3');

  ExecutaComando('alter table VENDAS drop DESCRICAO4');

  // Imformações complementares COMPRAS
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (Imformações complementares COMPRAS)');
 
  try
    ExecutaComando('alter table COMPRAS add COMPLEMENTO blob sub_type 1');

    ExecutaComando('commit');

    ExecutaComando('update COMPRAS set COMPLEMENTO=COMPLEMEN1||COMPLEMEN2||COMPLEMEN3||COMPLEMEN4||COMPLEMEN5');

    ExecutaComando('alter table COMPRAS drop COMPLEMEN1');

    ExecutaComando('alter table COMPRAS drop COMPLEMEN2');

    ExecutaComando('alter table COMPRAS drop COMPLEMEN3');

    ExecutaComando('alter table COMPRAS drop COMPLEMEN4');

    ExecutaComando('alter table COMPRAS drop COMPLEMEN5');
  except
  end;

  // COMPRAS NFEID
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (COMPRAS NFEID)');

  ExecutaComando('alter table COMPRAS add NFEID varchar(44)');

  // VENDAS
  ExecutaComando('alter table VENDAS add ANVISA integer default 0');

  // COMPRAS
  ExecutaComando('alter table COMPRAS add ANVISA integer default 0');

  // ITENS001
  ExecutaComando('alter table ITENS001 add ANVISA integer default 0');

  // ITENS002
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
  except
  end;


  // NFC-e
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (NFC-e)');

  ExecutaComando('create table NFCE (REGISTRO VARCHAR(10), DATA date, NUMERONF VARCHAR(6), STATUS VARCHAR(128), NFEID VARCHAR(44), NFERECIBO VARCHAR(15), NFEXML blob sub_type 1)');

  ExecutaComando('create generator G_NFCE ');

  ExecutaComando('alter table NFCE add DATA date');

  if ExecutaComando('create generator G_NUMERONFCE ') then
    ExecutaComando('set generator G_NUMERONFCE to 0 ');

  // VENDAS FINALIDADE
  ExecutaComando('alter table VENDAS add FINNFE varchar(1)');

  // VENDAS CONSUMIDOR FINAL
  ExecutaComando('alter table VENDAS add INDFINAL varchar(1)');

  // VENDAS PRESENCIAL
  ExecutaComando('alter table VENDAS add INDPRES varchar(1)');

  // COMPRAS FINALIDADE
  ExecutaComando('alter table COMPRAS add FINNFE varchar(1)');

  // COMPRAS CONSUMIDOR FINAL
  ExecutaComando('alter table COMPRAS add INDFINAL varchar(1)');

  // COMPRAS PRESENCIAL
  ExecutaComando('alter table COMPRAS add INDPRES varchar(1)');

  
  // PAF
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (PAF)');

  ExecutaComando('create table DEMAIS (REGISTRO VARCHAR(10), ECF VARCHAR(20), COO VARCHAR(6), GNF VARCHAR(6), GRG VARCHAR(6), CDC VARCHAR(6), DENOMINACAO VARCHAR(2), DATA date, HORA VARCHAR(8), ENCRYPTHASH varchar(56))');

  ExecutaComando('create generator G_DEMAIS ');

  ExecutaComando('create table CONTAOS (CONTA VARCHAR(6), IDENTIFICADOR1 VARCHAR(15), IDENTIFICADOR2 VARCHAR(15), IDENTIFICADOR3 VARCHAR(15), IDENTIFICADOR4 VARCHAR(15), IDENTIFICADOR5 VARCHAR(15))');

  ExecutaComando('create generator G_DEMAIS ');

  ExecutaComando('create table MEDIDA (REGISTRO VARCHAR(10), SIGLA VARCHAR(6), DESCRICAO VARCHAR(30), OBS VARCHAR(30), PRIMARY KEY (SIGLA) )');


  // SPED
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (SPED)');

  ExecutaComando('alter table ITENS001 add VICMS numeric(18,2)');

  ExecutaComando('alter table ITENS001 add VBC numeric(18,2)');

  ExecutaComando('alter table ITENS001 add VBCST numeric(18,2)');

  ExecutaComando('alter table ITENS001 add VICMSST numeric(18,2)');


  // vIPI
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (vIPI)');

  ExecutaComando('alter table ITENS001 add vIPI numeric(18,2)');

  ExecutaComando('commit');


  // SPED COMPRAS
  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (vICMS)');

  ExecutaComando('alter table ITENS002 add VICMS numeric(18,2)');

  ExecutaComando('alter table ITENS002 add VBC numeric(18,2)');

  ExecutaComando('alter table ITENS002 add VBCST numeric(18,2)');

  ExecutaComando('alter table ITENS002 add VICMSST numeric(18,2)');

  ExecutaComando('alter table ITENS002 add vIPI numeric(18,2)');

  ExecutaComando('alter table ITENS002 add CST_IPI varchar(2)');

  ExecutaComando('alter table ITENS002 add vPRECO numeric(18,2)');

  ExecutaComando('commit');

  // SPED Desconto
  ExecutaComando('alter table ALTERACA add DESCONTO numeric(18,2)');

  ExecutaComando('commit');

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (NUMERONF)');

  ExecutaComando('alter table RESUMO alter DOCUMENTO type varchar(12)');

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
    end;
  except
  end;

  // Nosso Numero
  ExecutaComando('alter table RECEBER add NN varchar(10)');

  ExecutaComando('create generator G_NN');

  ExecutaComando('commit');

  // Anvisa
  ExecutaComando('alter table COMPRAS add ANVISA integer default 0');

  ExecutaComando('alter table ALTERACA add ANVISA integer default 0');

  ExecutaComando('alter table ESTOQUE add CSOSN varchar(3)');

  ExecutaComando('alter table ESTOQUE add CEST varchar(7)');

  ExecutaComando('alter table ESTOQUE add CSOSN_NFCE varchar(3)');

  ExecutaComando('alter table ESTOQUE add CST_NFCE varchar(3)');

  ExecutaComando('alter table ESTOQUE add ALIQUOTA_NFCE numeric(18,2)');

  ExecutaComando('alter table EMITENTE add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table ESTOQUE add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table VENDAS add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table ITENS001 add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table ALTERACA add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table PAGAMENT add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table ORCAMENT add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table ORCAMENT add COO varchar(6)');

  ExecutaComando('alter table REDUCOES add ENCRYPTHASH varchar(56)');

  ExecutaComando('alter table REDUCOES add STATUS varchar(1)');

  ExecutaComando('alter table ALTERACA add COO varchar(6)');

  ExecutaComando('alter table ALTERACA add CCF varchar(6)');

  ExecutaComando('alter table PAGAMENT add CCF varchar(6)'); // Número de operações não fiscais executadas na impressora.

  ExecutaComando('alter table PAGAMENT add COO varchar(6)'); // Número de operações não fiscais executadas na impressora.

  ExecutaComando('alter table PAGAMENT add GNF varchar(6)'); // Número de operações não fiscais executadas na impressora.

  ExecutaComando('alter table PAGAMENT add GRG varchar(6)'); //  Numero do Relatório Gerencial

  ExecutaComando('alter table PAGAMENT add CDC varchar(6)'); // Número de conprovante de debito e credito

  ExecutaComando('alter table EMITENTE add CRT varchar(1)');

  ExecutaComando('alter table EMITENTE add CNAE varchar(7)');

  ExecutaComando('alter table EMITENTE add LICENCA varchar(56)');

  ExecutaComando('alter table ICM add CSOSN varchar(3)');

  ExecutaComando('alter table VENDAS add NVOL varchar(60)');

  ExecutaComando('alter table COMPRAS add NVOL varchar(60)');

  ExecutaComando('alter table VENDAS add LOKED varchar(1)');

  ExecutaComando('alter table VENDAS add NFEPROTOCOLO varchar(80)');

  ExecutaComando('alter table VENDAS add STATUS varchar(128)');

  ExecutaComando('alter table VENDAS add NFEID varchar(44)');

  ExecutaComando('alter table VENDAS add NFERECIBO varchar(15)');

  ExecutaComando('alter table VENDAS add NFEXML blob sub_type 1');

  ExecutaComando('alter table COMPRAS add NFEXML blob sub_type 1');

  ExecutaComando('alter table COMPRAS add MDESTINXML blob sub_type 1');

  ExecutaComando('alter table VENDAS add ICCE integer');

  ExecutaComando('alter table VENDAS add CCEXML blob sub_type 1');

  ExecutaComando('alter table VENDAS add RECIBOXML blob sub_type 1');

  ExecutaComando('create table AUDIT0RIA (ATO varchar(10), MODULO varchar(10), USUARIO varchar(60), HISTORICO varchar(80), VALOR_DE numeric(18,2), VALOR_PARA numeric(18,2), DATA date, HORA varchar(8), REGISTRO varchar(10))');

  ExecutaComando('alter table ESTOQUE add IAT varchar(01)');

  ExecutaComando('alter table ESTOQUE add IPPT varchar(01)');

  ExecutaComando('alter table REDUCOES add SMALL varchar(02)');

  ExecutaComando('alter table REDUCOES add TIPOECF varchar(07)');

  ExecutaComando('alter table REDUCOES add MARCAECF varchar(20)');

  ExecutaComando('alter table REDUCOES add MODELOECF varchar(20)');

  ExecutaComando('alter table REDUCOES add VERSAOSB varchar(10)');

  ExecutaComando('alter table REDUCOES add DATASB varchar(08)');

  ExecutaComando('alter table REDUCOES add HORASB varchar(06)');

  ExecutaComando('alter table ALTERACA add CNPJ varchar(19)');

  ExecutaComando('alter table EMITENTE alter MUNICIPIO type varchar(40)');

  ExecutaComando('alter table TRANSPOR add ANTT varchar(20)');

  ExecutaComando('alter table TRANSPOR alter MUNICIPIO type varchar(40)');

  ExecutaComando('alter table CLIFOR alter CIDADE type varchar(40)');

  if ExecutaComando('alter table CLIFOR alter CLIFOR type varchar(40)') then
  begin
    ExecutaComando('commit');

    ExecutaComando('update CLIFOR set CLIFOR=''Cliente'' where CLIFOR=''C'' ');

    ExecutaComando('update CLIFOR set CLIFOR=''Fornecedor'' where CLIFOR=''F'' ');
  end;

  ExecutaComando('alter table CLIFOR add FOTO blob sub_type 0');

  if ExecutaComando('alter table CLIFOR add WHATSAPP varchar(16)') then
  begin
    ExecutaComando('commit');
    
    ExecutaComando('update CLIFOR set WHATSAPP=CELULAR');
  end;

  // PAF
  ExecutaComando('alter table ESTOQUE alter REFERENCIA type varchar(14)');

  // NF-e
  ExecutaComando('alter table CLIFOR alter CIDADE type varchar(30)');

  if ExecutaComando('create generator G_LEGAL ') then
    ExecutaComando('set generator G_LEGAL to 0');

  ExecutaComando('create generator G_BUILD ');

  ExecutaComando('create generator G_MUTADO ');

  ExecutaComando('alter table ORCAMENT add NUMERONF varchar(7)');

  if sBuild < '336' then
  begin
    Form22.Repaint;
    Mensagem22('Aguarde alterando estrutura do banco de dados... (336)');
    // Para atender o PAF o DAV tem que ter Número com 10 dígitos
    ExecutaComando('alter table ORCAMENT alter PEDIDO type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ORCAMENT set PEDIDO='+QuotedStr('0000')+'||SubString(PEDIDO  from 1 for 6) where SubString(PEDIDO from 7 for 3)='+QuotedStr('')+' ');

    ExecutaComando('alter table OS alter NUMERO type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update OS set NUMERO='+QuotedStr('0000')+'||SubString(NUMERO from 1 for 6) where SubString(NUMERO from 7 for 3)='+QuotedStr('')+' ');

    ExecutaComando('alter table OS alter NF type varchar(12)');

    ExecutaComando('alter table ITENS001 alter NUMEROOS type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ITENS001 set NUMEROOS='+QuotedStr('0000')+'||SubString(NUMEROOS from 1 for 6) where SubString(NUMEROOS from 7 for 3)='+QuotedStr('')+' ');

    ExecutaComando('alter table ITENS003 alter NUMEROOS type varchar(10)');

    CommitaTudo(True);

    ExecutaComando('update ITENS003 set NUMEROOS='+QuotedStr('0000')+'||SubString(NUMEROOS from 1 for 6) where SubString(NUMEROOS from 7 for 3)='+QuotedStr('')+' ');
  end;

  Form22.Repaint;
  Mensagem22('Aguarde alterando estrutura do banco de dados... (337)');


  ExecutaComando('alter table EMITENTE add IM varchar(16)');

  ExecutaComando('alter table ICM alter OBS type varchar(250)');

  ExecutaComando('alter table ICM add CST varchar(3)');

  ExecutaComando('alter table ICM drop CSTCOFINS');

  ExecutaComando('alter table ICM add CSTPISCOFINS VARCHAR(2)');

  ExecutaComando('alter table ICM drop CSTPIS');

  ExecutaComando('alter table ICM add BCPIS numeric(18,2)');

  ExecutaComando('alter table ICM add BCCOFINS numeric(18,2)');

  ExecutaComando('alter table ICM add PPIS numeric(18,2)');

  ExecutaComando('alter table ICM add PCOFINS numeric(18,2)');

  ExecutaComando('alter table ICM add SOBREIPI varchar(1)');

  ExecutaComando('alter table ICM add SOBREFRETE varchar(1)');

  ExecutaComando('alter table ICM add SOBRESEGURO varchar(1)');

  ExecutaComando('alter table ICM add SOBREOUTRAS varchar(1)');

  ExecutaComando('alter table OS alter PROBLEMA type varchar(128)');

  ExecutaComando('alter table ALTERACA add HORA varchar(8)');

  ExecutaComando('alter table REDUCOES add HORA varchar(8)');

  ExecutaComando('alter table ALTERACA add DAV varchar(10)');

  ExecutaComando('alter table ALTERACA add TIPODAV varchar(10)');

  ExecutaComando('alter table RESUMO add VALOR numeric(18,2)');

  ExecutaComando('alter table PAGAR add ATIVO integer');

  ExecutaComando('create table MUNICIPIOS (CODIGO varchar(7), NOME varchar(40), UF varchar(2), REGISTRO varchar(10))');

  ExecutaComando('create table IBPT (CODIGO varchar(8), Ex varchar(2), Tabela varchar(2), AliqNac NUMERIC(18,4),AlicImp NUMERIC(18,4),REGISTRO varchar(10))');

  // Novo IBPT_
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

  ExecutaComando('alter table IBPT_ alter FONTE type varchar(30)');

  ExecutaComando('alter table IBPT_ alter FONTE type varchar(20)');

  ExecutaComando('alter table VENDEDOR alter NOME type varchar(35)');

  ExecutaComando('alter table ALTERACA alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table VENDAS alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table ORCAMENT alter VENDEDOR type varchar(35)');

  {Sandro Silva 2022-10-04 inicio}
  if ExecutaComando('ALTER TABLE ITENS001 ADD CSOSN VARCHAR(3)') then
    ExecutaComando('commit');
  {Sandro Silva 2022-10-04 fim}

  {Sandro Silva 2022-10-25 inicio}
  if ExecutaComando('ALTER TABLE ITENS001 ADD VBC_PIS_COFINS NUMERIC(18,2)') then
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE ALTERACA ADD VBC_PIS_COFINS NUMERIC(18,2)') then
    ExecutaComando('commit');
  {Sandro Silva 2022-10-25 fim}

  {Sandro Silva 2022-12-16 inicio}
  if ExecutaComando('ALTER TABLE RECEBER ADD MOVIMENTO DATE') then // Armazena a data que o valor foi creditado na conta banco
    ExecutaComando('commit');

  if ExecutaComando('alter table RECEBER alter DOCUMENTO type varchar(11)') then // Para poder marcar as parcelas migradas da Smallsoft para Zucchetti durante a incorporação
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE CONTAS ADD DESCRICAOCONTABIL VARCHAR(60), ADD IDENTIFICADOR VARCHAR(10), ADD CONTACONTABILIDADE VARCHAR(20)') then // Para gerar relatórios contábeis
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE COMPRAS ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)') then // Para gerar relatórios contábeis
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE ESTOQUE ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE ITENS001 ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
    ExecutaComando('commit');

  if ExecutaComando('ALTER TABLE ITENS003 ADD IDENTIFICADORPLANOCONTAS VARCHAR(10)')then // Para gerar relatórios contábeis
    ExecutaComando('commit');
  {Sandro Silva 2022-12-16 fim}

  ExecutaComando('alter table ICM add FRETESOBREIPI varchar(1)'); // Mauricio Parizotto 2023-03-28

  if ExecutaComando('ALTER TABLE ICM ADD BCPISCOFINS NUMERIC(18,2)') then
  begin
    ExecutaComando('commit');

    if ExecutaComando('Update ICM set BCPISCOFINS = COALESCE(BCCOFINS,BCPIS)') then
      ExecutaComando('commit');
  end;


  Form22.Repaint;
  Mensagem22('Aguarde...');

  try
    Form7.TabelaAberta           := Form7.ibDataSet2;

    ExecutaComando('delete from VENDEDOR where Coalesce(NOME,''X.X.X'' =''X.X.X'' ');

    ExecutaComando('delete from CLIFOR where Coalesce(NOME,''X.X.X'' =''X.X.X'' ');

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
