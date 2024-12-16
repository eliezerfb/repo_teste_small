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
      //Cria Conex�o para thread clonando da principal
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
            'Voc� � um Chatbot especialista em analise de opera��es de empresas de vendas'+sLineBreak+
            'Interaja com o cliente com as seguintes #Informa��es:'+sLineBreak+
            sDadosEnviados+sLineBreak+
            '#Regras para as respostas'+sLineBreak+
            '- Interaja com base nas #informa��es fornecidas.'+sLineBreak+
            '- N�o fa�a perguntas ao usu�rio, apenas responda.'+sLineBreak+
            '- Responda sempre em Portugu�s Brasileiro.'+sLineBreak+
            '- N�o gere comandos SQL.'+sLineBreak+
            '- Se n�o saber o que responder, responda que n�o sabe como responder.'+sLineBreak+
            '- N�o fale quem � voc�.';

end;


end.




