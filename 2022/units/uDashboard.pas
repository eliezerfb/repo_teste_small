unit uDashboard;

interface

uses
  Data.DB
  , IBX.IBDatabase
  , System.SysUtils
  , REST.Json
  , uClassesDashboard
  , IBX.IBQuery
  ;

  function GetdDadosDashboard(out sJson : string; IBDatabase: TIBDatabase):boolean;
  function getFiltroVendas(Transaction : TIBTransaction):string;
  procedure GeraDiagnosticoIA(Transaction : TIBTransaction);
  procedure GravaDiagnosticoIA(sDadosEnviados, sDadosRetornados : string; Data : TDateTime; Transaction : TIBTransaction);
  function GeraPromptEnvio(sDadosEnviados:string):string;

implementation

uses uFuncoesBancoDados
  , uArquivosDAT
  , uInteligenciaArtificial
  , uListaToJson;


function GetdDadosDashboard(out sJson : string; IBDatabase: TIBDatabase):boolean;
var
  DadosDTO : TRootDadosDTO;
  Transaction: TIBTransaction;
  IBDatabaseDash: TIBDatabase;
begin
  Result := False;
  sJson  := '';

  try
    try
      //Cria Conexão para thread clonando da principal
      IBDatabaseDash := TIBDatabase.Create(nil);
      IBDatabaseDash.Params       := IBDatabase.Params;
      IBDatabaseDash.DatabaseName := IBDatabase.DatabaseName;
      IBDatabaseDash.ServerType   := IBDatabase.ServerType;
      IBDatabaseDash.LoginPrompt  := False;

      Transaction := TIBTransaction.Create(nil);
      Transaction.DefaultDatabase := IBDatabaseDash;
      IBDatabaseDash.DefaultTransaction := Transaction;

      IBDatabaseDash.Connected := True;

      DadosDTO := TRootDadosDTO.Create;
      DadosDTO.setTransaction(Transaction);
      DadosDTO.FiltroNatVendas := getFiltroVendas(Transaction);
      DadosDTO.GetDados;
      sJson := TJson.ObjectToJsonString(DadosDTO);

      GeraDiagnosticoIA(Transaction);

      Result := True;
    finally
      FreeAndNil(Transaction);
      FreeAndNil(IBDatabaseDash);
      FreeAndNil(DadosDTO);
    end;
  except
  end;
end;


function getFiltroVendas(Transaction : TIBTransaction):string;
var
  ConfSistema : TArquivosDAT;
  sJsonFiltro, sOperacoes : string;
  Parametros : TParametros;
  i : integer;
begin
  Result := '';

  try
    try
      ConfSistema := TArquivosDAT.Create('',Transaction);
      sJsonFiltro := ConfSistema.BD.Dashboard.NaturezasVenda;
    finally
      FreeAndNil(ConfSistema);
    end;

    if Trim(sJsonFiltro) <> '' then
    begin
      try
        sOperacoes := QuotedStr('XXXXX');

        Parametros := TParametros.Create(sJsonFiltro);
        for I := Low(Parametros.Itens) to High(Parametros.Itens) do
        begin
          sOperacoes := sOperacoes + ','+QuotedStr(Parametros.Itens[i].Parametro);
        end;
      finally
        FreeAndNil(Parametros);
      end;

      Result := ' and OPERACAO in ('+sOperacoes+')';
    end else
    begin
      Result := ' and OPERACAO in (Select I.NOME From ICM I'+
                ' 				         Where LISTAR = ''S'' '+
                ' 				           and SUBSTRING(CFOP from 1 for 1) in (''5'',''6'',''7'')'+
                ' 					         and (UPPER(I.INTEGRACAO) LIKE ''%CAIXA%'''+
                ' 						           or UPPER(I.INTEGRACAO) LIKE ''%RECEBER%'' '+
                ' 					             )'+
                ' 				        )';
    end;
  except
  end;
end;

procedure GeraDiagnosticoIA(Transaction : TIBTransaction);
var
  sDadosEnvio, sPromptEnvio, sDiagnostico, sAPIKey : string;
begin
  //Gera dados a serem analisados
  sDadosEnvio  := ' -Vendas mês atual: 234249,64 '+sLineBreak+
                  ' -Vendas mês anterior: 266588,06 '+sLineBreak+
                  ' -Contas a receber no mês: 117718,51'+sLineBreak+
                  ' -Contas recebidas no mês: 1916,00'+sLineBreak+
                  ' -Contas a receber vencidas no mês: 113062,54 '+sLineBreak+
                  ' -Contas a pagar no mês: 206367,89'+sLineBreak+
                  ' -Contas pagas no mês: 7688,29 '+sLineBreak+
                  ' -Contas a pagar vencidas no mês: 187804.94'+sLineBreak+
                  ' -Inadimplência no trimestre: 99,60%';

  sPromptEnvio := GeraPromptEnvio(sDadosEnvio);

  //Busca API Key a ser utilizada
  sAPIKey      := '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';

  //Gera diaginostico pela IA
  TInteligenciaArtificial.New
                         .setAPIKey(sAPIKey)
                         .setPrompt(sPromptEnvio)
                         .Perguntar('Qual sua opnião e anlálise?')
                         .Resposta(sDiagnostico);



  //Grava dados no banco de dados
  if sDiagnostico <> '' then
  begin
    GravaDiagnosticoIA(sDadosEnvio,
                      sDiagnostico,
                      now,
                      Transaction);
  end;
end;


procedure GravaDiagnosticoIA(sDadosEnviados, sDadosRetornados : string; Data : TDateTime; Transaction : TIBTransaction);
var
  sSQL : string;
begin
  sDadosRetornados := Copy(sDadosRetornados,1,2000);

  sSQL := ' Insert into DIAGNOSTICOIA (IDDIAGNOSTICO, DATA, DADOSENVIADOS, DADOSRETORNADOS) '+
          ' Values ('+
          '(select gen_id(G_DIAGNOSTICOIA,1) from rdb$database), '+
          QuotedStr(DateToBD(Data))+','+
          QuotedStr(sDadosEnviados)+','+
          QuotedStr(sDadosRetornados)+
          ')';

  ExecutaComando(sSQL,Transaction);
end;

function GeraPromptEnvio(sDadosEnviados:string):string;
begin
  Result := '#Identidade'+sLineBreak+
            'Você é um Chatbot especialista em analise de operações de empresas de vendas'+sLineBreak+
            'Interaja com o cliente com as seguintes #Informações:'+sLineBreak+
            sDadosEnviados+sLineBreak+
            '#Regras para as respostas'+sLineBreak+
            '- Interaja com base nas #informações fornecidas.'+sLineBreak+
            '- Não faça perguntas ao usuário, apenas responda.'+sLineBreak+
            '- Responda sempre em Português Brasileiro.'+sLineBreak+
            '- Não gere comandos SQL.'+sLineBreak+
            '- Se não saber o que responder, responda que não sabe como responder.'+sLineBreak+
            '- Não fale quem é você.';

end;


end.




