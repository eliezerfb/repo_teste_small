(*////////////////////////////////////////////////////////////////////////////////
Funções utilizadas em diferentes units do projeto.
Estavam no form1, causando muita dependência
////////////////////////////////////////////////////////////////////////////////*)
unit ufuncoesfrentepaf;

interface

uses IniFiles, SysUtils, MSXML2_TLB, Forms, Dialogs, Windows
  {$IFDEF VER150}
  , IBDatabase, IBQuery
  {$ELSE}
  , IBX.IBDatabase, IBX.IBQuery
  {$ENDIF}
  , SmallFunc_xe, Classes, LbCipher, LbClass,
  ShellApi // Sandro Silva 2019-02-20
  , DateUtils
  , DB // Sandro Silva 2019-03-14
  , Controls // Sandro Silva 2019-06-14
  , uclassetiposblocox
  , ufuncoesfrente
  //, Printers
  , WinSpool
  , WinSock // Sandro Silva 2019-08-29 ER 02.06 UnoChapeco
  , IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP
  , MD5
  //, DBGrids
  ;

function PerfilPAF(sChave: String): String;
// Sandro Silva 2020-12-07  function PAFNFCe: Boolean;
function SetLengthAnsiString(iLength: Integer): AnsiString;

type
  // Classe para usar dll do Bloco X carregando dinamicamente. Permite que para nfce.exe e cfesat.exe não precise distribuir a dll
  TSmallBlocoX = class(TComponent)
  private
    DLL: THandle;
    FLoad: Boolean;
    _AlertaXmlPendenteBlocox: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; sTipo: PAnsiChar; sSerieECF: PAnsiChar; bExibirAlerta: Boolean; bRetaguarda: Boolean): Boolean; cdecl;
    _AssinaXmlPendenteBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; sTipo: PAnsiChar): Boolean; cdecl;
    _ConsultarReciboBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; Recibo: PAnsiChar): Boolean; cdecl;
    _PermitirGerarXmlEstoqueBlocoX: function(): Boolean; cdecl;
    _RestaurarArquivosBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; sTipo: PAnsiChar; sSerieECF: PAnsiChar; bApenasUltimo: Boolean): Boolean; cdecl;
    _ServidorBlocoXSefazConfigurado: function(UF: PAnsiChar): Boolean; cdecl;
    _TransmitirXmlPendenteBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; sTipo: PAnsiChar; sSerieECF: PAnsiChar; bAlerta: Boolean): Integer; cdecl;
    _TrataErroRetornoTransmissaoBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; sXmlResposta: PAnsiChar; sTipo: PAnsiChar; sSerie: PAnsiChar; sDataReferencia: PAnsiChar): Boolean; cdecl;
    _ValidaCertificadoDigitalBlocoX: function(sCNPJ: PAnsiChar): Boolean; cdecl; // Sandro Silva 2018-10-18 _ValidaCertificadoDigitalBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl;
    _XmlEstoqueBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; dtInicial: PAnsiChar; dtFinal: PAnsiChar; bLimparRecibo: Boolean; bLimparXMLResposta: Boolean; bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean; cdecl;
    _XmlEstoqueOmissoBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; dtInicial: PAnsiChar; dtFinal: PAnsiChar; bLimparRecibo: Boolean; bLimparXMLResposta: Boolean; bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean; cdecl;
    _XmlReducaoZBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; SerieECF: PAnsiChar; dtReferencia: PAnsiChar; bLimparRecibo: Boolean; bLimparXMLResposta: Boolean; bAssinarXML: Boolean): Boolean; cdecl;
    _SelecionaCertificadoDigitalBlocoX: function(): Boolean; cdecl;
    _ConsultarPendenciasDesenvolvedorPafEcfBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl;
    _IdentificaRetornosComErroTratando: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; Tipo: PAnsiChar): Boolean; cdecl;
    _VisualizaXmlBlocoX: function(CaminhoBanco: PAnsiChar; sTipo: PAnsiChar;DiretorioAtual: PAnsiChar ): Boolean; cdecl;
    _ReprocessarArquivoBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; Recibo: PAnsiChar): Boolean; cdecl;
    _CancelarArquivoBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar; Recibo: PAnsiChar): Boolean; cdecl;
    _GerarAoFISCOREDUCAOZBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl;
    _GerarEstoqueAnoAnteriorBlocoX: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl; // Sandro Silva 2022-11-22
    _GerarEstoqueMudancaDeTributacao: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl; // Sandro Silva 2022-11-22
    _GerarEstoqueSuspensaoOuBaixaDeIE: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl; // Sandro Silva 2022-11-22
    _GerarEstoqueMudancaDeRegime: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl; // Sandro Silva 2022-11-22
    _GerarEstoqueAtual: function(CaminhoBanco: PAnsiChar; DiretorioAtual: PAnsiChar): Boolean; cdecl; // Sandro Silva 2022-11-22

    FEmitente: TEmitente;
    FIBDATABASE: TIBDatabase;
    FIBTransaction: TIBTransaction;
    procedure Import(var Proc: pointer; Name: Pchar);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Load: Boolean read FLoad;
    //property Emitente: TEmitente read FEmitente write FEmitente;
    //property IBDATABASE: TIBDatabase read FIBDATABASE write FIBDATABASE;
    //property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    function CarregaDLL: Boolean;
    procedure FinalizaDLL;
    //function ValidaCertificadoDigital(CaminhoBanco: String;
    //  DiretorioAtual: String): Boolean;
    function ValidaCertificadoDigital(sCNPJ: String): Boolean;
    function XmlReducaoZ(CaminhoBanco: String;
      DiretorioAtual: String; SerieECF: String; sdtReferencia: String;
      bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
      bAssinarXML: Boolean): Boolean;
    function PermitirGerarXmlEstoqueBlocoX: Boolean;
    function XmlEstoque(CaminhoBanco: String; DiretorioAtual: String;
      sdtInicial: String; sdtFinal: String; bLimparRecibo: Boolean;
      bLimparXMLResposta: Boolean; bAssinarXML: Boolean;
      bForcarGeracao: Boolean): Boolean;
    function XmlEstoqueOmisso(CaminhoBanco: String; DiretorioAtual: String;
      sdtInicial: String; sdtFinal: String; bLimparRecibo: Boolean;
      bLimparXMLResposta: Boolean; bAssinarXML: Boolean;
      bForcarGeracao: Boolean): Boolean;
    function TransmitirXmlPendente(CaminhoBanco: String;
      DiretorioAtual: String; sTipo: String; sSerieECF: String;
      bAlerta: Boolean): Integer;
    function ConsultarRecibo(CaminhoBanco: String;
      DiretorioAtual: String; Recibo: String): Boolean;
    function ServidorSefazConfigurado(UF: String): Boolean;
    function AlertaXmlPendente(CaminhoBanco: String;
      DiretorioAtual: String; sTipo: String; sSerieECF: String;
      bExibirAlerta: Boolean; bRetaguarda: Boolean = False): Boolean;
    function RestaurarArquivosXML(CaminhoBanco: String;
      DiretorioAtual: String; sTipo: String;
      sSerieECF: String; bApenasUltimo: Boolean): Boolean;
    function TratarErroRetornoTransmissao(CaminhoBanco: String;
      DiretorioAtual: String; sXmlResposta: String; sTipo: String;
      sSerie: String; sDataReferencia: String): Boolean;
    function SelecionaCertificadoDigital: Boolean;
    function ConsultarPendenciasDesenvolvedorPafEcf(CaminhoBanco: String;
      DiretorioAtual: String): Boolean;
    function IdentificaRetornosComErroTratandoTodos(CaminhoBanco: String;
      DiretorioAtual: String; sTipo: String): Boolean;
    procedure ValidaMd5DoListaNoCriptografado;
    function VisualizaXmlBlocoX(CaminhoBanco: String;
      DiretorioAtual: String; sTipo: String): Boolean;
    function ReprocessarArquivoBlocoX(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar; Recibo: PAnsiChar): Boolean;
    function CancelarArquivoBlocoX(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar; Recibo: PAnsiChar): Boolean;
    function GerarAoFISCOREDUCAOZBlocox(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
    function GerarEstoqueAnoAnterior(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
    function GerarEstoqueMudancaDeTributacao(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
    function GerarEstoqueSuspensaoOuBaixaDeIE(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
    function GerarEstoqueMudancaDeRegime(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
    function GerarEstoqueAtual(CaminhoBanco: PAnsiChar;
      DiretorioAtual: PAnsiChar): Boolean;
  end;

var
  _BlocoX: TSmallBlocoX;

implementation

uses StrUtils
  , ufuncoesblocox // Sandro Silva 2019-06-18
  , uconstantes_chaves_privadas;

function PerfilPAF(sChave: String): String;
var
  LbBlowfish1: TLbBlowfish;
  sPerfil: String;
begin
  //
  LbBlowfish1 := TLbBlowfish.Create(nil);
  LbBlowfish1.CipherMode := cmECB;
  sPerfil := '';
  try
    LbBlowfish1.GenerateKey(sChave);

    // Sandro Silva 2019-08-07  Sleep(1000);
    sPerfil := LerParametroIni(NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF, 'PERFIL', 'I', sPerfil); // Sandro Silva 2022-12-02 Unochapeco sPerfil := LerParametroIni('arquivoauxiliarcriptografadopafecfsmallsoft.ini', 'PERFIL', 'I', sPerfil);
//ShowMessage('Perfil ' + sPerfil); // Sandro Silva 2018-09-17
    if sPerfil <> '' then
    begin
      try
        sPerfil := LbBlowfish1.DecryptString(sPerfil);
        //ShowMessage('Perfil PAF 269 ' + sPerfil);
      except
        sPerfil := '';
      end;
    end;
  except
    on E: Exception do
    begin
      sPerfil := '';
      //ShowMessage('Perfil PAF 269' + #13 + E.Message);
    end;
  end;

  Result := sPerfil;
  FreeAndNil(LbBlowfish1); // Sandro Silva 2019-06-19 LbBlowfish1.Free;

end;

function SetLengthAnsiString(iLength: Integer): AnsiString;
begin
  Result := AnsiString(StringOfChar(' ', iLength));
end;

// Classe para poder utilizar funções do bloco X através de dll dinâmica
{ TSmallBlocoX }

constructor TSmallBlocoX.Create(AOwner: TComponent);
begin
  inherited;
  FLoad := CarregaDLL;
  FIBDATABASE    := CriaIBDataBase;
  FIBTransaction := CriaIBTransaction(FIBDATABASE);
end;

destructor TSmallBlocoX.Destroy;
begin
  FinalizaDLL;
  //FreeAndNil(FIBTransaction);
  FreeAndNil(FIBDATABASE);
  if FIBTransaction <> nil then // Sandro Silva 2019-09-10 ER 02.06 UnoChapeco
    FreeAndNil(FIBTransaction);

  //ShowMessage('Teste 01 261'); // Sandro Silva 2020-06-22

  inherited;
end;

function TSmallBlocoX.CarregaDLL: Boolean;
begin
  Result := False;
  if FileExists(PChar(ExtractFilePath(Application.ExeName) + 'msgws.dll')) then // Sandro Silva 2019-06-18
  begin
    try
      DLL := LoadLibrary(PChar(ExtractFilePath(Application.ExeName) + 'msgws.dll')); //carregando dll

      Import(@_AlertaXmlPendenteBlocox, 'AlertaXmlPendenteBlocox');
      Import(@_AssinaXmlPendenteBlocoX, 'AssinaXmlPendenteBlocoX');
      Import(@_ConsultarReciboBlocoX, 'ConsultarReciboBlocoX');
      Import(@_PermitirGerarXmlEstoqueBlocoX, 'PermitirGerarXmlEstoqueBlocoX');
      Import(@_RestaurarArquivosBlocoX, 'RestaurarArquivosBlocoX');
      Import(@_ServidorBlocoXSefazConfigurado, 'ServidorBlocoXSefazConfigurado');
      Import(@_TransmitirXmlPendenteBlocoX, 'TransmitirXmlPendenteBlocoX');
      Import(@_TrataErroRetornoTransmissaoBlocoX, 'TrataErroRetornoTransmissaoBlocoX');
      Import(@_ValidaCertificadoDigitalBlocoX, 'ValidaCertificadoDigitalBlocoX');
      Import(@_XmlEstoqueBlocoX, 'XmlEstoqueBlocoX');
      Import(@_XmlEstoqueOmissoBlocoX, 'XmlEstoqueOmissoBlocoX');
      Import(@_XmlReducaoZBlocoX, 'XmlReducaoZBlocoX');
      Import(@_SelecionaCertificadoDigitalBlocoX, 'SelecionaCertificadoDigitalBlocoX');
      Import(@_ConsultarPendenciasDesenvolvedorPafEcfBlocoX, 'ConsultarPendenciasDesenvolvedorPafEcfBlocoX');
      Import(@_IdentificaRetornosComErroTratando, 'IdentificaRetornosComErroTratando'); // Sandro Silva 2019-06-18
      Import(@_VisualizaXmlBlocoX, 'VisualizaXmlBlocoX'); // Sandro Silva 2020-06-15
      Import(@_ReprocessarArquivoBlocoX, 'ReprocessarArquivoBlocoX'); // Sandro Silva 2020-09-30
      Import(@_CancelarArquivoBlocoX, 'CancelarArquivoBlocoX'); // Sandro Silva 2020-09-30
      Import(@_GerarAoFISCOREDUCAOZBlocoX, 'GerarAoFISCOREDUCAOZBlocoX'); // Sandro Silva 2022-09-05
      Import(@_GerarEstoqueAnoAnteriorBlocoX, 'GerarEstoqueAnoAnteriorBlocoX'); // Sandro Silva 2022-11-22
      Import(@_GerarEstoqueMudancaDeTributacao, 'GerarEstoqueMudancaDeTributacao'); // Sandro Silva 2022-11-22
      Import(@_GerarEstoqueSuspensaoOuBaixaDeIE, 'GerarEstoqueSuspensaoOuBaixaDeIE'); // Sandro Silva 2022-11-22
      Import(@_GerarEstoqueMudancaDeRegime, 'GerarEstoqueMudancaDeRegime'); // Sandro Silva 2022-11-22
      Import(@_GerarEstoqueAtual, 'GerarEstoqueAtual'); // Sandro Silva 2022-11-22

      Result := True;
    except
      on E: Exception do
      begin
        if DLL = 0 then
          ShowMessage('Não foi possível carregar as funções do Bloco X')
        else
          ShowMessage('Erro ao carregar funções do Bloco X' + #13 + E.Message);
      end;
    end;
  end;
end;

procedure TSmallBlocoX.FinalizaDLL;
begin
  if FLoad then // Sandro Silva 2019-06-18
  begin
    _AlertaXmlPendenteBlocox                      := nil;
    _AssinaXmlPendenteBlocoX                      := nil;
    _ConsultarReciboBlocoX                        := nil;
    _PermitirGerarXmlEstoqueBlocoX                := nil;
    _RestaurarArquivosBlocoX                      := nil;
    _ServidorBlocoXSefazConfigurado               := nil;
    _TransmitirXmlPendenteBlocoX                  := nil;
    _TrataErroRetornoTransmissaoBlocoX            := nil;
    _ValidaCertificadoDigitalBlocoX               := nil;
    _XmlEstoqueOmissoBlocoX                       := nil;
    _XmlReducaoZBlocoX                            := nil;
    _SelecionaCertificadoDigitalBlocoX            := nil;
    _ConsultarPendenciasDesenvolvedorPafEcfBlocoX := nil;
    _IdentificaRetornosComErroTratando            := nil; // Sandro Silva 2019-06-18
    _VisualizaXmlBlocoX                           := nil; // Sandro Silva 2020-06-15
    _ReprocessarArquivoBlocoX                     := nil; // Sandro Silva 2020-09-30
    _CancelarArquivoBlocoX                        := nil; // Sandro Silva 2020-09-30
    _GerarAoFISCOREDUCAOZBlocoX                   := nil;  // Sandro Silva 2022-09-05
    _GerarEstoqueAnoAnteriorBlocoX                := nil; // Sandro Silva 2022-11-22
    _GerarEstoqueMudancaDeTributacao              := nil; // Sandro Silva 2022-11-23
    _GerarEstoqueSuspensaoOuBaixaDeIE             := nil; // Sandro Silva 2022-11-22
    _GerarEstoqueMudancaDeRegime                  := nil; // Sandro Silva 2022-11-23
    _GerarEstoqueAtual                            := nil; // Sandro Silva 2022-11-23
  end;
end;

procedure TSmallBlocoX.Import(var Proc: pointer; Name: Pchar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(DLL, Pchar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' do Bloco X');
  end;
end;

function TSmallBlocoX.ValidaCertificadoDigital(sCNPJ: String): Boolean;
begin
  if FLoad = False then
    Result := BXValidaCertificadoDigital(sCNPJ)
  else
    Result := _ValidaCertificadoDigitalBlocoX(PAnsiChar(sCNPJ));
end;

function TSmallBlocoX.XmlReducaoZ(CaminhoBanco: String; DiretorioAtual: String;
  SerieECF: String; sdtReferencia: String; bLimparRecibo: Boolean;
  bLimparXMLResposta: Boolean; bAssinarXML: Boolean): Boolean;
begin
  if FLoad = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

       FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXGeraXmlReducaoZ(FEmitente, FIBTransaction, SerieECF, sdtReferencia, bLimparRecibo, bLimparXMLResposta, bAssinarXML);
        Result := True;
      except

      end;

    end;
    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);
    LogFrente('XML RZ criado', DiretorioAtual);
  end
  else
  begin
    Result := _XmlReducaoZBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(SerieECF), PAnsiChar(sdtReferencia), bLimparRecibo, bLimparXMLResposta, bAssinarXML);
  end;

end;

function TSmallBlocoX.PermitirGerarXmlEstoqueBlocoX: Boolean;
begin

  if FLoad = False then
    Result := BXPermiteGerarXmlEstoque
  else
    Result := _PermitirGerarXmlEstoqueBlocoX;
    
end;

function TSmallBlocoX.XmlEstoque(CaminhoBanco: String; DiretorioAtual: String;
  sdtInicial: String; sdtFinal: String; bLimparRecibo: Boolean;
  bLimparXMLResposta: Boolean; bAssinarXML: Boolean;
  bForcarGeracao: Boolean): Boolean;
// Gera xml do estoque apenas dos períodos com data final menor que 01/06/2020 ou com data final referente a 31/12   
begin

  if FLoad = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGeraXmlEstoqueMes(FEmitente, FIBTransaction, StrToDate(sdtInicial), StrToDate(sdtFinal), bLimparRecibo, bLimparXMLResposta, bAssinarXML, bForcarGeracao)

      except

      end;
    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);
    LogFrente('XML ESTOQUE criado', DiretorioAtual);
  end
  else
  begin
    Result := _XmlEstoqueBlocoX(PansiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sdtInicial), PAnsiChar(sdtFinal), True, True, True, bForcarGeracao);
  end;

end;

function TSmallBlocoX.XmlEstoqueOmisso(CaminhoBanco, DiretorioAtual,
  sdtInicial, sdtFinal: String; bLimparRecibo, bLimparXMLResposta,
  bAssinarXML, bForcarGeracao: Boolean): Boolean;
// gera xml do estoque de qualquer período
begin

  if FLoad = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGeraXmlEstoqueMes(FEmitente, FIBTransaction, StrToDate(sdtInicial), StrToDate(sdtFinal), bLimparRecibo, bLimparXMLResposta, bAssinarXML, bForcarGeracao)

      except

      end;
    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);
    LogFrente('XML ESTOQUE criado', DiretorioAtual);
  end
  else
  begin
    Result := _XmlEstoqueOmissoBlocoX(PansiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sdtInicial), PAnsiChar(sdtFinal), True, True, True, bForcarGeracao);
  end;

end;

function TSmallBlocoX.TransmitirXmlPendente(CaminhoBanco: String;
  DiretorioAtual: String; sTipo: String; sSerieECF: String;
  bAlerta: Boolean): Integer;
begin
  if FLoad = False then
  begin
    Result := 0;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        Result := BXTransmitirPendenteBlocoX(DiretorioAtual, FEmitente, FIBTransaction, sTipo ,sSerieECF, bAlerta);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
    Result := _TransmitirXmlPendenteBlocoX(PansiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sTipo), PAnsiChar(sSerieECF), bAlerta);
