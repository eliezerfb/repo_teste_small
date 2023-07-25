(*////////////////////////////////////////////////////////////////////////////////
Funções utilizadas em diferentes units do projeto.
Estavam no form1, causando muita dependência
////////////////////////////////////////////////////////////////////////////////*)
unit ufuncoesfrente;

interface

uses Windows, IniFiles, SysUtils, MSXML2_TLB, Forms, Dialogs,
  Classes, LbCipher, LbClass,
  ShellApi // Sandro Silva 2019-02-20
  , DateUtils
  , DB // Sandro Silva 2019-03-14
  , Controls // Sandro Silva 2019-06-14
  , Printers
  , WinSpool
  , WinSock // Sandro Silva 2019-08-29 ER 02.06 UnoChapeco
  , IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP
  , DBGrids
  , TlHelp32
  , Menus
  , MAPI
  {$IFDEF VER150}
  , IBDatabase, IBQuery, IBCustomDataSet
  , MD5
  , SmallFunc
  {$ELSE}
  , IBX.IBDatabase, IBX.IBQuery, IBX.IBCustomDataSet
  , MD5_unicode
  , smallfunc_xe
  {$ENDIF}
  , ExtCtrls
  , DBClient
//  , StdCtrls
  , uconstantes_chaves_privadas
  //, uClasseValidaRecursos
  , uValidaRecursosDelphi7
  ;

const MSG_ALERTA_MENU_FISCAL_INACESSIVEL = 'Menu Fiscal Indisponível nesta tela'; // Sandro Silva 2021-07-28 const MSG_ALERTA_MENU_FISCAL_INACESSIVEL = 'MENU FISCAL INACESSÍVEL NESTA TELA';
const CHAVE_PUBLICA = 'DF9F4DC6AF517A889BCE1181DEF8394455DBCD19768E8C785D9121E8DB9B9B104E5231EE8F8299D24451465178D3FC41D40DAFAF9C855824393FC964C747'+
                      '5C3993104443E8E73333D93C24E5D46B27D9A4DF5E6F0B05490B6C6829CEFA1030294DABC29E498A0F6096E8CE26B407B2E1B4939FDE6174EC1621BB3E988D29742D';

const TEXTO_CAIXA_LIVRE            = 'CAIXA LIVRE';
const TEXTO_CAIXA_EM_VENDA         = 'EM VENDA';

const COR_AZUL = $00EAB231; // Sandro Silva 2021-08-17

const FORMA_PAGAMENTO_A_VISTA         = 'A VISTA';
const FORMA_PAGAMENTO_BOLETO          = 'BOLETO';
const FORMA_PAGAMENTO_CARTAO          = 'CARTAO';
const FORMA_PAGAMENTO_CHEQUE          = 'CHEQUE'; // Sandro Silva 2016-04-19

const FRENTE_INI                      = 'FRENTE.INI';
const SECAO_FRENTE_CAIXA              = 'Frente de Caixa';
const SECAO_65                        = 'NFCE';
const SECAO_59                        = 'SAT-CFe';
const SECAO_MFE                       = 'MFE'; // Sandro Silva 2017-05-10
const CHAVE_INICIAR_MINIMIZADO        = 'Iniciar minimizado';
const CHAVE_INICIAR_COM_WINDOWS       = 'Iniciar com Windows';
const CHAVE_FORMAS_CONFIGURADAS       = 'Formas Configuradas';
const CHAVE_IMPRIMIR_CEST             = 'Imprimir CEST';
const CHAVE_IDENTIFICAR_POS           = 'Identificar POS';
const CHAVE_IMPRESSORA_PADRAO         = 'Impressora Padrao';
const CHAVE_CARNE_RESUMIDO            = 'Carne resumido';// Sandro Silva 2018-04-29
const CHAVE_TEF_CARTEIRA_DIGITAL      = 'TEF Carteira Digital'; // Configura no frente.ini se usa carteira digital com TEF Sandro Silva 2021-08-27
const CHAVE_CERTIFICADO_DIGITAL       = 'Certificado'; // Sandro Silva 2022-11-17
const INTERVAL_FRENTE_MINIMIZADO      = 5000; // 2015-12-01 15000;// 15 segundos
const INTERVAL_FRENTE_MAXIMIZADO      = 5000; // 2015-12-01 60000;// 60 segundos
const CNPJ_SOFTWARE_HOUSE_PAF         = '03.916.076/0006-64'; // Sandro Silva 2022-12-02 Unochapeco '07.426.598/0001-24';
const IE_SOFTWARE_HOUSE_PAF           = '262037645'; // Sandro Silva 2022-12-02 Unochapeco '255422385';
const IM_SOFTWARE_HOUSE_PAF           = 'ISENTO'; // Sandro Silva 2022-12-02 Unochapeco '22842';  // usar ISENTO
const RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF = 'Zucchetti Software e Sistemas Ltda'; // Sandro Silva 2022-12-02 Unochapeco 'Smallsoft Tecnologia em Informática EIRELI';
const VERSAO_ER_PAF_ECF               = '02.06'; // ER 02.06 Sandro Silva 2019-06-19  '02.05'; // Sandro Silva 2017-07-24 ER 02.05 '02.03';
const NUMERO_LAUDO_PAF_ECF            = 'UNO3972022';// Sandro Silva 2022-12-12 Unochapeco 'UNO3302019';
const DATA_EMISSAO_LAUDO_PAF_ECF      = '12/12/2022'; // Sandro Silva 2022-12-02 Unochapeco
const NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF = 'arquivoauxiliarcriptografadopafecfsmallsoft.ini'; // usado também pelo SAT

const NFCE_CSTAT_AUTORIZADO_100               = '100';
const NFCE_CSTAT_AUTORIZADO_FORA_DE_PRAZO_150 = '150';
const NFCE_CSTAT_CANCELADA_135                = '135';

const PAGAMENTO_EM_CARTAO = 'Pagamento em Cartão';

const NUMERO_FORMAS_EXTRAS = 8;

type
  TDadosEmitente = class
    Razao: String;
    CNPJ: String;
    UF: String;    
  end;

type
  TTipoPesquisa = (tpPesquisaOS, tpPesquisaOrca, tpPesquisaGerencial);

type
  TTipoInfoCombo = (tiInfoComboModeloSAT, tiInfoComboImpressoras, tiInfoComboFusoHorario, tiInfoComboContaClienteOS);

type
  TAliquota = class // Sandro Silva 2019-06-13  TAliquota = record
    Aliquota: String;
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
end;

type
  TCFOP = class // Sandro Silva 2019-06-13  TCFOP = record
    CFOP: String;
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
end;

type
  TCST = class // Sandro Silva 2019-06-13 TCST = record
    CST: String;
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
end;

type
  TCSOSN = class // Sandro Silva 2019-06-13 TCSOSN = record
    CSOSN: String;
    Valor: Double;
    Acrescimo: Double;
    Desconto: Double;
end;

type
  TForma = class // Sandro Silva 2019-06-13 TForma = record
    Forma: String;
    Valor: Double;
end;

type
  TCaixa = class // Sandro Silva 2019-06-14 TCaixa = record
    sCaixa: String;
    dValor: Double;
  end;

type
  TDiario = class
    dtData: TDate;
    dDesconto: Double;
    dAcrescimo: Double;
    dTotal: Double;
  end;

type
  TContingencia = class
    bTransmissaoPendente: Boolean;
    sdtPendente: String;
    LimiteDias: Integer;
    dtUltimaTransmissao: TDate;
  end;

type
  TTipoEntrega = class(TComponent)
  private
    FDomicilio: Boolean;
    procedure SetDomicilio(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property Domicilio: Boolean read FDomicilio write SetDomicilio;
  end;

type
  TMyApplication = class
  private
    FImgLogo: TImage;
    FUrlDataBase: String;
  public
    constructor Create(AOWner: TComponent);
    property ImgLogo: TImage read FImgLogo write FImgLogo;
    property UrlDataBase: String read FUrlDataBase write FUrlDataBase;
  end;

type
  // Tipo para leitura e gravação de arquivos grandes não suportados por TStringList
  TArquivo = class
  private
    FTexto: String;
    FArquivo: TextFile;
  protected 
  public
    property Texto: String read FTexto write FTexto;
    procedure SalvarArquivo(FileName: TFileName);
    procedure LerArquivo(FileName: TFileName; bBreakLine: Boolean = True);
  published
  end;

{$IFDEF VER150}
function GetIP: String;
{$ENDIF}
function LerParametroIni(sArquivo: String; sSecao: String; sParametro: String; sValorDefault: String): String;
function GravarParametroIni(sArquivo: String; sSecao: String; sParametro: String; sValor: String): String;
function xmlNodeXml(sXML: String; sNode: String): String;
function xmlNodeValueToFloat(sXML, sNode: String;
  sDecimalSeparator: String = '.'): Double;
function xmlNodeValue(sXML: String; sNode: String): String;
function CriaIBDataBase: TIBDatabase;
function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
function TamanhoCampo(IBTransaction: TIBTransaction; Tabela: String;
  Campo: String): Integer;
function TabelaExisteFB(Banco: TIBDatabase; sTabela: String): Boolean;
function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
function IndiceExiste(Banco: TIBDatabase; sTabela: String;
  sIndice: String): Boolean;
function IntToStrAlignR(Value: Integer; CasasDireita: Integer): String;
function FloatToStrAlignR(Value: Double; CasasDecimais: Integer; CasasDireita: Integer): String;
function SemMarcaTag(Value: String): String;
function AliquotaISSConfigura(IBTransaction: TIBTransaction): String;
function IncGenerator(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): String; 
function IncGeneratorToInt(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): Int64;
function ValidaCPFCNPJ(sNumero: String): Boolean;
function RetornaValorDaTagNoCampo(sTag: String; sObs: String): String;
function ShellExecuteAndWait(Operation, FileName, Parameter, Directory: String;
  Show: Word; bWait: Boolean): Longint;
function ValidaAjustaFusoHorario(sUF: String; sFusoAtual: String;
  sFusoHorarioPadrao: String; bHorarioDeVerao: Boolean): String; // Sandro Silva 2019-02-27
function TiraSerialDaLista(sListaSeriais: String; sSerialTirar: String): String;
procedure GravaPendenciaAlteraca(IBDatabase: TIBDatabase; bOffLine: Boolean;
  sCaixa: String; sPedido: String; sItem: String; sTipo: String);
function indRegraSAT(sCFOP: String): String;
function TruncaValor(dValor: Double; iDecimais: Integer = 2): Double;
//function UsuariosConectados(IBDatabase: TIBDatabase): Integer;
function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
function XmlValueToFloat(Value: String;
  SeparadorDecimalXml: String = '.'): Double;
function TefUsado: String;
procedure AdicionaCNPJRequisicaoTEF(var tfFile: TextFile; DataSet: TDataSet);
function BandeiraSemCreditoDebito(sBandeira: String): String;
function SelecionaCNPJCredenciadora(DATASETCLIFOR: TDataSet; sBandeira: String): String;
function DiasParaExpirar(IBDATABASE: TIBDatabase; bValidacaoNova: Boolean = True): Integer;
function Legal_ok(IBDATABASE: TIBDatabase): Boolean;
function CifrarTexto(sTexto: String): String;
function DescricaoCRT(sCrt: String): String;
function ConcatencaNodeNFeComProtNFe(sNFe: String; sprotNFe: String): String;
function FormataNumeroDoCupom(iCupom: Integer): String;
function ColumnIndex(Columns: TDBGridColumns; FieldName: String): Integer;
procedure AjustaLarguraDBGrid(DBGrid: TDBGrid);
procedure AjustarBufferChuncks(Form: TForm);
function DistribuicaoDFe(dtDataI: TDate; dtDataF: TDate; Diretorio: String;
  IBTRANSACTION: TIBTransaction): Boolean;
function GetComputerNameFunc: String;
function SelecionaXmlEnvio(Path: String; sDigestValue: String;
  NodeDigest: String): String;
procedure ListaDeArquivos(var Lista: TStringList; sAtual: String;
  sExtensao: String = '*.txt');
function ConsultaProcesso(sP1: String): Boolean;
function NomeModeloDocumento(sModeloDocumento: String): String;
procedure OpcoesMenuVisivel(Menu: TMenuItem; Visible: Boolean);
function TempoDecorridoPorExtenso(dtDataF, dtDataI: Tdate; ttHoraF, ttHoraI: TTime): String;
// Sandro Silva 2023-06-23 function SerialMEI(sSerial: String): Boolean;
function PAFNFCe: Boolean;
function NFCe: Boolean;
function Gerencial: Boolean;
function SAT: Boolean;
function MFE: Boolean;
function Build: String;
function SmallMessageBox(const Text, Caption: String; Flags: Longint): Integer;
function ValidaEmail(sP1: String):Boolean;
function EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo: String; bConfirma: Boolean): Integer;
function CriaCDSALIQ: TClientDataSet;
function CriaCDSCFOP: TClientDataSet;
function ConverteAcentosXML(pP1: String): String;
function UsaKitDesenvolvimentoSAT: Boolean;
function SelectMarketplace(sNome: String): String;
function FormaDePagamentoPadrao(sForma: String): Boolean;
function FormaExtraDePagamento(sForma: String): Boolean;
function SelectSQLGerenciadorVendasF10(sModeloECF: String;
  sModeloECF_Reserva: String; Data: TDate): String;
function RetornaTextoEmVenda(sModelo: String): String;  
//function ValidaQtdDocumentoFiscal(Recursos: TValidaRecurso): Boolean;
procedure ValidaValorAutorizadoCartao(ibDataSet25: TIBDataSet; TEFValorTotalAutorizado: Double);
function GravaDadosTransacaoEletronica(IBTransaction: TIBTransaction;
  dtData: TDate; sPedido: String; sCaixa: String; sModelo: String;
  sGNF: String; sForma: String; dValor: Double; sTransacao: String;
  sNomeRede: String; sAutorizacao: String; sBandeira: String): Boolean;
function AtualizaDadosTransacaoEletronica(IBTransaction: TIBTransaction;
  sPedidoOld: String; sCaixaOld: String; sModeloOld: String; dtData: TDate;
  sPedido: String; sCaixa: String; sModelo: String): Boolean;
var
  cWinDir: array[0..200] of Char;
  TipoEntrega: TTipoEntrega; // Sandro Silva 2020-06-01
  Aplicacao: TMyApplication;
  bImportarServicoDeOsOrcamento: Boolean = True; // Controlar se importa ou não serviço listados em Orçamento/OS para NFC-e/SAT. Sempre inicia como True Sandro Silva 2021-08-17
  //RecursosLicenca: TRecurcosDisponiveisParaLicenca;
  ValidaRecursos: TValidaRecurso;
  DadosEmitentePDV: TDadosEmitente;

implementation

uses StrUtils, uTypesRecursos;

//////////////////////////////
{$IFDEF VER150}
function GetIP: String;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^  do
  begin
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;
{$ENDIF}

function LerParametroIni(sArquivo: String; sSecao: String; sParametro: String; sValorDefault: String): String;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(sArquivo);

  Result := Trim(ini.ReadString(sSecao, sParametro, sValorDefault));
  Ini.Free;

end;

function GravarParametroIni(sArquivo: String; sSecao: String; sParametro: String; sValor: String): String;
begin
  with TIniFile.Create(sArquivo) do
  begin
    WriteString(sSecao, sparametro, sValor);
    Free;
  end;
end;

function xmlNodeXml(sXML: String; sNode: String): String;
//Sandro Silva 2012-02-08 inicio
// Extrai valor do elemento no xml
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
begin
  // Sandro Silva 2019-07-23  XMLDOM := CoDOMDocument50.Create; // Sandro Silva 2019-04-17 XMLDOM := CoDOMDocument.Create;
  XMLDOM := CoDOMDocument.Create; // Tem que criar como CoDOMDocument, CoDOMDocument50 não funcionou 100% 
  XMLDOM.loadXML(sXML);
  Result := '';
  xNodes := XMLDOM.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := xNodes.item[iNode].xml;
  end;
  XMLDOM := nil;
  xNodes := nil; // Sandro Silva 2019-06-19 
end;

function xmlNodeValueToFloat(sXML, sNode: String;
  sDecimalSeparator: String = '.'): Double;
//Sandro Silva 2017-05-23 inicio
//Converte valor no xml para Float
//sDecimalSeparator: Deve ser ',' ou '.'
var
  sValor: String;
begin
  sValor := xmlNodeValue(sXML, sNode);
  if sDecimalSeparator = '.' then
  begin
   sValor := StringReplace(sValor, ',', '', [rfReplaceAll]);
   sValor := StringReplace(sValor, '.', ',', [rfReplaceAll]);
  end
  else
   sValor := StringReplace(sValor, '.', '', [rfReplaceAll]);

  Result := StrToFloatDef(sValor, 0);
end;

function xmlNodeValue(sXML: String; sNode: String): String;
//Sandro Silva 2012-02-08 inicio
//Extrai valor do elemento no xml
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
  function utf8Fix(sTexto: String): String;
  const
    acento : array[1..46] of string = ('á', 'à', 'â', 'ã', 'ä', 'é', 'è', 'ê', 'ë', 'í', 'ì', 'î', 'ï', 'ó', 'ò', 'ô', 'õ', 'ö', 'ú', 'ù', 'û', 'ü', 'ç', 'Á', 'À', 'Â', 'Ã', 'Ä', 'É', 'È', 'Ê', 'Ë', 'Í', 'Ì', 'Î', 'Ï', 'Ó', 'Ò', 'Ô', 'Õ', 'Ö', 'Ú', 'Ù', 'Û', 'Ü', 'Ç');
    utf8: array[1..46] of string = ('Ã¡','Ã ','Ã¢','Ã£','Ã¤','Ã©','Ã¨','Ãª','Ã«','Ã­','Ã¬','Ã®','Ã¯','Ã³','Ã²','Ã´','Ãµ','Ã¶','Ãº','Ã¹','Ã»','Ã¼','Ã§','Ã','Ã€','Ã‚','Ãƒ','Ã„','Ã‰','Ãˆ','ÃŠ','Ã‹','Ã','ÃŒ','ÃŽ','Ã','Ã“','Ã’','Ã”','Ã•','Ã–','Ãš','Ã™','Ã›','Ãœ','Ã‡');
  var
    iLetra: Integer;
  begin
    Result := sTexto;
    for iLetra := 1 to length(utf8) do
    begin
      if Pos(utf8[iLetra], Result) > 0 then
        Result := StringReplace(Result, utf8[iLetra], acento[iLetra], [rfReplaceAll]);
    end;
  end;
begin
  //XMLDOM := CoDOMDocument50.Create; // Sandro Silva 2019-04-17 XMLDOM := CoDOMDocument.Create;
  XMLDOM := CoDOMDocument.Create;
  XMLDOM.loadXML(sXML);

  Result := '';
  try
    xNodes := XMLDOM.selectNodes(sNode);
    for iNode := 0 to xNodes.length -1 do
    begin
      Result := utf8fix(xNodes.item[iNode].text);
    end;
  except
  end;
  XMLDOM := nil;
  xNodes := nil; // Sandro Silva 2019-06-19 
end;

function CriaIBDataBase: TIBDatabase;
begin
  Result := TIBDatabase.Create(nil);
  Result.LoginPrompt            := False;
  Result.IdleTimer              := 0;
  Result.SQLDialect             := 3;
  Result.TraceFlags             := [];
  Result.AllowStreamedConnected := False;
  Result.Params.Add('user_name=SYSDBA');
  Result.Params.Add('password=masterkey');
end;

function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
{Sandro Silva 2011-04-12 inicio
Cria um objeto TIBTransaction}
begin
  try
    Result := TIBTransaction.Create(nil); // Sandro Silva 2019-06-18 Result := TIBTransaction.Create(Application); 
    Result.Params.Add('read_committed');
    Result.Params.Add('rec_version');
    Result.Params.Add('nowait');
    Result.DefaultDatabase := IBDATABASE;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Result := nil;
    end
  end;
end;

function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
// Sandro Silva 2011-04-12 inicio Cria um objeto TIBQuery
begin
  try
    Result := TIBQuery.Create(nil); // Sandro Silva 2019-06-18 Result := TIBQuery.Create(Application); 
    Result.Database    := IBTRANSACTION.DefaultDataBase;
    Result.Transaction := IBTRANSACTION;
    Result.BufferChunks := 100; // 2014-02-26 Erro de out of memory
  except
    on E: Exception do
    begin
      Result := nil;
    end
  end;
end;

function TamanhoCampo(IBTransaction: TIBTransaction; Tabela: String;
  Campo: String): Integer;
// Sandro Silva 2018-07-26 Retorna o tamanho do campo na tabela do banco.
// Usado para evitar tentativa de gravar mais caracteres que o campo suporta
var
  IBQTABELA: TIBQuery;
begin
  Result := 0;
  IBQTABELA := CriaIBQuery(IBTransaction);
  try
    IBQTABELA.Close;
    IBQTABELA.SQL.Text :=
      'select first 1 ' + Campo +
      ' from ' + Tabela +
      ' where REGISTRO = ''xxx'' ';
    IBQTABELA.Open;
    Result := IBQTABELA.FieldByName(Campo).Size;
  except

  end;
  FreeAndNil(IBQTABELA);
end;

function TabelaExisteFB(Banco: TIBDatabase; sTabela: String): Boolean;
{Sandro Silva 2015-10-01 inicio
Retorna True se encontrar a tabela informada}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select distinct F.RDB$RELATION_NAME as TABELA ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and F.RDB$RELATION_NAME = ' + QuotedStr(sTabela);
    IBQUERY.Open;
    Result := (IBQUERY.FieldByName('TABELA').AsString <> '');
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function CampoExisteFB(Banco: TIBDatabase; sTabela: String;
  sCampo: String): Boolean;
{Sandro Silva 2011-04-15 inicio
Retorna True se encontrar a tabela e o campo informado}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);
  try
    IBQUERY.Close;
    IBQUERY.SQL.Text :=
      'select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and F.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
      ' and F.RDB$FIELD_NAME = ' + QuotedStr(sCampo);
    IBQUERY.Open;
    Result := (IBQUERY.IsEmpty = False);
  finally
    IBTRANSACTION.Rollback;
    FreeAndNil(IBQUERY);
    FreeAndNil(IBTRANSACTION);
  end;
