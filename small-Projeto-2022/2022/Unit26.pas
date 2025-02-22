//     local de pagamento ---> 1    4
//             vencimento ---> 1   51
//         data documento ---> 5    4
//              documento ---> 5   15
//      esp�cie documento ---> 5   32
//                 aceite ---> 5   36
//             processado ---> 5   39
//     valor do documento ---> 6   52
// linha 1 das instru��es ---> 10   4
// linha 1 das instru��es ---> 10   4
// linha 1 das instru��es ---> 10   4
// linha 1 das instru��es ---> 10   4
// linha 1 das instru��es ---> 10   4
//         nome do Pagador ---> 15   8
//     endere�o do Pagador ---> 15   8
//             CEP Pagador ---> 15   8
//       cidade do Pagador ---> 15   8
//       estado do Pagador ---> 15   8
//          CGC do Pagador ---> 15   8

unit Unit26;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, smallfunc_xe, Menus, ShellApi
  ;

type
  TForm26 = class(TForm)
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label17: TLabel;
    MaskEdit42: TMaskEdit;
    MaskEdit43: TMaskEdit;
    Label18: TLabel;
    Label19: TLabel;
    MaskEdit44: TMaskEdit;
    Label20: TLabel;
    MaskEdit45: TMaskEdit;
    MaskEdit46: TMaskEdit;
    Label32: TLabel;
    Label33: TLabel;
    medtNossoNu: TMaskEdit;
    MaskEdit48: TMaskEdit;
    Label34: TLabel;
    MaskEdit49: TMaskEdit;
    Label39: TLabel;
    MaskEdit50: TMaskEdit;
    lblCodConvenio: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    cboBancos: TComboBox;
    GroupBox1: TGroupBox;
    Label27: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    MaskEdit41: TMaskEdit;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    MaskEdit7: TMaskEdit;
    MaskEdit8: TMaskEdit;
    MaskEdit9: TMaskEdit;
    MaskEdit10: TMaskEdit;
    MaskEdit11: TMaskEdit;
    MaskEdit12: TMaskEdit;
    MaskEdit13: TMaskEdit;
    MaskEdit14: TMaskEdit;
    MaskEdit15: TMaskEdit;
    MaskEdit16: TMaskEdit;
    MaskEdit17: TMaskEdit;
    MaskEdit18: TMaskEdit;
    MaskEdit19: TMaskEdit;
    MaskEdit20: TMaskEdit;
    MaskEdit21: TMaskEdit;
    MaskEdit22: TMaskEdit;
    MaskEdit23: TMaskEdit;
    MaskEdit24: TMaskEdit;
    MaskEdit25: TMaskEdit;
    MaskEdit26: TMaskEdit;
    MaskEdit27: TMaskEdit;
    MaskEdit28: TMaskEdit;
    MaskEdit29: TMaskEdit;
    MaskEdit30: TMaskEdit;
    MaskEdit31: TMaskEdit;
    MaskEdit32: TMaskEdit;
    MaskEdit33: TMaskEdit;
    MaskEdit34: TMaskEdit;
    MaskEdit35: TMaskEdit;
    MaskEdit36: TMaskEdit;
    MaskEdit37: TMaskEdit;
    MaskEdit38: TMaskEdit;
    MaskEdit39: TMaskEdit;
    MaskEdit40: TMaskEdit;
    MaskEdit400: TMaskEdit;
    MaskEdit51: TMaskEdit;
    chkCNAB400: TCheckBox;
    chkCNAB240: TCheckBox;
    Label35: TLabel;
    cboFormato: TComboBox;
    Label36: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure MaskEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit45Change(Sender: TObject);
    procedure cboBancosChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MaskEdit46Exit(Sender: TObject);
    procedure MaskEdit42Exit(Sender: TObject);
    procedure chkCNAB400KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chkCNAB240KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cboBancosExit(Sender: TObject);
  private
    procedure SelectBanco;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form26: TForm26;

implementation

uses Unit25, Unit7, Mais, uDialogs, uFuncoesBancoDados;

{$R *.DFM}


function LimpaDeixando(pP1, pP2:String):String;
var
   I:Integer;
