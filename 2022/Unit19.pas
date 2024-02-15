unit Unit19;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, IniFiles, ComCtrls, Shellapi, DBCtrls, SMALL_DBEdit, smallfunc_xe,
  ExtCtrls
  ;

type
  TForm19 = class(TForm)
    ColorDialog1: TColorDialog;
    OpenDialog4: TOpenDialog;
    OpenDialog3: TOpenDialog;
    Orelhas: TPageControl;
    Orelha_relatorios: TTabSheet;
    Orelha_permitir: TTabSheet;
    Orelha_juros: TTabSheet;
    Orelha_prazo: TTabSheet;
    Orelha_ajustes: TTabSheet;
    Orelha_IR: TTabSheet;
    Orelha_atendimento: TTabSheet;
    Orelha_perfil: TTabSheet;
    GroupBox3: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Image1: TImage;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    chkItensDuplicadosNF: TCheckBox;
    chkEstoqueNegativoNF: TCheckBox;
    chkVendasAbaixoCusto: TCheckBox;
    GroupBox1: TGroupBox;
    rbJurosSimples: TRadioButton;
    rbJurosComposto: TRadioButton;
    GroupBox2: TGroupBox;
    Label18: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label4: TLabel;
    MaskEdit4: TMaskEdit;
    Label7: TLabel;
    MaskEdit2: TMaskEdit;
    Label20: TLabel;
    Label5: TLabel;
    MaskEdit5: TMaskEdit;
    Label8: TLabel;
    MaskEdit3: TMaskEdit;
    Label21: TLabel;
    Label6: TLabel;
    MaskEdit6: TMaskEdit;
    Label9: TLabel;
    MaskEdit7: TMaskEdit;
    Label22: TLabel;
    ComboBox4: TComboBox;
    Label23: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox7: TComboBox;
    Label30: TLabel;
    Label13: TLabel;
    ComboBox5: TComboBox;
    ComboBox8: TComboBox;
    Label31: TLabel;
    Label33: TLabel;
    ComboBox10: TComboBox;
    ComboBox9: TComboBox;
    Label32: TLabel;
    Label28: TLabel;
    ComboBox6: TComboBox;
    Label12: TLabel;
    ComboBox2: TComboBox;
    Label14: TLabel;
    ComboBox3: TComboBox;
    Label11: TLabel;
    MaskEdit1: TMaskEdit;
    Label16: TLabel;
    MaskEdit8: TMaskEdit;
    Image7: TImage;
    Image9: TImage;
    CheckBox11: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox8: TCheckBox;
    Panel2: TPanel;
    Button2: TButton;
    Panel4: TPanel;
    Button6: TButton;
    Panel3: TPanel;
    btnCancelar: TButton;
    btnOK: TButton;
    Panel5: TPanel;
    Orelha_email: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label10: TLabel;
    Edit3: TEdit;
    Label24: TLabel;
    Edit4: TEdit;
    Label25: TLabel;
    Edit5: TEdit;
    Label15: TLabel;
    Edit6: TEdit;
    CheckBox3: TCheckBox;
    Orelha_matricial: TTabSheet;
    Label26: TLabel;
    ComboBoxNF: TComboBox;
    Label29: TLabel;
    ComboBoxNF2: TComboBox;
    ComboBoxImpressora: TComboBox;
    Label27: TLabel;
    ComboBoxBloqueto: TComboBox;
    ComboBox11: TComboBox;
    Label34: TLabel;
    Label35: TLabel;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    Label36: TLabel;
    Label37: TLabel;
    ComboBoxORCA: TComboBox;
    GroupBox4: TGroupBox;
    rbMultaPercentual: TRadioButton;
    rbMultaValor: TRadioButton;
    edtVlMulta: TEdit;
    edtJurosDia: TEdit;
    edtJurosMes: TEdit;
    edtJurosAno: TEdit;
    lblMulta: TLabel;
    chkFabricaProdSemQtd: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit2Exit(Sender: TObject);
    procedure MaskEdit3Exit(Sender: TObject);
    procedure MaskEdit7Exit(Sender: TObject);
    procedure MaskEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure MaskEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MaskEdit4Exit(Sender: TObject);
    procedure MaskEdit5Exit(Sender: TObject);
    procedure MaskEdit6Exit(Sender: TObject);
    procedure Edit7Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ComboBox5Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbJurosSimplesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbJurosCompostoClick(Sender: TObject);
    procedure rbJurosSimplesClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Edit7Enter(Sender: TObject);
    procedure Edit8Enter(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure JurosEnter(Sender: TObject);
    procedure ComboBox8Exit(Sender: TObject);
    procedure ComboBox9Exit(Sender: TObject);
    procedure ComboBox10Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox11Exit(Sender: TObject);
    procedure edtJurosDiaKeyPress(Sender: TObject; var Key: Char);
    procedure edtJurosDiaExit(Sender: TObject);
    procedure edtJurosMesExit(Sender: TObject);
    procedure edtJurosAnoExit(Sender: TObject);
    procedure edtVlMultaExit(Sender: TObject);
    procedure rbMultaPercentualClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetTipoMulta;
    procedure DefineLayoutAbaImpressao;    
  public
    { Public declarations }
    bChave : Boolean;
  end;

var
  Form19: TForm19;

implementation

uses Mais, Unit7, Unit14, Unit22, Unit12, Unit10, Unit2, Unit4,
  Unit24, Unit8, uDialogs, uArquivosDAT;

{$R *.DFM}

procedure GetTheListOfPrinters;
var
  p : pChar;
  p2 : pChar;
  i : integer;
  sDriver : string;
  sPort : string;
begin
  GetMem(p, 32767);
  p2 := p;
  // pega uma lista de nomes de impressoras do arquivo win.ini file
  // a lista e passada para strings separadas por um caracter nulo
  //com o final da string terminada em 2 nulos
  if GetProfileString('devices', nil, '',p, 32767) <> 0 then
  begin
    //
    while p2^ <> #0 do begin
     Form19.ComboBoxImpressora.Items.Add(StrPas(p2));
     // incrementa o poteiro para pegar a proxima string
     p2 := @p2[lStrLen(p2) + 1];
    end;
  end;
  //
  GetMem(p2, 32767);
  
  //pega o driver e a porta da impressora encontrada
  for i := 0 to (Form19.ComboBoxImpressora.Items.Count - 1) do
  begin
    StrPCopy(p2, Form19.ComboBoxImpressora.Items[i]);
    if GetProfileString('devices', p2, '',p, 32767) <> 0 then
    begin
      sDriver := StrPas(p);
      sPort := sDriver;
      Delete(sDriver, Pos(',', sDriver), Length(sDriver));
      Delete(sPort, 1, Pos(',', sPort));
      if Copy(Form19.ComboBoxImpressora.Items[i],1,2) ='\\' then
      begin
        Form19.ComboBoxNF.Items.Add(Form19.ComboBoxImpressora.Items[i]);
        Form19.ComboBoxNF2.Items.Add(Form19.ComboBoxImpressora.Items[i]);
        Form19.ComboBoxBloqueto.Items.Add(Form19.ComboBoxImpressora.Items[i]);
      end else
      begin
        Form19.comboBoxNF.Items.Add(sPort);
        Form19.comboBoxNF2.Items.Add(sPort);
        Form19.comboBoxBloqueto.Items.Add(sPort);
      end;
    end;
  end;
  FreeMem(p2,32767);
  FreeMem(p, 32767);
end;

{Dailon Parisotto 2023-10-13 Inicio}
procedure TForm19.DefineLayoutAbaImpressao;
var
  cEstado: String;
  bMostra: Boolean;
begin
  cEstado := Form7.ibDataSet13ESTADO.AsString;

  bMostra := ((cEstado <> 'SC') and (cEstado <> 'MG'));
  //Campos
  ComboBoxBloqueto.Visible := bMostra;
  ComboBoxNF.Visible       := bMostra;
  ComboBoxNF2.Visible      := bMostra;
  //Labels
  Label27.Visible := bMostra;
  Label26.Visible := bMostra;
  Label29.Visible := bMostra;
end;
{Dailon Parisotto 2023-10-13 Fim}


procedure TForm19.FormActivate(Sender: TObject);
var
  Mais1Ini, Mais2Ini, Mais3Ini, Mais4ini: TIniFile;

  ConfSistema : TArquivosDAT;
begin
  {Dailon Parisotto 2023-10-13 Inicio
  if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) or (Form1.iReduzida = 2)  then
  begin
    Form19.Orelha_matricial.TabVisible          := True;
  end else
  begin
    Form19.Orelha_matricial.TabVisible          := False;
  end;
  }
  DefineLayoutAbaImpressao;
  {Dailon Parisotto 2023-10-13 Fim}
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');

  if AllTrim(Mais1Ini.ReadString(Usuario,'B7','0')) <> '1' then
  begin
    Form19.Orelha_prazo.TabVisible       := False;
    Form19.Orelha_Ajustes.TabVisible     := False;
    Form19.Orelha_IR.TabVisible          := False;
    Form19.Orelha_Relatorios.TabVisible  := True;
    Form19.Orelha_email.TabVisible       := False;
    Form19.Orelha_Permitir.TabVisible    := False;
    Form19.Orelha_Juros.TabVisible       := False;
    Form19.Orelha_Atendimento.TabVisible := False;
    Form19.Orelha_Perfil.TabVisible      := False;
  end else
  begin
    Form19.Orelha_prazo.TabVisible       := True;
    Form19.Orelha_Ajustes.TabVisible     := True;
    Form19.Orelha_IR.TabVisible          := True;
    Form19.Orelha_Relatorios.TabVisible  := True;
    Form19.Orelha_Email.TabVisible       := True;
    Form19.Orelha_Permitir.TabVisible    := True;
    Form19.Orelha_Juros.TabVisible       := True;
    Form19.Orelha_Atendimento.TabVisible := True;
    Form19.Orelha_Perfil.TabVisible      := False;
  end;

  Mais1Ini.Free;

  Mais2ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais3ini := TIniFile.Create('retaguarda.ini');

  RadioButton3.Checked := False;
  RadioButton4.Checked := False;
  RadioButton5.Checked := False;

  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '1' then RadioButton3.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '2' then RadioButton4.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '3' then RadioButton5.Checked := True;

  try
    ColorDialog1.Color := StrToInt('$'+Mais2Ini.ReadString('Html','Cor','EBEBEB'));
    Edit7.Color := StrToInt('$'+AllTrim(Format('%18.0x',[ColorDialog1.Color])));
    Edit8.Color := StrToInt('$'+AllTrim(Format('%18.0x',[ColorDialog1.Color])));
  except end;

  if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
    Image1.Picture.LoadFromFile('LOGOTIP.BMP') else Form19.Image1.Picture := Form1.Image1.Picture;

  Image1.Width  := Image1.Picture.Width div 2;
  Image1.Height := Image1.Picture.Height div 2;

  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  Mais2ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  { -- Mais1Ini.WriteString(Mais.sEscolhido,'L'+alltrim(IntToStr(I)), -- }
  ComboBox5.Text   := Mais1Ini.ReadString('Nota Fiscal','Itens','16');
  ComboBox11.Text  := Mais1Ini.ReadString('Nota Fiscal','Serie','');
  ComboBox10.Text  := Mais1Ini.ReadString('OS','Itens','16');
  ComboBox8.Text  := Mais1Ini.ReadString('Nota Fiscal','Svc','5');
  ComboBox9.Text  := Mais1Ini.ReadString('OS','Svc','5');
  MaskEdit4.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo1','7');
  MaskEdit5.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','14');
  MaskEdit6.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo3','21');

  MaskEdit2.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo1','0,00');
  MaskEdit3.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo2','0,00');
  MaskEdit7.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo3','0,00');

  MaskEdit1.Text  := Mais1Ini.ReadString('Atendimento','Inicial','08:00:00');
  MaskEdit8.Text  := Mais1Ini.ReadString('Atendimento','Final','18:00:00');

  ComboBoxNF.Text        := Mais3Ini.ReadString('Nota Fiscal','Porta','LPT1');
  ComboBoxNF2.Text        := Mais3Ini.ReadString('Nota Fiscal 2','Porta','LPT1');
  ComboBoxBloqueto.Text    := Mais3Ini.ReadString('Bloqueto','Porta','LPT1');

  if Mais1Ini.ReadString('Permitir','Vendas abaixo do custo','Sim') = 'Não' then chkVendasAbaixoCusto.Checked  := False else chkVendasAbaixoCusto.Checked := True;
  if Mais1Ini.ReadString('Permitir','Estoque negativo','Sim')       = 'Não' then chkEstoqueNegativoNF.Checked  := False else chkEstoqueNegativoNF.Checked := True;
  if Mais1Ini.ReadString('Permitir','Duplos','Não')                 = 'Não' then chkItensDuplicadosNF.Checked  := False else chkItensDuplicadosNF.Checked := True;

  //Mauricio Parizotto 2024-02-02
  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
    chkFabricaProdSemQtd.Checked  := ConfSistema.BD.Outras.FabricaProdutoSemQtd;
  finally
    FreeAndNil(ConfSistema);
  end;

  ComboBox1.Text        := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
  ComboBox7.Text        := Mais1Ini.ReadString('Outros','Casas decimais na quantidade de serviços','0');
  ComboBox4.Text        := Mais1Ini.ReadString('Outros','Casas decimais no preço','2');
  ComboBox6.Text        := Mais3Ini.ReadString('Recibo','Vias','1');
  ComboBox2.Text        := Mais1Ini.ReadString('Outros','Teto limite para tributação de IR sobre serviços','R$ 100.000,00');
  ComboBox3.Text        := Mais1Ini.ReadString('Outros','Aliquota de IR','1,50 %');

  Form7.ibDataSet25.Open;

  {Mauricio Parizotto 2023-10-02 Inicio}
  if Form7.ibDataSet25.Active then
  begin
    Form7.ibDataSet25.Append;
    //Form7.ibDataSet25ACUMULADO1.AsFloat := StrToFloat(LimpanumeroDeixandoaVirgula(Mais1Ini.ReadString('Outros','Taxa de juros','0,0000')));
    Form7.ibDataSet25DIFERENCA_.AsFloat := StrToFloat(LimpanumeroDeixandoaVirgula(Mais1Ini.ReadString('Outros','Desconto','0,00')));
    Form7.ibDataSet25PAGAR.AsFloat      := StrToFloat(LimpanumeroDeixandoaVirgula(Mais1Ini.ReadString('Outros','Desconto total','0,00')));
    //edtJurosDiaExit(Sender);
  end;

  edtJurosDia.Text := FormatFloat('#,##0.00',StrToFloat(LimpanumeroDeixandoaVirgula(Mais1Ini.ReadString('Outros','Taxa de juros','0,0000'))));
  edtJurosDiaExit(Sender);

  edtVlMulta.Text := FormatFloat('#,##0.00',StrToFloat(LimpanumeroDeixandoaVirgula(Mais1Ini.ReadString('Outros','Multa','0,0000'))));
  rbMultaPercentual.Checked := Mais1Ini.ReadString('Outros','Tipo multa','Percentual') = 'Percentual';
  rbMultaValor.Checked      := Mais1Ini.ReadString('Outros','Tipo multa','Percentual') = 'Valor';

  SetTipoMulta;

  {Mauricio Parizotto 2023-10-02 Fim}

  if AllTrim(Mais1Ini.ReadString('Outros','Calculo de juros','1')) = '1' then
    rbJurosSimples.Checked := True
  else
    rbJurosComposto.Checked := True;

  RadioButton3.Checked := False;
  RadioButton4.Checked := False;
  RadioButton5.Checked := False;

  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '1' then RadioButton3.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '2' then RadioButton4.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '3' then RadioButton5.Checked := True;

  if ComboBox1.Text = '0' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0';
  if ComboBox1.Text = '1' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0';
  if ComboBox1.Text = '2' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00';
  if ComboBox1.Text = '3' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000';
  if ComboBox1.Text = '4' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000';

  Form7.ibDataSet4QTD_ATUAL.EditFormat    := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);

  Mais4ini := TIniFile.Create('frente.ini');

  Edit1.Text         := Mais4Ini.ReadString('mail','Host','');
  Edit2.Text         := Mais4Ini.ReadString('mail','UserID','');
  Edit3.Text         := Mais4Ini.ReadString('mail','Port','');
  Edit4.Text         := Mais4Ini.ReadString('mail','From','');
  Edit5.Text         := Mais4Ini.ReadString('mail','Name','');
  Edit6.Text         := Mais4Ini.ReadString('mail','Password','');
  ComboBoxORCA.Text  := Mais4Ini.ReadString('Orçamento','Porta','Impressora padrão do windows');

  if Mais4Ini.ReadString('mail','UseSSL','0') = '1' then
  begin
    CheckBox3.Checked := True;
  end else
  begin
    CheckBox3.Checked := False;
  end;

  Mais4Ini.Free;

  Mais1Ini.Free;
  Mais2Ini.Free;

  bChave := False;
