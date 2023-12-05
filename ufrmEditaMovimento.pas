unit ufrmEditaMovimento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  Grids, DBGrids, DB, IBCustomDataSet, IBQuery
  , StrUtils
  , ufuncoesfrente, DBClient
  ;

type
  TFEditaMovimento = class(TForm)
    btnOk: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    BitBtn1: TBitBtn;
    DBGridItens: TDBGrid;
    DataSource1: TDataSource;
    lbTotal: TLabel;
    CDSALTERACA: TClientDataSet;
    lbAlerta: TLabel;
    procedure btnOkClick(Sender: TObject);
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
    procedure DBGridItensKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FIBDATASETALTERACAAfterScroll(DataSet: TDataSet);
    procedure DBGridItensCellClick(Column: TColumn);
  private
    { Private declarations }
    FoMessageEvent: TMessageEvent;
    FCaixa: String;
    FPedido: String;
    FSelectOld: String;
    FIBDATASETALTERACA: TIBDataSet;
    FEditFormatUnitario: String;
    FEditFormatQuantidade: String;
    function TotalizaMovimento(DataSet: TDataSet): Double;
    function ItemCancelado(Field: TField): Boolean;
    function NaoEditavel(Field: TField): Boolean;
    procedure ScrollMouse(var Msg: TMsg; var Handled: Boolean);
    procedure AlertaDeProdutoNaoEditavel;
  public
    { Public declarations }
    property Pedido: String read FPedido write FPedido;
    property Caixa: String read FCaixa write FCaixa;
    function SelectSqlAlteracaEdicao: String;
    function SelecionaItens: Boolean;
  end;

var
  FEditaMovimento: TFEditaMovimento;

implementation

uses
  fiscal
  , SmallFunc
  , uajustaresolucao
  , Types;

{$R *.dfm}

