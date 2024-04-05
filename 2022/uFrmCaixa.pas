unit uFrmCaixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmCaixa = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmCaixa: TFrmCaixa;

implementation

{$R *.dfm}

uses unit7;

{ TFrmCaixa }

function TFrmCaixa.GetPaginaAjuda: string;
begin
  //
end;

procedure TFrmCaixa.SetaStatusUso;
begin
  inherited;
  //
end;

end.
