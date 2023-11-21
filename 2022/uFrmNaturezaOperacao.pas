unit uFrmNaturezaOperacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, SmallFunc,
  Dialogs, uFrmFichaPadrao, DB, ComCtrls, StdCtrls, Buttons, ExtCtrls, StrUtils, HtmlHelp,
  DBCtrls, Mask, SMALL_DBEdit, IBCustomDataSet, IBQuery, Grids, DBGrids,
  uframeCampo;

const TEXTO_NAO_MOVIMENTA_ESTOQUE          = '= Não movimenta o Estoque';
const TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS = '0 Usar o custo de compra nas notas';

type
  TFrmNaturezaOperacao = class(TFrmFichaPadrao)
    tbsNatureza: TTabSheet;
    tbsPisCofins: TTabSheet;
    Image7: TImage;
    __RR: TLabel;
    __AP: TLabel;
    __AM: TLabel;
    __AC: TLabel;
    __RO: TLabel;
    __PA: TLabel;
    __MT: TLabel;
    __MA: TLabel;
    __CE: TLabel;
    __RN: TLabel;
    __PB: TLabel;
    __PE: TLabel;
    __AL: TLabel;
    __SE: TLabel;
    __BA: TLabel;
    __PI: TLabel;
    __TO: TLabel;
    __DF: TLabel;
    __GO: TLabel;
    __MS: TLabel;
    __SP: TLabel;
    __MG: TLabel;
    __ES: TLabel;
    __RJ: TLabel;
    __PR: TLabel;
    __SC: TLabel;
    __RS: TLabel;
    Label100: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    dbeIcmCFOP: TSMALL_DBEdit;
    SMALL_DBEdit54: TSMALL_DBEdit;
    SMALL_DBEdit55: TSMALL_DBEdit;
    SMALL_DBEdit57: TSMALL_DBEdit;
    SMALL_DBEdit58: TSMALL_DBEdit;
    SMALL_DBEdit59: TSMALL_DBEdit;
    SMALL_DBEdit60: TSMALL_DBEdit;
    SMALL_DBEditX: TSMALL_DBEdit;
    SMALL_DBEdit44: TSMALL_DBEdit;
    SMALL_DBEdit47: TSMALL_DBEdit;
    DBCheckSobreIPI: TDBCheckBox;
    DBCheckSobreOutras: TDBCheckBox;
    DBCheckFRETESOBREIPI: TDBCheckBox;
    DBMemo4: TDBMemo;
    cbMovimentacaoEstoque: TComboBox;
    cbIntegracaoFinanceira: TComboBox;
    gbPisCofinsSaida: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Label49: TLabel;
    lbBCPISCOFINS: TLabel;
    ComboBox7: TComboBox;
    dbepPisSaida: TSMALL_DBEdit;
    dbepCofinsSaida: TSMALL_DBEdit;
    dbeIcmBCPISCOFINS: TSMALL_DBEdit;
    fraPlanoContas: TfFrameCampo;
    procedure DBMemo4Enter(Sender: TObject);
    procedure DBMemo4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo4KeyPress(Sender: TObject; var Key: Char);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure cbIntegracaoFinanceiraExit(Sender: TObject);
    procedure cbMovimentacaoEstoqueExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure __RRClick(Sender: TObject);
    procedure tbsNaturezaShow(Sender: TObject);
    procedure SMALL_DBEditXExit(Sender: TObject);
    procedure dbeIcmCFOPExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbsPisCofinsEnter(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure tbsNaturezaEnter(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaObjComValorDoBanco;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmNaturezaOperacao: TFrmNaturezaOperacao;

  bProximo : Boolean;

implementation

uses Unit7, uDialogs;

{$R *.dfm}


procedure GravaEscolha;
begin
  try
    {Sandro Silva 2023-06-28 inicio}
    // Contas a receber
    if Form7.sModulo = 'ICM' then
    begin
      Form7.ibDataSet14.Edit;

      {
      if (Form10.dBGrid3.Visible) and (Form10.dBGrid3.DataSource.Name = 'DSConsulta') then
      begin
        Form7.ibDataSet14CONTA.AsString := Form7.ibqConsulta.FieldByName('NOME').AsString;
        Form10.dBGrid3.Visible := False;
      end;
      }
    end;
    {Sandro Silva 2023-06-28 fim}
  except
  end;
end;

procedure TFrmNaturezaOperacao.DBMemo4Enter(Sender: TObject);
begin
  DBMemo4.MaxLength := Form7.ibDataSet14OBS.Size;
  
  SendMessage(DBMemo4.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(DBMemo4.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  DBMemo4.SelStart := Length(DBMemo4.Text); //move o cursor pra o final da ultima linha
  DBMemo4.SetFocus;
end;

procedure TFrmNaturezaOperacao.DBMemo4KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end
    else
      bProximo := True;
  end
  else
    bProximo := False;
end;

procedure TFrmNaturezaOperacao.DBMemo4KeyPress(Sender: TObject;
  var Key: Char);
begin
  {Sandro Silva 2023-06-29 inicio}
  if Length(DBMemo4.Text) >= Form7.ibDataSet14OBS.Size then
  begin
    if not (Ord(Key) in [VK_BACK, VK_RETURN, 27..43]) then
      Key := #0;
  end;
  {Sandro Silva 2023-06-29 fim}
end;


procedure TFrmNaturezaOperacao.AtualizaObjComValorDoBanco;
var
  I : integer;
begin
  try
    if FrmNaturezaOperacao = nil then
      Exit;

    if not FrmNaturezaOperacao.Active then
      Exit;

    if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
      Form7.ibDataSet14.Edit;

    if Form7.ibDataSet14SOBREIPI.AsString <> 'S' then
      Form7.ibDataSet14SOBREIPI.AsString := 'N';
    if Form7.ibDataSet14SOBREOUTRAS.AsString <> 'S' then
      Form7.ibDataSet14SOBREOUTRAS.AsString := 'N';
    if Form7.ibDataSet14FRETESOBREIPI.AsString <> 'S' then
      Form7.ibDataSet14FRETESOBREIPI.AsString := 'N';

    cbIntegracaoFinanceira.ItemIndex := 0;
    cbMovimentacaoEstoque.ItemIndex  := 0;
    ComboBox7.ItemIndex := -1;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'CAIXA') then
      cbIntegracaoFinanceira.ItemIndex := 1;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'PAGAR') then
      cbIntegracaoFinanceira.ItemIndex := 2;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), 'RECEBER') then
      cbIntegracaoFinanceira.ItemIndex := 3;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), '=') then
      cbMovimentacaoEstoque.ItemIndex := 1;

    if AnsiContainsText(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.AsString), '0') then
      cbMovimentacaoEstoque.ItemIndex := 2;


    if AllTrim(Form7.ibDataSet14CSTPISCOFINS.AsString)<>'' then
    begin
      for I := 0 to ComboBox7.Items.Count -1 do
      begin
        if Copy(ComboBox7.Items[I], 1, 2) = UpperCase(AllTrim(Form7.ibDataSet14CSTPISCOFINS.AsString)) then
        begin
          ComboBox7.ItemIndex := I;
        end;
      end;
    end;

    //Mapa
    __RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
    __AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
    __AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
    __PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
    __MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
    __AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
    __RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
    __MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
    __TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
    __CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
    __RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
    __PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
    __PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
    __PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
    __AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
    __SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
    __BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
    __GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
    __DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
    __MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
    __ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
    __MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
    __SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
    __RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
    __PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
    __SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
    __RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
  
    __RR.font.size := 8;
    __AP.font.size := 8;
    __AM.font.size := 8;
    __PA.font.size := 8;
    __MA.font.size := 8;
    __AC.font.size := 8;
    __RO.font.size := 8;
    __MT.font.size := 8;
    __TO.font.size := 8;
    __CE.font.size := 8;
    __RN.font.size := 8;
    __PI.font.size := 8;
    __PB.font.size := 8;
    __PE.font.size := 8;
    __AL.font.size := 8;
    __SE.font.size := 8;
    __BA.font.size := 8;
    __GO.font.size := 8;
    __DF.font.size := 8;
    __MG.font.size := 8;
    __ES.font.size := 8;
    __MS.font.size := 8;
    __SP.font.size := 8;
    __RJ.font.size := 8;
    __PR.font.size := 8;
    __SC.font.size := 8;
    __RS.font.size := 8;

    if Form7.ibDataSet13ESTADO.AsString = 'RR' then __RR.Font.Color := clRed else __RR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AP' then __AP.Font.Color := clRed else __AP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AM' then __AM.Font.Color := clRed else __AM.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PA' then __PA.Font.Color := clRed else __PA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MA' then __MA.Font.Color := clRed else __MA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AC' then __AC.Font.Color := clRed else __AC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RO' then __RO.Font.Color := clRed else __RO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MT' then __MT.Font.Color := clRed else __MT.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'TO' then __TO.Font.Color := clRed else __TO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'CE' then __CE.Font.Color := clRed else __CE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RN' then __RN.Font.Color := clRed else __RN.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PI' then __PI.Font.Color := clRed else __PI.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PB' then __PB.Font.Color := clRed else __PB.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PE' then __PE.Font.Color := clRed else __PE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'AL' then __AL.Font.Color := clRed else __AL.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SE' then __SE.Font.Color := clRed else __SE.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'BA' then __BA.Font.Color := clRed else __BA.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'GO' then __GO.Font.Color := clRed else __GO.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'DF' then __DF.Font.Color := clRed else __DF.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MG' then __MG.Font.Color := clRed else __MG.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'ES' then __ES.Font.Color := clRed else __ES.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'MS' then __MS.Font.Color := clRed else __MS.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then __SP.Font.Color := clRed else __SP.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RJ' then __RJ.Font.Color := clRed else __RJ.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'PR' then __PR.Font.Color := clRed else __PR.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then __SC.Font.Color := clRed else __SC.Font.Color := clSilver;
    if Form7.ibDataSet13ESTADO.AsString = 'RS' then __RS.Font.Color := clRed else __RS.Font.Color := clSilver;
  except
  end;
