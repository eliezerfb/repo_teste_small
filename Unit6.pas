unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, SmallFunc_xe, DBCtrls, SMALL_DBEdit, ExtCtrls,
  frame_teclado_1, Buttons
  , DB // Sandro Silva 2019-03-14 
  , uajustaresolucao
  ;

type TTipoDescontoAcrescimo = (tDescAcreSubtotal, tDescProduto); // Sandro Silva 2021-08-23

type
  TForm6 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    Button1: TBitBtn;
    Button2: TBitBtn;
    SMALL_DBEdit3: TSMALL_DBEdit;
    Label3: TLabel;
    Label4: TLabel;
    SMALL_DBEdit4: TSMALL_DBEdit;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    edTotalPagar: TEdit;
    lbTotalPagar: TLabel;
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SMALL_DBEdit1Exit(Sender: TObject);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure SMALL_DBEdit3Exit(Sender: TObject);
    procedure SMALL_DBEdit4Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edTotalPagarExit(Sender: TObject);
    procedure edTotalPagarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure AjustaValorDoAcrescimoOuDesconto;
    { Private declarations }
  public
    { Public declarations }
    bPermiteDescontoConvenio: Boolean;
    TipoDescontoAcrescimo: TTipoDescontoAcrescimo; // Sandro Silva 2021-08-23
    procedure AjustaPosicaoCampos(Value: Integer);
  end;

var
  Form6: TForm6;

implementation

uses fiscal, Unit2, ufuncoesfrente;

{$R *.dfm}

procedure TForm6.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;
  Close;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm6.SMALL_DBEdit1Exit(Sender: TObject);
begin
  //
  if (Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat >= 100) or (Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat < 0) then
  begin
    SmallMsg('Desconto inválido');
    Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;

    {Sandro Silva 2021-08-23 inicio}
    if edTotalPagar.Visible then
    begin
      edTotalPagar.Text := FormatFloat('0.00', Form1.fTotal);
    end;
    {Sandro Silva 2021-08-23 fim}

  end;
  //
  if Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat <> 0 then
  begin
    Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;
  end;
end;

procedure TForm6.SMALL_DBEdit2Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat < 0 then Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
  if Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat <> 0 then
  begin
    Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;
  end;
  if Form6.Caption = 'Desconto ou acréscimo' then
  begin
    if Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat >= Form1.ibDataSet25.FieldByName('RECEBER').AsFloat then
    begin
      SmallMsg('Desconto inválido');
      Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;

      {Sandro Silva 2021-08-23 inicio}
      if edTotalPagar.Visible then
      begin
        edTotalPagar.Text := FormatFloat('0.00', Form1.fTotal);
      end;
      {Sandro Silva 2021-08-23 fim}
    end;
  end;
end;

procedure TForm6.SMALL_DBEdit3Exit(Sender: TObject);
begin
  //
  if (Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat >= 100) or (Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat < 0) then
  begin
    SmallMsg('Acréscimo inválido');
    Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;

    {Sandro Silva 2021-08-23 inicio}
    if edTotalPagar.Visible then
    begin
      edTotalPagar.Text := FormatFloat('0.00', Form1.fTotal);
    end;
    {Sandro Silva 2021-08-23 fim}
  end;
  //
  if Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat <> 0 then
  begin
    Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;
  end;
end;

procedure TForm6.SMALL_DBEdit4Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat < 0 then
  begin
    Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;
  end;
  if Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat <> 0 then
  begin
    Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
    Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;
  end;
  if Form6.Caption = 'Desconto ou acréscimo' then
  begin
    if Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat >= Form1.ibDataSet25.FieldByName('RECEBER').AsFloat then
    begin
      SmallMsg('Acréscimo inválido');
      Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;

      {Sandro Silva 2021-08-23 inicio}
      if edTotalPagar.Visible then
      begin
        edTotalPagar.Text := FormatFloat('0.00', Form1.fTotal);
      end;
      {Sandro Silva 2021-08-23 fim}

    end;
  end;
end;

