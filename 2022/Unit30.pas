unit Unit30;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, DBCtrls, SMALL_DBEdit, ShellApi, Grids,
  DBGrids, DB, SmallFunc, IniFiles, htmlHelp, Menus, Buttons;

//  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
//  Forms, Dialogs, Grids, DBGrids, DB, DBibDataSets, ExtCtrls, Menus, Unit9, IniFiles,
//  StdCtrls, Unit10, Unit11, Unit14, Unit16, SmallFunc, Mask, DBCtrls,
//  SMALL_DBEdit, shellapi, Printers, ToolWin, ComCtrls, clipbrd, HtmlHelp;



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
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit14: TSMALL_DBEdit;
    SMALL_DBEdit15: TSMALL_DBEdit;
    SMALL_DBEdit16: TSMALL_DBEdit;
    SMALL_DBEdit17: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    SMALL_DBEdit11: TSMALL_DBEdit;
    DBGrid3: TDBGrid;
    SMALL_DBEdit13: TSMALL_DBEdit;
    ListBox1: TListBox;
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
    procedure FormCreate(Sender: TObject);
    procedure SMALL_DBEdit2Enter(Sender: TObject);
    procedure SMALL_DBEdit6Enter(Sender: TObject);
    procedure SMALL_DBEdit3Change(Sender: TObject);
    procedure SMALL_DBEdit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure ListBox1Click(Sender: TObject);
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
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
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
    procedure SMALL_DBEdit14Enter(Sender: TObject);
    procedure SMALL_DBEdit14Change(Sender: TObject);
    procedure SMALL_DBEdit14Exit(Sender: TObject);
    procedure SMALL_DBEdit14KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure SMALL_DBEdit11KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBMemo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo2Enter(Sender: TObject);
    procedure DBMemo1Enter(Sender: TObject);
    procedure DBMemo1Exit(Sender: TObject);
    procedure Incluirnovoitemnoestoque1Click(Sender: TObject);
    procedure Incluirnovocliente1Click(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label_fecha_0Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    sSistema, sDatafield : String;
    fPrecoDoServico : array[0..99999] of real;
  end;

var
  Form30: TForm30;
  bProximo : Boolean;

implementation

uses Mais, Unit7, Unit12, Unit41, Unit19, Unit22, Unit24, Mais3, preco1,
  Unit10;

{$R *.dfm}

function Seleciona(pP1: Boolean):Boolean;
begin
  with Form30 do
  begin
    //
    // Tecnicos
    //
    if dbGrid3.Top = (SMALL_DBEdit2.Top + SMALL_DBEdit2.Height -1) then
    begin
      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3TECNICO.AsString  := form7.ibDataSet9NOME.AsString;
      SMALL_DBEdit2.SetFocus;
      dBGrid3.Visible := False;
    end;
    //
    // Clientes
    //
    if dbGrid3.Top = (SMALL_DBEdit3.Top + SMALL_DBEdit3.Height -1) then
    begin
      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3CLIENTE.AsString  := form7.ibDataSet2NOME.AsString;
      SMALL_DBEdit3.SetFocus;
      dBGrid3.Visible := False;
    end;
    //
    // Produtos
    //
    if dbGrid3.Top = (dbGrid1.Top + dbGrid1.Height -1) then
    begin
      Form7.ibDataSet16.Edit;
      Form7.ibDataSet16DESCRICAO.AsString  := Form7.ibDataSet4DESCRICAO.AsString;
      dbGrid1.SetFocus;
      dBGrid3.Visible := False;
    end;
    //
    // Tecnicos no grid
    //
    if dbGrid3.Top = (dbGrid2.Top + dbGrid2.Height -1) then
    begin
      Form7.ibDataSet35.Edit;
      Form7.ibDataSet35TECNICO.AsString  := Form7.ibDataSet9NOME.AsString;
      dbGrid2.SetFocus;
      dBGrid3.Visible := False;
    end;
    //
  end;
  //
  Result := True;
  //
end;

procedure TForm30.FormCreate(Sender: TObject);
begin
  //
//  Form30.BorderIcons := [biSystemMenu];
//  Form30.BorderStyle := bsDialog;
  //
end;

procedure TForm30.SMALL_DBEdit2Enter(Sender: TObject);
begin
  //
  // Tecnicos
  //
  dBGrid3.DataSource                 := Form7.DataSource9;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := SMALL_DBEdit2.Width - 21;
  dBGrid3.Visible                    := True;  // SMALL_DBEdit2ENTER
  dBGrid3.Left                       := SMALL_DBEdit2.Left;
  dbGrid3.Top                        := SMALL_DBEdit2.Top + SMALL_DBEdit2.Height -1;
  dbGrid3.Width                      := SMALL_DBEdit2.Width;
  dBGrid3.Height                     := 201;
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
  //
  dBgrid3.Columns.Items[1].FieldName := '';
  dBgrid3.Columns.Items[1].Visible   := False;
  dBgrid3.Columns.Items[2].FieldName := '';
  dBgrid3.Columns.Items[2].Visible   := False;
  dBgrid3.Columns.Items[3].FieldName := '';
  dBgrid3.Columns.Items[3].Visible   := False;
  //
  Form30.SMALL_DBEdit2Change(Sender);
  //
end;

procedure TForm30.SMALL_DBEdit6Enter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;

procedure TForm30.SMALL_DBEdit3Change(Sender: TObject);
begin
  //
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
  end;
  //
  ListBox1.Visible := False;
  //
end;

procedure TForm30.SMALL_DBEdit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then PopUpMenu3.Popup(SMALL_DBEdit3.Left,SMALL_DBEdit3.Top + 20);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('os_cadastro.htm')));
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
    //
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%TECNICO%')+' and Upper(NOME) like '+QuotedStr(UpperCase(SMALL_DBEdit2.Text)+'%')+' order by NOME');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    //
    if not Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]) then
    begin
      //
      Form7.ibDataSet99.Close;
      Form7.ibDataSet99.SelectSQL.Clear;
      Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%TECNICO%')+' and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit2.Text)+'%')+' order by NOME');
      Form7.ibDataSet99.Open;
      Form7.ibDataSet99.First;
      Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
      //
    end;
    //
  end;
