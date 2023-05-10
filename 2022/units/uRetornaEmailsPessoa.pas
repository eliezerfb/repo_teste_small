unit uRetornaEmailsPessoa;

interface

uses
  uIRetornaEmailsPessoa, IBDatabase, IBQuery;

type
  TRetornarEmailsPessoa = class(TInterfacedObject, IRetornarEmailsPessoa)
  private
    FoDataBase: TIBDatabase;
    FoDataSet: TIBQuery;
    FcCodigoCad: String;
    FcTabela: String;
    constructor Create;
    destructor Destroy; override;
  public
    class function New: IRetornarEmailsPessoa;
    function setDataBase(AoDataBase: TIBDataBase): IRetornarEmailsPessoa;
    function setTabela(AcTabela: String): IRetornarEmailsPessoa;
    function setCodigoCadastro(AcCodigoCad: String): IRetornarEmailsPessoa;
    function Retornar: String;
  end;

implementation

uses SysUtils, DB;

{ TRetornarEmailsPessoa }

constructor TRetornarEmailsPessoa.Create;
begin
  FoDataSet := TIBQuery.Create(nil);
end;

destructor TRetornarEmailsPessoa.Destroy;
begin
  FreeAndNil(FoDataSet);
  inherited;
end;

class function TRetornarEmailsPessoa.New: IRetornarEmailsPessoa;
begin
  Result := Self.Create;
end;

function TRetornarEmailsPessoa.Retornar: String;
begin
  Result := EmptyStr;

  FoDataSet.Close;
  FoDataSet.SQL.Clear;
  FoDataSet.SQL.Add('SELECT');
  FoDataSet.SQL.Add('EMAIL');
  FoDataSet.SQL.Add('FROM ' + FcTabela);
  FoDataSet.SQL.Add('WHERE NOME=:XCOD');
  FoDataSet.ParamByName('XCOD').AsString := FcCodigoCad;
  FoDataSet.Open;
  FoDataSet.FetchAll;

  if (not FoDataSet.IsEmpty) then
    Result := FoDataSet.FieldByName('EMAIL').AsString;
end;

function TRetornarEmailsPessoa.setCodigoCadastro(AcCodigoCad: String): IRetornarEmailsPessoa;
begin
  Result := Self;
  
  FcCodigoCad := AcCodigoCad;
end;

function TRetornarEmailsPessoa.setDataBase(AoDataBase: TIBDataBase): IRetornarEmailsPessoa;
begin
  Result := Self;

  FoDataBase := AoDataBase;

  FoDataSet.Database := FoDataBase;
end;

function TRetornarEmailsPessoa.setTabela(
  AcTabela: String): IRetornarEmailsPessoa;
begin
  Result := Self;

  FcTabela := AcTabela;
end;

end.
