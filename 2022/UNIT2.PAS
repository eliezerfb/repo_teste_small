unit Unit2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls,IniFiles, mais3, shellapi
  , smallfunc_xe,
  Menus;

type
  TForm2 = class(TForm)
    Button2: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Usuario: TComboBox;
    Label3: TLabel;
    CheckBox8: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox16: TCheckBox;
    Label_8: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Label8: TLabel;
    Label_3: TLabel;
    Label_1: TLabel;
    Label_5: TLabel;
    Label_4: TLabel;
    Label_6: TLabel;
    Label_14: TLabel;
    Label_16: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Image10: TImage;
    CheckBox2: TCheckBox;
    Label_2: TLabel;
    Image_: TImage;
    CheckBox7: TCheckBox;
    Label_7: TLabel;
    CheckBox9: TCheckBox;
    Image9: TImage;
    CheckBox10: TCheckBox;
    Label4: TLabel;
    CheckBox11: TCheckBox;
    Panel5: TPanel;
    Panel6: TPanel;
    Label9: TLabel;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox15: TCheckBox;
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
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    Resetdo1: TMenuItem;
    ResetGeral1: TMenuItem;
    Auditoria1: TMenuItem;
    Image1__2: TImage;
    Image1__3: TImage;
    CheckBox37: TCheckBox;
    Label_c: TLabel;
    Label_s: TLabel;
    imgOrcamento: TImage;
    chkOrcamento: TCheckBox;
    lblOrcamento: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure CheckBox16Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Cli(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UsuarioExit(Sender: TObject);
    procedure UsuarioDblClick(Sender: TObject);
    procedure UsuarioKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UsuarioClick(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox8KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure CheckBox13Click(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox17Click(Sender: TObject);
    procedure CheckBox18Click(Sender: TObject);
    procedure CheckBox19Click(Sender: TObject);
    procedure CheckBox20Click(Sender: TObject);
    procedure CheckBox21Click(Sender: TObject);
    procedure CheckBox22Click(Sender: TObject);
    procedure CheckBox23Click(Sender: TObject);
    procedure CheckBox24Click(Sender: TObject);
    procedure CheckBox25Click(Sender: TObject);
    procedure CheckBox26Click(Sender: TObject);
    procedure CheckBox27Click(Sender: TObject);
    procedure CheckBox28Click(Sender: TObject);
    procedure CheckBox29Click(Sender: TObject);
    procedure CheckBox30Click(Sender: TObject);
    procedure CheckBox31Click(Sender: TObject);
    procedure CheckBox32Click(Sender: TObject);
    procedure CheckBox33Click(Sender: TObject);
    procedure CheckBox34Click(Sender: TObject);
    procedure CheckBox35Click(Sender: TObject);
    procedure CheckBox36Click(Sender: TObject);
    procedure Resetdo1Click(Sender: TObject);
    procedure ResetGeral1Click(Sender: TObject);
    procedure Auditoria1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox37Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkOrcamentoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bFlag: Boolean;
  end;

var
  Form2: TForm2;

implementation

uses Mais, Unit10, Unit22, Unit38, Unit7, Unit37, uSistema, uSmallConsts,
  uDialogs;

{$R *.DFM}

procedure TForm2.CheckBox1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

    if CheckBox1.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B3','0');
    if CheckBox1.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B3','1');
    if CheckBox1.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B3','2');

    if CheckBox1.State = cbUnchecked then Label_1.Caption := 'Não liberado';
    if CheckBox1.State = cbChecked then Label_1.Caption := 'Leitura e gravação';
    if CheckBox1.State = cbGrayed then Label_1.Caption := 'Somente leitura';

    if Form2.Tag <> 99 then Form1.FormShow(Sender);
    Mais1Ini.Free;
  end;
end;


procedure TForm2.CheckBox3Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox3.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B2','0');
    if CheckBox3.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B2','1');
    if CheckBox3.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B2','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_3.Caption := 'Não liberado';
      if State = cbChecked then Label_3.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_3.Caption := 'Somente leitura';
    end;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
    Mais1Ini.Free;
  end;
end;

procedure TForm2.CheckBox4Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox4.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B5','0');
    if CheckBox4.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B5','1');
    if CheckBox4.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B5','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_4.Caption := 'Não liberado';
      if State = cbChecked then Label_4.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_4.Caption := 'Somente leitura';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.CheckBox5Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox5.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B4','0');
    if CheckBox5.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B4','1');
    if CheckBox5.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B4','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_5.Caption := 'Não liberado';
      if State = cbChecked then Label_5.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_5.Caption := 'Somente leitura';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;  
end;

procedure TForm2.CheckBox6Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox6.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B6','0');
    if CheckBox6.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B6','1');
    if CheckBox6.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B6','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_6.Caption := 'Não liberado';
      if State = cbChecked then Label_6.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_6.Caption := 'Somente leitura';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;  
end;

procedure TForm2.CheckBox8Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox8.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1','0');
    if CheckBox8.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1','1');

    with Sender as TCheckBox do
    begin
      if State = cbChecked then Label_8.Caption := 'Notas de vendas liberadas';
      if State = cbUnchecked then Label_8.Caption   := 'Notas de vendas bloqueadas';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.CheckBox14Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox14.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B7','0');
    if CheckBox14.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B7','1');
    if CheckBox14.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B7','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_14.Caption := 'Não liberado';
      if State = cbChecked then Label_14.Caption := 'Completo';
      if State = cbGrayed then Label_14.Caption := 'Parcial';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;  
  // Nova senha
end;

procedure TForm2.CheckBox16Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox16.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B8','0');
    if CheckBox16.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B8','1');
    if CheckBox16.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B8','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_16.Caption := 'Não liberado';
      if State = cbChecked then Label_16.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_16.Caption := 'Somente leitura';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Form1.Label207.Tag     := 0;
  Form1.imgConfiguracoes.OnClick          := Form1.imgConfiguracoesClick;
  Form1.Label207.OnClick          := Form1.imgConfiguracoesClick;
  Form1.Label_bola_config.OnClick := Form1.Label_Bola_ConfigClick;

  close;
end;

procedure TForm2.Button1Cli(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.FormActivate(Sender: TObject);
var
  Mais1Ini: TIniFile;
  sSecoes :  TStrings;
  I, J : Integer;
begin
  Form2.bFlag := True;

  if not ((Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Commerce + Ordem de Serviço') or
         (Copy(Form22.sTitulo+Replicate(' ',33),1,33) <> 'Small Mei + Ordem de Serviço'))  then
  begin
    Image_.Visible     := False;
    CheckBox7.Visible  := False;
    Label_7.Visible    := False;

    for I := 1 to Form2.ComponentCount - 1 do
    begin
      if Form2.Components[I].Tag = 1 then
      begin
        Form2.Components[I].Tag := 0;
        if Copy(Form2.Components[I].Name,1,5) = 'Label' then TLabel(Form2.Components[I]).Top    := TLabel(Form2.Components[I]).Top    - 40;
        if Copy(Form2.Components[I].Name,1,5) = 'Image' then TImage(Form2.Components[I]).Top    := TImage(Form2.Components[I]).Top    - 40;
        if Copy(Form2.Components[I].Name,1,5) = 'Check' then TCheckBox(Form2.Components[I]).Top := TCheckBox(Form2.Components[I]).Top - 40;
      end;
    end;

    Panel3.Height := 435 - 40 + 40;
    Panel2.Height := 435 - 40 + 40;
    Form2.Height  := 534 - 40 + 40 + 40;
  end else
  begin
    Image_.Visible     := True;
    CheckBox7.Visible   := True;
    Label_7.Visible    := True;
  end;

  sSecoes := TStringList.Create;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  Mais1Ini.ReadSections(sSecoes);
  Usuario.Items.Clear;

  J := 0;

  for I := 0 to (sSecoes.Count - 1) do
  begin
    if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
    begin
      if AllTrim(sSecoes[I]) <> 'Administrador' then
      begin
        if Mais1Ini.ReadString(sSecoes[I],'Chave','') <> '' then
        begin
          // Se o usuário não usa o sistema a mais de 60 dias sera excluido
          if StrToDate(Copy(Mais1Ini.ReadString(sSecoes[I],'End',DateToStr(Date)+' '+TimeToStr(Time)),1,10)) < (Date-60) then
          begin
            Mais1ini.EraseSection(sSecoes[I]);
          end else
          begin
            if AllTrim(Mais1Ini.ReadString(sSecoes[I],'End','X')) = 'X' then
            begin
              Mais1Ini.WriteString(sSecoes[I],'End',DateToStr(Date-50)+' '+TimeToStr(Time));
            end;

            Usuario.Items.Add(sSecoes[I]);
            if AllTrim(sSecoes[I]) = AllTrim(Senhas.UsuarioPub) then Form2.Usuario.ItemIndex := J;
            J := J + 1;
          end;
        end else
        begin
          Mais1ini.EraseSection(sSecoes[I]);
        end;
      end;
    end;
  end;

  Mais1Ini.Free;
end;

procedure TForm2.UsuarioExit(Sender: TObject);
var
  I : Integer;
  Mais1Ini: TIniFile;
  sSenha, sSenhaX: String;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  Mais1Ini.WriteString(AllTrim(Senhas.UsuarioPub),'Ativo','Não');
  Mais1Ini.UpdateFile;
  Mais1Ini.Free;

  try
    Senhas.UsuarioPub := Usuario.Text;

    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    Mais1Ini.UpdateFile;
    sSenhaX := Mais1Ini.ReadString(Senhas.UsuarioPub,'Chave','15706143431572013809150491382314104');
    sSenha := '';
    // ----------------------------- //
    // Fórmula para ler a nova senha //
    // ----------------------------- //
    for I := 1 to (Length(sSenhaX) div 5) do
      sSenha := Chr((StrToInt(
                    Copy(sSenhaX,(I*5)-4,5)
                    )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
    // ----------------------------- //
    {Mauricio Parizotto 2024-08-12
    Form1.Top := 0;
    Form1.Left := 0;
    }

    Senhas.SenhaPub := sSenha;

    Form2.Repaint;
  except
  end;

  if Form2.Tag <> 99 then
    Form1.FormShow(Sender);

  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  Mais1Ini.WriteString(AllTrim(Senhas.UsuarioPub),'Ativo','Sim');
  Mais1Ini.UpdateFile;
  Mais1Ini.Free;
end;

procedure TForm2.UsuarioDblClick(Sender: TObject);
begin
  Button2.SetFocus;
end;

procedure TForm2.UsuarioKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('liberar_modulos.htm')));
  if Key = VK_RETURN then Button2.SetFocus;
end;

procedure TForm2.UsuarioClick(Sender: TObject);
begin
  Button2.SetFocus;
end;

procedure TForm2.CheckBox2Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox2.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B10','0');
    if CheckBox2.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B10','1');
    if CheckBox2.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B10','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_2.Caption := 'Não liberado';
      if State = cbChecked then Label_2.Caption := 'Leitura e gravação';
      if State = cbGrayed then Label_2.Caption := 'Somente leitura';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;  
end;

procedure TForm2.CheckBox7Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  // Nova Senha
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox7.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B_','0');
    if CheckBox7.State = cbChecked   then Mais1Ini.WriteString(Senhas.UsuarioPub,'B_','1');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label_7.Caption := 'Não liberado';
      if State = cbChecked then Label_7.Caption := 'Leitura e gravação';
    end;
    
    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  {Mauricio Parizotto 2024-07-31
  Image1.Picture      :=  Form1.imgVendas.Picture;
  Image1__2.Picture   :=  Form1.imgCompras.Picture;
  Image1__3.Picture   :=  Form1.imgServicos.Picture;

  Image_.Picture   :=  Form1.imgOrdemServico.Picture;
  Image2.Picture   :=  Form1.imgEstoque.Picture;
  Image3.Picture   :=  Form1.imgCliFor.Picture;
  Image4.Picture   :=  Form1.imgContaReceber.Picture;
  Image5.Picture   :=  Form1.imgCaixa.Picture;
  Image6.Picture   :=  Form1.imgBancos.Picture;
  Image7.Picture   :=  Form1.imgConfiguracoes.Picture;
  Image9.Picture   :=  Form1.imgIndicadores.Picture;
  Image8.Picture   :=  Form1.imgBackup.Picture;
  Image10.Picture  :=  Form1.imgContaPagar.Picture;
  }
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('liberar_modulos.htm')));
end;

procedure TForm2.CheckBox9Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox9.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1_E','0');
    if CheckBox9.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1_E','1');

    with Sender as TCheckBox do
    begin
      if State = cbChecked then Label_C.Caption     := 'Notas de compras liberadas';
      if State = cbUnchecked then Label_C.Caption   := 'Notas de compras bloqueadas';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.chkOrcamentoClick(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if (TSistema.GetInstance.Tema <> _TemaModerno)
    and (chkOrcamento.State <> cbUnchecked) then
  begin
    MensagemSistema('Esse módulo está disponível apenas para o tema Moderno do sistema.',msgAtencao);
    chkOrcamento.State := cbUnchecked;
    Exit;
  end;

  if (TSistema.GetInstance.Tema <> _TemaModerno) then
    Exit;

  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if chkOrcamento.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'BOR','0');
    if chkOrcamento.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'BOR','1');
    if chkOrcamento.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'BOR','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then lblOrcamento.Caption := 'Não liberado';
      if State = cbChecked then lblOrcamento.Caption := 'Liberado';
      if State = cbGrayed then lblOrcamento.Caption := 'Liberado';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;

procedure TForm2.CheckBox10Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox10.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B11','0');
    if CheckBox10.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B11','1');
    if CheckBox10.State = cbGrayed then Mais1Ini.WriteString(Senhas.UsuarioPub,'B11','2');

    with Sender as TCheckBox do
    begin
      if State = cbUnchecked then Label4.Caption := 'Não liberado';
      if State = cbChecked then Label4.Caption := 'Liberado';
      if State = cbGrayed then Label4.Caption := 'Liberado';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then Form1.FormShow(Sender);
  end;
end;


procedure TForm2.CheckBox8KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('liberar_modulos.htm')));
end;

