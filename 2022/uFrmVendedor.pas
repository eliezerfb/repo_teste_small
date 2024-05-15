unit uFrmVendedor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmVendedor = class(TFrmFichaPadrao)
    tbsFicha: TTabSheet;
    tbsFoto: TTabSheet;
    tbsComissao: TTabSheet;
    Label81: TLabel;
    Label82: TLabel;
    SMALL_DBEdit61: TSMALL_DBEdit;
    SMALL_DBEdit62: TSMALL_DBEdit;
    procedure tbsComissaoEnter(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmVendedor: TFrmVendedor;

implementation

{$R *.dfm}

uses unit7;

{ TFrmVendedor }

function TFrmVendedor.GetPaginaAjuda: string;
begin
  Result := 'config_vendedores.htm';
end;

procedure TFrmVendedor.SetaStatusUso;
begin
  inherited;

end;

procedure TFrmVendedor.tbsComissaoEnter(Sender: TObject);
begin
  try
    if not (Form7.ibDataset2.State in ([dsEdit, dsInsert])) then Form7.ibDataset2.Edit;
    Form7.IBDataSet2.Post;
    Form7.IBDataSet2.Edit;
  except
  end;
end;

end.
