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
  Classes, Controls, Contnrs;

type
  TTipoModalidadeTransacao = (tModalidadeNenhum, tModalidadeCartao, tModalidadeCarteiraDigital, tModalidadePix, tModalidadeOutros);

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
    //FCarteiraDigital: Boolean;
    FModalidade: TTipoModalidadeTransacao;
  public
    property NomeDoTEF: String read FNomeDoTEF write FNomeDoTEF;
    property DebitoOuCredito: String read FDebitoOuCredito write FDebitoOuCredito;
    property ValorPago: Double read FValorPago write FValorPago;
    property NomeRede: String read FNomeRede write FNomeRede;
    property Transaca: String read FTransaca write FTransaca;
    property Autorizacao: String read FAutorizacao write FAutorizacao;
    property Bandeira: String read FBandeira write FBandeira;
    //property CarteiraDigital: Boolean read FCarteiraDigital write FCarteiraDigital;
    property Modalidade: TTipoModalidadeTransacao read FModalidade write FModalidade;
  end;

  TTransacaoCartaoList = class(TObjectList)
  private
    function GetItem(Index: Integer): TTransacaoCartao;
    procedure SetItem(Index: Integer; const Value: TTransacaoCartao);
  public
    function Adicionar(sNomeDoTEF: String; sDebitoOuCredito: String;
      dValorPago: Double; sNomeRede: String; sTransaca: String;
      sAutorizacao: String; sBandeira: String;
      //bCarteiraDigital: Boolean
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
  protected
    {Protected Declarations}
  public
    {Public Declarations}
    constructor Create(AOWner: TComponent); override;
    destructor Destroy; override;
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

{ TTransacaoCartaoList }

constructor TTransacaoCartaoList.Create;
begin
  inherited Create(True);
end;

function TTransacaoCartaoList.Adicionar(sNomeDoTEF,
  sDebitoOuCredito: String; dValorPago: Double; sNomeRede,
  sTransaca: String; sAutorizacao: String;
  sBandeira: String;
  //bCarteiraDigital: Boolean
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
  //Result.CarteiraDigital := bCarteiraDigital;
  Result.Modalidade      := Modalidade;

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
