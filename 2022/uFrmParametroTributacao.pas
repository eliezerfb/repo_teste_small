unit uFrmParametroTributacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmFichaPadrao, ComCtrls, StdCtrls, Buttons, ExtCtrls, Mask,
  DBCtrls, SMALL_DBEdit, DB, uframeCampo, IBCustomDataSet;

type
  TFrmParametroTributacao = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    gbPisCofinsEntrada: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label34: TLabel;
    edtCFOP: TSMALL_DBEdit;
    Label51: TLabel;
    cboOrigem: TComboBox;
    Label36: TLabel;
    Label37: TLabel;
    cboCST: TComboBox;
    cboCSOSN: TComboBox;
    Label31: TLabel;
    edtICMS: TSMALL_DBEdit;
    Label2: TLabel;
    edtNCM: TSMALL_DBEdit;
    Label3: TLabel;
    fraPerfilTrib: TfFrameCampo;
    Label119: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label120: TLabel;
    Label116: TLabel;
    lblCSOSNPerfilTrib: TLabel;
    lblCSTPerfilTrib: TLabel;
    lblCFOPNfce: TLabel;
    lblCSOSN_NFCePerfilTrib: TLabel;
    lblCST_NFCePerfilTrib: TLabel;
    lblAliqNFCEPerfilTrib: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    DBText10: TDBText;
    DBText11: TDBText;
    DSPerfilTrib: TDataSource;
    DBText12: TDBText;
    ibdPerfilTrib: TIBDataSet;
    ibdPerfilTribTIPO_ITEM: TIBStringField;
    ibdPerfilTribIPPT: TIBStringField;
    ibdPerfilTribIAT: TIBStringField;
    ibdPerfilTribORIGEM: TIBStringField;
    ibdPerfilTribPIVA: TFloatField;
    ibdPerfilTribCST: TIBStringField;
    ibdPerfilTribCSOSN: TIBStringField;
    ibdPerfilTribST: TIBStringField;
    ibdPerfilTribCFOP: TIBStringField;
    ibdPerfilTribCST_NFCE: TIBStringField;
    ibdPerfilTribCSOSN_NFCE: TIBStringField;
    ibdPerfilTribALIQUOTA_NFCE: TIBBCDField;
    ibdPerfilTribCST_IPI: TIBStringField;
    ibdPerfilTribIPI: TFloatField;
    ibdPerfilTribENQ_IPI: TIBStringField;
    ibdPerfilTribCST_PIS_COFINS_SAIDA: TIBStringField;
    ibdPerfilTribALIQ_PIS_SAIDA: TIBBCDField;
    ibdPerfilTribALIQ_COFINS_SAIDA: TIBBCDField;
    ibdPerfilTribCST_PIS_COFINS_ENTRADA: TIBStringField;
    ibdPerfilTribALIQ_PIS_ENTRADA: TIBBCDField;
    ibdPerfilTribALIQ_COFINS_ENTRADA: TIBBCDField;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DBText13: TDBText;
    DBText14: TDBText;
    DBText15: TDBText;
    DBText16: TDBText;
    DBText17: TDBText;
    DBText18: TDBText;
    DBText19: TDBText;
    DBText20: TDBText;
    DBText21: TDBText;
    procedure edtCFOPKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure cboOrigemChange(Sender: TObject);
    procedure cboCSTChange(Sender: TObject);
    procedure cboCSOSNChange(Sender: TObject);
    procedure fraPerfilTribgdRegistrosDblClick(Sender: TObject);
    procedure fraPerfilTribExit(Sender: TObject);
    procedure fraPerfilTribgdRegistrosKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
  public
    { Public declarations }
  end;

var
  FrmParametroTributacao: TFrmParametroTributacao;

implementation

uses
  Unit7
  , HtmlHelp
  , SmallFunc
  ;

{$R *.dfm}

procedure TFrmParametroTributacao.edtCFOPKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(Form7.sAjuda)));
end;

procedure TFrmParametroTributacao.FormShow(Sender: TObject);
begin
  inherited;

  ibdPerfilTrib.Open;

  if edtCFOP.CanFocus then
    edtCFOP.SetFocus;
end;

