unit uGeraCNAB240;

interface

uses
  Windows
  , Messages
  , SysUtils
  , Forms
  , Dialogs
  , smallfunc_xe
  , IniFiles
  ;

type TBanco = (bOutro
              , bItau
              , bSicoob
              , bAilos
              , bUnicred);

  procedure GeraCNAB240;
  procedure GeraCNAB240SegmentoR(var F: TextFile; iReg : integer; sComandoMovimento : string; Banco : TBanco);

  procedure GeraCNAB240SegmentoHeaderL_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string;
        sLayoutdoLote, sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo, sCodigoDoconvenio,
        sNumeroContratoOP : string;
        iRemessa : integer);
  procedure GeraCNAB240SegmentoP_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string;
        sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo,
        sCodigodoJurosdeMora, sNumeroContratoOP : string);
  procedure GeraCNAB240SegmentoR_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string);

var
    sAvisoDebitoAuto : string;  

implementation

uses Unit7
  , Mais
  , Unit26
  , StrUtils
  , DB
  , uDialogs
  , DateUtils;


procedure GeraCNAB240;
var
  vTotal : Real;
  F: TextFile;
  sDigitoAgencia,
  sCodigodoJurosdeMora,
  sDatadoJurosdeMora,
  sDVDaAgencia,
  sCodigoParaBaixa,
  sNumeroDeDiasParaBaixa,
  sNumeroContratoOP,
  sEspecieDoTitulo,
  sTipoDocumento,
  sNumerodoDocumento,
  sFormaDeCadastrar,
  sCodigoDaCarteira,
  sDigitocontacorrente,
  sNumerocontaCorrente,
  sAgencia,
  sLayoutdoLote, sDensidade, sLayoutArquivo,
  sCodigoDoConvenio, sNomeDoBanco, sComandoMovimento, sParcela, sCPFOuCNPJ, sCodigoBenef: String;
  I, iReg, iRemessa, iLote : Integer;

  CodBanco : string;
  Banco : TBanco;
  ValorJuros : Real;
