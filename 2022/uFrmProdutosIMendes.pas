unit uFrmProdutosIMendes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, uClassesIMendes, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.DBClient;

  function GetCodigoImendesProd(Produtos : TArray<TProdutoImendes>):integer;

type
  TFrmProdutosIMendes = class(TFrmPadrao)
    dbgProdutos: TDBGrid;
    btnOk: TBitBtn;
    DSProdutos: TDataSource;
    cdsProdutos: TClientDataSet;
    cdsProdutosDescricao: TStringField;
    cdsProdutosCodImendes: TIntegerField;
    cdsProdutosCodEAN: TStringField;
    cdsProdutosCest: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure dbgProdutosDblClick(Sender: TObject);
  private
    { Private declarations }
    iCodImendes : integer;
  public
    { Public declarations }
  end;

var
  FrmProdutosIMendes: TFrmProdutosIMendes;

implementation

{$R *.dfm}

function GetCodigoImendesProd(Produtos : TArray<TProdutoImendes>):integer;
var
  i : integer;
begin
  Result := 0;

  try
    FrmProdutosIMendes := TFrmProdutosIMendes.create(nil);
    FrmProdutosIMendes.cdsProdutos.CreateDataset;

    for I := Low(Produtos) to High(Produtos) do
    begin
      FrmProdutosIMendes.cdsProdutos.Append;
      FrmProdutosIMendes.cdsProdutosCodImendes.AsInteger := StrToIntDef(Produtos[i].Id,0);
      FrmProdutosIMendes.cdsProdutosDescricao.AsString   := Produtos[i].Descricao;
      FrmProdutosIMendes.cdsProdutosCodEAN.AsString      := Produtos[i].Ean;
      FrmProdutosIMendes.cdsProdutosCest.AsString        := Produtos[i].Cest;
      FrmProdutosIMendes.cdsProdutos.Post;
    end;

    FrmProdutosIMendes.cdsProdutos.First;

    FrmProdutosIMendes.ShowModal;

    Result := FrmProdutosIMendes.iCodImendes;
  finally
    FreeAndNil(FrmProdutosIMendes);
  end;
end;


procedure TFrmProdutosIMendes.btnOkClick(Sender: TObject);
begin
  iCodImendes := cdsProdutosCodImendes.AsInteger;
  Close;
end;

procedure TFrmProdutosIMendes.dbgProdutosDblClick(Sender: TObject);
begin
  iCodImendes := cdsProdutosCodImendes.AsInteger;
  Close;
end;

procedure TFrmProdutosIMendes.FormCreate(Sender: TObject);
begin
  iCodImendes := 0;
end;

end.
