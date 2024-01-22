unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Mask, SmallFunc_xe, ShellApi, HtmlHelp,
  frame_teclado_1, Buttons, DB, IBCustomDataSet, IBQuery
  , uajustaresolucao, CheckLst, uframeCampoCaixasRelatorio;

const DOCUMENTO_NFCE   = '65 - NFC-e';
const DOCUMENTO_CFeSAT = '59 - CF-e-SAT';
const DOCUMENTO_MEI    = '99 - Documento MEI';

type
  TForm7 = class(TForm)
    Button1: TBitBtn;
    Button2: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2___: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    DateTimePicker3: TDateTimePicker;
    Label7: TLabel;
    edCPFCNPJ: TEdit;
    TabSheet3: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    dtpVendasInicial: TDateTimePicker;
    Label10: TLabel;
    dtpVendasFinal: TDateTimePicker;
    cbFormasPagto: TComboBox;
    Label11: TLabel;
    Label13: TLabel;
    edCliente: TEdit;
    IBQFORMASPAGAMENTO: TIBQuery;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    dtpEstoque: TDateTimePicker;
    TabSheet5: TTabSheet;
    Label16: TLabel;
    Label17: TLabel;
    dtpMovimentoDia: TDateTimePicker;
    Label18: TLabel;
    edMovimentoDia: TEdit;
    TabSheet6: TTabSheet;
    Label20: TLabel;
    Label21: TLabel;
    edCaixaDiario: TEdit;
    Label22: TLabel;
    Label19: TLabel;
    dtpInicialDiario: TDateTimePicker;
    Label23: TLabel;
    dtpFinalDiario: TDateTimePicker;
    cbModeloDiario: TComboBox;
    dtpMovimentoDiaF: TDateTimePicker;
    Label2: TLabel;
    checkMovimendoDiaPDF: TCheckBox;
    checkVendaPorDocumento: TCheckBox;
    checkTotalDiario: TCheckBox;
    checkMeioPagamento: TCheckBox;
    TabSheet7: TTabSheet;
    Label24: TLabel;
    Label25: TLabel;
    DateTimePicker4: TDateTimePicker;
    Label26: TLabel;
    DateTimePicker5: TDateTimePicker;
    CheckBox3: TCheckBox;
    dtpMovimentoHoraI: TDateTimePicker;
    dtpMovimentoHoraF: TDateTimePicker;
    chkMovimentoDiaHoraI: TCheckBox;
    chkMovimentoDiaHoraF: TCheckBox;
    chkNFCe: TCheckBox;
    chkCFe: TCheckBox;
    TabSheet8: TTabSheet;
    Label27: TLabel;
    Label28: TLabel;
    chkCaixaFechamentoDeCaixa: TCheckBox;
    Label30: TLabel;
    dtpFechamentoDeCaixaIni: TDateTimePicker;
    edFechamentoDeCaixa1: TEdit;
    dtpFechamentoDeCaixaFim: TDateTimePicker;
    checkFechamentoDeCaixaPDF: TCheckBox;
    dtpFechamentoDeCaixaHoraI: TDateTimePicker;
    dtpFechamentoDeCaixaHoraF: TDateTimePicker;
    chkFechamentoDeCaixaHoraI: TCheckBox;
    chkFechamentoDeCaixaHoraF: TCheckBox;
    chklbCaixas: TCheckListBox;
    frameCampoCaixasRelVendaPorDoc: TframeCampoCaixasRel;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure MaskEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateTimePicker1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edMovimentoDiaExit(Sender: TObject);
    procedure edCaixaDiarioEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CheckBox3Click(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure chkMovimentoDiaHoraIClick(Sender: TObject);
    procedure chkMovimentoDiaHoraFClick(Sender: TObject);
    procedure chkFechamentoDeCaixaHoraIClick(Sender: TObject);
    procedure TabSheet8Show(Sender: TObject);
    procedure chklbCaixasClickCheck(Sender: TObject);
    procedure chkCaixaFechamentoDeCaixaClick(Sender: TObject);
  private
    { Private declarations }
    Form7Label1Height: Integer;
    Form7Label3Top: Integer;
    Form7Label5Top: Integer;
    Form7DateTimePicker1Top: Integer;
    Form7DateTimePicker2Top: Integer;
  public
    { Public declarations }
    sMfd : String;
    bVendaCPF: Boolean;
    bVendaPorDocumento: Boolean;
    bEstoqueMensal: Boolean;
    bMovimentoDia: Boolean;
    bTotalDiario: Boolean;
    bDocumentoEmitidoPeriodo: Boolean;
    bFechamentoDeCaixa: Boolean;
  end;

var
  Form7: TForm7;

implementation

uses fiscal
  , Unit22
  , Unit2
  , _small_1
  , _small_2
  , _small_3
  {Sandro Silva 2021-07-22 inicio
  , _small_4
  , _small_5
  , _small_6
  , _small_7
  , _small_8
  , _small_9
  , _small_10
  , _small_11
  }
  , _small_12
  , _small_65
  , _small_14
  , _small_15
  , _small_59, urelatoriosgerenciais;

{$R *.DFM}

procedure TForm7.FormActivate(Sender: TObject);
begin
  if Screen.Height <= 768 then
    Form7.BorderStyle := bsToolWindow;

  PageControl1.Height     := AjustaAltura(232); // Sandro Silva 2017-08-30  232;
  PageControl1.ActivePage := TabSheet1;

  if bVendaCPF then
    PageControl1.ActivePage := TabSheet2;

  if bVendaPorDocumento then
  begin
    if checkVendaPorDocumento.Parent <> frameCampoCaixasRelVendaPorDoc.chklbCaixas.Parent then
      AjustaResolucao(frameCampoCaixasRelVendaPorDoc);

    frameCampoCaixasRelVendaPorDoc.Height := frameCampoCaixasRelVendaPorDoc.chklbCaixas.Top + frameCampoCaixasRelVendaPorDoc.chklbCaixas.Height + 1;
    frameCampoCaixasRelVendaPorDoc.Width := Self.Width;

    checkVendaPorDocumento.Parent := frameCampoCaixasRelVendaPorDoc.chklbCaixas.Parent;
    checkVendaPorDocumento.Left   := frameCampoCaixasRelVendaPorDoc.chklbCaixas.Left + frameCampoCaixasRelVendaPorDoc.chklbCaixas.Width + 50;
    checkVendaPorDocumento.Top    := (frameCampoCaixasRelVendaPorDoc.chklbCaixas.Top + frameCampoCaixasRelVendaPorDoc.chklbCaixas.Height - checkVendaPorDocumento.Height) + 5;

    checkVendaPorDocumento.BringToFront;

    checkVendaPorDocumento.Font := Label13.Font;

    PageControl1.ActivePage := TabSheet3;
  end;

  if bEstoqueMensal then
    PageControl1.ActivePage := TabSheet4;

  if bMovimentoDia then
  begin
    checkMovimendoDiaPDF.Font := Label18.Font;
    checkMovimendoDiaPDF.Left := edMovimentoDia.Left + edMovimentoDia.Width + AjustaLargura(15);
    checkMovimendoDiaPDF.Top  := edMovimentoDia.Top;
    PageControl1.ActivePage := TabSheet5;
  end;

  if bTotalDiario then
  begin
    checkTotalDiario.Font := Label21.Font;
    checkTotalDiario.Left := edCaixaDiario.Left + edCaixaDiario.Width + AjustaLargura(15);
    checkTotalDiario.Top  := edCaixaDiario.Top;
    PageControl1.ActivePage := TabSheet6;
  end;

  {Sandro Silva 2023-11-01 inicio}
  if bFechamentoDeCaixa then
  begin
    {
    checkFechamentoDeCaixaPDF.Font := Label18.Font;
    checkFechamentoDeCaixaPDF.Left := edFechamentoDeCaixa.Left + edFechamentoDeCaixa.Width + AjustaLargura(15);
    checkFechamentoDeCaixaPDF.Top  := edFechamentoDeCaixa.Top;
    }
    chklbCaixas.Top  := chkCaixaFechamentoDeCaixa.BoundsRect.Bottom + 2;
    chklbCaixas.Left := chkCaixaFechamentoDeCaixa.Left;
    PageControl1.ActivePage := TabSheet8;
  end;
  {Sandro Silva 2023-11-01 fim}

  if bDocumentoEmitidoPeriodo then
  begin
    CheckBox3.Font := DateTimePicker4.Font;
    CheckBox3.Left := DateTimePicker4.Left;
    CheckBox3.Top  := DateTimePicker5.BoundsRect.Bottom + AjustaAltura(8);

    chkNFCe.Font := DateTimePicker4.Font;
    chkCFe.Font  := DateTimePicker4.Font;
    chkNFCe.Left := DateTimePicker4.Left;
    chkCFe.Left  := chkNFCe.Left + chkNFCe.Width + AjustaLargura(8);
    chkNFCe.Top  := CheckBox3.BoundsRect.Bottom + AjustaAltura(8);
    chkCFe.Top   := chkNFCe.Top;

    chkNFCe.Visible := (Pos('|' + AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString), '|CE||SP|') > 0);
    chkCFe.Visible  := chkNFCe.Visible;

    PageControl1.ActivePage := TabSheet7;
  end;

  if PageControl1.ActivePage = TabSheet1 then
  begin
    //
    Form7.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
    Form7.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;
    //
    Form7.Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
    Form7.Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;
    //
    Form7.Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
    Form7.Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
    //
    FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    DateTimePicker1.Date := Date;
    DateTimePicker2.Date := Date;
    if Form7.Label3.Caption = 'Data inicial:' then
      Form7.DateTimePicker1.SetFocus
    else
      Form7.MaskEdit1.SetFocus;
    if not Form1.bData then
      Form7.Button1Click(Sender);
  end;

  if bVendaPorDocumento then
  begin
    PageControl1.Height   := AjustaAltura(284); // Sandro Silva 2017-08-30  284;
    dtpVendasInicial.Date := Date;
    dtpVendasFinal.Date   := Date;
    edCliente.Clear;

    IBQFORMASPAGAMENTO.Close;
    IBQFORMASPAGAMENTO.SQL.Text :=
      'select distinct replace(replace(substring(FORMA from 4 for 30), ''NFC-e'', ''''), ''NF-e'', '''') as FORMA ' +
      'from PAGAMENT ' +
      'where substring(FORMA from 1 for 2) <> ''00'' and substring(FORMA from 1 for 2) <> ''13'' ' +
      'order by 1';
    IBQFORMASPAGAMENTO.Open;

    cbFormasPagto.Clear;
    cbFormasPagto.Items.Add('');
    while IBQFORMASPAGAMENTO.Eof = False do
    begin
      cbFormasPagto.Items.Add(IBQFORMASPAGAMENTO.FieldByName('FORMA').AsString);
      IBQFORMASPAGAMENTO.Next;
    end; // while IBQFORMASPAGAMENTO.Eof = False do
    cbFormasPagto.SetFocus;
  end;

  if bEstoqueMensal then
  begin
    dtpEstoque.Date := Date;
  end;

  if bMovimentoDia then
  begin
    //aqui formata data e mais
    Form7.Caption          := 'Movimento do dia';
    dtpMovimentoDia.Date   := Date;
    dtpMovimentoDiaF.Date  := Date; // Sandro Silva 2017-12-14
    edMovimentoDia.Text    := Form1.sCaixa;
    dtpMovimentoHoraI.Time := Time;
    dtpMovimentoHoraF.Time := Time;

  end;

  {Sandro Silva 2023-11-01 inicio}
  if bFechamentoDeCaixa then
  begin
    //Form7.Caption                  := 'Fechamento de Caixa';
    dtpFechamentoDeCaixaIni.Date   := Date;
    dtpFechamentoDeCaixaFim.Date     := Date;
    //edFechamentoDeCaixa.Text       := Form1.sCaixa;
    dtpFechamentoDeCaixaHoraI.Date := Date;
    dtpFechamentoDeCaixaHoraF.Date := Date;
    dtpFechamentoDeCaixaHoraI.Time := Time;
    dtpFechamentoDeCaixaHoraF.Time := Time;


  end;
  {Sandro Silva 2023-11-01 fim}

  if bTotalDiario then
  begin
    dtpInicialDiario.Date := Date;
    dtpFinalDiario.Date   := Date;
    //edModeloDoc.Text      := Form1.sModeloECF;
    cbModeloDiario.Clear;
    {Sandro Silva 2020-09-28 inicio
    cbModeloDiario.Items.Add(DOCUMENTO_NFCE);
    cbModeloDiario.Items.Add(DOCUMENTO_CFeSAT);
    if Form1.sModeloECF = '65' then
      cbModeloDiario.ItemIndex := cbModeloDiario.Items.IndexOf(DOCUMENTO_NFCE);
    if Form1.sModeloECF = '59' then
      cbModeloDiario.ItemIndex := cbModeloDiario.Items.IndexOf(DOCUMENTO_CFeSAT);
    }
    if Form1.sModeloECF = '99' then
    begin
      cbModeloDiario.Items.Add(DOCUMENTO_MEI);
      cbModeloDiario.ItemIndex := cbModeloDiario.Items.IndexOf(DOCUMENTO_MEI);
    end
    else
    begin
      cbModeloDiario.Items.Add(DOCUMENTO_NFCE);
      cbModeloDiario.Items.Add(DOCUMENTO_CFeSAT);
      if Form1.sModeloECF = '65' then
        cbModeloDiario.ItemIndex := cbModeloDiario.Items.IndexOf(DOCUMENTO_NFCE);
      if Form1.sModeloECF = '59' then
        cbModeloDiario.ItemIndex := cbModeloDiario.Items.IndexOf(DOCUMENTO_CFeSAT);
    end;
    {Sandro Silva 2020-09-28 fim}
  end;

  if bDocumentoEmitidoPeriodo then
  begin
    DateTimePicker4.Date := Date;
    DateTimePicker5.Date := Date;
  end;

  Panel2.SendToBack; // Sandro Silva 2016-08-02
  PageControl1.SendToBack; // Sandro Silva 2016-08-02
  Label1.Width := DateTimePicker1.Width; // Label1.Parent.Width; // Sandro Silva 2017-10-23
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm7.Button1Click(Sender: TObject);
begin
  // 2015-07-08 Sandro Silva para poder controlar Close;
  if bVendaCPF then
  begin
    if CpfCgc(LimpaNumero(edCPFCNPJ.Text)) = False then
    begin
      ShowMessage('CPF/CNPJ inválido');
      Abort;
      Exit;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TForm7.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm7.MaskEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm7.DateTimePicker1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form1.sAjuda)));
