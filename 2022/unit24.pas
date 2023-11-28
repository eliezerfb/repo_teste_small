unit Unit24;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls, Mask,
  DBCtrls, SMALL_DBEdit, SmallFunc, Menus, IniFiles, Variants, HtmlHelp, ShellApi, jpeg,
  IBCustomDataSet, Buttons
  , StrUtils
  ;

type

  TForm24 = class(TForm)
    ScrollBox1: TScrollBox;
    pnlNota: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    SMALL_DBEdit40: TSMALL_DBEdit;
    SMALL_DBEdit3: TSMALL_DBEdit;
    Label12: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    SMALL_DBEdit39: TSMALL_DBEdit;
    SMALL_DBEdit4: TSMALL_DBEdit;
    SMALL_DBEdit5: TSMALL_DBEdit;
    Label13: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    DBGrid2: TDBGrid;
    Label15: TLabel;
    SMALL_DBEdit6: TSMALL_DBEdit;
    SMALL_DBEdit7: TSMALL_DBEdit;
    SMALL_DBEdit8: TSMALL_DBEdit;
    SMALL_DBEdit9: TSMALL_DBEdit;
    Label14: TLabel;
    Label21: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label18: TLabel;
    SMALL_DBEdit10: TSMALL_DBEdit;
    SMALL_DBEdit11: TSMALL_DBEdit;
    SMALL_DBEdit12: TSMALL_DBEdit;
    SMALL_DBEdit13: TSMALL_DBEdit;
    SMALL_DBEdit14: TSMALL_DBEdit;
    DBGrid1: TDBGrid;
    Label23: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label29: TLabel;
    SMALL_DBEdit17: TSMALL_DBEdit;
    SMALL_DBEdit24: TSMALL_DBEdit;
    SMALL_DBEdit19: TSMALL_DBEdit;
    SMALL_DBEdit21: TSMALL_DBEdit;
    SMALL_DBEdit20: TSMALL_DBEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    edtTotalNota: TSMALL_DBEdit;
    SMALL_DBEdit25: TSMALL_DBEdit;
    SMALL_DBEdit18: TSMALL_DBEdit;
    SMALL_DBEdit23: TSMALL_DBEdit;
    SMALL_DBEdit22: TSMALL_DBEdit;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    SMALL_DBEdit30: TSMALL_DBEdit;
    SMALL_DBEdit29: TSMALL_DBEdit;
    SMALL_DBEdit28: TSMALL_DBEdit;
    SMALL_DBEdit27: TSMALL_DBEdit;
    SMALL_DBEdit41: TSMALL_DBEdit;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    SMALL_DBEdit31: TSMALL_DBEdit;
    SMALL_DBEdit32: TSMALL_DBEdit;
    SMALL_DBEdit33: TSMALL_DBEdit;
    SMALL_DBEdit26: TSMALL_DBEdit;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    SMALL_DBEdit38: TSMALL_DBEdit;
    SMALL_DBEdit37: TSMALL_DBEdit;
    SMALL_DBEdit36: TSMALL_DBEdit;
    SMALL_DBEdit35: TSMALL_DBEdit;
    SMALL_DBEdit34: TSMALL_DBEdit;
    SMALL_DBEdit15: TSMALL_DBEdit;
    Label1: TLabel;
    Label65: TLabel;
    Edit5: TEdit;
    Label66: TLabel;
    Edit6: TEdit;
    Label67: TLabel;
    Label68: TLabel;
    Imagefixa: TImage;
    Label6: TLabel;
    SMALL_DBEdit2: TSMALL_DBEdit;
    Label28: TLabel;
    SMALL_DBEdit43: TSMALL_DBEdit;
    PopupMenu3: TPopupMenu;
    Incluirnovoitemnoestoque1: TMenuItem;
    Incluirnovocliente1: TMenuItem;
    Label64: TLabel;
    Panel9: TPanel;
    Edit2: TEdit;
    Panel5: TPanel;
    Label10: TLabel;
    SMALL_DBEdit44: TSMALL_DBEdit;
    SMALL_DBEdit45: TSMALL_DBEdit;
    Label5: TLabel;
    DBMemo1: TDBMemo;
    lblAlteraEntrada: TLabel;
    DBGrid33: TDBGrid;
    edtAlteraEntrada: TEdit;
    ibDataSet44: TIBDataSet;
    DBGrid3: TDBGrid;
    Button2: TBitBtn;
    ibDataSet44CODIGO: TIBStringField;
    ibDataSet44REFERENCIA: TIBStringField;
    ibDataSet44DESCRICAO: TIBStringField;
    ibDataSet44ALTERADO: TSmallintField;
    imagenovo: TImage;
    Label22: TLabel;
    SMALL_DBEdit46: TSMALL_DBEdit;
    ok: TBitBtn;
    edFretePorConta: TEdit;
    DataSource44: TDataSource;
    Label26: TLabel;
    Edit7: TEdit;
    Label27: TLabel;
    Edit8: TEdit;
    Label56: TLabel;
    Edit9: TEdit;
    Label85: TLabel;
    ComboBox12: TComboBox;
    Label86: TLabel;
    SMALL_DBEdit64: TSMALL_DBEdit;
    Label87: TLabel;
    ComboBox13: TComboBox;
    Label89: TLabel;
    Image5: TImage;
    SMALL_DBEdit51: TSMALL_DBEdit;
    SMALL_DBEdit52: TSMALL_DBEdit;
    lblPFCP: TLabel;
    SMALL_DBEdit53: TSMALL_DBEdit;
    lblFCP: TLabel;
    SMALL_DBEdit54: TSMALL_DBEdit;
    lblBCFCPST: TLabel;
    SMALL_DBEdit55: TSMALL_DBEdit;
    lblPFCPST: TLabel;
    SMALL_DBEdit56: TSMALL_DBEdit;
    lblFCPST: TLabel;
    lblBcFCP: TLabel;
    Label7: TLabel;
    SMALL_DBEdit16: TSMALL_DBEdit;
    cbDescontaICMSDesonerado: TCheckBox;
    btnPrecificar: TBitBtn;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SMALL_DBEdit40Change(Sender: TObject);
    procedure SMALL_DBEdit40Enter(Sender: TObject);
    procedure SMALL_DBEdit40Exit(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit39Change(Sender: TObject);
    procedure SMALL_DBEdit39Enter(Sender: TObject);
    procedure SMALL_DBEdit39Exit(Sender: TObject);
    procedure SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit41Change(Sender: TObject);
    procedure SMALL_DBEdit41Enter(Sender: TObject);
    procedure SMALL_DBEdit41Exit(Sender: TObject);
    procedure DBGrid33KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit22Enter(Sender: TObject);
    procedure SMALL_DBEdit23Enter(Sender: TObject);
    procedure SMALL_DBEdit11Exit(Sender: TObject);
    procedure SMALL_DBEdit20Enter(Sender: TObject);
    procedure SMALL_DBEdit4Enter(Sender: TObject);
    procedure Memo2Enter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure SMALL_DBEdit22KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit22Exit(Sender: TObject);
    procedure SMALL_DBEdit31Exit(Sender: TObject);
    procedure SMALL_DBEdit41KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OKClick(Sender: TObject);
    procedure SMALL_DBEdit15Exit(Sender: TObject);
    procedure SMALL_DBEdit51KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit9Exit(Sender: TObject);
    procedure OkEnter(Sender: TObject);
    procedure SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit5Click(Sender: TObject);
    procedure SMALL_DBEdit5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Incluirnovoitemnoestoque1Click(Sender: TObject);
    procedure Incluirnovocliente1Click(Sender: TObject);
    procedure Label64Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure edtAlteraEntradaChange(Sender: TObject);
    procedure edtAlteraEntradaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid33DblClick(Sender: TObject);
    procedure SMALL_DBEdit42KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit27Exit(Sender: TObject);
    procedure edFretePorContaEnter(Sender: TObject);
    procedure Label_fecha_0Click(Sender: TObject);
    procedure Edit7Click(Sender: TObject);
    procedure Edit8Click(Sender: TObject);
    procedure Edit9Click(Sender: TObject);
    procedure SMALL_DBEdit45Change(Sender: TObject);
    procedure ComboBox12Change(Sender: TObject);
    procedure ComboBox13Change(Sender: TObject);
    procedure ComboBox12Exit(Sender: TObject);
    procedure SMALL_DBEdit64Exit(Sender: TObject);
    procedure ComboBox13Exit(Sender: TObject);
    procedure ComboBox12KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure SMALL_DBEdit41Click(Sender: TObject);
    procedure SMALL_DBEdit16Exit(Sender: TObject);
    procedure SMALL_DBEdit41KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
 	procedure Edit7Change(Sender: TObject);
    procedure Edit9Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure SMALL_DBEdit18Exit(Sender: TObject);
    procedure SMALL_DBEdit2Exit(Sender: TObject);
    procedure SMALL_DBEdit23Exit(Sender: TObject);
    procedure edFretePorContaExit(Sender: TObject);
    procedure cbDescontaICMSDesoneradoClick(Sender: TObject);
    procedure btnPrecificarClick(Sender: TObject);
  private
    function RetornarWhereAtivoEstoque: String;
    function RetornarWhereProdDiferenteItemPrincipal: String;
    procedure DefineDataSetFinalidade;
    procedure DefineDataSetConsumidor;
    procedure DefineDataSetIndPresenca;
    procedure DefineDataSetInfNFe;
    procedure AtualizaTotalDaNota;
    function TestaNotaDescontaICMSDesonerado: Boolean;
    { Private declarations }
  public
    ConfDupl1, ConfDupl2, ConfDupl3, ConfCusto, ConfNegat, confDuplo: String;
    ConfItens   : Integer;
    ConfLimite  : Real;
    ConfIR      : Real;
    sSistema, sFornecedor, sNovoNumero : String;
    bProximo    : Boolean;
    sTeste      : String;
    sDataAntiga : String;
    { Public declarations }
  end;

  function ImprimeOuNaoANota2(pP1:Boolean):Boolean;

var
  Form24: TForm24;

implementation

uses Mais, Unit7, Unit10, Unit18, Unit43, Unit12, Unit22, Unit45,
  uFuncoesBancoDados, uDialogs, uFrmPrecificacaoProduto, Windows;

{$R *.DFM}


function Exemplo(sP1 : boolean):Boolean;
begin
  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDAE.AsString)+' ');
  Form1.ibQuery1.Open;

  Form24.Label89.Caption := 'Compra 1 '+Form1.IBQuery1.FieldByname('DESCRICAO').AsString+' e'+chr(10)+'vende ';

  Form1.ibQuery1.Close;
  Form1.ibQuery1.SQL.Clear;
  Form1.ibQuery1.SQL.Add('select SIGLA, DESCRICAO from MEDIDA where SIGLA='+QuotedStr(Form7.ibDataSet4MEDIDA.AsString)+' ');
  Form1.ibQuery1.Open;

  Form24.Label89.Caption := AllTrim(Form24.Label89.Caption) +' '+ FloatToStr(Form7.ibDataSet4FATORC.AsFloat) + ' ' + Form1.IBQuery1.FieldByname('DESCRICAO').AsString;
  
  Result := True;
end;


function Grid_Compra(P1:Boolean): Boolean;
begin
  //
  // Altera o Grid de mercadorias para mostrar na NF
  //
  Form7.ibDataSet23UNITARIO.Visible     := True;
  Form7.ibDataSet23IPI.Visible          := True;
  Form7.ibDataSet23ICM.Visible          := True;
  Form7.ibDataSet23CST_ICMS.Visible     := True;
  Form7.ibDataSet23CST_IPI.Visible      := True;
  Form7.ibDataSet23CFOP.Visible         := True;
  Form7.ibDataSet23BASE.Visible         := True;
  //
  Form7.ibDataSet23VICMS.Visible        := True;
  Form7.ibDataSet23VBC.Visible          := True;
  Form7.ibDataSet23VBCST.Visible        := True;
  Form7.ibDataSet23VICMSST.Visible      := True;
  Form7.ibDataSet23VIPI.Visible         := True;
  Form7.ibDataSet23QUANTIDADE.Visible   := False;
  Form7.ibDataSet23UNITARIO.Visible     := False;
  Form7.ibDataSet23QTD_ORIGINAL.Visible := True;
  Form7.ibDataSet23UNITARIO_O.Visible   := True;
  Form7.ibDataSet23EAN_ORIGINAL.Visible := True;
  {Sandro Silva 2023-04-11 inicio
  Form7.ibDataSet23VBCFCP.Visible       := True;
  Form7.ibDataSet23PFCP.Visible         := True;
  Form7.ibDataSet23VFCP.Visible         := True;
  Form7.ibDataSet23VBCFCPST.Visible     := True;
  Form7.ibDataSet23PFCPST.Visible       := True;
  Form7.ibDataSet23VFCPST.Visible       := True;
  {Sandro Silva 2023-04-11 fim}
  //
  Form7.ibDataSet23DESCRICAO.DisplayWidth     := 27+8;
  Form7.ibDataSet23TOTAL.DisplayWidth         := 15;
  Form7.ibDataSet23QUANTIDADE.DisplayWidth    := 14;
  Form7.ibDataSet23QTD_ORIGINAL.DisplayWidth  := 14;
  Form7.ibDataSet23UNITARIO_O.DisplayWidth    := 12;
  //
  Result := True;
end;


function MostraFoto(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
begin
  //
  if Form7.ibDataset4FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO,bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form24.Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form24.Image5.Picture.Width > Form24.Image5.Picture.Height then
    begin
      Form24.Image5.Width  := (StrToInt(StrZero((Form24.Image5.Picture.Width * (Form24.Panel9.Width / 2 / Form24.Image5.Picture.Width)),10,0))) *2;
      Form24.Image5.Height := (StrToInt(StrZero((Form24.Image5.Picture.Height* (Form24.Panel9.Width / 2 / Form24.Image5.Picture.Width)),10,0))) *2;
    end else
    begin
      Form24.Image5.Width  := (StrToInt(StrZero((Form24.Image5.Picture.Width * (Form24.Panel9.Height / 2 / Form24.Image5.Picture.Height)),10,0))) *2;
      Form24.Image5.Height := (StrToInt(StrZero((Form24.Image5.Picture.Height* (Form24.Panel9.Height / 2 / Form24.Image5.Picture.Height)),10,0))) *2;
    end;
    Form24.Image5.Left := (Form24.Panel9.Width  - Form24.Image5.Width) div 2;
    Form24.Image5.Top  := (Form24.Panel9.Height - Form24.Image5.Height) div 2;
    Form24.Image5.Repaint;
    Form24.Panel9.Visible := True;
    Form24.Image5.Visible := True;
  end else
  begin
    Form24.Image5.Picture := nil;
    Form24.Image5.Visible := False;
    Form24.Panel9.Visible := False;
  end;
  //
  Form24.Panel9.Visible := True;
  Form24.Panel5.Visible := True;
  //
  Result := True;
end;

function MostraFoto2(P1:Boolean): Boolean;
var
  BlobStream : TStream;
  jP2  : TJPEGImage;
begin
  //
  if Form7.ibDataset2FOTO.BlobSize <> 0 then
  begin
    BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2.FieldByname('FOTO'),bmRead);
    jp2 := TJPEGImage.Create;
    try
      jp2.LoadFromStream(BlobStream);
      Form24.Image5.Picture.Assign(jp2);
    finally
      BlobStream.Free;
      jp2.Free;
    end;
    if Form24.Image5.Picture.Width > Form24.Image5.Picture.Height then
    begin
      Form24.Image5.Width  := (StrToInt(StrZero((Form24.Image5.Picture.Width * (Form24.Panel9.Width / 2 / Form24.Image5.Picture.Width)),10,0)));//*2;
      Form24.Image5.Height := (StrToInt(StrZero((Form24.Image5.Picture.Height* (Form24.Panel9.Width / 2 / Form24.Image5.Picture.Width)),10,0)));//*2;
    end else
    begin
      Form24.Image5.Width  := (StrToInt(StrZero((Form24.Image5.Picture.Width * (Form24.Panel9.Height / 2 / Form24.Image5.Picture.Height)),10,0)));//*2;
      Form24.Image5.Height := (StrToInt(StrZero((Form24.Image5.Picture.Height* (Form24.Panel9.Height / 2 / Form24.Image5.Picture.Height)),10,0)));//*2;
    end;
    Form24.Image5.Left := (Form24.Panel9.Width  - Form24.Image5.Width) div 2;
    Form24.Image5.Top  := (Form24.Panel9.Height - Form24.Image5.Height) div 2;
    Form24.Image5.Repaint;
    Form24.Panel9.Visible := True;
    Form24.Image5.Visible := True;
  end else
  begin
    Form24.Image5.Picture := nil;
    Form24.Image5.Visible := False;
    Form24.Panel9.Visible := False;
  end;
  Result := True;
end;

function ApagaAsDuplicatasAnteriores2(pP1:Boolean):Boolean;
begin
  Form7.ibDataSet8.First;
  while not Form7.ibDataSet8.Eof do if Form7.ibDataSet8NUMERONF.AsString = Form7.ibDataSet24NUMERONF.AsString then Form7.ibDataSet8.Delete else Form7.ibDataSet8.Next;
  Result := True;
end;


function ApagaIntegracaoComOCaixa2(pP1:Boolean):Boolean;
begin
  // Apaga lançamento anterior no livro caixa
  try
    Form7.ibDataSet100.Close;
    Form7.ibDataSet100.SelectSQL.Clear;
    Form7.ibDataSet100.SelectSQL.Add('delete from CAIXA where substring(HISTORICO from 1 for 22)='+QuotedStr('Nota Fiscal: '+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9))+' and DATA = '+QuotedStr(Form24.sDataAntiga)+' ');
    Form7.IBDataSet100.Open;
  except
  end;

  Result := True;
end;

function IntegracaoComOCaixa2(pP1:Boolean):Boolean;
{var
  bButton : Integer;}