procedure TForm2.FormShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Form2.bFlag := True;
  Form2.Tag := 99;

  if AllTrim(Senhas.UsuarioPub) <> '' then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B_','9')) of
      0 : CheckBox7.State := cbUnchecked;
      1 : CheckBox7.State := cbChecked;
      2 : CheckBox7.State := cbGrayed;
      9 : begin
            CheckBox7.State := cbUnchecked;
            CheckBox7.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B1','9')) of
      0 : CheckBox8.State := cbUnchecked;
      1 : CheckBox8.State := cbChecked;
      2 : CheckBox8.State := cbGrayed;
      9 : begin
            CheckBox8.State := cbUnchecked;
            CheckBox8.State := cbChecked;
          end;

    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B1_E','9')) of
      0 : CheckBox9.State := cbUnchecked;
      1 : CheckBox9.State := cbChecked;
      2 : CheckBox9.State := cbGrayed;
      9 : begin
            CheckBox9.State := cbUnchecked;
            CheckBox9.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B1_S','9')) of
      0 : CheckBox37.State := cbUnchecked;
      1 : CheckBox37.State := cbChecked;
      2 : CheckBox37.State := cbGrayed;
      9 : begin
            CheckBox37.State := cbUnchecked;
            CheckBox37.State := cbChecked;
          end;
    end;


    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B2','9')) of
      0 : CheckBox3.State := cbUnchecked;
      1 : CheckBox3.State := cbChecked;
      2 : CheckBox3.State := cbGrayed;
      9 : begin
            CheckBox3.State := cbUnchecked;
            CheckBox3.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B3','9')) of
      0 : CheckBox1.State := cbUnchecked;
      1 : CheckBox1.State := cbChecked;
      2 : CheckBox1.State := cbGrayed;
      9 : begin
            CheckBox1.State := cbUnchecked;
            CheckBox1.State := cbChecked;
          end;
    end;

    //Orçamento
    if (TSistema.GetInstance.Tema = _TemaModerno) then
    begin
      case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'BOR',   Mais1Ini.ReadString(Senhas.UsuarioPub,'B2','9')     )) of
        0 : chkOrcamento.State := cbUnchecked;
        1 : chkOrcamento.State := cbChecked;
        2 : chkOrcamento.State := cbGrayed;
        9 : begin
              chkOrcamento.State := cbUnchecked;
              chkOrcamento.State := cbChecked;
            end;
      end;
    end else
    begin
      chkOrcamento.State := cbUnchecked;
    end;


    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B4','9')) of
      0 : CheckBox5.State := cbUnchecked;
      1 : CheckBox5.State := cbChecked;
      2 : CheckBox5.State := cbGrayed;
      9 : begin
            CheckBox5.State := cbUnchecked;
            CheckBox5.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B5','9')) of
      0 : CheckBox4.State := cbUnchecked;
      1 : CheckBox4.State := cbChecked;
      2 : CheckBox4.State := cbGrayed;
      9 : begin
            CheckBox4.State := cbUnchecked;
            CheckBox4.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B6','9')) of
      0 : CheckBox6.State := cbUnchecked;
      1 : CheckBox6.State := cbChecked;
      2 : CheckBox6.State := cbGrayed;
      9 : begin
            CheckBox6.State := cbUnchecked;
            CheckBox6.State := cbChecked;
          end;
    end;


    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B7','9')) of
      0 : CheckBox14.State := cbUnchecked;
      1 : CheckBox14.State := cbChecked;
      2 : CheckBox14.State := cbGrayed;
      9 : begin
            CheckBox14.State := cbUnchecked;
            CheckBox14.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B8','9')) of
      0 : CheckBox16.State := cbUnchecked;
      1 : CheckBox16.State := cbChecked;
      2 : CheckBox16.State := cbGrayed;
      9 : begin
            CheckBox16.State := cbUnchecked;
            CheckBox16.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B10','9')) of
      0 : CheckBox2.State := cbUnchecked;
      1 : CheckBox2.State := cbChecked;
      2 : CheckBox2.State := cbGrayed;
      9 : begin
            CheckBox2.State := cbUnchecked;
            CheckBox2.State := cbChecked;
          end;
    end;

    case StrToInt(Mais1Ini.ReadString(Senhas.UsuarioPub,'B11','9')) of
      0 : CheckBox10.State := cbUnchecked;
      1 : CheckBox10.State := cbChecked;
      2 : CheckBox10.State := cbGrayed;
      9 : begin
            CheckBox10.State := cbUnchecked;
            CheckBox10.State := cbChecked;
          end;
    end;

    // Indicadores
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I01','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I01','9') = '9') then CheckBox11.State := cbChecked else CheckBox11.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I02','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I02','9') = '9') then CheckBox12.State := cbChecked else CheckBox12.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I03','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I03','9') = '9') then CheckBox13.State := cbChecked else CheckBox13.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I04','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I04','9') = '9') then CheckBox15.State := cbChecked else CheckBox15.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I05','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I05','9') = '9') then CheckBox17.State := cbChecked else CheckBox17.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I06','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I06','9') = '9') then CheckBox18.State := cbChecked else CheckBox18.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I07','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I07','9') = '9') then CheckBox19.State := cbChecked else CheckBox19.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I08','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I08','9') = '9') then CheckBox20.State := cbChecked else CheckBox20.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I09','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I09','9') = '9') then CheckBox21.State := cbChecked else CheckBox21.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I10','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I10','9') = '9') then CheckBox22.State := cbChecked else CheckBox22.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I11','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I11','9') = '9') then CheckBox23.State := cbChecked else CheckBox23.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I12','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I12','9') = '9') then CheckBox24.State := cbChecked else CheckBox24.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I13','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I13','9') = '9') then CheckBox25.State := cbChecked else CheckBox25.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I14','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I14','9') = '9') then CheckBox26.State := cbChecked else CheckBox26.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I15','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I15','9') = '9') then CheckBox27.State := cbChecked else CheckBox27.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I16','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I16','9') = '9') then CheckBox28.State := cbChecked else CheckBox28.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I17','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I17','9') = '9') then CheckBox29.State := cbChecked else CheckBox29.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I18','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I18','9') = '9') then CheckBox30.State := cbChecked else CheckBox30.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I19','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I19','9') = '9') then CheckBox31.State := cbChecked else CheckBox31.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I20','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I20','9') = '9') then CheckBox32.State := cbChecked else CheckBox32.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I21','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I21','9') = '9') then CheckBox33.State := cbChecked else CheckBox33.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I22','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I22','9') = '9') then CheckBox34.State := cbChecked else CheckBox34.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I23','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I23','9') = '9') then CheckBox35.State := cbChecked else CheckBox35.State := cbUnchecked;
    if (Mais1Ini.ReadString(Senhas.UsuarioPub,'I24','9') = '1') or (Mais1Ini.ReadString(Senhas.UsuarioPub,'I24','9') = '9') then CheckBox36.State := cbChecked else CheckBox36.State := cbUnchecked;

    Mais1Ini.Free;
    Button2.SetFocus;
  end;

  Form2.bFlag := True;
  Form2.Tag := 0;
  Form1.FormShow(Sender);

  //Mauricio Parizotto 2024-07-31
  Image1.Picture       :=  Form1.imgVendas.Picture;
  Image1__2.Picture    :=  Form1.imgCompras.Picture;
  Image1__3.Picture    :=  Form1.imgServicos.Picture;

  Image_.Picture       :=  Form1.imgOrdemServico.Picture;
  Image2.Picture       :=  Form1.imgEstoque.Picture;
  Image3.Picture       :=  Form1.imgCliFor.Picture;
  Image4.Picture       :=  Form1.imgContaReceber.Picture;
  Image5.Picture       :=  Form1.imgCaixa.Picture;
  Image6.Picture       :=  Form1.imgBancos.Picture;
  Image7.Picture       :=  Form1.imgConfiguracoes.Picture;
  Image9.Picture       :=  Form1.imgIndicadores.Picture;
  Image8.Picture       :=  Form1.imgBackup.Picture;
  Image10.Picture      :=  Form1.imgContaPagar.Picture;

  if TSistema.GetInstance.Tema <> _TemaModerno then
    imgOrcamento.Picture := Form1.imgOrdemServico.Picture
  else
    imgOrcamento.Picture := Form1.imgOrcamento.Picture;