begin
  try
    try
      ForceDirectories(pchar(Form1.sAtual + '\remessa'));
    except
    end;

    CodBanco := Copy(AllTrim(Form26.MaskEdit42.Text),1,3);//Mauricio Parizotto 2023-10-11

    Banco := bOutro;

    if CodBanco = '341' then
      Banco := bItau;

    if CodBanco = '756' then
      Banco := bSicoob;

    if CodBanco = '085' then
      Banco := bAilos;

    if CodBanco = '136' then
      Banco := bUnicred;

    if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748' then
    begin
      // SICREDI
      Form1.sArquivoRemessa := AllTrim(Form26.MaskEdit46.Text)+Copy('123456789OND',Month(Date),1)+StrZero(Day(date),2,0)+'.CRM';

      I := 0;

      while FileExists(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa) do
      begin
        I := I + 1;
        Form1.sArquivoRemessa := AllTrim(Form26.MaskEdit46.Text)+Copy('123456789OND',Month(Date),1)+StrZero(Day(date),2,0)+'.'+StrZero(I,3,0);
      end;
    end else
    begin
      Form1.sArquivoRemessa := Copy(StrTran(DateToStr(Date),'/','_')+DiaDaSemana(Date)+replicate('_',10),1,14)+StrTran(TimeToStr(Time),':','_')+'.txt';
    end;

    AssignFile(F,Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
    Rewrite(F);   // Abre para gravação

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
        except
        end;

        iRemessa := 1;
      end;
    except
      iRemessa := 1
    end;

    // Zerezima
    iReg    := 2;
    vTotal  := 0;
    iLote   := 1;

    if CodBanco = '001' then
    begin
      // BANCO DO BRASIL
      if Pos('-',Form26.MaskEdit44.Text) = 0 then ShowMessage('Configure o código da agência 0000-0');
      if Pos('-',Form26.MaskEdit46.Text) = 0 then ShowMessage('Configure o Número da Código do Cedente 00000-0');
      if Pos('/',Form26.MaskEdit43.Text) = 0 then ShowMessage('Configure a carteira/variação 00/000');

      sNomeDoBanco           := 'BANCO DO BRASIL S.A.';
      sCodigoDoConvenio      := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit50.Text)),9,0),1,9)+'0014'+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',1,2)+Copy(AllTrim(Form26.MaskEdit43.Text)+'00/000',4,3)+'  ';
      sLayoutArquivo         := '000';
      sDensidade             := '06250';
      sLayoutdoLote          := '000';
      sAgencia               := Form26.MaskEdit44.Text;
      sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
      sNumeroContaCorrente   := Right('000000000000'+Copy(Form26.MaskEdit46.Text,1,Pos('-',Form26.MaskEdit46.Text)-1),12);
      sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form26.MaskEdit46.Text,1),1,1);
      sCodigoDaCarteira      := '7';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '02';
      //sNumeroDeDiasParaBaixa := '   '; Mauricio Parizotto 2024-03-21
      sNumeroDeDiasParaBaixa := '000';
      sCodigoParaBaixa       := '0';
      sDigitoAgencia         := '0';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000000000';
    end;

    if Banco = bSicoob then
    begin
      // SICOOB
      sNomeDoBanco           := 'SICOOB';
      sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
      sLayoutArquivo         := '081';
      sDensidade             := '00000';
      sLayoutdoLote          := '040';
      sAgencia               := Copy(Form26.MaskEdit44.Text+'0000-0',1,4); 
      sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
      sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
      sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form7.ibDataSet11CONTA.AsString,1),1,1);
      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '0';
      sTipoDocumento         := ' ';
      sEspecieDoTitulo       := '02';
      sNumeroDeDiasParaBaixa := '   ';
      sCodigoParaBaixa       := '0';
      sDigitoAgencia         := '0'; // tem que ser 0 no Header de Arquivo e nos outros lugar tem que ser ' ' 
      sAvisoDebitoAuto       := '0';
      sNumeroContratoOP      := '0000000000';
    end;

    if CodBanco = '748' then
    begin
      // SICREDI
      sNomeDoBanco           := 'SICREDI';
      sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
      sLayoutArquivo         := '081';
      sDensidade             := '01600';
      sLayoutdoLote          := '040';
      sAgencia               := Copy(Form26.MaskEdit44.Text+'0000-0',1,4);
      sDVDaAgencia           := ' ';
      sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
      sDigitocontacorrente   := Copy(Right(Replicate(' ',13)+Form7.ibDataSet11CONTA.AsString,1),1,1);
      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '03';
      sNumeroDeDiasParaBaixa := '060';
      sCodigoParaBaixa       := '1';
      sDigitoAgencia         := '0';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000000000';
    end;

    if Banco = bAilos then
    begin
      // AILOS
      sNomeDoBanco           := 'AILOS';
      sCodigoDoConvenio      := Copy(AllTrim(Form26.MaskEdit50.Text)+REplicate(' ',20),1,20);
      sLayoutArquivo         := '087';
      sDensidade             := '00000';
      sLayoutdoLote          := '045';
      sAgencia               := Copy(Form26.MaskEdit44.Text+'0000-0',1,4);
      sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
      sNumeroContaCorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),1,12);
      sDigitocontacorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),13,1);
      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '02';
      sNumeroDeDiasParaBaixa := '   ';
      sCodigoParaBaixa       := '2';
      sDigitoAgencia         := ' ';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000000000';
    end;

    if Banco = bItau then
    begin
      // ITAÚ
      sNomeDoBanco           := 'BANCO ITAU SA';
      sCodigoDoConvenio      := REplicate(' ',20);
      sLayoutArquivo         := '040';
      sDensidade             := '00000';
      sLayoutdoLote          := '030';

      //Agencia
      if Pos('-',Form7.ibDataSet11AGENCIA.AsString) > 0 then
      begin
        sAgencia               := Right('0000'+Copy(Form7.ibDataSet11AGENCIA.AsString,1,Pos('-',Form7.ibDataSet11AGENCIA.AsString)-1),4);
        sDVDaAgencia           := Copy(Copy(Form7.ibDataSet11AGENCIA.AsString,Pos('-',Form7.ibDataSet11AGENCIA.AsString)+1,1)+' ',1,1);
      end else
      begin
        sAgencia               := Right('0000'+Form7.ibDataSet11AGENCIA.AsString,4);
        sDVDaAgencia           := ' ';
      end;

      //Conta
      if Pos('-',Form7.ibDataSet11CONTA.AsString) > 0 then
      begin
        sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
        sDigitocontacorrente   := Copy(Copy(Form7.ibDataSet11CONTA.AsString,Pos('-',Form7.ibDataSet11CONTA.AsString)+1,1)+' ',1,1);
      end else
      begin
        sNumeroContaCorrente   := Right('000000000000'+Form7.ibDataSet11CONTA.AsString,12);
        sDigitocontacorrente   := ' ';
      end;

      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '01';
      sNumeroDeDiasParaBaixa := '00';
      sCodigoParaBaixa       := '2';
      sDigitoAgencia         := ' '; 
      sAvisoDebitoAuto       := '0';
      sNumeroContratoOP      := '0000000000';
    end;

    if CodBanco = '041' then
    begin
      // Banrisul
      sNomeDoBanco           := 'BANRISUL';
      sCodigoDoConvenio      := Copy(AllTrim(Form26.MaskEdit50.Text)+REplicate(' ',20),1,20);
      sLayoutArquivo         := '103';
      sDensidade             := '00000';
      sLayoutdoLote          := '060';

      //Agencia
      if Pos('-',Form7.ibDataSet11AGENCIA.AsString) > 0 then
      begin
        sAgencia               := Right('0000'+Copy(Form7.ibDataSet11AGENCIA.AsString,1,Pos('-',Form7.ibDataSet11AGENCIA.AsString)-1),4);
        sDVDaAgencia           := Copy(Copy(Form7.ibDataSet11AGENCIA.AsString,Pos('-',Form7.ibDataSet11AGENCIA.AsString)+1,1)+' ',1,1);
      end else
      begin
        sAgencia               := Right('0000'+Form7.ibDataSet11AGENCIA.AsString,4);
        sDVDaAgencia           := ' ';
      end;

      //Conta
      if Pos('-',Form7.ibDataSet11CONTA.AsString) > 0 then
      begin
        sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
        sDigitocontacorrente   := Copy(Copy(Form7.ibDataSet11CONTA.AsString,Pos('-',Form7.ibDataSet11CONTA.AsString)+1,1)+' ',1,1);
      end else
      begin
        sNumeroContaCorrente   := Right('000000000000'+Form7.ibDataSet11CONTA.AsString,12);
        sDigitocontacorrente   := ' ';
      end;

      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '02';
      sNumeroDeDiasParaBaixa := '   ';
      sCodigoParaBaixa       := '0';
      sDigitoAgencia         := ' ';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000805076';
    end;

    if Banco = bUnicred then
    begin
      // Unicred
      sNomeDoBanco           := 'UNICRED DO BRASIL';
      sCodigoDoConvenio      := Replicate(' ',20);
      sLayoutArquivo         := '085';
      sDensidade             := '00000';
      sLayoutdoLote          := '044';

      //Agencia
      if Pos('-',Form7.ibDataSet11AGENCIA.AsString) > 0 then
      begin
        sAgencia               := Right('0000'+Copy(Form7.ibDataSet11AGENCIA.AsString,1,Pos('-',Form7.ibDataSet11AGENCIA.AsString)-1),4);
        sDVDaAgencia           := Copy(Copy(Form7.ibDataSet11AGENCIA.AsString,Pos('-',Form7.ibDataSet11AGENCIA.AsString)+1,1)+' ',1,1);
      end else
      begin
        sAgencia               := Right('0000'+Form7.ibDataSet11AGENCIA.AsString,4);
        sDVDaAgencia           := ' ';
      end;

      //Conta
      if Pos('-',Form26.MaskEdit46.Text) > 0 then
      begin
        //sNumeroContaCorrente   := Right('000000000000'+Copy(Form7.ibDataSet11CONTA.AsString,1,Pos('-',Form7.ibDataSet11CONTA.AsString)-1),12);
        sNumeroContaCorrente   := Right('000000000000'+Copy(Form26.MaskEdit46.Text,1,Pos('-',Form26.MaskEdit46.Text)-1),12);
        sDigitocontacorrente   := Copy(Copy(Form26.MaskEdit46.Text,Pos('-',Form26.MaskEdit46.Text)+1,1)+' ',1,1);
      end else
      begin
        sNumeroContaCorrente   := Right('000000000000'+Form26.MaskEdit46.Text,12);
        sDigitocontacorrente   := ' ';
      end;

      sCodigoBenef := Form7.ibDataSet11CONTA.AsString;

      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := 'N ';
      sNumeroDeDiasParaBaixa := '000';
      sCodigoParaBaixa       := '0';
      sDigitoAgencia         := ' ';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000000000';
    end;

    if sNomeDoBanco = '' then
    begin
      sNomeDoBanco           := 'BANCO PADRAO CNAB';
      sCodigoDoConvenio      := Copy(Replicate(' ',20),1,20);
      sLayoutArquivo         := '000';
      sDensidade             := '00000';
      sLayoutdoLote          := '000';
      sAgencia               := Copy(Form26.MaskEdit44.Text+'0000-0',1,4);
      sDVDaAgencia           := Copy(Copy(Form26.MaskEdit44.Text+'0000-0',6,1),1,1);
      sNumeroContaCorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),1,12);
      sDigitocontacorrente   := Copy(StrZero(StrToInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),13,0),13,1);
      sCodigoDaCarteira      := '1';
      sFormaDeCadastrar      := '1';
      sTipoDocumento         := '1';
      sEspecieDoTitulo       := '02';
      sNumeroDeDiasParaBaixa := '   ';
      sCodigoParaBaixa       := '0';
      sDigitoAgencia         := '0';
      sAvisoDebitoAuto       := '2';
      sNumeroContratoOP      := '0000000000';
    end;


    try
      // Registro Header de Arquivo (Tipo = 0)
      // Banco do Brasil  HEADER
      WriteLn(F,Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                         + // 001 a 003 (003) Código do Banco na Compensação
        '0000'                                                                                    + // 004 a 007 (004) Lote de Serviço
        '0'                                                                                       + // 008 a 008 (001) Tipo de Registro "0" header
        Copy(Replicate(' ',9),1,9)                                                                + // 009 a 017 (009) Uso Exclusivo FEBRABAN / CNAB
        Copy('2',1,1)                                                                             + // 018 a 018 (001) Tipo de Inscrição da Empresa
        Copy(Right(Replicate('0',14)+LimpaNumero(Form7.IBDataSet13CGC.AsString),14),1,014)        + // 019 a 032 (014) Número de Inscrição da Empresa
        copy(sCodigoDoconvenio,1,20)                                                              + // 033 a 052 (020) Código do Convênio no Banco
        Copy('0'+Copy(sAgencia+'0000-0',1,4),1,5)                                                 + // 053 a 057 (005) Agência Mantenedora da Conta
        Copy(sDVdaAgencia,1,1)                                                                    + // 058 a 058 (001) Dígito Verificador da Agência
        //Copy(sNumeroContaCorrente,1,12)                                                           + // 059 a 070 (012) Número da Conta Corrente
        //Copy(sDigitocontacorrente,1,1)                                                            + // 071 a 071 (001) Dígito Verificador da Conta
        //Copy(sDigitoAgencia,1,1)                                                                  + // 072 a 072 (001) Dígito Verificador da Ag/Conta

        IfThen(Banco <> bUnicred,
              Copy(sNumeroContaCorrente,1,12)                                                      + // 059 a 070 (012) Número da Conta Corrente
              Copy(sDigitocontacorrente,1,1)                                                       + // 071 a 071 (001) Dígito Verificador da Conta
              Copy(sDigitoAgencia,1,1)                                                               // 072 a 072 (001) Dígito Verificador da Ag/Conta
              ,''
              )+

        IfThen(Banco = bUnicred,
              Copy(Right(Replicate('0',14)+LimpaNumero(sCodigoBenef),14),1,14)                      // 059 a 072 (014) Código Beneficiario
              ,''
              )+

        Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 073 a 102 (030) Nome da Empresa
        Copy(sNomeDoBanco+replicate(' ',30),1,30)                                                 + // 103 a 132 (030) Nome do Banco
        Copy(Replicate(' ',10),1,10)                                                              + // 133 a 142 (010) Uso Exclusivo FEBRABAN / CNAB
        copy('1',1,1)                                                                             + // 143 a 143 (001) Código Remessa '1'
        Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),7,4),1,008) + // 144 a 151 (008) Data de Geração do Arquivo
        Copy(StrTran(TimeToStr(Time),':','')+'000000',1,006)                                      + // 152 a 157 (006) Hora de Geração do Arquivo
        Copy(StrZero(iRemessa,6,0),1,006)                                                         + // 158 a 163 (006) Número Seqüencial do Arquivo
        Copy(sLayoutArquivo,1,3)                                                                  + // 164 a 166 (003) No da Versão do Layout do Arquivo
        Copy(sDensidade,1,5)                                                                      + // 167 a 171 (005) Densidade de Gravação do Arquivo
        Copy(Replicate(' ',20),1,20)                                                              + // 172 a 191 (020) Para Uso Reservado do Banco
        Copy(Replicate(' ',20),1,20)                                                              + // 192 a 211 (020) Para Uso Reservado da Empresa
        Copy(Replicate(' ',29),1,29)                                                                // 212 a 240 (029) Uso Exclusivo FEBRABAN / CNAB
        );

      if Banco <> bUnicred then
      begin
        // Registro Header de Lote (Tipo = 1)
        WriteLn(F,Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                         + // 001 a 003 (003) Código do Banco na Compensação
        '0001'                                                                                    + // 004 a 007 (004) Lote de Serviço
        '1'                                                                                       + // 008 a 008 (001) Tipo de Registro
        'R'                                                                                       + // 009 a 009 (001) Tipo de Operação
        '01'                                                                                      + // 010 a 011 (002) Tipo de Serviço
        Copy(Replicate(' ',002),1,002)                                                            + // 012 a 013 (002) Uso Exclusivo da FEBRABAN/CNAB
        Copy(sLayoutdoLote,1,3)                                                                   + // 014 a 016 (003) Nº da Versão do Layout do Lote
        ' '                                                                                       + // 017 a 017 (001) Uso Exclusivo da FEBRABAN/CNAB
        Copy('2',1,1)                                                                             + // 018 a 018 (001) Tipo de Inscrição da Empresa
        Copy(Right(Replicate('0',15)+LimpaNumero(Form7.IBDataSet13CGC.AsString),15),1,015)        + // 019 a 033 (015) Número de Inscrição da Empresa
        copy(sCodigoDoconvenio,1,20)                                                              + // 034 a 053 (020) Código do Convênio no Banco
        Copy('0'+sAgencia,1,5)                                                                    + // 054 a 058 (005) Agência Mantenedora da Conta
        Copy(sDVdaAgencia,1,1)                                                                    + // 059 a 059 (001) Dígito Verificador da Agência
        Copy(sNumeroContaCorrente,1,12)                                                           + // 060 a 071 (012) Número da Conta Corrente
        Copy(sDigitocontacorrente,1,1)                                                            + // 072 a 072 (001) Dígito Verificador da Conta
        Copy(' ',1,1)                                                                             + // 073 a 073 (001) Dígito Verificador da Ag/Conta
        Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 074 a 103 (030) Nome da Empresa
        Copy(Replicate(' ',40),1,40)                                                              + // 104 a 143 (040) Mensagem 1
        Copy(Replicate(' ',40),1,40)                                                              + // 144 a 183 (040) Mensagem 2
        Copy(StrZero(iRemessa,8,0),1,008)                                                         + // 184 a 191 (008) Número Remessa/Retorno
        Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),7,4),1,008) + // 192 a 199 (008) Data de Gravação Remessa/Retorno
        Copy('00000000',1,8)                                                                      + // 200 a 207 (008) Data do Crédito
        Copy(Replicate(' ',33),1,33)                                                              // 208 a 240 (033) Uso Exclusivo FEBRABAN / CNAB Mauricio Parizotto 2023-12-08
        );
      end else
      begin
        GeraCNAB240SegmentoHeaderL_Unicred(F, iReg, sComandoMovimento, sLayoutdoLote, sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo, sCodigoDoconvenio,
                                           sNumeroContratoOP,
                                           iRemessa);
      end;
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
        MensagemSistema(E.Message,msgErro);
      end;
    end;

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
          try
            Form7.ibDataSet2.Close;
            Form7.ibDataSet2.Selectsql.Clear;
            Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');
            Form7.ibDataSet2.Open;

            sCPFOuCNPJ := '01';
            if Length(LimpaNumero(Form7.IBDataSet2CGC.AsString)) = 14 then sCPFOuCNPJ := '02' else sCPFOuCNPJ := '01';

            sParcela := '01';

            if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
            begin
              sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em número
            end else
            begin
              sParcela := '01';
            end;

            if Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '756' then
            begin
              sNumerodoDocumento := Copy(StrZero(StrToFloat('0'+LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)),10,0)+sParcela+'014     ',1,20);
            end else
            begin
              sNumerodoDocumento := Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString)+Replicate(' ',20),1,20);
            end;
          except
            on E: Exception do
            begin
              //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message,msgErro);
            end;
          end;

          try
            // Código de Movimento usados pelo Small Commerce
            // '01' = Entrada de Títulos
            // '02' = Pedido de Baixa
            // '06' = Alteração de Vencimento
            sComandoMovimento := '01';

            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')BAIXA'       then sComandoMovimento := '02';
            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')VENCIMENTO'  then sComandoMovimento := '06';
            if UpperCase(AllTrim(Form7.ibDataSet7PORTADOR.AsString)) = 'BANCO ('+Copy(AllTrim(Form26.MaskEdit42.Text)+'000',1,3)+')EXCLUIR'     then sComandoMovimento := '99';

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
              // Registros de Detalhe (Tipo = 3)
              // Registro Detalhe - Segmento P (Obrigatório - Remessa)
              iReg := iReg + 1;

              //if (Form1.fTaxa = 0) and (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '748') then Mauricio Parizotto 2023-12-11
              if (Form1.fTaxa = 0) and ( (CodBanco = '748') or (CodBanco = '041')  ) then
              begin
                sCodigodoJurosdeMora := '3';          // Código do Juros de Mora
                sDatadoJurosdeMora   := '00000000';   // Data do Juros de Mora
              end else
              begin
                sCodigodoJurosdeMora := '2'; // Código do Juros de Mora
                sDatadoJurosdeMora   := Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),1,2)  +
                                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),4,2)       +
                                        Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime+1),7,4),1,008); // Data do Juros de Mora
              end;

              if Banco = bItau then
              begin
                sCodigodoJurosdeMora := '0';
                ValorJuros := (Form1.fTaxa / 100) * Form7.ibDataSet7VALOR_DUPL.AsFloat;
              end;

              if Banco <> bUnicred then
              begin
                WriteLn(F,
                Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
                Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
                copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
                Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
                Copy('P',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
                Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
                Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa
                Copy('0'+Copy(sAgencia+'0000-0',1,4),1,5)                                                 + // 018 a 022 (005) Agência Mantenedora da Conta
                Copy(sDVdaAgencia,1,1)                                                                    + // 023 a 023 (001) Dígito Verificador da Agência
                Copy(sNumeroContaCorrente,1,12)                                                           + // 024 a 035 (012) Número da Conta Corrente
                Copy(sDigitocontacorrente,1,1)                                                            + // 036 a 036 (001) Dígito Verificador da Conta
                Copy(' ',1,1)                                                                             + // 037 a 037 (001) Dígito Verificador da Ag/Conta
                Copy(sNumerodoDocumento,1,20)                                                             + // 038 a 057 (020) Número do Documento de Cobrança Mauricio Parizotto 2023-12-08

                IfThen((Banco <> bItau),
                       Copy(sCodigoDaCarteira,1,1)                                                        + // 058 a 058 (001) Código da Carteira
                       Copy(sFormaDeCadastrar,1,1)                                                        + // 059 a 059 (001) Forma de Cadastr. do Título no Banco
                       Copy(sTipoDocumento,1,1)                                                           + // 060 a 060 (001) Tipo de Documento
                       Copy('2',1,1)                                                                      + // 061 a 061 (001) Identificação da Emissão do Boleto de Pagamento
                       Copy('2',1,1)                                                                      + // 062 a 062 (001) Identificação da Distribuição
                       Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',15),1,15)             // 063 a 077 (015) Número do Documento de Cobrança
                       ,''
                       )+

                //Itau
                IfThen(Banco = bItau,
                       '00000'                                                                            + // 058 a 062 (005) COMPLEMENTO DE REGISTRO
                       Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',10),1,10)           + // 063 a 072 (010) Número do Documento de Cobrança
                       '00000'                                                                              // 073 a 077 (005) COMPLEMENTO DE REGISTRO
                       ,''
                       )+

                {Mauricio Parizotto 2023-10-11 Fim}
                Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                           +
                Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                                +
                Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),7,4),1,008)                         + // 078 a 085 (008) Data de Vencimento do Título
                Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),15,0),1,015)                      + // 086 a 100 (013)+(2) Valor Nominal do Título
                Copy('00000',1,5)                                                                         + // 101 a 105 (005) Agência Encarregada da Cobrança
                Copy(' ',1,001)                                                                           + // 106 a 106 (001) Dígito Verificador da Agência
                Copy(sEspecieDoTitulo,1,2)                                                                + // 107 a 108 (002) Espécie do Título
                Copy('N',1,1)                                                                             + // 109 a 109 (001) Identific. de Título Aceito/Não Aceito
                Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                              +
                Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                   +
                Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),7,4),1,008)                            + // 110 a 117 (008) Data da Emissão do Título
                Copy(sCodigodoJurosdeMora,1,1)                                                            + // 118 a 118 (001) Código do Juros de Mora
                sDatadoJurosdeMora                                                                        + // 119 a 126 (008) Data do Juros de Mora

                IfThen(Banco <> bItau,
                       Copy(StrZero((Form1.fTaxa * 30 * 100),15,0),1,015)                                   // 127 a 141 (013)+(2) Juros de Mora por Dia/Taxa
                       ,'')+

                //Itau - valor do juros
                IfThen(Banco = bItau,
                       Copy(StrZero((ValorJuros * 100),15,0),1,015)                                         // 127 a 141 (013)+(2) Juros de Mora por Dia/Taxa
                       ,'')+

                Copy('0',1,1)                                                                             + // 142 a 142 (001) Código do Desconto
                Copy('00000000',1,8)                                                                      + // 143 a 150 (008) Data do Desconto
                Copy(StrZero(0,15,0),1,015)                                                               + // 151 a 165 (013)+(2) Valor / Percentual a ser Concedido
                Copy('000000000000000',1,15)                                                              + // 166 a 180 (013)+(2) Valor do IOF a ser Recolhido
                Copy('000000000000000',1,15)                                                              + // 181 a 195 (013)+(2) Valor do Abatimento
                Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',25),1,25)                  + // 196 a 220 (025) Identificação do Título na Empresa
                Copy('3',1,1)                                                                             + // 221 a 221 (001) Código para Protesto
                Copy('00',1,2)                                                                            + // 222 a 223 (002) Número de Dias para Protesto
                Copy(sCodigoParaBaixa,1,1)                                                                + // 224 a 224 (001) Código para Baixa/Devolução

                {Mauricio Parizotto 2023-10-11 Inicio}
                //Copy(sNumeroDeDiasParaBaixa,1,3)                                                          + // 225 a 227 (003) Número de Dias para Baixa/Devolu??o
                //Copy('09',1,2)                                                                            + // 228 a 229 (002) Código da Moeda

                IfThen(Banco <> bItau,
                      Copy(sNumeroDeDiasParaBaixa,1,3)                                                    + // 225 a 227 (003) Número de Dias para Baixa/Devolução
                      Copy('09',1,2),''                                                                     // 228 a 229 (002) Código da Moeda
                      )+

                //Itau
                IfThen(Banco = bItau,
                      Copy(sNumeroDeDiasParaBaixa,1,2)                                                    + // 225 a 226 (002) Número de Dias para Baixa/Devolução
                      Copy('000',1,3), ''                                                                   // 227 a 229 (003) COMPLEMENTO DE REGISTRO
                      )+

                {Mauricio Parizotto 2023-10-11 Fim}

                //Copy(Right('0000000000',10),1,10)                                                         + // 230 a 239 (10) Nº do Contrato da Operação de Créd. Mauricio Parizotto 2023-11-07
                Copy(Right(sNumeroContratoOP,10),1,10)                                                      + // 230 a 239 (10) Nº do Contrato da Operação de Créd.
                //Copy(' ',1,1)                                                                               // 240 a 240 (001) Uso Exclusivo FEBRABAN / CNAB

                IfThen(CodBanco = '041',
                      '1'                                                                                     // 240 a 240 (001) Pagamento Parcial
                      ,' '                                                                                    // 240 a 240 (001) Uso Exclusivo FEBRABAN / CNAB
                      )

                );
              end else
              begin
                GeraCNAB240SegmentoP_Unicred(F, iReg, sComandoMovimento, sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo,
                                             sCodigodoJurosdeMora, sNumeroContratoOP);
              end;

              // Registro Detalhe - Segmento Q (Obrigatório - Remessa)
              iReg := iReg + 1;
              WriteLn(F,
                Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
                Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
                copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
                Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
                Copy('Q',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
                Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
                Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa

                // Dados do Pagador
                Copy(sCPFOuCNPJ,2,1)                                                                      + // 018 a 018 (001) Tipo de Inscrição da Empresa
                Copy(Right(Replicate('0',15)+LimpaNumero(Form7.IBDataSet2CGC.AsString),15),1,015)         + // 019 a 033 (015) Número de Inscrição da Empresa
                //Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2NOME.AsString))+Replicate(' ',40),1,040)                    + // 034 a 073 (040) Nome da Empresa Maurici Parizotto 2023-10-24

                IfThen(Banco <> bItau,
                      Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2NOME.AsString))+Replicate(' ',40),1,40)                // 034 a 073 (040) Nome da Empresa
                      ,''
                      )+

                //Itau
                IfThen(Banco = bItau,
                      Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2NOME.AsString))+Replicate(' ',30),1,30)              + // 034 a 063 (030) Nome da Empresa
                      Replicate(' ',10), ''                                                                                 // 064 a 073 (010) COMPLEMENTO DE REGISTRO
                      )+

                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2ENDERE.AsString))+Replicate(' ',40),1,40)                  + // 074 a 113 (040) Endereço
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2COMPLE.AsString))+Replicate(' ',15),1,15)                  + // 114 a 128 (015) Bairro
                Copy(UpperCase(Form7.IbDataSet2CEP.AsString)+Replicate(' ',5),1,005)                                      + // 129 a 133 (005) CEP
                Copy(UpperCase(Form7.IbDataSet2CEP.AsString)+Replicate(' ',3),7,003)                                      + // 134 a 136 (003) Sufixo do CEP
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2CIDADE.AsString))+Replicate(' ',15),1,15)                  + // 137 a 151 (015)Cidade
                Copy(UpperCase(ConverteAcentos(Form7.IbDataSet2ESTADO.AsString))+Replicate(' ',2),1,2)                    + // 152 a 153 (002) Unidade da Federação

                // Avalista
                Copy('0',1,1)                                                                             + // 154 a 154 (001) Tipo de Inscrição da Empresa Avalista
                Copy(Replicate('0',15),1,015)                                                             + // 155 a 169 (015) Número de Inscrição da Empresa avalista
                Copy(Replicate(' ',40),1,040)                                                             + // 170 a 209 (040) Nome da Empresa avalista

                Copy(Replicate('0',3),1,3)                                                                + // 210 a 212 (003) Cód. Bco. Corresp. na Compensação
                Copy(Replicate(' ',20),1,20)                                                              + // 213 a 232 (020) Nosso Nº no Banco Correspondente 213 a 232 (020)
                Copy(Replicate(' ',8),1,8)                                                                  // 233 a 240 (008) Uso Exclusivo FEBRABAN / CNAB
                );

              //Mauricio Parizotto 2023-10-03
              // Registro Detalhe – Segmento R “exclusivo para cobrança de multa” – Remessa)
              if (Form7.ibDataSet7VALOR_MULTA.AsFloat > 0) or (Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat > 0) then
              begin
                iReg := iReg + 1;
                GeraCNAB240SegmentoR(F,iReg,sComandoMovimento,Banco);
              end;

            except
              on E: Exception do
              begin
                //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
                MensagemSistema(E.Message,msgErro);
              end;
            end;
          except
            on E: Exception do
            begin
              //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message,msgErro);
            end;
          end;

          try
            vTotal := vTotal + Form7.ibDataSet7VALOR_DUPL.AsFloat;
          except
            on E: Exception do
            begin
              //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
              MensagemSistema(E.Message,msgErro);
            end;
          end;
        end;
      end;

      Form7.ibDataSet7.Next;
    end;

    try
      // Registro Trailer de Lote (Tipo = 5)
      WriteLn(F,
        Copy(AllTrim(Form26.MaskEdit42.Text),1,3)     + // 001 a 003 (003) Código do Banco na Compensação
        '0001'                                        + // 004 a 007 (004) Lote de Serviço
        '5'                                           + // 008 a 008 (001) Tipo de Registro
        Copy(Replicate(' ',9),1,9)                    + // 009 a 017 (009) Uso Exclusivo FEBRABAN/CNAB
        Copy(StrZero(iReg,6,0),1,006)                 + // 018 a 023 (006) Quantidade de Registros do Lote
        Copy(StrZero(0,92,0),1,092)                   + // 024 a 115 (092) Zeros
        Copy(Replicate(' ',125),1,125)                  // 116 a 240 (125) Brancos
        );

      // Registro Trailer de Arquivo (Tipo = 9)
      WriteLn(F,
        Copy(AllTrim(Form26.MaskEdit42.Text),1,3) +   // 001 a 003 (003) Código do Banco na Compensação
        Copy('9999',1,004)                        +   // 004 a 007 (004) Lote de Serviço
        Copy('9',1,004)                           +   // 008 a 008 (001) Tipo de Registro
        Copy(Replicate(' ',9),1,9)                +   // 009 a 017 (009) Uso Exclusivo FEBRABAN/CNAB
        Copy(StrZero(iLote,6,0),1,006)            +   // 018 a 023 (006) Quantidade de Lotes do Arquivo
        Copy(StrZero(iReg+2,6,0),1,006)           +   // 024 a 029 (006) Quantidade de Registros do Arquivo
        Copy(StrZero(0,6,0),1,006)                +   // 030 a 035 (006) Qtde de Contas p/ Conc. (Lotes)
        Copy(Replicate(' ',205),1,205)                // 036 a 240 (205) Uso Exclusivo FEBRABAN/CNAB
        );

      CloseFile(F); // Fecha o arquivo
    except
      on E: Exception do
      begin
        //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
        MensagemSistema(E.Message,msgErro);
      end;
    end;

    if iReg = 2 then
    begin
      DeleteFile(Form1.sAtual+'\remessa\'+Form1.sArquivoRemessa);
      Form1.sArquivoRemessa := '';

      //ShowMessage('Não existe movimento, o arquivo não foi gerado.');
      MensagemSistema('Não existe movimento, o arquivo não foi gerado.',msgAtencao);
    end;
  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar(E.Message),'Atenção',mb_Ok + MB_ICONWARNING);  Mauricio Parizotto 2023-10-25
      MensagemSistema(E.Message,msgErro);
    end;
  end;

  Form7.ibDataSet7.EnableControls;
