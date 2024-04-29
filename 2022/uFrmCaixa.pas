unit uFrmCaixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmCaixa = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtData: TSMALL_DBEdit;
    Label1: TLabel;
    edtHistorico: TSMALL_DBEdit;
    Label2: TLabel;
    edtEntrada: TSMALL_DBEdit;
    Label3: TLabel;
    edtSaida: TSMALL_DBEdit;
    Label4: TLabel;
    edtSaldo: TSMALL_DBEdit;
    Label5: TLabel;
    fraPlanoContas: TfFrameCampo;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure AtualizaObjComValorDoBanco;
  public
    { Public declarations }
  end;

var
  FrmCaixa: TFrmCaixa;

implementation

{$R *.dfm}

uses unit7;

{ TFrmCaixa }

procedure TFrmCaixa.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmCaixa.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmCaixa.FormShow(Sender: TObject);
begin
  inherited;

  if edtData.CanFocus then
    edtData.SetFocus;
end;

function TFrmCaixa.GetPaginaAjuda: string;
begin
  Result := 'livro.htm';
end;

procedure TFrmCaixa.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmCaixa.SetaStatusUso;
begin
  inherited;

  edtData.Enabled          := not(bEstaSendoUsado);
  fraPlanoContas.Enabled   := not(bEstaSendoUsado);
  edtHistorico.Enabled     := not(bEstaSendoUsado);
  edtEntrada.Enabled       := not(bEstaSendoUsado);
  edtSaida.Enabled         := not(bEstaSendoUsado);
  edtSaldo.Enabled         := not(bEstaSendoUsado);
end;


procedure TFrmCaixa.AtualizaObjComValorDoBanco;
begin
  try
    fraPlanoContas.TipoDePesquisa  := tpSelect;
    fraPlanoContas.GravarSomenteTextoEncontrato := False;
    fraPlanoContas.CampoCodigo     := Form7.ibDataSet1NOME;
    fraPlanoContas.CampoCodigoPesquisa := 'NOME';
    fraPlanoContas.sCampoDescricao := 'NOME';
    fraPlanoContas.sTabela         := 'CONTAS';
    fraPlanoContas.CampoAuxExiber  := ',CONTA';
    fraPlanoContas.CarregaDescricao;
  except
  end;
end;

end.
