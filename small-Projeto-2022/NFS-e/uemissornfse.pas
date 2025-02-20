unit uemissornfse;


interface

uses
  Windows, Messages, SysUtils, SmallFunc, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, spdNFSe, spdNFSeException, IniFiles, MSXML5_TLB, spdCustomNFSe,
  spdNFSeUtils, StrUtils, spdNFSeDataset, spdNFSeXsdUtils, ComCtrls, StdCtrls,
  ExtCtrls, CheckLst, Grids, DBGrids, OleCtrls, SHDocVw, spdNFSeTypes,
  spdNFSeGov, jpeg;

//******************************************************************************************************
//
//          Declarações
//
//******************************************************************************************************

type
  TModoOpercao = (tmoNenhum, tmoConfiguracao, tmoEnvioConsulta, tmoGeraPDF); // Sandro Silva 2023-01-25

type
  TFEmissorNFSe = class(TForm)
    OpnDlgTx2: TOpenDialog;
    pcMensagens: TPageControl;
    tsXML: TTabSheet;
    tsXMLFormatado: TTabSheet;
    mmXMLEnvio: TMemo;
    mmXML: TMemo;
    NFSe: TspdNFSe;
    svDlgExportar: TSaveDialog;
    OpnDlgLogoTipo: TOpenDialog;
    tsJSON: TTabSheet;
    mmJson: TMemo;
    tsFormatado: TTabSheet;
    mmTipado: TMemo;
    gbOperacoesNFSe: TGroupBox;
    lblAmbiente: TLabel;
    Label4: TLabel;
    btnEnviarRPS: TButton;
    btnCancelar: TButton;
    btnConsultarNota: TButton;
    edtNumeroRPS: TLabeledEdit;
    edtSerieRPS: TLabeledEdit;
    edtTipoRPS: TLabeledEdit;
    edtNumeroNFSe: TLabeledEdit;
    edtChaveCancelamento: TLabeledEdit;
    gbOperacaoImpressao: TGroupBox;
    btnEditarDocumento: TButton;
    btnImprimir: TButton;
    btnExportar: TButton;
    btnVisualizar: TButton;
    ckbEnviarEmailPDF: TCheckBox;
    edtCNPJSoftwareHouse: TLabeledEdit;
    edtTokenSoftwareHouse: TLabeledEdit;
    edtLogoEmitente: TEdit;
    btnLogoTipoEmitente: TButton;
    btnConfigArquivoINI: TButton;
    btnLoadConfig: TButton;
    cbListaCertificados: TComboBox;
    Label7: TLabel;
    btnListarCidades: TButton;
    edtNumProtocolo: TLabeledEdit;
    edtInscMunicipal: TLabeledEdit;
    edtCNPJ: TLabeledEdit;
    edtCidade: TLabeledEdit;
    Image1: TImage;
    Button1: TButton;
    btnAtualizaArquivos: TButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button2: TButton;

    {DECLARAÇÕES RELACIONADAS AO ENVIO e CONSULTAS}
    {Abre o arquivo NFSeConfig.ini}
    procedure btnConfigArquivoINIClick(Sender: TObject);
    {Executa a ação LoadConfig}
    procedure btnLoadConfigClick(Sender: TObject);
    {Enviar RPS apartir do arquivo TX2}
    procedure btnEnviarRPSClick(Sender: TObject);
    {Consulta a Nota Com base nos parametros preenchidos}
    procedure btnConsultarNotaClick(Sender: TObject);
    {Solicita Cancelamento da Nota na prefeitura}
    procedure btnCancelarClick(Sender: TObject);



    {DECLARAÇÕES COMUNS PARA AMBOS OS MÉTODOS}
    {Criação do Form}
    procedure FormCreate(Sender: TObject);
    {Editar o documento de impressão}
    procedure btnEditarDocumentoClick(Sender: TObject);
    {Imprimir documento}
    procedure btnImprimirClick(Sender: TObject);
    {Exporta documento de impressão no formato PDF}
    procedure btnExportarClick(Sender: TObject);
    {Visualizar documento de impressão}
    procedure btnVisualizarClick(Sender: TObject);
    {Executa o Dialog para busca do logtipo emitente}
    procedure btnLogoTipoEmitenteClick(Sender: TObject);
	  {Lista os certificados}
    procedure cbListaCertificadosDropDown(Sender: TObject);
    procedure mmXMLEnvioKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmXMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmJsonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmTipadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnAtualizaArquivosClick(Sender: TObject);
    procedure btnListarCidadesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ConfiguraCredencialTecnospeed;
    procedure FormActivate(Sender: TObject);
  private
    FModoOperacao: TModoOpercao; // Sandro Silva 2023-01-25
    sPadrao: String; // Sandro Silva 2023-09-06
    sCidade: String; // Sandro Silva 2023-09-06
    fLogEnvio: string;
    mmTx2: TMemo;// Sandro Silva 2024-06-10
    {Valida a presença do arquivo .ini}
    procedure CheckConfig;
    {Anexa o PDF e realiza o envio de email}
//    procedure EnviarEmail;
    {Evento utilizado para capturar o nome do log assim que ele é gerado}
    procedure OnLog(const aNome, aID, aFileName: string);
    procedure getRetornoV2Tipado;
    procedure getRetornoV2Json;
    function ExtrairRazaoSocialPrestador(sl: TStringList): String;
  public
    { Public declarations }
    sTX2, sNumeroDaNFSe, sRetornoDaPrefeitura, sAtual, smmXML : String;

  end;

var
  FEmissorNFSe: TFEmissorNFSe;

implementation

{$R *.dfm}

uses
  ShellApi, spdNFSeXmlUtils, uconstantes_chaves_privadas,
  ucredencialtecnospeed, uconfiguracaonfse;


{IMPLEMENTAÇÃO UTILIZANDO COMPONENTE NFSeV2}

function RetornaValorDaTagNoCampo(sTag: String; sObs: String): String;
// Extrai o valor do par�metro configurado
// Par�metros:
// sTag: Nome da tag par�metro
// sObs: Texto onde est� a tag com a configura��o
// Exemplo: Obs= <descANP>GLP</descANP> retorna: GLP
//          Obs= <descANP>GLP<descANP> retorna: GLP
var
  sTextoTag: String;
