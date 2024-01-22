unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, SmallFunc_xe, DB, DBCtrls,
  SMALL_DBEdit, IniFiles, ShellApi, FileCtrl, jpeg, frame_teclado_1,
  Buttons, htmlhelp
  , StrUtils
  , uajustaresolucao
  ;

function GetWidthText(const Text: String; Font: TFont): Integer;

type
  TForm2 = class(TForm)
    Panel6: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label27: TLabel;
    DBGrid1: TDBGrid;
    MaskEdit1: TMaskEdit;
    Edit6: TEdit;
    Panel4: TPanel;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit6: TSMALL_DBEdit;
    Panel5: TPanel;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Edit2: TEdit;
    Panel1: TPanel;
    Edit1: TEdit;
    Edit3: TEdit;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    Edit4: TEdit;
    Button4: TBitBtn;
    Label2: TLabel;
    Label15: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label28: TLabel;
    Panel2: TPanel;
    SMALL_DBEdit9: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit16: TSMALL_DBEdit;
    SMALL_DBEdit15: TSMALL_DBEdit;
    SMALL_DBEdit14: TSMALL_DBEdit;
    SMALL_DBEdit13: TSMALL_DBEdit;
    SMALL_DBEdit12: TSMALL_DBEdit;
    SMALL_DBEdit11: TSMALL_DBEdit;
    SMALL_DBEdit10: TSMALL_DBEdit;
    Label9: TLabel;
    Label8: TLabel;
    Label25: TLabel;
    Label24: TLabel;
    Label23: TLabel;
    Label22: TLabel;
    Label21: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    Image1: TImage;
    Button1: TBitBtn;
    Frame_teclado1: TFrame_teclado;
    Label30: TLabel;
    touch_backspace: TImage;
    touch_F8: TImage;
    LabelF8: TLabel;
    touch_F1: TImage;
    LabelESC: TLabel;
    Panel7: TPanel;
    Memo2: TMemo;
    touch_ESC: TImage;
    LabelF1: TLabel;
    Button2: TBitBtn;
    Button3: TBitBtn;
    Label32: TLabel;
    Edit10: TEdit;
    chkDelivery: TCheckBox;
    CheckBox1: TCheckBox;
    EdMarketplace: TEdit;
    lbMarketplace: TLabel;
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaskEdit1Enter(Sender: TObject);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SMALL_DBEdit5Exit(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SMALL_DBEdit5Enter(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SMALL_DBEdit3Exit(Sender: TObject);
    procedure Edit4KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure SMALL_DBEdit6Exit(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure SMALL_DBEdit8Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollBox1Exit(Sender: TObject);
    procedure Button3Enter(Sender: TObject);
    procedure Panel3Enter(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Panel4Enter(Sender: TObject);
    procedure SMALL_DBEdit9Exit(Sender: TObject);
    procedure SMALL_DBEdit10Exit(Sender: TObject);
    procedure SMALL_DBEdit11Exit(Sender: TObject);
    procedure SMALL_DBEdit12Exit(Sender: TObject);
    procedure SMALL_DBEdit13Exit(Sender: TObject);
    procedure SMALL_DBEdit14Exit(Sender: TObject);
    procedure SMALL_DBEdit15Exit(Sender: TObject);
    procedure SMALL_DBEdit16Exit(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SMALL_DBEdit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8Enter(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8Change(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure Edit8KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit9Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit9KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure SMALL_DBEdit2Enter(Sender: TObject);
    procedure touch_F8Click(Sender: TObject);
    procedure Edit9KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure touch_ESCClick(Sender: TObject);
    procedure touch_F1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Memo2Enter(Sender: TObject);
    procedure Edit10KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit10Enter(Sender: TObject);
    procedure Frame_teclado1touch_6Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure chkDeliveryClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdMarketplaceEnter(Sender: TObject);
    procedure EdMarketplaceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdMarketplaceKeyPress(Sender: TObject; var Key: Char);
    procedure EdMarketplaceChange(Sender: TObject);
    procedure EdMarketplaceExit(Sender: TObject);
  private
    { Private declarations }
    procedure AjustaBotoes;
    procedure SelecionaMarketplace(sNome: String);
    procedure AplicaMarketplaceSelecionadaoNaVenda;
  public
    { Public declarations }
    bCancela : Boolean;
    Ij : Integer;
    procedure ExibeSubTotal;
  end;
var
  Form2: TForm2;

implementation

uses fiscal, Unit10, Unit22, Unit6, {Unit5, }_small_59, _small_1,_small_2, _small_3,
    {Sandro Silva 2021-07-22 inicio
   _small_4,
   _small_5,
   _small_6,
   _small_7,
   _small_8,
   _small_9,
   _small_10,
   _small_11,
   }
   _small_12,
   _small_65,
   _small_14,
   _small_15,
   _small_17,
   _small_99,
  Unit7, Unit12, ufuncoesfrente, ufuncoestef;

{$R *.DFM}


function AbreGaveta(P1:Boolean): Boolean;
var
  I : Integer;
begin
  /////////////////
  // GAVETA      //
  /////////////////
  //
  if Form1.iGaveta <> 0 then
  begin
    //
    Form1.PDV_AbreGaveta(False);
    //
    if Form1.sGaveta <> '128' then
    begin
      for I := 1 to 10 do
      begin
        if Form1.sGaveta <> '255' then
        begin
          Form1.sGaveta := Form1.PDV_StatusGaveta(True);
          //
          Application.ProcessMessages;
          if I = 5 then SmallMsg('Verifique se a gaveta não está chaveada.');
          //
        end;
      end;
    end;
    //
    if Form1.sGaveta = '255' then
      Form1.Label_7.Caption := 'Gaveta aberta'
    else
      Form1.Label_7.Caption := '';
    //
  end;
  /////////////////
  // GAVETA      //
  /////////////////
  Result := True;
end;

function MostraFoto2(P1:Boolean): Boolean;
begin
  //
  Result := True;
  //
end;

function GetWidthText(const Text: String; Font: TFont): Integer;
// Largura do texto em conforme a fonte
var
  LBmp: TBitmap;
begin
  LBmp := TBitmap.Create;
  try
    LBmp.Canvas.Font := Font;
    LBmp.Canvas.Font.Style := [];
    LBmp.Canvas.Font.PixelsPerInch := 120;
    Result := LBmp.Canvas.TextWidth(Text);
  finally
    LBmp.Free;
  end;
end;

procedure TForm2.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    if dbGrid1.CanFocus then
    begin
      dbGrid1.SetFocus;
      if DBGrid1.Columns.Items[0].ReadOnly then // Sandro Silva 2018-05-02
        DbGrid1.SelectedIndex := 1;
    end;
  end;

end;

procedure TForm2.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_RETURN then
  begin
    I := DbGrid1.SelectedIndex;
    DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
    if I = DbGrid1.SelectedIndex  then
    begin
      if DBGrid1.Columns.Items[0].ReadOnly then // Sandro Silva 2018-05-02
        DbGrid1.SelectedIndex := 1
      else
        DbGrid1.SelectedIndex := 0;

      Form1.ibDataSet7.Next;
      if Form1.ibDataSet7.EOF then
        Form1.ibDataSet7.Append;
    end;
    if AllTrim(Form1.ibDataSet7.FieldByname('DOCUMENTO').AsString) = '' then
      if Button1.CanFocus then
        Button1.SetFocus;
  end;
end;

procedure TForm2.MaskEdit1Enter(Sender: TObject);
begin
  MaskEdit1.Text := LimpaNumero(MaskEdit1.TExt);
  dBGrid2.Visible := False;
  MaskEdit1.SelectAll;
end;

procedure TForm2.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
    Form2.DBGrid2DblClick(Sender);
end;

procedure TForm2.SMALL_DBEdit2KeyDown(Sender: TObject; var Key: Word;
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

  {Sandro Silva 2020-09-17 inicio}
  if ((ssAlt in Shift) and (Key = VK_F4)) then // Evitar fechar form com ALT+F4 e não executa ibDataSet25PAGARChange
  begin
    //SMALL_DBEdit2Exit(Sender);
    //Form1.ibDataSet25PAGARChange(
    if CheckBox1.Checked then
    begin
      if Button1.Caption = 'F3 Finalizar' then // Sandro Silva 2021-07-02 if Button1.Caption = '&Finalizar' then
        Button1Click(Button1);
    end;
  end;
  {Sandro Silva 2020-09-17 fim}

  //
  if (Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat <> 0) then
  begin
    Button1.Caption := 'F3 Avançar >>'; // Sandro Silva 2021-07-02 Button1.Caption := '&Avançar >>';
  end else
  begin
    Button1.Caption := 'F3 Finalizar'; // Sandro Silva 2021-07-02 Button1.Caption := '&Finalizar';
  end;
  //
end;

procedure TForm2.SMALL_DBEdit5Exit(Sender: TObject);
begin
  //
  if not Form1.bNFazMaisNada then
  begin
    //
    if Form1.ibDataSet25.FieldByname('RECEBER').AsFloat < 0 then
      Form1.ibDataSet25.FieldByname('RECEBER').AsFloat := StrToFloat(FormatFloat('0.00', Form1.fTotal)); // Sandro Silva 2021-12-23 Form1.ibDataSet25.FieldByname('RECEBER').AsFloat := Form1.fTotal;
    // Sandro Silva 2017-02-22 Para não permitir acréscimo acima do valor total vendido
    if Form1.ibDataSet25.FieldByname('RECEBER').AsFloat >= (Form1.fTotal * 2) then
      Form1.ibDataSet25.FieldByname('RECEBER').AsFloat := StrToFloat(FormatFloat('0.00', Form1.fTotal)); // Sandro Silva 2021-12-23 Form1.ibDataSet25.FieldByname('RECEBER').AsFloat := Form1.fTotal;
    //
    Form1.ibDataSet25.FieldByname('ACUMULADO2').AsFloat := StrToFloat(FormatFloat('0.00', Form1.ibDataSet25.FieldByname('RECEBER').AsFloat)); // Sandro Silva 2021-12-23 Form1.ibDataSet25.FieldByname('RECEBER').AsFloat;  
    //
    Panel5.Visible := False;
    // Sandro Silva 2023-11-01 Form2.SMALL_DBEdit5.Enabled := False;
    Form2.SMALL_DBEdit2.SetFocus;
    //
    Form1.Label_7.Caption := 'Forma de pagamento';
    //
  end;
  //
end;


procedure TForm2.Edit2KeyDown(Sender: TObject; var Key: Word;
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

procedure TForm2.Edit2Exit(Sender: TObject);
var
  sAlteracaRegistro: String;
begin
  if not CpfCgc(LimpaNumero(Edit2.Text)) then
  begin
    SmallMsg('CPF ou CNPJ inválido!');
    Form2.Edit2.Text := '';
  end else
  begin
    Form2.Edit2.Text := ConverteCpfCgc(AllTrim(LimpaNumero(Edit2.Text)));

    if ValidaCPFCNPJ(Edit2.Text) = False then
      Form2.Edit2.Text := ''; // 2015-07-28

    if ValidaCPFCNPJ(Form2.Edit2.Text) then // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Form2.Edit2.Text)) then
      Form1.sCPF_CNPJ_Validado := ConverteCpfCgc(AllTrim(LimpaNumero(Form2.Edit2.Text)))
    else
      Form1.sCPF_CNPJ_Validado := ''; // Sandro Silva 2018-10-25

    //
    Form1.ibQuery65.Close;
    Form1.ibQuery65.Sql.Clear;
    Form1.ibQuery65.SQL.Text := 'select * from CLIFOR where CGC='+QuotedStr(Form2.Edit2.Text)+' ';
    Form1.ibQuery65.Open;
    //
    if (Form1.IBQuery65.FieldByName('CGC').AsString = Form2.Edit2.Text)
      and (LimpaNumero(Form1.IBQuery65.FieldByName('CGC').AsString) <> '') then
    begin
      Form2.Edit8.Text := Form1.IBQuery65.FieldByName('NOME').AsString;
      Form2.Edit1.Text := Form1.IBQuery65.FieldByName('ENDERE').AsString;
      Form2.Edit3.Text := AllTrim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) + ' - ' + AllTrim(Form1.ibDataSet2.FieldByName('CEP').AsString); // Sandro Silva 2016-09-30
    end;
    //

    if Form2.Active then
    begin
      if Form2.Edit8.CanFocus then
        Form2.Edit8.SetFocus;
    end;

    sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
    Form1.ibDataSet27.Close;
    Form1.ibDataSet27.SelectSQL.Clear;
    Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' ');
    Form1.ibDataSet27.Open;
    Form1.ibDataSet27.First;

    while Form1.ibDataSet27.Eof = False do
    begin
      if Trim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> '' then
      begin
        Form1.ibDataSet27.Edit; // Atualiza dados do cliente 2017-06-30
        Form1.ibDataSet27.FieldByName('CNPJ').AsString := Form2.Edit2.Text;
        Form1.ibDataSet27.Post;
      end;
      Form1.ibDataSet27.Next;
    end;
    Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);

  end;
end;

procedure TForm2.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Button1.SetFocus;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm2.SMALL_DBEdit5Enter(Sender: TObject);
begin
  //
  Form1.bChave               := False;
  dBGrid2.Visible            := False;
  //
  if SMALL_DBEdit8.CanFocus then SMALL_DBEdit2.SetFocus;
  //
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  //
  Edit4.Visible      := True;
  Label1.Visible     := True;
  Edit4.SetFocus;
  //
end;

procedure TForm2.SMALL_DBEdit3Exit(Sender: TObject);
begin
  // Se valor cheque menor que zero
  if Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat := 0; // Cheque recebe zero
  if Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat <> 0 then
  begin
    Button4.Visible := True // Habilita botão impressão cheque
  end
  else
  begin
    Button4.Visible := False;
    Edit4.Visible   := False;
    Label1.Visible  := False;
  end;
  //
end;

procedure TForm2.Edit4KeyDown(Sender: TObject; var Key: Word;
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

procedure TForm2.SMALL_DBEdit2Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByName('PAGAR').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByName('PAGAR').AsFloat := 0;

  if (TEFValorTotalAutorizado > 0)
    and (Form1.ibDataSet25.FieldByName('PAGAR').AsFloat < TEFValorTotalAutorizado) then
  begin
    Form1.ibDataSet25.FieldByName('PAGAR').AsFloat   := TEFValorTotalAutorizado; // Sandro Silva 2017-06-23
  end;

end;

procedure TForm2.SMALL_DBEdit6Exit(Sender: TObject);
begin
  Button1.SetFocus;
end;

procedure TForm2.Edit2Enter(Sender: TObject);
begin
  Form2.Edit10.Text                := '';
  DBgrid2.Visible := False;
end;

procedure TForm2.Edit3Enter(Sender: TObject);
begin
  DBgrid2.Visible := False;
end;

procedure TForm2.SMALL_DBEdit8Exit(Sender: TObject);
var
  fCredito : Real;
begin
  //
  Form1.ibDataSet2.Refresh;
  //
  if Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat := 0;
  if Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat > 0 then
  begin
    if Edit8.Text = Form1.ibDataSet2.FieldByname('NOME').AsString then
    begin
      //
      if Form1.ibDataSet2.FieldByName('CREDITO').AsFloat <> 0 then
      begin
        //if sVendaImportando = '' then// Quando não é importação do mobile ou reprocessando nfc-e em contingência
        begin
          //
          Form1.ibDataSet99.Close;
          Form1.ibDataSet99.SelectSql.Clear;
          Form1.ibDataSet99.SelectSQL.Add('select sum(VALOR_DUPL) from RECEBER where VALOR_RECE=0 and NOME='+QuotedStr(Form1.ibDataSet2.FieldByName('NOME').AsString)+' ');
          Form1.ibDataSet99.Open;
          fCredito := Form1.ibDataSet2.FieldByName('CREDITO').AsFloat - Form1.ibDataSet25.FieldByname('RECEBER').AsFloat - Form1.IBDataSet99.FieldByName('SUM').AsFloat;
          Form1.ibDataSet99.Close;
          //
          if fCredito < 0 then
          begin
            //////////////////////////
            // Liberação de credito //
            // Libera se ainda tem  //
            // limite               //
            //////////////////////////
            SmallMsg('Atenção:'+Chr(10)
                      +Chr(10)
                      +'Limite de crédito: '+Chr(9)+Chr(9)+Chr(9)+'R$'+Chr(9)+Format('%10.2n',[Form1.ibDataSet2.FieldByName('CREDITO').AsFloat]) + '                ' + Chr(10)
                      +'Contas a receber: '+Chr(9)+Chr(9)+Chr(9)+'R$'+Chr(9)+Format('%10.2n',[(-Form1.ibDataSet2.FieldByName('CREDITO').AsFloat + Form1.ibDataSet25.FieldByName('RECEBER').AsFloat + fCredito)*-1]) + Chr(10)
                      + ifThen(Form1.sModeloECF_Reserva = '99', 'Total do movimento: ', 'Total da venda: ')+ // Sandro Silva 2023-06-23 +'Total da venda: '+
                      Chr(9)+Chr(9)+Chr(9)+'R$'+Chr(9)+Format('%10.2n',[Form1.ibDataSet25.FieldByName('RECEBER').AsFloat]) + Chr(10)
                      +Chr(10)
                      +'Limite de crédito excedido em: '+Chr(9)+'R$'+Chr(9)+Format('%10.2n',[(fCredito)*-1])
                      + Chr(10));
            //
            Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat := 0;
            Form2.Activate;
            //
          end;
        end;
      end;
    end;
    //
  end;
  //
end;

procedure TForm2.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if AllTrim(Edit1.Text) = '' then Button1.SetFocus
      else Perform(Wm_NextDlgCtl,0,0);
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

procedure TForm2.ScrollBox1Exit(Sender: TObject);
begin
  SMALL_DBEdit6.SetFocus;
end;

procedure TForm2.Button3Enter(Sender: TObject);
begin
  Edit8Exit(Sender);
  dBGrid2.Visible := False;
end;

procedure TForm2.Panel3Enter(Sender: TObject);
begin
  //
  if (AllTrim(Edit8.Text) = AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString))
    and (AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString) <> '') then
  begin
    //
    Edit6.Text      := Edit8.Text;
    //
  end else
  begin
    //
    Panel4.Visible := False;
    Panel3.Visible := False;
    Panel5.Visible := True;
    Edit9.Text := Form1.sVendedor;
    if (Form1.ClienteSmallMobile.sVendaImportando = '') then
    begin
      Edit2.SetFocus;
      SmallMsg('É necessário indicar o cliente cadastrado para vender a '+LowerCase(Form2.Label17.Caption)+'.');
    end;
    //
  end;
  //
end;

procedure TForm2.Edit4Exit(Sender: TObject);
begin
  if Form1.sModeloECF = '01' then if not _ecf01_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '02' then if not _ecf02_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '03' then if not _ecf03_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '12' then if not _ecf12_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '14' then if not _ecf14_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '15' then if not _ecf15_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '17' then if not _ecf17_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '59' then if not _ecf59_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if form1.sModeloECF = '65' then if not _ecf65_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '99' then if not _ecf99_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');

  {Sandro Silva 2021-07-22 inicio
  if Form1.sModeloECF = '04' then if not _ecf04_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '05' then if not _ecf05_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '06' then if not _ecf06_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '07' then if not _ecf07_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '08' then if not _ecf08_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '09' then if not _ecf09_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '10' then if not _ecf10_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  if Form1.sModeloECF = '11' then if not _ecf11_ImprimeCheque(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat,StrZero(StrToInt(LimpaNumero(Edit4.Text)),3,0)) then SmallMsg('Impressora não habilitada para imprimir cheque.');
  }

  Button1.SetFocus;
end;

procedure TForm2.Button1Enter(Sender: TObject);
var
  bButton : Integer;
begin
  // Inicia False
  Form6.bPermiteDescontoConvenio := False; // Sandro Silva 2015-05-13 Identifica quando o usuário opta ou não por usar o desconto do convênio
  //
  if (not Panel4.Visible) and (not Panel3.Visible) then
  begin
    //
    Form1.ibDataSet2.Close;
    Form1.ibDataSet2.SelectSQL.Clear;
    Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where Upper(NOME) like '+QuotedStr(UpperCase(Form2.Edit8.Text)+'%')+' and coalesce(ATIVO,0)=0 and trim(coalesce(NOME,'''')) <> '''' order by NOME');
    Form1.ibDataSet2.Open;
    //
    if (AllTrim(Form1.ibDataSet2.FieldByName('CONVENIO').AsString) <> '')
    and (Edit8.Text =  Form1.ibDataSet2.FieldByname('NOME').AsString) then
    begin
      //
      Form1.ibDataSet29.Locate('NOME',Form1.ibDataSet2.FieldByName('CONVENIO').AsString,[]);
      //
      if Form1.ibDataSet29.FieldByName('DESCONTO').AsFloat <> 0 then
      begin

        if (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin
          if (Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat <> 0) // desconto em percentual
            or (Form1.ibDataSet25.FieldByname('VALOR_2').AsFloat <> 0) then // desconto em reais
          begin
            bButton := IDYES;
          end
          else
          begin
            bButton := IDNO;
            if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then // Pos(TIPOMOBILE, Form1.ClienteSmallMobile.sVendaImportando) > 0 then
              SmallMsgBox(Pchar('É necessário confirmar o desconto de: % ' + AllTrim(Format('%12.2n',[Form1.ibDataSet29.FieldByname('DESCONTO').AsFloat])) +
                                Chr(10)+'Conforme convênio: '+Form1.ibDataSet29.FieldByname('NOME').AsString+
                                Chr(10) ),'Atenção', mb_YesNo + mb_DefButton1 + MB_ICONQUESTION)
            else
              bButton := SmallMsgBox(Pchar('Confirma um desconto de: % ' + AllTrim(Format('%12.2n',[Form1.ibDataSet29.FieldByname('DESCONTO').AsFloat])) +
                                          Chr(10)+'Conforme convênio: '+Form1.ibDataSet29.FieldByname('NOME').AsString+
                                          Chr(10) ),'Atenção', mb_YesNo + mb_DefButton1 + MB_ICONQUESTION);
          end;
        end
        else
        begin
          bButton := IDNO;
        end;

        //
        if bButton = IDYES then
        begin
          Form6.bPermiteDescontoConvenio := True; // Sandro Silva 2015-05-13 Identifica quando o usuário opta ou não por usar o desconto do convênio
          //

          {Sandro Silva 2021-11-23 inicio}
          Form6.TipoDescontoAcrescimo  := tDescAcreSubtotal; // Sandro Silva 2021-08-23
          Form6.AjustaPosicaoCampos(47); //Posiciona campos de desconto/acréscimos

          Form6.edTotalPagar.Visible := True;
          Form6.lbTotalPagar.Visible := Form6.edTotalPagar.Visible;
          {Sandro Silva 2021-11-23 fim}

          Form6.Label3.Visible         := True;
          Form6.SMALL_DBEdit3.Visible  := True;
          Form6.Label4.Visible         := True;
          Form6.SMALL_DBEdit4.Visible  := True;
          Form6.Caption                := 'Desconto';
          //
          Form6.ShowModal;
          //
        end;
        //
      end;
    end;
  end;
  //
  if Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat <> 0 then
  begin
    Button4.Visible := True
  end
  else
  begin
    Button4.Visible := False;
    Edit4.Visible   := False;
  end;
end;

procedure TForm2.Panel4Enter(Sender: TObject);
begin
//  Button1.Caption := '&Finalizar';
  Form1.bFlag2 := False; // Form2.Panel4Enter(
end;

procedure TForm2.SMALL_DBEdit9Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR01').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR01').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit10Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR02').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR02').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit11Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR03').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR03').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit12Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR04').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR04').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit13Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR05').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR05').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit14Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR06').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR06').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit15Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR07').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR07').AsFloat := 0;
end;

