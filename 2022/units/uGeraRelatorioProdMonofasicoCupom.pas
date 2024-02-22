unit uGeraRelatorioProdMonofasicoCupom;

interface

uses
  uIGeraRelatorioProdMonofasico, uSmallEnumerados, IBDataBase,
  uIEstruturaTipoRelatorioPadrao, SysUtils, udmRelProdMonofasicoCupom;

type
  TGeraRelatorioProdMonofasicoCupom = class(TInterfacedObject, IGeraRelatorioProdMonofasico)
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
    class function New: IGeraRelatorioProdMonofasico;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasico;
    function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasico;
    function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasico;
    function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
    function GeraRelatorio: IGeraRelatorioProdMonofasico;
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

function TGeraRelatorioProdMonofasicoCupom.GeraRelatorio: IGeraRelatorioProdMonofasico;
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

class function TGeraRelatorioProdMonofasicoCupom.New: IGeraRelatorioProdMonofasico;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoCupom.setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TGeraRelatorioProdMonofasicoCupom.setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FoTransaction := AoTransaction;

  FodmDados.Transaction := FoTransaction;
end;

function TGeraRelatorioProdMonofasicoCupom.setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FcUsuario := AcUsuario;
end;

end.
