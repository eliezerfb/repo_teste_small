unit converso_firebird;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBTables, DB, IBCustomDataSet, IBTable, IBDatabase,
  ExtCtrls, SmallFunc, ComCtrls, IniFiles, ShellApi, IBQuery, Winsock,
  IdBaseComponent, IdComponent, IdIPWatch, XPMan, FileCtrl, xmldom,
  XMLIntf, msxmldom, XMLDoc, Gauges;

type

  TForm1 = class(TForm)
    Table1: TTable;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBTable1: TIBTable;
    Edit2: TEdit;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    IBQuery1: TIBQuery;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label6: TLabel;
    IBQuery2: TIBQuery;
    Button3: TButton;
    Button5: TButton;
    IdIPWatch1: TIdIPWatch;
    Label1: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    XPManifest1: TXPManifest;
    Timer1: TTimer;
    Label4: TLabel;
    XMLDocument1: TXMLDocument;
    Gauge1: TGauge;
    procedure FormActivate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    I, X : Integer;
    iBanco, iArquivo : Integer;
    sCNPJ, sAtual, Url, Url2 : String;
    tInicio : tTime;
  end;

var
  Form1: TForm1;
  tInicio : tTime;

implementation

{$R *.dfm}


function ImportaXML(sP1: String):Boolean;
var
  //
  NodePrim, NodePai, NodeSec, NodeTmp: IXMLNode; // Node é um nó do XML
  sDataVencimento, sValorDuplicata, scodigo, sNumeroDaNota, sNomeDaEmpresa : String;
  //
begin
  //
  // Importa atravez do XML gravado no COMPRAS automaticamento por download (ConsultarDistribuicaoDFeChave)
  //
  try
    //
    try
      Form1.XMLDocument1.DOMVendor := GetDOMVendor('MSXML');
      Form1.XMLDocument1.LoadFromFile(Alltrim(sP1)); //Le Arquivo XML’);
    except
      Form1.XMLDocument1.DOMVendor := GetDOMVendor('Open XML');
      Form1.XMLDocument1.LoadFromFile(Alltrim(sP1)); //Le Arquivo XML’);
    end;
    //
    if (Pos('<mod>55</mod>',Form1.XMLDocument1.XML.Text) <> 0) then
    begin
      //
      // NFe
      //
//      if (Pos(LimpaNumero(Form1.sCNPJ),Form1.XMLDocument1.XML.Text) <> 0) then
//      begin
      //
      // Notas emitidas para este CNPJ
      //
      if (Pos('<cStat>100</cStat>',Form1.XMLDocument1.XML.Text) <> 0) then // Modelo 55 e assinada  (Pos('SignatureValue',Form1.XMLDocument1.XML.Text) <> 0) and
      begin
        //
        // NFe Assinada e Autorizada
        //
        if (Pos('<CNPJ>99999999000191</CNPJ>',Form1.XMLDocument1.XML.Text) = 0) then
        begin
          //
          Form1.XMLDocument1.Active    := True;
          //
          NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
          NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
          NodeSec  := NodePai.ChildNodes.FindNode('emit');
          NodeSec.ChildNodes.First;
          //
