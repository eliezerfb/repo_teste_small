unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  StrUtils
  , SmallFunc
  , uajustaresolucao
  ;

//const PAGAMENTO_EM_CARTAO = 'Pagamento em Cartão';

type
  TForm12 = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

uses Unit2, fiscal, Unit15, ufuncoesfrente;

{$R *.dfm}

procedure TForm12.Button1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSenha  : String;
  sSenhaX : String;
  I : Integer;
  sAtual : String;
begin
  //
  if (Copy(Form12.Label1.Caption, 1, 5) = 'Senha') // PAF-NFC-e tem mensagem de menu fiscal indisponível Sandro Silva 2020-12-09
    and (AnsiContainsText(Form12.Label1.Caption, 'Senha do usuário') = False) // Não é senha de usuário
   then
  begin
    //
    Getdir(0,sAtual);
    Mais1ini := TIniFile.Create(sAtual+'\EST0QUE.DAT');
    sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
    Mais1Ini.Free; // Sandro Silva 2018-11-21 Memória
    sSenha := '';
    // ----------------------------- //
    // Fórmula para ler a nova senha //
    // ----------------------------- //
    for I := 1 to (Length(sSenhaX) div 5) do
      sSenha := Chr((StrToInt(
                    Copy(sSenhaX,(I*5)-4,5)
                    )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
    // ----------------------------- //
    if AnsiUpperCase(sSenha) = AnsiUpperCase(Edit1.Text) then
    begin
      Form12.Caption := 'Liberado';
    end else
    begin
      Form12.Caption := '';
      SmallMsg('Senha do Administrador inválida.');
    end;
    //
    Edit1.Text    := '';
    //
  end;
  //
  if Form12.Label1.Caption = 'Senha do usuário' then
  begin
    //
    Form15.Senha.Text := Edit1.Text;
    //
  end;


  //Ficha depuraçaõ 3026
  if Form12.Label2.Caption = INFORME_CPF_OU_CNPJ then
  begin
    if Trim(Edit1.Text) <> '' then
    begin
      if (CpfCgc(LimpaNumero(Edit1.Text)) = False)
      or ((Length(LimpaNumero(Edit1.Text)) <> 11) and (Length(LimpaNumero(Edit1.Text)) <> 14)) then
      begin
        SmallMsg('CPF ou CNPJ inválido!');
        Edit1.SetFocus;
        Exit;
      end;
    end;
  end;

  //
  Close;
  //
end;

procedure TForm12.Image6Click(Sender: TObject);
begin
  Form12.Button1Click(Sender);
end;

procedure TForm12.FormActivate(Sender: TObject);
begin
  //
  //
  Form12.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Form12.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
  //
  Form12.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  Form12.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;
  //
  Form12.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  Form12.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;
  //
  Edit1.Visible := True;
  ActiveControl := Edit1; // Sandro Silva 2018-10-24
  if Pos('Alerta', Label1.Caption) > 0 then
  begin
    ActiveControl := BitBtn1; // Sandro Silva 2018-10-24 nil;
    Edit1.Visible := False;
  end;
  if Edit1.CanFocus then
  begin
    Edit1.SetFocus;
  end;
  //
end;

procedure TForm12.Edit1KeyDown(Sender: TObject; var Key: Word;
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

procedure TForm12.FormCreate(Sender: TObject);
begin
  // Artifício para o botão OK nunca ficar com foco quando o form for aberto. Evitar confirmação OK quando ler código de barras Sandro Silva 2018-10-24
  BitBtn1.Top := -10000;

  Form12.Top    := Form1.Panel1.Top;
  Form12.Left   := Form1.Panel1.Left;
  Form12.Height := Form1.Panel1.Height;
  Form12.Width  := Form1.Panel1.Width;

  AjustaResolucao(Form12);
  AjustaResolucao(Form12.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18
end;

procedure TForm12.FormShow(Sender: TObject);
begin
  if (Form12.Label1.Caption = PAGAMENTO_EM_CARTAO) or (Form12.Label1.Caption = PARCELAS_EM_CARTAO) then
  begin
    if Edit1.CanFocus then // Sandro Silva 2020-10-16
    begin
      Edit1.SetFocus;
      Edit1.SelectAll;
    end;
  end;

  {Sandro Silva 2021-07-30 inicio}
  Label3.Visible := False;
  Label3.Caption := '';
  //if PAFNFCe and (Form1.sModeloECF_Reserva <> '99') then // Sandro Silva 2023-06-27 if PAFNFCe then
  if PAFNFCe then
  begin
    Label3.Visible := True;
    Label3.Caption := MSG_ALERTA_MENU_FISCAL_INACESSIVEL;
  end;
  {Sandro Silva 2021-07-30 fim}

end;

procedure TForm12.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {Sandro Silva 2018-03-19 inicio}
  if Key = VK_ESCAPE then
  begin
    // Sandro Silva 2023-06-23 if (Pos('Alerta', Form12.Label1.Caption) > 0) and (AnsiContainsText(Form12.Label2.Caption, 'Não é possível efetuar a venda') or AnsiContainsText(Form12.Label2.Caption, 'Não foi possível importar')) then // Usar na venda direta e importações
    if (Pos('Alerta', Form12.Label1.Caption) > 0) and (AnsiContainsText(Form12.Label2.Caption, 'Não é possível efetuar a venda') or AnsiContainsText(Form12.Label2.Caption, 'Não é possível efetuar a movimenta') or AnsiContainsText(Form12.Label2.Caption, 'Não foi possível importar')) then // Usar na venda direta e importações
    begin
      Button1Click(Sender);
    end;
  end;
  {Sandro Silva 2018-03-19 fim}
end;

end.
