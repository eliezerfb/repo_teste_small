unit converso_firebird;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBTables, DB, IBCustomDataSet, IBTable, IBDatabase,
  ExtCtrls, SmallFunc, ComCtrls, IniFiles, ShellApi;

type
  TForm1 = class(TForm)
    Table1: TTable;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBTable1: TIBTable;
    Button4: TButton;
    Button1: TButton;
    Label16: TLabel;
    Image4: TImage;
    Label15: TLabel;
    Image3: TImage;
    Label11: TLabel;
    Image5: TImage;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Image1: TImage;
    Animate1: TAnimate;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Url, Url2 : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function Converso(sArquivo:String): Boolean;
var
  I, iContador, iField : Integer;
  sAtual : String;
begin
  //
  GetDir(0,sAtual);
  // Form1.Label1.Caption := 'Procurando '+Form1.Url2+'\'+sArquivo+'.dbf'+Replicate(' ',100);
  Form1.Repaint;
  //
  if FileExists(Form1.Url2+'\'+sArquivo+'.dbf') then
  begin
    //
    Form1.Table1.Active             := False;
    Form1.Table1.DataBaseName       := Form1.Url2;
    Form1.Table1.TableType          := ttDBase;
    Form1.Table1.TableLevel         := 5;
    Form1.Table1.TableName          := sArquivo+'.dbf';
    Pack(Form1.Table1);
    Form1.Table1.Active             := True;
    //
    Form1.ibTable1.Active           := False;
    Form1.ibTable1.TableName        := sArquivo;
    Form1.ibTable1.Active           := True;
    //
    iField    := Form1.Table1.FieldDefs.Count -1;
    iContador := 0;
    Screen.Cursor := crHourGlass; // Cursor de Aguardo
    Form1.Table1.First;
    //
    while not Form1.Table1.Eof do
    begin
      //
      Form1.ibTable1.Append;
      for I := 0 to iField do
      begin
        try
          if (Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).DataType = ftFloat)  or
             (Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).DataType = ftDate)   or
             (Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).DataType = ftString) then
          begin
            Application.ProcessMessages;
            if Form1.Table1.FieldDefs[I].Name = 'PAI'       then Form1.ibTable1.FieldByname('IDENTIFICADOR1').AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString else
             if Form1.Table1.FieldDefs[I].Name = 'MAE'       then Form1.ibTable1.FieldByname('IDENTIFICADOR2').AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString else
              if Form1.Table1.FieldDefs[I].Name = 'CONJUGE'   then Form1.ibTable1.FieldByname('IDENTIFICADOR3').AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString else
               if Form1.Table1.FieldDefs[I].Name = 'NATURAL'   then Form1.ibTable1.FieldByname('IDENTIFICADOR4').AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString else
                if Form1.Table1.FieldDefs[I].Name = 'PROFISSAO' then Form1.ibTable1.FieldByname('IDENTIFICADOR5').AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString
                 else Form1.ibTable1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString := Form1.Table1.FieldByname(Form1.Table1.FieldDefs[I].Name).AsString;
          end;
        except
          Form1.Label1.Caption := 'Erro';
          Form1.Label1.Repaint;
        end;
      end;
      //
      try
        Form1.ibTable1.FieldByname('REGISTRO').AsString := StrZero(iContador,10,0);
      except end;
      //
      Form1.ibTable1.Post;
      //
      Form1.Table1.Next;
      Application.ProcessMessages;
      iContador := iContador + 1;
//      if iContador >= 10 then Form1.Table1.Last;
      Form1.Label1.Caption := 'Aguarde!'+Chr(10)+Chr(10)+'Convertendo o arquivo '+sArquivo +' registro'+chr(10)+'número '+InttoStr(iContador)+Replicate(' ',100);
      Form1.Label1.Repaint;
    end;
    //
    Screen.Cursor := crDefault; // Cursor de Aguardo
    Result := True;
    //
  end else
  begin
    Result := False;
    Form1.Label1.Caption := sArquivo+' não encontrado'+Replicate(' ',100);
    Form1.Label1.Repaint;
  end;
  //
  Form1.Label1.Repaint;
  Screen.Cursor := crDefault; // Cursor de Aguardo
  //
end;


procedure TForm1.Button4Click(Sender: TObject);
var
  SmallIni : tIniFile;
  sAtual : String;
begin
  //
  Label2.Visible := False;
  Label3.Visible := False;
  Label4.Visible := False;
  Label5.Visible := False;
  //
  RadioButton1.Visible := False;
  RadioButton2.Visible := False;
  //
  Edit1.Visible := False;
  Edit2.Visible := False;
  Edit3.Visible := False;
  //
  Form1.Repaint;
  //
  while not FileExists('smallfir.exe') do
  begin
    CopyFile('smallfir.~~1','smallfir.exe',True);
    Form1.Repaint;
    Sleep(100);
  end;
  //
  if RadioButton2.Checked then ShellExecute( 0, 'Open', 'smallfir.exe','/SP /VERYSILENT /FORCE /NOCPL /COMPONENTS="ServerComponent"','',SW_SHOW)
  else ShellExecute( 0, 'Open', 'smallfir.exe','/SP /VERYSILENT /FORCE /NOCPL /COMPONENTS="ClientComponent"','',SW_SHOW);
  //
  while FileExists('smallfir.exe') do
  begin
    DeleteFile('smallfir.exe');
    Sleep(1000);
    Form1.Repaint;
  end;
  //
  Form1.Repaint;
  //
  GetDir(0,sAtual);
  SmallIni := TIniFile.Create(sAtual+'\small.ini');
  SmallIni.WriteString('Firebird','Server IP',Edit1.Text);
  SmallIni.WriteString('Firebird','Server URL',Edit2.TExt);
  SmallIni.Free;
  //
  Url  := Edit1.Text+':'+Edit2.Text+'\small.gdb';
  Url2 := Edit3.Text;
  //
  Edit1.Visible := False;
  Edit2.Visible := False;
  Edit3.Visible := False;
  //
  Label1.Caption := 'Aguarde...!';
  //
  try
    //
