//Unit Selecionar plano de contas
unit Unit43;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Mask, DBCtrls, SmallFunc, shellApi, HtmlHelp,
  ExtCtrls, WinTypes, WinProcs, DB, Buttons;

type
  TForm43 = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    Button4: TBitBtn;
    CheckBox1: TCheckBox;
    EdPesquisaConta: TEdit;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdPesquisaContaChange(Sender: TObject);
    procedure EdPesquisaContaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    FIdentificadorPlanoContas: String;
    { Private declarations }
    function UsandoDescricaoContabail: Boolean;
    procedure SelecionaConta;
  public
    { Public declarations }
    property IdentificadorPlanoContas: String read FIdentificadorPlanoContas write FIdentificadorPlanoContas; // Sandro Silva 2022-12-29
  end;

var
  Form43: TForm43;

implementation

uses Unit7, Unit10, Unit34, Mais, uDialogs;

{$R *.DFM}

procedure TForm43.DBGrid1CellClick(Column: TColumn);
begin
  {Sandro Silva 2022-12-20 inicio
  Edit1.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  }
  {Sandro Silva 2022-12-29 inicio
  if UsandoDescricaoContabail then
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;     // Plano de contas
  end
  else
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  end;
  }
  SelecionaConta;
  {Sandro Silva 2022-12-29 fim}
  EdPesquisaConta.SetFocus;
end;

procedure TForm43.DBGrid1DblClick(Sender: TObject);
begin
  {Sandro Silva 2022-12-20 inicio
  Edit1.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  }
  {Sandro Silva 2022-12-29 inicio
  if UsandoDescricaoContabail then
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;     // Plano de contas
  end
  else
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  end;
  }
  SelecionaConta;
  {Sandro Silva 2022-12-29 fim}
  EdPesquisaConta.SetFocus;
end;

procedure TForm43.FormActivate(Sender: TObject);
begin
  {Sandro Silva 2022-12-20 inicio}
  if UsandoDescricaoContabail then
  begin
    Form7.ibDataSet12.Close;
    Form7.ibDataSet12.SelectSQL.Clear;
    Form7.ibDataSet12.SelectSQL.Add('select * from CONTAS where coalesce(DESCRICAOCONTABIL, '''') <> '''' order by upper(DESCRICAOCONTABIL) ');
    Form7.ibDataSet12.Open;
  end
  else
  begin
    Form7.ibDataSet12.Close;
    Form7.ibDataSet12.SelectSQL.Clear;
    Form7.ibDataSet12.SelectSQL.Add('select * from CONTAS order by upper(NOME)');
    Form7.ibDataSet12.Open;
  end;
  {Sandro Silva 2022-12-20 fim}
  CheckBox1.Checked := False;
  Form7.ibDataSet12NOME.DisplayWidth := 30;
  CheckBox1.Caption := 'Usar sempre esta conta para '+Form7.ibDataSet14NOME.AsString;
  EdPesquisaConta.Text := '';

  {Sandro Silva 2022-12-29 inicio}
  if UsandoDescricaoContabail then
  begin

    if Trim(FIdentificadorPlanoContas) <> '' then
    begin

      if Form7.ibDataSet12.Locate('IDENTIFICADOR', FIdentificadorPlanoContas, []) then
      begin

        EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;
        SelecionaConta;

      end;

    end;

  end;
  {Sandro Silva 2022-12-29 fim}

  EdPesquisaConta.SetFocus;
end;

procedure TForm43.Button4Click(Sender: TObject);
begin
  if UsandoDescricaoContabail then
  begin
    if AllTrim(EdPesquisaConta.Text) = AllTrim(Form7.ibDataSet12DESCRICAOCONTABIL.AsString) then
    begin
      EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;

      if CheckBox1.Checked then
      begin
        Form7.ibDataSet14.Edit;
        form7.ibDataSet14CONTA.AsString := Form7.ibDataSet12NOME.AsString;
        Form7.ibDataSet14.Post;
      end;

      Close;
    end else
    begin
      //ShowMessage('     Selecione a conta a que este     '+Chr(10)+'     valor deve ser atribuído.'); Mauricio Parizotto 2023-10-25
      MensagemSistema('     Selecione a conta a que este     '+Chr(10)+'     valor deve ser atribuído.');
      EdPesquisaConta.SetFocus;
    end;
  end
  else
  begin
    if AllTrim(EdPesquisaConta.Text) = AllTrim(Form7.ibDataSet12NOME.AsString) then
    begin
      EdPesquisaConta.Text := Form7.ibDataSet12NOME.AsString;

      if CheckBox1.Checked then
      begin
        Form7.ibDataSet14.Edit;
        form7.ibDataSet14CONTA.AsString := EdPesquisaConta.Text;
        Form7.ibDataSet14.Post;
      end;

      Close;
    end else
    begin
      //ShowMessage('     Selecione a conta a que este     '+Chr(10)+'     valor deve ser atribuído.'); Mauricio Parizotto 2023-10-25
      MensagemSistema('     Selecione a conta a que este     '+Chr(10)+'     valor deve ser atribuído.');
      EdPesquisaConta.SetFocus;
    end;
  end;