end;

procedure TForm19.btnOKClick(Sender: TObject);
var
  Mais4Ini, Mais2Ini, Mais1Ini, Mais3Ini: TIniFile;
  ConfSistema : TArquivosDAT;
begin
  // { Grava as configurações no .INF }
  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  Mais2ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais3ini := TIniFile.Create('retaguarda.ini');

  Mais1Ini.WriteString('Nota Fiscal','Serie',AllTrim(ComboBox11.Text));
  Mais1Ini.WriteString('Nota Fiscal','Itens',AllTrim(ComboBox5.Text));
  Mais1Ini.WriteString('OS','Itens',AllTrim(ComboBox10.Text));
  Mais1Ini.WriteString('Nota Fiscal','Svc',AllTrim(ComboBox8.Text));
  Mais1Ini.WriteString('OS','Svc',AllTrim(ComboBox9.Text));
  Mais1Ini.WriteString('Nota Fiscal','Intervalo1',AllTrim(MaskEdit4.Text));
  Mais1Ini.WriteString('Nota Fiscal','Intervalo2',AllTrim(MaskEdit5.Text));
  Mais1Ini.WriteString('Nota Fiscal','Intervalo3',AllTrim(MaskEdit6.Text));

  Mais1Ini.WriteString('Atendimento','Inicial',AllTrim(MaskEdit1.Text));
  Mais1Ini.WriteString('Atendimento','Final',AllTrim(MaskEdit8.Text));

  Mais1Ini.WriteString('Lista de preços','Intervalo1',AllTrim(MaskEdit2.Text));
  Mais1Ini.WriteString('Lista de preços','Intervalo2',AllTrim(MaskEdit3.Text));
  Mais1Ini.WriteString('Lista de preços','Intervalo3',AllTrim(MaskEdit7.Text));

  Mais3Ini.WriteString('Nota Fiscal','Porta',AllTrim(ComboBoxNF.Text));
  Mais3Ini.WriteString('Nota Fiscal 2','Porta',AllTrim(ComboBoxNF2.Text));
  Mais3Ini.WriteString('Bloqueto','Porta',AllTrim(ComboBoxBloqueto.Text));

  if chkVendasAbaixoCusto.Checked = True then Mais1Ini.WriteString('Permitir','Vendas abaixo do custo','Sim') else Mais1Ini.WriteString('Permitir','Vendas abaixo do custo','Não');
  if chkEstoqueNegativoNF.Checked = True then Mais1Ini.WriteString('Permitir','Estoque negativo','Sim') else Mais1Ini.WriteString('Permitir','Estoque negativo','Não');
  if chkItensDuplicadosNF.Checked = True then Mais1Ini.WriteString('Permitir','Duplos','Sim') else Mais1Ini.WriteString('Permitir','Duplos','Não');

  //Mauricio Parizotto 2024-02-02
  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
    ConfSistema.BD.Outras.FabricaProdutoSemQtd := chkFabricaProdSemQtd.Checked;
  finally
    FreeAndNil(ConfSistema);
  end;

  if LimpaNumero(ComboBox1.Text) = '' then ComboBox1.TExt := '1';
  if LimpaNumero(ComboBox7.Text) = '' then ComboBox1.TExt := '0';
  if LimpaNumero(ComboBox4.TExt) = '' then ComboBox4.TExt := '2';
  if LimpaNumero(ComboBox6.TExt) = '' then ComboBox6.TExt := '1';
  if LimpaNumero(ComboBox2.TExt) = '' then ComboBox2.TExt := '10000';
  if LimpaNumero(ComboBox3.TExt) = '' then ComboBox3.TExt := '5';

  Mais1Ini.WriteString('Outros','Casas decimais na quantidade',ComboBox1.Text);
  Mais1Ini.WriteString('Outros','Casas decimais na quantidade de serviços',ComboBox7.Text);

  Mais1Ini.WriteString('Outros','Casas decimais no preço',ComboBox4.Text);
  Mais3Ini.WriteString('Recibo','Vias',ComboBox6.Text);

  Mais1Ini.WriteString('Outros','Teto limite para tributação de IR sobre serviços',ComboBox2.Text);
  Mais1Ini.WriteString('Outros','Aliquota de IR',ComboBox3.Text);
  //Mais1Ini.WriteString('Outros','Taxa de juros',Format('%10.4n',[Form7.ibDataSet25ACUMULADO1.AsFloat])); Mauricio Parizotto 2023-10-02
  Mais1Ini.WriteString('Outros','Taxa de juros',Format('%10.4n',[StrToFloatDef(edtJurosDia.Text,0)]));
  Mais1Ini.WriteString('Outros','Desconto',Format('%10.4n',[Form7.ibDataSet25DIFERENCA_.AsFloat]));
  Mais1Ini.WriteString('Outros','Desconto total',Format('%10.4n',[Form7.ibDataSet25PAGAR.AsFloat]));

  Mais1Ini.WriteString('Outros','Multa',Format('%10.4n',[StrToFloatDef(edtVlMulta.Text,0)]));

  if rbMultaPercentual.Checked then
    Mais1Ini.WriteString('Outros','Tipo multa','Percentual')
  else
    Mais1Ini.WriteString('Outros','Tipo multa','Valor');


  if Form19.rbJurosSimples.Checked then
    Mais1Ini.WriteString('Outros','Calculo de juros','1') else Mais1Ini.WriteString('Outros','Calculo de juros','2');

  if Form19.RadioButton3.Checked then Mais2Ini.WriteString('Html','Html1','1');
  if Form19.RadioButton4.Checked then Mais2Ini.WriteString('Html','Html1','2');
  if Form19.RadioButton5.Checked then Mais2Ini.WriteString('Html','Html1','3');
  
  { ------------------------------------------------- }
  { Configura as casas decimais na quantidade do esto }
  { ------------------------------------------------- }
  Form7.ibDataSet4QTD_ATUAL.EditFormat    := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);
  //
  Form19.Close;
  { Casas Decimais }
  Form1.ConfPreco := Mais1Ini.ReadString('Outros','Casas decimais no preço','2');
  if Form1.ConfPreco = '0' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0';
  if Form1.ConfPreco = '1' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0';
  if Form1.ConfPreco = '2' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00';
  if Form1.ConfPreco = '3' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000';
  if Form1.ConfPreco = '4' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0000';
  if Form1.ConfPreco = '5' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00000';
  if Form1.ConfPreco = '6' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000000';
  if Form1.ConfPreco = '7' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.0000000';
  if Form1.ConfPreco = '8' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.00000000';
  if Form1.ConfPreco = '9' then Form7.ibDataSet4PRECO.DisplayFormat := '#,##0.000000000';

  Form1.ConfCasas   := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
  if Form1.ConfCasas = '0' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0';
  if Form1.ConfCasas = '1' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0';
  if Form1.ConfCasas = '2' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00';
  if Form1.ConfCasas = '3' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000';
  if Form1.ConfCasas = '4' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000';
  if Form1.ConfCasas = '5' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00000';
  if Form1.ConfCasas = '6' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000000';
  if Form1.ConfCasas = '7' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000000';
  if Form1.ConfCasas = '8' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00000000';
  if Form1.ConfCasas = '9' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000000000';

  Mais2Ini.WriteString('Html','Cor',Right('000000'+AllTrim(Format('%6.0x',[ColorDialog1.Color])),6));
  Form1.sHtmlCor := Copy(Right('000000'+AllTrim(Format('%6.0x',[ColorDialog1.Color])),6),5,2)+
                    Copy(Right('000000'+AllTrim(Format('%6.0x',[ColorDialog1.Color])),6),3,2)+
                    Copy(Right('000000'+AllTrim(Format('%6.0x',[ColorDialog1.Color])),6),1,2);

  Form7.ibDataSet4QTD_ATUAL.EditFormat      := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);
  Form7.ibDataSet4PRECO.EditFormat          := copy(Form7.ibDataSet4PRECO.DisplayFormat,3,10);

  Form7.ibDataSet16QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
  Form7.ibDataSet16QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
  Form7.ibDataSet16UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
  Form7.ibDataSet16UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
  Form7.ibDataSet16TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
  Form7.ibDataSet16TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;

  Form7.ibDataSet23QUANTIDADE.EditFormat    := Form7.ibDataSet4QTD_ATUAL.EditFormat;
  Form7.ibDataSet23QUANTIDADE.DisplayFormat := Form7.ibDataSet4QTD_ATUAL.DisplayFormat;
  Form7.ibDataSet23UNITARIO.EditFormat      := Form7.ibDataSet4PRECO.EditFormat;
  Form7.ibDataSet23UNITARIO.DisplayFormat   := Form7.ibDataSet4PRECO.DisplayFormat;
  Form7.ibDataSet23TOTAL.EditFormat         := Form7.ibDataSet4PRECO.EditFormat;
  Form7.ibDataSet23TOTAL.DisplayFormat      := Form7.ibDataSet4PRECO.DisplayFormat;
  
  Form7.ibDataSet4CUSTOCOMPR.DisplayFormat  := Form7.ibDataSet4PRECO.DisplayFormat;
  Form7.ibDataSet4CUSTOCOMPR.EditFormat     := Form7.ibDataSet4PRECO.EditFormat;

  Mais4ini := TIniFile.Create('frente.ini');

  Mais4Ini.WriteString('mail','Host',Edit1.Text);
  Mais4Ini.WriteString('mail','UserID',Edit2.Text);
  Mais4Ini.WriteString('mail','Port',Edit3.Text);
  Mais4Ini.WriteString('mail','From',Edit4.Text);
  Mais4Ini.WriteString('mail','Name',Edit5.Text);
  Mais4Ini.WriteString('mail','Password',Edit6.Text);
  Mais4Ini.WriteString('Orçamento','Porta',AllTrim(ComboBoxORCA.Text));

  if CheckBox3.Checked then
  begin
    Mais4Ini.WriteString('mail','UseSSL','1');
  end else
  begin
    Mais4Ini.WriteString('mail','UseSSL','0');
  end;

  Mais4Ini.Free;

  Form1.ConfNegat   := Mais1Ini.ReadString('Permitir','Estoque negativo','Sim');
  Form1.ConfPermitFabricarSemQtd := chkFabricaProdSemQtd.Checked;

  Mais1Ini.Free;
  Mais2Ini.Free;
  Mais3Ini.Free;

  Close;
