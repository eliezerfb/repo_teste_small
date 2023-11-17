unit Unit29;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SmallFunc, Gauges;

type
  TForm29 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label2: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel1: TPanel;
    Gauge1: TGauge;
    Panel_dados: TPanel;
    Label3: TLabel;
    Edit_01: TEdit;
    Label_01: TLabel;
    Label_02: TLabel;
    Edit_02: TEdit;
    Label_03: TLabel;
    Edit_03: TEdit;
    Label_04: TLabel;
    Edit_04: TEdit;
    Label_05: TLabel;
    Edit_05: TEdit;
    Label_06: TLabel;
    Edit_06: TEdit;
    Label_07: TLabel;
    Edit_07: TEdit;
    Label_08: TLabel;
    Edit_08: TEdit;
    Label_09: TLabel;
    Edit_09: TEdit;
    Label_10: TLabel;
    Edit_10: TEdit;
    btnCancelar: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit_01KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
	procedure SomenteNumerosKeyPress(Sender: TObject; var Key: Char);
    procedure SomenteNumerosChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FnMaxLength: Integer;
    FbClicouOK: Boolean;
  public
    procedure DefinirSomenteNumeros;
    property MaxLength: Integer read FnMaxLength write FnMaxLength;
    property ClicouOK: Boolean read FbClicouOK write FbClicouOK;
  end;

var
  Form29: TForm29;

implementation

uses Unit7, Mais, Unit10;

{$R *.dfm}

procedure TForm29.Button1Click(Sender: TObject);
begin
  FbClicouOK := True;
  Close;
end;

procedure TForm29.FormActivate(Sender: TObject);
begin
  FbClicouOK := True;
  //
  Form7.AlphaBlend       := True;
  Form10.AlphaBlend      := True;
  Form7.AlphaBlendValue  := 0;
  Form10.AlphaBlendValue := 0;
  //
  if Form29.Button1.CanFocus then Form29.Button1.SetFocus;
  if Form29.Edit1.CanFocus then Form29.Edit1.SetFocus;
  if Form29.Panel_dados.Visible then Edit_01.SetFocus;
  //
  if Copy(TimeToStr(Time),1,2) < '04' then
  begin
    Form29.Label2.Caption := 'Boa noite!';
  end else
  begin
    if Copy(TimeToStr(Time),1,2) < '12' then
    begin
      Form29.Label2.Caption := 'Bom dia!';
    end else
    begin
      if Copy(TimeToStr(Time),1,2) < '20' then
      begin
        Form29.Label2.Caption := 'Boa tarde!';
      end else
      begin
        Form29.Label2.Caption := 'Boa noite!';
      end;
    end;
  end;
  //
  Form29.Height := Form7.Height;
  Form29.Width  := Form7.Width;
  Form29.Top    := Form7.Top;
  Form29.Left   := Form7.Left;
  //
  Form29.Label2.Left      := Form1.Label1.Left;
  Form29.Label1.Left      := Form1.Label3.Left;
  //
  Form29.Label2.Top       := Form1.Label1.Top;
  Form29.Label1.Top       := Form29.Label2.Top + Form29.Label2.Height + 35;
  //
//  Form29.Image1.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_'+FloatToStr(Random(12))+'.bmp');
  //
  Form29.Label2.Font.Height := Form1.Label1.Font.Height;
  Form29.Label1.Font.Height := Form1.Label3.Font.Height;
  //
  if Form29.Label1.Height > 250 then
  begin
    Form29.Label1.Font.Size := 11;
    Form29.Label1.Repaint;
  end;
  //
  if Form29.Label1.Width > 800 then
  begin
    if Length(Form29.Label1.Caption) > 100 then Form29.Label1.Caption := Copy(Form29.Label1.Caption,1,100)+chr(10)+AllTrim(Copy(Form29.Label1.Caption+Replicate(' ',200),101,200));
    if Length(Form29.Label1.Caption) > 50 then Form29.Label1.Caption := Copy(Form29.Label1.Caption,1,50)+chr(10)+AllTrim(Copy(Form29.Label1.Caption+Replicate(' ',200),51,200));
    Form29.Label1.Repaint;
  end;
  //
  if Form29.Label1.Height > 250 then
  begin
    Form29.Label1.Font.Size := 8;
    Form29.Label1.Repaint;
  end;
  //
  Form29.Edit1.Top      := Form29.Label1.Top + Form29.Label1.Height + 20;
  Form29.Edit1.Left     := Form29.Label1.Left;
  //
  Form29.Gauge1.Progress := 0;
  Form29.Panel1.Width    := 650;
  Form29.Panel1.Top      := 300;
  Form29.Panel1.Left     := 70;
  //
end;

procedure TForm29.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Form10.AlphaBlendValue := 255;
  Form7.AlphaBlendValue  := 255;
  //
  Form29.Label_01.Visible := False;
  Form29.Label_02.Visible := False;
  Form29.Label_03.Visible := False;
  Form29.Label_04.Visible := False;
  Form29.Label_05.Visible := False;
  Form29.Label_06.Visible := False;
  Form29.Label_07.Visible := False;
  Form29.Label_08.Visible := False;
  Form29.Label_09.Visible := False;
  Form29.Label_10.Visible := False;
  //
  Form29.Edit_01.Visible := False;
  Form29.Edit_02.Visible := False;
  Form29.Edit_03.Visible := False;
  Form29.Edit_04.Visible := False;
  Form29.Edit_05.Visible := False;
  Form29.Edit_06.Visible := False;
  Form29.Edit_07.Visible := False;
  Form29.Edit_08.Visible := False;
  Form29.Edit_09.Visible := False;
  Form29.Edit_10.Visible := False;
  //
  Button1.Visible     := True;
  Panel1.Visible      := False;
  Panel_Dados.Visible  := False;
  //
  FnMaxLength      := 0;
  Edit1.OnChange   := nil;
  Edit1.OnKeyPress := nil;
end;

procedure TForm29.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = Vk_Return then
  begin
    Button1Click(Sender);
  end;
end;

procedure TForm29.Edit_01KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm29.FormCreate(Sender: TObject);
begin
  Gauge1.Font.Name := 'MS Serif'; //Problema fonte borada no Delphi 7
  Gauge1.Font.Style := [fsBold];
end;

procedure TForm29.DefinirSomenteNumeros;
begin
  Edit1.OnKeyPress := SomenteNumerosKeyPress;
  Edit1.OnChange   := SomenteNumerosChange;
end;

procedure TForm29.SomenteNumerosKeyPress(Sender: TObject; var Key: Char);
begin
  // #1 - Ctrl + A
  // #3 - Ctrl + C
  // #8 - Backspace
  // #13 - Enter
  // #22 - Ctrl + V
  // #24 - Ctrl + X
  if (not (Key in ['0'..'9', Chr(1), Chr(3), Chr(8), Chr(13), Chr(22), Chr(24)])) // Permite 0 a 9 e as comandos
     or ((not (Key in [Chr(1), Chr(3), Chr(8), Chr(22), Chr(24)])) and (FnMaxLength > 0) and (FnMaxLength < Length(Edit1.Text)+1)) then // Permite apagar e valida o MaxLength
    Key := Chr(0);
end;

procedure TForm29.SomenteNumerosChange(Sender: TObject);
begin
  Edit1.Text := LimpaNumero(Edit1.Text);
  if FnMaxLength > 0 then
    Edit1.Text := Copy(Edit1.Text, 1, FnMaxLength);
end;

procedure TForm29.btnCancelarClick(Sender: TObject);
begin
  FbClicouOK := False;
  Self.Close;
end;

end.
