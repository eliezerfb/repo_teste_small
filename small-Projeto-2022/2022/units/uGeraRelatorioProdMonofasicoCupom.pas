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
    procedure GeraRelatorioCupomNota(AbGeraCabecalho: Boolean = True);
  public
    destructor Destroy; override;
    class function New: IGeraRelatorioProdMonofasico;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasico;
    function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasico;
    function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasico;
    function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
    function GeraRelatorio(AbComTotCFOPCSTCSOSN: Boolean = True; AbGeraCabecalho: Boolean = True): IGeraRelatorioProdMonofasico;
    function setEstrutura(AoEstrutura: IEstruturaTipoRelatorioPadrao): IGeraRelatorioProdMonofasico;
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

function TGeraRelatorioProdMonofasicoCupom.GeraRelatorio(AbComTotCFOPCSTCSOSN: Boolean = True; AbGeraCabecalho: Boolean = True): IGeraRelatorioProdMonofasico;
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  cTitulo: String;
begin
  Result := Self;

  CarregaDados;

  if not Assigned(FoEstrutura) then
    FoEstrutura := TEstruturaTipoRelatorioPadrao.New
                                                .setUsuario(FcUsuario);

  if not AbComTotCFOPCSTCSOSN then
    GeraRelatorioCupomNota(AbGeraCabecalho)
  else
  begin
    // Gera o cabeçalho
    if AbGeraCabecalho then
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
    if not AbComTotCFOPCSTCSOSN then
      oEstruturaRel.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

    if AbGeraCabecalho then
      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr)
    else
    begin
      TEstruturaRelProdMonofasicoCupom.New.getTitulo(cTitulo);

      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, cTitulo);

      cTitulo := EmptyStr;
    end;

    if AbComTotCFOPCSTCSOSN then
    begin
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

      oEstruturaRel.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por ' + cTitulo);
    end;
  end;
end;

procedure TGeraRelatorioProdMonofasicoCupom.GeraRelatorioCupomNota(AbGeraCabecalho: Boolean = True);
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  cTitulo: String;
begin
  // Gera o cabeçalho
  if AbGeraCabecalho then
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

  if AbGeraCabecalho then
    FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr)
  else
  begin
    TEstruturaRelProdMonofasicoCupom.New.getTitulo(cTitulo);

    FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, cTitulo);

    cTitulo := EmptyStr;
  end;
end;

function TGeraRelatorioProdMonofasicoCupom.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

class function TGeraRelatorioProdMonofasicoCupom.New: IGeraRelatorioProdMonofasico;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoCupom.setEstrutura(AoEstrutura: IEstruturaTipoRelatorioPadrao): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FoEstrutura := AoEstrutura;
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