begin
  //
{
  if StrToDate(DateToStr(Form7.ibDataSet24EMISSAO.AsDateTime)) <> Date then
  begin
    bButton := Application.MessageBox(pChar(chr(10) +'Este procedimento vai alterar o saldo do CAIXA do dia '+ Form7.ibDataSet24EMISSAO.AsString +Chr(10)+ ' e dos dias subsequentes até a data de hoje.'+
               chr(10)+
               'Continuar?'),
               'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);
  end else
  begin
    bButton := IDYES;
  end;
  //
  if bButton = IDYES  then
}
  begin
    if Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString),1,5) = 'CAIXA' then
    begin
      // Integração com o Livro caixa CAIXA.DBF                     //
      Form7.ibDataSet12.First;
      Form7.ibDataSet1.Append;
      Form7.ibDataSet1DATA.Value      := Form7.ibDataSet24EMISSAO.Value;
      Form7.ibDataSet1HISTORICO.Value := 'Nota Fiscal: '+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+' de '+Form7.ibDataSet24FORNECEDOR.asString;
      Form7.ibDataSet1SAIDA.Value     := Form7.ibDataSet24TOTAL.Value;
      Form7.ibDataSet1.Post;
      //
      if (Form7.ibDataSet14CONTA.AsString = '') then
      begin
        if (Form7.ibDataSet24TOTAL.AsFloat>0) then
        begin
          Form43.IdentificadorPlanoContas := Form7.ibDataSet24IDENTIFICADORPLANOCONTAS.AsString; // Sandro Silva 2022-12-29
          Form43.ShowModal; // Ok
          if Form1.DisponivelSomenteParaNos then
          begin

            if Trim(Form43.EdPesquisaConta.Text) <> '' then
            begin
              if Form7.ibDataSet12.Locate('DESCRICAOCONTABIL', Form43.EdPesquisaConta.Text, []) then
              begin
                // Salva o identificador do plano de contas na compra 
                Form7.ibDataSet24.Edit;
                Form7.ibDataSet24.FieldByName('IDENTIFICADORPLANOCONTAS').AsString := Form7.ibDataSet12.FieldByName('IDENTIFICADOR').AsString;
                Form7.ibDataSet24.Post;
              end;
            end;
          end;
        end;
      end else
      begin
        Form7.ibDataSet1.Edit;
        Form7.ibDataSet1NOME.AsString := Form7.ibDataSet14CONTA.AsString;
        Form7.ibDataSet1.Post;
      end;
      
      try
        Form7.ibDataSet1.Edit;
        Form7.ibDataSet1.Post;
      except end;
    end;
  end;
  //
  Result := True;
end;


function ImprimeOuNaoANota2(pP1:Boolean):Boolean;
var
  vLinha: array [1..200]  of String;   // Cria uma matriz com 100 elementos
                                      // isso eu aprendi num sonho
  vCampo: array [0..3000] of Variant; // Cria uma matriz com 1000 elementos

  ConfItens: Integer;
  F: TextFile;
  Mais2Ini, Mais1Ini: TIniFile;
  iPagina, I, J : Integer;            // e conteúdo variável
  sSerie : String;
  bMaisItens : Boolean;
begin
  //
  for I := 1 to 2000 do vCampo[I] := '';
  //
  if (AllTrim(Form7.ibDataSet24FORNECEDOR.AsString) <> '') and (Form7.ibDataSet24TOTAL.AsFloat <> 0) then
  begin
    i := Application.MessageBox(pChar(chr(10) +'Antes de imprimir verifique se a impressora está ligada e'+Chr(10)+
         'com o formulário posicionado.'+Chr(10)+
         chr(10)+
         'Imprimir a nota fiscal '+ Form7.ibDataSet24NUMERONF.asString +' agora?'),
         'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);
  end else i := 0;
  //
  //
  if AllTrim(Form7.ibDataSet24FORNECEDOR.AsString) <> Alltrim(Form7.IBDataSet2NOME.AsString) then
  begin
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Clear;
    Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' ');  //
    Form7.ibDataSet2.Open;
  end;
  //
  if AllTrim(Form7.ibDataSet24TRANSPORTA.AsString) = '' then Form7.ibDataSet18.Append else Form7.ibDataSet18.Locate('NOME',Form7.ibDataSet15TRANSPORTA.AsString,[]);
  //
  if i = 6 then
  begin
    //
    Form7.ibDataSet15.Close;
    Form7.ibDataSet15.SelectSQL.Clear;
    Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where NUMERONF like '+QuotedStr('%001')+ ' order by NUMERONF');
    Form7.ibDataSet15.Open;
    Form7.ibDataSet15.Last;
    //
    sSerie := Copy(Form7.ibDataSet15NUMERONF.AsString,10,3);
    if Alltrim(sSerie) = '' then sSerie := '1';
    //
    if Form7.ibDataSet24NUMERONF.AsString = Right(StrZero(StrToInt('0'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9))+1,9,0),9) then
    begin
      //
      if Application.MessageBox(pChar(chr(10) +'Você está imprimindo uma nota de entrada, com o número seqüencial do' + Chr(10)
                              +'seu formulário contínuo.'+chr(10)
                              +chr(10)
                              +'Você quer imprimir uma nota de entrada na seqüência do seu formulário contínuo?          '+ Chr(10)
                              +chr(10)),
                              'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONQUESTION) = 6 then
      begin
        //
        Form7.sTitulo := 'Notas fiscais de saída (vendas) série '+sSerie;
        Form7.sRPS := 'N';
        Form7.ibDataSet15.Append;
        Form7.ibDataSet15.Edit; Form7.ibDataSet15NUMERONF.AsString := Copy(Form7.ibDataSet24NUMERONF.AsString,1,9) + sSerie;
        Form7.ibDataSet15.Edit; Form7.ibDataSet15CLIENTE.AsString  := Form7.ibDataSet24FORNECEDOR.AsString;
        Form7.ibDataSet15.Edit; Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet24OPERACAO.AsString;
        //
        Form7.ibDataSet15.Edit; Form7.ibDataSet15COMPLEMENTO.AsString := 'ENTRADA';
        Form7.ibDataSet15.Edit; Form7.ibDataSet15EMITIDA.AsString    := 'E';
        //
        Form7.ibDataSet15.Post;
        //
      end;
    end;
    //
    // Teste
    //
    Form7.sModulo := 'COMPRA';
    //
    iPagina     := 72;
    Mais1ini    := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    ConfItens   := StrToInt(Mais1Ini.ReadString('Nota Fiscal','Itens','16'));
    Mais1Ini.Free;
    //
    // Início da impressão da nota
    //
    bMaisItens := True;
    Form7.ibDataSet23.First;
    //
    while bMaisItens do
    begin
      {                                           }
      { Arquivo de NF indexado por LINHA + COLUNA }
      {                                           }
      Form7.sModulo := 'COMPRA';
      //
      Form7.ibDataSet19.Active     := False;
      Form7.ibDataSet19.SelectSQL.Clear;
      Form7.ibDataSet19.SelectSQL.Add('select * from NOTA where SERIE=1 order by ((LINHA * 1000) + COLUNA)');
      Form7.ibDataSet19.Open;
      //
      // Relaciona as tabelas com o arquivo de vendas
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet24OPERACAO.AsString,[]); //
      //
      {                                           }
      { Inicializa todos os elementos dos vetores }
      {                                           }
      for I := 1 to 3000 do vCampo[I] := '';
      for I := 1 to 200  do  vLinha[I] := '';
      //
      // Zera os servicos
      //
      for I := 1 to 50 do
      begin
        vCampo[2150 + I] := '';
        vCampo[2300 + I] := '';
        vCampo[2350 + I] := '';
        vCampo[2400 + I] := '';
        vCampo[2600 + I] := '';
      end;
      //
      // Valores númericos
      //
      vCampo[020] := '************';   //  20 Base de Cálculo do ISS
      vCampo[021] := '************';
      vCampo[022] := '************'; //  22 Valor total do ISS
      vCampo[023] := '************'; //  23 Base de Cálculo do ICMS
      vCampo[025] := '************'; //  25 Valor do ICM
      vCampo[026] := '************'; //  26 Base de subst
      vCampo[027] := '************'; //  27 ICMS de Subst
      vCampo[028] := '************'; //  28 Total dos Produtos
      vCampo[029] := '************'; //  29 Valor do frete
      vCampo[030] := '************'; //  30 Seguro
      vCampo[031] := '************'; //  31 Outras despesas
      vCampo[032] := '************'; //  32 Valor total do IPI
      vCampo[033] := '************'; //  33 Valor total da nota
      vCampo[063] := Replicate('x',160);   //  Valor por Extenso
      vCampo[046] := '************'; //  29 Valor do desconto
      vCampo[069] := '************';
      vCampo[085] := '************'; //  Valor total dos produtos
      vCampo[020] := '************'; //  Imposto de renda
      //
      {                                                      }
      { Atribui o valor a cada elemento conf fonte no dBFAST }
      {                                                      }
      vCampo[001] := Form7.ibDataSet13CGC.Value;        //   1 C.G.C. do Emitente
      vCampo[002] := Form7.ibDataSet24OPERACAO.Value;   //   2 Natureza da operacão
      vCampo[003] := Form7.ibDataSet14CFOP.Value;       //   3 C.F.O.
      vCampo[005] := Form7.ibDataSet13IE.Value;         //   5 I.E. do emitente
      vCampo[007] := Form7.ibDataSet2NOME.Value;        //   7 Razão Social do Destinatário
      vCampo[008] := Form7.ibDataSet2CGC.Value;         //   8 C.G.C. do Destinatário
      vCampo[009] := DateTimeToStr(Form7.ibDataSet24EMISSAO.asDateTime); //   9 Data de emissão
      vCampo[010] := Form7.ibDataSet2ENDERE.Value;      //  10 Endereço do Destinatário
      vCampo[011] := Form7.ibDataSet2COMPLE.Value;      //  11 Bairro do cliente
      vCampo[012] := Form7.ibDataSet2CEP.Value;         //  12 CEP do Destinatário
      vCampo[013] := DateTimeToStr(Form7.ibDataSet24SAIDAD.asDateTime);     //  13 Data de Saída
      vCampo[014] := Form7.ibDataSet2CIDADE.Value;      //  14 Município do Destinatário
      vCampo[015] := Form7.ibDataSet2FONE.Value;        //  15 Telefone do cliente
      vCampo[016] := Form7.ibDataSet2ESTADO.Value;      //  16 U.F. do Destinatário
      vCampo[017] := Form7.ibDataSet2IE.Value;          //  17 I.E. do Destinatário
      vCampo[018] := Form7.ibDataSet24SAIDAH.Value;     //  18 Hora de saída
      vCampo[057] := Form7.ibDataSet13ENDERECO.Value;   //  57 Endereco do Emitente
      vCampo[059] := Form7.ibDataSet13MUNICIPIO.Value;  //  59 Cidade do Emitente
      vCampo[060] := Form7.ibDataSet13CEP.Value;        //  60 C.E.P. Emitente
      vCampo[061] := Form7.ibDataSet13ESTADO.Value;     //  61 Estado do Emitente
      vCampo[062] := Form7.ibDataSet24NUMERONF.AsString;   //  62 Número da Nota Fiscal
      vCampo[067] := Form7.ibDataSet13NOME.Value;       //  67 Nome do emitente
      VCampo[076] := ' '; // 76 X da nota de saida
      vCampo[077] := 'X'; // 77 X da nota de entrada
      //
      vCampo[085] := Form7.ibDataSet24MERCADORIA.Value; //  Valor total dos produtos
      vCampo[098] := Form7.ibDataSet24VENDEDOR.Value;   //  98 Nome do vendedor
      {                                                      }
      { Passa os dados do arquivo SAIDA.DBF para os vetores  }
      {                                                      }
      I := 0;
      //
      while (not Form7.ibDataSet23.Eof) and (I<ConfItens) do // Disable
      begin
        //
        Form7.ibDataSet4.Close;                                                //
        Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
        Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');  //
        Form7.ibDataSet4.Open;
        //
        if (Form7.ibDataSet23DESCRICAO.AsString <> '') and (Form7.ibDataSet23QUANTIDADE.AsFloat > 0) then
        begin

          vCampo[150 + I] := Form7.ibDataSet23DESCRICAO.Value;  // 150 Descrição do item
          vCampo[200 + I] := Form7.ibDataSet4CST.Value;         // 200 ST do item
          vCampo[250 + I] := Form7.ibDataSet23MEDIDA.Value;     // 250 Unidades de medida do item
          vCampo[300 + I] := Form7.ibDataSet23QUANTIDADE.Value; // 300 Quantidades do item
          vCampo[350 + I] := Form7.ibDataSet23UNITARIO.Value;   // 350 Valor unitário do item
          vCampo[400 + I] := Form7.ibDataSet23QUANTIDADE.Value
                             * Form7.ibDataSet23UNITARIO.Value; // 400 Valor total do item

          vCampo[500 + I] := Form7.ibDataSet23IPI.Value;         // 500 % IPI do item
          vCampo[450 + I] := Form7.ibDataSet23QUANTIDADE.Value *
                             Form7.ibDataSet23UNITARIO.Value   *
                             ( Form7.ibDataSet23IPI.Value / 100 ); // 450 Valor IPI do item

          vCampo[550 + I] := Form7.ibDataSet23ICM.Value;        // 550 % ICM do item
          vCampo[600 + I] := Form7.ibDataSet23CODIGO.Value;     // 600 Códigos do item
          vCampo[650 + I] := Form7.ibDataSet23VICMS.Value;      // 650 Valor do ICM do item
          { Procura o produto no estoque                                                   }
        //          Form7.ibDataSet4.IndexFieldNames := 'CODIGO';

          Form7.ibDataSet4.Close;                                                //
          Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
          Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');  //
          Form7.ibDataSet4.Open;
          //
          if Form7.ibDataSet4CODIGO.Value = Form7.ibDataSet23CODIGO.AsString then
          begin
            vCampo[700 + I] := Form7.ibDataSet4CF.Value;          // 700 CF do item
            vCampo[750 + I] := Form7.ibDataSet4REFERENCIA.Value;  // 750 Referência do item
          end;
          //
          vCampo[800 + I] := Form7.ibDataSet23CFOP.Value;     // 600 CFOP do Item item
          //
          { Incrementa o I salta para o próximo registro}
          I := I + 1;
        end;
        //
        Form7.ibDataSet23.next;
        //
      end;
      //
      if (Form7.ibDataSet23.eof) then // Disable
      begin
        //
        bMaisItens := False;
        //
        vCampo[020] := Form7.ibDataSet24SERVICOS.Value;   //  20 Base de Cálculo do ISS
        vCampo[021] := 0; { Voltar }
        vCampo[022] := Form7.ibDataSet24ISS.Value;          //  22 Valor total do ISS
        vCampo[023] := Form7.ibDataSet24BASEICM.Value;      //  23 Base de Cálculo do ICMS
        vCampo[025] := Form7.ibDataSet24ICMS.Value;         //  25 Valor do ICM
        vCampo[026] := Form7.ibDataSet24BASESUBSTI.Value;   //  26 Base de subst
        vCampo[027] := Form7.ibDataSet24ICMSSUBSTI.Value;   //  27 ICMS de Subst
        vCampo[028] := Form7.ibDataSet24MERCADORIA.Value;   //  28 Total dos Produtos
        vCampo[029] := Form7.ibDataSet24FRETE.Value;        //  29 Valor do frete
        vCampo[030] := Form7.ibDataSet24SEGURO.Value;       //  30 Seguro
        vCampo[031] := Form7.ibDataSet24DESPESAS.Value;     //  31 Outras despesas
        vCampo[032] := Form7.ibDataSet24IPI.Value;          //  32 Valor total do IPI
        vCampo[033] := Form7.ibDataSet24TOTAL.Value;        //  33 Valor total da nota
        vCampo[034] := Form7.ibDataSet24TRANSPORTA.Value;   //  34 Transportadora Nome
        // Imposto de renda:                                                              //
        // Se o valor for maior do que o Teto limite para tributação de IR sobre serviços //
        // tributa                                                                        //
        if vCampo[020] >= Form24.ConfLimite  then vCampo[068] := vCampo[020] * ((Form24.ConfIR / 100) * 1) else vCAmpo[068] := 0;
        //
        vCampo[035] := Form7.ibDataSet24FRETE12.Value;      //  35 Frete por conta (0 ou 1)
        vCampo[036] := Form7.ibDataSet18PLACA.Value;        //  36 Transportadora placa
        vCampo[037] := Form7.ibDataSet18ESTADO.Value;       //  37 Transportadora estado
        vCampo[038] := Form7.ibDataSet18CGC.Value;          //  38 CGC da tranportadora
        vCampo[039] := Form7.ibDataSet18ENDERECO.Value;     //  39 Transportadora endereço
        vCampo[040] := Form7.ibDataSet18MUNICIPIO.Value;    //  40 Transportadora município
        vCampo[042] := Form7.ibDataSet18IE.Value;           //  42 IE da transportadora
        vCampo[043] := Form7.ibDataSet24VOLUMES.Value;      //  43 Quantidade de  volumes
        vCampo[044] := Form7.ibDataSet24ESPECIE.Value;      //  44 Espécie de volumes
        vCampo[045] := Form7.ibDataSet24MARCA.Value;        //  45 Marca dos volumes
        vCampo[047] := Form7.ibDataSet24PESOBRUTO.Value;    //  47 Peso bruto
        vCampo[048] := Form7.ibDataSet24PESOLIQUI.Value;    //  48 Peso liquido
        //
        vCampo[049] := Copy(Form7.ibDataSet24COMPLEMENTO.AsString+REplicate(' ',3000),1,60);        //  49 Informacoes Complementares 1
        vCampo[050] := Copy(Form7.ibDataSet24COMPLEMENTO.AsString+REplicate(' ',3000),1+(60*1),60); //  49 Informacoes Complementares 1
        vCampo[051] := Copy(Form7.ibDataSet24COMPLEMENTO.AsString+REplicate(' ',3000),1+(60*2),60); //  49 Informacoes Complementares 1
        vCampo[052] := Copy(Form7.ibDataSet24COMPLEMENTO.AsString+REplicate(' ',3000),1+(60*3),60); //  49 Informacoes Complementares 1
        vCampo[053] := Copy(Form7.ibDataSet24COMPLEMENTO.AsString+REplicate(' ',3000),1+(60*4),60); //  49 Informacoes Complementares 1
        //
        vCampo[054] := Form7.ibDataSet24DESCRICAO1.AsString; //  54 Descrição dos serviços 1
        vCampo[055] := Form7.ibDataSet24DESCRICAO2.AsString; //  55 Descrição dos Serviços 2
        vCampo[056] := Form7.ibDataSet24DESCRICAO3.AsString; //  56 Descrição dos Serviços 3
        vCampo[063] := Alltrim(Extenso(vCampo[033]));   //  Valor por Extenso
        vCampo[069] := vCampo[033] - vCampo[068];
        //
        // Desdobramento das duplicatas na compra
        //
        I := 0;
        //
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
        begin
          if (copy(Form7.ibDataSet8DOCUMENTO.asString,1,9) = Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)) and (Form7.ibDataSet24FORNECEDOR.AsString = Form7.ibDataSet8NOME.AsString) then
          begin
            vCampo[1000 + I] := Form7.ibDataSet8DOCUMENTO.asString;    // Documento
            vCampo[1100 + I] := Form7.ibDataSet8VALOR_DUPL.asFloat;    // Valor da duplicata
            vCampo[1200 + I] := DateTimeToStr(Form7.ibDataSet8VENCIMENTO.asDateTime); // Vencimento
            //
            if Form7.ibDataSet8VENCIMENTO.asDateTime = Date then vCampo[1200 + I] := 'À VISTA ';
            if Form7.ibDataSet8VENCIMENTO.asDateTime < Date then vCampo[1200 + I] := 'ANTECIP ';
            if Form7.ibDataSet8VENCIMENTO.asDateTime = StrToDateTime('30/12/1899') then vCampo[1200 + I] := 'APRESENT';
            //
            if I < 25 then I := I + 1;
          end;
          Form7.ibDataSet8.Next;
        end;
      end;
      //
      // Impressão da NF
      //
      Form7.ibDataSet19.First;
      //
      if Copy(Form7.ibDataSet15NUMERONF.AsString,10,3) = '1' then
      begin
        Mais2ini := TIniFile.Create('retaguarda.ini');
        AssignFile(F,Mais2Ini.ReadString('Nota Fiscal','Porta','LPT1'));
        Mais2ini.Free;
      end else
      begin
        Mais2ini := TIniFile.Create('retaguarda.ini');
        AssignFile(F,Mais2Ini.ReadString('Nota Fiscal 2','Porta','LPT1'));
        Mais2ini.Free;
      end;

      try
        Rewrite(F);
      except
        //ShowMessage('Verifique a impressora.') Mauricio Parizotto 2023-10-25
        MensagemSistema('Verifique a impressora.',msgAtencao);
      end;

      // Arquivo de nota fiscal NOTA
      Form7.ibDataSet19.First;
      while not Form7.ibDataSet19.Eof do
      begin
        // Não imprime quando a linha e a coluna estiverem zeradas
        if Form7.ibDataSet19LINHA.AsFloat > 200 then
        begin
          Form7.ibDataSet19.Edit;
          Form7.ibDataSet19LINHA.AsFloat := 200;
        end;
        if Form7.ibDataSet19COLUNA.AsFloat > 300 then
        begin
          Form7.ibDataSet19.Edit;
          Form7.ibDataSet19COLUNA.AsFloat := 300;
        end;
        
        if (Form7.ibDataSet19LINHA.Value + Form7.ibDataSet19COLUNA.Value) > 0 then
        begin
          try
            if Trunc(Form7.ibDataSet19ELEMENTO.Value) > 0 then
            begin
              Form7.ibDataSet19.Edit;
              Form7.ibDataSet19LAYOUT.AsString := vCampo[ Trunc(Form7.ibDataSet19ELEMENTO.Value) ];
              Form7.ibDataSet19.Post;
            end;
          except
          end;
          
          if (Form7.ibDataSet19ELEMENTO.Value >= 150) and (Form7.ibDataSet19ELEMENTO.Value < 999) then
          begin