procedure TForm2.SMALL_DBEdit16Exit(Sender: TObject);
begin
  if Form1.ibDataSet25.FieldByname('VALOR08').AsFloat <= 0 then
    Form1.ibDataSet25.FieldByname('VALOR08').AsFloat := 0;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  _ecf12_AbreGaveta(True);
end;

procedure TForm2.SMALL_DBEdit5KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(27) then
  begin
    Form2.Button3Click(Sender);
  end;
end;

procedure TForm2.Edit8Enter(Sender: TObject);
begin
  //
  DBGrid2.BringToFront; // Sandro Silva 2020-06-01
  DBGrid2.Top        := Edit8.Top + Edit8.Height;
  DBGrid2.Height     := Panel1.BoundsRect.Bottom - DBGrid2.Top; // Sandro Silva 2022-04-06 AjustaAltura(275 - 30 - 40);
  DBGrid2.Visible    := True;
  DBGrid2.DataSource := Form1.DataSource2;

  DBGrid2.DataSource.DataSet.EnableControls; // Sandro Silva 2016-08-01

  DBGrid2.Parent := Edit8.Parent; // Sandro Silva 2022-04-05  

  if Edit8.Text = Form1.ibDataSet2.FieldByName('NOME').AsString then
    MostraFoto2(True);
  //
