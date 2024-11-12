library msgws;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  Controls,
  Dialogs,
  IBDatabase,
  Forms,
  DateUtils,
  ufuncoesfrente in 'ufuncoesfrente.pas',
  ufuncoesblocox in 'ufuncoesblocox.pas',
  uconstantes_chaves_privadas in '..\..\uconstantes_chaves_privadas.pas',
  uclassetiposblocox in 'uclassetiposblocox.pas',
  uarquivosblocox in 'uarquivosblocox.pas' {FArquivosBlocoX},
  smallfunc_xe in '..\unit_compartilhada\smallfunc_xe.pas',
  uConectaBancoSmall in '..\unit_compartilhada\uConectaBancoSmall.pas',
  uValidaRecursosDelphi7 in '..\unit_compartilhada\uValidaRecursosDelphi7.pas',
  uRecursosSistema in '..\unit_compartilhada\uRecursosSistema.pas',
  uTypesRecursos in '..\unit_compartilhada\uTypesRecursos.pas',
  uCriptografia in '..\unit_compartilhada\uCriptografia.pas',
  uSmallConsts in '..\unit_compartilhada\uSmallConsts.pas',
  uDialogs in '..\unit_compartilhada\uDialogs.pas',
  FuncaoMD5 in '..\unit_compartilhada\uFuncaoMD5.pas'
  ;

{$R *.res}

var
  Emitente: TEmitente;
  crCursor: TCursor;
  IBDATABASE1: TIBDatabase;
  IBTransaction1: TIBTransaction;

function XmlReducaoZBlocoX(CaminhoBanco: AnsiString; DiretorioAtual: AnsiString;
  SerieECF: AnsiString; dtReferencia: AnsiString; bLimparRecibo: Boolean;
  bLimparXMLResposta: Boolean; bAssinarXML: Boolean): Boolean; cdecl;
begin

  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PansiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

     Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      BXGeraXmlReducaoZ(Emitente, IBTransaction1, SerieECF, dtReferencia, bLimparRecibo, bLimparXMLResposta, bAssinarXML);
      Result := True;
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);

  ChDir(DiretorioAtual);
  LogFrente('XML RZ criado', DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function XmlEstoqueBlocoX(CaminhoBanco: AnsiString; DiretorioAtual: AnsiString;
  dtInicial: AnsiString; dtFinal: AnsiString; bLimparRecibo: Boolean;
  bLimparXMLResposta: Boolean; bAssinarXML: Boolean;
  bForcarGeracao: Boolean): Boolean; cdecl;
begin
  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PansiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try

      Result := BXGeraXmlEstoqueMes(Emitente, IBTransaction1, StrToDate(dtInicial), StrToDate(dtFinal), bLimparRecibo, bLimparXMLResposta, bAssinarXML, bForcarGeracao)
      
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);

  ChDir(DiretorioAtual);
  LogFrente('XML ESTOQUE criado', DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function XmlEstoqueOmissoBlocoX(CaminhoBanco: AnsiString; DiretorioAtual: AnsiString;
  dtInicial: AnsiString; dtFinal: AnsiString; bLimparRecibo: Boolean;
  bLimparXMLResposta: Boolean; bAssinarXML: Boolean;
  bForcarGeracao: Boolean): Boolean; cdecl;
begin
  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PansiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try

      Result := BXGeraXmlEstoqueMes(Emitente, IBTransaction1, StrToDate(dtInicial), StrToDate(dtFinal), bLimparRecibo, bLimparXMLResposta, bAssinarXML, bForcarGeracao)

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);

  ChDir(DiretorioAtual);
  LogFrente('XML ESTOQUE criado', DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function RecuperarRecibodeXmlRespostaBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; XmlResposta: AnsiString;
  sDtReferencia: AnsiString; sTipo: AnsiString; sSerie: AnsiString): Boolean; cdecl;
