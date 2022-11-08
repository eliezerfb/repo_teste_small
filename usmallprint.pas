unit usmallprint;

interface

uses
  SysUtils, Classes, ExtCtrls, Graphics, Windows, Forms, Printers, StdCtrls,
  StrUtils, tnpdf;

const FONT_NAME_DEFAULT = 'FontB88';
const FONT_SIZE_DEFAULT = 7;
const ALTURA_PAGINA_PDF = 2448;
const PERCENTUAL_LARGURA_LOGO_X_LARGURA_PAPEL = 0.2721518987341772;
const LARGURA_REFERENCIA_PAPEL_BOBINA = 640; //639

type
  TAlinhamento = (poLeft, poRight, poCenter, poJustify);

  TAmbiente = (taProducao, taTeste);

  TDestinoExtrato = (toPrinter, toImage);

type
  TSmallPrint = class(TComponent)
  private
    { Private declarations }
    iLarguraFisica: Integer;
    iPixelsPerInch: Integer;
    iLarguraPapel: Integer;
    iMargemEsq: Integer;
    iAlturaPDF: Integer;
    iAlturaFonte: Integer;
    iLarguraFonte: Integer;
    iPrimeiraLinhaPapel: Integer; // PosiÁ„o onde pode ser impresso a primeira linha em cada p·gina
    iLinha: Integer;
    iPageHeight: Integer;
    Pagina: Array of TImage; // Imagem que receber· os textos e outras imagem
    FCanvas: TCanvas;
    FDestino: TDestinoExtrato;
    FTitulo: String;
    FTamanhoPapel: String;
    iPrinterPhysicalWidth: Integer;
    FPDF: TPrintPDF;
    function GetPrinterPhysicalWidth: Integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Iniciar;
    procedure Finalizar;
    function CanvasLinha(var iPosicao: Integer; mm: Double;
      iTopo: Integer): Integer;
    function CriaPagina: TImage;
    procedure PrinterTexto(iLinha: Integer; iColuna: Integer;
      Texto: String; Alinhamento: TAlinhamento = poLeft; FontName: String = FONT_NAME_DEFAULT);
    procedure PrinterTextoMemo(iLinha: Integer; iColuna: Integer;
      iLargura: Integer; Texto: String; Alinhamento: TAlinhamento = poLeft);
    procedure NovaLinha;
    property DestinoImpressao: TDestinoExtrato read FDestino write FDestino;
    property Canvas: TCanvas read FCanvas write FCanvas;
    property Titulo: String read FTitulo write FTitulo;
    property LarguraPapel: String read FTamanhoPapel write FTamanhoPapel;
    property PDF: TPrintPDF read FPDF write FPDF;
    property LarguraLinha: Integer read iLarguraPapel;
    property Linha: Integer read iLinha write iLinha;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Smallsoft', [TSmallPrint]);
end;

{ TSmallPrint }

function TSmallPrint.CriaPagina: TImage;
var
  iPages: Integer;
  procedure NumerarPagina(Canvas: TCanvas; iNumero: Integer);
  begin
    Canvas.Font.Size := Canvas.Font.Size - 2;
    SetTextAlign(Canvas.Handle, TA_RIGHT);
    Canvas.TextOut(iLarguraPapel, iAlturaPDF - iAlturaFonte, 'P·gina ' + IntToStr(iNumero));
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
    FCanvas := Pagina[iPages].Canvas;
    FCanvas.Font.PixelsPerInch := 215; // Sandro Silva 2017-04-13  203;
    FCanvas.Font.Size          := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 Acertar a fonte depois de Canvas.Font.PixelsPerInch, que deixa a fonte menor
    iMargemEsq          := 10;
    iLinha              := 50;
    iAlturaFonte        := Pagina[iPages].Canvas.TextHeight('…g');// - 3; // Sandro Silva 2017-04-17 ; // Calcula a altura ocupada pelo texto, inclusive acentuados ou caracteres como "jgyqÁp";
    iLarguraFonte       := Pagina[iPages].Canvas.TextWidth('W');
    iPrimeiraLinhaPapel := iLinha + iAlturaFonte;
    Pagina[iPages].Canvas.Font.Style := [];
    Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
    Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; //14;

    if iPages > 0 then
      iLinha := iPrimeiraLinhaPapel;

    iPageHeight := Pagina[iPages].Height;

    // Numerando as p·ginas
    NumerarPagina(Pagina[iPages].Canvas, iPages + 1);
    Result := Pagina[iPages];
  except
    Result := nil
  end;
