unit Unit9;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, IniFiles, SmallFunc;
  
type
  TForm9 = class(TForm)
    ScrollBox1: TScrollBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    CheckBox32: TCheckBox;
    CheckBox33: TCheckBox;
    CheckBox34: TCheckBox;
    CheckBox35: TCheckBox;
    CheckBox36: TCheckBox;
    CheckBox37: TCheckBox;
    CheckBox38: TCheckBox;
    CheckBox39: TCheckBox;
    CheckBox40: TCheckBox;
    CheckBox41: TCheckBox;
    CheckBox42: TCheckBox;
    CheckBox43: TCheckBox;
    CheckBox44: TCheckBox;
    CheckBox45: TCheckBox;
    CheckBox46: TCheckBox;
    CheckBox47: TCheckBox;
    CheckBox48: TCheckBox;
    CheckBox49: TCheckBox;
    CheckBox50: TCheckBox;
    CheckBox51: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    bChave : Boolean;
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

uses
Unit7, Mais;

{$R *.DFM}

procedure TForm9.CheckBox1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  I       : Integer;
begin
  //
  if bChave then
  begin
    //
    Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
    //
    Form7.sMostra := '';
    for I := 1 to Form7.iCampos do
    begin
      if TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked = True then
        Form7.sMostra := Form7.sMostra + 'T'
      else
        Form7.sMostra := Form7.sMostra + 'F';
    end;
    //
    if Copy(Form7.sMostra,1,Form7.iCampos) = Replicate('F',Form7.iCampos) then
    begin
      Form7.sMostra := Replicate('T',Form7.iCampos);
      for I := 1 to Form7.iCampos do
      begin
        if Form7.ArquivoAberto.Fields[I-1].Visible = True then
          TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked := True
        else
          TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked := False;
      end;
    end;
    //
    // showmessage('Teste mostrar '+Form7.sModulo);
    //
    if Form7.sRPS = 'S' then
    begin
      Mais1Ini.WriteString('RPS','Mostrar',Form7.sMostra);
    end else
    begin
      Mais1Ini.WriteString(form7.sModulo,'Mostrar',Form7.sMostra);
    end;
    //
    Mais1Ini.Free;
    //
    {Sandro Silva 2022-12-20 inicio
    with Form7 do
    begin
      with ArquivoAberto do
      begin
        for I := 1 to iCampos do
        begin
          if Copy(Form7.sMostra,I,1) = 'T' then
            Fields[I-1].Visible := True
          else
            Fields[I-1].Visible := False;
        end;
      end;
    end;
    }
    for I := 1 to Form7.iCampos do
    begin
      Form7.ArquivoAberto.Fields[I-1].Visible := (Copy(Form7.sMostra,I,1) = 'T');
    end;

    {Sandro Silva 2022-12-20 fim}
    //
  end;
  //
end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form9.CheckBox8.Enabled := True;
  Form9.CheckBox9.Enabled := True;
  Form9.CheckBox10.Enabled := True;
end;

procedure TForm9.FormShow(Sender: TObject);
var
  I: Integer;
  iChecked: Integer; // Quantidade de checkbox
begin
  //
  bChave := False;
  //
  Form9.Width := 215;
  Form9.Left  := Form1.Width - Form9.Width + Form7.Left -15;
  Form9.Top   := Form7.Top + 25;
  if Form9.Height <= 50 then
    Form9.Height := 70;

  {Sandro Silva 2023-01-04 inicio}
  // Identifica quantos checkbox exitem;
  iChecked := -1;
  for I := 0 to Form9.ScrollBox1.ControlCount -1 do
  begin
    if Form9.ScrollBox1.Controls[i].ClassType = TCheckBox then
      Inc(iChecked);
  end;
  {Sandro Silva 2023-01-04 fim}

  //
  // Todos os CheckBox não visíveis
  //
  for I := 0 to iChecked do // Sandro Silva 2023-01-04 for I := 0 to 48 do
    TcheckBox(Form9.Components[I+CheckBox1.ComponentIndex]).Visible := False;

  //
  // ComponentIndex descobre qual o valor do primeiro checkbox no indice
  // Components acessa diretamente o indice do componente é possível
  // inclusive mudar o valor das suas propriedades
  //
  Form9.Height := 5;

  //
  for I := 1 to Form7.iCampos do
  begin
    try
      TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Visible := True;
      TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Caption := Form7.ArquivoAberto.Fields[I-1].DisplayLabel;
      {Sandro Silva 2023-01-04 inicio
      if Form7.ArquivoAberto.Fields[I-1].Visible = True then
        TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked := True
      else
        TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked := False;
      }
      TcheckBox(Form9.Components[I-1+CheckBox1.ComponentIndex]).Checked := Form7.ArquivoAberto.Fields[I-1].Visible;
      {Sandro Silva 2023-01-04 fim}

      if Form9.Height < Screen.Height then
        Form9.Height := Form9.Height + 25;
    except
    end;
  end;
  //
  Form9.Height := form9.Height - 2;
  if Form9.Height < 110 then
    Form9.Height := 110;
  if Form9.Height > (Form7.Height -25) then
    Form9.Height := Form7.Height -25;
  //
  bChave := True;
  //
end;

end.