end;

procedure TForm30.SMALL_DBEdit3Enter(Sender: TObject);
begin
  //
  // Cliente
  //
  Form1.bChaveSelecionaCliente := True;
  //
  dBGrid3.DataSource                 := Form7.DataSource2;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := SMALL_DBEdit3.Width - 21;
  dBGrid3.Left                       := SMALL_DBEdit3.Left;
  dbGrid3.Top                        := SMALL_DBEdit3.Top + SMALL_DBEdit3.Height -1;
  dbGrid3.Width                      := SMALL_DBEdit3.Width;
  dBGrid3.Height                     := 182;
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
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
  //
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
  dbGrid3.Visible := False;
  //
end;

procedure TForm30.Label15Click(Sender: TObject);
var
  sNome : String;
  SmallIni : tIniFile;
begin
  //
  with Sender as TLabel do
  begin
    //
    sNome   := StrTran(AllTrim(Form1.Small_InputForm('Personalização do sistema','Nome do campo:',Caption)),'','');
    if AllTrim(sNome) <> '' then Caption := sNome else sNome := Caption;
    Repaint;
    //
    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
    SmallIni.WriteString('OS',NAME,sNome);
    SmallIni.Free;
    //
  end;
  //
  Mais.LeLabels(True);
  //
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
  //
  dbGrid3.Visible   := False;
  ListBox1.Visible  := True;
  ListBox1.Height   := 41;
  //
end;

procedure TForm30.ListBox1Click(Sender: TObject);
begin
  //
  //
end;

procedure TForm30.SMALL_DBEdit7Change(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to 2 do
  begin
    if AnsiUpperCase(AllTrim(SMALL_DBEdit7.Text)) = AnSiUpperCase(Copy(ListBox1.Items[i],1,LenGth(AllTrim(SMALL_DBEdit7.Text)))) then ListBox1.ItemIndex := I;
  end;
end;

procedure TForm30.DBGrid1Enter(Sender: TObject);
begin
  //
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
  //
  //
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
  //
end;

procedure TForm30.DBGrid2Enter(Sender: TObject);
var
  I          : Integer;
begin
  //
  // Autocompletar serviços
  //
  ListBox2.Visible      := False;
  ListBox2.Items.Clear;
  //
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' order by DESCRICAO');  //
  Form7.ibDataSet4.Open;
  //
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select DESCRICAO, PRECO from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' order by DESCRICAO'); // Ok
  Form7.ibDataSet99.Open;
  //
  for I := 1 to 9999 do fPrecoDoServico[I] := 0;
  I := 0;
  //
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
  //
  ListBox2.Left     := 15;
  ListBox2.Top      := dbGrid2.Top + dbGrid2.Height -1;
  ListBox2.Height   := Panel1.Height - ListBox2.Top -17;
  ListBox2.Width    := 305;
  //
  // THE END AUTOCOMPLETAR
  //
  // Técnicos
  //
  if not Form30.dBGrid3.Visible then DbGrid2.SelectedIndex := 0;
  //
  dBGrid3.DataSource                 := Form7.DataSource9;
  dBgrid3.Columns.Items[0].FieldName := 'NOME';
  dBgrid3.Columns.Items[0].Width     := 110;
  //
  dBGrid3.Left       := 315;
  dbGrid3.Top        := dbGrid2.Top + dbGrid2.Height -1;
  dbGrid3.Width      := 105;
  //
  dBGrid3.Height     := Panel1.Height - dbGrid3.Top -5;
  //
  ListBox1.Visible       := False;
  ListBox2.Visible       := False;
  Form30.dBGrid3.Visible := False;
  //
