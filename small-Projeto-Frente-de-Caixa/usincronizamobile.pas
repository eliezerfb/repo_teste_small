{ *********************************************************************** }
{                                                                         }
{ Delphi                                                                  }
{ Realiza o processamento das requisições recebidas do smallmobile.com.br }
{                                                                         }
{ Copyright (c) Smallsoft Tecnologia                                      }
{                                                                         }
{ *********************************************************************** }

unit usincronizamobile;

interface

uses
  Windows
  , SysUtils
  , StdCtrls
  , StrUtils
  , Controls
  , DateUtils
  , Dialogs
  , Classes
  , IBQuery
  , Forms
  , Variants
  , ComCtrls
  , IniFiles
  , jpeg
  , Types
  , ExtCtrls
  ;

type
  TSmallMobileCliente = class
  private
    FTipoItemVendaNFCeParcela: String;
    FTipoItemVendaNFCeProduto: String;
    FTipoItemVendaNFCePagamentoFormaExtra: String;
    FTipoItemVendaNFCeBandeira: String;
    FTipoItemVendaNFCeCartao: String;
    FTipoItemVendaNFCeCheque: String;
    FsVendaImportando: String;
    FsLogRetornoMobile: String;
  public
    constructor Create;
    //destructor Destroy;
    procedure Sincronizar;
    function PagamentoComFormaExtra(sFormaExtra: String; dValorPago: Double): Boolean;
    procedure GeraArquivoAlerta(FileName: String; sMensagem: String);
    procedure ProcessaArquivo;
    function LogClienteMobile(sLog: String): Boolean;
    function UploadMobile(sFile: TFileName): boolean; overload; // A partir 2016
    function DownloadMobile(sExtensao: String;
      slArquivos: TStringList): String; overload;
    function LogRetornoMobile(sLog: String): String;
    function EnviarLogParaMobile(sLog: String): Boolean;
    function ImportandoMobile: Boolean;
    property TipoItemVendaNFCeProduto: String read FTipoItemVendaNFCeProduto;
    property TipoItemVendaNFCeCheque: String read FTipoItemVendaNFCeCheque;
    property TipoItemVendaNFCeCartao: String read FTipoItemVendaNFCeCartao;
    property TipoItemVendaNFCeBandeira: String read FTipoItemVendaNFCeBandeira;
    property TipoItemVendaNFCeParcela: String read FTipoItemVendaNFCeParcela;
    property TipoItemVendaNFCePagamentoFormaExtra: String read FTipoItemVendaNFCePagamentoFormaExtra;
    property sVendaImportando: String read FsVendaImportando write FsVendaImportando;
    property sLogRetornoMobile: String read FsLogRetornoMobile write FsLogRetornoMobile;
  end;

implementation

uses
  tnpdf
  , fiscal
  , SmallFunc_xe
  , ufuncoesfrente
  ;


{ TSmallMobileCliente }

constructor TSmallMobileCliente.Create;
begin
  inherited;
  FTipoItemVendaNFCeProduto             := 'PRODUTO';
  FTipoItemVendaNFCeCheque              := 'CHEQUE';
  FTipoItemVendaNFCeCartao              := 'CARTAO';
  FTipoItemVendaNFCeBandeira            := 'BANDEIRA';
  FTipoItemVendaNFCeParcela             := 'PARCELA';
  FTipoItemVendaNFCePagamentoFormaExtra := 'PAGAMENTO FORMA EXTRA';
end;
{
destructor TSmallMobileCliente.Destroy;
begin

  inherited;
end;
}
function TSmallMobileCliente.DownloadMobile(sExtensao: String;
  slArquivos: TStringList): String;
// A partir 2016 passou usar esta função
var
  slDownload: TStringList;
  I: Integer;
  sArquivo: String;
  sDirAtual: String;
