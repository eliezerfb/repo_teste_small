// unit desdobramento parcelas
unit Unit18;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, Unit7, SmallFunc,
  ExtCtrls, DB, ShellApi, IniFiles, Buttons, IBCustomDataSet, IBQuery;

type
    TForm18 = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    DBGrid1: TDBGrid;
    Label7: TLabel;
    cboDocCobranca: TComboBox;
    Button4: TBitBtn;
    Panel9: TPanel;
    lbTotalParcelas: TLabel;
    CheckBox1: TCheckBox;
    IBQINSTITUICAOFINANCEIRA: TIBQuery;
    IBQBANCOS: TIBQuery;
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
    procedure DBGrid1ColExit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cboDocCobrancaEnter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
  private
    { Private declarations }
    FIdentificadorPlanoContas: String; // Sandro Silva 2022-12-29
    procedure ExibeOpcoesPreencherColunas;
    procedure CarregacboDocCobranca;
    procedure GetBancosNFe(slBanco: TStringList);
    procedure GetInstituicaoFinanceira(slInstituicao: TStringList);
    function FormaDePagamentoEnvolveBancos(sForma: String): Boolean;
    function ValidarDesdobramentoParcela: Boolean;
  public
    { Public declarations }
    sConta : String;
    property IdentificadorPlanoContas: String read FIdentificadorPlanoContas write FIdentificadorPlanoContas; // Sandro Silva 2022-12-29
    procedure SetPickListParaColuna;
  end;

var
  Form18: TForm18;

implementation

uses Unit12, Mais, unit24, Unit19, Unit43, Unit25, Unit16, Unit22, Unit3, uFuncoesBancoDados,
  uFuncoesRetaguarda, StrUtils;

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
    if Key = VK_RETURN then
      Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP then
      Perform(Wm_NextDlgCtl,-1,0);
    if Key = VK_DOWN then
      Perform(Wm_NextDlgCtl,0,0);
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
    if Key = VK_RETURN then
      Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP then
      Perform(Wm_NextDlgCtl,-1,0);
    if Key = VK_DOWN then
      Perform(Wm_NextDlgCtl,0,0);
  except
  end;

end;

procedure TForm18.Label10MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do
    Font.Style := [];
end;

procedure TForm18.Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do
    Font.Style := [fsBold];
end;

procedure TForm18.FormShow(Sender: TObject);
var
  Total: Real;
  I: Integer;
  Mais1Ini: tIniFile;
  //sSecoes:  TStrings;
  //sBancoIni : string;
