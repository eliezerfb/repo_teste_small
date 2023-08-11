unit Unit28;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IniFiles, SmallFunc;

type
  TForm28 = class(TForm)
    Image1: TImage;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form28: TForm28;

implementation

uses Unit14, Mais, Unit7;

{$R *.dfm}

procedure TForm28.FormActivate(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
  DateTimePicker1.Date  := StrToDate(Mais1Ini.ReadString('XML','Periodo Inicial',DateToStr(DATE-30)));
  DateTimePicker2.Date  := StrToDate(Mais1Ini.ReadString('XML','Periodo Final',DateToStr(DATE)));
  Edit1.Text            := Alltrim(Mais1Ini.ReadString('XML','e-mail contabilidade',''));
  Mais1ini.Free;

  Image1.Picture := Form1.imgVendas.Picture;

  {$IFDEF VER150}
  ShortDateFormat := 'dd/mm/yyyy';
  {$ELSE}
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  {$ENDIF}
end;

procedure TForm28.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm28.Button2Click(Sender: TObject);
begin
  DateTimePicker1.Date    := StrToDate('01/01/1998');
  DateTimePicker2.Date    := StrToDate('01/01/1998');
  Close;
end;

end.

