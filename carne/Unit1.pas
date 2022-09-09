unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Printers, Db, DBTables, SmallFunc, Grids, DBGrids, IniFiles,
  ComCtrls, Buttons, IBDatabase, IBCustomDataSet;

type
  TForm1 = class(TForm)
    PrintDialog1: TPrintDialog;
    Button4: TButton;
    Button1: TButton;
    Panel2: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label62: TLabel;
    Image3: TImage;
    Label44: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Panel3: TPanel;
    Label1: TLabel;
    Shape3: TShape;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Shape4: TShape;
    Label8: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label43: TLabel;
    Label37: TLabel;
    Shape16: TShape;
    Label38: TLabel;
    Shape5: TShape;
    Label24: TLabel;
    Label25: TLabel;
    Label6: TLabel;
    Shape6: TShape;
    Label7: TLabel;
    Shape14: TShape;
    Shape15: TShape;
    Label23: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Edit4: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Shape7: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label26: TLabel;
    Shape13: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape17: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Label27: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Shape23: TShape;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Shape24: TShape;
    Shape25: TShape;
    Label66: TLabel;
    Label67: TLabel;
    Shape26: TShape;
    Label68: TLabel;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Shape18: TShape;
    ColorDialog1: TColorDialog;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    FontDialog1: TFontDialog;
    Image10: TImage;
    Image11: TImage;
    Image9: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    DataSource1: TDataSource;
    Label69: TLabel;
    Image33: TImage;
    Label70: TLabel;
    Image34: TImage;
    botao_fraco: TImage;
    Botao_forte: TImage;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Shape2: TShape;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    ibDataSet2: TIBDataSet;
    ibDataSet7: TIBDataSet;
    ibDataSet7DOCUMENTO: TStringField;
    ibDataSet7VENCIMENTO: TDateField;
    ibDataSet7VALOR_DUPL: TFloatField;
    ibDataSet7PORTADOR: TStringField;
    ibDataSet7HISTORICO: TStringField;
    ibDataSet7NOME: TStringField;
    ibDataSet7EMISSAO: TDateField;
    ibDataSet7RECEBIMENT: TDateField;
    ibDataSet7VALOR_RECE: TFloatField;
    ibDataSet7VALOR_JURO: TFloatField;
    ibDataSet7ATIVO: TSmallintField;
    ibDataSet7CONTA: TIBStringField;
    ibDataSet7NOSSONUM: TIBStringField;
    ibDataSet7CODEBAR: TIBStringField;
    ibDataSet7NUMERONF: TIBStringField;
    ibDataSet7REGISTRO: TIBStringField;
    ibDataSet13: TIBDataSet;
    ibDataSet13NOME: TIBStringField;
    ibDataSet13CONTATO: TIBStringField;
    ibDataSet13ENDERECO: TIBStringField;
    ibDataSet13COMPLE: TIBStringField;
    ibDataSet13MUNICIPIO: TIBStringField;
    ibDataSet13CEP: TIBStringField;
    ibDataSet13ESTADO: TIBStringField;
    ibDataSet13CGC: TIBStringField;
    ibDataSet13IE: TIBStringField;
    ibDataSet13TELEFO: TIBStringField;
    ibDataSet13EMAIL: TIBStringField;
    ibDataSet13HP: TIBStringField;
    ibDataSet13COPE: TFloatField;
    ibDataSet13RESE: TFloatField;
    ibDataSet13CVEN: TFloatField;
    ibDataSet13IMPO: TFloatField;
    ibDataSet13LUCR: TFloatField;
    ibDataSet13ICME: TFloatField;
    ibDataSet13ICMS: TFloatField;
    ibDataSet13REGISTRO: TIBStringField;
    Image1: TImage;
    procedure ImprimeDadosCarne(iColunaInicial : integer; iLinhaInicial : integer; iColunaFinal : integer; iLinhaFinal : integer);
    procedure FormCreate(Sender: TObject);
    procedure MostraDadosNaTela();
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure MudaA4();
    procedure ImprimeDadosDuplicata(iColunaInicial : integer; iLinhaInicial : integer);
    procedure Image2DblClick(Sender: TObject);
    procedure Image4DblClick(Sender: TObject);
    procedure Label28DblClick(Sender: TObject);
    procedure Label33DblClick(Sender: TObject);
    procedure FontesEmitente();
    procedure FontesInformacoes();
    procedure Cor1();
    procedure Cor2();
    procedure Button2Click(Sender: TObject);
    procedure AppActivate(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure Edit4Click(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Exit(Sender: TObject);
    procedure Button4Enter(Sender: TObject);
    procedure Button4Exit(Sender: TObject);
    procedure Label69MouseLeave(Sender: TObject);
    procedure Label69MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label70MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label70MouseLeave(Sender: TObject);
    procedure Label69Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    iRecordCount : Integer;
    sAtual : string;
    ArqIni : TiniFile;
    bSai   : boolean;
    kPonto : tBookMark;
  end;

var
  Form1: TForm1;

implementation

function Altura(MM : Double) : Longint;
var
  mmPointY : Real;
  PageSize, OffSetUL : TPoint;
begin
  mmPointY := Printer.PageHeight / GetDeviceCaps(Printer.Handle,VERTSIZE);
  Escape (Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
  Escape (Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
  if MM > 0 then Result := round ((MM * mmPointY) - OffSetUL.Y) else Result := round (MM * mmPointY);
end;

function Largura(MM : Double) : Longint;
var
  mmPointX : Real;
  PageSize, OffSetUL : TPoint;
begin
  mmPointX := Printer.PageWidth / GetDeviceCaps(Printer.Handle,HORZSIZE);
  Escape (Printer.Handle,GETPRINTINGOFFSET,0,nil,@OffSetUL);
  Escape (Printer.Handle,GETPHYSPAGESIZE,0,nil,@PageSize);
  if MM > 0 then Result := round ((MM * mmPointX) - OffSetUL.X) else Result := round (MM * mmPointX);
end;

{$R *.DFM}
procedure TForm1.MudaA4();
var
  Device : array[0..255] of char;
  Driver : array[0..255] of char;
  Port   : array[0..255] of char;
  hDMode : THandle;
  PDMode : PDEVMODE;
begin
  Printer.PrinterIndex := Printer.PrinterIndex;
  Printer.GetPrinter(Device, Driver, Port, hDMode);
  if hDMode <> 0 then
  begin
    pDMode := GlobalLock(hDMode);
    if pDMode <> nil then
    begin
      pDMode^.dmFields := pDMode^.dmFields or dm_PaperSize;
      pDMode^.dmPaperSize := DMPAPER_A4;
      //pDMode^.dmPaperSize := DMPAPER_LETTER;
      //pDMode^.dmPaperSize := DMPAPER_LEGAL;
      //pDMode^.dmPaperSize := DMPAPER_A4;
      //pDMode^.dmPaperSize := DMPAPER_LETTER_PLUS;
      //pDMode^.dmPaperSize := DMPAPER_EXECUTIVE
      //pDMode^.dmPaperSize := DMPAPER_A4_PLUS
    end;
  end;
end;

procedure TForm1.MostraDadosNaTela();
var
  sExtenso, sNumeroDuplicata : string;
  i : integer;
  fTotal : double;
begin
  //
  if IsNumericString(right(Label22.Caption, 1)) = True then sNumeroDuplicata := Label22.Caption else sNumeroDuplicata := copy(Label22.Caption, 1, Length(Label22.Caption) - 1);
{
  ibDataSet7.Close;
  ibDataSet7.SelectSQL.Clear;
  if copy(sNumeroDuplicata, 1, 1) = 'S' then
     ibDataSet7.SelectSQL.Add('SELECT * FROM RECEBER WHERE DOCUMENTO LIKE(''' + right('0000000000' + sNumeroDuplicata, 9) + '%'') ' +
                    'ORDER BY VENCIMENTO')
  else
     ibDataSet7.SelectSQL.Add('SELECT * FROM RECEBER WHERE DOCUMENTO LIKE(''' + right('0000000000' + sNumeroDuplicata, 9) + '%'') ' +
                    'OR DOCUMENTO LIKE(''R' + right('000000009' + sNumeroDuplicata, 9) + '%'') ORDER BY VENCIMENTO');
  ibDataSet7.Open;
}

  ibDataSet7.Close;
  ibDataSet7.SelectSQL.Clear;
  ibDataSet7.SelectSQL.Add('SELECT * FROM RECEBER WHERE DOCUMENTO LIKE '+QuotedStr(sNumeroDuplicata+'%')+' ORDER BY VENCIMENTO');
  ibDataSet7.Open;
  //
  ibDataSet7.First;
  while not ibDataSet7.Eof do
  begin
    iRecordCount := iRecordCount + 1;
    ibDataSet7.Next;
  end;
  //
  if iRecordCount = 0 then
  begin
    //
    // ShowMEssage(ibDataSet7.SelectSQL.Text);
    //
    MessageDlg('Não é possível identificar os dados deste registro.' + Chr(10) + 'Verifique o número do documento.', mtError, [mbok], 0);
    Winexec('TASKKILL /F /IM carne.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM smalldupl.exe' , SW_HIDE );
  end;
  //
  ibDataSet2.Close;
  ibDataSet2.SelectSQL.Clear;
  ibDataSet2.SelectSQL.Add('SELECT * FROM CLIFOR WHERE NOME=''' + ibDataSet7.FieldByName('NOME').AsString + '''');
  ibDataSet2.Open;

  ibDataSet13.Close;
  ibDataSet13.SelectSQL.Clear;
  ibDataSet13.SelectSQL.Add('SELECT * FROM EMITENTE');
  ibDataSet13.Open;

  ibDataSet7.First;
  for i:=1 to iRecordCount do
  begin
    if ibDataSet7.FieldByName('DOCUMENTO').AsString = Label22.Caption then kPonto := ibDataSet7.GetBookmark;
    ibDataSet7.Next;
  end;
  ibDataSet7.GotoBookmark(kponto);
  //
  // Carnê
  //
  Label17.Caption := Alltrim(Copy(ibDataSet2.FieldByName('NOME').AsString+Replicate(' ',35),1,35)) + ' - ' + ibDataSet2.FieldByName('CGC').AsString;
  Label18.Caption := ibDataSet2.FieldByName('ENDERE').AsString + ' - ' + ibDataSet2.FieldByName('COMPLE').AsString;
  Label19.Caption := ibDataSet2.FieldByName('CEP').AsString + ' - ' + ibDataSet2.FieldByName('CIDADE').AsString + ' - ' + ibDataSet2.FieldByName('ESTADO').AsString;
  Label38.Caption := IntToStr(ibDataSet7.RecNo) + '/' + IntToStr(iRecordCount);
  Label20.Caption := ibDataSet7.FieldByName('EMISSAO').AsString;
  Label21.Caption := ibDataSet7.FieldByName('VENCIMENTO').AsString;
  Label11.Caption := ibDataSet7.FieldByName('RECEBIMENT').AsString;
  Label23.Caption := Format('%n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]);
  Label9.Caption := Format('%n', [ibDataSet7.FieldByName('VALOR_RECE').AsFloat]);
  //
  fTotal := 0;
  //
  ibDataSet7.First;
  while not ibDataSet7.eof do
  begin
    fTotal := fTotal + ibDataSet7.FieldByName('VALOR_DUPL').AsFloat;
    ibDataSet7.Next;
  end;

  ibDataSet7.First;
  for i:=1 to iRecordCount do
  begin
    if ibDataSet7.FieldByName('DOCUMENTO').AsString = Label22.Caption then kPonto := ibDataSet7.GetBookmark;
    ibDataSet7.Next;
  end;
  ibDataSet7.GotoBookmark(kponto);
  //
  // Duplicata
  //
  Label33.Caption := Format('%9.2n', [fTotal]);;
  Label34.Caption := sNumeroDuplicata;
  Label35.Caption := Format('%9.2n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]);
  Label36.Caption := ibDataSet7.FieldByName('DOCUMENTO' ).AsString;
  Label39.Caption := ibDataSet7.FieldByName('VENCIMENTO').AsString;
  Label28.Caption := AllTrim(Copy(UpperCase(ConverteAcentos(ibDataSet13.FieldByName('NOME').AsString))+Replicate(' ',35),1,35));
  Label29.Caption := ibDataSet13.FieldByName('ENDERECO').AsString;
  Label30.Caption := ibDataSet13.FieldByName('CEP'   ).AsString + ' - ' +ibDataSet13.FieldByName('MUNICIPIO').AsString + ' - ' + ibDataSet13.FieldByName('ESTADO').AsString;
  Label44.Caption := 'FONE: ' + AllTrim(ibDataSet13.FieldByName('TELEFO').AsString);
  Label31.Caption := 'INSCRIÇÃO CNPJ: ' + ibDataSet13.FieldByName('CGC').AsString;
  Label32.Caption := 'INSCRIÇÃO ESTADUAL: ' + ibDataSet13.FieldByName('IE').AsString;
  //
  Label50.Caption := ibDataSet2.FieldByName('NOME'  ).AsString;
  Label51.Caption := ibDataSet2.FieldByName('ENDERE').AsString;
  Label52.Caption := ibDataSet2.FieldByName('CEP').AsString+' - '+ibDataSet2.FieldByName('CIDADE').AsString;
  Label53.Caption := ibDataSet2.FieldByName('ESTADO').AsString;
  Label54.Caption := ibDataSet2.FieldByName('CGC'   ).AsString;
  Label57.Caption := ibDataSet2.FieldByName('IE'    ).AsString;
  //
  sExtenso := Extenso(ibDataSet7.FieldByName('VALOR_DUPL').AsFloat);
  sExtenso := sExtenso + '. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ';
  Label42.Caption := sExtenso;
  Label41.Caption := 'QUE PAGAREI(EMOS) À ' + Label28.Caption + ', OU À SUA ORDEM NA PRAÇA E VENCIMENTO INDICADOS.';
  //
end;

procedure TForm1.ImprimeDadosDuplicata(iColunaInicial : integer; iLinhaInicial : integer);
var
  i, iAngulo : integer;
  sExtenso : string;
begin
  iAngulo := 70;
  Printer.Canvas.Brush.Style := bsClear;
  Printer.Canvas.Font.Name := Label29.Font.Name;
  Printer.Canvas.Font.Size := Label29.Font.Size + 2;
  Printer.Canvas.Font.Style := Label29.Font.Style;
  Printer.Canvas.Font.Color := Label29.Font.Color;
  Printer.Canvas.Pen.Style := psSolid;
  Printer.Canvas.StretchDraw(Rect(Largura(iColunaInicial ), Altura(iLinhaInicial ), Largura(iColunaInicial + 80), Altura(iLinhaInicial + 20)), Form1.Image3.Picture.Bitmap);
  //
  // Logotipo
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial), Altura(iLinhaInicial), Largura(iColunaInicial + 89), Altura(iLinhaInicial + 34), iAngulo, iAngulo);
  //
  // Dados da empresa
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 89), Altura(iLinhaInicial), Largura(200), Altura(iLinhaInicial + 34), iAngulo, iAngulo);
  //
  // Dados da duplicata
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial), Altura(iLinhaInicial + 34), Largura(200), Altura(iLinhaInicial + 132), iAngulo, iAngulo);
  //
  // Dados da fatura
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 4), Altura(iLinhaInicial + 39), Largura(iColunaInicial + 146), Altura(iLinhaInicial + 56), iAngulo, iAngulo);
  //
  // Uso da instituição financeira
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 149), Altura(iLinhaInicial + 39), Largura(198), Altura(iLinhaInicial + 64), iAngulo, iAngulo);
  //
  // Dados do cliente
  //
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 70), Largura(198), Altura(iLinhaInicial + 112), iAngulo, iAngulo);
  //
  // Valor por extenso
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 97), Largura(198), Altura(iLinhaInicial + 97) + 2);
  //
  // Valor por extenso
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 65), Altura(iLinhaInicial + 97), Largura(iColunaInicial + 65) + 2, Altura(iLinhaInicial + 112));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 2), AllTrim(Copy(ibDataSet13.FieldByName('NOME'  ).AsString+Replicate(' ',35),1,35)));
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Font.Size := 7;
  Printer.Canvas.TextOut((Largura(45) - Printer.Canvas.TextWidth('PARA USO DA')) div 2 + Largura(iColunaInicial + 149), Altura(iLinhaInicial + 40), 'PARA USO DA');
  Printer.Canvas.TextOut((Largura(45) - Printer.Canvas.TextWidth('INSTITUIÇÃO FINANCEIRA')) div 2 + Largura(iColunaInicial + 149), Altura(iLinhaInicial + 43), 'INSTITUIÇÃO FINANCEIRA');
  Printer.Canvas.Font.Size := Label29.Font.Size;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 6), ibDataSet13.FieldByName('ENDERECO').AsString + ' - ' + ibDataSet13.FieldByName('COMPLE').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 10), ibDataSet13.FieldByName('CEP'   ).AsString + ' - ' + ibDataSet13.FieldByName('MUNICIPIO').AsString + ' - ' + ibDataSet13.FieldByName('ESTADO').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 14), 'FONE: ' + ibDataSet13.FieldByName('TELEFO').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 18), 'INSCRIÇÃO CNPJ: ' + ibDataSet13.FieldByName('CGC').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 22), 'INSCRIÇÃO ESTADUAL: ' + ibDataSet13.FieldByName('IE').AsString);  //
  Printer.Canvas.TextOut(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 28), 'DATA DA EMISSÃO: ' + DateToStr(Date));  //
  Printer.Canvas.Font.Name := Label33.Font.Name;
  Printer.Canvas.Font.Size := Label33.Font.Size;
  Printer.Canvas.Font.Style := Label33.Font.Style;
  Printer.Canvas.Font.Color := Label33.Font.Color;
  //
  // IMPRIME O FUNDO EM ALGUNS CAMPOS
  //
  // DADOS DA FATURA
  Printer.Canvas.Brush.Color := Shape7.Brush.Color;
  Printer.Canvas.Pen.Style := psClear;
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 4)+2, Altura(iLinhaInicial + 41), Largura(iColunaInicial + 146)-2, Altura(iLinhaInicial + 49));
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 4)+2, Altura(iLinhaInicial + 39)+3, Largura(iColunaInicial + 146)-2, Altura(iLinhaInicial + 49), iAngulo, iAngulo);
  // VALOR POR EXTENSO
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 45), Altura(iLinhaInicial + 98), Largura(iColunaInicial + 65), Altura(iLinhaInicial + 112));
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 42)+2, Altura(iLinhaInicial + 97)+2, Largura(iColunaInicial + 65), Altura(iLinhaInicial + 100));
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 42)+2, Altura(iLinhaInicial + 97)+2, Largura(iColunaInicial + 65), Altura(iLinhaInicial + 112)-2, iAngulo, iAngulo);
  // DADOS DA FATURA
  Printer.Canvas.Brush.Color := Shape27.Brush.Color;
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 4)+2, Altura(iLinhaInicial + 49), Largura(iColunaInicial + 34)-2, Altura(iLinhaInicial + 52));
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 30)+2, Altura(iLinhaInicial + 49), Largura(iColunaInicial + 34)-2, Altura(iLinhaInicial + 56));
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 4)+2, Altura(iLinhaInicial + 49)+3, Largura(iColunaInicial + 34)-2, Altura(iLinhaInicial + 56)-2, iAngulo, iAngulo);
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 56)+2, Altura(iLinhaInicial + 49), Largura(iColunaInicial + 91)-2, Altura(iLinhaInicial + 56));
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 116)+2, Altura(iLinhaInicial + 49), Largura(iColunaInicial + 120), Altura(iLinhaInicial + 56));
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 130), Altura(iLinhaInicial + 49), Largura(iColunaInicial + 146)-2, Altura(iLinhaInicial + 53));
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 116)+2, Altura(iLinhaInicial + 49)+2, Largura(iColunaInicial + 146)-2, Altura(iLinhaInicial + 56)-2, iAngulo, iAngulo);
  // VALOR POR EXTENSO
  Printer.Canvas.RoundRect(Largura(iColunaInicial + 65)+3, Altura(iLinhaInicial + 97)+2, Largura(iColunaInicial + 190)-2, Altura(iLinhaInicial + 112)-2, iAngulo, iAngulo);
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 65)+2, Altura(iLinhaInicial + 97)+2, Largura(iColunaInicial + 68), Altura(iLinhaInicial + 112));
  Printer.Canvas.RecTangle(Largura(iColunaInicial + 185)+2, Altura(iLinhaInicial + 97)+2, Largura(iColunaInicial + 190), Altura(iLinhaInicial + 105));
  // VOLTA AO NORMAL
  Printer.Canvas.Brush.Color := clWhite;
  Printer.Canvas.Brush.Style := bsClear;
  Printer.Canvas.Pen.Style := psSolid;
  //              FIM DO FUNDO EM ALGUNS CAMPOS                         //
  Printer.Canvas.Font.Style := [fsBold];
  printer.Canvas.Font.Name := 'Tahoma';
  Printer.Canvas.Font.Color := clBlack;
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 25), Altura(iLinhaInicial + 40),  'FATURA');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 13), Altura(iLinhaInicial + 45),  'VALOR');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 34), Altura(iLinhaInicial + 44) + 2, Largura(iColunaInicial + 34) + 2, Altura(iLinhaInicial + 56));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 39), Altura(iLinhaInicial + 45),  'NÚMERO');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 56), Altura(iLinhaInicial + 39), Largura(iColunaInicial + 56) + 2, Altura(iLinhaInicial + 56));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 78), Altura(iLinhaInicial + 40),  'DUPLICATA');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 69), Altura(iLinhaInicial + 45),  'VALOR');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 91), Altura(iLinhaInicial + 44) + 2, Largura(iColunaInicial + 91) + 2, Altura(iLinhaInicial + 56));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 93), Altura(iLinhaInicial + 45),  'Nº DE ORDEM');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 116), Altura(iLinhaInicial + 39), Largura(iColunaInicial + 116) + 2, Altura(iLinhaInicial + 56));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 121), Altura(iLinhaInicial + 43),  'VENCIMENTO');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 4), Altura(iLinhaInicial + 44) + 2, Largura(iColunaInicial + 116), Altura(iLinhaInicial + 44) + 4);
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 4), Altura(iLinhaInicial + 49), Largura(iColunaInicial + 146), Altura(iLinhaInicial + 49) + 2);
  Printer.Canvas.Font.Name := Label33.Font.Name;
  Printer.Canvas.Font.Size := Label33.Font.Size;
  Printer.Canvas.Font.Style := Label33.Font.Style;
  Printer.Canvas.Font.Color := Label33.Font.Color;
  Printer.Canvas.TextOut(((Largura(35) - Printer.Canvas.TextWidth(Format('%9.2n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]))) div 2) + Largura(iColunaInicial + 56), Altura(iLinhaInicial + 50), Format('%9.2n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]));
  Printer.Canvas.TextOut(((Largura(30) - Printer.Canvas.TextWidth(Label33.Caption)) div 2) + Largura(iColunaInicial + 4), Altura(iLinhaInicial + 50), Label33.Caption);
  Printer.Canvas.TextOut(((Largura(22) - Printer.Canvas.TextWidth(Copy(ibDataSet7.FieldByName('DOCUMENTO').AsString, 1, Length(ibDataSet7.FieldByName('DOCUMENTO').AsString) - 1))) div 2) + Largura(iColunaInicial + 34), Altura(iLinhaInicial + 50), Copy(ibDataSet7.FieldByName('DOCUMENTO').AsString, 1, Length(ibDataSet7.FieldByName('DOCUMENTO').AsString) - 1));
  Printer.Canvas.TextOut(((Largura(26) - Printer.Canvas.TextWidth(ibDataSet7.FieldByName('DOCUMENTO').AsString)) div 2) + Largura(iColunaInicial + 91), Altura(iLinhaInicial + 50), ibDataSet7.FieldByName('DOCUMENTO').AsString);
  Printer.Canvas.TextOut(((Largura(30) - Printer.Canvas.TextWidth(ibDataSet7.FieldByName('VENCIMENTO').AsString)) div 2) + Largura(iColunaInicial + 116), Altura(iLinhaInicial + 50), ibDataSet7.FieldByName('VENCIMENTO').AsString);
  printer.Canvas.Font.Size := 7;
  printer.Canvas.Font.Name := 'Tahoma';
  Printer.Canvas.Font.Color := clBlack;
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 60), 'DESCONTO DE:');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 116), Altura(iLinhaInicial + 60), 'ATÉ:' );
  Printer.Canvas.TextOut(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 65), 'COND. ESPECIAIS:');
  Printer.Canvas.Font.Name := Label33.Font.Name;
  Printer.Canvas.Font.Size := Label33.Font.Size;
  Printer.Canvas.Font.Style := Label33.Font.Style;
  Printer.Canvas.Font.Color := Label33.Font.Color;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 61), Altura(iLinhaInicial + 59), Edit7.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 123), Altura(iLinhaInicial + 59), Edit8.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 65), Altura(iLinhaInicial + 64), Edit9.Text);
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 24), Altura(iLinhaInicial + 60), Largura(iColunaInicial + 24) + 2, Altura(iLinhaInicial + 119));
  //
  printer.Canvas.Font.Size := 7;
  printer.Canvas.Font.Name := 'Tahoma';
  Printer.Canvas.Font.Color := clBlack;
  Printer.Canvas.Font.Style := [];
  //
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44), Altura(iLinhaInicial + 73),  'NOME DO SACADO:'); //72
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44), Altura(iLinhaInicial + 78),  'ENDEREÇO:');       //77
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44), Altura(iLinhaInicial + 83),  'CEP/MUNICÍPIO:');  //82
  Printer.Canvas.TextOut(Largura(iColunaInicial + 140), Altura(iLinhaInicial + 83), 'ESTADO:');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44), Altura(iLinhaInicial + 88),  'PRAÇA DE PAGTO:');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44), Altura(iLinhaInicial + 93),  'INSCRIÇÃO CNPJ:');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 120), Altura(iLinhaInicial + 93),'INSC. ESTADUAL:');
  //
  Printer.Canvas.Font.Name := Label33.Font.Name;
  Printer.Canvas.Font.Size := Label33.Font.Size;
  Printer.Canvas.Font.Style := Label33.Font.Style;
  Printer.Canvas.Font.Color := Label33.Font.Color;
  //
  Printer.Canvas.TextOut(Largura(iColunaInicial + 67), Altura(iLinhaInicial + 72),  ibDataSet2.FieldByName('NOME'  ).AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 58), Altura(iLinhaInicial + 77),  ibDataSet2.FieldByName('ENDERE').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 63), Altura(iLinhaInicial + 82),  ibDataSet2.FieldByName('CEP'   ).AsString + ' - ' +ibDataSet2.FieldByName('CIDADE').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 152), Altura(iLinhaInicial + 82), ibDataSet2.FieldByName('ESTADO').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 66), Altura(iLinhaInicial + 87),  Edit6.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 65), Altura(iLinhaInicial + 92),  ibDataSet2.FieldByName('CGC'   ).AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 141), Altura(iLinhaInicial + 92), ibDataSet2.FieldByName('IE'    ).AsString);
  //
  printer.Canvas.Font.Size := 10;
  printer.Canvas.Font.Name := 'Arial';
  Printer.Canvas.Font.Color := clBlack;
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44) + (Largura(23) - Printer.Canvas.TextWidth('VALOR'  )) div 2, Altura(iLinhaInicial + 98), 'VALOR');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44) + (Largura(23) - Printer.Canvas.TextWidth('POR'    )) div 2, Altura(iLinhaInicial + 102), 'POR');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 44) + (Largura(23) - Printer.Canvas.TextWidth('EXTENSO')) div 2, Altura(iLinhaInicial + 106), 'EXTENSO');
  Printer.Canvas.Font.Name := Label33.Font.Name;
  Printer.Canvas.Font.Size := Label33.Font.Size;
  Printer.Canvas.Font.Style := Label33.Font.Style;
  Printer.Canvas.Font.Color := Label33.Font.Color;
  sExtenso := UpperCase(Extenso(ibDataSet7.FieldByName('VALOR_DUPL').AsFloat));
  sExtenso := sExtenso + ' ';
  while (Largura(iColunaInicial + 67) + Printer.Canvas.TextWidth(sExtenso)) < Largura(313) do sExtenso := sExtenso + '.';
  i:=1;
  if Printer.Canvas.TextWidth(sExtenso) > (Largura(194) - Largura(iColunaInicial + 67)) then
     while (Largura(iColunaInicial + 67) + Printer.Canvas.TextWidth(Copy(sExtenso, 1, i))) < Largura(194) do inc(i);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 67), Altura(iLinhaInicial + 100), Copy(sExtenso, 1, i));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 67), Altura(iLinhaInicial + 104), Copy(sExtenso, i + 1, Length(sExtenso)));
  //
  printer.Canvas.Font.Size := 7;
  printer.Canvas.Font.Name := 'Tahoma';
  Printer.Canvas.Font.Color := clBlack;
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 113), 'RECONHEÇO(EMOS) A EXATIDÃO DESTA DUPLICATA DE VENDA MERCANTIL/PRESTAÇÃO DE SERVIÇOS, NA IMPORTÂNCIA ACIMA');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 42), Altura(iLinhaInicial + 116), 'QUE PAGAREI(EMOS) À ' + AllTrim(Copy(UpperCase(ConverteAcentos(ibDataSet13.FieldByName('NOME').AsString))+Replicate(' ',35),1,35)) + ', OU À SUA ORDEM NA PRAÇA E VENCIMENTO INDICADOS.');
  //
  Printer.Canvas.Font.Size := 10;
  ShortDateFormat := 'dd/mm/yyyy';
  Printer.Canvas.TextOut(Largura(iColunaInicial + 50), Altura(iLinhaInicial + 124), '_____/_____/_____');
//  Printer.Canvas.Rectangle(Largura(iColunaInicial + 46), Altura(iLinhaInicial + 128), Largura(iColunaInicial + 54) + Printer.Canvas.TextWidth('_____/_____/_____'),  Altura(iLinhaInicial + 128) + 2);
  Printer.Canvas.Font.Size := 7;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 50) + (Largura(9) + Printer.Canvas.TextWidth('_____/_____/_____') - Printer.Canvas.TextWidth('DATA DO ACEITE')) div 2, Altura(iLinhaInicial + 128), 'DATA DO ACEITE');
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 129), Altura(iLinhaInicial + 128), Largura(iColunaInicial + 190),  Altura(iLinhaInicial + 128) + 2);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 129) + (Largura(65) - Printer.Canvas.TextWidth('ASSINATURA DO SACADO')) div 2, Altura(iLinhaInicial + 128), 'ASSINATURA DO SACADO');
end;

procedure TForm1.ImprimeDadosCarne(iColunaInicial : integer; iLinhaInicial : integer; iColunaFinal : integer; iLinhaFinal : integer);
begin
  //
  Printer.Canvas.Brush.Style := bsClear;
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Font.Name := 'Tahoma';
  Printer.Canvas.Font.Size := 5;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 36), Altura(iLinhaInicial), AllTrim(Copy(ibDataSet13.FieldByName('NOME').AsString+Replicate(' ',35),1,35))+ ' - ' + ibDataSet13.FieldByName('CGC').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 36), Altura(IlinhaInicial + 2), ibDataSet13.FieldByName('ENDERECO').AsString + ' - ' + ibDataSet13.FieldByName('COMPLE').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 36), Altura(ilinhaInicial + 4), ibDataSet13.FieldByName('CEP').AsString + ' ' + ibDataSet13.FieldByName('MUNICIPIO').AsString + ' - ' + ibDataSet13.FieldByName('ESTADO').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 36), Altura(ilinhaInicial + 6), 'Telefone: ' + ibDataSet13.FieldByName('TELEFO').AsString);
  Printer.Canvas.StretchDraw(Rect(Largura(iColunaInicial), Altura(iLinhaInicial), Largura(iColunaInicial + 36), Altura(iLinhaInicial + 9)), Form1.Image1.Picture.Bitmap);
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(IlinhaInicial + 9), 'DADOS DO CLIENTE:');
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(IlinhaInicial + 11), AllTrim(Copy(ibDataSet2.FieldByName('NOME').AsString+Replicate(' ',35),1,35)) + ' - ' + ibDataSet2.FieldByName('CGC').AsString) ;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(IlinhaInicial + 14), ibDataSet2.FieldByName('ENDERE').AsString + ' - ' + ibDataSet2.FieldByName('COMPLE').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(IlinhaInicial + 17), ibDataSet2.FieldByName('CEP').AsString + '  ' + ibDataSet2.FieldByName('CIDADE').AsString + ' - ' + ibDataSet2.FieldByName('ESTADO').AsString);
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial), Altura(iLinhaInicial + 21), Largura(iColunaFinal), Altura(iLinhaInicial + 21) + 2);
  //
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.Font.Size := 5;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 22), 'Nº DOCUMENTO');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 22), Altura(iLinhaInicial + 22), 'PARCELA Nº');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 43), Altura(iLinhaInicial + 22), 'EMISSÃO');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 69), Altura(iLinhaInicial + 22), 'VENCIMENTO');
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 21), Altura(iLinhaInicial + 21), Largura(iColunaInicial + 1 + 21) + 2, Altura(iLinhaInicial + 28));
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 42), Altura(iLinhaInicial + 21), Largura(iColunaInicial + 1 + 42) + 2, Altura(iLinhaInicial + 28));
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 68), Altura(iLinhaInicial + 21), Largura(iColunaInicial + 1 + 68) + 2, Altura(iLinhaInicial + 28));
  //
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 24), ibDataSet7.FieldByName('DOCUMENTO').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 22), Altura(iLinhaInicial + 24), IntToStr(ibDataSet7.RecNo) + '/' + IntToStr(iRecordCount));
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 43), Altura(iLinhaInicial + 24), ibDataSet7.FieldByName('EMISSAO').AsString);
  Printer.Canvas.Font.Size := 10;

  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 69) + (((Largura(iColunaFinal) - Largura(iColunaInicial + 70)) -
                         Printer.Canvas.TextWidth(ibDataSet7.FieldByName('VENCIMENTO').AsString)) div 2),
                         Altura(iLinhaInicial + 24), ibDataSet7.FieldByName('VENCIMENTO').AsString);
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial), Altura(iLinhaInicial + 28), Largura(iColunaFinal), Altura(iLinhaInicial + 28) + 2);
  //
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.Font.Size := 5;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 29), 'OBSERVAÇÕES:');
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 31), Edit1.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 34), Edit2.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 37), Edit3.Text);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 40), Edit4.Text);
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial), Altura(iLinhaInicial + 44), Largura(iColunaFinal), Altura(iLinhaInicial + 44) + 2);
  //
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.Font.Size := 5;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 45), 'DATA RECEBIMENTO');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 22), Altura(iLinhaInicial + 45), 'JUROS/DESCONTO');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 43), Altura(iLinhaInicial + 45), 'VALOR RECEBIDO');
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 69), Altura(iLinhaInicial + 45), 'VALOR');
  //
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 21), Altura(iLinhaInicial + 44), Largura(iColunaInicial + 1 + 21) + 2, Altura(iLinhaInicial + 51));
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 42), Altura(iLinhaInicial + 44), Largura(iColunaInicial + 1 + 42) + 2, Altura(iLinhaInicial + 51));
  Printer.Canvas.Rectangle(Largura(iColunaInicial + 1 + 68), Altura(iLinhaInicial + 44), Largura(iColunaInicial + 1 + 68) + 2, Altura(iLinhaInicial + 51));
  //
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1), Altura(iLinhaInicial + 47), ibDataSet7.FieldByName('RECEBIMENT').AsString);
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 22), Altura(iLinhaInicial + 47), Edit5.Text);
  //
  if ibDataSet7.FieldByName('VALOR_DUPL').AsFloat <> 0 then
  begin
    Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 43) + (((Largura(iColunaFinal - 26) - Largura(iColunaInicial + 43)) -
                           Printer.Canvas.TextWidth(Format('%n', [ibDataSet7.FieldByName('VALOR_RECE').AsFloat]))) div 2),
                           Altura(iLinhaInicial + 47), Format('%n', [ibDataSet7.FieldByName('VALOR_RECE').AsFloat]));
  end;                         
  //
  Printer.Canvas.Font.Size := 10;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1 + 69) + (((Largura(iColunaFinal) - Largura(iColunaInicial + 70)) -
                         Printer.Canvas.TextWidth(Format('%n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]))) div 2),
                         Altura(iLinhaInicial + 47), Format('%n', [ibDataSet7.FieldByName('VALOR_DUPL').AsFloat]));
  //
  Printer.Canvas.Rectangle(Largura(iColunaInicial), Altura(iLinhaInicial + 51), Largura(iColunaFinal), Altura(iLinhaInicial + 51) + 2);
  //
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.Font.Size := 5;
  Printer.Canvas.TextOut(Largura(iColunaInicial + 1) + (((Largura(iColunaFinal) - Largura(iColunaInicial + 1)) -
                         Printer.Canvas.TextWidth('AUTENTICAÇÃO MECÂNICA')) div 2),
                         Altura(iLinhaInicial + 52), 'AUTENTICAÇÃO MECÂNICA');
end;

procedure TForm1.AppActivate(Sender: TObject);
begin
  bSai := True;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  Mais1Ini : tIniFile;
  url, IP, Alias : String;

begin
  //
  // Abrindo os arquivos
  //
  GetDir(0, sAtual);
  Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
  Url      := Mais1Ini.ReadString('Firebird','Server url','');
  IP       := AllTrim(Mais1Ini.ReadString('Firebird','Server IP',''));
  Alias    := AllTrim(Mais1Ini.ReadString('Firebird','Alias',''));
  //
  if IP <> '' then Url := IP+':'+Url+'\small.fdb' else Url:= Url+'\small.fdb';
  //
  if Alltrim(Alias) <> '' then
  begin
    Url := IP+':'+Alias;
  end;
  //
  Mais1Ini.Free;
  //
  // Se não existe cria o arquivo GDB
  //
  try
    IBDatabase1.Close;
    IBDatabase1.Params.Clear;
    IbDatabase1.DatabaseName := Url;
    IBDatabase1.Params.Add('USER_NAME=SYSDBA');
    IBDatabase1.Params.Add('PASSWORD=masterkey');
    IbDatabase1.Open;
    IBTransaction1.Active := True;
  except
    //
    ShowMessage('Verifique se o servidor de dados está ligado e sua conexão de rede disponível.');
    Winexec('TASKKILL /F /IM carne.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM smalldupl.exe' , SW_HIDE );
    //
  end;
  //
  if UpperCase(ParamStr(2)) <> '' then
  begin
    Label22.Caption := ParamStr(1)
  end else
  begin
    MessageDlg('Número do documento não informado', mtInformation, [mbOk], 0);
    Label22.Caption := '000070051A';
//    Winexec('TASKKILL /F /IM carne.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM smalldupl.exe' , SW_HIDE );
  end;
  //
  if ParamStr(2) = '1' then
  begin
    //
    Panel2.Visible := True;
    Panel3.Visible := False;
    //
    Button4.Left := 625;
    Label70.Left := 625;
    Image34.Left := 625;
    //
    Button1.Left := 515;
    Label69.Left := 515;
    Image33.Left := 515;
    //
    Form1.Width  := 739;
    Form1.Position := poScreenCenter;
    Form1.Tag := 1;
    Form1.Caption := 'Duplicata';
  end else
  begin
    Panel3.Visible := True;
    Panel2.Visible := False;
    //
    Button4.Left := 330;
    Label70.Left := 330;
    Image34.Left := 330;
    //
    Button1.Left := 220;
    Label69.Left := 220;
    Image33.Left := 220;
    //
    Form1.Width := 448;
    Form1.Position := poScreenCenter;
    Form1.Tag := 0;
    Form1.Caption := 'Carnê de pagamento';
  end;
  //  ShowMessage('inicializado');
  if fileexists(sAtual + '\LOGOTIP.BMP') then
  begin
    Image1.Picture.Bitmap.LoadFromFile(sAtual + '\LOGOTIP.BMP');
    Image1.Update;
    Image1.Visible := True;
  end;
  //
  Image3.Picture := Image1.Picture;
  MostraDadosNaTela;
  //
  Image10.Picture := Image9.Picture;
  Image11.Picture := Image9.Picture;
  Image15.Picture := Image9.Picture;
  Image16.Picture := Image9.Picture;
  Image17.Picture := Image9.Picture;
  //
  Image25.Picture := Image14.Picture;
  Image26.Picture := Image14.Picture;
  Image27.Picture := Image14.Picture;
  Image28.Picture := Image14.Picture;
  Image29.Picture := Image14.Picture;
  //
  Image22.Picture := Image12.Picture;
  Image23.Picture := Image12.Picture;
  Image24.Picture := Image12.Picture;
  Image30.Picture := Image12.Picture;
  Image32.Picture := Image12.Picture;
  //
  Image18.Picture := Image13.Picture;
  Image19.Picture := Image13.Picture;
  Image20.Picture := Image13.Picture;
  Image21.Picture := Image13.Picture;
  Image31.Picture := Image13.Picture;
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  //
  ArqINI := TiniFile.create(sAtual + '\smallcom.inf');
  ArqIni.UpdateFile;
  //
  Edit1.Text := ArqIni.ReadString('Carne', 'Linha 1', 'Digite aqui seu texto...');
  Edit2.Text := ArqIni.ReadString('Carne', 'Linha 2', '');
  Edit3.Text := ArqIni.ReadString('Carne', 'Linha 3', '');
  Edit4.Text := ArqIni.ReadString('Carne', 'Linha 4', '');
  Edit5.Text := ArqIni.ReadString('Carne', 'Juros',   '');
  //
  Edit7.Text := ArqIni.ReadString('DUPLICATA', 'Desconto', '10 %');
  Edit8.Text := ArqIni.ReadString('DUPLICATA', 'Ate', '00/00/0000');
  Edit9.Text := ArqIni.ReadString('DUPLICATA', 'Especiais', 'Digite aqui as condições..');
  Edit6.Text := ArqIni.ReadString('DUPLICATA', 'Praca', 'Digite aqui a praça de pagamento..');
  //
  ColorDialog1.Color := ArqIni.ReadInteger('FONTES DUPLICATA', 'Cor1',15579990);
  Cor1;
  ColorDialog1.Color := ArqIni.ReadInteger('FONTES DUPLICATA', 'Cor2', $00EAEAEA);
  Cor2;
  //
  FontDialog1.Font.Name   := ArqIni.ReadString('FONTES DUPLICATA', 'EmitenteName', 'Tahoma');
  FontDialog1.Font.Size   := ArqIni.ReadInteger('FONTES DUPLICATA', 'EmitenteSize', 10);
  FontDialog1.Font.Color  := ArqIni.ReadInteger('FONTES DUPLICATA', 'EmitenteCor', 0);
  if ArqIni.ReadInteger('FONTES DUPLICATA', 'EmitenteStyle', 0) = 1 then
     FontDialog1.Font.Style := [fsBold]
  else if ArqIni.ReadInteger('FONTES DUPLICATA', 'EmitenteStyle', 0) = 2 then
     FontDialog1.Font.Style := [fsItalic]
  else if ArqIni.ReadInteger('FONTES DUPLICATA', 'EmitenteStyle', 0) = 3 then
     FontDialog1.Font.Style := [fsStrikeout]
  else
     FontDialog1.Font.Style := [];

  FontesEmitente;

  FontDialog1.Font.Name   := ArqIni.ReadString('FONTES DUPLICATA', 'InfoName', 'Arial');
  FontDialog1.Font.Size   := ArqIni.ReadInteger('FONTES DUPLICATA', 'InfoSize', 10);
  FontDialog1.Font.Color  := ArqIni.ReadInteger('FONTES DUPLICATA', 'InfoCor', 0);
  if ArqIni.ReadInteger('FONTES DUPLICATA', 'InfoStyle', 0) = 1 then
     FontDialog1.Font.Style := [fsBold]
  else if ArqIni.ReadInteger('FONTES DUPLICATA', 'InfoStyle', 0) = 2 then
     FontDialog1.Font.Style := [fsItalic]
  else if ArqIni.ReadInteger('FONTES DUPLICATA', 'InfoStyle', 0) = 3 then
     FontDialog1.Font.Style := [fsStrikeout]
  else
     FontDialog1.Font.Style := [];
  FontesInformacoes;

  ArqIni.Free;
  Panel2.Repaint;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  ArqINI := TiniFile.create(sAtual + '\smallcom.inf');
  ArqIni.UpdateFile;
  //
  ArqIni.WriteString('Carne', 'Linha 1', Edit1.Text);
  ArqIni.WriteString('Carne', 'Linha 2', Edit2.Text);
  ArqIni.WriteString('Carne', 'Linha 3', Edit3.Text);
  ArqIni.WriteString('Carne', 'Linha 4', Edit4.Text);
  ArqIni.WriteString('Carne', 'Juros', Edit5.Text);

  ArqIni.WriteString('DUPLICATA', 'Desconto', Edit7.Text);
  ArqIni.WriteString('DUPLICATA', 'Ate', Edit8.Text);
  ArqIni.WriteString('DUPLICATA', 'Especiais', Edit9.Text);
  ArqIni.WriteString('DUPLICATA', 'Praca', Edit6.Text);
  //
  ArqIni.WriteInteger('FONTES DUPLICATA', 'Cor1', Shape7.Brush.Color);
  ArqIni.WriteInteger('FONTES DUPLICATA', 'Cor2', Shape27.Brush.Color);

  ArqIni.WriteString('FONTES DUPLICATA', 'EmitenteName', Label29.Font.Name);
  ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteSize', Label29.Font.Size);
  ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteCor', Label29.Font.Color);

  if Label29.Font.Style = [fsBold] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteStyle', 1)
  else if Label29.Font.Style = [fsItalic] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteStyle', 2)
  else if Label29.Font.Style = [fsStrikeout] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteStyle', 3)
  else
     ArqIni.WriteInteger('FONTES DUPLICATA', 'EmitenteStyle', 0);

  ArqIni.WriteString('FONTES DUPLICATA', 'InfoName', Label33.Font.Name);
  ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoSize', Label33.Font.Size);
  ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoCor', Label33.Font.Color);
  if Label33.Font.Style = [fsBold] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoStyle', 1)
  else if Label33.Font.Style = [fsItalic] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoStyle', 2)
  else if Label33.Font.Style = [fsStrikeout] then
     ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoStyle', 3)
  else
     ArqIni.WriteInteger('FONTES DUPLICATA', 'InfoStyle', 0);

  ArqIni.Free;

end;

procedure TForm1.Button4Click(Sender: TObject);
var
  iCarne : integer;
  sNumber : string;
begin

  sNumber := copy(Label22.Caption, 1, length(Label22.Caption) - 1);

  ibDataSet7.Close;
  ibDataSet7.SelectSQL.Clear;
  if CheckBox4.Checked then
  begin
    if copy(Label22.Caption, 1, 1) = 'S' then
    begin
      ibDataSet7.SelectSQL.Add('Select * from RECEBER where documento like(''' + sNumber + '%'') and '); // filtra o nº documento
      ibDataSet7.SelectSQL.Add('valor_rece=0 order by vencimento'); // filtra as parcelas em aberto e ativas
    end else
    begin
      ibDataSet7.SelectSQL.Add('Select * from RECEBER where (documento like(''' + sNumber + '%'') or '); // filtra o nº documento
      ibDataSet7.SelectSQL.Add('documento like (''R' + right(sNumber, 9) + '%'')) ');  // filtra as parcelas restantes
      ibDataSet7.SelectSQL.Add('and valor_rece=0 order by vencimento'); // filtra as parcelas em aberto e ativas
    end;
  end else
  begin
    if copy(Label22.Caption, 1, 1) = 'S' then
    begin
     ibDataSet7.SelectSQL.Add('Select * from RECEBER where documento like(''' + sNumber + '%'') order by vencimento');
    end else
    begin
     ibDataSet7.SelectSQL.Add('Select * from RECEBER where (documento like(''' + sNumber + '%'') or ');
     ibDataSet7.SelectSQL.Add('documento like (''R' + right(sNumber, 9) + '%'')) order by vencimento');
    end;
  end;

  try
    ibDataSet7.Open;
  except
    ShowMessage('Erro no comando SQL: '+ibDataSet7.SelectSQL.Text);
  end;
  //
  if CheckBox3.Checked then ibDataSet7.First else ibDataSet7.GotoBookMark(kPonto);
  iCarne := 0;
  if (PrintDialog1.Execute) and (ibDataSet7.RecordCount > 0) then
  begin
    MudaA4;
    Printer.BeginDoc;
    if Form1.Tag = 0 then
    begin
      if CheckBox3.Checked = False then
      begin
        iCarne := 1;
        ImprimeDadosCarne(8, 8,  101, 70);
        Printer.Canvas.Rectangle(Largura(8), Altura(8+9)-2, Largura(101), Altura(70));
        ImprimeDadosCarne(112, 8, 205, 70);
        Printer.Canvas.Rectangle(Largura(112), Altura(8+9)-2, Largura(205), Altura(70));
        Printer.Canvas.Pen.Style := psDash;
        Printer.Canvas.Rectangle(Largura(8), Altura(78), Largura(205), Altura(78)+2);
        Printer.Canvas.Rectangle(Largura(105), Altura(8), Largura(105) + 2, Altura(78));
        Printer.Canvas.Pen.Style := psSolid;
      end else if CheckBox3.Checked = True then
      begin
        while not ibDataSet7.eof do
        begin
          iCarne := 1;
          ImprimeDadosCarne(8, 8,  101, 70);
          Printer.Canvas.Rectangle(Largura(8), Altura(8+9)-2, Largura(101), Altura(70));
          ImprimeDadosCarne(112, 8, 205, 70);
          Printer.Canvas.Rectangle(Largura(112), Altura(8+9)-2, Largura(205), Altura(70));
          Printer.Canvas.Rectangle(Largura(112), Altura(8+9)-2, Largura(205), Altura(70));
          Printer.Canvas.Pen.Style := psDash;
          Printer.Canvas.Rectangle(Largura(8), Altura(78), Largura(205), Altura(78)+2);
          Printer.Canvas.Rectangle(Largura(105), Altura(8), Largura(105) + 2, Altura(78));
          Printer.Canvas.Pen.Style := psSolid;
          ibDataSet7.Next;
          if not ibDataSet7.Eof then
          begin
            iCarne := 2;
            ImprimeDadosCarne(8, 86,  101, 148);
            Printer.Canvas.Rectangle(Largura(8), Altura(86+9)-2, Largura(101), Altura(148));
            ImprimeDadosCarne(112, 86,  205, 148);
            Printer.Canvas.Rectangle(Largura(112), Altura(86+9)-2, Largura(205), Altura(148));
            Printer.Canvas.Pen.Style := psDash;
            Printer.Canvas.Rectangle(Largura(8), Altura(156), Largura(205), Altura(156)+2);
            Printer.Canvas.Rectangle(Largura(105), Altura(78), Largura(105) + 2, Altura(156));
            Printer.Canvas.Pen.Style := psSolid;
          end;
          ibDataSet7.Next;
          if not ibDataSet7.Eof then
          begin
            iCarne := 3;
            ImprimeDadosCarne(8, 164,  101, 227);
            Printer.Canvas.Rectangle(Largura(8), Altura(164+9)-3, Largura(101), Altura(227));
            ImprimeDadosCarne(112, 164,  205, 227);
            Printer.Canvas.Rectangle(Largura(112), Altura(164+9)-3, Largura(205), Altura(227));
            Printer.Canvas.Pen.Style := psDash;
            Printer.Canvas.Rectangle(Largura(8), Altura(235), Largura(205), Altura(235)+2);
            Printer.Canvas.Rectangle(Largura(105), Altura(156), Largura(105) + 2, Altura(235));
            Printer.Canvas.Pen.Style := psSolid;
          end;
          ibDataSet7.Next;
          if not ibDataSet7.Eof then Printer.NewPage;
        end;
      end;
      //
      if iCarne = 3 then iCarne := 8;
      if iCarne = 1 then iCarne := 86;
      if iCarne = 2 then iCarne := 164;

      if CheckBox1.Checked then
      begin
        if iCarne = 8 then Printer.NewPage;
        Printer.Canvas.Rectangle(Largura(8), Altura(iCarne), Largura(205), Altura(iCarne + 62));
        Printer.Canvas.Font.Size := 40;
        Printer.Canvas.Font.Name := 'Arial Narrow';
        Printer.Canvas.Font.Style := [fsBold];
        Printer.Canvas.StretchDraw(Rect(Largura(10+0), Altura(iCarne + 5 ), Largura(10+60), Altura(iCarne + 5 +15)), Form1.Image1.Picture.Bitmap);
        Printer.Canvas.TextOut((Largura(210) - Printer.Canvas.TextWidth('CARNÊ DE PAGAMENTO')) div 2, Altura(iCarne + 22), 'CARNÊ DE PAGAMENTO');
        Printer.Canvas.Font.Size := 10;
        Printer.Canvas.Font.Style := [fsBold];
        Printer.Canvas.TextOut(Largura(10), Altura(iCarne + 46), 'CLIENTE:');
        Printer.Canvas.Font.Style := [];
        Printer.Canvas.TextOut(Largura(10) + Printer.Canvas.TextWidth('CLIENTE:') + 30, Altura(iCarne + 46), AllTrim(Copy(ibDataSet2.FieldByName('NOME').AsString+Replicate(' ',35),1,35)) + ' - ' + ibDataSet2.FieldByName('CGC').AsString);
        Printer.Canvas.TextOut(Largura(10) + Printer.Canvas.TextWidth('CLIENTE:') + 30, Altura(iCarne + 50), ibDataSet2.FieldByName('ENDERE').AsString + ' - ' + ibDataSet2.FieldByName('COMPLE').AsString);
        Printer.Canvas.TextOut(Largura(10) + Printer.Canvas.TextWidth('CLIENTE:') + 30, Altura(iCarne + 54), ibDataSet2.FieldByName('CIDADE').AsString + ' - ' + ibDataSet2.FieldByName('ESTADO').AsString);
        Printer.Canvas.Pen.Style := psDash;
        Printer.Canvas.Rectangle(Largura(8), Altura(iCarne + 70), Largura(205), Altura(iCarne + 70)+2);
        Printer.Canvas.Pen.Style := psSolid;
        //
        if iCarne = 8 then iCarne := 86 else
        if iCarne = 86 then iCarne := 164 else
        if iCarne = 164 then iCarne := 8;
      end;

      if CheckBox2.Checked then
      begin
        if iCarne = 8 then Printer.NewPage;
        Printer.Canvas.Rectangle(Largura(8), Altura(iCarne), Largura(205), Altura(iCarne + 62));
        Printer.Canvas.Font.Size := 50;
        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.Font.Style := [fsBold];
        Printer.Canvas.Font.Size := 8;
        Printer.Canvas.TextOut((Largura(210) - Printer.Canvas.TextWidth(AllTrim(Copy(ibDataSet13.FieldByName('NOME').AsString+Replicate(' ',35),1,35)))) div 2, Altura(iCarne + 42), Alltrim(Copy(ibDataSet13.FieldByName('NOME').AsString+Replicate(' ',35),1,35)));
        Printer.Canvas.Font.Style := [];
        Printer.Canvas.TextOut((Largura(210) - Printer.Canvas.TextWidth(ibDataSet13.FieldByName('ENDERECO').AsString + ' - ' + ibDataSet13.FieldByName('COMPLE').AsString)) div 2, Altura(iCarne + 46), ibDataSet13.FieldByName('ENDERECO').AsString + ' - ' + ibDataSet13.FieldByName('COMPLE').AsString);
        Printer.Canvas.TextOut((Largura(210) - Printer.Canvas.TextWidth('Fone: ' + ibDataSet13.FieldByName('TELEFO').AsString + ' - ' + ibDataSet13.FieldByName('CEP').AsString + ' - ' + ibDataSet13.FieldByName('MUNICIPIO').AsString + ' - ' + ibDataSet13.FieldByName('ESTADO').AsString)) div 2, Altura(iCarne + 50), 'Fone: ' + ibDataSet13.FieldByName('TELEFO').AsString + ' - ' + ibDataSet13.FieldByName('MUNICIPIO').AsString + ' - ' + ibDataSet13.FieldByName('CEP').AsString + ' - ' + ibDataSet13.FieldByName('ESTADO').AsString);
        Printer.Canvas.TextOut((Largura(210) - Printer.Canvas.TextWidth('CNPJ: ' + ibDataSet13.FieldByName('CGC').AsString + ' - IE: ' + ibDataSet13.FieldByName('IE').AsString)) div 2, Altura(iCarne + 54), 'CNPJ: ' + ibDataSet13.FieldByName('CGC').AsString + ' - IE: ' + ibDataSet13.FieldByName('IE').AsString);
        Printer.Canvas.Pen.Style := psDash;
        Printer.Canvas.Rectangle(Largura(8), Altura(iCarne + 70), Largura(205), Altura(iCarne + 70)+2);
        Printer.Canvas.Pen.Style := psSolid;
      end;
    end else if Form1.Tag = 1 then
    begin
      if CheckBox3.Checked = True then
      begin
        while not ibDataSet7.Eof do
        begin
          ImprimeDadosDuplicata(8, 8);
          Printer.Canvas.Pen.Style := psDash;
          Printer.Canvas.Rectangle(0 , Altura(145), Largura(230), Altura(145) + 2);
          Printer.Canvas.Pen.Style := psSolid;
          ibDataSet7.Next;
          if not ibDataSet7.Eof then ImprimeDadosDuplicata(8, 150);
          ibDataSet7.Next;
          if not ibDataSet7.Eof then Printer.NewPage;
        end;
      end else
      begin
        ImprimeDadosDuplicata(8, 8);
        Printer.Canvas.Pen.Style := psDash;
        Printer.Canvas.Rectangle(0 , Altura(145), Largura(230), Altura(145) + 2);
        Printer.Canvas.Pen.Style := psSolid;
      end;
    end;
    Printer.Enddoc;
  end;
end;

procedure TForm1.Image2DblClick(Sender: TObject);
begin
  ColorDialog1.Color := Shape7.Brush.Color;
  if ColorDialog1.Execute then Cor1;
end;

procedure TForm1.Cor2();
begin
  Shape18.Brush.Color := ColorDialog1.Color;
  Shape27.Brush.Color := ColorDialog1.Color;
  Shape28.Brush.Color := ColorDialog1.Color;
  Shape29.Brush.Color := ColorDialog1.Color;
end;

procedure TForm1.Image4DblClick(Sender: TObject);
begin
  if ColorDialog1.Execute then Cor2;
end;

procedure TForm1.Cor1();
begin
  Shape7.Brush.Color := ColorDialog1.Color;
  Shape30.Brush.Color := ColorDialog1.Color;
end;

procedure TForm1.FontesEmitente();
begin
  Label28.Font := FontDialog1.Font;
  Label29.Font := FontDialog1.Font;
  Label30.Font := FontDialog1.Font;
  Label31.Font := FontDialog1.Font;
  Label32.Font := FontDialog1.Font;
  Label44.Font := FontDialog1.Font;
  Label28.Font.Style := [fsBold];
end;

procedure TForm1.FontesInformacoes();
begin
  Label33.Font := FontDialog1.Font;
  Label34.Font := FontDialog1.Font;
  Label35.Font := FontDialog1.Font;
  Label36.Font := FontDialog1.Font;
  Label39.Font := FontDialog1.Font;
  Label42.Font := FontDialog1.Font;
  Label50.Font := FontDialog1.Font;
  Label51.Font := FontDialog1.Font;
  Label52.Font := FontDialog1.Font;
  Label53.Font := FontDialog1.Font;
  Label54.Font := FontDialog1.Font;
  Label57.Font := FontDialog1.Font;
end;

procedure TForm1.Label28DblClick(Sender: TObject);
begin
  FontDialog1.Font := Label29.Font;
  if FontDialog1.Execute then FontesEmitente();
end;

procedure TForm1.Label33DblClick(Sender: TObject);
begin
  FontDialog1.Font := Label33.Font;
  if FontDialog1.Execute then FontesInformacoes();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Shape22.BringToFront;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then
     CheckBox4.Enabled := True
  else
  begin
    CheckBox4.Checked := False;
    CheckBox4.Enabled := False;
  end;

end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
  Edit2.SelectAll;
end;

procedure TForm1.Edit3Enter(Sender: TObject);
begin
  Edit3.SelectAll;
end;

procedure TForm1.Edit4Enter(Sender: TObject);
begin
  Edit4.SelectAll;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key=Chr(10) then Edit2.SetFocus;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=Chr(10) then Edit3.SetFocus;
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if key=Chr(10) then Edit4.SetFocus;
end;

procedure TForm1.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key=Chr(10) then Edit5.SetFocus;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  Edit2.SelectAll;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
  Edit3.SelectAll;
end;

procedure TForm1.Edit4Click(Sender: TObject);
begin
  Edit4.SelectAll;
end;

procedure TForm1.Button1Enter(Sender: TObject);
begin
  Label69.Font.Style := [fsBold];
  Image33.Picture    := Botao_Fraco.Picture;
end;

procedure TForm1.Button1Exit(Sender: TObject);
begin
  Label69.Font.Style := [];
  Image33.Picture    := Botao_Forte.Picture;
end;

procedure TForm1.Button4Enter(Sender: TObject);
begin
  Label70.Font.Style := [fsBold];
  Image34.Picture    := Botao_Fraco.Picture;
end;

procedure TForm1.Button4Exit(Sender: TObject);
begin
  Label70.Font.Style := [];
  Image34.Picture    := Botao_Forte.Picture;

end;

procedure TForm1.Label69MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm1.Label69MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm1.Label70MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do Font.Style := [fsBold];
end;

procedure TForm1.Label70MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do Font.Style := [];
end;

procedure TForm1.Label69Click(Sender: TObject);
begin
  Close;
end;

end.

