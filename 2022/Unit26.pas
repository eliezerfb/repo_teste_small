//     local de pagamento ---> 1    4
//             vencimento ---> 1   51
//         data documento ---> 5    4
//              documento ---> 5   15
//      espécie documento ---> 5   32
//                 aceite ---> 5   36
//             processado ---> 5   39
//     valor do documento ---> 6   52
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
// linha 1 das instruções ---> 10   4
//         nome do Pagador ---> 15   8
//     endereço do Pagador ---> 15   8
//             CEP Pagador ---> 15   8
//       cidade do Pagador ---> 15   8
//       estado do Pagador ---> 15   8
//          CGC do Pagador ---> 15   8

unit Unit26;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, SmallFunc, Menus, ShellApi, HtmlHelp;

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
    MaskEdit47: TMaskEdit;
    MaskEdit48: TMaskEdit;
    Label34: TLabel;
    MaskEdit49: TMaskEdit;
    Label39: TLabel;
    MaskEdit50: TMaskEdit;
    Label40: TLabel;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form26: TForm26;

implementation

uses Unit25, Unit7, Mais;

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
begin
  Form26.Caption := 'Configuração do '+AnsiLowercase(Form25.Caption);
end;


procedure TForm26.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN   then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
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
      Label40.Caption := 'código de transmissão';
    end else
    begin
      Label40.Caption := 'código do convênio (X)';
    end;
  except
  end;

  try
    MaskEdit48.Text := UpperCase(StrTran(MaskEdit45.Text,'N','W'));

    try
      if Pos('AAMMDD',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'AAMMDD',
      (Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),9,2)+
      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),4,2)+
      Copy(DateToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,2))); // Data de vencimento AAMMDD
    except
    end;

    if Pos('K',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('K',Length(LimpaDeixando(MaskEdit48.Text,'K'))),
       Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit43.Text)),Length(LimpaDeixando(MaskEdit48.Text,'K')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'K'))));

    if Pos('X',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('X',Length(LimpaDeixando(MaskEdit48.Text,'X'))),
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
      if Pos('C',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('C',Length(LimpaDeixando(MaskEdit48.Text,'C'))),
      Copy( LimpaNumero(MaskEdit46.Text)+Replicate('0',Length(LimpaDeixando(MaskEdit48.Text,'C'))),1,Length(LimpaDeixando(MaskEdit48.Text,'C'))));
    end else
    begin
      if Pos('C',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('C',Length(LimpaDeixando(MaskEdit48.Text,'C'))),
      Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit46.Text)),Length(LimpaDeixando(MaskEdit48.Text,'C')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'C'))));
    end;

    if Pos('PP',MaskEdit48.Text) <> 0 then
    begin
      if Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))]) >= 64 then
      begin
        sParcela := StrZero((Ord(Form7.ibDataSet7DOCUMENTO.AsString[Length(Trim(Form7.ibDataSet7DOCUMENTO.AsString))])-64),2,0); //converte a letra em número
      end else
      begin
        sParcela := '01';
      end;

      MaskEdit48.Text := StrTran(MaskEdit48.Text,'PP',sParcela);
    end;

    if Pos('N',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('N',Length(LimpaDeixando(MaskEdit48.Text,'N'))),
             Right(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit47.Text)),Length(LimpaDeixando(MaskEdit48.Text,'N')),0),Length(LimpaDeixando(MaskEdit48.Text,'N'))));
    if Pos('J',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('J',Length(LimpaDeixando(MaskEdit48.Text,'J'))),
       Copy(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit49.Text)),Length(LimpaDeixando(MaskEdit48.Text,'J')),0),1,Length(LimpaDeixando(MaskEdit48.Text,'J'))));
    if Pos('YY',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'YY',Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2));

    if Pos('W',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,Replicate('W',Length(LimpaDeixando(MaskEdit48.Text,'W'))),
       Right(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit47.Text)),15,0),Length(LimpaDeixando(MaskEdit48.Text,'W'))));

    if Pos('d',MaskEdit45.Text) <> 0 then
    begin
       // descrobre qual o caracter anterior ao "d" minusculo
       // descrobre a 1_ posição deste caracter
       // Descobre a última - o 1_ da a posição para o Copy(1_,último-1_);
       MaskEdit48.Text :=
       StrTran(MaskEdit48.Text,'D',Modulo_11(Copy(MaskEdit48.Text,
       Pos(Copy(MaskEdit45.Text,Pos('d',MaskEdit45.Text)-1,1),MaskEdit45.Text)
           ,
           (Pos('d',MaskEdit45.Text)) - (Pos(Copy(MaskEdit45.Text,Pos('d',MaskEdit45.Text)-1,1),MaskEdit45.Text))
           )));
    end;

    if Pos('m',MaskEdit45.Text) <> 0 then
    begin
       // Modulo M somente para ítaú
       MaskEdit48.Text := StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(Form26.MaskEdit44.Text+'0000',1,4)+Copy(Form26.MaskEdit46.Text+'00000',1,5)+Copy(Form26.MaskEdit43.Text+'000',1,3)+Right('00000000'+Form26.MaskEdit47.Text,8)));
    end;

    if Pos('m',MaskEdit45.Text) <> 0 then
    begin
       // descrobre qual o caracter anterior ao "m" minusculo
       // descrobre a 1_ posição deste caracter
       // Descobre a última - o 1_ da a posição para o Copy(1_,último-1_);
       MaskEdit48.Text :=
       StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(MaskEdit48.Text,
       Pos(Copy(MaskEdit45.Text,Pos('m',MaskEdit45.Text)-1,1),MaskEdit45.Text)
           ,
           (Pos('m',MaskEdit45.Text)) - (Pos(Copy(MaskEdit45.Text,Pos('m',MaskEdit45.Text)-1,1),MaskEdit45.Text))
           )));
    end;

    if Pos('V',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'V',Modulo_11(LimpaNumero(MaskEdit44.Text)+LimpaNumero(MaskEdit46.Text)+Copy(IntToStr(Year(Form7.ibDataSet7EMISSAO.AsDateTime)),3,2)+'2'+Right(StrZero(StrtoInt('0'+LimpaNumero(MaskEdit47.Text)),15,0),5)));

    if Pos('S',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'S',
     Modulo_sicoob(
                            Copy(Form26.MaskEdit44.Text,1,4)+
                            StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit46.Text)),10,0)+
                            StrZero(StrtoInt('0'+LimpaNumero(Form26.MaskEdit47.Text)),7,0)));
    
    if Pos('M',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'M',Modulo_10(Copy(MaskEdit48.Text,1,Pos('M',MaskEdit48.Text)-1)));
    try
      if Pos('I',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'I',Modulo_10(
                                                                                                      AllTrim(MaskEdit44.Text)           // 4 Agencia
                                                                                                      +AllTrim(MaskEdit46.Text)          // 5 conta
                                                                                                      +AllTrim(MaskEdit43.Text)          // 3 Carteira
                                                                                                      +Right(AllTrim(MaskEdit47.Text),8) // 8 Nosso Número
                                                                                                     ));
    except end;
    try
      if Pos('U',MaskEdit48.Text) <> 0 then MaskEdit48.Text := StrTran(MaskEdit48.Text,'U',Modulo_11('1'+Right(AllTrim(MaskEdit47.Text),11))); // Nosso Número acrescido de 1 a esquerda 1/NNNNNNNNNNN
    except
    end;

    if Pos('D',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'D',Modulo_11(LimpaNumero(Copy(MaskEdit48.Text,1,Pos('D',MaskEdit48.Text)-1))));

    if Pos('BB',MaskEdit48.Text) <> 0 then
      MaskEdit48.Text := StrTran(MaskEdit48.Text,'BB',Modulo_Duplo_Digito_Banrisul(LimpaNumero(MaskEdit48.Text)));
    
  except
    on E: Exception do
    begin
      Application.MessageBox(pChar('Mascara do campo livre, inválida. '+E.Message),'Atenção',mb_Ok + MB_ICONWARNING);
    end;
  end;
