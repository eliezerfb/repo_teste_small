unit uGeraRelatorioProdMonofasicoNota;

interface

uses
  uIGeraRelatorioProdMonofasico, uSmallEnumerados, IBX.IBDataBase,
  uIEstruturaTipoRelatorioPadrao, SysUtils, udmRelProdMonofasicoNota;

type
  TGeraRelatorioProdMonofasicoNota = class(TInterfacedObject, IGeraRelatorioProdMonofasico)
  private
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    FoTransaction: TIBTransaction;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FodmDados: TdmRelProdMonofasicoNota;
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

{ TGeraRelatorioProdMonofasicoNota }

uses
  uEstruturaRelProdMonofasicoNota, uIEstruturaRelatorioPadrao,
  uDadosRelatorioPadraoDAO, uEstruturaTipoRelatorioPadrao;

procedure TGeraRelatorioProdMonofasicoNota.CarregaDados;
begin
  FodmDados.CarregaDados(FdDataIni, FdDataFim);
end;

constructor TGeraRelatorioProdMonofasicoNota.Create;
begin
  FodmDados := TdmRelProdMonofasicoNota.Create(nil);
end;

destructor TGeraRelatorioProdMonofasicoNota.Destroy;
begin
  FreeAndNil(FodmDados);
  inherited;
end;

function TGeraRelatorioProdMonofasicoNota.GeraRelatorio: IGeraRelatorioProdMonofasico;
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  cTitulo: String;
begin
  Result := Self;

  CarregaDados;

  FoEstrutura := TEstruturaTipoRelatorioPadrao.New
                                       .setUsuario(FcUsuario);

  // Gera o cabeçalho
  FoEstrutura.GerarImpressaoCabecalho(TEstruturaRelProdMonofasicoNota.New
                                                                      .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                                      .setDataBase(FoTransaction.DefaultDatabase)
                                                                             ));

  // Dados dos itens
  oEstruturaRel := TEstruturaRelProdMonofasicoNota.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsDados)
                                                          );
  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr);

  // Totalizador CFOP
  oEstruturaRel := TEstruturaRelProdMonofasicoNota.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsCFOP)
                                                          );
  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por CFOP');

  // Totalizador CSTICMS/CSOSN
  oEstruturaRel := TEstruturaRelProdMonofasicoNota.New
                                                   .setDAO(TDadosRelatorioPadraoDAO.New
                                                                                   .setDataBase(FoTransaction.DefaultDatabase)
                                                                                   .CarregarDados(FodmDados.cdsCSTICMSCSOSN)
                                                          );
  cTitulo := FodmDados.cdsCSTICMSCSOSNCSTICMS.DisplayLabel;
  if FodmDados.cdsCSTICMSCSOSNCSOSN.Visible then
    cTitulo := FodmDados.cdsCSTICMSCSOSNCSOSN.DisplayLabel;

  FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por ' + cTitulo);
end;

function TGeraRelatorioProdMonofasicoNota.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

class function TGeraRelatorioProdMonofasicoNota.New: IGeraRelatorioProdMonofasico;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoNota.setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TGeraRelatorioProdMonofasicoNota.setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FoTransaction := AoTransaction;

  FodmDados.Transaction := FoTransaction;
end;

function TGeraRelatorioProdMonofasicoNota.setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FcUsuario := AcUsuario;
end;

end.
