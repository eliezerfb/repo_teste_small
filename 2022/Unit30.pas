unit Unit30;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, DBCtrls, SMALL_DBEdit, ShellApi, Grids,
  DBGrids, DB, SmallFunc, IniFiles, htmlHelp, Menus, Buttons, jpeg, IBQuery,
  uframeCampo, uframePesquisaPadrao, uframePesquisaServico, IBCustomDataSet;

const COLOR_GRID_CINZA = $00F0F0F0;

type
  TForm30 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label30: TLabel;
    Label25: TLabel;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit6: TSMALL_DBEdit;
    SMALL_DBEdit7: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit10: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    SMALL_DBEdit11: TSMALL_DBEdit;
    DBGrid3: TDBGrid;
    SMALL_DBEdit13: TSMALL_DBEdit;
    listSituacao: TListBox;
    ListBox2: TListBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    SMALL_DBEdit19: TSMALL_DBEdit;
    Label29: TLabel;
    Label8: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Panel2: TPanel;
    SMALL_DBEdit20: TSMALL_DBEdit;
    SMALL_DBEdit21: TSMALL_DBEdit;
    SMALL_DBEdit22: TSMALL_DBEdit;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    PopupMenu3: TPopupMenu;
    Incluirnovoitemnoestoque1: TMenuItem;
    Incluirnovocliente1: TMenuItem;
    Button1: TBitBtn;
    Label13: TLabel;
    framePesquisaServOS: TframePesquisaServico;
    fFrameIdentifi1: TfFrameCampo;
    fFrameDescricao: TfFrameCampo;
    fFrameIdentifi2: TfFrameCampo;
    fFrameIdentifi3: TfFrameCampo;
    fFrameIdentifi4: TfFrameCampo;
    pnlFotoProd: TPanel;
    imgFotoProd: TImage;
    procedure FormCreate(Sender: TObject);
    procedure SMALL_DBEdit2Enter(Sender: TObject);
    procedure SMALL_DBEdit6Enter(Sender: TObject);
    procedure SMALL_DBEdit3Change(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit2Change(Sender: TObject);
    procedure SMALL_DBEdit3Enter(Sender: TObject);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit4Enter(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure Label14MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label14MouseLeave(Sender: TObject);
    procedure Label13MouseLeave(Sender: TObject);
    procedure Label21MouseLeave(Sender: TObject);
    procedure Label22MouseLeave(Sender: TObject);
    procedure Label13MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label22MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SMALL_DBEdit7Enter(Sender: TObject);
    procedure SMALL_DBEdit7Change(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid2Enter(Sender: TObject);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure SMALL_DBEdit3Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SMALL_DBEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure listSituacaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure DBGrid2ColExit(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox2Click(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure SMALL_DBEdit11KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBMemo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo2Enter(Sender: TObject);
    procedure DBMemo1Enter(Sender: TObject);
    procedure DBMemo1Exit(Sender: TObject);
    procedure Incluirnovoitemnoestoque1Click(Sender: TObject);
    procedure Incluirnovocliente1Click(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure listSituacaoDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure DBGrid2ColEnter(Sender: TObject);
    procedure framePesquisaServOSdbgItensPesqCellClick(Column: TColumn);
    procedure framePesquisaServOSdbgItensPesqKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure framePesquisaServOSdbgItensPesqKeyPress(Sender: TObject;
      var Key: Char);
    procedure fFrameIdentifi1txtCampoEnter(Sender: TObject);
    procedure fFrameDescricaotxtCampoEnter(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure fFrameIdentifi2txtCampoEnter(Sender: TObject);
    procedure fFrameIdentifi3txtCampoEnter(Sender: TObject);
    procedure fFrameIdentifi4txtCampoEnter(Sender: TObject);
    procedure fFrameDescricaogdRegistrosDblClick(Sender: TObject);
    procedure SMALL_DBEdit7Exit(Sender: TObject);
    procedure SMALL_DBEdit7Click(Sender: TObject);
    procedure DBGrid3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    procedure DefinirCorClienteDevedor;
    procedure DescricaoServicoChange(Sender: TField);
    procedure AtribuirItemPesquisaServico;
    procedure OcultaListaDePesquisa;
    procedure MostraFoto;
    procedure CarregaSituacoes;
  public
    { Public declarations }
    sSistema, sDatafield : String;
    fPrecoDoServico: array of Real; // Sandro Silva 2023-08-08 fPrecoDoServico : array[0..99999] of real;
  end;

var
  Form30: TForm30;
  bProximo : Boolean;

implementation

uses Mais, Unit7, Unit12, Unit41, Unit19, Unit22, Unit24, Mais3, preco1,
  Unit10, uTestaClienteDevendo, uFuncoesBancoDados;

{$R *.dfm}

function Seleciona(pP1: Boolean):Boolean;
begin
  with Form30 do
  begin
    // Tecnicos
    if dbGrid3.Top = (SMALL_DBEdit2.Top + SMALL_DBEdit2.Height -1) then
    begin
      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3TECNICO.AsString  := form7.ibDataSet9NOME.AsString;
      SMALL_DBEdit2.SetFocus;
      dBGrid3.Visible := False;
    end;

    // Clientes
    if dbGrid3.Top = (SMALL_DBEdit3.Top + SMALL_DBEdit3.Height -1) then
    begin
      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3CLIENTE.AsString  := form7.ibDataSet2NOME.AsString;
      SMALL_DBEdit3.SetFocus;
      dBGrid3.Visible := False;
    end;

    // Produtos
    if dbGrid3.Top = (dbGrid1.Top + dbGrid1.Height -1) then
    begin
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16DESCRICAO.AsString  := Form7.ibDataSet4DESCRICAO.AsString;
      dbGrid1.SetFocus;
      dBGrid3.Visible := False;
    end;

    // Tecnicos no grid
    if dbGrid3.Top = (dbGrid2.Top + dbGrid2.Height -1) then
    begin
      Form7.ibDataSet35.Edit;
      Form7.ibDataSet35TECNICO.AsString  := Form7.ibDataSet9NOME.AsString;
      dbGrid2.SetFocus;
      dBGrid3.Visible := False;
    end;
  end;

  Result := True;
end;

procedure TForm30.FormCreate(Sender: TObject);
begin
  {Sandro Silva 2023-10-10 inicio}
  fFrameDescricao.gdRegistros.Color := COLOR_GRID_CINZA;
  fFrameDescricao.CampoVazioAbrirGridPesquisa := True;
  fFrameDescricao.AutoSizeColunaNoGridDePesquisa := True;
  fFrameIdentifi1.gdRegistros.Color := COLOR_GRID_CINZA;
  fFrameIdentifi1.CampoVazioAbrirGridPesquisa := True;
  fFrameIdentifi1.AutoSizeColunaNoGridDePesquisa := True;
  fFrameIdentifi2.gdRegistros.Color := COLOR_GRID_CINZA;
  fFrameIdentifi2.CampoVazioAbrirGridPesquisa := True;
  fFrameIdentifi2.AutoSizeColunaNoGridDePesquisa := True;
  fFrameIdentifi3.gdRegistros.Color := COLOR_GRID_CINZA;
  fFrameIdentifi3.CampoVazioAbrirGridPesquisa := True;
  fFrameIdentifi3.AutoSizeColunaNoGridDePesquisa := True;
  fFrameIdentifi4.gdRegistros.Color := COLOR_GRID_CINZA;
  fFrameIdentifi4.CampoVazioAbrirGridPesquisa := True;
  fFrameIdentifi4.AutoSizeColunaNoGridDePesquisa := True;
  {Sandro Silva 2023-10-10 fim}
end;

procedure TForm30.SMALL_DBEdit2Enter(Sender: TObject);
begin
  // Tecnicos
  dBGrid3.DataSource                 := Form7.DataSource9;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := SMALL_DBEdit2.Width - 21;
  dBGrid3.Visible                    := True;  // SMALL_DBEdit2ENTER
  dBGrid3.Left                       := SMALL_DBEdit2.Left;
  dbGrid3.Top                        := SMALL_DBEdit2.Top + SMALL_DBEdit2.Height -1;
  dbGrid3.Width                      := SMALL_DBEdit2.Width;
  //dBGrid3.Height                     := 201;
  dBGrid3.Height                     := 161;
  listSituacao.Visible               := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
  //
  dBgrid3.Columns.Items[1].FieldName := '';
  dBgrid3.Columns.Items[1].Visible   := False;
  dBgrid3.Columns.Items[2].FieldName := '';
  dBgrid3.Columns.Items[2].Visible   := False;
  dBgrid3.Columns.Items[3].FieldName := '';
  dBgrid3.Columns.Items[3].Visible   := False;
  //
  Form30.SMALL_DBEdit2Change(Sender);
end;

procedure TForm30.SMALL_DBEdit6Enter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;

procedure TForm30.SMALL_DBEdit3Change(Sender: TObject);
begin
  if Alltrim(SMALL_DBEdit3.Text) <> '' then
  begin
    if (Form30.Visible) and (Form7.ibDataSet2.Active) and (not dbGrid3.Focused) then
    begin
      //
      if Form1.bChaveSelecionaCliente then
      begin
        dBGrid3.Visible    := True;
        Form7.ibDataSet2.DisableControls;
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.SelectSQL.Clear;
        Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit3.Text)+'%')+' and coalesce(ATIVO,0)=0 order by NOME');
        Form7.ibDataSet2.Open;
        Form7.ibDataSet2.EnableControls;
      end;  
      //
    end;
  end else
    DefinirCorClienteDevedor;
  
  listSituacao.Visible := False;
end;

procedure TForm30.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if dbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);
end;

procedure TForm30.SMALL_DBEdit2Change(Sender: TObject);
begin
  if (Form30.Visible) and (Form7.ibDataSet9.Active) then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%TECNICO%')+' and Upper(NOME) like '+QuotedStr(UpperCase(SMALL_DBEdit2.Text)+'%')+' order by NOME');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;

    if not Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]) then
    begin
      Form7.ibDataSet99.Close;
      Form7.ibDataSet99.SelectSQL.Clear;
      Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%TECNICO%')+' and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit2.Text)+'%')+' order by NOME');
      Form7.ibDataSet99.Open;
      Form7.ibDataSet99.First;
      Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    end;
  end;