end;

procedure TForm2.Edit8Exit(Sender: TObject);
var
  sTexto : String;
begin
  //
  // Prazo
  //
  if not Form1.bNFazMaisNada then
  begin
    sTexto := Edit8.Text;
    Form1.sConveniado := Edit8.Text;
  end;
  //
end;

procedure TForm2.Edit8KeyPress(Sender: TObject; var Key: Char);
var
  sAlteracaRegistro: String;
begin
  //
  if Key = Chr(27) then
  begin
    Form2.Button3Click(Sender);
  end;
  //
  if Key = Chr(13) then
  begin
    //
    if AllTrim(Edit8.Text) = '' then
    begin
      sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
      Form1.ibDataSet27.First;
      while Form1.ibDataSet27.Eof = False do
      begin
        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('CLIFOR').AsString := Trim(Edit8.Text);
        Form1.ibDataSet27.FieldByName('CNPJ').AsString   := Trim(Edit2.Text);

        //SmallMsg('Teste 01 CPF ' + edit2.Text + #13 + ' alteraca ' + Form1.ibDataSet27.FieldByName('CNPJ').AsString);

        Form1.ibDataSet27.Post;
        Form1.ibDataSet27.Next;
      end;
      Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);


      if (form1.sModeloECF = '59') or (form1.sModeloECF = '65') or (form1.sModeloECF = '99') then
      begin
        if Form2.Edit10.Visible then
        begin
          if Form2.Edit10.CanFocus then
            Form2.Edit10.SetFocus;
        end;
      end
      else
        Button1Click(Sender);
      if Form2.SMALL_DBEdit5.CanFocus then
        Form2.SMALL_DBEdit5.SetFocus;
    end else
    begin
      //
      if Alltrim(Edit8.Text)<>'' then
        Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]);
      if UpperCase(AllTrim(Edit8.Text)) = Copy(UpperCase(AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString)),1,Length(AllTrim(Edit8.Text))) then
      begin
        //
        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByname('CLIFOR').AsString := AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString);
        //
        Form2.Edit8.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString);
        Form1.sConveniado                := Edit8.Text; // Sandro Silva 2016-09-30 Carrega dados igual Edit8Exit();
        Form2.Edit10.Text                := AllTrim(Form1.ibDataSet2.FieldByname('EMAIL').AsString);
        if (AllTrim(Edit8.Text) <> '') and (AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString) <> '') then // Sandro Silva 2016-02-18
        begin
          Form2.Edit2.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CGC').AsString);

          if ValidaCPFCNPJ(Form2.Edit2.Text) = False then
            Form2.Edit2.Text := '';

        end;
        Form2.Edit1.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString);
        Form2.Edit3.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) + ' - ' + AllTrim(Form1.ibDataSet2.FieldByname('CEP').AsString);


        if ValidaCPFCNPJ(Form2.Edit2.Text) then // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Form2.Edit2.Text)) then
          Form1.sCPF_CNPJ_Validado := ConverteCpfCgc(AllTrim(LimpaNumero(Form2.Edit2.Text)));


        if Form1.sModeloECF = '59' then
        begin
          if (Trim(Form1.ibDataSet2.FieldByname('ENDERE').AsString) = '')
            or (Numero_Sem_Endereco(Trim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)) = '')
            or (Trim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) = '')
            or (Trim(Form1.ibDataSet2.FieldByname('ESTADO').AsString) = '') then
            SmallMsgBox(PChar('Cadastro do cliente incompleto.' + #13 +
                               'Acesse o Small Commerce e complete o cadastro.' + #13 + #13 +
                               'Campos obrigatórios para ' + Form1.sTipoDocumento + #13 + // Sandro Silva 2018-08-01
                               'Endereço: ' + Trim(Form1.ibDataSet2.FieldByname('ENDERE').AsString) + #13 +
                               'Número: ' + Numero_Sem_Endereco(Trim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)) + #13 +
                               'Cidade: ' + Trim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) + ' - ' + Trim(Form1.ibDataSet2.FieldByname('ESTADO').AsString)), 'Atenção', MB_ICONWARNING + MB_OK);
        end;

        //
        if AllTrim(Form2.Edit3.Text) = '-' then
          Form2.Edit3.Text := '';

        Form1.ibDataSet27.Post;

        sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Clear;
        Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' ');
        Form1.ibDataSet27.Open;
        //
        Form1.ibDataSet27.First;
        while Form1.ibDataSet27.Eof = False do
        begin
          Form1.ibDataSet27.Edit;
          Form1.ibDataSet27.FieldByName('CLIFOR').AsString   := Form2.Edit8.Text;
          Form1.ibDataSet27.FieldByName('CNPJ').AsString     := Form2.Edit2.Text;
          Form1.ibDataSet27.FieldByName('VENDEDOR').AsString := Form1.sVendedor;
          Form1.ibDataSet27.Post;
          Form1.ibDataSet27.Next;
        end;
        Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);

        dBGrid2.Visible := False;
        Button1.SetFocus;   // Exibe messagebox perguntando sobre desconto do convênio
        //        MaskEdit1.SetFocus;
      end else
      begin
        if Form2.Edit10.CanFocus then
          Form2.Edit10.SetFocus;
        Form2.Edit10.Text                := '';
      end;
    end;
    //
  end;
  //
end;

procedure TForm2.Edit8Change(Sender: TObject);
begin
  Form1.ibDataSet2.Close;
  Form1.ibDataSet2.SelectSQL.Clear;
  Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where Upper(NOME) like '+QuotedStr(UpperCase(Edit8.Text)+'%')+' and coalesce(ATIVO,0)=0 and trim(coalesce(NOME,'''')) <> '''' order by NOME');
  Form1.ibDataSet2.Open;

  if Form1.ibDataSet2.FieldByname('MOSTRAR').AsString = '1' then
    Edit8.Font.Color := clRed
  else
    Edit8.Font.Color := clBlack;

end;

procedure TForm2.DBGrid2Exit(Sender: TObject);
begin
  //
  {Sandro Silva 2022-04-05 inicio
  if dBgrid2.Top = (Edit9.Top + Edit9.Height) then
  begin
    Form2.Edit9.Text                 := AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString);
  end else
  begin
    //
    if Alltrim(Edit8.Text)<>'' then
      Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]);
    //
    if (Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]))
      and (AllTrim(Edit8.Text) = AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString))
      and (AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString) <> '') then
    begin
      //
      Form2.Edit8.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString);
      Form1.sConveniado                := Edit8.Text; // Sandro Silva 2016-09-30 Carrega dados igual Edit8Exit();
      Form2.Edit2.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CGC').AsString);

      if ValidaCPFCNPJ(LimpaNumero(Form2.Edit2.Text)) = False then
        Form2.Edit2.Text := '';

      Form2.Edit1.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' - '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString);
      Form2.Edit3.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) + ' - ' + AllTrim(Form1.ibDataSet2.FieldByname('CEP').AsString);

      if ValidaCPFCNPJ(Form2.Edit2.Text ) then  // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Form2.Edit2.Text)) then
        Form1.sCPF_CNPJ_Validado := ConverteCpfCgc(AllTrim(LimpaNumero(Form2.Edit2.Text)));
      //
      if AllTrim(Form2.Edit3.Text) = '-' then Form2.Edit3.Text := '';
      if AllTrim(Form2.Edit1.Text) = '-' then Form2.Edit1.Text := '';
      //
    end;
  end;
  }
  if dBgrid2.Top = (EdMarketplace.Top + EdMarketplace.Height) then
  begin
    Form2.EdMarketplace.Text                 := AllTrim(Form1.IBQMARKETPLACE.FieldByname('NOME').AsString);
  end else
  begin

    if dBgrid2.Top = (Edit9.Top + Edit9.Height) then
    begin
      Form2.Edit9.Text                 := AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString);
    end else
    begin
      //
      if Alltrim(Edit8.Text)<>'' then
        Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]);
      //
      if (Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]))
        and (AllTrim(Edit8.Text) = AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString))
        and (AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString) <> '') then
      begin
        //
        Form2.Edit8.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString);
        Form1.sConveniado                := Edit8.Text; // Sandro Silva 2016-09-30 Carrega dados igual Edit8Exit();
        Form2.Edit2.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CGC').AsString);

        if ValidaCPFCNPJ(LimpaNumero(Form2.Edit2.Text)) = False then
          Form2.Edit2.Text := '';

        Form2.Edit1.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' - '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString);
        Form2.Edit3.Text                 := AllTrim(Form1.ibDataSet2.FieldByname('CIDADE').AsString) + ' - ' + AllTrim(Form1.ibDataSet2.FieldByname('CEP').AsString);

        if ValidaCPFCNPJ(Form2.Edit2.Text ) then  // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Form2.Edit2.Text)) then
          Form1.sCPF_CNPJ_Validado := ConverteCpfCgc(AllTrim(LimpaNumero(Form2.Edit2.Text)));
        //
        if AllTrim(Form2.Edit3.Text) = '-' then Form2.Edit3.Text := '';
        if AllTrim(Form2.Edit1.Text) = '-' then Form2.Edit1.Text := '';
        //
      end;
    end;
  end;
  {Sandro Silva 2022-04-05 fim}
  //
