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
  private
    procedure Pesquisar;
  public
    sCampoCodigo,
    sCampoDescricao,
    sTabela,
    sFiltro: String;
    sSQL: String;
    function GetCodigo: TField;
    function DescricaoPorCodigo(iCodigo: Integer): String;
    function CodigoString: String;
    procedure Limpar;
  end;

implementation

{$R *.dfm}

function TfFrameCampo.GetCodigo: TField;
begin
  Result := Query.Fields[0]
end;

procedure TfFrameCampo.Pesquisar;
begin
  Query.SQL.Text := ' Select '+sCampoCodigo+','+sCampoDescricao+
                    ' From '+sTabela+
                    ' Where (UPPER('+sCampoDescricao+') like '+QuotedStr('%'+UpperCase(txtCampo.Text)+'%')+
                    '   or '+sCampoCodigo+' = '+IntToStr(StrToIntDef(txtCampo.Text,0))+')';

  if sFiltro <> '' then
    Query.SQL.Add(' and '+sFiltro);
  Query.SQL.Add(' Order by '+sCampoDescricao);
  Query.Open;
end;

procedure TfFrameCampo.txtCampoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Self.BringToFront;
    Pesquisar;

    gdRegistros.Visible := True;
    Self.Height := txtCampo.Height + gdRegistros.Height+5;
    gdRegistros.SetFocus;
  end;

  if Key = VK_ESCAPE then
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
  end;
end;

procedure TfFrameCampo.gdRegistrosDblClick(Sender: TObject);
begin
  txtCampo.Text       := Query.Fields[1].AsString;
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

function TfFrameCampo.DescricaoPorCodigo(iCodigo: Integer): String;
var
  teste: TNotifyEvent;
begin
  Query.SQL.Text := ' Select '+sCampoCodigo+','+sCampoDescricao+
                    ' From '+sTabela+
                    ' Where '+sCampoCodigo+' = '+IntToStr(iCodigo);
  Query.Open;
  Result := Query.FieldByName(sCampoDescricao).AsString;

  teste := txtCampo.OnChange;
  txtCampo.OnChange := nil;
  txtCampo.Text := Query.FieldByName(sCampoDescricao).AsString;
  txtCampo.OnChange := teste;
end;

procedure TfFrameCampo.txtCampoChange(Sender: TObject);
begin
  if txtCampo.Text <> '' then
  begin
    Self.BringToFront;
    Pesquisar;

    gdRegistros.Visible := True;
    Self.Height := txtCampo.Height + gdRegistros.Height+5;
  end else
  begin
    gdRegistros.Visible := False;
    Self.Height := txtCampo.Height;
    Query.Close;
  end;
end;

function TfFrameCampo.CodigoString: String;
begin
  try
    Result := GetCodigo.AsString;
  except
    Result := '';
  end;
end;

procedure TfFrameCampo.Limpar;
begin
  txtCampo.Clear;
end;

end.



