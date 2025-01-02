unit uFrmCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls, uObjetoConsultaCEP, uConsultaCEP,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo, Winapi.ShellAPI, System.IniFiles, System.StrUtils, Videocap,
  Vcl.Imaging.jpeg, Vcl.ExtDlgs, Vcl.Clipbrd, Vcl.Grids, Vcl.DBGrids,
  IBX.IBCustomDataSet, IBX.IBQuery, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, MaskUtils,
  Generics.Collections;

type
  THackDBGrid = Class(TDBGrid);
  TFrmCadastro = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    tbsFoto: TTabSheet;
    Label2: TLabel;
    edtCPFCNPJ: TSMALL_DBEdit;
    Label3: TLabel;
    edtRazaoSocial: TSMALL_DBEdit;
    Label4: TLabel;
    edtContato: TSMALL_DBEdit;
    Label5: TLabel;
    edtCEP: TSMALL_DBEdit;
    Label6: TLabel;
    edtEndereco: TSMALL_DBEdit;
    imgEndereco: TImage;
    Label7: TLabel;
    edtBairro: TSMALL_DBEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtEstado: TSMALL_DBEdit;
    Label10: TLabel;
    edtRG_IE: TSMALL_DBEdit;
    Label11: TLabel;
    edtTelefone: TSMALL_DBEdit;
    Label12: TLabel;
    edtCelular: TSMALL_DBEdit;
    Label13: TLabel;
    edtWhatsApp: TSMALL_DBEdit;
    Label14: TLabel;
    edtEmail: TSMALL_DBEdit;
    Label15: TLabel;
    edtLimiteCredito: TSMALL_DBEdit;
    lblLimiteCredDisponivel: TLabel;
    eLimiteCredDisponivel: TEdit;
    Label16: TLabel;
    edtCadastro: TSMALL_DBEdit;
    Label17: TLabel;
    edtUltVenda: TSMALL_DBEdit;
    Label18: TLabel;
    edtNascido: TSMALL_DBEdit;
    lblConvenio: TLabel;
    Label19: TLabel;
    edtIdentificador1: TSMALL_DBEdit;
    Label20: TLabel;
    edtIdentificador2: TSMALL_DBEdit;
    Label21: TLabel;
    edtIdentificador3: TSMALL_DBEdit;
    Label22: TLabel;
    edtIdentificador4: TSMALL_DBEdit;
    Label23: TLabel;
    edtIdentificador5: TSMALL_DBEdit;
    Label25: TLabel;
    memObs: TDBMemo;
    Label26: TLabel;
    edtProxContato: TSMALL_DBEdit;
    Label27: TLabel;
    memContato: TDBMemo;
    fraConvenio: TfFrameCampo;
    fraMunicipio: TfFrameCampo;
    cboRelacaoCom: TComboBox;
    Label56: TLabel;
    pnl_IE: TPanel;
    rgIEContribuinte: TRadioButton;
    rgIENaoContribuinte: TRadioButton;
    rgIEIsento: TRadioButton;
    btnRenogiarDivida: TBitBtn;
    Image3: TImage;
    Image5: TImage;
    VideoCap1: TVideoCap;
    btnWebCam: TBitBtn;
    btnSelecionarArquivo: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    tbsComissao: TTabSheet;
    Label81: TLabel;
    Label82: TLabel;
    SMALL_DBEdit61: TSMALL_DBEdit;
    SMALL_DBEdit62: TSMALL_DBEdit;
    pnl_IE_PR: TPanel;
    chkProdRural: TDBCheckBox;
    tbsAddress: TTabSheet;
    PanelAddress: TPanel;
    DBGridAddress: TDBGrid;
    FDMemTableAddress: TFDMemTable;
    FDMemTableAddressIDENDERECO: TIntegerField;
    FDMemTableAddressIDCLIFOR: TIntegerField;
    FDMemTableAddressENDERECO: TStringField;
    DataSourceAddress: TDataSource;
    FDMemTableAddressTIPO: TStringField;
    FDMemTableAddressNUMERO: TStringField;
    FDMemTableAddressBAIRRO: TStringField;
    FDMemTableAddressCEP: TStringField;
    FDMemTableAddressCIDADE: TStringField;
    FDMemTableAddressTELEFONE: TStringField;
    FDMemTableAddressESTADO: TStringField;
    IBQueryCidades: TIBQuery;
    DataSourceCidades: TDataSource;
    FDMemTableAddressINVALID: TSmallintField;
    procedure FormShow(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure edtCEPEnter(Sender: TObject);
    procedure edtEnderecoExit(Sender: TObject);
    procedure edtBairroExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboRelacaoComChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgIEContribuinteClick(Sender: TObject);
    procedure rgIENaoContribuinteClick(Sender: TObject);
    procedure rgIEIsentoClick(Sender: TObject);
    procedure edtCPFCNPJChange(Sender: TObject);
    procedure edtLimiteCreditoExit(Sender: TObject);
    procedure imgEnderecoClick(Sender: TObject);
    procedure btnRenogiarDividaClick(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure Label19MouseLeave(Sender: TObject);
    procedure Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure memContatoEnter(Sender: TObject);
    procedure memContatoExit(Sender: TObject);
    procedure memContatoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtEstadoExit(Sender: TObject);
    procedure tbsFotoShow(Sender: TObject);
    procedure btnSelecionarArquivoClick(Sender: TObject);
    procedure btnWebCamClick(Sender: TObject);
    procedure edtEnderecoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtEmailKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtBairroKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbsComissaoEnter(Sender: TObject);
    procedure edtCPFCNPJExit(Sender: TObject);
    procedure chkProdRuralClick(Sender: TObject);
    procedure memObsEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FDMemTableAddressAfterInsert(DataSet: TDataSet);
    procedure FormDeactivate(Sender: TObject);
    procedure FDMemTableAddressTIPOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure FDMemTableAddressTIPOSetText(Sender: TField; const Text: string);
    procedure DBGridAddressKeyPress(Sender: TObject; var Key: Char);
    procedure DBGridAddressColExit(Sender: TObject);
    procedure DBGridAddressColEnter(Sender: TObject);
    procedure DataSourceAddressDataChange(Sender: TObject; Field: TField);
    procedure FDMemTableAddressESTADOChange(Sender: TField);
    procedure DBGridAddressKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridAddressCellClick(Column: TColumn);
    procedure FDMemTableAddressESTADOSetText(Sender: TField;
      const Text: string);
    procedure tbsAddressShow(Sender: TObject);
    procedure FDMemTableAddressAfterScroll(DataSet: TDataSet);
    procedure FDMemTableAddressAfterDelete(DataSet: TDataSet);
    procedure FDMemTableAddressBeforeInsert(DataSet: TDataSet);
    procedure FDMemTableAddressBeforePost(DataSet: TDataSet);
    procedure DBGridAddressDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    FOldCEPEnderecoAdicional: String;
    FPanelCities: TPanel;
    FDBGRidCities: TDBGrid;
    FLastIdCliFor: Integer;
    FcCEPAnterior: String;
    sContatos : String;
    sNomeDoJPG : string;
    bProximo  : boolean;
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure DefineCamposCEP(AoObjeto: TObjetoConsultaCEP);
    procedure LimpaEspaco(Campo : TSMALL_DBEdit);
    procedure AtualizaObjComValorDoBanco;
    procedure CarregaTipoContibuinte;
    procedure SetTipoContribuinte(iTipo: integer);
    procedure DefinirLimiteDisponivel;
    procedure AtualizaTela;
    function GetColumnIdByFieldName(AField: String): Integer;
    procedure LoadAddress();
    procedure PersistAddress();
    procedure FilterCity(AUf: String; APartialName: String = '');
    procedure SelectCity();
    procedure ShowGridCidade();
    procedure SetGridCidade();
    procedure DBGridCidadesCellClick(Column: TColumn);
    procedure DBGridCidadesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function ValidateCurrentAddress(SilentMode: Boolean = False): Boolean;
  public
    { Public declarations }
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.dfm}

uses unit7
  , uDialogs
  , uRetornaLimiteDisponivel
  , smallfunc_xe
  , uFuncoesBancoDados
  , MAIS
  , uFrmParcelas
  , MAIS3, uPermissaoUsuario
  , uFuncoesRetaguarda, uSmallEnumerados, uSmallConsts;

{ TFrmCadastro }

procedure TFrmCadastro.FDMemTableAddressAfterDelete(DataSet: TDataSet);
begin
  inherited;
  FPanelCities.Visible := False;
end;

procedure TFrmCadastro.FDMemTableAddressAfterInsert(DataSet: TDataSet);
begin
  inherited;
  if not(FDMemTableAddress.CachedUpdates) then
    Exit;

  FDMemTableAddressIDENDERECO.AsInteger :=
    IncGenerator(Form7.IBDatabase1, 'G_CLIFORENDERECOS').ToInteger;
  FDMemTableAddressTIPO.AsString := TipoEnderecoToString(teEntrega);
  DBGridAddress.SelectedIndex := 1;
end;

procedure TFrmCadastro.FDMemTableAddressAfterScroll(DataSet: TDataSet);
begin
  inherited;
  FOldCEPEnderecoAdicional := FDMemTableAddressCEP.AsString;
end;

procedure TFrmCadastro.FDMemTableAddressBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if not(FDMemTableAddress.CachedUpdates) then
    Exit;

  if not(ValidateCurrentAddress()) and not(FDMemTableAddress.IsEmpty) then
    Abort;
end;

procedure TFrmCadastro.FDMemTableAddressBeforePost(DataSet: TDataSet);
begin
  inherited;
  with TIBQuery.Create(nil) do
  begin
    try
      Database := Form7.IBDatabase1;
      SQL.Text := 'select 1 from rdb$database where '+
        ' exists (select 1 from municipios where nome = :nome and uf = :uf )';
      ParamByName('nome').AsString := FDMemTableAddressCIDADE.AsString;
      ParamByName('uf').AsString := FDMemTableAddressESTADO.AsString;
      Open();
      if not(Boolean(Fields[0].AsInteger)) then
      begin
        FDMemTableAddressCIDADE.AsString := '';
        FDMemTableAddressESTADO.AsString := '';
      end;
    finally
      Free;
    end;
  end;

  if trim(FDMemTableAddressCEP.AsString) = '-' then
    FDMemTableAddressCEP.AsString := '';

  if ValidateCurrentAddress() then
  begin
    FDMemTableAddressINVALID.AsInteger := Integer(False);
    Exit;
  end;

  FDMemTableAddressINVALID.AsInteger := Integer(True);

  if not(Visible) or not(FDMemTableAddress.CachedUpdates) or
  not(pgcFicha.ActivePage = tbsAddress) then
    Exit;

  if DBGridAddress.CanFocus then
    DBGridAddress.SetFocus();

  if (trim(FDMemTableAddressENDERECO.AsString) = '') and
    (trim(FDMemTableAddressNUMERO.AsString) = '') and
    (trim(FDMemTableAddressBAIRRO.AsString) = '') and
    (trim(FDMemTableAddressCEP.AsString) = '') and
    (trim(FDMemTableAddressCIDADE.AsString) = '') and
    (trim(FDMemTableAddressESTADO.AsString) = '') then
  begin
    if FDMemTableAddress.State = dsInsert then
    begin
      FDMemTableAddress.Cancel;
      Abort;
    end;
    FDMemTableAddress.Delete;
    Abort;
  end;


  raise Exception.Create('Endereço incompleto');
end;

procedure TFrmCadastro.FDMemTableAddressESTADOChange(Sender: TField);
begin
  inherited;

  if not(FDMemTableAddress.CachedUpdates) then
    Exit();

  if not(Sender.OldValue = Sender.AsString) then
    FDMemTableAddressCIDADE.Clear;
end;

procedure TFrmCadastro.FDMemTableAddressESTADOSetText(Sender: TField;
  const Text: string);
  function GetUF(AValue: String): String;
  begin
    Exit(Copy(AValue, 1, 2));
  end;
begin
  inherited;

  if not(FDMemTableAddress.CachedUpdates) then
    Exit();


  var Filtered: String;
  var Value := UpperCase(GetUF(Text));
  for var i := 1 to Length(Value) do
  begin
    if CharInSet(Value[i], ['A'..'Z']) then
      Filtered := Filtered + Value[i];
  end;

  Sender.AsString := '';
  var EstadoColumnID := GetColumnIdByFieldName('ESTADO');
  for var i := 0 to DBGridAddress.Columns[EstadoColumnId].PickList.Count - 1 do
  begin
    if not(GetUF(DBGridAddress.Columns[EstadoColumnId].PickList[i]) = Filtered) then
      Continue;

    Sender.AsString := Filtered;
  end;
end;

procedure TFrmCadastro.FDMemTableAddressTIPOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  inherited;
  if LimpaNumero(Sender.AsString) = '' then
  begin
    Text := '';
    Exit;
  end;

  Text := TipoEnderecoToStrText(
    TTipoEndereco(Sender.AsInteger)
  );
end;

procedure TFrmCadastro.FDMemTableAddressTIPOSetText(Sender: TField;
  const Text: string);
begin
  inherited;
  var Ok: boolean;
  Sender.AsString := TipoEnderecoToString(StrTextTipoEndereco(Ok, Text));
end;

procedure TFrmCadastro.FilterCity(AUf, APartialName: String);
begin
  if not(FDMemTableAddress.CachedUpdates) then
    Exit;

  var FilterByName := '';
  APartialName := AnsiUpperCase(Trim(APartialName));
  if not(APartialName = '') then
    FilterByName := 'and upper('+GetTmpCharacterSet('nome')+') like upper(:nome)';

  IBQueryCidades.DisableControls;
  try
    IBQueryCidades.Close();
    IBQueryCidades.SQL.Text := 'select codigo, uf, nome '+
      'from municipios '+
      'where uf = :uf '+FilterByName+
      'order by nome';
    if not(APartialName = '') then
      IBQueryCidades.ParamByName('nome').AsString := '%'+APartialName+'%';
    IBQueryCidades.ParamByName('uf').AsString := AUf;
    IBQueryCidades.Open;
  finally
    IBQueryCidades.EnableControls;
  end;

  IBQueryCidades.Open;
end;

procedure TFrmCadastro.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  FreeAndNil(FrmCadastro);
end;

procedure TFrmCadastro.FormCreate(Sender: TObject);
begin
  cboRelacaoCom.Clear;
  cboRelacaoCom.Items.Add('');
  cboRelacaoCom.Items.Add('Cliente');
  cboRelacaoCom.Items.Add('Fornecedor');
  cboRelacaoCom.Items.Add('Cliente/Fornecedor');
  cboRelacaoCom.Items.Add('Funcionário');
  cboRelacaoCom.Items.Add('Revenda');
  cboRelacaoCom.Items.Add('Representante');
  cboRelacaoCom.Items.Add('Distribuidor');
  cboRelacaoCom.Items.Add('Vendedor');
  cboRelacaoCom.Items.Add('Credenciadora de cartão');
  cboRelacaoCom.Items.Add('Instituição financeira');
  cboRelacaoCom.Items.Add('Marketplace');
  cboRelacaoCom.Items.Add('Revenda Inativa'); // adicionadas para uso na Smallsoft
  cboRelacaoCom.Items.Add('Cliente Inativo'); // adicionadas para uso na Smallsoft
  cboRelacaoCom.Sorted := True;

  pnl_IE_PR.Top  := pnl_IE.Top;
  pnl_IE_PR.Left := pnl_IE.Left;

  FLastIdCliFor := 0;

  var ColumnId := GetColumnIdByFieldName('TIPO');
  DBGridAddress.Columns[ColumnId].PickList.Clear;
  for var t := Low(TTipoEndereco) to High(TTipoEndereco) do
  begin
    if not(t = teEntrega) then
      continue;
    DBGridAddress.Columns[ColumnId].PickList.Add(TipoEnderecoToStrText(t));
  end;

  ColumnId := GetColumnIdByFieldName('ESTADO');
  for var I := 0 to High(UF_NAMES) do
    DBGridAddress.Columns[ColumnId].PickList.Add(UF_ACRONYM[I]+' '+UF_NAMES[I]);

  SetGridCidade();

  inherited
end;

procedure TFrmCadastro.FormDeactivate(Sender: TObject);
begin
  inherited;
  PersistAddress();
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
begin
  inherited;

  try
    Label19.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR1').DisplayLabel + ':';
    Label20.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR2').DisplayLabel + ':';
    Label21.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR3').DisplayLabel + ':';
    Label22.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR4').DisplayLabel + ':';
    Label23.Caption := DSCadastro.DataSet.FieldByName('IDENTIFICADOR5').DisplayLabel + ':';
  except
  end;

  pgcFicha.ActivePage := tbsCadastro;

  if edtCPFCNPJ.Canfocus then
    edtCPFCNPJ.SetFocus;

  tbsComissao.TabVisible := Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor');
  FPanelCities.Visible := False;

end;

function TFrmCadastro.GetColumnIdByFieldName(AField: String): Integer;
begin
  for var i := 0 to DBGridAddress.Columns.Count-1 do
    if UpperCase(DBGridAddress.Columns[i].FieldName) = UpperCase(AField) then
      Exit(I);
end;

function TFrmCadastro.GetPaginaAjuda: string;
begin
  if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
    Result := 'config_vendedores.htm'
  else
    Result := 'clifor.htm';
end;

procedure TFrmCadastro.imgEnderecoClick(Sender: TObject);
begin
    ShellExecute( 0, 'Open',pChar('https://www.google.com.br/maps/dir//'+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2ENDERE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2COMPLE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2CEP.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2CIDADE.AsString))+' - '+
                Trim(ConverteAcentosPHP(Form7.ibDataSet2ESTADO.AsString))+' '
                ),'', '', SW_SHOWMAXIMIZED);
