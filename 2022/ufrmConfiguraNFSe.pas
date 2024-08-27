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
  ACBrNFSeXConversao, ACBrNFSeXWebservicesResponse
  ;

type
  TfrmConfiguraNFSe = class(TFrmPadrao)
    btnGravar: TBitBtn;
    Label30: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label41: TLabel;
    Label44: TLabel;
    rgTipoAmb: TRadioGroup;
    edtSenhaWeb: TEdit;
    edtUserWeb: TEdit;
    edtFraseSecWeb: TEdit;
    edtChaveAcessoWeb: TEdit;
    edtChaveAutorizWeb: TEdit;
    lSSLLib: TLabel;
    lCryptLib: TLabel;
    lHttpLib: TLabel;
    lXmlSign: TLabel;
    cbSSLLib: TComboBox;
    cbCryptLib: TComboBox;
    cbHttpLib: TComboBox;
    cbXmlSignLib: TComboBox;
    cbSSLType: TComboBox;
    lSSLLib1: TLabel;
    Label49: TLabel;
    cbLayoutNFSe: TComboBox;
    Label3: TLabel;
    mmCertificado: TMemo;
    btnSelecionaCertificado: TBitBtn;
    BitBtn1: TBitBtn;
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
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Ini: TIniFile;
    procedure LerConfiguracao;
    procedure SalvarConfiguracao;
    procedure AtualizarSSLLibsCombo;
  public
    { Public declarations }
  end;

var
  frmConfiguraNFSe: TfrmConfiguraNFSe;

implementation

{$R *.dfm}

uses unit7, ufrmSelecionaCertificadoNFSe, uSmallNFSe,
  ufrmOutrasConfiguracoesNFSe, uArquivosDAT;

{ TfrmConfiguraNFSe }

procedure TfrmConfiguraNFSe.AtualizarSSLLibsCombo;
begin
  cbSSLType.Enabled := (TSSLHttpLib(cbHttpLib.ItemIndex) in [httpWinHttp, httpOpenSSL]);
end;

procedure TfrmConfiguraNFSe.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Application.CreateForm(TfrmOutrasConfiguracoesNFSe, frmOutrasConfiguracoesNFSe);
  frmOutrasConfiguracoesNFSe.ShowModal;
  FreeAndNil(frmOutrasConfiguracoesNFSe);
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
  Ini.Free;
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
  mmCertificado.Clear;
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');

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

end;

procedure TfrmConfiguraNFSe.FormShow(Sender: TObject);
begin
  inherited;
  LerConfiguracao;
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
  config: TArquivosDAT;
begin

  config := TArquivosDAT.Create('', Form7.IBTransaction1);

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

  cbSSLType.ItemIndex     := Ini.ReadInteger('WebService', 'SSLType',     5);
  edtSenhaWeb.Text        := Ini.ReadString( 'WebService', 'SenhaWeb',    '');
  edtUserWeb.Text         := Ini.ReadString( 'WebService', 'UserWeb',     '');
  edtFraseSecWeb.Text     := Ini.ReadString( 'WebService', 'FraseSecWeb', '');
  edtChaveAcessoWeb.Text  := Ini.ReadString( 'WebService', 'ChAcessoWeb', '');
  edtChaveAutorizWeb.Text := Ini.ReadString( 'WebService', 'ChAutorizWeb', '');
  rgTipoAmb.ItemIndex     := Ini.ReadInteger('WebService', 'Ambiente',     2) - 1;

  cbLayoutNFSe.ItemIndex     := Ini.ReadInteger('Geral', 'LayoutNFSe',     0);
  config.Free;
end;

procedure TfrmConfiguraNFSe.SalvarConfiguracao;
begin
  Ini.WriteInteger('Certificado', 'SSLLib',     cbSSLLib.ItemIndex);
  Ini.WriteInteger('Certificado', 'CryptLib',   cbCryptLib.ItemIndex);
  Ini.WriteInteger('Certificado', 'HttpLib',    cbHttpLib.ItemIndex);
  Ini.WriteInteger('Certificado', 'XmlSignLib', cbXmlSignLib.ItemIndex);
  //Ini.WriteString( 'Certificado', 'NumSerie',   edtNumSerie.Text);
  //Ini.WriteString( 'Certificado', 'NomeCertificado', edSubjectNameCertificado.Text);

  Ini.WriteInteger('WebService', 'SSLType',      cbSSLType.ItemIndex);
  Ini.WriteString( 'WebService', 'SenhaWeb',     edtSenhaWeb.Text);
  Ini.WriteString( 'WebService', 'UserWeb',      edtUserWeb.Text);
  Ini.WriteString( 'WebService', 'FraseSecWeb',  edtFraseSecWeb.Text);
  Ini.WriteString( 'WebService', 'ChAcessoWeb',  edtChaveAcessoWeb.Text);
  Ini.WriteString( 'WebService', 'ChAutorizWeb', edtChaveAutorizWeb.Text);
  Ini.WriteInteger('WebService', 'Ambiente',     rgTipoAmb.ItemIndex + 1);

  Ini.WriteInteger('Geral', 'LayoutNFSe',     cbLayoutNFSe.ItemIndex);
end;

end.
