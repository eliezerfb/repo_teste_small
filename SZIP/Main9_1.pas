unit Main9_1;

interface

uses
  Windows, Messages, SysUtils, {Variants,} Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SmallFunc, XPMan, Gauges;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Label6: TLabel;
    Memo1: TMemo;
    Button2: TButton;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
	{ Private declarations }
  	fzip: TThread;
  public
	{ Public declarations }
	property ZipThread: TThread read fzip write fzip;
  end;

var
  Form1: TForm1;

implementation
Uses
	ZThrd;

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.WindowState := wsMinimized;
	fzip := nil;
  Label6.Caption  := ParamStr(1)+' '+ParamStr(2)+' em '+ParamStr(3);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  sl: TStringList;
begin
  //
  Form1.WindowState := wsMinimized;
  Button1.Enabled := True;
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  if UpperCase(ParamStr(1))='BACKUP' then
  begin
    //
    if ParamCount = 3 then
    begin
      //
      try
        //
        if not assigned(fzip) then
        begin
          sl := TStringList.Create;
          try
            //
            sl.Add(ParamStr(2));
            fzip := TZipThread.Create(ParamStr(3),sl,Memo1,false);
            //
            while Copy(AllTrim(Memo1.Text)+'     ',1,5) <> 'Added' do
            begin
              Application.ProcessMessages;
              sleep(100);
            end;
            //
            while not FileExists(ParamStr(3)) do
            begin
              sleep(100);
              Memo1.Repaint;
            end;
            //
          finally
            sl.Free;
          end;
        end;
      except end;
    end;
    //
  end;
  //
  if UpperCase(ParamStr(1))='RESTORE' then
  begin

  end;
  //
  Screen.Cursor := crDefault; // 
  Close;
  //
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  sAtual: String;
  I, Z : Integer;
begin
  //
  GetDir(0,sAtual);
  I := Random(12);
  //
  try
    //
    for Z := 0 to StrToInt(Copy(TimetoStr(Time),7,2)) do
    begin
      I := Random(12);
    end;
    //
    if FileExists(sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp') then
    begin
      Image1.Picture.LoadFromFile(sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp');
      Image1.Repaint;
    end;
    //
  except end;
  //
  Form1.Repaint;
  Button1Click(Sender);
  //
end;

end.