end;

procedure GeraCNAB240SegmentoR(var F: TextFile; iReg : integer; sComandoMovimento : string; Banco : TBanco);
var
  vMulta : Double;
  vDataMulta : TDateTime;
  TipoMulta : string;
begin
  //Mauricio Parizotto 2023-12-11
  if Banco = bUnicred then
  begin
    GeraCNAB240SegmentoR_Unicred(F, iReg, sComandoMovimento);
    Exit;
  end;

  //Tipo de Multa
  if Form7.ibDataSet7VALOR_MULTA.AsFloat > 0 then
  begin
    vMulta    := Form7.ibDataSet7VALOR_MULTA.AsFloat;
    TipoMulta := '1';
  end;

  if Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat > 0 then
  begin
    vMulta    := Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat;
    TipoMulta := '2';
  end;

  vDataMulta := IncDay(Form7.ibDataSet7VENCIMENTO.AsDateTime, 1);

  if Banco = bAilos then
  begin
    vDataMulta := Form7.ibDataSet7VENCIMENTO.AsDateTime;
  end;

  WriteLn(F,
                Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
                Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
                copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
                Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
                Copy('R',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
                Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
                Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa

                //Desconto 2
                Copy('0',1,1)                                                                             + // 018 a 018 (001) Código do Desconto
                Copy(Replicate('0',8),1,8)                                                                + // 019 a 026 (008) Data do Desconto
                Copy(Replicate('0',15),1,15)                                                              + // 027 a 041 (013)+(2) Valor/Percentual do Desconto

                //Desconto 3
                Copy('0',1,1)                                                                             + // 042 a 042 (001) Código do Desconto
                Copy(Replicate('0',8),1,8)                                                                + // 043 a 050 (008) Data do Desconto
                Copy(Replicate('0',15),1,15)                                                              + // 051 a 065 (013)+(2) Valor/Percentual do Desconto

                //Multa
                Copy(TipoMulta,1,1)                                                                       + // 066 a 066 (001) Código da Multa
                Copy(Copy(DateToStr(vDataMulta),1,2)                                                      +
                Copy(DateToStr(vDataMulta),4,2)                                                           +
                Copy(DateToStr(vDataMulta),7,4),1,008)                                                    + // 067 a 074 (008) Data da Multa
                Copy(StrZero((vMulta * 100),15,0),1,015)                                                  + // 075 a 089 (013)+(2) Valor/Percentual da Multa

                //Outros
                Copy(Replicate(' ',10),1,10)                                                              + // 090 a 099 (010) Informação ao Pagador
                Copy(Replicate(' ',40),1,40)                                                              + // 100 a 139 (040) Mensagem 3
                Copy(Replicate(' ',40),1,40)                                                              + // 140 a 179 (040) Mensagem 4
                Copy(Replicate(' ',20),1,20)                                                              + // 180 a 199 (020) Uso Exclusivo FEBRABAN / CNAB
                Copy(Replicate('0',8),1,8)                                                                + // 200 a 207 (008) Data Limite de Pagamento(SICOOB) | Cód. Ocor. do Sacado (AILOS)

                //Dados Para Débito
                IfThen(Banco <> bSicoob,
                      Replicate(' ',3)                                                                    + // 208 a 210 (003) Código do Banco na Conta Débito
                      Replicate(' ',5)                                                                      // 211 a 215 (005) Código da Agência na Conta Débito
                      ,''
                      )+

                IfThen(Banco = bSicoob,
                      Replicate('0',3)                                                                    + // 208 a 210 (003) Código do Banco na Conta Débito
                      Replicate('0',5)                                                                      // 211 a 215 (005) Código da Agência na Conta Débito
                      ,''
                      )+

                Copy(Replicate(' ',1),1,1)                                                                + // 216 a 216 (001) Dígito Verificador da Agência

                IfThen(Banco <> bSicoob,
                      Replicate(' ',12)                                                                     // 217 a 228 (012) Conta Corrente na Conta Débito
                      ,''
                      )+
                IfThen(Banco = bSicoob,
                      Replicate('0',12)
                      ,''                                                                                   // 217 a 228 (012) Conta Corrente na Conta Débito
                      )+

                Copy(Replicate(' ',1),1,1)                                                                + // 229 a 229 (001) Dígito Verificador da Conta
                Copy(Replicate(' ',1),1,1)                                                                + // 230 a 230 (001) Dígito Verificador da Agencia/Conta
                Copy(Replicate(sAvisoDebitoAuto,1),1,1)                                                   + // 231 a 231 (001) Aviso para Débito Automático
                Copy(Replicate(' ',9),1,9)                                                                  // 232 a 240 (009) Uso Exclusivo FEBRABAN / CNAB
                );
  
end;

procedure GeraCNAB240SegmentoHeaderL_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string;
        sLayoutdoLote, sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo, sCodigoDoconvenio,
        sNumeroContratoOP : string;
        iRemessa : integer);