end;

procedure TForm7.ComboBox1Change(Sender: TObject);
begin
  //
  Form1.IbDataSet99.Close;
  Form1.IbDataSet99.SelectSql.Clear;
  Form1.IbDataSet99.SelectSQL.Add('select SMALL from REDUCOES where SERIE='+QuotedStr(Alltrim(Form7.ComboBox1.Text))+'');
  Form1.IbDataSet99.Open;
  //
  //
  Form1.IbDataSet99.Close;
  //
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckBox2.Visible := False;
  MaskEdit1.Width := 32;
  MaskEdit2.Width := 32;
end;

procedure TForm7.FormCreate(Sender: TObject);
var
  iObj: Integer;
begin
  Form7.Width  := 300; // Sandro Silva 2021-07-12
  Form7.Height := 615; // Sandro Silva 2017-10-23
  AjustaResolucao(Form7);// Sandro Silva 2016-08-19
  AjustaResolucao(Form7.Frame_teclado1);// Sandro Silva 2016-08-19
  Form7.Width  := AjustaLargura(Form7.Width);// Sandro Silva 2016-08-19
  Form7.Height := AjustaAltura(Form7.Height);// Sandro Silva 2016-08-19
  if Form7.Top < 0 then
    Form7.Top := 0;

  for iObj := 0 to PageControl1.PageCount -1 do
    PageControl1.Pages[iObj].TabVisible := False;

  {Sandro Silva 2021-07-12 inicio}
  for iObj := 0 to Form7.ComponentCount -1 do
  begin
    if Form7.Components[iObj].ClassType = TCheckBox then
      TCheckBox(Form7.Components[iObj]).TabStop := False; // Não parar nos checkbox quando avançar com Enter nos campos
  end;
  {Sandro Silva 2021-07-12 fim}

  DateTimePicker3.Date := Date;

  Label1.Width    := DateTimePicker1.Width;

  Label3.Width    := DateTimePicker1.Width;
  Label4.Width    := Label3.Width;
  Label5.Width    := Label3.Width;
  CheckBox1.Width := Label3.Width;
  CheckBox2.Width := Label3.Width;

  checkMeioPagamento.Left  := DateTimePicker1.Left; // Sandro Silva 2017-12-15
  checkMeioPagamento.Font  := DateTimePicker1.Font; // Sandro Silva 2017-12-15
  checkMeioPagamento.Width := Label3.Width; // Sandro Silva 2017-12-15
  checkMeioPagamento.Top   := DateTimePicker2.BoundsRect.Bottom + AjustaAltura(5);

  Label7.Width := edCPFCNPJ.Width;
  Label6.Width := Label7.Width;

  Label9.Width := dtpVendasInicial.Width;
  Label9.Width := Label9.Width;
  Label9.Width := Label9.Width;
  Label9.Width := Label9.Width;
  Label9.Width := Label9.Width;

  Label15.Width := dtpEstoque.Width;

  Label16.Width := dtpMovimentoDia.Width;
  Label18.Width := Label16.Width;

  Label19.Width := dtpInicialDiario.Width;
  Label21.Width := Label19.Width;
  Label22.Width := Label19.Width;
  Label23.Width := Label19.Width;

  Form7.Label3.Top              := Form7.Label1.BoundsRect.Bottom + AjustaAltura(3);
  Form7.MaskEdit1.Top           := Form7.Label3.BoundsRect.Bottom + AjustaAltura(3);
  Form7.Label5.Top              := Form7.MaskEdit1.BoundsRect.Bottom + AjustaAltura(5);
  Form7.MaskEdit2.Top           := Form7.Label5.BoundsRect.Bottom + AjustaAltura(3);
  Form7.DateTimePicker1.Top     := Form7.Label3.BoundsRect.Bottom + AjustaAltura(3);
  Form7.DateTimePicker2.Top     := Form7.Label5.BoundsRect.Bottom + AjustaAltura(3);

  Form7Label1Height             := Label1.Height;
  Form7Label3Top                := Label3.Top;
  Form7Label5Top                := Label5.Top;
  Form7DateTimePicker1Top       := DateTimePicker1.Top;
  Form7DateTimePicker2Top       := DateTimePicker2.Top;

