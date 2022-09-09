unit Graf1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart;

type
  TForm2 = class(TForm)
    Chart1: TChart;
    Series1: TBarSeries;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Grafico;

{$R *.DFM}

procedure TForm2.FormActivate(Sender: TObject);
var
   I:Integer;
   SeriesClass:TChartSeriesClass;
   NovaSerie:TchartSeries;
begin
   Chart1.Series[0].Free;
   case Form1.ComboBox1.ItemIndex of
      0: SeriesClass :=TBarSeries;
      1: SeriesClass :=TLineSeries;
      2: SeriesClass :=TPieSeries;
   else
      SeriesClass :=TBarSeries;
   end;
   NovaSerie :=SeriesClass.Create(self);
   NovaSerie.ParentChart :=Chart1;
   NovaSerie.Title:='Teste';

   Form2.Chart1.Title.Text.Clear;
   Form2.Chart1.Title.Text.Add(Form1.Edit1.Text);
   Form2.Chart1.View3d  := Form1.CheckBox1.Checked;
   Form2.Chart1.Legend.Visible := Form1.CheckBox2.Checked;
   Form2.Chart1.Series[0].Marks.Visible := Form1.CheckBox3.Checked;
   for I := 1 to 4 do
   begin
{      Form2.Chart1.Series[0].AddXY(Date,StrToFloat(GrafX[I]),'',Form2.Chart1.Series[0].SeriesColor);}
      Form2.Chart1.Series[0].Add(StrToFloat(GrafX[I]),'',Form2.Chart1.Series[0].SeriesColor);
   end;
end;
end.