end;

procedure TForm2.CheckBox11Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox11.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I01','0');
  if CheckBox11.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I01','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox12Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox12.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I02','0');
  if CheckBox12.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I02','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox13Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox13.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I03','0');
  if CheckBox13.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I03','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox15Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox15.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I04','0');
  if CheckBox15.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I04','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox17Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox17.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I05','0');
  if CheckBox17.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I05','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox18Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox18.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I06','0');
  if CheckBox18.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I06','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox19Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox19.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I07','0');
  if CheckBox19.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I07','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox20Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox20.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I08','0');
  if CheckBox20.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I08','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox21Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox21.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I09','0');
  if CheckBox21.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I09','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox22Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox22.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I10','0');
  if CheckBox22.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I10','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox23Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox23.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I11','0');
  if CheckBox23.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I11','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox24Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox24.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I12','0');
  if CheckBox24.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I12','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox25Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox25.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I13','0');
  if CheckBox25.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I13','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox26Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox26.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I14','0');
  if CheckBox26.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I14','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox27Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox27.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I15','0');
  if CheckBox27.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I15','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox28Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox28.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I16','0');
  if CheckBox28.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I16','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox29Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox29.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I17','0');
  if CheckBox29.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I17','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox30Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox30.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I18','0');
  if CheckBox30.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I18','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox31Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox31.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I19','0');
  if CheckBox31.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I19','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox32Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox32.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I20','0');
  if CheckBox32.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I20','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox33Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox33.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I21','0');
  if CheckBox33.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I21','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox34Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox34.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I22','0');
  if CheckBox34.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I22','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox35Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox35.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I23','0');
  if CheckBox35.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I23','1');
  Mais1Ini.Free;
