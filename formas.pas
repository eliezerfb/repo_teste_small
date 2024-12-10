unit formas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, StrUtils, SmallFunc_xe, ufuncoesfrente,
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
const DESC_FORMA_17_PAGAMENTO_INSTANTANEO                        = '17 - Pagamento Instantâneo (PIX) Dinâmico';
const DESC_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18 - Transferência bancária, Carteira Digital';
const DESC_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19 - Programa de fidelidade, Cashback, Crédito Virtual';
{Sandro Silva 2021-03-05 fim}
const DESC_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO           = '20 - Pagamento Instantâneo (PIX) Estático'; // Sandro Silva 2024-07-01
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
    cboForma01: TComboBox;
    cboForma02: TComboBox;
    cboForma03: TComboBox;
    cboForma04: TComboBox;
    cboForma05: TComboBox;
    cboForma06: TComboBox;
    cboForma07: TComboBox;
    cboForma08: TComboBox;
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
    cboPixExtra1: TComboBox;
    cboPixExtra2: TComboBox;
    cboPixExtra3: TComboBox;
    cboPixExtra4: TComboBox;
    cboPixExtra5: TComboBox;
    cboPixExtra6: TComboBox;
    cboPixExtra7: TComboBox;
    cboPixExtra8: TComboBox;
    chkAtalhoF6_1: TCheckBox;
    chkAtalhoF6_2: TCheckBox;
    chkAtalhoF6_3: TCheckBox;
    chkAtalhoF6_4: TCheckBox;
    chkAtalhoF6_5: TCheckBox;
    chkAtalhoF6_6: TCheckBox;
    chkAtalhoF6_7: TCheckBox;
    chkAtalhoF6_8: TCheckBox;
    procedure OkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit5Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cboForma01Change(Sender: TObject);
    procedure cboForma02Change(Sender: TObject);
    procedure cboForma03Change(Sender: TObject);
    procedure cboForma04Change(Sender: TObject);
    procedure cboForma05Change(Sender: TObject);
    procedure cboForma06Change(Sender: TObject);
    procedure cboForma07Change(Sender: TObject);
    procedure cboForma08Change(Sender: TObject);
    procedure chkAtalhoF6_1Click(Sender: TObject);
    procedure chkAtalhoF6_2Click(Sender: TObject);
    procedure chkAtalhoF6_3Click(Sender: TObject);
    procedure chkAtalhoF6_4Click(Sender: TObject);
    procedure chkAtalhoF6_5Click(Sender: TObject);
    procedure chkAtalhoF6_6Click(Sender: TObject);
    procedure chkAtalhoF6_7Click(Sender: TObject);
    procedure chkAtalhoF6_8Click(Sender: TObject);
  private
    { Private declarations }
    sSecaoFrente: String;
    sFormaAtalhoF6 : string;
    procedure CarregaInformacoes;
    procedure CarregaOpcaoTipoPix(ComboOpcao: Tcombobox; FormaPgto: string);
    procedure OpcaoLancaContaReceber;
    procedure SetCheckAtalhoF6; // Sandro Silva 2021-07-27
  public
    { Public declarations }
  end;
var
  FormasP: TFormasP;

implementation

