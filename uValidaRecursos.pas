unit uValidaRecursos;

interface

uses
  System.Classes
  , System.SysUtils
  , System.StrUtils
  , Windows
  , IBX.IBDatabase
  , IBX.IBQuery
  , LbCipher, LbClass
  , uconstantes_chaves_privadas
  , uRecursosSistema
  , REST.Json
  , uConectaBancoSmall
  , uCriptografia
  , uTypesRecursos
  ;

  function RecursoLiberado(IBDATABASE: TIBDatabase; sRecurso : Recurso; out DataLimite : TDate):Boolean;
  function RecursoData(vRecursosSistema: TRecursosSistema; sRecurso : Recurso):Tdate;

  function RecursoQuantidade(IBDATABASE: TIBDatabase; sRecurso : Recurso):Integer;
  function RecursoQtd(vRecursosSistema: TRecursosSistema; sRecurso : Recurso):integer;

implementation

function RecursoLiberado(IBDATABASE: TIBDatabase; sRecurso : Recurso; out DataLimite : TDate):Boolean;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;

  qyAux: TIBQuery;
  trAux: TIBTransaction;

  {$Region'//// Limpa Numero ////'}
  function LimpaNumero(pP1:String):String;
  var
     I:Integer;
  begin
     Result:='';
     for I := 1 to length(pP1) do
     begin
       if Pos(Copy(pP1,I,1),'0123456789') > 0 then
          Result:=Result+Copy(pP1,I,1);
     end;
  end;
  {$Endregion}
begin
  Result := False;
  DataLimite := StrToDate('01/01/1900');

  try
    {$Region'//// Informações BD  ////'}
    try
      trAux := CriaIBTransaction(IBDATABASE);
      qyAux := CriaIBQuery(trAux);

      qyAux.Database := IBDATABASE;
      qyAux.SQL.Text := 'Select CGC, RECURSO from EMITENTE';
      qyAux.Open;

      vRecuso := qyAux.FieldByName('RECURSO').AsString;
      vCNPJ   := LimpaNumero(qyAux.FieldByName('CGC').AsString);
    finally
      FreeAndNil(qyAux);
      FreeAndNil(trAux);
    end;
    {$Endregion}

    //Descriptografa
    vRecuso := SmallDecrypt(CHAVE_CIFRAR_NOVA,vRecuso);

    {$Region'//// Valida Informações do Recurso ////'}
    if Trim(vRecuso) <> '' then
    begin
      try
        try
          vRecursosSistema := TJson.JsonToObject<TRecursosSistema>(vRecuso);

          //Conteudo Criptografado deve bater com dados do emitente
          if vRecursosSistema.CNPJ <> vCNPJ then
            Exit;

          DataLimite := RecursoData(vRecursosSistema,sRecurso) ;
          Result     := DataLimite >= Date;
        finally
          FreeAndNil(vRecursosSistema);
        end;
      except
      end;
    end;
    {$Endregion}
  except
  end;
end;


function RecursoQuantidade(IBDATABASE: TIBDatabase; sRecurso : Recurso):Integer;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;

  qyAux: TIBQuery;
  trAux: TIBTransaction;

  {$Region'//// Limpa Numero ////'}
  function LimpaNumero(pP1:String):String;
  var
     I:Integer;
  begin
     Result:='';
     for I := 1 to length(pP1) do
     begin
       if Pos(Copy(pP1,I,1),'0123456789') > 0 then
          Result:=Result+Copy(pP1,I,1);
     end;
  end;
  {$Endregion}
begin
  Result := 0;

  try
    {$Region'//// Informações BD  ////'}
    try
      trAux := CriaIBTransaction(IBDATABASE);
      qyAux := CriaIBQuery(trAux);

      qyAux.Database := IBDATABASE;
      qyAux.SQL.Text := 'Select CGC, RECURSO from EMITENTE';
      qyAux.Open;

      vRecuso := qyAux.FieldByName('RECURSO').AsString;
      vCNPJ   := LimpaNumero(qyAux.FieldByName('CGC').AsString);
    finally
      FreeAndNil(qyAux);
      FreeAndNil(trAux);
    end;
    {$Endregion}

    //Descriptografa
    vRecuso := SmallDecrypt(CHAVE_CIFRAR_NOVA,vRecuso);

    {$Region'//// Valida Informações do Recurso ////'}
    if Trim(vRecuso) <> '' then
    begin
      try
        try
          vRecursosSistema := TJson.JsonToObject<TRecursosSistema>(vRecuso);

          //Conteudo Criptografado deve bater com dados do emitente
          if vRecursosSistema.CNPJ <> vCNPJ then
            Exit;

          Result := RecursoQtd(vRecursosSistema,sRecurso) ;
        finally
          FreeAndNil(vRecursosSistema);
        end;
      except
      end;
    end;
    {$Endregion}
  except
  end;
end;


function RecursoData(vRecursosSistema: TRecursosSistema; sRecurso : Recurso):Tdate;
begin
  Result := StrToDate('01/01/1900');

  try
    case sRecurso of
      rcOS            : Result := vRecursosSistema.Recursos.OS;
      rcSped          : Result := vRecursosSistema.Recursos.Sped;
      rcSpedPisCofins : Result := vRecursosSistema.Recursos.SpedPisCofins;
      rcAnvisa        : Result := vRecursosSistema.Recursos.Anvisa;
      rcSintegra      : Result := vRecursosSistema.Recursos.Sintegra;
      rcComandas      : Result := vRecursosSistema.Recursos.Comandas;
      rcMDFE          : Result := vRecursosSistema.Recursos.MDFE;
      rcMobile        : Result := vRecursosSistema.Recursos.Mobile;
      rcEtiquetas     : Result := vRecursosSistema.Recursos.Etiquetas;
      rcOrcamento     : Result := vRecursosSistema.Recursos.Orcamento;
      rcContasPagar   : Result := vRecursosSistema.Recursos.ContasPagar;
      rcContasReceber : Result := vRecursosSistema.Recursos.ContasReceber;
      rcCaixa         : Result := vRecursosSistema.Recursos.Caixa;
      rcBancos        : Result := vRecursosSistema.Recursos.Bancos;
      rcIndicadores   : Result := vRecursosSistema.Recursos.Indicadores;
      rcInventarioP7  : Result := vRecursosSistema.Recursos.InventarioP7;
    end;
  except
  end;
end;


function RecursoQtd(vRecursosSistema: TRecursosSistema; sRecurso : Recurso):integer;
begin
  Result := 0;

  try
    case sRecurso of
      rcQtdNFCE    : Result := vRecursosSistema.Recursos.QtdNFCE;
      rcQtdNFE     : Result := vRecursosSistema.Recursos.QtdNFE;
    end;
  except
  end;
end;


end.
