unit uParcelasReceber;

interface

uses
  Controls,
  Contnrs,
  SysUtils,
  IBCustomDataSet
  ;

type
  TParcelaReceber = class;
  TParcelaReceber = class(TObjectList)
  private
    FPERCENTUAL_MULTA: String;
    FVALOR_RECE: String;
    FVALOR_MULTA: String;
    FVALOR_JURO: String;
    FVALOR_DUPL: DOUBLE;
    FATIVO: Integer;
    FMOVIMENTO: String;
    FCODEBAR: String;
    FDOCUMENTO: String;
    FNOME: String;
    FCONTA: String;
    FNUMERONF: String;
    FBANDEIRA: String;
    FFORMADEPAGAMENTO: String;
    FPORTADOR: String;
    FNOSSONUM: String;
    FREGISTRO: String;
    FAUTORIZACAOTRANSACAO: String;
    FHISTORICO: String;
    FINSTITUICAOFINANCEIRA: String;
    FNN: String;
    FVENCIMENTO: TDATE;
    FEMISSAO: TDATE;
    FRECEBEIMENT: String;
  published
    property HISTORICO: String read FHISTORICO write FHISTORICO;
    property PORTADOR: String read FPORTADOR write FPORTADOR;
    property DOCUMENTO: String read FDOCUMENTO write FDOCUMENTO;
    property NOME: String read FNOME write FNOME;
    property EMISSAO: TDATE read FEMISSAO write FEMISSAO;
    property VENCIMENTO: TDATE read FVENCIMENTO write FVENCIMENTO;
    property VALOR_DUPL: DOUBLE read FVALOR_DUPL write FVALOR_DUPL;
    property RECEBIMENT: String read FRECEBEIMENT write FRECEBEIMENT;
    property VALOR_RECE: String read FVALOR_RECE write FVALOR_RECE;
    property VALOR_JURO: String read FVALOR_JURO write FVALOR_JURO;
    property ATIVO: Integer read FATIVO write FATIVO;
    property CONTA: String read FCONTA write FCONTA;
    property NOSSONUM: String read FNOSSONUM write FNOSSONUM;
    property CODEBAR: String read FCODEBAR write FCODEBAR;
    property NUMERONF: String read FNUMERONF write FNUMERONF;
    property REGISTRO: String read FREGISTRO write FREGISTRO;
    property NN: String read FNN write FNN;
    property MOVIMENTO: String read FMOVIMENTO write FMOVIMENTO;
    property INSTITUICAOFINANCEIRA: String read FINSTITUICAOFINANCEIRA write FINSTITUICAOFINANCEIRA;
    property FORMADEPAGAMENTO: String read FFORMADEPAGAMENTO write FFORMADEPAGAMENTO;
    property AUTORIZACAOTRANSACAO: String read FAUTORIZACAOTRANSACAO write FAUTORIZACAOTRANSACAO;
    property BANDEIRA: String read FBANDEIRA write FBANDEIRA;
    property VALOR_MULTA: String read FVALOR_MULTA write FVALOR_MULTA;
    property PERCENTUAL_MULTA: String read FPERCENTUAL_MULTA write FPERCENTUAL_MULTA;
  end;

  TParcelasReceberList = class(TObjectList)
    private
      procedure SetItem(Index: Integer; const Value: TParcelaReceber);
    public
      function GetItem(Index: Integer): TParcelaReceber;
      function Adiciona(DataSetParcelas: TIBDataSet): TParcelaReceber;
      property Items[Index: Integer]: TParcelaReceber read GetItem write SetItem;
  end;

  TParcelamentoReceber = class
  private
    FParcelas: TParcelasReceberList;
  protected
    procedure AtualizaObjReceber(DataSetParcelas: TIBDataSet);
    procedure AtualizaDataSetReceber(DataSetParcelas: TibDataSet);
    //procedure ReparcelaValor(iParcelas: Integer; dTotalParcelar: Double);
  public
    constructor Create; virtual;
    procedure LimpaItens;
    function GetValorTotalParcelas: Double;
    property Parcelas: TParcelasReceberList read FParcelas write FParcelas;
  end;

implementation

uses DB;

{ TParcelasReceberList }

function TParcelasReceberList.Adiciona(
  DataSetParcelas: TibDataSet): TParcelaReceber;
