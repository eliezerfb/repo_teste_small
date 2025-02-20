unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, SmallFunc, Mask, DBCtrls, SMALL_DBEdit, ComCtrls,
  frame_teclado_1, Buttons, DB, IBCustomDataSet, IBQuery
  , uajustaresolucao
  ;

type
  TTipoMovimentoGrade = (mgRetorno, mgSaida); // [mgRetorno]: Fazendo cancelamento de item ou nota/cupom; [mgSaida]; Fazendo a venda do item 
  
type
  TForm13 = class(TForm)
    Panel1: TPanel;
    StringGrid2: TStringGrid;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Button2: TBitBtn;
    Button1: TBitBtn;
    Label38: TLabel;
    Edit2: TEdit;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid2Click(Sender: TObject);
    procedure StringGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure TabSheet1Enter(Sender: TObject);
    procedure StringGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormCreate(Sender: TObject);
    procedure Label6MouseLeave(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rQtd : Real;
    iMultiplicador, iColunas, iLinhas : Integer;
    BaixaQtd : Real;
    bSaida : Boolean;
    TipoMovimento: TTipoMovimentoGrade; // Sandro Silva 2018-10-30
  end;
var
  Form13: TForm13;

implementation

uses Fiscal, Unit7;

{$R *.DFM}

procedure TForm13.FormActivate(Sender: TObject);
var
  I, J : Integer;
  dQtdCanceladoSemCommit: Double;
  dQtdVendaSemCommit: Double;
begin
  //
  Form13.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Form13.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Form13.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  Form13.Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Form13.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  Form13.Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  Form13.Top    := Form1.Panel1.Top;
  Form13.Left   := Form1.Panel1.Left;
  Form13.Height := Form1.Panel1.Height;
  Form13.Width  := Form1.Panel1.Width;


  {Sandro Silva 2018-04-11 inicio}
  Button1.Left := (Form13.Width - (Button1.Width + Button2.Width + AjustaLargura(25))) div 2;
  Button2.Left := Button1.BoundsRect.Right + AjustaLargura(25);
  {Sandro Silva 2018-04-11 fim}
  //
  iLinhas  := 20;
  iColunas := 20;
  //
  Form13.Edit2.Text   := Form1.ibDataSet4.FieldByname('DESCRICAO').AsString;
  //
  StringGrid1.RowCount := 20;
  StringGrid2.RowCount := 20;
  StringGrid1.ColCount := 20;
  StringGrid1.ColCount := 20;
  //
  StringGrid1.Col := 1;
  StringGrid1.Row := 1;
  StringGrid2.Col := 1;
  StringGrid2.Row := 1;
  //
  for I := 0 to 99 do
  begin
    for J := 0 to 99 do
    begin
      StringGrid1.Cells[I,J] := '';
      StringGrid2.Cells[I,J] := '';
    end;
  end;
  //
  Form1.ibDataSet10.Close;
  Form1.ibDataSet10.SelectSQL.Clear;
  Form1.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form1.ibDataSet4CODIGO.AsString)+' order by CODIGO, COR, TAMANHO');
  Form1.ibDataSet10.Open;
  Form1.ibDataSet10.First;
  //
  rQtd := 0;
  //
  while not Form1.ibDataSet10.EOF do
  begin
    //
    if AllTrim(Form1.ibDataSet10QTD.AsString) <> '' then
    begin
      if StrToInt(Form1.ibDataSet10COR.AsString) + strtoInt(Form1.ibDataSet10TAMANHO.AsString) <> 0 then
      begin
        if (StrToInt(Form1.ibDataSet10COR.AsString) <> 0) and (strtoInt(Form1.ibDataSet10TAMANHO.AsString) <> 0) then
        begin
          rQtd := rQtd + StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form1.ibDataSet10QTD.AsString)));
          Form13.StringGrid1.Cells[StrToInt(Form1.ibDataSet10COR.AsString),strtoInt(Form1.ibDataSet10TAMANHO.AsString)] := '0,00';
          Form13.StringGrid2.Cells[StrToInt(Form1.ibDataSet10COR.AsString),strtoInt(Form1.ibDataSet10TAMANHO.AsString)] := Form1.ibDataSet10QTD.AsString;
          //
        end else
        begin
          Form13.StringGrid1.Cells[StrToInt(Form1.ibDataSet10COR.AsString),strtoInt(Form1.ibDataSet10TAMANHO.AsString)] := Form1.ibDataSet10QTD.AsString;
          Form13.StringGrid2.Cells[StrToInt(Form1.ibDataSet10COR.AsString),strtoInt(Form1.ibDataSet10TAMANHO.AsString)] := Form1.ibDataSet10QTD.AsString;
        end;
      end;
    end;
    //
    Form1.ibDataSet10.Next;
  end;
  //
  for I := 0 to 20 do if AllTrim(StringGrid1.Cells[I,0]) <> '' then iColunas := I;
  for I := 0 to 20 do if AllTrim(StringGrid1.Cells[0,I]) <> '' then iLinhas  := I;
  //
  // Só pra saber se é entrada ou saída, só a 1a X
  //
  Form13.StringGrid1.Repaint;
  Form13.StringGrid2.Repaint;
  Form13.StringGrid1.SetFocus;
  //
  dQtdCanceladoSemCommit := QtdCanceladaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString);
  dQtdVendaSemCommit     := QtdVendaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString);
  if ((rQtd - (Form1.ibDataSet4.FieldByname('QTD_ATUAL').AsFloat + dQtdCanceladoSemCommit - dQtdVendaSemCommit)) < 0) and (Form1.ConfNegat = 'Não') then // Sandro Silva 2018-10-24 if (rQtd - (Form1.ibDataSet4.FieldByname('QTD_ATUAL').AsFloat + QtdCanceladaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString) - QtdVendaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString))) < 0 then
    bSaida := False
  else
    bSaida := True;
  //
  StringGrid1.SetFocus;
  //
  Button2.Visible := not (Form13.TipoMovimento = mgRetorno);
  if Form13.TipoMovimento = mgRetorno then
    Label38.Caption := 'Grade do item ' + Right(Form1.ibDataSet27.FieldByName('ITEM').AsString, 3) + ':'
