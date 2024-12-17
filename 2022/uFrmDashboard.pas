unit uFrmDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Platform.Win,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Rest.Json, uClassesDadosDash,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, Winapi.Windows,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, FMXTee.Series, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.ExtCtrls, FMX.Ani;

type
  TFrmDashboard = class(TForm)
    GridPanelPrincipal: TGridPanelLayout;
    GridPanelLinha1: TGridPanelLayout;
    GridPanelLinha2: TGridPanelLayout;
    GridPanelLinha3: TGridPanelLayout;
    Rec01: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    lblVendasDia: TLabel;
    lblVendasMes: TLabel;
    lblSaldoCaixa: TLabel;
    layVendasDia: TLayout;
    ImgVendasDia: TImage;
    lblTitVendasDia: TLabel;
    layVendasMes: TLayout;
    imgVendasMes: TImage;
    lblTitVendasMes: TLabel;
    laySaldoCaixa: TLayout;
    imgSaldoCx: TImage;
    lblTitSaldoCaixa: TLabel;
    layInadimplencia: TLayout;
    imgInadimplencia: TImage;
    lblTitInadimplencia: TLabel;
    Rectangle4: TRectangle;
    layVendasDiarias: TLayout;
    imgVendasDiarias: TImage;
    lblTitVendasDiarias: TLabel;
    Rectangle5: TRectangle;
    layContasReceber: TLayout;
    imgContasReceber: TImage;
    lblTitContasReceber: TLabel;
    Rectangle6: TRectangle;
    layContasPagar: TLayout;
    imgContasPagar: TImage;
    lblTitContasPagar: TLabel;
    Rectangle7: TRectangle;
    layVendasVendedor: TLayout;
    imgVendasVendedor: TImage;
    lblTitVendasVendedor: TLabel;
    Rectangle8: TRectangle;
    layVendasFormaPgto: TLayout;
    imgVendasForma: TImage;
    lblTitVendasFormaPgto: TLabel;
    GridPanInad: TGridPanelLayout;
    lblInad3: TLabel;
    lblInad12: TLabel;
    lblInadTot: TLabel;
    lblLegInad3: TLabel;
    lblLegInad12: TLabel;
    lblLegInadTot: TLabel;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    GridPanelLayout2: TGridPanelLayout;
    Layout11: TLayout;
    Layout13: TLayout;
    Line4: TLine;
    Layout17: TLayout;
    Layout18: TLayout;
    lblRecebidasDia: TLabel;
    Layout14: TLayout;
    lblTotContaRecDia: TLabel;
    lblContaRecDia: TLabel;
    recTotalRecDia: TRectangle;
    recPercRecDia: TRectangle;
    ChartVendasMes: TChart;
    Series1: TBarSeries;
    ChartVendasVendedor: TChart;
    BarSeries1: THorizBarSeries;
    GridPanelLayout3: TGridPanelLayout;
    layFormasPgto: TLayout;
    Layout16: TLayout;
    ChartFormasPgto: TChart;
    PieSeries1: TPieSeries;
    CircleFormaPgto: TCircle;
    lblContaRecebidasDia: TLabel;
    lblContaARecDia: TLabel;
    lblAreceberDia: TLabel;
    Layout12: TLayout;
    Line5: TLine;
    Layout29: TLayout;
    recTotalRecMes: TRectangle;
    recPercRecMes: TRectangle;
    Layout30: TLayout;
    lblRecebidasMes: TLabel;
    lblContaRecebidasMes: TLabel;
    lblContaARecMes: TLabel;
    lblAreceberMes: TLabel;
    Layout31: TLayout;
    lblTotContaRecMes: TLabel;
    lblContaRecMes: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Layout32: TLayout;
    Line6: TLine;
    Layout33: TLayout;
    recTotalPagDia: TRectangle;
    recPercPagDia: TRectangle;
    Layout34: TLayout;
    lblPagasDia: TLabel;
    lblContaPagasDia: TLabel;
    lblContaAPagDia: TLabel;
    lblApagarDia: TLabel;
    Layout35: TLayout;
    lblTotContaPagDia: TLabel;
    lblContaPagDia: TLabel;
    Layout36: TLayout;
    Layout37: TLayout;
    Line7: TLine;
    Layout38: TLayout;
    recTotalPagMes: TRectangle;
    recPercPagMes: TRectangle;
    Layout39: TLayout;
    lblPagasMes: TLabel;
    lblContaPagasMes: TLabel;
    lblContaAPagMes: TLabel;
    lblApagarMes: TLabel;
    Layout40: TLayout;
    lblTotContaPagMes: TLabel;
    lblContaPagMes: TLabel;
    GridPanelFormas: TGridPanelLayout;
    Layout19: TLayout;
    Layout20: TLayout;
    recFormaPgto1: TRectangle;
    lblDescForma1: TLabel;
    lblValForma1: TLabel;
    TimerRepaint: TTimer;
    recSelecaoPeriodo: TRectangle;
    lblPeriodo: TLabel;
    Layout1: TLayout;
    lblVlrRecVencidas: TLabel;
    layQtdContaRecVenc: TLayout;
    lblRecVencidas: TLabel;
    CircQtdRecVencidas: TCircle;
    lblQtdRecVencidas: TLabel;
    Layout2: TLayout;
    layQtdContaPadVenc: TLayout;
    CircQtdPagVencidas: TCircle;
    lblQtdPagVencidas: TLabel;
    lblVlrPagVencidas: TLabel;
    lblPagVencidas: TLabel;
    p: TRectangle;
    gridContasDiagnostico: TGridPanelLayout;
    Rectangle16: TRectangle;
    layContasBancarias: TLayout;
    imgContasBancarias: TImage;
    lblTitContasBancarias: TLabel;
    layContasBancarias3: TLayout;
    Line11: TLine;
    gridLayContasBancarias3: TGridPanelLayout;
    layContaBancaria3_1: TLayout;
    lblVlContaBancaria3_1: TLabel;
    Line12: TLine;
    lblNomeContaBancaria3_1: TLabel;
    recDiagnosticoIA: TRectangle;
    layDiagnosticoIA: TLayout;
    imgDiagnosticoIA: TImage;
    lblTitDiagnosticoIA: TLabel;
    txtDiagnosticoIA: TText;
    imgExpContrai: TImage;
    pnlLoading: TRectangle;
    layLoading: TLayout;
    lblCarregando: TLabel;
    Rectangle10: TRectangle;
    BitmapListAnimation1: TBitmapListAnimation;
    imfInfoIA: TImage;
    Layout3: TLayout;
    Layout4: TLayout;
    imgDiagnosticoNext: TImage;
    imgDiagnosticoPrior: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerRepaintTimer(Sender: TObject);
    procedure lblPeriodoClick(Sender: TObject);
    procedure recSelecaoPeriodoMouseEnter(Sender: TObject);
    procedure recSelecaoPeriodoMouseLeave(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure imgExpContraiClick(Sender: TObject);
    procedure imgDiagnosticoPriorClick(Sender: TObject);
    procedure imgDiagnosticoNextClick(Sender: TObject);
  private
    dPercRecDia, dPercRecMes, dPercPagDia, dPercPagMes : double;
    iPeriodoSel, iPeriodoIASel : integer;
    iWidth, iHeigth : Single;
    iposX, iposY : Single;
    DadosDTO: TRootDadosDTO;
    procedure EscondeIcone;
    procedure GraficoRecPagar;
    procedure LegendaFormasPgto(VendasFormaPgto: TArray<TVendasFormaPgto>);
    procedure AtualizaDadosContasReceber;
    procedure AtualizaDadosContasPagar;
    procedure AtualizaDadosInadimplencia;
    procedure AtualizaDadosVendedor;
    procedure AtualizaDadosFormaPagamento;
    procedure AtualizaDadosContasBancarias;
    procedure AtualizaDadosVendasDiarias;
    procedure AtualizaDadosIndicadores;
    function Reduzida: boolean;
    procedure ExpandeDiagnosticoIA;
    procedure ContraiDiagnosticoIA;
    procedure AtualizaDadosDiagnosticoIA;
    { Private declarations }
  public
    procedure AtualizaDados(sJsonDados : string);
    { Public declarations }
  end;

var
  FrmDashboard: TFrmDashboard;

implementation

{$R *.fmx}


procedure TFrmDashboard.FormCreate(Sender: TObject);
begin
  iPeriodoSel   := 0;
  iPeriodoIASel := 0;
  pnlLoading.Align := TAlignLayout.Client;

  ChartVendasVendedor.Series[0].Clear;
  ChartFormasPgto.Series[0].Clear;
  layContasBancarias3.Visible := False;
  ChartVendasVendedor.Visible := False;
  ChartVendasMes.Visible      := False;
  GridPanelFormas.Visible     := False;
  CircQtdRecVencidas.Visible  := False;
  lblRecVencidas.Visible      := False;
  CircQtdPagVencidas.Visible  := False;
  lblPagVencidas.Visible      := False;
  lblVlrRecVencidas.Visible   := False;
  lblVlrPagVencidas.Visible   := False;
  imgDiagnosticoPrior.Visible := False;
  imgDiagnosticoNext.Visible  := False;
  imgExpContrai.Visible       := False;

  imfInfoIA.Hint := 'Seu diagnóstico por IA é '+sLineBreak+
                    'atualizado periodicamente.'+sLineBreak+
                    'Acompanhe os indicadores e'+sLineBreak+
                    'aproveite as dicas para melhorar'+sLineBreak+
                    'sua performance.';
end;

procedure TFrmDashboard.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if key=vk_f4 then
    abort;
end;

procedure TFrmDashboard.FormResize(Sender: TObject);
begin
  if Reduzida then
  begin
    {$Region'//// Ajusta resulução menor ////'}
    lblTitVendasDia.Font.Size       := 12;
    lblTitVendasMes.Font.Size       := 12;
    lblPeriodo.Font.Size            := 12;
    lblTitSaldoCaixa.Font.Size      := 12;
    lblTitInadimplencia.Font.Size   := 12;
    lblTitVendasDiarias.Font.Size   := 12;
    lblTitContasReceber.Font.Size   := 12;
    lblTitContasPagar.Font.Size     := 12;
    lblTitVendasVendedor.Font.Size  := 12;
    lblTitVendasFormaPgto.Font.Size := 12;
    lblTitContasBancarias.Font.Size := 12;
    lblTitDiagnosticoIA.Font.Size   := 12;

    txtDiagnosticoIA.Font.Size      := 11;

    layVendasDia.Margins.Top        := 5;
    layVendasMes.Margins.Top        := 5;
    laySaldoCaixa.Margins.Top       := 5;
    layInadimplencia.Margins.Top    := 5;
    layVendasDiarias.Margins.Top    := 5;
    layContasReceber.Margins.Top    := 5;
    layContasPagar.Margins.Top      := 5;
    layVendasVendedor.Margins.Top   := 5;
    layVendasFormaPgto.Margins.Top  := 5;
    layContasBancarias.Margins.Top  := 5;
    layDiagnosticoIA.Margins.Top    := 5;

    ImgVendasDia.Width              := 24;
    imgVendasMes.Width              := 24;
    imgSaldoCx.Width                := 24;
    imgInadimplencia.Width          := 24;
    imgVendasDiarias.Width          := 24;
    imgContasReceber.Width          := 24;
    imgContasPagar.Width            := 24;
    imgVendasVendedor.Width         := 24;
    imgVendasForma.Width            := 24;
    imgContasBancarias.Width        := 24;
    imgDiagnosticoIA.Width          := 24;

    lblContaRecDia.Font.Size        := 13;
    lblContaRecebidasDia.Font.Size  := 13;
    lblContaARecDia.Font.Size       := 13;
    lblContaRecMes.Font.Size        := 13;
    lblContaRecebidasMes.Font.Size  := 13;
    lblContaARecMes.Font.Size       := 13;
    lblVlrRecVencidas.Font.Size     := 13;
    lblTotContaRecDia.Font.Size     := 11;
    lblRecebidasDia.Font.Size       := 11;
    lblTotContaRecMes.Font.Size     := 11;
    lblRecebidasMes.Font.Size       := 11;
    lblAreceberDia.Font.Size        := 11;
    lblAreceberMes.Font.Size        := 11;
    lblRecVencidas.Font.Size        := 11;

    lblContaPagDia.Font.Size        := 13;
    lblContaPagasDia.Font.Size      := 13;
    lblContaAPagDia.Font.Size       := 13;
    lblContaPagMes.Font.Size        := 13;
    lblContaPagasMes.Font.Size      := 13;
    lblContaAPagMes.Font.Size       := 13;
    lblVlrPagVencidas.Font.Size     := 13;
    lblTotContaPagDia.Font.Size     := 11;
    lblPagasDia.Font.Size           := 11;
    lblTotContaPagMes.Font.Size     := 11;
    lblPagasMes.Font.Size           := 11;
    lblApagarDia.Font.Size          := 11;
    lblApagarMes.Font.Size          := 11;
    lblPagVencidas.Font.Size        := 11;

    lblVendasDia.Font.Size          := 28;
    lblVendasMes.Font.Size          := 28;
    lblSaldoCaixa.Font.Size         := 28;

    lblInad3.Font.Size              := 20;
    lblInad12.Font.Size             := 20;
    lblInadTot.Font.Size            := 20;
    lblLegInad3.Font.Size           := 13;
    lblLegInad12.Font.Size          := 13;
    lblLegInadTot.Font.Size         := 13;
    GridPanInad.Height              := 50;

    ChartFormasPgto.Series[0].Marks.Font.Size := 14;


    lblVlContaBancaria3_1.Font.Size   := 16;
    lblNomeContaBancaria3_1.Font.Size := 12;
    lblVlContaBancaria3_1.Width       := 146;

    recFormaPgto1.Width               := 22;
    recFormaPgto1.Height              := 22;
    lblDescForma1.Font.Size           := 10;
    lblDescForma1.Width               := 129;
    lblValForma1.Font.Size            := 12;
    {$Endregion}
  end else
  begin
    {$Region'//// Ajusta resulução maior ////'}
    lblTitVendasDia.Font.Size       := 14;
    lblTitVendasMes.Font.Size       := 14;
    lblPeriodo.Font.Size            := 14;
    lblTitSaldoCaixa.Font.Size      := 14;
    lblTitInadimplencia.Font.Size   := 14;
    lblTitVendasDiarias.Font.Size   := 14;
    lblTitContasReceber.Font.Size   := 14;
    lblTitContasPagar.Font.Size     := 14;
    lblTitVendasVendedor.Font.Size  := 14;
    lblTitVendasFormaPgto.Font.Size := 14;
    lblTitContasBancarias.Font.Size := 14;
    lblTitDiagnosticoIA.Font.Size   := 14;

    txtDiagnosticoIA.Font.Size      := 13;

    layVendasDia.Margins.Top        := 10;
    layVendasMes.Margins.Top        := 10;
    laySaldoCaixa.Margins.Top       := 10;
    layInadimplencia.Margins.Top    := 10;
    layVendasDiarias.Margins.Top    := 10;
    layContasReceber.Margins.Top    := 10;
    layContasPagar.Margins.Top      := 10;
    layVendasVendedor.Margins.Top   := 10;
    layVendasFormaPgto.Margins.Top  := 10;
    layContasBancarias.Margins.Top  := 10;
    layDiagnosticoIA.Margins.Top    := 10;

    ImgVendasDia.Width              := 28;
    imgVendasMes.Width              := 28;
    imgSaldoCx.Width                := 28;
    imgInadimplencia.Width          := 28;
    imgVendasDiarias.Width          := 28;
    imgContasReceber.Width          := 28;
    imgContasPagar.Width            := 28;
    imgVendasVendedor.Width         := 28;
    imgVendasForma.Width            := 28;
    imgContasBancarias.Width        := 28;
    imgDiagnosticoIA.Width          := 28;

    lblContaRecDia.Font.Size        := 16;
    lblContaRecebidasDia.Font.Size  := 16;
    lblContaARecDia.Font.Size       := 16;
    lblContaRecMes.Font.Size        := 16;
    lblContaRecebidasMes.Font.Size  := 16;
    lblContaARecMes.Font.Size       := 16;
    lblVlrRecVencidas.Font.Size     := 16;
    lblTotContaRecDia.Font.Size     := 12;
    lblRecebidasDia.Font.Size       := 12;
    lblTotContaRecMes.Font.Size     := 12;
    lblRecebidasMes.Font.Size       := 12;
    lblAreceberDia.Font.Size        := 12;
    lblAreceberMes.Font.Size        := 12;
    lblRecVencidas.Font.Size        := 12;

    lblContaPagDia.Font.Size        := 16;
    lblContaPagasDia.Font.Size      := 16;
    lblContaAPagDia.Font.Size       := 16;
    lblContaPagMes.Font.Size        := 16;
    lblContaPagasMes.Font.Size      := 16;
    lblContaAPagMes.Font.Size       := 16;
    lblVlrPagVencidas.Font.Size     := 16;
    lblTotContaPagDia.Font.Size     := 12;
    lblPagasDia.Font.Size           := 12;
    lblTotContaPagMes.Font.Size     := 12;
    lblPagasMes.Font.Size           := 12;
    lblApagarDia.Font.Size          := 12;
    lblApagarMes.Font.Size          := 12;
    lblPagVencidas.Font.Size        := 12;

    lblVendasDia.Font.Size          := 36;
    lblVendasMes.Font.Size          := 36;
    lblSaldoCaixa.Font.Size         := 36;

    lblInad3.Font.Size              := 28;
    lblInad12.Font.Size             := 28;
    lblInadTot.Font.Size            := 28;
    lblLegInad3.Font.Size           := 16;
    lblLegInad12.Font.Size          := 16;
    lblLegInadTot.Font.Size         := 16;
    GridPanInad.Height              := 75;

    ChartFormasPgto.Series[0].Marks.Font.Size := 17;


    lblVlContaBancaria3_1.Font.Size   := 20;
    lblNomeContaBancaria3_1.Font.Size := 14;
    lblVlContaBancaria3_1.Width       := 160;

    recFormaPgto1.Width               := 27;
    recFormaPgto1.Height              := 27;
    lblDescForma1.Font.Size           := 12;
    lblDescForma1.Width               := 150;
    lblValForma1.Font.Size            := 14;
    {$Endregion}
  end;

  GraficoRecPagar;
end;

procedure TFrmDashboard.FormShow(Sender: TObject);
begin
  EscondeIcone;
end;

procedure TFrmDashboard.TimerRepaintTimer(Sender: TObject);
begin
  TimerRepaint.Enabled := False;
  GridPanelFormas.Repaint;
  gridLayContasBancarias3.Repaint;
  lblTitDiagnosticoIA.Repaint;
  Self.Updated;
end;

procedure TFrmDashboard.EscondeIcone;
var
  appHandle: HWND;
  pid, current_pid: DWORD;
  name: String;
begin
  name := ChangeFileExt(ExtractFileName(ParamStr(0)), '');

  appHandle := 0;
  pid := 0;
  current_pid := GetCurrentProcessId();
  repeat
  begin
    appHandle := FindWindowExA(0, appHandle, 'TFMAppClass', PAnsiChar(AnsiString(name)));
    if (appHandle>0) then
    begin
      GetWindowThreadProcessId(appHandle, pid);
      if (current_pid = pid) then break;
    end;
  end
  until (appHandle>0);

  ShowWindow(appHandle, SW_HIDE);
end;

procedure TFrmDashboard.AtualizaDados(sJsonDados : string);
begin
  if sJsonDados = '' then
    Exit;

  pnlLoading.Visible          := False;
  layLoading.Visible          := False;

  ChartVendasVendedor.Visible := True;
  ChartVendasMes.Visible      := True;
  GridPanelFormas.Visible     := True;

  CircQtdRecVencidas.Visible  := True;
  lblRecVencidas.Visible      := True;
  CircQtdPagVencidas.Visible  := True;
  lblPagVencidas.Visible      := True;
  lblVlrRecVencidas.Visible   := True;
  lblVlrPagVencidas.Visible   := True;

  try
    try
      if DadosDTO <> nil then
        FreeAndNil(DadosDTO);

      DadosDTO := TJson.JsonToObject<TRootDadosDTO>(sJsonDados);

      AtualizaDadosIndicadores;

      AtualizaDadosInadimplencia;

      AtualizaDadosVendasDiarias;

      AtualizaDadosContasReceber;

      AtualizaDadosContasPagar;

      GraficoRecPagar;

      AtualizaDadosVendedor;

      AtualizaDadosFormaPagamento;

      AtualizaDadosContasBancarias;

      AtualizaDadosDiagnosticoIA;
    finally
    end;
  except
  end;

  TimerRepaint.Enabled    := True;
end;


procedure TFrmDashboard.GraficoRecPagar;
begin
  if dPercRecDia = 100 then
    recPercRecDia.Width := recTotalRecDia.Width
  else
    recPercRecDia.Width       := Trunc((recTotalRecDia.Width / 100 ) * dPercRecDia);

  if dPercRecMes = 100 then
    recPercRecMes.Width := recTotalRecMes.Width
  else
    recPercRecMes.Width       := Trunc((recTotalRecMes.Width / 100 ) * dPercRecMes);

  if dPercPagDia = 100 then
    recPercPagDia.Width := recTotalPagDia.Width
  else
    recPercPagDia.Width       := Trunc((recTotalPagDia.Width / 100 ) * dPercPagDia);

  if dPercPagMes = 100 then
    recPercPagMes.Width := recTotalPagMes.Width
  else
    recPercPagMes.Width       := Trunc((recTotalPagMes.Width / 100 ) * dPercPagMes);
end;

procedure TFrmDashboard.imgDiagnosticoNextClick(Sender: TObject);
begin
  iPeriodoIASel := iPeriodoIASel -1;
  AtualizaDadosDiagnosticoIA;
end;

procedure TFrmDashboard.imgDiagnosticoPriorClick(Sender: TObject);
begin
  iPeriodoIASel := iPeriodoIASel +1;
  AtualizaDadosDiagnosticoIA;
end;

procedure TFrmDashboard.imgExpContraiClick(Sender: TObject);
begin
  if imgExpContrai.Tag = 0 then
  begin
    ExpandeDiagnosticoIA;
    imgExpContrai.Tag := 1;
    imgExpContrai.AnimateFloat('RotationAngle',0,0.2);
  end else
  begin
    ContraiDiagnosticoIA;
    imgExpContrai.Tag := 0;
    imgExpContrai.AnimateFloat('RotationAngle',180,0.2);
  end;
end;

procedure TFrmDashboard.lblPeriodoClick(Sender: TObject);
begin
  if iPeriodoSel = 0 then
  begin
    iPeriodoSel := 1;
  end else
  begin
    iPeriodoSel := 0;
  end;

  AtualizaDadosIndicadores;
  AtualizaDadosVendasDiarias;
  AtualizaDadosVendedor;
  AtualizaDadosFormaPagamento;
end;

procedure TFrmDashboard.LegendaFormasPgto(VendasFormaPgto: TArray<TVendasFormaPgto>);
var
  i, QtdTot, iMargem, iMargem2: integer;
  lblTexto, recCor : TComponent;
  layFormaPgto, layCorPgto: TLayout;
  lblDescForma, lblValForma : TLabel;
  recFormaPgto : TRectangle;
begin
  QtdTot := High(VendasFormaPgto) + 1;

  if GridPanelFormas.RowCollection.Count < QtdTot then
  begin
    //Add linhas faltantes
    for i := GridPanelFormas.RowCollection.Count + 1 to QtdTot do
    begin
      GridPanelFormas.RowCollection.Add;

      layFormaPgto := TLayout.Create(Self);

      layFormaPgto.Align  := TAlignLayout.Client;
      layFormaPgto.Parent := GridPanelFormas;

      layCorPgto := TLayout.Create(Self);
      layCorPgto.Align  := TAlignLayout.Left;
      layCorPgto.Parent := layFormaPgto;
      layCorPgto.Width  := 39;

      lblDescForma                := TLabel.Create(self);
      lblDescForma.Name           := 'lblDescForma'+i.ToString;
      lblDescForma.StyledSettings := lblDescForma1.StyledSettings;
      lblDescForma.Parent         := layFormaPgto;
      lblDescForma.Align          := lblDescForma1.Align;
      lblDescForma.Anchors        := lblDescForma1.Anchors;
      lblDescForma.TextSettings   := lblDescForma1.TextSettings;

      lblValForma                 := TLabel.Create(self);
      lblValForma.Name            := 'lblValForma'+i.ToString;
      lblValForma.StyledSettings  := lblValForma1.StyledSettings;
      lblValForma.Parent          := layFormaPgto;
      lblValForma.Align           := lblValForma1.Align;
      lblValForma.Width           := lblValForma1.Width;
      lblValForma.TextSettings    := lblValForma1.TextSettings;

      recFormaPgto                := TRectangle.Create(self);
      recFormaPgto.Name           := 'recFormaPgto'+i.ToString;
      recFormaPgto.Parent         := layCorPgto;
      recFormaPgto.Align          := TAlignLayout.Center;
      recFormaPgto.Width          := recFormaPgto1.Width;
      recFormaPgto.Height         := recFormaPgto1.Height;
      recFormaPgto.Stroke.Color   := recFormaPgto1.Stroke.Color
    end;
  end;

  GridPanelFormas.RowCollection.BeginUpdate;

  //Oculta todas
  for I := 0 to GridPanelFormas.RowCollection.Count - 1 do
  begin
    GridPanelFormas.RowCollection[i].SizeStyle := TGridPanelLayout.TsizeStyle.Absolute;
    GridPanelFormas.RowCollection[i].Value := 0;
  end;

  //Habilita e preenche formas
  for I := 0 to QtdTot -1 do
  begin
    try
      GridPanelFormas.RowCollection[i].SizeStyle := TGridPanelLayout.TsizeStyle.Percent;
      GridPanelFormas.RowCollection[i].Value := 100 / QtdTot;

      lblTexto := FindComponent('lblDescForma'+IntToStr(i+1));
      TLabel(lblTexto).Text := VendasFormaPgto[i].Descricao;

      lblTexto := FindComponent('lblValForma'+IntToStr(i+1));
      TLabel(lblTexto).Text := Formatfloat('##,##00.00 %',VendasFormaPgto[i].Percentual)+ ' = '+Formatfloat('R$ #,##0.00',VendasFormaPgto[i].Valor);

      recCor := FindComponent('recFormaPgto'+IntToStr(i+1));
      TRectangle(recCor).Fill.Color := VendasFormaPgto[i].Cor;
    except
    end;
  end;

  GridPanelFormas.RowCollection.EndUpdate;

  //Ajusta Margens
  iMargem  := 0;
  iMargem2 := 20;

  if QtdTot <= 4 then
  begin
    if Reduzida then
      iMargem := 25
    else
      iMargem := 50;
  end;

  if (QtdTot > 4) and (QtdTot <= 6) then
  begin
    if Reduzida then
      iMargem := 0
    else
      iMargem := 25;
  end;

  if (QtdTot > 6) and (Reduzida) then
  begin
    iMargem2 := 5;
  end;

  GridPanelFormas.Margins.Top    := iMargem;
  GridPanelFormas.Margins.Bottom := iMargem;
  layFormasPgto.Margins.Top      := iMargem2;
  layFormasPgto.Margins.Bottom   := iMargem2;

  TimerRepaint.Enabled := True;
end;

procedure TFrmDashboard.AtualizaDadosContasReceber;
begin
  lblContaRecDia.Text       := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.ReceberDia);
  lblContaRecMes.Text       := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.ReceberMes);
  lblContaRecebidasDia.Text := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.RecebidasDia);
  lblContaRecebidasMes.Text := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.RecebidasMes);
  lblContaARecDia.Text      := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.ReceberDia - DadosDTO.ContasReceber.RecebidasDia);
  lblContaARecMes.Text      := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.ReceberMes - DadosDTO.ContasReceber.RecebidasMes);
  dPercRecDia               := DadosDTO.ContasReceber.PercRecDia;
  dPercRecMes               := DadosDTO.ContasReceber.PercRecMes;
  lblVlrRecVencidas.Text    := Formatfloat('R$ #,##0.00', DadosDTO.ContasReceber.ValorVencidasMes);

  if DadosDTO.ContasReceber.ValorVencidasMes > 0 then
    lblVlrRecVencidas.FontColor := $FFF2496C
  else
    lblVlrRecVencidas.FontColor := $FF495465;

  if DadosDTO.ContasReceber.VencidasMes > 0 then
  begin
    CircQtdRecVencidas.Fill.Color   := $FFF2496C;
    CircQtdRecVencidas.Stroke.Color := $FFF2496C;
  end else
  begin
    CircQtdRecVencidas.Fill.Color   := $FF495465;
    CircQtdRecVencidas.Stroke.Color := $FF495465;
  end;

  if DadosDTO.ContasReceber.VencidasMes < 100 then
  begin
    lblQtdRecVencidas.Text    := DadosDTO.ContasReceber.VencidasMes.ToString;
    lblQtdRecVencidas.Width  := 16;
    layQtdContaRecVenc.Width := 22;
    CircQtdRecVencidas.Width := 22;
  end else
  begin
    lblQtdRecVencidas.Text    := '99+';
    lblQtdRecVencidas.Width  := 26;
    layQtdContaRecVenc.Width := 26;
    CircQtdRecVencidas.Width := 26;
  end;
