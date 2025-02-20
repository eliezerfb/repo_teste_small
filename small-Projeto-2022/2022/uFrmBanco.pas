unit uFrmBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit;

type
  TFrmBanco = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    Label129: TLabel;
    edtEmissao: TSMALL_DBEdit;
    edtDocumento: TSMALL_DBEdit;
    Label1: TLabel;
    edtHistorico: TSMALL_DBEdit;
    Label2: TLabel;
    edtEntrada: TSMALL_DBEdit;
    Label3: TLabel;
    edtSaida: TSMALL_DBEdit;
    Label4: TLabel;
    edtPreDatado: TSMALL_DBEdit;
    Label5: TLabel;
    edtCompensado: TSMALL_DBEdit;
    Label6: TLabel;
    edtSaldo: TSMALL_DBEdit;
    Label7: TLabel;
    edtNominal: TSMALL_DBEdit;
    Label8: TLabel;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
  public
    { Public declarations }
  end;

var
  FrmBanco: TFrmBanco;

implementation

{$R *.dfm}

uses
  unit7
  , uPermissaoUsuario
  , MAIS;

{ TFrmBanco }

procedure TFrmBanco.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmBanco.FormShow(Sender: TObject);
begin
  inherited;

  if edtEmissao.CanFocus then
    edtEmissao.SetFocus;
end;

function TFrmBanco.GetPaginaAjuda: string;
begin
  Result := 'bancos.htm';
end;

procedure TFrmBanco.lblNovoClick(Sender: TObject);
begin
  inherited;

  //Contador
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmBanco.SetaStatusUso;
begin
  inherited;

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtEmissao.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtDocumento.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtHistorico.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtEntrada.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtSaida.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtPreDatado.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtCompensado.Enabled   := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtSaldo.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtNominal.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
end;

end.