end;

procedure TForm19.btnCancelarClick(Sender: TObject);
begin
  Form19.Close;
end;

procedure TForm19.FormCreate(Sender: TObject);
var
  Mais1Ini, Mais2Ini: TIniFile;
begin
  // Lê as configurações no .INF
  Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  Mais2ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  // -- Mais1Ini.WriteString(Mais.sEscolhido,'L'+alltrim(IntToStr(I)), --
  ComboBox11.Text  := Mais1Ini.ReadString('Nota Fiscal','Serie','');
  ComboBox5.Text   := Mais1Ini.ReadString('Nota Fiscal','Itens','16');
  ComboBox10.Text  := Mais1Ini.ReadString('OS','Itens','16');
  ComboBox8.Text   := Mais1Ini.ReadString('Nota Fiscal','Svc','5');
  ComboBox9.Text   := Mais1Ini.ReadString('OS','Svc','5');

  MaskEdit4.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo1','7');
  MaskEdit5.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo2','14');
  MaskEdit6.Text  := Mais1Ini.ReadString('Nota Fiscal','Intervalo3','21');

  MaskEdit2.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo1','0,00');
  MaskEdit3.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo2','0,00');
  MaskEdit7.Text  := Mais1Ini.ReadString('Lista de preços','Intervalo3','0,00');

  MaskEdit1.Text  := Mais1Ini.ReadString('Atendimento','Inicial','08:00:00');
  MaskEdit8.Text  := Mais1Ini.ReadString('Atendimento','Final','18:00:00');

  if Mais1Ini.ReadString('Permitir','Vendas abaixo do custo','Sim') = 'Não' then chkVendasAbaixoCusto.Checked := False else chkVendasAbaixoCusto.Checked := True;
  if Mais1Ini.ReadString('Permitir','Estoque negativo','Sim') = 'Não' then chkEstoqueNegativoNF.Checked := False else chkEstoqueNegativoNF.Checked := True;
  if Mais1Ini.ReadString('Permitir','Duplos','Sim') = 'Não' then chkItensDuplicadosNF.Checked := False else chkItensDuplicadosNF.Checked := True;

  Form19.Top  := 70;
  Form19.Left := Screen.Width - Form19.Width;

  ComboBox2.Text        := Mais1Ini.ReadString('Outros','Teto limite para tributação de IR sobre serviços','R$ 100.000,00');
  ComboBox3.Text        := Mais1Ini.ReadString('Outros','Aliquota de IR','1,50 %');

  ComboBox1.Text        := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
  ComboBox7.Text        := Mais1Ini.ReadString('Outros','Casas decimais na quantidade de serviços','0');

  if ComboBox1.Text = '0' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0';
  if ComboBox1.Text = '1' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0';
  if ComboBox1.Text = '2' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.00';
  if ComboBox1.Text = '3' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.000';
  if ComboBox1.Text = '4' then Form7.ibDataSet4QTD_ATUAL.DisplayFormat := '#,##0.0000';

  Form7.ibDataSet4QTD_ATUAL.EditFormat    := copy(Form7.ibDataSet4QTD_ATUAL.DisplayFormat,3,10);

  if AllTrim(Mais1Ini.ReadString('Outros','Calculo de juros','1')) = '1' then
    rbJurosSimples.Checked := True
  else
    rbJurosComposto.Checked := True;

  RadioButton3.Checked := False;
  RadioButton4.Checked := False;
  RadioButton5.Checked := False;

  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '1' then RadioButton3.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '2' then RadioButton4.Checked := True;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '3' then RadioButton5.Checked := True;

  try
    Edit7.Color := StrToInt('$'+AllTrim(Mais2Ini.ReadString('Html','Cor','EBEBEB')));
    Edit8.Color := StrToInt('$'+AllTrim(Mais2Ini.ReadString('Html','Cor','EBEBEB')));
  except
  end;

  Mais1Ini.Free;

  // Opções
  Form19.Width  := 650;
  Form19.Height := 450;
