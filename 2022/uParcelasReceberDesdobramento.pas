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

constructor TReceberDesdobramento.Create;
begin
  inherited;

end;

destructor TReceberDesdobramento.Destroy;
begin

  inherited;
end;

end.