end;

procedure TForm2.Edit8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_F5 then
  begin
    Commitatudo(False); // Form2.Edit8KeyDown()
    Form1.ibDataset25.Edit;
    Form1.ibDataset27.Edit;
  end;
  //
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if (Key = VK_UP) or (Key = VK_DOWN) then dBgrid2.SetFocus;
  //
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    dBgrid2.SetFocus;
  end;
  //
end;

procedure TForm2.MaskEdit1Exit(Sender: TObject);
var
  I : Integer;
  dDiferenca : Double;
  Mais1Ini: TIniFile;
  sIntervalo4, sIntervalo5, sIntervalo6 : String;
begin
  //
  // Lê as configurações no .INF
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  sIntervalo4  := Mais1Ini.ReadString('Nota Fiscal','Intervalo1','7');
  sIntervalo5  := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','14');
  sIntervalo6  := Mais1Ini.ReadString('Nota Fiscal','Intervalo3','21');
  Mais1Ini.Free;
  //
  // Consistência
  //
  if LimpaNumero(MaskEdit1.Text) = '' then MaskEdit1.Text := '1';
  if StrtoInt(LimpaNumero(MaskEdit1.Text)) > 100  then MaskEdit1.Text := '1';
  MaskEdit1.Text := LimpaNumero(MaskEdit1.Text);
  //
  // Bug 2000 free
  //
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  //
  if AllTrim(MaskEdit1.Text) <> '' then
  begin
    //
    while (not Form1.ibDataSet14.EOF)
         and (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) <> '5102')
         and (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) <> '6102')
         and (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) <> '512')
         and (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) <> '612') do Form1.ibDataSet14.Next;

    Form1.ibDataSet7.First;
    while not Form1.ibDataSet7.Eof do
      Form1.ibDataSet7.Delete;
    //
    for I := 1 to StrToInt(AllTrim(MaskEdit1.Text)) do
    begin
      //
      Form1.ibDataSet7.Append;
      Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(I); //chr(69+Form1.iCaixa-1)+FormataNumeroDoCupom(Form1.iCupom) + chr(64+I);
      Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := StrToFloat(Format('%8.2f',[Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat / StrToInt(AllTrim(MaskEdit1.Text))]));
      Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := SomaDias(Date,I*7);
      Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := Date;
      Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0;
      Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0;
      Form1.ibDataSet7.FieldByName('NOME').AsString         := Form1.sConveniado;
      Form1.ibDataSet7.FieldByName('HISTORICO').Value       := 'Venda Caixa: '+Form1.sCaixa+' Cupom: '+FormataNumeroDoCupom(Form1.iCupom);
      Form1.ibDataSet7.FieldByName('CONTA').AsString        := Form1.ibDataSet14.FieldByname('CONTA').AsString;
      //
      if I = 1 then Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := SomaDias(Date,StrToInt(sIntervalo4));
      if I = 2 then Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := SomaDias(Date,StrToInt(sIntervalo5));
      if I = 3 then Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := SomaDias(Date,StrToInt(sIntervalo6));
      if I > 3 then Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := SomaDias(Date,StrToInt(sIntervalo6)+((StrToInt(sIntervalo6)-StrToInt(sIntervalo5))*(I-3)));
    end;
    //
    // Valor quebrado
    //
    dDiferenca := Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat;
    Form1.ibDataSet7.First;
    while not Form1.ibDataSet7.Eof do
    begin
      dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]));
      Form1.ibDataSet7.Next;
    end;
    //
    if dDiferenca <> 0 then
    begin
      Form1.ibDataSet7.First;
      Form1.ibDataSet7.Edit;
      Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat := Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat + ddiferenca;
    end;
  end;
  //
  Form1.ibDataSet7.First;
  Button1.Caption := 'F3 Finalizar'; // Sandro Silva 2021-07-02 Button1.Caption := '&Finalizar';
  //
end;

procedure TForm2.Edit9Change(Sender: TObject);
begin
  Form1.ibDataSet99.Close;
  Form1.ibDataSet99.SelectSQL.Clear;
  Form1.ibDataSet99.SelectSQL.Text :=
    'select * ' +
    'from VENDEDOR ' +
    'where upper(NOME) like ' + QuotedStr('%' + UpperCase(Edit9.Text) + '%') +
    ' and coalesce(NOME, '''') <> '''' ' +
    ' order by NOME';
  Form1.ibDataSet99.Open;
  Form1.ibDataSet99.First;
  Form1.ibDataSet9.Locate('NOME',Form1.ibDataSet99.FieldByname('NOME').AsString,[]);
end;

procedure TForm2.Edit9Enter(Sender: TObject);
begin
  DBGrid2.BringToFront; // Sandro Silva 2020-06-01
  DBGrid2.Top        := Edit9.Top + Edit9.Height;
  DBGrid2.Height     := Edit10.BoundsRect.Bottom - DBGrid2.Top; // Sandro Silva 2022-04-06 AjustaAltura(320 - 30);
  DBGrid2.Visible    := True;
  DBGrid2.DataSource := Form1.DataSource9;

  DBGrid2.DataSource.DataSet.EnableControls; // Sandro Silva 2016-08-01

  DBGrid2.Parent := Edit9.Parent; // Sandro Silva 2022-04-05
end;

procedure TForm2.FormShow(Sender: TObject);
var
  Mais1Ini : tIniFile;
  bFalta : Boolean;
  sAlteracaRegistro: String;
  sSecaoFrente: String;