end;

procedure TForm19.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;

procedure TForm19.MaskEdit2Exit(Sender: TObject);
begin
  try
    MaskEdit2.Text := Format('%5.2n',[StrToFloat(StrTran(StrTran(StrTran(StrTran(MaskEdit2.Text,' ',''),' ',''),' ',''),' ',''))])
  except MaskEdit2.Text := '0,00' end;
end;

procedure TForm19.MaskEdit3Exit(Sender: TObject);
begin
  try
    MaskEdit3.Text := Format('%5.2n',[StrToFloat(StrTran(StrTran(StrTran(StrTran(MaskEdit3.Text,' ',''),' ',''),' ',''),' ',''))])
  except MaskEdit3.Text := '0,00' end;
end;

procedure TForm19.MaskEdit7Exit(Sender: TObject);
begin
  try
    MaskEdit7.Text := Format('%5.2n',[StrToFloat(StrTran(StrTran(StrTran(StrTran(MaskEdit7.Text,' ',''),' ',''),' ',''),' ',''))])
  except MaskEdit7.Text := '0,00' end;
end;

procedure TForm19.MaskEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(46) then key := chr(44);
end;

procedure TForm19.MaskEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;


procedure TForm19.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais2ini : TIniFile;
begin
  Chdir(Form1.sAtual);
  Mais2ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '1' then Form1.bHtml1 := True else Form1.bHtml1 := False;
  if AllTrim(Mais2Ini.ReadString('Html','Html1','1')) = '3' then
  begin
    Form1.bHtml1 := True;
    Form1.bPDF   := True;
  end else
  begin
    Form1.bPDF   := False;
  end;
  
  Form2.bFlag := True;
  Form1.FormShow(Sender);
