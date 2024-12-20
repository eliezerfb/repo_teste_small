unit uDashboard;

interface

uses
  Data.DB
  , IBX.IBDatabase
  , System.SysUtils
  , REST.Json
  , uClassesDashboard
  , IBX.IBQuery
  , DateUtils
  ;

  function GetdDadosDashboard(out sJson : string; IBDatabase: TIBDatabase):boolean;
  function getFiltroVendas(Transaction : TIBTransaction):string;

implementation

uses uFuncoesBancoDados
  , uArquivosDAT
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


end.




