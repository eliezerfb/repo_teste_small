unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, smallfunc_xe, Buttons, DB;

type
  TForm4 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    procedure FormClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);

  private
    { Private declarations }
  public
    LarguraDoCaracter, AlturaDoCaracter, Comprimido, DivisorDoEspacamento : Integer;
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses Unit7, Mais;

{$R *.DFM}




procedure TForm4.FormClick(Sender: TObject);
var
  I : Integer;
  Component1 : TLabel;
  MyBookmark: TBookmark;
begin
  //
  if Form4.Visible then
  begin
    begin
      for I := ComponentCount -1 downto 0 do
      begin
        if Copy(Components[I].Name,1,5) = 'Recno' then Components[I].Destroy;
      end;
      //
      Form4.HorzScrollBar.Position := 1;
      Form4.VertScrollBar.Position := 1;
      //
      Panel1.Left   := 0;
      Panel1.Top    := 1;
      Panel1.Width  := 10;
      Panel1.Height := 10;
      //
      //
      if (Form7.sModulo = 'CONFOS') or (Form7.sModulo = 'CONFRECIBO') then
      begin
        //
        Form7.ibDataSet119.DisableControls;
        MyBooKMark := Form7.ibDataSet119.GetBookmark;
        //
        Form7.ibDataSet119.First;
        Comprimido           := 7;
        DivisorDoEspacamento := 150;
        //
        while not Form7.ibDataSet119.EOF do
        begin
          //
          if ((Form7.ibDataSet119LINHA.AsFloat + Form7.ibDataSet119COLUNA.AsFloat) <> 0) or (Form7.ibDataSet119LINHA.AsFloat <> 0) then
          begin
            //
            if AllTrim(UpperCase(Form7.ibDataSet119TIPO.AsString)) = '@& CHR(15)' then Comprimido := 4; // Tamanho variável do caracter
            if AllTrim(UpperCase(Form7.ibDataSet119TIPO.AsString)) = '@& CHR(18)' then Comprimido := 7; // Tamanho variável do caracter
            //
            if AllTrim(UpperCase(Form7.ibDataSet119TIPO.AsString)) = '@& CHR(27)+[2]' then DivisorDoEspacamento := 150; // Espaçamento variável 1/6 de linha
            if AllTrim(UpperCase(Form7.ibDataSet119TIPO.AsString)) = '@& CHR(27)+[0]' then DivisorDoEspacamento := 175; // Espaçamento variável 1/8 de linha
            if AllTrim(UpperCase(Form7.ibDataSet119TIPO.AsString)) = '@& CHR(27)+[1]' then DivisorDoEspacamento := 200; // Espaçamento variável 7/72 de linha
            //
            // Fonte
            Component1 := TLabel.Create(Self);
            //
            Component1.Font.Size   := 10;
            Component1.Parent      := Panel1;
            Component1.Transparent := True;
            Component1.visible     := True;
            Component1.Font.Color  := clblack;
            Component1.Font.Color  := clRed;
            Component1.font.Name   := 'Courier New';
            //
            Component1.Font.Size   := Comprimido;
            Canvas.Font.Size       := Component1.Font.Size;   // Tamanho da Fonte
            //
            AlturaDoCaracter       := 12 * 100 div DivisorDoEspacamento; // Define o espaçamento
            if Comprimido = 7 then LarguraDoCaracter := Canvas.TextWidth(Replicate('-',100)) div 60
              else LarguraDoCaracter := Canvas.TextWidth(Replicate('-',100)) div 80;
            //
            //
            Component1.Name        := 'Recno'+AllTrim(IntToStr(Form7.ibDataSet119.Recno));
            Component1.Top         := (Form7.ibDataSet119LINHA.AsInteger * AlTuraDoCaracter) - Comprimido; // - (10 - Comprimido);
            Component1.Left        := (Form7.ibDataSet119COLUNA.AsInteger-1) * LarguraDoCaracter + 20;
            Component1.Transparent := True;
            Component1.visible     := True;
            if Comprimido = 7 then Component1.Font.Color  := clSilver else Component1.Font.Color  := clBlack;
            //
            if Copy(Form7.ibDataSet119TIPO.AsString,1,1) = '9' then
            begin
              try
                //
                Component1.Caption     := Right(Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet119TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.##','0.00'),StrToFloat(StrTran('0'+Form7.ibDataSet119LAYOUT.AsString,'.',''))),length(Alltrim(Form7.ibDataSet119Tipo.Value)));
                //
              except
                Form7.ibDataSet119.Edit;
                Form7.ibDataSet119Tipo.Value := ''
              end;
               // Component1.Caption     := Right(Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet119TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.##','0.00'),StrToFloat(StrTran(Form7.ibDataSet119LAYOUT.AsString,',','')+'0')),length(Alltrim(Form7.ibDataSet119Tipo.Value)));
               // so falta substituir o valor real pelo 3333.3333
               //            Component1.Caption     := Format('%'+IntToStr(Length(AllTrim(Form7.ibDataSet119TIPO.AsString)))+'.2n',[StrToFloat('0'+LimpaNumero(AllTrim(Form7.ibDataSet119LAYOUT.AsString)))/100]);
            end else Component1.Caption := AllTrim(Form7.ibDataSet119LAYOUT.AsString);
            // Texto Fixo
            if Copy(Form7.ibDataSet119TIPO.AsString,1,2) = '@R' then Component1.Caption := Alltrim(Copy(Form7.ibDataSet119TIPO.AsString,3,Length(Form7.ibDataSet119TIPO.AsString)-2));
            if Copy(Form7.ibDataSet119TIPO.AsString,1,2) = '@r' then Component1.Caption := Replicate(Copy(Form7.ibDataSet119TIPO.AsString,4,1),StrToInt('0'+Limpanumero(Copy(Form7.ibDataSet119TIPO.AsString,6,3))));
            // Extenso
            if Copy(Form7.ibDataSet119TIPO.AsString,1,2) = '@E' then
            begin
              Component1.Caption := Copy(AllTrim(Form7.ibDataSet119LAYOUT.AsString)
                             +' '+Replicate('.x',100),StrToInt(Copy(Form7.ibDataSet119TIPO.AsString,4,2))
                               ,StrToInt(Copy(Form7.ibDataSet119TIPO.AsString,6,2)));
            end;
            // Tamanho da página //
            if Copy(Form7.ibDataSet119TIPO.AsString,1,19) = '@& CHR(27)+[C]+CHR(' then
            begin
               Component1.Caption      := Replicate('_',80);
               Component1.Top          := StrToInt('0'+LimpaNumero(Alltrim(Copy(Form7.ibDataSet119TIPO.AsString,19,Length(Form7.ibDataSet119TIPO.AsString)-2)))) * AlTuraDoCaracter;
               Component1.Left         := 0 + 20;
               Component1.Font.Color   := ClSilver;
            end;
            //
            Component1.Hint        := Form7.ibDataSet119DESCRICAO.AsString
                                      + Chr(10)
                                      + Chr(10) + 'Linha: '+FloatToStr(Form7.ibDataSet119LINHA.AsFloat)
                                      + Chr(10) + 'Coluna: '+FloatToStr(Form7.ibDataSet119COLUNA.AsFloat);

            Component1.ShowHint    := True;
            Component1.OnClick     := Label1Click;
            //
            if Panel1.Height < (Component1.Top) then Panel1.Height := Component1.Top + (AlturaDoCaracter * 3);
            //
            if Panel1.Width  < (Component1.Left + Component1.Width) then Panel1.Width := Component1.Left + Component1.Width + 20;
  //          if Panel1.Width  < (82 * LarguraDoCaracter) then Panel1.Width := (82 * LarguraDoCaracter) + 40;
            //
            //
            //
          end;
          Form7.ibDataSet119.Next;
          //
        end;
        Form7.ibDataSet119.GotoBookmark(MyBookmark);
        Form7.ibDataSet119.EnableControls;
      end else
      begin
        Form7.ibDataSet19.DisableControls;
        MyBooKMark := Form7.ibDataSet19.GetBookmark;
        //
        Form7.ibDataSet19.First;
        Comprimido           := 7;
        DivisorDoEspacamento := 150;
        //
        while not Form7.ibDataSet19.EOF do
        begin
          //
          if ((Form7.ibDataSet19LINHA.AsFloat + Form7.ibDataSet19COLUNA.AsFloat) <> 0) or (Form7.ibDataSet19LINHA.AsFloat <> 0) then
          begin
            //
            if AllTrim(UpperCase(Form7.ibDataSet19TIPO.AsString)) = '@& CHR(15)' then Comprimido := 4; // Tamanho variável do caracter
            if AllTrim(UpperCase(Form7.ibDataSet19TIPO.AsString)) = '@& CHR(18)' then Comprimido := 7; // Tamanho variável do caracter
            //
            if AllTrim(UpperCase(Form7.ibDataSet19TIPO.AsString)) = '@& CHR(27)+[2]' then DivisorDoEspacamento := 150; // Espaçamento variável 1/6 de linha
            if AllTrim(UpperCase(Form7.ibDataSet19TIPO.AsString)) = '@& CHR(27)+[0]' then DivisorDoEspacamento := 175; // Espaçamento variável 1/8 de linha
            if AllTrim(UpperCase(Form7.ibDataSet19TIPO.AsString)) = '@& CHR(27)+[1]' then DivisorDoEspacamento := 200; // Espaçamento variável 7/72 de linha
            //
            // Fonte
            Component1 := TLabel.Create(Self);
            //
            Component1.Font.Size   := 10;
            Component1.Parent      := Panel1;
            Component1.Transparent := True;
            Component1.visible     := True;
            Component1.Font.Color  := clblack;
            Component1.Font.Color  := clRed;
            Component1.font.Name   := 'Courier New';
            //
            Component1.Font.Size   := Comprimido;
            Canvas.Font.Size       := Component1.Font.Size;   // Tamanho da Fonte
            //
            AlturaDoCaracter       := 12 * 100 div DivisorDoEspacamento; // Define o espaçamento
            if Comprimido = 7 then LarguraDoCaracter := Canvas.TextWidth(Replicate('-',100)) div 60
              else LarguraDoCaracter := Canvas.TextWidth(Replicate('-',100)) div 80;
            //
            //
            Component1.Name        := 'Recno'+AllTrim(IntToStr(Form7.ibDataSet19.Recno));
            Component1.Top         := (Form7.ibDataSet19LINHA.AsInteger * AlTuraDoCaracter) - Comprimido; // - (10 - Comprimido);
            Component1.Left        := (Form7.ibDataSet19COLUNA.AsInteger-1) * LarguraDoCaracter + 20;
            Component1.Transparent := True;
            Component1.visible     := True;
            if Comprimido = 7 then Component1.Font.Color  := clSilver else Component1.Font.Color  := clBlack;
            //
            if Copy(Form7.ibDataSet19TIPO.AsString,1,1) = '9' then
            begin
              try
                //
                Component1.Caption     := Right(Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.##','0.00'),StrToFloat(StrTran('0'+Form7.ibDataSet19LAYOUT.AsString,'.',''))),length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                //
              except
                Form7.ibDataSet19.Edit;
                Form7.ibDataSet19Tipo.Value := ''
              end;
               // Component1.Caption     := Right(Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.##','0.00'),StrToFloat(StrTran(Form7.ibDataSet19LAYOUT.AsString,',','')+'0')),length(Alltrim(Form7.ibDataSet19Tipo.Value)));
               // so falta substituir o valor real pelo 3333.3333
               //            Component1.Caption     := Format('%'+IntToStr(Length(AllTrim(Form7.ibDataSet19TIPO.AsString)))+'.2n',[StrToFloat('0'+LimpaNumero(AllTrim(Form7.ibDataSet19LAYOUT.AsString)))/100]);
            end else Component1.Caption := AllTrim(Form7.ibDataSet19LAYOUT.AsString);
            // Texto Fixo
            if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@R' then Component1.Caption := Alltrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2));
            if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@r' then Component1.Caption := Replicate(Copy(Form7.ibDataSet19TIPO.AsString,4,1),StrToInt('0'+Limpanumero(Copy(Form7.ibDataSet19TIPO.AsString,6,3))));
            // Extenso
            if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@E' then
            begin
              Component1.Caption := Copy(AllTrim(Form7.ibDataSet19LAYOUT.AsString)
                             +' '+Replicate('.x',100),StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,4,2))
                               ,StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,6,2)));
            end;
            // Tamanho da página //
            if Copy(Form7.ibDataSet19TIPO.AsString,1,19) = '@& CHR(27)+[C]+CHR(' then
            begin
               Component1.Caption      := Replicate('_',80);
               Component1.Top          := StrToInt('0'+LimpaNumero(Alltrim(Copy(Form7.ibDataSet19TIPO.AsString,19,Length(Form7.ibDataSet19TIPO.AsString)-2)))) * AlTuraDoCaracter;
               Component1.Left         := 0 + 20;
               Component1.Font.Color   := ClSilver;
            end;
            //
            Component1.Hint        := Form7.ibDataSet19DESCRICAO.AsString
                                      + Chr(10)
                                      + Chr(10) + 'Linha: '+FloatToStr(Form7.ibDataSet19LINHA.AsFloat)
                                      + Chr(10) + 'Coluna: '+FloatToStr(Form7.ibDataSet19COLUNA.AsFloat);

            Component1.ShowHint    := True;
            Component1.OnClick     := Label1Click;
            //
            if Panel1.Height < (Component1.Top) then Panel1.Height := Component1.Top + (AlturaDoCaracter * 3);
            //
            if Panel1.Width  < (Component1.Left + Component1.Width) then Panel1.Width := Component1.Left + Component1.Width + 20;
  //          if Panel1.Width  < (82 * LarguraDoCaracter) then Panel1.Width := (82 * LarguraDoCaracter) + 40;
            //
            //
            //
          end;
          Form7.ibDataSet19.Next;
          //
        end;
        //
        Form7.ibDataSet19.GotoBookmark(MyBookmark);
        Form7.ibDataSet19.EnableControls;
        //
      end;
    end;
  end;
