unit uFrmTecnico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmTecnico = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtNome: TSMALL_DBEdit;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmTecnico: TFrmTecnico;

implementation

{$R *.dfm}

uses unit7;

procedure TFrmTecnico.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State = dsEdit then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmTecnico.FormShow(Sender: TObject);
begin
  inherited;

  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

function TFrmTecnico.GetPaginaAjuda: string;
begin
  Result := 'config_tecnicos.htm';
end;


procedure TFrmTecnico.SetaStatusUso;
begin
  inherited;

  edtNome.Enabled          := not(bEstaSendoUsado);
end;

end.
