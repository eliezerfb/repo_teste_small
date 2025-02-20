unit uRelatorioCatalogoProdudos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormRelatorioPadrao, StdCtrls, Buttons, ExtCtrls, DB,
  uIEstruturaTipoRelatorioPadrao, IBDataBase;

type
  TfrmRelatorioCatalogoProduto = class(TfrmRelatorioPadrao)
    procedure FormCreate(Sender: TObject);
  private
    FnRecNo: Integer;
    FcTextoFiltro: String;
    FDataSet: TDataSet;
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    function getDataSet: TDataSet;
    procedure setDataSet(const Value: TDataSet);
    function getUsuario: String;
    procedure setUsuario(const Value: String);
    function getTextoFiltro: String;
    procedure setTextoFiltro(const Value: String);
  public
    property DataSet: TDataSet read getDataSet write setDataSet;
    property Usuario: String read getUsuario write setUsuario;
    property TextoFiltro: String read getTextoFiltro write setTextoFiltro;
    procedure Imprimir;
  protected
    function Estrutura: IEstruturaTipoRelatorioPadrao; override;
  end;

var
  frmRelatorioCatalogoProduto: TfrmRelatorioCatalogoProduto;

implementation

uses
  uEstruturaTipoRelatorioPadrao, uEstruturaRelCatalogoProdutos,
  uDadosRelatorioPadraoDAO, uIEstruturaRelatorioPadrao;

{$R *.dfm}

{ TfrmRelatorioCatalogoProduto }

function TfrmRelatorioCatalogoProduto.getDataSet: TDataSet;
begin
  Result := FDataSet;
end;

procedure TfrmRelatorioCatalogoProduto.setDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

function TfrmRelatorioCatalogoProduto.getUsuario: String;
begin
  Result := FcUsuario;
end;

procedure TfrmRelatorioCatalogoProduto.setUsuario(const Value: String);
begin
  FcUsuario := Value;
end;

procedure TfrmRelatorioCatalogoProduto.Imprimir;
var
  oEstruturaCat: IEstruturaRelatorioPadrao;
begin
  FnRecNo := FDataSet.RecNo;
  FDataSet.DisableControls;
  try
    FDataSet.First;
    FoEstrutura.setUsuario(FcUsuario);
    oEstruturaCat := TEstruturaRelCatalogoProdutos.New
                                                  .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                  .setDataBase(DataBase)
                                                                                  .CarregarDados(FDataSet)
                                                         );
                                                         

    oEstruturaCat.FiltrosRodape.AddItem('Número de registros: ' + IntToStr(FDataSet.RecordCount));
    oEstruturaCat.FiltrosRodape.AddItem(FcTextoFiltro);

    FoEstrutura.GerarImpressao(oEstruturaCat);

    btnAvancar.Click;
  finally
    FDataSet.RecNo := FnRecNo;
    FDataSet.EnableControls;
  end;
end;

procedure TfrmRelatorioCatalogoProduto.FormCreate(Sender: TObject);
begin
  inherited;
  FoEstrutura := TEstruturaTipoRelatorioPadrao.New;
end;

function TfrmRelatorioCatalogoProduto.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

function TfrmRelatorioCatalogoProduto.getTextoFiltro: String;
begin
  Result := FcTextoFiltro;
end;

procedure TfrmRelatorioCatalogoProduto.setTextoFiltro(const Value: String);
begin
  FcTextoFiltro := Value;
end;

end.
