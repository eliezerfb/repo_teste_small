unit Unit1;

interface
uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, DBGrids, Db, IniFiles, ShellApi, SmallFunc,
  OleCtrls, Buttons, Printers, Menus, HtmlHelp, ComCtrls, IBDatabase,
  IBCustomDataSet, Mask, DBCtrls, SMALL_DBEdit, jpeg, Winsock,
  LbClass, MD5, IBQuery, LbCipher, DBTables; //, LbCipher;

type
  TForm1 = class(TForm)
    DataSource37: TDataSource;
    ibDataSet37: TibDataSet;
    ibDataSet37DESCRICAO: TStringField;
    ibDataSet37QUANTIDADE: TFloatField;
    ibDataSet37UNITARIO: TFloatField;
    ibDataSet37TOTAL: TFloatField;
    ibDataSet37DATA: TDateField;
    ibDataSet37TIPO: TStringField;
    ibDataSet37CLIFOR: TStringField;
    ibDataSet37VENDEDOR: TStringField;
    ibDataSet37CAIXA: TStringField;
    ibDataSet37CODIGO: TStringField;
    ScrollBox1: TScrollBox;
    Image14: TImage;
    Button1: TButton;
    IBTransaction1: TIBTransaction;
    IBDataSet99: TIBDataSet;
    ibDataSet4: TIBDataSet;
    ibDataSet4CODIGO: TStringField;
    ibDataSet4REFERENCIA: TStringField;
    ibDataSet4DESCRICAO: TStringField;
    ibDataSet4FORNECEDOR: TStringField;
    ibDataSet4NOME: TStringField;
    ibDataSet4MEDIDA: TStringField;
    ibDataSet4PRECO: TFloatField;
    ibDataSet4INDEXADOR: TFloatField;
    ibDataSet4CUSTOCOMPR: TFloatField;
    ibDataSet4ULT_COMPRA: TDateField;
    ibDataSet4CUSTOMEDIO: TFloatField;
    ibDataSet4QTD_ATUAL: TFloatField;
    ibDataSet4QTD_MINIM: TFloatField;
    ibDataSet4ULT_VENDA: TDateField;
    ibDataSet4COMISSAO: TFloatField;
    ibDataSet4PESO: TFloatField;
    ibDataSet4LOCAL: TStringField;
    ibDataSet4IPI: TFloatField;
    ibDataSet4MARGEMLB: TFloatField;
    ibDataSet4CST: TStringField;
    ibDataSet4ST: TStringField;
    ibDataSet4CF: TStringField;
    ibDataSet4LIVRE1: TStringField;
    ibDataSet4LIVRE2: TStringField;
    ibDataSet4LIVRE3: TStringField;
    ibDataSet4LIVRE4: TStringField;
    ibDataSet4OBS: TStringField;
    ibDataSet4QTD_COMPRA: TFloatField;
    ibDataSet4QTD_INICIO: TFloatField;
    ibDataSet4DAT_INICIO: TDateField;
    ibDataSet4QTD_VEND: TFloatField;
    ibDataSet4CUS_VEND: TFloatField;
    ibDataSet4VAL_VEND: TFloatField;
    ibDataSet4LUC_VEND: TFloatField;
    ibDataSet4ATIVO: TSmallintField;
    ibDataSet4ALTERADO: TSmallintField;
    ibDataSet4SERIE: TSmallintField;
    ibDataSet4FOTO: TMemoField;
    ibDataSet4REGISTRO: TIBStringField;
    DataSource4: TDataSource;
    IBDataSet2: TIBDataSet;
    DataSource2: TDataSource;
    Label13: TLabel;
    Label16: TLabel;
    ibDataSet9: TIBDataSet;
    ibDataSet9NOME: TStringField;
    ibDataSet9COMISSA1: TFloatField;
    ibDataSet9COMISSA2: TFloatField;
    ibDataSet9HORASTRAB: TStringField;
    ibDataSet9FUNCAO: TStringField;
    ibDataSet9ATIVO: TSmallintField;
    ibDataSet9REGISTRO: TIBStringField;
    DataSource9: TDataSource;
    Label17: TLabel;
    ibDataSet13: TIBDataSet;
    ibDataSet13NOME: TStringField;
    ibDataSet13CONTATO: TStringField;
    ibDataSet13ENDERECO: TStringField;
    ibDataSet13COMPLE: TStringField;
    ibDataSet13CEP: TStringField;
    ibDataSet13MUNICIPIO: TStringField;
    ibDataSet13ESTADO: TStringField;
    ibDataSet13CGC: TStringField;
    ibDataSet13IE: TStringField;
    ibDataSet13TELEFO: TStringField;
    ibDataSet13EMAIL: TStringField;
    ibDataSet13HP: TStringField;
    ibDataSet13COPE: TFloatField;
    ibDataSet13RESE: TFloatField;
    ibDataSet13CVEN: TFloatField;
    ibDataSet13IMPO: TFloatField;
    ibDataSet13LUCR: TFloatField;
    ibDataSet13ICME: TFloatField;
    ibDataSet13ICMS: TFloatField;
    ibDataSet13REGISTRO: TIBStringField;
    DataSource13: TDataSource;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    ibDataSet37MEDIDA: TIBStringField;
    ibDataSet37ITEM: TIBStringField;
    ibDataSet37VALORICM: TFloatField;
    ibDataSet37ALIQUICM: TIBStringField;
    ibDataSet37REGISTRO: TIBStringField;
    ibDataSet37NUMERONF: TIBStringField;
    ibDataSet37PEDIDO: TIBStringField;
    Panel9: TPanel;
    Image2: TImage;
    IBDataSet2NOME: TIBStringField;
    IBDataSet2CONTATO: TIBStringField;
    IBDataSet2IE: TIBStringField;
    IBDataSet2CGC: TIBStringField;
    IBDataSet2ENDERE: TIBStringField;
    IBDataSet2COMPLE: TIBStringField;
    IBDataSet2CIDADE: TIBStringField;
    IBDataSet2ESTADO: TIBStringField;
    IBDataSet2CEP: TIBStringField;
    IBDataSet2FONE: TIBStringField;
    IBDataSet2FAX: TIBStringField;
    IBDataSet2EMAIL: TIBStringField;
    IBDataSet2OBS: TIBStringField;
    IBDataSet2CELULAR: TIBStringField;
    IBDataSet2CREDITO: TFloatField;
    IBDataSet2CONVENIO: TIBStringField;
    IBDataSet2IDENTIFICADOR1: TIBStringField;
    IBDataSet2IDENTIFICADOR2: TIBStringField;
    IBDataSet2IDENTIFICADOR3: TIBStringField;
    IBDataSet2IDENTIFICADOR4: TIBStringField;
    IBDataSet2IDENTIFICADOR5: TIBStringField;
    IBDataSet2DATANAS: TDateField;
    IBDataSet2CADASTRO: TDateField;
    IBDataSet2ULTIMACO: TDateField;
    IBDataSet2PROXDATA: TDateField;
    IBDataSet2CUSTO: TFloatField;
    IBDataSet2COMPRA: TFloatField;
    IBDataSet2ATIVO: TSmallintField;
    IBDataSet2MOSTRAR: TIBStringField;
    IBDataSet2CLIFOR: TIBStringField;
    IBDataSet2CONTATOS: TMemoField;
    IBDataSet2REGISTRO: TIBStringField;
    IBDataSet2FOTO: TBlobField;
    IBDatabase1: TIBDatabase;
    ibDataSet37COO: TIBStringField;
    LbBlowfish1: TLbBlowfish;
    LbMD51: TLbMD5;
    ibDataSet37ENCRYPTHASH: TIBStringField;
    Panel1: TPanel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    Panel8: TPanel;
    Panel6: TPanel;
    Label11: TLabel;
    Panel5: TPanel;
    Label10: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Panel2: TPanel;
    Label5: TLabel;
    Edit4: TEdit;
    Panel10: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label24: TLabel;
    Label23: TLabel;
    Label20: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label12: TLabel;
    Label1: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Panel7: TPanel;
    Image3_: TImage;
    Image3: TImage;
    IBQuery1: TIBQuery;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure ibDataSet37NewRecord(DataSet: TDataSet);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3Enter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Enter(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ibDataSet37AfterPost(DataSet: TDataSet);
    procedure ibDataSet37UNITARIOChange(Sender: TField);
    procedure Edit8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Enter(Sender: TObject);
    procedure ibDataSet37TOTALChange(Sender: TField);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure ibDataSet37QUANTIDADEChange(Sender: TField);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure ibDataSet37BeforeInsert(DataSet: TDataSet);
    procedure Image14Click(Sender: TObject);
    procedure SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit1Exit(Sender: TObject);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure ibDataSet37BeforeEdit(DataSet: TDataSet);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ibDataSet37BeforePost(DataSet: TDataSet);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure Label_minimiza_0Click(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ibDataSet37UNITARIOSetText(Sender: TField;
      const Text: String);
    procedure ibDataSet13RESESetText(Sender: TField; const Text: String);
    procedure ibDataSet37TOTALSetText(Sender: TField; const Text: String);
    procedure Panel1Click(Sender: TObject);
    procedure ibDataSet37BeforeDelete(DataSet: TDataSet);

  private
    { Private declarations }
//    Peedy : IAgentCtlCharacterEx;

  public
    { Public declarations }
    sAntigo        : String;
    sAnterior      : String;
    sCaixa         : String;
    sCliente       : String;
    sVendedor      : String;
    sAtual         : String;
    sProximo       : String;
    sNumeroAtual   : String;
    sPasta         : String;
    sPorta         : String;
    //
    ConfSpaco, ConfCusto, ConfNegat, sPrazo, ConfCasas, ConfPreco : String;
    bPDF : boolean;
    //
    V1  : Variant;
    bChave, bRodape, bImporta, bChaveDoTempo : Boolean;
    iVista, iVias, iLinha, iTamanho : Integer;
    fConfDesconto, fconfDescontoTotal, fTotal : Real;
    //
  end;
var
  Form1: TForm1;

implementation

uses Unit2, Unit22;

{$R *.DFM}

function RunAsAdmin(const Handle: Hwnd; const Path, Params: string): Boolean;
var
  sei: TShellExecuteInfoA;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PAnsiChar(Path);
  sei.lpParameters := PAnsiChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@sei);
end;

function CriaIBTransaction(IBDATABASE: TIBDatabase): TIBTransaction;
//Sandro Silva 2011-04-12 inicio
//Cria um objeto TIBTransaction
begin
  try
    Result := TIBTransaction.Create(Application);
    Result.Params.Add('read_committed');
    Result.Params.Add('rec_version');
    Result.Params.Add('nowait');
    Result.DefaultDatabase := IBDATABASE;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Result := nil;
    end
  end;
end;

function CriaIBQuery(IBTRANSACTION: TIBTransaction): TIBQuery;
//Sandro Silva 2011-04-12 inicio
//Cria um objeto TIBQuery
begin
  try
    Result := TIBQuery.Create(Application);
    Result.Database    := IBTRANSACTION.DefaultDataBase;
    Result.Transaction := IBTRANSACTION;
    Result.BufferChunks := 100; // 2014-02-26 Evitar Erro de out of memory
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Result := nil;
    end
  end;
end;

function HasHs(sP1: String; bP2: Boolean): boolean;
var
  IBQHASH: TIBQuery;
  IBTHASH: TIBTransaction;
begin
  //
  if bP2 then
  begin

    Form1.ibQuery1.Close;
    Form1.ibQuery1.SQL.Clear;
    Form1.ibQuery1.SQL.Add('select gen_id(G_HASH_'+sP1+',0) as TOTALREG from rdb$database');
    Form1.ibQuery1.Open;

    try


      IBTHASH := CriaIBTransaction(Form1.ibQuery1.Transaction.DefaultDatabase);
      IBQHASH := CriaIBQuery(IBTHASH);

      Form1.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta

      IBQHASH.Close;
      IBQHASH.SQL.Clear;
      IBQHASH.SQL.Add('update HASHS set ENCRYPTHASH='+QuotedStr(Form1.LbBlowfish1.EncryptString(MD5Print(MD5String(Form1.ibQuery1.FieldByName('TOTALREG').AsString))))+' where TABELA='+QuotedStr(sP1)+' ');
      IBQHASH.ExecSQL;

      if IBQHASH.RowsAffected = 0 then
      begin
        //2015-11-26 Não existe ainda controle de hash da tabela
        IBQHASH.Close;
        IBQHASH.SQL.Clear;
        IBQHASH.SQL.Add('insert into HASHS(TABELA, ENCRYPTHASH) values(' + QuotedStr(sP1) + ',' + QuotedStr(Form1.LbBlowfish1.EncryptString(MD5Print(MD5String(Form1.ibQuery1.FieldByName('TOTALREG').AsString)))) + ')');
        IBQHASH.ExecSQL;
      end;

      IBQHASH.Transaction.Commit;

      IBTHASH.Free;
      IBQHASH.Free;

    except

    end;
    //
    Result := True;
    //
  end else
  begin
    Result := True;
  end;
  //
  // Ok testado
  //
end;




function HtmlParaPdf(sP1:String): boolean;
//var
//  Handle: THandle;
begin
  //
//  Handle := FindWindow('TForm1', 'Orçamento');
  //
  try
    //
    while FileExists(pChar(sP1+'.pdf')) do
    begin
      //
      try
        DeleteFile(pChar(sP1+'.pdf'));
        DeleteFile(pChar(sP1+'_.pdf'));
      except end;
      //
      Sleep(10);
      //
    end;
    //
    chdir(pChar(Form1.sAtual+'\HTMLtoPDF'));
    //
    while FileExists(pChar('tempo_ok.pdf')) do
    begin
      DeleteFile(pChar('tempo_ok.pdf'));
      Sleep(10);
    end;
    //
    while FileExists(pChar('tempo.pdf')) do
    begin
      DeleteFile(pChar('tempo.pdf'));
      Sleep(10);
    end;
    //
    // Sandro Silva 2019-09-25 inicio
    // Ref. ficha depuração 4713
    // Precisa excluir o orçamento*.pdf antigo para ser substituído pelo novo com os dados atualizados
    // Tenta renomear se falhar a exclusão por estar aberto no visualizador de pdf
    if FileExists(pChar(form1.sAtual+'\'+sP1+'.pdf')) then
    begin
      if DeleteFile(pChar(form1.sAtual+'\'+sP1+'.pdf')) = False then
      begin
        RenameFile(pChar(form1.sAtual+'\'+sP1+'.pdf'), pChar(form1.sAtual+'\'+sP1+'_'+LimpaNumero(TimeToStr(Time))+'.pdf'));
      end;
    end;
    // Sandro Silva 2019-09-25 fim
    //

    //
//    ShellExecute( 0, 'Open', pChar('html2pdf'),pchar('"'+Form1.sAtual+'\'+sP1+'.htm" "tempo.pdf"'), '', SW_HIDE);
    ShellExecute( 0, 'runas', pChar('html2pdf'),pchar('"'+Form1.sAtual+'\'+sP1+'.htm" "tempo.pdf"'), '', SW_HIDE);
//    RunAsAdmin(Handle, pChar('html2pdf'),pchar('"'+Form1.sAtual+'\'+sP1+'.htm" "tempo.pdf"'));
    Sleep(10);
    //
    while not FileExists(pChar(Form1.sAtual+'\HTMLtoPDF\tempo_ok.pdf')) do
    begin
      RenameFile(pChar(Form1.sAtual+'\HTMLtoPDF\tempo.pdf'),pChar(Form1.sAtual+'\HTMLtoPDF\tempo_ok.pdf'));
      Sleep(10);
    end;
    //
    chdir(pChar(Form1.sAtual));
    //
    CopyFile(pChar(Form1.sAtual+'\HTMLtoPDF\tempo_ok.pdf'), pChar(Form1.sAtual+'\'+sP1+'_.pdf'),False);
    //
    while not FileExists(pChar(form1.sAtual+'\'+sP1+'.pdf')) do
    begin
      RenameFile(pChar(Form1.sAtual+'\'+sP1+'_.pdf'), pChar(Form1.sAtual+'\'+sP1+'.pdf'));
      Sleep(10);
    end;
    //
  except end;
  //
  Result := True;
  //
end;


function AbreArquivoNoFormatoCerto(sP1:String): boolean;
begin
  //
  if Form1.bPDF then
  begin
    //
    Screen.Cursor            := crHourGlass;
    HtmlParaPdf(sP1);
    ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\'+sP1+'.pdf'),'', '', SW_SHOWMAXIMIZED);
    Screen.Cursor            := crDefault;
    //
  end else
  begin
    //
    ShellExecute( 0, 'Open',pChar(form1.sAtual+'\'+sP1+'.HTM'),'', '', SW_SHOWMAXIMIZED);
    //
  end;
  //
  Result := True;
  //
end;


function AssinaRegistro(pNome: String; DataSet: TDataSet; bP: Boolean): Boolean;
var
  // sNomes : String;
  // i : Integer;
  s : String;
begin
  //
  // Usei este bloco para pegar o nome dos CAMPOS
  //
  //
  //    for I := 1 to DataSet.Fields.Count -1 do
  //    begin
  //      if (DataSet.Fields[I].FieldName <> 'ENCRYPTHASH') and (DataSet.Fields[I].FieldName <> 'REGISTRO') then
  //      sNomes := sNomes + DataSet.Fields[I].FieldName +Chr(10);
  //    end;
  //    ShowMessage(sNomes);
  //
  Result := True;
  s := '';
  //
  try
    if pNome = 'ESTOQUE' then
    begin
      s :=
      DataSet.FieldByname('REFERENCIA').AsString+
      DataSet.FieldByname('DESCRICAO').AsString+
      DataSet.FieldByname('NOME').AsString+
      DataSet.FieldByname('MEDIDA').AsString+
      DataSet.FieldByname('PRECO').AsString+
      DataSet.FieldByname('QTD_ATUAL').AsString+
      DataSet.FieldByname('DAT_INICIO').AsString+
      DataSet.FieldByname('ULT_COMPRA').AsString+
      DataSet.FieldByname('ULT_VENDA').AsString+
      DataSet.FieldByname('CF').AsString+
      DataSet.FieldByname('IPI').AsString+
      DataSet.FieldByname('CST').AsString+
      DataSet.FieldByname('ST').AsString+
      DataSet.FieldByname('IAT').AsString+
      DataSet.FieldByname('IPPT').AsString;
    end;
    //
    if pNome = 'ALTERACA' then
    begin
      s :=
      DataSet.FieldByname('DESCRICAO').AsString+
      DataSet.FieldByname('QUANTIDADE').AsString+
      DataSet.FieldByname('MEDIDA').AsString+
      DataSet.FieldByname('UNITARIO').AsString+
      DataSet.FieldByname('TOTAL').AsString+
      DataSet.FieldByname('DATA').AsString+
      DataSet.FieldByname('TIPO').AsString+
      DataSet.FieldByname('PEDIDO').AsString+
      DataSet.FieldByname('ITEM').AsString+
      DataSet.FieldByname('CLIFOR').AsString+
      DataSet.FieldByname('VENDEDOR').AsString+
      DataSet.FieldByname('CAIXA').AsString+
      DataSet.FieldByname('VALORICM').AsString+
      DataSet.FieldByname('ALIQUICM').AsString+
      DataSet.FieldByname('HORA').AsString+
      DataSet.FieldByname('DAV').AsString+
      DataSet.FieldByname('TIPODAV').AsString+
      DataSet.FieldByname('CNPJ').AsString+
      DataSet.FieldByname('COO').AsString+
      DataSet.FieldByname('CCF').AsString+
      DataSet.FieldByname('REFERENCIA').AsString;
      //
    end;
    //
    if pNome = 'REDUCOES' then
    begin
      s :=
      DataSet.FieldByname('HORA').AsString+
      DataSet.FieldByname('SERIE').AsString+
      DataSet.FieldByname('PDV').AsString+
      DataSet.FieldByname('TIPOECF').AsString+
      DataSet.FieldByname('MARCAECF').AsString+
      DataSet.FieldByname('MODELOECF').AsString+
      DataSet.FieldByname('VERSAOSB').AsString+
      DataSet.FieldByname('DATASB').AsString+
      DataSet.FieldByname('HORASB').AsString+
      DataSet.FieldByname('CUPOMI').AsString+
      DataSet.FieldByname('CUPOMF').AsString+
      DataSet.FieldByname('CONTADORZ').AsString+
      DataSet.FieldByname('TOTALI').AsString+
      DataSet.FieldByname('TOTALF').AsString+
      DataSet.FieldByname('ALIQUOTA01').AsString+
      DataSet.FieldByname('ALIQUOTA02').AsString+
      DataSet.FieldByname('ALIQUOTA03').AsString+
      DataSet.FieldByname('ALIQUOTA04').AsString+
      DataSet.FieldByname('ALIQUOTA05').AsString+
      DataSet.FieldByname('ALIQUOTA06').AsString+
      DataSet.FieldByname('ALIQUOTA07').AsString+
      DataSet.FieldByname('ALIQUOTA08').AsString+
      DataSet.FieldByname('ALIQUOTA09').AsString+
      DataSet.FieldByname('ALIQUOTA10').AsString+
      DataSet.FieldByname('ALIQUOTA11').AsString+
      DataSet.FieldByname('ALIQUOTA12').AsString+
      DataSet.FieldByname('ALIQUOTA13').AsString+
      DataSet.FieldByname('ALIQUOTA14').AsString+
      DataSet.FieldByname('ALIQUOTA15').AsString+
      DataSet.FieldByname('ALIQUOTA16').AsString+
      DataSet.FieldByname('ALIQUOTA17').AsString+
      DataSet.FieldByname('ALIQUOTA18').AsString+
      DataSet.FieldByname('ALIQUOTA19').AsString+
      DataSet.FieldByname('ALIQU01').AsString+
      DataSet.FieldByname('ALIQU02').AsString+
      DataSet.FieldByname('ALIQU03').AsString+
      DataSet.FieldByname('ALIQU04').AsString+
      DataSet.FieldByname('ALIQU05').AsString+
      DataSet.FieldByname('ALIQU06').AsString+
      DataSet.FieldByname('ALIQU07').AsString+
      DataSet.FieldByname('ALIQU08').AsString+
      DataSet.FieldByname('ALIQU09').AsString+
      DataSet.FieldByname('ALIQU10').AsString+
      DataSet.FieldByname('ALIQU11').AsString+
      DataSet.FieldByname('ALIQU12').AsString+
      DataSet.FieldByname('ALIQU13').AsString+
      DataSet.FieldByname('ALIQU14').AsString+
      DataSet.FieldByname('ALIQU15').AsString+
      DataSet.FieldByname('ALIQU16').AsString+
      DataSet.FieldByname('CANCELAMEN').AsString+
      DataSet.FieldByname('DESCONTOS').AsString+
      DataSet.FieldByname('ISSQN').AsString+
      DataSet.FieldByname('SMALL').AsString+
      DataSet.FieldByname('STATUS').AsString;
      //
    end;
    //
    if pNome = 'ORCAMENT' then
    begin
      s :=
      DataSet.FieldByname('DESCRICAO').AsString+
      DataSet.FieldByname('QUANTIDADE').AsString+
      DataSet.FieldByname('UNITARIO').AsString+
      DataSet.FieldByname('TOTAL').AsString+
      DataSet.FieldByname('DATA').AsString+
      DataSet.FieldByname('TIPO').AsString+
      DataSet.FieldByname('PEDIDO').AsString+
      DataSet.FieldByname('CLIFOR').AsString+
      DataSet.FieldByname('VENDEDOR').AsString+
      DataSet.FieldByname('CAIXA').AsString+
      DataSet.FieldByname('MEDIDA').AsString+
      DataSet.FieldByname('ITEM').AsString+
      DataSet.FieldByname('VALORICM').AsString+
      DataSet.FieldByname('ALIQUICM').AsString+
      DataSet.FieldByname('NUMERONF').AsString+
      DataSet.FieldByname('COO').AsString;
      //
    end;
    //
    if pNome = 'PAGAMENT' then
    begin
      //
      s :=
      DataSet.FieldByname('PEDIDO').AsString+
      DataSet.FieldByname('CAIXA').AsString+
      DataSet.FieldByname('CLIFOR').AsString+
      DataSet.FieldByname('VENDEDOR').AsString+
      DataSet.FieldByname('FORMA').AsString+
      DataSet.FieldByname('VALOR').AsString+
      DataSet.FieldByname('GNF').AsString;
      //
    end;
    //
    // Não posso usar este bloco porque senão a ordem dos campos muda
    //
    // s := '';
    // for I := 1 to DataSet.Fields.Count -1 do
    // begin
    //   if (DataSet.Fields[I].FieldName <> 'ENCRYPTHASH') and (DataSet.Fields[I].FieldName <> 'REGISTRO') then s := s + DataSet.Fields[I].AsString;
    // end;
    //
    Form1.LbBlowfish1.GenerateKey(Form1.sPasta); // Minha chave secreta
    //
    if bP then
    begin
      DataSet.Fieldbyname('ENCRYPTHASH').AsString := Form1.LbBlowfish1.EncryptString(MD5Print(MD5String(s))); // Encrypta e grava o hash do registro
    end else
    begin
      if DataSet.Fieldbyname('ENCRYPTHASH').AsString = Form1.LbBlowfish1.EncryptString(MD5Print(MD5String(s))) then  // Encrypta e compara o hash do registro
      begin
        Result := True;
      end else
      begin
        Result := False;
      end;
    end;
  except ShowMessage('Erro ao criptografar head do registro do arquivo '+pNome) end;
  //
end;

function GetIP:string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^  do
  begin
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;


function MostraFoto(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
begin
  //
  if Form1.ibDataset4FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form1.ibDataset4.CreateBlobStream(Form1.ibDataset4FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form1.Image2.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form1.Image2.Picture.Width > Form1.Image2.Picture.Height then
    begin
      Form1.Image2.Width  := (StrToInt(StrZero((Form1.Image2.Picture.Width * (Form1.Panel9.Width / 2 / Form1.Image2.Picture.Width)),10,0)))*2;
      Form1.Image2.Height := (StrToInt(StrZero((Form1.Image2.Picture.Height* (Form1.Panel9.Width / 2 / Form1.Image2.Picture.Width)),10,0)))*2;
    end else
    begin
      Form1.Image2.Width  := (StrToInt(StrZero((Form1.Image2.Picture.Width * (Form1.Panel9.Height / 2 / Form1.Image2.Picture.Height)),10,0)))*2;
      Form1.Image2.Height := (StrToInt(StrZero((Form1.Image2.Picture.Height* (Form1.Panel9.Height / 2 / Form1.Image2.Picture.Height)),10,0)))*2;
    end;
    Form1.Image2.Left := (Form1.Panel9.Width  - Form1.Image2.Width) div 2;
    Form1.Image2.Top  := (Form1.Panel9.Height - Form1.Image2.Height) div 2;
    Form1.Image2.Repaint;
    Form1.Panel9.Visible := True;
    Form1.Image2.Visible := True;
  end else
  begin
    Form1.Image2.Picture := nil;
    Form1.Image2.Visible := False;
    Form1.Panel9.Visible := False;
  end;
  Result := True;
end;

function MostraFoto2(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
begin
  //
  if Form1.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form1.ibDataset2.CreateBlobStream(Form1.ibDataset2.FieldByname('FOTO'),bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form1.Image2.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form1.Image2.Picture.Width > Form1.Image2.Picture.Height then
    begin
      Form1.Image2.Width  := (StrToInt(StrZero((Form1.Image2.Picture.Width * (Form1.Panel9.Width / 2 / Form1.Image2.Picture.Width)),10,0)))*2;
      Form1.Image2.Height := (StrToInt(StrZero((Form1.Image2.Picture.Height* (Form1.Panel9.Width / 2 / Form1.Image2.Picture.Width)),10,0)))*2;
    end else
    begin
      Form1.Image2.Width  := (StrToInt(StrZero((Form1.Image2.Picture.Width * (Form1.Panel9.Height / 2 / Form1.Image2.Picture.Height)),10,0)))*2;
      Form1.Image2.Height := (StrToInt(StrZero((Form1.Image2.Picture.Height* (Form1.Panel9.Height / 2 / Form1.Image2.Picture.Height)),10,0)))*2;
    end;
    Form1.Image2.Left := (Form1.Panel9.Width  - Form1.Image2.Width) div 2;
    Form1.Image2.Top  := (Form1.Panel9.Height - Form1.Image2.Height) div 2;
    Form1.Image2.Repaint;
    Form1.Panel9.Visible := True;
    Form1.Image2.Visible := True;
  end else
  begin
    Form1.Image2.Picture := nil;
    Form1.Image2.Visible := False;
    Form1.Panel9.Visible := False;
  end;
  Result := True;
end;

function Commitatudo(P1:Boolean): Boolean;
begin
  //
  try
    HasHs('ORCAMENT',True);
  except end;
  //
  if (Length(Form1.Edit1.Text)=10) and (Alltrim(Form1.ibDataSet37.FieldByname('PEDIDO').AsString)='') then
  begin
    try
      //
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSql.Clear;
      Form1.ibDataset99.SelectSql.Add('select gen_id(G_ORCAMENTO,0) from rdb$database');
      Form1.ibDataset99.Open;
      //
      if Form1.Edit1.Text = StrZero(StrToInt(Form1.ibDataSet99.FieldByname('GEN_ID').AsString),10,0) then
      begin
        Form1.ibDataSet99.Close;
        Form1.ibDataSet99.SelectSql.Clear;
        Form1.ibDataset99.SelectSql.Add('select gen_id(G_ORCAMENTO,-1) from rdb$database');
        Form1.ibDataset99.Open;
      end;
      //
    except end;
  end;
  //
  try
    Form1.IBTransaction1.Commit;
  except
    ShowMessage('Erro ao gravar os dados fisicamente arquivos. Erro 330');
  end;
  //
  try
    //
    if P1 then
    begin
      //
      Form1.ibDataSet4.Selectsql.Clear;
      Form1.ibDataSet2.Selectsql.Clear;
      Form1.ibDataSet9.Selectsql.Clear;
      Form1.ibDataSet37.Selectsql.Clear;
      Form1.ibDataSet13.Selectsql.Clear;
      //
      Form1.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');
      Form1.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME=''X.X.X.X'' and coalesce(ATIVO,0)=0 order by NOME');
      Form1.ibDataSet9.Selectsql.Add('select * from VENDEDOR');
      Form1.ibDataSet37.Selectsql.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Copy(Form1.Edit1.Text,1,10))+'');
      Form1.ibDataSet13.Selectsql.Add('select * from EMITENTE');
      //
    end;
    //
    try Form1.ibDataSet4.Active := True; except ShowMessage('Erro ao abrir arquivo 4');  end;
    try Form1.ibDataset2.Active := True; except ShowMessage('Erro ao abrir arquivo 2'); end;
    try Form1.ibDataSet9.Active := True; except ShowMessage('Erro ao abrir arquivo 9'); end;
    try Form1.ibDataSet13.Active := True; except ShowMessage('Erro ao abrir arquivo 13'); end;
    try Form1.ibDataSet37.Active := True; except ShowMessage('Erro ao abrir arquivo 27'); end;
    //
  except
    ShowMessage('Erro ao abrir arquivos. Erro 359');
  end;
  //
  Form1.ibDataSet13.Edit;
  Form1.ibDataSet13RESE.AsFloat := 0;
  //
  Result := True;
  //
end;

function Altera(pP1: boolean): Boolean;
begin
  //
  // Criar novos registros com o orcamento antigo
  //
  Result := True;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Retangulo : Trect;
  wndHandle:THandle;
  Mais1Ini : TIniFile;
  iAjuste, I : Integer;
  wndClass:array[0..50] of char;
  Url, IP, Alias : String;
begin
  //
//  ShowMessage('O orçamento só pode impresso em equipamento diverso do ECF desde que instalado fora do recinto de atendimento ao público; e ser convertido em arquivo do tipo PDF (portable document format).');
  //
  Form1.sPasta  := 'FFEAA766654488992624076BDF9907FBBDEFF3CF616D352280FD6F0E13A59109D7761E3E0492EAB3DF38EB6D125451C36662933A3AC0D5AAC6AC4F926E89'+
                   'F717DFB1F4CB28B1D11CD44517DDDC1A3D21AA1004C13FC87E952322E73E2A969A7240A51F324E11EC8D9B9367B1C28A69035EABD45C33FD522C21A798BE4F49B95B';
  //
  if Copy(WinVersion,1,3)='006' then Form1.iVista := 5 else Form1.iVista := 0;
  //
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0],nil);
  GetWindowRect(wndHandle,Retangulo);
  //
  Form1.Top    := 0;
  Form1.Left   := 0;
  Form1.Width  := Screen.Width;
  Form1.Height := Screen.Height;
  //
  // CHDir('I:\teste');
  //
  sCaixa   := '0001';
  bChave   := False;
  bImporta := False;
  //
  GetDir(0,sAtual);
  //
  Mais1ini                     := TIniFile.Create('FRENTE.INI');
  sPorta := Mais1Ini.ReadString('Orçamento','Porta','Impressora padrão do windows');
  Form1.Image14.Picture := Form1.Image3.Picture;
  Mais1ini.Free;
  //
  Form1.ibDataSet37UNITARIO.ReadOnly := True;
  Form1.ibDataSet37TOTAL.ReadOnly := True;
  //
  Form1.ibDataSet37UNITARIO.ReadOnly := False;
  Form1.ibDataSet37TOTAL.ReadOnly := False;
  //
  Mais1ini      := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  ConfCusto     := Mais1Ini.ReadString('Permitir','Vendas abaixo do custo','Sim');
  ConfNegat     := Mais1Ini.ReadString('Permitir','Estoque negativo','Sim');
  ConfCasas     := Mais1Ini.ReadString('Outros','Casas decimais na quantidade','2');
  ConfPreco     := Mais1Ini.ReadString('Outros','Casas decimais no preço','2');
  //
  try
    fConfDesconto := StrToFloat(Mais1Ini.ReadString('Outros','Desconto','0'));
  except
    fConfDesconto := 0;
  end;
  //
  try
    fConfDescontoTotal := StrToFloat(Mais1Ini.ReadString('Outros','Desconto total','0'));
  except
    fConfDescontoTotal := 0;
  end;
  //
  if ConfPreco = '0' then ibDataSet37UNITARIO.DisplayFormat := '#,##0';
  if ConfPreco = '1' then ibDataSet37UNITARIO.DisplayFormat := '#,##0.0';
  if ConfPreco = '2' then ibDataSet37UNITARIO.DisplayFormat := '#,##0.00';
  if ConfPreco = '3' then ibDataSet37UNITARIO.DisplayFormat := '#,##0.000';
  if ConfPreco = '4' then ibDataSet37UNITARIO.DisplayFormat := '#,##0.0000';
  //
  if ConfPreco = '0' then ibDataSet37TOTAL.DisplayFormat := '#,##0';
  if ConfPreco = '1' then ibDataSet37TOTAL.DisplayFormat := '#,##0.0';
  if ConfPreco = '2' then ibDataSet37TOTAL.DisplayFormat := '#,##0.00';
  if ConfPreco = '3' then ibDataSet37TOTAL.DisplayFormat := '#,##0.000';
  if ConfPreco = '4' then ibDataSet37TOTAL.DisplayFormat := '#,##0.0000';
  //
  if ConfCasas = '0' then ibDataSet37QUANTIDADE.DisplayFormat := '#,##0';
  if ConfCasas = '1' then ibDataSet37QUANTIDADE.DisplayFormat := '#,##0.0';
  if ConfCasas = '2' then ibDataSet37QUANTIDADE.DisplayFormat := '#,##0.00';
  if ConfCasas = '3' then ibDataSet37QUANTIDADE.DisplayFormat := '#,##0.000';
  if ConfCasas = '4' then ibDataSet37QUANTIDADE.DisplayFormat := '#,##0.0000';
  //
  Mais1Ini.Free;
  // Ano 200 bug free
  ShortDateFormat := 'dd/mm/yyyy';
  //
  Mais1Ini := TIniFile.Create(Form1.sAtual+'\small.ini');
  Url      := Mais1Ini.ReadString('Firebird','Server url','');
  IP       := AllTrim(Mais1Ini.ReadString('Firebird','Server IP',''));
  Alias    := AllTrim(Mais1Ini.ReadString('Firebird','Alias',''));
  //
  if IP = '' then IP := GetIp;
  //
  if IP <> '' then Url := IP+':'+Url+'\small.fdb' else Url:= Url+'\small.fdb';
  //
  if Alltrim(Alias) <> '' then
  begin
    Url := IP+':'+Alias;
  end;
  //
  Mais1Ini.Free;
  //
  // Se não existe cria o arquivo GDB
  //
  try
    IBDatabase1.Close;
    IBDatabase1.Params.Clear;
    IbDatabase1.DatabaseName := Url;
    IBDatabase1.Params.Add('USER_NAME=SYSDBA');
    IBDatabase1.Params.Add('PASSWORD=masterkey');
    IbDatabase1.Open;
    IBTransaction1.Active := True;
  except
    //
    ShowMessage('Verifique se o servidor de dados está ligado e sua conexão de rede disponível.');
    Form1.DestroyWindowHandle;
    Halt(1);
    Halt(1);
    //
  end;
  //
  Edit1.Text := '';
  //
  try
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSql.Clear;
    Form1.ibDataset99.SelectSql.Add('select gen_id(G_ORCAMENTO,0) from rdb$database');
    Form1.ibDataset99.Open;
    //
    Edit1.Text := ibDataSet99.FieldByname('GEN_ID').AsString;
    //
    Form1.ibDataset99.Close;
  except end;
  //
  if Edit1.Text = '' then
  begin
    try
      Form1.ibDataset99.Close;
      Form1.ibDataset99.SelectSql.Clear;
      Form1.ibDataset99.SelectSql.Add('create generator G_ORCAMENTO ');
      Form1.ibDataset99.Open;
      Form1.ibDataset99.Close;
    except end;
    try
      //
      Form1.IBDataSet99.Close;
      Form1.IBDataSet99.SelectSQL.Clear;
      Form1.IBDataSet99.SelectSQL.Add('select max(PEDIDO) from ORCAMENT');
      Form1.IBDataSet99.Open;
      Edit1.Text := Form1.IBDataSet99.fieldByname('MAX').AsString;
      //
      Form1.ibDataset99.Close;
      Form1.ibDataset99.SelectSql.Clear;
      Form1.ibDataset99.SelectSql.Add('set generator G_ORCAMENTO to '+Edit1.Text+' ');
      Form1.ibDataset99.Open;
      //
    except end;
  end;
  //
  Edit1.Text := '';
  //
  try
    //
    ibDataSet37.Active := True;  // Alteraca
    ibDataSet4.Active  := True;  // Estoque
    ibDataSet2.Active  := True;  // Clientes
    ibDataSet13.Active := True;  // Emitente
    ibDataSet9.Active  := True;  // Vendedores
    //
  except
    //
    try
      Mais1Ini.WriteInteger('Orçamento','Arquivo',0);
      Mais1Ini.Free;
    except end;
    //
    ShowMessage('Atenção:'+Chr(10)+Chr(10)+
                '         Entre no sistema de retaguarda para criar todos'+ Chr(10) +
                '         os arquivos necessários para rodar o sistema.');
    //
    Form1.DestroyWindowHandle;
    Application.Terminate;
    Halt(1);
    //
  end;
  //
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0],nil);
  GetWindowRect(wndHandle,Retangulo);
  //
  // Dados do Emitente
  Label14.Caption := Trim(Copy(ibDataSet13.FieldByname('NOME').AsString+Replicate(' ',35),1,35));
  Label23.Caption := Trim(ibDataSet13.FieldByname('CGC').AsString);
  if AllTrim(Label23.Caption) = '' then Label23.Caption := '<CNPJ/CPF>';
  // Label15.Caption := Trim(ibDataSet13.FieldByname('TELEFO').AsString);
  if Pos('xx',ibDataSet13.FieldByNAme('TELEFO').AsString) = 0 then
       Label15.Caption := AllTrim('('+Copy(ibDataSet13.FieldByNAme('TELEFO').AsString,1,1)+'xx'+
       Copy(ibDataSet13.FieldByNAme('TELEFO').AsString,2,2)+')'+
       Copy(ibDataSet13.FieldByNAme('TELEFO').AsString+'              ',4,15)
       ) else Label15.Caption := AllTrim(ibDataSet13.FieldByNAme('TELEFO').AsString);

  ////////////////////////////////////////////
  //
  iAjuste := 0;
  if Screen.Height = 480 then iAjuste :=  0;
  if Screen.Height =  600 then iAjuste :=  25 + 10;
  if Screen.Height >=  768 then iAjuste :=  160 + 35;
  //
  ScrollBox1.Height := Form1.Height - 15 - ((Retangulo.Bottom - Retangulo.Top));
  if ScrollBox1.Height > 690 then ScrollBox1.Height := 690;
  dBGrid1.Height    := ScrollBox1.Height - dBGrid1.Top - 106;
  //
  Form1.Panel7.Left   := Form1.DBGrid1.Left + 583 + 1;
  Form1.Panel7.Top    := Form1.Panel6.Top;
  Form1.Panel7.Height := Form1.DBGrid1.Height + Form1.Panel6.Height -1;
  //
  Form1.Panel8.Left     := Form1.DBGrid1.Left + 583 + 0;
  Form1.Panel8.Height   := Form1.DBGrid1.Height + Form1.Panel6.Height -1;
  //
  ScrollBox1.Top    := 10;
  ScrollBox1.Left   := 10;
  //
  for I := 1 To Form1.ComponentCount-1 do
  begin
    if Copy(Form1.Components[I].Name,1,4) = 'Labe' then if TLAbel(Form1.Components[I]).Top    >= 312 then TLAbel(Form1.Components[I]).Top    := TLAbel(Form1.Components[I]).Top     + iAjuste;
    if Copy(Form1.Components[I].Name,1,4) = 'Edit' then if TEdit(Form1.Components[I]).Top     >= 312 then TEdit(Form1.Components[I]).Top     := TEdit(Form1.Components[I]).Top      + iAjuste;
    if Copy(Form1.Components[I].Name,1,4) = 'Imag' then if TImage(Form1.Components[I]).Top    >= 312 then TImage(Form1.Components[I]).Top    := TImage(Form1.Components[I]).Top     + iAjuste;
    if Copy(Form1.Components[I].Name,1,4) = 'C4DB' then if TSMALL_DBEdit(Form1.Components[I]).Top >= 312 then TSMALL_DBEdit(Form1.Components[I]).Top := TSMALL_DBEdit(Form1.Components[I]).Top  + iAjuste;
  end;
  //
  form1.SMALL_DBEdit1.Top := Label24.Top;
  //
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  //
  // ShowMessage('Teste: '+Form1.Edit1.Text +chr(10)+ sNumeroAtual);
  //
  ibDataset13RESE.AsFloat := 0; // Desconto;
  //
//  if StrToInt(Form1.Edit1.Text) <= strToInt(sNumeroAtual) then
  begin
    //
    Edit1.Text := StrZero(StrToInt(Edit1.Text),10,0);
    //
    Form1.ibDataSet37.Close;
    Form1.ibDataSet37.SelectSql.Clear;
    Form1.ibDataSet37.Selectsql.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Copy(Form1.Edit1.Text,1,10))+'');
    Form1.ibDataSet37.Open;
    //
    if StrToInt(Form1.Edit1.Text) < strToInt(sNumeroAtual) then
    begin
      Edit2.Text := ibDataSet37.FieldByName('CLIFOR').AsString;
      Edit3.Text := ibDataSet37.FieldByName('VENDEDOR').AsString; // Sandro Silva 2019-09-25 Trazer o vendedor selecionado
    end;
    //
    Edit4.Text := ibDataSet37.FieldByName('NUMERONF').AsString;
    //
    ibDataSet37.DisableControls;
    ibDataSet37.First;
    while not ibDataSet37.Eof do
    begin
      //
      if Alltrim(ibDataset37DESCRICAO.AsString) = 'Desconto' then
      begin
        ibDataset13RESE.AsFloat := ibDataset13RESE.AsFloat + ibDataSet37TOTAL.AsFloat;
        ibDataSet37.Delete;
      end else
      begin
        ibDataSet37.Next;
      end;
      //
    end;
    ibDataSet37.EnableControls;
    //
    if (Alltrim(Edit4.Text) <> '') or (AllTrim(ibDAtaSet37.FieldByname('COO').AsString) <> '') then
    begin
      //
      // Não pode ser alterado quando já foi emitido documento fiscal
      //
      Edit2.Enabled   := False;
      Edit3.Enabled   := False;
      dbGrid1.Enabled := False;
      //
      // dbGrid1.Hint    := 'Este documento não pode ser alterado. Documento fiscal já foi emitido.';
      // Image10.Visible := True;
      //
      ibDataSet37.Edit;
      ibDataSet37.Post;
      //
      Button1.SetFocus;
      //
    end else
    begin
      //
      Edit2.Enabled   := True;
      Edit3.Enabled   := True;
      dbGrid1.Enabled := True;
      //
      Edit2.Hint      := '';
      Edit3.Hint      := '';
      dbGrid1.Hint    := '';
      //
      Edit2.SetFocus;
      //
    end;
  end;
  //
end;

procedure TForm1.ibDataSet37NewRecord(DataSet: TDataSet);
begin
  //
  ibDataSet37REGISTRO.AsString               := sProximo;
  ibDataSet37.fieldByName('PEDIDO').AsString := copy(Edit1.Text,1,10);
  ibDataSet37.FieldByName('DATA').AsDateTime := Date;
  ibDataSet37.fieldByName('TIPO').AsString   := 'ORCAME';
  //
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  //
  if Length(AllTrim(Edit2.Text))>2 then
  begin
    ibDataset2.Close;
    ibDataset2.SelectSQL.Clear;
    ibDataset2.SelectSQL.Add('select * from CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(Edit2.Text)+'%')+' and coalesce(ATIVO,0)=0 order by Upper(NOME)');
    ibDataset2.Open;
  end;
  //
end;

procedure TForm1.Edit2Enter(Sender: TObject);
begin
  try
    //
    if Edit2.Text = ibDataSet2.fieldByName('NOME').AsString then  MostraFoto2(True);
    //
    dBGrid2.DataSource           := DataSource2;
    dBgrid2.Columns[0].Fieldname := 'NOME';
    dBgrid2.Columns[1].Fieldname := '';
    dBgrid2.Columns[2].Fieldname := '';
    dBgrid2.Columns[3].Fieldname := '';
    dBgrid2.Columns[4].Fieldname := '';
    //
    dBGrid2.Height               := Panel1.Height - Edit2.Top - Edit2.Height - 10;
    dBGrid2.Left                 := Edit2.Left;
    dbGrid2.Top                  := Edit2.Top + Edit2.Height;
    dbGrid2.Width                := 586;
    //
    DbGrid2.Visible  := True;
    //
  except end;
  //
end;

procedure TForm1.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
  if (Key = VK_CONTROL) or (Key = VK_DELETE)  then Key := 0;
  if (Key = VK_RETURN) or (Key = VK_TAB) then DBGrid2DblClick(Sender);
  //
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
begin
  //
  if AllTrim(ibDataSet2.fieldByName('NOME').AsString) <> AllTrim(Edit2.Text) then
  begin
    Edit2.Text     := ibDataSet2.fieldByName('NOME').AsString;
    Label6.Caption := ibDataSet2.FieldByName('ENDERE').AsString + ' - ' + ibDataSet2.FieldByName('COMPLE').AsString;
    Label7.Caption := ibDataSet2.FieldByName('CEP').AsString + ' ' + ibDataSet2.FieldByName('CIDADE').AsString + ', '+ ibDataSet2.FieldByName('ESTADO').AsString+' '+ibDataSet2.FieldByName('FONE').AsString;
    Label12.Caption := ibDataSet2.FieldByName('CGC').AsString;
    if AllTrim(Label12.Caption) = '' then Label12.Caption := '<CNPJ/CPF>';
  end;
  //
  Edit3.Text     := ibDataSet9.fieldByName('NOME').AsString;
  //
  if (dBgrid2.Columns[0].Fieldname = 'CODIGO') then
  begin
    //
    ibDataSet37.Edit;
    ibDataSet37.FieldByName('DESCRICAO').AsString := ibDataSet4.FieldByname('DESCRICAO').AsString;
    ibDataSet37.FieldByName('CODIGO').AsString    := ibDataSet4.FieldByname('CODIGO').AsString;
    ibDataSet37.FieldByname('PEDIDO').AsString    := Copy(Edit1.Text,1,10);
    ibDataSet37.FieldByName('DATA').AsDateTime    := Date;
    ibDataSet37.FieldByName('CLIFOR').AsString    := ibDataSet2.FieldByname('NOME').AsString;
    //
    if ibDataSet37.FieldByName('UNITARIO').AsFloat = 0 then
    begin
      ibDataSet37.FieldByName('UNITARIO').AsFloat   := ibDataSet4.FieldByname('PRECO').AsFloat;
      ibDataSet37.FieldByName('QUANTIDADE').AsFloat := 1;
    end;
    //
    dbGrid1.SetFocus;
    dbGrid1.Update;
    //
  end else
  begin
     //
    Perform(Wm_NextDlgCtl,0,0);
    //
    if dbGrid2.Left = Edit2.Left then Edit2.SetFocus;
    if dbGrid2.Left = Edit3.Left then Edit3.SetFocus;
    //
  end;
  //
  dBgrid2.Visible := False;
  //
end;

procedure TForm1.Edit2Exit(Sender: TObject);
begin
  try
    //
    MostraFoto2(True);
    Label6.Caption := ibDataSet2.FieldByName('ENDERE').AsString + ' - ' + ibDataSet2.FieldByName('COMPLE').AsString;
    Label7.Caption := ibDataSet2.FieldByName('CEP').AsString + ' ' + ibDataSet2.FieldByName('CIDADE').AsString + ', '+ ibDataSet2.FieldByName('ESTADO').AsString + ' ' + ibDataSet2.FieldByName('FONE').AsString;
    Label12.Caption := ibDataSet2.FieldByName('CGC').AsString;
    if AllTrim(Label12.Caption) = '' then Label12.Caption := '<CNPJ/CPF>';
    //
  except end;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
// var
//  sAntigo : String;
begin
  //
  //
  try
    if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
    if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_DOWN   then Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP     then Perform(Wm_NextDlgCtl,-1,0);
    //
  except
    ShowMessage('Erro 102');
    Halt(1);
  end;
  //
end;

procedure TForm1.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if ((Key = VK_RETURN) or (Key = VK_TAB)) then
    begin
      Edit2.Text := ibDataSet2.fieldByName('NOME').AsString;
      DBgrid2.Visible := False;
      Perform(Wm_NextDlgCtl,0,0);
    end;
    if Key = VK_UP then
    begin
      DBgrid2.Visible := False;
      Perform(Wm_NextDlgCtl,-1,0);
    end;
    if Key = VK_DOWN then dBgrid2.Setfocus;
  except end;
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
end;

procedure TForm1.Edit3Enter(Sender: TObject);
begin
  try
    //
    dBGrid2.TabOrder             := 3;
    dBgrid2.Columns[0].Fieldname := 'NOME';
    dBgrid2.Columns[1].Fieldname := '';
    dBgrid2.Columns[2].Fieldname := '';
    dBgrid2.Columns[3].Fieldname := '';
    dBgrid2.Columns[4].Fieldname := '';
    //
    dBGrid2.DataSource           := DataSource9;
    dbGrid2.Top                  := Edit3.Top + Edit3.Height;
    dBGrid2.Height               := Panel1.Height - Edit3.Top - Edit3.Height -10;
    //
    dBGrid2.Left                 := Edit3.Left;
    dbGrid2.Top                  := Edit3.Top + Edit3.Height;
    dbGrid2.Width                := 236;
    //
    DbGrid2.Visible  := True;
    //
  except end;
  //
end;

procedure TForm1.DBGrid1Enter(Sender: TObject);
begin
  //
  try
    //
    dBGrid2.DataSource           := DataSource4;
    dBgrid2.Columns[0].Fieldname := 'CODIGO';
    dBgrid2.Columns[1].Fieldname := 'DESCRICAO';
    dBgrid2.Columns[2].Fieldname := 'MEDIDA';
    dBgrid2.Columns[3].Fieldname := 'QTD_ATUAL';
    dBgrid2.Columns[4].Fieldname := 'PRECO';
    //
    dBGrid2.Left                 := DbGrid1.Left;
    dbGrid2.Top                  := DbGrid1.Top + DbGrid1.Height;
    dbGrid2.Width                := DbGrid1.Width;

    dbGrid2.Width                := 584;

    dBGrid2.Height               := Panel1.Height - DbGrid1.Top - DbGrid1.Height - 10;
    //
  except end;
  //
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  //
  ibDataSet9.Close;
  ibDataSet9.SelectSQL.Clear;
  ibDataSet9.SelectSQL.Add('select * FROM VENDEDOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(Edit3.Text)+'%')+' order by NOME');
  ibDataSet9.Open;
  //
end;

procedure TForm1.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if dbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);

  //
  // desconto em precentual %
  //
  if Key = Chr(37) then
  begin
    if DbGrid1.SelectedIndex = 3 then
    begin
      //
      ibDataSet4.Close;                                                //
      ibDataSet4.Selectsql.Clear;
      ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
      ibDataSet4.Open;
      //
      ibDataSet37.UpdateRecord;
      //
      if  ibDataSet37TOTAL.AsFLoat > fConfDesconto then
      begin
        ShowMessage('Desconto não permitido!'+chr(10)+chr(10)+
        'Verifique as permissões com o Administrador em:'+chr(10)+
        'Configurações do Sistema; Permitir.'+chr(10)+chr(10)+
        'Esta configurado para permitir no máximo '+FloatToStr(fConfDesconto)+'% de desconto no item.');
        //
        ibDataSet37UNITARIO.AsFLoat := Form1.ibDataSet4PRECO.AsFloat;
        //
      end else
      begin
        ibDataSet37UNITARIO.AsFLoat := Form1.ibDataSet4PRECO.AsFloat - (ibDataSet37TOTAL.AsFLoat * Form1.ibDataSet4PRECO.AsFloat / 100);
      end;
      //
    end;
  end;
end;

procedure TForm1.Button1Enter(Sender: TObject);
begin
  //
  dbGrid2.Visible := False;
  //
end;

procedure TForm1.Edit3Exit(Sender: TObject);
begin
  try
    ibDataSet37.DisableControls;
    ibDataSet37.First;
    while not ibDataSet37.Eof do
    begin
      ibDataSet37.Edit;
      ibDataSet37.FieldByName('VENDEDOR').AsString := Edit3.Text;
      ibDataSet37.Next;
    end;
    ibDataSet37.EnableControls;
  except end;
end;

function ImprimeNaImpressoraDoWindows(sP1: String): Boolean;
var
  I, iLinha, iTamanho : Integer;
  sLinha : String;
  iMargemLeft: Integer;// Sandro Silva Controla a margem a esquerda onde inicia a impressão
begin
  //
  try
    //
    if VerificaSeTemImpressora() then
    begin
      //
      iMargemLeft := 5; // Sandro Silva 2015-05-06
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iMargemLeft := 15;
      Printer.Canvas.Pen.Width  := 1;             // Largura da linha  //
      Printer.Canvas.Font.Name  := 'Courier New'; // Tipo da fonte     //
      Printer.Canvas.Font.Size  := 7;             // Tamanho da fonte  //
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        Printer.Canvas.Font.Size  := 5;
      Printer.Canvas.Font.Style := [fsBold];      // Coloca em negrito //
      Printer.Canvas.Font.Color := clBlack;
      //Sandro Silva 2015-05-06 "a" impresso ocupa menos espaço que "W" iTamanho := Printer.Canvas.TextWidth('a') * 3;   // Tamanho que cada caractere ocupa na impressão em pontos
      iTamanho := Printer.Canvas.TextWidth('W') * 3;   // Tamanho que cada caractere ocupa na impressão em pontos
      if Printer.PageWidth <= 464 then // Sandro Silva 2018-03-26
        iTamanho := Trunc(Printer.Canvas.TextWidth('W') * 2.5);   // Tamanho que cada caractere ocupa na impressão em pontos // Sandro Silva 2018-03-23  iTamanho := Printer.Canvas.TextWidth('W') * 4;   // Tamanho que cada caractere ocupa na impressão em pontos
      Printer.Title := 'Relatório Gerencial';          // Este título é visto no spoool da impressora
      Printer.BeginDoc;                                // Inicia o documento de impressão
      //
      iLinha := 1;
      //
      for I := 1 to Length(sP1) do
      begin
        //
        if Copy(sP1,I,1) <> chr(10) then
        begin
          sLinha := sLinha+Copy(sP1,I,1);
        end else
        begin
          //
          Printer.Canvas.TextOut(iMargemLeft, iLinha * iTamanho,sLinha);  // Impressão da linha
          iLinha := iLinha + 1;
          sLinha:='';
          {Sandro Silva 2014-08-27 inicio}
          //A partir da posição vertical atual do canvas + a altura da fonte verifica se é maior que a altura da página da impressora padrão
          if (Printer.Canvas.PenPos.Y + Printer.Canvas.TextHeight('Ég')) >= (Printer.PageHeight - (Printer.Canvas.TextHeight('Ég') * 3)) then // Controla avanço de páginas
          begin
            Printer.NewPage;
            iLinha := 1;
          end;
          {Sandro Silva 2014-08-27 final}
        end;
      end;
      //
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+1) * iTamanho,' ');  //
      Printer.Canvas.TextOut(iMargemLeft, (iLinha+2) * iTamanho,' ');  //
      //
      Printer.EndDoc;
      //
    end else
    begin
      ShowMessage('Não há impressora instalada no windows!');
    end;
    //
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao imprimir! '+E.Message);
    end;
  end;
  //
  Result := True;
  //
end;



procedure TForm1.Button1Click(Sender: TObject);
var
  F : TextFile;
  fTotal, fDesconto : double;
  sCupomFiscalVinculado, sCodigo: string;
begin
  //
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  //
  try
    //
    Form1.Image14.Picture := Form1.Image3_.Picture;
    Form1.Image14.Repaint;
    //
    Form1.ibDataSet37.DisableControls;
    Form1.ibDataSet37.First;
    //
    while not Form1.ibDataSet37.Eof do
    begin
      Form1.ibDataSet37.Edit;
      Form1.ibDataSet37.FieldByName('CLIFOR').AsString    := Form1.ibDataSet2.FieldByname('NOME').AsString;
      Form1.ibDataSet37.FieldByName('VENDEDOR').AsString  := Edit3.Text;
      Form1.ibDataSet37.Post;
      Form1.ibDataSet37.Next;
    end;
    //
    Form1.ibDataSet37.EnableControls;
    Form1.ibDataSet37.DisableControls;
    Form1.ibDataSet37.First;
    //
    while not Form1.ibDataSet37.Eof do
    begin
      Form1.ibDataSet37.Edit;
      Form1.ibDataSet37.FieldByName('CLIFOR').AsString    := Form1.ibDataSet2.FieldByname('NOME').AsString;
      Form1.ibDataSet37.FieldByName('VENDEDOR').AsString  := Form1.ibDataSet9.fieldByName('NOME').AsString;
      Form1.ibDataSet37.Post;
      Form1.ibDataSet37.Next;
    end;
    //
    Form1.ibDataSet37.EnableControls;
    //
    if (sPorta = 'PDF') or (sPorta = 'HTML') then
    begin
      //
      //Sandro Silva 2019-09-25 No Small está salvando o arquivo como "Orçamento", com cedilha AssignFile(F,Form1.sAtual+'\ORCAMENTOS\'+'Orcamento '+Edit1.Text+'.htm');
      AssignFile(F,Form1.sAtual+'\ORCAMENTOS\'+'Orçamento '+Edit1.Text+'.htm');
      Rewrite(F);
      //
      // .........................................................................
      //
      Writeln(F,'<html><head><title>Orçamento '+Edit1.Text+'</title></head>');
      WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
      //
      WriteLn(F,'<table border=1 cellspacing=1 cellpadding=5 Width=650 style="border-collapse: collapse"  bordercolor=#000000>');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td>');
      WriteLn(F,'<table border=0 cellspacing=1 cellpadding=5 Width=640>');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td bgcolor=#FFFFFF>');
      WriteLn(F,'   <img src="logotip.jpg" alt="'+AllTrim(ibDataSet13NOME.AsString)+'">');
      WriteLn(F,'  </td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF>');
      WriteLn(F,'   <br><font face="Arial" size=1>Data: <b>'+ibDataSet37.FieldByname('DATA').AsString+' '+TimeToStr(Time)+'</b>');
      WriteLn(F,'   <br><font face="Arial" size=1>Vendedor: <b>'+Edit3.Text+'</b>');
      WriteLn(F,'   <br>Telefone: <b>' + AllTrim(ibDataSet13TELEFO.AsString));

      WriteLn(F,'  </td>');
      WriteLn(F,' </tr>');
      WriteLn(F,'<table>');
      WriteLn(F,'<table border=0 cellspacing=0 cellpadding=0 Width=100%>');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td bgcolor=#FFFFFF>');
      WriteLn(F,'   <center><font face="Arial" size=2><b>DOCUMENTO AUXILIAR DE VENDA - ORÇAMENTO</b></center>');
      WriteLn(F,'   <center><font face="Arial" size=2><b>NÃO É DOCUMENTO FISCAL - NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE</b></center>');
      WriteLn(F,'   <center><font face="Arial" size=2><b>MERCADORIA - NÃO COMPROVA PAGAMENTO</b></center>');
      WriteLn(F,'  </td>');
      WriteLn(F,' </tr>');
      WriteLn(F,'<table>');
      //
      WriteLn(F,'<table border=1 cellspacing=1 cellpadding=5 Width=640 style="border-collapse: collapse"  bordercolor=#000000>');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td nowrap colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Arial" size=1><center>Identificação do Estabelecimento Emitente</center></td>');
      WriteLn(F,' </tr>');
      WriteLn(F,' <tr >');
      WriteLn(F,'  <td nowrap colspan=3><font face="Arial" size=1>Denominação:  <b>'+AllTrim(Copy(ibDataSet13.FieldByname('NOME').AsString+Replicate(' ',35),1,35))+'</b>'+
      '<br>'+
      ibDataSet13.FieldByname('ENDERECO').AsString+'<br>'+
      ibDataSet13.FieldByname('CEP').AsString+' - '+ibDataSet13.FieldByname('MUNICIPIO').AsString+', '+ibDataSet13.FieldByname('ESTADO').AsString+'<br>'+
      ibDataSet13.FieldByname('COMPLE').AsString+'<br>'+
      'Telefone: '+ibDataSet13.FieldByname('TELEFO').AsString+'<br></td>');
      //
      WriteLn(F,'  <td nowrap colspan=1 vAlign=Top><font face="Arial" size=1>CNPJ/CPF:  <b>'+ibDataSet13CGC.AsString+'</b></td>');
      WriteLn(F,' </tr>');
      //
      WriteLn(F,' <tr >');
      WriteLn(F,'  <td nowrap colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Arial" size=1><center>Identificação do Destinatário</center></td>');
      WriteLn(F,' </tr >');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td nowrap colspan=3><font face="Arial" size=1>Denominação:  <b>'+AllTrim(Copy(ibDataSet2.FieldByname('NOME').AsString+Replicate(' ',35),1,35))+'</b>');
      WriteLn(F,'<br>'+
      ibDataSet2.FieldByname('ENDERE').AsString+'<br>'+
      ibDataSet2.FieldByname('CEP').AsString+' - '+ibDataSet2.FieldByname('CIDADE').AsString+', '+ibDataSet2.FieldByname('ESTADO').AsString+'<br>'+
      ibDataSet2.FieldByname('COMPLE').AsString+'<br>'+
      'Telefone: '+ibDataSet2.FieldByname('FONE').AsString+'<br>'+'</td>');
      WriteLn(F,'  <td nowrap colspan=1 vAlign=Top><font face="Arial" size=1>CNPJ/CPF:  <b>'+ibDataSet2.FieldByname('CGC').AsString+'</b></td>');
      WriteLn(F,' </tr>');
      //
      WriteLn(F,' <tr >');
      WriteLn(F,'  <td nowrap colspan=2 bgcolor=#FFFFFF width=300><font face="Arial" size=1>Número do Orçamento: <b>'+Edit1.Text+'</b></td>');
      WriteLn(F,'  <td nowrap colspan=2 bgcolor=#FFFFFF width=300><font face="Arial" size=1>Número do Documento Fiscal: <b>'+Edit4.Text+'</b></td>');
      WriteLn(F,' </tr>');
      WriteLn(F,'</table>');
      //
      WriteLn(F,' <br>');
      //
      WriteLn(F,'<table border=1 cellspacing=1 cellpadding=5 Width=640 style="border-collapse: collapse"  bordercolor=#000000>');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Código</td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=370><font face="Arial" size=1>Descrição</td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=70><font face="Arial" size=1>Quantidade</td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=50><font face="Arial" size=1>Und</td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Unitário</td>');
      WriteLn(F,'  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Total</td>');
      WriteLn(F,' </tr>');
      //
      ibDataSet37.First;
      fTotal := 0;
      iLinha := 11;
      //
      while not ibDataSet37.EOF do
      begin
        //
  //      if Alltrim(ibDataSet37CODIGO.AsString) <> '' then
  //      begin
          //
          if Alltrim(ibDataSet37CODIGO.AsString) <> '' then
          begin
            ibDataSet4.Close;                                                //
            ibDataSet4.Selectsql.Clear;
            ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
            ibDataSet4.Open;
          end;
          //
          iLinha := iLinha + 1;
          //
          if (ibDataSet4DESCRICAO.AsString = ibDataSet37DESCRICAO.AsString) and (Alltrim(ibDataSet37CODIGO.AsString) <> '') then
          begin
            //
            if AllTrim(ibDataSet4.FieldByName('REFERENCIA').AsString) = '' then sCodigo := StrZero(StrToInt(AllTrim(ibDataSet4.FieldByName('CODIGO').AsString)),13,0) else sCodigo := Copy(ibDataSet4.FieldByName('REFERENCIA').AsString+replicate(' ',13),1,13);
            //
            WriteLn(F,' <tr>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+sCodigo+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+ibDataSet37DESCRICAO.AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%7.'+ConfCasas+'n',[ibDataSet37QUANTIDADE.AsFloat])+'</td>'); // Quantidade
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+ibDataSet4.FieldByname('MEDIDA').AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[ibDataSet37UNITARIO.AsFloat])+'</td>'); // Valor
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[ibDataSet37TOTAL.AsFloat])+'</td>'); // Valor
            WriteLn(F,' </tr>');
            //
            fTotal := fTotal + ibDataSet37TOTAL.AsFloat;
            //
          end else
          begin
            if Alltrim(ibDataSet37DESCRICAO.AsString) <> '' then
            begin
              if UpperCase(ibDataSet37DESCRICAO.AsString) <> 'DESCONTO' then
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Arial" size=1></td>');
                Writeln(F,'  <td  nowrap colspan=5 bgcolor=#FFFFFFFF><font face="Arial" size=1>'+ibDataSet37DESCRICAO.AsString+'</td>');
                WriteLn(F,' </tr>');
              end else
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF></td>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+ibDataSet37DESCRICAO.AsString+'</td>');
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF></td>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF></td>');
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF></td>'); // Valor
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[ibDataSet37TOTAL.AsFloat])+'</td>'); // Valor
                WriteLn(F,' </tr>');
                fTotal := fTotal + ibDataSet37TOTAL.AsFloat;
              end;
            end;
          end;
  //      end;
        //
        ibDataSet37.NExt;
      end;
      //
      fTotal := fTotal - ibDataSet13RESE.Asfloat;
      //
      WriteLn(F,'<table border=0 cellspacing=1 cellpadding=5 Width=100%>');
      WriteLn(F,' <tr>');
      Writeln(F,'  <td bordercolor=#FFFFFF align=Right><font face="Arial" size=1><b>Desconto R$: '+Format('%12.'+Form1.ConfPreco+'n',[ibDataSet13RESE.Asfloat])+'<br><br>Total R$: '+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td></b>'); // Valor
      WriteLn(F,' </tr>');
      //
      WriteLn(F,'<table border=0 cellspacing=1 cellpadding=2 Width=100%');
      WriteLn(F,' <tr>');
      WriteLn(F,'  <br><font face="Arial" size=1><center>É vedada a autenticação deste documento</center>');
      WriteLn(F,' </tr>');
      WriteLn(F,'</table>');
      //
      WriteLn(F,'</table>');
      WriteLn(F,'  </td>');
      WriteLn(F,' </tr>');
      WriteLn(F,'</table>');
      //
      if (Alltrim(ibDataSet13HP.AsString) = '') then
      begin
        WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
      end else
      begin
        WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+ibDataSet13HP.AsString+'">'+ibDataSet13HP.AsString+'</a><font>');
      end;
      //
      WriteLn(F,'</html>');
      CloseFile(F);                                    // Fecha o arquivo
      //
      if (sPorta = 'PDF') then bPDF := True else bPDF := False;
      //
      //Sandro Silva 2019-09-25 No Small está salvando o arquivo como "Orçamento", com cedilha if FileExists(Form1.sAtual+'\ORCAMENTOS\'+'Orcamento '+Edit1.Text+'.htm') then
      if FileExists(Form1.sAtual+'\ORCAMENTOS\'+'Orçamento '+Edit1.Text+'.htm') then
      begin
      //Sandro Silva 2019-09-25 No Small está salvando o arquivo como "Orçamento", com cedilha AbreArquivoNoFormatoCerto(pChar('\ORCAMENTOS\'+'Orcamento '+Edit1.Text));
      AbreArquivoNoFormatoCerto(pChar('\ORCAMENTOS\'+'Orçamento '+Edit1.Text));
//        AbreArquivoNoFormatoCerto(pChar(Form1.sAtual+'\ORCAMENTOS\'+'Orçamento '+Edit1.Text+'.htm'));
      end;
      //
      ibDataSet37.Last;
      if Alltrim(ibDataSet37CODIGO.AsString) = '' then ibDataSet37.Delete else ibDataSet37.NExt;
      //
    end else
    begin
      //
      sCupomFiscalVinculado :=
      'DOCUMENTO AUXILIAR DE VENDA (DAV) - ORCAMENTO'+chr(13)+chr(10)+
      'NÃO É DOCUMENTO FISCAL'+chr(13)+chr(10)+
      'NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE'+chr(13)+chr(10)+
      'MERCADORIA - NÃO COMPROVA PAGAMENTO'+chr(13)+chr(10)+
      '------------------------------------------------'+chr(13)+chr(10)+
      Copy('Emitente: '+ AllTrim(Copy(ibDataSet13.FieldByname('NOME').AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      'CNPJ: '+ ibDataSet13CGC.AsString+chr(13)+chr(10)+

      Copy(ibDataSet13.FieldByname('ENDERECO').AsString  + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy(ibDataSet13.FieldByname('CEP').AsString+' - '+ibDataSet13.FieldByname('MUNICIPIO').AsString+', '+ibDataSet13.FieldByname('ESTADO').AsString  + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy(ibDataSet13.FieldByname('COMPLE').AsString  + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy('Vendedor: '+ Edit3.Text + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy('Telefone: '+ ibDataSet13.FieldByname('TELEFO').AsString + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      '-----------------------------------------------'+chr(13)+chr(10)+
      Copy('Destinatário: ' + AllTrim(Copy(ibDataSet2.FieldByname('NOME').AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      'CNPJ: '+ IBDataSet2.FieldByname('CGC').AsString + chr(13)+chr(10)+
      Copy(ibDataSet2.FieldByname('ENDERE').AsString  + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy(ibDataSet2.FieldByname('CEP').AsString+' - '+ibDataSet2.FieldByname('CIDADE').AsString+', '+ibDataSet2.FieldByname('ESTADO').AsString + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy(ibDataSet2.FieldByname('COMPLE').AsString +  Replicate(' ',45),1,45)+chr(13)+chr(10)+
      Copy('Telefone: '+ibDataSet2.FieldByname('FONE').AsString + Replicate(' ',45),1,45)+chr(13)+chr(10)+
      '-----------------------------------------------'+chr(13)+chr(10)+
      'Número do Orçamento: '+IBDataSet37.FieldByname('PEDIDO').AsString+chr(13)+chr(10)+
      'Número do Documento Fiscal: '+IBDataSet37.FieldByname('NUMERONF').AsString+chr(13)+chr(10)+
      'Data: '+DateToStr(Date)+' '+TimeToStr(Time)+chr(13)+chr(10)+
      //
      '-----------------------------------------------'+chr(13)+chr(10)+
      'CÓDIGO        DESCRIÇÃO                         '+chr(13)+chr(10)+
      'QTD         UNITARIO  TOTAL'+chr(13)+chr(10)+
      '------------------------------------------------'+chr(13)+chr(10)+'';
      //
      fTotal := 0;
      fdesconto := 0;
      //
      ibDataSet37.First;
      //
      while not ibDataSet37.Eof do
      begin
        //
        if UpperCase(AllTrim(ibDataSet37.FieldByName('DESCRICAO').AsString))  = 'DESCONTO' then
        begin
          //
          fDesconto := fDesconto + ibDataSet37.FieldByname('TOTAL').AsFloat;
          //
        end else
        begin
          //
          if Alltrim(ibDataSet37DESCRICAO.AsString) <> '' then
          begin
            //
            ibDAtaSet4.Close;
            ibDataSet4.SelectSQL.Clear;
            ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Alltrim(ibDataSet37.FieldByName('DESCRICAO').AsString))+' and coalesce(ATIVO,0)=0 ');
            ibDAtaSet4.Open;
            //
            if AllTrim(ibDAtaSet4.FieldByName('DESCRICAO').AsString) = Alltrim(ibDataSet37.FieldByName('DESCRICAO').AsString) then
            begin
              //
              if (Length(AllTrim(ibDataSet4.FieldByname('REFERENCIA').AsString)) = 13)
              or (Length(AllTrim(ibDataSet4.FieldByname('REFERENCIA').AsString)) = 14)
              or (Length(AllTrim(ibDataSet4.FieldByname('REFERENCIA').AsString)) = 8)
                then sCodigo := ibDataSet4.FieldByname('REFERENCIA').AsString
                  else sCodigo := StrZero(StrToInt('0'+ibDataSet4.FieldByname('CODIGO').AsString),14,0);
              //
              sCupomFiscalVinculado := sCupomFiscalVinculado + sCodigo + ' ' + Copy(ibDataSet37.FieldByname('DESCRICAO').AsString+Replicate(' ',30),1,30)+chr(13)+chr(10)+
              Format('%10.2n',[ibDataSet37.FieldByname('QUANTIDADE').AsFloat])+'X'+
              Format('%10.2n',[ibDataSet37.FieldByname('UNITARIO').AsFloat])+' '+
              Format('%10.2n',[ibDataSet37.FieldByname('TOTAL').AsFloat])+chr(13)+chr(10);
              //
              fTotal := fTotal +  ibDataSet37.FieldByname('TOTAL').AsFloat;
              //
            end else
            begin
              {Sandro Silva 2018-03-26 inicio
              sCupomFiscalVinculado := sCupomFiscalVinculado + '               ' + Copy(ibDataSet37.FieldByname('DESCRICAO').AsString+Replicate(' ',33),1,33)+chr(13)+chr(10);
              }
              // Divide o texto da observação em 2 partes para imprimir sem cortar
              sCupomFiscalVinculado := sCupomFiscalVinculado + '               ' + Copy(ibDataSet37.FieldByname('DESCRICAO').AsString+Replicate(' ',30),1,30)+chr(13)+chr(10);
              if Copy(ibDataSet37.FieldByname('DESCRICAO').AsString, 31, 15) <> '' then
                sCupomFiscalVinculado := sCupomFiscalVinculado + '               ' + Copy(Copy(ibDataSet37.FieldByname('DESCRICAO').AsString, 31, 15)+Replicate(' ',30),1,30)+chr(13)+chr(10);
              {Sandro Silva 2018-03-26 fim}
            end;
          end;
        end;
        //
        ibDataSet37.Next;
        //
      end;
      //
      fDesconto := ibDataSet13RESE.AsFloat;
      //
      sCupomFiscalVinculado := sCupomFiscalVinculado +  '------------------------------------------------'+chr(13)+chr(10)+
      'SUB TOTAL                           '+Format('%10.2n',[fTotal])+chr(13)+chr(10)+
      'DESCONTO                            '+Format('%10.2n',[fDesconto])+chr(13)+chr(10)+
      'TOTAL                               '+Format('%10.2n',[fTotal-fDesconto])+chr(13)+chr(10)+
      'É vedada a autenticação deste documento'+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10);
      //
      if Length(sCupomfiscalVinculado) > 80 then
      begin
        //
        if sPorta = 'Impressora padrão do windows' then
        begin
          ImprimeNaImpressoraDoWindows(sCupomFiscalVinculado);
        end else
        begin
          //
          try
            //
            if sPorta = 'TXT' then
            begin
              AssignFile(F,Form1.sAtual+'\ORCAMENTOS\'+'Orçamento '+Edit1.Text+'.txt');
              Rewrite(F);
              Writeln(F,ConverteAcentos(sCupomFiscalVinculado));
              CloseFile(F);
              ShellExecute( 0, 'Open',pChar(Form1.sAtual+'\ORCAMENTOS\'+'Orçamento '+Form1.Edit1.Text+'.txt'),'', '', SW_SHOWMAXIMIZED);
            end else
            begin
              AssignFile(F,sPorta);
              Rewrite(F);
              Writeln(F,#15+ConverteAcentos(sCupomFiscalVinculado));
              CloseFile(F);
            end;
            //
          except ShowMessage('Não foi possível imprimir em '+sPorta) end;
          //
        end;
        //
      end;
    end;
    //
    Sleep(500);
    //
  except end;
  //
  Form1.Image14.Picture := Form1.Image3.Picture;
  Form1.Image14.Repaint;
  Screen.Cursor := crDefault;
  Edit1.SetFocus;
  //
  //
end;

procedure TForm1.ibDataSet37AfterPost(DataSet: TDataSet);
var
  sReg : String;
begin
  //
  ibDataSet4.Close;                                                //
  ibDataSet4.Selectsql.Clear;
  ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
  ibDataSet4.Open;
  //
  if not bChave then
  begin
    //
    if ConfCusto <> 'Sim' then
    begin
      if (ibDataSet37UNITARIO.AsFloat < ibDataSet4.FieldByname('CUSTOCOMPR').AsFloat) and (ibDataSet37UNITARIO.AsFloat <> 0) then
      begin
        ShowMessage('Não é permitido orçar preços abaixo do custo');
        ibDataSet37.Edit;
        ibDataSet37UNITARIO.AsFloat := ibDataSet4.FieldByname('CUSTOCOMPR').AsFloat;
      end;
    end;
    //
    Label20.Caption := 'Total R$                0,00';
    //
    fTotal := 0;
    sReg := ibDataSet37REGISTRO.AsString;
    //
    ibDataSet37.DisableControls;
    ibDataSet37.First;
    while not ibDataSet37.Eof do
    begin
      //
      fTotal := fTotal + ibDataSet37TOTAL.AsFloat;
      ibDataSet37.Next;
      //
    end;
    ibDataSet37.Locate('REGISTRO',sReg,[]);
    ibDataSet37.EnableControls;
    //
    fTotal := fTotal - ibDataset13RESE.AsFloat;
    //
    Label20.Caption := 'Total R$'+Format('%20.2n',[fTotal]);
    //
  end;
  //
end;

procedure TForm1.ibDataSet37UNITARIOChange(Sender: TField);
begin
  //
  if UpperCase(ibDataSet37DESCRICAO.AsString) <> 'DESCONTO' then
  begin
    if Form1.ibDataSet37QUANTIDADE.AsString = '' then
    begin
      if Form1.ibDataSet37UNITARIO.AsString   <> '' then Form1.ibDataSet37UNITARIO.AsString   := '';
      if Form1.ibDataSet37TOTAL.AsString      <> '' then Form1.ibDataSet37TOTAL.AsString      := '';
    end else
    begin
      if ibDataSet37UNITARIO.AsFloat < 0 then ibDataSet37UNITARIO.AsFloat := ibDataSet4.FieldByname('PRECO').AsFloat;
      if ibDataSet37TOTAL.AsFloat <> Arredonda(ibDataSet37QUANTIDADE.AsFloat * ibDataSet37UNITARIO.AsFloat,StrToInt(ConfPreco)) then
      begin
        ibDataSet37TOTAL.AsFloat := Arredonda(ibDataSet37QUANTIDADE.AsFloat * ibDataSet37UNITARIO.AsFloat,StrToInt(ConfPreco));
      end;
    end;
  end;
  //
end;

procedure TForm1.Edit8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
  if Key = VK_UP then Perform(Wm_NextDlgCtl,-1,0);
  if Key = VK_DOWN then Perform(Wm_NextDlgCtl,0,0);
  if ((Key = VK_RETURN) or (Key = VK_TAB)) then Perform(Wm_NextDlgCtl,0,0);
  //
end;

procedure TForm1.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
    if ((Key = VK_RETURN) or (Key = VK_TAB)) then
    begin
      Edit3.Text := ibDataSet9.FieldByName('NOME').AsString;
      DBgrid2.Visible := False;
      Perform(Wm_NextDlgCtl,0,0);
    end;
    if Key = VK_UP then
    begin
      DBgrid2.Visible := False;
      Perform(Wm_NextDlgCtl,-1,0);
    end;
    if Key = VK_DOWN then dBgrid2.Setfocus;
  except end;
end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin
  //
  if (ibDataset13RESE.AsFloat <> 0) and (AllTrim(Edit1.Text)<>'') then
  begin
    //
    ibDataSet37.Append;
    ibDataSet37.fieldByName('PEDIDO').AsString := copy(Edit1.Text,1,10);
    ibDataset37DESCRICAO.AsString              := 'Desconto';
    ibDataset37TOTAL.AsFloat                   := ibDataset13RESE.AsFloat;
    ibDataSet37VENDEDOR.AsString               := Edit3.Text;
    ibDataSet37.FieldByName('CLIFOR').AsString := ibDataSet2.FieldByname('NOME').AsString;
    ibDataSet37.Post;
    ibDataset13.Edit;
    ibDataset13RESE.AsFloat := 0;
    //
  end;
  //
  Form1.Image2.Picture := nil;
  //
  Edit2.Enabled   := True;
  Edit3.Enabled   := True;
  dbGrid1.Enabled := True;
  //
  Edit4.Text      := '';
  Edit2.Hint      := '';
  Edit3.Hint      := '';
  dbGrid1.Hint    := '';
  Form1.Repaint;
  //
  Commitatudo(True);
  //
  try
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSql.Clear;
    Form1.ibDataset99.SelectSql.Add('select gen_id(G_MUTADO,1) from rdb$database');
    Form1.ibDataset99.Open;
  except end;
  //
  try
    //
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSql.Clear;
    Form1.ibDataset99.SelectSql.Add('select gen_id(G_ORCAMENTO,1) from rdb$database');
    Form1.ibDataset99.Open;
    //
    Edit1.Text   := StrZero(StrtoFloat('0'+Form1.IBDataSet99.fieldByname('GEN_ID').AsString),10,0);
    sNumeroAtual := Edit1.Text;
    Form1.ibDataset99.Close;
    //
  except end;
  //
  if Form1.sAntigo <> '' then
  begin
    //
    // Abre o antigo
    //
    Form1.Edit1.Text := form1.sAntigo;
    Form1.sAntigo    := '';
    //
  end else
  begin
    //
    // Abre um novo
    //
    Form1.ibDataSet37.Close;
    Form1.ibDataSet37.SelectSql.Clear;
    Form1.ibDataSet37.Selectsql.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Copy(Form1.Edit1.Text,1,10))+'');
    Form1.ibDataSet37.Open;
    //
    Form1.Label20.Caption := 'Total R$                0,00';
    Form1.Edit2.Text      := '<Nome do Cliente>';
    Form1.Label6.Caption  := '<Endereço do Cliente>';
    Form1.Label7.Caption  := '<CEP><Cidade do Cliente,><UF><Telefone>';
    Form1.Edit3.Text      := '<Nome do Vendedor>';
    //
    Form1.Edit1.SelectAll;
    //
    Form1.VertScrollbar.Position := 1;
    //
  end;
  //
end;

procedure TForm1.ibDataSet37TOTALChange(Sender: TField);
begin
  //
  if ibDataSet37TOTAL.AsFloat < 0 then
  begin
    ibDataSet37DESCRICAO.AsString := 'Desconto';
  end;
  //
  if UpperCase(ibDataSet37DESCRICAO.AsString) <> 'DESCONTO' then
  begin
    //
    if Form1.ibDataSet37QUANTIDADE.AsString = '' then
    begin
      if Form1.ibDataSet37UNITARIO.AsString   <> '' then Form1.ibDataSet37UNITARIO.AsString   := '';
      if Form1.ibDataSet37TOTAL.AsString      <> '' then Form1.ibDataSet37TOTAL.AsString      := '';
    end else
    begin
      if ibDataSet37TOTAL.AsFloat > 0 then
      begin
        if ibDataSet37QUANTIDADE.AsFloat <= 0 then ibDataSet37QUANTIDADE.AsFloat := 1;
        ibDataSet37UNITARIO.AsFloat := Arredonda((ibDataSet37TOTAL.AsFloat / ibDataSet37QUANTIDADE.AsFloat), StrToInt(ConfPreco));
      end;
    end;
  end;
  //
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
end;

procedure TForm1.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  Edit2.SelectAll;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
  Edit3.SelectAll;
end;

procedure TForm1.ibDataSet37QUANTIDADEChange(Sender: TField);
begin
  //
  if ibDataSet37DESCRICAO.AsString <> ibDataSet4.FieldByName('DESCRICAO').AsString then
  begin
    ibDataSet4.Close;                                                //
    ibDataSet4.Selectsql.Clear;
    ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
    ibDataSet4.Open;
  end;
  //
  if ibDataSet37DESCRICAO.AsString = ibDataSet4.FieldByName('DESCRICAO').AsString then
  begin
    if ibDataSet37QUANTIDADE.AsFloat <= 0 then ibDataSet37QUANTIDADE.AsFloat := 1;
    ibDataSet37UNITARIOChange(Sender);
  end else
  begin
    if Form1.ibDataSet37QUANTIDADE.AsString <> '' then Form1.ibDataSet37QUANTIDADE.AsString := '';
    if Form1.ibDataSet37UNITARIO.AsString   <> '' then Form1.ibDataSet37UNITARIO.AsString   := '';
    if UpperCase(ibDataSet37DESCRICAO.AsString) <> 'DESCONTO' then
    begin
      if Form1.ibDataSet37TOTAL.AsString      <> '' then Form1.ibDataSet37TOTAL.AsString      := '';
    end;
  end;
  //
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key <> Chr(8) then if pos(Key,'0123456789') = 0 then Key := Chr(0);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  try
    Form1.IBDataSet99.Close;
    Form1.IBDataSet99.SelectSQL.Clear;
    Form1.IBDataSet99.SelectSQL.Add('delete from ORCAMENT where coalesce(DESCRICAO,'+QuotedStr('')+')='+QuotedStr('')+' ');
    Form1.IBDataSet99.Open;
  except end;
  //
  CommitaTudo(True);
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  //
  ForceDirectories(Form1.sAtual+'\ORCAMENTOS');
  //
  Image14.Left := 630;
  //
  Image14.Top  := ScrollBox1.Height + ScrollBox1.Top - Image14.Height;
  //
  Panel9.Top    := ScrollBox1.Top;
  Panel9.Left   := Scrollbox1.Left + Scrollbox1.Width + 5;
  Panel9.Width  := Screen.Width - Panel9.Left - 10;
  //
  if Panel9.Width  > 300 then Panel9.Width := 300;
  if Panel9.Height > 300 then Panel9.Height := 300;
  //
  Button1.Left := Form1.Width + 100;
  Edit1.SetFocus;
  //
end;

procedure TForm1.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
//  if AllTrim(ibDataSet37.FieldByName('DESCRICAO').AsString) = '' then Abort;
end;

procedure TForm1.ibDataSet37BeforeInsert(DataSet: TDataSet);
begin
  ibDataSet99.Close;
  ibDataSet99.SelectSql.Clear;
  ibDataset99.SelectSql.Add('select gen_id(G_ORCAMENT,1) from rdb$database');
  ibDataset99.Open;
  sProximo := StrZero(StrToInt(ibDataSet99.FieldByname('GEN_ID').AsString),10,0);
  ibDataset99.Close;
end;

procedure TForm1.Image14Click(Sender: TObject);
begin
  Form1.Button1Click(Sender);
end;

procedure TForm1.SMALL_DBEdit1KeyPress(Sender: TObject; var Key: Char);
var
  fTotalOrcamento : Real;
begin
  if Key = Chr(13) then
  begin
    ibDataset37.Edit;
    ibDataset37.Post;
    ibDataset37.Edit;
    Button1.SetFocus;
  end;
  //
  // desconto em precentual %
  //
  if Key = Chr(37) then
  begin
    //
    // Recalcula o total
    //
    fTotalOrcamento := 0;
    //
    ibDataSet37.First;
    while not ibDataSet37.EOF do
    begin
      fTotalOrcamento := fTotalOrcamento + ibDataSet37TOTAL.AsFloat;
      ibDataSet37.NExt;
    end;
    //
    if  StrToFloat(Form1.SMALL_DBEdit1.Text) > fConfDesconto then
    begin
      ShowMessage('Desconto não permitido!'+chr(10)+chr(10)+
      'Verifique as permissões com o Administrador em:'+chr(10)+
      'Configurações do Sistema; Permitir.'+chr(10)+chr(10)+
      'Esta configurado para permitir no máximo '+FloatToStr(fConfDesconto)+'% de desconto no item.');
    end else
    begin
      Form1.ibDataSet13RESE.AsFloat := StrToFloat(Form1.SMALL_DBEdit1.Text) * (fTotalOrcamento) / 100;
    end;
    //
  end;
  //
end;

procedure TForm1.SMALL_DBEdit1Exit(Sender: TObject);
begin
  if Form1.ibDataSet13RESE.AsFloat < 0 then Form1.ibDataSet13RESE.AsFloat := 0;
  ibDataset37.Edit;
  ibDataset37.Post;
  ibDataset37.Edit;
end;

procedure TForm1.SMALL_DBEdit1Enter(Sender: TObject);
begin
  DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
  dbGrid2.Visible := False;
end;

procedure TForm1.ibDataSet37BeforeEdit(DataSet: TDataSet);
begin
  sAnterior := ibDataSet37DESCRICAO.AsString;
end;

procedure TForm1.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (dBgrid2.Columns[0].Fieldname = 'CODIGO') then MostraFoto(True);
  if (dBgrid2.Columns[0].Fieldname = 'NOME') then MostraFoto2(True);
end;

procedure TForm1.ibDataSet37BeforePost(DataSet: TDataSet);
begin
  AssinaRegistro('ORCAMENT',DataSet, True);
  HasHs('ORCAMENT',True);
end;

procedure TForm1.Label_fecha_0Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Label_minimiza_0Click(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TForm1.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  // Multi Procura
  //
  if DbGrid1.SelectedIndex = 0 then
  begin
    //
    if not (ibDataset37.State in ([dsEdit, dsInsert])) then ibDataset37.Edit;
    ibDataSet37.UpdateRecord;
    //
    if not ((Key = VK_RETURN) or (Key = VK_TAB)) then
    begin
      //
      if (Length(Limpanumero(AllTrim(ibDataSet37DESCRICAO.AsString))) <> Length(AllTrim(ibDataSet37DESCRICAO.AsString))) or (Length(Alltrim(ibDataSet37DESCRICAO.AsString))>14)  then
      begin
        //
        // Multi Procura
        //
        // Form1.Label9.Caption := ibDataSet37.FieldByname('DESCRICAO').AsString;
        //
        ibDataSet4.DisableControls;
        ibDataSet4.Close;
        ibDataSet4.SelectSQL.Clear;
        ibDataSet4.SelectSQL.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and upper(DESCRICAO) like '+QuotedStr('%'+UpperCase(ibDataSet37.FieldByname('DESCRICAO').AsString)+'%')+' order by upper(DESCRICAO)');
        ibDataSet4.Open;
        ibDataSet4.First;
        ibDataSet4.EnableControls;
        //
      end;
      //
    end;
  end;
  //
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  // Multi Procura
  //
  if DbGrid1.SelectedIndex = 0 then
  begin
    //
    if not (ibDataset37.State in ([dsEdit, dsInsert])) then ibDataset37.Edit;
    ibDataSet37.UpdateRecord;
    //
    if (Key = VK_RETURN) or (Key = VK_TAB) then
    begin
      //
      if (ibDataSet37DESCRICAO.AsString <> ibDataSet4DESCRICAO.AsString) then
      begin
        if AllTrim(ibDataSet37DESCRICAO.AsString) = '' then SMALL_DBEdit1.Setfocus else
        begin
          //
          // Procura por código
          //
          if AllTrim(ibDataSet37CODIGO.AsString) <> '' then
          begin
            ibDataSet4.Close;                                                //
            ibDataSet4.Selectsql.Clear;
            ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and CODIGO='+QuotedStr(ibDataSet37CODIGO.AsString)+' ');  //
            ibDataSet4.Open;
          end;
          //
          if (length(Alltrim(ibDataSet37DESCRICAO.AsString)) <= 5) and (LimpaNumero(Alltrim(ibDataSet37DESCRICAO.AsString))<>'') then
          begin
            try
              //
              ibDataSet4.Close;
              ibDataSet4.Selectsql.Clear;
              ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and CODIGO='+QuotedStr(StrZero(StrToInt(AllTrim(ibDataSet37DESCRICAO.AsString)),5,0))+' ');  //
              ibDataSet4.Open;
              //
            except end;
          end;
          //
          if Pos(Alltrim(ibDataSet37DESCRICAO.AsString),ibDataSet4.FieldByname('CODIGO').AsString) = 0 then
          begin
            //
            // Procura pela referencia
            //
            ibDataSet4.Close;                                                //
            ibDataSet4.Selectsql.Clear;
            ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 and REFERENCIA='+QuotedStr(AllTrim(ibDataSet37DESCRICAO.AsString))+' ');  //
            ibDataSet4.Open;
            //
            if Alltrim(ibDataSet37DESCRICAO.AsString) <> AllTrim(ibDataSet4.FieldByname('REFERENCIA').AsString) then
            begin
              //
              // Procura pela descricão
              //
              ibDataSet4.DisableControls;
              ibDataSet4.Close;
              ibDataSet4.SelectSQL.Clear;
              ibDataSet4.SelectSQL.Add('select * from ESTOQUE where Coalesce(Ativo,0)=0 order by upper(DESCRICAO)');
              ibDataSet4.Open;
              ibDataSet4.First;
              ibDataSet4.EnableControls;
              //
              ibDataSet4.Locate('DESCRICAO',AllTrim(ibDataSet37.FieldByname('DESCRICAO').AsString),[loCaseInsensitive, loPartialKey]);
              //
              if Pos(AnsiUpperCase(alltrim(ibDataSet37DESCRICAO.AsString)),AnsiUpperCase(ibDataSet4.FieldByname('DESCRICAO').AsString)) = 0 then
              begin
                ibDataSet4.DisableControls;
                ibDataSet4.First;
                while not ibDataSet4.Eof and (Pos(AnsiUpperCase(alltrim(ibDataSet37DESCRICAO.AsString)),AnsiUpperCase(ibDataSet4.FieldByname('DESCRICAO').AsString)) = 0) do ibDataSet4.Next;
                ibDataSet4.EnableControls;
              end;
            end;
          end;
        end;
      end;
      //
      if (AllTrim(ibDataSet37DESCRICAO.AsString) <> '') then
      begin
        if not ibDataSet4.Eof then
        begin
          ibDataSet37.Edit;
          ibDataSet37.FieldByName('DESCRICAO').AsString := ibDataSet4.FieldByname('DESCRICAO').AsString;
          ibDataSet37.FieldByName('CODIGO').AsString    := ibDataSet4.FieldByname('CODIGO').AsString;
          ibDataSet37.FieldByname('PEDIDO').AsString    := Copy(Edit1.Text,1,10);
          ibDataSet37.FieldByName('DATA').AsDateTime    := Date;
          ibDataSet37.FieldByName('CLIFOR').AsString    := ibDataSet2.FieldByname('NOME').AsString;
          //
          if (ibDataSet37.FieldByName('UNITARIO').AsFloat = 0) or (sAnterior<>ibDataSet37.FieldByName('DESCRICAO').AsString) then
          begin
            ibDataSet37.FieldByName('QUANTIDADE').AsFloat := 1;
            ibDataSet37.FieldByName('UNITARIO').AsFloat   := ibDataSet4.FieldByname('PRECO').AsFloat;
          end;
          //
        end;
      end;
      //
      MostraFoto(True);
      //
    end;
  end;
  //
  //  if not (ibDataset37.State in ([dsEdit, dsInsert])) then ibDataset37.Edit;
  //
  if (Key = VK_RETURN) or (Key = VK_TAB) then
  begin
    //
//    if ibDataSet37.FieldByName('DESCRICAO').AsString <> '' then
    begin
      I := DbGrid1.SelectedIndex;
      DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
      if I = DbGrid1.SelectedIndex  then
      begin
        //
        DbGrid1.SelectedIndex := 0;
        ibDataSet37.Next;
        if ibDataSet37.EOF then
        begin
          ibDataSet37.Append;
          ibDataSet37.FieldByName('DATA').AsDateTime := Date;
        end;
      end;
    end;
  end;
  //
  if (Key = VK_DOWN) and (DbGrid2.Visible)  then
  begin
    dBgrid2.SetFocus;
    Abort;
  end;
  //
  try
    if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('orca_novo.htm')));
    //
    //
    if DbGrid1.SelectedIndex = 0 then
      if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) then DbGrid2.Visible  := True;
    //
    if Key = VK_ESCAPE then Key := VK_RETURN;
    //
  except end;
  //
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //
  // Abre o antigo
  //
  if ParamCount > 0 then
  begin
    Form1.sAntigo := ParamStr(1);
  end;
  //
//  if (Mais1Ini.ReadString('Frente de caixa'  , 'Modelo do ECF'           ,'01') <> '01')
//  and (Mais1Ini.ReadString('Frente de caixa'  , 'Modelo do ECF'           ,'01') <> '59')
//  and (Mais1Ini.ReadString('Frente de caixa'  , 'Modelo do ECF'           ,'01') <> '65') then
  begin
    //
//    if (Form1.ibDataSet13ESTADO.AsString = 'SC') or (Form1.ibDataSet13ESTADO.AsString = 'ES') then
//    begin
//      ShowMessage('O orçamento só pode impresso em equipamento diverso do ECF desde que instalado fora do recinto de atendimento ao público; e ser convertido em arquivo do tipo PDF (portable document format).');
//      sPorta := 'PDF';
//    end;
    //
  end;
  //
end;

procedure TForm1.ibDataSet37UNITARIOSetText(Sender: TField;
  const Text: String);
begin
  //
  ibDataSet4.Close;                                                //
  ibDataSet4.Selectsql.Clear;
  ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
  ibDataSet4.Open;
  //
  if  StrToFloat(Text) < (Form1.ibDataSet4PRECO.AsFloat - (Form1.ibDataSet4PRECO.AsFloat * fConfDesconto / 100)) then
  begin
    ShowMessage('Desconto não permitido!'+chr(10)+chr(10)+
    'Verifique as permissões com o Administrador em:'+chr(10)+
    'Configurações do Sistema; Permitir.'+chr(10)+chr(10)+
    'Esta configurado para permitir no máximo '+FloatToStr(fConfDesconto)+'% de desconto no item.');
    Sender.AsString := Form1.ibDataSet4PRECO.AsString;
  end else
  begin
    Sender.AsString := Text;
  end;
  //
end;

procedure TForm1.ibDataSet13RESESetText(Sender: TField;
  const Text: String);
var
  fTotal1 : Real;
begin
  //
  fTotal1 := 0;
  //
  ibDataSet37.DisableControls;
  ibDataSet37.First;
  while not ibDataSet37.Eof do
  begin
    //
    fTotal1 := fTotal1 + ibDataSet37TOTAL.AsFloat;
    ibDataSet37.Next;
    //
  end;
  //
  ibDataSet37.EnableControls;
  //
  if  StrToFloat(Text) > (fTotal1 * fConfDescontoTotal / 100) then
  begin
    ShowMessage('Desconto não permitido!'+chr(10)+chr(10)+
    'Verifique as permissões com o Administrador em:'+chr(10)+
    'Configurações do Sistema; Permitir.'+chr(10)+chr(10)+
    'Esta configurado para permitir no máximo '+FloatToStr(fConfDescontoTotal)+'% de desconto no total do orçamento.');
    //
    Sender.AsString := '0,00';
    //
  end else
  begin
    //
    Sender.AsString := Text;
    //
  end;
  //
end;

procedure TForm1.ibDataSet37TOTALSetText(Sender: TField;
  const Text: String);
begin
  //
  ibDataSet4.Close;                                                //
  ibDataSet4.Selectsql.Clear;
  ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(AllTrim(ibDataSet37CODIGO.AsString))+' ');  //
  ibDataSet4.Open;
  //
  if (StrToFloat(Text) / Form1.ibDataSet37QUANTIDADE.AsFloat) < (Form1.ibDataSet4PRECO.AsFloat - (Form1.ibDataSet4PRECO.AsFloat * fConfDesconto / 100)) then
  begin
    ShowMessage('Desconto não permitido!'+chr(10)+chr(10)+
    'Verifique as permissões com o Administrador em:'+chr(10)+
    'Configurações do Sistema; Permitir.'+chr(10)+chr(10)+
    'Esta configurado para permitir no máximo '+FloatToStr(fConfDesconto)+'% de desconto no item.');
    Sender.AsFloat := Form1.ibDataSet4PRECO.AsFloat * Form1.ibDataSet37QUANTIDADE.AsFloat;
  end else
  begin
    Sender.AsString := Text;
  end;
  //
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  form1.Width  := 800;
  form1.Height := 800;
end;

procedure TForm1.ibDataSet37BeforeDelete(DataSet: TDataSet);
begin
  HasHs('ORCAMENT',True);
end;

end.









