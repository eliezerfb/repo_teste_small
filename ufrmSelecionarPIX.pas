unit ufrmSelecionarPIX;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, IBX.IBQuery;

type
  TFrmSelecionarPIX = class(TForm)
    DBGrid1: TDBGrid;
    DSBancosPIX: TDataSource;
    pnlMenu: TPanel;
    btnSelect: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnSelectClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    BancoSelecionado : Boolean;
  public
    { Public declarations }
  end;

  function SelecionaChavePIX(ibqBancos: TIBQuery):Boolean;

var
  FrmSelecionarPIX: TFrmSelecionarPIX;

implementation

{$R *.dfm}

procedure TFrmSelecionarPIX.btnCancelClick(Sender: TObject);
begin
  BancoSelecionado := False;
  Close;
end;

procedure TFrmSelecionarPIX.btnSelectClick(Sender: TObject);
begin
  BancoSelecionado := True;
  Close;
end;

procedure TFrmSelecionarPIX.DBGrid1DblClick(Sender: TObject);
begin
  btnSelectClick(Sender);
end;

function SelecionaChavePIX(ibqBancos: TIBQuery):Boolean;
begin
  Result := False;

  try
    FrmSelecionarPIX := TFrmSelecionarPIX.Create(nil);
    FrmSelecionarPIX.DSBancosPIX.DataSet := ibqBancos;
    FrmSelecionarPIX.ShowModal;

    Result := FrmSelecionarPIX.BancoSelecionado;
  finally
    FreeAndNil(FrmSelecionarPIX);
  end;
end;

end.
