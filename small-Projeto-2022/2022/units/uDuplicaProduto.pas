unit uDuplicaProduto;

interface

uses
  uIDuplicaProduto, DB, IBDatabase, IBQuery, uConectaBancoSmall, Forms, Windows;

type
  TDuplicaProduto = class(TInterfacedObject, IDuplicaProduto)
  private
    FcCodigoProdNew: String;
    FcCodigoProd: String;
    FoTransaction: TIBTransaction;
    FoDataSetEstoque: TDataSet;
    FoDataSetComposicao: TDataSet;
    function RetornarDadosProduto: TIBQuery;
    procedure DuplicaTabelaEstoque;
    function RetornaNroRegistro(AcGenerator: String; AnQtdeCarac: Integer): String;
    procedure DuplicaTabelaComposto;
    function RetornarDadosComposto: TIBQuery;
    function TestarCampoIgnorarTabEstoque(AcCampo: String): Boolean;
  public
    class function New: IDuplicaProduto;
    function SetTransaction(AoTransaction: TIBTransaction): IDuplicaProduto;
    function SetDataSetEstoque(AoDataSet: TDataSet): IDuplicaProduto;
    function SetDataSetComposicao(AoDataSet: TDataSet): IDuplicaProduto;
    function SetCodigoProduto(AcCodigoProd: String): IDuplicaProduto;
    function Duplicar: Boolean;
  end;

implementation

uses SysUtils, SmallFunc, uSmallResourceString, uDialogs;

{ TDuplicaProduto }

function TDuplicaProduto.Duplicar: Boolean;
begin
  Result := False;
  try
    DuplicaTabelaEstoque;
    DuplicaTabelaComposto;

    Result := True;
  except
    on e: exception do
      //Application.MessageBox(Pchar('Não foi possível duplicar o produto.' + SLineBreak + e.Message), PChar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);  Mauricio Parizotto 2023-10-25
      MensagemSistema('Não foi possível duplicar o produto.' + SLineBreak + e.Message,msgAtencao);
  end;
end;

procedure TDuplicaProduto.DuplicaTabelaComposto;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDadosComposto;
  try
    while not qryDados.Eof do
    begin
      FoDataSetComposicao.Append;

      FoDataSetComposicao.FieldByName('CODIGO').AsString := FcCodigoProdNew;
      FoDataSetComposicao.FieldByName('REGISTRO').AsString := RetornaNroRegistro('G_COMPOSTO', 10);

      for i := 0 to Pred(qryDados.FieldCount) do
      begin
        if Assigned(FoDataSetComposicao.FindField(qryDados.Fields[i].FieldName)) then
        begin
          if (qryDados.Fields[i].FieldName = 'CODIGO') or (qryDados.Fields[i].FieldName = 'REGISTRO') then
            Continue;
          FoDataSetComposicao.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
        end;
      end;

      FoDataSetComposicao.Post;
      
      qryDados.Next;
    end;
  finally
    FreeAndNil(qryDados);
  end;
end;

procedure TDuplicaProduto.DuplicaTabelaEstoque;
var
  i: Integer;
  qryDados: TIBQuery;
begin
  qryDados := RetornarDadosProduto;
  try
    while not qryDados.Eof do
    begin
      FoDataSetEstoque.Append;
      // CÓDIGO E REGISTRO GERA SOZINHO
      FoDataSetEstoque.FieldByName('ATIVO').AsString        := '0';
      FoDataSetEstoque.FieldByName('DAT_INICIO').AsDateTime := Date;
      FcCodigoProdNew := FoDataSetEstoque.FieldByName('CODIGO').AsString;
      for i := 0 to Pred(qryDados.FieldCount) do
      begin
        if Assigned(FoDataSetEstoque.FindField(qryDados.Fields[i].FieldName)) then
        begin
          if TestarCampoIgnorarTabEstoque(qryDados.Fields[i].FieldName) then
            Continue;

          if qryDados.Fields[i].FieldName = 'DESCRICAO' then
            FoDataSetEstoque.FieldByName('DESCRICAO').AsString := Copy(qryDados.FieldByName('DESCRICAO').AsString, 1, 39)
                                                                  + ' ' + FcCodigoProdNew
          else
            FoDataSetEstoque.FindField(qryDados.Fields[i].FieldName).Value := qryDados.Fields[i].Value;
        end;
      end;

      FoDataSetEstoque.Post;

      qryDados.Next;
    end;
  finally
    FreeAndNil(qryDados);
  end;
