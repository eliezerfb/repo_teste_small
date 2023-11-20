unit uFrmPerfilTributacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmFichaPadrao, DB, ComCtrls, StdCtrls, Buttons, ExtCtrls, HtmlHelp, SmallFunc,
  Mask, DBCtrls, SMALL_DBEdit;

type
  TFrmPerfilTributacao = class(TFrmFichaPadrao)
    tbsPerfilTributacao: TTabSheet;
    tbsIPI: TTabSheet;
    tbsPisCofins: TTabSheet;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    lblCSOSNPerfilTrib: TLabel;
    lblCSTPerfilTrib: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    lblCitPerfilTrib: TLabel;
    lblCFOPNfce: TLabel;
    lblCSOSN_NFCePerfilTrib: TLabel;
    lblCST_NFCePerfilTrib: TLabel;
    lblAliqNFCEPerfilTrib: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    lblAtencaoPerfilTrib: TLabel;
    edtIVAPerfilTrb: TSMALL_DBEdit;
    edtCITPerfilTrib: TSMALL_DBEdit;
    cboCSTPerfilTrib: TComboBox;
    cboTipoItemPerfTrib: TComboBox;
    cboIPPTPerfTrib: TComboBox;
    cboIATPerfTrib: TComboBox;
    cboOrigemPerfTrib: TComboBox;
    cboCSOSNPerfilTrib: TComboBox;
    cboCFOP_NFCePerfTrib: TComboBox;
    cboCST_NFCePerfilTrib: TComboBox;
    cboCSOSN_NFCePerfilTrib: TComboBox;
    edtAliqNFCEPerfilTrib: TSMALL_DBEdit;
    edtDescricaoPerfilTrib: TSMALL_DBEdit;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    cboCST_IPI_PerTrib: TComboBox;
    edtPercIPIPerfilTrib: TSMALL_DBEdit;
    edtCodEnquadPerfilTrib: TSMALL_DBEdit;
    lbAtencaoIPI: TLabel;
    lbAtencaoPisCofins: TLabel;
    GroupBox1: TGroupBox;
    Label112: TLabel;
    lblCST_PIS_S_PerTrib: TLabel;
    lblCST_COFINS_S_PerTrib: TLabel;
    cboCST_PISCOFINS_S_PerTrib: TComboBox;
    edtPercPISPerfiLTrib: TSMALL_DBEdit;
    edtPercCofinsPefilTrib: TSMALL_DBEdit;
    GroupBox2: TGroupBox;
    Label131: TLabel;
    lblCST_PIS_E_PerTrib: TLabel;
    lblCST_COFINS_E_PerTrib: TLabel;
    cboCST_PISCOFINS_E_PerTrib: TComboBox;
    edtPecPISEntPerfilTrib: TSMALL_DBEdit;
    edtPercCofnsEntPerfilTrib: TSMALL_DBEdit;
    procedure cboCST_IPI_PerTribChange(Sender: TObject);
    procedure tbsIPIShow(Sender: TObject);
    procedure edtCITPerfilTribExit(Sender: TObject);
    procedure tbsIPIEnter(Sender: TObject);
    procedure DSCadastroStateChange(Sender: TObject);
    procedure cboCST_PISCOFINS_S_PerTribChange(Sender: TObject);
    procedure cboCST_PISCOFINS_E_PerTribChange(Sender: TObject);
    procedure edtDescricaoPerfilTribMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure cboTipoItemPerfTribChange(Sender: TObject);
    procedure cboIPPTPerfTribChange(Sender: TObject);
    procedure cboIATPerfTribChange(Sender: TObject);
    procedure cboOrigemPerfTribChange(Sender: TObject);
    procedure cboCFOP_NFCePerfTribChange(Sender: TObject);
    procedure cboCSOSN_NFCePerfilTribChange(Sender: TObject);
    procedure cboCST_NFCePerfilTribChange(Sender: TObject);
    procedure cboCSOSNPerfilTribChange(Sender: TObject);
    procedure cboCSTPerfilTribChange(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure CarregaCitPerfilTrib;
  public
    { Public declarations }
  end;

var
  FrmPerfilTributacao: TFrmPerfilTributacao;

implementation

uses Unit7;

{$R *.dfm}

procedure TFrmPerfilTributacao.cboCST_IPI_PerTribChange(Sender: TObject);
begin
  if caption = form7.ibdPerfilTributaDESCRICAO.AsString then
  begin
    Form7.ibdPerfilTributaCST_IPI.AsString := Copy(cboCST_IPI_PerTrib.Items[cboCST_IPI_PerTrib.ItemIndex]+'  ',1,2);
  end;
end;

function TFrmPerfilTributacao.GetPaginaAjuda: string;
begin
  Result := 'perfil_tributacao.htm';
end;

procedure TFrmPerfilTributacao.SetaStatusUso;
begin
  inherited;

  cboCST_IPI_PerTrib.Enabled          := not(bEstaSendoUsado);
  cboCST_PISCOFINS_S_PerTrib.Enabled  := not(bEstaSendoUsado);
  cboCST_PISCOFINS_E_PerTrib.Enabled  := not(bEstaSendoUsado);
  cboTipoItemPerfTrib.Enabled         := not(bEstaSendoUsado);
  cboIPPTPerfTrib.Enabled             := not(bEstaSendoUsado);
  cboIATPerfTrib.Enabled              := not(bEstaSendoUsado);
  cboOrigemPerfTrib.Enabled           := not(bEstaSendoUsado);
  cboCFOP_NFCePerfTrib.Enabled        := not(bEstaSendoUsado);
  cboCSTPerfilTrib.Enabled            := not(bEstaSendoUsado);
  cboCSOSNPerfilTrib.Enabled          := not(bEstaSendoUsado);
  cboCST_NFCePerfilTrib.Enabled       := not(bEstaSendoUsado);
  cboCSOSN_NFCePerfilTrib.Enabled     := not(bEstaSendoUsado);
  edtPercIPIPerfilTrib.Enabled        := not(bEstaSendoUsado);
  edtCodEnquadPerfilTrib.Enabled      := not(bEstaSendoUsado);
  edtPercPISPerfiLTrib.Enabled        := not(bEstaSendoUsado);
  edtPercCofinsPefilTrib.Enabled      := not(bEstaSendoUsado);
  edtPecPISEntPerfilTrib.Enabled      := not(bEstaSendoUsado);
  edtPercCofnsEntPerfilTrib.Enabled   := not(bEstaSendoUsado);
  edtDescricaoPerfilTrib.Enabled      := not(bEstaSendoUsado);
  edtIVAPerfilTrb.Enabled             := not(bEstaSendoUsado);
  edtAliqNFCEPerfilTrib.Enabled       := not(bEstaSendoUsado);
  edtCITPerfilTrib.Enabled            := not(bEstaSendoUsado);
end;

procedure TFrmPerfilTributacao.tbsIPIShow(Sender: TObject);
var
  I : integer;
begin
  FrmPerfilTributacao.Caption := form7.ibdPerfilTributaDESCRICAO.AsString;

  // Antes de tudo Zera os combos
  cboCST_IPI_PerTrib.ItemIndex := -1;
  cboCST_PISCOFINS_S_PerTrib.ItemIndex := -1;
  cboCST_PISCOFINS_E_PerTrib.ItemIndex := -1;
  cboTipoItemPerfTrib.ItemIndex := -1;
  cboIPPTPerfTrib.ItemIndex := -1;
  cboIATPerfTrib.ItemIndex := -1;
  cboOrigemPerfTrib.ItemIndex := -1;
  cboCFOP_NFCePerfTrib.ItemIndex := -1;
  cboCSTPerfilTrib.ItemIndex := -1;
  cboCSOSNPerfilTrib.ItemIndex := -1;
  cboCST_NFCePerfilTrib.ItemIndex := -1;
  cboCSOSN_NFCePerfilTrib.ItemIndex := -1;


  if not (Form7.ibdPerfilTributa.State in ([dsEdit, dsInsert])) then
    Form7.ibdPerfilTributa.Edit;


  //Tipo Item
  if AllTrim(Form7.ibdPerfilTributaTIPO_ITEM.AsString)<>'' then
  begin
    for I := 0 to cboTipoItemPerfTrib.Items.Count -1 do
    begin
      if Copy(cboTipoItemPerfTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaTIPO_ITEM.AsString)) then
      begin
        cboTipoItemPerfTrib.ItemIndex := I;
      end;
    end;
  end;

  //CST IPI
  if AllTrim(Form7.ibdPerfilTributaCST_IPI.AsString)<>'' then
  begin
    for I := 0 to cboCST_IPI_PerTrib.Items.Count -1 do
    begin
      if Copy(cboCST_IPI_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_IPI.AsString)) then
      begin
        cboCST_IPI_PerTrib.ItemIndex := I;
      end;
    end;
  end;

  //IPPT
  for I := 0 to cboIPPTPerfTrib.Items.Count -1 do
  begin
    if Copy(cboIPPTPerfTrib.Items[I],1,1) = UpperCase(AllTrim(Form7.ibdPerfilTributaIPPT.AsString)) then
    begin
      cboIPPTPerfTrib.ItemIndex := I;
    end;
  end;

  //IAT
  for I := 0 to cboIATPerfTrib.Items.Count -1 do
  begin
    if Copy(cboIATPerfTrib.Items[I],1,1) = UpperCase(AllTrim(Form7.ibdPerfilTributaIAT.AsString)) then
    begin
      cboIATPerfTrib.ItemIndex := I;
    end;
  end;

  //Origem
  if AllTrim(Form7.ibdPerfilTributaCST.AsString)<>'' then
  begin
    for I := 0 to cboOrigemPerfTrib.Items.Count -1 do
    begin
      if Copy(cboOrigemPerfTrib.Items[I],1,1) = Copy(Form7.ibdPerfilTributaCST.AsString+'000',1,1) then
      begin
        cboOrigemPerfTrib.ItemIndex := I;
      end;
    end;
  end;

  //CFOP NFCe
  if AllTrim(Form7.ibdPerfilTributaCFOP.AsString)<>'' then
  begin
    for I := 0 to cboCFOP_NFCePerfTrib.Items.Count -1 do
    begin
      if Copy(cboCFOP_NFCePerfTrib.Items[I],1,4) = UpperCase(AllTrim(Form7.ibdPerfilTributaCFOP.AsString)) then
      begin
        cboCFOP_NFCePerfTrib.ItemIndex := I;
      end;
    end;
  end;

  //CST
  if AllTrim(Form7.ibdPerfilTributaCST.AsString)<>'' then
  begin
    for I := 0 to cboCSTPerfilTrib.Items.Count -1 do
    begin
      if Copy(cboCSTPerfilTrib.Items[I],1,2) = Copy(Form7.ibdPerfilTributaCST.AsString+'000',2,2) then
      begin
        cboCSTPerfilTrib.ItemIndex := I;
      end;
    end;
  end;

  //CSOSN
  if AllTrim(Form7.ibdPerfilTributaCSOSN.AsString)<>'' then
  begin
    for I := 0 to cboCSOSNPerfilTrib.Items.Count -1 do
    begin
      if Copy(cboCSOSNPerfilTrib.Items[I],1, Length(Trim(Form7.ibdPerfilTributaCSOSN.AsString))) = UpperCase(AllTrim(Form7.ibdPerfilTributaCSOSN.AsString)) then
      begin
        cboCSOSNPerfilTrib.ItemIndex := I;
      end;
    end;
  end;

  //CST NFCE
  if AllTrim(Form7.ibdPerfilTributaCST_NFCE.AsString)<>'' then
  begin
    for I := 0 to cboCST_NFCePerfilTrib.Items.Count -1 do
    begin
      if Copy(cboCST_NFCePerfilTrib.Items[I],1,2) = Copy(Form7.ibdPerfilTributaCST_NFCE.AsString+'000',2,2) then
      begin
        cboCST_NFCePerfilTrib.ItemIndex := I;
      end;
    end;
  end;

  //CSOSN NFCE
  if AllTrim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString)<>'' then
  begin
    for I := 0 to cboCSOSN_NFCePerfilTrib.Items.Count -1 do
    begin
      if Copy(cboCSOSN_NFCePerfilTrib.Items[I],1,Length(Trim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString))) = UpperCase(AllTrim(Form7.ibdPerfilTributaCSOSN_NFCE.AsString)) then
      begin
        cboCSOSN_NFCePerfilTrib.ItemIndex := I;
      end;
    end;
  end;


  //Pis-Cofins Saída
  if AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString)<>'' then
  begin
    for I := 0 to cboCST_PISCOFINS_S_PerTrib.Items.Count -1 do
    begin
      if Copy(cboCST_PISCOFINS_S_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString)) then
      begin
        cboCST_PISCOFINS_S_PerTrib.ItemIndex := I;
      end;
    end;
  end;

  //Pis-Cofins Entrada
  if AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString)<>'' then
  begin
    for I := 0 to cboCST_PISCOFINS_E_PerTrib.Items.Count -1 do
    begin
      if Copy(cboCST_PISCOFINS_E_PerTrib.Items[I],1,2) = UpperCase(AllTrim(Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString)) then
      begin
        cboCST_PISCOFINS_E_PerTrib.ItemIndex := I;
      end;
    end;
  end;


  //CST-CSOCN
  if Form7.ibDataSet13CRT.AsString = '1' then
  begin
    lblCSOSNPerfilTrib.Visible       := True;
    cboCSOSNPerfilTrib.Visible       := True;
    lblCSTPerfilTrib.Visible         := False;
    cboCSTPerfilTrib.Visible         := False;

    lblCSOSN_NFCePerfilTrib.Visible  := True;
    cboCSOSN_NFCePerfilTrib.Visible  := True;
    lblCST_NFCePerfilTrib.Visible    := False;
    cboCST_NFCePerfilTrib.Visible    := False;
  end else
  begin
    lblCSOSNPerfilTrib.Visible       := False;
    cboCSOSNPerfilTrib.Visible       := False;
    lblCSTPerfilTrib.Visible         := True;
    cboCSTPerfilTrib.Visible         := True;

    lblCSOSN_NFCePerfilTrib.Visible  := False;
    cboCSOSN_NFCePerfilTrib.Visible  := False;
    lblCST_NFCePerfilTrib.Visible    := True;
    cboCST_NFCePerfilTrib.Visible    := True;
  end;

  //NFC-e ou SAT
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

  //CIT
  CarregaCitPerfilTrib;
