unit uFrmProdutosDevolucao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Grids, DBGrids, Buttons, DB,
  IBCustomDataSet, DBClient, Provider;

type
  TFrmProdutosDevolucao = class(TFrmPadrao)
    DBGrid1: TDBGrid;
    Label10: TLabel;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    DSProdutos: TDataSource;
    cdsProdutosNota: TClientDataSet;
    ibdProdutosNota: TIBDataSet;
    ibdProdutosNotaMARCADO: TIBStringField;
    ibdProdutosNotaNUMERONF: TIBStringField;
    ibdProdutosNotaCODIGO: TIBStringField;
    ibdProdutosNotaDESCRICAO: TIBStringField;
    ibdProdutosNotaST: TIBStringField;
    ibdProdutosNotaIPI: TFloatField;
    ibdProdutosNotaICM: TFloatField;
    ibdProdutosNotaBASE: TFloatField;
    ibdProdutosNotaMEDIDA: TIBStringField;
    ibdProdutosNotaQUANTIDADE: TFloatField;
    ibdProdutosNotaUNITARIO: TFloatField;
    ibdProdutosNotaTOTAL: TFloatField;
    ibdProdutosNotaPESO: TFloatField;
    ibdProdutosNotaCST_PIS_COFINS: TIBStringField;
    ibdProdutosNotaALIQ_PIS: TIBBCDField;
    ibdProdutosNotaVICMS: TIBBCDField;
    ibdProdutosNotaVBC: TIBBCDField;
    ibdProdutosNotaVICMSST: TIBBCDField;
    ibdProdutosNotaVIPI: TIBBCDField;
    ibdProdutosNotaCST_IPI: TIBStringField;
    ibdProdutosNotaCST_ICMS: TIBStringField;
    ibdProdutosNotaVBCFCP: TIBBCDField;
    ibdProdutosNotaPFCP: TIBBCDField;
    ibdProdutosNotaVFCP: TIBBCDField;
    ibdProdutosNotaVBCFCPST: TIBBCDField;
    ibdProdutosNotaPFCPST: TIBBCDField;
    ibdProdutosNotaVFCPST: TIBBCDField;
    ibdProdutosNotaICMS_DESONERADO: TIBBCDField;
    dspProdutosNota: TDataSetProvider;
    cdsProdutosNotaMARCADO: TStringField;
    cdsProdutosNotaNUMERONF: TStringField;
    cdsProdutosNotaCODIGO: TStringField;
    cdsProdutosNotaDESCRICAO: TStringField;
    cdsProdutosNotaST: TStringField;
    cdsProdutosNotaIPI: TFloatField;
    cdsProdutosNotaICM: TFloatField;
    cdsProdutosNotaBASE: TFloatField;
    cdsProdutosNotaMEDIDA: TStringField;
    cdsProdutosNotaQUANTIDADE: TFloatField;
    cdsProdutosNotaUNITARIO: TFloatField;
    cdsProdutosNotaTOTAL: TFloatField;
    cdsProdutosNotaPESO: TFloatField;
    cdsProdutosNotaCST_PIS_COFINS: TStringField;
    cdsProdutosNotaALIQ_PIS: TBCDField;
    cdsProdutosNotaVICMS: TBCDField;
    cdsProdutosNotaVBC: TBCDField;
    cdsProdutosNotaVICMSST: TBCDField;
    cdsProdutosNotaVIPI: TBCDField;
    cdsProdutosNotaCST_IPI: TStringField;
    cdsProdutosNotaCST_ICMS: TStringField;
    cdsProdutosNotaVBCFCP: TBCDField;
    cdsProdutosNotaPFCP: TBCDField;
    cdsProdutosNotaVFCP: TBCDField;
    cdsProdutosNotaVBCFCPST: TBCDField;
    cdsProdutosNotaPFCPST: TBCDField;
    cdsProdutosNotaVFCPST: TBCDField;
    cdsProdutosNotaICMS_DESONERADO: TBCDField;
    ibdProdutosNotaVBCST: TIBBCDField;
    cdsProdutosNotaVBCST: TBCDField;
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProdutosDevolucao: TFrmProdutosDevolucao;

implementation

uses uFrmParametroTributacao, Mais;

{$R *.dfm}

procedure TFrmProdutosDevolucao.FormCreate(Sender: TObject);
begin
  cdsProdutosNota.Open;
end;

procedure TFrmProdutosDevolucao.DBGrid1CellClick(Column: TColumn);
begin
  if Column.FieldName = 'MARCADO' then
  begin
    cdsProdutosNota.Edit;
    cdsProdutosNotaMARCADO.AsString := 'N';
    cdsProdutosNota.Post;
  end;
end;

end.
