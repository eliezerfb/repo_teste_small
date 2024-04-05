unit uFrmTransportadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmTransportadora = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmTransportadora: TFrmTransportadora;

implementation

{$R *.dfm}

uses unit7;

{ TFrmTransportadora }

function TFrmTransportadora.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmTransportadora.SetaStatusUso;
begin
  inherited;
  //
end;

end.
