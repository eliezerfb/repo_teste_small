unit uItensInativosImpXMLEntrada;

interface

uses
  uIItensInativosImpXMLEntrada, DB, IBQuery, IBDatabase, Windows, Forms;

type
  TItensInativosImpXMLEnt = class(TInterfacedObject, IItensInativosImpXMLEntrada)
  private
    FibqItens: TIBQuery;
    constructor Create;
    procedure CarregarItensInativos(AcItens: String);
    procedure ReativarItens;
  public
    destructor Destroy; override;
    class function New: IItensInativosImpXMLEntrada;
    function setDataBase(AoDataBase: TIBDataBase): IItensInativosImpXMLEntrada;
    function Executar(AcItens: String): IItensInativosImpXMLEntrada;
  end;

implementation

uses SysUtils, Dialogs, Classes;

{ TItensInativosImpXMLEnt }

constructor TItensInativosImpXMLEnt.Create;
begin
  FibqItens := TIBQuery.Create(nil);
end;

destructor TItensInativosImpXMLEnt.Destroy;
begin
  FreeAndNil(FibqItens);
  inherited;
end;

procedure TItensInativosImpXMLEnt.CarregarItensInativos(AcItens: String);
begin
  AcItens := Copy(AcItens,1,Length(AcItens)-1);

  FibqItens.Close;
  FibqItens.SQL.Clear;
  FibqItens.SQL.Add('SELECT');
  FibqItens.SQL.Add('  CODIGO');
  FibqItens.SQL.Add('  , DESCRICAO');
  FibqItens.SQL.Add('FROM ESTOQUE');
  FibqItens.SQL.Add('WHERE (COALESCE(ATIVO,0)=1) AND (COALESCE(TIPO_ITEM,'+QuotedStr(EmptyStr)+')<>'+QuotedStr('01')+')');
  FibqItens.SQL.Add('AND (CODIGO IN (' + AcItens + '))');
  FibqItens.SQL.Add('ORDER BY CODIGO');
  FibqItens.Open;
  // Sandro Silva 2023-08-23 FetchAll causa lentidão. Usar em situações que realmente for necessário. Usar algum parâmetro para definir se deve aplicar
  // FibqItens.FetchAll;
end;

function TItensInativosImpXMLEnt.Executar(AcItens: String): IItensInativosImpXMLEntrada;
var
  cMsg: String;
begin
  if Trim(AcItens) = EmptyStr then
    Exit;

  CarregarItensInativos(AcItens);
  if FibqItens.IsEmpty then
    Exit;

  FibqItens.First;

  cMsg := 'Foram encontrados produtos inativos nesta nota fiscal:';
  while not FibqItens.Eof do
  begin
    cMsg := cMsg + sLineBreak + FibqItens.FieldByName('codigo').AsString + ' - ' + FibqItens.FieldByName('descricao').AsString;

    FibqItens.Next;
  end;
  cMsg := cMsg + sLineBreak + sLineBreak +
          'Para o correto lançamento da Nota de Compra, os itens serão reativados automaticamente.';

  Application.MessageBox(pChar(cMsg),'Atenção',mb_Ok + MB_ICONINFORMATION);
  ReativarItens;
end;

procedure TItensInativosImpXMLEnt.ReativarItens;
var
  ibqUpdate: TIBQuery;
begin
  FibqItens.First;

  ibqUpdate := TIBQuery.Create(nil);
  try
    try
      while not FibqItens.Eof do
      begin
        ibqUpdate.Database := FibqItens.DataBase;
        ibqUpdate.Close;
        ibqUpdate.SQL.Clear;
        ibqUpdate.SQL.Add('UPDATE ESTOQUE SET');
        ibqUpdate.SQL.Add('ATIVO=0');
        ibqUpdate.SQL.Add('WHERE (CODIGO=:XCOD)');
        ibqUpdate.ParamByName('XCOD').AsString := FibqItens.FieldByName('codigo').AsString;
        ibqUpdate.ExecSQL;

        FibqItens.Next;
      end;
    except
      on e: Exception do
      begin
        raise Exception.Create('Não foi possível alterar o ativo do item: ' + FibqItens.FieldByName('codigo').AsString + ' - ' + e.Message);
        Exit;
      end;
    end;
  finally
    FreeAndNil(ibqUpdate);
  end;
end;

class function TItensInativosImpXMLEnt.New: IItensInativosImpXMLEntrada;
begin
  Result := Self.Create;
end;

function TItensInativosImpXMLEnt.setDataBase(
  AoDataBase: TIBDataBase): IItensInativosImpXMLEntrada;
begin
  Result := Self;

  FibqItens.Database := AoDataBase;
end;

end.
