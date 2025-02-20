unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, SmallFunc_xe, Buttons;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    MaskEdit1: TMaskEdit;
    Button3: TBitBtn;
    Button1: TBitBtn;
    Button2: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    Label10: TLabel;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  sISS1, sISS2 : String;

implementation

uses fiscal
  , _small_59
  , _small_1
  ,_small_2
  , _small_3
  {Sandro Silva 2021-07-22 inicio
  , _small_4
  , _small_5
  , _small_6
  , _small_7
  , _small_8
  , _small_9
  , _small_10
  , _small_11
  }
  , _small_12
  , _small_65
  , _small_14
  , _small_15
  , _small_17
  , _small_99;

{$R *.DFM}


procedure TForm4.FormCreate(Sender: TObject);
var
  Component1: TCheckBox;
  Component2: TMaskEdit;
  Component3: Tlabel;
  I : Integer;
begin
  //
  for I := 1 to 16 do
  begin
    //
    Component3             := TLabel.Create(Self);
    Component3.Parent      := Panel2;
    Component3.AutoSize    := False;
    Component3.Height      := 16;
    Component3.Font.Color  := clblack;
    Component3.font.Name   := 'MS Sans Serif';
    Component3.font.Size   := 8;
    Component3.Name        := 'Labela'+IntToStr(I);
    Component3.Top         := I * 16 + 1;
    Component3.Left        := 1;
    Component3.Visible     := True;
    Component3.Caption     := ' ';
    Component3.Width       := 165;

    if I = ( I Div 2 ) * 2 then Component3.Color := clInactiveCaption else Component3.Color := clBtnFace;

    Component1             := TCheckBox.Create(Self);
    Component1.Parent      := Panel2;
    Component1.Alignment   := taLeftJustify;
    Component1.Height      := 16;
    Component1.Font.Color  := clblack;
    Component1.font.Name   := 'MS Sans Serif';
    Component1.font.Size   := 8;
    Component1.Name        := 'Aliquota'+IntToStr(I);
    Component1.Top         := I * 16 + 1;
    Component1.Left        := 1;
    Component1.Visible     := True;
    Component1.Caption     := ' Alíquota '+IntToStr(I);
    Component1.Width       := 100;
    //
    if I = ( I Div 2 ) * 2 then Component1.Color := clInactiveCaption else Component1.Color := clBtnFace;
    //
    Component2             := TMaskEdit.Create(Self);
    try
      if StrToFloat(Copy(Form1.sAliquotas,(I*4)-1,2) + ',' + Copy(Form1.sAliquotas,(I*4)+1,2)) <> 0 then
        Component2.Enabled := False;
    except
      if (FormatSettings.DecimalSeparator <> ',') or (FormatSettings.DateSeparator <> '/') then
      begin
        Application.MessageBox(Pchar('As propriedades das configurações regionais do seu sistema não estão'     + Chr(10) +
                                     'de acordo com o padrão utilizado no Brasil.'                              + Chr(10) +
                                     Chr(10) +
                                     'Estas configurações regionais alteram o modo como números, moedas, datas' + Chr(10) +
                                     'e horas são exibidos.'                                                    + Chr(10) +
                                     Chr(10) +
                                     'Altere estas configurações para:' + Chr(10) +
                                     Chr(10) +
                                     Chr(10) +
                                     '                  Português (Brasileiro)' + Chr(10) +
                                     Chr(10)+
                                     'Verifique também o separador decimal, que deve ser "." e ' + chr(10)+
                                     'o separador de data que deve ser "/".')

                                     ,'Atenção',mb_Ok + MB_ICONWARNING);
        Close;
        // Application.Terminate;
        Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
        {Sandro Silva 2014-06-30 inicio}
        FecharAplicacao(ExtractFileName(Application.ExeName));
        {Sandro Silva 2014-06-30 final}
      end;
    end;
    //
    Component2.Height      := 16;
    Component2.BorderStyle := BsNone;
    Component2.Parent      := Panel2;
    Component2.Font.Color  := clblack;
    Component2.font.Name   := 'MS Sans Serif';
    Component2.font.Size   := 8;
    Component2.Name        := 'MaskEdita'+IntToStr(I);
    Component2.Top         := I * 16 + 1;
    Component2.Left        := 130;
    Component2.Visible     := True;
    Component2.Width       := 30;
    Component2.EditMask    := '##,##;1;0';
    Component2.Text        := Copy(Form1.sAliquotas,(I*4)-1,2) + ',' + Copy(Form1.sAliquotas,(I*4)+1,2);
    if I = ( I Div 2 ) * 2 then Component2.Color := clInactiveCaption else Component2.Color := clBtnFace;
    Component2.OnKeyDown   := FormKeyDown;
    Component2.OnExit      := MaskEdit1Exit;
  end;
end;

procedure TForm4.Button1Click(Sender: TObject);
var
  J, I : Integer;
  bButton: Integer;
  pMensagem : pChar;
  sVincula : String;
