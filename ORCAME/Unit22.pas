unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ShellApi;

type
  TForm22 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image2: TImage;
    Image1: TImage;
    Label2: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Image1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Inicio : TTime;
    sContrasteCor : String;
  end;

var
  Form22: TForm22;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm22.FormCreate(Sender: TObject);
var
  Size, Size2: DWord;
  Pt, Pt2: Pointer;
begin
  sContrasteCor := 'BRANCO';
  Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
  GetMem (Pt, Size);
  GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
  VerQueryValue(Pt,'\StringFileInfo\041604E4\FileVersion',Pt2, Size2);
  Label4.Caption :=  'Versão e Build: ' + PChar (pt2);
  FreeMem (Pt);
end;

procedure TForm22.FormClick(Sender: TObject);
begin
  Close;
end;

procedure TForm22.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close;
end;

procedure TForm22.Image1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm22.Label1Click(Sender: TObject);
var
 I : Integer;
begin
  //
  if Image1.Tag = 7 then
  begin
    Form22.Color           := ClBlack;
    Form22.Color           := clWhite;
    Form22.AlphaBlendValue := 100;
    Form22.WindowState     := WsMaximized;
    Image1.Picture.Bitmap  := Image2.Picture.Bitmap;
    Image1.AutoSize        := True;
    Image1.Stretch         := True;
    Image1.Align           := AlClient;
    Image1.Left            := 0;
    Image1.Top             := 0;
    //
    Label2.Visible := False;
    Label3.Visible := False;
    Label4.Visible := False;
    Label5.Visible := False;
    //
    //
    for I := 1 to 30 do
    begin
      Label1.Caption := 'Desenvolvido por Ronei Ivo Weber';
      Label1.Font.Size := I;
      Label1.Top  := Screen.Height div 2 + 40;
      Label1.Left := (Screen.Width - Label1.Width) div 2;
      Label1.Repaint;
      Sleep(100);
    end;
    //
    //
    Form1.Close;
    //
  end else
  begin
    Image1.Tag     := 0;
    Close;
  end;
  //
end;

procedure TForm22.Label6Click(Sender: TObject);
begin
  Image1.Tag := Image1.Tag + 1;
end;

procedure TForm22.FormActivate(Sender: TObject);
begin
  //
  if (sContrasteCor <> 'BRANCO') then
  begin
    Label7.Font.Color := clBlack;
    Label8.Font.Color := clBlack;
    Label2.Font.Color := clBlack;
    Label1.Font.Color := clBlack;
    Label4.Font.Color := clBlack;
    Label3.Font.Color := clBlack;
    Label5.Font.Color := clBlack;
  end else
  begin
    Label7.Font.Color := clWhite;
    Label8.Font.Color := clWhite;
    Label2.Font.Color := clWhite;
    Label1.Font.Color := clWhite;
    Label4.Font.Color := clWhite;
    Label3.Font.Color := clWhite;
    Label5.Font.Color := clWhite;
  end;
  //
  Image1.Repaint;
  //
end;

procedure TForm22.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tImage do
  begin
    Picture.SaveToFile('c:\teste.bmp');
  end;  
end;

end.
