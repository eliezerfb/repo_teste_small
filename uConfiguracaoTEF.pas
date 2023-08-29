{Configuração TEF
Autor: Dailon Parisotto
}
unit uConfiguracaoTEF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, frame_teclado_1, StdCtrls, IniFiles, ComCtrls, Buttons,
  SmallFunc, Grids, DB, DBGrids, DBClient, MD5, uajustaresolucao;

const
  _cColunaAtivo    = 'ATIVO';
  _cCampoINIPasta  = 'Pasta';
  _cCampoINIReq    = 'Req';
  _cCampoINIResp   = 'Resp';
  _cCampoINIExec   = 'Exec';
  _cCampoINIbAtivo = 'bAtivo';

type
  TFConfiguracaoTEF = class(TForm)
    btnOK: TBitBtn;
    lblTitulo: TLabel;
    cdsTEFs: TClientDataSet;
    dsTEFs: TDataSource;
    dbgTEFs: TDBGrid;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    btnCancelar: TBitBtn;
    Label8: TLabel;
    cdsTEFsNOME: TStringField;
    cdsTEFsPASTA: TStringField;
    cdsTEFsDIRETORIOREQ: TStringField;
    cdsTEFsDIRETORIORESP: TStringField;
    cdsTEFsCAMINHOEXE: TStringField;
    cdsTEFsATIVO: TStringField;
    Panel2: TPanel;
    Frame_teclado1: TFrame_teclado;
    procedure btnOKClick(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cdsTEFsAfterInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbgTEFsExit(Sender: TObject);
    procedure cdsTEFsPostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure cdsTEFsATIVOSetText(Sender: TField; const Text: String);
    procedure dbgTEFsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgTEFsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgTEFsColEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dbgTEFsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgTEFsCellClick(Column: TColumn);
    procedure cdsTEFsNOMESetText(Sender: TField; const Text: String);
    procedure cdsTEFsPASTASetText(Sender: TField; const Text: String);
    procedure cdsTEFsDIRETORIOREQSetText(Sender: TField; const Text: String);
    procedure cdsTEFsDIRETORIORESPSetText(Sender: TField; const Text: String);
    procedure cdsTEFsCAMINHOEXESetText(Sender: TField; const Text: String);
    procedure FormDestroy(Sender: TObject);
  private
    FoIni: TIniFile;
    function SalvarINI: Boolean;
    procedure DeletarRecord(Sender: TObject);
    procedure CarregarINI;
    procedure AjustaLayout;
    function TestarConfiguracoes: Boolean;
    procedure DefineTemTEFINI;
  public
  end;

var
  FConfiguracaoTEF: TFConfiguracaoTEF;

implementation

uses fiscal, StrUtils, ufuncoesfrente, uSmallConsts;

{$R *.dfm}

procedure TFConfiguracaoTEF.btnOKClick(Sender: TObject);
begin
  if not TestarConfiguracoes then
    Exit;
    
  if SalvarINI then
    Close;
end;

function TFConfiguracaoTEF.TestarConfiguracoes: Boolean;
begin
  Result := False;

  cdsTEFs.DisableControls;
  cdsTEFs.First;
  try
    while not cdsTEFs.Eof do
    begin
      if cdsTEFsNOME.AsString = EmptyStr then
      begin
        Application.MessageBox('Nenhum nome foi definido para a configuração do TEF.', 'Atenção', MB_ICONINFORMATION + MB_OK);
        dbgTEFs.SetFocus;
        dbgTEFs.SelectedIndex := 0;
        Exit;
      end;
      
      cdsTEFs.Next;
    end;
  finally
    cdsTEFs.EnableControls;
  end;

  Result := True
end;

procedure TFConfiguracaoTEF.Image6Click(Sender: TObject);
begin
  btnOKClick(Sender);
end;

procedure TFConfiguracaoTEF.AjustaLayout;
var
  iColuna: Integer;
  iLargura: Integer;
begin
  Self.Top    := Form1.Panel1.Top;
  Self.Left   := Form1.Panel1.Left;
  Self.Height := Form1.Panel1.Height;
  Self.Width  := Form1.Panel1.Width;

  AjustaResolucao(Self);
  AjustaResolucao(Frame_teclado1);
  Form1.Image7Click(Self); 

  btnOK.Left := (Self.Width - (btnOK.Width + AjustaLargura(12) + btnCancelar.Width)) div 2;
  btnCancelar.Left := btnOK.BoundsRect.Right + AjustaLargura(12);

  for iColuna := 0 to dbgTEFs.Columns.Count -1 do
    dbgTEFs.Columns[iColuna].Width := AjustaLargura(dbgTEFs.Columns[iColuna].Width);

  iLargura := 0;
  for iColuna := 0 to dbgTEFs.Columns.Count -1 do
  begin
    if iColuna = 0 then
    begin
      Label2.Left  := dbgTEFs.Left + iLargura + AjustaLargura(3);
      Label2.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;

    if iColuna = 1 then
    begin
      Label3.Left  := dbgTEFs.Left + iLargura + AjustaLargura(4);
      Label3.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;

    if iColuna = 2 then
    begin
      Label4.Left  := dbgTEFs.Left + iLargura + AjustaLargura(5);
      Label4.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;

    if iColuna = 3 then
    begin
      Label5.Left  := dbgTEFs.Left + iLargura + AjustaLargura(6);
      Label5.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;

    if iColuna = 4 then
    begin
      Label8.Left  := dbgTEFs.Left + iLargura + AjustaLargura(6);
      Label8.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;

    if iColuna = 5 then
    begin
      Label6.Left  := dbgTEFs.Left + iLargura + AjustaLargura(6); 
      Label6.Width := dbgTEFs.Columns[iColuna].Width;
      iLargura := iLargura + dbgTEFs.Columns[iColuna].Width;
    end;
  end;
end;

procedure TFConfiguracaoTEF.FormCreate(Sender: TObject);
const
  _cChaveID = 'idxNOME';
begin
  FoIni     := TIniFile.Create(FRENTE_INI);

  AjustaLayout;

  cdsTEFs.CreateDataSet;
  cdsTEFs.IndexDefs.Add(_cChaveID, 'NOME', [ixUnique]);
  cdsTEFs.IndexName := _cChaveID;
end;

procedure TFConfiguracaoTEF.FormShow(Sender: TObject);
begin
  CarregarINI;

  dbgTEFs.Font.Size := btnOK.Font.Size;
  Frame_teclado1.Left := AjustaLargura(-12);

  lblTitulo.Left    := dbgTEFs.Left + AjustaLargura(3);
  lblTitulo.Caption := 'Configuração TEF';
end;

procedure TFConfiguracaoTEF.cdsTEFsAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName(_cColunaAtivo).AsString   := _cNao;
end;

procedure TFConfiguracaoTEF.CarregarINI;
var
  iSecao: Integer;
  cNomeSecao: String;
  slSessions : TStringList;
begin
  cdsTEFs.EmptyDataSet;

  slSessions := TStringList.Create;
  try
    FoIni.ReadSections(slSessions);

    for iSecao := 0 to Pred(slSessions.Count) do
    begin
      if (FoIni.ReadString(slSessions.Strings[iSecao], _cCampoINIbAtivo, EmptyStr) <> EmptyStr) then
      begin
        cNomeSecao := slSessions.Strings[iSecao];
        cdsTEFs.Append;
        cdsTEFsNOME.AsString          := cNomeSecao;
        cdsTEFsPASTA.AsString         := FoIni.ReadString(cNomeSecao, _cCampoINIPasta, EmptyStr);
        cdsTEFsDIRETORIOREQ.AsString  := FoIni.ReadString(cNomeSecao, _cCampoINIReq, EmptyStr);
        cdsTEFsDIRETORIORESP.AsString := FoIni.ReadString(cNomeSecao, _cCampoINIResp, EmptyStr);
        cdsTEFsCAMINHOEXE.AsString    := FoIni.ReadString(cNomeSecao, _cCampoINIExec, EmptyStr);
        cdsTEFsATIVO.AsString         := FoIni.ReadString(cNomeSecao, _cCampoINIbAtivo, _cNao);
        cdsTEFs.Post;
      end;
    end;
  finally
    FreeAndNil(slSessions);
  end;
  cdsTEFs.First;
end;

procedure TFConfiguracaoTEF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DefineTemTEFINI;
end;

procedure TFConfiguracaoTEF.DefineTemTEFINI;
begin
  cdsTEFs.DisableControls;
  cdsTEFs.First;
  FoIni.WriteString('Frente de caixa', 'TEM TEF', _cNao);
  if cdsTEFs.IsEmpty then
    Exit;
    
  while not cdsTEFs.Eof do
  begin
    if cdsTEFsATIVO.AsString = _cSim then
    begin
      FoIni.WriteString('Frente de caixa', 'TEM TEF', _cSim);
      Break;
    end;
    cdsTEFs.Next;
  end;
end;

function TFConfiguracaoTEF.SalvarINI: Boolean;
var
  cNomeSecao: String;
  iQtdPadrao: Integer;
begin
  Result := False;
  try
    cdsTEFs.First;

    while not cdsTEFs.Eof do
    begin
      if (cdsTEFsNOME.AsString <> EmptyStr) then
      begin
        if cdsTEFsNOME.AsString <> cdsTEFsNOME.OldValue then
          FoIni.EraseSection(cdsTEFsNOME.OldValue);

        cNomeSecao := cdsTEFsNOME.AsString;

        FoIni.WriteString(cNomeSecao, _cCampoINIPasta,  cdsTEFsPASTA.AsString);
        FoIni.WriteString(cNomeSecao, _cCampoINIReq,    cdsTEFsDIRETORIOREQ.AsString);
        FoIni.WriteString(cNomeSecao, _cCampoINIResp,   cdsTEFsDIRETORIORESP.AsString);
        FoIni.WriteString(cNomeSecao, _cCampoINIExec,   cdsTEFsCAMINHOEXE.AsString);
        FoIni.WriteString(cNomeSecao, _cCampoINIbAtivo, cdsTEFsATIVO.AsString);

        if AnsiUpperCase(cdsTEFsATIVO.AsString) = AnsiUpperCase(_cSim) then
          FoIni.WriteString('Frente de caixa', 'TEM TEF', _cSim);
      end;
      cdsTEFs.Next;
    end;
    Result := True;
  except
    on e:exception do
    begin
      Application.MessageBox(PAnsiChar('Não foi possível salvar a configuração do TEF.' + SLineBreak + e.Message), 'Atenção', MB_ICONINFORMATION + MB_OK);
    end;
  end;
end;

procedure TFConfiguracaoTEF.dbgTEFsExit(Sender: TObject);
begin
  if (Sender as TDBGrid).DataSource.DataSet.State in [dsEdit, dsInsert] then
    (Sender as TDBGrid).DataSource.DataSet.Post;
end;

procedure TFConfiguracaoTEF.cdsTEFsPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
  sAlerta: String;
begin
  sAlerta := E.Message;
  if AnsiContainsText(E.Message, 'Key Violation') then
  begin
    sAlerta := 'TEF já cadastrado';
    dbgTEFs.SelectedIndex := 0;
  end;
  if AnsiContainsText(E.Message, 'must have a value') then
    sAlerta := 'Preencha todas as colunas';
  Application.MessageBox(PAnsiChar(sAlerta), 'Atenção', MB_ICONWARNING + MB_OK);
  Action := daAbort;
end;

procedure TFConfiguracaoTEF.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFConfiguracaoTEF.cdsTEFsATIVOSetText(Sender: TField;
  const Text: String);
begin
  if AnsiUpperCase(Text) = AnsiUpperCase(_cSim) then
    Sender.AsString := _cSim
  else
    Sender.AsString := _cNao;
end;

procedure TFConfiguracaoTEF.dbgTEFsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  if Key = VK_RETURN then
  begin
    i := (Sender as TDbGrid).SelectedIndex;
    if ((Sender as TDbGrid).SelectedIndex + 1) < (Sender as TDbGrid).Columns.Count - 1 then
    begin
      (Sender as TDbGrid).SelectedIndex := (Sender as TDbGrid).SelectedIndex + 1;
      if i = (Sender as TDbGrid).SelectedIndex  then
      begin
        (Sender as TDbGrid).SelectedIndex := 0;
        (Sender as TDbGrid).DataSource.DataSet.Next;
        if (Sender as TDbGrid).DataSource.DataSet.EOF then
          (Sender as TDbGrid).DataSource.DataSet.Append;
      end;
    end
    else
    begin
      (Sender as TDbGrid).SelectedIndex := 0;
      (Sender as TDbGrid).DataSource.DataSet.Next;
      if (Sender as TDbGrid).DataSource.DataSet.EOF then
        (Sender as TDbGrid).DataSource.DataSet.Append;
    end;
  end;
end;

procedure TFConfiguracaoTEF.dbgTEFsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Shift = [ssctrl]) and (Key = VK_Delete)) then
  begin
    Key := 0;
    DeletarRecord(Sender);
  end;
