unit Unit35;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Db, inifiles, Spin, SmallFunc,
  ComCtrls;

type
  TForm35 = class(TForm)
    ColorDialog1: TColorDialog;
    Button5: TButton;
    Button6: TButton;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox1: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    GroupBox3: TGroupBox;
    Label19: TLabel;
    Edit2: TEdit;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Edit4: TEdit;
    Label10: TLabel;
    Label2: TLabel;
    Edit5: TEdit;
    Label11: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Label12: TLabel;
    Label7: TLabel;
    Edit8: TEdit;
    Label13: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Label14: TLabel;
    Label5: TLabel;
    Edit6: TEdit;
    Label15: TLabel;
    Label8: TLabel;
    Edit7: TEdit;
    Label16: TLabel;
    Label9: TLabel;
    Edit9: TEdit;
    Label17: TLabel;
    GroupBox6: TGroupBox;
    Label18: TLabel;
    SpinEdit1: TSpinEdit;
    Label23: TLabel;
    SpinEdit3: TSpinEdit;
    Label20: TLabel;
    SpinEdit2: TSpinEdit;
    ComboBox2: TComboBox;
    Label21: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit9KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Image5Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure SpinEdit2Exit(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpinButton2DownClick(Sender: TObject);
    procedure SpinButton3DownClick(Sender: TObject);
    procedure SpinButton4DownClick(Sender: TObject);
    procedure SpinButton5DownClick(Sender: TObject);
    procedure SpinButton6DownClick(Sender: TObject);
    procedure SpinButton7DownClick(Sender: TObject);
    procedure SpinButton8DownClick(Sender: TObject);
    procedure SpinButton2UpClick(Sender: TObject);
    procedure SpinButton3UpClick(Sender: TObject);
    procedure SpinButton4UpClick(Sender: TObject);
    procedure SpinButton5UpClick(Sender: TObject);
    procedure SpinButton6UpClick(Sender: TObject);
    procedure SpinButton7UpClick(Sender: TObject);
    procedure SpinButton8UpClick(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit4Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form35: TForm35;
  cColor : TColor;
implementation

uses Unit15, Mais, Unit7, Mais3;

Function Tecla(cTl : Char): char;
begin
  Tecla  := cTl;
  if cTl = #46 then Tecla := #44;
  if ((Ord(cTl)<48) or (Ord(cTl)>57)) and (Ord(cTl)<>8) and (Ord(cTl)<>44) and (Ord(cTl)<>46) then Tecla := #0;
end;

Function TotalDeColunas(sTotal : String): Boolean;
Begin
  TotalDeColunas := True;
  if StrToFloat(sTotal) > 8 Then // Número máximo de colunas é 5
  begin
     MessageDlg('Número de colunas por linha fora dos padrões permitidos: 1 à 8 !', MtInformation, [mbok], 0);
     TotalDeColunas := False;
  end;
end;
{$R *.DFM}

procedure TForm35.Image1Click(Sender: TObject);
begin
   edit1.setfocus;
end;

procedure TForm35.Image3Click(Sender: TObject);
begin
   edit3.SetFocus;
end;

procedure TForm35.Image4Click(Sender: TObject);
begin
   edit6.SetFocus;
end;

procedure TForm35.Image6Click(Sender: TObject);
begin
   edit1.SetFocus;
end;

procedure TForm35.Image7Click(Sender: TObject);
begin
   edit7.SetFocus;
end;

procedure TForm35.Image8Click(Sender: TObject);
begin
   edit8.SetFocus;
end;

procedure TForm35.Image9Click(Sender: TObject);
begin
   edit9.SetFocus;
end;

procedure TForm35.FormCreate(Sender: TObject);
begin
  //
  cColor := ClBlack;
  //
end;

procedure TForm35.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if ((Key<#48) or (Key>#57)) and (Key<>#8) and (Key<>#44) then Key := #0;
end;

procedure TForm35.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  Key := Tecla(Key);
end;

procedure TForm35.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  Key := Tecla(Key);
end;

procedure TForm35.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  Key := Tecla(Key);
end;

procedure TForm35.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #44) or (key = #46) then Key := #0;
  Key := Tecla(Key);
end;

procedure TForm35.Edit9KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #44) or (key = #46) then Key := #0;
  Key := Tecla(Key);
end;

procedure TForm35.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  Key := Tecla(Key);
end;

procedure TForm35.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
  Key := Tecla(Key);
end;


procedure TForm35.Image5Click(Sender: TObject);
begin
   edit8.SetFocus;
end;

procedure TForm35.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked = True  then
  begin
     //
     Edit2.Enabled   := True;
     Edit2.SetFocus;
     Edit2.SelectAll;
     //
     if ComboBox2.Text = 'Matricial' then
     begin
        Edit2.Font.Color := 0;
     end;

  end;

  if CheckBox3.Checked = False then
  begin
     Edit2.Enabled   := False;
  end;

end;

procedure TForm35.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm35.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked = True then
  begin
     RadioButton2.Checked := False;
     RadioButton3.Checked := False;
  end;
end;

procedure TForm35.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked = True then
  begin
     RadioButton1.Checked := False;
     RadioButton3.Checked := False;
  end;
end;

procedure TForm35.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked = True then
  begin
     RadioButton1.Enabled := False;
     RadioButton2.Enabled := False;
     RadioButton3.Enabled := False;
     RadioButton3.Checked := True;


     CheckBox5.Enabled := True;
     CheckBox6.Enabled := True;
     SpinEdit1.Enabled := False;
     SpinEdit2.Enabled := True;
     SpinEdit3.Enabled := False;

     ComboBox2.Text    := 'Jato de tinta';
     
  end else
  begin
     RadioButton1.Enabled := True;
     RadioButton3.Enabled := True;

     CheckBox5.Checked := False;
     CheckBox6.Checked := False;
     CheckBox5.Enabled := False;
     CheckBox6.Enabled := False;

     SpinEdit1.Enabled := True;
     SpinEdit2.Enabled := False;
     SpinEdit3.Enabled := True;

  end;

end;

procedure TForm35.SpinEdit2Exit(Sender: TObject);
begin
   if (SpinEdit2.Value > 20) or (SpinEdit2.Value < 11) then SpinEdit2.Value := 14;
end;

procedure TForm35.SpinEdit1Exit(Sender: TObject);
begin
   if (SpinEdit1.Value > 20) or (SpinEdit1.Value < 4) then SpinEdit1.Value := 8;
end;

procedure TForm35.RadioButton3Click(Sender: TObject);
begin
  if RadioButton3.Checked = True then
  begin
     RadioButton1.Checked := False;
     RadioButton2.Checked := False;
  end;
end;

procedure TForm35.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  key := #0;
end;

procedure TForm35.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.Text =  'Matricial' then
  begin
     CheckBox4.Enabled := False;
     CheckBox4.Checked := False;
     CheckBox5.Enabled := False;
     CheckBox5.Checked := False;
     CheckBox6.Enabled := False;
     CheckBox6.Checked := False;
     if CheckBox3.Checked = True Then
     begin
        Edit2.Font.Color := 0;
     end;
  end else
  begin
     if Form7.sModulo = 'ESTOQUE' then CheckBox4.Enabled := True;
  end;
end;

procedure TForm35.ComboBox2Exit(Sender: TObject);
begin
  if ComboBox2.Text = 'Matricial' then
  begin
    MessageDlg('Ao selecionar um modelo de impressora matricial lembre-se que a unidade de medida das etiquetas ' +
              'passa a ser cc (caracter) e para facilitar a configuração utilize a régua impressa pelo programa ' +
              'no modo caracter comprimido de sua impressora matricial.', MtInformation,[mbok], 0);
    Form35.ComboBox2Change(Sender);
    Label10.Caption := 'cc';
    Label11.Caption := 'cc';
    Label12.Caption := 'cc';
    Label13.Caption := 'cc';
    Label14.Caption := 'cc';
    Label15.Caption := 'cc';
    Label16.Caption := 'cc';
    Label17.Caption := 'cc';
  end else
  begin
    Label10.Caption := 'mm';
    Label11.Caption := 'mm';
    Label12.Caption := 'mm';
    Label13.Caption := 'mm';
    Label14.Caption := 'mm';
    Label15.Caption := 'mm';
    Label16.Caption := 'mm';
    Label17.Caption := 'mm';
  end;
  if Form7.sModulo <> 'ESTOQUE' then
  begin
     Form35.CheckBox4.Enabled := False;
     Form35.CheckBox5.Enabled := False;
     Form35.CheckBox6.Enabled := False;
     //
     Form35.CheckBox4.Checked := False;
     Form35.CheckBox5.Checked := False;
     Form35.CheckBox6.Checked := False;
  end;

end;

procedure TForm35.FormActivate(Sender: TObject);
  var
  ArqINI  : TiniFile;
  sOpcoes : String;
  iOp     : Integer;
begin
  //
  Button6.Tag := 0;
  //
  if Form7.sModulo <> 'ESTOQUE' then
  begin
    Form35.RadioButton2.Enabled := True;  {Habilita a opção de mala direta}

    Form35.CheckBox4.Enabled := False;    {Desabilita a opção de código de barras}
    Form35.CheckBox5.Enabled := False;
    Form35.CheckBox6.Enabled := False;
    //
    Form35.CheckBox4.Checked := False;
    Form35.CheckBox5.Checked := False;
    Form35.CheckBox6.Checked := False;
    //
  end else
  begin
    Form35.CheckBox4.Enabled := True;     {Habilita a opção de código de barras}
    //
    Form35.RadioButton2.Enabled := False;
    Form35.RadioButton3.Checked := True;  {Marca a opção para imprimir apenas os dados}
    //
  end;
  //
//  ShowMessage(Form15.ibTable1.ibTableName);
  //

  if (Form15.CheckBox1.Checked = True) and (Form7.sModulo = 'ESTOQUE') then
  begin
    Form35.CheckBox4.Checked  := True;
  end Else
  begin
     Form35.CheckBox4.Checked := False;
     Form35.CheckBox5.Checked := False;
     Form35.CheckBox6.Checked := False;
  end;
  if Form15.CheckBox1.Enabled = False then
  begin
     Form35.CheckBox4.Enabled := False;
     Form35.CheckBox4.Checked := False;
  end else if Form7.sModulo = 'ESTOQUE' then Form35.CheckBox4.Enabled := True;
  if (Form15.CheckBox2.Checked = True) and (form7.sModulo <> 'ESTOQUE') then Form35.RadioButton2.Checked := True Else Form35.RadioButton3.Checked := True;

  {Lê as configurações da tela conforme a última vez que foram confirmadas pelo botão Ok do Form35}
  ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
  ArqIni.UpdateFile;
  sOpcoes      := arqINI.ReadString('CONFIG' ,'Opcoes', 'FFT');
  iOp := 1;
  //
  While iOp <= Length(sOpcoes) do // Verifica qual o RadioButton que está marcado
  begin
    if iOp = 1 then
       if Copy(sOpcoes, iOp, 1) = 'T' then Form35.RadioButton1.Checked := True Else Form35.RadioButton1.Checked := False;
    if iOp = 2 then
       if (Copy(sOpcoes, iOp, 1) = 'T') and (form7.sModulo <> 'ESTOQUE') then Form35.RadioButton2.Checked := True Else Form35.RadioButton2.Checked := False;
    if iOp = 3 then
       if Copy(sOpcoes, iOp, 1) = 'T' then Form35.RadioButton3.Checked := True Else Form35.RadioButton3.Checked := False;
    Inc(iOp);
  end;
  {Faz uma verificação para ver se os RadioButton não estão todos em branco}
  if (RadioButton1.Checked = False) and (RadioButton2.Checked = False) and
     (RadioButton3.Checked = False) then RadioButton3.Checked := True;
  //
  //Form35.SpinEdit1.Value := StrToInt(arqINI.ReadString('CONFIG' ,'FonteN', '7'));
  sOpcoes                := arqINI.ReadString('CONFIG' ,'Barras', 'FFF');
  iOp := 1;
  While (iOp <= Length(sOpcoes)) and (Form7.sModulo = 'ESTOQUE') do // Verifica os CheckBoxs que estão marcados referente código de barras
  begin
    if iOp = 1 then
       if Copy(sOpcoes, iOp, 1) = 'T' then Form35.CheckBox4.Checked := True Else Form35.CheckBox4.Checked := False;
    if iOp = 2 then
       if Copy(sOpcoes, iOp, 1) = 'T' then Form35.CheckBox5.Checked := True Else Form35.CheckBox5.Checked := False;
    if iOp = 3 then
       if Copy(sOpcoes, iOp, 1) = 'T' then Form35.CheckBox6.Checked := True Else Form35.CheckBox6.Checked := False;
    Inc(iOp);
  end;
  sOpcoes                 := arqINI.ReadString('CONFIG' ,'Comentário', 'F');                           // Se o campo de comentário está marcado
  if sOpcoes = 'T' then Form35.CheckBox3.Checked := True Else Form35.CheckBox3.Checked := False;
  Form35.Edit2.Text       := arqINI.ReadString('CONFIG' ,'ComenTexto', 'DESTINATÁRIO');               // O texto do campo comentário
  Form35.Edit2.Font.Color := StrToInt(arqINI.ReadString('CONFIG' ,'ComenCor', '$00000040'));          // A cor do campo comentário
  //

  if Form7.sModulo = 'ESTOQUE' then Form15.CheckBox1Click(Sender) else Form15.CheckBox2Click(Sender);

  if ComboBox2.Text = 'Matricial' then
  begin
    Form35.ComboBox2Change(Sender);
    Label10.Caption := 'cc';
    Label11.Caption := 'cc';
    Label12.Caption := 'cc';
    Label13.Caption := 'cc';
    Label14.Caption := 'cc';
    Label15.Caption := 'cc';
    Label16.Caption := 'cc';
    Label17.Caption := 'cc';
  end else
  begin
    Label10.Caption := 'mm';
    Label11.Caption := 'mm';
    Label12.Caption := 'mm';
    Label13.Caption := 'mm';
    Label14.Caption := 'mm';
    Label15.Caption := 'mm';
    Label16.Caption := 'mm';
    Label17.Caption := 'mm';
  end;
  //
  //
end;

procedure TForm35.SpinButton1DownClick(Sender: TObject);
begin
  Edit4.Text := FloatToStr(StrTofloat(Edit4.Text) - 0.1);
  if StrToFloat(Edit4.Text) < 0 Then Edit4.Text := '0';
end;

procedure TForm35.SpinButton1UpClick(Sender: TObject);
begin
  Edit4.Text := FloatToStr(StrTofloat(Edit4.Text) + 0.1);
end;

procedure TForm35.SpinButton2DownClick(Sender: TObject);
begin
  Edit5.Text := FloatToStr(StrTofloat(Edit5.Text) - 0.1);
  if StrToFloat(Edit5.Text) < 0 Then Edit5.Text := '0';
end;

procedure TForm35.SpinButton3DownClick(Sender: TObject);
begin
  Edit1.Text := FloatToStr(StrTofloat(Edit1.Text) - 0.1);
  if StrToFloat(Edit1.Text) < 0 Then Edit1.Text := '0';
end;

procedure TForm35.SpinButton4DownClick(Sender: TObject);
begin
  Edit8.Text := FloatToStr(StrTofloat(Edit8.Text) - 0.1);
  if StrToFloat(Edit8.Text) < 0 Then Edit8.Text := '0';
end;

procedure TForm35.SpinButton5DownClick(Sender: TObject);
begin
  Edit3.Text := FloatToStr(StrTofloat(Edit3.Text) - 0.1);
  if StrToFloat(Edit3.Text) < 0 Then Edit3.Text := '0';
end;

procedure TForm35.SpinButton6DownClick(Sender: TObject);
begin
  Edit6.Text := FloatToStr(StrTofloat(Edit6.Text) - 0.1);
  if StrToFloat(Edit6.Text) < 0 Then Edit6.Text := '0';
end;

procedure TForm35.SpinButton7DownClick(Sender: TObject);
begin
  Edit7.Text := FloatToStr(StrTofloat(Edit7.Text) - 1);
  if StrToFloat(Edit7.Text) < 0 Then Edit7.Text := '0';
end;

procedure TForm35.SpinButton8DownClick(Sender: TObject);
begin
  Edit9.Text := FloatToStr(StrTofloat(Edit9.Text) - 1);
  if StrToFloat(Edit9.Text) < 0 Then Edit9.Text := '0';
end;

procedure TForm35.SpinButton2UpClick(Sender: TObject);
begin
  Edit5.Text := FloatToStr(StrTofloat(Edit5.Text) + 0.1);
end;

procedure TForm35.SpinButton3UpClick(Sender: TObject);
begin
  Edit1.Text := FloatToStr(StrTofloat(Edit1.Text) + 0.1);
end;

procedure TForm35.SpinButton4UpClick(Sender: TObject);
begin
  Edit8.Text := FloatToStr(StrTofloat(Edit8.Text) + 0.1);
end;

procedure TForm35.SpinButton5UpClick(Sender: TObject);
begin
  Edit3.Text := FloatToStr(StrTofloat(Edit3.Text) + 0.1);
end;

procedure TForm35.SpinButton6UpClick(Sender: TObject);
begin
  Edit6.Text := FloatToStr(StrTofloat(Edit6.Text) + 0.1);
end;

procedure TForm35.SpinButton7UpClick(Sender: TObject);
begin
  Edit7.Text := FloatToStr(StrTofloat(Edit7.Text) + 1);
  if StrToFloat(Edit7.Text) > 5 Then Edit7.Text := '5';
end;

procedure TForm35.SpinButton8UpClick(Sender: TObject);
begin
  Edit9.Text := FloatToStr(StrTofloat(Edit9.Text) + 1);
end;

procedure TForm35.Edit2Exit(Sender: TObject);
begin
  if (Form35.CheckBox3.Checked = True) and (Form35.Edit2.Text = '') then
  begin
     MessageDlg('É necessário informar um comentário para a impressão!', mtInformation, [mbok], 0);
     Form35.Edit2.SetFocus;
  end;
end;

procedure TForm35.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
     key := #0;
     perform (WM_NextDlgCtl, 0, 0);
  end;
end;

procedure TForm35.Button5Click(Sender: TObject);
var
  sNome  : string;
  ArqIni : TIniFile;
begin
  //
  ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
  ArqIni.UpdateFile;
  if TotalDeColunas(Edit7.text) = False then Exit;
  //
  sNome := 'Etiqueta personalizada - ' + Edit9.Text + ' linhas e ' + Edit7.Text + ' colunas -'+Senhas.UsuarioPub;
  InputQuery('Novo modelo de etiqueta', 'Digite o nome do seu modelo de etiquetas:', sNome);
  Form35.ComboBox1.Text := sNome;
end;

procedure TForm35.Button6Click(Sender: TObject);
  var
  ArqIni  : TiniFile;
  sOpcoes : string;
begin
  //
  //
  if AllTrim(Form35.ComboBox1.Text) = '' then Form35.ComboBox1.Text := 'Etiqueta personalizada pelo usuário';
  //
  // Grava as configurações da etiqueta selecionada
  //
  try
    ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Margem superior',     Form35.Edit3.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Margem esquerda',     Form35.Edit6.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Altura da pagina',    Form35.Edit5.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Largura da pagina',   Form35.Edit4.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Tamanho vertical',    Form35.Edit1.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Tamanho horizontal',  Form35.Edit8.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Linhas por folha',    Form35.Edit9.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Margem esquerda',     Form35.Edit6.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Etiquetas por linha', Form35.Edit7.Text);
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Fonte',               IntToStr(Form35.SpinEdit1.Value));
    ArqIni.WriteString(Form35.ComboBox1.Text, 'FontePreco',          IntToStr(Form35.SpinEdit3.Value));
    ArqIni.WriteString(Form35.ComboBox1.Text, 'FonteB',              IntToStr(Form35.SpinEdit2.Value));
    ArqIni.WriteString(Form35.ComboBox1.Text, 'Impressora',          Form35.ComboBox2.Text);
    //
    // Grava as configurações das opções selecionadas neste Form35
    //
    if Form35.RadioButton1.Checked = True then sOpcoes := 'T' else sOpcoes := 'F';
    if Form35.RadioButton2.Checked = True then sOpcoes := sOpcoes + 'T' else sOpcoes := sOpcoes + 'F';
    if Form35.RadioButton3.Checked = True then sOpcoes := sOpcoes + 'T' else sOpcoes := sOpcoes + 'F';
    Arqini.WriteString('CONFIG', 'Opcoes',  sOpcoes); // RadioButtons
    sOpcoes := '';
    if Form35.CheckBox4.Checked = True then sOpcoes := 'T' else sOpcoes := 'F';
    if Form35.CheckBox5.Checked = True then sOpcoes := sOpcoes + 'T' else sOpcoes := sOpcoes + 'F';
    if Form35.CheckBox6.Checked = True then sOpcoes := sOpcoes + 'T' else sOpcoes := sOpcoes + 'F';
    Arqini.WriteString('CONFIG', 'Barras',  sOpcoes); // CheckBoxs
    Arqini.WriteString('CONFIG', 'FonteC',  IntToStr(Form35.SpinEdit2.Value));
    if Form35.CheckBox3.Checked = True then sOpcoes := 'T' Else sOpcoes := 'F';
    Arqini.WriteString('CONFIG', 'Comentário',  sOpcoes);                           // Se campo comentário está marcado
    Arqini.WriteString('CONFIG', 'ComenTexto',  Form35.Edit2.Text);                 // Texto do campo comentário
    Arqini.WriteString('CONFIG', 'ComenCor',    IntToStr(Form35.Edit2.Font.Color)); // Cor do campo Comentário
    //
    ArqIni.UpdateFile;
    ArqIni.Free;
    //
    Form15.ComboBox1.Items := Form35.ComboBox1.Items;
    Form15.ComboBox1.Text  := Form35.ComboBox1.Text;
    Form15.ComboBox1.Tag   := 1;
    //
  except end;
  //
  try
    //
    // Se o CheckBox do código de barras estiver marcado, marca também no form15
    //
    if (Form35.CheckBox4.Checked = True) and (Form15.CheckBox1.Enabled = True) then Form15.CheckBox1.Checked := True Else Form15.CheckBox1.Checked := False;
    {Se o RadioButton de mala direta estiver marcado, marca também no Check do form15}
    if Form35.RadioButton2.Checked = True then Form15.CheckBox2.Checked := True Else Form15.CheckBox2.Checked := False;
    // Verifica qual das opções do ComboBox3 foi selecionada e marca o RadioButton correpondente no form15
    //
  except end;
  //
  Close;
  //
end;

procedure TForm35.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Button5.Caption = '&Salvar' then
  begin
    Button6.Tag := 0;
    Button5.Caption := '&Nova Etiqueta';
    Button6.Enabled := True;
    ComboBox1.Enabled := True;
    MessageBox(0, 'Suas configurações de etiquetas não foram salvas.',
                  'Configurações não salvas', 0);
    Form15.ComboBox1.SetFocus;
  end;
  //
  //
end;


procedure TForm35.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ArqIni  : TiniFile;
begin
  if Key = VK_DELETE then
  begin
    if MessageDlg('Deseja apagar o modelo de etiquetas:' + chr(13) + ComboBox1.Text,
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
      Arqini.EraseSection(ComboBox1.Text);
      Form35.ComboBox1.Clear;
      Form15.ComboBox1.Clear;
      Form35.ComboBox1.Items := Form15.ComboBox1.Items;
      ComboBox1.ItemIndex := 4;
      ArqIni.Free;
    end;
  end;
end;

procedure TForm35.Edit4Change(Sender: TObject);
begin
  with Sender as TEdit do Text := LimpaNumeroDeixandoAVirgula(Text);
end;

procedure TForm35.ComboBox1Change(Sender: TObject);
var
  ArqINI : TiniFile;
begin
  //
  ArqINI := TiniFile.create(Form1.sAtual + '\etiquetas.inf');
  //
  if AllTrim(Form35.ComboBox1.Text) = '' then Form35.ComboBox1.Text := '25,4mm x 101,6mm - 10 linhas e 2 colunas (20 etiquetas por folha)';
  //
  Form35.Edit3.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Margem superior',     '0');
  Form35.Edit6.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Margem esquerda',     '0');
  Form35.Edit5.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Altura da pagina',    '0');
  Form35.Edit4.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Largura da pagina',   '0');
  Form35.Edit1.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Tamanho vertical',    '0');
  Form35.Edit8.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Tamanho horizontal',  '0');
  Form35.Edit9.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Linhas por folha',    '0');
  Form35.Edit7.text      := arqINI.ReadString(Form35.ComboBox1.Text,'Etiquetas por linha', '0');
  Form35.SpinEdit1.Value := StrToInt(arqINI.ReadString(Form35.ComboBox1.Text,'Fonte',      '0'));
  Form35.SpinEdit3.Value := StrToInt(arqINI.ReadString(Form35.ComboBox1.Text,'FontePreco', arqINI.ReadString(Form35.ComboBox1.Text,'Fonte', '0')));
  Form35.SpinEdit2.Value := StrToInt(arqINI.ReadString(Form35.ComboBox1.Text,'FonteB',     '0'));
  Form35.Combobox2.Text  := arqINI.ReadString(Form35.ComboBox1.Text,'Impressora',          'Jato de tinta');
  //
  if Form35.ComboBox2.Text = 'Matricial' then
  begin
    Label10.Caption := 'cc';
    Label11.Caption := 'cc';
    Label12.Caption := 'cc';
    Label13.Caption := 'cc';
    Label14.Caption := 'cc';
    Label15.Caption := 'cc';
    Label16.Caption := 'cc';
    Label17.Caption := 'cc';
  end else
  begin
    Label10.Caption := 'mm';
    Label11.Caption := 'mm';
    Label12.Caption := 'mm';
    Label13.Caption := 'mm';
    Label14.Caption := 'mm';
    Label15.Caption := 'mm';
    Label16.Caption := 'mm';
    Label17.Caption := 'mm';
  end;
end;

procedure TForm35.Edit9Change(Sender: TObject);
begin
  with Sender as TEdit do Text := LimpaNumero(Text);
end;

end.