uses Unit2, Unit12, fiscal, _Small_59, _small_65, uSmallConsts;

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
      and (iIndice <> 20)
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
    if AllTrim(Edit5.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 1', Copy(cboForma01.Text, 1, 2));
    if AllTrim(Edit6.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 2', Copy(cboForma02.Text, 1, 2));
    if AllTrim(Edit7.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 3', Copy(cboForma03.Text, 1, 2));
    if AllTrim(Edit8.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 4', Copy(cboForma04.Text, 1, 2));
    if AllTrim(Edit9.Text)  <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 5', Copy(cboForma05.Text, 1, 2));
    if AllTrim(Edit10.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 6', Copy(cboForma06.Text, 1, 2));
    if AllTrim(Edit11.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 7', Copy(cboForma07.Text, 1, 2));
    if AllTrim(Edit12.Text) <> '' then Mais1Ini.WriteString('Frente de caixa','Ordem forma extra 8', Copy(cboForma08.Text, 1, 2));
  end
  else
  begin // Configuração para NFC-e/CF-e-SAT
    if AllTrim(Edit5.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 1', Copy(cboForma01.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 1', '');

    if AllTrim(Edit6.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 2', Copy(cboForma02.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 2', '');

    if AllTrim(Edit7.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 3', Copy(cboForma03.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 3', '');

    if AllTrim(Edit8.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 4', Copy(cboForma04.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 4', '');

    if AllTrim(Edit9.Text)  <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 5', Copy(cboForma05.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 5', '');

    if AllTrim(Edit10.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 6', Copy(cboForma06.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 6', '');

    if AllTrim(Edit11.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 7', Copy(cboForma07.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 7', '');
    if AllTrim(Edit12.Text) <> '' then
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 8', Copy(cboForma08.Text, 1, 2))
    else
      Mais1Ini.WriteString(SECAO_65,'Ordem forma extra 8', '');

    if chkAplicarForma.Checked then
    begin
      Mais1Ini.WriteString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Sim');

      if (AllTrim(Edit5.Text)  <> '') and (IndiceValido(cboForma01.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit5.Text;

      if (AllTrim(Edit6.Text)  <> '') and (IndiceValido(cboForma02.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit6.Text;

      if (AllTrim(Edit7.Text)  <> '') and (IndiceValido(cboForma03.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit7.Text;

      if (AllTrim(Edit8.Text)  <> '') and (IndiceValido(cboForma04.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit8.Text;

      if (AllTrim(Edit9.Text)  <> '') and (IndiceValido(cboForma05.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit9.Text;

      if (AllTrim(Edit10.Text) <> '') and (IndiceValido(cboForma06.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit10.Text;

      if (AllTrim(Edit11.Text) <> '') and (IndiceValido(cboForma07.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit11.Text;

      if (AllTrim(Edit12.Text) <> '') and (IndiceValido(cboForma08.Text) = False) then
        sAlertaFormaExtra := sAlertaFormaExtra + #13 + Edit12.Text;

      if sAlertaFormaExtra <> '' then
      begin
        SmallMsgBox(PChar('Configure corretamente o índice da forma de pagamento abaixo' + #13 + sAlertaFormaExtra), 'Atenção', MB_OK + MB_ICONWARNING);
      end;
    end
    else
      Mais1Ini.WriteString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não');

    {Mauricio Parizotto 2024-06-14 Inicio}
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 1', cboPixExtra1.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 2', cboPixExtra2.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 3', cboPixExtra3.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 4', cboPixExtra4.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 5', cboPixExtra5.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 6', cboPixExtra6.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 7', cboPixExtra7.Text);
    Mais1Ini.WriteString(SECAO_65, 'Tipo Pix 8', cboPixExtra8.Text);
    {Mauricio Parizotto 2024-06-14 Fim}
  end;

  {Sandro Silva 2021-08-30 inicio}
  // Se tiver marcada a opção "Usando TEF para carteiras digitais"
  Mais1Ini.WriteString('Frente de caixa', CHAVE_TEF_CARTEIRA_DIGITAL, IfThen(chkUsandoTefCarteirasDigitais.Checked, 'Sim', 'Não'));
  {Sandro Silva 2021-08-30 fim}


  //Mauricio Parizotto 2024-12-04
  Mais1Ini.WriteString(SECAO_65,'Atalho F6', sFormaAtalhoF6);

  Mais1ini.Free;

  SmallMsg('Este Programa vai ser fechado para que as novas alterações'+Chr(10)+'tenham efeito');
  Form1.ClienteSmallMobile.EnviarLogParaMobile( // Sandro Silva 2022-08-08 EnviarLogParaMobile(
    Form1.ClienteSmallMobile.sLogRetornoMobile);
  Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
  FecharAplicacao(ExtractFileName(Application.ExeName));
  Close;
end;

procedure TFormasP.FormActivate(Sender: TObject);
begin
(* Mauricio Parizotto 2024-06-14
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
    if AllTrim(Edit6.Text)  <> '' then cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','6' )) else cboForma02.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','7' )) else cboForma03.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','8' )) else cboForma04.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','9' )) else cboForma05.Text  := '';
    if AllTrim(Edit10.Text) <> '' then cboForma06.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','10')) else cboForma06.Text := '';
    if AllTrim(Edit11.Text) <> '' then cboForma07.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','11')) else cboForma07.Text := '';
    if AllTrim(Edit12.Text) <> '' then cboForma08.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','12')) else cboForma08.Text := '';
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
    if AllTrim(Edit6.Text)  <> '' then cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','6' )) else cboForma02.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','7' )) else cboForma03.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','8' )) else cboForma04.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','9' )) else cboForma05.Text  := '';
    if AllTrim(Edit10.Text) <> '' then cboForma06.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','10')) else cboForma06.Text := '';
    if AllTrim(Edit11.Text) <> '' then cboForma07.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','11')) else cboForma07.Text := '';
    if AllTrim(Edit12.Text) <> '' then cboForma08.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','12')) else cboForma08.Text := '';

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
        cboForma02.ItemIndex  := ComboIndex(cboForma02, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2', '')), 2));
      if cboForma02.ItemIndex = -1 then
        cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','' )) ;
    end
    else
      cboForma02.Text  := '';

    if AllTrim(Edit7.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')) <> '' then
        cboForma03.ItemIndex  := ComboIndex(cboForma03, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')), 2));
      if cboForma03.ItemIndex = -1 then
        cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','' )) ;
    end
    else
      cboForma03.Text  := '';

    if AllTrim(Edit8.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')) <> '' then
        cboForma04.ItemIndex  := ComboIndex(cboForma04, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')), 2));
      if cboForma04.ItemIndex = -1 then
        cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','' )) ;
    end
    else
      cboForma04.Text  := '';

    if AllTrim(Edit9.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')) <> '' then
        cboForma05.ItemIndex  := ComboIndex(cboForma05, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')), 2));
      if cboForma05.ItemIndex = -1 then
        cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','' )) ;
    end
    else
      cboForma05.Text  := '';

    if AllTrim(Edit10.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')) <> '' then
        cboForma06.ItemIndex  := ComboIndex(cboForma06, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')), 2));
      if cboForma06.ItemIndex = -1 then
        cboForma06.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','' )) ;
    end
    else
      cboForma06.Text := '';

    if AllTrim(Edit11.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')) <> '' then
        cboForma07.ItemIndex  := ComboIndex(cboForma07, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')), 2));
      if cboForma07.ItemIndex = -1 then
        cboForma07.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','' )) ;
    end
    else
      cboForma07.Text := '';

    if AllTrim(Edit12.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')) <> '' then
        cboForma08.ItemIndex  := ComboIndex(cboForma08, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')), 2));
      if cboForma08.ItemIndex = -1 then
        cboForma08.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','' )) ;
    end
    else
      cboForma08.Text := '';
  end;

  Mais1ini.Free;
  *)
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
    Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_DOWN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TFormasP.cboForma06Change(Sender: TObject);
begin
  cboPixExtra6.Visible := (Copy(cboForma06.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma06.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra6,Copy(cboForma06.Text,1,2));

  if (cboPixExtra6.Visible) and (cboPixExtra6.ItemIndex = -1) then
    cboPixExtra6.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_6.Visible := cboPixExtra6.Visible;
  if not chkAtalhoF6_6.Visible then
  begin
    chkAtalhoF6_6.Checked := False;
    chkAtalhoF6_6Click(chkAtalhoF6_6);
  end;
end;

procedure TFormasP.cboForma07Change(Sender: TObject);
begin
  cboPixExtra7.Visible := (Copy(cboForma07.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma07.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra7,Copy(cboForma07.Text,1,2));

  if (cboPixExtra7.Visible) and (cboPixExtra7.ItemIndex = -1) then
    cboPixExtra7.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_7.Visible := cboPixExtra7.Visible;
  if not chkAtalhoF6_7.Visible then
  begin
    chkAtalhoF6_7.Checked := False;
    chkAtalhoF6_7Click(chkAtalhoF6_7);
  end;
end;

procedure TFormasP.cboForma08Change(Sender: TObject);
begin
  cboPixExtra8.Visible := (Copy(cboForma08.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma08.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra8,Copy(cboForma08.Text,1,2));

  if (cboPixExtra8.Visible) and (cboPixExtra8.ItemIndex = -1) then
    cboPixExtra8.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_8.Visible := cboPixExtra8.Visible;
  if not chkAtalhoF6_8.Visible then
  begin
    chkAtalhoF6_8.Checked := False;
    chkAtalhoF6_1Click(chkAtalhoF6_8);
  end;
end;

procedure TFormasP.chkAtalhoF6_1Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 1'
  else
    if sFormaAtalhoF6 = 'Forma extra 1' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_2Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 2'
  else
    if sFormaAtalhoF6 = 'Forma extra 2' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_3Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 3'
  else
    if sFormaAtalhoF6 = 'Forma extra 3' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_4Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 4'
  else
    if sFormaAtalhoF6 = 'Forma extra 4' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_5Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 5'
  else
    if sFormaAtalhoF6 = 'Forma extra 5' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_6Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 6'
  else
    if sFormaAtalhoF6 = 'Forma extra 6' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_7Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 7'
  else
    if sFormaAtalhoF6 = 'Forma extra 7' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.chkAtalhoF6_8Click(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then
    sFormaAtalhoF6 := 'Forma extra 8'
  else
    if sFormaAtalhoF6 = 'Forma extra 8' then
      sFormaAtalhoF6 := '';

  SetCheckAtalhoF6;
end;

procedure TFormasP.cboForma01Change(Sender: TObject);
begin
  cboPixExtra1.Visible := (Copy(cboForma01.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma01.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra1,Copy(cboForma01.Text,1,2));

  if (cboPixExtra1.Visible) and (cboPixExtra1.ItemIndex = -1) then
    cboPixExtra1.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_1.Visible := cboPixExtra1.Visible;
  if not chkAtalhoF6_1.Visible then
  begin
    chkAtalhoF6_1.Checked := False;
    chkAtalhoF6_1Click(chkAtalhoF6_1);
  end;
end;

procedure TFormasP.cboForma02Change(Sender: TObject);
begin
  cboPixExtra2.Visible := (Copy(cboForma02.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma02.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra2,Copy(cboForma02.Text,1,2));

  if (cboPixExtra2.Visible) and (cboPixExtra2.ItemIndex = -1) then
    cboPixExtra2.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_2.Visible := cboPixExtra2.Visible;
  if not chkAtalhoF6_2.Visible then
  begin
    chkAtalhoF6_2.Checked := False;
    chkAtalhoF6_2Click(chkAtalhoF6_2);
  end;
end;

procedure TFormasP.cboForma03Change(Sender: TObject);
begin
  cboPixExtra3.Visible := (Copy(cboForma03.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma03.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra3,Copy(cboForma03.Text,1,2));

  if (cboPixExtra3.Visible) and (cboPixExtra3.ItemIndex = -1) then
    cboPixExtra3.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_3.Visible := cboPixExtra3.Visible;
  if not chkAtalhoF6_3.Visible then
  begin
    chkAtalhoF6_3.Checked := False;
    chkAtalhoF6_3Click(chkAtalhoF6_3);
  end;
end;

procedure TFormasP.cboForma04Change(Sender: TObject);
begin
  cboPixExtra4.Visible := (Copy(cboForma04.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma04.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra4,Copy(cboForma04.Text,1,2));

  if (cboPixExtra4.Visible) and (cboPixExtra4.ItemIndex = -1) then
    cboPixExtra4.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_4.Visible := cboPixExtra4.Visible;
  if not chkAtalhoF6_4.Visible then
  begin
    chkAtalhoF6_4.Checked := False;
    chkAtalhoF6_4Click(chkAtalhoF6_4);
  end;
end;

procedure TFormasP.cboForma05Change(Sender: TObject);
begin
  cboPixExtra5.Visible := (Copy(cboForma05.Text,1,2) = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO) or (Copy(cboForma05.Text,1,2) = NFCE_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO)  ;

  CarregaOpcaoTipoPix(cboPixExtra5,Copy(cboForma05.Text,1,2));

  if (cboPixExtra5.Visible) and (cboPixExtra5.ItemIndex = -1) then
    cboPixExtra5.ItemIndex := 0;

  //Mauricio Parizotto 2024-12-04
  chkAtalhoF6_5.Visible := cboPixExtra5.Visible;
  if not chkAtalhoF6_5.Visible then
  begin
    chkAtalhoF6_5.Checked := False;
    chkAtalhoF6_5Click(chkAtalhoF6_5);
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
    if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') then // Sandro Silva 2023-07-31 if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') then 
    begin
      Combo.Items.Add(DESC_FORMA_16_DEPOSITO_BANCARIO);
      Combo.Items.Add(DESC_FORMA_17_PAGAMENTO_INSTANTANEO);
      Combo.Items.Add(DESC_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL);
      Combo.Items.Add(DESC_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL);
      Combo.Items.Add(DESC_FORMA_20_PAGAMENTO_INSTANTANEO_PIX_ESTATICO);
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
    CarregaCombo(cboForma01);
    CarregaCombo(cboForma02);
    CarregaCombo(cboForma03);
    CarregaCombo(cboForma04);
    CarregaCombo(cboForma05);
    CarregaCombo(cboForma06);
    CarregaCombo(cboForma07);
    CarregaCombo(cboForma08);

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

  CarregaInformacoes;

end;

procedure TFormasP.FormCreate(Sender: TObject);
var
  iPosLeft : integer;
begin
  FormasP.BorderStyle := bsNone; // Sandro Silva 2021-08-09
  AjustaResolucao(FormasP); // Sandro Silva 2018-08-28
  AjustaResolucao(FormaSP.Frame_teclado1);

  chkAplicarForma.Left  := Edit12.Left;
  chkAplicarForma.Width := Edit12.Width;
  chkAplicarForma.Top   := Edit12.BoundsRect.Bottom + AjustaAltura(7);
  chkAplicarForma.Font  := Label1.Font;

  {Sandro Silva 2021-08-30 inicio}
  chkUsandoTefCarteirasDigitais.Left  := cboForma08.Left;
  //chkUsandoTefCarteirasDigitais.Width := cboForma08.Width;
  chkUsandoTefCarteirasDigitais.Top   := chkAplicarForma.Top;// cboForma08.BoundsRect.Bottom + AjustaAltura(7);
  chkUsandoTefCarteirasDigitais.Font  := Label1.Font;
  {Sandro Silva 2021-08-30 fim}   

  //Sandro Silva 2024.01.22 FormasP.Top    := Screen.Height - FormasP.Height div 2;
  //Sandro Silva 2024.01.22 FormasP.Left   := Screen.Width - FormasP.Width div 2;

  //Mauricio Parizotto 2024-06-14
  {Mauricio Parizotto 2024-12-04 Início
  cboPixExtra1.Left := chkReceberExtra1.Left + 180;
  cboPixExtra2.Left := chkReceberExtra2.Left + 180;
  cboPixExtra3.Left := chkReceberExtra3.Left + 180;
  cboPixExtra4.Left := chkReceberExtra4.Left + 180;
  cboPixExtra5.Left := chkReceberExtra5.Left + 180;
  cboPixExtra6.Left := chkReceberExtra6.Left + 180;
  cboPixExtra7.Left := chkReceberExtra7.Left + 180;
  cboPixExtra8.Left := chkReceberExtra8.Left + 180;
  }

  if Screen.Width > 1900 then
    iPosLeft := chkReceberExtra1.Left + 180
  else
    iPosLeft := chkReceberExtra1.Left + 150;

  cboPixExtra1.Left := iPosLeft;
  cboPixExtra2.Left := iPosLeft;
  cboPixExtra3.Left := iPosLeft;
  cboPixExtra4.Left := iPosLeft;
  cboPixExtra5.Left := iPosLeft;
  cboPixExtra6.Left := iPosLeft;
  cboPixExtra7.Left := iPosLeft;
  cboPixExtra8.Left := iPosLeft;

  chkAtalhoF6_1.Left := cboPixExtra1.Left + cboPixExtra1.Width + 10;
  chkAtalhoF6_2.Left := cboPixExtra2.Left + cboPixExtra2.Width + 10;
  chkAtalhoF6_3.Left := cboPixExtra3.Left + cboPixExtra3.Width + 10;
  chkAtalhoF6_4.Left := cboPixExtra4.Left + cboPixExtra4.Width + 10;
  chkAtalhoF6_5.Left := cboPixExtra5.Left + cboPixExtra5.Width + 10;
  chkAtalhoF6_6.Left := cboPixExtra6.Left + cboPixExtra6.Width + 10;
  chkAtalhoF6_7.Left := cboPixExtra7.Left + cboPixExtra7.Width + 10;
  chkAtalhoF6_8.Left := cboPixExtra8.Left + cboPixExtra8.Width + 10;
end;

procedure TFormasP.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormasP.CarregaInformacoes;
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
  Mais1ini    := TIniFile.Create('FRENTE.INI');

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

    if AllTrim(Edit5.Text)  <> '' then cboForma01.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 1','5' )) else cboForma01.Text  := '';
    if AllTrim(Edit6.Text)  <> '' then cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 2','6' )) else cboForma02.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 3','7' )) else cboForma03.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 4','8' )) else cboForma04.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 5','9' )) else cboForma05.Text  := '';
    if AllTrim(Edit10.Text) <> '' then cboForma06.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 6','10')) else cboForma06.Text := '';
    if AllTrim(Edit11.Text) <> '' then cboForma07.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 7','11')) else cboForma07.Text := '';
    if AllTrim(Edit12.Text) <> '' then cboForma08.Text := LimpaNumero(Mais1Ini.ReadString('Frente de caixa','Ordem forma extra 8','12')) else cboForma08.Text := '';
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

    if AllTrim(Edit5.Text)  <> '' then cboForma01.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1','5' )) else cboForma01.Text  := '';
    if AllTrim(Edit6.Text)  <> '' then cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','6' )) else cboForma02.Text  := '';
    if AllTrim(Edit7.Text)  <> '' then cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','7' )) else cboForma03.Text  := '';
    if AllTrim(Edit8.Text)  <> '' then cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','8' )) else cboForma04.Text  := '';
    if AllTrim(Edit9.Text)  <> '' then cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','9' )) else cboForma05.Text  := '';
    if AllTrim(Edit10.Text) <> '' then cboForma06.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','10')) else cboForma06.Text := '';
    if AllTrim(Edit11.Text) <> '' then cboForma07.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','11')) else cboForma07.Text := '';
    if AllTrim(Edit12.Text) <> '' then cboForma08.Text := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','12')) else cboForma08.Text := '';

    if AllTrim(Edit5.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1', '')) <> '' then
        cboForma01.ItemIndex  := ComboIndex(cboForma01, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1', '')), 2));
      if cboForma01.ItemIndex = -1 then
        cboForma01.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 1','' )) ;
    end
    else
      cboForma01.Text  := '';

    if AllTrim(Edit6.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2', '')) <> '' then
        cboForma02.ItemIndex  := ComboIndex(cboForma02, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2', '')), 2));
      if cboForma02.ItemIndex = -1 then
        cboForma02.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 2','' )) ;
    end
    else
      cboForma02.Text  := '';

    if AllTrim(Edit7.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')) <> '' then
        cboForma03.ItemIndex  := ComboIndex(cboForma03, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3', '')), 2));
      if cboForma03.ItemIndex = -1 then
        cboForma03.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 3','' )) ;
    end
    else
      cboForma03.Text  := '';

    if AllTrim(Edit8.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')) <> '' then
        cboForma04.ItemIndex  := ComboIndex(cboForma04, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4', '')), 2));
      if cboForma04.ItemIndex = -1 then
        cboForma04.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 4','' )) ;
    end
    else
      cboForma04.Text  := '';

    if AllTrim(Edit9.Text)  <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')) <> '' then
        cboForma05.ItemIndex  := ComboIndex(cboForma05, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5', '')), 2));
      if cboForma05.ItemIndex = -1 then
        cboForma05.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 5','' )) ;
    end
    else
      cboForma05.Text  := '';

    if AllTrim(Edit10.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')) <> '' then
        cboForma06.ItemIndex  := ComboIndex(cboForma06, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6', '')), 2));
      if cboForma06.ItemIndex = -1 then
        cboForma06.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 6','' )) ;
    end
    else
      cboForma06.Text := '';

    if AllTrim(Edit11.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')) <> '' then
        cboForma07.ItemIndex  := ComboIndex(cboForma07, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7', '')), 2));
      if cboForma07.ItemIndex = -1 then
        cboForma07.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 7','' )) ;
    end
    else
      cboForma07.Text := '';

    if AllTrim(Edit12.Text) <> '' then
    begin
      if LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')) <> '' then
        cboForma08.ItemIndex  := ComboIndex(cboForma08, Right('0' + LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8', '')), 2));
      if cboForma08.ItemIndex = -1 then
        cboForma08.Text  := LimpaNumero(Mais1Ini.ReadString(SECAO_65,'Ordem forma extra 8','' )) ;
    end
    else
      cboForma08.Text := '';

    {Mauricio Parizotto 2024-06-14 Inicio}
    cboPixExtra1.ItemIndex := cboPixExtra1.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 1', ''));
    cboPixExtra2.ItemIndex := cboPixExtra2.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 2', ''));
    cboPixExtra3.ItemIndex := cboPixExtra3.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 3', ''));
    cboPixExtra4.ItemIndex := cboPixExtra4.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 4', ''));
    cboPixExtra5.ItemIndex := cboPixExtra5.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 5', ''));
    cboPixExtra6.ItemIndex := cboPixExtra6.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 6', ''));
    cboPixExtra7.ItemIndex := cboPixExtra7.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 7', ''));
    cboPixExtra8.ItemIndex := cboPixExtra8.Items.IndexOf(Mais1Ini.ReadString(SECAO_65,'Tipo Pix 8', ''));
    {Mauricio Parizotto 2024-06-14 Fim}
  end;

  Mais1ini.Free;

  //Mauricio Parizotto 2024-12-04
  sFormaAtalhoF6 := GetFormaAtalhoF6;

  //Mauricio Parizotto 2024-06-14
  cboForma01Change(nil);
  cboForma02Change(nil);
  cboForma03Change(nil);
  cboForma04Change(nil);
  cboForma05Change(nil);
  cboForma06Change(nil);
  cboForma07Change(nil);
  cboForma08Change(nil);
end;

procedure TFormasP.CarregaOpcaoTipoPix(ComboOpcao:Tcombobox; FormaPgto : string);
var
  sTipoPix : string;
begin
  sTipoPix := ComboOpcao.Text;
  ComboOpcao.Items.Clear;
  ComboOpcao.Items.Add(_PixManual);
  ComboOpcao.Items.Add(_PixEstatico);

  if FormaPgto = NFCE_FORMA_17_PAGAMENTO_INSTANTANEO_PIX_DINAMICO then
    ComboOpcao.Items.Add(_PixDinamico);

  //Tenta voltar para a opção que tinha antes
  ComboOpcao.ItemIndex := ComboOpcao.Items.IndexOf(sTipoPix);

  OpcaoLancaContaReceber;
end;

procedure TFormasP.OpcaoLancaContaReceber;  //Mauricio Parizotto 2024-09-06
begin
  chkReceberExtra1.Enabled := Copy(cboForma01.Text,1,2) <> '17';
  chkReceberExtra2.Enabled := Copy(cboForma02.Text,1,2) <> '17';
  chkReceberExtra3.Enabled := Copy(cboForma03.Text,1,2) <> '17';
  chkReceberExtra4.Enabled := Copy(cboForma04.Text,1,2) <> '17';
  chkReceberExtra5.Enabled := Copy(cboForma05.Text,1,2) <> '17';
  chkReceberExtra6.Enabled := Copy(cboForma06.Text,1,2) <> '17';
  chkReceberExtra7.Enabled := Copy(cboForma07.Text,1,2) <> '17';
  chkReceberExtra8.Enabled := Copy(cboForma08.Text,1,2) <> '17';


  //Marca a opção se tiver desabilitada
  if not chkReceberExtra1.Enabled then
   chkReceberExtra1.Checked := True;

  if not chkReceberExtra2.Enabled then
   chkReceberExtra2.Checked := True;

  if not chkReceberExtra3.Enabled then
   chkReceberExtra3.Checked := True;

  if not chkReceberExtra4.Enabled then
   chkReceberExtra4.Checked := True;

  if not chkReceberExtra5.Enabled then
   chkReceberExtra5.Checked := True;

  if not chkReceberExtra6.Enabled then
   chkReceberExtra6.Checked := True;

  if not chkReceberExtra7.Enabled then
   chkReceberExtra7.Checked := True;

  if not chkReceberExtra8.Enabled then
   chkReceberExtra8.Checked := True;
end;

procedure TFormasP.SetCheckAtalhoF6; //Mauricio Parizotto 2024-12-04
begin
  chkAtalhoF6_1.OnClick := nil;
  chkAtalhoF6_2.OnClick := nil;
  chkAtalhoF6_3.OnClick := nil;
  chkAtalhoF6_4.OnClick := nil;
  chkAtalhoF6_5.OnClick := nil;
  chkAtalhoF6_6.OnClick := nil;
  chkAtalhoF6_7.OnClick := nil;
  chkAtalhoF6_8.OnClick := nil;

  chkAtalhoF6_1.Checked := (sFormaAtalhoF6 = 'Forma extra 1');
  chkAtalhoF6_2.Checked := (sFormaAtalhoF6 = 'Forma extra 2');
  chkAtalhoF6_3.Checked := (sFormaAtalhoF6 = 'Forma extra 3');
  chkAtalhoF6_4.Checked := (sFormaAtalhoF6 = 'Forma extra 4');
  chkAtalhoF6_5.Checked := (sFormaAtalhoF6 = 'Forma extra 5');
  chkAtalhoF6_6.Checked := (sFormaAtalhoF6 = 'Forma extra 6');
  chkAtalhoF6_7.Checked := (sFormaAtalhoF6 = 'Forma extra 7');
  chkAtalhoF6_8.Checked := (sFormaAtalhoF6 = 'Forma extra 8');

  chkAtalhoF6_1.OnClick := chkAtalhoF6_1Click;
  chkAtalhoF6_2.OnClick := chkAtalhoF6_2Click;
  chkAtalhoF6_3.OnClick := chkAtalhoF6_3Click;
  chkAtalhoF6_4.OnClick := chkAtalhoF6_4Click;
  chkAtalhoF6_5.OnClick := chkAtalhoF6_5Click;
  chkAtalhoF6_6.OnClick := chkAtalhoF6_6Click;
  chkAtalhoF6_7.OnClick := chkAtalhoF6_7Click;
  chkAtalhoF6_8.OnClick := chkAtalhoF6_8Click;
end;

end.


