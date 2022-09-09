unit ftpconect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Psock, NMFtp, StdCtrls, ComCtrls, ExtCtrls, SmallFunc, Db, DBTables, ShellApi,
  Grids, DBGrids, Gauges, NMpop3, NMsmtp;

type
  TForm1 = class(TForm)
    NMFTP1: TNMFTP;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DataSource1: TDataSource;
    Table1: TTable;
    Button5: TButton;
    Table1CONTATO: TStringField;
    Table1NOME: TStringField;
    Table1CIDADE: TStringField;
    Table1ESTADO: TStringField;
    Table1EMAIL: TStringField;
    Table1OBS: TStringField;
    Table1ULTIMACO: TDateField;
    Button6: TButton;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    Button7: TButton;
    Table1ATIVO: TBooleanField;
    NMSMTP1: TNMSMTP;
    Memo2: TMemo;
    Table1CREDITO: TFloatField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure NMFTP1Connect(Sender: TObject);
    procedure NMFTP1ConnectionFailed(Sender: TObject);
    procedure NMFTP1Disconnect(Sender: TObject);
    procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure NMFTP1Failure(var Handled: Boolean; Trans_Type: TCmdType);
    procedure NMFTP1InvalidHost(var Handled: Boolean);
    procedure NMFTP1Success(Trans_Type: TCmdType);
    procedure Button3Click(Sender: TObject);
    procedure NMFTP1ListItem(Listing: String);
    procedure Button4Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure NMSMTP1Connect(Sender: TObject);
    procedure NMSMTP1ConnectionFailed(Sender: TObject);
    procedure NMSMTP1ConnectionRequired(var Handled: Boolean);
    procedure NMSMTP1Disconnect(Sender: TObject);
    procedure NMSMTP1Failure(Sender: TObject);
    procedure NMSMTP1HeaderIncomplete(var handled: Boolean;
      hiType: Integer);
    procedure NMSMTP1HostResolved(Sender: TComponent);
    procedure NMSMTP1InvalidHost(var Handled: Boolean);
    procedure NMSMTP1Success(Sender: TObject);
    procedure NMSMTP1Status(Sender: TComponent; Status: String);
    procedure NMSMTP1SendStart(Sender: TObject);
    procedure NMSMTP1RecipientNotFound(Recipient: String);
    procedure NMSMTP1PacketSent(Sender: TObject);
  private
    { Private declarations }
    Q : Integer;
  public
    { Public declarations }
    sAtual : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function ValidaEmail(sP1: String):Boolean;
var
  I : Integer;
begin
  Result := False;
  if (Pos('@',sP1)<>0) then Result := True;
  if (Pos('@.',sP1)<>0) or
     (Pos('.@',sP1)<>0) or
     (Pos('..',sP1)<>0) then
  begin
    Result := False;
  end;
  //
  for I := 1 to 57 do
  begin
    if Pos(Copy(' "!#$%®*()+=^]}{,|?¡¿¬ƒ√…» ÀÕŒœ”‘’⁄‹«·‡‚‰„ÈËÍÎÌÓÔÛÙı˙¸Á*',I,1),AllTrim(sP1)) <> 0 then
    begin
      Result := False;
    end;
  end;
  //
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  NMFTP1.Host     := Edit3.Text;
  NMFTP1.Port     := 21;
  NMFTP1.Timeout  := 5000;
  NMFTP1.UserID   := Edit1.Text;  // Login
  NMFTP1.Password := Edit2.Text;  // Senha
  try
    NMFTP1.Connect;
    Q := 1;
    NMFTP1.List;
  except end;
  Screen.Cursor             := crDefault;
 
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  NMFTP1.Disconnect;
  Memo1.Text := '';
end;

procedure TForm1.NMFTP1Connect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Conectado a '+NMFTP1.Host +' Senha: '+ NMFTP1.Password;
  Q := 1;
  NMFTP1.List;

end;

