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

function TGeraRelatorioProdMonofasicoNota.GeraRelatorio(AbComTotCFOPCSTCSOSN: Boolean = True; AbGeraCabecalho: Boolean = True): IGeraRelatorioProdMonofasico;
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

    if not AbComTotCFOPCSTCSOSN then
      oEstruturaRel.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

    if AbGeraCabecalho then
      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr)
    else
    begin
      TEstruturaRelProdMonofasicoNota.New.getTitulo(cTitulo);

      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, cTitulo);

      cTitulo := EmptyStr;
    end;

    if AbComTotCFOPCSTCSOSN then
    begin
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

      oEstruturaRel.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

      FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, 'Acumulado por ' + cTitulo);
    end;
  end;
end;

procedure TGeraRelatorioProdMonofasicoNota.GeraRelatorioCupomNota(AbGeraCabecalho: Boolean);
var
  oEstruturaRel: IEstruturaRelatorioPadrao;
  cTitulo: String;
begin
  // Gera o cabeçalho
  if AbGeraCabecalho then
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

  oEstruturaRel.FiltrosRodape.setFiltroData('Período analisado, de '+DateToStr(FdDataIni)+' até '+DateToStr(FdDataFim));

  if AbGeraCabecalho then
    FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, EmptyStr)
  else
  begin
    TEstruturaRelProdMonofasicoNota.New.getTitulo(cTitulo);

    FoEstrutura.GerarImpressaoAgrupado(oEstruturaRel, cTitulo);

    cTitulo := EmptyStr;
  end;
end;

function TGeraRelatorioProdMonofasicoNota.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

class function TGeraRelatorioProdMonofasicoNota.New: IGeraRelatorioProdMonofasico;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoNota.setEstrutura(AoEstrutura: IEstruturaTipoRelatorioPadrao): IGeraRelatorioProdMonofasico;
begin
  Result := Self;

  FoEstrutura := AoEstrutura;
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