end;

procedure TForm13.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  iMultiplicador, J, I : Integer;
  BaixaQtd : Real;
  rCompraOuVenda : Real;
begin
  //
  BaixaQtd := rQtd - (Form1.ibDataSet4.FieldByname('QTD_ATUAL').AsFloat + QtdCanceladaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString) - QtdVendaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString));
  rCompraOuVenda  := 0;
  //
  if Form13.TipoMovimento = mgRetorno then // Sandro Silva 2019-03-18   if Copy(Form13.Label2.Caption,1,4) = 'Reto' then
    iMultiplicador := 1
  else
    iMultiplicador := -1;
  //
  for I := 0 to 99 do
  begin
    for J := 0 to 99 do
    begin
      if AllTrim(Form13.StringGrid1.Cells[I,J]) <> '' then
      begin
        try
          if (I <> 0) and (J <> 0) then
          begin
            BaixaQtd := BaixaQtd + (StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J])))*iMultiplicador);
            rCompraOuVenda  := rCompraOuVenda  + StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J])));
          end;
        except Form13.StringGrid1.Cells[I,J] := ''  end;
      end;
    end;
  end;
  //

  if Form13.TipoMovimento = mgRetorno then
  begin
    Label2.Caption := '   Saída de: ' + Format('%12.'+Form1.ConfCasas+'n',[Abs(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat)]) + #13 +
                      'Retorno de: '  + Format('%12.'+Form1.ConfCasas+'n',[Abs(rCompraOuVenda)]);
  end
  else
    Label2.Caption := 'Saída de: '+Format('%12.'+Form1.ConfCasas+'n',[Abs(rCompraOuVenda)]);

  //
  try
    if StringGrid1.Cells[aCol,aRow] <> '' then
    begin
      if (aCol <> 0) and (aRow <> 0) then
      begin
        if StringGrid1.Cells[aCol,aRow] <> Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))]) then
        begin
          StringGrid1.Cells[aCol,aRow] := Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))]);
        end;
      end;
    end;
  except StringGrid1.Cells[aCol,aRow] := '0,00' end;
  //
  StringGrid1.Canvas.Font.Color := clblack;
  if ACol = 0 then StringGrid1.Canvas.Font.Color := clRed;
  if ARow = 0 then StringGrid1.Canvas.Font.Color := clBlue;
