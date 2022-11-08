{ *********************************************************************** }
{ Funções usadas para geração, envio e consulta de xml do BLOCO X do PAF  }
{ Autor: Sandro Luis da Silva                                             }
{                                                                         }
{                                                                         }
{ *********************************************************************** }

unit ufuncoesblocox;

interface

uses Controls, SysUtils, IBDatabase, DB, IBCustomDataSet, IBQuery,
  Smallfunc, ufuncoesfrente, StrUtils, Forms, Dialogs,
  DateUtils, LbCipher, LbClass, Classes, Windows, ShellApi
  , Contnrs // Sandro Silva 2018-11-26
  , msxml // Sandro Silva 2019-05-07
  , md5 // Sandro Silva 2019-06-12
  , upafecfmensagens
  , ufuncoesfrentepaf
  , uclassetiposblocox
  , IniFiles
  , IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP
  ;

const QTD_BLOQUEIO_XML_PENDENTE_RZ      = 10;// Sandro Silva 2019-08-26 ER 02.06 UnoChapeco 20;
const QTD_BLOQUEIO_XML_PENDENTE_ESTOQUE = 5;
const INTERVALO_PARA_CONSULTA           = 10; // Sandro Silva 2019-03-25 Documentação do Bloco X alterada, orienta aguardar 10 minutos entre o envio e a consulta  5; //Inicialmento 5 minutos

const TIPO_ITEM_COD_MATERIAL_DE_USO_E_CONSUMO = '07';
const DATA_FINAL_PRIMEIRO_PERIODO_OBRIGATORIO_ENVIO_ESTOQUE = '31/12/2022'; //'31/12/2022';
const DATA_INICIAL_OBRIGATORIO_GERACAO_ARQUIVO_REDUCAO_Z    = '01/01/2023';// Sandro Silva 2022-09-05
const RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO  = 'Data de referência é anterior à data de início da obrigação';

type
  TLog = class
    FDiretorioAtual: String;
    FArquivo: TArquivo;
  private
  public
    constructor Create;
    destructor Destroy; override;
    property DiretorioAtual: String read FDiretorioAtual write FDiretorioAtual;
    procedure SalvaLog(Arquivo: String; Texto: String);
  end;

  TEstoqueItens = class  // Sandro Silva 2018-11-26 Usando array simples ocorria out of memory quando navegava nos itens do array
  private
    FCodigoNCMSH: String;
    FQuantidade: String;
    FUnidade: String;
    FCodigoProprio: String;
    FCodigoCEST: String;
    FSituacaoTributaria: String;
    FIsArredondado: String;
    FQuantidadeTotalAquisicao: String;
    FCodigoGTIN: String;
    FValorBaseCalculoICMSST: String;
    FDescricao: String;
    FValorUnitario: String;
    FSituacaoEstoque: String;
    FValorTotalAquisicao: String;
    FValorTotalICMSST: String;
    FValorTotalICMSDebitoFornecedor: String;
    FAliquota: String;
    FIppt: String;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Descricao: String read FDescricao write FDescricao;
    property CodigoGTIN: String read FCodigoGTIN write FCodigoGTIN;
    property CodigoCEST: String read FCodigoCEST write FCodigoCest;
    property CodigoNCMSH: String read FCodigoNCMSH write FCodigoNCMSH;
    property CodigoProprio: String read FCodigoProprio write FCodigoProprio;
    property Quantidade: String read FQuantidade write FQuantidade;
    property QuantidadeTotalAquisicao: String read FQuantidadeTotalAquisicao write FQuantidadeTotalAquisicao;
    property Unidade: String read FUnidade write FUnidade;
    property ValorUnitario: String read FValorUnitario write FValorUnitario;
    property ValorTotalAquisicao: String read FValorTotalAquisicao write FValorTotalAquisicao;
    property ValorTotalICMSDebitoFornecedor: String read FValorTotalICMSDebitoFornecedor write FValorTotalICMSDebitoFornecedor;
    property ValorBaseCalculoICMSST: String read FValorBaseCalculoICMSST write FValorBaseCalculoICMSST;
    property ValorTotalICMSST: String read FValorTotalICMSST write FValorTotalICMSST;
    property SituacaoTributaria: String read FSituacaoTributaria write FSituacaoTributaria;
    property Aliquota: String read FAliquota write FAliquota;
    property IsArredondado: String read FIsArredondado write FIsArredondado;
    property Ippt: String read FIppt write FIppt;
    property SituacaoEstoque: String read FSituacaoEstoque write FSituacaoEstoque;
  end;

  TEstoqueItensList = class(TObjectList) // Cria lista de objetos TEstoqueItens
    private
      function getItem(Index: Integer): TEstoqueItens;
    protected
      function Adiciona(CodigoNCMSH: String; Quantidade: String;
        Unidade: String; CodigoProprio: String; CodigoCEST: String;
        SituacaoTributaria: String; IsArredondado: String;
        QuantidadeTotalAquisicao: String; CodigoGTIN: String;
        ValorBaseCalculoICMSST: String; Descricao: String;
        ValorUnitario: String; SituacaoEstoque: String;
        ValorTotalAquisicao: String; ValorTotalICMSST: String;
        ValorTotalICMSDebitoFornecedor: String;
        Aliquota: String; Ippt: String): TEstoqueItens;
    public
      property Items[Index: Integer]: TEstoqueItens read getItem;
  end;

  TReducaoZItens = class
  private
    FValorDiferenca: Currency;
    FQuantidade: Double;
    FValorCancelamento: Double;
    FValorDesconto: Double;
    FValorTotalLiquido: Double;
    FValorAcrescimo: Double;
    FCodigoNCMSH: String;
    FCodigoCEST: String;
    FTipo: String;
    FCodigoGTIN: String;
    FCodigoProprio: String;
    FUnidade: String;
    FDescricao: String;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Tipo: String read FTipo write FTipo;
    property Descricao: String read FDescricao write FDescricao;
    property CodigoGTIN: String read FCodigoGTIN write FCodigoGTIN;
    property CodigoCEST: String read FCodigoCEST write FCodigoCEST;
    property CodigoNCMSH: String read FCodigoNCMSH write FCodigoNCMSH;
    property CodigoProprio: String read FCodigoProprio write FCodigoProprio;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property Unidade: String read FUnidade write FUnidade;
    property ValorDesconto: Double read FValorDesconto write FValorDesconto;
    property ValorAcrescimo: Double read FValorAcrescimo write FValorAcrescimo;
    property ValorCancelamento: Double read FValorCancelamento write FValorCancelamento;
    property ValorTotalLiquido: Double read FValorTotalLiquido write FValorTotalLiquido;
    property ValorDiferenca: Currency read FValorDiferenca write FValorDiferenca;
  end;

    TReducaoZItensList = class(TObjectList) // Cria lista de objetos TReducaoZItens
    private
      function getItem(Index: Integer): TReducaoZItens;
    protected
      function Adiciona(Tipo: String; Descricao: String; CodigoGTIN: String;
        CodigoCEST: String; CodigoNCMSH: String; CodigoProprio: String;
        Quantidade: Double; Unidade: String; ValorDesconto: Double;
        ValorAcrescimo: Double; ValorCancelamento: Double;
        ValorTotalLiquido: Double;ValorDiferenca: Currency): TReducaoZItens;
    public
      property Items[Index: Integer]: TReducaoZItens read getItem;
  end;

function CertificadoPertenceAoEmitente(sSubjectName: String;
  sCNPJEmitente: String): Boolean;
procedure LogFrente(sTexto: String; sDiretorioAtual: String);
procedure ConectaIBDataBase(IBDATABASE: TIBDatabase; CaminhoBanco: String);
procedure FechaIBDataBase(IBDATABASE: TIBDatabase);
function DadosEmitente(IBTransaction:  TIBTransaction;
  DiretorioAtual: String): TEmitente;
function AliquotasISS(IBTransaction: TIBTransaction): String;
function Credenciamento(CNPJ: String): String;
function BXSalvarBancoXmlEnvio(IBTRANSACTION1: TIBTransaction; // IBDATABASE: TIBDatabase;
  sTipo: String; sSerie: String;
  dtDataHora: TDateTime; XML: WideString; dtReferencia: TDate): String;
function BXCabecalhoXml(IE: String; sCredenciamento: String): String;
procedure BXGeraXmlReducaoZ(Emitente: TEmitente; IBTransaction1: TIBTransaction;
  SerieECF: String; sdtReferencia: String;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean);
function BXGeraXmlEstoqueMes(Emitente: TEmitente; IBTransaction1: TIBTransaction;
  dtInicial: TDate; dtFinal: TDate;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean;
function BXGeraXmlEstoquePeriodo(Emitente: TEmitente; IBTransaction1: TIBTransaction;
  dtInicial: TDate; dtFinal: TDate;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean;
function BXRecuperarRecibodeXmlResposta(IBTransaction: TIBTransaction;
  XmlResposta: String; sDtReferencia: String; sTipo: String;
  sSerie: String): Boolean;
function BXGravaReciboTransmissao(IBTransaction: TIBTransaction;
  sRecibo: String; dtDatareferencia: TDate; sTipo: String;
  sSerie: String): Boolean;
procedure BXAssinaTodosXmlPendente(IBTransaction: TIBTransaction; sTipo: String;
  DiretorioAtual: String);
function BXServidorSefazConfigurado(UF: String): Boolean;
procedure BXSalvarReciboTransmissaoBanco(Emitente: TEmitente; IBTransaction: TIBTransaction;
  Retorno: TRetornoBlocoX;
  sRegistro: String); overload;
procedure BXTrataErroRetornoTransmissao(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sXmlResposta: String;
  sTipo: String; sSerie: String; sDataReferencia: String);
function BXAlertarXmlPendente(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sTipo: String; sSerieECF: String;
  bExibirAlerta: Boolean; bRetaguarda: Boolean = False): Boolean;
function BXPermiteGerarXmlEstoque: Boolean;
procedure BXDesconsideraXmlForaObrigatoriedade(
  IBTransaction1: TIBTransaction);
function BXTransmitirPendenteBlocoX(DiretorioAtual: String; Emitente: TEmitente;
  IBTransaction1: TIBTransaction; sTipo: String; sSerieECF: String;
  bAlerta: Boolean = True): Integer;
function BXConsultarRecibo(Emitente: TEmitente; IBTransaction: TIBTransaction;
  DiretorioAtual: String; sRecibo: String): Boolean;
procedure BXRestaurarArquivos(IBTransaction1: TIBTransaction;
  DiretorioAtual: String; sTipo: String;
  sSerieECF: String; bApenasUltimo: Boolean = False);
function BXValidaCertificadoDigital(sCNPJ: String): Boolean;
function CNAEDispensadoEnvioEstoque: Boolean;
function BXSelecionarCertificadoDigital: String;
function BXValidaFalhaNaGeracaoXML(Emitente: TEmitente; IBTransaction1: TIBTransaction): Boolean;
procedure LogAuditoria(IBTransaction1: TIBTransaction; Ato: String;
  Modulo: String; Historico: String; Data: TDate; Hora: String);
function BXConsultarPendenciasDesenvolvedorPafEcf(
  Emitente: TEmitente): Boolean;
procedure ConcatenaLogXml(var sLog: String; sTexto: String);
procedure BXExibeAlertaErros(Emitente: TEmitente; sTipo: String;
  IBTransaction: TIBTransaction);
function TrataErrosInternosServidorSEFAZ(Emitente: TEmitente;
  IBTransaction: TIBTransaction): Boolean; // Sandro Silva 2019-06-18
function BXIdentificaRetornosComErroTratando(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sTipo: String): Boolean; // Sandro Silva 2019-06-18
function BXReprocessarArquivo(Emitente: TEmitente;
  IBTransaction: TIBTransaction; DiretorioAtual: String; // Sandro Silva 2019-12-11  sTipo: String;
  sRecibo: String = ''): Boolean; // Sandro Silva 2019-11-05
function BXCancelarArquivo(Emitente: TEmitente;
  IBTransaction: TIBTransaction; DiretorioAtual: String;
  sRecibo: String = ''): Boolean; // Sandro Silva 2022-03-11
procedure ValidaMd5DoListaNoCriptografado;
function BXVisualizaXmlBlocoX(Emitente: TEmitente;
  CaminhoBanco: String;
  sTipo: String;
  DiretorioAtual: String): Boolean;
procedure BXGeraXmlReducaoSemBlocoX(Emitente: TEmitente;
  IBTransaction: TIBTransaction);
function BXGerarAoFISCOREDUCAOZ(Emitente: TEmitente;
  IBTransaction: TIBTransaction): Boolean;
function GetCredenciamentoFomXML(sXML: String): String;
function GetSituacaoProcessamentoDescricaoFomXML(sXML: String): String;
procedure CriarCampoEcfsSerieIntervencao(IBTransaction: TIBTransaction);
function NumeroDeSerieDoEcfNaSefaz(IBTransaction: TIBTransaction;
  sNumeroSerie: String): String;
procedure ValidaEstruturaBancoBlocoX(IBTransaction: TIBTransaction);
function XmlRespostaPadraoSucessoBlocoX(NumeroRecibo: String): String;
function XmlRespostaPadraoAguardandoBlocoX(NumeroRecibo: String): String;
function RespostaComSucessoNoXmlBlocoX(XmlResposta: String): Boolean;
function RespostaComErroNoXmlBlocoX(XmlResposta: String): Boolean;

implementation

uses uarquivosblocox, uconstantes_chaves_privadas;

function GetCredenciamentoFomXML(sXML: String): String;
var
  i, iIni, iFim: Integer;
begin
  sXML := Copy(sXML, 1, 300); // Sandro Silva 2019-03-14
  iIni := Pos('<NumeroCredenciamento>', sXML) + Length('<NumeroCredenciamento>');
  iFim := Pos('</NumeroCredenciamento>', sXML) -1;
  Result := '';
  for i := iIni to iFim do
  begin
    Result := Result + Copy(sXML, i, 1);
  end;
end;

function GetSituacaoProcessamentoDescricaoFomXML(sXML: String): String;
var
  i, iIni, iFim: Integer;
begin
  sXML := Copy(sXML, 1, 300); // Sandro Silva 2019-03-14
  iIni := Pos('<SituacaoProcessamentoDescricao>', sXML) + Length('<SituacaoProcessamentoDescricao>');
  iFim := Pos('</SituacaoProcessamentoDescricao>', sXML) -1;
  Result := '';
  for i := iIni to iFim do
  begin
    Result := Result + Copy(sXML, i, 1);
  end;
end;

procedure ValidaEstruturaBancoBlocoX(IBTransaction: TIBTransaction);
// Tem ocorrido casos que o generator G_BLOCOX não existe no banco. O restante da estrutura relacionada ao bloco x está ok, apenas g_blocox faltando
var
  IBTBASE: TIBTransaction;
  IBQBASE: TIBQuery;
  bOk: Boolean;
begin
  IBTBASE := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQBASE := CriaIBQuery(IBTBASE);
  bOk := True;
  try
    // Generator
    IBQBASE.Close;
    IBQBASE.SQL.Text :=
      'select RDB$GENERATOR_NAME as GENERATOR from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_BLOCOX');
    IBQBASE.Open;

    if IBQBASE.FieldByName('GENERATOR').AsString = '' then
    begin
      bOk := False;
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'CREATE SEQUENCE G_BLOCOX';
      IBQBASE.ExecSQL;
      IBQBASE.Transaction.Commit;
      bOk := True;
    end;
  except
    IBQBASE.Transaction.Rollback;
  end;

  if bOk = False then
  begin
    try
      // Generator
      IBQBASE.Close;
      IBQBASE.SQL.Text :=
        'select RDB$GENERATOR_NAME as GENERATOR from RDB$GENERATORS where RDB$GENERATOR_NAME = ' + QuotedStr('G_BLOCOX');
      IBQBASE.Open;

      if IBQBASE.FieldByName('GENERATOR').AsString = '' then
      begin
        IBQBASE.Close;
        IBQBASE.SQL.Text :=
          'CREATE GENERATOR G_BLOCOX';
        IBQBASE.ExecSQL;
        IBQBASE.Transaction.Commit;
      end;
    except
      IBQBASE.Transaction.Rollback;
    end;
  end;

  FreeAndNil(IBQBASE);
  FreeAndNil(IBTBASE);
end;

function XmlRespostaPadraoSucessoBlocoX(NumeroRecibo: String): String;
begin
  Result :=
    BLOCOX_ESPECIFICACAO_XML +
    '<Resposta Versao="' + BLOCOX_VERSAO_LEIAUTE + '">' +
      '<Recibo>' + NumeroRecibo + '</Recibo>' +
      '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>' +
      '<SituacaoProcessamentoDescricao>Sucesso</SituacaoProcessamentoDescricao>' +
      '<Mensagem />' +
    '</Resposta>';
end;

function XmlRespostaPadraoAguardandoBlocoX(NumeroRecibo: String): String;
begin
  Result :=
    BLOCOX_ESPECIFICACAO_XML +
    '<Resposta Versao="' + BLOCOX_VERSAO_LEIAUTE + '">' +
      '<Recibo>' + NumeroRecibo + '</Recibo>' +
      '<SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo>' +
      '<SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao>' +
      '<Mensagem />' +
    '</Resposta>';
end;

function RespostaComSucessoNoXmlBlocoX(XmlResposta: String): Boolean;
begin
  Result := AnsiContainsText(XmlResposta, '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>');
end;

function RespostaComErroNoXmlBlocoX(XmlResposta: String): Boolean;
begin
  Result := AnsiContainsText(XmlResposta, '<SituacaoProcessamentoCodigo>2</SituacaoProcessamentoCodigo>');
end;

procedure CriarCampoEcfsSerieIntervencao(IBTransaction: TIBTransaction);
var
  IBTECFS: TIBTransaction;
  IBQECFS: TIBQuery;
begin
  IBTECFS := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQECFS := CriaIBQuery(IBTECFS);
  try
    IBQECFS.Close;
    IBQECFS.SQL.Text :=
      'select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and F.RDB$RELATION_NAME = :TABELA ' +
      ' and F.RDB$FIELD_NAME = :CAMPO ';
    IBQECFS.ParamByName('TABELA').AsString := 'ECFS';
    IBQECFS.ParamByName('CAMPO').AsString  := 'SERIEINTERVENCAO';
    IBQECFS.Open;

    if IBQECFS.IsEmpty then
    begin

      IBQECFS.Close;
      IBQECFS.SQL.Text := 'ALTER TABLE ECFS ADD SERIEINTERVENCAO VARCHAR(21)';
      IBQECFS.ExecSQL;
      IBQECFS.Transaction.Commit;

    end;
  except
    IBQECFS.Transaction.Rollback;
  end;

  FreeAndNil(IBQECFS);
  FreeAndNil(IBTECFS);
end;

function NumeroDeSerieDoEcfNaSefaz(IBTransaction: TIBTransaction;
  sNumeroSerie: String): String;
// Retorna o número de série do ECF.
// Quando ECF sofrer interveção deverá ser preenchido o campo SERIEINTERVENCAO na tabela ECFS
// Adotado essa solução para evitar ter que credenciar nova versão do frente.exe
var
  IBTECFS: TIBTransaction;
  IBQECFS: TIBQuery;
begin
  Result := '';
  IBTECFS := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQECFS := CriaIBQuery(IBTECFS);
  try
    IBQECFS.Close;
    IBQECFS.SQL.Text :=
      'select F.RDB$RELATION_NAME, F.RDB$FIELD_NAME ' +
      'from RDB$RELATION_FIELDS F ' +
      'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
      'and R.RDB$VIEW_BLR is null ' +
      'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ' +
      'and F.RDB$RELATION_NAME = :TABELA ' +
      ' and F.RDB$FIELD_NAME = :CAMPO ';
    IBQECFS.ParamByName('TABELA').AsString := 'ECFS';
    IBQECFS.ParamByName('CAMPO').AsString  := 'SERIEINTERVENCAO';
    IBQECFS.Open;

    if IBQECFS.IsEmpty = False then
    begin

      IBQECFS.Close;
      IBQECFS.SQL.Text :=
        'select SERIEINTERVENCAO ' +
        'from ECFS ' +
        'where SERIE = :SERIE';
      IBQECFS.ParamByName('SERIE').AsString := sNumeroSerie;
      IBQECFS.Open;

      Result := Trim(IBQECFS.FieldByName('SERIEINTERVENCAO').AsString);

    end;
  except
    IBQECFS.Transaction.Rollback;
  end;

  if Result = '' then     // Se não encontrar retorna o mesmo número informado
    Result := sNumeroSerie;

  FreeAndNil(IBQECFS);
  FreeAndNil(IBTECFS);

end;

function CertificadoPertenceAoEmitente(sSubjectName: String;
  sCNPJEmitente: String): Boolean;
begin
  // Valida se o cnpj raiz do emitente tem 8 dígitos e está contido no subjectname do certificado
  Result := (AnsiContainsText(sSubjectName, Copy(LimpaNumero(sCNPJEmitente), 1, 8))) and (Length(Copy(LimpaNumero(sCNPJEmitente), 1, 8)) = 8);
end;

procedure LogFrente(sTexto: String; sDiretorioAtual: String);
var
  myFile: TextFile;
begin
  if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then
  begin
    {Sandro Silva 2021-09-10 inicio}
    if DirectoryExists(sDiretorioAtual + '\log\blocox') = False then
      CreateDir(sDiretorioAtual + '\log\blocox');
    {Sandro Silva 2021-09-10 fim}

    try
      AssignFile(myFile, PAnsiChar(sDiretorioAtual + '\log\blocox\log_' + FormatDateTime('yyyy-mm-dd', Date) + '.txt'));

      if FileExists(PAnsiChar(sDiretorioAtual + '\log\blocox\log_' + FormatDateTime('yyyy-mm-dd', Date) + '.txt')) = False then
      begin
        {$I-}
        ReWrite(myFile);
        {$I+}
      end
      else
      begin
        {$I-}
        Append(myFile);
        {$I+}
      end;

      WriteLn(myFile, FormatDateTime('dd/mm/yyyy HH:nn:ss.zzz', Now) + ': ' + sTexto);

      CloseFile(myFile);
    except
    end;
  end;
end;

procedure ConectaIBDataBase(IBDATABASE: TIBDatabase; CaminhoBanco: String);
begin
  //ShowMessage('Abrindo banco 692'); // Sandro Silva 2018-09-17
  //LogFrente('Abrindo banco 692', CaminhoBanco);

  IBDATABASE.DatabaseName := CaminhoBanco;
  try
    IBDATABASE.Open;
  except

  end;
end;

procedure FechaIBDataBase(IBDATABASE: TIBDatabase);
begin

  if IBDATABASE <> nil then // Sandro Silva 2020-06-22 
  begin

    if IBDATABASE.Connected then
      IBDATABASE.Close;

  end;
//  LogFrente('Fecha banco 1087', CaminhoBanco);
end;

function DadosEmitente(IBTransaction: TIBTransaction;
  DiretorioAtual: String): TEmitente;
var
  IBQEMITENTE: TIBQuery;
begin
  IBQEMITENTE    := CriaIBQuery(IBTransaction);
  IBQEMITENTE.Close;
  IBQEMITENTE.SQL.Text :=
    'select NOME, CGC, IE, ESTADO, MUNICIPIO ' +
    'from EMITENTE';
  IBQEMITENTE.Open;

  Result.Nome      := IBQEMITENTE.FieldByName('NOME').AsString;
  Result.UF        := IBQEMITENTE.FieldByName('ESTADO').AsString;
  Result.Municipio := IBQEMITENTE.FieldByName('MUNICIPIO').AsString;
  Result.IE        := IBQEMITENTE.FieldByName('IE').AsString;
  Result.CNPJ      := LimpaNumero(IBQEMITENTE.FieldByName('CGC').AsString);
  Result.Configuracao.DiretorioAtual := DiretorioAtual;
  Result.Configuracao.ConfCasas      := LerParametroIni(DiretorioAtual+'\smallcom.inf', 'Outros', 'Casas decimais na quantidade','2');
  Result.Configuracao.PerfilPAF      := PerfilPAF(CHAVE_CIFRAR);
//ShowMessage('160'); // Sandro Silva 2018-09-19
  FreeAndNil(IBQEMITENTE);
end;

function AliquotasISS(IBTransaction: TIBTransaction): String;
var
  IBQISS: TIBQuery;
begin
  Result := '';
  IBQISS := CriaIBQuery(IBTransaction);
  IBQISS.Close;
  IBQISS.SQL.Text :=
    'select * ' +
    'from ICM ' +
    'where ISS > 0';
  IBQISS.Open;
  IBQISS.First;
  while IBQISS.Eof = False do
  begin
    if IBQISS.FieldByName('ISS').AsFloat > 0 then
    begin
      Result := LimpaNumero(FormatFloat('00.00', IBQISS.FieldByName('ISS').AsFloat));
      Break;
    end;
    IBQISS.Next;
  end;
  FreeAndNil(IBQISS); // Sandro Silva 2019-06-18
end;

function Credenciamento(CNPJ: String): String;
var
  sCredenciamento: String;
  sPasta: String;
  sArquivo: String;
  LbBlowfish1: TLbBlowfish;
begin
  sPasta := CHAVE_CIFRAR; // Sandro Silva 2018-09-21

  sArquivo := 'arquivoauxiliarcriptografadopafecfsmallsoft.ini';

  LbBlowfish1 := TLbBlowfish.Create(nil);
  LbBlowfish1.CipherMode := cmECB;

  try
    LbBlowfish1.GenerateKey(sPasta);

    // Sandro Silva 2019-08-07  Sleep(1000);
    sCredenciamento := LerParametroIni(sArquivo, INI_SECAO_ECF, INI_CHAVE_NUMERO_CREDENCIAMENTO_PAF, sCredenciamento);
    if sCredenciamento <> '' then
    begin
      try
        sCredenciamento := LbBlowfish1.DecryptString(sCredenciamento);
        if Copy(sCredenciamento, 1, 18) <> Trim(FormataCpfCgc(LimpaNumero(CNPJ))) then
          sCredenciamento := ''
        else
          sCredenciamento := Copy(sCredenciamento, 19, Length(sCredenciamento));
      except
        sCredenciamento := '';
      end;
    end;
  except
    on E: Exception do
    begin
      sCredenciamento := '';
      //ShowMessage('CREDENCIAMENTO 115' + #13 + E.Message);
      //LogFrente('CREDENCIAMENTO ' + E.Message, CaminhoBanco);
    end;
  end;
  Result := sCredenciamento;
  LbBlowfish1.Free;
end;

function BXSalvarBancoXmlEnvio(IBTRANSACTION1: TIBTransaction;
  sTipo: String; sSerie: String; dtDataHora: TDateTime; XML: WideString;
  dtReferencia: TDate): String;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  sRegistro: String;
  sMensagemResposta: String;
begin
  IBTBLOCOX := CriaIBTransaction(IBTransaction1.DefaultDatabase); // Tem que ser transação diferente do ibdataset27
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);
  Result := '';
  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select REGISTRO, XMLRESPOSTA ' + // Sandro Silva 2018-08-31 'select REGISTRO ' +
      'from BLOCOX ' +
      'where TIPO = ' + QuotedStr(sTipo) +
      ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtReferencia));
    if sTipo = 'REDUCAO' then
    begin
      IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerie)); // Sandro Silva 2017-12-28  IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSeriais));
    end;
    IBQBLOCOX.Open; // Sandro Silva 2017-03-27

    sMensagemResposta := '';
    if IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString <> '' then
      sMensagemResposta := ProcessaResposta(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString, 'Mensagem'); // Sandro Silva 2018-08-31

    if (IBQBLOCOX.FieldByName('REGISTRO').AsString = '') then // Sandro Silva 2018-08-31 if (IBQBLOCOX.FieldByName('REGISTRO').AsString = '') then
    begin

      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'insert into BLOCOX (REGISTRO, TIPO, DATAHORA, XMLENVIO, RECIBO, SERIE, DATAREFERENCIA) ' +
        'values (:REGISTRO, :TIPO, :DATAHORA, :XMLENVIO, :RECIBO, :SERIE, :DATAREFERENCIA)';

      sRegistro := RightStr('0000000000' + IncGenerator(IBTransaction1.DefaultDatabase, 'G_BLOCOX'), 10);
      IBQBLOCOX.ParamByName('REGISTRO').AsString   := sRegistro;
      IBQBLOCOX.ParamByName('TIPO').AsString       := sTipo;
      IBQBLOCOX.ParamByName('DATAHORA').AsDateTime := dtDataHora;
      IBQBLOCOX.ParamByName('XMLENVIO').AsString   := XML;
      IBQBLOCOX.ParamByName('RECIBO').Clear;
      IBQBLOCOX.ParamByName('SERIE').AsString      := sSerie;
      if Trim(IBQBLOCOX.ParamByName('SERIE').AsString) = '' then
        IBQBLOCOX.ParamByName('SERIE').Clear;
      IBQBLOCOX.ParamByName('DATAREFERENCIA').AsDate  := StrToDate(FormatDateTime('dd/mm/yyyy', dtReferencia));

      try
        IBQBLOCOX.ExecSQL;
        IBQBLOCOX.Transaction.Commit;
        Result := sRegistro;
      except
        IBQBLOCOX.Transaction.Rollback;
      end;
    end
    else
    begin
      sRegistro := IBQBLOCOX.FieldByName('REGISTRO').AsString;
      if XML <> '' then
      begin

        //ShowMessage('teste 01 483' + #13 + sMensagemResposta);  // Sandro Silva 2018-11-23

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'update BLOCOX set ' +
          'XMLENVIO = :XMLENVIO ' +
          ', RECIBO = null ' + // Alterou o xml limpa recibo para novo envio Sandro Silva 2018-08-31
          ', XMLRESPOSTA = :XMLRESPOSTA ' +  // ', XMLRESPOSTA = ' + QuotedStr(sMensagemResposta) + // Alterou o xml salva mensagem anterior para novo envio Sandro Silva 2018-08-31
          ' where REGISTRO = ' + QuotedStr(sRegistro);
        IBQBLOCOX.ParamByName('XMLENVIO').AsString    := XML;
        IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := sMensagemResposta;
        if Trim(IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString) = '' then
          IBQBLOCOX.ParamByName('XMLRESPOSTA').Clear;
        try
          IBQBLOCOX.ExecSQL;
          IBQBLOCOX.Transaction.Commit;
          Result := sRegistro;
        except
          IBQBLOCOX.Transaction.Rollback;
        end;
      end;
    end;
  finally
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);
  end;
end;

function BXCabecalhoXml(IE: String; sCredenciamento: String): String;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
begin
  Result :=
    '<Estabelecimento>' +
      '<Ie>' + LimpaNumero(IE) + '</Ie>' +
    '</Estabelecimento>' +
    '<PafEcf>' +
      '<NumeroCredenciamento>' + sCredenciamento + '</NumeroCredenciamento>' +
    '</PafEcf>';
end;

procedure BXGeraXmlReducaoZ(Emitente: TEmitente;
  IBTransaction1: TIBTransaction;
  SerieECF: String; sdtReferencia: String;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean);
