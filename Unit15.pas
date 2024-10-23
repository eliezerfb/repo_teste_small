unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles, SmallFunc_xe, Buttons,
  Vcl.Imaging.pngimage;

type
  TForm15 = class(TForm)
    pnlPrincipal: TPanel;
    pnlLogin: TPanel;
    imgFundo: TImage;
    imgLogin: TImage;
    lblUsuario: TLabel;
    lblSenha: TLabel;
    imgOculta: TImage;
    imgVer: TImage;
    imgUsuario: TImage;
    imgSenha: TImage;
    imgLogo: TImage;
    Image2: TImage;
    imgEntrar: TImage;
    lblConfNS: TLabel;
    imgEntrarFoco: TImage;
    imgCancelar: TImage;
    lblCancelar: TLabel;
    lblEntrar: TLabel;
    edtSenha: TEdit;
    pnlVisSenha2: TPanel;
    imgVisSenha2: TImage;
    pnlusuario: TPanel;
    UsuarioNew: TComboBox;
    pnlVisSenha1: TPanel;
    imgVisSenha1: TImage;
    pnlVisSenha3: TPanel;
    imgVisSenha3: TImage;
    LabelF10Indisponivel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UsuarioNewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UsuarioNewExit(Sender: TObject);
    procedure edtSenhaClick(Sender: TObject);
    procedure edtSenhaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lblEntrarClick(Sender: TObject);
    procedure lblCancelarClick(Sender: TObject);
    procedure edtSenhaMouseEnter(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imgVisSenha2Click(Sender: TObject);
    procedure imgEntrarMouseEnter(Sender: TObject);
    procedure imgEntrarMouseLeave(Sender: TObject);
    procedure lblCancelarMouseEnter(Sender: TObject);
    procedure lblCancelarMouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FnTentativas: Integer;
    procedure TremeTela;
  public
     SenhaPub: String;
     UsuarioPub: String;

     property Tentativas: Integer read FnTentativas write FnTentativas;
  end;

var
  Form15: TForm15;

implementation

uses Unit22, fiscal, Unit12, ufuncoesfrente, urequisitospafnfce,
  uDialogs, uSmallConsts;

{$R *.dfm}

procedure TForm15.FormCreate(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Self.ClientWidth := Form22.ClientWidth;
  Self.ClientHeight := Form22.ClientHeight;

  Form15.Position := poDesigned; // Sandro Silva 2021-07-30;
  Mais1ini := TIniFile.Create('MAIS1.INI');
  try
    UsuarioNew.Text := Mais1Ini.ReadString('Usuarios','Nome',UsuarioNew.Text);
  finally
    Mais1Ini.Free;
  end;
end;

procedure TForm15.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  I : Integer;
begin
  Form15.edtSenha.SetFocus;

  sSecoes := TStringList.Create;

  Mais1ini := TIniFile.Create('MAIS1.INI');
  UsuarioNew.Text := Mais1Ini.ReadString('Usuarios','Nome',UsuarioNew.Text);

  Mais1Ini.Free;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  Mais1Ini.ReadSections(sSecoes);

  for I := 0 to (sSecoes.Count - 1) do
  begin
    if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
    begin
      if AllTrim(sSecoes[I]) <> _cUsuarioAdmin then
      begin
        if Mais1Ini.ReadString(sSecoes[I],'Chave','') <> '' then
        begin
          UsuarioNew.Items.Add(sSecoes[I]);
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

  if Tentativas > 0 then
    TremeTela;
end;

procedure TForm15.UsuarioNewExit(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if UpperCase(AllTrim(UsuarioNew.Text)) = UpperCase(_cUsuarioAdmin) then
  begin
    MensagemSistema('Usuário inválido.');
    UsuarioNew.SetFocus;
  end else
  begin
    try
      Mais1ini := TIniFile.Create(Form1.sAtual+'\'+UsuarioNew.Text+'.INF');
      try
        Mais1Ini.WriteString('Senha','Usuário e senha válidos','Sim');
      finally
        Mais1Ini.Free;
      end;
    except
    end;
  end;
end;

procedure TForm15.UsuarioNewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    edtSenha.SetFocus;
end;

procedure TForm15.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  //
  if (AllTrim(UsuarioNew.Text) <> EmptyStr) and (edtSenha.Text <> _cSenhaSair) then
  begin
    SenhaPub:=edtSenha.Text;
    UsuarioPub:=UsuarioNew.Text;
    // Grava o o nome do último a usar o programa no .INI
    if UsuarioPub <> _cUsuarioAdmin then
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
    if edtSenha.Text <> _cSenhaSair then
    begin
      UsuarioNew.SetFocus;
      TremeTela;
      Abort;
    end;
    //
  end;
  //
end;

procedure TForm15.TremeTela;
var
  I : Integer;
begin
  if Self.edtSenha.Text <> EmptyStr then
  begin
    for I := 1 to 3 do
    begin
      pnlLogin.Left := pnlLogin.Left +10;  pnlLogin.Repaint; sleep(20);
      pnlLogin.Left := pnlLogin.Left -10;  pnlLogin.Repaint; sleep(20);
      pnlLogin.Left := pnlLogin.Left +08;  pnlLogin.Repaint; sleep(15);
      pnlLogin.Left := pnlLogin.Left -08;  pnlLogin.Repaint; sleep(15);
      pnlLogin.Left := pnlLogin.Left +06;  pnlLogin.Repaint; sleep(10);
      pnlLogin.Left := pnlLogin.Left -06;  pnlLogin.Repaint; sleep(10);
      pnlLogin.Left := pnlLogin.Left +04;  pnlLogin.Repaint; sleep(05);
      pnlLogin.Left := pnlLogin.Left -04;  pnlLogin.Repaint; sleep(05);
    end;
  end;
  Self.edtSenha.Text := EmptyStr;
end;

procedure TForm15.edtSenhaClick(Sender: TObject);
begin
  Form1.Small_InputBox('Senha do usuário','Informe a senha de '+UsuarioNew.Text+':','');
end;

procedure TForm15.edtSenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lblEntrarClick(Sender);
end;

procedure TForm15.edtSenhaMouseEnter(Sender: TObject);
begin
  pnlVisSenha2.Visible := True;
  pnlVisSenha2.Top     := TEdit(Sender).Top + 3;
  pnlVisSenha2.Left    := TEdit(Sender).Left + TEdit(Sender).Width - 20;
end;

procedure TForm15.lblCancelarClick(Sender: TObject);
begin
  if AllTrim(UsuarioNew.Text) = EmptyStr then
    UsuarioNew.Text := '<Usuário>';

  edtSenha.Text := _cSenhaSair;
  SenhaPub      := edtSenha.Text;
  UsuarioPub    := UsuarioNew.Text;

  Close;
  Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
  {Sandro Silva 2014-06-30 inicio}
  FecharAplicacao(ExtractFileName(Application.ExeName));
  {Sandro Silva 2014-06-30 final}
end;

procedure TForm15.lblCancelarMouseEnter(Sender: TObject);
begin
  imgCancelar.Visible := True;
  Self.Repaint;
end;

procedure TForm15.lblCancelarMouseLeave(Sender: TObject);
begin
  imgCancelar.Visible := False;
  Self.Repaint;
end;

procedure TForm15.lblEntrarClick(Sender: TObject);
begin
  Close;
end;

procedure TForm15.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Sandro Silva 2021-07-22
  if (Key = VK_ESCAPE) then
    lblCancelarClick(Self);
end;

procedure TForm15.FormResize(Sender: TObject);
begin
  pnlLogin.Left    := (Self.Width div 2) - (pnlLogin.Width div 2) ;
  pnlLogin.Top     := (Self.Height div 2) - (pnlLogin.Height div 2);
  pnlLogin.Visible := True;
end;

procedure TForm15.FormShow(Sender: TObject);
begin
  Form22.pnlCarregamento.Visible := False;

  if (Form1.sModeloECF_Reserva = '59') or (Form1.sModeloECF_Reserva = '65') or (Form1.sModeloECF_Reserva = '99') or (Pos('FRENTE.EXE', AnsiUpperCase(ExtractFileName(Application.ExeName))) = 0) then
  begin
    LabelF10Indisponivel.Visible := False;
    if PAFNFCe then
    begin
      LabelF10Indisponivel.Caption := MSG_ALERTA_MENU_FISCAL_INACESSIVEL;
      LabelF10Indisponivel.Visible := True;
    end;
  end;
end;

procedure TForm15.imgEntrarMouseEnter(Sender: TObject);
begin
  imgEntrarFoco.Visible := True;
  Self.Repaint;
end;

procedure TForm15.imgEntrarMouseLeave(Sender: TObject);
begin
  imgEntrarFoco.Visible := False;
  Self.Repaint;
end;

procedure TForm15.imgVisSenha2Click(Sender: TObject);
begin
  if edtSenha.PasswordChar = '*' then
  begin
    imgVisSenha2.Picture := imgOculta.Picture;
    imgVisSenha2.Visible := True;
    edtSenha.PasswordChar := #0;
  end else
  begin
    imgVisSenha2.Picture := imgVer.Picture;
    imgVisSenha2.Visible := True;
    edtSenha.PasswordChar := '*';
  end;
end;

end.