//  if not ((ARow = 0) or (ACol = 0)) then StringGrid1.Canvas.Brush.Color := clWindow;
  StringGrid1.Canvas.FillRect(Rect);
  //
  if ARow = 0 then
  begin
    StringGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Form13.StringGrid1.Cells[aCol,aRow])
  end else
  begin
    //
    //
    // Mostra na grade primeiro o saldo em estoque
    if ACol <> 0 then
    begin
      StringGrid1.Canvas.Font.Name  := 'Arial';
      StringGrid1.Canvas.Font.Color := clSilver;
      StringGrid1.Canvas.Font.Size  := StringGrid1.Font.Size - 2; // 8;
      StringGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+16,AllTrim(Form13.StringGrid2.Cells[aCol,aRow]));
    end;
    // Depois mostra na grade a quantidade digitada para o Canvas não cortar a vírgula
    StringGrid1.Canvas.Font.Size  := StringGrid1.Font.Size; // 10;
    StringGrid1.Canvas.Font.Color := clBlack;
    if aCol = 0 then StringGrid1.Canvas.Font.Color := clRed;
    StringGrid1.Canvas.TextOut(Rect.Right - StringGrid1.Canvas.TextWidth(Form13.StringGrid1.Cells[aCol,aRow]) -2 ,Rect.Top+2,  Form13.StringGrid1.Cells[aCol,aRow]);
    //
  end;
  //
end;

procedure TForm13.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  try
    if (Key = VK_Down) or (Key = VK_Up) or (Key = VK_Right) or (Key = VK_Left)  or (Key = VK_Return)then
    begin
      if not ((StringGrid1.Row = 0) and (StringGrid1.Col =  iColunas + 1)) then
      begin
        if not ((StringGrid1.Row = 0) and (StringGrid1.Row =  iLinhas + 1)) then
        begin
          if StringGrid1.Col = 0 then StringGrid1.Col := 1;
          if StringGrid1.Row = 0 then StringGrid1.Row := 1;
        end;
      end;
      for I := 0 to 20 do if AllTrim(StringGrid1.Cells[I,0]) <> '' then iColunas := I;
      for I := 0 to 20 do if AllTrim(StringGrid1.Cells[0,I]) <> '' then iLinhas  := I;
////////////////////////////////////////////
      //
    end;
  except end;
  //
  //
end;

procedure TForm13.StringGrid1Click(Sender: TObject);
begin
  //
  if not ((StringGrid1.Row = 0) and (StringGrid1.Col =  iColunas + 1)) then
  begin
    if not ((StringGrid1.Col = 0) and (StringGrid1.Row =  iLinhas + 1)) then
    begin
      if StringGrid1.Col = 0 then StringGrid1.Col := 1;
      if StringGrid1.Row = 0 then StringGrid1.Row := 1;
      //
      if StringGrid1.Col > iColunas then StringGrid1.Col := iColunas;
      if StringGrid1.Row > iLinhas  then StringGrid1.Row := iLinhas;
    end;
  end;
  //
end;