end;

function IndiceExiste(Banco: TIBDatabase; sTabela: String;
  sIndice: String): Boolean;
{Sandro Silva 2012-02-23 inicio
Pesquisa na base se o índice existe na tabela, retornando True/False}
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);

  IBQUERY.Close;
  IBQUERY.SQL.Text :=
    'select I.RDB$INDEX_NAME as NOMEINDICE ' +
    'from RDB$INDICES I ' +
    'where I.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
    ' and I.RDB$INDEX_NAME = ' + QuotedStr(sIndice);
  IBQUERY.Open;

  Result := (Trim(IBQUERY.FieldByName('NOMEINDICE').AsString) <> '');
end;

function IntToStrAlignR(Value: Integer; CasasDireita: Integer): String;
// Converte inteiro para texto e preenche espaços a esquerda para que
// o valor fique alinhado a direita quando impresso usando a função
// ImpressaoNaoSujeitoaoICMS()
begin
  Result := FormatFloat(',0', Value);
  if CasasDireita > Length(Result) then
    Result := DupeString(' ', CasasDireita - Length(Result)) + Result;
end;

function FloatToStrAlignR(Value: Double; CasasDecimais: Integer; CasasDireita: Integer): String;
// Converte para texto, conforme casas decimais e preenche espaços a esquerda para que
// o valor fique alinhado a direita quando impresso usando a função
// ImpressaoNaoSujeitoaoICMS()
begin
  if CasasDecimais > 0 then
    Result := FormatFloat(',0.' + DupeString('0', CasasDecimais), Value)
  else
    Result := FormatFloat(',0', Value);
  if CasasDireita > Length(Result) then
    Result := DupeString(' ', CasasDireita - Length(Result)) + Result;
