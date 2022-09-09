unit Unit40;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SmallFunc, Mask;

type
  TForm40 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    MaskEdit1: TMaskEdit;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Memo2: TMemo;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form40: TForm40;

implementation

uses Unit7, Mais, Mais3;

{$R *.dfm}

procedure TForm40.FormActivate(Sender: TObject);
begin
  //
  Form1.Tag   := 0;
  Edit1.Text  := 'A/C <CONTATO>';      //
  //
  Form40.Color  := Form7.Color;
  Form40.Top    := Form7.Top;
  Form40.Height := Form7.Height;
  Form40.Width  := Form7.Width;
  Form40.Left   := Form7.Left;
  //
//  Memo1.Height     := Form7.Height - Memo1.Top - 80;
//  Memo1.Width      := Form7.Width  - Memo1.Left - 20;
  //
  Form40.CheckBox1.Top := Memo1.Top + Memo1.Height + 15;
  //
  if Form7.sModulo = 'RECEBER' then
  begin
     if Form40.Tag = 9 then
     begin
       if FileExists(LimpaNome(Senhas.UsuarioPub)+'_cobranca2.txt') then
       begin
         Form40.Memo1.Lines.LoadFromFile(LimpaNome(Senhas.UsuarioPub)+'_cobranca2.txt')
       end else
       begin
         if FileExists(Form1.sAtual+'\cobranca2.txt') then Form40.Memo1.Lines.LoadFromFile('cobranca2.txt')
       end;
     end else
     begin
       if FileExists(LimpaNome(Senhas.UsuarioPub)+'_cobranca.txt') then
       begin
         Form40.Memo1.Lines.LoadFromFile(LimpaNome(Senhas.UsuarioPub)+'_cobranca.txt')
       end else
       begin
         if FileExists(Form1.sAtual+'\cobranca.txt') then Form40.Memo1.Lines.LoadFromFile('cobranca.txt')
       end;
     end;
  end else
  begin
    if Copy(Form40.Caption,1,15) = 'Enviar WhatsApp' then
    begin
      if Copy(Form40.Caption,1,20) = 'Enviar WhatsApp para' then
      begin
        if FileExists(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp1.txt') then
        begin
          Form40.Memo1.Lines.LoadFromFile(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp1.txt');
        end else
        begin
          if FileExists(Form1.sAtual+'\WhatsApp.txt') then Form40.Memo1.Lines.LoadFromFile('WhatsApp1.txt')
        end;
      end else
      begin
        if FileExists(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp.txt') then
        begin
          Form40.Memo1.Lines.LoadFromFile(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp.txt');
        end else
        begin
          if FileExists(Form1.sAtual+'\WhatsApp.txt') then Form40.Memo1.Lines.LoadFromFile('WhatsApp.txt')
        end;
      end;
    end else
    begin
      if FileExists(LimpaNome(Senhas.UsuarioPub)+'_e-mail.txt') then
      begin
        Form40.Memo1.Lines.LoadFromFile(LimpaNome(Senhas.UsuarioPub)+'_e-mail.txt');
      end else
      begin
        if FileExists(Form1.sAtual+'\e-mail.txt') then Form40.Memo1.Lines.LoadFromFile('e-mail.txt')
      end;
    end;
  end;
  //
  if Form7.sModulo = 'RECEBER' then
  begin
    Form7.ibDataSet11.First;
  end;
  //
end;

procedure TForm40.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Form40.Memo1.Update;
  //
  if Form7.sModulo = 'RECEBER' then
  begin
    if Form40.Tag = 9 then
    begin
      Form40.Memo1.Lines.SaveToFile(LimpaNome(Senhas.UsuarioPub)+'_cobranca2.txt')
    end else
    begin
      Form40.Memo1.Lines.SaveToFile(LimpaNome(Senhas.UsuarioPub)+'_cobranca.txt')
    end;
  end else
  begin
    if Copy(Form40.Caption,1,15) = 'Enviar WhatsApp' then
    begin
      if Copy(Form40.Caption,1,20) = 'Enviar WhatsApp para' then
      begin
        Form40.Memo1.Lines.SaveToFile(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp1.txt');
      end else
      begin
        Form40.Memo1.Lines.SaveToFile(LimpaNome(Senhas.UsuarioPub)+'_WhatsApp.txt');
      end;
    end else
    begin
      Form40.Memo1.Lines.SaveToFile(LimpaNome(Senhas.UsuarioPub)+'_e-mail.txt');
    end;
  end;
  //
  Form40.CheckBox1.Visible      := False;
  Form40.Tag := 0;
  //
end;

procedure TForm40.Label3Click(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Title    := 'Selecionar o arquivo para enviar por e-mail.';
  OpenDialog1.Filter   := '*.jpg|*.jpg|*.bmp';
  OpenDialog1.Execute;
  //
  // ShowMessage(OpenDialog1.FileName);
  //
  Label3.Caption := 'Arquivo Anexado: '+OpenDialog1.FileName;
  CHDir(Form1.sAtual);
end;

procedure TForm40.Button1Click(Sender: TObject);
begin
  Form1.Tag := 1;
  Close;
end;

procedure TForm40.Button2Click(Sender: TObject);
begin
  Form1.Tag := 0;
  Close;
end;

end.

