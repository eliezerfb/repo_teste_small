unit uEditaMovimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  Grids, DBGrids, DB, IBCustomDataSet, IBQuery
  , StrUtils
  , ufuncoesfrente
  ;

type
  TFEditaMovimento = class(TForm)
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    BitBtn1: TBitBtn;
    DBGridItens: TDBGrid;
    DataSource1: TDataSource;
    lbTotal: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure DBGridItensColEnter(Sender: TObject);
    procedure DBGridItensKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    FCaixa: String;
    FPedido: String;
    function TotalizaMovimento(DataSet: TDataSet): Double;
  public
    { Public declarations }
    property Pedido: String read FPedido write FPedido;
    property Caixa: String read FCaixa write FCaixa;
  end;

var
  FEditaMovimento: TFEditaMovimento;

implementation

uses
  fiscal
  , SmallFunc
  , uajustaresolucao
  ;

{$R *.dfm}

procedure TFEditaMovimento.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFEditaMovimento.FormActivate(Sender: TObject);
begin

  FEditaMovimento.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  FEditaMovimento.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;

  FEditaMovimento.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  FEditaMovimento.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;

  FEditaMovimento.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  FEditaMovimento.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;

  ActiveControl := DBGridItens; // Sandro Silva 2018-10-24

end;