begin
  chkDelivery.Caption := 'Cliente cadastrado para delivery em ' + Form1.ibDataSet13.FieldByName('ESTADO').AsString; // Sandro Silva 2020-06-01

  // Quando abre primeira vez SAT e configura, os botões do Form2 ficam maiores. Nas aberturas seguintes não acontece
  if Form1.sModeloECF = '59' then
  begin
    touch_ESC.Picture := Form1.touch_ESC.Picture;
    touch_F1.Picture  := Form1.touch_F1.Picture;
    touch_F8.Picture  := Form1.touch_F8.Picture;

    AjustaBotoes;
  end;

  sSecaoFrente := Form1.SecaoFrente();

  if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
  begin
    Form1.CalculaDescontoPromocional;
  end;

  if (Form1.sModeloECF = '65') then
  begin
    chkDelivery.Visible := True; // Sandro Silva 2020-06-01
    chkDelivery.Enabled := True; // Sandro Silva 2020-06-01
  end;
  {Sandro Silva 2020-06-01 fim}

  //
  Form2.DBGrid1.Font.Size := Form2.MaskEdit1.Font.Size;
  if (Form1.ClienteSmallMobile.sVendaImportando <> '') then // 2015-06-29
    Form2.SendToBack;
  //
  if (Form1.sModeloECF = '65') or (Form1.sModeloECF = '59') or (Form1.sModeloECF = '99') then
  begin
    Form2.Label32.Visible := True;
    Form2.Edit10.Visible  := True;
  end else
  begin
    Form2.Label32.Visible := False;
    Form2.Edit10.Visible  := False;
  end;
  //
  Form1.ibDataSet27.Close;
  Form1.ibDataSet27.SelectSQL.Clear;
  Form1.ibDataSet27.Selectsql.Add('select * ' +
                                  'from ALTERACA ' +
                                  'where CAIXA='+QuotedStr(Form1.sCaixa)+
                                  ' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+ // Sandro Silva 2021-11-29 ' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+
                                  ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
                                  ' and (DESCRICAO=''Desconto'' or DESCRICAO=''Acréscimo'') and  coalesce(ITEM,''xx'')=''xx'' ');
  Form1.ibDataSet27.Open;
  //
  if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) > 0) then // Sandro Silva 2016-05-03
  begin
    Form1.fDescontoNoTotal := StrToFloat(FormatFloat('0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat)) // Sandro Silva 2021-12-23 Form1.fDescontoNoTotal := Form1.ibDataSet27.FieldByname('TOTAL').AsFloat
  end
  else
  begin
    Form1.fDescontoNoTotal := StrToFloat(FormatFloat('0.00', Form1.ibDataSet27.FieldByname('TOTAL').AsFloat*-1)); // Sandro Silva 2021-12-23 Form1.fDescontoNoTotal := Form1.ibDataSet27.FieldByname('TOTAL').AsFloat*-1;
    if Form1.ibDataSet25.State in [dsEdit, dsInsert] = False then // Sandro Silva 2022-09-06
      Form1.ibDataSet25.Edit; // Precisa para evitar erro quando está usando POS com indentificaPOS e configurou apenas CREDITO/DEBITO sem bandeira
    Form1.ibDataSet25.FieldByname('RECEBER').AsFloat := StrToFloat(FormatFloat('0.00', Form1.fTotal + Form1.fDescontoNoTotal)); // Sandro Silva 2021-12-23 Form1.fTotal + Form1.fDescontoNoTotal;
  end;

  //
  // SmallMsg(Form1.ibDataSet25RECEBER.AsString);
  //
  ExibeSubTotal;
  //
  Form2.Top    := Form1.Panel1.Top;
  Form2.Left   := Form1.Panel1.Left;
  Form2.Height := Form1.Panel1.Height;
  Form2.Width  := Form1.Panel1.Width;
  //
  form2.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  form2.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  form2.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  form2.Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  form2.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  form2.Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  Mais1ini := TIniFile.Create('frente.ini'); // Sandro Silva 2019-05-08
  try
    //
    Screen.Cursor   := crHourGlass;  // Cursor de Aguardo

    Panel5.Visible  := True;
    if (Form1.ClienteSmallMobile.sVendaImportando = '') then
    begin
      if Edit9.CanFocus then
        Edit9.Setfocus;
    end;
    //

    Panel3.Visible  := False;
    Panel4.Visible  := False;
    Edit4.Visible   := False;
    Button4.Visible := False;
    Edit4.Visible   := False;
    Label1.Visible  := False;
    //
    Ij := 0;
    //
    Button1.Caption := 'F3 Avançar >>'; // Sandro Silva 2021-07-02 Button1.Caption := '&Avançar >>';
    //
    //
    if UpperCase(Mais1Ini.ReadString('Frente de caixa','Controle de Cheque','')) = 'SIM' then
    begin
      //
      Form2.Label7.Caption  := 'Número do cheque';
      Form2.Label17.Caption := 'Prazo / Cheque';
      //
      Label9.Visible := False;
      SMALL_DBEdit3.Visible := False;
      //
    end
    else
    begin
      Form2.Label7.Caption  := 'Portador'; // Sandro Silva 2020-07-21
      Form2.Label17.Caption := 'Prazo'; // Sandro Silva 2020-07-21
      //
      Label9.Visible := True; // Sandro Silva 2020-07-21
      SMALL_DBEdit3.Visible := True; // Sandro Silva 2020-07-21
    end;
    //
    Panel1.Visible  := True;
    Label14.Visible := True;
    Label11.Visible := False;
    //
    // Só se alterar manualmente no ini
    //
    if Mais1Ini.ReadString('Frente de caixa','Forma Cartao','')   <> '' then Label8.Caption   := Mais1Ini.ReadString('Frente de caixa','Forma Cartao','TEF');
    if Mais1Ini.ReadString('Frente de caixa','Forma A prazo','')  <> '' then Label17.Caption  := Mais1Ini.ReadString('Frente de caixa','Forma A prazo','A prazo');
    if Mais1Ini.ReadString('Frente de caixa','Forma Cheque','')   <> '' then Label9.Caption   := Mais1Ini.ReadString('Frente de caixa','Forma Cheque','Em cheque');
    if Mais1Ini.ReadString('Frente de caixa','Forma Dinheiro','') <> '' then Label2.Caption   := Mais1Ini.ReadString('Frente de caixa','Forma Dinheiro','Dinheiro');
    //
    // Forma extra 1
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 1','') <> '' then
    begin
      Label18.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 1','');
      Label18.Visible    := True;
      SMALL_DBEdit9.Visible := True;
    end;
    //
    // Forma extra 2
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 2','') <> '' then
    begin
      Label19.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 2','');
      Label19.Visible    := True;
      SMALL_DBEdit10.Visible := True;
    end;
    //
    // Forma extra 3
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 3','') <> '' then
    begin
      Label20.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 3','');
      Label20.Visible    := True;
      SMALL_DBEdit11.Visible := True;
    end;
    //
    // Forma extra 4
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 4','') <> '' then
    begin
      Label21.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 4','');
      Label21.Visible    := True;
      SMALL_DBEdit12.Visible := True;
    end;
    //
    // Forma extra 5
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 5','') <> '' then
    begin
      Label22.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 5','');
      Label22.Visible    := True;
      SMALL_DBEdit13.Visible := True;
    end;
    //
    // Forma extra 6
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 6','') <> '' then
    begin
      Label23.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 6','');
      Label23.Visible    := True;
      SMALL_DBEdit14.Visible := True;
    end;
    //
    // Forma extra 7
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 7','') <> '' then
    begin
      Label24.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 7','');
      Label24.Visible    := True;
      SMALL_DBEdit15.Visible := True;
    end;
    //
    // Forma extra 8
    //
    if Mais1Ini.ReadString(sSecaoFrente,'Forma extra 8','') <> '' then
    begin
      Label25.Caption    := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 8','');
      Label25.Visible    := True;
      SMALL_DBEdit16.Visible := True;
    end;
    //
    Form1.bFlag2 := False; // FormShow(
    //
    if Form1.sCPF_CNPJ_Validado = '' then
    begin

      if Trim(Form1.sConveniado) = '' then
      begin
        Edit1.Text         := '';
        //if (Form1.ClienteSmallMobile.sVendaImportando = '') then // 2015-07-27
        Edit2.Text         := '';
        Edit3.Text         := '';
      end;

      Edit8.Text         := Form1.sConveniado;

    end;
    //
    //
    Form2.Repaint;
    if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Não é contingência sendo transmitida
    begin
      //
      CommitaTudo(True); // Form2 Ativate
      //
      Form1.DeletaDataSet25; // Form2.FormShow()
      Form1.ibDataSet25.Append;

    end
    else
    begin // Sandro Silva 2016-04-25 Transmitindo Contingência NFC-e
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Text :=
        'select * ' +
        'from ALTERACA ' +
        'where CAIXA = ' + QuotedStr(Form1.sCaixa) +
        ' and PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(Form1.icupom)); // Sandro Silva 2021-11-29 ' and PEDIDO = ' + QuotedStr(StrZero(Form1.icupom,6,0));
      Form1.ibDataSet27.Open;
    end;

    sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
    Form1.ibDataSet27.First;
    while Form1.ibDataSet27.Eof = False do
    begin
      if Form1.ibDataSet27.FieldByName('CNPJ').AsString <> '' then
      begin
        Edit2.Text := Form1.ibDataSet27.FieldByName('CNPJ').AsString;
        if ValidaCPFCNPJ(Form2.Edit2.Text) then // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Form2.Edit2.Text)) then
        begin
          Form1.sCPF_CNPJ_Validado := ConverteCpfCgc(AllTrim(LimpaNumero(Form2.Edit2.Text)));
          Edit2.Text := ''; // Sandro Silva 2018-10-25
        end;
        Break;
      end;
      Form1.ibDataSet27.Next;
    end;
    Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);

    //
    // Cupom já foi fechado
    // está a espera do
    // pagamento
    //
    Form1.bFlag2 := True; // FormShow(
    //
    bFalta := Form1.PDV_FaltaPagamento(True);
    //
    if bFalta then
    begin
      //
      // Sandro Silva 2023-11-01 Form2.SMALL_DBEdit5.Enabled := False;
      //
      // Apaga o que ta em branco
      //
      Form1.ibDataSet27.First;
      while not Form1.ibDataSet27.Eof do
        if Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> '' then
        begin
          Form1.ibDataSet27.Next
        end
        else
        begin
          try /// Sandro Silva 2020-05-05
            Form1.ibDataSet27.Delete;
          except

          end;
        end;
      //
      if (AllTrim(Form1.ibDataSet27.FieldByname('CLIFOR').AsString) <> '') then
        Edit8.Text := Form1.ibDataSet27.FieldByname('CLIFOR').AsString;
      //
      Form2.Edit8Change(Sender);
      Form2.Edit8Exit(Sender);
      Form2.Button1Click(Sender);
      //
    end;
    //
    // Sandro Silva 2023-11-01 Form2.SMALL_DBEdit5.Enabled := True;
    //
    if Alltrim(Edit9.Text)<>'' then
    begin
      if Form1.ibDataSet9.Locate('NOME',AllTrim(Edit9.Text),[loCaseInsensitive, loPartialKey]) then
        Edit9.Text := Form1.ibDataSet9NOME.AsString;
    end;
    if Alltrim(Edit8.Text)<>'' then
      Form1.ibDataSet2.Locate('NOME',Edit8.Text,[]);
    //
  except end;
  //
  if Alltrim(Form1.sCPF_CNPJ_Validado) <> '' then
  begin
    //
    Form1.ibDataSet2.Close;
    Form1.ibDataSet2.SelectSQL.Clear;
    Form1.ibDataSet2.SelectSQL.Add('select * from CLIFOR where CGC = ' + QuotedStr(Form1.sCPF_CNPJ_Validado) + ' and coalesce(ATIVO,0)=0 and trim(coalesce(NOME,'''')) <> '''' order by NOME');
    Form1.ibDataSet2.Open;
    //
    Form1.ibDataSet2.Locate('CGC',Form1.sCPF_CNPJ_Validado,[]);
    if Form1.ibDataSet2.FieldByname('CGC').AsString = Form1.sCPF_CNPJ_Validado then
    begin
      Edit8.Text := Form1.ibDataSet2.FieldByname('NOME').AsString;
    end;
    Edit2.Text := Form1.sCPF_CNPJ_Validado;

    // Evitar que fique apenas a máscara do CNPJ/CPF
    if ValidaCPFCNPJ(Edit2.Text) = False then // Sandro Silva 2018-10-25 if CpfCgc(LimpaNumero(Edit2.Text)) = False then
    begin
      Edit2.Text := '';
      Form1.sCPF_CNPJ_Validado := '';
    end;

  end;
  //
  if Form1.fDesconto <> 0 then
  begin
    //
    {Sandro Silva 2021-11-23 inicio}
    Form6.TipoDescontoAcrescimo  := tDescAcreSubtotal; // Sandro Silva 2021-08-23
    Form6.AjustaPosicaoCampos(47); //Posiciona campos de desconto/acréscimos

    Form6.edTotalPagar.Visible := True;
    Form6.lbTotalPagar.Visible := Form6.edTotalPagar.Visible;
    {Sandro Silva 2021-11-23 fim}

    Form6.Label3.Visible         := True;
    Form6.SMALL_DBEdit3.Visible  := True;
    Form6.Label4.Visible         := True;
    Form6.SMALL_DBEdit4.Visible  := True;
    Form6.Caption                := 'Desconto';
    //
    Form6.ShowModal;
    //
  end;
  //
  if (Form1.ClienteSmallMobile.sVendaImportando = '') then
  begin
    if Edit9.CanFocus then
      Edit9.Setfocus;
  end;

  // Se está usando login fica definido o usuário logado como o vendedor , se não estiver selecionado outro vendedor
  if (Form1.sSenhaDeUsuario = 'Sim') then
  begin
    if (Edit9.Text = '') then
    begin
      Edit9.Text := Form1.sVendedor;
    end;

    if (Form1.ClienteSmallMobile.sVendaImportando = '') then
    begin
      if Edit2.CanFocus then
        Edit2.SetFocus;
    end;
  end;
  Mais1Ini.Free; // Sandro Silva 2018-11-21 Memória
  Screen.Cursor := crDefault;  // Cursor de Aguardo
  //
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.sPrazo := '';
  Form1.ibDataSet7.First;
  while not Form1.ibDataSet7.Eof do
  begin
    Form1.sPrazo := Form1.sPrazo + DateToStr(Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime) + ' '
                    + Format('%8.2n',[Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]) + '  ';
    Form1.ibDataSet7.Next;
  end;
  //
  Form1.Image2.Visible := False;
  Form1.Panel9.Visible := False;
  //
end;

procedure TForm2.Edit9KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = VK_F5 then
  begin
    Commitatudo(False); // Form2.Edit9KeyDown()
    Form1.ibDataset25.Edit;
    Form1.ibDataset27.Edit;
  end;

  if Key = VK_RETURN then Edit2.SetFocus;
  if (Key = VK_UP) or (Key = VK_DOWN) then dBgrid2.SetFocus;

end;

procedure TForm2.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(13) then
  begin
    if UpperCase(AllTrim(Edit9.Text)) = Copy(UpperCase(AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString)),1,Length(AllTrim(Edit9.Text))) then
    begin
      Form2.Edit9.Text                 := AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString);
      Form1.ibDataSet27.Edit;
      Form1.ibDataSet27.FieldByname('VENDEDOR').AsString := AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString);
    end;
  end;
  if Key = Chr(27) then
  begin
    Form2.Button3Click(Sender);
  end;