end;

procedure TFrmNaturezaOperacao.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  fraPlanoContas.TipoDePesquisa  := tpSelect;
  fraPlanoContas.GravarSomenteTextoEncontrato := False;
  fraPlanoContas.CampoCodigo     := Form7.ibDataSet14CONTA;
  fraPlanoContas.CampoCodigoPesquisa := 'NOME';
  fraPlanoContas.sCampoDescricao := 'NOME';
  fraPlanoContas.sTabela         := 'CONTAS';
  fraPlanoContas.CampoAuxExiber  := ',CONTA';
  fraPlanoContas.CarregaDescricao;

  AtualizaObjComValorDoBanco;
end;

procedure TFrmNaturezaOperacao.cbIntegracaoFinanceiraExit(Sender: TObject);
begin
  if FrmNaturezaOperacao.Active then
  begin
    Form7.ibDataSet14.Edit;
    if cbIntegracaoFinanceira.Text = '' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
    end
    else if cbIntegracaoFinanceira.Text = 'Caixa' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Caixa';
    end
    else if cbIntegracaoFinanceira.Text = 'Pagar' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Pagar';
    end
    else if cbIntegracaoFinanceira.Text = 'Receber' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Receber', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Pagar', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, 'Caixa', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + 'Receber';
    end;
  end;