end;

procedure TForm30.SMALL_DBEdit2Exit(Sender: TObject);
begin
  Form7.ibDataSet3.Edit;
  Form7.ibDataSet3TECNICO.AsString := Form7.ibDataSet9NOME.AsString;
end;

procedure TForm30.SMALL_DBEdit3Exit(Sender: TObject);
begin
  //
  Form1.bChaveSelecionaCliente := False;

  //
  // teste
  //


  //
  // CPF/CGC
  //
  if Form7.ibDataSet3CLIENTE.AsString <> Form7.ibDataSet2NOME.AsString then
  begin
    //
    if AllTrim(LimpaNumero(SMALL_DBEDIT3.Text))<>'' then
    begin
      //
      if Length(LimpaNumero(Copy(SMALL_DBEDIT3.Text,1,3)))=3 then
      begin
        //
        if CpfCgc(LimpaNumero(SMALL_DBEDIT3.Text)) then
        begin
          //
          // CAAD9
          //
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEDIT3.Text))))+'');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;
          //
          Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
          //
        end;
      end;
    end;
    //
    // CPF/CGC
    //
    if AllTrim(SMALL_DBEDIT3.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
    begin
      Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
    end;
    //
  end;
  //
  // Teste
  //
  if AllTrim(LimpaNumero(SMALL_DBEdit3.Text))<>'' then
  begin
    if CpfCgc(LimpaNumero(SMALL_DBEdit3.Text)) then
    begin
      //
      // CAAD9
      //
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
  //
  // CPF/CGC
  //
  if AllTrim(SMALL_DBEdit3.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
  begin
    Form7.ibDataSet3CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
  end;
  //
end;

procedure TForm30.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  if Form7.ibDataSet3.Modified then Form7.ibDataSet3.Post;
  Form7.ibDataSet3.Edit;

{
  try
    //
    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet4.DisableControls;
    //
    if Form7.ibDataSet3.Modified then Form7.ibDataSet3.Post;
    if AllTrim(Form7.ibDataSet3CLIENTE.AsString) <> '' then
    begin
      //
      // Atenção a rotina abaixo altera a quantidade no estoque
      //
      Form7.ibDataSet16.First;
      while not Form7.ibDataSet16.Eof do
      begin
        //
        // Procura o produto no estoque
        //
        try
          //
          Form7.ibDataSet4.Close;
          Form7.ibDataSet4.Selectsql.Clear;
          Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
          Form7.ibDataSet4.Open;
          //
          if (Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '') then
          begin
            //
            // Atenção a rotina abaixo altera a quantidade no estoque
            //
            Form7.ibDataSet4.Edit;
//            Form7.ibDataSet4QTD_ATUAL.Value      := Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet16QUANTIDADE.AsFloat;
            Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet3DATA.AsDateTime;
            Form7.ibDataSet4.Post;
            //
//            Form7.sModulo := 'FECHAOS';
//            Form7.ibDataSet16.Edit;
//            Form7.ibDataSet16SINCRONIA.AsFloat := Form7.ibDataSet16QUANTIDADE.AsFloat; // Resolvi este problema as 4 da madrugada no NoteBook em casa
            Form7.ibDataSet16.Post;
            //
            // Atenção a rotina acima altera a quantidade no estoque
            //
          end;
          //
        except end;
        //
        Form7.sModulo := 'OS';
        Form7.ibDataSet16.next;
        //
      end;
      //
      Form7.ibDataSet16UNITARIO.Visible := False;
  //    Form7.ibDataSet35UNITARIO.Visible := False;
      //
    end else
    begin
      Form7.ibDataSet3.Delete;
    end;
    //
  except end;
}
  //
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 29;
  Form7.ibDataSet35TECNICO.DisplayWidth   := 12;
  Form7.ibDataSet3.EnableControls;
  //
  try
    Form7.Close;
    Form7.Show;
  except end;
  //
end;

procedure TForm30.SMALL_DBEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then if dBgrid3.Visible = True then dBgrid3.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then  if dBgrid3.Visible = True then dBgrid3.SetFocus else Perform(Wm_NextDlgCtl,-1,0);
  if Key = VK_RETURN then  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then if ListBox1.Visible = True then ListBox1.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then if ListBox1.Visible = True then ListBox1.SetFocus else Perform(Wm_NextDlgCtl,-1,0);
  if Key = VK_RETURN then  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_RETURN then
  begin
    if ListBox1.ItemIndex = 0 then Form7.ibDataSet3SITUACAO.AsString := 'Agendada';
    if ListBox1.ItemIndex = 1 then Form7.ibDataSet3SITUACAO.AsString := 'Aberta';
    if ListBox1.ItemIndex = 2 then Form7.ibDataSet3SITUACAO.AsString := 'Fechada';
    SMALL_DBEdit7.SetFocus;
    Key := VK_SHIFT;
    ListBox1.Visible := False;
  end;
  //
end;

procedure TForm30.DBGrid2KeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  //
  // Descriçao dos serviços
  //
  if DbGrid2.SelectedIndex = 0 then
  begin
    //
    Form1.bFlagControlaLancamentoProduto := False;
    Form7.ibDataSet35.Edit;
    Form7.ibDataSet35.UpdateRecord;
    //
    for I := 0 to ListBox2.Items.Count -1 do
    begin
      if AnsiUpperCase(AllTrim(Form7.ibDataSet35DESCRICAO.AsString)+Key) = AnSiUpperCase(Copy(ListBox2.Items[i],1,LenGth( AllTrim(Form7.ibDataSet35DESCRICAO.AsString)+Key ))) then
        ListBox2.ItemIndex := I;
    end;
    //
    ListBox2.Update;
    //
    if Key <> Chr(13) then
    begin
      if not ListBox2.Visible then
        ListBox2.Visible := True; // Key press produtos
    end else
    begin
{
      if StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString+Key))),5,0) <> '00000' then
      begin
        //
        // Procura apenas pelo CODIGO
        //
        Form7.ibDataSet4.Locate('CODIGO',StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString+Key))),5,0),[loCaseInsensitive,loPartialKey]);
        //
        if Form7.ibDataSet4CODIGO.AsString = StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString+Key))),5,0) then
        begin
          Form7.ibDataSet35DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
          Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
          Form7.ibDataSet35UNITARIO.AsFloat   := Form7.ibDataSet4PRECO.AsFloat;
        end;
      end
}
    end;
    //
  end else ListBox2.Visible  := False;
  //
  // Técnicos
  //
  if DbGrid2.SelectedIndex = 1 then
  begin
    //
    ListBox2.Visible  := False;
    if Key <> Chr(13) then if not Form30.dBGrid3.Visible then Form30.dBGrid3.Visible := True; // Key press serviços
    //
    Form1.bFlagControlaLancamentoProduto := False;
    Form7.ibDataSet35.Edit;
    Form7.ibDataSet35.UpdateRecord;
    //
    // Tecnicos
    //
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * from VENDEDOR where FUNCAO='+QuotedStr('TECNICO')+' and Upper(NOME) like Upper('+QuotedStr('%'+ AllTrim(Form7.ibDataSet35TECNICO.AsString)+Key +'%')+') order by NOME');
    Form7.IBDataSet99.Open;
    Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    Form7.ibDataSet35.Edit;
    //
  end else Form30.dBGrid3.Visible := False;
  //
  if dbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);
  //
