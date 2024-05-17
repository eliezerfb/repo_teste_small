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
    chkPixEstatico: TDBCheckBox;
    Label7: TLabel;
    edtChavePix: TSMALL_DBEdit;
    Label8: TLabel;
    SMALL_DBEdit3: TSMALL_DBEdit;
    cboTipoChave: TDBComboBox;
    procedure DSCadastroDataChange(Sender: TObject; Field: TField);
    procedure lblNovoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cboTipoChaveChange(Sender: TObject);
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

uses unit7
	, uSmallConsts
	, uDialogs
	, uPermissaoUsuario
	, MAIS;

{ TFrmContaBancaria }

procedure TFrmContaBancaria.btnOKClick(Sender: TObject);
begin
  //Mauricio Parizotto 2024-05-06
  if chkPixEstatico.Checked then
  begin
    if Trim(Form7.ibDataSet11PIXTIPOCHAVE.AsString) = '' then
    begin
      MensagemSistema('O campo Tipo chave deve ser preenchido!',msgAtencao);
      cboTipoChave.SetFocus;
      Exit;
    end;

    if Trim(Form7.ibDataSet11PIXCHAVE.AsString) = '' then
    begin
      MensagemSistema('O campo Chave PIX deve ser preenchido!',msgAtencao);
      edtChavePix.SetFocus;
      Exit;
    end;

    if (cboTipoChave.ItemIndex = 1) and (copy(DSCadastro.DataSet.FieldByName('PIXCHAVE').AsString,1,3) <> '+55') then
    begin
      if not (DSCadastro.DataSet.State in ([dsEdit, dsInsert])) then
        DSCadastro.DataSet.Edit;

      DSCadastro.DataSet.FieldByName('PIXCHAVE').AsString := '+55'+DSCadastro.DataSet.FieldByName('PIXCHAVE').AsString;
    end;
  end;

  inherited;
end;

procedure TFrmContaBancaria.cboTipoChaveChange(Sender: TObject);
begin
  if cboTipoChave.ItemIndex = 1 then
  begin
    if trim(DSCadastro.DataSet.FieldByName('PIXCHAVE').AsString ) = '' then
      DSCadastro.DataSet.FieldByName('PIXCHAVE').AsString := '+55';
  end;
end;

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

  bSomenteLeitura := SomenteLeitura(Form7.sModulo,MAIS.Usuario);

  edtNome.Enabled           := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtAgencia.Enabled        := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtContaCorrente.Enabled  := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraPlanoContas.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtSaldo.Enabled          := not(bEstaSendoUsado) and not (bSomenteLeitura);
  fraInstituicao.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);

  chkPixEstatico.Enabled    := not(bEstaSendoUsado) and not (bSomenteLeitura);
  cboTipoChave.Enabled      := not(bEstaSendoUsado) and not (bSomenteLeitura);
  edtChavePix.Enabled       := not(bEstaSendoUsado) and not (bSomenteLeitura);
  SMALL_DBEdit3.Enabled     := not(bEstaSendoUsado) and not (bSomenteLeitura);
end;


procedure TFrmContaBancaria.AtualizaObjComValorDoBanco;
begin
  try
    //Plano de contas
    fraPlanoContas.TipoDePesquisa               := tpSelect;
    fraPlanoContas.GravarSomenteTextoEncontrato := True;
    fraPlanoContas.CampoCodigo                  := Form7.ibDataSet11PLANO;
    fraPlanoContas.CampoCodigoPesquisa          := 'CONTA';
    fraPlanoContas.sCampoDescricao              := 'NOME';
    fraPlanoContas.sTabela                      := 'CONTAS';
    fraPlanoContas.CarregaDescricaoCodigo;

    //Instituição Financeira
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
