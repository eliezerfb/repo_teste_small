unit uGeraRelatorioProdMonofasicoCupom;

interface

uses
  uIGeraRelatorioProdMonofasicoCupom, uSmallEnumerados, IBDataBase,
  uIEstruturaTipoRelatorioPadrao, SysUtils, udmRelProdMonofasicoCupom;

type
  TGeraRelatorioProdMonofasicoCupom = class(TInterfacedObject, IGeraRelatorioProdMonofasicoCupom)
  private
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    FoTransaction: TIBTransaction;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FodmDados: TdmRelProdMonofasicoCupom;
    procedure CarregaDados;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IGeraRelatorioProdMonofasicoCupom;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupom;
    function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupom;
    function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupom;
    function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
    function GeraRelatorio: IGeraRelatorioProdMonofasicoCupom;
    function Imprimir: IGeraRelatorioProdMonofasicoCupom;
  end;

implementation

{ TGeraRelatorioProdMonofasicoCupom }

uses
  uEstruturaRelProdMonofasicoCupom, uIEstruturaRelatorioPadrao,
  uDadosRelatorioPadraoDAO, uEstruturaTipoRelatorioPadrao;

procedure TGeraRelatorioProdMonofasicoCupom.CarregaDados;
begin
  FodmDados.CarregaDados(FdDataIni, FdDataFim);
end;

constructor TGeraRelatorioProdMonofasicoCupom.Create;
begin
  FodmDados := TdmRelProdMonofasicoCupom.Create(nil);
end;

destructor TGeraRelatorioProdMonofasicoCupom.Destroy;
begin
  FreeAndNil(FodmDados);
  inherited;
end;

function TGeraRelatorioProdMonofasicoCupom.GeraRelatorio: IGeraRelatorioProdMonofasicoCupom;
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  cTitulo: String;
begin
  Result := Self;

  CarregaDados;

  FoEstrutura := TEstruturaTipoRelatorioPadrao.New
                                       .setUsuario(FcUsuario);

  // Gera o cabeçalho
  FoEstrutura.GerarImpressaoCabecalho(TEstruturaRelProdMonofasicoCupom.New
                                                                      .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                                      .setDataBase(FoTransaction.DefaultDatabase)
                                                                             ));

  // Dados dos itens
  oEstruturaRel := TEstruturaRelProdMonofasicoCupom.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsDados)
                                                          );
  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr);

  // Totalizador CFOP
  oEstruturaRel := TEstruturaRelProdMonofasicoCupom.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsCFOP)
                                                          );
  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por CFOP');

  // Totalizador CSTICMS/CSOSN
  oEstruturaRel := TEstruturaRelProdMonofasicoCupom.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsCSTICMSCSOSN)
                                                          );
  cTitulo := FodmDados.cdsCSTICMSCSOSNCSTICMS.DisplayLabel;
  if FodmDados.cdsCSTICMSCSOSNCSOSN.Visible then
    cTitulo := FodmDados.cdsCSTICMSCSOSNCSOSN.DisplayLabel;

  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por ' + cTitulo);
end;

function TGeraRelatorioProdMonofasicoCupom.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

function TGeraRelatorioProdMonofasicoCupom.Imprimir: IGeraRelatorioProdMonofasicoCupom;
begin
  Result := Self;
end;

class function TGeraRelatorioProdMonofasicoCupom.New: IGeraRelatorioProdMonofasicoCupom;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoCupom.setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupom;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TGeraRelatorioProdMonofasicoCupom.setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupom;
begin
  Result := Self;

  FoTransaction := AoTransaction;

  FodmDados.Transaction := FoTransaction;
end;

function TGeraRelatorioProdMonofasicoCupom.setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupom;
begin
  Result := Self;

  FcUsuario := AcUsuario;
end;

end.