var
  //t: TTime;
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  IBQALTERACA: TIBQuery;
  IBQREDUCOES: TIBQuery;
  IBQREDUCAO: TIBQuery;
  IBQITENS: TIBQuery;
  IBQCUPOM: TIBQuery;
  IBQDESCONTO: TIBQuery;
  IBQACRESCIMO: TIBQuery;
  BXReducaoZ: TBlocoXReducaoZ; // Sandro Silva 2016-02-12
  iAliq: Integer;
  sCredenciamento: String;
  sAliqISSQN: String;
  sAliquota: String;

  sNumeroFabricacao: String;
  sModeloECF: String;
  sTipo: String;
  sMarca: String;
  sModelo: String;
  sVersao: String;
  sDataReferencia: String;
  sVendaBrutaDiaria: String;
  sDataHoraEmissao: String; // Sandro Silva 2017-08-02
  sGT: String;
  sCRZ: String;
  sCOO: String;
  sCRO: String;
  sCaixa: String;// Sandro Silva 2016-03-04 POLIMIG BlocoX
  sRegistro: String;
  sArquivoXML: String; // Sandro Silva 2017-03-20
  sAliquotasISS: String;
  sLogRZ: String; // Sandro Silva 2019-04-04
  LbBlowfish1: TLbBlowfish; // Sandro Silva 2019-06-12
  sEncriptaHash: String; // Sandro Silva 2019-06-12
  ArquivoLogBX: TArquivo;
  function SelecionaItens(sPDV: String; sCupomI: String; sCupomF: String; sAliquota: String; dValorTotalizador: Double): String; // Sandro Silva 2020-09-16 function SelecionaItens(sPDV: String; dtData: TDate; sAliquota: String; dValorTotalizador: Double): String;
  var
    sxmlItens: String;
    sTagGrupo: String;
    sCodigoGTIN: String;
    sCodigoCEST: String;
    sCodigoNCMSH: String;
    sValorDesconto: String;
    sValorAcrescimo: String;
    sValorCancelamento: String;
    sValorTotalLiquido: String;

    bCupomCancelado: Boolean;

    rTotalItem: Real;
    rSubTotalCupom: Real;
    rDescontoItem: Real;
    rDescontoCupom: Real;
    rAcrescimoCupom: Real;
    rValorDesconto: Real;
    rValorAcrescimo: Real;
    rValorTotalItemLiquido: Real;

    rSomaValorTotalLiquido: Real; // Sandro Silva 2018-09-11
    cDiferencaTotalizador: Currency; // Sandro Silva 2018-09-11
    // Sandro Silva 2018-11-26  aItens: array of TItens; // Sandro Silva 2018-09-11
    aRZ: TReducaoZItensList; // Sandro Silva 2018-11-26
    iItens: Integer; // Sandro Silva 2018-09-11
    iPosicaoItem: Integer; // Sandro Silva 2018-11-16
    bAchou: Boolean; // Sandro Silva 2018-11-16
    sDescricao: String; // Sandro Silva 2019-04-04
  begin
    // Sandro Silva 2018-11-26  SetLength(aItens, 0); // Sandro Silva 2018-09-11
    aRZ := TReducaoZItensList.Create();// Sandro Silva 2018-11-26
    rSomaValorTotalLiquido := 0.00; // Sandro Silva 2018-09-11

    if (LimpaNumero(sCupomI) = '') or (LimpaNumero(sCupomF) = '') then // se um dos 2 estiver vazio, considera zerado os 2 para evitar demora na geração onde os totais estarão errados
    begin
      sCupomI := '0000000';
      sCupomF := '0000000';
    end;

    IBQITENS.Close;
    IBQITENS.SQL.Text :=
      'select A.CODIGO, A.QUANTIDADE, A.UNITARIO, A.TOTAL, A.REFERENCIA, A.PEDIDO, A.ITEM, A.TIPO, A.CAIXA, A.DATA ' +
      ', A.DESCRICAO as DESCRICAO_ALTERACA ' +
      ', case when coalesce(trim(A.MEDIDA), '''') = '''' then ''UND'' else trim(A.MEDIDA) end as MEDIDA ' + // Sandro Silva 2017-08-17
      ', E.DESCRICAO, E.CEST, E.CF as NCM ' +// Sandro Silva 2017-08-17
      'from ALTERACA A ' +
      'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
      'where A.CAIXA = ' + QuotedStr(sPDV) +
      ' and A.PEDIDO between ' + QuotedStr(sCupomI) + ' and ' + QuotedStr(sCupomF);
    // Diferente de ISS, isento, substituição e não tributado
    if (sAliquota <> 'ISS') and ((Copy(sAliquota, 1, 1) = 'I') or (Copy(sAliquota, 1, 1) = 'F') or (Copy(sAliquota, 1, 1) = 'N')) then
      IBQITENS.SQL.Add(' and A.ALIQUICM <> ''ISS'' and substring(A.ALIQUICM from 1 for 1) = ' + QuotedStr(Copy(sAliquota, 1, 1)))
    else
      IBQITENS.SQL.Add(' and A.ALIQUICM = ' + QuotedStr(sAliquota));

    IBQITENS.SQL.Add(
      ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''CANCEL'') ' +
      ' and A.DESCRICAO <> ''Desconto'' ' +
      ' and A.DESCRICAO <> ''Acréscimo'' ' +
      ' and coalesce(A.CODIGO, '''') <> '''' ' +  // Não listar os descontos/acréscimos cancelados
      ' order by A.PEDIDO, A.ITEM');
    IBQITENS.Open;

    sTagGrupo := '<Produto>';
    if sAliquota = 'ISS' then
      sTagGrupo := '<Servico>';
      
    sxmlItens := '';
    while IBQITENS.Eof = False do
    begin

      sDescricao := Trim(IBQITENS.FieldByName('DESCRICAO').AsString);
      try
        if sDescricao = '' then
        begin
          if Trim(IBQITENS.FieldByName('DESCRICAO_ALTERACA').AsString) = '<CANCELADO>' then
          begin

            // Tenta localizar o produto em uma das tabelas do banco e recuperar a descrição

            // procura a descrição nos itens comprados
            IBQSALVA.Close;
            IBQSALVA.SQL.Text :=
              'select first 1 CODIGO, DESCRICAO ' +
              'from ITENS002 ' +
              'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) +
              'order by REGISTRO desc';
            IBQSALVA.Open;
            if IBQSALVA.FieldByName('CODIGO').AsString <> '' then
            begin
              sDescricao := Trim(IBQSALVA.FieldByName('DESCRICAO').AsString);
            end;

            if sDescricao = '' then
            begin
              // procura a descrição nos itens vendidos
              IBQSALVA.Close;
              IBQSALVA.SQL.Text :=
                'select first 1 CODIGO, DESCRICAO ' +
                'from ITENS001 ' +
                'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) +
                'order by REGISTRO desc';
              IBQSALVA.Open;
              if IBQSALVA.FieldByName('CODIGO').AsString <> '' then
              begin
                sDescricao := Trim(IBQSALVA.FieldByName('DESCRICAO').AsString);
              end;
            end;

            if sDescricao = '' then
            begin
              // procura a descrição nos itens vendidos como serviço
              IBQSALVA.Close;
              IBQSALVA.SQL.Text :=
                'select first 1 CODIGO, DESCRICAO ' +
                'from ITENS003 ' +
                'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) +
                'order by REGISTRO desc';
              IBQSALVA.Open;
              if IBQSALVA.FieldByName('CODIGO').AsString <> '' then
              begin
                sDescricao := Trim(IBQSALVA.FieldByName('DESCRICAO').AsString);
              end;
            end;

            if sDescricao = '' then
            begin
              // procura a descrição nos orçamentos
              IBQSALVA.Close;
              IBQSALVA.SQL.Text :=
                'select first 1 CODIGO, DESCRICAO ' +
                'from ORCAMENT ' +
                'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) +
                'order by REGISTRO desc';
              IBQSALVA.Open;
              if IBQSALVA.FieldByName('CODIGO').AsString <> '' then
              begin
                sDescricao := Trim(IBQSALVA.FieldByName('DESCRICAO').AsString);
              end;
            end;

            if sDescricao = '' then
            begin
              // procura a descrição nos itens fabricados
              IBQSALVA.Close;
              IBQSALVA.SQL.Text :=
                'select first 1 CODIGO, DESCRICAO ' +
                'from ALTERACA ' +
                'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) +
                ' and TIPO = ''FABRIC'' ' +
                'order by REGISTRO desc';
              IBQSALVA.Open;
              if IBQSALVA.FieldByName('CODIGO').AsString <> '' then
              begin
                sDescricao := Trim(IBQSALVA.FieldByName('DESCRICAO').AsString);
              end;
            end;

            if sDescricao = '' then
              sDescricao := 'Produto Código ' + IBQITENS.FieldByName('CODIGO').AsString;

          end
          else
            sDescricao := Trim(IBQITENS.FieldByName('DESCRICAO_ALTERACA').AsString);

        end;

        if Trim(IBQITENS.FieldByName('DESCRICAO').AsString) = '' then
        begin
          if sLogRZ <> '' then
            sLogRZ := sLogRZ + #13 + #10;

          sLogRZ := '- Produto sem cadastro no estoque. No estoque complete o cadastro do produto (NCM, CEST, CIT...): Código ' + IBQITENS.FieldByName('CODIGO').AsString + ' ' + Trim(sDescricao) + ' ' + Trim(IBQITENS.FieldByName('MEDIDA').AsString);

          IBQSALVA.Close;
          IBQSALVA.SQL.Text :=
            'select CODIGO ' +
            'from ESTOQUE ' +
            'where CODIGO = ' + QuotedStr(IBQITENS.FieldByName('CODIGO').AsString);
          IBQSALVA.Open;

          if IBQSALVA.FieldByName('CODIGO').AsString = '' then
          begin // Não encontrou, inclui

            // Incluindo estoque
            IBQSALVA.Close;
            IBQSALVA.Params.Clear;
            IBQSALVA.SQL.Text :=
              'insert into ESTOQUE (REGISTRO, CODIGO, DESCRICAO, MEDIDA, PRECO, ULT_VENDA, TIPO_ITEM, REFERENCIA, IAT, IPPT) ' +
                           'values (right(''0000000000''||gen_id(G_ESTOQUE, 1), 10), ' +
                                   QuotedStr(IBQITENS.FieldByName('CODIGO').AsString) + ', ' +
                                   QuotedStr(Trim(sDescricao)) + ', ' +
                                   QuotedStr(Trim(IBQITENS.FieldByName('MEDIDA').AsString)) + ', ' +
                                   StringReplace(StringReplace(FloatToStr(IBQITENS.FieldByName('UNITARIO').AsFloat), '.', '', [rfReplaceAll]), ',', '.', [rfReplaceAll]) + ',' +
                                   QuotedStr(FormatDateTime('yyyy-mm-dd', IBQITENS.FieldByName('DATA').AsDateTime)) +
                                   ', ''01'', ' +
                                   QuotedStr(Trim(IBQITENS.FieldByName('REFERENCIA').AsString)) + ', ' +
                                   ' ''T'', ''T'')';
            try
              IBQSALVA.ExecSQL;
              IBQSALVA.Transaction.Commit;
              try
                IBQSALVA.Close;
                IBQSALVA.Params.Clear;
                IBQSALVA.SQL.Text :=
                  'select gen_id(G_HASH_ESTOQUE, 1) from RDB$DATABASE';
                IBQSALVA.Open;
                except
                end;

            except
              IBQSALVA.Transaction.Rollback;
            end;
          end;
        end;

      except

      end;

      //LogFrente('Início Item ' + IBQITENS.FieldByName('ITEM').AsString, Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

      sCodigoGTIN  := ConverteAcentos2(Trim(IBQITENS.FieldByName('REFERENCIA').AsString)); // Sandro Silva 2018-08-20 Trim(IBQITENS.FieldByName('REFERENCIA').AsString);
      if ValidaEAN13(LimpaNumero(sCodigoGTIN)) = False then
        sCodigoGTIN := ''
      else
        sCodigoGTIN := LimpaNumero(sCodigoGTIN);

      sCodigoCEST  := ConverteAcentos2(Trim(IBQITENS.FieldByName('CEST').AsString)); // Sandro Silva 2018-08-20 Trim(IBQITENS.FieldByName('CEST').AsString);
      sCodigoNCMSH := ConverteAcentos2(Trim(IBQITENS.FieldByName('NCM').AsString)); // Sandro Silva 2018-08-20 Trim(IBQITENS.FieldByName('NCM').AsString);
      if sCodigoNCMSH = '' then
        sCodigoNCMSH := '00';

      sValorDesconto     := '0,00';
      sValorAcrescimo    := '0,00';
      sValorCancelamento := '0,00';
      sValorTotalLiquido := '0,00';
      try
        // Valida se todo cupom está cancelado cancelado
        IBQCUPOM.Close;
        IBQCUPOM.SQL.Text :=
          'select count(ITEM) as ITENS ' +
          'from ALTERACA ' +
          'where (TIPO = ''BALCAO'') ' +
          ' and PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
          ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
          ' and (DESCRICAO <> ''Desconto'') ' + // Apenas descontos de cada item
          ' and (DESCRICAO <> ''Acréscimo'')';
        IBQCUPOM.Open;

        bCupomCancelado := (IBQCUPOM.FieldByName('ITENS').AsInteger = 0);

        //Desconto no Cupom
        IBQDESCONTO.Close;
        IBQDESCONTO.SQL.Text :=
          'select TOTAL ' +
          'from ALTERACA ' +
          'where PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
          ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
          ' and coalesce(ITEM, '''') = '''' ' +
          ' and DESCRICAO = ''Desconto'' ';
        IBQDESCONTO.Open;

        rDescontoCupom := IBQDESCONTO.FieldByName('TOTAL').AsFloat;

        //
        // Acréscimo
        //
        if bCupomCancelado then
        begin

          //Desconto no item
          IBQDESCONTO.Close;
          IBQDESCONTO.SQL.Text :=
            'select TOTAL ' +
            'from ALTERACA ' +
            'where (TIPO = ''CANCEL'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
            ' and ITEM = ' + QuotedStr(IBQITENS.FieldByName('ITEM').AsString) +
            ' and DESCRICAO = ''Desconto'' ';
          IBQDESCONTO.Open;

          rDescontoItem := IBQDESCONTO.FieldByName('TOTAL').AsFloat;

          IBQACRESCIMO.Close;
          IBQACRESCIMO.SQL.Text :=
            'select sum(TOTAL) as ACRESCIMO ' +
            'from ALTERACA ' +
            'where PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and (TIPO = ''CANCEL'') ' +
            ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString);
          IBQACRESCIMO.Open;
          //
          rAcrescimoCupom := IBQACRESCIMO.FieldByName('ACRESCIMO').AsFloat;

          // Total do cupom para ratear o desconto do cupom entre os itens
          IBQCUPOM.Close;
          IBQCUPOM.SQL.Text :=
            'select sum(TOTAL) as TOTAL ' +
            'from ALTERACA ' +
            'where (TIPO = ''CANCEL'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
            ' and ((DESCRICAO <> ''Desconto'') or (DESCRICAO = ''Desconto'' and coalesce(ITEM, '''') <> '''')) ' + // Apenas descontos de cada item
            ' and (DESCRICAO <> ''Acréscimo'')';
          IBQCUPOM.Open;

          rSubTotalCupom         := IBQCUPOM.FieldByName('TOTAL').AsFloat;

        end
        else
        begin

          //Desconto no item
          IBQDESCONTO.Close;
          IBQDESCONTO.SQL.Text :=
            'select TOTAL ' +
            'from ALTERACA ' +
            'where PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
            ' and ITEM = ' + QuotedStr(IBQITENS.FieldByName('ITEM').AsString) +
            ' and (TIPO = ''BALCAO'') ' +
            ' and DESCRICAO = ''Desconto'' ';
          IBQDESCONTO.Open;

          rDescontoItem := IBQDESCONTO.FieldByName('TOTAL').AsFloat;

          IBQACRESCIMO.Close;
          IBQACRESCIMO.SQL.Text :=
            'select sum(TOTAL) as ACRESCIMO ' +
            'from ALTERACA ' +
            'where PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and (TIPO = ''BALCAO'') ' +
            ' and DESCRICAO = ' + QuotedStr('Acréscimo') +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString);
          IBQACRESCIMO.Open;
          //
          rAcrescimoCupom := IBQACRESCIMO.FieldByName('ACRESCIMO').AsFloat;

          // Total do cupom para ratear o desconto do cupom entre os itens
          IBQCUPOM.Close;
          IBQCUPOM.SQL.Text :=
            'select sum(TOTAL) as TOTAL ' +
            'from ALTERACA ' +
            'where (TIPO = ''BALCAO'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQITENS.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(IBQITENS.FieldByName('CAIXA').AsString) +
            ' and ((DESCRICAO <> ''Desconto'') or (DESCRICAO = ''Desconto'' and coalesce(ITEM, '''') <> '''')) ' + // Apenas descontos de cada item
            ' and (DESCRICAO <> ''Acréscimo'')';
          IBQCUPOM.Open;

          rSubTotalCupom := IBQCUPOM.FieldByName('TOTAL').AsFloat;

        end;

        //Configurado 3 casas decimais para tornar mais preciso a soma quando existe desconto/acréscimo em cupom com o mesmo produto repetido muitas vezes
        // Os dados devem ficar agrupados por alíquota e produto
        // Cliente lançou 110x o mesmo item e deu desconto no final do cupom
        // Total de cada item 24,90
        // Desconto no cupom 410,85
        // Rateio desconto para cada item 3,735
        // Arredondar o rateio ficaria 3,73
        // Somando o desconto de cada um dos 110 itens ficaria 410,30 (3,73 X 110), ficando diferença de 0,55
        // Para fins de acumulo mantem 3 casas decimais, arredondando para duas casas apenas no final quando gera a tag
        if IBQITENS.FieldByName('TIPO').AsString = 'BALCAO' then
        begin
          rTotalItem             := StrToFloat(FormatFloat('0.00', (IBQITENS.FieldByName('TOTAL').AsFloat - abs(rDescontoItem)))) ;  //0,90 || 1,00
          if rSubTotalCupom > 0 then
          begin
            rValorAcrescimo := StrToFloat(FormatFloat('0.000', (rTotalItem / rSubTotalCupom) * rAcrescimoCupom));     //(0,90/1,9)*0,4 = 0,19  || (1/1,9)*0,40 = 0,21
            rValorDesconto  := StrToFloat(FormatFloat('0.000', (rTotalItem / rSubTotalCupom) * Abs(rDescontoCupom))); //(0,90/1,9)*0 = 0        || (1/1,90)*0 = 0
          end
          else
          begin
            rValorAcrescimo := 0.00;
            rValorDesconto  := 0.00;
          end;
          rValorTotalItemLiquido := rTotalItem + rValorAcrescimo - rValorDesconto; // 0,9+0,19 - 0= 1,09  || 0,90+,21-0 = 1,21

          sValorDesconto     := FormatFloat('0.000', Abs(rValorDesconto) + Abs(rDescontoItem)); // desconto rateado + desconto do item
          sValorAcrescimo    := FormatFloat('0.000', rValorAcrescimo);
          sValorTotalLiquido := FormatFloat('0.000', rValorTotalItemLiquido);
        end
        else// if IBQITENS.FieldByName('TIPO').AsString = 'CANCEL' then
        begin
          rTotalItem             := StrToFloat(FormatFloat('0.00', (IBQITENS.FieldByName('TOTAL').AsFloat - abs(rDescontoItem)))) ;  //0,90 || 1,00

          if bCupomCancelado then
          begin
            rValorAcrescimo        := StrToFloat(FormatFloat('0.000', (rTotalItem / rSubTotalCupom) * rAcrescimoCupom));     //(0,90/1,9)*0,4 = 0,19  || (1/1,9)*0,40 = 0,21
            rValorDesconto         := StrToFloat(FormatFloat('0.000', (rTotalItem / rSubTotalCupom) * Abs(rDescontoCupom))); //(0,90/1,9)*0 = 0       || (1/1,90)*0 = 0
          end
          else
          begin
            rValorAcrescimo  := 0.00;
            rValorDesconto   := 0.00;
          end;

          if bCupomCancelado then
            rValorTotalItemLiquido := rTotalItem + rValorAcrescimo + abs(rDescontoItem) - abs(rValorDesconto) // Desconto do cupom deve descontar do total Sandro Silva 2018-10-23 rValorTotalItemLiquido := rTotalItem + rValorAcrescimo + abs(rDescontoItem) + rValorDesconto
          else
            rValorTotalItemLiquido := rTotalItem + rValorAcrescimo;

          sValorCancelamento := FormatFloat('0.000', rValorTotalItemLiquido);

          if bCupomCancelado then
            sValorDesconto   := FormatFloat('0.000', rValorDesconto) // desconto rateado + desconto do item
          else
            sValorDesconto   := '0,00';

          sValorAcrescimo    := FormatFloat('0.000', rValorAcrescimo); // Sandro Silva 2018-10-04  '0,00';
          sValorTotalLiquido := '0,00';
        end;
        {Sandro Silva 2020-04-27 fim}
      except

      end;

      rSomaValorTotalLiquido := rSomaValorTotalLiquido + StrToFloat(sValorTotalLiquido);

      // Acumula no array para conferir a soma dos itens com o valor do totalizador

      // Não é permitido duplicar produtos/serviços na Redução Z
      // O sistema verifica se existem produtos duplicados dentro de um mesmo totalizador.
      bAchou := False;
      iPosicaoItem := -1;

      for iItens := 0 to aRZ.Count -1 do
      begin
        if ((sCodigoGTIN <> '') and (aRZ.Items[iItens].CodigoGTIN = sCodigoGTIN)) // Tem gtin e o gtin já está em outro produto
          or (aRZ.Items[iItens].CodigoProprio = Trim(IBQITENS.FieldByName('CODIGO').AsString)) // Código interno repetido em outro produto
         then
        begin
          bAchou := True;
          iPosicaoItem := iItens;
          Break;
        end;
      end;

      if bAchou = False then
      begin
        aRZ.Adiciona(IfThen(sAliquota = 'ISS', 'ISS', 'ICMS'),
          ConverteAcentos2(Trim(sDescricao)), // Sandro Silva 2019-04-04 ConverteAcentos2(Trim(IBQITENS.FieldByName('DESCRICAO').AsString)),
          sCodigoGTIN, sCodigoCEST, sCodigoNCMSH,
          Trim(IBQITENS.FieldByName('CODIGO').AsString),
          IBQITENS.FieldByName('QUANTIDADE').AsFloat,
          ConverteAcentos2(Trim(IBQITENS.FieldByName('MEDIDA').AsString)),
          StrToFloat(sValorDesconto), StrToFloat(sValorAcrescimo), StrToFloat(sValorCancelamento), StrToFloat(sValorTotalLiquido), 0);
      end
      else
      begin
        aRZ.Items[iPosicaoItem].Quantidade        := aRZ.Items[iPosicaoItem].Quantidade + IBQITENS.FieldByName('QUANTIDADE').AsFloat;
        aRZ.Items[iPosicaoItem].ValorDesconto     := aRZ.Items[iPosicaoItem].ValorDesconto + StrToFloat(sValorDesconto);
        aRZ.Items[iPosicaoItem].ValorAcrescimo    := aRZ.Items[iPosicaoItem].ValorAcrescimo + StrToFloat(sValorAcrescimo);
        aRZ.Items[iPosicaoItem].ValorCancelamento := aRZ.Items[iPosicaoItem].ValorCancelamento + StrToFloat(sValorCancelamento);
        aRZ.Items[iPosicaoItem].ValorTotalLiquido := aRZ.Items[iPosicaoItem].ValorTotalLiquido + StrToFloat(sValorTotalLiquido);
      end;

      //LogFrente('Incluiu na lista Item ' + IBQITENS.FieldByName('ITEM').AsString, Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

      IBQITENS.Next;
    end; // while IBQITENS.Eof = False do

    if aRZ.Count > 0 then // Sandro Silva 2018-11-26 if Length(aItens) > 0 then
    begin

      // Rateia a diferença entre os produtos da alíquota
      cDiferencaTotalizador := StrToFloat(FormatFloat('0.00', dValorTotalizador - rSomaValorTotalLiquido));
      if cDiferencaTotalizador <> 0.00 then
      begin

        for iItens := 0 to aRZ.Count -1 do
        begin
          try
            aRZ.Items[iItens].ValorDiferenca    := StrToFloat(FormatFloat('0.00', (aRZ.Items[iItens].ValorTotalLiquido / rSomaValorTotalLiquido) * cDiferencaTotalizador));
          except
            aRZ.Items[iItens].ValorDiferenca    := 0.00; // Sandro Silva 2022-02-16
          end;
          aRZ.Items[iItens].ValorTotalLiquido := aRZ.Items[iItens].ValorTotalLiquido + aRZ.Items[iItens].ValorDiferenca;
        end;
      end;

      // Confere se o valor do totalizador é igual a soma dos itens
      rSomaValorTotalLiquido := 0.00;

      for iItens := 0 to aRZ.Count -1 do
      begin
        rSomaValorTotalLiquido := rSomaValorTotalLiquido + aRZ.Items[iItens].ValorTotalLiquido;
      end;

      // Repete a comparação se tem diferença e repassa para o primeiro item com valor maior que a diferença
      cDiferencaTotalizador := StrToFloat(FormatFloat('0.00', dValorTotalizador - rSomaValorTotalLiquido));
      if cDiferencaTotalizador <> 0.00 then
      begin
        for iItens := 0 to aRZ.Count -1 do
        begin
          if aRZ.Items[iItens].ValorTotalLiquido > Abs(cDiferencaTotalizador) then
          begin
            aRZ.Items[iItens].ValorDiferenca    := aRZ.Items[iItens].ValorDiferenca + StrToFloat(FormatFloat('0.00', cDiferencaTotalizador));
            aRZ.Items[iItens].ValorTotalLiquido := aRZ.Items[iItens].ValorTotalLiquido + cDiferencaTotalizador;
            Break;
          end;
        end;

      end;

      //LogFrente('Início tags Item ', Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

      for iItens := 0 to aRZ.Count -1 do
      begin
        if aRZ.Items[iItens].Tipo = 'ISS' then
          sxmlItens := sxmlItens + sTagGrupo +
            '<Descricao>' + aRZ.Items[iItens].DESCRICAO + '</Descricao>' +
            '<CodigoProprio>' + aRZ.Items[iItens].CodigoProprio + '</CodigoProprio>' +// Sandro Silva 2017-08-03  '<Codigo>' + Trim(IBQESTOQUE.FieldByName('CODIGO').AsString) + '</Codigo>' +// Sandro Silva 2016-03-04 POLIMIG
            '<Quantidade>' + FormatFloat('0.' + DupeString('0', StrToIntDef(Emitente.Configuracao.ConfCasas, 2)), aRZ.Items[iItens].Quantidade) + '</Quantidade>' + // Sandro Silva 2016-03-04 POLIMIG
            '<Unidade>' + aRZ.Items[iItens].Unidade + '</Unidade>' +
            '<ValorDesconto>' + FormatFloat('0.00', aRZ.Items[iItens].ValorDesconto) + '</ValorDesconto>' +
            '<ValorAcrescimo>' + FormatFloat('0.00', aRZ.Items[iItens].ValorAcrescimo) + '</ValorAcrescimo>' +
            '<ValorCancelamento>' + FormatFloat('0.00', aRZ.Items[iItens].ValorCancelamento) + '</ValorCancelamento>' +
            '<ValorTotalLiquido>' + FormatFloat('0.00', aRZ.Items[iItens].ValorTotalLiquido) + '</ValorTotalLiquido>' +
          '</Servico>'
        else
          sxmlItens := sxmlItens + sTagGrupo +
            '<Descricao>' + aRZ.Items[iItens].DESCRICAO + '</Descricao>' +
            '<CodigoGTIN>' + aRZ.Items[iItens].CodigoGTIN + '</CodigoGTIN>' +
            '<CodigoCEST>' + aRZ.Items[iItens].CodigoCEST + '</CodigoCEST>' +
            '<CodigoNCMSH>' + aRZ.Items[iItens].CodigoNCMSH + '</CodigoNCMSH>' +
            '<CodigoProprio>' + aRZ.Items[iItens].CodigoProprio + '</CodigoProprio>' +// Sandro Silva 2017-08-03  '<Codigo>' + Trim(IBQESTOQUE.FieldByName('CODIGO').AsString) + '</Codigo>' +// Sandro Silva 2016-03-04 POLIMIG
            '<Quantidade>' + FormatFloat('0.' + DupeString('0', StrToIntDef(Emitente.Configuracao.ConfCasas, 2)), aRZ.Items[iItens].QUANTIDADE) + '</Quantidade>' + // Sandro Silva 2016-03-04 POLIMIG
            '<Unidade>' + aRZ.Items[iItens].Unidade + '</Unidade>' +
            '<ValorDesconto>' + FormatFloat('0.00', aRZ.Items[iItens].ValorDesconto) + '</ValorDesconto>' +
            '<ValorAcrescimo>' + FormatFloat('0.00', aRZ.Items[iItens].ValorAcrescimo) + '</ValorAcrescimo>' +
            '<ValorCancelamento>' + FormatFloat('0.00', aRZ.Items[iItens].ValorCancelamento) + '</ValorCancelamento>' +
            '<ValorTotalLiquido>' + FormatFloat('0.00', aRZ.Items[iItens].ValorTotalLiquido) + '</ValorTotalLiquido>' +
          '</Produto>';
      end;

      //LogFrente('Fim tags Itens ', Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

    end; // if Length(aItens) > 0 then

    aRZ.Clear; // Sandro Silva 2019-06-19

    FreeAndNil(aRZ); // Sandro Silva 2019-06-19 aRZ.Free;
    Result := sxmlItens;

  end;

  procedure SelecionaTotalizador(sPDV: String; sCupomI: String; sCupomF: String; sAliquota: String; dValorAliquota: Double; sOrdem: String); // Sandro Silva 2020-09-16 procedure SelecionaTotalizador(sPDV: String; dtData: TDate; sAliquota: String; dValorAliquota: Double; sOrdem: String);
    function FormataAliquota(sAliquota: String): String;
    begin
      if Trim(sAliquota) = 'ISS' then
      begin
        Result := 'S';
      end
      else
      begin
        if LimpaNumero(sAliquota) = '' then
          Result := Copy(sAliquota, 1, 1)
        else
          Result := sAliquota;
      end;
    end;
    var
      sTipoTot: String;
      sNomeAliq: String;
  begin
    {Sandro Silva 2017-11-08 inicio Polimig}
    sNomeAliq := Trim(FormataAliquota(sAliquota));

    //ShowMessage('Totalizador ' + sNomeAliq + ' 630'); // Sandro Silva 2018-09-17

    sAliquota := Trim(sAliquota);
    if ((sModeloECF = '02') and (AnsiContainsText(sAliquotasISS, sAliquota)))
     or ((sModeloECF <> '02') and (Trim(sAliquota) = 'ISS')) then
    begin
      sTipoTot := sOrdem + 'S' + LimpaNumero(sAliquota); //sNomeAliq;
    end
    else
    begin
      if LimpaNumero(sAliquota) = '' then
        sTipoTot := sNomeAliq
      else
        sTipoTot := sOrdem + 'T' + sNomeAliq;
    end;
    sNomeAliq := sTipoTot;
    {Sandro Silva 2017-11-08 final Polimig}

    {Sandro Silva 2017-11-13 inicio HOMOLOGA 2017}
    // Formatar o Nome da Aliquota de ISS
    try

      if (sNomeAliq = 'S') and (Trim(sAliquota) = 'ISS') then
      begin
        sNomeAliq := sOrdem + sNomeAliq + sAliqISSQN;
      end
      else
      begin
        if sAliquota = 'ISS' then
        begin
          if StrToIntDef(AliquotaISSConfigura(IBQREDUCAO.Transaction), 0) > 0 then
          begin
            if FormatFloat('0000', StrToIntDef(AliquotaISSConfigura(IBQREDUCAO.Transaction), 0)) = FormatFloat('0000', StrToIntDef(IBQREDUCAO.FieldByName('ALIQU' + Strzero(iAliq, 2, 0)).AsString, 0)) then
            begin
              sNomeAliq := sOrdem + 'S' + FormatFloat('0000', StrToIntDef(IBQREDUCAO.FieldByName('ALIQU' + Strzero(iAliq, 2, 0)).AsString, 0));
            end;
          end;
        end;
      end;

    except
      sNomeAliq := sTipoTot;
    end;

    if (sNomeAliq = 'F') or (sNomeAliq = 'I') or (sNomeAliq = 'N') then
      sNomeAliq := sNomeAliq + '1';

    if sAliquota = 'ISS' then
    begin
      if Length(sNomeAliq) < 4 then // Se é ISSQN e não tem alíquota configurada atribui '0000' para não listar o totalizador
        sAliquota := '0000';
    end;

    //LogFrente('Aliquota ' + SALIQUOTA, Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

    if sAliquota <> '0000' then
    begin
      //LogFrente('Totalizador ' + sNomeAliq + ' ' + FormatFloat('0.00', dValorAliquota), CaminhoBanco);

      BXReducaoZ.XML := BXReducaoZ.XML  +
        '<TotalizadorParcial>' +
            '<Nome>' + sNomeAliq + '</Nome>' + // Sandro Silva 2016-03-04 POLIMIG// Sandro Silva 2017-11-08 Polimig  '<Nome>' + Trim(FormataAliquota(sAliquota)) + '</Nome>' + // Sandro Silva 2016-03-04 POLIMIG
            '<Valor>' + FormatFloat('0.00', dValorAliquota) + '</Valor>' +
            '<ProdutosServicos>' +
              SelecionaItens(sPDV, sCupomI, sCupomF, sAliquota, StrToFloat(FormatFloat('0.00', dValorAliquota))) + // Sandro Silva 2020-09-16 SelecionaItens(sPDV, dtData, sAliquota, StrToFloat(FormatFloat('0.00', dValorAliquota))) +  // Sandro Silva 2018-09-11  SelecionaItens(sPDV, dtData, sAliquota) +
            '</ProdutosServicos>' +
        '</TotalizadorParcial>';
    end;
  end;
begin
  //T := Time;

//ShowMessage('Teste 01 1459'); // Sandro Silva 2021-01-04

  if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06
  begin

    IBQREDUCOES   := CriaIBQuery(IBTransaction1);
    IBQREDUCOES.DisableControls; // Sandro Silva 2019-11-05

    IBQALTERACA   := CriaIBQuery(IBTransaction1);
    IBQALTERACA.DisableControls; // Sandro Silva 2019-11-05

    sLogRZ := ''; // Sandro Silva 2019-04-04

//ShowMessage('Teste 01 1469'); // Sandro Silva 2021-01-04

    // Seleciona o movimento (itens vendido)
    IBQALTERACA.Close;
    IBQALTERACA.SQL.Text :=
      'select first 1 * ' +
      'from ALTERACA ' +
      'where TIPO = ''BALCAO'' or TIPO = ''CANCEL'' or TIPO = ''LOKED'' or TIPO = ''CANLOK'' or TIPO = ''KOLNAC'' ';
    IBQALTERACA.Open;

    //Seleciona os dados da Redução Z (pode ser que não tenha movimento, REDUCOES.TOTALI e REDUCOES.TOTALF serão iguais)
    IBQREDUCOES.Close;
    IBQREDUCOES.SQL.Text :=
      'select * ' +
      'from REDUCOES ' +
      'where SERIE  = ' + QuotedStr(SerieECF) +
      ' and DATA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(sdtReferencia)));
    IBQREDUCOES.Open;


//ShowMessage('Teste 01 1478'); // Sandro Silva 2021-01-04

    // Sandro Silva 2021-01-18  if IBQREDUCOES.FieldByName('REGISTRO').AsString <> '' then // Gerar xml da redução apenas se existir movimento no alteraca. Não gera quando recupera dados da última rz com o banco vazio
    if (IBQALTERACA.FieldByName('REGISTRO').AsString <> '')
      or ((IBQALTERACA.FieldByName('REGISTRO').AsString = '') and (IBQREDUCOES.FieldByName('TOTALI').AsFloat = IBQREDUCOES.FieldByName('TOTALF').AsFloat)) // Só tem redução Z, sem movimento
    then // Gerar xml da redução apenas se existir movimento no alteraca. Não gera quando recupera dados da última rz com o banco vazio
    begin

//ShowMessage('Teste 01 1502'); // Sandro Silva 2021-01-04

      IBQREDUCOES.Close;
      IBQREDUCOES.SQL.Text :=
        'select first 1 * ' +
        'from ALTERACA ' +
        'where TIPO = ''BALCAO'' ' +
        ' and DESCRICAO = ''<CANCELADO>'' ';
      IBQREDUCOES.Open;