end;

procedure TForm2.DBGrid2DblClick(Sender: TObject);
begin

  dBGrid2.Visible := False;
  if dBgrid2.Top = (EdMarketplace.Top + EdMarketplace.Height) then
  begin
    Form2.EdMarketplace.Text  := Trim(Form1.IBQMARKETPLACE.FieldByname('NOME').AsString);
    Form2.EdMarketplace.SetFocus;

    if Trim(Form2.EdMarketplace.Text) <> '' then
    begin
      // Selecionou um marketplace intermediador, habilita preenchimento tag indIntermed
      _ecf65_HabilitarGerarindIntermed(True);
      Form1.InformarindIntermedNFCe1.Checked := (LerParametroIni(FRENTE_INI, SECAO_65, 'indIntermed', 'Não') = 'Sim');
    end;

    {Sandro Silva 2022-04-12 inicio}
    //keybd_event(VK_RETURN, 0, 0, 0);
    //keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0);
    AplicaMarketplaceSelecionadaoNaVenda;
    {Sandro Silva 2022-04-12 fim}        

  end else
  begin
    if dBgrid2.Top = (Edit9.Top + Edit9.Height) then
    begin
      Form2.Edit9.Text  := AllTrim(Form1.ibDataSet9.FieldByname('NOME').AsString);
      Form2.Edit9.SetFocus;
    end else
    begin
      if AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString) <> '' then
      begin
        Form2.Edit8.Text := AllTrim(Form1.ibDataSet2.FieldByname('NOME').AsString);
        Form2.Edit8.SetFocus;
      end
      else
      begin
        if (Form1.sModeloECF = '65') or (Form1.sModeloECF = '59') or (Form1.sModeloECF = '99') then
        begin
          if Edit10.CanFocus then
            Edit10.SetFocus
          else
            Button1.SetFocus;
        end
        else
          if Edit1.CanFocus then
            Edit1.SetFocus
          else
            if Button1.CanFocus then
              Button1.SetFocus;
      end;
    end;
  end;
  {Sandro Silva 2022-04-05 fim}
end;

procedure TForm2.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  dDiferenca : Double;
  MyBookmark: TBookmark;
  iRegistro, iDuplicatas: Integer;
  sPortador: String;// Sandro Silva 2016-12-15 Ficha 3404
begin
  //
  if Key = chr(46) then key := chr(44);
  if (Key = chr(13)) or (Key = Chr(9) ) then
  begin
    //
    MyBookmark  := Form1.ibDataSet7.GetBookmark;
    if AllTrim(Form1.ibDataSet7.FieldByname('DOCUMENTO').AsString) = '' then
    begin
      if Button4.CanFocus then
        Button4.SetFocus
    end
    else
    begin
      //
      iRegistro   := Form1.ibDataSet7.Recno;
      ddiferenca  := Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat;;
      iDuplicatas := StrToInt(AllTrim(MaskEdit1.Text));
      //
      Form1.ibDataSet7.DisableControls;
      Form1.ibDataSet7.First;
      sPortador := Form1.ibDataSet7.FieldByName('PORTADOR').AsString; // Sandro Silva 2016-12-15 Ficha 3404
      while not Form1.ibDataSet7.Eof do
      begin
        if Form1.ibDataSet7.Recno <= iRegistro then
        begin
          iDuplicatas := iDuplicatas - 1;
          dDiferenca := dDiferenca - Form1.ibDataSet7.FieldByname('VALOR_DUPL').Value;
        end else
        begin
         Form1.ibDataSet7.Edit;
         Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat := dDiferenca / iDuplicatas;
         Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat := StrToFloat(Format('%8.2f',[Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat]));
        end;

        if sPortador <> Form1.ibDataSet7.FieldByName('PORTADOR').AsString then
        begin
          Form1.ibDataSet7.Edit;
          Form1.ibDataSet7.FieldByName('PORTADOR').AsString := sPortador;
        end;
        Form1.ibDataSet7.Next;
      end;
      //
      ddiferenca  := Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat;;
      Form1.ibDataSet7.First;
      while not Form1.ibDataSet7.Eof do
      begin
        dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat]));
        Form1.ibDataSet7.Next;
      end;
      //
      Form1.ibDataSet7.First;
      Form1.ibDataSet7.Edit;
      if dDiferenca <> 0 then Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat := Form1.ibDataSet7.FieldByname('VALOR_DUPL').AsFloat + ddiferenca;
      //
      Form1.ibDataSet7.GotoBookmark(MyBookmark);
      Form1.ibDataSet7.FreeBookmark(MyBookmark);
      Form1.ibDataSet7.EnableControls;
      //
    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  iColuna: Integer;
  iLargura: Integer;
begin
  {Sandro Silva 2021-03-04 inicio}
  Panel5.BorderStyle := bsNone;
  Panel6.BorderStyle := bsNone;
  Edit1.BorderStyle  := bsNone;
  Edit3.BorderStyle  := bsNone;
  {Sandro Silva 2021-03-04 fim}

  KeyPreview := True; // Sandro Silva 2021-07-02

  Form2.touch_ESC.Picture := Form1.touch_ESC.Picture;
  Form2.touch_F1.Picture  := Form1.touch_F1.Picture;
  Form2.touch_F8.Picture  := Form1.touch_F8.Picture;

  //
  LabelESC.Alignment := taCenter;
  LabelESC.Caption := 'ESC' + #13 + 'Voltar';

  LabelF1.Alignment := taCenter;
  LabelF1.Caption := 'F1' + #13 + 'Ajuda';

  LabelF8.Alignment := taCenter;
  LabelF8.Caption := 'F8' + #13 + 'Acréscimo ou' + #13 + 'Desconto';
  //
  AjustaResolucao(Form2);
  AjustaResolucao(Form2.Frame_teclado1);

  Form2.DBGrid2.Columns[0].Font.Size := Form2.Edit8.Font.Size; //Form2.Label28.Font.Size - AjustaAltura(2); // Diminui 1 por causa do estilo fsBold. Sandro Silva 2016-08-01
  Form2.DBGrid2.Columns[0].Width     := AjustaLargura(Form2.DBGrid2.Columns[0].Width); // Sandro Silva 2016-08-01

  for iColuna := 0 to Form2.DBGrid1.Columns.Count -1 do
  begin
    Form2.DBGrid1.Columns[iColuna].Width := AjustaLargura(Form2.DBGrid1.Columns[iColuna].Width);
  end;

  iLargura := 0;
  for iColuna := 0 to Form2.DBGrid1.Columns.Count -1 do
  begin
    if iColuna = 0 then
    begin
      Form2.Label3.Left  := Form2.DBGrid1.Left + iLargura + 3;
      Form2.Label3.Width := Form2.DBGrid1.Columns[iColuna].Width;
      iLargura := iLargura + Form2.DBGrid1.Columns[iColuna].Width;
    end;

    if iColuna = 1 then
    begin
      Form2.Label5.Left  := Form2.DBGrid1.Left + iLargura + 4;
      Form2.Label5.Width := Form2.DBGrid1.Columns[iColuna].Width;
      iLargura := iLargura + Form2.DBGrid1.Columns[iColuna].Width;
    end;

    if iColuna = 2 then
    begin
      Form2.Label4.Left  := Form2.DBGrid1.Left + iLargura + 5;
      Form2.Label4.Width := Form2.DBGrid1.Columns[iColuna].Width;
      iLargura := iLargura + Form2.DBGrid1.Columns[iColuna].Width;
    end;

    if iColuna = 3 then
    begin
      Form2.Label7.Left  := Form2.DBGrid1.Left + iLargura + 6;
      Form2.Label7.Width := Form2.DBGrid1.Columns[iColuna].Width;
      iLargura := iLargura + Form2.DBGrid1.Columns[iColuna].Width;
    end;
  end;

  AjustaBotoes;

  Label28.Width := Edit9.Width;
  Label13.Width := Label28.Width;
  Label12.Width := Label28.Width;
  Label32.Width := Label28.Width;
  Label14.Width := Label28.Width;

  Label15.Width := SMALL_DBEdit9.Width;
  Label8.Width  := Label15.Width;
  Label17.Width := Label15.Width;
  Label9.Width  := Label15.Width;
  Label18.Width := Label15.Width;
  Label19.Width := Label15.Width;
  Label20.Width := Label15.Width;
  Label21.Width := Label15.Width;
  Label22.Width := Label15.Width;
  Label23.Width := Label15.Width;
  Label24.Width := Label15.Width;
  Label25.Width := Label15.Width;
  Label2.Width  := Label15.Width;
  Label10.Width := Label15.Width;

  Label27.Width := Edit6.Width;
  Label6.Width  := MaskEdit1.Width;
  //
  Form1.Image7Click(Sender);
  //
  //
  SMALL_DBEdit5.Color := Image1.Canvas.Pixels[SMALL_DBEdit5.Left, SMALL_DBEdit5.Top - SMALL_DBEdit5.Height]; // Vermelho $006666FF

  SMALL_DBEdit2.Color := Image1.Canvas.Pixels[SMALL_DBEdit2.Left, SMALL_DBEdit2.Top - SMALL_DBEdit2.Height]; // Verde $009BCB66
  SMALL_DBEdit8.Color := SMALL_DBEdit2.Color; // Verde $009BCB66
  SMALL_DBEdit3.Color := SMALL_DBEdit2.Color; // Verde $009BCB66
  SMALL_DBEdit6.Color := SMALL_DBEdit2.Color; // Verde $009BCB66

  SMALL_DBEdit9.Color  := Image1.Canvas.Pixels[SMALL_DBEdit9.Left, SMALL_DBEdit9.Top - SMALL_DBEdit9.Height]; // Cinza $006666FF
  SMALL_DBEdit10.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit11.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit12.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit13.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit14.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit15.Color := SMALL_DBEdit9.Color;
  SMALL_DBEdit16.Color := SMALL_DBEdit9.Color;
end;

