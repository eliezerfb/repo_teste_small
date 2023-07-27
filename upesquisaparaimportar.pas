unit upesquisaparaimportar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  Grids, DBGrids, DB, IBCustomDataSet, IBQuery
  , StrUtils
  , ufuncoesfrente
  ;

type
  TFPesquisaParaImportar = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    edPesquisa: TEdit;
    Button1: TBitBtn;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    IBQPESQUISA: TIBQuery;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure DateTimePicker1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IBQPESQUISAAfterOpen(DataSet: TDataSet);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    FTipoPesquisa: TTipoPesquisa;
    FIdSelecionado: String;
    procedure SelecionaOrcamento;
    procedure SelecionaPesquisa;
    procedure SelecionaOS;
    procedure SelecionaGerencial;
    { Private declarations }
  public
    { Public declarations }
    property TipoPesquisa: TTipoPesquisa read FTipoPesquisa write FTipoPesquisa;
    property IdSelecionado: String read FIdSelecionado write FIdSelecionado;
  end;

var
  FPesquisaParaImportar: TFPesquisaParaImportar;

implementation

uses
  fiscal
  , SmallFunc
//  , ufuncoesfrente
  , uajustaresolucao
  ;

{$R *.dfm}

procedure TFPesquisaParaImportar.Button1Click(Sender: TObject);
begin
  FIdSelecionado := edPesquisa.Text;
  if FTipoPesquisa = tpPesquisaOrca then
    FIdSelecionado := StrZero(StrToInt64Def(Limpanumero(FIdSelecionado), 0), 10, 0);
  if FTipoPesquisa = tpPesquisaOS then
    FIdSelecionado := StrZero(StrToInt64Def(Limpanumero(FIdSelecionado), 0), 10, 0);
  {Sandro Silva 2023-07-13 inicio}
  if FTipoPesquisa = tpPesquisaGerencial then
    FIdSelecionado := StrZero(StrToInt64Def(Limpanumero(FIdSelecionado), 0), 10, 0);
  {Sandro Silva 2023-07-13 fim}
  if FIdSelecionado = '' then
    ModalResult := mrCancel
  else
    ModalResult := mrOk;
end;

procedure TFPesquisaParaImportar.Image6Click(Sender: TObject);
begin
  FPesquisaParaImportar.Button1Click(Sender);
end;

procedure TFPesquisaParaImportar.FormActivate(Sender: TObject);
begin

  FPesquisaParaImportar.Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  FPesquisaParaImportar.Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;

  FPesquisaParaImportar.Frame_teclado1.Led_ECF.Picture := Form1.Frame_teclado1.Led_ECF.Picture;
  FPesquisaParaImportar.Frame_teclado1.Led_ECF.Hint    := Form1.Frame_teclado1.Led_ECF.Hint;

  FPesquisaParaImportar.Frame_teclado1.Led_REDE.Picture := Form1.Frame_teclado1.Led_REDE.Picture;
  FPesquisaParaImportar.Frame_teclado1.Led_REDE.Hint    := Form1.Frame_teclado1.Led_REDE.Hint;

  edPesquisa.Visible := True;
  ActiveControl := edPesquisa; // Sandro Silva 2018-10-24
  if edPesquisa.CanFocus then
  begin
    edPesquisa.SetFocus;
  end;
  
end;

procedure TFPesquisaParaImportar.edPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if (LimpaNumero(edPesquisa.Text) <> edPesquisa.Text) or (Trim(edPesquisa.Text) = '') then
    begin
      SelecionaPesquisa;
    end
    else
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

procedure TFPesquisaParaImportar.FormCreate(Sender: TObject);
begin
  // Artifício para o botão OK nunca ficar com foco quando o form for aberto. Evitar confirmação OK quando ler código de barras Sandro Silva 2018-10-24
  BitBtn1.Top := -10000;

  FPesquisaParaImportar.Top    := Form1.Panel1.Top;
  FPesquisaParaImportar.Left   := Form1.Panel1.Left;
  FPesquisaParaImportar.Height := Form1.Panel1.Height;
  FPesquisaParaImportar.Width  := Form1.Panel1.Width;

  AjustaResolucao(FPesquisaParaImportar);
  AjustaResolucao(FPesquisaParaImportar.Frame_teclado1);
  Form1.Image7Click(Sender); // Sandro Silva 2016-08-18

  DateTimePicker1.Width  := DBGrid1.Width;

end;

procedure TFPesquisaParaImportar.FormShow(Sender: TObject);
begin
  DateTimePicker1.Date := Date;
  DateTimePicker1.Visible := True;
  edPesquisa.Text := '';

  if FTipoPesquisa = tpPesquisaORCA then
  begin
    Label1.Caption := 'Importar orçamento...';
    Label2.Caption := 'Número do orçamento ou Nome do cliente:';

    SelecionaOrcamento;
  end;
  if FTipoPesquisa = tpPesquisaOS then
  begin
    Label1.Caption := 'Importar OS';
    Label2.Caption := 'Número da OS ou Nome do cliente:';

    SelecionaOS;
  end;

  {Sandro Silva 2023-07-13 inicio}
  if FTipoPesquisa = tpPesquisaGerencial then
  begin
    Label1.Caption := 'Importar Gerencial';
    Label2.Caption := 'Número do Gerencial ou Nome do cliente:';

    SelecionaGerencial;
  end;
  {Sandro Silva 2023-07-13 fim}
