// unit desdobramento parcelas
unit Unit18;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, Unit7, SmallFunc,
  ExtCtrls, DB, ShellApi, IniFiles, Buttons;

type
    TForm18 = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    DBGrid1: TDBGrid;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Button4: TBitBtn;
    Panel9: TPanel;
    Label45: TLabel;
    CheckBox1: TCheckBox;
    procedure SMALL_DBEdit1Exit(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure SMALL_DBEdit16KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label10MouseLeave(Sender: TObject);
    procedure Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    sConta : String;
//    bDesdobra : boolean;
    { Public declarations }
  end;

var
  Form18: TForm18;

implementation

uses Unit12, Mais, unit24, Unit19, Unit43, Unit25, Unit16, Unit22, Unit3;

{$R *.DFM}


procedure TForm18.SMALL_DBEdit1Exit(Sender: TObject);
Var
  I : Integer;
  dDiferenca : Double;
begin
  //
  ShortDateFormat := 'dd/mm/yyyy';
  //
  try
    //
    if Form7.sModulo = 'CLIENTES' then
    begin
      //
      // Cria as duplicatas
      // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //
      //
      I := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        I := I + 1;
        Form7.ibDataSet7.Next;
      end;
      //
      if I <> Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) then
      begin
        //
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
        //
        for I := 1 to Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) do
        begin
          //
          Form7.ibDataSet7.Append;
          Form7.ibDataSet7NUMERONF.AsString                          := Form7.ibDataSet15NUMERONF.AsString;
          Form7.ibDataSet7DOCUMENTO.Value                            := 'RE'+Right(Form7.ibDataSet15NUMERONF.AsString,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
          Form7.ibDataSet7VALOR_DUPL.AsFloat                         := Arredonda((Form7.ibDataSet15TOTAL.AsFloat) / Form7.ibDataSet15DUPLICATAS.AsFloat,2);
//          Form7.ibDataSet7VALOR_DUPL.AsFloat                         := StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
          Form7.ibDataSet7HISTORICO.Value                            := 'CODIGO DO ACORDO '+Form7.ibDataSet15NUMERONF.AsString;
          Form7.ibDataSet7EMISSAO.asDateTime                         := Date;
          Form7.ibDataSet7NOME.Value                                 := Form7.ibDataSet2NOME.Value;
          Form7.ibDataSet7CONTA.AsString                             := sConta;
          //
          if I = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.MaskEdit4.Text)));
          if I = 2 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.MaskEdit5.Text)));
          if I = 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.MaskEdit6.Text)));
          if I > 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.MaskEdit6.Text))+((StrToInt(AllTrim(Form19.MaskEdit6.Text))-StrToInt(AllTrim(Form19.MaskEdit5.Text)))*(I-3)));
          //
          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;
          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;
          //
          Form7.ibDataSet7.Post;
          //
        end;
        //
        // Valor quebrado
        //
        dDiferenca := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
          Form7.ibDataSet7.Next;
        end;
        //
        Form7.ibDataSet7.First;
        Form7.ibDataSet7.Edit;
        if dDiferenca <> 0 then
          Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca;
        //
      end;
      //
    end;
    //
    Form7.ibDataSet7.First;
    //
  except end;
  //
  try
    //
    if Form7.sModulo = 'VENDA' then // Ok
    begin
      //
      // RECEBER
      //
      Form7.ibDataSet15.Edit;
      //
      if Form7.ibDataSet15.Modified then
      begin
         Form7.ibDataSet15.Post;
         Form7.ibDataSet15.Edit;
      end;
      //
      // Cria as duplicatas
      // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //
      //
      I := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        I := I + 1;
        Form7.ibDataSet7.Next;
      end;
      //
      if I <> Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) then
      begin
        //
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
        //
        for I := 1 to Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) do
        begin
          //
          Form7.ibDataSet7.Append;
          Form7.ibDataSet7NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;
          //
          if Form7.sRPS <> 'S' then
          begin
            if Copy(Form7.ibDataSet15NUMERONF.AsString,10,3) = '002' then
            begin
              Form7.ibDataSet7DOCUMENTO.Value := 'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,2,8) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
            end else
            begin
              Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
            end;
          end else
          begin
            Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,1)+'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,3,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
          end;
          //
          Form7.ibDataSet7VALOR_DUPL.AsFloat          := Arredonda((Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR) / Form7.ibDataSet15DUPLICATAS.AsFloat,2);;
          //
          if Form7.sRPS <> 'S' then
          begin
            Form7.ibDataSet7HISTORICO.Value := 'NFE NAO AUTORIZADA';
          end else
          begin
            Form7.ibDataSet7HISTORICO.AsString := 'RPS número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9);
          end;
          //
          Form7.ibDataSet7EMISSAO.asDateTime    := Form7.ibDataSet15EMISSAO.AsDateTime;
          Form7.ibDataSet7NOME.Value            := Form7.ibDataSet15CLIENTE.Value;
          Form7.ibDataSet7CONTA.AsString        := sConta;
          if I = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit4.Text)));
          if I = 2 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit5.Text)));
          if I = 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit6.Text)));
          if I > 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit6.Text))+
              ((StrToInt(AllTrim(Form19.MaskEdit6.Text))
               -StrToInt(AllTrim(Form19.MaskEdit5.Text)))*(I-3)));
          //
          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;
          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;
          //
          Form7.ibDataSet7.Post;
          //
        end;
        //
        // Valor quebrado
        //
        dDiferenca := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
          Form7.ibDataSet7.Next;
        end;
        //
        Form7.ibDataSet7.First;
        Form7.ibDataSet7.Edit;
        if dDiferenca <> 0 then
          Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca;
        //
      end;
      //
      Form7.ibDataSet7.First;
      //
    end;
  except
  end;
  //
  try
    //
    if Form7.sModulo = 'COMPRA' then
    begin
      //
      // PAGAR
      //
      if Form7.ibDataSet24.Modified then
      begin
         Form7.ibDataSet24.Post;
         Form7.ibDataSet24.Edit;
      end;
      //
      // Cria as duplicatas
      // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //
      //
      I := 0;
      Form7.ibDataSet8.First;
      while not Form7.ibDataSet8.Eof do
      begin
        I := I + 1;
        Form7.ibDataSet8.Next;
      end;
      //
      if I <> Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat) then
      begin
        //
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
        begin
          Form7.ibDataSet8.Delete;
          Form7.ibDataSet8.First;
        end;
        //
        for I := 1 to Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat) do
        begin
          //
          Form7.ibDataSet8.Append;
          Form7.ibDataSet8NUMERONF.AsString   := Form7.ibDataSet24NUMERONF.AsString;
          Form7.ibDataSet8DOCUMENTO.Value     := Copy(Form7.ibDataSet24NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
          Form7.ibDataSet8VALOR_DUPL.AsFloat  := Form7.ibDataSet24TOTAL.AsFloat / Form7.ibDataSet24DUPLICATAS.AsFloat;
          Form7.ibDataSet8VALOR_DUPL.AsFloat  := StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
          Form7.ibDataSet8HISTORICO.Value     := 'Nota Fiscal: '+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9);
          Form7.ibDataSet8EMISSAO.asDateTime  := Form7.ibDataSet24EMISSAO.AsDateTime;
          Form7.ibDataSet8NOME.Value          := Form7.ibDataSet24FORNECEDOR.AsString;
          Form7.ibDataSet8CONTA.AsString      := sConta;
          if I = 1 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit4.Text)));
          if I = 2 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit5.Text)));
          if I = 3 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit6.Text)));
          if I > 3 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.MaskEdit6.Text))+
              ((StrToInt(AllTrim(Form19.MaskEdit6.Text))
               -StrToInt(AllTrim(Form19.MaskEdit5.Text)))*(I-3)));
          Form7.ibDataSet8.Post;
          //
        end;
        //
        // Valor quebrado
        //
        dDiferenca := Form7.ibDataSet24TOTAL.AsFloat;
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
        begin
          dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
          Form7.ibDataSet8.Next;
        end;
        //
        Form7.ibDataSet8.First;
        Form7.ibDataSet8.Edit;
        if dDiferenca <> 0 then
          Form7.ibDataSet8VALOR_DUPL.AsFloat := Form7.ibDataSet8VALOR_DUPL.AsFloat + ddiferenca;
      end;
      //
      Form7.ibDataSet8.First;
    end;
  except
  end;
  //
  /////////////
  // the end //
  /////////////