procedure TFrmParametroTributacao.SetaStatusUso;
begin
  inherited;
  
  edtCFOP.Enabled       := not(bEstaSendoUsado);
  cboOrigem.Enabled     := not(bEstaSendoUsado);
  cboCST.Enabled        := not(bEstaSendoUsado);
  cboCSOSN.Enabled      := not(bEstaSendoUsado);
  edtICMS.Enabled       := not(bEstaSendoUsado);
  edtNCM.Enabled        := not(bEstaSendoUsado);
  fraPerfilTrib.Enabled := not(bEstaSendoUsado);
end;

procedure TFrmParametroTributacao.lblNovoClick(Sender: TObject);
begin
  inherited;

  if (edtCFOP.CanFocus) and (Self.Visible) then
    edtCFOP.SetFocus;
end;

procedure TFrmParametroTributacao.DSCadastroDataChange(Sender: TObject;
  Field: TField);
var
  I : integer;
begin
  inherited;

  if DSCadastro.DataSet.State = dsEdit then
    Exit;

  fraPerfilTrib.CampoCodigo     := DSCadastro.DataSet.FieldByName('IDPERFILTRIBUTACAO');
  fraPerfilTrib.sCampoDescricao := 'DESCRICAO';
  fraPerfilTrib.sTabela         := 'PERFILTRIBUTACAO';
  fraPerfilTrib.CarregaDescricao;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  //Combos
  cboOrigem.ItemIndex := -1;
  cboCST.ItemIndex    := -1;
  cboCSOSN.ItemIndex  := -1;

  if AllTrim(DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString) <> '' then
  begin
    for I := 0 to cboOrigem.Items.Count -1 do
    begin
      if Copy(cboOrigem.Items[I],1,Length(Trim(DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString))) = UpperCase(AllTrim(DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString)) then
      begin
        cboOrigem.ItemIndex := I;
      end;
    end;
  end;

  if AllTrim(DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString) <> '' then
  begin
    for I := 0 to cboCST.Items.Count -1 do
    begin
      if Copy(cboCST.Items[I],1,Length(Trim(DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString))) = UpperCase(AllTrim(DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString)) then
      begin
        cboCST.ItemIndex := I;
      end;
    end;
  end;

  if AllTrim(DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString) <> '' then
  begin
    for I := 0 to cboCSOSN.Items.Count -1 do
    begin
      if Copy(cboCSOSN.Items[I],1,Length(Trim(DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString))) = UpperCase(AllTrim(DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString)) then
      begin
        cboCSOSN.ItemIndex := I;
      end;
    end;
  end;
end;

procedure TFrmParametroTributacao.cboOrigemChange(Sender: TObject);
begin
 if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString := Copy(cboOrigem.Items[cboOrigem.ItemIndex]+' ',1,1);
end;

procedure TFrmParametroTributacao.cboCSTChange(Sender: TObject);
begin
  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString := Copy(cboCST.Items[cboCST.ItemIndex]+'   ',1,2);
end;

procedure TFrmParametroTributacao.cboCSOSNChange(Sender: TObject);
begin
  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString := Trim(Copy(cboCSOSN.Items[cboCSOSN.ItemIndex]+'   ',1,3));
end;

procedure TFrmParametroTributacao.fraPerfilTribgdRegistrosDblClick(
  Sender: TObject);
begin
  inherited;
  fraPerfilTrib.gdRegistrosDblClick(Sender);

  ibdPerfilTrib.Close;
  ibdPerfilTrib.Open;
end;

procedure TFrmParametroTributacao.fraPerfilTribExit(Sender: TObject);
begin
  inherited;
  fraPerfilTrib.FrameExit(Sender);

  ibdPerfilTrib.Close;
  ibdPerfilTrib.Open;
end;

procedure TFrmParametroTributacao.fraPerfilTribgdRegistrosKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  fraPerfilTrib.gdRegistrosKeyDown(Sender, Key, Shift);

  if Key = VK_RETURN then
  begin
    ibdPerfilTrib.Close;
    ibdPerfilTrib.Open;
  end;
end;

procedure TFrmParametroTributacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  ibdPerfilTrib.Close;
  FreeAndNil(FrmParametroTributacao);
end;

end.
