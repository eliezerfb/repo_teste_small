unit ufrmConfiguraNFSe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls, System.IniFiles, System.TypInfo,
  Vcl.Buttons,
  blcksock,
  ACBrDFeSSL,
  ACBrBase,
  ACBrUtil.Base,
  ACBrUtil.DateTime, ACBrUtil.FilesIO,
  ACBrDFe, ACBrDFeReport, ACBrMail, ACBrNFSeX,
  ACBrNFSeXConversao, ACBrNFSeXWebservicesResponse, Vcl.ComCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient
  , uArquivosDAT
  ;

type
  TfrmConfiguraNFSe = class(TFrmPadrao)
    btnGravar: TBitBtn;
    pgConexoesNFSe: TPageControl;
    tsConexaoPrefeitura: TTabSheet;
    Label30: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label41: TLabel;
    Label44: TLabel;
    lSSLLib: TLabel;
    lCryptLib: TLabel;
    lHttpLib: TLabel;
    lXmlSign: TLabel;
    lSSLLib1: TLabel;
    Label49: TLabel;
    Label3: TLabel;
    rgTipoAmb: TRadioGroup;
    edtSenhaWeb: TEdit;
    edtUserWeb: TEdit;
    edtFraseSecWeb: TEdit;
    edtChaveAcessoWeb: TEdit;
    edtChaveAutorizWeb: TEdit;
    cbSSLLib: TComboBox;
    cbCryptLib: TComboBox;
    cbHttpLib: TComboBox;
    cbXmlSignLib: TComboBox;
    cbSSLType: TComboBox;
    cbLayoutNFSe: TComboBox;
    mmCertificado: TMemo;
    btnSelecionaCertificado: TBitBtn;
    tbOutrasInformacoes: TTabSheet;
    DBGCONFIG: TDBGrid;
    DSConfig: TDataSource;
    CDSConfig: TClientDataSet;
    CDSConfigPARAMETRO: TStringField;
    CDSConfigVALOR: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbSSLLibChange(Sender: TObject);
    procedure cbCryptLibChange(Sender: TObject);
    procedure cbHttpLibChange(Sender: TObject);
    procedure cbXmlSignLibChange(Sender: TObject);
    procedure lbCertificado1Click(Sender: TObject);
    procedure btnSelecionaCertificadoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    //Ini: TIniFile;
    config: TArquivosDAT;
    procedure LerConfiguracao;
    procedure SalvarConfiguracao;
    procedure AtualizarSSLLibsCombo;
    procedure GravarOutrasConfiguracoes;
  public
    { Public declarations }
  end;

var
  frmConfiguraNFSe: TfrmConfiguraNFSe;

implementation

{$R *.dfm}

uses unit7, ufrmSelecionaCertificadoNFSe, uSmallNFSe
  //ufrmOutrasConfiguracoesNFSe
  , uListaToJson;

{ TfrmConfiguraNFSe }

procedure TfrmConfiguraNFSe.AtualizarSSLLibsCombo;
begin
  cbSSLType.Enabled := (TSSLHttpLib(cbHttpLib.ItemIndex) in [httpWinHttp, httpOpenSSL]);
end;

procedure TfrmConfiguraNFSe.btnGravarClick(Sender: TObject);
begin
  inherited;
  SalvarConfiguracao;
  Close;
end;

procedure TfrmConfiguraNFSe.btnSelecionaCertificadoClick(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmSelecionaCertificadoNFSe, frmSelecionaCertificadoNFSe);
  frmSelecionaCertificadoNFSe.ShowModal;
  FreeAndNil(frmSelecionaCertificadoNFSe);

  LerConfiguracao;
end;

procedure TfrmConfiguraNFSe.cbCryptLibChange(Sender: TObject);
begin
  inherited;
  AtualizarSSLLibsCombo;
end;

procedure TfrmConfiguraNFSe.cbHttpLibChange(Sender: TObject);
begin
  inherited;
  AtualizarSSLLibsCombo;
end;

procedure TfrmConfiguraNFSe.cbSSLLibChange(Sender: TObject);
begin
  inherited;
  AtualizarSSLLibsCombo;
end;

