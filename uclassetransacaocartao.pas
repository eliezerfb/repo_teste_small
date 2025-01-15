{ *************************************************************************** }
{                                                                             }
{ Classe para armazenar os dados das transaões com cartão                     }
{                                                                             }
{ Autor: Sandro Silva                                                         }
{ Data: 14/06/2017                                                            }
{                                                                             }
{ *************************************************************************** }
unit uclassetransacaocartao;

interface

uses
  Classes, Controls, Contnrs
  , SysUtils
  ;

type
  //Sandro Silva 2024-11-27 TTipoModalidadeTransacao = (tModalidadeNenhum, tModalidadeCartao, tModalidadeCarteiraDigital, tModalidadePix, tModalidadeOutros);
  TTipoModalidadeTransacao = (tModalidadeNenhum, tModalidadeCartaoNaoIdentificado, tModalidadeCartaoPOS, tModalidadeCartaoTEF, tModalidadeCarteiraDigital, tModalidadePix, tModalidadeOutros);

type
  TTiposTransacao = (tpNone, tpPOS, tpTEF); // Sandro Silva (smal-778) 2024-11-06

type
  TTipoTransacaoTefPos = class
    Tipo: TTiposTransacao;
    Descricao: String;
  end;

  TTransacaoCartaoList = class;

  TTransacaoCartao = class
  private
    FValorPago: Double;
    FNomeDoTEF: String;
    FDebitoOuCredito: String;
    FTransaca: String;
    FNomeRede: String;
    FAutorizacao: String;
    FBandeira: String;
    FBIN: String;
    FUltimosDigitos: String;
    FModalidade: TTipoModalidadeTransacao;
  public
    property NomeDoTEF: String read FNomeDoTEF write FNomeDoTEF;
    property DebitoOuCredito: String read FDebitoOuCredito write FDebitoOuCredito;
    property ValorPago: Double read FValorPago write FValorPago;
    property NomeRede: String read FNomeRede write FNomeRede;
    property Transaca: String read FTransaca write FTransaca;
    property Autorizacao: String read FAutorizacao write FAutorizacao;
    property Bandeira: String read FBandeira write FBandeira;
    property BIN: String read FBIN write FBIN;
    property UltimosDigitos: String read FUltimosDigitos write FUltimosDigitos;    
    property Modalidade: TTipoModalidadeTransacao read FModalidade write FModalidade;
  end;

  TTransacaoCartaoList = class(TObjectList)
  private
    function GetItem(Index: Integer): TTransacaoCartao;
    procedure SetItem(Index: Integer; const Value: TTransacaoCartao);
  public
    function Adicionar(sNomeDoTEF: String; sDebitoOuCredito: String;
      dValorPago: Double; sNomeRede: String; sTransaca: String;
      sAutorizacao, sBandeira, sBIN, sUltimosDigitos: String;
      Modalidade: TTipoModalidadeTransacao
      ): TTransacaoCartao;
    property Items[Index: Integer]: TTransacaoCartao read GetItem write SetItem;
    constructor Create;
  end;

type
  TTransacaoFinanceira = class(TControl)
  private
    {Private Declarations}
    FTransacoes: TTransacaoCartaoList;
    function GetTemTransacaoTef: Boolean;
  protected
    {Protected Declarations}
  public
    {Public Declarations}
    constructor Create(AOWner: TComponent); override;
    destructor Destroy; override;
    property TemTransacaoTef: Boolean read GetTemTransacaoTef;
    property Transacoes: TTransacaoCartaoList read FTransacoes write FTransacoes;
  published
    {Published Declarations}
  end;

implementation

{TTransacaoFinanceira}
constructor TTransacaoFinanceira.Create(AOWner: TComponent);
begin
  inherited Create(AOWner);
  FTransacoes := TTransacaoCartaoList.Create;
end;

destructor TTransacaoFinanceira.Destroy;
begin
  inherited Destroy;
end;

function TTransacaoFinanceira.GetTemTransacaoTef: Boolean;
var
  iTransacao: Integer;
begin
  Result := False;
  for iTransacao := 0 to FTransacoes.Count -1 do
  begin
    if FTransacoes.Items[iTransacao].FModalidade = tModalidadeCartaoTEF then
    begin
      Result := True;
      Break;
    end
  end;
end;

{ TTransacaoCartaoList }

constructor TTransacaoCartaoList.Create;
begin
  inherited Create(True);
end;

function TTransacaoCartaoList.Adicionar(sNomeDoTEF,
  sDebitoOuCredito: String; dValorPago: Double; sNomeRede,
  sTransaca, sAutorizacao, sBandeira, sBIN, sUltimosDigitos: String;
  Modalidade: TTipoModalidadeTransacao
  ): TTransacaoCartao;
begin
  Result := TTransacaoCartao.Create;
  Result.NomeDoTEF       := sNomeDoTEF;
  Result.DebitoOuCredito := sDebitoOuCredito;
  Result.ValorPago       := dValorPago;
  Result.NomeRede        := sNomeRede;
  Result.Transaca        := sTransaca;
  Result.Autorizacao     := sAutorizacao;
  Result.Bandeira        := sBandeira;
  Result.Modalidade      := Modalidade;
  Result.BIN             := sBIN;
  Result.UltimosDigitos  := sUltimosDigitos;

  if Trim(Result.NomeRede) = '' then // Sandro Silva 2023-04-25 f-6859
    Result.NomeRede := Result.NomeDoTEF;

  Add(Result);

end;

function TTransacaoCartaoList.GetItem(Index: Integer): TTransacaoCartao;
begin
  Result := TTransacaoCartao(inherited Items[Index]);
end;

procedure TTransacaoCartaoList.SetItem(Index: Integer;
  const Value: TTransacaoCartao);
begin
  Put(Index, Value);
end;

end.