begin
  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
  begin
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
    lbTotalParcelas.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
    //
  end else
  begin
    Form18.SMALL_DBEdit1.Enabled := True;
    Form18.DBGrid1.Enabled       := True;
  end;

  try
    if AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString) = 'CAIXA' then
       Form18.Close; // else if Alltrim(SMALL_DBEdit1.Text) = '' then SMALL_DBEdit1.Text := '1';

    if SMALL_DBEdit1.CanFocus then
    begin
      SMALL_DBEdit1.SetFocus;
      SMALL_DBEdit1.SelectAll;
    end;

    if (AllTrim(Form7.ibDataSet14CONTA.AsString) = '') then
    begin
      Form7.ibDataSet12.First;

      if Form7.SModulo <> 'CLIENTES' then  // Ok
      begin
        Form43.IdentificadorPlanoContas := FIdentificadorPlanoContas; // Sandro Silva 2022-12-29

        Form43.ShowModal; // OK
        sConta := Form7.ibDataSet12NOME.AsString;
        FIdentificadorPlanoContas := Form7.ibDataSet12IDENTIFICADOR.AsString;// Sandro Silva 2022-12-29
      end else
      begin
        sConta := '';
        FIdentificadorPlanoContas := '';// Sandro Silva 2022-12-29
      end;
    end else
    begin
      sConta := Form7.ibDataSet14CONTA.AsString;
    end;

    Panel9.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];

    if (Form7.sModulo <> 'VENDA') and (Form7.sModulo <> 'COMPRA') and (Form7.sModulo <> 'CLIENTES') then
      Form7.sModulo := 'VENDA';

    CheckBox1.Visible := False;

    if Form7.SModulo = 'CLIENTES' then  // Ok
    begin
      Form7.ibQuery1.Close;
      Form7.IBQuery1.SQL.Clear;
      Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=9 where coalesce(ATIVO,9)<>1 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and VALOR_RECE=0');
      Form7.IBQuery1.Open;

      CheckBox1.Visible := False;
      
      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do
        Form7.ibDataSet7.Fields[I-1].Visible := False;
      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;
      lbTotalParcelas.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
      SMALL_DBEdit1.DataSource := Form7.DataSource15;
      // ***********************************
      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      // ***********************************
      {Sandro Silva 2023-06-21 inicio
      cboDocCobranca.Items.Clear;
      cboDocCobranca.Items.Add('<Não imprimir documento>');

      try
        sSecoes := TStringList.Create;
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        Mais1Ini.ReadSections(sSecoes);

        for J := 0 to (sSecoes.Count - 1) do
        begin
          if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
          begin
            //cboDocCobranca.Items.Add(sSecoes[J]);  Mauricio Parizotto 2023-06-19

            sBancoIni := trim(StringReplace(sSecoes[J],'Boleto de cobrança do ','',[rfReplaceAll]));

            if ExecutaComandoEscalar(Form7.IBDatabase1,
                                     ' Select Count(*) From BANCOS '+
                                     ' Where NOME = '+QuotedStr(sBancoIni)) > 0 then
            begin
              cboDocCobranca.Items.Add(sSecoes[J]);
            end;
          end;
        end;

        Mais1Ini.Free;
      except
      end;

      cboDocCobranca.Items.Add('<Imprimir Duplicata>');
      cboDocCobranca.Items.Add('<Imprimir Carnê>');

      cboDocCobranca.Visible   := True;
      cboDocCobranca.ItemIndex := 0;
      }
      CarregacboDocCobranca;
      Label7.Visible      := True;

      dbGrid1.DataSource := Form7.DataSource7;

      if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;
    end;

    if Form7.SModulo = 'VENDA' then // Ok
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
        CheckBox1.Checked := True
      else
        CheckBox1.Checked := False;
      Mais1Ini.Free;
      //
      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do
        Form7.ibDataSet7.Fields[I-1].Visible := False;

      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;

      {Sandro Silva 2023-06-16 inicio}
      Form18.Width  := 995;//1000;// 906; // Largura normal
      Form18.Height := 444; //500;

      lbTotalParcelas.Alignment := taLeftJustify;
      lbTotalParcelas.Left      := 5;
      Form7.ibDataSet7FORMADEPAGAMENTO.Visible     := True; // Sandro Silva 2023-06-16
      Form7.ibDataSet7AUTORIZACAOTRANSACAO.Visible := True; // Sandro Silva 2023-06-22
      Form7.ibDataSet7BANDEIRA.Visible             := True; // Sandro Silva 2023-06-22

      Form7.ibDataSet7VALOR_DUPL.DisplayWidth := 10;
      Form7.ibDataSet7FORMADEPAGAMENTO.Index  := 12;

      Form7.ibDataSet7PORTADOR.DisplayWidth := 20;
      Form7.ibDataSet7DOCUMENTO.DisplayWidth := 11;

      {Sandro Silva 2023-07-05 inicio}
      IBQBANCOS.Close;
      IBQBANCOS.SQL.Text :=
        'select NOME, INSTITUICAOFINANCEIRA ' +
        'from BANCOS ' +
        'order by NOME';
      IBQBANCOS.Open;

      IBQINSTITUICAOFINANCEIRA.Close;
      IBQINSTITUICAOFINANCEIRA.SQL.Text :=
        'select NOME ' +
        'from CLIFOR ' +
        'where CLIFOR in (''Credenciadora de cartão'', ''Instituição financeira'') ' +
        'order by NOME';
      IBQINSTITUICAOFINANCEIRA.Open;

      GetFormasDePagamentoNFe(Form7.slPickListFormaDePagamento);
      GetBanderiasOperadorasNFe(Form7.slPickListBandeira);
      Form7.slPickListBandeira.Add('');
      Form7.slPickListBandeira.Sorted := True;
      Form7.slPickListBandeira.Sort;
      GetBancosNFe(Form7.slPickListBanco);
      GetInstituicaoFinanceira(Form7.slPickListInstituicao);
      {Sandro Silva 2023-07-05 fim}

      {Sandro Silva 2023-06-16 fim}

      lbTotalParcelas.Caption := 'Total: ' + Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)]);
      SMALL_DBEdit1.DataSource := Form7.DataSource15;
      // ***********************************
      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      // ***********************************
      {
      cboDocCobranca.Items.Clear;
      cboDocCobranca.Items.Add('<Não imprimir documento>');

      try
        sSecoes := TStringList.Create;
        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        Mais1Ini.ReadSections(sSecoes);

        for J := 0 to (sSecoes.Count - 1) do
        begin
          if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
          begin
            //cboDocCobranca.Items.Add(sSecoes[J]);  Mauricio Parizotto 2023-06-19

            sBancoIni := trim(StringReplace(sSecoes[J],'Boleto de cobrança do ','',[rfReplaceAll]));

            if ExecutaComandoEscalar(Form7.IBDatabase1,
                                     ' Select Count(*) From BANCOS '+
                                     ' Where NOME = '+QuotedStr(sBancoIni)) > 0 then
            begin
              cboDocCobranca.Items.Add(sSecoes[J]);
            end;
          end;
        end;

        Mais1Ini.Free;
      except
      end;

      cboDocCobranca.Items.Add('<Imprimir Duplicata>');
      cboDocCobranca.Items.Add('<Imprimir Carnê>');

      cboDocCobranca.Visible   := True;
      cboDocCobranca.ItemIndex := 0;
      }
      CarregacboDocCobranca;

      Label7.Visible      := True;

      dbGrid1.DataSource := Form7.DataSource7;
      if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;
    end;

    if Form7.SModulo = 'COMPRA' then
    begin
      cboDocCobranca.Visible := False;
      Label7.Visible    := False;

      Form7.ibDataSet8.EnableControls;
      for I := 1 to Form7.ibDataSet8.FieldCount do
        Form7.ibDataSet8.Fields[I-1].Visible := False;
      Form7.ibDataSet8DOCUMENTO.Visible  := True;
      Form7.ibDataSet8VENCIMENTO.Visible := True;
      Form7.ibDataSet8VALOR_DUPL.Visible := True;
      Form7.ibDataSet8PORTADOR.Visible   := True;

      lbTotalParcelas.Caption := Format('%12.2n',[Form7.ibDataSet24TOTAL.AsFloat]);
      SMALL_DBEdit1.DataSource := Form7.DataSource24;
      dbGrid1.DataSource := Form7.DataSource8;

      if Form7.ibDataSet24DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet24.Edit;
        Form7.ibDataSet24DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet24.Post;
      end;
    end;

    if SMALL_DBEdit1.CanFocus then
    begin
      SMALL_DBEdit1.SetFocus;
      SMALL_DBEdit1.SelectAll;
    end;

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

  try

    if Field.Name = 'ibDataSet7VENCIMENTO' then
    begin
      dbGrid1.Canvas.Brush.Color := clWhite;
      dbGrid1.Canvas.Font := dbGrid1.Font;
      if (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7) then
        DBGrid1.Canvas.Font.Color   := clRed
      else
        DBGrid1.Canvas.Font.Color   := clBlack;
      dbGrid1.Canvas.TextOut(Rect.Left + dbGrid1.Canvas.TextWidth('99/99/9999_'), Rect.Top + 2, Copy(DiaDaSemana(Form7.ibDataSet7VENCIMENTO.AsDateTime), 1, 3) );
    end;

    dbGrid1.Canvas.Brush.Color := Form7.Panel7.Color;
    dbGrid1.Canvas.Pen.Color   := clRed;

    xRect.Left   := REct.Left;
    xRect.Top    := -1;
    xRect.Right  := Rect.Right;
    xRect.Bottom := Rect.Bottom - Rect.Top + 0;

    dbGrid1.Canvas.FillRect(xRect);

    //with dbgrid1.Canvas do
    //begin
      OldBkMode := SetBkMode(Handle, TRANSPARENT);
      dbgrid1.Canvas.Font := dbgrid1.TitleFont;
      dbgrid1.Canvas.TextOut(Rect.Left + 2, 2, Trim(Field.DisplayLabel));
      dbgrid1.Canvas.Font.Color := clblack;
      SetBkMode(Handle, OldBkMode);
    //end;
  except
  end;