begin
  J := 0;
  For I := 1 to Form4.ComponentCount -1 do
  begin

    if Copy(Form4.Components[I].Name,1,9) = 'MaskEdita' then
    begin

      J := J + 1;
      
      try
        if ( StrToFloat( StrTran(TMaskEdit(Form4.Components[I]).Text,' ','0')) <> 0 ) and
           ( Copy(Form1.sAliquotas,J*4-1,4) = '0000' ) then
        begin

          // -------------------------------- //
          // Adicionando nova aliquota        //
          // -------------------------------- //
          pMensagem := pChar('Atenção:' + Chr(10) +
                            ' '        + Chr(10) +
                            '         Você está adicionando uma nova alíquota' + Chr(10) +
                            '         que será gravada na memória CMOS da sua                  ' + Chr(10) +
                            '         impressora fiscal.' + Chr(10) +
                            Chr(10) +
                            'Alíquota '+IntToStr(J)+' com '+Format('%6.2n',[StrtoFloat(TMaskEdit(Form4.Components[I]).Text)]) + ' %' +
                            Chr(10) +
                            Chr(10) + 'Gravar ?');

          bButton := Application.MessageBox(pMensagem,'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONWARNING);

          if bButton = IDYES then
          begin
            if Form1.sModeloECF = '01' then _ecf01_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '02' then _ecf02_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '03' then _ecf03_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '12' then _ecf12_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '14' then _ecf14_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '15' then _ecf15_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '17' then _ecf17_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '59' then _ecf59_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if form1.sModeloECF = '65' then _ecf65_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '99' then _ecf99_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));

            {Sandro Silva 2021-07-22 inicio
            if Form1.sModeloECF = '04' then _ecf04_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '05' then _ecf05_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '06' then _ecf06_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '07' then _ecf07_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '08' then _ecf08_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '09' then _ecf09_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '10' then _ecf10_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            if Form1.sModeloECF = '11' then _ecf11_NovaAliquota(StrZero(StrToFloat(TMaskEdit(Form4.Components[I]).Text)*100,4,0));
            }
          end;
        end;
      except end;
    end;
  end;
  //
  {Sandro Silva 2017-07-26 inicio
  if Form1.sModeloECF = '59' then Form1.sAliquotas := _ecf59_RetornaAliquotas(True);
  if Form1.sModeloECF = '01' then Form1.sAliquotas := _ecf01_RetornaAliquotas(True);
  if Form1.sModeloECF = '02' then Form1.sAliquotas := _ecf02_RetornaAliquotas(True);
  if Form1.sModeloECF = '03' then Form1.sAliquotas := _ecf03_RetornaAliquotas(True);
  if Form1.sModeloECF = '04' then Form1.sAliquotas := _ecf04_RetornaAliquotas(True);
  if Form1.sModeloECF = '05' then Form1.sAliquotas := _ecf05_RetornaAliquotas(True);
  if Form1.sModeloECF = '06' then Form1.sAliquotas := _ecf06_RetornaAliquotas(True);
  if Form1.sModeloECF = '07' then Form1.sAliquotas := _ecf07_RetornaAliquotas(True);
  if Form1.sModeloECF = '08' then Form1.sAliquotas := _ecf08_RetornaAliquotas(True);
  if Form1.sModeloECF = '09' then Form1.sAliquotas := _ecf09_RetornaAliquotas(True);
  if Form1.sModeloECF = '10' then Form1.sAliquotas := _ecf10_RetornaAliquotas(True);
  if Form1.sModeloECF = '11' then Form1.sAliquotas := _ecf11_RetornaAliquotas(True);
  if Form1.sModeloECF = '12' then Form1.sAliquotas := _ecf12_RetornaAliquotas(True);
  if form1.sModeloECF = '65' then Form1.sAliquotas := _ecf65_RetornaAliquotas(True);
  if Form1.sModeloECF = '14' then Form1.sAliquotas := _ecf14_RetornaAliquotas(True);
  if Form1.sModeloECF = '15' then Form1.sAliquotas := _ecf15_RetornaAliquotas(True);
  if Form1.sModeloECF = '17' then Form1.sAliquotas := _ecf17_RetornaAliquotas(True);
  }
  Form1.sAliquotas := Form1.PDV_RetornaAliquotas(True);
  {Sandro Silva 2017-07-26 final}
  //
  sVincula         := '';
  //
  For I := 1 to Form4.ComponentCount -1 do
  begin
    if Copy(Form4.Components[I].Name,1,8) = 'Aliquota' then
    begin
      if TCheckBox(Form4.Components[I]).Checked = True then sVincula := sVincula + '1'
      else sVincula := sVincula + '0';
      if TCheckBox(Form4.Components[I]).Checked = True then sISS2 := '1' + sISS2
      else sISS2 := '0' + sISS2;
    end;
  end;
  //  ShowMessage(sVincula);
  if sISS1 <> sISS2 then
  begin
    if Form1.sModeloECF = '01' then _ecf01_Vincula(sVincula);
    if Form1.sModeloECF = '02' then _ecf02_Vincula(sVincula);
    if Form1.sModeloECF = '03' then _ecf03_Vincula(sVincula);
    if Form1.sModeloECF = '12' then _ecf12_Vincula(sVincula);
    if Form1.sModeloECF = '14' then _ecf14_Vincula(sVincula);
    if Form1.sModeloECF = '15' then _ecf15_Vincula(sVincula);
    if Form1.sModeloECF = '17' then _ecf17_Vincula(sVincula);
    if Form1.sModeloECF = '59' then _ecf59_Vincula(sVincula);
    if form1.sModeloECF = '65' then _ecf65_Vincula(sVincula);
    if Form1.sModeloECF = '99' then _ecf99_Vincula(sVincula);
    {Sandro Silva 2021-07-22 inicio
    if Form1.sModeloECF = '04' then _ecf04_Vincula(sVincula);
    if Form1.sModeloECF = '05' then _ecf05_Vincula(sVincula);
    if Form1.sModeloECF = '06' then _ecf06_Vincula(sVincula);
    if Form1.sModeloECF = '07' then _ecf07_Vincula(sVincula);
    if Form1.sModeloECF = '08' then _ecf08_Vincula(sVincula);
    if Form1.sModeloECF = '09' then _ecf09_Vincula(sVincula);
    if Form1.sModeloECF = '10' then _ecf10_Vincula(sVincula);
    if Form1.sModeloECF = '11' then _ecf11_Vincula(sVincula);
    }
  end;
  Close;
  //
