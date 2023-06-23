unit formas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, StrUtils, SmallFunc, ufuncoesfrente,
  frame_teclado_1, Buttons
  , uajustaresolucao
  ;

const DESC_FORMA_01_DINHEIRO                                     = '01 - Dinheiro';
const DESC_FORMA_02_CHEQUE                                       = '02 - Cheque';
const DESC_FORMA_03_CARTAO                                       = '03/04 - Cartão';
const DESC_FORMA_05_PRAZO                                        = '05 - Prazo';
const DESC_FORMA_10_VALE_ALIMENTACAO                             = '10 - Vale Alimentação';
const DESC_FORMA_11_VALE_REFEICAO                                = '11 - Vale Refeição';
const DESC_FORMA_12_VALE_PRESENTE                                = '12 - Vale Presente';
const DESC_FORMA_13_VALE_COMBUSTIVEL                             = '13 - Vale Combustível';
{Sandro Silva 2021-03-05 inicio}
const DESC_FORMA_16_DEPOSITO_BANCARIO                            = '16 - Depósito Bancário';
const DESC_FORMA_17_PAGAMENTO_INSTANTANEO                        = '17 - Pagamento Instantâneo (PIX)';
const DESC_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18 - Transferência bancária, Carteira Digital';
const DESC_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19 - Programa de fidelidade, Cashback, Crédito Virtual';
{Sandro Silva 2021-03-05 fim}
const DESC_FORMA_99_OUTROS = '99 - Outros';

type
  TFormasP = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Ok: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    chkAplicarForma: TCheckBox;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    Button1: TBitBtn;
    chkReceberExtra1: TCheckBox;
    chkReceberExtra2: TCheckBox;
    chkReceberExtra3: TCheckBox;
    chkReceberExtra4: TCheckBox;
    chkReceberExtra5: TCheckBox;
    chkReceberExtra6: TCheckBox;
    chkReceberExtra7: TCheckBox;
    chkReceberExtra8: TCheckBox;
    chkUsandoTefCarteirasDigitais: TCheckBox;
    procedure OkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit5Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    sSecaoFrente: String; // Sandro Silva 2021-07-27
  public
    { Public declarations }
  end;
var
  FormasP: TFormasP;

implementation

uses Unit2, Unit12, fiscal, _Small_59, _small_65;

{$R *.dfm}

