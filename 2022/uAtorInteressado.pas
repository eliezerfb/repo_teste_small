unit uAtorInteressado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrmPadrao, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.Buttons, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, IBX.IBDatabase,
  IBX.IBCustomDataSet, IBX.IBQuery, Clipbrd, System.Generics.Collections,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, System.ImageList,
  Vcl.ImgList;

type
  TIdentification = record
    Identification: String;
    Reference: String;
    class function Create(const AIdentification, AReference: String): TIdentification; static;
  end;

  TfmAtorInteressado = class(TFrmPadrao)
    PanelBotton: TPanel;
    PanelGrid: TPanel;
    DBGridActors: TDBGrid;
    PanelLeft: TPanel;
    LabelInfo: TLabel;
    BitBtnOk: TBitBtn;
    BitBtn1: TBitBtn;
    FDMemTableMain: TFDMemTable;
    FDMemTableMainCPFCNPJ: TStringField;
    FDMemTableMainIS_PROTECTED: TSmallintField;
    dsMain: TDataSource;
    FDMemTableMainDELETED: TIntegerField;
    Bevel1: TBevel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDMemTableMainUUID: TStringField;
    ImageList1: TImageList;
    FDMemTableMainIDATORINTERESSADO: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FDMemTableMainBeforeDelete(DataSet: TDataSet);
    procedure DBGridActorsDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure DBGridActorsKeyPress(Sender: TObject; var Key: Char);
    procedure FDMemTableMainBeforePost(DataSet: TDataSet);
    procedure DBGridActorsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridActorsCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure FDMemTableMainAfterInsert(DataSet: TDataSet);
    procedure FDMemTableMainBeforeEdit(DataSet: TDataSet);
  private
    { Private declarations }
    FConnection: TIBDataBase;
    FIdentificationsNotAllowed: TList<TIdentification>;
    FTransaction: TIBTransaction;
    FNumeroNF: String;
    FModelo: String;
    procedure AddActor(AID: Integer; AIdentification: String;
      AIsProtected: Boolean);
    function RemoveMask(AValue: String): String;
    procedure DeleteRecord();
    procedure LoadDataset();
    procedure PersistDataset();
    function CancelBlankRecord(): Boolean;
  public
    { Public declarations }
    class function Execute(AConnection: TIBDatabase;
      ATransaction: TIBTransaction; ANumeroNF, AModelo: String;
      AAccountingIdentification: String;
      AIdentificationsNotAllowed: TList<TIdentification>): Boolean;
  end;

var
  fmAtorInteressado: TfmAtorInteressado;

implementation

{$R *.dfm}

uses
  SmallFunc;

const
  MSG_INVALID_IDENTIFICATION = 'CNPJ/CPF inválido.';
  MSG_ALREADY_INFORMED = 'O %s d%s %s não precisa ser informado pois '+
    'já é ator interessado.';
  MSG_DUPLICATE_RECORD = '%s já informado.';
  LIMIT_OF_ACTORS = 10;
  MSG_LIMIT_OF_RECORDS = ' É permitido informar até %d atores interessados '+
    'por Nota Fiscal.';
  ACCOUNTING_REFERENCE = 'Contabilidade';



procedure TfmAtorInteressado.AddActor(AID: Integer; AIdentification: String;
  AIsProtected: Boolean);
begin
  AIdentification := RemoveMask(AIdentification);
  if trim(AIdentification) = '' then
    Exit();
  FDMemTableMain.Append;
  FDMemTableMainIDATORINTERESSADO.AsInteger := AID;
  FDMemTableMainCPFCNPJ.AsString := ConverteCpfCgc(AIdentification);
  FDMemTableMainIS_PROTECTED.AsInteger := Integer(AIsProtected);
  FDMemTableMain.Post;
end;

function TfmAtorInteressado.CancelBlankRecord(): Boolean;
begin
  Result := False;
  if RemoveMask(FDMemTableMainCPFCNPJ.AsString) = '' then
  begin
    FDMemTableMain.Cancel;
    Result := True;
  end;
end;

procedure TfmAtorInteressado.DBGridActorsCellClick(Column: TColumn);
begin
  inherited;
  if not(Column.Index = 1) then
  begin
    CancelBlankRecord();
    Exit;
  end;

  DeleteRecord();
end;

procedure TfmAtorInteressado.DBGridActorsDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);

function GetColor(): TColor;
begin
  Result := clWhite;
  if Boolean(FDMemTableMainIS_PROTECTED.AsInteger) then
    Result := clGradientInactiveCaption;
end;

