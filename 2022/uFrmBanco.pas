unit uFrmBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmBanco = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmBanco: TFrmBanco;

implementation

{$R *.dfm}

uses unit7;

{ TFrmBanco }

function TFrmBanco.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmBanco.SetaStatusUso;
begin
  inherited;
  //
end;

end.