begin
  Result := '';
  sObs := Trim(sObs);
  if AnsiContainsText(sObs, '<' + sTag + '>') then
  begin
    sTextoTag := Copy(sObs, Pos('<' + sTag + '>', sObs) + Length('<' + sTag + '>'), Length(sObs));
    sTextoTag := StringReplace(STextoTag, '</' + sTag, '<' + sTag, []);
    Result := AllTrim(Copy(sTextoTag, 1, Pos('<' + sTag + '>', STextoTag) -1));
  end;
end;

procedure TFEmissorNFSe.CheckConfig;
var
  _Cidade, _CNPJ: string;
  _bConfig: Boolean;
begin
  _Cidade := trim(NFSe.Cidade);
  _CNPJ := trim(NFSe.CNPJ);

  _bConfig := (_Cidade <> '') and (_CNPJ <> '');

  if (not _bConfig) then
    raise Exception.Create('Favor configurar o componente antes de prosseguir!');
end;

procedure TFEmissorNFSe.mmJsonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C: string;
begin
  if ssCtrl in Shift then
  begin
    C := LowerCase(Char(Key));
    if C = 'a' then
    begin
      mmJson.SelectAll;
    end;
  end;
end;

procedure TFEmissorNFSe.mmTipadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C: string;
begin
  if ssCtrl in Shift then
  begin
    C := LowerCase(Char(Key));
    if C = 'a' then
    begin
      mmTipado.SelectAll;
    end;
  end;
end;

procedure TFEmissorNFSe.mmXMLEnvioKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C: string;
begin
  if ssCtrl in Shift then
  begin
    C := LowerCase(Char(Key));
    if C = 'a' then
    begin
      mmXMLEnvio.SelectAll;
    end;
  end;
end;

procedure TFEmissorNFSe.mmXMLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  C: string;
begin
  if ssCtrl in Shift then
  begin
    C := LowerCase(Char(Key));
    if C = 'a' then
    begin
      mmXML.SelectAll;
    end;
  end;
end;

procedure TFEmissorNFSe.btnConfigArquivoINIClick(Sender: TObject);
var
  _ExecuteFile: string;
  _NomeCertificado: string;
  _CurrentDir: string;
  _IniFile: TIniFile;
begin
  (Sender as TWinControl).Enabled := False;
  try
    if cbListaCertificados.Text <> '' then
    begin
      _NomeCertificado := Trim(cbListaCertificados.Text);

      _CurrentDir := ExtractFilePath(ParamStr(0));
      SetCurrentDir(_CurrentDir);
      _IniFile := TIniFile.Create(_CurrentDir + 'nfseConfig.ini');
      try
        _IniFile.WriteString('NFSE', 'NomeCertificado', _NomeCertificado);
      finally
        _IniFile.Free;
      end;
    end;
    _ExecuteFile := ExtractFilePath(ParamStr(0)) + 'nfseConfig.ini';
    ShellExecute(Application.Handle, nil, Pchar(_ExecuteFile), nil, nil, SW_SHOWNORMAL);
  finally
    (Sender as TWinControl).Enabled := True;
  end;
end;

  {Exemplo de configuração do componente NFSe}
procedure TFEmissorNFSe.btnLoadConfigClick(Sender: TObject);
begin
  ConfiguraCredencialTecnospeed;

  NFSe.LoadConfig;
  NFSe.OnLog := OnLog;
  edtCidade.Text := NFSe.Cidade;
  edtCNPJ.Text := NFSe.CNPJ;
  edtInscMunicipal.Text := NFSe.InscricaoMunicipal;
  cbListaCertificados.Text := NFSe.NomeCertificado.Text;
  
  edtLogoEmitente.Text       := sAtual + '\logonfse.jpg';
  NFSE.LogoTipoEmitente      := sAtual + '\logonfse.jpg';
end;

procedure TFEmissorNFSe.btnEnviarRPSClick(Sender: TObject);
begin
  try
    CheckConfig;
    NFSe.Enviar(pChar(sAtual+'\NFSE\smallnfse.tx2'));
    getRetornoV2Tipado;
    getRetornoV2Json;
  except
  end;
end;

procedure TFEmissorNFSe.btnEditarDocumentoClick(Sender: TObject);
begin
  CheckConfig;
  OpnDlgTx2.Execute;
  Nfse.EditarImpressao(mmXML.Text, mmXMLEnvio.Text, OpnDlgTx2.FileName);
end;