begin
  GetDir(0, sDirAtual);
  slDownload := TStringList.Create;
  try

    slArquivos.Clear;
    ListaDeArquivos(slDownload, pchar(Form1.sAtual+'\mobile\download'), sExtensao);

    for I := 0 to slDownload.Count -1 do
    begin
      sArquivo := Form1.sAtual + '\mobile\download\' + AllTrim(slDownload[I]);
      //
      //SmallMsg(LowerCase(sExtensao) +chr(10)+ LowerCase(sArquivo));
      //
      if (pos(LowerCase(Copy(sExtensao,2,4)),LowerCase(sArquivo)) <> 0) then
      begin
        //
        slArquivos.Add(sArquivo);
        //
        // SmallMsg(sArquivo);
        //
      end;
    end; // for I := 0 to slDownload.Count -1 do
  finally
    // slDownload.Free;
    FreeAndNil(slDownload);
  end;

end;

function TSmallMobileCliente.EnviarLogParaMobile(sLog: String): Boolean;
var
  sPdfMobile: String;
begin
  Result := False;
  try
    if Form1.ImportarvendasdoSmallMobile1.Checked then
    begin
      if (sLog <> '') and (ImportandoMobile) then // (Pos(TIPOMOBILE, Form1.ClienteSmallMobile.sVendaImportando) > 0) then
      begin
        sPdfMobile := Form1.sAtual + '\mobile\' + StringReplace(Form1.ClienteSmallMobile.sVendaImportando, TIPOMOBILE, '', [rfReplaceAll]) + '.pdf';
        GeraArquivoAlerta(sPdfMobile, sLog);
        Sleep(1000);
        UploadMobile(sPdfMobile);
        DeleteFile(sPdfMobile);
      end;
    end;
    Result := True;
  except

  end;
  ChDir(Form1.sAtual); // Sandro Silva 2017-04-04

end;

procedure TSmallMobileCliente.GeraArquivoAlerta(FileName,
  sMensagem: String);
var
  PDF: TPrintPDF;
  reTexto: TRichEdit;
  iLinha: Integer;
  iString: Integer;
  sRetornoGeraPDF: String;
  Img: TImage; // Sandro Silva 2022-08-05
  iWidth: Integer; // Sandro Silva 2022-08-05
  iFontSize: Integer;
  sFontName: String;