begin
  inherited;
  DBGridActors.Canvas.Brush.Color := GetColor();
  DBGridActors.DefaultDrawDataCell(Rect, Column.Field, State);

  if (Column.Index = 1) and not(Boolean(FDMemTableMainIS_PROTECTED.AsInteger)) then
    ImageList1.Draw((Sender as TDBGrid).Canvas, Rect.Left + 4, Rect.Top + 1, 0);
end;

procedure TfmAtorInteressado.DBGridActorsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if key in ([VK_LEFT, VK_RIGHT]) then
    Key := 0;

  var Field := TDBGrid(Sender).SelectedField;

  if Assigned(Field) and (Field.FieldName = 'CPFCNPJ') then
  begin
    if (Key in ([VK_DELETE, VK_BACK])) and (TDBGrid(Sender).EditorMode) then
    begin
      Key := 0;
      if not(Boolean(FDMemTableMainIS_PROTECTED.AsInteger)) then
      begin
        var NewValue := RemoveMask(Field.AsString);
        Delete(NewValue, NewValue.Length, 1);
        Field.AsString := NewValue;
      end;
      Abort;
    end;

    if (Shift = [ssCtrl]) and (Key = Ord('C')) then
    begin
      Clipboard.AsText := Field.AsString;
      Key := 0;
      Exit;
    end;

    if (Shift = [ssCtrl]) and (Key = Ord('V')) and
      not(Boolean(FDMemTableMainIS_PROTECTED.AsInteger)) then
    begin
      var Identification := RemoveMask(Clipboard.AsText);
      try
        if not(CpfCgc(Identification)) then
          raise Exception.Create(MSG_INVALID_IDENTIFICATION);
      except
        raise Exception.Create(MSG_INVALID_IDENTIFICATION);
      end;
      Field.AsString := ConverteCpfCgc(RemoveMask(Clipboard.AsText));
      Key := 0;
      Exit;
    end;

    if Boolean(FDMemTableMainIS_PROTECTED.AsInteger) and
      not(Key in [VK_RETURN, VK_DOWN]) then
      Abort();
  end;

  if (Key = VK_DELETE) and (FDMemTableMain.State = dsBrowse) then
    DeleteRecord();

  if Key = VK_UP then
  begin
    if CancelBlankRecord() then
      Abort();
  end;

  if (Key in [VK_BACK, VK_F2]) and (FDMemTableMain.State = dsBrowse) and
    not(FDMemTableMain.IsEmpty) and
    not(Boolean(FDMemTableMainIS_PROTECTED.AsInteger)) then
    FDMemTableMain.Edit;
end;

