///
/// Projeto criado e compilado com XE6
///
unit Grafico;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Menus, StdCtrls,
  Printers, smallfunc, ComCtrls, VclTee.TeeGDIPlus, pngImage;

type
  TForm1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    SalvarComo1: TMenuItem;
    Imprimir1: TMenuItem;
    Sair1: TMenuItem;
    N1: TMenuItem;
    Sair2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Shape1: TShape;
    Label6: TLabel;
    Edit4: TEdit;
    ComboBox1: TComboBox;
    CheckBox3: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Shape2: TShape;
    Label7: TLabel;
    CheckBox5: TCheckBox;
    ComboBox2: TComboBox;
    Edit5: TEdit;
    TabSheet2: TTabSheet;
    Chart1: TChart;
    Button2: TButton;
    Button3: TButton;
    Impressora1: TMenuItem;
    Edita1: TMenuItem;
    Copiar1: TMenuItem;
    CopiarPara1: TMenuItem;
    Series1: TBarSeries;
    Series2: TBarSeries;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure SalvarComo1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure FechaOPrograma(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
     Combos:array [0..1] of TComboBox;
  public
    { Public declarations }
     Procedure RefreshShape;
     var
       LarguraBMP,AlturaBMP:integer;
       SubTitulo: String;
       FontSizeLabel: String;
       FontSizeMarks: String;
  end;
  GraficoXY = array [1..100] of String[20];

var
  Form1: TForm1;
  IniFile: TIniFile;
  Serie1,Serie2,GrafX,LegendaX:GraficoXY;
  sAtual,sNomedoArquivo,ProgramaQueChamou:String;
  NumSeries:Integer;
  PrimeiraVez:Boolean;


implementation

uses Graf1;

{$R *.DFM}


procedure TForm1.FechaOPrograma(Sender: TObject);
begin
   Application.Terminate;
end;

Function EditColor(AOwner:TComponent; AColor:TColor):TColor;
Begin
  With TColorDialog.Create(AOwner) do
  try
    Color:=AColor;
    if Execute then AColor:=Color;
  finally
    Free;
  end;
  result:=AColor;
end;

Procedure TForm1.RefreshShape;
Begin
  With Form1.Chart1.Series[0] do
  Begin
    Form1.Shape1.Visible:=not ColorEachPoint;
    if Form1.Shape1.Visible then Form1.Shape1.Brush.Color:=SeriesColor;
  end;
  With Form1.Chart1.Series[1] do
  Begin
    Form1.Shape2.Visible:=not ColorEachPoint;
    if Form1.Shape2.Visible then Form1.Shape2.Brush.Color:=SeriesColor;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var  ComponenteImage: TImage;
  ImagemPng: TPngImage;
begin
  try
    //
    Chart1.Width  := LarguraBMP;
    Chart1.Height := AlturaBMP;
    //
    ComponenteImage:= TImage.Create(self);
    ComponenteImage.width := Chart1.Width;
    ComponenteImage.Height := Chart1.Height;
    ComponenteImage.Picture.Bitmap.Assign(Chart1.TeeCreateBitmap(clWhite, Rect(0,0, ComponenteImage.Width, ComponenteImage.Height))); ///
    //
    ImagemPng := TPngImage.Create;
    ImagemPng.Assign(ComponenteImage.Picture.Graphic);
    ImagemPng.SaveToFile(StrTran(lowercase(sNomedoArquivo),'.gra','.png'));
    ImagemPNG.Free;
    ComponenteImage.Free;
  except

  end;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  try
   //
   GetDir(0,sAtual);//diretório atual                           // Parâmetro 1: Nome do arquivo de grafico (GRA)
   if UpperCase(ParamStr(1)) <> '' then
   begin
     sNomedoArquivo := sAtual+'\'+UpperCase(ParamStr(1));
   end else
   begin
     sNomedoArquivo := sAtual+'\vendedores.gra';
   end;
   //
   if not FileExists(sNomedoArquivo) then Winexec('TASKKILL /F /IM graficos.exe' , SW_HIDE );
   //
   try except
     printer.Orientation:=poLandscape;
   end;
   //


   PrimeiraVez:=True;
   Form1.Top  := 0;//83;
   Form1.Left := 0;
   Form1.Width  := Screen.Width;
   Form1.Height := Screen.Height;
   Abrir1Click(Sender);
   //
  except

  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  I:integer;
begin
  try
   if not Form1.Chart1.Series[0].ColorEachPoint then
   begin
      Form1.Chart1.Series[0].SeriesColor:=Shape1.Brush.Color;
      Form1.Chart1.Series[1].SeriesColor:=Shape2.Brush.Color;
      Shape1.Visible:=True;
      Label6.Visible:=True;
   end
   else
   begin
      Shape1.Visible:=False;
      Label6.Visible:=False;
   end;

   I:=1;
   while I <= 100 do
   begin
      if Serie1[I]='FIM' then
         I:=100
      else
         begin
            { 2017-10-10
            if not Form1.Chart1.Series[0].ColorEachPoint then
            begin
               Chart1.Series[0].AddXY(I,StrToFloat(Serie1[I]),LegendaX[I],Chart1.Series[0].SeriesColor);
               Chart1.Series[1].AddXY(I,StrToFloat(Serie2[I]),LegendaX[I],Chart1.Series[1].SeriesColor);
            end
            else
            begin
               Chart1.Series[0].AddXY(I,StrToFloat(Serie1[I]),LegendaX[I],clTeeColor);
               Chart1.Series[1].AddXY(I,StrToFloat(Serie2[I]),LegendaX[I],clTeeColor);
            end;
            }
            if not Form1.Chart1.Series[0].ColorEachPoint then
            begin
               Chart1.Series[0].AddXY(I,StrToFloatDef(Serie1[I], 0.00),LegendaX[I],Chart1.Series[0].SeriesColor);
               Chart1.Series[1].AddXY(I,StrToFloatDef(Serie2[I], 0.00),LegendaX[I],Chart1.Series[1].SeriesColor);
            end
            else
            begin
               Chart1.Series[0].AddXY(I,StrToFloatDef(Serie1[I], 0.00),LegendaX[I],clTeeColor);
               Chart1.Series[1].AddXY(I,StrToFloatDef(Serie2[I], 0.00),LegendaX[I],clTeeColor);
            end;

         end;
      inc(I);
   end;
   Form1.Chart1.Series[0].Marks.Visible := Form1.CheckBox3.Checked;
   Form1.Chart1.Series[0].Marks.Style:=smsValue;
   Form1.Chart1.Series[0].Title:=Edit4.Text;
   Form1.Chart1.Series[1].Title:=Edit5.Text;
   Form1.Chart1.Series[1].Marks.Visible := Form1.CheckBox5.Checked;
   Form1.Chart1.Series[1].Marks.Style:=smsValue;
   if NumSeries=1 then Form1.Chart1.Series[1].Active:=False;
   //
  except
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
   Chart1.View3d  := Form1.CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
   Chart1.Legend.Visible := Form1.CheckBox2.Checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
   Chart1.Series[0].Marks.Visible := Form1.CheckBox3.Checked;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
   Chart1.Title.Text.Clear;
   Chart1.Title.Text.Add(Form1.Edit1.Text);
   Chart1.Title.Repaint;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
   Chart1.Gradient.Visible:=CheckBox4.Checked;
end;

procedure TForm1.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   with Chart1.Series[0] do
      ValueColor[ValueIndex]:=EditColor(Self,ValueColor[ValueIndex]);
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
   Chart1.BottomAxis.Title.Caption:=Edit2.Text;
   Chart1.BottomAxis.Title.Repaint;
end;

procedure TForm1.Edit3Exit(Sender: TObject);
begin
   Chart1.LeftAxis.Title.Caption:=Edit3.Text;
   Chart1.LeftAxis.Title.Repaint;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
   Chart1.Series[1].Marks.Visible := Form1.CheckBox5.Checked;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
  I:Integer;
  SeriesClass: TChartSeriesClass;
  NovaSerie: TChartSeries;
begin
   //destrói a serie existente (em ordem inversa)
   for I := 1 downto 0 do
      Chart1.Series[I].Free;
  //cria a nova série
   Chart1.chart3dpercent:= 60;

   Chart1.View3DOptions.Rotation  :=210;
   Chart1.View3DOptions.Elevation :=210;

   Chart1.View3DOptions.Orthogonal :=true;

   for I := 0 to 1 do
   begin
      case Combos[I].ItemIndex of
        0: SeriesClass := TBarSeries;
        1: SeriesClass := TLineSeries;
        2: SeriesClass := TAreaSeries;
        3: SeriesClass := TPointSeries;
      else
         begin
           SeriesClass := TPieSeries;
           Chart1.Legend.TextStyle:= ltsPlain;
           Chart1.chart3dpercent:= 60;
        //   Chart1.View3DOptions.Elevation :=210;
        //   Chart1.View3DOptions.Rotation:=210;
           Chart1.View3DOptions.Zoom :=100;
         end
      end;
      NovaSerie := SeriesClass.Create(self);
//      if Chart1.Chart3dPercent=60 then Chart1.Series[0].Circled:=True;

      NovaSerie.ParentChart := Chart1;
   end;
   // verifica se é Pizza, se for atribui a forma arredondada na pizza

   Form1.Chart1.Series[0].Marks.font.Size := StrToIntDef(FontSizeMarks, 22);//Form1.Chart1.Title.Font.Size;
   Form1.Chart1.Series[1].Marks.font.Size := StrToIntDef(FontSizeMarks, 22);//Form1.Chart1.Title.Font.Size;

   Form1.Chart1.Legend.Transparent := True; // 2017-10-09

   if Chart1.Series[ 0 ] is TPieSeries then
   begin
    Chart1.chart3dpercent := 20;
  	( Chart1.Series[ 0 ] as TPieSeries ).Circled          := True;
  	( Chart1.Series[ 0 ] as TPieSeries ).Shadow.Visible   := False;
  	( Chart1.Series[ 0 ] as TPieSeries ).Marks.FontSeriesColor := False; // Fonte da cor d serie

   	( Chart1.Series[ 0 ] as TPieSeries ).Marks.MultiLine := True;


  	( Chart1.Series[ 0 ] as TPieSeries ).PieMarks.LegSize     := 0; //distancia das legendas do grafico
  	( Chart1.Series[ 0 ] as TPieSeries ).PieMarks.VertCenter  := False;
  	( Chart1.Series[ 0 ] as TPieSeries ).BevelPercent         := 25;
    ( Chart1.Series[ 0 ] as TPieSeries ).Gradient.Visible     := True;
    ( Chart1.Series[ 0 ] as TPieSeries ).ExplodeBiggest       := 10; //separa o item com maior percentual
    ( Chart1.Series[ 0 ] as TPieSeries ).PiePen.Visible       := True; // Contorno
    ( Chart1.Series[ 0 ] as TPieSeries ).PiePen.Fill.Gradient.Visible    := True; // Contorno gradiente
    ( Chart1.Series[ 0 ] as TPieSeries ).PiePen.Fill.Gradient.EndColor   := clBlack;
    ( Chart1.Series[ 0 ] as TPieSeries ).PiePen.Fill.Gradient.Midcolor   := clWhite;
    ( Chart1.Series[ 0 ] as TPieSeries ).PiePen.Fill.Gradient.Startcolor := clBlack;
    ( Chart1.Series[ 0 ] as TPieSeries ).GradientBright       := 33;
    ( Chart1.Series[ 0 ] as TPieSeries ).Pen.Width            := Abs(Form1.Chart1.Title.Font.Size div 15);


    Form1.Chart1.Chart3DPercent         := 13; //aumenta 3d do grafico... influencia na altura
    Form1.Chart1.Series[0].Transparency := 33;
    Form1.Chart1.Series[1].Transparency := 33;

    Form1.Chart1.Series[0].Marks.font.Size := StrToIntDef(FontSizeMarks, 12);//Form1.Chart1.Title.Font.Size;
    Form1.Chart1.Series[1].Marks.font.Size := StrToIntDef(FontSizeMarks, 12);//Form1.Chart1.Title.Font.Size;

//    Chart1.View3DOptions.Elevation := 210;

   end;
   //
   if Chart1.Series[ 0 ] is TBarSeries then
   begin
    ( Chart1.Series[ 0 ] as TBarSeries ).BarPen.Visible := True; // Contorno
    ( Chart1.Series[ 0 ] as TBarSeries ).BarPen.Fill.Gradient.Visible    := True; // Contorno gradiente

    ( Chart1.Series[ 0 ] as TBarSeries ).BarPen.Fill.Gradient.EndColor   := IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); //2020-07-20 clSilver;// clBlack; //2018-10-04 IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2018-10-03 $00E6BE78;
    ( Chart1.Series[ 0 ] as TBarSeries ).BarPen.Fill.Gradient.Midcolor   := clWhite;// clBtnFace; // 2018-10-04 clBlack; //2018-10-04 clWhite;
    ( Chart1.Series[ 0 ] as TBarSeries ).BarPen.Fill.Gradient.Startcolor := IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); //2020-07-20 clSilver;// clBlack; //2018-10-04 IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2018-10-03 $00E6BE78;
    ( Chart1.Series[ 0 ] as TBarSeries ).Pen.Width                       := Abs(Form1.Chart1.Title.Font.Size div 8); // 1; // 2018-10-04 Abs(Form1.Chart1.Title.Font.Size div 30); // 15);

    Chart1.BottomAxis.Grid.Visible := False;

    Form1.Chart1.Chart3DPercent         := 33; //aumenta 3d do grafico... influencia na altura
    Form1.Chart1.Series[0].Transparency := 33; // 2018-10-04 20;
    Form1.Chart1.Series[1].Transparency := 33; // 2018-10-04 20;

   end;

   if Chart1.Series[ 0 ] is TLineSeries then
   begin
    ( Chart1.Series[ 0 ] as TLineSeries ).LinePen.Visible := True; // Contorno
    ( Chart1.Series[ 0 ] as TLineSeries ).LinePen.Fill.Gradient.Visible    := True; // Contorno gradiente
    ( Chart1.Series[ 0 ] as TLineSeries ).LinePen.Fill.Gradient.EndColor   := IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2020-07-20 clBlack; //2018-10-04 IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2018-10-03 $00E6BE78;
    ( Chart1.Series[ 0 ] as TLineSeries ).LinePen.Fill.Gradient.Midcolor   := clWhite;
    ( Chart1.Series[ 0 ] as TLineSeries ).LinePen.Fill.Gradient.Startcolor := IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2020-07-20 clBlack; //2018-10-04 IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // 2018-10-03 $00E6BE78;
    ( Chart1.Series[ 0 ] as TLineSeries ).Pen.Width                        := Abs(Form1.Chart1.Title.Font.Size div 10);

    Chart1.BottomAxis.Grid.Visible := False;
    Form1.Chart1.Chart3DPercent         := 33; //aumenta 3d do grafico... influencia na altura
    Form1.Chart1.Series[0].Transparency := 10;
    Form1.Chart1.Series[1].Transparency := 10;

   end;
   //
   Button1Click(Sender);
   //
   Form1.Chart1.SubTitle.Font := Form1.Chart1.Title.Font; // Mesma fonte do título
   //
   Form1.Chart1.Series[0].Marks.Frame.Color := $004080FF; //contorno da legenda
   Form1.Chart1.Series[1].Marks.Frame.Color := $004080FF; //contorno da legenda
   //
   Form1.Chart1.Series[0].Marks.Arrow.Color := clBlack; // cor da linha entre o grafico e a legenda
   Form1.Chart1.Series[1].Marks.Arrow.Color := clBlack;  // Cor da linha entre o grafico e a legenda
   //
   Form1.Chart1.Series[0].Marks.Style := smsLabelValue; // Tipo da legenda
   Form1.Chart1.Series[1].Marks.Style := smsLabelValue; // Tipo da legenda
   //
   Form1.Chart1.Series[0].Marks.Angle := 360; // Angulo em graus
   Form1.Chart1.Series[1].Marks.Angle := 360; // Angulo em graus
   //
   Form1.Chart1.Series[0].Marks.Arrow.Visible := False; // Setinha da legenda
   Form1.Chart1.Series[1].Marks.Arrow.Visible := False; // Setinha da legenda
   //
   Form1.Chart1.LeftAxis.LabelsFont.Name   := Form1.Chart1.Title.Font.Name;
   Form1.Chart1.BottomAxis.LabelsFont.Name := Form1.Chart1.Title.Font.Name;
   Form1.Chart1.TopAxis.LabelsFont.Name    := Form1.Chart1.Title.Font.Name;
   Form1.Chart1.RightAxis.LabelsFont.Name  := Form1.Chart1.Title.Font.Name;
   //
   Form1.Chart1.LeftAxis.LabelsFont.Size   := StrToIntDef(FontSizeLabel, Form1.Chart1.Title.Font.Size);
   Form1.Chart1.BottomAxis.LabelsFont.Size := StrToIntDef(FontSizeLabel, Form1.Chart1.Title.Font.Size);
   Form1.Chart1.TopAxis.LabelsFont.Size    := StrToIntDef(FontSizeLabel, Form1.Chart1.Title.Font.Size);
   Form1.Chart1.RightAxis.LabelsFont.Size  := StrToIntDef(FontSizeLabel, Form1.Chart1.Title.Font.Size);
   //
   //