end;

procedure TFrmDashboard.AtualizaDadosContasPagar;
begin
  lblContaPagDia.Text    := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagarDia);
  lblContaPagMes.Text    := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagarMes);
  lblContaPagasDia.Text  := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagasDia);
  lblContaPagasMes.Text  := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagasMes);
  lblContaAPagDia.Text   := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagarDia - DadosDTO.ContasPagar.PagasDia);
  lblContaAPagMes.Text   := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.PagarMes - DadosDTO.ContasPagar.PagasMes);
  dPercPagDia            := DadosDTO.ContasPagar.PercPagDia;
  dPercPagMes            := DadosDTO.ContasPagar.PercPagMes;
  lblVlrPagVencidas.Text := Formatfloat('R$ #,##0.00', DadosDTO.ContasPagar.ValorVencidasMes);

  if DadosDTO.ContasPagar.ValorVencidasMes > 0 then
    lblVlrPagVencidas.FontColor := $FFF2496C
  else
    lblVlrPagVencidas.FontColor := $FF495465;

  if DadosDTO.ContasPagar.VencidasMes > 0 then
  begin
    CircQtdPagVencidas.Fill.Color   := $FFF2496C;
  end else
  begin
    CircQtdPagVencidas.Fill.Color   := $FF495465;
  end;

  if DadosDTO.ContasPagar.VencidasMes < 100 then
  begin
    lblQtdPagVencidas.Text := DadosDTO.ContasPagar.VencidasMes.ToString;
    lblQtdPagVencidas.Width  := 16;
    layQtdContaPadVenc.Width := 22;
    CircQtdPagVencidas.Width := 22;
  end else
  begin
    lblQtdPagVencidas.Text   := '99+';
    lblQtdPagVencidas.Width  := 26;
    layQtdContaPadVenc.Width := 26;
    CircQtdPagVencidas.Width := 26;
  end;
