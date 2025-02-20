unit uimpressaopdf;

interface

uses Graphics, ExtCtrls, Printers, tnpdf, Windows, SysUtils, Forms,
  StdCtrls, Classes, Controls, ShellAPI
  , SynPDF
  ;

const FONT_NAME_DEFAULT = 'Courier New';//'FontB88'; //2016-01-14 'Calibri';//'Arial Narrow';//'Sans Serif';//'Cambria';//'MS Sans Serif';// 'Calibri';
const FONT_SIZE_DEFAULT = 7; // 2015-06-29 8;//7;
const ALTURA_PAGINA_PDF = 2448;// 3508; // Sandro Silva 2017-04-17  2374;

type
  TDestinoDoc = (toPrinterDoc, toImageDoc);
  TAlinhamento = (poLeft, poRight, poCenter, poJustify);

  TImpressaoPDF = class(TComponent)
  private
    FLarguraPapel: Integer;
    //FLogRetornoMobile: String;
  protected

  public
    function Imprimir(sTitulo: String; sTexto: String;
      sArquivoPDF: String): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property LarguraPapel: Integer read FLarguraPapel write FLarguraPapel;
  published

  end;

implementation

constructor TImpressaoPDF.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TImpressaoPDF.Destroy;
begin
  inherited;
end;

function TImpressaoPDF.Imprimir(sTitulo: String; sTexto: String;
  sArquivoPDF: String): Boolean;
