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
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, smallfunc;

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
  private
    {Campo que guarda a hash do certificado escolhido}
    FSelectedCertificateName: String;
    {Esta função atualiza na property SelectedCertificate o certificado escolhido pelo usuário
    ao clicar em btnSelect ou dar um duplo clique em uma das linhas de lbList}
    procedure UpdateSelectedCertificate;
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
  //
  UpdateSelectedCertificate;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  Mais1Ini.WriteString('NFE','Certificado',SelectedCertificateName);
  Mais1ini.Free;
  //
  try
    Form7.spdNFe.NomeCertificado.Text     := SelectedCertificateName;
  except end;
  //
  // Form7.N0TestarservidorNFe1Click(Sender);
  //
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
  ModalResult := mrOk;
  frmSelectCertificate.btnSelectClick(Sender);
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

end.
