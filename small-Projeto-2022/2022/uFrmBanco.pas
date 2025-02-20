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

uses unit7;

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

  edtEmissao.Enabled      := not(bEstaSendoUsado);
  edtDocumento.Enabled    := not(bEstaSendoUsado);
  edtHistorico.Enabled    := not(bEstaSendoUsado);
  edtEntrada.Enabled      := not(bEstaSendoUsado);
  edtSaida.Enabled        := not(bEstaSendoUsado);
  edtPreDatado.Enabled    := not(bEstaSendoUsado);
  edtCompensado.Enabled   := not(bEstaSendoUsado);
  edtSaldo.Enabled        := not(bEstaSendoUsado);
  edtNominal.Enabled      := not(bEstaSendoUsado);
end;

end.