begin
  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, Pansichar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin
    try
      Result := BXRecuperarRecibodeXmlResposta(IBTransaction1, XmlResposta,
        sDtReferencia, sTipo, sSerie);
    except

    end;
  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function AlertaXmlPendenteBlocox(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; sTipo: AnsiString; sSerieECF: AnsiString;
  bExibirAlerta: Boolean; bRetaguarda: Boolean): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try

//ShowMessage('169'); // Sandro Silva 2018-09-19

      Result := BXAlertarXmlPendente(Emitente, IBTransaction1, sTipo, sSerieECF, bExibirAlerta, bRetaguarda);

      BXExibeAlertaErros(Emitente, sTipo, IBTransaction1); // Sandro Silva 2019-04-02

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function PermitirGerarXmlEstoqueBlocoX: Boolean; cdecl;
begin
  Result := BXPermiteGerarXmlEstoque;
end;

function AssinaXmlPendenteBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; sTipo: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try

      BXAssinaTodosXmlPendente(IBTransaction1, sTipo, DiretorioAtual);
      Result := True;
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;

end;

function TrataErroRetornoTransmissaoBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; sXmlResposta: AnsiString; sTipo: AnsiString;
  sSerie: AnsiString; sDataReferencia: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      BXTrataErroRetornoTransmissao(Emitente, IBTransaction1, sXmlResposta, sTipo, sSerie, sDataReferencia);
      Result := True;
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;

end;

function ServidorBlocoXSefazConfigurado(UF: AnsiString): Boolean; cdecl;
begin
  Result := BXServidorSefazConfigurado(UF);
end;

function ConsultarReciboBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; Recibo: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXConsultarRecibo(Emitente, IBTransaction1, DiretorioAtual, Recibo);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function RestaurarArquivosBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; sTipo: AnsiString;
  sSerieECF: AnsiString; bApenasUltimo: Boolean): Boolean; cdecl;
begin
//ShowMessage('153'); // Sandro Silva 2018-09-19
  Result := False;
  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try

      BXRestaurarArquivos(IBTransaction1, DiretorioAtual, sTipo, sSerieECF, bApenasUltimo);
      Result := True;

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;

end;

function TransmitirXmlPendenteBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; sTipo: AnsiString; sSerieECF: AnsiString;
  bAlerta: Boolean): Integer; cdecl;
begin
  Result := 0;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      Result := BXTransmitirPendenteBlocoX(DiretorioAtual, Emitente, IBTransaction1, sTipo ,sSerieECF, bAlerta);
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;

end;

function ValidaCertificadoDigitalBlocoX(sCNPJ: AnsiString): Boolean; cdecl;
begin
  Result := True;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try
    Result := BXValidaCertificadoDigital(Pansichar(sCNPJ)); // Sandro Silva 2024-10-21 Result := BXValidaCertificadoDigital(sCNPJ);
  except

  end;

  Screen.Cursor := crCursor;

end;

function SelecionaCertificadoDigitalBlocoX: Boolean; cdecl;
begin
  Result := BXSelecionarCertificadoDigital <> '';
end;

function ConsultarPendenciasDesenvolvedorPafEcfBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      BXConsultarPendenciasDesenvolvedorPafEcf(Emitente);
      Result := True;
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);
  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;

end;

function IdentificaRetornosComErroTratando(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; Tipo: AnsiString): Boolean; cdecl;
begin
  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      Result := BXIdentificaRetornosComErroTratando(Emitente, IBTransaction1, Tipo);
    except

    end;

  ///ShowMessage('Teste 01 522'); // Sandro Silva 2020-06-22

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  //ShowMessage('Teste 01 530'); // Sandro Silva 2020-06-22

  //if IBDATABASE1 = nil then
  //  ShowMessage('Teste 01 nil 533'); // Sandro Silva 2020-06-22

  FechaIBDataBase(IBDATABASE1);

  //ShowMessage('Teste 01 534'); // Sandro Silva 2020-06-22

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  Screen.Cursor := crCursor;

end;