end;

procedure TFrmDashboard.AtualizaDadosInadimplencia;
begin
  lblInad3.Text     := Formatfloat('#,##0.00%', DadosDTO.Inadimplencia.Trimestre);

  if DadosDTO.Inadimplencia.Trimestre > 0 then
    lblInad3.FontColor := $FFF2496C
  else
    lblInad3.FontColor := $FF495465;

  lblInad12.Text    := Formatfloat('#,##0.00%', DadosDTO.Inadimplencia.Ano);

  if DadosDTO.Inadimplencia.Ano > 0 then
    lblInad12.FontColor := $FFF2496C
  else
    lblInad12.FontColor := $FF495465;

  lblInadTot.Text   := Formatfloat('#,##0.00%', DadosDTO.Inadimplencia.Total);

  if DadosDTO.Inadimplencia.Total > 0 then
    lblInadTot.FontColor := $FFF2496C
  else
    lblInadTot.FontColor := $FF495465;
end;

procedure TFrmDashboard.AtualizaDadosVendedor;
var
  i: Integer;
begin
  ChartVendasVendedor.Series[0].Clear;
  DadosDTO.SetCorVendedor;
  for i := Low(DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor) to High(DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor) do
  begin
    ChartVendasVendedor.Series[0].Add(DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor[i].Valor,
                                      DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor[i].Vendedor + ' ',
                                      DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor[i].Cor);

    ChartVendasVendedor.Series[0].Marks[i].Text.Text := Formatfloat('R$ #,##0.00', DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor[i].Valor);
  end;

  ChartVendasVendedor.Visible :=  High(DadosDTO.VendasPeriodo[iPeriodoSel].VendasVendedor) >= 0;