procedure TForm1.NMFTP1ConnectionFailed(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Falha ao conectar.';
end;

procedure TForm1.NMFTP1Disconnect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Desconectado';
end;

procedure TForm1.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
  StatusBar1.SimpleText := 'Erro na conecÁ„o.';
end;

procedure TForm1.NMFTP1Failure(var Handled: Boolean; Trans_Type: TCmdType);
begin
  StatusBar1.SimpleText := 'Falha';
end;

procedure TForm1.NMFTP1InvalidHost(var Handled: Boolean);
begin
  StatusBar1.SimpleText := 'Invalid host';
end;

procedure TForm1.NMFTP1Success(Trans_Type: TCmdType);
begin
  StatusBar1.SimpleText := 'Ok';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Q := 1;
  NMFTP1.List;
end;

procedure TForm1.NMFTP1ListItem(Listing: String);
begin
  Memo1.Lines.Add(IntToStr(Q)+': '+Listing);
  Inc(Q);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  I  : Integer;
  //I, I1, I2, I3, I4, I5, I6, I7, I8 : Integer;
  // S : String;
  tInicio : TTime;
begin
  //
  ShortDateFormat := 'dd/mm/yy';
  tInicio := Time;
  //
  NMFTP1.Host     := Edit3.Text;
  NMFTP1.Port     := 21;
  NMFTP1.Timeout  := 500;
  NMFTP1.UserID   := Edit1.Text;
  //
  for I := 0 to 18000 do
  begin
    Edit2.Text      := DateTimeToStr(StrToDateTime('01/01/1950')+I);
    Label4.Caption  := Edit2.Text + '  ' + IntTostr(I);
    Edit2.Repaint;
    Label4.Repaint;
    Label5.Caption  := TimeToStr(Time - tInicio);  // Edit2.Text := 'ronei030'
    Label5.Repaint;
    NMFTP1.Password := Edit2.Text;
    try
      NMFTP1.Connect;
    except end;
  end;
  //
  //
{  S := ' qwertyuiopasdfghjklzxcvbnm0123456789';
  for I1 :=  1 to 37 do
  begin
    for I2 := 1 to 37 do
    begin
      for I3 := 1 to 37 do
      begin
        for I4 := 1 to 37 do
        begin
          for I5 := 2 to 37 do
          begin
            for I6 := 2 to 37 do
            begin
              for I7 := 2 to 37 do
              begin
                for I8 := 2 to 37 do
                begin
                  I := I + 1;

                  Label4.Caption := Edit2.Text + '  ' + IntTostr(I);

                  Label4.Repaint;

                  Edit2.Text := AllTrim(copy(S,I8,1)+copy(S,I7,1)+copy(S,I6,1)+copy(S,I5,1)+copy(S,I4,1)+copy(S,I3,1)+copy(S,I2,1)+copy(S,I1,1));
                  Edit2.Repaint;

//                  if I = 10 then
//                  begin
                    Label5.Caption := TimeToStr(Time - tInicio);  // Edit2.Text := 'ronei030'
                    Label5.Repaint;
//                  end;

                  NMFTP1.Password := Edit2.Text;
                  try
                    NMFTP1.Connect;
                  except end;

                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
}
  //
end;

procedure TForm1.Panel2Click(Sender: TObject);
begin
//  Close;
//  Halt(1);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  GetDir(0,sAtual);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  A, F: TextFile;
  I : Integer;
  sEstado, sLinha : String;
begin
  //
  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  //
  Table1.DisableControls;
  Table1.Active          := False;
  //
  Table1.DatabaseName    := sAtual;
  Table1.IndexName       := 'CLI_03';
  Table1.Active          := True;
  Table1.First;
  //
  while not Table1.EOF do
  begin
    //
    AssignFile(A,'REVENDA.HTM');
    Reset(A);
    //
    sEstado := UpperCase(Table1.FieldByname('ESTADO').AsString);
    DeleteFile(sEstado+'.HTM');
    AssignFile(F,sEstado+'.HTM');
    Rewrite(F);                  // Abre para gravaÁ„o
    //
    for I := 1 to 1000 do
    begin
      ReadLn(A,sLinha);
      if AllTrim(sLinha) = '<!--#includevirtual="revendas.txt"-->' then
      begin
        Writeln(F,'<p><font name=verdana size=2><b>Revendas cadastradas no<br>estado de '+Table1.FieldByname('ESTADO').AsString+'</font></b></br></br>');
        Writeln(F,'<table border=0 cellpadding=2 cellspacing=1>');
        Writeln(F,' <tr  bgcolor= #C0C0C0 align=left>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>Nome</font></th>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>Contato</font></th>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>MunicÌpio</font></th>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>UF</font></th>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>e-mail</font></th>');
        Writeln(F,'  <th nowrap><font name=verdana size=1>Destaque</font></th>');
        //
        while (sEstado = UpperCase(Table1.FieldByname('ESTADO').AsString)) and (not Table1.EOF) do
        begin
          if Pos('revenda',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0 then
          begin
            if (Table1.FieldByName('ULTIMACO').AsDateTime >= Date - StrToInt(ComboBox1.Text))
            or (Pos('curso 2002',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0)
            or (Pos('destaque 2002',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0)
            then
            begin
              Writeln(F,' <tr bgcolor=#E6E6E6>');
              Writeln(F,'  <td><font size=1>'+Table1.FieldByname('NOME').AsString+'<br></font></td>');
              Writeln(F,'  <td><font size=1>'+Table1.FieldByname('CONTATO').AsString+'<br></font></td>');
              Writeln(F,'  <td><font size=1>'+Table1.FieldByname('CIDADE').AsString+'<br></font></td>');
              Writeln(F,'  <td><font size=1>'+Table1.FieldByname('ESTADO').AsString+'<br></font></td>');
              Writeln(F,'  <td align=center><font size=1><a href="mailto:'+Table1.FieldByname('EMAIL').AsString+'?Subject=Tenho interesse no sistema Aplicativos Comerciais &body= &bcc=compu2@compufour.com.br"><img src="email.gif" border=0 alt="Mande um e-mail"<br></font></td>');
              Writeln(F,'  <td align="center" nowrap>');
              if Pos('curso 2002',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0 then Writeln(F,'   <img src="star.gif" border=0 alt="Participou do curso de revendas 2002">');
              if Pos('destaque 2002',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0 then Writeln(F,'   <img src="starr.gif" border=0 alt="Revenda destaque 2002">');
              Writeln(F,'  </td>');
            end;
          end;
          Table1.Next;
        end;
        //
        Writeln(F,' </tr>');
        Writeln(F,'</table>');
        Writeln(F,'<p><font name=verdana size=1>Atualizado em ConcÛrdia, '+DateToStr(Date)+' ‡s '+TimeToStr(Time));
        Label5.Caption := TimeToStr(Time);
        //
      end else Writeln(F,sLinha);
    end;
    //
    CloseFile(F);
    CloseFile(A);
    //
    // Table1.Next;
    //
  end;
  //
  Table1.Active          := False;
  Screen.Cursor             := crDefault;
  Button1.Enabled := True;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  //
  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  NMFTP1.Upload('AM.htm','am.htm');
  NMFTP1.List;

  NMFTP1.Upload('AL.htm','al.htm');
  NMFTP1.List;

  NMFTP1.Upload('AP.htm','ap.htm');
  NMFTP1.List;

  NMFTP1.Upload('AC.htm','ac.htm');
  NMFTP1.List;

  NMFTP1.Upload('BA.htm','ba.htm');
  NMFTP1.List;

  NMFTP1.Upload('CE.htm','ce.htm');
  NMFTP1.List;

  NMFTP1.Upload('DF.htm','df.htm');
  NMFTP1.List;

  NMFTP1.Upload('ES.htm','es.htm');
  NMFTP1.List;

  NMFTP1.Upload('GO.htm','go.htm');
  NMFTP1.List;

  NMFTP1.Upload('MA.htm','ma.htm');
  NMFTP1.List;

  NMFTP1.Upload('MG.htm','mg.htm');
  NMFTP1.List;

  NMFTP1.Upload('MT.htm','mt.htm');
  NMFTP1.List;

  NMFTP1.Upload('MS.htm','ms.htm');
  NMFTP1.List;

  NMFTP1.Upload('PA.htm','pa.htm');
  NMFTP1.List;

  NMFTP1.Upload('PB.htm','pb.htm');
  NMFTP1.List;

  NMFTP1.Upload('PE.htm','pe.htm');
  NMFTP1.List;

  NMFTP1.Upload('PI.htm','pi.htm');
  NMFTP1.List;

  NMFTP1.Upload('PR.htm','pr.htm');
  NMFTP1.List;

  NMFTP1.Upload('RJ.htm','rj.htm');
  NMFTP1.List;

  NMFTP1.Upload('RN.htm','rn.htm');
  NMFTP1.List;

  NMFTP1.Upload('RO.htm','ro.htm');
  NMFTP1.List;

  NMFTP1.Upload('RR.htm','rr.htm');
  NMFTP1.List;

  NMFTP1.Upload('RS.htm','rs.htm');
  NMFTP1.List;

  NMFTP1.Upload('SC.htm','sc.htm');
  NMFTP1.List;

  NMFTP1.Upload('SE.htm','se.htm');
  NMFTP1.List;

  NMFTP1.Upload('SP.htm','sp.htm');
  NMFTP1.List;

  NMFTP1.Upload('TO.htm','to.htm');
  NMFTP1.List;

  Screen.Cursor             := crDefault;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button1.Enabled := False;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button6.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if StatusBar1.SimpleText = 'Ok' then Button6.Enabled := True else Button6.Enabled := False;
  if StatusBar1.SimpleText = 'Ok' then Button2.Enabled := True else Button2.Enabled := False;
  Label8.Caption := TimeToStr(Time);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  I : Integer;
begin
  //
  // conectando SMTP
  //
  Memo2.Visible := True;
  //
//  NMSMTP1.Host                    := 'smtp.netcon.com.br';
//  NMSMTP1.Port   := 25;
//  NMSMTP1.UserID                  := 'compu4';
//  NMSMTP1.Connect;
  //
  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  //
  Table1.Active          := False;
  //
  Table1.DatabaseName    := sAtual;
  Table1.IndexName       := 'CLI_03';
  Table1.Active          := True;
  Table1.First;
  //
  I := 0;
  //
//  Table1.DisableControls;
//  while not Table1.EOF do
//  begin
//    StatusBar1.SimpleText := Table1NOME.AsString;
//    if Table1CREDITO.AsFloat > 15 then Table1.Delete else Table1.Next;
//  end;
  //
  Table1.First;
  //
  while not Table1.EOF do
  begin
    StatusBar1.SimpleText := Table1NOME.AsString;
    if ValidaEmail(Table1EMAIL.AsString)  then
    begin
      Memo2.Lines.Clear;
      //
//      I  := I + 1;
      //
      while not NMSMTP1.FConnected do
      begin
        ShowMessage('Tecle <enter> para conectar com smtp.netcon.com.br');
        NMSMTP1.Host                    := 'smtp.netcon.com.br';
        NMSMTP1.Port   := 25;
        NMSMTP1.UserID                  := 'compu4';
        NMSMTP1.Connect;
      end;
      //
      Memo2.Lines.Add('Ol· '+
      UpperCase(Copy(AllTrim(Table1CONTATO.AsString),1,1))+
      LowerCase(Copy( StrTran(AllTrim(Table1CONTATO.AsString),' ','!')
      +'!',2,Pos('!',StrTran(AllTrim(Table1CONTATO.AsString),' ','!')+'!')-1)+' ')
      );
      //
      Memo2.Lines.Add('');
      Memo2.Lines.Add('Queremos lhe apresentar o que h· de melhor em automaÁ„o comercial para pequenas empresas de comÈrcio. ');
      Memo2.Lines.Add('O software Aplicativos Comerciais È um sistema totalmente integrado para informatizar '
      +'frente de caixa e retaguarda.');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('Emiss„o de notas fiscais em formul·rio.');
      Memo2.Lines.Add('Emiss„o de Cupom Fiscal (ECF e TEF).');
      Memo2.Lines.Add('Controle de Estoque.');
      Memo2.Lines.Add('Contas a pagar e Contas a Receber, Livro caixa e Bancos.');
      Memo2.Lines.Add('Cadastro de Clientes e Fornecedores.');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('Mais de 25.000 empresas de comercio j· utilizam os nossos sistemas em todo o Brasil.');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('Saiba mais sobre este fant·stico software em www.compufour.com.br');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('O preÁo? sÛ R$ 248,00');
      Memo2.Lines.Add('');
//      Memo2.Lines.Add('Seu nome foi indicado por um amigo que visitou a nossa p·gina.');
      Memo2.Lines.Add('Se a automaÁ„o da sua empresa n„o est· bem resolvida, ou ainda n„o est· informatizada, ');
      Memo2.Lines.Add('ligue gratuitamente para 0800-490022.');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('');
      Memo2.Lines.Add('Adalberto Angelo Hinkel');
      Memo2.Lines.Add('vendas@compufour.com.br');
      Memo2.Lines.Add('www.compufour.com.br');
      Memo2.Repaint;
      NMSMTP1.PostMessage.FromAddress := 'vendas@compufour.com.br';
      NMSMTP1.PostMessage.FromName    := 'CompuFour Informatica Ltda';
      //
      NMSMTP1.PostMessage.ToAddress.Add(AllTrim(Table1EMAIL.AsString));
//      NMSMTP1.PostMessage.ToAddress.Add(AllTrim('ronei@compufour.com.br'));
      NMSMTP1.PostMessage.Subject      := 'Automacao para pequenas empresas de comercio.';
      NMSMTP1.PostMessage.Body.Assign(Memo2.Lines);
      NMSMTP1.SendMail;
//      if I >= 5 then Halt(1);
    end;
    Table1.Next;
  end;
{
    if Pos('revenda',LowerCase(Table1.FieldByName('OBS').AsString)) <> 0 then
    begin
//      I  := I + 1;
      //
      if (Table1ATIVO.AsBoolean = False) and (ValidaEmail(Table1EMAIL.AsString)) then
      begin
        Memo2.Lines.Clear;
        //
        Memo2.Lines.Add('Ol· '+Copy( StrTran(AllTrim(Table1CONTATO.AsString),' ','/')
        +'/',1,Pos('/',StrTran(AllTrim(Table1CONTATO.AsString),' ','/')+'/')-1)+'! ');
        //
        Memo2.Lines.Add('');
        if Table1ULTIMACO.AsDateTime > StrToDate('01/01/1995') then
        Memo2.Lines.Add('   Estive analisando a ficha da '+StrTran(StrTran(AllTrim(Table1NOME.AsString),'Ltda',''),'LTDA','')+' e verifiquei que a sua ˙ltima compra conosco foi em '+AllTrim(InttoStr(day(Table1ULTIMACO.AsDateTime)))+' de '+AllTrim(MesExtenso(Month(Table1ULTIMACO.AsDateTime)))+' de '+IntToStr(Year(Table1ULTIMACO.AsDateTime))+'.')
        else Memo2.Lines.Add('   Estive analisando a ficha da '+StrTran(StrTran(AllTrim(Table1NOME.AsString),'Ltda',''),'LTDA',''));
        if Table1ULTIMACO.AsDateTime < StrToDate('01/01/2001') then
        begin
          Memo2.Lines.Add('Faz tempo que n„o compra conosco, gostarÌamos de saber o motivo. Porque temos interesse em tÍ-lo como parceiro novamente.');
          Memo2.Lines.Add('J· estamos comercializando a vers„o 2001 dos Aplicativos Comerciais que est· bastante melhorada, inclusive com ORDEM DE SERVI«OS.');
        end;
        Memo2.Lines.Add('   Como est„o as vendas em '+AllTrim(Table1CIDADE.AsString)+'? Se precisar de alguma coisa estamos a disposiÁ„o.');
        if Table1ULTIMACO.AsDateTime < StrToDate('01/01/2001') then
          Memo2.Lines.Add('   Reativando a parceria quando alguÈm ligar de '+AllTrim(Table1CIDADE.AsString)+' interessado no Aplicativos Comerciais poderemos indicar a '+StrTran(StrTran(AllTrim(Table1NOME.AsString),'Ltda',''),'LTDA','')+'.')
        else Memo2.Lines.Add('   Quando alguÈm ligar de '+AllTrim(Table1CIDADE.AsString)+' interessado no Aplicativos Comerciais estaremos indicando a '+StrTran(StrTran(AllTrim(Table1NOME.AsString),'Ltda',''),'LTDA','')+'.');
        //
        Memo2.Lines.Add('');
        Memo2.Lines.Add('N„o perca a promoÁ„o do mÍs de Abril');
        Memo2.Lines.Add('Ligue gratuitamente para 0800-490022');
        Memo2.Lines.Add('');
        Memo2.Lines.Add('Adalberto Angelo Hinkel');
        Memo2.Lines.Add('adalberto@compufour.com.br');
        Memo2.Lines.Add('www.compufour.com.br');
        Memo2.Repaint;
        NMSMTP1.PostMessage.FromAddress := 'adalberto@compufour.com.br';
        NMSMTP1.PostMessage.FromName    := 'CompuFour Inform·tica Ltda';
        NMSMTP1.PostMessage.ToAddress.Add(AllTrim(Table1EMAIL.AsString));
        NMSMTP1.PostMessage.Subject      := 'Como vao as vendas?';
        NMSMTP1.PostMessage.Body.Assign(Memo2.Lines);
        NMSMTP1.SendMail;
//        ShowMessage(pChar('mailto:'+AllTrim(Table1EMAIL.AsString)
//        +'?Subject=Como v„o as vendas? &body='+sTexto+' &bcc='));
//        ShowMessage('Tecle ok para o prÛximo!');
      end;
//      if I >= 15 then Halt(1);
    end;
    Table1.Next;
  end;
}



  //
  // Desconectando SMTP
  //
  NMSMTP1.Disconnect;
  //
  Table1.Active   := False;
  Screen.Cursor   := crDefault;
  Button1.Enabled := True;
  Memo2.Visible := False;
  ShowMessage(IntToStr(I)+' email s enviados');
  //
end;

procedure TForm1.NMSMTP1Connect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Conectado a '+NMSMTP1.Host;
end;

procedure TForm1.NMSMTP1ConnectionFailed(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Falha ao conectar '+NMSMTP1.Host;
end;

procedure TForm1.NMSMTP1ConnectionRequired(var Handled: Boolean);
begin
  StatusBar1.SimpleText := 'Tentando se conectar '+NMSMTP1.Host;
end;

procedure TForm1.NMSMTP1Disconnect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Desconectado.';

end;

procedure TForm1.NMSMTP1Failure(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Falha ao se conectar com '+NMSMTP1.Host;
end;




procedure TForm1.NMSMTP1HeaderIncomplete(var handled: Boolean;
  hiType: Integer);
begin
  ShowMessage('Header Incomplete.');
end;

procedure TForm1.NMSMTP1HostResolved(Sender: TComponent);
begin
  StatusBar1.SimpleText := 'Host resolved';
end;

procedure TForm1.NMSMTP1InvalidHost(var Handled: Boolean);
begin
  StatusBar1.SimpleText := 'Invalid Host';
end;

procedure TForm1.NMSMTP1Success(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Success';
end;

procedure TForm1.NMSMTP1Status(Sender: TComponent; Status: String);
begin
  If StatusBar1 <> nil then
    StatusBar1.SimpleText := status;
end;

procedure TForm1.NMSMTP1SendStart(Sender: TObject);
begin
  StatusBar1.simpleText := 'Sending message';
end;

procedure TForm1.NMSMTP1RecipientNotFound(Recipient: String);
begin
  ShowMessage('Recipient "'+Recipient+'" not found');
end;

procedure TForm1.NMSMTP1PacketSent(Sender: TObject);
begin
  StatusBar1.SimpleText := IntToStr(NMSMTP1.BytesSent)+' bytes of '+IntToStr(NMSMTP1.BytesTotal)+' sent';

end;

end.