procedure TForm2.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MostraFoto2(True);
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  fTotal1 : Double;
begin
  if (Form1.sModeloECF = '65') then
  begin
    if StrToFloatDef(Form1.sValorLimiteIdentificaConsumidor, 0.00) > 0.00 then
    begin
      if (Form1.fTotal - Form1.fDescontoNoTotal) >= StrToFloatDef(Form1.sValorLimiteIdentificaConsumidor, 0.00) then // Sandro Silva 2021-07-30 if Form1.fTotal >= StrToFloatDef(Form1.sValorLimiteIdentificaConsumidor, 0.00) then
      begin
        if (LimpaNumero(Form1.sCPF_CNPJ_Validado) = '') and (LimpaNumero(Form2.Edit2.Text) = '') then
        begin
          Application.ProcessMessages;
          Application.BringToFront;
          SmallMsg('Para vendas com valor maior ou igual a R$' + FormatFloat(',0.00', StrToFloatDef(Form1.sValorLimiteIdentificaConsumidor, 0.00)) + ' é obrigatório informar o CPF do cliente');
          Abort;
        end;
      end;
    end;

    {Sandro Silva 2021-07-12 inicio}
    if StrToFloatDef(Form1.sValorLimiteSemIdentificarConsumidor, 0.00) > 0.00 then
    begin
      if (Form1.fTotal - Form1.fDescontoNoTotal) >= StrToFloatDef(Form1.sValorLimiteSemIdentificarConsumidor, 0.00) then
      begin
        //if (LimpaNumero(Form1.sCPF_CNPJ_Validado) = '') and (LimpaNumero(Form2.Edit2.Text) = '') then
        //begin
          Application.ProcessMessages;
          Application.BringToFront;
          SmallMsg('Não é permitido vendas com valor total maior ou igual a R$' + FormatFloat(',0.00', StrToFloatDef(Form1.sValorLimiteSemIdentificarConsumidor, 0.00)) + '');
          Abort;
        //end;
      end;
    end;
    {Sandro Silva 2021-07-12 fim}

  end;

  //
  if SMALL_DBEdit5.Focused then
    Button1.SetFocus;
  //
  if Panel5.Visible then
  begin
    //
    Form1.sConveniado := Edit8.Text;
    Form1.sVendedor   := Edit9.Text;
    //
    // Desconto pelo convênio
    //
    //
    fTotal1 := Form1.PDV_SubTotal(True);
    //
    if (Form1.ClienteSmallMobile.sVendaImportando = '')
      or ((Form1.ClienteSmallMobile.sVendaImportando <> '') and (sFormaPag = FORMA_PAGAMENTO_A_VISTA)) then
    begin
      fTotal1 := fTotal1 - Form1.fDescontoNoTotal;
      //
      if (Form1.ibDataSet25.State in [dsInsert, dsEdit]) = False then
        Form1.ibDataSet25.Edit;
      Form1.ibDataSet25.FieldByName('RECEBER').AsFloat    := StrToFloat(FormatFloat('0.00', fTotal1)); // Sandro Silva 2021-12-23 fTotal1;
      Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := 0;
      if TEFValorTotalAutorizado > 0 then
      begin
        Form1.ibDataSet25.FieldByName('PAGAR').AsFloat   := TEFValorTotalAutorizado; // Sandro Silva 2017-06-23
      end;

      Form1.ibDataSet25.FieldByName('ACUMULADO1').AsFloat := 0;
      Form1.ibDataSet25.FieldByName('ACUMULADO2').AsFloat := StrToFloat(FormatFloat('0.00', Form1.ibDataSet25.FieldByName('RECEBER').AsFloat)); // Sandro Silva 2021-12-23 Form1.ibDataSet25.FieldByName('RECEBER').AsFloat;
      // 2012    Form1.ibDataSet25ACUMULADO2.AsFloat := 0;
      Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat := 0;
      Form1.ibDataSet25.FieldByName('VALOR01').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR02').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR03').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR04').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR05').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR06').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR07').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR08').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR_1').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR_2').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR_3').AsFloat    := 0;
      Form1.ibDataSet25.FieldByName('VALOR_4').AsFloat    := 0;
    end;

    //
    Panel4.Visible := True;

    Panel5.Visible := False; // Sandro Silva 2021-07-05

    Button1.Caption := 'F3 Finalizar >>'; // Sandro Silva 2021-07-02 Button1.Caption := '&Finalizar >>';
    //
    // Identificação do cliente
    //
    if SMALL_DBEdit5.CanFocus then
    begin
      SMALL_DBEdit5.SelectAll;
      if (Form1.ClienteSmallMobile.sVendaImportando = '') then  // 2015-06-29
        try  // Sandro Silva 2021-09-06
          SMALL_DBEdit5.SetFocus;
        except
        end;
    end else
    begin
      //////////////////////////
      // Cupom já foi fechado //
      // está a espera do     //
      // pagamento            //
      //////////////////////////
      SMALL_DBEdit2.SetFocus;
    end;
    //
    // Sandro Silva 2021-07-05 Panel5.Visible := False;
    //
    //
  end else
  begin
    //
    if Panel4.Visible then
    begin
      //
      if Form1.ibDataSet25.FieldByname('DIFERENCA_').AsFloat <> 0 then
      begin
        Panel4.Visible := False;
        Panel3.Visible := True;
        if (Form1.ClienteSmallMobile.sVendaImportando = '') then // 2015-06-24
        begin
          MaskEdit1.Setfocus;
        end;
      end else
      begin
        Button2Click(Sender);
      end;
      //
    end else
    begin
      //
      if Panel3.Visible then
      begin
        if (StrToIntDef(LimpaNumero(MaskEdit1.Text), 0) = 0) and (Form1.ClienteSmallMobile.sVendaImportando = '') then
        begin
          MaskEdit1.SetFocus;
          SmallMsg('Informe o número de parcelas');
        end
        else
          Button2Click(Sender);
      end;
      //
    end;
    //
  end;

  // Se finalizando em dinheiro deve excluir parcelas a receber do documento
  if Form1.ClienteSmallMobile.sVendaImportando = '' then
  begin
    //Form1.ibDataSet25RECEBER.AsFloat    = Total
    //Form1.fTEFPago                      = Cartão
    //Form1.ibDataSet25PAGAR              = Cartão
    //Form1.ibDataSet25ACUMULADO1         = Cheque
    //Form1.ibDataSet25DIFERENCA_         = Prazo
    //Form1.ibDataSet25ACUMULADO2.AsFloat = Dinheiro
    if (Form1.fTEFPago = 0)
      and (Form1.ibDataSet25.FieldByName('PAGAR').AsFloat = 0)
      and (Form1.ibDataSet25.FieldByName('DIFERENCA_').AsFloat = 0) then
    begin

      Form1.ibDataSet7.First;
      while not Form1.ibDataSet7.Eof do
        Form1.ibDataSet7.Delete;

    end;
  end;
  //
end;

procedure TForm2.SMALL_DBEdit2Enter(Sender: TObject);
begin
  TDBEdit(Sender).SelectAll;
end;

