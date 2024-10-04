unit uFrmNaturezaOperacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, smallfunc_xe,
  Dialogs, uFrmFichaPadrao, DB, ComCtrls, StdCtrls, Buttons, ExtCtrls, StrUtils
  ,
  DBCtrls, Mask, SMALL_DBEdit, IBCustomDataSet, IBQuery, Grids, DBGrids,
  uframeCampo, Vcl.Imaging.pngimage;

const TEXTO_NAO_MOVIMENTA_ESTOQUE          = '= Não movimenta o Estoque';
const TEXTO_USAR_CUSTO_DE_COMPRA_NAS_NOTAS = '0 Usar o custo de compra nas notas';

type
  TFrmNaturezaOperacao = class(TFrmFichaPadrao)
    tbsNatureza: TTabSheet;
    tbsPisCofins: TTabSheet;
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
    SMALL_DBEdit44: TSMALL_DBEdit;
    SMALL_DBEdit47: TSMALL_DBEdit;
    DBCheckSobreIPI: TDBCheckBox;
    DBCheckSobreOutras: TDBCheckBox;
    DBCheckFRETESOBREIPI: TDBCheckBox;
    memObservacao: TDBMemo;
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
    Label1: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    GroupBox1: TGroupBox;
    chkPisCofinsSobLucro: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    chkRefenciarNota: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    pnlMapaICMS: TPanel;
    Image4: TImage;
    Label52: TLabel;
    _AP: TLabel;
    _RR: TLabel;
    _AM: TLabel;
    _AC: TLabel;
    _RO: TLabel;
    _PA: TLabel;
    _MA: TLabel;
    _CE: TLabel;
    _RN: TLabel;
    _PB: TLabel;
    _PE: TLabel;
    _AL: TLabel;
    _SE: TLabel;
    _PI: TLabel;
    _TO: TLabel;
    _MT: TLabel;
    _DF: TLabel;
    _BA: TLabel;
    _GO: TLabel;
    _MG: TLabel;
    _ES: TLabel;
    _RJ: TLabel;
    _SP: TLabel;
    _MS: TLabel;
    _PR: TLabel;
    _SC: TLabel;
    _RS: TLabel;
    SMALL_DBEditX: TSMALL_DBEdit;
    DBCheckBox3: TDBCheckBox;
    procedure memObservacaoEnter(Sender: TObject);
    procedure memObservacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memObservacaoKeyPress(Sender: TObject; var Key: Char);
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
    procedure DBCheckSobreClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblAnteriorClick(Sender: TObject);
    procedure lblProximoClick(Sender: TObject);
    procedure lblProcurarClick(Sender: TObject);
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
    end;
    {Sandro Silva 2023-06-28 fim}
  except
  end;
end;