end;

procedure TForm19.MaskEdit4Exit(Sender: TObject);
begin
  if AllTrim(LimpaNumero(MaskEdit4.Text)) = '' then MaskEdit4.Text := '7';
end;

procedure TForm19.MaskEdit5Exit(Sender: TObject);
begin
  if AllTrim(LimpaNumero(MaskEdit5.Text)) = '' then
    MaskEdit5.Text := '14';
end;

procedure TForm19.MaskEdit6Exit(Sender: TObject);
begin
  if AllTrim(LimpaNumero(MaskEdit6.Text)) = '' then MaskEdit6.Text := '21';
end;

procedure TForm19.Edit7Click(Sender: TObject);
begin
  ColorDialog1.Execute;
  Edit7.Color := StrToInt('$'+AllTrim(Format('%18.0x',[ColorDialog1.Color])));
  Edit8.Color := StrToInt('$'+AllTrim(Format('%18.0x',[ColorDialog1.Color])));
end;

procedure TForm19.Image1Click(Sender: TObject);
begin
  if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
    Form14.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGOTIP.BMP');
    
  if not FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
    Form14.Image1.Picture.SaveToFile('LOGOTIP.BMP');

  ShellExecute( 0, 'Open','pbrush.exe','LOGOTIP.BMP', '', SW_SHOW);
  //ShowMessage('Tecle <enter> para que a nova imagem seja exibida.'); Mauricio Parizotto 2023-10-25
  MensagemSistema('Tecle <enter> para que a nova imagem seja exibida.');

  if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
  begin
    Form19.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGOTIP.BMP');
    Form14.Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGOTIP.BMP');
  end;

  Form14.Image1.Picture.Bitmap.Height :=  90;
  Form14.Image1.Picture.Bitmap.Width  := 360;
  Form14.Image1.Picture.SaveToFile('LOGOTIP.BMP');
end;

