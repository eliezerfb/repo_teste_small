unit Unit48;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls, Mask,
  DBCtrls, SMALL_DBEdit, SmallFunc, Menus, IniFiles, shellapi, Buttons, HtmlHelp, jpeg;

function Retributa(pP1:Boolean):Boolean;
function ApagaIntegracaoComOCaixa(pP1:Boolean):Boolean;

type 
    TForm48 = class(TForm)
    Label44: TLabel;
    Label55: TLabel;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label65: TLabel;
    Label9: TLabel;
    SMALL_DBEdit43: TSMALL_DBEdit;
    Label8: TLabel;
    Label11: TLabel;
    SMALL_DBEdit39: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    DBGrid2: TDBGrid;
    Label30: TLabel;
    SMALL_DBEdit18: TSMALL_DBEdit;
    Label1: TLabel;
    SMALL_DBEdit19: TSMALL_DBEdit;
    Label38: TLabel;
    SMALL_DBEdit16: TSMALL_DBEdit;
    Label5: TLabel;
    PopupMenu3: TPopupMenu;
    Importaroramentos1: TMenuItem;
    ImportarOS2: TMenuItem;
    Label71: TLabel;
    DBGrid4: TDBGrid;
    Label6: TLabel;
    Label57: TLabel;
    Label59: TLabel;
    Label69: TLabel;
    Panel6: TPanel;
    Button1: TBitBtn;
    Label62: TLabel;
    DBMemo1: TDBMemo;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Label2: TLabel;
    Label3: TLabel;
    SMALL_DBEdit40: TSMALL_DBEdit;
    DBGrid1: TDBGrid;
    Imagefixa: TImage;
    DBGrid3: TDBGrid;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button3: TBitBtn;
    SMALL_DBEdit3: TSMALL_DBEdit;
    Label4: TLabel;
    procedure DBLookupComboBox2Exit(Sender: TObject);
    procedure SMALL_DBEdit39Exit(Sender: TObject);
    procedure SMALL_DBEdit39Change(Sender: TObject);
    procedure SMALL_DBEdit39Enter(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit43Change(Sender: TObject);
    procedure SMALL_DBEdit43Enter(Sender: TObject);
    procedure SMALL_DBEdit43Exit(Sender: TObject);
    procedure SMALL_DBEdit48Enter(Sender: TObject);
    procedure SMALL_DBEdit52KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2Exit(Sender: TObject);
    procedure SMALL_DBEdit4Exit(Sender: TObject);
    procedure SMALL_DBEdit13Exit(Sender: TObject);
    procedure SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ImportarOS2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid4KeyPress(Sender: TObject; var Key: Char);
    procedure Importaroramentos1Click(Sender: TObject);
    procedure Label28Click(Sender: TObject);
    procedure Label28MouseLeave(Sender: TObject);
    procedure Label28MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid4Enter(Sender: TObject);
    procedure DBGrid4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid4ColEnter(Sender: TObject);
    procedure Button2Enter(Sender: TObject);
    procedure DBMemo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit39KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure SMALL_DBEdit40Enter(Sender: TObject);
    procedure SMALL_DBEdit40Exit(Sender: TObject);
    procedure SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit2Enter(Sender: TObject);
    procedure SMALL_DBEdit40Change(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SMALL_DBEdit3Enter(Sender: TObject);

  private
    { Private declarations }
    procedure RecalcularIssDosItens;
  public
    fVelho      : Real;
    sOperacaoAntiga, sObservacaoAntiga, sSistema, sNovoNumero : String;
    bOk         : Boolean;
    fPrecoDoServico : array[0..99999] of real;
    { Public declarations }
  end;

var
  Form48: TForm48;
  MyBookmark: TBookmark;

implementation

uses Unit7, Unit10, Mais, Unit18, Unit41, Unit43, Unit19,
  Unit24;


function ApagaAsDuplicatasAnteriores(pP1:Boolean):Boolean;
begin
  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    if Form7.ibDataSet7NUMERONF.AsString = Form7.ibDataSet15NUMERONF.AsString then Form7.ibDataSet7.Delete else Form7.ibDataSet7.Next;
  end;

  Result := True;
end;

function ApagaIntegracaoComOCaixa(pP1:Boolean):Boolean;
begin
  // Apaga lançamento anterior no livro caixa
  Form7.ibDataSet100.Close;
  Form7.ibDataSet100.SelectSQL.Clear;
  Form7.ibDataSet100.SelectSQL.Add('delete from CAIXA where substring(HISTORICO from 1 for 22)='+QuotedStr('Nota Fiscal: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9))+' and DATA = '+QuotedStr(DateToStrInvertida(Form7.ibDataSet15EMISSAO.AsDateTime))+' ');
  Form7.IBDataSet100.Open;

  Result := True;
end;

function Retributa(pP1:Boolean):Boolean;
var
  sReg16 : String;
begin
  Form7.sModulo := 'RETRIBUTA';
  
  try
{
    Form7.ibQuery1.Close;
    Form7.ibQuery1.SQL.Clear;
    Form7.ibQuery1.SQL.Add('select sum(TOTAL) from ITENS001 where NUMERONF='+QuotedStr(Form7.IbDAtaSet15NUMERONF.AsString)+' ');
    Form7.ibQuery1.Open;
    //
    if Form7.IBQuery1.FieldByName('SUM').AsFloat <> Form7.IbDAtaSet15MERCADORIA.AsFloat then
    //
    // Desempenho nota
    //
}
    begin
      sReg16 := Form7.ibDataSet16REGISTRO.AsString;
      Form7.ibDataSet16.DisableControls;

      if Form7.ibDataSet16.Modified then Form7.ibDataSet16.Post;

      Form7.ibDataSet16.First;
      while not Form7.ibDataSet16.EOF do // Disable
      begin
        Form1.bFlag := True; 
        Form7.ibDataSet16DESCRICAOChange(Form7.ibDataSet16DESCRICAO);
        Form7.ibDataSet16.Next;
      end;

      Form7.ibDataSet16.Locate('REGISTRO',sReg16,[]);
    end;
  except
  end;

  Form7.ibDataSet16.Edit;

  // não voltar Form7.ibDataSet16.EnableControls;  // Retributa
  Form7.sModulo := 'VENDA';

  Result := True;
end;


{$R *.DFM}

procedure TForm48.DBLookupComboBox2Exit(Sender: TObject);
begin
  try
    Form7.ibDataSet15.Edit;
    Form7.ibDataSet15.Post;
    Form7.ibDataSet18.Edit;
  except end;
end;

procedure TForm48.SMALL_DBEdit39Exit(Sender: TObject);
begin
  Form1.bChaveSelecionaCliente := False;
  // CPF/CGC
  if Form7.ibDataSet15CLIENTE.AsString <> Form7.ibDataSet2NOME.AsString then
  begin 
    if AllTrim(LimpaNumero(SMALL_DBEdit39.Text))<>'' then
    begin
      if Length(LimpaNumero(Copy(SMALL_DBEdit39.Text,1,3)))=3 then
      begin
        if CpfCgc(LimpaNumero(SMALL_DBEdit39.Text)) then
        begin
          // CAAD9
          Form7.ibDataSet2.DisableControls;
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.SelectSQL.Clear;
          Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEdit39.Text))))+'');
          Form7.ibDataSet2.Open;
          Form7.ibDataSet2.EnableControls;

          // ShowMessage(Form7.ibDataSet2NOME.AsString);
          Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
        end;
      end;
    end;

    // CPF/CGC
    if AllTrim(SMALL_DBEdit39.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
    begin
      Form7.ibDataSet15CLIENTE.AsString := Form7.ibDataSet2NOME.AsString;
    end;

    try
      Form7.ibDataSet15TOTALChange(Form7.ibDataSet15TOTAL);
    except end;

    Retributa(True);
    if form7.ibDataSet16.Modified then
      Form7.ibDataset16.Post;
  end;

  // Cliente atrasado em vermelho
  if Form7.ibDataSet2MOSTRAR.AsString = '1' then SMALL_DBEdit39.Font.Color := clRed else SMALL_DBEdit39.Font.Color := clBlack;

  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    if (Form7.ibDataSet7NOME.AsString <> Form7.IBDataSet2NOME.AsString) and (Form7.ibDataSet7NUMERONF.AsString = Form7.ibDataSet15NUMERONF.AsString) then
    begin
      Form7.ibDataSet7.Edit;
      Form7.ibDataSet7NOME.AsString := Form7.IBDataSet2NOME.AsString;
      Form7.ibDataSet7.Post;
    end;
    Form7.ibDataSet7.Next;
  end;
  
  // Cliente atrasado em vermelho
  Form7.ibDataSet16.EnableControls;
end;

procedure TForm48.SMALL_DBEdit39Change(Sender: TObject);
begin
  if (Form48.Visible) and (Form7.ibDataSet2.Active) then
  begin
    if Form1.bChaveSelecionaCliente then
    begin
      dBGrid2.Visible    := True;
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.SelectSQL.Clear;
      Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit39.Text)+'%')+' and coalesce(ATIVO,0)=0 order by NOME');
      Form7.ibDataSet2.Open;
      dBGrid2.Repaint;
    end;
  end;