end;

procedure TForm18.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  dDiferenca : Double;
  MyBookmark: TBookmark;
  iRegistro, iDuplicatas: Integer;
begin
  //
  try
    if Key = chr(46) then
      Key := chr(44);
    if (Key = chr(13)) or (Key = Chr(9) ) then
    begin
      //
      if Form7.sModulo = 'CLIENTES' then
      begin
        MyBookmark  := Form7.ibDataSet7.GetBookmark;
        if AllTrim(Form7.ibDataSet7DOCUMENTO.AsString) = '' then
          Button4.SetFocus
        else
        begin
          //
          iRegistro   := Form7.ibDataSet7.Recno;
          ddiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
          iDuplicatas := Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat);
          //
          Form7.ibDataSet7.DisableControls;
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            if Form7.ibDataSet7.Recno <= iRegistro then
            begin
              iDuplicatas := iDuplicatas - 1;
              dDiferenca := dDiferenca - Form7.ibDataSet7VALOR_DUPL.Value;
            end else
            begin
             Form7.ibDataSet7.Edit;
             Form7.ibDataSet7VALOR_DUPL.AsFloat := dDiferenca / iDuplicatas;
             Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
            end;
            Form7.ibDataSet7.Next;
          end;
          //
          ddiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
            Form7.ibDataSet7.Next;
          end;
          //
          Form7.ibDataSet7.First;
          Form7.ibDataSet7.Edit;
          if dDiferenca <> 0 then
            Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca;
          //
          Form7.ibDataSet7.GotoBookmark(MyBookmark);
          Form7.ibDataSet7.FreeBookmark(MyBookmark);
          Form7.ibDataSet7.EnableControls;
          //
        end;
      end;
      //
      if Form7.sModulo = 'VENDA' then // Ok
      begin
        MyBookmark  := Form7.ibDataSet7.GetBookmark;
        if AllTrim(Form7.ibDataSet7DOCUMENTO.AsString) = '' then
          Button4.SetFocus
        else
        begin
          //
          iRegistro   := Form7.ibDataSet7.Recno;
          ddiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
          iDuplicatas := Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat);
          //
          Form7.ibDataSet7.DisableControls;
  //        Dbgrid1.Enabled := false;
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            if Form7.ibDataSet7.Recno <= iRegistro then
            begin
              iDuplicatas := iDuplicatas - 1;
              dDiferenca := dDiferenca - Form7.ibDataSet7VALOR_DUPL.Value;
            end else
            begin
              Form7.ibDataSet7.Edit;
              Form7.ibDataSet7VALOR_DUPL.AsFloat := dDiferenca / iDuplicatas;
              Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
            end;
            Form7.ibDataSet7.Next;
          end;
          //
          ddiferenca  := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
            Form7.ibDataSet7.Next;
          end;
          //
          Form7.ibDataSet7.First;
          Form7.ibDataSet7.Edit;
          if dDiferenca <> 0 then Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca;
          //
          Form7.ibDataSet7.GotoBookmark(MyBookmark);
          Form7.ibDataSet7.FreeBookmark(MyBookmark);
          Form7.ibDataSet7.EnableControls;
  //        Dbgrid1.Enabled := True;
          //
        end;
      end;
      //
      if Form7.sModulo = 'COMPRA' then
      begin
        MyBookmark  := Form7.ibDataSet8.GetBookmark;
        if AllTrim(Form7.ibDataSet8DOCUMENTO.AsString) = '' then
          Button4.SetFocus
        else
        begin
          //
          iRegistro   := Form7.ibDataSet8.Recno;
          ddiferenca  := Form7.ibDataSet24TOTAL.Value;
          iDuplicatas := Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat);
          //
          Form7.ibDataSet8.DisableControls;
  //        Dbgrid1.Enabled := false;
          Form7.ibDataSet8.First;
          while not Form7.ibDataSet8.Eof do
          begin
            if Form7.ibDataSet8.Recno <= iRegistro then
            begin
              iDuplicatas := iDuplicatas - 1;
              dDiferenca := dDiferenca - Form7.ibDataSet8VALOR_DUPL.Value;
            end else
            begin
             Form7.ibDataSet8.Edit;
             Form7.ibDataSet8VALOR_DUPL.AsFloat := dDiferenca / iDuplicatas;
             Form7.ibDataSet8VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
            end;
            Form7.ibDataSet8.Next;
          end;
          //
          ddiferenca  := Form7.ibDataSet24TOTAL.Value;
          Form7.ibDataSet8.First;
          while not Form7.ibDataSet8.Eof do
          begin
            dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
            Form7.ibDataSet8.Next;
          end;
          //
          Form7.ibDataSet8.First;
          Form7.ibDataSet8.Edit;
          if dDiferenca <> 0 then
            Form7.ibDataSet8VALOR_DUPL.AsFloat := Form7.ibDataSet8VALOR_DUPL.AsFloat + ddiferenca;
          //
          Form7.ibDataSet8.GotoBookmark(MyBookmark);
          Form7.ibDataSet8.FreeBookmark(MyBookmark);
          Form7.ibDataSet8.EnableControls;
  //        Dbgrid1.Enabled := True;
          //
        end;
      end;
    end;
  except

  end;