procedure TFEditaMovimento.FormCreate(Sender: TObject);
begin
  // Artifício para o botão OK nunca ficar com foco quando o form for aberto. Evitar confirmação OK quando ler código de barras Sandro Silva 2018-10-24
  BitBtn1.Top := -10000;
  Form1.bEditandoMovimento := True;

  FEditaMovimento.Top    := Form1.Panel1.Top;
  FEditaMovimento.Left   := Form1.Panel1.Left;
  FEditaMovimento.Height := Form1.Panel1.Height;
  FEditaMovimento.Width  := Form1.Panel1.Width;

  AjustaResolucao(FEditaMovimento);
  AjustaResolucao(FEditaMovimento.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18

end;

procedure TFEditaMovimento.DBGridItensDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  yCalc, xCalc: integer;
  sTexto: String;
begin

  (Sender As TDBGrid).Canvas.Font.Size  := Form1.LabelESC2.Font.Size;
  (Sender As TDBGrid).Canvas.Font.Name  := Form1.LabelESC2.Font.Name;

  if Column.Field <> nil then
  begin
    sTexto := Column.Field.AsString;
    xCalc  := Rect.Left + 2;

    (Sender As TDBGrid).Canvas.Font.Color := clBlack;

    if Column.Field.AsString <> '' then
    begin

      if gdSelected in State then // Se a coluna estiver selecionada deixa a fonte branca para ter contraste
        (Sender As TDBGrid).Canvas.Font.Color := clWhite;

      if (Column.Field.DataType in [ftFloat, ftBCD, ftFMTBcd]) then
      begin
        sTexto := FormatFloat('0.00', Column.Field.AsFloat);

        xCalc := Rect.Right - (Sender As TDBGrid).Canvas.TextWidth(sTexto) - 2; // Alinha a direita
      end;

      if (Column.Field.FieldName = 'ITEM') then
        sTexto := RightStr(Column.Field.AsString, 3);
    end;

    

    // Cor de fundo para célula depende se está selecionada
    if gdSelected in State then
    begin

      (Sender As TDBGrid).Canvas.Brush.Color := clHighlight

    end
    else
    begin
    
      (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;

      if (Column.Field.FieldName <> 'UNITARIO') and (Column.Field.FieldName <> 'QUANTIDADE') then
      begin
        (Sender As TDBGrid).Canvas.Brush.Color := clBtnFace;
      end;

    end;        

    // Preenche com a cor de fundo
    (Sender As TDBGrid).Canvas.FillRect(Rect);

    // Calcula posição para centralizar o sTexto na vertical
    yCalc := (Sender As TDBGrid).Canvas.TextHeight(sTexto);
    yCalc := (Rect.Top + (Rect.Bottom - Rect.Top - yCalc) div 2);// + 2;

    (Sender As TDBGrid).Canvas.TextRect(Rect, xCalc, yCalc, sTexto);

  end; //if Column.Field <> nil then

end;

procedure TFEditaMovimento.FormShow(Sender: TObject);
var
  iCol: Integer;
begin

  for iCol := 0 to DBGridItens.Columns.Count - 1 do
  begin
    DBGridItens.Columns[iCol].Title.Font.Size := DBGridItens.Font.Size;
  end;     

  Form1.ibDataSet27.Close;
  Form1.ibDataSet27.SelectSQL.Text :=
    'select * ' +
    'from ALTERACA ' +
    'where PEDIDO = :PEDIDO ' +
    ' and CAIXA = :CAIXA ' +
    ' and TIPO <> ''CANCEL'' ' +
    ' and TIPO <> ''KOLNAC'' ' + // Sandro Silva 2019-03-26 Quando em Dead Lock, regsitro fica com TIPO=KOLNAC. Altera para "CANCEL" quando estiver destravado
    ' and DESCRICAO <> ''Acréscimo'' ' +
    ' and DESCRICAO <> ''Desconto'' ' +
    ' and DESCRICAO <> ''<CANCELADO>'' ' +
    ' and coalesce(VENDEDOR, '''') <> ''<cancelado>'' ';
  Form1.ibDataSet27.ParamByName('PEDIDO').AsString := FPedido;
  Form1.ibDataSet27.ParamByName('CAIXA').AsString  := FCaixa;
  Form1.ibDataSet27.Open;

  AjustaLarguraDBGrid(DBGridItens);

  TotalizaMovimento(Form1.ibDataSet27);

end;

function TFEditaMovimento.TotalizaMovimento(DataSet: TDataSet): Double;
var
  sItem: String;
begin
  DataSet.DisableControls;
  try
    sItem := DataSet.FieldByName('ITEM').AsString;
    while DataSet.Eof = False do
    begin
      if (DataSet.FieldByName('UNITARIO').AsFloat * DataSet.FieldByName('QUANTIDADE').AsFloat) <> DataSet.FieldByName('TOTAL').AsFloat then
      begin
        DataSet.Edit;
        DataSet.FieldByName('TOTAL').AsFloat := StrToFloat(FormatFloat('0.00', DataSet.FieldByName('UNITARIO').AsFloat * DataSet.FieldByName('QUANTIDADE').AsFloat));
        DataSet.Post;
      end;
      DataSet.Next;
    end;
    DataSet.Locate('ITEM', sItem, []);
  finally
    DataSet.EnableControls;
  end;

  Form1.fTotal    := 9999999.99; // Jeito de forçar a totalização :(
  Result := Form1.PDV_SubTotal(True);
  lbTotal.Caption := 'Total:R$ ' + FormatFloat('0.00', Result);
end;

procedure TFEditaMovimento.DBGridItensColEnter(Sender: TObject);
begin
  DBGridItens.ReadOnly := False;
  if (DBGridItens.SelectedField.FieldName <> 'QUANTIDADE') and (DBGridItens.SelectedField.FieldName <> 'UNITARIO') then
    DBGridItens.ReadOnly := True;
end;

procedure TFEditaMovimento.DBGridItensKeyPress(Sender: TObject;
  var Key: Char);
begin
  if TDBGrid(Sender).SelectedField.DataType = ftFloat then
  begin
    if Key = Chr(46) then
      Key := Chr(44);
  end;
end;

procedure TFEditaMovimento.DBGridItensKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [SsCtrl]) and (Key = 46) then
    Key := 0;

  if Key in [VK_TAB, VK_ESCAPE] then
    Key := VK_RETURN;
    
  try

    if Key = VK_RETURN then
    begin

      if (TDBGrid(Sender).SelectedIndex + 1) >= TDBGrid(Sender).Columns.Count then
      begin

        TDBGrid(Sender).SelectedIndex := 0;
        TDBGrid(Sender).DataSource.DataSet.Next;

      end
      else
        TDBGrid(Sender).SelectedIndex := TDBGrid(Sender).SelectedIndex + 1;
      
    end;

  except
  end;
  
end;

procedure TFEditaMovimento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Form1.bEditandoMovimento := False;
end;

procedure TFEditaMovimento.DataSource1DataChange(Sender: TObject;
  Field: TField);
var
  dTotalItem: Double;
begin
  // Atualizando o total do item se alterado quantidade ou valor unitário 
  if Field = nil then
    Exit;

  if Field.DataSet.Active = False then
    Exit;

  if (Field.FieldName = 'QUANTIDADE')
    or (Field.FieldName = 'UNITARIO')
  then
  begin
    if ((TemGrade(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString) = False)
      and (TemSerie(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString) = False)
      and (TemComposicao(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString) = False)
      and (Field.FieldName = 'QUANTIDADE'))
      or (Field.FieldName = 'UNITARIO')
    then
    begin

      dTotalItem := StrToFloat(FormatFloat('0.00', Field.DataSet.FieldByName('UNITARIO').AsFloat * Field.DataSet.FieldByName('QUANTIDADE').AsFloat));

      if Field.DataSet.FieldByName('TOTAL').AsFloat <> dTotalItem then
      begin
        if Field.DataSet.State <> dsEdit then
          Field.DataSet.Edit;

        Field.DataSet.FieldByName('TOTAL').AsFloat := dTotalItem;
        TotalizaMovimento(Field.DataSet);
      end;
    end;
  end;
end;

end.