end;

procedure TForm48.SMALL_DBEdit39Enter(Sender: TObject);
begin
  Form1.bChaveSelecionaCliente := True;

  dBGrid2.DataSource := Form7.DataSource2;
  dBGrid2.Visible    := False;

  dBGrid2.Left       := SMALL_DBEdit39.Left;
  dbGrid2.Top        := SMALL_DBEdit39.Top + SMALL_DBEdit39.Height -1;
  dbGrid2.Width      := SMALL_DBEdit39.Width;
  dBGrid2.Height     := 225; // Panel1.Height - dbGrid2.Top - 20;

  dbGrid2.Columns[0].Width := dbGrid2.Width - 30;
  dbGrid2.Columns[0].Width := 250;
  dbGrid2.Columns[1].Visible := False;
  
  SMALL_DBEdit39.SelectAll;
end;

procedure TForm48.DBGrid2DblClick(Sender: TObject);
begin
  Form7.ibDataSet15.Edit;
  Form7.ibDataSet15OPERACAO.AsString   := form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet15CLIENTE.AsString    := form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet15TRANSPORTA.AsString := form7.ibDataSet18NOME.AsString;
  Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;
  if dbGrid2.Top = (SMALL_DBEdit39.Top + SMALL_DBEdit39.Height -1) then SMALL_DBEdit39.SetFocus;
  if dbGrid2.Top = (SMALL_DBEdit43.Top + SMALL_DBEdit43.Height -1) then SMALL_DBEdit43.SetFocus;
  dBGrid2.Visible := False;
  
  RecalcularIssDosItens;// Sandro Silva 2022-09-22