end;

procedure TForm18.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP then Perform(Wm_NextDlgCtl,-1,0);
    if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  except end;

end;

procedure TForm18.SMALL_DBEdit1Enter(Sender: TObject);
var
  Total : Real;
begin
  //
  try
    //
    if Form7.sModulo = 'CLIENTES' then // Ok
    begin
      Total := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
        Form7.ibDataSet7.Next;
      end;
      //
      if (Abs(Total - Form7.ibDataSet15TOTAL.AsFloat) > 0.01) and (Total<>0) then
      begin
        //
        ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da renegociação. As parcelas serão recalculadas.');
        //
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
        //
        SMALL_DBEdit1Exit(Sender);
        //
      end;
    end;
    //
    if Form7.sModulo = 'VENDA' then // Ok
    begin
      Total := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
        Form7.ibDataSet7.Next;
      end;
      //
      if (Abs(Total - (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) > 0.01) and (Total<>0) then
      begin
        ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.');
        //
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
        SMALL_DBEdit1Exit(Sender);
        //
      end;
    end;
    //
    //
    if Form7.sModulo = 'COMPRA' then
    begin
      //
      Total := 0;
      Form7.ibDataSet8.First;
      while not Form7.ibDataSet8.Eof do
      begin
        Total := Total + Form7.ibDataSet8VALOR_DUPL.AsFloat;
        Form7.ibDataSet8.Next;
      end;
      //
      if (Abs(Total - Form7.ibDataSet24TOTAL.AsFloat) > 0.01) and (Total<>0) then
      begin
        //
        ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.');
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do Form7.ibDataSet8.Delete;
        SMALL_DBEdit1Exit(Sender);
        //
      end;
      //
    end;
    //
    DbGrid1.Update;
    //
  except end;
  //
end;

procedure TForm18.SMALL_DBEdit16KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP then Perform(Wm_NextDlgCtl,-1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  except end;

end;

procedure TForm18.Label10MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm18.Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm18.FormShow(Sender: TObject);
var
  Total : Real;
  I, J : Integer;
  Mais1Ini : tIniFile;
  sSecoes :  TStrings;
begin
  //
  // ShowMessage(Form7.ibDataSet15TOTAL.AsString);
  //
  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
  begin
    //
    Total := 0;
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
       Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
       Form7.ibDataSet7.Next;
     end;
     //
     if (Abs(Total - Form7.ibDataSet15TOTAL.AsFloat) > 0.01) then
     begin
       Form18.SMALL_DBEdit1.Enabled := True;
       Form18.DBGrid1.Enabled       := True;
     end else
     begin
       Form18.SMALL_DBEdit1.Enabled := False;
       Form18.DBGrid1.Enabled       := False;
     end;
     //
     Label45.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
     //
  end else
  begin
    Form18.SMALL_DBEdit1.Enabled := True;
    Form18.DBGrid1.Enabled       := True;
  end;
  //
  try
    //
    if AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString) = 'CAIXA' then Form18.Close; // else if Alltrim(SMALL_DBEdit1.Text) = '' then SMALL_DBEdit1.Text := '1';
    //
    if SMALL_DBEdit1.CanFocus then
    begin
      SMALL_DBEdit1.SetFocus;
      SMALL_DBEdit1.SelectAll;
    end;
    //
    if (AllTrim(Form7.ibDataSet14CONTA.AsString) = '') then
    begin
      Form7.ibDataSet12.First;
  //    if bDesdobra then
      if Form7.SModulo <> 'CLIENTES' then  // Ok
      begin
        Form43.ShowModal; // OK
        sConta := Form7.ibDataSet12NOME.AsString;
      end else
      begin
        sConta := '';
      end;
    end else sConta := Form7.ibDataSet14CONTA.AsString;
    //
    Panel9.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];
    //
    if (Form7.sModulo <> 'VENDA') and (Form7.sModulo <> 'COMPRA') and (Form7.sModulo <> 'CLIENTES') then Form7.sModulo := 'VENDA';
    //
    CheckBox1.Visible := False;
    //
    if Form7.SModulo = 'CLIENTES' then  // Ok
    begin
      //
      Form7.ibQuery1.Close;
      Form7.IBQuery1.SQL.Clear;
      Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=9 where coalesce(ATIVO,9)<>1 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and VALOR_RECE=0');
      Form7.IBQuery1.Open;
      //
      CheckBox1.Visible := False;
      //
      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do  Form7.ibDataSet7.Fields[I-1].Visible := False;
      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;
      Label45.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
      SMALL_DBEdit1.DataSource := Form7.DataSource15;
      // ***********************************
      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      // ***********************************
      ComboBox1.Items.Clear;
      ComboBox1.Items.Add('<Não imprimir documento>');
      //
      try
        //
        sSecoes := TStringList.Create;
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        Mais1Ini.ReadSections(sSecoes);
        //
        for J := 0 to (sSecoes.Count - 1) do
        begin
          if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
          begin
            ComboBox1.Items.Add(sSecoes[J]);
          end;
        end;
        //
        Mais1Ini.Free;
        //
      except end;
      //
      ComboBox1.Items.Add('<Imprimir Duplicata>');
      ComboBox1.Items.Add('<Imprimir Carnê>');
      //
      Combobox1.Visible   := True;
      Combobox1.ItemIndex := 0;
      Label7.Visible      := True;
      //
      dbGrid1.DataSource := Form7.DataSource7;
      //
      if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;
      //
    end;
    //
    if Form7.SModulo = 'VENDA' then // Ok
    begin
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then CheckBox1.Checked := True else  CheckBox1.Checked := False;
      Mais1Ini.Free;
      //
      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do  Form7.ibDataSet7.Fields[I-1].Visible := False;
      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;
      Label45.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)]);
      SMALL_DBEdit1.DataSource := Form7.DataSource15;
      // ***********************************
      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      // ***********************************
      ComboBox1.Items.Clear;
      ComboBox1.Items.Add('<Não imprimir documento>');
      //
      try
        //
        sSecoes := TStringList.Create;
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        Mais1Ini.ReadSections(sSecoes);
        //
        for J := 0 to (sSecoes.Count - 1) do
        begin
          if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
          begin
            ComboBox1.Items.Add(sSecoes[J]);
          end;
        end;
        //
        Mais1Ini.Free;
        //
      except end;
      //
      ComboBox1.Items.Add('<Imprimir Duplicata>');
      ComboBox1.Items.Add('<Imprimir Carnê>');
      //
      Combobox1.Visible   := True;
      Combobox1.ItemIndex := 0;
      Label7.Visible      := True;
      //
      dbGrid1.DataSource := Form7.DataSource7;
      if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;
      //
    end;
    //
    if Form7.SModulo = 'COMPRA' then
    begin
      //
      Combobox1.Visible := False;
      Label7.Visible    := False;
      //
      Form7.ibDataSet8.EnableControls;
      for I := 1 to Form7.ibDataSet8.FieldCount do  Form7.ibDataSet8.Fields[I-1].Visible := False;
      Form7.ibDataSet8DOCUMENTO.Visible  := True;
      Form7.ibDataSet8VENCIMENTO.Visible := True;
      Form7.ibDataSet8VALOR_DUPL.Visible := True;
      Form7.ibDataSet8PORTADOR.Visible   := True;
      //
      Label45.Caption := Format('%12.2n',[Form7.ibDataSet24TOTAL.AsFloat]);
      SMALL_DBEdit1.DataSource := Form7.DataSource24;
      dbGrid1.DataSource := Form7.DataSource8;
      //
      if Form7.ibDataSet24DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet24.Edit;
        Form7.ibDataSet24DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet24.Post;
      end;
    end;
    //
    if SMALL_DBEdit1.CanFocus then
    begin
      SMALL_DBEdit1.SetFocus;
      SMALL_DBEdit1.SelectAll;
    end;
    //
    Form18.SMALL_DBEdit1Exit(Sender);
    //
  except end;
  //
