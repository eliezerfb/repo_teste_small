unit uExportaXML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, SmallFunc, uArquivosDAT,
  uSalvaXMLContabilFactory, IBQuery, uConectaBancoSmall;

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
    function TestarTemTabelaNFCe: Boolean;
    function TestarArquivoMaior10Mega(AcArquivo: String): Boolean;
    function TamanhoArquivo(AcArquivo: string): Integer;
    procedure LimparPastaContabil;
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

function TfrmExportaXML.TamanhoArquivo(AcArquivo: string): Integer;
begin
  with TFileStream.Create(AcArquivo, fmOpenRead or fmShareExclusive) do
  try
    Result := Size;
  finally
   Free;
  end;
end;

procedure TfrmExportaXML.LimparPastaContabil;
var
  i: integer;
  oSearch: TSearchRec;
begin
  if not (DirectoryExists(ExtractFilePath(Application.ExeName) + 'CONTABIL\')) then
    Exit;

  I := FindFirst(ExtractFilePath(Application.ExeName) + 'CONTABIL\*.*', faAnyFile, oSearch);

  while I = 0 do
  begin
    DeleteFile(ExtractFilePath(Application.ExeName) + 'CONTABIL\' + oSearch.Name);
    I := FindNext(oSearch);
  end;
end;

function TfrmExportaXML.EnviarXml: Boolean;
var
  cAnexo, cTitulo, cCorpo: String;
  cZipNFeSaida, cZipNFeEntrada, cZipNFCeSAT: String;
  bTamanhoZip: Boolean;
begin
  Result := False;
  bTamanhoZip := True;
  try
    if not FazValidacoes then
      Exit;

    LimparPastaContabil;
    
    try
      if cbNFeSaida.Checked then
      begin
        Form7.ibDataSet15.DisableControls;
        try
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSql.Clear;
          Form7.ibDataSet15.Selectsql.Add('select * from VENDAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dtFinal.Date))+
                                          ' and EMISSAO>='+QuotedStr(DateToStrInvertida(dtInicial.Date))+' order by EMISSAO, NUMERONF');
          Form7.ibDataset15.Open;

          cZipNFeSaida   := TSalvaXMLContabilFactory.New
                                                    .NFeSaida
                                                    .setTransaction(Form7.IBTransaction1)
                                                    .setDatas(dtInicial.Date, dtFinal.Date)
                                                    .setDataSet(Form7.ibDataSet15)
                                                    .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                    .Salvar
                                                    .Compactar
                                                    .getCaminhoArquivos;
        finally
          Form7.ibDataSet15.EnableControls;
        end;
      end;

      if cbNFeEntrada.Checked then
      begin
        Form7.ibDataSet24.DisableControls;
        try
          Form7.ibDataSet24.Close;
          Form7.ibDataSet24.SelectSql.Clear;
          Form7.ibDataSet24.Selectsql.Add('select * from COMPRAS where EMISSAO<='+QuotedStr(DateToStrInvertida(dtFinal.Date))+
                                          ' and EMISSAO>='+QuotedStr(DateToStrInvertida(dtInicial.Date))+' order by EMISSAO, NUMERONF');
          Form7.ibDataSet24.Open;

          cZipNFeEntrada := TSalvaXMLContabilFactory.New
                                                    .NFeEntrada
                                                    .setTransaction(Form7.IBTransaction1)
                                                    .setDatas(dtInicial.Date, dtFinal.Date)
                                                    .setDataSet(Form7.ibDataSet24)
                                                    .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                    .Salvar
                                                    .Compactar
                                                    .getCaminhoArquivos;
        finally
          Form7.ibDataSet24.EnableControls;
        end;
      end;

      if cbNFCeSAT.Checked then
        cZipNFCeSAT    := TSalvaXMLContabilFactory.New
                                                  .NFCeSAT
                                                  .setTransaction(Form7.IBTransaction1)
                                                  .setDatas(dtInicial.Date, dtFinal.Date)
                                                  .setCNPJ(Form7.ibDataSet13CGC.AsString)
                                                  .Salvar
                                                  .Compactar
                                                  .getCaminhoArquivos;

      if FileExists(cZipNFeSaida) then
        cAnexo := cZipNFeSaida;
      if FileExists(cZipNFeEntrada) then
      begin
        if cAnexo <> EmptyStr then
          cAnexo := cAnexo + ';';
        cAnexo := cAnexo + cZipNFeEntrada;
      end;
      if FileExists(cZipNFCeSAT) then
      begin
        if cAnexo <> EmptyStr then
          cAnexo := cAnexo + ';';
        cAnexo := cAnexo + cZipNFCeSAT;
      end;

      if cAnexo <> EmptyStr then
      begin
        if (TestarArquivoMaior10Mega(cZipNFeSaida)) or (TestarArquivoMaior10Mega(cZipNFeEntrada)) or (TestarArquivoMaior10Mega(cZipNFCeSAT)) then
        begin
          if Application.MessageBox(PChar('O tamanho de um ou mais arquivos ultrapassou 10MB.' + SLineBreak + SLineBreak +
                                        'Seu servidor de e-mail poderá bloquear o envio.' + SLineBreak +
                                        'Selecione períodos menores para evitar bloqueio do envio.' + SLineBreak + SLineBreak +
                                        'Deseja enviar o(s) arquivo(s) mesmo assim?'), PChar(_cTituloMsg), MB_ICONQUESTION + MB_YESNO) = mrNo then
          Exit;
        end;
          
        cTitulo := _cTituloEmailXMLContab;
        cTitulo := StringReplace(cTitulo, '<RAZAOEMPRESA>', Form7.ibDataSet13NOME.AsString, []);
        cTitulo := StringReplace(cTitulo, '<CNPJEMPRESA>', Form7.ibDataSet13CGC.AsString, []);

        cCorpo := _cCorpoEmailXMLContab;
        cCorpo := StringReplace(cCorpo, '<RAZAOEMPRESA>', Form7.ibDataSet13NOME.AsString, []);
        cCorpo := StringReplace(cCorpo, '<CNPJEMPRESA>', Form7.ibDataSet13CGC.AsString, []);
        cCorpo := StringReplace(cCorpo, '<PERIODO>', DateToStr(dtInicial.Date) + ' à ' + DateToStr(dtFinal.Date), []);

        Unit7.EnviarEMail(EmptyStr, AllTrim(edtEmailContab.Text), EmptyStr, cTitulo, cCorpo, cAnexo, False);
        Result := True;
      end
      else
        Application.MessageBox(PChar('O e-mail não foi enviado a contabilidade.' + sLineBreak + sLineBreak +
                                     'Não foi encontrado nenhum XML para os documentos marcados, verifique o período informado.'), pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);

    finally
      LimparPastaContabil;
    end;
  except
    on e:Exception do
      Application.MessageBox(PChar('Não foi possível enviar o(s) XML(s) para a contabilidade.' + sLineBreak + e.message), pchar(_cTituloMsg), MB_OK + MB_ICONINFORMATION);
  end;
end;

function TfrmExportaXML.TestarArquivoMaior10Mega(AcArquivo: String): Boolean;
begin
  Result := False;

  if AcArquivo = EmptyStr then
    Exit;

  if TamanhoArquivo(AcArquivo) > _cArquivo10MB then
    Result := True;
end;

procedure TfrmExportaXML.btnAvancarClick(Sender: TObject);
begin
  btnAvancar.Enabled := False;
  try
    if not EnviarXml then
      Exit;

    btnCancelarClick(Self);
  finally
    btnAvancar.Enabled := True;
  end;
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

  TestarTemTabelaNFCe;

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

  if not FileExists('szip.exe') then
  begin
    Application.MessageBox(PChar('Utilitário de compatação não encontrado SZIP.EXE' + SLineBreak + SLineBreak +
                                 'O envio dos XMLs foi cancelado.'), Pchar(_cTituloMsg), MB_ICONWARNING + MB_OK);
    Exit;
  end;
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

function TfrmExportaXML.TestarTemTabelaNFCe: Boolean;
var
  qryNFCe: TIBQuery;
begin
  qryNFCe := CriaIBQuery(Form7.IBTransaction1);
  try
    qryNFCe.Close;
    qryNFCe.Database := Form7.IBDatabase1;
    qryNFCe.SQL.Clear;
    qryNFCe.SQL.Add('SELECT COUNT(*) TEM');
    qryNFCe.SQL.Add('FROM RDB$RELATIONS');
    qryNFCe.SQL.Add('WHERE RDB$FLAGS=1 and RDB$RELATION_NAME=''NFCE''');
    qryNFCe.Open;

    cbNFCeSAT.Enabled := (qryNFCe.FieldByName('TEM').AsInteger > 0);
    if not cbNFCeSAT.Enabled then
      cbNFCeSAT.Checked := False;

    Result := cbNFCeSAT.Enabled;
  finally
    FreeAndNil(qryNFCe);
  end;
end;

end.