end;

procedure TForm30.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  try
    begin
      if Key = VK_RETURN then
      begin
        //
        // Técnicos
        //
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
    //
  except end;
  //
end;

procedure TForm30.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Form1.bFlagControlaLancamentoProduto := True;
  //
  if Key = VK_DOWN   then
  begin
    if dBgrid3.Visible then
    begin
      dBgrid3.SetFocus;
      Abort;
    end;
    if ListBox2.Visible then
    begin
      ListBox2.SetFocus;
      Abort;
    end;
  end;
  //
  if Key = VK_UP then
  begin
    if dBgrid3.Visible then
    begin
      dBgrid3.SetFocus;
      Abort;
    end;
    if ListBox2.Visible then
    begin
      ListBox2.SetFocus;
      Abort;
    end;
  end;
  //
  if Key = VK_RETURN then
  begin
    //
    // Sistema de procura
    //
    if DbGrid2.SelectedIndex = 0 then
    begin
      //
      if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then Form7.ibDataset35.Edit;
      Form7.ibDataSet35.UpdateRecord;
      if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then Form7.ibDataset35.Edit;
      //
      // Procura produto pelo código
      //
      Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet35DESCRICAO.AsString,[loCaseInsensitive,loPartialKey]);
      //
      if (Form7.ibDataSet35DESCRICAO.AsString <> Form7.ibDataSet4DESCRICAO.AsString) then
      begin
        //
        if (Length(Alltrim(Limpanumero(Form7.ibDataSet35DESCRICAO.AsString))) <= 5) then
        begin
          //
          // Procura por código
          //
          try
            // Sandro Silva 2022-09-21 if StrToInt(AllTrim(Form7.ibDataSet35DESCRICAO.AsString)) <> 0 then
            if StrToIntDef(AllTrim(Form7.ibDataSet35DESCRICAO.AsString), 0) <> 0 then
            begin
              //
              // Sandro Silva 2022-09-21 Form7.ibDataSet4.Locate('CODIGO',StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString))),5,0),[loCaseInsensitive,loPartialKey]);
              Form7.ibDataSet4.Locate('CODIGO',StrZero(StrToIntDef(AllTrim(LimpaNumero(Form7.ibDataSet35DESCRICAO.AsString)), 0),5,0),[loCaseInsensitive,loPartialKey]);
              //
              // Sandro Silva 2022-09-21 if Form7.ibDataSet4CODIGO.AsString = StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString))),5,0) then
              if Form7.ibDataSet4CODIGO.AsString = StrZero(StrToIntDef(AllTrim(LimpaNumero(Form7.ibDataSet35DESCRICAO.AsString)), 0),5,0) then
              begin
                //
                Form7.ibDataSet35DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
                //
                if Form7.ibDataSet35QUANTIDADE.AsFloat >= 0 then
                begin
                  Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
                  Form7.ibDataSet35UNITARIO.AsFloat   := Form7.ibDataSet4PRECO.AsFloat;
                end;
                //
                Form7.ibDataSet35.Post;
                Form7.ibDataSet35.Edit;
                //
                //
                Seleciona(True);
                Abort;
                //
                //
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
  //