end;

procedure TForm30.SMALL_DBEdit3Enter(Sender: TObject);
begin
  // Cliente
  Form1.bChaveSelecionaCliente := True;

  dBGrid3.DataSource                 := Form7.DataSource2;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := SMALL_DBEdit3.Width - 21;
  dBGrid3.Left                       := SMALL_DBEdit3.Left;
  dbGrid3.Top                        := SMALL_DBEdit3.Top + SMALL_DBEdit3.Height -1;
  dbGrid3.Width                      := SMALL_DBEdit3.Width;
  dBGrid3.Height                     := 182;
  listSituacao.Visible               := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
  //
  dBgrid3.Columns.Items[1].FieldName := '';
  dBgrid3.Columns.Items[1].Visible   := False;
  dBgrid3.Columns.Items[2].FieldName := '';
  dBgrid3.Columns.Items[2].Visible   := False;
  dBgrid3.Columns.Items[3].FieldName := '';
  dBgrid3.Columns.Items[3].Visible   := False;
  dBGrid3.Visible    := False;
  //
end;

procedure TForm30.DBGrid3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then Key := 0;
  if Key = VK_Return then Seleciona(True);
end;

procedure TForm30.SMALL_DBEdit4Enter(Sender: TObject);
begin
  {Sandro Silva 2023-09-28 inicio
  //
  ListBox1.Visible                   := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
  dbGrid3.Visible := False;
  //
  }
  OcultaListaDePesquisa;
end;

