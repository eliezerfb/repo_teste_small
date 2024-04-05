unit uFrmConvenio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmConvenio = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
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

function TFrmConvenio.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmConvenio.SetaStatusUso;
begin
  inherited;
  //
end;

end.