end;

procedure TForm30.DBGrid1ColExit(Sender: TObject);
var
  Sreg1 : String;
begin
  //
  if UpperCase(Form1.ConfDuplo) <> 'SIM' then Jatem(Form7.ibDataSet16,Form7.ibDataSet16DESCRICAO,True) else
  begin
    sReg1 := Form7.ibDataSet16.FieldByname('REGISTRO').AsString;
    Form7.ibDataSet16.First;
    Form7.ibDataSet16.Locate('REGISTRO',sREg1,[]);
  end;
  //
  if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '' then Perform(Wm_NextDlgCtl,0,0);
  //
end;

procedure TForm30.DBGrid2ColExit(Sender: TObject);
begin
  ListBox2.Visible := False;
  Form7.ibDataSet35.Edit;
  Form7.ibDataSet35.UpdateRecord;
  if AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '' then Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm30.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('os.htm')));
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  //
  try
    if DbGrid1.SelectedIndex = 0 then
    begin
      //
      if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
      begin
        //
        if not dBGrid3.Visible then dBgrid3.Visible := True; //
        //
        if not (Form7.ibDataSet16.State in ([dsEdit, dsInsert])) then
        begin
          Form7.ibDataSet16.Edit;
        end;
{
        Form1.bFlagControlaLancamentoProduto := False;
        Form7.ibDataSet16.UpdateRecord; // Teste 99
        Form1.bFlagControlaLancamentoProduto := True;
}
        //
        Form1.bFlagControlaLancamentoProduto := False;
        Form7.ibDataSet16.Edit;
        Form7.ibDataSet16.UpdateRecord;
        Form7.ibDataSet16.Edit;
        Form1.bFlagControlaLancamentoProduto := True;
        //
      end;
      if Key = VK_DOWN then if dBgrid3.CanFocus then dBgrid3.SetFocus;
      //
    end;
    //
    if (Key = VK_UP) and (Form7.ibDataSet16.BOF) then dbGrid2.SetFocus;
  except end;
  //
end;

procedure TForm30.ListBox2Click(Sender: TObject);
begin
  //
  if ListBox2.Top < DBGrid1.Top then
  begin
    try
      if ListBox2.Items.Count >= 1 then
      begin
        Form7.ibDataSet3.Edit;
        Form7.ibDataSet3.FieldByName(sDataField).AsString := ListBox2.Items[ListBox2.ItemIndex];
     end;
    except end;
    //
    Perform(Wm_NextDlgCtl,0,0);
    //
  end else
  begin
    try
      if ListBox2.Items.Count >= 1 then
      begin
        Form7.ibDataSet35.Edit;
        Form7.ibDataSet35DESCRICAO.AsString := ListBox2.Items[ListBox2.ItemIndex];
        Form7.ibDataSet35TOTAL.AsFloat      := fPrecoDoServico[ListBox2.ItemIndex];
        Form7.ibDataSet35UNITARIO.AsFloat   := fPrecoDoServico[ListBox2.ItemIndex];
        Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
      end;
    except end;
    //
    ListBox2.Visible      := False;
    dbGrid2.SetFocus;