end;

procedure TFConfiguracaoTEF.dbgTEFsColEnter(Sender: TObject);
begin
  if UpperCase(TDBGrid(Sender).SelectedField.FieldName) = _cColunaAtivo then
    TDBGrid(Sender).Options := TDBGrid(Sender).Options - [dgEditing]
  else
    TDBGrid(Sender).Options := TDBGrid(Sender).Options + [dgEditing];
end;

procedure TFConfiguracaoTEF.DeletarRecord(Sender: TObject);
begin
  if cdsTEFs.IsEmpty then
    Exit;
    
  if Application.MessageBox(PAnsiChar('Excluir a configuração do TEF ' + cdsTEFsNOME.AsString + '?'), 'Atenção', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2) = idYes then
  begin
    if (cdsTEFsNOME.AsString <> EmptyStr) and (FoIni.SectionExists(cdsTEFsNOME.AsString)) then
      FoIni.EraseSection(cdsTEFsNOME.AsString);
    cdsTEFs.Delete;
    dbgTEFs.SelectedIndex := 0;
  end;
end;

procedure TFConfiguracaoTEF.FormActivate(Sender: TObject);
begin
  Frame_teclado1.Led_FISCAL.Picture := Form1.Frame_teclado1.Led_FISCAL.Picture;
  Frame_teclado1.Led_FISCAL.Hint    := Form1.Frame_teclado1.Led_FISCAL.Hint;

  Frame_teclado1.Led_ECF.Picture    := Form1.Frame_teclado1.Led_ECF.Picture;
  Frame_teclado1.Led_ECF.Hint       := Form1.Frame_teclado1.Led_ECF.Hint;

  Frame_teclado1.Led_REDE.Picture   := Form1.Frame_teclado1.Led_REDE.Picture;
  Frame_teclado1.Led_REDE.Hint      := Form1.Frame_teclado1.Led_REDE.Hint;