procedure TFrmNaturezaOperacao.memObservacaoEnter(Sender: TObject);
begin
  memObservacao.MaxLength := Form7.ibDataSet14OBS.Size;
  
  SendMessage(memObservacao.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(memObservacao.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  memObservacao.SelStart := Length(memObservacao.Text); //move o cursor pra o final da ultima linha
  memObservacao.SetFocus;
end;

procedure TFrmNaturezaOperacao.memObservacaoKeyDown(Sender: TObject;
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

procedure TFrmNaturezaOperacao.memObservacaoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Length(memObservacao.Text) >= Form7.ibDataSet14OBS.Size then
  begin
    if not (Ord(Key) in [VK_BACK, VK_RETURN, 27..43]) then
      Key := #0;
  end;
end;


procedure TFrmNaturezaOperacao.AtualizaObjComValorDoBanco;
var
  I : integer;
begin
  try
    fraPlanoContas.TipoDePesquisa  := tpSelect;
    fraPlanoContas.GravarSomenteTextoEncontrato := False;
    fraPlanoContas.CampoCodigo     := Form7.ibDataSet14CONTA;
    fraPlanoContas.CampoCodigoPesquisa := 'NOME';
    fraPlanoContas.sCampoDescricao := 'NOME';
    fraPlanoContas.sTabela         := 'CONTAS';
    fraPlanoContas.CampoAuxExiber  := ',CONTA';
    fraPlanoContas.CarregaDescricao;
  except
  end;

  try
    if FrmNaturezaOperacao = nil then
      Exit;

    if not FrmNaturezaOperacao.Active then
      Exit;


    if (Form7.ibDataSet14.State <> dsInactive) then
    begin
      if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
        Form7.ibDataSet14.Edit;

      if Form7.ibDataSet14SOBREIPI.AsString <> 'S' then
        Form7.ibDataSet14SOBREIPI.AsString := 'N';
      if Form7.ibDataSet14SOBREOUTRAS.AsString <> 'S' then
        Form7.ibDataSet14SOBREOUTRAS.AsString := 'N';
      if Form7.ibDataSet14FRETESOBREIPI.AsString <> 'S' then
        Form7.ibDataSet14FRETESOBREIPI.AsString := 'N';
      if Form7.ibDataSet14IPISOBREOUTRA.AsString <> 'S' then
        Form7.ibDataSet14IPISOBREOUTRA.AsString := 'N';

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
	end;

    //Mapa
    _RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
    _AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
    _AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
    _PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
    _MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
    _AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
    _RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
    _MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
    _TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
    _CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
    _RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
    _PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
    _PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
    _PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
    _AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
    _SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
    _BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
    _GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
    _DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
    _MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
    _ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
    _MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
    _SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
    _RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
    _PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
    _SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
    _RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';

    _RR.font.size := 8;
    _AP.font.size := 8;
    _AM.font.size := 8;
    _PA.font.size := 8;
    _MA.font.size := 8;
    _AC.font.size := 8;
    _RO.font.size := 8;
    _MT.font.size := 8;
    _TO.font.size := 8;
    _CE.font.size := 8;
    _RN.font.size := 8;
    _PI.font.size := 8;
    _PB.font.size := 8;
    _PE.font.size := 8;
    _AL.font.size := 8;
    _SE.font.size := 8;
    _BA.font.size := 8;
    _GO.font.size := 8;
    _DF.font.size := 8;
    _MG.font.size := 8;
    _ES.font.size := 8;
    _MS.font.size := 8;
    _SP.font.size := 8;
    _RJ.font.size := 8;
    _PR.font.size := 8;
    _SC.font.size := 8;
    _RS.font.size := 8;

    if Form7.ibDataSet13ESTADO.AsString = 'RR' then _RR.Font.Color := clRed else _RR.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'AP' then _AP.Font.Color := clRed else _AP.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'AM' then _AM.Font.Color := clRed else _AM.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'PA' then _PA.Font.Color := clRed else _PA.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'MA' then _MA.Font.Color := clRed else _MA.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'AC' then _AC.Font.Color := clRed else _AC.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'RO' then _RO.Font.Color := clRed else _RO.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'MT' then _MT.Font.Color := clRed else _MT.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'TO' then _TO.Font.Color := clRed else _TO.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'CE' then _CE.Font.Color := clRed else _CE.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'RN' then _RN.Font.Color := clRed else _RN.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'PI' then _PI.Font.Color := clRed else _PI.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'PB' then _PB.Font.Color := clRed else _PB.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'PE' then _PE.Font.Color := clRed else _PE.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'AL' then _AL.Font.Color := clRed else _AL.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'SE' then _SE.Font.Color := clRed else _SE.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'BA' then _BA.Font.Color := clRed else _BA.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'GO' then _GO.Font.Color := clRed else _GO.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'DF' then _DF.Font.Color := clRed else _DF.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'MG' then _MG.Font.Color := clRed else _MG.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'ES' then _ES.Font.Color := clRed else _ES.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'MS' then _MS.Font.Color := clRed else _MS.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then _SP.Font.Color := clRed else _SP.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'RJ' then _RJ.Font.Color := clRed else _RJ.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'PR' then _PR.Font.Color := clRed else _PR.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then _SC.Font.Color := clRed else _SC.Font.Color := clBlack;
    if Form7.ibDataSet13ESTADO.AsString = 'RS' then _RS.Font.Color := clRed else _RS.Font.Color := clBlack;

    if Form7.ibDataSet13ESTADO.AsString = 'RR' then _RR.Font.Style := [fsBold] else _RR.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'AP' then _AP.Font.Style := [fsBold] else _AP.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'AM' then _AM.Font.Style := [fsBold] else _AM.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'PA' then _PA.Font.Style := [fsBold] else _PA.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'MA' then _MA.Font.Style := [fsBold] else _MA.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'AC' then _AC.Font.Style := [fsBold] else _AC.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'RO' then _RO.Font.Style := [fsBold] else _RO.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'MT' then _MT.Font.Style := [fsBold] else _MT.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'TO' then _TO.Font.Style := [fsBold] else _TO.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'CE' then _CE.Font.Style := [fsBold] else _CE.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'RN' then _RN.Font.Style := [fsBold] else _RN.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'PI' then _PI.Font.Style := [fsBold] else _PI.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'PB' then _PB.Font.Style := [fsBold] else _PB.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'PE' then _PE.Font.Style := [fsBold] else _PE.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'AL' then _AL.Font.Style := [fsBold] else _AL.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'SE' then _SE.Font.Style := [fsBold] else _SE.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'BA' then _BA.Font.Style := [fsBold] else _BA.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'GO' then _GO.Font.Style := [fsBold] else _GO.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'DF' then _DF.Font.Style := [fsBold] else _DF.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'MG' then _MG.Font.Style := [fsBold] else _MG.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'ES' then _ES.Font.Style := [fsBold] else _ES.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'MS' then _MS.Font.Style := [fsBold] else _MS.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'SP' then _SP.Font.Style := [fsBold] else _SP.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'RJ' then _RJ.Font.Style := [fsBold] else _RJ.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'PR' then _PR.Font.Style := [fsBold] else _PR.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'SC' then _SC.Font.Style := [fsBold] else _SC.Font.Style := [];
    if Form7.ibDataSet13ESTADO.AsString = 'RS' then _RS.Font.Style := [fsBold] else _RS.Font.Style := [];
  except
  end;
end;

procedure TFrmNaturezaOperacao.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;
end;

procedure TFrmNaturezaOperacao.btnOKClick(Sender: TObject);
begin
  Form7.DefineNovoNomeNatOperacao;
  inherited;
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

procedure TFrmNaturezaOperacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Form7.FbClicouModulo := False;
  inherited;
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

  _RR.Caption := 'RR '+Form7.ibDataSet14.FieldByname('RR_').AsString+'%';
  _AP.Caption := 'AP '+Form7.ibDataSet14.FieldByname('AP_').AsString+'%';
  _AM.Caption := 'AM '+Form7.ibDataSet14.FieldByname('AM_').AsString+'%';
  _PA.Caption := 'PA '+Form7.ibDataSet14.FieldByname('PA_').AsString+'%';
  _MA.Caption := 'MA '+Form7.ibDataSet14.FieldByname('MA_').AsString+'%';
  _AC.Caption := 'AC '+Form7.ibDataSet14.FieldByname('AC_').AsString+'%';
  _RO.Caption := 'RO '+Form7.ibDataSet14.FieldByname('RO_').AsString+'%';
  _MT.Caption := 'MT '+Form7.ibDataSet14.FieldByname('MT_').AsString+'%';
  _TO.Caption := 'TO '+Form7.ibDataSet14.FieldByname('TO_').AsString+'%';
  _CE.Caption := 'CE '+Form7.ibDataSet14.FieldByname('CE_').AsString+'%';
  _RN.Caption := 'RN '+Form7.ibDataSet14.FieldByname('RN_').AsString+'%';
  _PI.Caption := 'PI '+Form7.ibDataSet14.FieldByname('PI_').AsString+'%';
  _PB.Caption := 'PB '+Form7.ibDataSet14.FieldByname('PB_').AsString+'%';
  _PE.Caption := 'PE '+Form7.ibDataSet14.FieldByname('PE_').AsString+'%';
  _AL.Caption := 'AL '+Form7.ibDataSet14.FieldByname('AL_').AsString+'%';
  _SE.Caption := 'SE '+Form7.ibDataSet14.FieldByname('SE_').AsString+'%';
  _BA.Caption := 'BA '+Form7.ibDataSet14.FieldByname('BA_').AsString+'%';
  _GO.Caption := 'GO '+Form7.ibDataSet14.FieldByname('GO_').AsString+'%';
  _DF.Caption := 'DF '+Form7.ibDataSet14.FieldByname('DF_').AsString+'%';
  _MG.Caption := 'MG '+Form7.ibDataSet14.FieldByname('MG_').AsString+'%';
  _ES.Caption := 'ES '+Form7.ibDataSet14.FieldByname('ES_').AsString+'%';
  _MS.Caption := 'MS '+Form7.ibDataSet14.FieldByname('MS_').AsString+'%';
  _SP.Caption := 'SP '+Form7.ibDataSet14.FieldByname('SP_').AsString+'%';
  _RJ.Caption := 'RJ '+Form7.ibDataSet14.FieldByname('RJ_').AsString+'%';
  _PR.Caption := 'PR '+Form7.ibDataSet14.FieldByname('PR_').AsString+'%';
  _SC.Caption := 'SC '+Form7.ibDataSet14.FieldByname('SC_').AsString+'%';
  _RS.Caption := 'RS '+Form7.ibDataSet14.FieldByname('RS_').AsString+'%';
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
  Form7.FbClicouModulo := True;
  Form7.sNumeroAnterior14 := Form7.ibDataSet14REGISTRO.AsString;
  Form7.sNomeAnterior14   := Form7.ibDataSet14NOME.AsString;

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

procedure TFrmNaturezaOperacao.DBCheckSobreClick(Sender: TObject);
var
  oCampo: TDBCheckBox;
  cValor: String;
begin
  if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
    Form7.ibDataSet14.Edit;

  oCampo := (Sender as TDBCheckBox);

  cValor := 'N';
  if oCampo.Checked then
    cValor := 'S';

  Form7.ibDataSet14.FieldByName(oCampo.DataField).AsString := cValor;
end;

procedure TFrmNaturezaOperacao.tbsNaturezaEnter(Sender: TObject);
begin
  if not (Form7.ibDataSet14.State in ([dsEdit, dsInsert])) then
    Form7.ibDataSet14.Edit;
end;

procedure TFrmNaturezaOperacao.lblAnteriorClick(Sender: TObject);
begin
  if Form7.ibDataSet14NOME.AsString <> SMALL_DBEdit54.Text then
  begin
    btnOK.SetFocus;
    SMALL_DBEdit54.SetFocus;
  end;
  Form7.DefineNovoNomeNatOperacao;
  inherited;
  Form7.AtualizaVariaveisAnteriorNatOper;
end;

procedure TFrmNaturezaOperacao.lblNovoClick(Sender: TObject);
begin
  if Form7.ibDataSet14NOME.AsString <> SMALL_DBEdit54.Text then
  begin
    btnOK.SetFocus;
    SMALL_DBEdit54.SetFocus;
  end;
  Form7.DefineNovoNomeNatOperacao;
  inherited;
  AtualizaObjComValorDoBanco;
  Form7.AtualizaVariaveisAnteriorNatOper;
end;

procedure TFrmNaturezaOperacao.lblProcurarClick(Sender: TObject);
begin
  inherited;
  Form7.AtualizaVariaveisAnteriorNatOper;
end;

procedure TFrmNaturezaOperacao.lblProximoClick(Sender: TObject);
begin
  if Form7.ibDataSet14NOME.AsString <> SMALL_DBEdit54.Text then
  begin
    btnOK.SetFocus;
    SMALL_DBEdit54.SetFocus;
  end;
  Form7.DefineNovoNomeNatOperacao;
  inherited;
  Form7.AtualizaVariaveisAnteriorNatOper;
end;

end.