begin
   Result:='';
   for I := 1 to length(pP1) do
   begin
     if Pos(Copy(pP1,I,1),pP2) <> 0 then
        Result:=Result+Copy(pP1,I,1);
   end;
end;



procedure TForm26.FormActivate(Sender: TObject);
var
  sFormatoBoleto : string;
begin
  Form26.Caption := 'Configura��o do '+AnsiLowercase(Form25.Caption);

  //Mauricio Parizotto 2024-02-05
  sFormatoBoleto := ExecutaComandoEscalar(Form7.ibDataSet7.Transaction,
                                          ' Select Coalesce(FORMATOBOLETO,''Padr�o'') '+
                                          ' From BANCOS '+
                                          ' Where NOME ='+QuotedStr(Form1.sBancoBoleto));

  cboFormato.ItemIndex := cboFormato.Items.IndexOf(sFormatoBoleto);
end;


procedure TForm26.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  //if Key = VK_DOWN   then Perform(Wm_NextDlgCtl,0,0);
  //if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
  //Mauricio Parizotto 2023-09-29
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('cr_bloqueto_preenchendo.htm')));
end;

procedure TForm26.MaskEdit45Change(Sender: TObject);
var
  sParcela : String;
begin
  try
    if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then // SANTANDER
    begin
      lblCodConvenio.Caption := 'c�digo de transmiss�o';
    end else
    if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '077') then
    begin
      lblCodConvenio.Caption := 'n�mero da opera��o (X)'; //Mauricio Parizotto 2024-02-22
    end else
    begin
      lblCodConvenio.Caption := 'c�digo do conv�nio (X)';
    end;
  except
  end;

  try
    MaskEdit48.Text := UpperCase(StrTran(MaskEdit45.Text,'N','W'));

    try
      if Pos('AAMMDD',MaskEdit48.Text) <> 0 then
        MaskEdit48.Text := StrTran(MaskEdit48.Text,'AAMMDD',
          (Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2)+
          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)+
          Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2))); // Data de vencimento AAMMDD
    except
    end;

    if Pos('K',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('K',Length(LimpaDeixando(MaskEdit48.Text,'K'))),
        Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit43.Text)),Length(LimpaDeixando(MaskEdit48.Text,'K')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'K'))));

    if Pos('X',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('X',Length(LimpaDeixando(MaskEdit48.Text,'X'))),
        Copy(StrZero(StrtoFloat('0'+LimpaNumero(MaskEdit50.Text)),Length(LimpaDeixando(MaskEdit48.Text,'X')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'X'))));


    if Pos('A',MaskEdit48.Text) <> 0 then
    begin
      if Length(LimpaDeixando(MaskEdit48.Text,'A')) = Length( LimpaNumero(Copy(MaskEdit44.Text+'    ',1,Length(LimpaDeixando(MaskEdit48.Text,'A'))))) then
      begin
        MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('A',Length(LimpaDeixando(MaskEdit48.Text,'A'))),Copy(MaskEdit44.Text,1,Length(LimpaDeixando(MaskEdit48.Text,'A'))));
      end else
      begin
        MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('A',Length(LimpaDeixando(MaskEdit48.Text,'A'))),
        Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit44.Text)),Length(LimpaDeixando(MaskEdit48.Text,'A')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'A'))));
      end;
    end;

    if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '237') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '041') then // BRADESCO OU BANRISUL
    begin
      if Pos('C',MaskEdit48.Text) <> 0 then
        MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('C',Length(LimpaDeixando(MaskEdit48.Text,'C'))),
          Copy( LimpaNumero(MaskEdit46.Text)+Replicate('0',Length(LimpaDeixando(MaskEdit48.Text,'C'))),1,Length(LimpaDeixando(MaskEdit48.Text,'C'))));
    end else
    begin
      if Pos('C',MaskEdit48.Text) <> 0 then
        MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('C',Length(LimpaDeixando(MaskEdit48.Text,'C'))),
          Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit46.Text)),Length(LimpaDeixando(MaskEdit48.Text,'C')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'C'))));
    end;

    if Pos('PP',MaskEdit48.Text) <> 0 then
    begin
      if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
      begin
        sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em n�mero
      end else
      begin
        sParcela := '01';
      end;

      MaskEdit48.Text := StrTran(MaskEdit48.Text,'PP',sParcela);
    end;

    {Sandro Silva 2024-05-24 inicio
    if Pos('N',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('N',Length(LimpaDeixando(MaskEdit48.Text,'N'))),
             Right(StrZero(StrtoInt('0'+LimpaNumero(medtNossoNu.Text)),Length(LimpaDeixando(MaskEdit48.Text,'N')),0),Length(LimpaDeixando(MaskEdit48.Text,'N'))));
    if Pos('J',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('J',Length(LimpaDeixando(MaskEdit48.Text,'J'))),
       Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit49.Text)),Length(LimpaDeixando(MaskEdit48.Text,'J')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'J'))));
    if Pos('YY',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, 'YY',Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)), 3, 2));

    if Pos('W',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('W',Length(LimpaDeixando(MaskEdit48.Text,'W'))),
       Right(StrZero(StrtoInt('0'+LimpaNumero(medtNossoNu.Text)),15,0),Length(LimpaDeixando(MaskEdit48.Text,'W'))));
    }
    if Pos('N',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, Replicate('N', Length(LimpaDeixando(MaskEdit48.Text, 'N'))),
                         Right(StrZero(StrToInt64Def(LimpaNumero(medtNossoNu.Text), 0), Length(LimpaDeixando(MaskEdit48.Text, 'N')), 0), Length(LimpaDeixando(MaskEdit48.Text, 'N'))));
    if Pos('J',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, Replicate('J', Length(LimpaDeixando(MaskEdit48.Text,'J'))),
                         Copy(StrZero(StrToInt64Def(LimpaNumero(MaskEdit49.Text), 0), Length(LimpaDeixando(MaskEdit48.Text, 'J')), 0), 1, Length(LimpaDeixando(MaskEdit48.Text, 'J'))));
    if Pos('YY',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, 'YY', Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)), 3, 2));
    if Pos('W',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, Replicate('W', Length(LimpaDeixando(MaskEdit48.Text, 'W'))),
                         Right(StrZero(StrToInt64Def(LimpaNumero(medtNossoNu.Text), 0), 15, 0), Length(LimpaDeixando(MaskEdit48.Text, 'W'))));
    {Sandro Silva 2024-05-24 fim}

    if Pos('d',MaskEdit45.Text) <> 0 then
    begin
      // descrobre qual o caracter anterior ao "d" minusculo
      // descrobre a 1_ posi��o deste caracter
      // Descobre a �ltima - o 1_ da a posi��o para o Copy(1_,�ltimo-1_);
      MaskEdit48.Text :=
        StrTran(MaskEdit48.Text,'D',Modulo_11(Copy(MaskEdit48.Text,
        Pos(Copy(MaskEdit45.Text,Pos('d',MaskEdit45.Text)-1,1),MaskEdit45.Text)
           ,
           (Pos('d',MaskEdit45.Text)) - (Pos(Copy(MaskEdit45.Text,Pos('d',MaskEdit45.Text)-1,1),MaskEdit45.Text))
           )));
    end;

    if Pos('m',MaskEdit45.Text) <> 0 then
    begin
       // Modulo M somente para �ta�
       MaskEdit48.Text := StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(Form26.MaskEdit44.Text+'0000',1,4)+Copy(Form26.MaskEdit46.Text+'00000',1,5)+Copy(Form26.MaskEdit43.Text+'000',1,3)+Right('00000000'+Form26.medtNossoNu.Text,8)));
    end;

    if Pos('m',MaskEdit45.Text) <> 0 then
    begin
      // descrobre qual o caracter anterior ao "m" minusculo
      // descrobre a 1_ posi��o deste caracter
      // Descobre a �ltima - o 1_ da a posi��o para o Copy(1_,�ltimo-1_);
      MaskEdit48.Text :=
        StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(MaskEdit48.Text,
        Pos(Copy(MaskEdit45.Text,Pos('m',MaskEdit45.Text)-1,1),MaskEdit45.Text)
           ,
           (Pos('m',MaskEdit45.Text)) - (Pos(Copy(MaskEdit45.Text,Pos('m',MaskEdit45.Text)-1,1),MaskEdit45.Text))
           )));
    end;

    {Sandro Silva 2024-05-24 inicio
    if Pos('V',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'V',Modulo_11(LimpaNumero(MaskEdit44.Text)+LimpaNumero(MaskEdit46.Text)+Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'2'+Right(StrZero(StrtoInt('0'+LimpaNumero(medtNossoNu.Text)),15,0),5)));

    if Pos('S',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'S',
     Modulo_sicoob(
                            Copy(Form26.MaskEdit44.Text,1,4)+
                            StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),10,0)+
                            StrZero(StrtoInt('0'+LimpaNumero(Form26.medtNossoNu.Text)),7,0)));
    }
    if Pos('V',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text, 'V', Modulo_11(LimpaNumero(MaskEdit44.Text) + LimpaNumero(MaskEdit46.Text) + Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)), 3, 2) + '2' + Right(StrZero(StrToInt64Def(LimpaNumero(medtNossoNu.Text), 0), 15, 0), 5)));

    if Pos('S',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'S',
                         Modulo_sicoob(
                            Copy(Form26.MaskEdit44.Text, 1, 4) +
                            StrZero(StrToInt64Def(LimpaNumero(Form26.MaskEdit46.Text), 0), 10, 0) +
                            StrZero(StrToInt64Def(LimpaNumero(Form26.medtNossoNu.Text), 0), 7, 0)));
    {Sandro Silva 2024-05-24 fim}

    if Pos('M',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(MaskEdit48.Text,1,Pos('M',MaskEdit48.Text)-1)));
    try
      if Pos('I',MaskEdit48.Text) <> 0 then
      begin
        {Mauricio Parizotto 2024-04-18
        MaskEdit48.Text := StrTran(MaskEdit48.Text,'I',Modulo_10(
                                                                  AllTrim(MaskEdit44.Text)           // 4 Agencia
                                                                  +AllTrim(MaskEdit46.Text)          // 5 conta
                                                                  +AllTrim(MaskEdit43.Text)          // 3 Carteira
                                                                  +Right(AllTrim(medtNossoNu.Text),8) // 8 Nosso N�mero
                                                                 ));
        }
        {Sandro Silva 2024-09-10 inicio
        MaskEdit48.Text := StrTran(MaskEdit48.Text,'I',Modulo_10(
                                                                  Copy(AllTrim(MaskEdit44.Text),1,4)  // Agencia (sem dv)
                                                                  +AllTrim(MaskEdit43.Text)           // Carteira
                                                                  +AllTrim(medtNossoNu.Text)          // Nosso N�mero
                                                                 ));
        }
        if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '077') then
        begin
          MaskEdit48.Text := StrTran(MaskEdit48.Text,'I',Modulo_10(
                                                                  Copy(AllTrim(MaskEdit44.Text),1,4)    // Agencia (sem dv)
                                                                  +AllTrim(MaskEdit43.Text)             // Carteira
                                                                  +Right(AllTrim(medtNossoNu.Text), 10) // Nosso N�mero
                                                                 ));
        end
        else
        begin
          MaskEdit48.Text := StrTran(MaskEdit48.Text,'I',Modulo_10(
                                                                  Copy(AllTrim(MaskEdit44.Text),1,4)  // Agencia (sem dv)
                                                                  +AllTrim(MaskEdit43.Text)           // Carteira
                                                                  +AllTrim(medtNossoNu.Text)          // Nosso N�mero
                                                                 ));
        end;
        {Sandro Silva 2024-09-10 fim}
      end;

    except

    end;
    try
      if Pos('U',MaskEdit48.Text) <> 0 then
        MaskEdit48.Text := StrTran(MaskEdit48.Text,'U',Modulo_11('1'+Right(AllTrim(medtNossoNu.Text),11))); // Nosso N�mero acrescido de 1 a esquerda 1/NNNNNNNNNNN
    except
    end;

    if Pos('D',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'D',Modulo_11(LimpaNumero(Copy(MaskEdit48.Text,1,Pos('D',MaskEdit48.Text)-1))));

    if Pos('BB',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'BB',Modulo_Duplo_Digito_Banrisul(LimpaNumero(MaskEdit48.Text)));

  except
    on E: Exception do
    begin
      //Application.MessageBox(pChar('Mascara do campo livre, inv�lida. '+E.Message),'Aten��o',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-24
      MensagemSistema('Mascara do campo livre, inv�lida. '+E.Message
                      ,msgErro);
    end;
  end;
