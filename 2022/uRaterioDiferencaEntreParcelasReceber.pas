unit uRaterioDiferencaEntreParcelasReceber;

interface

uses
  SysUtils,
  IBCustomDataSet,
  uParcelasReceber
  ;

type
  TRateioDiferencaEntreParcelasReceber = class(TParcelamentoReceber)
  private
  public
    constructor Create; Override;
    destructor Destroy; Override;
    //procedure ReparcelaValor(DataSetItens: TibDataSet; iParcelas: Integer;
    //  dTotalParcelar: Double);
    procedure RateiaDiferenca(DataSetNota: TIBDataSet;
      DataSetParcelas: TIBDataSet; ModuloAtual: String; dRetencaoIR: Double;
      dTotalNota: Double; iNumeroParcelas: Integer);
    function TotalParcelasLancadas(DataSetParcelas: TIBDataSet): Double;
  end;

implementation

{ TRateioDiferencaEntreParcelasReceber }
{
procedure TRateioDiferencaEntreParcelasReceber.ReparcelaValor(DataSetItens: TibDataSet;
  iParcelas: Integer; dTotalParcelar: Double);
var
  iRecno: Integer;
begin
  //if not Calculando then
  begin
    try
      DataSetItens.DisableControls;

      iRecno := DataSetItens.Recno;

      AtualizaObjReceber(DataSetItens);
      ReparcelaValor(DataSetItens, iParcelas, dTotalParcelar);
      AtualizaDataSetReceber(DataSetItens);
      DataSetItens.Recno := iRecno;

    finally
      DataSetItens.EnableControls;
    end;
  end;

end;
}
procedure TRateioDiferencaEntreParcelasReceber.RateiaDiferenca(DataSetNota: TIBDataSet;
  DataSetParcelas: TIBDataSet; ModuloAtual: String; dRetencaoIR: Double;
  dTotalNota: Double; iNumeroParcelas: Integer);
(*
var
  iRecno: Integer;
begin
  //if not Calculando then
  begin
    try
      DataSetParcelas.DisableControls;

      iRecno := DataSetParcelas.Recno;

      AtualizaObjReceber(DataSetParcelas);
      RateiaDiferencaParcelaEntreAsDemais(DataSetParcelas, ModuloAtual, dRetencaoIR, dTotalNota, iNumeroParcelas);
      AtualizaDataSetReceber(DataSetParcelas);

      DataSetParcelas.Recno := iRecno;

    finally
      DataSetParcelas.EnableControls;
    end;
  end;
*)
var
  dDiferenca: Currency; // Sandro Silva 2023-11-21 Double;
  iRegistro, iDuplicatas: Integer;
  dSomaParcelas: Currency; // Sandro Silva 2023-11-20
  i: Integer;
//  iRecno: Integer;
begin
  // Quando altera o valor de uma parcela, a diferença é repassada para as demais com vencimento posterior daquela alterada
  if ModuloAtual = 'VENDA' then // Ok
  begin
    try

      DataSetParcelas.DisableControls;

      iRegistro   := DataSetParcelas.Recno;//iRecno := DataSetParcelas.Recno;

      AtualizaObjReceber(DataSetParcelas); 

      //iRegistro   := iRecno;//DataSetParcelas.Recno;
      dDiferenca  := StrToFloat(FormatFloat('0.00', (dTotalNota - dRetencaoIR))); // Sandro Silva 2023-11-13 dDiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - FRetencaoIR);
      iDuplicatas := iNumeroParcelas;

      dSomaParcelas := GetValorTotalParcelas;// 0.00;

      if dSomaParcelas <> StrToFloat(FormatFloat('0.00',(dTotalNota - dRetencaoIR))) then
      begin
        for i := 0 to Parcelas.Count -1 do
        begin
          if (i + 1) <= iRegistro then
          begin
            iDuplicatas := iDuplicatas - 1;
            dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - Parcelas.Items[i].VALOR_DUPL)); // Sandro Silva 2023-11-13 dDiferenca := dDiferenca - Form7.ibDataSet7VALOR_DUPL.Value;
          end else
          begin
            Parcelas.Items[i].VALOR_DUPL := StrToFloat(FormatFloat('0.00', dDiferenca / iDuplicatas));
          end;
        end;
      end;

      dDiferenca  := StrToFloat(FormatFloat('0.00', (dTotalNota - dRetencaoIR))); // Sandro Silva 2023-11-20 dDiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - FRetencaoIR);
      for i := 0 to Parcelas.Count -1 do
      begin
        dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - StrToFloat(FormatFloat('0.00', Parcelas.Items[i].VALOR_DUPL)))); // Sandro Silva 2023-11-20 dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
      end;

      if dDiferenca <> 0 then
        Parcelas.Items[Parcelas.Count -1].VALOR_DUPL := StrToFloat(FormatFloat('0.00', Parcelas.Items[Parcelas.Count -1].VALOR_DUPL + dDiferenca)); // Sandro Silva 2023-11-20 Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat + dDiferenca]));

      AtualizaDataSetReceber(DataSetParcelas);

      DataSetParcelas.Recno := iRegistro;//DataSetParcelas.Recno := iRecno;

    finally
      DataSetParcelas.EnableControls;

    end;

  end;

end;

constructor TRateioDiferencaEntreParcelasReceber.Create;
begin
  inherited;

end;

destructor TRateioDiferencaEntreParcelasReceber.Destroy;
begin

  inherited;
end;

function TRateioDiferencaEntreParcelasReceber.TotalParcelasLancadas(
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