end;

function TSmallBlocoX.ConsultarRecibo(CaminhoBanco: String;
  DiretorioAtual: String; Recibo: String): Boolean;
begin

  if FLoad = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

      try
        FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

        Result := BXConsultarRecibo(FEmitente, FIBTransaction, DiretorioAtual, Recibo);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _ConsultarReciboBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(Recibo));
  end;

end;

function TSmallBlocoX.ServidorSefazConfigurado(UF: String): Boolean;
begin
  if Fload = False then
    Result := BXServidorSefazConfigurado(UF)
  else
    Result := _ServidorBlocoXSefazConfigurado(PAnsiChar(UF));
end;

function TSmallBlocoX.AlertaXmlPendente(CaminhoBanco: String;
  DiretorioAtual: String; sTipo: String; sSerieECF: String;
  bExibirAlerta: Boolean; bRetaguarda: Boolean = False): Boolean;
begin
  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

  //ShowMessage('169'); // Sandro Silva 2018-09-19

        Result := BXAlertarXmlPendente(FEmitente, FIBTransaction, sTipo, sSerieECF, bExibirAlerta, bRetaguarda);

        BXExibeAlertaErros(FEmitente, sTipo, FIBTransaction); // Sandro Silva 2019-04-02

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);
  end
  else
  begin
    Result := _AlertaXmlPendenteBlocox(PansiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sTipo), PAnsiChar(sSerieECF), bExibirAlerta, bRetaguarda);
  end;
