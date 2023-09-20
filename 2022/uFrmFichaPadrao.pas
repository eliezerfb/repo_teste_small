unit uFrmFichaPadrao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, DB, IBCustomDataSet, IBQuery, ExtDlgs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmFichaPadrao = class(TFrmPadrao)
    Panel_branco: TPanel;
    pnlBotoesSuperior: TPanel;
    imgNovo: TImage;
    imgProcurar: TImage;
    imgVisualizar: TImage;
    imgAnterior: TImage;
    imgProximo: TImage;
    lblNovo: TLabel;
    lblProcurar: TLabel;
    lblVisualizar: TLabel;
    lblAnterior: TLabel;
    lblProximo: TLabel;
    pnlBotoesPosterior: TPanel;
    btnOK: TBitBtn;
    Panel1: TPanel;
    Button4: TBitBtn;
    Panel8: TPanel;
    Button19: TBitBtn;
    pgcFicha: TPageControl;
    DSCadastro: TDataSource;
    procedure lblNovoMouseLeave(Sender: TObject);
    procedure lblProcurarMouseLeave(Sender: TObject);
    procedure lblVisualizarMouseLeave(Sender: TObject);
    procedure lblAnteriorMouseLeave(Sender: TObject);
    procedure lblProximoMouseLeave(Sender: TObject);
    procedure lblNovoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblProcurarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblVisualizarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure lblAnteriorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblProximoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFichaPadrao: TFrmFichaPadrao;

implementation

uses uIconesSistema
    ;

{$R *.dfm}

procedure TFrmFichaPadrao.lblNovoMouseLeave(Sender: TObject);
begin
  if lblNovo.Font.Style <> [] then
  begin
    imgNovo.Picture    := IconesSistema.GetIconNovo(False).Picture;
    lblNovo.Font.Style := [];
  end;
end;

procedure TFrmFichaPadrao.lblProcurarMouseLeave(Sender: TObject);
begin
  if lblProcurar.Font.Style <> [] then
  begin
    imgProcurar.Picture    := IconesSistema.GetIconProcurar(False).Picture;
    lblProcurar.Font.Style := [];
  end;
end;

procedure TFrmFichaPadrao.lblVisualizarMouseLeave(Sender: TObject);
begin
  if lblVisualizar.Font.Style <> [] then
  begin
    imgVisualizar.Picture    := IconesSistema.GetIconVisualizar(False).Picture;
    lblVisualizar.Font.Style := [];
  end;
end;

procedure TFrmFichaPadrao.lblAnteriorMouseLeave(Sender: TObject);
begin
  if lblAnterior.Font.Style <> [] then
  begin
    imgAnterior.Picture    := IconesSistema.GetIconAnterior(False).Picture;
    lblAnterior.Font.Style := [];
  end;
end;

procedure TFrmFichaPadrao.lblProximoMouseLeave(Sender: TObject);
begin
  if lblProximo.Font.Style <> [] then
  begin
    imgProximo.Picture    := IconesSistema.GetIconProximo(False).Picture;
    lblProximo.Font.Style := [];
  end;
end;

procedure TFrmFichaPadrao.lblNovoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblNovo.Font.Style <> [fsBold] then
  begin
    imgNovo.Picture    := IconesSistema.GetIconNovo(True).Picture;
    lblNovo.Font.Style := [fsBold];
  end;
end;

procedure TFrmFichaPadrao.lblProcurarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblProcurar.Font.Style <> [fsBold] then
  begin
    imgProcurar.Picture    := IconesSistema.GetIconProcurar(True).Picture;
    lblProcurar.Font.Style := [fsBold];
  end;
end;

procedure TFrmFichaPadrao.lblVisualizarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblVisualizar.Font.Style <> [fsBold] then
  begin
    imgVisualizar.Picture    := IconesSistema.GetIconVisualizar(True).Picture;
    lblVisualizar.Font.Style := [fsBold];
  end;
end;

procedure TFrmFichaPadrao.lblAnteriorMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblAnterior.Font.Style <> [fsBold] then
  begin
    imgAnterior.Picture    := IconesSistema.GetIconAnterior(True).Picture;
    lblAnterior.Font.Style := [fsBold];
  end;
end;

procedure TFrmFichaPadrao.lblProximoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lblProximo.Font.Style <> [fsBold] then
  begin
    imgProximo.Picture    := IconesSistema.GetIconProximo(True).Picture;
    lblProximo.Font.Style := [fsBold];
  end;
end;

procedure TFrmFichaPadrao.FormCreate(Sender: TObject);
begin
  inherited;
  
  imgNovo.Picture       := IconesSistema.GetIconNovo(False).Picture;
  imgProcurar.Picture   := IconesSistema.GetIconProcurar(False).Picture;
  imgVisualizar.Picture := IconesSistema.GetIconVisualizar(False).Picture;
  imgProximo.Picture    := IconesSistema.GetIconProximo(False).Picture;
  imgAnterior.Picture   := IconesSistema.GetIconAnterior(False).Picture;
end;

procedure TFrmFichaPadrao.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
