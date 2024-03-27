unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles, SmallFunc_xe, Buttons;

type
  TForm15 = class(TForm)
    Panel1: TPanel;
    Label5: TLabel;
    Label4: TLabel;
    Usuario: TComboBox;
    SENHA: TEdit;
    Button1: TBitBtn;
    Button2: TBitBtn;
    LabelF10Indisponivel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UsuarioKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UsuarioExit(Sender: TObject);
    procedure UsuarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SENHAKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure SENHAClick(Sender: TObject);
    procedure SENHAEnter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
     SenhaPub: String;
     UsuarioPub: String;

  end;

var
  Form15: TForm15;

implementation

uses Unit22, fiscal, Unit12, ufuncoesfrente, urequisitospafnfce;

{$R *.dfm}

procedure TForm15.FormCreate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Form15.Position := poDesigned; // Sandro Silva 2021-07-30;
  //
  Mais1ini := TIniFile.Create('MAIS1.INI');
  Usuario.Text := Mais1Ini.ReadString('Usuarios','Nome',Usuario.Text);
  Mais1Ini.Free;
  if length(Usuario.Text) = 0 then Usuario.TabOrder := 0;
  //
end;

procedure TForm15.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  I : Integer;
begin
  //
  Form22.Label6.Caption := '';
  //
  Form15.Senha.Text := '';
  Form15.SENHA.SetFocus;
  //
  sSecoes := TStringList.Create;
  //
  Mais1ini := TIniFile.Create('MAIS1.INI');
  Usuario.Text := Mais1Ini.ReadString('Usuarios','Nome',Usuario.Text);
  //
  Mais1Ini.Free;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  Mais1Ini.ReadSections(sSecoes);
  //
  for I := 0 to (sSecoes.Count - 1) do
  begin
    if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
    begin
      if AllTrim(sSecoes[I]) <> 'Administrador' then
      begin
        if Mais1Ini.ReadString(sSecoes[I],'Chave','') <> '' then
        begin
          Usuario.Items.Add(sSecoes[I]);
        end else
        begin
          Mais1ini.EraseSection(sSecoes[I]);
        end;
      end;
    end;
  end;
  //
  {Sandro Silva 2018-11-21 inicio
  Memória} 
  Mais1Ini.Free;
  sSecoes.Free;
  {Sandro Silva 2018-11-21 fim}
end;

procedure TForm15.UsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then SENHA.SetFocus;
end;

procedure TForm15.UsuarioExit(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  //
  if UpperCase(AllTrim(USUARIO.Text)) = 'ADMINISTRADOR' then
  begin
    ShowMessage('Usuário inválido.');
    USUARIO.Text := '';
    USUARIO.SetFocus;
  end else
  begin
    //
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\'+USUARIO.Text+'.INF');
      Mais1Ini.WriteString('Senha','Usuário e senha válidos','Sim');
      Mais1Ini.Free;
    except end;
  end;
  //
end;

procedure TForm15.UsuarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Senha.SetFocus;
end;

procedure TForm15.SENHAKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  // Sandro Silva 2021-07-22 if Key = VK_RETURN then Button1.SetFocus;
  if Key = VK_RETURN then
    Button1Click(Sender);
  //
end;

procedure TForm15.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  //
  if (AllTrim(Usuario.Text) <> '') and (Senha.Text<>'#####') then
  begin
    SenhaPub:=Senha.Text;
    UsuarioPub:=Usuario.Text;
    // Grava o o nome do último a usar o programa no .INI
    if UsuarioPub <> 'Administrador' then
    begin
      Mais1ini := TIniFile.Create('MAIS1.INI');
      Mais1Ini.WriteString('Usuarios','Nome',UsuarioPub);
      Mais1Ini.Free;
    end;
    //
    Close;
    //
  end else
  begin
    //
    if Senha.Text <> '#####' then
    begin
      Usuario.SetFocus;
      Abort;
    end;
    //
  end;
  //
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
  //
  if AllTrim(Usuario.Text) = '' then Usuario.Text := '<Usuário>';
  //
  SENHA.Text  := '#####';
  SenhaPub     := SENHA.Text;
  UsuarioPub   := USUARIO.Text;
  //
  Close;
  Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
  {Sandro Silva 2014-06-30 inicio}
  FecharAplicacao(ExtractFileName(Application.ExeName));
  {Sandro Silva 2014-06-30 final}
  //
end;

procedure TForm15.SENHAClick(Sender: TObject);
begin
  Form1.Small_InputBox('Senha do usuário','Informe a senha de '+Usuario.Text+':','');
end;

procedure TForm15.SENHAEnter(Sender: TObject);
var
  I : Integer;
begin
  //
  for I := 1 to 3 do
  begin
{
    Form15.Top  := Form15.Top  +07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left +07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left -07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  -07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  -07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left -07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left +07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  +07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left -07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  +07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  -07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left +07;  Form15.Repaint; sleep(7);
    Form15.Left := Form15.Left +07;  Form15.Repaint; sleep(7);
    Form15.Top  := Form15.Top  -07;  Form15.Repaint; sleep(7);
}

    Form15.Left := Form15.Left +10;  Form15.Repaint; sleep(20);
    Form15.Left := Form15.Left -10;  Form15.Repaint; sleep(20);
    Form15.Left := Form15.Left +08;  Form15.Repaint; sleep(15);
    Form15.Left := Form15.Left -08;  Form15.Repaint; sleep(15);
    Form15.Left := Form15.Left +06;  Form15.Repaint; sleep(10);
    Form15.Left := Form15.Left -06;  Form15.Repaint; sleep(10);
    Form15.Left := Form15.Left +04;  Form15.Repaint; sleep(05);
    Form15.Left := Form15.Left -04;  Form15.Repaint; sleep(05);
    //

    //
  end;
  //
end;

procedure TForm15.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm15.FormShow(Sender: TObject);
begin
  if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') or (Pos('FRENTE.EXE', AnsiUpperCase(ExtractFileName(Application.ExeName))) = 0) then
  begin
    LabelF10Indisponivel.Visible := False;
    {Sandro Silva 2020-12-07 inicio}
    //if PAFNFCe and (Form1.sModeloECF_Reserva <> '99') then // Sandro Silva 2023-06-27 if PAFNFCe then
    if PAFNFCe then
    begin
      LabelF10Indisponivel.Caption := MSG_ALERTA_MENU_FISCAL_INACESSIVEL;
      LabelF10Indisponivel.Visible := True;
    end;
    {Sandro Silva 2020-12-07 fim}
  end;


  {Sandro Silva 2021-07-22 inicio}
  //Button1.Visible := False;
  //Button2.Visible := Button1.Visible;
  Label4.Font.Color := clWhite;
  Label5.Font.Color := Label4.Font.Color;
  LabelF10Indisponivel.Font.Color := Label4.Font.Color;
  Self.Color := Aplicacao.ImgLogo.Canvas.Pixels[1,1];
  Panel1.Color := Self.Color;
  Form15.Left := (Screen.Width - Form15.Width ) div 2; // Sandro Silva 2021-07-30
  Form15.Top  := ((Screen.Height - Form15.Height ) div 2) + 20;// Sandro Silva 2021-07-30
  {Sandro Silva 2021-07-22 fim}
  
end;

procedure TForm15.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Sandro Silva 2021-07-22
  if (Key = VK_ESCAPE) then
    Button2Click(Button2);
end;

end.
