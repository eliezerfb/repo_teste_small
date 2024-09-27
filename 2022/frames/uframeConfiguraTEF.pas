unit uframeConfiguraTEF;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Datasnap.DBClient, IniFiles, System.StrUtils,
  IBX.IBDatabase;

const
  _cColunaAtivo    = 'ATIVO';
  _cColunaIDNOME   = 'IDNOME';
  _cCampoINIPasta  = 'Pasta';
  _cCampoINIReq    = 'Req';
  _cCampoINIResp   = 'Resp';
  _cCampoINIExec   = 'Exec';
  _cCampoINIbAtivo = 'bAtivo';

type
  TframeConfiguraTEF = class(TFrame)
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    btnOK: TBitBtn;
    dbgTEFs: TDBGrid;
    btnCancelar: TBitBtn;
    cdsTEFs: TClientDataSet;
    cdsTEFsNOME: TStringField;
    cdsTEFsPASTA: TStringField;
    cdsTEFsDIRETORIOREQ: TStringField;
    cdsTEFsDIRETORIORESP: TStringField;
    cdsTEFsCAMINHOEXE: TStringField;
    cdsTEFsATIVO: TStringField;
    cdsTEFsIDNOME: TStringField;
    dsTEFs: TDataSource;
    procedure dbgTEFsCellClick(Column: TColumn);
    procedure dbgTEFsColEnter(Sender: TObject);
    procedure dbgTEFsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgTEFsEnter(Sender: TObject);
    procedure dbgTEFsExit(Sender: TObject);
    procedure dbgTEFsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbgTEFsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cdsTEFsAfterInsert(DataSet: TDataSet);
    procedure cdsTEFsAfterPost(DataSet: TDataSet);
    procedure cdsTEFsPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure btnOKClick(Sender: TObject);
    procedure cdsTEFsNOMEChange(Sender: TField);
    procedure cdsTEFsNOMESetText(Sender: TField; const Text: string);
    procedure cdsTEFsPASTASetText(Sender: TField; const Text: string);
    procedure cdsTEFsDIRETORIOREQSetText(Sender: TField; const Text: string);
    procedure cdsTEFsDIRETORIORESPSetText(Sender: TField; const Text: string);
    procedure cdsTEFsCAMINHOEXESetText(Sender: TField; const Text: string);
    procedure cdsTEFsATIVOSetText(Sender: TField; const Text: string);
    procedure cdsTEFsIDNOMESetText(Sender: TField; const Text: string);
  private
    FoIni: TIniFile;
    FbSalvou: Boolean;
    FoIBDataBase: TIbDataBase;
    procedure DeletarRecord(Sender: TObject);
    function TestarConfiguracoes: Boolean;
    function SalvarINI: Boolean;
    procedure CarregarINI;
  public
    property IBDataBase: TIbDataBase read FoIBDataBase write FoIBDataBase;
    property Salvou: Boolean read FbSalvou;
    procedure CriarObjetos;
    procedure LimparObjetos;
    function TestarZPOSLiberado: Boolean;
    procedure DefineTemTEFINI;
  end;

implementation

{$R *.dfm}

uses
  uSmallConsts, uDialogs, uValidaRecursos,
  uTypesRecursos, uSmallResourceString;

procedure TframeConfiguraTEF.btnOKClick(Sender: TObject);
begin
  if not TestarConfiguracoes then
    Exit;

  FbSalvou := SalvarINI;
end;

function TframeConfiguraTEF.SalvarINI: Boolean;
var
  cNomeSecao: String;
//Sandro Silva 2024-09-26  iQtdPadrao: Integer;
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

    {Sandro Silva 2023-10-24 inicio}
//    FoIni.WriteString(SECAO_FRENTE_CAIXA, CHAVE_INI_SUPRIMIR_LINHAS_EM_BRANCO_DO_COMPROVANTE_TEF, IfThen(chkSuprimirLinhasEmBrancoDoComprovante.Checked, _cSim, _cNao));
    {Sandro Silva 2023-10-24 fim}

    DefineTemTEFINI;
    Result := True;
  except
    on e:exception do
    begin
      Application.MessageBox(PChar('Não foi possível salvar a configuração do TEF.' + SLineBreak + e.Message), 'Atenção', MB_ICONINFORMATION + MB_OK);
    end;
  end;
end;

procedure TframeConfiguraTEF.DefineTemTEFINI;
begin
  cdsTEFs.DisableControls;
  try
    cdsTEFs.First;
    FoIni.WriteString('Frente de caixa', 'TEM TEF', _cNao);
    if cdsTEFs.IsEmpty then
      Exit;

    while not cdsTEFs.Eof do
    begin
      if cdsTEFsATIVO.AsString = _cSim then
      begin
        if TestarZPOSLiberado then
        begin
          FoIni.WriteString('Frente de caixa', 'TEM TEF', _cSim);
          Break;
        end;
      end;
      cdsTEFs.Next;
    end;
  finally
    cdsTEFs.EnableControls;
  end;
