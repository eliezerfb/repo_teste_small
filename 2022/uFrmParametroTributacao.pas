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
    descCSTPerfilTrib: TDBText;
    descCSOSNPerfilTrib: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    descCST_NFCePerfilTrib: TDBText;
    DBText11: TDBText;
    DSPerfilTrib: TDataSource;
    descCSOSN_NFCePerfilTrib: TDBText;
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
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    function CadastroDuplicado: Boolean;
  public
    { Public declarations }
  end;

var
  FrmParametroTributacao: TFrmParametroTributacao;

implementation

uses
  Unit7
  , smallfunc_xe
  , uFuncoesRetaguarda, uFuncoesBancoDados, uDialogs;

{$R *.dfm}

procedure TFrmParametroTributacao.FormShow(Sender: TObject);
begin
  inherited;

  ibdPerfilTrib.Open;

  if edtCFOP.CanFocus then
    edtCFOP.SetFocus;

  if Form7.ibDataSet13CRT.AsString = '1' then
  begin
    lblCSOSNPerfilTrib.Visible       := True;
    descCSOSNPerfilTrib.Visible      := True;
    lblCSTPerfilTrib.Visible         := False;
    descCSTPerfilTrib.Visible        := False;

    lblCSOSN_NFCePerfilTrib.Visible  := True;
    descCSOSN_NFCePerfilTrib.Visible := True;
    lblCST_NFCePerfilTrib.Visible    := False;
    descCST_NFCePerfilTrib.Visible   := False;
  end else
  begin
    lblCSOSNPerfilTrib.Visible       := False;
    descCSOSNPerfilTrib.Visible      := False;
    lblCSTPerfilTrib.Visible         := True;
    descCSTPerfilTrib.Visible        := True;

    lblCSOSN_NFCePerfilTrib.Visible  := False;
    descCSOSN_NFCePerfilTrib.Visible := False;
    lblCST_NFCePerfilTrib.Visible    := True;
    descCST_NFCePerfilTrib.Visible   := True;
  end;

  if Form7.ibDataSet13ESTADO.AsString = 'SP' then
  begin
    lblCFOPNfce.Caption             := StrTran(lblCFOPNfce.Caption,'NFC-e','SAT');
    lblCST_NFCePerfilTrib.Caption   := StrTran(lblCST_NFCePerfilTrib.Caption,'NFC-e','SAT');
    lblCSOSN_NFCePerfilTrib.Caption := StrTran(lblCSOSN_NFCePerfilTrib.Caption,'NFC-e','SAT');
    lblAliqNFCEPerfilTrib.Caption   := StrTran(lblAliqNFCEPerfilTrib.Caption,'NFC-e','SAT');
  end else
  begin
    lblCFOPNfce.Caption             := StrTran(lblCFOPNfce.Caption,'SAT','NFC-e');
    lblCST_NFCePerfilTrib.Caption   := StrTran(lblCST_NFCePerfilTrib.Caption,'SAT','NFC-e');
    lblCSOSN_NFCePerfilTrib.Caption := StrTran(lblCSOSN_NFCePerfilTrib.Caption,'SAT','NFC-e');
    lblAliqNFCEPerfilTrib.Caption   := StrTran(lblAliqNFCEPerfilTrib.Caption,'SAT','NFC-e');
  end;
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

  DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString := Copy(cboOrigem.Items[cboOrigem.ItemIndex],1,1);
end;

procedure TFrmParametroTributacao.cboCSTChange(Sender: TObject);
begin
  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString := Copy(cboCST.Items[cboCST.ItemIndex],1,2);
end;

procedure TFrmParametroTributacao.cboCSOSNChange(Sender: TObject);
begin
  if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString := Trim(Copy(cboCSOSN.Items[cboCSOSN.ItemIndex],1,3));
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

  //Limpa da Memória
  Action := caFree;
  FrmParametroTributacao := nil;
end;

procedure TFrmParametroTributacao.btnOKClick(Sender: TObject);
begin
  //Validações
  if (DSCadastro.DataSet.FieldByName('CFOP_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('ORIGEM_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('CST_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('CSOSN_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('ALIQ_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('NCM_ENTRADA').AsString = '')
    and (DSCadastro.DataSet.FieldByName('IDPERFILTRIBUTACAO').AsString = '') then
  begin
    //Se estiver tudo em branco cancela
    DSCadastro.DataSet.Cancel;
  end else
  begin
    if (DSCadastro.DataSet.FieldByName('IDPERFILTRIBUTACAO').AsString = '') then
    begin
      MensagemSistema('Campo Perfil de tributação deve ser preenchido!',msgAtencao);
      if fraPerfilTrib.txtCampo.CanFocus then
        fraPerfilTrib.txtCampo.SetFocus;

      Exit;
    end;

    if CadastroDuplicado then
    begin
      MensagemSistema('Parâmetros informados já utilizados em outro cadastro!',msgAtencao);
      
      Exit;
    end;
  end;

  inherited;
end;

function TFrmParametroTributacao.GetPaginaAjuda: string;
begin
  Result := 'parametros_tributacao.htm';
end;

function TFrmParametroTributacao.CadastroDuplicado:Boolean;
begin
  //Verifica se tem um outro registro com as mesmas informaçoes já cadastrado
  Result := True;

  try
    Result := ExecutaComandoEscalar(Form7.IBDatabase1,
                                    ' Select count(*) '+
                                    ' From PARAMETROTRIBUTACAO'+
                                    ' Where IDPARAMETROTRIBUTACAO <> '+QuotedStr(DSCadastro.DataSet.FieldbyName('IDPARAMETROTRIBUTACAO').AsString)+
                                    '   and Coalesce(CFOP_ENTRADA,'''') = '+QuotedStr(DSCadastro.DataSet.FieldbyName('CFOP_ENTRADA').AsString)+
                                    '   and Coalesce(ORIGEM_ENTRADA,'''') = '+QuotedStr(DSCadastro.DataSet.FieldbyName('ORIGEM_ENTRADA').AsString)+
                                    '   and Coalesce(CST_ENTRADA,'''') = '+QuotedStr(DSCadastro.DataSet.FieldbyName('CST_ENTRADA').AsString)+
                                    '   and Coalesce(CSOSN_ENTRADA,'''') = '+QuotedStr(DSCadastro.DataSet.FieldbyName('CSOSN_ENTRADA').AsString)+
                                    '   and Coalesce(ALIQ_ENTRADA,0) = '+ FloatToBD(DSCadastro.DataSet.FieldbyName('ALIQ_ENTRADA').AsFloat)+
                                    '   and Coalesce(NCM_ENTRADA,'''') = '+QuotedStr(DSCadastro.DataSet.FieldbyName('NCM_ENTRADA').AsString)
                                    ) > 0;
  except
  end;
end;

end.