end;

procedure TForm26.cboBancosChange(Sender: TObject);
begin
  SelectBanco;
end;

procedure TForm26.Button2Click(Sender: TObject);
begin
  if (not chkCNAB400.Checked) and (not chkCNAB240.Checked) then
  begin
    //Application.MessageBox(pChar('Informe se � CNAB400 ou CNAB240.'),'Aten��o',mb_Ok + MB_ICONWARNING); Mauricio Parizotto 2023-10-25
    MensagemSistema('Informe se � CNAB400 ou CNAB240.',msgAtencao);
    Exit;
  end;

  //Mauricio Parizotto 2024-02-05
  ExecutaComando(' Update BANCOS '+
                 '   set FORMATOBOLETO = '+QuotedStr(cboFormato.Text)+
                 ' Where NOME ='+QuotedStr(Form1.sBancoBoleto),
                 Form7.ibDataSet7.Transaction);

  Form25.sFormatoBoleto := cboFormato.Text;

  Close;
end;

procedure TForm26.MaskEdit46Exit(Sender: TObject);
begin
  if (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '033') or (Copy(AllTrim(Form26.MaskEdit42.Text),1,3) = '353') then
  begin
    if LimpaNumero(MaskEdit46.Text) <> '' then
    begin
      if Length(LimpaNumero(MaskEdit46.Text)) <= 8 then
      begin
        MaskEdit46.Text := Right('00000000'+LimpaNumero(MaskEdit46.Text),8);
      end;
    end;
  end;
