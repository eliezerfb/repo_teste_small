// Cadastro Emitente
unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Mask, SMALL_DBEdit, ExtCtrls
  ,ShellApi, Grids,
  DBGrids, smallfunc_xe, strutils,
  WinTypes, WinProcs, IniFiles, Buttons, DB, ComCtrls, Clipbrd, OleCtrls, SHDocVw, Registry,
  IBCustomDataSet;

type
  TForm17 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit2: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    SMALL_DBEdit6: TSMALL_DBEdit;
    SMALL_DBEdit7: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    Label10: TLabel;
    SMALL_DBEdit10: TSMALL_DBEdit;
    Label11: TLabel;
    SMALL_DBEdit11: TSMALL_DBEdit;
    Label14: TLabel;
    SMALL_DBEdit12: TSMALL_DBEdit;
    Label15: TLabel;
    SMALL_DBEdit13: TSMALL_DBEdit;
    Image2: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ComboBox7: TComboBox;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Button2: TBitBtn;
    Button1: TBitBtn;
    dbgPesquisa: TDBGrid;
    WebBrowser3: TWebBrowser;
    Button4: TBitBtn;
    CheckBox1: TCheckBox;
    ibdMunicipios: TIBDataSet;
    ibdMunicipiosCODIGO: TIBStringField;
    ibdMunicipiosNOME: TIBStringField;
    ibdMunicipiosUF: TIBStringField;
    ibdMunicipiosREGISTRO: TIBStringField;
    DSMunicipios: TDataSource;
    DSEmitente: TDataSource;
    ibdEmitente: TIBDataSet;
    ibdEmitenteCGC: TIBStringField;
    ibdEmitenteNOME: TIBStringField;
    ibdEmitenteCONTATO: TIBStringField;
    ibdEmitenteENDERECO: TIBStringField;
    ibdEmitenteCOMPLE: TIBStringField;
    ibdEmitenteCEP: TIBStringField;
    ibdEmitenteMUNICIPIO: TIBStringField;
    ibdEmitenteESTADO: TIBStringField;
    ibdEmitenteIE: TIBStringField;
    ibdEmitenteIM: TIBStringField;
    ibdEmitenteTELEFO: TIBStringField;
    ibdEmitenteEMAIL: TIBStringField;
    ibdEmitenteHP: TIBStringField;
    ibdEmitenteCOPE: TFloatField;
    ibdEmitenteRESE: TFloatField;
    ibdEmitenteCVEN: TFloatField;
    ibdEmitenteIMPO: TFloatField;
    ibdEmitenteLUCR: TFloatField;
    ibdEmitenteICME: TFloatField;
    ibdEmitenteICMS: TFloatField;
    ibdEmitenteCRT: TIBStringField;
    ibdEmitenteCNAE: TIBStringField;
    ibdEmitenteREGISTRO: TIBStringField;
    ibdEmitenteENCRYPTHASH: TIBStringField;
    ibdEmitenteLICENCA: TIBStringField;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit4Enter(Sender: TObject);
    procedure SMALL_DBEdit6Enter(Sender: TObject);
    procedure dbgPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPesquisaDblClick(Sender: TObject);
    procedure SMALL_DBEdit4Change(Sender: TObject);
    procedure SMALL_DBEdit7Exit(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ibdEmitenteESTADOSetText(Sender: TField; const Text: String);
    procedure ibdEmitenteCGCSetText(Sender: TField; const Text: String);
    procedure ibdEmitenteAfterPost(DataSet: TDataSet);
    procedure ibdEmitenteBeforePost(DataSet: TDataSet);
    procedure ibdEmitenteBeforeInsert(DataSet: TDataSet);
    procedure ibdEmitenteNewRecord(DataSet: TDataSet);
    procedure ibdEmitenteDeleteError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ibdEmitenteEditError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ibdEmitentePostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ibdEmitenteUpdateError(DataSet: TDataSet; E: EDatabaseError;
      UpdateKind: TUpdateKind; var UpdateAction: TIBUpdateAction);
    procedure ibdEmitenteMUNICIPIOSetText(Sender: TField;
      const Text: String);
  private
    function RetornarWhereMunicipio(AcMunicipio: String): String;
  public
    { Public declarations }
  end;

var
  Form17: TForm17;

implementation

uses Unit7, Unit10, Unit19, Mais, uListaCnaes, Mais3, uDialogs;

{$R *.DFM}

procedure TForm17.Button1Click(Sender: TObject);
begin
  try
    dbgPesquisa.Visible    := False;
    DSEmitente.DataSet.Post;

    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    AgendaCommit(True);
    Commitatudo(True); // SQL - Commando
    AbreArquivos(True);
    Screen.Cursor := crDefault; // Cursor de Aguardo

    Form1.RegistrodoPrograma(False);
  except
  end;

  Close;
end;

procedure TForm17.FormActivate(Sender: TObject);
begin
  if Form1.iReduzida = 2 then
  begin
    CheckBox1.Visible := True;
    CheckBox1.Checked := True;
  end else
  begin
    CheckBox1.Visible := False;
  end;

  Form17.Tag := 0;

  Button4.Visible := False;
  Button2.Visible := True;
  Button1.Visible := True;

  try
    if DSEmitente.DataSet.Active then
    begin
      DSEmitente.DataSet.First;
      try
        if DSEmitente.DataSet.Eof then
          DSEmitente.DataSet.Append
        else
          DSEmitente.DataSet.Edit;
      except
      end;

      if DSEmitente.DataSet.FieldByName('ESTADO').AsString = '  ' then
        DSEmitente.DataSet.FieldByName('ESTADO').AsString := '';

      Form7.bFlag := False;
      DSEmitente.DataSet.Active := True;
      DSEmitente.DataSet.Edit;
      if SMALL_DBEdit7.CanFocus then SMALL_DBEdit7.SetFocus;

      Image2.Picture.Bitmap :=  Form7.imgVisualizar.Picture.Bitmap;
    end;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit7KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_emitente.htm')));
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;

  if dbgPesquisa.Visible then
  begin
    if (Key = VK_UP) or (Key = VK_DOWN) then
    begin
      if dbgPesquisa.CanFocus then
        dbgPesquisa.SetFocus;
    end;
  end else
  begin
    if Key = VK_UP then
    begin
      Perform(Wm_NextDlgCtl,1,0);
    end;
    if Key = VK_DOWN then
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end;
  end;  
end;

procedure TForm17.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    DSEmitente.DataSet.Cancel;
    Form1.AvisoConfig(True);
  except
  end;

  if Form1.iReduzida = 99 then
  begin
    Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
    Winexec('TASKKILL /F /IM small22.exe' , SW_HIDE );
    Winexec('TASKKILL /F /IM nfe.exe' , SW_HIDE );
  end;
end;

procedure TForm17.Button2Click(Sender: TObject);
begin
  dbgPesquisa.Visible    := False;
  //Form14.Button2Click(Sender);
  Form19.ShowModal;
end;

procedure TForm17.Image2Click(Sender: TObject);
begin
  Form7.sModulo := 'EMITENTE';

  Form7.dbGrid1.Datasource     := DSEmitente;
  Form7.ArquivoAberto          := DSEmitente.Dataset;
  Form7.TabelaAberta           := TIBDataSet(DSEmitente.DataSet);
  Form7.iCampos                := 12;

  Form10.Image203Click(Sender);
end;

procedure TForm17.ComboBox1Change(Sender: TObject);
begin
  DSEmitente.DataSet.FieldByName('CRT').AsString := Copy(ComboBox1.Items[ComboBox1.ItemIndex],1,1);
end;

procedure TForm17.ComboBox7Change(Sender: TObject);
begin
  DSEmitente.DataSet.FieldByName('CNAE').AsString := Copy(ComboBox7.Items[ComboBox7.ItemIndex],1,7);
end;

procedure TForm17.FormShow(Sender: TObject);
var
  I : Integer;
begin
  Button1.Left  := Panel2.Width - Button1.Width - 10;
  Button2.Left  := Button1.Left - 140;

  Commitatudo(True); // SQL - Commando
  AbreArquivos(True);

  ibdEmitente.Close;
  ibdEmitente.Open;

  // CRT
  for I := 0 to ComboBox1.Items.Count -1 do
  begin
    if Copy(ComboBox1.Items[I],1,1) = AllTrim(DSEmitente.DataSet.FieldByName('CRT').AsString) then
    begin
      ComboBox1.ItemIndex := I;
    end;
  end;

  // CNAE
  for I := 0 to ComboBox7.Items.Count -1 do
  begin
    if Copy(ComboBox7.Items[I],1,7) = AllTrim(DSEmitente.DataSet.FieldByName('CNAE').AsString) then
    begin
      ComboBox7.ItemIndex := I;
    end;
  end;

  DSEmitente.DataSet.Edit;

  if AllTrim(DSEmitente.DataSet.FieldByName('CGC').AsString) = '' then
  begin
    if Form1.GetCNPJCertificado(Form7.spdNFe.NomeCertificado.Text) <> '' then
    begin
      //Mauricio Parizotto 2023-07-10
      Form7.spdNFe.CNPJ := LimpaNumero(Form1.GetCNPJCertificado(Form7.spdNFe.NomeCertificado.Text));

      if not (DSEmitente.DataSet.State in ([dsEdit, dsInsert])) then
        DSEmitente.DataSet.Edit;

      SMALL_DBEdit7.Text := FormataCpfCgc(Form1.GetCNPJCertificado(Form7.spdNFe.NomeCertificado.Text));
      ibdEmitenteCGCSetText(DSEmitente.DataSet.FieldByName('CGC'),SMALL_DBEdit7.Text);
    end;
  end;
end;

procedure TForm17.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('config_emitente.htm')));
  if Key = VK_RETURN then
  begin
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TForm17.SMALL_DBEdit4Enter(Sender: TObject);
begin
  try
    if Length(AllTrim(DSEmitente.DataSet.FieldByName('ESTADO').AsString)) <> 2 then
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Clear;
      ibdMunicipios.SelectSQL.Add('Select');
      ibdMunicipios.SelectSQL.Add('*');
      ibdMunicipios.SelectSQL.Add('from MUNICIPIOS');
      if DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString <> EmptyStr then
        ibdMunicipios.SelectSQL.Add('where (UPPER(NOME) LIKE ' + QuotedStr(RetornarWhereMunicipio(DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString)) + ')');
      ibdMunicipios.SelectSQL.Add('Order by NOME');; // Procura em todo o Pais o estado está em branco
      ibdMunicipios.Open;
    end else
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Clear;
      ibdMunicipios.SelectSQL.Add('Select *');
      ibdMunicipios.SelectSQL.Add('From MUNICIPIOS');
      ibdMunicipios.SelectSQL.Add('Where (UF='+QuotedStr(DSEmitente.DataSet.FieldByName('ESTADO').AsString) + ')');
      if DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString <> EmptyStr then
        ibdMunicipios.SelectSQL.Add('AND (UPPER(NOME) LIKE ' + QuotedStr(RetornarWhereMunicipio(DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString)) + ')');
      ibdMunicipios.SelectSQL.Add('Order by NOME'); // Procura dentro do estado
      ibdMunicipios.Open;
    end;

    ibdMunicipios.Locate('NOME',AllTrim(DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString),[loCaseInsensitive, loPartialKey]);

    dbgPesquisa.Height     := 200;
    dbgPesquisa.Columns[0].Width := dbgPesquisa.Width - 20; 
    dbgPesquisa.DataSource := DSMunicipios; // Municipios
    dbgPesquisa.Visible    := True;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit6Enter(Sender: TObject);