//const PERCENTUAL_LARGURA_LOGO_X_LARGURA_PAPEL = 0.2721518987341772;
const LARGURA_REFERENCIA_PAPEL_BOBINA = 640; //639
var
  i: Integer;
  sLinha: String;
  FCursor: TCursor;
  Destino: TDestinoDoc;
  iPrimeiraLinhaPapel: Integer; // Posição onde pode ser impresso a primeira linha em cada página
  iLarguraPapel: Integer;
  iMargemEsq: Integer;
  iLinha: Integer;
  //iMargemRazaoSocial: Integer;
  iAlturaFonte: Integer;
  iLarguraFonte: Integer;

  Canvas: TCanvas;
  iLarguraFisica: Integer;
  //iPixelsPerInch: Integer;
  iHeightAltura: Integer;
  sFilePDF: String;
  Pagina: Array of TImage; // Imagem que receberá os textos e outras imagem
  iAlturaPDF: Integer;
  PDF: TPdfDocumentGDI; //Sandro Silva 2024-04-26 PDF: TPrintPDF;
  PAGE : TPdfPage;
  iPagina: Integer;
  //iLinhasFinal: Integer;
  //iPrinterPhysicalWidth: Integer; // Sandro Silva 2017-09-12

  sRetornoGeraPDF: String;
  function GetPrinterPhysicalWidth: Integer;
  begin
    Result := GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH);
  end;

  function CriaPagina: TImage;
  var
    iPages: Integer;
    procedure NumerarPagina(Canvas: TCanvas; iNumero: Integer);
    begin
      Canvas.Font.Size := Canvas.Font.Size - 2;
      SetTextAlign(Canvas.Handle, TA_RIGHT);
      Canvas.TextOut(iLarguraPapel, iAlturaPDF - iAlturaFonte, 'Página ' + IntToStr(iNumero));
      SetTextAlign(Canvas.Handle, TA_LEFT);
      Canvas.Font.Size := Canvas.Font.Size + 2;
    end;
  begin
    try
      SetLength(Pagina, Length(Pagina) + 1);
      iPages := High(Pagina);
      Pagina[iPages]              := TImage.Create(Application);
      Pagina[iPages].Parent       := Application.MainForm;//  Form1;
      Pagina[iPages].Proportional := True;
      Pagina[iPages].Visible      := False;
      Pagina[iPages].Height       := iAlturaPDF;
      if iPages = 0 then
        Pagina[iPages].Top := 0
      else
        Pagina[iPages].Top := Pagina[iPages -1 ].BoundsRect.Bottom + 10;
      Pagina[iPages].Left                       := 0;
      Pagina[iPages].Width                      := iLarguraPapel;// Sandro Silva 2017-04-17  iLarguraFisica;
      Pagina[iPages].Canvas.Brush.Color         := clWhite;
      Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 * 2;// 14;
      Pagina[iPages].Canvas.Font.Style          := [fsBold];
      Pagina[iPages].Picture.Bitmap.PixelFormat := pf32bit; // 2015-05-15 pf24bit; // pf32bit; //2014-04-30
      Pagina[iPages].Picture.Bitmap.Height      := Pagina[iPages].Height;
      Pagina[iPages].Picture.Bitmap.Width       := Pagina[iPages].Width;
      Canvas := Pagina[iPages].Canvas;
      Canvas.Font.PixelsPerInch := 230;// 215; // Sandro Silva 2017-04-13  203;
      Canvas.Font.Size          := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 Acertar a fonte depois de Canvas.Font.PixelsPerInch, que deixa a fonte menor
      Canvas.Font.Name          := FONT_NAME_DEFAULT;
      iMargemEsq          := 02;//02; // Sandro Silva 2017-12-15  10;
      iLinha              := 50;
      iAlturaFonte        := Pagina[iPages].Canvas.TextHeight('Ég');// - 3; // Sandro Silva 2017-04-17 ; // Calcula a altura ocupada pelo texto, inclusive acentuados ou caracteres como "jgyqçp";
      iLarguraFonte       := Pagina[iPages].Canvas.TextWidth('W');
      iPrimeiraLinhaPapel := iLinha + iAlturaFonte;
      Pagina[iPages].Canvas.Font.Style := [];
      Pagina[iPages].Canvas.Font.Name  := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size  := FONT_SIZE_DEFAULT; //14;

      if iPages > 0 then
        iLinha := iPrimeiraLinhaPapel;

      iHeightAltura := Pagina[iPages].Height;

      // Numerando as páginas
      // Sandro Silva 2017-12-15  NumerarPagina(Pagina[iPages].Canvas, iPages + 1);
      Result := Pagina[iPages];
    except
      Result := nil
    end;
  end;

  function CanvasLinha(var iPosicao: Integer; mm: Double; iTopo: Integer): Integer;
  // Sandro Silva 2013-01-10 inicio Avança a posição verticar do Canvas para impressão
  begin

    iPosicao := iPosicao + Round(mm);

    if Destino = toImageDoc then
    begin
      if iPosicao + Trunc(mm / 3) > (iAlturaPDF - (iAlturaFonte * 2)) then
        CriaPagina;
    end
    else
    begin
      if iPosicao >= (Printer.PageHeight - (iAlturaFonte * 2)) then // Controla avanço de páginas
      begin
        Printer.NewPage;
        iPosicao := iTopo;
      end;
    end;
    Result := iPosicao;
  end;

  procedure PrinterTexto(iLinha: Integer; iColuna: Integer;
    Texto: String; Alinhamento: TAlinhamento = poLeft; FontName: String = FONT_NAME_DEFAULT);
  begin
    Canvas.Font.Name := FontName; // 2016-01-14

    case Alinhamento of
      poCenter:
        begin
          if Destino = toImageDoc then
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2) + iMargemEsq // 2014-05-09
          else
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2);
        end;
      poRight:
        begin
          iColuna := iLarguraPapel;
          SetTextAlign(Canvas.Handle, TA_RIGHT);
        end;
    end;

    Canvas.TextOut(iColuna, iLinha, Texto);

    SetTextAlign(Canvas.Handle, TA_LEFT);
  end;

  procedure PrinterTextoMemo(var iLinha: Integer; iColuna: Integer;
    const iLargura: Integer; Texto: String; Alinhamento: TAlinhamento = poLeft);
  var
    iMemoLine: Integer;
    sTextoLinha: String;
    reTexto: TMemo;
    slTexto: TStringList;
    sTextoOrig: String;
    sTexto: String;

    function sBreakApart(BaseString, BreakString: String; StringList: TStringList): TStringList;
    var
      EndOfCurrentString: Byte;
    begin
      repeat
        EndOfCurrentString := Pos(BreakString, BaseString);
        if EndOfCurrentString = 0 then
          StringList.Add(BaseString)
        else
          StringList.Add(Copy(BaseString, 1, EndOfCurrentString - 1));
        BaseString := Copy(BaseString, EndOfCurrentString + Length(BreakString), Length(BaseString) - EndOfCurrentString);

      until EndOfCurrentString = 0;
      Result := StringList;
    end;

    procedure CanvasTextOut;
    begin

      if Destino = toImageDoc then
      begin
        if (iLinha + Canvas.TextHeight(sTextoLinha)) > iAlturaPDF then
          CriaPagina;
      end;

      case Alinhamento of
        poCenter:
          begin
            iColuna := Round((iLargura - Canvas.TextWidth(sTextoLinha)) / 2);
          end;
        poRight:
          begin
            iColuna := iLargura;
            SetTextAlign(Canvas.Handle, TA_RIGHT);
          end;
      end;

      Canvas.TextOut(iColuna, iLinha, Trim(sTextoLinha));

      SetTextAlign(Canvas.Handle, TA_LEFT);

    end;
  begin
    reTexto := TMemo.Create(nil);
    reTexto.Left       := -1000;
    reTexto.Top        := -1000;
    reTexto.Visible    := False;
    reTexto.Parent     := Application.MainForm; // Sandro Silva 2017-04-27  Screen.ActiveForm;
    reTexto.ParentFont := False;
    reTexto.Font       := Canvas.Font;
    reTexto.Width      := iLargura;
    reTexto.Repaint;

    slTexto    := TStringList.create;
    sTextoOrig := Texto;
    sTexto     := sTextoOrig;
    reTexto.Lines.Assign(sBreakApart(sTextoOrig, ' ', slTexto));

    sTextoOrig := StringReplace(sTextoOrig, #$D#$A, '', [rfReplaceAll]);
    sTextoOrig := StringReplace(sTextoOrig, '  ', ' ', [rfReplaceAll]);
    iMemoLine := 0;
    while (sTextoOrig <> '') do
    begin
      sTexto := reTexto.Lines.Strings[iMemoLine] + ' ';
      if (Canvas.TextWidth(sTextoLinha + sTexto) <= iLargura) and (iMemoLine <= reTexto.Lines.Count) then
      begin
        sTextoLinha := StringReplace(sTextoLinha + sTexto, '  ', ' ', [rfReplaceAll]);
      end
      else
      begin
        sTextoOrig := StringReplace(StringReplace(sTextoOrig, StringReplace(sTextoLinha, '  ', ' ', [rfReplaceAll]), '', [rfIgnoreCase]), #$D#$A, '', [rfIgnoreCase]);

        CanvasTextOut;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        sTextoLinha := sTexto + ' ';
      end;

      Inc(iMemoLine);

      if iMemoLine >= reTexto.Lines.Count then
        Break;

    end;

    if (Trim(sTextoOrig) <> '') then
    begin

      sTextoLinha := sTextoOrig;

      CanvasTextOut;

    end;

  end;

begin
  FCursor        := Screen.Cursor;
  Screen.Cursor  := crHourGlass;
  iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;
  if FLarguraPapel > LARGURA_REFERENCIA_PAPEL_BOBINA then
    iLarguraFisica := FLarguraPapel;
  try
    try

      Destino := toImageDoc;

      Canvas := TCanvas.Create;

      Printer.Title := sTitulo;
      Printer.BeginDoc;

      Printer.Canvas.Font.Name          := FONT_NAME_DEFAULT;
      Printer.Canvas.Font.Size          := FONT_SIZE_DEFAULT;
      Printer.Canvas.Font.PixelsPerInch := 500;

      Canvas                            := Printer.Canvas; // Sandro Silva 2017-09-12

      iAlturaPDF     := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  3508; // Sandro Silva 2017-04-13  2350;
      // iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;
      //iPixelsPerInch := 250;// 215; // 600; // Sandro Silva 2017-04-11  103;

      if FLarguraPapel > 0 then
        iLarguraPapel             := FLarguraPapel
      else
        iLarguraPapel             := 640;// 588; // Sandro Silva 2017-04-18  576;// LARGURA_REFERENCIA_PAPEL_BOBINA; // Sandro Silva 2017-04-10

      CriaPagina; // Cria nova página no array

      for I := 1 to Length(sTexto) do
      begin
        if Copy(sTexto,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(sTexto,I,1);
        end
        else
        begin
          Canvas.Font.Style := [fsBold];
          PrinterTexto(iLinha, iMargemEsq, sLinha, poLeft);
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          sLinha := '';
        end;
      end;

      Result := True;
    except
      Result := False;
    end;

  finally
    if Destino = toImageDoc then
    begin
      try

        Printer.Abort;

        {Sandro Silva 2024-04-26

        try
          sFilePDF := sArquivoPDF;
          if DirectoryExists(ExtractFilePath(Application.ExeName) + 'Relatorios') = False then
            ForceDirectories(ExtractFilePath(Application.ExeName) + 'Relatorios');

          // Cria o PDF

          //Create TPrintPDF VCL
          PDF := TPrintPDF.Create(Self);

          //Set Doc Info
          PDF.TITLE       := ExtractFileName(sFilePDF);
          PDF.Creator     := 'Small - ' + ExtractFileName(Application.ExeName);
          PDF.Author      := '';
          PDF.Keywords    := '';
          PDF.Producer    := 'Small - ' + ExtractFileName(Application.ExeName);
          //Set Filename to save
          PDF.Subject     := ExtractFileName(sFilePDF);

          PDF.JPEGQuality := 100;

          //Use Compression: VCL Must compile with ZLIB comes with D3 above
          PDF.Compress    := False;

          //Set Page Size
          PDF.PageWidth   := iLarguraFisica;
          PDF.PageHeight  := ALTURA_PAGINA_PDF;

          //Set Filename to save
          PDF.FileName  := ExtractFilePath(Application.ExeName) + 'Relatorios\' + sFilePDF;

          //Start Printing...
          PDF.BeginDoc;

          for iPagina := 0 to Length(Pagina) -1 do
          begin

            //Print Image
            PDF.DrawJPEG(0, 0, Pagina[iPagina].Picture.Bitmap);

            if iPagina < Length(Pagina) -1 then
              //Add New Page
              PDF.NewPage;
            FreeAndNil(Pagina[iPagina]);
          end;

          //End Printing
          sRetornoGeraPDF := PDF.EndDoc;

          Sleep(500 * Length(Pagina) -1);
        except
          on E: Exception do
          begin
            with TStringList.Create do
            begin
              Text := E.Message;
              SaveToFile(ChangeFileExt(PDF.FileName, '.txt'));
              Free;
            end;
          end;
        end;

        //FREE TPrintPDF VCL
        if PDF <> nil then
        begin
          if FileExists(PDF.FileName) then
            ShellExecute(0, 'Open', pChar(PDF.FileName), '', '', SW_SHOW);
          FreeAndNil(PDF);//.Free;
        end;
        }

        try
          sFilePDF := ExtractFilePath(Application.ExeName) + 'Relatorios\' + ExtractFileName(sArquivoPDF);
          if DirectoryExists(ExtractFilePath(Application.ExeName) + 'Relatorios') = False then
            ForceDirectories(ExtractFilePath(Application.ExeName) + 'Relatorios');

          // Cria o PDF

          {Create TPrintPDF VCL}
          PDF := TPdfDocumentGDI.Create();
          PDF.DefaultPaperSize := psUserDefined;
          PDF.DefaultPageWidth := iLarguraFisica;

          {Set Doc Info}
          PDF.Info.Title        := ExtractFileName(sFilePDF);
          PDF.Info.Creator      := 'Small - ' + ExtractFileName(Application.ExeName);
          PDF.Info.Author       := '';
          PDF.Info.CreationDate := now;

          PDF.Info.Keywords    := '';
          {Set Filename to save}
          PDF.Info.Subject     := sFilePDF;

          {Use Compression: VCL Must compile with ZLIB comes with D3 above}
          PDF.ForceJPEGCompression := 0;

          {Set Page Size}
          PAGE := pdf.AddPage;
          PAGE.PageLandscape := False;

          PAGE.PageWidth   := iLarguraPapel;
          PAGE.PageHeight  := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  2374;

          {Start Printing...}
          for iPagina := 0 to Length(Pagina) -1 do
          begin

            {Print Image}
            PDF.VCLCanvas.Draw(0, 0, Pagina[iPagina].Picture.Graphic);

            if iPagina < Length(Pagina) -1 then
              {Add New Page}
              PAGE := Pdf.AddPage;
            FreeAndNil(Pagina[iPagina]);
          end;

          {End Printing}

          Sleep(500 * Length(Pagina) -1);
        except
          on E: Exception do
          begin
            with TStringList.Create do
            begin
              Text := E.Message;
              SaveToFile(ChangeFileExt(sFilePDF, '.txt'));
              Free;
            end;
          end;
        end;

        PDF.SaveToFile(sFilePDF);

        {FREE TPrintPDF VCL}
        if PDF <> nil then
        begin
          FreeAndNil(PDF);//.Free;
          if FileExists(sFilePDF) then
            ShellExecute(0, 'Open', pChar(sFilePDF), '', '', SW_SHOW);
        end;


        Pagina := nil;

      finally

      end;
    end;

    if Printer.Printing then
      Printer.Abort;

    Screen.Cursor := FCursor;
  end;
end;

end.
