unit ufrmOrigemCombustivel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient, StdCtrls, Buttons,
  IBCustomDataSet, IBQuery;

type
  TFrmOrigemCombustivel = class(TForm)
    CDSORIGEM: TClientDataSet;
    DSORIGEM: TDataSource;
    CDSORIGEMINDIMPORT: TIntegerField;
    CDSORIGEMUFORIGEM: TStringField;
    CDSORIGEMPORIGEM: TFloatField;
    btnOk: TBitBtn;
    lbLegenda: TLabel;
    IBQORIGEM: TIBQuery;
    lbProduto: TLabel;
    DBGridRastro: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure GridOrigemDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridOrigemExit(Sender: TObject);
    procedure GridOrigemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridOrigemKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure DBGridRastroDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGridRastroExit(Sender: TObject);
    procedure DBGridRastroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridRastroKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FUnidadeProduto: String;
    FCodigoProduto: String;
    FDescricaoProduto: String;
    procedure SetCodigoProduto(const Value: String);
    procedure BuscaOrigemNoXmlUltimoFornecedor;
  public
    { Public declarations }
    property CodigoProduto: String read FCodigoProduto write SetCodigoProduto;
    property DescricaoProduto: String read FDescricaoProduto write FDescricaoProduto;
    property UnidadeProduto: String read FUnidadeProduto write FUnidadeProduto;
    procedure LimpaInformacoes;

  end;

var
  FrmOrigemCombustivel: TFrmOrigemCombustivel;

implementation

uses Unit7, uFuncoesRetaguarda, smallfunc_xe, MSXML2_TLB, uDialogs;

{$R *.dfm}

procedure TFrmOrigemCombustivel.FormCreate(Sender: TObject);
begin
  CDSORIGEM.CreateDataSet;
end;

procedure TFrmOrigemCombustivel.GridOrigemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  R: TRect;
  yCalc, xCalc: integer;
  sTexto: String;
