unit uGeraCNAB400;

interface

uses
  Windows, Messages, SysUtils, Forms, Dialogs, SmallFunc, IniFiles;

  procedure GeraCNAB400;

implementation

uses Unit26
  , Mais
  , Unit7
  , Unit25
  ;

procedure GeraCNAB400;
var
  vTotal : Real;
  I : Integer;
  F: TextFile;
  sCodigoDaCarteira, sComandoMovimento, sIdoComplemento, sIdentificacaoBanco, sParcela, sCPFOuCNPJ, sCPFOuCNPJ_EMITENTE: String;
  iReg, iRemessa : Integer;
begin
try
    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then // SICOOB
    begin
      sIdentificacaoBanco := '756BANCOOBCED';
    end else
    begin
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '001' then // BANCO DO BRASIL
      begin
        sIdentificacaoBanco := '001BANCODOBRASIL';
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
        begin
          sIdentificacaoBanco := '104C ECON FEDERAL';
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
          begin
            sIdentificacaoBanco := '237BRADESCO';
          end else
          begin
            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353' then // SANTANDER
            begin
              sIdentificacaoBanco := '353SANTANDER';
            end else
            begin
              if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033' then // SANTANDER
              begin
                sIdentificacaoBanco := '033SANTANDER';
              end else
              begin
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                begin
                  sIdentificacaoBanco := '041BANRISUL';
                end else
                begin
                  sIdentificacaoBanco := Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+'          ';
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    try
      ForceDirectories(pchar(Form1.sAtual + '\remessa'));
    except end;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
    begin
      Form1.sArquivoRemessa := '';

      for I := 0 to 99 do
      begin
        if Form1.sArquivoRemessa = '' then
        begin
          if not FileExists(Form1.sAtual+'\remessa\'+'CB'+Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+StrZero(I,2,0)+'.rem') then
          begin
            Form1.sArquivoRemessa := 'CB'+Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+StrZero(I,2,0)+'.rem';
          end;
        end;
      end;
    end else
    begin
      Form1.sArquivoRemessa := Copy(StrTran(DateToStr(Date),'/','_')+DiaDaSemana(Date)+replicate('_',10),1,14)+StrTran(TimeToStr(Time),':','_')+'.txt';
    end;

    AssignFile(F,Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
    Rewrite(F);   // Abre para grava��o

    // Criar um generator para cada banco
    try
      try
        Form7.ibDataset99.Close;
        Form7.ibDataset99.SelectSql.Clear;
        Form7.ibDataset99.SelectSql.Add('select gen_id(G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+',1) from rdb$database');
        Form7.ibDataset99.Open;

        iRemessa := StrToInt(Form7.ibDataset99.FieldByname('GEN_ID').AsString);
      except
        try
          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('create generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3));
          Form7.ibDataset99.Open;
          
          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSql.Add('set generator G_'+Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+' to 1');
          Form7.ibDataset99.Open;

        except end;

        iRemessa := 1;
      end;
    except
      iRemessa := 1
    end;

    try
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
      begin
        // SICOOB HEADER
        WriteLn(F,
          Copy('0',1,001)                                                                           + // 001 ok Identifica��o do Registro Header: �0� (zero)
          Copy('1',1,001)                                                                           + // 002 ok Tipo de Opera��o: �1� (um)
          Copy('REMESSA',1,007)                                                                     + // 003 ok Identifica��o por Extenso do Tipo de Opera��o: "REMESSA"
          Copy('01',1,002)                                                                          + // 004 ok Identifica��o do Tipo de Servi�o: �01� (um)
          Copy('COBRAN�A',1,008)                                                                    + // 005 ok Identifica��o por Extenso do Tipo de Servi�o: �COBRAN�A�
          Copy(Replicate(' ',7),1,007)                                                              + // 006 ok Complemento do Registro: Brancos
          Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                       + // 007 Ok Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
          Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                                       + // 008 Ok D�gito Verificador do Prefixo: vide planilha "Capa" deste arquivo
          Copy(Right('000000000'+LimpaNumero(Form26.MaskEdit46.Text),9),1,8)                        + // 009 Ok C�digo do Cliente/Benefici�rio: vide planilha "Capa" deste arquivo
          Copy(Right('000000000'+LimpaNumero(Form26.MaskEdit46.Text),9),9,1)                        + // 010 Ok D�gito Verificador do C�digo: vide planilha "Capa" deste arquivo
          Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),6)                                     + // 011 Ok N�mero do conv�nio l�der: Brancos
          Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 012 Ok Nome do Benefici�rio: vide planilha "Capa" deste arquivo
          Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 013 Ok Identifica��o do Banco: "756BANCOOBCED"
          Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 014 ok Data da Grava��o da Remessa: formato ddmmaa
          Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 015 ok Seq�encial da Remessa: n�mero seq�encial acrescido de 1 a cada remessa. Inicia com "0000001"
          Copy(Replicate(' ',287),1,287)                                                            + // 016 ok Complemento do Registro: Brancos
          Copy('000001',1,006)                                                                      + // 017 ok Seq�encial do Registro:�000001�
          ''
          );
      end else
      begin
        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
        begin
          // CAIXA HEADER
          WriteLn(F,
            Copy('0',1,001)                                                                           + // 01- 001 a 001 9(001) Identifica��o do Registro Header: �0� (zero)
            Copy('1',1,001)                                                                           + // 02- 002 a 002 9(001) Tipo de Opera��o: �1� (um)
            Copy('REMESSA',1,007)                                                                     + // 03- 003 a 009 X(007) Identifica��o por Extenso do Tipo de Opera��o 01
            Copy('01',1,002)                                                                          + // 04- 010 a 011 9(002) Identifica��o do Tipo de Servi�o: �01�
            Copy('COBRANCA',1,008)                                                                    + // 05- 012 a 019 X(008) Identifica��o por Extenso do Tipo de Servi�o: �COBRANCA�
            Copy(Replicate(' ',7),1,007)                                                              + // 06- 020 a 026 X(007) Complemento do Registro: �Brancos�
            Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                    + // 07- 027 a 030 X(004) C�digo da agencia
            Copy(LimpaNumero(Form26.MaskEdit46.Text)+'      ',1,006)                                  + // 08- 031 a 036 X(006) cod. Benefici�rio
            Copy(Replicate(' ',10),1,10)                                                              + //
            Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 10- 047 a 076 X(030) Nome do Cedente
            Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 11- 077 a 094 X(018)
            Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 12- 095 a 100 9(006) Data da Grava��o: Informe no formato �DDMMAA� 21
            Copy(Replicate(' ',289),1,289)                                                            + // 13- 101 a 389 Brancos
            Copy(StrZero(iRemessa,5,0),1,005)                                                         + // 14- 390 a 394 9(005) Seq�encial da Remessa 03
            Copy('000001',1,006)                                                                      + // 15- 395 a 400 9(006) Seq�encial do Registro:�000001�
            ''
            );
        end else
        begin
          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
          begin
            // BRADESCO
            WriteLn(F,
              Copy('0',1,001)                                                                           + // 01 - 001 a 001 - 9(001) Identifica��o do Registro (0)
              Copy('1',1,001)                                                                           + // 02 - 002 a 002 - 9(001) Identifica��o do Arquivo Remessa (1)
              Copy('REMESSA',1,007)                                                                     + // 03 - 003 a 009 - X(007) Literal Remessa (REMESSA)
              Copy('01',1,002)                                                                          + // 04 - 010 a 011 - 9(002) C�digo de Servi�o (01)
              Copy('COBRANCA       ',1,015)                                                             + // 05 - 012 a 026 - X(015) Literal Servi�o (COBRANCA)
              Copy(Right(Replicate('0',20)+LimpaNumero(Form26.MaskEdit50.Text),20),1,020)               + // 06 - 027 a 046 - 9(020) C�digo da Empresa (Ser� fornecido pelo Bradesco, quando do Cadastramento)
              Copy(UpperCase(ConverteAcentosPHP(Form7.IbDataSet13NOME.AsString))+Replicate(' ',30),1,030)  + // 07 - 047 a 076 - X(030) Nome da Empresa (Raz�o Social)
              Copy('237',1,003)                                                                         + // 08 - 077 a 079 - 9(003) N�mero do Bradesco na C�mara de Compensa��o (237)
              Copy('BRADESCO       ',1,015)                                                             + // 09 - 080 a 094 - X(015) Nome do Banco por Extenso (Bradesco)
              Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 10 - 095 a 100 - 9(006) Data da Grava��o do Arquivo (DDMMAA)
              Copy('        ',1,8)                                                                      + // 11 - 101 a 108 - X(008) Branco (Branco)
              Copy('MX',1,2)                                                                            + // 12 - 109 a 110 - X(002) Identifica��o do sistema (MX)
              Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 13 - 111 a 117 - 9(007) N� Seq�encial de Remessa (Seq�encial)
              Copy(Replicate(' ',277),1,277)                                                            + // 14 - 118 a 394 - X(277) Branco (Branco)
              Copy('000001',1,006)                                                                      + // 15 - 395 a 400 - 9(006) N� Seq�encial do Registro de Um em Um (000001)
              ''
              );
          end else
          begin
            // ITA� HEADER ITAU
            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '341' then // Ita� ITAU
            begin
              WriteLn(F,
                Copy('0',1,001)                                                                           + // 001 a 001 - 9(001) TIPO DE REGISTRO    - IDENTIFICA��O DO REGISTRO HEADER             - 0
                Copy('1',1,001)                                                                           + // 002 a 002 - 9(001) OPERA��O            - TIPO DE OPERA��O - REMESSA                   - 1
                Copy('REMESSA',1,007)                                                                     + // 003 a 009 - X(007) LITERAL DE REMESSA  - IDENTIFICA��O POR EXTENSO DO MOVIMENTO       - REMESSA
                Copy('01',1,002)                                                                          + // 010 a 011 - 9(002) C�DIGO DO SERVI�O   - IDENTIFICA��O DO TIPO DE SERVI�O             - 01
                Copy('COBRANCA       ',1,015)                                                             + // 012 a 026 - X(015) LITERAL DE SERVI�O  - IDENTIFICA��O POR EXTENSO DO TIPO DE SERVI�O - COBRANCA
                Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                    + // 027 a 030 - 9(004) AG�NCIA             - AG�NCIA MANTENEDORA DA CONTA                 -
                Copy('00',1,002)                                                                          + // 031 a 032 - 9(002) ZEROS               - COMPLEMENTO DE REGISTRO                      - 00
                Copy(LimpaNumero(Form26.MaskEdit46.Text)+'00000',1,5)                                     + // 033 a 037 - 9(005) CONTA               - N�MERO DA CONTA CORRENTE DA EMPRESA          -
                Copy(Right('0'+LimpaNumero(Form26.MaskEdit46.Text),1),1,1)                                + // 038 a 038 - 9(001) DAC                 - D�GITO DE AUTO CONFER�NCIA AG/CONTA EMPRESA  -
                Copy(Replicate(' ',008),1,008)                                                            + // 039 a 046 - X(008) BRANCOS             - COMPLEMENTO DO REGISTRO                      -
                Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 047 a 076 - X(030) NOME DA EMPRESA     - NOME POR EXTENSO DA "EMPRESA M�E"            -
                Copy(sIdentificacaoBanco,1,003)                                                           + // 077 a 079 - 9(003) C�DIGO DO BANCO     - N� DO BANCO NA C�MARA DE COMPENSA��O         - 341
                Copy('BANCO ITAU SA  ',1,015)                                                             + // 080 a 094 - X(015) NOME DO BANCO       - NOME POR EXTENSO DO BANCO COBRADOR           - BANCO ITAU SA
                Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 095 a 100 - 9(006) DATA DE GERA��O     - DATA DE GERA��O DO ARQUIVO                   - DDMMAA
                Copy(Replicate(' ',294),1,294)                                                            + // 101 a 394 - X(294) BRANCOS             - COMPLEMENTO DO REGISTRO                      -
                Copy('000001',1,006)                                                                      + // 395 a 400 - 9(006) N�MERO SEQ�ENCIAL   - N�MERO SEQ�ENCIAL DO REGISTRO NO ARQUIVO     - 000001
                ''
                );
            end else
            begin
              // SANTANDER HEADER
              if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then // SANTANDER
              begin
                //
                WriteLn(F,
                  Copy('0',1,001)                                                                           + // 01 001 a 001 - 9(001) C�digo do registro = 0
                  Copy('1',1,001)                                                                           + // 02 002 a 002 - 9(001) C�digo da remessa = 1
                  Copy('REMESSA',1,007)                                                                     + // 03 003 a 009 - X(007) Literal de transmiss�o = REMESSA
                  Copy('01',1,002)                                                                          + // 04 010 a 011 - 9(002) C�digo do servi�o = 01
                  Copy('COBRANCA       ',1,015)                                                             + // 05 012 a 026 - X(015) Literal de servi�o = COBRAN�A
                  Copy(Right('00000000000000000000'+LimpaNumero(Form26.MaskEdit50.Text),20),1,020)          + // 06 027 a 046 - 9(020) C�digo de Transmiss�o (nota 1)
                  Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 07 047 a 076 - X(030) Nome do cedente
                  Copy(sIdentificacaoBanco,1,003)                                                           + // 08 077 a 079 - 9(003) C�digo do Banco = 353 / 033
                  Copy('SANTANDER      ',1,015)                                                             + // 09 080 a 094 - X(015) Nome do Banco = SANTANDER
                  Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 10 095 a 100 - 9(006) Data de Grava��o
                  Copy(Replicate('0',16),1,16)                                                              + // 11 101 a 116 - 9(016) Zeros
                  Copy(Replicate(' ',47),1,47)                                                              + // 12 117 a 163 - X(047) Mensagem 1
                  Copy(Replicate(' ',47),1,47)                                                              + // 13 164 a 210 - X(047) Mensagem 2
                  Copy(Replicate(' ',47),1,47)                                                              + // 14 211 a 257 - X(047) Mensagem 3
                  Copy(Replicate(' ',47),1,47)                                                              + // 15 258 a 304 - X(047) Mensagem 4
                  Copy(Replicate(' ',47),1,47)                                                              + // 16 305 a 351 - X(047) Mensagem 5
                  Copy(Replicate(' ',40),1,40)                                                              + // 17 352 a 391 - X(047) Mensagem 6
                  Copy(StrZero(iRemessa,3,0),1,003)                                                         + // 18 392 a 394 - 9(003) N�mero da vers�o da remessa opcional, se informada, ser� controlada pelo sistema
                  Copy('000001',1,006)                                                                      + // 19 395 a 400 - 9(006) N�mero sequencial do registro no arquivo = 000001
                  ''
                  );
              end else
              begin
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                begin
                  // BANRISUL HEADER
                  WriteLn(F,
                    Copy('01REMESSA',1,009)                                                                   + // 01 001 a 009 -   9 (x) 01REMESSA (constante) - Campo obrigat�rio
                    Copy(Replicate(' ',17),1,017)                                                             + // 02 010 a 026 -  17 (x) BRANCOS
                    Copy(
                    Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)+
                    LimpaNumero(Form26.MaskEdit46.Text)+Replicate('0',13)
                    ,1,13)                                                                                    + // 03 027 a 039 -  13 (9) C�DIGO DE CEDENTE
                    Copy(Replicate(' ',07),1,007)                                                             + // 04 040 a 046 -   7 (x) BRANCOS
                    Copy(UpperCase(ConverteAcentosPHP(Form7.IbDataSet13NOME.AsString))+Replicate(' ',30),1,030) + // 05 047 a 076 -  30 (x) NOME DA EMPRESA
                    Copy('041BANRISUL',1,011)                                                                 + // 06 077 a 087 -  11 (x) 041BANRISUL (constante)
                    Copy(Replicate(' ',07),1,007)                                                             + // 07 088 a 094 -   7 (x) BRANCOS
                    Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 08 095 a 100 -   6 (9) DATA DE GRAVA��O DO ARQUIVO
                    Copy(Replicate(' ',09),1,009)                                                             + // 09 101 a 109 -   9 (x) BRANCOS
                    Copy(Replicate(' ',04),1,004)                                                             + // 10 110 a 113 -   4 (x) BRANCOS
                    Copy(Replicate(' ',01),1,001)                                                             + // 11 114 a 114 -   1 (x) BRANCOS
                    Copy(' ',1,001)                                                                           + // 12 115 a 115 -   1 (x) X � Quando for movimento para teste, P � Quando for movimento em produ��o
                    Copy(Replicate(' ',01),1,001)                                                             + // 13 116 a 116 -   1 (x) BRANCOS
                    Copy(Replicate(' ',10),1,010)                                                             + // 14 117 a 126 -  10 (x) C�DIGO DO CLIENTE NO OFFICE BANKING
                    Copy(Replicate(' ',268),1,268)                                                            + // 15 127 a 394 - 268 (x) Brancos
                    Copy('000001',1,006)                                                                      + // 16 395 a 400 -   6 (x) 000001 (constante)
                    ''
                    );
                end else
                begin
                  // Banco do Brasil  HEADER
                  WriteLn(F,
                    Copy('0',1,001)                                                                           + // 01.0 001 a 001 9(001) Identifica��o do Registro Header: �0� (zero)
                    Copy('1',1,001)                                                                           + // 02.0 002 a 002 9(001) Tipo de Opera��o: �1� (um)
                    Copy('REMESSA',1,007)                                                                     + // 03.0 003 a 009 X(007) Identifica��o por Extenso do Tipo de Opera��o 01
                    Copy('01',1,002)                                                                          + // 04.0 010 a 011 9(002) Identifica��o do Tipo de Servi�o: �01�
                    Copy('COBRANCA',1,008)                                                                    + // 05.0 012 a 019 X(008) Identifica��o por Extenso do Tipo de Servi�o: �COBRANCA�
                    Copy(Replicate(' ',7),1,007)                                                              + // 06.0 020 a 026 X(007) Complemento do Registro: �Brancos�
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                       + // 07.0 027 a 030 9(004) Prefixo da Ag�ncia: N�mero da Ag�ncia onde est� cadastrado o conv�nio l�der do cedente 02
                    Copy(Copy(AllTrim(Form26.MaskEdit44.Text)+'000000',6,1),1,001)                            + // 08.0 031 a 031 X(001) D�gito Verificador - D.V. - do Prefixo da Ag�ncia. 02
                    Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),1,8)            + // 09.0 032 a 039 9(008) N�mero da Conta Corrente: N�mero da conta onde est� cadastrado o Conv�nio L�der do Cedente 02
                    Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),9,1)            + // 10.0 040 a 040 X(001) D�gito Verificador - D.V. � do N�mero da Conta Corrente do Cedente 02
                    Copy('000000',1,6)                                                                        + // 11.0 041 a 046 9(006) Complemento do Registro: �000000�
                    Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 12.0 047 a 076 X(030) Nome do Cedente
                    Copy(sIdentificacaoBanco+Replicate(' ',18),1,018)                                         + // 13.0 077 a 094 X(018) 001BANCODOBRASIL
                    Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2),1,006) + // 14.0 095 a 100 9(006) Data da Grava��o: Informe no formato �DDMMAA� 21
                    Copy(StrZero(iRemessa,7,0),1,007)                                                         + // 15.0 101 a 107 9(007) Seq�encial da Remessa 03
                    Copy(Replicate(' ',22),1,22)                                                              + // 16.0 108 a 129 X(22) Complemento do Registro: �Brancos�
                    Copy(Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),7),1,7)                           + // 17.0 130 a 136 9(007) N�mero do Conv�nio L�der (numera��o acima de 1.000.000 um milh�o)" 04
                    Copy(Replicate(' ',258)  ,1,258)                                                          + // 18.0 137 a 394 X(258) Complemento do Registro: �Brancos�
                    Copy('000001',1,006)                                                                      + // 19.0 395 a 400 9(006) Seq�encial do Registro:�000001�
                    ''
                    );
                end;
              end;
            end;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        Application.MessageBox(pChar(E.Message),'Aten��o',mb_Ok + MB_ICONWARNING);
      end;
    end;

    // Zerezima
    iReg := 1;
    vTotal := 0;

    Form7.ibDataSet7.DisableControls;
    Form7.ibDataSet7.First;

    while not Form7.ibDataSet7.Eof do
    begin
      if Form7.ibDataSet7ATIVO.AsFloat <> 1 then
      begin
        if (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'REMESSA ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')VENCIMENTO') or
           (UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')EXCLUIR') then
        begin
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.Selectsql.Clear;
          Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
          Form7.ibDataSet2.Open;

          try
            if Length(LimpaNumero(Form7.IBDataSet2CGC.AsString)) = 14 then sCPFOuCNPJ := '02' else sCPFOuCNPJ := '01';

            if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
            begin
              sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em n�mero
            end else
            begin
              sParcela := '01';
            end;

            iReg := iReg + 1;

            try
              // 01 = Registro de T�tulos
              // 02 = Solicita��o de Baixa
              // 04 = Concess�o de Abatimento
              // 05 = Cancelamento de Abatimento
              // 06 = Altera��o de Vencimento
              // 08 = Altera��o de Seu N�mero
              // 09 = Instru��o para Protestar
              // 10 = Instru��o para Sustar Protesto
              // 11 = Instru��o para Dispensar Juros
              // 12 = Altera��o de Pagador
              // 31 = Altera��o de Outros Dados
              // 34 = Baixa - Pagamento Direto ao Benefici�rio
              // 34 = Pagamento Direto ao Benefici�rio
              sComandoMovimento := '01';

              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')BAIXA'       then sComandoMovimento := '02';
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')VENCIMENTO'  then sComandoMovimento := '06';
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')EXCLUIR'     then sComandoMovimento := '99';

              if (sComandoMovimento = '06') and (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104') then
              begin
                sComandoMovimento := '05';
              end;

              // Altera para n�o ir de novo
              if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')BAIXA' then
              begin
                Form7.ibDataSet7.Edit;
                Form7.ibDataSet7PORTADOR.AsString := 'EM CARTEIRA';
                Form7.ibDataSet7.Post;
              end else
              begin
                if Form7.ibDataSet7PORTADOR.AsString <> 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')' then
                begin
                  Form7.ibDataSet7.Edit;
                  Form7.ibDataSet7PORTADOR.AsString := 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text+'000'),1,3)+')';
                  Form7.ibDataSet7.Post;
                end;
              end;

              try
                if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
                begin
                  // SICOOB REMESSA
                  WriteLn(F,
                    Copy('1',1,001)                                                          + // Ok 1 Identifica��o do Registro Detalhe: 1 (um)
                    Copy('02',1,002)                                                         + // Ok 2 "Tipo de Inscri��o do Benefici�rio: ""01"" = CPF ""02"" = CNPJ  "
                    Copy(LimpaNumero(Form7.IBDataSet13CGC.AsString)+Replicate(' ',14),1,014) + // Ok 3 N�mero do CPF/CNPJ do Benefici�rio
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                      + // Ok 4 Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                      + // Ok 5 D�gito Verificador do Prefixo: vide planilha "Capa" deste arquivo
                    Copy(Right('000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),9),1,8) + // ok 6 Conta Corrente: vide planilha "Capa" deste arquivo
                    Copy(Right('000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),9),9,1) + // 0k 7 D�gito Verificador da Conta: vide planilha "Capa" deste arquivo
                    Copy('000000',1,006)                                                     + // ok 8 N�mero do Conv�nio de Cobran�a do Benefici�rio: "000000"
                    Copy(Replicate(' ',25),1,025)                                            + // ok 9 N�mero de Controle do Participante: Brancos
                    Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)),12,0),1,012) + // 10 Ok Nosso N�mero
                    Copy(sPArcela+'00',1,002)                                                + // 11 Ok N�mero da Parcela: "01" se parcela �nica
    //              Copy('01',1,002)                                                         + // 11 Ok N�mero da Parcela: "01" se parcela �nica
                    Copy('00',1,002)                                                         + // 12 Ok Grupo de Valor: "00"
                    Copy('   ',1,003)                                                        + // 13 Ok Complemento do Registro: Brancos
                    Copy(' ',1,001)                                                          + // 14 Ok "Indicativo de Mensagem ou Sacador/Avalista: Brancos: Poder� ser informada nas posi��es 352 a 391 (SEQ 50) qualquer mensagem para ser impressa no boleto; �A�: Dever� ser informado nas posi��es 352 a 391 (SEQ 50) o nome e CPF/CNPJ do sacador"
                    Copy('001',1,003)                                                        + // 15 Ok Prefixo do T�tulo: Brancos
                    Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000000',3,3)          + // 16 Ok Varia��o da Carteira: "000"
                    Copy('0',1,001)                                                          + // 17 Ok Conta Cau��o: "0"
                    Copy('00000',1,005)                                                      + // 18 Ok "N�mero do Contrato Garantia: Para Carteira 1 preencher ""00000""; Para Carteira 3 preencher com o  n�mero do contrato sem DV."
                    Copy('0',1,001)                                                          + // 19 Ok "DV do contrato: Para Carteira 1 preencher ""0""; Para Carteira 3 preencher com o D�gito Verificador."
                    Copy('000000',1,006)                                                     + // 20 Ok Numero do border�: preencher em caso de carteira 3
                    Copy('    ',1,004)                                                       + // 21 Ok Complemento do Registro: Brancos
                    Copy('2',1,001)                                                          + // 22 Ok "Tipo de Emiss�o: 1-Cooperativa 2-Cliente"
                    Copy('01',1,002)                                                         + // 23 Ok "Carteira/Modalidade: 01 = Simples Com Registro 02 = Simples Sem Registro 03 = Garantida Caucionada"
                    Copy(sComandoMovimento,1,002)                                            + // 24 Ok "Comando/Movimento:
                    Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10) + // 25 Ok Seu N�mero/N�mero atribu�do pela Empresa
                    Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)+Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)+Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006) + // 26 Ok "Data Vencimento: Formato DDMMAA
                    Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)     + // 27 Ok Valor do Titulo
                    Copy(Form26.MaskEdit42.Text,1,003)                                       + // 28 Ok N�mero Banco: "756"
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                      + // 29 ok Prefixo da Cooperativa: vide planilha "Capa" deste arquivo
                    Copy(Copy(Form26.MaskEdit44.Text+'    ',5,1),1,001)                      + // 30 ok D�gito Verificador do Prefixo: vide planilha "Capa" deste arquivo
                    Copy('01',1,002)                                                         + // 31 ok "Esp�cie do T�tulo
                    Copy('0',1,001)                                                          + // 32 "Aceite do T�tulo: ""0"" = Sem aceite ""1"" = Com aceite"
                    Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)+Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)+Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006) + // 33 Data de Emiss�o do T�tulo: formato ddmmaa
                    Copy('01',1,002)                                                         + // 34 Ok "Primeira instru��o codificada:
                    Copy('01',1,002)                                                         + // 35 Ok Segunda instru��o: vide SEQ 33
                    Copy('000000',1,006)                                                     + // 36 Ok "Taxa de mora m�s Ex: 022000 = 2,20%)"
                    Copy('000000',1,006)                                                     + // 37 Ok "Taxa de multa Ex: 022000 = 2,20%)"
                    Copy('2',1,001)                                                          + // 38 Ok "Tipo Distribui��o 1 � Cooperativa 2 - Cliente"
                    Copy('000000',1,006)                                                     + // 39 Ok "Data primeiro desconto: Informar a data limite a ser observada pelo cliente para o pagamento do t�tulo com Desconto no formato ddmmaa.
                    Copy('0000000000000',1,013)                                              + // 40 Ok "Valor primeiro desconto: Informar o valor do desconto, com duas casa decimais. Preencher com zeros quando n�o for concedido nenhum desconto."
                    Copy('9000000000000',1,013)                                              + // 41 Ok "193-193 � C�digo da moeda
                    Copy('0000000000000',1,013)                                              + // 42 Ok Valor Abatimento
                    Copy(sCPFOuCNPJ,1,002)                                                   + // 43 Ok "Tipo de Inscri��o do Pagador: ""01"" = CPF ""02"" = CNPJ "
                    Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014) + // 44 Ok N�mero do CNPJ ou CPF do Pagador
                    Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)              + // 45 Ok Nome do Pagador
                    Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,037)            + // 46 Ok Endere�o do Pagador
                    Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,015)            + // 47 Ok Bairro do Pagador
                    Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)  + // 48 Ok CEP do Pagador
                    Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)            + // 49 Ok Cidade do Pagador
                    Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)            + // 50 Ok UF do Pagador
                    Copy(Replicate(' ',40),1,040)                                            + // 51 Ok "Observa��es/Mensagem ou Sacador/Avalista:
                    Copy('00',1,002)                                                         + // 52 Ok "N�mero de Dias Para Protesto:
                    Copy(' ',1,001)                                                          + // 53 Ok Complemento do Registro: Brancos
                    Copy(StrZero(iReg,6,0),1,006)                                            + // 54 Ok Seq�encial do Registro: Incrementado em 1 a cada registro
                    ''
                    );
                end else
                begin
                  if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '104' then // CAIXA
                  begin
                    // CAIXA REMESSA
                    if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';

                    WriteLn(F,
                      Copy('1',1,001)                                                                          + // 01.1 - 001 a 001 - 9(001) Preencher �1�
                      Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 02.1 - 002 a 003 - 9(002) Preencher com o tipo de Inscri��o da Empresa Benefici�ria: �01� = CPF ou �02� = CNPJ
                      Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 03.1 - 004 a 017 - 9(014) Preencher com N�mero de inscri��o da Empresa (CNPJ) ou Pessoa F�sica (CPF) a que se est� fazendo refer�ncia, de acordo com o c�digo do campo acima
                      Copy(LimpaNumero(Form26.MaskEdit44.Text)+'    ',1,004)                                   + // 04.1 - 018 a 021 - 9(004) Preencher com o C�digo da Ag�ncia de vincula��o do Benefici�rio, com 4 d�gitos
                      Copy(LimpaNumero(Form26.MaskEdit46.Text)+'      ',1,006)                                 + // 05.1 - 022 a 027 - 9(006) Preencher com o C�digo que identifica a Empresa na CAIXA, fornecido pela ag�ncia de vincula��o
                      Copy('2',1,001)                                                                          + // 06.1 - 028 a 028 - 9(001) Preencher com a forma de emiss�o do boleto desejada: �1� = Banco Emite ou �2� = Cliente Emite
                      Copy('0',1,001)                                                                          + // 07.1 - 029 a 029 - 9(001) Identifica��o da Entrega/Distribui��o do Boleto
                      Copy('00',1,002)                                                                         + // 09.1 - 032 a 056 - 9(002) Taxa Perman�ncia Informar �00�
                      Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'                         ',1,025)   + // 10.1 - 057 a 058 - X(025) Preencher com Seu N�mero de controle do t�tulo (exemplos: n� da duplicata no caso de cobran�a de duplicatas, n� da ap�lice, em caso de cobran�a de seguros)
                      Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,017)           + // 11.1 - 059 a 073 - 9(017) Nosso N�mero
                      Copy('   ',1,003)                                                                        + // 12.1 - 074 a 076 - X(003) Preencher com espa�os
                      Copy(Replicate(' ',30),1,030)                                                            + // 13.1 - 077 a 106 - X(030) Preencher com Mensagem a ser impressa no boleto
                      Copy('01',1,002)                                                                         + // 14.1 - 107 a 108 - 9(002) Preencher de acordo com a modalidade de cobran�a contratada: �01� = Cobran�a Registrada ou �02� = Cobran�a Sem Registro
                      Copy(sComandoMovimento,1,002)                                                            + // 15.1 - 109 a 110 - 9(002) C�digo Ocorr�ncia Preencher com a a��o desejada para o t�tulo
                      Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 16.1 - 111 a 120 - X(010) Preencher com Seu N�mero de controle do t�tulo (exemplos: n� da duplicata no caso de cobran�a de duplicatas, n� da ap�lice, em caso de cobran�a de seguros)
                      Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 17.1 - 121 a 126 - 9(006) Preencher com a Data de Vencimento do T�tulo, no formato DDMMAA (Dia, M�s e Ano); para os vencimentos �� Vista� ou �Contra-apresenta��o�
                      Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 18.1 - 127 a 139 - 9(013) Preencher com o Valor Nominal do T�tulo, utillizando 2 decimais
                      Copy(LimpaNumero(Form26.MaskEdit42.Text)+'000',1,003)                                    + // 19.1 - 140 a 142 - 9(003) Preencher �104�
                      Copy('00000',1,005)                                                                      + // 20.1 - 143 a 147 - 9(005) Preencher com zeros
                      Copy('01',1,002)                                                                         + // 21.1 - 148 a 149 - 9(002) Esp�cie do T�tulo: 01 DM Duplicata Mercantil
                      Copy('N',1,001)                                                                          + // 22.1 - 150 a 150 - 9(001) Identifica��o de T�tulo - Aceito / N�o Aceito
                      Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                      Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                      Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 23.1 - 151 a 156 - 9(006) Data da Emiss�o do T�tulo
                      Copy('02',1,002)                                                                         + // 24.1 - 157 a 158 - 9(002) Primeira Instru��o de Cobran�a
                      Copy('00',1,002)                                                                         + // 25.1 - 159 a 160 - 9(002) �0�
                      Copy('0000000000000',1,013)                                                              + // 26.1 - 161 a 173 - 9(013) Juros de Mora por dia/Valor; 2 decimais
                      Copy('000000',1,006)                                                                     + // 27.1 - 174 a 179 - 9(006) Data limite para concess�o do desconto
                      Copy('0000000000000',1,013)                                                              + // 28.1 - 180 a 192 - 9(013) Valor do Desconto a ser concedido; 2 decimais
                      Copy('0000000000000',1,013)                                                              + // 29.1 - 193 a 205 - 9(013) Valor do IOF a ser recolhido; 2 decimais
                      Copy('0000000000000',1,013)                                                              + // 30.1 - 206 a 218 - 9(013) Valor do abatimento a ser concedido; 2 decimais
                      Copy(sCPFOuCNPJ,1,002)                                                                   + // 31.1 - 219 a 220 - 9(002) Identificador do Tipo de Inscri��o do Pagador
                      Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 32.1 - 221 a 234 - 9(014) N�mero de Inscri��o do Pagador
                      Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)                              + // 33.1 - 235 a 274 - X(040) Nome do Pagador
                      Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 34.1 - 275 a 314 - X(040) Endere�o do Pagador
                      Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 35.1 - 315 a 326 - X(012) Bairro do Pagador
                      Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 36.1 - 327 a 334 - 9(008) CEP do Pagador
                      Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)                            + // 37.1 - 335 a 349 - X(015) Cidade do Pagador
                      Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)                            + // 38.1 - 350 a 351 - X(002) Unidade da Federa��o do Pagador
                      Copy('000000',1,006)                                                                     + // 39.1 - 352 a 357 - 9(006) Defini��o da data para pagamento de multa
                      Copy('0000000000',1,010)                                                                 + // 40.1 - 358 a 367 - 9(010) Valor nominal da multa; 2 decimais
                      Copy(Replicate(' ',22),1,022)                                                            + // 41.1 - 368 a 389 - X(022) Nome do Sacador/Avalista
                      Copy('00',1,002)                                                                         + // 42.1 - 390 a 391 - 9(002) Terceira Instru��o de Cobran�a
                      Copy('29',1,002)                                                                         + // 43.1 - 392 a 393 - 9(002) N�mero de dias para in�cio do protesto/devolu��o
                      Copy('1',1,001)                                                                          + // 44.1 - 394 a 394 - 9(001) C�digo da Moeda �1�
                      Copy(StrZero(iReg,6,0),1,006)                                                            + // 45.1 - 395 a 400 - 9(006) N�mero Sequencial do Registro no Arquivo
                      ''
                      );
                  end else
                  begin
                    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237' then // BRADESCO
                    begin
                      // BRADESCO
                      WriteLn(F,
                        Copy('1',1,001)                                                                              + // 01.1 - 001 a 001  - 9(001) Identifica��o do Registro
                        Copy('00000',1,005)                                                                          + // 02.1 - 002 a 006  - 9(005) Ag�ncia de D�bito (opcional)
                        Copy('0',1,001)                                                                              + // 03.1 - 007 a 007  - X(001) D�gito da Ag�ncia de D�bito (opcional)
                        Copy('00000',1,005)                                                                          + // 04.1 - 008 a 012  - 9(005) Raz�o da Conta Corrente (opcional)
                        Copy('0000000',1,007)                                                                        + // 05.1 - 013 a 019  - 9(007) Conta Corrente (opcional)
                        Copy('0',1,001)                                                                              + // 06.1 - 020 a 020  - X(001) D�gito da Conta Corrente (opcional)
                        '0'+
                        Right('000'+LimpaNumero(Form26.MaskEdit43.Text),3)+
                        '0'+Copy(Right('00000'+LimpaNumero(Form26.MaskEdit44.Text),5),1,4)+
                        Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8),1,7) +
                        Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8),8,1)                   + // 07.1 - 021 a 037  - X(017) Identifica��o da Empresa Benefici�ria no Banco
                        Copy(Replicate(' ',25),1,025)                                                                + // 08.1 - 038 a 062  - X(025) N� Controle do Participante
                        Copy('000',1,003)                                                                            + // 09.1 - 063 a 065  - 9(003) C�digo do Banco a ser debitado na C�mara de Compensa��o
                        Copy('0',1,001)                                                                              + // 10.1 - 066 a 066  - 9(001) Campo de Multa
                        Copy('0000',1,004)                                                                           + // 11.1 - 067 a 070  - 9(004) Percentual de multa
                        Copy(Copy(StrTran(Form7.ibDataset7NOSSONUM.AsString,'-',''),4,012),1,12)                     + // 12.1 - 071 a 081  - 9(011) Identifica��o do T�tulo no Banco
                        Copy('0000000000',1,010)                                                                     + // 13.1 - 083 a 092  - 9(010) Desconto Bonifica��o por dia
                        Copy('2',1,001)                                                                              + // 14.1 - 093 a 093  - X(001) Condi��o para Emiss�o da Papeleta de Cobran�a
                        Copy('N',1,001)                                                                              + // 15.1 - 094 a 094  - X(001) Ident. se emite Boleto para D�bito Autom�tico
                        Copy('          ',1,010)                                                                     + // 16.1 - 095 a 104  - X(010) Identifica��o da Opera��o do Banco
                        Copy(' ',1,001)                                                                              + // 17.1 - 105 a 105  - 9(001) Indicador Rateio Cr�dito (opcional)
                        Copy('2',1,001)                                                                              + // 18.1 - 106 a 106  - X(001) Endere�amento para Aviso do D�bito Autom�tico em Conta Corrente (opcional)
                        Copy('  ',1,002)                                                                             + // 19.1 - 107 a 108  - X(002) Branco
                        //
                        Copy(sComandoMovimento,1,002)                                                                + // 20.1 - 109 a 110  - 9(002) Identifica��o da ocorr�ncia
                        Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                     + // 21.1 - 111 a 120  - X(010) N� do Documento
                        Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                              +
                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                                   +
                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                            + // 22.1 - 121 a 126  - 9(006) Data do Vencimento do T�tulo
                        Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                         + // 23.1 - 127 a 139  - 9(013) Valor do T�tulo
                        Copy('000',1,003)                                                                            + // 24.1 - 140 a 142  - 9(003) Banco Encarregado da Cobran�a
                        Copy('00000',1,005)                                                                          + // 25.1 - 143 a 147  - 9(005) Ag�ncia Deposit�ria
                        Copy('01',1,002)                                                                             + // 26.1 - 148 a 149  - 9(002) Esp�cie de T�tulo
                        Copy('N',1,001)                                                                              + // 27.1 - 150 a 150  - X(001) Identifica��o
                        Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                                 +
                        Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                      +
                        Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                               + // 28.1 - 151 a 156  - 9(006) Data da emiss�o do T�tulo
                        Copy('00',1,002)                                                                             + // 29.1 - 157 a 158  - 9(002) 1� instru��o
                        Copy('00',1,002)                                                                             + // 30.1 - 159 a 160  - 9(002) 2� instru��o
                        Copy('0000000000000',1,013)                                                                  + // 31.1 - 161 a 173  - 9(013) Valor a ser cobrado por Dia de Atraso
                        Copy('000000',1,006)                                                                         + // 32.1 - 174 a 179  - 9(006) Data Limite P/Concess�o de Desconto
                        Copy('0000000000000',1,013)                                                                  + // 33.1 - 180 a 192  - 9(013) Valor do Desconto
                        Copy('0000000000000',1,013)                                                                  + // 34.1 - 193 a 205  - 9(013) Valor do IOF
                        Copy('0000000000000',1,013)                                                                  + // 35.1 - 206 a 218  - 9(013) Valor do Abatimento a ser concedido ou cancelado
                        Copy(sCPFOuCNPJ,1,002)                                                                       + // 36.1 - 219 a 220  - 9(002) Identifica��o do Tipo de Inscri��o do Pagador
                        Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)            + // 37.1 - 221 a 234  - X(014) N� Inscri��o do Pagador
                        Copy(UpperCase(ConverteAcentosPHP(Form7.ibDataSet2NOME.AsString))+Replicate(' ',40),1,040)   + // 38.1 - 235 a 274  - X(040) Nome do Pagador
                        Copy(UpperCase(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+Replicate(' ',40),1,040) + // 39.1 - 275 a 314  - X(040) Endere�o Completo
                        Copy('            ',1,012)                                                                   + // 40.1 - 315 a 326  - X(012) 1� Mensagem
                        Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),1,005)                       + // 41.1 - 327 a 331  - 9(005) CEP
                        Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),6,003)                       + // 42.1 - 332 a 334  - 9(003) Sufixo do CEP
                        Copy(Replicate(' ',60),1,060)                                                                + // 43.1 - 335 a 394  - X(060) Sacador/Avalista ou 2� Mensagem
                        Copy(StrZero(iReg,6,0),1,006)                                                                + // 44.1 - 395 a 400  - 9(006) N� Seq�encial do Registro
                        ''
                        );
                    end else
                    begin
                      // SANTANDER
                      if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then
                      begin
                        if LimpaNumero(Form7.ibDataSet11CONTA.AsString) <> '' then
                        begin
                          if LimpaNumero(Form7.ibDataSet11CONTA.AsString) <> '' then
                          begin
                            try
                              Form7.ibDataSet11.Edit;
                              if Length(LimpaNumero(Form7.ibDataSet11CONTA.AsString)) <= 8 then
                              begin
                                Form7.ibDataSet11CONTA.AsString := Right('00000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),8);
                              end else
                              begin
                                Form7.ibDataSet11CONTA.AsString := Right('0000000000'+LimpaNumero(Form7.ibDataSet11CONTA.AsString),10);
                              end;

                              Form7.ibDataSet11.Post;
                            except
                            end;
                          end;
                        end;

                        if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';
                        if Length(LimpaNumero(Form7.ibDataSet11CONTA.AsString)) = 10 then sIdoComplemento     := 'I' else sIdoComplemento := '0';
                        
                        WriteLn(F,
                          Copy('1',1,001)                                                                          + // 001.1 - 001 a 001 - 9(001) C�digo do registro = 1
                          Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 002.1 - 002 a 003 - 9(002) Tipo de inscri��o do cedente: 01 = CPF 02 = CGC
                          Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 003.1 - 004 a 017 - 9(014) CGC ou CPF do cedente
                          Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)                                   + // 004.1 - 018 a 021 - 9(004) C�digo da ag�ncia cedente (nota 2)
                          Copy(LimpaNumero(Form26.MaskEdit46.Text)+'000000000',1,8)                                + // 005.1 - 022 a 029 - 9(008) Conta movimento cedente (nota 2)
                          Copy(LimpaNumero(Form7.ibDataSet11CONTA.AsString)+'00000000',1,008)                      + // 006.1 - 030 a 037 - 9(008) Conta cobran�a cedente (nota 2)
                          Copy(Replicate(' ',25),1,25)                                                             + // 007.1 - 038 a 062 - X(025) N�mero de controle do participante, para controle por parte do cedente
                          Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataSet7NN.AsString)),7,0),1,07)         +
                          Modulo_11(LimpaNumero(Form7.ibDataSet7NN.AsString))                                      + // 008.1 - 063 a 070 - 9(008) Nosso n�mero (nota 3)
                          Copy('000000',1,6)                                                                       + // 009.1 - 071 a 076 - 9(006) Data do segundo desconto
                          Copy(' ',1,1)                                                                            + // 010.1 - 077 a 077 - X(001) Branco
                          Copy('0',1,1)                                                                            + // 011.1 - 078 a 078 - 9(001) Informa��o de multa = 4, sen�o houver informar zero
                          Copy('0000',1,4)                                                                         + // 012.1 - 079 a 082 - 9(004) Percentual multa por atraso %
                          Copy('00',1,2)                                                                           + // 013.1 - 083 a 084 - 9(002) Unidade de valor moeda corrente = 00
                          Copy('0000000000000',1,13)                                                               + // 014.1 - 085 a 097 - 9(013) Valor do t�tulo em outra unidade (consultar banco)
                          Copy('    ',1,4)                                                                         + // 015.1 - 098 a 101 - X(004) Brancos
                          Copy('000000',1,6)                                                                       + // 016.1 - 102 a 107 - 9(006) Data para cobran�a de multa. (Nota 4)
                          Copy('5',1,1)                                                                            + // 017.1 - 108 a 108 - 9(001) C�digo da carteira (5 = R�PIDA COM REGISTRO (BLOQUETE EMITIDO PELO CLIENTE))
                          Copy(sComandoMovimento,1,002)                                                            + // 018.1 - 109 a 110 - 9(002) C�digo da ocorr�ncia: (01 = ENTRADA DE T�TULO 02 = BAIXA DE T�TULO 06 = PRORROGA��O DE VENCIMENTO)
                          Copy(Form7.ibDataset7DOCUMENTO.AsString+'          ',1,010)                              + // 019.1 - 111 a 120 - X(010) Seu n�mero
                          Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 020.1 - 121 a 126 - 9(006) Data de vencimento do t�tulo
                          Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 021.1 - 127 a 139 - 9(013) Valor do t�tulo - moeda corrente
                          Copy(Copy(AllTrim(Form26.MaskEdit42.Text),1,3)+'000',1,3)                                + // 022.1 - 140 a 142 - 9(003) N�mero do Banco cobrador = 353 / 033
                          Copy('00000',1,5)                                                                        + // 023.1 - 143 a 147 - 9(005) C�digo da ag�ncia cobradora do Banco Santander informar somente se carteira for igual a 5, caso contr�rio, informar zeros.
                          Copy('01',1,2)                                                                           + // 024.1 - 148 a 149 - 9(002) Esp�cie de documento: 01 = DUPLICATA
                          Copy('N',1,001)                                                                          + // 025.1 - 150 a 150 - X(001) Tipo de aceite = N
                          Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 026.1 - 151 a 156 - 9(006) Data da emiss�o do t�tulo
                          Copy('00',1,2)                                                                           + // 027.1 - 157 a 158 - 9(002) Primeira instru��o cobran�a
                          Copy('00',1,2)                                                                           + // 028.1 - 159 a 160 - 9(002) Segunda instru��o cobran�a c�digo 00 = N�O H� INSTRU��ES
                          Copy(Replicate('0',13),1,13)                                                             + // 029.1 - 161 a 173 - 9(013) Valor de mora a ser cobrado por dia de atraso
                          Copy('000000',1,6)                                                                       + // 030.1 - 174 a 179 - 9(006) Data limite para concess�o de desconto
                          Copy(Replicate('0',13),1,13)                                                             + // 031.1 - 180 a 192 - 9(013) Valor de desconto a ser concedido
                          Copy(Replicate('0',13),1,13)                                                             + // 032.1 - 193 a 205 - 9(013) Valor do IOF a ser recolhido pelo Banco para nota de seguro
                          Copy(Replicate('0',13),1,13)                                                             + // 033.1 - 206 a 218 - 9(013) Valor do abatimento a ser concedido ou valor do segundo desconto
                          Copy(sCPFOuCNPJ,1,002)                                                                   + // 034.1 - 219 a 220 - 9(002) Tipo de inscri��o do sacado: 01 = CPF 02 = CGC
                          Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 035.1 - 221 a 234 - 9(014) CGC ou CPF do sacado
                          Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',40),1,040)                              + // 036.1 - 235 a 274 - X(040) Nome do sacado
                          Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 037.1 - 275 a 314 - X(040) Endere�o do sacado
                          Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 038.1 - 315 a 326 - X(012) Bairro do sacado (opcional)
                          Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 039.1 - 327 a 331 - 9(005) CEP do sacado
                                                                                                                     // 040.1 - 332 a 334 - 9(003) Complemento do CEP
                          Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',40),1,015)                            + // 041.1 - 335 a 349 - X(015) Munic�pio do sacado
                          Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',40),1,002)                            + // 042.1 - 350 a 351 - X(002) UF Estado do sacado
                          Copy(Replicate(' ',30),1,030)                                                            + // 043.1 - 352 a 381 - X(030) Nome do sacador ou coobrigado
                          Copy(' ',1,1)                                                                            + // 044.1 - 382 a 382 - X(001) Brancos
                          Copy(sIdoComplemento,1,1)                                                                + // 045.1 - 383 a 383 - 9(001) Identificador do Complemento (nota 2)
                          Copy(LimpaNumero(Form7.ibDataSet11CONTA.AsString)+'0000000000',9,2)                      + // 046.1 - 384 a 385 - 9(002) Complemento (nota 2)
                          Copy(Replicate(' ',6),1,006)                                                             + // 047.1 - 386 a 391 - X(006) Brancos
                          Copy('00',1,002)                                                                         + // 048.1 - 392 a 393 - 9(002) N�mero de dias para protesto.
                          Copy(' ',1,001)                                                                          + // 049.1 - 394 a 394 - X(001) Branco
                          Copy(StrZero(iReg,6,0),1,006)                                                            + // 050.1 - 395 a 400 - 9(006) N�mero sequencial do registro no arquivo
                          ''
                          );
                      end else
                      begin
                        // ITA� REMESSA ITAU
                        if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '341' then // Ita� ITAU
                        begin
                          sCodigoDaCarteira := 'I';

                          if Form26.MaskEdit43.Text = '108' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '180' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '121' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '150' then sCodigoDaCarteira := 'U';
                          if Form26.MaskEdit43.Text = '109' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '191' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '104' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '188' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '147' then sCodigoDaCarteira := 'E';
                          if Form26.MaskEdit43.Text = '112' then sCodigoDaCarteira := 'I';
                          if Form26.MaskEdit43.Text = '115' then sCodigoDaCarteira := 'I';

                          if Length(LimpaNumero(Form7.IBDataSet13CGC.AsString)) = 14 then sCPFOuCNPJ_EMITENTE := '02' else sCPFOuCNPJ_EMITENTE := '01';

                          WriteLn(F,
                            Copy('1',1,001)                                                                          + // 001 a 001 - 9(01) IDENTIFICA��O DO REGISTRO TRANSA��O
                            Copy(sCPFOuCNPJ_EMITENTE,1,002)                                                          + // 002 a 003 - 9(02) TIPO DE INSCRI��O DA EMPRESA
                            Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)       + // 004 a 017 - 9(14) N� DE INSCRI��O DA EMPRESA (CPF/CNPJ)
                            Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)                                   + // 018 a 021 - 9(04) AG�NCIA MANTENEDORA DA CONTA
                            Copy('00',1,2)                                                                           + // 022 a 023 - 9(02) COMPLEMENTO DE REGISTRO
                            Copy(LimpaNumero(Form26.MaskEdit46.Text)+'00000',1,5)                                    + // 024 a 028 - 9(05) N�MERO DA CONTA CORRENTE DA EMPRESA
                            Copy(Right('0'+LimpaNumero(Form26.MaskEdit46.Text),1),1,1)                               + // 029 a 029 - 9(01) D�GITO DE AUTO CONFER�NCIA AG/CONTA EMPRESA
                            Copy(Replicate(' ',4),1,004)                                                             + // 030 a 033 - X(04) COMPLEMENTO DE REGISTRO
                            Copy('0000',1,004)                                                                       + // 034 a 037 - 9(04) C�D.INSTRU��O/ALEGA��O A SER CANCELADA
                            Copy(Replicate(' ',25),1,025)                                                            + // 038 a 062 - X(25) IDENTIFICA��O DO T�TULO NA EMPRESA
                            Copy(Right('00000000'+LimpaNumero(Form7.ibDataSet7NN.AsString),8),1,8)                   + // 063 a 070 - 9(08) IDENTIFICA��O DO T�TULO NO BANCO
                            Copy('0000000000000',1,13)                                                               + // 071 a 083 - 9(13) QUANTIDADE DE MOEDA VARI�VEL
                            Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000',1,3)                             + // 084 a 086 - 9(03) N�MERO DA CARTEIRA NO BANCO
                            Copy(Replicate(' ',21),1,021)                                                            + // 087 a 107 - X(21) IDENTIFICA��O DA OPERA��O NO BANCO
                            Copy(sCodigoDaCarteira,1,001)                                                            + // 108 a 108 - X(01) C�DIGO DA CARTEIRA
                            Copy(sComandoMovimento,1,002)                                                            + // 109 a 110 - 9(02) IDENTIFICA��O DA OCORR�NCIA
                            Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 111 a 120 - X(10) N� DO DOCUMENTO DE COBRAN�A (DUPL.,NP ETC.)
                            Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                            Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                            Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 121 a 126 - 9(06) DATA DE VENCIMENTO DO T�TULO
                            Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 127 a 139 - 9(13) VALOR NOMINAL DO T�TULO
                            Copy(sIdentificacaoBanco,1,003)                                                          + // 140 a 142 - 9(03) N� DO BANCO NA C�MARA DE COMPENSA��O
                            Copy('00000',1,5)                                                                        + // 143 a 147 - 9(05) AG�NCIA ONDE O T�TULO SER� COBRADO
                            Copy('01',1,002)                                                                         + // 148 a 149 - X(02) ESP�CIE DO T�TULO
                            Copy('N',1,001)                                                                          + // 150 a 150 - X(01) IDENTIFICA��O DE T�TULO ACEITO OU N�O ACEITO
                            Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                            Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                            Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 151 a 156 - 9(06) DATA DA EMISS�O DO T�TULO
                            Copy('10',1,002)                                                                         + // 157 a 158 - X(02) 1� INSTRU��O DE COBRAN�A
                            Copy('10',1,002)                                                                         + // 159 a 160 - X(02) 2� INSTRU��O DE COBRAN�A
                            Copy('0000000000000',1,13)                                                               + // 161 a 173 - 9(13) VALOR DE MORA POR DIA DE ATRASO
                            Copy('000000',1,6)                                                                       + // 174 a 179 - 9(06) DATA LIMITE PARA CONCESS�O DE DESCONTO
                            Copy('0000000000000',1,13)                                                               + // 180 a 192 - 9(13) VALOR DO DESCONTO A SER CONCEDIDO
                            Copy('0000000000000',1,13)                                                               + // 193 a 205 - 9(13) VALOR DO I.O.F. RECOLHIDO P/ NOTAS SEGURO
                            Copy('0000000000000',1,13)                                                               + // 206 a 218 - 9(13) VALOR DO ABATIMENTO A SER CONCEDIDO
                            Copy(sCPFOuCNPJ,1,002)                                                                   + // 219 a 220 - 9(02) IDENTIFICA��O DO TIPO DE INSCRI��O/SACADO
                            Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 221 a 234 - 9(14) N� DE INSCRI��O DO SACADO (CPF/CNPJ)
                            Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',30),1,030)                              + // 235 a 264 - X(30) NOME DO SACADO
                            Copy(Replicate(' ',10),1,010)                                                            + // 265 a 274 - X(10) COMPLEMENTO DE REGISTRO
                            Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 275 a 314 - X(40) RUA, N�MERO E COMPLEMENTO DO SACADO
                            Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',12),1,012)                            + // 315 a 326 - X(12) BAIRRO DO SACADO
                            Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',8),1,008)                   + // 327 a 334 - 9(08) CEP DO SACADO
                            Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',15),1,015)                            + // 335 a 349 - X(15) CIDADE DO SACADO
                            Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 350 a 351 - X(02) UF DO SACADO
                            Copy(Replicate(' ',30),1,030)                                                            + // 352 a 381 - X(30) NOME DO SACADOR OU AVALISTA
                            Copy(Replicate(' ',04),1,004)                                                            + // 382 a 385 - X(04) COMPLEMENTO DO REGISTRO
                            Copy('000000',1,6)                                                                       + // 386 a 391 - 9(06) DATA DE MORA
                            Copy('00',1,002)                                                                         + // 392 a 393 - 9(02) QUANTIDADE DE DIAS
                            Copy(' ',1,001)                                                                          + // 394 a 394 - X(01) COMPLEMENTO DO REGISTRO
                            Copy(StrZero(iReg,6,0),1,006)                                                            + // 395 a 400 - 9(06) N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
                            ''
                            );
                        end else
                        begin
                          if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
                          begin
                            // BANRISUL REMESSA
                            WriteLn(F,
                              Copy('1',1,001)                                                                          + // 001 a 001 - x(01) TIPO DE REGISTRO: 1 (constante)
                              Copy(Replicate(' ',16),1,016)                                                            + // 002 a 017 - x(16) BRANCOS
                              Copy(
                              Copy(LimpaNumero(Form26.MaskEdit44.Text)+'0000',1,004)+
                              LimpaNumero(Form26.MaskEdit46.Text)+Replicate('0',13)
                              ,1,13)                                                                                   + // 03 027 a 039 -  13 (9) C�DIGO DE CEDENTE
                              Copy(Replicate(' ',07),1,007)                                                            + // 031 a 037 - x(07) BRANCOS
                              Copy(Form7.ibDataset7DOCUMENTO.AsString+Replicate(' ',25),1,025)                         + // 038 a 062 - x(25) IDENTIFICA��O DO T�TULO PARA O BENEFICI�RIO
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,010)           + // 063 a 072 - x(10) IDENTIFICA��O DO T�TULO PARA O BANCO (NOSSO N�MERO)
                              Copy(Replicate(' ',32),1,032)                                                            + // 073 a 104 - x(32) MENSAGEM NO BLOQUETO
                              Copy(Replicate(' ',03),1,003)                                                            + // 105 a 107 - x(03) BRANCOS
                              Copy('1',1,001)                                                                          + // 108 a 108 - x(01) TIPO DE CARTEIRA
                              Copy(sComandoMovimento,1,002)                                                            + // 109 a 110 - x(02) C�DIGO DE OCORR�NCIA
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+Replicate(' ',10),1,10)              + // 111 a 120 - x(10) SEU N�MERO  *+* Nosso n�mero banrisul
                              Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 121 a 126 - x(06) DATA DE VENCIMENTO DO T�TULO
                              Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 127 a 139 - x(13) VALOR DO T�TULO
                              Copy('041',1,003)                                                                        + // 140 a 142 - x(03) BANCO COBRADOR: 041 (constante)
                              Copy(Replicate(' ',05),1,005)                                                            + // 143 a 147 - x(05) BRANCOS
                              Copy('08',1,002)                                                                         + // 148 a 149 - x(02) TIPO DE DOCUMENTO
                              Copy('N',1,001)                                                                          + // 150 a 150 - x(01) C�DIGO DE ACEITE
                              Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 151 a 156 - x(06) DATA DA EMISS�O DO T�TULO
                              Copy('23',1,002)                                                                         + // 157 a 158 - x(02) C�DIGO DA 1� INSTRU��O - N�o protestar
                              Copy('  ',1,002)                                                                         + // 159 a 160 - x(02) C�DIGO DA 2� INSTRU��O
                              Copy(' ',1,001)                                                                          + // 161 a 161 - x(01) C�DIGO DE MORA
                              Copy('             ',1,012)                                                              + // 162 a 173 - x(12) VALOR AO DIA OU TAXA MENSAL DE JUROS
                              Copy('      ',1,006)                                                                     + // 174 a 179 - x(06) DATA PARA CONCESS�O DO DESCONTO
                              Copy('              ',1,013)                                                             + // 180 a 192 - x(13) VALOR DO DESCONTO A SER CONCEDIDO
                              Copy('              ',1,013)                                                             + // 193 a 205 - x(13) VALOR IOF
                              Copy('              ',1,013)                                                             + // 206 a 218 - x(13) VALOR DO ABATIMENTO
                              Copy(sCPFOuCNPJ,1,002)                                                                   + // 219 a 220 - x(02) TIPO DE INSCRI��O DO PAGADOR
                              Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 221 a 234 - x(14) N�MERO DE INSCRI��O DO PAGADOR NO MF
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2NOME.AsString)+Replicate(' ',35),1,035)          + // 235 a 269 - x(35) NOME DO PAGADOR
                              Copy(Replicate(' ',05),1,005)                                                            + // 270 a 274 - x(05) BRANCOS
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString)+Replicate(' ',40),1,040)        + // 275 a 314 - x(40) ENDERE�O DO PAGADOR
                              Copy(Replicate(' ',07),1,007)                                                            + // 315 a 321 - x(07) BRANCOS
                              Copy(Replicate(' ',03),1,003)                                                            + // 322 a 324 - x(03) TAXA PARA MULTA AP�S O VENCIMENTO
                              Copy(Replicate(' ',02),1,002)                                                            + // 325 a 326 - x(02) N�MERO DE DIAS PARA MULTA AP�S O VENCIMENTO
                              Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',40),1,008)                  + // 327 a 334 - x(08) CEP
                              Copy(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString)+Replicate(' ',15),1,015)        + // 335 a 349 - x(15) CIDADE DO PAGADOR (PRA�A DE COBRAN�A)
                              Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 350 a 351 - x(02) UF � UNIDADE DA FEDERA��O
                              Copy(Replicate(' ',04),1,004)                                                            + // 352 a 355 - x(04) TAXA AO DIA PARA PAGAMENTO ANTECIPADO
                              Copy(Replicate(' ',02),1,002)                                                            + // 356 a 357 - x(02) BRANCOS
                              Copy('              ',1,012)                                                             + // 358 a 369 - x(12) VALOR PARA C�LCULO DO DESCONTO
                              Copy(Replicate(' ',02),1,002)                                                            + // 370 a 371 - x(02) N�MERO DE DIAS PARA PROTESTO OU DE DEVOLU��O AUTOM�TICA
                              Copy(Replicate(' ',23),1,023)                                                            + // 372 a 394 - x(23) BRANCOS
                              Copy(StrZero(iReg,6,0),1,006)                                                            + // 395 a 400 - x(06) N�MERO SEQUENCIAL DO REGISTRO
                              ''
                              );
                          end else
                          begin
                            // Banco do Brasil REMESSA
                            WriteLn(F,
                              Copy('7',1,001)                                                                          + // 01.7 001 a 001 9(001) Identifica��o do Registro Detalhe: 7 (sete)
                              Copy('02',1,002)                                                                         + // 02.7 002 a 003 9(002) Tipo de Inscri��o do Cedente 22
                              Copy(LimpaNumero(Form7.IBDataSet13CGC.AsString)+Replicate(' ',14),1,014)                 + // 03.7 004 a 017 9(014) N�mero do CPF/CNPJ do Cedente
                              Copy(Copy(Form26.MaskEdit44.Text+'    ',1,4),1,004)                                      + // 04.7 018 a 021 9(004) Prefixo da Ag�ncia 02
                              Copy(Copy(AllTrim(Form26.MaskEdit44.Text)+'000000',6,1),1,001)                           + // 05.7 022 a 022 X(001) D�gito Verificador - D.V. - do Prefixo da Ag�ncia 02
                              Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),1,8)           + // 06.7 023 a 030 9(008) N�mero da Conta Corrente do Cedente 02
                              Copy(Right('000000000'+AllTrim(StrTran(Form26.MaskEdit46.Text,'-','')),9),9,1)           + // 07.7 031 a 031 X(001) D�gito Verificador - D.V. - do N�mero da Conta Corrente do Cedente 02
                              Copy(Right('000000'+LimpaNumero(Form26.MaskEdit50.Text),7),1,7)                          + // 08.7 032 a 038 9(007) N�mero do Conv�nio de Cobran�a do Cedente 02
                              Copy(Replicate(' ',25),1,025)                                                            + // 09.7 039 a 063 X(025) C�digo de Controle da Empresa 23
                              Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+'00000000000000000',1,017)           + // 10.7 064 a 080 9(017) Nosso-N�mero 06
                              Copy('00',1,002)                                                                         + // 11.7 081 a 082 9(002) N�mero da Presta��o: �00� (Zeros)
                              Copy('00',1,002)                                                                         + // 12.7 083 a 084 9(002) Grupo de Valor: �00� (Zeros)
                              Copy('   ',1,003)                                                                        + // 13.7 085 a 087 X(003) Complemento do Registro: �Brancos�
                              Copy(' ',1,001)                                                                          + // 14.7 088 a 088 X(001) Indicativo de Mensagem ou Sacador/Avalista 13
                              Copy('   ',1,003)                                                                        + // 15.7 089 a 091 X(003) Prefixo do T�tulo: �Brancos�
                              Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'000000',3,3)                          + // 16.7 092 a 094 9(003) Varia��o da Carteira 02
                              Copy('0',1,001)                                                                          + // 17.7 095 a 095 9(001) Conta Cau��o: �0� (Zero)
                              Copy('000000',1,006)                                                                     + // 18.7 096 a 101 9(006) N�mero do Border�: �000000� (Zeros)
                              Copy('     ',1,005)                                                                      + // 19.7 102 a 106 X(005) Tipo de Cobran�a 24
                              Copy(AllTrim(LimpaNumero(Form26.MaskEdit43.Text))+'00',1,002)                            + // 20.7 107 a 108 9(002) Carteira de Cobran�a 25
                              Copy(sComandoMovimento,1,002)                                                            + // 21.7 109 a 110 9(002) Comando 20
                              Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)                 + // 22.7 111 a 120 X(010) Seu N�mero/N�mero do T�tulo Atribu�do pelo Cedente 05
                              Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                          +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                               +
                              Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2),1,006)                        + // 23.7 121 a 126 9(006) Data de Vencimento 08
                              Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),13,0),1,013)                     + // 24.7 127 a 139 9(011) v99 Valor do T�tulo 19
                              Copy(LimpaNumero(Form26.MaskEdit42.Text)+'000',1,003)                                    + // 25.7 140 a 142 9(003) N�mero do Banco: �001�
                              Copy('0000',1,004)                                                                       + // 26.7 143 a 146 9(004) Prefixo da Ag�ncia Cobradora: �0000� 26
                              Copy('     ',5,001)                                                                      + // 27.7 147 a 147 X(001) D�gito Verificador do Prefixo da Ag�ncia Cobradora: �Brancos�
                              Copy('01',1,002)                                                                         + // 28.7 148 a 149 9(002) Esp�cie de Titulo 07
                              Copy('N',1,001)                                                                          + // 29.7 150 a 150 X(001) Aceite do T�tulo: 27
                              Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                             +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                  +
                              Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),9,2),1,006)                           + // 30.7 151 a 156 9(006) Data de Emiss�o: Informe no formato �DDMMAA� 28 31.7
                              Copy('00',1,002)                                                                         + // 31.7 157 a 158 9(002) Instru��o Codificada 09
                              Copy('01',1,002)                                                                         + // 32.7 159 a 160 9(002) Instru��o Codificada 09
                              Copy('00000000000000',1,013)                                                             + // 33.7 161 a 173 9(011) v99 Juros de Mora por Dia de Atraso 10
                              Copy('000000',1,006)                                                                     + // 34.7 174 a 179 9(006) Data Limite para Concess�o de Desconto/Data de Opera��o do BBVendor/Juros de Mora. 11
                              Copy('00000000000000',1,013)                                                             + // 35.7 180 a 192 9(011)v99 Valor do Desconto 29
                              Copy('00000000000000',1,013)                                                             + // 36.7 193 a 205 9(011)v99 Valor do IOF/Qtde Unidade Vari�vel. 30
                              Copy('00000000000000',1,013)                                                             + // 37.7 206 a 218 9(011)v99 Valor do Abatimento 31
                              Copy(sCPFOuCNPJ,1,002)                                                                   + // 38.7 219 a 220 9(002) Tipo de Inscri��o do Sacado 32
                              Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet2CGC.AsString),14),1,014)        + // 39.7 221 a 234 9(014) N�mero do CNPJ ou CPF do Sacado 33
                              Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',37),1,037)                              + // 40.7 235 a 271 X(037) Nome do Sacado
                              Copy('   ',1,003)                                                                        + // 41.7 272 a 274 X(003) Complemento do Registro: �Brancos�
                              Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',40),1,040)                            + // 42.7 275 a 314 X(040) Endere�o do Sacado
                              Copy(Form7.ibDataSet2COMPLE.AsString+Replicate(' ',40),1,012)                            + // 43.7 315 a 326 X(012) Bairro do Sacado
                              Copy(LimpaNumero(Form7.ibDataSet2CEP.AsString)+Replicate('0',08),1,008)                  + // 44.7 327 a 334 9(008) CEP do Endere�o do Sacado
                              Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',15),1,015)                            + // 45.7 335 a 349 X(015) Cidade do Sacado
                              Copy(Form7.ibDataSet2ESTADO.AsString+Replicate(' ',02),1,002)                            + // 46.7 350 a 351 X(002) UF da Cidade do Sacado
                              Copy(Replicate(' ',40),1,040)                                                            + // 47.7 352 a 391 X(040) Observa��es/Mensagem ou Sacador/Avalista 13
                              Copy('00',1,002)                                                                         + // 48.7 392 a 393 X(002) N�mero de Dias Para Protesto 34
                              Copy(' ',1,001)                                                                          + // 49.7 394 a 394 X(001) Complemento do Registro: �Brancos�
                              Copy(StrZero(iReg,6,0),1,006)                                                            + // 50.7 395 a 400 9(006) Seq�encial de Registro 35
                              ''
                              );
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              except
                on E: Exception do
                begin
                  Application.MessageBox(pChar(E.Message),'Aten��o',mb_Ok + MB_ICONWARNING);
                end;
              end;
            except
              on E: Exception do
              begin
                Application.MessageBox(pChar(E.Message),'Aten��o',mb_Ok + MB_ICONWARNING);
              end;
            end;

            vTotal := vTotal + Form7.ibDataSet7VALOR_DUPL.AsFloat;
          except
          end;
        end;
      end;
      Form7.ibDataSet7.Next;
    end;

    // TAILER
    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041' then // Banrisul
    begin
      // BANRISUL TAILER
      WriteLn(F,
        Copy('9',1,001)                                                                                                            + // 001 a 001 - 9(001)      C�digo do registro = 9
        Copy(Replicate(' ',26),1,26)                                                                                               + // 002 a 027 - X(26)       Brancos
        Copy(StrZero(vTotal*100,13,0),1,013)                                                                                       + // 028 a 040 - 9(013)      Valor total dos t�tulos (informa��o obrigat�ria)
        Copy(Replicate(' ',354),1,354)                                                                                             + // 041 a 394 - X(354)      Brancos
        Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 395 a 400 - 9(006)      N�mero sequencial do registro no arquivo
        ''
        );
    end else
    begin
      if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
      begin
        // SICOOB TAILER
        WriteLn(F,
          Copy('9',1,001)                                                                                                            + // 1 Identifica��o Registro Trailler: "9"
          Copy(Replicate(' ',193),1,193)                                                                                             + // 2 Complemento do Registro: Brancos
          Copy(AllTrim(Form25.Edit4.Text)+' '+AllTrim(Form25.Edit5.Text)+' '+AllTrim(Form25.Edit6.Text)+' '+AllTrim(Form25.Edit7.Text)+Replicate(' ',200),001,40)+ // 3 "Mensagem responsabilidade Benefici�rio:
          Copy(AllTrim(Form25.Edit4.Text)+' '+AllTrim(Form25.Edit5.Text)+' '+AllTrim(Form25.Edit6.Text)+' '+AllTrim(Form25.Edit7.Text)+Replicate(' ',200),041,40)+ // 4 "Mensagem responsabilidade Benefici�rio:
          Copy(AllTrim(Form25.Edit4.Text)+' '+AllTrim(Form25.Edit5.Text)+' '+AllTrim(Form25.Edit6.Text)+' '+AllTrim(Form25.Edit7.Text)+Replicate(' ',200),081,40)+ // 5 "Mensagem responsabilidade Benefici�rio:
          Copy(AllTrim(Form25.Edit4.Text)+' '+AllTrim(Form25.Edit5.Text)+' '+AllTrim(Form25.Edit6.Text)+' '+AllTrim(Form25.Edit7.Text)+Replicate(' ',200),121,40)+ // 6 "Mensagem responsabilidade Benefici�rio:
          Copy(AllTrim(Form25.Edit4.Text)+' '+AllTrim(Form25.Edit5.Text)+' '+AllTrim(Form25.Edit6.Text)+' '+AllTrim(Form25.Edit7.Text)+Replicate(' ',200),161,40)+ // 7 "Mensagem responsabilidade Benefici�rio:
          Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 8 Seq�encial do Registro: Incrementado em 1 a cada registro
          ''
          );
      end else
      begin
        if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then
        begin
          // SANTANDER TAILER
          WriteLn(F,
            Copy('9',1,001)                                                                                                            + // 001 a 001 - 9(001)      C�digo do registro = 9
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 002 a 007 - 9(006)      Quantidade de documentos no arquivo informa��o obrigat�ria)
            Copy(StrZero(vTotal*100,13,0),1,013)                                                                                       + // 008 a 020 - 9(011)v99   Valor total dos t�tulos (informa��o obrigat�ria)
            Copy(Replicate('0',374),1,374)                                                                                             + // 021 a 394 - 9(374)      Zeros
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 395 a 400 - 9(006)      N�mero sequencial do registro no arquivo
            ''
            );
        end else
        begin
          WriteLn(F,
            Copy('9',1,001)                                                                                                            + // 01.9 001 a 001 9(001) Identifica��o do Registro Trailer: �9�
            Copy(Replicate(' ',393),1,393)                                                                                             + // 02.9 002 a 394 X(393) Complemento do Registro: �Brancos�
            Copy(StrZero(iReg+1,6,0),1,006)                                                                                            + // 03.9 395 a 400 9(006) N�mero Seq�encial do Registro no Arquivo
            ''
            );
        end;
      end;
    end;

    CloseFile(F); // Fecha o arquivo

    if iReg = 1 then
    begin
      DeleteFile(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
      Form1.sArquivoRemessa := '';
      
      ShowMessage('N�o existe movimento, o arquivo n�o foi gerado.');
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar(E.Message),'Aten��o',mb_Ok + MB_ICONWARNING);
    end;
  end;

  Form7.ibDataSet7.EnableControls;
end;

end.