end;

function TframeConfiguraTEF.TestarConfiguracoes: Boolean;
begin
  Result := False;

  cdsTEFs.DisableControls;
  cdsTEFs.First;
  try
    while not cdsTEFs.Eof do
    begin
      if (cdsTEFsNOME.AsString = EmptyStr)
         and (cdsTEFsPASTA.AsString = EmptyStr)
         and (cdsTEFsDIRETORIOREQ.AsString = EmptyStr)
         and (cdsTEFsDIRETORIORESP.AsString = EmptyStr)
         and (cdsTEFsCAMINHOEXE.AsString = EmptyStr) then
      begin
        cdsTEFs.Delete;
        Continue;
      end;

      if cdsTEFsNOME.AsString = EmptyStr then
      begin
        Application.MessageBox('Nenhum nome foi definido para a configuração do TEF.', 'Atenção', MB_ICONINFORMATION + MB_OK);
        dbgTEFs.SetFocus;
        dbgTEFs.SelectedIndex := 1;
        Exit;
      end;

      cdsTEFs.Next;
    end;
  finally
    cdsTEFs.EnableControls;
  end;

  Result := True
end;

procedure TframeConfiguraTEF.cdsTEFsAfterInsert(DataSet: TDataSet);
var
  i: Integer;
begin
  for i := 0 to Pred(DataSet.Fields.Count) do
  begin
    if DataSet.Fields[i].FieldName <> _cColunaAtivo then
      DataSet.FieldByName(DataSet.Fields[i].FieldName).AsString := EmptyStr;
  end;
  DataSet.FieldByName(_cColunaAtivo).AsString   := _cNao;
end;

procedure TframeConfiguraTEF.cdsTEFsAfterPost(DataSet: TDataSet);
var
  nRecNo: Integer;
begin
  nRecNo := cdsTEFs.RecNo;
  cdsTEFs.DisableControls;
  try
    while not cdsTEFs.Eof do
    begin
      if cdsTEFsNOME.AsString = EmptyStr then
        cdsTEFs.Delete;
      cdsTEFs.Next;
    end;
  finally
    if not cdsTEFs.IsEmpty then
      cdsTEFs.RecNo := nRecNo;
    cdsTEFs.EnableControls;
  end;
end;

procedure TframeConfiguraTEF.cdsTEFsATIVOSetText(Sender: TField;
  const Text: string);
begin
  if AnsiUpperCase(Text) = AnsiUpperCase(_cSim) then
    Sender.AsString := _cSim
  else
    Sender.AsString := _cNao;
end;

procedure TframeConfiguraTEF.cdsTEFsCAMINHOEXESetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Trim(Text);
end;

procedure TframeConfiguraTEF.cdsTEFsDIRETORIOREQSetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Trim(Text);
end;

procedure TframeConfiguraTEF.cdsTEFsDIRETORIORESPSetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Trim(Text);
end;

procedure TframeConfiguraTEF.cdsTEFsIDNOMESetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := AnsiUpperCase(Trim(Text));
end;

procedure TframeConfiguraTEF.cdsTEFsNOMEChange(Sender: TField);
begin
  if Sender.AsString <> EmptyStr then
    cdsTEFsIDNOME.AsString := AnsiUpperCase(Sender.AsString);
end;

procedure TframeConfiguraTEF.cdsTEFsNOMESetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Trim(Text);
end;

procedure TframeConfiguraTEF.cdsTEFsPASTASetText(Sender: TField;
  const Text: string);
begin
  Sender.AsString := Trim(Text);
end;

procedure TframeConfiguraTEF.cdsTEFsPostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
  cAlerta: String;
begin
  cAlerta := E.Message;
  if AnsiContainsText(E.Message, 'Key Violation') then
  begin
    cAlerta := 'TEF já cadastrado';
    dbgTEFs.SelectedIndex := 1;
  end;
  if AnsiContainsText(E.Message, 'must have a value') then
    cAlerta := 'Preencha todas as colunas';
  Application.MessageBox(PChar(cAlerta), 'Atenção', MB_ICONWARNING + MB_OK);
  Action := daAbort;
end;

procedure TframeConfiguraTEF.CriarObjetos;
const
  _cChaveID = 'idxIDNOME';
begin
  FoIni     := TIniFile.Create('FRENTE.INI');

  cdsTEFs.CreateDataSet;
  cdsTEFs.IndexDefs.Add(_cChaveID, _cColunaIDNOME, [ixUnique]);
  cdsTEFs.IndexName := _cChaveID;

  CarregarINI;