procedure TForm30.Label15Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  with Sender as TLabel do
  begin
    sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),'','');
    if AllTrim(sNome) <> '' then Caption := sNome else sNome := Caption;
    Repaint;
    
    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString('OS',NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TForm30.Label14MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as TLabel do
  begin
    Font.Style := [fsBold,fsUnderline];
    Font.Color := clBlue;
    Repaint;
  end;
end;

procedure TForm30.Label14MouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Font.Style := [];
    Font.Color := clSilver;
    Repaint;
  end;
end;

procedure TForm30.Label13MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm30.Label21MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm30.Label22MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm30.Label13MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm30.Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm30.Label22MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm30.SMALL_DBEdit7Enter(Sender: TObject);
begin
  {Sandro Silva 2023-09-28 inicio
  //
  dbGrid3.Visible   := False;
  }
  OcultaListaDePesquisa;  
  listSituacao.Visible  := True;
  //listSituacao.Height   := 53; // Sandro Silva 2023-10-17   ListBox1.Height   := 41; Mauricio Parizotto
  listSituacao.Height   := 161;
  SMALL_DBEdit7.SelectAll;
end;

procedure TForm30.SMALL_DBEdit7Change(Sender: TObject);
var
  I : Integer;
begin
  {Sandro Silva 2023-10-16 inicio
  for I := 0 to 2 do
  begin
    if AnsiUpperCase(AllTrim(SMALL_DBEdit7.Text)) = AnSiUpperCase(Copy(ListBox1.Items[i], 1, Length(AllTrim(SMALL_DBEdit7.Text)))) then
      ListBox1.ItemIndex := I;
  end;
  }
  listSituacao.Visible := True;
  for I := 0 to listSituacao.Items.Count -1 do
  begin
    if AnsiUpperCase(AllTrim(SMALL_DBEdit7.Text)) = AnSiUpperCase(Copy(listSituacao.Items[i], 1, Length(AllTrim(SMALL_DBEdit7.Text)))) then
    begin
      listSituacao.ItemIndex := I;
    end;
  end;

end;

procedure TForm30.DBGrid1Enter(Sender: TObject);
begin
  // Estoque
  //
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where TIPO_ITEM<>'+QuotedStr('09')+' order by DESCRICAO');  //
  Form7.ibDataSet4.Open;
  //
  Form7.ibDataSet16.Enablecontrols;
  dbGrid3.Visible    := False;
  dBGrid3.Left       := 15;
  dbGrid3.Top        := dbGrid1.Top + dbGrid1.Height -1;
  //
  dbGrid3.Width      := dbGrid1.Width;
  dBGrid3.Height     := Panel1.Height - dbGrid3.Top -15;
  //
  dBGrid3.DataSource                 := Form7.DataSource4;
  dBgrid3.Columns.Items[0].FieldName := 'DESCRICAO';
  dBgrid3.Columns.Items[0].Width     := 335;
  //
  dBgrid3.Columns.Items[1].FieldName := 'QTD_ATUAL';
  dBgrid3.Columns.Items[1].Width     := 77;
  dBgrid3.Columns.Items[1].Visible   := True;
  //
  dBgrid3.Columns.Items[2].FieldName := 'PRECO';
  dBgrid3.Columns.Items[2].Width     := 77;
  dBgrid3.Columns.Items[2].Visible   := True;
  //
  dBgrid3.Columns.Items[3].FieldName := 'LOCAL';
  dBgrid3.Columns.Items[3].Width     := 77;
  dBgrid3.Columns.Items[3].Visible   := True;

  listSituacao.Visible                   := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
end;

procedure TForm30.DBGrid2Enter(Sender: TObject);
begin
  // Autocompletar serviços
  //
  // Sandro Silva 2023-09-28 ListBox22.Visible      := False;
  // Sandro Silva 2023-09-28 ListBox22.Items.Clear;
  //
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' order by DESCRICAO');  //
  Form7.ibDataSet4.Open;

  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select DESCRICAO, PRECO from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' order by DESCRICAO'); // Ok
  Form7.ibDataSet99.Open;

  {Sandro Silva 2023-08-08 inicio
  for I := 1 to 9999 do fPrecoDoServico[I] := 0;
  I := 0;

  if Form7.ibDataSet99.FieldByname('DESCRICAO').AsString <> '' then
  begin
    //
    while not Form7.ibDataSet99.Eof do
    begin
      //
      try
        ListBox2.Items.Add(AllTrim(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString));
        fPrecoDoServico[I] := Form7.ibDataSet99.FieldByname('PRECO').AsFloat;
        I := I + 1;
      except end;
      //
      Form7.ibDataSet99.Next;
      //
    end;
    //
  end;
  }

  {Sandro Silva 2023-09-28 inicio
  SetLength(fPrecoDoServico, 0);

  if Form7.ibDataSet99.FieldByname('DESCRICAO').AsString <> '' then
  begin
    while not Form7.ibDataSet99.Eof do
    begin
      try
        SetLength(fPrecoDoServico, Length(fPrecoDoServico) + 1);
        //ListBox22.Items.Add(AllTrim(Form7.ibDataSet99.FieldByname('DESCRICAO').AsString));
        fPrecoDoServico[High(fPrecoDoServico)] := Form7.ibDataSet99.FieldByname('PRECO').AsFloat;
      except
      end;
      Form7.ibDataSet99.Next;
    end;
  end;
  }

  {Sandro Silva 2023-08-08 fim}
  //
  {Sandro Silva 2023-09-28 inicio
  ListBox22.Left     := 15;
  ListBox22.Top      := dbGrid2.Top + dbGrid2.Height -1;
  ListBox22.Height   := Panel1.Height - ListBox22.Top -17;
  ListBox22.Width    := 305;
  }
  // THE END AUTOCOMPLETAR

  // Técnicos
  if not Form30.dBGrid3.Visible then
    DbGrid2.SelectedIndex := 0;

  dBGrid3.DataSource                 := Form7.DataSource9;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := 110;

  dBGrid3.Left       := 315;
  dbGrid3.Top        := dbGrid2.Top + dbGrid2.Height -1;
  dbGrid3.Width      := 105;

  dBGrid3.Height     := Panel1.Height - dbGrid3.Top -5;

  {Sandro Silva 2023-09-28 inicio
  ListBox1.Visible       := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible       := False;
  Form30.dBGrid3.Visible := False;
  }
  OcultaListaDePesquisa;
end;

procedure TForm30.SMALL_DBEdit2Exit(Sender: TObject);
begin
  Form7.ibDataSet3.Edit;
  Form7.ibDataSet3TECNICO.AsString := Form7.ibDataSet9NOME.AsString;
end;