end;

procedure TForm18.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
  slFormas: TStringList;
  sForma: String;
begin

  try
  {Sandro Silva 2023-06-21 inicio} 
    if TDBGrid(Sender).SelectedField.FieldName = 'FORMADEPAGAMENTO' then
    begin
      if (Key = VK_DOWN) OR (Key = VK_UP) then
      begin
        slFormas := TStringList.Create;
        GetFormasDePagamentoNFe(slFormas);
        sForma := ValidaFormadePagamentoDigitada(TDBGrid(Sender).SelectedField.AsString, slFormas);
        if TDBGrid(Sender).SelectedField.AsString <> sForma then
        begin
          TDBGrid(Sender).DataSource.DataSet.Edit;
          TDBGrid(Sender).SelectedField.AsString := sForma;
        end;
        slFormas.Free;
      end;
    end;
    {Sandro Silva 2023-06-21 fim}

    if (Key = VK_RETURN) then
    begin
      I := DbGrid1.SelectedIndex;

      DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
      if I = DbGrid1.SelectedIndex  then
      begin
        DbGrid1.SelectedIndex := 0;
        dBgrid1.DataSource.DataSet.Next;
        if dBgrid1.DataSource.DataSet.EOF then
          Button4.SetFocus;
      end;
    end;
  except
  end;