end;

procedure TframeConfiguraTEF.CarregarINI;
var
  iSecao: Integer;
  cNomeSecao: String;
  slSessions : TStringList;
  {Dailon Parisotto (f-18547) 2024-05-06 Inicio}
  bTemTEF: Boolean;
  {Dailon Parisotto (f-18547) 2024-05-06 Fim}
begin
  cdsTEFs.EmptyDataSet;

  slSessions := TStringList.Create;
  try
    {Dailon Parisotto (f-18547) 2024-05-06 Inicio}
    bTemTEF := (FoIni.ReadString('Frente de caixa', 'TEM TEF', _cNao) = _cSim);
    {Dailon Parisotto (f-18547) 2024-05-06 Fim}

    FoIni.ReadSections(slSessions);

    for iSecao := 0 to Pred(slSessions.Count) do
    begin
      if (FoIni.ReadString(slSessions.Strings[iSecao], _cCampoINIbAtivo, EmptyStr) <> EmptyStr) then
      begin
        cNomeSecao := slSessions.Strings[iSecao];
        cdsTEFs.Append;
        cdsTEFsIDNOME.AsString        := AnsiUpperCase(cNomeSecao);
        cdsTEFsNOME.AsString          := cNomeSecao;
        cdsTEFsPASTA.AsString         := FoIni.ReadString(cNomeSecao, _cCampoINIPasta, EmptyStr);
        cdsTEFsDIRETORIOREQ.AsString  := FoIni.ReadString(cNomeSecao, _cCampoINIReq, EmptyStr);
        cdsTEFsDIRETORIORESP.AsString := FoIni.ReadString(cNomeSecao, _cCampoINIResp, EmptyStr);
        cdsTEFsCAMINHOEXE.AsString    := FoIni.ReadString(cNomeSecao, _cCampoINIExec, EmptyStr);

        {Dailon Parisotto (f-18547) 2024-05-06 Inicio

        cdsTEFsATIVO.AsString         := FoIni.ReadString(cNomeSecao, _cCampoINIbAtivo, _cNao);

        }
        if not bTemTEF then
          cdsTEFsATIVO.AsString         := _cNao
        else
          cdsTEFsATIVO.AsString         := FoIni.ReadString(cNomeSecao, _cCampoINIbAtivo, _cNao);
        {Dailon Parisotto (f-18547) 2024-05-06 Fim}

        cdsTEFs.Post;
      end;
    end;

    {Sandro Silva 2023-10-24 inicio}
//    chkSuprimirLinhasEmBrancoDoComprovante.Checked := (FoIni.ReadString(SECAO_FRENTE_CAIXA, CHAVE_INI_SUPRIMIR_LINHAS_EM_BRANCO_DO_COMPROVANTE_TEF, _cNao) = _cSim);
    {Sandro Silva 2023-10-24 fim}

    {Dailon Parisotto (f-18547) 2024-05-06 Inicio}
    if not bTemTEF then
      SalvarINI;
    {Dailon Parisotto (f-18547) 2024-05-06 Fim}

  finally
    FreeAndNil(slSessions);
  end;
  cdsTEFs.First;
end;

function TframeConfiguraTEF.TestarZPOSLiberado: Boolean;
var
  dLimiteRecurso : Tdate;
begin
  Result := True;
  if (Pos('ZPOS', AnsiUpperCase(cdsTEFsNOME.AsString)) > 0) then
    Result := (RecursoLiberado(FoIBDataBase, rcZPOS, dLimiteRecurso));
end;

procedure TframeConfiguraTEF.dbgTEFsCellClick(Column: TColumn);
begin
  if not TestarZPOSLiberado then
  begin
    cdsTEFs.Edit;
    cdsTEFsATIVO.AsString := _cNao;
    cdsTEFs.Post;
    cdsTEFs.Edit;

    uDialogs.MensagemSistema(_cSerialSemAcessoRecurso, msgInformacao);
    Exit;
  end;

  if Column.FieldName = _cColunaAtivo then
  begin
    cdsTEFs.Edit;
    if cdsTEFsATIVO.AsString = _cSim then
      cdsTEFsATIVO.AsString := _cNao
    else
    begin

      if (cdsTEFsNOME.AsString = EmptyStr)
         or (cdsTEFsPASTA.AsString = EmptyStr)
         or (cdsTEFsDIRETORIOREQ.AsString = EmptyStr)
         or (cdsTEFsDIRETORIORESP.AsString = EmptyStr)
         or (cdsTEFsCAMINHOEXE.AsString = EmptyStr) then
        uDialogs.MensagemSistema('Para ativar este TEF todos os campos devem ser preenchidos.', msgInformacao)
      else
        cdsTEFsATIVO.AsString := _cSim;

    end;
    cdsTEFs.Post;
    cdsTEFs.Edit;
  end;
