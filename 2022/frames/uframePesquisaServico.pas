unit uframePesquisaServico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uframePesquisaPadrao, Grids, DBGrids, ExtCtrls, DB, SmallFunc;

type
  TframePesquisaServico = class(TframePesquisaPadrao)
  private
  public
    constructor Create(AOwner: TComponent); override;  
    procedure CarregarServico(AcPesquisar: String);
  end;

var
  framePesquisaServico: TframePesquisaServico;

implementation

{$R *.dfm}

{ TframePesquisaPadrao1 }

procedure TframePesquisaServico.CarregarServico(AcPesquisar: String);
begin
  if not Self.Visible then
    Exit;
  FqryRegistros.DisableControls;
  try
    FqryRegistros.Close;
    FqryRegistros.SQL.Clear;
    FqryRegistros.SQL.Add('SELECT');
    FqryRegistros.SQL.Add('ESTOQUE.DESCRICAO AS DESCRICAO');
    FqryRegistros.SQL.Add('FROM ESTOQUE');
    FqryRegistros.SQL.Add('WHERE');
    FqryRegistros.SQL.Add('(((COALESCE(ESTOQUE.ATIVO,0)=0) OR (COALESCE(ESTOQUE.ATIVO,0)=1)) AND (ESTOQUE.TIPO_ITEM='+QuotedStr('09')+'))');
    if (LimpaNumero(AcPesquisar) = AcPesquisar) and (Length(LimpaNumero(AcPesquisar)) <= 5) then
      FqryRegistros.SQL.Add('AND (ESTOQUE.CODIGO='+ QuotedStr(LimpaNumero(AcPesquisar))+')');
    if (LimpaNumero(AcPesquisar) = AcPesquisar) and (Length(LimpaNumero(AcPesquisar)) > 5) then
      FqryRegistros.SQL.Add('AND (ESTOQUE.REFERENCIA='+ QuotedStr(LimpaNumero(AcPesquisar))+')');
    if (LimpaNumero(AcPesquisar) <> AcPesquisar) then
    begin
      FqryRegistros.SQL.Add('AND ((UPPER(ESTOQUE.DESCRICAO) LIKE ' + QuotedStr('%') + '||UPPER(_iso8859_1 ' + QuotedStr(AcPesquisar) + ')||' + QuotedStr('%') + ')');
      FqryRegistros.SQL.Add('OR (LOWER(ESTOQUE.DESCRICAO) LIKE ' + QuotedStr('%') + '||LOWER(_iso8859_1 ' + QuotedStr(AcPesquisar) + ')||' + QuotedStr('%') + '))');
    end;

    FqryRegistros.SQL.Add('ORDER BY ESTOQUE.DESCRICAO');
    FqryRegistros.Open;
  finally
    FqryRegistros.EnableControls;
  end;
end;

constructor TframePesquisaServico.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
