unit ufrmInformarDrawback;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient;

type
  TfrmInformarDrawback = class(TFrmPadrao)
    dsDrawback: TDataSource;
    dbgPrincipal: TDBGrid;
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    cdsDrawback: TClientDataSet;
    cdsDrawbackCODIGO: TStringField;
    cdsDrawbackDESCRICAO: TStringField;
    cdsDrawbackDRAWBACK: TStringField;
    cdsDrawbackREGISTRO: TStringField;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgPrincipalEnter(Sender: TObject);
    procedure dbgPrincipalKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsDrawbackBeforeInsert(DataSet: TDataSet);
    procedure dbgPrincipalDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
  private
    FDataSet: TDataSet;
    FnRecNo: Integer;
    FoColorGrid: TColor;
    procedure setDataSet(const Value: TDataSet);
  public
    property DataSet: TDataSet read FDataSet write setDataSet;
    property ColorGrid: TColor read FoColorGrid write FoColorGrid;
  end;

var
  frmInformarDrawback: TfrmInformarDrawback;

implementation

{$R *.dfm}

{ TfrmInformarDrawback }

procedure TfrmInformarDrawback.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInformarDrawback.btnOKClick(Sender: TObject);
begin
  cdsDrawback.DisableControls;
  try
    cdsDrawback.First;

    while not cdsDrawback.Eof do
    begin
      if DataSet.Locate('REGISTRO', cdsDrawbackREGISTRO.AsString, []) then
      begin
        DataSet.Edit;
        DataSet.FieldByName('DRAWBACK').AsString := cdsDrawbackDRAWBACK.AsString;
        DataSet.Post;
      end;
      cdsDrawback.Next;
    end;

    Self.Close;
  finally
    cdsDrawback.EnableControls;
  end;
end;

procedure TfrmInformarDrawback.cdsDrawbackBeforeInsert(DataSet: TDataSet);
begin
  if Self.Showing then
    Abort;
end;

procedure TfrmInformarDrawback.dbgPrincipalDrawDataCell(Sender: TObject; const Rect: TRect; Field: TField; State: TGridDrawState);
var
  OldBkMode : Integer;
  xRect : tREct;
begin
  dbgPrincipal.Canvas.Brush.Color := FoColorGrid;
  dbgPrincipal.Canvas.Pen.Color   := clRed;

  xRect.Left   := REct.Left;
  xRect.Top    := -1;
  xRect.Right  := Rect.Right;
  xRect.Bottom := Rect.Bottom - Rect.Top + 0;

  dbgPrincipal.Canvas.FillRect(xRect);

  OldBkMode := SetBkMode(Handle, TRANSPARENT);
  dbgPrincipal.Canvas.Font := dbgPrincipal.TitleFont;
  dbgPrincipal.Canvas.TextOut(Rect.Left + 2, 2, Trim(Field.DisplayLabel));
  dbgPrincipal.Canvas.Font.Color := clblack;
  SetBkMode(Handle, OldBkMode);
end;

procedure TfrmInformarDrawback.dbgPrincipalEnter(Sender: TObject);
begin
  dbgPrincipal.SelectedIndex := 1;
end;

procedure TfrmInformarDrawback.dbgPrincipalKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Shift = [ssCtrl]) or (Shift = [ssCtrl, ssShift])) and (Key = VK_DELETE) then
    Key := 0;
end;

procedure TfrmInformarDrawback.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FDataSet.RecNo := FnRecNo;
  FDataSet.EnableControls;
end;

procedure TfrmInformarDrawback.setDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
  FnRecNo := FDataSet.RecNo;

  FDataSet.DisableControls;
  cdsDrawbackCODIGO.ReadOnly := False;
  cdsDrawbackDESCRICAO.ReadOnly := False;
  try
    cdsDrawback.CreateDataSet;

    FDataSet.First;
    while not FDataSet.Eof do
    begin
      // Não adicionar itens de observação
      if FDataSet.FieldByName('CODIGO').AsString <> EmptyStr then
      begin
        cdsDrawback.Append;
        cdsDrawbackREGISTRO.AsString  := FDataSet.FieldByName('REGISTRO').AsString;
        cdsDrawbackCODIGO.AsString    := FDataSet.FieldByName('CODIGO').AsString;
        cdsDrawbackDESCRICAO.AsString := FDataSet.FieldByName('DESCRICAO').AsString;
        cdsDrawbackDRAWBACK.AsString  := FDataSet.FieldByName('DRAWBACK').AsString;
        cdsDrawback.Post;
      end;

      FDataSet.Next;
    end;

    cdsDrawback.IndexFieldNames := cdsDrawbackREGISTRO.FieldName;
  finally
    cdsDrawbackCODIGO.ReadOnly := True;
    cdsDrawbackDESCRICAO.ReadOnly := True;
  end;
end;

end.
