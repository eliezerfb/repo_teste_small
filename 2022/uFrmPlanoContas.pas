unit uFrmPlanoContas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmFichaPadrao, Data.DB, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, SMALL_DBEdit,
  IBX.IBCustomDataSet;

type
  TFrmPlanoContas = class(TFrmFichaPadrao)
    tbsCadastro: TTabSheet;
    LabelNroConta: TLabel;
    edtNroConta: TSMALL_DBEdit;
    edtNomeConta: TSMALL_DBEdit;
    Label1: TLabel;
    edtDia: TSMALL_DBEdit;
    Label2: TLabel;
    edtMes: TSMALL_DBEdit;
    Label3: TLabel;
    edtAno: TSMALL_DBEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtSaldo: TSMALL_DBEdit;
    Label6: TLabel;
    edtDescContabil: TSMALL_DBEdit;
    Label7: TLabel;
    edtCodContabil: TSMALL_DBEdit;
    Label8: TLabel;
    edtIdentificador: TSMALL_DBEdit;
    cbxTipoConta: TComboBox;
    LabelTipoConta: TLabel;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxTipoContaClick(Sender: TObject);
    procedure edtNroContaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNroContaEnter(Sender: TObject);
  private
    { Private declarations }
    procedure SetaStatusUso; override;
    function GetPaginaAjuda:string; override;
    procedure SetTipoConta();
  public
    { Public declarations }
  end;

var
  FrmPlanoContas: TFrmPlanoContas;

implementation

{$R *.dfm}

uses
  unit7, uFuncoesRetaguarda;

{ TFrmPlanoContas }

procedure TFrmPlanoContas.cbxTipoContaClick(Sender: TObject);
begin
  inherited;
  var PrefixoConta := TTipoPlanoConta(cbxTipoConta.ItemIndex);

  if (PrefixoConta = CodigoPlanoContaToTipo(edtNroConta.Text)) or
    (PrefixoConta = tpcNenhum) then
    Exit;

  var NroConta := edtNroConta.Text;
  Delete(NroConta, 1, 1);

  if not(DSCadastro.DataSet.State in [dsEdit, dsInsert]) then
    DSCadastro.DataSet.Edit;

  DSCadastro.DataSet.FieldByName('conta').AsString :=
    TipoPlanoContaToStr(PrefixoConta)+NroConta;

  edtNroConta.SetFocus();
end;


procedure TFrmPlanoContas.DSCadastroDataChange(Sender: TObject; Field: TField);
begin
  inherited;

  if DSCadastro.DataSet.State in ([dsEdit, dsInsert]) then
    Exit;

  tbsCadastro.Caption := GetDescritivoNavegacao;

  SetTipoConta();
end;

procedure TFrmPlanoContas.edtNroContaEnter(Sender: TObject);
begin
  inherited;
  if Length(edtNroConta.Text) = 1 then
    edtNroConta.SelStart := Length(edtNroConta.Text);
end;

procedure TFrmPlanoContas.edtNroContaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  SetTipoConta();
end;

procedure TFrmPlanoContas.FormCreate(Sender: TObject);
begin
  inherited;
  for var t := Low(TTipoPlanoConta) to High(TTipoPlanoConta) do
    cbxTipoConta.Items.Add(TipoPlanoContaToText(t));
end;

procedure TFrmPlanoContas.FormShow(Sender: TObject);
begin
  inherited;

  if cbxTipoConta.CanFocus then
    cbxTipoConta.SetFocus;
end;

function TFrmPlanoContas.GetPaginaAjuda: string;
begin
  Result := 'config_plano_contas.htm';
end;

procedure TFrmPlanoContas.lblNovoClick(Sender: TObject);
begin
  inherited;
  tbsCadastro.Caption := GetDescritivoNavegacao;
end;

procedure TFrmPlanoContas.SetaStatusUso;
begin
  inherited;

  cbxTipoConta.Enabled := not(bEstaSendoUsado);
  edtNroConta.Enabled := not(bEstaSendoUsado);
  edtNomeConta.Enabled     := not(bEstaSendoUsado);
  edtDia.Enabled           := not(bEstaSendoUsado);
  edtMes.Enabled           := not(bEstaSendoUsado);
  edtAno.Enabled           := not(bEstaSendoUsado);
  edtSaldo.Enabled         := not(bEstaSendoUsado);
  edtDescContabil.Enabled  := not(bEstaSendoUsado);
  edtCodContabil.Enabled   := not(bEstaSendoUsado);
  edtIdentificador.Enabled := not(bEstaSendoUsado);
end;


procedure TFrmPlanoContas.SetTipoConta;
begin
  cbxTipoConta.ItemIndex := cbxTipoConta.Items.IndexOf(
    TipoPlanoContaToText(CodigoPlanoContaToTipo(edtNroConta.Text))
  );
end;

end.