//    Url := InputBox('URL','Caminho','192.168.254.4:C:\Projeto 2008\2008 Firebird\small.gdb');
    //
    IbDatabase1.DatabaseName := Url;
    IBDatabase1.Params.Clear;
    //
    IBDatabase1.Params.Add('USER "SYSDBA"');
    IBDatabase1.Params.Add('PASSWORD "masterkey"');
    IbDatabase1.CreateDatabase;
    IBTransaction1.Active := True;
    IbDatabase1.Open;
    //
    // Se não existe cria o arquivo CAIXA.DBF
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName := 'CAIXA';
    //
    ibTable1.FieldDefs.Add('DATA'     ,ftDate   ,  0, False);
    ibTable1.FieldDefs.Add('CONTA'    ,ftString ,  5, False);
    ibTable1.FieldDefs.Add('NOME'     ,ftString , 25, False);
    ibTable1.FieldDefs.Add('HISTORICO',ftString , 45, False);
    ibTable1.FieldDefs.Add('ENTRADA'  ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('SAIDA'    ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('SALDO'    ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // snx ALTERACA
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ALTERACA';
    ibTable1.FieldDefs.Add('CODIGO'    ,ftString   , 5, False);
    ibTable1.FieldDefs.Add('DESCRICAO' ,ftString   ,45, False);
    ibTable1.FieldDefs.Add('QUANTIDADE',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('MEDIDA'    ,ftString   , 3, False);
    ibTable1.FieldDefs.Add('UNITARIO'  ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('TOTAL'     ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('DATA'      ,ftDate     , 0, False);
    ibTable1.FieldDefs.Add('TIPO'      ,ftString   , 6, False);
    ibTable1.FieldDefs.Add('PEDIDO'    ,ftString   , 6, False);
    ibTable1.FieldDefs.Add('CLIFOR'    ,ftString   ,35, False);
    ibTable1.FieldDefs.Add('VENDEDOR'  ,ftString   ,30, False);
    ibTable1.FieldDefs.Add('CAIXA'     ,ftString    ,3, False);
    ibTable1.FieldDefs.Add('VALORICM'  ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUICM'  ,ftString   , 5, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString    , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo FLUXO
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'FLUXO';
    ibTable1.FieldDefs.Add('DATA'      ,ftDate   ,0, False);
    ibTable1.FieldDefs.Add('PAGAR'     ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('ACUMULADO1',ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('RECEBER'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('ACUMULADO2',ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('DIFERENCA_',ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('ACUMULADO3',ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR01'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR02'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR03'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR04'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR05'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR06'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR07'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR08'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR09'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR10'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR_1'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR_2'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR_3'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('VALOR_4'   ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('REGISTRO'  ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo GRUPO
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'GRUPO';
    ibTable1.FieldDefs.Add('NOME'    ,ftString ,25, False);
    ibTable1.CreateTable;
    //
    //snx GRADE
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'GRADE';
    //
    ibTable1.FieldDefs.Add('CODIGO'    ,ftString , 6, False);
    ibTable1.FieldDefs.Add('COR'       ,ftString , 2, False);
    ibTable1.FieldDefs.Add('TAMANHO'   ,ftString , 2, False);
    ibTable1.FieldDefs.Add('QTD'       ,ftString ,10, False);
    ibTable1.FieldDefs.Add('ENTRADAS'  ,ftString ,14, False);
    ibTable1.FieldDefs.Add('REGISTRO'  ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo SERIE
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'SERIE';
    //
    ibTable1.FieldDefs.Add('CODIGO'    ,ftString , 6, False);
    ibTable1.FieldDefs.Add('SERIAL'    ,ftString ,45, False);
    ibTable1.FieldDefs.Add('NFCOMPRA'  ,ftString , 6, False);
    ibTable1.FieldDefs.Add('NFVENDA'   ,ftString , 6, False);
    ibTable1.FieldDefs.Add('VALCOMPRA' ,ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('VALVENDA'  ,ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('DATCOMPRA' ,ftDate   , 0, False);
    ibTable1.FieldDefs.Add('DATVENDA'  ,ftDate   , 0, False);
    ibTable1.FieldDefs.Add('REGISTRO'  ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo COMPOSTO
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'COMPOSTO';
    //
    ibTable1.FieldDefs.Add('CODIGO'    ,ftString   , 5, False);
    ibTable1.FieldDefs.Add('DESCRICAO' ,ftString   ,45, False);
    ibTable1.FieldDefs.Add('QUANTIDADE',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString    ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo Usuarios
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'USUARIOS';
    //
    ibTable1.FieldDefs.Add('NUMERO'    ,ftString , 7, False);
    ibTable1.FieldDefs.Add('VENCIMENTO',ftDate   , 0, False);
    ibTable1.FieldDefs.Add('VALOR'     ,ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('PORTADOR'  ,ftString ,35, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString  ,10, False);
    //
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo NOTA
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'NOTA';
    ibTable1.FieldDefs.Add('DESCRICAO'   ,ftString , 30, False);
    ibTable1.FieldDefs.Add('TIPO'        ,ftString , 30, False);
    ibTable1.FieldDefs.Add('LINHA'       ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('COLUNA'      ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('ELEMENTO'    ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('INDICE'      ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('LAYOUT'      ,ftString ,100, False);
    ibTable1.FieldDefs.Add('SERIE'       ,ftString ,  1, False);
    ibTable1.FieldDefs.Add('REGISTRO'    ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // Configuraçao da OS
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'CONFOS';
    ibTable1.FieldDefs.Add('DESCRICAO'   ,ftString , 30, False);
    ibTable1.FieldDefs.Add('TIPO'        ,ftString , 30, False);
    ibTable1.FieldDefs.Add('LINHA'       ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('COLUNA'      ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('ELEMENTO'    ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('INDICE'      ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('LAYOUT'      ,ftString ,100, False);
    ibTable1.FieldDefs.Add('SERIE'       ,ftString ,  1, False);
    ibTable1.FieldDefs.Add('REGISTRO'    ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo Transportadoras
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'TRANSPOR';
    ibTable1.FieldDefs.Add('NOME'      ,ftString ,34, False);
    ibTable1.FieldDefs.Add('PLACA'     ,ftString ,11, False);
    ibTable1.FieldDefs.Add('ENDERECO'  ,ftString ,34, False);
    ibTable1.FieldDefs.Add('MUNICIPIO' ,ftString ,20, False);
    ibTable1.FieldDefs.Add('ESTADO'    ,ftString ,02, False);
    ibTable1.FieldDefs.Add('CGC'       ,ftString ,19, False);
    ibTable1.FieldDefs.Add('IE'        ,ftString ,15, False);
    ibTable1.FieldDefs.Add('FONE'      ,ftString ,16, False);
    ibTable1.FieldDefs.Add('UF'        ,ftString ,02, False);
    ibTable1.FieldDefs.Add('EMAIL'     ,ftString ,80, False);
    ibTable1.FieldDefs.Add('REGISTRO'  ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // Itens de Venda NF e OS não usa mais TMP usa relacionamento com OS e VENDA
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ITENS001';
    ibTable1.FieldDefs.Add('NUMERONF'     ,ftString , 7, False);    // Numero da NF
    ibTable1.FieldDefs.Add('CODIGO'       ,ftString , 5, False);    // Código 5 dígitos
    ibTable1.FieldDefs.Add('DESCRICAO'    ,ftString ,45, False);    // Descrição
    ibTable1.FieldDefs.Add('ST'           ,ftString , 3, False);    // situação tributária
    ibTable1.FieldDefs.Add('IPI'          ,ftFloat  , 0, False);    // Valor de IPI
    ibTable1.FieldDefs.Add('ICM'          ,ftFloat  , 0, False);    // Valor de ICM
    ibTable1.FieldDefs.Add('ISS'          ,ftFloat  , 0, False);    // Valor de ISS
    ibTable1.FieldDefs.Add('MEDIDA'       ,ftString , 3, False);    // Unidade de medida
    ibTable1.FieldDefs.Add('QUANTIDADE'   ,ftFloat  , 0, False);    // Quantidade vendida
    ibTable1.FieldDefs.Add('SINCRONIA'    ,ftFloat  , 0, False);    // Sincronia com estoque  Resolvi este problema as 4 da madrugada no NoteBook em casa
    ibTable1.FieldDefs.Add('UNITARIO'     ,ftFloat  , 0, False);    // Preço unitário
    ibTable1.FieldDefs.Add('TOTAL'        ,ftFloat  , 0, False);    // Valor total
    ibTable1.FieldDefs.Add('LISTA'        ,ftFloat  , 0, False);    // Valor na pauta
    ibTable1.FieldDefs.Add('CUSTO'        ,ftFloat  , 0, False);    // Custo de compta
    ibTable1.FieldDefs.Add('PESO'         ,ftFloat  , 0, False);    // Peso bruto do produto
    ibTable1.FieldDefs.Add('BASE'         ,ftFloat  , 0, False);    // Base de calculo
    ibTable1.FieldDefs.Add('BASEISS'      ,ftFloat  , 0, False);    // Base de calculo ISS
    ibTable1.FieldDefs.Add('ALIQUOTA'     ,ftFloat  , 0, False);    // Aliquota de ICM
    ibTable1.FieldDefs.Add('CFOP'         ,ftString , 5, False);    // para NF com 2ou+ CFOP
    ibTable1.FieldDefs.Add('NUMEROOS'     ,ftString , 6, False);    // Número vinculado a OS
    ibTable1.FieldDefs.Add('REGISTRO'     ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // Notas de Venda
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'VENDAS';
    ibTable1.FieldDefs.Add('NUMERONF'     ,ftString ,07, False);
    ibTable1.FieldDefs.Add('MODELO'       ,ftString ,02, False);
    ibTable1.FieldDefs.Add('VENDEDOR'     ,ftString ,30, False);
    ibTable1.FieldDefs.Add('CLIENTE'      ,ftString ,35, False);
    ibTable1.FieldDefs.Add('OPERACAO'     ,ftString ,40, False);
    ibTable1.FieldDefs.Add('EMISSAO'      ,ftDate,0, False);
    ibTable1.FieldDefs.Add('FRETE'        ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('SEGURO'       ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESPESAS'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESCONTO'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('VOLUMES'      ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ESPECIE'      ,ftString ,13, False);
    ibTable1.FieldDefs.Add('MARCA'        ,ftString ,13, False);
    ibTable1.FieldDefs.Add('TRANSPORTA'   ,ftString ,35, False);
    ibTable1.FieldDefs.Add('FRETE12'      ,ftString ,1, False);
    ibTable1.FieldDefs.Add('SAIDAH'       ,ftString ,8, False);
    ibTable1.FieldDefs.Add('SAIDAD'       ,ftDate,0, False);
    ibTable1.FieldDefs.Add('DUPLICATAS'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('BASEICM'      ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('BASEISS'      ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ICMS'         ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ICMSSUBSTI'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('BASESUBSTI'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ISS'          ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('IPI'          ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('TOTAL'        ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('MERCADORIA'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('COMPLEMEN1'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN2'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN3'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN4'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN5'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('EMITIDA'      ,ftString ,01, False);
    ibTable1.FieldDefs.Add('SERVICOS'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESCRICAO1'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('DESCRICAO2'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('DESCRICAO3'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('PESOBRUTO'    ,ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('PESOLIQUI'    ,ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('REGISTRO'     ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // Itens de Venda ITENS002
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ITENS002';
    ibTable1.FieldDefs.Add('NUMERONF'     ,ftString , 6, False); // Numero da NF
    ibTable1.FieldDefs.Add('CODIGO'       ,ftString , 5, False); // Código 5 dígitos
    ibTable1.FieldDefs.Add('DESCRICAO'    ,ftString ,45, False); // Descrição
    ibTable1.FieldDefs.Add('ST'           ,ftString , 3, False); // situação tributária
    ibTable1.FieldDefs.Add('IPI'          ,ftFloat  , 0, False); // Aliquota de IPI
    ibTable1.FieldDefs.Add('ICM'          ,ftFloat  , 0, False); // Aliquota de ICM
    ibTable1.FieldDefs.Add('BASE'         ,ftFloat  , 0, False); // Base de calculo
    ibTable1.FieldDefs.Add('MEDIDA'       ,ftString , 3, False); // Unidade de medida
    ibTable1.FieldDefs.Add('QUANTIDADE'   ,ftFloat  , 0, False); // Quantidade vendida
    ibTable1.FieldDefs.Add('SINCRONIA'    ,ftFloat  , 0, False); // Sincronia com estoque Resolvi este problema as 4 da madrugada no NoteBook em casa
    ibTable1.FieldDefs.Add('UNITARIO'     ,ftFloat  , 0, False); // Preço unitário
    ibTable1.FieldDefs.Add('TOTAL'        ,ftFloat  , 0, False); // Valor total
    ibTable1.FieldDefs.Add('LISTA'        ,ftFloat  , 0, False); // Valor na pauta
    ibTable1.FieldDefs.Add('CUSTO'        ,ftFloat  , 0, False); // Custo de compta
    ibTable1.FieldDefs.Add('PESO'         ,ftFloat  , 0, False); // Peso bruto do produto
    ibTable1.FieldDefs.Add('FORNECEDOR'   ,ftString ,35, False); // Fornecedor
    ibTable1.FieldDefs.Add('CFOP'         ,ftString , 5, False); // para NF com 2ou+ CFOP
    ibTable1.FieldDefs.Add('REGISTRO'     ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo COMPRAS
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'COMPRAS';
    ibTable1.FieldDefs.Add('NUMERONF'     ,ftString ,06, False);
    ibTable1.FieldDefs.Add('MODELO'       ,ftString ,02, False);
    ibTable1.FieldDefs.Add('VENDEDOR'     ,ftString ,30, False);
    ibTable1.FieldDefs.Add('FORNECEDOR'   ,ftString ,35, False);
    ibTable1.FieldDefs.Add('OPERACAO'     ,ftString ,40, False);
    ibTable1.FieldDefs.Add('EMISSAO'      ,ftDate,0, False);
    ibTable1.FieldDefs.Add('FRETE'        ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESCONTO'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('SEGURO'       ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESPESAS'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('VOLUMES'      ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ESPECIE'      ,ftString ,13, False);
    ibTable1.FieldDefs.Add('MARCA'        ,ftString ,13, False);
    ibTable1.FieldDefs.Add('TRANSPORTA'   ,ftString ,35, False);
    ibTable1.FieldDefs.Add('FRETE12'      ,ftString ,1, False);
    ibTable1.FieldDefs.Add('SAIDAH'       ,ftString ,8, False);
    ibTable1.FieldDefs.Add('SAIDAD'       ,ftDate,0, False);
    ibTable1.FieldDefs.Add('DUPLICATAS'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('BASEICM'      ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ICMS'         ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ICMSSUBSTI'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('BASESUBSTI'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ISS'          ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('IPI'          ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('TOTAL'        ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('MERCADORIA'   ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('COMPLEMEN1'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN2'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN3'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN4'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('COMPLEMEN5'   ,ftString ,60, False);
    ibTable1.FieldDefs.Add('EMITIDA'      ,ftString ,01, False);
    ibTable1.FieldDefs.Add('SERVICOS'     ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('DESCRICAO1'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('DESCRICAO2'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('DESCRICAO3'   ,ftString ,61, False);
    ibTable1.FieldDefs.Add('PESOBRUTO'    ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('PESOLIQUI'    ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('REGISTRO'     ,ftString, 10, False);
    //
    ibTable1.CreateTable;
    //
    // Itens de Serviço na NF e OS não usa mais TMP usa relacionamento com OS e VENDA
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ITENS003';
    ibTable1.FieldDefs.Add('NUMERONF'     ,ftString , 7, False);    // Numero da NF
    ibTable1.FieldDefs.Add('CODIGO'       ,ftString , 5, False);    // Código 5 dígitos
    ibTable1.FieldDefs.Add('DESCRICAO'    ,ftString ,45, False);    // Descrição
    ibTable1.FieldDefs.Add('MEDIDA'       ,ftString , 3, False);    // Unidade de medida
    ibTable1.FieldDefs.Add('QUANTIDADE'   ,ftFloat  , 0, False);    // Quantidade vendida
    ibTable1.FieldDefs.Add('UNITARIO'     ,ftFloat  , 0, False);    // Preço unitário
    ibTable1.FieldDefs.Add('TOTAL'        ,ftFloat  , 0, False);    // Valor total
    ibTable1.FieldDefs.Add('CFOP'         ,ftString , 5, False);    // para NF com 2ou+ CFOP
    ibTable1.FieldDefs.Add('TECNICO'      ,ftString ,15, False);    // para NF com 2ou+ CFOP
    ibTable1.FieldDefs.Add('ISS'          ,ftFloat  , 0, False);    // Valor de ISS
    ibTable1.FieldDefs.Add('BASEISS'      ,ftFloat  , 0, False);    // Base de calculo ISS
    ibTable1.FieldDefs.Add('NUMEROOS'     ,ftString , 6, False);    // Número vinculado a OS
    ibTable1.FieldDefs.Add('REGISTRO'     ,ftString ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo EMITENTE
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'EMITENTE';
    ibTable1.FieldDefs.Add('NOME'     ,ftString , 35, False);
    ibTable1.FieldDefs.Add('CONTATO'  ,ftString , 35, False);
    ibTable1.FieldDefs.Add('ENDERECO' ,ftString , 35, False);
    ibTable1.FieldDefs.Add('COMPLE'   ,ftString , 20, False);
    ibTable1.FieldDefs.Add('MUNICIPIO',ftString , 20, False);
    ibTable1.FieldDefs.Add('CEP'      ,ftString , 09, False);
    ibTable1.FieldDefs.Add('ESTADO'   ,ftString , 02, False);
    ibTable1.FieldDefs.Add('CGC'      ,ftString , 18, False);
    ibTable1.FieldDefs.Add('IE'       ,ftString , 16, False);
    ibTable1.FieldDefs.Add('TELEFO'   ,ftString , 16, False);
    ibTable1.FieldDefs.Add('EMAIL'    ,ftString ,132, False);
    ibTable1.FieldDefs.Add('HP'       ,ftString ,130, False);
    ibTable1.FieldDefs.Add('COPE', ftFloat, 0, False); // Custo operacional
    ibTable1.FieldDefs.Add('RESE', ftFloat, 0, False); // Reserva
    ibTable1.FieldDefs.Add('CVEN', ftFloat, 0, False); // Comissão de vendedores
    ibTable1.FieldDefs.Add('IMPO', ftFloat, 0, False); // Outros impostos
    ibTable1.FieldDefs.Add('LUCR', ftFloat, 0, False); // Lucro desejado
    ibTable1.FieldDefs.Add('ICME', ftFloat, 0, False); // ICMe
    ibTable1.FieldDefs.Add('ICMS', ftFloat, 0, False); // ICMs
    ibTable1.FieldDefs.Add('REGISTRO',ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo ICM
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ICM';
    ibTable1.FieldDefs.Add('NOME'       ,ftString ,40, False);
    ibTable1.FieldDefs.Add('CFOP'       ,ftString ,5, False);
    ibTable1.FieldDefs.Add('ST'         ,ftString ,3, False);
    ibTable1.FieldDefs.Add('BASE'       ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('BASEISS'    ,ftFloat  ,0, False);
    ibTable1.FieldDefs.Add('INTEGRACAO' ,ftString ,8, False);
    ibTable1.FieldDefs.Add('ISS'        ,ftFloat  ,0, False); // ISS
    ibTable1.FieldDefs.Add('AM'     ,ftFloat,0, False); //Amazonas
    ibTable1.FieldDefs.Add('AC'     ,ftFloat,0, False); //Acre
    ibTable1.FieldDefs.Add('AL'     ,ftFloat,0, False); //Alagoas
    ibTable1.FieldDefs.Add('AP'     ,ftFloat,0, False); //Amapá
    ibTable1.FieldDefs.Add('BA'     ,ftFloat,0, False); //Baia
    ibTable1.FieldDefs.Add('CE'     ,ftFloat,0, False); //Ceará
    ibTable1.FieldDefs.Add('DF'     ,ftFloat,0, False); //Distrito Federal
    ibTable1.FieldDefs.Add('ES'     ,ftFloat,0, False); //Espirito Santo
    ibTable1.FieldDefs.Add('GO'     ,ftFloat,0, False); //Goiás
    ibTable1.FieldDefs.Add('MA'     ,ftFloat,0, False); //Maranhão
    ibTable1.FieldDefs.Add('MG'     ,ftFloat,0, False); //Minas Gerais
    ibTable1.FieldDefs.Add('MT'     ,ftFloat,0, False); //Mato grosso
    ibTable1.FieldDefs.Add('MS'     ,ftFloat,0, False); //Mato grosso do sul
    ibTable1.FieldDefs.Add('PA'     ,ftFloat,0, False); //Pará
    ibTable1.FieldDefs.Add('PB'     ,ftFloat,0, False); //Paraíba
    ibTable1.FieldDefs.Add('PE'     ,ftFloat,0, False); //Pernambuco
    ibTable1.FieldDefs.Add('PI'     ,ftFloat,0, False); //Piauí
    ibTable1.FieldDefs.Add('PR'     ,ftFloat,0, False); //Parana
    ibTable1.FieldDefs.Add('RJ'     ,ftFloat,0, False); //Rio de Janeiro
    ibTable1.FieldDefs.Add('RN'     ,ftFloat,0, False); //Rio Grande do Norte
    ibTable1.FieldDefs.Add('RO'     ,ftFloat,0, False); //Rondônia
    ibTable1.FieldDefs.Add('RR'     ,ftFloat,0, False); //Roraima
    ibTable1.FieldDefs.Add('RS'     ,ftFloat,0, False); //Rio Grande do Sul
    ibTable1.FieldDefs.Add('SC'     ,ftFloat,0, False); //Santa Catarina
    ibTable1.FieldDefs.Add('SE'     ,ftFloat,0, False); //Sergipe
    ibTable1.FieldDefs.Add('SP'     ,ftFloat,0, False); //São Paulo
    ibTable1.FieldDefs.Add('TO'     ,ftFloat,0, False); //Tocantins
    ibTable1.FieldDefs.Add('EX'     ,ftFloat,0, False); //Tocantins
    ibTable1.FieldDefs.Add('OBS'    ,ftString ,130, False);
    ibTable1.FieldDefs.Add('CONTA'  ,ftString ,25, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo BANCOS
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'BANCOS';
    ibTable1.FieldDefs.Add('NOME'    ,ftString ,30, False);
    ibTable1.FieldDefs.Add('AGENCIA' ,ftString ,10, False);
    ibTable1.FieldDefs.Add('CONTA'   ,ftString ,16, False);
    ibTable1.FieldDefs.Add('PLANO'   ,ftString ,05, False);
    ibTable1.FieldDefs.Add('SALDO1'  ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('SALDO2'  ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('SALDO3'  ,ftFloat,0, False);
    ibTable1.FieldDefs.Add('ARQUIVO' ,ftString ,08, False);
    ibTable1.FieldDefs.Add('REGISTRO',ftString ,10, False);
    ibTable1.CreateTable;
    //
    // RESUMO.DBF
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'RESUMO';
    ibTable1.FieldDefs.Add('DATA'      ,ftDate   , 0, False);
    ibTable1.FieldDefs.Add('DOCUMENTO' ,ftString , 8, False);
    ibTable1.FieldDefs.Add('HISTORICO' ,ftString ,45, False);
    ibTable1.FieldDefs.Add('QUANTIDADE',ftFloat  , 0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString  ,10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo VENDEDOR
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'VENDEDOR';
    ibTable1.FieldDefs.Add('NOME'     ,ftString , 35, False);
    ibTable1.FieldDefs.Add('COMISSA1' ,ftFloat  ,  0, False);
    ibTable1.FieldDefs.Add('COMISSA2' ,ftFloat  ,  0, False);
    ibTable1.FieldDefs.Add('HORASTRAB',ftString ,  4, False);
    ibTable1.FieldDefs.Add('FUNCAO'   ,ftString , 10, False);
    ibTable1.FieldDefs.Add('ATIVO'    ,ftBoolean,  0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo CONVENIO
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'CONVENIO';
    ibTable1.FieldDefs.Add('NOME'    ,ftString , 30, False);
    ibTable1.FieldDefs.Add('RAZAO'   ,ftString , 30, False);
    ibTable1.FieldDefs.Add('FONE'    ,ftString , 16, False);
    ibTable1.FieldDefs.Add('EMAIL'   ,ftString , 80, False);
    ibTable1.FieldDefs.Add('DESCONTO',ftFloat  ,  0, False);
    ibTable1.FieldDefs.Add('REGISTRO',ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo CONTAS
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'CONTAS';
    ibTable1.FieldDefs.Add('CONTA',ftString, 5, False);
    ibTable1.FieldDefs.Add('NOME' ,ftString,25, False);
    ibTable1.FieldDefs.Add('DIA'  ,ftFloat,  0, False);
    ibTable1.FieldDefs.Add('MES'  ,ftFloat,  0, False);
    ibTable1.FieldDefs.Add('ANO'  ,ftFloat,  0, False);
    ibTable1.FieldDefs.Add('SALDO',ftFloat,  0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo PAGAR
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'PAGAR';
    ibTable1.FieldDefs.Add('HISTORICO'  ,ftString , 35, False);
    ibTable1.FieldDefs.Add('PORTADOR'   ,ftString , 35, False);
    ibTable1.FieldDefs.Add('DOCUMENTO'  ,ftString , 7 , False);
    ibTable1.FieldDefs.Add('NOME'       ,ftString , 35, False);
    ibTable1.FieldDefs.Add('EMISSAO'    ,ftDate   , 0 , False);
    ibTable1.FieldDefs.Add('VENCIMENTO' ,ftDate   , 0 , False);
    ibTable1.FieldDefs.Add('VALOR_DUPL' ,ftFloat  , 0 , False);
    ibTable1.FieldDefs.Add('PAGAMENTO'  ,ftDate   , 0 , False);
    ibTable1.FieldDefs.Add('VALOR_PAGO' ,ftFloat  , 0 , False);
    ibTable1.FieldDefs.Add('CONTA',      ftString ,25, False);
    ibTable1.FieldDefs.Add('NUMERONF'  , ftString,  7, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo RECEBER
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'RECEBER';
    ibTable1.FieldDefs.Add('HISTORICO',  ftString, 35, False);
    ibTable1.FieldDefs.Add('PORTADOR' ,  ftString, 35, False);
    ibTable1.FieldDefs.Add('DOCUMENTO',  ftString,  7, False);
    ibTable1.FieldDefs.Add('NOME',       ftString, 35, False);
    ibTable1.FieldDefs.Add('EMISSAO',    ftDate,    0, False);
    ibTable1.FieldDefs.Add('VENCIMENTO', ftDate,    0, False);
    ibTable1.FieldDefs.Add('VALOR_DUPL', ftFloat,   0, False);
    ibTable1.FieldDefs.Add('RECEBIMENT', ftDate,    0, False);
    ibTable1.FieldDefs.Add('VALOR_RECE', ftFloat,   0, False);
    ibTable1.FieldDefs.Add('VALOR_JURO', ftFloat,   0, False);
    ibTable1.FieldDefs.Add('ATIVO',      ftBoolean, 0, False);
    ibTable1.FieldDefs.Add('CONTA',      ftString ,25, False);
    ibTable1.FieldDefs.Add('NOSSONUM'  , ftString, 20, False);
    ibTable1.FieldDefs.Add('CODEBAR'   , ftString, 50, False);
    ibTable1.FieldDefs.Add('NUMERONF'  , ftString,  7, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo CLIFOR
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'CLIFOR';
    ibTable1.FieldDefs.Add('NOME'     ,ftString, 35, False);
    ibTable1.FieldDefs.Add('CONTATO'  ,ftString, 35, False);
    ibTable1.FieldDefs.Add('IE'       ,ftString, 16, False);
    ibTable1.FieldDefs.Add('CGC'      ,ftString, 19, False);
    ibTable1.FieldDefs.Add('ENDERE'   ,ftString, 40, False);
    ibTable1.FieldDefs.Add('COMPLE'   ,ftString, 35, False);
    ibTable1.FieldDefs.Add('CIDADE'   ,ftString, 25, False);
    ibTable1.FieldDefs.Add('ESTADO'   ,ftString,  2, False);
    ibTable1.FieldDefs.Add('CEP'      ,ftString,  9, False);
    ibTable1.FieldDefs.Add('FONE'     ,ftString, 16, False);
    ibTable1.FieldDefs.Add('FAX'      ,ftString, 16, False);
    ibTable1.FieldDefs.Add('EMAIL'    ,ftString, 80, False);
    ibTable1.FieldDefs.Add('OBS'      ,ftString,254, False);
    ibTable1.FieldDefs.Add('CELULAR'  ,ftString, 16, False);
    ibTable1.FieldDefs.Add('CREDITO'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('CONVENIO' ,ftString, 30, False);
    //
    ibTable1.FieldDefs.Add('IDENTIFICADOR1' ,ftString, 30, False);
    ibTable1.FieldDefs.Add('IDENTIFICADOR2' ,ftString, 30, False);
    ibTable1.FieldDefs.Add('IDENTIFICADOR3' ,ftString, 30, False);
    ibTable1.FieldDefs.Add('IDENTIFICADOR4' ,ftString, 30, False);
    ibTable1.FieldDefs.Add('IDENTIFICADOR5' ,ftString, 30, False);
    //
    ibTable1.FieldDefs.Add('DATANAS'  ,ftDate  ,  0, False);
    ibTable1.FieldDefs.Add('CADASTRO' ,ftDate  ,  0, False);
    ibTable1.FieldDefs.Add('ULTIMACO' ,ftDate  ,  0, False);
    ibTable1.FieldDefs.Add('PROXDATA' ,ftDate  ,  0, False);
    ibTable1.FieldDefs.Add('CUSTO'   ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('COMPRA'  ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('ATIVO'   ,ftBoolean,  0, False);
    ibTable1.FieldDefs.Add('MOSTRAR' ,ftString ,  1, False);
    ibTable1.FieldDefs.Add('CLIFOR'  ,ftString ,  1, False);
    ibTable1.FieldDefs.Add('REGISTRO',ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo OS
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'OS';
    ibTable1.FieldDefs.Add('NUMERO'    ,ftString,   6, False);
    ibTable1.FieldDefs.Add('DATA'      ,ftDate  ,   0, False);
    ibTable1.FieldDefs.Add('HORA'      ,ftString,   5, False);
    ibTable1.FieldDefs.Add('CLIENTE'   ,ftString,  35, False);
    ibTable1.FieldDefs.Add('DATA_PRO'  ,ftDate  ,   0, False);
    ibTable1.FieldDefs.Add('HORA_PRO'  ,ftString,   5, False);
    ibTable1.FieldDefs.Add('TEMPO'     ,ftString,   5, False);
    ibTable1.FieldDefs.Add('DATA_TER'  ,ftDate  ,   0, False);
    ibTable1.FieldDefs.Add('HORA_TER'  ,ftString,   5, False);
    ibTable1.FieldDefs.Add('SITUACAO'  ,ftString,  25, False);
    ibTable1.FieldDefs.Add('DATA_ENT'  ,ftDate  ,   0, False);
    ibTable1.FieldDefs.Add('HORA_ENT'  ,ftString,   5, False);
    ibTable1.FieldDefs.Add('TECNICO'   ,ftString,  15, False);
    ibTable1.FieldDefs.Add('DESCRICAO' ,ftString,  40, False);
    ibTable1.FieldDefs.Add('PROBLEMA'  ,ftString,  70, False);
    ibTable1.FieldDefs.Add('IDENTIFI1' ,ftString,  20, False);
    ibTable1.FieldDefs.Add('IDENTIFI2' ,ftString,  20, False);
    ibTable1.FieldDefs.Add('IDENTIFI3' ,ftString,  20, False);
    ibTable1.FieldDefs.Add('IDENTIFI4' ,ftString,  20, False);
    ibTable1.FieldDefs.Add('GARANTIA'  ,ftDate  ,   0, False);
    ibTable1.FieldDefs.Add('OBSERVACAO',ftString, 254, False);
    ibTable1.FieldDefs.Add('TOTAL_SERV',ftFloat,    0, False);
    ibTable1.FieldDefs.Add('TOTAL_PECA',ftFloat,    0, False);
    ibTable1.FieldDefs.Add('TOTAL_FRET',ftFloat,    0, False);
    ibTable1.FieldDefs.Add('TOTAL_OS'  ,ftFloat,    0, False);
    ibTable1.FieldDefs.Add('NF'        ,FtString,   6, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // se não existe cria o arquivo REDUCOES
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'REDUCOES';
    ibTable1.FieldDefs.Add('DATA'      ,ftDate     , 0, False);
    ibTable1.FieldDefs.Add('PDV'       ,ftString   , 3, False);
    ibTable1.FieldDefs.Add('SERIE'     ,ftString   ,20, False);
    ibTable1.FieldDefs.Add('CUPOMi'    ,ftString   , 6, False);
    ibTable1.FieldDefs.Add('CUPOMf'    ,ftString   , 6, False);
    ibTable1.FieldDefs.Add('CONTADORz' ,ftString   , 6, False);
    ibTable1.FieldDefs.Add('TOTALi'    ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('TOTALf'    ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA01',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA02',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA03',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA04',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA05',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA06',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA07',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA08',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA09',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA10',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA11',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA12',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA13',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA14',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA15',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA16',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA17',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA18',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQUOTA19',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ALIQU01',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU02',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU03',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU04',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU05',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU06',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU07',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU08',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU09',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU10',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU11',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU12',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU13',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU14',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU15',FtString    , 4, False);
    ibTable1.FieldDefs.Add('ALIQU16',FtString    , 4, False);
    ibTable1.FieldDefs.Add('CANCELAMEN',ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('DESCONTOS' ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('ISSQN'     ,ftFloat    , 0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // ESTOQUE
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'ESTOQUE';
    ibTable1.FieldDefs.Add('CODIGO'    ,ftString,  5, False);
    ibTable1.FieldDefs.Add('REFERENCIA',ftString, 13, False);
    ibTable1.FieldDefs.Add('DESCRICAO' ,ftString, 45, False);
    ibTable1.FieldDefs.Add('NOME'      ,ftString, 25, False);
    ibTable1.FieldDefs.Add('FORNECEDOR',ftString, 35, False);
    ibTable1.FieldDefs.Add('MEDIDA'    ,ftString,  3, False);
    ibTable1.FieldDefs.Add('PRECO'     ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('INDEXADOR' ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('CUSTOCOMPR',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('CUSTOMEDIO',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('QTD_COMPRA',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('QTD_ATUAL' ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('QTD_MINIM' ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('QTD_INICIO',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('DAT_INICIO',ftDate ,   0, False);
    ibTable1.FieldDefs.Add('ULT_COMPRA',ftDate ,   0, False);
    ibTable1.FieldDefs.Add('ULT_VENDA' ,ftDate ,   0, False);
    ibTable1.FieldDefs.Add('LIVRE1'    ,ftString, 30, False);
    ibTable1.FieldDefs.Add('LIVRE2'    ,ftString, 30, False);
    ibTable1.FieldDefs.Add('LIVRE3'    ,ftString, 30, False);
    ibTable1.FieldDefs.Add('LIVRE4'    ,ftString, 30, False);
    ibTable1.FieldDefs.Add('PESO'      ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('LOCAL'     ,ftString, 10, False);
    ibTable1.FieldDefs.Add('CF'        ,ftString, 13, False);
    ibTable1.FieldDefs.Add('IPI'       ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('CST'       ,ftString,  3, False);
    ibTable1.FieldDefs.Add('ST'        ,ftString,  3, False);
    ibTable1.FieldDefs.Add('COMISSAO'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('OBS'       ,ftString, 254, False);
    ibTable1.FieldDefs.Add('QTD_VEND'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('CUS_VEND'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('VAL_VEND'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('LUC_VEND'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('ATIVO'     ,ftBoolean, 0, False);
    ibTable1.FieldDefs.Add('MARGEMLB'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('ALTERADO'  ,ftBoolean, 0, False);
    ibTable1.FieldDefs.Add('SERIE'     ,ftBoolean, 0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
    // MOVI0001
    //
    ibTable1.FieldDefs.clear;
    ibTable1.TableName    := 'MOVI0001';
    ibTable1.FieldDefs.Add('CONTA'     ,ftString,  4, False);
    ibTable1.FieldDefs.Add('DOCUMENTO' ,ftString, 10, False);
    ibTable1.FieldDefs.Add('HISTORICO' ,ftString, 50, False);
    ibTable1.FieldDefs.Add('NOMINAL'   ,ftString, 30, False);
    ibTable1.FieldDefs.Add('SAIDA_'    ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('ENTRADA_'  ,ftFloat,   0, False);
    ibTable1.FieldDefs.Add('EMISSAO'   ,ftDate,    0, False);
    ibTable1.FieldDefs.Add('PREDATA'   ,ftDate,    0, False);
    ibTable1.FieldDefs.Add('COMPENS'   ,ftDate,    0, False);
    ibTable1.FieldDefs.Add('SALDO_TALA',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('SALDO_REAL',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('SALDO_BANC',ftFloat,   0, False);
    ibTable1.FieldDefs.Add('REGISTRO' ,ftString , 10, False);
    ibTable1.CreateTable;
    //
  //  ShowMessage('Arquivo SMALL.GDB criado com sucesso.');
    //
    IBTransaction1.Commit;
    IBTransaction1.Active := False;
    IbDatabase1.Close;
  except end;
  //
  try
    //
    IBDatabase1.Connected     := False;
    IBTransaction1.Active     := False;
    //
    IBDatabase1.Params.Clear;
    IbDatabase1.DatabaseName := Url;
    IBDatabase1.Params.Add('USER_NAME=SYSDBA');
    IBDatabase1.Params.Add('PASSWORD=masterkey');
    IbDatabase1.Open;
    IBTransaction1.Active := True;
    IBDatabase1.Connected := True;
    //
  except
    ShowMessage('Erro ao abrir o arquivo small.gdb');
    Halt(1);
  end;
  //
  Animate1.Active := True;
  Animate1.Visible := True;
  //
  try
    //
    if AllTrim(URL2) <> '' then
    begin
      Converso('EMITENTE');
      Converso('CONTAS');
      Converso('CONVENIO');
      Converso('VENDEDOR');
      Converso('BANCOS');
      Converso('ICM');
      Converso('TRANSPOR');
      Converso('NOTA');
      Converso('COMPOSTO');
      Converso('SERIE');
      Converso('GRADE');
      Converso('GRUPO');
      Converso('ITENS003');
      Converso('OS');
      Converso('COMPRAS');
      Converso('ITENS002');
      Converso('VENDAS');
      Converso('ITENS001');
      Converso('ALTERACA');
      Converso('PAGAR');
      Converso('RECEBER');
      Converso('CAIXA');
      Converso('ESTOQUE');
      Converso('CLIFOR');
    end;
  except

  end;
  //
  try
    Label1.Caption := 'Aguarde!'+Chr(10)+chr(10)+'gravando fisicamente os dados no arquivo small.gdb';
    Label1.Repaint;
    IBTransaction1.Commit;
  except
    ShowMessage('Erro ao gravar fisicamente os dados no arquivo small.gdb');
    Halt(1);
  end;
  //
  if (FileExists(Form1.Url2+'\'+'estoque.dbf')) then
  begin
    Label1.Caption := 'Parabéns!'+Chr(10)+chr(10)
    +'Seu banco de dados foi criado e configurado com sucesso e'+Chr(10)
    +'está pronto para ser utilizado.'+Chr(10)+Chr(10)
    +'Seus arquivos antigos foram convertidos para'+Chr(10)
    +'o "Client Server".';
  end else
  begin
    Label1.Caption := 'Parabéns!'+Chr(10)+chr(10)
    +'Seu banco de dados "Client Server" foi criado e configurado'+Chr(10)
    +'com sucesso e está pronto para ser utilizado.';
  end;
  //
  Animate1.Active := False;
  Animate1.Visible := False;
{
  //
  DeleteFile('CLIFOR.DBF');
  DeleteFile('ESTOQUE.DBF');
  DeleteFile('CAIXA.DBF');
  DeleteFile('RECEBER.DBF');
  DeleteFile('PAGAR.DBF');
  DeleteFile('ALTERACA.DBF');
  DeleteFile('ITENS001.DBF');
  DeleteFile('VENDAS.DBF');
  DeleteFile('ITENS002.DBF');
  DeleteFile('COMPRAS.DBF');
  DeleteFile('OS.DBF');
  DeleteFile('ITENS003.DBF');
  DeleteFile('GRUPO.DBF');
  DeleteFile('GRADE.DBF');
  DeleteFile('SERIE.DBF');
  DeleteFile('COMPOSTO.DBF');
  DeleteFile('NOTA.DBF');
  DeleteFile('TRANSPOR.DBF');
  DeleteFile('ICM.DBF');
  DeleteFile('BANCOS.DBF');
  DeleteFile('VENDEDOR.DBF');
  DeleteFile('CONVENIO.DBF');
  DeleteFile('CONTAS.DBF');
  DeleteFile('EMITENTE.DBF');
  //
  DeleteFile('CLIFOR.MDX');
  DeleteFile('ESTOQUE.MDX');
  DeleteFile('CAIXA.MDX');
  DeleteFile('RECEBER.MDX');
  DeleteFile('PAGAR.MDX');
  DeleteFile('ALTERACA.MDX');
  DeleteFile('ITENS001.MDX');
  DeleteFile('VENDAS.MDX');
  DeleteFile('ITENS002.MDX');
  DeleteFile('COMPRAS.MDX');
  DeleteFile('OS.MDX');
  DeleteFile('ITENS003.MDX');
  DeleteFile('GRUPO.MDX');
  DeleteFile('GRADE.MDX');
  DeleteFile('SERIE.MDX');
  DeleteFile('COMPOSTO.MDX');
  DeleteFile('NOTA.MDX');
  DeleteFile('TRANSPOR.MDX');
  DeleteFile('ICM.MDX');
  DeleteFile('BANCOS.MDX');
  DeleteFile('VENDEDOR.MDX');
  DeleteFile('CONVENIO.MDX');
  DeleteFile('CONTAS.MDX');
  DeleteFile('EMITENTE.MDX');
  //
}
  Image5.Visible := False;
  Image3.Visible := False;
  //
  Label11.Visible := False;
  Label15.Visible := False;
  //
  Label16.Caption := 'Ok';
  Button1.SetFocus;
  //
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  SmallIni : tIniFile;
  sAtual : String;
begin
  //
  GetDir(0,sAtual);
  SmallIni := TIniFile.Create(sAtual+'\small.ini');
  Edit1.Text := SmallIni.ReadString('Firebird','Server IP','');
  Edit2.Text := SmallIni.ReadString('Firebird','Server url','c:\Arquivos de programas\smallsoft\small commerce');
  SmallIni.Free;
  //
  // if FileExists('c:\Arquivos de programas\smallsoft\small commerce\estoque.dbf') then Edit3.Text := 'c:\Arquivos de programas\smallsoft\small commerce' else Edit3.Text := '';
  //
  Button1.Top  := Form1.Height + 50;
  Button4.Top  := Form1.Height + 50;
  //
  Label1.Caption := 'Atenção!'+Chr(10)+chr(10)
  +'Este assistente vai configurar o acesso e se for necessário'+Chr(10)
  +'criar um banco de dados "Client Server".';
  Label2.Caption := 'IP do servidor:';
  Label3.Caption := 'Endereço do arquivo no servidor:';
  Label4.Caption := 'Endereço da base de dados para conversão:';
  Label5.Caption := 'Clique em Avançar> para continuar.';
  //
  Label1.Repaint;
  //
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
  if FileExists('c:\Arquivos de programas\compufour\Aplicativos Comerciais\estoque.dbf') then Edit3.Text := 'c:\Arquivos de programas\compufour\Aplicativos Comerciais';
  if FileExists('c:\Arquivos de programas\smallsoft\small commerce\estoque.dbf') then Edit3.Text := 'c:\Arquivos de programas\smallsoft\small commerce';
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked then
  begin
    Edit1.Text     := '';
    Edit1.Visible  := False;
    Label2.Visible := False;
  end else
  begin
    Edit1.Visible  := True;
    Label2.Visible := True;
  end;
end;

end.

