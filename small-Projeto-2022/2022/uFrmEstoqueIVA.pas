
unit uFrmEstoqueIVA;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  Data.DB, IBX.IBCustomDataSet;

type
  TFrmEstoqueIVA = class(TFrmPadrao)
    btnCancelar: TBitBtn;
    btnEnviar: TBitBtn;
    Image4: TImage;
    Image3: TImage;
    LabelDescricaoNCM: TLabel;
    _RR: TLabel;
    _AP: TLabel;
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
    _GO: TLabel;
    _BA: TLabel;
    _MG: TLabel;
    _MS: TLabel;
    _SP: TLabel;
    _ES: TLabel;
    _RJ: TLabel;
    _PR: TLabel;
    _SC: TLabel;
    _RS: TLabel;
    edt_valor: TSMALL_DBEdit;
    DSCadastro: TDataSource;
    ibdEstoqueIVA: TIBDataSet;
    ibdEstoqueIVAIDESTOQUEIVA: TIntegerField;
    ibdEstoqueIVAIDESTOQUE: TIntegerField;
    ibdEstoqueIVAAC_: TIBBCDField;
    ibdEstoqueIVAAL_: TIBBCDField;
    ibdEstoqueIVAAP_: TIBBCDField;
    ibdEstoqueIVAAM_: TIBBCDField;
    ibdEstoqueIVABA_: TIBBCDField;
    ibdEstoqueIVACE_: TIBBCDField;
    ibdEstoqueIVADF_: TIBBCDField;
    ibdEstoqueIVAES_: TIBBCDField;
    ibdEstoqueIVAGO_: TIBBCDField;
    ibdEstoqueIVAMA_: TIBBCDField;
    ibdEstoqueIVAMT_: TIBBCDField;
    ibdEstoqueIVAMS_: TIBBCDField;
    ibdEstoqueIVAMG_: TIBBCDField;
    ibdEstoqueIVAPA_: TIBBCDField;
    ibdEstoqueIVAPB_: TIBBCDField;
    ibdEstoqueIVAPR_: TIBBCDField;
    ibdEstoqueIVAPE_: TIBBCDField;
    ibdEstoqueIVAPI_: TIBBCDField;
    ibdEstoqueIVARJ_: TIBBCDField;
    ibdEstoqueIVARN_: TIBBCDField;
    ibdEstoqueIVARS_: TIBBCDField;
    ibdEstoqueIVARO_: TIBBCDField;
    ibdEstoqueIVARR_: TIBBCDField;
    ibdEstoqueIVASC_: TIBBCDField;
    ibdEstoqueIVASP_: TIBBCDField;
    ibdEstoqueIVASE_: TIBBCDField;
    ibdEstoqueIVATO_: TIBBCDField;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure _RRClick(Sender: TObject);
    procedure edt_valorExit(Sender: TObject);
    procedure edt_valorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure CarregaDados;
    procedure SetValorPadrao;
    { Private declarations }
  public
    UF_EMITENTE : string;
    { Public declarations }
  end;

var
  FrmEstoqueIVA: TFrmEstoqueIVA;

  procedure ConfiguraIVAporEstado(IDESTOQUE : integer; UF : string);

implementation

{$R *.dfm}

uses unit7, smallfunc_xe, uFuncoesBancoDados;

procedure TFrmEstoqueIVA.btnCancelarClick(Sender: TObject);
begin
  ibdEstoqueIVA.Cancel;
  Close;
end;

procedure TFrmEstoqueIVA.btnEnviarClick(Sender: TObject);
begin
  ibdEstoqueIVA.Post;
  Close;
end;