procedure TForm30.SMALL_DBEdit3Exit(Sender: TObject);
begin
  Form1.bChaveSelecionaCliente := False;

  // CPF/CGC
  if Form7.ibDataSet3CLIENTE.AsString <> Form7.ibDataSet2NOME.AsString then
  begin
    if AllTrim(LimpaNumero(SMALL_DBEDIT3.Text))<>'' then
    begin
      if Length(LimpaNumero(Copy(SMALL_DBEDIT3.Text,1,3)))=3 then
      begin
        if CpfCgc(LimpaNumero(SMALL_DBEDIT3.Text)) then
        begin
          // CAAD9
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEDIT3.Text))))+'');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;

          Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
        end;
      end;
    end;

    // CPF/CGC
    if AllTrim(SMALL_DBEDIT3.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
    begin
      Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
    end;
  end;

  // Teste
  if AllTrim(LimpaNumero(SMALL_DBEdit3.Text))<>'' then
  begin
    if CpfCgc(LimpaNumero(SMALL_DBEdit3.Text)) then
    begin
      // CAAD9
      Form7.ibDataSet99.DisableControls;
      Form7.ibDataSet99.Close;
      Form7.ibDataSet99.SelectSQL.Clear;
      Form7.ibDataSet99.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEdit3.Text))))+'');
      Form7.ibDataSet99.Open;
      //
      Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet99.FieldByname('NOME').AsString;
      //
    end;
  end;

  // CPF/CGC
  if AllTrim(SMALL_DBEdit3.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
  begin
    Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
  end;

  DefinirCorClienteDevedor;
end;

procedure TForm30.DefinirCorClienteDevedor;
begin
  SMALL_DBEdit3.Font.Color := TTestaClienteDevendo.New
                                                  .setDataBase(Form7.IBDatabase1)
                                                  .setCliente(SMALL_DBEdit3.Text)
                                                  .CarregarDados
                                                  .RetornarCor;
end;

procedure TForm30.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Form7.ibDataSet3.Modified then Form7.ibDataSet3.Post;
  Form7.ibDataSet3.Edit;

  Form7.ibDataSet35DESCRICAO.DisplayWidth := 29;
  Form7.ibDataSet35TECNICO.DisplayWidth   := 12;
  Form7.ibDataSet3.EnableControls;

  try
    Form7.Close;
    Form7.Show;
  except
  end;
end;

procedure TForm30.SMALL_DBEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then if dBgrid3.Visible = True then dBgrid3.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then  if dBgrid3.Visible = True then dBgrid3.SetFocus else Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_RETURN then  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then
    if listSituacao.Visible = True then
      listSituacao.SetFocus
    else
      Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then
  begin
    if listSituacao.Visible = True then
      listSituacao.SetFocus
    else
      Perform(Wm_NextDlgCtl,1,0);
  end;
  if Key = VK_RETURN then
  begin
    listSituacao.Visible  := False; // Sandro Silva 2023-10-17
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm30.listSituacaoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    try
      if listSituacao.ItemIndex < 0 then
        listSituacao.ItemIndex := 0;

      {
      if listSituacao.ItemIndex = 0 then
        Form7.ibDataSet3SITUACAO.AsString := 'Agendada';
      if listSituacao.ItemIndex = 1 then
        Form7.ibDataSet3SITUACAO.AsString := 'Aberta';
      if listSituacao.ItemIndex = 2 then
        Form7.ibDataSet3SITUACAO.AsString := 'Fechada';
      Mauricio Parizotto 2023-12-04 }
      Form7.ibDataSet3SITUACAO.AsString := listSituacao.Items[listSituacao.ItemIndex];
      SMALL_DBEdit7.SetFocus;
      Key := VK_SHIFT;
      listSituacao.Visible := False;
    except
    end;
  end;
end;

procedure TForm30.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  // Descriçao dos serviços
  if DbGrid2.SelectedIndex = 0 then
  begin
    if Key <> Chr(13) then
    begin
      framePesquisaServOS.Visible := (AllTrim(Form7.ibDataSet35DESCRICAO.AsString) <> EmptyStr) and (Form7.ibDataSet35.State in [dsEdit, dsInsert]);
      framePesquisaServOS.CarregarServico(Form7.ibDataSet35DESCRICAO.AsString);
    end;
  end
  else
  begin
    framePesquisaServOS.Visible := False;
  end;

  // Técnicos
  if DbGrid2.SelectedIndex = 1 then
  begin
    // Sandro Silva 2023-09-28 ListBox22.Visible  := False;
    if Key <> Chr(13) then
      if not Form30.dBGrid3.Visible then
        Form30.dBGrid3.Visible := True; // Key press serviços

    Form1.bFlag := False;
    Form7.ibDataSet35.Edit;
    Form7.ibDataSet35.UpdateRecord;

    // Tecnicos
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * from VENDEDOR where FUNCAO='+QuotedStr('TECNICO')+' and Upper(NOME) like Upper('+QuotedStr('%'+ AllTrim(Form7.ibDataSet35TECNICO.AsString)+Key +'%')+') order by NOME');
    Form7.IBDataSet99.Open;
    Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    Form7.ibDataSet35.Edit;
  end else
    Form30.dBGrid3.Visible := False;

  if dbGrid1.SelectedField.DataType = ftFloat then
    if Key = chr(46) then
      key := chr(44);
end;

procedure TForm30.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if (Key = VK_TAB) or (Key = VK_ESCAPE) then
    Key := VK_RETURN;
  try
    begin
      if DBGrid2.SelectedIndex = 0 then
      begin
        if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) and (Key <> VK_DELETE) then
        begin
          Form7.bFlag := False;
          Form7.ibDataSet35.Edit;
          Form7.ibDataSet35.UpdateRecord;
          Form7.ibDataSet35.Edit;
          Form7.bFlag := True;

          framePesquisaServOS.Visible := (AllTrim(Form7.ibDataSet35DESCRICAO.AsString) <> EmptyStr) and (Form7.ibDataSet35.State in [dsEdit, dsInsert]);

          framePesquisaServOS.CarregarServico(Form7.ibDataSet35DESCRICAO.AsString);          
        end;
      end;

      if Key = VK_RETURN then
      begin
        // Técnicos
        if AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '' then
        begin
          if Form7.ibDataSet35QUANTIDADE.AsFloat <> 0 then
          begin
            Form7.ibDataSet35.Edit;
            Form7.ibDataSet35.Post;
          end else Perform(Wm_NextDlgCtl,0,0);
        end else
        begin
          if DbGrid2.SelectedIndex = 1 then
          begin
            Form7.ibDataSet9.Locate('NOME',AllTrim(Form7.ibDataSet35TECNICO.AsString),[loCaseInsensitive, loPartialKey]);
            if Pos(AllTrim(Form7.ibDataSet35TECNICO.AsString),Form7.ibDataSet9NOME.AsString) <> 0 then Form7.ibDataSet35TECNICO.AsString := Form7.ibDataSet9NOME.AsString else Form7.ibDataSet35TECNICO.AsString := '';
          end;
          //
          I := dBGrid2.SelectedIndex;
          dBGrid2.SelectedIndex := dBGrid2.SelectedIndex  + 1;
          if I = dBGrid2.SelectedIndex  then
          begin
            dBGrid2.SelectedIndex := 0;
            Form7.ibDataSet35.Next;
            if Form7.ibDataSet35.EOF then Form7.ibDataSet35.Append;
          end;
        end;
      end;
    end;
  except end;
end;