end;


procedure TFrmPerfilTributacao.CarregaCitPerfilTrib;
begin
  if AllTrim(Form7.ibdPerfilTributaST.AsString) <> '' then
  begin
    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Text := ' Select * FROM ICM '+
                                        ' Where ST='+QuotedStr(Form7.ibdPerfilTributaST.AsString);
    Form7.ibDataSet14.Open;

    if Alltrim(Form7.ibDataSet14CFOP.AsString) <> '' then
    begin
      lblCitPerfilTrib.Caption := Form7.ibDataSet14CFOP.AsString + ' - ' + Form7.ibDataSet14NOME.AsString;
    end else
    begin
      lblCitPerfilTrib.Caption := '';
    end;
  end else
  begin
    lblCitPerfilTrib.Caption := '';
  end;
end;

procedure TFrmPerfilTributacao.edtCITPerfilTribExit(Sender: TObject);
begin
  CarregaCitPerfilTrib;
end;

procedure TFrmPerfilTributacao.tbsIPIEnter(Sender: TObject);
begin
  if not (Form7.ibdPerfilTributa.State in ([dsEdit, dsInsert])) then
      Form7.ibdPerfilTributa.Edit;
end;

procedure TFrmPerfilTributacao.DSCadastroStateChange(Sender: TObject);
begin
  inherited;
  lblAtencaoPerfilTrib.Visible := DSCadastro.State = dsEdit;
  lbAtencaoPisCofins.Visible   := DSCadastro.State = dsEdit;
  lbAtencaoIPI.Visible         := DSCadastro.State = dsEdit;
