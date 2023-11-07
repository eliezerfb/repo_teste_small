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
    BitBtn2: TBitBtn;
    DBGridItens: TDBGrid;
    DataSource1: TDataSource;
    lbTotal: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGridItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCaixa: String;
    FPedido: String;
    function TotalizaMovimento(DataSet: TIBDataSet): Double;
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

  FEditaMovimento.Top    := Form1.Panel1.Top;
  FEditaMovimento.Left   := Form1.Panel1.Left;
  FEditaMovimento.Height := Form1.Panel1.Height;
  FEditaMovimento.Width  := Form1.Panel1.Width;

  AjustaResolucao(FEditaMovimento);
  AjustaResolucao(FEditaMovimento.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18

end;

procedure TFEditaMovimento.BitBtn2Click(Sender: TObject);
begin
  Close;
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

    end;

    // Cor de fundo para célula depende se está selecionada
    if gdSelected in State then
      (Sender As TDBGrid).Canvas.Brush.Color := clHighlight
    else
      (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;

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

function TFEditaMovimento.TotalizaMovimento(DataSet: TIBDataSet): Double;
var
  sItem: String;
begin
  Result := 0.00;
  sItem := DataSet.FieldByName('ITEM').AsString;
  while DataSet.Eof = False do
  begin
    Result := DataSet.FieldByName('TOTAL').AsFloat;
    DataSet.Next;
  end;

  lbTotal.Caption := 'Total: ' + FormatFloat('0.00', Result);
end;

end.
