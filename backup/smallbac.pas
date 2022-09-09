unit smallbac;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  backup, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, IniFiles, Grids,  DirOutln, ImgList;

type
  TForm1 = class(TForm)
    OpenDialog: TOpenDialog;
    Backupfile1: TBackupFile;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    FileListBox: TListBox;
    ButtonAdicionaArquivos: TButton;
    ButtonCriaArquivo: TButton;
    ButtonAdicionaMascara: TButton;
    Panel1: TPanel;
    ButtonRestaura: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    rgBackupMode: TRadioGroup;
    Label2: TLabel;
    EdBackupTitle: TEdit;
    BtnCancel: TButton;
    SaveDialog: TSaveDialog;
    ButtonApagaArquivos: TButton;
    Button6: TButton;
    FileListBox1: TFileListBox;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Edit2: TEdit;
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
    ButtonVisualizar: TButton;
    ImageList1: TImageList;
    procedure ButtonAdicionaArquivosClick(Sender: TObject);
    procedure ButtonCriaArquivoClick(Sender: TObject);
    procedure Backupfile1Progress(Sender: TObject; Filename: String;
      Percent: TPercentage; var Continue: Boolean);
    procedure ButtonAdicionaMascaraClick(Sender: TObject);
    procedure ButtonApagaArquivosClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure ButtonRestauraClick(Sender: TObject);
    procedure rbOrigpathClick(Sender: TObject);
    procedure Backupfile1Error(Sender: TObject; const Error: Integer;
      ErrString: String);
    procedure FormCreate(Sender: TObject);
    procedure Backupfile1NeedDisk(Sender: TObject; DiskID: Word;
      var Continue: Boolean);
    procedure FileListBoxKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonVisualizarClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
  sDirDefault:String;
  ArquivoLista, ArquivoSaida, ArquivoOriginal, CaminhoDestino:String;
  bSplash, bMostraMensagemFinal:boolean;
  DriveDest:Byte;
  sTipo:string;

implementation