end;



procedure TForm4.Button2Click(Sender: TObject);
begin
  Close;
end;








procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm4.MaskEdit1Exit(Sender: TObject);
begin
  try
    with Sender as TMaskEdit do Text := Format('%5.2n',[StrToFloat(Text)]);
  except end;  
end;

procedure TForm4.FormActivate(Sender: TObject);
var
  sTexto  : String;
  I, J : Integer;
  bChave  : Boolean;
begin
  //
  sTexto := '00';
  if Form1.sModeloECF = '01' then sTexto := _ecf01_FlagsDeISS(True);
  if Form1.sModeloECF = '02' then sTexto := _ecf02_FlagsDeISS(True);
  if Form1.sModeloECF = '03' then sTexto := _ecf03_FlagsDeISS(True);
  if Form1.sModeloECF = '12' then sTexto := _ecf12_FlagsDeISS(True);
  if Form1.sModeloECF = '14' then sTexto := _ecf14_FlagsDeISS(True);
  if Form1.sModeloECF = '15' then sTexto := _ecf15_FlagsDeISS(True);
  if Form1.sModeloECF = '17' then sTexto := _ecf17_FlagsDeISS(True);
  if Form1.sModeloECF = '59' then sTexto := _ecf59_FlagsDeISS(True);
  if form1.sModeloECF = '65' then sTexto := _ecf65_FlagsDeISS(True);
  if Form1.sModeloECF = '99' then sTexto := _ecf99_FlagsDeISS(True);
  {Sandro Silva 2021-07-22 inicio
  if Form1.sModeloECF = '04' then sTexto := _ecf04_FlagsDeISS(True);
  if Form1.sModeloECF = '05' then sTexto := _ecf05_FlagsDeISS(True);
  if Form1.sModeloECF = '06' then sTexto := _ecf06_FlagsDeISS(True);
  if Form1.sModeloECF = '07' then sTexto := _ecf07_FlagsDeISS(True);
  if Form1.sModeloECF = '08' then sTexto := _ecf08_FlagsDeISS(True);
  if Form1.sModeloECF = '09' then sTexto := _ecf09_FlagsDeISS(True);
  if Form1.sModeloECF = '10' then sTexto := _ecf10_FlagsDeISS(True);
  if Form1.sModeloECF = '11' then sTexto := _ecf11_FlagsDeISS(True);
  }
  //
  if AllTrim(sTexto) <> '' then
  begin
    bChave := False;
    J := 0;
    For I := 1 to Form4.ComponentCount -1 do
    begin
      if Copy(Form4.Components[I].Name,1,8) = 'Aliquota' then
      begin
        J := J + 1;
        if Copy(Right('00000000'+IntToBin(Ord(sTexto[1])),8) + Right('00000000'+IntToBin(Ord(sTexto[2])),8),J,1) = '1' then TCheckBox(Form4.Components[I]).Checked := True else TCheckBox(Form4.Components[I]).Checked := False;
      end;
      if bChave = False then
      begin
        if Copy(Form4.Components[I].Name,1,9) = 'MaskEdita' then
        begin
          if TMaskEdit(Form4.Components[I]).CanFoCus then
          begin
            TMaskEdit(Form4.Components[I]).SetFocus;
            bChave := True;
          end;
        end;
      end;
    end;
  end;
  try
    sISS1 := Right('000000000'+IntToBin(Ord(sTexto[2])),8)
           + Right('000000000'+IntToBin(Ord(sTexto[1])),8);
  except end;
  //

end;

end.