procedure TForm30.AtribuirItemPesquisaServico;
begin
  if allTrim(framePesquisaServOS.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString) <> EmptyStr then
  begin
    Form7.ibDataSet35.Edit;
    Form7.ibDataSet35DESCRICAO.AsString := framePesquisaServOS.dbgItensPesq.DataSource.DataSet.FieldByName('DESCRICAO').AsString;
    Form7.ibDataSet35TOTAL.AsFloat      := framePesquisaServOS.dbgItensPesq.DataSource.DataSet.FieldByName('PRECO').AsFloat;
    Form7.ibDataSet35UNITARIO.AsFloat   := framePesquisaServOS.dbgItensPesq.DataSource.DataSet.FieldByName('PRECO').AsFloat;
    Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
    
    framePesquisaServOS.Visible := False;
    DBGrid2.SetFocus;
  end;
end;

procedure TForm30.DescricaoServicoChange(Sender: TField);
begin
  if Sender = Form7.ibDataSet35DESCRICAO then
  begin
    if (Trim(DBGrid2.DataSource.DataSet.fieldbyname('DESCRICAO').AsString) = EmptyStr) then
    begin
      framePesquisaServOS.Visible := False;
      Exit;
    end;

    framePesquisaServOS.CarregarServico(DBGrid2.DataSource.DataSet.fieldbyname('DESCRICAO').AsString);
  end;
end;

procedure TForm30.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.bFlag := True;

  if (Key = VK_DOWN) or (Key = VK_UP) then
  begin
    if dBgrid3.Visible then
    begin
      dBgrid3.SetFocus;
      Abort;
    end;

    {Sandro Silva 2023-09-28 inicio 
    if ListBox22.Visible then
    begin
      ListBox22.SetFocus;
      Abort;
    end;
    }
    if framePesquisaServOS.Visible then
    begin
      framePesquisaServOS.dbgItensPesq.SetFocus;
      Abort;
    end;
  end;

  if Key = VK_RETURN then
  begin
    // Sistema de procura
    if DbGrid2.SelectedIndex = 0 then
    begin
      if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset35.Edit;
      Form7.ibDataSet35.UpdateRecord;
      if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset35.Edit;

      // Procura produto pelo código
      Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet35DESCRICAO.AsString,[loCaseInsensitive,loPartialKey]);

      if (Form7.ibDataSet35DESCRICAO.AsString <> Form7.ibDataSet4DESCRICAO.AsString) then
      begin
        if (Length(Alltrim(Limpanumero(Form7.ibDataSet35DESCRICAO.AsString))) <= 5) then
        begin
          // Procura por código
          try
            if StrToIntDef(AllTrim(Form7.ibDataSet35DESCRICAO.AsString), 0) <> 0 then
            begin
              Form7.ibDataSet4.Locate('CODIGO',StrZero(StrToIntDef(AllTrim(LimpaNumero(Form7.ibDataSet35DESCRICAO.AsString)), 0),5,0),[loCaseInsensitive,loPartialKey]);
              if Form7.ibDataSet4CODIGO.AsString = StrZero(StrToIntDef(AllTrim(LimpaNumero(Form7.ibDataSet35DESCRICAO.AsString)), 0),5,0) then
              begin
                Form7.ibDataSet35DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;

                if Form7.ibDataSet35QUANTIDADE.AsFloat >= 0 then
                begin
                  Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
                  Form7.ibDataSet35UNITARIO.AsFloat   := Form7.ibDataSet4PRECO.AsFloat;
                end;

                Form7.ibDataSet35.Post;
                Form7.ibDataSet35.Edit;

                Seleciona(True);
                Abort;

              end else
              begin
                Form7.ibDataSet35DESCRICAO.AsString := '';
              end;
            end;
          except end;  
        end;
      end;
    end;
  end;  
end;

procedure TForm30.DBGrid1ColExit(Sender: TObject);
var
  Sreg1 : String;
begin
  if UpperCase(Form1.ConfDuplo) <> 'SIM' then Jatem(Form7.ibDataSet16,Form7.ibDataSet16DESCRICAO,True) else
  begin
    sReg1 := Form7.ibDataSet16.FieldByname('REGISTRO').AsString;
    Form7.ibDataSet16.First;
    Form7.ibDataSet16.Locate('REGISTRO',sREg1,[]);
  end;

  if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '' then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.DBGrid2ColExit(Sender: TObject);
begin
  framePesquisaServOS.Visible := False;
  Form7.ibDataSet35.Edit;
  Form7.ibDataSet35.UpdateRecord;
  if AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = EmptyStr then
    Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  try
    if DbGrid1.SelectedIndex = 0 then
    begin
      if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
      begin
        if not dBGrid3.Visible then dBgrid3.Visible := True;

        if not (Form7.ibDataSet16.State in ([dsEdit, dsInsert])) then
        begin
          Form7.ibDataSet16.Edit;
        end;

        Form1.bFlag := False;
        Form7.ibDataSet16.Edit;
        Form7.ibDataSet16.UpdateRecord;
        Form7.ibDataSet16.Edit;
        Form1.bFlag := True;
      end;
      if Key = VK_DOWN then
        if dBgrid3.CanFocus then
          dBgrid3.SetFocus;
    end;

    if (Key = VK_UP) and (Form7.ibDataSet16.BOF) then dbGrid2.SetFocus;
  except end;
  {Mauricio Parizotto 2023-11-15 Inicio}
  if AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '' then
  begin
    if Form7.ibDataSet16CODIGO.AsString <> Form7.ibDataSet4CODIGO.AsString then
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Text := ' Select * '+
                                         ' From ESTOQUE '+
                                         ' Where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString);
      Form7.ibDataSet4.Open;
    end;
  end;

  MostraFoto;
  {Mauricio Parizotto 2023-11-15 Fim}
end;

procedure TForm30.ListBox2Click(Sender: TObject);
begin
  //
  (*// Sandro Silva 2023-09-28
  if ListBox22.Top < DBGrid1.Top then
  begin
    {Sandro Silva 2023-09-28 inicio
    try
      if ListBox22.Items.Count >= 1 then
      begin
        Form7.ibDataSet3.Edit;
        Form7.ibDataSet3.FieldByName(sDataField).AsString := ListBox22.Items[ListBox22.ItemIndex];
     end;
    except end;
    //
    Perform(Wm_NextDlgCtl,0,0);
    //
    }
  end else
  begin
    {Sandro Silva 2023-09-28 inicio
    try
      if ListBox22.Items.Count >= 1 then
      begin
        Form7.ibDataSet35.Edit;
        Form7.ibDataSet35DESCRICAO.AsString := ListBox22.Items[ListBox22.ItemIndex];
        Form7.ibDataSet35TOTAL.AsFloat      := fPrecoDoServico[ListBox22.ItemIndex];
        Form7.ibDataSet35UNITARIO.AsFloat   := fPrecoDoServico[ListBox22.ItemIndex];
        Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
      end;
    except
    end;
    }
    {Sandro Silva 2023-09-28 inicio
    //
    ListBox22.Visible      := False;
    dbGrid2.SetFocus;
//    DbGrid1.SelectedIndex := DbGrid1.SelectedIndex + 1;
    //
    }
  end;
  //
  *)
