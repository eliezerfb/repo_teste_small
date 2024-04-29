unit uFrmGrupoMercadoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmGrupoMercadoria = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtGrupo: TSMALL_DBEdit;
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
  FrmGrupoMercadoria: TFrmGrupoMercadoria;

implementation

{$R *.dfm}

uses unit7;

{ TFrmGrupoMercadoria }

procedure TFrmGrupoMercadoria.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmGrupoMercadoria.FormShow(Sender: TObject);
begin
  inherited;

  if edtGrupo.CanFocus then
    edtGrupo.SetFocus;
end;

function TFrmGrupoMercadoria.GetPaginaAjuda: string;
begin
  Result := 'est_grupos.htm';
end;

procedure TFrmGrupoMercadoria.lblNovoClick(Sender: TObject);
begin
  inherited;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmGrupoMercadoria.SetaStatusUso;
begin
  inherited;

  edtGrupo.Enabled   := not(bEstaSendoUsado);
end;

end.