end;

function TSmallPrint.CanvasLinha(var iPosicao: Integer; mm: Double; iTopo: Integer): Integer;
{Sandro Silva 2013-01-10 inicio
AvanÁa a posiÁ„o verticar do Canvas para impress„o}
begin

  iPosicao := iPosicao + Round(mm);

  if FDestino = toImage then
  begin
    if iPosicao + Trunc(mm / 3) > (iAlturaPDF - (iAlturaFonte * 2)) then
      CriaPagina;
  end
  else
  begin
    if iPosicao >= (iPageHeight - (iAlturaFonte * 2)) then // Controla avanÁo de p·ginas // Sandro Silva 2018-03-20  if iPosicao >= (Printer.PageHeight - (iAlturaFonte * 2)) then // Controla avanÁo de p·ginas
    begin
      Printer.NewPage;
      iPosicao := iTopo;
    end;
  end;
  Result := iPosicao;
end;

procedure TSmallPrint.PrinterTexto(iLinha: Integer; iColuna: Integer;
  Texto: String; Alinhamento: TAlinhamento = poLeft; FontName: String = FONT_NAME_DEFAULT);
begin
  FCanvas.Font.Name := FontName; // 2016-01-14

  case Alinhamento of
    poCenter:
      begin
        if FDestino = toImage then
          iColuna := Round((iLarguraPapel - iMargemEsq - FCanvas.TextWidth(Texto)) / 2) + iMargemEsq // 2014-05-09
        else
          iColuna := Round((iLarguraPapel - iMargemEsq - FCanvas.TextWidth(Texto)) / 2);
      end;
    poRight:
      begin
        iColuna := iLarguraPapel;
        SetTextAlign(FCanvas.Handle, TA_RIGHT);
      end;
  end;

  FCanvas.TextOut(iColuna, iLinha, Texto);

  SetTextAlign(FCanvas.Handle, TA_LEFT);
end;

procedure TSmallPrint.PrinterTextoMemo(iLinha: Integer; iColuna: Integer;
  iLargura: Integer; Texto: String; Alinhamento: TAlinhamento = poLeft);
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

    if FDestino = toImage then
    begin
      if (iLinha + FCanvas.TextHeight(sTextoLinha)) > iAlturaPDF then
        CriaPagina;
    end;

    case Alinhamento of
      poCenter:
        begin
          iColuna := Round((iLargura - FCanvas.TextWidth(sTextoLinha)) / 2);
        end;
      poRight:
        begin
          iColuna := iLargura;
          SetTextAlign(FCanvas.Handle, TA_RIGHT);
        end;
    end;

    FCanvas.TextOut(iColuna, iLinha, Trim(sTextoLinha));

    SetTextAlign(FCanvas.Handle, TA_LEFT);

  end;