end;

procedure TFrmDashboard.AtualizaDadosFormaPagamento;
var
  i : Integer;
begin
  //Vendas forma pagamento
  DadosDTO.CalcPercentualPgto;
  ChartFormasPgto.Series[0].Clear;
  DadosDTO.SetCorFormasPgto;

  for i := Low(DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto) to High(DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto) do
  begin
    ChartFormasPgto.Series[0].Add(DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto[i].Valor,
                                  DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto[i].Descricao + ' ',
                                  DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto[i].Cor);
  end;
  LegendaFormasPgto(DadosDTO.VendasPeriodo[iPeriodoSel].VendasFormaPgto);
end;


procedure TFrmDashboard.AtualizaDadosContasBancarias;
var
  i, iQtdReg : integer;
  layContasBanc: TLayout;
  lblDescContaBanc, lblValContaBanc : TLabel;
  LinhaContasBanc : Tline;
  lblTexto : TComponent;
begin
  layContasBancarias3.Visible := False;
  iQtdReg := High(DadosDTO.ContasBancarias) + 1;

  layContasBancarias3.Align              := TAlignLayout.Client;

  if iQtdReg > 0 then
    layContasBancarias3.Visible            := True;

  if gridLayContasBancarias3.RowCollection.Count < iQtdReg then
  begin
    //Add linhas faltantes
    for i := gridLayContasBancarias3.RowCollection.Count + 1 to iQtdReg do
    begin
      gridLayContasBancarias3.RowCollection.Add;
      layContasBanc := TLayout.Create(Self);
      layContasBanc.Align := TAlignLayout.Client;
      layContasBanc.Parent := gridLayContasBancarias3;

      lblDescContaBanc                := TLabel.Create(self);
      lblDescContaBanc.Name           := 'lblNomeContaBancaria3_'+i.ToString;
      lblDescContaBanc.StyledSettings := lblNomeContaBancaria3_1.StyledSettings;
      lblDescContaBanc.Parent         := layContasBanc;
      lblDescContaBanc.Align          := lblNomeContaBancaria3_1.Align;
      lblDescContaBanc.Anchors        := lblNomeContaBancaria3_1.Anchors;

      lblValContaBanc                 := TLabel.Create(self);
      lblValContaBanc.Name            := 'lblVlContaBancaria3_'+i.ToString;
      lblValContaBanc.StyledSettings  := lblVlContaBancaria3_1.StyledSettings;
      lblValContaBanc.Parent          := layContasBanc;
      lblValContaBanc.Align           := lblVlContaBancaria3_1.Align;
      lblValContaBanc.Width           := lblVlContaBancaria3_1.Width;


      LinhaContasBanc                 := Tline.Create(self);
      LinhaContasBanc.Parent          := layContasBanc;
      LinhaContasBanc.Align           := TAlignLayout.Bottom;
      LinhaContasBanc.Stroke.Color    := $FFE2EBF3;
      LinhaContasBanc.Height          := 1;
    end;

    //Ajusta tamanho
    gridLayContasBancarias3.RowCollection.BeginUpdate;

    for I := 0 to iQtdReg -1 do
    begin
      gridLayContasBancarias3.RowCollection[i].SizeStyle := TGridPanelLayout.TsizeStyle.Percent;
      gridLayContasBancarias3.RowCollection[i].Value := 100 / iQtdReg;
    end;

    gridLayContasBancarias3.RowCollection.EndUpdate;
  end;

  for i := Low(DadosDTO.ContasBancarias) to High(DadosDTO.ContasBancarias) do
  begin
    try
      lblTexto := FindComponent('lblNomeContaBancaria3_'+IntToStr(i+1));
      TLabel(lblTexto).Text         := DadosDTO.ContasBancarias[i].Descricao;
      TLabel(lblTexto).TextSettings := lblNomeContaBancaria3_1.TextSettings;
    except
    end;

    try
      lblTexto := FindComponent('lblVlContaBancaria3_'+IntToStr(i+1));
      TLabel(lblTexto).Text         := Formatfloat('R$ ##,##0.00',DadosDTO.ContasBancarias[i].Valor);
      TLabel(lblTexto).TextSettings := lblVlContaBancaria3_1.TextSettings;
    except
    end;
  end;