end;

function TSmallBlocoX.RestaurarArquivosXML(CaminhoBanco: String;
  DiretorioAtual: String; sTipo: String;
  sSerieECF: String; bApenasUltimo: Boolean): Boolean;
begin

  if Fload = False then
  begin
    Result := False;
    
    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

      try

        BXRestaurarArquivos(FIBTransaction, DiretorioAtual, sTipo, sSerieECF, bApenasUltimo);
        Result := True;

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _RestaurarArquivosBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sTipo), PAnsiChar(sSerieECF), bApenasUltimo);
  end;

end;

function TSmallBlocoX.TratarErroRetornoTransmissao(CaminhoBanco: String;
  DiretorioAtual: String; sXmlResposta: String; sTipo: String;
  sSerie: String; sDataReferencia: String): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXTrataErroRetornoTransmissao(FEmitente, FIBTransaction, sXmlResposta, sTipo, sSerie, sDataReferencia);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _TrataErroRetornoTransmissaoBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sXmlResposta), PAnsiChar(sTipo), PAnsiChar(sSerie), PAnsiChar(sDataReferencia));
  end;

end;

function TSmallBlocoX.SelecionaCertificadoDigital: Boolean;
begin
  Result := False;

  if Fload = False then
  begin
    Result := BXSelecionarCertificadoDigital <> '';
  end
  else
  begin
    if _SelecionaCertificadoDigitalBlocoX then
      Result := True;
  end;