begin
  reTexto := TMemo.Create(nil);
  reTexto.Left       := -1000;
  reTexto.Top        := -1000;
  reTexto.Visible    := False;
  reTexto.Parent     := Application.MainForm; // Sandro Silva 2017-04-27  Screen.ActiveForm;
  reTexto.ParentFont := False;
  reTexto.Font       := FCanvas.Font;
  reTexto.Width      := iLargura;
  reTexto.Repaint;

  slTexto    := TStringList.create;
  sTextoOrig := Texto;
  sTexto     := sTextoOrig;
  reTexto.Lines.Assign(sBreakApart(sTextoOrig, ' ', slTexto));

  sTextoOrig := StringReplace(sTextoOrig, #$D#$A, '', [rfReplaceAll]);
  while AnsiContainsText(sTextoOrig, '  ') do
    sTextoOrig := StringReplace(sTextoOrig, '  ', ' ', [rfReplaceAll]);

  iMemoLine := 0;
  while (sTextoOrig <> '') do
  begin
    sTexto := reTexto.Lines.Strings[iMemoLine] + ' ';
    if (FCanvas.TextWidth(sTextoLinha + sTexto) <= iLargura) and (iMemoLine <= reTexto.Lines.Count) then
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

procedure TSmallPrint.Iniciar;
begin
  FCanvas := TCanvas.Create;

  Printer.Title := FTitulo;
  Printer.BeginDoc;

  FCanvas := Printer.Canvas;

  if FDestino = toImage then
  begin
    iAlturaPDF     := ALTURA_PAGINA_PDF;
    iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;
    iPixelsPerInch := 600;
  end
  else
  begin
    iLarguraFisica := GetPrinterPhysicalWidth;

    if FTamanhoPapel <> '' then
    begin
      if FTamanhoPapel = '58' then
        iLarguraFisica := 384;
      if FTamanhoPapel = '76' then
        iLarguraFisica := 512;
      if FTamanhoPapel = '80' then
        iLarguraFisica := 576; //588;
      if FTamanhoPapel = 'A4' then
        iLarguraFisica := 4961;
    end;

    if (FTamanhoPapel <> 'A4') and (iLarguraFisica > LARGURA_REFERENCIA_PAPEL_BOBINA) then
    begin
      iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;// 1678;
    end;

    iPixelsPerInch := 600; // Sandro Silva 2016-12-07
    iPageHeight  := Printer.PageHeight;  //nops xxxx 2448
  end;

  if FDestino = toPrinter then
  begin
    Printer.Canvas.Font.Name          := FONT_NAME_DEFAULT;
    Printer.Canvas.Font.Size          := FONT_SIZE_DEFAULT;
    Printer.Canvas.Font.Style         := [fsBold];
    Printer.Canvas.Font.PixelsPerInch := iPixelsPerInch; // 2014-05-09
    FCanvas.Font.PixelsPerInch         := iPixelsPerInch;// GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSX);
    iMargemEsq                        := 2;// Sandro Silva 2018-03-20  5;// 2015-05-07 0;
    iLinha                            := 50;
    iAlturaFonte                      := Printer.Canvas.TextHeight('…g') - 1;// Sandro Silva 2017-04-18  Printer.Canvas.TextHeight('…g') - 3; // Calcula a altura ocupada pelo texto;
    iLarguraFonte                     := Printer.Canvas.TextWidth('W');

    iPrinterPhysicalWidth := iLarguraFisica;// Sandro Silva 2018-06-15  GetPrinterPhysicalWidth; // Sandro Silva 2017-09-12

    if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
      iLarguraPapel := 1678
    else
      if iPrinterPhysicalWidth > 464 then
      begin
        if iPrinterPhysicalWidth < 576 then // Sandro Silva 2018-06-15
          iLarguraPapel := 512
        else
          iLarguraPapel := iPrinterPhysicalWidth //512 - Sweda SI-300  // Sandro Silva 2018-06-13  576
      end
      else
        iLarguraPapel := iPrinterPhysicalWidth;// Sandro Silva 2018-06-14  GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// ¡rea de impress„o descontando margens Sandro Silva 2016-12-07   Printer.PageWidth;

    Printer.Canvas.Font.Style := [];
    Printer.Canvas.Font.Name  := FONT_NAME_DEFAULT;
    Printer.Canvas.Font.Size  := FONT_SIZE_DEFAULT;

    iPrimeiraLinhaPapel       := 50 + iAlturaFonte;// Sandro Silva 2017-04-18  40 + iAlturaFonte;
  end
  else
  begin
    iLarguraPapel             := 588; // Sandro Silva 2017-04-18  576;// LARGURA_REFERENCIA_PAPEL_BOBINA; // Sandro Silva 2017-04-10
    CriaPagina; // Cria nova p·gina no array
  end;

end;

function TSmallPrint.GetPrinterPhysicalWidth: Integer;
begin
  Result := GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// Sandro Silva 2018-06-15  Result := GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH);
end;

procedure TSmallPrint.Finalizar;
var
  iPagina: Integer;
begin
  if FDestino = toImage then
  begin
    try

      Printer.Abort;

      try
        // Cria o PDF

        {Create TPrintPDF VCL}
        //PDF := TPrintPDF.Create(Self);

        {Set Doc Info}
        //FPDF.TITLE       := ExtractFileName(sFileCFeSAT);
        //FPDF.Creator     := 'Smallsoft - ' + ExtractFileName(Application.ExeName);
        //FPDF.Author      := xmlNodeValue(sCFeXML, '//emit/xNome');
        //FPDF.Keywords    := FPDFKeyWords;
        FPDF.Producer    := 'Smallsoft - ' + ExtractFileName(Application.ExeName);
        {Set Filename to save}
        //if sFileExport = '' then // 2015-06-30
        //  FPDF.Subject     := ExtractFileName(sFileCFeSAT)
        //else
        //  FPDF.Subject     := sFileExport;

        //FPDF.JPEGQuality := 100; //2015-05-15 50;

        {Use Compression: VCL Must compile with ZLIB comes with D3 above}
        //FPDF.Compress    := False; // Sandro Silva 2017-04-11  True;

        {Set Page Size}
        FPDF.PageWidth   := iLarguraFisica;
        FPDF.PageHeight  := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  2374;

        {Set Filename to save}
        //if sFileExport = '' then // 2015-06-30
        //  FPDF.FileName  := ExtractFilePath(Application.ExeName) + 'CFeSAT\' + sFileCFeSAT + '.pdf'
        //else
        //  FPDF.FileName  := sFileExport;

        {Start Printing...}
        FPDF.BeginDoc;

        for iPagina := 0 to Length(Pagina) -1 do
        begin

          {Print Image}
          FPDF.DrawJPEG(0, 0, Pagina[iPagina].Picture.Bitmap);

          if iPagina < Length(Pagina) -1 then
            {Add New Page}
            FPDF.NewPage;
          FreeAndNil(Pagina[iPagina]);
        end;

        {End Printing}
        //sRetornoGeraPDF := FPDF.EndDoc;
        FPDF.EndDoc;
        //if sRetornoGeraPDF <> '' then
        //  FLogRetornoMobile := sRetornoGeraPDF;// Sandro Silva 2016-11-09  SmallMsgBox(PChar(sRetornoGeraPDF), 'AtenÁ„o', MB_ICONWARNING + MB_OK);

        Sleep(500 * Length(Pagina) -1);
      except
        on E: Exception do
        begin
          //sRetornoGeraPDF := FPDF.FileName + ' j· est· aberto';
        end;
      end;

      {FREE TPrintPDF VCL}
      //if FPDF <> nil then
      //  FreeAndNil(FPDF);//.Free;

      Pagina := nil;

    finally

    end;
  end
  else
  begin
    Printer.EndDoc;
  end;

end;

constructor TSmallPrint.Create;
begin
  FPDF := TPrintPDF.Create(Self);
  FTamanhoPapel := '80'; // Inicia com papel lagura 80 mm (Bobina)
  Inherited;
end;

destructor TSmallPrint.Destroy;
begin
  FreeAndNil(FPDF);
  inherited;
end;

procedure TSmallPrint.NovaLinha;
begin
  iAlturaFonte := Canvas.TextHeight('WÁjqp› √');
  CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
end;

end.