procedure TFEditaMovimento.btnOkClick(Sender: TObject);
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

  FIBDATASETALTERACA := TIBDataSet.Create(nil);
  FIBDATASETALTERACA.AfterScroll := FIBDATASETALTERACAAfterScroll;

  FoMessageEvent := Application.OnMessage;

  Application.OnMessage := ScrollMouse;

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
        if Column.FieldName = 'QUANTIDADE' then
          sTexto := FormatFloat('#,##0.' + DupeString('0', StrToIntDef(Form1.ConfCasas, 2)), Column.Field.AsFloat);
        if Column.FieldName = 'UNITARIO' then
          sTexto := FormatFloat('#,##0.' + DupeString('0', StrToIntDef(Form1.ConfPreco, 2)), Column.Field.AsFloat);

        xCalc := Rect.Right - (Sender As TDBGrid).Canvas.TextWidth(sTexto) - 2; // Alinha a direita
      end;

      if (Column.Field.FieldName = 'ITEM') then
        sTexto := RightStr(Column.Field.AsString, 3);
    end;

    if ItemCancelado(Column.Field) then
    begin
      (Sender As TDBGrid).Canvas.Font.Style  := [fsStrikeOut, fsBold];
    end;

    // Cor de fundo para célula depende se está selecionada
    if gdSelected in State then
    begin
      (Sender As TDBGrid).Canvas.Brush.Color := clHighlight;

      if ItemCancelado(Column.Field) then
      begin
        (Sender As TDBGrid).Canvas.Font.Style  := [fsStrikeOut];
      end;

    end
    else
    begin

      (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;

      if ((Column.Field.FieldName <> 'UNITARIO') and (Column.Field.FieldName <> 'QUANTIDADE'))
        or (ItemCancelado(Column.Field) or (Column.Field.DataSet.FieldByName('DESCRICAO').AsString = 'Desconto') or (Column.Field.DataSet.FieldByName('DESCRICAO').AsString = 'Acréscimo'))
      then
      begin
        (Sender As TDBGrid).Canvas.Brush.Color := clBtnFace;
      end;

    end;

    // Preenche com a cor de fundo
    (Sender As TDBGrid).Canvas.FillRect(Rect);

    // Calcula posição para centralizar o sTexto na vertical
    yCalc := (Sender As TDBGrid).Canvas.TextHeight(sTexto);
    yCalc := (Rect.Top + (Rect.Bottom - Rect.Top - yCalc) div 2);// + 2;

    // Centraliza o texto da coluna item
    if (Column.Field.FieldName = 'ITEM') then
    begin
      xCalc := (Sender As TDBGrid).Canvas.TextWidth(sTexto);
      xCalc := (Rect.Left + (Rect.Right - Rect.Left - xCalc) div 2);// + 2;
    end;                                                         

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

  {Sandro Silva 2023-11-28 inicio
  FSelectOld := Form1.ibDataSet27.SelectSQL.Text;

  FEditFormatUnitario   := TFloatField(Form1.ibDataSet27.FieldByName('UNITARIO')).EditFormat; // Sandro Silva 2023-11-23
  FEditFormatQuantidade := TFloatField(Form1.ibDataSet27.FieldByName('QUANTIDADE')).EditFormat; // Sandro Silva 2023-11-23
  TFloatField(Form1.ibDataSet27.FieldByName('UNITARIO')).EditFormat   := '#,##0.' + DupeString('0', StrToIntDef(Form1.ConfPreco, 2)); // Sandro Silva 2023-11-23
  TFloatField(Form1.ibDataSet27.FieldByName('QUANTIDADE')).EditFormat := '#,##0.' + DupeString('0', StrToIntDef(Form1.ConfCasas, 2)); // Sandro Silva 2023-11-23

  Form1.ibDataSet27.Close;
  Form1.ibDataSet27.SelectSQL.Text := SelectSqlAlteracaEdicao;
  Form1.ibDataSet27.Open;
  }

  TFloatField(Form1.ibDataSet27.FieldByName('UNITARIO')).EditFormat   := '#,##0.' + DupeString('0', StrToIntDef(Form1.ConfPreco, 2)); // Sandro Silva 2023-11-23
  TFloatField(Form1.ibDataSet27.FieldByName('QUANTIDADE')).EditFormat := '#,##0.' + DupeString('0', StrToIntDef(Form1.ConfCasas, 2)); // Sandro Silva 2023-11-23

  AjustaLarguraDBGrid(DBGridItens);

  TotalizaMovimento(Form1.ibDataSet27);

  {Sandro Silva 2023-12-04 inicio}
  FIBDATASETALTERACA := Form1.ibDataSet27;
  FIBDATASETALTERACA.AfterScroll := FIBDATASETALTERACAAfterScroll;
  {Sandro Silva 2023-12-04 fim}

  Form1.ibDataSet27.Last;
  DBGridItens.SelectedIndex := ColumnIndex(DBGridItens.Columns, 'UNITARIO');
  DBGridItensColEnter(DBGridItens);

  {Sandro Silva 2023-12-04 inicio
  FIBDATASETALTERACA := Form1.ibDataSet27;
  FIBDATASETALTERACA.AfterScroll := FIBDATASETALTERACAAfterScroll;
  }

end;

function TFEditaMovimento.TotalizaMovimento(DataSet: TDataSet): Double;
var
  sItem: String;
begin
  DataSet.DisableControls;
  Result := 0.00;
  try
    sItem := DataSet.FieldByName('REGISTRO').AsString;
    DataSet.First;
    while DataSet.Eof = False do
    begin
      if (DataSet.FieldByName('UNITARIO').AsFloat * DataSet.FieldByName('QUANTIDADE').AsFloat) <> DataSet.FieldByName('TOTAL').AsFloat then
      begin
        DataSet.Edit;
        DataSet.FieldByName('TOTAL').AsFloat := StrToFloat(FormatFloat('0.00', DataSet.FieldByName('UNITARIO').AsFloat * DataSet.FieldByName('QUANTIDADE').AsFloat));
        DataSet.Post;
      end;
      if ItemCancelado(DataSet.FieldByName('TOTAL')) = False then
        Result := Result + DataSet.FieldByName('TOTAL').AsFloat;
      DataSet.Next;
    end;
    DataSet.Locate('REGISTRO', sItem, []);
  finally
    DataSet.EnableControls;
  end;

  lbTotal.Caption := 'Total:R$ ' + FormatFloat('0.00', Result);
end;

procedure TFEditaMovimento.DBGridItensColEnter(Sender: TObject);
begin
  DBGridItens.ReadOnly := False;
  if (DBGridItens.SelectedField.FieldName <> 'QUANTIDADE') and (DBGridItens.SelectedField.FieldName <> 'UNITARIO') then
    DBGridItens.ReadOnly := True;
//  if NaoEditavel(DBGridItens.SelectedField) then
//    DBGridItens.ReadOnly := True;
end;

procedure TFEditaMovimento.DBGridItensKeyPress(Sender: TObject;
  var Key: Char);
begin
  if TDBGrid(Sender).SelectedField.DataType = ftFloat then
  begin
    if Key = Chr(46) then
      Key := Chr(44);
  end;

  if NaoEditavel(DBGridItens.SelectedField) then
    Key := #0;
    
  if (Key = '-') or (Key = '+') or (Key = 'E') or (Key = 'e') then
    Key := #0;

end;

procedure TFEditaMovimento.DBGridItensKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 46) then
    Key := 0;

  if Key in [VK_TAB{, VK_ESCAPE}] then
    Key := VK_RETURN;

  try

    if Key = VK_RETURN then
    begin

      if (TDBGrid(Sender).SelectedIndex + 1) > ColumnIndex(TDBGrid(Sender).Columns, 'UNITARIO') then
      begin

        TDBGrid(Sender).DataSource.DataSet.Next;

        if TDBGrid(Sender).DataSource.DataSet.Eof then
          btnOk.SetFocus
        else
          TDBGrid(Sender).SelectedIndex := ColumnIndex(TDBGrid(Sender).Columns, 'QUANTIDADE'); // TDBGrid(Sender).SelectedIndex := 0;

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
  Application.OnMessage := FoMessageEvent;
  Form1.bEditandoMovimento := False;
  Form1.ibDataSet27.SelectSQL.Text := FSelectOld;
  TFloatField(Form1.ibDataSet27.FieldByName('UNITARIO')).EditFormat   := FEditFormatUnitario; // Sandro Silva 2023-11-23
  TFloatField(Form1.ibDataSet27.FieldByName('QUANTIDADE')).EditFormat := FEditFormatQuantidade; // Sandro Silva 2023-11-23
  FIBDATASETALTERACA.AfterScroll  := nil;
  FIBDATASETALTERACA.BeforeScroll := nil;
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