procedure TFEmissorNFSe.btnImprimirClick(Sender: TObject);
begin
  CheckConfig;
  
  Nfse.Imprimir(mmXML.Text, mmXMLEnvio.Text,pChar(sAtual+'\NFSE\LOG\'+sNumeroDaNFSe+'.pdf'));
end;

procedure TFEmissorNFSe.btnExportarClick(Sender: TObject);
begin
{
  try
    CheckConfig;
    if FileExists(pChar(sAtual+'\NFSE\smallnfse.tx2')) then
    begin
      Nfse.ExportarImpressaoParaPDF(mmXML.Text, mmXMLEnvio.Text, pChar(sAtual+'\NFSE\smallnfse.tx2'), pChar(sAtual+'\NFSE\LOG\'+sNumeroDaNFSe+'.pdf'));
    end else
    begin
      Nfse.Imprimir(mmXML.Text, mmXMLEnvio.Text,pChar(sAtual+'\NFSE\LOG\'+sNumeroDaNFSe+'.pdf'));
    end;
  except
  end;
}
  try
    CheckConfig;
    if FileExists(pChar(sAtual+'\NFSE\smallnfse.tx2')) then
    begin
      Nfse.ExportarImpressaoParaPDF(mmXML.Text, mmXMLEnvio.Text, pChar(sAtual+'\NFSE\smallnfse.tx2'), pChar(sAtual+'\NFSE\LOG\'+sNumeroDaNFSe+'.pdf'));
    end else
    begin
      Nfse.Imprimir(mmXML.Text, mmXMLEnvio.Text,pChar(sAtual+'\NFSE\LOG\'+sNumeroDaNFSe+'.pdf'));
    end;
  except
  end;
end;

procedure TFEmissorNFSe.btnVisualizarClick(Sender: TObject);
begin
  CheckConfig;
  Nfse.VisualizarImpressao(mmXML.Text, mmXMLEnvio.Text, OpnDlgTx2.FileName);
end;

procedure TFEmissorNFSe.cbListaCertificadosDropDown(Sender: TObject);
begin
  cbListaCertificados.Clear;
  NFSe.ListarCertificados(cbListaCertificados.Items);
end;

procedure TFEmissorNFSe.FormCreate(Sender: TObject);
var
  F: TextFile;
  I : Integer;
  Mais1Ini : tIniFile;
  _file : TStringList;
  sLoguinSenha : String;
  procedure AddRazaoSocialParametroExtra;
  var
    sRazaoSocial: String;
  begin
    if (sCidade = 'SAOSEBASTIAODOCAIRS') and (sPadrao = 'TECNOSISTEMAS') then
    begin
      sRazaoSocial := ExtrairRazaoSocialPrestador(_File);
      if Trim(sRazaoSocial) <> '' then
      begin
        if NFSe.ParametrosExtras <> '' then
          NFSe.ParametrosExtras := NFSe.ParametrosExtras + ';';
        NFSe.ParametrosExtras := NFSe.ParametrosExtras + 'RazaoSocial=' + sRazaoSocial;
      end;
    end;
  end;
begin
  mmTx2 := TMemo.Create(Application);
  mmTx2.Visible := False;
  mmTx2.Parent := FEmissorNFSe;

  FModoOperacao := tmoNenhum;
  sTX2 := '';
  GetDir(0,sAtual);

  edtCNPJSoftwareHouse.Text  := '03916076000664';
  edtTokenSoftwareHouse.Text := '5236f0fc4fb818efe845ebff0d0457af';

  Mais1ini := TIniFile.Create(sAtual+'\nfseConfig.ini');

  Mais1Ini.WriteString('NFSE','Arquivos',sAtual+'\NFSE');
  Mais1Ini.WriteString('NFSE','DiretorioLog',sAtual+'\NFSE\Log');
  Mais1Ini.WriteString('NFSE','DiretorioLogErro',sAtual+'\NFSE\LogErro');
  Mais1Ini.WriteString('NFSE','LogoTipoEmitente',sAtual+'\NFSE\logonfse.jpg');

  sLoguinSenha := Mais1Ini.ReadString('NFSE','ParametrosExtras','');

  LabeledEdit1.Text := Copy(sLoguinSenha+Replicate(' ',30),Pos('Login=',sLoguinSenha)+6,Pos(';',sLoguinSenha)-Pos('Login=',sLoguinSenha)+1-7);
  LabeledEdit2.Text := AllTrim(Copy(sLoguinSenha+Replicate(' ',200),Pos('Senha=',sLoguinSenha+Replicate(' ',200))+6,150));

  sPadrao := AnsiUpperCase(Mais1Ini.ReadString('Informacoes obtidas na prefeitura', 'Padrao', '')); // Sandro Silva 2023-09-06
  sCidade := AnsiUpperCase(Mais1Ini.ReadString('NFSE', 'CIDADE', '')); // Sandro Silva 2023-09-06

  if Mais1Ini.ReadString('NFSE','Ambiente','2') = '1' then
  begin
    RadioButton1.Checked := False;
    RadioButton2.Checked := True;
  end else
  begin
    RadioButton1.Checked := True;
    RadioButton2.Checked := False;
  end;

  Mais1ini.Free;

  FEmissorNFSe.btnLoadConfigClick(Sender);

  if FileExists(Pchar(sAtual+'\NFSE\smallnfse.tx2')) then
  begin
    _file := TStringList.Create;
    _file.LoadFromFile(pChar(sAtual+'\NFSE\smallnfse.tx2'));

    if Pos('Config=Sim',_File.Text) <> 0 then
    begin
      FModoOperacao := tmoConfiguracao; // Sandro Silva 2023-01-25

      btnAtualizaArquivosClick(Sender);
      Button2.Visible := True;

      if FileExists(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG')) then
      begin
        Image1.Picture.LoadFromFile(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG'));
      end;

      btnListarCidadesClick(Sender);
    end else
    begin
      if Pos('GerarPDF=Sim',_File.Text) <> 0 then
      begin
        FModoOperacao := tmoGeraPDF;

        try
          AssignFile(F,Pchar(sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
          Rewrite(F);

          Write(F,RetornaValorDaTagNoCampo('tx2',_File.Text));
          CloseFile(F);
          Sleep(100); // Sandro Silva 2023-01-25

          mmXML.Text      := RetornaValorDaTagNoCampo('XMLImpressao',_File.Text);
          mmXMLEnvio.Text := RetornaValorDaTagNoCampo('XMLdeEvio',_File.Text); // �ltima altera��o 08/08/2022 para resolver o caso de Joinvile
          sNumeroDaNFSe   := RetornaValorDaTagNoCampo('sNumeroDaNFSE',_File.Text);
          mmTx2.Text      := RetornaValorDaTagNoCampo('tx2',_File.Text);

          FEmissorNFSe.btnExportarClick(Sender);
        except
        end;

        Close;
        Winexec('TASKKILL /F /IM NFSE.EXE' , SW_HIDE );
      end else
      begin
        FModoOperacao := tmoEnvioConsulta; // Sandro Silva 2023-01-25

        if FileExists(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG')) then
        begin
          Image1.Picture.LoadFromFile(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG'));
        end else
        begin
          btnAtualizaArquivosClick(Sender);
        end;

        try
          if RetornaValorDaTagNoCampo('Status',_File.Text) = 'EM PROCESSAMENTO' then
          begin
            edtNumeroNFSe.Text   := RetornaValorDaTagNoCampo('NumeroDaNFSe',_File.Text);
            edtNumeroRPS.Text    := RetornaValorDaTagNoCampo('NumeroDoRPS' ,_File.Text);
            edtSerieRPS.Text     := RetornaValorDaTagNoCampo('SerieDoRPS'  ,_File.Text);
            edtTipoRPS.Text      := RetornaValorDaTagNoCampo('Tipo'        ,_File.Text);
            edtNumProtocolo.Text := RetornaValorDaTagNoCampo('Protocolo'   ,_File.Text);

            // Grava o NOVO TXT2
            {Mauricio Parizotto 2025-01-22}
            //while FileExists(Pchar(sAtual+'\NFSE\smallnfse.tx2')) do
            if FileExists(Pchar(sAtual+'\NFSE\smallnfse.tx2')) then
            begin
              DeleteFile(Pchar(sAtual+'\NFSE\smallnfse.tx2'));
              Sleep(100);
            end;

            AssignFile(F,Pchar(sAtual+'\NFSE\smallnfse.tx2'));  // Direciona o arquivo F para EXPORTA.TXT
            Rewrite(F);

            Write(F,RetornaValorDaTagNoCampo('tx2',_File.Text));
            CloseFile(F);

            mmXMLEnvio.Text := RetornaValorDaTagNoCampo('XMLdeEvio',_File.Text);

            AddRazaoSocialParametroExtra;

            btnConsultarNotaClick(Sender);

            if (NFSe.Ambiente = akHomologacao) then
            begin
              FEmissorNFSe.btnVisualizarClick(Sender);
            end else
            begin
              if Pos('ChaveDeCancelamento',smmXML) <> 0 then
              begin
                FEmissorNFSe.btnExportarClick(Sender);
              end;
            end;
          end else
          begin
            sTX2 := _File.Text;

            if Pos('ChaveDeCancelamento=',_File.Text) <> 0 then
            begin
              edtChaveCancelamento.Text := StrTran(_File.Text,'ChaveDeCancelamento=','');
              btnCancelarClick(Sender);
            end else
            begin
              FEmissorNFSe.btnEnviarRPSClick(Sender);
              //Sleep(100);
              Sleep(1000); //Mauricio Parizotto 2025-01-22 

              I := 0;
              //while (RetornaValorDaTagNoCampo('Status',smmXML) = 'EM PROCESSAMENTO') or (Pos('NFS-E NAO AUTORIZADA',RetornaValorDaTagNoCampo('Status',smmXML))<>0) and (I < 10) do  Mauricio Parizotto 2025-01-22
              while ((RetornaValorDaTagNoCampo('Status',smmXML) = 'EM PROCESSAMENTO') or (Pos('NFS-E NAO AUTORIZADA',RetornaValorDaTagNoCampo('Status',smmXML))<>0))
                and (I < 5) do
              begin
                edtNumeroNFSe.Text   := '';
                edtNumeroRPS.Text    := RetornaValorDaTagNoCampo('NumeroDoRPS' ,smmXML);
                edtSerieRPS.Text     := RetornaValorDaTagNoCampo('SerieDoRPS'  ,smmXML);
                edtTipoRPS.Text      := RetornaValorDaTagNoCampo('Tipo'        ,smmXML);
                edtNumProtocolo.Text := '';

                {Sandro Silva 2024-08-28 inicio}
                //getRetornoV2Tipado;
                //getRetornoV2Json;
                if (sCidade = 'SERRAES') then
                begin
                  edtNumProtocolo.Text := NFSe.RetornoWS[0].CodVerificacao;
                end;
                {Sandro Silva 2024-08-28 fim}

                AddRazaoSocialParametroExtra;

                btnConsultarNotaClick(Sender);

                Sleep(1000);

                if (RetornaValorDaTagNoCampo('Status',smmXML) = 'EM PROCESSAMENTO')  or (Pos('NFS-E NAO AUTORIZADA',RetornaValorDaTagNoCampo('Status',smmXML))<>0) then
                begin
                  edtNumeroNFSe.Text   := RetornaValorDaTagNoCampo('NumeroDaNFSe',smmXML);
                  edtNumeroRPS.Text    := RetornaValorDaTagNoCampo('NumeroDoRPS' ,smmXML);
                  edtSerieRPS.Text     := RetornaValorDaTagNoCampo('SerieDoRPS'  ,smmXML);
                  edtTipoRPS.Text      := RetornaValorDaTagNoCampo('Tipo'        ,smmXML);
                  edtNumProtocolo.Text := RetornaValorDaTagNoCampo('Protocolo'   ,smmXML);
                  btnConsultarNotaClick(Sender);
                  Sleep(1000);
                end;

                I := I + 1;
              end;

              if (NFSe.Ambiente = akHomologacao) then
              begin
                FEmissorNFSe.btnVisualizarClick(Sender);
              end else
              begin
                if Pos('ChaveDeCancelamento',smmXML) <> 0 then
                begin
                  FEmissorNFSe.btnExportarClick(Sender);
                end;
              end;
            end;
          end;
        except
        end;

        Close;
        Winexec('TASKKILL /F /IM NFSE.EXE' , SW_HIDE );
      end;
    end;
  end;
end;

procedure TFEmissorNFSe.btnLogoTipoEmitenteClick(Sender: TObject);
begin
  OpnDlgLogoTipo.InitialDir := ExtractFileDir(edtLogoEmitente.Text);
  OpnDlgLogoTipo.FileName := ExtractFileName(edtLogoEmitente.Text);
  if OpnDlgLogoTipo.Execute then
    edtLogoEmitente.Text := OpnDlgLogoTipo.FileName;
end;

procedure TFEmissorNFSe.OnLog(const aNome, aID, aFileName: string);
begin
  fLogEnvio := '';
  
  if (AnsiContainsText(aNome, 'resposta')) then
    fLogEnvio := aFileName;
  if ((AnsiContainsText(aNome, 'enviar_lote_rps_envio')) or (AnsiContainsText(aNome, 'enviar_lote_sincrono_envio'))) then
    mmXMLEnvio.Text := aFileName;
end;

procedure TFEmissorNFSe.getRetornoV2Tipado;
var
  i: Integer;
  sProtocolo: String; //Sandro Silva 2024-08-28
  sSituacao: String; //Sandro Silva 2024-09-02
  slUltimaResposta: TStringList; // Sandro Silva 2024-09-02
  {Sandro Silva 2024-09-02 inicio}
  function SituacaoNFSe: String;
  var
    S: TSearchREc;
    I: Integer;
    sArquivoLogUltimoRetorno: String;
    sNumeroNFSeCancelando: String;
  begin
    Result := NFSe.RetornoWS.Items[i].Situacao;

    if (sCidade = 'SERRAES') then
    begin
      try
        sNumeroNFSeCancelando := Copy(edtChaveCancelamento.Text, 1, pos('|', edtChaveCancelamento.Text) - 1);

        I := FindFirst(ExtractFilePath(Application.ExeName) + 'NFSE\log\' + Trim('*_' + sNumeroNFSeCancelando + '_cancelar_nfse_resposta.xml'), faAnyFile, S);

        while I = 0 do
        begin
          sArquivoLogUltimoRetorno := ExtractFilePath(Application.ExeName) + 'NFSE\log\' + S.Name;
          I := FindNext(S);
        end;

        FindClose(S);

        if FileExists(sArquivoLogUltimoRetorno) then
        begin
          slUltimaResposta := TStringList.Create;
          slUltimaResposta.LoadFromFile(sArquivoLogUltimoRetorno);

          if AnsiContainsText(slUltimaResposta.Text, 'cancelada com sucesso') then
          begin
            Result := 'CANCELADA';
          end;
          slUltimaResposta.Free;
        end;
      except
      end;
    end;
  end;
begin
  try
  mmTipado.Clear;

  for i := 0 to NFSe.RetornoWS.Count - 1 do
  begin
    if (NFSe.RetornoWS.Items[i].Status = 'EMPROCESSAMENTO') or (Pos('n�o foi processado',NFSe.RetornoJson)<>0)
      or ((Trim(edtCidade.Text) = 'BRASILIADF') and (Pos('Lote aguardando processamento', NFSe.RetornoJson) <> 0))
    then
    begin
      if ((Trim(edtCidade.Text) = 'BRASILIADF') and (Pos('Lote aguardando processamento', NFSe.RetornoJson) <> 0)) then
      begin
        smmXml := ConverteAcentos('<XMLRet>'+
                    '<Status>EM PROCESSAMENTO</Status>'+
                    '<Motivo>' + NFSe.RetornoWS.Items[i].Motivo+'</Motivo>'+
                    '<NumeroDaNFSe>' + RetornaValorDaTagNoCampo('NumeroDaNFSe', mmXMLEnvio.Text) +                     '</NumeroDaNFSe>'+
                    '<NumeroDoRPS>' + RetornaValorDaTagNoCampo('NumeroDoRPS' , mmXMLEnvio.Text) +                      '</NumeroDoRPS>'+
                    '<SerieDoRPS>' + RetornaValorDaTagNoCampo('SerieDoRPS'  , mmXMLEnvio.Text) +                       '</SerieDoRPS>'+
                    '<Tipo>' + RetornaValorDaTagNoCampo('Tipo'        , mmXMLEnvio.Text) +                             '</Tipo>'+
                    '<Protocolo>' + RetornaValorDaTagNoCampo('Protocolo', mmXMLEnvio.Text) + '</Protocolo>'+
                    '<ArquivoGeradorNfse>'+ StrTran(AnsiLowerCase(mmXMLEnvio.Text), AnsiLowerCase(sAtual+'\\nfse\log\'),'') +'</ArquivoGeradorNfse>'+
                    '<Json>' + NFSe.RetornoJson + '</Json>'+
                    '</XMLRet>'
                    );

        if RetornaValorDaTagNoCampo('Protocolo', sTX2) <> '' then
          edtNumProtocolo.text := RetornaValorDaTagNoCampo('Protocolo', sTX2);

      end
      else
      begin
        {Sandro Silva 2024-08-28 inicio}
        sProtocolo := '';
        if NFSe.RetornoWS.Items[i].Protocolo <> '' then
          sProtocolo := NFSe.RetornoWS.Items[i].Protocolo;
        if (sCidade = 'SERRAES') and (Trim(sProtocolo) = '') then
          sProtocolo := NFSe.RetornoWS.Items[i].CodVerificacao;
        {Sandro Silva 2024-08-28 fim}

        sSituacao := SituacaoNFSe;

        smmXml := ConverteAcentos('<XMLRet>'+
                    '<Status>EM PROCESSAMENTO</Status>'+
                    '<Motivo>'+NFSe.RetornoWS.Items[i].Motivo+'</Motivo>'+
                    '<NumeroDaNFSe>' + NFSe.RetornoWS.Items[i].NumeroNFSe+                     '</NumeroDaNFSe>'+
                    '<NumeroDoRPS>' + NFSe.RetornoWS.Items[i].NumeroRps+                       '</NumeroDoRPS>'+
                    '<SerieDoRPS>' + NFSe.RetornoWS.Items[i].SerieRps+                         '</SerieDoRPS>'+
                    '<Tipo>' + NFSe.RetornoWS.Items[i].Tipo+                                   '</Tipo>'+
                    '<Protocolo>' + sProtocolo +                                               '</Protocolo>' + //Sandro Silva 2024-08-28  '<Protocolo>'+NFSe.RetornoWS.Items[i].Protocolo+'</Protocolo>'+
                    '<Situacao>' + sSituacao +                                                 '</Situacao>'+ //Sandro Silva 2024-09-02
                    '<ArquivoGeradorNfse>'+ StrTran(AnsiLowerCase(mmXMLEnvio.Text), AnsiLowerCase(sAtual+'\\nfse\log\'),'') +'</ArquivoGeradorNfse>'+
                    '<Json>' + NFSe.RetornoJson + '</Json>'+
                    '</XMLRet>');

        if sProtocolo <> '' then
          edtNumProtocolo.text := sProtocolo;
      end;
    end else
    begin
      if NFSe.RetornoWS.Items[i].Status = 'ERRO' then
      begin
        smmXml   := ConverteAcentos('<XMLRet>'+
                    '<Status>NFS-E NAO AUTORIZADA: ' + NFSe.RetornoWS.Items[i].Motivo +'</Status>'+
                    '<Motivo>'+NFSe.RetornoWS.Items[i].Motivo+'</Motivo>'+
                    '<ArquivoGeradorNfse>'+ StrTran(AnsiLowerCase(mmXMLEnvio.Text), AnsiLowerCase(sAtual+'\\nfse\log\'),'') +'</ArquivoGeradorNfse'+
                    '<Json>' + NFSe.RetornoJson + '</Json>'+
                    '</XMLRet>');
      end else
      begin
        {Sandro Silva 2024-09-02 inicio}
        sSituacao := SituacaoNFSe;
        {
        sSituacao := NFSe.RetornoWS.Items[i].Situacao;

        ShowMessage('Situa��o ' + sSituacao);

        if (sCidade = 'SERRAES') then
        begin
          slUltimaResposta := TStringList.Create;
          slUltimaResposta.LoadFromFile(NFSe.UltimoLogResposta);
          if AnsiContainsText(slUltimaResposta.Text, 'cancelada') then
          begin
            sSituacao := 'Cancelada';

            ShowMessage('log resposta ' + #13 + slUltimaResposta.Text); //Sandro Silva 2024-09-04

          end;
          slUltimaResposta.Free;
        end;
        }
        {Sandro Silva 2024-09-02 fim}

        sRetornoDaPrefeitura :=
          '<Status>' + NFSe.RetornoWS.Items[i].Status +                              '</Status>'+
          '<Protocolo>' + NFSe.RetornoWS.Items[i].Protocolo +                        '</Protocolo>'+
          '<CNPJ>' + NFSe.RetornoWS.Items[i].CNPJ +                                  '</CNPJ>'+
          '<InscricaoMunicipal>' + NFSe.RetornoWS.Items[i].InscricaoMunicipal+       '</InscricaoMunicipal>'+
          '<SerieDoRPS>' + NFSe.RetornoWS.Items[i].SerieRps+                         '</SerieDoRPS>'+
          '<NumeroDoRPS>' + NFSe.RetornoWS.Items[i].NumeroRps+                       '</NumeroDoRPS>'+
          '<NumeroDaNFSe>' + NFSe.RetornoWS.Items[i].NumeroNFSe+                     '</NumeroDaNFSe>'+
          '<DataDeEmissao>' + NFSe.RetornoWS.Items[i].DataEmissaoNFSe+               '</DataDeEmissao>'+
          '<CodigoDeVerificacao>' + NFSe.RetornoWS.Items[i].CodVerificacao+          '</CodigoDeVerificacao>'+
          '<Situacao>' + sSituacao +                                                  '</Situacao>'+ //Sandro Silva 2024-09-02 '<Situacao>' + NFSe.RetornoWS.Items[i].Situacao+                           '</Situacao>'+
          '<DataDeCancelamento>' + NFSe.RetornoWS.Items[i].DataCancelamento+         '</DataDeCancelamento>'+
          '<ChaveDeCancelamento>' + NFSe.RetornoWS.Items[i].ChaveCancelamento+       '</ChaveDeCancelamento>'+
          '<Tipo>' + NFSe.RetornoWS.Items[i].Tipo+                                   '</Tipo>'+
          '<Motivo>' + NFSe.RetornoWS.Items[i].Motivo+                               '</Motivo>'+
          '<ArquivoGeradorNfse>'+ StrTran(AnsiLowerCase(mmXMLEnvio.Text), AnsiLowerCase(sAtual+'\\nfse\log\'),'') +'</ArquivoGeradorNfse>'+
          '<DataDeAutorizacao>' + NFSe.RetornoWS.Items[i].DataAutorizacao+           '</DataDeAutorizacao>'+
          '<Json>' + NFSe.RetornoJson + '</Json>';

        mmTipado.Lines.Add(sRetornoDaPrefeitura);

        sNumeroDaNFSe := Right('000000000'+AllTrim(NFSe.RetornoWS.Items[i].NumeroNFSe),9);

        // Tratamentos somente para Demo
        if NFSe.RetornoWS.Items[i].Protocolo <> '' then
          edtNumProtocolo.text := NFSe.RetornoWS.Items[i].Protocolo;

        edtNumeroRPS.text         := NFSe.RetornoWS.Items[i].NumeroRps;
        edtSerieRPS.text          := NFSe.RetornoWS.Items[i].SerieRps;
        edtTipoRPS.text           := NFSe.RetornoWS.Items[i].Tipo;
        edtNumeroNFSe.Text        := NFSe.RetornoWS.Items[i].NumeroNFSe;
        edtChaveCancelamento.Text := NFSe.RetornoWS.Items[i].ChaveCancelamento;
        mmXML.Text                := NFSe.RetornoWS.Items[i].XmlImpressao;

        {Sandro Silva 2024-06-10 inicio
        smmXml := StrTran(pChar(NFSe.RetornoWS.Items[i].XmlImpressao),'</retorno>','')+'<sRetornoDaPrefeitura>'+ ConverteAcentos(sREtornoDaPrefeitura) +'</sRetornoDaPrefeitura>';
        }
        if (sPadrao = 'PRESCON') and (sCidade = 'CAMPOSDOJORDAOSP') then
          smmXml := StrTran(pChar(NFSe.RetornoWS.Items[i].XmlImpressao),'</retorno>','')+'<sRetornoDaPrefeitura>'+ ConverteAcentos(sREtornoDaPrefeitura) + '<xmlretorno>' + NFSe.RetornoWS.Items[i].XmlImpressao + '</xmlretorno>' +'</sRetornoDaPrefeitura>'
        else
          smmXml := StrTran(pChar(NFSe.RetornoWS.Items[i].XmlImpressao),'</retorno>','')+'<sRetornoDaPrefeitura>'+ ConverteAcentos(sREtornoDaPrefeitura) +'</sRetornoDaPrefeitura>';
        {Sandro Silva 2024-06-10 fim}

      end;
    end;
  end;
  except
    on e:exception do
      ShowMessage('Erro: '+e.Message);
  end;
end;

procedure TFEmissorNFSe.getRetornoV2Json;
begin
  mmJson.Clear;
  mmJson.Lines.Add(NFSe.RetornoJson);
end;

procedure TFEmissorNFSe.btnConsultarNotaClick(Sender: TObject);
var
  sResposta: String;
begin
  try
    CheckConfig;
  {
    ShowMessage(
  '.N�mero NFSe : '+'|'+edtNumeroNFSe.Text+'|'+chr(10)+
  '.N�mero RPS  : '+edtNumeroRPS.Text    +chr(10)+
  '.S�rie RPS   : '+edtSerieRPS.Text     +chr(10)+
  '.Tipo RPS    : '+edtTipoRPS.Text      +chr(10)+
  '.Protocolo   : '+edtNumProtocolo.Text);
  }

    if Length(AllTrim(edtNumeroNFSe.Text)) > 12 then
    begin
      NFSe.Consultar(AllTrim(edtNumeroNFSe.Text), '', '', '', '');
    end else
    begin
      if (sCidade = 'SERRAES') then
      begin
        NFSe.Consultar('', '', '', '', edtNumProtocolo.Text);
      end
      else
        NFSe.Consultar(edtNumeroNFSe.Text, edtNumeroRPS.Text, edtSerieRPS.Text, edtTipoRPS.Text, edtNumProtocolo.Text);
    end;

    Sleep(1000);

    getRetornoV2Tipado;
    getRetornoV2Json;
  except
  end;
end;

procedure TFEmissorNFSe.btnCancelarClick(Sender: TObject);
var
  sResposta: String;
begin
  try
    sResposta := NFSe.CancelarNota(edtChaveCancelamento.Text);
    getRetornoV2Tipado;
    getRetornoV2Json;
  except
  end;
end;

//procedure TfrmExemplo.getRetornoTomadasV2Json;
//begin
//  mmJson.Clear;
//  mmJson.Lines.Add(NFSe.RetornoJsonTomadas);
//end;
{
procedure TfrmExemplo.getRetornoTomadasV2Tipado;
var
  i: Integer;
begin
  mmTipado.Clear;

  for i := 0 to NFSe.RetornoWSNotasTomadas.Count - 1 do
  begin
    mmTipado.Lines.Add('Status: ' + NFSe.RetornoWSNotasTomadas.Items[i].Status);
    mmTipado.Lines.Add('CNPJ: ' + NFSe.RetornoWSNotasTomadas.Items[i].CNPJ);
    mmTipado.Lines.Add('Inscricao Municipal: ' + NFSe.RetornoWSNotasTomadas.Items[i].InscricaoMunicipal);
    mmTipado.Lines.Add('Serie do RPS: ' + NFSe.RetornoWSNotasTomadas.Items[i].SerieRps);
    mmTipado.Lines.Add('Número do RPS: ' + NFSe.RetornoWSNotasTomadas.Items[i].NumeroRps);
    mmTipado.Lines.Add('Número da NFS-e: ' + NFSe.RetornoWSNotasTomadas.Items[i].NumeroNFSe);
    mmTipado.Lines.Add('Data de Emissão: ' + NFSe.RetornoWSNotasTomadas.Items[i].DataEmissaoNFSe);
    mmTipado.Lines.Add('Código de Verificação: ' + NFSe.RetornoWSNotasTomadas.Items[i].CodVerificacao);
    mmTipado.Lines.Add('Situação: ' + NFSe.RetornoWSNotasTomadas.Items[i].Situacao);
    mmTipado.Lines.Add('Data De Cancelamento: ' + NFSe.RetornoWSNotasTomadas.Items[i].DataCancelamento);
    mmTipado.Lines.Add('Chave de Cancelamento: ' + NFSe.RetornoWSNotasTomadas.Items[i].ChaveCancelamento);
    mmTipado.Lines.Add('Tipo: ' + NFSe.RetornoWSNotasTomadas.Items[i].Tipo);
    mmTipado.Lines.Add('Motivo: ' + NFSe.RetornoWSNotasTomadas.Items[i].Motivo);

    mmTipado.Lines.Add('ValorServicos: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorServicos);
    mmTipado.Lines.Add('ValorDeducoes: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorDeducoes);
    mmTipado.Lines.Add('ValorPis: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorPis);
    mmTipado.Lines.Add('ValorCofins: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorCofins);
    mmTipado.Lines.Add('ValorInss: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorInss);
    mmTipado.Lines.Add('ValorIr: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorIr);
    mmTipado.Lines.Add('ValorCsll: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorCsll);
    mmTipado.Lines.Add('AliquotaIss: ' + NFSe.RetornoWSNotasTomadas.Items[i].AliquotaIss);
    mmTipado.Lines.Add('ValorIss: ' + NFSe.RetornoWSNotasTomadas.Items[i].ValorIss);
    mmTipado.Lines.Add('IssRetido: ' + NFSe.RetornoWSNotasTomadas.Items[i].IssRetido);
    mmTipado.Lines.Add('Data de Autorização: ' + NFSe.RetornoWSNotasTomadas.Items[i].DataAutorizacao);

    mmTipado.Lines.Add('RazaoSocialPrestador: ' + NFSe.RetornoWSNotasTomadas.Items[i].RazaoSocialPrestador);
    mmTipado.Lines.Add('EnderecoPrestador' + NFSe.RetornoWSNotasTomadas.Items[i].EnderecoPrestador);
    mmTipado.Lines.Add('NumeroPrestador' + NFSe.RetornoWSNotasTomadas.Items[i].NumeroPrestador);
    mmTipado.Lines.Add('ComplementoPrestador' + NFSe.RetornoWSNotasTomadas.Items[i].ComplementoPrestador);
    mmTipado.Lines.Add('BairroPrestador' + NFSe.RetornoWSNotasTomadas.Items[i].BairroPrestador);
    mmTipado.Lines.Add('CodigoCidadePrestador' + NFSe.RetornoWSNotasTomadas.Items[i].CodigoCidadePrestador);
    mmTipado.Lines.Add('CepPrestador' + NFSe.RetornoWSNotasTomadas.Items[i].CepPrestador);
    mmTipado.Lines.Add('CpfCnpjTomador' + NFSe.RetornoWSNotasTomadas.Items[i].CpfCnpjTomador);
    mmTipado.Lines.Add('InscMunicipalTomador' + NFSe.RetornoWSNotasTomadas.Items[i].InscMunicipalTomador);
    mmTipado.Lines.Add('RazaoSocialTomador' + NFSe.RetornoWSNotasTomadas.Items[i].RazaoSocialTomador);
    mmTipado.Lines.Add('EnderecoTomador' + NFSe.RetornoWSNotasTomadas.Items[i].EnderecoTomador);
    mmTipado.Lines.Add('NumeroTomador' + NFSe.RetornoWSNotasTomadas.Items[i].NumeroTomador);
    mmTipado.Lines.Add('ComplementoTomador' + NFSe.RetornoWSNotasTomadas.Items[i].ComplementoTomador);
    mmTipado.Lines.Add('BairroTomador' + NFSe.RetornoWSNotasTomadas.Items[i].BairroTomador);
    mmTipado.Lines.Add('CodigoCidadeTomador' + NFSe.RetornoWSNotasTomadas.Items[i].CodigoCidadeTomador);
    mmTipado.Lines.Add('CepTomador' + NFSe.RetornoWSNotasTomadas.Items[i].CepTomador);
    mmTipado.Lines.Add('EmailTomador' + NFSe.RetornoWSNotasTomadas.Items[i].EmailTomador);
    mmTipado.Lines.Add('TelefoneTomador' + NFSe.RetornoWSNotasTomadas.Items[i].TelefoneTomador);
    mmTipado.Lines.Add('ItemListaServico' + NFSe.RetornoWSNotasTomadas.Items[i].ItemListaServico);
    mmTipado.Lines.Add('CodigoCNAE' + NFSe.RetornoWSNotasTomadas.Items[i].CodigoCNAE);
    mmTipado.Lines.Add('CodTributacaoMunicipio' + NFSe.RetornoWSNotasTomadas.Items[i].CodTributacaoMunicipio);
    mmTipado.Lines.Add('CodigoCidadePrestacao' + NFSe.RetornoWSNotasTomadas.Items[i].CodigoCidadePrestacao);
    mmTipado.Lines.Add('DiscriminacaoServico' + NFSe.RetornoWSNotasTomadas.Items[i].DiscriminacaoServico);
    mmTipado.Lines.Add('XML: ' + NFSe.RetornoWSNotasTomadas.Items[i].Xml);

    mmTipado.Lines.Add('');
    mmTipado.Lines.Add('================================================');
    mmTipado.Lines.Add('');
  end;
end;
}

procedure TFEmissorNFSe.btnAtualizaArquivosClick(Sender: TObject);
begin
  try
    NFSe.AtualizarArquivos;
    if FileExists(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG')) then
    begin
      Image1.Picture.LoadFromFile(Pchar(sAtual+'\NFSE\Templates\Impressao\Brasoes\'+Alltrim(edtCidade.Text)+'.JPG'));
    end;
  except
    on e:exception do
      ShowMessage('Erro ao Atualiza Arquivos: '+e.Message);
  end;
end;

procedure TFEmissorNFSe.btnListarCidadesClick(Sender: TObject);
begin
  mmXMLEnvio.Text := NFSe.ConsultarCidadesHomologadas;
end;

procedure TFEmissorNFSe.FormClose(Sender: TObject; var Action: TCloseAction);
var
  F: TextFile;
begin
  {Mauricio Parizotto 2025-01-22}
  //while FileExists(Pchar(sAtual+'\NFSE\ret.txt')) do
  if FileExists(Pchar(sAtual+'\NFSE\ret.txt')) then
  begin
    DeleteFile(Pchar(sAtual+'\NFSE\ret.txt'));
    Sleep(100);
  end;

  AssignFile(F,pChar(sAtual+'\NFSE\ret.txt'));  // Direciona o arquivo F para EXPORTA.TXT
  Rewrite(F);

  Write(F,smmXML);
  CloseFile(F);
end;

procedure TFEmissorNFSe.Button1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(sAtual+'\nfseConfig.ini');

  Mais1Ini.WriteString('NFSE','ParametrosExtras',pChar('Login='+LabeledEdit1.Text+';Senha='+LabeledEdit2.Text));
  Mais1Ini.WriteString('NFSE','NomeCertificado',pChar(cbListaCertificados.Text));

  if RadioButton1.Checked then
  begin
    Mais1Ini.WriteString('NFSE','Ambiente','2');
  end else
  begin
    Mais1Ini.WriteString('NFSE','Ambiente','1');
  end;

  Mais1ini.Free;

  Close;
end;

procedure TFEmissorNFSe.RadioButton1Click(Sender: TObject);
begin
  RadioButton2.Checked := False;
end;

procedure TFEmissorNFSe.RadioButton2Click(Sender: TObject);
begin
  RadioButton1.Checked := False;
end;

procedure TFEmissorNFSe.Button2Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  Mais1ini := TIniFile.Create(sAtual+'\nfseConfig.ini');

  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivadorCultural'     ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','IncentivadorCultural'     ,'2');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','RegimeEspecialTributacao' ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','RegimeEspecialTributacao' ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','NaturezaTributacao'       ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','NaturezaTributacao'       ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','IncentivoFiscal'          ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','IncentivoFiscal'          ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','TipoTributacao'           ,'6');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','ExigibilidadeISS'         ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','ExigibilidadeISS'         ,'1');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','Operacao'                 ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','Operacao'                 ,'A');
  if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','CodigoCnae'               ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','CodigoCnae'               ,''); // Sandro Silva 2023-02-09 if Mais1Ini.ReadString('Informacoes obtidas na prefeitura','CodigoCnae'               ,'') = '' then Mais1Ini.WriteString('Informacoes obtidas na prefeitura','CodigoCnae'               ,'6203100');

  Mais1ini.EraseSection('MAIL');
  Mais1ini.EraseSection('tx2');

  Mais1ini.Free;

  Application.CreateForm(TFConfiguracaoNFSe, FConfiguracaoNFSe);
  FConfiguracaoNFSe.ShowModal;
  FreeAndNil(FConfiguracaoNFSe);
  
  Close;
end;

procedure TFEmissorNFSe.ConfiguraCredencialTecnospeed;
var
  CredencialTecnospeed: TCredenciaisTecnospeed;
begin
  NFSe.ConfigurarSoftwareHouse(edtCNPJSoftwareHouse.Text,edtTokenSoftwareHouse.Text);

  try
    CredencialTecnospeed := TCredenciaisTecnospeed.Create;
    CredencialTecnospeed.PrivateKey := CHAVE_CIFRAR;
    CredencialTecnospeed.LeCredencial(FEmissorNFSe.sAtual);

    if CredencialTecnospeed.CNJP <> '' then
      NFSe.ConfigurarSoftwareHouse(CredencialTecnospeed.CNJP, CredencialTecnospeed.Token);

    FreeAndNil(CredencialTecnospeed);
  except
  end;
end;

procedure TFEmissorNFSe.FormActivate(Sender: TObject);
begin
  if FModoOperacao <> tmoConfiguracao then
    FecharAplicacao(ExtractFileName(Application.ExeName));
end;

function TFEmissorNFSe.ExtrairRazaoSocialPrestador(
  sl: TStringList): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to sl.Count do
  begin
    if Pos('RazaoSocialPrestador=', sl.Strings[i]) = 1 then
    begin
      Result := sl.Strings[i];
      Result := Copy(Result, Pos('=', Result) + 1, Length(Result));
      Break;
    end;
  end;
end;

end.