begin
  if (DataSetParcelas.FieldByName('VENCIMENTO').AsString = '') and (DataSetParcelas.FieldByName('VALOR_DUPL').AsFloat <= 0) then
    Exit;

  Result := TParcelaReceber.Create;

  Result.HISTORICO             := DataSetParcelas.FieldByName('HISTORICO').AsString;
  Result.PORTADOR              := DataSetParcelas.FieldByName('PORTADOR').AsString;
  Result.DOCUMENTO             := DataSetParcelas.FieldByName('DOCUMENTO').AsString;
  Result.NOME                  := DataSetParcelas.FieldByName('NOME').AsString;
  Result.EMISSAO               := DataSetParcelas.FieldByName('EMISSAO').AsDateTime;
  Result.VENCIMENTO            := DataSetParcelas.FieldByName('VENCIMENTO').AsDateTime;
  Result.VALOR_DUPL            := DataSetParcelas.FieldByName('VALOR_DUPL').AsFloat;
  Result.RECEBIMENT            := DataSetParcelas.FieldByName('RECEBIMENT').AsString;
  Result.VALOR_RECE            := DataSetParcelas.FieldByName('VALOR_RECE').AsString;
  Result.VALOR_JURO            := DataSetParcelas.FieldByName('VALOR_JURO').AsString;
  Result.ATIVO                 := DataSetParcelas.FieldByName('ATIVO').AsInteger;
  Result.CONTA                 := DataSetParcelas.FieldByName('CONTA').AsString;
  Result.NOSSONUM              := DataSetParcelas.FieldByName('NOSSONUM').AsString;
  Result.CODEBAR               := DataSetParcelas.FieldByName('CODEBAR').AsString;
  Result.NUMERONF              := DataSetParcelas.FieldByName('NUMERONF').AsString;
  Result.REGISTRO              := DataSetParcelas.FieldByName('REGISTRO').AsString;
  Result.NN                    := DataSetParcelas.FieldByName('NN').AsString;
  Result.MOVIMENTO             := DataSetParcelas.FieldByName('MOVIMENTO').AsString;
  Result.INSTITUICAOFINANCEIRA := DataSetParcelas.FieldByName('INSTITUICAOFINANCEIRA').AsString;
  Result.FORMADEPAGAMENTO      := DataSetParcelas.FieldByName('FORMADEPAGAMENTO').AsString;
  Result.AUTORIZACAOTRANSACAO  := DataSetParcelas.FieldByName('FORMADEPAGAMENTO').AsString;
  Result.BANDEIRA              := DataSetParcelas.FieldByName('BANDEIRA').AsString;
  Result.VALOR_MULTA           := DataSetParcelas.FieldByName('VALOR_MULTA').AsString;
  Result.PERCENTUAL_MULTA      := DataSetParcelas.FieldByName('PERCENTUAL_MULTA').AsString;

  Add(Result);  
end;

function TParcelasReceberList.GetItem(Index: Integer): TParcelaReceber;
begin
  Result := TParcelaReceber(inherited Items[Index]);  
end;

procedure TParcelasReceberList.SetItem(Index: Integer;
  const Value: TParcelaReceber);
begin
  Put(Index, Value);
end;

{ TParcelamentoReceber }

procedure TParcelamentoReceber.AtualizaDataSetReceber(
  DataSetParcelas: TibDataSet);
var
  i: integer;
  oItem: TParcelaReceber;
begin
  try
    DataSetParcelas.DisableControls;

    for i := 0 to FParcelas.Count -1 do
    begin
      oItem := FParcelas.GetItem(i);
      if DataSetParcelas.Locate('REGISTRO', oItem.REGISTRO, []) then
      begin
        DataSetParcelas.Edit;

        DataSetParcelas.FieldByName('HISTORICO').AsString             := oItem.HISTORICO;
        DataSetParcelas.FieldByName('PORTADOR').AsString              := oItem.PORTADOR;
        DataSetParcelas.FieldByName('DOCUMENTO').AsString             := oItem.DOCUMENTO;
        DataSetParcelas.FieldByName('NOME').AsString                  := oItem.NOME;
        DataSetParcelas.FieldByName('EMISSAO').AsDateTime             := oItem.EMISSAO;
        DataSetParcelas.FieldByName('VENCIMENTO').AsDateTime          := oItem.VENCIMENTO;
        DataSetParcelas.FieldByName('VALOR_DUPL').AsFloat             := oItem.VALOR_DUPL;
        DataSetParcelas.FieldByName('RECEBIMENT').AsString            := oItem.RECEBIMENT;
        DataSetParcelas.FieldByName('VALOR_RECE').AsString            := oItem.VALOR_RECE;
        DataSetParcelas.FieldByName('VALOR_JURO').AsString            := oItem.VALOR_JURO;
        DataSetParcelas.FieldByName('ATIVO').AsInteger                := oItem.ATIVO;
        DataSetParcelas.FieldByName('CONTA').AsString                 := oItem.CONTA;
        DataSetParcelas.FieldByName('NOSSONUM').AsString              := oItem.NOSSONUM;
        DataSetParcelas.FieldByName('CODEBAR').AsString               := oItem.CODEBAR;
        DataSetParcelas.FieldByName('NUMERONF').AsString              := oItem.NUMERONF;
        DataSetParcelas.FieldByName('REGISTRO').AsString              := oItem.REGISTRO;
        DataSetParcelas.FieldByName('NN').AsString                    := oItem.NN;
        DataSetParcelas.FieldByName('MOVIMENTO').AsString             := oItem.MOVIMENTO;
        DataSetParcelas.FieldByName('INSTITUICAOFINANCEIRA').AsString := oItem.INSTITUICAOFINANCEIRA;
        DataSetParcelas.FieldByName('FORMADEPAGAMENTO').AsString      := oItem.FORMADEPAGAMENTO;
        DataSetParcelas.FieldByName('FORMADEPAGAMENTO').AsString      := oItem.AUTORIZACAOTRANSACAO;
        DataSetParcelas.FieldByName('BANDEIRA').AsString              := oItem.BANDEIRA;
        DataSetParcelas.FieldByName('VALOR_MULTA').AsString           := oItem.VALOR_MULTA;
        DataSetParcelas.FieldByName('PERCENTUAL_MULTA').AsString      := oItem.PERCENTUAL_MULTA;
        DataSetParcelas.Post;
      end;
    end;
  finally
    DataSetParcelas.EnableControls;
  end
