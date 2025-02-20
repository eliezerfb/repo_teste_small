unit uTestaClienteDevendo;

interface

uses
  uITestaClienteDevendo, IBDatabase, Graphics, IBQuery;

type
  TTestaClienteDevendo = class(TInterfacedObject, ITestaClienteDevendo)
  private
    FcCliente: String;
    FQryDados: TIBQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ITestaClienteDevendo;
    function setDataBase(AoDataBase: TIBDatabase): ITestaClienteDevendo;
    function setCliente(AcCliente: String): ITestaClienteDevendo;
    function CarregarDados: ITestaClienteDevendo;
    function TestarClienteDevendo: Boolean;
    function RetornarCor: TColor;    
  end;

implementation

uses TypInfo, SysUtils;

{ TTestaClienteDevendo }

function TTestaClienteDevendo.CarregarDados: ITestaClienteDevendo;
begin
  Result := Self;
  if FcCliente = EmptyStr then
    Exit;
    
  FQryDados.Close;
  FQryDados.SQL.Clear;
  FQryDados.SQL.Add('SELECT FIRST 1');
  FQryDados.SQL.Add('MOSTRAR');
  FQryDados.SQL.Add('FROM CLIFOR');
  FQryDados.SQL.Add('WHERE (NOME=:XNOME)');
  FQryDados.ParamByName('XNOME').AsString := FcCliente;
  FQryDados.Open;
  // Sandro Silva 2023-10-09 FetchAll causa lentidão. Usar em situações que realmente for necessário. Usar algum parâmetro para definir se deve aplicar
  //FQryDados.FetchAll; Nesta situação não há motivos para usar fetchall porque está selecionando o primeiro registro (First 1)
end;

constructor TTestaClienteDevendo.Create;
begin
  FQryDados := TIBQuery.Create(nil);
end;

destructor TTestaClienteDevendo.Destroy;
begin
  FreeAndNil(FQryDados);
  inherited;
end;

class function TTestaClienteDevendo.New: ITestaClienteDevendo;
begin
  Result := Self.Create;
end;

function TTestaClienteDevendo.RetornarCor: TColor;
begin
  Result := clBlack;
  if TestarClienteDevendo then
    Result := clRed;
end;

function TTestaClienteDevendo.setCliente(AcCliente: String): ITestaClienteDevendo;
begin
  Result := Self;
  
  FcCliente := AcCliente;
end;

function TTestaClienteDevendo.setDataBase(AoDataBase: TIBDatabase): ITestaClienteDevendo;
begin
  Result := Self;

  FQryDados.Database := AoDataBase;
end;

function TTestaClienteDevendo.TestarClienteDevendo: Boolean;
begin
  Result := False;
  if (not FQryDados.IsEmpty) then
    Result := FQryDados.FieldByName('MOSTRAR').AsString = '1';
end;

end.