procedure TfrmConfiguraNFSe.cbXmlSignLibChange(Sender: TObject);
begin
  inherited;
  AtualizarSSLLibsCombo;
end;

procedure TfrmConfiguraNFSe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfrmConfiguraNFSe.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  config.Free;
  //Ini.Free;
end;

procedure TfrmConfiguraNFSe.FormCreate(Sender: TObject);
var
  T: TSSLLib;
  U: TSSLCryptLib;
  V: TSSLHttpLib;
  X: TSSLXmlSignLib;
  Y: TSSLType;
  L: TLayoutNFSe;
begin
  inherited;

  pgConexoesNFSe.ActivePage := tsConexaoPrefeitura;

  config := TArquivosDAT.Create('', Form7.IBTransaction1);

  mmCertificado.Clear;
  //Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

  cbSSLLib.Items.Clear;
  for T := Low(TSSLLib) to High(TSSLLib) do
    cbSSLLib.Items.Add(GetEnumName(TypeInfo(TSSLLib), integer(T)));
  cbSSLLib.ItemIndex := 4;

  cbCryptLib.Items.Clear;
  for U := Low(TSSLCryptLib) to High(TSSLCryptLib) do
    cbCryptLib.Items.Add(GetEnumName(TypeInfo(TSSLCryptLib), integer(U)));
  cbCryptLib.ItemIndex := 0;

  cbHttpLib.Items.Clear;
  for V := Low(TSSLHttpLib) to High(TSSLHttpLib) do
    cbHttpLib.Items.Add(GetEnumName(TypeInfo(TSSLHttpLib), integer(V)));
  cbHttpLib.ItemIndex := 0;

  cbXmlSignLib.Items.Clear;
  for X := Low(TSSLXmlSignLib) to High(TSSLXmlSignLib) do
    cbXmlSignLib.Items.Add(GetEnumName(TypeInfo(TSSLXmlSignLib), integer(X)));
  cbXmlSignLib.ItemIndex := 0;

  cbSSLType.Items.Clear;
  for Y := Low(TSSLType) to High(TSSLType) do
    cbSSLType.Items.Add(GetEnumName(TypeInfo(TSSLType), integer(Y)));
  cbSSLType.ItemIndex := 5;

  cbLayoutNFSe.Items.Clear;
  for L := Low(TLayoutNFSe) to High(TLayoutNFSe) do
    cbLayoutNFSe.Items.Add(GetEnumName(TypeInfo(TLayoutNFSe), integer(L)));
  cbLayoutNFSe.ItemIndex := 0;

  DBGCONFIG.DrawingStyle := gdsClassic;
  CDSConfig.CreateDataSet;
  CDSConfig.Open;
  //CarregaOutrasConfiguracoes;

end;

procedure TfrmConfiguraNFSe.FormShow(Sender: TObject);
begin
  inherited;
  LerConfiguracao;
end;

procedure TfrmConfiguraNFSe.GravarOutrasConfiguracoes;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

  ini.EraseSection('Informacoes obtidas na prefeitura');
  CDSConfig.First;
  while CDSConfig.Eof = False do
  begin

    if Trim(CDSConfig.FieldByName('PARAMETRO').AsString) <> '' then
      Ini.WriteString('Informacoes obtidas na prefeitura', CDSConfig.FieldByName('PARAMETRO').AsString, CDSConfig.FieldByName('VALOR').AsString);

    CDSConfig.Next;
  end;
  Ini.Free;

end;

procedure TfrmConfiguraNFSe.lbCertificado1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmSelecionaCertificadoNFSe, frmSelecionaCertificadoNFSe);
  frmSelecionaCertificadoNFSe.ShowModal;
  FreeAndNil(frmSelecionaCertificadoNFSe);
end;

procedure TfrmConfiguraNFSe.LerConfiguracao;
var
  NFSe: TNFS;
  dtValidadeCertificado: TDate;
  iParam: Integer;
  Parametros: TParametros;
