{
Parte integrante de uExemplo, o formulário de seleção de certificados é
responsável por mostrar uma lista contendo todos os certificados registrados no sistema,
para que o usuário possa selecionar qual certificado que será utilizado para validação junto
à SEFAZ.

@author(TecnoSpeed - Consultoria em TI (http://www.tecnospeed.com.br))
@created(Agosto/2008)}
unit SelecionaCertificado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, smallfunc, DB, DBClient, spdNFe,
  dbcgrids, Grids, DBGrids, DBCtrls;

type
  {Declaração da classe do formulário de seleção de certificados}
  TfrmSelectCertificate = class(TForm)
    {Listbox responsável por listar os certificados. O usuário pode selecionar o certificado desejado com um duplo clique na linha do mesmo.

    Com um duplo clique em qualquer linha do ListBox é chamado o evento lbListDblClick.
    }
    lbList: TListBox;
    {Botão de seleção: clicando neste botão o usuário pode selecionar o certificado que estiver marcado na lista.

    Ao clicar neste botão é chamado o evento btnSelectClick.
    }
    btnSelect: TBitBtn;
    {Botão de cancelamento: clicando neste botão o usuário pode cancelar a operação de seleção do certificado}
    btnCancel: TBitBtn;
    {Painel que contém o componente de listagem}
    pnlBody: TPanel;
    {Painel que contém os botões de seleção (btnSelect) e cancelamento (btnCancel)}
    pnlMenu: TPanel;
    {Botão de remoção de certificado}
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
    {Evento responsável por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formulário.
    É chamado quando o usuário clica no botão btnSelect.}
    procedure btnSelectClick(Sender: TObject);
    {Evento responsável por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formulário.
    É chamado quando o usuário dá um duplo clique na linha do lbList.}
    procedure lbListDblClick(Sender: TObject);
    {Evento que fdz a chamada para a remoção de um certificado por spdNfe.}
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure dbcgCertificadosDblClick(Sender: TObject);
  private
    {Campo que guarda a hash do certificado escolhido}
    FSelectedCertificateName: String;
    {Esta função atualiza na property SelectedCertificate o certificado escolhido pelo usuário
    ao clicar em btnSelect ou dar um duplo clique em uma das linhas de lbList}
    procedure UpdateSelectedCertificate;
    function GetValidadeCertificado(certificado: string): string;
  published
    {Property que guarda o nome do certificado escolhido}
    property SelectedCertificateName : String read FSelectedCertificateName write FSelectedCertificateName;
  end;

var
  {Varíável do formulário de seleção de certificados}
  frmSelectCertificate: TfrmSelectCertificate;

implementation

uses Mais, Unit7;

{$R *.dfm}

{ TfrmSelectCertificate }

procedure TfrmSelectCertificate.btnSelectClick(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  UpdateSelectedCertificate;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Certificado',SelectedCertificateName);
  Mais1ini.Free;

  try
    Form7.spdNFe.NomeCertificado.Text     := SelectedCertificateName;
  except
  end;
end;

procedure TfrmSelectCertificate.UpdateSelectedCertificate;
begin
  {
  if lbList.ItemIndex = - 1 then
    SelectedCertificateName := ''
  else
    SelectedCertificateName := lbList.Items[lbList.ItemIndex];
  Mauricio Parizotto 2023-11-06}
  SelectedCertificateName := cdsCertificadosCertificado.AsString;
end;

procedure TfrmSelectCertificate.lbListDblClick(Sender: TObject);
begin
  UpdateSelectedCertificate;
  ModalResult := mrOk;
  frmSelectCertificate.btnSelectClick(Sender);
end;

procedure TfrmSelectCertificate.btnRemoveClick(Sender: TObject);
begin
  //UpdateSelectedCertificate;
  //ModalResult := mrIgnore;
end;

procedure TfrmSelectCertificate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lbList.Items.Clear;
end;

procedure TfrmSelectCertificate.FormShow(Sender: TObject);
var
  i, posi :integer;
  Mais1Ini : TIniFile;
  CertificadoConfigurado : string;
  DescCertificado : string;
begin
  {Mauricio Parizotto 2023-11-06 Inicio}
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    CertificadoConfigurado := Mais1Ini.ReadString('NFE','Certificado','');
    Mais1ini.Free;
  finally
  end;

  cdsCertificados.Close;
  cdsCertificados.CreateDataSet;
  cdsCertificados.Open;

  for i := 0 to lbList.Items.Count -1 do
  begin
    posi := pos(',',lbList.Items[i]);
    if posi < 10 then
      posi := Length(lbList.Items[i]);

    DescCertificado := Copy(lbList.Items[i],1, posi -1);

    posi := pos('=',DescCertificado);
    if posi > 0 then
      DescCertificado := Copy(DescCertificado, posi +1, 200);

    cdsCertificados.Append;
    cdsCertificadosCertificado.AsString := lbList.Items[i];
    cdsCertificadosDescricao.AsString   := DescCertificado;
    cdsCertificadosValidade.AsString    := GetValidadeCertificado(lbList.Items[i]);

    cdsCertificados.Post;
  end;

  cdsCertificados.First;

  cdsCertificados.Locate('Certificado',CertificadoConfigurado,[]);
  {Mauricio Parizotto 2023-11-06 Fim}
end;

procedure TfrmSelectCertificate.dbcgCertificadosDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
  btnSelectClick(Sender);
end;

function TfrmSelectCertificate.GetValidadeCertificado(certificado:string):string;
var
  DtVencimento : TDateTime;
  spdNFe: TspdNFe;
begin
  Result := '';

  try
    try
      spdNFe := TspdNFe.create(nil);
      spdNFe.NomeCertificado.Text := certificado;
      DtVencimento := spdNFe.GetVencimentoCertificado;
      Result := DateToStr(DtVencimento);
    except
    end;
  finally
    FreeAndNil(spdNFe);
  end;
end;

end.