end;

procedure TFrmNaturezaOperacao.cbMovimentacaoEstoqueExit(Sender: TObject);
begin
  if FrmNaturezaOperacao.Active then
  begin
    Form7.ibDataSet14.Edit;
    if cbMovimentacaoEstoque.Text = '' then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
    end else if cbMovimentacaoEstoque.Text = TEXTO_NAO_MOVIMENTA_ESTOQUE then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + '=';
    end else if cbMovimentacaoEstoque.Text = TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS then
    begin
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '=', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := StringReplace(Form7.ibDataSet14INTEGRACAO.AsString, '0', '', [rfReplaceAll]);
      Form7.ibDataSet14INTEGRACAO.AsString := Form7.ibDataSet14INTEGRACAO.AsString + '0';
    end;
  end;
end;

procedure TFrmNaturezaOperacao.FormCreate(Sender: TObject);
begin
  inherited;

  cbMovimentacaoEstoque.Items.Clear;
  cbMovimentacaoEstoque.Items.Add('');
  cbMovimentacaoEstoque.Items.Add(TEXTO_NAO_MOVIMENTA_ESTOQUE);
  cbMovimentacaoEstoque.Items.Add(TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS);
end;

procedure TFrmNaturezaOperacao.__RRClick(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    SMALL_DBEditX.DataField := Copy(Caption,1,2)+'_';
    SMALL_DBEditX.Top       := Top;
    SMALL_DBEditX.Left      := Left;
    SMALL_DBEditX.Visible   := True;
    SMALL_DBEditX.SetFocus;
    SMALL_DBEditX.SetFocus;
  end;
end;

procedure TFrmNaturezaOperacao.tbsNaturezaShow(Sender: TObject);
begin
  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;
end;

procedure TFrmNaturezaOperacao.SMALL_DBEditXExit(Sender: TObject);
begin
  SMALL_DBEditX.Visible   := False;

  __RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
  __AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
  __AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
  __PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
  __MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
  __AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
  __RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
  __MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
  __TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
  __CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
  __RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
  __PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
  __PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
  __PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
  __AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
  __SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
  __BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
  __GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
  __DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
  __MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
  __ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
  __MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
  __SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
  __RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
  __PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
  __SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
  __RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
end;

procedure TFrmNaturezaOperacao.dbeIcmCFOPExit(Sender: TObject);
begin
  with Sender as TSMALL_DBEdit do
  begin
    DataSource.DataSet.FieldByName(DataField).AsString := Trim(TSMALL_DBEdit(Sender).Text);
  end;
end;


procedure TFrmNaturezaOperacao.FormActivate(Sender: TObject);
begin
  AtualizaObjComValorDoBanco;
end;


procedure TFrmNaturezaOperacao.SetaStatusUso;
begin
  inherited;
  //
end;

function TFrmNaturezaOperacao.GetPaginaAjuda: string;
begin
  Result := 'config_icms_iss.htm';
end;

procedure TFrmNaturezaOperacao.FormShow(Sender: TObject);
begin
  inherited;

  pgcFicha.TabIndex := 0;

  if dbeIcmCFOP.CanFocus then
    dbeIcmCFOP.SetFocus;
end;

procedure TFrmNaturezaOperacao.tbsPisCofinsEnter(Sender: TObject);
begin
  if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
    Form7.ibDataSet14.Edit;
end;

procedure TFrmNaturezaOperacao.ComboBox7Change(Sender: TObject);
begin
  Form7.ibDataSet14CSTPISCOFINS.AsString := Copy(ComboBox7.Items[ComboBox7.ItemIndex]+'  ',1,2);

  if Copy(ComboBox7.Items[ComboBox7.ItemIndex]+'  ',1,2) = '03' then
  begin
    Label43.Caption := 'R$ PIS:';
    Label49.Caption := 'R$ COFINS:';
  end else
  begin
    Label43.Caption := '% PIS:';
    Label49.Caption := '% COFINS:';
  end;
end;

procedure TFrmNaturezaOperacao.tbsNaturezaEnter(Sender: TObject);
begin
  if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
    Form7.ibDataSet14.Edit;
end;

procedure TFrmNaturezaOperacao.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;
end;

end.