try
            //
            // Linha dos produtos
            //
            for I := 0 to ConfItens do
            begin
              //
              if (VarType(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I]) = varDouble) then
              begin
                try
                  //
                  if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@*' then  // Multiplica o número pelo valor do int
                  begin
                    vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                    Right( Replicate(' ',100)+FormatFloat('#,##0.00', vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )] * LimpaNumeroDeixandoAvirgula(Form7.ibDataSet19TIPO.AsString) ),10);
                  end else
                  begin
                    if AllTrim(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.AsString,'9',''),'.',''),',','')) <> '' then
                    begin
                      Form7.ibDataSet19.Edit;
                      Form7.ibDataSet19TIPO.AsString := '999.999,99';
                      Form7.ibDataSet19.Post;
                    end;
                    //
                    vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                    Right(
                    Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I])
                    ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                  end;
                  //
                except
                  //
                  try
                    Form7.ibDataSet19.Edit;
                    Form7.ibDataSet19TIPO.AsString := '999.999,99';
                    Form7.ibDataSet19.Post;
                    //
                                          vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                    Right(
                    Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I])
                    ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                  except
                    //ShowMessage('Erro 2'); Mauricio Parizotto 2023-10-25
                    MensagemSistema('Erro 2',msgErro);
                  end;
                end;
              end else
              begin
                try
                  vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                                                         alltrim(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I ]);
                except end;
              end;
            end;

except end;
          end else
          begin
            //
            // SERVICOS SERVIÇOS serviços
            //
            if (Form7.ibDataSet19ELEMENTO.Value >= 2150) and  (Form7.ibDataSet19ELEMENTO.Value < 2999) then
            begin

try
              // Linha dos Serviços
              //
              // Resolvi esse problema num sonho
              //
              for I := 0 to Form1.ConfItens do
              begin
                if (VarType(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I]) = varDouble) then
                begin
                  try
                    //
                    if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@*' then  // Multiplica o número pelo valor do int
                    begin
                      vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                      Right( Replicate(' ',100)+FormatFloat('#,##0.00',
                      vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )]
                      * LimpaNumeroDeixandoAvirgula(Form7.ibDataSet19TIPO.AsString)
                      ),10);
                    end else
                    begin
                      if AllTrim(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.AsString,'9',''),'.',''),',','')) <> '' then
                      begin
                        Form7.ibDataSet19.Edit;
                        Form7.ibDataSet19TIPO.AsString := '999.999,99';
                        Form7.ibDataSet19.Post;
                      end;
                      //
                      vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                      Right(
                      Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I])
                      ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                    end;
                    //
                  except
                    //
                    try
                      Form7.ibDataSet19.Edit;
                      Form7.ibDataSet19TIPO.AsString := '999.999,99';
                      Form7.ibDataSet19.Post;
                      //
                                            vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                      Right(
                      Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I])
                      ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                    except end;
                    //
                  end;
                end else
                begin
                  try
                     vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat)+I ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                                                           alltrim(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )+I ]);
                  except end;
                end;
              end;
except end;
            end else
            begin
              //
try
              if Form7.ibDataSet19ELEMENTO.Value > 0 then
              begin
                //
                // Todas as informações da NF menos itens de produtos ou serviços
                //
                if (VarType(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )]) = varDouble) then
                begin
                  try
                    //
                    if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@*' then  // Multiplica o número pelo valor do int
                    begin
                      vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                      Right( Replicate(' ',100)+FormatFloat('#,##0.00',
                      vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )]
                      * LimpaNumeroDeixandoAvirgula(Form7.ibDataSet19TIPO.AsString)
                      ),10);
                    end else
                    begin
                      if AllTrim(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.AsString,'9',''),'.',''),',','')) <> '' then
                      begin
                        Form7.ibDataSet19.Edit;
                        Form7.ibDataSet19TIPO.AsString := '999.999,99';
                        Form7.ibDataSet19.Post;
                      end;
                      //
                      vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                      Right( Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )])
                      ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                    end;
                    //
                  except
                    try
                      try
                        Form7.ibDataSet19.Edit;
                        Form7.ibDataSet19TIPO.AsString := '999.999,99';
                        Form7.ibDataSet19.Post;
                        //
                        vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                        Right( Replicate(' ',100)+FormatFloat(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(StrTran(Form7.ibDataSet19TIPO.Value,'9','#'),'.','*'),',','.'),'*',','),'#.####','0.0000'),'#.###','0.000'),'#.##','0.00'),'#.#','0.0'),vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value )])
                        ,length(Alltrim(Form7.ibDataSet19Tipo.Value)));
                      except end;
                    except end;
                  end;
                end
                else
                  try
                    //
                    // @S 0150
                    //
                    if Copy(Form7.ibDataSet19TIPO.AsString,1,2) =  '@S' then
                    begin
                      try
                        vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value ) ] := Copy(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value ) ]+Replicate(' ',100),StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,4,2)),StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,6,2)));
                      except end;
                    end;
                    //
                    vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                                                             alltrim(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value ) ]);
                  except end;
              end;
except end;
              //
              if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@&' then // Comando para a impressora
              begin

                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'E->OBSERVACAO' then
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]  + Form7.ibDataSet2OBS.AsString;
                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'CHR(15)' then
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]  + chr(15);
                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'CHR(18)' then
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] + chr(18);
                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'CHR(27)+[0]' then
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] + chr(27)+'0';
                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'CHR(27)+[1]' then
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] + chr(27)+'1';
                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2))) = 'CHR(27)+[2]' then vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] + chr(27)+'2';

                if UpperCase(AllTrim(Copy(Form7.ibDataSet19TIPO.AsString,3,17))) = 'CHR(27)+[C]+CHR(' then
                begin
                  vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] + chr(27)+'C'+chr(StrToInt(Copy(Form7.ibDataSet19Tipo.AsString,Length(Form7.ibDataSet19TIPO.AsString)-2,2)));
                  iPagina := StrToInt('0'+Limpanumero((Copy(Form7.ibDataSet19Tipo.AsString,Length(Form7.ibDataSet19TIPO.AsString)-3,3))));
                end;
              end;
              
              if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@R' then // Texto fixo
              begin
                  vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] := Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value))+
                                                           alltrim(Copy(Form7.ibDataSet19TIPO.AsString,3,Length(Form7.ibDataSet19TIPO.AsString)-2));
              end;
              if Copy(Form7.ibDataSet19TIPO.AsString,1,2) = '@E' then  // Valor por extenso
              begin
                vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ] :=
                   Copy(vLinha[ Trunc(Form7.ibDataSet19LINHA.AsFloat) ]+Replicate(' ',200),1,Trunc(Form7.ibDataSet19COLUNA.Value)) +
                       Copy(AllTrim(vCampo[ Trunc( Form7.ibDataSet19ELEMENTO.Value ) ])
                         +' '+Replicate('.x',100),StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,4,2))
                           ,StrToInt(Copy(Form7.ibDataSet19TIPO.AsString,6,2)));
              end;
            end;
            //
          end;
        end;
        //
        Form7.ibDataSet19.Next;
      end;
      {                    }
      { Elimina os acentos }
      {                    }
      for J := 1 to iPagina -1 do
        for I := 1 to 36 do
         vLinha[ J ] := strtran( vLinha[ J ],copy('ÁÀÂÄÃÉÈÊËÍÎÏÓÔÕÚÜÇáàâäãéèêëíîïóôõúüç*',I,1),copy('AAAAAEEEEIIIOOOUUCaaaaaeeeeiiiooouuc*',I,1)
      {+chr(8)+StrTran(copy('/`^"~/~^"/^"/^~/",/~^"~/`^"/^"/^~/",',I,1),'/',Chr(39))});
      {                         }
      { Imprime todas as Linhas }
      {                         }
      // MOTOR DA NOTA FISCAL
      try
        Writeln(F,chr(27)+'@');
        for I := 0 to iPagina -1 do
        begin
          try
            Writeln(F,vLinha[I]);
          except
            //ShowMessage('Verifique a impressora.'); Mauricio Parizotto 2023-10-25
            MensagemSistema('Verifique a impressora.',msgAtencao);
            Abort;
          end;
        end;
        CloseFile(F);
      except
        //ShowMessage('Verifique a impressora.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Verifique a impressora.',msgAtencao);
        Abort;
      end;
    end;

    Form7.sModulo := 'COMPRA';
    Form7.ibDataSet24.Edit;
  end;

  Result := True;
end;

procedure TForm24.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN then if dBgrid2.Visible = True then dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP   then if dBgrid2.Visible = True then dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,1,0);
  Key := VK_SHIFT;
end;

procedure TForm24.FormClose(Sender: TObject; var Action: TCloseAction);
var
  F : TextFile;
  sCustoCompra : String;