begin
  if Trim(FileName) <> '' then
  begin

    {Sandro Silva 2022-08-05 inicio}
    iWidth := 1258;
    iFontSize := 40;
    sFontName := 'Courier New';
    Img := TImage.Create(nil);
    Img.SendToBack;
    Img.Visible := False;
    Img.Parent  := Application.MainForm;
    Img.Width   := iWidth;
    Img.Height  := 2374;
    Img.Canvas.Font.Name := sFontName;// 'Courier New';
    Img.Canvas.Font.Size := iFontSize;// 40;//30;
    {Sandro Silva 2022-08-05 fim}

    // Cria o PDF

    //Create TPrintPDF VCL
    PDF := TPrintPDF.Create(nil);
    reTexto := TRichEdit.Create(Application);
    // Deixa a largura um pouco menor que a image base que receberá o texto
    reTexto.Width      := iWidth - Img.Canvas.TextWidth('Z');  // 1500;//1400;//1300;//950;//900;//800;
    reTexto.Visible    := False;
    reTexto.Parent     := Form1;
    reTexto.PlainText  := True;
    reTexto.Font.Name  := sFontName;//  'Courier New';
    reTexto.Font.Size  := iFontSize;//  50;
    reTexto.WordWrap   := True;
    reTexto.WantTabs   := True;
    reTexto.ScrollBars := ssVertical;//ssBoth;
    reTexto.Text       := sMensagem;

    {Sandro Silva 2022-08-05 inicio}
    iLinha := 20;

    //Cria as linhas de texto na imagem
    for iString := 0 to reTexto.Lines.Count - 1 do
    begin
      Img.Canvas.TextOut(15, iLinha, StringReplace(reTexto.Lines.Strings[iString], #9, ' ', [rfReplaceAll]));

      iLinha := iLinha + (Img.Canvas.TextHeight(StringReplace(reTexto.Lines.Strings[iString], #9, ' ', [rfReplaceAll])) + 1);//20;
    end;
    {Sandro Silva 2022-08-05 fim}

    try
      //Set Doc Info
      PDF.Title       := 'Alerta';
      PDF.Creator     := 'Small';
      PDF.Author      := 'Zucchetti'; // Sandro Silva 2022-12-02 Unochapeco
      PDF.Keywords    := '';
      PDF.Producer    := 'Small';
      PDF.Subject     := 'Alerta Small Mobile';
      PDF.JPEGQuality := 100; //50;

      // Use Compression: VCL Must compile with ZLIB comes with D3 above
      PDF.Compress    := True;

      //Set Page Size
      PDF.PageWidth   := 1258;//800;// 1258;
      PDF.PageHeight  := 2374;

      //Set Filename to save//
      PDF.FileName    := FileName;

      //Start Printing...
      PDF.BeginDoc;

      // Altera a fonte do Documento PDF de acordo com o Memo1
      PDF.Font.Name := poCourierBold;// poTimesBold;
      PDF.Font.Size := 50;//18;

      {Sandro Silva 2022-08-05 inicio

      iLinha := 50;//20;

      //Cria as linhas do PDF
      for iString := 0 to reTexto.Lines.Count - 1 do
      begin
        PDF.TextOut(10, iLinha, reTexto.Lines.Strings[iString]);
        PDF.TextOut(15, iLinha, StringReplace(reTexto.Lines.Strings[iString], #9, ' ', [rfReplaceAll]));
      end;
      PDF.DrawJPEG(0, 0, Img.Picture.Bitmap);
      }
      PDF.DrawJPEG(0, 0, Img.Picture.Bitmap);

    finally
      //End Printing
      try
        sRetornoGeraPDF := PDF.EndDoc;
        if sRetornoGeraPDF <> '' then
          SmallMsgBox(PChar(sRetornoGeraPDF), 'Atenção', MB_ICONWARNING + MB_OK);
        if PDF <> nil then
          FreeAndNil(PDF);
        if reTexto <> nil then
          FreeAndNil(reTexto);
      except

      end;
      if PDF <> nil then
        FreeAndNil(PDF);
      if reTexto <> nil then
        FreeAndNil(reTexto);

      {Sandro Silva 2022-08-05 inicio}
      if Img <> nil then
        FreeAndNil(Img);
      {Sandro Silva 2022-08-05 fim}
    end;
  end;
end;

function TSmallMobileCliente.ImportandoMobile: Boolean;
begin
  if (Form1.sModeloECF <> '59') and (Form1.sModeloECF <> '65') and (Form1.sModeloECF <> '99') then // ECF não usa mobile
    Result := False
  else
    Result := (Pos(TIPOMOBILE, FsVendaImportando) > 0);
end;

function TSmallMobileCliente.LogClienteMobile(sLog: String): Boolean;
var
  LogFile: TextFile;
  sFile: String;
  procedure RenameLog(Arquivo: String);
  var
    sFile: String;
    sExtensao: String;
  begin
    try
      sFile := ExtractFileName(Arquivo);
      sExtensao := ExtractFileExt(Arquivo);
      RenameFile(Arquivo, ExtractFilePath(Arquivo) + StringReplace(sFile, sExtensao, '_' + FormatDateTime('yyyymmddHHnnss', Now) + sExtensao , [rfReplaceAll]));
    except

    end;
  end;
  function TamanhoArquivo(Arquivo: string): Integer;
  begin
    Result := 0;
    try
      if FileExists(Arquivo) then
      begin
        with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
          try
            Result := Size;
          finally
            Free;
          end;
      end;
    except
    end;
  end;
begin
  Result := False;
  try
    // Sandro Silva 2016-03-24  sFile := ExtractFilePath(Application.ExeName) + 'log\log_sat.txt';
    sFile := ExtractFilePath(Application.ExeName) + 'mobile\log\log_mobile_' + Form1.sCaixa + '_' + FormatDateTime('yyyy-mm-dd', Date) + '.txt';

    if DirectoryExists(ExtractFilePath(Application.ExeName) + 'mobile\log') = False then
      ForceDirectories(ExtractFilePath(Application.ExeName) + 'mobile\log');

    if FileExists(sFile) then
    begin
      if StrToInt(FormatFloat('0', TamanhoArquivo(sFile) / 1024)) >= 1024 then
        RenameLog(sFile);
    end;

    AssignFile(LogFile, sFile);
    if FileExists(sFile) = False then
      ReWrite(LogFile)
    else
      Append(LogFile);

    WriteLn(LogFile, FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + '|' + sLog);
    CloseFile(LogFile);
    Result := True;
  except

  end;
  ChDir(Form1.sAtual);

end;

function TSmallMobileCliente.LogRetornoMobile(sLog: String): String;
begin
  if Trim(sLog) <> '' then
    FsLogRetornoMobile := FsLogRetornoMobile + #13;
  FsLogRetornoMobile := FsLogRetornoMobile + sLog;

  Result := FsLogRetornoMobile;

end;

function TSmallMobileCliente.PagamentoComFormaExtra(
  sFormaExtra: String; dValorPago: Double): Boolean;
var
  iniFormas: TIniFile;
  iFormaExtra: Integer;
begin
  Result := False;
  if FormaExtraDePagamento(sFormaPag) then
  begin
    iniFormas := TIniFile.Create(FRENTE_INI);
    for iFormaExtra := 1 to NUMERO_FORMAS_EXTRAS do
    begin

      if sFormaExtra = AnsiUpperCase(iniFormas.ReadString(Form1.SecaoFrente, 'Forma extra ' + IntToStr(iFormaExtra), '')) then
      begin
        try
          Form1.ibDataSet25.Edit;
          Form1.ibDataSet25.FieldByName('RECEBER').AsFloat      := dValorPago; //ficou zerado na sequência do button18click
          Form1.ibDataSet25.FieldByName('VALOR' + FormatFloat('00', iFormaExtra)).AsFloat := dValorPago;
          Form1.ibDataSet25.Post;
          Result := True;
          Break;
        except
          on E: Exception do
          begin
            ShowMessage(E.Message);
          end;
        end;
      end;

    end;
    iniFormas.Free;

    if Result = False then
    begin
      LogRetornoMobile('Forma de pagamento não encontrada: ' + sFormaExtra);
    end;
  end;
end;

procedure TSmallMobileCliente.ProcessaArquivo;
begin

end;

procedure TSmallMobileCliente.Sincronizar;
var
  s, sSenha : String;
  //
  ArqIni : TIniFile;
  sSecoes :  TStrings;
  I, iI: Integer;
  sCNPJ : String;
  //
  jp    : TJPEGImage;
  F     : TextFile;
  Rect  : TRect;
  // BlobStream : TStream;
  //
  //
  Image1: TImage;
  Image6: TImage;
  Cursor: TCursor;
  //t1: TTime;
begin
  //t1 := Time;
  //
  Cursor := Screen.Cursor;

  Screen.Cursor := crHourGlass; // Cursor de Aguardo

  Image1 := TImage.Create(Application);
  Image1.Visible := False;
  Image1.Parent  := Form1;

  Image6 := TImage.Create(Application);
  Image6.Visible := False;
  Image6.Parent  := Form1;

  try
    //
    DeleteFile('estoque.sql');
    DeleteFile('clifor.sql');
    DeleteFile('usuarios.sql');
    DeleteFile('bandeiras.sql');
    DeleteFile('formas_pagamentos.sql');
    //
    Sleep(100);
    //
    sCNPJ := Trim(LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString));
    //
    try
      //
      if sCNPJ <> '' then
      begin
        try
          //
          // estoque.sql
          //
          Form1.IBQuery1.DisableControls;
          Form1.IBQuery1.Close;
          Form1.IBQuery1.SQL.Clear;
          Form1.IBQuery1.SQL.Text :=
            'select CODIGO, CST, DESCRICAO, MEDIDA, PRECO, QTD_ATUAL, ST ' +
            'from ESTOQUE order by CODIGO';
          Form1.IBQuery1.Open;
          //
          AssignFile(F,'estoque.sql');
          Rewrite(F);
          WriteLN(F,'delete from estoque where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
          //
          Form1.IBQuery1.First;
          while not Form1.IBQuery1.Eof do
          begin
            try
              //
              try
                DeleteFile('tempo.bmp');
                DeleteFile(pChar('_t_'+Form1.IBQuery1.FieldByName('CODIGO').AsString+'.jpg'));
              except end;
              //
              WriteLN(F,'insert into estoque (EMITENTE, CODIGO, CST, DESCRICAO, MEDIDA, PRECO, QTD_ATUAL, ST) values ('
              +QuotedStr(sCNPJ)+', '
              +QuotedStr(StrTran(Form1.IBQuery1.FieldByName('CODIGO').AsString,'''',''))+', '
              +QuotedStr(StrTran(Form1.IBQuery1.FieldByName('CST').AsString,'''',''))+', '
              +QuotedStr(ConverteAcentosPHP(Form1.IBQuery1.FieldByName('DESCRICAO').AsString)) +', '
              +QuotedStr(StrTran(Form1.IBQuery1.FieldByName('MEDIDA').AsString,'''',''))+', '
              +QuotedStr(StrTRan(Form1.IBQuery1.FieldByName('PRECO').AsString,',','.'))+', '
              +QuotedStr(StrTRan(Form1.IBQuery1.FieldByName('QTD_ATUAL').AsString,',','.'))+', '
              +QuotedStr(StrTran(Form1.IBQuery1.FieldByName('ST').AsString,'''',''))+' ); ');
              //
            except end;
            //
            Form1.IBQuery1.Next;
            //
          end;
          Form1.IBQuery1.EnableControls; // Sandro Silva 2020-11-06
          //
          CloseFile(F);
          //
        except
          try
            CloseFile(F);
          except end;
        end;
        try
          //
          // clifor.off
          //
          Form1.IBQuery1.DisableControls;
          Form1.IBQuery1.Close;
          Form1.IBQuery1.SQL.Clear;
          Form1.IBQuery1.SQL.Text :=
            'select CLI.NOME, CLI.CGC, CLI.IE, CLI.CEP, CLI.EMAIL, CLI.CIDADE, CLI.COMPLE, CLI.ENDERE, CLI.ESTADO, CLI.FONE ' +
            ', CON.DESCONTO as DESCONTO_CONVENIO ' +
            'from CLIFOR CLI ' +
            'left join CONVENIO CON on CON.NOME = CLI.CONVENIO ' +
            'where trim(coalesce(CLI.NOME,'''')) <> '''' '; // Sandro Silva 2016-02-18
          Form1.IBQuery1.Open;
          //
          AssignFile(F,'clifor.sql');
          Rewrite(F);
          WriteLN(F,'delete from clifor where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
          Form1.ibQuery1.First;
          while not Form1.ibQuery1.Eof do
          begin
            try
              if LimpaNumero(Form1.ibQuery1.FieldByName('CGC').AsString) <> '' then
              begin
                         //insert into clifor (EMITENTE, NOME, CGC, IE, CEP, EMAIL, CIDADE, COMPLE, ENDERE, ESTADO, FONE, DESCONTO_CONVENIO) values (
                         //'07426598000124', 'Fernanda Gottschalk teste de aumento do campo da razao socia', '01046256947', '123152', '89700-000', '',
                         //'Concordia', 'centro', 'Rua tupis, 390', 'SC', '(0xx49)3444-4242','15' );

                //
                WriteLN(F,'insert into clifor (EMITENTE, NOME, CGC, IE, CEP, EMAIL, CIDADE, COMPLE, ENDERE, ESTADO, FONE, DESCONTO_CONVENIO) values ('
                  +QuotedStr(sCNPJ)+', '
                  +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByName('NOME').AsString))+', '
                  +QuotedStr(LimpaNumero(Form1.ibQuery1.FieldByName('CGC').AsString))+', '
                  +QuotedStr(Form1.ibQuery1.FieldByName('IE').AsString)+', '
                  +QuotedStr(Form1.ibQuery1.FieldByName('CEP').AsString)+', '
                  +QuotedStr(Form1.ibQuery1.FieldByName('EMAIL').AsString)+', '
                  +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByName('CIDADE').AsString))+', '
                  +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByName('COMPLE').AsString))+', '
                  +QuotedStr(ConverteAcentosPHP(Form1.ibQuery1.FieldByName('ENDERE').AsString))+', '
                  +QuotedStr(Form1.ibQuery1.FieldByName('ESTADO').AsString)+', '
                  +QuotedStr(Form1.ibQuery1.FieldByName('FONE').AsString)+', '
                  +QuotedStr(StringReplace(Form1.ibQuery1.FieldByName('DESCONTO_CONVENIO').AsString, ',', '.', [rfReplaceAll]))
                  +' ); ');
                //
              end;
              //
            except end;
            //
            Form1.ibQuery1.Next;
            //
          end;
          Form1.IBQuery1.EnableControls; // Sandro Silva 2020-11-06
          //
          CloseFile(F);
          //
        except
          try
            CloseFile(F);
          except end;
        end;
        try
          //
          // usuarios.off
          //
          AssignFile(F,'usuarios.sql');
          Rewrite(F);
          WriteLN(F,'delete from usuarios where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
          //
          sSecoes := TStringList.Create;
          //
          ArqIni := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
          ArqIni.ReadSections(sSecoes);
          //
          for I := 0 to (sSecoes.Count - 1) do
          begin
            s := '';
            if ArqIni.ReadString(sSecoes[I],'Chave','ÁstreloPitecus') <> 'ÁstreloPitecus' then
            begin
              if AllTrim(sSecoes[I]) <> 'Administrador' then
              begin
                //
                sSenha   := ArqIni.ReadString(sSecoes[I],'Chave','15706143431572013809150491382314104');
                // ----------------------------- //
                // Fórmula para ler a nova senha //
                // ----------------------------- //
                for iI := 1 to (Length(sSenha) div 5) do
                  s := Chr((StrToInt(
                                Copy(sSenha,(iI*5)-4,5)
                                )+((Length(sSenha) div 5)-iI+1)*7) div 137) + s;
                //
                if ArqIni.ReadString(sSecoes[I],'Chave','') <> '' then
                begin
                  //
                  WriteLN(F,'insert into usuarios (EMITENTE, NOME, SENHA, STATUS) values ('
                  +QuotedStr(sCNPJ)+', '
                  +QuotedStr(sSecoes[I])+', '
                  +QuotedStr(s)+', '
                  +QuotedStr(

                  StrTran(StrTran(StrTran(

                  ArqIni.ReadString(sSecoes[I],'B1','1')+  // NFCE/NFE/Orçamento
                  ArqIni.ReadString(sSecoes[I],'B2','1')+  // Estoque
                  ArqIni.ReadString(sSecoes[I],'B3','1')+  // Cadastro
                  ArqIni.ReadString(sSecoes[I],'B5','1')   // Caixa

                  ,'1','X'),'0','1'),'X','0') // Xoor - Inverte 0 pra um e 1 pra zero

                  )+');');
                  {Sandro Silva 2016-05-23 final}
                  //
                end;
              end;
            end;
          end;
          //
          CloseFile(F);
          ArqIni.Free;
          sSecoes.Free;
          //
        except
          try
            CloseFile(F);
          except end;
        end;

        try
          // Bandeiras de cartões débito/crédito
          //
          // bandeiras.off
          //
          AssignFile(F,'bandeiras.sql');
          Rewrite(F);
          WriteLN(F,'delete from cartoes where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
          //
          sSecoes := TStringList.Create;
          //
          ArqIni := TIniFile.Create('FRENTE.INI');
          ArqIni.ReadSections(sSecoes);
          //
          for I := 0 to (sSecoes.Count - 1) do
          begin
            if ArqIni.ReadString(sSecoes[I],'CARTAO ACEITO','NAO') = 'SIM' then
            begin
              WriteLN(F,'insert into cartoes (EMITENTE, CARTAO) values ('
              +QuotedStr(sCNPJ)+', '
              +QuotedStr(sSecoes[I])+');');
            end;
          end;

          //
          CloseFile(F);
          ArqIni.Free;
          sSecoes.Free;
          //
        except
          try
            CloseFile(F);
          except end;
        end;

        {Sandro Silva 2022-08-04 inicio}
        try
          // Formas de pagamento conforme definições implementadas no smallmobile.com.br
          //
          //
          AssignFile(F,'formas_pagamentos.sql');
          Rewrite(F);
          WriteLN(F,'delete from formas_pagamentos where EMITENTE = '+QuotedStr(sCNPJ)+'; '); // Apaga somente as inf atuais deste CNPJ
          //
          sSecoes := TStringList.Create;
          //
          ArqIni := TIniFile.Create('FRENTE.INI');
          ArqIni.ReadSections(sSecoes);
          //
          for I := 1 to 8 do
          begin
            // Tem forma extra configurada e com código para usar no xml da NFC-e/SAT/MFE
            if (ArqIni.ReadString(Form1.SecaoFrente, 'Forma extra ' + IntToStr(I), '') <> '') and
              (ArqIni.ReadString(SECAO_65, 'Ordem forma extra ' + IntToStr(I), '') <> '') then
            begin
              WriteLN(F,'insert into formas_pagamentos (EMITENTE, DESCRICAO, CODIGO) values ('
                + QuotedStr(sCNPJ) + ', '                                                                   // cnpj emitente
                + QuotedStr(ArqIni.ReadString(Form1.SecaoFrente, 'Forma extra ' + IntToStr(I), '')) + ', '  // Forma Extra
                + QuotedStr(ArqIni.ReadString(SECAO_65, 'Ordem forma extra ' + IntToStr(I), ''))            // Código que irá assumir no
                + ');'
              );
            end;
          end;

          //
          CloseFile(F);

          ArqIni.Free;
          sSecoes.Free;
          //
        except
          try
            CloseFile(F);
          except end;
        end;
        {Sandro Silva 2022-08-04 fim}
        //
        Form1.LbBlowfish1.GenerateKey(Form1.sPasta);
        //Screen.Cursor := crHourGlass;                   // Cursor de Aguardo
        //
        // Envia os arquivos
        //
        // logo.jpg
        //
        if FileExists('LOGOTIP.BMP') then
        begin
          //
          Rect.Top    := 0;
          Rect.Left   := 0;
          Rect.Right  := 360;
          Rect.Bottom := 90;
          //
          Image1.Picture.LoadFromFile('LOGOTIP.BMP');
          Image1.Canvas.StretchDraw(Rect,Image1.Picture.Graphic);
          //
          Image1.Picture.Bitmap.Width  := 360;
          Image1.Picture.Bitmap.Height := 90;
          //
          jp := TJPEGImage.Create;
          try
            jp.Assign(Image1.Picture.Bitmap);
            jp.CompressionQuality := 100;
            jp.SaveToFile('logo.jpg');
          except
          end;
          FreeAndNil(jp);
          //
        end;
        //
        // Transmite os arquivos
        //
        //sTime := Time;
        //
        UploadMobile('clifor.sql');
        UploadMobile('usuarios.sql');
        UploadMobile('estoque.sql');
        UploadMobile('logo.jpg');
        UploadMobile('bandeiras.sql');
        UploadMobile('formas_pagamentos.sql'); // Sandro Silva 2022-08-04
        //
        // Exclui os arquivos locais
        DeleteFile('clifor.sql');
        DeleteFile('usuarios.sql');
        DeleteFile('estoque.sql');
        DeleteFile('logo.jpg');
        DeleteFile('bandeiras.sql');
        DeleteFile('formas_pagamentos.sql'); // Sandro Silva 2022-08-04
        //
      end else
      begin
        if (FsVendaImportando = '') then
          SmallMsg('CNPJ do emitente inválido.');
      end;
      //
    except end;
  finally
    FreeAndNil(Image1);
    FreeAndNil(Image6);

    Form1.IBQuery1.Close;
    Form1.IBQuery1.EnableControls;

    Screen.Cursor := Cursor;
  end;
  ChDir(Form1.sAtual); // Sandro Silva 2017-03-31
end;

function TSmallMobileCliente.UploadMobile(sFile: TFileName): boolean;
var
  sDestino: String;
begin
  //
  sDestino := Form1.sAtual+'\mobile\upload\'+ExtractFileName(sFile);
  if CopyFile(PChar(sFile), PChar(sDestino), False) then
  begin
    LogClienteMobile('Criou-' + ExtractFileName(sDestino));
    DeleteFile(pchar(sFile));
  end;
  //
  Result := True;
  //
  sLogRetornoMobile := ''; // Sandro Silva 2016-05-05
end;

end.