end;

procedure TFrmDashboard.AtualizaDadosVendasDiarias;
var
  i, iMaxL: Integer;
begin
  iMaxL := 0;
  ChartVendasMes.Series[0].Clear;
  for I := Low(DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias) to High(DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias) do
  begin
    ChartVendasMes.Series[0].Add(DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias[i].Valor,
                                 DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias[i].Dia);

    ChartVendasMes.Series[0].Marks[i].Text.Text := '  '+Formatfloat('R$ #,##0.00', DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias[i].Valor);

    if Length(Formatfloat('R$ #,##0.00', DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias[i].Valor)) > iMaxL then
      iMaxL := Length(Formatfloat('R$ #,##0.00', DadosDTO.VendasPeriodo[iPeriodoSel].VendasDiarias[i].Valor));
  end;

  ChartVendasMes.MarginTop := 3 + (iMaxL * 2);
end;

procedure TFrmDashboard.AtualizaDadosIndicadores;
begin
  if iPeriodoSel = 0 then
    lblPeriodo.Text    := '< '+DadosDTO.VendasPeriodo[iPeriodoSel].Periodo
  else
    lblPeriodo.Text    := DadosDTO.VendasPeriodo[iPeriodoSel].Periodo+' >';

  lblVendasDia.Text  := Formatfloat('R$ #,##0.00', DadosDTO.VendasDia);
  lblVendasMes.Text  := Formatfloat('R$ #,##0.00', DadosDTO.VendasPeriodo[iPeriodoSel].VendasMes);
  lblSaldoCaixa.Text := Formatfloat('R$ #,##0.00', DadosDTO.SaldoCaixa);
