unit ufrmInformacoesExportacaoNFe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons, uframeCampo, Data.DB,
  IBX.IBCustomDataSet, IBX.IBDatabase, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls,
  SMALL_DBEdit, IBX.IBQuery, Vcl.Imaging.pngimage;

type
  TfrmInformacoesExportacaoNFe = class(TFrmPadrao)
    btnOK: TBitBtn;
    btnCancelar: TBitBtn;
    fraPais: TfFrameCampo;
    ibVENDASExportacao: TIBDataSet;
    btnDrawback: TBitBtn;
    ibVENDASExportacaoIDVENDASEXPORTACAO: TIntegerField;
    ibVENDASExportacaoIDPAISES: TIntegerField;
    ibVENDASExportacaoUFEMBARQUE: TIBStringField;
    ibVENDASExportacaoLOCALEMBARQUE: TIBStringField;
    ibVENDASExportacaoRECINTOALFANDEGARIO: TIBStringField;
    ibVENDASExportacaoIDENTESTRANGEIRO: TIBStringField;
    ibVENDASExportacaoNUMERONF: TIBStringField;
    imgFundoAviso: TImage;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label_01: TLabel;
    Label3: TLabel;
    fraUFEmbarque: TfFrameCampo;
    dsVendasExportacao: TDataSource;
    edtRecintoAlfandegado: TSMALL_DBEdit;
    edtLocalEmbarque: TSMALL_DBEdit;
    edtIdentificacaoDestinatario: TSMALL_DBEdit;
    imgInformacao: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnDrawbackClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure ibVENDASExportacaoBeforePost(DataSet: TDataSet);
    procedure KeyDownCampos(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FcNumeroNF: String;
    FoTransaction: TIBTransaction;
    FbClicouOK: Boolean;
    procedure setTransaction(const Value: TIBTransaction);
    procedure ConfiguraFrames;
    procedure AjustaLayout;
    procedure ConsultaInformacoesExportação;
    function FazVerificacoes: Boolean;
    function getCodPais: String;
    function getIdentCompradorExterior: String;
    function getLocalDespacho: String;
    function getLocalEmbarque: String;
    function getPais: String;
    function getUFEmbarq: String;
  public
    //Input
    property Transaction: TIBTransaction read FoTransaction write setTransaction;
    property NumeroNF: String read FcNumeroNF write FcNumeroNF;
    //Output
    property ClicouOK: Boolean read FbClicouOK;
    property Pais: String read getPais;
    property CodPais: String read getCodPais;
    property UFEmbarq: String read getUFEmbarq;
    property LocalEmbarque: String read getLocalEmbarque;
    property LocalDespacho: String read getLocalDespacho;
    property IdentCompradorExterior: String read getIdentCompradorExterior;
  end;

var
  frmInformacoesExportacaoNFe: TfrmInformacoesExportacaoNFe;

implementation

uses
  ufrmInformarDrawback, Unit7, smallfunc_xe, uSistema, uFuncoesBancoDados,
  uDialogs;

{$R *.dfm}

procedure TfrmInformacoesExportacaoNFe.btnCancelarClick(Sender: TObject);
begin
  inherited;
  ibVENDASExportacao.Cancel;
  FbClicouOK := False;

  Self.Close;
end;

procedure TfrmInformacoesExportacaoNFe.btnDrawbackClick(Sender: TObject);
begin
  frmInformarDrawback := TfrmInformarDrawback.Create(nil);
  try
    frmInformarDrawback.ColorGrid := Form7.Panel7.Color;
    frmInformarDrawback.DataSet   := Form7.ibDataSet16;
    frmInformarDrawback.ShowModal;
  finally
    FreeAndNil(frmInformarDrawback);
  end;
end;

procedure TfrmInformacoesExportacaoNFe.btnOKClick(Sender: TObject);
begin
  if not FazVerificacoes then
    Exit;

  ibVENDASExportacao.Post;
  FbClicouOK := True;

  Self.Close;
end;

function TfrmInformacoesExportacaoNFe.FazVerificacoes: Boolean;
begin
  Result := False;

  if (AllTrim(fraPais.txtCampo.Text) = EmptyStr) then
  begin
    MensagemSistema('Selecione o país de destino.');
    fraPais.txtCampo.SetFocus;
    Exit;
  end;
  if (AllTrim(fraUFEmbarque.txtCampo.Text) = EmptyStr) then
  begin
    MensagemSistema('Selecione a UF de embarque.');
    fraUFEmbarque.txtCampo.SetFocus;
    Exit;
  end;
  if (AllTrim(edtLocalEmbarque.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o local do embarque.');
    edtLocalEmbarque.SetFocus;
    Exit;
  end;
  if (AllTrim(edtRecintoAlfandegado.Text) = EmptyStr) then
  begin
    MensagemSistema('Informe o recinto alfandegado.');
    edtRecintoAlfandegado.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmInformacoesExportacaoNFe.FormActivate(Sender: TObject);
begin
  Self.Height := Form7.Height;
  Self.Width  := Form7.Width;
  Self.Top    := Form7.Top;
  Self.Left   := Form7.Left;
end;

procedure TfrmInformacoesExportacaoNFe.FormShow(Sender: TObject);
begin
  inherited;
  FbClicouOK := False;
  AjustaLayout;

  ConsultaInformacoesExportação;
  ConfiguraFrames;

  fraPais.txtCampo.SetFocus;
end;

procedure TfrmInformacoesExportacaoNFe.KeyDownCampos(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
end;

function TfrmInformacoesExportacaoNFe.getCodPais: String;
var
  qryPais: TIbquery;
begin
  qryPais := CriaIBQuery(FoTransaction);
  try
    qryPais.Close;
    qryPais.SQL.Clear;
    qryPais.SQL.Add('select CODIGO from PAISES where (NOME=:XNOME) order by NOME');
    qryPais.ParamByName('XNOME').AsString := fraPais.txtCampo.Text;
    qryPais.Open;

    Result := EmptyStr;
    if not qryPais.IsEmpty then
     Result := qryPais.FieldByName('CODIGO').AsString;
  finally
    FreeAndNil(qryPais);
  end;
end;

function TfrmInformacoesExportacaoNFe.getIdentCompradorExterior: String;
begin
  Result := edtIdentificacaoDestinatario.Text;
end;

function TfrmInformacoesExportacaoNFe.getLocalDespacho: String;
begin
  Result := edtRecintoAlfandegado.Text;
end;

function TfrmInformacoesExportacaoNFe.getLocalEmbarque: String;
begin
  Result := edtLocalEmbarque.Text;
end;

function TfrmInformacoesExportacaoNFe.getPais: String;
begin
  Result := fraPais.txtCampo.Text;
end;

function TfrmInformacoesExportacaoNFe.getUFEmbarq: String;
begin
  Result := fraUFEmbarque.txtCampo.Text;
end;

procedure TfrmInformacoesExportacaoNFe.ibVENDASExportacaoBeforePost(DataSet: TDataSet);
var
  qryGenerator: TIbquery;
begin
  if ibVENDASExportacaoIDVENDASEXPORTACAO.AsInteger <= 0 then
  begin
    qryGenerator := CriaIBQuery(FoTransaction);
    try
      qryGenerator.Close;
      qryGenerator.Sql.Clear;
      qryGenerator.Sql.Add('select gen_id(G_VENDASEXPORTACAO,1) AS ID from rdb$database');
      qryGenerator.Open;

      ibVENDASExportacaoIDVENDASEXPORTACAO.AsInteger := qryGenerator.FieldByName('ID').AsInteger;
    finally
      FreeAndNil(qryGenerator)
    end;
  end;
end;

procedure TfrmInformacoesExportacaoNFe.ConsultaInformacoesExportação;
var
  qryPais: TIbquery;
begin
  ibVENDASExportacao.Close;
  ibVENDASExportacao.ParamByName('NUMERONF').AsString := FcNumeroNF;
  ibVENDASExportacao.Open;

  if ibVENDASExportacao.IsEmpty then
  begin
    ibVENDASExportacao.Append;
    ibVENDASExportacaoNUMERONF.AsString   := FcNumeroNF;
    ibVENDASExportacaoUFEMBARQUE.AsString := Form7.ibDataSet13ESTADO.AsString;

    qryPais := CriaIBQuery(FoTransaction);
    try
      qryPais.Close;
      qryPais.SQL.Clear;
      qryPais.SQL.Add('select IDPAISES from PAISES where (NOME=:XNOME) order by NOME');
      qryPais.ParamByName('XNOME').AsString := 'ESTADOS UNIDOS';
      qryPais.Open;

      ibVENDASExportacaoIDPAISES.AsString     := qryPais.FieldByName('IDPAISES').AsString;
    finally
      FreeAndNil(qryPais)
    end;
  end else
    ibVENDASExportacao.Edit;
end;

procedure TfrmInformacoesExportacaoNFe.AjustaLayout;
var
  cImgFundo: String;
begin
  cImgFundo := ExtractFilePath(Application.ExeName) + ImagemFundoSmall(TSistema.GetInstance.Tema,'13');

  if FileExists(cImgFundo) then
    imgFundoAviso.Picture.LoadFromFile(cImgFundo) ;

  edtRecintoAlfandegado.Font := fraPais.txtCampo.Font;
  edtLocalEmbarque.Font := fraPais.txtCampo.Font;
  edtIdentificacaoDestinatario.Font := fraPais.txtCampo.Font;
end;

procedure TfrmInformacoesExportacaoNFe.ConfiguraFrames;
begin
  // País
  fraPais.TipoDePesquisa               := tpLocate;
  fraPais.GravarSomenteTextoEncontrato := True;
  fraPais.CampoVazioAbrirGridPesquisa  := True;
  fraPais.CampoCodigo                  := ibVENDASExportacaoIDPAISES;
  fraPais.CampoCodigoPesquisa          := 'IDPAISES';
  fraPais.sCampoDescricao              := 'NOME';
  fraPais.sTabela                      := 'PAISES';
  fraPais.CarregaDescricao;
  // UF Embarque
  fraUFEmbarque.TipoDePesquisa               := tpSelect;
  fraUFEmbarque.GravarSomenteTextoEncontrato := True;
  fraUFEmbarque.CampoVazioAbrirGridPesquisa  := True;
  fraUFEmbarque.CampoCodigo                  := ibVENDASExportacaoUFEMBARQUE;
  fraUFEmbarque.CampoCodigoPesquisa          := 'UF';
  fraUFEmbarque.sCampoDescricao              := 'UF';
  fraUFEmbarque.sTabela                      := 'MUNICIPIOS';
  fraUFEmbarque.CarregaDescricao;
  // Se não aumentar corta a UF
  fraUFEmbarque.gdRegistros.Columns[0].Width := fraUFEmbarque.gdRegistros.Columns[0].Width + 8;
end;

procedure TfrmInformacoesExportacaoNFe.setTransaction(
  const Value: TIBTransaction);
begin
  FoTransaction := Value;

  ibVENDASExportacao.Transaction := FoTransaction;
end;

end.
