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
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles
  , CAPICOM_TLB, MSXML2_TLB;

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
    {Evento responsável por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formulário.
    É chamado quando o usuário clica no botão btnSelect.}
    procedure btnSelectClick(Sender: TObject);
    {Evento responsável por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formulário.
    É chamado quando o usuário dá um duplo clique na linha do lbList.}
    procedure lbListDblClick(Sender: TObject);
    {Evento que fdz a chamada para a remoção de um certificado por spdNfe.}
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    {Campo que guarda a hash do certificado escolhido}
    FSelectedCertificateName: String;
    FModeloECF: String;
    {Esta função atualiza na property SelectedCertificate o certificado escolhido pelo usuário
    ao clicar em btnSelect ou dar um duplo clique em uma das linhas de lbList}
    procedure UpdateSelectedCertificate;
  published
    {Property que guarda o nome do certificado escolhido}
    property SelectedCertificateName : String read FSelectedCertificateName write FSelectedCertificateName;
    property ModeloECF: String read FModeloECF write FModeloECF;
  end;

var
  {Varíável do formulário de seleção de certificados}
  frmSelectCertificate: TfrmSelectCertificate;

implementation

uses Fiscal, _Small_59, _small_65;

{$R *.dfm}

{ TfrmSelectCertificate }

procedure TfrmSelectCertificate.btnSelectClick(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  UpdateSelectedCertificate;
  Mais1ini := TIniFile.Create('frente.ini');
  if FModeloECF = '65' then
    Mais1Ini.WriteString('NFCE','Certificado',SelectedCertificateName);
  if (FModeloECF <> '59') and (FModeloECF <> '65') then
    Mais1Ini.WriteString('Frente de caixa', 'Certificado', SelectedCertificateName);
  Mais1ini.Free;
end;

procedure TfrmSelectCertificate.UpdateSelectedCertificate;
begin
  if lbList.ItemIndex = - 1 then
    SelectedCertificateName := ''
  else
    SelectedCertificateName := lbList.Items[lbList.ItemIndex];
end;

procedure TfrmSelectCertificate.lbListDblClick(Sender: TObject);
begin
  UpdateSelectedCertificate;
  frmSelectCertificate.btnSelectClick(Sender);
  ModalResult := mrOk;
end;

procedure TfrmSelectCertificate.btnRemoveClick(Sender: TObject);
begin
  UpdateSelectedCertificate;
  ModalResult := mrIgnore;
end;

procedure TfrmSelectCertificate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lbList.Items.Clear;
end;

procedure TfrmSelectCertificate.FormCreate(Sender: TObject);
begin
  FModeloECF := '65';
end;

procedure TfrmSelectCertificate.FormActivate(Sender: TObject);
  procedure ListaCertificados(CertList: TStrings);
  var
    Store : IStore3;
    CertsLista: ICertificates2;
    CertDados: ICertificate;
    iCert: Integer;
  begin
    Store := CoStore.Create;
    Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

    CertsLista       := Store.Certificates as ICertificates2;
    if not(CertsLista.Count = 0) then
    begin
      for iCert := 1 to CertsLista.Count do
      begin
        CertDados := IInterface(CertsLista.Item[iCert]) as ICertificate2;
        CertList.Add(CertDados.SubjectName);
      end;
    end;
    if CertDados <> nil then
      CertDados := nil;
    if CertsLista <> nil then
      CertsLista := nil;
    if Store <> nil then
      Store := nil;
  end;
begin
  if (FModeloECF <> '59') and (FModeloECF <> '65') then
  begin
    lbList.Items.Clear;
    ListaCertificados(lbList.Items);// Precisa ser desta maneira. Tecnospeed carrega apenas parte do nome dos certificados
  end;
end;

procedure TfrmSelectCertificate.btnCancelClick(Sender: TObject);
var
  Mais1Ini : TIniFile;
begin
  {Sandro Silva 2019-02-25 inicio}
  // permitir não selecionar certificado e usar apenas para lançamentos nas mesas
  UpdateSelectedCertificate;
  Mais1ini := TIniFile.Create('frente.ini');
  if FModeloECF = '65' then
  begin
    if Mais1Ini.ReadString('NFCE','Certificado','') = '' then
      Mais1Ini.WriteString('NFCE','Certificado','XXX'); // Para evitar que fique em loop na abertura quando não tem certificado digital instalado e quer usar para lançar nas mesas, por exemplo
  end;
  //  if (FModeloECF <> '59') and (FModeloECF <> '65') then
  //    Mais1Ini.WriteString('Frente de caixa', 'Certificado', SelectedCertificateName);
  Mais1ini.Free;
  {Sandro Silva 2019-02-25 fim}
end;

end.