end;

procedure TFConfiguracaoTEF.dbgTEFsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  iCheck: Integer;
  rRect: TRect;
begin
  if Column.FieldName = _cColunaAtivo then
  begin
    dbgTEFs.Canvas.FillRect(Rect);
    iCheck := 0;
    if cdsTEFsATIVO.AsString = _cSim then
      iCheck := DFCS_CHECKED
    else
      iCheck := 0;
    rRect := Rect;
    InflateRect(rRect,-2,-2);
    DrawFrameControl(dbgTEFs.Canvas.Handle,rRect,DFC_BUTTON, DFCS_BUTTONCHECK or iCheck);
  end;
end;

procedure TFConfiguracaoTEF.dbgTEFsCellClick(Column: TColumn);
begin
  if Column.FieldName = _cColunaAtivo then
  begin
    cdsTEFs.Edit;
    if cdsTEFsATIVO.AsString = _cSim then
      cdsTEFsATIVO.AsString := _cNao
    else
      cdsTEFsATIVO.AsString := _cSim;
    cdsTEFs.Post;
  end;
end;

procedure TFConfiguracaoTEF.cdsTEFsNOMESetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Trim(Text);
end;

procedure TFConfiguracaoTEF.cdsTEFsPASTASetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Trim(Text);
end;

procedure TFConfiguracaoTEF.cdsTEFsDIRETORIOREQSetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Trim(Text);
end;

procedure TFConfiguracaoTEF.cdsTEFsDIRETORIORESPSetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Trim(Text);
end;

procedure TFConfiguracaoTEF.cdsTEFsCAMINHOEXESetText(Sender: TField;
  const Text: String);
begin
  Sender.AsString := Trim(Text);
end;

procedure TFConfiguracaoTEF.FormDestroy(Sender: TObject);
begin
  FoIni.Free;
end;

end.
