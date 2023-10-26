unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, SmallFunc, Mask, DBCtrls, SMALL_DBEdit, ComCtrls;

type
  TForm13 = class(TForm)
    Panel1: TPanel;
    StringGrid2: TStringGrid;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Button2: TButton;
    Button1: TButton;
    Label38: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    rQtd : Real;
    iMultiplicador, iColunas, iLinhas : Integer;
    BaixaQtd : Real;
    bSaida : Boolean;
  end;
var
  Form13: TForm13;

implementation

uses Unit7, Mais, Unit24, Unit12, Unit10, Unit14, Unit30, uDialogs;

{$R *.DFM}

procedure TForm13.FormActivate(Sender: TObject);
var
  I, J : Integer;
begin
  //
//  Form13.Caption := Form7.sModulo;
  if (Form7.sModulo = 'COMPRA') or (Form7.sModulo = 'VENDA') then Form1.rReserva := 0;
  //
  iLinhas  := 20;
  iColunas := 20;
  //
  Form13.Edit2.Text   := Form7.ibDataSet4DESCRICAO.AsString;
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
  Form7.ibDataSet10.Close;
  Form7.ibDataSet10.SelectSQL.Clear;
  Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)); //+' order by CODIGO, COR, TAMANHO');
  Form7.ibDataSet10.Open;
  Form7.ibDataSet10.First;
  //
  rQtd := 0;
  //
  while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and not (Form7.ibDataSet10.EOF) do
  begin
    //
    if AllTrim(Form7.ibDataSet10QTD.AsString) <> '' then
    begin
      if StrToInt(Form7.ibDataSet10COR.AsString) + strtoInt(Form7.ibDataSet10TAMANHO.AsString) <> 0 then
      begin
        if (StrToInt(Form7.ibDataSet10COR.AsString) <> 0) and (strtoInt(Form7.ibDataSet10TAMANHO.AsString) <> 0) then
        begin
          //
          rQtd := rQtd + StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form7.ibDataSet10QTD.AsString)));
          Form13.StringGrid1.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := '0,00';
          Form13.StringGrid2.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
          //
        end else
        begin
          Form13.StringGrid1.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
          Form13.StringGrid2.Cells[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
        end;
      end;
    end;
    //
    Form7.ibDataSet10.Next;
    //
  end;
  //
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
  if (rQtd - Form7.ibDataSet4QTD_ATUAL.AsFloat) < 0 then bSaida := False else bSaida := True;
  if Form7.sModulo = 'COMPRA' then bSaida := False;
  //
  StringGrid1.SetFocus;
  if Form7.sModulo = 'COMPRA' then bSaida := False;
  //
end;

procedure TForm13.Button1Click(Sender: TObject);
var
  J, I : Integer;
  rCompraOuVenda : Real;
begin
  if Label2.Caption = 'Saída de: 0,00' then
  begin
    //ShowMessage('Informe a quantidade na grade.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Informe a quantidade na grade.',msgAtencao);
    Abort;
  end;

  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
  
  try
    rCompraOuVenda := 0;
    //
    BaixaQtd := rQtd - Form7.ibDataSet4QTD_ATUAL.AsFloat - Form1.rReserva;
    if BaixaQtd < 0 then iMultiplicador := 1 else iMultiplicador := -1;
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
    if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'OS') then
    begin
      Form7.bChaveGrade := True;
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16QUANTIDADE.AsFloat := rCompraOuVenda;
      Form7.ibDataSet16TOTAL.AsFloat      := Arredonda(Form7.ibDataSet16QUANTIDADE.AsFloat * Form7.ibDataSet16UNITARIO.AsFloat,StrToInt(Form1.ConfPreco));
      BaixaQtd := 0;
      Form12.DBGrid1.Update;
      Form7.bChaveGrade := False;
    end;
    //
    if Form7.sModulo = 'COMPRA' then
    begin
      Form7.bChave := True;
      Form7.ibDataSet23.Edit;
      Form7.ibDataSet23TOTAL.AsFloat        := 0;
      Form7.ibDataSet23QUANTIDADE.AsFloat   := rCompraOuVenda;
      Form7.ibDataSet23QTD_ORIGINAL.AsFloat := rCompraOuVenda;
      //
      form7.ibDataSet23UNITARIO.AsFloat   := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
      Form7.ibDataSet23UNITARIO_O.AsFloat := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
      BaixaQtd := 0;
      Form24.DBGrid1.Update;
      Form7.bChaveGrade := False;
    end;
    //
    if BaixaQtd = 0 then
    begin
      Form7.ibDataSet10.Close;
      Form7.ibDataSet10.SelectSQL.Clear;
      Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
      Form7.ibDataSet10.Open;
      //
      for I := 0 to 99 do
      begin
        for J := 0 to 99 do
        begin
          if (I <= iColunas) and (J <= iLinhas) then
          begin
            //
            Form7.ibDataSet10.First;
            while (not Form7.ibDataSet10.Eof) and not ((Form7.ibDataSet10COR.AsString = StrZero(I,2,0)) and (Form7.ibDataSet10TAMANHO.AsString = StrZero(J,2,0))) do
            begin
              Form7.ibDataSet10.Next;
            end;
            //
            try
              if (Form7.ibDataSet10CODIGO.AsString + Form7.ibDataSet10COR.AsString + Form7.ibDataSet10TAMANHO.AsString) = Form7.ibDataSet4CODIGO.AsString+StrZero(I,2,0)+StrZero(J,2,0) then
              begin
                Form7.ibDataSet10.Edit;
              end else
              begin
                Form7.ibDataSet10.Append;
              end;
              //
              Form7.ibDataSet10CODIGO.AsString  := Form7.ibDataSet4CODIGO.AsString;
              Form7.ibDataSet10COR.AsString     := StrZero(I,2,0);
              Form7.ibDataSet10TAMANHO.AsString := StrZero(J,2,0);
              //
            except end;
            //
            // Quando I=0 e J=0 São as legendas não é a qtd
            try
              if (I = 0) or (J = 0) then
              begin
                 Form7.ibDataSet10QTD.AsString  := Form13.StringGrid1.Cells[I,J]
              end else
              begin
                if Form13.StringGrid1.Cells[I,J] = '' then Form13.StringGrid1.Cells[I,J] := '0,00';
                if Form7.ibDataSet10ENTRADAS.AsString = '' then Form7.ibDataSet10ENTRADAS.AsString := '0,00';
                if Form13.StringGrid2.Cells[I,J] = '' then Form13.StringGrid2.Cells[I,J]  := '0,00';
                //
                if Form7.sModulo = 'COMPRA' then
                begin
                  Form7.ibDataSet10QTD.AsString := LimpaNumeroDeixandoAVirgula( Format('%12.4n',[(-1*iMultiplicador*StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J]))))+(StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid2.Cells[I,J]))))]));
                  Form7.ibDataSet10ENTRADAS.AsString := LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[(iMultiplicador*StrToFloat(LimpaNumeroDeixandoAVirgula(Form13.StringGrid1.Cells[I,J])))+StrToFloat(LimpaNumeroDeixandoAVirgula(Form7.ibDataSet10ENTRADAS.AsString))]));
                  if Form7.ibDataSet10ENTRADAS.AsString = '' then Form7.ibDataSet10ENTRADAS.AsString := '0,00';
                end else
                begin
                  if LimpaNumeroDeixandoAVirgula( Format('%12.2n',[StrToFloat(Form7.ibDataSet10QTD.AsString)]))  <> LimpaNumeroDeixandoAVirgula( Format('%12.2n',[(iMultiplicador*StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J]))))+(StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid2.Cells[I,J]))))])) then
                  Form1.sGrade := Form1.sGrade + '('+Form13.StringGrid1.Cells[0,J]+'/'+Form13.StringGrid1.Cells[I,0]+')';
                  Form7.ibDataSet10QTD.AsString := LimpaNumeroDeixandoAVirgula( Format('%12.4n',[(iMultiplicador*StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid1.Cells[I,J]))))+(StrToFloat(LimpaNumeroDeixandoAVirgula(AllTrim(Form13.StringGrid2.Cells[I,J]))))]));
                end;
              end;
            except end;
            
            try
              Form7.ibDataSet10.Post;
            except
            end;
          end;
        end;
      end;
    end else
    begin
      //ShowMessage('Acerte a diferença de: '+FloatToStr(BaixaQtd)); Mauricio Parizotto 2023-10-25
      MensagemSistema('Acerte a diferença de: '+FloatToStr(BaixaQtd),msgAtencao);
      Abort;
    end;
  except
    Abort
  end;

  // Fiz está rotina no dia do meu aniversário 26/09/2001
  Close;
  Screen.Cursor             := crDefault;              // Cursor de Aguardo
