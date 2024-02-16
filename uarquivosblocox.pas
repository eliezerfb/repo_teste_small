unit uarquivosblocox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons
  , IBDatabase, DB, IBCustomDataSet, IBQuery, ComCtrls, Grids, DBGrids
  , StrUtils, Clipbrd, ShellApi
  , ufuncoesfrente
  , ufuncoesfrentepaf
  , ufuncoesblocox, uclassetiposblocox, upafecfmensagens
  , smallfunc_xe
  , xmldom, XMLIntf, msxmldom, msxml, Menus
  , LbCipher,
  LbClass;

type
  TFArquivosBlocoX = class(TForm)
    DSBLOCOX: TDataSource;
    Label5: TLabel;
    Label2: TLabel;
    reMensagem: TRichEdit;
    cbTipo: TComboBox;
    Label1: TLabel;
    cbSituacao: TComboBox;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    PopupMenu1: TPopupMenu;
    VisualizarXMLdeEnvio1: TMenuItem;
    N1: TMenuItem;
    VisualizarXMLdeRespostadaSEFAZ1: TMenuItem;
    N2: TMenuItem;
    RecriarXMLparaEnvio1: TMenuItem;
    N3: TMenuItem;
    ConsultaRecibo1: TMenuItem;
    N7: TMenuItem;
    Corrigir1: TMenuItem;
    N4: TMenuItem;
    RecuperarRecibodeXMLjenviado1: TMenuItem;
    N6: TMenuItem;
    Gravarnmerodorecibo1: TMenuItem;
    N5: TMenuItem;
    Refresh1: TMenuItem;
    N8: TMenuItem;
    Verificarpendncias1: TMenuItem;
    N9: TMenuItem;
    ransmitirpendentes1: TMenuItem;
    N10: TMenuItem;
    SomarTag1: TMenuItem;
    N12: TMenuItem;
    GerarXMLRZOmisso1: TMenuItem;
    GerarXMLEstoqueomisso1: TMenuItem;
    N13: TMenuItem;
    ImportarAC17041: TMenuItem;
    N14: TMenuItem;
    Anlisedomovimento1: TMenuItem;
    N16: TMenuItem;
    ConsultaPendnciaUsuriosPAF1: TMenuItem;
    IBDSBLOCOX: TIBDataSet;
    Label4: TLabel;
    Edit1: TEdit;
    edCredenciamentoDesatualizadoXML: TEdit;
    lbCredenciamentoDesatualizadoXML: TLabel;
    IBQREDUCOES: TIBQuery;
    LbBlowfish1: TLbBlowfish;
    chkCrzNaoGerado: TCheckBox;
    edEmitente: TEdit;
    IBTransaction: TIBTransaction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnOmisso: TBitBtn;
    PopupMenuOmissos: TPopupMenu;
    XMLReduoZ1: TMenuItem;
    XMLEstoque1: TMenuItem;
    N11: TMenuItem;
    IBDatabase: TIBDatabase;
    Reprocessararquivos1: TMenuItem;
    N15: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTipoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbSituacaoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VisualizarXMLdeEnvio1Click(Sender: TObject);
    procedure VisualizarXMLdeRespostadaSEFAZ1Click(Sender: TObject);
    procedure RecriarXMLparaEnvio1Click(Sender: TObject);
    procedure ConsultaRecibo1Click(Sender: TObject);
    procedure Corrigir1Click(Sender: TObject);
    procedure IBDSBLOCOXAfterOpen(DataSet: TDataSet);
    procedure IBDSBLOCOXAfterScroll(DataSet: TDataSet);
    procedure RecuperarRecibodeXMLjenviado1Click(Sender: TObject);
    procedure Gravarnmerodorecibo1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure Verificarpendncias1Click(Sender: TObject);
    procedure ransmitirpendentes1Click(Sender: TObject);
    procedure SomarTag1Click(Sender: TObject);
    procedure GerarXMLRZOmisso1Click(Sender: TObject);
    procedure GerarXMLEstoqueomisso1Click(Sender: TObject);
    procedure ConsultaPendnciaUsuriosPAF1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cbSituacaoChange(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
    procedure btnOmissoClick(Sender: TObject);
    procedure Reprocessararquivos1Click(Sender: TObject);
  private
    { Private declarations }
    FTipo: String;
    // Sandro Silva 2020-06-18  FIBTransactionOrigem: TIBTransaction;
    FsAtual: String;
    FEmitente: TEmitente;
    BlocoX: TSmallBlocoX;
    sArquivo, sPasta: String;
    FCaminhoBanco: String;
    procedure SetTipo(const Value: String);
    procedure SelecionaDados;
    procedure SetsAtual(const Value: String);
    procedure VisualizarXml(Field: TField);
    procedure GerarXmlEnvio;
    function Credenciamento: String;//(DataSet: TDataSet);
    function BlocoxSalvarBanco(sTipo: String; sSerie: String;
      dtDataHora: TDateTime; XML: WideString; dtReferencia: TDate): String;
    function GravaRecibo(sRecibo: String; dtDatareferencia: TDate;
      sTipo: String; sSerie: String): Boolean;
    procedure SomarTag;
    procedure GeraXMLReducao(sCRZ, sCaixa: String);
    procedure SetCaminhoBanco(const Value: String);
    procedure ConectaBanco(sCaminho: String);
  public
    { Public declarations }
    property Tipo: String read FTipo write SetTipo;
    property sAtual: String read FsAtual write SetsAtual;
    property CaminhoBanco: String read FCaminhoBanco write SetCaminhoBanco;
  end;

var
  FArquivosBlocoX: TFArquivosBlocoX;

implementation

uses uconstantes_chaves_privadas;

{$R *.dfm}

function BloquearCtrl_Del(Key: Word; Shift: TShiftState): Word;
begin
  if (Shift = [ssctrl]) and (Key = VK_Delete) then
    Result := 0
  else
    Result := Key;
end;

procedure TFArquivosBlocoX.SetTipo(const Value: String);
begin
  FTipo := Value;

  if AnsiUpperCase(FTipo) = 'ESTOQUE' then
    cbTipo.ItemIndex := cbTipo.Items.IndexOf('Estoque')
  else
    if AnsiUpperCase(FTipo) = 'REDUCAO' then
      cbTipo.ItemIndex := cbTipo.Items.IndexOf('Redução')
    else
      cbTipo.ItemIndex := cbTipo.Items.IndexOf('Todos');

end;

procedure TFArquivosBlocoX.FormCreate(Sender: TObject);
begin
  BlocoX := TSmallBlocoX.Create(Self); // Sandro Silva 2020-06-22 BlocoX := TSmallBlocoX.Create(nil);
  cbSituacao.ItemIndex := cbSituacao.Items.IndexOf('Pendente');

  // Ajusta as dimensões do form
  ClientWidth  := Screen.Width;
  ClientHeight := Screen.Height - 40; // Desconta a altura da barra de tarefas

  Top    := 0;
  Left   := 0;

  DBGrid1.Columns.Clear;

  sPasta := CHAVE_CIFRAR;

  sArquivo := NOME_ARQUIVO_AUXILIAR_CRIPTOGRAFADO_PAF_ECF; // Sandro Silva 2022-12-02 Unochapeco 'arquivoauxiliarcriptografadopafecfsmallsoft.ini';

end;

procedure TFArquivosBlocoX.FormResize(Sender: TObject);
begin
  if DBGrid1.DataSource.DataSet.Active then
    AjustaLarguraDBGrid(DBGrid1);
end;

procedure TFArquivosBlocoX.FormShow(Sender: TObject);
begin
  SelecionaDados;
end;

procedure TFArquivosBlocoX.SelecionaDados;
var
  sFiltroTipo: String;
  sFiltroSituacao: String;
begin
  sFiltroTipo     := ' ';
  sFiltroSituacao := ' ';
  if AnsiUpperCase(cbTipo.Text) <>  'TODOS' then
  begin
    if AnsiUpperCase(cbTipo.Text) =  'ESTOQUE' then
      sFiltroTipo := ' and BX.TIPO = ''ESTOQUE'' ';
    if AnsiUpperCase(cbTipo.Text) =  'REDUÇÃO' then
      sFiltroTipo := ' and BX.TIPO = ''REDUCAO'' ' ;
  end;
  if AnsiUpperCase(cbSituacao.Text) <>  'TODOS' then
  begin
    if AnsiUpperCase(cbSituacao.Text) =  'SUCESSO' then
      sFiltroSituacao := 'and (coalesce(BX.XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>1'' ) ';

    if AnsiUpperCase(cbSituacao.Text) =  'AGUARDANDO' then
      sFiltroSituacao := 'and (coalesce(BX.XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>0'' ) ';

    if AnsiUpperCase(cbSituacao.Text) =  'PENDENTE' then
      sFiltroSituacao := ' and (coalesce(BX.XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>1'' ) ' +
                         ' and (coalesce(BX.XMLRESPOSTA, '''') not containing ''<SituacaoProcessamentoCodigo>0'' ) ';
  end;

  IBDSBLOCOX.Close;
  IBDSBLOCOX.Transaction := IBTransaction;
  IBDSBLOCOX.SelectSQL.Text :=
    //'select * ' +
    //'from BLOCOX ' +
    'select R.PDV, R.CONTADORZ, BX.* ' +
    'from BLOCOX BX ' +
    'left join REDUCOES R on R.SERIE = BX.SERIE and R.DATA = BX.DATAREFERENCIA and (R.SMALL <> ''59'') and (R.SMALL <> ''65'') and (R.SMALL <> ''99'') ' + // Sandro Silva 2021-08-11 'left join REDUCOES R on R.SERIE = BX.SERIE and R.DATA = BX.DATAREFERENCIA and (R.SMALL <> ''59'') and (R.SMALL <> ''65'') ' +
    'where BX.REGISTRO is not null ' +
    sFiltroTipo +
    sFiltroSituacao +
    ' order by DATAREFERENCIA desc, DATAHORA';
  IBDSBLOCOX.Open;
end;

procedure TFArquivosBlocoX.cbTipoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelecionaDados;
end;

procedure TFArquivosBlocoX.cbSituacaoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelecionaDados;
end;

procedure TFArquivosBlocoX.SetsAtual(const Value: String);
begin
  FsAtual := Value;
end;

procedure TFArquivosBlocoX.DBGrid1DrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
var
  sFieldValue: String;
  R: TRect;
begin
  R := Rect;

  TDBGrid(Sender).Canvas.FillRect(Rect);

  if (gdFocused in State)
    and (Application.Active) // Para evitar que fique a celula do grid toda em branco quando trocar de aplicação
  then
  begin

  end
  else
  begin

    if (Pos('<SituacaoProcessamentoCodigo>0', Field.DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)then
      TDBGrid(Sender).Canvas.Font.Color  := clSilver
    else
      if (Pos('<SituacaoProcessamentoCodigo>1', Field.DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)then
        TDBGrid(Sender).Canvas.Font.Color  := COR_AZUL // Sandro Silva 2021-08-17 $00EAB231 // Azul
      else
        TDBGrid(Sender).Canvas.Font.Color  := clRed; // Sandro Silva 2017-09-29

  end;

  sFieldValue := Field.AsString;

  if (AnsiUpperCase(Field.FieldName) = 'XMLENVIO') or (AnsiUpperCase(Field.FieldName) = 'XMLRESPOSTA') then
  begin
    if Field.AsString <> '' then
      sFieldValue := Copy(Field.AsString, 1, 39) //  '<?xml version="1.0" encoding="utf-8" ?>'
    else
      sFieldValue := '';
    // Não precisa recorta o texto nas linhas acima Sandro Silva 2018-09-20  sFieldValue := Copy(sFieldValue, 1, iLarguraTexto);

  end;

  TDBGrid(Sender).Canvas.TextOut(R.Left + 2, R.Top + 2, sFieldValue);

end;

procedure TFArquivosBlocoX.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

    //ShowMessage('Teste 01 348'); // Sandro Silva 2020-06-22

  FreeAndNil(BlocoX);
end;

procedure TFArquivosBlocoX.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (chr(Key) in ['C', 'c']) then
  begin
    Clipboard.Free;
    Clipboard.AsText := (Sender as TDBGrid).SelectedField.AsString;
  end;
end;

procedure TFArquivosBlocoX.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := BloquearCtrl_Del(Key, Shift);
end;

procedure TFArquivosBlocoX.VisualizarXMLdeEnvio1Click(Sender: TObject);
begin
  VisualizarXml(DBGrid1.DataSource.DataSet.FieldByName('XMLENVIO'));
end;

procedure TFArquivosBlocoX.VisualizarXml(Field: TField);
var
  sArquivo: String;
begin
  if Field.AsString <> '' then
  begin
    sArquivo := ExtractFilePath(Application.ExeName) + Field.DataSet.FieldByName('TIPO').AsString + '_' + Field.DataSet.FieldByName('SERIE').AsString + '_' + AnsiUpperCase(Field.FieldName) + '_' + FormatDateTime('YYYYMMDDSSZZZ', Field.DataSet.FieldByName('DATAHORA').AsDateTime) + '.xml';
    TBlobField(Field).SaveToFile(sArquivo);
    Sleep(250);
    ShellExecute(0, 'open', pChar(sArquivo), '', '', SW_MAX);
  end;
end;

procedure TFArquivosBlocoX.VisualizarXMLdeRespostadaSEFAZ1Click(
  Sender: TObject);
begin
  VisualizarXml(DBGrid1.DataSource.DataSet.FieldByName('XMLRESPOSTA'));
end;

procedure TFArquivosBlocoX.RecriarXMLparaEnvio1Click(Sender: TObject);
begin
  GerarXmlEnvio;//(IBDSBLOCOX);
end;

procedure TFArquivosBlocoX.GerarXmlEnvio;//(DataSet: TDataSet);
var
  sRegistro: String;
  dtInicial, dtFinal: TDate;
begin
  if IBDSBLOCOX.Active then // if IBDatabase1.Connected then
  begin

    if IBDSBLOCOX.IsEmpty = False then
    begin
      IBDSBLOCOX.DisableControls;

      sRegistro := IBDSBLOCOX.FieldByName('REGISTRO').AsString;

      if AnsiContainsText(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>1') = False then
      begin

        if IBDSBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
        begin
          Blocox.XmlReducaoZ(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(FsAtual), AnsiString(IBDSBLOCOX.FieldByName('SERIE').AsString), AnsiString(IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsString), True, True, True)
        end;

        if IBDSBLOCOX.FieldByName('TIPO').AsString = 'ESTOQUE' then
        begin
          try
            dtFinal   := IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime;
            dtInicial := StrToDate('01/' + FormatDateTime('mm/yyyy', dtFinal));

            Blocox.XmlEstoqueOmisso(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(FsAtual), AnsiString(FormatDateTime('dd/mm/yyyy', dtInicial)), AnsiString(FormatDateTime('dd/mm/yyyy', dtFinal)), True, True, True, True);

          except
            on E: Exception do
            begin
              ShowMessage('<DataReferenica> inválida' + Char(13) + E.Message);
            end;
          end;
        end;

      end;

      IBDSBLOCOX.Transaction.Rollback;
      SelecionaDados;

      IBDSBLOCOX.Locate('REGISTRO', sRegistro, []);
      IBDSBLOCOX.EnableControls;
    end
    else
    begin
      IBDSBLOCOX.Transaction.Rollback;
      SelecionaDados;
    end;
  end;
end;

procedure TFArquivosBlocoX.ConsultaRecibo1Click(Sender: TObject);
var
  bTodas: Boolean;
begin
  bTodas := (Application.MessageBox(PWideChar('Consultar este XML e os demais listados com status AGUARDANDO?' + #13 + #13 + 'Tecle Não para consultar apenas do selecionado'), 'Atenção', MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) = ID_YES);
  DBGrid1.DataSource.DataSet.DisableControls; // Sandro Silva 2019-06-19
  while True do
  begin
    if AnsiContainsText(DBGrid1.DataSource.DataSet.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>0') then // 0: Aguardando
    begin
      if DBGrid1.DataSource.DataSet.FieldByName('RECIBO').AsString <> '' then
        Blocox.ConsultarRecibo(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(sAtual), AnsiString(DBGrid1.DataSource.DataSet.FieldByName('RECIBO').AsString));
    end;
    if bTodas then
      DBGrid1.DataSource.DataSet.Next;

    if (bTodas = False) or (DBGrid1.DataSource.DataSet.Eof) then
      Break;
  end;
  DBGrid1.DataSource.DataSet.EnableControls; // Sandro Silva 2019-06-19
  Refresh1.Click;

end;

procedure TFArquivosBlocoX.Corrigir1Click(Sender: TObject);
var
  IBTSALVA: TIBTransaction;
  IBQSALVA: TIBQuery;
  IBQCORRIGIR: TIBQuery;
  sXML: String;
  sRegistro: String;
  sCOO: String;
begin
  IBTSALVA    := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQSALVA    := CriaIBQuery(IBTSALVA);

  IBQCORRIGIR := CriaIBQuery(IBTransaction);

  DBGrid1.DataSource.DataSet.Last;// IBDSBLOCOX.Last;

  if DBGrid1.DataSource.DataSet.RecordCount = 0 then
  begin
    IBDSBLOCOX.Close;
    IBDSBLOCOX.SelectSQL.Text :=
      'select * ' +
      'from BLOCOX ' +
      'where coalesce(XMLRESPOSTA, '''') = '''' ' +
      'order by DATAREFERENCIA';
    IBDSBLOCOX.Open;
  end;

  //Seleciona todos os xml a serem enviados com data maior ou igual ao que está sendo exibido com problemas
  IBQCORRIGIR.Close;
  IBQCORRIGIR.SQL.Text :=
    'select * ' +
    'from BLOCOX ' +
    'where DATAREFERENCIA >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime)) +
    ' and TIPO = ' + QuotedStr(IBDSBLOCOX.FieldByName('TIPO').AsString) +
    ' and (XMLENVIO containing ' + QuotedStr('<NumeroCredenciamento>' + edCredenciamentoDesatualizadoXML.Text + '</NumeroCredenciamento>') + ' or XMLENVIO containing ' + QuotedStr('<NumeroCredenciamento></NumeroCredenciamento>') + ') ' +
    ' order by DATAREFERENCIA';
  IBQCORRIGIR.Open;
  IBQCORRIGIR.First;

  while IBQCORRIGIR.Eof = False do
  begin
    if (AnsiContainsText(IBQCORRIGIR.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>') = False) then //Não foi recebido com sucesso
    begin

      // Troca o número de credenciamento
      sXML := StringReplace(IBQCORRIGIR.FieldByName('XMLENVIO').AsString, '<NumeroCredenciamento>' + edCredenciamentoDesatualizadoXML.Text + '</NumeroCredenciamento>', '<NumeroCredenciamento>' + Edit1.Text + '</NumeroCredenciamento>', [rfReplaceAll]);
      sXML := StringReplace(sXML, '<NumeroCredenciamento></NumeroCredenciamento>', '<NumeroCredenciamento>' + Edit1.Text + '</NumeroCredenciamento>', [rfReplaceAll]);

      if IBQCORRIGIR.FieldByName('TIPO').AsString = 'REDUCAO' then
      begin
        //Corrige COO da redução quando ECF 09/09
        IBQREDUCOES.Close;
        IBQREDUCOES.SQL.Text :=
          'select * ' +
          'from REDUCOES ' +
          'where SERIE  = ' + QuotedStr(IBQCORRIGIR.FieldByName('SERIE').AsString) +
          ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQCORRIGIR.FieldByName('DATAREFERENCIA').AsDateTime)) +
          ' order by DATA';
        IBQREDUCOES.Open;

        if Trim(IBQREDUCOES.FieldByName('MODELOECF').AsString) <> '' then
        begin
          if AnsiContainsText(Trim(IBQREDUCOES.FieldByName('MODELOECF').AsString), '4200 TH') or AnsiContainsText(Trim(IBQREDUCOES.FieldByName('MODELOECF').AsString), 'FS800') or AnsiContainsText(Trim(IBQREDUCOES.FieldByName('MODELOECF').AsString), 'T800') or AnsiContainsText(Trim(IBQREDUCOES.FieldByName('MODELOECF').AsString), 'T900') then
            sCOO := RightStr('000000000' + Trim(xmlNodeValue(sXML, '//DadosReducaoZ/COO')), 9) // 09/09
          else
            sCOO := RightStr('000000' + Trim(xmlNodeValue(sXML, '//DadosReducaoZ/COO')), 6); // 85/01
          if (sCOO <> '') and (RightStr(sCOO, 6) <> '000000') then
            sXML := StringReplace(sXML, '<COO>' + xmlNodeValue(IBQCORRIGIR.FieldByName('XMLENVIO').AsString, '//DadosReducaoZ/COO') + '</COO>', '<COO>' + sCOO + '</COO>', [rfReplaceAll]);
        end;
      end;

      //Limpa assinatura para assinar quando transmitir
      sXML := Copy(sXML, 1, Pos('<Signature', sXML) - 1);
      sXML := sXML + '<Signature />';
      if IBQCORRIGIR.FieldByName('TIPO').AsString = 'REDUCAO' then
        sXML := sXML + '</ReducaoZ>'
      else
        sXML := sXML + '</Estoque>';

      sRegistro := BlocoxSalvarBanco(IBQCORRIGIR.FieldByName('TIPO').AsString, IBQCORRIGIR.FieldByName('SERIE').AsString, Now, sXML, IBQCORRIGIR.FieldByName('DATAREFERENCIA').AsDateTime);

      if sRegistro <> '' then
      begin

        IBQSALVA.Close;
        IBQSALVA.SQL.Text :=
          'update BLOCOX set ' +
          'RECIBO = null ' +
          'where REGISTRO = ' + QuotedStr(sRegistro);
        try
          IBQSALVA.ExecSQL;
          IBQSALVA.Transaction.Commit;
        except
          IBQSALVA.Transaction.Rollback;

        end;

        IBQSALVA.Close;
        IBQSALVA.SQL.Text :=
          'update BLOCOX set ' +
          'XMLRESPOSTA = null ' +
          'where REGISTRO = ' + QuotedStr(sRegistro);
        try
          IBQSALVA.ExecSQL;
          IBQSALVA.Transaction.Commit;
        except
          IBQSALVA.Transaction.Rollback;

        end;

      end; // if sRegistro <> '' then

    end;// transmitido com sucesso
    IBQCORRIGIR.Next;
  end;
  FreeAndNil(IBQSALVA);
  FreeAndNil(IBTSALVA);

  FreeAndNil(IBQCORRIGIR);

  SelecionaDados;// AbreTabelas; // Sandro Silva 2018-06-28

end;

procedure TFArquivosBlocoX.IBDSBLOCOXAfterOpen(DataSet: TDataSet);
begin
  if chkCrzNaoGerado.Checked = False then
  begin
    DataSet.FieldByName('RECIBO').Index         := 4;
    DataSet.FieldByName('SERIE').Index          := 3;
    DataSet.FieldByName('DATAREFERENCIA').Index := 4;

    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'PDV')].Width            := 44; // Sandro Silva 2019-07-18
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'CONTADORZ')].Width      := 44; // Sandro Silva 2019-06-19
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'RECIBO')].Width         := 300;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'DATAHORA')].Width       := 150; //190;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'TIPO')].Width           := 75; //100;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'SERIE')].Width          := 250;//300;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'DATAREFERENCIA')].Width := 150; //190;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'XMLENVIO')].Width       := 500;
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'XMLRESPOSTA')].Width    := 500;

    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'RECIBO')].Title.Caption         := 'Recibo';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'DATAHORA')].Title.Caption       := 'Data Geração';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'TIPO')].Title.Caption           := 'Tipo';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'SERIE')].Title.Caption          := 'Número de Série do ECF';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'DATAREFERENCIA')].Title.Caption := 'Data Referência';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'XMLENVIO')].Title.Caption       := 'XML Enviado';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'XMLRESPOSTA')].Title.Caption    := 'XML Resposta SEFAZ';
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'CONTADORZ')].Title.Caption      := 'CRZ'; // Sandro Silva 2019-06-19
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'PDV')].Title.Caption            := 'PDV'; // Sandro Silva 2019-07-18
    DBGrid1.Columns.Items[ColumnIndex(DBGrid1.Columns, 'REGISTRO')].Visible := False;
  end;
  AjustaLarguraDBGrid(DBGrid1);

  edCredenciamentoDesatualizadoXML.Visible := (DataSet.IsEmpty = False);
  lbCredenciamentoDesatualizadoXML.Visible := edCredenciamentoDesatualizadoXML.Visible;

end;

procedure TFArquivosBlocoX.IBDSBLOCOXAfterScroll(DataSet: TDataSet);
begin
  try

    reMensagem.Font.Color := clWindowText;
    if (Pos('<SituacaoProcessamentoCodigo>0', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)
      or (Pos('<SituacaoOperacaoCodigo>0', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0) then // Sandro Silva 2019-07-19 if (Pos('<SituacaoProcessamentoCodigo>0', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)then
      reMensagem.Font.Color := clWindowText
    else
      if (Pos('<SituacaoProcessamentoCodigo>1', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)
        or (Pos('<SituacaoOperacaoCodigo>1', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0) then // Sandro Silva 2019-07-19 if (Pos('<SituacaoProcessamentoCodigo>1', DataSet.FieldByName('XMLRESPOSTA').AsString) <> 0)then
        reMensagem.Font.Color := COR_AZUL // Sandro Silva 2021-08-17 $00EAB231 // Azul
      else
        reMensagem.Font.Color :=  clRed;

    reMensagem.Text := xmlNodeValue(DataSet.FieldByName('XMLRESPOSTA').AsString, '//Mensagem');
    if reMensagem.Text = '' then
      reMensagem.Text := xmlNodeValue(DataSet.FieldByName('XMLRESPOSTA').AsString, '//SituacaoProcessamentoDescricao');

    if reMensagem.Text = '' then
      reMensagem.Text := xmlNodeValue(DataSet.FieldByName('XMLRESPOSTA').AsString, '//SituacaoOperacaoDescricao');

    if reMensagem.Text = '' then
    begin
      if AnsiContainsText(DataSet.FieldByName('XMLRESPOSTA').AsString, 'soap:Text') then
        reMensagem.Text := xmlNodeValue(DataSet.FieldByName('XMLRESPOSTA').AsString, '//soap:Text');
    end;

    edCredenciamentoDesatualizadoXML.Text := GetCredenciamentoFomXML(DataSet.FieldByName('XMLENVIO').AsString);// Sandro Silva 2019-03-13  Edit2.Text := xmlNodeValue(DataSet.FieldByName('XMLENVIO').AsString, '//NumeroCredenciamento');

  except

  end;
end;

function TFArquivosBlocoX.Credenciamento: String;
var
  sCredenciamento: String;
begin
  LbBlowfish1.GenerateKey(sPasta);
  sCredenciamento := LerParametroIni(sArquivo, INI_SECAO_ECF, INI_CHAVE_NUMERO_CREDENCIAMENTO_PAF, sCredenciamento);
  if sCredenciamento <> '' then
  begin
    try
      sCredenciamento := LbBlowfish1.DecryptString(sCredenciamento);
      if Copy(sCredenciamento, 1, 18) <> Trim(FormataCpfCgc(LimpaNumero(FEmitente.CNPJ))) then
        sCredenciamento := ''
      else
        sCredenciamento := Copy(sCredenciamento, 19, Length(sCredenciamento));
    except
      sCredenciamento := '';
    end;

  end;
  Result := sCredenciamento;
end;

function TFArquivosBlocoX.BlocoxSalvarBanco(sTipo, sSerie: String;
  dtDataHora: TDateTime; XML: WideString; dtReferencia: TDate): String;
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
  sRegistro: String;
begin
  IBTBLOCOX := CriaIBTransaction(IBDSBLOCOX.Transaction.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);
  Result := '';
  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select REGISTRO ' +
      'from BLOCOX ' +
      'where TIPO = ' + QuotedStr(sTipo) +
      ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtReferencia));
    if sTipo = 'REDUCAO' then
    begin
      IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSerie));// Sandro Silva 2017-12-28  IBQBLOCOX.SQL.Add(' and SERIE = ' + QuotedStr(sSeriais));
    end;
    IBQBLOCOX.Open; // Sandro Silva 2017-03-27

    if IBQBLOCOX.FieldByName('REGISTRO').AsString = '' then
    begin

      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'insert into BLOCOX (REGISTRO, TIPO, DATAHORA, XMLENVIO, RECIBO, SERIE, DATAREFERENCIA) ' +
        'values (:REGISTRO, :TIPO, :DATAHORA, :XMLENVIO, :RECIBO, :SERIE, :DATAREFERENCIA)';

      sRegistro := RightStr('0000000000' + IncGenerator(IBDSBLOCOX.Transaction.DefaultDatabase, 'G_BLOCOX'), 10);
      IBQBLOCOX.ParamByName('REGISTRO').AsString   := sRegistro;
      IBQBLOCOX.ParamByName('TIPO').AsString       := sTipo;
      IBQBLOCOX.ParamByName('DATAHORA').AsDateTime := dtDataHora;
      IBQBLOCOX.ParamByName('XMLENVIO').AsString   := XML;
      IBQBLOCOX.ParamByName('RECIBO').Clear;
      IBQBLOCOX.ParamByName('SERIE').AsString      := sSerie;
      if Trim(IBQBLOCOX.ParamByName('SERIE').AsString) = '' then
        IBQBLOCOX.ParamByName('SERIE').Clear;
      IBQBLOCOX.ParamByName('DATAREFERENCIA').AsDate  := StrToDate(FormatDateTime('dd/mm/yyyy', dtReferencia));

      try
        IBQBLOCOX.ExecSQL;
        IBQBLOCOX.Transaction.Commit;
        Result := sRegistro;
      except
        IBQBLOCOX.Transaction.Rollback;
      end;
    end
    else
    begin
      sRegistro := IBQBLOCOX.FieldByName('REGISTRO').AsString;
      if XML <> '' then
      begin
        IBQBLOCOX.Close;
        IBQBLOCOX.SQL.Text :=
          'update BLOCOX set ' +
          'XMLENVIO = :XMLENVIO ' +
          ' where REGISTRO = ' + QuotedStr(sRegistro);
        IBQBLOCOX.ParamByName('XMLENVIO').AsString := XML;
        try
          IBQBLOCOX.ExecSQL;
          IBQBLOCOX.Transaction.Commit;
          Result := sRegistro;
        except
          IBQBLOCOX.Transaction.Rollback;
        end;
      end;
    end;
  finally
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);
  end;

end;

procedure TFArquivosBlocoX.RecuperarRecibodeXMLjenviado1Click(
  Sender: TObject);
var
  sMensagem: String;
  sRecibo: String;
  sAlerta: String; // Sandro Silva 2019-03-27
  sRegistro: String; // Sandro Silva 2019-03-27
begin
  if IBDSBLOCOX.Active = False then
    Exit;

  if (AnsiContainsText(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>')) then //Foi recebido com sucesso
    Exit;

  sAlerta := ''; // Sandro Silva 2019-03-27

  IBDSBLOCOX.DisableControls;

  IBDSBLOCOX.First;
  while IBDSBLOCOX.Eof = False do
  begin
    sRegistro := IBDSBLOCOX.FieldByName('REGISTRO').AsString;
    sMensagem := Trim(xmlNodeValue(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//Mensagem'));

    if sMensagem = '' then
      sMensagem := Trim(xmlNodeValue(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//SituacaoProcessamentoDescricao'));

    //Erro 1009: Um arquivo idêntico já foi recepcionado anteriormente. Consulte a situação do processamento deste arquivo ao invés de enviá-lo novamente. O número do recibo é cb95cc9a-dc7c-4c40-889a-8c1b2f8d2096
    //Erro 3001: Já existe Redução Z com CRZ 2380 para o ECF de número de fabricação EP041010000000020232 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c8cbbe0-a0ee-4a18-973a-6475862e6a9b
    //Erro 3001: Já existe Redução Z com CRZ 2314 para o ECF de número de fabricação EP041010000000020825 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é df3e3ffc-e92b-4143-9ca5-2a92a20c5c7c
    //Erro 3001: Já existe Redução Z com CRZ 0877 para o ECF de número de fabricação EP081410000000066980 processada com sucesso. O número do recibo da Redução Z já processada com sucesso é 2c131d67-b075-40c0-82ef-59b1f000a126

    if (AnsiContainsText(sMensagem, 'Já existe ') and AnsiContainsText(sMensagem, 'O número do recibo') and AnsiContainsText(sMensagem, ' com sucesso'))
     or (AnsiContainsText(sMensagem, 'arquivo idêntico já foi recepcionado ') and AnsiContainsText(sMensagem, 'O número do recibo'))
     or (AnsiContainsText(sMensagem, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagem, 'O recibo ')) // Sandro Silva 2019-03-22
     then
    begin
      if (AnsiContainsText(sMensagem, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagem, 'O recibo ')) then
      begin
        sMensagem := Copy(sMensagem, Pos(AnsiUpperCase('O recibo '), AnsiUpperCase(sMensagem)) + Length('O recibo '), 36);
      end;
      sRecibo := Right(Trim(sMensagem), 36);// Trim(Copy(sMensagem, Pos('com sucesso é', sMensagem) + Length('com sucesso é'), 40));
      GravaRecibo(sRecibo, IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime, IBDSBLOCOX.FieldByName('TIPO').AsString, IBDSBLOCOX.FieldByName('SERIE').AsString);

      try
        IBDSBLOCOX.Locate('REGISTRO', sRegistro, []);
      except
      end;

    end
    else
    begin
      sAlerta := sAlerta + #13 + 'Não foi possível recuperar o recibo da mensagem. Referência:  "' + IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsString + ' ' + IBDSBLOCOX.FieldByName('TIPO').AsString + ' ' + IBDSBLOCOX.FieldByName('SERIE').AsString + '"'; // Sandro Silva 2019-03-27  ShowMessage('Não foi possível recuperar o recibo da mensagem: "' + sMensagem + '"');
    end; // if AnsiContainsText(sMensagem, 'Já existe ') and AnsiContainsText(sMensagem, ' com sucesso é ') then

    IBDSBLOCOX.Next;

  end;

  IBDSBLOCOX.EnableControls;

  if sAlerta <> '' then
    ShowMessage(sAlerta);

end;

function TFArquivosBlocoX.GravaRecibo(sRecibo: String;
  dtDatareferencia: TDate; sTipo, sSerie: String): Boolean;
var
  IBTBLOCOX: TIBTransaction;
  IBQBLOCOX: TIBQuery;
begin
  Result := True;
  if IBDSBLOCOX.Active = False then
    Exit;
  IBTBLOCOX := CriaIBTransaction(IBTransaction.DefaultDatabase);
  IBQBLOCOX := CriaIBQuery(IBTBLOCOX);// Sandro Silva 2017-12-27 Polimig  IBQBLOCOX := CriaIBQuery(ibDataSet88.Transaction);// Sandro Silva 2017-03-31 CriaIBQuery(ibDataSet27.Transaction);
  try
   if (Length(Trim(sRecibo)) = 36) and (Pos(' ', sRecibo) = 0) then // Exemplo de recibo: 42fdb728-a535-42e6-b238-9dc3f5fd59f4
   begin

     if (Copy(sRecibo, 9, 1) = '-') and (Copy(sRecibo, 14, 1) = '-') and (Copy(sRecibo, 19, 1) = '-') and (Copy(sRecibo, 24, 1) = '-') then
     begin
       IBQBLOCOX.Close;
       IBQBLOCOX.SQL.Text :=
         'update BLOCOX set ' +
         'RECIBO = ' + QuotedStr(sRecibo) +
         ', XMLRESPOSTA = ' + QuotedStr(BLOCOX_ESPECIFICACAO_XML + '<Resposta Versao="' + BLOCOX_VERSAO_LEIAUTE + '"><Recibo>' + sRecibo + '</Recibo>  <SituacaoProcessamentoCodigo>0</SituacaoProcessamentoCodigo><SituacaoProcessamentoDescricao>Aguardando</SituacaoProcessamentoDescricao><Mensagem /></Resposta>') +
         'where DATAREFERENCIA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', dtDatareferencia)) +
         ' and TIPO = ' + QuotedStr(sTipo) +
         ' and coalesce(SERIE, '''') = ' + QuotedStr(sSerie);
       try
         IBQBLOCOX.ExecSQL;
         IBQBLOCOX.Transaction.Commit;
       except
         on E: Exception do
         begin
           IBQBLOCOX.Transaction.Rollback;
           ShowMessage('Não foi possível recuperar o número do recibo' + #13 + E.Message);
         end;
       end;
     end
     else
       ShowMessage('Recibo inválido ' + sRecibo);
   end;
  finally
    FreeAndNil(IBQBLOCOX);
    FreeAndNil(IBTBLOCOX);

    IBDSBLOCOX.Transaction.Rollback;
    SelecionaDados;
  end;

end;

procedure TFArquivosBlocoX.Gravarnmerodorecibo1Click(Sender: TObject);
var
  sRecibo: String;
begin
  if (IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsString = '')
    or (IBDSBLOCOX.FieldByName('TIPO').AsString = '')
  then
    Exit;

  if (AnsiContainsText(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>1</SituacaoProcessamentoCodigo>')) then //Foi recebido com sucesso
    Exit;

  sRecibo := InputBox('Informe o número do recibo', 'Recibo de processamento', '');
  if sRecibo <> '' then
    GravaRecibo(sRecibo, IBDSBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime, IBDSBLOCOX.FieldByName('TIPO').AsString, IBDSBLOCOX.FieldByName('SERIE').AsString);

end;

procedure TFArquivosBlocoX.Refresh1Click(Sender: TObject);
begin
  IBDSBLOCOX.Transaction.Rollback;
  SelecionaDados;
end;

procedure TFArquivosBlocoX.Verificarpendncias1Click(Sender: TObject);
begin

  Blocox.AlertaXmlPendente(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName, FsAtual, 'ESTOQUE', '', True);
  Blocox.AlertaXmlPendente(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName, FsAtual, 'REDUCAO', '', True, True);

end;

procedure TFArquivosBlocoX.ransmitirpendentes1Click(Sender: TObject);
var
  IBTTRATAR: TIBTransaction;
  IBQTRATAR: TIBQuery;
  IBQBLOCOX: TIBQuery;
  sFiltro: String;
begin
  // Trata erro nos xml
  // Duas querys, uma para selecionar os xml com erro e outra para quando estiver em rede com outros terminais, verificar se outro terminal já fez a correção.
  // Só fará a correção se ainda não tiver sido feita por outro terminal
  IBTTRATAR := CriaIBTransaction(IBDSBLOCOX.Transaction.DefaultDatabase);
  IBQTRATAR := CriaIBQuery(IBTTRATAR);
  IBQBLOCOX := CriaIBQuery(IBDSBLOCOX.Transaction);
  try

    sFiltro := '';

    if AnsiUpperCase(cbTipo.Text) <> 'TODOS' then
    begin
      if AnsiUpperCase(cbTipo.Text) = 'REDUÇÃO' then
        sFiltro := ' and TIPO = ''REDUCAO'' ';
      if AnsiUpperCase(cbTipo.Text) = 'ESTOQUE' then
        sFiltro := ' and TIPO = ''ESTOQUE'' ';
    end;

    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select * ' +
      'from BLOCOX ' +
      'where coalesce(XMLRESPOSTA, '''') containing ''<SituacaoProcessamentoCodigo>2'' ' +
      //' and TIPO = ''REDUCAO'' ' +
      sFiltro +
      ' order by DATAREFERENCIA ';
    IBQBLOCOX.Open;

    while IBQBLOCOX.Eof = False do
    begin

      IBQTRATAR.Close;
      IBQTRATAR.SQL.Text :=
        'select * ' +
        'from BLOCOX ' +
        'where TIPO = ' + QuotedStr(IBQBLOCOX.FieldByName('TIPO').AsString) +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', IBQBLOCOX.FieldByName('DATAREFERENCIA').AsDateTime));
      if IBQBLOCOX.FieldByName('TIPO').AsString = 'REDUCAO' then
        IBQTRATAR.SQL.Add(' and SERIE = ' + QuotedStr(IBQBLOCOX.FieldByName('SERIE').AsString));
      IBQTRATAR.Open;

      if AnsiContainsText(IBQTRATAR.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>2') then
      begin
        BlocoX.TratarErroRetornoTransmissao(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName, FsAtual, IBQTRATAR.FieldByName('XMLRESPOSTA').AsString,
          IBQTRATAR.FieldByName('TIPO').AsString, IBQTRATAR.FieldByName('SERIE').AsString, FormatDateTime('dd/mm/yyyy', IBQTRATAR.FieldByName('DATAREFERENCIA').AsDateTime));
      end;

      IBQTRATAR.Transaction.Rollback;

      IBQBLOCOX.Next;
    end;
  except

  end;
  FreeAndNil(IBQTRATAR);
  FreeAndNil(IBTTRATAR);
  FreeAndNil(IBQBLOCOX);

  if DBGrid1.DataSource.DataSet.FieldByName('TIPO').AsString <> '' then
    Blocox.TransmitirXmlPendente(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName, FsAtual, DBGrid1.DataSource.DataSet.FieldByName('TIPO').AsString, DBGrid1.DataSource.DataSet.FieldByName('SERIE').AsString, True);

  Refresh1Click(Sender);
end;

procedure TFArquivosBlocoX.SomarTag1Click(Sender: TObject);
begin
  SomarTag;
end;

procedure TFArquivosBlocoX.SomarTag;
var
  sExp: String;
  sResultado: String;
  XMLNFE: IXMLDOMDocument;
  xNodePag: IXMLDOMNodeList;
  iNode: Integer;
begin

  sResultado := '0,00';
  sExp := InputBox('Soma tag', 'Tag', '//ValorDesconto | //ValorCancelamento | //ValorTotalLiquido');
  if sExp <> '' then
  begin
    try
      XMLNFE := CoDOMDocument.Create;
      XMLNFE.loadXML(StringReplace(DBGrid1.DataSource.DataSet.FieldByName('XMLENVIO').AsString, ',', '.', [rfReplaceAll]));

      xNodePag := XMLNFE.selectNodes(sExp);
      for iNode := 0 to xNodePag.length -1 do
      begin
        sResultado := FloatToStr( StrToFloat(sResultado) + StrToFloatDef(StringReplace(xNodePag.item[iNode].text, '.', ',', [rfReplaceAll]), 0));
      end;
      ShowMessage('Resultado ' + sResultado);
    except
    end;

  end;

end;

procedure TFArquivosBlocoX.GerarXMLRZOmisso1Click(Sender: TObject);
// Gera o xml da RZ a partir do CRZ e número de série do ECF
var
  sCRZ: String;
  sCaixa: String;
begin
  while True do
  begin

    while StrToIntDef(sCRZ, 0) = 0 do
    begin
      sCRZ := Trim(InputBox('Informe o número do CRZ', 'Contador da Redução Z. (Deixe em branco e tecle [Enter] para finalizar)', ''));
      if Trim(sCRZ) = '' then
        Break;
    end;

    if Trim(sCRZ) = '' then
      Break;

    while StrToIntDef(sCaixa, 0) = 0 do
      sCaixa := Trim(InputBox('Informe o número do caixa', 'Número do caixa', ''));
    // Sandro Silva 2022-02-16 GeraXMLReducao(DBGrid1.DataSource.DataSet.FieldByName('CRZ').AsString, DBGrid1.DataSource.DataSet.FieldByName('CAIXA').AsString)
    GeraXMLReducao(DBGrid1.DataSource.DataSet.FieldByName('CRZ').AsString, DBGrid1.DataSource.DataSet.FieldByName('PDV').AsString)
  end;

end;

procedure TFArquivosBlocoX.GerarXMLEstoqueomisso1Click(Sender: TObject);
var
  sDtReferencia: String;
  IBQBLOCOX: TIBQuery;
begin
  while StrToDateDef(sDtReferencia, StrToDate('30/11/1899')) = StrToDate('30/11/1899') do
  begin
    sDtReferencia := Trim(InputBox('Informe data do último dia do mês referente ao Estoque', 'Data do Estoque', ''));
    if Trim(sDtReferencia) = '' then
      Break;
  end;

  if Trim(sDtReferencia) = '' then
    Exit;
    
  IBQBLOCOX := CriaIBQuery(IBDSBLOCOX.Transaction);

  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select DATAREFERENCIA ' +
      'from BLOCOX ' +
      'where coalesce(SERIE, '''') = '''' ' +
      ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(sDtReferencia))) +
      ' and TIPO = ''ESTOQUE'' ';
    IBQBLOCOX.Open;

    if IBQBLOCOX.FieldByName('DATAREFERENCIA').AsString = '' then
    begin
      Blocox.XmlEstoqueOmisso(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(FsAtual), AnsiString('01/' + Copy(sDtReferencia, 4, 7)), AnsiString(sDtReferencia), True, True, True, True);
    end
    else
    begin
      ShowMessage('XML já existe');
    end;

  except

  end;
  FreeAndNil(IBQBLOCOX);

  Refresh1Click(Sender);

end;

procedure TFArquivosBlocoX.GeraXMLReducao(sCRZ, sCaixa: String);
var
  sSerie: String;
  sDtReferencia: String;
  IBQBLOCOX: TIBQuery;
begin
  IBQBLOCOX := CriaIBQuery(IBDSBLOCOX.Transaction);

  try
    IBQBLOCOX.Close;
    IBQBLOCOX.SQL.Text :=
      'select CONTADORZ, SERIE, DATA ' +
      'from REDUCOES ' +
      'where right(''000000''||trim(CONTADORZ), 6)= right(''000000''||' + QuotedStr(sCRZ) +', 6) ' + // Sandro Silva 2019-03-28  'where cast(CONTADORZ as integer) = ' + sCRZ +
      ' and PDV = ' + QuotedStr(sCaixa) +
      ' and CONTADORZ is not null';
    IBQBLOCOX.Open;

    if IBQBLOCOX.FieldByName('CONTADORZ').AsString <> '' then
    begin

      sSerie        := IBQBLOCOX.FieldByName('SERIE').AsString;
      sDtReferencia := IBQBLOCOX.FieldByName('DATA').AsString;

      IBQBLOCOX.Close;
      IBQBLOCOX.SQL.Text :=
        'select SERIE, DATAREFERENCIA ' +
        'from BLOCOX ' +
        'where SERIE = ' + QuotedStr(sSerie) +
        ' and DATAREFERENCIA = ' + QuotedStr(FormatDateTime('YYYY-MM-DD', StrToDate(sDtReferencia))) +
        ' and TIPO = ''REDUCAO'' ';
      IBQBLOCOX.Open;

      if IBQBLOCOX.FieldByName('SERIE').AsString <> '' then
        ShowMessage('XML já existe')
      else
        Blocox.XmlReducaoZ(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(FsAtual), AnsiString(sSerie), AnsiString(sDtReferencia), True, True, True);
    end;

  except
    on E: Exception do
    begin
      LogFrente('Falha geração xml RZ: ' + E.Message, FsAtual); // Sandro Silva 2019-03-28
    end;
  end;

  FreeAndNil(IBQBLOCOX);

end;

procedure TFArquivosBlocoX.ConsultaPendnciaUsuriosPAF1Click(
  Sender: TObject);
begin
  BlocoX.ConsultarPendenciasDesenvolvedorPafEcf(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(FsAtual));
end;

procedure TFArquivosBlocoX.PopupMenu1Popup(Sender: TObject);
var
  sMensagem: String;
  i: Integer;
begin
  for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items[i].Enabled := True;

  if chkCrzNaoGerado.Checked = False then // Sandro Silva 2019-02-25
  begin
    sMensagem := xmlNodeValue(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//Mensagem');

    if sMensagem = '' then
      sMensagem := Trim(xmlNodeValue(IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString, '//SituacaoProcessamentoDescricao'));

    RecuperarRecibodeXMLjenviado1.Enabled := (AnsiContainsText(sMensagem, 'Já existe ') and AnsiContainsText(sMensagem, 'O número do recibo') and AnsiContainsText(sMensagem, ' com sucesso'))
                                          or (AnsiContainsText(sMensagem, 'arquivo idêntico já foi recepcionado ') and AnsiContainsText(sMensagem, 'O número do recibo'))
                                          or (AnsiContainsText(sMensagem, 'arquivo idêntico a este já foi recepcionado ') and AnsiContainsText(sMensagem, 'O recibo '))// Sandro Silva 2019-03-22
                                          ;
  end;

  if AnsiUpperCase(cbSituacao.Text) = 'TODOS' then //if chkExibirTodos.Checked then
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items[i].Enabled := False;

    ConsultaRecibo1.Enabled                 := True;
    Refresh1.Enabled                        := True;
    Verificarpendncias1.Enabled             := True;
    VisualizarXMLdeEnvio1.Enabled           := True;
    VisualizarXMLdeRespostadaSEFAZ1.Enabled := True;

    RecriarXMLparaEnvio1.Enabled            := (IBDSBLOCOX.FieldByName('XMLRESPOSTA').AsString = ''); // Sandro Silva 2018-11-23

  end;
  SomarTag1.Visible                   := False;
  //SomarTag1.Enabled          := chkCrzNaoGerado.Checked = False; // Sandro Silva 2019-03-28
  ImportarAC17041.Enabled             := True; // Sandro Silva 2019-04-02
  Anlisedomovimento1.Enabled          := True; // Sandro Silva 2019-04-05
  ConsultaPendnciaUsuriosPAF1.Enabled := True; // Sandro Silva 2019-05-07
  ransmitirpendentes1.Enabled         := True;
  GerarXMLRZOmisso1.Enabled           := True;
  GerarXMLEstoqueomisso1.Enabled      := True;

end;

procedure TFArquivosBlocoX.BitBtn1Click(Sender: TObject);
begin
  SelecionaDados;
end;

procedure TFArquivosBlocoX.BitBtn2Click(Sender: TObject);
begin
  ransmitirpendentes1Click(Sender);
end;

procedure TFArquivosBlocoX.cbSituacaoChange(Sender: TObject);
begin
  SelecionaDados;
end;

procedure TFArquivosBlocoX.cbTipoChange(Sender: TObject);
begin
  SelecionaDados;
end;

procedure TFArquivosBlocoX.btnOmissoClick(Sender: TObject);
begin
  PopupMenuOmissos.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TFArquivosBlocoX.SetCaminhoBanco(const Value: String);
begin
  FCaminhoBanco := Value;
  ConectaBanco(FCaminhoBanco);
  FEmitente := DadosEmitente(IBTransaction, FsAtual);
  edEmitente.Text := FEmitente.Nome + ' ' + FEmitente.CNPJ + ' - ' + FEmitente.IE + ' - ' + FEmitente.Municipio + ' - ' + FEmitente.UF;
  Edit1.Text := Credenciamento;

end;

procedure TFArquivosBlocoX.ConectaBanco(sCaminho: String);
begin
  try
    IBDatabase.Close;
    IBDatabase.Params.Clear;
    IbDatabase.DatabaseName := sCaminho;
    IBDatabase.Params.Add('USER_NAME=SYSDBA');
    IBDatabase.Params.Add('PASSWORD=masterkey');
    IBDatabase.Open;
  except
    ShowMessage('Não foi possível conectar o banco de dados');
  end;
end;

procedure TFArquivosBlocoX.Reprocessararquivos1Click(Sender: TObject);
var
  bTodas: Boolean;
begin
  bTodas := (Application.MessageBox(PWideChar('Reprocessar este XML e os próximos listados?' + #13 + #13 + 'Tecle Não para reprocessar apenas do selecionado'), 'Atenção', MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) = ID_YES);
  DBGrid1.DataSource.DataSet.DisableControls; // Sandro Silva 2019-06-19
  while True do
  begin
    if (AnsiContainsText(DBGrid1.DataSource.DataSet.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>2') or AnsiContainsText(DBGrid1.DataSource.DataSet.FieldByName('XMLRESPOSTA').AsString, '<SituacaoProcessamentoCodigo>3')) then // 2:Erro 3:Cancelado
      BlocoX.ReprocessarArquivoBlocoX(AnsiString(IBDSBLOCOX.Transaction.DefaultDatabase.DatabaseName), AnsiString(satual), AnsiString(DBGrid1.DataSource.DataSet.FieldByName('RECIBO').AsString));
    if bTodas then
      DBGrid1.DataSource.DataSet.Next;

    if (bTodas = False) or (DBGrid1.DataSource.DataSet.Eof) then
      Break;
  end;
  DBGrid1.DataSource.DataSet.EnableControls; // Sandro Silva 2019-06-19
  Refresh1.Click;
end;

end.