end;

procedure TForm2.CheckBox36Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  if CheckBox36.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I24','0');
  if CheckBox36.State = cbChecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'I24','1');
  Mais1Ini.Free;
end;

procedure TForm2.Resetdo1Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
  bButton : Integer;
begin
  bButton := Application.MessageBox(Pchar('Este usuário vai ser eliminado e não vai mais ter acesso ao'+Chr(10)+
                                          'sistema.'+
             Chr(10) +
             Chr(10) +
             'Continuar?' +
             Chr(10))
             ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
  if bButton = IDYES then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    Mais1ini.EraseSection(Senhas.UsuarioPub);
    close;
  end;
end;

procedure TForm2.ResetGeral1Click(Sender: TObject);
var
  bButton : Integer;
begin
  bButton := Application.MessageBox(Pchar('O reset geral vai eliminar todos os usuários, os usuários devem'+Chr(10)+
                                          'ser recadastrados e as senhas redigitadas inclusive a do Administrador.'+Chr(10)+
                                          'Se o sistema estiver liberado para mais de 2 usuários as licenças'+Chr(10)+
                                          'de uso adicionais devem ser recadastradas.'+
             Chr(10)+
             Chr(10)+
             'Continuar?'+
             Chr(10))
             ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
  if bButton = IDYES then
  begin
    DeleteFile(pChar(Form1.sAtual+'\EST0QUE.DAT'));
    close;
    Form1.Close;
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE ); Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;
end;

procedure TForm2.Auditoria1Click(Sender: TObject);
begin
  Form38.Label25.Visible    := True;
  Form38.ComboBox1.Visible  := True;
  Form38.Label2.Visible     := True;
  Form38.Label3.Visible     := True;
  Form38.DateTimePicker1.Visible := True;
  Form38.DateTimePicker2.Visible := True;
  Form7.sModulo := 'Auditoria';
  Form38.Show;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  Form2.PopupMenu1.Popup(Form2.Left+Form2.Button1.Left+5,Form2.Top+Form2.Button1.Top+Form2.Button1.Height+30);
end;

procedure TForm2.CheckBox37Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  if Form2.bFlag then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
    if CheckBox37.State = cbUnchecked then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1_S','0');
    if CheckBox37.State = cbChecked   then Mais1Ini.WriteString(Senhas.UsuarioPub,'B1_S','1');

    with Sender as TCheckBox do
    begin
      if State = cbChecked then Label_S.Caption := 'Notas de serviços liberadas';
      if State = cbUnchecked then Label_S.Caption   := 'Notas de serviços bloqueadas';
    end;

    Mais1Ini.Free;
    if Form2.Tag <> 99 then
      Form1.FormShow(Sender);
  end;
end;

end.