end;

class function TDuplicaProduto.New: IDuplicaProduto;
begin
  Result := Self.Create;
end;

function TDuplicaProduto.RetornarDadosProduto: TIBQuery;
begin
  Result := CriaIBQuery(FoTransaction);

  Result.Close;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT *');
  Result.SQL.Add('FROM ESTOQUE');
  Result.SQL.Add('WHERE (CODIGO=:XCOD)');
  Result.ParamByName('XCOD').AsString := FcCodigoProd;
  Result.Open;

  Result.First;
end;

function TDuplicaProduto.RetornarDadosComposto: TIBQuery;
begin
  Result := CriaIBQuery(FoTransaction);

  Result.Close;
  Result.SQL.Clear;
  Result.SQL.Add('SELECT *');
  Result.SQL.Add('FROM COMPOSTO');
  Result.SQL.Add('WHERE (CODIGO=:XCOD)');
  Result.ParamByName('XCOD').AsString := FcCodigoProd;
  Result.Open;

  Result.First;
end;

function TDuplicaProduto.SetCodigoProduto(AcCodigoProd: String): IDuplicaProduto;
begin
  Result := Self;

  FcCodigoProd := AcCodigoProd;
end;

function TDuplicaProduto.SetDataSetEstoque(AoDataSet: TDataSet): IDuplicaProduto;
begin
  Result := Self;

  FoDataSetEstoque := AoDataSet;
end;

function TDuplicaProduto.SetTransaction(AoTransaction: TIBTransaction): IDuplicaProduto;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

function TDuplicaProduto.RetornaNroRegistro(AcGenerator: String; AnQtdeCarac: Integer): String;
var
  QryGen: TIBQuery;
begin
  QryGen := CriaIBQuery(FoTransaction);
  try
    QryGen.Close;
    QryGen.SQL.Clear;
    QryGen.SQL.Add('select gen_id('+AcGenerator+',1) from rdb$database');
    QryGen.Open;

    Result := StrZero(StrToInt(QryGen.FieldByname('GEN_ID').AsString),AnQtdeCarac,0);
  finally
    FreeAndNil(QryGen);
  end;
end;

function TDuplicaProduto.SetDataSetComposicao(
  AoDataSet: TDataSet): IDuplicaProduto;
begin
  Result := Self;

  FoDataSetComposicao := AoDataSet;
end;

function TDuplicaProduto.TestarCampoIgnorarTabEstoque(AcCampo: String): Boolean;
const
  _cCampos = ';CODIGO;DAT_INICIO;CUSTOCOMPR;CUSTOMEDIO;QTD_COMPRA;QTD_ATUAL' +
             ';QTD_INICIO;QTD_VEND;CUS_VEND;VAL_VEND;LUC_VEND;FOTO;REFERENCIA;ONPROMO' +
             ';OFFPROMO;IIA;VALOR_PARCELA_IMPORTADA_EXTERIO;FATORC;IIA_UF;IIA_MUNI' +
             ';QTD_PRO1;QTD_PRO2;DESCONT1;DESCONT2;DAT_INICIO;ULT_COMPRA;ULT_VENDA' +
             ';REGISTRO;PROMOINI;PROMOFIM;IDENTIFICADORPLANOCONTAS;ATIVO;ALTERADO' +
             ';SERIE;ENCRYPTHASH;CODIGO_FCI;FORNECEDOR;CODIGO;MEDIDAE;MARKETPLACE;';
begin
  Result := (Pos(';'+AcCampo+';', _cCampos) > 0);
end;

end.