end;

procedure TForm18.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  OldBkMode : Integer;
  xRect : tREct;
begin
  //
  try
  if Field.Name = 'ibDataSet7VENCIMENTO' then
  begin
    dbGrid1.Canvas.Brush.Color := clWhite;
    dbGrid1.Canvas.Font := dbGrid1.Font;
    if (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7) then DBGrid1.Canvas.Font.Color   := clRed else DBGrid1.Canvas.Font.Color   := clBlack;
    dbGrid1.Canvas.TextOut(Rect.Left+dbGrid1.Canvas.TextWidth('99/99/9999_'),Rect.Top+2,Copy(DiaDaSemana(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,3) );
  end;
  //
  dbGrid1.Canvas.Brush.Color := Form7.Panel7.Color;
  dbGrid1.Canvas.Pen.Color   := clRed;
  //
  xRect.Left   := REct.Left;
  xRect.Top    := -1;
  xRect.Right  := Rect.Right;
  xRect.Bottom := Rect.Bottom - Rect.Top + 0;
  //
  dbGrid1.Canvas.FillRect(xRect);
  //
  //
  with dbgrid1.Canvas do
  begin
    OldBkMode := SetBkMode(Handle, TRANSPARENT);
    dbgrid1.Canvas.Font := dbgrid1.TitleFont;
    TextOut(Rect.Left+2,2,AllTrim(Field.DisplayLabel));
    dbgrid1.Canvas.Font.Color := clblack;
    SetBkMode(Handle, OldBkMode);
  end;
  except end;
  //
end;

procedure TForm18.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  try
    if (Key = VK_RETURN) then
    begin
      I := DbGrid1.SelectedIndex;
      DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
      if I = DbGrid1.SelectedIndex  then
      begin
        DbGrid1.SelectedIndex := 0;
        dBgrid1.DataSource.DataSet.Next;
        if dBgrid1.DataSource.DataSet.EOF then Button4.SetFocus;
      end;
    end;
  except end;
end;

procedure TForm18.DBGrid1ColEnter(Sender: TObject);
begin
  try
  if (Form7.sModulo = 'VENDA') and (DbGrid1.SelectedIndex = 0) then DbGrid1.SelectedIndex := 1;
  except end;
end;

procedure TForm18.DBGrid1Enter(Sender: TObject);
begin
  DbGrid1.SelectedIndex := 1;
end;

procedure TForm18.Button4Click(Sender: TObject);
begin
  Form18.Close;
end;

procedure TForm18.CheckBox1Click(Sender: TObject);
var
  Mais1ini : tInifile;
begin
  //
try
  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  if CheckBox1.Checked then
  begin
    Mais1Ini.WriteString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Sim');
  end else
  begin
    Mais1Ini.WriteString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não');
  end;
  Mais1Ini.Free;
  except end;
  //
end;

procedure TForm18.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini : tIniFile;
  bButton : Integer;
  F : TextFile;
  I : Integer;
  sSenhaX, sSenha : String;
  ftotal1 : Real;
  Total : Real;
begin
  //
  if Form7.sModulo = 'VENDA' then // Ok
  begin
    Total := 0;
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
      Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
      Form7.ibDataSet7.Next;
    end;
    //
    if (Abs(Total - (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) > 0.01) and (Total<>0) then
    begin
      //
      ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.');
      //
      SMALL_DBEdit1.SetFocus;
      Abort;
      //
    end;
  end;
  //
  try
    Form18.Close;
    //
    if Form7.sModulo = 'CLIENTES' then
    begin
      //
      // ACORDO
      //
      Form7.sTextoDoAcordo := 'TERMO DE RENEGOCIAÇÃO DE DÍVIDA '+Form7.ibDataSet15NUMERONF.AsString+chr(13)+chr(10)+chr(13)+chr(10)+
                              'Na presente data ('+DateToStr(Date)+') é regido o acordo de novação de dívida entre a empresa ('+Form7.ibDataSet13NOME.AsString+') '+
                              'sendo assim pessoa jurídica de direito privado, inscrita no CNPJ ('+Form7.ibDataSet13CGC.AsString+'), com sede em ('+
                              Form7.ibDataSet13MUNICIPIO.AsString +', '+ Form7.ibDataSet13ESTADO.AsString +'). '+
                              'Do outro lado o devedor ('+Form7.ibDataset2NOME.AsString+'), portador do CPF/CNPJ ('+Form7.ibDataset2CGC.AsString+
                              '), residente e domiciliado em ('+Form7.ibDataset2CIDADE.AsString+'-'+Form7.ibDataSet2ESTADO.AsString +'). '+
                              'O Devedor declara e se confessa devedor, nesta data, da importância de R$ '+
                              AllTrim(Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet15TOTAL.AsFloat]))+' ('+AllTrim(Extenso(Form7.ibDataSet15TOTAL.AsFloat))+'). '+
                              'Referente a parcelas anteriormente acordadas em aberto conforme tabelas abaixo:'+chr(13)+chr(10)+chr(13)+chr(10)+
                              Form7.sTextoDoAcordo+chr(13)+chr(10)+
                              'Afim da regularização do débito ambas as partes decidem celebrar o seguinte acordo. '+
                              'O Credor, pretendendo reaver o seu crédito, compromete-se a parcelar o valor desta dívida, '+
                              'devidamente corrigido com a respectiva atualização, a contar do vencimento combinado entre '+
                              'ambos, o devedor, por sua vez, aceita a presente novação, obrigando-se a efetuar os pagamentos '+
                              'nas condições e formas descritas neste documento. '+chr(13)+chr(10)+
                              'O Devedor pagará ao Credor ('+Form7.ibDataSet15DUPLICATAS.AsString+') parcela(s) conforme tabela abaixo. '+chr(13)+chr(10)+chr(13)+chr(10)+
                              'Parcela    Vencimento   Valor R$'+chr(13)+chr(10)+
                              '---------- ------------ -------------'+chr(13)+chr(10);
      //
      // Zeresima
      //
      fTotal1 := 0;
      //
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
         Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+chr(13)+chr(10);
         ftotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
         Form7.ibDataSet7.Next;
      end;
      //
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                              '                        -------------'+chr(13)+chr(10)+
                              '                      '+Format('%15.2n',[ftotal1])+chr(13)+chr(10);
      //
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
      chr(13)+chr(10)+
      'O Devedor efetuará o pagamento na data de vencimento de cada parcela conforme combinado entre ambas as partes. '+
      'Estando ciente o devedor que no caso de inadimplemento de uma ou mais parcelas, terá o devedor seu nome inscrito no Serviço de Proteção ao Crédito. '+
      'Este termo de renegociação de dívida passa a valer a partir da comprovação do pagamento da primeira parcela. A divida total sera considerada quitada mediante o pagamento pontual de todas as parcelas. '+
      'Fica eleito o foro da cidade de '+Form7.ibDataSet13MUNICIPIO.AsString +', '+ Form7.ibDataSet13ESTADO.AsString +' para dirimir dúvidas a respeito do presente Termo de Renegociação de Dívida, renunciando qualquer outro foro por mais especial e privilegiado que seja. '+
      'E por se acharem justo e pactuados, conforme os termos e condições aqui estabelecidas, firmam o presente Termo de Renegociação de Dívida em duas vias de igual teor.'+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de ' + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de ' + Copy(DateTimeToStr(Date),7,4)+chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      Form7.ibDataSet13NOME.AsString+chr(13)+chr(10)+
      Form7.ibDataSet13CGC.AsString+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      Form7.ibDataset2NOME.AsString+chr(13)+chr(10)+
      Form7.ibDataset2CGC.AsString+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+
      //
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      'TESTEMUNHA COM CPF'+chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      'TESTEMUNHA COM CPF';

      AssignFile(F,pchar('ACORDO'+Form7.ibDataSet15NUMERONF.AsString+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
      Rewrite(F);                  // Abre para gravação
      WriteLn(F,Form7.sTextoDoAcordo);
      CloseFile(F); // Fecha o arquivo
      ShellExecute( 0, 'Open',pchar('ACORDO'+Form7.ibDataSet15NUMERONF.AsString+'.txt'),'','', SW_SHOWMAXIMIZED);
      //
      // THE END ACORDO
      //
      bButton := Application.MessageBox(Pchar('Confirma a renegociação?'),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);
      //
      if bButton = IDYES then
      begin
        Form22.Show;
        Form22.Label6.Caption := '';
        Form22.Label6.Width   := Screen.Width;
        Form22.Label6.Repaint;
        Senhas2.ShowModal;
        Form22.Close;
        Senha2:=Senhas2.SenhaPub2;
        Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
        sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
        sSenha := '';
        // ----------------------------- //
        // Fórmula para ler a nova senha //
        // ----------------------------- //
        for I := 1 to (Length(sSenhaX) div 5) do
          sSenha := Chr((StrToInt(
                        Copy(sSenhaX,(I*5)-4,5)
                        )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
        // ----------------------------- //
        if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
        begin
          //
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set PORTADOR='+QuotedStr('ACORDO '+Form7.ibDataSet15NUMERONF.AsString)+' where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;
          //
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=1 where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;
          //
          Form7.IBDataSet2.Edit;
          Form7.IBDataSet2MOSTRAR.AsFloat := 0;
          //
        end else
        begin
          //
          // Volta tudo
          //
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;
          //
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            Form7.ibDataSet7.Delete;
            Form7.ibDataSet7.First;
          end;
          //
        end;
      end else
      begin
        //
        // Volta tudo
        //
        Form7.ibQuery1.Close;
        Form7.IBQuery1.SQL.Clear;
        Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
        Form7.IBQuery1.Open;
        //
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
        //
      end;
    end;
    //
    if Form7.sModulo = 'VENDA' then
    begin
      //
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then Form18.CheckBox1.Checked := True else  Form18.CheckBox1.Checked := False;
      Mais1Ini.Free;
      //
      if Form18.CheckBox1.Checked then
      begin
        Form7.bProximas := True;
        Form7.N6EnviarNFeConsultareImprimirDANFE1Click(Sender);
        Form7.bProximas := False;
      end;
      //
      if (Pos('<nfeProc',Form7.ibDataSet15NFEXML.AsString) <> 0) or (Form18.CheckBox1.Checked = False) then
      begin
        if (Form18.ComboBox1.Text <> '<Não imprimir documento>') and (AllTrim(Form18.ComboBox1.Text) <> '') then
        begin
          if Form18.ComboBox1.Text <> '<Imprimir Duplicata>' then
          begin
            if Form18.ComboBox1.Text <> '<Imprimir Carnê>' then
            begin
              Form1.sEscolhido       := Form18.ComboBox1.Text;
              Form25.btnEnviaEmailTodos.Visible := True; // Sandro Silva 2022-12-23 Form25.Button8.Visible := True;
              Form25.ShowModal;
              Form25.btnEnviaEmailTodos.Visible := False; // Sandro Silva 2022-12-23 Form25.Button8.Visible := False;
            end else
            begin
              Form7.Close;
              Form7.Show;
              ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'2'), '', SW_SHOW);
            end;
          end else
          begin
            Form7.Close;
            Form7.Show;
            ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'1'), '', SW_SHOW);
          end;
        end;
      end;
      //
    end;
  except end;
  //
end;

end.