//    DbGrid1.SelectedIndex := DbGrid1.SelectedIndex + 1;
    //
  end;
  //
end;

procedure TForm30.SMALL_DBEdit14Enter(Sender: TObject);
var
  I          : Integer;
  bJatem     : Boolean;
  sRegistro  : String;
begin
  //
  // Autocompletar
  //
  ListBox1.Visible := False;
  dBGrid3.Visible  := False;
  //
  with Sender as TSMALL_DBEdit do
  begin
    //
    sDataField := Datafield;
    ListBox2.Items.Clear;
    ListBox2.TabOrder := TabOrder;
    ListBox2.Visible := False;
    //
    sRegistro := Form7.ibDataSet3REGISTRO.AsString;
    Form7.ibDataSet3.DisableControls;
    Form7.ibDataSet3.Last;
    //
    for I := 1 to 50 do
    begin
      if AllTrim(Form7.ibDataSet3.FieldByname(DATAFIELD).AsString) <> '' then
      begin
        //
        // Percore os itens para ver se já existe
        //
        bJaTem             := False;
        ListBox2.ItemIndex := 0;
        //
        while ListBox2.ItemIndex < ListBox2.Items.Count -1 do
        begin
          if AnsiUpperCase(AllTrim(ListBox2.Items[ListBox2.ItemIndex])) = AnsiUpperCase(AllTrim(Form7.ibDataSet3.FieldByname(DATAFIELD).AsString)) then bJaTem := True;
          ListBox2.ItemIndex := ListBox2.ItemIndex + 1;
          if AnsiUpperCase(AllTrim(ListBox2.Items[ListBox2.ItemIndex])) = AnsiUpperCase(AllTrim(Form7.ibDataSet3.FieldByname(DATAFIELD).AsString)) then bJaTem := True;
        end;
        //
        if not bJatem then ListBox2.Items.Add(AllTrim(Form7.ibDataSet3.FieldByname(DATAFIELD).AsString));
        //
      end;
      Form7.ibDataSet3.MoveBy(-1);
    end;
    //
    Form7.ibDataSet3.Locate('REGISTRO',sRegistro,[]);
    Form7.ibDataSet3.EnableControls;
    //
    ListBox2.Visible  := True;
    ListBox2.Left     := Left;
    ListBox2.Top      := Top + 19;
    ListBox2.Width    := Width;
    ListBox2.Height   := (dbGrid1.Top + dbGrid1.Height) - ListBox2.Top;
    //
  end;
  //
  ListBox1.Visible                   := False;
  dbGrid3.Visible := False;
  //
end;

procedure TForm30.SMALL_DBEdit14Change(Sender: TObject);
var
  I : Integer;
begin
  with Sender as TSMALL_DBEdit do
  begin
    for I := 0 to ListBox2.Items.Count -1 do
    begin
      if AnsiUpperCase(AllTrim(Text)) = AnSiUpperCase(Copy(ListBox2.Items[i],1,LenGth(AllTrim(Text)))) then ListBox2.ItemIndex := I;
    end;
  end;
end;

procedure TForm30.SMALL_DBEdit14Exit(Sender: TObject);
begin
{
  with Sender as TSMALL_DBEdit do
  begin
    if AllTrim(Text) <> '' then
    begin
      try
        if ListBox2.Items.Count >= 1 then
        begin
          if AnsiUpperCase(AllTrim(Text)) = AnsiUpperCase(Copy(ListBox2.Items[ListBox2.ItemIndex],1,LenGth(AllTrim(Text)))) then
          begin
            Form7.ibDataSet3.Edit;
            Form7.ibDataSet3.FieldByName(DATAFIELD).AsString := ListBox2.Items[ListBox2.ItemIndex];
          end;
        end;
      except end;
    end;
  end;
}  
end;