begin

  sTexto := Column.Field.AsString;
  xCalc  := Rect.Left + 2;

  (Sender As TDBGrid).Canvas.Font.Color := clBlack;

  (Sender as TDBGrid).Canvas.Font.Color := clWindowText;
  if gdSelected in State then
    (Sender as TDBGrid).Canvas.Font.Color := clWindowText;

  (Sender as TDBGrid).Canvas.Font.Style := [];

  if ((Sender as TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString <> '0') and ((Sender as TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString <> '1') then
  begin
    (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
    (Sender as TDBGrid).Canvas.Font.Color := clRed;

  end;

  if (Column.FieldName = 'UFORIGEM') then
  begin
    //if (Pos('1'+UpperCase(Column.Field.AsString)+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO2') = 0) then
    if UFCodigo(Column.Field.AsString) = '' then
    begin
      (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
      (Sender as TDBGrid).Canvas.Font.Color := clRed;
    end;
  end;

  if (Column.FieldName = 'PORIGEM') then
  begin
    if (Column.Field.AsFloat < 0) or (Column.Field.AsFloat > 100) then
    begin
      (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
      (Sender as TDBGrid).Canvas.Font.Color := clRed;
    end;
  end;

  { Cor de fundo para célula depende se está selecionada
  if gdSelected in State then
    (Sender As TDBGrid).Canvas.Brush.Color := clHighlight
  else
    (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;
  }
  R := Rect;

  { Preenche com a cor de fundo }
  (Sender As TDBGrid).Canvas.FillRect(Rect);

  { Calcula posição para centralizar o sTexto na vertical }
  yCalc := (Sender As TDBGrid).Canvas.TextHeight(sTexto);
  yCalc := (R.Top + (R.Bottom - R.Top - yCalc) div 2);// + 2;

  (Sender As TDBGrid).Canvas.TextRect(R, xCalc, yCalc, sTexto);

  DBGridDrawColumnCell(Sender, R, DataCol, Column, State);
end;

procedure TFrmOrigemCombustivel.GridOrigemExit(Sender: TObject);
begin
  // Limpar a linhas sem informações
  TDBGrid(Sender).DataSource.DataSet.DisableControls;
  try
    TDBGrid(Sender).DataSource.DataSet.First;
    while TDBGrid(Sender).DataSource.DataSet.Eof = False do
    begin

      if (TDBGrid(Sender).DataSource.DataSet.FieldByName('INDIMPORT').AsString = '')
        and (TDBGrid(Sender).DataSource.DataSet.FieldByName('UFORIGEM').AsString = '')
        and (TDBGrid(Sender).DataSource.DataSet.FieldByName('PORIGEM').AsString = '')
      then
        TDBGrid(Sender).DataSource.DataSet.Delete
      else
        TDBGrid(Sender).DataSource.DataSet.Next;

    end;
  finally
    TDBGrid(Sender).DataSource.DataSet.EnableControls;
  end;

end;

procedure TFrmOrigemCombustivel.GridOrigemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if TDBGrid(Sender).DataSource.DataSet.RecordCount > 0 then
      TDBGrid(Sender).DataSource.DataSet.Delete;
  end;

  if (Key = VK_RETURN) then
  begin

    // Avança cada coluna com Enter e quando chega na última cria linha nova
    //if (Sender As TDBGrid).DataSource.DataSet.State in [dsBrowse] then
    begin
      if (Sender As TDBGrid).SelectedIndex = (Sender As TDBGrid).Columns.Count -1 then
      begin

        if (Sender As TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString = '' then
        begin
          if (Sender As TDBGrid).DataSource.DataSet.State in [dsInsert, dsEdit] then
            (Sender As TDBGrid).DataSource.DataSet.Post;

          btnOk.SetFocus;
        end
        else
        begin
          (Sender As TDBGrid).DataSource.DataSet.Append;
          (Sender As TDBGrid).SelectedIndex := 0;
        end;
      end
      else
        (Sender As TDBGrid).SelectedIndex := (Sender As TDBGrid).SelectedIndex + 1;
    end;
  end;

end;

procedure TFrmOrigemCombustivel.GridOrigemKeyPress(Sender: TObject; var Key: Char);
begin
  if (Sender As TDBGrid).SelectedField.DataType = ftFloat then
  begin
    if Key = Chr(46) then
      Key := Chr(44);
  end;
end;

procedure TFrmOrigemCombustivel.LimpaInformacoes;
begin
  CDSORIGEM.EmptyDataSet;
end;

procedure TFrmOrigemCombustivel.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmOrigemCombustivel.BuscaOrigemNoXmlUltimoFornecedor;
var
  XMLDOM: IXMLDOMDocument;
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
begin
  if FCodigoProduto = '' then
  begin
    MensagemSistema('Informe o código do produto');
    Exit;
  end;

//  CDSORIGEM.Filter := 'CODIGO = ' + QuotedStr(sCodigoProduto);
//  CDSORIGEM.Filtered := True;

  IBQORIGEM.Close;
  IBQORIGEM.SQL.Text :=
    'select first 1 C.NFEXML ' +
    'from ITENS002 I ' +
    'join COMPRAS C on C.NUMERONF = I.NUMERONF and C.FORNECEDOR = I.FORNECEDOR ' +
    'where I.CODIGO = :CODIGO ' +
    'order by C.EMISSAO desc';
  IBQORIGEM.ParamByName('CODIGO').AsString := FCodigoProduto;
  IBQORIGEM.Open;

  XMLDOM := CoDOMDocument.Create; // Tem que criar como CoDOMDocument, CoDOMDocument50 não funcionou 100%
  XMLDOM.loadXML(IBQORIGEM.FieldByName('NFEXML').AsString);
  xNodes := XMLDOM.selectNodes('//comb/origComb');
  for iNode := 0 to xNodes.length -1 do
  begin
    if xmlNodeValue(xNodes.item[iNode].xml, '//indImport') <> '' then
    begin
      CDSORIGEM.Append;
      CDSORIGEM.FieldByName('INDIMPORT').AsString := xmlNodeValue(xNodes.item[iNode].xml, '//indImport');
      CDSORIGEM.FieldByName('UFORIGEM').AsString  := UFSigla(xmlNodeValue(xNodes.item[iNode].xml, '//cUFOrig'));
      CDSORIGEM.FieldByName('PORIGEM').AsFloat    := xmlNodeValueToFloat(xNodes.item[iNode].xml, '//pOrig');
      CDSORIGEM.Post;
    end;
  end;
  XMLDOM := nil;
  xNodes := nil; // Sandro Silva 2019-06-19

end;

procedure TFrmOrigemCombustivel.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  bIncompleto: Boolean;
begin
  CDSORIGEM.First;
  bIncompleto := False;
  while CDSORIGEM.Eof = False do
  begin
    if (CDSORIGEM.FieldByName('INDIMPORT').AsString <> '0') and (CDSORIGEM.FieldByName('INDIMPORT').AsString <> '1') then
    begin
      bIncompleto := True;
      MensagemSistema('Informe a origem do combustível' + #13 + #13 +
                      '0-Nacional' + #13 +
                      '1-Importado');
      Break;
    end;

    if UFCodigo(CDSORIGEM.FieldByName('UFORIGEM').AsString) = '' then
    begin
      bIncompleto := True;
      MensagemSistema('Informe a sigla da UF de origem do combustível');
      Break;
    end;

    if (CDSORIGEM.FieldByName('PORIGEM').AsFloat < 0) or (CDSORIGEM.FieldByName('PORIGEM').AsFloat > 100) then
    begin
      bIncompleto := True;
      MensagemSistema('Informe o percentual originário da UF' + #13 + #13 +
                      'Percentual entre 0 e 100');
      Break;
    end;

    CDSORIGEM.Next;
  end;
  if bIncompleto then
    Abort;
end;

procedure TFrmOrigemCombustivel.FormActivate(Sender: TObject);
begin
  lbProduto.Caption := '' + FCodigoProduto + ' - ' + FDescricaoProduto + ' - ' + FUnidadeProduto;
end;

procedure TFrmOrigemCombustivel.DBGridRastroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  R: TRect;
  yCalc, xCalc: integer;
  sTexto: String;
begin

  sTexto := Column.Field.AsString;
  xCalc  := Rect.Left + 2;

  (Sender As TDBGrid).Canvas.Font.Color := clBlack;

  (Sender as TDBGrid).Canvas.Font.Color := clWindowText;
  if gdSelected in State then
    (Sender as TDBGrid).Canvas.Font.Color := clWindowText;

  (Sender as TDBGrid).Canvas.Font.Style := [];

  if ((Sender as TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString <> '0') and ((Sender as TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString <> '1') then
  begin
    (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
    (Sender as TDBGrid).Canvas.Font.Color := clRed;

  end;

  if (Column.FieldName = 'UFORIGEM') then
  begin
    if UFCodigo(Column.Field.AsString) = '' then
    begin
      (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
      (Sender as TDBGrid).Canvas.Font.Color := clRed;
    end;
  end;

  if (Column.FieldName = 'PORIGEM') then
  begin
    if (Column.Field.AsFloat < 0) or (Column.Field.AsFloat > 100) then
    begin
      (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
      (Sender as TDBGrid).Canvas.Font.Color := clRed;
    end;
  end;

  { Cor de fundo para célula depende se está selecionada
  if gdSelected in State then
    (Sender As TDBGrid).Canvas.Brush.Color := clHighlight
  else
    (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;
  }
  R := Rect;

  { Preenche com a cor de fundo }
  (Sender As TDBGrid).Canvas.FillRect(Rect);

  { Calcula posição para centralizar o sTexto na vertical }
  yCalc := (Sender As TDBGrid).Canvas.TextHeight(sTexto);
  yCalc := (R.Top + (R.Bottom - R.Top - yCalc) div 2);// + 2;

  (Sender As TDBGrid).Canvas.TextRect(R, xCalc, yCalc, sTexto);

  DBGridDrawColumnCell(Sender, R, DataCol, Column, State);

end;

procedure TFrmOrigemCombustivel.DBGridRastroExit(Sender: TObject);
begin
  // Limpar a linhas sem informações
  TDBGrid(Sender).DataSource.DataSet.DisableControls;
  try
    TDBGrid(Sender).DataSource.DataSet.First;
    while TDBGrid(Sender).DataSource.DataSet.Eof = False do
    begin

      if (TDBGrid(Sender).DataSource.DataSet.FieldByName('INDIMPORT').AsString = '')
        and (TDBGrid(Sender).DataSource.DataSet.FieldByName('UFORIGEM').AsString = '')
        and (TDBGrid(Sender).DataSource.DataSet.FieldByName('PORIGEM').AsString = '')
      then
        TDBGrid(Sender).DataSource.DataSet.Delete
      else
        TDBGrid(Sender).DataSource.DataSet.Next;

    end;
  finally
    TDBGrid(Sender).DataSource.DataSet.EnableControls;
  end;

end;

procedure TFrmOrigemCombustivel.DBGridRastroKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    if TDBGrid(Sender).DataSource.DataSet.RecordCount > 0 then
      TDBGrid(Sender).DataSource.DataSet.Delete;
  end;

  if (Key = VK_RETURN) then
  begin

    // Avança cada coluna com Enter e quando chega na última cria linha nova
    //if (Sender As TDBGrid).DataSource.DataSet.State in [dsBrowse] then
    begin
      if (Sender As TDBGrid).SelectedIndex = (Sender As TDBGrid).Columns.Count -1 then
      begin

        if (Sender As TDBGrid).DataSource.DataSet.FieldByName('INDIMPORT').AsString = '' then
        begin
          if (Sender As TDBGrid).DataSource.DataSet.State in [dsInsert, dsEdit] then
            (Sender As TDBGrid).DataSource.DataSet.Post;

          btnOk.SetFocus;
        end
        else
        begin
          (Sender As TDBGrid).DataSource.DataSet.Append;
          (Sender As TDBGrid).SelectedIndex := 0;
        end;
      end
      else
        (Sender As TDBGrid).SelectedIndex := (Sender As TDBGrid).SelectedIndex + 1;
    end;
  end;

end;

procedure TFrmOrigemCombustivel.DBGridRastroKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Sender As TDBGrid).SelectedField.DataType = ftFloat then
  begin
    if Key = Chr(46) then
      Key := Chr(44);
  end;
  if (Sender As TDBGrid).SelectedField.FieldName = 'UFORIGEM' then
    Key := UpCase(Key)
end;

procedure TFrmOrigemCombustivel.SetCodigoProduto(const Value: String);
begin
  FCodigoProduto := Value;
  BuscaOrigemNoXmlUltimoFornecedor;  
end;

end.