//   Form1.Chart1.Gradient.EndColor := clWhite; //controla a cor gradiente
//   Form1.Chart1.Gradient.MidColor := $00EAEAEA;//controla a cor gradiente
//   Form1.Chart1.Gradient.StartColor := $00EAEAEA;//controla a cor gradiente
   //
   Form1.Chart1.View3DOptions.Zoom :=100;
   {coloca os valores no gráfico}
   Form1.Chart1.Repaint;
   //
end;

procedure TForm1.Edit4Exit(Sender: TObject);
begin
   Chart1.Series[0].Title:=Edit4.Text;
end;


procedure TForm1.Edit5Exit(Sender: TObject);
begin
   Chart1.Series[1].Title:=Edit5.Text;
end;

procedure TForm1.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  With Chart1.Series[0] do
       SeriesColor:= EditColor(Self,SeriesColor);
  RefreshShape;
  ComboBox1Change(Sender);
end;

procedure TForm1.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  With Chart1.Series[1] do
       SeriesColor:=EditColor(Self,SeriesColor);
  RefreshShape;
  ComboBox1Change(Sender);
end;


procedure TForm1.Button2Click(Sender: TObject);
var
   RetGraf:TRect;
//   Orient:TPrinterOrientation;
begin
//   Orient:=printer.Orientation;
//   printer.Orientation:=poLandscape;

