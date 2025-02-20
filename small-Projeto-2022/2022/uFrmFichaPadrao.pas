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
    procedure lblAnteriorClick(Sender: TObject);
    procedure lblProximoClick(Sender: TObject);
    procedure lblProcurarClick(Sender: TObject);
    procedure lblVisualizarClick(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PadraoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    VerificandoUso : Boolean;
    function GravaRegistro: Boolean;
    { Private declarations }
  public
    bEstaSendoUsado : Boolean;
    bSomenteLeitura: Boolean;
    bGravandoRegistro : Boolean;
    procedure VerificaSeEstaSendoUsado;
    function GetDescritivoNavegacao:string;
    function FormularioAtivo(Form : TForm): boolean;
    procedure KeyPressPadrao(Sender: TObject; var Key: Word; Shift: TShiftState);
    { Public declarations }
  protected
    procedure SetaStatusUso; virtual; abstract;
    function GetPaginaAjuda:string; virtual; abstract;
  end;

var
  FrmFichaPadrao: TFrmFichaPadrao;

implementation

uses uIconesSistema
    , uFrmAssistenteProcura
    , uVisualizaCadastro
    , uFuncoesBancoDados
    , smallfunc_xe, unit7;

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

  bGravandoRegistro     := False;
end;

procedure TFrmFichaPadrao.btnOKClick(Sender: TObject);
begin
  GravaRegistro;
  Close;
end;

procedure TFrmFichaPadrao.lblAnteriorClick(Sender: TObject);
begin
  inherited;
  DSCadastro.DataSet.Prior;
  TibDataSet(DSCadastro.DataSet).Transaction.CommitRetaining;
  VerificaSeEstaSendoUsado;
end;

procedure TFrmFichaPadrao.lblProximoClick(Sender: TObject);
begin
  inherited;
  DSCadastro.DataSet.Next;
  TibDataSet(DSCadastro.DataSet).Transaction.CommitRetaining;
  VerificaSeEstaSendoUsado;
end;

procedure TFrmFichaPadrao.lblProcurarClick(Sender: TObject);
begin
  inherited;
  FrmAssistenteProcura.ShowModal;
end;

procedure TFrmFichaPadrao.lblVisualizarClick(Sender: TObject);
begin
  inherited;
  GeraVisualizacaoFichaCadastro;
end;

procedure TFrmFichaPadrao.lblNovoClick(Sender: TObject);
begin
  inherited;

  bEstaSendoUsado := False;
  SetaStatusUso;
  
  DSCadastro.DataSet.Append;
  TibDataSet(DSCadastro.DataSet).Transaction.CommitRetaining;
end;

function TFrmFichaPadrao.GravaRegistro:Boolean;
begin
  bGravandoRegistro  := True;

  if bEstaSendoUsado then
  begin
    DSCadastro.DataSet.Cancel;
  end else
  begin
    if DSCadastro.DataSet.Modified then
    begin
      DSCadastro.DataSet.Post;
    end else
    begin
      DSCadastro.DataSet.Cancel;
    end;
  end;

  TibDataSet(DSCadastro.DataSet).Transaction.CommitRetaining;
  Result := True;

  bGravandoRegistro  := False;
end;

procedure TFrmFichaPadrao.VerificaSeEstaSendoUsado;
begin
  if VerificandoUso then
    Exit;

  VerificandoUso  := True;
  bEstaSendoUsado := False;

  if not (DSCadastro.DataSet.State in ([dsInsert])) then
  begin
    try
      DSCadastro.DataSet.DisableControls;
      DSCadastro.DataSet.Edit;
      DSCadastro.DataSet.Post;
      bEstaSendoUsado := False;
    except
      bEstaSendoUsado := True;
    end;

    DSCadastro.DataSet.EnableControls;
  end;

  //Mauricio Parizotto 2024-08-12
  if bEstaSendoUsado then
  //Faz commit e testa novamente
  begin
    try
      AgendaCommit(True);
      Form7.Close;
      Form7.Show;

      Self.BringToFront;

      try
        DSCadastro.DataSet.DisableControls;
        DSCadastro.DataSet.Edit;
        DSCadastro.DataSet.Post;
        bEstaSendoUsado := False;
      except
        bEstaSendoUsado := True;
      end;

      DSCadastro.DataSet.EnableControls;
    except
    end;
  end;

  VerificandoUso := False;

  SetaStatusUso;
end;


procedure TFrmFichaPadrao.FormShow(Sender: TObject);
begin
  inherited;
  VerificaSeEstaSendoUsado;
end;

function TFrmFichaPadrao.GetDescritivoNavegacao: string;
var
  sTotal : integer;
begin
  Result := '';

  try
    sTotal := ExecutaComandoEscalar(TibDataSet(DSCadastro.DataSet).Database,
                                    ' Select count(1) '+
                                    ' From ('+
                                    TibDataSet(DSCadastro.DataSet).SelectSQL.Text+
                                    ' ) A');

    if DSCadastro.DataSet.State = dsInsert then
      Result := 'Ficha '+IntToStr(DSCadastro.DataSet.Recno)+' de '+IntToStr(sTotal + 1)
    else
      Result := 'Ficha '+IntToStr(DSCadastro.DataSet.Recno)+' de '+IntToStr(sTotal);

    //Mauricio Parizotto 2024-04-16
    if DSCadastro.DataSet.Recno > sTotal then
      Result := 'Ficha '+IntToStr(DSCadastro.DataSet.Recno)+' de '+IntToStr(DSCadastro.DataSet.Recno);
  except

  end;

end;

function TFrmFichaPadrao.FormularioAtivo(Form : TForm): boolean;
begin
  Result := Form.Active;
end;

procedure TFrmFichaPadrao.KeyPressPadrao(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar(GetPaginaAjuda)));
end;

procedure TFrmFichaPadrao.PadraoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  KeyPressPadrao(Sender, Key, Shift);
end;

end.
