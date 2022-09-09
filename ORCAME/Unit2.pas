unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label5: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.FormCreate(Sender: TObject);
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  GetMem (Pt, Size);
  GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
//       VerQueryValue (Pt, '\', Pt2, Size2);
  VerQueryValue(Pt,'\StringFileInfo\041604E4\FileVersion',Pt2, Size2);
  Label6.Caption :=  'Versão e Build: ' + PChar (pt2);
  FreeMem (Pt);
end;

procedure TForm2.FormClick(Sender: TObject);
begin
  Close;
end;

end.