end;

procedure TForm26.MaskEdit42Exit(Sender: TObject);
begin
  if (Alltrim(Form26.MaskEdit45.Text) = '') or (Alltrim(Form26.MaskEdit45.Text) = '0000000000000000000000000') then
  begin
    if Length(LimpaNumero(MaskEdit42.Text)) >= 3 then
    begin
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '085' then MaskEdit45.Text := 'XXXXXXccccccccNNNNNNNNNKK';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '756' then MaskEdit45.Text := '1aaaa02cccccccnnnnnnnS001';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '748' then MaskEdit45.Text := '11YY2NNNNNVAAAAAACCCCC10D';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '104' then MaskEdit45.Text := 'CCCCCCC00010004NNNNNNNNND';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '001' then MaskEdit45.Text := '000000xxxxxxxnnnnnnnnnnkk';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '237' then MaskEdit45.Text := 'AAAAKKNNNNNNNNNNNCCCCCCC0';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '033' then MaskEdit45.Text := '9ccccccc0000nnnnnnnnd0kkk';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '353' then MaskEdit45.Text := '9ccccccc0000nnnnnnnnd0kkk';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '041' then MaskEdit45.Text := '21aaaacccccccnnnnnnnn40bb';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '341' then MaskEdit45.Text := 'KKKNNNNNNNNmAAAACCCCCC000';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '077' then MaskEdit45.Text := 'AAAAKKKXXXXXXXNNNNNNNNNNI'; // Mauricio Parizotto 2024-02-19
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '409' then MaskEdit45.Text := '5???????00NNNNNNNNNNNNNNd';
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '136' then MaskEdit45.Text := 'AAAACCCCCCCCCCNNNNNNNNNNN'; // Mauricio Parizotto 2023-12-07

      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS001' then Form26.MaskEdit45.Text := '1aaaa01cccccccnnnnnnnS0PP';
      if Form26.MaskEdit45.Text = '1aaaa02cccccccnnnnnnnS001' then Form26.MaskEdit45.Text := '1aaaa02cccccccnnnnnnnS0PP';

      if Form26.MaskEdit45.Text = 'XXXXXXccccccccNNNNNNNNNKK' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('AILOS');
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('SICREDI');
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('SICOOB');
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Caixa Econ�mica');
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Banco do Brasil 7 posi��es');
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Banco do Brasil 6 posi��es');
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Bradesco');
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Santander');
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40bb' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Banrisul');
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Ita�');
      if Form26.MaskEdit45.Text = 'AAAAKKKXXXXXXXNNNNNNNNNNI' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Inter'); //Mauricio Parizotto 2024-02-19
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Unibanco');
      if Form26.MaskEdit45.Text = 'AAAACCCCCCCCCCNNNNNNNNNNN' then cboBancos.ItemIndex := cboBancos.Items.IndexOf('Unicred'); // Mauricio Parizotto 2023-12-07
    end;
  end;