end;

procedure TForm18.DBGrid1ColEnter(Sender: TObject);
begin
  try
    if (Form7.sModulo = 'VENDA') and (DbGrid1.SelectedIndex = 0) then
      DbGrid1.SelectedIndex := 1;

    SetPickListParaColuna;

    ExibeOpcoesPreencherColunas; // Sandro Silva 2023-06-19
  except
  end;
  
end;

procedure TForm18.DBGrid1Enter(Sender: TObject);
begin
  DbGrid1.SelectedIndex := 1;
  Form7.ibDataSet7.Tag := ID_BLOQUEAR_APPEND_NO_GRID_DESDOBRAMENTO_PARCELAS; // Bloqueia fazer append/insert no dataset
end;

procedure TForm18.Button4Click(Sender: TObject);
begin
  {Sandro Silva 2023-07-12 inicio
  Form18.Close;
  }
  if ValidarDesdobramentoParcela then
    Form18.Close;
  {Sandro Silva 2023-07-12 fim}
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
  if Form7.sModulo = 'VENDA' then // Ok
  begin
    Total := 0;
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
      Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
      Form7.ibDataSet7.Next;
    end;

    if (Abs(Total - (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) > 0.01) and (Total<>0) then
    begin
      ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.');
      
      SMALL_DBEdit1.SetFocus;
      Abort;
    end;

    {Sandro Silva 2023-06-16 inicio}
    // Limpa picklist das formas de pagamento a receber
    for i := 0 to DBGrid1.Columns.Count -1 do
    begin
      DBGrid1.Columns[i].PickList.Clear;
    end;
    {
    Form7.ibDataSet7VALOR_DUPL.DisplayWidth := 14;
    Form18.Width := 600; // Largura normal
    lbTotalParcelas.Alignment := taRightJustify;
    lbTotalParcelas.Left      := 239;
    Form7.ibDataSet7FORMADEPAGAMENTO.Visible := False; // Sandro Silva 2023-06-16
    Form7.ibDataSet7PORTADOR.Index := 12;
    Form7.ibDataSet7PORTADOR.DisplayWidth  := 33;
    Form7.ibDataSet7DOCUMENTO.DisplayWidth := 12;
    }
    Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_BOLETO;
    Form7.ibDataSet7.DisableControls;
    {Sandro Silva 2023-06-16 fim}

  end;

  try
    Form18.Close;
    if Form7.sModulo = 'CLIENTES' then
    begin
      // ACORDO
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

      // Zeresima
      fTotal1 := 0;

      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+chr(13)+chr(10);
        ftotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
        Form7.ibDataSet7.Next;
      end;

      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                              '                        -------------'+chr(13)+chr(10)+
                              '                      '+Format('%15.2n',[ftotal1])+chr(13)+chr(10);

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
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set PORTADOR='+QuotedStr('ACORDO '+Form7.ibDataSet15NUMERONF.AsString)+' where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=1 where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.IBDataSet2.Edit;
          Form7.IBDataSet2MOSTRAR.AsFloat := 0;
        end else
        begin
          // Volta tudo
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            Form7.ibDataSet7.Delete;
            Form7.ibDataSet7.First;
          end;
        end;
      end else
      begin
        // Volta tudo
        Form7.ibQuery1.Close;
        Form7.IBQuery1.SQL.Clear;
        Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
        Form7.IBQuery1.Open;

        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
      end;
    end;

    if Form7.sModulo = 'VENDA' then
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
        Form18.CheckBox1.Checked := True
      else
        Form18.CheckBox1.Checked := False;
      Mais1Ini.Free;

      if Form18.CheckBox1.Checked then
      begin
        Form7.bProximas := True;
        Form7.N6EnviarNFeConsultareImprimirDANFE1Click(Sender);
        Form7.bProximas := False;
      end;

      if (Pos('<nfeProc',Form7.ibDataSet15NFEXML.AsString) <> 0) or (Form18.CheckBox1.Checked = False) then
      begin
        if (Form18.cboDocCobranca.Text <> '<Não imprimir documento>') and (AllTrim(Form18.cboDocCobranca.Text) <> '') then
        begin
          if Form18.cboDocCobranca.Text <> '<Imprimir Duplicata>' then
          begin
            if Form18.cboDocCobranca.Text <> '<Imprimir Carnê>' then
            begin
              {Sandro Silva 2023-06-20 inicio
              Form1.sEscolhido       := Form18.ComboBox1.Text;
              Form25.btnEnviaEmailTodos.Visible := True; // Sandro Silva 2022-12-23 Form25.Button8.Visible := True;
              Form25.ShowModal;
              Form25.btnEnviaEmailTodos.Visible := False; // Sandro Silva 2022-12-23 Form25.Button8.Visible := False;
              }
              try
                {Sandro Silva 2023-07-12 inicio
                Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_BOLETO;
                Form7.ibDataSet7.DisableControls;
                {Sandro Silva 2023-07-12 fim}

                Form1.sEscolhido       := Form18.cboDocCobranca.Text;
                Form1.sBancoBoleto     := Trim(StringReplace(Form18.cboDocCobranca.Text, 'Boleto de cobrança do', '', [rfReplaceAll]));
                Form25.btnEnviaEmailTodos.Visible := True;
                Form25.ShowModal;
                Form25.btnEnviaEmailTodos.Visible := False;

              finally
                Form7.ibDataSet7.EnableControls;
                Form7.ibDataSet7.Tag := 0;
              end;

              Form25.btnEnviaEmailTodos.Visible := False; // Sandro Silva 2022-12-23 Form25.Button8.Visible := False;
              {Sandro Silva 2023-06-20 fim}
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
    end;
    {Sandro Silva 2023-07-12 inicio}
    Form7.ibDataSet7VALOR_DUPL.DisplayWidth := 14;
    Form18.Width  := 600; // Largura normal
    Form18.Height := 421; // Altura normal
    lbTotalParcelas.Alignment := taRightJustify;
    lbTotalParcelas.Left      := 239;
    Form7.ibDataSet7FORMADEPAGAMENTO.Visible := False; // Sandro Silva 2023-06-16
    Form7.ibDataSet7PORTADOR.Index := 12;
    Form7.ibDataSet7PORTADOR.DisplayWidth  := 33;
    Form7.ibDataSet7DOCUMENTO.DisplayWidth := 12;
    Form7.ibDataSet7.Tag := 0; // Sandro Silva 2023-07-18
    Form1.sBancoBoleto     := ''; // Sandro Silva 2023-07-18
    {Sandro Silva 2023-07-12 fim}
  except
  end;
  //

end;

procedure TForm18.ExibeOpcoesPreencherColunas;
begin
  if (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'BANDEIRA')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'PORTADOR')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'AUTORIZACAOTRANSACAO')
     then
  begin

    if (DbGrid1.Columns[DbGrid1.SelectedIndex].PickList.Count > 0) then
    begin

      keybd_event(VK_F2,0,0,0);
      keybd_event(VK_F2,0,KEYEVENTF_KEYUP,0);
      keybd_event(VK_MENU,0,0,0);
      keybd_event(VK_DOWN,0,0,0);
      keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
      keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);

    end;

  end;

