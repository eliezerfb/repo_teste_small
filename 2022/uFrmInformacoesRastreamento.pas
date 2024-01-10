unit uFrmInformacoesRastreamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, StrUtils, DBCtrls, ExtCtrls, Buttons, DB, smallfunc_xe,
  DBClient, Grids, DBGrids, IBCustomDataSet;

const COR_CAMPO_OBRIGATORIO = $0080FFFF;

type
   TValidaDadosCampo = class
      procedure SetText(Sender: TField; const Text: String);
   private
     function OccurrencesOfChar(const S: string; const C: char): integer;
   public

   end;

type
  TFrmInformacoesRastreamento = class(TForm)
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    lbLegenda: TLabel;
    lbQuantidadeItem: TLabel;
    lbProduto: TLabel;
    lbValorQuantidadeItem: TLabel;
    lbQuantidadeAcumulada: TLabel;
    CDSLOTES: TClientDataSet;
    DSLOTES: TDataSource;
    CDSLOTESNUMERO: TWideStringField;
    CDSLOTESQUANTIDADE: TFloatField;
    CDSLOTESDTFABRICACAO: TDateField;
    CDSLOTESDTVALIDADE: TDateField;
    CDSLOTESCODIGOAGREGACAO: TWideStringField;
    DBGridRastro: TDBGrid;
    CDSLOTESQUANTIDADEACUMULADA: TAggregateField;
    DBTValorQuantidadeAcumulada: TDBText;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FocusNextControl(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DBGridRastroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CDSLOTESAfterOpen(DataSet: TDataSet);
    procedure DBGridRastroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridRastroKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridRastroExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FdQtdAcumulado: Double;
    FdQtdItemNaNota: Double;

    function LinhaDataSetPreenchida(DataSet: TDataSet): Boolean;
  public
    { Public declarations }
    property QtdItemNaNota: Double read FdQtdItemNaNota write FdQtdItemNaNota;
  end;

var
  ValidaDadosCampos: TValidaDadosCampo;
  FrmInformacoesRastreamento: TFrmInformacoesRastreamento;

implementation

uses uDialogs;

{$R *.dfm}

procedure ValidaDadosCampo(DataSet: TDataSet; DataFiled: String);
begin
  DataSet.FieldByName(DataFiled).OnSetText := ValidaDadosCampos.SetText;
end;

procedure MsgBoxAlerta(sMensagem: String);
begin
  //Application.MessageBox(PChar(sMensagem), 'Atenção', MB_OK + MB_ICONWARNING) Mauricio Parizotto 2023-10-25
  MensagemSistema(sMensagem,msgAtencao);
end;

function TiraMascara(sTexto: String): String;
{Sandro Silva 2011-04-01 inicio
Retorna string sem mascaras. Ex.: CNPJ elimina traços, pontos}
var
   iPos: Integer;
begin
  Result := '';
  for iPos := 1 to Length(sTexto) do
    if StrToIntDef(Copy(sTexto, iPos, 1), -1) >= 0 then
      Result := Result + Copy(sTexto, iPos, 1);
end;

procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBkMode: Integer;
  xRect: TRect;
begin
  (Sender as TDBGrid).Canvas.Pen.Color   := clBlack;
  (Sender as TDBGrid).Canvas.Brush.Color := clBtnFace;// clBlack;
  //
  xRect.Left   := Rect.Left;
  xRect.Top    := -1;
  xRect.Right  := Rect.Right;
  xRect.Bottom := Rect.Bottom - Rect.Top;// + 1;
  (Sender as TDBGrid).Canvas.FillRect(xRect);
  xRect.Bottom := Rect.Bottom - Rect.Top;// + 2;
  //
  //
  OldBkMode := SetBkMode((Sender as TDBGrid).Handle, TRANSPARENT);
  (Sender as TDBGrid).Canvas.Font.Style := [];
  //(Sender as TDBGrid).Canvas.Font.Size := (Sender as TDBGrid).Columns[Column.Index].Title.Font.Size;
  if (fsBold in (Sender as TDBGrid).Columns[Column.Index].Title.Font.Style) then
    (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
  (Sender as TDBGrid).Canvas.Font.Color  := clblack;
  (Sender as TDBGrid).Canvas.Brush.Color := clBtnFace;
  (Sender as  TDBGrid).Canvas.TextOut(Rect.Left + 2, 2, Trim(Column.Title.Caption));
  (Sender as TDBGrid).Canvas.Font.Color  := clblack;
  SetBkMode((Sender as TDBGrid).Canvas.Handle, OldBkMode);

  ///////////
  (Sender as TDBGrid).Canvas.Font.Style := [];

  if gdSelected in State then // Se a coluna estiver selecionada deixa a fonte branca para ter contraste
    (Sender as TDBGrid).Canvas.Font.Color := clWhite;
end;

procedure TFrmInformacoesRastreamento.btnCancelarClick(Sender: TObject);
begin

  if CDSLOTES.RecordCount > 0 then
  begin
    if Application.MessageBox(PChar('As informações digitadas não constarão na nota' + #10 + #10 + 'Realmente deseja não informar?'), 'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = id_No then
      Exit;
  end;

  Close;
end;

procedure TFrmInformacoesRastreamento.btnOkClick(Sender: TObject);
var
  bOk: Boolean;
begin
  CDSLOTES.DisableControls;
  try
    bOk := True;
    FdQtdAcumulado := 0;
    CDSLOTES.First;
    while CDSLOTES.Eof = False do
    begin

      if LinhaDataSetPreenchida(CDSLOTES) then
      begin

        if CDSLOTES.FieldByName('NUMERO').AsString = '' then
        begin
          MsgBoxAlerta('Informe o Número do lote');
          DBGridRastro.SelectedIndex := 0;
          bOk := False;
          Break;
        end;

        if CDSLOTES.FieldByName('QUANTIDADE').AsFloat <= 0 then
        begin
          MsgBoxAlerta('Informe a Quantidade no lote');
          DBGridRastro.SelectedIndex := 1;
          bOk := False;
          Break;
        end;

        if CDSLOTES.FieldByName('DTFABRICACAO').AsDateTime = StrToDate('30/12/1899') then
        begin
          MsgBoxAlerta('Informe a Data de Fabricação válida');
          DBGridRastro.SelectedIndex := 2;
          bOk := False;
          Break;
        end;

        if CDSLOTES.FieldByName('DTVALIDADE').AsDateTime = StrToDate('30/12/1899') then
        begin
          MsgBoxAlerta('Informe a Data de Validade válida');
          DBGridRastro.SelectedIndex := 3;
          bOk := False;
          Break;
        end;

        FdQtdAcumulado := FdQtdAcumulado + CDSLOTES.FieldByName('QUANTIDADE').AsFloat;
      end;

      CDSLOTES.Next;
    end;

    if FdQtdAcumulado <> FdQtdItemNaNota then
    begin

      if FdQtdAcumulado > FdQtdItemNaNota then
        MsgBoxAlerta('O total de quantidades informadas ultrapassou a quantidade do item na nota');
      if FdQtdAcumulado < FdQtdItemNaNota then
        MsgBoxAlerta('Total de quantidades informadas menor que a quantidade do item na nota');

      DBGridRastro.SelectedIndex := 1;
      bOk := False;

    end;

    if bOk = False then
    begin

      DBGridRastro.SetFocus;

    end
    else
    begin

      // Limpar a linhas sem informações
      CDSLOTES.First;
      while CDSLOTES.Eof = False do
      begin

        if (CDSLOTES.FieldByName('NUMERO').AsString = '')
          or (CDSLOTES.FieldByName('QUANTIDADE').AsString = '')
          or (CDSLOTES.FieldByName('DTFABRICACAO').AsString = '')
          or (CDSLOTES.FieldByName('DTVALIDADE').AsString = '')
        then
          CDSLOTES.Delete
        else
          CDSLOTES.Next;

      end;

      ModalResult := mrOk;

    end;
  finally
    CDSLOTES.EnableControls;
  end;
end;

procedure TFrmInformacoesRastreamento.FocusNextControl(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(Sender as TWinControl, True, True);
    Key := #0;
  end;
end;

procedure TFrmInformacoesRastreamento.FormCreate(Sender: TObject);
var
  iCol: Integer;
begin
  //lbProduto.AutoSize   := False;
  //lbProduto.Width      := FrmInformacoesRastreamento.Width - 16;
  //lbProduto.Alignment  := taCenter;
  lbProduto.Font.Size  := 9;
  lbProduto.Font.Style := [fsBold];

  lbValorQuantidadeItem.Font.Style       := [fsBold];
  DBTValorQuantidadeAcumulada.Font.Style := [fsBold];

  lbLegenda.ParentColor := False;

  CDSLOTES.CreateDataSet;
  CDSLOTES.Open;

  lbLegenda.Color      := COR_CAMPO_OBRIGATORIO;

  CDSLOTES.EmptyDataSet;

end;

procedure TFrmInformacoesRastreamento.DBGridRastroDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  R: TRect; 
  yCalc, xCalc: integer;
  sTexto: String;
begin

  sTexto := Column.Field.AsString;
  xCalc  := Rect.Left + 2;

  (Sender As TDBGrid).Canvas.Font.Color := clBlack;

  if (Column.FieldName = 'NUMERO')
    or (Column.FieldName = 'QUANTIDADE')
    or (Column.FieldName = 'DTFABRICACAO')
    or (Column.FieldName = 'DTVALIDADE')
  then
  begin
    if (Sender as TDBGrid).DataSource.DataSet.FieldByName(Column.FieldName).AsString = '' then
      (Sender as TDBGrid).Canvas.Brush.Color := COR_CAMPO_OBRIGATORIO;
  end;

  (Sender as TDBGrid).Canvas.Font.Color := clWindowText;
  if gdSelected in State then
    (Sender as TDBGrid).Canvas.Font.Color := clWindowText;

  (Sender as TDBGrid).Canvas.Font.Style := [];
  if (Column.FieldName = 'DTFABRICACAO')
    or (Column.FieldName = 'DTVALIDADE')
  then
  begin

    if ((Sender as TDBGrid).DataSource.DataSet.FieldByName('DTFABRICACAO').AsString <> '')
      and ((Sender as TDBGrid).DataSource.DataSet.FieldByName('DTVALIDADE').AsString <> '') then
    begin

      if (Sender as TDBGrid).DataSource.DataSet.FieldByName('DTFABRICACAO').AsDateTime > (Sender as TDBGrid).DataSource.DataSet.FieldByName('DTVALIDADE').AsDateTime then
      begin
        (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
        (Sender as TDBGrid).Canvas.Font.Color := clRed;
      end;

    end;

    if (Column.FieldName = 'DTFABRICACAO') then
    begin
      if Column.Field.AsString <> '' then
        if Date < Column.Field.AsDateTime then
        begin
          (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
          (Sender as TDBGrid).Canvas.Font.Color := clRed;
        end;
    end;

    if (Column.FieldName = 'DTVALIDADE') then
    begin
      if Column.Field.AsString <> '' then
        if Date > Column.Field.AsDateTime then
        begin
          (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
          (Sender as TDBGrid).Canvas.Font.Color := clRed;
        end;
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

procedure TFrmInformacoesRastreamento.CDSLOTESAfterOpen(DataSet: TDataSet);
begin
  TDateTimeField(DataSet.FieldByName('DTFABRICACAO')).DisplayFormat := 'dd/mm/yyyy';
  TDateTimeField(DataSet.FieldByName('DTVALIDADE')).DisplayFormat   := 'dd/mm/yyyy';
  TFloatField(DataSet.FieldByName('QUANTIDADE')).DisplayFormat      := '#0.00';

  DataSet.FieldByName('DTFABRICACAO').EditMask := '!99/99/9999;1;_';
  DataSet.FieldByName('DTVALIDADE').EditMask   := '!99/99/9999;1;_';

  ValidaDadosCampo(DataSet, 'QUANTIDADE');
  ValidaDadosCampo(DataSet, 'DTFABRICACAO');
  ValidaDadosCampo(DataSet, 'DTVALIDADE');

end;

procedure TFrmInformacoesRastreamento.DBGridRastroKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26

  if Key = VK_DELETE then
  begin
    if CDSLOTES.RecordCount > 0 then
      CDSLOTES.Delete;
  end;

  if (Key = VK_RETURN) then
  begin

    // Avança cada coluna com Enter e quando chega na última cria linha nova
    //if (Sender As TDBGrid).DataSource.DataSet.State in [dsBrowse] then
    begin
      if (Sender As TDBGrid).SelectedIndex = (Sender As TDBGrid).Columns.Count -1 then
      begin

        if (Sender As TDBGrid).DataSource.DataSet.FieldByName('NUMERO').AsString = '' then
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

//Passa todos os campos do DataSet, se nenhum estiver preenchido retorna True
function TFrmInformacoesRastreamento.LinhaDataSetPreenchida(
  DataSet: TDataSet): Boolean;
var
  iCol: Integer;
begin
  Result := False;

  // Passa por todos os campos
  for iCol := 0 to DataSet.Fields.Count -1 do
  begin
    if DataSet.Fields[iCol].AsString <> '' then
    begin
      Result := True;
      Break;
    end;
  end;

end;

{ TValidaDadosCampo }

function TValidaDadosCampo.OccurrencesOfChar(const S: string;
  const C: char): integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(S) do
    if S[i] = C then
      inc(Result);
end;

procedure TValidaDadosCampo.SetText(Sender: TField; const Text: String);
var
  sCurrectedText: String;
  sTextOutDecimalsSeparator: String;
  iPos: Integer;
begin
  if TiraMascara(Text) = '' then
    Sender.Clear
  else
  begin
    case Sender.DataType of
    ftDate:
      begin
        if StrToDateDef(Text,0) = 0 then
          MsgBoxAlerta('Data inválida')
        else
          Sender.AsString := Text;
      end;
    ftTime:
      begin
        if StrToTimeDef(Text,0) = 0 then
          MsgBoxAlerta('Hora inválida')
        else
          Sender.AsString := Text;
      end;
    ftDateTime, ftTimeStamp:
      begin {01.10.2007 - Sandro}
        if StrToDateTimeDef(Text,0) = 0 then
        begin
          Sender.Clear;
          MsgBoxAlerta('Data/hora inválida')
        end
        else
          Sender.AsString := Text;
      end;
    ftFMTBcd, ftFloat:
      begin
        // Elimina excesso de separador decimal (vírgula)
        sCurrectedText := '';

        for iPos := 1 to Length(Text) do
        begin
          {$IFDEF VER150}
          if (OccurrencesOfChar(sCurrectedText, DecimalSeparator) = 0) or (Copy(Text, iPos, 1) <> DecimalSeparator) then
            sCurrectedText := sCurrectedText + Copy(Text, iPos, 1);
          {$ELSE}
          if (OccurrencesOfChar(sCurrectedText, FormatSettings.DecimalSeparator) = 0) or (Copy(Text, iPos, 1) <> FormatSettings.DecimalSeparator) then
            sCurrectedText := sCurrectedText + Copy(Text, iPos, 1);
          {$ENDIF}
        end;

        {$IFDEF VER150}
        sCurrectedText := StringReplace(sCurrectedText, ThousandSeparator, '', [rfReplaceAll]);
        {$ELSE}
        sCurrectedText := StringReplace(sCurrectedText, FormatSettings.ThousandSeparator, '', [rfReplaceAll]);  
        {$ENDIF}
        sCurrectedText := StringReplace(AnsiLowerCase(sCurrectedText), 'e', '', [rfReplaceAll]);

        Sender.AsString := sCurrectedText;

      end;
    else
      Sender.AsString := Text;
    end;

  end;

end;

procedure TFrmInformacoesRastreamento.DBGridRastroKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Sender As TDBGrid).SelectedField.DataType = ftFloat then
  begin
    if Key = Chr(46) then
      Key := Chr(44);
  end;
end;

procedure TFrmInformacoesRastreamento.DBGridRastroExit(Sender: TObject);
begin
  // Limpar a linhas sem informações
  CDSLOTES.DisableControls;
  try
    CDSLOTES.First;
    while CDSLOTES.Eof = False do
    begin

      if (CDSLOTES.FieldByName('NUMERO').AsString = '')
        and (CDSLOTES.FieldByName('QUANTIDADE').AsString = '')
        and (CDSLOTES.FieldByName('DTFABRICACAO').AsString = '')
        and (CDSLOTES.FieldByName('DTVALIDADE').AsString = '')
        and (CDSLOTES.FieldByName('CODIGOAGREGACAO').AsString = '')
      then
        CDSLOTES.Delete
      else
        CDSLOTES.Next;
    end;
  finally
    CDSLOTES.EnableControls;
  end;
end;

procedure TFrmInformacoesRastreamento.FormShow(Sender: TObject);
begin
  ActiveControl := DBGridRastro;
end;

end.
