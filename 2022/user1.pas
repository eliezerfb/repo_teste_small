unit user1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles, SmallFunc,
  ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bchave : Boolean;
//    sParametro : String;
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
begin
  bChave := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Component1 : TLabel;
  Component2 : TImage;
  Mais1Ini: TIniFile;
  I, J, Z : Integer;
//  sMensagem : String;
  sSecoes :  TStrings;
  sAtual : String;
begin
  //
  Form1.Height := 550;
  //
  GetDir(0,sAtual);
  sSecoes := TStringList.Create;
  Mais1ini := TIniFile.Create(sAtual+'\EST0QUE.DAT');
  Mais1Ini.ReadSections(sSecoes);
  J := Form1.ComponentCount-1;
  for I := J DownTo 8 do Form1.Components[I].Destroy;
  // GroupBox2.Height := 25;
  J := Form1.ComponentCount-1;
  for I := J DownTo 7 do Form1.Components[I].Destroy;
  //
  Z := 0;
  for I := 0 to (sSecoes.Count - 1) do
  begin
    if Mais1Ini.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
    begin
      if AllTrim(sSecoes[I]) <> 'Supervisor' then
      begin
        //
        Z := Z + 1;
        //
        Component1             := TLabel.Create(Self);
        Component2             := TImage.Create(Self);
        //
        Component1.Parent      := Form1;
        Component2.Parent      := Form1;
        //
        Component1.Transparent := True;
        Component2.Transparent := True;
        Component1.visible     := True;
        Component2.visible     := True;
        //
        Component1.Font.Color  := clBlack;
        Component1.font.Name   := Label1.Font.Name;
        Component1.font.Size   := Label1.font.Size;
        Component1.Top         := (Z * 20);
        Component2.Top         := (Z * 20);
        Component1.Left        := 30;
        Component2.Left        := 10;
        Component1.Caption     := pChar(sSecoes[I]);
        //
        if Form1.Height < Component2.Top + 30 then Form1.Height := Form1.Height + 20;
        Component2.Picture := Image1.Picture;
        if Mais1Ini.ReadString(pChar(sSecoes[I]),'Ativo','Não') <> 'Não' then Component2.Picture := Image2.Picture;
        //
      end;
    end;
  end;
  //
  for I := 1 to 20 do
  begin
    DeleteFile('ALTE'+StrZero(I,4,0)+'.MDX');
    if FileExists('ALTE'+StrZero(I,4,0)+'.DBF') and FileExists('ALTE'+StrZero(I,4,0)+'.MDX') then
    begin
      //
      Z := Z + 1;
      //
      Component1             := TLabel.Create(Self);
      Component2             := TImage.Create(Self);
      Component1.Parent      := Form1;
      Component2.Parent      := Form1;
      Component1.Transparent := True;
      Component2.Transparent := True;
      Component1.visible     := True;
      Component2.visible     := True;
      //
      Component1.Font.Color  := clblack;
      Component1.font.Name   := Label1.Font.Name;
      Component1.font.Size   := Label1.font.Size;
      Component1.Parent      := Form1;
      Component2.Parent      := Form1;
      Component1.Top  := (Z * 15)+5;
      Component2.Top  := (Z * 15)+5;
      Component1.Left := 30;
      Component2.Left := 10;
      Component1.Caption := 'Usuário de frente de caixa';
      //
      if Form1.Height < Component2.Top + 15 then Form1.Height := Form1.Height + 15;
      //
      Component2.Picture := Image2.Picture;
      //
    end;
    //
  end;
  //
  Form1.Height := Form1.Height + 20;
  Form1.REpaint;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 sPar:string;
begin
  sPar:=ParamStr(1);
end;

end.