end;

function TSmallBlocoX.ConsultarPendenciasDesenvolvedorPafEcf(CaminhoBanco,
  DiretorioAtual: String): Boolean;
begin

  if FLoad = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXConsultarPendenciasDesenvolvedorPafEcf(FEmitente);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);
  end
  else
  begin
    Result := _ConsultarPendenciasDesenvolvedorPafEcfBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.IdentificaRetornosComErroTratandoTodos(CaminhoBanco,
  DiretorioAtual: String; sTipo: String): Boolean;
begin
  if FLoad = False then
  begin

    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19

      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        Result := BXIdentificaRetornosComErroTratando(FEmitente, FIBTransaction, sTipo);
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _IdentificaRetornosComErroTratando(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(sTipo)); // Sandro Silva 2020-06-22 Result := _IdentificaRetornosComErroTratando(PAnsiChar(CaminhoBanco), PAnsiChar(sTipo), PAnsiChar(DiretorioAtual));

  end;

end;

procedure TSmallBlocoX.ValidaMd5DoListaNoCriptografado;
(*
var
  LbBlowfish: TLbBlowfish;
  Maisini: TIniFile;
  IniSerial: TIniFile;
  sUF: String; //
  sMD5Lista: String; //
  sMD5Cripta: String;
  snro_fabrica: String; //
  svalor_gt: String; //
  sCNPJ: String; //
  sModECF: String;
  sConcomitante: String; //
  sAutorizacaoUso: String; //
  sSerial: String;
  slParams: TStringList;
  slRespostaSite: TStringList;
  lResponse: TStringStream;
  IdHTTP: TIdHTTP;
begin
  GetWindowsDirectory(cWinDir,200);
  LbBlowfish := TLbBlowfish.Create(nil);
  LbBlowfish.CipherMode := cmECB;

  if FileExists(PChar(cWinDir + '\arquivoauxiliarcriptografadopafecfsmallsoft.ini')) then
  begin

    IniSerial := TIniFile.Create('WIND0WS.L0G');
    // Versão 2018
    if IniSerial.SectionExists('SC') then
      sSerial  := IniSerial.ReadString('SC','Ser',''); // 2018
    // Versão 2019
    if IniSerial.SectionExists('RR') then
      sSerial  := IniSerial.ReadString('RR','Ser',''); // 2019
    // Versão 2020
    if IniSerial.SectionExists('LICENCA') then
      sSerial  := IniSerial.ReadString('LICENCA','Ser',''); // 2020
    IniSerial.Free;

    Maisini := TIniFile.Create(PChar(cWinDir + '\arquivoauxiliarcriptografadopafecfsmallsoft.ini'));
    try
      LbBlowfish.GenerateKey(CHAVE_CIFRAR);

      sUF          := Copy(LbBlowfish.DecryptString(StringReplace(Trim(MaisIni.ReadString('UF','I','')), ' ', '', [rfReplaceAll])), 1, 2);
      sMD5Lista    := MD5Print(MD5File(pChar(ExtractFileDir(Application.ExeName) + '\LISTA.TXT')));
      snro_fabrica := LbBlowfish.DecryptString(StringReplace(Trim(MaisIni.ReadString('ECF','SERIE','')), ' ', '', [rfReplaceAll]));
      svalor_gt    := LbBlowfish.DecryptString(MaisIni.ReadString('ECF', 'GT', ''));
      sCNPJ        := LbBlowfish.DecryptString(MaisIni.ReadString('ECF','CGC', ''));

      try
        sMD5Cripta := LbBlowfish.DecryptString(StringReplace(Trim(MaisIni.ReadString('MD5','HOMOLOGADO','')), sCNPJ, '', [rfReplaceAll]));
      except
        sMD5Cripta := '';
      end;

      ShowMessage(sMD5Cripta);
      
      if AnsiUpperCase(sMD5Cripta) <> AnsiUpperCase(sCNPJ+sMD5Lista) then
      begin

        if LimpaNumero(sCNPJ) <> '' then
        begin

          //Form1.memo1.Clear;
          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + sUF;
          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + sMD5Lista;


          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + snro_fabrica;

          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + svalor_gt;
          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + sCNPJ;

          sConcomitante := MaisIni.ReadString('CONCOMITANTE','I','');
          if sConcomitante <> '' then
            sConcomitante := LbBlowfish.DecryptString(MaisIni.ReadString('CONCOMITANTE','I','CONCOMITANTE'))
          else
            sConcomitante := 'CONCOMITANTE';

          //Form1.memo1.Lines.Add('');
          //Form1.memo1.Text := Form1.memo1.Text + sConcomitante;

          if AnsiContainsText(sConcomitante, 'CONTA DE CLIENTE') then //Como conta
          begin
            sConcomitante := 'CONTA DE CLIENTE';
          end
          else
            if AnsiContainsText(sConcomitante, 'CONTA DE CLIENTE OS') then //Como controle de ordem de serviço
            begin
              sConcomitante := 'CONTA DE CLIENTE OS';
            end
            else
              if AnsiContainsText(sConcomitante, 'MESAS') then //Como controle de mesas
              begin
                sConcomitante := 'MESAS';
              end
              else
                if AnsiContainsText(sConcomitante, 'MESA - CONSUMO') then //Como mesa
                begin
                  sConcomitante := 'MESA - CONSUMO';
                end
                else
                  if AnsiContainsText(sConcomitante, 'DAV') then //Como controle de DAV
                    sConcomitante := 'DAV'
                  else
                    sConcomitante := 'CONCOMITANTE';

          //Form1.memo1.Text := Form1.memo1.Text + ' - ' + sConcomitante;
        end;

        IdHTTP := TIdHTTP.Create(nil);
        slRespostaSite := TStringList.Create;
        slParams       := TStringList.Create;
        lResponse := TStringStream.Create('');

        try
          IdHTTP.Request.CustomHeaders.Clear;
          IdHTTP.Request.Clear;
          IdHTTP.Request.ContentType     := 'application/x-www-form-urlencoded';
          IdHTTP.Request.ContentEncoding := 'multipart/form-data';
          IdHTTP.Request.UserAgent       := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
          IdHTTP.ReadTimeout             := 30000;

          // Parâmetros aguardados no site são Case sensitive
          slParams.Add('uf=' + sUF);
          slParams.Add('md5=' + sMD5Lista);
          slParams.Add('serial=' + sSerial);
          slParams.Add('nro_fabrica=' + snro_fabrica);
          slParams.Add('valor_GT=' + svalor_gt);
          slParams.Add('cnpj=' + sCNPJ);
          slParams.Add('modecf=' + sModECF);
          slParams.Add('concomitante=' + sConcomitante);
          slParams.Add('autorizacao_uso=' + sAutorizacaoUso);

          IdHTTP.Post('http://www.smallsoft.com.br/adm/assinatura-paf.php', slParams, lResponse);

          lResponse.Position := 0;
          slRespostaSite.LoadFromStream(lResponse);
          //Form1.Memo1.Lines.Add(slRespostaSite.Text);
          //Form1.Memo1.Lines.Add(xmlNodeValue(slRespostaSite.Text, '//md5'));


          if AnsiUpperCase(xmlNodeValue(slRespostaSite.Text, '//md5')) = AnsiUpperCase(sMD5Lista) then
            MaisIni.WriteString('MD5','HOMOLOGADO', LbBlowfish.EncryptString(sCNPJ + AnsiLowerCase(Trim(xmlNodeValue(slRespostaSite.Text, '//md5'))))); // Cifra cnpj emitente + md5 do lista

        except
        end;

        FreeAndNil(slParams);
        FreeAndNil(lResponse);
        FreeAndNil(slRespostaSite);
        FreeAndNil(IdHTTP);

      end; // MD5 contido no cripta é diferente do MD5 do lista.txt

    except

    end;

    MaisIni.Free;
  end;

  FreeAndNil(LbBlowfish);

end;
*)
begin
  ufuncoesblocox.ValidaMd5DoListaNoCriptografado;