begin
  // Registro Header de Lote (Tipo = 1)
  WriteLn(F,Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                             + // 001 a 003 (003) Código do Banco na Compensação
        '0001'                                                                                    + // 004 a 007 (004) Lote de Serviço
        '1'                                                                                       + // 008 a 008 (001) Tipo de Registro
        'R'                                                                                       + // 009 a 009 (001) Tipo de Operação
        '01'                                                                                      + // 010 a 011 (002) Tipo de Serviço
        Replicate(' ',002)                                                                        + // 012 a 013 (002) Uso Exclusivo da FEBRABAN/CNAB
        Copy(sLayoutdoLote,1,3)                                                                   + // 014 a 016 (003) Nº da Versão do Layout do Lote
        ' '                                                                                       + // 017 a 017 (001) Uso Exclusivo da FEBRABAN/CNAB
        Copy('2',1,1)                                                                             + // 018 a 018 (001) Tipo de Inscrição da Empresa
        Copy(Right(Replicate('0',15)+LimpaNumero(Form7.IBDataSet13CGC.AsString),15),1,015)        + // 019 a 033 (015) Número de Inscrição da Empresa
        copy(sCodigoDoconvenio,1,20)                                                              + // 034 a 053 (020) Código do Convênio no Banco
        Copy('0'+sAgencia,1,5)                                                                    + // 054 a 058 (005) Agência Mantenedora da Conta
        Copy(sDVdaAgencia,1,1)                                                                    + // 059 a 059 (001) Dígito Verificador da Agência
        '0'+ sNumeroContaCorrente + Copy(sDigitocontacorrente,1,1)                                + // 060 a 073 (014) Número da Conta Corrente
        Copy(UpperCase(Form7.IbDataSet13NOME.AsString)+Replicate(' ',30),1,030)                   + // 074 a 103 (030) Nome da Empresa
        Replicate(' ',40)                                                                         + // 104 a 143 (040) Mensagem 1
        Replicate(' ',40)                                                                         + // 144 a 183 (040) Mensagem 2
        Copy(StrZero(iRemessa,8,0),1,008)                                                         + // 184 a 191 (008) Número Remessa/Retorno
        Copy(Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),7,4),1,008) + // 192 a 199 (008) Data de Gravação Remessa/Retorno
        Copy('00000000',1,8)                                                                      + // 200 a 207 (008) Data do Crédito
        Replicate('0',2)                                                                          + // 208 a 209 (002) Files
        Replicate(' ',31)                                                                           // 210 a 240 (031) Uso Exclusivo FEBRABAN / CNAB
        );