procedure TForm19.ComboBox5Exit(Sender: TObject);
begin
  try
    if StrToInt(AllTrim(ComboBox5.Text)) < 3 then ComboBox5.Text := '3';
  except ComboBox5.Text := '16' end;
end;

procedure TForm19.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;

procedure TForm19.rbJurosSimplesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;

procedure TForm19.btnOKKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;

procedure TForm19.rbJurosCompostoClick(Sender: TObject);
begin
  bChave := True;
end;

procedure TForm19.rbJurosSimplesClick(Sender: TObject);
begin
  bChave := True;
end;

procedure TForm19.FormHide(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  if bChave then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.WriteString('Outros','Data','26/09/1967');
  end;
end;

procedure TForm19.Edit7Enter(Sender: TObject);
begin
  btnOK.SetFocus;
end;

procedure TForm19.Edit8Enter(Sender: TObject);
begin
  btnOK.SetFocus;
end;

procedure TForm19.Image7Click(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  Form19.Image9.Picture.Bitmap := Form19.Image7.Picture.Bitmap;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  Mais1Ini.WriteString('Perfil','tela_3d','1');
  Mais1Ini.Free;
  Form1.sContrasteCor := 'PRETO';
  Form19.Button1Click(Sender);
end;

procedure TForm19.Button1Click(Sender: TObject);
var
  r1 : tRect;
begin
  begin
    Form7.imgNovo.Picture := Form1.imgVendas.Picture;
    Form7.imgExcluir.Picture := Form1.imgVendas.Picture;
    Form7.imgProcurar.Picture := Form1.imgVendas.Picture;
    Form7.imgVisualizar.Picture := Form1.imgVendas.Picture;
    Form7.imgImprimir.Picture := Form1.imgVendas.Picture;
    Form7.imgEditar.Picture := Form1.imgVendas.Picture;
    Form7.imgLibBloq.Picture := Form1.imgVendas.Picture;
    Form7.imgFiltrar.Picture := Form1.imgVendas.Picture;
    Form7.Image308.Picture := Form1.imgVendas.Picture;

    if FileExists(Form1.sAtual+'\inicial\small_22_.bmp') then
    begin
      if FileExists(Form1.sAtual+'\inicial\small_22_.bmp') then
        Form19.Image7.Picture.LoadFromFile(Form1.sAtual+'\inicial\small_22_.bmp');

      Form19.Image9.Picture.Bitmap := Form19.Image7.Picture.Bitmap;

      // BOTOES PRINCIPAIS
      r1.Top     := 30;
      r1.Bottom  := 30 + 70;

      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);

      Form1.imgVendas.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgVendas.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 1);
      r1.Right   := 10 + (70 * 2);

      Form1.imgOrdemServico.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgOrdemServico.Picture.Bitmap.TransParentColor := Form1.imgOrdemServico.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 2);
      r1.Right   := 10 + (70 * 3);

      Form1.imgEstoque.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgEstoque.Picture.Bitmap.TransParentColor := Form1.imgEstoque.Picture.BitMap.canvas.pixels[1,1];
      
      r1.Left    := 10 + (70 * 3);
      r1.Right   := 10 + (70 * 4);

      Form1.imgCliFor.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgCliFor.Picture.Bitmap.TransParentColor := Form1.imgCliFor.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 4);
      r1.Right   := 10 + (70 * 5);

      Form1.imgContaReceber.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgContaReceber.Picture.Bitmap.TransParentColor := Form1.imgContaReceber.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 5);
      r1.Right   := 10 + (70 * 6);

      Form1.imgContaPagar.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgContaPagar.Picture.Bitmap.TransParentColor := Form1.imgContaPagar.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 6);
      r1.Right   := 10 + (70 * 7);

      Form1.imgCaixa.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgCaixa.Picture.Bitmap.TransParentColor := Form1.imgCaixa.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 7);
      r1.Right   := 10 + (70 * 8);

      Form1.imgBancos.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgBancos.Picture.Bitmap.TransParentColor := Form1.imgBancos.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 8);
      r1.Right   := 10 + (70 * 9);

      Form1.imgConfiguracoes.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgConfiguracoes.Picture.Bitmap.TransParentColor := Form1.imgConfiguracoes.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 9);
      r1.Right   := 10 + (70 *10);

      Form1.imgBackup.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgBackup.Picture.Bitmap.TransParentColor := Form1.imgBackup.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 10);
      r1.Right   := 10 + (70 * 11);

      Form1.imgServicos.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgServicos.Picture.Bitmap.TransParentColor := Form1.imgServicos.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 11);
      r1.Right   := 10 + (70 * 12);

      Form1.imgCompras.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.imgCompras.Picture.Bitmap.TransParentColor := Form1.imgCompras.Picture.BitMap.canvas.pixels[1,1];

      // BOTOES SECUNDARIOS
      r1.Top     := 30 + 70;
      r1.Bottom  := 30 + 70 + 70;

      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);

      Form7.imgNovo.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgNovo.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 1);
      r1.Right   := 10 + (70 * 2);

      Form7.imgExcluir.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgExcluir.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 2);
      r1.Right   := 10 + (70 * 3);

      Form7.imgProcurar.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgProcurar.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 3);
      r1.Right   := 10 + (70 * 4);

      Form7.imgImprimir.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgImprimir.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 4);
      r1.Right   := 10 + (70 * 5);

      Form7.imgVisualizar.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgVisualizar.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 5);
      r1.Right   := 10 + (70 * 6);
      Form7.imgEditar.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgEditar.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 6);
      r1.Right   := 10 + (70 * 7);

      Form7.imgFiltrar.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgFiltrar.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 8);
      r1.Right   := 10 + (70 * 9);

      Form7.imgLibBloq.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.imgLibBloq.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 9);
      r1.Right   := 10 + (70 * 10);

      Form7.Image308.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image308.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      // BOTOES TERCIARIOS Form10
      Form10.Image201.Picture.Bitmap       := Form7.imgNovo.Picture.Bitmap;
      Form10.Image202.Picture.Bitmap       := Form7.imgProcurar.Picture.Bitmap;
      Form10.Image203.Picture.Bitmap       := Form7.imgVisualizar.Picture.Bitmap;

      Form10.Image204.Picture.Bitmap       := Form7.imgNovo.Picture.Bitmap;
      Form10.Image205.Picture.Bitmap       := Form7.imgNovo.Picture.Bitmap;

      r1.Top     := 30 + 70 + 70;
      r1.Bottom  := 30 + 70 + 70 + 70;

      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);

      Form10.Image204.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form10.Image204.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 1);
      r1.Right   := 10 + (70 * 2);

      Form10.Image205.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form10.Image205.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      // Botão Small Mobile
      if not (Form1.iReduzida = 1) then
      begin
        r1.Left    := 10 + (70 * 2);
        r1.Right   := 10 + (70 * 3);

        Form1.imgIndicadores.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
        Form1.imgIndicadores.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];
      end;

      r1.Left    := 10 + (70 * 3);
      r1.Right   := 10 + (70 * 4);

      Form1.Image_Raio_1.Picture     := Form1.imgIndicadores.Picture;

      Form1.Image_Raio_1.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image_Raio_1.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      // PERIGO BACKUP
      r1.Left    := 10 + (70 * 9);
      r1.Right   := 10 + (70 *10);

      Form1.Image_Perigo_1.Picture   := Form1.imgBackup.Picture;

      Form1.Image_Perigo_1.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image_Perigo_1.Picture.Bitmap.TransParentColor := Form1.imgBackup.Picture.BitMap.canvas.pixels[1,1];

      Form1.Image_Perigo_2.Picture   := Form1.imgBackup.Picture;

      Form1.Image_Raio_2.Picture     := Form1.imgIndicadores.Picture;

      // BOTOES PRINCIPAIS DESTACADOS
      Form1.Image203_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image200_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image201_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image201__X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image202_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image203_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image204_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image210_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image205_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image206_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image207_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image208_X.Picture.Bitmap  := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image201C_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form1.Image201S_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;

      r1.Top     := 330;
      r1.Bottom  := 330 + 70;

      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);

      Form1.Image201_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image201_X.Picture.Bitmap.TransParentColor := Form1.imgVendas.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 1);
      r1.Right   := 10 + (70 * 2);

      Form1.Image201__X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image201__X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 2);
      r1.Right   := 10 + (70 * 3);

      Form1.Image202_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image202_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];

      r1.Left    := 10 + (70 * 3);
      r1.Right   := 10 + (70 * 4);

      Form1.Image203_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image203_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      
      r1.Left    := 10 + (70 * 4);
      r1.Right   := 10 + (70 * 5);
      //
      Form1.Image204_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image204_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 5);
      r1.Right   := 10 + (70 * 6);
      //
      Form1.Image210_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image210_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 6);
      r1.Right   := 10 + (70 * 7);
      //
      Form1.Image205_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image205_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 7);
      r1.Right   := 10 + (70 * 8);
      //
      Form1.Image206_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image206_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 8);
      r1.Right   := 10 + (70 * 9);
      //
      Form1.Image207_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image207_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 9);
      r1.Right   := 10 + (70 *10);
      //
      Form1.Image208_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image208_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 10);
      r1.Right   := 10 + (70 * 11);
      //
      Form1.Image201S_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image201S_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 11);
      r1.Right   := 10 + (70 * 12);
      //
      Form1.Image201C_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image201C_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];

      // BOTOES SECUNDARIOS DESTACADOS
      Form7.Image201_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image202_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image203_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image205_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image204_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image206_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image209_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image208_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;
      Form7.Image308_X.Picture.Bitmap := Form1.imgCliFor.Picture.Bitmap;

      r1.Top     := 330 + 70;
      r1.Bottom  := 330 + 70 + 70;
      //
      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);
      //
      Form7.Image201_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image201_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 1);  //
      r1.Right   := 10 + (70 * 2);  //
      //
      Form7.Image202_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image202_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 2);  //
      r1.Right   := 10 + (70 * 3);  //
      //
      Form7.Image203_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image203_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 3);  //
      r1.Right   := 10 + (70 * 4);  //
      //
      Form7.Image205_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image205_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 4);  //
      r1.Right   := 10 + (70 * 5);  //
      //
      Form7.Image204_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image204_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 5);
      r1.Right   := 10 + (70 * 6);
      Form7.Image206_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image206_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 6);
      r1.Right   := 10 + (70 * 7);
      //
      Form7.Image209_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image209_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      //
      r1.Left    := 10 + (70 * 8);
      r1.Right   := 10 + (70 * 9);
      //
      Form7.Image208_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image208_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 9);
      r1.Right   := 10 + (70 *10);
      //
      Form7.Image308_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form7.Image308_X.Picture.Bitmap.TransParentColor := Form1.Image208_X.Picture.BitMap.canvas.pixels[1,1];

      // BOTOES TERCIARIOS Form10 DESTACADOS
      Form10.Image201_X.Picture.Bitmap       := Form7.Image201_X.Picture.Bitmap;
      Form10.Image202_X.Picture.Bitmap       := Form7.Image203_X.Picture.Bitmap;
      Form10.Image203_X.Picture.Bitmap       := Form7.Image204_X.Picture.Bitmap;
      //
      Form10.Image204_X.Picture.Bitmap       := Form7.Image201_X.Picture.Bitmap;
      Form10.Image205_X.Picture.Bitmap       := Form7.Image201_X.Picture.Bitmap;
      //
      r1.Top     := 330 + 70 + 70;
      r1.Bottom  := 330 + 70 + 70 + 70;
      //
      r1.Left    := 10 + (70 * 0);
      r1.Right   := 10 + (70 * 1);
      //
      Form10.Image204_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form10.Image204_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
      //
      r1.Left    := 10 + (70 * 1);  //
      r1.Right   := 10 + (70 * 2);  //
      //
      Form10.Image205_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form10.Image205_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];

      // Botão Small Mobile
      r1.Left    := 10 + (70 * 2);  //
      r1.Right   := 10 + (70 * 3);  //
      //
      Form1.Image200_X.Picture.Bitmap.Canvas.CopyRect(Rect(0,0,70,70),Form19.Image9.Picture.Bitmap.Canvas,R1);
      Form1.Image200_X.Picture.Bitmap.TransParentColor := Form1.Image201_X.Picture.BitMap.canvas.pixels[1,1];
    end;
  end;

  Form1.Image200_R.Picture  := Form1.imgIndicadores.Picture;
  Form1.Image201_R.Picture  := Form1.imgVendas.Picture;
  Form1.Image201C_R.Picture := Form1.imgCompras.Picture;
  Form1.Image201S_R.Picture := Form1.imgServicos.Picture;

  Form1.Image201__R.Picture := Form1.imgOrdemServico.Picture;
  Form1.Image202_R.Picture  := Form1.imgEstoque.Picture;
  Form1.Image203_R.Picture  := Form1.imgCliFor.Picture;
  Form1.Image204_R.Picture  := Form1.imgContaReceber.Picture;
  Form1.Image210_R.Picture  := Form1.imgContaPagar.Picture;
  Form1.Image205_R.Picture  := Form1.imgCaixa.Picture;
  Form1.Image206_R.Picture  := Form1.imgBancos.Picture;
  Form1.Image207_R.Picture  := Form1.imgConfiguracoes.Picture;
  Form1.Image208_R.Picture  := Form1.imgBackup.Picture;

  Form7.Image201_R.Picture.Bitmap := Form7.imgNovo.Picture.Bitmap;
  Form7.Image202_R.Picture.Bitmap := Form7.imgExcluir.Picture.Bitmap;
  Form7.Image203_R.Picture.Bitmap := Form7.imgProcurar.Picture.Bitmap;
  Form7.Image205_R.Picture.Bitmap := Form7.imgImprimir.Picture.Bitmap;
  Form7.Image204_R.Picture.Bitmap := Form7.imgVisualizar.Picture.Bitmap;
  Form7.Image206_R.Picture.Bitmap := Form7.imgEditar.Picture.Bitmap;
  Form7.Image209_R.Picture.Bitmap := Form7.imgFiltrar.Picture.Bitmap;
  Form7.Image208_R.Picture.Bitmap := Form7.imgLibBloq.Picture.Bitmap;
  Form7.Image308_R.Picture.Bitmap := Form7.Image308.Picture.Bitmap;

  Form10.Image201_R.Picture.Bitmap       := Form10.Image201.Picture.Bitmap;
  Form10.Image202_R.Picture.Bitmap       := Form10.Image202.Picture.Bitmap;
  Form10.Image203_R.Picture.Bitmap       := Form10.Image203.Picture.Bitmap;
  Form10.Image204_R.Picture.Bitmap       := Form10.Image204.Picture.Bitmap;
  Form10.Image205_R.Picture.Bitmap       := Form10.Image205.Picture.Bitmap;

  Form1.MontaTela(True);