end;

procedure TForm18.DBGrid1ColExit(Sender: TObject);
var
  iRecno: Integer;
  sForma: String;
  sPortador: String;
  sAutorizacao: String;
  sBandeira: String;
begin
  if Form7.ibDataSet7FORMADEPAGAMENTO.Visible then
  begin

    if DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO' then
    begin

      DBGrid1.DataSource.DataSet.DisableControls;
      try

        iRecno := DBGrid1.DataSource.DataSet.RecNo;
        sForma := ValidaFormadePagamentoDigitada(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString, TStringList(DBGrid1.Columns[DBGrid1.SelectedIndex].PickList));

        if DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString <> sForma then
        begin
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
        end;

        if sForma <> '' then
        begin

          while DBGrid1.DataSource.DataSet.Eof = False do
          begin
            if DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString = '' then
            begin
              DBGrid1.DataSource.DataSet.Edit;
              DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
            end;
            DBGrid1.DataSource.DataSet.Next;
          end;

          DBGrid1.DataSource.DataSet.RecNo := iRecno;

        end
        else
        begin

          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := '';

        end;

      finally
        DBGrid1.DataSource.DataSet.EnableControls;
      end;
    end;

    //Ao preencher o campo Portador, Autorização e Bandeira deve aplicar para as demais parcelas que possuem
    //a mesma forma de pagamento e o campo Portador=EM CARTEIRA ou em branco e Autorização e Bandeira em branco

    if (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'PORTADOR') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'AUTORIZACAOTRANSACAO') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'BANDEIRA')
     then
    begin

      DBGrid1.DataSource.DataSet.DisableControls;
      try

        iRecno := DBGrid1.DataSource.DataSet.RecNo;
        sPortador    := DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString;
        sForma       := DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString;
        sAutorizacao := DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString;
        sBandeira    := DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString;

        while DBGrid1.DataSource.DataSet.Eof = False do
        begin
          if (DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString = sForma)
            and ((DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString = 'EM CARTEIRA') or (Trim(DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString) = '') or (DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString = sPortador))
            then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString := sPortador;

            if (DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString = '') then
              DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString := sAutorizacao;

            if (DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString = '') then
              DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString := sBandeira;
          end;
          DBGrid1.DataSource.DataSet.Next;
        end;

        DBGrid1.DataSource.DataSet.RecNo := iRecno;

      finally
        DBGrid1.DataSource.DataSet.EnableControls;
      end;
    end;

  end;