begin
  Screen.Cursor := crHourGlass; // Cursor de Aguardo
  Form7.ibDataSet4.DisableControls;
  Form7.ibDataSet23.DisableControls;

  Form24.Panel5.Visible := False;
  Form24.Panel9.Visible := False;
  try
    DeleteFile(pChar(Form1.sAtual+'\Cálculos de Custos da Última Nota.txt'));   // Apaga o arquivo anterior
    AssignFile(F,pchar(Form1.sAtual+'\Cálculos de Custos da Última Nota.txt'));
    Rewrite(F);           // Abre para gravação

	DefineDataSetInfNFe;
    // Tudo que for feito alteração no DATASET24 coloque depois da linha abaixo
    // caso contrário pode ocorrer de tentar alterar valores e o dataset não ta
    // no estado de alteração (vai dar erro).
    if Form7.ibDataSet24.Modified then
      Form7.ibDataSet24.Post;

    if Form7.ibDataSet24.State = dsBrowse then
      Form7.ibDataSet24.Edit;

    DBMemo1.SetFocus;
    
    try
      if Form7.ibDataSet24FINNFE.AsString   <> LimpaNumero(Edit7.Text) then
        Form7.ibDataSet24FINNFE.AsString   := LimpaNumero(Edit7.Text);
      if Form7.ibDataSet24INDFINAL.AsString <> LimpaNumero(Edit8.Text) then
        Form7.ibDataSet24INDFINAL.AsString := LimpaNumero(Edit8.Text);
      if Form7.ibDataSet24INDPRES.AsString  <> LimpaNumero(Edit9.Text) then
        Form7.ibDataSet24INDPRES.AsString  := LimpaNumero(Edit9.Text);

      if (Trim(Copy(Form7.ibDataSet24NFEID.AsString,21,2)) <> '')
        and (Trim(Copy(Form7.ibDataSet24NFEID.AsString,21,2)) <> '00')
        and (Form7.ibDataSet24MODELO.AsString <> Trim(Copy(Form7.ibDataSet24NFEID.AsString,21,2))) then
        Form7.ibDataSet24MODELO.AsString  := Trim(Copy(Form7.ibDataSet24NFEID.AsString,21,2));
    except
      on E: Exception do
        //ShowMessage('Erro ao gravar NF-e: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
        MensagemSistema('Erro ao gravar NF-e: '+chr(10)+E.Message,msgErro);
    end;

    if AllTrim(Form7.ibDataSet24FORNECEDOR.AsString) <> '' then
    begin
      //////////////////////////////////////////////////////////////////////////////////
      // Atenção a rotina abaixo altera a quantidade no estoque                       //
      //////////////////////////////////////////////////////////////////////////////////
      Form1.bFlag := True;

      Writeln(F,'CÁLCULO DO CUSTO MÉDIO DA ÚLTIMA NOTA');
      Writeln(F,Replicate('-',80));
      Writeln(F,'CUSTO MÉDIO  = ((QTD_ATUAL * CUSTOMEDIO ANTERIOR) + (QUANTIDADE * CUSTOCOMPR - (VICMS / QUANTIDADE))))/ (QUANTIDADE + QTD_ATUAL)');
      Writeln(F,'CUSTO COMPRA = (VALOR UNITARIO + ((TOTAL ICMS ST + TOTAL VIPI)/ QUANTIDADE) ) + (( VALOR UNITARIO / TOTAL MERCADORIAS ) * ( FRETE + SEGURO + OUTRAS DESPESAS - DESCONTO ))');
      Writeln(F,Replicate('-',80));

      while not Form7.ibDataSet23.Eof do
      begin
        Form7.ibDataSet23.Edit;

        if (Form7.ibDataSet23QUANTIDADE.AsFloat > 0)  and (AllTrim (Form7.ibDataSet23DESCRICAO.AsString) <> '') then
        begin
          // Procura o produto no estoque
          Form7.ibDataSet4.Close;
          Form7.ibDataSet4.Selectsql.Clear;
          Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');
          Form7.ibDataSet4.Open;
          Form7.ibDataSet4.Edit;

          try
            //Remove marcação de prduto novo
            if Form7.ibDataSet4ALTERADO.AsString = '3' then
              Form7.ibDataSet4ALTERADO.AsString     := '0';

            if Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            begin
              // SERIAIS - Repassa o valor pago e a data da compra //
              if Form7.ibDataSet4.FieldByname('SERIE').Value = 1 then
              begin
                Form7.ibDataSet30.Close;
                Form7.ibDataSet30.SelectSQL.Clear;
                Form7.ibDataSet30.Selectsql.Add('select * from SERIE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' and NFCOMPRA='+QuotedStr( Copy(Form7.ibDataSet24NUMERONF.AsString,4,6) )+' ');
                Form7.ibDataSet30.Open;

                while not Form7.ibDataSet30.Eof do
                begin
                  Form7.ibDataSet30.Edit;
                  Form7.ibDataSet30VALCOMPRA.AsFloat     := Form7.ibDataSet23UNITARIO.AsFloat;
                  Form7.ibDataSet30DATCOMPRA.AsDateTime  := Form7.ibDataSet24EMISSAO.AsDateTime;
                  Form7.ibDataSet30.Post;
                  Form7.ibDataSet30.Next;
                end;
              end;

              try
                try
                  // Primeiro atualiza o custo depois a quantidade
                  try
                    if (Form7.ibDataSet23UNITARIO.Asfloat <> 0) then
                    begin
                      if (AllTrim(Form7.ibDataSet14INTEGRACAO.AsString) <> '') then
                      begin
                        // Fórmula do custo de compra                                                                     //
                        // Custo Compra = (Valor Unitário + ICMSST + VIPI) + (( Valor Unitário / Valor das mercadorias )  //
                        //                 * ( frete + Seguro + Outras ))                                                 //
                        //                                                                                                //
                        // Obs: O Custo de Compra é a soma do valor pago ao fornecedor mais as                            //
                        // despesas proporcionais de frete seguro e outras.                                               //
                        //
                        if (Form7.ibDataSet4ULT_COMPRA.AsDateTime <= Form7.ibDataSet24EMISSAO.AsDateTime) then
                        begin
                          {Sandro Silva 2023-10-16 inicio
                          Form7.ibDataSet4CUSTOCOMPR.AsFloat := (Form7.ibDataSet23UNITARIO.AsFloat + ((Form7.ibDataSet23VICMSST.AsFloat + Form7.ibDataSet23VIPI.AsFloat)/Form7.ibDataSet23QUANTIDADE.AsFloat) ) // Unitário + ICMSST + IPI
                                                                + (( Form7.ibDataSet23UNITARIO.AsFloat     // Rateio   //
                                                                   / Form7.ibDataSet24MERCADORIA.AsFloat ) * //          //
                                                                  ( Form7.ibDataSet24FRETE.AsFloat +         // o frete  //
                                                                     Form7.ibDataSet24SEGURO.AsFloat +       // o seguro //
                                                                     Form7.ibDataSet24DESPESAS.AsFloat -     // outras   //
                                                                     Form7.ibDataSet24DESCONTO.AsFloat       // desconto //
                                                                  )); //
                          }

                          //Se alterar aqui, alerar sql da tela FrmPrecificacaoProduto
                          Form7.ibDataSet4CUSTOCOMPR.AsFloat := (Form7.ibDataSet23UNITARIO.AsFloat + ((Form7.ibDataSet23VICMSST.AsFloat + Form7.ibDataSet23VIPI.AsFloat + Form7.ibDataSet23VFCPST.AsFloat)/Form7.ibDataSet23QUANTIDADE.AsFloat) ) // Unitário + ICMSST + IPI + FCP ST
                                                                + (( Form7.ibDataSet23UNITARIO.AsFloat     // Rateio   //
                                                                   / Form7.ibDataSet24MERCADORIA.AsFloat ) * //          //
                                                                  ( Form7.ibDataSet24FRETE.AsFloat +         // o frete  //
                                                                     Form7.ibDataSet24SEGURO.AsFloat +       // o seguro //
                                                                     Form7.ibDataSet24DESPESAS.AsFloat -     // outras   //
                                                                     Form7.ibDataSet24DESCONTO.AsFloat       // desconto //
                                                                  )); 
                          {Sandro Silva 2023-10-16 fim}

                          {Sandro Silva 2023-03-02 inicio}
                          if AnsiContainsText(Form7.ibDataSet4CUSTOCOMPR.AsString, 'INF') then
                            Form7.ibDataSet4CUSTOCOMPR.AsFloat := 0.00;
                          {Sandro Silva 2023-03-02 fim}

                          {Sandro Silva 2023-10-16 inicio
                          sCustoCompra := Form7.ibDataSet4CUSTOCOMPR.AsString +
                                          ' = ( ' + Form7.ibDataSet23UNITARIO.AsString + ' + ' +
                                          '(( ' + Form7.ibDataSet23VICMSST.AsString + ' + ' + Form7.ibDataSet23VIPI.AsString + ') / ' + Form7.ibDataSet23QUANTIDADE.AsString+ '))'+
                                          '+ (( ' + Form7.ibDataSet23UNITARIO.AsString +
                                          ' / ' +  Form7.ibDataSet24MERCADORIA.AsString + ' ) * ' +
                                          ' ( ' + Form7.ibDataSet24FRETE.AsString + ' + ' +
                                          Form7.ibDataSet24SEGURO.AsString + ' + ' +
                                          Form7.ibDataSet24DESPESAS.AsString + ' - ' +
                                          Form7.ibDataSet24DESCONTO.AsString + ' ))';
                          }
                          sCustoCompra := Form7.ibDataSet4CUSTOCOMPR.AsString +
                                          ' = ( ' + Form7.ibDataSet23UNITARIO.AsString + ' + ' +
                                          '(( ' + Form7.ibDataSet23VICMSST.AsString + ' + ' + Form7.ibDataSet23VIPI.AsString + ' + ' + Form7.ibDataSet23VFCPST.AsString + ') / ' + Form7.ibDataSet23QUANTIDADE.AsString + '))' +
                                          '+ (( ' + Form7.ibDataSet23UNITARIO.AsString +
                                          ' / ' +  Form7.ibDataSet24MERCADORIA.AsString + ' ) * ' +
                                          ' ( ' + Form7.ibDataSet24FRETE.AsString + ' + ' +
                                          Form7.ibDataSet24SEGURO.AsString + ' + ' +
                                          Form7.ibDataSet24DESPESAS.AsString + ' - ' +
                                          Form7.ibDataSet24DESCONTO.AsString + ' ))';
                          {Sandro Silva 2023-10-16 fim}


                          // Fórmula do custo médio                                                //
                          // Custo Médio = (( Quantidade Atual * Custo Médio ) +                   //
                          //               ( Quantidade comprada * ( Custo Compra - VICMS))        //
                          //               / (Quantidade comprada + Quantidade Atual)              //
                          //                                                                       //
                          // Obs: O Custo Médio é a média ponderada entre o custo da mercadoria    //
                          // comprada menos o crédito de ICMS e o custo da mercadoria em estoque.  //

                          if not Form1.bMediaPonderadaFixa then
                          begin
                            if Form7.ibDataSet23CUSTO.AsFloat = 0 then
                            begin
                              if (Form7.ibDataSet4CUSTOMEDIO.AsFloat = 0) or (Form7.ibDataSet4QTD_ATUAL.AsFloat <= 0)  then
                              begin
                                Form7.ibDataSet4CUSTOMEDIO.AsFloat := Form7.ibDataSet4CUSTOCOMPR.AsFloat - (Form7.ibDataSet23VICMS.Asfloat/Form7.ibDataSet23QUANTIDADE.Asfloat);

                                {Sandro Silva 2023-03-01 inicio}
                                if AnsiContainsText(Form7.ibDataSet4CUSTOMEDIO.AsString, 'INF') then
                                  Form7.ibDataSet4CUSTOMEDIO.AsFloat := 0.00;
                                {Sandro Silva 2023-03-01 fim}

                                Writeln(F,'Descrição.........: ' + Form7.ibDataset4DESCRICAO.AsString);
                                Writeln(F,'Código............: ' + Form7.ibDataset4CODIGO.AsString);
                                Writeln(F,'Custo de compra...: ' + sCustoCompra);
                                Writeln(F,'Custo médio.......: ' + Form7.ibDataSet4CUSTOMEDIO.AsString + ' = '+Form7.ibDataSet4CUSTOMEDIO.AsString);
                              end else
                              begin

                                {Sandro Silva 2023-03-01 inicio}
                                if AnsiContainsText(Form7.ibDataSet4CUSTOMEDIO.AsString, 'INF') then
                                  Form7.ibDataSet4CUSTOMEDIO.AsFloat := 0.00;
                                {Sandro Silva 2023-03-01 fim}

                                Writeln(F,'Descrição.........: ' + Form7.ibDataset4DESCRICAO.AsString);
                                Writeln(F,'Código............: ' + Form7.ibDataset4CODIGO.AsString);
                                Writeln(F,'Custo de compra...: ' + sCustoCompra);
                                Writeln(F,'Custo médio.......: ' + FloatToStr(((Form7.ibDataSet4QTD_ATUAL.Asfloat * Form7.ibDataSet4CUSTOMEDIO.AsFloat) +
                                                                              (Form7.ibDataSet23QUANTIDADE.Asfloat * (Form7.ibDataSet4CUSTOCOMPR.AsFloat -
                                                                              (Form7.ibDataSet23VICMS.Asfloat/Form7.ibDataSet23QUANTIDADE.Asfloat))))
                                                                               / (Form7.ibDataSet23QUANTIDADE.Asfloat + Form7.ibDataSet4QTD_ATUAL.Asfloat))+
                                                                   ' = (('+Form7.ibDataSet4QTD_ATUAL.AsString+' * ' +
                                                                   Form7.ibDataSet4CUSTOMEDIO.AsString+') + ('+Form7.ibDataSet23QUANTIDADE.AsString +
                                                                   ' * ('+Form7.ibDataSet4CUSTOCOMPR.AsString+
                                                                   ' - ('+Form7.ibDataSet23VICMS.AsString+' / '+Form7.ibDataSet23QUANTIDADE.AsString+'))))'+
                                                                   '/ ('+Form7.ibDataSet23QUANTIDADE.AsString+' + '+Form7.ibDataSet4QTD_ATUAL.AsString+')'
                                                                   );

                                Form7.ibDataSet4CUSTOMEDIO.AsFloat := ((Form7.ibDataSet4QTD_ATUAL.Asfloat * Form7.ibDataSet4CUSTOMEDIO.AsFloat) + (Form7.ibDataSet23QUANTIDADE.Asfloat * (Form7.ibDataSet4CUSTOCOMPR.AsFloat - (Form7.ibDataSet23VICMS.Asfloat/Form7.ibDataSet23QUANTIDADE.Asfloat))))
                                                                        / (Form7.ibDataSet23QUANTIDADE.Asfloat + Form7.ibDataSet4QTD_ATUAL.Asfloat);

                                {Sandro Silva 2023-03-01 inicio}
                                if AnsiContainsText(Form7.ibDataSet4CUSTOMEDIO.AsString, 'INF') then
                                  Form7.ibDataSet4CUSTOMEDIO.AsFloat := 0.00;
                                {Sandro Silva 2023-03-01 fim}

                              end;

                              Writeln(F,Replicate('-',80));
                            end;
                          end;

                          Form7.ibDataSet4.Post;
                          Form7.ibDataSet4.Edit;
                          Form7.ibDataSet4QTD_COMPRA.AsFloat    := Form7.ibDataSet4QTD_COMPRA.AsFloat + Form7.ibDataSet23QUANTIDADE.Asfloat;

                          Form7.ibDataSet4FORNECEDOR.ReadOnly   := False;
                          Form7.ibDataSet4FORNECEDOR.AsString   := Form7.ibDataSet24FORNECEDOR.AsString;
                          Form7.ibDataSet4FORNECEDOR.ReadOnly   := True;

                          Form7.ibDataSet4ULT_COMPRA.AsDateTime := Form7.ibDataSet24EMISSAO.AsDateTime;
                          Form7.ibDataSet4ALTERADO.AsString     := '0';

                          if Form7.ibDataSet23LISTA.AsFloat <> 0 then
                          begin
                            Form7.ibDataSet4PRECO.AsFloat      := Form7.ibDataSet23LISTA.AsFloat;
                            Form7.ibDataSet4ALTERADO.AsString  := '1';
                          end;
                        end;
                        ///////////////////////////////////////////////////////////////////////////
                        // Fórmula do custo médio                                                //
                        //                                                                                                //
                        // Fórmula do custo de medio                                                                      //
                        // Custo Medio = (Valor Unitário + ICMSST + VIPI) + (( Valor Unitário / Valor das mercadorias )   //
                        //                 * ( frete + Seguro + Outras )) - Credito de ICMS                               //
                        //                                                                                                //
                        // Obs: O Custo de medio é a media ponderada dasoma do valor pago ao fornecedor mais as           //
                        // despesas proporcionais de frete seguro e outras menos o crédito de ICMS.                       //
                        //
                        {Sandro Silva 2023-10-17 inicio
                        Form7.ibDataSet23CUSTO.AsFloat        := (Form7.ibDataSet23UNITARIO.AsFloat + ((Form7.ibDataSet23VICMSST.AsFloat + Form7.ibDataSet23VIPI.AsFloat)/Form7.ibDataSet23QUANTIDADE.AsFloat) ) // Unitário + ICMSST + IPI
                                                                  + (( Form7.ibDataSet23UNITARIO.AsFloat     // Rateio   //
                                                                   / Form7.ibDataSet24MERCADORIA.AsFloat ) * //          //
                                                                  ( Form7.ibDataSet24FRETE.AsFloat +         // o frete  //
                                                                     Form7.ibDataSet24SEGURO.AsFloat +       // o seguro //
                                                                     Form7.ibDataSet24DESPESAS.AsFloat -     // outras   //
                                                                     Form7.ibDataSet24DESCONTO.AsFloat       // desconto //
                                                                     )) - (Form7.ibDataSet23VICMS.Asfloat/Form7.ibDataSet23QUANTIDADE.AsFloat); // menos o crédito de ICMS
                        }
                        try
                          // itens002.custo armazena o custo médio
                          Form7.ibDataSet23CUSTO.AsFloat        := (Form7.ibDataSet23UNITARIO.AsFloat + ((Form7.ibDataSet23VICMSST.AsFloat + Form7.ibDataSet23VIPI.AsFloat + Form7.ibDataSet23VFCPST.AsFloat)/Form7.ibDataSet23QUANTIDADE.AsFloat) ) // Unitário + ICMSST + IPI + FCPST
                                                                    + (( Form7.ibDataSet23UNITARIO.AsFloat     // Rateio   //
                                                                     / Form7.ibDataSet24MERCADORIA.AsFloat ) * //          //
                                                                    ( Form7.ibDataSet24FRETE.AsFloat +         // o frete  //
                                                                       Form7.ibDataSet24SEGURO.AsFloat +       // o seguro //
                                                                       Form7.ibDataSet24DESPESAS.AsFloat -     // outras   //
                                                                       Form7.ibDataSet24DESCONTO.AsFloat       // desconto //
                                                                       )) - (Form7.ibDataSet23VICMS.AsFloat/Form7.ibDataSet23QUANTIDADE.AsFloat); // menos o crédito de ICMS

                          if AnsiContainsText(Form7.ibDataSet23CUSTO.AsString, 'INF') then
                            Form7.ibDataSet23CUSTO.AsFloat := 0.00;

                        except
                          Form7.ibDataSet23CUSTO.AsFloat := 0.00;
                        end;
                        {Sandro Silva 2023-10-17 fim}

                        //
                        Form7.ibDataSet4.Post;
                      end;
                    end;
                  except
                    on E: Exception do
                      //ShowMessage('Erro ao calcular custo médio: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
                      MensagemSistema('Erro ao calcular custo médio: '+chr(10)+E.Message,msgErro);
                  end;

                  try
                    if Form7.ibDataSet23SINCRONIA.AsFloat <> Form7.ibDataSet23QUANTIDADE.AsFloat then
                    begin
                      if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
                      begin
                        // Atenção a rotina acima altera a quantidade no estoque
                        Form7.ibDataSet4.Edit;
                        Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat + Form7.ibDataSet23QUANTIDADE.AsFloat;
                        
                        // Atenção a rotina acima altera a quantidade no estoque

                        Form7.ibDataSet4.Post;
                      end;

                      Form7.sModulo := 'NAO';
                      Form7.ibDataSet23SINCRONIA.AsFloat := Form7.ibDataSet23QUANTIDADE.AsFloat;        // Resolvi este problema as 4 da madrugada no NoteBook em casa
                    end;
                  except
                  end;
                except
                end;

                Form7.sModulo := 'NAO';
              except
              end;

              try
                //////////////////////////////////////////////////////////////////////////////////////////////////
                // Fórmula do custo médio                                                                       //
                // Custo Médio = (CUSTO DE CADA COMPRA * QUANTIDADE DE CADA COMPRA) / QUANTIDADE TOTAL COMPRADA //
                //                                                                                              //

                if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
                  Form7.ibDataset4.Edit;

                // Duas formas de calcular o custo médio
                if Form1.bMediaPonderadaFixa then
                begin
                  Form7.ibDataSet23.Post;
                  Form7.ibDataSet23.Edit;
                  Form7.IBTransaction1.CommitRetaining;

                  Form7.IBQuery99.Close;
                  Form7.IBQuery99.SQL.Clear;
                  Form7.IBQuery99.SQL.Add('select sum(CUSTO*QUANTIDADE)as vC, sum(QUANTIDADE) as vQ from ITENS002 where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' and Coalesce(CUSTO,0)<>0');
                  Form7.IBQuery99.Open;

                  {Sandro Silva 2023-03-01 inicio}
                  if AnsiContainsText(Form7.ibDataSet4CUSTOMEDIO.AsString, 'INF') then
                    Form7.ibDataSet4CUSTOMEDIO.AsFloat := 0.00;
                  {Sandro Silva 2023-03-01 fim}
                end;

                // Grava a nova quantidade o novo fornecedor e a ultima compra no estoque //
                Form7.ibDataset4.Post;
              except
              end;
            end;
          except
          end;
        end;

        try
          if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
            Form7.ibDataset4.Post;
        except
        end;

        Form7.ibDataSet23.Post;
        Form7.ibDataSet23.Next;
      end;

      Form1.bFlag := True;
      Form7.sModulo := 'COMPRAS';

      // Atenção a rotina acima altera a quantidade no estoque
      /////////////////////////////////////////////////////////////////////////////////
      //
      // Desdobramento das duplicatas
      //
      Form7.sModulo := 'COMPRA';
      Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet24OPERACAO.AsString,[]);

      ApagaIntegracaoComOCaixa2(True);

      if Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString),1,5) = 'CAIXA' then
      begin
        IntegracaoComOCaixa2(True)
      end;

      if (Copy(AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString),1,5) = 'PAGAR')
      and (Form7.ibDataSet24TOTAL.AsFloat > 0) then
      begin
        Form18.IdentificadorPlanoContas := Form7.ibDataSet24IDENTIFICADORPLANOCONTAS.AsString; // Sandro Silva 2022-12-29

        Form18.ShowModal;
        {Sandro Silva 2022-12-29 inicio}
        if Form1.DisponivelSomenteParaNos then
        begin
          if not (Form7.ibDataSet24.State in [dsEdit, dsInsert]) then
            Form7.ibDataSet24.Edit;
          Form7.ibDataSet24IDENTIFICADORPLANOCONTAS.AsString := Form18.IdentificadorPlanoContas;
          Form7.ibDataSet24.Post;
          Form7.ibDataSet24.Edit;
        end;
        {Sandro Silva 2022-12-29 fim}
      end else
      begin
        ApagaAsDuplicatasAnteriores2(True);
        Form7.ibDataSet24.Edit;
        Form7.ibDataSet24DUPLICATAS.AsFloat := 0;
      end;
    end;

    //                                                           //
    // Lay-Out no form7                                         //
    //                                                         //
    Form7.ibDataSet23UNITARIO.Visible     := False;         //
    Form7.ibDataSet23CFOP.Visible         := True; // Sandro Silva 2023-03-27 Form7.ibDataSet23CFOP.Visible           := False;        //       //
    Form7.ibDataSet23BASE.Visible         := False;       //
    Form7.ibDataSet23VICMS.Visible        := False;
    Form7.ibDataSet23VBC.Visible          := False;
    Form7.ibDataSet23VBCST.Visible        := False;
    Form7.ibDataSet23VICMSST.Visible      := False;
    Form7.ibDataSet23VIPI.Visible         := False;
    // Sandro Silva 2023-03-29 Form7.ibDataSet23DESCRICAO.DisplayWidth := 35;         //

    {Sandro Silva 2023-03-29 inicio}
    Form7.ibDataSet23UNITARIO_O.Visible   := False;
    Form7.ibDataSet23QUANTIDADE.Visible   := True;
    Form7.ibDataSet23QTD_ORIGINAL.Visible := False;
    {Sandro Silva 2023-04-11 inicio}
    Form7.ibDataSet23VBCFCP.Visible       := False;
    Form7.ibDataSet23PFCP.Visible         := False;
    Form7.ibDataSet23VFCP.Visible         := False;
    Form7.ibDataSet23VBCFCPST.Visible     := False;
    Form7.ibDataSet23PFCPST.Visible       := False;
    Form7.ibDataSet23VFCPST.Visible       := False;
    {Sandro Silva 2023-04-11 fim}         
    Form7.ibDataSet23DESCRICAO.DisplayWidth    := 41;         //
    Form7.ibDataSet23TOTAL.DisplayWidth        := 09;
    Form7.ibDataSet23QUANTIDADE.DisplayWidth   := 09;
    Form7.ibDataSet23QTD_ORIGINAL.DisplayWidth := 10;
    Form7.ibDataSet23UNITARIO_O.DisplayWidth   := 10;

    Form7.ibDataSet23QUANTIDADE.DisplayLabel    := 'Qtd';
    {Sandro Silva 2023-03-29 fim}

    dbGrid2.TitleFont.Color := clBlack;

    Screen.Cursor := crDefault; // Cursor de Aguardo

    Form7.IBQuery99.Close;
    Form7.IBQuery99.SQL.Clear;
    Form7.IBQuery99.SQL.Add('delete from ITENS002 where Coalesce(DESCRICAO,'''')='+QuotedStr('')+'');
    Form7.IBQuery99.Open;
  except
  end;

  Form7.ibDataSet4.EnableControls;
  Form7.ibDataSet23.EnableControls;

  if Form7.Visible then
  begin
    Screen.Cursor            := crHourGlass;
    AgendaCommit(True);
    Form7.Close;
    Form7.Show;
    Screen.Cursor            := crDefault;
  end;
  
  try
    CloseFile(F);  // Fecha o arquivo
  except
  end;
end;

procedure TForm24.SMALL_DBEdit40Change(Sender: TObject);
begin
  if (Form24.Visible) and (Form7.ibDataSet14.Active) then
  begin
    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM ICM where ((CFOP like '+QuotedStr('1%')+') or (CFOP like '+QuotedStr('2%')+') or (CFOP like '+QuotedStr('3%')+')) and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit40.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.IBDataSet99.EnableControls;
    Form7.ibDataSet14.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
    //
    Form7.ibDataSet24.Enablecontrols;
    dBGrid2.DataSource := Form7.DataSource14;
    Form7.ibDataSet14.EnableControls;
    //
  end;
end;

procedure TForm24.SMALL_DBEdit40Enter(Sender: TObject);
begin
  //
  Panel5.Visible  := False;
  dBGrid3.Visible := False;
  // ------------------------- //
  // Operação de venda ICM.DBF //
  // ------------------------- //
  dBGrid2.DataSource := Form7.DataSource14;
  dBGrid2.Visible    := True;
  //
//  if Form7.ibDataSet14.IndexFieldNames <> 'NOME' then Form7.ibDataSet14.IndexFieldNames := 'NOME';
  //
  if AllTrim(SMALL_DBEdit40.Text) = '' then
  begin
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.First;
    while (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '1102') and (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '2102') and
     (not Form7.ibDataSet14.EOF) do Form7.ibDataSet14.Next;
    Form7.ibDataSet14.EnableControls;
    Form7.ibDataSet24.Edit;
    SMALL_DBEdit40.Text := Form7.ibDataSet14NOME.AsString;
  end else
  begin
//    Form7.ibDataSet14.SetKey;
//    Form7.ibDataSet14NOME.AsString := AllTrim(SMALL_DBEdit40.Text);
//    Form7.ibDataSet14.GotoNearest;
  end;
  //
  dBGrid2.DataSource := Form7.DataSource14;
  dBGrid2.Visible := True;
  dBGrid2.Visible := True;
  dBGrid2.Height  := 173;
  dBGrid2.Left    := SMALL_DBEdit40.Left;
  dbGrid2.Top     := SMALL_DBEdit40.Top + SMALL_DBEdit40.Height;
  dbGrid2.Width    := SMALL_DBEdit40.Width;
  dbGrid2.Columns[0].Width := dbGrid2.Width - 30;
  //
  SMALL_DBEdit40.SelectAll;
  //
end;

procedure TForm24.SMALL_DBEdit40Exit(Sender: TObject);
begin
  //************************************
  // Joga p/obs a obs na tabela de icm *
  //************************************
  if AllTrim(Form7.ibDataSet24OPERACAO.AsString) <> AllTrim(Form7.ibDataSet14NOME.AsString) then Observacao2(False);
  //***********************
  // Limpando o que tinha *
  // **********************
  { ------------------------- }
  { Operação de venda ICM.DBF }
  { ------------------------- }
  sText := AllTrim(SMALL_DBEdit40.Text);
  if sText <> '' then
  begin
    tProcura := Form7.ibDataSet14;
    if Pos(AnsiUpperCase(sText),AnsiUpperCase(AllTrim(tProcura.FieldByName('NOME').AsString))) <> 0 then
    begin
      Form7.ibDataSet24.Edit;
      Form7.ibDataSet24OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
    end
    else
    begin
//      Form29.ShowModal;
      Form7.ibDataSet24.Edit;
      if Pos(AnsiUpperCase(AllTrim(sText)),AnsiUpperCase(tProcura.FieldByName('NOME').AsString)) = 0 then
         Form7.ibDataSet24OPERACAO.AsString := '';
      if AllTrim(sText) <> tProcura.FieldByName('NOME').AsString  then sText := '' else
         Form7.ibDataSet24OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
      SMALL_DBEdit40.SetFocus;
    end;
    Form7.ibDataSet24.Edit;
    Form7.ibDataSet24.Post;
    Form7.ibDataSet24.Edit;
    Form24.SMALL_DBEdit11Exit(Sender);
  end;
  //
  if SMALL_DBEdit40.Text = '' then SMALL_DBEdit40.Text := Form7.ibDataSet14NOME.AsString;
  //
end;


procedure TForm24.DBGrid2CellClick(Column: TColumn);
begin
  //************************************
  // Joga p/obs a obs na tabela de icm *
  //************************************
  if AllTrim(Form7.ibDataSet24OPERACAO.AsString) <> AllTrim(Form7.ibDataSet14NOME.AsString) then Observacao2(False);
  //***********************
  // Limpando o que tinha *
  // **********************
  Form7.ibDataSet24.Edit;
  Form7.ibDataSet24OPERACAO.AsString    := form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet24FORNECEDOR.AsString  := form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet24TRANSPORTA.AsString  := form7.ibDataSet18NOME.AsString;
  //
end;

procedure TForm24.DBGrid2DblClick(Sender: TObject);
begin
  //
  if AllTrim(Form7.ibDataSet24OPERACAO.AsString) <> AllTrim(Form7.ibDataSet14NOME.AsString) then Observacao2(False);
  Form7.ibDataSet24.Edit;
  Form7.ibDataSet24OPERACAO.AsString   := form7.ibDataSet14NOME.AsString;
  Form7.ibDataSet24FORNECEDOR.AsString := form7.ibDataSet2NOME.AsString;
  Form7.ibDataSet24TRANSPORTA.AsString := form7.ibDataSet18NOME.AsString;
  dBGrid2.Visible := False;
  if dbGrid2.Top = (SMALL_DBEdit39.Top + SMALL_DBEdit39.Height) then SMALL_DBEdit39.SetFocus;
  if dbGrid2.Top = (SMALL_DBEdit40.Top + SMALL_DBEdit40.Height) then SMALL_DBEdit40.SetFocus;
  if dbGrid2.Top = (SMALL_DBEdit41.Top + SMALL_DBEdit41.Height) then SMALL_DBEdit41.SetFocus;
  //
end;

procedure TForm24.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    //************************************
    // Joga p/obs a obs na tabela de icm *
    //************************************
    if AllTrim(Form7.ibDataSet24OPERACAO.AsString) <> AllTrim(Form7.ibDataSet14NOME.AsString) then Observacao2(False);
    //***********************
    // Limpando o que tinha *
    // **********************
    Form7.ibDataSet24.Edit;
    Form7.ibDataSet24OPERACAO.AsString   := form7.ibDataSet14NOME.AsString;
    Form7.ibDataSet24FORNECEDOR.AsString := form7.ibDataSet2NOME.AsString;
    Form7.ibDataSet24TRANSPORTA.AsString := form7.ibDataSet18NOME.AsString;
    dBGrid2.Visible := False;
    if dbGrid2.Top = (SMALL_DBEdit39.Top + SMALL_DBEdit39.Height) then SMALL_DBEdit39.SetFocus;
    if dbGrid2.Top = (SMALL_DBEdit40.Top + SMALL_DBEdit40.Height) then SMALL_DBEdit40.SetFocus;
    if dbGrid2.Top = (SMALL_DBEdit41.Top + SMALL_DBEdit41.Height) then SMALL_DBEdit41.SetFocus;
  end;
end;

procedure TForm24.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //
  MostraFoto2(True);
  //
end;

procedure TForm24.SMALL_DBEdit39Change(Sender: TObject);
begin
  if (Form24.Visible) and (Form7.ibDataSet2.Active) then
  begin
    //
    if Form1.bChaveSelecionaCliente then
    begin
      dBGrid2.Visible    := True;
      Form7.ibDataSet2.DisableControls;
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.SelectSQL.Clear;
      Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit39.Text)+'%')+' and coalesce(ATIVO,0)=0 order by NOME');
      Form7.ibDataSet2.Open;
      Form7.ibDataSet2.EnableControls;
    end;  
    //
  end;
end;

procedure TForm24.SMALL_DBEdit39Enter(Sender: TObject);
begin
  //
  Form1.bChaveSelecionaCliente := True;
  //
  if SMALL_DBEdit39.Text = Form7.ibDataSet2.fieldByName('NOME').AsString then  MostraFoto2(True);
  //
  SMALL_DBEdit39.SetFocus;
  dBGrid3.Visible := False;
  //
  Form24.VertScrollbar.Position := 10;
  dBGrid2.DataSource            := Form7.DataSource2;
  dBGrid2.Visible               := False;
  dBGrid2.Height                := 190;
  dbGrid2.Top                   := SMALL_DBEdit39.Top + SMALL_DBEdit39.Height;
  dbGrid2.Width                 := SMALL_DBEdit39.Width;
  dbGrid2.Columns[0].Width      := dbGrid2.Width - 30;
  //
  SMALL_DBEdit39.SelectAll;
  //
end;

procedure TForm24.SMALL_DBEdit39Exit(Sender: TObject);
var
  sRegistro : String;
begin
  //
  Form1.bChaveSelecionaCliente := False;
  //
  // CPF/CGC
  //
  if AllTrim(LimpaNumero(SMALL_DBEdit39.Text))<>'' then
  begin
    if Length(LimpaNumero(Copy(SMALL_DBEdit39.Text,1,3)))=3 then
    begin
      if CpfCgc(LimpaNumero(SMALL_DBEdit39.Text)) then
      begin
        // CAAD9
        Form7.ibDataSet2.DisableControls;
        Form7.ibDataSet2.Close;
        Form7.ibDataSet2.SelectSQL.Clear;
        Form7.ibDataSet2.SelectSQL.Add('select * FROM CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(LimpaNumero(SMALL_DBEdit39.Text))))+'');
        Form7.ibDataSet2.Open;
        Form7.ibDataSet2.EnableControls;

        Form7.ibDataSet24FORNECEDOR.AsString := Form7.ibDataSet2NOME.AsString;
      end;
    end;
  end;

  // CPF/CGC
  if AllTrim(SMALL_DBEdit39.Text)<>AllTrim(Form7.ibDAtaSet2NOME.AsString) then
  begin
    Form7.ibDataSet24FORNECEDOR.AsString := Form7.ibDataSet2NOME.AsString;
  end;
  
  Form7.IBDataSet99.Close;
  Form7.IBDataSet99.SelectSQL.Clear;
  Form7.IBDataSet99.SelectSQL.Add('select NUMERONF, FORNECEDOR, REGISTRO from COMPRAS where NUMERONF='+QuotedStr(Form7.ibDataSet24NUMERONF.AsString)+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' and REGISTRO<>'+QuotedStr(Form7.ibDataSet24REGISTRO.AsString)+' ');
  Form7.IBDataSet99.Open;
  //
  if (Form7.IBDataSet99.FieldByName('NUMERONF').AsString = Form7.ibDataSet24NUMERONF.AsString) and (Form7.IBDataSet99.FieldByName('FORNECEDOR').AsString = Form7.ibDataSet24FORNECEDOR.AsString) and (Form7.IBDataSet99.FieldByName('REGISTRO').AsString <> Form7.ibDataSet24REGISTRO.AsString) then
  begin
    sRegistro := Form7.IBDataSet99.FieldByName('REGISTRO').AsString;

    //ShowMessage('Nota fiscal já cadastrada.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Nota fiscal já cadastrada.',msgAtencao);

    Form7.sModulo := 'DUPLA';
    Form7.ibDataSet24.Delete;
    Form7.sModulo := 'COMPRA';
    //
    Form7.ibDataSet24.Locate('REGISTRO',sREgistro,[]);
    Form7.ibDataSet24.Edit;
  end else
  begin
    Form7.ibDataSet24.Post;
    Form7.ibDataSet24.Edit;
    //
    SMALL_DBEdit11Exit(Sender);
    Observacao2(False);
    //
    Form7.ibDataSet8.First;
    while not Form7.ibDataSet8.Eof do
    begin
      if (Form7.ibDataset8NOME.AsString <> Form7.IBDataSet2NOME.AsString) and (Form7.ibDataset8NUMERONF.AsString = Form7.ibDataSet24NUMERONF.AsString) then
      begin
        Form7.ibDataset8.Edit;
        Form7.ibDataset8NOME.AsString := Form7.IBDataSet2NOME.AsString;
        Form7.ibDataset8.Post;
      end;
      Form7.ibDataset8.Next;
    end;
  end;
  //
  if SMALL_DBEdit39.Text = Form7.ibDataSet2.fieldByName('NOME').AsString then  MostraFoto2(True);
end;

procedure TForm24.SMALL_DBEdit39KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  if (Key = VK_UP) or (Key = VK_DOWN) then dBgrid2.SetFocus;
end;

procedure TForm24.SMALL_DBEdit41Change(Sender: TObject);
begin
  if (Form24.Visible) and (Form7.ibDataSet18.Active) then
  begin
    dBGrid2.Visible := True;

    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM TRANSPOR where Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit41.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;
    Form7.ibDataSet99.First;
    Form7.ibDataSet18.Locate('NOME',AllTrim( Form7.ibDataSet99.FieldByname('NOME').AsString  ),[loCaseInsensitive, loPartialKey]);
  end;
end;

procedure TForm24.SMALL_DBEdit41Enter(Sender: TObject);
begin
  dBGrid2.DataSource := Form7.DataSource18;
  //dBGrid2.Visible := True;
  dBGrid2.Height  := 150;
  dBGrid2.Left    := SMALL_DBEdit41.Left;
  dbGrid2.Top     := SMALL_DBEdit41.Top + SMALL_DBEdit41.Height;
  dbGrid2.Width   := SMALL_DBEdit41.Width;
end;

procedure TForm24.SMALL_DBEdit41Exit(Sender: TObject);
begin
  sText := AllTrim(SMALL_DBEdit41.Text);
  if sText <> '' then
  begin
    tProcura := Form7.ibDataSet18;
    if Pos(AnsiUpperCase(AllTrim(sText)),AnsiUpperCase(AllTrim(tProcura.FieldByName('NOME').AsString))) <> 0
    then
    begin
      Form7.ibDataSet24.Edit;
      Form7.ibDataSet24TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
    end else
    begin
//      Form29.ShowModal;
      Form7.ibDataSet24.Edit;
      if Pos(AnsiUpperCase(AllTrim(sText)),AnsiUpperCase(tProcura.FieldByName('NOME').AsString)) = 0 then
         Form7.ibDataSet24TRANSPORTA.AsString := '';
      if AllTrim(sText) <> tProcura.FieldByName('NOME').AsString  then sText := '' else
         Form7.ibDataSet24TRANSPORTA.AsString := Form7.ibDataSet18NOME.AsString;
      SMALL_DBEdit41.SetFocus;
    end;
    Form7.ibDataSet24.Edit;
    Form7.ibDataSet24.Post;
    { Ver }
  end;

  if AllTrim(Form7.ibDataSet24TRANSPORTA.AsString) = '' then Form7.ibDataSet18.Append else
  begin
    if AllTrim(Form7.ibDataSet24FRETE12.AsString) = '' then
    begin
      if not (Form7.ibDataset24.State in ([dsEdit, dsInsert])) then Form7.ibDataset24.Edit;
      Form7.ibDataSet24FRETE12.AsString := '1';
    end;
  end;
end;

procedure TForm24.DBGrid33KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    Form24.DBGrid33DblClick(Sender);
  end;
end;

procedure TForm24.SMALL_DBEdit22Enter(Sender: TObject);
begin
  //
  Form24.Panel5.Visible := False;
  Form24.Panel9.Visible := False;
  //
  VertScrollbar.Position := 200;
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
  Form7.sModulo   := 'FRETE';
end;

procedure TForm24.SMALL_DBEdit23Enter(Sender: TObject);
begin
  dBGrid2.Visible := False;
  VertScrollbar.Position := 200;
end;

procedure TForm24.SMALL_DBEdit11Exit(Sender: TObject);
begin
  if (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '1') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '2') then
  begin
    if AllTrim(Form7.ibDataSet2ESTADO.AsString)='EX' then
    begin
      Form7.ibDataSet14.Edit;
      Form7.ibDataSet14CFOP.AsString := '1'+copy(Form7.ibDataSet14CFOP.AsString,2,5);
      Form7.ibDataSet14.Post;
    end else
    begin
      Form7.ibDataSet14.Edit;
      if (Form7.ibDataSet2ESTADO.AsString = UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '2') then
        Form7.ibDataSet14CFOP.AsString := '1'+copy(Form7.ibDataSet14CFOP.AsString,2,5);
      if (Form7.ibDataSet2ESTADO.AsString <> UpperCase(Form7.ibDataSet13ESTADO.AsString)) and (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '1') then
        Form7.ibDataSet14CFOP.AsString := '2'+copy(Form7.ibDataSet14CFOP.AsString,2,5);
      Form7.ibDataSet14.Post;
    end;
  end;
end;

procedure TForm24.SMALL_DBEdit20Enter(Sender: TObject);
begin
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
end;

procedure TForm24.SMALL_DBEdit4Enter(Sender: TObject);
begin
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
end;

procedure TForm24.Memo2Enter(Sender: TObject);
begin
  dBGrid2.Visible := False;
  dBGrid3.Visible := False;
end;

procedure TForm24.DBGrid1Enter(Sender: TObject);
begin
  Form1.bFlag := False;
  dBGrid2.Visible    := False;
  dBGrid3.Visible    := False;
end;

procedure TForm24.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  if Key = VK_INSERT then
  begin
    PopUpMenu3.Popup(dBGrid1.Left,dBgrid1.Top + 20);
    Key := VK_SHIFT;
    Abort;
  end;

  if ((Key = VK_DOWN) or (Key = VK_UP)) and (dBgrid3.CanFocus) then
  begin
    Key := VK_SHIFT;
    dBgrid3.SetFocus;
  end;

  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  if (Key = VK_RETURN) and (AllTrim(Form7.ibDataSet23DESCRICAO.AsString) = '') then DbGrid1.SelectedIndex := 0;

  if Key = VK_RETURN then
  begin
    Form7.ibDataSet23.Edit;

    if AllTrim(Form7.ibDataSet23DESCRICAO.AsString) <> '' then
    begin
      if DbGrid1.SelectedIndex = 0 then
      begin
        Form1.bFlag := True;
        Form7.ibDataSet23.Edit;

        //Localiza por descrição
        if AnsiUpperCase(AllTrim(Form7.ibDataSet23DESCRICAO.AsString)) = Copy(AnsiUpperCase(Form7.ibDataSet4DESCRICAO.AsString),1,Length(AnsiUpperCase(AllTrim(Form7.ibDataSet23DESCRICAO.AsString)))) then
        begin
          Form7.ibDataSet23DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
        end else
        //Localiza por código
        //Mauricio Parizotto 2023-10-18
        begin
          // chama novamente TForm7.ibDataSet23DESCRICAOChange com bFlag := True
          Form7.ibDataSet23DESCRICAO.AsString := AllTrim(Form7.ibDataSet23DESCRICAO.AsString);
        end;
      end;

      I := DbGrid1.SelectedIndex;
      DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;

      if I = DbGrid1.SelectedIndex  then
      begin
        DbGrid1.SelectedIndex := 0;
        Form7.ibDataSet23.Next;
        if Form7.ibDataSet23.EOF then Form7.ibDataSet23.Append;
      end;
    end else
    begin
      Form7.ibDataSet23.Edit;
      Form7.ibDataSet23.Post;

      Perform(Wm_NextDlgCtl,0,0);
    end;
  end;
  
  Form7.ibDataSet4.EnableControls;
end;

procedure TForm24.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if dbGrid1.SelectedField.DataType = ftFloat then
     if Key = chr(46) then key := chr(44);
end;

procedure TForm24.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_TAB    then Key := VK_RETURN;
  if Key = VK_ESCAPE then Key := VK_RETURN;
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  //
  if DbGrid1.SelectedIndex = 0 then
  begin
    if (Key <> VK_Return) and (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_LEFT) and (Key <> VK_RIGHT) then
    begin
      if not dBGrid3.Visible then
      begin
        dBgrid3.Visible := True;
        dBGrid3.Height  := 170;
      end else
      Form1.bFlag := False;
      Form7.ibDataSet23.Edit;
      Form7.ibDataSet23.UpdateRecord;
      Form7.ibDataSet23.Edit;
      Form1.bFlag := True;
    end;
  end;

  if AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '' then
  begin
    if Form7.ibDataSet23CODIGO.AsString <> Form7.ibDataSet4CODIGO.AsString then
    begin
      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
    end;
  end;

  MostraFoto(True);
end;


procedure TForm24.DBGrid1ColEnter(Sender: TObject);
begin
  dBGrid3.Visible := False;
end;

procedure TForm24.SMALL_DBEdit22KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Form7.sModulo <> 'FRETE' then
  begin
    if Key = VK_RETURN then Perform(Wm_NextDlgCtl,0,0);
  end else Form7.sModulo := 'COMPRA';
  //
  if Key = VK_DOWN   then Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
end;

procedure TForm24.SMALL_DBEdit22Exit(Sender: TObject);
begin
  {Sandro Silva 2023-08-02 inicio
  Form7.ibDataSet23.Edit;
  Form7.ibDataSet23.Post;
  Form7.sModulo   := 'COMPRA';
  }
  AtualizaTotalDaNota;
  {Sandro Silva 2023-08-02 fim}
end;

procedure TForm24.AtualizaTotalDaNota;
begin
  // Atualiza o total da nota
  Form7.ibDataSet23.Edit;
  Form7.ibDataSet23.Post;
  Form7.sModulo   := 'COMPRA';
end;

procedure TForm24.SMALL_DBEdit31Exit(Sender: TObject);
begin
  Ok.SetFocus;
end;

procedure TForm24.SMALL_DBEdit41KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN:
    begin
      if dBgrid2.Visible then
        dBgrid2.SetFocus
      else
        Perform(Wm_NextDlgCtl,0,0);
    end;
    VK_UP:
    begin
      if dBgrid2.Visible then
        dBgrid2.SetFocus
      else
        Perform(Wm_NextDlgCtl,1,0);
    end;
  end;
end;

procedure TForm24.OKClick(Sender: TObject);
begin
  Form24.Close;
end;

procedure TForm24.SMALL_DBEdit15Exit(Sender: TObject);
begin
  OK.SetFocus;
end;

procedure TForm24.SMALL_DBEdit51KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then OK.SetFocus;
  if Key = VK_DOWN   then OK.SetFocus;
  if Key = VK_UP     then Perform(Wm_NextDlgCtl,1,0);
end;

procedure TForm24.DBGrid1CellClick(Column: TColumn);
begin
  //
  Form7.ibDataSet4.Close;                                                //
  Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');  //
  Form7.ibDataSet4.Open;
  //
  if (Form7.ibDataSet4CODIGO.AsString <> Form7.ibDataSet23CODIGO.AsString) or (AllTrim(Form7.ibDataSet23CODIGO.AsString)='') then
  begin
    Form7.ibDataSet4.Close;                                                //
    Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet23DESCRICAO.AsString)+' ');  //
    Form7.ibDataSet4.Open;
  end;
  //
  //
end;

procedure TForm24.DBGrid1ColExit(Sender: TObject);
begin
  exit;
//  Form1.bFlag := True;
  Form7.ibDataSet23DESCRICAOChange(Form7.ibDataSet23DESCRICAO);
  Form7.ibDataSet23QTD_ORIGINALChange(Form7.ibDataSet23QTD_ORIGINAL);
  Form7.ibDataSet23UNITARIO_OChange(Form7.ibDataSet23UNITARIO_O);

  Form12.SMALL_DBEdit45.Repaint;
  Form12.SMALL_DBEdit44.Repaint;
  Form12.SMALL_DBEdit42.Repaint;
end;

procedure TForm24.DBGrid2Exit(Sender: TObject);
begin
  if (dbGrid2.Top = SMALL_DBEdit41.Top + SMALL_DBEdit41.Height)
    then SMALL_DBEdit41.SetFocus else
end;

procedure TForm24.SMALL_DBEdit40KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_INSERT then PopUpMenu3.Popup(SMALL_DBEdit39.Left,SMALL_DBEdit39.Top + 20);
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
end;

procedure TForm24.SMALL_DBEdit9Exit(Sender: TObject);
begin
  DbGrid1.SetFocus;
end;

procedure TForm24.OkEnter(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 200;
end;

procedure TForm24.SMALL_DBEdit40KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then  Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN then if dBgrid2.Visible = True then dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP   then if dBgrid2.Visible = True then dBgrid2.SetFocus else Perform(Wm_NextDlgCtl,1,0);
  Key := VK_SHIFT;
end;

procedure TForm24.Edit5Click(Sender: TObject);
begin
  if Form1.bNotaVendaLiberada then
  begin
    Form24.Close;
    Form7.Vendas_1Click(Sender);
  end;
end;

procedure TForm24.SMALL_DBEdit5KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'Retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then  Perform(Wm_NextDlgCtl,0,0);
end;

procedure TForm24.SMALL_DBEdit43KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then SMALL_DBEdit41.SetFocus;
end;

function TForm24.TestaNotaDescontaICMSDesonerado: Boolean;
begin
  Result := Form7.ibDataSet24ICMS_DESONERADO.AsCurrency > 0;
  cbDescontaICMSDesonerado.Checked := Result;  
end;

procedure TForm24.FormShow(Sender: TObject);
var
  Mais1Ini: TIniFile;
begin
  //
  Form24.Tag := 1;
  Form24.ActiveControl := Nil;
  //
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where Coalesce(Ativo,0)=0 order by upper(NOME)');  //
  Form7.ibDataSet2.Open;
  //
  if Form7.ibDataSet24NUMERONF.AsString = '' then
  begin
    Form7.ibDataSet24.Edit;
    Form7.ibDataSet24NUMERONF.AsString := '000000000';
  end;
  //
  if Form1.bNotaVendaLiberada then Edit5.Enabled := True else Edit5.Enabled := False;
  //
  Grid_Compra(True);
  //
  pnlNota.Left                   := 10;
  Form24.VertScrollBar.Position := 1;
  //
  Form7.ibDataSet14.DisableControls;
  Form7.ibDataSet18.DisableControls;
  Form7.ibDataSet8.DisableControls;
  Form7.ibDataSet2.DisableControls;
  //
  Mais1ini    := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
  //
  try
    ConfDuplo   := Mais1Ini.ReadString('Permitir','Duplos','Não');
  except
    ConfDuplo   := 'Não';
  end;
  //
  Mais1Ini.Free;
  //
  Form7.bChaveRecalculaBase := True;
  //
  // Libera ou não fornecedores e Estoque
  //
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  //
  if AllTrim(Mais1Ini.ReadString(Usuario,'B3','0')) <> '1' then
  begin
    //
    SMALL_DBEdit4.Enabled := False;
    SMALL_DBEdit6.Enabled := False;
    SMALL_DBEdit7.Enabled := False;
    SMALL_DBEdit8.Enabled := False;
    SMALL_DBEdit10.Enabled := False;
    SMALL_DBEdit11.Enabled := False;
    SMALL_DBEdit12.Enabled := False;
    SMALL_DBEdit13.Enabled := False;
    //
  end else
  begin
    //
    SMALL_DBEdit4.Enabled := True;
    SMALL_DBEdit6.Enabled := True;
    SMALL_DBEdit7.Enabled := True;
    SMALL_DBEdit8.Enabled := True;
    SMALL_DBEdit10.Enabled := True;
    SMALL_DBEdit11.Enabled := True;
    SMALL_DBEdit12.Enabled := True;
    SMALL_DBEdit13.Enabled := True;
    //
  end;

  // Arquivo de forneced por ordem de nome

  {$IFDEF VER150}
  ShortDateFormat := 'dd/mm/yyyy';
  {$ELSE}
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  {$ENDIF}

  // Relaciona a natureza da operação com o arquivo de vendas
  if AllTrim(Form7.ibDataSet24OPERACAO.AsString) = ''
    then Form7.ibDataSet14.Append
       else Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet24OPERACAO.AsString,[]);
  //
  // Relaciona os clientes com o arquivo de vendas
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet24FORNECEDOR.AsString)+' ');  //
  Form7.ibDataSet2.Open;
  //
  Form7.ibDataSet18.Locate('NOME',Form7.ibDataSet24TRANSPORTA.AsString,[]);
  //
  // Abre o arquivo de clientes para edição
  try Form7.ibDataSet2.Edit except end;
  //
  if not (AllTrim(Form7.ibDataSet24TRANSPORTA.AsString) = AllTrim(Form7.ibDataSet18NOME.AsString)) then
  begin
    Form7.ibDataSet24.Edit;
    Form7.ibDataSet24TRANSPORTA.AsString := '';
    Form7.ibDataSet18.Append;
  end;

  try
    if AllTrim(Form7.ibDataSet24MODELO.AsString) = '' then
    begin
      Form7.ibDataSet24.Edit;
      Form7.ibDataSet24MODELO.AsString := '01';
    end;
    Label64.Caption := 'Mod: '+StrZero(StrToInt(Form7.ibDataSet24MODELO.AsString),2,0);
  except end;

  if Form7.ibDataSet24NUMERONF.AsString <> '000000000' then
  begin
    // Atenção a rotina abaixo altera a quantidade no estoque
    Form7.ibDataSet23.DisableControls;
    Form7.ibDataSet23.First;
    while not Form7.ibDataSet23.Eof do
    begin
      // Procura o produto no estoque
      Screen.Cursor := crHourGlass; // Cursor de Aguardo

      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      //
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
      //
      if Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
      begin
        //
        if Form7.ibDataSet23SINCRONIA.AsFloat = Form7.ibDataSet23QUANTIDADE.AsFloat then    // Resolvi este problema as 4 da madrugada no NoteBook em casa
        begin
          try
            if Pos('=',UpperCase(Form7.ibDataSet14INTEGRACAO.AsString)) = 0 then
            begin
              Form7.ibDataset4.Edit;
              Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat - Form7.ibDataSet23QUANTIDADE.AsFloat; // Desconta a quantidade na compra
              Form7.ibDataSet4.Post;
            end;

            Form7.sModulo := 'NAO';
            Form7.ibDataSet23.Edit;
            Form7.ibDataSet23SINCRONIA.AsFloat := 0;                                      // Resolvi este problema as 4 da madrugada no NoteBook em casa
          except end;
        end;
      end;
      Form7.ibDataSet23.Next;
    end;
  end;

  Form7.sModulo := 'COMPRA';

  Form7.ibDataSet4.Close;                                                //
  Form7.ibDataSet4.Selectsql.Clear;                                      // relacionado
  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where Coalesce(ST,'+QuotedStr('')+')<>'+QuotedStr('SVC')+' order by upper(DESCRICAO)');  //
  Form7.ibDataSet4.Open;

  Form7.ibDataSet23.EnableControls;

  if Form7.ibDataSet24FRETE12.AsString = '0' then
    edFretePorConta.Text := '0-Remetente'
  else
    if Form7.ibDataSet24FRETE12.AsString = '1' then
      edFretePorConta.Text := '1-Destinatário'
    else
      if Form7.ibDataSet24FRETE12.AsString = '2' then
        edFretePorConta.Text := '2-Terceiros'
      else
        if Form7.ibDataSet24FRETE12.AsString = '3' then
          edFretePorConta.Text := '3-Próprio remetente'
        else
          if Form7.ibDataSet24FRETE12.AsString = '4' then
            edFretePorConta.Text := '4-Próprio destinatário'
          else
            if Form7.ibDataSet24FRETE12.AsString = '9' then
              edFretePorConta.Text := '9-Sem frete'
            else
              edFretePorConta.Text := '';

  Form12.Edit4.Visible := True;

  Form24.Button1Click(Sender);

  Screen.Cursor := crDefault; // Cursor de Aguardo

  // Atenção a rotina acima altera a quantidade no estoque
  sDataAntiga := DateToStrInvertida(Form7.ibDataSet24EMISSAO.AsDateTime);

  Form7.bDescontaICMSDeso := TestaNotaDescontaICMSDesonerado;  
end;

procedure TForm24.FormActivate(Sender: TObject);
var
  cIndPres: String;
begin
  // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria);
  Form24.Top     := Form7.Top;
  Form24.Left    := Form7.Left;
  Form24.Width   := Form7.Width;
  Form24.Height  := Form7.Height;

  edFretePorConta.Top := SMALL_DBEdit27.Top; // Sandro Silva 2023-08-04

  if Form24.Tag = 1 then
  begin
    Form24.Tag := 0;
    Edit7.OnChange := nil;
    Edit8.OnChange := nil;
    Edit9.OnChange := nil;
    try
      try
        if Form7.ibDataSet24FINNFE.AsString = '1' then
        begin
          Edit7.Text := '1-Normal';
        end else
        begin
          if Form7.ibDataSet24FINNFE.AsString = '2' then
          begin
            Edit7.Text := '2-Complementar';
            //Form12.SMALL_DBEdit16.ReadOnly := False;
            edtTotalNota.ReadOnly := False;
          end else
          begin
            if Form7.ibDataSet24FINNFE.AsString = '3' then
            begin
              Edit7.Text := '3-de Ajuste';
            end else
            begin
              if Form7.ibDataSet24FINNFE.AsString = '4' then
              begin
                Edit7.Text := '4-Devolução de mercadoria';
              end else
              begin
                Edit7.Text := '1-Normal';
              end;
            end;
          end;
        end;
      except
      end;

      // Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final
      try
        if Form7.ibDataSet24INDFINAL.AsString = '1' then
        begin
          Edit8.Text := '1-Consumidor Final';
        end else
        begin
          Edit8.Text := '0-Normal';
        end;
      except
      end;

      // Indicador de presença do comprador no estabelecimento comercial no momento da operação:
      //  0=Não se aplica (por exemplo, para a Nota Fiscal complementar ou de ajuste)
      //  1=Operação presencial
      //  2=Operação não presencial, pela Internet
      //  3=Operação não presencial, Teleatendimento
      //  4=NFC-e em operação com entrega em domicílio
      //  9=Operação não presencial, outros.
      try
        cIndPres := '1';

        if AllTrim(Form7.ibDataSet24INDPRES.AsString) = '' then
        begin
          try
            Form7.ibQuery1.Close;
            Form7.ibQuery1.SQL.Clear;
            Form7.ibQuery1.SQL.Add('select first 1 INDPRES from VENDAS where coalesce(INDPRES,''X'')<>''X'' order by NUMERONF desc');
            Form7.ibQuery1.Open;

            cIndPres := Form7.ibQuery1.FieldByName('INDPRES').AsString;
          except end;
        end
        else
          cIndPres := Form7.ibDataSet24INDPRES.AsString;

        if cIndPres = '0' then
        begin
          Edit9.Text := '0=Não se aplica';
        end else
        begin
          if cIndPres = '1' then
          begin
            Edit9.Text := '1=Operação presencial';
          end else
          begin
            if cIndPres = '2' then
            begin
              Edit9.Text := '2=Operação não presencial, pela Internet';
            end else
            begin
              if cIndPres = '3' then
              begin
                Edit9.Text := '3=Operação não presencial, Teleatendimento';
              end else
              begin
                if cIndPres = '4' then
                begin
                  Edit9.Text := '4=NFC-e em operação com entrega em domicílio';
                end else
                begin
                  if cIndPres = '9' then
                  begin
                    Edit9.Text := '9=Operação não presencial, outros';
                  end else
                  begin
                    //
                    Edit9.Text := '1=Operação presencial';
                    //
                  end;
                end;
              end;
            end;
          end;
        end;
      except end;
    finally
      Edit7.OnChange := Edit7Change;
      Edit8.OnChange := Edit8Change;
      Edit9.OnChange := Edit9Change;
    end;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Close;
    Form7.ibDataSet14.SelectSQL.Clear;
    Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''1'' or  SubString(CFOP from 1 for 1) = ''2'' or SubString(CFOP from 1 for 1) = ''3''  order by upper(NOME)');
    Form7.ibDataSet14.Open;
    Form7.ibDataSet14.EnableControls;

    if Alltrim(Form7.ibDAtaSet24OPERACAO.AsString) <> '' then
    begin
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Locate('NOME',AllTrim(Form7.ibDAtaSet24OPERACAO.AsString),[]);
      Form7.ibDataSet14.EnableControls;
    end;

    Form7.ibDataSet99.Close;
    Form7.ibDataSet99.SelectSQL.Clear;
    Form7.ibDataSet99.SelectSQL.Add('select * FROM ICM where ((CFOP like '+QuotedStr('1%')+') or (CFOP like '+QuotedStr('2%')+') or (CFOP like '+QuotedStr('3%')+')) and Upper(NOME) like '+QuotedStr('%'+UpperCase(SMALL_DBEdit40.Text)+'%')+' order by upper(NOME)');
    Form7.ibDataSet99.Open;

    Form7.ibDataSet99.EnableControls;
    Form7.ibDataSet14.EnableControls;
    //
    Form24.Image5.Picture := nil;
    Form24.Image5.Visible := False;
    Form24.Panel9.Visible := False;

    // Form Ativate
    Form7.ibDataSet14.EnableControls;
    Form7.ibDataSet24.EnableControls;
    Form7.ibDataSet23.EnableControls;
    Form7.ibDataSet18.EnableControls;
    Form7.ibDataSet8.EnableControls;
    Form7.ibDataSet2.EnableControls;

    if Form7.ibDataSet24NUMERONF.AsString = '000000000' then
    begin
      Edit2.Text := '000000000/000';
      Edit2.ReadOnly := False;
      Edit2.SetFocus;
      Edit2.SelectAll;
    end else
    begin
      Edit2.Text := Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet24NUMERONF.AsString,10,3);
      Edit2.ReadOnly := True;
      SMALL_DBEdit40.SetFocus;
    end;

    // FOTO
    Panel9.Top    := Form24.pnlNota.Top;
    Panel9.Left   := pnlNota.Left + pnlNota.Width + 10;

    Panel9.Width  := 300; // Dailon Parisotto 2023-11-16 (Ficar igual rotina VENDA)
    Panel9.Height := Panel9.Width;

    Panel5.Top    := Panel9.Top + Panel9.Height + 10;
    Panel5.Left   := Panel9.Left;
    Panel5.Width  := 1050  - Panel5.Left - 20;
    Panel5.Height := pnlNota.Height - (Panel5.Top - pnlNota.Top);

    Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;
  end;

  //Mauricio Parizotto 2023-06-06
  Form7.HintTotalNotaCompra;
end;

procedure TForm24.Incluirnovoitemnoestoque1Click(Sender: TObject);
begin
  if Form1.imgEstoque.Visible then
  begin
    //
    if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset4.Post;
    if (Form7.ibDataset23.State in ([dsEdit, dsInsert])) then
      Form7.ibDataset23.Post;
    //
    Form7.ibDataSet24.DisableControls;
    Form7.ibDataSet23.DisableControls;
    //
    try
      Form1.bFechaTudo           := False;
      Form1.imgEstoqueClick(Sender);
      Form7.Close;
      Form7.iKey := 0;
      Form7.ibDataSet4.Append; // Incluir novo item pela nota de compra
      Form10.ShowModal;
      //
      Form7.sModulo := 'COMPRA';
      Form7.sTitulo := 'Notas fiscais de entrada (compras)';
      Form7.sRPS := 'N';
      Form7.Show;
      
      if Form24.DBGrid1.CanFocus then
        Form24.DBGrid1.SetFocus;
      Form7.ibDataSet23.Last;
    except
    end;
    
    Form1.bFechaTudo           := True;

    Form7.sModulo := 'COMPRA';
    Form7.sTitulo := 'Notas fiscais de entrada (compras)';
    Form7.sRPS := 'N';

    Form7.ibDataSet23.Close;
    Form7.ibDataSet23.DataSource  := Form7.DataSource24;
    Form7.ibDataSet23.Selectsql.Clear;
    Form7.ibDataSet23.Selectsql.Add('select * from ITENS002 where NUMERONF=:NUMERONF and FORNECEDOR=:FORNECEDOR');
    Form7.ibDataSet23.Open;

    Grid_Compra(True);

    Form7.ibDataSet24.EnableControls;
    Form7.ibDataSet23.EnableControls;
  end;

  // Altera o Grid de mercadorias para mostrar na NF
  Grid_Compra(True);
end;

procedure TForm24.Incluirnovocliente1Click(Sender: TObject);
var
  sTitulo : String;
begin
  if Form1.imgEstoque.Visible then
  begin
    sTitulo := Form7.sTitulo;
    Form7.ibDataSet24.DisableControls;
    Form7.ibDataSet23.DisableControls;
    try
      Form1.bFechaTudo           := False;
      Form1.imgCliForClick(Sender);
      Form7.ibDataSet2.Append;
      Form7.Close;
      Form10.ShowModal;

      Form7.ibDataSet24FORNECEDOR.AsString := Form7.IBDataSet2NOME.AsString;

      Form7.sModulo := 'COMPRA';
      Form7.sTitulo := sTitulo;
      Form7.sRPS := 'N';

      Form7.Show;

      if Form24.DBGrid1.CanFocus then
        Form24.DBGrid1.SetFocus;
      Form7.ibDataSet23.Last;
    except
    end;

    Form1.bFechaTudo           := True;
    Form7.ibDataSet24.EnableControls;
    Form7.ibDataSet23.EnableControls;
  end;

  // Altera o Grid de mercadorias para mostrar na NF
  Grid_Compra(True);
end;

procedure TForm24.Label64Click(Sender: TObject);
begin
  Form7.ibDataSet24.Edit;
  Form7.ibDataSet24MODELO.AsString := Right('00'+Copy(Form1.Small_InputForm('Modelo da Nota Fiscal','',Form7.ibDataSet24MODELO.AsString)+'  ',1,2),2);
  Label64.Caption := 'Mod: '+Form7.ibDataSet24MODELO.AsString;
end;

procedure TForm24.Edit2Exit(Sender: TObject);
begin
  try
    if Edit2.Text <> '000000000/000' then
    begin
      if Pos('/',Edit2.Text) = 0 then
      begin
        Edit2.Text := StrZero(StrToFloat(LimpaNumero('0'+Edit2.Text)),9,0) + '/001';
      end else
      begin
        Edit2.Text := StrZero(StrToFloat(LimpaNumero('0'+Copy(Edit2.Text,1,Pos('/',Edit2.Text)))),9,0) +Copy(Edit2.Text+'   ',Pos('/',Edit2.Text),4);
      end;
    end;

    if not (Form7.ibDataset24.State in ([dsEdit, dsInsert])) then Form7.ibDataset24.Edit;
    Form7.ibDataSet24NUMERONF.AsString := StrTran(Edit2.Text,'/','');

    Form7.IBDataSet99.Close;
    Form7.IBDataSet99.SelectSQL.Clear;
    Form7.IBDataSet99.SelectSQL.Add('select * from COMPRAS where NUMERONF='+QuotedStr(Form7.ibDataSet24NUMERONF.AsString));

    sDataAntiga := DateToStrInvertida(Form7.ibDataSet24EMISSAO.AsDateTime);

    if Form7.ibDataSet24NUMERONF.AsString = '000000000000' then
    begin
      Edit2.Text := '000000000/000';
      Edit2.ReadOnly := False;
      Edit2.SetFocus;
      Edit2.SelectAll;
    end else
    begin
      Edit2.Text := Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet24NUMERONF.AsString,10,3);
      Edit2.ReadOnly := True;
      SMALL_DBEdit40.SetFocus;
    end;
  except
    Edit2.Text := '000000000/000';
    Edit2.ReadOnly := False;
    Edit2.SetFocus;
    Edit2.SelectAll;
  end;
end;

procedure TForm24.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_DOWN then
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,0,0);
  if Key = VK_UP   then
    if dBgrid2.Visible = True then
      dBgrid2.SetFocus
    else
      Perform(Wm_NextDlgCtl,1,0);
  Key := VK_SHIFT;
end;

procedure TForm24.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  Qtd : integer;
begin
  {Mauricio Parizotto 2023-10-18 Inicio
  //
  if Field.Name = 'ibDataSet23DESCRICAO' then
  begin
    //
    if Form7.ibDataSet4CODIGO.AsString <> Form7.ibDataSet23CODIGO.AsString then
    begin
      if not dBgrid3.Visible then
      begin
        Form7.ibDataSet4.DisableControls;
        Form7.ibDataSet4.Close;
        Form7.ibDataSet4.Selectsql.Clear;
        Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+' ');
        Form7.ibDataSet4.Open;
        Form7.ibDataSet4.EnableControls;
      end;
    end;
    //
    if Form7.ibDataSet4ALTERADO.AsString = '3' then
    begin
      dbGrid1.Canvas.StretchDraw(Rect,Form24.ImageNovo.Picture.Graphic);   // Item novo
      dbGrid1.Canvas.TextOut(Rect.Left+22,Rect.Top+2,Field.AsString);
    end;
    //
    //
  end;
  //
  //
  }

  //Verifica se o produto é novo
  if Field.Name = 'ibDataSet23DESCRICAO' then
  begin
    Qtd := ExecutaComandoEscalar(Form7.ibDataSet4.Transaction,
                            ' Select count(1) '+
                            ' From ESTOQUE'+
                            ' Where CODIGO='+QuotedStr(Form7.ibDataSet23CODIGO.AsString)+
                            '   and ALTERADO = 3 ');

    if Qtd > 0 then
    begin
      dbGrid1.Canvas.StretchDraw(Rect,Form24.ImageNovo.Picture.Graphic);
      dbGrid1.Canvas.TextOut(Rect.Left+22,Rect.Top+2,Field.AsString);
    end;
  end;

  {Mauricio Parizotto 2023-10-18 Fim}
end;

procedure TForm24.edtAlteraEntradaChange(Sender: TObject);
begin
  if edtAlteraEntrada.Text <> EmptyStr then
  begin
    Form24.ibDataSet44.DisableControls;
    Form24.ibDataSet44.Close;
    Form24.ibDataSet44.SelectSQL.Clear;
    Form24.ibDataSet44.SelectSQL.Add('select *');
    Form24.ibDataSet44.SelectSQL.Add('from ESTOQUE');
    Form24.ibDataSet44.SelectSQL.Add('where');
    Form24.ibDataSet44.SelectSQL.Add(RetornarWhereAtivoEstoque);
    Form24.ibDataSet44.SelectSQL.Add('AND ' + RetornarWhereProdDiferenteItemPrincipal);

    if Limpanumero(edtAlteraEntrada.Text) <> edtAlteraEntrada.Text then
    begin
      Form24.ibDataSet44.SelectSQL.Add('AND (upper(DESCRICAO) like '+QuotedStr('%'+UpperCase(edtAlteraEntrada.Text)+'%')+')');
      Form24.ibDataSet44.SelectSQL.Add('order by upper(DESCRICAO)');
    end else
    begin
      if Length(Limpanumero(edtAlteraEntrada.Text)) <= 5 then
        Form24.ibDataSet44.SelectSQL.Add('AND (CODIGO='+QuotedStr(StrZero( StrToInt64(Limpanumero(edtAlteraEntrada.Text)),5,0))+')')
      else
        Form24.ibDataSet44.SelectSQL.Add('AND (REFERENCIA='+QuotedStr(Limpanumero(edtAlteraEntrada.Text))+')');
    end;
    
    Form24.ibDataSet44.Open;
    Form24.ibDataSet44.First;
    Form24.ibDataSet44.EnableControls;
  end;
end;

function TForm24.RetornarWhereProdDiferenteItemPrincipal: String;
begin
  Result := '(DESCRICAO<>'+QuotedStr(Form7.ibDataSet23DESCRICAO.AsString)+')';
end;

function TForm24.RetornarWhereAtivoEstoque: String;
begin
  Result := '((COALESCE(ATIVO,0)=0) OR ((COALESCE(ATIVO,0)=1) AND (TIPO_ITEM=''01'')))';
end;

procedure TForm24.edtAlteraEntradaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then
    if dBgrid33.CanFocus then
      dBgrid33.SetFocus;
  if Key = VK_ESCAPE then
    Form24.Button2Click(Sender);
end;

procedure TForm24.Button2Click(Sender: TObject);
begin
  if lblAlteraEntrada.Visible = False then
  begin
    ibDataSet44.Close;
    lblAlteraEntrada.Top     := Label5.Top + 40;
    edtAlteraEntrada.Top    := SMALL_DBEdit45.Top + 40;
    dbGrid33.Top    := edtAlteraEntrada.Top + 20;

    dbGrid33.Height := Panel5.Height - dbGrid33.Top - 15;

    lblAlteraEntrada.Visible    := True;
    edtAlteraEntrada.Visible    := True;
    dbGrid33.Visible            := True;

    if edtAlteraEntrada.CanFocus then
      edtAlteraEntrada.SetFocus;
  end else
  begin
    lblAlteraEntrada.Visible    := False;
    edtAlteraEntrada.Visible      := False;
    dbGrid33.Visible   := False;
    
    Form24.DBGrid1.SetFocus;
    DbGrid1.SelectedIndex := 0;
    DbGrid1.SelectedIndex := 1;
  end;
end;

procedure TForm24.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(13) then
  begin
    if Form7.ibDataSet4DESCRICAO.AsString <> '' then
    begin
      Form7.ibDataSet23.Edit;

      if AllTrim(Form7.ibDataSet23DESCRICAO.AsString) <> AllTrim(Form7.ibDataSet4DESCRICAO.AsString) then
      begin
        Form7.ibDataSet23QUANTIDADE.AsFloat := 0;
      end;

      Form1.bFlag := True;
      Form7.ibDataSet23DESCRICAO.AsString := Form7.ibDataSet4DESCRICAO.AsString;
      
      dBGrid3.Visible := False;
      dbGrid1.SelectedIndex := 1;
      dbGrid1.SetFocus;
    end;
  end;
end;

procedure TForm24.DBGrid3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MostraFoto(True);
  Form7.ibDataSet4.EnableControls;
end;

procedure TForm24.DBGrid33DblClick(Sender: TObject);
var
  bButton: Integer;
  scodigo: String;
begin
  if Form7.ibDataSet4DESCRICAO.AsString <> Form7.ibDataSet23DESCRICAO.AsString then
  begin
    Form7.ibDataSet4.Close;                                                //
    Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
    Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet23DESCRICAO.AsString)+' ');  //
    Form7.ibDataSet4.Open;
  end;

  if Form7.ibDataSet4DESCRICAO.AsString <> '' then
  begin
    bButton := Application.MessageBox(Pchar(
    'Alterar do item: '+chr(10)+chr(10)+Form7.ibDataSet4DESCRICAO.AsString+chr(10)+chr(10)+
    'Para o item: '+chr(10)+chr(10)+Form24.ibDataSet44DESCRICAO.AsString+Chr(10))
    ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
    //
    if bButton = IDYES then
    begin
      try
        Form7.IBDataSet6.Append;
        Form7.IBDataSet6CODIGO.AsString       := Form24.ibDataSet44CODIGO.AsString;
        Form7.IBDataSet6EAN.AsString          := Form7.ibDataSet23EAN_ORIGINAL.AsString;
        Form7.IBDataSet6FORNECEDOR.AsString   := Form7.ibDataSet24FORNECEDOR.AsString;
        Form7.IBDataSet6.Post;
      except
        on E: Exception do
          //ShowMessage('Erro 2133: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
          MensagemSistema('Erro 2133: '+chr(10)+E.Message,msgErro);
      end;

      sCodigo := Form7.ibDataSet4CODIGO.AsString;
      
      if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then Form7.ibDataset4.Post;
      if (Form7.ibDataset23.State in ([dsEdit, dsInsert])) then Form7.ibDataset23.Post;
      //
      Form1.ibQuery1.Close;
      Form1.ibQuery1.Sql.Clear;
      Form1.ibQuery1.Sql.Add('update ITENS002 set DESCRICAO='+quotedStr(Form24.ibDataSet44DESCRICAO.AsString)+
                             ', CODIGO='+quotedStr(Form24.ibDataSet44CODIGO.AsString)+
                             ', SINCRONIA=0'+
                             ' where NUMERONF='+quotedStr(Form7.ibDataSet23NUMERONF.AsString)+
                             ' and FORNECEDOR='+quotedStr(Form7.ibDataSet23FORNECEDOR.AsString)+
                             ' and DESCRICAO='+quotedStr(Form7.ibDataSet4DESCRICAO.AsString)+' ');
      Form1.ibQuery1.Open;

      Form1.bFlag := False;

      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(sCodigo)+' ');
      Form7.ibDataSet4.Open;

      if sCodigo = Form7.ibDataSet4CODIGO.AsString then
      begin
        if Form7.ibDataSet4ALTERADO.AsString = '3' then
        begin
          Form7.ibDataSet4.Delete;
        end;
      end;

      Form7.ibDataSet23.Close;
      Form7.ibDataSet23.DataSource  := Form7.DataSource24;
      Form7.ibDataSet23.Selectsql.Clear;
      Form7.ibDataSet23.Selectsql.Add('select * from ITENS002 where NUMERONF=:NUMERONF and FORNECEDOR=:FORNECEDOR');
      Form7.ibDataSet23.Open;

      Form7.ibDataSet4.Close;                                                //
      Form7.ibDataSet4.Selectsql.Clear;                                      // receber Relacionado
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form24.ibDataSet44CODIGO.AsString)+' ');  //
      Form7.ibDataSet4.Open;
      
      Form24.edtAlteraEntrada.Text :=  '';
      
      Form7.ibDataSet23.Locate('DESCRICAO',Form24.ibDataSet44DESCRICAO.AsString,[]);
      Form7.bMudei := True;
    end else
    begin
      Form24.edtAlteraEntrada.Text :=  '';
    end;

    lblAlteraEntrada.Visible   := False;
    edtAlteraEntrada.Visible   := False;
    dbGrid33.Visible           := False;
  end;

  Form24.DBGrid1.SetFocus;
  DbGrid1.SelectedIndex := 0;
  DbGrid1.SelectedIndex := 1;
end;

procedure TForm24.SMALL_DBEdit42KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Form7.ibDataSet23.Eof then
    Form24.SMALL_DBEdit22.SetFocus;
end;

procedure TForm24.SMALL_DBEdit27Exit(Sender: TObject);
begin
  if (Form7.ibDataSet24FRETE12.AsString <> '0')
  and (Form7.ibDataSet24FRETE12.AsString <> '1')
  and (Form7.ibDataSet24FRETE12.AsString <> '2')
  and (Form7.ibDataSet24FRETE12.AsString <> '3')
  and (Form7.ibDataSet24FRETE12.AsString <> '4')
  and (Form7.ibDataSet24FRETE12.AsString <> '9') then
  begin
    {
    Application.MessageBox('Valores válidos:' + Chr(10) +
                          Chr(10) +
                          '0 - Contratação do Frete por conta do Remetente (CIF);' + Chr(10) +
                          '1 - Contratação do Frete por conta do destinatário/remetente (FOB);' + Chr(10) +
                          '2 - Contratação do Frete por conta de terceiros;' + Chr(10) +
                          '3 - Transporte próprio por conta do remetente;' + Chr(10) +
                          '4 - Transporte próprio por conta do destinatário;' + Chr(10) +
                          '9 - Sem Ocorrência de transporte.'
              ,'Valor inválido',mb_IconError+mb_Ok);
    Mauricio Parizotto 2023-10-25}

    MensagemSistema('Valores válidos:' + Chr(10) +
                    Chr(10) +
                    '0 - Contratação do Frete por conta do Remetente (CIF);' + Chr(10) +
                    '1 - Contratação do Frete por conta do destinatário/remetente (FOB);' + Chr(10) +
                    '2 - Contratação do Frete por conta de terceiros;' + Chr(10) +
                    '3 - Transporte próprio por conta do remetente;' + Chr(10) +
                    '4 - Transporte próprio por conta do destinatário;' + Chr(10) +
                    '9 - Sem Ocorrência de transporte.'
                    ,msgErro);


    Form7.ibDataSet24FRETE12.AsString := '0';
  end;

  if Form7.ibDataSet24FRETE12.AsString = '0' then
    edFretePorConta.Text := '0-Remetente'
  else if Form7.ibDataSet24FRETE12.AsString = '1' then
    edFretePorConta.Text := '1-Destinatário'
  else if Form7.ibDataSet24FRETE12.AsString = '2' then
    edFretePorConta.Text := '2-Terceiros'
  else if Form7.ibDataSet24FRETE12.AsString = '3' then
    edFretePorConta.Text := '3-Próprio remetente'
  else if Form7.ibDataSet24FRETE12.AsString = '4' then
    edFretePorConta.Text := '4-Próprio destinatário'
  else if Form7.ibDataSet24FRETE12.AsString = '9' then
    edFretePorConta.Text := '9-Sem frete'
  else
    edFretePorConta.Text := '';

  Form24.edFretePorConta.Visible := True;
  AtualizaTotalDaNota; // Sandro Silva 2023-08-03
end;

procedure TForm24.edFretePorContaEnter(Sender: TObject);
begin
  Form24.SMALL_DBEdit27.SetFocus;
  Form24.edFretePorConta.Visible := False;
end;

procedure TForm24.Label_fecha_0Click(Sender: TObject);
begin
  Form24.Close;
end;

procedure TForm24.Edit7Click(Sender: TObject);
begin
  //
  Edit7.Text := LimpaNumero(Form1.Small_InputForm('Finalidade da NFe','Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)',LimpaNumero(Edit7.Text)));
  //
  if (LimpaNumero(Edit7.Text) = '1') then
  begin
    Edit7.Text := '1-Normal';
  end else
  begin
    if (LimpaNumero(Edit7.Text) = '2') then
    begin
      Edit7.Text := '2-Complementar';
    end else
    begin
      if (LimpaNumero(Edit7.Text) = '3') then
      begin
        Edit7.Text := '3-de Ajuste';
      end else
      begin
        if (LimpaNumero(Edit7.Text) = '4') then
        begin
          Edit7.Text := '4-Devolução de mercadoria';
        end else
        begin
          Edit7.Text := '1-Normal';
        end;
      end;
    end;
  end;
  //
  if Form7.ibDataSet24FINNFE.AsString   <> LimpaNumero(Edit7.Text) then
    Form7.ibDataSet24FINNFE.AsString   := LimpaNumero(Edit7.Text);
  //
  try
    Form24.SMALL_DBEdit40.SetFocus;
  except
  end;
  //
  // Finalidade da NFe (1-Normal, 2-Complementar, 3-de Ajuste, 4-Devolução de mercadoria)
  //
end;

procedure TForm24.Edit8Click(Sender: TObject);
begin
  //
  Edit8.Text := LimpaNumero(Form1.Small_InputForm('Indicador de operação', 'Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final)', LimpaNumero(Edit8.Text)));
  //
  if (LimpaNumero(Edit8.Text) = '1') then
  begin
    Edit8.Text := '1-Consumidor Final';
  end else
  begin
    Edit8.Text := '0-Normal';
  end;
  //
  if Form7.ibDataSet24INDFINAL.AsString <> LimpaNumero(Edit8.Text) then
    Form7.ibDataSet24INDFINAL.AsString := LimpaNumero(Edit8.Text);
  //
  try
    Form24.SMALL_DBEdit40.SetFocus;
  except
  end;
  //
  // Indicador de operação com Consumidor Final (0-Normal, 1-Consumidor Final)
  //
end;

procedure TForm24.Edit9Click(Sender: TObject);
begin
  //
  Edit9.Text := LimpaNumero(Form1.Small_InputForm('Indicador de presença','Indicador de presença do comprador no estabelecimento comercial no momento da operação:'+chr(10)+chr(10)+
                '0=Não se aplica (por exemplo, para a Nota Fiscal complementar ou de ajuste);'+chr(10)+
                '1=Operação presencial;'+chr(10)+
                '2=Operação não presencial, pela Internet;'+chr(10)+
                '3=Operação não presencial, Teleatendimento;'+chr(10)+
                '4=NFC-e em operação com entrega em domicílio;'+chr(10)+
                '9=Operação não presencial, outros.',LimpaNumero(Edit9.Text)));
  //
  if (LimpaNumero(Edit9.Text) = '0') then
  begin
    Edit9.Text := '0=Não se aplica';
  end else
  begin
    if (LimpaNumero(Edit9.Text) = '1') then
    begin
      Edit9.Text := '1=Operação presencial';
    end else
    begin
      if (LimpaNumero(Edit9.Text) = '2') then
      begin
        Edit9.Text := '2=Operação não presencial, pela Internet';
      end else
      begin
        if (LimpaNumero(Edit9.Text) = '3') then
        begin
          Edit9.Text := '3=Operação não presencial, Teleatendimento';
        end else
        begin
          if (LimpaNumero(Edit9.Text) = '4') then
          begin
            Edit9.Text := '4=NFC-e em operação com entrega em domicílio';
          end else
          begin
            Edit9.Text := '9=Operação não presencial, outros';
          end;
        end;
      end;
    end;
  end;
  //
  if Form7.ibDataSet24INDPRES.AsString  <> LimpaNumero(Edit9.Text) then
    Form7.ibDataSet24INDPRES.AsString  := LimpaNumero(Edit9.Text);
  //
  try
    Form24.SMALL_DBEdit40.SetFocus;
  except end;
  //
  // Indicador de presença do comprador no estabelecimento comercial no momento da operação
  //
end;

procedure TForm24.SMALL_DBEdit45Change(Sender: TObject);
var
  I : Integer;
begin
  if lblAlteraEntrada.Visible then // Simula o click para esconder o grid e fechar a consulta.
    Button2Click(Self);
  try
    if Form7.sModulo = 'COMPRA' then
    begin
      if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') and (Form7.ibDataSet4.Active) then
      begin
        ComboBox12.Items.Clear;
        ComboBox13.Items.Clear;

        Form7.IBDataSet49.Close;
        Form7.IBDataSet49.SelectSQL.Clear;
        Form7.IBDataSet49.SelectSQL.Add('select * from MEDIDA order by SIGLA');
        Form7.IBDataSet49.Open;
        
        while not Form7.IBDataSet49.Eof do
        begin
          ComboBox12.Items.Add(Form7.IBDataSet49SIGLA.AsString);
          ComboBox13.Items.Add(Form7.IBDataSet49SIGLA.AsString);
          Form7.IBDataSet49.Next;
        end;

        if AllTrim(Form7.IbDataSet4MEDIDAE.AsString) = '' then
        begin
          if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
            Form7.ibDataset4.Edit;
          if AllTrim(Form7.IbDataSet4MEDIDA.AsString) <> '' then
            Form7.ibDataSet4MEDIDAE.AsString := Form7.ibDataSet4MEDIDA.AsString else
          begin
            Form7.ibDataSet4MEDIDAE.AsString := 'UND';
            Form7.ibDataSet4MEDIDA.AsString := 'UND';
          end;
        end;

        for I := 0 to ComboBox12.Items.Count do
        begin
          if Form7.ibDataSet4MEDIDAE.AsString = ComboBox12.Items[I] then
          begin
            ComboBox12.ItemIndex := I;
          end;

          if Form7.ibDataSet4MEDIDA.AsString = ComboBox13.Items[I] then
          begin
            ComboBox13.ItemIndex := I;
          end;
        end;

        if Form7.IbDataSet4FATORC.AsFloat <= 0 then
        begin
          if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
            Form7.ibDataset4.Edit;
          Form7.ibDataSet4FATORC.AsFloat := 1;
        end;

        Exemplo(True);
      end else
      begin
        Form24.Label89.Caption := '';
      end;
    end;
  except
    on E: Exception do
      //ShowMessage('Erro 8 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 8 FC: '+chr(10)+E.Message,msgErro);
  end;
end;

procedure TForm24.ComboBox12Change(Sender: TObject);
begin
  try
    if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      Form7.ibDataSet4MEDIDAE.AsString :=  ComboBox12.Text;
      Exemplo(True);
    end else
    begin
      Form24.Label89.Caption := '';
    end;
  except
    on E: Exception do
      //ShowMessage('Erro 6 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 6 FC: '+chr(10)+E.Message,msgErro);
  end;

end;

procedure TForm24.ComboBox13Change(Sender: TObject);
begin
  try
    if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') then
    begin
      if not (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Edit;
      Form7.ibDataSet4MEDIDA.AsString  :=  ComboBox13.Text;
      Exemplo(True);
    end else
    begin
      Form24.Label89.Caption := '';
    end;
  except
    on E: Exception do
      //ShowMessage('Erro 3 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 3 FC: '+chr(10)+E.Message,msgErro);
  end;
end;

procedure TForm24.ComboBox12Exit(Sender: TObject);
begin
  try
    if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') then
    begin
      if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Post;
      Form7.ibDataset4.Edit;
      Exemplo(True);
    end else
    begin
      Form24.Label89.Caption := '';
    end;
  except
    on E: Exception do
      //ShowMessage('Erro 1 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 1 FC: '+chr(10)+E.Message,msgErro);
  end;
end;


procedure TForm24.SMALL_DBEdit64Exit(Sender: TObject);
begin
  try
    if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') then
    begin
      if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Post;
      Form7.ibDataset4.Edit;
      if Form7.ibDataSet4FATORC.AsFloat = 0 then
        Form7.ibDataSet4FATORC.AsFloat :=1;
      Exemplo(True);
      //
      try
        if not (Form7.ibDataset23.State in ([dsEdit, dsInsert])) then Form7.ibDataset23.Edit;
        if (Form7.ibDataSet4FATORC.AsFloat = 0) or (Form7.ibDataSet4FATORC.AsFloat = 1) then
        begin
          Form7.ibDataSet23QUANTIDADE.AsFloat := Form7.ibDataSet23QTD_ORIGINAL.AsFloat;
          Form7.ibDataSet23UNITARIO.AsFloat   := Form7.ibDataSet23UNITARIO_O.AsFloat;
        end else
        begin
          Form7.ibDataSet23QUANTIDADE.AsFloat := (Form7.ibDataSet23QTD_ORIGINAL.AsFloat * Form7.ibDataSet4FATORC.AsFloat);
          Form7.ibDataSet23UNITARIO.AsFloat   := (Form7.ibDataSet23UNITARIO_O.AsFloat / Form7.ibDataSet4FATORC.AsFloat);
        end;
      except end;
      //
    end else
    begin
      Form24.Label89.Caption := '';
    end;
  except
    on E: Exception do
      //ShowMessage('Erro 2 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 2 FC: '+chr(10)+E.Message,msgErro);
  end;
end;

procedure TForm24.ComboBox13Exit(Sender: TObject);
begin
  try
    if (Form7.ibDataSet23CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and (AllTrim(Form7.ibDataSet23CODIGO.AsString) <> '') then
    begin
      if (Form7.ibDataset4.State in ([dsEdit, dsInsert])) then
        Form7.ibDataset4.Post;
      Form7.ibDataset4.Edit;
      Exemplo(True);
    end else
    begin
      Form24.Label89.Caption := '';
    end;

    Form1.bFlag := False;

    Form24.DBGrid1.SetFocus;

    DbGrid1.SelectedIndex := 0;
    DbGrid1.SelectedIndex := 1;
  except
    on E: Exception do
      //ShowMessage('Erro 4 FC: '+chr(10)+E.Message); Mauricio Parizotto 2023-10-25
      MensagemSistema('Erro 4 FC: '+chr(10)+E.Message,msgErro);
  end;
end;

procedure TForm24.ComboBox12KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
    HH(handle, PChar( extractFilePath(application.exeName) + 'retaguarda.chm' + '>Ajuda Small'), HH_Display_Topic, Longint(PChar('nf_compra.htm')));
  if Key = VK_RETURN then
    Perform(Wm_NextDlgCtl,0,0);
  Key := VK_SHIFT;
end;

procedure TForm24.Button1Click(Sender: TObject);
var
  Mais1Ini : tIniFile;
  iA, I : Integer;
begin
  if dBGrid1.Top <> 225 then
  begin
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');

    if Mais1Ini.ReadString('NFE','Preenchimento','Simples') = 'Simples' then
    begin
      Label15.Visible := False;
      Label16.Visible := False;
      Label17.Visible := False;
      Label18.Visible := False;
      Label19.Visible := False;
      Label20.Visible := False;
      Label21.Visible := False;
      Label45.Visible := False;
      Label46.Visible := False;
      Label47.Visible := False;
      Label48.Visible := False;

      SMALL_DBEdit6.Visible  := False;
      SMALL_DBEdit7.Visible  := False;
      SMALL_DBEdit8.Visible  := False;
      SMALL_DBEdit10.Visible := False;
      SMALL_DBEdit11.Visible := False;
      SMALL_DBEdit12.Visible := False;
      SMALL_DBEdit13.Visible := False;
      SMALL_DBEdit26.Visible  := False;
      SMALL_DBEdit31.Visible  := False;
      SMALL_DBEdit32.Visible  := False;
      SMALL_DBEdit33.Visible := False;

      dBGrid1.Top    := 225;
      dBGrid1.Height := 126;

      Label49.Top := 555;
      Label50.Top := 555;
      Label51.Top := 555;
      Label52.Top := 555;
      Label53.Top := 555;
      Label54.Top := 555;

      SMALL_DBEdit15.Top := 570;
      SMALL_DBEdit34.Top := 570;
      SMALL_DBEdit35.Top := 570;
      SMALL_DBEdit36.Top := 570;
      SMALL_DBEdit37.Top := 570;
      SMALL_DBEdit38.Top := 570;

      Label1.Top  := 595;
      DBMemo1.Top := 610;

      pnlNota.Height := 625;

      Mais1ini.Free;

      iA := Form7.Height - pnlNota.Height - Ok.Height - 60;

      if iA < 0 then
        iA := 0;

      begin
        dBGrid1.Height  := dBGrid1.Height + iA;
        pnlNota.Height  := pnlNota.Height + iA;

        for I := 0 to Form12.ComponentCount-1 do
        begin
          try
            if (Copy(TSMALL_DBEdit(Components[I]).Name,1,5) <> 'Popup')
              and (Copy(TSMALL_DBEdit(Components[I]).Name,1,5) <> 'Image')
              //Mauricio Parizotto 2023-05-31 só os componente do pnlNota
              and (TControl(Components[I]).Parent.Name = 'pnlNota')  then
            begin
              if TSMALL_DBEdit(Components[I]).Top > dBGrid1.Top then
                TSMALL_DBEdit(Components[I]).Top := TSMALL_DBEdit(Components[I]).Top + iA -75;
            end;
          except

          end;
        end;
      end;
    end;
  end;

  Ok.Top      := pnlNota.Top + pnlNota.Height + 10;
end;

procedure TForm24.SMALL_DBEdit41Click(Sender: TObject);
begin
  dBGrid2.Visible := True;
end;

procedure TForm24.SMALL_DBEdit16Exit(Sender: TObject);
begin
  try
    Form24.DBGrid1.SetFocus;
    DbGrid1.SelectedIndex := 1;
    DbGrid1.SelectedIndex := 0;
  except

  end;
end;

procedure TForm24.DefineDataSetFinalidade;
begin
  Form7.ibDataSet24FINNFE.AsString  := LimpaNumero(Edit7.Text);
end;

procedure TForm24.DefineDataSetConsumidor;
begin
  Form7.ibDataSet24INDFINAL.AsString  := LimpaNumero(Edit8.Text);
end;

procedure TForm24.DefineDataSetIndPresenca;
begin
  Form7.ibDataSet24INDPRES.AsString  := LimpaNumero(Edit9.Text);
end;

procedure TForm24.Edit7Change(Sender: TObject);
begin
  DefineDataSetInfNFe;
end;

procedure TForm24.Edit9Change(Sender: TObject);
begin
  DefineDataSetInfNFe;
end;

procedure TForm24.Edit8Change(Sender: TObject);
begin
  DefineDataSetInfNFe;
end;

procedure TForm24.DefineDataSetInfNFe;
var
  bNaoEdit: Boolean;
begin
  bNaoEdit := False;
  if Form7.ibDataSet24.State = dsBrowse then
  begin
    Form7.ibDataSet24.Edit;
    bNaoEdit := True;
  end;
  try
    DefineDataSetFinalidade;
    DefineDataSetConsumidor;
    DefineDataSetIndPresenca;
  finally
    if bNaoEdit then
      Form7.ibDataSet24.Post;
  end;
end;

procedure TForm24.SMALL_DBEdit41KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then SMALL_DBEdit28.SetFocus;
end;

procedure TForm24.SMALL_DBEdit18Exit(Sender: TObject);
begin
  AtualizaTotalDaNota;
end;

procedure TForm24.SMALL_DBEdit2Exit(Sender: TObject);
begin
  AtualizaTotalDaNota;
end;

procedure TForm24.SMALL_DBEdit23Exit(Sender: TObject);
begin
  AtualizaTotalDaNota;
end;

procedure TForm24.edFretePorContaExit(Sender: TObject);
begin
  AtualizaTotalDaNota;
end;

procedure TForm24.cbDescontaICMSDesoneradoClick(Sender: TObject);
begin
  Form7.bDescontaICMSDeso := cbDescontaICMSDesonerado.Checked;
  
  Form7.ibDataSet23AfterPost(Form7.ibDataSet23);
end;

procedure TForm24.btnPrecificarClick(Sender: TObject);
begin
  if Form7.ibDataSet24.State in ([dsEdit, dsInsert]) then
    Form7.ibDataSet24.Post;

  try
    FrmPrecificacaoProduto := TFrmPrecificacaoProduto.Create(self);
    FrmPrecificacaoProduto.ibdProdutosNota.ParamByName('NUMERONF').AsString := Form7.ibDataSet24NUMERONF.AsString;
    FrmPrecificacaoProduto.ibdProdutosNota.ParamByName('FORNECEDOR').AsString := Form7.ibDataSet24FORNECEDOR.AsString;
    FrmPrecificacaoProduto.ShowModal;
  finally
    FreeAndNil(FrmPrecificacaoProduto);
  end;
end;

end.
