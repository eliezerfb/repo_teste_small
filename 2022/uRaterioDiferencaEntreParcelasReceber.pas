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
    procedure RateiaDiferenca(DataSetNota: TIBDataSet;
      DataSetParcelas: TIBDataSet; ModuloAtual: String; dRetencaoIR: Double;
      dTotalNota: Double; iNumeroParcelas: Integer);
    function TotalParcelasLancadas(DataSetParcelas: TIBDataSet): Double;
  end;

implementation

{ TRateioDiferencaEntreParcelasReceber }

procedure TRateioDiferencaEntreParcelasReceber.RateiaDiferenca(DataSetNota: TIBDataSet;
  DataSetParcelas: TIBDataSet; ModuloAtual: String; dRetencaoIR: Double;
  dTotalNota: Double; iNumeroParcelas: Integer);
var
  dDiferenca: Currency; // Sandro Silva 2023-11-21 Double;
  //iRegistro,
  iDuplicatas: Integer;
  dSomaParcelas: Currency; // Sandro Silva 2023-11-20
  i: Integer;
  sRegistro: String;
begin
  // Quando altera o valor de uma parcela, a diferença é repassada para as demais com vencimento posterior daquela alterada
  if ModuloAtual = 'VENDA' then // Ok
  begin
    try

      DataSetParcelas.DisableControls;

      //iRegistro   := DataSetParcelas.Recno;//Guarda o registro que está posicionado
      sRegistro := DataSetParcelas.FieldByName('REGISTRO').AsString;

      AtualizaObjReceber(DataSetParcelas); // Carrega os dados do dataset para o objeto

      dDiferenca  := StrToFloat(FormatFloat('0.00', (dTotalNota - dRetencaoIR))); // Sandro Silva 2023-11-13 dDiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - FRetencaoIR);
      iDuplicatas := iNumeroParcelas;

      dSomaParcelas := GetValorTotalParcelas;// 0.00;

      // Identifica a diferença para ratear
      if dSomaParcelas <> StrToFloat(FormatFloat('0.00',(dTotalNota - dRetencaoIR))) then
      begin
        for i := 0 to Parcelas.Count -1 do
        begin
          if Parcelas.Items[i].REGISTRO <= sRegistro then // Sandro Silva 2023-11-23 if (i + 1) <= iRegistro then
          begin
            iDuplicatas := iDuplicatas - 1;
            dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - Parcelas.Items[i].VALOR_DUPL)); // Sandro Silva 2023-11-13 dDiferenca := dDiferenca - Form7.ibDataSet7VALOR_DUPL.Value;
          end else
          begin
            Parcelas.Items[i].VALOR_DUPL := StrToFloat(FormatFloat('0.00', dDiferenca / iDuplicatas));
          end;
        end;
      end;

      // valida se restou alguma diferença depois de ratear
      dDiferenca  := StrToFloat(FormatFloat('0.00', (dTotalNota - dRetencaoIR))); // Sandro Silva 2023-11-20 dDiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - FRetencaoIR);
      for i := 0 to Parcelas.Count -1 do
      begin
        dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - StrToFloat(FormatFloat('0.00', Parcelas.Items[i].VALOR_DUPL)))); // Sandro Silva 2023-11-20 dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
      end;

      // diferença identificada depois do rateio é repassada para a última parcela
      if dDiferenca <> 0 then
        Parcelas.Items[Parcelas.Count -1].VALOR_DUPL := StrToFloat(FormatFloat('0.00', Parcelas.Items[Parcelas.Count -1].VALOR_DUPL + dDiferenca)); // Sandro Silva 2023-11-20 Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat + dDiferenca]));

      // atualiza os dados do objeto devolta para o dataset
      AtualizaDataSetReceber(DataSetParcelas);

      DataSetParcelas.Locate('REGISTRO', sRegistro, []); // DataSetParcelas.Recno := iRegistro;//DataSetParcelas.Recno := iRecno;

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