function VisualizaXmlBlocoX(CaminhoBanco: AnsiString; Tipo: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

    try
      Result := BXVisualizaXmlBlocoX(Emitente, IBTransaction1.DefaultDatabase.DatabaseName, Tipo, DiretorioAtual); // Sandro Silva 2020-06-18 Result := BXVisualizaXmlBlocoX(Emitente, IBTransaction1, Tipo, DiretorioAtual); 
    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  Screen.Cursor := crCursor;

end;

function ReprocessarArquivoBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; Recibo: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXReprocessarArquivo(Emitente, IBTransaction1, DiretorioAtual, Recibo);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function CancelarArquivoBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString; Recibo: AnsiString): Boolean; cdecl;
begin
  Result := False;
//ShowMessage('153'); // Sandro Silva 2018-09-19

  crCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXCancelarArquivo(Emitente, IBTransaction1, DiretorioAtual, Recibo);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);
  Screen.Cursor := crCursor;
end;

function GerarAoFISCOREDUCAOZBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarAoFISCOREDUCAOZ(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;

function GerarEstoqueAnoAnteriorBlocoX(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarEstoqueAnoAnterior(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;

function GerarEstoqueMudancaDeTributacao(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarEstoqueMudancaDeTributacao(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;

function GerarEstoqueSuspensaoOuBaixaDeIE(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarEstoqueSuspensaoOuBaixaDeIE(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;

function GerarEstoqueMudancaDeRegime(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarEstoqueMudancaDeRegime(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;

function GerarEstoqueAtual(CaminhoBanco: AnsiString;
  DiretorioAtual: AnsiString): Boolean; cdecl;
begin
  Result := False;

  IBDATABASE1    := CriaIBDataBase;
  IBTransaction1 := CriaIBTransaction(IBDATABASE1);

  ConectaIBDataBase(IBDATABASE1, PAnsiChar(CaminhoBanco));

  if IBDATABASE1.Connected then
  begin

//ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

    try
      Emitente := DadosEmitente(IBTransaction1, DiretorioAtual);

      Result := BXGerarEstoqueAtual(Emitente, IBTransaction1);

    except

    end;

  end
  else
  begin
    ShowMessage('Não foi possível selecionar os dados');
  end;

  FechaIBDataBase(IBDATABASE1);

  FreeAndNil(IBTransaction1);
  FreeAndNil(IBDATABASE1);
  ChDir(DiretorioAtual);

end;


exports
  XmlReducaoZBlocoX,
  XmlEstoqueBlocoX,
  XmlEstoqueOmissoBlocoX,
  RecuperarRecibodeXmlRespostaBlocoX,
  AlertaXmlPendenteBlocox,
  PermitirGerarXmlEstoqueBlocoX,
  AssinaXmlPendenteBlocoX,
  TrataErroRetornoTransmissaoBlocoX,
  ServidorBlocoXSefazConfigurado,
  ConsultarReciboBlocoX,
  RestaurarArquivosBlocoX,
  TransmitirXmlPendenteBlocoX,
  ValidaCertificadoDigitalBlocoX,
  SelecionaCertificadoDigitalBlocoX,
  ConsultarPendenciasDesenvolvedorPafEcfBlocoX // Sandro Silva 2019-03-26
  , IdentificaRetornosComErroTratando // Sandro Silva 2019-06-18
  , VisualizaXmlBlocoX // Sandro Silva 2020-06-09
  , ReprocessarArquivoBlocoX // Sandro Silva 2020-09-30
  , CancelarArquivoBlocoX // Sandro Silva 2022-03-11
  , GerarAoFISCOREDUCAOZBlocoX // Sandro Silva 2022-09-05
  , GerarEstoqueAnoAnteriorBlocoX // Sandro Silva 2022-11-22
  , GerarEstoqueMudancaDeTributacao // Sandro Silva 2022-11-22
  , GerarEstoqueSuspensaoOuBaixaDeIE // Sandro Silva 2022-11-23
  , GerarEstoqueMudancaDeRegime // Sandro Silva 2022-11-23
  , GerarEstoqueAtual // Sandro Silva 2022-11-23
  ;

begin


end.

//uses ufuncoesblocox.