end;


procedure GeraCNAB240SegmentoP_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string;
  sAgencia, sDVdaAgencia, sNumeroContaCorrente, sDigitocontacorrente, sNumerodoDocumento, sEspecieDoTitulo,
  sCodigodoJurosdeMora, sNumeroContratoOP : string);
var
  vMulta : Double;
  TipoMulta : string;
begin
  //Mauricio Parizotto 2024-04-03
  if Form1.fTaxa = 0 then
    sCodigodoJurosdeMora := '5'; //Isento

  WriteLn(F,
          Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
          Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
          copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
          Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
          Copy('P',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
          Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
          Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa
          Copy('0'+Copy(sAgencia+'0000-0',1,4),1,5)                                                 + // 018 a 022 (005) Agência Mantenedora da Conta
          Copy(sDVdaAgencia,1,1)                                                                    + // 023 a 023 (001) Dígito Verificador da Agência
          Copy(sNumeroContaCorrente,1,12)                                                           + // 024 a 035 (012) Número da Conta Corrente
          Copy(sDigitocontacorrente,1,1)                                                            + // 036 a 036 (001) Dígito Verificador da Conta
          Copy(' ',1,1)                                                                             + // 037 a 037 (001) Dígito Verificador da Ag/Conta
          Copy(LimpaNumero(Form7.ibDataset7NOSSONUM.AsString),1,11)                                 + // 038 a 048 (011) Número do Documento de Cobrança
          Replicate(' ',8)                                                                          + // 049 a 056 (008) COMPLEMENTO DE REGISTRO
          '21'                                                                                      + // 057 a 058 (002) Código da Carteira
          Replicate(' ',4)                                                                          + // 059 a 062 (004) COMPLEMENTO DE REGISTRO
          Copy(sNumerodoDocumento,1,15)                                                             + // 063 a 077 (015) Número do Documento de Cobrança
          Copy(Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2)                           +
          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)                                +
          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),7,4),1,008)                         + // 078 a 085 (008) Data de Vencimento do Título
          Copy(StrZero((Form7.ibDataSet7VALOR_DUPL.AsFloat * 100),15,0),1,015)                      + // 086 a 100 (013)+(2) Valor Nominal do Título
          Copy('00000',1,5)                                                                         + // 101 a 105 (005) Agência Encarregada da Cobrança
          Copy(' ',1,001)                                                                           + // 106 a 106 (001) Dígito Verificador da Agência
          Copy(sEspecieDoTitulo,1,2)                                                                + // 107 a 108 (002) Espécie do Título
          Copy('N',1,1)                                                                             + // 109 a 109 (001) Identific. de Título Aceito/Não Aceito
          Copy(Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),1,2)                              +
          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),4,2)                                   +
          Copy(DateToStr(Form7.ibDataSet7EMISSAO.AsDateTime),7,4),1,008)                            + // 110 a 117 (008) Data da Emissão do Título
          Copy(sCodigodoJurosdeMora,1,1)                                                            + // 118 a 118 (001) Código do Juros de Mora
          Replicate(' ',8)                                                                          + // 119 a 126 (008) Branco
          Copy(StrZero((Form1.fTaxa * 30 * 100),15,0),1,015)                                        + // 127 a 141 (013)+(2) Juros de Mora por Dia/Taxa
          Copy('0',1,1)                                                                             + // 142 a 142 (001) Código do Desconto
          Copy('00000000',1,8)                                                                      + // 143 a 150 (008) Data do Desconto
          Copy(StrZero(0,15,0),1,015)                                                               + // 151 a 165 (013)+(2) Valor / Percentual a ser Concedido
          Replicate(' ',15)                                                                         + // 166 a 180 (015) Branco
          Copy('000000000000000',1,15)                                                              + // 181 a 195 (013)+(2) Valor do Abatimento
          Copy(AllTrim(Form7.ibDataset7DOCUMENTO.AsString)+Replicate(' ',25),1,25)                  + // 196 a 220 (025) Identificação do Título na Empresa
          Copy('3',1,1)                                                                             + // 221 a 221 (001) Código para Protesto
          Copy('00',1,2)                                                                            + // 222 a 223 (002) Número de Dias para Protesto
          Replicate(' ',4)                                                                          + // 224 a 227 (004) Branco
          '09'                                                                                      + // 228 a 229 (002) Código da Moeda
          Copy(Right(sNumeroContratoOP,10),1,10)                                                    + // 230 a 239 (10) Nº do Contrato da Operação de Créd.
          Copy(' ',1,1)                                                                               // 240 a 240 (001) Uso Exclusivo FEBRABAN / CNAB
          );

