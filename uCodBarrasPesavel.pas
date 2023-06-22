unit uCodBarrasPesavel;

interface

uses
  uICodBarrasPesavel, SmallFunc, IBQuery, IBDatabase, uArquivosDAT;

type
  TCodBarrasPesavel = class(TInterfacedObject, ICodBarrasPesavel)
  private
    FqryDados: TIBQuery;
    FcPrimeiroDigito: String;
    FcCodProd: string;
    FcCodBarras: String;
    FoArquivoDAT: TArquivosDAT;

    FnValor: Real;
    FnQtde: Real;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: ICodBarrasPesavel;

    function setDatabase(AoDatabase: TIBDatabase): ICodBarrasPesavel;
    function setCodigoBarras(AcCodBarras: String): ICodBarrasPesavel;
    function CarregarDados: ICodBarrasPesavel;
    function CalcularValores: ICodBarrasPesavel;
    function RetornarQtde: Real;
    function RetornarPreco: Real;
  end;

implementation

uses SysUtils, Math, uSmallConsts;

{ TCodBarrasPesavel }

function TCodBarrasPesavel.CalcularValores: ICodBarrasPesavel;
begin
  Result := Self;

  FnQtde := 0;
  FnValor := 0;

  if (FqryDados.IsEmpty) then
    Exit;

  if (FqryDados.FieldByName('MEDIDA').AsString <> _cMedidaKU)
    and (FqryDados.FieldByName('MEDIDA').AsString <> _cMedidaKG) then
    Exit;

  if FcCodProd <> AllTrim(FqryDados.FieldByName('REFERENCIA').AsString) then
    Exit;

  try
    if FoArquivoDAT.Frente.FrentedeCaixa.TipoEtiqueta = _cMedidaKG then
    begin
      if (UpperCase(AllTrim(FqryDados.FieldByName('MEDIDA').AsString)) = _cMedidaKU) then
        FnQtde := StrToFloatDef(Copy(FcCodBarras,8,5), 0);
      if (UpperCase(AllTrim(FqryDados.FieldByName('MEDIDA').AsString)) = _cMedidaKG) then
        FnQtde := StrToFloatDef(Copy(FcCodBarras,8,5), 0) / 1000;
    end else
    begin
      FnValor := StrToFloatDef(Copy(FcCodBarras,8,5), 0) / 100;

      if FnValor <> 0 then
      begin
        if (UpperCase(AllTrim(FqryDados.FieldByName('MEDIDA').AsString)) = _cMedidaKU) or (UpperCase(AllTrim(FqryDados.FieldByName('MEDIDA').AsString)) = _cMedidaKG) then
          FnQtde := StrToFloatDef(FormatFloat('0.0000', FnValor / FqryDados.FieldByName('PRECO').AsFloat), (FnValor / FqryDados.FieldByName('PRECO').AsFloat));
      end;

      FnValor := 0;
    end;
  except
    FnValor := 0;
    FnQtde := 0;
  end;
end;

function TCodBarrasPesavel.CarregarDados: ICodBarrasPesavel;
begin
  Result := Self;

  if FcPrimeiroDigito <> '2' then
    Exit;
  if Length(FcCodBarras) <> 13 then
    Exit;
  if FcCodProd = EmptyStr then
    Exit;

  FqryDados.Close;
  FqryDados.SQL.Clear;
  FqryDados.SQL.Add('SELECT');
  FqryDados.SQL.Add(' MEDIDA');
  FqryDados.SQL.Add(' , PRECO');
  FqryDados.SQL.Add(' , REFERENCIA');
  FqryDados.SQL.Add('FROM ESTOQUE');
  FqryDados.SQL.Add('WHERE (REFERENCIA=:XREFERENCIA)');
  FqryDados.SQL.Add('AND (COALESCE(ATIVO,0)=0)');
  FqryDados.ParamByName('XREFERENCIA').AsString := FcCodProd;
  FqryDados.FetchAll;
  FqryDados.Open;
end;

constructor TCodBarrasPesavel.Create;
begin
  FqryDados := TIBQuery.Create(nil);
  FoArquivoDAT := TArquivosDAT.Create(EmptyStr);
end;

destructor TCodBarrasPesavel.Destroy;
begin
  FreeAndNil(FqryDados);
  FreeAndNil(FoArquivoDAT);
  inherited;
end;

class function TCodBarrasPesavel.New: ICodBarrasPesavel;
begin
  Result := Self.Create;
end;

function TCodBarrasPesavel.RetornarPreco: Real;
begin
  Result := FnValor;
end;

function TCodBarrasPesavel.RetornarQtde: Real;
begin
  Result := FnQtde;
end;

function TCodBarrasPesavel.setCodigoBarras(AcCodBarras: String): ICodBarrasPesavel;
begin
  Result := Self;

  FcCodBarras := Alltrim(AcCodBarras);
  FcPrimeiroDigito := Copy(FcCodBarras,1,1);
  FcCodProd := Copy(FcCodBarras, 1, 7);  
end;

function TCodBarrasPesavel.setDatabase(AoDatabase: TIBDatabase): ICodBarrasPesavel;
begin
  Result := Self;

  FqryDados.Database := AoDatabase;
end;

end.
