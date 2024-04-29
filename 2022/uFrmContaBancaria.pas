unit uFrmContaBancaria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmContaBancaria = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtNome: TSMALL_DBEdit;
    Label1: TLabel;
    edtAgencia: TSMALL_DBEdit;
    Label2: TLabel;
    edtContaCorrente: TSMALL_DBEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtSaldo: TSMALL_DBEdit;
    Label5: TLabel;
    fraPlanoContas: TfFrameCampo;
    fraInstituicao: TfFrameCampo;
    tbsPIX: TTabSheet;
    Label6: TLabel;
    chkPisCofinsSobLucro: TDBCheckBox;
    Label7: TLabel;
    SMALL_DBEdit2: TSMALL_DBEdit;
    Label8: TLabel;
    SMALL_DBEdit3: TSMALL_DBEdit;
    cbMovimentacaoEstoque: TComboBox;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure AtualizaObjComValorDoBanco;
  public
    { Public declarations }
  end;

var
  FrmContaBancaria: TFrmContaBancaria;

implementation

{$R *.dfm}

uses unit7, uSmallConsts;

{ TFrmContaBancaria }

procedure TFrmContaBancaria.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmContaBancaria.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmContaBancaria.FormCreate(Sender: TObject);
begin
  inherited;

  pgcFicha.ActivePage := tbsCadastro;
end;

procedure TFrmContaBancaria.FormShow(Sender: TObject);
begin
  inherited;

  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

function TFrmContaBancaria.GetPaginaAjuda: string;
begin
  Result := 'bancos.htm';
end;

procedure TFrmContaBancaria.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmContaBancaria.SetaStatusUso;
begin
  inherited;

  edtNome.Enabled           := not(bEstaSendoUsado);
  edtAgencia.Enabled        := not(bEstaSendoUsado);
  edtContaCorrente.Enabled  := not(bEstaSendoUsado);
  fraPlanoContas.Enabled    := not(bEstaSendoUsado);
  edtSaldo.Enabled          := not(bEstaSendoUsado);
  fraInstituicao.Enabled    := not(bEstaSendoUsado);
end;


procedure TFrmContaBancaria.AtualizaObjComValorDoBanco;
begin
  try
    fraPlanoContas.TipoDePesquisa               := tpSelect;
    fraPlanoContas.GravarSomenteTextoEncontrato := True;
    fraPlanoContas.CampoCodigo                  := Form7.ibDataSet11PLANO;
    fraPlanoContas.CampoCodigoPesquisa          := 'CONTA';
    fraPlanoContas.sCampoDescricao              := 'NOME';
    fraPlanoContas.sTabela                      := 'CONTAS';
    fraPlanoContas.CarregaDescricaoCodigo;

    fraInstituicao.TipoDePesquisa               := tpSelect;
    fraInstituicao.GravarSomenteTextoEncontrato := True;
    fraInstituicao.CampoCodigo                  := Form7.ibDataSet11INSTITUICAOFINANCEIRA;
    fraInstituicao.CampoCodigoPesquisa          := 'NOME';
    fraInstituicao.sCampoDescricao              := 'NOME';
    fraInstituicao.sTabela                      := 'CLIFOR';
    fraInstituicao.sFiltro                      := ' and CLIFOR = '+QuotedStr(_RelComInstituicao);
    fraInstituicao.CarregaDescricao;
  except
  end;
end;


end.