end;

procedure TFrmPerfilTributacao.cboCST_PISCOFINS_S_PerTribChange(
  Sender: TObject);
begin
  Form7.ibdPerfilTributaCST_PIS_COFINS_SAIDA.AsString := Copy(cboCST_PISCOFINS_S_PerTrib.Items[cboCST_PISCOFINS_S_PerTrib.ItemIndex]+'  ',1,2);

  if Copy(cboCST_PISCOFINS_S_PerTrib.Items[cboCST_PISCOFINS_S_PerTrib.ItemIndex]+'  ',1,2) = '03' then
  begin
    lblCST_PIS_S_PerTrib.Caption    := 'R$ PIS:';
    lblCST_COFINS_S_PerTrib.Caption := 'R$ COFINS:';
  end else
  begin
    lblCST_PIS_S_PerTrib.Caption    := '% PIS:';
    lblCST_COFINS_S_PerTrib.Caption := '% COFINS:';
  end;
end;

procedure TFrmPerfilTributacao.cboCST_PISCOFINS_E_PerTribChange(
  Sender: TObject);
begin
  Form7.ibdPerfilTributaCST_PIS_COFINS_ENTRADA.AsString := Copy(cboCST_PISCOFINS_E_PerTrib.Items[cboCST_PISCOFINS_E_PerTrib.ItemIndex]+'  ',1,2);