end;

procedure TframeConfiguraTEF.dbgTEFsColEnter(Sender: TObject);
begin
  if UpperCase(TDBGrid(Sender).SelectedField.FieldName) = _cColunaAtivo then
    TDBGrid(Sender).Options := TDBGrid(Sender).Options - [dgEditing]
  else
    TDBGrid(Sender).Options := TDBGrid(Sender).Options + [dgEditing];
end;

procedure TframeConfiguraTEF.dbgTEFsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  iCheck: Integer;
  rRect: TRect;
begin
  if Column.FieldName = _cColunaAtivo then
  begin
    dbgTEFs.Canvas.Font.Color := clWindow;
    dbgTEFs.Canvas.Brush.Color := clWindow;
    dbgTEFs.Canvas.FillRect(Rect);
    iCheck := 0;
    if cdsTEFsATIVO.AsString = _cSim then
      iCheck := DFCS_CHECKED
    else
      iCheck := 0;
    rRect := Rect;
    InflateRect(rRect, -2, -2);
    DrawFrameControl(dbgTEFs.Canvas.Handle,rRect,DFC_BUTTON, DFCS_BUTTONCHECK or iCheck);
  end;
end;

procedure TframeConfiguraTEF.dbgTEFsEnter(Sender: TObject);
begin
  if UpperCase(TDBGrid(Sender).SelectedField.FieldName) = _cColunaAtivo then
    TDBGrid(Sender).Options := TDBGrid(Sender).Options - [dgEditing]
  else
    TDBGrid(Sender).Options := TDBGrid(Sender).Options + [dgEditing];
end;

procedure TframeConfiguraTEF.dbgTEFsExit(Sender: TObject);
begin
  if (Sender as TDBGrid).DataSource.DataSet.State in [dsEdit, dsInsert] then
    (Sender as TDBGrid).DataSource.DataSet.Post;
end;

procedure TframeConfiguraTEF.dbgTEFsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Shift = [ssctrl]) and (Key = VK_Delete)) then
  begin
    Key := 0;
    DeletarRecord(Sender);
  end;
  if Key = VK_DOWN then
  begin
    if (cdsTEFsNOME.AsString = EmptyStr) and (cdsTEFs.Eof) then
      Key := 0;
  end;
end;

procedure TframeConfiguraTEF.DeletarRecord(Sender: TObject);
begin
  if cdsTEFs.IsEmpty then
    Exit;

  if Application.MessageBox(PChar('Excluir a configuração do TEF ' + cdsTEFsNOME.AsString + '?'), 'Atenção', MB_ICONWARNING + MB_YESNO + MB_DEFBUTTON2) = idYes then
  begin
    if (cdsTEFsNOME.AsString <> EmptyStr) and (FoIni.SectionExists(cdsTEFsNOME.AsString)) then
      FoIni.EraseSection(cdsTEFsNOME.AsString);
    cdsTEFs.Delete;
    dbgTEFs.SelectedIndex := 0;
  end;
end;

procedure TframeConfiguraTEF.LimparObjetos;
begin
  FoIni.Free;
end;

procedure TframeConfiguraTEF.dbgTEFsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: Integer;
begin
  if Key = VK_RETURN then
  begin
    i := (Sender as TDbGrid).SelectedIndex;
    if ((Sender as TDbGrid).SelectedIndex) <= (Sender as TDbGrid).Columns.Count - 1 then
    begin
      (Sender as TDbGrid).SelectedIndex := (Sender as TDbGrid).SelectedIndex + 1;
      if i = (Sender as TDbGrid).SelectedIndex  then
      begin
        (Sender as TDbGrid).SelectedIndex := 0;
        (Sender as TDbGrid).DataSource.DataSet.Next;
        if (Sender as TDbGrid).DataSource.DataSet.EOF then
        begin
          if (Sender as TDbGrid).DataSource.DataSet.FieldByName('NOME').AsString = EmptyStr then
            (Sender as TDbGrid).DataSource.DataSet.Delete;
          (Sender as TDbGrid).DataSource.DataSet.Append;
        end;
      end;
    end
    else
    begin
      (Sender as TDbGrid).SelectedIndex := 0;
      (Sender as TDbGrid).DataSource.DataSet.Next;
      if (Sender as TDbGrid).DataSource.DataSet.EOF then
      begin
        if (Sender as TDbGrid).DataSource.DataSet.FieldByName('NOME').AsString = EmptyStr then
          (Sender as TDbGrid).DataSource.DataSet.Delete;
        (Sender as TDbGrid).DataSource.DataSet.Append;
      end;
    end;
  end;
end;

end.
