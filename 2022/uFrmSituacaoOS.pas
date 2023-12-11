unit uFrmSituacaoOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmFichaPadrao, DB, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  Mask, DBCtrls, SMALL_DBEdit;

type
  TFrmSituacaoOS = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    edtSituacao: TSMALL_DBEdit;
    Label129: TLabel;
    procedure FormShow(Sender: TObject);
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmSituacaoOS: TFrmSituacaoOS;

implementation

uses Unit7;

{$R *.dfm}

procedure TFrmSituacaoOS.FormShow(Sender: TObject);
begin
  inherited;

  if edtSituacao.CanFocus then
    edtSituacao.SetFocus;
end;

function TFrmSituacaoOS.GetPaginaAjuda: string;
begin
  Result := 'INDEX.HTM';
end;

procedure TFrmSituacaoOS.SetaStatusUso;
begin
  inherited;

  edtSituacao.Enabled          := not(bEstaSendoUsado);
end;

procedure TFrmSituacaoOS.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State = dsEdit then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

end.
