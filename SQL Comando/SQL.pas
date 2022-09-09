unit SQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, Grids, DBGrids, StdCtrls, ExtCtrls,
  IBDatabase, XPMan, SMALLFunc, ShellApi, Winsock, IniFiles;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    Panel1: TPanel;
    Edit1: TEdit;
    IBDataSet1: TIBDataSet;
    DataSource1: TDataSource;
    XPManifest1: TXPManifest;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sComandoAnterior : String;
    sComandos : array[0..1000] of String;
    iI, iJ : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetIP:string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^  do
  begin
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  iI := 0;
  iJ := 0;
  Edit1.Top := 0;
  Edit1.Left := 190;
  Edit1.Width := Panel1.Width;
  Edit1.Height := Panel1.Height;  //
  //
  Form1.Button4.Left           := Form1.Button3.Left + Form1.Button3.Width +1;
  Form1.Button5.Left           := Form1.Button4.Left + Form1.Button4.Width +1;
  Form1.Button6.Left           := Form1.Button5.Left + Form1.Button5.Width +1;
  Form1.Button7.Left           := Form1.Button6.Left + Form1.Button6.Width +1;
  Form1.Edit1.Left             := Form1.Button7.Left + Form1.Button7.Width +1;
  //
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(16) then
  begin
    Form1.Button2Click(Sender);
  end;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_REturn then
  begin
    Form1.Button1Click(Sender);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
  sFields, sAtual, Url, IP, Alias, sArquivo, sDelete, sUpdate, sInsert : String;
  I : Integer;
