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

  function GetdDadosDashboard(out sJson : string; Transaction : TIBTransaction):boolean;
  function getFiltroVendas(Transaction : TIBTransaction):string;

implementation

uses uFuncoesBancoDados
  , uArquivosDAT
  , uListaToJson;


function GetdDadosDashboard(out sJson : string; Transaction : TIBTransaction):boolean;
var
  DadosDTO : TRootDadosDTO;
begin
  Result := False;
  sJson  := '';

  try
    try
      DadosDTO := TRootDadosDTO.Create;
      DadosDTO.setTransaction(Transaction);
      DadosDTO.FiltroNatVendas := getFiltroVendas(Transaction);
      DadosDTO.GetDados;
      sJson := TJson.ObjectToJsonString(DadosDTO);
      Result := True;
    finally
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
        Parametros := TParametros.Create(sJsonFiltro);
        for I := Low(Parametros.Itens) to High(Parametros.Itens) do
        begin
          sOperacoes := sOperacoes + ','+QuotedStr(Parametros.Itens[i].Parametro);
        end;
      finally
        FreeAndNil(Parametros);
      end;

      Delete(sOperacoes,1,1);

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