end;

procedure TFrmDashboard.recSelecaoPeriodoMouseEnter(Sender: TObject);
begin
  lblPeriodo.Font.Style :=  [TFontStyle.fsBold];
end;

procedure TFrmDashboard.recSelecaoPeriodoMouseLeave(Sender: TObject);
begin
  lblPeriodo.Font.Style :=  [];
end;

function TFrmDashboard.Reduzida:boolean;
begin
  Result := (Width < 1440) or (Height < 720);
end;


procedure TFrmDashboard.ExpandeDiagnosticoIA;
begin
  iposX   := gridContasDiagnostico.Position.X + 5;
  iposY   := GridPanelLinha3.Position.Y + recDiagnosticoIA.Position.Y;
  iWidth  := recDiagnosticoIA.Width;
  iHeigth := recDiagnosticoIA.Height;

  recDiagnosticoIA.Parent := self;
  recDiagnosticoIA.Align  := TAlignLayout.None;

  recDiagnosticoIA.Position.X := iposX;
  recDiagnosticoIA.Position.Y := iposY;
  recDiagnosticoIA.Width      := iWidth;
  recDiagnosticoIA.Height     := iHeigth;

  //recDiagnosticoIA.AnimateFloat('Position.Y',10,0.3);
  recDiagnosticoIA.AnimateFloat('Position.Y',GridPanelLinha2.Position.Y + 5,0.3);
  recDiagnosticoIA.AnimateFloatWait('Height',self.Height - (GridPanelLinha2.Position.Y + 15 ) ,0.3);
