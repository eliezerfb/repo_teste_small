unit uExportaXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, SmallFunc, uArquivosDAT,
  uGeraXMLDocsEletronicosFactory;

type
  TfrmExportaXML = class(TForm)
    Image1: TImage;
    dtInicial: TDateTimePicker;
    Label3: TLabel;
    dtFinal: TDateTimePicker;
    Label2: TLabel;
    edtEmailContab: TEdit;
    Label4: TLabel;
    btnAvancar: TButton;
    btnCancelar: TButton;
    cbNFeSaida: TCheckBox;
    cbNFeEntrada: TCheckBox;
    cbNFCeSAT: TCheckBox;
    procedure btnAvancarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FoArquivoDAT: TArquivosDAT;
    procedure CarregaArquivoINI;
    procedure GravaArquivoINI;
    function FazValidacoes: Boolean;
    function EnviarXml: Boolean;
  public
    procedure SetImagem(AoImagem: TPicture);
    procedure AbrirTelaTodosDocs;
    procedure AbrirTelaNFe(AbSaida: Boolean = True; AbEntrada: Boolean = True);
    procedure AbrirSATNFCe;
  end;

var
  frmExportaXML: TfrmExportaXML;

implementation

uses
  uSmallConsts, uSmallResourceString, unit7;

{$R *.dfm}

function TfrmExportaXML.EnviarXml: Boolean;
var
  cAnexo: String;
  cZipNFeSaida, cZipNFeEntrada, cZipNFCeSAT: String;
begin
  Result := False;
  try
    if FazValidacoes then
      Exit;

    try
      if cbNFeSaida.Checked then
        cZipNFeSaida   := TGeraXMLDocsEletronicosFactory.New
                                                        .NFeSaida
                                                        .setTransaction(Form7.IBTransaction1)
                                                        .setDatas(dtInicial.Date, dtFinal.Date)
                                                        .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                        .Salvar
                                                        .Compactar
                                                        .getCaminhoArquivos;

      if cbNFeEntrada.Checked then
        cZipNFeEntrada := TGeraXMLDocsEletronicosFactory.New
                                                        .NFeEntrada
                                                        .setTransaction(Form7.IBTransaction1)
                                                        .setDatas(dtInicial.Date, dtFinal.Date)
                                                        .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                        .Salvar
                                                        .Compactar
                                                        .getCaminhoArquivos;

      if cbNFCeSAT.Checked then
        cZipNFCeSAT    := TGeraXMLDocsEletronicosFactory.New
                                                        .NFCeSAT
                                                        .setTransaction(Form7.IBTransaction1)
                                                        .setDatas(dtInicial.Date, dtFinal.Date)
                                                        .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                        .Salvar
                                                        .Compactar
                                                        .getCaminhoArquivos;

      if cZipNFeSaida <> EmptyStr then
        cAnexo := cZipNFeSaida;
      if cZipNFeEntrada <> EmptyStr then
      begin
        if cAnexo <> EmptyStr then
          cAnexo := cAnexo + ';';
        cAnexo := cZipNFeEntrada;
      end;
      if cZipNFCeSAT <> EmptyStr then
      begin
        if cAnexo <> EmptyStr then
          cAnexo := cAnexo + ';';
        cAnexo := cZipNFCeSAT;
      end;

      Unit7.EnviarEMail(AllTrim(edtEmailContab.Text), EmptyStr, EmptyStr, 'Assunto', 'Texto', cAnexo, False);

      Result := True;
    finally
      if FileExists(cZipNFeSaida) then
        DeleteFile(cZipNFeSaida);
      if FileExists(cZipNFeEntrada) then
        DeleteFile(cZipNFeEntrada);
      if FileExists(cZipNFCeSAT) then
        DeleteFile(cZipNFCeSAT);
    end;
  except
    on e:Exception do
      Application.MessageBox(PChar('Não foi possível enviar o(s) XML(s) para a contabilidade.' + sLineBreak + e.message), pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmExportaXML.btnAvancarClick(Sender: TObject);
begin
  if not EnviarXml then
    Exit;
    
  btnCancelarClick(Self);
end;

procedure TfrmExportaXML.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExportaXML.AbrirSATNFCe;
begin
  cbNFCeSAT.Enabled    := True;
  cbNFeSaida.Enabled   := False;
  cbNFeEntrada.Enabled := False;

  Self.ShowModal;
end;

procedure TfrmExportaXML.AbrirTelaNFe(AbSaida, AbEntrada: Boolean);
begin
  cbNFeSaida.Enabled   := AbSaida;
  cbNFeEntrada.Enabled := AbEntrada;
  cbNFCeSAT.Enabled    := False;

  Self.ShowModal;
end;

procedure TfrmExportaXML.AbrirTelaTodosDocs;
begin
  cbNFeSaida.Enabled   := True;
  cbNFeEntrada.Enabled := True;
  cbNFCeSAT.Enabled    := True;

  Self.ShowModal;
end;

procedure TfrmExportaXML.FormShow(Sender: TObject);
begin
  cbNFCeSAT.Checked    := False;
  cbNFeSaida.Checked   := False;
  cbNFeEntrada.Checked := False;

  if cbNFeSaida.Enabled then
    cbNFeSaida.Checked   := True;
  if cbNFeEntrada.Enabled then
    cbNFeEntrada.Checked := True;
  if cbNFCeSAT.Enabled then
    cbNFCeSAT.Checked    := True;
end;

procedure TfrmExportaXML.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GravaArquivoINI;
end;

procedure TfrmExportaXML.FormCreate(Sender: TObject);
begin
  {$IFDEF VER150}
  ShortDateFormat := _cFormatDate;
  {$ELSE}
  FormatSettings.ShortDateFormat := _cFormatDate;
  {$ENDIF}
  
  FoArquivoDAT := TArquivosDAT.Create(EmptyStr);

  CarregaArquivoINI;
end;

procedure TfrmExportaXML.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FoArquivoDAT);
end;

procedure TfrmExportaXML.CarregaArquivoINI;
begin
  dtInicial.Date      := FoArquivoDAT.NFe.XML.PeriodoInicial;
  dtFinal.Date        := FoArquivoDAT.NFe.XML.PeriodoFinal;
  edtEmailContab.Text := Alltrim(FoArquivoDAT.NFe.XML.EmailContabilidade);
end;

procedure TfrmExportaXML.GravaArquivoINI;
begin
  FoArquivoDAT.NFe.XML.PeriodoInicial     := dtInicial.Date;
  FoArquivoDAT.NFe.XML.PeriodoFinal       := dtFinal.Date;
  FoArquivoDAT.NFe.XML.EmailContabilidade := AllTrim(edtEmailContab.Text);
end;

procedure TfrmExportaXML.SetImagem(AoImagem: TPicture);
begin
  Image1.Picture := AoImagem;
end;

function TfrmExportaXML.FazValidacoes: Boolean;
begin
  Result := False;

  if (not cbNFeSaida.Checked) and (not cbNFeEntrada.Checked) and (not cbNFCeSAT.Checked) then
  begin
    Application.MessageBox('Marque ao menos um tipo de documento.', Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  if not ValidaEmail(edtEmailContab.Text) then
  begin
    Application.MessageBox(Pchar(_cEmailInvalido), Pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
    edtEmailContab.SetFocus;
    Exit;
  end;  

  Result := True;
end;

end.