end;

procedure TForm19.FormShow(Sender: TObject);
begin
  Form19.Width  := 640;
  Form19.Height := 480;

  btnOK.Left  := Panel3.Width - btnOK.Width - 10;
  btnCancelar.Left  := btnOK.Left - 140;

  ComboBoxImpressora.Items.Clear;
  comboBoxNF.Items.clear;
  comboBoxNF2.Items.clear;
  comboBoxORCA.Items.clear;
  comboBoxBloqueto.Items.clear;

  Form19.ComboBoxORCA.Items.Add('Impressora padrão do windows');
  Form19.ComboBoxORCA.Items.Add('PDF');
  Form19.ComboBoxORCA.Items.Add('HTML');
  Form19.ComboBoxORCA.Items.Add('TXT');
  
  GetTheListOfPrinters;
end;

procedure TForm19.CheckBox8Click(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\'+Usuario+'.inf');
  if CheckBox8.Checked then
  begin
    Mais1Ini.WriteString('Perfil','Labels','Sim');
  end else
  begin
    Mais1Ini.WriteString('Perfil','Labels','Não');
  end;

  Form19.Button1Click(Sender);

  if (Form19.Visible) and (Form19.CanFocus) then
    Form19.SetFocus;
end;

procedure TForm19.JurosEnter(Sender: TObject);
begin
  Form7.ibDataSet25.Open;
  Form7.ibDataSet25.Edit;
end;

procedure TForm19.ComboBox8Exit(Sender: TObject);
begin
  try
    if StrToInt(AllTrim(ComboBox8.Text)) < 3 then ComboBox8.Text := '3';
  except ComboBox8.Text := '16' end;
end;

procedure TForm19.ComboBox9Exit(Sender: TObject);
begin
  try
    if StrToInt(AllTrim(ComboBox9.Text)) < 3 then ComboBox9.Text := '3';
  except ComboBox9.Text := '5' end;
end;

procedure TForm19.ComboBox10Exit(Sender: TObject);
begin
  try
    if StrToInt(AllTrim(ComboBox10.Text)) < 3 then ComboBox10.Text := '3';
  except ComboBox10.Text := '16' end;
end;

procedure TForm19.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config.htm')));
end;

procedure TForm19.ComboBox11Exit(Sender: TObject);
var
  sS, sMax : String;
begin
  if ComboBox11.Text = '000' then
  begin
    ComboBox11.Text := '000';
    Form1.sSerieEspecial := ComboBox11.Text;
  end else
  begin
    if LimpaNumero(ComboBox11.Text) <> '' then
    begin
      Form1.sSerieEspecial := ComboBox11.Text;
    end;
  end;

  if Form1.sSerieEspecial <> 'XXX' then
  begin
    try
      Form7.IBDataSet99.Close;
      Form7.IBDataSet99.SelectSQL.Clear;
      Form7.ibDataset99.SelectSql.Add('select gen_id(G_SERIE'+Form1.sSerieEspecial+',1) from rdb$database');
      Form7.IBDataSet99.Open;

      sS := StrZero(StrtoFloat(Form7.ibDataSet99.FieldByname('GEN_ID').AsString),9,0)+Right(Form7.sTitulo,3);
    except
      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.SQL.Clear;
        Form1.ibQuery1.SQL.Add('create generator G_SERIE'+Form1.sSerieEspecial);
        Form1.ibQuery1.ExecSQL;
      except
      end;

      try
        Form1.ibQuery1.Close;
        Form1.ibQuery1.SQL.Clear;
        Form1.ibQuery1.SQL.Add('select max(NUMERONF) from VENDAS where NUMERONF like '+QuotedStr('%')+form1.sSerieEspecial+' ');
        Form1.ibQuery1.Open;
        sMax := Form1.ibQuery1.fieldByname('MAX').AsString;
        Form1.ibQuery1.Close;
        Form1.ibQuery1.SQL.Clear;
        Form1.ibQuery1.SQL.Add('set generator G_SERIE'+Form1.sSerieEspecial+' to 0'+copy(sMax,1,9)+' ');
        Form1.ibQuery1.ExecSQL;
      except
      end;
    end
  end;
end;

procedure TForm19.edtJurosDiaKeyPress(Sender: TObject; var Key: Char);
begin
  ValidaValor(Sender, Key,'F');
end;

procedure TForm19.edtJurosDiaExit(Sender: TObject);
begin
  edtJurosDia.Text := FormatFloat('#,##0.00', StrToFloatDef(edtJurosDia.Text,0));

  Form1.fTaxa := StrToFloatDef(edtJurosDia.Text,0);
  edtJurosMes.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosDia.Text,0) * 30);
  edtJurosAno.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosDia.Text,0) * 360);
