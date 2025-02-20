unit uEstruturaRelGenerico;

interface

uses
  uIEstruturaRelGenerico
  , uIEstruturaTipoRelatorioPadrao
  , IBDatabase
  , uIEstruturaRelatorioPadrao
  , Classes
  , SysUtils
  , smallfunc_xe
  , IBQuery;

type
  TEstruturaRelGenerico = class(TInterfacedObject, IEstruturaRelGenerico)
  private
    FoDataBase: TIBDatabase;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IEstruturaRelGenerico;
    function setUsuario(AcUsuario: String): IEstruturaRelGenerico;
    function setDataBase(AoDataBase: TIBDatabase): IEstruturaRelGenerico;
    function Estrutura: IEstruturaTipoRelatorioPadrao;
  end;

implementation

uses
  uEstruturaTipoRelatorioPadrao,
  uDadosRelatorioPadraoDAO;

{ TEstruturaRelGenerico }

constructor TEstruturaRelGenerico.Create;
begin
  FoEstrutura := TEstruturaTipoRelatorioPadrao.New;
end;

function TEstruturaRelGenerico.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;


class function TEstruturaRelGenerico.New: IEstruturaRelGenerico;
begin
  Result := Self.Create;
end;

function TEstruturaRelGenerico.setDataBase(AoDataBase: TIBDatabase): IEstruturaRelGenerico;
begin
  Result := Self;

  FoDataBase := AoDataBase;

  FoEstrutura.setDataBase(AoDataBase);
end;

function TEstruturaRelGenerico.setUsuario(AcUsuario: String): IEstruturaRelGenerico;
begin
  Result := Self;

  FoEstrutura.setUsuario(AcUsuario);
end;


destructor TEstruturaRelGenerico.Destroy;
begin
  inherited;
end;


end.