end;

function TSmallBlocoX.VisualizaXmlBlocoX(CaminhoBanco,
  DiretorioAtual: String; sTipo: String): Boolean;
begin
  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXVisualizaXmlBlocoX(FEmitente, FIBTransaction.DefaultDatabase.DatabaseName, sTipo, DiretorioAtual); // Sandro Silva 2020-06-18 BXVisualizaXmlBlocoX(FEmitente, FIBTransaction, sTipo, DiretorioAtual);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _VisualizaXmlBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(sTipo), PAnsiChar(DiretorioAtual));
  end;

end;


////////////////////////////// Fim Classe dll bloco X
//////////////////////////////

function TSmallBlocoX.ReprocessarArquivoBlocoX(CaminhoBanco,
  DiretorioAtual, Recibo: PAnsiChar): Boolean;
begin
  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXReprocessarArquivo(FEmitente, FIBTransaction, DiretorioAtual, Recibo);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _ReprocessarArquivoBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(Recibo));
  end;

end;

function TSmallBlocoX.CancelarArquivoBlocoX(CaminhoBanco, DiretorioAtual,
  Recibo: PAnsiChar): Boolean;
begin
  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXCancelarArquivo(FEmitente, FIBTransaction, DiretorioAtual, Recibo);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _CancelarArquivoBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual), PAnsiChar(Recibo));
  end;