begin

  NFSe := TNFS.Create(nil);
  NFSe.IBTRANSACTION := Form7.IBTransaction1;
  NFSe.ConfigurarComponente;
  dtValidadeCertificado := NFSe.ACBrNFSeX.SSL.CertDataVenc;
  FreeAndNil(NFSe);

  cbSSLLib.ItemIndex     := config.BD.NFSe.Certificado.SSLLib.ToInteger;// Ini.ReadInteger('Certificado', 'SSLLib',     4);
  cbCryptLib.ItemIndex   := config.BD.NFSe.Certificado.CryptLib.ToInteger;// Ini.ReadInteger('Certificado', 'CryptLib',   3);
  cbHttpLib.ItemIndex    := config.BD.NFSe.Certificado.HttpLib.ToInteger;// Ini.ReadInteger('Certificado', 'HttpLib',    2);
  cbXmlSignLib.ItemIndex := config.BD.NFSe.Certificado.XmlSignLib.ToInteger;// Ini.ReadInteger('Certificado', 'XmlSignLib', 0);
  {
  mmCertificado.Clear;
  mmCertificado.Text := Ini.ReadString('Certificado', 'NumSerie',   '');
  mmCertificado.Lines.Add(Ini.ReadString('Certificado', 'NomeCertificado', ''));
  mmCertificado.Lines.Add('Validade: ' + FormatDateTime('dd/mm/yyyy', dtValidadeCertificado));
  }
  mmCertificado.Clear;
  mmCertificado.Text := config.BD.NFSe.Certificado.NumSerie;
  mmCertificado.Lines.Add(config.BD.NFSe.Certificado.NomeCertificado);
  mmCertificado.Lines.Add('Validade: ' + FormatDateTime('dd/mm/yyyy', dtValidadeCertificado));


  if cbSSLLib.ItemIndex <> 5 then
    cbSSLLibChange(cbSSLLib);
  {
  cbSSLType.ItemIndex     := Ini.ReadInteger('WebService', 'SSLType',     5);
  edtSenhaWeb.Text        := Ini.ReadString( 'WebService', 'SenhaWeb',    '');
  edtUserWeb.Text         := Ini.ReadString( 'WebService', 'UserWeb',     '');
  edtFraseSecWeb.Text     := Ini.ReadString( 'WebService', 'FraseSecWeb', '');
  edtChaveAcessoWeb.Text  := Ini.ReadString( 'WebService', 'ChAcessoWeb', '');
  edtChaveAutorizWeb.Text := Ini.ReadString( 'WebService', 'ChAutorizWeb', '');
  rgTipoAmb.ItemIndex     := Ini.ReadInteger('WebService', 'Ambiente',     2) - 1;

  cbLayoutNFSe.ItemIndex     := Ini.ReadInteger('Geral', 'LayoutNFSe',     0);
  }

  cbSSLType.ItemIndex     := config.BD.NFSe.WebService.SSLType.ToInteger; // Ini.ReadInteger('WebService', 'SSLType',     5);
  edtSenhaWeb.Text        := config.BD.NFSe.WebService.SenhaWeb; // Ini.ReadString( 'WebService', 'SenhaWeb',    '');
  edtUserWeb.Text         := config.BD.NFSe.WebService.UserWeb; // Ini.ReadString( 'WebService', 'UserWeb',     '');
  edtFraseSecWeb.Text     := config.BD.NFSe.WebService.FraseSecWeb; //Ini.ReadString( 'WebService', 'FraseSecWeb', '');
  edtChaveAcessoWeb.Text  := config.BD.NFSe.WebService.ChAcessoWeb; // Ini.ReadString( 'WebService', 'ChAcessoWeb', '');
  edtChaveAutorizWeb.Text := config.BD.NFSe.WebService.ChAutorizWeb; // Ini.ReadString( 'WebService', 'ChAutorizWeb', '');
  rgTipoAmb.ItemIndex     := config.BD.NFSe.WebService.Ambiente.ToInteger; // Ini.ReadInteger('WebService', 'Ambiente',     2) - 1;

  cbLayoutNFSe.ItemIndex  := config.BD.NFSe.LayoutNFSe.ToInteger; // Ini.ReadInteger('Geral', 'LayoutNFSe',     0);

  //Carrega Outras informações;

  CDSConfig.EmptyDataSet;

  Parametros := TParametros.Create;
  Parametros := config.BD.NFSe.InformacoesObtidasPrefeitura.Informacoes;

  for iParam := 0 to High(Parametros.Itens) do
  begin
    CDSConfig.Append;
    CDSConfig.FieldByName('PARAMETRO').AsString := Parametros.Itens[iParam].Parametro; // Copy(sSection.Strings[iParam], 1, Pos('=', sSection.Strings[iParam]) - 1);
    CDSConfig.FieldByName('VALOR').AsString     := Parametros.Itens[iParam].Valor; // Copy(sSection.Strings[iParam], Pos('=', sSection.Strings[iParam]) + 1, Length(sSection.Strings[iParam]));
    CDSConfig.Post;
  end;

  Parametros.Free;