end;

procedure TParcelamentoReceber.AtualizaObjReceber(DataSetParcelas: TIBDataSet);
begin
  LimpaItens;

  try
    DataSetParcelas.DisableControls;
    DataSetParcelas.First;

    while not DataSetParcelas.Eof do
    begin
      FParcelas.Adiciona(DataSetParcelas);
      DataSetParcelas.Next;
    end;
  finally
    DataSetParcelas.EnableControls;
  end;

end;

constructor TParcelamentoReceber.Create;
begin
  FParcelas := TParcelasReceberList.Create;
end;

function TParcelamentoReceber.GetValorTotalParcelas: Double;
var
  Parcela: TParcelaReceber;
  i: Integer;
begin
  Result      := 0;

  Parcela := TParcelaReceber.Create;
  for i := 0 to FParcelas.Count -1 do
  begin
    Parcela := FParcelas.GetItem(i);
    Result := Result + Parcela.VALOR_DUPL;
  end;

end;

procedure TParcelamentoReceber.LimpaItens;
begin
  FreeAndNil(FParcelas);
  Parcelas := TParcelasReceberList.Create;
end;

(*
procedure TParcelamentoReceber.ReparcelaValor(iParcelas: Integer; dTotalParcelar: Double);
var
  dTotal: Double;
  aParcelas: array of Double;
  i: Integer;
begin
  // Quando o total da nota de venda é alterado, essa rotina irá reparcelar o novo valor com base no valor que cada parcela possui
  // Se lançar novos itens na nota, ou mudar o valor dos itens, o total da nota será alterado
  // Ex.:
  // Total antigo da nota: R$100,00
  // Parcela 1: R$75,00
  // Parcela 2: R$25,00
  //
  // Novo Total da nota: R$120,00
  // Parcela 1: R$90,00
  // Parcela 2: R$30,00


  //TotalizaParcelas
  dTotal := GetValorTotalParcelas;
  dTotalParcelar := StrToFloat(FormatFloat('0.00', dTotalParcelar)); // Sandro Silva 2023-11-20

  //Identifica a proporção de cada parcela no total
  SetLength(aParcelas, 0);
  for i := 0 to FParcelas.Count do
  begin
    SetLength(aParcelas, Length(aParcelas) + 1);
    aParcelas[High(aParcelas)] := StrToFloat(FormatFloat('0.00', FParcelas.Items[i].VALOR_DUPL)) / dTotal;
  end;

  //Reparcela o total da nota
  dTotal := 0.00;
  for i := 0 to FParcelas.Count do
  begin
    FParcelas.Items[i].VALOR_DUPL := StrToFloat(FormatFloat('0.00', dTotalParcelar * aParcelas[i]));
    dTotal := dTotal + StrToFloat(FormatFloat('0.00', FParcelas.Items[i].VALOR_DUPL));
  end;

  if dTotal <> dTotalParcelar then
  begin
    FParcelas.Items[FParcelas.Count -1].VALOR_DUPL := StrToFloat(FormatFloat('0.00', FParcelas.Items[FParcelas.Count -1].VALOR_DUPL + (dTotalParcelar - dTotal)));
  end;
end;
*)

end.