procedure TfmAtorInteressado.DBGridActorsKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not(Key in ['0'..'9', #13]) then
    Abort;

  if (Key = #8) and Boolean(FDMemTableMainIS_PROTECTED.AsInteger) then
    Abort();

  if (Key = #13) then
  begin
    Key := #0;
    with TDBGrid(Sender) do
    begin
      if not (dgEditing in Options) then
        Options := Options + [dgEditing];

      SelectedIndex := 0;
      if not DataSource.DataSet.Eof then
        DataSource.DataSet.Next;

      if DataSource.DataSet.Eof then
        DataSource.DataSet.Append;
    end;
    Exit();
  end;

  if not(FDMemTableMain.State in ([dsEdit, dsInsert])) then
    Exit();


  var Field := TDBGrid(Sender).SelectedField;

  if Assigned(Field) and (Field.FieldName = 'CPFCNPJ') then
  begin
    var Input := RemoveMask(Field.AsString);

    if Key <> #8 then
      Input := Input + Key
    else if Length(Input) > 0 then
      Delete(Input, Length(Input), 1);

    var Formatted := '';
    if Length(Input) <= 11 then
    begin
      for var i := 1 to Length(Input) do
      begin
        Formatted := Formatted + Input[i];
        if i = 3 then
          Formatted := Formatted + '.';
        if i = 6 then
          Formatted := Formatted + '.';
        if i = 9 then
          Formatted := Formatted + '-';
      end;
    end
    else
    begin
      // CNPJ Formatting
      for var i := 1 to Length(Input) do
      begin
        Formatted := Formatted + Input[i];
        if i = 2 then
          Formatted := Formatted + '.';
        if i = 5 then
          Formatted := Formatted + '.';
        if i = 8 then
          Formatted := Formatted + '/';
        if i = 12 then
          Formatted := Formatted + '-';
      end;
    end;

    Field.AsString := Formatted;
    Key := #0;
  end;
end;

procedure TfmAtorInteressado.DeleteRecord();
begin
  if (FDMemTableMain.IsEmpty) or Boolean(FDMemTableMainIS_PROTECTED.AsInteger) then
    Exit;

  FDMemTableMain.Delete();
end;

class function TfmAtorInteressado.Execute(AConnection: TIBDatabase;
  ATransaction: TIBTransaction; ANumeroNF, AModelo: String;
  AAccountingIdentification: String;
  AIdentificationsNotAllowed: TList<TIdentification>): Boolean;
begin
  with TfmAtorInteressado.Create(nil) do
  begin
    try
      FConnection := AConnection;
      FTransaction := ATransaction;
      FNumeroNF := ANumeroNF;
      FModelo := AModelo;

      FIdentificationsNotAllowed := AIdentificationsNotAllowed;

      if not(AAccountingIdentification = '') then
      begin
        var AccountingIdentification: TIdentification;
        AccountingIdentification.Identification :=
          RemoveMask(AAccountingIdentification);
        AccountingIdentification.Reference := ACCOUNTING_REFERENCE;
      end;

      for var i := 0 to FIdentificationsNotAllowed.Count - 1 do
      begin
        var Temp := FIdentificationsNotAllowed[i];
        Temp.Identification := RemoveMask(Temp.Identification);
        FIdentificationsNotAllowed[i] := Temp;
      end;

      LoadDataset();

      if FDMemTableMain.IsEmpty then
        AddActor(0, AAccountingIdentification, True);

      if not(FDMemTableMain.IsEmpty) and
      (FDMemTableMain.RecordCount < LIMIT_OF_ACTORS) then
        FDMemTableMain.Append();

      if FDMemTableMain.RecordCount >= LIMIT_OF_ACTORS then
        FDMemTableMain.First;


      Result := ShowModal = mrOk;

      if Result then
        PersistDataset();

    finally
      Free;
    end;
  end;
end;

procedure TfmAtorInteressado.FDMemTableMainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  if FDMemTableMainUUID.AsString = '' then
    FDMemTableMainUUID.AsString := TGUID.NewGuid.ToString();
end;

procedure TfmAtorInteressado.FDMemTableMainBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  if Boolean(Dataset.FieldByName('IS_PROTECTED').AsInteger) then
    Abort;
end;

procedure TfmAtorInteressado.FDMemTableMainBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if Boolean(Dataset.FieldByName('IS_PROTECTED').AsInteger) then
    raise Exception.Create('Não é possível alterar este registro.');
end;

procedure TfmAtorInteressado.FDMemTableMainBeforePost(DataSet: TDataSet);

function GetTypeOfIdentification(AValue: String): String;
begin
  if AValue.Length = 11 then
    Exit('CPF');
  Exit('CNPJ');
end;

function GetPrefix(AValue: String): String;
begin
  if (AValue = ACCOUNTING_REFERENCE) or (AValue = 'Transportadora') then
      Exit('a');
  Exit('o');
end;

begin
  inherited;

  var CNPJCPF := RemoveMask(FDMemTableMainCPFCNPJ.AsString);

  if Trim(RemoveMask(CNPJCPF)).Length = 0 then
    Abort;

  if FDMemTableMain.RecordCount = LIMIT_OF_ACTORS then
  begin
    FDMemTableMain.Cancel;
    raise Exception.Create(Format(MSG_LIMIT_OF_RECORDS, [LIMIT_OF_ACTORS]));
  end;

  try
    if not(CpfCgc(CNPJCPF)) then
      raise Exception.Create(MSG_INVALID_IDENTIFICATION);
  except
    raise Exception.Create(MSG_INVALID_IDENTIFICATION);
  end;


  for var Identification in FIdentificationsNotAllowed do
  begin
    if not(Identification.Identification = CNPJCPF) then
      Continue;

    raise Exception.Create(
      Format(
        MSG_ALREADY_INFORMED,
        [
          GetTypeOfIdentification(Identification.Identification),
          GetPrefix(Identification.Reference),
          Identification.Reference
        ]
      )
    );
  end;

  var CurrentUIID := FDMemTableMainUUID.AsString;
  var IsDuplicate := False;
  var TempMemTable := TFDMemTable.Create(nil);
  try
    TempMemTable.CloneCursor(FDMemTableMain, True);
    TempMemTable.First;
    while not TempMemTable.Eof do
    begin
      if (FDMemTableMainCPFCNPJ.AsString = TempMemTable.FieldByName('CPFCNPJ').AsString) and
        not(FDMemTableMainUUID.AsString = TempMemTable.FieldByName('UUID').AsString) then
      begin
        FDMemTableMain.Cancel;
        raise Exception.Create(
          Format(MSG_DUPLICATE_RECORD, [GetTypeOfIdentification(CNPJCPF)])
        );
      end;
      TempMemTable.Next;
    end;
  finally
    TempMemTable.Free;
  end;


end;

procedure TfmAtorInteressado.FormCreate(Sender: TObject);
begin
  inherited;
  FDMemTableMain.CreateDataSet();

  DBGridActors.Columns[0].Width := 170;
  DBGridActors.Columns[1].Width := 25;
  ShowScrollBar(DBGridActors.Handle, SB_HORZ, FALSE);

  LabelInfo.Caption := 'Informe o CPF ou CNPJ da '+#13+
    'pessoa ou empresa autorizada '+#13+
    'a acessar o XML desta NF-e.';
  Font.Name := 'Microsoft Sans Serif';
end;

procedure TfmAtorInteressado.FormShow(Sender: TObject);
begin
  inherited;
  DBGridActors.SetFocus();
end;

procedure TfmAtorInteressado.LoadDataset;
begin
  FDMemTableMain.DisableControls;
  var Qry := TIBQuery.Create(Self);
  try
    Qry.Database := FConnection;
    Qry.Transaction := FTransaction;
    Qry.SQL.Text := 'select idatorinteressado, cpfcnpj, is_protected '+
      ' from atorinteressado '+
      ' where numeronf = :numeronf and modelo = :modelo'+
      ' order by idatorinteressado';
    Qry.Prepare;
    Qry.ParamByName('numeronf').AsString := FNumeroNF;
    Qry.ParamByName('modelo').AsString := FModelo;
    Qry.Open();
    while not(Qry.Eof) do
    begin
      AddActor(
        Qry.FieldByName('idatorinteressado').AsInteger,
        Qry.FieldByName('cpfcnpj').AsString,
        Boolean(Qry.FieldByName('is_protected').AsInteger)
      );
      Qry.Next;
    end;
  finally
    Qry.Free;
    FDMemTableMain.EnableControls;
  end;

end;

procedure TfmAtorInteressado.PersistDataset;
  procedure SetKeyParam(Qry: TIBQuery);
  begin
    Qry.ParamByName('NUMERONF').AsString := FNumeroNF;
    Qry.ParamByName('MODELO').AsString := FModelo;
  end;
begin
  if FDMemTableMain.State in ([dsInsert, dsEdit]) then
  begin
    if Trim(FDMemTableMainCPFCNPJ.AsString) = '' then
    begin
      if FDMemTableMain.State = dsInsert then
        FDMemTableMain.Cancel
      else
        FDMemTableMain.Delete;
    end else
      FDMemTableMain.Post;
  end;

  FDMemTableMain.DisableControls;
  var Qry := TIBQuery.Create(Self);
  try
    Qry.Database := FConnection;
    Qry.Transaction := FTransaction;
    Qry.SQL.Text := 'delete from atorinteressado '+
      'where numeronf = :numeronf and modelo = :modelo; ';
    SetKeyParam(Qry);
    Qry.Prepare;
    Qry.ExecSQL;

    Qry.SQL.Text := 'INSERT INTO atorinteressado '+
      '(IDATORINTERESSADO, NUMERONF, MODELO, CPFCNPJ, IS_PROTECTED) '+
      ' VALUES (NEXT VALUE FOR g_atorinteressado, '+
      '  :NUMERONF, :MODELO, :CPFCNPJ, :IS_PROTECTED '+
      ');';

    Qry.Prepare;

    FDMemTableMain.First;
    while not(FDMemTableMain.Eof) do
    begin
      SetKeyParam(Qry);
      var Identification := RemoveMask(FDMemTableMainCPFCNPJ.AsString);
      if not(Identification = '') then
      begin
        Qry.ParamByName('CPFCNPJ').AsString := Identification;
        Qry.ParamByName('IS_PROTECTED').AsInteger :=
          FDMemTableMainIS_PROTECTED.AsInteger;
        Qry.ExecSQL;
      end;
      FDMemTableMain.Next;
    end;
  finally
    Qry.Free;
    FDMemTableMain.EnableControls;
  end;
end;

function TfmAtorInteressado.RemoveMask(AValue: String): String;
begin
  Result := AValue.Replace('.', '').Replace('-', '').Replace('/', '');
end;

{ TIdentification }

class function TIdentification.Create(const AIdentification,
  AReference: String): TIdentification;
begin
  Result.Identification := AIdentification;
  Result.Reference := AReference;
end;

end.