end;

procedure TForm7.FormShow(Sender: TObject);
begin
  Label1.AutoSize := True; // Sandro Silva 2016-09-29
  {Sandro Silva 2023-11-01 inicio}
  if bFechamentoDeCaixa then
  begin
    chklbCaixas.Clear;
    Form1.IBQuery65.Close;
    Form1.IBQuery65.SQL.Text :=
      'select distinct CAIXA ' +
      'from NFCE ' +
      'where coalesce(CAIXA, '''') <> '''' ' +
      'order by DATA DESC, CAIXA';
    Form1.IBQuery65.Open;
    while Form1.IBQuery65.Eof = False do
    begin
      chklbCaixas.Items.Add(Form1.IBQuery65.FieldByName('CAIXA').AsString);
      if chklbCaixas.Items.Strings[chklbCaixas.Items.Count -1] = Form1.sCaixa then
        chklbCaixas.Checked[chklbCaixas.Items.Count -1] := True;
      Form1.IBQuery65.Next;
    end;
    if chklbCaixas.Items.Count = 0 then
      chklbCaixas.Items.Add(Form1.sCaixa); // Se ainda não tem movimento na tabela NFCE adiciona o caixa atual na lista de caixas
  end;
  {Sandro Silva 2023-11-01 fim}

  {Dailon Parisotto (f-7567) 2023-11-16 Inicio}
  if bVendaPorDocumento then
  begin
    frameCampoCaixasRelVendaPorDoc.Caixa := Form1.sCaixa;
    frameCampoCaixasRelVendaPorDoc.CarregarCaixas(Form1.IBTransaction1);
  end;
  {Dailon Parisotto (f-7567) 2023-11-16 Fim}  
