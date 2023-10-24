unit uFrmConfigEmailAutContabilidade;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmPadrao, StdCtrls, uArquivosDat, SmallFunc, Buttons, ExtCtrls;

type
  TfrmConfigEmailAutContab = class(TFrmPadrao)
    edtEmailContab: TEdit;
    Label4: TLabel;
    cbAtivarEnvio: TCheckBox;
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    Image1: TImage;
    gbDocumentos: TGroupBox;
    cbNFeSaida: TCheckBox;
    cbNFeEntrada: TCheckBox;
    cbNFCeSAT: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FoArqDat: TArquivosDAT;
    procedure CarregaINI;
    procedure SalvarINI;
    procedure EnviarXMLs;
    function FazVerificacoes: Boolean;
  public
    procedure SetImagem(AoImagem: TPicture);
  end;

var
  frmConfigEmailAutContab: TfrmConfigEmailAutContab;

implementation

uses uSmallConsts, uSmallResourceString, uExportaXML, DateUtils;

{$R *.dfm}

procedure TfrmConfigEmailAutContab.FormCreate(Sender: TObject);
begin
  inherited;
  FoArqDat := TArquivosDAT.Create(EmptyStr);
end;

procedure TfrmConfigEmailAutContab.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FoArqDat);
  inherited;
end;

procedure TfrmConfigEmailAutContab.CarregaINI;
begin
  cbAtivarEnvio.Checked := FoArqDat.NFe.XML.EnvioAutomatico;
  cbNFeSaida.Checked    := FoArqDat.NFe.XML.NFeSaida;
  cbNFeEntrada.Checked  := FoArqDat.NFe.XML.NFeEntrada;
  cbNFCeSAT.Checked     := FoArqDat.NFe.XML.NFCe;
  edtEmailContab.Text   := FoArqDat.NFe.XML.EmailContabilidade;
end;

procedure TfrmConfigEmailAutContab.FormActivate(Sender: TObject);
begin
  inherited;
  CarregaINI;
end;

procedure TfrmConfigEmailAutContab.SalvarINI;
begin
  FoArqDat.NFe.XML.EnvioAutomatico    := cbAtivarEnvio.Checked;
  FoArqDat.NFe.XML.NFeSaida           := cbNFeSaida.Checked;
  FoArqDat.NFe.XML.NFeEntrada         := cbNFeEntrada.Checked;
  FoArqDat.NFe.XML.NFCe               := cbNFCeSAT.Checked;
  FoArqDat.NFe.XML.EmailContabilidade := edtEmailContab.Text;
end;

function TfrmConfigEmailAutContab.FazVerificacoes: Boolean;
begin
  Result := False;

  if cbAtivarEnvio.Checked then
  begin
    if (not cbNFeSaida.Checked) and (not cbNFeEntrada.Checked) and (not cbNFCeSAT.Checked) then
    begin
      Application.MessageBox(PChar(_cSelecioneTipoDocEmailXMLConf), Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
      cbNFeSaida.SetFocus;
      Exit;
    end;
    if Trim(edtEmailContab.Text) = EmptyStr then
    begin
      Application.MessageBox(PChar(_cInformeEmailContab), Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
      edtEmailContab.SetFocus;
      Exit;
    end;
  end;

  if Trim(edtEmailContab.Text) <> EmptyStr then
  begin
    if not ValidaEmail(edtEmailContab.Text) then
    begin
      Application.MessageBox(PChar(_cEmailInvalido), Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
      edtEmailContab.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

procedure TfrmConfigEmailAutContab.EnviarXMLs;
begin
  // Já estava ativado, portanto não pede pra enviar
  if FoArqDat.NFe.XML.EnvioAutomatico then
    Exit;
  // Se não está ativado não solicita para enviar
  if not cbAtivarEnvio.Checked then
    Exit;

  if (MonthOf(FoArqDat.NFe.XML.DataUltimoEnvio) = MonthOf(Date))
     and (YearOf(FoArqDat.NFe.XML.DataUltimoEnvio) = YearOf(Date)) then
    Exit;

  if Application.MessageBox(PChar(_cEnviarXMLMesAnterior), Pchar(_cTituloMsg), MB_YESNO + MB_ICONQUESTION) = mrYes then
  begin
    frmExportaXML := TfrmExportaXML.Create(nil);
    btnOk.Enabled := False;
    btnCancelar.Enabled := False;
    try
      if frmExportaXML.EnviarMesAnterior(cbNFeSaida.Checked, cbNFeEntrada.Checked, cbNFCeSAT.Checked,
                                        edtEmailContab.Text) then
        Application.MessageBox(PChar(_cXMLsMesEnviadosSucesso), Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
    finally
      FreeAndNil(frmExportaXML);
      btnOk.Enabled := True;
      btnCancelar.Enabled := True;
    end;
  end;

  FoArqDat.NFe.XML.DataUltimoEnvio := Date;
end;

procedure TfrmConfigEmailAutContab.btnOkClick(Sender: TObject);
begin
  if not FazVerificacoes then
    Exit;
  try
    EnviarXMLs;
    Self.Close;
  finally
    SalvarINI;
  end;
end;

procedure TfrmConfigEmailAutContab.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmConfigEmailAutContab.SetImagem(AoImagem: TPicture);
begin
  Image1.Picture := AoImagem;
end;

end.
