{
Parte integrante de uExemplo, o formul�rio de sele��o de certificados �
respons�vel por mostrar uma lista contendo todos os certificados registrados no sistema,
para que o usu�rio possa selecionar qual certificado que ser� utilizado para valida��o junto
� SEFAZ.

@author(TecnoSpeed - Consultoria em TI (http://www.tecnospeed.com.br))
@created(Agosto/2008)}
unit SelecionaCertificado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, smallfunc;

type
  {Declara��o da classe do formul�rio de sele��o de certificados}
  TfrmSelectCertificate = class(TForm)
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
    {Evento respons�vel por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formul�rio.
    � chamado quando o usu�rio clica no bot�o btnSelect.}
    procedure btnSelectClick(Sender: TObject);
    {Evento respons�vel por salvar o certificado escolhido na propriedade SelectedCertificate e fechar o formul�rio.
    � chamado quando o usu�rio d� um duplo clique na linha do lbList.}
    procedure lbListDblClick(Sender: TObject);
    {Evento que fdz a chamada para a remo��o de um certificado por spdNfe.}
    procedure btnRemoveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    {Campo que guarda a hash do certificado escolhido}
    FSelectedCertificateName: String;
    {Esta fun��o atualiza na property SelectedCertificate o certificado escolhido pelo usu�rio
    ao clicar em btnSelect ou dar um duplo clique em uma das linhas de lbList}
    procedure UpdateSelectedCertificate;
  published
    {Property que guarda o nome do certificado escolhido}
    property SelectedCertificateName : String read FSelectedCertificateName write FSelectedCertificateName;
  end;

var
  {Var��vel do formul�rio de sele��o de certificados}
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
