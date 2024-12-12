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
  , IBX.IBDatabase
  , smallfunc_xe
  , unit7
  ;

procedure DropViewProcedure;
procedure AtualizaBancoDeDados(sBuild : string);
procedure RemoveValorLIVRE4(Sigla, sNovoCampo : string; IBTRANSACTION : TIBTransaction); // Mauricio Parizotto 2024-10-01
// Sandro Silva 2023-09-22  function ExecutaComando(comando:string):Boolean;

implementation

uses Unit22, Unit13, uFuncoesBancoDados, uFuncoesRetaguarda, uDialogs;


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
      //ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)'); Mauricio Parizotto 2023-10-25
      MensagemSistema('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)',msgAtencao);
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
      //ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)'); Mauricio Parizotto 2023-10-25}
      MensagemSistema('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)',msgAtencao);
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
      //ShowMessage('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)'); Mauricio Parizotto 2023-10-25
      MensagemSistema('Foi(ram) encontrado(s) objeto(s) desconhecido(s) na estrutura do banco e' + #13 + ' será(ão) excluído(s)',msgAtencao);
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
    {
    ShowMessage('Não foi possível atualizar o banco de dados.'+Chr(10)+Chr(10)+
                'Ativos: '+ IntToStr( form1.ibDataSet200.RecordCount)+Chr(10)+Chr(10)+
                ' 1 - Feche todos os programas que usam o SMALL.FDB em todos os terminais'+Chr(10)+
                ' 2 - Execute o Small Commerce novamente');
    Mauricio Parizotto 2023-10-25}
    MensagemSistema('Não foi possível atualizar o banco de dados.'+Chr(10)+Chr(10)+
                    'Ativos: '+ IntToStr( form1.ibDataSet200.RecordCount)+Chr(10)+Chr(10)+
                    ' 1 - Feche todos os programas que usam o SMALL.FDB em todos os terminais'+Chr(10)+
                    ' 2 - Execute o Small Commerce novamente'
                    ,msgAtencao);

    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName)); // Sandro Silva 2024-01-04
    Exit;
  end;

  Form22.Repaint;
  Mensagem22('Alterando estrutura do banco de dados');

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

  {Sandro Silva (f-21659) 2024-11-19 inicio
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


    // Cria o UNITARIO_O mas agora com double precision
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
  }

  if (AnsiUpperCase(TipoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O')) <> 'DOUBLE')
    or (AnsiUpperCase(TipoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL')) <> 'DOUBLE')
  then
  begin

    // Fator de conversão
    try
      // Cria UNITARIO_O_ double precision temporario
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O_') = False then
        ExecutaComando('alter table ITENS002 add UNITARIO_O_ double precision');

      // Cria QTD_ORIGINAL_ double precision temporario
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL_') = False then
        ExecutaComando('alter table ITENS002 add QTD_ORIGINAL_ double precision');

      // Grava
      ExecutaComando('commit');

      II := 99;
      try
        // Guarda UNITARIO_O e QTD_ORIGINAL nos campos temp
        //ExecutaComando('update ITENS002 set UNITARIO_O_=UNITARIO_O, QTD_ORIGINAL_=QTD_ORIGINAL');

        if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O')
          and CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL') then
        begin

          // Guarda UNITARIO_O e QTD_ORIGINAL nos campos temp
          if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O') then
            ExecutaComando('update ITENS002 set UNITARIO_O_=UNITARIO_O');
          if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL') then
            ExecutaComando('update ITENS002 set QTD_ORIGINAL_=QTD_ORIGINAL');

          // Grava
          ExecutaComando('commit');

          // Campos UNITARIO_O e QTD_ORIGINAL não estejam null
          if (ExecutaComandoEscalar(Form1.ibDataSet200.Transaction, 'select min(coalesce(UNITARIO_O, -999999)) from ITENS002') >= 0)
            and (ExecutaComandoEscalar(Form1.ibDataSet200.Transaction, 'select min(coalesce(QTD_ORIGINAL, -999999)) from ITENS002') >= 0) then
            II := 0;

        end;

      except
      end;

      // Apaga o campo original UNITARIO_O
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O') then
        ExecutaComando('alter table ITENS002 drop UNITARIO_O');

      // Apaga o campo original QTD_ORIGINAL
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL') then
        ExecutaComando('alter table ITENS002 drop QTD_ORIGINAL');

      // Grava
      ExecutaComando('commit');

      // Cria o UNITARIO_O mas agora com double precision
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O') = False then
      begin
        ExecutaComando('alter table ITENS002 add UNITARIO_O double precision');
        ExecutaComando('commit');
      end;

      // Cria o QTD_ORIGINAL mas agora com double precision
      if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL') = False then
      begin
        ExecutaComando('alter table ITENS002 add QTD_ORIGINAL double precision');
        ExecutaComando('commit');
      end;

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
    {Sandro Silva (f-21659) 2024-11-19 fim}

    // Apaga o campo temporario UNITARIO_O_
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'UNITARIO_O_') then
      ExecutaComando('alter table ITENS002 drop UNITARIO_O_');

    // Apaga o campo temporario QTD_ORIGINAL
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'QTD_ORIGINAL_') then
      ExecutaComando('alter table ITENS002 drop QTD_ORIGINAL_');

    // Grava
    ExecutaComando('commit');

  end;


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
    if ExecutaComando('alter table ITENS002 add QTD_ORIGINAL NUMERIC(18,9)')
      and ExecutaComando('alter table ITENS002 add UNITARIO_O NUMERIC(18,9)') then
    begin
      // Se conseguiu criar os 2 campos faz update
      ExecutaComando('commit');
      ExecutaComando('update ITENS002 set UNITARIO_O=UNITARIO, QTD_ORIGINAL=QUANTIDADE');
      ExecutaComando('commit');
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

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'PICMSST') = False then
    ExecutaComando('alter table ITENS002 add PICMSST NUMERIC(18, 4)');

  // GRAVAR? O HISTORICO DO CSOSN
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CSOSN') = False then
    ExecutaComando('ALTER TABLE ALTERACA ADD CSOSN VARCHAR(3)');

  {Sandro Silva (f-21659) 2024-11-19 inicio
  ExecutaComando('alter table ALTERACA add SERIE CHAR(4)');

  ExecutaComando('alter table ALTERACA add SUBSERIE CHAR(3)');

  ExecutaComando('alter table ALTERACA add CFOP CHAR(4)');
  }
  // ALTERACA NF de venda a consumidor (modelo 02)
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'SERIE') = False then
    ExecutaComando('alter table ALTERACA add SERIE CHAR(4)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'SUBSERIE') = False then
    ExecutaComando('alter table ALTERACA add SUBSERIE CHAR(3)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CFOP') = False then
    ExecutaComando('alter table ALTERACA add CFOP CHAR(4)');
  {Sandro Silva (f-21659) 2024-11-19 fim}

  // ALTERACA PIS COFINS
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CST_ICMS') = False then
    ExecutaComando('alter table ALTERACA add CST_ICMS CHAR(3)');

  {Sandro Silva (f-21659) inicio
  ExecutaComando('alter table ALTERACA add CST_PIS_COFINS VARCHAR(2)');

  ExecutaComando('alter table ALTERACA add ALIQ_PIS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add ALIQ_COFINS NUMERIC(18,4)');

  ExecutaComando('alter table ALTERACA add OBS VARCHAR(40)');

  ExecutaComando('alter table ALTERACA add STATUS VARCHAR(1)');

  ExecutaComando('alter table REDUCOES add CODIGOECF varchar(6)');
  }
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'CST_PIS_COFINS') = False then
    ExecutaComando('alter table ALTERACA add CST_PIS_COFINS VARCHAR(2)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'ALIQ_PIS') = False then
    ExecutaComando('alter table ALTERACA add ALIQ_PIS NUMERIC(18,4)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'ALIQ_COFINS') = False then
    ExecutaComando('alter table ALTERACA add ALIQ_COFINS NUMERIC(18,4)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'OBS') = False then
    ExecutaComando('alter table ALTERACA add OBS VARCHAR(40)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'STATUS') = False then
    ExecutaComando('alter table ALTERACA add STATUS VARCHAR(1)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'CODIGOECF') = False then
    ExecutaComando('alter table REDUCOES add CODIGOECF varchar(6)');
  {Sandro Silva (f-21659) 2024-11-19 fim}

  // Cancelamento extemporaneo
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'DATA_CANCEL') = False then
  begin
    ExecutaComando('alter table VENDAS add DATA_CANCEL date');
    ExecutaComando('alter table VENDAS add HORA_CANCEL varchar(8)');
    ExecutaComando('alter table VENDAS add COD_SIT varchar(2)');
    ExecutaComando('commit');
  end;

  // Informações complementares VENDA
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

  // Informações complementares COMPRAS
  Form22.Repaint;
  Mensagem22('Alterando estrutura do banco de dados... (Informações complementares COMPRAS)');

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
  Mensagem22('Alterando estrutura do banco de dados... (COMPRAS NFEID)');

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
  Mensagem22('Alterando estrutura do banco de dados... (IVA)');

  {Sandro Silva (f-21659) 2024-11-19 inicio
  try
    Mensagem22('Atualizando o campo IVA');
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
  }
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'PIVA') = False then
  begin
    try
      Mensagem22('Atualizando o campo IVA');
      ExecutaComando('alter table ESTOQUE add PIVA double precision');

      ExecutaComando('commit');

      ExecutaComando('select * from ESTOQUE where SubString(LIVRE4 from 1 for 5)='+QuotedStr('<pIVA')+' ');

      while not Form1.ibDataSet200.Eof do
      begin
        ExecutaComando('update ESTOQUE set PIVA='+  QuotedStr( StrTran(LimpaNumeroDeixandoAvirgula(Form1.ibDataSet200.FieldByname('LIVRE4').AsString),',','.')) +' where CODIGO='+QuotedStr(Form1.ibDataset200.FieldByname('CODIGO').AsString)+' ');

        Form1.ibDataset200.Moveby(1);
      end;

      ExecutaComando('update ESTOQUE set LIVRE4='+QuotedStr('')+' where substring(LIVRE4 from 1 for 5)='+QuotedStr('<pIVA')+' ');
      ExecutaComando('commit');
    except
    end;
  end;
  {Sandro Silva (f-21659) 2024-11-19 fim}

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

  // NFC-e
  Form22.Repaint;
  Mensagem22('Alterando estrutura do banco de dados... (NFC-e)');

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
  Mensagem22('Alterando estrutura do banco de dados... (PAF)');

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
  Mensagem22('Alterando estrutura do banco de dados... (SPED)');

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
  Mensagem22('Alterando estrutura do banco de dados... (vIPI)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'vIPI') = False then
    ExecutaComando('alter table ITENS001 add vIPI numeric(18,2)');

  ExecutaComando('commit');


  // SPED COMPRAS
  Form22.Repaint;
  Mensagem22('Alterando estrutura do banco de dados... (vICMS)');

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
  Mensagem22('Alterando estrutura do banco de dados... (NUMERONF)');

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
    Mensagem22('Alterando estrutura do banco de dados... (336)');
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
  Mensagem22('Alterando estrutura do banco de dados... (337)');

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

  {Sandro Silva (f-21659) 2024-11-19 inicio
  ExecutaComando('alter table OS alter PROBLEMA type varchar(128)');

  ExecutaComando('alter table ALTERACA add HORA varchar(8)');

  ExecutaComando('alter table REDUCOES add HORA varchar(8)');

  ExecutaComando('alter table ALTERACA add DAV varchar(10)');

  ExecutaComando('alter table ALTERACA add TIPODAV varchar(10)');
  }
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'OS', 'PROBLEMA') < 128 then
    ExecutaComando('alter table OS alter PROBLEMA type varchar(128)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'HORA') = False then
    ExecutaComando('alter table ALTERACA add HORA varchar(8)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'REDUCOES', 'HORA') = False then
    ExecutaComando('alter table REDUCOES add HORA varchar(8)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'DAV') = False then
    ExecutaComando('alter table ALTERACA add DAV varchar(10)');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'TIPODAV') = False then
    ExecutaComando('alter table ALTERACA add TIPODAV varchar(10)');
  {Sandro Silva (f-21659) 2024-11-19 fim}

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

  {Sandro Silva (f-21659) 2024-11-21
  ExecutaComando('alter table IBPT_ alter FONTE type varchar(30)');
  ExecutaComando('alter table IBPT_ alter FONTE type varchar(20)');

  ExecutaComando('alter table VENDEDOR alter NOME type varchar(35)');

  ExecutaComando('alter table ALTERACA alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table VENDAS alter VENDEDOR type varchar(35)');

  ExecutaComando('alter table ORCAMENT alter VENDEDOR type varchar(35)');

  }
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'IBPT_', 'FONTE') < 30 then
    ExecutaComando('alter table IBPT_ alter FONTE type varchar(30)');

  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDEDOR', 'NOME') < 35 then
    ExecutaComando('alter table VENDEDOR alter NOME type varchar(35)');
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ALTERACA', 'VENDEDOR') < 35 then
    ExecutaComando('alter table ALTERACA alter VENDEDOR type varchar(35)');
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'VENDEDOR') < 35 then
    ExecutaComando('alter table VENDAS alter VENDEDOR type varchar(35)');
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ORCAMENT', 'VENDEDOR') < 35 then
    ExecutaComando('alter table ORCAMENT alter VENDEDOR type varchar(35)');

  ExecutaComando('commit');

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'CSOSN') = False then
  begin
    if ExecutaComando('ALTER TABLE ITENS001 ADD CSOSN VARCHAR(3)') then
      ExecutaComando('commit');
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

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'MOVIMENTO') = False then
  begin
    if ExecutaComando('ALTER TABLE RECEBER ADD MOVIMENTO DATE') then // Armazena a data que o valor foi creditado na conta banco
      ExecutaComando('commit');
  end;

  if ExecutaComando('alter table RECEBER alter DOCUMENTO type varchar(11)') then // Para poder marcar as parcelas migradas da Smallsoft para Zucchetti durante a incorporação
    ExecutaComando('commit');

  {Sandro Silva (f-21659) 2024-11-21 inicio
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS') then
  begin
    if ExecutaComando('ALTER TABLE CONTAS ADD DESCRICAOCONTABIL VARCHAR(60), ADD IDENTIFICADOR VARCHAR(10), ADD CONTACONTABILIDADE VARCHAR(20)') then // Para gerar relatórios contábeis
      ExecutaComando('commit');
  end;
  }
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS') then
  begin
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS', 'DESCRICAOCONTABIL') = False then
      if ExecutaComando('ALTER TABLE CONTAS ADD DESCRICAOCONTABIL VARCHAR(60)') then // Para gerar relatórios contábeis
        ExecutaComando('commit');
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS', 'IDENTIFICADOR') = False then
      if ExecutaComando('ALTER TABLE CONTAS ADD IDENTIFICADOR VARCHAR(10)') then // Para gerar relatórios contábeis
        ExecutaComando('commit');
    if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS', 'CONTACONTABILIDADE') = False then
      if ExecutaComando('ALTER TABLE CONTAS ADD CONTACONTABILIDADE VARCHAR(20)') then // Para gerar relatórios contábeis
        ExecutaComando('commit');
  end;
  {Sandro Silva (f-21659) 2024-11-21 fim}

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

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRAS', 'VFCPST') = False then
  begin
    if ExecutaComando('alter table COMPRAS add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;

  if ExecutaComando('Update EMITENTE set CNAE = ''0''||trim(CNAE) Where char_length(trim(CNAE)) = 6') then // Mauricio Parizotto 2023-04-06
    ExecutaComando('commit');


  //Mauricio Parizotto 2023-05-08
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'EMITENTE', 'RECURSO') = False then
  begin
    if ExecutaComando('alter table EMITENTE add RECURSO BLOB SUB_TYPE TEXT') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDAS', 'VFCPST') = False then
  begin
    if ExecutaComando('alter table VENDAS add VFCPST numeric(18, 2)') then
      ExecutaComando('Commit');
  end;

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

  {Sandro Silva 2023-09-14 inicio}
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'IDX_RECEBER_ATIVO') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_RECEBER_ATIVO ON RECEBER (ATIVO)') then
      ExecutaComando('Commit');
  end;
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'IDX_RECEBER_HISTORICO') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_RECEBER_HISTORICO ON RECEBER (HISTORICO)') then
      ExecutaComando('Commit');
  end;
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONTAS', 'IDX_CONTAS_UPPER_NOME') = False then // Sandro Silva (f21659) 20240-11-21 if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'IDX_CONTAS_UPPER_NOME') = False then
  begin
    if ExecutaComando('CREATE INDEX IDX_CONTAS_UPPER_NOME ON CONTAS COMPUTED BY (upper(NOME))') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2023-09-14 fim}                                               

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
    ExecutaComando('Commit');
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
    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-08-07 Fim}


  {Mauricio Parizotto 2023-08-25 Inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CFOPCONVERSAO') = False then
  begin
    ExecutaComando('Create table CFOPCONVERSAO ('+
                   '   CFOP_ORIGEM VARCHAR(4),'+
                   '   CFOP_CONVERSAO VARCHAR(5),'+
                   '   REGISTRO VARCHAR(10) NOT NULL,'+
                   '   CONSTRAINT PK_CFOPCONVERSAO PRIMARY KEY (REGISTRO)'+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_CFOPCONVERSAO');
    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-08-25 Fim}
  

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

  {Mauricio Parizotto 2023-09-19 Inicio}
  if TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PARAMETROTRIBUTACAO') = False then
  begin
    ExecutaComando('Create table PARAMETROTRIBUTACAO('+
                   '  IDPARAMETROTRIBUTACAO INTEGER NOT NULL,'+
                   '  CFOP_ENTRADA VARCHAR(4),'+
                   '  ORIGEM_ENTRADA VARCHAR(1),'+
                   '  CST_ENTRADA VARCHAR(2),'+
                   '  CSOSN_ENTRADA VARCHAR(3),'+
                   '  ALIQ_ENTRADA NUMERIC(18,4),'+
                   '  NCM_ENTRADA VARCHAR(8),'+
                   '  IDPERFILTRIBUTACAO INTEGER NOT NULL,'+
                   '  REGISTRO VARCHAR(10) NOT NULL,'+
                   '  CONSTRAINT PK_PARAMETROTRIBUTACAO PRIMARY KEY (REGISTRO)'+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_PARAMETROTRIBUTACAO');
    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-09-19 Fim}
  
  {Dailon Parisotto 2023-09-12 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ORCAMENTOBS')) then
  begin
    ExecutaComando('CREATE TABLE ORCAMENTOBS ('+
                   ' 	PEDIDO VARCHAR(10) NOT NULL,'+
                   ' 	OBS BLOB SUB_TYPE 1 SEGMENT SIZE 80,'+
                   ' 	REGISTRO VARCHAR(10) NOT NULL,'+
                   ' 	CONSTRAINT PK_ORCAMENTOBS_REGISTRO PRIMARY KEY (REGISTRO)'+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_ORCAMENTOBS_REGISTRO');

    ExecutaComando('Commit');
  end;
  {Dailon Parisotto 2023-09-12 Fim}

  {Mauricio Parizotto 2023-09-19 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'VALOR_MULTA') = False then
  begin
    if ExecutaComando('alter table RECEBER add VALOR_MULTA numeric (18,2)') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'PERCENTUAL_MULTA') = False then
  begin
    if ExecutaComando('alter table RECEBER add PERCENTUAL_MULTA numeric (18,2)') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-09-29 Fim}

  {Sandro Silva 2024-04-01 inicio}
  if TamanhoCampoFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'RECEBER', 'NN') = 10 then
  begin
    if ExecutaComando('alter table RECEBER alter NN type varchar(11) character set none') then
      ExecutaComando('Commit');
  end;
  {Sandro Silva 2024-04-01 final}

  {Mauricio Parizotto 2023-11-15 Inicio}
  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'OS', 'PROBLEMA') < 1000 then
  begin
    if ExecutaComando(' ALTER TABLE OS ALTER COLUMN PROBLEMA TYPE VARCHAR(1000) ') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-11-15 Fim}

  {Mauricio Parizotto 2023-11-20 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONFIGURACAOSISTEMA')) then
  begin
    ExecutaComando('CREATE TABLE CONFIGURACAOSISTEMA ('+
                   ' 	IDCONFIGURACAOSISTEMA INTEGER NOT NULL,'+
                   ' 	NOME VARCHAR(30) NOT NULL,'+
                   ' 	MODULO VARCHAR(20) NOT NULL,'+
                   ' 	VALOR BLOB SUB_TYPE TEXT,'+
                   '  DESCRICAO VARCHAR(100),'+
                   '  CONSTRAINT PK_CONFIGURACAOSISTEMA PRIMARY KEY (IDCONFIGURACAOSISTEMA)'+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_CONFIGURACAOSISTEMA');

    ExecutaComando('Commit');
  end;

  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'OS', 'OBSERVACAO') < 1000 then
  begin
    if ExecutaComando(' ALTER TABLE OS ALTER COLUMN OBSERVACAO TYPE VARCHAR(1000) ') then
      ExecutaComando('Commit');
  end;

  {Mauricio Parizotto 2023-11-20 Fim}



  {Mauricio Parizotto 2023-12-04 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'OSSITUACAO')) then
  begin
    ExecutaComando('CREATE TABLE OSSITUACAO ('+
                   ' 	IDSITUACAO INTEGER NOT NULL,'+
                   '  SITUACAO VARCHAR(25),'+
                   '  CONSTRAINT PK_OSSITUACAO_IDSITUACAO PRIMARY KEY (IDSITUACAO)'+
                   ')');

    ExecutaComando('CREATE SEQUENCE G_OSSITUACAO');

    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-12-04 Fim}

  {Mauricio Parizotto 2023-11-29 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'OS', 'IDOS') = False then
  begin
    if ExecutaComando('ALTER TABLE OS ADD IDOS INTEGER') then
    begin
      ExecutaComando('Commit');
      //ExecutaComando('UPDATE OS SET IDOS = cast(REGISTRO as integer)'); Mauricio Parizotto 2024-06-10
    end;
  end;

  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'OSANEXOS')) then
  begin
    ExecutaComando(' Create table OSANEXOS ('+
                   ' 	 IDANEXO INTEGER NOT NULL,'+
                   ' 	 IDOS INTEGER NOT NULL,'+
                   ' 	 NOME VARCHAR(100) NOT NULL,'+
                   ' 	 ANEXO BLOB SUB_TYPE TEXT NOT NULL,'+
                   ' 	 CONSTRAINT PK_OSANEXOS_IDANEXO PRIMARY KEY(IDANEXO)'+
                   ' )');

    ExecutaComando('CREATE SEQUENCE G_OSANEXOS');

    ExecutaComando('Commit');

    ExecutaComando('CREATE SEQUENCE G_OSIDOS');

    ExecutaComando('Commit');

    ExecutaComando('UPDATE OS SET IDOS = (select gen_id(G_OSIDOS,1) from rdb$database)');

    ExecutaComando('Commit');

    ExecutaComando('CREATE UNIQUE INDEX OS_IDOS_IDX ON OS (IDOS);');
  end;
  {Mauricio Parizotto 2023-11-29 Fim}
  
  {Mauricio Parizotto 2023-12-11 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'CBENEF') = False then
  begin
    if ExecutaComando('alter table ICM add CBENEF varchar(10)') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-12-11 Fim}


  {Mauricio Parizotto 2023-12-26 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'OS', 'NFSE') = False then
  begin
    if ExecutaComando('alter table OS add NFSE varchar(12)') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2023-12-26 Fim}

  {Mauricio Parizotto 2024-02-05 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'FORMATOBOLETO') = False then
  begin
    if ExecutaComando('alter table BANCOS add FORMATOBOLETO varchar(10)') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-02-05 Fim}
  
  {Mauricio Parizotto 2024-02-19 Inicio}
  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'AUDIT0RIA', 'HISTORICO') < 1000 then
  begin
    if ExecutaComando('ALTER TABLE AUDIT0RIA ALTER COLUMN HISTORICO TYPE VARCHAR(1000);') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-02-19 Fim}


  {Mauricio Parizotto 2024-02-28 Inicio}
  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'CODEBAR', 'EAN') < 60 then
  begin
    if ExecutaComando('ALTER TABLE CODEBAR ALTER COLUMN EAN TYPE VARCHAR(60);') then
      ExecutaComando('Commit');
  end;

  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'ITENS002', 'EAN_ORIGINAL') < 60 then
  begin
    if ExecutaComando('ALTER TABLE ITENS002 ALTER COLUMN EAN_ORIGINAL TYPE VARCHAR(60);') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-02-28 Fim}

  {Mauricio Parizotto 2024-03-28 Inicio}
  if not CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'PISCOFINSLUCRO') then
  begin
    if ExecutaComando('Alter table ICM add PISCOFINSLUCRO varchar(1);') then
      ExecutaComando('Commit');

    if ExecutaComando('Update ICM set PISCOFINSLUCRO = ''N'' ;') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-03-28 Fim}

  (* Sandro Silva 2024-04-11 Estava causando access violation quando atualiza e em seguida cadastra um produto com 120 caracteres
  {Dailon Parisotto (f-17787) 2024-03-27 Inicio}
  try
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Clear;
    Form1.ibDataSet200.SelectSQL.Text :=
      'SELECT COALESCE(ESTADO,''SC'') AS ESTADO FROM EMITENTE';
    Form1.ibDataSet200.Open;

    if (AnsiUpperCase(Form1.ibDataSet200.FieldByName('ESTADO').AsString) <> 'SC') and (Form1.ibDataSet200.FieldByName('ESTADO').AsString <> EmptyStr) then // Sandro Silva 2024-04-09 if (Form1.ibDataSet200.FieldByName('ESTADO').AsString <> 'SC') and (Form1.ibDataSet200.FieldByName('ESTADO').AsString <> EmptyStr) then
      Form1.Comandos120CaracteresProd;
  finally
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Clear;
  end;
  {Dailon Parisotto (f-17787) 2024-03-27 Fim}
  *)

  {Sandro Silva 2024-04-23 inicio}
  // Nas NFS-e, o campo MARCA é usado para controlar se a nota tem retenção de ISS (I) ou IRRF (F)
  // Existem notas de serviços lançadas com o campo MARCA preenchido com texto incorreto, gerado pela rotina de vendas de NFS-e
  // Comandos abaixo corrigem as situações detectadas
  //-- Troca "(F)(F)" para "(F)"
  if ExecutaComando('update VENDAS set ' +
    'MARCA = replace(replace(MARCA, ''(F)(F)'', ''(F)''), ''(('', ''('') ' +
    'where MODELO = ''SV'' ' +
    ' and MARCA is not null') then
    ExecutaComando('Commit');

  //-- Troca "(I)(I)" para "(I)", elimina "(("
  if ExecutaComando('update VENDAS set ' +
    'MARCA = replace(replace(MARCA, ''(I)(I)'', ''(I)''), ''(('', ''('') ' +
    'where MODELO = ''SV'' ' +
    'and MARCA is not null') then
    ExecutaComando('Commit');

  //-- Elimina "(" quando ficar no final do texto salvo no campo Ex.: VARIAS(I)(
  if ExecutaComando('update VENDAS set ' +
    'MARCA = substring(trim(MARCA) from 1 for (char_length(trim(MARCA)) -1)) ' +
    'where MODELO = ''SV'' ' +
    'and substring(trim(MARCA) from char_length(trim(MARCA)) for 1) = ''('' ') then
    ExecutaComando('Commit');
  {Sandro Silva 2024-04-23 fim}


  {Mauricio Parizotto 2024-03-22 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CFOPCONVERSAO', 'CONSIDERACSTCSOSN') = False then
  begin
    if ExecutaComando('Alter table CFOPCONVERSAO add CONSIDERACSTCSOSN VARCHAR(1);') then
      ExecutaComando('Commit');

    if ExecutaComando('Update CFOPCONVERSAO set CONSIDERACSTCSOSN = ''N'';') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CFOPCONVERSAO', 'CST') = False then
  begin
    if ExecutaComando('Alter table CFOPCONVERSAO add CST VARCHAR(2);') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CFOPCONVERSAO', 'CSOSN') = False then
  begin
    if ExecutaComando('Alter table CFOPCONVERSAO add CSOSN VARCHAR(3);') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-03-22 Fim}
  
  {Mauricio Parizotto 2024-04-12 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CLIFOR', 'CONTRIBUINTE') = False then
  begin
    if ExecutaComando('Alter table CLIFOR add CONTRIBUINTE integer;') then
    begin
      ExecutaComando('comment on column CLIFOR.CONTRIBUINTE is ''1 = Contribuinte, 2 = Isento, 9 = Não Contribuinte'';');
      ExecutaComando('Commit');
    end;
  end;
  {Mauricio Parizotto 2024-04-12 Fim}

  {Mauricio Parizotto 2024-04-22 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'IPISOBREOUTRA') = False then
  begin
    if ExecutaComando('Alter table ICM add IPISOBREOUTRA varchar(1);') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-04-22 Fim}

  {Mauricio Parizotto 2024-06-21 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'REFERENCIANOTA') = False then
  begin
    if ExecutaComando('Alter table ICM add REFERENCIANOTA VARCHAR(1);') then
      ExecutaComando('Commit');

    if ExecutaComando('Update ICM set REFERENCIANOTA = ''N'' ') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-06-21 Fim}


  {Mauricio Parizotto 2024-04-29 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'PIXESTATICO') = False then
  begin
    if ExecutaComando('Alter table BANCOS add PIXESTATICO VARCHAR(1);') then
    begin
      ExecutaComando('Commit');
      ExecutaComando('Update BANCOS SET PIXESTATICO = ''N'';');
      ExecutaComando('Commit');
    end;
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'PIXTIPOCHAVE') = False then
  begin
    if ExecutaComando('Alter table BANCOS add PIXTIPOCHAVE VARCHAR(20);') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'PIXTITULAR') = False then
  begin
    if ExecutaComando('Alter table BANCOS add PIXTITULAR VARCHAR(25);') then
      ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'PIXCHAVE') = False then
  begin
    if ExecutaComando('Alter table BANCOS add PIXCHAVE VARCHAR(40);') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-04-29 Fim}
  
  {Mauricio Parizotto 2024-06-27 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CLIFOR', 'PRODUTORRURAL') = False then
  begin
    if ExecutaComando('Alter table CLIFOR add PRODUTORRURAL varchar(1);') then
      ExecutaComando('Commit');

    if ExecutaComando('Update CLIFOR set PRODUTORRURAL = ''N'' ;') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-06-27 Fim}

  {Mauricio Parizotto 2024-06-10 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'BANCOS', 'IDBANCO') = False then
  begin
    if ExecutaComando('ALTER TABLE BANCOS ADD IDBANCO INTEGER') then
    begin
      ExecutaComando('Commit');

      ExecutaComando('CREATE SEQUENCE G_BANCOSIDBANCO');

      ExecutaComando('UPDATE BANCOS SET IDBANCO = (select gen_id(G_BANCOSIDBANCO,1) from rdb$database)');

      ExecutaComando('Commit');

      ExecutaComando('CREATE UNIQUE INDEX BANCOS_IDBANCO_IDX ON BANCOS (IDBANCO)');

      ExecutaComando('Commit');
    end;
  end;

  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONFIGURACAOITAU')) then
  begin
    ExecutaComando(' Create table CONFIGURACAOITAU('+
                   ' 	 IDCONFIGURACAOITAU integer NOT NULL,'+
                   ' 	 IDBANCO integer,'+
                   ' 	 HABILITADO VARCHAR(1),'+
                   ' 	 USUARIO VARCHAR(100),'+
                   ' 	 SENHA VARCHAR(100),'+
                   ' 	 CLIENTID VARCHAR(300),'+
                   ' 	 CONSTRAINT PK_CONFIGURACAOITAU PRIMARY KEY(IDCONFIGURACAOITAU)'+
                   ' )');

    ExecutaComando('CREATE SEQUENCE G_CONFIGURACAOITAU');

    ExecutaComando('Commit');
  end;


  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITAUTRANSACAO')) then
  begin
    ExecutaComando(' Create table ITAUTRANSACAO('+
                   '   IDTRANSACAO integer NOT NULL,'+
                   '   NUMERONF varchar(6),'+
                   '   CAIXA varchar(3),'+
                   '   ORDERID varchar(40),'+
                   '   DATAHORA timestamp,'+
                   '   STATUS varchar(12),'+
                   '   VALOR numeric(18,2),'+
                   '   CODIGOAUTORIZACAO varchar(40), '+
                   '   CNPJINSTITUICAO varchar(19), '+
                   '   CONSTRAINT PK_ITAUTRANSACAO PRIMARY KEY (IDTRANSACAO)'+
                   ' )');

    ExecutaComando('CREATE SEQUENCE G_ITAUTRANSACAO');

    ExecutaComando('CREATE INDEX ITAUTRANSACAOORDERID ON ITAUTRANSACAO (ORDERID);');

    ExecutaComando('Commit');
  end;


  {Mauricio Parizotto 2024-06-10 Fim}

  {Mauricio Parizotto 204-07-10 Inicio}
  if ExecutaComando(' Update RECEBER'+
                    '  set FORMADEPAGAMENTO = ''Pagamento Instantâneo (PIX) Estático''  '+
                    ' Where FORMADEPAGAMENTO = ''Pagamento Instantâneo (PIX)'' ') then
      ExecutaComando('Commit');
  {Mauricio Parizotto 204-07-10 Fim}
  
  
  {Mauricio Parizotto 2024-07-23 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'IMPOSTOMANUAL') = False then
  begin
    if ExecutaComando('Alter table ICM add IMPOSTOMANUAL VARCHAR(1);') then
      ExecutaComando('Commit');

    if ExecutaComando('Update ICM set IMPOSTOMANUAL = ''N'' ') then
      ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-07-23 Fim}

  {Dailon Parisotto 2024-08-22 Inicio}
  try
    {Sandro Silva 2024-09-19 inicio
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Clear;
    Form1.ibDataSet200.SelectSQL.Add('SELECT I.RDB$INDEX_NAME AS INDICENAME');
    Form1.ibDataSet200.SelectSQL.Add('FROM RDB$INDEX_SEGMENTS S');
    Form1.ibDataSet200.SelectSQL.Add('INNER JOIN RDB$INDICES I');
    Form1.ibDataSet200.SelectSQL.Add('    ON (I.RDB$INDEX_NAME=S.RDB$INDEX_NAME)');
    Form1.ibDataSet200.SelectSQL.Add('    AND (I.RDB$RELATION_NAME=''ITENS002'')');
    Form1.ibDataSet200.SelectSQL.Add('WHERE (S.RDB$FIELD_NAME=''CODIGO'')');
    Form1.ibDataSet200.Open;

    if (Trim(Form1.ibDataSet200.FieldByName('INDICENAME').AsString) = EmptyStr) then
    begin
      ExecutaComando('CREATE INDEX IDX_ITENS002_CODIGO ON ITENS002 (CODIGO);');

      ExecutaComando('Commit');
    end;
    }
    if (IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS002', 'IDX_ITENS002_CODIGO') = False) then
    begin
      ExecutaComando('CREATE INDEX IDX_ITENS002_CODIGO ON ITENS002 (CODIGO);');

      ExecutaComando('Commit');
    end;
    {Sandro Silva 2024-09-19 fim}
  finally
    Form1.ibDataSet200.Close;
    Form1.ibDataSet200.SelectSQL.Clear;
  end;
  {Dailon Parisotto 2024-08-22 Fim}

  {Mauricio Parizotto 2024-08-21 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'FORMAPAGAMENTO')) then
  begin
    ExecutaComando(' CREATE TABLE FORMAPAGAMENTO ('+
                   ' 	IDFORMA INTEGER NOT NULL,'+
                   ' 	CODIGO_TPAG VARCHAR(2),'+
                   ' 	DESCRICAO VARCHAR(60),'+
                   ' 	CONSTRAINT PK_FORMAPAGAMENTO PRIMARY KEY (IDFORMA)'+
                   ' );');

    ExecutaComando('Commit');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(1,''01'',''Dinheiro'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(2,''02'',''Cheque'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(3,''03'',''Cartão de Crédito'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(4,''04'',''Cartão de Débito'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(5,''05'',''Crédito de Loja'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(6,''10'',''Vale Alimentação'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(7,''11'',''Vale Refeição'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(8,''12'',''Vale Presente'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(9,''13'',''Vale Combustível'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(10,''14'',''Duplicata Mercantil'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(11,''15'',''Boleto Bancário'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(12,''16'',''Depósito Bancário'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(13,''17'',''Pagamento Instantâneo (PIX) Dinâmico'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                  ' Values(14,''18'',''Transfer.bancária, Carteira Digital'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(15,''19'',''Progr.de fidelidade, Cashback, Crédito Virtual'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(16,''20'',''Pagamento Instantâneo (PIX) Estático'')');

    ExecutaComando(' Insert Into FORMAPAGAMENTO(IDFORMA,CODIGO_TPAG,DESCRICAO)'+
                   ' Values(17,''99'',''Outros'')');

    ExecutaComando('Commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAGAMENT', 'IDFORMA') = False then
  begin
    ExecutaComando('Alter table PAGAMENT add IDFORMA int;');
    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-08-21 Fim}

  {Sandro Silva 2024-09-02 inicio}
  // Generator para sequencial do número do lote de NFSe. Inicialmente usao para padrão SYSTEM, prefeitura Erechim - RS
  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase,'G_LOTENFSE') = False then
  begin
    if ExecutaComando('CREATE SEQUENCE G_LOTENFSE') then
      ExecutaComando('commit');
  end;
  {Sandro Silva 2024-09-02 fim}

  {Dailon Parisotto (smal-653) 2024-08-26 Inicio}
  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'ICM', 'NOME') < 60 then
  begin
    ExecutaComando('alter table ICM alter NOME type varchar(60)');
    ExecutaComando('alter table VENDAS alter OPERACAO type varchar(60)');
    ExecutaComando('alter table COMPRAS alter OPERACAO type varchar(60)');

    ExecutaComando('commit');
  end;
  {Dailon Parisotto (smal-653) 2024-08-26 Fim}

  {Mauricio Parizotto 2024-09-04 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'CONFIGURACAOSICOOB')) then
  begin
    ExecutaComando(' CREATE TABLE CONFIGURACAOSICOOB ('+
                   ' 	 IDCONFIGURACAOSICOOB INTEGER NOT NULL,'+
                   ' 	 IDBANCO INTEGER,'+
                   ' 	 HABILITADO VARCHAR(1),	'+
                   ' 	 IDAPIPIX INTEGER,'+
                   ' 	 CLIENTIDPIX VARCHAR(100), '+
                   ' 	 CLIENTIDBOLETO VARCHAR(100), '+
                   ' 	 CERTIFICADO BLOB SUB_TYPE TEXT,'+
                   ' 	 CERTIFICADONOME VARCHAR(80), '+
                   ' 	 CERTIFICADOSENHA VARCHAR(200), '+
                   ' 	 CONSTRAINT PK_CONFIGURACAOSICOOB PRIMARY KEY (IDCONFIGURACAOSICOOB)'+
                   ' );');

  end;

  if TamanhoCampo(Form1.ibDataSet200.Transaction, 'RECEBER', 'AUTORIZACAOTRANSACAO') = 20 then
  begin
    ExecutaComando('alter table RECEBER alter AUTORIZACAOTRANSACAO type varchar(128)');
  end;

  {Mauricio Parizotto 2024-09-04 Fim}
  {Mauricio Parizotto 2024-09-09 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'IDESTOQUE') = False then
  begin
    if ExecutaComando('ALTER TABLE ESTOQUE ADD IDESTOQUE INTEGER') then
    begin
      ExecutaComando('Commit');

      ExecutaComando('CREATE SEQUENCE G_ESTOQUEIDESTOQUE');

      ExecutaComando('UPDATE ESTOQUE SET IDESTOQUE = (select gen_id(G_ESTOQUEIDESTOQUE,1) from rdb$database)');

      ExecutaComando('Commit');

      ExecutaComando('CREATE UNIQUE INDEX ESTOQUE_IDESTOQUE_IDX ON ESTOQUE (IDESTOQUE)');

      ExecutaComando('Commit');
    end;
  end;

  {Sandro Silva (f-21199) 2024-10-23 inicio}
  if IndiceExiste(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'ESTOQUE_IDESTOQUE_IDX') then
  begin
    // Padronizar nomeclatura dos índices. Sempre começar com prefixo IDX_, seguido pelo nome da tabela mai o caractere "_", na sequencia o nome dos campos que compõem o índice
    ExecutaComando('DROP INDEX ESTOQUE_IDESTOQUE_IDX');
    ExecutaComando('Commit');

    ExecutaComando('CREATE UNIQUE INDEX IDX_ESTOQUE_IDESTOQUE ON ESTOQUE (IDESTOQUE)');
  end;
  {Sandro Silva (f-21199) 2024-10-23 fim}

  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUEIVA')) then
  begin
    ExecutaComando(' Create table ESTOQUEIVA('+
                   ' 	 IDESTOQUEIVA INTEGER NOT NULL,'+
                   ' 	 IDESTOQUE INTEGER NOT NULL,'+
                   ' 	 AC_ DECIMAL(18,4),'+
                   ' 	 AL_ DECIMAL(18,4),'+
                   ' 	 AP_ DECIMAL(18,4),'+
                   ' 	 AM_ DECIMAL(18,4),'+
                   ' 	 BA_ DECIMAL(18,4),'+
                   ' 	 CE_ DECIMAL(18,4),'+
                   ' 	 DF_ DECIMAL(18,4),'+
                   ' 	 ES_ DECIMAL(18,4),'+
                   ' 	 GO_ DECIMAL(18,4),'+
                   ' 	 MA_ DECIMAL(18,4),'+
                   ' 	 MT_ DECIMAL(18,4),'+
                   ' 	 MS_ DECIMAL(18,4),'+
                   ' 	 MG_ DECIMAL(18,4),'+
                   ' 	 PA_ DECIMAL(18,4),'+
                   ' 	 PB_ DECIMAL(18,4),'+
                   ' 	 PR_ DECIMAL(18,4),'+
                   ' 	 PE_ DECIMAL(18,4),'+
                   ' 	 PI_ DECIMAL(18,4),'+
                   ' 	 RJ_ DECIMAL(18,4),'+
                   ' 	 RN_ DECIMAL(18,4),'+
                   ' 	 RS_ DECIMAL(18,4),'+
                   ' 	 RO_ DECIMAL(18,4),'+
                   ' 	 RR_ DECIMAL(18,4),'+
                   ' 	 SC_ DECIMAL(18,4),'+
                   ' 	 SP_ DECIMAL(18,4),'+
                   ' 	 SE_ DECIMAL(18,4),'+
                   ' 	 TO_ DECIMAL(18,4),'+
                   ' 	 CONSTRAINT PK_ESTOQUEIVA PRIMARY KEY (IDESTOQUEIVA)'+
                   ' )');

    ExecutaComando('Commit');

    if ExecutaComando('CREATE SEQUENCE G_ESTOQUEIVAIDESTOQUEIVA') then
      ExecutaComando('commit');
  end;

  {Mauricio Parizotto 2024-09-09 Fim}
  
  {Dailon Parisotto (smal-706) 2024-09-18 Inicio}
  if (not CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ITENS001', 'DRAWBACK')) then
  begin
    ExecutaComando('ALTER TABLE ITENS001 ADD DRAWBACK VARCHAR(11);');

    ExecutaComando('Commit');
  end;

  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'VENDASEXPORTACAO')) then
  begin
    ExecutaComando('CREATE TABLE VENDASEXPORTACAO ('+
                   '    IDVENDASEXPORTACAO INTEGER NOT NULL,'+
                   '    NUMERONF VARCHAR(12),'+
                   '    IDPAISES INTEGER,'+
                   '    UFEMBARQUE VARCHAR(2),'+
                   '    LOCALEMBARQUE VARCHAR(60),'+
                   '    RECINTOALFANDEGARIO VARCHAR(60),'+
                   '    IDENTESTRANGEIRO VARCHAR(50),'+
                   '    CONSTRAINT PK_VENDASEXPORTACAO PRIMARY KEY (IDVENDASEXPORTACAO)'+
                   ' );');

    ExecutaComando('Commit');

    ExecutaComando('CREATE SEQUENCE G_VENDASEXPORTACAO');

    ExecutaComando('Commit');
  end;

  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'PAISES')) then
  begin
    ExecutaComando(' CREATE TABLE PAISES ('+
                   '   IDPAISES INTEGER NOT NULL,'+
                   '   CODIGO INTEGER,'+
                   '   NOME VARCHAR(80),'+
                   '   CONSTRAINT PK_PAISES PRIMARY KEY (IDPAISES)'+
                   ' );');

    ExecutaComando('Commit');

    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (1,132,'+QuotedStr('AFEGANISTAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (2,7560,'+QuotedStr('AFRICA DO SUL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (3,153,'+QuotedStr('ALAND, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (4,175,'+QuotedStr('ALBANIA, REPUBLICA  DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (5,230,'+QuotedStr('ALEMANHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (6,370,'+QuotedStr('ANDORRA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (7,400,'+QuotedStr('ANGOLA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (8,418,'+QuotedStr('ANGUILLA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (9,420,'+QuotedStr('ANTARTICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (10,434,'+QuotedStr('ANTIGUA E BARBUDA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (11,531,'+QuotedStr('ARABIA SAUDITA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (12,590,'+QuotedStr('ARGELIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (13,639,'+QuotedStr('ARGENTINA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (14,647,'+QuotedStr('ARMENIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (15,655,'+QuotedStr('ARUBA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (16,698,'+QuotedStr('AUSTRALIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (17,728,'+QuotedStr('AUSTRIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (18,736,'+QuotedStr('AZERBAIJAO, REPUBLICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (19,779,'+QuotedStr('BAHAMAS, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (20,809,'+QuotedStr('BAHREIN, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (21,817,'+QuotedStr('BANGLADESH') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (22,833,'+QuotedStr('BARBADOS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (23,850,'+QuotedStr('BELARUS, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (24,876,'+QuotedStr('BELGICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (25,884,'+QuotedStr('BELIZE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (26,2291,'+QuotedStr('BENIN') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (27,906,'+QuotedStr('BERMUDAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (28,973,'+QuotedStr('BOLIVIA, ESTADO PLURINACIONAL DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (29,990,'+QuotedStr('BONAIRE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (30,981,'+QuotedStr('BOSNIA-HERZEGOVINA (REPUBLICA DA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (31,1015,'+QuotedStr('BOTSUANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (32,1023,'+QuotedStr('BOUVET, ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (33,1058,'+QuotedStr('BRASIL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (34,1082,'+QuotedStr('BRUNEI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (35,1112,'+QuotedStr('BULGARIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (36,310,'+QuotedStr('BURKINA FASO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (37,1155,'+QuotedStr('BURUNDI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (38,1198,'+QuotedStr('BUTAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (39,1279,'+QuotedStr('CABO VERDE, REPUBLICA DE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (40,1457,'+QuotedStr('CAMAROES') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (41,1414,'+QuotedStr('CAMBOJA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (42,1490,'+QuotedStr('CANADA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (43,1546,'+QuotedStr('CATAR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (44,1376,'+QuotedStr('CAYMAN, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (45,1538,'+QuotedStr('CAZAQUISTAO, REPUBLICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (46,7889,'+QuotedStr('CHADE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (47,1589,'+QuotedStr('CHILE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (48,1600,'+QuotedStr('CHINA, REPUBLICA POPULAR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (49,1635,'+QuotedStr('CHIPRE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (50,5118,'+QuotedStr('CHRISTMAS,ILHA (NAVIDAD)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (51,7412,'+QuotedStr('CINGAPURA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (52,1651,'+QuotedStr('COCOS(KEELING),ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (53,1694,'+QuotedStr('COLOMBIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (54,1732,'+QuotedStr('COMORES, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (55,1775,'+QuotedStr('CONGO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (56,8885,'+QuotedStr('CONGO, REPUBLICA DEMOCRATICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (57,1830,'+QuotedStr('COOK, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (58,1872,'+QuotedStr('COREIA (DO NORTE), REP.POP.DEMOCRATICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (59,1902,'+QuotedStr('COREIA (DO SUL), REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (60,1937,'+QuotedStr('COSTA DO MARFIM') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (61,1961,'+QuotedStr('COSTA RICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (62,1988,'+QuotedStr('COVEITE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (63,1953,'+QuotedStr('CROACIA (REPUBLICA DA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (64,1996,'+QuotedStr('CUBA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (65,2003,'+QuotedStr('CURACAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (66,2321,'+QuotedStr('DINAMARCA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (67,7838,'+QuotedStr('DJIBUTI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (68,2356,'+QuotedStr('DOMINICA,ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (69,2402,'+QuotedStr('EGITO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (70,6874,'+QuotedStr('EL SALVADOR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (71,2445,'+QuotedStr('EMIRADOS ARABES UNIDOS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (72,2399,'+QuotedStr('EQUADOR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (73,2437,'+QuotedStr('ERITREIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (74,2470,'+QuotedStr('ESLOVACA, REPUBLICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (75,2461,'+QuotedStr('ESLOVENIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (76,2453,'+QuotedStr('ESPANHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (77,7544,'+QuotedStr('ESSUATINI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (78,2496,'+QuotedStr('ESTADOS UNIDOS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (79,2518,'+QuotedStr('ESTONIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (80,2534,'+QuotedStr('ETIOPIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (81,2550,'+QuotedStr('FALKLAND (ILHAS MALVINAS)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (82,2593,'+QuotedStr('FEROE, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (83,8702,'+QuotedStr('FIJI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (84,2674,'+QuotedStr('FILIPINAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (85,2712,'+QuotedStr('FINLANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (86,1619,'+QuotedStr('FORMOSA (TAIWAN)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (87,2755,'+QuotedStr('FRANCA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (88,2810,'+QuotedStr('GABAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (89,2852,'+QuotedStr('GAMBIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (90,2895,'+QuotedStr('GANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (91,2917,'+QuotedStr('GEORGIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (92,2933,'+QuotedStr('GIBRALTAR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (93,2976,'+QuotedStr('GRANADA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (94,3018,'+QuotedStr('GRECIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (95,3050,'+QuotedStr('GROENLANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (96,3093,'+QuotedStr('GUADALUPE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (97,3131,'+QuotedStr('GUAM') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (98,3174,'+QuotedStr('GUATEMALA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (99,3212,'+QuotedStr('GUERNSEY, ILHA DO CANAL (INCLUI ALDERNEY E SARK)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (100,3379,'+QuotedStr('GUIANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (101,3255,'+QuotedStr('GUIANA FRANCESA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (102,3298,'+QuotedStr('GUINE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (103,3344,'+QuotedStr('GUINE-BISSAU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (104,3310,'+QuotedStr('GUINE-EQUATORIAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (105,3417,'+QuotedStr('HAITI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (106,3450,'+QuotedStr('HONDURAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (107,3514,'+QuotedStr('HONG KONG') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (108,3557,'+QuotedStr('HUNGRIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (109,3573,'+QuotedStr('IEMEN') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (110,3433,'+QuotedStr('ILHA HEARD E ILHAS MCDONALD') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (111,2925,'+QuotedStr('ILHAS GEORGIA DO SUL E SANDWICH DO SUL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (112,3611,'+QuotedStr('INDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (113,3654,'+QuotedStr('INDONESIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (114,3727,'+QuotedStr('IRA, REPUBLICA ISLAMICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (115,3697,'+QuotedStr('IRAQUE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (116,3751,'+QuotedStr('IRLANDA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (117,3794,'+QuotedStr('ISLANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (118,3832,'+QuotedStr('ISRAEL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (119,3867,'+QuotedStr('ITALIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (120,3913,'+QuotedStr('JAMAICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (121,3999,'+QuotedStr('JAPAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (122,3930,'+QuotedStr('JERSEY, ILHA DO CANAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (123,4030,'+QuotedStr('JORDANIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (124,4111,'+QuotedStr('KIRIBATI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (125,1988,'+QuotedStr('KUWAIT') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (126,4200,'+QuotedStr('LAOS, REP.POP.DEMOCR.DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (127,4260,'+QuotedStr('LESOTO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (128,4278,'+QuotedStr('LETONIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (129,4316,'+QuotedStr('LIBANO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (130,4340,'+QuotedStr('LIBERIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (131,4383,'+QuotedStr('LIBIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (132,4405,'+QuotedStr('LIECHTENSTEIN') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (133,4421,'+QuotedStr('LITUANIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (134,4456,'+QuotedStr('LUXEMBURGO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (135,4472,'+QuotedStr('MACAU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (136,4499,'+QuotedStr('MACEDONIA DO NORTE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (137,4499,'+QuotedStr('MACEDONIA, ANT.REP.IUGOSLAVA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (138,4502,'+QuotedStr('MADAGASCAR') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (139,4553,'+QuotedStr('MALASIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (140,4588,'+QuotedStr('MALAVI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (141,4618,'+QuotedStr('MALDIVAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (142,4642,'+QuotedStr('MALI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (143,4677,'+QuotedStr('MALTA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (144,3595,'+QuotedStr('MAN, ILHA DE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (145,4723,'+QuotedStr('MARIANAS DO NORTE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (146,4740,'+QuotedStr('MARROCOS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (147,4766,'+QuotedStr('MARSHALL,ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (148,4774,'+QuotedStr('MARTINICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (149,4855,'+QuotedStr('MAURICIO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (150,4880,'+QuotedStr('MAURITANIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (151,4898,'+QuotedStr('MAYOTTE (ILHAS FRANCESAS)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (152,4936,'+QuotedStr('MEXICO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (153,930,'+QuotedStr('MIANMAR (BIRMANIA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (154,4995,'+QuotedStr('MICRONESIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (155,5053,'+QuotedStr('MOCAMBIQUE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (156,4944,'+QuotedStr('MOLDAVIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (157,4952,'+QuotedStr('MONACO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (158,4979,'+QuotedStr('MONGOLIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (159,4985,'+QuotedStr('MONTENEGRO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (160,5010,'+QuotedStr('MONTSERRAT,ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (161,5070,'+QuotedStr('NAMIBIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (162,5088,'+QuotedStr('NAURU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (163,5177,'+QuotedStr('NEPAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (164,5215,'+QuotedStr('NICARAGUA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (165,5258,'+QuotedStr('NIGER') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (166,5282,'+QuotedStr('NIGERIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (167,5312,'+QuotedStr('NIUE,ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (168,5355,'+QuotedStr('NORFOLK,ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (169,5380,'+QuotedStr('NORUEGA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (170,5428,'+QuotedStr('NOVA CALEDONIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (171,5487,'+QuotedStr('NOVA ZELANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (172,5568,'+QuotedStr('OMA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (173,5665,'+QuotedStr('PACIFICO,ILHAS DO (POSSESSAO DOS EUA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (174,5738,'+QuotedStr('PAISES BAIXOS (HOLANDA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (175,5754,'+QuotedStr('PALAU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (176,5780,'+QuotedStr('PALESTINA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (177,5800,'+QuotedStr('PANAMA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (178,5452,'+QuotedStr('PAPUA NOVA GUINE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (179,5762,'+QuotedStr('PAQUISTAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (180,5860,'+QuotedStr('PARAGUAI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (181,5894,'+QuotedStr('PERU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (182,5932,'+QuotedStr('PITCAIRN,ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (183,5991,'+QuotedStr('POLINESIA FRANCESA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (184,6033,'+QuotedStr('POLONIA, REPUBLICA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (185,6114,'+QuotedStr('PORTO RICO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (186,6076,'+QuotedStr('PORTUGAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (187,6238,'+QuotedStr('QUENIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (188,6254,'+QuotedStr('QUIRGUIZ, REPUBLICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (189,6289,'+QuotedStr('REINO UNIDO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (190,6408,'+QuotedStr('REPUBLICA CENTRO-AFRICANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (191,6475,'+QuotedStr('REPUBLICA DOMINICANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (192,6602,'+QuotedStr('REUNIAO, ILHA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (193,6700,'+QuotedStr('ROMENIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (194,6750,'+QuotedStr('RUANDA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (195,6769,'+QuotedStr('RUSSIA, FEDERACAO DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (196,6858,'+QuotedStr('SAARA OCIDENTAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (197,6777,'+QuotedStr('SALOMAO, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (198,6904,'+QuotedStr('SAMOA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (199,6912,'+QuotedStr('SAMOA AMERICANA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (200,6971,'+QuotedStr('SAN MARINO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (201,7102,'+QuotedStr('SANTA HELENA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (202,7153,'+QuotedStr('SANTA LUCIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (203,6939,'+QuotedStr('SAO BARTOLOMEU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (204,6955,'+QuotedStr('SAO CRISTOVAO E NEVES,ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (205,6980,'+QuotedStr('SAO MARTINHO, ILHA DE (PARTE FRANCESA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (206,6998,'+QuotedStr('SAO MARTINHO, ILHA DE (PARTE HOLANDESA)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (207,7005,'+QuotedStr('SAO PEDRO E MIQUELON') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (208,7200,'+QuotedStr('SAO TOME E PRINCIPE, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (209,7056,'+QuotedStr('SAO VICENTE E GRANADINAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (210,7285,'+QuotedStr('SENEGAL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (211,7358,'+QuotedStr('SERRA LEOA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (212,7370,'+QuotedStr('SERVIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (213,7315,'+QuotedStr('SEYCHELLES') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (214,7447,'+QuotedStr('SIRIA, REPUBLICA ARABE DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (215,7480,'+QuotedStr('SOMALIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (216,7501,'+QuotedStr('SRI LANKA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (217,7544,'+QuotedStr('SUAZILANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (218,7595,'+QuotedStr('SUDAO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (219,7600,'+QuotedStr('SUDÃO DO SUL') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (220,7641,'+QuotedStr('SUECIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (221,7676,'+QuotedStr('SUICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (222,7706,'+QuotedStr('SURINAME') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (223,7552,'+QuotedStr('SVALBARD E JAN MAYERN') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (224,7722,'+QuotedStr('TADJIQUISTAO, REPUBLICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (225,7765,'+QuotedStr('TAILANDIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (226,7803,'+QuotedStr('TANZANIA, REP.UNIDA DA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (227,7919,'+QuotedStr('TCHECA, REPUBLICA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (228,7811,'+QuotedStr('TERRAS AUSTRAIS E ANTARTICAS FRANCESAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (229,7820,'+QuotedStr('TERRITORIO BRIT.OC.INDICO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (230,7951,'+QuotedStr('TIMOR LESTE') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (231,8001,'+QuotedStr('TOGO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (232,8109,'+QuotedStr('TONGA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (233,8052,'+QuotedStr('TOQUELAU,ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (234,8150,'+QuotedStr('TRINIDAD E TOBAGO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (235,8206,'+QuotedStr('TUNISIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (236,8230,'+QuotedStr('TURCAS E CAICOS,ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (237,8249,'+QuotedStr('TURCOMENISTAO, REPUBLICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (238,8273,'+QuotedStr('TURQUIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (239,8281,'+QuotedStr('TUVALU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (240,8311,'+QuotedStr('UCRANIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (241,8338,'+QuotedStr('UGANDA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (242,8451,'+QuotedStr('URUGUAI') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (243,8478,'+QuotedStr('UZBEQUISTAO, REPUBLICA DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (244,5517,'+QuotedStr('VANUATU') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (245,8486,'+QuotedStr('VATICANO, EST.DA CIDADE DO') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (246,8508,'+QuotedStr('VENEZUELA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (247,8583,'+QuotedStr('VIETNA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (248,8630,'+QuotedStr('VIRGENS,ILHAS (BRITANICAS)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (249,8664,'+QuotedStr('VIRGENS,ILHAS (E.U.A.)') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (250,8753,'+QuotedStr('WALLIS E FUTUNA, ILHAS') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (251,8907,'+QuotedStr('ZAMBIA') + ');');
    ExecutaComando(' INSERT INTO PAISES (IDPAISES, CODIGO, NOME) VALUES (252,6653,'+QuotedStr('ZIMBABUE') + ');');

    ExecutaComando('Commit');
  end;
  {Dailon Parisotto (smal-706) 2024-09-18 Inicio}  

  {Mauricio Parizotto 2024-09-27 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'LISTAR') = False then
  begin
    if ExecutaComando('ALTER TABLE ICM ADD LISTAR VARCHAR(1)') then
    begin
      ExecutaComando('commit');
      ExecutaComando('UPDATE ICM set LISTAR = ''S'' ');
      ExecutaComando('commit');
    end;
  end;
  {Mauricio Parizotto 2024-09-27 Fim}

  {Mauricio Parizotto 2024-09-30 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'NATUREZA_RECEITA') = False then
  begin
    if ExecutaComando('ALTER TABLE ESTOQUE ADD NATUREZA_RECEITA VARCHAR(3)') then
    begin
      ExecutaComando('Commit');

      RemoveValorLIVRE4('NR', 'NATUREZA_RECEITA', Form1.ibDataSet200.Transaction);
    end;
  end;
  {Mauricio Parizotto 2024-09-30 Fim}

  {Mauricio Parizotto 2024-10-28 Inicio}
  if (not TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'COMPRASIMPORTACAO')) then
  begin
    ExecutaComando(' Create table COMPRASIMPORTACAO ('+
                   ' 	 IDCOMPRASIMPORTACAO INTEGER NOT NULL,'+
                   ' 	 NUMERONF VARCHAR(12),'+
                   ' 	 IDPAISES INTEGER,'+
                   ' 	 NUMRODI VARCHAR(12),'+
                   ' 	 DATAREGISTRODI DATE,'+
                   ' 	 LOCALDESEMBARACO VARCHAR(60),'+
                   ' 	 UFDESEMBARACO VARCHAR(2),'+
                   ' 	 DATADESEMBARACO DATE,'+
                   ' 	 CODEXPORTADOR VARCHAR(60),'+
                   ' 	 NUMADICAO INTEGER,'+
                   ' 	 IDENTESTRANGEIRO VARCHAR(50),'+
                   ' 	 CONSTRAINT PK_COMPRASIMPORTACAO PRIMARY KEY (IDCOMPRASIMPORTACAO)'+
                   ' );');

    ExecutaComando('Commit');

    ExecutaComando('CREATE SEQUENCE G_COMPRASIMPORTACAO');

    ExecutaComando('Commit');
  end;
  {Mauricio Parizotto 2024-10-28 Inicio}

{Mauricio Parizotto 2024-09-27 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ICM', 'TRIB_INTELIGENTE') = False then
  begin
    if ExecutaComando('ALTER TABLE ICM ADD TRIB_INTELIGENTE VARCHAR(1)') then
      ExecutaComando('commit');
  end;
  {Mauricio Parizotto 2024-09-27 Fim}

  
  {Mauricio Parizotto 2024-09-26 Inicio}
  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CONSULTA_TRIBUTACAO') = False then
  begin
    if ExecutaComando('Alter table ESTOQUE add CONSULTA_TRIBUTACAO varchar(1);') then
    begin
      ExecutaComando('commit');
      ExecutaComando('Update ESTOQUE set CONSULTA_TRIBUTACAO = ''S'' ');
      ExecutaComando('commit');
    end;
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'STATUS_TRIBUTACAO') = False then
  begin
    if ExecutaComando('Alter table ESTOQUE add STATUS_TRIBUTACAO varchar(30);') then
    begin
      ExecutaComando('commit');	
      ExecutaComando('Update ESTOQUE set STATUS_TRIBUTACAO = ''Não consultado'' ');
      ExecutaComando('commit');
    end;
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'DATA_STATUS_TRIBUTACAO') = False then
  begin
    if ExecutaComando('Alter table ESTOQUE add DATA_STATUS_TRIBUTACAO timestamp;') then
      ExecutaComando('commit');
  end;

  if CampoExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ESTOQUE', 'CODIGO_IMENDES') = False then
  begin
    if ExecutaComando('Alter table ESTOQUE add CODIGO_IMENDES integer;') then
      ExecutaComando('commit');
  end;
  {Mauricio Parizotto 2024-09-26 Fim}

  {Mauricio Parizotto 2024-10-14 Inicio}
  if GeneratorExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase,'G_CIT') = False then
  begin
    if ExecutaComando('CREATE SEQUENCE G_CIT') then
      ExecutaComando('commit');
  end;
  {Mauricio Parizotto 2024-10-14 Fim}

  if not(TabelaExisteFB(Form1.ibDataSet200.Transaction.DefaultDatabase, 'ATORINTERESSADO')) then
  begin
    ExecutaComando(
      'create table ATORINTERESSADO ('+
        'ID INTEGER, '+
        'NUMERONF VARCHAR(12), '+
        'MODELO VARCHAR(2), '+
        'CPFCNPJ VARCHAR(14), '+
        'IS_PROTECTED SMALLINT '+
      ')'
    );
    ExecutaComando('CREATE SEQUENCE G_ATORINTERESSADO');
    ExecutaComando('commit');
  end;


  Form22.Repaint;

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
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form1.ibDataset200.FieldByname('NOME').AsString));
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
    ExecutaComando('set generator G_BUILD to ' + BUILD_DO_BANCO); // Sandro Silva 2022-09-12 Form1.ibDataset200.SelectSql.Add('set generator G_BUILD to 2022004');
  except
  end;

  ExecutaComando('update COMPRAS set NFEXML = null where coalesce(NFEXML, '''') <> '''' and (NFEXML not like ''%<chNFe>''||NFEID||''</chNFe>%'')');

  ExecutaComando('commit');  

  Form13.Tag := 99;

  Mensagem22('Criando indicadores');

  Form22.Repaint;
  Mensagem22('Alteração na estrutura Ok');
end;


procedure RemoveValorLIVRE4(Sigla, sNovoCampo : string; IBTRANSACTION : TIBTransaction); // Mauricio Parizotto 2024-10-01
var
  IBQUERY: TIBQuery;
  sNR, sIdent4, sNovoIdent4 : string;
begin
  try
    IBQUERY := CriaIBQuery(IBTRANSACTION);

    try
      IBQUERY.Close;
      IBQUERY.SQL.Text := ' Select'+
                          '   * '+
                          ' From ESTOQUE'+
                          ' Where UPPER(LIVRE4) like ''%'+Sigla+'=%'' ';
      IBQUERY.Open;

      while not IBQUERY.Eof do
      begin
        sIdent4 := UpperCase(IBQUERY.FieldByName('LIVRE4').AsString);

        sNR := ExtrairConfiguracao(sIdent4, Sigla);

        sNovoIdent4 := StringReplace(sIdent4,Sigla+'='+sNR,'',[rfReplaceAll]);
        sNovoIdent4 := StringReplace(sNovoIdent4, ';;',';',[rfReplaceAll] );
        sNovoIdent4 := StringReplace(sNovoIdent4, '; ;',';',[rfReplaceAll] );

        if (Copy(sNovoIdent4,1,1) = ';') then
          Delete(sNovoIdent4,1,1);

        if (Copy(sNovoIdent4,1,1) = ' ') then
          Delete(sNovoIdent4,1,1);

        ExecutaComando(' Update ESTOQUE set '+sNovoCampo+' = '+ QuotedStr(Copy(sNR,1,3) )+
                       '   , LIVRE4 = '+ QuotedStr(sNovoIdent4)+
                       ' Where IDESTOQUE = '+IBQUERY.FieldByName('IDESTOQUE').AsString,
                       IBTRANSACTION);

        IBQUERY.Next;
      end;
    finally
      FreeAndNil(IBQUERY);
    end;
  except
  end;
end;


end.
