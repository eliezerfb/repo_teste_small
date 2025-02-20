unit uGeraRelatorioProdMonofasicoCupomNota;

interface

uses
  uIGeraRelatorioProdMonofasicoCupomNota, uSmallEnumerados, IBDataBase,
  IBQuery, SysUtils, uIEstruturaTipoRelatorioPadrao,
  DB, DBClient, Variants, smallfunc_xe, Windows;

type
  TGeraRelatorioProdMonofasicoCupomNota = class(TInterfacedObject, IGeraRelatorioProdMonofasicoCupomNota)
  private
    FcUsuario: String;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    FoTransaction: TIBTransaction;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
  public
    class function New: IGeraRelatorioProdMonofasicoCupomNota;
    function setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupomNota;
    function setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupomNota;
    function setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupomNota;
    function getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
    function Salvar(AcCaminho: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioProdMonofasicoCupomNota;
    function GeraRelatorio: IGeraRelatorioProdMonofasicoCupomNota;
  end;


implementation

uses
  uGeraRelatorioProdMonofasicoCupom, uGeraRelatorioProdMonofasicoNota,
  uEstruturaTipoRelatorioPadrao;

{ GeraRelatorioProdMonofasicoCupomNota }

function TGeraRelatorioProdMonofasicoCupomNota.GeraRelatorio: IGeraRelatorioProdMonofasicoCupomNota;
begin
  Result := Self;

  FoEstrutura := TEstruturaTipoRelatorioPadrao.New
                                              .setUsuario(FcUsuario);


  TGeraRelatorioProdMonofasicoCupom.New
                                   .setEstrutura(FoEstrutura)
                                   .setTransaction(FoTransaction)
                                   .setUsuario(FcUsuario)
                                   .setPeriodo(FdDataIni, FdDataFim)
                                   .GeraRelatorio(False, True);

  TGeraRelatorioProdMonofasicoNota.New
                                  .setEstrutura(FoEstrutura)
                                  .setTransaction(FoTransaction)
                                  .setUsuario(FcUsuario)
                                  .setPeriodo(FdDataIni, FdDataFim)
                                  .GeraRelatorio(False, False);
end;

function TGeraRelatorioProdMonofasicoCupomNota.getEstruturaRelatorio: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

class function TGeraRelatorioProdMonofasicoCupomNota.New: IGeraRelatorioProdMonofasicoCupomNota;
begin
  Result := Self.Create;
end;

function TGeraRelatorioProdMonofasicoCupomNota.Salvar(AcCaminho: String; AenTipoRelatorio: uSmallEnumerados.tTipoRelatorio): IGeraRelatorioProdMonofasicoCupomNota;
var
  cArquivoAtual : String;
begin
  Result := Self;

  FoEstrutura.Salvar(AenTipoRelatorio);
  Sleep(200);

  cArquivoAtual := FcUsuario + ExtractFileExt(AcCaminho);

  if FileExists(cArquivoAtual) then
  begin
    if FileExists(ExtractFileName(AcCaminho)) then
    begin
      //DeleteFile(PAnsiChar(ExtractFileName(AcCaminho))); Mauricio Parizotto 2023-12-29
      DeleteFile(PChar(ExtractFileName(AcCaminho)));
      Sleep(150);
    end;

    RenameFile(cArquivoAtual, ExtractFileName(AcCaminho));
    Sleep(100);

    if FileExists(AcCaminho) then
    begin
      //DeleteFile(PAnsiChar(AcCaminho)); Mauricio Parizotto 2023-12-29
      DeleteFile(PChar(AcCaminho));
      Sleep(150);
    end;

    //MoveFile(PAnsiChar(ExtractFileName(AcCaminho)), PAnsiChar(AcCaminho)); Mauricio Parizotto 2023-12-29
    MoveFile(PChar(ExtractFileName(AcCaminho)), PChar(AcCaminho));
    Sleep(150);
  end;
end;

function TGeraRelatorioProdMonofasicoCupomNota.setPeriodo(AdDataIni, AdDataFim: TDateTime): IGeraRelatorioProdMonofasicoCupomNota;
begin
  Result := Self;

  FdDataIni := AdDataIni;
  FdDataFim := AdDataFim;
end;

function TGeraRelatorioProdMonofasicoCupomNota.setTransaction(AoTransaction: TIBTransaction): IGeraRelatorioProdMonofasicoCupomNota;
begin
  Result := Self;

  FoTransaction := AoTransaction;
end;

function TGeraRelatorioProdMonofasicoCupomNota.setUsuario(AcUsuario: String): IGeraRelatorioProdMonofasicoCupomNota;
begin
  Result := Self;

  FcUsuario := AcUsuario;
end;

end.
