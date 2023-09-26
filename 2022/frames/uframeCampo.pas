unit uframeCampo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, IBDatabase, DB,
  IBCustomDataSet, IBQuery;

type
  TfFrameCampo = class(TFrame)
    txtCampo: TEdit;
    gdRegistros: TDBGrid;
    DataSource: TDataSource;
    Query: TIBQuery;
    procedure txtCampoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gdRegistrosDblClick(Sender: TObject);
    procedure gdRegistrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtCampoChange(Sender: TObject);
    procedure txtCampoClick(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure txtCampoEnter(Sender: TObject);
  private
    procedure Pesquisar;
  public
    sCampoDescricao,
    sTabela,
    sFiltro: String;
    sSQL: String;
    CampoCodigo : TField;

    procedure CarregaDescricao;
  end;

implementation

{$R *.dfm}

procedure TfFrameCampo.Pesquisar;
begin
  Self.BringToFront;
  gdRegistros.Visible := True;
  Self.Height := txtCampo.Height + gdRegistros.Height+5;
  Query.Locate('NOME', Trim(txtCampo.Text), [loCaseInsensitive, loPartialKey]);
end;

procedure TfFrameCampo.txtCampoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;

    PostMessage(GetParentForm(Self).Handle, wm_NextDlgCtl, Ord((ssShift in Shift)), 0);
    Key := 0;
  end;

  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    PostMessage(GetParentForm(Self).Handle, wm_NextDlgCtl, Ord((ssShift in Shift)), 0);
    Key := 0;
  end;

  if Key = VK_ESCAPE then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
  end;
end;

procedure TfFrameCampo.gdRegistrosDblClick(Sender: TObject);
begin
  txtCampo.Text     := Query.Fields[1].AsString;
  CampoCodigo.Value := Query.Fields[0].Value; // Sandro Silva 2023-09-26   CampoCodigo.AsInteger   := Query.Fields[0].AsInteger;

  gdRegistros.Visible := False;
  txtcampo.SetFocus;
  Self.Height := txtCampo.Height;

  Self.SendToBack;
end;

procedure TfFrameCampo.gdRegistrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    gdRegistrosDblClick(gdRegistros);

  if Key = VK_ESCAPE then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
    txtCampo.SetFocus;
  end;
end;

procedure TfFrameCampo.CarregaDescricao;
var
  teste: TNotifyEvent;
  sCampoCodigo : string;
begin
  sCampoCodigo := CampoCodigo.FieldName;

  Query.Close;
  if sSQL <> '' then
    Query.SQL.Text := sSQL
  else
    Query.SQL.Text := ' Select '+sCampoCodigo+','+sCampoDescricao+' as NOME'+
                      ' From '+sTabela+
                      ' Where 1=1 '+
                      sFiltro+
                      ' Order by upper('+sCampoDescricao+')';
  Query.Open;

  if Query.Locate(sCampoCodigo, Trim(CampoCodigo.AsString), [loCaseInsensitive, loPartialKey]) then
  begin
    teste := txtCampo.OnChange;
    txtCampo.OnChange := nil;
    txtCampo.Text := Query.FieldByName('NOME').AsString;
    txtCampo.OnChange := teste;
  end else
  begin
    txtCampo.Text := '';
  end;
end;

procedure TfFrameCampo.txtCampoChange(Sender: TObject);
begin
  if (txtCampo.Text <> '') and (txtCampo.Focused) then
  begin
    Pesquisar;
  end;
end;

procedure TfFrameCampo.txtCampoClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TfFrameCampo.FrameExit(Sender: TObject);
begin
  if Query.Locate('NOME', Trim(txtCampo.Text), [loCaseInsensitive, loPartialKey]) then
  begin
    txtCampo.Text           := Query.Fields[1].AsString;

    if CampoCodigo.AsInteger <> Query.Fields[0].AsInteger then
      CampoCodigo.AsInteger := Query.Fields[0].AsInteger;
  end else
  begin
    txtCampo.Clear;
    CampoCodigo.Value := null;
  end;

  gdRegistros.Visible := False;
  Self.Height := txtCampo.Height;
  Self.SendToBack;
end;

procedure TfFrameCampo.txtCampoEnter(Sender: TObject);
begin
  if not (CampoCodigo.DataSet.State in ([dsEdit, dsInsert])) then
    CampoCodigo.DataSet.edit;
end;

end.



