unit uFrmAnexosOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, Buttons, Grids, DBGrids, DB,
  IBCustomDataSet, ExtCtrls;

type
  TFrmAnexosOS = class(TFrmPadrao)
    dbgPrincipal: TDBGrid;
    Button22: TBitBtn;
    Button13: TBitBtn;
    BitBtn1: TBitBtn;
    DSAnexosOS: TDataSource;
    ibdAnexosOS: TIBDataSet;
    ibdAnexosOSIDANEXO: TIntegerField;
    ibdAnexosOSIDOS: TIntegerField;
    ibdAnexosOSNOME: TIBStringField;
    ibdAnexosOSANEXO: TMemoField;
    Image5: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAnexosOS: TFrmAnexosOS;

implementation

uses Unit7;

{$R *.dfm}

end.
