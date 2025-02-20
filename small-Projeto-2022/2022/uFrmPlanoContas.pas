unit uFrmPlanoContas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmPlanoContas = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtConta: TSMALL_DBEdit;
    edtNomeConta: TSMALL_DBEdit;
    Label1: TLabel;
    edtDia: TSMALL_DBEdit;
    Label2: TLabel;
    edtMes: TSMALL_DBEdit;
    Label3: TLabel;
    edtAno: TSMALL_DBEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtSaldo: TSMALL_DBEdit;
    Label6: TLabel;
    edtDescContabil: TSMALL_DBEdit;
    Label7: TLabel;
    edtCodContabil: TSMALL_DBEdit;
    Label8: TLabel;
    edtIdentificador: TSMALL_DBEdit;
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
  FrmPlanoContas: TFrmPlanoContas;

implementation

{$R *.dfm}

uses unit7;

{ TFrmPlanoContas }

procedure TFrmPlanoContas.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmPlanoContas.FormShow(Sender: TObject);
begin
  inherited;

  if edtConta.CanFocus then
    edtConta.SetFocus;
end;

function TFrmPlanoContas.GetPaginaAjuda: string;
begin
  Result := 'config_plano_contas.htm';
end;

procedure TFrmPlanoContas.lblNovoClick(Sender: TObject);
begin
  inherited;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmPlanoContas.SetaStatusUso;
begin
  inherited;

  edtConta.Enabled         := not(bEstaSendoUsado);
  edtNomeConta.Enabled     := not(bEstaSendoUsado);
  edtDia.Enabled           := not(bEstaSendoUsado);
  edtMes.Enabled           := not(bEstaSendoUsado);
  edtAno.Enabled           := not(bEstaSendoUsado);
  edtSaldo.Enabled         := not(bEstaSendoUsado);
  edtDescContabil.Enabled  := not(bEstaSendoUsado);
  edtCodContabil.Enabled   := not(bEstaSendoUsado);
  edtIdentificador.Enabled := not(bEstaSendoUsado);
end;

end.