begin
  if dbgPesquisa.Visible then
  begin
    if (DSEmitente.DataSet.State in ([dsEdit, dsInsert])) then
    begin
      if AllTrim(ibdMunicipiosNOME.AsString) <> '' then
      begin
        DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString := ibdMunicipiosNOME.AsString;
      end;
    end;
    
    dbgPesquisa.Visible    := False;
  end;
end;

procedure TForm17.dbgPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    dbgPesquisaDblClick(Sender);
  end;
end;

procedure TForm17.dbgPesquisaDblClick(Sender: TObject);
begin
  try
    DSEmitente.DataSet.FieldByName('MUNICIPIO').AsString := ibdMunicipiosNOME.AsString;
    DSEmitente.DataSet.FieldByName('ESTADO').AsString    := ibdMunicipiosUF.AsString;

    if SMALL_DBEdit6.CanFocus then
      SMALL_DBEdit6.SetFocus;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit4Change(Sender: TObject);
begin
  try
    if (not dbgPesquisa.Visible) and (Form17.Visible) then
    //if (not dbgPesquisa.Visible) then
    begin
      SMALL_DBEdit4Enter(Sender);
    end;
  except
  end;

  try
    if Length(AllTrim(DSEmitente.DataSet.FieldByName('ESTADO').AsString)) = 2 then
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Text := ' Select * From MUNICIPIOS '+
                                      ' Where Upper(NOME) like '+QuotedStr(RetornarWhereMunicipio(SMALL_DBEdit4.Text))+' '+
                                      '   and UF='+QuotedStr(UpperCase(DSEmitente.DataSet.FieldByName('ESTADO').AsString))+
                                      ' Order by NOME';
      ibdMunicipios.Open;
    end else
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Text := ' Select * From MUNICIPIOS'+
                                      ' Where Upper(NOME) like '+QuotedStr(RetornarWhereMunicipio(SMALL_DBEdit4.Text))+' '+
                                      ' Order by NOME';
      ibdMunicipios.Open;
    end;
  except
  end;