end;

procedure TForm18.DBGrid1CellClick(Column: TColumn);
begin
  ExibeOpcoesPreencherColunas;
end;

procedure TForm18.CarregacboDocCobranca;
var
  Mais1Ini: tIniFile;
  sSecoes:  TStrings;
  J: Integer;
  sBancoIni: String;
begin
  // ***********************************
  // Preenche o combobox com os bancos *
  // configurados no controle bancário *
  // ***********************************
  cboDocCobranca.Items.Clear;
  cboDocCobranca.Items.Add('<Não imprimir documento>');

  sSecoes := TStringList.Create;  
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.ReadSections(sSecoes);

    for J := 0 to (sSecoes.Count - 1) do
    begin
      if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
      begin
        //cboDocCobranca.Items.Add(sSecoes[J]);  Mauricio Parizotto 2023-06-19

        sBancoIni := trim(StringReplace(sSecoes[J],'Boleto de cobrança do ','',[rfReplaceAll]));

        if ExecutaComandoEscalar(Form7.IBDatabase1,
                                 ' Select Count(*) From BANCOS '+
                                 ' Where NOME = '+QuotedStr(sBancoIni)) > 0 then
        begin
          cboDocCobranca.Items.Add(sSecoes[J]);
        end;
      end;
    end;

    Mais1Ini.Free;
  except
  end;

  cboDocCobranca.Items.Add('<Imprimir Duplicata>');
  cboDocCobranca.Items.Add('<Imprimir Carnê>');

  cboDocCobranca.Visible   := True;
  cboDocCobranca.ItemIndex := 0;

  sSecoes.Free;