end;

function TSmallBlocoX.GerarAoFISCOREDUCAOZBlocox(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try
        BXGerarAoFISCOREDUCAOZ(FEmitente, FIBTransaction);
        Result := True;
      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarAoFISCOREDUCAOZBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.GerarEstoqueAnoAnterior(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
// Sandro Silva 2022-11-22
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGerarEstoqueAnoAnterior(FEmitente, FIBTransaction);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarEstoqueAnoAnteriorBlocoX(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.GerarEstoqueMudancaDeTributacao(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGerarEstoqueMudancaDeTributacao(FEmitente, FIBTransaction);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarEstoqueMudancaDeTributacao(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.GerarEstoqueSuspensaoOuBaixaDeIE(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGerarEstoqueSuspensaoOuBaixaDeIE(FEmitente, FIBTransaction);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarEstoqueSuspensaoOuBaixaDeIE(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.GerarEstoqueMudancaDeRegime(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGerarEstoqueMudancaDeRegime(FEmitente, FIBTransaction);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarEstoqueMudancaDeRegime(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

function TSmallBlocoX.GerarEstoqueAtual(CaminhoBanco,
  DiretorioAtual: PAnsiChar): Boolean;
begin

  if Fload = False then
  begin
    Result := False;

    ConectaIBDataBase(FIBDATABASE, CaminhoBanco);

    if FIBDATABASE.Connected then
    begin

  //ShowMessage('163 ' + DiretorioAtual); // Sandro Silva 2018-09-19
      FEmitente := DadosEmitente(FIBTransaction, DiretorioAtual);

      try

        Result := BXGerarEstoqueAtual(FEmitente, FIBTransaction);

      except

      end;

    end;

    FechaIBDataBase(FIBDATABASE);

    ChDir(DiretorioAtual);

  end
  else
  begin
    Result := _GerarEstoqueAtual(PAnsiChar(CaminhoBanco), PAnsiChar(DiretorioAtual));
  end;

end;

end.