procedure TForm30.SMALL_DBEdit14KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then if ListBox2.Visible = True then ListBox2.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then if ListBox2.Visible = True then ListBox2.SetFocus else Perform(Wm_NextDlgCtl,-1,0);
  if Key = VK_RETURN then
  begin
    ListBox2.TabOrder := 0;
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm30.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_DOWN   then
  begin
    ListBox2.ItemIndex := ListBox2.ItemIndex + 1;
    Abort;
  end;
  if Key = VK_UP     then
  begin
    ListBox2.ItemIndex := ListBox2.ItemIndex - 1;
    Abort;
  end;
  if Key = vK_return then
  begin
    Form30.ListBox2Click(Sender);
  end;
  //
end;

procedure TForm30.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  if Key = VK_INSERT then
  begin
    PopUpMenu3.Popup(dBGrid1.Left,dBgrid1.Top + 20);
    Key := VK_SHIFT;
    Abort;
  end;
  //
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  try
    begin
      if Key = VK_RETURN then
      begin
        //
        Form7.ibDataSet16.Edit;
        //
        if AllTrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
        begin
          //
          if AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '' then
          begin
            Form7.ibDataSet4.Close;                                                //
            Form7.ibDataSet4.Selectsql.Clear;
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
            Form7.ibDataSet4.Open;
          end;
          //
          if DbGrid1.SelectedIndex = 0 then
          begin
            Form1.bFlagControlaLancamentoProduto := True;
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
          //
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16.Post;
          Perform(Wm_NextDlgCtl,0,0);
//         SMALL_DBEdit17.SetFocus;
          SMALL_DBEdit17.SelectAll;
          //
        end;
      end;
    end;
    //
  except end;
  //
  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '') then DbGrid1.SelectedIndex := 0;
  //
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
  //
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where Coalesce(Ativo,0)=0 order by upper(NOME)');  //
  Form7.ibDataSet2.Open;
  //
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 35;
  Form7.ibDataSet35TECNICO.DisplayWidth   := 10;
  //
  bProximo := False;
  Form7.ibDataSet3.DisableControls;
  //
  Form7.ibDataSet35TECNICO.Visible := True;
  //
  Form7.ibDataSet9.Active := False;
  Form7.ibDataSet9.Active := True;
  //
  Form7.ibDataSet19.Active     := False;
  Form7.ibDataSet19.Active     := True;
  //
//  Form30.ScrollBox1.Color := Form7.Color;
//  Form30.Panel2.Color := Form7.Color;
  //
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString)+' ');  //
  Form7.ibDataSet2.Open;
  //
  SMALL_DBEdit2.SetFocus;
  SMALL_DBEdit2.SelectAll;
  //
  ScrollBox1.VertScrollBar.Position := 1;
  Label25.Caption := 'ORDEM DE SERVIÇO '+Form7.ibDataSet3NUMERO.AsString;
  //
  // Atenção a rotina abaixo altera a quantidade no estoque
  //
  Form7.ibDataSet16.DisableControls;
  Form7.ibDataSet16.First;
  while not Form7.ibDataSet16.Eof do
  begin
    //
    // Procura o produto no estoque
    //
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    //
    if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then // Resolvi este problema as 4 da madrugada no NoteBook em casa
    begin
      //
      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
      //
      if (Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (Alltrim(Form7.ibDataSet16CODIGO.AsString)<>'') then
      begin
        Form7.ibDataSet4.Edit;
        Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet16QUANTIDADE.AsFloat;
        Form7.ibDataSet4.Post;
        //                                                                        //
        Form7.ibDataSet16.Edit;                                                       //
        Form7.ibDataSet16SINCRONIA.AsFloat := 0;                                      // Resolvi este problema as 4 da madrugada no NoteBook em casa
        //                                                                        //
      end;
    end;
    //
    Form7.ibDataSet16.Next;
    //
  end;
  //
  Form7.ibDataSet16.EnableControls;
  //
  Form7.ibDataSet16UNITARIO.Visible := True;
//  Form7.ibDataSet35UNITARIO.Visible := True;
  //
//  Label20.Caption := Form7.ibDataSet13NOME.AsString;
//  Label22.Caption := Form7.ibDataSet13CGC.AsString+' IE: '+Form7.ibDataSet13IE.AsString;
//  Label24.Caption := AllTrim(Form7.ibDataSet13ENDERECO.AsString) + ' - ' + AllTrim(Form7.ibDataSet13COMPLE.AsString);
//  Label26.Caption := AllTrim(Form7.ibDataSet13CEP.AsString) + ' ' + AllTrim(Form7.ibDataSet13MUNICIPIO.AsString) + ' - ' + AllTrim(Form7.ibDataSet13ESTADO.AsString);
//  Label28.Caption := AllTrim(Form7.ibDataSet13TELEFO.AsString);
  //
  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
  Form7.ibDataSet4.Open;
  //
  Form7.ibDataSet3.EnableControls;
  //
  Screen.Cursor := crDefault; // Cursor de Aguardo
  //
end;

procedure TForm30.FormActivate(Sender: TObject);
begin
  //
  Form30.Top     := Form7.Top;
  Form30.Left    := 0;
  Form30.Width   := Form7.Width;
  Form30.Height  := Form7.Height;
  //
  // Posiciona na tabéla de CFOP
  //
  Form7.ibDataSet14.Close;
  Form7.ibDataSet14.SelectSQL.Clear;
  Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or  SubString(CFOP from 1 for 1) = '''' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(CFOP,''XXX'') = ''XXX'' order by upper(NOME)');
  Form7.ibDataSet14.Open;
  //
  // VENDAS
  //
  Form7.ibDataSet15.Close;
  Form7.ibDataSet15.SelectSQL.Clear;
  Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where NUMERONF=''0000000000''');
  Form7.ibDataSet15.Open;
  //
  //
  //
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
  //
  //
  //
  Form7.ibDataSet16.EnableControls;
  //
  Form7.ibDataSet16UNITARIO.Visible := True;
  Form7.ibDataSet35UNITARIO.Visible := True;
  //