end;


procedure GeraCNAB240SegmentoR_Unicred(var F: TextFile; iReg : integer; sComandoMovimento : string);
var
  vMulta : Double;
  TipoMulta : string;
begin
  //Tipo de Multa
  if Form7.ibDataSet7VALOR_MULTA.AsFloat > 0 then
  begin
    vMulta    := Form7.ibDataSet7VALOR_MULTA.AsFloat;
    TipoMulta := '1';
  end;

  if Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat > 0 then
  begin
    vMulta    := Form7.ibDataSet7PERCENTUAL_MULTA.AsFloat;
    TipoMulta := '2';
  end;

  WriteLn(F,
          Copy(AllTrim(Form26.MaskEdit42.Text),1,3)                                                 + // 001 a 003 (003) Código do Banco na Compensação
          Copy('0001',1,4)                                                                          + // 004 a 007 (004) Lote de Serviço
          copy('3',1,1)                                                                             + // 008 a 008 (001) Tipo de Registro
          Copy(StrZero(iReg-2,5,0),1,005)                                                           + // 009 a 013 (005) Nº Sequencial do Registro no Lote
          Copy('R',1,1)                                                                             + // 014 a 014 (001) Cód. Segmento do Registro Detalhe
          Copy(' ',1,1)                                                                             + // 015 a 015 (001) Uso Exclusivo FEBRABAN/CNAB
          Copy(sComandoMovimento,1,2)                                                               + // 016 a 017 (002) Código de Movimento Remessa
          Replicate(' ',48)                                                                         + // 018 a 065 (048) Branco

          //Multa
          Copy(TipoMulta,1,1)                                                                       + // 066 a 066 (001) Código da Multa
          Replicate(' ',8)                                                                          + // 067 a 074 (008) Branco
          Copy(StrZero((vMulta * 100),15,0),1,015)                                                  + // 075 a 089 (013)+(2) Valor/Percentual da Multa

          //Outros
          Replicate(' ',10)                                                                         + // 090 a 099 (010) Informação ao Pagador
          Replicate(' ',40)                                                                         + // 100 a 139 (040) Mensagem 3
          Replicate(' ',40)                                                                         + // 140 a 179 (040) Mensagem 4
          Replicate(' ',20)                                                                         + // 180 a 199 (020) Uso Exclusivo FEBRABAN / CNAB
          Replicate(' ',32)                                                                         + // 200 a 231 (032) Branco
          Replicate(' ',9)                                                                            // 232 a 240 (009) Uso Exclusivo FEBRABAN / CNAB
          );
  
end;


end.