end;

procedure TForm48.DBGrid2CellClick(Column: TColumn);
begin
  Form7.ibDataSet15.Edit;
  Form7.ibDataSet15OPERACAO.AsString   := Form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet15CLIENTE.AsString    := Form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet15TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
  Form7.ibDataSet15VENDEDOR.AsString   := Form7.ibDataSet9NOME.AsString;
end;

procedure TForm48.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    Form48.DBGrid2DblClick(Sender);
  end;
end;

procedure TForm48.SMALL_DBEdit43Change(Sender: TObject);
begin
  if (Form48.Visible) and (Form7.ibDataSet9.Active) then
  begin
    if not dBGrid2.Visible then
      SMALL_DBEdit43Enter(Sender);
    
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM VENDEDOR where FUNCAO like '+QuotedStr('%VENDEDOR%')+' and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit43.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet9.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TForm48.SMALL_DBEdit43Enter(Sender: TObject);
begin
  Form7.ibDataSet15.Enablecontrols;
  if Form7.sModulo <> 'RETRIBUTA' then
    Form7.ibDataSet16.EnableControls;
  
  dBGrid2.Visible := False;

  // Vendedores
  dBGrid2.DataSource         := Form7.DataSource9;
  dBGrid2.Visible            := True;
  dBGrid2.Left               := SMALL_DBEdit43.Left;
  dbGrid2.Top                := SMALL_DBEdit43.Top + SMALL_DBEdit43.Height -1;
  dbGrid2.Width              := SMALL_DBEdit43.Width;
  dBGrid2.Height             := 161; //Panel1.Height - dbGrid2.Top - 20;

  dbGrid2.Columns[0].Width   := SMALL_DBEdit43.Width -10;
  dbGrid2.Columns[1].Visible := False;

  SMALL_DBEdit43.SelectAll;
end;

procedure TForm48.SMALL_DBEdit43Exit(Sender: TObject);
begin
  if SMALL_DBEdit43.Text <> '' then
  begin
    if Pos( AnsiUpperCase(SMALL_DBEdit43.Text), AnsiUpperCase(AllTrim(Form7.ibDataSet9NOME.AsString))) <> 0 then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15VENDEDOR.AsString := Form7.ibDataSet9NOME.AsString;
    end else
    begin
      if SMALL_DBEdit43.CanFocus then SMALL_DBEdit43.SetFocus;
    end;
  end;
end;

procedure TForm48.SMALL_DBEdit48Enter(Sender: TObject);
begin
  dbGrid3.Visible := False;
  DbGrid2.Visible := False;
end;

procedure TForm48.SMALL_DBEdit52KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_TAB    then Perform(Wm_NextDlgCtl,1,0);
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,-1,0);
end;

procedure TForm48.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then
    Key := 0;
end;

procedure TForm48.DBGrid2Exit(Sender: TObject);
begin
  if (dbGrid2.Top = SMALL_DBEdit39.Top + SMALL_DBEdit39.Height) then
    SMALL_DBEdit39.SetFocus;
end;

procedure TForm48.SMALL_DBEdit4Exit(Sender: TObject);
begin
  Retributa(True);
end;

procedure TForm48.SMALL_DBEdit13Exit(Sender: TObject);
begin
  Retributa(True);
  if form7.ibDataSet16.Modified then Form7.ibDataSet16.Post;
end;

procedure TForm48.SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1     then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nfse_sobre.htm')));
  if Key = VK_INSERT then
  begin
    PopUpMenu3.Popup(SMALL_DBEdit39.Left,SMALL_DBEdit39.Top + 20);
  end;
end;

procedure TForm48.SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1     then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nfse_sobre.htm')));
end;

procedure TForm48.Button1Enter(Sender: TObject);
begin
  dbGrid3.Visible := False;
  ScrollBox1.VertScrollBar.Position := 200;
end;

procedure TForm48.Button1Click(Sender: TObject);
begin
  bOk := True;
  Form48.Close;
end;

procedure TForm48.ImportarOS2Click(Sender: TObject);
begin
  // Atualiza as ECF's que estão em uso
  Form7.sModulo := 'OS';
  Form41.ShowModal;
  Form7.sModulo := 'VENDA';
end;