{ topo da página   RetGraf:=Rect(0,0,Printer.PageWidth-1,Trunc((Printer.PageHeight-1)/2));}
{   RetGraf:=Rect(0,Trunc((Printer.PageHeight-1)/2),Printer.PageWidth-1,Printer.PageHeight-1);}
   if printer.Orientation=poPortrait then
      RetGraf:=Rect(0,0,Printer.PageWidth-1,Trunc((Printer.PageHeight-1)/2))
   else
      RetGraf:=Rect(0,0,Printer.PageWidth-1,Printer.PageHeight-1);
   Form1.Chart1.PrintRect(RetGraf);
{   Form1.Chart1.print;}
//   printer.Orientation:=Orient; //poPortrait;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
   Close;
   Halt(0);
end;

procedure TForm1.Abrir1Click(Sender: TObject);
var
   Titulo,TituloX,TituloY,TituloSerie1,TituloSerie2,Valores,NomeBMP:String;
   I,TipoGS1,TipoGS2 :integer;
   LeuoArquivo:Boolean;
begin
   NomeBMP:='';
   if PrimeiraVez then
      LeuoArquivo:=True
   else
      begin
         LeuoArquivo:=OpenDialog1.Execute;
         sNomedoArquivo:=OpenDialog1.Filename;
      end;
   if LeuoArquivo then
   begin
    if not PrimeiraVez then
        sNomedoArquivo:=OpenDialog1.Filename
    else
        PrimeiraVez:=False;
    {abre arquivo}
    if FileExists(sNomedoArquivo) then
    begin
        IniFile := TIniFile.Create(sNomedoArquivo);
        ProgramaQueChamou:='Dados';
        NomeBMP:= IniFile.ReadString (ProgramaQueChamou,'NomeBMP', '');
        LarguraBMP:= IniFile.ReadInteger (ProgramaQueChamou,'LarguraBMP', 0);
        AlturaBMP:= IniFile.ReadInteger (ProgramaQueChamou,'AlturaBMP', 0);
        Titulo := IniFile.ReadString (ProgramaQueChamou,'Titulo', '');
        SubTitulo := IniFile.ReadString (ProgramaQueChamou,'SubTitulo', '');
        TituloX := IniFile.ReadString (ProgramaQueChamou,'TituloX', '');
        TituloY := IniFile.ReadString (ProgramaQueChamou,'TituloY', '');
        TituloSerie1 := IniFile.ReadString (ProgramaQueChamou,'TituloSerie1', '');
        TituloSerie2 := IniFile.ReadString (ProgramaQueChamou,'TituloSerie2', '');
        NumSeries := IniFile.ReadInteger (ProgramaQueChamou,'Series', 0);
        TipoGS1 := IniFile.ReadInteger(ProgramaQueChamou,'TipoS1',1);
        TipoGS2 := IniFile.ReadInteger(ProgramaQueChamou,'TipoS2',1);
        FontSizeLabel := IniFile.ReadString (ProgramaQueChamou,'FontSizeLabel', '');
        FontSizeMarks := IniFile.ReadString (ProgramaQueChamou,'FontSizeMarks', '');

        Chart1.SubTitle.Text.Text := Form1.SubTitulo;// Repassa para o subtitulo

        Form1.Chart1.Title.Font.Name  := 'Microsoft Sans Serif';
        Form1.Chart1.Title.Font.Size  := IniFile.ReadInteger(ProgramaQueChamou,'FontSize',8);
        //
        Form1.Chart1.SubTitle.Font    := Form1.Chart1.Title.Font;


        Form1.Series1.Legend.Font.Name  := 'Microsoft Sans Serif';
        Form1.Series1.Legend.Font.Size  := Form1.Chart1.Title.Font.Size;

        Form1.Series2.Legend.Font.Name  := 'Microsoft Sans Serif';
        Form1.Series2.Legend.Font.Size  := Form1.Chart1.Title.Font.Size;
        //
        Form1.Chart1.Legend.Font.Name := 'Microsoft Sans Serif';
        Form1.Chart1.Legend.Font.Size := IniFile.ReadInteger(ProgramaQueChamou,'FontSizeLabel',8);
        //
        Form1.Chart1.MarginTop    := IniFile.ReadInteger(ProgramaQueChamou,'MarginTop',6);
        Form1.Chart1.MarginLeft   := IniFile.ReadInteger(ProgramaQueChamou,'MarginLeft',6);
        Form1.Chart1.MarginRight  := IniFile.ReadInteger(ProgramaQueChamou,'MarginTop',6);
        Form1.Chart1.MarginBottom := IniFile.ReadInteger(ProgramaQueChamou,'MarginTop',6);