end;

procedure TForm30.DBMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_DOWN   then if ListBox2.Visible = True then ListBox2.SetFocus else Perform(Wm_NextDlgCtl,0,0);
//  if Key = VK_UP     then if ListBox2.Visible = True then ListBox2.SetFocus else Perform(Wm_NextDlgCtl,-1,0);
end;

procedure TForm30.DBMemo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('os_cadastro.htm')));
  if Key = VK_RETURN then
  begin
    if bProximo then
    begin
      Perform(Wm_NextDlgCtl,0,0);
      bProximo := False;
    end else bProximo := True;
  end else bProximo := False;
  //
  //
end;

procedure TForm30.DBMemo2Enter(Sender: TObject);
begin
  //
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
  dbGrid3.Visible := False;
  //
end;

procedure TForm30.DBMemo1Enter(Sender: TObject);
begin
  //
  ListBox1.Visible                   := False;
  ListBox2.Visible                   := False;
  dbGrid3.Visible := False;
  //
end;

procedure TForm30.DBMemo1Exit(Sender: TObject);
begin
  //
  Form7.ibDataSet3.Edit;
  Form7.ibDataSet3PROBLEMA.AsString := AllTrimCHR(AllTrimCHR(Alltrim(Form7.ibDataSet3PROBLEMA.AsString),chr(10)),chr(13));
  Form30.DBMemo1.Repaint;
  //
//  Form7.ibDataSet3.Post;
//  Form7.ibDataSet3.Edit;
//  Form30.DBMemo1.Update;

end;

procedure TForm30.Incluirnovoitemnoestoque1Click(Sender: TObject);
begin
  if Form1.Image202.Visible then
  begin
    //
    Form7.ibDataSet3.DisableControls;
    Form7.ibDataSet16.DisableControls;
    //
    try
      Form1.bFechaTudo           := False;
      Form1.Image202Click(Sender);
      Form7.Close;
      Form7.iKey := 0;
      Form7.ibDataSet4.Append; // Incluir novo item pelo menu estoque
      Form10.ShowModal;
      Form7.sModulo := 'OS';
    except end;
    //
    Form1.bFechaTudo           := True;
    Form7.ibDataSet3.EnableControls;
    Form7.ibDataSet16.EnableControls;
  end;
end;

procedure TForm30.Incluirnovocliente1Click(Sender: TObject);
begin
  if Form1.Image202.Visible then
  begin
    Form7.ibDataSet3.DisableControls;
    Form7.ibDataSet16.DisableControls;
    try
      Form1.bFechaTudo           := False;
      Form1.Image203Click(Sender);
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
    if Length(Alltrim(dbMemo1.Text)) >= 128 then
    begin
      dbMemo1.Text := Copy(dbMemo1.Text,1,128);
      Perform(Wm_NextDlgCtl,0,0);
    end;
  except end;
end;

procedure TForm30.ListBox1DblClick(Sender: TObject);
begin
  //
  if ListBox1.ItemIndex = 0 then Form7.ibDataSet3SITUACAO.AsString := 'Agendada';
  if ListBox1.ItemIndex = 1 then Form7.ibDataSet3SITUACAO.AsString := 'Aberta';
  if ListBox1.ItemIndex = 2 then Form7.ibDataSet3SITUACAO.AsString := 'Fechada';
  //
  SMALL_DBEdit3.SetFocus;
  ListBox1.Visible := False;
  //
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

end.