end;

function SemMarcaTag(Value: String): String;
// Elimina os caractéres identificadores de tag "<" e ">"
begin
  Value := StringReplace(Value, '<', '', [rfReplaceAll]);
  Value := StringReplace(Value, '>', '', [rfReplaceAll]);
  Result := Value;
end;

function AliquotaISSConfigura(IBTransaction: TIBTransaction): String;
var
  sAliqISS: String;
  IBQISS: TIBQuery;
begin

  IBQISS := CriaIBQuery(IBTransaction);

  IBQISS.BufferChunks   := 10; // Sandro Silva 2018-12-14
  IBQISS.UniDirectional := True; // Sandro Silva 2018-12-14
  IBQISS.DisableControls; // Sandro Silva 2018-12-14

  IBQISS.Close;
  IBQISS.sql.Add('select * from ICM order by CFOP');
  IBQISS.Open;


  sAliqISS := '0000';
  IBQISS.First; // saber qual a aliquota associada //
  while not IBQISS.EOF do
  begin
    //
    // deve ter alíquota e base de ISS preenchido e não ter base de ICMS
    if (IBQISS.FieldByName('ISS').AsFloat > 0) and (IBQISS.FieldByName('BASEISS').AsString <> '') and (IBQISS.FieldByName('BASE').AsFloat = 0) then // Sandro Silva 2019-04-12 if IBQISS.FieldByName('ISS').AsFloat > 0 then
    begin
      sAliqISS := StrZero(IBQISS.FieldByName('ISS').AsFloat * 100,4,0);
      Break;
    end;
    //
    IBQISS.Next;
    //
  end;
  FreeAndNil(IBQISS); // Sandro Silva 2018-12-14 
  Result := sAliqISS;
end;

function IncGenerator(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): String;
var
  IBTTEMP: TIBTransaction;
  IBQTEMP: TIBQuery;
begin
  IBTTEMP := CriaIBTransaction(IBDataBase);
  IBQTEMP := CriaIBQuery(IBTTEMP);
  Result := '0';
  try
    IBQTEMP.Close;
    IBQTEMP.SQL.Text := 'select gen_id(' + sGenerator + ', '+ IntToStr(iQtd) +') as NUMERO from rdb$database';
    IBQTEMP.Open;
    Result := IBQTEMP.FieldByName('NUMERO').AsString;
    IBQTEMP.Transaction.Rollback;
  except
  end;
  FreeAndNil(IBQTEMP);
  FreeAndNil(IBTTEMP);
end;

function IncGeneratorToInt(IBDataBase: TIBDatabase; sGenerator: String;
  iQtd: Integer = 1): Int64;
var
  IBTTEMP: TIBTransaction;
  IBQTEMP: TIBQuery;
begin
  IBTTEMP := CriaIBTransaction(IBDataBase);
  IBQTEMP := CriaIBQuery(IBTTEMP);
  Result := 0;
  try
    IBQTEMP.Close;
    IBQTEMP.SQL.Text := 'select gen_id(' + sGenerator + ', '+ IntToStr(iQtd) +') as NUMERO from rdb$database';
    IBQTEMP.Open;
    Result := IBQTEMP.FieldByName('NUMERO').AsInteger;
    IBQTEMP.Transaction.Rollback;
  except
  end;
  FreeAndNil(IBQTEMP);
  FreeAndNil(IBTTEMP);
end;

function ValidaCPFCNPJ(sNumero: String): Boolean;
// Verifica se o CPF/CNPJ é válido. CpfCgc() retorna True quando a string for vazia
begin
  Result := False;
  sNumero := LimpaNumero(sNumero);
  if sNumero <> '' then
  begin
    Result := CpfCgc(sNumero);
  end;
end;

function RetornaValorDaTagNoCampo(sTag: String; sObs: String): String;
// Exemplo: Obs= <descANP>GLP</descANP> retorna GLP
//          Obs= <descANP>GLP<descANP> retorna GLP
var
  sTextoTag: String;
begin
  Result := '';
  sObs := Trim(sObs);
  sObs := StringReplace(sObs, #$D#$A, '', [rfReplaceAll]); // Eliminar quebras de linha geradas no cadastro de produto pelo campo blob
  if AnsiContainsText(sObs, '<' + sTag + '>') then
  begin
    sTextoTag := Copy(sObs, Pos('<' + sTag + '>', sObs) + Length('<' + sTag + '>'), Length(sObs));
    sTextoTag := StringReplace(STextoTag, '</' + sTag, '<' + sTag, []);
    Result := Copy(sTextoTag, 1, Pos('<' + sTag + '>', STextoTag) -1);
  end;
end;

function ShellExecuteAndWait(Operation, FileName, Parameter, Directory: String;
  Show: Word; bWait: Boolean): Longint;
// Abre outro executável e aguardo ele ser finalizado para continuar a execução
// Show: SW_SHOWNORMAL; SW_MAXIMIZE; SW_MINIMIZE; SW_HIDE
var
  bOK: Boolean;
  Info: TShellExecuteInfo;
begin
  FillChar(Info, SizeOf(Info), Chr(0));
  Info.cbSize       := SizeOf(Info);
  Info.fMask        := SEE_MASK_NOCLOSEPROCESS;
  Info.lpVerb       := PChar(Operation);
  Info.lpFile       := PChar(FileName);
  Info.lpParameters := PChar(Parameter);
  Info.lpDirectory  := PChar(Directory);
  Info.nShow        := Show;
  bOK := Boolean(ShellExecuteEx(@Info));
  if bOK then
  begin
    if bWait then
    begin
      while WaitForSingleObject(Info.hProcess, 100) = WAIT_TIMEOUT do
        Application.ProcessMessages;
      bOK := GetExitCodeProcess(Info.hProcess, DWORD(Result));
    end
    else
      Result := 0;
  end;
  if not bOK then
    Result := -1;
end;

function ValidaAjustaFusoHorario(sUF: String; sFusoAtual: String;
  sFusoHorarioPadrao: String; bHorarioDeVerao: Boolean): String;
begin
  // Ajusta o fuso horário quando trocar a UF do Emitente
  Result := sFusoAtual;
  if bHorarioDeVerao = False then
  begin
    if sFusoHorarioPadrao <> sFusoAtual then
      Result := DefineFusoHorario('FRENTE.INI', 'NFCE', 'Fuso', sUF, '', False);
  end
  else
  begin
    if ('-' + Copy(TimeToStr(IncHour(StrToTime(StringReplace(sFusoHorarioPadrao, '-', '', [])), -1)), 1, 5)) <> sFusoAtual then
      Result := DefineFusoHorario('FRENTE.INI', 'NFCE', 'Fuso', sUF, '', True);
  end;
end;

function TiraSerialDaLista(sListaSeriais: String; sSerialTirar: String): String;
//Elimina o código do serial da lista se seriais lançado em uma venda, quando o item é cancelado
begin
  if Pos(sSerialTirar + ', ', sListaSeriais) > 0 then // Primeiro da lista
    sListaSeriais := StringReplace(sListaSeriais, Trim(sSerialTirar) + ', ','', [])
  else
    if Pos(', ' + sSerialTirar, sListaSeriais) > 0 then // Último da lista
      sListaSeriais := StringReplace(sListaSeriais, ', ' + Trim(sSerialTirar),'', [])
    else
      sListaSeriais := StringReplace(sListaSeriais, Trim(sSerialTirar),'', []);
  sListaSeriais := Trim(sListaSeriais);
  Result := sListaSeriais;
end;

procedure GravaPendenciaAlteraca(IBDatabase: TIBDatabase; bOffLine: Boolean;
  sCaixa, sPedido, sItem, sTipo: String);
var
  IBTPENDENCIA: TIBTransaction;
  IBQPENDENCIA: TIBQuery;
begin
  if bOffLine then
  begin
    IBTPENDENCIA := CriaIBTransaction(IBDatabase);
    IBQPENDENCIA := CriaIBQuery(IBTPENDENCIA);

    try
      IBQPENDENCIA.Close;
      IBQPENDENCIA.SQL.Text :=
        'insert into PENDENCIA (CAIXA, PEDIDO, ITEM, TIPO) ' +
        'values (:CAIXA, :PEDIDO, :ITEM, :TIPO)';
      IBQPENDENCIA.ParamByName('CAIXA').AsString     := sCaixa;
      IBQPENDENCIA.ParamByName('PEDIDO').AsString    := sPedido;
      IBQPENDENCIA.ParamByName('ITEM').AsString      := sItem;
      IBQPENDENCIA.ParamByName('TIPO').AsString      := sTipo;
      IBQPENDENCIA.ExecSQL;
      IBTPENDENCIA.Commit;
    except
      if IBTPENDENCIA.Active then
        IBTPENDENCIA.Rollback;
    end;
    FreeAndNil(IBQPENDENCIA);
    FreeAndNil(IBTPENDENCIA);
  end;
end;

function indRegraSAT(sCFOP: String): String;
// Sandro Silva 2019-05-21
// Retorna T ou A
begin
  Result := 'A';
  if (sCFOP = '5656') or (sCFOP = '5667') then // Combustível
    Result := 'T'
end;

function TruncaValor(dValor: Double; iDecimais: Integer = 2): Double;
// Sandro Silva 2019-05-21
// Retorna o valor truncado com a quantidade de casas informado
var
  iFator: Integer;
  sTruncado: String;
begin
  iFator := StrToIntDef('1' + DupeString('0', iDecimais), 1);
  sTruncado := FloatToStr(dValor * iFator);
  if Pos(',', sTruncado) > 0 then
    sTruncado := Copy(sTruncado, 1, Pos(',', sTruncado) - 1);
  Result := (StrToInt(sTruncado) / iFator); // Result := (Trunc((dValor) * iFator) / iFator);
end;

{
function UsuariosConectados(IBDatabase: TIBDatabase): Integer;
// Sandro Silva 2019-06-19 Retorna a quantidade de IPs conectados ao banco, por protocolo (TCP/IP - XNET)
// Para controlar o número de usuário por licença
var
  IBTIP: TIBTransaction;
  IBQIP: TIBQuery;
begin
  IBTIP := CriaIBTransaction(IBDatabase);
  IBQIP := CriaIBQuery(IBTIP);
  Result := 2000; // Padrão
  try
    IBQIP.Close;
    IBQIP.SQL.Text :=
      'select count(distinct MON$REMOTE_ADDRESS) as IP from MON$ATTACHMENTS';
    IBQIP.Open;
    Result := IBQIP.FieldByName('IP').AsInteger;
  except

  end;
  FreeAndNil(IBQIP);
  FreeAndNil(IBTIP);
end;
}

function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
// Sandro Silva 2015-12-10 Formata valor float com 2 casas decimais para usar nos elementos do xml da nfce
// Parâmetros:
// dValor: Valor a ser formatado
// iPrecisao: Quantidade de casas decimais resultante no valor formatado. Por default formata com 2 casas. Ex.: 2 = 0,00; 3 = 0,000
var
  sMascara: String;
begin
  sMascara := '##0.' + DupeString('0', iPrecisao);
  Result := StrTran(Alltrim(FormatFloat(sMascara, dValor)), ',', '.'); // Quantidade Comercializada do Item
end;

function XmlValueToFloat(Value: String;
  SeparadorDecimalXml: String = '.'): Double;
// Sandro Silva 2023-05-17
// Converte valor float de tags xml para Float
begin
  if SeparadorDecimalXml = ',' then
    Value := StringReplace(Value, '.', '', [rfReplaceAll]);// Elimina os pontos

  if SeparadorDecimalXml = '.' then
  begin
    Value := StringReplace(Value, ',', '', [rfReplaceAll]); // Elimina a vírgula
    Value := StringReplace(Value, '.', ',', [rfReplaceAll]); // Troca o ponto pela vírgula
  end;
  
  Result := StrToFloatDef(Value, 0.00);
end;

function TefUsado: String;
// Sandro Silva 2019-08-13 Retorno o Nome do tef usado 
begin
  Result := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'TEF USADO', 'TEF_DISC');