end;

procedure TForm7.edMovimentoDiaExit(Sender: TObject);
begin
  edMovimentoDia.Text := Right('000' + LimpaNumero(edMovimentoDia.Text), 3);
  if edMovimentoDia.Text = '000' then
    edMovimentoDia.Clear;
end;

procedure TForm7.edCaixaDiarioEnter(Sender: TObject);
begin
  edCaixaDiario.SelectAll;
end;

procedure TForm7.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Label1.Height        := Form7Label1Height;
  Label3.Top           := Form7Label3Top;
  Label5.Top           := Form7Label5Top;
  DateTimePicker1.Top  := Form7DateTimePicker1Top;
  DateTimePicker2.Top  := Form7DateTimePicker2Top;
end;

procedure TForm7.CheckBox3Click(Sender: TObject);
begin
  CheckBox3.Checked := True;
end;

procedure TForm7.TabSheet5Show(Sender: TObject);
begin
  chkMovimentoDiaHoraI.Top := dtpMovimentoHoraI.Top - chkMovimentoDiaHoraI.Height;
  chkMovimentoDiaHoraF.Top := dtpMovimentoHoraF.Top - chkMovimentoDiaHoraF.Height;
  chkMovimentoDiaHoraI.Left := dtpMovimentoHoraI.Left;
  chkMovimentoDiaHoraF.Left := dtpMovimentoHoraF.Left;
