unit uParcelasReceberDesdobramento;

interface

uses
  IBCustomDataSet,
  uParcelasReceber
  ;

type
  TReceberDesdobramento = class(TParcelamentoReceber)
  private
  public
    constructor Create; Override;
    destructor Destroy; Override;
    procedure CalculaValores(DataSetItens: TibDataSet; iParcelas: Integer;
      dTotalParcelar: Double);
    procedure RateiaDiferenca(DataSetNota: TIBDataSet;
      DataSetParcelas: TIBDataSet; ModuloAtual: String);
    function TotalParcelasLancadas(DataSetParcelas: TIBDataSet): Double; 
  end;

implementation

{ TReceberDesdobramento }

procedure TReceberDesdobramento.CalculaValores(DataSetItens: TibDataSet;
  iParcelas: Integer; dTotalParcelar: Double);
var
  iRecno: Integer;
begin
  //if not Calculando then
  begin
    try
      iRecno := DataSetItens.Recno;

      AtualizaObjReceber(DataSetItens);
      ParcelarValor(iParcelas, dTotalParcelar);
      AtualizaDataSetReceber(DataSetItens);
      DataSetItens.Recno := iRecno;

    finally
    end;
  end;

end;

procedure TReceberDesdobramento.RateiaDiferenca(DataSetNota: TIBDataSet;
  DataSetParcelas: TIBDataSet; ModuloAtual: String);
var
  iRecno: Integer;
begin
  //if not Calculando then
  begin
    try
      DataSetParcelas.DisableControls;

      iRecno := DataSetParcelas.Recno;

      AtualizaObjReceber(DataSetParcelas);
      RateiaDiferencaParcelaEntreAsDemais(DataSetParcelas, ModuloAtual);
      AtualizaDataSetReceber(DataSetParcelas);

      DataSetParcelas.Recno := iRecno;

    finally
      DataSetParcelas.EnableControls;
    end;
  end;

end;

constructor TReceberDesdobramento.Create;
begin
  inherited;

end;

destructor TReceberDesdobramento.Destroy;
begin

  inherited;
end;

function TReceberDesdobramento.TotalParcelasLancadas(
  DataSetParcelas: TIBDataSet): Double;
var
  iRecno: Integer;
begin
  try
    iRecno := DataSetParcelas.Recno;

    AtualizaObjReceber(DataSetParcelas);

    Result := GetValorTotalParcelas;

    DataSetParcelas.Recno := iRecno;

  finally

  end;

end;

end.