function TFEditaMovimento.ItemCancelado(Field: TField): Boolean;
begin
  Result := False;    
  if (Field.DataSet.FieldByName('DESCRICAO').AsString = '<CANCELADO>')
    or (Field.DataSet.FieldByName('VENDEDOR').AsString = '<cancelado>')
    or (Field.DataSet.FieldByName('TIPO').AsString = 'CANCEL')
    or (Field.DataSet.FieldByName('TIPO').AsString = 'KOLNAC')
  then
    Result := True;
end;

function TFEditaMovimento.NaoEditavel(Field: TField): Boolean;
var
  bNaoEditaQtd: Boolean;
begin
  Result := False;

  bNaoEditaQtd := False;

  if (Field.FieldName = 'QUANTIDADE') then
  begin
    if (TemGrade(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (TemSerie(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (TemComposicao(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (SemEstoque(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString) and (Form1.ConfNegat = 'Não'))
    then
      bNaoEditaQtd := True;
  end;

  if ((Field.FieldName <> 'QUANTIDADE')
    and (Field.FieldName <> 'UNITARIO'))
    or ItemCancelado(Field)
    or (Field.DataSet.FieldByName('DESCRICAO').AsString = 'Desconto')
    or (Field.DataSet.FieldByName('DESCRICAO').AsString = 'Acréscimo')
    {Sandro Silva 2023-12-04 inicio
    or (TemGrade(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (TemSerie(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (TemComposicao(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    or (SemEstoque(Form1.ibDataSet27.Transaction, Field.DataSet.FieldByName('CODIGO').AsString))
    {Sandro Silva 2023-12-04 fim}
    or bNaoEditaQtd
    then
      Result := True;
end;

procedure TFEditaMovimento.DBGridItensKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then
  begin
    if TDBGrid(Sender).DataSource.DataSet.Eof then
    begin
      Key := 0;
      TDBGrid(Sender).DataSource.DataSet.Cancel;
    end;
  end;
end;

procedure TFEditaMovimento.FIBDATASETALTERACAAfterScroll(
  DataSet: TDataSet);
begin
   DBGridItens.ReadOnly := False;
  if NaoEditavel(DBGridItens.SelectedField) then
    DBGridItens.ReadOnly := True;

  {Sandro Silva 2023-12-04 inicio}
  AlertaDeProdutoNaoEditavel;
  {Sandro Silva 2023-12-04 fim}
end;

procedure TFEditaMovimento.ScrollMouse(var Msg: TMsg;
  var Handled: Boolean);
var
  i: Smallint;
begin
  if Msg.message = WM_MOUSEWHEEL then
  begin
    Msg.message := WM_KEYDOWN;
    Msg.lParam := 0;
    i := HiWord(Msg.wParam) ;
    if i > 0 then
    begin
      if DBGridItens.DataSource.DataSet.RecNo = 1 then
        Exit;
      Msg.wParam := VK_UP
    end
    else
    begin
      if DBGridItens.DataSource.DataSet.RecNo = DBGridItens.DataSource.DataSet.RecordCount then
        Exit;
      Msg.wParam := VK_DOWN;
    end;
    Handled := False;
  end;
end;

procedure TFEditaMovimento.DBGridItensCellClick(Column: TColumn);
begin
  DBGridItens.ReadOnly := False;
  if NaoEditavel(Column.Field) then
    DBGridItens.ReadOnly := True;
end;

function TFEditaMovimento.SelectSqlAlteracaEdicao: String;
begin
  Result :=
    'select * ' +
    'from ALTERACA ' +
    'where PEDIDO = ' + QuotedStr(FPedido) +
    ' and CAIXA = ' + QuotedStr(FCaixa) +
    ' order by REGISTRO';
end;

function TFEditaMovimento.SelecionaItens: Boolean;
var
  SelectEstoqueOld: String;
  sItem: String;
  sCodigo: String;
  sDescricao: String;
begin
  Result := True;
  FSelectOld := Form1.ibDataSet27.SelectSQL.Text;
  SelectEstoqueOld := Form1.ibDataSet4.SelectSQL.Text;

  FEditFormatUnitario   := TFloatField(Form1.ibDataSet27.FieldByName('UNITARIO')).EditFormat; // Sandro Silva 2023-11-23
  FEditFormatQuantidade := TFloatField(Form1.ibDataSet27.FieldByName('QUANTIDADE')).EditFormat; // Sandro Silva 2023-11-23
  try
    Form1.ibDataSet27.Close;
    Form1.ibDataSet27.SelectSQL.Text := SelectSqlAlteracaEdicao;
    Form1.ibDataSet27.Open;

    while Form1.ibDataSet27.Eof = False do
    begin

      if (Form1.ibDataSet27.FieldByName('TIPO').AsString <> 'CANCEL') then
      begin
      
        // Para pode exibir na mensagem quando não consegue bloquear os registros dos itens da venda
        sItem      := Form1.ibDataSet27.FieldByName('ITEM').AsString;
        sCodigo    := Form1.ibDataSet27.FieldByName('CODIGO').AsString;
        sDescricao := Form1.ibDataSet27.FieldByName('DESCRICAO').AsString;

        if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then
        begin
          Result := False;
          Break;
        end;

        try
          // Artifício para forçar a edição e bloquear nas tabelas alteraca e estoque
          Form1.ibDataSet27.Edit;
          Form1.ibDataSet27.FieldByName('CODIGO').AsString := Form1.ibDataSet27.FieldByName('CODIGO').AsString;
          Form1.ibDataSet27.Post;

          Form1.ibDataSet4.Close;
          Form1.ibDataSet4.SelectSQL.Text :=
            'select * from ESTOQUE where CODIGO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString);
          Form1.ibDataSet4.Open;

          if (Form1.ibDataSet4.FieldByName('CODIGO').AsString <> '') and (Form1.ibDataSet4.FieldByName('DESCRICAO').AsString <> '') then
          begin
            Form1.ibDataSet4.Edit;
            Form1.ibDataSet4.FieldByName('CODIGO').AsString := Form1.ibDataSet4.FieldByName('CODIGO').AsString;
            Form1.ibDataSet4.Post;
          end;

        except
          on E: Exception do
          begin
            Form1.ibDataSet27.SelectSQL.Text := FSelectOld;
            Result := False;
            Break;
          end;
        end;
      end;
      Form1.ibDataSet27.Next;
    end;
  finally
    if Result = False then
    begin
      Application.BringToFront;
      SmallMessageBox(
        'Item: ' + RightStr(sItem, 3) + ' - ' + sDescricao + #13 + #13 +
        'Está sendo movimentado por outro usuário', 'Atenção', MB_OK + MB_ICONWARNING);
    end;
    Form1.ibDataSet4.SelectSQL.Text := SelectEstoqueOld;
  end;
end;

procedure TFEditaMovimento.AlertaDeProdutoNaoEditavel;
begin
  {Sandro Silva 2023-12-04 inicio}
  lbAlerta.Visible := False;
  if (TemGrade(Form1.ibDataSet27.Transaction, Form1.ibDataSet27.FieldByName('CODIGO').AsString))
  or (TemSerie(Form1.ibDataSet27.Transaction, Form1.ibDataSet27.FieldByName('CODIGO').AsString))
  or (TemComposicao(Form1.ibDataSet27.Transaction, Form1.ibDataSet27.FieldByName('CODIGO').AsString))
  or (SemEstoque(Form1.ibDataSet27.Transaction, Form1.ibDataSet27.FieldByName('CODIGO').AsString) and (Form1.ConfNegat = 'Não') )
  then
  begin
    lbAlerta.Caption := '*Item ' + RightStr(Form1.ibDataSet27.FieldByName('ITEM').AsString, 3) + ' é produto';
    if (Form1.ConfNegat = 'Não') then
      lbAlerta.Caption := lbAlerta.Caption + ' sem estoque, ou';
    lbAlerta.Caption := lbAlerta.Caption + ' composto, ou com grade, ou com controle de série';
    lbAlerta.Visible := True;
    if (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Desconto') or (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Acréscimo') then
      lbAlerta.Visible := False;
  end;
  {Sandro Silva 2023-12-04 fim}

end;

end.