end;

procedure TFrmPerfilTributacao.edtDescricaoPerfilTribMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TSMALL_DBEdit do
  begin
    Hint := Field.DisplayLabel;
    ShowHint := True;
  end;
end;

procedure TFrmPerfilTributacao.FormShow(Sender: TObject);
begin
  inherited;
  pgcFicha.TabIndex := 0;

  if edtDescricaoPerfilTrib.CanFocus then
    edtDescricaoPerfilTrib.SetFocus;
end;

procedure TFrmPerfilTributacao.cboTipoItemPerfTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaTIPO_ITEM.AsString := Copy(cboTipoItemPerfTrib.Items[cboTipoItemPerfTrib.ItemIndex]+'  ',1,2);
end;

procedure TFrmPerfilTributacao.cboIPPTPerfTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaIPPT.AsString := Copy(cboIPPTPerfTrib.Items[cboIPPTPerfTrib.ItemIndex]+' ',1,1);
end;

procedure TFrmPerfilTributacao.cboIATPerfTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaIAT.AsString := Copy(cboIATPerfTrib.Items[cboIATPerfTrib.ItemIndex]+' ',1,1);
end;

procedure TFrmPerfilTributacao.cboOrigemPerfTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaCST.AsString := Copy(cboOrigemPerfTrib.Items[cboOrigemPerfTrib.ItemIndex]+' ',1,1)+Copy(Form7.ibdPerfilTributaCST.AsString+'  ',2,2);
  Form7.ibdPerfilTributaCST_NFCE.AsString := Copy(cboOrigemPerfTrib.Items[cboOrigemPerfTrib.ItemIndex]+' ',1,1)+Copy(Form7.ibdPerfilTributaCST_NFCE.AsString+'  ',2,2); // Mauricio Parizotto 2023-09-06
