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

  function SistemaSerial(IBDATABASE: TIBDatabase): String;
  function SistemaLimiteUsuarios(IBDATABASE: TIBDatabase): Integer;

  procedure InformacoesBD(IBDATABASE: TIBDatabase; out vRecuso, vCNPJ : string);

  function RecursoLiberado(IBDATABASE: TIBDatabase; sRecurso : TRecursos; out DataLimite : TDate): Boolean;
  function RecursoData(vRecursosSistema: TRecursosSistema; sRecurso : TRecursos): Tdate;

  function RecursoQuantidade(IBDATABASE: TIBDatabase; sRecurso : TRecursos): Integer;
  function RecursoQtd(vRecursosSistema: TRecursosSistema; sRecurso : TRecursos): integer;

  function RecursosSistema(IBDATABASE: TIBDatabase): TRecursosSistema;

implementation

function SistemaSerial(IBDATABASE: TIBDatabase): String;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;
begin
  Result := '';

  try
    // Informações BD
    InformacoesBD(IBDATABASE, vRecuso, vCNPJ);

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

          Result     := vRecursosSistema.Serial;
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

function SistemaLimiteUsuarios(IBDATABASE: TIBDatabase): Integer;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;
begin
  Result := 1;

  try
    // Informações BD
    InformacoesBD(IBDATABASE, vRecuso, vCNPJ);

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

          Result     := vRecursosSistema.Usuarios;
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

function RecursoLiberado(IBDATABASE: TIBDatabase; sRecurso : TRecursos; out DataLimite : TDate): Boolean;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;
begin
  Result := False;
  DataLimite := StrToDate('01/01/1900');

  try
    // Informações BD
    InformacoesBD(IBDATABASE, vRecuso, vCNPJ);

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


function RecursoQuantidade(IBDATABASE: TIBDatabase; sRecurso : TRecursos):Integer;
var
  vRecursosSistema : TRecursosSistema;
  vRecuso, vCNPJ : string;
begin
  Result := 0;

  try
    // Informações BD
    InformacoesBD(IBDATABASE, vRecuso, vCNPJ);

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


function RecursoData(vRecursosSistema: TRecursosSistema; sRecurso : TRecursos):Tdate;
begin
  Result := StrToDate('01/01/1900');

  try
    case sRecurso of
      rcOS               : Result := vRecursosSistema.Recursos.OS;
      rcSped             : Result := vRecursosSistema.Recursos.Sped;
      rcSpedPisCofins    : Result := vRecursosSistema.Recursos.SpedPisCofins;
      rcAnvisa           : Result := vRecursosSistema.Recursos.Anvisa;
      rcSintegra         : Result := vRecursosSistema.Recursos.Sintegra;
      rcComandas         : Result := vRecursosSistema.Recursos.Comandas;
      rcMDFE             : Result := vRecursosSistema.Recursos.MDFE;
      rcMobile           : Result := vRecursosSistema.Recursos.Mobile;
      rcEtiquetas        : Result := vRecursosSistema.Recursos.Etiquetas;
      rcOrcamento        : Result := vRecursosSistema.Recursos.Orcamento;
      rcContasPagar      : Result := vRecursosSistema.Recursos.ContasPagar;
      rcContasReceber    : Result := vRecursosSistema.Recursos.ContasReceber;
      rcCaixa            : Result := vRecursosSistema.Recursos.Caixa;
      rcBancos           : Result := vRecursosSistema.Recursos.Bancos;
      rcIndicadores      : Result := vRecursosSistema.Recursos.Indicadores;
      rcInventarioP7     : Result := vRecursosSistema.Recursos.InventarioP7;
      rcMKP              : Result := vRecursosSistema.Recursos.MKP;
      rcZPOS             : Result := vRecursosSistema.Recursos.ZPOS;
      rcIntegracaoItau   : Result := vRecursosSistema.Recursos.IntegracaoItau;
      rcIntegracaoSicoob : Result := vRecursosSistema.Recursos.IntegracaoSicoob;
    end;
  except
  end;
end;


function RecursoQtd(vRecursosSistema: TRecursosSistema; sRecurso : TRecursos):integer;
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


procedure InformacoesBD(IBDATABASE: TIBDatabase; out vRecuso, vCNPJ : string);
var
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
  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    if CampoExisteFB(IBDATABASE, 'EMITENTE', 'RECURSO') then
    begin
      try
        if CampoExisteFB(IBDATABASE, 'EMITENTE', 'RECURSO') then
        begin
          //qyAux.Database := IBDATABASE;
          qyAux.SQL.Text := 'Select CGC, RECURSO from EMITENTE';
          qyAux.Open;

          vRecuso := qyAux.FieldByName('RECURSO').AsString;
          vCNPJ   := LimpaNumero(qyAux.FieldByName('CGC').AsString);
        end;
      except
        vRecuso := '';
        vCNPJ   := '';
      end;
    end;
  finally
    FreeAndNil(qyAux);
    FreeAndNil(trAux);
  end;
end;


function RecursosSistema(IBDATABASE: TIBDatabase): TRecursosSistema;
var
 vRecuso, vCNPJ : string;
begin
  try
    // Informações BD
    InformacoesBD(IBDATABASE, vRecuso, vCNPJ);

    //Descriptografa
    vRecuso := SmallDecrypt(CHAVE_CIFRAR_NOVA,vRecuso);

    if Trim(vRecuso) <> '' then
    begin
      try
        Result := TJson.JsonToObject<TRecursosSistema>(vRecuso);
      except
      end;
    end;
  except
  end;
end;

end.
