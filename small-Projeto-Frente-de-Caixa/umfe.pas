// Sandro Silva 2022-05-17 Após o prado de 07/11/2022, tirar essa uses e eliminar as dependências relacionadas ao Integrador e Validador Fiscal das demais unit do projeto
(*
Unit para uso com MFE e integrador fiscal do Ceará
Autor: Sandro Luis da Silva

Contém estruturas de objetos que geram e fazem a leitura de arquivos xml usados
na comunicação com integrador fiscal e suas obrigatoriedades


Simulador POS Integrador Fiscal
http://simuladorpossefazce.azurewebsites.net/

Site
autizacao-sat.php
hardware-compativel.php

Nova tabela

CREATE TABLE VFPE (
    REGISTRO          VARCHAR(10) NOT NULL,
    DATA              DATE,
    PEDIDO            VARCHAR(6),
    CAIXA             VARCHAR(3),
    FORMA             VARCHAR(30),
    VALOR             NUMERIC(18,2),
    IDPAGAMENTO       INTEGER,
    IDRESPOSTAFISCAL  INTEGER,
    TRANSMITIDO       VARCHAR(1)
);

ALTER TABLE VFPE ADD CONSTRAINT PK_VFPE PRIMARY KEY (REGISTRO);

CREATE SEQUENCE G_VFPE;


Base web
INSERT INTO `smallsoft`.`hardware` (`tipo`, `nome`, `modelo`, `versao`, `fabricante`, `site_fabri`, `ativo`) VALUES ('MFe', 'ELGIN LINKERC1', 'LINKERC1', 'X', 'ELGIN', 'www.elgin.com.br', 0);
INSERT INTO `smallsoft`.`hardware` (`tipo`, `nome`, `modelo`, `versao`, `fabricante`, `site_fabri`, `ativo`) VALUES ('MFe', 'TANCA TM-1000', 'TM-1000', 'X', 'TANCA', 'www.tanca.com.br', 0);

UPDATE `smallsoft`.`hardware` SET `modelo`='MP 4200 TH FI II' WHERE `ID`='91';
UPDATE `smallsoft`.`hardware` SET `modelo`='MP 4200 TH FI' WHERE `ID`='90';

Configuração
     Baixe o instalador em https://integrador.blob.core.windows.net/releases/Integrador Setup 1.5.86.exe
    Faça a instalação do mesmo e ao executar pela primeira vez utilize os seguintes dados na tela de configuração/opções:
        Estabelecimento CNPJ - IE: 30146465000116 - 065911482 ou (22295347000141 - 065911482)
        CNPJ da Software House: 98155757000159
        Código de Validação do Aplicativo Comercial: MD2Nof/O0tQMPKiYeeAydSjYt7YV9kU0nWKZGXHVdYIzR2W9Z6tgXni/Y5bnjmUAk8MkqlBJIiOOIskKCjJ086k7vAP0EU5cBRYj/nzHUiRdu9AVD7WRfVs00BDyb5fsnnKg7gAXXH6SBgCxG9yjAkxJ0l2E2idsWBAJ5peQEBZqtHytRUC+FLaSfd3+66QNxIBlDwQIRzUGPaU6fvErVDSfMUf8WpkwnPz36fCQnyLypqe/5mbox9pt3RCbbXcYqnR/4poYGr9M9Kymj4/PyX9xGeiXwbgzOOHNIU5M/aAs0rulXz948bZla0eXABgEcp6mDkTzweLPZTbmOhX+eA==
        Selecione o checkbox "Servidor" (Talvez seja necessário alterar o campo IsServer para True no arquivo Integrador.cnf - Use o SQLiteStudio -http://sqlitestudio.pl/)
    Para o MDK ELGIN use os seguinte dados na criação do XML de Venda:
        CNPJ contribuinte: 14.200.166/0001-66
        IE: 1234567890
        CNPJ Software House: 10615281000140
        Assinatura: CODIGO DE VINCULACAO AC DO MFE-CFE
    Para o MDK da TANCA use os seguinte dados na criação do XML de Venda:
        Código de Ativação: 12345678
        CNPJ do Contribuinte: 08.723.218/0001-86
        IE do Contribuinte: 562.377.111.111
        CNPJ da Software House: 16.716.114/0001-72
        Assinatura da Software House: SGR-SAT SISTEMA DE GESTAO E RETAGUARDA DO SAT




Fluxo de operação com integrador

Fonte: jackson Lima: http://www.projetoacbr.com.br/forum/topic/36410-integrador-fiscal-mfe-cear%C3%A1-como-usar-com-o-acbr/?page=2

Estou postando aqui informações do fluxo completo de venda e pagamento, para quem precisar.

Segundo o administrador do projeto mfe é assim:

1 - Registrar o Cliente (AC - Sem Interface com o Integrador)
2 - Registrar Produtos  (AC - Sem Interface com o Integrador)
3 - Definir forma de pagamento (AC - Sem Interface com o Integrador)
4 - Enviar solicitação de pagamento ao Validador (Interface com o Integrador - Componente: VFP-e / Método: EnviarPagamento)
5 - Solicitar Status de Pagamento para o Validador, em casos de POS (Interface com o Integrador - Componente: VFP-e / Método: VerificarStatusValidador)
ou
5 - Enviar Status de Pagamento para o Validador, em caso de TEF  (Interface com o Integrador - Componente: VFP-e / Método: EnviarStatusPagamento)

6 - Gerar o CF-e (Interface com o Integrador - Componente: MF-e  / Método: EnviarDadosVenda)
7 - Enviar comprovante do Documento Fiscal para o Validador (Interface com o Integrador - Componente: VFP-e  / Método: RespostaFiscal)
8 - Imprimir o Cupom Fiscal em Impressora (AC - Sem Interface com o Integrador)
ou
8 - Imprimir o Cupom Fiscal no POS.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Importante implementar 2 cadastros no PDV.

1 - Cadastro de POS (Nome e Serial)
2 - Cadastro de Chave do validador (ChaveAcesso String (50) e ChaveRegistro String (50) ) e
    Integrador (Identificador String (1) Chave Unica para relacionamento entre as mensagens e o retorno do Integrador )

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

quando falamos de POS ele te envia os dados do pagamento e vc receber pelo passo 5 guarda os dados no seu sistema e alimenta a informação de pagamento do CF-e, apos a emissão do CF-e vc pega a chave de acesso e remete novamente ao integrador pelo passo 7



Luiz Abade 	2 de mai
A CHAVEACESSOVALIDADOR é um cadastrado realizado desde a SEFAZ para identificação do contribuinte perante o processo fiscal ele será gerada somente para cadastro e liberação do contribuinte e da SH, este ID identifica um unico CNPJ perante a SEFAZ

A CHAVEREQUISICAO é um cadastro realizado desde a SEFAZ para identificação do contribuinte e a adquirente que fará a captura do pagamento, este codigo somente será concedido as empresa em produção deste recurso.
"ChaveAcessoValidador e ChaveRequisição não existe nenhum local da SEFAZ para gerar, mas eles orientam a usar na ChaveAcessoValidador a mesma usada em ambiente de homologação e a ChaveRequisição gerar um GUID contendo o CNPJ do Contribuinte + o CNPJ da Adquirente. O código do estabelecimento vc deve obter com a rede adquirente."

Para realização de testes a SH deve usar o seguinte dado:

<Parametro>
   <Nome>chaveAcessoValidador</Nome>
   <Valor>25CFE38D-3B92-46C0-91CA-CFF751A82D3D</Valor>
</Parametro>

<Parametro>
   <Nome>ChaveRequisicao</Nome>
   <Valor>26359854-5698-1365-9856-965478231456</Valor>
</Parametro>

*)

unit umfe;

interface

uses
  ComObj, ActiveX, Contnrs, Classes, SysUtils, MSXML2_TLB,
  IniFiles, ufuncoesfrente
  {$IFDEF VER150}
  //, SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  ;

//const CHAVE_ACESSO_VALIDADOR_DESENVOLVIMENTO = '25CFE38D-3B92-46C0-91CA-CFF751A82D3D'; 

const COMPONENTE_MFE  = 'MF-e';
const COMPONENTE_VFPE = 'VFP-e';
const COMPONENTE_NFCE = 'NFCE';

const METODO_MFE_CONSULTAR                    = 'ConsultarMFe';
const METODO_MFE_CONSULTAR_STATUS_OPERACIONAL = 'ConsultarStatusOperacional';
const METODO_MFE_EXTRAIR_LOGS                 = 'ExtrairLogs';
const METODO_MFE_TESTE_FIM_A_FIM              = 'TesteFimaFim';
const METODO_MFE_ENVIAR_DADOS_VENDA           = 'EnviarDadosVenda';
const METODO_MFE_CANCELAR_ULTIMA_VENDA        = 'CancelarUltimaVenda';
const METODO_MFE_ATIVAR                       = 'AtivarMFe';
const METODO_MFE_CONSULTAR_NUMERO_SESSAO      = 'ConsultarNumeroSessao';
const METODO_MFE_ASSOCIAR_ASSINATURA          = 'AssociarAssinatura';

const METODO_NFCE_AUTORIZACAO_PRODUCAO    = 'NfeAutorizacaoLote12';
const METODO_NFCE_AUTORIZACAO_HOMOLOGACAO = 'HNfeAutorizacaoLote12';

const METODO_VFPE_ENVIAR_PAGAMENTO           = 'EnviarPagamento';
const METODO_VFPE_VERIFICAR_STATUS_VALIDADOR = 'VerificarStatusValidador';
const METODO_VFPE_ENVIAR_STATUS_PAGAMENTO    = 'EnviarStatusPagamento';
const METODO_VFPE_RESPOSTA_FISCAL            = 'RespostaFiscal';

function GuidCreate: String;
procedure ListaDeArquivos(var Lista: TStringList; sAtual: String; sExtensao: String = '*.xml');

type
  TArquivo = class
  private
    FTexto: String;
    FArquivo: TextFile;
  protected
  public
    property Texto: String read FTexto write FTexto;
    procedure SalvarArquivo(FileName: TFileName);
    procedure LerArquivo(FileName: TFileName);
  published
  end;

type
  TParametrosList = class;

  TParametro = class
  private
    FNome: String;
    FValor: String;
    procedure SetNome(const Value: String);
    procedure SetValor(const Value: String);
  protected
  public
    property Nome: String read FNome write SetNome;
    property Valor: String read FValor write SetValor;
  published
  end;

  TParametrosList = class(TObjectList)
  private
    function GetItem(Index: Integer): TParametro;
    procedure SetItem(Index: Integer; const Value: TParametro);
  public
    function Adiciona: TParametro;
    property Items[Index: Integer]: TParametro read GetItem write SetItem;
  end;

  TConstrutorParametros = class(TObjectList)
  private
    function GetItem(Index: Integer): TParametro;
    procedure SetItem(Index: Integer; const Value: TParametro);
  public
    function Adiciona: TParametro;
    property Items[Index: Integer]: TParametro read GetItem write SetItem;
  end;

  TRespostaFiscalList = class;

  TRespostaFiscal = class
  private
    FNsu: String;
    FCodigoAutorizacao: String;
    FBandeira: String;
    FAdquirente: String;
    FNumerodeAprovacao: String;
    FidRespostaFiscal: String;
    FidFila: String;
  protected
  public
    procedure Clear;
    property CodigoAutorizacao: String read FCodigoAutorizacao write FCodigoAutorizacao;
    property Nsu: String read FNsu write FNsu;
    property NumerodeAprovacao: String read FNumerodeAprovacao write FNumerodeAprovacao;
    property Bandeira: String read FBandeira write FBandeira;
    property Adquirente: String read FAdquirente write FAdquirente;
    property idRespostaFiscal: String read FidRespostaFiscal write FidRespostaFiscal;
    property idFila: String read FidFila write FidFila;
  published
  end;

  TRespostaFiscalList = class(TObjectList)
  private
    function GetItem(Index: Integer): TRespostaFiscal;
    procedure SetItem(Index: Integer; const Value: TRespostaFiscal);
  public
    function Adiciona: TRespostaFiscal;
    procedure ExcluiItem(Index: Integer);
    property Items[Index: Integer]: TRespostaFiscal read GetItem write SetItem;
  end;

  TFormaPagamentoList = class;

  TFormaPagamento = class
  private
    FEmitirCupomNFCE: String;
    FValorTotalVenda: String;
    FIcmsBase: String;
    FCodigoMoeda: String;
    FOrigemPagamento: String;
    FHabilitarMultiplosPagamentos: String;
    FHabilitarControleAntiFraude: String;
    FForma: String;
    FidPagamento: String;
    FTipoForma: String;
    FidRespostaFiscal: String;
    FTransmitido: String;
    FRespostaFiscal: TRespostaFiscal;
  protected
  public
    property IcmsBase: String read FIcmsBase write FIcmsBase;
    property ValorTotalVenda: String read FValorTotalVenda write FValorTotalVenda;
    property HabilitarMultiplosPagamentos: String read FHabilitarMultiplosPagamentos write FHabilitarMultiplosPagamentos;
    property HabilitarControleAntiFraude: String read FHabilitarControleAntiFraude write FHabilitarControleAntiFraude;
    property CodigoMoeda: String read FCodigoMoeda write FCodigoMoeda;
    property EmitirCupomNFCE: String read FEmitirCupomNFCE write FEmitirCupomNFCE;
    property OrigemPagamento: String read FOrigemPagamento write FOrigemPagamento;
    property Forma: String read FForma write FForma;
    property TipoForma: String read FTipoForma write FTipoForma;
    property idPagamento: String read FidPagamento write FidPagamento;
    property idRespostaFiscal: String read FidRespostaFiscal write FidRespostaFiscal;
    property Transmitido: String read FTransmitido write FTransmitido;
    property RespostaFiscal: TRespostaFiscal read FRespostaFiscal write FRespostaFiscal;
  published
  end;

  TFormaPagamentoList = class(TObjectList)
  private
    function GetItem(Index: Integer): TFormaPagamento;
    procedure SetItem(Index: Integer; const Value: TFormaPagamento);
  public
    function Adiciona: TFormaPagamento;
    property Items[Index: Integer]: TFormaPagamento read GetItem write SetItem;
  end;

  TEnviarPagamento = class
  private
    FFormaPagamentoList: TFormaPagamentoList;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    property Formas: TFormaPagamentoList read FFormaPagamentoList write FFormaPagamentoList;
    function AdicionaForma(TipoForma: String; Forma: String;
      EmitirCupomNFCE: String; ValorTotalVenda: String;
      IcmsBase: String; CodigoMoeda: String;
      OrigemPagamento: String; SerialPOS: String;
      cnpjContribuinte: String; HabilitarMultiplosPagamentos: String;
      HabilitarControleAntiFraude: String): Boolean; overload;
    function AdicionaForma: Integer; overload;
    procedure Clear;
  published
  end;

  TTransacaoCartaoMFE = class
  private
    FResposta: String;
    FCodigoAutorizacao: String;
    FBin: String;
    FDonoCartao: String;
    FDataExpiracao: String;
    FInstituicaoFinanceira: String;
    FParcelas: String;
    FCodigoPagamento: String;
    FValorPagamento: String;
    FTipo: String;
    FUltimosQuatroDigitos: String;
    function GetCodigoAutorizacao: String;
    function GetBin: String;
    function GetDonoCartao: String;
    function GetDataExpiracao: String;
    function GetInstituicaoFinanceira: String;
    function GetParcelas: String;
    function GetCodigoPagamento: String;
    function GetValorPagamento: String;
    function GetTipo: String;
    function GetUltimosQuatroDigitos: String;
    procedure SetResposta(const Value: String);
  protected
  public
    function GetLinha(Codigo: String): String;
    property Resposta: String read FResposta write SetResposta;// FResposta;
    property CodigoAutorizacao: String read GetCodigoAutorizacao write FCodigoAutorizacao;
    property Bin: String read GetBin write FBin;
    property DonoCartao: String read GetDonoCartao write FDonoCartao;
    property DataExpiracao: String read GetDataExpiracao write FDataExpiracao;
    property InstituicaoFinanceira: String read GetInstituicaoFinanceira write FInstituicaoFinanceira;
    property Parcelas: String read GetParcelas write FParcelas;
    property CodigoPagamento: String read GetCodigoPagamento write FCodigoPagamento;
    property ValorPagamento: String read GetValorPagamento write FValorPagamento;
    property Tipo: String read GetTipo write FTipo;
    property UltimosQuatroDigitos: String read GetUltimosQuatroDigitos write FUltimosQuatroDigitos;
  published
  end;

  TIntegradorFiscal = class
  private
    FParametros: TParametrosList;
    FIdentificador: String;
    FMetodo: String;
    FComponente: String;
    FXmlSolicitacao: String;
    FCaminhoIntegrador: String;
    FUltimaSolicitacao: String;
    FMensagemRetorno: String;
    FXmlResposta: String;
    FcodigoDeAtivacao: String;
    FConstrutorParametros: TConstrutorParametros;
    FUltimoidPagamento: String;
    FUltimoidRespostaFiscal: String;
    FcnpjContribuinte: String;
    FchaveAcessoValidador: String;
    FCodigoEstabelecimento: String;
    FChaveRequisicao: String;
    FCaminhoLog: String;
    FCaixa: String;
    FTransacao: TTransacaoCartaoMFE;
    FSerialPOS: String;
    FEnviarPagamento: TEnviarPagamento;
    FDiretorioAtual: String;
    FComponenteMFE: String;
    FUsandoSimuladorPOS: Boolean;
    procedure SetParametros(const Value: TParametrosList);
    procedure SetIdentificador(const Value: String);
    procedure SetXmlSolicitacao(const Value: String);
    procedure SetCaminhoIntegrador(const Value: String);
    procedure SetUltimaSolicitacao(const Value: String);
    procedure AdicionaParametro(sNome: String; sValor: String);
    procedure AdicionaParametroConstrutor(sNome: String; sValor: String);
    procedure GeraSolicitacao;
    function CapturaResposta: String;
    procedure LimparParametros;
    procedure SetMensagemRetorno(const Value: String);
    procedure SetXmlResposta(const Value: String);
    procedure SetcodigoDeAtivacao(const Value: String);
    procedure SetConstrutorParametros(const Value: TConstrutorParametros);
    procedure SetidPagamento(const Value: String);
    procedure SetCaminhoLog(const Value: String);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function CriarChaveRequisicao: String;
    function ConsultarStatusOperacional(numeroSessao: String): String;
    function ConsultaMFe(numeroSessao: String): String;
    function ExtrairLogs(numeroSessao: String): String;
    function TesteFimaFim(numeroSessao: String; dadosVenda: String): String;
    function EnviarDadosVenda(numeroSessao: String;
      dadosVenda: String; nrDocumento: String): String;
    function CancelarUltimaVenda(numeroSessao: String;
      dadosCancelamento: String): String;
    function AtivarMFe(numeroSessao: String; subComando: String;
      cnpj: String; cUF: String): String;
    function ConsultarNumeroSessao(numeroSessao: String;
      cNumeroDeSessao: String): String;
    function AssociarAssinatura(numeroSessao: String;
      cnpjValue: String; assinaturaCNPJs: String): String;
    procedure EnviarPagamento(sChaveRequisicao: String;
      sCodigoEstabelecimento: String;
      sForma: String; sSerialPOS: String;
      ValorOperacaoSujeitaICMS: Double; ValorTotalVenda: Double;
      HabilitarMultiplosPagamentos: String;
      HabilitarControleAntiFraude: String; CodigoMoeda: String;
      EmitirCupomNFCE: String; OrigemPagamento: String);
    procedure VerificarStatusValidador(idPagamento: String);
    procedure EnviarStatusPagamento(CodigoAutorizacao: String;
      Bin: String; DonoCartao: String; DataExpiracao: String;
      InstituicaoFinanceira: String; Parcelas: String;
      CodigoPagamento: String; ValorPagamento: String;
      IdFila: String; Tipo: String; UltimosQuatroDigitos: String);
    function EnviarRespostaFiscal(idFila: String; IdCFe: String): String;
    procedure idRespostaFiscal(idFila: String; idResposta: String);
    function GetidPagamento(sForma: String; iSequenciaForma: Integer): String;
    function GetidRespostaFiscal(sForma: String;
      sIdPagamento: String): String;
    function GetStatusTransmissaoidRespostaFiscal(sForma: String;
      sIdPagamento: String): String;
    function GetBandeiraRespostaFiscal(sForma: String;
      sIdPagamento: String): String;
    function GetAdquirenteRespostaFiscal(sForma: String;
      sIdPagamento: String): String;
    function SelecionarDadosAdquirente(sArquivoIni: String;
      sAdquirenteNome: String; var sUltimaAdquirenteUsada: String): Boolean; // Sandro Silva 2018-07-03
    function idPagamentoTransmitido(idPagamento: String): String;
    procedure SalvaLog(sNomeArquivo: String; sConteudo: String);
    property Identificador: String read FIdentificador write SetIdentificador;
    property Parametros: TParametrosList read FParametros write SetParametros;
    property ConstrutorParametros: TConstrutorParametros read FConstrutorParametros write SetConstrutorParametros;
    property XmlSolicitacao: String read FXmlSolicitacao write SetXmlSolicitacao;
    property CaminhoIntegrador: String read FCaminhoIntegrador write SetCaminhoIntegrador;
    property UltimaSolicitacao: String read FUltimaSolicitacao write SetUltimaSolicitacao;
    property MensagemRetorno: String read FMensagemRetorno write SetMensagemRetorno;
    property XmlResposta: String read FXmlResposta write SetXmlResposta;
    property codigoDeAtivacao: String read FcodigoDeAtivacao write SetcodigoDeAtivacao;
    property UltimoidPagamento: String read FUltimoidPagamento write SetidPagamento;
    property UltimoidRespostaFiscal: String read FUltimoidRespostaFiscal write FUltimoidRespostaFiscal;
    property CnpjContribuinte: String read FcnpjContribuinte write FcnpjContribuinte;
    property ChaveAcessoValidador: String read FchaveAcessoValidador write FchaveAcessoValidador;
    property CodigoEstabelecimento: String read FCodigoEstabelecimento write FCodigoEstabelecimento;
    property ChaveRequisicao: String read FChaveRequisicao write FChaveRequisicao;
    property CaminhoLog: String read FCaminhoLog write SetCaminhoLog;
    property Caixa: String read FCaixa write FCaixa;
    property TransacaoFinanceira: TTransacaoCartaoMFE read FTransacao write FTransacao;
    property SerialPOS: String read FSerialPOS write FSerialPOS;
    property EnviarFormaPagamento: TEnviarPagamento read FEnviarPagamento write FEnviarPagamento;
    property DiretorioAtual: String read FDiretorioAtual write FDiretorioAtual;
    property ComponenteMFE: String read FComponenteMFE write FComponenteMFE;
    property UsandoSimuladorPOS: Boolean read FUsandoSimuladorPOS write FUsandoSimuladorPOS;
  published

  end;

implementation

uses StrUtils, DateUtils;

function GuidCreate: String;
var
  ID: TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID);
  Result := StringReplace(Result, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

procedure ListaDeArquivos(var Lista: TStringList; sAtual: String; sExtensao: String = '*.xml');
var
  S : TSearchREc;
  I : Integer;
begin
  Lista.Clear;
  //
  I := FindFirst( sAtual + '\' + Trim(sExtensao), faAnyFile, S);
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

{ TParametro }

procedure TParametro.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TParametro.SetValor(const Value: String);
begin
  FValor := Value;
end;

{ TParametrosList }

function TParametrosList.Adiciona: TParametro;
begin
  Result := TParametro.Create;
  Add(Result);
end;

function TParametrosList.GetItem(Index: Integer): TParametro;
begin
  Result := TParametro(inherited Items[Index]);
end;

procedure TParametrosList.SetItem(Index: Integer; const Value: TParametro);
begin
  Put(Index, Value);
end;                                       

{ TConstrutorParametros }

function TConstrutorParametros.Adiciona: TParametro;
begin
  Result := TParametro.Create;
  Add(Result);
end;

function TConstrutorParametros.GetItem(Index: Integer): TParametro;
begin
  Result := TParametro(inherited Items[Index]);
end;

procedure TConstrutorParametros.SetItem(Index: Integer;
  const Value: TParametro);
begin
  Put(Index, Value);
end;

{ TIntegradorFiscal }

procedure TIntegradorFiscal.AdicionaParametro(sNome, sValor: String);
begin
  with FParametros.Adiciona do
  begin
    Nome  := sNome;
    Valor := sValor;
  end;
end;

procedure TIntegradorFiscal.AdicionaParametroConstrutor(sNome, sValor: String);
begin
  with FConstrutorParametros.Adiciona do
  begin
    Nome  := sNome;
    Valor := sValor;
  end;
end;

function TIntegradorFiscal.CapturaResposta: String;
var
  slResp: TStringList;
  slXml: TStringList;
  iResp: Integer;
  bBreak: Boolean;
  dtInicio: TDateTime;
begin
  FMensagemRetorno := '';

  // Limpar IDPAGAMENTO somente se fizer nova solicitação de pagamento ao Validador
  if (xmlNodeValue(FXmlSolicitacao, '//Integrador/Componente/@Nome') = COMPONENTE_VFPE) and
    (xmlNodeValue(FXmlSolicitacao, '//Integrador/Componente/Metodo/@Nome') = METODO_VFPE_ENVIAR_PAGAMENTO) then
    FUltimoidPagamento     := '';

  slResp := TStringList.Create;
  slXml  := TStringList.Create;
  bBreak := False;
  try
    dtInicio := Now;
    while bBreak = False do
    begin
      ListaDeArquivos(slResp, FCaminhoIntegrador + '\output');
      for iResp := 0 to slResp.Count - 1 do
      begin
        Sleep(50);
        try
          slXml.LoadFromFile(FCaminhoIntegrador + '\output\' + slResp.Strings[iResp]);
          FXmlResposta := slXml.Text;
          while AnsiContainsText(FXmlResposta, '  ') do
            FXmlResposta := StringReplace(FXmlResposta, '  ', ' ', [rfReplaceAll]);

          FXmlResposta := StringReplace(FXmlResposta, 'ï»¿', '', [rfReplaceAll]);

          // Integrador define encoding como sendo utf-8 e retornando caracteres especiais. Isso causa conflito.
          if AnsiContainsText(FXmlResposta, '<?xml version="1.0" encoding="utf-8"?>') then
          begin
            FXmlResposta := StringReplace(FXmlResposta, 'encoding="utf-8"', 'encoding="ISO-8859-1"', [rfReplaceAll]);
          end;

          if AnsiContainsText(FXmlResposta, '<Valor>' + FIdentificador + '</Valor>') then
          begin
            try
              DeleteFile(FCaminhoIntegrador + '\output\' + slResp.Strings[iResp]);
            except

            end;

            if AnsiContainsText(FXmlResposta, '<retorno>') then
              FMensagemRetorno := xmlNodeValue(FXmlResposta, '//Integrador/Resposta/retorno');

            if AnsiContainsText(FXmlResposta, '<Erro>') then
              FMensagemRetorno := 'Erro! ' + xmlNodeValue(FXmlResposta, '//Integrador/Erro/Codigo') + ' - ' + xmlNodeValue(FXmlResposta, '//Integrador/Erro/Valor');

            if FMensagemRetorno = '' then
              FMensagemRetorno := FXmlResposta;

            SalvaLog(FCaminhoLog + '\MFe' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FCaixa + '-ret-' + xmlNodeValue(FXmlSolicitacao, '//Integrador/Componente/Metodo/@Nome') + '_' + FIdentificador + '.xml', FXmlResposta);

            bBreak := True;
            Break;
          end; // if AnsiContainsText(FXmlResposta, '<Valor>' + FIdentificador + '</Valor>') then
        except
        end;
      end; // for iResp := 0 to slResp.Count - 1 do
      if SecondsBetween(Now, dtInicio) >= 30 then
      begin
        DeleteFile(PChar(FUltimaSolicitacao + '.xml'));
        bBreak := True;
      end;
    end; // while bBreak = False do
  finally
    slResp.Clear;
    slXml.Clear;
    FreeAndNil(slResp);
    FreeAndNil(slXml);
  end;

  if (xmlNodeValue(FXmlSolicitacao, '//Integrador/Componente/@Nome') = COMPONENTE_VFPE) and
    (xmlNodeValue(FXmlSolicitacao, '//Integrador/Componente/Metodo/@Nome') = METODO_VFPE_ENVIAR_PAGAMENTO) then
    FUltimoidPagamento := xmlNodeValue(FXmlResposta, '//Resposta/IdPagamento');
end;

constructor TIntegradorFiscal.Create;
begin
  FComponenteMFE        := COMPONENTE_MFE;
  FParametros           := TParametrosList.Create;
  FConstrutorParametros := TConstrutorParametros.Create;
  FTransacao            := TTransacaoCartaoMFE.Create;
  FEnviarPagamento      := TEnviarPagamento.Create;
end;

destructor TIntegradorFiscal.Destroy;
begin
  FParametros.Free;
  FConstrutorParametros.Free;
  FTransacao.Free;
  FEnviarPagamento.Free;
end;

procedure TIntegradorFiscal.SetCaminhoIntegrador(const Value: String);
begin
  FCaminhoIntegrador := Value;
end;

procedure TIntegradorFiscal.SetIdentificador(const Value: String);
begin
  FIdentificador := Value;
end;

procedure TIntegradorFiscal.SetParametros(const Value: TParametrosList);
begin
  FParametros := Value;
end;

procedure TIntegradorFiscal.SetConstrutorParametros(
  const Value: TConstrutorParametros);
begin
  FConstrutorParametros := Value;
end;

procedure TIntegradorFiscal.SetMensagemRetorno(const Value: String);
begin
  FMensagemRetorno := Value;
end;

procedure TIntegradorFiscal.SetUltimaSolicitacao(const Value: String);
begin
  FUltimaSolicitacao := Value;
end;

procedure TIntegradorFiscal.SetXmlResposta(const Value: String);
begin
  FXmlResposta := Value;
end;

procedure TIntegradorFiscal.SetXmlSolicitacao(const Value: String);
begin
  FXmlSolicitacao := Value;
end;

procedure TIntegradorFiscal.SetcodigoDeAtivacao(const Value: String);
begin
  FcodigoDeAtivacao := Value;
end;

procedure TIntegradorFiscal.GeraSolicitacao;
var
  slXML: TStringList;
  iParam: Integer;
begin
  FIdentificador := FCaixa + FormatDateTime('HHnnsszzz', Time); // Sandro Silva 2017-05-26  FCaixa + '-' + FormatDateTime('HHnnsszzz', Time); // Sandro Silva 2017-05-18 FormatDateTime('HHnnsszzz', Time);
  slXML := TStringList.Create;
  slXML.Clear;
  slXML.Text := '<?xml version="1.0" encoding="utf-8" standalone="yes"?>' +
    '<Integrador>'+
      '<Identificador>' +
        '<Valor>' + FIdentificador + '</Valor>' +
      '</Identificador>' +
      '<Componente Nome="' + FComponente + '">' +
        '<Metodo Nome="' + FMetodo + '">';

  if FConstrutorParametros.Count > 0 then
  begin
    slXML.Text := slXML.Text +
          '<Construtor>' +
            '<Parametros>';
    for iParam := 0 to FConstrutorParametros.Count - 1 do
    begin
      slXML.Text := slXML.Text +
              '<Parametro>' +
                '<Nome>' + FConstrutorParametros.Items[iParam].Nome + '</Nome>' +
                //'<!--int-->' +
                '<Valor>' + FConstrutorParametros.Items[iParam].Valor + '</Valor>' +
              '</Parametro>';
    end;
    slXML.Text := slXML.Text +
            '</Parametros>' +
          '</Construtor>';
  end;

  slXML.Text := slXML.Text +
          '<Parametros>';
  for iParam := 0 to FParametros.Count - 1 do
  begin
    slXML.Text := slXML.Text +
            '<Parametro>' +
              '<Nome>' + FParametros.Items[iParam].Nome + '</Nome>' +
              //'<!--int-->' +
              '<Valor>' + FParametros.Items[iParam].Valor + '</Valor>' +
            '</Parametro>';
  end;
  slXML.Text := slXML.Text +
          '</Parametros>' +
        '</Metodo>' +
      '</Componente>' +
    '</Integrador>';

  SalvaLog(FCaminhoLog + '\MFe' +  FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) + '-' + FCaixa + '-env-' + FMetodo + '_' + FIdentificador  + '.xml', slXML.Text);

  if Trim(FChaveRequisicao) = '' then
    FUltimaSolicitacao := FCaminhoIntegrador + '\input\' + FCaixa + '-' + FormatDateTime('yyyy-mm-dd-HH-nn-ss-zzz', Now) // Sandro Silva 2017-05-10  GuidCreate;
  else
    FUltimaSolicitacao := FCaminhoIntegrador + '\input\' + FCaixa + '-' + FChaveRequisicao; // Sandro Silva 2017-05-10  GuidCreate;
  slXML.SaveToFile(FUltimaSolicitacao + '.tmp');
  DeleteFile(PChar(FUltimaSolicitacao + '.xml'));
  RenameFile(PChar(FUltimaSolicitacao + '.tmp'), PChar(FUltimaSolicitacao + '.xml'));
  Sleep(50); // Tempo de renomear

  FXmlSolicitacao := slXML.Text;

  FreeAndNil(slXML);
  ChDir(FDiretorioAtual); // Sandro Silva 2017-05-20
end;

function TIntegradorFiscal.ConsultaMFe(numeroSessao: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_CONSULTAR;
  AdicionaParametro('numeroSessao', numeroSessao);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.ConsultarStatusOperacional(numeroSessao: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_CONSULTAR_STATUS_OPERACIONAL;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.ExtrairLogs(numeroSessao: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_EXTRAIR_LOGS;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.TesteFimaFim(numeroSessao, dadosVenda: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_TESTE_FIM_A_FIM;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('dadosVenda', '<![CDATA[' + xmlNodeXml(dadosVenda, '//CFe') + ']]>' );
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.EnviarDadosVenda(numeroSessao, dadosVenda,
  nrDocumento: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_ENVIAR_DADOS_VENDA;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('dadosVenda', '<![CDATA[' + xmlNodeXml(dadosVenda, '//CFe') + ']]>' );
  AdicionaParametro('nrDocumento', nrDocumento);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.CancelarUltimaVenda(numeroSessao,
  dadosCancelamento: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_CANCELAR_ULTIMA_VENDA;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('chave', LimpaNumero(xmlNodeValue(dadosCancelamento, '//infCFe/@chCanc')));
  AdicionaParametro('dadosCancelamento', '<![CDATA[' + dadosCancelamento + ']]>' );
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.AtivarMFe(numeroSessao, subComando, cnpj,
  cUF: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_ATIVAR;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('subComando', subComando);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('cnpj', cnpj);
  AdicionaParametro('cUF', cUF);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.ConsultarNumeroSessao(numeroSessao,
  cNumeroDeSessao: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_CONSULTAR_NUMERO_SESSAO;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('cNumeroDeSessao', cNumeroDeSessao);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

function TIntegradorFiscal.AssociarAssinatura(numeroSessao, cnpjValue,
  assinaturaCNPJs: String): String;
begin
  LimparParametros;
  FComponente := FComponenteMFE;
  FMetodo     := METODO_MFE_ASSOCIAR_ASSINATURA;
  AdicionaParametro('numeroSessao', numeroSessao);
  AdicionaParametro('codigoDeAtivacao', FcodigoDeAtivacao);
  AdicionaParametro('cnpjValue', cnpjValue);
  AdicionaParametro('assinaturaCNPJs', assinaturaCNPJs);
  GeraSolicitacao;
  CapturaResposta;
  Result := FMensagemRetorno;
end;

procedure TIntegradorFiscal.EnviarPagamento(sChaveRequisicao: String;
  sCodigoEstabelecimento: String;
  sForma: String; sSerialPOS: String;
  ValorOperacaoSujeitaICMS, ValorTotalVenda: Double;
  HabilitarMultiplosPagamentos, HabilitarControleAntiFraude, CodigoMoeda,
  EmitirCupomNFCE, OrigemPagamento: String);
var
  iForma: Integer;
  bNovoidPagamento: Boolean;
begin
  LimparParametros;
  FComponente := COMPONENTE_VFPE;
  FMetodo     := METODO_VFPE_ENVIAR_PAGAMENTO;

  // Controla para não gerar idpagamento que fique sem resposta dos dados de pagamento
  bNovoidPagamento := True;
  if FEnviarPagamento.Formas.Count > 0 then
  begin //Foi enviado pagamento
    if (FEnviarPagamento.Formas.Items[FEnviarPagamento.Formas.Count -1].RespostaFiscal.Nsu = '') and (FUltimoidPagamento <> '') then // if (FEnviarPagamento.Forma.Items[FEnviarPagamento.Forma.Count -1].RespostaFiscal.Nsu = '') then
    begin  // Último pagamento não tem autorização
      bNovoidPagamento := False;
    end;
  end;

  if bNovoidPagamento then
  begin
    iForma := FEnviarPagamento.AdicionaForma;
    FEnviarPagamento.Formas.Items[iForma].EmitirCupomNFCE              := EmitirCupomNFCE;
    FEnviarPagamento.Formas.Items[iForma].ValorTotalVenda              := StringReplace(FormatFloat('0.00', ValorTotalVenda), ',', '.', [rfReplaceAll]); // Sandro Silva 2017-09-21 Sem simulador POS deve ser ponto o separador decimal
    if FUsandoSimuladorPOS then
      FEnviarPagamento.Formas.Items[iForma].ValorTotalVenda            := FormatFloat('0.00', ValorTotalVenda);
    FEnviarPagamento.Formas.Items[iForma].IcmsBase                     := StringReplace(FloatToStr(ValorOperacaoSujeitaICMS), ',', '.', [rfReplaceAll]); // Sandro Silva 2017-09-21 Com simulador POS deve ser ponto o separador decimal
    FEnviarPagamento.Formas.Items[iForma].CodigoMoeda                  := CodigoMoeda;
    FEnviarPagamento.Formas.Items[iForma].OrigemPagamento              := OrigemPagamento;
    FEnviarPagamento.Formas.Items[iForma].HabilitarMultiplosPagamentos := HabilitarMultiplosPagamentos;
    FEnviarPagamento.Formas.Items[iForma].HabilitarControleAntiFraude  := HabilitarControleAntiFraude;
    FEnviarPagamento.Formas.Items[iForma].Forma                        := Copy(sForma, 1, 2);
    FEnviarPagamento.Formas.Items[iForma].TipoForma                    := AnsiUpperCase(sForma);

    AdicionaParametroConstrutor('chaveAcessoValidador', FchaveAcessoValidador);
    AdicionaParametro('ChaveRequisicao', sChaveRequisicao);
    AdicionaParametro('Estabelecimento', sCodigoEstabelecimento);
    AdicionaParametro('SerialPos', sSerialPOS); // Sandro Silva 2017-05-17  FSerialPOS);
    AdicionaParametro('Cnpj', FcnpjContribuinte);
    AdicionaParametro('IcmsBase', FEnviarPagamento.Formas.Items[iForma].IcmsBase);
    AdicionaParametro('ValorTotalVenda', FEnviarPagamento.Formas.Items[iForma].ValorTotalVenda);
    AdicionaParametro('HabilitarMultiplosPagamentos', FEnviarPagamento.Formas.Items[iForma].HabilitarMultiplosPagamentos); // 'True' ou 'False'
    AdicionaParametro('HabilitarControleAntiFraude', FEnviarPagamento.Formas.Items[iForma].HabilitarControleAntiFraude); // 'True' ou 'False'
    AdicionaParametro('CodigoMoeda', FEnviarPagamento.Formas.Items[iForma].CodigoMoeda); // 'BRL'
    AdicionaParametro('EmitirCupomNFCE', FEnviarPagamento.Formas.Items[iForma].EmitirCupomNFCE); // 'True' ou 'False'
    AdicionaParametro('OrigemPagamento', FEnviarPagamento.Formas.Items[iForma].OrigemPagamento);
    GeraSolicitacao;
    CapturaResposta;
    FEnviarPagamento.Formas.Items[iForma].idPagamento := FUltimoidPagamento;
    FEnviarPagamento.Formas.Items[iForma].Transmitido := 'S';
    if AnsiContainsText(FXmlResposta, '<StatusPagamento>SalvoEmArmazenamentoLocal</StatusPagamento>') then
      FEnviarPagamento.Formas.Items[iForma].Transmitido := 'N';
  end;
end;

procedure TIntegradorFiscal.SetidPagamento(const Value: String);
begin
  FUltimoidPagamento := Value;
end;

procedure TIntegradorFiscal.VerificarStatusValidador(idPagamento: String);
begin
  LimparParametros;
  FComponente := COMPONENTE_VFPE;
  FMetodo     := METODO_VFPE_VERIFICAR_STATUS_VALIDADOR;
  AdicionaParametroConstrutor('chaveAcessoValidador', FchaveAcessoValidador);
  AdicionaParametro('idFila', idPagamento);
  AdicionaParametro('cnpj', FcnpjContribuinte);
  GeraSolicitacao;
  CapturaResposta;
end;

procedure TIntegradorFiscal.EnviarStatusPagamento(CodigoAutorizacao, Bin,
  DonoCartao, DataExpiracao, InstituicaoFinanceira, Parcelas,
  CodigoPagamento, ValorPagamento, IdFila, Tipo,
  UltimosQuatroDigitos: String);
begin
  LimparParametros;
  FComponente := COMPONENTE_VFPE;
  FMetodo     := METODO_VFPE_ENVIAR_STATUS_PAGAMENTO;
  AdicionaParametroConstrutor('chaveAcessoValidador', FchaveAcessoValidador);
  AdicionaParametro('CodigoAutorizacao', CodigoAutorizacao);
  AdicionaParametro('Bin', Bin);
  AdicionaParametro('DonoCartao', DonoCartao);
  AdicionaParametro('DataExpiracao', DataExpiracao);
  AdicionaParametro('InstituicaoFinanceira', InstituicaoFinanceira);
  AdicionaParametro('Parcelas', Parcelas);
  AdicionaParametro('CodigoPagamento', CodigoPagamento);
  AdicionaParametro('ValorPagamento', ValorPagamento);
  AdicionaParametro('IdFila', IdFila);
  AdicionaParametro('Tipo', Tipo);
  AdicionaParametro('UltimosQuatroDigitos', UltimosQuatroDigitos);
  GeraSolicitacao;
  CapturaResposta;
end;

function TIntegradorFiscal.EnviarRespostaFiscal(idFila, IdCFe: String): String;
var
  iItem: Integer;
  bAchou: Boolean; // Sandro Silva 2018-07-03
  sNumeroDocumentoFiscal: String;
begin
  LimparParametros;
  FComponente := COMPONENTE_VFPE;
  FMetodo     := METODO_VFPE_RESPOSTA_FISCAL;

  if FEnviarPagamento.Formas.Count > 0 then //if FRespostaFiscal.Count > 0 then // Sandro Silva 2018-07-03
  begin

    AdicionaParametroConstrutor('chaveAcessoValidador', FchaveAcessoValidador);
    AdicionaParametro('idFila', idFila);
    AdicionaParametro('ChaveAcesso', IdCFe);

    bAchou := False;
    for iItem := 0 to FEnviarPagamento.Formas.Count -1 do
    begin
      if FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.idFila = idFila then
      begin
        bAchou := True;
        Break;
      end;
    end;

    if bAchou then
    begin
      sNumeroDocumentoFiscal := '';
      if Copy(IdCFe, 21, 2) = '59' then
        sNumeroDocumentoFiscal := Copy(IdCFe, 32, 6);
      if Copy(IdCFe, 21, 2) = '65' then
        sNumeroDocumentoFiscal := Copy(IdCFe, 26, 9);
      AdicionaParametro('Nsu', FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.Nsu);
      AdicionaParametro('NumerodeAprovacao', FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.NumerodeAprovacao);
      AdicionaParametro('Bandeira', FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.Bandeira);
      AdicionaParametro('Adquirente', FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.Adquirente);
      AdicionaParametro('Cnpj', FcnpjContribuinte);
      AdicionaParametro('ImpressaoFiscal', '');
      AdicionaParametro('NumeroDocumento', sNumeroDocumentoFiscal); // Sandro Silva 2018-07-03 AdicionaParametro('NumeroDocumento', '');
      GeraSolicitacao;
      CapturaResposta;
      FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.idRespostaFiscal := xmlNodeValue(FXmlResposta, '//Resposta/retorno');// Sandro Silva 2017-05-20

      idRespostaFiscal(idFila, FEnviarPagamento.Formas.Items[iItem].RespostaFiscal.idRespostaFiscal);

      Result := xmlNodeValue(FXmlResposta, '//Resposta/retorno');
    end;
  end;
end;

procedure TIntegradorFiscal.LimparParametros;
begin
  FParametros.Clear;
  FConstrutorParametros.Clear;
end;

function TIntegradorFiscal.CriarChaveRequisicao: String;
begin
  Result := GuidCreate;
end;

procedure TIntegradorFiscal.SetCaminhoLog(const Value: String);
var
  sLogDia: String;
begin
  FCaminhoLog := Value;
  sLogDia := FCaminhoLog + '\IntegradorFiscal\' + FormatDateTime('yyyymmdd', Date);
  ForceDirectories(FCaminhoLog);
  ForceDirectories(sLogDia);// Sandro Silva 2018-07-03  ForceDirectories(FCaminhoLog + '\MFe');// Sandro Silva 2017-05-15
  if DirectoryExists(sLogDia) then
    FCaminhoLog := sLogDia;
end;

procedure TIntegradorFiscal.idRespostaFiscal(idFila, idResposta: String);
var
  iForma: Integer;
begin
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if FEnviarPagamento.Formas.Items[iForma].idPagamento = idFila then
    begin
      FEnviarPagamento.Formas.Items[iForma].idRespostaFiscal := idResposta;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.GetidPagamento(sForma: String;
  iSequenciaForma: Integer): String;
var
  iForma: Integer;
begin
  Result := '';
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if (FEnviarPagamento.Formas.Items[iForma].Forma = sForma) and (iForma = iSequenciaForma) then
    begin
      Result := FEnviarPagamento.Formas.Items[iForma].idPagamento;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.GetidRespostaFiscal(sForma: String;
  sIdPagamento: String): String;
var
  iForma: Integer;
begin
  Result := '';
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if (FEnviarPagamento.Formas.Items[iForma].Forma = sForma) and (FEnviarPagamento.Formas.Items[iForma].idPagamento = sIdPagamento) then
    begin
      Result := FEnviarPagamento.Formas.Items[iForma].idRespostaFiscal;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.GetStatusTransmissaoidRespostaFiscal(sForma: String;
  sIdPagamento: String): String;
var
  iForma: Integer;
begin
  Result := '';
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if (FEnviarPagamento.Formas.Items[iForma].Forma = sForma) and (FEnviarPagamento.Formas.Items[iForma].idPagamento = sIdPagamento) then
    begin
      Result := FEnviarPagamento.Formas.Items[iForma].Transmitido;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.GetBandeiraRespostaFiscal(sForma: String;
  sIdPagamento: String): String;
var
  iForma: Integer;
begin
  Result := '';
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if (FEnviarPagamento.Formas.Items[iForma].Forma = sForma) and (FEnviarPagamento.Formas.Items[iForma].idPagamento = sIdPagamento) then
    begin
      Result := FEnviarPagamento.Formas.Items[iForma].RespostaFiscal.Bandeira;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.GetAdquirenteRespostaFiscal(sForma: String;
  sIdPagamento: String): String;
var
  iForma: Integer;
begin
  Result := '';
  for iForma := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if (FEnviarPagamento.Formas.Items[iForma].Forma = sForma) and (FEnviarPagamento.Formas.Items[iForma].idPagamento = sIdPagamento) then
    begin
      Result := FEnviarPagamento.Formas.Items[iForma].RespostaFiscal.Adquirente;
      Break;
    end;
  end;
end;

function TIntegradorFiscal.SelecionarDadosAdquirente(sArquivoIni: String;
  sAdquirenteNome: String; var sUltimaAdquirenteUsada: String): Boolean;
// Seleciona os dados da adquirente salvos no arquivo .ini.
// retorna o nome da última adquirente usada para sUltimaAdquirenteUsada
var
  IniADQUIRENTE: TIniFile;
  sSecoes :  TStrings;
  I: Integer;
begin
  Result := False;

  sSecoes := TStringList.Create;
  IniADQUIRENTE := TIniFile.Create(sArquivoIni);
  try
    sSecoes.Clear;
    IniADQUIRENTE.ReadSections(sSecoes); //conta o número de itens

    for I := 0 to sSecoes.Count - 1 do
    begin
      if AnsiContainsText(sSecoes.Strings[I], 'ADQUIRENTE') then
      begin
        if (sAdquirenteNome = IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Gerenciador TEF', 'xxx')) // Se usando TEF
         or (sAdquirenteNome = IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Nome', 'xxx')) then  // Se usando POS
        begin
          if (IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Ativo', 'Sim') = 'Sim') // Se usando TEF
            or (IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'POS Ativo', 'Sim') = 'Sim') then // Se usando POS
          begin
            FChaveRequisicao       := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Chave Requisicao', '');
            FCodigoEstabelecimento := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'ID Estabelecimento', '');
            FSerialPOS             := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Serial POS', '');
            sUltimaAdquirenteUsada := IniADQUIRENTE.ReadString(sSecoes.Strings[I], 'Nome', 'xxx'); // Sandro Silva 2017-09-04  sAdquirenteNome;

            Break;
          end;
        end;
      end;
    end;

    Result := True;
  except
  end;
  sSecoes.Free;
  IniADQUIRENTE.Free;
end;

function TIntegradorFiscal.idPagamentoTransmitido(idPagamento: String): String;
// Verifica se o idPagamento foi transmitido. Retorna S ou N
// Se não há conexão com internet Pagamento não é transmitido. Integrador retorna um IDPagamento local
var
  iItem: Integer;
begin
  Result := '';
  for iItem := 0 to FEnviarPagamento.Formas.Count - 1 do
  begin
    if FEnviarPagamento.Formas.Items[iItem].idPagamento = idPagamento then
    begin
      Result := FEnviarPagamento.Formas.Items[iItem].Transmitido;
      Break
    end;
  end;
end;

procedure TIntegradorFiscal.SalvaLog(sNomeArquivo, sConteudo: String);
var
  Arq: TArquivo;
begin
  Arq := TArquivo.Create;
  try
    Arq.Texto := sConteudo;
    Arq.SalvarArquivo(sNomeArquivo);
  except
  end;
  FreeAndNil(Arq);
end;

{ TArquivo }

procedure TArquivo.LerArquivo(FileName: TFileName);
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
          FTexto := FTexto + #10 + #13;
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
    AssignFile(FArquivo, FileName); // Sandro Silva 2021-06-28 AssignFile(FArquivo, PAnsiChar(FileName));
    Rewrite(FArquivo);
    Writeln(FArquivo, FTexto);
    CloseFile(FArquivo);
  except

  end;
end;

{ TTransacaoCartaoMFE }

function TTransacaoCartaoMFE.GetBin: String;
begin
  FBin := IfThen(LimpaNumero(GetLinha('010-004')) = '',  '0000', GetLinha('010-004'));
  Result := FBin;
end;

function TTransacaoCartaoMFE.GetCodigoAutorizacao: String;
begin
  FCodigoAutorizacao := GetLinha('013-000');
  Result := FCodigoAutorizacao;
end;

function TTransacaoCartaoMFE.GetCodigoPagamento: String;
begin
  FCodigoPagamento := GetLinha('012-000'); //CodigoPagamento,
  Result := FCodigoPagamento;
end;

function TTransacaoCartaoMFE.GetDataExpiracao: String;
begin
  FDataExpiracao := IfThen(LimpaNumero(GetLinha('300-001')) = '',  '0000', GetLinha('741-000'));  //DataExpiracao,
  Result := FDataExpiracao;
end;

function TTransacaoCartaoMFE.GetDonoCartao: String;
begin
  FDonoCartao := IfThen(GetLinha('210-027') = '',  'Indefinido', GetLinha('210-027')); //DonoCartao, // Certificadora SITEF orientou que essa informação não pode ser repassada na transação, como determina normas internacionais de segurança
  Result := FDonoCartao;
end;

function TTransacaoCartaoMFE.GetInstituicaoFinanceira: String;
begin
  // No futuro tratar respostas conforme tipo TEF (sitef, pay&go). sitef retorno código da instituição (Ex.: 010-001 = AP refere-se a CIELO) 
  FInstituicaoFinanceira := GetLinha('010-000'); //InstituicaoFinanceira
  Result := FInstituicaoFinanceira;
end;

function TTransacaoCartaoMFE.GetLinha(Codigo: String): String;
var
  iLinha: Integer;
  sLinha: String;
  slLinhas: TStringList;
begin
  Result := '';
  slLinhas := TStringList.Create;
  slLinhas.Text := FResposta;
  for iLinha := 0 to slLinhas.Count -1 do
  begin
    sLinha := slLinhas.Strings[iLinha];
    if Copy(sLinha, 1, Length(Codigo)) = Codigo then
    begin
      if Result <> '' then
        Result := Result + #10;
      Result := Result + StringReplace(Trim(Copy(sLinha, 10, Length(sLinha)-9)), '"', '', [rfReplaceAll]);
    end;
  end;
  slLinhas.Free;
end;

function TTransacaoCartaoMFE.GetParcelas: String;
begin
  FParcelas := IfThen(StrToIntDef(GetLinha('018-000'), 0) = 0, '1', GetLinha('018-000')); //Parcelas,
  Result := FParcelas;
end;

function TTransacaoCartaoMFE.GetTipo: String;
begin
  FTipo := GetLinha('040-000'); //Tipo,

  if Trim(FTipo) = '' then
  begin
    FTipo := AnsiUpperCase(GetLinha('010-000'));
    FTipo := StringReplace(StringReplace(FTipo, 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]);
  end;

  Result := FTipo;
end;

function TTransacaoCartaoMFE.GetUltimosQuatroDigitos: String;
begin
  FUltimosQuatroDigitos := '0000'; //UltimosQuatroDigitos
  Result := FUltimosQuatroDigitos;
end;

function TTransacaoCartaoMFE.GetValorPagamento: String;
begin
  FValorPagamento := FloatToStr(StrToIntDef(GetLinha('003-000'), 0) / 100); //ValorPagamento,
  Result := FValorPagamento;
end;

procedure TTransacaoCartaoMFE.SetResposta(const Value: String);
begin
  FResposta := Value;
  if Trim(FResposta) = '' then
  begin
    FCodigoAutorizacao     := '';
    FCodigoPagamento       := '';
    FCodigoAutorizacao     := '';
    FTipo                  := '';
    FInstituicaoFinanceira := '';
  end;
end;

{ TRespostaFiscal }

procedure TRespostaFiscal.Clear;
begin
  FNsu               := '';
  FCodigoAutorizacao := '';
  FBandeira          := '';
  FAdquirente        := '';
  FNumerodeAprovacao := '';

end;

{ TFormaPagamentoList }

function TFormaPagamentoList.Adiciona: TFormaPagamento;
begin
  Result := TFormaPagamento.Create;
  Result.RespostaFiscal := TRespostaFiscal.Create;
  Add(Result);
end;

function TFormaPagamentoList.GetItem(Index: Integer): TFormaPagamento;
begin
  Result := TFormaPagamento(inherited Items[Index]);
end;

procedure TFormaPagamentoList.SetItem(Index: Integer;
  const Value: TFormaPagamento);
begin
  Put(Index, Value);
end;

{ TEnviarPagamento }

function TEnviarPagamento.AdicionaForma(TipoForma: String; Forma: String;
  EmitirCupomNFCE: String; ValorTotalVenda: String;
  IcmsBase: String; CodigoMoeda: String; OrigemPagamento: String;
  SerialPOS: String; cnpjContribuinte: String;
  HabilitarMultiplosPagamentos: String;
  HabilitarControleAntiFraude: String): Boolean;
begin
  Result := False;
  try
    with FFormaPagamentoList.Adiciona do
    begin
      EmitirCupomNFCE              := EmitirCupomNFCE;
      ValorTotalVenda              := ValorTotalVenda;
      IcmsBase                     := IcmsBase;
      CodigoMoeda                  := CodigoMoeda;
      OrigemPagamento              := OrigemPagamento;
      SerialPos                    := SerialPOS;
      CnpjContribuinte             := cnpjContribuinte;
      HabilitarMultiplosPagamentos := HabilitarMultiplosPagamentos;
      HabilitarControleAntiFraude  := HabilitarControleAntiFraude;
      Forma                        := Forma;
      TipoForma                    := TipoForma;
    end;
    Result := True;
  except
  end;
end;

function TEnviarPagamento.AdicionaForma: Integer;
begin
  FFormaPagamentoList.Adiciona;
  Result := FFormaPagamentoList.Count - 1;
end;

procedure TEnviarPagamento.Clear;
begin
  FFormaPagamentoList.Clear;
end;

constructor TEnviarPagamento.Create;
begin
  FFormaPagamentoList := TFormaPagamentoList.Create;
end;

destructor TEnviarPagamento.Destroy;
begin
  FFormaPagamentoList.Free;
  //inherited Destroy;
  //inherited; // Sandro Silva 2017-06-01 Igual TSmallSat
end;

{ TRespostaFiscalList }

function TRespostaFiscalList.Adiciona: TRespostaFiscal;
begin
  Result := TRespostaFiscal.Create;
  Add(Result);
end;

procedure TRespostaFiscalList.ExcluiItem(Index: Integer);
// Sandro Silva 2018-07-03
begin
  Remove(Items[Index]);
end;

function TRespostaFiscalList.GetItem(Index: Integer): TRespostaFiscal;
begin
  Result := TRespostaFiscal(inherited Items[Index]);
end;

procedure TRespostaFiscalList.SetItem(Index: Integer;
  const Value: TRespostaFiscal);
begin
  Put(Index, Value);
end;

end.