end;

procedure TForm17.SMALL_DBEdit7Exit(Sender: TObject);
begin
  //Form7.ibDataSet13CGCSetText(DSEmitente.DataSet.FieldByName('CGC'),LimpaNumero(Form17.SMALL_DBEdit7.Text));
  ibdEmitenteCGCSetText(DSEmitente.DataSet.FieldByName('CGC'),LimpaNumero(Form17.SMALL_DBEdit7.Text));
end;

procedure TForm17.Button4Click(Sender: TObject);
begin
  Form17.Tag := 256;
  Button4.Visible := False;
end;

procedure TForm17.CheckBox1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
begin
  if not CheckBox1.Checked then
  begin
    if Application.MessageBox(Pchar(
      'Confirma que esta empresa NÃO é um Microempreendedor Individual (MEI)?'+
      Chr(10) +
      Chr(10) +
      'Continuar? Não é possível voltar esta opção.' +
      Chr(10))
      ,'Atenção',mb_YesNo + mb_DefButton1 + MB_ICONWARNING) = IDYES then
    begin
      CheckBox1.Visible := False;
      Form1.iReduzida          := 0;
      Mais1ini                 := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      Mais1Ini.WriteString('LICENCA','MEI','NAO');
      Mais1Ini.Free;
    end;
  end;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
  //Mauricio Parizotto 2023-03-23
  ComboBox7.Items.Clear;
  ComboBox7.Items.Text := getListaCnae;
  DSEmitente.DataSet := ibdEmitente;