procedure TForm48.FormShow(Sender: TObject);
begin
  Form48.Tag := 1;

  Form48.ActiveControl := Nil;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  if not Form7.ibDAtaSet18.Active then
    Form7.ibDAtaSet18.Active := True;

  Form7.ibDataSet16.DisableControls;
  Form7.ibDataSet14.DisableControls;
  Form7.ibDataSet15.DisableControls;
  Form7.ibDataSet35.DisableControls;
  Form7.ibDataSet2.DisableControls;

  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
  Form7.ibDataSet2.Open;

  if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset15.Edit;

  if Right(Form7.sTitulo,3) = 'RPS' then
  begin
    Form7.ibDataSet15MODELO.Value        := 'SV';
    Form7.ibDataset15.Post;
    Form7.ibDataset15.Edit;
  end;

  Form7.ibDataSet2.EnableControls;

  bOk := False;

  Label71.Caption := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3);

  Panel1.Left     := 10; // (ScrollBox1.Width - Panel1.Width) div 2;
  Panel6.Left     := 5;
  Panel6.Top      := Panel1.Top + Panel1.Height + 5;

  try
    // se n tem vendedores cadastrados se não tiver n pede
    Form7.ibDataSet9.DisableControls;
    Form7.ibDataSet9.First;
    while not Form7.ibDataSet9.EOF do
    begin
      if AllTrim(form7.ibDataSet9NOME.AsString) <> '' then
      begin
        SMALL_DBEdit43.Visible := True;
        Label9.Visible     := True;
      end;
      Form7.ibDataSet9.Next;
    end;
    Form7.ibDataSet9.EnableControls;
    
    dBGrid2.Visible := False;
  except
    Form48.Close;
  end;

  Form7.sModulo := 'VENDA';

  // Relaciona a natureza da operação com o arquivo de vendas
  if AllTrim(Form7.ibDataSet15OPERACAO.AsString) = '' then
    Form7.ibDataSet14.Append
  else
    Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

  // Relaciona os clientes com o arquivo de vendas                     
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' '); 
  Form7.ibDataSet2.Open;

  Form7.ibDataSet9.Locate('NOME',Form7.ibDataSet15VENDEDOR.AsString,[]);

  // Abre o arquivo de clientes para edição
  if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) or (Form1.iReduzida = 2)  then
  begin
    // Atenção a rotina abaixo altera a quantidade no estoque
    Screen.Cursor := crHourGlass; // Cursor de Aguardo

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.Eof do // disable
    begin
      // Procura o produto no estoque

      Screen.Cursor := crHourGlass; // Cursor de Aguardo

      Form7.ibDataSet4.Close;                                                
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
      Form7.ibDataSet4.Open;

      if (Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet16CODIGO.AsString)<>'') then
      begin
        if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then    // Resolvi este problema as 4 da madrugada no NoteBook em casa
        begin
          try
            if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
            begin
              if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
              begin
                Screen.Cursor := crHourGlass; // Cursor de Aguardo
                Form7.ibDataSet4.Edit;
                Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet16QUANTIDADE.AsFloat; // Retorna a quantidade ao estoque quando entra na NF
                Form7.ibDataSet4.Edit;
                Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                Form7.ibDataSet4.Post;
                Screen.Cursor := crHourGlass; // Cursor de Aguardo
              end;
            end;

            Form7.sModulo := 'NAO';
            Form7.ibDataSet16.Edit;                                                     
            Form7.ibDataSet16SINCRONIA.AsFloat := 0;                                    // Resolvi este problema as 4 da madrugada no NoteBook em casa
          except
          end;
        end;
      end;
      Form7.ibDataSet16.Next;
    end;

    Form7.sModulo := 'VENDA';

    // DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
    // ShowMessage('Form Show em: '+TimeToStr(Time - tInicio)+','+StrZero(cent,3,0));
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.Selectsql.Clear;
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
    Form7.ibDataSet4.Open;

    if Form7.sModulo <> 'RETRIBUTA' then
      Form7.ibDataSet16.EnableControls;

    // Atenção a rotina acima altera a quantidade no estoque
  end;

  Form7.sModulo := 'VENDA';

  Form7.ibDataSet14.EnableControls;
  Form7.ibDataSet15.EnableControls;
  Form7.ibDataSet35.EnableControls;
  Form7.ibDataSet2.EnableControls;

  // Foco no vendedor ou no cliente
  ScrollBox1.VertScrollBar.Position := 1;

  // Altera o Grid de mercadorias para mostrar na NF

  // Lay-Out no form7
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 50;
  Form7.ibDataSet35TECNICO.Visible        := False;

  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.SelectSQL.Clear;
  Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' and Coalesce(Ativo,0)=0 order by DESCRICAO'); // Ok
  Form7.ibDataSet4.Open;

  Screen.Cursor := crDefault; // Cursor de Aguardo
end;