end;

procedure TForm26.cboBancosChange(Sender: TObject);
begin
  {Mauricio Parizotto 2023-09-29 Inicio
  if cboBancos.Text = 'AILOS - Sistema de Cooperativas de Crédito'   then Form26.MaskEdit45.Text := 'XXXXXXccccccccNNNNNNNNNKK';
  if cboBancos.Text = 'SICOOB - Sem registro'                        then Form26.MaskEdit45.Text := '1aaaa02cccccccnnnnnnnS0PP';
  if cboBancos.Text = 'SICOOB - Com registro'                        then Form26.MaskEdit45.Text := '1aaaa01cccccccnnnnnnnS0PP';
  if cboBancos.Text = 'SICREDI - Com registro'                       then Form26.MaskEdit45.Text := '11YY2NNNNNVAAAAAACCCCC10D';
  if cboBancos.Text = 'Caixa Econômica - Com registro'               then Form26.MaskEdit45.Text := 'CCCCCCC00010004NNNNNNNNND';
  if cboBancos.Text = 'Caixa Econômica - Sem registro'               then Form26.MaskEdit45.Text := 'CCCCCCC00020004NNNNNNNNND';
  if cboBancos.Text = 'Banco do Brasil - Com registro 7 posições'    then Form26.MaskEdit45.Text := '000000xxxxxxxnnnnnnnnnnkk';
  if cboBancos.Text = 'Banco do Brasil - Com registro 6 posições'    then Form26.MaskEdit45.Text := 'XXXXXXnnnnnaaaa000ccccckk';
  if cboBancos.Text = 'Banco do Brasil - Sem registro'               then Form26.MaskEdit45.Text := 'xxxxxxnnnnnnnnnnnnnnnnnkk';
  if cboBancos.Text = 'Bradesco - Com registro'                      then Form26.MaskEdit45.Text := 'AAAAKKNNNNNNNNNNNCCCCCCC0';
  if cboBancos.Text = 'Santander - Com registro'                     then Form26.MaskEdit45.Text := '9ccccccc0000nnnnnnnnd0kkk';
  if cboBancos.Text = 'Banrisul - Com registro'                      then Form26.MaskEdit45.Text := '21aaaacccccccnnnnnnnn40bb';
  if cboBancos.Text = 'Itaú - Com registro'                          then Form26.MaskEdit45.Text := 'KKKNNNNNNNNmAAAACCCCCC000';
  if cboBancos.Text = 'Unibanco'                                     then Form26.MaskEdit45.Text := '5???????00NNNNNNNNNNNNNNd';
  }

  chkCNAB400.Enabled := False;
  chkCNAB240.Enabled := False;

  chkCNAB400.Checked := False;
  chkCNAB240.Checked := False;

  if cboBancos.Text = 'AILOS - Sistema de Cooperativas de Crédito' then
  begin
    MaskEdit45.Text := 'XXXXXXccccccccNNNNNNNNNKK';
    chkCNAB240.Checked := True;
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
  end;

  if cboBancos.Text = 'Caixa Econômica' then
  begin
    MaskEdit45.Text := 'CCCCCCC00010004NNNNNNNNND';
    chkCNAB400.Checked := True;
  end;

  if cboBancos.Text = 'Banco do Brasil 7 posições' then
  begin
    MaskEdit45.Text := '000000xxxxxxxnnnnnnnnnnkk';
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'Banco do Brasil 6 posições' then
  begin
    MaskEdit45.Text := 'XXXXXXnnnnnaaaa000ccccckk';
    chkCNAB400.Enabled := True;
    chkCNAB240.Enabled := True;
  end;

  if cboBancos.Text = 'Bradesco' then
  begin
    MaskEdit45.Text := 'AAAAKKNNNNNNNNNNNCCCCCCC0';
    chkCNAB400.Checked := True;
  end;

  if cboBancos.Text = 'Santander' then
  begin
    MaskEdit45.Text := '9ccccccc0000nnnnnnnnd0kkk';
    chkCNAB400.Checked := True;
  end;

  if cboBancos.Text = 'Banrisul' then
  begin
    MaskEdit45.Text := '21aaaacccccccnnnnnnnn40bb';
    chkCNAB400.Checked := True;
  end;

  if cboBancos.Text = 'Itaú' then
  begin
    MaskEdit45.Text := 'KKKNNNNNNNNmAAAACCCCCC000';
    chkCNAB400.Checked := True;
  end;

  if cboBancos.Text = 'Unibanco' then
  begin
    MaskEdit45.Text := '5???????00NNNNNNNNNNNNNNd';
    chkCNAB400.Checked := True;
  end;

  {Mauricio Parizotto 2023-09-29 Fim}
