unit uConfiguracaoTEFCommerce;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrmPadrao, uframeConfiguraTEF, Vcl.StdCtrls, Vcl.DBGrids, Vcl.Grids,
  Data.DB, IBX.IBDataBase;

type
  TfrmConfiguracaoTEFCommerce = class(TFrmPadrao)
    frameConfiguracao: TframeConfiguraTEF;
    procedure frameConfiguraTEF1btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frameConfiguracaobtnOKClick(Sender: TObject);
    procedure frameConfiguracaodbgTEFsCellClick(Column: TColumn);
    procedure frameConfiguracaodbgTEFsColEnter(Sender: TObject);
    procedure frameConfiguracaodbgTEFsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure frameConfiguracaodbgTEFsEnter(Sender: TObject);
    procedure frameConfiguracaodbgTEFsExit(Sender: TObject);
    procedure frameConfiguracaodbgTEFsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure frameConfiguracaodbgTEFsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure frameConfiguracaocdsTEFsAfterPost(DataSet: TDataSet);
    procedure frameConfiguracaocdsTEFsAfterInsert(DataSet: TDataSet);
    procedure frameConfiguracaocdsTEFsPostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
    procedure frameConfiguracaocdsTEFsNOMEChange(Sender: TField);
    procedure frameConfiguracaocdsTEFsNOMESetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsPASTASetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsDIRETORIOREQSetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsDIRETORIORESPSetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsCAMINHOEXESetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsATIVOSetText(Sender: TField; const Text: string);
    procedure frameConfiguracaocdsTEFsIDNOMESetText(Sender: TField; const Text: string);
  private
    FoIBDataBase: TIBDataBase;
    procedure setIBDataBase(const Value: TIBDataBase);
  public
    property IBDataBase: TIBDataBase read FoIBDataBase write setIBDataBase;
    procedure AtualizaTEMTEF;
  end;

var
  frmConfiguracaoTEFCommerce: TfrmConfiguracaoTEFCommerce;

implementation

{$R *.dfm}

procedure TfrmConfiguracaoTEFCommerce.FormCreate(Sender: TObject);
begin
  inherited;

  frameConfiguracao.CriarObjetos;
end;

procedure TfrmConfiguracaoTEFCommerce.FormDestroy(Sender: TObject);
begin
  frameConfiguracao.LimparObjetos;
  inherited;
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaobtnOKClick(
  Sender: TObject);
begin
  frameConfiguracao.btnOKClick(Sender);

  if frameConfiguracao.Salvou then
    Close;
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsAfterInsert(
  DataSet: TDataSet);
begin
  inherited;
  frameConfiguracao.cdsTEFsAfterInsert(DataSet);
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsAfterPost(
  DataSet: TDataSet);
begin
  inherited;
  frameConfiguracao.cdsTEFsAfterPost(DataSet);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsATIVOSetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsATIVOSetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsCAMINHOEXESetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsCAMINHOEXESetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsDIRETORIOREQSetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsDIRETORIOREQSetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsDIRETORIORESPSetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsDIRETORIORESPSetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsIDNOMESetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsIDNOMESetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsNOMEChange(
  Sender: TField);
begin
  inherited;
  frameConfiguracao.cdsTEFsNOMEChange(Sender);
end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsNOMESetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsNOMESetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsPASTASetText(
  Sender: TField; const Text: string);
begin
  inherited;
  frameConfiguracao.cdsTEFsPASTASetText(Sender, Text);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaocdsTEFsPostError(
  DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
begin
  inherited;
  frameConfiguracao.cdsTEFsPostError(DataSet, E, Action);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsCellClick(
  Column: TColumn);
begin
  inherited;
  frameConfiguracao.dbgTEFsCellClick(Column);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsColEnter(
  Sender: TObject);
begin
  inherited;
  frameConfiguracao.dbgTEFsColEnter(Sender);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  frameConfiguracao.dbgTEFsDrawColumnCell(Sender, Rect, DataCol, Column,
  State);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsEnter(
  Sender: TObject);
begin
  inherited;
  frameConfiguracao.dbgTEFsEnter(Sender);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsExit(
  Sender: TObject);
begin
  inherited;
  frameConfiguracao.dbgTEFsExit(Sender);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  frameConfiguracao.dbgTEFsKeyDown(Sender, Key, Shift);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguracaodbgTEFsKeyUp(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  frameConfiguracao.dbgTEFsKeyUp(Sender, Key, Shift);

end;

procedure TfrmConfiguracaoTEFCommerce.frameConfiguraTEF1btnCancelarClick(
  Sender: TObject);
begin
  inherited;
  Self.Close;
end;

procedure TfrmConfiguracaoTEFCommerce.setIBDataBase(const Value: TIBDataBase);
begin
  FoIBDataBase := Value;
  frameConfiguracao.IBDataBase := FoIBDataBase;
end;

procedure TfrmConfiguracaoTEFCommerce.AtualizaTEMTEF;
begin
  // Os dados do INI são carregados no CREATE
  frameConfiguracao.DefineTemTEFINI;
end;

end.