procedure TForm48.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini: TIniFile;
begin
  try
    Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet4.DisableControls;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet15.DisableControls;
    Form48.Hide;

    Form7.sModulo := 'RETRIBUTA';

    {Sandro Silva 2022-09-23 inicio}
    // Teste na Small, importando Orçamento, não está gravando ISS e BASEISS em ITENS003
    if Form7.ibDataSet15MODELO.AsString = 'SV' then
      RecalcularIssDosItens; // Sandro Silva 2022-09-22
    {Sandro Silva 2022-09-23 fim}

    if Form7.ibDataSet15.Modified then
      Form7.ibDataSet15.Post;

    if (AllTrim(Form7.ibDataSet15CLIENTE.AsString)) <> '' then
    begin
      if ((Form7.ibDataSet13ESTADO.AsString <> 'SC') and (Form7.ibDataSet13ESTADO.AsString <> 'MG')) or (Form1.iReduzida = 2)  then
      begin
        // Atenção a rotina abaixo altera a quantidade no estoque
        Form7.ibDataSet16.DisableControls;
        Form7.ibDataSet16.First;
        while not Form7.ibDataSet16.Eof do // disable
        begin
          // Procura o produto no estoque
          try
            Form7.ibDataSet4.Close;
            Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
            Form7.ibDataSet4.Open;

            if Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            begin
              if Form7.ibDataSet16SINCRONIA.AsFloat <> Form7.ibDataSet16QUANTIDADE.AsFloat then
              begin
                if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
                begin
                  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
                  begin
                    Form7.ibDataSet4.Edit;
                    Form7.ibDataSet4QTD_ATUAL.AsFloat    := Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet16QUANTIDADE.AsFloat; // Baixa a quantidade no estoque quando fecha a NF
                    Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                    Form7.ibDataSet4.Post;
                  end;
                end;

                Form7.sModulo := 'FECHAVENDA';
                Form7.ibDataSet16.Edit;
                Form7.ibDataSet16SINCRONIA.AsFloat := Form7.ibDataSet16QUANTIDADE.AsFloat; // Resolvi este problema as 4 da madrugada no NoteBook em casa
                Form7.ibDataSet16.Post;
              end;
            end;
          except
          end;

          Form7.sModulo := 'VENDA';
          Form7.ibDataSet16.Next;
        end;
        // Atenção a rotina acima altera a quantidade no estoque
      end;

      // Desdobramento das duplicatas
      Form7.sModulo := 'VENDA';
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);

      ApagaIntegracaoComOCaixa(True);

      if (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString),1,7) = 'RECEBER') and (Form7.ibDataSet15TOTAL.AsFloat > 0) then
      begin
        Form18.ShowModal;
      end else
      begin
        ApagaAsDuplicatasAnteriores(True);
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 0;
        Form7.ibDataSet15.Post;

        Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
        if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
          Form18.CheckBox1.Checked := True
        else
          Form18.CheckBox1.Checked := False;
        Mais1Ini.Free;

        if Form18.CheckBox1.Checked then
        begin
          Form7.bProximas := True;
          Form7.N6EnviarNFeConsultareImprimirDANFE1Click(Sender);
          Form7.bProximas := False;
        end;
      end;
    end else
    begin
      // Se o cliente estiver em branco apaga
      Form7.ibDataSet15.Delete;
    end;
  except
  end;

  // Lay-Out no form7
  Form7.ibDataSet16UNITARIO.Visible       := False;
  Form7.ibDataSet16CFOP.Visible           := False;
  Form7.ibDataSet16XPED.Visible           := False;
  Form7.ibDataSet16NITEMPED.Visible       := False;
  Form7.ibDataSet16DESCRICAO.DisplayWidth := 41;
  Form7.ibDataSet35DESCRICAO.DisplayWidth := 29;
  Form7.ibDataSet35TECNICO.Visible        := True;
  //    Form7.ibDataSet35UNITARIO.Visible       := False;

  Form7.ibDataSet4.Close;
  Form7.ibDataSet4.Selectsql.Clear;
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
  Form7.ibDataSet4.Open;

  Form7.sModulo := 'VENDA';

  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet4.EnableControls;
  Form7.ibDataSet14.EnableControls;
  Form7.ibDataSet15.EnableControls;

  BaixaEstoqueDaNFeAutorizada('');

  Form7.Close;
  Form7.Show;

  // Para atender o PAF
  if ParamCount > 0 then
  begin
    if AllTrim(Copy(UpperCase(ParamStr(1)),1,3)) = 'URB' then
    begin
