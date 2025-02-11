unit uReportScreenBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.CheckLst,
  System.Generics.Collections, IniFiles, uFrmPadrao;

type
  TPrintMode = (pmLegacy, pmInterface, pmFastReport);

  TInfoReportBase = record
    User: String;
    Html: Boolean;
    HtmlColor: String;
    PDF: Boolean;
    UsuarioPub: String;
    NomeEmitente: String;
    CRT: String;
    HomePage: String;
    ReportImage: TPicture;
  end;

  TfrmReportScreenBase = class(TFrmPadrao)
    PanelBotton: TPanel;
    btnCancelar: TBitBtn;
    BitBtnNext: TBitBtn;
    BitBtnPrior: TBitBtn;
    BevelPrior: TBevel;
    BevelPrint: TBevel;
    PanelMain: TPanel;
    PanelImg: TPanel;
    ImgRel: TImage;
    Bevel4: TBevel;
    PageControlParams: TPageControl;
    tbsPeriod: TTabSheet;
    PanelParams: TPanel;
    PanelPeriod: TPanel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerStart: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    PanelWait: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnNextClick(Sender: TObject);
    procedure BitBtnPriorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    FIniPath: String;
    FTimeStartReport: TTime;
    FListOfPanelsToStyle: TList<TPanel>;
    FReadyToPrint: Boolean;
    FCurrentPage: Integer;
    FPageControlParams: TPageControl;
    FInfoReportBase: TInfoReportBase;
    FPrintMode: TPrintMode;
    FCanceled: Boolean;
    procedure ShowPage(AIndex: Integer);
    procedure SetReadyToPrint();
    function getTitle: String;
    procedure setTitle(const AValue: String);
    procedure PrePrinting();
    procedure PrintHeader();
    procedure PrintFooter();
    procedure PrintLegacyMode();
  protected
    procedure Print(); virtual; abstract;
    function Validate(var AMsg: string):Boolean; virtual; abstract;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AInfoReportBase: TInfoReportBase);
    property InfoReportBase: TInfoReportBase read FInfoReportBase;
    property ListOfPanelsToStyle: TList<TPanel> read FListOfPanelsToStyle write FListOfPanelsToStyle;
    property Title: String read getTitle write setTitle;
    property PrintMode: TPrintMode read FPrintMode write FPrintMode;
    property Canceled: Boolean read FCanceled;
    var
      TextFileBaseReport: TextFile;
  end;

var
  frmReportScreenBase: TfrmReportScreenBase;

implementation

{$R *.dfm}

uses
  smallfunc_xe;

const
  INI_OUTROS_SECTION = 'Outros';
  INI_START_IDENT = 'Período Inicial';
  INI_END_IDENT = 'Período Final';


procedure TfrmReportScreenBase.BitBtnNextClick(Sender: TObject);
begin
  if (tbsPeriod.Parent = PanelParams) and 
    (DateTimePickerEnd.Date < DateTimePickerStart.Date) then
    raise Exception.Create('O período informado é inválido.');

  if not(FReadyToPrint) then
  begin
    ShowPage(FCurrentPage + 1);
    Exit;
  end;

  var Msg: String;
  if not(Validate(Msg)) then
    raise Exception.Create(Msg);

  if PrintMode in [pmInterface, pmFastReport] then
  begin
    Print();
    ModalResult := mrOk;
    Exit;
  end;

  PrintLegacyMode();
end;

procedure TfrmReportScreenBase.BitBtnPriorClick(Sender: TObject);
begin
  ShowPage(FCurrentPage - 1);
end;

procedure TfrmReportScreenBase.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  FCanceled := True;
end;

constructor TfrmReportScreenBase.Create(AOwner: TComponent;
  AInfoReportBase: TInfoReportBase);
begin
  inherited Create(AOwner);
  FInfoReportBase := AInfoReportBase;
  FInfoReportBase.NomeEmitente := Trim(FInfoReportBase.NomeEmitente);
end;

procedure TfrmReportScreenBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with TIniFile.Create(FIniPath) do
  begin
    try
      WriteString(
        INI_OUTROS_SECTION,
        INI_START_IDENT,
        DateToStr(DateTimePickerStart.Date)
      );
      WriteString(
        INI_OUTROS_SECTION,
        INI_END_IDENT,
        DateToStr(DateTimePickerEnd.Date)
      );
    finally
      Free;
    end;
  end;
end;

procedure TfrmReportScreenBase.FormCreate(Sender: TObject);
begin
  Color := clWhite;
  ClientHeight := 280;
  ClientWidth := 518;
  PageControlParams.Visible := False;

  FListOfPanelsToStyle := TList<TPanel>.Create;
  FListOfPanelsToStyle.AddRange(
    [PanelMain, PanelImg, PanelBotton, PanelParams, PanelPeriod, PanelWait]
  );

  FIniPath := ExtractFilePath(ParamStr(0))+FInfoReportBase.User+'.inf';
  ImgRel.Picture := FInfoReportBase.ReportImage;
end;

procedure TfrmReportScreenBase.FormShow(Sender: TObject);
begin
  BitBtnNext.SetFocus();
  
  for var P in ListOfPanelsToStyle do
  begin
    P.BorderStyle := bsNone;
    P.BevelOuter := bvNone;
    P.Color := Color;
    P.ParentBackground := False;
  end;

  with TIniFile.Create(FIniPath) do
  begin
    try
      DateTimePickerStart.Date := StrtoDate(
        ReadString(
          INI_OUTROS_SECTION,
          INI_START_IDENT,
          DateToStr(Date-360)
        )
      );
      DateTimePickerEnd.Date := StrtoDate(
        ReadString(
          INI_OUTROS_SECTION,
          INI_END_IDENT,
          DateToStr(Date)
        )
      );
    finally
      Free;
    end;
  end;

  ShowPage(0);
