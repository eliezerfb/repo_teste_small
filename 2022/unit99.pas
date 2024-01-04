unit Unit99;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, smallfunc_xe, ExtCtrls
  ;

type
  TForm99 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button2: TButton;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form99: TForm99;

implementation

uses

Mais3, Unit3, Mais, Unit22;

{$R *.DFM}

procedure TForm99.FormActivate(Sender: TObject);
begin
  //
  Form99.Top             := Form22.Image1.Top + Form22.Image1.Height;
  Form99.Left            := (Form22.Width div 2) - (Senhas.Width div 2) ;
  //
  Edit1.Text := Senhas.Senha.Text;
  Edit2.Text := '';
  Edit1.SelectAll;
  //
  try
    if Senhas2.Senha.Text <> '' then Edit1.Text := Senhas2.Senha.Text;
//    if Length(Senhas2.Senha.Text) <> 0 then Edit1.Text := Senhas2.Senha.Text;
  except end;
  Edit1.SetFocus;
  //
end;

procedure TForm99.Edit1Exit(Sender: TObject);
begin
  if Alltrim(Edit1.Text) = '' then Edit1.SetFocus;
end;

procedure TForm99.Edit2Exit(Sender: TObject);
begin
  if Alltrim(Edit2.Text) = '' then Edit2.SetFocus;
end;

procedure TForm99.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Edit2.SetFocus;
end;

procedure TForm99.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Close;
  if Key = VK_ESCAPE then
  begin
    Edit1.Text := '';
    Edit2.Text := '';
    Close;
  end;


end;

procedure TForm99.Button2Click(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Close;
end;

procedure TForm99.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm99.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('login.htm')));
end;

procedure TForm99.Edit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('login.htm')));
end;

end.