//      Form1.Close;
    end;
  end;

  Form1.ConfEspecie := Form7.ibDataSet15ESPECIE.AsString;
  Form1.ConfMarca   := Form7.ibDataSet15MARCA.AsString;

  // Apaga ítens em branco
  try
    Form7.IBQuery99.Close;
    Form7.IBQuery99.SQL.Clear;
    Form7.IBQuery99.SQL.Add('delete from ITENS001 where Coalesce(DESCRICAO,'''')='+QuotedStr('')+'');
    Form7.IBQuery99.Open;
  except
  end;
end;


procedure TForm48.DBGrid4KeyPress(Sender: TObject; var Key: Char);
begin
  if DbGrid4.SelectedIndex = 0 then
  begin
    if not dbGrid3.Visible then
      dbGrid3.Visible := True;
  end
  else
    dbGrid3.Visible  := False;

  if dbGrid4.SelectedField.DataType = ftFloat then
  begin
    if Key = chr(46) then
      Key := chr(44);
  end;
end;

procedure TForm48.Importaroramentos1Click(Sender: TObject);
begin
  Form7.sModulo := 'ORCAMENTO';
  Form41.ShowModal;
  Form7.sModulo := 'VENDA';
end;

procedure TForm48.Label28Click(Sender: TObject);
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
    SmallIni.WriteString('VENDAS',NAME,sNome);
    SmallIni.Free;
  end;

  Mais.LeLabels(True);
end;

procedure TForm48.Label28MouseLeave(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Font.Style := [];
    Font.Color := clSilver;
    Repaint;
  end;
end;

procedure TForm48.Label28MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as TLabel do
  begin
    Font.Style := [fsBold,fsUnderline];
    Font.Color := clBlue;
    Repaint;
  end;
end;

procedure TForm48.FormActivate(Sender: TObject);
begin
  // ISS Retido
  if Pos('(I)',Form7.ibDataset15MARCA.AsString) <> 0 then
  begin
    Form48.CheckBox1.Checked := True;
  end else
  begin
    Form48.CheckBox1.Checked := False;
  end;

  // Impostos federais retidos
  if Pos('(F)',Form7.ibDataset15MARCA.AsString) <> 0 then
  begin
    Form48.CheckBox2.Checked := True;
  end else
  begin
    Form48.CheckBox2.Checked := False;
  end;

  if FileExists(Form1.sAtual+'\NFSE\Templates\Impressao\Brasoes\'+UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString)+'.JPG') then
  begin
    ImageFixa.Picture.LoadFromFile(Form1.sAtual+'\NFSE\Templates\Impressao\Brasoes\'+UpperCase(StrTran(ConverteAcentos(Form7.ibDAtaset13MUNICIPIO.AsString),' ',''))+UpperCase(Form7.ibDAtaset13ESTADO.AsString)+'.JPG');
  end else
  begin
    if FileExists(Form1.sAtual+'\NFSE\Templates\Impressao\Brasoes\CONCORDIASC.JPG') then
    begin
      ImageFixa.Picture.LoadFromFile(Form1.sAtual+'\NFSE\Templates\Impressao\Brasoes\CONCORDIASC.JPG');
    end;
  end;

  if Form48.Tag = 1 then
  begin
    // THE END;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Clear;
    Form7.ibDataSet14.SelectSQL.Add('select * from ICM where (ISS<>0) or (CFOP=''5933'') or (CFOP=''6933'') order by ISS');
    Form7.ibDataSet14.Open;
    Form7.ibDataSet14.EnableControls;

    Form48.Top     := Form7.Top;
    Form48.Left    := Form7.Left;
    Form48.Width   := Form7.Width;
    Form48.Height  := Form7.Height;

    Form7.ibDataSet35UNITARIO.Visible := True;
    ScrollBox1.VertScrollBar.Position := 1;
  end;
end;

procedure TForm48.DBGrid4Enter(Sender: TObject);
begin
  // Autocompletar serviços
  if Form7.IBDataSet4.SelectSQL.TExt <>  ('select * from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' and Coalesce(Ativo,0)=0 order by DESCRICAO') then
  begin
    Form7.ibDataSet4.Close;
    Form7.ibDataSet4.SelectSQL.Clear;
    Form7.IBDataSet4.SelectSQL.Add('select * from ESTOQUE where TIPO_ITEM='+QuotedStr('09')+' and Coalesce(Ativo,0)=0 order by DESCRICAO'); // Ok
    Form7.ibDataSet4.Open;
  end;

  dbGrid3.Visible := False;
  dBGrid2.Visible := False;

  dbGrid3.Left     := dbGrid4.Left-1;
  dbGrid3.Top      := dbGrid4.Top + dbGrid4.Height -1;
  dbGrid3.Height   := 160;
  dbGrid3.Width    := dbGrid4.Width+2;

  // THE END AUTOCOMPLETAR
  dbGrid3.Visible       := False;
end;

procedure TForm48.DBGrid4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_DOWN  then
  begin
    if dbGrid3.Visible then
    begin
      dbGrid3.SetFocus;
      Abort;
    end;
  end;
  
  if Key = VK_UP then
  begin
    if dbGrid3.Visible then
    begin
      dbGrid3.SetFocus;
      Abort;
    end;
  end;

  // Sistema de procura
  if DbGrid4.SelectedIndex = 0 then
  begin
    if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset35.Edit;
    Form7.ibDataSet35.UpdateRecord;
    if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset35.Edit;
  end;

  //  Sistema de procura
  if Key = VK_TAB    then
    Key := VK_RETURN;

  if Key = VK_ESCAPE then
    Key := VK_RETURN;

  try
    if Key = VK_RETURN then
    begin
      if DbGrid4.SelectedIndex = 0 then
      begin
        if AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '' then
        begin
          SMALL_DBEdit2.SetFocus;
          dbGrid3.Visible := False;
        end else
        begin
          Form7.ibDataSet4.Locate('DESCRICAO',Form7.ibDataSet35DESCRICAO.AsString,[loCaseInsensitive,loPartialKey]);

          if (Form7.ibDataSet35DESCRICAO.AsString <> Form7.ibDataSet4DESCRICAO.AsString) and (Alltrim(Form7.ibDataSet35DESCRICAO.AsString)<>'')then
          begin
            if (length(Alltrim(Limpanumero(Form7.ibDataSet35DESCRICAO.AsString))) <= 5) and (LimpaNumero(Alltrim(Form7.ibDataSet35DESCRICAO.AsString))<>'') then
            begin
              // Procura por código
              if StrToInt(AllTrim(Form7.ibDataSet35DESCRICAO.AsString)) <> 0 then
              begin
                Form7.ibDataSet4.Locate('CODIGO',StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString))),5,0),[loCaseInsensitive,loPartialKey]);

                if Form7.ibDataSet4CODIGO.AsString = StrZero(StrToInt(AllTrim(LimpaNumero('0'+Form7.ibDataSet35DESCRICAO.AsString))),5,0) then
                begin
                  Form7.ibDataSet35DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
                  Form48.DBGrid3DblClick(Sender);
                end else
                begin
                  Form7.ibDataSet35DESCRICAO.AsString := '';
                end;
              end;
            end else
            begin
              Form48.DBGrid3DblClick(Sender);
            end;
          end;
        end;
      end;

      I := DbGrid4.SelectedIndex;
      DbGrid4.SelectedIndex := DbGrid4.SelectedIndex  + 1;
      if I = DbGrid4.SelectedIndex  then
      begin
        DbGrid4.SelectedIndex := 0;
        Form7.ibDataSet35.Next;
        if Form7.ibDataSet35.EOF then Form7.ibDataSet35.Append;
      end;
    end;
  except
  end;

  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '') then
    DbGrid4.SelectedIndex := 0;
end;

procedure TForm48.DBGrid4ColEnter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;

procedure TForm48.Button2Enter(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 200;
end;

procedure TForm48.DBMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Button3.SetFocus;
  if Key = VK_TAB    then Button3.SetFocus;
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,-1,0);
end;

procedure TForm48.SMALL_DBEdit39KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN   then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,0,0);
  end;

  if Key = VK_UP     then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,-1,0);
  end;

  if Key = VK_RETURN then
  begin
    if Form7.ibDataSet35.IsEmpty = False then
      Form7.ibDataSet35.First;
      
    Perform(Wm_NextDlgCtl,0,0);
  end;
  Key := VK_SHIFT;
end;

procedure TForm48.Label_fecha_0Click(Sender: TObject);
begin
  Form48.Close;
end;

procedure TForm48.SMALL_DBEdit40Enter(Sender: TObject);
begin
  if not dBGrid2.Visible then
  begin
    sOperacaoAntiga   := Form7.ibDAtaSet15OPERACAO.AsString;
    sObservacaoAntiga := Form7.ibDataSet14OBS.AsString;
  end;

  if Form7.sModulo <> 'RETRIBUTA' then
    Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet15.Enablecontrols;
  //
  dBGrid2.Visible := False;
  // ------------------------- //
  // Operação de venda ICM.DBF //
  // ------------------------- //
  dBGrid2.DataSource := Form7.DataSource14;
  dBGrid2.Visible    := True;
  
  if AllTrim(SMALL_DBEdit40.Text) = '' then
  begin
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.First;
    while (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '5'+Copy(Form1.ConfCFOP,2,3)) and (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '6'+Copy(Form1.ConfCFOP,2,3)) and
     (not Form7.ibDataSet14.EOF) do
       Form7.ibDataSet14.Next;
    Form7.ibDataSet14.EnableControls;
    Form7.ibDataSet15.Edit;
    SMALL_DBEdit40.Text := Form7.ibDataSet14NOME.AsString;
  end else
  begin
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Locate('NOME',AllTrim(Form7.ibDAtaSet15OPERACAO.AsString),[]);
    Form7.ibDataSet14.EnableControls;
  end;

  Form7.ibDataSet14.EnableControls;

  dBGrid2.Left       := SMALL_DBEdit40.Left;
  dbGrid2.Top        := SMALL_DBEdit40.Top + SMALL_DBEdit40.Height -1;
  dbGrid2.Width      := SMALL_DBEdit40.Width;
  dBGrid2.Height     := 260; //Panel1.Height - dbGrid2.Top - 20;

  dbGrid2.Columns[0].Width   := 250;
  dbGrid2.Columns[1].Width   := 30;
  dbGrid2.Columns[1].Visible := True;

  SMALL_DBEdit40.SelectAll;
end;

procedure TForm48.SMALL_DBEdit40Exit(Sender: TObject);
begin
  // Joga p/obs a obs na tabela de icm  Limpando o que tinha
  Form7.ibDataSet14.Locate('NOME',AllTrim(SMALL_DBEdit40.Text),[]);

  if AllTrim(sOperacaoAntiga) <> AllTrim(Form7.ibDataSet14NOME.AsString) then
  begin
    Form7.ibQuery1.Close;
    Form7.ibQuery1.SQL.Clear;
    Form7.ibQuery1.SQL.Add('select * from ICM where NOME='+QuotedStr(sOperacaoAntiga)+' ');
    Form7.ibQuery1.Open;

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.EOF do // Disable
    begin
      if Form7.ibDataSet16TOTAL.AsString <> '' then
      begin
        if Form7.ibDataSet16CFOP.AsString = Form7.ibQuery1.FieldByName('CFOP').AsString then
        begin
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16CFOP.AsString := '';
        end;
      end;
      Form7.ibDataSet16.Next;
    end;

    Retributa(True);

    if Form7.ibDataSet16.Modified then
      Form7.ibDataSet16.Post;
  end;

  if SMALL_DBEdit40.Text <> '' then
  begin
    RecalcularIssDosItens; // Sandro Silva 2022-09-22

    if (Pos( AnsiUpperCase(AllTrim(SMALL_DBEdit40.Text)), AnsiUpperCase(AllTrim(Form7.ibDataSet14NOME.AsString))) <> 0) then
    begin
      Form7.ibDataSet15.Edit;
      Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
      ObservacaoOperacao(False); // On exit
    end else
    begin
      if AllTrim(SMALL_DBEdit40.Text)<>AllTrim(Form7.ibDataSet14NOME.AsString) then
      begin
        if SMALL_DBEdit40.CanFocus then
          SMALL_DBEdit40.SetFocus;
      end;
    end;
  end;
end;

procedure TForm48.SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nfse_venda.htm')));
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN   then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,0,0);
  end;
  if Key = VK_UP     then
  begin
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,-1,0);
  end;
  Key := VK_SHIFT;
end;

procedure TForm48.SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then
    PopUpMenu3.Popup(dBGrid1.Left,dBgrid1.Top + 20);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nfse_sobre.htm')));
end;

procedure TForm48.SMALL_DBEdit2Enter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;

procedure TForm48.SMALL_DBEdit40Change(Sender: TObject);
begin
  if (Form48.Visible) and (Form7.ibDataSet14.Active) then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM ICM where ((ISS<>0) or (CFOP=''5933'') or (CFOP=''6933'')) and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit40.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet14.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    Form7.IBDataSet99.EnableControls;
    
    Form7.ibDataSet15.Enablecontrols;
    dBGrid2.DataSource := Form7.DataSource14;
  end;
end;

procedure TForm48.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    Form48.DBGrid3DblClick(Sender);
  end;
end;

procedure TForm48.DBGrid3DblClick(Sender: TObject);
begin
  try
    if not (Form7.ibDataset35.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset35.Edit;

    Form7.ibDataSet35CODIGO.AsString    := Form7.IBDataSet4.FieldByname('CODIGO').AsString;
    Form7.ibDataSet35DESCRICAO.AsString := Form7.IBDataSet4.FieldByname('DESCRICAO').AsString;
    Form7.ibDataSet35QUANTIDADE.AsFloat := 1;
    Form7.ibDataSet35UNITARIO.AsFloat   := Form7.IBDataSet4.FieldByname('PRECO').AsFloat;

    {Sandro Silva 2022-09-22 inicio}
    Form7.ibDataSet35ISS.AsFloat      := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBDataSet14.FieldByname('ISS').AsFloat / 100 * Form7.IBDataSet14.FieldByname('BASEISS').AsFloat / 100);
    Form7.ibDataSet35BASEISS.AsFloat  := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBDataSet14.FieldByname('BASEISS').AsFloat / 100);
    {Sandro Silva 2022-09-22 fim}
    Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Value := Form7.ibDataSet4IDENTIFICADORPLANOCONTAS.Value;
    if Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.AsString = '' then
      Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Clear;

    Form7.ibDataSet35.Post;
    Form7.ibDataSet35.Edit;
  except
  end;

  if dbGrid3.Focused then
    dbGrid4.SetFocus;
end;

procedure TForm48.CheckBox1Click(Sender: TObject);
begin
  DBMemo1.SetFocus;
  dbGrid1.Visible := False;
  dbGrid2.Visible := False;

  if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset15.Edit;

  if Form48.CheckBox1.Checked then
  begin
    Form7.ibDataset15MARCA.AsString := Form7.ibDataset15MARCA.AsString + '(I)';
  end else
  begin
    Form7.ibDataset15MARCA.AsString := StrTran(Form7.ibDataset15MARCA.AsString,'(I)','');
  end;

  Form7.ibDataset15.Post;
  Form7.ibDataset15.Edit;

  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
end;

procedure TForm48.SMALL_DBEdit2Exit(Sender: TObject);
begin
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
end;

procedure TForm48.CheckBox2Click(Sender: TObject);
begin
  DBMemo1.SetFocus;
  dbGrid1.Visible := False;
  dbGrid2.Visible := False;

  if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset15.Edit;

  if Form48.CheckBox2.Checked then
  begin
    Form7.ibDataset15MARCA.AsString := Form7.ibDataset15MARCA.AsString + '(F)';
  end else
  begin
    Form7.ibDataset15MARCA.AsString := StrTran(Form7.ibDataset15MARCA.AsString,'(F)','');
  end;

  Form7.ibDataset15.Post;
  Form7.ibDataset15.Edit;

  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
end;

procedure TForm48.Button3Click(Sender: TObject);
begin
  Form48.DBGrid1.SelectedIndex := 0;
  
  try
    bOk := True;
    Form48.Close;
    Form7.Image101Click(Sender);
  except
  end;
end;

procedure TForm48.RecalcularIssDosItens;
var
  cTotal: Currency;
begin
  {Sandro Silva 2022-09-22 inicio}
  // Quando mudar a operação deve recalcular os valores de ISS dos itens lançados na nota conforme a alíquota de ISS da operação
  if Form7.ibDataSet35.Active then
  begin
    if Form7.ibDataSet35.RecordCount > 0 then // Tem itens lançados
    begin
      cTotal := 0.00;
      Form7.ibDataSet35.First;
      while Form7.ibDataSet35.Eof = False do
      begin
        // Aplica a alíquota nos itens lançados
        Form7.ibDataSet35.Edit;
        
        Form7.ibDataSet35ISS.AsFloat      := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBDataSet14.FieldByname('ISS').AsFloat / 100 * Form7.IBDataSet14.FieldByname('BASEISS').AsFloat / 100);
        Form7.ibDataSet35BASEISS.AsFloat  := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBDataSet14.FieldByname('BASEISS').AsFloat / 100);
        cTotal := cTotal + Form7.ibDataSet35ISS.AsFloat; // Acumula para atualizar o total de ISS na tabela VENDAS

        Form7.ibDataSet35.Next;
      end;
      if Form7.ibDataSet15ISS.AsFloat <> cTotal then
      begin
        if not (Form7.ibDataSet15.State in [dsInsert, dsEdit]) then
          Form7.ibDataSet15.Edit;
        Form7.ibDataSet15ISS.AsFloat := cTotal;
      end;

    end;
  end;

  {Sandro Silva 2022-09-22 fim}
end;

procedure TForm48.SMALL_DBEdit3Enter(Sender: TObject);
begin
  dBGrid2.Visible    := False;
end;

end.