//          if NodeSec.ChildNodes['CMPJ'].Text = Form1.sCNPJ then
          begin
            //
            NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
            NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
            NodeSec  := NodePai.ChildNodes.FindNode('ide');
            //
            NodeSec.ChildNodes.First;
            sNumeroDaNota := Right(StrZero(StrToFloat(NodeSec.ChildNodes['nNF'].Text),9,0),9)+StrZero(StrToInt(LimpaNumero('0'+NodeSec.ChildNodes['serie'].Text)),3,0);
            //
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('select NUMERONF from VENDAS where NUMERONF='+QuotedStr(sNumeroDaNota)+' ');
            Form1.ibQuery1.Open;
            //
            if (Form1.IBQuery1.FieldByName('NUMERONF').AsString = '') then
            begin
              //
              try
                //
                NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
                NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
                NodeSec  := NodePai.ChildNodes.FindNode('dest');
                NodeSec.ChildNodes.First;
                //
                sNomeDaEmpresa := PrimeiraMaiuscula(AllTrim(Copy(CaracteresHTML((AllTrim(XmlNodeValue(NodeSec.ChildNodes['xNome'].XML,'//xNome'))))+replicate(' ',60),1,60)));
                //
                Form1.ibQuery1.Close;
                Form1.ibQuery1.SQL.Clear;
                Form1.ibQuery1.SQL.Add('select CGC, NOME from CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text)))+' ');
                Form1.ibQuery1.Open;
                //
                if ( Form1.IBQuery1.FieldByName('CGC').AsString <> ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text)) ) then
                begin
                  //
                  //
                  // Importa Cliente
                  //
                  Form1.ibQuery2.Close;
                  Form1.ibQuery2.SQL.Clear;
                  Form1.ibQuery2.SQL.Add('select * from CLIFOR where Upper(NOME)='+QuotedStr(UpperCase(sNomeDaEmpresa)));
                  Form1.ibQuery2.Open;
                  //
                  while sNomeDaEmpresa = Form1.IBQuery2.FieldByName('NOME').AsString do
                  begin
                    //
                    sNomeDaEmpresa := Copy(sNomeDaEmpresa,1,Length(sNomeDaEmpresa)-2);
                    //
                    Form1.ibQuery2.Close;
                    Form1.ibQuery2.SQL.Clear;
                    Form1.ibQuery2.SQL.Add('select * from CLIFOR where NOME='+QuotedStr(sNomeDaEmpresa));
                    Form1.ibQuery2.Open;
                  end;
                  //
                  Form1.IBQuery1.Close;
                  Form1.IBQuery1.SQL.Text :=
                  'insert into CLIFOR (REGISTRO, CGC, NOME, IE, ENDERE, COMPLE, CIDADE, ESTADO, CEP, FONE) ' +
                  'values (right(''0000000000''||gen_id(G_CLIFOR, 1), 10),  :CGC, :NOME, :IE, :ENDERE, :COMPLE, :CIDADE, :ESTADO, :CEP, :FONE)';
                  //
                  Form1.IBQuery1.ParamByName('CGC').AsString      := ConverteCpfCgc(AllTrim(NodeSec.ChildNodes['CNPJ'].Text));
                  Form1.IBQuery1.ParamByName('NOME').AsString     := sNomeDaEmpresa;
                  Form1.IBQuery1.ParamByName('IE').AsString       := AllTrim(NodeSec.ChildNodes['IE'].Text);
                  //
                  NodeTmp  := NodeSec.ChildNodes['enderDest']; // tag <prod> dentro de <det>
                  NodeTmp.ChildNodes.First;
                  //
                  Form1.IBQuery1.ParamByName('ENDERE').AsString   := Copy(PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xLgr'].XML,'//xLgr'))))+' '+AllTrim(NodeTmp.ChildNodes['nro'].Text))+Replicate(' ',40),1,40);;
                  Form1.IBQuery1.ParamByName('COMPLE').AsString   := PrimeiraMaiuscula(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xBairro'].XML,'//xBairro')))));
                  Form1.IBQuery1.ParamByName('CIDADE').AsString   := Copy(CaracteresHTML((AllTrim(XmlNodeValue(NodeTmp.ChildNodes['xMun'].XML,'//xMun'))))+Replicate(' ',40),1,40);
                  Form1.IBQuery1.ParamByName('ESTADO').AsString   := AllTrim(NodeTmp.ChildNodes['UF'].Text);
                  Form1.IBQuery1.ParamByName('CEP').AsString      := Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),1,5)+'-'+Copy(AllTrim(NodeTmp.ChildNodes['CEP'].Text+'00000000'),5,3);
                  Form1.IBQuery1.ParamByName('FONE').AsString     := '(0xx'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),1,2)+')'+Copy(AllTrim(NodeTmp.ChildNodes['fone'].Text+'         '),2,9);
                  Form1.IBQuery1.ExecSQL;
                  //
                  // Fim do importa Cliente
                  //
                end;
                //
              except end;
              //
              try
                //
                // Importa Produtos
                //
                NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
                NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
                NodeSec  := NodePai.ChildNodes.FindNode('det');
                //
                NodeSec.ChildNodes.First;
                //
                repeat
                  //
                  try
                    //
                    NodeTmp  := NodeSec.ChildNodes['prod']; // tag <prod> dentro de <det>
                    NodeTmp.ChildNodes.First;
                    //
                    if Alltrim(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))) <> '' then
                    begin
                      //
                      Form1.ibQuery1.Close;
                      Form1.ibQuery1.Sql.Clear;
                      Form1.ibQuery1.Sql.Add('select CODIGO, REFERENCIA, DESCRICAO from ESTOQUE where REFERENCIA='+QuotedStr(AllTrim(NodeTmp.ChildNodes['cEAN'].Text))+' and DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39)))+' ');
                      Form1.ibQuery1.Open;
                      //
                      if (Form1.IBQuery1.FieldByName('REFERENCIA').AsString <>  AllTrim(NodeTmp.ChildNodes['cEAN'].Text) ) then
                      begin
                        //
                        // Produto novo
                        //
                        Form1.IBQuery1.Close;
                        Form1.IBQuery1.SQL.Text :=
                        'insert into ESTOQUE (REGISTRO, CODIGO, REFERENCIA, DESCRICAO, MEDIDA, PRECO, CF, CODIGO_FCI) ' +
                        'values (right(''0000000000''||gen_id(G_ESTOQUE, 1), 10), right(''00000''||gen_id(G_ESTOQUE, 0), 5), :REFERENCIA, :DESCRICAO, :MEDIDA, :PRECO, :CF, :CODIGO_FCI)';
                        //
                        Form1.IBQuery1.ParamByName('REFERENCIA').AsString    := NodeTmp.ChildNodes['cEAN'].Text;
                        Form1.IBQuery1.ParamByName('DESCRICAO').AsString     := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39));
                        Form1.IBQuery1.ParamByName('MEDIDA').AsString        := AllTrim(NodeTmp.ChildNodes['uCom'].Text);
                        Form1.IBQuery1.ParamByName('PRECO').AsFloat          := StrToFloat(StrTran(NodeTmp.ChildNodes['vProd'].Text,'.',','));
                        Form1.IBQuery1.ParamByName('CF').AsString            := AllTrim(Copy(NodeTmp.ChildNodes['NCM'].Text+Replicate(' ',45),1,45));
                        Form1.IBQuery1.ParamByName('CODIGO_FCI').AsString    := AllTrim(NodeTmp.ChildNodes['nFCI'].Text);
                        //
                        Form1.IBQuery1.ExecSQL;
                        //
                      end;
                    end;
                    //
                    // Da pra melhorar aqui com o Generator
                    //
                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select CODIGO, REFERENCIA, DESCRICAO from ESTOQUE where REFERENCIA='+QuotedStr(AllTrim(NodeTmp.ChildNodes['cEAN'].Text))+' and DESCRICAO='+QuotedStr(AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39)))+' ');
                    Form1.ibQuery1.Open;
                    //
                    sCodigo    := Form1.IBQuery1.FieldByName('CODIGO').AsString;
                    //
                    // Itens da Nota Fiscal
                    //
                    try
                      //
                      if sCODIGO <> '' then
                      begin
                        //
                        Form1.IBQuery1.Close;
                        Form1.IBQuery1.SQL.Text := 'insert into ITENS001 (REGISTRO, NUMERONF, CODIGO, DESCRICAO, QUANTIDADE, SINCRONIA, UNITARIO, TOTAL, XPED, NITEMPED, VICMS, VBC, VBCST, VICMSST)' +
                                                   'values (right(''0000000000''||gen_id(G_ITENS001,1),10), :NUMERONF, :CODIGO, :DESCRICAO, :QUANTIDADE, :SINCRONIA, :UNITARIO, :TOTAL, :XPED, :NITEMPED, :VICMS, :VBC, :VBCST, :VICMSST)';
                        //
                        Form1.IBQuery1.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
                        Form1.IBQuery1.ParamByName('CODIGO').AsString        := sCodigo;
                        Form1.IBQuery1.ParamByName('DESCRICAO').AsString     := AllTrim(Copy(CaracteresHTML((XmlNodeValue(NodeTmp.ChildNodes['xProd'].XML,'//xProd')))+Replicate(' ',39),1,39));
                        //
                        if LimpaNumero(NodeTmp.ChildNodes['qTrib'].Text) <> '' then Form1.IBQuery1.ParamByName('QUANTIDADE').AsFloat := StrToFloat(StrTran(NodeTmp.ChildNodes['qTrib'].Text,'.',','));
                        if LimpaNumero(NodeTmp.ChildNodes['vProd'].Text) <> '' then Form1.IBQuery1.ParamByName('UNITARIO').AsFloat   := StrToFloat(StrTran(NodeTmp.ChildNodes['vProd'].Text,'.',','));
                        //
                        Form1.IBQuery1.ParamByName('TOTAL').AsFloat   :=  StrToFloat(StrTran(NodeTmp.ChildNodes['vProd'].Text,'.',','))*StrToFloat(StrTran(NodeTmp.ChildNodes['qTrib'].Text,'.',','));
                        //
                        Form1.IBQuery1.ExecSQL;
                        //
                      end;
                      //
                    except end;
                    //
                  except end;
                  //
                  NodeSec := NodeSec.NextSibling; // Next
                  //
                until NodeSec = nil;
              except end;
              //
              // Contas a Receber
              //
              //
              NodePrim := Form1.XMLDocument1.DocumentElement.ChildNodes.FindNode('NFe');
              NodePai  := NodePrim.ChildNodes.FindNode('infNFe');
              NodeSec  := NodePai.ChildNodes.FindNode('cobr');
              NodeSec.ChildNodes.First;
              //
              NodeTmp  := NodeSec.ChildNodes['dup']; // tag <prod> dentro de <det>
              NodeTmp.ChildNodes.First;
              //
              repeat

                try
                  //
                  sDataVencimento := NodeTmp.ChildNodes['dVenc'].Text;
                  sValorDuplicata := NodeTmp.ChildNodes['vDup'].Text;
                  //
                  if Length(sDataVencimento) >= 10 then
                  begin

                    Form1.IBQuery1.Close;

                    Form1.IBQuery1.SQL.Text := 'insert into RECEBER (REGISTRO, HISTORICO, DOCUMENTO, NOME, EMISSAO, VENCIMENTO, VALOR_DUPL, NUMERONF) ' +
                    'values (right(''0000000000''||gen_id(G_RECEBER, 1), 10), :HISTORICO, :DOCUMENTO, :NOME, :EMISSAO, :VENCIMENTO, :VALOR_DUPL, :NUMERONF)';
                    //
                    Form1.IBQuery1.ParamByName('HISTORICO').AsString     := 'Nota Fiscal: ' + Copy(sNumeroDaNota,1,13);

                    Form1.IBQuery1.ParamByName('DOCUMENTO').AsString     := Copy(sNumeroDaNota,2,9)+Chr(65+StrToInt(NodeTmp.ChildNodes['nDup'].Text));
                    Form1.IBQuery1.ParamByName('NUMERONF').AsString      := Copy(sNumeroDaNota,1,13);
                    Form1.IBQuery1.ParamByName('EMISSAO').AsDateTime     := StrToDate(Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),9,2)+'/'+Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),6,2)+'/'+Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),1,4));

                    Form1.IBQuery1.ParamByName('VENCIMENTO').AsDateTime  := StrToDate(Copy(sDataVencimento,9,2)+'/'+Copy(sDataVencimento,6,2)+'/'+Copy(sDataVencimento,1,4));

                    Form1.IBQuery1.ParamByName('NOME').AsString       := sNomeDaEmpresa;
                    Form1.IBQuery1.ParamByName('VALOR_DUPL').AsFloat  := StrToFloat(StrTran(sValorDuplicata,'.',','));
                    Form1.IBQuery1.ExecSQL;

                  end;
                  //
                except end;

                NodeTmp := NodeTmp.NextSibling; // Next

              until NodeTmp = nil;
              //
              // Importa a NOTA FISCAL ELETRONICA
              //
              try
                //
                Form1.IBQuery1.Close;
                Form1.IBQuery1.SQL.Text := 'insert into VENDAS (REGISTRO, NUMERONF, EMISSAO, MODELO, CLIENTE, NFEXML, NFEID, STATUS, TOTAL, FRETE, SEGURO, DESPESAS, DESCONTO, BASEICM, ICMS, BASESUBSTI, IPI, MERCADORIA, OPERACAO)' +
                                           'values (right(''0000000000''||gen_id(G_VENDAS, 1), 10), :NUMERONF, :EMISSAO, :MODELO, :CLIENTE, :NFEXML, :NFEID, :STATUS, :TOTAL, :FRETE, :SEGURO, :DESPESAS, :DESCONTO, :BASEICM, :ICMS, :BASESUBSTI, :IPI, :MERCADORIA, :OPERACAO)';
                //
                Form1.IBQuery1.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
                Form1.IBQuery1.ParamByName('EMISSAO').AsDateTime     := StrToDate(Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),9,2)+'/'+Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),6,2)+'/'+Copy(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/dhEmi')),1,4));
                Form1.IBQuery1.ParamByName('MODELO').AsString        := '55';
                Form1.IBQuery1.ParamByName('CLIENTE').AsString       := sNomeDaEmpresa;
                Form1.IBQuery1.ParamByName('NFEXML').AsString        := Form1.XMLDocument1.XML.Text;
                Form1.IBQuery1.ParamByName('NFEID').AsString         := pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//infProt/chNFe'));
                Form1.IBQuery1.ParamByName('STATUS').AsString        := pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//infProt/xMotivo'));
                Form1.IBQuery1.ParamByName('TOTAL').AsFloat          := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vNF')),'.',','));
                Form1.IBQuery1.ParamByName('FRETE').AsFloat          := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vFrete')),'.',','));
                Form1.IBQuery1.ParamByName('SEGURO').AsFloat         := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vSeg')),'.',','));
                Form1.IBQuery1.ParamByName('DESPESAS').AsFloat       := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vOutro')),'.',','));
                Form1.IBQuery1.ParamByName('DESCONTO').AsFloat       := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vDesc')),'.',','));
                Form1.IBQuery1.ParamByName('BASEICM').AsFloat        := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vBC')),'.',','));
                Form1.IBQuery1.ParamByName('ICMS').AsFloat           := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vICMS')),'.',','));
                Form1.IBQuery1.ParamByName('BASESUBSTI').AsFloat     := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vBCST')),'.',','));
                Form1.IBQuery1.ParamByName('IPI').AsFloat            := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vIPI')),'.',','));
                Form1.IBQuery1.ParamByName('MERCADORIA').AsFloat     := StrToFloat(StrTran(pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//total/ICMSTot/vProd')),'.',','));
                Form1.IBQuery1.ParamByName('OPERACAO').AsString      := pChar(xmlNodeValue(Form1.XMLDocument1.XML.Text, '//ide/natOp'));
                //
                Form1.IBQuery1.ExecSQL;
                //
              except end;
            end;
          end;
        end;
      end;
    end;
  except end;
  //
  Result := True;
  //
end;

function GetCNPJCertificado(SubjectName: String): String;
var
  iComposicao: Integer;
  sl: TStringList;
begin
  Result := '';
  sl := TStringList.Create;
  try
    sl.DelimitedText := '"' + StringReplace(SubjectName, ', ', '","', [rfReplaceAll]) + '"';
    sl.Delimiter := ',';
    for iComposicao := 0 to sl.Count - 1 do
    begin
      if AnsiUpperCase(Copy(sl.Strings[iComposicao], 1, 3)) = 'CN=' then
      begin
        Result := Copy(LimpaNumero(sl.Strings[iComposicao]),1,14);
//        Result := RightStr(LimpaNumero(sl.Strings[iComposicao]), 14);
        Break;
      end;
    end;
  except

  end;
  sl.Free;
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

procedure TForm1.FormActivate(Sender: TObject);
var
  SmallIni : tIniFile;
begin
  //
  RadioButton1.Font.Color := clWhite;
  RadioButton2.Font.Color := clRed;
  RadioButton3.Font.Color := clRed;
  //
  Label8.Caption := 'CONFIGURE O ACESSO AO'+Chr(10)+
                    'BANCO DE DADOS';
  //
  try
    GetDir(0,sAtual);
    Edit2.Text := sAtual;
  except end;
  //
  try
    SmallIni := TIniFile.Create(sAtual+'\small.ini');
    Edit1.Text := SmallIni.ReadString('Firebird','Server IP','');
    Edit2.Text := SmallIni.ReadString('Firebird','Server url',sAtual);
    SmallIni.Free;
  except end;
  //
  try
    if allTrim(Edit1.Text) = '' then Edit1.TExt := IdIPWatch1.LocalName;
    if allTrim(Edit1.Text) = '' then Edit1.TExt := GetIp;
  except end;
  //
  Label2.Caption := 'IP do servidor:';
  Label3.Caption := 'Endereço do arquivo no servidor:';
  Label5.Caption := 'Clique Ok para continuar.';
  //
  Label6.Caption := 'Selecione uma das opções abaixo e'+chr(10)+'clique em Ok para continuar.';
  //
  Label1.Repaint;
  //
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Winexec('TASKKILL /F /IM "firebird.exe"' , SW_HIDE );
  Halt(1);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  f: TextFile;
  sLinha : String;
  Mais1ini : tInifile;
  SmallIni : tIniFile;
  sData : String;
begin
  //
  Winexec('net start FirebirdGuardianDefaultInstance' , SW_HIDE );
  //
  if Panel1.Visible then
  begin
    //
    Panel1.Visible := False;
    //
    // Banco de dados em BRANCO
    //
    if RadioButton1.Checked then
    begin
      Label1.Caption := 'Atenção!'+Chr(10)+chr(10)
      +'Este assistente vai criar um novo Banco de'+Chr(10)+'dados "Client Server".';
    end;
    //
    // Convertendo banco de dados dbf
    //
    if RadioButton2.Checked then
    begin
      Label1.Caption := 'Atenção!'+Chr(10)+chr(10)
      +'Este assistente vai converter uma base de dados antiga para'+Chr(10)
      +'o novo Banco de dados "Client Server".';
      //
    end;
    //
    // Banco de dados exemplo
    //
    if RadioButton3.Checked then
    begin
      Label1.Caption := 'Atenção!'+Chr(10)+chr(10)
      +'Este assistente vai criar um Banco de dados "Client Server"'+Chr(10)
      +'com dados fictícios como exemplo para testes e demonstração.';
    end;
    //
  end else
  begin
    //
    SmallIni := TIniFile.Create(sAtual+'\small.ini');
    SmallIni.WriteString('Firebird','Server IP',Edit1.Text);
    SmallIni.WriteString('Firebird','Server URL',Edit2.TExt);
    SmallIni.Free;
    //
    if not FileExists('small.fdb') then
    begin
      //
      Label2.Visible := False;
      Label3.Visible := False;
      //
      Edit1.Visible := False;
      Edit2.Visible := False;
      //
      Form1.Repaint;
      //
      if AllTrim(Edit1.Text) <> '' then Url := Edit1.Text+':'+Edit2.Text+'\small.fdb' else Url := Edit2.Text+'\small.fdb';
      //
      Label1.Caption := 'Aguarde...!';
      //
      // Banco de dados em BRANCO
      //
      if RadioButton1.Checked then
      begin
        CopyFile('padrao.fdb','small.fdb',True);
      end;
      //
      // Banco de dados exemplo
      //
      if RadioButton3.Checked then
      begin
        //
        Label1.Caption := 'Aguarde!'+Chr(10)+chr(10)+'Criando os campos';
        Label1.Repaint;
        //
        //
        CopyFile('exemplo.fdb','small.fdb',True);
        //
        try
          //
          IBDatabase1.Close;
          IBDatabase1.Params.Clear;
          IbDatabase1.DatabaseName := url;
          IBDatabase1.Params.Add('USER_NAME=SYSDBA');
          IBDatabase1.Params.Add('PASSWORD=masterkey');
          IbDatabase1.Open;
          IBTransaction1.Active := True;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('select first 1 DATA from CAIXA order by DATA desc');
          Form1.ibQuery1.Open;
          //
          sData := FormatDateTime('yyyy-mm-dd',Form1.ibQuery1.FieldByname('DATA').AsDateTime);
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update CAIXA set DATA=(DATA+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update ALTERACA set DATA=(DATA+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update VENDAS set EMISSAO=(EMISSAO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update COMPRAS set EMISSAO=(EMISSAO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update RECEBER set EMISSAO=(EMISSAO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update RECEBER set VENCIMENTO=(VENCIMENTO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update RECEBER set RECEBIMENT=(RECEBIMENT+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update PAGAR set EMISSAO=(EMISSAO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update PAGAR set VENCIMENTO=(VENCIMENTO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update PAGAR set PAGAMENTO=(PAGAMENTO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update MOVIMENT set EMISSAO=(EMISSAO+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update MOVIMENT set PREDATA=(PREDATA+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('update MOVIMENT set COMPENS=(COMPENS+(CURRENT_DATE-Cast('+QuotedStr(sData)+' as date)))');
          Form1.ibQuery1.Open;
          //
          IBTransaction1.Commit;
          //
        except
          on E: Exception do  ShowMessage('Erro: '+E.Message);
        end;
        //
      end;
      //
      // Converter base antiga
      //
      if RadioButton2.Checked then
      begin
        //
        Button3.Enabled := False;
        //
        Label1.Caption := 'Aguarde!'+Chr(10)+chr(10)+'Procurando por arquivos XML';
        Label1.Repaint;
        //
        try
          //
          Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
          sCNPJ    := GetCNPJCertificado(AllTrim(Mais1ini.ReadString('NFE','Certificado','')));
          Mais1ini.Free;
          //
          if not CPFCGC(sCNPJ) then
          begin
            ShowMessage('CNPJ inválido.');
            sCNPJ := '';
          end;
          //
          if AllTrim(sCNPJ)='' then
          begin
            //
            while AllTrim(sCNPJ)='' do
            begin
              //
              sCNPJ := InputBox('Informe o CNPJ válido: ','CNPJ:',sCNPJ);
              //
              if not CPFCGC(sCNPJ) then
              begin
                ShowMessage('CNPJ inválido.');
                sCNPJ := '';
              end;
              //
            end;
            //
          end;
          //
          Label8.Caption := 'ESTAMOS TRABALHANDO NO SEU NOVO'+Chr(10)+
                            'BANCO DE DADOS';

          CopyFile('padrao.fdb','small.fdb',True);
          //
          Label1.Caption :=            'Aguarde!'+Chr(10)+
                                       chr(10)+
                                       'Estamos procurando por arquivos XML para o CNPJ: '+FormataCpfCgc(sCNPJ)+', este'+Chr(10)+
                                       'procedimento vai demorar não desligue o computador.';
          Label1.Visible := True;
          Label1.Repaint;
          //
//          Label4.Visible := True;
          Label4.Repaint;
          //
          Screen.Cursor := crAppStart;
          //
          IBDatabase1.Close;
          IBDatabase1.Params.Clear;
          IbDatabase1.DatabaseName := url;
          IBDatabase1.Params.Add('USER_NAME=SYSDBA');
          IBDatabase1.Params.Add('PASSWORD=masterkey');
          IbDatabase1.Open;
          IBTransaction1.Active := True;
          //
          try
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('create generator G_1');
            Form1.ibQuery1.ExecSQL;
          except end;
          //
          //
          DeleteFile('arquivos_.tmp');
          DeleteFile('arquivos_.txt');
          // ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C dir ' + 'C:\2019\*.XML /S/B >> arquivos_.tmp'), nil, SW_HIDE);
          ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C dir ' + 'C:\*.XML /S/B > arquivos_.tmp'), nil, SW_HIDE);
          while RenameFile(PChar('arquivos_.tmp'), PChar('arquivos_.txt')) = False do
          begin
            Application.ProcessMessages;
            Sleep(100);
          end;
          //
          AssignFile(F, 'arquivos_.txt');
          Reset(F);
          //
          X := 0;
          I := 0;
          //
          while not Eof(F) Do
          begin
            //
            ReadLn(F, sLinha);
            X := X + 1;
            //
          end;
          //
          tInicio := Time;
          Timer1.Enabled := True;
          Gauge1.Visible := True;
          //
          Reset(F);
          while not Eof(F) Do
          begin
            //
            I := I + 1;
            //
            ReadLn(F, sLinha);
            if (Pos('Recycle'   ,sLinha) = 0) and
               (Pos('templates' ,sLinha) = 0) and
               (Pos('samples'   ,sLinha) = 0) then
            begin
              Application.ProcessMessages;
              ImportaXML(sLinha);
            end;
          end;
          //
          IBTransaction1.Commit;
          IbDatabase1.Close;
          //
          Screen.Cursor := crDefault;
          //
          //
        except ShowMessage('Não foi possível criar o arquivo small.fdb verifique:'+chr(10)
        +chr(10)+'1 - Verifique se existe a pasta '+Edit2.Text
        +chr(10)+'2 - Desative o seu antivirus durante a instalação'
        +chr(10)+'3 - Desative o Firewal do Windows durante a instalação'
        +chr(10)+'4 - Verifique outros programas conflitantes') end;
        //
      end;
    end;
    //
    try
      SmallIni := TIniFile.Create(sAtual+'\small.ini');
      SmallIni.WriteString('Teste','C', pChar(Label4.Caption));
      SmallIni.Free;
    except end;
    //
    Label8.Visible := False;
    Label4.Visible := False;
    //
    Label1.Caption := 'Parabéns!'+Chr(10)+chr(10)
    +'Seu banco de dados "Client Server" foi criado e configurado'+Chr(10)
    +'com sucesso e está pronto para ser utilizado.';
    //
    Label2.Visible := False;
    Label3.Visible := False;
    //
    Edit1.Visible := False;
    Edit2.Visible := False;
    //
    Button3.Enabled := False;
    //
    Label1.Visible := True;
    Form1.Panel1.Visible := False;
    Form1.Repaint;
    //
    Sleep(2000);
    //
    Close;
    //
  end;
  //
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //
  if Copy(TimeToStr(Time - tInicio),1,5)='00:00' then Label4.Visible := True;
  //
  if X <> 0 then
  begin
    //
    Label4.Caption := 'Tempo decorrido           '+ TimeToStr(Time - tInicio)+chr(10)+
                      'Total de arquivos             '+ IntToStr(X)+chr(10)+
                      'Arquivos analizados       '+ IntToStr(I);

//    Label4.Repaint;
    Gauge1.Progress := I * 100 div X;
    Gauge1.Repaint;
    //
  end;
  //
end;

end.