//        Form1.Chart1.MarginRight  := 1;
//        Form1.Chart1.MarginBottom := 1;
        //
        Form1.Font := Form1.Chart1.Title.Font;
        //
        Form1.Chart1.Title.Alignment := taLeftJustify;
        Form1.Chart1.SubTitle.Alignment := taLeftJustify;
        //
        {lê os valores no INI}
        I:=1;
        while I <=100 do
        begin
           Valores := IniFile.ReadString (ProgramaQueChamou,'XY'+StrZero(I,2,0), '');
           if Valores = '' then
              begin
                Serie1[I]:='FIM';
                Serie2[I]:='FIM';
                GrafX[I]:='FIM';
                LegendaX[I]:='FIM';
                I:=100;
              end
           else
              begin
                 Serie1[I]:=Copy(Valores,Pos('S1<',Valores)+3,(Pos('>S2',Valores))-(Pos('S1<',Valores)+3));
                 Serie2[I]:=Copy(Valores,Pos('S2<',Valores)+3,(Pos('>VX',Valores))-(Pos('S2<',Valores)+3));
                 GrafX[I] :=Copy(Valores,Pos('VX<',Valores)+3,(Pos('>LX',Valores))-(Pos('VX<',Valores)+3));
                 LegendaX[I]:=Copy(Valores,Pos('LX<',Valores)+3,(Length(Valores))-(Pos('LX<',Valores)+3));
              end;
           Inc(I);
        end;
        { monta o gráfico }
     {   if Chart1.Gradient.Visible then
           Chart1.Title.Font.Color:=clWhite
        else
           Chart1.Title.Font.Color:=$00E6BE78;}


        {caracteristicas do Gráfico}
        CheckBox1.Checked:=IniFile.ReadBool(ProgramaQueChamou,'3D',False);
        CheckBox2.Checked:=IniFile.ReadBool(ProgramaQueChamou,'Legenda',False);
        CheckBox4.Checked:=IniFile.ReadBool(ProgramaQueChamou,'Gradiente',False);
        CheckBox3.Checked:=IniFile.ReadBool(ProgramaQueChamou,'MarcasS1',False);
        CheckBox5.Checked:=IniFile.ReadBool(ProgramaQueChamou,'MarcasS2',False);

        Chart1.Series[0].SeriesColor := IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255); // $00E6BE78; // IniFile.ReadInteger(ProgramaQueChamou,'CorS1',255);
        Chart1.Series[1].SeriesColor := IniFile.ReadInteger(ProgramaQueChamou,'CorS2',255); //2020-07-20 $00E6BE78; // IniFile.ReadInteger(ProgramaQueChamou,'CorS2',255);

        Chart1.BottomAxis.LabelStyle:=talText;
        Edit1.Text:=Titulo;
        Edit2.Text:=TituloX;
        Edit3.Text:=TituloY;
        Edit4.Text:=TituloSerie1;
        Edit5.Text:=TituloSerie2;
        Chart1.Title.Text.Clear;
        Chart1.Title.Text.Add(Form1.Edit1.Text);
        Chart1.Title.Repaint;
        //
        if Chart1.Title.Caption = '' then Chart1.Title.Visible := False;
        //
        Chart1.BottomAxis.Title.Caption:=Edit2.Text;
        Chart1.BottomAxis.Title.Repaint;
        Chart1.LeftAxis.Title.Caption:=Edit3.Text;
        Chart1.LeftAxis.Title.Repaint;
        if NumSeries > 2 then NumSeries:=2;
        if NumSeries <= 0 then NumSeries:=1;
        if NumSeries = 1 then
         begin
           Chart1.Series[1].Active:=false;
           GroupBox2.Visible:=False;
           ComboBox1.Items.Add('Pizza');
           if TipoGS1 > 4 then TipoGS1:=1;
         end
        else
         begin
           Chart1.Series[1].Active:=True;
           GroupBox2.Visible:=True;
           ComboBox1.Items.Delete(4); //Add('Pizza');
           if TipoGS1 > 3 then TipoGS1:=1;
           if TipoGS2 > 3 then TipoGS2:=1;
         end;
       // preenche o array de Combos
       Combos [0] := ComboBox1;
       Combos [1] := ComboBox2;
       // Mostra o tipo de gráfico inicial
       Combos [0].ItemIndex :=TipoGS1;
       Combos [1].ItemIndex :=TipoGS2;

       {coloca os valores no gráfico}
       RefreshShape;

       //coloca o fundo branco  e  o tamanho mais que a metade
       if NomeBMP <> '' then begin
          Chart1.Color :=clWhite;
          Chart1.Align :=alNone;
          Chart1.Height:= AlturaBMP;  //253  //211;
          Chart1.Width := LarguraBMP; //310 //258;
       end;
       ComboBox1Change(Sender); //     Button1Click(Sender);
    end else
    begin

    end;
  end;
