unit uRetornaOperacoesRelatorio;

interface

uses
  uIRetornaOperacoesRelatorio, IBDatabase, IBQuery, Classes, uSmallEnumerados,
  CheckLst, SmallFunc;

type
  TRetornaOperacoesRelatorio = class(TInterfacedObject, IRetornaOperacoesRelatorio)
  private
    FQryDados: TIBQuery;
    FenOperacao: tOperacaoDocumento;
    constructor Create;
  public
    destructor Destroy; override;
    class function New: IRetornaOperacoesRelatorio;
    function setDataBase(AoDataBase: TIBDatabase): IRetornaOperacoesRelatorio;
    function setOperacaoVenda: IRetornaOperacoesRelatorio;
    function setOperacaoCompra: IRetornaOperacoesRelatorio;
    function CarregaDados: IRetornaOperacoesRelatorio;
    function DefineItens(AoCheckList: TCheckListBox): IRetornaOperacoesRelatorio;
  end;

implementation

uses TypInfo, SysUtils;

{ TRetornaOperacoesRelatorio }

function TRetornaOperacoesRelatorio.CarregaDados: IRetornaOperacoesRelatorio;
begin
  Result := Self;

  FQryDados.Close;
  FQryDados.SQL.Clear;
  FQryDados.SQL.Add('SELECT');
  FQryDados.SQL.Add('   CFOP');
  FQryDados.SQL.Add('   , NOME');
  FQryDados.SQL.Add('   , INTEGRACAO');
  FQryDados.SQL.Add('FROM ICM');
  FQryDados.SQL.Add('ORDER BY CFOP');
  FQryDados.Open;
end;

constructor TRetornaOperacoesRelatorio.Create;
begin
  FQryDados := TIBQuery.Create(nil);
end;

function TRetornaOperacoesRelatorio.DefineItens(AoCheckList: TCheckListBox): IRetornaOperacoesRelatorio;
var
  cIntegracao: String;
  cCFOP: String;
  bCFOPValido: Boolean;
begin
  Result := Self;

  AoCheckList.Items.Clear;  
  if FQryDados.IsEmpty then
    Exit;

  while not FQryDados.Eof do
  begin
    cCFOP := FQryDados.FieldByName('CFOP').AsString;

    bCFOPValido := (Copy(cCFOP,1,1) = '5') or (Copy(cCFOP,1,1) = '6') or (Copy(cCFOP,1,1) = '7');
    cIntegracao := 'RECEBER';
    if FenOperacao = todCompra then
    begin
      bCFOPValido := (Copy(cCFOP,1,1) = '1') or (Copy(cCFOP,1,1) = '2') or (Copy(cCFOP,1,1) = '3');
      cIntegracao := 'PAGAR';
    end;
    if bCFOPValido then
    begin
      if AllTrim(FQryDados.FieldByName('NOME').AsString) <> EmptyStr then
      begin
        AoCheckList.Items.add(FQryDados.FieldByName('NOME').AsString);
        if (Copy(AnsiUpperCase(FQryDados.FieldByName('INTEGRACAO').AsString),1,5) = 'CAIXA') or (Copy(AnsiUpperCase(FQryDados.FieldByName('INTEGRACAO').AsString),1,7) = cIntegracao) then
          AoCheckList.Checked[(AoCheckList.Items.Count -1)] := True
        else
          AoCheckList.Checked[(AoCheckList.Items.Count -1)] := False;
      end;
    end;

    FQryDados.Next;
  end;
end;

destructor TRetornaOperacoesRelatorio.Destroy;
begin
  FreeAndNil(FQryDados);
  inherited;
end;

class function TRetornaOperacoesRelatorio.New: IRetornaOperacoesRelatorio;
begin
  Result := Self.Create;
end;

function TRetornaOperacoesRelatorio.setDataBase(AoDataBase: TIBDatabase): IRetornaOperacoesRelatorio;
begin
  Result := Self;

  FQryDados.Database := AoDataBase;
end;

function TRetornaOperacoesRelatorio.setOperacaoCompra: IRetornaOperacoesRelatorio;
begin
  Result := Self;

  FenOperacao := todCompra;
end;

function TRetornaOperacoesRelatorio.setOperacaoVenda: IRetornaOperacoesRelatorio;
begin
  Result := Self;

  FenOperacao := todVenda;
end;

end.