end;

procedure TForm30.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_INSERT then
  begin
    PopUpMenu3.Popup(dBGrid1.Left,dBgrid1.Top + 20);
    Key := VK_SHIFT;
    Abort;
  end;

  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  try
    begin
      if Key = VK_RETURN then
      begin
        Form7.ibDataSet16.Edit;

        if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
        begin
          if AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '' then
          begin
            Form7.ibDataSet4.Close;                                                //
            Form7.ibDataSet4.Selectsql.Clear;
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
            Form7.ibDataSet4.Open;
          end;

          if DbGrid1.SelectedIndex = 0 then
          begin
            Form1.bFlag := True;
            Form7.ibDataSet16.Edit;
            if AnsiUpperCase(AllTrim(Form7.ibDataSet16DESCRICAO.AsString)) = Copy(AnsiUpperCase(Form7.ibDataSet4DESCRICAO.AsString),1,Length(AnsiUpperCase(AllTrim(Form7.ibDataSet16DESCRICAO.AsString))))
             then
              Form7.ibDataSet16DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString
            else
              Form7.ibDataSet16DESCRICAO.AsString := ' '+AllTrim(Form7.ibDataSet16DESCRICAO.AsString);
          end;
          I := DbGrid1.SelectedIndex;
          DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
          if I = DbGrid1.SelectedIndex  then
          begin
            DbGrid1.SelectedIndex := 0;
            Form7.ibDataSet16.Next;
            if Form7.ibDataSet16.EOF then
              Form7.ibDataSet16.Append;
          end;
        end else
        begin
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16.Post;
          Perform(Wm_NextDlgCtl,0,0);
        end;
      end;
    end;
  except
  end;

  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '') then DbGrid1.SelectedIndex := 0;
end;

procedure TForm30.DBGrid3DblClick(Sender: TObject);
begin
  Seleciona(True);
end;

procedure TForm30.SMALL_DBEdit11KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Close;
end;