begin
  //
  GetDir(0,sAtual);
  //
  if not IBTransaction1.Active then
  begin
    //
    try
      //
      IBDatabase1.Close;
      IBDatabase1.Params.Clear;
      IbDatabase1.DatabaseName := Edit1.Text;
      IBDatabase1.Params.Add('USER_NAME=SYSDBA');
      IBDatabase1.Params.Add('PASSWORD=masterkey');
      IbDatabase1.Open;
      IBTransaction1.Active := True;
      Edit1.Text := '';
      //
    except
      //
      Mais1Ini := TIniFile.Create(sAtual+'\small.ini');
      Url      := Mais1Ini.ReadString('Firebird','Server url','');
      IP       := AllTrim(Mais1Ini.ReadString('Firebird','Server IP',''));
      Alias    := AllTrim(Mais1Ini.ReadString('Firebird','Alias',''));
      //
      if IP = '' then IP := GetIp;
      //
      if IP <> '' then Url := IP+':'+Url+'\small.gdb' else Url:= Url+'\small.gdb';
      //
      if Alltrim(Alias) <> '' then
      begin
        Url := IP+':'+Alias;
      end;
      //
      Mais1Ini.Free;
      //
      try
        IBDatabase1.Close;
        IBDatabase1.Params.Clear;
        IbDatabase1.DatabaseName := Url;
        IBDatabase1.Params.Add('USER_NAME=SYSDBA');
        IBDatabase1.Params.Add('PASSWORD=masterkey');
        IbDatabase1.Open;
        IBTransaction1.Active := True;
      except end;
      //
    end;
  end;
  //
  if (UpperCase(Edit1.Text) = 'EXIT') or  (UpperCase(Edit1.Text) = 'QUIT') then
  begin
    Close;
  end else
  begin
    try
      //
      Form1.IBDataSet1.Close;
      Form1.IBDataSet1.SelectSQL.Clear;
      Form1.IBDataSet1.SelectSQL.Add(Edit1.Text);
      Form1.IBDataSet1.Open;
      //
      if  (Pos('SELECT',UpperCase(ibDataSet1.SelectSQL.Text)) <> 0)
      and (Pos('SUM(',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos('GROUP BY',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos('RDB$',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos('HASHS',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos(',',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos('.',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      and (Pos('COMMIT',UpperCase(ibDataSet1.SelectSQL.Text)) = 0)
      then
      begin
        //
        sArquivo := Copy(ibDataSet1.SelectSQL.Text+Replicate(' ',2000),pos('from',LowerCase(ibDataSet1.SelectSQL.Text))+5,2000);
        sArquivo := strTran(Copy(sArquivo,1,Pos(' ',sArquivo)),',','');
        //
        sDelete := 'delete from '+sArquivo+' where REGISTRO=:OLD_REGISTRO';
        sUpdate := 'update '+sArquivo+' set ';
        sInsert := 'insert into '+sArquivo+' ';
        sFields := '';
        //
        for I := 0 to ibDataSet1.FieldCount -1 do
        begin
          sUpdate := sUpdate + ibDataSet1.Fields[I].FieldName + '=:'+ibDataSet1.Fields[I].FieldName;
          sFields := sFields + ':'+ ibDataSet1.Fields[I].FieldName;
          if I = ibDataSet1.FieldCount -1 then sUpdate := sUpdate + ' ' else sUpdate := sUpdate + ', ';
          if I = ibDataSet1.FieldCount -1 then sFields := sFields + ' ' else sFields := sFields + ', ';
        end;
        //
        sUpdate := sUpdate + ' where REGISTRO=:OLD_REGISTRO';
        //
        sInsert := sInsert +'('+StrTran(sFields,':','')+') values ('+sFields+')';
        // ShowMEssage(sInsert);
        //
        ibDataSet1.Close;
        ibDataSet1.DeleteSQL.Clear;
        ibDataSet1.ModifySql.Clear;
        ibDataSet1.DeleteSQL.Add(sDelete);
        ibDataSet1.ModifySql.Add(sUpdate);
        // ibDataSet1.InsertSql.Add(sInsert);
        ibDataSet1.Open;
        //
      end;
      //
      if  (Pos('SELECT',UpperCase(ibDataSet1.SelectSQL.Text)) <> 0) then
      begin
        sComandoAnterior := ibDataSet1.SelectSQL.Text;
      end else
      begin
        if sComandoAnterior <> '' then
        begin
          Form1.IBDataSet1.Close;
          Form1.IBDataSet1.SelectSQL.Clear;
          Form1.IBDataSet1.SelectSQL.Add(sComandoAnterior);
          Form1.IBDataSet1.Open;
        end;
      end;
      //
      iI := iI + 1;
      iJ := iI;
      sComandos[iI] := Edit1.Text;
      Edit1.Text    := '';
      //
    except end;
    //
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I : Integer;
  F : TextFile;
  vTotal: array [0..200] of Double;  // Cria uma matriz com 100 elementos
begin
  //
  DeleteFile('c:\teste.txt');
  AssignFile(F,'c:\teste.txt');
  Rewrite(F);
  //
  for I := 0 to dbGrid1.FieldCount -1 do
  begin
    Write(F,Copy(dbGrid1.Fields[I].DisplayName+Replicate(' ',dbGrid1.Fields[I].DisplayWidth),1,dbGrid1.Fields[I].DisplayWidth)+' ');
  end;
  WriteLn(F,'');
  //
  for I := 0 to dbGrid1.FieldCount -1 do
  begin
    Write(F,Replicate('-',dbGrid1.Fields[I].DisplayWidth)+' ');
  end;
  WriteLn(F,'');
  //
  //
  for I := 1 to 200 do vTotal[I] := 0;
  //
  ibDataSet1.DisableControls;
  ibDataSet1.First;
  while not Form1.ibDataSet1.Eof do
  begin
    //
    begin
      for I := 0 to dbGrid1.FieldCount -1 do
      begin
        if dbGrid1.Fields[I].DataType = ftFloat then
        begin
          Write(F,Format('%'+IntToStr(dbGrid1.Fields[I].DisplayWidth)+'.4n',[dbGrid1.Fields[I].asFloat])+' ');
          vTotal[I] := vTotal[I] + dbGrid1.Fields[I].AsFloat;
        end else
        begin
          if dbGrid1.Fields[I].DisplayName =  'FOTO' then
          begin
            Write(F,'FOTO');
          end else
          begin
            Write(F,Copy(dbGrid1.Fields[I].asString+Replicate(' ',250),1,dbGrid1.Fields[I].DisplayWidth)+' ');
          end;
        end;
      end;
      //
      WriteLn(F,'');
      //
    end;
    //
    Form1.ibDataSet1.Next;
    //
  end;
  ibDataSet1.EnableControls;
  //
  begin
    //
    for I := 0 to dbGrid1.FieldCount -1 do
    begin
      if dbGrid1.Fields[I].DataType = ftFloat then
      begin
        Write(F,Replicate('-',dbGrid1.Fields[I].DisplayWidth)+' ');
      end else
      begin
        Write(F,Replicate(' ',dbGrid1.Fields[I].DisplayWidth)+' ');
      end;
    end;
    WriteLn(F,'');
    //
    for I := 0 to dbGrid1.FieldCount -1 do
    begin
      if dbGrid1.Fields[I].DataType = ftFloat then
      begin
        Write(F,Format('%'+IntToStr(dbGrid1.Fields[I].DisplayWidth)+'.4n',[vTotal[I]])+' ');
      end else
      begin
        Write(F,Replicate(' ',dbGrid1.Fields[I].DisplayWidth)+' ');
      end;
    end;
    WriteLn(F,'');
    CloseFile(F);
    //
    if FileExists('c:\teste.txt') then ShellExecute( 0, 'Open',pChar('c:\teste.txt'),'', '', SW_SHOW);
    //
  end;
  //
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  iJ := iJ + 1;
  if iJ > iI then iJ := iI+1;
  Edit1.Text := sComandos[iJ];
  Edit1.SetFocus;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  iJ := iJ - 1;
  if iJ < 1 then iJ := 1;
  Edit1.Text := sComandos[iJ];
  Edit1.SetFocus;
  
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Form1.Edit1.Font.Size        := Edit1.Font.Size +1;
  Form1.DBGrid1.Font.Size      := Edit1.Font.Size;
  Form1.DBGrid1.TitleFont.Size := Edit1.Font.Size;
  Form1.Panel1.Height          := Form1.Edit1.Height +1;
  //
  Form1.Button3.Font.Size      := Edit1.Font.Size;
  Form1.Button4.Font.Size      := Edit1.Font.Size;
  Form1.Button5.Font.Size      := Edit1.Font.Size;
  Form1.Button6.Font.Size      := Edit1.Font.Size;
  Form1.Button7.Font.Size      := Edit1.Font.Size;
  //
  Form1.Button3.Height          := Form1.Button3.Height +1;
  Form1.Button4.Height          := Form1.Button4.Height +1;
  Form1.Button5.Height          := Form1.Button5.Height +1;
  Form1.Button6.Height          := Form1.Button6.Height +1;
  Form1.Button7.Height          := Form1.Button7.Height +1;
  //
  Form1.Button3.Width          := Form1.Button3.Width +1;
  Form1.Button4.Width          := Form1.Button4.Width +1;
  Form1.Button5.Width          := Form1.Button5.Width +1;
  Form1.Button6.Width          := Form1.Button6.Width +1;
  Form1.Button7.Width          := Form1.Button7.Width +1;
  //
  Form1.Button4.Left           := Form1.Button3.Left + Form1.Button3.Width +1;
  Form1.Button5.Left           := Form1.Button4.Left + Form1.Button4.Width +1;
  Form1.Button6.Left           := Form1.Button5.Left + Form1.Button5.Width +1;
  Form1.Button7.Left           := Form1.Button6.Left + Form1.Button6.Width +1;
  Form1.Edit1.Left             := Form1.Button7.Left + Form1.Button7.Width +1;
  //
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  //
  Form1.Edit1.Font.Size        := Edit1.Font.Size -1;
  Form1.DBGrid1.Font.Size      := Edit1.Font.Size;
  Form1.DBGrid1.TitleFont.Size := Edit1.Font.Size;
  Form1.Panel1.Height          := Form1.Edit1.Height -1;
  //
  Form1.Button3.Font.Size      := Edit1.Font.Size;
  Form1.Button4.Font.Size      := Edit1.Font.Size;
  Form1.Button5.Font.Size      := Edit1.Font.Size;
  Form1.Button6.Font.Size      := Edit1.Font.Size;
  Form1.Button7.Font.Size      := Edit1.Font.Size;
  //
  Form1.Button3.Height          := Form1.Button3.Height -1;
  Form1.Button4.Height          := Form1.Button4.Height -1;
  Form1.Button5.Height          := Form1.Button5.Height -1;
  Form1.Button6.Height          := Form1.Button6.Height -1;
  Form1.Button7.Height          := Form1.Button7.Height -1;
  //
  Form1.Button3.Width          := Form1.Button3.Width -1;
  Form1.Button4.Width          := Form1.Button4.Width -1;
  Form1.Button5.Width          := Form1.Button5.Width -1;
  Form1.Button6.Width          := Form1.Button6.Width -1;
  Form1.Button7.Width          := Form1.Button7.Width -1;
  //
  Form1.Button4.Left           := Form1.Button3.Left + Form1.Button3.Width -1;
  Form1.Button5.Left           := Form1.Button4.Left + Form1.Button4.Width -1;
  Form1.Button6.Left           := Form1.Button5.Left + Form1.Button5.Width -1;
  Form1.Button7.Left           := Form1.Button6.Left + Form1.Button6.Width -1;
  Form1.Edit1.Left             := Form1.Button7.Left + Form1.Button7.Width -1;
  //
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Edit1.Text := GetIp;
  Form1.OpenDialog1.Execute;
  Edit1.Text := Edit1.Text + ':' + Form1.OpenDialog1.FileName;
  Form1.Button1Click(Sender);
  Edit1.Text := 'select RDB$RELATION_NAME from RDB$RELATIONS where (RDB$SYSTEM_FLAG = 0 OR RDB$SYSTEM_FLAG IS NULL) and (RDB$VIEW_SOURCE IS NULL) order by RDB$RELATION_ID';
  Form1.Button1Click(Sender);
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  if Form1.DBGrid1.Fields[0].DisplayName = 'RDB$RELATION_NAME' then
  begin
    Form1.Edit1.Text := 'select * from '+UpperCase(Form1.DBGrid1.Fields[0].Value);
    Form1.Button1Click(Sender);
  end;
end;

procedure TForm1.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
  if Form1.DBGrid1.Fields[0].DisplayName = 'RDB$RELATION_NAME' then
  begin
    Form1.Edit1.Text := 'select * from '+UpperCase(Form1.DBGrid1.Fields[0].Value);
  end;

end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    if Form1.DBGrid1.Fields[0].DisplayName = 'RDB$RELATION_NAME' then
    begin
      Form1.Edit1.Text := 'select * from '+UpperCase(Form1.DBGrid1.Fields[0].Value);
      Form1.Button1Click(Sender);
    end;
  end;

end;

procedure TForm1.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  //
  if Key = chr(6) then
  begin
    InputBox('Procurar por','','');
    ShowMessage('Ainda não esta pronto');
  end;
  //
  if Key = chr(16) then
  begin
    Form1.Button2Click(Form1.Button2);
  end;
  //

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  sComandoAnterior := '';
end;

end.
