unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  backup, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, IniFiles;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Backupfile1: TBackupFile;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    FileListBox: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    rgBackupMode: TRadioGroup;
    Label2: TLabel;
    EdBackupTitle: TEdit;
    BtnCancel: TButton;
    SaveDialog: TSaveDialog;
    Button5: TButton;
    Button6: TButton;
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Edit2: TEdit;
    rgRestoreMode: TRadioGroup;
    Label3: TLabel;
    rgCompressionLevel: TRadioGroup;
    gbRestorepath: TGroupBox;
    rbOrigpath: TRadioButton;
    rbOtherPath: TRadioButton;
    EdPath: TEdit;
    CbFullPath: TCheckBox;
    Edit1: TEdit;
    Label4: TLabel;
    CbSaveFileID: TCheckBox;
    MeFiles: TMemo;
    Image1: TImage;
    Image2: TImage;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Backupfile1Progress(Sender: TObject; Filename: String;
      Percent: TPercentage; var Continue: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure rbOrigpathClick(Sender: TObject);
    procedure Backupfile1Error(Sender: TObject; const Error: Integer;
      ErrString: String);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Backupfile1NeedDisk(Sender: TObject; DiskID: Word;
      var Continue: Boolean);
  private
  public
  end;

var
  Form1: TForm1;
  sDirDefault:String;
  ArquivoLista, ArquivoSaida:String;
  DriveDest:Byte;
  sTipo:string;

implementation

{$R *.DFM}

Function VerificaEspacoNoDisquete(Unidade:byte):Boolean;
var
  iButton,iResPesq:integer;
  bEnquanto:boolean;
  SearchRec:TSearchRec;
begin
   Result:=False;
   bEnquanto:=True;
   while bEnquanto do
   begin
     if DiskFree(Unidade) < 1400000 then
     begin
       iButton := Application.MessageBox('ATENÇÃO: Este disco não possui espaço suficiente ! '+chr(10)+
                                         'Para  APAGAR  os arquivos e prosseguir, clique SIM,'+chr(10)+
                                         'para trocar de disco, substitua-o  e clique  NÃO, e'+chr(10)+
                                         'para interromper clique CANCELAR' , 'Troca de Disco'
                                      , MB_ICONQUESTION+mb_YesNOCancel + mb_DefButton1);


       if iButton = IDCancel then // Aborta
        begin
          bEnquanto:=False;
        end
       else // apaga ou troca
        begin
          if iButton = IDYes then // apaga os arquivos
          begin
             iResPesq:=FindFirst(Chr(64+Unidade)+':\*.*',faAnyFile,SearchRec);
             while iResPesq=0 do
             begin
                DeleteFile(Chr(64+Unidade)+':\'+SearchRec.Name);
                iResPesq:=FindNext(SearchRec);
             end;
          end;
        end;
      end
     else // tem espaço resulta TRUE
      begin
        Result:=True;
        bEnquanto:=False;
      end;
   end; // while
end; // function



procedure TForm1.Button1Click(Sender: TObject);
var
   I: Integer;
begin
   if OpenDialog.execute then with FileListbox.items do
   begin
     beginupdate;
     for I := 0 to OpenDialog.files.count-1 do
       if indexof(lowercase(OpenDialog.files[i])) = -1 then
          add(lowercase(OpenDialog.files[i]));
     endupdate;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 sTemp:String;
 bContinue:Boolean;
 iButton:integer;
begin
     sTipo:='BACKUP';
     if Filelistbox.items.count = 0 then Showmessage('Nenhum arquivo Adicionado')
     else with SaveDialog do
     if ArquivoSaida = '' then
       if execute then ArquivoSaida := filename;
     if ArquivoSaida <> '' then
     begin
          //obtem o numero para o drive destino para verificar o espaço
          sTemp:=UpperCase(Copy(ArquivoSaida,1,1));
          DriveDest:=ord(sTemp[1])-64;

          bContinue:=False;
          //verifica se o arquivo existe
          if FileExists(ArquivoSaida) then
          begin
                iButton := Application.MessageBox('Já existe um arquivo gravado neste disco, Apagá-lo ?' , 'Troca de Disco'
                                   , MB_ICONQUESTION+mb_YesNO + mb_DefButton1);
                if iButton = IDYes then    {Apaga}
                begin
                   DeleteFile(ArquivoSaida);
                end;
          end;

          if VerificaEspacoNoDisquete(DriveDest) then bContinue:=True;


          if (uppercase(copy(ArquivoSaida, 1, 1)) = 'A') or (uppercase(copy(ArquivoSaida, 1, 1)) = 'B') then
          begin
//               Showmessage('Por favor, insira um disquete com espaço disponível');
               BackupFile1.maxSize := 1400000;  //backup to floppy
          end
          else BackupFile1.maxSize := 0;

          backupfile1.backuptitle      := EdBackupTitle.text;
          backupfile1.backupmode       := TBackupMode(rgBackupmode.itemindex);
          backupfile1.compressionLevel := TCompressionLevel(rgCompressionLevel.itemindex);
          backupfile1.SaveFileID       := CbSaveFileID.checked;

          if bContinue then
           begin
            if backupfile1.backup(filelistbox.items, ArquivoSaida) then
             begin
               Form1.Image1.Visible:=True;
               Form1.Image2.Visible:=False;
               Showmessage('Cópia bem sucedida. Taxa de compressão = '+inttostr(BackupFile1.compressionrate)+' %');
             end
            else
             begin
               Showmessage('Cópia com problemas ou abortada');
             end;
           end
          else
             Showmessage('Cópia abortada');

          Form1.Image2.Visible:=True;
          Form1.Image1.Visible:=False;
     end;
end;

procedure TForm1.Backupfile1Progress(Sender: TObject; Filename: String;
  Percent: TPercentage; var Continue: Boolean);
begin
     with Progressbar1 do
     begin
          visible := Percent < 100;
          if visible then position := Percent;
          StaticText1.visible:=Visible;
     end;
//        if Percent < 100 then Label1.caption := 'Processando... '+ExtractFileName(Filename) else Label1.caption := '';
//     if Percent < 100 then Label1.caption := Filename else Label1.caption := '';
     if Percent < 100 then StaticText1.caption := Filename else StaticText1.Visible:=False;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   S: string;
begin
     S := extractFilepath(application.exename)+'*.*';
     if InputQuery('Adicionar arquivos com coringas', 'Entre com o caminho + máscara de arquivo', S) then FileListBox.items.add(S);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     filelistbox.items.clear;
end;

procedure TForm1.BtnCancelClick(Sender: TObject);
begin
     if not BackupFile1.busy then close
     else if MessageDlg('Quer mesmo abortar a operação ?',mtConfirmation, [mbYes,mbNo], 0) = mrYes then Backupfile1.Stop;
end;

procedure TForm1.FileListBox1Click(Sender: TObject);
var
   files: tstringlist;
   I: integer;
   S, FA, SZ: string;
begin
     files := TStringlist.create;
     MeFiles.lines.clear;
     Edit2.text := backupfile1.getArchiveTitle(Filelistbox1.filename, files);
     if Edit2.text = '' then Edit1.text := ''
     else begin
       Edit1.text := inttostr(backupfile1.FilesTotal)+' Arquivos, '+inttostr(round(backupfile1.SizeTotal/1024))+' KB total';
       MeFiles.lines.beginupdate;
       for I := 0 to files.count-1 do
       begin
            S  := copy(files[i],1,pos(#9,Files[i])-1);  //file name
            FA := copy(files[i],pos(#9,Files[i])+1,pos('=',Files[i])-pos(#9,Files[i])-1);  //file age
            FA := DateToStr(
                  FileDateToDateTime(
                  StrtoInt(FA)       //integer file date is system + language independent!
                  ));
            SZ := copy(files[i],pos('=',Files[i])+1, length(Files[i])-pos('=',Files[i]));  //file size in Bytes
            MeFiles.lines.add(S + ' de ' + FA + ', ' + SZ + ' bytes');
       end;
       if files.count = 0 then MeFiles.lines.add('Não há maiores informações sobre este arquivo');
       MeFiles.lines.endupdate;
     end;
     files.free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   S: string;
begin
     sTipo:='RESTORE';
     backupfile1.Restoremode  := TRestoreMode(rgRestoreMode.itemindex);
     if rbOrigpath.checked then S := ''
     else begin
          S := EdPath.text;
          if trim(s) = '' then
          begin
               showmessage('Por favor, entre com o diretório destino');
               exit;
          end;
     end;
     backupfile1.restoreFullpath := cbFullpath.enabled and cbFullpath.checked;
     if backupfile1.restore(filelistbox1.filename, S) then
      begin
       // muda a imagem.
       Form1.Image1.Visible:=True;
       Form1.Image2.Visible:=False;
       showmessage('Restauração completada, '+inttostr(backupfile1.FilesProcessed)+' arquivos de '+inttostr(backupfile1.FilesTotal)+' restaurados');
      end
     else showmessage('Falha na restauração ou cancelado pelo usuário');
     Form1.Image1.Visible:=False;
     Form1.Image2.Visible:=False;
end;

procedure TForm1.rbOrigpathClick(Sender: TObject);
begin
     EdPath.enabled     := rbOtherPath.checked;
     cbFullPath.enabled := rbOtherPath.checked;
end;

procedure TForm1.Backupfile1Error(Sender: TObject; const Error: Integer;
  ErrString: String);
begin
   showmessage(ErrString);
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  Inicio:TIniFile;
begin
  sTipo:='BACKUP';
  GetDir(0,sDirDefault);
  Inicio:=TIniFile.Create(sDirDefault+'\sma.ini');
  ArquivoLista := Inicio.ReadString('Lista','Nome Lista','');
  ArquivoSaida := Inicio.ReadString('Lista','Nome Saida','');
  Inicio.Free;
  if (FileExists(ArquivoLista)) and (ArquivoSaida <> '')then
  begin
     Filelistbox.Items.LoadFromFile(sDirDefault+'\'+ArquivoLista);
     //=====
     if Filelistbox.items.count > 0 then
        Form1.Button2Click(Sender);
  end;
  //zera o arquivo de saida para não executar de novo
  ArquivoSaida:='';
end;

procedure TForm1.FormActivate(Sender: TObject);
//var
//  sTemp:String;
begin
{  if (FileExists(ArquivoLista)) and (ArquivoSaida <> '')then
  begin
     Filelistbox.Items.LoadFromFile(sDirDefault+'\'+ArquivoLista);
     //=====
     if Filelistbox.items.count = 0 then Showmessage('Nenhum arquivo adicionado')
     else
     begin
          //obtem o numero para o drive destino para verificar o espaço
          sTemp:=UpperCase(Copy(ArquivoSaida,1,1));
          DriveDest:=ord(sTemp[1])-64;

          if uppercase(copy(ArquivoSaida, 1, 1)) = 'A' then
          begin
               Showmessage('Por favor, insira um disquete com espaço disponível');
               BackupFile1.maxSize := 1400000;  //backup to floppy
          end
          else BackupFile1.maxSize := 0;

          backupfile1.backuptitle      := EdBackupTitle.text;
          backupfile1.backupmode       := TBackupMode(rgBackupmode.itemindex);
          backupfile1.compressionLevel := TCompressionLevel(rgCompressionLevel.itemindex);
          backupfile1.SaveFileID       := CbSaveFileID.checked;

          if backupfile1.backup(filelistbox.items, ArquivoSaida) then
           begin
             Form1.Image1.Visible:=True;
             Form1.Image2.Visible:=False;
             Showmessage('Cópia bem sucedida. Taxa de compressão = '+inttostr(BackupFile1.compressionrate)+' %');
           end
          else
           begin
             Showmessage('Cópia com problemas ou abortada');
           end;
          Form1.Image2.Visible:=True;
          Form1.Image1.Visible:=False;
     end;

   // ======

  end;
  ArquivoLista:='';
  ArquivoSaida:='';}
end;

procedure TForm1.Backupfile1NeedDisk(Sender: TObject; DiskID: Word;
  var Continue: Boolean);
//  var
//    bEnquanto:Boolean;
//    iButton,ResPesq:Integer;
//    SearchRec:TSearchRec;
begin
  if sTipo = 'RESTORE' then
   begin
      showmessage(Format(cInsertDisk, [inttostr(DiskID)]));
   end
  else //BACKUP
   begin
     Continue:=VerificaEspacoNoDisquete(DriveDest);
{
     bEnquanto:=True;
     while bEnquanto do
     begin
        showmessage(Format(cInsertDisk, [inttostr(DiskID)]));
        if DiskFree(DriveDest) < 1400000 then
         begin
           iButton := Application.MessageBox('ATENÇÃO: Este disco não possui espaço suficiente ! '+chr(10)+
                                             'Para  APAGAR  os arquivos e prosseguir, clique SIM,'+chr(10)+
                                             'para trocar de disco, substitua-o  e clique  NÃO, e'+chr(10)+
                                             'para interromper clique CANCELAR' , 'Troca de Disco'
                                      , MB_ICONQUESTION+mb_YesNOCancel + mb_DefButton1);


           if iButton = IDCancel then // Aborta
            begin
              Continue:=False;
              bEnquanto:=False;
            end
           else
            begin
              if iButton = IDYes then // apaga os arquivos
              begin
                 ResPesq:=FindFirst(Chr(64+DriveDest)+':\*.*',faAnyFile,SearchRec);
                 while ResPesq=0 do
                 begin
                    DeleteFile(Chr(64+DriveDest)+':\'+SearchRec.Name);
                    ResPesq:=FindNext(SearchRec);
                 end;
              end;
            end;
         end
        else
          begin
            Continue:=True;
            bEnquanto:=False;
          end;
     end;}
   end;
end;

end.
