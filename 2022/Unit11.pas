unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SmallFunc, HtmlHelp;

type
  TForm11 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit4: TEdit;
    ComboBox7: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Edit6: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

uses Unit7;

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm11.FormActivate(Sender: TObject);
begin
  //
  if Form11.Edit2.Text = '0000' then
  begin
    Edit2.Text := Copy(DateToStr(Date),9,2)+Copy(DateToStr(Date),4,2); // AAMM
  end;
  //
  Edit1.SetFocus;
  //
end;

procedure TForm11.Edit1Exit(Sender: TObject);
begin
  if Pos('1'+UpperCase(Edit1.Text)+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX21  21mg2')
     = 0 then
  begin
    ShowMessage('Estado inválido');
    Edit1.Text := UpperCase(Form7.ibDataSet13ESTADO.AsString);
  end;
end;

procedure TForm11.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_Produtor_Rural.htm')));
  //
end;

procedure TForm11.Edit5Exit(Sender: TObject);
begin
  //
  Edit5.Text := LimpaNumero(Copy(Edit5.Text+'   ',1,3));
  //
end;

procedure TForm11.Edit6Change(Sender: TObject);
begin
  Edit6.Text := LimpaNumero(Copy(Edit6.Text+'         ',1,9));
end;

end.

//
// Ok na pasta certa
//
