{
Parte integrante de uExemplo, o formul�rio de sele��o de certificados �
respons�vel por mostrar uma lista contendo todos os certificados registrados no sistema,
para que o usu�rio possa selecionar qual certificado que ser� utilizado para valida��o junto
� SEFAZ.

@author(TecnoSpeed - Consultoria em TI (http://www.tecnospeed.com.br))
@created(Agosto/2008)}
unit ufrmSelecionaCertificadoNFSe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, smallfunc_xe, DB, DBClient, spdNFe,
  dbcgrids, Grids, DBGrids, DBCtrls
  , ACBrNFSeX, ACBrDFeSSL
  ;

type
  {Declara��o da classe do formul�rio de sele��o de certificados}
  TfrmSelecionaCertificadoNFSe = class(TForm)
    {Listbox respons�vel por listar os certificados. O usu�rio pode selecionar o certificado desejado com um duplo clique na linha do mesmo.

    Com um duplo clique em qualquer linha do ListBox � chamado o evento lbListDblClick.
    }
    lbList: TListBox;
    {Bot�o de sele��o: clicando neste bot�o o usu�rio pode selecionar o certificado que estiver marcado na lista.

    Ao clicar neste bot�o � chamado o evento btnSelectClick.
    }
    btnSelect: TBitBtn;
    {Bot�o de cancelamento: clicando neste bot�o o usu�rio pode cancelar a opera��o de sele��o do certificado}
    btnCancel: TBitBtn;
    {Painel que cont�m o componente de listagem}
    pnlBody: TPanel;
    {Painel que cont�m os bot�es de sele��o (btnSelect) e cancelamento (btnCancel)}
    pnlMenu: TPanel;
    {Bot�o de remo��o de certificado}
    btnRemove: TBitBtn;
    DSCertificados: TDataSource;
    cdsCertificados: TClientDataSet;
    cdsCertificadosCertificado: TStringField;
    cdsCertificadosValidade: TStringField;
    cdsCertificadosDescricao: TStringField;
    Panel1: TPanel;
    dbcgCertificados: TDBCtrlGrid;
    DBText1: TDBText;
    DBText2: TDBText;
    Label1: TLabel;
    cdsCertificadosNUMEROSERIE: TStringField;
    cdsCertificadosTIPO: TStringField;
    DBText3: TDBText;
    Label2: TLabel;
    {Evento respons�vel por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formul�rio.
    � chamado quando o usu�rio clica no bot�o btnSelect.}
    procedure btnSelectClick(Sender: TObject);
    {Evento respons�vel por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formul�rio.
    � chamado quando o usu�rio d� um duplo clique na linha do lbList.}
    procedure lbListDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dbcgCertificadosDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    ACBrNFSeX: TACBrNFSeX;
    {Campo que guarda a hash do certificado escolhido}
    FSelectedCertificateName: String;
    FSelectedCertificateNumSerie: String;
    {Esta fun��o atualiza na property SelectedCertificate o certificado escolhido pelo usu�rio
    ao clicar em btnSelect ou dar um duplo clique em uma das linhas de lbList}
    procedure UpdateSelectedCertificate;
    function GetValidadeCertificado(NumeroSerie: string): string;
  published
    {Property que guarda o nome do certificado escolhido}
    property SelectedCertificateName : String read FSelectedCertificateName write FSelectedCertificateName;
    property SelectedCertificateNumSerie : String read FSelectedCertificateNumSerie write FSelectedCertificateNumSerie;
  end;

var
  {Var��vel do formul�rio de sele��o de certificados}
  frmSelecionaCertificadoNFSe: TfrmSelecionaCertificadoNFSe;

implementation

uses Mais, uSmallNFSe, Unit7;

{$R *.dfm}

{ TfrmSelecionaCertificadoNFSe }

procedure TfrmSelecionaCertificadoNFSe.btnSelectClick(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  UpdateSelectedCertificate;
  Mais1ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');
  Mais1Ini.WriteString('Certificado', 'NomeCertificado', SelectedCertificateName);
  Mais1Ini.WriteString('Certificado', 'NumSerie', FSelectedCertificateNumSerie);
  Mais1ini.Free;

  {
  try
    Form7.spdNFe.NomeCertificado.Text     := SelectedCertificateName;
  except
  end;
  }
end;

procedure TfrmSelecionaCertificadoNFSe.UpdateSelectedCertificate;
begin
  SelectedCertificateName      := cdsCertificadosCertificado.AsString;
  FSelectedCertificateNumSerie := cdsCertificadosNUMEROSERIE.AsString;
end;

procedure TfrmSelecionaCertificadoNFSe.lbListDblClick(Sender: TObject);
begin
  UpdateSelectedCertificate;
  ModalResult := mrOk;
  frmSelecionaCertificadoNFSe.btnSelectClick(Sender);
end;

procedure TfrmSelecionaCertificadoNFSe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lbList.Items.Clear;
end;

procedure TfrmSelecionaCertificadoNFSe.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FreeAndNil(ACBrNFSeX);
end;

procedure TfrmSelecionaCertificadoNFSe.FormCreate(Sender: TObject);
begin
  ACBrNFSeX := TACBrNFSeX.Create(nil);
end;

procedure TfrmSelecionaCertificadoNFSe.FormShow(Sender: TObject);
var
  i, posi :integer;
  Mais1Ini : TIniFile;
  CertificadoConfigurado : string;
  DescCertificado : string;
  NFSe: TNFS;
begin
  try
    Mais1ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'nfse.ini');
    CertificadoConfigurado := Mais1Ini.ReadString('Certificado', 'NomeCertificado', '');
    Mais1ini.Free;
  finally
  end;

  cdsCertificados.Close;
  cdsCertificados.CreateDataSet;
  cdsCertificados.Open;

  {
  ACBrNFSeX := TNFS.ConfigurarComponente(ACBrNFSeX, FORM7.ibDataSet13.Transaction);

  ACBrNFSeX.SSL.LerCertificadosStore;
  for I := 0 to ACBrNFSeX.SSL.ListaCertificados.Count-1 do
  begin
    if (ACBrNFSeX.SSL.ListaCertificados[I].CNPJ <> '') then
    begin

      cdsCertificados.Append;
      cdsCertificadosCertificado.AsString := ACBrNFSeX.SSL.ListaCertificados[I].SubjectName;
      cdsCertificadosDescricao.AsString   := ACBrNFSeX.SSL.ListaCertificados[I].RazaoSocial;
      cdsCertificadosValidade.AsString    := FormatDateTime('dd/mm/yyyy', ACBrNFSeX.SSL.ListaCertificados[I].DataVenc);
      cdsCertificadosNUMEROSERIE.AsString := ACBrNFSeX.SSL.ListaCertificados[I].NumeroSerie;
      cdsCertificadosTIPO.AsString        := 'Desconhecido';
      case ACBrNFSeX.SSL.ListaCertificados[I].Tipo of
        tpcA1: cdsCertificadosTIPO.AsString        := 'A1';
        tpcA3: cdsCertificadosTIPO.AsString        := 'A3';
      end;
      cdsCertificados.Post;

    end;
  end;
  }

  NFSe := TNFS.Create(nil);
  NFSe.IBTRANSACTION := Form7.ibDataSet13.Transaction;
  NFSe.ConfigurarComponente;

  NFSe.ACBrNFSeX.SSL.LerCertificadosStore;
  for I := 0 to NFSe.ACBrNFSeX.SSL.ListaCertificados.Count-1 do
  begin
    if (NFSe.ACBrNFSeX.SSL.ListaCertificados[I].CNPJ <> '') then
    begin

      cdsCertificados.Append;
      cdsCertificadosCertificado.AsString := NFSe.ACBrNFSeX.SSL.ListaCertificados[I].SubjectName;
      cdsCertificadosDescricao.AsString   := NFSe.ACBrNFSeX.SSL.ListaCertificados[I].RazaoSocial;
      cdsCertificadosValidade.AsString    := FormatDateTime('dd/mm/yyyy', NFSe.ACBrNFSeX.SSL.ListaCertificados[I].DataVenc);
      cdsCertificadosNUMEROSERIE.AsString := NFSe.ACBrNFSeX.SSL.ListaCertificados[I].NumeroSerie;
      cdsCertificadosTIPO.AsString        := 'Desconhecido';
      case NFSe.ACBrNFSeX.SSL.ListaCertificados[I].Tipo of
        tpcA1: cdsCertificadosTIPO.AsString        := 'A1';
        tpcA3: cdsCertificadosTIPO.AsString        := 'A3';
      end;
      cdsCertificados.Post;

    end;
  end;

  cdsCertificados.First;

  cdsCertificados.Locate('Certificado', CertificadoConfigurado,[]);

  FreeAndNil(NFSe);

end;

procedure TfrmSelecionaCertificadoNFSe.dbcgCertificadosDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
  btnSelectClick(Sender);
end;

function TfrmSelecionaCertificadoNFSe.GetValidadeCertificado(NumeroSerie: string):string;
var
  DtVencimento : TDateTime;
begin
  Result := '';

  try
    ACBrNFSeX.Configuracoes.Certificados.NumeroSerie := NumeroSerie;
    DtVencimento := ACBrNFSeX.SSL.CertDataVenc;
    Result := DateToStr(DtVencimento);
  except
  end;
end;

end.