end;

procedure TForm18.GetBancosNFe(slBanco: TStringList);
begin
  slBanco.Clear;
  IBQBANCOS.First;
  while IBQBANCOS.Eof = False do
  begin
    slBanco.Add(IBQBANCOS.FieldByName('NOME').AsString);
    IBQBANCOS.Next;
  end; // while IBQ.Eof = False do

end;

procedure TForm18.GetInstituicaoFinanceira(slInstituicao: TStringList);
begin
  slInstituicao.Clear;
  IBQINSTITUICAOFINANCEIRA.First;
  while IBQINSTITUICAOFINANCEIRA.Eof = False do
  begin

    slInstituicao.Add(IBQINSTITUICAOFINANCEIRA.FieldByName('NOME').AsString);
    IBQINSTITUICAOFINANCEIRA.Next;
  end; // while IBQ.Eof = False do
end;

procedure TForm18.SetPickListParaColuna;
begin
  if Form7.sModulo = 'VENDA' then
  begin

    if Form7.ibDataSet7BANDEIRA.Visible then
    begin
      if DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'BANDEIRA' then
      begin
        DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList.Clear;

        if FormaDePagamentoEnvolveCartao(Form18.DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
          DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList := Form7.slPickListBandeira;

      end;
    end;


    if Form7.ibDataSet7FORMADEPAGAMENTO.Visible then
    begin

      if DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO' then
        DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList := Form7.slPickListFormaDePagamento;

    end;

    if Form18.DBGrid1.SelectedField.FieldName = 'PORTADOR' then
    begin

      Form18.DBGrid1.Columns[Form18.DBGrid1.SelectedIndex].PickList.Clear;
      if FormaDePagamentoEnvolveBancos(Form18.DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        Form18.DBGrid1.Columns[Form18.DBGrid1.SelectedIndex].PickList := Form7.slPickListBanco;

      if FormaDePagamentoEnvolveCartao(Form18.DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        Form18.DBGrid1.Columns[Form18.DBGrid1.SelectedIndex].PickList := Form7.slPickListInstituicao;

    end
  end;

end;

function TForm18.FormaDePagamentoEnvolveBancos(sForma: String): Boolean;
begin
  Result := (Pos('|' + IdFormasDePagamentoNFe(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) + '|', '|02|16|17|18|') > 0); /// envolvem bancos
end;

function TForm18.ValidarDesdobramentoParcela: Boolean; 
var
  slFormas: TStringList;
  sForma: String;
  iRecno: Integer;
  sMensagem: String;
  iRecnoFormaErrada: Integer;
  sColunaPosicionar: String;
begin
  Result := True; 
  if Form7.sModulo = 'VENDA' then
  begin
    slFormas := TStringList.Create;
    iRecnoFormaErrada := -1;
    try
      DBGrid1.DataSource.DataSet.DisableControls;
      sMensagem := '';
      GetFormasDePagamentoNFe(slFormas);

      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'FORMADEPAGAMENTO')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'BANDEIRA')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'PORTADOR')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'AUTORIZACAOTRANSACAO')].ReadOnly := False;


      iRecno := DBGrid1.DataSource.DataSet.RecNo;
      DBGrid1.DataSource.DataSet.First;
      while DBGrid1.DataSource.DataSet.Eof = False do
      begin

        sForma := ValidaFormadePagamentoDigitada(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString, slFormas);
        if (sForma <> DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        begin
          if sForma = '' then
          begin
            sMensagem := 'Forma de pagamento incorreta informada';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'FORMADEPAGAMENTO';
          end;
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
        end;
        
        if FormaDePagamentoEnvolveBancos(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then // envolvem bancos
        begin
          IBQBANCOS.First;
          if IBQBANCOS.Locate('NOME', DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString, []) then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('INSTITUICAOFINANCEIRA').AsString := IBQBANCOS.FieldByName('INSTITUICAOFINANCEIRA').AsString;
          end;
        end;

        if FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then // envolvem instituição financeiras/credenciadoras
        begin
          if IBQINSTITUICAOFINANCEIRA.Locate('NOME', DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString, []) then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('INSTITUICAOFINANCEIRA').AsString := IBQINSTITUICAOFINANCEIRA.FieldByName('NOME').AsString;

          end;

          if Trim(DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString) = '' then
          begin
            sMensagem := 'Informe a bandeira do cartão de crédito/débito';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'BANDEIRA';
          end;

          if Trim(DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) = '' then
          begin
            sMensagem := 'Informe o número da autorização do cartão de crédito/débito';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'AUTORIZACAOTRANSACAO';
          end;

        end;


        DBGrid1.DataSource.DataSet.Next;
      end;

      DBGrid1.DataSource.DataSet.Recno := iRecno;

    finally
      slFormas.Free;
      DBGrid1.DataSource.DataSet.EnableControls;

      if sMensagem <> '' then
      begin
        Result := False;
        DBGrid1.SetFocus;
        if iRecnoFormaErrada <> -1 then
        begin
          DBGrid1.DataSource.DataSet.Recno := iRecnoFormaErrada;
          DBGrid1.SelectedIndex := IndexColumnFromName(DBGrid1, sColunaPosicionar);
        end;
        ShowMessage(sMensagem);
      end;

    end;
  end;

end;

procedure TForm18.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ValidarDesdobramentoParcela = False then
    Abort;
end;

procedure TForm18.cboDocCobrancaEnter(Sender: TObject);
begin
  if Form7.sModulo = 'VENDA' then
  begin
    DBGrid1.DataSource.DataSet.First;
    DBGrid1.SelectedIndex := IndexColumnFromName(DBGrid1, 'VENCIMENTO');
  end;
end;

procedure TForm18.DBGrid1Exit(Sender: TObject);
begin
  Form7.ibDataSet7.Tag := 0; // Permiter fazer append/insert no dataset
end;

end.
