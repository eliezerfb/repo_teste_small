//Unit Selecionar plano de contas
unit Unit43;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Mask, DBCtrls, SmallFunc, shellApi, HtmlHelp,
  ExtCtrls, WinTypes, WinProcs, DB;

type
  TForm43 = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form43: TForm43;

implementation

uses Unit7, Unit10, Unit34, Mais;

{$R *.DFM}


procedure TForm43.DBGrid1CellClick(Column: TColumn);
begin
  Edit1.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  Edit1.SetFocus;
end;

procedure TForm43.DBGrid1DblClick(Sender: TObject);
begin
  Edit1.Text := Form7.ibDataSet12NOME.AsString;     // Plano de contas
  Edit1.SetFocus;
end;

procedure TForm43.FormActivate(Sender: TObject);
begin
  CheckBox1.Checked := False;
  Form7.ibDataSet12NOME.DisplayWidth := 30;
  CheckBox1.Caption := 'Usar sempre esta conta para '+Form7.ibDataSet14NOME.AsString;
  Edit1.Text := '';
  Edit1.SetFocus;
end;

procedure TForm43.Button4Click(Sender: TObject);
begin
  //
  if AllTrim(Edit1.Text) = AllTrim(Form7.ibDataSet12NOME.AsString) then
  begin
    Edit1.Text := Form7.ibDataSet12NOME.AsString;
    Close;
  end else
  begin
    ShowMessage('     Selecione a conta a que este     '+Chr(10)+'     valor deve ser atribuído.');
    Edit1.SetFocus;
  end;
  //
  if CheckBox1.Checked then
  begin
    Form7.ibDataSet14.Edit;
    form7.ibDataSet14CONTA.AsString := Edit1.Text;
    Form7.ibDataSet14.Post;
  end;
  //
end;

procedure TForm43.FormClose(Sender: TObject; var Action: TCloseAction);
var
 sConta: String;
begin
  try
    sConta := Form7.ibDataSet12NOME.AsString;
    Form7.ibDataSet12NOME.DisplayWidth := 25;
  except
  end;
end;

procedure TForm43.Edit1Change(Sender: TObject);
begin
  //
  Form7.ibDataSet99.Close;
  Form7.ibDataSet99.SelectSQL.Clear;
  Form7.ibDataSet99.SelectSQL.Add('select * FROM CONTAS where Upper(NOME) like '+QuotedStr('%'+UpperCase(AllTrim(Edit1.Text))+'%')+' order by upper(NOME) ');
  Form7.ibDataSet99.Open;
  Form7.ibDataSet99.First;
  Form7.ibDataSet12.Locate('NOME',AllTrim(Form7.ibDataSet99.FieldByname('NOME').AsString),[]);
  //
end;

procedure TForm43.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_RETURN then
  begin
    if (Edit1.Text = Form7.ibDataSet12NOME.AsString) and (Alltrim(Edit1.Text)<>'') then
      Close;
    if Form7.ibDataSet12.Locate('NOME',AllTrim(Edit1.Text),[loCaseInsensitive, loPartialKey]) then
      Edit1.Text := Form7.ibDataSet12NOME.AsString;
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

end.