end;

procedure TForm19.edtJurosMesExit(Sender: TObject);
begin
  edtJurosMes.Text := FormatFloat('#,##0.00', StrToFloatDef(edtJurosMes.Text,0));

  Form1.fTaxa := StrToFloatDef(edtJurosDia.Text,0);
  edtJurosDia.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosMes.Text,0) / 30);
  edtJurosAno.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosDia.Text,0) * 360);

  Form1.fTaxa := StrToFloatDef(edtJurosDia.Text,0);
end;

procedure TForm19.edtJurosAnoExit(Sender: TObject);
begin
  edtJurosAno.Text := FormatFloat('#,##0.00', StrToFloatDef(edtJurosAno.Text,0));

  edtJurosDia.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosAno.Text,0) / 360);
  edtJurosMes.Text := FormatFloat('#,##0.00',StrToFloatDef(edtJurosDia.Text,0) * 30);

  Form1.fTaxa := StrToFloatDef(edtJurosDia.Text,0);
end;

procedure TForm19.edtVlMultaExit(Sender: TObject);
begin
  edtVlMulta.Text := FormatFloat('#,##0.00', StrToFloatDef(edtVlMulta.Text,0));
end;

procedure TForm19.rbMultaPercentualClick(Sender: TObject);
begin
  SetTipoMulta;
end;

procedure TForm19.SetTipoMulta;
begin
  if rbMultaPercentual.Checked then
    lblMulta.Caption := '%'
  else
    lblMulta.Caption := 'R$';
end;

end.