end;

procedure TForm7.chkMovimentoDiaHoraIClick(Sender: TObject);
begin
  Form7.chkMovimentoDiaHoraF.Checked := Form7.chkMovimentoDiaHoraI.Checked;
  dtpMovimentoHoraI.Enabled := Form7.chkMovimentoDiaHoraI.Checked;
  dtpMovimentoHoraF.Enabled := Form7.chkMovimentoDiaHoraI.Checked;
end;

procedure TForm7.chkMovimentoDiaHoraFClick(Sender: TObject);
begin
  Form7.chkMovimentoDiaHoraI.Checked := Form7.chkMovimentoDiaHoraF.Checked; // Sandro Silva 2018-11-30
  dtpMovimentoHoraI.Enabled := Form7.chkMovimentoDiaHoraI.Checked;
  dtpMovimentoHoraF.Enabled := Form7.chkMovimentoDiaHoraI.Checked;
end;

procedure TForm7.chkFechamentoDeCaixaHoraIClick(Sender: TObject);
begin
  Form7.chkFechamentoDeCaixaHoraF.Checked := Form7.chkFechamentoDeCaixaHoraI.Checked;
  dtpFechamentoDeCaixaHoraI.Enabled := Form7.chkFechamentoDeCaixaHoraI.Checked;
  dtpFechamentoDeCaixaHoraF.Enabled := Form7.chkFechamentoDeCaixaHoraI.Checked;