end;

procedure TFrmDashboard.ContraiDiagnosticoIA;
begin
  recDiagnosticoIA.AnimateFloat('Position.Y',iposY,0.3);
  recDiagnosticoIA.AnimateFloatWait('Height',iHeigth ,0.3);

  recDiagnosticoIA.Parent := gridContasDiagnostico;
  recDiagnosticoIA.Align  := TAlignLayout.Client;
  TimerRepaint.Enabled    := True;
end;


procedure TFrmDashboard.AtualizaDadosDiagnosticoIA;
begin
  imgDiagnosticoPrior.Visible := False;
  imgDiagnosticoNext.Visible  := False;

  if High(DadosDTO.AnaliseIA) < 0 then
  begin
    imgExpContrai.Visible := False;
    txtDiagnosticoIA.TextSettings.VertAlign := TTextAlign.Center;
    txtDiagnosticoIA.Text := 'A Inteligência Artificial está coletando os dados para gerar o diagnóstico.'+sLineBreak+
                             'Em breve teremos uma análise para você.';
  end else
  begin
    imgExpContrai.Visible := True;
    txtDiagnosticoIA.TextSettings.VertAlign := TTextAlign.Leading;
    txtDiagnosticoIA.Text := DateToStr(DadosDTO.AnaliseIA[iPeriodoIASel].Periodo) + ' - ' + DadosDTO.AnaliseIA[iPeriodoIASel].Analise;

    if High(DadosDTO.AnaliseIA) > 0 then
    begin
      imgDiagnosticoPrior.Visible  := iPeriodoIASel <> High(DadosDTO.AnaliseIA);
      imgDiagnosticoNext.Visible   := iPeriodoIASel <> Low(DadosDTO.AnaliseIA);
    end;
  end;
end;

end.