end;

procedure TForm26.Button2Click(Sender: TObject);
begin
  if (not chkCNAB400.Checked) and (not chkCNAB240.Checked) then
  begin
    Application.MessageBox(pChar('Informe se é CNAB400 ou CNAB240.'),'Atenção',mb_Ok + MB_ICONWARNING);
    Exit;
  end;

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
      if Copy(AllTrim(MaskEdit42.Text),1,3) = '409' then MaskEdit45.Text := '5???????00NNNNNNNNNNNNNNd';

      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS001' then Form26.MaskEdit45.Text := '1aaaa01cccccccnnnnnnnS0PP';
      if Form26.MaskEdit45.Text = '1aaaa02cccccccnnnnnnnS001' then Form26.MaskEdit45.Text := '1aaaa02cccccccnnnnnnnS0PP';

      {
      if Form26.MaskEdit45.Text = 'XXXXXXccccccccNNNNNNNNNKK' then cboBancos.Text := 'AILOS - Sistema de Cooperativas de Crédito';
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then cboBancos.Text := 'SICREDI - Com registro';
      if Form26.MaskEdit45.Text = '1aaaa02cccccccnnnnnnnS0PP' then cboBancos.Text := 'SICOOB - Sem registro';
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then cboBancos.Text := 'SICOOB - Com registro';
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then cboBancos.Text := 'Caixa Econômica - Com registro';
      if Form26.MaskEdit45.Text = 'CCCCCCC00020004NNNNNNNNND' then cboBancos.Text := 'Caixa Econômica - Sem registro';
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then cboBancos.Text := 'Banco do Brasil - Com registro 7 posições';
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then cboBancos.Text := 'Banco do Brasil - Com registro 6 posições';
      if Form26.MaskEdit45.Text = 'xxxxxxnnnnnnnnnnnnnnnnnkk' then cboBancos.Text := 'Banco do Brasil - Sem registro';
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then cboBancos.Text := 'Bradesco - Com registro';
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then cboBancos.Text := 'Santander - Com registro';
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40bb' then cboBancos.Text := 'Banrisul - Com registro';
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then cboBancos.Text := 'Itaú - Com registro';
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then cboBancos.Text := 'Unibanco';
      Mauricio Parizotto 2023-10-02}

      if Form26.MaskEdit45.Text = 'XXXXXXccccccccNNNNNNNNNKK' then cboBancos.Text := 'AILOS - Sistema de Cooperativas de Crédito';
      if Form26.MaskEdit45.Text = '11YY2NNNNNVAAAAAACCCCC10D' then cboBancos.Text := 'SICREDI';
      if Form26.MaskEdit45.Text = '1aaaa01cccccccnnnnnnnS0PP' then cboBancos.Text := 'SICOOB';
      if Form26.MaskEdit45.Text = 'CCCCCCC00010004NNNNNNNNND' then cboBancos.Text := 'Caixa Econômica';
      if Form26.MaskEdit45.Text = '000000xxxxxxxnnnnnnnnnnkk' then cboBancos.Text := 'Banco do Brasil 7 posições';
      if Form26.MaskEdit45.Text = 'XXXXXXnnnnnaaaa000ccccckk' then cboBancos.Text := 'Banco do Brasil 6 posições';
      if Form26.MaskEdit45.Text = 'AAAAKKNNNNNNNNNNNCCCCCCC0' then cboBancos.Text := 'Bradesco';
      if Form26.MaskEdit45.Text = '9ccccccc0000nnnnnnnnd0kkk' then cboBancos.Text := 'Santander';
      if Form26.MaskEdit45.Text = '21aaaacccccccnnnnnnnn40bb' then cboBancos.Text := 'Banrisul';
      if Form26.MaskEdit45.Text = 'KKKNNNNNNNNmAAAACCCCCC000' then cboBancos.Text := 'Itaú';
      if Form26.MaskEdit45.Text = '5???????00NNNNNNNNNNNNNNd' then cboBancos.Text := 'Unibanco';
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
end;

end.