end;

procedure TFrmCadastro.Label19Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  with Sender as TLabel do
  begin
    FrmCadastro.SendToBack; //Mauricio Parizotto 2024-08-15
    sNome   := StrTran(Trim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),':','');
    FrmCadastro.BringToFront;
    Caption := sNome+':';
    Repaint;

    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString(Form7.sModulo,NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TFrmCadastro.Label19MouseLeave(Sender: TObject);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [];
      Font.Color := clBlack;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmCadastro.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;

  try
    if edtCPFCNPJ.CanFocus then
      edtCPFCNPJ.SetFocus;
  except
  end;
end;

procedure TFrmCadastro.SelectCity;
begin
  if not(IBQueryCidades.Active) then
    Exit;

  if FDMemTableAddress.State = dsBrowse then
    FDMemTableAddress.Edit;

  if not(FDMemTableAddressESTADO.AsString = IBQueryCidades.FieldByName('UF').AsString) then
    FDMemTableAddressESTADO.AsString := IBQueryCidades.FieldByName('UF').AsString;
  FDMemTableAddressCIDADE.AsString := IBQueryCidades.FieldByName('nome').AsString;

  FPanelCities.Visible := False;
  DBGridAddress.SetFocus;
  DBGridAddress.SelectedIndex := GetColumnIdByFieldName('TELEFONE');
end;

procedure TFrmCadastro.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtCPFCNPJ.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtRazaoSocial.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtContato.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCEP.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEndereco.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtBairro.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraMunicipio.Enabled          := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEstado.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtRG_IE.Enabled              := not(bEstaSendoUsado) and not (bSomenteLeitura) and (Form7.IBDataSet2CONTRIBUINTE.AsString <> '2');
  pnl_IE.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  chkProdRural.Enabled          := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtTelefone.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCelular.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtWhatsApp.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEmail.Enabled              := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtLimiteCredito.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  eLimiteCredDisponivel.Enabled := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCadastro.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtUltVenda.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNascido.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraConvenio.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador1.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador2.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador3.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador4.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtIdentificador5.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memObs.Enabled                := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtProxContato.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  memContato.Enabled            := not(bEstaSendoUsado) and not (bSomenteLeitura);
  cboRelacaoCom.Enabled         := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnWebCam.Enabled             := not(bEstaSendoUsado) and not (bSomenteLeitura);
  btnSelecionarArquivo.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);


  if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
  begin
    cboRelacaoCom.Enabled := False;
  end;
