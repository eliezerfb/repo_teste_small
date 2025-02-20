unit uDiagnosticoIA;

interface

uses
  Data.DB
  , IBX.IBDatabase
  , System.SysUtils
  , uClassesDashboard
  , IBX.IBQuery
  , DateUtils
  , REST.Types
  , Rest.JSON
  , REST.Json.Types
  ;

type
  TRetChaveIA = class
  private
    [JSONName('token_ia')]
    FTokenIa: string;
  published
    property TokenIa: string read FTokenIa write FTokenIa;
  end;

  function GeraDiagnosticoIA(iPeriodo : integer; IBDatabase: TIBDatabase):boolean;
  procedure GravaDiagnosticoIA(sDadosEnviados, sDadosRetornados : string; Data : TDateTime; iPeriodo : integer; Transaction : TIBTransaction);
  function GeraPromptEnvio(sDadosEnviados:string):string;
  function DeveGerarDiagnosticoIA(out iPeriodo : integer; IBDatabase: TIBDatabase):boolean;
  function GetDadosEnvio(iPeriodo : integer; out bDadosInsuf : boolean; Transaction : TIBTransaction):string;
  function GetApiKeyIA : string;

implementation

uses uFuncoesBancoDados
  , uInteligenciaArtificial
  , smallfunc_xe
  , uDashboard
  , uWebServiceSmall
  , uconstantes_chaves_privadas;

function GeraDiagnosticoIA(iPeriodo : integer; IBDatabase: TIBDatabase):boolean;
var
  sDadosEnvio, sPromptEnvio, sDiagnostico, sAPIKey, sPergunta : string;
  Transaction: TIBTransaction;
  IBDatabaseDash: TIBDatabase;
  DataRef : TDate;
  bDadosInsuf : boolean;
begin
  Result := False;

  try
    IBDatabaseDash := CriaConexaoClone(IBDatabase);
    Transaction := TIBTransaction.Create(nil);
    Transaction.DefaultDatabase := IBDatabaseDash;
    IBDatabaseDash.DefaultTransaction := Transaction;
    IBDatabaseDash.Connected := True;

    sDadosEnvio  := GetDadosEnvio(iPeriodo, bDadosInsuf, Transaction);

    if bDadosInsuf then
    begin
      Result := True;
      Exit;
    end;
    
    sPromptEnvio := GeraPromptEnvio(sDadosEnvio);

    //Busca API Key a ser utilizada
    sAPIKey      := GetApiKeyIA;

    if iPeriodo = 4 then
      sPergunta := 'Analise os dados, diga como está a saúde da minha empesa e o que eu posso melhorar'
    else
      sPergunta := 'Analise os dados e me diga o que eu posso melhorar';

    //Gera diaginostico pela IA
    TInteligenciaArtificial.New
                           .setAPIKey(sAPIKey)
                           .setPrompt(sPromptEnvio)
                           .Perguntar(sPergunta)
                           .Resposta(sDiagnostico);


    //Grava dados no banco de dados
    DataRef := now;

    if iPeriodo = 1 then
    begin
      var iDia : integer;

      iDia    := DayOf(now);
      DataRef := IncDay(Now,iDia*-1);
    end;

    if sDiagnostico <> '' then
    begin
      GravaDiagnosticoIA(sDadosEnvio,
                        sDiagnostico,
                        DataRef,
                        iPeriodo,
                        Transaction);
    end;
    
    Result := True;
  finally
    FreeAndNil(Transaction);
    FreeAndNil(IBDatabaseDash);
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
            'Você é um Chatbot especialista em análise de operações de empresas de vendas.'+sLineBreak+
            'Interaja com o cliente com as seguintes #Informações:'+sLineBreak+
            sDadosEnviados+sLineBreak+
            '#Regras para as respostas'+sLineBreak+
            '- Interaja com base nas #informações fornecidas.'+sLineBreak+
            '- Não faça perguntas ao usuário, apenas responda.'+sLineBreak+
            '- Responda sempre em Português Brasileiro.'+sLineBreak+
            '- Não fale quem é você.'+sLineBreak+
            '- Troque a palavra sugiero por sugiro.'+sLineBreak+
            '- Não sugira que o cliente faça perguntas.'+sLineBreak+
            '- Não diga que é uma análise.'+sLineBreak+
            '- Não diga que a resposta é com base nas informações fornecidas.';

end;


function DeveGerarDiagnosticoIA(out iPeriodo : integer; IBDatabase: TIBDatabase):boolean;
var
  iDia, iMes, iAno : Integer;
  sFiltro, sDataIni, sDataFim : string;

  Transaction: TIBTransaction;
  IBDatabaseDash: TIBDatabase;
begin
  Result := False;

  iDia  :=  DayOf(now);
  iMes  :=  MonthOf(now);
  iAno  :=  YearOf(now);

  if iDia <= 7 then
  begin
    iPeriodo := 1;
    sDataIni := FormatDateTime('YYYY-MM-DD',IncDay(Now,iDia*-1) );
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
    sFiltro  := ' Where DATA >= '+QuotedStr(sDataIni)+
                '  and PERIODO = '+iPeriodo.ToString;
  end;

  try
    IBDatabaseDash := CriaConexaoClone(IBDatabase);
    Transaction := TIBTransaction.Create(nil);
    Transaction.DefaultDatabase := IBDatabaseDash;
    IBDatabaseDash.DefaultTransaction := Transaction;
    IBDatabaseDash.Connected := True;

    Result := ExecutaComandoEscalar(Transaction,
                                    ' Select Count(*)'+
                                    ' From DIAGNOSTICOIA'+
                                    sFiltro
                                    ) = 0;
  finally
    FreeAndNil(Transaction);
    FreeAndNil(IBDatabaseDash);
  end;