procedure TFrmEstoqueIVA._RRClick(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    edt_valorExit(sender);
    edt_valor.DataField := Copy(Caption,1,2)+'_';
    edt_valor.Top       := Top;
    edt_valor.Left      := Left;
    edt_valor.Visible   := True;
    edt_valor.Refresh;

    if edt_valor.CanFocus then
    begin
      edt_valor.SetFocus;
    end;
  end;
end;

procedure ConfiguraIVAporEstado(IDESTOQUE : integer; UF : string);
begin
  try
    FrmEstoqueIVA := TFrmEstoqueIVA.Create(nil);

    FrmEstoqueIVA.UF_EMITENTE := UF;

    FrmEstoqueIVA.ibdEstoqueIVA.Close;
    FrmEstoqueIVA.ibdEstoqueIVA.SelectSQL.text := ' Select'+
                                                  '   *'+
                                                  ' From ESTOQUEIVA'+
                                                  ' Where IDESTOQUE = '+IDESTOQUE.toString;
    FrmEstoqueIVA.ibdEstoqueIVA.Open;

    if FrmEstoqueIVA.ibdEstoqueIVA.isEmpty then
    begin
      FrmEstoqueIVA.ibdEstoqueIVA.Insert;
      FrmEstoqueIVA.ibdEstoqueIVAIDESTOQUEIVA.AsString := IncGenerator(FrmEstoqueIVA.ibdEstoqueIVA.Database,'G_ESTOQUEIVAIDESTOQUEIVA');
      FrmEstoqueIVA.ibdEstoqueIVAIDESTOQUE.AsInteger   := IDESTOQUE;
      FrmEstoqueIVA.SetValorPadrao;
    end else
    begin
      FrmEstoqueIVA.ibdEstoqueIVA.Edit;
    end;

    FrmEstoqueIVA.CarregaDados;
    FrmEstoqueIVA.ShowModal;
  finally
    FreeAndNil(FrmEstoqueIVA);
  end;
end;

procedure TFrmEstoqueIVA.CarregaDados;
begin
  _RR.Caption := 'RR '+ibdEstoqueIVA.FieldByname('RR_').AsString;
  _AP.Caption := 'AP '+ibdEstoqueIVA.FieldByname('AP_').AsString;
  _AM.Caption := 'AM '+ibdEstoqueIVA.FieldByname('AM_').AsString;
  _PA.Caption := 'PA '+ibdEstoqueIVA.FieldByname('PA_').AsString;
  _MA.Caption := 'MA '+ibdEstoqueIVA.FieldByname('MA_').AsString;
  _AC.Caption := 'AC '+ibdEstoqueIVA.FieldByname('AC_').AsString;
  _RO.Caption := 'RO '+ibdEstoqueIVA.FieldByname('RO_').AsString;
  _MT.Caption := 'MT '+ibdEstoqueIVA.FieldByname('MT_').AsString;
  _TO.Caption := 'TO '+ibdEstoqueIVA.FieldByname('TO_').AsString;
  _CE.Caption := 'CE '+ibdEstoqueIVA.FieldByname('CE_').AsString;
  _RN.Caption := 'RN '+ibdEstoqueIVA.FieldByname('RN_').AsString;
  _PI.Caption := 'PI '+ibdEstoqueIVA.FieldByname('PI_').AsString;
  _PB.Caption := 'PB '+ibdEstoqueIVA.FieldByname('PB_').AsString;
  _PE.Caption := 'PE '+ibdEstoqueIVA.FieldByname('PE_').AsString;
  _AL.Caption := 'AL '+ibdEstoqueIVA.FieldByname('AL_').AsString;
  _SE.Caption := 'SE '+ibdEstoqueIVA.FieldByname('SE_').AsString;
  _BA.Caption := 'BA '+ibdEstoqueIVA.FieldByname('BA_').AsString;
  _GO.Caption := 'GO '+ibdEstoqueIVA.FieldByname('GO_').AsString;
  _DF.Caption := 'DF '+ibdEstoqueIVA.FieldByname('DF_').AsString;
  _MG.Caption := 'MG '+ibdEstoqueIVA.FieldByname('MG_').AsString;
  _ES.Caption := 'ES '+ibdEstoqueIVA.FieldByname('ES_').AsString;
  _MS.Caption := 'MS '+ibdEstoqueIVA.FieldByname('MS_').AsString;
  _SP.Caption := 'SP '+ibdEstoqueIVA.FieldByname('SP_').AsString;
  _RJ.Caption := 'RJ '+ibdEstoqueIVA.FieldByname('RJ_').AsString;
  _PR.Caption := 'PR '+ibdEstoqueIVA.FieldByname('PR_').AsString;
  _SC.Caption := 'SC '+ibdEstoqueIVA.FieldByname('SC_').AsString;
  _RS.Caption := 'RS '+ibdEstoqueIVA.FieldByname('RS_').AsString;


  if UF_EMITENTE = 'RR' then _RR.Font.Color := clRed else _RR.Font.Color := clBlack;
  if UF_EMITENTE = 'AP' then _AP.Font.Color := clRed else _AP.Font.Color := clBlack;
  if UF_EMITENTE = 'AM' then _AM.Font.Color := clRed else _AM.Font.Color := clBlack;
  if UF_EMITENTE = 'PA' then _PA.Font.Color := clRed else _PA.Font.Color := clBlack;
  if UF_EMITENTE = 'MA' then _MA.Font.Color := clRed else _MA.Font.Color := clBlack;
  if UF_EMITENTE = 'AC' then _AC.Font.Color := clRed else _AC.Font.Color := clBlack;
  if UF_EMITENTE = 'RO' then _RO.Font.Color := clRed else _RO.Font.Color := clBlack;
  if UF_EMITENTE = 'MT' then _MT.Font.Color := clRed else _MT.Font.Color := clBlack;
  if UF_EMITENTE = 'TO' then _TO.Font.Color := clRed else _TO.Font.Color := clBlack;
  if UF_EMITENTE = 'CE' then _CE.Font.Color := clRed else _CE.Font.Color := clBlack;
  if UF_EMITENTE = 'RN' then _RN.Font.Color := clRed else _RN.Font.Color := clBlack;
  if UF_EMITENTE = 'PI' then _PI.Font.Color := clRed else _PI.Font.Color := clBlack;
  if UF_EMITENTE = 'PB' then _PB.Font.Color := clRed else _PB.Font.Color := clBlack;
  if UF_EMITENTE = 'PE' then _PE.Font.Color := clRed else _PE.Font.Color := clBlack;
  if UF_EMITENTE = 'AL' then _AL.Font.Color := clRed else _AL.Font.Color := clBlack;
  if UF_EMITENTE = 'SE' then _SE.Font.Color := clRed else _SE.Font.Color := clBlack;
  if UF_EMITENTE = 'BA' then _BA.Font.Color := clRed else _BA.Font.Color := clBlack;
  if UF_EMITENTE = 'GO' then _GO.Font.Color := clRed else _GO.Font.Color := clBlack;
  if UF_EMITENTE = 'DF' then _DF.Font.Color := clRed else _DF.Font.Color := clBlack;
  if UF_EMITENTE = 'MG' then _MG.Font.Color := clRed else _MG.Font.Color := clBlack;
  if UF_EMITENTE = 'ES' then _ES.Font.Color := clRed else _ES.Font.Color := clBlack;
  if UF_EMITENTE = 'MS' then _MS.Font.Color := clRed else _MS.Font.Color := clBlack;
  if UF_EMITENTE = 'SP' then _SP.Font.Color := clRed else _SP.Font.Color := clBlack;
  if UF_EMITENTE = 'RJ' then _RJ.Font.Color := clRed else _RJ.Font.Color := clBlack;
  if UF_EMITENTE = 'PR' then _PR.Font.Color := clRed else _PR.Font.Color := clBlack;
  if UF_EMITENTE = 'SC' then _SC.Font.Color := clRed else _SC.Font.Color := clBlack;
  if UF_EMITENTE = 'RS' then _RS.Font.Color := clRed else _RS.Font.Color := clBlack;

  if UF_EMITENTE = 'RR' then _RR.Font.Style := [fsBold] else _RR.Font.Style := [];
  if UF_EMITENTE = 'AP' then _AP.Font.Style := [fsBold] else _AP.Font.Style := [];
  if UF_EMITENTE = 'AM' then _AM.Font.Style := [fsBold] else _AM.Font.Style := [];
  if UF_EMITENTE = 'PA' then _PA.Font.Style := [fsBold] else _PA.Font.Style := [];
  if UF_EMITENTE = 'MA' then _MA.Font.Style := [fsBold] else _MA.Font.Style := [];
  if UF_EMITENTE = 'AC' then _AC.Font.Style := [fsBold] else _AC.Font.Style := [];
  if UF_EMITENTE = 'RO' then _RO.Font.Style := [fsBold] else _RO.Font.Style := [];
  if UF_EMITENTE = 'MT' then _MT.Font.Style := [fsBold] else _MT.Font.Style := [];
  if UF_EMITENTE = 'TO' then _TO.Font.Style := [fsBold] else _TO.Font.Style := [];
  if UF_EMITENTE = 'CE' then _CE.Font.Style := [fsBold] else _CE.Font.Style := [];
  if UF_EMITENTE = 'RN' then _RN.Font.Style := [fsBold] else _RN.Font.Style := [];
  if UF_EMITENTE = 'PI' then _PI.Font.Style := [fsBold] else _PI.Font.Style := [];
  if UF_EMITENTE = 'PB' then _PB.Font.Style := [fsBold] else _PB.Font.Style := [];
  if UF_EMITENTE = 'PE' then _PE.Font.Style := [fsBold] else _PE.Font.Style := [];
  if UF_EMITENTE = 'AL' then _AL.Font.Style := [fsBold] else _AL.Font.Style := [];
  if UF_EMITENTE = 'SE' then _SE.Font.Style := [fsBold] else _SE.Font.Style := [];
  if UF_EMITENTE = 'BA' then _BA.Font.Style := [fsBold] else _BA.Font.Style := [];
  if UF_EMITENTE = 'GO' then _GO.Font.Style := [fsBold] else _GO.Font.Style := [];
  if UF_EMITENTE = 'DF' then _DF.Font.Style := [fsBold] else _DF.Font.Style := [];
  if UF_EMITENTE = 'MG' then _MG.Font.Style := [fsBold] else _MG.Font.Style := [];
  if UF_EMITENTE = 'ES' then _ES.Font.Style := [fsBold] else _ES.Font.Style := [];
  if UF_EMITENTE = 'MS' then _MS.Font.Style := [fsBold] else _MS.Font.Style := [];
  if UF_EMITENTE = 'SP' then _SP.Font.Style := [fsBold] else _SP.Font.Style := [];
  if UF_EMITENTE = 'RJ' then _RJ.Font.Style := [fsBold] else _RJ.Font.Style := [];
  if UF_EMITENTE = 'PR' then _PR.Font.Style := [fsBold] else _PR.Font.Style := [];
  if UF_EMITENTE = 'SC' then _SC.Font.Style := [fsBold] else _SC.Font.Style := [];
  if UF_EMITENTE = 'RS' then _RS.Font.Style := [fsBold] else _RS.Font.Style := [];

end;

procedure TFrmEstoqueIVA.edt_valorExit(Sender: TObject);
begin
  {não funciona o cancelar
  try
    ibdEstoqueIVA.Post;
  except
  end;
  }

  try
    ibdEstoqueIVA.Edit;
  except
  end;

  edt_valor.Visible   := False;

  CarregaDados;
end;

procedure TFrmEstoqueIVA.edt_valorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TFrmEstoqueIVA.SetValorPadrao;
begin
  ibdEstoqueIVA.FieldByname('RR_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('AP_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('AM_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('PA_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('MA_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('AC_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('RO_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('MT_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('TO_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('CE_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('RN_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('PI_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('PB_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('PE_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('AL_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('SE_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('BA_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('GO_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('DF_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('MG_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('ES_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('MS_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('SP_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('RJ_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('PR_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('SC_').AsInteger := 0;
  ibdEstoqueIVA.FieldByname('RS_').AsInteger := 0;
end;

end.