procedure TFormasP.OkClick(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sAlertaFormaExtra: String;
  // Sandro Silva 2021-07-27 sSecaoFrente: String;
  function IndiceValido(sIndice: String): Boolean;
  var
    iIndice: Integer;
  begin
    Result := True;
    {Sandro Silva 2021-03-09 inicio
    if ((StrToIntDef(Copy(sIndice, 1, 2), 0) <> 5)
      and (StrToIntDef(Copy(sIndice, 1, 2), 0) <> 10)
      and (StrToIntDef(Copy(sIndice, 1, 2), 0) <> 11)
      and (StrToIntDef(Copy(sIndice, 1, 2), 0) <> 12)
      and (StrToIntDef(Copy(sIndice, 1, 2), 0) <> 13)
      and (StrToIntDef(Copy(sIndice, 1, 2), 0) <> 99)
      ) then
      Result := False;
    }
    iIndice := StrToIntDef(Copy(sIndice, 1, 2), 0);
    {Sandro Silva 2021-08-11 inicio
    if (Form1.sModeloECF = '65') then
    begin
      if (  (iIndice <> 5)
        and (iIndice <> 10)
        and (iIndice <> 11)
        and (iIndice <> 12)
        and (iIndice <> 13)
        and (iIndice <> 16)
        and (iIndice <> 17)
        and (iIndice <> 18)
        and (iIndice <> 19)
        and (iIndice <> 99)
        ) then
        Result := False;

    end
    else
    begin

      if (  (iIndice <> 5)
        and (iIndice <> 10)
        and (iIndice <> 11)
        and (iIndice <> 12)
        and (iIndice <> 13)
        and (iIndice <> 99)
        ) then
        Result := False;
    end;
    }
    if (  (iIndice <> 5)
      and (iIndice <> 10)
      and (iIndice <> 11)
      and (iIndice <> 12)
      and (iIndice <> 13)
      and (iIndice <> 16)
      and (iIndice <> 17)
      and (iIndice <> 18)
      and (iIndice <> 19)
      and (iIndice <> 99)
      ) then
      Result := False;
    {Sandro Silva 2021-08-11 fim}
  end;
begin
  //
  Mais1ini    := TIniFile.Create('FRENTE.INI');

  //
  Mais1Ini.WriteString('Frente de caixa','Forma Cartao'  ,Edit1.Text);
  Mais1Ini.WriteString('Frente de caixa','Forma A prazo' ,Edit2.Text);
  Mais1Ini.WriteString('Frente de caixa','Forma Cheque'  ,Edit3.Text);
  Mais1Ini.WriteString('Frente de caixa','Forma Dinheiro',Edit4.Text);

  {Sandro Silva 2021-07-27 inicio
  if (Form1.sModeloECF = '59') or (Form1.sModeloECF = '65') or (Form1.sModeloECF = '99') then
    sSecaoFrente := SECAO_65
  else
    sSecaoFrente := 'Frente de caixa';
  }
  sSecaoFrente := Form1.SecaoFrente();
  {Sandro Silva 2021-07-27 fim}


  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 1' ,Edit5.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 2' ,Edit6.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 3' ,Edit7.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 4' ,Edit8.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 5' ,Edit9.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 6' ,Edit10.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 7' ,Edit11.Text);
  Mais1Ini.WriteString(sSecaoFrente,'Forma extra 8' ,Edit12.Text);


  {Sandro Silva 2021-07-27 inicio}
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 1 Contas Receber', IfThen(chkReceberExtra1.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 2 Contas Receber', IfThen(chkReceberExtra2.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 3 Contas Receber', IfThen(chkReceberExtra3.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 4 Contas Receber', IfThen(chkReceberExtra4.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 5 Contas Receber', IfThen(chkReceberExtra5.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 6 Contas Receber', IfThen(chkReceberExtra6.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 7 Contas Receber', IfThen(chkReceberExtra7.Checked, 'Sim', 'Não'));
  Mais1Ini.WriteString(sSecaoFrente, 'Forma extra 8 Contas Receber', IfThen(chkReceberExtra8.Checked, 'Sim', 'Não'));
  {Sandro Silva 2021-07-27 fim}

  if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then
  begin
    Mais1Ini.WriteString('Frente de caixa','Cartao'  ,ComboBox1.Text);
    Mais1Ini.WriteString('Frente de caixa','Prazo'   ,ComboBox2.Text);
    Mais1Ini.WriteString('Frente de caixa','Cheque'  ,ComboBox3.Text);
    Mais1Ini.WriteString('Frente de caixa','Dinheiro',ComboBox4.Text);

    // Não deve limpar a configuração no FRENTE.INI porque nos ECF ficam gravadas as formas extras
    if AllTrim(Edit5.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 1', Copy(ComboBox5.Text, 1, 2));
    if AllTrim(Edit6.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 2', Copy(ComboBox6.Text, 1, 2));
    if AllTrim(Edit7.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 3', Copy(ComboBox7.Text, 1, 2));
    if AllTrim(Edit8.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 4', Copy(ComboBox8.Text, 1, 2));
    if AllTrim(Edit9.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 5', Copy(ComboBox9.Text, 1, 2));
    if AllTrim(Edit10.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 6', Copy(ComboBox10.Text, 1, 2));
    if AllTrim(Edit11.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 7', Copy(ComboBox11.Text, 1, 2));
    if AllTrim(Edit12.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 8', Copy(ComboBox12.Text, 1, 2));
  end
  else
  begin // Configuração para NFC-e/CF-e-SAT
    if AllTrim(Edit5.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 1', Copy(ComboBox5.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 1', '');

    if AllTrim(Edit6.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 2', Copy(ComboBox6.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 2', '');

    if AllTrim(Edit7.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 3', Copy(ComboBox7.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 3', '');

    if AllTrim(Edit8.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 4', Copy(ComboBox8.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 4', '');

    if AllTrim(Edit9.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 5', Copy(ComboBox9.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 5', '');

    if AllTrim(Edit10.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 6', Copy(ComboBox10.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 6', '');

    if AllTrim(Edit11.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 7', Copy(ComboBox11.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 7', '');
    if AllTrim(Edit12.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 8', Copy(ComboBox12.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 8', '');

    if chkAplicarForma.Checked then
    begin
      Mais1Ini.WriteString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Sim');

      if (AllTrim(Edit5.Text)  <> '') and (IndiceValido(ComboBox5.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit5.Text;

      if (AllTrim(Edit6.Text)  <> '') and (IndiceValido(ComboBox6.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit6.Text;

      if (AllTrim(Edit7.Text)  <> '') and (IndiceValido(ComboBox7.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit7.Text;

      if (AllTrim(Edit8.Text)  <> '') and (IndiceValido(ComboBox8.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit8.Text;

      if (AllTrim(Edit9.Text)  <> '') and (IndiceValido(ComboBox9.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit9.Text;

      if (AllTrim(Edit10.Text) <> '') and (IndiceValido(ComboBox10.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit10.Text;

      if (AllTrim(Edit11.Text) <> '') and (IndiceValido(ComboBox11.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit11.Text;

      if (AllTrim(Edit12.Text) <> '') and (IndiceValido(ComboBox12.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit12.Text;

      if sAlertaFormaExtra <> '' then
      begin
        SmallMsgBox(PChar('Configure corretamente o índice da forma de pagamento abaixo' + #13 + sAlertaFormaExtra), 'Atenção', MB_OK + MB_ICONWARNING);
      end;
    end
    else
      Mais1Ini.WriteString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não');

  end;

  {Sandro Silva 2021-08-30 inicio}
  // Se tiver marcada a opção "Usando TEF para carteiras digitais"
  Mais1Ini.WriteString('Frente de caixa', CHAVE_TEF_CARTEIRA_DIGITAL, IfThen(chkUsandoTefCarteirasDigitais.Checked, 'Sim', 'Não'));
  {Sandro Silva 2021-08-30 fim}


  Mais1ini.Free;
  //
  SmallMsg('Este Programa vai ser fechado para que as novas alterações'+Chr(10)+'tenham efeito');
  Form1.ClienteSmallMobile.EnviarLogParaMobile( // Sandro Silva 2022-08-08 EnviarLogParaMobile(
    Form1.ClienteSmallMobile.sLogRetornoMobile);
  Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName));
  Close;
  //
end;

procedure TFormasP.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  // Sandro Silva 2021-07-27 sSecaoFrente: String;
  function ComboIndex(ComboBox: TComboBox; sTexto: String): Integer;
  var
    iItem: Integer;
  begin
    Result := -1;
    for iItem := 0 to ComboBox.Items.Count - 1 do
    begin
      if Copy(ComboBox.Items.Strings[iItem], 1, 2) = Right('0' + sTexto, 2) then
      begin
        Result := iItem;
        Break;
      end;
    end;
  end;
begin
  //
  //
  Mais1ini    := TIniFile.Create('FRENTE.INI');
  //
  Edit1.Text  := Mais1Ini.ReadString('Frente de caixa','Forma Cartao'   ,'Cartao');
  Edit2.Text  := Mais1Ini.ReadString('Frente de caixa','Forma A prazo'  ,'Prazo');
  Edit3.Text  := Mais1Ini.ReadString('Frente de caixa','Forma Cheque'   ,'Cheque');
  Edit4.Text  := Mais1Ini.ReadString('Frente de caixa','Forma Dinheiro' ,'Dinheiro');
  //
  {Sandro Silva 2021-07-27 inicio
  if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
    sSecaoFrente := SECAO_65
  else
    sSecaoFrente := 'Frente de caixa';
  }
  sSecaoFrente := Form1.SecaoFrente();

  Edit5.Text  := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 1','');
  Edit6.Text  := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 2','');
  Edit7.Text  := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 3','');
  Edit8.Text  := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 4','');
  Edit9.Text  := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 5','');
  Edit10.Text := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 6','');
  Edit11.Text := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 7','');
  Edit12.Text := Mais1Ini.ReadString(sSecaoFrente,'Forma extra 8','');

  if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then
  begin
    ComboBox2.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Prazo'    ,'4'));
    ComboBox1.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Cartao'   ,'3'));
    ComboBox3.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Cheque'   ,'2'));
    ComboBox4.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','dinheiro' ,'1'));

    if AllTrim(Edit5.Text)  <> '' then ComboBox5.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','5' )) else ComboBox5.Text  := '';
    if AllTrim(Edit6.Text)  <> '' then ComboBox6.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','6' )) else ComboBox6.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then ComboBox7.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','7' )) else ComboBox7.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then ComboBox8.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','8' )) else ComboBox8.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then ComboBox9.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','9' )) else ComboBox9.Text  := '';
    if AllTrim(Edit10.Text) <> '' then ComboBox10.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','10')) else ComboBox10.Text := '';
    if AllTrim(Edit11.Text) <> '' then ComboBox11.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','11')) else ComboBox11.Text := '';
    if AllTrim(Edit12.Text) <> '' then ComboBox12.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','12')) else ComboBox12.Text := '';
    //
  end
  else
  begin // Configuração para NFC-e/CF-e-SAT
    ComboBox2.ItemIndex  := ComboIndex(ComboBox2, '05'); // Prazo
    if ComboBox2.ItemIndex = -1 then
      ComboBox2.Text  := DESC_FORMA_05_PRAZO;

    ComboBox1.ItemIndex  := ComboIndex(ComboBox1, '03'); // Cartão Débito/Crédito
    if ComboBox1.ItemIndex = -1 then
      ComboBox1.Text  := DESC_FORMA_03_CARTAO;

    ComboBox3.ItemIndex  := ComboIndex(ComboBox3, '02'); // Cheque
    if ComboBox3.ItemIndex = -1 then
      ComboBox3.Text  := DESC_FORMA_02_CHEQUE;

    ComboBox4.ItemIndex  := ComboIndex(ComboBox4, '01'); // Dinheiro
    if ComboBox4.ItemIndex = -1 then
      ComboBox4.Text  := DESC_FORMA_01_DINHEIRO;

    if AllTrim(Edit5.Text)  <> '' then ComboBox5.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1','5' )) else ComboBox5.Text  := '';
    if AllTrim(Edit6.Text)  <> '' then ComboBox6.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','6' )) else ComboBox6.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then ComboBox7.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','7' )) else ComboBox7.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then ComboBox8.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','8' )) else ComboBox8.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then ComboBox9.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','9' )) else ComboBox9.Text  := '';
    if AllTrim(Edit10.Text) <> '' then ComboBox10.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','10')) else ComboBox10.Text := '';
    if AllTrim(Edit11.Text) <> '' then ComboBox11.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','11')) else ComboBox11.Text := '';
    if AllTrim(Edit12.Text) <> '' then ComboBox12.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','12')) else ComboBox12.Text := '';

    if AllTrim(Edit5.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1', '')) <> '' then
        ComboBox5.ItemIndex  := ComboIndex(ComboBox5, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1', '')), 2));
      if ComboBox5.ItemIndex = -1 then
        ComboBox5.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1','' )) ;
    end
    else
      ComboBox5.Text  := '';

    if AllTrim(Edit6.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2', '')) <> '' then
        ComboBox6.ItemIndex  := ComboIndex(ComboBox6, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2', '')), 2));
      if ComboBox6.ItemIndex = -1 then
        ComboBox6.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','' )) ;
    end
    else
      ComboBox6.Text  := '';

    if AllTrim(Edit7.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')) <> '' then
        ComboBox7.ItemIndex  := ComboIndex(ComboBox7, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')), 2));
      if ComboBox7.ItemIndex = -1 then
        ComboBox7.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','' )) ;
    end
    else
      ComboBox7.Text  := '';

    if AllTrim(Edit8.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')) <> '' then
        ComboBox8.ItemIndex  := ComboIndex(ComboBox8, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')), 2));
      if ComboBox8.ItemIndex = -1 then
        ComboBox8.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','' )) ;
    end
    else
      ComboBox8.Text  := '';

    if AllTrim(Edit9.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')) <> '' then
        ComboBox9.ItemIndex  := ComboIndex(ComboBox9, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')), 2));
      if ComboBox9.ItemIndex = -1 then
        ComboBox9.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','' )) ;
    end
    else
      ComboBox9.Text  := '';

    if AllTrim(Edit10.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')) <> '' then
        ComboBox10.ItemIndex  := ComboIndex(ComboBox10, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')), 2));
      if ComboBox10.ItemIndex = -1 then
        ComboBox10.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','' )) ;
    end
    else
      ComboBox10.Text := '';

    if AllTrim(Edit11.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')) <> '' then
        ComboBox11.ItemIndex  := ComboIndex(ComboBox11, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')), 2));
      if ComboBox11.ItemIndex = -1 then
        ComboBox11.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','' )) ;
    end
    else
      ComboBox11.Text := '';

    if AllTrim(Edit12.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')) <> '' then
        ComboBox12.ItemIndex  := ComboIndex(ComboBox12, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')), 2));
      if ComboBox12.ItemIndex = -1 then
        ComboBox12.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','' )) ;
    end
    else
      ComboBox12.Text := '';
  end;

  Mais1ini.Free;
  //
end;

procedure TFormasP.Edit5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP then
  begin
    Perform(Wm_NextDlgCtl,-1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TFormasP.Edit5Exit(Sender: TObject);
var
  I : Integer;
begin
  with Sender as TEdit do
  begin
    for I := 1 to 36 do Text :=  StrTran(Text,copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãéèêëíîïóôõúüç*',I,1),copy('AAAAAEEEEIIIOOOUUCaaaaaeeeeiiiooouuc*',I,1));
    Text := Copy(Text,1,15);
  end;
end;

procedure TFormasP.FormShow(Sender: TObject);
  procedure CarregaCombo(Combo: TComboBox; bPadrao: Boolean = False);
  begin
    Combo.Clear;
    if bPadrao then
    begin
      Combo.Items.Add(DESC_FORMA_01_DINHEIRO);
      Combo.Items.Add(DESC_FORMA_02_CHEQUE);
      Combo.Items.Add(DESC_FORMA_03_CARTAO);
      Combo.Items.Add(DESC_FORMA_05_PRAZO);
    end;
    Combo.Items.Add(DESC_FORMA_10_VALE_ALIMENTACAO);
    Combo.Items.Add(DESC_FORMA_11_VALE_REFEICAO);
    Combo.Items.Add(DESC_FORMA_12_VALE_PRESENTE);
    Combo.Items.Add(DESC_FORMA_13_VALE_COMBUSTIVEL);

    {Sandro Silva 2021-03-08 inicio}
    if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') then // Sandro Silva 2021-08-09 if (Form1.sModeloECF_Reserva = '65') then
    begin
      Combo.Items.Add(DESC_FORMA_16_DEPOSITO_BANCARIO);
      Combo.Items.Add(DESC_FORMA_17_PAGAMENTO_INSTANTANEO);
      Combo.Items.Add(DESC_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL);
      Combo.Items.Add(DESC_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL);
    end;
    {Sandro Silva 2021-03-08 fim}     
    Combo.Items.Add(DESC_FORMA_99_OUTROS);
  end;
begin
  sSecaoFrente := Form1.SecaoFrente(); // Sandro Silva 2021-07-27

  chkUsandoTefCarteirasDigitais.Visible := False; // Sandro Silva 2021-08-30
  chkUsandoTefCarteirasDigitais.Checked := (LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, CHAVE_TEF_CARTEIRA_DIGITAL, 'Não') = 'Sim');  

  if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then
  begin
    if Form1.sModeloECF_Reserva = '59' then
      Label2.Caption := 'Índice no SAT/MFE';
    if Form1.sModeloECF_Reserva = '65' then
      Label2.Caption := 'Índice na NFC-e';
    if Form1.sModeloECF_Reserva = '99' then
      Label2.Caption := 'Índice na movimentação'; // Sandro Silva 2023-06-23 Label2.Caption := 'Índice na Venda';

    chkUsandoTefCarteirasDigitais.Visible := True; // Sandro Silva 2021-08-30

    ComboBox4.Enabled := False;// Dinheiro
    ComboBox3.Enabled := False;// Cheque
    ComboBox1.Enabled := False;// Cartão de Crédito/Cartão de Débito
    ComboBox2.Enabled := False;// Crédito Loja

    CarregaCombo(ComboBox4, True);// Dinheiro
    CarregaCombo(ComboBox3, True);//  Cheque
    CarregaCombo(ComboBox1, True);//  Cartão de Crédito/Cartão de Débito
    CarregaCombo(ComboBox2, True);//  Crédito Loja
    CarregaCombo(ComboBox5);
    CarregaCombo(ComboBox6);
    CarregaCombo(ComboBox7);
    CarregaCombo(ComboBox8);
    CarregaCombo(ComboBox9);
    CarregaCombo(ComboBox10);
    CarregaCombo(ComboBox11);
    CarregaCombo(ComboBox12);

    chkAplicarForma.Checked := (LerParametroIni(FRENTE_INI, SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim');

    {Sandro Silva 2020-09-29 inicio
    chkAplicarForma.Visible := True;
    }
    if (Form1.sModeloECF_Reserva <> '59') and (Form1.sModeloECF_Reserva <> '65') and (Form1.sModeloECF_Reserva <> '99') then // Sandro Silva 2021-07-27  if Form1.sModeloECF_Reserva <> '99' then // Sandro Silva 2020-09-29
      chkAplicarForma.Visible := False
    else
      chkAplicarForma.Visible := True;
    {Sandro Silva 2020-09-29 fim}

    {Sandro Silva 2021-07-27 inicio}
    chkReceberExtra1.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 1 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra2.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 2 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra3.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 3 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra4.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 4 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra5.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 5 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra6.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 6 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra7.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 7 Contas Receber', 'Não') = 'Sim');
    chkReceberExtra8.Checked := (LerParametroIni(FRENTE_INI, sSecaoFrente, 'Forma extra 8 Contas Receber', 'Não') = 'Sim');

    chkReceberExtra1.Visible := chkAplicarForma.Visible;
    chkReceberExtra2.Visible := chkAplicarForma.Visible;
    chkReceberExtra3.Visible := chkAplicarForma.Visible;
    chkReceberExtra4.Visible := chkAplicarForma.Visible;
    chkReceberExtra5.Visible := chkAplicarForma.Visible;
    chkReceberExtra6.Visible := chkAplicarForma.Visible;
    chkReceberExtra7.Visible := chkAplicarForma.Visible;
    chkReceberExtra8.Visible := chkAplicarForma.Visible;
    {Sandro Silva 2021-07-27 fim}

  end;
end;

procedure TFormasP.FormCreate(Sender: TObject);
begin
  FormasP.BorderStyle := bsNone; // Sandro Silva 2021-08-09
  AjustaResolucao(FormasP); // Sandro Silva 2018-08-28
  AjustaResolucao(FormaSP.Frame_teclado1);

  chkAplicarForma.Left  := Edit12.Left;
  chkAplicarForma.Width := Edit12.Width;
  chkAplicarForma.Top   := Edit12.BoundsRect.Bottom + AjustaAltura(7);
  chkAplicarForma.Font  := Label1.Font;

  {Sandro Silva 2021-08-30 inicio}
  chkUsandoTefCarteirasDigitais.Left  := ComboBox12.Left;
  //chkUsandoTefCarteirasDigitais.Width := ComboBox12.Width;
  chkUsandoTefCarteirasDigitais.Top   := chkAplicarForma.Top;// ComboBox12.BoundsRect.Bottom + AjustaAltura(7);
  chkUsandoTefCarteirasDigitais.Font  := Label1.Font;
  {Sandro Silva 2021-08-30 fim}   

  FormasP.Top    := Screen.Height - FormasP.Height div 2;
  FormasP.Left   := Screen.Width - FormasP.Width div 2;
end;

procedure TFormasP.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