end;

procedure TForm13.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  iMultiplicador, J, I : Integer;
  BaixaQtd : Real;
  rCompraOuVenda : Real;
begin
  BaixaQtd := rQtd - Form7.ibDataSet4QTD_ATUAL.AsFloat - Form1.rReserva;
  rCompraOuVenda  := 0;

  if BaixaQtd < 0 then iMultiplicador := 1 else iMultiplicador := -1;
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
  if Form7.sModulo = 'COMPRA' then
  begin
    Label2.Caption := 'Entrada de: '+ LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[Abs(rCompraOuVenda)]));
  end else
  begin
    if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'OS') then
    begin
      Label2.Caption := 'Saída de: '+ LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[Abs(rCompraOuVenda)]));
    end else
    begin
      if BaixaQtd = 0  then
      begin
        Label2.Caption    := 'Ok';
      end else
      begin
        if BaixaQtd > 0
          then Label2.Caption := 'Saída de: '+ LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[Abs(BaixaQtd)]))
            else Label2.Caption := 'Entrada de: '+ LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[Abs(BaixaQtd)]));
      end;
    end;
  end;
  //
  try
    if StringGrid1.Cells[aCol,aRow] <> '' then
    begin
      if (aCol <> 0) and (aRow <> 0) then
      begin
        if StringGrid1.Cells[aCol,aRow] <> LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))])) then
        begin
          StringGrid1.Cells[aCol,aRow] := LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid1.Cells[aCol,aRow]))]));
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
    StringGrid1.Canvas.Font.Size  := 10;
    StringGrid1.Canvas.Font.Color := clBlack;
    if aCol = 0 then StringGrid1.Canvas.Font.Color := clRed;
    StringGrid1.Canvas.TextOut(Rect.Right - StringGrid1.Canvas.TextWidth(Form13.StringGrid1.Cells[aCol,aRow]) -2 ,Rect.Top+2,  Form13.StringGrid1.Cells[aCol,aRow]);
    //
    if ACol <> 0 then
    begin
      StringGrid1.Canvas.Font.Name  := 'Microsoft Sans Serif';
      StringGrid1.Canvas.Font.Color := clSilver;
      StringGrid1.Canvas.Font.Size  := 8;
      StringGrid1.Canvas.TextOut(Rect.Left+2,Rect.Top+16,AllTrim(Form13.StringGrid2.Cells[aCol,aRow]));
    end;
  end;
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
        if StringGrid2.Cells[aCol,aRow] <> LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid2.Cells[aCol,aRow]))])) then
        begin
          StringGrid2.Cells[aCol,aRow] := LimpaNumeroDeixandoAVirgula( Format('%12.'+Form1.ConfCasas+'n',[StrToFloat(LimpaNumeroDeixandoAVirgula(StringGrid2.Cells[aCol,aRow]))]));
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