procedure TForm13.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  //
  try
    if StringGrid2.Cells[aCol,aRow] <> '' then
    begin
      if (aCol <> 0) and (aRow <> 0) then
      begin
        if StringGrid2.Cells[aCol,aRow] <> Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid2.Cells[aCol,aRow]))]) then
        begin
          StringGrid2.Cells[aCol,aRow] := Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid2.Cells[aCol,aRow]))]);
        end;
      end;
    end;
  except StringGrid2.Cells[aCol,aRow] := '' end;
  //
  if ACol = 0 then
    StringGrid2.Canvas.Font.Color := clBlue
    else
      if ARow = 0 then
        StringGrid2.Canvas.Font.Color := clRed
          else StringGrid2.Canvas.Font.Color := clBlack;
  //
  if not ((ARow = 0) or (ACol = 0)) then StringGrid2.Canvas.Brush.Color := clWindow;
  StringGrid2.Canvas.FillRect(Rect);
  //
  if ARow = 0 then
  begin
    StringGrid2.Canvas.TextOut(Rect.Left+2,Rect.Top+2,  Form13.StringGrid2.Cells[aCol,aRow])
  end else
  begin
    StringGrid2.Canvas.TextOut(Rect.Right - StringGrid2.Canvas.TextWidth(Form13.StringGrid2.Cells[aCol,aRow]) -2 ,Rect.Top+2,  Form13.StringGrid2.Cells[aCol,aRow]);
  end;
  //
end;

procedure TForm13.StringGrid2Click(Sender: TObject);
begin
  if StringGrid2.Col = 0 then StringGrid2.Col := 1;
  if StringGrid2.Row = 0 then StringGrid2.Row := 1;
end;

procedure TForm13.StringGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if StringGrid2.Col = 0 then StringGrid2.Col := 1;
  if StringGrid2.Row = 0 then StringGrid2.Row := 1;
end;

procedure TForm13.StringGrid1KeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
   try
     if Key = chr(13) then
     begin
       I := StringGrid1.Col;
       try StringGrid1.Col := StringGrid1.Col + 1; except end;
       if I = StringGrid1.Col then
       begin
         StringGrid1.Col := 0;
         if Trim(StringGrid1.Cells[0, StringGrid1.Row + 1]) = '' then
           Button1.SetFocus
         else
           StringGrid1.Row := StringGrid1.Row + 1;
       end;
     end;
   except end;
   if Key = Chr(45) then Key := Chr(0);
end;

procedure TForm13.TabSheet1Enter(Sender: TObject);
begin
  StringGrid1.Col := 0;
  StringGrid1.Row := 0;
end;

procedure TForm13.StringGrid2KeyPress(Sender: TObject; var Key: Char);
var
  I : Integer;
begin
   try
     if Key = chr(13) then
     begin
       I := StringGrid2.Col;
       try StringGrid2.Col := StringGrid2.Col + 1; except end;
       if I = StringGrid2.Col then
       begin
         StringGrid2.Col := 0;
         StringGrid2.Row := StringGrid2.Row + 1;
       end;
     end;
   except end;
end;

procedure TForm13.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  I, J : Integer;
begin
  //
  // verifica se tem quantidade ou não
  //
  if bSaida then
  begin
    for I := 0 to 99 do
    begin
      for J := 0 to 99 do
      begin
        if AllTrim(Form13.StringGrid1.Cells[I,J]) <> '' then
        begin
          try
            if (I <> 0) and (J <> 0) then
            begin
              if Form1.ConfNegat = 'Não' then
              begin
                if StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J]))) > StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid2.Cells[I,J]))) then
                begin
                  SmallMsg('Não tem '+AllTrim(StrTran(Form13.StringGrid1.Cells[I,J],'-',''))+' '+AllTrim(Form1.ibDataSet4.FieldByname('DESCRICAO').AsString)+' '+Form13.StringGrid1.Cells[I,0]+' '+Form13.StringGrid1.Cells[0,J]+' no estoque.'+Chr(10)+
                  'Só tem '+AllTrim(Form13.StringGrid2.Cells[I,J])+'.');
                  Form13.StringGrid1.Cells[I,J] := '0,0';
                end;
              end;
            end;
          except Form13.StringGrid1.Cells[I,J] := ''  end;
        end;
      end;
    end;
  end;