end;

procedure TFrmPerfilTributacao.cboCFOP_NFCePerfTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaCFOP.AsString := Copy(cboCFOP_NFCePerfTrib.Items[cboCFOP_NFCePerfTrib.ItemIndex]+'    ',1,4);
end;

procedure TFrmPerfilTributacao.cboCSOSN_NFCePerfilTribChange(
  Sender: TObject);
begin
  Form7.ibdPerfilTributaCSOSN_NFCE.AsString := Trim(Copy(cboCSOSN_NFCePerfilTrib.Items[cboCSOSN_NFCePerfilTrib.ItemIndex]+'   ',1,3));
end;

procedure TFrmPerfilTributacao.cboCST_NFCePerfilTribChange(
  Sender: TObject);
begin
  Form7.ibdPerfilTributaCST_NFCE.AsString := Copy(Form7.ibdPerfilTributaCST.AsString+' ',1,1)+Copy(cboCST_NFCePerfilTrib.Items[cboCST_NFCePerfilTrib.ItemIndex]+'   ',1,2);
end;

procedure TFrmPerfilTributacao.cboCSOSNPerfilTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaCSOSN.AsString := Trim(Copy(cboCSOSNPerfilTrib.Items[cboCSOSNPerfilTrib.ItemIndex]+'   ',1,3));
end;

procedure TFrmPerfilTributacao.cboCSTPerfilTribChange(Sender: TObject);
begin
  Form7.ibdPerfilTributaCST.AsString := Copy(Form7.ibdPerfilTributaCST.AsString+' ',1,1)+Copy(cboCSTPerfilTrib.Items[cboCSTPerfilTrib.ItemIndex]+'   ',1,2);
end;

procedure TFrmPerfilTributacao.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State = dsEdit then
    Exit;

  tbsIPIShow(Sender);
end;

end.