end;

procedure TFPesquisaParaImportar.BitBtn2Click(Sender: TObject);
begin
  FIdSelecionado := '';
  Close;
end;

procedure TFPesquisaParaImportar.SelecionaOrcamento;
var
  sCondicao: String;
begin
  sCondicao := '';
  if (LimpaNumero(edPesquisa.Text) <> edPesquisa.Text) then
  begin
    sCondicao := ' and CLIFOR containing ' + QuotedStr(edPesquisa.Text);
  end;
  IBQPESQUISA.Close;
  IBQPESQUISA.SQL.Text :=
    'select PEDIDO as "Número", DATA as "Data", CLIFOR as "Cliente", VENDEDOR as "Vendedor", ' +
    'sum(case when DESCRICAO <> ''Desconto'' then TOTAL else 0 end ) as "Total bruto", ' +
    'sum ( case when DESCRICAO  = ''Desconto'' then TOTAL else 0 end ) as "Desconto", ' +
    'max(coalesce(NUMERONF, '''')) as "Doc. Fiscal" ' + // Sandro Silva 2021-08-17 'NUMERONF as "Doc. Fiscal" ' +
    'from ORCAMENT ' +
    'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date - 30)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date)) + ' ' + // Últimos 30 dias da data
    sCondicao +
    ' group by PEDIDO, DATA, CLIFOR, VENDEDOR ' + // Sandro Silva 2021-08-17 ' group by PEDIDO, DATA, CLIFOR, VENDEDOR, NUMERONF ' +
    'order by DATA desc, PEDIDO desc';
  IBQPESQUISA.Open;
end;

procedure TFPesquisaParaImportar.SelecionaOS;
var
  sCondicao: String;
begin
  sCondicao := '';
  if (LimpaNumero(edPesquisa.Text) <> edPesquisa.Text) then
  begin
    sCondicao := ' and CLIENTE containing ' + QuotedStr(edPesquisa.Text);
  end;
  IBQPESQUISA.Close;
  IBQPESQUISA.SQL.Text :=
    'select NUMERO as "Número", DATA as "Data", CLIENTE as "Cliente", TECNICO as "Técnico", ' +
    'TOTAL_OS as "Total bruto", ' +
    'DESCONTO as "Desconto", ' +
    'NF as "Doc. Fiscal" ' +
    'from OS ' +
    'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date - 30)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date)) + ' ' + // Últimos 30 dias da data
    ' and (SITUACAO = ''Aberta'' or SITUACAO = ''Agendada'') ' +
    sCondicao +
    //' group by PEDIDO, DATA, CLIFOR, VENDEDOR, NUMERONF ' +
    'order by DATA desc, NUMERO desc';
  IBQPESQUISA.Open;
end;

procedure TFPesquisaParaImportar.SelecionaPesquisa;
begin
  if FTipoPesquisa = tpPesquisaORCA then
  begin
    SelecionaOrcamento;
  end;
  if FTipoPesquisa = tpPesquisaOS then
  begin
    SelecionaOS;
  end;
  {Sandro Silva 2023-07-13 inicio}
  if FTipoPesquisa = tpPesquisaGerencial then
  begin
    SelecionaGerencial;
  end;
  {Sandro Silva 2023-07-13 fim}
end;

procedure TFPesquisaParaImportar.DateTimePicker1Change(Sender: TObject);
begin
  SelecionaPesquisa;
end;

procedure TFPesquisaParaImportar.DateTimePicker1Click(Sender: TObject);
begin
  Keybd_Event(VK_MENU,0,0,0);
  Keybd_Event(VK_DOWN,0,0,0);
  Keybd_Event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
  Keybd_Event(VK_MENU,0,KEYEVENTF_KEYUP,0);
end;

procedure TFPesquisaParaImportar.DBGrid1DblClick(Sender: TObject);
begin
  if FTipoPesquisa = tpPesquisaORCA then
    edPesquisa.Text := DBGrid1.DataSource.DataSet.FieldByName('Número').AsString;
  if FTipoPesquisa = tpPesquisaOS then
    edPesquisa.Text := DBGrid1.DataSource.DataSet.FieldByName('Número').AsString;
  {Sandro Silva 2023-07-13 inicio}
  if FTipoPesquisa = tpPesquisaGerencial then
    edPesquisa.Text := DBGrid1.DataSource.DataSet.FieldByName('Número').AsString;
  {Sandro Silva 2023-07-13 fim}
  Button1Click(Sender);
end;

procedure TFPesquisaParaImportar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  edPesquisa.Text := '';
end;

procedure TFPesquisaParaImportar.IBQPESQUISAAfterOpen(DataSet: TDataSet);
begin
  if FTipoPesquisa = tpPesquisaORCA then
  begin
    DataSet.FieldByName('Cliente').DisplayWidth  := AjustaLargura(40);
    DataSet.FieldByName('Vendedor').DisplayWidth := AjustaLargura(18);
  end;

  if FTipoPesquisa = tpPesquisaOS then
  begin
    DataSet.FieldByName('Cliente').DisplayWidth := AjustaLargura(40);
    DataSet.FieldByName('Técnico').DisplayWidth := AjustaLargura(18);
  end;
  {Sandro Silva 2023-07-13 inicio}
  if FTipoPesquisa = tpPesquisaGerencial then
  begin
    DataSet.FieldByName('Cliente').DisplayWidth := AjustaLargura(40);
    DataSet.FieldByName('Cliente').DisplayWidth := AjustaLargura(18);
  end;
  {Sandro Silva 2023-07-13 fim}
end;

procedure TFPesquisaParaImportar.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  yCalc, xCalc: integer;
  sTexto: String;
begin

  (Sender As TDBGrid).Canvas.Font.Size  := Form1.LabelESC2.Font.Size;
  (Sender As TDBGrid).Canvas.Font.Name  := Form1.LabelESC2.Font.Name;

  if Column.Field <> nil then
  begin
    sTexto := Column.Field.AsString;
    xCalc  := Rect.Left + 2;

    (Sender As TDBGrid).Canvas.Font.Color := clBlack;

    if Column.Field.AsString <> '' then
    begin

      if gdSelected in State then // Se a coluna estiver selecionada deixa a fonte branca para ter contraste
        (Sender As TDBGrid).Canvas.Font.Color := clWhite
      else
      begin
        if Column.Field.DataSet.FieldByName('Doc. Fiscal').AsString <> '' then
          (Sender As TDBGrid).Canvas.Font.Color := COR_AZUL // Sandro Silva 2021-08-17
      end;

      if (Column.Field.DataType in [ftFloat, ftBCD, ftFMTBcd]) then
      begin
        sTexto := FormatFloat('0.00', Column.Field.AsFloat);

        xCalc := Rect.Right - (Sender As TDBGrid).Canvas.TextWidth(sTexto) - 2; // Alinha a direita
      end;

    end;

    // Cor de fundo para célula depende se está selecionada
    if gdSelected in State then
      (Sender As TDBGrid).Canvas.Brush.Color := clHighlight
    else
      (Sender As TDBGrid).Canvas.Brush.Color := (Sender As TDBGrid).Color;

    // Preenche com a cor de fundo
    (Sender As TDBGrid).Canvas.FillRect(Rect);

    // Calcula posição para centralizar o sTexto na vertical
    yCalc := (Sender As TDBGrid).Canvas.TextHeight(sTexto);
    yCalc := (Rect.Top + (Rect.Bottom - Rect.Top - yCalc) div 2);// + 2;

    (Sender As TDBGrid).Canvas.TextRect(Rect, xCalc, yCalc, sTexto);

  end; //if Column.Field <> nil then

end;

procedure TFPesquisaParaImportar.SelecionaGerencial;
var
  sCondicao: String;
begin
  sCondicao := '';
  if (LimpaNumero(edPesquisa.Text) <> edPesquisa.Text) then
  begin
    if Length(LimpaNumero(edPesquisa.Text)) in [11, 14] then
      sCondicao := ' and A.CNPJ = ' + QuotedStr(FormataCpfCgc(LimpaNumero(edPesquisa.Text)))
    else
      sCondicao := ' and A.CLIFOR containing ' + QuotedStr(edPesquisa.Text);
  end;
  IBQPESQUISA.Close;
  IBQPESQUISA.SQL.Text :=
    'select N.NUMERONF as "Número", N.DATA as "Data" ' +
    ', coalesce(A.CLIFOR, '''') as "Cliente" ' +
    ', N.TOTAL as "Total" ' +
    ', max(coalesce(A.VALORICM, '''')) as "Doc. Fiscal" ' +
    'from NFCE N ' +
    'join ALTERACA A on A.PEDIDO = N.NUMERONF and A.CAIXA = N.CAIXA ' +
    'where N.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date - 30)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', DateTimePicker1.Date)) + ' ' + // Últimos 30 dias da data
    ' and N.MODELO = ''99'' ' +
    ' and N.STATUS = ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' ' +
    sCondicao +
    'group by N.NUMERONF, N.DATA, coalesce(A.CLIFOR, ''''), N.TOTAL ' +
    'order by N.DATA desc, N.NUMERONF desc';
  IBQPESQUISA.Open;

end;

procedure TFPesquisaParaImportar.DBGrid1CellClick(Column: TColumn);
begin
  if Trim(edPesquisa.Text) = '' then
    edPesquisa.Text := DBGrid1.DataSource.DataSet.FieldByName('Número').AsString;
end;

end.
