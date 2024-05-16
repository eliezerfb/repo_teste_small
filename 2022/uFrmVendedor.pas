unit uFrmVendedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmVendedor = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    tbsFoto: TTabSheet;
    tbsComissao: TTabSheet;
    Label81: TLabel;
    Label82: TLabel;
    SMALL_DBEdit61: TSMALL_DBEdit;
    SMALL_DBEdit62: TSMALL_DBEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    imgEndereco: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    edtCPFCNPJ: TSMALL_DBEdit;
    edtRazaoSocial: TSMALL_DBEdit;
    edtCEP: TSMALL_DBEdit;
    edtEndereco: TSMALL_DBEdit;
    edtBairro: TSMALL_DBEdit;
    edtEstado: TSMALL_DBEdit;
    edtRG_IE: TSMALL_DBEdit;
    edtTelefone: TSMALL_DBEdit;
    edtCelular: TSMALL_DBEdit;
    edtWhatsApp: TSMALL_DBEdit;
    edtEmail: TSMALL_DBEdit;
    edtCadastro: TSMALL_DBEdit;
    edtNascido: TSMALL_DBEdit;
    fraMunicipio: TfFrameCampo;
    DSCadastroVen: TDataSource;
    procedure tbsComissaoEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmVendedor: TFrmVendedor;

implementation

{$R *.dfm}

uses unit7;

{ TFrmVendedor }

procedure TFrmVendedor.FormShow(Sender: TObject);
begin
  inherited;

  pgcFicha.ActivePage := tbsCadastro;

  if edtCPFCNPJ.Canfocus then
    edtCPFCNPJ.SetFocus;
end;

function TFrmVendedor.GetPaginaAjuda: string;
begin
  Result := 'config_vendedores.htm';
end;

procedure TFrmVendedor.SetaStatusUso;
begin
  inherited;

end;

procedure TFrmVendedor.tbsComissaoEnter(Sender: TObject);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2.Post;
    Form7.IBDataSet2.Edit;
  except
  end;
end;

end.