//ShowMessage('Teste 01 1512'); // Sandro Silva 2021-01-04

      if IBQREDUCOES.FieldByName('REGISTRO').AsString <> '' then
      begin

        IBTSALVA := CriaIBTransaction(IBTransaction1.DefaultDatabase);// CriaIBTransaction(IBDATABASE);
        IBQSALVA := CriaIBQuery(IBTSALVA);
        IBQSALVA.DisableControls; // Sandro Silva 2019-11-05

        LbBlowfish1 := TLbBlowfish.Create(nil);
        LbBlowfish1.CipherMode := cmECB;

        try
          sEncriptaHash := '';
          LbBlowfish1.GenerateKey(CHAVE_CIFRAR);
          sEncriptaHash := LbBlowfish1.EncryptString(MD5Print(MD5String(CHAVE_CIFRAR)));
        except
          sEncriptaHash := '';
        end;
        FreeAndNil(LbBlowfish1); // Sandro Silva 2019-06-19 LbBlowfish1.Free;

        try
          IBQSALVA.Close;
          IBQSALVA.SQL.Text :=
            'update ALTERACA set ' +
            'TIPO = ''CANCEL'', ' +
            'ENCRYPTHASH = nullif(' + QuotedStr(sEncriptaHash) + ', '''') ' + // Sandro Silva 2019-06-12 'ENCRYPTHASH = null ' +
            'where TIPO = ''BALCAO'' ' +
            ' and DESCRICAO = ''<CANCELADO>'' ';
          IBQSALVA.ExecSQL;
          IBQSALVA.Transaction.Commit;
        except
          IBQSALVA.Transaction.Rollback;
        end;
        FreeAndNil(IBQSALVA);
        FreeAndNil(IBTSALVA);
      end;

//ShowMessage('Teste 01 1554'); // Sandro Silva 2021-01-04

      IBQREDUCOES.Close;
      IBQREDUCOES.SQL.Text :=
        'select * ' +
        'from REDUCOES ' +
        'where SERIE  = ' + QuotedStr(SerieECF) +
        ' and DATA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(sdtReferencia))) +
        ' order by DATA ';
      IBQREDUCOES.Open;

//ShowMessage('Teste 01 1565'); // Sandro Silva 2021-01-04

      sModeloECF := IBQREDUCOES.FieldByName('SMALL').AsString;

    //ShowMessage('MODELO_ECF ' + sModeloECF + ' 769');

      sAliquotasISS := AliquotasISS(IBQREDUCOES.Transaction);

    //ShowMessage('AliquotasISS ' + sAliquotasISS + ' 781');

      BXReducaoZ := TBlocoXReducaoZ.Create(nil);

      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'ECF', SerieECF);
      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Referencia', sdtReferencia);
      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Emissao', FormatDateTime('dd/mm/yyyy HH:nn:ss', Now));

      //ShowMessage('Teste 01 Marcou início geração xml RZ ' + sdtReferencia); // Sandro Silva 2019-02-15

      if (sModeloECF <> '59') and (sModeloECF <> '65') then
      begin

        IBTSALVA := CriaIBTransaction(IBTransaction1.DefaultDatabase);// CriaIBTransaction(IBDATABASE);
        IBQSALVA := CriaIBQuery(IBTSALVA);

        IBQREDUCAO   := CriaIBQuery(IBTransaction1);
        IBQITENS     := CriaIBQuery(IBTransaction1);
        IBQCUPOM     := CriaIBQuery(IBTransaction1);
        IBQDESCONTO  := CriaIBQuery(IBTransaction1);
        IBQACRESCIMO := CriaIBQuery(IBTransaction1);

        IBQREDUCAO.BufferChunks   := 10;
        IBQITENS.BufferChunks     := 10;
        IBQCUPOM.BufferChunks     := 10;
        IBQDESCONTO.BufferChunks  := 10;
        IBQACRESCIMO.BufferChunks := 10;

        IBQREDUCAO.UniDirectional   := True;
        IBQITENS.UniDirectional     := True;
        IBQCUPOM.UniDirectional     := True;
        IBQDESCONTO.UniDirectional  := True;
        IBQACRESCIMO.UniDirectional := True;

        IBQREDUCAO.DisableControls;
        IBQITENS.DisableControls;
        IBQCUPOM.DisableControls;
        IBQDESCONTO.DisableControls;
        IBQACRESCIMO.DisableControls;

        sCredenciamento := Credenciamento(FormataCpfCgc(Emitente.CNPJ));

        if sCredenciamento = '' then
          LogFrente('Credenciamento não informado', Emitente.Configuracao.DiretorioAtual);
    //ShowMessage('SCREDENCIAMENTO ' + sCredenciamento + ' 805');

        BXReducaoZ.UF  := Emitente.UF; // Sandro Silva 2018-09-21 IBQEMITENTE.FieldByName('ESTADO').AsString;
        BXReducaoZ.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', ''); // 'CN=SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI:07426598000124, OU=Autenticado por AR EXXA, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, L=CONCORDIA, S=SC, O=ICP-Brasil, C=BR';

        BXReducaoZ.GetCertificado(True);

        if (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado','') = '') and (BXReducaoZ.CertificadoSubjectName <> '') then // Sandro Silva 2016-03-05 POLIMIG
          GravarParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', BXReducaoZ.CertificadoSubjectName);

//ShowMessage('Teste 01 1633'); // Sandro Silva 2021-01-04

        try
          IBQREDUCAO.Close;
          IBQREDUCAO.SQL.Text :=
            'select first 1 RZ.PDV, RZ.DATA, RZ.TIPOECF, RZ.MARCAECF, RZ.MODELOECF, RZ.VERSAOSB, ' +
            'RZ.CONTADORZ, RZ.CUPOMF as COO, RZ.ALIQUOTA16 as CRO, ' +
            'RZ.CUPOMI, RZ.CUPOMF, ' + // Sandro Silva 2020-09-16
            'RZ.TOTALI, RZ.TOTALF, ' +
            'RZ.CANCELAMEN, RZ.DESCONTOS, ' + // Sandro Silva 2017-12-27 Polimig
            'RZ.ALIQUOTA01, RZ.ALIQUOTA02, RZ.ALIQUOTA03, RZ.ALIQUOTA04, RZ.ALIQUOTA05, RZ.ALIQUOTA06, ' +
            'RZ.ALIQUOTA07, RZ.ALIQUOTA08, RZ.ALIQUOTA09, RZ.ALIQUOTA10, RZ.ALIQUOTA11, RZ.ALIQUOTA12, ' +
            'RZ.ALIQUOTA13, RZ.ALIQUOTA14, RZ.ALIQUOTA15, RZ.ALIQUOTA17, RZ.ALIQUOTA18, RZ.ALIQUOTA19, ' +
            'RZ.ALIQU01, RZ.ALIQU02, RZ.ALIQU03, RZ.ALIQU04, RZ.ALIQU05, RZ.ALIQU06, RZ.ALIQU07, ' +
            'RZ.ALIQU08, RZ.ALIQU09, RZ.ALIQU10, RZ.ALIQU11, RZ.ALIQU12, RZ.ALIQU13, RZ.ALIQU14, RZ.ALIQU15 ' +
            ', RZ.HORA ' +
            ', D.DATA as DATAEMISSAOREDUCAOZ, D.HORA as HORAEMISSAOREDUCAOZ ' + // Sandro Silva 2017-08-02
            'from REDUCOES RZ ' +
            'left join DEMAIS D on D.ECF = RZ.SERIE ' +
              '  and D.DENOMINACAO = ''RZ'' ' +
              ' and (cast(D.COO as integer) = (cast(RZ.CUPOMF as integer)) or (cast(D.COO as integer) = (cast(RZ.CUPOMF as integer) + 1))) ' +
            ' where RZ.SERIE = ' + QuotedStr(SerieECF) +
            ' and RZ.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(sdtReferencia))) +
            ' order by RZ.CONTADORZ desc';
          IBQREDUCAO.Open;

//ShowMessage('Teste 01 1659'); // Sandro Silva 2021-01-04

    //ShowMessage('dados redução 780'); // Sandro Silva 2018-09-17

          if IBQREDUCAO.FieldByName('DATA').AsString <> '' then // Sandro Silva 2017-11-01
          begin

            //LogFrente('Teste 1117 ', Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-03-28

//ShowMessage('Teste 01 1668'); // Sandro Silva 2021-01-04

            sNumeroFabricacao := Trim(SerieECF);
            sTipo             := ConverteAcentos2(Trim(IBQREDUCAO.FieldByName('TIPOECF').AsString));
            sMarca            := ConverteAcentos2(Trim(IBQREDUCAO.FieldByName('MARCAECF').AsString));
            sModelo           := ConverteAcentos2(Trim(IBQREDUCAO.FieldByName('MODELOECF').AsString));
            sVersao           := ConverteAcentos2(Trim(IBQREDUCAO.FieldByName('VERSAOSB').AsString));
            sDataReferencia   := FormatDateTime('yyyy-mm-dd', IBQREDUCAO.FieldByName('DATA').AsDateTime);// Sandro Silva 2016-03-04 POLIMIG
            if (IBQREDUCAO.FieldByName('DATAEMISSAOREDUCAOZ').AsString <> '') then
              sDataHoraEmissao  := FormatDateTime('yyyy-mm-dd', IBQREDUCAO.FieldByName('DATAEMISSAOREDUCAOZ').AsDateTime)
            else
              sDataHoraEmissao  := FormatDateTime('yyyy-mm-dd', IBQREDUCAO.FieldByName('DATA').AsDateTime);

            try
              if (IBQREDUCAO.FieldByName('HORAEMISSAOREDUCAOZ').AsString <> '') then
                sDataHoraEmissao  := sDataHoraEmissao + 'T' + FormatDateTime('HH:nn:ss', IBQREDUCAO.FieldByName('HORAEMISSAOREDUCAOZ').AsDateTime) // Sandro Silva 2017-08-02
              else
                sDataHoraEmissao  := sDataHoraEmissao + 'T' + FormatDateTime('HH:nn:ss', IBQREDUCAO.FieldByName('HORA').AsDateTime);
            except
              sDataHoraEmissao  := sDataHoraEmissao + 'T18:' + FormatDateTime('nn:ss', Time); // Alguns ECF retornam hora bugada (Bematech '00/00/20') Sandro Silva 2020-08-20
            end;

            sCRZ              := Right(Trim(IBQREDUCAO.FieldByName('CONTADORZ').AsString), 4);

            if AnsiContainsText(Trim(IBQREDUCAO.FieldByName('MODELOECF').AsString), '4200 TH') or AnsiContainsText(Trim(IBQREDUCAO.FieldByName('MODELOECF').AsString), 'FS800') or AnsiContainsText(Trim(IBQREDUCAO.FieldByName('MODELOECF').AsString), 'T800') or AnsiContainsText(Trim(IBQREDUCAO.FieldByName('MODELOECF').AsString), 'T900') then
              sCOO              := Right('000000000' + Trim(IBQREDUCAO.FieldByName('COO').AsString), 9)
            else
              sCOO              := Trim(IBQREDUCAO.FieldByName('COO').AsString);

            sCRO              := Right('000' + Trim(IBQREDUCAO.FieldByName('CRO').AsString), 3);// Sandro Silva 2017-03-10  Trim(IBQREDUCAO.FieldByName('CRO').AsString);
            sVendaBrutaDiaria := FormatFloat(DupeString('0', 14), (IBQREDUCAO.FieldByName('TOTALF').AsFloat - IBQREDUCAO.FieldByName('TOTALI').AsFloat) * 100);// Sandro Silva 2017-03-10  FormatFloat('0.00', IBQREDUCAO.FieldByName('TOTALF').AsFloat - IBQREDUCAO.FieldByName('TOTALI').AsFloat);
            sGT               := FormatFloat(DupeString('0', 18), IBQREDUCAO.FieldByName('TOTALF').AsFloat * 100);// Sandro Silva 2017-03-10  FormatFloat('0.00', IBQREDUCAO.FieldByName('TOTALF').AsFloat);
            sCaixa            := Trim(IBQREDUCAO.FieldByName('PDV').AsString); // Sandro Silva 2016-03-04 POLIMIG

            if Trim(sCaixa) = '' then
            begin

//ShowMessage('Teste 01 1710'); // Sandro Silva 2021-01-04

              // Atualizar campo PDV vazio
              try
                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'update REDUCOES set ' +
                  'PDV = (select first 1 R1.PDV ' +
                         'from REDUCOES R1 ' +
                         'where R1.SERIE = ' + QuotedStr(SerieECF) +
                         ' and coalesce(R1.PDV, '''') <> '''' ' +
                         ' order by R1.DATA desc) ' +
                  'where SERIE = ' + QuotedStr(SerieECF) +
                  ' and coalesce(PDV, '''') = '''' ';
                IBQSALVA.ExecSQL;
                IBQSALVA.Transaction.Commit;

//ShowMessage('Teste 01 1727'); // Sandro Silva 2021-01-04

                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'select first 1 R1.PDV ' +
                  'from REDUCOES R1 ' +
                  'where R1.SERIE = ' + QuotedStr(SerieECF) +
                  ' and coalesce(R1.PDV, '''') <> '''' ' +
                  ' order by R1.DATA desc';
                IBQSALVA.Open;
                sCaixa := Right('00' + IBQSALVA.FieldByName('PDV').AsString, 3);

//ShowMessage('Teste 01 1739'); // Sandro Silva 2021-01-04

              except
                IBQSALVA.Transaction.Rollback;
              end;

            end;

            if Trim(sCaixa) = '' then // Sandro Silva 2016-03-04 POLIMIG
              sCaixa := Right('00' + IBQREDUCOES.FieldByName('PDV').AsString, 3);

            BXReducaoZ.XML :=
            BLOCOX_ESPECIFICACAO_XML + // Sandro Silva 2017-04-28  '<?xml version="1.0" encoding="utf-8" ?>' +
            '<ReducaoZ Versao="' + BLOCOX_VERSAO_LEIAUTE + '">' + // Sandro Silva 2017-04-28  '<ReducaoZ Versao="1.0">' +
              '<Mensagem>' +
                BXCabecalhoXml(Emitente.IE, sCredenciamento) + // Sandro Silva 2018-09-21 BlocoXCabecalhoXml(IBQEMITENTE.FieldByName('IE').AsString, sCredenciamento) +
                '<Ecf>' +
                  '<NumeroFabricacao>' + NumeroDeSerieDoEcfNaSefaz(IBTransaction1, sNumeroFabricacao) + '</NumeroFabricacao>' + // Sandro Silva 2020-06-10   '<NumeroFabricacao>' + sNumeroFabricacao + '</NumeroFabricacao>' +
                  '<DadosReducaoZ>' +
                    '<DataReferencia>' + sDataReferencia + '</DataReferencia>' +
                    '<DataHoraEmissao>' + sDataHoraEmissao + '</DataHoraEmissao>' + // Sandro Silva 2017-08-02  Formato: aaaa-MM-ddThh:mm:ss
                    '<CRZ>' + sCRZ + '</CRZ>' +
                    '<COO>' + sCOO + '</COO>' +
                    '<CRO>' + sCRO + '</CRO>' +
                    '<VendaBrutaDiaria>' + sVendaBrutaDiaria + '</VendaBrutaDiaria>' +
                    '<GT>' + sGT + '</GT>' +
                    '<TotalizadoresParciais>';
                      sAliqISSQN := AliquotaISSConfigura(IBQREDUCOES.Transaction);

                      for iAliq := 1 to 19 do
                      begin
                        case iAliq of
                          1..15: // Totalizadores com alíquota
                            sAliquota := IBQREDUCAO.FieldByName('ALIQU' + Strzero(iAliq, 2, 0)).AsString;
                          16:; // Não faz
                          17: // Totalizador ISENTO III
                            sAliquota := 'III';
                          18: // Totalizador NÃO TRIBUTADO NNN
                            sAliquota := 'NNN';
                          19: // Totalizador SUBSTITUIÇÃO FFF
                            sAliquota := 'FFF';
                        end;
                        if (sAliqISSQN = sAliquota) and (sAliqISSQN <> '0000') then // Sandro Silva 2019-04-23 if sAliqISSQN = sAliquota then
                          sAliquota := 'ISS';

                        //LogFrente('Aliquota ' + sAliquota + ' ' + sAliqISSQN, Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2018-10-10

                        // Sandro Silva 2018-10-29 Conforme auditor fiscal Bruno Nogueira: "Segue retificação dos totalizadores. É necessário enviar o totalizador S"  if sAliquota <> 'ISS' then // Sandro Silva 2018-10-25 Auditor Fiscal Bruno Nogueira: Não anexar o totalizador S, visto que é referente ao ISS. Vou atualizar a documentação, obrigado.
                        //begin
                          if iAliq <> 16 then // ALIQUOTA16 não se refere a um totalizador
                            SelecionaTotalizador(IBQREDUCAO.FieldByName('PDV').AsString,
                                                 // Sandro Silva 2020-09-16 IBQREDUCAO.FieldByName('DATA').AsDateTime,
                                                 IBQREDUCAO.FieldByName('CUPOMI').AsString,
                                                 IBQREDUCAO.FieldByName('CUPOMF').AsString,
                                                 sAliquota,
                                                 IBQREDUCAO.FieldByName('ALIQUOTA' + Strzero(iAliq, 2, 0)).AsFloat,
                                                 Strzero(iAliq, 2, 0));
                        //end;

                      end;

                      BXReducaoZ.XML := BXReducaoZ.XML +
                    '</TotalizadoresParciais>' +
                  '</DadosReducaoZ>' +
                '</Ecf>' +
              '</Mensagem>' +
              '<Signature />' + // Precisa existir para saber onde adicionar elementos da assinatura
            '</ReducaoZ>';
            ForceDirectories(PASTA_REDUCOES_BLOCO_X);

    //ShowMessage(FormatDateTime('HH:nn:ss, zzz', Time - t));

//ShowMessage('Teste 01 1812'); // Sandro Silva 2021-01-04

            if bAssinarXML then
              BXReducaoZ.AssinaXML;

//ShowMessage('Teste 01 1817'); // Sandro Silva 2021-01-04

    //ShowMessage('salva no banco 946'); // Sandro Silva 2018-09-17
            LogFrente('XML Redução gerado: ' + Copy(SerieECF, 1, 20) + ' ' + IBQREDUCAO.FieldByName('DATA').AsString, Emitente.Configuracao.DiretorioAtual);

            sRegistro := BXSalvarBancoXmlEnvio(IBTransaction1, 'REDUCAO', Copy(SerieECF, 1, 20), Now, BXReducaoZ.XML, IBQREDUCAO.FieldByName('DATA').AsDateTime);

            LogFrente(IfThen(sRegistro = '', 'XML não foi salvo no banco', 'XML salvo no banco') + ': ' + Copy(SerieECF, 1, 20) + ' ' + IBQREDUCAO.FieldByName('DATA').AsString, Emitente.Configuracao.DiretorioAtual);

            sArquivoXML := PASTA_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + SerieECF + '_' + LimpaNumero(sDataReferencia) + '.xml';
    //ShowMessage('salva arquivo 1022'); // Sandro Silva 2018-09-17
            if BXReducaoZ.SalvaArquivo(sArquivoXML) then// Sandro Silva 2016-03-04 POLIMIG
            begin
              LogFrente('XML salvo na pasta: ' + Copy(SerieECF, 1, 20) + ' ' + IBQREDUCAO.FieldByName('DATA').AsString, Emitente.Configuracao.DiretorioAtual);

    //ShowMessage('salva arquivo 1028'); // Sandro Silva 2018-09-17
              SalvarHashPasta('REDUCAO', PASTA_REDUCOES_BLOCO_X, '*.xml');
    //ShowMessage('salva hash 1026'); // Sandro Silva 2018-09-17
            end;

            if sRegistro <> '' then
            begin

              if bLimparRecibo then
              begin
                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'update BLOCOX set ' +
                  'RECIBO = null ' +
                  'where REGISTRO = ' + QuotedStr(sRegistro);
                try
                  IBQSALVA.ExecSQL;
                  IBQSALVA.Transaction.Commit;
                except
                  IBQSALVA.Transaction.Rollback;
                end;

              end;

              if bLimparXMLResposta then
              begin
                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'update BLOCOX set ' +
                  'XMLRESPOSTA = null ' +
                  'where REGISTRO = ' + QuotedStr(sRegistro);
                try
                  IBQSALVA.ExecSQL;
                  IBQSALVA.Transaction.Commit;
                except
                  IBQSALVA.Transaction.Rollback;
                end;

              end;

            end; // if sRegistro <> '' then

          end; // if IBQREDUCAO.FieldByName('DATA').AsString <> '' then
        finally

          if sLogRZ <> '' then
          begin
            try
              sLogRZ := '                  **************** Arquivo gerado com inconsistência ******************' + #13 + #10 + #13 + #10 +
                'Redução Z ECF ' + Copy(SerieECF, 1, 20) + ' ' + IBQREDUCAO.FieldByName('DATA').AsString + #13 + #10 +
                '1 - Favor corrigir os alertas abaixo.' + #13 + #10 +
                '2 - Após acesse o Frente de Caixa e faça a transmissão dos arquivos da Redução Z' + #13 + #10 + #13 + #10 +
                'Alertas:' + #13 + #10 + sLogRZ;

              if FileExists(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + SerieECF + '_' + LimpaNumero(sDataReferencia) + '_' + FormatDateTime('yyyymmdd', Date) + '.txt')) = False then // Cria e exibe apenas 1X por dia Sandro Silva 2019-04-08
              begin

                ArquivoLogBX := TArquivo.Create;
                ArquivoLogBX.Texto := sLogRZ;
                ArquivoLogBX.SalvarArquivo(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + SerieECF + '_' + LimpaNumero(sDataReferencia) + '_' + FormatDateTime('yyyymmdd', Date) + '.txt');
                Sleep(100);
                FreeAndNil(ArquivoLogBX);

                ChDir(Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-04-04

                if FileExists(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + SerieECF + '_' + LimpaNumero(sDataReferencia) + '_' + FormatDateTime('yyyymmdd', Date) + '.txt')) then
                begin
                  ShellExecute(Application.Handle, nil, PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + SerieECF + '_' + LimpaNumero(sDataReferencia) + '_' + FormatDateTime('yyyymmdd', Date) + '.txt'), nil, nil, SW_SHOWNORMAL);
                end;

              end;

            except

            end;
          end;

          FreeAndNil(IBQSALVA);
          FreeAndNil(IBTSALVA);

          FreeAndNil(IBQREDUCAO);
          FreeAndNil(IBQITENS);
          FreeAndNil(IBQDESCONTO);
          FreeAndNil(IBQACRESCIMO);
          FreeAndNil(IBQCUPOM);
          FreeAndNil(IBQREDUCOES);
        end;

      end;

      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'ECF', '');
      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Referencia', '');
      GravarParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Emissao', '');

      FreeAndNil(BXReducaoZ); // Sandro Silva 2019-06-19 BXReducaoZ.Free;

    end;// if IBQREDUCOES.FieldByName('REGISTRO').AsString <> '' then

    if IBQREDUCOES <> nil then
      FreeAndNil(IBQREDUCOES);

  end; //   if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06

end;

function BXGeraXmlEstoquePeriodo(Emitente: TEmitente; IBTransaction1: TIBTransaction;
  dtInicial: TDate; dtFinal: TDate;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  //t: TTime;
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  //IBQDEMAIS: TIBQuery;
  IBQESTOQUE: TIBQuery;
  IBQVENDAS: TIBQuery;
  IBQCOMPRAS: TIBQuery;
  IBQFABRICA: TIBQuery;
  IBQBALCAO: TIBQuery;
  IBQRESERVA: TIBQuery;
  IBQAQUISICAO: TIBQuery; // Sandro Silva 2017-08-03
  IBQREDUCOES: TIBQuery; // Sandro Silva 2019-02-15
  BXEstoque: TBlocoXEstoque; // Sandro Silva 2016-02-12
  aEstoque: TEstoqueItensList; // Sandro Silva 2018-11-26
  iItens: Integer; // Sandro Silva 2018-11-16
  iPosicaoItem: Integer; // Sandro Silva 2018-11-16
  bAchou: Boolean; // Sandro Silva 2018-11-16
  sQtd: String;
  sValor: String;
  sIndArred: String;
  sST: String;
  sAliquota: String;
  sIppt: String; // Sandro Silva 2016-03-04 POLIMIG
  sSituacaoEstoque: String; // Sandro Silva 2016-03-04 POLIMIG
  dQtd: Double;
  dVenda: Double;
  dCompra: Double;
  dAltera: Double;
  dBalcao: Double;
  dRese: Double;
  CursorOld: TCursor;
  sRegistro: String;
  sArquivoXML: String;
  sUnidade: String; // Sandro Silva 2017-06-26
  sCodigoGTIN: String; // Sandro Silva 2017-08-02
  sCodigoCEST: String; // Sandro Silva 2017-08-02
  sCodigoNCMSH: String; // Sandro Silva 2017-08-02
  sQuantidadeTotalAquisicao: String; // Sandro Silva 2017-08-03
  sValorTotalAquisicao: String; // Sandro Silva 2017-08-03
  sValorTotalICMSDebitoFornecedor: String; // Sandro Silva 2017-08-03
  sValorBaseCalculoICMSST: String; // Sandro Silva 2017-08-03
  sValorTotalICMSST: String; // Sandro Silva 2017-08-03
  dtDataHora: TDate;
  sCodigoInternoDuplicado: String; // Sandro Silva 2018-11-23
  sCodigoGTINDuplicado: String; // Sandro Silva 2018-11-23
  slLog: TStringList; // Sandro Silva 2021-02-11
  sFiltroTipo_Item: String; // Sandro Silva 2020-06-17
  function SQL_Where_NF_Transmitida_Impressa(sAlias: String): String;
  {Sandro Silva 2013-12-03 inicio
  Retorna condição para where selecionar apenas NFe emitidas e transmitidas
  PAF-ECF ER 2.01}
  begin
    if Trim(sAlias) <> '' then
      sAlias := sAlias + '.';
    Result := '( ((' + sAlias + 'MODELO = ''55'' or ' + sAlias + 'MODELO = ''57'') and upper(coalesce(' + sAlias + 'EMITIDA, '''')) in (''S'', ''X'')) ' +
            ' or (((' + sAlias + 'MODELO <> ''55'' and ' + sAlias + 'MODELO <> ''57'') and  upper(coalesce(' + sAlias + 'EMITIDA, '''')) in (''J'', ''S'', ''X'') ))) ';
  end;

  function SelectProdutosNFSaida(dtInventario: TDate; sProdutoCodigo: String; sFiltro: String = ''): String;
  var
    sFiltroProduto: String;
  begin
    if sProdutoCodigo <> '' then
      sFiltroProduto := ' and ITENS001.CODIGO = ' + QuotedStr(sProdutoCodigo) + ' ';

    Result := 'select ITENS001.CODIGO, sum(ITENS001.QUANTIDADE) as vQTD_VENDA ' + // Sandro Silva 2018-12-14 'select ITENS001.CODIGO, ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE) as vQTD_VENDA ' +
      'from ITENS001, VENDAS ' +
      'where VENDAS.EMISSAO > ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInventario)) +
      ' and VENDAS.NUMERONF = ITENS001.NUMERONF ' +
      ' and ' + SQL_Where_NF_Transmitida_Impressa('VENDAS') + // 2013-12-03 ER 2.01
      sFiltroProduto +
      sFiltro + // 2014-04-29 Para filtrar saídas que não movimentas o estoque (Remessa para transporte)
      ' group by ITENS001.CODIGO ' + // Sandro Silva 2018-12-14 ' group by ITENS001.CODIGO, ITENS001.DESCRICAO ' +
      ' order by CODIGO';
  end;

  function SelectProdutosNFEntrada(dtInventario: TDate; sProdutoCodigo: String; sFiltro: String = ''): String;
  var
    sFiltroProduto: String;
  begin
    if sProdutoCodigo <> '' then
      sFiltroProduto := ' and ITENS002.CODIGO = ' + QuotedStr(sProdutoCodigo) + ' ';

    Result := 'select ITENS002.CODIGO, sum(ITENS002.QUANTIDADE) as vQTD_COMPRA ' + // Sandro Silva 2018-12-14 'select ITENS002.CODIGO, ITENS002.DESCRICAO, sum(ITENS002.QUANTIDADE) as vQTD_COMPRA ' +
      'from ITENS002, COMPRAS ' +
      'where COMPRAS.EMISSAO > ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInventario)) +
      ' and COMPRAS.NUMERONF = ITENS002.NUMERONF ' +
      ' and COMPRAS.FORNECEDOR = ITENS002.FORNECEDOR ' +
      sFiltroProduto +
      sFiltro +
      ' group by ITENS002.CODIGO ' + // Sandro Silva 2018-12-14 ' group by ITENS002.CODIGO, ITENS002.DESCRICAO ' +
      ' order by CODIGO';
  end;

  function SelectAlteraProdutosAlteraca(dtInventario: TDate; sProdutoCodigo: String): String;
  var
    sFiltroProduto: String;
  begin
    if sProdutoCodigo <> '' then
      sFiltroProduto := ' and ALTERACA.CODIGO = ' + QuotedStr(sProdutoCodigo) + ' ';

    Result := 'select ALTERACA.CODIGO, sum(ALTERACA.QUANTIDADE) as vQTD_ALTERA ' + // Sandro Silva 2018-12-14 'select ALTERACA.CODIGO, ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE) as vQTD_ALTERA ' +
      'from ALTERACA ' +
      'where ALTERACA.DATA > ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInventario)) +
      ' and TIPO <> ' + QuotedStr('BALCAO') + ' and TIPO <> ' + QuotedStr('CANCEL') +
      ' and TIPO <> ' + QuotedStr('VENDA') + // 2013-01-28
      sFiltroProduto +
      ' group by ALTERACA.CODIGO ' + // Sandro Silva 2018-12-14 ' group by ALTERACA.CODIGO, ALTERACA.DESCRICAO ' +
      ' order by CODIGO';
  end;

  function SelectVendaProdutosAlteraca(dtInventario: TDate; sProdutoCodigo: String): String;
  var
    sFiltroProduto: String;
  begin
    if sProdutoCodigo <> '' then
      sFiltroProduto := ' and ALTERACA.CODIGO = ' + QuotedStr(sProdutoCodigo) + ' ';

    Result := 'select ALTERACA.CODIGO, sum(ALTERACA.QUANTIDADE) as vQTD_BALCAO ' + // Sandro Silva 2018-12-14 'select ALTERACA.CODIGO, ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE) as vQTD_BALCAO ' +
      'from ALTERACA ' +
      'where ALTERACA.DATA > ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInventario)) +
      ' and (TIPO = ' + QuotedStr('BALCAO') + ' or TIPO = ' + QuotedStr('VENDA') + ') ' +
      ' and DESCRICAO <> ''<CANCELADO>'' ' + //2015-10-07 Alceu Foppa Junior Desconsidera itens cancelados
      ' and coalesce(ALTERACA.VALORICM, 0) = 0 ' +  // desconsiderar cupons importados para NF
      sFiltroProduto +
      ' group by ALTERACA.CODIGO ' + // Sandro Silva 2018-12-14 ' group by ALTERACA.CODIGO, ALTERACA.DESCRICAO ' +
      ' order by CODIGO';
  end;

  function SelectReservaProdutosOS(dtInventario: TDate; sProdutoCodigo: String): String;
  var
    sFiltroProduto: String;
  begin
    if sProdutoCodigo <> '' then
      sFiltroProduto := ' and ITENS001.CODIGO = ' + QuotedStr(sProdutoCodigo) + ' ';

    Result := 'select ITENS001.CODIGO, sum(ITENS001.QUANTIDADE) as vQTD_RESE ' + // Sandro Silva 2018-12-14 'select ITENS001.CODIGO, ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE) as vQTD_RESE ' +
      'from ITENS001, OS ' +
      'where OS.DATA > ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtInventario)) +
      ' and (coalesce(ITENS001.NUMERONF, ' + QuotedStr('') + ') = ' + QuotedStr('') + ') ' +
      ' and OS.NUMERO=ITENS001.NUMEROOS ' +
      ' and coalesce(ITENS001.SINCRONIA, 0) = ITENS001.QUANTIDADE ' + // 2014-01-07 Para S09 que não da mais baixa do estoque se ter documento emitido
      ' and ITENS001.DESCRICAO is not null ' +
      sFiltroProduto +
      ' group by ITENS001.CODIGO ' + // Sandro Silva 2018-12-14 ' group by ITENS001.CODIGO, ITENS001.DESCRICAO ' +
      ' order by CODIGO';
  end;

  {Sandro Silva 2016-03-04 POLIMIG inicio Seleciona alíquota do produto}
  function AliquotaProduto(sST: String; sUF: String): String;
  var
    sSituacaoTributaria: String;
    IBQICM: TIBQuery;
  begin
    Result := '';
    IBQICM := CriaIBQuery(IBTransaction1);
    IBQICM.BufferChunks := 10; // Sandro Silva 2018-12-14
    IBQICM.UniDirectional := True;
    IBQICM.Close;
    IBQICM.SQL.Text :=
      'select * ' +
      'from ICM ' +
      'where ST = ' + QuotedStr(sST);
    IBQICM.Open;

    IBQICM.DisableControls;// Sandro Silva 2018-12-14

    if AllTrim(sST) <> '' then // Se o ST não estiver em branco   //
    begin                                    // Procurar na tabela de ICM para  //
      IBQICM.First;                         // saber qual a aliquota associada //
      while not IBQICM.EOF do
      begin
        if IBQICM.FieldByName('ST').AsString = sST then  // Pode ocorrer um erro    //
        begin                                           // se o estado do emitente //
          try                                             // Não estiver cadastrado  //
            if IBQICM.FieldByName('ISS').AsFloat > 0 then
            begin
              Result := StrZero(IBQICM.FieldByName('ISS').AsFloat * 100,4,0);
              sSituacaoTributaria := 'S';
            end else
            begin
              Result := StrZero( (IBQICM.FieldByName(sUF+'_').AsFloat * 100) / 100 * IBQICM.FieldByName('BASE').AsFloat,4,0);
              sSituacaoTributaria := 'T';
            end;
          except Result  := '' end;
        end;
        IBQICM.Next;
      end;
    end else sSituacaoTributaria := 'T';

    if Result = '' then // Se o Result continuar em branco é porque não estava cadastrado //
    begin            // na tabela de ICM ou estava em branco                        //

      IBQICM.Close;
      IBQICM.SQL.Text :=
        'select * ' +
        'from ICM ' +
        'where (CFOP = ''5102'' or CFOP = ''6102'') ';
      IBQICM.Open;

      IBQICM.DisableControls; // Sandro Silva 2018-12-14

      IBQICM.First;
      while not IBQICM.EOF do  // Procura pela operação padrão venda À vista ou //
      begin                     // venda a prazo 512 ou 612 ou 5102 ou 6102      //
        if (AllTrim(IBQICM.FieldByName('CFOP').AsString) = '5102') or (AllTrim(IBQICM.FieldByName('CFOP').AsString) = '6102') then
        begin
          try
            Result := StrZero( (IBQICM.FieldByName(sUF+'_').AsFloat * 100) / 100 * IBQICM.FieldByName('BASE').AsFloat ,4,0);
          except Result  := '' end;
        end;
        IBQICM.Next;
      end;
    end;

    IBQICM.Close; // Sandro Silva 2018-11-27

    if Copy(allTrim(sST),1,1) = 'I' then sSituacaoTributaria := 'I' else
      if Copy(allTrim(sST),1,1) = 'F' then sSituacaoTributaria := 'F' else
        if Copy(allTrim(sST),1,1) = 'N' then sSituacaoTributaria := 'N';

    if (sSituacaoTributaria = 'I') or (sSituacaoTributaria = 'F') or (sSituacaoTributaria = 'N') then
      Result := '0000';
    FreeAndNil(IBQICM);
  end;
begin
  //t := Time;
  if CNAEDispensadoEnvioEstoque then // Sandro Silva 2020-08-05
  begin
    GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Referencia', '');
    GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', '');

    Result := True;

    LogFrente('CNAE dispensado envio do ESTOQUE ' + FormatDateTime('dd/mm/yyyy', dtFinal), Emitente.Configuracao.DiretorioAtual);    
  end
  else
  begin

    if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06
    begin

      Result := False;

      slLog := TStringList.Create;// Sandro Silva 2021-02-11

      CursorOld     := Screen.Cursor;
      Screen.Cursor := crHourGlass;

      IBTSALVA    := CriaIBTransaction(IBTransaction1.DefaultDatabase);// CriaIBTransaction(IBDATABASE);
      IBQSALVA    := CriaIBQuery(IBTSALVA);

      IBQESTOQUE   := CriaIBQuery(IBTransaction1);
      IBQESTOQUE.UniDirectional := True; // Apenas query do ESTOQUE, nas outras o ponteiro é movimentado bidirecional Sandro Silva 2018-11-23
      IBQVENDAS    := CriaIBQuery(IBTransaction1);
      IBQCOMPRAS   := CriaIBQuery(IBTransaction1);
      IBQFABRICA   := CriaIBQuery(IBTransaction1);
      IBQBALCAO    := CriaIBQuery(IBTransaction1);
      IBQRESERVA   := CriaIBQuery(IBTransaction1);
      IBQAQUISICAO := CriaIBQuery(IBTransaction1);
      IBQREDUCOES  := CriaIBQuery(IBTransaction1);// Sandro Silva 2019-02-15

      // Otimizar
      IBQESTOQUE.DisableControls;
      IBQVENDAS.DisableControls;
      IBQCOMPRAS.DisableControls;
      IBQFABRICA.DisableControls;
      IBQBALCAO.DisableControls;
      IBQRESERVA.DisableControls;
      IBQAQUISICAO.DisableControls;
      IBQREDUCOES.DisableControls; // Sandro Silva 2019-02-15

      IBQVENDAS.BufferChunks    := 10;
      IBQCOMPRAS.BufferChunks   := 10;
      IBQFABRICA.BufferChunks   := 10;
      IBQBALCAO.BufferChunks    := 10;
      IBQRESERVA.BufferChunks   := 10;
      IBQAQUISICAO.BufferChunks := 10;
      IBQREDUCOES.BufferChunks  := 10; // Sandro Silva 2019-02-15

      IBQVENDAS.UniDirectional    := True;
      IBQCOMPRAS.UniDirectional   := True;
      IBQFABRICA.UniDirectional   := True;
      IBQBALCAO.UniDirectional    := True;
      IBQRESERVA.UniDirectional   := True;
      IBQAQUISICAO.UniDirectional := True;
      IBQREDUCOES.UniDirectional  := True; // Sandro Silva 2019-02-15

      BXEstoque  := TBlocoXEstoque.Create(nil);

      aEstoque := TEstoqueItensList.Create();

      IBQESTOQUE.Close;
      IBQESTOQUE.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        'where TIPO = ''ESTOQUE'' ' +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtFinal)) +
        ' order by DATAHORA';
      IBQESTOQUE.Open;
      //nao salvou a data do estoque gerado

      if bForcarGeracao then
        dtDataHora := IBQESTOQUE.FieldByName('DATAHORA').AsDateTime
      else
        dtDataHora := Now;

      if bForcarGeracao and (dtDataHora = 0) then
      begin
        IBQREDUCOES.Close;
        IBQREDUCOES.SQL.Text :=
          'select DATA, HORA '  +
          'from REDUCOES ' +
          'where DATA > ' + QuotedStr(FormatDateTime('YYYY-MM-DD', dtFinal)) +
          ' order by DATA ';
        IBQREDUCOES.Open;
        if IBQREDUCOES.FieldByName('DATA').AsString = '' then
          dtDataHora := Now
        else
          dtDataHora := StrToDateTime(IBQREDUCOES.FieldByName('DATA').AsString + ' ' + IBQREDUCOES.FieldByName('HORA').AsString);
      end;

      if LerParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', '') <> '' then
        dtDataHora := StrToDateTime(LerParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', FormatDateTime('dd/mm/yyyy HH:nn:ss', dtDataHora)));// Recupera a data e hora salva no ini quando não consegue completar a geração
      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Referencia', FormatDateTime('dd/mm/yyy', dtFinal));
      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', FormatDateTime('dd/mm/yyyy HH:nn:ss', dtDataHora));

      //ShowMessage('Teste 01 Marcou início geração xml estoque ' + DateTimeToStr(dtFinal)); // Sandro Silva 2019-02-15

      if (IBQESTOQUE.FieldByName('DATAHORA').AsString = '') or (bForcarGeracao) then
      begin
        {
        //2. O Arquivo com Informações do Estoque Mensal do Estabelecimento deve ser gerado até o 5º dia de movimento do mês seguinte a que se refere,
        // quando o PAF-ECF comandar a emissão do primeiro documento Redução Z do dia.
        }
        if BXPermiteGerarXmlEstoque or bForcarGeracao then
        begin

          BXEstoque.UF := Emitente.UF; // Sandro Silva 2018-09-21 IBQEMITENTE.FieldByName('ESTADO').AsString;
          BXEstoque.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', ''); // 'CN=SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI:07426598000124, OU=Autenticado por AR EXXA, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, L=CONCORDIA, S=SC, O=ICP-Brasil, C=BR';

          if (LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado','') = '') and (BXEstoque.CertificadoSubjectName <> '') then // Sandro Silva 2016-03-05 POLIMIG
            GravarParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', BXEstoque.CertificadoSubjectName);

          try

            sFiltroTipo_Item := ' and coalesce(TIPO_ITEM, '''') <>  ' + QuotedStr(TIPO_ITEM_COD_MATERIAL_DE_USO_E_CONSUMO) + ' ';// Ficha 5012 Sandro Silva 2020-06-17

            //Identifica os ESTOQUE.CODIGO duplicados e concatena na string para depois validar na geração do xml
            IBQESTOQUE.Close;
            IBQESTOQUE.SQL.Text :=
              'select CODIGO, count(CODIGO) ' +
              'from ESTOQUE ' +
              'where coalesce(CODIGO, '''') <> '''' ' +
              sFiltroTipo_Item +  // Sandro Silva 2020-06-17
              ' group by CODIGO ' +
              'having count(CODIGO) > 1';
            IBQESTOQUE.Open;
            IBQESTOQUE.DisableControls; // Sandro Silva 2018-12-14

            while IBQESTOQUE.Eof = False do
            begin
              sCodigoInternoDuplicado := sCodigoInternoDuplicado + '|' + IBQESTOQUE.FieldByName('CODIGO').AsString + '|';
              IBQESTOQUE.Next;
            end;

            //Identifica os ESTOQUE.REFERENCIA duplicados e concatena na string para depois validar na geração do xml
            IBQESTOQUE.Close;
            IBQESTOQUE.SQL.Text :=
              'select REFERENCIA, count(REFERENCIA) ' +
              'from ESTOQUE ' +
              'where coalesce(REFERENCIA, '''') <> '''' ' +
              sFiltroTipo_Item +  // Sandro Silva 2020-06-17
              ' group by REFERENCIA ' +
              'having count(REFERENCIA) > 1';
            IBQESTOQUE.Open;

            IBQESTOQUE.DisableControls; // Sandro Silva 2018-12-14

            while IBQESTOQUE.Eof = False do
            begin
              sCodigoGTIN  := ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('REFERENCIA').AsString));
              if ValidaEAN13(LimpaNumero(sCodigoGTIN)) = False then
                sCodigoGTIN := ''
              else
                sCodigoGTIN := LimpaNumero(sCodigoGTIN);

              if sCodigoGTIN <> '' then
                sCodigoGTINDuplicado := sCodigoGTINDuplicado + '|' + sCodigoGTIN + '|';
              IBQESTOQUE.Next;
            end;

            IBQESTOQUE.Close;
            IBQESTOQUE.SQL.Text :=
              'select DESCRICAO, CODIGO, QTD_ATUAL, ST, IAT, IPPT, TIPO_ITEM ' + // Sandro Silva 2019-03-07 'select DESCRICAO, CODIGO, QTD_ATUAL, PRECO, ST, IAT, IPPT, TIPO_ITEM ' +
              ', case when coalesce(trim(MEDIDA), '''') = '''' then ''UN'' ' +
                  'else trim(MEDIDA) ' +
                'end as MEDIDA ' +
              ', REFERENCIA, CEST, CF as NCM ' +// Sandro Silva 2017-08-02
              ', CUSTOCOMPR ' + // Sandro Silva 2019-03-07
              'from ESTOQUE ' +
              'where coalesce(trim(DESCRICAO), '''') <> '''' ' +
              sFiltroTipo_Item +  // Sandro Silva 2020-06-17
              ' order by CODIGO';
            IBQESTOQUE.Open;

            IBQESTOQUE.DisableControls; // Sandro Silva 2018-12-14
    //ShowMessage('Estoque 1427'); // Sandro Silva 2018-09-17

            BXEstoque.XML :=
            BLOCOX_ESPECIFICACAO_XML + // Sandro Silva 2017-04-28  '<?xml version="1.0" encoding="utf-8" ?>' +
            '<Estoque Versao="' + BLOCOX_VERSAO_LEIAUTE + '">' + // Sandro Silva 2017-04-28  '<Estoque Versao="1.0">' +
              '<Mensagem>' +
                BXCabecalhoXml(Emitente.IE, Credenciamento(FormataCpfCgc(Emitente.CNPJ))) + // Sandro Silva 2018-09-21 BlocoXCabecalhoXml(IBQEMITENTE.FieldByName('IE').AsString, Credenciamento(IBQEMITENTE.FieldByName('CGC').AsString)) +
                '<DadosEstoque>' +
                  '<DataReferencia>' + FormatDateTime('yyyy-mm-dd', dtFinal) + '</DataReferencia>' + // Sandro Silva 2017-08-02 Data de referência do Estoque. Será sempre o último dia de cada mês.
                  '<Produtos>';

                    while IBQESTOQUE.Eof = False do
                    begin

                      // Venda nf
                      IBQVENDAS.Close;
                      IBQVENDAS.SQL.Clear;
                      IBQVENDAS.SQL.Text := SelectProdutosNFSaida(dtFinal, IBQESTOQUE.FieldByName('CODIGO').AsString, ' and ITENS001.QUANTIDADE = ITENS001.SINCRONIA and VENDAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%''))');
                      IBQVENDAS.Open;
                      {Sandro Silva 2018-11-27 fim}

                      IBQVENDAS.DisableControls;
                      dVenda := IBQVENDAS.FieldByName('vQTD_VENDA').AsFloat;

                      IBQVENDAS.Close; // Sandro Silva 2018-11-27

                      // Compra
                      IBQCOMPRAS.Close;
                      IBQCOMPRAS.SQL.Clear;
                      IBQCOMPRAS.SQL.Text := SelectProdutosNFEntrada(dtFinal, IBQESTOQUE.FieldByName('CODIGO').AsString, ' and ITENS002.QUANTIDADE = ITENS002.SINCRONIA and COMPRAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%''))');
                      IBQCOMPRAS.Open;

                      IBQCOMPRAS.DisableControls;
                      dCompra := IBQCOMPRAS.FieldByName('vQTD_COMPRA').AsFloat;
                      IBQCOMPRAS.Close; // Sandro Silva 2018-11-27

                      // Alteração ficha produto, fabricação composto
                      IBQFABRICA.Close;
                      IBQFABRICA.SQL.Clear;
                      IBQFABRICA.SQL.Text := SelectAlteraProdutosAlteraca(dtFinal, IBQESTOQUE.FieldByName('CODIGO').AsString);
                      IBQFABRICA.Open;

                      IBQFABRICA.DisableControls;
                      dAltera := IBQFABRICA.FieldByName('vQTD_ALTERA').AsFloat;

                      IBQFABRICA.Close; // Sandro Silva 2018-11-27

                      // Venda cupom e nf consumidor (C300)
                      IBQBALCAO.Close;
                      IBQBALCAO.SQL.Clear;
                      IBQBALCAO.SQL.Text := SelectVendaProdutosAlteraca(dtFinal, IBQESTOQUE.FieldByName('CODIGO').AsString);
                      IBQBALCAO.Open;
                      {Sandro Silva 2018-11-27 fim}
                      IBQBALCAO.DisableControls;
                      dBalcao := IBQBALCAO.FieldByName('vQTD_BALCAO').AsFloat;
                      IBQBALCAO.Close; // Sandro Silva 2018-11-27

                      // Reserva O.S. que ainda não foram vendidas
                      IBQRESERVA.Close;
                      IBQRESERVA.SQL.Clear;
                      IBQRESERVA.SQL.Text := SelectReservaProdutosOS(dtFinal, IBQESTOQUE.FieldByName('CODIGO').AsString);
                      IBQRESERVA.Open;

                      IBQRESERVA.DisableControls;
                      dRese := IBQRESERVA.FieldByName('vQTD_RESE').AsFloat;
                      IBQRESERVA.Close;

                      //
                      dQtd := IBQESTOQUE.FieldByName('QTD_ATUAL').AsFloat
                         - dCompra
                         + dVenda
                         + dBalcao
                         + dRese
                         - dAltera;

                      sQtd := '0,000'; // Sandro Silva 2017-03-15 '0,00'
                      if dQtd > 0 then
                      begin
                        sQtd := FormatFloat('0.000', dQtd); // Sandro Silva 2017-03-15
                      end;

                      try

                        // Compras no período
                        IBQAQUISICAO.Close;
                        IBQAQUISICAO.SQL.Clear;
                        IBQAQUISICAO.SQL.Text :=
                          'select ITENS002.CODIGO, sum(ITENS002.QUANTIDADE) as QTDCOMPRA ' +
                          ', sum(ITENS002.QUANTIDADE * ITENS002.UNITARIO) as VALORTOTALAQUISICAO ' +
                          ', sum(coalesce(ITENS002.VICMS, 0)) as VALORTOTALICMSDEBITOFORNECEDOR ' +
                          ', sum(coalesce(ITENS002.VBCST, 0)) as VALORBASECALCULOICMSST ' +
                          ', sum(coalesce(ITENS002.VICMSST, 0)) as VALORTOTALICMSST ' +
                          'from COMPRAS ' +
                          'join ITENS002 on COMPRAS.NUMERONF = ITENS002.NUMERONF and COMPRAS.FORNECEDOR = ITENS002.FORNECEDOR ' +
                          'where COMPRAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy', dtFinal) + '-01-01') +  ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtFinal)) +
                          ' and ITENS002.CODIGO = ' + QuotedStr(IBQESTOQUE.FieldByName('CODIGO').AsString) +
                          ' and ITENS002.QUANTIDADE = ITENS002.SINCRONIA and COMPRAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%''))' +
                          ' group by ITENS002.CODIGO ' +
                          ' order by CODIGO';
                        IBQAQUISICAO.Open;
                        IBQAQUISICAO.DisableControls; // Sandro Silva 2018-12-14

                        sQuantidadeTotalAquisicao       := FormatFloat('0.000', IBQAQUISICAO.FieldByName('QTDCOMPRA').AsFloat); // Sandro Silva 2017-08-03
                        sValorTotalAquisicao            := FormatFloat('0.00', IBQAQUISICAO.FieldByName('VALORTOTALAQUISICAO').AsFloat); // Sandro Silva 2017-08-03
                        sValorTotalICMSDebitoFornecedor := FormatFloat('0.00', IBQAQUISICAO.FieldByName('VALORTOTALICMSDEBITOFORNECEDOR').AsFloat); // Sandro Silva 2017-08-03
                        sValorBaseCalculoICMSST         := FormatFloat('0.00', IBQAQUISICAO.FieldByName('VALORBASECALCULOICMSST').AsFloat); // Sandro Silva 2017-08-03
                        sValorTotalICMSST               := FormatFloat('0.00', IBQAQUISICAO.FieldByName('VALORTOTALICMSST').AsFloat); // Sandro Silva 2017-08-03

                        IBQAQUISICAO.Close; // Sandro Silva 2018-11-26

                        sValor := FormatFloat('0.000', IBQESTOQUE.FieldByName('CUSTOCOMPR').AsFloat); // Sandro Silva 2019-03-07 sValor := FormatFloat('0.000', IBQESTOQUE.FieldByName('PRECO').AsFloat);  // Sandro Silva 2017-11-29 Polimig  sValor := FormatFloat('0.00', IBQESTOQUE.FieldByName('PRECO').AsFloat);

                        sST := 'T';
                        if (Copy(IBQESTOQUE.FieldByName('TIPO_ITEM').AsString, 1, 2) = '09') then // Sandro Silva 2018-11-16 if (Copy(IBQESTOQUE.FieldByName('TIPO_ITEM').AsString, 1, 1) = '09') then
                          sST := 'S';

                        if (Copy(IBQESTOQUE.FieldByName('ST').AsString, 1, 1) = 'I')
                          or (Copy(IBQESTOQUE.FieldByName('ST').AsString, 1, 1) = 'F')
                          or (Copy(IBQESTOQUE.FieldByName('ST').AsString, 1, 1) = 'N') then
                          sST := Copy(IBQESTOQUE.FieldByName('ST').AsString, 1, 1);

                        if sST = 'I' then
                          sST := SITUACAO_TRIBUTARIA_ISENTO;
                        if sST = 'N' then
                          sST := SITUACAO_TRIBUTARIA_NAO_TRIBUTADO;
                        if sST = 'F' then
                          sST := SITUACAO_TRIBUTARIA_SUBSTITUICAO_TRIBUTARIA;
                        if sST = 'T' then
                          sST := SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ICMS;
                        if sST = 'S' then
                          sST := SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ISSQN;

                        sAliquota := AliquotaProduto(IBQESTOQUE.FieldByName('ST').AsString, Emitente.UF);
                        if sAliquota <> '' then
                          sAliquota := FormatFloat('0.00', StrToFloat(sAliquota) / 100)
                        else
                          sAliquota := '0,00';

                        if (sST <> SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ICMS)
                          and (sST <> SITUACAO_TRIBUTARIA_TRIBUTADO_PELO_ISSQN) then
                          sAliquota := '';

                        sAliquota := Trim(sAliquota); // Sandro Silva 2017-09-26

                        sIndArred := 'false';
                        if AnsiUpperCase(AllTrim(IBQESTOQUE.FieldByName('IAT').AsString)) = 'A' then // Sandro Silva 2017-12-27 Polimig  if sValor <> IBQESTOQUE.FieldByName('PRECO').AsString then
                          sIndArred := 'true';

                        if Copy(Trim(IBQESTOQUE.FieldByName('IPPT').AsString) + 'P', 1, 1) = 'P' then
                          sIppt := 'Proprio'
                        else
                          sIppt := 'Terceiros';

                        sSituacaoEstoque := 'Positivo';
                        if StrToFloatDef(sQtd, 0) < 0 then
                          sSituacaoEstoque := 'Negativo';

                        sUnidade := Trim(ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('MEDIDA').AsString)));
                        if sUnidade = '' then
                          sUnidade := 'UND';

                        sCodigoGTIN  := ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('REFERENCIA').AsString));
                        if ValidaEAN13(LimpaNumero(sCodigoGTIN)) = False then
                          sCodigoGTIN := ''
                        else
                          sCodigoGTIN := LimpaNumero(sCodigoGTIN);
                        sCodigoCEST  := ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('CEST').AsString)); // Sandro Silva 2018-08-20  Trim(IBQESTOQUE.FieldByName('CEST').AsString);

                        if (sST <> SITUACAO_TRIBUTARIA_SUBSTITUICAO_TRIBUTARIA) and (Trim(sCodigoCEST) <> '') then // Regra 4015 - Verifica se o código CEST foi preenchido quando o produto não está sob substituição tributária
                        begin
                          sCodigoCEST := '';
                        end;
                        if (sST = SITUACAO_TRIBUTARIA_SUBSTITUICAO_TRIBUTARIA) and (Trim(sCodigoCEST) = '') then // Regra 4014 - Verifica se o código CEST foi informado quando o produto está sob substituição tributária
                        begin
                          if StrToFloatDef(sQtd, 0) > 0 then // Sandro Silva 2021-02-11
                          begin
                            // Sandro Silva 2021-02-11 ConcatenaLogXml(sLog, '- Configurar CEST no cadastro do Produto: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + ' ' + IBQESTOQUE.FieldByName('DESCRICAO').AsString);
                            slLog.Add('- Configurar CEST no cadastro do Produto: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + ' ' + IBQESTOQUE.FieldByName('DESCRICAO').AsString);
                          end;
                        end;

                        sCodigoNCMSH := ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('NCM').AsString)); // Sandro Silva 2018-08-20 Trim(IBQESTOQUE.FieldByName('NCM').AsString);
                        if sCodigoNCMSH = '' then
                          sCodigoNCMSH := '00';

                        if (Trim(ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('DESCRICAO').AsString))) <> '')
                          and (Trim(IBQESTOQUE.FieldByName('CODIGO').AsString) <> '') then
                        begin

                          bAchou := False;
                          iPosicaoItem := -1;

                          if (Pos('|' + IBQESTOQUE.FieldByName('CODIGO').AsString + '|', sCodigoInternoDuplicado) > 0)
                            or (Pos('|' + sCodigoGTIN + '|', sCodigoGTINDuplicado) > 0) then
                          begin

                            for iItens := 0 to aEstoque.Count -1 do
                            begin
                              if ((sCodigoGTIN <> '') and (aEstoque.Items[iItens].CodigoGTIN = sCodigoGTIN)) // Tem gtin e o gtin já está em outro produto
                                or (aEstoque.Items[iItens].CodigoProprio = Trim(IBQESTOQUE.FieldByName('CODIGO').AsString)) // Código interno repetido em outro produto
                               then
                              begin
                                bAchou := True;
                                iPosicaoItem := iItens;
                                Break;
                              end;
                            end;
                          end;

                          if bAchou = False then
                          begin
                            aEstoque.Adiciona(sCodigoNCMSH, sQtd, sUnidade, Trim(IBQESTOQUE.FieldByName('CODIGO').AsString), sCodigoCEST,
                              sST, sIndArred, sQuantidadeTotalAquisicao, sCodigoGTIN, sValorBaseCalculoICMSST, ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('DESCRICAO').AsString)),
                              sValor, sSituacaoEstoque, sValorTotalAquisicao, sValorTotalICMSST, sValorTotalICMSDebitoFornecedor, sAliquota, sIppt);
                          end
                          else
                          begin
                            aEstoque.Items[iPosicaoItem].Quantidade                     := FormatFloat('0.000', StrToFloatDef(aEstoque.Items[iPosicaoItem].Quantidade, 0) + StrToFloatDef(sQtd, 0));
                            aEstoque.Items[iPosicaoItem].QuantidadeTotalAquisicao       := FormatFloat('0.000', StrToFloatDef(aEstoque.Items[iPosicaoItem].QuantidadeTotalAquisicao, 0) + StrToFloatDef(sQuantidadeTotalAquisicao, 0));
                            aEstoque.Items[iPosicaoItem].ValorUnitario                  := FormatFloat('0.000', StrToFloatDef(aEstoque.Items[iPosicaoItem].ValorUnitario, 0) + StrToFloatDef(sValor, 0));
                            aEstoque.Items[iPosicaoItem].ValorTotalAquisicao            := FormatFloat('0.00', StrToFloatDef(aEstoque.Items[iPosicaoItem].ValorTotalAquisicao, 0) + StrToFloatDef(sValorTotalAquisicao, 0));
                            aEstoque.Items[iPosicaoItem].ValorTotalICMSDebitoFornecedor := FormatFloat('0.00', StrToFloatDef(aEstoque.Items[iPosicaoItem].ValorTotalICMSDebitoFornecedor, 0) + StrToFloatDef(sValorTotalICMSDebitoFornecedor, 0));
                            aEstoque.Items[iPosicaoItem].ValorBaseCalculoICMSST         := FormatFloat('0.00', StrToFloatDef(aEstoque.Items[iPosicaoItem].ValorBaseCalculoICMSST, 0) + StrToFloatDef(sValorBaseCalculoICMSST, 0));
                            aEstoque.Items[iPosicaoItem].ValorTotalICMSST               := FormatFloat('0.00', StrToFloatDef(aEstoque.Items[iPosicaoItem].ValorTotalICMSST, 0) + StrToFloatDef(sValorTotalICMSST, 0));
                          end;

                        end;
                      except
                        on E: Exception do
                        begin
  //  ShowMessage('1629 Código ' + IBQESTOQUE.FieldByName('CODIGO').AsString + #13 + E.Message); // Sandro Silva 2018-09-17
                        end;
                      end;

                      IBQESTOQUE.Next;
                    end;

                    sCodigoInternoDuplicado := ''; // Sandro Silva 2018-11-26
                    sCodigoGTINDuplicado := ''; // Sandro Silva 2018-11-26

                    //ShowMessage('Teste 01 2122');  // Sandro Silva 2018-11-23

                    // Fecha as querys que não são mais usadas
                    IBQVENDAS.Close;
                    IBQCOMPRAS.Close;
                    IBQFABRICA.Close;
                    IBQBALCAO.Close;
                    IBQRESERVA.Close;

                    for iItens := 0 to aEstoque.Count -1 do
                    begin

                      try

                        if (StrToFloatDef(aEstoque.Items[iItens].Quantidade, 0) > 0) or (StrToFloatDef(aEstoque.Items[iItens].QuantidadeTotalAquisicao, 0) > 0) or (AnsiContainsText(aEstoque.Items[iItens].SituacaoTributaria, 'ISSQN')) then
                        begin
                          // Ficha 4982
                          // Item com saldo de estoque ou com aquisição no período ou é serviço (ISSQN)
                          //Conforme resposta a questionamentos do Grupo Desenvolvedore Google feito a Sefaz
                          // 4. Produtos com quantidade zero, não necessitam mais serem informados se não possuírem movimentação de entrada no período, isso?
                          // É isso mesmo.

                          BXEstoque.XML := BXEstoque.XML +
                            '<Produto>' +
                              '<Descricao>' + aEstoque.Items[iItens].Descricao + '</Descricao>' +
                              '<CodigoGTIN>' + aEstoque.Items[iItens].CodigoGTIN + '</CodigoGTIN>' + // Sandro Silva 2017-08-02
                              '<CodigoCEST>' + aEstoque.Items[iItens].CodigoCEST + '</CodigoCEST>' + // Sandro Silva 2017-08-02
                              '<CodigoNCMSH>' + aEstoque.Items[iItens].CodigoNCMSH + '</CodigoNCMSH>' + // Sandro Silva 2017-08-02
                              '<CodigoProprio>' + aEstoque.Items[iItens].CodigoProprio + '</CodigoProprio>' +// Sandro Silva 2017-08-03  '<Codigo>' + Trim(IBQESTOQUE.FieldByName('CODIGO').AsString) + '</Codigo>' +// Sandro Silva 2016-03-04 POLIMIG
                              '<Quantidade>' + aEstoque.Items[iItens].Quantidade + '</Quantidade>' +
                              '<QuantidadeTotalAquisicao>' + aEstoque.Items[iItens].QuantidadeTotalAquisicao + '</QuantidadeTotalAquisicao>' + // Sandro Silva 2017-08-03 Quantidade total adquirida
                              '<Unidade>' + aEstoque.Items[iItens].Unidade + '</Unidade>' +// Sandro Silva 2017-06-26  '<Unidade>' + ConverteAcentos2(Trim(IBQESTOQUE.FieldByName('MEDIDA').AsString)) + '</Unidade>' +
                              '<ValorUnitario>' + aEstoque.Items[iItens].ValorUnitario + '</ValorUnitario>' +
                              '<ValorTotalAquisicao>' + aEstoque.Items[iItens].ValorTotalAquisicao + '</ValorTotalAquisicao>' + // Sandro Silva 2017-08-03 Valor total de aquisição do produto
                              '<ValorTotalICMSDebitoFornecedor>' + aEstoque.Items[iItens].ValorTotalICMSDebitoFornecedor + '</ValorTotalICMSDebitoFornecedor>' + // Sandro Silva 2017-08-03  Valor total do ICMS informado como débito da operação ou prestação praticada pelo fornecedor da mercadoria, quando for o caso
                              '<ValorBaseCalculoICMSST>' + aEstoque.Items[iItens].ValorBaseCalculoICMSST + '</ValorBaseCalculoICMSST>' + // Sandro Silva 2017-08-03 A base de cálculo do ICMS devido por substituição tributária da mercadoria, quando for o caso
                              '<ValorTotalICMSST>' + aEstoque.Items[iItens].ValorTotalICMSST + '</ValorTotalICMSST>' + // Sandro Silva 2017-08-03 O Valor total do ICMS devido por substituição tributária da mercadoria, quando for o caso
                              '<SituacaoTributaria>' + aEstoque.Items[iItens].SituacaoTributaria + '</SituacaoTributaria>' +
                              '<Aliquota>' + aEstoque.Items[iItens].Aliquota + '</Aliquota>' +
                              '<IsArredondado>' + aEstoque.Items[iItens].IsArredondado + '</IsArredondado>' + // Sandro Silva 2016-03-04 POLIMIG
                              '<Ippt>' + aEstoque.Items[iItens].Ippt + '</Ippt>' + // Sandro Silva 2016-03-04 POLIMIG
                              '<SituacaoEstoque>' + aEstoque.Items[iItens].SituacaoEstoque+ '</SituacaoEstoque>' + // Sandro Silva 2016-03-04 POLIMIG
                            '</Produto>';

                        end;

                      except
                        on E: Exception do
                        begin
                          //ShowMessage(IntToStr(iItens));
                        end;
                      end;
                    end;

                    BXEstoque.XML := BXEstoque.XML +
                  '</Produtos>' +
                '</DadosEstoque>' +
              '</Mensagem>' +
              '<Signature />' + // Precisa existir para saber onde adicionar elementos da assinatura
            '</Estoque>';

            //ShowMessage('Teste 01 2167');  // Sandro Silva 2018-11-23

            ForceDirectories(PASTA_ESTOQUE_BLOCO_X);

            LogFrente('XML do estoque gerado' + ': ' + FormatDateTime('dd/mm/yyyy', dtFinal), Emitente.Configuracao.DiretorioAtual);

  //ShowMessage(FormatDateTime('HH:nn:ss, zzz', Time - t));

            if bAssinarXML then
              BXEstoque.AssinaXML;

            //ShowMessage('Teste 01 2177');  // Sandro Silva 2018-11-23

            sRegistro := BXSalvarBancoXmlEnvio({IBDATABASE} IBTransaction1, 'ESTOQUE', '', dtDataHora, BXEstoque.XML, dtFinal);

            LogFrente(IfThen(sRegistro = '', 'XML não foi salvo no banco', 'XML salvo no banco') + ': ESTOQUE ' + FormatDateTime('dd/mm/yyyy', dtFinal), Emitente.Configuracao.DiretorioAtual);

            sArquivoXML := PASTA_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + FormatDateTime('mmyyyy', dtFinal) + '.xml';


            if BXEstoque.SalvaArquivo(sArquivoXML) then
            begin

              LogFrente('XML salvo na pasta: ESTOQUE ' + FormatDateTime('dd/mm/yyyy', dtFinal), Emitente.Configuracao.DiretorioAtual);

              SalvarHashPasta('ESTOQUE', PASTA_ESTOQUE_BLOCO_X, '*.xml');
            end;

            //ShowMessage('Teste 01 2196');  // Sandro Silva 2018-11-23

            if sRegistro <> '' then
            begin

              if bLimparRecibo then
              begin
                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'update BLOCOX set ' +
                  'RECIBO = null ' +
                  'where REGISTRO = ' + QuotedStr(sRegistro);
                try
                  IBQSALVA.ExecSQL;
                  IBQSALVA.Transaction.Commit;
                except
                  IBQSALVA.Transaction.Rollback;
                end;

              end;

              if bLimparXMLResposta then
              begin
                IBQSALVA.Close;
                IBQSALVA.SQL.Text :=
                  'update BLOCOX set ' +
                  'XMLRESPOSTA = null ' +
                  'where REGISTRO = ' + QuotedStr(sRegistro);
                try
                  IBQSALVA.ExecSQL;
                  IBQSALVA.Transaction.Commit;
                except
                  IBQSALVA.Transaction.Rollback;
                end;

              end;

            end; // if sRegistro <> '' then

            //ShowMessage('Teste 01 2235');  // Sandro Silva 2018-11-23

            Result := True;

  //  ShowMessage('finally 1696'); // Sandro Silva 2018-09-17
          finally
            Screen.Cursor := CursorOld;
          end;
        end; // if (IBQDEMAIS.FieldByName('REDUCOES').AsInteger <= 1) and (DayOf(Date) <= 5) then
      end;

      FreeAndNil(IBQSALVA);
      FreeAndNil(IBTSALVA);
      FreeAndNil(IBQESTOQUE);
      FreeAndNil(IBQVENDAS);
      FreeAndNil(IBQCOMPRAS);
      FreeAndNil(IBQFABRICA);
      FreeAndNil(IBQBALCAO);
      FreeAndNil(IBQRESERVA);
      FreeAndNil(IBQAQUISICAO);
      FreeAndNil(IBQREDUCOES);
      FreeAndNil(BXEstoque); // Sandro Silva 2019-06-19 BXEstoque.Free;
      aEstoque.Clear; // Sandro Silva 2019-06-19
      aEstoque.Free;

      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Referencia', '');
      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', '');

      //ShowMessage('Teste 01 finalizou geração xml estoque ' + DateTimeToStr(dtFinal)); // Sandro Silva 2019-02-15

      //ShowMessage('fim 1721'); // Sandro Silva 2018-09-17

      if slLog.Text <> '' then// Sandro Silva 2021-02-11 if sLog <> '' then
      begin
        try
          slLog.Text :=// Sandro Silva 2021-02-11 sLog :=

          '                  **************** Arquivo com inconsistência ******************' + #13 + #10 + #13 + #10 +
          'XML Estoque ' + FormatDateTime('dd/mm/yyy', dtFinal) + #13 + #10 +
          '1 - Favor corrigir os alertas abaixo.' + #13 + #10 +
          '2 - Após acesse o Frente de Caixa e faça a transmissão dos arquivos pendentes' + #13 + #10 + #13 + #10 +
          'Alertas:' + #13 + #10 +
          slLog.Text;// Sandro Silva 2021-02-11 sLog;

          if FileExists(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_Estoque_' + FormatDateTime('yyyymmdd', dtFinal) + '.txt')) then
          begin
            DeleteFile(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_Estoque_' + FormatDateTime('yyyymmdd', dtFinal) + '.txt'));
            Sleep(250);// meio segundo para excluir o arquivo
          end;

          slLog.SaveToFile(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_Estoque_' + FormatDateTime('yyyymmdd', dtFinal) + '.txt');

          ChDir(Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-04-04

          if FileExists(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_Estoque_' + FormatDateTime('yyyymmdd', dtFinal) + '.txt')) then
          begin
            ShellExecute(Application.Handle, nil, PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_Estoque_' + FormatDateTime('yyyymmdd', dtFinal) + '.txt'), nil, nil, SW_SHOWNORMAL);
          end;

        except

        end;
      end;

      FreeAndNil(slLog); // Sandro Silva 2021-02-11
    end
    else
    begin
      Result := True;
    end; //   if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06

  end; //   if CNAEDispensadoEnvioEstoque then
end;

function BXGeraXmlEstoqueMes(Emitente: TEmitente;
  IBTransaction1: TIBTransaction;
  dtInicial: TDate; dtFinal: TDate;
  bLimparRecibo: Boolean; bLimparXMLResposta: Boolean;
  bAssinarXML: Boolean; bForcarGeracao: Boolean): Boolean;
// Permite gerar o xml do estoque se for com data menor que 01/06/2020 ou período anual
begin
  //t := Time;

  if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06
  begin

    // Essa rotina só deve ser acionada durante a emissão da redução Z
    BXGeraXmlEstoquePeriodo(Emitente, IBTransaction1, dtInicial, dtFinal, bLimparRecibo, bLimparXMLResposta, bAssinarXML, bForcarGeracao);

    Result := True;

  end
  else
  begin
    Result := True;
  end; //   if (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'V') or (Copy(Emitente.Configuracao.PerfilPAF, 1, 1) = 'W') then // Sandro Silva 2019-08-06
end;

function BXRecuperarRecibodeXmlResposta(IBTransaction: TIBTransaction;
  XmlResposta: String; sDtReferencia: String; sTipo: String;
  sSerie: String): Boolean;
var
  sMensagem: String;
  sRecibo: String;
  IBQXML: TIBQuery;
  sSQL: String;
begin

  IBQXML := CriaIBQuery(IBTransaction);
  try
    sSQL :=
      'select * ' +
      'from BLOCOX ' +
      'where XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>'' ' +
      ' and TIPO = ' + QuotedStr(sTipo) +
      ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(sDtReferencia)));

    if Trim(sSerie) <> '' then
      sSQL := sSQL + ' and SERIE = ' + QuotedStr(sSerie);

    sSQL := sSQL +
      ' order by DATAREFERENCIA'; // Sandro Silva 2018-09-27 'order by DATAHORA';

    IBQXML.Close;
    IBQXML.SQL.Text := sSQL;
    IBQXML.Open;

    IBQXML.First;
    while IBQXML.Eof = False do
    begin

      // Sandro Silva 2022-09-05 if (AnsiContainsText(IBQXML.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>')) = False then //Não foi recebido com sucesso
      if RespostaComSucessoNoXmlBlocoX(IBQXML.FieldByName('XMLRESPOSTA').AsString) = False then //Não foi recebido com sucesso
      begin

        sMensagem := Trim(xmlNodeValue(IBQXML.FieldByName('XMLRESPOSTA').AsString, '//Mensagem'));

        if sMensagem = '' then
          sMensagem := Trim(xmlNodeValue(IBQXML.FieldByName('XMLRESPOSTA').AsString, '//SituacaoProcessamentoDescricao'));

        //Erro 1009: Um arquivo idêntico já foi recepcionado anteriormente. Consulte a situação do processamento deste arquivo ao invés de enviá-lo novamente. O número do recibo é cb95cc9a-dc7c-4c40-889a-8c1b2f8d2096
        //Erro 1009: Um arquivo idêntico a este já foi recepcionado anteriormente. O recibo 9c3065bd-adfc-4dee-8e4a-23a604cf37c7 está processado com sucesso.
        //Erro 3001: Já existe Redução Z com CRZ 2380 para o ECF de número de fabricação EP041010000000020232 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c8cbbe0-a0ee-4a18-973a-6475862e6a9b
        //Erro 3001: Já existe Redução Z com CRZ 2314 para o ECF de número de fabricação EP041010000000020825 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é df3e3ffc-e92b-4143-9ca5-2a92a20c5c7c
        //Erro 3001: Já existe Redução Z com CRZ 0877 para o ECF de número de fabricação EP081410000000066980 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c131d67-b075-40c0-82ef-59b1f000a126

        if (AnsiContainsText(sMensagem, 'Já existe ') and AnsiContainsText(sMensagem, 'O número do recibo') and AnsiContainsText(sMensagem, ' com sucesso'))
         or (AnsiContainsText(sMensagem, 'arquivo idêntico já foi recepcionado ') and AnsiContainsText(sMensagem, 'O número do recibo'))
         or (AnsiContainsText(sMensagem, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagem, 'O recibo ')) // Sandro Silva 2019-03-22
         then
        begin

          if (AnsiContainsText(sMensagem, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagem, 'O recibo ')) then
          begin
            sMensagem := Copy(sMensagem, Pos(AnsiUpperCase('O recibo '), AnsiUpperCase(sMensagem)) + Length('O recibo '), 36);
          end;

          sRecibo := Right(Trim(sMensagem), 36);// Trim(Copy(sMensagem, Pos('com sucesso é', sMensagem) + Length('com sucesso é'), 40));
          BXGravaReciboTransmissao(IBTransaction, sRecibo, IBQXML.FieldByName('DATAREFERENCIA').AsDateTime, IBQXML.FieldByName('TIPO').AsString, IBQXML.FieldByName('SERIE').AsString);
        end
        else
        begin
          ShowMessage('Não foi possível ler o recibo' + #13 + IBQXML.FieldByName('TIPO').AsString + ' ' + IBQXML.FieldByName('SERIE').AsString + ' ' + IBQXML.FieldByName('DATAREFERENCIA').AsString);
        end; // if AnsiContainsText(sMensagem, 'Já existe ') and AnsiContainsText(sMensagem, ' com sucesso é ') then

      end;

      IBQXML.Next;

    end;
    Result := True;
  except
    Result := False;
  end;

  FreeAndNil(IBQXML); // Create(nil);

end;

function BXGravaReciboTransmissao(IBTransaction: TIBTransaction;
  sRecibo: String; dtDatareferencia: TDate; sTipo: String;
  sSerie: String): Boolean;
//
// Grava os recibos recuperados da tag mensagem. Casos de duplicidade de envio
//
var
  IBTSALVAR: TIBTransaction;
  IBQBLOCOX: TIBQuery;
begin
  IBTSALVAR := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTSALVAR);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);
  try
   if (Length(Trim(sRecibo)) = 36) and (Pos(' ', sRecibo) = 0) then // Exemplo de recibo: 42fdb728-a535-42e6-b238-9dc3f5fd59f4
   begin
     if (Copy(sRecibo, 9, 1) = '-') and (Copy(sRecibo, 14, 1) = '-') and (Copy(sRecibo, 19, 1) = '-') and (Copy(sRecibo, 24, 1) = '-') then
     begin
       IBQBLOCOX.Close;
       IBQBLOCOX.SQL.Text :=
         'update BLOCOX set ' +
         'RECIBO = ' + QuotedStr(sRecibo) +
         // Sandro Silva 2022-09-05 ', XMLRESPOSTA = ' + QuotedStr(BLOCOX_ESPECIFICACAO_XML + '<Resposta Versao="' + BLOCOX_VERSAO_LEIAUTE + '"><Recibo>' + sRecibo + '</Recibo><SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao><Mensagem /></Resposta>') +
         ', XMLRESPOSTA = ' + QuotedStr(XmlRespostaPadraoAguardandoBlocoX(sRecibo)) +
         'where DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtDatareferencia)) +
         ' and TIPO = ' + QuotedStr(sTipo) +
         ' and coalesce(SERIE, '''') = ' + QuotedStr(sSerie);
       try
         IBQBLOCOX.ExecSQL;
         IBQBLOCOX.Transaction.Commit;

         //LogFrente('Recibo salvo no banco: ' + sRecibo + ' ' + sTipo + ' ' + FormatDateTime('dd/mm/yyyy', dtDatareferencia), Emitente.Configuracao.DiretorioAtual);

       except
         on E: Exception do
         begin
           IBQBLOCOX.Transaction.Rollback;
           //LogFrente('Recibo não foi salvo no banco: ' + sRecibo + ' ' + FormatDateTime('dd/mm/yyyy', dtDatareferencia), Emitente.Configuracao.DiretorioAtual);

           ShowMessage('Não foi possível salvar o número do recibo' + #13 + E.Message);
         end;
       end;
     end
     else
       ShowMessage('Recibo inválido ' + sRecibo);
   end;
   Result := True;
  finally
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTSALVAR);
  end;

end;

procedure BXAssinaTodosXmlPendente(IBTransaction: TIBTransaction;
  sTipo: String; DiretorioAtual: String);
// Sandro Silva 2018-01-29 Verifica os xml que não foram assinados, assina para futura transmissão
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  ArquivoXml: TArquivo;
  BlocoX: TBlocoXValidarXML;
  sArquivoXML: String;
begin

  BXDesconsideraXmlForaObrigatoriedade(IBTransaction); // Sandro Silva 2020-02-28

  //
  // Não usar transações dos ibdataset
  //
  IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase); // Sandro Silva 2018-09-20 CriaIBTransaction(IBDatabase1);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);

  ArquivoXml := TArquivo.Create;

  BlocoX := TBlocoXValidarXML.Create(nil);
  BlocoX.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');

  try
    // Seleciona todos xml que estão pendentes de envio
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select * ' +
      'from BLOCOX ' +
      'where coalesce(RECIBO, '''') = '''' ' + // Sem recibo indica que não foi enviado
      ' and TIPO = ' + QuotedStr(sTipo) +
      ' order by DATAREFERENCIA'; // Sandro Silva 2018-09-27 ' order by DATAHORA';
    IBQBLOCOX.Open;

    while IBQBLOCOX.Eof = False do
    begin

      //validar ser está assinado
      //assinar qdo sem assinatura
      //salvar arquivo assinado na base e na pasta
      ArquivoXml.Texto := IBQBLOCOX.FieldByName('XMLENVIO').AsString;
      if ArquivoXML.Texto <> '' then
      begin
        if xmlNodeValue(ArquivoXML.Texto, '//Signature/SignatureValue') = '' then
        begin

          try
            BlocoX.DiretorioAtual := DiretorioAtual;
            BlocoX.Xml := ArquivoXml.Texto;
            BlocoX.AssinaXML;

            //LogFrente(BlocoX.Xml, DiretorioAtual); // Sandro Silva 2019-04-22

            if xmlNodeValue(BlocoX.Xml, '//Signature/SignatureValue') <> '' then
            begin

              ArquivoXML.Texto := BlocoX.Xml;

              if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
                sArquivoXML := PASTA_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + IBQBLOCOX.FieldByName('SERIE').AsString + '_' + FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime) + '.xml'
              else
                sArquivoXML := PASTA_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + FormatDateTime('mmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime) + '.xml'; // Sandro Silva 2019-06-21 ER 02.06 sArquivoXML := PASTA_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + FormatDateTime('yyyymm', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime) + '01_' + FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime) + '.xml';

              ArquivoXML.SalvarArquivo(sArquivoXML);

              BXSalvarBancoXmlEnvio(IBTransaction, IBQBLOCOX.FieldByName('TIPO').AsString, IBQBLOCOX.FieldByName('SERIE').AsString, IBQBLOCOX.FieldByName('DATAHORA').AsDateTime, BlocoX.Xml, IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

            end;
          except
            on E: Exception do
            begin
              LogFrente(E.Message, DiretorioAtual);
            end;
          end;
        end;
      end;

      IBQBLOCOX.Next;
    end;
  finally
    FreeAndNil(ArquivoXml); // Sandro Silva 2019-06-19 ArquivoXml.Free;
    FreeAndNil(BlocoX); // Sandro Silva 2019-06-19 BlocoX.Free;
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);
  end;

end;

function BXServidorSefazConfigurado(UF: String): Boolean;
var
  ArqConfigXml: TStringList;
  sSubjectName: String; // Sandro Silva 2018-02-05
  sPerfilPAF: String;
begin
  Result := False; // Sandro Silva 2017-05-20
  sPerfilPAF := Copy(PerfilPAF(CHAVE_CIFRAR), 1, 1);

//ShowMessage('teste 1 etapa perfil'); // Sandro Silva 2020-03-13

  if (sPerfilPAF = 'T') or (sPerfilPAF = 'V') or (sPerfilPAF = 'W') then // Sandro Silva 2019-08-06
  begin

    ArqConfigXml := TStringList.Create;
    try
      {
      // Para Fernanda testar situacao clientes. Voltar como era após testes
      ArqConfigXml.Text :=
        '<?xml version="1.0" encoding="utf-8"?>' +
        '<Smallsoft>' +
          '<BlocoX>' +
            '<UF nome="SC">' +
              '<Servico acao="Consultar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>ConsultarResult</TagResposta>' +
              '</Servico>' +
              '<Servico acao="Enviar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>EnviarResult</TagResposta>' +
              '</Servico>' +
              '<Servico acao="Validar">' +
                  '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                  '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                  '<TagResposta>ValidarResult</TagResposta>' +
              '</Servico>' +
            '</UF>' +
          '</BlocoX>' +
        '</Smallsoft>';
      {Sandro Silva 2018-01-25 fim}

      sSubjectName := '';
      try
        sSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');// Sandro Silva 2018-09-20  BXReducaoZ.CertificadoSubjectName; // Sandro Silva 2018-02-06  BXEstoque.Certificado.SubjectName;
      except
      end;

//ShowMessage('teste 1 etapa certificado' + #13 + sSubjectName); // Sandro Silva 2020-03-13

      if (AnsiContainsText(sSubjectName, '07426598000124')) then
      begin
        // Sandro Silva 2018-02-01 Não é certificado da Smallsoft usa homologação
        if FileExists(DiretorioConfigBlocoX + '\blocox_servidores_homologacao.xml') = False then
        begin
          ArqConfigXml.Text :=
            '<?xml version="1.0" encoding="utf-8"?>' +
            '<Smallsoft>' +
              '<BlocoX>' +
                '<UF nome="SC">' +
                  '<Servico acao="Consultar">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                      '<TagResposta>ConsultarResult</TagResposta>' +
                  '</Servico>' +
                  '<Servico acao="Enviar">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                      '<TagResposta>EnviarResult</TagResposta>' +
                  '</Servico>' +
                  '<Servico acao="Validar">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/Recepcao.asmx</SOAPAction>' +
                      '<TagResposta>ValidarResult</TagResposta>' +
                  '</Servico>' +


                  '<Servico acao="CancelarArquivo">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/CancelarArquivo</SOAPAction>' +
                      '<TagResposta>CancelarArquivoResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                  '<Servico acao="ConsultarPendenciasContribuinte">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/ConsultarPendenciasContribuinte</SOAPAction>' +
                      '<TagResposta>ConsultarPendenciasContribuinteResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                  '<Servico acao="ConsultarPendenciasDesenvolvedorPafEcf">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/ConsultarPendenciasDesenvolvedorPafEcf</SOAPAction>' +
                      '<TagResposta>ConsultarPendenciasDesenvolvedorPafEcfResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                  '<Servico acao="ConsultarProcessamentoArquivo">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/ConsultarProcessamentoArquivo</SOAPAction>' +
                      '<TagResposta>ConsultarProcessamentoArquivoResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                  '<Servico acao="ReprocessarArquivo">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/ReprocessarArquivo</SOAPAction>' +
                      '<TagResposta>ReprocessarArquivoResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                  '<Servico acao="TransmitirArquivo">' +
                      '<Url>http://webservices.sathomologa.sef.sc.gov.br/wsdfesiv/blocox.asmx</Url>' +
                      '<SOAPAction>http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/TransmitirArquivo</SOAPAction>' +
                      '<TagResposta>TransmitirArquivoResult</TagResposta>' +
                      '<TimeOut></TimeOut>' +
                  '</Servico>' +

                '</UF>' +
              '</BlocoX>' +
            '</Smallsoft>';
        end
        else
          ArqConfigXml.LoadFromFile(DiretorioConfigBlocoX + '\blocox_servidores_homologacao.xml');
      end
      else
      begin
        ArqConfigXml.LoadFromFile(DiretorioConfigBlocoX + '\blocox_servidores.xml');
      end;

      Result := (
            (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="Enviar"]/Url') <> '')
        and (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="Enviar"]/SOAPAction') <> '')
        and (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="Enviar"]/TagResposta') <> '')
        )
        or // Novo serviço de recepção
        (
            (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="TransmitirArquivo"]/Url') <> '')
        and (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="TransmitirArquivo"]/SOAPAction') <> '')
        and (xmlNodeValue(ArqConfigXml.Text, '//UF[@nome="' + UF + '"]/Servico[@acao="TransmitirArquivo"]/TagResposta') <> '')
        );

//ShowMessage('teste 1 etapa url ok'); // Sandro Silva 2020-03-13


    except
    end;
    FreeAndNil(ArqConfigXml);// Sandro Silva 2019-07-18  ArqConfigXml.Free;
  end
  else
  begin
    //LogFrente('Perfil não habilitado ao PAF: ' + sPerfilPAF, Emitente.Configuracao.DiretorioAtual);
  end;//   if (sPerfilPAF = 'T') or (sPerfilPAF = 'V') or (sPerfilPAF = 'W') then // Sandro Silva 2019-08-06

  ValidaMd5DoListaNoCriptografado;

//ShowMessage('teste 1 etapa fim validação perfil'); // Sandro Silva 2020-03-13

end;

procedure BXSalvarReciboTransmissaoBanco(Emitente: TEmitente; IBTransaction: TIBTransaction;
  Retorno: TRetornoBlocoX;
  sRegistro: String); overload;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  sSql: String;
  sRecibo: String;
  sMensagemResposta: String;
  //sDtreferencia: String;
  sXMLResposta: String;
begin
  IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);
  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'update BLOCOX set ';

    if Trim(Retorno.Recibo) <> '' then
      sSql := ' RECIBO = :RECIBO ';

    if Retorno.XmlResposta <> '' then
    begin
      if sSQL <> '' then
        sSql := sSql + ', ';
      sSql := sSql + ' XMLRESPOSTA = :XMLRESPOSTA ';
    end;

    if ssql <> '' then
    begin

      IBQBLOCOX.SQL.Add(sSql);

      sXMLResposta := Retorno.XmlResposta;// Sandro Silva 2019-03-27

      if Retorno.Recibo <> '' then
      begin
        IBQBLOCOX.ParamByName('RECIBO').AsString := Retorno.Recibo;
      end
      else
      begin
        // <Mensagem>Erro: já existe Redução Z com estas informações com situação aguardando ou sucesso, número do reciboa3de306d-df19-4862-a15e-b9d07fc7e6d7</Mensagem>
        sMensagemResposta := AnsiLowerCase(Retorno.Mensagem);

        if AnsiContainsText(sMensagemResposta, 'recibo') then
        begin

          if AnsiContainsText(sMensagemResposta, 'Erro 1009') then
          begin
             ///Erro 1009: Um arquivo idêntico a este já foi recepcionado anteriormente. O recibo 415cf8cf-dccd-4fb3-9d5f-d4ea61edaa0a está com erro no processamento. Você pode reprocessá-lo pelo web service ou pela aplicação web.

            // Testar se está passando aqui quando grava recibo de consulta com retorno Erro 1009
            if AnsiContainsText(sMensagemResposta, 'erro no processamento') and AnsiContainsText(sMensagemResposta, 'pode reprocessá-lo') then
            begin
              try
                BXReprocessarArquivo(Emitente, IBTransaction, Emitente.Configuracao.DiretorioAtual, Retorno.Recibo);
              except
              end;
            end;

            if (AnsiContainsText(sMensagemResposta, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagemResposta, 'O recibo ')) then
            begin
              sMensagemResposta := Copy(sMensagemResposta, Pos(AnsiUpperCase('O recibo '), AnsiUpperCase(sMensagemResposta)) + Length('O recibo '), 36);
            end;

            sMensagemResposta := Right(Trim(sMensagemResposta), 36);// Trim(Copy(sMensagem, Pos('com sucesso é', sMensagem) + Length('com sucesso é'), 40));

            sRecibo := sMensagemResposta;

            // Sandro Silva 2022-09-05 sXMLResposta := '<?xml version="1.0" encoding="utf-8"?><Resposta><Recibo>' + sRecibo + '</Recibo><SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao><Mensagem /></Resposta>';
            sXMLResposta := XmlRespostaPadraoAguardandoBlocoX(sRecibo);

          end
          else
          begin

            sMensagemResposta := Copy(sMensagemResposta, Pos('recibo', sMensagemResposta), Length(sMensagemResposta));
            sMensagemResposta := Trim(StringReplace(sMensagemResposta, 'recibo', '', [rfReplaceAll]));
            sMensagemResposta := RightStr(sMensagemResposta, 36); // Sandro Silva 2018-09-04

            sRecibo := sMensagemResposta;

          end;

          if sMensagemResposta <> '' then
          begin
            if sSQL <> '' then
              IBQBLOCOX.SQL.Add(', RECIBO = :RECIBO ')
            else
              IBQBLOCOX.SQL.Add(' RECIBO = :RECIBO ');
            IBQBLOCOX.ParamByName('RECIBO').AsString := sRecibo; // Sandro Silva 2019-03-27 IBQBLOCOX.ParamByName('RECIBO').AsString := sMensagemResposta;
          end;
        end;
      end;

      IBQBLOCOX.SQL.Add(' where REGISTRO = :REGISTRO ');

      IBQBLOCOX.ParamByName('REGISTRO').AsString := sRegistro;

      //ShowMessage('Teste 01 2883 ' + #13 + Retorno.XmlResposta); // Sandro Silva 2018-11-23

      if sXMLResposta <> '' then // Sandro Silva 2019-03-27  if Retorno.XmlResposta <> '' then
        IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := sXMLResposta; // Sandro Silva 2019-03-27 IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := Retorno.XmlResposta;
      try
        IBQBLOCOX.ExecSQL;
        IBQBLOCOX.Transaction.Commit;
      except
        IBQBLOCOX.Transaction.Rollback;
      end;
    end;
  finally
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);
  end;
end;

procedure BXTrataErroRetornoTransmissao(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sXmlResposta: String; sTipo: String;
  sSerie: String; sDataReferencia: String);
var
  IBTSALVAR: TIBTransaction;
  IBQSALVAR: TIBQuery;
  IBQBLOCOX: TIBQuery;
  sMensagemRetorno: String;
  sCredenciamentoXML: String;
  sCredenciamentoVigente: String;
  sXML: String;
  sRecibo: String;
  sIExml: String;
  sIEBanco: String;
begin

  if RespostaComErroNoXmlBlocoX(sXmlResposta) // if (Pos('<SituacaoProcessamentoCodigo>2</SituacaoProcessamentoCodigo>', sXmlResposta) > 0)
    or (Pos('<SituacaoProcessamentoCodigo>3</SituacaoProcessamentoCodigo>', sXmlResposta) > 0) then
  begin // Sefaz respondeu informando que há erro no xml enviado
    IBTSALVAR := CriaIBTransaction(IBTransaction.DefaultDatabase);
    IBQSALVAR := CriaIBQuery(IBTSALVAR);

    IBQBLOCOX := CriaIBQuery(IBTransaction);
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select * ' +
      'from BLOCOX ' +
      'where DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(sDataReferencia))) +
      ' and TIPO = ' + QuotedStr(sTipo);
    if sSerie <> '' then
      IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerie));
    IBQBLOCOX.Open;

    if Pos('</RespostaManutencao>', sXmlResposta) > 0 then
    begin
      try
        sMensagemRetorno := xmlNodeValue(sXmlResposta, '//SituacaoProcessamentoDescricao');
      except
        sMensagemRetorno := ''
      end;

      if sMensagemRetorno = '' then
        sMensagemRetorno := ProcessaResposta(sXmlResposta, 'SituacaoProcessamentoDescricao');
    end
    else
    begin
      try
        sMensagemRetorno := xmlNodeValue(sXmlResposta, '//Mensagem');
      except
        sMensagemRetorno := ''
      end;

      if sMensagemRetorno = '' then
        sMensagemRetorno := ProcessaResposta(sXmlResposta, 'Mensagem');
    end;

    if AnsiContainsText(sMensagemRetorno, 'Erro 3024') // O sistema verifica se a data de referência é anterior à data de início da obrigação
      or AnsiContainsText(sMensagemRetorno, 'Erro 4011') // Verifica se o CNAE do contribuinte não está obrigado a enviar Estoque
      or AnsiContainsText(sMensagemRetorno, 'Erro 4019') // O sistema verifica se a data de referência é anterior à data de início da obrigação
      then
    begin

      LogFrente('XML gerado antes da obrigação' + ': ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString + ' ' + FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);

      if AnsiContainsText(sMensagemRetorno, 'Erro 4011')   // Contribuinte não obrigado a enviar Estoque
        or AnsiContainsText(sMensagemRetorno, 'Erro 4019') // Data de referência anterior ao início da obrigação
        then
      begin
        // Se CNAE do contribuinte não está obrigado a enviar ESTOQUE
        // Salva recibo e xml resposta padrão, para evitar que fique gerando até que ultrapasse a data limite de geração

        try
          IBQSALVAR.Close;
          IBQSALVAR.SQL.Text :=
            'update BLOCOX set ' +
            'RECIBO = :RECIBO ' +
            ', XMLRESPOSTA = :XMLRESPOSTA ' +
            'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
            ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
          if AnsiContainsText(sMensagemRetorno, 'Erro 4011') then  // Contribuinte não obrigado a enviar Estoque
            IBQSALVAR.ParamByName('RECIBO').AsString      := 'CNAE não obrigado a enviar os arquivos de Estoque';
          if AnsiContainsText(sMensagemRetorno, 'Erro 4019') then // Data de referência anterior ao início da obrigação
            IBQSALVAR.ParamByName('RECIBO').AsString      := RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO;
          // Sandro Silva 2022-09-05 IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := '<?xml version="1.0" encoding="utf-8"?><Resposta><Recibo>' + IBQSALVAR.ParamByName('RECIBO').AsString + '</Recibo><SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Sucesso</SituacaoProcessamentoDescricao><Mensagem /></Resposta>';
          IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoSucessoBlocoX(IBQSALVAR.ParamByName('RECIBO').AsString);
          IBQSALVAR.ExecSQL;
          IBQSALVAR.Transaction.Commit;
        except
          IBQSALVAR.Transaction.Rollback;
        end;

      end
      else
      begin

        if AnsiContainsText(sMensagemRetorno, 'Erro 3024') then // O sistema verifica se a data de referência é anterior à data de início da obrigação
        begin
          try

            if IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then // Gera novamente o xml a partir do
            begin
              IBQSALVAR.Close;
              IBQSALVAR.SQL.Text :=
                'delete from BLOCOX ' +
                'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
                ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
              IBQSALVAR.ExecSQL;

            end
            else
            begin
              IBQSALVAR.Close;
              IBQSALVAR.SQL.Text :=
                'update BLOCOX set ' +
                'RECIBO = :RECIBO ' +
                ', XMLRESPOSTA = :XMLRESPOSTA ' +
                'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
                ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
              IBQSALVAR.ParamByName('RECIBO').AsString      := RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO;
              // Sandro Silva 2022-09-05 IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := '<?xml version="1.0" encoding="utf-8"?><Resposta><Recibo>' + IBQSALVAR.ParamByName('RECIBO').AsString + '</Recibo><SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Sucesso</SituacaoProcessamentoDescricao><Mensagem /></Resposta>';
              IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoSucessoBlocoX(IBQSALVAR.ParamByName('RECIBO').AsString);
              IBQSALVAR.ExecSQL;

            end;
            IBQSALVAR.Transaction.Commit;
          except
            IBQSALVAR.Transaction.Rollback;
          end;
        end;

      end; // if AnsiContainsText(sMensagemRetorno, 'Erro 4011') then

    end
    else
    begin

      if AnsiContainsText(sMensagemRetorno, 'Erro 1001') // Schema inválido
        or AnsiContainsText(sMensagemRetorno, 'Erro 1002') // Verifica se a versão enviada é válida
        or AnsiContainsText(sMensagemRetorno, 'Erro 3002') // Data de referência da Redução Z não pode ser posterior à data atual
        or AnsiContainsText(sMensagemRetorno, 'Erro 3003') // Atestado de Intervenção de Pedido de Uso (normal ou de equipamento cessado) não encontrado para o ECF informado.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3004') // Data de referência da Redução Z é anterior à data do Atestado de Intervenção de Pedido de Uso do ECF.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3005') // Código NCM informado no produto é inválido
        or AnsiContainsText(sMensagemRetorno, 'Erro 3007') // Não é permitido um CRZ menor para uma data de referência posterior
        or AnsiContainsText(sMensagemRetorno, 'Erro 3008') // Não é permitido um CRZ maior para uma data de referência anterior
        or AnsiContainsText(sMensagemRetorno, 'Erro 3009') // Não é permitido um GT menor com data de referência posterior
        or AnsiContainsText(sMensagemRetorno, 'Erro 3010') // O GT atual deve corresponder à soma da venda bruta diária atual com o GT da Redução Z anterior.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3011') // O valor do totalizador parcial [TOTALIZADOR_PARCIAL] deve ser a soma dos valores líquidos dos produtos/serviços
        or AnsiContainsText(sMensagemRetorno, 'Erro 3012') // O valor da venda bruta diária deve ser a soma dos valores líquidos + cancelamentos + descontos.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3013') // Totalizador [TOTALIZADOR_PARCIAL] inválido. Os valores possíveis estão na tabela 4.4.6 do Ato COTEPE/ICMS nº 09, de 18 de abril de 2008, que discrimina os códigos dos Totalizadores Parciais da Redução Z.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3014') // Não é permitido um GT maior com data de referência anterior
        or AnsiContainsText(sMensagemRetorno, 'Erro 3015') // Não é permitido duplicar totalizadores. Totalizadores duplicados: [LISTA_DOS_TOTALIZADORES]
        or AnsiContainsText(sMensagemRetorno, 'Erro 3016') // Os seguintes totalizadores excedem o máximo de 3 ocorrências por tipo: [LISTA_DOS_TOTALIZADORES]
        or AnsiContainsText(sMensagemRetorno, 'Erro 3017') // Totalizadores de cancelamento, acréscimo e desconto, não devem ser utilizados pois estes estão nos elementos ValorCancelamento, ValorAcrescimo e ValorDesconto
        or AnsiContainsText(sMensagemRetorno, 'Erro 3018') // Não é permitido duplicar produtos/serviços na Redução Z.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3019') // O sistema verifica se o produto informado na Redução Z se encontra no estoque do mês anterior.
        or AnsiContainsText(sMensagemRetorno, 'Erro 3020') // Verifica se o código GTIN informado é válido
        or AnsiContainsText(sMensagemRetorno, 'Erro 3021') // Verifica se o código CEST informado é válido
        or AnsiContainsText(sMensagemRetorno, 'Erro 3022') // Verifica se o código CEST está dentro da validade na data de referência da Redução Z
        or AnsiContainsText(sMensagemRetorno, 'Erro 3023') // Verifica se existe vínculo entre o NCM e o CEST informado no produto
        or AnsiContainsText(sMensagemRetorno, 'Erro 3026') // Verifica se o código CEST informado é válido para o NCM/SH do produto:
        or AnsiContainsText(sMensagemRetorno, 'Erro 4001') // Data de referência do Estoque precisa ser o último dia do mês.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4002') // Data de referência do Estoque não pode ser posterior à data atual
        or AnsiContainsText(sMensagemRetorno, 'Erro 4003') // Quando a situação tributária for não tributado, isento ou substituição tributária, a alíquota precisa estar em branco.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4004') // Quando a situação tributária for diferente de não tributado, de isento e de substituição tributária, alíquota precisa ter valor.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4006') // Verifica se o NCM é válido.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4007') // Data de referência do Estoque não pode ser anterior à data do início das atividades do contribuinte.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4009') // A quantidade total adquirida do produto não deve ser negativa.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4010') // Não é permitido duplicar produtos no Estoque.
        or AnsiContainsText(sMensagemRetorno, 'Erro 4012') // Verifica se o estoque contém todos os produtos das Reduções Z do mesmo mês. Quando informado o GTIN na Redução Z, procura o produto com o código próprio e o GTIN (juntos) no estoque
        or AnsiContainsText(sMensagemRetorno, 'Erro 4013') // Verifica se o código GTIN informado é válido
        or AnsiContainsText(sMensagemRetorno, 'Erro 4014') // Verifica se o código CEST foi informado quando o produto está sob substituição tributária
        or AnsiContainsText(sMensagemRetorno, 'Erro 4015') // Verifica se o código CEST foi preenchido quando o produto não está sob substituição tributária
        or AnsiContainsText(sMensagemRetorno, 'Erro 4016') // Verifica se o código CEST informado é válido
        or AnsiContainsText(sMensagemRetorno, 'Erro 4017') // Verifica se o código CEST está dentro da validade na data de referência do Estoque
        or AnsiContainsText(sMensagemRetorno, 'Erro 4018') // Verifica se existe vínculo entre o NCM e o CEST informado no produto
        or AnsiContainsText(sMensagemRetorno, 'Erro 4021') // Verifica se o código CEST informado é válido para o NCM/SH do produto:
        or AnsiContainsText(sMensagemRetorno, 'Erro 9999') // Caso ocorra algum erro inesperado, o sistema irá retornar a descrição do erro através deste código
      then
      begin // gera novamente o xml

        if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
          BXGeraXmlReducaoZ(Emitente, IBTransaction, IBQBLOCOX.FieldByName('SERIE').AsString, FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), True, True, True);

        if IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then // Gera novamente o xml a partir do
        begin

          BXGeraXmlEstoquePeriodo(Emitente, IBTransaction, StrToDate('01' + FormatDateTime('/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime)), IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime, True, True, True, True);

        end;

      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 1003')   // Assinatura digital inválida
        or AnsiContainsText(sMensagemRetorno, 'Erro 1004') // Erro na leitura do certificado digital
        or AnsiContainsText(sMensagemRetorno, 'Erro 1005') // Não foi encontrado o CNPJ do certificado digital
        or AnsiContainsText(sMensagemRetorno, 'Erro 1007') // Certificado digital com CNPJ raíz diferente do estabelecimento.
        or AnsiContainsText(sMensagemRetorno, 'Erro 1008') // Contribuinte precisa estar com o cadastro ativo
        or AnsiContainsText(sMensagemRetorno, 'Erro 2001') // PAF-ECF não encontrando
        or AnsiContainsText(sMensagemRetorno, 'Erro 2002') // PAF-ECF precisa estar ativo ou vencido. Situação: [SITUACAO_DO_PAF_ECF]
        //or AnsiContainsText(sMensagemRetorno, 'Erro 2003') // Versão da Especificação de Requisitos do PAF-ECF [VERSAO_DA_ESPECIFICACAO_DE_REQUISITOS_DO_PAF_ECF], mas precisa ser 02.03 ou superior
        //or AnsiContainsText(sMensagemRetorno, 'Erro 2004') // Laudo do PAF-ECF precisa ser até 180 dias da data de validade. Data de validade: [DATA_DE_VALIDADE_DO_LAUDO]
        //or AnsiContainsText(sMensagemRetorno, 'Erro 2005') // Nenhum PAF-ECF encontrado no SAT para o estabelecimento, enquanto no XML foi informado o número [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_XML]
        //or AnsiContainsText(sMensagemRetorno, 'Erro 2006') // Número do credenciamento do PAF-ECF informado no XML diferente do SAT e não corresponde a uma versão mais recente. XML: [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_XML] SAT: [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_SAT]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2007') // ECF não encontrando ou com situação diferente de ativo
        or AnsiContainsText(sMensagemRetorno, 'Erro 2008') // ECF com situação ativo encontrado em mais de uma autorização de uso: [LISTA_DAS_AUTORIZACOES_DE_USO_DO_ECF]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2009') // Autorização de uso do ECF com situação diferente de ativo. Situação: [SITUACAO_DA_AUTORIZACAO_DE_USO]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2010') // ECF em modo de treinamento
        or AnsiContainsText(sMensagemRetorno, 'Erro 2011') // ECF com pendência: [DESCRICAO_DA_PENDENCIA]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2012') // ECF não pertence ao estabelecimento informado
        or AnsiContainsText(sMensagemRetorno, 'Erro 2013') // ECF não utiliza o PAF-ECF informado
        or AnsiContainsText(sMensagemRetorno, 'Erro 2014') // Não é possível realizar a atualização da versão do PAF-ECF utilizada pelo contribuinte.
        or AnsiContainsText(sMensagemRetorno, 'Erro 2015') // A autorização de uso do ECF não possui PAF-ECF, enquanto no XML foi informado o número

      then
      begin // Limpa a assinatura digital do xml para ser assinado no próximo envio
        if AnsiContainsText(sMensagemRetorno, 'Erro 2007') and AnsiContainsText(sMensagemRetorno, 'Número de fabricação:') then  // <SituacaoProcessamentoDescricao>Erro 2007: ECF não encontrado ou com situação diferente de ativo. IE: 25.424.565-0. Número de fabricação: EL051200000000014075</SituacaoProcessamentoDescricao>
        begin
          BXGeraXmlReducaoZ(Emitente, IBTransaction, IBQBLOCOX.FieldByName('SERIE').AsString, FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), True, True, True);
        end
        else
        begin

          sXML := IBQBLOCOX.FieldByName('XMLENVIO').AsString;
          // Limpa assinatura para assinar quando transmitir
          sXML := Copy(sXML, 1, Pos('<Signature', sXML) - 1);
          sXML := sXML + '<Signature />';
          if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
            sXML := sXML + '</ReducaoZ>'
          else
            sXML := sXML + '</Estoque>';

          BXSalvarBancoXmlEnvio(IBTransaction, IBQBLOCOX.FieldByName('TIPO').AsString, IBQBLOCOX.FieldByName('SERIE').AsString, IBQBLOCOX.FieldByName('DATAHORA').AsDateTime, sXML, IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);
        end;

      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 1006') // Número da Inscrição Estadual do estabelecimento inválido
        or AnsiContainsText(sMensagemRetorno, 'Erro 2003') // Versão da Especificação de Requisitos do PAF-ECF [VERSAO_DA_ESPECIFICACAO_DE_REQUISITOS_DO_PAF_ECF], mas precisa ser 02.03 ou superior
        or AnsiContainsText(sMensagemRetorno, 'Erro 2004') // Laudo do PAF-ECF precisa ser até 180 dias da data de validade. Data de validade: [DATA_DE_VALIDADE_DO_LAUDO]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2005') // Nenhum PAF-ECF encontrado no SAT para o estabelecimento, enquanto no XML foi informado o número [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_XML]
        or AnsiContainsText(sMensagemRetorno, 'Erro 2006') // Número do credenciamento do PAF-ECF informado no XML diferente do SAT e não corresponde a uma versão mais recente. XML: [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_XML] SAT: [NUMERO_DO_CREDENCIAMENTO_DO_PAF_ECF_NO_SAT]
       then
      begin // Número do credenciamento no xml enviado é diferente do número atual na SERFAZ

        if AnsiContainsText(sMensagemRetorno, 'Erro 1006') then // Número da Inscrição Estadual do estabelecimento inválido
        begin
          // Troca o número da IE
          sIExml   := xmlNodeValue(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '//Ie');
          sIEBanco := LimpaNumero(Emitente.IE);
          sXML := StringReplace(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '<Ie>' + sIExml + '</Ie>', '<Ie>' + sIEBanco + '</Ie>', [rfReplaceAll]);
          sXML := StringReplace(sXML, '<Ie></Ie>', '<Ie>' + sIEBanco + '</Ie>', [rfReplaceAll]);
        end
        else
        begin
          // Troca o número de credenciamento
          sCredenciamentoXMl     := xmlNodeValue(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '//NumeroCredenciamento');
          sCredenciamentoVigente := Credenciamento(FormataCpfCgc(Emitente.CNPJ));// Sandro Silva 2019-12-11  sCredenciamentoVigente := LerParametroIni('arquivoauxiliarcriptografadopafecfsmallsoft.ini', INI_SECAO_ECF, INI_CHAVE_NUMERO_CREDENCIAMENTO_PAF, sCredenciamentoVigente);

          sXML := StringReplace(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '<NumeroCredenciamento>' + sCredenciamentoXMl + '</NumeroCredenciamento>', '<NumeroCredenciamento>' + sCredenciamentoVigente + '</NumeroCredenciamento>', [rfReplaceAll]);
          sXML := StringReplace(sXML, '<NumeroCredenciamento></NumeroCredenciamento>', '<NumeroCredenciamento>' + sCredenciamentoVigente + '</NumeroCredenciamento>', [rfReplaceAll]);
        end;

        // Limpa assinatura para assinar quando transmitir
        sXML := Copy(sXML, 1, Pos('<Signature', sXML) - 1);
        sXML := sXML + '<Signature />';
        if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
          sXML := sXML + '</ReducaoZ>'
        else
          sXML := sXML + '</Estoque>';

        BXSalvarBancoXmlEnvio(IBTransaction, IBQBLOCOX.FieldByName('TIPO').AsString, IBQBLOCOX.FieldByName('SERIE').AsString, IBQBLOCOX.FieldByName('DATAHORA').AsDateTime, sXML, IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

      end;

      //Erro 1009: Um arquivo idêntico já foi recepcionado anteriormente. Consulte a situação do processamento deste arquivo ao invés de enviá-lo novamente. O número do recibo é cb95cc9a-dc7c-4c40-889a-8c1b2f8d2096
      //Erro 1009: Um arquivo idêntico a este já foi recepcionado anteriormente. O recibo 9c3065bd-adfc-4dee-8e4a-23a604cf37c7 está processado com sucesso
      //Erro 3001: Já existe Redução Z com CRZ 2380 para o ECF de número de fabricação EP041010000000020232 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c8cbbe0-a0ee-4a18-973a-6475862e6a9b
      //Erro 3001: Já existe Redução Z com CRZ 2314 para o ECF de número de fabricação EP041010000000020825 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é df3e3ffc-e92b-4143-9ca5-2a92a20c5c7c
      //Erro 3001: Já existe Redução Z com CRZ 0877 para o ECF de número de fabricação EP081410000000066980 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c131d67-b075-40c0-82ef-59b1f000a126
      if (AnsiContainsText(sMensagemRetorno, 'Já existe ') and AnsiContainsText(sMensagemRetorno, 'O número do recibo') and AnsiContainsText(sMensagemRetorno, ' com sucesso'))
        or (AnsiContainsText(sMensagemRetorno, 'arquivo idêntico já foi recepcionado ') and AnsiContainsText(sMensagemRetorno, 'O número do recibo'))
        or (AnsiContainsText(sMensagemRetorno, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagemRetorno, 'O recibo ')) // Sandro Silva 2019-03-22
        or AnsiContainsText(sMensagemRetorno, 'Erro 3001') // Já existe Redução Z com CRZ
        or AnsiContainsText(sMensagemRetorno, 'Erro 3006') // Já existe Redução Z para a data de referência
        or AnsiContainsText(sMensagemRetorno, 'Erro 4005') // Já existe Estoque para a IE
        then
      begin
        if (AnsiContainsText(sMensagemRetorno, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagemRetorno, 'O recibo ')) then
        begin
          sMensagemRetorno := Copy(sMensagemRetorno, Pos(AnsiUpperCase('O recibo '), AnsiUpperCase(sMensagemRetorno)) + Length('O recibo '), 36);
        end;

        sRecibo := Right(Trim(sMensagemRetorno), 36);// Trim(Copy(sMensagem, Pos('com sucesso é', sMensagem) + Length('com sucesso é'), 40));

        //ShowMessage('teste 01 3080 ' + #13 + sRecibo); // Sandro Silva 2018-11-23
        BXGravaReciboTransmissao(IBTransaction, sRecibo, IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime, IBQBLOCOX.FieldByName('TIPO').AsString, IBQBLOCOX.FieldByName('SERIE').AsString);

      end;
    end; // if // O sistema verifica se a data de referência é anterior à data de início da obrigação Sandro Silva 2019-04-15

    FreeAndNil(IBQSALVAR);
    FreeAndNil(IBTSALVAR);
    FreeAndNil(IBQBLOCOX);
  end; // if Pos('<SituacaoProcessamentoCodigo>2</SituacaoProcessamentoCodigo>', sXmlResposta) > 0 then
end;

function BXAlertarXmlPendente(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sTipo: String; sSerieECF: String;
  bExibirAlerta: Boolean; bRetaguarda: Boolean = False): Boolean;// String;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
// Sandro Silva 2017-03-30 Retorna mensagem de alerta com qtd de arquivos não transmitidos a Sefaz. Se bExibirAlerta = True exibe mensagem
var
  IBTBLOCOX: TIBTransaction; // Sandro Silva 2017-11-13  HOMOLOGA 2017 para ler os dados atualizados no banco por outra transação
  IBQBLOCOX: TIBQuery; // Sandro Silva 2017-03-20
  sMensagemAlerta: String; // Sandro Silva 2018-09-21
  bBlocoxRZPendente: Boolean;
  bBlocoxEstoquePendente: Boolean;
  sDataPendencia: String; // Sandro Silva 2019-06-21 ER 02.06
  Retorno: TRetornoBlocoX; // Sandro Silva 2022-09-06
  function AlertaRZ(iQtd: Integer; sDataPendencia: String): String; // Sandro Silva 2019-06-21 ER 02.06 function AlertaRZ(iQtd: Integer): String;
  begin
    Result := '';
    if iQtd > 0 then
    begin
      // Sandro Silva 2019-06-21 ER 02.06   Result := 'HÁ  ' + IntToStr(iQtd) + '  ' + AnsiUpperCase(PREFIXO_ALERTA_ARQUIVOS_RZ_BLOCO_X) + ' PENDENTES DE TRANSMISSÃO AO FISCO. O CONTRIBUINTE PODE TRANSMITIR OS ARQUIVOS PELO MENU FISCAL POR MEIO DO COMANDO ''TRANSMITIR ARQUIVOS COM INFORMAÇÕES DA REDUÇÃO Z DO PAF-ECF''.';
      // Sandro Silva 2022-09-02
      //ATO DIAT Nº 46/2022 Result := 'HÁ  ' + IntToStr(iQtd) + '  ' + AnsiUpperCase(PREFIXO_ALERTA_ARQUIVOS_RZ_BLOCO_X) + ' PENDENTES DE TRANSMISSÃO AO FISCO. O CONTRIBUINTE PODE TRANSMITIR OS ARQUIVOS PELO MENU FISCAL POR MEIO DO COMANDO ''TRANSMITIR ARQUIVO REDUÇÃO Z ' + sDataPendencia + '''.';
      Result := '';
      // NOVAS REGRAS SOBRE BLOCO X DA ER 02.06 PARA SC – ATO DIAT Nº 011/2020
      // Art. 1º-A.
      case iQtd of
        1,2,3,4:
          Result := Result + ' ';
        5..1000000:
          // Sandro Silva 2022-09-05 Result := Result + #13 + 'VERIFIQUE COM O FORNECEDOR DO PROGRAMA A SOLUÇÃO DA PENDÊNCIA.';
      end;
    end; // if iQtd > 0 then
    Result := Trim(Result);
  end;

  function AlertaEstoque(iQtd: Integer; sDataPendencia: String): String; // Sandro Silva 2019-06-21 ER 02.06 function AlertaEstoque(iQtd: Integer): String;
  begin

    if iQtd > 0 then
    begin

      if Result <> '' then
        Result := Result + #13 + #13;

      // Sandro Silva 2022-09-02 ATO DIAT Nº 46/2022 Result := Result + 'HÁ  ' + IntToStr(iQtd) + '  ' + AnsiUpperCase(PREFIXO_ALERTA_ARQUIVOS_ESTOQUE_BLOCO_X) + ' PENDENTES DE TRANSMISSÃO AO FISCO. O CONTRIBUINTE PODE TRANSMITIR OS ARQUIVOS PELO MENU FISCAL POR MEIO DO COMANDO ''TRANSMITIR ARQUIVO ESTOQUE MENSAL ' + sDataPendencia + '''.';
      Result := '';

      // NOVAS REGRAS SOBRE BLOCO X DA ER 02.06 PARA SC – ATO DIAT Nº 011/2020
      // Art. 1º-A.
      case iQtd of
        1:
          Result := Result + ' ';
        2..1000000:
        begin
          // Sandro Silva 2022-09-02 ATO DIAT Nº 46/2022 Result := Result + #13 + 'VERIFIQUE COM O FORNECEDOR DO PROGRAMA A SOLUÇÃO DA PENDÊNCIA.';
          Result := '';
        end;
      end;

      Result := Trim(Result);

    end; // if iQtd > 0 then

    if CNAEDispensadoEnvioEstoque then // ATO DIAT 17 2017
      Result := '';
  end;
begin
  bBlocoxEstoquePendente := False; // Sandro Silva 2020-05-21
  bBlocoxRZPendente      := False; // Sandro Silva 2020-05-21

  try
  //ShowMessage('2748'); // Sandro Silva 2018-09-19
//      LogFrente('Arquivos da RZ PENDENTES: ' + FormatFloat('0', IBQBLOCOX.FieldByName('PENDENTE').AsInteger)  + ' ' + Emitente.UF + ' Perfil ' + Copy(Emitente.Configuracao.PerfilPAF,1,1), Emitente.Configuracao.DiretorioAtual);

    CriarCampoEcfsSerieIntervencao(IBTransaction); // Sandro Silva 2020-06-10

    ValidaEstruturaBancoBlocoX(IBTransaction);

    TrataErrosInternosServidorSEFAZ(Emitente, IBTransaction); // Sandro Silva 2019-06-18

     //LogFrente('Verificando existência de arquivos pendentes de transmissão', Emitente.Configuracao.DiretorioAtual);

     // Gera XML da reduções não encontradas no blocoX
     if sTipo = 'REDUCAO' then
     begin
       BXGeraXmlReducaoSemBlocoX(Emitente, IBTransaction);
     end;

    IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase); // Sandro Silva 2017-11-13  HOMOLOGA 2017 para ler os dados atualizados no banco por outra transação
    IBQBLOCOX := CriaIBQuery(IBTBLOCOX); // Sandro Silva 2017-11-13  HOMOLOGA 2017 para ler os dados atualizados no banco por outra transação IBQBLOCOX := CriaIBQuery(Form1.ibDataset88.Transaction); // Sandro Silva 2017-03-27  CriaIBQuery(Form1.IBQuery65.Transaction);

    if BXServidorSefazConfigurado(Emitente.UF) = False then
    begin

      //ShowMessage('Servidor não configurado 2767'); // Sandro Silva 2018-09-19

      if (sTipo = 'REDUCAO') or (sTipo = '') then
      begin

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 DATAREFERENCIA ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 // Sandro Silva 2019-08-28 ER 02.06 UnoChapeco ' or (coalesce(RECIBO, '''') <> '''') and (XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>0'' and XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''REDUCAO'' ';

        if sSerieECF <> '' then
          IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerieECF));
        IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA');
        IBQBLOCOX.Open;
        sDataPendencia := FormatDateTime('ddmmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select count(*) as PENDENTE ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 // Sandro Silva 2019-08-28 ER 02.06 UnoChapeco ' or (coalesce(RECIBO, '''') <> '''') and (XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>0'' and XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''REDUCAO'' ';

        if sSerieECF <> '' then
          IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerieECF));
        IBQBLOCOX.Open;

        if (sSerieECF <> '') or (bRetaguarda) then // Sandro Silva 2018-01-24  Não exbie mensagem alerta quando num.série ecf é vazio (transmitindo das demais ecf)
        begin
          sMensagemAlerta := AlertaRZ(IBQBLOCOX.FieldByName('PENDENTE').AsInteger, sDataPendencia); // Sandro Silva 2019-06-21 ER 02.06   sMensagemAlerta := AlertaRZ(IBQBLOCOX.FieldByName('PENDENTE').AsInteger);

          if (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'T') then // Sandro Silva 2019-06-25 ER 02.06 if (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'T') and (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'U') then // Sandro Silva 2017-11-10 Polimig
          begin
            if IBQBLOCOX.FieldByName('PENDENTE').AsInteger >= QTD_BLOQUEIO_XML_PENDENTE_RZ then // Sandro Silva 2018-10-18 if IBQBLOCOX.FieldByName('PENDENTE').AsInteger >= 10 then // Sandro Silva 2017-03-31  // Sandro Silva 2017-03-31
              bBlocoxRZPendente := False;
          end
          else
          begin
            bBlocoxRZPendente := False;
          end;
        end;
      end;

      if (sTipo = 'ESTOQUE') or (sTipo = '') then
      begin
        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 DATAREFERENCIA ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 // Sandro Silva 2019-08-28 ER 02.06 UnoChapeco ' or (coalesce(RECIBO, '''') <> '''') and (XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>0'' and XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''ESTOQUE'' ' +
          ' order by DATAREFERENCIA';
        IBQBLOCOX.Open;
        sDataPendencia := FormatDateTime('mmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select count(*) as PENDENTE ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 // Sandro Silva 2019-08-28 ER 02.06 UnoChapeco ' or (coalesce(RECIBO, '''') <> '''') and (XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>0'' and XMLRESPOSTA not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''ESTOQUE'' ';
        IBQBLOCOX.Open;

        if sMensagemAlerta <> '' then
          sMensagemAlerta := sMensagemAlerta + #13 + #13;
        sMensagemAlerta := sMensagemAlerta + AlertaEstoque(IBQBLOCOX.FieldByName('PENDENTE').AsInteger, sDataPendencia); // Sandro Silva 2019-06-21 ER 02.06 sMensagemAlerta := sMensagemAlerta + AlertaEstoque(IBQBLOCOX.FieldByName('PENDENTE').AsInteger);

        if IBQBLOCOX.FieldByName('PENDENTE').AsInteger >= QTD_BLOQUEIO_XML_PENDENTE_ESTOQUE then // Sandro Silva 2018-10-18 if IBQBLOCOX.FieldByName('PENDENTE').AsInteger >= 10 then // Sandro Silva 2017-03-31  // Sandro Silva 2017-03-31
          bBlocoxEstoquePendente := False;

      end;

    end
    else
    begin

  //ShowMessage('Servidor Configurado 2815'); // Sandro Silva 2018-09-19

      if (sTipo = 'REDUCAO') or (sTipo = '') then
      begin

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 DATAREFERENCIA ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''REDUCAO'' ';

        if sSerieECF <> '' then
          IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerieECF));
        IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA');
        IBQBLOCOX.Open;
        sDataPendencia := FormatDateTime('ddmmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select count(*) as PENDENTE ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''REDUCAO'' ';

        if sSerieECF <> '' then
          IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerieECF));
        IBQBLOCOX.Open;

        if (sSerieECF <> '') or (bRetaguarda) then // Sandro Silva 2018-01-24  Não exbie mensagem alerta quando num.série ecf é vazio (transmitindo das demais ecf)
        begin
          sMensagemAlerta := AlertaRZ(IBQBLOCOX.FieldByName('PENDENTE').AsInteger, sDataPendencia); // Sandro Silva 2019-06-21 ER 02.06 sMensagemAlerta := AlertaRZ(IBQBLOCOX.FieldByName('PENDENTE').AsInteger);

          if (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'T') then // Sandro Silva 2019-06-25 ER 02.06 if (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'T') and (Copy(Emitente.Configuracao.PerfilPAF,1,1) <> 'U') then // Sandro Silva 2017-11-10 Polimig
          begin

            //ShowMessage('Teste 01 45497'); // Sandro Silva 2017-11-10 Polimig
            // NOVAS REGRAS SOBRE BLOCO X DA ER 02.06 PARA SC – ATO DIAT Nº 011/2020
            // Art. 1º-A.
            bBlocoxRZPendente := False;
          end
          else
          begin
            bBlocoxRZPendente := False;
            //ShowMessage('Teste 01 45524'); // Sandro Silva 2017-11-10 Polimig
          end;
        end;
      end;

      if (sTipo = 'ESTOQUE') or (sTipo = '') then
      begin
        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 DATAREFERENCIA ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''ESTOQUE'' ' +
          ' order by DATAREFERENCIA';
        IBQBLOCOX.Open;
        sDataPendencia := FormatDateTime('mmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select count(*) as PENDENTE ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ''ESTOQUE'' ';
        IBQBLOCOX.Open;

        if sMensagemAlerta <> '' then
          sMensagemAlerta := sMensagemAlerta + #13 + #13;
        sMensagemAlerta := sMensagemAlerta + AlertaEstoque(IBQBLOCOX.FieldByName('PENDENTE').AsInteger, sDataPendencia); // Sandro Silva 2019-06-21 ER 02.06 sMensagemAlerta := sMensagemAlerta + AlertaEstoque(IBQBLOCOX.FieldByName('PENDENTE').AsInteger); // Sandro Silva 2017-08-11

        // NOVAS REGRAS SOBRE BLOCO X DA ER 02.06 PARA SC – ATO DIAT Nº 011/2020
        // Art. 1º-A.
        bBlocoxRZPendente := False;

      end;
    end;

    if (Copy(Emitente.Configuracao.PerfilPAF,1,1) = 'T') then // Sandro Silva 2019-06-25 ER 02.06  if (Copy(Emitente.Configuracao.PerfilPAF,1,1) = 'T') or (Copy(Emitente.Configuracao.PerfilPAF,1,1) = 'U') then // Sandro Silva 2017-11-10 Polimig
    begin
      bBlocoxRZPendente := False;
    end;

    if (sTipo = 'ESTOQUE') or (sTipo = '') then
      LogFrente('Arquivos do ESTOQUE PENDENTES: ' + FormatFloat('0', IBQBLOCOX.FieldByName('PENDENTE').AsInteger)  + ' ' + Emitente.UF + ' Perfil ' + Copy(Emitente.Configuracao.PerfilPAF,1,1), Emitente.Configuracao.DiretorioAtual);

    if (sTipo = 'REDUCAO') or (sTipo = '') then
      LogFrente('Arquivos da RZ PENDENTES: ' + FormatFloat('0', IBQBLOCOX.FieldByName('PENDENTE').AsInteger)  + ' ' + Emitente.UF + ' Perfil ' + Copy(Emitente.Configuracao.PerfilPAF,1,1), Emitente.Configuracao.DiretorioAtual);

    {Sandro Silva 2022-09-06 inicio}
    if IBQBLOCOX.FieldByName('PENDENTE').AsInteger > 0 then
    begin
      // Atualiza registros como RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO

      // Redução Z e Estoque
      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
               ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
        ' and DATAREFERENCIA < :DTINICIOOBRIGACAO';
        //' and ((TIPO = ''REDUCAO'' and DATAREFERENCIA < :DTINICIOOBRIGACAOREDUCAOZ) or (TIPO = ''ESTOQUE'' and DATAREFERENCIA < :DTINICIOOBRIGACAOESTOQUE))';
      //IBQBLOCOX.ParamByName('DTINICIOOBRIGACAOREDUCAOZ').AsDate := StrToDate(DATA_INICIAL_OBRIGATORIO_GERACAO_ARQUIVO_REDUCAO_Z);
      //IBQBLOCOX.ParamByName('DTINICIOOBRIGACAOESTOQUE').AsDate := StrToDate(DATA_FINAL_PRIMEIRO_PERIODO_OBRIGATORIO_ENVIO_ESTOQUE);
      IBQBLOCOX.ParamByName('DTINICIOOBRIGACAO').AsDate := StrToDate(DATA_INICIAL_OBRIGATORIO_GERACAO_ARQUIVO_REDUCAO_Z);
      IBQBLOCOX.Open;

      Retorno := TRetornoBlocoX.Create;
      while IBQBLOCOX.Eof = False do
      begin

        if (IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO') or
          ((IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE') and (IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime < StrToDate(DATA_FINAL_PRIMEIRO_PERIODO_OBRIGATORIO_ENVIO_ESTOQUE)))
        then
        begin

          Retorno.Recibo      := RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO;
          Retorno.XmlResposta := XmlRespostaPadraoSucessoBlocoX(RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO);

          BXSalvarReciboTransmissaoBanco(Emitente, IBTransaction, Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString);
          
        end;

        IBQBLOCOX.Next;
      end;

      FreeAndNil(Retorno);


    end;
    {Sandro Silva 2022-09-06 fim}

    if bExibirAlerta then
    begin
      if sMensagemAlerta <> '' then
      begin
        ShowMessage(PChar(sMensagemAlerta));
      end;
    end;

    FreeAndNil(IBTBLOCOX); // Create(nil);

    FreeAndNil(IBQBLOCOX); // Create(nil);

    // ATO DIAT 17 2017
    if CNAEDispensadoEnvioEstoque then
      bBlocoxEstoquePendente := False;

  except
    on E: Exception do
    begin

      LogFrente('Alerta XML pendentes: ' + Emitente.UF + ' Perfil ' + Copy(Emitente.Configuracao.PerfilPAF, 1, 1) + ' - ' + E.Message, Emitente.Configuracao.DiretorioAtual);

    end;
  end;

  // Conforme ATO DIAT Nº 46/2022 não precisa bloquear o PAF a partir de determinado número de pendências  
  Result := False; // Sandro Silva 2022-09-06 Result := (bBlocoxEstoquePendente) or (bBlocoxRZPendente);

  ChDir(Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2017-03-31

end;

function BXPermiteGerarXmlEstoque: Boolean;
begin
  Result := (DayOf(Date) <= 10);
end;

procedure BXDesconsideraXmlForaObrigatoriedade(IBTransaction1: TIBTransaction);
// Atualiza os registros da tabela BLOCOX para serem desconsiderados nas validações e transmissão quando sua data for inferior a data de início de obrigação de transmissão
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  sCnae: String;
begin

  IBTBLOCOX := CriaIBTransaction(IBTransaction1.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);
  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select CNAE, CGC ' +
      'from EMITENTE';
    IBQBLOCOX.Open;

    if LimpaNumero(IBQBLOCOX.FieldByName('CGC').AsString) <> '07426598000124' then
    begin
      sCnae := LimpaNumero(IBQBLOCOX.FieldByName('CNAE').AsString);

      // IX - a partir de 1º de março de 2020, os estabelecimentos enquadrados nos seguintes códigos da Classificação Nacional de Atividades Econômicas (CNAE):
      if (sCnae = '5611201')   // - Restaurantes e similares;
        or (sCnae = '5611202') // - Bares e outros estabelecimentos especializados em servir bebidas;
        or (sCnae = '5611203') // - Lanchonetes, casas de chá, de sucos e similares.
      then
      begin

        //Verifica se exitem registros para atualizar

        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 REGISTRO ' +
          'from BLOCOX ' +
          'where DATAREFERENCIA < ' + QuotedStr('2020-03-01') +
          ' and coalesce(RECIBO, '''') = '''' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'' ';
        IBQBLOCOX.Open;

        if IBQBLOCOX.FieldByName('REGISTRO').AsString <> '' then
        begin

          IBQBLOCOX.Close;
          IBQBLOCOX.SQL.Text :=
            'update BLOCOX set ' +
            'RECIBO = :RECIBO, ' +
            'XMLRESPOSTA = :XMLRESPOSTA ' +
            'where DATAREFERENCIA < ' + QuotedStr('2020-03-01') +
            ' and coalesce(RECIBO, '''') = '''' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'' ';
          IBQBLOCOX.ParamByName('RECIBO').AsString      := 'DATA MOVIMENTO ANTERIOR À DATA DE INÍCIO DA OBRIGAÇÃO';
          // Sandro Silva 2022-09-05 IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := '<SituacaoProcessamentoCodigo>1';
          IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoSucessoBlocoX(IBQBLOCOX.ParamByName('RECIBO').AsString);
          try
            IBQBLOCOX.ExecSQL;
            IBQBLOCOX.Transaction.Commit;
          except
            IBQBLOCOX.Transaction.Rollback;
          end;
        end;
      end; // if cnae bares/restaurantes

      //X - a partir de 1º de junho de 2020, os demais estabelecimentos enquadrados nos códigos da Classificação Nacional de Atividades Econômicas (CNAE) de Comércio Varejista.
      if (Pos(Copy(sCnae, 1, 3)+'|', '471|472|473|475|476|478|') > 0) and (sCnae <> '4711301') and (sCnae <> '4711302') then
      begin

        //Verifica se exitem registros para atualizar
        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select first 1 REGISTRO ' +
          'from BLOCOX ' +
          'where DATAREFERENCIA < ' + QuotedStr('2020-06-01') +
          ' and coalesce(RECIBO, '''') = '''' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'' ';
        IBQBLOCOX.Open;

        if IBQBLOCOX.FieldByName('REGISTRO').AsString <> '' then
        begin

          IBQBLOCOX.Close;
          IBQBLOCOX.SQL.Text :=
            'update BLOCOX set ' +
            'RECIBO = :RECIBO, ' +
            'XMLRESPOSTA = :XMLRESPOSTA ' +
            'where DATAREFERENCIA < ' + QuotedStr('2020-06-01') +
            ' and coalesce(RECIBO, '''') = '''' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'' ';
          IBQBLOCOX.ParamByName('RECIBO').AsString      := 'DATA MOVIMENTO ANTERIOR À DATA DE INÍCIO DA OBRIGAÇÃO';
          // Sandro Silva 2022-09-05 IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := '<SituacaoProcessamentoCodigo>1';
          IBQBLOCOX.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoSucessoBlocoX(IBQBLOCOX.ParamByName('RECIBO').AsString);
          try
            IBQBLOCOX.ExecSQL;
            IBQBLOCOX.Transaction.Commit;
          except
            IBQBLOCOX.Transaction.Rollback;
          end;
        end;
      end; // if cnae varegistas

    end;

  except

  end;
  FreeAndNil(IBQBLOCOX);
  FreeAndNil(IBTBLOCOX);
end;

function BXTransmitirPendenteBlocoX(DiretorioAtual: String; Emitente: TEmitente;
  IBTransaction1: TIBTransaction; sTipo: String; sSerieECF: String;
  bAlerta: Boolean = True): Integer;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  BlocoX: TServiceBlocoXBase;
  ArquivoXML: TArquivo;
  sArquivoXml: String;
  sDTReferencia: String; // Sandro Silva 2017-11-10 Polimig
  sSubjectName: String; // Sandro Silva 2018-02-05
  BXEstoque: TBlocoXEstoque; // Sandro Silva 2016-02-12
  BXReducaoZ: TBlocoXReducaoZ;
begin
  Result := 0; // Sandro Silva 2017-05-20

  BXDesconsideraXmlForaObrigatoriedade(IBTransaction1); // Sandro Silva 2020-02-28

  BXValidaFalhaNaGeracaoXML(Emitente, IBTransaction1); // Sandro Silva 2019-02-14

//ShowMessage('teste 3156');// Sandro Silva 2018-09-19

  LogFrente('Assinando XML ' + sTipo + ' sem assinatura digital', Emitente.Configuracao.DiretorioAtual);
  BXAssinaTodosXmlPendente(IBTransaction1, sTipo, DiretorioAtual); // Sandro Silva 2018-09-27 BXAssinaXmlPendente(IBTransaction1, sTipo);  // Sandro Silva 2018-02-14 Assinatura feita independente de ter servidor configurado

  //ShowMessage('teste 3160');// Sandro Silva 2018-09-19

  LogFrente('Checando configuração servidor ' + Emitente.UF, Emitente.Configuracao.DiretorioAtual);
  if BXServidorSefazConfigurado(Emitente.UF) then
  begin
    //
    // NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
    //

    sSubjectName := '';
    try
      sSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', ''); // BXReducaoZ.CertificadoSubjectName; // Sandro Silva 2018-02-06  BXEstoque.Certificado.SubjectName;
    except

    end;

    // Aceitar certificado da matriz nas filiais para assinar os xml A conferência do certificado digital é feito por meio do CNPJ raíz.
    if CertificadoPertenceAoEmitente(sSubjectName, Emitente.CNPJ) = False then
    begin
      LogFrente('Certificado com subjectName diferente do selecionado', Emitente.Configuracao.DiretorioAtual);
    end; // if (GetCNPJCertificado(BXEstoque.Certificado.SubjectName) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString)) then // Sandro Silva 2018-02-01

    Result := 1;

    BXReducaoZ := TBlocoXReducaoZ.Create(nil);
    BXEstoque  := TBlocoXEstoque.Create(nil);

    BXReducaoZ.UF := Emitente.UF;
    BXReducaoZ.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', ''); // 'CN=SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI:07426598000124, OU=Autenticado por AR EXXA, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, L=CONCORDIA, S=SC, O=ICP-Brasil, C=BR';

    BXEstoque.UF := Emitente.UF; // Sandro Silva 2018-09-21 IBQEMITENTE.FieldByName('ESTADO').AsString;
    BXEstoque.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', ''); // 'CN=SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI:07426598000124, OU=Autenticado por AR EXXA, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, L=CONCORDIA, S=SC, O=ICP-Brasil, C=BR';

    //
    // Não usar transações dos ibdataset
    //
    IBTSALVA  := CriaIBTransaction(IBTransaction1.DefaultDatabase);
    IBQSALVA  := CriaIBQuery(IBTSALVA);
    IBTBLOCOX := CriaIBTransaction(IBTransaction1.DefaultDatabase);
    IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);

    //BlocoX := TServiceBlocoXBase.Create(nil);// Sandro Silva 2017-03-31
    ArquivoXML := TArquivo.Create;

    try
      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        'where coalesce(RECIBO, '''') = '''' ' +
        ' and TIPO = ' + QuotedStr(sTipo);
      if (sTipo = 'REDUCAO') then // Sandro Silva 2017-11-10 Polimig   and (sSerieECF <> '') then
      begin
        if sSerieECF <> '' then
          IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerieECF));
      end;

      IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA'); // Sandro Silva 2018-09-27 IBQBLOCOX.SQL.Add(' order by DATAHORA');
      IBQBLOCOX.Open;
      while IBQBLOCOX.Eof = False do
      begin

        LogFrente('Selecionando dados para transmissão ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString + ' ' + FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);
//ShowMessage('teste 3221');// Sandro Silva 2018-09-19

        // Controlar quando mais de 1 aplicativo estiver transmitindo. Se transmitir 2x o mesmo arquivo causa erro na recepção por duplicidade
        // Vertifica se existem arquivos pendentes com data inferior ao que está sendo enviado
        IBQSALVA.Close;
        IBQSALVA.SQL.Text :=
          'select REGISTRO, DATAREFERENCIA, TIPO, SERIE, RECIBO ' +
          'from BLOCOX ' +
          'where (coalesce(RECIBO, '''') = '''' ' + // sem recibo ou com recibo e situacao diferente de aguardando e sucesso
                 ' or (coalesce(RECIBO, '''') <> '''') and (coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>0'' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'') ) ' +
          ' and TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
          ' and DATAREFERENCIA < ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));

        if IBQBLOCOX.FieldByName('SERIE').AsString <> '' then
          IBQSALVA.SQL.Add(' and coalesce(SERIE, '''') = ' + QuotedStr(IBQBLOCOX.FieldByName('SERIE').AsString));

        // Esta alteração normativa está publicada e não é mais necessário transmitir em ordem cronológica.
        //
        //Att,
        //Bruno Nogueira

        //Auditor Fiscal da Receita Estadual
        //Secretaria de Estado da Fazenda de Santa Catarina
        //Diretoria de Administração Tributária - DIAT
        //Gerência de Fiscalização - GEFIS
        IBQSALVA.SQL.Add(' and coalesce(REGISTRO, '''') = '''' '); // Remover essa linha se precisar ativar a regra de transmissão em ordem cronológica

        IBQSALVA.SQL.Add(' order by DATAREFERENCIA');

        //ShowMessage(IBQSALVA.SQL.Text);

        IBQSALVA.Open;

        if IBQSALVA.FieldByName('REGISTRO').AsString = '' then // Não encontrou arquivo com data anterior pendente
        begin

          sDTReferencia := FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime); // Sandro Silva 2017-11-10 Polimig

          sArquivoXml := DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('TIPO').AsString + IfThen(IBQBLOCOX.FieldByName('SERIE').AsString <> '', '_' + IBQBLOCOX.FieldByName('SERIE').AsString, '') + '_' + sDTReferencia + '.xml';
          ArquivoXML.Texto := IBQBLOCOX.FieldByName('XMLENVIO').AsString;

          ArquivoXML.SalvarArquivo(sArquivoXml);

          BXEstoque.EnvioEstoque.Retorno.Clear; // Sandro Silva 2017-03-31
          BXEstoque.EnvioReducaoZ.Retorno.Clear; // Sandro Silva 2017-03-31

          //ShowMessage('teste 3266');// Sandro Silva 2018-09-19

          if xmlNodeValue(ArquivoXML.Texto, '//Signature/SignatureValue') <> '' then // Sandro Silva 2018-01-30 Só transmitir se xml estiver assinado
          begin

            BXEstoque.EnvioEstoque.DTRefe  := sDTReferencia;
            BXEstoque.EnvioReducaoZ.DTRefe := sDTReferencia;
            BXEstoque.EnvioReducaoZ.ECF    := IBQBLOCOX.FieldByName('SERIE').AsString;

            {Sandro Silva 2022-09-05 inicio
            if IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then
            begin

              //ShowMessage('teste 3277');// Sandro Silva 2018-09-19
              BXEstoque.TransmitirBlocoX(Emitente.UF, 'ESTOQUE', sArquivoXml);
              BlocoX  := BXEstoque.EnvioEstoque;

              LogFrente('Transmitido arquivo ' + sArquivoXml, Emitente.Configuracao.DiretorioAtual);
              //ShowMessage('teste 3282');// Sandro Silva 2018-09-19

            end
            else
            begin
              if IBQBLOCOX.FieldByName('SERIE').AsString <> '' then
              begin
                BXReducaoZ.EnvioEstoque.DTRefe  := sDTReferencia;
                BXReducaoZ.EnvioReducaoZ.DTRefe := sDTReferencia;
                BXReducaoZ.EnvioReducaoZ.ECF    := IBQBLOCOX.FieldByName('SERIE').AsString;

                BXReducaoZ.TransmitirBlocoX(Emitente.UF, 'REDUCAO', sArquivoXml);
                BlocoX  := BXReducaoZ.EnvioReducaoZ;

                LogFrente('Transmitido arquivo ' + sArquivoXml, Emitente.Configuracao.DiretorioAtual);
              end;
            end;
            }

            //aqui tratar para não transmitir até que seja necessário
            //salvar sempre como sucesso se a data for inferior ao período obrigatório de transmissão 01/01/2023

            BlocoX := nil;

            if IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then
            begin

              //ShowMessage('teste 3277');// Sandro Silva 2018-09-19
              if IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime >= StrToDate(DATA_FINAL_PRIMEIRO_PERIODO_OBRIGATORIO_ENVIO_ESTOQUE) then
              begin

                BXEstoque.TransmitirBlocoX(Emitente.UF, 'ESTOQUE', sArquivoXml);

                LogFrente('Transmitido arquivo ' + sArquivoXml, Emitente.Configuracao.DiretorioAtual);
                //ShowMessage('teste 3282');// Sandro Silva 2018-09-19

              end
              else
              begin
                // Até 01/01/2023 não precisa enviar, trata como data anterior a obrigação
                BXEstoque.EnvioEstoque.Retorno.Recibo      := RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO;
                BXEstoque.EnvioEstoque.Retorno.XmlResposta := XmlRespostaPadraoSucessoBlocoX(RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO)
              end;
              BlocoX  := BXEstoque.EnvioEstoque;

            end
            else
            begin

              if IBQBLOCOX.FieldByName('SERIE').AsString <> '' then
              begin

                BXReducaoZ.EnvioEstoque.DTRefe  := sDTReferencia;
                BXReducaoZ.EnvioReducaoZ.DTRefe := sDTReferencia;
                BXReducaoZ.EnvioReducaoZ.ECF    := IBQBLOCOX.FieldByName('SERIE').AsString;

                // Sempre defini como sem recibo e xml de resposta
                BXReducaoZ.EnvioReducaoZ.Retorno.Recibo      := '';
                BXReducaoZ.EnvioReducaoZ.Retorno.XmlResposta := '';

                if IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime < StrToDate(DATA_INICIAL_OBRIGATORIO_GERACAO_ARQUIVO_REDUCAO_Z) then
                begin
                  // Até 01/01/2023 não precisa enviar, trata como data anterior a obrigação
                  BXReducaoZ.EnvioReducaoZ.Retorno.Recibo      := RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO;
                  BXReducaoZ.EnvioReducaoZ.Retorno.XmlResposta := XmlRespostaPadraoSucessoBlocoX(RECIBO_PADRAO_DATA_REFERENCIA_ANTES_INICIO_OBRIGACAO);

                end;

                // ATO DIAT Nº 46/2022 desobriga o envio
                // BXReducaoZ.TransmitirBlocoX(Emitente.UF, 'REDUCAO', sArquivoXml);

                BlocoX  := BXReducaoZ.EnvioReducaoZ;

                LogFrente('Transmitido arquivo ' + sArquivoXml, Emitente.Configuracao.DiretorioAtual);

              end;

            end;

            if BlocoX <> nil then
            begin

              if (xmlNodeValue(BlocoX.Retorno.XmlResposta, '//SituacaoProcessamentoCodigo') = '1') then // 1: Sucesso
              begin
                Result := 0
              end
              else
              begin
                Result := 1;

              end;

              DeleteFile(Pchar(sArquivoXml));

              LogFrente('Salvando recibo ' + BlocoX.Retorno.XmlResposta, Emitente.Configuracao.DiretorioAtual);
              BXSalvarReciboTransmissaoBanco(Emitente, IBTransaction1, BlocoX.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString); // Sandro Silva 2019-12-11 BXSalvarReciboTransmissaoBanco(IBTransaction1, BlocoX.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString);

              //ShowMessage('Teste 01 3782'); // Sandro Silva 2018-11-23

              if Result > 0 then
              begin
                if sSerieECF <> '' then // Sandro Silva 2018-01-31 Consultando xml do ECF conectado
                  Break; // Não transmitiu para o envio
              end;

            end;

          end; // if xmlNodeValue(ArquivoXML.Texto, '//Signature/SignatureValue') = '' then

        end
        else
        begin

          LogFrente('Outro arquivo pendente ' + IBQSALVA.FieldByName('TIPO').AsString + ' ' + IBQSALVA.FieldByName('SERIE').AsString + ' ' + FormatDateTime('dd/mm/yyyy', IBQSALVA.FieldByName('DATAREFERENCIA').AsDateTime) + ' ' + IBQSALVA.FieldByName('RECIBO').AsString, Emitente.Configuracao.DiretorioAtual);

        end; // if IBQSALVA.FieldByName('REGISTRO').AsString = '' then

        IBQSALVA.Transaction.Rollback; // Sandro Silva 2018-01-30

        IBQBLOCOX.Next;

        //ShowMessage('Teste 01 3809'); // Sandro Silva 2018-11-23

      end; // while IBQ.Eof = False do
      Sleep(500); // Sandro Silva 2020-05-20 Sleep(2000);

      //ShowMessage('Teste 01 3815'); // Sandro Silva 2018-11-23

    finally
      if sTipo = 'REDUCAO' then
      begin
        if sSerieECF <> '' then // Sandro Silva 2018-01-31 Consultando xml do ECF conectado
        begin
          if Result = 0 then
          begin
            // Sandro Silva 2022-09-06 Application.MessageBox(PChar(PREFIXO_ALERTA_ARQUIVOS_RZ_BLOCO_X + ' transmitido(s) com sucesso.'), 'Atenção', MB_ICONINFORMATION + MB_OK);
          end
          else
          begin
            if bAlerta then // Sandro Silva 2018-01-31
              BXAlertarXmlPendente(Emitente, IBTransaction1, sTIPO, sSerieECF, True);
          end;
        end;
      end;
      FreeAndNil(IBQSALVA);
      FreeAndNil(IBTSALVA);
      FreeAndNil(IBQBLOCOX);
      FreeAndNil(IBTBLOCOX);

      //ShowMessage('Teste 01 3850'); // Sandro Silva 2018-11-23

      FreeAndNil(ArquivoXML); // Sandro Silva 2019-06-19 ArquivoXML.Free;

      //ShowMessage('Teste 01 3856'); // Sandro Silva 2018-11-23

      //if BlocoX <> nil then
      // Causa erro se limpar da memória. Identificar e corrigir  BlocoX.Free;

      //ShowMessage('Teste 01 3859'); // Sandro Silva 2018-11-23
    end;           

  end;

  ChDir(DiretorioAtual); // Sandro Silva 2017-03-31
end;

function BXConsultarRecibo(Emitente: TEmitente; IBTransaction: TIBTransaction;
  DiretorioAtual: String; sRecibo: String): Boolean;
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  blocoxConsulta: TBlocoXConsultarProcessamentoArquivo; // Sandro Silva 2019-07-18
  ArqConsulta: TArquivo; // Sandro Silva 2019-07-18
  sSubjectName: String;
begin

//ShowMessage('teste 1 etapa configuração'); // Sandro Silva 2020-03-13

  if BXServidorSefazConfigurado(Emitente.UF) then
  begin

    IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase);
    IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);

    blocoxConsulta := TBlocoXConsultarProcessamentoArquivo.Create(Application);
    ArqConsulta    := TArquivo.Create; // Sandro Silva 2019-07-18
    blocoxConsulta.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');

    sSubjectName := '';
    try
      sSubjectName := blocoxConsulta.CertificadoSubjectName; // Sandro Silva 2018-02-05  blocoxConsulta.Certificado.SubjectName;
    except

    end;

    if CertificadoPertenceAoEmitente(sSubjectName, Emitente.CNPJ) then// Sandro Silva 2020-03-13  if (AnsiContainsText(sSubjectName, LimpaNumero(Emitente.CNPJ))) then
    begin

      IBQBLOCOX.Close;
      if sRecibo = '' then
        IBQBLOCOX.SQL.Text :=
          'select * ' +
          'from BLOCOX ' +
          'where ((coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>0'') or (coalesce(XMLRESPOSTA, '''') containing ''<SituacaoOperacaoCodigo>1'' and coalesce(XMLRESPOSTA, '''') not containing ''<SituacaoOperacaoDescricao>Sucesso'') )' + // Aguardando
          ' and coalesce(RECIBO, '''') <> '''' ' + // tem recibo
          ' and DATAHORA <= cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd HH:nn:ss', IncMinute(Now, -INTERVALO_PARA_CONSULTA))) + ' as timestamp) ' + // XML enviados a mais de 5 minutos
          ' order by DATAREFERENCIA' // Sandro Silva 2018-09-27 ' order by DATAHORA'
      else
        IBQBLOCOX.SQL.Text :=
          'select * ' +
          'from BLOCOX ' +
          'where coalesce(RECIBO, '''') = ' + QuotedStr(sRecibo);

      IBQBLOCOX.Open;

      while IBQBLOCOX.Eof = False do
      begin

        if IBQBLOCOX.FieldByName('RECIBO').AsString <> '' then
        begin
          try

            ArqConsulta.Texto := Format(XML_CONSULTAR_PROCESSAMENTO_ARQUIVO, [IBQBLOCOX.FieldByName('RECIBO').AsString]);
            blocoxConsulta.Xml := ArqConsulta.Texto;
//ShowMessage('teste 1 etapa assina xml consulta'); // Sandro Silva 2020-03-13
            blocoxConsulta.AssinaXML;

//ShowMessage('teste 1 etapa salva log xml consulta'); // Sandro Silva 2020-03-13

            blocoxConsulta.SalvaArquivo(DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_consultarprocessamentoarquivo.xml');

            blocoxConsulta.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');
            blocoxConsulta.GetCertificado(False);

//ShowMessage('teste 1 etapa envio consulta'); // Sandro Silva 2020-03-13

            blocoxConsulta.ConsultarProcessamentoArquivo.MimeType         := 'text/xml';
            blocoxConsulta.ConsultarProcessamentoArquivo.Charsets         := 'utf-8';
            blocoxConsulta.ConsultarProcessamentoArquivo.EncodeDataToUTF8 := True;
            blocoxConsulta.ConsultarProcessamentoArquivo.UF               := Emitente.UF;
            blocoxConsulta.ConsultarProcessamentoArquivo.Servico          := 'ConsultarProcessamentoArquivo'; //'Consultar';
            blocoxConsulta.ConsultarProcessamentoArquivo.Recibo           := IBQBLOCOX.FieldByName('RECIBO').AsString;
            blocoxConsulta.ConsultarProcessamentoArquivo.XmlFile          := DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_consultarprocessamentoarquivo.xml';
            blocoxConsulta.ConsultarProcessamentoArquivo.Enviar;
            {Sandro Silva 2019-07-18 fim}

//ShowMessage('teste 1 etapa salva log consulta'); // Sandro Silva 2020-03-13
            LogFrente('Consultou recibo ' + IBQBLOCOX.FieldByName('RECIBO').AsString + ' - ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IfThen(IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO', ' ' + IBQBLOCOX.FieldByName('SERIE').AsString, '') + FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);

//ShowMessage('teste 1 etapa salva recibo consulta'); // Sandro Silva 2020-03-13
            BXSalvarReciboTransmissaoBanco(Emitente, IBTransaction, blocoxConsulta.ConsultarProcessamentoArquivo.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString); // Sandro Silva 2019-12-11 BXSalvarReciboTransmissaoBanco(IBTransaction, blocoxConsulta.ConsultarProcessamentoArquivo.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString);

          except

          end;
        end;

        IBQBLOCOX.Next;

      end;

    end; // if (GetCNPJCertificado(blocoxConsulta.Certificado.SubjectName) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString)) then // Sandro Silva 2018-02-01

    blocoxConsulta.Free;
    FreeAndNil(ArqConsulta); // Sandro Silva 2019-07-18

    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);

  end; // if BlocoXServidorConfigurado then

  ChDir(DiretorioAtual); // Sandro Silva 2017-03-31
  Result := True; // Sandro Silva 2018-06-28

end;

procedure BXRestaurarArquivos(IBTransaction1: TIBTransaction;
  DiretorioAtual: String; sTipo: String;
  sSerieECF: String; bApenasUltimo: Boolean = False);
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBQBLOCOX: TIBQuery;
  ArqXml: TArquivo;
  sNomeArquivoXmlSalvo: String;
  sDataReferencia: String;
  sDataReferenciaFinal: String;
  sPerfilPAF: String;
begin
  sPerfilPAF := Copy(PerfilPAF(CHAVE_CIFRAR), 1, 1);
  if (sPerfilPAF = 'T') or (sPerfilPAF = 'V') or (sPerfilPAF = 'W') then // Sandro Silva 2019-08-06
  begin

    CriaDiretoriosBlocoX;

    if ((sSerieECF <> '') and (AnsiContainsText(sTipo, 'REDUCAO')))
      or (AnsiContainsText(sTipo, 'ESTOQUE')) then
    begin

      IBQBLOCOX := CriaIBQuery(IBTransaction1);// Sandro Silva 2017-03-27  CriaIBQuery(Form1.ibDataSet27.Transaction);
      ArqXml := TArquivo.Create;
      try
        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'select * ' +
          'from BLOCOX ';
        if AnsiContainsText(sTipo, 'ESTOQUE') then
          IBQBLOCOX.SQL.Add(' where TIPO = ''ESTOQUE'' ');

        if AnsiContainsText(sTipo, 'REDUCAO') then
          IBQBLOCOX.SQL.Add(' where TIPO = ''REDUCAO'' and SERIE = ' + QuotedStr(sSerieECF) + ' ');

        if AnsiContainsText(sTipo, 'RECIBO') then
          IBQBLOCOX.SQL.Add(' and coalesce(RECIBO, '''') <> '''' ');

        if bApenasUltimo then
          IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA desc ')
        else
          IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA');

        IBQBLOCOX.Open;

        while IBQBLOCOX.Eof = False do
        begin

          if Trim(IBQBLOCOX.FieldByName('XMLENVIO').AsString) <> '' then
          begin

            if AnsiContainsText(sTipo, 'REDUCAO') then
            begin
              sDataReferencia := LimpaNumero(xmlNodeValue(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '//DadosReducaoZ/DataReferencia'));
              if sDataReferencia <> '' then
              begin
                ArqXml.Texto         := IBQBLOCOX.FieldByName('XMLENVIO').AsString;
                sNomeArquivoXmlSalvo := PASTA_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + sSerieECF + '_' + sDataReferencia + '.xml';
                ArqXml.SalvarArquivo(sNomeArquivoXmlSalvo);
              end;
            end;

            if AnsiContainsText(sTipo, 'ESTOQUE') then
            begin

              sDataReferenciaFinal   := LimpaNumero(xmlNodeValue(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '//DadosEstoque/DataReferencia'));
              sDataReferenciaFinal   := Copy(sDataReferenciaFinal, 5, 2) + Copy(sDataReferenciaFinal, 1, 4); // Sandro Silva 2019-06-21 ER 02.06

              if (sDataReferenciaFinal <> '') then // Sandro Silva 2019-06-21 ER 02.06 if (sDataReferenciaInicial <> '') and (sDataReferenciaFinal <> '') then
              begin
                ArqXml.Texto         := IBQBLOCOX.FieldByName('XMLENVIO').AsString;
                sNomeArquivoXmlSalvo := PASTA_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + sDataReferenciaFinal + '.xml'; // Sandro Silva 2019-06-21 ER 02.06 sNomeArquivoXmlSalvo := PASTA_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + sDataReferenciaInicial + '_' + sDataReferenciaFinal + '.xml';
                ArqXml.SalvarArquivo(sNomeArquivoXmlSalvo);
              end;
            end;

          end;

          if (IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString <> '')
            then
          begin

            sNomeArquivoXmlSalvo := ''; // Sandro Silva 2018-10-17

            if IBQBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then
            begin
              sDataReferenciaFinal   := FormatDateTime('mmyyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime);

              if (sDataReferenciaFinal <> '') then
              begin
                sNomeArquivoXmlSalvo := PASTA_RECIBOS_ESTOQUE_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_ESTOQUE_BLOCO_X + sDataReferenciaFinal;
              end;
            end;

            if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
            begin
              sDataReferencia := LimpaNumero(xmlNodeValue(IBQBLOCOX.FieldByName('XMLENVIO').AsString, '//DadosReducaoZ/DataReferencia'));
              sNomeArquivoXmlSalvo := PASTA_RECIBOS_REDUCOES_BLOCO_X + '\' + PREFIXO_ARQUIVOS_XML_RZ_BLOCO_X + sSerieECF + '_' + sDataReferencia;
            end;

            if IBQBLOCOX.FieldByName('RECIBO').AsString <> '' then
              sNomeArquivoXmlSalvo := sNomeArquivoXmlSalvo + '_Recibo_' + IBQBLOCOX.FieldByName('RECIBO').AsString;
            sNomeArquivoXmlSalvo := sNomeArquivoXmlSalvo + '.xml';
            ArqXml.Texto         := IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString;
            ArqXml.SalvarArquivo(sNomeArquivoXmlSalvo);

          end;

          IBQBLOCOX.Next;
        end;

      except

      end;
      FreeAndNil(ArqXml); // Sandro Silva 2019-06-19 ArqXml.Free;
      FreeAndNil(IBQBLOCOX);
    end;
    ChDir(DiretorioAtual); // Sandro Silva 2017-03-31
  end; //   if (sPerfilPAF = 'T') or (sPerfilPAF = 'V') or (sPerfilPAF = 'W') then // Sandro Silva 2019-08-06

end;

function BXValidaCertificadoDigital(sCNPJ: String): Boolean;
var
  BXReducaoZ: TBlocoXReducaoZ;
begin
  Result := True;
  try

    BXReducaoZ := TBlocoXReducaoZ.Create(nil);

    BXReducaoZ.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');

    if BXReducaoZ.CertificadoSubjectName <> '' then
    begin

      if (AnsiContainsText(BXReducaoZ.CertificadoSubjectName, Copy(LimpaNumero({EMITENTE.CNPJ}sCNPJ), 1, 8)) = False) then
      begin
        Application.ProcessMessages;
        Application.BringToFront;

        Result := False;

        //
        Application.MessageBox(PAnsiChar('O certificado digital selecionado não pertence a empresa ' + {Emitente.CNPJ} sCNPJ +
                               #13 + #13 + BXReducaoZ.CertificadoSubjectName),
                                    'Atenção', MB_ICONWARNING + MB_OK);
      end;

    end
    else
      Result := False;

    if BXReducaoZ.Certificado <> nil then
    begin
      if StrToDate(FormatDateTime('dd/mm/yyyy', BXReducaoZ.Certificado.ValidToDate)) < StrToDate(FormatDateTime('dd/mm/yyyy', Date)) then
      begin
        Application.ProcessMessages;
        Application.BringToFront;

        Result := False;

        //
        Application.MessageBox(PAnsiChar('O certificado digital selecionado expirou em ' + FormatDateTime('dd/mm/yyyy', BXReducaoZ.Certificado.ValidToDate) +
                             #13 + #13 + BXReducaoZ.CertificadoSubjectName),
                                    'Atenção', MB_ICONWARNING + MB_OK);

      end;
    end;
  except
    Result := False;
  end;
  FreeAndNil(BXReducaoZ);
end;

function CNAEDispensadoEnvioEstoque: Boolean;
begin
  // ATO DIAT 17 2017: Especificamente os restaurantes, bares e similares deverão iniciar a transmissão dos arquivos eletrônicos em 01 de junho de 2019.
  // A transmissão mensal do arquivo eletrônico do Estoque continua dispensada para os restaurantes, bares e similares, conforme regra disposta no próprio Ato COTEPE ICMS 09/2013, desde que utilizem aplicativo específico.
  Result := (LerParametroIni('Frente.ini', 'Frente de Caixa', 'Dispensado do Envio do Estoque', 'Não') = 'Sim');
end;

function BXSelecionarCertificadoDigital: String;
var
  BX1: TBlocoXReducaoZ;
begin
  BX1 := TBlocoXReducaoZ.Create(nil);
  try

    BX1.GetCertificado(True);
    Result := BX1.CertificadoSubjectName;

    GravarParametroIni('Frente.ini', 'Frente de caixa', 'Certificado', Result);

  except

  end;
  FreeAndNil(BX1);
end;

procedure LogAuditoria(IBTransaction1: TIBTransaction; Ato: String;
  Modulo: String; Historico: String; Data: TDate; Hora: String);
// Salva log na auditoria do banco
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
begin
  {Sandro Silva 2019-02-15 inicio}
  IBTBLOCOX := CriaIBTransaction(IBTransaction1.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);

  try
      //Registra na auditoria
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'insert into AUDIT0RIA (ATO, MODULO, USUARIO, HISTORICO, DATA, HORA, REGISTRO) ' +
      'values (:ATO, :MODULO, null, :HISTORICO, :DATA, :HORA, right(''0000000000''||gen_id(G_AUDIT0RIA, 1), 10))';
    IBQBLOCOX.ParamByName('ATO').AsString       := Ato;
    IBQBLOCOX.ParamByName('MODULO').AsString    := Modulo;
    IBQBLOCOX.ParamByName('HISTORICO').AsString := Historico;
    IBQBLOCOX.ParamByName('DATA').AsDate        := Data;
    IBQBLOCOX.ParamByName('HORA').AsString      := Hora;
    IBQBLOCOX.ExecSQL;
    IBQBLOCOX.Transaction.Commit;
  except
    IBQBLOCOX.Transaction.RollBack;
  end;
  FreeAndNil(IBQBLOCOX);
  FreeAndNil(IBTBLOCOX);

end;

function BXValidaFalhaNaGeracaoXML(Emitente: TEmitente; IBTransaction1: TIBTransaction): Boolean;
// Valida se o processo de geração iniciado foi finalizado corretamente
var
  dtDataReferenciaFim: TDate;
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  sSerieECF: String;
  sDatareferencia: String;
begin
  IBTBLOCOX := CriaIBTransaction(IBTransaction1.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);

  try
    // Verifica se a geração do último xml do estoque foi concluída
    sDatareferencia := LerParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Referencia', '');

    if (sDatareferencia <> '') and (Copy(sDatareferencia, 1, 5) <> '31/12') then
    begin
      // Desconsiderar se for de período diferente de Dezembro
      sDatareferencia := '';
      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Referencia', '');
      GravarParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', '');
    end;

    if sDatareferencia <> '' then // Não finalizou corretamente a rotina de geração do xml do estoque
    begin

      dtDataReferenciaFim := StrToDate(sDatareferencia);

      //ShowMessage('Teste 01 xml estoque pendente ' + sDatareferencia); // Sandro Silva 2019-02-15

      //Registra na auditoria
      LogAuditoria(IBTransaction1, 'BLOCOX', 'FRENTE', 'Interrompeu geração do XML do Estoque ' + sDatareferencia, StrToDateDef(Copy(LerParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', ''), 1, 10), Date), Copy(LerParametroIni('ENERGIA.INI', 'XML Estoque', 'Data Emissao', ''), 12, 8));

      // Consulta se existe no banco o xml referente ao período
      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select DATAREFERENCIA ' +
        'from BLOCOX ' +
        'where TIPO = ''ESTOQUE'' ' +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', dtDataReferenciaFim));
      IBQBLOCOX.Open;

      if IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString = '' then // Não encontrou no banco o xml para enviar
      begin
        //ShowMessage('Teste 01 gera xml estoque ' + sDatareferencia); // Sandro Silva 2019-02-15
        BXGeraXmlEstoquePeriodo(Emitente, IBTransaction1, dtDataReferenciaFim, dtDataReferenciaFim, True, True, True, True);
      end;

    end;

    // Verifica se a última geração do xml da redução z foi conclída
    sSerieECF := LerParametroIni('ENERGIA.INI', 'XML Reducao', 'ECF', '');
    if sSerieECF <> '' then  // Não finalizou corretamente a rotina de geração do xml da reducao
    begin
      sDatareferencia := LerParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Referencia', '');

      //ShowMessage('Teste 01 xml da reducao pendente ' + sDatareferencia); // Sandro Silva 2019-02-15

      //Registra na auditoria
      LogAuditoria(IBTransaction1, 'BLOCOX', 'FRENTE', 'Interrompeu geração do XML da Redução Z ' + sSerieECF + ' ' + sDatareferencia,  StrToDateDef(Copy(LerParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Emissao', ''), 1, 10), Date), Copy(LerParametroIni('ENERGIA.INI', 'XML Reducao', 'Data Emissao', ''), 12, 8));

      // Consulta se existe no banco o xml referente ao período
      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select DATAREFERENCIA ' +
        'from BLOCOX ' +
        'where TIPO = ''REDUCAO'' ' +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(sDatareferencia))) +
        ' and SERIE = ' + QuotedStr(sSerieECF);
      IBQBLOCOX.Open;

      if IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString = '' then // Não encontrou no banco o xml para enviar
      begin

        //ShowMessage('Teste 01 gera xml reducao ' + sDatareferencia); // Sandro Silva 2019-02-15

        BXGeraXmlReducaoZ(Emitente,
                          IBTransaction1,
                          sSerieECF,
                          sDatareferencia, True, True, True);
      end;
    end;

  except

  end;
  FreeAndNil(IBQBLOCOX);
  FreeAndNil(IBTBLOCOX);
  Result := True;
end;

function BXConsultarPendenciasDesenvolvedorPafEcf(
  Emitente: TEmitente): Boolean;
var
  blocoxConsulta: TBlocoXConsultarPendenciasDesenvolvedorPafEcf;
  sCNPJDesenvolvedor: String;
  XMLNFE: IXMLDOMDocument;
  iNode: Integer;
  xNodeItens: IXMLDOMNodeList;
  sXml: String;
  slHtml : TStringList;
  sArquivoHtml: String;
  sArquivoConsulta: String;
begin
  Result := False;
  try
    sCNPJDesenvolvedor := '07426598000124';
    if Pos(sCNPJDesenvolvedor, LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '')) > 0 then // Sandro Silva 2019-05-07  if Pos(sCNPJDesenvolvedor, BXSelecionarCertificadoDigital) > 0 then
    begin
      //ShowMessage('Servidor estava instável. Testar a partir de ');
      blocoxConsulta := TBlocoXConsultarPendenciasDesenvolvedorPafEcf.Create(nil);

      with TArquivo.Create do
      begin
        Texto := BLOCOX_ESPECIFICACAO_XML +
          '<ConsultarPendenciasDesenvolvedorPafEcf Versao="1.0">' +
            '<Mensagem>' +
                '<CNPJ>' + sCNPJDesenvolvedor + '</CNPJ>' +
            '</Mensagem>' +
            '<Signature />' + // Precisa existir para saber onde adicionar elementos da assinatura
          '</ConsultarPendenciasDesenvolvedorPafEcf>';

        blocoxConsulta.Xml := Texto;
        blocoxConsulta.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');
        blocoxConsulta.GetCertificado(True);
        blocoxConsulta.AssinaXML;

        sArquivoConsulta := DiretorioLogBlocoX + '\consultarpendenciasdesenvolvedorpafecf_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.xml';
        blocoxConsulta.SalvaArquivo(sArquivoConsulta);
        Free;
      end;

      blocoxConsulta.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');
      blocoxConsulta.GetCertificado(False);

      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.MimeType            := 'text/xml';
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.Charsets            := 'utf-8';
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.EncodeDataToUTF8    := True;
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.UF                  := Emitente.UF;
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.Servico             := 'ConsultarPendenciasDesenvolvedorPafEcf';
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.CNPJDesenvolvedor   := sCNPJDesenvolvedor;
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.XmlFile             := sArquivoConsulta;
      blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.Enviar;
      sXml := blocoxConsulta.ConsultarPendenciasDesenvolvedorPafEcf.Retorno.XmlResposta;

      // Gera html a partir do xml de retorno da consulta
      try
        sXml := StringReplace(sXml, '<?xml version="1.0" encoding="utf-8"?>', '<?xml version="1.0" encoding="iso-8859-1"?>', [rfReplaceAll]); // Retorno possui caracteres especiais (éô) e UTF-8 não permite

        XMLNFE := CoDOMDocument.Create;
        XMLNFE.loadXML(sXml);

        slHtml := TStringList.Create;

        slHtml.Add('<HTML>');
        slHtml.Add('<HEAD><TITLE>Pendências com Bloco X do PAF-ECF</TITLE>');

        slHtml.Add('<style>');
        slHtml.Add('body{                        ');
        slHtml.Add('font-family: Verdana;        ');
        slHtml.Add('font-size: 10px;             ');
        slHtml.Add('}                            ');
        slHtml.Add('table{                       ');
        slHtml.Add('border: 1px solid;           ');
        slHtml.Add('border-color: #D0D0D0;       ');
        slHtml.Add('border-collapse: collapse;   ');
        slHtml.Add('cellpadding: 2;              ');
        slHtml.Add('cellspacing: 2;              ');
        slHtml.Add('font-size: 10px;             ');
        slHtml.Add('}                            ');
        slHtml.Add('th{                          ');
        slHtml.Add('background-color:#32B1EA;    ');
        slHtml.Add('color:#FFFFFF;               ');
        slHtml.Add('}                            ');
        slHtml.Add('td{                          ');
        slHtml.Add('height:20px;                 ');
        slHtml.Add('border:1px solid;            ');
        slHtml.Add('border-color: #D0D0D0;       ');
        slHtml.Add('margin-left:5;               ');
        slHtml.Add('margin-right:10;             ');
        slHtml.Add('white-space: nowrap;         ');
        slHtml.Add('}                            ');
        slHtml.Add('</style>');
        slHtml.Add('</HEAD>');
        slHtml.Add('<BODY style=text-align:center>');
        slHtml.Add('<font Face=verdana size=2 color=#000000><b>Empresas pendentes com Bloco X do PAF-ECF</b>');
        slHtml.Add('<br><br>');

        slHtml.Add('<table>');

        slHtml.Add('<tr>');
          slHtml.Add('<th>IE</th>');
          slHtml.Add('<th>Nome empresa</th>');
          slHtml.Add('<th>Pendências</th>');
          slHtml.Add('<th>Avisos</th>');
        slHtml.Add('</tr>');

        xNodeItens := XMLNFE.selectNodes('//Estabelecimento');
        if xNodeItens.length > 0 then
        begin

          for iNode := 0 to xNodeItens.length -1 do
          begin
             slHtml.Add('<tr>');
               slHtml.Add('<td>' + xmlNodeValue(xNodeItens.item[iNode].xml, '//IE') + '</td>');
               slHtml.Add('<td>' + xmlNodeValue(xNodeItens.item[iNode].xml, '//NomeEmpresarial') + '</td>');
               slHtml.Add('<td>' + xmlNodeValue(xNodeItens.item[iNode].xml, '//QuantidadePendencias') + '</td>');
               slHtml.Add('<td>' + xmlNodeValue(xNodeItens.item[iNode].xml, '//QuantidadeAvisos') + '</td>');
             slHtml.Add('</tr>');
          end; // for iNode := 0 to xNodeItens.length -1 do

        end; // if xNodeItens.length > 0 then

        slHtml.Add('</table>');
        slHtml.Add('<BR><BR><BR><p align=center> <font face=verdana size=1 color=#0000FF><b>' + IntToStr(xNodeItens.length) + '</b> Registros</font>');
        slHtml.Add('<br>');
        slHtml.Add('<p align=center> <font face=verdana size=1 color=#0000FF>Smallsoft ' + FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + '</BODY></HTML>');

        if ForceDirectories(DiretorioLogBlocoX) then
        begin
          sArquivoHtml := DiretorioLogBlocoX + '\consultarpendenciasdesenvolvedorpafecf_' + FormatDateTime('dd-mm-yyyy-HH-nn-ss-zzz', Now) + '.html';
          slHtml.SaveToFile(sArquivoHtml);
          //Screen.Cursor := crDefault;
          ShellExecute( 0, 'Open', PChar(sArquivoHtml), '', '', SW_SHOWMAXIMIZED);
        end;

      finally
        XMLNFE := nil;
        if xNodeItens <> nil then
          xNodeItens := nil; // Sandro Silva 2019-06-19
      end;

      FreeAndNil(blocoxConsulta); // Sandro Silva 2019-06-19 blocoxConsulta.Free; 
      FreeAndNil(slHtml);

      Result := True;
    //<?xml version="1.0" encoding="utf-8"?>
    //<?xml version="1.0" encoding="iso-8859-1"?>
    end;
  except

  end;
end;

procedure ConcatenaLogXml(var sLog: String; sTexto: String);
// Concatena log em string para exibição após a geração
begin
  if sLog <> '' then
    sLog := sLog + #13 + #10;
  sLog := sLog + sTexto;
end;

procedure BXExibeAlertaErros(Emitente: TEmitente; sTipo: String;
  IBTransaction: TIBTransaction);
// Exibe no bloco de notas o alerta com erros que estão impedindo a recepção dos xml
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  IBQESTOQUE: TIBQuery;
  sMensagemRetorno: String;
  sLog: String;
begin
  IBTBLOCOX  := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQBLOCOX  := CriaIBQuery(IBTBLOCOX);
  IBQESTOQUE := CriaIBQuery(IBTBLOCOX);

  IBQBLOCOX.Close;
  IBQBLOCOX.SQL.Text :=
    'select * ' +
    'from BLOCOX ' +
    'where TIPO = ' + QuotedStr(sTipo) +
    ' and (coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>2</SituacaoProcessamentoCodigo>'' ' +
      '  or coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>3</SituacaoProcessamentoCodigo>'') ' +
    ' order by DATAREFERENCIA';
  IBQBLOCOX.Open;

  sLog := '';
  while IBQBLOCOX.Eof = False do
  begin

    try
      sMensagemRetorno := Trim(xmlNodeValue(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//Mensagem'));

      if sMensagemRetorno = '' then
        sMensagemRetorno := Trim(xmlNodeValue(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//SituacaoProcessamentoDescricao'));

      if AnsiContainsText(sMensagemRetorno, 'Erro 3020') then  // Verifica se o código GTIN informado é válido
      begin
        ConcatenaLogXml(sLog, '- Erro 3020 Existe código de barra inválido no cadastro de produtos: ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 3021') then  // Verifica se o código CEST informado é válido
      begin
        ConcatenaLogXml(sLog, '- Erro 3021 Existe CEST inválido no cadastro de produtos: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 3022') then  // Verifica se o código CEST está dentro da validade na data de referência da Redução Z
      begin
        ConcatenaLogXml(sLog, '- Erro 3022 Existe CEST fora da validade na data de referência da Redução Z: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 3023') then  // Verifica se existe vínculo entre o NCM e o CEST informado no produto
      begin
        ConcatenaLogXml(sLog, '- Erro 3023 Existe produto no estoque com NCM sem vínculo com CEST: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4013') then  // Verifica se o código GTIN informado é válido
      begin
        ConcatenaLogXml(sLog, '- Erro 4013 Existe código de barra inválido no cadastro de produtos: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4014') then  // Verifica se o código CEST foi informado quando o produto está sob substituição tributária
      begin
        ConcatenaLogXml(sLog, '- Erro 4014 Existe produto com ST sem configuração do CEST: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
        IBQESTOQUE.Close;
        IBQESTOQUE.SQL.Text :=
          'select * ' +
          'from ESTOQUE ' +
          'where coalesce(trim(CEST), '''') = '''' ' +
          ' and substring(trim(coalesce(ST, '''')) from 1 for 1) = ''F'' ';
        IBQESTOQUE.Open;
        
        while IBQESTOQUE.Eof = False do
        begin
          if AnsiContainsText(sLog, ' Preencher CEST no cadastro do estoque: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + '-' + IBQESTOQUE.FieldByName('DESCRICAO').AsString) = False then
            ConcatenaLogXml(sLog, ' Preencher CEST no cadastro do estoque: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + '-' + IBQESTOQUE.FieldByName('DESCRICAO').AsString);

          IBQESTOQUE.Next;
        end; // while IBQESTOQUE.Eof = False do
        
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4015') then  // Verifica se o código CEST foi preenchido quando o produto não está sob substituição tributária
      begin
        ConcatenaLogXml(sLog, '- Erro 4015 Existe produto sem ST com configuração do CEST: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
        IBQESTOQUE.Close;
        IBQESTOQUE.SQL.Text :=
          'select * ' +
          'from ESTOQUE ' +
          'where coalesce(trim(CEST), '''') <> '''' ' +
          ' and substring(trim(coalesce(ST, '''')) from 1 for 1) <> ''F'' ';
        IBQESTOQUE.Open;

        while IBQESTOQUE.Eof = False do
        begin
          if AnsiContainsText(sLog, ' Não deve Preencher CEST no cadastro do estoque: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + '-' + IBQESTOQUE.FieldByName('DESCRICAO').AsString) = False then
            ConcatenaLogXml(sLog, ' Não deve Preencher CEST no cadastro do estoque: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + '-' + IBQESTOQUE.FieldByName('DESCRICAO').AsString);

          IBQESTOQUE.Next;
        end; // while IBQESTOQUE.Eof = False do

      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4016') then  // Verifica se o código CEST informado é válido
      begin
        ConcatenaLogXml(sLog, '- Erro 4016 Existe CEST inválido no cadastro de produtos: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4017') then  // Verifica se o código CEST está dentro da validade na data de referência do Estoque
      begin
        ConcatenaLogXml(sLog, '- Erro 4017 Existe CEST fora da validade na data de referência do Estoque: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;

      if AnsiContainsText(sMensagemRetorno, 'Erro 4018') then  // Verifica se existe vínculo entre o NCM e o CEST informado no produto
      begin
        ConcatenaLogXml(sLog, '- Erro 4018 Existe produto no estoque com NCM sem vínculo com CEST: '  + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBQBLOCOX.FieldByName('SERIE').AsString);;
      end;
    except
      sMensagemRetorno := ''
    end;

    IBQBLOCOX.Next;

  end; // while IBQBLOCOX.Eof = False do

  FreeAndNil(IBQBLOCOX);
  FreeAndNil(IBQESTOQUE);

  if sLog <> '' then
  begin
    try
      sLog := '                  **************** Arquivo com inconsistência ******************' + #13 + #10 + #13 + #10 +
        '1 - Favor corrigir os alertas abaixo.' + #13 + #10 +
        '2 - Após acesse o Frente de Caixa e faça a transmissão dos arquivos pendentes' + #13 + #10 + #13 + #10 +
        'Alertas:' + #13 + #10 + sLog;

      with TArquivo.Create do
      begin
        Texto := sLog;
        SalvarArquivo(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + sTipo + '.txt');
        Sleep(100);
        Free;
      end;
      ChDir(Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2019-04-04

      if FileExists(PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + sTipo + '.txt')) then
      begin
        ShellExecute(Application.Handle, nil, PChar(Emitente.Configuracao.DiretorioAtual + '\log\log_XML_' + sTipo + '.txt'), nil, nil, SW_SHOWNORMAL);
      end;

    except

    end;
  end;
end;

function TrataErrosInternosServidorSEFAZ(Emitente: TEmitente;
  IBTransaction: TIBTransaction): Boolean;
// Trata resposta da Sefaz contendo erros internos do servidor. Retorno do soap não é nenhum dos padrões de rsposta de mensagens
// Ex.:  <soap:Text xml:lang="en">Server was unable to process request. ---> ORA-30006: recurso ocupado; aquisição com timeout WAIT expirada ORA-06512: em line 6...
var
  IBTSALVAR: TIBTransaction;
  IBQSALVAR: TIBQuery;
  IBQBLOCOX: TIBQuery;
  sXmlResposta: String;
  sTipo: String;
  sSerie: String;
  sDataReferencia: String;
begin
  Result := True;

  IBTSALVAR := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQSALVAR := CriaIBQuery(IBTSALVAR);
  IBQBLOCOX := CriaIBQuery(IBTransaction);

  IBQBLOCOX.Close;
  IBQBLOCOX.SQL.Text :=
    'select XMLRESPOSTA, TIPO, SERIE, DATAREFERENCIA ' +
    'from BLOCOX ' +
    'where ((XMLRESPOSTA containing ''<soap:Envelope'') ' +
    ' or (XMLRESPOSTA containing ''<SituacaoOperacaoCodigo>1'' and XMLRESPOSTA containing ''<SituacaoOperacaoDescricao>XML inválido:''))';
  IBQBLOCOX.Open;

  while IBQBLOCOX.Eof = False do
  begin

    sXmlResposta    := IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString;
    sTipo           := IBQBLOCOX.FieldByName('TIPO').AsString;
    sSerie          := IBQBLOCOX.FieldByName('SERIE').AsString;
    sDataReferencia := IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString;

    if Pos('<soap:Envelope', sXmlResposta) > 0 then
    begin
      // Erros internos do servidor do Bloco X
      // Quando servidor apresentar problemas e retornar erro de exception que ocorreu nos métodos de processamento interno
      // Ex.:  <soap:Text xml:lang="en">Server was unable to process request. ---> ORA-30006: recurso ocupado; aquisição com timeout WAIT expirada ORA-06512: em line 6...

      try
        IBQSALVAR.Close;
        IBQSALVAR.SQL.Text :=
          'update BLOCOX set ' +
          'RECIBO = null ' +
          ', XMLRESPOSTA = null ' +
          'where TIPO = ' + QuotedStr(sTipo) +
          ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(sDataReferencia)));
        if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
          IBQSALVAR.SQL.Add(' and SERIE = ' + QuotedStr(sSerie));
        IBQSALVAR.ExecSQL;
        IBQSALVAR.Transaction.Commit;

      except
        IBQSALVAR.Transaction.Rollback;
      end;

      IBQBLOCOX.Next;
    end; // if Pos('<soap:Envelope', sXmlResposta) > 0 then

    if (Pos('<SituacaoOperacaoCodigo>1', sXmlResposta) > 0) and (Pos('<SituacaoOperacaoDescricao>XML inválido:', sXmlResposta) > 0) then
    begin
      // Erros internos do servidor do Bloco X
      // Quando servidor apresentar problemas e retornar xml com estrutura fora do padrão
      // Ex.:  <SituacaoOperacaoCodigo>1</SituacaoOperacaoCodigo><SituacaoOperacaoDescricao>XML inválido: The element 'Manutencao' has invalid child element 'Signature'. List of possible elements expected: 'Signature' in namespace 'http://www.w3.org/2000/09/xmldsig#'.</SituacaoOperacaoDescricao>
      try
        IBQSALVAR.Close;
        IBQSALVAR.SQL.Text :=
          'update BLOCOX set ' +
          'XMLRESPOSTA = :XMLRESPOSTA ' +
          'where TIPO = ' + QuotedStr(sTipo) +
          ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(sDataReferencia)));
        if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
          IBQSALVAR.SQL.Add(' and SERIE = ' + QuotedStr(sSerie));

        // Sandro Silva 2022-09-05 IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := '<?xml version="1.0" encoding="utf-8"?><Resposta><Recibo>' + IBQBLOCOX.FieldByName('RECIBO').AsString + '</Recibo><SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao><Mensagem /></Resposta>';
        IBQSALVAR.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoAguardandoBlocoX(IBQBLOCOX.FieldByName('RECIBO').AsString);
        IBQSALVAR.ExecSQL;
        IBQSALVAR.Transaction.Commit;

      except
        IBQSALVAR.Transaction.Rollback;
      end;

      IBQBLOCOX.Next;
    end; // if Pos('<soap:Envelope', sXmlResposta) > 0 then

  end; // while IBQBLOCOX.Eof = False do

  FreeAndNil(IBQBLOCOX);
  FreeAndNil(IBQSALVAR);
  FreeAndNil(IBTSALVAR);

end;

function BXIdentificaRetornosComErroTratando(Emitente: TEmitente;
  IBTransaction: TIBTransaction; sTipo: String): Boolean; // Sandro Silva 2019-06-18
var
  IBTTRATAR: TIBTransaction;
  IBQTRATAR: TIBQuery;
  IBQBLOCOX: TIBQuery;
begin
  // Identifica os xml rejeitados por erro e recria com os dados atualizados
  // Ex.: Número credenciamento, NCM, IE contribuinte, assinatura digital inválida

  // Duas querys, uma para selecionar os xml com erro e outra para quando estiver em rede com outros terminais, verificar se outro terminal já fez a correção.
  // Só fará a correção se ainda não tiver sido feita por outro terminal
  IBTTRATAR := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQTRATAR := CriaIBQuery(IBTTRATAR);
  IBQBLOCOX := CriaIBQuery(IBTransaction);
  try
    //Commitatudo2(True); // EnvioaoFISCOESTOQUEClick 2017-03-22

    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select * ' +
      'from BLOCOX ' +
      'where XMLRESPOSTA containing ''<SituacaoProcessamentoCodigo>2'' ' +
      'or (coalesce(RECIBO, '''') <> '''' and coalesce(XMLRESPOSTA, '''') <> '''' and coalesce(XMLRESPOSTA, '''') not containing ''SituacaoProcessamentoCodigo'')';
    if sTipo <> '' then
      IBQBLOCOX.SQL.Add(' and TIPO = ' + QuotedStr(sTipo));
    IBQBLOCOX.SQL.Add(' order by DATAREFERENCIA ');
    IBQBLOCOX.Open;

    while IBQBLOCOX.Eof = False do
    begin

      // Trata retornos com erro de servidor indisponível
      // Gravando por padrão reposta com status aguardando para ser consultada na próxima oportunidade
      if (Trim(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString) <> '') and (AnsiContainsText(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString, 'SituacaoProcessamentoCodigo') = False) then
      begin

        try
          IBQTRATAR.Close;
          IBQTRATAR.SQL.Text :=
            'update BLOCOX set ' +
            'XMLRESPOSTA = :XMLRESPOSTA ' +
            'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
            ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
          if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
            IBQTRATAR.SQL.Add(' and SERIE = ' + QuotedStr(IBQBLOCOX.FieldByName('SERIE').AsString));
          // Sandro Silva 2022-09-05 IBQTRATAR.ParamByName('XMLRESPOSTA').AsString := '<?xml version="1.0" encoding="utf-8"?><Resposta><Recibo>' + IBQBLOCOX.FieldByName('RECIBO').AsString + '</Recibo><SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao><Mensagem /></Resposta>';
          IBQTRATAR.ParamByName('XMLRESPOSTA').AsString := XmlRespostaPadraoAguardandoBlocoX(IBQBLOCOX.FieldByName('RECIBO').AsString);
          IBQTRATAR.ExecSQL;
          IBQTRATAR.Transaction.Commit;

          // Sandro Silva 2021-12-29 LogFrente('Corrigiu retorno HTTP Error 503: ' + IBQBLOCOX.FieldByName('RECIBO').AsString + ' ' + sTipo + ' ' + FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);
          LogFrente('Corrigiu retorno fora do schema: ' + IBQBLOCOX.FieldByName('RECIBO').AsString + ' ' + sTipo + ' ' + FormatDateTime('dd/mm/yyyy', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);
        except
          IBQTRATAR.Transaction.Rollback;
        end;

      end;

      IBQTRATAR.Close;
      IBQTRATAR.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
      if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
        IBQTRATAR.SQL.Add(' and SERIE = ' + QuotedStr(IBQBLOCOX.FieldByName('SERIE').AsString));
      IBQTRATAR.Open;

      if AnsiContainsText(IBQTRATAR.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>2') then
      begin

        BXTrataErroRetornoTransmissao(Emitente, IBTransaction, IBQTRATAR.FieldByName('XMLRESPOSTA').AsString, IBQTRATAR.FieldByName('TIPO').AsString, IBQTRATAR.FieldByName('SERIE').AsString, FormatDateTime('dd/mm/yyyy', IBQTRATAR.FieldByName('DATAREFERENCIA').AsDateTime));

      end;

      IBQTRATAR.Transaction.Rollback;

      IBQBLOCOX.Next;
    end;
  except

  end;
  FreeAndNil(IBQTRATAR);
  FreeAndNil(IBTTRATAR);
  FreeAndNil(IBQBLOCOX);
  try
    TrataErrosInternosServidorSEFAZ(Emitente, IBTransaction);
  except

  end;

  try

    if AnsiContainsText(Application.ExeName, '\frente') then
    begin
      if Application.MessageBox(PAnsiChar('Deseja visualizar a lista dos arquivos xml do Bloco X?'), 'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_Yes then
      begin
        BXVisualizaXmlBlocoX(Emitente, IBTransaction.DefaultDatabase.DatabaseName, sTipo, Emitente.Configuracao.DiretorioAtual); // Sandro Silva 2020-06-18 BXVisualizaXmlBlocoX(FEmitente, FIBTransaction, sTipo, PAnsiChar(DiretorioAtual));
      end;
    end;
  except
  end;

  //ShowMessage('Teste 01 6243'); // Sandro Silva 2020-06-22

  Result := True;
end;

function BXVisualizaXmlBlocoX(Emitente: TEmitente;
  // Sandro Silva 2020-06-18  IBTransaction: TIBTransaction;
  CaminhoBanco: String;
  sTipo: String;
  DiretorioAtual: String): Boolean;
var
  FArquivosBlocoX: TFArquivosBlocoX;
begin
  // Cria Form para visualizar os arquivos referentes ao bloco x e seu status

  //ShowMessage('Teste 01 6245' + #13 + sTipo); // Sandro Silva 2020-06-18

  try

    FArquivosBlocoX              := TFArquivosBlocoX.Create(nil);
    FArquivosBlocoX.Tipo         := sTipo;
    FArquivosBlocoX.sAtual       := DiretorioAtual;
    FArquivosBlocoX.CaminhoBanco := CaminhoBanco;
    FArquivosBlocoX.ShowModal;

  //ShowMessage('Teste 01 6268'); // Sandro Silva 2020-06-22

    FreeAndNil(FArquivosBlocoX);
  except
  end;

  Result := True;
end;

function BXReprocessarArquivo(Emitente: TEmitente;
  IBTransaction: TIBTransaction; DiretorioAtual: String; // Sandro Silva 2019-12-11  sTipo: String;
  sRecibo: String = ''): Boolean; // Sandro Silva 2019-11-05
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  blocoxReprocessarArquivo: TBlocoXReprocessarArquivo; // Sandro Silva 2019-07-18
  ArqConsulta: TArquivo; // Sandro Silva 2019-07-18
  sSubjectName: String;
  sMotivo: String;
begin

  if BXServidorSefazConfigurado(Emitente.UF) then
  begin

    IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase);
    IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);

    blocoxReprocessarArquivo := TBlocoXReprocessarArquivo.Create(nil); //Application);
    ArqConsulta    := TArquivo.Create; // Sandro Silva 2019-07-18
    blocoxReprocessarArquivo.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');

    sSubjectName := '';
    try
      sSubjectName := blocoxReprocessarArquivo.CertificadoSubjectName; // Sandro Silva 2018-02-05  blocoxConsulta.Certificado.SubjectName;
    except

    end;

    if CertificadoPertenceAoEmitente(sSubjectName, Emitente.CNPJ) then// Sandro Silva 2020-03-13  if (AnsiContainsText(sSubjectName, LimpaNumero(Emitente.CNPJ))) then
    begin

      IBQBLOCOX.Close;
      if sRecibo = '' then
        IBQBLOCOX.SQL.Text :=
          'select * ' +
          'from BLOCOX ' +
          'where ((coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>2'') or (coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>3''))' + // 2:Erro 3:Cancelado
          ' and coalesce(RECIBO, '''') <> '''' ' + // tem recibo
          ' and DATAHORA <= cast(' + QuotedStr(FormatDateTime('yyyy-mm-dd HH:nn:ss', IncMinute(Now, -INTERVALO_PARA_CONSULTA))) + ' as timestamp) ' + // XML enviados a mais de 5 minutos
          ' order by DATAREFERENCIA' // Sandro Silva 2018-09-27 ' order by DATAHORA'
      else
        IBQBLOCOX.SQL.Text :=
          'select * ' +
          'from BLOCOX ' +
          'where ((coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>2'') or (coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>3''))' + // 2:Erro 3:Cancelado
          ' and coalesce(RECIBO, '''') = ' + QuotedStr(sRecibo);
      IBQBLOCOX.Open;

      while IBQBLOCOX.Eof = False do
      begin

        if IBQBLOCOX.FieldByName('RECIBO').AsString <> '' then
        begin
          try

            sMotivo := Trim('Correcao: ' + Copy(GetSituacaoProcessamentoDescricaoFomXML(IBQBLOCOX.FieldByName('XMLRESPOSTA').AsString), 1, 1000));

            ArqConsulta.Texto := Format(XML_REPROCESSAR_ARQUIVO, [IBQBLOCOX.FieldByName('RECIBO').AsString, sMotivo]);
            blocoxReprocessarArquivo.Xml := ArqConsulta.Texto;
            blocoxReprocessarArquivo.AssinaXML;

            blocoxReprocessarArquivo.SalvaArquivo(DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_reprocessararquivo.xml');

            blocoxReprocessarArquivo.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');
            blocoxReprocessarArquivo.GetCertificado(False);

            blocoxReprocessarArquivo.ReprocessarArquivo.MimeType         := 'text/xml';
            blocoxReprocessarArquivo.ReprocessarArquivo.Charsets         := 'utf-8';
            blocoxReprocessarArquivo.ReprocessarArquivo.EncodeDataToUTF8 := True;
            blocoxReprocessarArquivo.ReprocessarArquivo.UF               := Emitente.UF;
            blocoxReprocessarArquivo.ReprocessarArquivo.Servico          := 'ReprocessarArquivo'; //'Consultar';
            blocoxReprocessarArquivo.ReprocessarArquivo.Recibo           := IBQBLOCOX.FieldByName('RECIBO').AsString;
            blocoxReprocessarArquivo.ReprocessarArquivo.XmlFile          := DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_reprocessararquivo.xml';
            blocoxReprocessarArquivo.ReprocessarArquivo.Enviar;

            LogFrente('Consultou recibo ' + IBQBLOCOX.FieldByName('RECIBO').AsString + ' - ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IfThen(IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO', ' ' + IBQBLOCOX.FieldByName('SERIE').AsString, '') + FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);

            BXSalvarReciboTransmissaoBanco(Emitente, IBTransaction, blocoxReprocessarArquivo.ReprocessarArquivo.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString); // Sandro Silva 2019-12-11 BXSalvarReciboTransmissaoBanco(IBTransaction, blocoxReprocessarArquivo.ReprocessarArquivo.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString);

          except

          end;
        end;

        IBQBLOCOX.Next;

      end;

    end; // if (GetCNPJCertificado(blocoxConsulta.Certificado.SubjectName) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString)) then // Sandro Silva 2018-02-01

    blocoxReprocessarArquivo.Free;
    FreeAndNil(ArqConsulta); // Sandro Silva 2019-07-18

    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);

  end; // if BlocoXServidorConfigurado then

  ChDir(DiretorioAtual); // Sandro Silva 2017-03-31
  Result := True; // Sandro Silva 2018-06-28

end;

function BXCancelarArquivo(Emitente: TEmitente;
  IBTransaction: TIBTransaction; DiretorioAtual: String;
  sRecibo: String = ''): Boolean; // Sandro Silva 2022-03-11
//
// NÃO USAR COMMITATUDO() AQUI OU EM OUTRO PONTO DO BLOCOX
//
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  blocoxCancelarArquivo: TBlocoXCancelarArquivo; // Sandro Silva 2019-07-18
  ArqConsulta: TArquivo; // Sandro Silva 2019-07-18
  sSubjectName: String;
  sMotivo: String;
begin

  if BXServidorSefazConfigurado(Emitente.UF) then
  begin

    IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase);
    IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);

    blocoxCancelarArquivo := TBlocoXCancelarArquivo.Create(nil); //Application);
    ArqConsulta    := TArquivo.Create; // Sandro Silva 2019-07-18
    blocoxCancelarArquivo.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');

    sSubjectName := '';
    try
      sSubjectName := blocoxCancelarArquivo.CertificadoSubjectName; // Sandro Silva 2018-02-05  blocoxConsulta.Certificado.SubjectName;
    except

    end;

    if CertificadoPertenceAoEmitente(sSubjectName, Emitente.CNPJ) then// Sandro Silva 2020-03-13  if (AnsiContainsText(sSubjectName, LimpaNumero(Emitente.CNPJ))) then
    begin

      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        //'where ((coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>2'') or (coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>3''))' +
        //' and coalesce(RECIBO, '''') = ' + QuotedStr(sRecibo);
         ' where coalesce(RECIBO, '''') = ' + QuotedStr(sRecibo);
      IBQBLOCOX.Open;

      while IBQBLOCOX.Eof = False do
      begin

        if IBQBLOCOX.FieldByName('RECIBO').AsString <> '' then
        begin
          try

            sMotivo := Trim('Manutenção: ' + Copy(IBQBLOCOX.FieldByName('RECIBO').AsString, 1, 1000));

            ArqConsulta.Texto := Format(XML_CANCELAR_ARQUIVO, [IBQBLOCOX.FieldByName('RECIBO').AsString, sMotivo]);
            blocoxCancelarArquivo.Xml := ArqConsulta.Texto;
            blocoxCancelarArquivo.AssinaXML;

            blocoxCancelarArquivo.SalvaArquivo(DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_cancelararquivo.xml');

            blocoxCancelarArquivo.CertificadoSubjectName := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'Certificado', '');
            blocoxCancelarArquivo.GetCertificado(False);

            blocoxCancelarArquivo.CancelarArquivo.MimeType         := 'text/xml';
            blocoxCancelarArquivo.CancelarArquivo.Charsets         := 'utf-8';
            blocoxCancelarArquivo.CancelarArquivo.EncodeDataToUTF8 := True;
            blocoxCancelarArquivo.CancelarArquivo.UF               := Emitente.UF;
            blocoxCancelarArquivo.CancelarArquivo.Servico          := 'CancelarArquivo'; //'Consultar';
            blocoxCancelarArquivo.CancelarArquivo.Recibo           := IBQBLOCOX.FieldByName('RECIBO').AsString;
            blocoxCancelarArquivo.CancelarArquivo.XmlFile          := DiretorioLogBlocoX + '\' + IBQBLOCOX.FieldByName('RECIBO').AsString + '_cancelararquivo.xml';
            blocoxCancelarArquivo.CancelarArquivo.Enviar;

            LogFrente('Consultou recibo ' + IBQBLOCOX.FieldByName('RECIBO').AsString + ' - ' + IBQBLOCOX.FieldByName('TIPO').AsString + ' ' + IfThen(IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO', ' ' + IBQBLOCOX.FieldByName('SERIE').AsString, '') + FormatDateTime('yyyymmdd', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime), Emitente.Configuracao.DiretorioAtual);

            BXSalvarReciboTransmissaoBanco(Emitente, IBTransaction, blocoxCancelarArquivo.CancelarArquivo.Retorno, IBQBLOCOX.FieldByName('REGISTRO').AsString);

          except

          end;
        end;

        IBQBLOCOX.Next;

      end;

    end; // if (GetCNPJCertificado(blocoxConsulta.Certificado.SubjectName) = LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString)) then // Sandro Silva 2018-02-01

    blocoxCancelarArquivo.Free;
    FreeAndNil(ArqConsulta); // Sandro Silva 2019-07-18

    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);

  end; // if BlocoXServidorConfigurado then

  ChDir(DiretorioAtual); // Sandro Silva 2017-03-31
  Result := True; // Sandro Silva 2018-06-28

end;

procedure BXGeraXmlReducaoSemBlocoX(Emitente: TEmitente;
  IBTransaction: TIBTransaction);
// Gera XML da RZ não encontrados no blocox dos últimos 5 dias
var
  IBTREDUCAO: TIBTransaction;
  IBQREDUCAO: TIBQuery;
begin

  IBTREDUCAO := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQREDUCAO := CriaIBQuery(IBTREDUCAO);

  IBQREDUCAO.Close;
  IBQREDUCAO.SQL.Text :=
    'select R.DATA, R.HORA, R.PDV as CAIXA, R.SERIE as ECF, R.CONTADORZ as CRZ ' +
    'from REDUCOES R ' +
    'left join BLOCOX B on B.DATAREFERENCIA = R.DATA and B.SERIE = R.SERIE ' +
    'where (R.SMALL <> ''59'' and R.SMALL <> ''65'' and R.SMALL <> ''99'') ' + // Sandro Silva 2021-08-11 'where (R.SMALL <> ''59'' and R.SMALL <> ''65'') ' +
    ' and R.DATA >= (current_date - 5) ' +
    ' and B.DATAREFERENCIA is null ' +
    'order by R.DATA';
  IBQREDUCAO.Open;

  while IBQREDUCAO.Eof = False do
  begin

    if (IBQREDUCAO.FieldByName('CRZ').AsString <> '') and (IBQREDUCAO.FieldByName('CAIXA').AsString <> '') then
    begin

      LogFrente('XML Redução não encontrado: ' + IBQREDUCAO.FieldByName('ECF').AsString + ' ' + IBQREDUCAO.FieldByName('DATA').AsString, Emitente.Configuracao.DiretorioAtual);

      BXGeraXmlReducaoZ(Emitente, IBTransaction, IBQREDUCAO.FieldByName('ECF').AsString, FormatDateTime('dd/mm/yyyy', IBQREDUCAO.FieldByName('DATA').AsDateTime), True, False, True);
//BE111810101110034741

      LogFrente('XML Redução gerado: ' + IBQREDUCAO.FieldByName('ECF').AsString + ' ' + IBQREDUCAO.FieldByName('DATA').AsString, Emitente.Configuracao.DiretorioAtual);

    end;

    IBQREDUCAO.Next;
  end;

  FreeAndNil(IBQREDUCAO);
  FreeAndNil(IBTREDUCAO);
end;

// Exporta XML da Redução Z em repositório local que é disponibilizado ao fiscal
// Exporta xml do período informado
function BXGerarAoFISCOREDUCAOZ(Emitente: TEmitente;
  IBTransaction: TIBTransaction): Boolean;
const PASTA_GERAR_AO_FISCO_REDUCAO_Z = 'c:\BlocoX\Gerar ao FISCO-REDUÇÃO Z';
var
  dtInicial: TDate;
  dtFinal: TDate;
  IBTREDUCAO: TIBTransaction;
  IBQREDUCAO: TIBQuery;
begin

  dtInicial := StrToDateDef(InputBox('Data Inicial', 'Informe a Data Inicial para "Gerar ao FISCO-REDUÇÃO Z" - (dd/mm/yyyy)', ''), StrToDate('30/12/1899'));
  dtFinal   := StrToDateDef(InputBox('Data Final', 'Informe a Data Final para "Gerar ao FISCO-REDUÇÃO Z" - (dd/mm/yyyy)', ''), StrToDate('30/12/1899'));

  if (dtInicial > StrToDate('30/12/1899')) and (dtFinal > StrToDate('30/12/1899')) then
  begin

    if dtInicial <= dtFinal then
    begin

      try
        CreateDir('c:\BlocoX');
        CreateDir(PASTA_GERAR_AO_FISCO_REDUCAO_Z);

        IBTREDUCAO := CriaIBTransaction(IBTransaction.DefaultDatabase);
        IBQREDUCAO := CriaIBQuery(IBTREDUCAO);

        IBQREDUCAO.Close;
        IBQREDUCAO.SQL.Text :=
          'select B.* ' +
          'from BLOCOX B ' +
          'where B.DATAREFERENCIA between :DTINICIAL and :DTFINAL ' +
          ' and B.TIPO = ''REDUCAO'' ' +
          ' order by B.DATAREFERENCIA, B.SERIE';
        IBQREDUCAO.ParamByName('DTINICIAL').AsDate := dtInicial;
        IBQREDUCAO.ParamByName('DTFINAL').AsDate   := dtFinal;        
        IBQREDUCAO.Open;

        while IBQREDUCAO.Eof = False do
        begin
        
          if IBQREDUCAO.FieldByName('XMLENVIO').AsString <> '' then
          begin
            TBlobField(IBQREDUCAO.FieldByName('XMLENVIO')).SaveToFile(PASTA_GERAR_AO_FISCO_REDUCAO_Z + '\' + 'Redução_Z_' + FormatDateTime('ddmmyyyy', IBQREDUCAO.FieldByName('DATAREFERENCIA').AsDateTime) + '_' + IBQREDUCAO.FieldByName('SERIE').AsString + '.xml');
          end;

          IBQREDUCAO.Next;
        end;

        // Abre a pasta onde foram gerados os arquivos XML 
        ShellExecute(Application.Handle, PChar('open'), PChar('explorer.exe'), PChar(PASTA_GERAR_AO_FISCO_REDUCAO_Z), nil, SW_NORMAL);

      except
      end;

      if IBQREDUCAO <> nil then
        FreeAndNil(IBQREDUCAO);
      if IBTREDUCAO <> nil then
        FreeAndNil(IBTREDUCAO);

    end;

  end;

  Result := True;

end;

procedure ValidaMd5DoListaNoCriptografado;
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
    // Versão 2020 ou superior
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

      if AnsiUpperCase(sMD5Cripta) <> AnsiUpperCase(sCNPJ+sMD5Lista) then
      begin

        if LimpaNumero(sCNPJ) <> '' then
        begin

          sConcomitante := MaisIni.ReadString('CONCOMITANTE','I','');
          if sConcomitante <> '' then
            sConcomitante := LbBlowfish.DecryptString(MaisIni.ReadString('CONCOMITANTE','I','CONCOMITANTE'))
          else
            sConcomitante := 'CONCOMITANTE';

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

          if AnsiUpperCase(xmlNodeValue(slRespostaSite.Text, '//md5')) = AnsiUpperCase(sMD5Lista) then
            MaisIni.WriteString('MD5','HOMOLOGADO', LbBlowfish.EncryptString(sCNPJ + AnsiLowerCase(Trim(xmlNodeValue(slRespostaSite.Text, '//md5'))))); // Cifra cnpj emitente + md5 do lista

          if Trim(xmlNodeValue(slRespostaSite.Text, '//credenciamento')) <> '' then
          begin
            MaisIni.WriteString('ECF','CRED', LbBlowfish.EncryptString(sCNPJ + Trim(xmlNodeValue(slRespostaSite.Text, '//credenciamento')))); // No arquivoauxiliarcriptografadopafecfsmallsoft.ini cifra cnpj emitente + número credenciamento paf
            GravarParametroIni('FRENTE.INI', 'Frente de Caixa', 'CRED', LbBlowfish.EncryptString(sCNPJ + Trim(xmlNodeValue(slRespostaSite.Text, '//credenciamento')))); // No frente.ini cifra cnpj emitente + número credenciamento paf
          end;

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



{ TLog }

constructor TLog.Create;
begin
  FArquivo := TArquivo.Create;

end;

destructor TLog.Destroy;
begin
  FreeAndNil(FArquivo); // Sandro Silva 2020-06-04

  inherited;
end;

procedure TLog.SalvaLog(Arquivo: String; Texto: String);
begin
  FArquivo.Texto := FormatDateTime('dd/mm/yyyy HH:nn:ss.zzz', Now) + ': ' + Texto;
  FArquivo.SalvarArquivo(Arquivo);
end;

{ TEstoqueItens }

constructor TEstoqueItens.Create;
begin

end;

destructor TEstoqueItens.Destroy;
begin

  inherited;
end;

{ TEstoqueItensList }

function TEstoqueItensList.Adiciona(CodigoNCMSH: String; Quantidade: String;
  Unidade: String; CodigoProprio: String; CodigoCEST: String;
  SituacaoTributaria: String; IsArredondado: String;
  QuantidadeTotalAquisicao: String; CodigoGTIN: String;
  ValorBaseCalculoICMSST: String; Descricao: String;
  ValorUnitario: String; SituacaoEstoque: String;
  ValorTotalAquisicao: String; ValorTotalICMSST: String;
  ValorTotalICMSDebitoFornecedor: String;
  Aliquota: String; Ippt: String): TEstoqueItens;
begin
  Result := TEstoqueItens.Create;
  Result.FCodigoNCMSH                    := CodigoNCMSH;
  Result.FQuantidade                     := Quantidade;
  Result.FUnidade                        := Unidade;
  Result.FCodigoProprio                  := CodigoProprio;
  Result.FCodigoCEST                     := CodigoCEST;
  Result.FSituacaoTributaria             := SituacaoTributaria;
  Result.FIsArredondado                  := IsArredondado;
  Result.FQuantidadeTotalAquisicao       := QuantidadeTotalAquisicao;
  Result.FCodigoGTIN                     := CodigoGTIN;
  Result.FValorBaseCalculoICMSST         := ValorBaseCalculoICMSST;
  Result.FDescricao                      := Descricao;
  Result.FValorUnitario                  := ValorUnitario;
  Result.FSituacaoEstoque                := SituacaoEstoque;
  Result.FValorTotalAquisicao            := ValorTotalAquisicao;
  Result.FValorTotalICMSST               := ValorTotalICMSST;
  Result.FValorTotalICMSDebitoFornecedor := ValorTotalICMSDebitoFornecedor;
  Result.FAliquota                       := Aliquota;
  Result.FIppt                           := Ippt;

  Add(Result);
end;

function TEstoqueItensList.getItem(Index: Integer): TEstoqueItens;
begin
  Result := TEstoqueItens(inherited Items[index]);
end;

{ TRZ }

constructor TReducaoZItens.Create;
begin

end;

destructor TReducaoZItens.Destroy;
begin

  inherited;
end;

{ TReducaoZItensList }

function TReducaoZItensList.Adiciona(Tipo, Descricao, CodigoGTIN,
  CodigoCEST, CodigoNCMSH, CodigoProprio: String; Quantidade: Double;
  Unidade: String; ValorDesconto, ValorAcrescimo, ValorCancelamento,
  ValorTotalLiquido: Double; ValorDiferenca: Currency): TReducaoZItens;
begin
  Result := TReducaoZItens.Create;
  Result.Tipo              := Tipo;
  Result.Descricao         := Descricao;
  Result.CodigoGTIN        := CodigoGTIN;
  Result.CodigoCEST        := CodigoCEST;
  Result.CodigoNCMSH       := CodigoNCMSH;
  Result.CodigoProprio     := CodigoProprio;
  Result.Quantidade        := Quantidade;
  Result.Unidade           := Unidade;
  Result.ValorDesconto     := ValorDesconto;
  Result.ValorAcrescimo    := ValorAcrescimo;
  Result.ValorCancelamento := ValorCancelamento;
  Result.ValorTotalLiquido := ValorTotalLiquido;
  Result.ValorDiferenca    := ValorDiferenca;

  Add(Result);
end;

function TReducaoZItensList.getItem(Index: Integer): TReducaoZItens;
begin
  Result := TReducaoZItens(inherited Items[index]);
end;

end.