end;

procedure TFrmCadastro.SetGridCidade();
begin
  FPanelCities := TPanel.Create(Self);
  FDBGRidCities := TDBGrid.Create(Self);

  with FPanelCities do
  begin
    Parent := Self;
    BevelOuter := bvNone;
    Caption := '';
    Padding.SetBounds(1, 1, 1, 1);
    ParentBackground := False;
    Visible := True;
    Height := 100;
  end;

  with FDBGRidCities do
  begin
    Parent := FPanelCities;
    Align := alClient;
    DataSource := DataSourceCidades;
    Font.Height := -11;
    Font.Name := 'Roboto';
    Font.Style := [];
    Options := [dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit];
    ReadOnly := True;
    OnCellClick := DBGridCidadesCellClick;
    OnKeyDown := DBGridCidadesKeyDown;
    Visible := True;
    var ColumnCity := Columns.Add;
    ColumnCity.FieldName := 'NOME';
    ColumnCity.Width := 180;
    ColumnCity.Expanded := False;
  end;
end;

procedure TFrmCadastro.edtEmailExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEmailKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtLimiteCreditoExit(Sender: TObject);
begin
  DefinirLimiteDisponivel;
end;

procedure TFrmCadastro.edtCEPEnter(Sender: TObject);
begin
  FcCEPAnterior := TSMALL_DBEdit(Sender).Text;
end;

procedure TFrmCadastro.edtCEPExit(Sender: TObject);
begin
  {Dailon (f-7224) 2024-04-01 inicio}
  if (FcCEPAnterior <> TSMALL_DBEdit(Sender).Text) then
  begin
    try
      DefineCamposCEP(TConsultaCEP.New
                                  .setCEP(TSMALL_DBEdit(Sender).Text)
                                  .SolicitarDados
                                  .getObjeto
                     );
    except
      on e:exception do
        MensagemSistema(e.Message, msgAtencao);
    end;
  end;
  {Dailon (f-7224) 2024-04-01 Fim}
end;

procedure TFrmCadastro.edtEnderecoExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEnderecoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtBairroExit(Sender: TObject);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtBairroKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  LimpaEspaco(TSMALL_DBEdit(Sender));
end;

procedure TFrmCadastro.edtEstadoExit(Sender: TObject);
begin
  if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
  begin
    fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
  end else
  begin
    fraMunicipio.sFiltro := ' ';
  end;
end;