end;

procedure TForm17.ibdEmitenteESTADOSetText(Sender: TField; const Text: String);
begin
  if (Pos('1'+UpperCase(Text)+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX21  21mg2')
     = 0) and (AllTrim(Text)<>'') then
  begin
    //ShowMessage('Estado inválido'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Estado inválido',msgAtencao);
    ibdEmitenteESTADO.AsString := UpperCase(ibdEmitenteESTADO.AsString);
  end else
  begin
    ibdEmitenteESTADO.AsString := UpperCase(Text);
  end;
end;

procedure TForm17.ibdEmitenteCGCSetText(Sender: TField; const Text: String);
var
  sRetorno : String;
  I: Integer;
begin
  if LimpaNumero(Text) <> '' then
  begin
    if CpfCgc(LimpaNumero(Text)) then
      ibdEmitenteCGC.AsString := ConverteCpfCgc(AllTrim(LimpaNumero(Text)))
    else
      //ShowMessage('CPF ou CNPJ inválido!'); Mauricio Parizotto 2023-10-25
      MensagemSistema('CPF ou CNPJ inválido!',msgAtencao);
  end
  else
    ibdEmitenteCGC.AsString := '';

  if (AllTrim(ibdEmitenteNOME.AsString) = '') and (AllTrim(LimpaNumero(ibdEmitenteCGC.AsString))<>'') then
  begin
    Screen.Cursor            := crHourGlass;

    try
      if (Length(LimpaNumero(ibdEmitenteCGC.AsString)) = 14) or (Length(LimpaNumero(ibdEmitenteCGC.AsString)) = 11) then
      begin
        sRetorno := ConsultaCadastro(ibdEmitenteCGC.AsString);

        if AllTrim(xmlNodeValue(sRetorno,'//xNome')) <> '' then
        begin
          ibdEmitenteIE.AsString       := xmlNodeValue(sRetorno,'//IE');
          ibdEmitenteESTADO.AsString   := xmlNodeValue(sRetorno,'//UF');
          ibdEmitenteNOME.AsString     := PrimeiraMaiuscula(ConverteAcentos(xmlNodeValue(sRetorno,'//xNome')));
          ibdEmitenteENDERECO.AsString := PrimeiraMaiuscula(ConverteAcentos(xmlNodeValue(sRetorno,'//xLgr')+', '+xmlNodeValue(sRetorno,'//nro') + ' ' + xmlNodeValue(sRetorno,'//xCpl')));
          ibdEmitenteCOMPLE.AsString   := PrimeiraMaiuscula((xmlNodeValue(sRetorno,'//xBairro')));
          ibdEmitenteCEP.AsString      := copy(xmlNodeValue(sRetorno,'//CEP'),1,5)+'-'+copy(xmlNodeValue(sRetorno,'//CEP'),6,3);
          ibdEmitenteCNAE.AsString     := xmlNodeValue(sRetorno,'//CNAE');

          for I := 0 to Form17.ComboBox7.Items.Count -1 do
          begin
            if Copy(Form17.ComboBox7.Items[I],1,7) = AllTrim(ibdEmitenteCNAE.AsString) then
            begin
              Form17.ComboBox7.ItemIndex := I;
            end;
          end;

          Form7.ibDataset99.Close;
          Form7.ibDataset99.SelectSql.Clear;
          Form7.ibDataset99.SelectSQL.Add('select * from MUNICIPIOS where CODIGO='+QuotedStr(xmlNodeValue(sRetorno,'//cMun'))+' ');
          Form7.ibDataset99.Open;

          ibdEmitenteMUNICIPIO.AsString := Form7.IBDataSet99.FieldByname('NOME').AsString;

          ComboBox1.ItemIndex    := 0;
          ibdEmitenteCRT.AsString := '1';
        end;
      end;
    except

    end;
  end;

  Screen.Cursor            := crDefault;
end;

procedure TForm17.ibdEmitenteAfterPost(DataSet: TDataSet);
begin
  AgendaCommit(True);
end;

procedure TForm17.ibdEmitenteBeforePost(DataSet: TDataSet);
begin
  AssinaRegistro('EMITENTE',DataSet, True);
end;

procedure TForm17.ibdEmitenteBeforeInsert(DataSet: TDataSet);
begin
  try
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSql.Clear;
    Form7.ibDataset99.SelectSql.Add('select gen_id(G_EMITENTE,1) from rdb$database');
    Form7.ibDataset99.Open;
    Form7.sProximo := strZero(StrToInt(Form7.ibDataSet99.FieldByname('GEN_ID').AsString),10,0);
    Form7.ibDataset99.Close;
  except
    Abort
  end;
end;

procedure TForm17.ibdEmitenteNewRecord(DataSet: TDataSet);
begin
  ibdEmitenteREGISTRO.AsString := Form7.sProximo;
end;

procedure TForm17.ibdEmitenteDeleteError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  Abort;
end;

procedure TForm17.ibdEmitenteEditError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  Abort;
end;

procedure TForm17.ibdEmitentePostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  DataSet.Cancel;
  Abort;
end;

procedure TForm17.ibdEmitenteUpdateError(DataSet: TDataSet;
  E: EDatabaseError; UpdateKind: TUpdateKind;
  var UpdateAction: TIBUpdateAction);
begin
  try
    if (ibdEmitenteCGC.AsString = CNPJ_SMALLSOFT) then
    begin
      // Comercial da Small está perdendo dados de contatos
      if AnsiContainsText(E.Message, 'deadlock') then
        Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Form7.smodulo + ' Conflito L23774 ' + RightStr(E.Message, 50),0,0) // Ato, Modulo, Usuário, Histórico, Valor
      else
        Audita('CONTATOS','SMALL', Senhas.UsuarioPub, Form7.smodulo + ' ' + Copy('Salvar contatos L23776 ' + E.Message, 1, 80),0,0); // Ato, Modulo, Usuário, Histórico, Valor
    end;
  except
  end;

  Abort;
