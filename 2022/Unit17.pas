// Cadastro Emitente
unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Mask, SMALL_DBEdit, ExtCtrls, HtmlHelp, ShellApi, Grids,
  DBGrids, SmallFunc, strutils, 
  WinTypes, WinProcs, IniFiles, Buttons, DB, ComCtrls, Clipbrd, OleCtrls, SHDocVw, Registry;

type
  TForm17 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit6: TSMALL_DBEdit;
    SMALL_DBEdit7: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    Label10: TLabel;
    SMALL_DBEdit10: TSMALL_DBEdit;
    Label11: TLabel;
    SMALL_DBEdit11: TSMALL_DBEdit;
    Label14: TLabel;
    SMALL_DBEdit12: TSMALL_DBEdit;
    Label15: TLabel;
    SMALL_DBEdit13: TSMALL_DBEdit;
    Image2: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ComboBox7: TComboBox;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Button2: TBitBtn;
    Button1: TBitBtn;
    DBGrid3: TDBGrid;
    WebBrowser3: TWebBrowser;
    Button4: TBitBtn;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit4Enter(Sender: TObject);
    procedure SMALL_DBEdit6Enter(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure SMALL_DBEdit4Change(Sender: TObject);
    procedure SMALL_DBEdit7Exit(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form17: TForm17;

implementation

uses Unit7, Unit10, Unit14, Unit19, Mais, uListaCnaes;

{$R *.DFM}

procedure TForm17.Button1Click(Sender: TObject);
begin
  try
    dBGrid3.Visible    := False;
    Form7.ibDataSet13.Post;
    //Form1.RegistrodoProgramaonline1Click(Sender); Mauricio Parizotto 2023-05-15
    Form1.RegistrodoPrograma(False);

    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    AgendaCommit(True);
    Commitatudo(True); // SQL - Commando
    AbreArquivos(True);
    Screen.Cursor := crDefault; // Cursor de Aguardo
  except
  end;

  Close;
end;

procedure TForm17.FormActivate(Sender: TObject);
begin
  if Form1.iReduzida = 2 then
  begin
    Form17.CheckBox1.Visible := True;
    Form17.CheckBox1.Checked := True;
  end else
  begin
    Form17.CheckBox1.Visible := False;
  end;

  Form17.Tag := 0;

  Button4.Visible := False;
  Button2.Visible := True;
  Button1.Visible := True;

  try
    if Form7.ibDataSet13.Active then
    begin
      Form7.ibDataSet13.First;
      try
        if Form7.ibDataSet13.Eof then
          Form7.ibDataSet13.Append
        else
          Form7.ibDataSet13.Edit;
      except
      end;

      if Form7.ibDataSet13ESTADO.AsString = '  ' then
        Form7.ibDataSet13ESTADO.AsString := '';

      Form7.bFlag := False;
      Form7.ibDataSet13.Active := True;
      Form7.ibDataSet13.Edit;
      if SMALL_DBEdit7.CanFocus then SMALL_DBEdit7.SetFocus;

      Image2.Picture.Bitmap :=  Form7.Image204.Picture.Bitmap;
    end;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_emitente.htm')));
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;

  if dBgrid3.Visible then
  begin
    if (Key = VK_UP) or (Key = VK_DOWN) then
    begin
      if dBgrid3.CanFocus then
        dBgrid3.SetFocus;
    end;
  end else
  begin
    if Key = VK_UP then
    begin
      Perform(Wm_NextDlgCtl,-1,0);
    end;
    if Key = VK_DOWN then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end;
  end;  
end;

procedure TForm17.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    Form7.ibDataSet13.Cancel;
    Form1.AvisoConfig(True);
  except
  end;

  if Form1.iReduzida = 99 then
  begin
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
end;

procedure TForm17.Button2Click(Sender: TObject);
begin
  dBGrid3.Visible    := False;
  Form14.Button2Click(Sender);
end;

procedure TForm17.Image2Click(Sender: TObject);
begin
  Form7.sModulo := 'EMITENTE';

  Form7.dbGrid1.Datasource     := Form7.DataSource13;
  Form7.ArquivoAberto          := Form7.DataSource13.Dataset;
  Form7.TabelaAberta           := Form7.ibDataSet13;
  Form7.iCampos                := 12;

  Form10.Image203Click(Sender);
end;

procedure TForm17.ComboBox1Change(Sender: TObject);
begin
  Form7.ibDataSet13CRT.AsString := Copy(ComboBox1.Items[ComboBox1.ItemIndex],1,1);
end;

procedure TForm17.ComboBox7Change(Sender: TObject);
begin
  Form7.ibDataSet13CNAE.AsString := Copy(ComboBox7.Items[ComboBox7.ItemIndex],1,7);
end;

procedure TForm17.FormShow(Sender: TObject);
var
  sCertificado : String;
  I : Integer;
  Mais1Ini : tIniFile;
begin
  // Mover as validações envolvendo certifica para evento Form17.onActive
  try
    if Form7.ibDataSet13CGC.AsString = '' then
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
      sCertificado := AllTrim(Mais1ini.ReadString('NFE','Certificado',''));
      Mais1ini.Free;

      if AllTrim(sCertificado) = '' then
      begin
        if Copy(Form1.sSerial,4,1) <> 'M' then
        begin
          Form1.SelecionarCertificadoDigital1Click(Sender);
        end;
      end;
    end;
  except
  end;

  Button1.Left  := Panel2.Width - Button1.Width - 10;
  Button2.Left  := Button1.Left - 140;

  // CRT
  for I := 0 to ComboBox1.Items.Count -1 do
  begin
    if Copy(ComboBox1.Items[I],1,1) = AllTrim(Form7.ibDataSet13CRT.AsString) then
    begin
      ComboBox1.ItemIndex := I;
    end;
  end;

  // CNAE
  for I := 0 to ComboBox7.Items.Count -1 do
  begin
    if Copy(ComboBox7.Items[I],1,7) = AllTrim(Form7.ibDataSet13CNAE.AsString) then
    begin
      ComboBox7.ItemIndex := I;
    end;
  end;

  Commitatudo(True); // SQL - Commando
  AbreArquivos(True);

  Form7.ibDataSet13.Edit;

  if AllTrim(Form7.ibDataSet13CGC.AsString) = '' then
  begin
    if Form1.GetCNPJCertificado(Form7.spdNFe.NomeCertificado.Text) <> '' then
    begin
      if not (Form7.ibDataset13.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset13.Edit;
      Form17.SMALL_DBEdit7.Text := FormataCpfCgc(Form1.GetCNPJCertificado(Form7.spdNFe.NomeCertificado.Text));
      Form7.ibDataSet13CGCSetText(Form7.ibDataset13CGC,Form17.SMALL_DBEdit7.Text);
    end;
  end;
end;

procedure TForm17.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_emitente.htm')));
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm17.SMALL_DBEdit4Enter(Sender: TObject);
begin
  try
    if Length(AllTrim(Form7.IBDataSet13ESTADO.AsString)) <> 2 then
    begin
      Form7.IBDataSet39.Close;
      Form7.IBDataSet39.SelectSQL.Clear;
      Form7.IBDataSet39.SelectSQL.Add('select * from MUNICIPIOS order by NOME'); // Procura em todo o Pais o estado está em branco
      Form7.IBDataSet39.Open;
    end else
    begin
      Form7.IBDataSet39.Close;
      Form7.IBDataSet39.SelectSQL.Clear;
      Form7.IBDataSet39.SelectSQL.Add(' Select * from MUNICIPIOS'+
                                      ' Where UF='+QuotedStr(Form7.IBDataSet13ESTADO.AsString)+
                                      ' Order by NOME'); // Procura dentro do estado
      Form7.IBDataSet39.Open;
    end;

    Form7.ibDataSet39.Locate('NOME',AllTrim(Form7.IBDataSet13MUNICIPIO.AsString),[loCaseInsensitive, loPartialKey]);

    dBGrid3.Height     := 200;
    dBGrid3.DataSource := Form7.DataSource39; // Municipios
    dBGrid3.Visible    := True;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit6Enter(Sender: TObject);
begin
  if dBGrid3.Visible then
  begin
    if (Form7.ibDataset13.State in ([dsEdit, dsInsert])) then
    begin
      if AllTrim(Form7.IBDataSet39NOME.AsString) <> '' then
      begin
        Form7.ibDataSet13MUNICIPIO.AsString := Form7.IBDataSet39NOME.AsString;
      end;  
    end;
    
    dBGrid3.Visible    := False;
  end;
end;

procedure TForm17.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    DBGrid3DblClick(Sender);
  end;
end;

procedure TForm17.DBGrid3DblClick(Sender: TObject);
begin
  try
    Form7.ibDataSet13MUNICIPIO.AsString := Form7.IBDataSet39NOME.AsString;
    if SMALL_DBEdit4.CanFocus then
      SMALL_DBEdit4.SetFocus;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit4Change(Sender: TObject);
begin
  try
    if not dbGrid3.Visible then
    begin
      Form17.SMALL_DBEdit4Enter(Sender);
    end;
  except
  end;

  try
    if Length(AllTrim(Form7.IBDataSet13ESTADO.AsString)) = 2 then
    begin
      Form7.IBDataSet39.Close;
      Form7.IBDataSet39.SelectSQL.Clear;
      Form7.IBDataset39.SelectSQL.Add(' Select * from MUNICIPIOS '+
                                      ' Where Upper(NOME) like '+QuotedStr(AnsiUppercase(SMALL_DBEdit4.Text)+'%')+' '+
                                      '   and UF='+QuotedStr(UpperCase(Form7.ibDataSet13ESTADO.AsString))+
                                      ' Order by NOME');
      Form7.IBDataSet39.Open;
    end else
    begin
      Form7.IBDataSet39.Close;
      Form7.IBDataSet39.SelectSQL.Clear;
      Form7.IBDataset39.SelectSQL.Add(' Select * from MUNICIPIOS'+
                                      ' Where Upper(NOME) like '+QuotedStr(Uppercase(SMALL_DBEdit4.Text)+'%')+' '+
                                      ' Order by NOME');
      Form7.IBDataSet39.Open;
    end;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit7Exit(Sender: TObject);
begin
  Form7.ibDataSet13CGCSetText(Form7.ibDataSet13CGC,LimpaNumero(Form17.SMALL_DBEdit7.Text));
end;

procedure TForm17.Button4Click(Sender: TObject);
begin
  Form17.Tag := 256;
  Button4.Visible := False;
end;

procedure TForm17.CheckBox1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  if not Form17.CheckBox1.Checked then
  begin
    if Application.MessageBox(Pchar(
      'Confirma que esta empresa NÃO é um Microempreendedor Individual (MEI)?'+
      Chr(10) +
      Chr(10) +
      'Continuar? Não é possível voltar esta opção.' +
      Chr(10))
      ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING) = IDYES then
    begin
      Form17.CheckBox1.Visible := False;
      Form1.iReduzida          := 0;
      Mais1ini                 := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      Mais1Ini.WriteString('LICENCA','MEI','NAO');
      Mais1Ini.Free;
    end;
  end;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
  //Mauricio Parizotto 2023-03-23
  ComboBox7.Items.Clear;
  ComboBox7.Items.Text := getListaCnae;
end;

end.