procedure TForm13.Button2Click(Sender: TObject);
begin
  if Form7.sModulo = 'ESTOQUE' then Form7.ibDataSet4.Cancel;
  if Form7.sModulo = 'COMPRA' then
  begin
    Form7.bChave := True;
    Form7.ibDataSet23.Delete;
    Form7.bChave := False;
  end;
  if Form7.sModulo = 'VENDA' then
  begin
    Form7.bChave := True;
    Form7.ibDataSet16.Delete;
    Form7.bChave := False;
  end;
  Close;
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
                  {
                  ShowMessage('Não tem '+AllTrim(StrTran(Form13.StringGrid1.Cells[I,J],'-',''))+' '+AllTrim(Form7.ibDataSet4DESCRICAO.AsString)+' '+Form13.StringGrid1.Cells[I,0]+' '+Form13.StringGrid1.Cells[0,J]+' no estoque.'+Chr(10)+
                  'Só tem '+AllTrim(Form13.StringGrid2.Cells[I,J])+'.');
                  Mauricio Parizotto 2023-10-25}
                  MensagemSistema('Não tem '+AllTrim(StrTran(Form13.StringGrid1.Cells[I,J],'-',''))+' '+AllTrim(Form7.ibDataSet4DESCRICAO.AsString)+' '+Form13.StringGrid1.Cells[I,0]+' '+Form13.StringGrid1.Cells[0,J]+' no estoque.'+Chr(10)+
                                  'Só tem '+AllTrim(Form13.StringGrid2.Cells[I,J])+'.'
                                  ,msgAtencao);

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
  Form7.bChaveGrade := False;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  Form1.sGrade := '';
end;

end.


