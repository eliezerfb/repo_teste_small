unit uFrmConvenio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmConvenio = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtConvenio: TSMALL_DBEdit;
    edtRazao: TSMALL_DBEdit;
    Label1: TLabel;
    edtTelefone: TSMALL_DBEdit;
    Label2: TLabel;
    edtEmail: TSMALL_DBEdit;
    Label3: TLabel;
    edtDesconto: TSMALL_DBEdit;
    Label4: TLabel;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmConvenio: TFrmConvenio;

implementation

{$R *.dfm}

uses unit7;

{ TFrmConvenio }

procedure TFrmConvenio.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State = dsEdit then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmConvenio.FormShow(Sender: TObject);
begin
  inherited;

  if edtConvenio.CanFocus then
    edtConvenio.SetFocus;
end;

function TFrmConvenio.GetPaginaAjuda: string;
begin
  Result := 'config_convenio.htm';
end;

procedure TFrmConvenio.lblNovoClick(Sender: TObject);
begin
  inherited;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmConvenio.SetaStatusUso;
begin
  inherited;

  edtConvenio.Enabled         := not(bEstaSendoUsado);
  edtRazao.Enabled            := not(bEstaSendoUsado);
  edtTelefone.Enabled         := not(bEstaSendoUsado);
  edtEmail.Enabled            := not(bEstaSendoUsado);
  edtDesconto.Enabled         := not(bEstaSendoUsado);
end;

end.
