unit uDiagnosticoIA;

interface

uses
  Data.DB
  , IBX.IBDatabase
  , System.SysUtils
  , uClassesDashboard
  , IBX.IBQuery
  , DateUtils
  ;

  function GeraDiagnosticoIA(iPeriodo : integer; Transaction : TIBTransaction):boolean;
  procedure GravaDiagnosticoIA(sDadosEnviados, sDadosRetornados : string; Data : TDateTime; iPeriodo : integer; Transaction : TIBTransaction);
  function GeraPromptEnvio(sDadosEnviados:string):string;
  function DeveGerarDiagnosticoIA(out iPeriodo : integer; Transaction : TIBTransaction):boolean;

implementation

uses uFuncoesBancoDados
  , uInteligenciaArtificial
  , smallfunc_xe;

function GeraDiagnosticoIA(iPeriodo : integer; Transaction : TIBTransaction):boolean;
var
  sDadosEnvio, sPromptEnvio, sDiagnostico, sAPIKey : string;
begin
  //Gera dados a serem analisados
  sDadosEnvio  := ' -Vendas m�s atual: 234249,64 '+sLineBreak+
                  ' -Vendas m�s anterior: 266588,06 '+sLineBreak+
                  ' -Contas a receber no m�s: 117718,51'+sLineBreak+
                  ' -Contas recebidas no m�s: 1916,00'+sLineBreak+
                  ' -Contas a receber vencidas no m�s: 113062,54 '+sLineBreak+
                  ' -Contas a pagar no m�s: 206367,89'+sLineBreak+
                  ' -Contas pagas no m�s: 7688,29 '+sLineBreak+
                  ' -Contas a pagar vencidas no m�s: 187804.94'+sLineBreak+
                  ' -Inadimpl�ncia no trimestre: 99,60%';

  sPromptEnvio := GeraPromptEnvio(sDadosEnvio);

  //Busca API Key a ser utilizada
  sAPIKey      := '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';

  //Gera diaginostico pela IA
  TInteligenciaArtificial.New
                         .setAPIKey(sAPIKey)
                         .setPrompt(sPromptEnvio)
                         .Perguntar('Qual sua opni�o e anl�lise?')
                         .Resposta(sDiagnostico);



  //Grava dados no banco de dados
  if sDiagnostico <> '' then
  begin
    GravaDiagnosticoIA(sDadosEnvio,
                      sDiagnostico,
                      now,
                      iPeriodo,
                      Transaction);
  end;
end;


procedure GravaDiagnosticoIA(sDadosEnviados, sDadosRetornados : string; Data : TDateTime; iPeriodo : integer; Transaction : TIBTransaction);
var
  sSQL : string;
begin
  sDadosRetornados := Copy(sDadosRetornados,1,2000);

  sSQL := ' Insert into DIAGNOSTICOIA (IDDIAGNOSTICO, DATA, DADOSENVIADOS, DADOSRETORNADOS, PERIODO) '+
          ' Values ('+
          '(select gen_id(G_DIAGNOSTICOIA,1) from rdb$database), '+
          QuotedStr(DateToBD(Data))+','+
          QuotedStr(sDadosEnviados)+','+
          QuotedStr(sDadosRetornados)+','+
          iPeriodo.ToString+
          ')';

  ExecutaComando(sSQL,Transaction);
end;

function GeraPromptEnvio(sDadosEnviados:string):string;
begin
  Result := '#Identidade'+sLineBreak+
            'Voc� � um Chatbot especialista em an�lise de opera��es de empresas de vendas.'+sLineBreak+
            'Interaja com o cliente com as seguintes #Informa��es:'+sLineBreak+
            sDadosEnviados+sLineBreak+
            '#Regras para as respostas'+sLineBreak+
            '- Interaja com base nas #informa��es fornecidas.'+sLineBreak+
            '- N�o fa�a perguntas ao usu�rio, apenas responda.'+sLineBreak+
            '- Responda sempre em Portugu�s Brasileiro.'+sLineBreak+
            '- N�o fale quem � voc�.'+sLineBreak+
            '- Troque a palavra sugiero por sugiro.'+sLineBreak+
            '- N�o sugira que o cliente fa�a perguntas.'+sLineBreak+
            '- N�o diga que � uma an�lise.'+sLineBreak+
            '- N�o diga que a resposta � com base nas informa��es fornecidas.';

end;


function DeveGerarDiagnosticoIA(out iPeriodo : integer; Transaction : TIBTransaction):boolean;
var
  iDia, iMes, iAno : Integer;
  sFiltro, sDataIni, sDataFim : string;
begin
  Result := False;

  iDia  :=  DayOf(now);
  iMes  :=  MonthOf(now);
  iAno  :=  YearOf(now);

  if iDia <= 7 then
  begin
    iPeriodo := 1;
    sDataIni := DateToStr( IncDay(Now,iDia*-1) );
    sFiltro  := ' Where DATA = '+QuotedStr(sDataIni)+
                '  and PERIODO = '+iPeriodo.ToString;
  end;

  if (iDia >= 8)
    and (iDia <=14) then
  begin
    iPeriodo := 2;
    sDataIni := iAno.ToString + '-'+ StrZero(iMes,2,0) + '-08';
    sDataFim := iAno.ToString + '-'+ StrZero(iMes,2,0) + '-14';
    sFiltro  := ' Where DATA BETWEEN '+QuotedStr(sDataIni) + ' and '+QuotedStr(sDataFim)+
                '  and PERIODO = '+iPeriodo.ToString;
  end;

  if (iDia >= 15)
    and (iDia <=21) then
  begin
    iPeriodo := 3;
    sDataIni := iAno.ToString + '-'+ StrZero(iMes,2,0) + '-15';
    sDataFim := iAno.ToString + '-'+ StrZero(iMes,2,0) + '-21';
    sFiltro  := ' Where DATA BETWEEN '+QuotedStr(sDataIni) + ' and '+QuotedStr(sDataFim)+
                '  and PERIODO = '+iPeriodo.ToString;
  end;

  if iDia >= 22 then
  begin
    iPeriodo := 4;
    sDataIni := iAno.ToString + '-'+ StrZero(iMes,2,0) + '-22';
    sFiltro  := ' Where DATA > = '+QuotedStr(sDataIni)+
                '  and PERIODO = '+iPeriodo.ToString;
  end;

  Result := ExecutaComandoEscalar(Transaction,
                                  ' Select Count(*)'+
                                  ' From DIAGNOSTICOIA'+
                                  sFiltro
                                  ) = 0;


  //Verifica movimento
  if Result then
  begin
    //1 - Movimento 2 �ltimos meses
    //2 - Movimento m�s
    //3 - Contas a receber no m�s
    //4 - Movimento no �ltimo m�s
  end;
end;

end.