end;

function TfrmReportScreenBase.getTitle: String;
begin
  Result := Caption;
end;

procedure TfrmReportScreenBase.PrePrinting();
begin
  var Ext := '.HTM';
  if not(FInfoReportBase.Html) then
    Ext := '.txt';
  var FileName := FInfoReportBase.UsuarioPub+Ext;
  DeleteFile(pChar(FileName));
  AssignFile(TextFileBaseReport, pChar(FileName));

  try
    Rewrite(TextFileBaseReport);
  except
    ShowMessage(
      'Não foi possível gravar no arquivo '+Ext+'   '+Chr(10)+Chr(10)+
      'Este programa será fechado.'
    );
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    FecharAplicacao(ExtractFileName(Application.ExeName));
  end;

end;

procedure TfrmReportScreenBase.PrintFooter;
var
  GeneratedIn, Time_generate: String;

  procedure FooterHtml();
  begin
    WriteLn(
      TextFileBaseReport,
      '<center><br><font face="Microsoft Sans Serif" size=1>'+GeneratedIn+
      '</font><br>'
    );

    if (FInfoReportBase.HomePage = '') then
      WriteLn(
        TextFileBaseReport,
        '<font face="verdana" size=1><center>Relatório gerado pelo sistema '+
        'Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br'+
        '</a><font>'
      )
    else
      WriteLn(
        TextFileBaseReport,
        '<font face="verdana" size=1><center>'+
        '<a href="http://'+FInfoReportBase.HomePage+'">'+FInfoReportBase.HomePage+
        '</a><font>'
      );

    WriteLn(
      TextFileBaseReport,
        '<font face="Microsoft Sans Serif" size=1><center>'+
        Time_generate+'</center>'
      );

    if not FInfoReportBase.PDF then
      WriteLn(
        TextFileBaseReport,
        '<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center>'+
        '<font face="Webdings" size=5 color=#215E21>P<font face='+
        '"Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, '+
        'pense no meio ambiente.</center></a>'
      );

    WriteLn(TextFileBaseReport, '</html>');
  end;

  procedure FooterTxt();
  begin
    WriteLn(TextFileBaseReport, GeneratedIn);
    WriteLn(TextFileBaseReport, Time_generate);
  end;
begin
  FInfoReportBase.HomePage := Trim(FInfoReportBase.HomePage);
  GeneratedIn := 'Gerado em '+
    FormatDateTime('dd "de" mmmm "de" yyyy "às" hh:nn', Now());
  Time_generate := 'Tempo para gerar este relatório: '+
    TimeToStr(Time - FTimeStartReport);

  if FInfoReportBase.Html then
    FooterHtml()
  else
    FooterTxt();
end;

procedure TfrmReportScreenBase.PrintHeader;
  procedure HtmlHeader;
  begin
    Writeln(
      TextFileBaseReport,
      '<html><head><title>'+FInfoReportBase.NomeEmitente+' - '+Title+
      '</title></head>'
    );
    WriteLn(
      TextFileBaseReport,
      '<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>'
    );
    WriteLn(
      TextFileBaseReport,
      '<img src="logotip.jpg" alt="'+FInfoReportBase.NomeEmitente+'">'
    );
    WriteLn(
      TextFileBaseReport,
      '<br><font size=3 color=#000000><b>'+FInfoReportBase.NomeEmitente+'</b></font>'
    );

  end;

  procedure TxtHeader();
  begin
    WriteLn(TextFileBaseReport, FInfoReportBase.NomeEmitente);
    WriteLn(TextFileBaseReport, '');
  end;

begin
  if FInfoReportBase.Html then
  begin
    HtmlHeader();
    Exit();
  end;
  TxtHeader();
end;

procedure TfrmReportScreenBase.PrintLegacyMode;
begin
  ShowPage(-1);
  
  FTimeStartReport := Time;
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  PrePrinting();
  PrintHeader();
  Print();
  PrintFooter();
  CloseFile(TextFileBaseReport);
  Screen.Cursor := crDefault;
  ModalResult := mrOk;
end;

procedure TfrmReportScreenBase.SetReadyToPrint;
const
  NEXT_CAPTION = 'Avançar >';
  PRINT_CAPTION = 'Gerar';
begin
  BitBtnNext.Caption := NEXT_CAPTION;
  FReadyToPrint := PageControlParams.PageCount = FCurrentPage + 1;
  if FReadyToPrint then
    BitBtnNext.Caption := PRINT_CAPTION;
end;

procedure TfrmReportScreenBase.setTitle(const AValue: String);
begin
  Caption := AValue;
end;

procedure TfrmReportScreenBase.ShowPage(AIndex: Integer);
  procedure BackParent();
  begin
    for var I := 0 to PageControlParams.PageCount - 1 do
      PageControlParams.Pages[I].Parent := PageControlParams;
  end;
begin
  if AIndex = -1 then
  begin
    BitBtnNext.Enabled := False;
    BitBtnPrior.Enabled := False;
    BackParent();
    PanelWait.Align := alClient;
    PanelWait.Visible := True;
    Exit;
  end;

  BitBtnPrior.Enabled := not(AIndex = 0);
  if (AIndex < 0) or (AIndex >= PageControlParams.PageCount) then
    Exit;

  BackParent();

  PageControlParams.ActivePageIndex := AIndex;
  PageControlParams.Pages[AIndex].Parent := PanelParams;
  FCurrentPage := AIndex;
  SetReadyToPrint();
end;

end.