end;


procedure TForm4.Label1Click(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Form7.ibDataSet19.DisableControls;
    Form7.ibDataSet19.First;
    while (not Form7.ibDataSet19.EOF) and (AllTrim(Form7.ibDataSet19DESCRICAO.AsString) <> Copy(Hint,1,Pos(Chr(10),Hint)-1)) do Form7.ibDataSet19.Next;
    Form7.ibDataSet19.EnableControls;
    Form7.DBGrid1.SetFocus;
  end;
end;


procedure TForm4.FormActivate(Sender: TObject);
begin
//  ScrollBox1.Color     := Form4.Color;
end;

procedure TForm4.Panel1DblClick(Sender: TObject);
begin
  if Form4.Top <> 0 then
  begin
    Form4.Top    := 0;
    Form4.Left   := 0;
    Form4.Height := Form1.Height;
    Form4.Width  := Form1.Width;
    Panel1.Top   := 10;
    Panel1.Left  := (Form1.Width - Panel1.Width) div 2;
  end else
  begin
    Form4.Top            := Form7.Top;
    Form4.Left           := Form7.Left + Form7.Width + 10;
    Form4.Width          := Screen.Width - Form4.Left;
    Form4.Height         := Form7.Height;
    Panel1.Top           := 0;
    Panel1.Left          := 0;
  end;
end;

end.