procedure TFrmCadastro.tbsAddressShow(Sender: TObject);
begin
  inherited;
  DBGridAddress.SelectedIndex := GetColumnIdByFieldName('CEP');
  if FDMemTableAddress.Active then
  begin
    if FDMemTableAddress.IsEmpty then
      FDMemTableAddress.Insert
    else
      FDMemTableAddress.First;
  end;
end;

procedure TFrmCadastro.tbsComissaoEnter(Sender: TObject);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then 
      Form7.ibDataset2.Edit;
      
    Form7.IBDataSet2.Post;
    Form7.IBDataSet2.Edit;
  except
  end;
end;

procedure TFrmCadastro.tbsFotoShow(Sender: TObject);
begin
  sNomeDoJPG := Form1.sAtual+'\tempo1'+Form7.IBDataSet2REGISTRO.AsString+'.jpg';

  btnWebCam.Caption      := '&Webcam';
  VideoCap1.visible      := False;
  Image5.Visible         := True;
  AtualizaTela;
end;

function TFrmCadastro.ValidateCurrentAddress(SilentMode: Boolean): Boolean;
begin
  var ListOfFields := TList<String>.Create;
  var FieldLimits := TDictionary<String, Integer>.Create;
  var Limit := 0;
  try
    ListOfFields.AddRange(['ENDERECO', 'NUMERO', 'BAIRRO', 'ESTADO', 'CIDADE']);
    FieldLimits.Add('NUMERO', 1);
    FieldLimits.Add('ESTADO', 2);

    for var Field in ListOfFields do
    begin
      if not FieldLimits.TryGetValue(Field, Limit) then
        Limit := 2;

      if Trim(FDMemTableAddress.FieldByName(Field).AsString).Length < Limit then
      begin
        if not(SilentMode) then
          DBGridAddress.SelectedIndex := GetColumnIdByFieldName(Field);
        Exit(False);
      end;
    end;
  finally
    ListOfFields.Free;
  end;

  Result := True;
end;

procedure TFrmCadastro.cboRelacaoComChange(Sender: TObject);
begin
  DSCadastro.DataSet.Edit;
  DSCadastro.DataSet.FieldByName('CLIFOR').AsString := cboRelacaoCom.Text;

  if Form7.ibDataSet9NOME.AsString =  Form7.ibDataSet2NOME.AsString then
  begin
    if Form7.ibDataSet2CLIFOR.AsString <> 'Vendedor' then
    begin
      Form7.ibDataSet9.Delete;
    end else
    begin
      Form7.ibDataSet9.Append;
      Form7.IBDataSet9NOME.AsString := Form7.IBDataSet2NOME.AsString;
      Form7.ibDataSet9.Post;
    end;
  end;

  if Form7.ibDataSet2CLIFOR.AsString = 'Marketplace' then
  begin
    if Trim(RetornaValorDaTagNoCampo('idCadIntTran',Form7.ibDataSet2OBS.AsString)) = '' then
    begin
      Form7.ibDataSet2OBS.AsString := Trim(Form7.ibDataSet2OBS.AsString) + '<idCadIntTran>0000</idCadIntTran>'
    end;
  end else
  begin
    Form7.ibDataSet2OBS.AsString := StringReplace(Form7.ibDataSet2OBS.AsString,'<idCadIntTran>0000</idCadIntTran>','',[rfReplaceAll]);
  end;

end;

procedure TFrmCadastro.chkProdRuralClick(Sender: TObject);
begin
  if chkProdRural.Checked then
  begin
    if Copy(DSCadastro.DataSet.FieldByName('IE').AsString,1,2) <> 'PR' then
      DSCadastro.DataSet.FieldByName('IE').AsString := 'PR'+Trim(Copy(DSCadastro.DataSet.FieldByName('IE').AsString,1,14));
  end else
  begin
    if Copy(Trim(DSCadastro.DataSet.FieldByName('IE').AsString),1,2) = 'PR' then
      DSCadastro.DataSet.FieldByName('IE').AsString := Trim(Copy(DSCadastro.DataSet.FieldByName('IE').AsString, 3,16) );
  end;
end;