end;

procedure AdicionaCNPJRequisicaoTEF(var tfFile: TextFile; DataSet: TDataSet);
begin
  if AnsiUpperCase(TefUsado) = 'SITEF' then
  begin
    if DataSet.Active then
    begin
      try
        WriteLn(tfFile, '565-008 = 1=' + LimpaNumero(DataSet.FieldByName('CGC').AsString) + ';2=07426598000124'); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comerciala
      except
      end;
    end;
  end;
end;

function BandeiraSemCreditoDebito(sBandeira: String): String;
// Elimina o texto DEBITO, CREDITO... da bandeira selecionada
begin
  Result := AnsiUpperCase(sBandeira);
  Result := StringReplace(Result, ' CREDITO', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' DEBITO', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' VOUCHER', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' VALE', '', [rfReplaceAll]);
end;

function SelecionaCNPJCredenciadora(DATASETCLIFOR: TDataSet; sBandeira: String): String;
//Seleciona direto se encontrar apenas 1 registros
//Se encontrar mais que 1 procura aquele que tiver a rede cadastrada na OBS. Não encontrando seleciona o último verificado
begin
  Result := '';
  DATASETCLIFOR.Last;
  DATASETCLIFOR.First;

  if DATASETCLIFOR.RecordCount = 1 then
  begin
    Result := LimpaNumero(DATASETCLIFOR.FieldByName('CGC').AsString);
  end
  else
  begin
    DATASETCLIFOR.First;
    while DATASETCLIFOR.Eof = False do
    begin
      if Pos(AnsiUpperCase(sBandeira), AnsiUpperCase(DATASETCLIFOR.FieldByName('OBS').AsString)) > 0 then
      begin
        Break;
      end;

      DATASETCLIFOR.Next;
    end;

    Result := LimpaNumero(DATASETCLIFOR.FieldByName('CGC').AsString);
  end;

end;

function Legal_ok(IBDATABASE: TIBDatabase): Boolean;
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  dtLimite: TDate;
begin
  {Sandro Silva 2021-09-24 inicio
  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select gen_id(G_LEGAL,0) as LEGAL from rdb$database');
    qyAux.Open;

    if qyAux.FieldByname('LEGAL').AsString <> '0' then
    begin
      Result := False;
    end
    else
    begin
      Result := True;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
  }

  ///////////
  Result := True; // Começa otimista, que está tudo ok. Torna false durante validação
  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select gen_id(G_LEGAL,0) as LEGAL from rdb$database');
    qyAux.Open;

    if qyAux.FieldByname('LEGAL').AsString <> '0' then
    begin
      if qyAux.FieldByname('LEGAL').AsString = '19670926' then
      begin
        Result := False;
      end
      else
      begin
        dtLimite := StrToDate(Copy(qyAux.FieldByname('LEGAL').AsString,7,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,5,2)+'/'+Copy(qyAux.FieldByname('LEGAL').AsString,1,4));

        if (Date >= dtLimite + 31) or (Date < dtLimite) then
        begin
          Result := False;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;

  FreeAndNil(trAux);
  FreeAndNil(qyAux);
end;

function CifrarTexto(sTexto: String): String;
// Método para cifrar textos usando chave privada
var
  Blowfish: TLbBlowfish;
begin
  Result := '';
  Blowfish := TLbBlowfish.Create(Application);
  try
    Blowfish.GenerateKey(CHAVE_CIFRAR); // Minha chave secreta
    Result := Blowfish.EncryptString(sTexto);
  except
    on E: Exception do
    begin
      ShowMessage('Falha 947 ' + E.Message);
    end;
  end;
  FreeAndNil(Blowfish);
end;

function DiasParaExpirar(IBDATABASE: TIBDatabase; bValidacaoNova: Boolean = True): Integer;
var
  qyAux: TIBQuery;
  trAux: TIBTransaction;
  Blowfish: TLbBlowfish;
  sGeneratorG_Legal: String;
  sDataLimite: String; // Sandro Silva 2022-11-14
begin

  try
    trAux := CriaIBTransaction(IBDATABASE);
    qyAux := CriaIBQuery(trAux);

    Blowfish := TLbBlowfish.Create(Application);

    {Sandro Silva 2021-09-24 inicio}
    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select gen_id(G_LEGAL,0) as LEGAL from rdb$database');
    qyAux.Open;
    sGeneratorG_Legal := qyAux.FieldByname('LEGAL').AsString;
    {Sandro Silva 2021-09-24 fim}

    qyAux.Close;
    qyAux.SQL.Clear;
    qyAux.SQL.Add('select trim(LICENCA) as LICENCA from EMITENTE'); // Sandro Silva 2021-01-08 qyAux.SQL.Add('select LICENCA from EMITENTE');
    qyAux.Open;

    Blowfish.GenerateKey(CHAVE_CIFRAR); // Minha chave secreta

    if AllTrim(qyAux.FieldByname('LICENCA').AsString) <> '' then
    begin
      if sGeneratorG_Legal = '19670926' then
      begin
        Result := -1;
      end
      else
      begin

        if sGeneratorG_Legal <> '0' then
        begin
          // Sandro Silva 2022-11-14 Result := Trunc(31 - (Date - StrToDate(Copy(sGeneratorG_Legal,7,2)+'/'+Copy(sGeneratorG_Legal,5,2)+'/'+Copy(sGeneratorG_Legal,1,4))));
          // Ronei autorizou reduzir o tempo de uso do frente sem o Commerce acessar smallsoft.com.br
          sDataLimite := Copy(sGeneratorG_Legal,7,2)+'/'+Copy(sGeneratorG_Legal,5,2)+'/'+Copy(sGeneratorG_Legal,1,4);
          Result := Trunc(15 - (Date - StrToDate(sDataLimite)));
        end
        else
        begin
          {Sandro Silva 2022-11-14 inicio
          Result := Trunc(365 - (Date - StrToDate(Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4))));
          }
          sDataLimite := Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),7,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),5,2)+'/'+Copy(Blowfish.DecryptString(qyAux.FieldByname('LICENCA').AsString),1,4);
          if bValidacaoNova = False then
          begin
            Result := Trunc(365 - (Date - StrToDate(sDataLimite)));
          end
          else
          begin
            Result := Trunc((StrToDate(sDataLimite) - Date));
          end;
          {Sandro Silva 2022-11-14 fim}
        end;
        
      end;
      {Sandro Silva 2021-09-24 fim}

    end
    else
    begin
      Result := -1; // 0 dias ainda pode usar
      {Sandro Silva 2021-06-22 inicio
      Application.MessageBox(PansiChar('Cadastro do emitente desatualizado' + Chr(10) + Chr(10) +
        'Entre antes no programa "Small" e confirme os dados no Cadastro do emitente.'), 'Atenção', MB_OK + MB_ICONWARNING);
      }
      SmallMessageBox('Cadastro do emitente desatualizado' + Chr(10) + Chr(10) +
        'Entre antes no programa "Small" e confirme os dados no Cadastro do emitente.', 'Atenção', MB_OK + MB_ICONWARNING);
      {Sandro Silva 2021-06-22 final}

    end;

  except
    on E: Exception do
    begin
      if AnsiContainsText(E.Message, 'Column unknown') and AnsiContainsText(E.Message, 'LICENCA') then
      begin
        {Sandro Silva 2021-06-22 inicio
        Application.MessageBox(PansiChar('Seu banco de dados está desatualizado' + Chr(10) + Chr(10) +
          'Entre antes no programa "Small" para ajustar os arquivos.'), 'Atenção', MB_OK + MB_ICONWARNING);
        }
        SmallMessageBox('Seu banco de dados está desatualizado' + Chr(10) + Chr(10) +
          'Entre antes no programa "Small" para ajustar os arquivos.', 'Atenção', MB_OK + MB_ICONWARNING);
        {Sandro Silva 2021-06-22 final}

        FecharAplicacao(ExtractFileName(Application.ExeName));
        Abort;
      end;
      Result := -1; // 0 dias ainda pode usar
    end;
  end;

  FreeAndNil(trAux);
  FreeAndNil(qyAux);
  FreeAndNil(Blowfish);
