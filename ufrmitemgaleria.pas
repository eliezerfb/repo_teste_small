unit ufrmitemgaleria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmItemGaleria = class(TFrame)
    Panel2: TPanel;
    lbItem: TLabel;
    imgItem: TImage;
  private
    FCodigo: String;
    FDescricao: String;
    procedure SetCodigo(const Value: String);
    procedure SetDescricao(const Value: String);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;  override;
    property Codigo: String read FCodigo write SetCodigo;
    property Descricao: String read FDescricao write SetDescricao;
  end;

implementation

{$R *.dfm}

{ TfrmItemGaleria }

constructor TfrmItemGaleria.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

destructor TfrmItemGaleria.Destroy;
begin

  //FreeAndNil(Self);// := nil;
  inherited;

end;

procedure TfrmItemGaleria.SetCodigo(const Value: String);
begin
  FCodigo := Value;
  lbItem.Caption := FCodigo + ' - ' + FDescricao;
  lbItem.Layout := tlCenter;
end;

procedure TfrmItemGaleria.SetDescricao(const Value: String);
begin
  FDescricao := Value;
  lbItem.Caption := FCodigo + ' - ' + FDescricao;
  lbItem.Layout := tlCenter;
end;

end.