end;

procedure TfrmConfiguraNFSe.SalvarConfiguracao;
var
  Parametros: TParametros;
begin
  config.BD.NFSe.Certificado.SSLLib     := cbSSLLib.ItemIndex.ToString; // Ini.WriteInteger('Certificado', 'SSLLib',     cbSSLLib.ItemIndex);
  config.BD.NFSe.Certificado.CryptLib   := cbCryptLib.ItemIndex.ToString; // Ini.WriteInteger('Certificado', 'CryptLib',   cbCryptLib.ItemIndex);
  config.BD.NFSe.Certificado.HttpLib    := cbHttpLib.ItemIndex.ToString; // Ini.WriteInteger('Certificado', 'HttpLib',    cbHttpLib.ItemIndex);
  config.BD.NFSe.Certificado.XmlSignLib := cbXmlSignLib.ItemIndex.ToString; //  Ini.WriteInteger('Certificado', 'XmlSignLib', cbXmlSignLib.ItemIndex);

  //Ini.WriteString( 'Certificado', 'NumSerie',   edtNumSerie.Text);
  //Ini.WriteString( 'Certificado', 'NomeCertificado', edSubjectNameCertificado.Text);

  config.BD.NFSe.WebService.SSLType      := cbSSLType.ItemIndex.ToString; //  Ini.WriteInteger('WebService', 'SSLType',      cbSSLType.ItemIndex);
  config.BD.NFSe.WebService.SenhaWeb     := edtSenhaWeb.Text; // Ini.WriteString( 'WebService', 'SenhaWeb',     edtSenhaWeb.Text);
  config.BD.NFSe.WebService.UserWeb      := edtUserWeb.Text; //  Ini.WriteString( 'WebService', 'UserWeb',      edtUserWeb.Text);
  config.BD.NFSe.WebService.FraseSecWeb  := edtFraseSecWeb.Text; //  Ini.WriteString( 'WebService', 'FraseSecWeb',  edtFraseSecWeb.Text);
  config.BD.NFSe.WebService.ChAcessoWeb  := edtChaveAcessoWeb.Text; // Ini.WriteString( 'WebService', 'ChAcessoWeb',  edtChaveAcessoWeb.Text);
  config.BD.NFSe.WebService.ChAutorizWeb := edtChaveAutorizWeb.Text; // Ini.WriteString( 'WebService', 'ChAutorizWeb', edtChaveAutorizWeb.Text);
  config.BD.NFSe.WebService.Ambiente     := (rgTipoAmb.ItemIndex - 1).ToString; //  Ini.WriteInteger('WebService', 'Ambiente',     rgTipoAmb.ItemIndex + 1);

  config.BD.NFSe.LayoutNFSe := cbLayoutNFSe.ItemIndex.ToString;// Ini.WriteInteger('Geral', 'LayoutNFSe',     cbLayoutNFSe.ItemIndex);

  // Gravar Outras Informações;
  Parametros := TParametros.Create;
  Parametros.Json := config.BD.NFSe.InformacoesObtidasPrefeitura.Informacoes.Json;

  CDSConfig.First;
  while CDSConfig.Eof = False do
  begin
    Parametros.SetValorParametro(CDSConfig.FieldByName('PARAMETRO').AsString, CDSConfig.FieldByName('VALOR').AsString);
    CDSConfig.Next;
  end;

  config.BD.NFSe.InformacoesObtidasPrefeitura.Informacoes := Parametros;

  Parametros.Free;
end;

end.