////////////////////////////      //
end;

procedure TForm13.FormCreate(Sender: TObject);
begin
  Form1.bChaveGrade := False;
  AjustaResolucao(Form13);// Sandro Silva 2016-07-28
  AjustaResolucao(Form13.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18
end;

procedure TForm13.Label6MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm13.Label5MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm13.Label5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm13.Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
  //
  //  Form1.ibDataSet27.Delete;
  //
  try
    Form1.ibDataSet27.Edit;
    Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := 0;
    Form1.ibDataSet27.FieldByName('TOTAL').AsFloat      := 0;
  except

  end;
  //
  Form1.Edit1.Text := '';

  Close;
end;

procedure TForm13.Button1Click(Sender: TObject);
var
  iMultiplicador, J, I : Integer;
  BaixaQtd : Real;
  rCompraOuVenda : Real;
  sObs: String;
  sQtdGrade: String; // Sandro Silva 2019-03-18
  dQtdGrade: Real; // Sandro Silva 2019-03-18
  dQtdCanceladaSemCommit: Double; // Sandro Silva 2019-03-19
  dQtdVendaSemCommit: Double; // Sandro Silva 2019-03-19
begin
  //
  try
    //
    rCompraOuVenda := 0;
    //
    dQtdCanceladaSemCommit := QtdCanceladaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString); // Sandro Silva 2019-03-19
    dQtdVendaSemCommit     := QtdVendaSemCommit(Form1.ibDataSet4.FieldByname('CODIGO').AsString); // Sandro Silva 2019-03-19
    BaixaQtd := rQtd - (Form1.ibDataSet4.FieldByname('QTD_ATUAL').AsFloat + dQtdCanceladaSemCommit - dQtdVendaSemCommit);

    if BaixaQtd < 0 then
      iMultiplicador := 1
    else
      iMultiplicador := -1;
    //
    // Soma as quantidades digitadas
    for I := 0 to 99 do
    begin
      for J := 0 to 99 do
      begin

        sQtdGrade := Trim(Form13.StringGrid1.Cells[I,J]);
        if AllTrim(sQtdGrade) <> '' then
        begin
          try
            if (I <> 0) and (J <> 0) then
            begin
              sQtdGrade := StringReplace(sQtdGrade, '.', '', [rfReplaceAll]);
              dQtdGrade := (StrToFloatDef(sQtdGrade, 0)*iMultiplicador);
              BaixaQtd := StrToFloat(FormatFloat('0.000000', BaixaQtd)) + StrToFloat(FormatFloat('0.000000', dQtdGrade)); // Corrigir problema com dízima periódica na 12ª casa decimal
              rCompraOuVenda  := rCompraOuVenda  + StrToFloat(FormatFloat('0.000000', StrToFloatDef(sQtdGrade, 0))); // Corrigir problema com dízima periódica na 12ª casa decimal

              if Form13.TipoMovimento = mgSaida then
              begin
                if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then // Ficha 4496
                begin
                  if (StrToFloatDef(sQtdGrade, 0)*iMultiplicador) <> 0.00 then
                    sObs := sObs + ' ' + Form13.StringGrid1.Cells[I,0] + ' ' + Form13.StringGrid1.Cells[0,J] + ' ' + FloatToStr(Abs(StrToFloatDef(sQtdGrade, 0)*iMultiplicador)) + '';
                end;
              end;
            end;
          except Form13.StringGrid1.Cells[I,J] := ''  end;
        end;

      end;
    end;
    //
    if not Form1.bApaga then
    begin
      try
        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := rCompraOuVenda;
        Form1.ibDataSet27.FieldByName('TOTAL').AsCurrency   := Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat; // Sandro Silva 2018-12-14 Form1.ibDataSet27TOTAL.AsFloat      := Form1.ibDataSet27QUANTIDADE.AsFloat * Form1.ibDataSet27UNITARIO.AsFloat;
        if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then  // Ficha 4496
          Form1.ibDataSet27.FieldByName('OBS').AsString := Trim(Copy(Trim(sObs), 1, Form1.ibDataSet27.FieldByName('OBS').Size)); // Sandro Silva 2019-03-07
      except
      end;
      Form1.fQuantidadeVendida            := rCompraOuVenda;
      BaixaQtd := 0;
    end;
    //
    if BaixaQtd = 0 then
    begin
      //
      Form1.ibDataSet10.Close;
      Form1.ibDataSet10.SelectSQL.Clear;
      Form1.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form1.ibDataSet4.FieldByName('CODIGO').AsString)+' ');
      Form1.ibDataSet10.Open;
      //
      for I := 0 to 99 do
      begin
        for J := 0 to 99 do
        begin
          if (I <= iColunas) and (J <= iLinhas) then
          begin
            //
            Form1.ibDataSet10.First;
            while (not Form1.ibDataSet10.Eof) and not ((Form1.ibDataSet10.FieldByName('COR').AsString = StrZero(I,2,0)) and (Form1.ibDataSet10.FieldByName('TAMANHO').AsString = StrZero(J,2,0))) do
            begin
              Form1.ibDataSet10.Next;
            end;
            //
            try
              if (Form1.ibDataSet10.FieldByName('COR').AsString = StrZero(I,2,0)) and (Form1.ibDataSet10.FieldByName('TAMANHO').AsString = StrZero(J,2,0)) then
              begin
                Form1.ibDataSet10.Edit;
              end else
              begin
                Form1.ibDataSet10.Append;
              end;
              //
              Form1.ibDataSet10.FieldByName('CODIGO').AsString  := Form1.ibDataSet4.FieldByname('CODIGO').AsString;
              Form1.ibDataSet10.FieldByName('COR').AsString     := StrZero(I,2,0);
              Form1.ibDataSet10.FieldByName('TAMANHO').AsString := StrZero(J,2,0);
              //
              // Quando I=0 e J=0 São as legendas não é a qtd
              //
              if (I = 0) or (J = 0) then
              begin
                Form1.ibDataSet10.FieldByName('QTD').AsString  := Form13.StringGrid1.Cells[I,J]
              end
              else
              begin
                //
                if Form13.StringGrid1.Cells[I,J] = '' then Form13.StringGrid1.Cells[I,J] := '0,00';
                if Form1.ibDataSet10.FieldByName('ENTRADAS').AsString = '' then Form1.ibDataSet10.FieldByName('ENTRADAS').AsString := '0,00';
                if Form13.StringGrid2.Cells[I,J] = '' then Form13.StringGrid2.Cells[I,J]  := '0,00';
                //
                Form1.ibDataSet10.FieldByName('QTD').AsString := Format('%12.4n',[(iMultiplicador*StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J]))))+(StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid2.Cells[I,J]))))]);
                //
              end;
              Form1.ibDataSet10.Post;
            except

            end;

          end;
        end;
      end;
      //
      //
      Close;
      //
    end else
    begin
      SmallMsg('Acerte a diferença de: '+FloatToStr(BaixaQtd));
      if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
      begin
        Exit;
      end;
    end;
    //
  except end;
  //
  Close;
  //
  // Fiz está rotina no dia do meu aniversário 26/09/2001
  //
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  Label2.Top  := StringGrid1.BoundsRect.Bottom + Label2.Height;
  Button1.Top := Label2.BoundsRect.Bottom + AjustaAltura(8);
  Button2.Top := Button1.Top;

  Label2.BringToFront;
  Button1.BringToFront;
  Button2.BringToFront;

  Button1.Repaint;
  Button2.Repaint;
end;

end.