procedure TForm6.FormActivate(Sender: TObject);
begin
  edTotalPagar.ReadOnly := True;
  if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
    edTotalPagar.ReadOnly := False;
  //
  Commitatudo(True); // Form6.FormActivate()
  //
  Form6.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Form6.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Form6.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  Form6.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Form6.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  Form6.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat := 0;
  Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := 0;

  edTotalPagar.Text := FormatFloat('0.00', Form1.fTotal); // Sandro Silva 2021-08-18
  //
  if Form6.Label3.Visible then // Desconto no total não do ítem
  begin
    //
    if Form1.fDesconto <> 0 then
      Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := StrToFloat(FormatFloat('0.00', Form1.fDesconto)); // Sandro Silva 2021-12-23 Form1.ibDataSet25.FieldByname('VALOR_2').AsFloat := Form1.fDesconto;
    if (Form1.fDesconto = 0) and (Form1.fDescontoNoTotal <> 0) then
    begin
      if Form1.fDescontoNoTotal > 0 then
        Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat := StrToFloat(FormatFloat('0.00', Abs(Form1.fDescontoNoTotal))); // Sandro Silva 2017-08-08 // Sandro Silva 2021-12-23 Abs(Form1.fDescontoNoTotal);
      if Form1.fDescontoNoTotal < 0 then
        Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat := StrToFloat(FormatFloat('0.00', Abs(Form1.fDescontoNoTotal))); // Sandro Silva 2017-08-08 // Sandro Silva 2021-12-23 Abs(Form1.fDescontoNoTotal);
    end;
    //
    Form1.ibDataSet2.Close;
    Form1.ibDataSet2.SelectSQL.Clear;
    Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where Upper(NOME) like '+QuotedStr(UpperCase(Form2.Edit8.Text)+'%')+' and coalesce(ATIVO,0)=0 and trim(coalesce(NOME,'''')) <> '''' order by NOME');
    Form1.ibDataSet2.Open;
    //
    if (AllTrim(Form1.ibDataSet2.FieldByName('CONVENIO').AsString) <> '')
    and (Form2.Edit8.Text =  Form1.ibDataSet2.FieldByname('NOME').AsString) then
    begin
      //
      Form1.ibDataSet29.Locate('NOME',Form1.ibDataSet2.FieldByName('CONVENIO').AsString,[]);
      //
      if Form1.ibDataSet29.FieldByName('DESCONTO').AsFloat <> 0 then
      begin
        if bPermiteDescontoConvenio then
          Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := Form1.ibDataSet29.FieldByName('DESCONTO').AsFloat;
      end;
      //
    end;
  end;
  //
  Small_dbEdit1.SetFocus;
  Small_dbEdit1.SelectAll;
  //

  if (Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat <> 0) // desconto em percentual
    and (Form1.ibDataSet25.FieldByname('VALOR_2').AsFloat <> 0) then // desconto em reais
  begin

    SmallMsgBox(PChar('O cliente possui ' + FormatFloat('#0.00%', Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat) + ' de desconto cadastrado no seu convênio ' +
                      'e foi lançado mais ' + FormatFloat('R$ #0.00', Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat) + ' de desconto no cupom' + #13 + #13 +
                      'O desconto do convênio será desconsiderado'), 'Atenção', MB_ICONWARNING + MB_OK);

    Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat := 0;
    bPermiteDescontoConvenio := False;

    if Button2.CanFocus then
      Button2.SetFocus;

  end;

end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
var
  sCliforSelecionado: String;
  sCNPJSelecionado: String;
  sVendedorSelecionado: String;
begin
  // *****************
  // Desconto em %   *
  // *****************
  if Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat > 0 then Form1.fDescontoNoTotal := StrToFloat(Format('%10.2f',[Form1.fTotal -(Form1.fTotal - (Form1.fTotal * Form1.ibDataSet25.FieldByName('VALOR_1').asFloat / 100))]));
  if Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat > 0 then Form1.fDescontoNoTotal := StrToFloat(FormatFloat('0.00', Form1.fTotal - (Form1.fTotal - Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat))); // Sandro Silva 2021-12-23 Form1.fTotal - (Form1.fTotal - Form1.ibDataSet25VALOR_2.AsFloat);
  if Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat > 0 then Form1.fDescontoNoTotal := StrToFloat(Format('%10.2f',[Form1.fTotal -(Form1.fTotal + (Form1.fTotal * Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat/100))]));
  if Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat > 0 then Form1.fDescontoNoTotal := StrToFloat(FormatFloat('0.00', Form1.fTotal - (Form1.fTotal + Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat))); // Sandro Silva 2021-12-23 Form1.fDescontoNoTotal := Form1.fTotal - (Form1.fTotal + Form1.ibDataSet25VALOR_4.AsFloat);
  //
  if Form2.Visible then
  begin
    Form2.Memo2.Lines.Clear;

    // Zerar desconto/ acréscimo para nfce/sat
    if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
    begin
      if (Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat = 0) and
         (Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat = 0) and
         (Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat = 0) and
         (Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat = 0) then
      begin
        Form1.fDescontoNoTotal := 0;
        Form1.fDesconto        := 0; // Sandro Silva 2017-06-30

        // Procura o desconto ou total lançados anteriormente
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.Selectsql.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and (DESCRICAO=''Desconto'' or DESCRICAO=''Acréscimo'') and  coalesce(ITEM,''xx'')=''xx'' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.Selectsql.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' and (DESCRICAO=''Desconto'' or DESCRICAO=''Acréscimo'') and  coalesce(ITEM,''xx'')=''xx'' ');
        Form1.ibDataSet27.Open;
        //
        if (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Desconto') or (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Acréscimo') then
        begin
          try /// Sandro Silva 2020-05-05
            Form1.ibDataSet27.Delete;
          except
          end;
        end;
      end;
    end;

    Form2.ExibeSubTotal;

    //
    if Form1.fDescontoNoTotal <> 0 then
    begin

      // Sandro Silva 2017-08-08 Fica abrindo tela do desconto toda vez que pressiona F3/F7  Form1.fDesconto := Form1.fDescontoNoTotal; // Sandro Silva 2017-08-08
      //

      {Sandro Silva 2022-03-22 inicio} 
      // Ficha 5732
      // Verifica se informou cliente antes de lançar desconto ou acréscimo
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Text := 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and coalesce(CLIFOR,'''') <> '''' ';
      Form1.ibDataSet27.Open;

      sCNPJSelecionado   := Form1.ibDataSet27.FieldByName('CNPJ').AsString;
      sCliforSelecionado := Form1.ibDataSet27.FieldByName('CLIFOR').AsString;

      // Verifica se informou vendedor antes de lançar desconto ou acréscimo
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Text := 'select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and coalesce(VENDEDOR,'''') <> '''' ';
      Form1.ibDataSet27.Open;

      sVendedorSelecionado := Form1.ibDataSet27.FieldByName('VENDEDOR').AsString;

      {Sandro Silva 2022-03-22 fim}

      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.Selectsql.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' and (DESCRICAO=''Desconto'' or DESCRICAO=''Acréscimo'') and  coalesce(ITEM,''xx'')=''xx'' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.Selectsql.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' and (DESCRICAO=''Desconto'' or DESCRICAO=''Acréscimo'') and  coalesce(ITEM,''xx'')=''xx'' ');
      Form1.ibDataSet27.Open;
      //
      if (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Desconto') or (Form1.ibDataSet27.FieldByName('DESCRICAO').AsString = 'Acréscimo') then
      begin
        Form1.ibDataSet27.Edit; // Desconto
      end else
      begin
        Form1.ibDataSet27.Append; // Desconto
      end;
      //
      Form1.ibDataSet27.FieldByName('TIPO').AsString      := 'BALCAO';
      Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := FormataNumeroDoCupom(Form1.icupom); // Sandro Silva 2021-11-29 Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := StrZero(Form1.icupom,6,0);
      //
      if Form1.fDescontoNoTotal < 0 then
      begin
        Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Acréscimo';
      end else
      begin
        Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Desconto';
      end;
      //
      Form1.ibDataSet27.FieldByName('DATA').AsDateTime     := StrToDate(Form1.sDataDoCupom);
      Form1.ibDataSet27.FieldByName('HORA').AsString       := Copy(Form1.sHoraDoCupom,7,2)+':'+Copy(Form1.sHoraDoCupom,9,2)+':'+Copy(Form1.sHoraDoCupom,11,2);
      {Sandro Silva 2022-08-29 inicio}
      if Form1.sModeloEcf = '65' then
        Form1.ibDataSet27.FieldByName('HORA').AsString       := FormatDateTime('HH:nn:ss', Time);
      {Sandro Silva 2022-08-29 fim}
      Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat  := 1;
      Form1.ibDataSet27.FieldByName('UNITARIO').AsCurrency := StrToFloat(FormatFloat('0.00',((Form1.fDescontoNoTotal*-1)))); // Desconto no total // Sandro Silva 2019-09-18 ER 02.06 UnoChapeco Form1.ibDataSet27UNITARIO.AsFloat := (Form1.fDescontoNoTotal*-1); // Desconto no total
      Form1.ibDataSet27.FieldByName('TOTAL').AsCurrency    := StrToFloat(FormatFloat('0.00',(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat))); // Sandro Silva 2019-09-18 ER 02.06 UnoChapeco Form1.ibDataSet27TOTAL.AsFloat      := Form1.ibDataSet27QUANTIDADE.AsFloat * Form1.ibDataSet27UNITARIO.AsFloat;
      Form1.ibDataSet27.FieldByName('CAIXA').AsString      := Form1.sCaixa;
      Form1.ibDataSet27.FieldByName('CLIFOR').AsString     := sCliforSelecionado;  // Sandro Silva 2016-09-29
      {Sandro Silva 2023-07-26 inicio}
      if Form1.ibDataSet27.FieldByName('CLIFOR').AsString = '' then
        Form1.ibDataSet27.FieldByName('CLIFOR').Clear;
      {Sandro Silva 2023-07-26 fim}
      Form1.ibDataSet27.FieldByName('CNPJ').AsString       := sCNPJSelecionado;    // Sandro Silva 2016-09-29
      Form1.ibDataSet27.FieldByName('VENDEDOR').AsString   := sVendedorSelecionado;// Sandro Silva 2016-09-29
      Form1.ibDataSet27.Post;
      //
    end;
    //
  end;
  {Sandro Silva 2021-08-23 inicio}
  edTotalPagar.Visible := False;
  lbTotalPagar.Visible := edTotalPagar.Visible;
  if TipoDescontoAcrescimo = tDescAcreSubtotal then
    AjustaPosicaoCampos(-47);
  {Sandro Silva 2021-08-23 fim}
  //
end;

procedure TForm6.SMALL_DBEdit1Enter(Sender: TObject);
begin
  if SMALL_DBEdit1.CanFocus then SMALL_DBEdit1.SetFocus;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  // Ajusta os componentes a resolução
  AjustaResolucao(Form6);// Sandro Silva 2016-08-19
  AjustaResolucao(Form6.Frame_teclado1);// Sandro Silva 2016-08-19
  Form6.Width  := AjustaLargura(Form6.Width);// Sandro Silva 2016-08-19
  Form6.Height := AjustaAltura(Form6.Height);// Sandro Silva 2016-08-19
  if Form6.Top < 0 then
    Form6.Top := 0;

  Label1.Width       := SMALL_DBEdit1.Width;
  Label2.Width       := SMALL_DBEdit2.Width;
  Label3.Width       := SMALL_DBEdit3.Width;
  Label4.Width       := SMALL_DBEdit4.Width;
  lbTotalPagar.Width := edTotalPagar.Width; // Sandro Silva 2021-08-19
  AjustaPosicaoCampos(-47);
end;

procedure TForm6.edTotalPagarExit(Sender: TObject);
begin
  AjustaValorDoAcrescimoOuDesconto;
end;

procedure TForm6.AjustaValorDoAcrescimoOuDesconto;
// Ajusta o Valor do Acrescimo ou do Desconto a partir do valor a pagar informado
var
  cTotalAPagar: Currency;
begin
  cTotalAPagar := StrToFloatDef(edTotalPagar.Text, Form1.fTotal); // Valida valor digitado, deixando o total da venda como valor default em caso de falha na validação
  if cTotalAPagar <= 0.00 then // não aceitar valor zerado ou negativo
    cTotalAPagar := Form1.fTotal;
  edTotalPagar.Text := FormatFloat('0.00', cTotalAPagar);

  if StrToFloat(FormatFloat('0.00', Form1.fTotal)) <> StrToFloat(FormatFloat('0.00', cTotalAPagar)) then //Sandro Silva 2024-04-29 if Form1.fTotal <> cTotalAPagar then
  begin
    if Form1.fTotal > cTotalAPagar then
    begin
      Form1.ibDataSet25.FieldByName('VALOR_2').AsString := FormatFloat('0.00', Form1.fTotal - cTotalAPagar);
      SMALL_DBEdit2.SetFocus;
    end
    else
    begin
      Form1.ibDataSet25.FieldByName('VALOR_4').AsString := FormatFloat('0.00', cTotalAPagar - Form1.fTotal);
      SMALL_DBEdit4.SetFocus;
    end;
  end;
end;

procedure TForm6.edTotalPagarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm6.AjustaPosicaoCampos(Value: Integer);
begin
  // Ajusta posição dos campos de desconto/acréscimo conforme tipo de desconto, se no item ou desconto/acréscimo no subtotal da venda
  Form6.Label1.Top := Form6.Label1.Top + AjustaAltura(Value);
  Form6.Label2.Top := Form6.Label2.Top + AjustaAltura(Value);
  Form6.Label3.Top := Form6.Label3.Top + AjustaAltura(Value);
  Form6.Label4.Top := Form6.Label4.Top + AjustaAltura(Value);

  Form6.SMALL_DBEdit1.Top := Form6.SMALL_DBEdit1.Top + AjustaAltura(Value);
  Form6.SMALL_DBEdit2.Top := Form6.SMALL_DBEdit2.Top + AjustaAltura(Value);
  Form6.SMALL_DBEdit3.Top := Form6.SMALL_DBEdit3.Top + AjustaAltura(Value);
  Form6.SMALL_DBEdit4.Top := Form6.SMALL_DBEdit4.Top + AjustaAltura(Value);

end;

end.


