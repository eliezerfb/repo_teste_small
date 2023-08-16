unit uframePesquisaPadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, DBGrids, ExtCtrls, DB, IBQuery, IBDatabase;

type
  TframePesquisaPadrao = class(TFrame)
    pnlPrincipal: TPanel;
    dbgItensPesq: TDBGrid;
    procedure dbgItensPesqKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure setDataBase(AoDataBase: TIBDataBase);
  protected
    FdsRegistros: TDataSource;
    FqryRegistros: TIBQuery;
  end;

implementation

{$R *.dfm}

{ TframePesquisaPadrao }

constructor TframePesquisaPadrao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FdsRegistros  := TDataSource.Create(nil);
  FqryRegistros := TIBQuery.Create(nil);

  Self.dbgItensPesq.DataSource := Self.FdsRegistros;
  Self.FdsRegistros.DataSet := Self.FqryRegistros;
end;

destructor TframePesquisaPadrao.Destroy;
begin
  FreeAndNil(FdsRegistros);
  FqryRegistros.Close;
  FreeAndNil(FqryRegistros);

  inherited;
end;

procedure TframePesquisaPadrao.setDataBase(AoDataBase: TIBDataBase);
begin
  Self.FqryRegistros.Close;
  Self.FqryRegistros.SQL.Clear;

  Self.FqryRegistros.Database := AoDataBase;
end;

procedure TframePesquisaPadrao.dbgItensPesqKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then
    Key := 0;
end;

end.