end;

function GetDadosEnvio(iPeriodo : integer; out bDadosInsuf : boolean; Transaction : TIBTransaction):string;
var
  DadosDTO : TRootDadosDTO;

  function GetDadosPeriodo01:string;
  var
    Data1, Data2 : TDate;  
    iDia : integer;
  begin
    Result := '';
    DadosDTO.GetDadosP1;

    iDia  := DayOf(now);
    Data1 := IncDay(Now,iDia*-1);

    iDia  := DayOf(Data1);
    Data2 := IncDay(Data1,iDia*-1);

    Result := '-Vendas '+FormatDateTime('dd/mm', Data1) + ': ' + Formatfloat('#,##0.00', DadosDTO.VendasPeriodo[1].VendasMes)+sLineBreak+
              '-Vendas '+FormatDateTime('dd/mm', Data2) + ': ' + Formatfloat('#,##0.00', DadosDTO.VendasPeriodo[2].VendasMes)+sLineBreak;

    if (DadosDTO.VendasPeriodo[1].VendasMes = 1)
      or (DadosDTO.VendasPeriodo[1].VendasMes = 2) then
      bDadosInsuf := True;
  end;

  function GetDadosPeriodo02:string;
  var
    i : integer;
    dAcumulado : Double;
  begin
    Result := '';
    DadosDTO.GetDadosP2;

    dAcumulado := 0;
    
    for I := Low(DadosDTO.VendasPeriodo[0].VendasDiarias) to High(DadosDTO.VendasPeriodo[0].VendasDiarias) do
    begin
      if DadosDTO.VendasPeriodo[0].VendasDiarias[i].Valor > 0 then
      begin
        Result := Result + '-Vendas dia '+DadosDTO.VendasPeriodo[0].VendasDiarias[i].Dia+': '+
                            Formatfloat('#,##0.00',DadosDTO.VendasPeriodo[0].VendasDiarias[i].Valor )+sLineBreak;

        dAcumulado := dAcumulado + DadosDTO.VendasPeriodo[0].VendasDiarias[i].Valor;
      end;
    end;

    if dAcumulado = 0 then
      bDadosInsuf := True;
  end;

  function GetDadosPeriodo03:string;
  begin
    Result := '';
    DadosDTO.GetDadosP3;

    Result := '-Contas a receber no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.ReceberMes)+sLineBreak+
              '-Contas recebidas no mês até o momento: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.RecebidasMes)+sLineBreak+
              '-Contas a receber vencidas no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.ValorVencidasMes)+sLineBreak+
              '-Inadimplência no trimestre: '+Formatfloat('#,##0.00',DadosDTO.Inadimplencia.Trimestre)+sLineBreak;

    if DadosDTO.ContasReceber.ReceberMes = 0 then
      bDadosInsuf := True;
  end;

  function GetDadosPeriodo04:string;
  begin
    Result := '';
    DadosDTO.GetDadosP4;

    Result := '-Vendas até o momento: '+ Formatfloat('#,##0.00',DadosDTO.VendasPeriodo[0].VendasMes)+sLineBreak+
              //'-Média de venda diaria: '+
              '-Contas a receber no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.ReceberMes)+sLineBreak+
              '-Contas recebidas no mês até o momento: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.RecebidasMes)+sLineBreak+
              '-Contas a receber vencidas no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasReceber.ValorVencidasMes)+sLineBreak+
              '-Contas a pagar no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasPagar.PagarMes)+sLineBreak+
              '-Contas pagas no mês até o momento: '+Formatfloat('#,##0.00',DadosDTO.ContasPagar.PagasMes)+sLineBreak+
              '-Contas a pagar vencidas no mês: '+Formatfloat('#,##0.00',DadosDTO.ContasPagar.ValorVencidasMes)+sLineBreak+
              '-Saldo do caixa: '+Formatfloat('#,##0.00',DadosDTO.SaldoCaixa)+sLineBreak;

    if DadosDTO.VendasPeriodo[1].VendasMes = 0 then
      bDadosInsuf := True;
  end;
begin
  try
    bDadosInsuf := False;
  
    DadosDTO := TRootDadosDTO.Create;
    DadosDTO.setTransaction(Transaction);
    DadosDTO.FiltroNatVendas := getFiltroVendas(Transaction);

    case iPeriodo of
      1 : Result := GetDadosPeriodo01;
      2 : Result := GetDadosPeriodo02;
      3 : Result := GetDadosPeriodo03;
      4 : Result := GetDadosPeriodo04;
    end;
  finally
    FreeAndNil(DadosDTO);
  end;
end;

function GetApiKeyIA : string;
var
  jsonRet : string;
  StatusCode : integer;
  RetChaveIA : TRetChaveIA;
begin
  //Padrão
  Result := SMALL_TOKEN_IA_DEF;

  try
    if RequisicaoSmall(rmPOST,
                      'https://smallsoft.com.br/token-ia',
                      '{"hashIa": "'+SMALL_HAS_API+'"}',
                      jsonRet,
                      StatusCode) then
    begin
      try
        RetChaveIA := TJson.JsonToObject<TRetChaveIA>(jsonRet);
        Result := RetChaveIA.TokenIa;
      finally
        FreeAndNil(RetChaveIA);
      end;
    end;
  except
  end;
end;

end.
