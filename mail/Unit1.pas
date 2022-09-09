unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Psock, NMsmtp, ExtCtrls, IniFiles, Smallfunc;

type
  TForm1 = class(TForm)
    NMSMTP1: TNMSMTP;
    Panel1: TPanel;
    procedure Panel1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

procedure TForm1.Panel1Click(Sender: TObject);
var
  I, II, III : Integer;
  Mais1Ini : tIniFile;
  tArquivosAtachados : TStringList;
begin
  //
  try
    if AllTrim(ParamStr(1)) <> '' then
    begin
    //  ShowMessage('Para: '+ParamStr(1)+chr(10)+
    //              'Assunto: '+ParamStr(2)+chr(10)+
    //              'Mensagem:'+ParamStr(3)+chr(10)+
    //              'Anexo:'+ParamStr(4));
      //
      Mais1ini               := TIniFile.Create('FRENTE.INI');
      //
      if (Mais1Ini.ReadString('Mail','Host','') = '') or (Mais1Ini.ReadString('Mail','UserID','')='') or (Mais1Ini.ReadInteger('Mail','Port',25)=0) then
      begin
        ShowMessage('No programa de retaguarda entre em configurações clique na aba email e configure seu servidor de e-mail');
        Winexec('TASKKILL /F /IM mail.exe' , SW_HIDE );
      end;
      //
      //
      tArquivosAtachados := TStringList.Create;
      //
      if AllTrim(ParamStr(4))<>'' then tArquivosAtachados.Add(pChar(ParamStr(4)));
      if AllTrim(ParamStr(5))<>'' then tArquivosAtachados.Add(pChar(ParamStr(5)));
      Form1.NMSMTP1.PostMessage.Attachments := tArquivosAtachados;
      //
      Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
      //
      try
        while not Form1.NMSMTP1.FConnected do
        begin
          Form1.NMSMTP1.Host                    := Mais1Ini.ReadString('Mail','Host','');
          Form1.NMSMTP1.UserID                  := Mais1Ini.ReadString('Mail','UserID','');   // 'ronei@smallsoft.com.br';
          Form1.NMSMTP1.Port                    := Mais1Ini.ReadInteger('Mail','Port',25);
//          Form1.NMSMTP1.Password                := Mais1Ini.ReadString('Mail','Password','');
          //
          // ShowMEssage(Mais1Ini.ReadString('Mail','Host','')+chr(10)+
          //             Mais1Ini.ReadString('Mail','UserID','')+chr(10)+
          //             Mais1Ini.ReadString('Mail','Port','25'));
          //
          Form1.NMSMTP1.SubType    := mtHtml; // mtPlain, mtEnriched, mtSgml, mtTabSeperated, mtHtml
          Form1.NMSMTP1.EncodeType := uuMime;
          Form1.NMSMTP1.Connect;
          //
        end;
        //
        Form1.NMSMTP1.PostMessage.FromAddress := Mais1Ini.ReadString('Mail','From','');
        Form1.NMSMTP1.PostMessage.FromName    := Mais1Ini.ReadString('Mail','Name','');
        //
        II    := 1;
        III   := 0;
        //
        for I := 1 to length(ParamStr(1)+';') do
        begin
          III := III + 1;
          if Copy(ParamStr(1)+';',I,1)=';' then
          begin
            //
            Form1.NMSMTP1.PostMessage.ToAddress.Add(Copy(ParamStr(1)+';',II,III-1));
            //
            // ShowMessage(Copy(ParamStr(1)+';',II,III-1));
            //
            II := I+1;
            III := 0;
          end;
        end;
        //
    //    Form1.NMSMTP1.PostMessage.ToAddress.Add(ParamStr(1));
        Form1.NMSMTP1.PostMessage.Subject     := ConverteAcentos(ParamStr(2));
        Form1.NMSMTP1.PostMessage.Body.Add(ConverteAcentos(ParamStr(3)));
    {
        Form1.NMSMTP1.PostMessage.ToAddress.Add('ronei@smallsoft.com.br');
        Form1.NMSMTP1.PostMessage.Subject     := 'Assunto';
        Form1.NMSMTP1.PostMessage.Body.Add('Mensagem');
    }
        Form1.NMSMTP1.SendMail;
        Form1.NMSMTP1.Disconnect;
        //
      except end;
      //
      Screen.Cursor   := crDefault;
      //
    end;
  except end;
  //
  Winexec('TASKKILL /F /IM mail.exe' , SW_HIDE );
  Winexec('TASKKILL /F /IM email.exe' , SW_HIDE );
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Form1.Panel1Click(Sender);
end;

procedure TForm1.Panel1DblClick(Sender: TObject);
begin
  Winexec('TASKKILL /F /IM mail.exe' , SW_HIDE );
  Winexec('TASKKILL /F /IM email.exe' , SW_HIDE );
end;

end.