end;

function DescricaoCRT(sCrt: String): String;
begin
  Result := '';
  if sCrt = '1' then
    Result := '1-Simples nacional';
  if sCrt = '2' then
    Result := '2-Simples Nacional, excesso sublimite de receita bruta';
  if sCrt = '3' then
    Result := '3-Regime normal';
end;

function ConcatencaNodeNFeComProtNFe(sNFe: String; sprotNFe: String): String;
begin
  Result :=
    '<?xml version="1.0" encoding="UTF-8"?>' +
    '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + xmlNodeValue(sNFe, '//infNFe/@versao') + '">' +
      xmlNodeXml(sNFe, '//NFe') +
      xmlNodeXML(sprotNFe, '//protNFe') +
    '</nfeProc>';
end;

function FormataNumeroDoCupom(iCupom: Integer): String;
// Retorna o número do cupom formatado com zeros a esquerda conforme o documento emitido
// No futuro poderá adaptar retornos diferentes para ECF=Dependendo o modelo 6 ou 9 dígitos, NFC-e=9 dígitos e SAT=6 dígitos
// SAT AD35211161099008000141599000247300000432609834
// NFC-e 13211207426598000124650010001207231074265988
begin
  // Usar PAFNFCe(), NFCe(), MEI(), SAT(), MFE() para identificar o número de dígitos que deve ser formatado o número do cupom
  Result := StrZero(iCupom,6,0);
end;

function ColumnIndex(Columns: TDBGridColumns; FieldName: String): Integer;
var
  i: Integer;
begin
  Result := 0;
  try
    for i := 0 to Columns.Count -1 do
    begin
      if AnsiUpperCase(Columns.Items[i].FieldName) = AnsiUpperCase(FieldName) then
      begin
        Result := i;
        Break;
      end;
    end;
  except

  end;
end;

procedure AjustaLarguraDBGrid(DBGrid: TDBGrid);
var
  iWidthTotalColunas: Integer;
  iColuna: Integer;
begin
  if DBGrid.Visible then
  begin
    iWidthTotalColunas := 0;
    for iColuna := 0 to DBGrid.Columns.Count -1 do
    begin
      if DBGrid.Columns[iColuna].Visible then // Sandro Silva 2020-09-28
        iWidthTotalColunas := iWidthTotalColunas + DBGrid.Columns[iColuna].Width;
    end;
    for iColuna := 0 to DBGrid.Columns.Count -1 do
    begin
      DBGrid.Columns[iColuna].Width := Trunc((DBGrid.Columns[iColuna].Width / iWidthTotalColunas) * (DBGrid.Width - GetSystemMetrics(SM_CYHSCROLL) - IndicatorWidth));
    end;
  end;
end;

procedure AjustarBufferChuncks(Form: TForm);
// Ajustar a propriedade BufferChunks para melhor controlar a memória evitando out of memory
var
  iObj: Integer;
begin
  for iObj := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[iObj].ClassType = TIBDataSet then
    begin
      TIBDataSet(Form.Components[iObj]).BufferChunks := 100; // Atenção com tabelas onde existem muitos registros, pode ocorrer lentidão se diminuir esse valor
    end;
    if Form.Components[iObj].ClassType = TIBQuery then
    begin
      TIBQuery(Form.Components[iObj]).BufferChunks := 100; // Atenção com tabelas onde existem muitos registros, pode ocorrer lentidão se diminuir esse valor
    end;
  end;
end;

function DistribuicaoDFe(dtDataI: TDate; dtDataF: TDate; Diretorio: String;
  IBTRANSACTION: TIBTransaction): Boolean;
// Sandro Silva 2021-01-28 Exporta xml de NFC-e/SAT e Inutilização de NFC-e
var
  IBQDFE: TIBQuery;
  SearchRec: tSearchREC;
  Encontrou : Integer;
  bTemCFeSAT: Boolean;
  F : TExtfile;
  fNFe : String;
  sFileExporta: String;
  function TamanhoArquivo(Arquivo: string): Integer;
  begin
    with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
    try
      Result := Size;
    finally
     Free;
    end;
  end;