uses FormCoringas, Abertura;

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
       if DiskFree(Unidade) <= 0 then
         begin
          iButton := Application.MessageBox('ATENÇÃO: Coloque um disco com  espaço suficiente e clique SIM'+chr(10)+
                                            'para continuar. Para interromper clique NÃO ou CANCELA' , 'Troca de Disco'
                                         , MB_ICONQUESTION+mb_YesNOCancel + mb_DefButton1);
          if iButton=IdNO then iButton:=IdCancel;
          if iButton=IdYes then iButton:=IdNo;
         end
       else

          iButton := Application.MessageBox('ATENÇÃO: Este disco não possui espaço suficiente,  '+chr(10)+
                                            'para  APAGAR  os arquivos e prosseguir, clique SIM,'+chr(10)+
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



procedure TForm1.ButtonAdicionaArquivosClick(Sender: TObject);
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

procedure TForm1.ButtonCriaArquivoClick(Sender: TObject);
var
 sTemp:String;
 bContinue:Boolean;
 iButton,i:integer;
begin
     Screen.Cursor := crHourglass;
     // desativa os outros botões
     PageControl1.Pages[1].TabVisible:=False;
     ButtonCriaArquivo.Enabled:=False;
     ButtonAdicionaArquivos.Enabled:=False;
     ButtonAdicionaMascara.Enabled:=False;
     ButtonApagaArquivos.Enabled:=False;
     //
     sTipo:='BACKUP';
     //se for maior que 0 apaga os __KYT*.DBF
     if Filelistbox.items.count > 0 then
     begin
        for I := FileListBox.Items.Count-1 downto 0 do
        begin
//          showmessage(FileListBox.Items.Strings[i]);
          if Pos('__KYT',AnsiUpperCase(FileListBox.Items.Strings[i])) > 0  then
          begin
            Filelistbox.Items.Delete(I);
          end;
        end;
     end;
     if Filelistbox.items.count = 0 then Showmessage('Nenhum arquivo Adicionado')
     else
      begin
        with SaveDialog do
          if ArquivoSaida = '' then
            if execute then ArquivoSaida := filename;
      end;
     if ArquivoSaida <> '' then
     begin
          //obtem o numero para o drive destino para verificar o espaço
          sTemp:=UpperCase(Copy(ArquivoSaida,1,1));
          DriveDest:=ord(sTemp[1])-64;
          bContinue:=False;
          //verifica se o arquivo existe
          if FileExists(ArquivoSaida) then
          begin
                iButton := Application.MessageBox('Já existe um arquivo gravado neste disco, apagá-lo ?' , 'Troca de Disco'
                                   , MB_ICONQUESTION+mb_YesNO + mb_DefButton1);
                if iButton = IDYes then    {Apaga}
                begin
                   DeleteFile(ArquivoSaida);
                end;
          end;
          if not FileExists(ArquivoSaida) then
             if VerificaEspacoNoDisquete(DriveDest) then bContinue:=True;


          if (uppercase(copy(ArquivoSaida, 1, 1)) = 'A') or (uppercase(copy(ArquivoSaida, 1, 1)) = 'B') then
          begin
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
               if bMostraMensagemFinal then
                 Showmessage('Cópia bem sucedida. Taxa de compressão = '+inttostr(BackupFile1.compressionrate)+' %');
             end
            else
             begin
               Showmessage('Cópia com problemas ou abortada');
             end;
           end
          else
             Showmessage('Cópia abortada');
          ArquivoSaida:='';
          Form1.Image2.Visible:=True;
          Form1.Image1.Visible:=False;
     end;
     Screen.Cursor := crDefault;
     // desativa os outros botões
     ButtonAdicionaArquivos.Enabled:=True;
     ButtonAdicionaMascara.Enabled:=True;
     ButtonApagaArquivos.Enabled:=True;
     ButtonCriaArquivo.Enabled:=True;
     PageControl1.Pages[1].TabVisible:=True;
end;

procedure TForm1.Backupfile1Progress(Sender: TObject; Filename: String;
  Percent: TPercentage; var Continue: Boolean);
begin
  if SplashForm.Active and bSplash then
  begin

   if STipo = 'BACKUP' then
   begin
     SplashForm.Label1.Caption := 'Aguarde compactando:'+chr(10)+chr(10)+Filename+chr(10)+chr(10)+ArquivoSaida;
   end else
   begin
     SplashForm.Label1.Caption := 'Aguarde descompactando:'+chr(10)+chr(10);
   end;
   //
   if Percent > 100 then Percent:=100;
   SplashForm.Gauge1.Progress := Percent;
   SplashForm.Gauge1.Repaint;
  end;
  with Progressbar1 do
  begin
    visible := Percent < 100;
    if visible then position := Percent;
    StaticText1.visible:=Visible;
  end;
  if Percent < 100 then StaticText1.caption := Filename else StaticText1.Visible:=False;
end;

procedure TForm1.ButtonAdicionaMascaraClick(Sender: TObject);
//var
//   S: string;
begin
//     S := extractFilepath(application.exename)+'*.*';
//     if InputQuery('Adicionar arquivos com coringas', 'Entre com o caminho + máscara de arquivo', S) then FileListBox.items.add(S);
     Form2.Edit1.Text := extractFilepath(application.exename)+'*.*';
     Form2.ShowModal;
end;

procedure TForm1.ButtonApagaArquivosClick(Sender: TObject);
begin
     filelistbox.items.clear;
end;

procedure TForm1.BtnCancelClick(Sender: TObject);
var
  iButton:integer;
begin
     if not BackupFile1.busy then
        close
     else
      begin
         iButton := Application.MessageBox('Quer mesmo abortar a operação ? ' , 'Confirmação'
                                         , MB_ICONQUESTION+mb_YesNO + mb_DefButton1);

         if iButton = IDYes then
         begin
           Backupfile1.Stop;
           PageControl1.Pages[0].TabVisible:=True;
           PageControl1.Pages[1].TabVisible:=True;
         end;
      end;

//        MessageDlg('Quer mesmo abortar a operação ?',mtConfirmation, [mbYes,mbNo], 0) = mrYes then Backupfile1.Stop;
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

procedure TForm1.ButtonRestauraClick(Sender: TObject);
var
   sArqOrigem,S,sLinha: string;
   F : TextFile;
begin
     // desativa
     PageControl1.Pages[0].TabVisible:=False;
     ButtonRestaura.Enabled:=False;
     gbRestorepath.Enabled:=False;
     //
     sTipo:='RESTORE';
     if rbOrigpath.checked then
        S := ''
     else
      begin
        S := EdPath.text;
        if trim(s) = '' then
        begin
           showmessage('Por favor, entre com o diretório destino');
           exit;
        end;
      end;


     backupfile1.restoreFullpath := cbFullpath.enabled and cbFullpath.checked;

     if ArquivoOriginal <> '' then
        sArqOrigem:=ArquivoOriginal
     else
        sArqOrigem:=filelistbox1.filename;

     if backupfile1.restore(sArqOrigem, S) then
     begin
       // muda a imagem.
       Form1.Image1.Visible:=True;
       Form1.Image2.Visible:=False;
       if bMostraMensagemFinal then
       begin
         showmessage('Restauração completada, '+inttostr(backupfile1.FilesProcessed)+' arquivos de '+inttostr(backupfile1.FilesTotal)+' restaurados');
       end;
     end;
     //
     Form1.Image1.Visible:=False;
     Form1.Image2.Visible:=False;
     // habilita
     ButtonRestaura.Enabled:=True;
     gbRestorepath.Enabled:=True;
     PageControl1.Pages[0].TabVisible:=True;
end;

procedure TForm1.rbOrigpathClick(Sender: TObject);
begin
     EdPath.enabled     := rbOtherPath.checked;
     cbFullPath.enabled := rbOtherPath.checked;
     ButtonVisualizar.Enabled    := rbOtherPath.checked;
end;

procedure TForm1.Backupfile1Error(Sender: TObject; const Error: Integer;
  ErrString: String);
begin
  Showmessage('Erro controlado: '+ErrString);
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  Finaliza,bEnquanto:boolean;
  Inicio:TIniFile;
  aPar: array [1..3] of string;
  I, iButton:integer;
  Unidade:byte;
begin
  iButton := 0;
  bMostraMensagemFinal:=True;
  bSplash:=True; // esta variável serve para controlar se as informações de
                 //progresso irão ser exibidas no splashform ou não

  // Parâmetro 1: Tipo (BACKUP ou RESTORE)
  // Parâmetro 2: Nome do arquivo que contém a lista no caso de BACKUP
  //              Nome do arquivo original no caso de RESTORE
  // Parâmetro 3: Nome do arquivo de saída no caso de BACKUP ou
  //              Caminho destino no caso de RESTORE se em branco restaura no caminho original
  // ex.:  backup lista.cop a:\copia
  GetDir(0,sDirDefault);
  sTipo:='BACKUP';
  Finaliza:=False;
  aPar[1]:='';aPar[2]:='';aPar[3]:='';
  if ParamCount > 3 then
   begin
     Showmessage('ERRO:'+chr(10)+'Excesso de parâmetros.'+chr(10)+'Para nomes longos utilize aspas.');
     halt(1);
   end
  else
   begin
    for I:= 1 to ParamCount do
    begin
       Finaliza:=True;
       aPar[I]:= UpperCase(ParamStr(I));
    end;
    if (aPar[1]='BACKUP')  then
    begin
       if aPar[2]<>'' then ArquivoLista:=aPar[2];
       if aPar[3]<>'' then ArquivoSaida:=aPar[3];
    end;
    if (aPar[1]='BACKUP/I')  then
    begin
       bMostraMensagemFinal:=False;
       if aPar[2]<>'' then ArquivoLista:=aPar[2];
       if aPar[3]<>'' then ArquivoSaida:=aPar[3];
    end;
    if aPar[1]='RESTORE' then
    begin
       sTipo:='RESTORE';
       if aPar[2]<>'' then ArquivoOriginal:=aPar[2];
       if aPar[3]<>'' then
        begin
          CaminhoDestino:=aPar[3];
          if UpperCase(Copy(CaminhoDestino+'     ',1,5)) = 'ATUAL' then
          begin
             CaminhoDestino:=sDirDefault;
          end;
        end
       else
         CaminhoDestino:='';//CaminhoDestino:=sDirDefault;
    end;

    if UpperCase(aPar[1])='RESTORE-O' then
    begin
       bMostraMensagemFinal:=False;
       bSplash:=False;
       sTipo:='RESTORE';
       if aPar[2]<>'' then ArquivoOriginal:=aPar[2];
       CaminhoDestino:=sDirDefault;
    end;
    Form1.Repaint;
    //backup
    if sTipo='BACKUP' then
     begin
      if UpperCase(ExtractFileExt(ArquivoLista))= '.COP' then //se for um arquivo de lista
       begin
         if (FileExists(ArquivoLista)) and (ArquivoSaida <> '')then
         begin
           Filelistbox.Items.LoadFromFile(sDirDefault+'\'+ArquivoLista);
           if Filelistbox.items.count > 0 then
              Form1.ButtonCriaArquivoClick(Sender);
         end;
       end
      else //quando não é um arquivo de lista e sim um arquivo só
       begin
         if (FileExists(ArquivoLista)) and (ArquivoSaida <> '')then
         begin
           Filelistbox.Items.Add(ArquivoLista);//sDirDefault+'\'+ArquivoLista);
           if Filelistbox.items.count > 0 then
              Form1.ButtonCriaArquivoClick(Sender);
         end;
       end;
     end
    else
    //RESTORE
     begin
      bEnquanto:=True;
      while bEnquanto do
      begin
         if (FileExists(ArquivoOriginal)) and (ArquivoOriginal <> '') then
          begin
            Form1.PageControl1.ActivePage := Form1.PageControl1.Pages[1];
      //     Filelistbox1.Items.Add(ArquivoOriginal);
            if CaminhoDestino <> '' then
             begin
                Form1.EdPath.Text := CaminhoDestino;
                Form1.rbOtherPath.Checked :=True;   //29-11-2004
             end
            else
             begin
                Form1.rbOrigpath.Checked := True;
             end;
           // Form1.CbFullPath.Checked := True;   //10/02/2000
            Form1.ButtonRestauraClick(Sender);
            bEnquanto:=False;
          end
         else
          begin
            Unidade:=ord(ArquivoOriginal[1])-64;
            if DiskFree(Unidade) < 0 then
              iButton := Application.MessageBox('ATENÇÃO: Coloque o disco com o arquivo origem e clique SIM'+chr(10)+
                                              'para interromper clique NÃO ou CANCELAR' , 'Troca de Disco'
                                           , MB_ICONQUESTION+mb_YesNOCancel + mb_DefButton1)
            else
              iButton := Application.MessageBox('ATENÇÃO: Este disco não contém o arquivo origem,  '+chr(10)+
                                              'para trocar de disco e tentar novamente, clique SIM'+chr(10)+
                                              'para interromper clique NÃO ou CANCELAR' , 'Troca de Disco'
                                             , MB_ICONQUESTION+mb_YesNOCancel + mb_DefButton1);
          end;
         if (iButton = IdNO) or (iButton = IdCancel) then bEnquanto:=False;
      end;
    end;

    //zera as variáveis para não executar de novo
    ArquivoSaida:='';
    ArquivoOriginal:='';
    CaminhoDestino:='';
    if Finaliza then halt(1);
    bSplash:=False;
  end;
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
//      showmessage(Format(cInsertDisk, [inttostr(DiskID)]));
//      Continue := MessageDlg(Format(cInsertDisk, [inttostr(DiskID)]), mtInformation, mbOKCancel, 0) = mrOK;
   end
  else //BACKUP
   begin
//     showmessage(Format(cInsertDisk, [inttostr(DiskID)]));
     Continue:=VerificaEspacoNoDisquete(DriveDest);
   end;
end;

procedure TForm1.FileListBoxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I:integer;
begin
   // se a tecla for um DEL apaga o item
   if Key = VK_DELETE then
   begin
    if FileListBox.SelCount > 0 then
    begin
      for I := FileListBox.Items.Count-1 downto 0 do
      begin
          if FileListBox.Selected[I] then
            Filelistbox.Items.Delete(I);
      end;
    end;
   end;
end;


procedure TForm1.ButtonVisualizarClick(Sender: TObject);
var
  Dir:String;
begin
   Dir:='';
   if SelectDirectory('Selecione o Diretório:','',Dir) then
//   if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],0) then //, sdPrompt],0) then
      EdPath.Text := Dir;
end;

end.
