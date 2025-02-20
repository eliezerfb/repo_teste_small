unit uTestaProdutoExiste;

interface

uses
  uITestaProdutoExiste, IBDatabase, IBQuery, SysUtils;

type
  TTestaProdutoExiste = class(TInterfacedObject, ITestaProdutoExiste)
  private
    FibqProds: TIBQuery;
    FcTexto: String;
    constructor Create;
    procedure Consultar;
  public
    destructor Destroy; override;
    class function New: ITestaProdutoExiste;
    function setDataBase(AoDataBase: TIBDataBase): ITestaProdutoExiste;
    function setTextoPesquisar(AcTexto: String): ITestaProdutoExiste;
    function getQuery: TIBQuery;
    function Testar: Boolean;
  end;

implementation

uses TypInfo, DB, smallfunc_xe;

{ TTestaProdutoExiste }

constructor TTestaProdutoExiste.Create;
begin
  FibqProds := TIBQuery.Create(nil);
end;

destructor TTestaProdutoExiste.Destroy;
begin
  FreeAndNil(FibqProds);
  inherited;
end;

class function TTestaProdutoExiste.New: ITestaProdutoExiste;
begin
  Result := Self.Create;
end;

function TTestaProdutoExiste.setDataBase(AoDataBase: TIBDataBase): ITestaProdutoExiste;
begin
  Result := Self;

  FibqProds.Database := AoDataBase;
end;

function TTestaProdutoExiste.setTextoPesquisar(AcTexto: String): ITestaProdutoExiste;
begin
  Result := Self;

  FcTexto := AcTexto;
end;

function TTestaProdutoExiste.Testar: Boolean;
begin
  Consultar;
  
  Result := (not FibqProds.IsEmpty);
end;

procedure TTestaProdutoExiste.Consultar;
begin
  FibqProds.Close;
  FibqProds.SQL.Clear;
  FibqProds.SQL.Add('SELECT');
  FibqProds.SQL.Add(' CODIGO');
  FibqProds.SQL.Add(' , DESCRICAO');
  FibqProds.SQL.Add('FROM ESTOQUE');
  FibqProds.SQL.Add('WHERE');
  FibqProds.SQL.Add('((COALESCE(ATIVO,0)=0) OR ((COALESCE(ATIVO,0)=1) AND (COALESCE(TIPO_ITEM,'+QuotedStr(EmptyStr)+')='+QuotedStr('01')+')))');
  if (LimpaNumero(FcTexto) = FcTexto) and (Length(LimpaNumero(FcTexto)) <= 5) then
    FibqProds.SQL.Add('AND (ESTOQUE.CODIGO='+ QuotedStr(StrZero(StrToIntDef((LimpaNumero(FcTexto)),0),5,0))+')');
  if (LimpaNumero(FcTexto) = FcTexto) and (Length(LimpaNumero(FcTexto)) > 5) then
    FibqProds.SQL.Add('AND (ESTOQUE.REFERENCIA='+ QuotedStr(LimpaNumero(FcTexto))+')');
  if (LimpaNumero(FcTexto) <> FcTexto) then
    FibqProds.SQL.Add('AND (UPPER(ESTOQUE.DESCRICAO)=' + QuotedStr(UpperCase(FcTexto)) + ')');

  FibqProds.Open;
  // Sandro Silva 2023-08-23 FetchAll causa lentidão. Usar em situações que realmente for necessário. Usar algum parâmetro para definir se deve aplicar
  // FibqProds.FetchAll;
end;

function TTestaProdutoExiste.getQuery: TIBQuery;
begin
  Result := FibqProds;
end;

end.