procedure TForm30.FormShow(Sender: TObject);
begin
  framePesquisaServOS.setDataBase(Form7.IBDatabase1);
  Form7.ibDataSet35DESCRICAO.OnChange := DescricaoServicoChange;
  framePesquisaServOS.Height := 136;
  
  DefinirCorClienteDevedor;

  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where Coalesce(Ativo,0)=0 order by upper(NOME)');  //
  Form7.ibDataSet2.Open;

  Form7.ibDataSet35DESCRICAO.DisplayWidth := 35;
  Form7.ibDataSet35TECNICO.DisplayWidth   := 10;

  bProximo := False;
  Form7.ibDataSet3.DisableControls;

  Form7.ibDataSet35TECNICO.Visible := True;

  Form7.ibDataSet9.Active := False;
  Form7.ibDataSet9.Active := True;

  Form7.ibDataSet19.Active     := False;
  Form7.ibDataSet19.Active     := True;

  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString)+' ');  //
  Form7.ibDataSet2.Open;

  SMALL_DBEdit2.SetFocus;
  SMALL_DBEdit2.SelectAll;

  ScrollBox1.VertScrollBar.Position := 1;
  Label25.Caption := 'ORDEM DE SERVIÇO '+Form7.ibDataSet3NUMERO.AsString;

  // Atenção a rotina abaixo altera a quantidade no estoque
  Form7.ibDataSet16.DisableControls;
  Form7.ibDataSet16.First;
  while not Form7.ibDataSet16.Eof do
  begin
    // Procura o produto no estoque
    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then // Resolvi este problema as 4 da madrugada no NoteBook em casa
    begin
      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;

      if (Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (Alltrim(Form7.ibDataSet16CODIGO.AsString)<>'') then
      begin
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet16QUANTIDADE.AsFloat;
        Form7.ibDataSet4.Post;

        Form7.ibDataSet16.Edit;
        Form7.ibDataSet16SINCRONIA.AsFloat := 0;
      end;
    end;

    Form7.ibDataSet16.Next;
  end;

  Form7.ibDataSet16.EnableControls;

  Form7.ibDataSet16UNITARIO.Visible := True;

  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
  Form7.ibDataSet4.Open;

  Form7.ibDataSet3.EnableControls;

  Screen.Cursor := crDefault; // Cursor de Aguardo
end;

procedure TForm30.FormActivate(Sender: TObject);
begin
  Form30.Top     := Form7.Top;
  Form30.Left    := 0;
  Form30.Width   := Form7.Width;
  Form30.Height  := Form7.Height;

  //Mauricio Parizotto 2023-12-05
  CarregaSituacoes;

  // Posiciona na tabéla de CFOP
  Form7.ibDataSet14.Close;
  Form7.ibDataSet14.SelectSQL.Clear;
  Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
  Form7.ibDataSet14.Open;

  // VENDAS
  Form7.ibDataSet15.Close;
  Form7.ibDataSet15.SelectSQL.Clear;
  Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where NUMERONF=''0000000000''');
  Form7.ibDataSet15.Open;

  Form7.ibDataSet16IPI.Visible            := False;
  Form7.ibDataSet16CST_IPI.Visible        := False;
  Form7.ibDataSet16ICM.Visible            := False;
  Form7.ibDataSet16CST_ICMS.Visible       := False;
  Form7.ibDataSet16CFOP.Visible           := False;
  Form7.ibDataSet16VICMS.Visible          := False;
  Form7.ibDataSet16VBC.Visible            := False;
  Form7.ibDataSet16VBCST.Visible          := False;
  Form7.ibDataSet16VICMSST.Visible        := False;
  Form7.ibDataSet16VIPI.Visible           := False;
  Form7.ibDataSet16XPED.Visible           := False;
  Form7.ibDataSet16NITEMPED.Visible       := False;

  Form7.ibDataSet16.EnableControls;

  Form7.ibDataSet16UNITARIO.Visible := True;
  Form7.ibDataSet35UNITARIO.Visible := True;

  fFrameDescricao.TipoDePesquisa  := tpSelect;
  fFrameDescricao.GravarSomenteTextoEncontrato := False;
  fFrameDescricao.CampoCodigo     := Form7.ibDataSet3DESCRICAO;
  fFrameDescricao.sCampoDescricao := 'DESCRICAO';
  fFrameDescricao.sTabela         := 'OS';
  fFrameDescricao.CarregaDescricao;

  fFrameIdentifi1.TipoDePesquisa  := tpSelect;
  fFrameIdentifi1.GravarSomenteTextoEncontrato := False;
  fFrameIdentifi1.CampoCodigo     := Form7.ibDataSet3IDENTIFI1;
  fFrameIdentifi1.sCampoDescricao := 'IDENTIFI1';
  fFrameIdentifi1.sTabela         := 'OS';
  fFrameIdentifi1.CarregaDescricao;

  fFrameIdentifi2.TipoDePesquisa  := tpSelect;
  fFrameIdentifi2.GravarSomenteTextoEncontrato := False;
  fFrameIdentifi2.CampoCodigo     := Form7.ibDataSet3IDENTIFI2;
  fFrameIdentifi2.sCampoDescricao := 'IDENTIFI2';
  fFrameIdentifi2.sTabela         := 'OS';
  fFrameIdentifi2.CarregaDescricao;

  fFrameIdentifi3.TipoDePesquisa  := tpSelect;
  fFrameIdentifi3.GravarSomenteTextoEncontrato := False;
  fFrameIdentifi3.CampoCodigo     := Form7.ibDataSet3IDENTIFI3;
  fFrameIdentifi3.sCampoDescricao := 'IDENTIFI3';
  fFrameIdentifi3.sTabela         := 'OS';
  fFrameIdentifi3.CarregaDescricao;

  fFrameIdentifi4.TipoDePesquisa  := tpSelect;
  fFrameIdentifi4.GravarSomenteTextoEncontrato := False;
  fFrameIdentifi4.CampoCodigo     := Form7.ibDataSet3IDENTIFI4;
  fFrameIdentifi4.sCampoDescricao := 'IDENTIFI4';
  fFrameIdentifi4.sTabela         := 'OS';
  fFrameIdentifi4.CarregaDescricao;
  {Sandro Silva 2023-09-28 fim}

  {Mauricio Parizotto 2023-11-16 Inicio}
  imgFotoProd.Picture := nil;
  imgFotoProd.Visible := False;
  pnlFotoProd.Visible := False;
  // FOTO
  pnlFotoProd.Top    := Panel1.Top;
  pnlFotoProd.Left   := Panel1.Left + Panel1.Width + 5;
  pnlFotoProd.Width  := Screen.Width - pnlFotoProd.Left - 10;
  pnlFotoProd.Height := 300;

  if pnlFotoProd.Width  > 300 then pnlFotoProd.Width := 300;
  if pnlFotoProd.Height > 300 then pnlFotoProd.Height := 300;
  {Mauricio Parizotto 2023-11-16 Fim}
end;

procedure TForm30.DBMemo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
      bProximo := False;
    end
    else
      bProximo := True;
  end
  else
    bProximo := False;
end;

procedure TForm30.DBMemo2Enter(Sender: TObject);
begin
  {Sandro Silva 2023-09-28 inicio
  ListBox1.Visible                   := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
  dbGrid3.Visible := False;
  }
  OcultaListaDePesquisa;
end;

procedure TForm30.DBMemo1Enter(Sender: TObject);
begin
  {Sandro Silva 2023-09-28 inicio
  ListBox1.Visible                   := False;
  // Sandro Silva 2023-09-28 ListBox22.Visible                   := False;
  dbGrid3.Visible := False;
  }
  OcultaListaDePesquisa;  
end;

procedure TForm30.DBMemo1Exit(Sender: TObject);
begin
  Form7.ibDataSet3.Edit;
  Form7.ibDataSet3PROBLEMA.AsString := AllTrimCHR(AllTrimCHR(Alltrim(Form7.ibDataSet3PROBLEMA.AsString),chr(10)),chr(13));
  Form30.DBMemo1.Repaint;
end;

procedure TForm30.Incluirnovoitemnoestoque1Click(Sender: TObject);
begin
  if Form1.imgEstoque.Visible then
  begin
    Form7.ibDataSet3.DisableControls;
    Form7.ibDataSet16.DisableControls;

    try
      Form1.bFechaTudo           := False;
      Form1.imgEstoqueClick(Sender);
      Form7.Close;
      Form7.iKey := 0;
      Form7.ibDataSet4.Append; // Incluir novo item pelo menu estoque
      Form10.ShowModal;
      Form7.sModulo := 'OS';
    except
    end;

    Form1.bFechaTudo           := True;
    Form7.ibDataSet3.EnableControls;
    Form7.ibDataSet16.EnableControls;
  end;
end;

procedure TForm30.Incluirnovocliente1Click(Sender: TObject);
begin
  if Form1.imgEstoque.Visible then
  begin
    Form7.ibDataSet3.DisableControls;
    Form7.ibDataSet16.DisableControls;
    try
      Form1.bFechaTudo           := False;
      Form1.imgCliForClick(Sender);
      Form7.Close;
      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3CLIENTE.AsString := '';
      Form7.ibDataSet3.Post;

      Form7.ibDataSet2.Append;
      Form10.ShowModal;
      Form7.sModulo := 'OS';
    except end;
    Form1.bFechaTudo           := True;
    Form7.ibDataSet3.EnableControls;
    Form7.ibDataSet16.EnableControls;
  end;
end;

procedure TForm30.DBMemo1Change(Sender: TObject);
begin
  try
    //Mauricio Parizotto 2023-11-15
    //if Length(Alltrim(dbMemo1.Text)) >= 128 then
    if Length(Alltrim(dbMemo1.Text)) >= 1000 then
    begin
      //dbMemo1.Text := Copy(dbMemo1.Text,1,128);
      dbMemo1.Text := Copy(dbMemo1.Text,1,1000);
      Perform(Wm_NextDlgCtl,0,0);
    end;
  except
  end;
end;

procedure TForm30.listSituacaoDblClick(Sender: TObject);
begin
  {
  if listSituacao.ItemIndex = 0 then
    Form7.ibDataSet3SITUACAO.AsString := 'Agendada';
  if listSituacao.ItemIndex = 1 then
    Form7.ibDataSet3SITUACAO.AsString := 'Aberta';
  if listSituacao.ItemIndex = 2 then
    Form7.ibDataSet3SITUACAO.AsString := 'Fechada';
  Mauricio Parizotto 2023-12-04}

  Form7.ibDataSet3SITUACAO.AsString := listSituacao.Items[listSituacao.ItemIndex];

  SMALL_DBEdit3.SetFocus;
  listSituacao.Visible := False;
end;

procedure TForm30.Button1Click(Sender: TObject);
begin
  SMALL_DBEdit11.SetFocus;
  Close;
end;

procedure TForm30.Label_fecha_0Click(Sender: TObject);
begin
  Close;
end;

procedure TForm30.DBGrid2ColEnter(Sender: TObject);
begin
  framePesquisaServOS.Visible := False;
end;

procedure TForm30.framePesquisaServOSdbgItensPesqCellClick(
  Column: TColumn);
begin
  AtribuirItemPesquisaServico;
end;

procedure TForm30.framePesquisaServOSdbgItensPesqKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  framePesquisaServOS.dbgItensPesqKeyDown(Sender, Key, Shift);
end;

procedure TForm30.framePesquisaServOSdbgItensPesqKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
    AtribuirItemPesquisaServico;
end;

procedure TForm30.OcultaListaDePesquisa;
begin
  listSituacao.Visible := False;
  dbGrid3.Visible  := False;
end;

procedure TForm30.fFrameIdentifi1txtCampoEnter(Sender: TObject);
begin
  fFrameIdentifi1.txtCampoEnter(Sender);
  OcultaListaDePesquisa;
end;

procedure TForm30.fFrameDescricaotxtCampoEnter(Sender: TObject);
begin
  fFrameDescricao.txtCampoEnter(Sender);
  OcultaListaDePesquisa;
end;

procedure TForm30.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then
    PopUpMenu3.Popup(SMALL_DBEdit3.Left,SMALL_DBEdit3.Top + 20);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('os_cadastro.htm')));
end;

procedure TForm30.fFrameIdentifi2txtCampoEnter(Sender: TObject);
begin
  fFrameIdentifi2.txtCampoEnter(Sender);
  OcultaListaDePesquisa;
end;

procedure TForm30.fFrameIdentifi3txtCampoEnter(Sender: TObject);
begin
  fFrameIdentifi3.txtCampoEnter(Sender);
  OcultaListaDePesquisa;
end;

procedure TForm30.fFrameIdentifi4txtCampoEnter(Sender: TObject);
begin
  fFrameIdentifi4.txtCampoEnter(Sender);
  OcultaListaDePesquisa;
end;

procedure TForm30.fFrameDescricaogdRegistrosDblClick(Sender: TObject);
begin
  fFrameDescricao.gdRegistrosDblClick(Sender);
  Form7.ibDataSet35.Edit;
  Form7.ibDataSet35TOTAL.AsFloat      := TDBGrid(Sender).DataSource.DataSet.FieldByName('TOTAL').AsFloat;//( fPrecoDoServico[ListBox22.ItemIndex];
  Form7.ibDataSet35UNITARIO.AsFloat   := TDBGrid(Sender).DataSource.DataSet.FieldByName('UNITARIO').AsFloat;//fPrecoDoServico[ListBox22.ItemIndex];
  Form7.ibDataSet35QUANTIDADE.AsFloat := 1;

end;

procedure TForm30.SMALL_DBEdit7Exit(Sender: TObject);
begin
  try
    SMALL_DBEdit7.Field.AsString := listSituacao.Items[listSituacao.ItemIndex]; // Sandro Silva 2023-10-17
  except
  end;
end;

procedure TForm30.SMALL_DBEdit7Click(Sender: TObject);
begin
  {Sandro Silva 2023-10-23 inicio}
  //ListBox1.Visible  := True;
  //ListBox1.Height   := 53; // Sandro Silva 2023-10-17   ListBox1.Height   := 41;
  SMALL_DBEdit7.SelectAll;
  {Sandro Silva 2023-10-23 fim}
end;


procedure TForm30.MostraFoto;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
  bMostrarImage: Boolean;
begin
  bMostrarImage := False;
  imgFotoProd.Picture := nil;
  imgFotoProd.Visible := False;
  pnlFotoProd.Visible := False;

  if Form7.ibDataset4FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      try
        jp2.LoadFromStream(BlobStream);
        imgFotoProd.Picture.Assign(jp2);

        if imgFotoProd.Picture.Width > imgFotoProd.Picture.Height then
        begin
          imgFotoProd.Width  := (StrToInt(StrZero((imgFotoProd.Picture.Width * (pnlFotoProd.Width / 2 / imgFotoProd.Picture.Width)),10,0)))*2;
          imgFotoProd.Height := (StrToInt(StrZero((imgFotoProd.Picture.Height* (pnlFotoProd.Width / 2 / imgFotoProd.Picture.Width)),10,0)))*2;
        end else
        begin
          imgFotoProd.Width  := (StrToInt(StrZero((imgFotoProd.Picture.Width * (pnlFotoProd.Height / 2 / imgFotoProd.Picture.Height)),10,0)))*2;
          imgFotoProd.Height := (StrToInt(StrZero((imgFotoProd.Picture.Height* (pnlFotoProd.Height / 2 / imgFotoProd.Picture.Height)),10,0)))*2;
        end;
        imgFotoProd.Left := (pnlFotoProd.Width  - imgFotoProd.Width) div 2;
        imgFotoProd.Top  := (pnlFotoProd.Height - imgFotoProd.Height) div 2;
        imgFotoProd.Repaint;
        pnlFotoProd.Visible := True;
        imgFotoProd.Visible := True;

      except
      end;
    finally
      BlobStream.Free;
      jp2.Free;
    end;
  end;
end;

procedure TForm30.DBGrid3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Mauricio Parizotto 2023-11-15
  MostraFoto;
end;

procedure TForm30.CarregaSituacoes;
var
  IbqSituacao : TIBQuery;
begin
  listSituacao.Items.Clear;
  listSituacao.Items.Add('Agendada');
  listSituacao.Items.Add('Aberta');
  listSituacao.Items.Add('Fechada');

  //Dados do cadastro situação OS
  try
    IbqSituacao := CriaIBQuery(Form7.ibDataSet3.Transaction);
    IbqSituacao.SQL.Text := ' Select SITUACAO '+
                            ' From OSSITUACAO '+
                            ' Order by Upper(SITUACAO)';
    IbqSituacao.Open;

    while not IbqSituacao.Eof do
    begin
      listSituacao.Items.Add(IbqSituacao.FieldByName('SITUACAO').Asstring);
      IbqSituacao.Next;
    end;
  finally
    FreeAndNil(IbqSituacao);
  end;

  //Se tiver excluido ou renomeado uma situação cadastrada
  if listSituacao.Items.IndexOf(Form7.ibDataSet3SITUACAO.AsString) < 0 then
    listSituacao.Items.Add(Form7.ibDataSet3SITUACAO.AsString);

  listSituacao.Sorted := True;
end;

end.