procedure TForm2.touch_F8Click(Sender: TObject);
begin
  keybd_event(VK_F8, 0, 0, 0);
  keybd_event(VK_F8, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TForm2.Edit9KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  Form1.sAjuda   := 'ecf_teclas.htm';
  if Key = VK_F1 then HH(handle, PChar( ExtractFilePath(Application.ExeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form1.sAjuda)));
  //
  if Key = VK_ESCAPE then
  begin
    Form2.Button3Click(Sender);
  end;
  //
  if Key = VK_F8 then
  begin
    //
    if Form1.sLiberacao = '3' then
    begin
      if Form1.ClienteSmallMobile.ImportandoMobile // Sandro Silva 2022-08-08 if ImportandoMobile
        and ((Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99')) then
      begin

      end
      else
      begin
        Form1.Small_InputBox('Senha','Informe a senha do administrador:','');
        if Form12.Caption <> 'Liberado' then Abort;
      end;
    end;
    //
    {Sandro Silva 2021-08-23 inicio}
    Form6.TipoDescontoAcrescimo  := tDescAcreSubtotal; // Sandro Silva 2021-08-23
    Form6.AjustaPosicaoCampos(47); //Posiciona campos de desconto/acréscimos

    Form6.edTotalPagar.Visible := True;
    Form6.lbTotalPagar.Visible := Form6.edTotalPagar.Visible;
    {Sandro Silva 2021-08-23 fim}

    Form6.Label3.Visible         := True;
    Form6.SMALL_DBEdit3.Visible  := True;
    Form6.Label4.Visible         := True;
    Form6.SMALL_DBEdit4.Visible  := True;
    Form6.Caption                := 'Desconto';
    //
    Form6.ShowModal;
    //
  end;
  //
end;

procedure TForm2.touch_ESCClick(Sender: TObject);
begin
  keybd_event(VK_ESCAPE, 0, 0, 0);
  keybd_event(VK_ESCAPE, 0, KEYEVENTF_KEYUP, 0);
end;

procedure TForm2.touch_F1Click(Sender: TObject);
begin
  keybd_event(VK_F1, 0, 0, 0);
  keybd_event(VK_F1, 0, KEYEVENTF_KEYUP, 0); 
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  //
  if (Form1.ibDataSet25.FieldByname('ACUMULADO1').Asfloat > 0.01) or (Form1.ibDataSet25.FieldByname('ACUMULADO2').Asfloat > 0.01) then
    AbreGaveta(True);// Só abre com dinheiro e cheque
  //
  bCancela := False;
  //
  if (Form1.ibDataSet27.FieldByname('CLIFOR').AsString = Form1.ibDataset2.FieldByname('NOME').AsString) and (AllTrim(Form1.ibDataSet27.FieldByname('CLIFOR').AsString)<>'') then
  begin
    try
      Form1.ibDataSet2.Edit;
      Form1.ibDataSet2.FieldByname('ULTIMACO').AsDatetime := Date;
      Form1.ibDataset2.Post;
    except end;
  end;
  //
  Form1.bVolta := False;
  Form2.Close;
  Panel3.Visible := False;
  Form1.lbDisplayPDV.Caption := Form1.sStatusECF;
  //
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  //
  Form1.bNFazMaisNada := True;
  Form1.bNaoSaiComESC := True;
  //
  Commitatudo(True); // Form2.Button3Click()
  Form1.ibDataset25.Edit;
  //
  //
  Close;
  //
end;

procedure TForm2.Memo2Enter(Sender: TObject);
begin
  Form2.Button1.SetFocus;
end;

procedure TForm2.Edit10KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if AllTrim(Edit1.Text) = '' then Button1.SetFocus
      else Perform(Wm_NextDlgCtl,0,0);
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

procedure TForm2.Edit10Enter(Sender: TObject);
begin
  DBgrid2.Visible := False;
end;

procedure TForm2.ExibeSubTotal;
var
  iEspaco: Integer;
begin
  Form2.Memo2.Lines.Clear;
  iEspaco := Trunc(((Form2.Memo2.Width - GetWidthText('Subtotal R$ '+Format('%12.2n',[Form1.fTotal]), Form2.Memo2.Font)) - AjustaLargura(8)) / GetWidthText(' ', Form2.Memo2.Font));
  Form2.Memo2.Lines.Add('Subtotal R$ '+Replicate(' ',iEspaco)+Format('%12.2n',[Form1.fTotal]));
  //
  // Form1.fDescontoNoTotal trabalha com operação ao contrário do sinal do valor da variável. Se valor for negatico é acrécimo, positivo é desconto 
  if Form1.fDescontoNoTotal < 0 then
  begin
    iEspaco := Trunc(((Form2.Memo2.Width - GetWidthText('Acréscimo R$ '+Format('%12.2n',[Form1.fTotal]), Form2.Memo2.Font)) - AjustaLargura(8)) / GetWidthText(' ', Form2.Memo2.Font));
    Form2.Memo2.Lines.Add('Acréscimo R$ '+Replicate(' ',iEspaco)+Format('%12.2n',[Form1.fDescontoNoTotal*-1]));
  end;
  if Form1.fDescontoNoTotal > 0 then
  begin
    iEspaco := Trunc(((Form2.Memo2.Width - GetWidthText('Desconto R$ '+Format('%12.2n',[Form1.fTotal]), Form2.Memo2.Font)) - AjustaLargura(8)) / GetWidthText(' ', Form2.Memo2.Font));
    Form2.Memo2.Lines.Add('Desconto R$ '+Replicate(' ',iEspaco)+Format('%12.2n',[Form1.fDescontoNoTotal*-1]));
  end;
  //
  iEspaco := Trunc((Form2.Memo2.Width - AjustaLargura(8)) / GetWidthText('-', Form2.Memo2.Font));
  Form2.Memo2.Lines.Add(Replicate('-', iEspaco));
  iEspaco := Trunc(((Form2.Memo2.Width - GetWidthText('Total R$ '+Format('%12.2n',[Form1.fTotal]), Form2.Memo2.Font)) - AjustaLargura(8)) / GetWidthText(' ', Form2.Memo2.Font));
  Form2.Memo2.Lines.Add('Total R$ '+Replicate(' ',iEspaco)+Format('%12.2n',[Form1.fTotal-Form1.fDescontoNoTotal]));
end;

procedure TForm2.Frame_teclado1touch_6Click(Sender: TObject);
begin
  Frame_teclado1.touch_6Click(Sender);
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  Form1.sEnderecoClifor := Edit1.Text; // Sandro Silva 2016-09-30
end;

procedure TForm2.Edit3Change(Sender: TObject);
begin
  Form1.sCidadeClifor := Edit1.Text; // Sandro Silva 2016-09-30
end;

procedure TForm2.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if DBGrid2.Top = Edit9.Top + Edit9.Height then
  begin

    DBGrid2.Canvas.Font.Name  := Button1.Font.Name;
    DBGrid2.Canvas.Font.Style := [];
    DBGrid2.Canvas.Font.Color := clBlack;

    if gdSelected in State then
    begin
      DBGrid2.Canvas.Font.Color := clWhite;
    end;

    DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  end;

  if DBGrid2.Top = Edit8.Top + Edit8.Height then
  begin
    // dBgrid2 exibindo cadastro de clientes

    DBGrid2.Canvas.Font.Name  := Button1.Font.Name;
    DBGrid2.Canvas.Font.Style := [];
    if DBGrid2.DataSource.DataSet.FieldByName('MOSTRAR').AsString = '1' then // Inadimplente
      DBGrid2.Canvas.Font.Color := clRed
    else
      DBGrid2.Canvas.Font.Color := clBlack;

    if gdSelected in State then
    begin
      if DBGrid2.DataSource.DataSet.FieldByName('MOSTRAR').AsString = '1' then // Inadimplente
        DBGrid2.Canvas.Font.Color := clRed
      else
        DBGrid2.Canvas.Font.Color := clWhite;
    end;

    DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  end;

end;

procedure TForm2.AjustaBotoes;
begin
  Form2.touch_ESC.Width := Form1.touch_ESC.Width;
  Form2.touch_F1.Width  := Form1.touch_F1.Width;
  Form2.touch_F8.Width  := Form1.touch_F8.Width;

  Form2.LabelF1.Top  := Form2.touch_F1.Top;
  Form2.LabelF8.Top  := Form2.touch_F8.Top;
  Form2.LabelESC.Top := Form2.touch_ESC.Top;

  Form2.LabelF1.Left  := Form2.touch_F1.Left;
  Form2.LabelF8.Left  := Form2.touch_F8.Left;
  Form2.LabelESC.Left := Form2.touch_ESC.Left;

  Form2.LabelF1.Width  := Form2.touch_F1.Width;
  Form2.LabelF8.Width  := Form2.touch_F8.Width;
  Form2.LabelESC.Width := Form2.touch_ESC.Width;

  Form2.LabelF1.Height  := Form2.touch_F1.Height;
  Form2.LabelF8.Height  := Form2.touch_F8.Height;
  Form2.LabelESC.Height := Form2.touch_ESC.Height;

  Form2.LabelF1.Layout  := tlCenter;
  Form2.LabelF8.Layout  := tlCenter;
  Form2.LabelESC.Layout := tlCenter;
end;

procedure TForm2.chkDeliveryClick(Sender: TObject);
begin
  TipoEntrega.Domicilio := chkDelivery.Checked; // Sandro Silva 2020-06-01
end;

procedure TForm2.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssAlt in Shift) and (Key = VK_F4)) then
  begin
    Key := 0;
  end;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssAlt in Shift) and (Key = VK_F4)) then
  begin
    Key := 0;
  end;

  {Sandro Silva 2021-07-02 inicio}
  if Key = VK_F3 then
  begin
    ActiveControl := nil;
    Button1Click(Button1);
  end;
  if Key = VK_ESCAPE then
  begin
    ActiveControl := nil;
    Button3Click(Button3);
  end;
  {Sandro Silva 2021-07-02 fim}

end;

procedure TForm2.EdMarketplaceEnter(Sender: TObject);
begin
  {Sandro Silva 2022-04-05 inicio}
  DBGrid2.BringToFront;
  DBGrid2.Top        := EdMarketplace.Top + EdMarketplace.Height;
  DBGrid2.Height     := Edit2.BoundsRect.Bottom - DBGrid2.Top; // Sandro Silva 2022-04-06 AjustaAltura(320 - 30);
  DBGrid2.Visible    := True;
  DBGrid2.DataSource := Form1.DSMARKETPLACE;

  DBGrid2.DataSource.DataSet.EnableControls;

  SelecionaMarketplace('');

  DBGrid2.Parent := Form2;
  DBGrid2.BringToFront;
  {Sandro Silva 2022-04-05 fim}
end;

procedure TForm2.EdMarketplaceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {Sandro Silva 2022-04-05 inicio}
  //
  if Key = VK_F5 then
  begin
    Commitatudo(False); // Form2.EdMarketplaceKeyDown()
    Form1.ibDataset25.Edit;
    Form1.ibDataset27.Edit;
  end;
  //
  // Sandro Silva 2022-04-06 if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_RETURN then Edit9.SetFocus;

  if (Key = VK_UP) or (Key = VK_DOWN) then dBgrid2.SetFocus;
  //
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    dBgrid2.SetFocus;
  end;
  //
  {Sandro Silva 2022-04-05 fim}
end;

procedure TForm2.EdMarketplaceKeyPress(Sender: TObject; var Key: Char);
//var
//  sAlteracaRegistro: String;
begin
  {Sandro Silva 2022-04-05 inicio}
  if Key = Chr(27) then
  begin
    Form2.Button3Click(Sender);
  end;

  if Key = Chr(13) then
  begin
    //
    AplicaMarketplaceSelecionadaoNaVenda;
    //
  end;
  {Sandro Silva 2022-04-05 fim}
end;

procedure TForm2.EdMarketplaceChange(Sender: TObject);
begin
  {Sandro Silva 2022-04-05 inicio}
  SelecionaMarketplace(EdMarketplace.Text);

  if Form1.IBQMARKETPLACE.FieldByname('MOSTRAR').AsString = '1' then
    EdMarketplace.Font.Color := clRed
  else
    EdMarketplace.Font.Color := clBlack;
  {Sandro Silva 2022-04-05 fim}
end;

procedure TForm2.SelecionaMarketplace(sNome: String);
begin
  Form1.IBQMARKETPLACE.Close;
  Form1.IBQMARKETPLACE.SQL.Clear;
  Form1.IBQMARKETPLACE.SQL.Text := SelectMarketplace(sNome);
  Form1.IBQMARKETPLACE.Open;
end;

procedure TForm2.AplicaMarketplaceSelecionadaoNaVenda;
var
  sAlteracaRegistro: String;
begin
  if Trim(edMarketplace.Text) = '' then
  begin
    sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
    Form1.ibDataSet27.First;
    while Form1.ibDataSet27.Eof = False do
    begin
      Form1.ibDataSet27.Edit;
      Form1.ibDataSet27.FieldByName('MARKETPLACE').AsString := Trim(edMarketplace.Text);
      Form1.ibDataSet27.Post;
      Form1.ibDataSet27.Next;
    end;
    Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);

    if Form2.SMALL_DBEdit5.CanFocus then
      Form2.SMALL_DBEdit5.SetFocus;
  end else
  begin
    //
    if Trim(edMarketplace.Text) <> '' then
      Form1.IBQMARKETPLACE.Locate('NOME', edMarketplace.Text,[]);
    if UpperCase(Trim(edMarketplace.Text)) = Copy(UpperCase(Trim(Form1.IBQMARKETPLACE.FieldByname('NOME').AsString)), 1, Length(Trim(edMarketplace.Text))) then
    begin
      //
      Form2.edMarketplace.Text                 := Trim(Form1.IBQMARKETPLACE.FieldByname('NOME').AsString);

      sAlteracaRegistro := Form1.ibDataSet27.FieldByName('REGISTRO').AsString;
      Form1.ibDataSet27.Close;
      Form1.ibDataSet27.SelectSQL.Clear;
      Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(FormataNumeroDoCupom(Form1.icupom))+' '); // Sandro Silva 2021-11-29 Form1.ibDataSet27.SelectSQL.Add('select * from ALTERACA where CAIXA='+QuotedStr(Form1.sCaixa)+' and PEDIDO='+QuotedStr(StrZero(Form1.icupom,6,0))+' ');
      Form1.ibDataSet27.Open;
      //
      Form1.ibDataSet27.First;
      while Form1.ibDataSet27.Eof = False do
      begin
        Form1.ibDataSet27.Edit;
        Form1.ibDataSet27.FieldByName('MARKETPLACE').AsString   := Form2.edMarketplace.Text;
        Form1.ibDataSet27.Post;
        Form1.ibDataSet27.Next;
      end;
      Form1.ibDataSet27.Locate('REGISTRO', sAlteracaRegistro, []);

      dBGrid2.Visible := False;
    end;
  end;
end;

procedure TForm2.EdMarketplaceExit(Sender: TObject);
begin
  if Trim(EdMarketplace.Text) = '' then
    AplicaMarketplaceSelecionadaoNaVenda; // Sandro Silva 2022-05-04
end;

end.
