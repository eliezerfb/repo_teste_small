unit uFrmContaBancaria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmContaBancaria = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmContaBancaria: TFrmContaBancaria;

implementation

{$R *.dfm}

uses unit7;

{ TFrmContaBancaria }

function TFrmContaBancaria.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmContaBancaria.SetaStatusUso;
begin
  inherited;
  //
end;

end.
