unit ufrmInformacoesImportacaoNFe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons, uframeCampo, Data.DB,
  IBX.IBCustomDataSet, IBX.IBDatabase, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls,
  SMALL_DBEdit, IBX.IBQuery, Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TfrmInformacoesImportacaoNFe = class(TFrmPadrao)
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    fraPais: TfFrameCampo;
    ibdImportacao: TIBDataSet;
    imgFundoAviso: TImage;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label_01: TLabel;
    Label3: TLabel;
    fraUFDesembaraco: TfFrameCampo;
    dsImportacao: TDataSource;
    edtIdentificacaoDestinatario: TSMALL_DBEdit;
    imgInformacao: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtNumeroDI: TSMALL_DBEdit;
    edtLocalDesembaraco: TSMALL_DBEdit;
    edtCodExportador: TSMALL_DBEdit;
    edtAdicao: TSMALL_DBEdit;
    dtpDataRegistroDI: TDateTimePicker;
    dtpDataDesembaraco: TDateTimePicker;
    ibdImportacaoIDCOMPRASIMPORTACAO: TIntegerField;
    ibdImportacaoNUMERONF: TIBStringField;
    ibdImportacaoIDPAISES: TIntegerField;
    ibdImportacaoNUMRODI: TIBStringField;
    ibdImportacaoDATAREGISTRODI: TDateField;
    ibdImportacaoLOCALDESEMBARACO: TIBStringField;
    ibdImportacaoUFDESEMBARACO: TIBStringField;
    ibdImportacaoDATADESEMBARACO: TDateField;
    ibdImportacaoCODEXPORTADOR: TIBStringField;
    ibdImportacaoNUMADICAO: TIntegerField;
    ibdImportacaoIDENTESTRANGEIRO: TIBStringField;
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure KeyDownCampos(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FcNumeroNF: String;
    FbClicouOK: Boolean;
    procedure CarregaValoresObjeto;
    procedure AjustaLayout;
    procedure ConsultaInformacoes;
    function FazVerificacoes: Boolean;
    function getCodPais: String;
    function getIdentCompradorExterior: String;
    function getPais: String;
    function getUFDesembaraco: String;
    function getNumAdicao: string;
    function getCodExportador: string;
    function getDataDesembaraco: string;
    function getLocalDesembaraco: string;
    function getDataRegistroDI: string;
    function getNumRegistroDI: string;
  public
    //Input
    property NumeroNF: String read FcNumeroNF write FcNumeroNF;
    //Output
    property ClicouOK: Boolean read FbClicouOK;
    property Pais: String read getPais;
    property CodPais: String read getCodPais;
    property UFDesembaraco: String read getUFDesembaraco;
    property NumAdicao : string read getNumAdicao;
    property CodExportador : string read getCodExportador;
    property IdentCompradorExterior: String read getIdentCompradorExterior;
    property DataDesembaraco : string read getDataDesembaraco;
    property LocalDesembaraco : string read getLocalDesembaraco;
    property DataRegistroDI : string read getDataRegistroDI;
    property NumRegistroDI : string read getNumRegistroDI;
  end;

var
  frmInformacoesImportacaoNFe: TfrmInformacoesImportacaoNFe;

implementation

uses
  Unit7, smallfunc_xe, uSistema, uFuncoesBancoDados, uDialogs;

{$R *.dfm}

procedure TfrmInformacoesImportacaoNFe.btnCancelarClick(Sender: TObject);
begin
  inherited;
  ibdImportacao.Cancel;
  FbClicouOK := False;

  Self.Close;
end;

procedure TfrmInformacoesImportacaoNFe.btnOKClick(Sender: TObject);
begin
  ibdImportacaoDATAREGISTRODI.AsDateTime   := dtpDataRegistroDI.Date;
  ibdImportacaoDATADESEMBARACO.AsDateTime  := dtpDataDesembaraco.Date;

  if not FazVerificacoes then
    Exit;

  ibdImportacao.Post;
  FbClicouOK := True;

  Self.Close;
end;

function TfrmInformacoesImportacaoNFe.FazVerificacoes: Boolean;
begin
  Result := False;

  if (AllTrim(fraPais.txtCampo.Text) = EmptyStr) then
  begin
    MensagemSistema('Selecione o país de destino.',msgAtencao);
    fraPais.txtCampo.SetFocus;
    Exit;
  end;

  if (AllTrim(edtNumeroDI.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o número do documento de importação (DI/DSI/DA).',msgAtencao);
    edtNumeroDI.SetFocus;
    Exit;
  end;

  if (AllTrim(edtLocalDesembaraco.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o local de desembaraço.',msgAtencao);
    edtLocalDesembaraco.SetFocus;
    Exit;
  end;

  if (AllTrim(fraUFDesembaraco.txtCampo.Text) = EmptyStr) then
  begin
    MensagemSistema('Selecione a UF onde ocorreu o desembaraço aduaneiro.',msgAtencao);
    fraUFDesembaraco.txtCampo.SetFocus;
    Exit;
  end;

  if (AllTrim(edtCodExportador.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o código do exportador.',msgAtencao);
    edtCodExportador.SetFocus;
    Exit;
  end;

  if (AllTrim(edtAdicao.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o número da adição.',msgAtencao);
    edtAdicao.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmInformacoesImportacaoNFe.FormActivate(Sender: TObject);
begin
  Self.Height := Form7.Height;
  Self.Width  := Form7.Width;
  Self.Top    := Form7.Top;
  Self.Left   := Form7.Left;
end;

procedure TfrmInformacoesImportacaoNFe.FormShow(Sender: TObject);
begin
  inherited;
  FbClicouOK := False;
  AjustaLayout;

  ConsultaInformacoes;
  CarregaValoresObjeto;

  fraPais.txtCampo.SetFocus;
end;

procedure TfrmInformacoesImportacaoNFe.KeyDownCampos(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

function TfrmInformacoesImportacaoNFe.getCodExportador: string;
begin
  Result := ibdImportacaoCODEXPORTADOR.AsString;
end;


function TfrmInformacoesImportacaoNFe.getDataDesembaraco: string;
begin
  Result := FormatDateTime('yyyy-mm-dd',ibdImportacaoDATADESEMBARACO.AsDateTime);
end;

function TfrmInformacoesImportacaoNFe.getDataRegistroDI: string;
begin
  Result := FormatDateTime('yyyy-mm-dd',ibdImportacaoDATAREGISTRODI.AsDateTime);
end;

function TfrmInformacoesImportacaoNFe.getIdentCompradorExterior: String;
begin
  Result := ibdImportacaoIDENTESTRANGEIRO.AsString;
end;


function TfrmInformacoesImportacaoNFe.getLocalDesembaraco: string;
begin
  Result := ibdImportacaoLOCALDESEMBARACO.AsString;
end;

function TfrmInformacoesImportacaoNFe.getNumAdicao: string;
begin
  Result := ibdImportacaoNUMADICAO.AsString;
end;

function TfrmInformacoesImportacaoNFe.getNumRegistroDI: string;
begin
  Result := ibdImportacaoNUMRODI.AsString;
end;

function TfrmInformacoesImportacaoNFe.getPais: String;
begin
  Result := fraPais.txtCampo.Text;
end;

function TfrmInformacoesImportacaoNFe.getUFDesembaraco: String;
begin
  Result := fraUFDesembaraco.txtCampo.Text;
end;

procedure TfrmInformacoesImportacaoNFe.ConsultaInformacoes;
var
  qryPais: TIbquery;
begin
  ibdImportacao.Close;
  ibdImportacao.ParamByName('NUMERONF').AsString := FcNumeroNF;
  ibdImportacao.Open;

  if ibdImportacao.IsEmpty then
  begin
    ibdImportacao.Append;
    ibdImportacaoIDCOMPRASIMPORTACAO.AsString := IncGenerator(ibdImportacao.Database,'G_COMPRASIMPORTACAO');
    ibdImportacaoNUMERONF.AsString            := FcNumeroNF;
    ibdImportacaoUFDESEMBARACO.AsString       := Form7.ibDataSet13ESTADO.AsString;
    ibdImportacaoDATADESEMBARACO.AsDateTime   := Now;
    ibdImportacaoDATAREGISTRODI.AsDateTime    := Now;
  end else
    ibdImportacao.Edit;
end;

procedure TfrmInformacoesImportacaoNFe.AjustaLayout;
var
  cImgFundo: String;
begin
  cImgFundo := ExtractFilePath(Application.ExeName) + ImagemFundoSmall(TSistema.GetInstance.Tema,'13');

  if FileExists(cImgFundo) then
    imgFundoAviso.Picture.LoadFromFile(cImgFundo) ;
end;

procedure TfrmInformacoesImportacaoNFe.CarregaValoresObjeto;
begin
  dtpDataRegistroDI.Date  := ibdImportacaoDATAREGISTRODI.AsDateTime;
  dtpDataDesembaraco.Date := ibdImportacaoDATADESEMBARACO.AsDateTime;


  // País
  fraPais.TipoDePesquisa               := tpLocate;
  fraPais.GravarSomenteTextoEncontrato := True;
  fraPais.CampoVazioAbrirGridPesquisa  := False;
  fraPais.CampoCodigo                  := ibdImportacaoIDPAISES;
  fraPais.CampoCodigoPesquisa          := 'IDPAISES';
  fraPais.sCampoDescricao              := 'NOME';
  fraPais.sTabela                      := 'PAISES';
  fraPais.CarregaDescricao;

  // UF Embarque
  fraUFDesembaraco.TipoDePesquisa               := tpLocate;
  fraUFDesembaraco.GravarSomenteTextoEncontrato := True;
  fraUFDesembaraco.CampoVazioAbrirGridPesquisa  := True;
  fraUFDesembaraco.CampoCodigo                  := ibdImportacaoUFDESEMBARACO;
  fraUFDesembaraco.CampoCodigoPesquisa          := 'UF';
  fraUFDesembaraco.sCampoDescricao              := 'UF';
  fraUFDesembaraco.sTabela                      := ' (Select UF'+
                                                ' From MUNICIPIOS'+
                                                ' Group By UF)';
  fraUFDesembaraco.CarregaDescricao;
end;

function TfrmInformacoesImportacaoNFe.getCodPais: String;
begin
  Result := '';

  try
    Result := ExecutaComandoEscalar(ibdImportacao.Transaction,
                                    ' Select CODIGO'+
                                    ' From PAISES '+
                                    ' Where IDPAISES ='+ibdImportacaoIDPAISES.AsString);
  except
  end;
end;

end.
