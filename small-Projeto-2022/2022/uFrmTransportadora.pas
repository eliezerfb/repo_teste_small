unit uFrmTransportadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  uframeCampo;

type
  TFrmTransportadora = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtCNPJ: TSMALL_DBEdit;
    Label1: TLabel;
    edtNome: TSMALL_DBEdit;
    Label2: TLabel;
    edtEndereco: TSMALL_DBEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtIE: TSMALL_DBEdit;
    Label5: TLabel;
    edtTelefone: TSMALL_DBEdit;
    Label6: TLabel;
    edtEmail: TSMALL_DBEdit;
    Label7: TLabel;
    edtPlacaVeiculo: TSMALL_DBEdit;
    Label8: TLabel;
    edtANTT: TSMALL_DBEdit;
    Label9: TLabel;
    edtUF: TSMALL_DBEdit;
    Label10: TLabel;
    edtUFVeiculo: TSMALL_DBEdit;
    fraMunicipio: TfFrameCampo;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtUFExit(Sender: TObject);
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
  FrmTransportadora: TFrmTransportadora;

implementation

{$R *.dfm}

uses unit7;

{ TFrmTransportadora }

procedure TFrmTransportadora.DSCadastroDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmTransportadora.FormActivate(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmTransportadora.FormShow(Sender: TObject);
begin
  inherited;

  if edtCNPJ.CanFocus then
    edtCNPJ.SetFocus;
end;

function TFrmTransportadora.GetPaginaAjuda: string;
begin
  Result := 'config_transportadora.htm';
end;

procedure TFrmTransportadora.lblNovoClick(Sender: TObject);
begin
  inherited;

  AtualizaObjComValorDoBanco;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmTransportadora.SetaStatusUso;
begin
  inherited;

  edtCNPJ.Enabled         := not(bEstaSendoUsado);
  edtNome.Enabled         := not(bEstaSendoUsado);
  edtEndereco.Enabled     := not(bEstaSendoUsado);
  fraMunicipio.Enabled    := not(bEstaSendoUsado);
  edtUF.Enabled           := not(bEstaSendoUsado);
  edtIE.Enabled           := not(bEstaSendoUsado);
  edtTelefone.Enabled     := not(bEstaSendoUsado);
  edtEmail.Enabled        := not(bEstaSendoUsado);
  edtPlacaVeiculo.Enabled := not(bEstaSendoUsado);
  edtANTT.Enabled         := not(bEstaSendoUsado);
end;

procedure TFrmTransportadora.edtUFExit(Sender: TObject);
begin
  inherited;
  AtualizaObjComValorDoBanco;
end;

procedure TFrmTransportadora.AtualizaObjComValorDoBanco;
begin
  try
    fraMunicipio.TipoDePesquisa  := tpSelect;
    fraMunicipio.GravarSomenteTextoEncontrato := True;
    fraMunicipio.CampoCodigo     := Form7.ibDataSet18MUNICIPIO;
    fraMunicipio.CampoCodigoPesquisa := 'NOME';
    fraMunicipio.sCampoDescricao := 'NOME';
    fraMunicipio.sTabela         := 'MUNICIPIOS';
    if Trim(Form7.ibDataSet18UF.AsString) <> '' then
      fraMunicipio.sFiltro       := ' and UF = '+QuotedStr(Form7.ibDataSet18UF.AsString);
    fraMunicipio.CarregaDescricao;
  except
  end;
end;

end.