procedure TFrmCadastro.memContatoEnter(Sender: TObject);
begin
  sContatos := Form7.IBDataSet2CONTATOS.AsString;

  if Form7.ArquivoAberto.Modified then
    Form7.ArquivoAberto.Post;

  Form7.ArquivoAberto.Edit;

  SendMessage(memContato.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  SendMessage(memContato.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  memContato.SelStart := Length(memContato.Text); //move o cursor pra o final da ultima linha
  memContato.SetFocus;
end;

procedure TFrmCadastro.memContatoExit(Sender: TObject);
begin
  if StrTran(StrTran(StrTran(Form7.IBDataSet2CONTATOS.AsString,chr(10),''),chr(13),''),' ','') <> StrTran(StrTran(StrTran(sContatos,chr(10),''),chr(13),''),' ','') then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2CONTATOS.AsString := Form7.IBDataSet2CONTATOS.AsString +chr(10) +'('+Senhas.UsuarioPub+') '+StrZero(Year(Date),4,0)+'-'+StrZero(Month(Date),2,0)+'-'+StrZero(day(Date),2,0)+' '+TimeToStr(Time);

    // Comercial da Small está perdendo dados de contatos
    if Form7.ibDataSet13CGC.AsString = CNPJ_SMALLSOFT then
      Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy(Form7.IBDataSet2NOME.AsString, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
  end;

  begin
    try
      if Form7.ArquivoAberto.Modified then Form7.ArquivoAberto.Post;
    except
      on E: Exception do
      begin
        // Comercial da Small está perdendo dados de contatos
        if AnsiContainsText(E.Message, 'deadlock') then
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, 'Conflito L3729 ' + RightStr(E.Message, 50),0,0) // Ato, Modulo, Usuário, Histórico, Valor
        else
          Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Copy('Salvar contatos L3731 ' + E.Message, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor

        MensagemSistema('Não foi possível gravar o assunto do contato - Este registro está sendo usado por outro usuário.',msgAtencao);
        Form7.ArquivoAberto.Cancel;
      end;
    end;

    Form7.ArquivoAberto.Edit;
  end;
end;

procedure TFrmCadastro.memContatoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Key := 0;
      Perform(Wm_NextDlgCtl,0,0);
    end
    else
      bProximo := True;
  end
  else
  	bProximo := False;
end;

procedure TFrmCadastro.memObsEnter(Sender: TObject);
begin
  //Mauricio Parizotto - SMAL-629
  Form7.ibDataSet2OBS.AsString := StringReplace(Form7.ibDataSet2OBS.AsString,#13#10#13#10,#13#10,[rfReplaceAll]);
  Form7.ibDataSet2OBS.AsString := StringReplace(Form7.ibDataSet2OBS.AsString,#13#10#13#10,#13#10,[rfReplaceAll]);

  //Mauricio Parizotto 2024-08-02
  SendMessage(memObs.Handle, WM_VSCROLL, SB_BOTTOM, 0); //vai pra ultima linha
  //SendMessage(memObs.Handle, WM_HSCROLL, SB_RIGHT, 0); //vai pra ultima coluna
  memObs.SelStart := Length(memObs.Text); //move o cursor pra o final da ultima linha
end;

procedure TFrmCadastro.PersistAddress();
begin
  if not(FDMemTableAddress.Active) then
    Exit;

  if FDMemTableAddress.State in ([dsEdit, dsInsert]) then
  begin
    if (FDMemTableAddressENDERECO.Text = '') and
      (FDMemTableAddressESTADO.Text = '') and
      (FDMemTableAddressCIDADE.Text = '') then
      FDMemTableAddress.Cancel
    else
      FDMemTableAddress.Post;
  end;

  if FDMemTableAddress.ChangeCount = 0 then
    Exit;

  FDMemTableAddress.DisableControls;

  var MainID := DSCadastro.DataSet.FieldByName('IDCLIFOR').AsInteger;
  var OldFilterChanges := FDMemTableAddress.FilterChanges;
  var Qry := TIBQuery.Create(nil);
  try
    Qry.Database := Form7.IBDatabase1;
    Qry.Transaction := Form7.IBTransaction1;
    FDMemTableAddress.FilterChanges := [rtModified, rtInserted, rtDeleted];

    FDMemTableAddress.First;
    while not FDMemTableAddress.Eof do
    begin
      case FDMemTableAddress.UpdateStatus of
        usInserted, usModified:
          begin
            Qry.SQL.Text := 'UPDATE OR INSERT INTO CLIFORENDERECOS '+
             ' (IDENDERECO, IDCLIFOR, TIPO, ENDERECO, NUMERO, BAIRRO, '+
             '  CEP, CIDADE, ESTADO, TELEFONE) '+
             ' VALUES  '+
             ' (:IDENDERECO, :IDCLIFOR, :TIPO, :ENDERECO, :NUMERO, :BAIRRO, '+
             ' :CEP, :CIDADE, :ESTADO, :TELEFONE) '+
             ' MATCHING (IDENDERECO) '+
             ' RETURNING IDENDERECO;';
            Qry.ParamByName('IDENDERECO').AsInteger :=  FDMemTableAddressIDENDERECO.AsInteger;
            Qry.ParamByName('IDCLIFOR').AsInteger := MainID;
            Qry.ParamByName('ENDERECO').AsString := FDMemTableAddressENDERECO.AsString;
            Qry.ParamByName('TIPO').AsString := FDMemTableAddressTIPO.AsString;
            Qry.ParamByName('NUMERO').AsString := FDMemTableAddressNUMERO.AsString;
            Qry.ParamByName('BAIRRO').AsString := FDMemTableAddressBAIRRO.AsString;
            Qry.ParamByName('CEP').AsString := FDMemTableAddressCEP.AsString;
            Qry.ParamByName('CIDADE').AsString := FDMemTableAddressCIDADE.AsString;
            Qry.ParamByName('ESTADO').AsString := FDMemTableAddressESTADO.AsString;
            Qry.ParamByName('TELEFONE').AsString :=
              LimpaNumero(FDMemTableAddressTELEFONE.AsString);
            Qry.ExecSQL;
          end;
        usDeleted:
          begin
            Qry.SQL.Text := 'delete from CLIFORENDERECOS '+
              ' where IDENDERECO = :IDENDERECO';
            Qry.ParamByName('IDENDERECO').AsInteger :=
              FDMemTableAddressIDENDERECO.AsInteger;
            Qry.ExecSQL;
          end;
      end;
      FDMemTableAddress.Next;
    end;
  finally
    Qry.Free;
    FDMemTableAddress.CommitUpdates;
    FDMemTableAddress.FilterChanges := OldFilterChanges;
    FDMemTableAddress.EnableControls;
  end;
end;

procedure TFrmCadastro.DataSourceAddressDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  if Assigned(Field) and (UpperCase(Field.FieldName) = 'ESTADO') then
    FilterCity(FDMemTableAddressESTADO.AsString);
end;

procedure TFrmCadastro.DBGridAddressCellClick(Column: TColumn);
begin
  inherited;
  ShowGridCidade();
end;

procedure TFrmCadastro.DBGridAddressColEnter(Sender: TObject);
begin
  inherited;
  if DBGridAddress.SelectedIndex = GetColumnIdByFieldName('CEP') then
  begin
    FOldCEPEnderecoAdicional := FDMemTableAddressCEP.AsString;
    Exit();
  end;

  if (DBGridAddress.SelectedIndex = GetColumnIdByFieldName('CIDADE')) and
    (FDMemTableAddressESTADO.AsString = 'EX') then
  begin
    if (FDMemTableAddress.State in [dsEdit, dsInsert]) then
    begin
      FDMemTableAddressCIDADE.AsString := 'Exterior';
      DBGridAddress.SelectedIndex := GetColumnIdByFieldName('TELEFONE');
    end;
    Exit();
  end;

  ShowGridCidade;
end;

procedure TFrmCadastro.DBGridAddressColExit(Sender: TObject);
begin
  inherited;
  FPanelCities.Visible := False;
  var CEPIndex := GetColumnIdByFieldName('CEP');
  if DBGridAddress.SelectedIndex = CEPIndex then
  begin
    if FOldCEPEnderecoAdicional = FDMemTableAddressCEP.AsString then
      Exit;

    try
      var ObjConsultaCEP := TConsultaCEP
        .New
        .setCEP(FDMemTableAddressCEP.Text)
        .SolicitarDados
        .getObjeto;

      if ObjConsultaCEP = nil then
        Exit;

      if FDMemTableAddress.State = dsBrowse then
        FDMemTableAddress.Edit;

      FDMemTableAddressENDERECO.AsString := ObjConsultaCEP.logradouro;
      FDMemTableAddressBAIRRO.AsString := ObjConsultaCEP.bairro;
      FDMemTableAddressESTADO.AsString := ObjConsultaCEP.uf;
      FDMemTableAddressCIDADE.AsString := ObjConsultaCEP.localidade;
    except
      on e:exception do
      begin
        DBGridAddress.SelectedIndex := CEPIndex;
        raise Exception.Create(e.Message);
      end;
    end;
  end;

  if (FDMemTableAddress.State = dsEdit) then
    FDMemTableAddressINVALID.AsInteger := Integer(not(ValidateCurrentAddress()))
end;

procedure TFrmCadastro.DBGridAddressDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);

  function GetColor(): TColor;
  begin
    if Boolean(FDMemTableAddressInvalid.AsInteger) then
      Exit($00D9D9FF);

    Result := clWhite;
  end;

begin
  inherited;
  DBGridAddress.Canvas.Brush.Color := GetColor();
  DBGridAddress.DefaultDrawDataCell(Rect, Column.Field, State);
end;

procedure TFrmCadastro.DBGridAddressKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  if (Key = VK_DELETE) and
  (DBGridAddress.SelectedIndex = GetColumnIdByFieldName('CIDADE')) and
  not(FDMemTableAddressCIDADE.AsString = '') then
  begin
    if FDMemTableAddress.State = dsBrowse then
      FDMemTableAddress.Edit;
    FDMemTableAddressCIDADE.AsString := '';
    FilterCity(FDMemTableAddressESTADO.AsString);
    ShowGridCidade();
    Exit;
  end;

  if (Key = VK_DELETE) and not(DBGridAddress.EditorMode) then
  begin
    FDMemTableAddress.Delete();
    if (Shift = [SsCtrl]) and (key = VK_DELETE) then
      key := 0;
    Exit;
  end;

  if (Key in [VK_DOWN, VK_RETURN]) and
    (DBGridAddress.SelectedIndex = GetColumnIdByFieldName('CIDADE')) then
  begin
    if (FPanelCities.Visible) and (DBGridAddress.CanFocus) then
      FDBGRidCities.SetFocus;
    Key := 0;
    Abort;
  end;
end;

procedure TFrmCadastro.DBGridAddressKeyPress(Sender: TObject; var Key: Char);
var
  Input: String;
begin
  inherited;
  if (Key = #13) then
  begin
    if FPanelCities.Visible then
      Exit();

    Key := #0;
    with TDBGrid(Sender) do
    begin
      if not (dgEditing in Options) then
        Options := Options + [dgEditing];

      if SelectedIndex < FieldCount - 1 then
        SelectedIndex := SelectedIndex + 1
      else
      begin
        if not DataSource.DataSet.Eof then
          DataSource.DataSet.Next;

        if (DataSource.DataSet.Eof) and
          not(trim(FDMemTableAddressENDERECO.Text) = '') then
          DataSource.DataSet.Append;

        SelectedIndex := 1;
      end;

    end;
    Exit();
  end;

  var Field := TDBGrid(Sender).SelectedField;
  if not(Assigned(Field)) then
    Exit();

  if Field.FieldName = 'TIPO' then
  begin
    Key := #0;
    Exit;
  end;

  if Field.FieldName = 'TELEFONE' then
  begin
    if not(Key in ['0'..'9', #8]) then
      Abort;

    if (FDMemTableAddress.State = dsBrowse) and not(FDMemTableAddress.IsEmpty) then
      FDMemTableAddress.Edit;

    Input := LimpaNumero(Field.AsString);

    if Key <> #8 then
      Input := Input + Key
    else if Length(Input) > 0 then
      Delete(Input, Length(Input), 1);

    var Formatted := '';
    for var i := 1 to Input.Length do
    begin
      Formatted := Formatted + Input[i];
      if i = 1 then
        Formatted := '('+Formatted;
      if i = 2 then
        Formatted := Formatted+') ';
      if (i = 6) and (Input.Length <= 10) then
        Formatted := Formatted+'-';
      if (i = 7) and (Input.Length = 11) then
        Formatted := Formatted+'-'
    end;

    Field.AsString := Formatted;
    Key := #0;
    Exit;
  end;

  if Field.FieldName = 'CIDADE' then
  begin
    Input := Field.AsString;

    if Key <> #8 then
      Input := Input + Key
    else if Length(Input) > 0 then
      Delete(Input, Length(Input), 1);

    FilterCity(FDMemTableAddressESTADO.AsString, Input);

    if (FDMemTableAddress.State = dsBrowse) and not(FDMemTableAddress.IsEmpty) then
      FDMemTableAddress.Edit;

    Field.AsString := Input;

    Key := #0;
  end;

end;

procedure TFrmCadastro.DBGridCidadesCellClick(Column: TColumn);
begin
  inherited;
  SelectCity();
end;

procedure TFrmCadastro.DBGridCidadesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    SelectCity();
end;

procedure TFrmCadastro.DefineCamposCEP(AoObjeto: TObjetoConsultaCEP);
begin
  if not Assigned(AoObjeto) then
    Exit;

  // Endereço
  DSCadastro.DataSet.FieldByName('ENDERE').AsString := Copy(AoObjeto.logradouro,1, DSCadastro.DataSet.FieldByName('ENDERE').Size);

  // Bairro
  DSCadastro.DataSet.FieldByName('COMPLE').AsString := Copy(AoObjeto.bairro,1, DSCadastro.DataSet.FieldByName('COMPLE').Size);

  // Municipio
  if DSCadastro.DataSet.FieldByName('CIDADE').Asstring <> AoObjeto.localidade then
    DSCadastro.DataSet.FieldByName('CIDADE').AsString := Copy(AoObjeto.localidade,1, DSCadastro.DataSet.FieldByName('CIDADE').Size);

  // Estado
  if DSCadastro.DataSet.FieldByName('ESTADO').AsString <> AoObjeto.uf then
    DSCadastro.DataSet.FieldByName('ESTADO').AsString := Copy(AoObjeto.uf,1, DSCadastro.DataSet.FieldByName('ESTADO').Size);

  //Carrega componente
  try
    if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
    begin
      fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
    end else
    begin
      fraMunicipio.sFiltro := ' ';
    end;

    fraMunicipio.CarregaDescricao;
  except
  end;
end;

procedure TFrmCadastro.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if Field = nil then
    PersistAddress();

  //Mauricio Parizotto 2024-08-29
  if not Self.Visible then
    Exit;

  if Field = nil then
    LoadAddress();

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  if bGravandoRegistro then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmCadastro.edtCPFCNPJChange(Sender: TObject);
begin
  pnl_IE.Visible    := (Length(Trim(form7.ibDAtaset2CGC.AsString)) = 18); //Mauricio Parizotto 2024-04-15
  pnl_IE_PR.Visible := (Length(Trim(form7.ibDAtaset2CGC.AsString)) = 14); //Mauricio Parizotto 2024-06-27
end;

procedure TFrmCadastro.edtCPFCNPJExit(Sender: TObject);
begin
  try
    fraMunicipio.CarregaDescricao;
  except
  end;
end;

procedure TFrmCadastro.LimpaEspaco(Campo : TSMALL_DBEdit);
begin
  if (Copy(Campo.Text,1,1) = ' ') then
  begin
    if not (Campo.Field.DataSet.State in [dsEdit, dsInsert]) then
    begin
      Campo.Field.DataSet.Edit;
      Campo.Text := Trim(Campo.Text);
      Campo.Field.DataSet.Post;
    end else
      Campo.Text := Trim(Campo.Text);
  end;
end;

procedure TFrmCadastro.LoadAddress();
begin

  var CurrentIdCliFor := DSCadastro.DataSet.FieldByName('IDCLIFOR').AsInteger;

  if CurrentIdCliFor = FLastIdCliFor then
    Exit;

  if not(FDMemTableAddress.Active) then
    FDMemTableAddress.CreateDataSet;

  FDMemTableAddress.EmptyDataSet;
  FDMemTableAddress.CachedUpdates := False;
  var qryAddress := TIBQuery.Create(nil);
  try
    qryAddress.Database := Form7.IBDatabase1;
    qryAddress.SQL.Text := 'select * from CLIFORENDERECOS '+
      'where idclifor = :idclifor '+
      ' order by idendereco';
    qryAddress.ParamByName('idclifor').AsInteger :=
      DSCadastro.DataSet.FieldByName('idclifor').AsInteger;
    qryAddress.Open;

    while not(qryAddress.Eof) do
    begin
      FDMemTableAddress.Append;
      FDMemTableAddressIDENDERECO.AsInteger := qryAddress.FieldByName('IDENDERECO').AsInteger;
      FDMemTableAddressIDCLIFOR.AsInteger := qryAddress.FieldByName('IDCLIFOR').AsInteger;
      FDMemTableAddressENDERECO.AsString := qryAddress.FieldByName('ENDERECO').AsString;
      FDMemTableAddressTIPO.AsString := qryAddress.FieldByName('TIPO').AsString;
      FDMemTableAddressNUMERO.AsString := qryAddress.FieldByName('NUMERO').AsString;
      FDMemTableAddressBAIRRO.AsString := qryAddress.FieldByName('BAIRRO').AsString;
      FDMemTableAddressCEP.AsString := qryAddress.FieldByName('CEP').AsString;
      FDMemTableAddressCIDADE.AsString := qryAddress.FieldByName('CIDADE').AsString;
      FDMemTableAddressESTADO.AsString := qryAddress.FieldByName('ESTADO').AsString;
      var PhoneNumber := LimpaNumero(qryAddress.FieldByName('TELEFONE').AsString);
      if not(PhoneNumber = '') then
      begin
        var PhoneMask := '!(99) 9999-9999;0;';
        if qryAddress.FieldByName('TELEFONE').AsString.Length = 11 then
          PhoneMask := '!(99) 99999-9999;0;';
        FDMemTableAddressTELEFONE.AsString :=
          FormatMaskText(PhoneMask, PhoneNumber);
      end;
      FDMemTableAddress.Post;
      qryAddress.Next;
    end;

  finally
    FLastIdCliFor := CurrentIdCliFor;
    qryAddress.Free;
    FDMemTableAddress.CachedUpdates := True;
  end;
end;

procedure TFrmCadastro.rgIEContribuinteClick(Sender: TObject);
begin
  SetTipoContribuinte(1);
end;

procedure TFrmCadastro.rgIEIsentoClick(Sender: TObject);
begin
  SetTipoContribuinte(2);
end;

procedure TFrmCadastro.rgIENaoContribuinteClick(Sender: TObject);
begin
  SetTipoContribuinte(9);
end;

procedure TFrmCadastro.AtualizaObjComValorDoBanco;
var
  ValorPagar : double;
begin
  //Se não estiver ativo não carrega informações
  if not FormularioAtivo(Self) then
    Exit;

  cboRelacaoCom.ItemIndex := cboRelacaoCom.Items.IndexOf(Form7.ibDataSet2CLIFOR.AsString);

  if Form7.sWhere  = 'where CLIFOR='+QuotedStr('Vendedor') then
    cboRelacaoCom.ItemIndex := cboRelacaoCom.Items.IndexOf('Vendedor');

  pnl_IE.Visible                  := (Length(trim(Form7.ibDAtaset2CGC.AsString)) = 18);
  pnl_IE_PR.Visible               := (Length(Trim(form7.ibDAtaset2CGC.AsString)) = 14); //Mauricio Parizotto 2024-06-27

  Self.Caption := form7.ibDataSet2NOME.AsString;

  DefinirLimiteDisponivel;

  CarregaTipoContibuinte;

  //Convenio
  try
    fraConvenio.TipoDePesquisa               := tpLocate;
    fraConvenio.GravarSomenteTextoEncontrato := True;
    fraConvenio.CampoVazioAbrirGridPesquisa  := True;
    fraConvenio.CampoCodigo                  := Form7.ibDataSet2CONVENIO;
    fraConvenio.CampoCodigoPesquisa          := 'NOME';
    fraConvenio.sCampoDescricao              := 'NOME';
    fraConvenio.sTabela                      := 'CONVENIO';
    fraConvenio.CarregaDescricao;
  except
  end;

  //Município
  try
    fraMunicipio.TipoDePesquisa               := tpSelect;
    fraMunicipio.GravarSomenteTextoEncontrato := True;
    fraMunicipio.CampoVazioAbrirGridPesquisa  := True;
    fraMunicipio.CampoCodigo                  := Form7.ibDataSet2CIDADE;
    fraMunicipio.CampoCodigoPesquisa          := 'NOME';
    fraMunicipio.sCampoDescricao              := 'NOME';
    fraMunicipio.sTabela                      := 'MUNICIPIOS';

    if Length(Trim(Form7.IBDataSet2ESTADO.AsString)) = 2 then
    begin
      fraMunicipio.sFiltro := ' and UF='+QuotedStr(Form7.IBDataSet2ESTADO.AsString);
    end else
    begin
      fraMunicipio.sFiltro := ' ';
    end;

    fraMunicipio.CarregaDescricao;
  except
  end;

  //Botão renegociar divida
  btnRenogiarDivida.Visible := False;
  
  if Trim(Form7.IBDataSet2NOME.AsString) <> '' then
  begin
    ValorPagar := ExecutaComandoEscalar(Form7.IBTransaction1,
                                        ' Select Coalesce(sum(VALOR_DUPL),0) as TOTAL '+
                                       ' From RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0');

    if ValorPagar <> 0 then
    begin
      if Form1.imgVendas.Visible then
      begin
        btnRenogiarDivida.Visible := True;
      end;
    end;
  end;

  AtualizaTela;
end;


procedure TFrmCadastro.SetTipoContribuinte(iTipo : integer);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;

    Form7.IBDataSet2CONTRIBUINTE.AsInteger := iTipo;

    CarregaTipoContibuinte;
  except
  end;
end;

procedure TFrmCadastro.ShowGridCidade();
begin
  if not(DBGridAddress.SelectedIndex = GetColumnIdByFieldName('CIDADE')) then
    Exit();

  if not(Trim(FDMemTableAddressCIDADE.AsString) = '') then
    FilterCity(
      FDMemTableAddressESTADO.AsString,
      FDMemTableAddressCIDADE.AsString
    )
  else if (Trim(FDMemTableAddressESTADO.AsString) = '') then
  begin
    if FDMemTableAddress.State in ([dsInsert, dsEdit]) then
    begin
      if IBQueryCidades.Active and not(IBQueryCidades.FieldByName('UF').AsString = '') then
        FDMemTableAddressESTADO.AsString := IBQueryCidades.FieldByName('UF').AsString
      else if not(DSCadastro.DataSet.FieldByName('ESTADO').AsString = '') then
        FDMemTableAddressESTADO.AsString := DSCadastro.DataSet.FieldByName('ESTADO').AsString;
      FilterCity(FDMemTableAddressESTADO.AsString);
    end;
  end;


  var Col := DBGridAddress.SelectedIndex;
  var Row := THackDBGrid(DBGridAddress).Row;

  var Position := ScreenToClient(
    DBGridAddress.ClientToScreen(
      Point(DBGridAddress.Left, DBGridAddress.Top)
    )
  );

  var R: TRect;
  R.Left := Position.X - PanelAddress.Padding.Left + 5;
  for var i := 0 to Col - 1 do
    R.Left := R.Left + DBGridAddress.Columns[i].Width;

  R.Top := Position.Y;
  for var i := THackDBGrid(DBGridAddress).TopRow to Row -1 do
    R.Top := R.Top + THackDBGrid(DBGridAddress).DefaultRowHeight;

  R.Right := R.Left + THackDBGrid(DBGridAddress).ColWidths[Col];
  R.Bottom := R.Top + THackDBGrid(DBGridAddress).DefaultRowHeight;

  with FPanelCities do
  begin
    Left := R.Left;
    Top := R.Bottom;
    Width := R.Width + 100;
    Visible := True;
    BringToFront;
  end;
end;

procedure TFrmCadastro.btnRenogiarDividaClick(Sender: TObject);
var
  ftotal1, fTotal2 : Real;
  bButton : Integer;
  sNumeroNF : String;
begin
  try
    ExecutaComando('create generator G_RENEGOCIACAO');
  except
  end;

  Form7.sTextoDoAcordo := '';

  Form7.ibDataSet7.Close;
  Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                     ' Where SubString(DOCUMENTO from 1 for 2)=''RE'' '+
                                     '   and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                     '   and coalesce(ATIVO,9)<>1 '+
                                     '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                     ' Order by VENCIMENTO';
  Form7.ibDataSet7.Open;
  Form7.ibDataSet7.Last;

  if Copy(Form7.ibDataSet7DOCUMENTO.AsString,1,2) = 'RE' then
  begin
    // Abre uma negociação já existente
    sNumeroNF := LimpaNumero(Form7.ibDataSet7HISTORICO.AsString);

    ExecutaComando(' Update RECEBER set PORTADOR='''', ATIVO=0 '+
                   ' Where PORTADOR=' + QuotedStr('ACORDO '+sNumeroNF) +
                   '   and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString),
                   Form7.IBTransaction1);

    Form7.IBDataSet2.Edit;
    Form7.IBDataSet2MOSTRAR.AsFloat := 1;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 and SubString(DOCUMENTO from 1 for 2)<>''RE''  '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                       ' Order by VENCIMENTO';
    Form7.ibDataSet7.Open;
  end else
  begin
    // Nova negociação
    try
      Form7.ibQuery2.Close;
      Form7.ibQuery2.SQL.Text := ' Select gen_id(G_RENEGOCIACAO,1) from rdb$database';
      Form7.ibQuery2.Open;

      sNumeroNF := strZero(StrToInt(Form7.ibQuery2.FieldByname('GEN_ID').AsString),12,0);
    except
    end;

    // Total das parcelas em aberto
    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       '   and coalesce(ATIVO,9)<>1 '+
                                       '   and Coalesce(VALOR_RECE,999999999)=0 '+
                                       ' Order by VENCIMENTO';
    Form7.ibDataSet7.Open;
  end;

  Form7.sTextoDoAcordo := 'Parcela    Vencimento   Valor R$      Atualizado R$ '+chr(13)+chr(10)+
                          '---------- ------------ ------------- --------------'+chr(13)+chr(10);
  fTotal1 := 0;
  fTotal2 := 0;

  while not Form7.ibDataSet7.Eof do
  begin
    Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_JURO.AsFloat])+chr(13)+chr(10);
    fTotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
    fTotal2 := fTotal2 + Form7.ibDataSet7VALOR_JURO.AsFloat;
    Form7.ibDataSet7.Next;
  end;

  Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                          '                        ------------- ---------------'+chr(13)+chr(10)+
                          '                       '+Format('%15.2n',[fTotal1])+Format('%15.2n',[ftotal2])+chr(13)+chr(10);
  if fTotal1 <> 0 then
  begin
    bButton := Application.MessageBox(Pchar('Considerar o valor atualizado com juros?'),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);

    if bButton = IDYES then
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia.'+chr(13)+chr(10);
      fTotal1 := fTotal2;
    end else
    begin
      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + chr(13) + chr(10) + 'Valor atualizado calculado com a taxa de juros de '+AllTrim(Format('%15.4n',[Form1.fTaxa]))+' ao dia foi desconsiderado.'+chr(13)+chr(10);
    end;

    Form7.ibDataSet7.Close;
    Form7.ibDataSet7.Selectsql.Text := ' Select * from RECEBER '+
                                       ' Where NUMERONF='+QuotedStr(sNumeroNF)+
                                       '   and  NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+
                                       ' Order by REGISTRO';
    Form7.ibDataSet7.Open;

    //Mauricio Parizotto 2024-01-24
    try
      FrmParcelas := TFrmParcelas.Create(Self);
      FrmParcelas.Caption := 'Renegociação de dívida';
      FrmParcelas.vlrRenegociacao := fTotal1;
      FrmParcelas.nrRenegociacao := sNumeroNF;
      FrmParcelas.ShowModal;
    finally
      FreeAndNil(FrmParcelas);
    end;
  end;
end;

procedure TFrmCadastro.btnWebCamClick(Sender: TObject);
var
  jp : TJPEGImage;
begin
  if btnWebCam.Caption <> '&Captura' then
  begin
    try
      VideoCap1.visible    := True;
      Image5.Visible       := False;
      VideoCAp1.Left       := 5;
      VideoCAp1.Top        := 5;

      VideoCAp1.Width      := 640;
      VideoCAp1.Height     := 480;

      VideoCap1.visible    := True;

      try
        Videocap1.DriverIndex := 0;
      except
      end;

      try
        VideoCap1.VideoPreview := True;
        VideoCap1.CapAudio     := False;
      except end;

      btnWebCam.Caption := '&Captura';
    except
    end;
  end else
  begin
    try
      VideoCap1.SaveToClipboard;
      Image5.Picture.Bitmap.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
      VideoCap1.VideoPreview := False;
      VideoCap1.visible      := False;

      jp := TJPEGImage.Create;
      jp.Assign(Image5.Picture.Bitmap);
      jp.CompressionQuality := 100;

      jp.SaveToFile(sNomeDoJPG);

      btnWebCam.Caption    := '&Webcam';
      Image5.Visible       := True;

      while not FileExists(pChar(sNomeDoJPG)) do
      begin
        Sleep(100);
      end;

      Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
      Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

      AtualizaTela;
    except
    end;
  end;

end;

procedure TFrmCadastro.btnSelecionarArquivoClick(Sender: TObject);
begin
  OpenPictureDialog1.Execute;
  CHDir(Form1.sAtual);

  if FileExists(OpenPictureDialog1.FileName) then
  begin
    Screen.Cursor             := crHourGlass;              // Cursor de Aguardo

    while FileExists(pChar(sNomeDoJPG)) do
    begin
      DeleteFile(pChar(sNomeDoJPG));
    end;

    CopyFile(pChar(OpenPictureDialog1.FileName),pChar(sNomeDoJPG),True);

    while not FileExists(pChar(sNomeDoJPG)) do
    begin
      Sleep(100);
    end;

    Screen.Cursor             := crDefault;              // Cursor de Aguardo

    Image3.Picture.LoadFromFile(pChar(sNomeDoJPG));
    Image5.Picture.LoadFromFile(pChar(sNomeDoJPG));

    AtualizaTela;
  end;
end;

procedure TFrmCadastro.CarregaTipoContibuinte;
begin
  try
    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 0 then
    begin
      rgIEContribuinte.Checked    := False;
      rgIEIsento.Checked          := False;
      rgIENaoContribuinte.Checked := False;
    end;

    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 1 then
    begin
      rgIEContribuinte.Checked := True;

      if Form7.IBDataSet2IE.AsString = 'ISENTO' then
        Form7.IBDataSet2IE.AsString := '';
    end;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 2 then
    begin
      rgIEIsento.Checked          := True;

      Form7.IBDataSet2IE.AsString := 'ISENTO';
    end;

    if Form7.IBDataSet2CONTRIBUINTE.AsInteger = 9 then
    begin
      rgIENaoContribuinte.Checked := True;

      if Form7.IBDataSet2IE.AsString = 'ISENTO' then
        Form7.IBDataSet2IE.AsString := '';
    end;

    edtRG_IE.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura) and (Form7.IBDataSet2CONTRIBUINTE.AsString <> '2');
  except
  end;
end;


procedure TFrmCadastro.DefinirLimiteDisponivel;
var
  nValor: Currency;
begin
  eLimiteCredDisponivel.Text := EmptyStr;
  if not Self.Showing then
    Exit;

  if (Form7.sModulo = 'CLIENTES') and (Form7.IBDataSet2CREDITO.AsCurrency > 0) then
  begin
    nValor := TRetornaLimiteDisponivel.New
                                      .SetDatabase(Form7.IBDatabase1)
                                      .SetCliente(Form7.IBDataSet2NOME.AsString)
                                      .setLimiteCredito(Form7.IBDataSet2CREDITO.AsCurrency)
                                      .CarregarDados
                                      .RetornarValor;



    eLimiteCredDisponivel.Text := FormatFloat(',0.00', nValor);
  end;
end;


procedure TFrmCadastro.Label19MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  try
    with Sender as TLabel do
    begin
      Font.Style := [fsBold,fsUnderline];
      Font.Color := clBlue;
      Repaint;
    end;
  except
  end;
end;

procedure TFrmCadastro.AtualizaTela;
var
  BlobStream: TStream;
  FileStream : TFileStream;
  JP2         : TJPEGImage;
begin
  Image5.Picture := nil;
  Image3.Picture := nil;

  if FileExists(sNomeDoJPG) then
  begin
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset2.Edit;
    FileStream := TFileStream.Create(sNomeDoJPG,fmOpenRead or fmShareDenyWrite);
    BlobStream := Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmWrite);
    try
      BlobStream.CopyFrom(FileStream,FileStream.Size);
    finally
      FileStream.Free;
      BlobStream.Free;
    end;

    Deletefile(pChar(sNomeDoJPG));
  end;

  if Form7.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
  end
  else
    Image5.Picture := Image3.Picture;
end;

end.




