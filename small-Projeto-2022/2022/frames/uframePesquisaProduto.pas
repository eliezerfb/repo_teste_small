unit uframePesquisaProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uframePesquisaPadrao, Grids, DBGrids, ExtCtrls, DB, SmallFunc;

type
  TframePesquisaProduto = class(TframePesquisaPadrao)
  private
  public
    constructor Create(AOwner: TComponent); override;  
    procedure CarregarProdutos(AcPesquisar: String);
  end;

var
  framePesquisaProduto: TframePesquisaProduto;

implementation

{$R *.dfm}

{ TframePesquisaProduto }

procedure TframePesquisaProduto.CarregarProdutos(AcPesquisar: String);
begin
  if not Self.Visible then
    Exit;
    
  FqryRegistros.Close;
  FqryRegistros.SQL.Clear;
  FqryRegistros.SQL.Add('SELECT');
  FqryRegistros.SQL.Add(' ESTOQUE.CODIGO');
  FqryRegistros.SQL.Add(' , ESTOQUE.DESCRICAO AS DESCRICAO');
  FqryRegistros.SQL.Add('FROM ESTOQUE');
  FqryRegistros.SQL.Add('WHERE');
  FqryRegistros.SQL.Add('((COALESCE(ESTOQUE.ATIVO,0)=0) OR ((COALESCE(ESTOQUE.ATIVO,0)=1) AND (ESTOQUE.TIPO_ITEM='+QuotedStr('01')+')))');
  if (LimpaNumero(AcPesquisar) = AcPesquisar) and (Length(LimpaNumero(AcPesquisar)) <= 5) then
    FqryRegistros.SQL.Add('AND (ESTOQUE.CODIGO='+ QuotedStr(LimpaNumero(AcPesquisar))+')');
  if (LimpaNumero(AcPesquisar) = AcPesquisar) and (Length(LimpaNumero(AcPesquisar)) > 5) then
    FqryRegistros.SQL.Add('AND (ESTOQUE.REFERENCIA='+ QuotedStr(LimpaNumero(AcPesquisar))+')');
  if (LimpaNumero(AcPesquisar) <> AcPesquisar) then
    FqryRegistros.SQL.Add('AND (UPPER(ESTOQUE.DESCRICAO) LIKE ' + QuotedStr('%' + UpperCase(AcPesquisar) + '%') + ')');
  FqryRegistros.SQL.Add('ORDER BY ESTOQUE.DESCRICAO');
  FqryRegistros.Open;
  // Sandro Silva 2023-08-23 FetchAll causa lentidão. Usar em situações que realmente for necessário. Usar algum parâmetro para definir se deve aplicar
  // FqryRegistros.FetchAll;

  dbgItensPesq.Columns[Pred(dbgItensPesq.Columns.Count)].Width := dbgItensPesq.Width - 22;  
end;

constructor TframePesquisaProduto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