end;

procedure TForm43.FormClose(Sender: TObject; var Action: TCloseAction);
//var
// Sandro Silva 2022-12-29 sConta: String;
begin
  try
    // Sandro Silva 2022-12-29 sConta := Form7.ibDataSet12NOME.AsString;
    Form7.ibDataSet12NOME.DisplayWidth := 25;
  except
  end;
end;

procedure TForm43.EdPesquisaContaChange(Sender: TObject);
begin
  //
  {Sandro Silva 2022-12-20 inicio
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.ibDataSet99.SelectSQL.Add('select * FROM CONTAS where Upper(NOME) like '+QuotedStr('%'+UpperCase(AllTrim(Edit1.Text))+'%')+' order by upper(NOME) ');
  Form7.ibDataSet99.Open;
  Form7.ibDataSet99.First;
  Form7.ibDataSet12.Locate('NOME',AllTrim(Form7.ibDataSet99.FieldByname('NOME').AsString),[]);
  }
  if UsandoDescricaoContabail then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM CONTAS where Upper(DESCRICAOCONTABIL) like '+QuotedStr('%'+UpperCase(AllTrim(EdPesquisaConta.Text))+'%')+' order by upper(DESCRICAOCONTABIL) ');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet12.Locate('DESCRICAOCONTABIL', Trim(Form7.ibDataSet99.FieldByname('DESCRICAOCONTABIL').AsString), []);
  end
  else
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM CONTAS where Upper(NOME) like '+QuotedStr('%'+UpperCase(AllTrim(EdPesquisaConta.Text))+'%')+' order by upper(NOME) ');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet12.Locate('NOME',AllTrim(Form7.ibDataSet99.FieldByname('NOME').AsString),[]);
  end;
  {Sandro Silva 2022-12-20 fim}
  //
end;

procedure TForm43.EdPesquisaContaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_RETURN then
  begin
    {Sandro Silva 2022-12-20 inicio
    if (Edit1.Text = Form7.ibDataSet12NOME.AsString) and (Alltrim(Edit1.Text)<>'') then
      Close;
    if Form7.ibDataSet12.Locate('NOME',AllTrim(Edit1.Text),[loCaseInsensitive, loPartialKey]) then
      Edit1.Text := Form7.ibDataSet12NOME.AsString;
    }
    if UsandoDescricaoContabail then
    begin
      if (EdPesquisaConta.Text = Form7.ibDataSet12DESCRICAOCONTABIL.AsString) and (Alltrim(EdPesquisaConta.Text)<>'') then
        Close;
      if Form7.ibDataSet12.Locate('DESCRICAOCONTABIL',AllTrim(EdPesquisaConta.Text),[loCaseInsensitive, loPartialKey]) then
        EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;
    end
    else
    begin
      if (EdPesquisaConta.Text = Form7.ibDataSet12NOME.AsString) and (Alltrim(EdPesquisaConta.Text)<>'') then
        Close;
      if Form7.ibDataSet12.Locate('NOME',AllTrim(EdPesquisaConta.Text),[loCaseInsensitive, loPartialKey]) then
        EdPesquisaConta.Text := Form7.ibDataSet12NOME.AsString;
    end;
    {Sandro Silva 2022-12-20 fim}
  end;
  //
  if (Key = VK_UP) or (Key = VK_DOWN) then
  begin
    if dBgrid1.CanFocus then
      dBgrid1.SetFocus
    else
      Button4.SetFocus;
  end;

  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('planodecontas.htm')));
end;

procedure TForm43.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    DBGrid1DblClick(Sender);
end;

procedure TForm43.FormShow(Sender: TObject);
begin
  {Sandro Silva 2022-12-19 inicio}
  if UsandoDescricaoContabail then
  begin
    Form43.Width := 472;
    DBGrid1.Columns[0].FieldName := 'DESCRICAOCONTABIL';
  end
  else
  begin
    Form43.Width := 279;
    DBGrid1.Columns[0].FieldName := 'NOME';
  end;
  {Sandro Silva 2022-12-19 fim}
end;

function TForm43.UsandoDescricaoContabail: Boolean;
begin
  Result := False;
  if Form1.DisponivelSomenteParaNos and (Form7.sModulo = 'COMPRA') then
    Result := True; 
end;

procedure TForm43.SelecionaConta;
begin
  if UsandoDescricaoContabail then
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12DESCRICAOCONTABIL.AsString;     // Plano de contas
  end
  else
  begin
    EdPesquisaConta.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  end;

end;

end.