end;

procedure TForm26.chkCNAB400KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm26.chkCNAB240KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm26.FormShow(Sender: TObject);
begin
  if cboBancos.CanFocus then
    cboBancos.SetFocus;

  SelectBanco;
end;


procedure TForm26.SelectBanco;
begin
  chkCNAB400.Enabled := False;
  chkCNAB240.Enabled := False;

  if cboBancos.Text = 'AILOS' then
  begin
    MaskEdit45.Text := 'XXXXXXccccccccNNNNNNNNNKK';
    chkCNAB240.Checked := True;
    chkCNAB400.Checked := False;
  end;

  if cboBancos.Text = 'SICOOB' then
  begin
    MaskEdit45.Text := '1aaaa01cccccccnnnnnnnS0PP';
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'SICREDI' then
  begin
    MaskEdit45.Text := '11YY2NNNNNVAAAAAACCCCC10D';
    chkCNAB240.Checked := True;
    chkCNAB400.Checked := False;
  end;

  if cboBancos.Text = 'Caixa Econ�mica' then
  begin
    MaskEdit45.Text := 'CCCCCCC00010004NNNNNNNNND';
    chkCNAB400.Checked := True;
    chkCNAB240.Checked := False;
  end;

  if cboBancos.Text = 'Banco do Brasil 7 posi��es' then
  begin
    MaskEdit45.Text := '000000xxxxxxxnnnnnnnnnnkk';
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'Banco do Brasil 6 posi��es' then
  begin
    MaskEdit45.Text := 'XXXXXXnnnnnaaaa000ccccckk';
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'Bradesco' then
  begin
    MaskEdit45.Text := 'AAAAKKNNNNNNNNNNNCCCCCCC0';
    chkCNAB400.Checked := True;
    chkCNAB240.Checked := False;
  end;

  if cboBancos.Text = 'Santander' then
  begin
    MaskEdit45.Text := '9ccccccc0000nnnnnnnnd0kkk';
    chkCNAB400.Checked := True;
    chkCNAB240.Checked := False;
  end;

  if cboBancos.Text = 'Banrisul' then
  begin
    MaskEdit45.Text := '21aaaacccccccnnnnnnnn40bb';
    //Mauricio Parizotto 2023-11-01
    //chkCNAB400.Checked := True;
    //chkCNAB240.Checked := False;
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'Ita�' then
  begin
    MaskEdit45.Text := 'KKKNNNNNNNNmAAAACCCCCC000';
    //Mauricio Parizotto 2023-10-23
    //chkCNAB400.Checked := True;
    //chkCNAB240.Checked := False;
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  //Mauricio Parizotto 2024-02-19
  if cboBancos.Text = 'Inter' then
  begin
    MaskEdit45.Text := 'AAAAKKKXXXXXXXNNNNNNNNNNI';
    chkCNAB400.Checked := True;
    chkCNAB240.Checked := False;
  end;

  if cboBancos.Text = 'Unibanco' then
  begin
    MaskEdit45.Text := '5???????00NNNNNNNNNNNNNNd';
    chkCNAB400.Checked := True;
    chkCNAB240.Checked := False;
  end;

  if cboBancos.Text = 'Unicred' then
  begin
    MaskEdit45.Text := 'AAAACCCCCCCCCCNNNNNNNNNNN';
    chkCNAB400.Checked := False;
    chkCNAB240.Checked := True;
  end;
end;

procedure TForm26.cboBancosExit(Sender: TObject);
begin
  SelectBanco;
end;

end.