end;

procedure TForm1.SalvarComo1Click(Sender: TObject);
var
   Button: Integer;
   Continua: Boolean;
begin
//    Continua:=True;
    repeat
       Button := IDYes;
       if SaveDialog1.Execute then
        begin
          if FileExists(SaveDialog1.FileName) then
             Button := Application.MessageBox('O arquivo já existe ! Substituí-lo ?',
                     'GRÁFICOS', MB_ICONQUESTION+mb_YesNO + mb_DefButton1);
          if Button = IDYes then
           begin
             //Screen.Cursor :=crHourGlass;
             sNomedoArquivo:=SaveDialog1.FileName;
             Salvar1Click(Sender);
             //Screen.Cursor :=crDefault;
             Continua:=False;
           end
          else
             Continua:=True;
        end
       else
          Continua:=False;
    until not Continua;
end;

procedure TForm1.Salvar1Click(Sender: TObject);
var
  I:Integer;
begin
   //Screen.Cursor :=crHourGlass;
   if UpperCase(sNomedoArquivo) = upperCase(satual)+'\PADRAO.GRA'  then  SalvarComo1Click(Sender);

   IniFile:=TIniFile.Create(sNomedoArquivo);
   IniFile.WriteString(ProgramaQueChamou,'Titulo',Edit1.Text);
   IniFile.WriteString(ProgramaQueChamou,'TituloX',Edit2.Text);
   IniFile.WriteString(ProgramaQueChamou,'TituloY',Edit3.Text);
   IniFile.WriteString(ProgramaQueChamou,'TituloSerie1',Edit4.Text);
   IniFile.WriteString(ProgramaQueChamou,'TituloSerie2',Edit5.Text);
   IniFile.WriteBool(ProgramaQueChamou,'3D',CheckBox1.Checked);
   IniFile.WriteBool(ProgramaQueChamou,'Legenda',CheckBox2.Checked);
   IniFile.WriteBool(ProgramaQueChamou,'Gradiente',CheckBox4.Checked);
   IniFile.WriteBool(ProgramaQueChamou,'MarcasS1',CheckBox3.Checked);
   IniFile.WriteBool(ProgramaQueChamou,'MarcasS2',CheckBox5.Checked);
   IniFile.WriteInteger(ProgramaQueChamou,'CorS1',Chart1.Series[0].SeriesColor);
   IniFile.WriteInteger(ProgramaQueChamou,'CorS2',Chart1.Series[1].SeriesColor);
   IniFile.WriteInteger(ProgramaQueChamou,'TipoS1',Combos [0].ItemIndex);
   IniFile.WriteInteger(ProgramaQueChamou,'TipoS2',Combos [1].ItemIndex);
   IniFile.WriteInteger(ProgramaQueChamou,'Series',NumSeries);

   I:=1;
   while Serie1[I] <> 'FIM' do
   begin
      IniFile.WriteString(ProgramaQueChamou,'XY'+StrZero(I,2,0),'S1<'+Serie1[I]+
                        '>S2<'+Serie2[I]+'>VX<'+GrafX[I]+
                        '>LX<'+LegendaX[I]+'>');
      I:=I+1;
   end;
   //Screen.Cursor :=crDefault;
   IniFile.Destroy;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   PrinterSetupDialog1.Execute;
end;













procedure TForm1.Copiar1Click(Sender: TObject);
var
  CordeFundo, CordoGrafico : TColor;
begin
   CordeFundo := Chart1.BackColor;
   CordoGrafico := Chart1.Color;
   Chart1.BackColor:=clWhite;
   Chart1.Color := clWhite;
   Chart1.CopyToClipboardBitmap;
   Chart1.BackColor:= CordeFundo;
   Chart1.Color := CordoGrafico;


{  var
  ARect: TRect;
begin
  Copy1Click(Sender);	// copy picture to Clipboard
 with Image.Canvas do
  begin
    CopyMode := cmWhiteness;	// copy everything as white
   ARect := Rect(0, 0, Image.Width, Image.Height);	// get bitmap rectangle
   CopyRect(ARect, Image.Canvas, ARect);	// copy bitmap over itself
   CopyMode := cmSrcCopy;	// restore normal mode
  end;}

end;

end.