begin
  IBQDFE := CriaIBQuery(IBTRANSACTION);
  Result := True;
  try

    ForceDirectories(Diretorio);

    //
    // Apaga todos os arquivos .XML da pasta CONTABIL
    //
    FindFirst(Diretorio + '\*.xml', faAnyFile, SearchRec);
    Encontrou := 0;
    while Encontrou = 0 do
    begin
      DeleteFile(pChar(Diretorio + '\'+Searchrec.Name));
      Encontrou := FindNext(SearchRec);
    end;

    // Seleciona NFC-e e SAT
    IBQDFE.DisableControls;
    IBQDFE.Close;
    IBQDFE.SQL.Text :=
      'select * ' +
      'from NFCE ' +
      'where DATA between '+QuotedStr(DateToStrInvertida(dtDataI))+ ' and '+QuotedStr(DateToStrInvertida(dtDataF))+
      ' and coalesce(NFEXML,'''')<>'''' ' +
      ' and (STATUS containing ''Autoriza'' or STATUS containing ''Cancel'' or STATUS containing ''conting'' or STATUS containing ''Sucesso'') ' +
      ' order by DATA, NFEID';
    IBQDFE.Open;

    bTemCFeSAT := False;
    IBQDFE.First;

    while not IBQDFE.Eof do
    begin

      sFileExporta := '';

      if bTemCFeSAT = False then // Para agilizar o processamento. Depois que identificou existência de CF-e-SAT não precisa processar os demais xml
      begin
        if AnsiContainsText(IBQDFE.FieldByName('NFEXML').AsString, '<mod>59</mod>') then // Sandro Silva 2020-08-24 if (xmlNodeValue(Form1.ibDataSet150.FieldByName('NFEXML').AsString, '//ide/mod') = '59') then
          bTemCFeSAT := True;
      end;

      if ((Pos('<nfeProc',IBQDFE.FieldByName('NFEXML').AsString) <> 0) // NFC-e emitida
          or ((Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0)) // NFC-e cancelada
         )
        or ((xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//infCFe/@Id') <> '')  //CF-e-SAT de venda com ID
            and (xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//Signature/SignatureValue') <> '')  //CF-e-SAT assinado
           )
        then
      begin
        try
          // ------------------------------------------ //
          // Cria um diretório com uma cópias dos dados //
          // ------------------------------------------ //
          //ForceDirectories(Diretorio);
          fNFe := IBQDFE.FieldByName('NFEXML').AsString;
          // Componente NFCe está gerando os xml com 'ï»¿' no início do arquivo e causa erro ao exportar para contabilidade
          fNFe := StringReplace(fNFe, 'ï»¿','', [rfReplaceAll]); // Sandro Silva 2016-03-21

          if (Copy(xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//chNFe'), 21, 2) = '65') then  // Assim para identificar xml de cancelamento de NFC-e
          begin
            sFileExporta := PansiChar(Diretorio+'\'+IBQDFE.FieldByName('NFEID').AsString+'-nfce.xml');  // Direciona o arquivo F para EXPORTA.TXT
            if (Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0) then
              sFileExporta := PansiChar(Diretorio+'\'+IBQDFE.FieldByName('NFEID').AsString+'-caneve.xml');  // Direciona o arquivo F para EXPORTA.TXT
          end;
          if (xmlNodeValue(IBQDFE.FieldByName('NFEXML').AsString, '//ide/mod') = '59') then
          begin
            sFileExporta := PansiChar(Diretorio+'\AD'+IBQDFE.FieldByName('NFEID').AsString+'.xml');  // Direciona o arquivo F para EXPORTA.TXT
            if (Pos('CANCEL', AnsiUpperCase(IBQDFE.FieldByName('STATUS').AsString)) <> 0) then
              sFileExporta := PansiChar(Diretorio+'\ADC'+IBQDFE.FieldByName('NFEID').AsString+'.xml');  // Direciona o arquivo F para EXPORTA.TXT
          end;

          //
        except
          Result := False;
        end;

      end;

      if Trim(sFileExporta) <> '' then
      begin
        AssignFile(F,PansiChar(Trim(sFileExporta)));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);                  // Abre para gravação
        WriteLn(F,fNFe);
        CloseFile(F); // Fecha o arquivo
      end;

      IBQDFE.Next;
    end;

    // Seleciona NFC-e inutilizadas
    IBQDFE.DisableControls;
    IBQDFE.Close;
    IBQDFE.SQL.Text :=
      'select XML ' +
      'from INUTILIZACAO ' +
      'where DATA between '+QuotedStr(DateToStrInvertida(dtDataI))+ ' and '+QuotedStr(DateToStrInvertida(dtDataF))+
      ' and coalesce(XML,'''')<>'''' ' +
      ' and MODELO = ''65'' ' +
      ' order by DATA, NPROT';
    IBQDFE.Open;

    IBQDFE.First;

    while not IBQDFE.Eof do
    begin

      sFileExporta := '';

      if (Pos('<nProt>',IBQDFE.FieldByName('XML').AsString) <> 0) then // NFC-e Inutilizada
      begin
        try
          // ------------------------------------------ //
          // Cria um diretório com uma cópias dos dados //
          // ------------------------------------------ //
          //ForceDirectories(Diretorio);
          
          fNFe := IBQDFE.FieldByName('XML').AsString;
          // Componente NFCe está gerando os xml com 'ï»¿' no início do arquivo e causa erro ao exportar para contabilidade
          fNFe := StringReplace(fNFe, 'ï»¿','', [rfReplaceAll]); // Sandro Silva 2016-03-21

          sFileExporta := PansiChar(Diretorio+'\'+
            xmlNodeValue(fNFe, '//cUF') +
            xmlNodeValue(fNFe, '//ano') +
            xmlNodeValue(fNFe, '//CNPJ') +
            xmlNodeValue(fNFe, '//mod') +
            RightStr('000' + xmlNodeValue(fNFe, '//serie'), 3) +
            RightStr('000000000' + xmlNodeValue(fNFe, '//nNFIni'), 9) +
            RightStr('000000000' + xmlNodeValue(fNFe, '//nNFFin'), 9) +
            '-inut.xml');  // Direciona o arquivo F para EXPORTA.TXT

          //
        except
          Result := False;
        end;

      end;

      if Trim(sFileExporta) <> '' then
      begin
        AssignFile(F,PansiChar(Trim(sFileExporta)));  // Direciona o arquivo F para EXPORTA.TXT
        Rewrite(F);                  // Abre para gravação
        WriteLn(F,fNFe);
        CloseFile(F); // Fecha o arquivo
      end;

      IBQDFE.Next;
    end;

  except
    Result := False;
  end;

  FreeAndNil(IBQDFE);
end;

function GetComputerNameFunc : String;
//Sandro Silva 2015-04-06 inicio
// Retorna o nome do computador usado para gravar em REDUCOES quando NFC-e ou CF-e-SAT
var
  sIpBuffer : String;
  dwSize : DWord;
begin
  dwSize := 255;
  SetLength(sIpBuffer, dwSize);
  if GetComputerName(PChar(sIpBuffer),dwSize) then
    Result := PAnsiChar(sIpBuffer);// PChar(sIpBuffer);
end;

function SelecionaXmlEnvio(Path: String; sDigestValue: String;
  NodeDigest: String): String;
var // Sandro Silva 2016-03-11
  SR: TSearchRec;
  I: integer;
  sl: TStringList;// RE: TRichEdit;
  sDigestLido: String;
begin
  I := FindFirst(Path, faAnyFile, SR);
  sl := TStringList.Create;// RE := TRichEdit.Create(Application);
  while I = 0 do
  begin
    sl.LoadFromFile(ExtractFilePath(Path) + SR.Name); // RE.Lines.LoadFromFile(ExtractFilePath(Path) + SR.Name);
    sDigestLido := '';
    if NodeDigest <> '' then
      sDigestLido := xmlNodeValue(sl.Text, NodeDigest); // sDigestLido := xmlNodeValue(RE.Text, NodeDigest);
    if sDigestLido = sDigestValue then
    begin
      Result := SR.Name;
      Break;
    end;
    I := FindNext(SR);
  end;
  FreeAndNil(sl);// FreeAndNil(RE);
end;

procedure ListaDeArquivos(var Lista: TStringList; sAtual: String;
  sExtensao: String = '*.txt');
var
  S : TSearchREc;
  I : Integer;
begin
  Lista.Clear;
  //
  I := FindFirst( PansiChar(sAtual + '\' + AllTrim(sExtensao)), faAnyFile, S);
  //
  while I = 0 do
  begin
    Lista.Add(S.Name);
    I := FindNext(S);
  end;
  //
  FindClose(S); 
  //
end;

function ConsultaProcesso(sP1: String): Boolean;
var
  Snapshot: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  //
  Result   := False;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (Snapshot = Cardinal(-1)) then exit;
  //
  ProcessEntry32.dwSize := SizeOf(TProcessEntry32);
  //
  // pesquisa pela lista de processos
  //
  if (Process32First(Snapshot, ProcessEntry32)) then
  repeat
    //
    // enquanto houver processos
    //
    if AnsiUpperCase(ProcessEntry32.szExeFile) = AnsiUpperCase(sP1) then
      Result := True;
    //
  until not Process32Next(Snapshot, ProcessEntry32);
  //
  CloseHandle(Snapshot);
  //
end;

function NomeModeloDocumento(sModeloDocumento: String): String;
begin
  if sModeloDocumento = '59' then
    Result := 'CF-e';

  if sModeloDocumento = '65' then
    Result := 'NCF-e';
end;

procedure OpcoesMenuVisivel(Menu: TMenuItem; Visible: Boolean);
var
  iItem: Integer;
begin
  for iItem := 0 to Menu.Count - 1 do
  begin
    Menu.Items[iItem].Visible := Visible;
  end;
end;

function TempoDecorridoPorExtenso(dtDataF, dtDataI: Tdate; ttHoraF, ttHoraI: TTime): String;
{Sandro Silva
Retorna texto formatado por extenso do tempo decorrido entre duas data/horas
Parâmetros:
- dtDataF: Data final;
- dtDataI: Data inicial;
- ttHoraF: Hora final;
- ttHoraI: Hora inicial
Rertorno: String com o tempo decorrido em extenso. Ex.: 02 Dia(s), 03 Hora(s) e 10 Min(s)}
var
  dtDataHoraF, dtDataHoraI: TDateTime;
  iDias: Integer;
  dTempoTotal, dHoras: Double;
  wHoras, wMin, wSeg, wCent: Word;
  sTempoExtenso: String;

  function TempoExtenso(iTempo: Integer; sTipo: String): String;
  // Retorna o texto formatado por extenso a partir do tipo definido em sTipo.
  begin
    if UpperCase(sTipo) = 'D' then
      Result := 'dia'
    else
      if UpperCase(sTipo) = 'H' then
        Result := 'hora'
      else
        if UpperCase(sTipo) = 'M' then
          Result := 'minuto'; // aqui pode mudar para "Minutos"
    if iTempo > 1 then
      Result := Result + 's';
  end;
begin
  dtDataHoraF := Trunc(dtDataF) + Frac(ttHoraF);
  dtDataHoraI := Trunc(dtDataI) + Frac(ttHoraI);

  if dtDataHoraI > dtDataHoraF then
    dTempoTotal := dtDataHoraI - dtDataHoraF
  else
    dTempoTotal := dtDataHoraF - dtDataHoraI;

  iDias  := Trunc(dTempoTotal);
  dHoras := dTempoTotal - Trunc(dTempoTotal);
  Decodetime(dHoras, wHoras, wMin, wSeg, wCent);

  if wMin > 0 then
  begin
    sTempoExtenso := TempoExtenso(wMin, 'M');
    if Result <> '' then
      Result := FormatFloat('00', wMin) + ' ' + sTempoExtenso + ', ' + Result
    else
      Result := FormatFloat('00', wMin) + ' ' + sTempoExtenso;
  end;

  if wHoras > 0 then
  begin
    sTempoExtenso := TempoExtenso(wHoras, 'H');
    if Result <> '' then
    begin
      Result := FormatFloat('00', wHoras) + ' ' + sTempoExtenso + ' e ' + Result
    end
    else
      Result := FormatFloat('00', wHoras) + ' ' + sTempoExtenso;
  end;

  if iDias > 0 then
  begin
    sTempoExtenso := TempoExtenso(iDias, 'D');
    if Result <> '' then
    begin
      if Pos('Hor', Result) = 0 then
        Result := FormatFloat('#00', iDias) + ' ' + sTempoExtenso + ' e ' + Result
      else
        Result := FormatFloat('#00', iDias) + ' ' + sTempoExtenso + ', ' + Result
    end
    else
      Result := FormatFloat('#00', iDias) + ' ' + sTempoExtenso;
  end;
end;

(*{Sandro Silva 2023-06-23 inicio}
function SerialMEI(sSerial: String): Boolean;
// Retorna True se o serial é de empresa enquadrada como MEI
begin
  Result := False;

  {Sandro Silva 2021-12-29 inicio
  if sSerial = '' then
    sSerial := LerParametroIni('WIND0WS.L0G', 'LICENCA', 'Ser', '');
  if (
    (Copy(sSerial,4,1) = 'N') or // 12 Usuários Small Mei + OS
    (Copy(sSerial,4,1) = 'O') or // 07 Usuários Small Mei + OS
    (Copy(sSerial,4,1) = 'P') or // 02 Usuários Small Mei + OS
    (Copy(sSerial,4,1) = 'Q') or // 12 Usuários Small Mei
    (Copy(sSerial,4,1) = 'R') or // 07 Usuários Small Mei
    (Copy(sSerial,4,1) = 'M')    // 02 Usuários Small Mei
     ) then
    Result := True;
  }

  if sSerial = '' then
    sSerial := LerParametroIni('WIND0WS.L0G', 'LICENCA', 'Ser', '');

  if (LerParametroIni(ExtractFilePath(Application.ExeName) + 'smallcom.inf', 'Licenca', 'MEI', '') = 'SIM') then
  begin
    Result := True;
  end
  else
  begin

    if (
      (Copy(sSerial,4,1) = 'N') or // 12 Usuários Small Mei + OS
      (Copy(sSerial,4,1) = 'O') or // 07 Usuários Small Mei + OS
      (Copy(sSerial,4,1) = 'P') or // 02 Usuários Small Mei + OS
      (Copy(sSerial,4,1) = 'Q') or // 12 Usuários Small Mei
      (Copy(sSerial,4,1) = 'R') or // 07 Usuários Small Mei
      (Copy(sSerial,4,1) = 'M')    // 02 Usuários Small Mei
       ) then
      Result := True;
  end;
  {Sandro Silva 2021-12-29 fim}
end;
*)

function Build: String;
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  //
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  GetMem (Pt, Size);
  GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
  VerQueryValue(Pt,'\StringFileInfo\041604E4\FileVersion',Pt2, Size2);
  Result := PChar(pt2);
  FreeMem (Pt);
  //
end;

function PAFNFCe: Boolean;
//Retorna True se o executável é PAF emissor de NFC-e
begin
  // Sandro Silva 2021-03-19 Result := (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'PAFNFCE.EXE') or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'PAFNFCE', '') = 'Sim');
  // Sandro Silva 2023-07-18 Result := (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'PAFNFCE.EXE') or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'PAFNFCE', '') = 'Sim') or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', '') = 'PAFNFCE');
  if (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Modelo do ECF', '') = '65') then
  begin
    if (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'PAFNFCE.EXE') then
      Result := True
    else if (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'NFCE.EXE') and (DadosEmitentePDV.UF = 'SC') and (LimpaNumero(DadosEmitentePDV.CNPJ) <> LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF)) then
      Result := True;
  end;

  {Sandro Silva 2023-06-27 inicio}
  if (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'GERENCIAL.EXE') then
    Result := False;
  {Sandro Silva 2023-06-27 fim}
end;

function NFCe: Boolean;
//Retorna True se o executável é NFC-e
begin
  // Sandro Silva 2023-07-18 Result := (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'NFCE.EXE') or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', '') = 'NFCE');
  Result := (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'NFCE.EXE') or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Modelo do ECF', '') = '65');
  if (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'GERENCIAL.EXE') then
    Result := False;
end;

function Gerencial: Boolean;
var
  sCaminhoDev: String;
  sNomeProjeto: String;
begin
  // Sandro Silva 2023-06-23 Result := (Pos('mei.exe',AnsiLowerCase(Application.ExeName)) <> 0) or (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', '') = 'MEI')
  Result := ((Pos('gerencial.exe', AnsiLowerCase(Application.ExeName)) > 0) or ((Pos('frente.exe', AnsiLowerCase(Application.ExeName)) > 0) and (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Modelo do ECF', '') = '99') )); // Sandro Silva 2023-07-18 Result := (Pos('gerencial.exe', AnsiLowerCase(Application.ExeName)) > 0);
  {
  if Result = False then
  begin
    try
      // Artifício para executar com F9
      with TStringList.Create do
      begin

        sCaminhoDev  := '\desenvolvimento\executaveis\Small Commerce\';
        sNomeProjeto := 'artificio.txt';
        if FileExists(sCaminhoDev + sNomeProjeto) then
        begin
          LoadFromFile(sCaminhoDev + sNomeProjeto);
          if (Pos('frente.exe', AnsiLowerCase(Application.ExeName)) > 0) and AnsiContainsText(Text, 'program frente;') and AnsiContainsText(AnsiUpperCase(Text), AnsiUpperCase('ufuncoesfrente in ''ufuncoesfrente.pas''')) then
          begin
            Result := True;
          end;
        end;
        Free;
      end;
    except

    end;
  end;
  }
end;

function SAT: Boolean;
begin
  // Sandro Silva 2023-07-18 Result := (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', '') = 'SAT');
  Result := ((LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Modelo do ECF', '') = '59') or (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'CFESAT.EXE'))
    and (DadosEmitentePDV.UF = 'SP') ;
end;

function MFE: Boolean;
begin
  // Sandro Silva 2023-07-18 Result := (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Tipo Documento', '') = 'MFE');
  Result := ((LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Modelo do ECF', '') = '59') or (AnsiUpperCase(ExtractFileName(Application.ExeName)) = 'CFESAT.EXE'))
    and (DadosEmitentePDV.UF = 'CE') ;
end;

function SmallMessageBox(const Text, Caption: String; Flags: Longint): Integer;
begin
  {$IFDEF VER150}
  Result := Application.MessageBox(PansiChar(Text), PansiChar(Caption), Flags);
  {$ELSE}
  Result := Application.MessageBox(PwideChar(Text), PwideChar(Caption), Flags);
  {$ENDIF}
end;

function ValidaEmail(sP1: String):Boolean;
var
  I : Integer;
begin
  Result := False;
  if (Pos('@',sP1)<>0) then Result := True;
  if (Pos('@.',sP1)<>0) or
     (Pos('.@',sP1)<>0) or
     (Pos('..',sP1)<>0) then
  begin
    Result := False;
  end;
  //
  for I := 1 to 57 do
  begin
    if Pos(Copy(' "!#$%¨*()+=^]}{,|?ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãéèêëíîïóôõúüç*',I,1),AllTrim(sP1)) <> 0 then
    begin
      Result := False;
    end;
  end;
  //
end;

function EnviarEMail(sDe, sPara, sCC, sAssunto, sTexto, sAnexo: String; bConfirma: Boolean): Integer;
var
  Mais1Ini : tIniFile;
  sAtual : String;
  Msg: TMapiMessage;
  lpSender, lpRecepient, lpComCopia: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;
  SM: TFNMapiSendMail;
  MAPIModule: HModule;
  Flags: Cardinal;
  //
begin
  //
  GetDir(0,sAtual);
  //
  Mais1ini := TIniFile.Create('frente.ini');
  //
  if FileExists(PAnsiChar('mail.exe')) and (Mais1Ini.ReadString('mail','Host','') <> '') then // Sandro Silva 2020-09-03 if FileExists(pChar('mail.exe')) and (Mais1Ini.ReadString('mail','Host','') <> '') then 
  begin
    //
    while FileExists(PAnsiChar('email.exe')) do // Sandro Silva 2020-09-03 while FileExists(pChar('email.exe')) do 
    begin
      DeleteFile('email.exe');
      sleep(10);
    end;
    //
    while not FileExists(PansiChar('email.exe')) do // Sandro Silva 2020-09-03 while not FileExists(pChar('email.exe')) do
    begin
      CopyFile('mail.exe', 'email.exe', False);
      sleep(10);
    end;
    //
    ShellExecuteA(0, 'Open', PAnsiChar('email.exe'), PAnsiChar(sPara+' '+'"'+sAssunto+'"'+' '+'"'+sTexto+'"'+' '+'"'+sAnexo+'"'), PAnsiChar(''), SW_SHOW); // Sandro Silva 2020-09-03 ShellExecute( 0, 'Open', 'email.exe',pChar(sPara+' '+'"'+sAssunto+'"'+' '+'"'+sTexto+'"'+' '+'"'+sAnexo+'"'), '', SW_SHOW);
    //
    Result := 1;
    //
  end else
  begin
    //
    //
    //
    // cria propriedades da mensagem
    //
    FillChar(Msg, SizeOf(Msg), 0);
    //
    with Msg do
    begin
      if (sAssunto <> '') then lpszSubject  := PAnsiChar(sAssunto); // Sandro Silva 2020-09-03 if (sAssunto <> '') then lpszSubject := PChar(sAssunto);
      if (sTexto <> '')   then lpszNoteText := PAnsiChar(sTexto); //Corpo da Mensagem // Sandro Silva 2020-09-03 if (sTexto <> '')   then lpszNoteText := PChar(sTexto); //Corpo da Mensagem
      //
      // remetente
      //
      if (sDe <> '') then
      begin
        lpSender.ulRecipClass := MAPI_ORIG;
        lpSender.lpszName     := PAnsiChar(sDe); // Sandro Silva 2020-09-03 lpSender.lpszName := PChar(sDe);
        lpSender.lpszAddress  := PAnsiChar(sDe); // Sandro Silva 2020-09-03 lpSender.lpszAddress  := PChar(sDe); 
        lpSender.ulReserved := 0;
        lpSender.ulEIDSize := 0;
        lpSender.lpEntryID := nil;
        lpOriginator := @lpSender;
      end;
      //
      // destinatário
      //
      if (sPara <> '') then
      begin
        //
        if not bConfirma then
        begin
          sPara := StrTran(StrTran(sPara,';','><'),' ','');
          sPara := StrTran(sPara,'><','>;<');
        end;
        //
        lpRecepient.ulRecipClass := MAPI_TO;
        lpRecepient.lpszName     := PAnsiChar(''); // Sandro Silva 2020-09-03 lpRecepient.lpszName := PChar('');
        lpRecepient.lpszAddress  := PAnsiChar(sPara); // Sandro Silva 2020-09-03 lpRecepient.lpszAddress  := PChar(sPara); 
        lpRecepient.ulReserved   := 0;
        lpRecepient.ulEIDSize    := 0;
        lpRecepient.lpEntryID    := nil;
        nRecipCount := 1;
        lpRecips := @lpRecepient;
        //
      end else
      begin
        //
        if (sCC <> '') then
        begin
          lpComCopia.ulRecipClass := MAPI_CC;
          lpComCopia.lpszName     := PAnsiChar(sCC); // Sandro Silva 2020-09-03 lpComCopia.lpszName     := PChar(sCC);
          lpComCopia.lpszAddress  := PAnsiChar(sCC); // Sandro Silva 2020-09-03 lpComCopia.lpszAddress  := PChar(sCC);
          lpComCopia.ulReserved   := 0;
          lpComCopia.ulEIDSize    := 0;
          lpComCopia.lpEntryID    := nil;
          nRecipCount             := 1;
          lpRecips                := @lpComCopia;
        end else
        begin
          lpRecips := nil;
        end;
      end;
      // arquivo anexo
      if (sAnexo = '') then
      begin
        nFileCount := 0;
        lpFiles := nil;
      end else
      begin
        //
        FillChar(FileAttach, SizeOf(FileAttach), 0);
        //
        FileAttach.nPosition    := Cardinal($FFFFFFFF);
        FileAttach.lpFileType   := nil;
        FileAttach.lpszPathName := PAnsiChar(sAnexo); // Sandro Silva 2020-09-03 FileAttach.lpszPathName := PChar(sAnexo);
        nFileCount              := 1;
        lpFiles                 := @FileAttach;
        //
      end;
      //
      // carrega dll e o método sPara envio do email
      //
      {$IFDEF VER150}
      MAPIModule := LoadLibrary(PAnsiChar(MAPIDLL));
      {$ELSE}
      MAPIModule := LoadLibrary(PWideChar(MAPIDLL));
      {$ENDIF}
  //    MAPIModule.
      if MAPIModule = 0 then
      begin
        Result := -1
      end else
      begin
        try
          //
  //        Flags := MAPI_AB_NOMODIFY;
  //        Flags := MAPI_USE_DEFAULT;
  //        Flags := MAPI_ENVELOPE_ONLY;

          if bConfirma then
          begin
            Flags := MAPI_DIALOG or MAPI_LOGON_UI;
          end else
          begin
            Flags := 0;
          end;
          //
          @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
          if @SM <> nil then
          begin
            Result := SM(0, Application.Handle, Msg, Flags, 0);
          end else
          begin
            Result := 1;
          end;
        finally
          FreeLibrary(MAPIModule);
        end;
        //
      end;
    end;
    //
  end;
  //
  Mais1Ini.Free;
  //
  CHDir(sAtual);
  //
end;

function CriaCDSALIQ: TClientDataSet;
begin
  Result := TClientDataSet.Create(Application);
  Result.Close;
  Result.FieldDefs.Clear;
  Result.FieldDefs.Add('ALIQUOTA', ftString, 7);
  Result.FieldDefs.Add('VALOR', ftFloat);
  Result.FieldDefs.Add('ACRESCIMO', ftFloat);
  Result.FieldDefs.Add('DESCONTO', ftFloat);
  Result.CreateDataSet;  
end;

function CriaCDSCFOP: TClientDataSet;
begin
  Result := TClientDataSet.Create(Application);
  Result.Close;
  Result.FieldDefs.Clear;
  Result.FieldDefs.Add('CFOP', ftString, 5);
  Result.FieldDefs.Add('VALOR', ftFloat);
  Result.FieldDefs.Add('ACRESCIMO', ftFloat);
  Result.FieldDefs.Add('DESCONTO', ftFloat);
  Result.CreateDataSet;

end;

function ConverteAcentosXML(pP1: String): String;
// Sandro Silva 2016-07-14 Para substituir onde usa ConverteAcentos2. Permite caractere cifrão $
var
  I:Integer;
begin
  pP1 := ConverteAcentos(pP1);
  Result:='';
  for I := 1 to length(pP1) do
  begin
    if Pos(AnsiUpperCase(Copy(pP1,I,1)),'1234567890ABCDEFGHIJKLMNOPQRSTUVXYZW,/.-()%$|') > 0 then
      Result := Result+Copy(pP1,I,1) else Result := Result+' ';
  end;
end;

function UsaKitDesenvolvimentoSAT: Boolean;
// Retorna True quando estiver usando KIT de desenvolvimento
var
  sAssinaturaLida: String;
begin
  sAssinaturaLida := LerParametroIni(NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF, 'SAT-CFe', 'Assinatura Associada', ''); // Sandro Silva 2022-12-02 Unochapeco sAssinaturaLida := LerParametroIni('arquivoauxiliarcriptografadopafecfsmallsoft.ini', 'SAT-CFe', 'Assinatura Associada', '');

  Result := (sAssinaturaLida = 'CODIGO DE VINCULACAO AC DO MFE-CFE') // MFE ELGIN
    or (sAssinaturaLida = 'SGR-SAT SISTEMA DE GESTAO E RETAGUARDA DO SAT') // TANCA/BEMATECH
    or (sAssinaturaLida = '111111111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111111111222222222222221111' +
                          '11111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111111111222222222222221111111111111122222222222222111111111111112222222222222211111111') // TANCA/BEMATECH
end;

function SelectMarketplace(sNome: String): String;
var
  sFiltro: String;
begin
  sFiltro := '';
  if sNome <> '' then
    sFiltro := ' and Upper(NOME) like '+QuotedStr(UpperCase(sNome) + '%');
  Result :=
  'select * ' +
  'from CLIFOR ' +
  'where coalesce(ATIVO, 0) = 0 ' +
  ' and trim(coalesce(NOME,'''')) <> '''' ' +
  ' and coalesce(CGC, '''') <> '''' ' +
  ' and char_length(coalesce(CGC, '''')) >= 18 ' +
  //' and coalesce(OBS, '''') LIKE ''%<idCadIntTran>%'' ' +
  ' and CLIFOR = ''Marketplace'' ' + sFiltro +
  ' order by NOME';
end;

function FormaDePagamentoPadrao(sForma: String): Boolean;
// Retorna True se a forma de pagamento é uma das formas padrão
begin
  Result := False;
  if sForma = FORMA_PAGAMENTO_A_VISTA then
    Result := True;
  if sForma = FORMA_PAGAMENTO_BOLETO then
    Result := True;
  if sForma = FORMA_PAGAMENTO_CARTAO then
    Result := True;
  if sForma = FORMA_PAGAMENTO_CHEQUE then
    Result := True;
end;

function FormaExtraDePagamento(sForma: String): Boolean;
// Retorna False se a forma for uma das formas padrão de pagamento
begin
  Result := True;
  if sForma = FORMA_PAGAMENTO_A_VISTA then
    Result := False;
  if sForma = FORMA_PAGAMENTO_BOLETO then
    Result := False;
  if sForma = FORMA_PAGAMENTO_CARTAO then
    Result := False;
  if sForma = FORMA_PAGAMENTO_CHEQUE then
    Result := False;
end;

function SelectSQLGerenciadorVendasF10(sModeloECF: String;
  sModeloECF_Reserva: String; Data: TDate): String;
begin
 Result:=
  'select * from NFCE where DATA='+QuotedStr(DateToStrInvertida(Data)) +
  IfThen((sModeloECF = '99') or (sModeloECF_Reserva = '99'), ' and MODELO = ''99'' ', ' ') +
  ' order by NUMERONF ';
end;

function RetornaTextoEmVenda(sModelo: String): String;
begin
  Result := TEXTO_CAIXA_EM_VENDA;
  if sModelo = '99' then
    Result := 'EM LANÇAMENTO';
end;

procedure ValidaValorAutorizadoCartao(ibDataSet25: TIBDataSet; TEFValorTotalAutorizado: Double);
begin
  if ibDataSet25.FieldByName('PAGAR').AsFloat <= 0 then
    ibDataSet25.FieldByName('PAGAR').AsFloat := 0;

  if (TEFValorTotalAutorizado > 0)
    and (ibDataSet25.FieldByName('PAGAR').AsFloat < TEFValorTotalAutorizado) then
  begin
    ibDataSet25.FieldByName('PAGAR').AsFloat   := TEFValorTotalAutorizado; // Sandro Silva 2017-06-23
  end;
end;

function GravaDadosTransacaoEletronica(IBTransaction: TIBTransaction;
  dtData: TDate; sPedido: String; sCaixa: String; sModelo: String;
  sGNF: String; sForma: String; dValor: Double; sTransacao: String;
  sNomeRede: String; sAutorizacao: String; sBandeira: String): Boolean;
var
  IBQTRANSACAO: TIBQuery;
  sRegistro: String;
  iForma: Integer;
begin
  Result := True;

  IBQTRANSACAO := CriaIBQuery(IBTransaction);

  try
    IBQTRANSACAO.Close;
    IBQTRANSACAO.SQL.Text :=
      'insert into TRANSACAOELETRONICA (REGISTRO, DATA, PEDIDO, CAIXA, MODELO, GNF, FORMA, VALOR, TRANSACAO, NOMEREDE, AUTORIZACAO, BANDEIRA) ' +
      ' values (:REGISTRO, :DATA, :PEDIDO, :CAIXA, :MODELO, :GNF, :FORMA, :VALOR, :TRANSACAO, :NOMEREDE, :AUTORIZACAO, :BANDEIRA)';
    sRegistro := FormatFloat('0000000000', IncGeneratorToInt(IBTransaction.DefaultDatabase, 'G_VFPE', 1));
    IBQTRANSACAO.ParamByName('REGISTRO').AsString         := sRegistro;
    IBQTRANSACAO.ParamByName('DATA').AsDate               := dtData;
    IBQTRANSACAO.ParamByName('PEDIDO').AsString           := sPedido;
    IBQTRANSACAO.ParamByName('CAIXA').AsString            := sCaixa;
    IBQTRANSACAO.ParamByName('MODELO').AsString           := sModelo;
    IBQTRANSACAO.ParamByName('GNF').AsString              := sGNF;    
    IBQTRANSACAO.ParamByName('FORMA').AsString            := sForma;
    IBQTRANSACAO.ParamByName('VALOR').AsFloat             := dValor;
    IBQTRANSACAO.ParamByName('TRANSACAO').AsString        := Copy(sTransacao, 1, TamanhoCampo(IBQTRANSACAO.Transaction, 'VFPE', 'TRANSACAO'));
    IBQTRANSACAO.ParamByName('NOMEREDE').AsString         := Copy(sNomeRede, 1, TamanhoCampo(IBQTRANSACAO.Transaction, 'VFPE', 'NOMEREDE'));
    IBQTRANSACAO.ParamByName('AUTORIZACAO').AsString      := Copy(sAutorizacao, 1, TamanhoCampo(IBQTRANSACAO.Transaction, 'VFPE', 'AUTORIZACAO'));
    IBQTRANSACAO.ParamByName('BANDEIRA').AsString         := Copy(sBandeira, 1, TamanhoCampo(IBQTRANSACAO.Transaction, 'VFPE', 'BANDEIRA'));
    IBQTRANSACAO.ExecSQL;
  except
    Result := False;
  end;

  FreeAndNil(IBQTRANSACAO);

end;

function AtualizaDadosTransacaoEletronica(IBTransaction: TIBTransaction;
  sPedidoOld: String; sCaixaOld: String; sModeloOld: String; dtData: TDate;
  sPedido: String; sCaixa: String; sModelo: String): Boolean;
var
  IBQTRANSACAO: TIBQuery;
  iForma: Integer;
begin
  Result := True;

  IBQTRANSACAO := CriaIBQuery(IBTransaction);

  try
    IBQTRANSACAO.Close;
    IBQTRANSACAO.SQL.Text :=
      'update TRANSACAOELETRONICA set ' +
      'DATA = :DATA, ' +
      'PEDIDO = :PEDIDO, ' +
      'CAIXA = :CAIXA, ' +
      'MODELO = :MODELO ' +
      'where PEDIDO = :PEDIDOOLD ' +
      ' and CAIXA = :CAIXAOLD ' +
      ' and MODELO = :MODELOOLD ';
    IBQTRANSACAO.ParamByName('DATA').AsDate        := dtData;
    IBQTRANSACAO.ParamByName('PEDIDO').AsString    := sPedido;
    IBQTRANSACAO.ParamByName('CAIXA').AsString     := sCaixa;
    IBQTRANSACAO.ParamByName('MODELO').AsString    := sModelo;
    IBQTRANSACAO.ParamByName('PEDIDOOLD').AsString := sPedidoOld;
    IBQTRANSACAO.ParamByName('CAIXAOLD').AsString  := sCaixaOld;
    IBQTRANSACAO.ParamByName('MODELOOLD').AsString := sModeloOld;
    IBQTRANSACAO.ExecSQL;
  except
    Result := False;
  end;

  FreeAndNil(IBQTRANSACAO);

end;


{
function ValidaQtdDocumentoFiscal(Recursos: TValidaRecurso): Boolean;
begin
  Result := False;
  try
    Result := Recursos.ValidaQtdDocumentoFrente;
  except
  end;
end;
}

{ TTipoEntrega }

constructor TTipoEntrega.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TTipoEntrega.SetDomicilio(const Value: Boolean);
begin
  FDomicilio := Value;
end;

{ TMyApplication }

constructor TMyApplication.Create(AOWner: TComponent);
begin
  FImgLogo := TImage.Create(Application);
end;

{ TArquivo }

procedure TArquivo.LerArquivo(FileName: TFileName; bBreakLine: Boolean = True);
var
  sLinha: String;
begin
  FTexto := '';
  if FileExists(FileName) then
  begin
    try
      AssignFile(FArquivo, FileName);
      Reset(FArquivo); //abre o arquivo para leitura;
      while not Eof(FArquivo) do
      begin
        Readln(FArquivo, slinha); //lê do arquivo e desce uma linha. O conteúdo lido é transferido para a variável linha
        if FTexto <> '' then
        begin
          if bBreakLine then
          FTexto := FTexto + #10 + #13;
        end;
        FTexto := FTexto + sLinha; //adiciona a um campo Memo
      end;
    except

    end;
    Closefile(FArquivo);
  end;

end;

procedure TArquivo.SalvarArquivo(FileName: TFileName);
begin
  try
    AssignFile(FArquivo, pChar(FileName));
    Rewrite(FArquivo);
    Writeln(FArquivo, FTexto);
    CloseFile(FArquivo);                                    // Fecha o arquivo
  except

  end;

end;

end.
