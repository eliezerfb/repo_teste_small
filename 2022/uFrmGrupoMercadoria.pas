unit uFrmGrupoMercadoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmGrupoMercadoria = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
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

function TFrmGrupoMercadoria.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmGrupoMercadoria.SetaStatusUso;
begin
  inherited;
  //
end;

end.