end;

procedure TForm7.TabSheet8Show(Sender: TObject);
begin
  chkFechamentoDeCaixaHoraF.Top := dtpFechamentoDeCaixaHoraI.Top - chkFechamentoDeCaixaHoraI.Height;
  chkFechamentoDeCaixaHoraF.Top := dtpFechamentoDeCaixaHoraF.Top - chkFechamentoDeCaixaHoraF.Height;
  chkFechamentoDeCaixaHoraI.Left := dtpFechamentoDeCaixaHoraI.Left;
  chkFechamentoDeCaixaHoraF.Left := dtpFechamentoDeCaixaHoraF.Left;

  chkCaixaFechamentoDeCaixa.Caption := StringReplace(ListaCaixasSelecionados(Form7.chklbCaixas), #39, '', [rfReplaceAll]);
  if chkCaixaFechamentoDeCaixa.Caption = '' then
    chkCaixaFechamentoDeCaixa.Caption := 'Todos';
  chkCaixaFechamentoDeCaixa.Caption := 'Caixas (' + chkCaixaFechamentoDeCaixa.Caption + '):'

end;

procedure TForm7.chklbCaixasClickCheck(Sender: TObject);
var
  sListaCaixas: String;
begin
  sListaCaixas := StringReplace(ListaCaixasSelecionados(Form7.chklbCaixas), #39, '', [rfReplaceAll]);
  if sListaCaixas = '' then
    sListaCaixas := 'Todos';
  chkCaixaFechamentoDeCaixa.Caption := 'Caixas (' + sListaCaixas + '):'
end;

procedure TForm7.chkCaixaFechamentoDeCaixaClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to chklbCaixas.Items.Count - 1 do
  begin
    chklbCaixas.Checked[i] := chkCaixaFechamentoDeCaixa.Checked;
  end;
  chkCaixaFechamentoDeCaixa.Caption := 'Caixas (Todos):'
end;

end.