end;

procedure TForm17.ibdEmitenteMUNICIPIOSetText(Sender: TField;
  const Text: String);
begin
  if (ibdMunicipiosNOME.AsString <> '') or (Trim(Text) <> '') then
  begin
    ibdEmitenteMUNICIPIO.AsString := Text;

    if Length(AllTrim(ibdEmitenteESTADO.AsString)) <> 2 then
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Clear;
      ibdMunicipios.SelectSQL.Add('select');
      ibdMunicipios.SelectSQL.Add('*');
      ibdMunicipios.SelectSQL.Add('from MUNICIPIOS');
      if ibdEmitenteMUNICIPIO.AsString <> EmptyStr then
        ibdMunicipios.SelectSQL.Add('where (UPPER(NOME) LIKE ' + QuotedStr(RetornarWhereMunicipio(ibdEmitenteMUNICIPIO.AsString)) + ')');
      ibdMunicipios.SelectSQL.Add('order by NOME'); // Procura em todo o Pais o estado está em branco
      ibdMunicipios.Open;
    end else
    begin
      ibdMunicipios.Close;
      ibdMunicipios.SelectSQL.Clear;
      ibdMunicipios.SelectSQL.Add('select');
      ibdMunicipios.SelectSQL.Add('*');
      ibdMunicipios.SelectSQL.Add('from MUNICIPIOS');
      ibdMunicipios.SelectSQL.Add('where (UF='+QuotedStr(ibdEmitenteESTADO.AsString)+ ')');
      if ibdEmitenteMUNICIPIO.AsString <> EmptyStr then
        ibdMunicipios.SelectSQL.Add('AND (UPPER(NOME) LIKE ' + QuotedStr(RetornarWhereMunicipio(ibdEmitenteMUNICIPIO.AsString)) + ')');
      ibdMunicipios.SelectSQL.Add('order by NOME'); // Procura dentro do estado
      ibdMunicipios.Open;
    end;

    ibdMunicipios.Locate('NOME',AllTrim(Text),[loCaseInsensitive, loPartialKey]);

    if Pos(AnsiUpperCase(AllTrim(Text)), AnsiUpperCase(ibdMunicipiosNOME.AsString)) <> 0 then
    begin
      if not dbgPesquisa.Focused then
      begin
        ibdEmitenteMUNICIPIO.AsString := ibdMunicipiosNOME.AsString;
        if (not Self.Showing) or (not dbgPesquisa.Visible) then
        begin
          if ibdEmitenteESTADO.AsString = '' then
            ibdEmitenteESTADO.AsString := ibdMunicipiosUF.AsString;
        end;
      end;
    end;
  end else
  begin
    ibdEmitenteMUNICIPIO.AsString := Text;
  end;
end;

function TForm17.RetornarWhereMunicipio(AcMunicipio: String): String;
begin
  Result := UpperCase(AcMunicipio);

  if Length(Result) < 40 then
    Result := Result + '%';
end;

end.





