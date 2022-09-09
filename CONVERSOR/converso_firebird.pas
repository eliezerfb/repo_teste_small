unit converso_firebird;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBTables, DB, IBCustomDataSet, IBDatabase,
  ExtCtrls, SmallFunc, ComCtrls, IniFiles, ShellApi, IBQuery, Winsock,
  IdBaseComponent, IdComponent, IdIPWatch, XPMan, FileCtrl,
  msxmldom, Gauges, MSXML, StrUtils, TlHelp32, DBClient, Grids, DBGrids;

  const iTamanhoCliforEmail   = 80;
  const iTamanhoCliforBairro  = 35;
  const iTamanhoVendasEspecie = 13;
  const iTamanhoVendasMarca   = 13;

type
  TForma = record
    Forma: String;
    Valor: Double;
  end;

type

  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBQuery1: TIBQuery;
    IBQuery2: TIBQuery;
    IdIPWatch1: TIdIPWatch;
    XPManifest1: TXPManifest;
    Timer1: TTimer;
    IBQuery3: TIBQuery;
    Label4: TLabel;
    Label8: TLabel;
    IbqItens001: TIBQuery;
    IbqVendas: TIBQuery;
    IbqReceber: TIBQuery;
    IbqClifor: TIBQuery;
    IbqEstoque: TIBQuery;
    IbqNFCe: TIBQuery;
    IbqAlteraca: TIBQuery;
    Gauge1: TGauge;
    Label1: TLabel;
    Image1: TImage;
    Timer2: TTimer;
    IBQMUNICIPIOS: TIBQuery;
    IBQPAGAMENT: TIBQuery;
    Button5: TButton;
    Button3: TButton;
    Button1: TButton;
    Button7: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button7Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer2Timer(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

  private

    function xmlNodeValue2(sNode: String): String;
    procedure AdicionaNaListaImportacao(sCaminho: String; Data: TDate);
    function NomeMunicipio(sCodigo: String): String;
    procedure SalvaClifor();
    procedure AcumulaFormas(Forma, Valor: String);
    function ImportaXML(sP1: String): Boolean;
    function DescFormaPagamento(sCodigoForma: String): String;
    procedure GravaFormaPagamento(sForma: String; dValor: Double;
      sdtEmissao, sPedido, sCaixa, sClifor: String);

    { Private declarations }
  public
    { Public declarations }
    sMensagemPadrao, sUltimaNotaImportada : String;
    I, II, X : Integer;
    {iBanco,} iArquivo : Integer;
    sCNPJ, sAtual, Url, Url2, sURL, sIP : String;
    tInicio : tTime;

    FXMLNFE: IXMLDOMDocument;
    CDSBANCOS: TClientDataSet;
    // Sandro Silva 2019-11-01  CDSPAGAMENT: TClientDataSet;

    aForma: array of TForma; // Sandro Silva 2019-11-01
    {Usadas Clifor}
    sCNPJDest, sNomeDaEmpresa, sFone, sEmailClifor, sCEP: String;

  end;

var
  Form1: TForm1;
  tInicio : tTime;

implementation

{$R *.dfm}

function ConsultaProcesso(sP1: String): Boolean;
var
  Snapshot: THandle;
  ProcessEntry32: TProcessEntry32;
begin
  //
  Result   := False;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if (Snapshot = Cardinal(-1)) then exit;
  //
  ProcessEntry32.dwSize := SizeOf(TProcessEntry32);
  //
  // pesquisa pela lista de processos
  //
  if (Process32First(Snapshot, ProcessEntry32)) then
  repeat
    //
    // enquanto houver processos
    //
    if AnsiUpperCase(ProcessEntry32.szExeFile) = AnsiUpperCase(sP1) then Result := True;
    //
  until not Process32Next(Snapshot, ProcessEntry32);
  //
  CloseHandle(Snapshot);
  //
end;

function TForm1.xmlNodeValue2(sNode: String): String;
{Sandro Silva 2012-02-08 inicio
Extrai valor do elemento no xml}
var
  iNode: Integer;
  xNodes: IXMLDOMNodeList;
begin
  Result := '';
  xNodes := FXMLNFE.selectNodes(sNode);
  for iNode := 0 to xNodes.length -1 do
  begin
    Result := xNodes.item[iNode].text;
  end;
end;

function TForm1.DescFormaPagamento(sCodigoForma: String): String;
begin
  // Codificação das formas de pagamento compatíveis nos manuais do SAT e NFC-e
  case StrToIntDef(sCodigoForma, 99) of
    02://  02 - Cheque
      Result := '01 Em cheque';
    03://  03 - Cartão de Crédito
      Result := '03 Cartao CREDITO';
    04://  04 - Cartão de Débito
      Result := '03 Cartao DEBITO';
    05://  05 - Crédito Loja
      Result := '04 A prazo NFC-e';
    10://  10 - Vale Alimentação
      Result := '05 Vale Alimentacao';
    11://  11 - Vale Refeição
      Result := '06 Vale Refeicao';
    12://  12 - Vale Presente
      Result := '07 Vale Presente';
    13://  13 - Vale Combustível
      Result := '08 Vale Combustivel';
  else // 01 - Dinheiro e outros formas
    Result := '02 Dinheiro NFC-e';
  end;
end;

procedure TForm1.AcumulaFormas(Forma: String; Valor: String);
var
  iForma: Integer;
  bAchou: Boolean;
begin
  bAchou := False;
  for iForma := 0 to Length(aForma) -1 do
  begin
    if aForma[iForma].Forma = Forma then
    begin
      bAchou := True;
      Break;
    end;
  end;
  if bAchou = False then
  begin
    SetLength(aForma, Length(aForma) + 1);
    aForma[High(aForma)].Forma := Forma;
  end;
  aForma[High(aForma)].Valor := aForma[High(aForma)].Valor + StrToFloatDef(StringReplace(Valor, '.', ',', [rfReplaceAll]), 0);
end;

procedure TForm1.GravaFormaPagamento(sForma: String; dValor: Double;
  sdtEmissao: String; sPedido: String; sCaixa: String; sClifor: String);
begin
  if AnsiContainsText(sForma, 'Total') then
  begin
    dValor := dValor * (-1);// Total deve ficar negativo
  end;
  try
    Form1.IBQPAGAMENT.ParamByName('DATA').AsDate       := StrToDate(sdtEmissao);
    Form1.IBQPAGAMENT.ParamByName('PEDIDO').AsString   := RightStr(sPedido, 6);
    Form1.IBQPAGAMENT.ParamByName('CAIXA').AsString    := sCaixa;
    Form1.IBQPAGAMENT.ParamByName('CLIFOR').AsString   := sClifor;
    if Form1.IBQPAGAMENT.ParamByName('CLIFOR').AsString = '' then
      Form1.IBQPAGAMENT.ParamByName('CLIFOR').Clear;
    Form1.IBQPAGAMENT.ParamByName('FORMA').AsString    := sForma;
    Form1.IBQPAGAMENT.ParamByName('VALOR').AsFloat     := dValor;
    if (Form1.IBQPAGAMENT.ParamByName('VALOR').AsString = '0.00') and (sForma = '13 Troco') then
      Form1.IBQPAGAMENT.ParamByName('VALOR').Clear;
    Form1.IBQPAGAMENT.ParamByName('CCF').AsString      := Form1.IBQPAGAMENT.ParamByName('PEDIDO').AsString;
    Form1.IBQPAGAMENT.ParamByName('COO').AsString      := Form1.IBQPAGAMENT.ParamByName('PEDIDO').AsString;
    if AnsiContainsText(sForma, 'cheque') or AnsiContainsText(sForma, 'cartao') or AnsiContainsText(sForma, 'prazo') then
      Form1.IBQPAGAMENT.ParamByName('GNF').AsString :=  Form1.IBQPAGAMENT.ParamByName('PEDIDO').AsString; // (qdo cheque, cartao, prazo,
    Form1.IBQPAGAMENT.ExecSQL;
  except
  end;

end;

function TForm1.ImportaXML(sP1: String):Boolean;
const iTamanhoCliforEmail   = 80;
const iTamanhoCliforBairro  = 35;
const iTamanhoVendasEspecie = 13;
const iTamanhoVendasMarca   = 13;
var
  xNodeItens: IXMLDOMNodeList;
  fqTrib, fvUnCom : Real;
  sNDup, sdtEmissao, sEAN, sCFOP, sNatOp, sMod, sSerie, snNF, sCStat, sDataVencimento, sValorDuplicata, scodigo, sNumeroDaNota, sDescricao, sContaAtiva,
  sNItemPed, sXPED, sIPITribCST, sCSTIPI, sPISOutrCST, sPISQtdeCST, sPathICMSItem, sTipoItem, sNCM, sPathCSOSN, sOrigem, sCSTPisCofins, sCSOSN, sCSTICMS,
  sPISAliqCST, sFrete12, sCaixa, sEnder: String;
  sHoraEmissao: String; // Sandro Silva 2019-11-01
  iNode : Integer;
  iSequenciaParcelaBalcao: Integer; // Sandro Silva 2019-11-01
  dAliqICMS, dValorIPI, dRedBC, dValorIcmsST, dValorBCIcmsST, dValorBCIcms, dValorICMS, dAliqIPI, dPIVA, dAliqPIS, dAliqCOFINS, dDesconto: Double;
  dOutros: Double; // Sandro Silva 2019-11-01
  stpNF: String; // Sandro Silva 2019-11-03
  scEnqIPI: String; // Sandro Silva 2019-11-04
begin
  //
  // A Chave de Acesso de um Documento Fiscal: NF-e, CT-e, NFC-e e MDF-e é formada pelas seguintes informações:
  //
  // cUF - Código da UF do emitente do Documento Fiscal;
  // AAMM - Ano e Mês de emissão da NF-e;
  // CNPJ - CNPJ do emitente;
  // mod - Modelo do Documento Fiscal;
  // serie - Série do Documento Fiscal;
  // nNF - Número do Documento Fiscal;
  // tpEmis – forma de emissão da NF-e;
  // cNF - Código Numérico que compõe a Chave de Acesso;
  // cDV - Dígito Verificador da Chave de Acesso.
  //       xxxxxxxxxxxxxx..xxx..........
  // 42190907426598000124550010000977381004640327-nfe
  //
  try
    //
    sMod   := Form1.IBQuery3.FieldByname('MODELO').AsString;
    sSerie := Form1.IBQuery3.FieldByname('SERIE').AsString;
    snNF   := Form1.IBQuery3.FieldByname('NUMERONF').AsString;
    scStat := Form1.IBQuery3.FieldByname('CSTAT').AsString;
    //
    sCNPJDest      := '';
    sNomeDaEmpresa := '';
    sFone          := '';
    sEmailClifor   := '';
    sCEP           := '';
    //
    if sMod = '59' then
    begin
      if snNF+sSerie+scStat <> Form1.sUltimaNotaImportada then // Sandro Silva 2019-11-01 if snNF+sSerie <> Form1.sUltimaNotaImportada then
      begin

        if ((sCStat='100') or (sCStat='150')) then
        begin

          try
            Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
          except end;

          if (Trim(Form1.xmlNodeValue2('//CFe/infCFe/@versao')) <> '') then
          begin
            {
            sNumeroDaNota := StrZero(StrToFloat(Form1.xmlNodeValue2('//nCFe')),6,0);
            sdtEmissao     := Form1.xmlNodeValue2('//ide/dEmi');
            if sdtEmissao <> '' then
              sdtEmissao     := Copy(sDtEmissao,7,2)+'/'+Copy(sDtEmissao,5,2)+'/'+Copy(sdtEmissao,1,4);
            sNomeDaEmpresa := PrimeiraMaiuscula(Trim(Copy((Trim(Form1.xmlNodeValue2('//dest/xNome')))+replicate(' ',60),1,60)));
            sEnder         := Form1.xmlNodeValue2('//entrega/xLgr');
            sCNPJDest      := Form1.xmlNodeValue2('//dest/CNPJ');
            sCaixa         := Right('000' + Form1.xmlNodeValue2('//ide/numeroCaixa'), 3);
            sFone          := ''; // S@t não têm no xml
            sCEP           := ''; // S@t não têm no xml
            }

            // Sandro Silva 2019-11-01 Form1.sUltimaNotaImportada := snNF+sSerie;

            if Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ then
            begin

              Form1.sUltimaNotaImportada := snNF+sSerie+scStat;

              try
                sNumeroDaNota := StrZero(StrToFloat(Form1.xmlNodeValue2('//nCFe')),6,0);
                sdtEmissao     := Form1.xmlNodeValue2('//ide/dEmi');
                if sdtEmissao <> '' then
                  sdtEmissao     := Copy(sDtEmissao,7,2)+'/'+Copy(sDtEmissao,5,2)+'/'+Copy(sdtEmissao,1,4);
                sHoraEmissao := Form1.xmlNodeValue2('//ide/hEmi'); // Sandro Silva 2019-11-01
                sHoraEmissao := Copy(sHoraEmissao, 1, 2) + ':' + Copy(sHoraEmissao, 3, 2) + ':' + Copy(sHoraEmissao, 5, 2); // Sandro Silva 2019-11-01

                sNomeDaEmpresa := PrimeiraMaiuscula(Trim(Copy((Trim(Form1.xmlNodeValue2('//dest/xNome')))+replicate(' ',60),1,60)));
                sEnder         := Form1.xmlNodeValue2('//entrega/xLgr');
                sCNPJDest      := Form1.xmlNodeValue2('//dest/CNPJ');
                sCaixa         := Right('000' + Form1.xmlNodeValue2('//ide/numeroCaixa'), 3);
                sFone          := ''; // S@t não têm no xml
                sCEP           := ''; // S@t não têm no xml

                if sCNPJDest = '' then
                  sCNPJDest      := Form1.xmlNodeValue2('//dest/CPF');

                Form1.ibQuery1.Close;
                Form1.ibQuery1.SQL.Clear;
                Form1.ibQuery1.SQL.Add('select CGC, NOME from CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(Trim(sCNPJDest)))+' ');
                Form1.ibQuery1.Open;
                //
                if ( (Form1.IBQuery1.FieldByName('CGC').AsString <> ConverteCpfCgc(Trim(sCNPJDest))) and (Trim(sCNPJDest) <> '') and (sNomeDaEmpresa <> '') and (sEnder <> '')) then
                begin
                  //
                  // Importa Cliente
                  //
                  try
                    Form1.SalvaClifor;
                    {
                    //
                    Form1.IbqClifor.ParamByName('CGC').AsString      := ConverteCpfCgc(Trim(sCNPJDest));
                    Form1.IbqClifor.ParamByName('NOME').AsString     := sNomeDaEmpresa;
                    Form1.IbqClifor.ParamByName('IE').AsString       := Form1.xmlNodeValue2('//dest/IE');
                    Form1.IbqClifor.ParamByName('ENDERE').AsString   := Copy(PrimeiraMaiuscula(CaracteresHTML(( StringReplace(Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr')), ',', ' ', [rfReplaceAll])))+', '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40); // Sandro Silva 2019-10-31 Form1.IbqClifor.ParamByName('ENDERE').AsString   := Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr'))))+' '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40);;
                    Form1.IbqClifor.ParamByName('COMPLE').AsString   := Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xBairro'))))), 1, iTamanhoCliforBairro);
                    // Sandro Silva 2019-10-31 inicio
                    Form1.IbqClifor.ParamByName('CIDADE').AsString   := Form1.NomeMunicipio(Trim(Form1.xmlNodeValue2('//dest/enderDest/cMun')));
                    if Form1.IbqClifor.ParamByName('CIDADE').AsString = '' then
                    // Sandro Silva 2019-10-31 fim
                      Form1.IbqClifor.ParamByName('CIDADE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xMun')))))+Replicate(' ',40),1,40));
                    Form1.IbqClifor.ParamByName('ESTADO').AsString   := Form1.xmlNodeValue2('//dest/enderDest/UF');
                    Form1.IbqClifor.ParamByName('CEP').AsString      := Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),1,5)+'-'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),5,3);
                    // Sandro Silva 2019-10-31 inicio
                    //Form1.IbqClifor.ParamByName('FONE').AsString     := '(0xx'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),1,2)+')'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),2,9);
                    if Copy(sFone, 1, 1) = '0' then
                      sFone := Copy(sFone, 2, 14);
                    if Length(sFone) < 10 then
                      Form1.IbqClifor.ParamByName('FONE').AsString     := Trim(sFone)
                    else
                      Form1.IbqClifor.ParamByName('FONE').AsString     := '(0xx'+Copy(Trim(sFone),1,2)+')'+Copy(Trim(sFone),3,9);
                    // Sandro Silva 2019-10-31 fim

                    if LimpaNumero(ConverteCpfCgc(Trim(sCNPJDest))) = '' then
                      Form1.IbqClifor.ParamByName('CGC').Clear;

                    sEmailClifor := Copy(Trim(Form1.xmlNodeValue2('//enderEmit/email')), 1, iTamanhoCliforEmail);
                    if sEmailClifor <> '' then
                      Form1.IbqClifor.ParamByName('EMAIL').AsString := sEmailClifor
                    else
                      Form1.IbqClifor.ParamByName('EMAIL').Clear;

                    Form1.IbqClifor.ExecSQL;
                    //
                  except end;
                  //
                  }
                  except end;
                //
                // Fim do importa Cliente
                //
                end else
                begin
                  sNomeDaEmpresa := Form1.IBQuery1.FieldByName('NOME').AsString;
                end;
              except end;

              try
                //
                // Percore os itens da nota
                //
                xNodeItens := Form1.FXMLNFE.selectNodes('//det');
                //
                for iNode := 0 to xNodeItens.length -1 do
                begin
                  //
                  // Zerezima
                  //
                  dPIVA          := 0;
                  dAliqICMS      := 0;
                  sCSTIPI        := '';
                  sCSTICMS       := '';
                  sXPED          := '';
                  sNItemPed      := '';
                  scEnqIPI        := ''; // Sandro Silva 2019-11-04
                  //
                  // Sandro Silva 2019-11-01  dDesconto      := 0;
                  //sCSTIPI        := '';
                  //sCSTICMS       := '';
                  //sXPED          := '';
                  //sNItemPed      := '';
                  //
                  if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP')) <> '' then sCFOP := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));
                  //
                  fqTrib    := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/qCom'),'.',','));
                  fvUnCom   := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/vUnCom'),'.',','));
                  //
                  if (fqTrib<>0) and (fvUnCom<>0) then
                  begin
                    //
                    sDescricao := Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd')), 1, 45); // Sandro Silva 2019-11-01 sDescricao := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd'));
                    sCodigo    := '';
                    dDesconto  := StrToFloatDef(StringReplace(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/vDesc'), '.', ',', [rfReplaceAll]), 0);
                    //
                    try
                      sEAN       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/cEAN'));
                    except
                      sEAN  := '';
                    end;
                    //
                    if (sEAN = '') or (sEAN = 'SEM GTIN') then
                    begin
                      //
                      Form1.ibQuery1.Close;
                      Form1.ibQuery1.Sql.Clear;
                      Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(sDescricao)+' ');
                      Form1.ibQuery1.Open;
                      //
                      if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                      begin
                        sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                        sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                      end;
                      //
                    end else
                    begin
                      //
                      Form1.ibQuery1.Close;
                      Form1.ibQuery1.Sql.Clear;
                      Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where REFERENCIA='+QuotedStr(sEAN)+' ');
                      Form1.ibQuery1.Open;
                      //
                      if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                      begin
                        sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                        sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                      end;
                      //
                    end;
                    //


                    try
                      sTipoItem := '00'; // Inicia considerando que é produto para revenda
                      if (Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vBC')) <> '') then
                        sTipoItem := '09'; // Identificou que tem elemento referente a serviço troca o tipo para serviço

                      sNCM        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'));
                      sCFOP       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));

                      sCSOSN     := '';
                      sPathCSOSN := '';
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/CSOSN')) <> '' then // 101
                        sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/'
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/CSOSN')) <> '' then // 102
                          sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/'
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/CSOSN')) <> '' then // 201
                            sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/'
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/CSOSN')) <> '' then // 202
                              sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/'
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/CSOSN')) <> '' then // 500
                                sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/'
                              else
                                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/CSOSN')) <> '' then // 900
                                  sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/';


                      dAliqICMS      := 0;

                      if sPathCSOSN <> '' then
                      begin
                        sCSOSN  := Trim(Form1.xmlNodeValue2(sPathCSOSN + 'CSOSN'));
                        sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'orig')) + '0', 1, 1);
                        dAliqICMS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                      end;

                      sPathICMSItem := '';
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/CST')) <> '' then
                      begin
                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/';
                      end
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/CST')) <> '' then
                        begin
                          sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/';
                        end
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/CST')) <> '' then
                          begin
                            sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/';
                          end
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/CST')) <> '' then
                            begin
                              sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/';
                            end
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/CST')) <> '' then
                              begin
                                sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/';
                              end
                              else
                                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/CST')) <> '' then
                                begin
                                  sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/';
                                end
                                else
                                  if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/CST')) <> '' then
                                  begin
                                    sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/';
                                  end
                                  else
                                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/CST')) <> '' then
                                    begin
                                      sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/';
                                    end
                                    else
                                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/CST')) <> '' then
                                      begin
                                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/';
                                      end
                                      else
                                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/CST')) <> '' then
                                        begin
                                          sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/';
                                        end;

                      sCSTICMS   := Trim(Form1.xmlNodeValue2(sPathICMSItem + 'CST'));

                      if (sCSTICMS <> '') then
                      begin
                        //
                        // Na NFe o CST ICMS é listado com 2 casas. Concatenar a origem
                        //
                        sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'orig')) + '0', 1, 1);
                        sCSTICMS := sOrigem + sCSTICMS;
                        //
                        dAliqICMS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                        dPIVA          := 0.00; // SAT não tem a tag pMVAST // Sandro Silva 2019-11-01 dPIVA          := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pMVAST')), '.', ',', [rfReplaceAll]), 0) / 100; 
                      end;

                      sCSTPisCofins := '';

                      // Localiza o CST para o PIS e a COFINS e a Alíquota para o PIS
                      sPISAliqCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/CST'));
                      if sPISAliqCST <> '' then
                      begin
                        sCSTPisCofins := sPISAliqCST;
                        dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/pPIS')), '.', ',', [rfReplaceAll]), 0);
                        dAliqPIS      := dAliqPIS * 100;
                      end
                      else
                      begin
                        sPISQtdeCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/CST'));
                        if sPISQtdeCST <> '' then
                        begin
                          sCSTPisCofins := sPISQtdeCST;
                          dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          sPISOutrCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/CST'));
                          if sPISOutrCST <> '' then
                          begin
                            sCSTPisCofins := sPISOutrCST;
                            dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/pPIS')), '.', ',', [rfReplaceAll]), 0);
                          end
                          else
                          begin
                            sCSTPisCofins := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISNT/CST'));
                            dAliqPIS      := 0;
                          end;
                        end;
                      end;

                      if dAliqPIS = 0 then
                      begin
                        dAliqPIS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PISST/pPIS')), '.', ',', [rfReplaceAll]), 0);
                        dAliqPIS := dAliqPIS * 100;
                      end;

                      // Localiza a Alíquota para a COFINS
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/CST')) <> '' then
                      begin
                        dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                        dAliqCOFINS := dAliqCOFINS * 100;
                      end
                      else
                      begin
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/CST')) <> '' then
                        begin
                          dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/CST')) <> '' then
                          begin
                            dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                          end
                          else
                          begin
                            dAliqCOFINS := 0;
                          end;
                        end;
                      end;

                      if dAliqCOFINS = 0 then
                      begin
                        dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINSST/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                        dAliqCOFINS := dAliqCOFINS * 100;
                      end;

                      sCSTIPI := '';
                      sIPITribCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/CST'));
                      if sIPITribCST <> '' then
                        sCSTIPI := sIPITribCST
                      else
                        sCSTIPI := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPINT/CST'));

                      //dValorIPI := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/vIPI')), '.', ',', [rfReplaceAll]), 0);

                      sXPED     := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xPed'));
                      sNItemPed := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nItemPed'));

                      if (sCodigo='') then
                      begin
                        //
                        // Produto novo
                        //
                        Form1.ibQuery1.Close;
                        Form1.ibQuery1.Sql.Clear;
                        Form1.ibQuery1.Sql.Add('select gen_id(G_ESTOQUE,1) from rdb$database');
                        Form1.ibQuery1.Open;
                        //
                        sCodigo    := StrZero(StrtoFloat(Form1.ibQuery1.FieldByname('GEN_ID').AsString),5,0);
                        //
                        Form1.IbqEstoque.ParamByName('REGISTRO').AsString      := '00000'+sCodigo;
                        Form1.IbqEstoque.ParamByName('CODIGO').AsString        := sCodigo;
                        Form1.IbqEstoque.ParamByName('REFERENCIA').AsString    := sEAN;
                        Form1.IbqEstoque.ParamByName('DESCRICAO').AsString     := sDescricao;
                        Form1.IbqEstoque.ParamByName('MEDIDA').AsString        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                        Form1.IbqEstoque.ParamByName('PRECO').AsFloat          := fvUnCom;
                        Form1.IbqEstoque.ParamByName('CF').AsString            := Trim(Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'))+Replicate(' ',45),1,45));
                        Form1.IbqEstoque.ParamByName('CODIGO_FCI').AsString    := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nFCI'));
                        Form1.IbqEstoque.ParamByName('ULT_VENDA').AsDate       := StrToDate(sdtEmissao);

                        Form1.IbqEstoque.ParamByName('CSOSN').Clear;

                        if sCFOP <> '' then
                          Form1.IbqEstoque.ParamByName('CFOP').AsString := sCFOP
                        else
                          Form1.IbqEstoque.ParamByName('CFOP').Clear;

                        Form1.IbqEstoque.ParamByName('CST').Clear;
                        Form1.IbqEstoque.ParamByName('TIPO_ITEM').AsString  := sTipoItem;

                        Form1.IbqEstoque.ParamByName('CST_PIS_COFINS_SAIDA').AsString  := sCSTPisCofins;
                        Form1.IbqEstoque.ParamByName('ALIQ_PIS_SAIDA').AsFloat         := dAliqPIS;
                        Form1.IbqEstoque.ParamByName('ALIQ_COFINS_SAIDA').AsFloat      := dAliqCOFINS;

                        if sTipoItem <> '09' then
                        begin
                          if Trim(sCSOSN) <> '' then
                          begin
                            Form1.IbqEstoque.ParamByName('CSOSN').AsString    := sCSOSN;
                            Form1.IbqEstoque.ParamByName('CST').AsString      := sOrigem;
                          end
                          else
                            if Trim(sCSTICMS) <> '' then
                            begin
                              Form1.IbqEstoque.ParamByName('CSOSN').Clear;
                              Form1.IbqEstoque.ParamByName('CST').AsString    := sCSTICMS;
                            end;
                        end;

                        if (dPIVA > 0) and (sTipoItem <> '09') then
                          Form1.IbqEstoque.ParamByName('PIVA').AsFloat := StrToFloat(FormatFloat('0.0000', dPIVA))
                        else
                          Form1.IbqEstoque.ParamByName('PIVA').Clear;

                        //
                        Form1.IbqEstoque.ExecSQL;
                        //
                      end;
                    except  end;
                    //
                    try
                      //
                      //
                      // Itens da Nota Fiscal - S@T - Salva ALTERACA
                      if Trim(sCODIGO) <> '' then
                      begin
                        //
                        Form1.IbqAlteraca.ParamByName('CODIGO').AsString         := sCodigo;;
                        Form1.IbqAlteraca.ParamByName('DESCRICAO').AsString      := sDescricao;
                        Form1.IbqAlteraca.ParamByName('QUANTIDADE').AsFloat      := fqTrib;
                        Form1.IbqAlteraca.ParamByName('MEDIDA').AsString         := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                        Form1.IbqAlteraca.ParamByName('UNITARIO').AsFloat        := fvUnCom;
                        Form1.IbqAlteraca.ParamByName('TOTAL').AsFloat           := fvUnCom*fqTrib;
                        Form1.IbqAlteraca.ParamByName('DATA').AsDate             := StrToDate(sdtEmissao);
                        Form1.IbqAlteraca.ParamByName('TIPO').AsString           := 'BALCAO';
                        Form1.IbqAlteraca.ParamByName('PEDIDO').AsString         := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('ITEM').AsString           := StrZero(iNode+1, 6, 0);
                        Form1.IbqAlteraca.ParamByName('CLIFOR').AsString         := sNomeDaEmpresa;
                        Form1.IbqAlteraca.ParamByName('CAIXA').AsString          := sCaixa;
                        Form1.IbqAlteraca.ParamByName('CST_PIS_COFINS').AsString := sCSTPisCofins;
                        Form1.IbqAlteraca.ParamByName('DESCONTO').Clear; // Sandro Silva 2019-11-01 Form1.IbqAlteraca.ParamByName('DESCONTO').AsFloat        := dDesconto;
                        Form1.IbqAlteraca.ParamByName('COO').AsString            := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('CCF').AsString            := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('CNPJ').AsString           := sCNPJDest;
                        Form1.IbqAlteraca.ParamByName('REFERENCIA').AsString     := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/cEAN'));
                        Form1.IbqAlteraca.ParamByName('HORA').AsString           := sHoraEmissao;
                        Form1.IbqAlteraca.ParamByName('CFOP').AsString           := sCFOP;
                        Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString       := sCSTICMS;
                        Form1.IbqAlteraca.ParamByName('CSOSN').AsString          := sCSOSN;

                        if sTipoItem = '09' then // Identificou que tem elemento referente a serviço
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'ISS'
                        else
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := StrZero((dAliqICMS * 100), 4, 0);

                        if Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString <> '' then
                        begin
                          if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '40' then // – Isenta
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'I';
                          if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '41' then // – Não tributada
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'N';
                          if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '60' then // – ICMS cobrado anteriormente por substituição tributária
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'F';
                        end;

                        if Form1.IbqAlteraca.ParamByName('CSOSN').AsString <> '' then
                        begin
                          if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '300' then // – Isenta
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'I';
                          if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '400' then // – Não tributada
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'N';
                          if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '500' then // – ICMS cobrado anteriormente por substituição tributária
                            Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'F';
                        end;

                        if Form1.IbqAlteraca.ParamByName('CFOP').AsString = '' then
                          Form1.IbqAlteraca.ParamByName('CFOP').Clear;

                        if Form1.IbqAlteraca.ParamByName('CSOSN').AsString = '' then
                          Form1.IbqAlteraca.ParamByName('CSOSN').Clear;

                        if Trim(Form1.IbqAlteraca.ParamByName('CNPJ').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('CNPJ').Clear;

                        if Trim(Form1.IbqAlteraca.ParamByName('CLIFOR').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;

                        if Trim(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('CST_ICMS').Clear;

                        if Trim(Form1.IbqAlteraca.ParamByName('REFERENCIA').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;

                        {Sandro Silva 2019-11-01 inicio 
                        // Ajusta valor dos campos quando estiver incluindo DESCONTO
                        if (sDescricao = 'Desconto') or (sDescricao = 'Acréscimo') then
                        begin
                          Form1.IbqAlteraca.ParamByName('CODIGO').Clear;
                          Form1.IbqAlteraca.ParamByName('MEDIDA').Clear;
                          Form1.IbqAlteraca.ParamByName('ITEM').Clear;
                          if sDescricao = 'Desconto' then
                          begin

                            if sCodigo <> '' then
                            begin
                              Form1.IbqAlteraca.ParamByName('ITEM').AsString   := StrZero(iNode, 6, 0);// Gravando desconto do item importado anteriormente
                              Form1.IbqAlteraca.ParamByName('CODIGO').AsString := sCodigo;
                            end;

                            Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;
                            Form1.IbqAlteraca.ParamByName('VENDEDOR').Clear;
                            Form1.IbqAlteraca.ParamByName('CNPJ').Clear;
                          end;
                          Form1.IbqAlteraca.ParamByName('VALORICM').Clear;
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').Clear;
                          Form1.IbqAlteraca.ParamByName('DESCONTO').Clear;
                          Form1.IbqAlteraca.ParamByName('COO').Clear;
                          Form1.IbqAlteraca.ParamByName('CCF').Clear;
                          Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                        end;
                        }
                        //
                        Form1.IbqAlteraca.ExecSQL;
                        //
                        {Aqui colocar rotina para salvar desconto e acrescimo}
                        //
                      end;
                      //
                    except end;
                    //
                    // Sandro Silva 2019-11-01 inicio
                    // Desconto sobre o total do item
                    if (dDesconto > 0) then
                    begin
                      try
                        //
                        Form1.IbqAlteraca.ParamByName('ITEM').AsString           := StrZero(iNode+1, 6, 0);
                        Form1.IbqAlteraca.ParamByName('DESCRICAO').AsString      := 'Desconto';
                        Form1.IbqAlteraca.ParamByName('QUANTIDADE').AsFloat      := 1;
                        Form1.IbqAlteraca.ParamByName('UNITARIO').AsFloat        := dDesconto * (-1);
                        Form1.IbqAlteraca.ParamByName('TOTAL').AsFloat           := dDesconto * (-1);
                        Form1.IbqAlteraca.ParamByName('DATA').AsDate             := StrToDate(sdtEmissao);
                        Form1.IbqAlteraca.ParamByName('HORA').AsString           := sHoraEmissao;
                        Form1.IbqAlteraca.ParamByName('TIPO').AsString           := 'BALCAO';
                        Form1.IbqAlteraca.ParamByName('PEDIDO').AsString         := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('CLIFOR').AsString         := sNomeDaEmpresa;
                        Form1.IbqAlteraca.ParamByName('CAIXA').AsString          := sCaixa;
                        Form1.IbqAlteraca.ParamByName('COO').AsString            := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('CCF').AsString            := sNumeroDaNota;
                        Form1.IbqAlteraca.ParamByName('CNPJ').AsString           := sCNPJDest;
                        if Trim(Form1.IbqAlteraca.ParamByName('CNPJ').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('CNPJ').Clear;
                        if Trim(Form1.IbqAlteraca.ParamByName('CLIFOR').AsString) = '' then
                          Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;

                        Form1.IbqAlteraca.ParamByName('CODIGO').Clear;
                        Form1.IbqAlteraca.ParamByName('MEDIDA').Clear;
                        Form1.IbqAlteraca.ParamByName('CST_PIS_COFINS').Clear;
                        Form1.IbqAlteraca.ParamByName('DESCONTO').Clear; 
                        Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                        Form1.IbqAlteraca.ParamByName('ALIQUICM').Clear;
                        Form1.IbqAlteraca.ParamByName('CFOP').Clear;
                        Form1.IbqAlteraca.ParamByName('CSOSN').Clear;
                        Form1.IbqAlteraca.ParamByName('CST_ICMS').Clear;
                        Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;

                        //
                        Form1.IbqAlteraca.ExecSQL;
                        //
                      except end;
                    end; // if (dDesconto > 0) then
                    // Sandro Silva 2019-11-01 fim 
                  end; // if (fqTrib<>0) and (fvUnCom<>0) then
                  //
                end; // for iNode := 0 to xNodeItens.length -1 do

                // Sandro Silva 2019-11-01 inicio
                // Seleciona acréscimo sobre o subtotal
                dOutros := StrToFloatDef(StringReplace(Form1.xmlNodeValue2('//total/DescAcrEntr/vAcresSubtot'), '.', ',', [rfReplaceAll]), 0);

                if (dOutros > 0) then
                begin
                  try
                    //
                    //
                    // Acréscimo subtotal
                    //
                    Form1.IbqAlteraca.ParamByName('DESCRICAO').AsString      := 'Acréscimo';
                    Form1.IbqAlteraca.ParamByName('QUANTIDADE').AsFloat      := 1;
                    Form1.IbqAlteraca.ParamByName('UNITARIO').AsFloat        := dOutros;
                    Form1.IbqAlteraca.ParamByName('TOTAL').AsFloat           := dOutros;
                    Form1.IbqAlteraca.ParamByName('DATA').AsDate             := StrToDate(sdtEmissao);
                    Form1.IbqAlteraca.ParamByName('HORA').AsString           := sHoraEmissao;
                    Form1.IbqAlteraca.ParamByName('TIPO').AsString           := 'BALCAO';
                    Form1.IbqAlteraca.ParamByName('PEDIDO').AsString         := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CLIFOR').AsString         := sNomeDaEmpresa;
                    Form1.IbqAlteraca.ParamByName('CAIXA').AsString          := sCaixa;
                    Form1.IbqAlteraca.ParamByName('COO').AsString            := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CCF').AsString            := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CNPJ').AsString           := sCNPJDest;
                    if Trim(Form1.IbqAlteraca.ParamByName('CNPJ').AsString) = '' then
                      Form1.IbqAlteraca.ParamByName('CNPJ').Clear;
                    if Trim(Form1.IbqAlteraca.ParamByName('CLIFOR').AsString) = '' then
                      Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;

                    Form1.IbqAlteraca.ParamByName('ITEM').Clear;
                    Form1.IbqAlteraca.ParamByName('CODIGO').Clear;
                    Form1.IbqAlteraca.ParamByName('MEDIDA').Clear;
                    Form1.IbqAlteraca.ParamByName('CST_PIS_COFINS').Clear;
                    Form1.IbqAlteraca.ParamByName('DESCONTO').Clear;
                    Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                    Form1.IbqAlteraca.ParamByName('ALIQUICM').Clear;
                    Form1.IbqAlteraca.ParamByName('CFOP').Clear;
                    Form1.IbqAlteraca.ParamByName('CSOSN').Clear;
                    Form1.IbqAlteraca.ParamByName('CST_ICMS').Clear;
                    Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;

                    //
                    Form1.IbqAlteraca.ExecSQL;
                    //
                  except end;
                end;// if (dOutros > 0) then

                // Desconto sobre o subtotal
                dDesconto := StrToFloatDef(StringReplace(Form1.xmlNodeValue2('//total/DescAcrEntr/vDescSubtot'), '.', ',', [rfReplaceAll]), 0);

                if (dDesconto > 0) then
                begin
                  try
                    //
                    //
                    // Desconto subtotal
                    //
                    Form1.IbqAlteraca.ParamByName('DESCRICAO').AsString      := 'Desconto';
                    Form1.IbqAlteraca.ParamByName('QUANTIDADE').AsFloat      := 1;
                    Form1.IbqAlteraca.ParamByName('UNITARIO').AsFloat        := dDesconto * (-1);
                    Form1.IbqAlteraca.ParamByName('TOTAL').AsFloat           := dDesconto * (-1);
                    Form1.IbqAlteraca.ParamByName('DATA').AsDate             := StrToDate(sdtEmissao);
                    Form1.IbqAlteraca.ParamByName('HORA').AsString           := sHoraEmissao;
                    Form1.IbqAlteraca.ParamByName('TIPO').AsString           := 'BALCAO';
                    Form1.IbqAlteraca.ParamByName('PEDIDO').AsString         := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CLIFOR').AsString         := sNomeDaEmpresa;
                    Form1.IbqAlteraca.ParamByName('CAIXA').AsString          := sCaixa;
                    Form1.IbqAlteraca.ParamByName('COO').AsString            := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CCF').AsString            := sNumeroDaNota;
                    Form1.IbqAlteraca.ParamByName('CNPJ').AsString           := sCNPJDest;
                    if Trim(Form1.IbqAlteraca.ParamByName('CNPJ').AsString) = '' then
                      Form1.IbqAlteraca.ParamByName('CNPJ').Clear;
                    if Trim(Form1.IbqAlteraca.ParamByName('CLIFOR').AsString) = '' then
                      Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;

                    Form1.IbqAlteraca.ParamByName('ITEM').Clear;
                    Form1.IbqAlteraca.ParamByName('CODIGO').Clear;
                    Form1.IbqAlteraca.ParamByName('MEDIDA').Clear;
                    Form1.IbqAlteraca.ParamByName('CST_PIS_COFINS').Clear;
                    Form1.IbqAlteraca.ParamByName('DESCONTO').Clear; 
                    Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                    Form1.IbqAlteraca.ParamByName('ALIQUICM').Clear;
                    Form1.IbqAlteraca.ParamByName('CFOP').Clear;
                    Form1.IbqAlteraca.ParamByName('CSOSN').Clear;
                    Form1.IbqAlteraca.ParamByName('CST_ICMS').Clear;
                    Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                    //
                    Form1.IbqAlteraca.ExecSQL;
                    //
                  except end;
                end; // if (dDesconto > 0) then
                // Sandro Silva 2019-11-01
                //
              except end; // for itens

              // Sandro Silva 2019-10-31
              try

                // Corrigir contas receber
                // importar pagament

                {Sandro Silva 2019-11-01 inicio
                //
                // Contas a Receber
                //
                xNodeItens := Form1.FXMLNFE.selectNodes('//dup');
                //
                // xmlNodeValue(xNodeItens.item[iNode].xml, '//vDup');
                //
                for iNode := 0 to xNodeItens.length -1 do
                begin
                  //
                  sDataVencimento := xmlNodeValue(xNodeItens.item[iNode].xml, '//dVenc');
                  sValorDuplicata := xmlNodeValue(xNodeItens.item[iNode].xml, '//vDup');
                  sNDup           := xmlNodeValue(xNodeItens.item[iNode].xml, '//nDup');
                  //
                  // <dup xmlns="http://www.portalfiscal.inf.br/nfe"><nDup>001</nDup><dVenc>2019-11-14</dVenc><vDup>349.00</vDup></dup>
                  //
                  // ShowMessage(sDataVencimento);
                  //
                  if Length(sDataVencimento) >= 10 then
                  begin
                    //
                    // Incluindo no contas a Receber
                    //
                    Form1.IbqReceber.ParamByName('HISTORICO').AsString     := 'Nota Fiscal: ' + Copy(sNumeroDaNota,1,9); // Sandro Silva 2019-10-31 Form1.IbqReceber.ParamByName('HISTORICO').AsString     := 'Nota Fiscal: ' + Copy(sNumeroDaNota,1,12);
                    //
                    if Length(sNDup) > 3 then
                    begin
                      Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Trim(sNDup);
                    end else
                    begin
                      Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,1,9)+Chr(64+StrToInt(sNDup)); // Sandro Silva 2019-10-31 Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,2,9)+Chr(64+StrToInt(sNDup));
                    end;
                    //
                    // Conta vencida deve ir com 1
                    //
                    if (StrToDate(Copy(sDataVencimento,9,2)+'/'+Copy(sDataVencimento,6,2)+'/'+Copy(sDataVencimento,1,4)) < Date) then
                      sContaAtiva := '1'
                    else
                      sContaAtiva := '0';

                    //
                    Form1.IbqReceber.ParamByName('NUMERONF').AsString      := Copy(sNumeroDaNota,1,12);
                    Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime     := StrToDate(sdtEmissao);
                    Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime  := StrToDate(Copy(sDataVencimento,9,2)+'/'+Copy(sDataVencimento,6,2)+'/'+Copy(sDataVencimento,1,4));
                    Form1.IbqReceber.ParamByName('NOME').AsString          := sNomeDaEmpresa;
                    Form1.IbqReceber.ParamByName('VALOR_DUPL').AsFloat     := StrToFloat(StrTran(sValorDuplicata,'.',','));
                    Form1.IbqReceber.ParamByName('ATIVO').AsString         := sContaAtiva;
                    Form1.IbqReceber.ParamByName('VALOR_RECE').AsFloat     := 0.00; // Sandro Silva 2019-10-31
                    Form1.IbqReceber.ExecSQL;
                  end;
                  //
                end;
                }

                //
                // Pagament e Contas a Receber
                //
                Form1.aForma := nil;
                xNodeItens := Form1.FXMLNFE.selectNodes('//MP'); // selecionas formas de pagamento
                if xNodeItens.length > 0 then
                  Form1.AcumulaFormas('00 Total', Form1.xmlNodeValue2('//vCFe'));

                // Acumula o valor das formas de pagamento repetidas no xml
                for iNode := 0 to xNodeItens.length -1 do
                begin
                  Form1.AcumulaFormas(Form1.DescFormaPagamento(xmlNodeValue(xNodeItens.item[iNode].xml, '//cMP')), xmlNodeValue(xNodeItens.item[iNode].xml, '//vMP'));
                end;

                if xNodeItens.length > 0 then
                  Form1.AcumulaFormas('13 Troco', Form1.xmlNodeValue2('//pgto/vTroco'));

                //Após acumular os valores das formas iguais grava no banco
                iSequenciaParcelaBalcao := 0;
                for iNode := 0 to Length(Form1.aForma) - 1 do
                begin

                  Form1.GravaFormaPagamento(
                    Form1.aForma[iNode].Forma,
                    Form1.aForma[iNode].Valor,
                    sdtEmissao,
                    RightStr(Form1.IBQuery3.FieldByName('NUMERONF').AsString, 6),
                    sCaixa, // Para NFC-e fica sempre 001
                    sNomeDaEmpresa
                    );

                  // Gravar em receber se a forma for cartão ou a prazo
                  if AnsiContainsText(Form1.aForma[iNode].Forma, '04 A prazo') or AnsiContainsText(Form1.aForma[iNode].Forma, 'CARTAO') then
                  begin
                    Inc(iSequenciaParcelaBalcao);
                    try
                      Form1.IbqReceber.ParamByName('NUMERONF').AsString      := RightStr('000000' +sNumeroDaNota, 6) + sCaixa;
                      if AnsiContainsText(Form1.aForma[iNode].Forma, 'CARTAO') then
                        Form1.IbqReceber.ParamByName('NOME').AsString         := Copy(Form1.aForma[iNode].Forma, 4, 15)
                      else
                        Form1.IbqReceber.ParamByName('NOME').AsString         := Trim(sNomeDaEmpresa);
                      Form1.IbqReceber.ParamByName('HISTORICO').AsString    := 'NF: ' + Copy(sNumeroDaNota,1,9) + ' VENDA ' + AnsiUpperCase(Copy(Form1.aForma[iNode].Forma, 4, 15));
                      Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,1,9)+Chr(64+ iSequenciaParcelaBalcao);
                      Form1.IbqReceber.ParamByName('VALOR_DUPL').AsFloat    := Form1.aForma[iNode].Valor;
                      Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime    := StrToDate(sdtEmissao);
                      Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime := Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime + (30); // Fixo 30 dias após a emissão
                      if (Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime < Date) then
                        sContaAtiva := '1'
                      else
                        sContaAtiva := '0';
                      Form1.IbqReceber.ParamByName('ATIVO').AsString        := sContaAtiva;
                      Form1.IbqReceber.ParamByName('VALOR_RECE').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                      Form1.IbqReceber.ExecSQL;
                    except
                    end;

                  end;

                end;

              except end;
              // Sandro Silva 2019-10-31

              try
                //
                //
                // Salva S@T
                if Trim(sCODIGO) <> '' then
                begin
                  //
                  if (AnsiContainsText(Form1.FXMLNFE.xml, '>1</tpAmb>')) then
                  begin
                    Form1.IbqNFCe.ParamByName('STATUS').AsString := 'CF-e-SAT Emitido com sucesso';
                  end
                  else
                  begin
                    Form1.IbqNFCe.ParamByName('STATUS').AsString := 'CF-e-SAT Emitido com sucesso emitido em ambiente de homologação';
                  end;

                  Form1.IbqNFCe.ParamByName('NUMERONF').AsString  := sNumeroDaNota;
                  Form1.IbqNFCe.ParamByName('NFEID').AsString     := LimpaNumero(Form1.xmlNodeValue2('//infCFe/@Id'));
                  Form1.IbqNFCe.ParamByName('NFEXML').AsString    := Form1.FXMLNFE.xml;
                  Form1.IbqNFCe.ParamByName('DATA').AsDateTime    := StrToDate(sdtEmissao);
                  Form1.IbqNFCe.ParamByName('CAIXA').AsString     := sCaixa;
                  Form1.IbqNFCe.ParamByName('MODELO').AsString    := '59';
                  Form1.IbqNFCe.ParamByName('TOTAL').AsFloat      := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//vCFe'), '.', ','), 0);
                  //
                  Form1.IbqNFCe.ExecSQL;
                  //
                end;
                //
              except end;

            end; // if Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ then
          end; // if (Trim(Form1.xmlNodeValue2('//CFe/infCFe/@versao')) <> '') then
        end
        else
        begin

          // cancelamentos de SAT

          if ((scStat = '135') or (scStat = '136') or (scStat = '155')) then // Sandro Silva 2019-11-01 if ((scStat = '135') or (scStat = '136') or (scStat = '155')) and (Form1.xmlNodeValue2('//tpAmb')='1') then
          begin
            //

            if Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ then
            begin

              Form1.sUltimaNotaImportada := snNF+sSerie+scStat;

              try
                Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
              except end;
              //
              // Sandro Silva 2019-11-01  sNumeroDaNota := Copy(Form1.IBQuery3.FieldByName('ID').AsString,29,6);
              sNumeroDaNota := Copy(LimpaNumero(xmlNodeValue2('//infCFe/@chCanc')),32,6); // S@t precisa extrair o número da chave que foi cancelada

              sCaixa := RightStr('000' + Form1.xmlNodeValue2('//numeroCaixa'), 3);
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('select REGISTRO, DATA from NFCE where NUMERONF='+QuotedStr(sNumeroDaNota)+' and CAIXA = '+QuotedStr(sCaixa));
              Form1.ibQuery1.Open;
              //
              if Form1.ibQuery1.FieldByname('REGISTRO').AsString <> '' then
              begin
                sdtEmissao := FormatDateTime('dd/mm/yyyy', Form1.ibQuery1.FieldByname('DATA').AsDateTime);
                //
                try
                  Form1.ibQuery1.Close;
                  Form1.ibQuery1.SQL.Clear;
                  Form1.ibQuery1.SQL.Add('update NFCE set NFEXML=:NFEXML, NFEID=:NFEID, STATUS=:STATUS, TOTAL=:TOTAL  where NUMERONF='+QuotedStr(sNumeroDaNota)+' and CAIXA = '+QuotedStr(sCaixa));
                  //
                  Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
                  Form1.ibQuery1.ParamByName('NFEID').AsString         := LimpaNumero(Form1.xmlNodeValue2('//infCFe/@Id'));
                  Form1.ibQuery1.ParamByName('STATUS').AsString        := 'Cancelado com sucesso + conteúdo notas';
                  Form1.ibQuery1.ParamByName('TOTAL').AsFloat          := 0;
                  //
                  Form1.ibQuery1.ExecSQL;
                except

                end;

                /// Cancela no alteraca
                try

                  Form1.ibQuery1.Close;
                  Form1.ibQuery1.SQL.Text :=
                    'update ALTERACA set ' +
                    'TIPO = ''CANCEL'' ' +
                    'where CAIXA = ' + QuotedStr(sCaixa) +
                    ' and TIPO = ' + QuotedStr('BALCAO') +
                    ' and PEDIDO = ' + QuotedStr(sNumeroDaNota); // Sandro Silva 2019-11-02 ' and COO = ' + QuotedStr(sNumeroDaNota);
                  Form1.ibQuery1.ExecSQL;
                except
                end;

                try
                  ///exclusão de pagament
                  Form1.ibQuery1.Close;
                  Form1.ibQuery1.SQL.Text :=
                    'delete from PAGAMENT where (coalesce(CLIFOR, '''') <> ''Sangria'' and coalesce(CLIFOR, '''') <> ''Suprimento'') and CAIXA = ' + QuotedStr(sCaixa) + ' and PEDIDO = ' + QuotedStr(sNumeroDaNota) + ' ';
                  Form1.ibQuery1.ExecSQL;
                except
                end;

                try
                  //exclusao de receber
                  Form1.ibQuery1.Close;
                  Form1.ibQuery1.SQL.Text :=
                    'delete from RECEBER where NUMERONF='+QuotedStr(sNumeroDaNota)+ ' and EMISSAO='+ QuotedStr(DateToStrInvertida(StrToDate(sdtEmissao))) + ' ';
                  Form1.ibQuery1.ExecSQL;
                except
                end;

                //
              end else
              begin
                //
                sNumeroDaNota := Copy(LimpaNumero(xmlNodeValue2('//infCFe/@chCanc')),32,6); // S@t precisa extrair o número da chave que foi cancelada
                // Sandro Silva 2019-11-01  sdtEmissao     := Form1.xmlNodeValue2('//dEmi');
                // Sandro Silva 2019-11-01  sdtEmissao     := Copy(sDtEmissao,9,2)+'/'+Copy(sDtEmissao,6,2)+'/'+Copy(sdtEmissao,1,4);
                sdtEmissao     := Form1.xmlNodeValue2('//ide/dEmi');
                if sdtEmissao <> '' then
                  sdtEmissao     := Copy(sDtEmissao,7,2)+'/'+Copy(sDtEmissao,5,2)+'/'+Copy(sdtEmissao,1,4);
                //
                Form1.ibQuery1.Close;
                Form1.ibQuery1.SQL.Clear;
                Form1.ibQuery1.SQL.Add('insert into NFCE (REGISTRO, NUMERONF, DATA, NFEXML, STATUS, TOTAL, NFEID, CAIXA, MODELO) values (right(''0000000000''||gen_id(G_NFCE, 1), 10), :NUMERONF, :DATA, :NFEXML, :STATUS, :TOTAL, :NFEID, :CAIXA, :MODELO)');
                //
                Form1.ibQuery1.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
                Form1.ibQuery1.ParamByName('DATA').AsDateTime        := StrToDate(sdtEmissao);
                //
                Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
                Form1.ibQuery1.ParamByName('STATUS').AsString        := 'Cancelado com sucesso + conteúdo notas';
                Form1.ibQuery1.ParamByName('TOTAL').Clear;
                //
                Form1.ibQuery1.ParamByName('NFEID').AsString        := Form1.IBQuery3.FieldByName('ID').AsString;
                Form1.ibQuery1.ParamByName('CAIXA').AsString        := sCaixa;
                Form1.ibQuery1.ParamByName('MODELO').AsString       := sMod;
                //
                Form1.ibQuery1.ExecSQL;
                //
              end;
              //
            end; // if Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ then
            //
          end; // if ((scStat = '135') or (scStat = '136') or (scStat = '155')) and (Form1.xmlNodeValue2('//tpAmb')='1') then

        end; // if ((sCStat='100') or (sCStat='150')) then
      end; // if snNF+sSerie <> Form1.sUltimaNotaImportada then
    end; // if sMod = '59' then

    if sMod = '65' then
    begin
      //
      // NFC-e
      //
      if (snNF+sSerie+sCStat <> Form1.sUltimaNotaImportada) then
      begin
        sCaixa         := '065'; // NFC-e sempre começa com caixa 065 para não confundir com SAT
        //
        if ((sCStat='100') or (sCStat='150')) then
        begin
          //
          try
            Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
          except end;
          //
          if (Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ) and (Form1.xmlNodeValue2('//tpAmb')='1') then
          begin
            //
            Form1.sUltimaNotaImportada := snNF+sSerie+sCStat;
            //
            try
              //
              sNumeroDaNota  := StrZero(StrToFloat(Form1.xmlNodeValue2('//nNF')),6,0);
              sdtEmissao     := Form1.xmlNodeValue2('//dhRecbto');
              sdtEmissao     := Copy(sDtEmissao,9,2)+'/'+Copy(sDtEmissao,6,2)+'/'+Copy(sdtEmissao,1,4);
              sNomeDaEmpresa := PrimeiraMaiuscula(Trim(Copy((Trim(Form1.xmlNodeValue2('//dest/xNome')))+replicate(' ',60),1,60)));
              sEnder         := Form1.xmlNodeValue2('//enderDest/xLgr');
              sCNPJDest      := Form1.xmlNodeValue2('//dest/CNPJ');
              sFone          := Form1.xmlNodeValue2('//dest/enderDest/fone'); // Sandro Silva 2019-10-31
              sCEP           := Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),1,5)+'-'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),6,3);

              if sCNPJDest = '' then
                sCNPJDest      := Form1.xmlNodeValue2('//dest/CPF');

              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('select CGC, NOME from CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(Trim(sCNPJDest)))+' ');
              Form1.ibQuery1.Open;
              //
              if ( (Form1.IBQuery1.FieldByName('CGC').AsString <> ConverteCpfCgc(Trim(sCNPJDest))) and (Trim(sCNPJDest) <> '') and (sNomeDaEmpresa <> '') and (sEnder <> '')) then
              begin
                //
                // Importa Cliente
                //
                try
                  Form1.SalvaClifor;
                  {
                  //
                  Form1.IbqClifor.ParamByName('CGC').AsString      := ConverteCpfCgc(Trim(sCNPJDest));
                  Form1.IbqClifor.ParamByName('NOME').AsString     := sNomeDaEmpresa;
                  Form1.IbqClifor.ParamByName('IE').AsString       := Form1.xmlNodeValue2('//dest/IE');
                  Form1.IbqClifor.ParamByName('ENDERE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr'))))+' '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40));
                  Form1.IbqClifor.ParamByName('COMPLE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xBairro'))))), 1, iTamanhoCliforBairro)); 
                  Form1.IbqClifor.ParamByName('CIDADE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xMun')))))+Replicate(' ',40),1,40));
                  Form1.IbqClifor.ParamByName('ESTADO').AsString   := Form1.xmlNodeValue2('//dest/enderDest/UF');
                  Form1.IbqClifor.ParamByName('CEP').AsString      := Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),1,5)+'-'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),5,3);
                  Form1.IbqClifor.ParamByName('FONE').AsString     := '(0xx'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),1,2)+')'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),2,9);

                  if LimpaNumero(ConverteCpfCgc(Trim(sCNPJDest))) = '' then
                    Form1.IbqClifor.ParamByName('CGC').Clear;

                  sEmailClifor := Copy(Trim(Form1.xmlNodeValue2('//enderEmit/email')), 1, iTamanhoCliforEmail);
                  if sEmailClifor <> '' then
                    Form1.IbqClifor.ParamByName('EMAIL').AsString := sEmailClifor
                  else
                    Form1.IbqClifor.ParamByName('EMAIL').Clear;

                  Form1.IbqClifor.ExecSQL;
                  //
                  }
                except end;
                //
                // Fim do importa Cliente
                //
              end else
              begin
                sNomeDaEmpresa := Form1.IBQuery1.FieldByName('NOME').AsString;
              end;
            except end;

            try
              //
              // Percore os itens da nota
              //
              xNodeItens := Form1.FXMLNFE.selectNodes('//det');
              //
              for iNode := 0 to xNodeItens.length -1 do
              begin
                //
                // Zerezima
                //
                dAliqICMS      := 0;
                dPIVA          := 0;
                dDesconto      := 0;
                sCSTIPI        := '';
                sCSTICMS       := '';
                sXPED          := '';
                sNItemPed      := '';
                scEnqIPI        := ''; // Sandro Silva 2019-11-04
                //sCSTIPI        := '';
                //sCSTICMS       := '';
                //sXPED          := '';
                //sNItemPed      := '';

                //
                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP')) <> '' then sCFOP := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));
                //
                fqTrib    := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/qTrib'),'.',','));
                fvUnCom   := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/vUnCom'),'.',','));
                //
                if (fqTrib<>0) and (fvUnCom<>0) then
                begin
                  //
                  sDescricao := Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd')), 1, 45); // Sandro Silva 2019-11-01 sDescricao := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd'));
                  sCodigo    := '';
                  //
                  try
                    sEAN       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/cEAN'));
                  except
                    sEAN  := '';
                  end;
                  //
                  if (sEAN = '') or (sEAN = 'SEM GTIN') then
                  begin
                    //
                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(sDescricao)+' ');
                    Form1.ibQuery1.Open;
                    //
                    if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                    begin
                      sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                      sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                    end;
                    //
                  end else
                  begin
                    //
                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where REFERENCIA='+QuotedStr(sEAN)+' ');
                    Form1.ibQuery1.Open;
                    //
                    if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                    begin
                      sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                      sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                    end;
                    //
                  end;
                  //

                  try
                    sTipoItem := '00'; // Inicia considerando que é produto para revenda
                    if (Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vBC')) <> '') then
                      sTipoItem := '09'; // Identificou que tem elemento referente a serviço troca o tipo para serviço

                    sNCM        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'));
                    sCFOP       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));

                    sCSOSN     := '';
                    sPathCSOSN := '';
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/CSOSN')) <> '' then // 101
                      sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/'
                    else
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/CSOSN')) <> '' then // 102
                        sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/'
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/CSOSN')) <> '' then // 201
                          sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/'
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/CSOSN')) <> '' then // 202
                            sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/'
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/CSOSN')) <> '' then // 500
                              sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/'
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/CSOSN')) <> '' then // 900
                                sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/';


                    if sPathCSOSN <> '' then
                    begin
                      sCSOSN  := Trim(Form1.xmlNodeValue2(sPathCSOSN + 'CSOSN'));
                      sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'orig')) + '0', 1, 1);
                      dAliqICMS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                    end;

                    sPathICMSItem := '';
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/CST')) <> '' then
                    begin
                      sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/';
                    end
                    else
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/CST')) <> '' then
                      begin
                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/';
                      end
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/CST')) <> '' then
                        begin
                          sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/';
                        end
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/CST')) <> '' then
                          begin
                            sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/';
                          end
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/CST')) <> '' then
                            begin
                              sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/';
                            end
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/CST')) <> '' then
                              begin
                                sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/';
                              end
                              else
                                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/CST')) <> '' then
                                begin
                                  sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/';
                                end
                                else
                                  if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/CST')) <> '' then
                                  begin
                                    sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/';
                                  end
                                  else
                                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/CST')) <> '' then
                                    begin
                                      sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/';
                                    end
                                    else
                                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/CST')) <> '' then
                                      begin
                                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/';
                                      end;

                    sCSTICMS   := Trim(Form1.xmlNodeValue2(sPathICMSItem + 'CST'));

                    if (sCSTICMS <> '') then
                    begin
                      // Na NFe o CST ICMS é listado com 2 casas. Concatenar a origem
                      sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'orig')) + '0', 1, 1);
                      sCSTICMS := sOrigem + sCSTICMS;

                      dAliqICMS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                      dPIVA          := 0.00;// NFC-e não tem pMVAST por que não vende com ST // Sandro Silva 2019-11-01 dPIVA          := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pMVAST')), '.', ',', [rfReplaceAll]), 0) / 100; 
                    end;

                    sCSTPisCofins := '';

                    // Localiza o CST para o PIS e a COFINS e a Alíquota para o PIS
                    sPISAliqCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/CST'));
                    if sPISAliqCST <> '' then
                    begin
                      sCSTPisCofins := sPISAliqCST;
                      dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/pPIS')), '.', ',', [rfReplaceAll]), 0);
                      dAliqPIS := dAliqPIS * 100;
                    end
                    else
                    begin
                      sPISQtdeCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/CST'));
                      if sPISQtdeCST <> '' then
                      begin
                        sCSTPisCofins := sPISQtdeCST;
                        dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                      end
                      else
                      begin
                        sPISOutrCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/CST'));
                        if sPISOutrCST <> '' then
                        begin
                          sCSTPisCofins := sPISOutrCST;
                          dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/pPIS')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          sCSTPisCofins := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISNT/CST'));
                          dAliqPIS      := 0;
                        end;
                      end;
                    end;

                    if dAliqPIS = 0 then
                    begin
                      dAliqPIS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PISST/pPIS')), '.', ',', [rfReplaceAll]), 0);
                      dAliqPIS := dAliqPIS * 100;
                    end;

                    // Localiza a Alíquota para a COFINS
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/CST')) <> '' then
                    begin
                      dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                      dAliqCOFINS := dAliqCOFINS * 100;
                    end
                    else
                    begin
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/CST')) <> '' then
                      begin
                        dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                      end
                      else
                      begin
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/CST')) <> '' then
                        begin
                          dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          dAliqCOFINS := 0;
                        end;
                      end;
                    end;

                    if dAliqCOFINS = 0 then
                    begin
                      dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINSST/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                      dAliqCOFINS := dAliqCOFINS * 100;
                    end;

                    sCSTIPI := '';
                    sIPITribCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/CST'));
                    if sIPITribCST <> '' then
                      sCSTIPI := sIPITribCST
                    else
                      sCSTIPI := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPINT/CST'));

                    //dValorIPI := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/vIPI')), '.', ',', [rfReplaceAll]), 0);

                    sXPED     := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xPed'));
                    sNItemPed := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nItemPed'));


                    if (sCodigo='') then
                    begin
                      //
                      // Produto novo
                      //
                      Form1.ibQuery1.Close;
                      Form1.ibQuery1.Sql.Clear;
                      Form1.ibQuery1.Sql.Add('select gen_id(G_ESTOQUE,1) from rdb$database');
                      Form1.ibQuery1.Open;
                      //
                      sCodigo    := StrZero(StrtoFloat(Form1.ibQuery1.FieldByname('GEN_ID').AsString),5,0);

                      //
                      Form1.IbqEstoque.ParamByName('REGISTRO').AsString      := '00000'+sCodigo;
                      Form1.IbqEstoque.ParamByName('CODIGO').AsString        := sCodigo;
                      Form1.IbqEstoque.ParamByName('REFERENCIA').AsString    := sEAN;
                      Form1.IbqEstoque.ParamByName('DESCRICAO').AsString     := sDescricao;
                      Form1.IbqEstoque.ParamByName('MEDIDA').AsString        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                      Form1.IbqEstoque.ParamByName('PRECO').AsFloat          := fvUnCom;
                      Form1.IbqEstoque.ParamByName('CF').AsString            := Trim(Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'))+Replicate(' ',45),1,45));
                      Form1.IbqEstoque.ParamByName('CODIGO_FCI').AsString    := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nFCI'));
                      Form1.IbqEstoque.ParamByName('ULT_VENDA').AsDate       := StrToDate(sdtEmissao);

                      Form1.IbqEstoque.ParamByName('CSOSN').Clear;

                      if sCFOP <> '' then
                        Form1.IbqEstoque.ParamByName('CFOP').AsString := sCFOP
                      else
                        Form1.IbqEstoque.ParamByName('CFOP').Clear;

                      Form1.IbqEstoque.ParamByName('CST').Clear;
                      Form1.IbqEstoque.ParamByName('TIPO_ITEM').AsString  := sTipoItem;

                      Form1.IbqEstoque.ParamByName('CST_PIS_COFINS_SAIDA').AsString  := sCSTPisCofins;
                      Form1.IbqEstoque.ParamByName('ALIQ_PIS_SAIDA').AsFloat         := dAliqPIS;
                      Form1.IbqEstoque.ParamByName('ALIQ_COFINS_SAIDA').AsFloat      := dAliqCOFINS;

                      if sTipoItem <> '09' then
                      begin
                        if Trim(sCSOSN) <> '' then
                        begin
                          Form1.IbqEstoque.ParamByName('CSOSN').AsString    := sCSOSN;
                          Form1.IbqEstoque.ParamByName('CST').AsString      := sOrigem;
                        end
                        else
                          if Trim(sCSTICMS) <> '' then
                          begin
                            Form1.IbqEstoque.ParamByName('CSOSN').Clear;
                            Form1.IbqEstoque.ParamByName('CST').AsString    := sCSTICMS;
                          end;
                      end;

                      if (dPIVA > 0) and (sTipoItem <> '09') then
                        Form1.IbqEstoque.ParamByName('PIVA').AsFloat := StrToFloat(FormatFloat('0.0000', dPIVA))
                      else
                        Form1.IbqEstoque.ParamByName('PIVA').Clear;

                      //
                      Form1.IbqEstoque.ExecSQL;
                    end;
                    //
                  except  end;

                    //
                  try
                    //
                    //
                    // Itens da Nota Fiscal - Salva ALTERACA
                    if Trim(sCODIGO) <> '' then
                    begin
                      //
                      Form1.IbqAlteraca.ParamByName('CODIGO').AsString         := sCodigo;;
                      Form1.IbqAlteraca.ParamByName('DESCRICAO').AsString      := sDescricao;
                      Form1.IbqAlteraca.ParamByName('QUANTIDADE').AsFloat      := fqTrib;
                      Form1.IbqAlteraca.ParamByName('MEDIDA').AsString         := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                      Form1.IbqAlteraca.ParamByName('UNITARIO').AsFloat        := fvUnCom;
                      Form1.IbqAlteraca.ParamByName('TOTAL').AsFloat           := fvUnCom*fqTrib;
                      Form1.IbqAlteraca.ParamByName('DATA').AsDate             := StrToDate(sdtEmissao);
                      Form1.IbqAlteraca.ParamByName('TIPO').AsString           := 'BALCAO';
                      Form1.IbqAlteraca.ParamByName('PEDIDO').AsString         := sNumeroDaNota;
                      Form1.IbqAlteraca.ParamByName('ITEM').AsString           := StrZero(iNode+1, 6, 0);
                      Form1.IbqAlteraca.ParamByName('CLIFOR').AsString         := sNomeDaEmpresa;
                      Form1.IbqAlteraca.ParamByName('CAIXA').AsString          := sCaixa;
                      Form1.IbqAlteraca.ParamByName('CST_PIS_COFINS').AsString := sCSTPisCofins;
                      Form1.IbqAlteraca.ParamByName('DESCONTO').AsFloat        := dDesconto;
                      Form1.IbqAlteraca.ParamByName('COO').AsString            := sNumeroDaNota;
                      Form1.IbqAlteraca.ParamByName('CCF').AsString            := sNumeroDaNota;
                      Form1.IbqAlteraca.ParamByName('CNPJ').AsString           := sCNPJDest;
                      Form1.IbqAlteraca.ParamByName('REFERENCIA').AsString     := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/cEAN'));
                      Form1.IbqAlteraca.ParamByName('HORA').Clear;
                      Form1.IbqAlteraca.ParamByName('CFOP').AsString           := sCFOP;
                      Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString       := sCSTICMS;
                      Form1.IbqAlteraca.ParamByName('CSOSN').AsString          := sCSOSN;

                      if sTipoItem = '09' then // Identificou que tem elemento referente a serviço
                        Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'ISS'
                      else
                        Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := StrZero((dAliqICMS * 100), 4, 0);

                      if Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString <> '' then
                      begin
                        if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '40' then // – Isenta
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'I';
                        if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '41' then // – Não tributada
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'N';
                        if Right(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString, 2) = '60' then // – ICMS cobrado anteriormente por substituição tributária
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'F';
                      end;

                      if Form1.IbqAlteraca.ParamByName('CSOSN').AsString <> '' then
                      begin
                        if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '300' then // – Isenta
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'I';
                        if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '400' then // – Não tributada
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'N';
                        if Right(Form1.IbqAlteraca.ParamByName('CSOSN').AsString, 3) = '500' then // – ICMS cobrado anteriormente por substituição tributária
                          Form1.IbqAlteraca.ParamByName('ALIQUICM').AsString := 'F';
                      end;

                      if Form1.IbqAlteraca.ParamByName('CFOP').AsString = '' then
                        Form1.IbqAlteraca.ParamByName('CFOP').Clear;

                      if Form1.IbqAlteraca.ParamByName('CSOSN').AsString = '' then
                        Form1.IbqAlteraca.ParamByName('CSOSN').Clear;

                      if Trim(Form1.IbqAlteraca.ParamByName('CNPJ').AsString) = '' then
                        Form1.IbqAlteraca.ParamByName('CNPJ').Clear;

                      if Trim(Form1.IbqAlteraca.ParamByName('CLIFOR').AsString) = '' then
                        Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;

                      if Trim(Form1.IbqAlteraca.ParamByName('CST_ICMS').AsString) = '' then
                        Form1.IbqAlteraca.ParamByName('CST_ICMS').Clear;

                      if Trim(Form1.IbqAlteraca.ParamByName('REFERENCIA').AsString) = '' then
                        Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;

                      // Ajusta valor dos campos quando estiver incluindo DESCONTO
                      if (sDescricao = 'Desconto') or (sDescricao = 'Acréscimo') then
                      begin
                        Form1.IbqAlteraca.ParamByName('CODIGO').Clear;
                        Form1.IbqAlteraca.ParamByName('MEDIDA').Clear;
                        Form1.IbqAlteraca.ParamByName('ITEM').Clear;
                        if sDescricao = 'Desconto' then
                        begin

                          if sCodigo <> '' then
                          begin
                            Form1.IbqAlteraca.ParamByName('ITEM').AsString   := StrZero(iNode, 6, 0);// Gravando desconto do item importado anteriormente
                            Form1.IbqAlteraca.ParamByName('CODIGO').AsString := sCodigo;
                          end;

                          Form1.IbqAlteraca.ParamByName('CLIFOR').Clear;
                          Form1.IbqAlteraca.ParamByName('VENDEDOR').Clear;
                          Form1.IbqAlteraca.ParamByName('CNPJ').Clear;
                        end;
                        Form1.IbqAlteraca.ParamByName('VALORICM').Clear;
                        Form1.IbqAlteraca.ParamByName('ALIQUICM').Clear;
                        Form1.IbqAlteraca.ParamByName('DESCONTO').Clear;
                        Form1.IbqAlteraca.ParamByName('COO').Clear;
                        Form1.IbqAlteraca.ParamByName('CCF').Clear;
                        Form1.IbqAlteraca.ParamByName('REFERENCIA').Clear;
                      end;
                      //
                      Form1.IbqAlteraca.ExecSQL;
                      //
                    end;
                    //
                  except end;

                  //
                end; // if (fqTrib<>0) and (fvUnCom<>0) then
              end; // for iNode := 0 to xNodeItens.length -1 do
              //
            except end; // for itens

            {Gabriel Rogelin - 2019-01-11 - Início}
            try
              //
              // Pagament e Contas a Receber
              //
              Form1.aForma := nil;
              // Sandro Silva 2019-11-04  xNodeItens := Form1.FXMLNFE.selectNodes('//detPag'); // selecionas formas de pagamento

              if (Trim(xmlNodeValue2('//protNFe/@versao')) = '3.00') or (Trim(xmlNodeValue2('//protNFe/@versao')) = '3.10') then
                xNodeItens := FXMLNFE.selectNodes('//infNFe/pag')
              else
                xNodeItens := FXMLNFE.selectNodes('//detPag');

              if xNodeItens.length > 0 then
                Form1.AcumulaFormas('00 Total', Form1.xmlNodeValue2('//vNF'));

              // Acumula o valor das formas de pagamento repetidas no xml
              for iNode := 0 to xNodeItens.length -1 do
              begin
                Form1.AcumulaFormas(Form1.DescFormaPagamento(xmlNodeValue(xNodeItens.item[iNode].xml, '//tPag')), xmlNodeValue(xNodeItens.item[iNode].xml, '//vPag'));
              end;

              if xNodeItens.length > 0 then
                Form1.AcumulaFormas('13 Troco', Form1.xmlNodeValue2('//vTroco'));

              //Após acumular os valores das formas iguais grava no banco
              iSequenciaParcelaBalcao := 0;
              for iNode := 0 to Length(Form1.aForma) - 1 do
              begin

                Form1.GravaFormaPagamento(
                  Form1.aForma[iNode].Forma,
                  Form1.aForma[iNode].Valor,
                  sdtEmissao,
                  RightStr(Form1.IBQuery3.FieldByName('NUMERONF').AsString, 6),
                  sCaixa, // Para NFC-e fica sempre 001
                  sNomeDaEmpresa
                  );

                // Gravar em receber se a forma for cartão ou a prazo
                if AnsiContainsText(Form1.aForma[iNode].Forma, '04 A prazo') or AnsiContainsText(Form1.aForma[iNode].Forma, 'CARTAO') then
                begin
                  Inc(iSequenciaParcelaBalcao);
                  try
                    Form1.IbqReceber.ParamByName('NUMERONF').AsString      := RightStr('000000' +sNumeroDaNota, 6) + sCaixa;
                    if AnsiContainsText(Form1.aForma[iNode].Forma, 'CARTAO') then
                      Form1.IbqReceber.ParamByName('NOME').AsString         := Copy(Form1.aForma[iNode].Forma, 4, 15)
                    else
                      Form1.IbqReceber.ParamByName('NOME').AsString         := Trim(sNomeDaEmpresa);
                    Form1.IbqReceber.ParamByName('HISTORICO').AsString    := 'NF: ' + Copy(sNumeroDaNota,1,9) + ' VENDA ' + AnsiUpperCase(Copy(Form1.aForma[iNode].Forma, 4, 15));
                    Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,1,9)+Chr(64+ iSequenciaParcelaBalcao);
                    Form1.IbqReceber.ParamByName('VALOR_DUPL').AsFloat    := Form1.aForma[iNode].Valor;
                    Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime    := StrToDate(sdtEmissao);
                    Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime := Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime + (30); // Fixo 30 dias após a emissão
                    if (Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime < Date) then
                      sContaAtiva := '1'
                    else
                      sContaAtiva := '0';
                    Form1.IbqReceber.ParamByName('ATIVO').AsString        := sContaAtiva;
                    Form1.IbqReceber.ParamByName('VALOR_RECE').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                    Form1.IbqReceber.ExecSQL;
                  except
                  end;

                end;

              end;

            except end;
            {Gabriel Rogelin - 2019-01-11 - Fim}

            try
              // Salva NFCe
              if Trim(sCODIGO) <> '' then
              begin
                //
                Form1.IbqNFCe.ParamByName('NUMERONF').AsString  := sNumeroDaNota;
                Form1.IbqNFCe.ParamByName('STATUS').AsString    := StringReplace(Copy(Form1.xmlNodeValue2('//infProt/xMotivo'),1,128), 'NF-e', 'NFC-e', [RfReplaceAll]);
                Form1.IbqNFCe.ParamByName('NFEID').AsString     := Form1.IBQuery3.FieldByName('ID').AsString;
                Form1.IbqNFCe.ParamByName('NFEXML').AsString    := Form1.FXMLNFE.xml;
                Form1.IbqNFCe.ParamByName('DATA').AsDateTime    := StrToDate(sdtEmissao);
                Form1.IbqNFCe.ParamByName('CAIXA').AsString     := sCaixa;
                Form1.IbqNFCe.ParamByName('MODELO').AsString    := '65';
                Form1.IbqNFCe.ParamByName('TOTAL').AsFloat      := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vNF'), '.', ','), 0);
                //
                Form1.IbqNFCe.ExecSQL;
                //
              end;
              //
            except

            end;
          end; // if Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ then
        end else // if ((Form1.xmlNodeValue2('//cStat') = '100') or (Form1.xmlNodeValue2('//cStat') = '150')) and (Form1.xmlNodeValue2('//tpAmb')='1') then
        begin
          //
          if ((scStat = '135') or (scStat = '136') or (scStat = '155')) and (Form1.xmlNodeValue2('//tpAmb')='1') then
          begin
            //
            try
              Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
            except end;
            //
            sNumeroDaNota := Copy(Form1.IBQuery3.FieldByName('ID').AsString,29,6);
            //
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('select REGISTRO, DATA from NFCE where NUMERONF='+QuotedStr(sNumeroDaNota)+' and CAIXA=' + QuotedStr(sCaixa));
            Form1.ibQuery1.Open;
            //
            sdtEmissao := Form1.ibQuery1.FieldByname('DATA').AsString;
            //
            if Form1.ibQuery1.FieldByname('REGISTRO').AsString <> '' then
            begin
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('update NFCE set NFEXML=:NFEXML, STATUS=:STATUS, TOTAL=:TOTAL  where NUMERONF='+QuotedStr(sNumeroDaNota)+' and CAIXA=' + QuotedStr(sCaixa)); // Sandro Silva 2019-11-04 Form1.ibQuery1.SQL.Add('update NFCE set NFEXML=:NFEXML, STATUS=:STATUS, TOTAL=:TOTAL  where NUMERONF='+QuotedStr(sNumeroDaNota)+' ');
              //
              Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
              Form1.ibQuery1.ParamByName('STATUS').AsString        := 'Cancelamento Registrado e viculado a NFCe';
              Form1.ibQuery1.ParamByName('TOTAL').AsFloat          := 0;
              //
              Form1.ibQuery1.ExecSQL;

              // Sandro Silva 2019-11-02 Inicio
              /// Cancela no alteraca
              try

                Form1.ibQuery1.Close;
                Form1.ibQuery1.SQL.Text :=
                  'update ALTERACA set ' +
                  'TIPO = ''CANCEL'' ' +
                  'where CAIXA = ' + QuotedStr(sCaixa) +
                  ' and TIPO = ' + QuotedStr('BALCAO') +
                  ' and PEDIDO = ' + QuotedStr(sNumeroDaNota); // Sandro Silva 2019-11-02 ' and COO = ' + QuotedStr(sNumeroDaNota);
                Form1.ibQuery1.ExecSQL;
              except
              end;
              // Sandro Silva 2019-11-02 fim
              //
              // Exclui Pagament
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('delete from PAGAMENT where (coalesce(CLIFOR, '''') <> ''Sangria'' and coalesce(CLIFOR, '''') <> ''Suprimento'') and CAIXA = ' + QuotedStr(sCaixa) + ' and PEDIDO = ' + QuotedStr(sNumeroDaNota) + ' ');
              Form1.ibQuery1.ExecSQL;
              //
              // Exclui Receber
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('delete from RECEBER where NUMERONF='+QuotedStr(sNumeroDaNota)+ ' and EMISSAO='+ QuotedStr(DateToStrInvertida(StrToDate(sdtEmissao))) + ' ');
              Form1.ibQuery1.ExecSQL;
              //
            end else
            begin
              //
              sdtEmissao     := Form1.xmlNodeValue2('//dhRegEvento');
              sdtEmissao     := Copy(sDtEmissao,9,2)+'/'+Copy(sDtEmissao,6,2)+'/'+Copy(sdtEmissao,1,4);
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('insert into NFCE (REGISTRO, NUMERONF, DATA, NFEXML, STATUS, TOTAL, NFEID, CAIXA, MODELO) values (right(''0000000000''||gen_id(G_NFCE, 1), 10), :NUMERONF, :DATA, :NFEXML, :STATUS, :TOTAL, :NFEID, :CAIXA, :MODELO)');
              //
              Form1.ibQuery1.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
              Form1.ibQuery1.ParamByName('DATA').AsDateTime        := StrToDate(sdtEmissao);
              //
              Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
              Form1.ibQuery1.ParamByName('STATUS').AsString        := 'Cancelamento Registrado e viculado a NFCe';
              Form1.ibQuery1.ParamByName('TOTAL').AsFloat          := 0;
              //
              Form1.ibQuery1.ParamByName('NFEID').AsString        := Form1.IBQuery3.FieldByName('ID').AsString;
              Form1.ibQuery1.ParamByName('CAIXA').AsString        := sCaixa;
              Form1.ibQuery1.ParamByName('MODELO').AsString       := '65';
              //
              Form1.ibQuery1.ExecSQL;
              //
            end;
            //
          end;
        end;
      end; // if snNF+sSerie <> Form1.sUltimaNotaImportada then
    end;// if modelo 65
    //
    if sMod = '55' then
    begin
      //
      // NFf-e
      //
      if (snNF+sSerie+sCStat <> Form1.sUltimaNotaImportada) then
      begin
        //
        if ((sCStat='100') or (sCStat='150')) then
        begin
          //
          try
            Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
          except end;
          //
          if (Form1.xmlNodeValue2('//emit/CNPJ') = Form1.sCNPJ) and (Form1.xmlNodeValue2('//tpAmb')='1') then
          begin
            //
            Form1.sUltimaNotaImportada := snNF+sSerie+sCStat;
            //
            try
              sNumeroDaNota  := StrZero(StrToFloat(Form1.xmlNodeValue2('//nNF')),9,0)+StrZero(StrToFloat(Form1.xmlNodeValue2('//serie')),3,0);
              sNatOp         := Form1.xmlNodeValue2('//natOp');
              sdtEmissao     := Form1.xmlNodeValue2('//dhRecbto');
              sdtEmissao     := Copy(sDtEmissao,9,2)+'/'+Copy(sDtEmissao,6,2)+'/'+Copy(sdtEmissao,1,4);
              sNomeDaEmpresa := PrimeiraMaiuscula(Trim(Copy((Trim(Form1.xmlNodeValue2('//dest/xNome')))+replicate(' ',60),1,60)));
              sEnder         := Form1.xmlNodeValue2('//enderDest/xLgr');
              sCNPJDest      := Form1.xmlNodeValue2('//dest/CNPJ');
              sFone          := Form1.xmlNodeValue2('//dest/enderDest/fone'); // Sandro Silva 2019-10-31
              sCEP           := Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),1,5)+'-'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),6,3);
              stpNF          := xmlNodeValue2('//ide/tpNF'); // Tipo do Documento Fiscal (0 - entrada; 1 - saída) // Sandro Silva 2019-11-03

              if sCNPJDest = '' then
                sCNPJDest      := Form1.xmlNodeValue2('//dest/CPF');
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('select CGC, NOME from CLIFOR where CGC='+QuotedStr(ConverteCpfCgc(Trim(sCNPJDest)))+' ');
              Form1.ibQuery1.Open;
              //
              if ( (Form1.IBQuery1.FieldByName('CGC').AsString <> ConverteCpfCgc(Trim(sCNPJDest))) and (Trim(sCNPJDest) <> '') and (sNomeDaEmpresa <> '') and (sEnder <> '')) then
              begin
                //
                // Importa Cliente
                //
                try
                  Form1.SalvaClifor;
                  {
                  Form1.IbqClifor.ParamByName('CGC').AsString      := ConverteCpfCgc(Trim(sCNPJDest));
                  Form1.IbqClifor.ParamByName('NOME').AsString     := sNomeDaEmpresa;
                  Form1.IbqClifor.ParamByName('IE').AsString       := Form1.xmlNodeValue2('//dest/IE');
                  Form1.IbqClifor.ParamByName('ENDERE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML(( StringReplace(Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr')), ',', ' ', [rfReplaceAll])))+', '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40)); // Sandro Silva 2019-10-31 Form1.IbqClifor.ParamByName('ENDERE').AsString   := Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr'))))+' '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40);
                  Form1.IbqClifor.ParamByName('COMPLE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xBairro'))))), 1, iTamanhoCliforBairro)); // Sandro Silva 2019-10-31 Form1.IbqClifor.ParamByName('COMPLE').AsString   := PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xBairro')))));
                  // Sandro Silva 2019-10-31 inicio
                  Form1.IbqClifor.ParamByName('CIDADE').AsString   := Form1.NomeMunicipio(Form1.xmlNodeValue2('//enderDest/cMun'));
                  if Trim(Form1.IbqClifor.ParamByName('CIDADE').AsString) = '' then
                  // Sandro Silva 2019-10-31 fim
                    Form1.IbqClifor.ParamByName('CIDADE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xMun')))))+Replicate(' ',40),1,40));
                  Form1.IbqClifor.ParamByName('ESTADO').AsString   := Form1.xmlNodeValue2('//dest/enderDest/UF');
                  Form1.IbqClifor.ParamByName('CEP').AsString      := Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),1,5)+'-'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/CEP')+'00000000'),5,3);
                  // Sandro Silva 2019-10-31  Form1.IbqClifor.ParamByName('FONE').AsString     := '(0xx'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),1,2)+')'+Copy(Trim(Form1.xmlNodeValue2('//dest/enderDest/fone')+'         '),2,9);
                  if Copy(sFone, 1, 1) = '0' then
                    sFone := Copy(sFone, 2, 14);
                  if Length(sFone) < 10 then
                    Form1.IbqClifor.ParamByName('FONE').AsString     := Trim(sFone)
                  else
                    Form1.IbqClifor.ParamByName('FONE').AsString     := '(0xx'+Copy(Trim(sFone),1,2)+')'+Copy(Trim(sFone),3,9);

                  sEmailClifor := Copy(Trim(Form1.xmlNodeValue2('//enderEmit/email')), 1, iTamanhoCliforEmail);
                  if sEmailClifor <> '' then
                    Form1.IbqClifor.ParamByName('EMAIL').AsString := sEmailClifor
                  else
                    Form1.IbqClifor.ParamByName('EMAIL').Clear;

                  Form1.IbqClifor.ExecSQL;
                  }
                  //
                except end;
                //
                // Fim do importa Cliente
                //
              end else
              begin
                sNomeDaEmpresa := Form1.IBQuery1.FieldByName('NOME').AsString;
              end;
            except end;
            //
            //
            //
            try
              //
              // Percore os itens da nota - mod 55
              //
              xNodeItens := Form1.FXMLNFE.selectNodes('//det');
              //
              for iNode := 0 to xNodeItens.length -1 do
              begin
                //
                // Zerezima
                //
                dAliqPIS       := 0;
                dAliqCOFINS    := 0;
                dAliqICMS      := 0;
                dValorIPI      := 0;
                dValorIcmsST   := 0;
                dValorBCIcmsST := 0;
                dAliqIPI       := 0;
                dRedBC         := 0;
                dValorBCIcms   := 0;
                dPIVA          := 0;
                dValorICMS     := 0;
                //
                sCSTIPI        := '';
                sCSTICMS       := '';
                sXPED          := '';
                sNItemPed      := '';
                scEnqIPI        := ''; // Sandro Silva 2019-11-04
                //
                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP')) <> '' then sCFOP := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));
                //
                fqTrib    := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/qTrib'),'.',','));
                fvUnCom   := StrToFloat(StrTran(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/vUnCom'),'.',','));
                //
                if (fqTrib<>0) and (fvUnCom<>0) then
                begin
                  //
                  sDescricao := Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd')), 1, 45); // Sandro Silva 2019-11-01 sDescricao := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xProd'));
                  sCodigo    := '';
                  //
                  try
                    sEAN       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/cEAN'));
                  except
                    sEAN  := '';
                  end;
                  //
                  if (sEAN = '') or (sEAN = 'SEM GTIN') then
                  begin
                    //
                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where DESCRICAO='+QuotedStr(sDescricao)+' ');
                    Form1.ibQuery1.Open;
                    //
                    if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                    begin
                      sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                      sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                    end;
                    //
                  end else
                  begin
                    //
                    Form1.ibQuery1.Close;
                    Form1.ibQuery1.Sql.Clear;
                    Form1.ibQuery1.Sql.Add('select CODIGO, DESCRICAO from ESTOQUE where REFERENCIA='+QuotedStr(sEAN)+' ');
                    Form1.ibQuery1.Open;
                    //
                    if Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString)<>'' then
                    begin
                      sDescricao := Trim(Form1.IBQuery1.FieldByName('DESCRICAO').AsString);
                      sCodigo    := Trim(Form1.IBQuery1.FieldByName('CODIGO').AsString);
                    end;
                    //
                  end;
                  //

                  try
                    sTipoItem := '00'; // Inicia considerando que é produto para revenda
                    if (Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ISSQN/vBC')) <> '') then
                      sTipoItem := '09'; // Identificou que tem elemento referente a serviço troca o tipo para serviço

                    sNCM        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'));
                    sCFOP       := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/CFOP'));

                    sCSOSN     := '';
                    sPathCSOSN := '';
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/CSOSN')) <> '' then // 101
                      sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN101/'
                    else
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/CSOSN')) <> '' then // 102
                        sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN102/'
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/CSOSN')) <> '' then // 201
                          sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN201/'
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/CSOSN')) <> '' then // 202
                            sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN202/'
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/CSOSN')) <> '' then // 500
                              sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN500/'
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/CSOSN')) <> '' then // 900
                                sPathCSOSN := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSSN900/';


                    dAliqICMS      := 0;

                    if sPathCSOSN <> '' then
                    begin
                      sCSOSN  := Trim(Form1.xmlNodeValue2(sPathCSOSN + 'CSOSN'));
                      sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'orig')) + '0', 1, 1);
                      dAliqICMS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathCSOSN + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                    end;

                    sPathICMSItem := '';
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/CST')) <> '' then
                    begin
                      sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMSPart/';
                    end
                    else
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/CST')) <> '' then
                      begin
                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS00/';
                      end
                      else
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/CST')) <> '' then
                        begin
                          sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS10/';
                        end
                        else
                          if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/CST')) <> '' then
                          begin
                            sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS20/';
                          end
                          else
                            if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/CST')) <> '' then
                            begin
                              sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS30/';
                            end
                            else
                              if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/CST')) <> '' then
                              begin
                                sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS40/';
                              end
                              else
                                if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/CST')) <> '' then
                                begin
                                  sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS51/';
                                end
                                else
                                  if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/CST')) <> '' then
                                  begin
                                    sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS60/';
                                  end
                                  else
                                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/CST')) <> '' then
                                    begin
                                      sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS70/';
                                    end
                                    else
                                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/CST')) <> '' then
                                      begin
                                        sPathICMSItem := '//det[' + IntToStr(iNode) + ']/imposto/ICMS/ICMS90/';
                                      end;

                    sCSTICMS   := Trim(Form1.xmlNodeValue2(sPathICMSItem + 'CST'));

                    if (sCSTICMS <> '') then
                    begin
                      //
                      // Na NFe o CST ICMS é listado com 2 casas. Concatenar a origem
                      //
                      sOrigem := Copy(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'orig')) + '0', 1, 1);
                      sCSTICMS := sOrigem + sCSTICMS;
                      //
                      dAliqICMS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pICMS')), '.', ',', [rfReplaceAll]), 0);
                      dPIVA          := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pMVAST')), '.', ',', [rfReplaceAll]), 0); // Sandro Silva 2019-11-01 dPIVA          := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pMVAST')), '.', ',', [rfReplaceAll]), 0) / 100;
                      if dPIVA > 0 then
                      begin
                        if dPIVA >= 100 then
                          dPIVA := dPIVA / 100
                        else
                          dPIVA := 1 + (dPIVA / 100); // Sandro Silva 2019-11-04
                      end;
                      dValorICMS     := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'vICMS')), '.', ',', [rfReplaceAll]), 0);
                      dValorBCIcms   := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'vBC')), '.', ',', [rfReplaceAll]), 0);
                      dValorBCIcmsST := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'vBCST')), '.', ',', [rfReplaceAll]), 0);
                      dValorIcmsST   := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'vICMSST')), '.', ',', [rfReplaceAll]), 0);
                      dRedBC         := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2(sPathICMSItem + 'pRedBC')), '.', ',', [rfReplaceAll]), 0);
                      //
                    end;

                    sCSTPisCofins := '';

                    // Localiza o CST para o PIS e a COFINS e a Alíquota para o PIS
                    sPISAliqCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/CST'));
                    if sPISAliqCST <> '' then
                    begin
                      sCSTPisCofins := sPISAliqCST;
                      dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISAliq/pPIS')), '.', ',', [rfReplaceAll]), 0);
                      // Sandro Silva 2019-10-31  dAliqPIS := dAliqPIS * 100;
                    end
                    else
                    begin
                      sPISQtdeCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/CST'));
                      if sPISQtdeCST <> '' then
                      begin
                        sCSTPisCofins := sPISQtdeCST;
                        dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                      end
                      else
                      begin
                        sPISOutrCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/CST'));
                        if sPISOutrCST <> '' then
                        begin
                          sCSTPisCofins := sPISOutrCST;
                          dAliqPIS      := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISOutr/pPIS')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          sCSTPisCofins := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PIS/PISNT/CST'));
                          dAliqPIS      := 0;
                        end;
                      end;
                    end;

                    if dAliqPIS = 0 then
                    begin
                      dAliqPIS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/PISST/pPIS')), '.', ',', [rfReplaceAll]), 0);
                      // Sandro Silva 2019-10-31  dAliqPIS := dAliqPIS * 100;
                    end;

                    // Localiza a Alíquota para a COFINS
                    if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/CST')) <> '' then
                    begin
                      dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSAliq/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                      // Sandro Silva 2019-10-31  dAliqCOFINS := dAliqCOFINS * 100;
                    end
                    else
                    begin
                      if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/CST')) <> '' then
                      begin
                        dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSQtde/vAliqProd')), '.', ',', [rfReplaceAll]), 0);
                      end
                      else
                      begin
                        if Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/CST')) <> '' then
                        begin
                          dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINS/COFINSOutr/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                        end
                        else
                        begin
                          dAliqCOFINS := 0;
                        end;
                      end;
                    end;

                    if dAliqCOFINS = 0 then
                    begin
                      dAliqCOFINS := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/COFINSST/pCOFINS')), '.', ',', [rfReplaceAll]), 0);
                      // Sandro Silva 2019-10-31  dAliqCOFINS := dAliqCOFINS * 100;
                    end;

                    sCSTIPI := '';
                    sIPITribCST := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/CST'));
                    if sIPITribCST <> '' then
                      sCSTIPI := sIPITribCST
                    else
                      sCSTIPI := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPINT/CST'));

                    dValorIPI := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/vIPI')), '.', ',', [rfReplaceAll]), 0);
                    dAliqIPI  := StrToFloatDef(StringReplace(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/IPITrib/pIPI')), '.', ',', [rfReplaceAll]), 0);// Sandro Silva 2019-11-04
                    scEnqIPI   := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/imposto/IPI/cEnq')); // Sandro Silva 2019-11-04

                    sXPED     := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/xPed'));
                    sNItemPed := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nItemPed'));

                    if (sCodigo='') then
                    begin
                      //
                      // Produto novo
                      //
                      Form1.ibQuery1.Close;
                      Form1.ibQuery1.Sql.Clear;
                      Form1.ibQuery1.Sql.Add('select gen_id(G_ESTOQUE,1) from rdb$database');
                      Form1.ibQuery1.Open;
                      //
                      sCodigo    := StrZero(StrtoFloat(Form1.ibQuery1.FieldByname('GEN_ID').AsString),5,0);

                      //
                      Form1.IbqEstoque.ParamByName('REGISTRO').AsString      := '00000'+sCodigo;
                      Form1.IbqEstoque.ParamByName('CODIGO').AsString        := sCodigo;
                      Form1.IbqEstoque.ParamByName('REFERENCIA').AsString    := sEAN;
                      Form1.IbqEstoque.ParamByName('DESCRICAO').AsString     := sDescricao;
                      Form1.IbqEstoque.ParamByName('MEDIDA').AsString        := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                      Form1.IbqEstoque.ParamByName('PRECO').AsFloat          := fvUnCom;
                      Form1.IbqEstoque.ParamByName('CF').AsString            := Trim(Copy(Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/NCM'))+Replicate(' ',45),1,45));
                      Form1.IbqEstoque.ParamByName('CODIGO_FCI').AsString    := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/nFCI'));
                      Form1.IbqEstoque.ParamByName('ULT_VENDA').AsDate       := StrToDate(sdtEmissao);

                      Form1.IbqEstoque.ParamByName('CSOSN').Clear;

                      if sCFOP <> '' then
                        Form1.IbqEstoque.ParamByName('CFOP').AsString := sCFOP
                      else
                        Form1.IbqEstoque.ParamByName('CFOP').Clear;

                      Form1.IbqEstoque.ParamByName('CST').Clear;
                      Form1.IbqEstoque.ParamByName('TIPO_ITEM').AsString  := sTipoItem;

                      Form1.IbqEstoque.ParamByName('CST_PIS_COFINS_SAIDA').AsString  := sCSTPisCofins;
                      Form1.IbqEstoque.ParamByName('ALIQ_PIS_SAIDA').AsFloat         := dAliqPIS;
                      Form1.IbqEstoque.ParamByName('ALIQ_COFINS_SAIDA').AsFloat      := dAliqCOFINS;

                      if sTipoItem <> '09' then
                      begin
                        if Trim(sCSOSN) <> '' then
                        begin
                          Form1.IbqEstoque.ParamByName('CSOSN').AsString    := sCSOSN;
                          Form1.IbqEstoque.ParamByName('CST').AsString      := sOrigem;
                        end
                        else
                          if Trim(sCSTICMS) <> '' then
                          begin
                            Form1.IbqEstoque.ParamByName('CSOSN').Clear;
                            Form1.IbqEstoque.ParamByName('CST').AsString    := sCSTICMS;
                          end;
                      end;

                      if (dPIVA > 0) and (sTipoItem <> '09') then
                        Form1.IbqEstoque.ParamByName('PIVA').AsFloat := StrToFloat(FormatFloat('0.0000', dPIVA))
                      else
                        Form1.IbqEstoque.ParamByName('PIVA').Clear;

                      Form1.IbqEstoque.ParamByName('ENQ_IPI').AsString := scEnqIPI; // Sandro Silva 2019-11-04
                      Form1.IbqEstoque.ParamByName('CST_IPI').AsString := sCSTIPI; // Sandro Silva 2019-11-04
                      Form1.IbqEstoque.ParamByName('IPI').AsFloat      := dAliqIPI; // Sandro Silva 2019-11-04
                      //
                      Form1.IbqEstoque.ExecSQL;
                      //
                    end;
                  except  end;
                  //
                  // Só grava itens001 se a nota for de saída
                  if (xmlNodeValue2('//ide/tpNF') = '1') then // Tipo do Documento Fiscal (0 - entrada; 1 - saída)
                  begin

                    try
                      //
                      // Itens da Nota Fiscal
                      //
                      if Trim(sCODIGO) <> '' then
                      begin
                        //
                        Form1.IbqItens001.ParamByName('NUMERONF').AsString       := sNumeroDaNota;
                        Form1.IbqItens001.ParamByName('CODIGO').AsString         := sCodigo;
                        Form1.IbqItens001.ParamByName('DESCRICAO').AsString      := sDescricao;
                        Form1.IbqItens001.ParamByName('QUANTIDADE').AsFloat      := fqTrib;
                        Form1.IbqItens001.ParamByName('SINCRONIA').AsFloat       := fqTrib;
                        Form1.IbqItens001.ParamByName('UNITARIO').AsFloat        := fvUnCom;
                        Form1.IbqItens001.ParamByName('TOTAL').AsFloat           := fvUnCom*fqTrib;

                        Form1.IbqItens001.ParamByName('IPI').AsFloat             := dAliqIPI;
                        Form1.IbqItens001.ParamByName('ICM').AsFloat             := dAliqICMS;
                        Form1.IbqItens001.ParamByName('MEDIDA').AsString         := Trim(Form1.xmlNodeValue2('//det[' + IntToStr(iNode) + ']/prod/uCom'));
                        Form1.IbqItens001.ParamByName('BASE').Clear;
                        if dAliqICMS > 0 then
                        begin
                          if dRedBC = 0 then
                            Form1.IbqItens001.ParamByName('BASE').AsFloat := 100
                          else
                            Form1.IbqItens001.ParamByName('BASE').AsFloat := dRedBC;
                        end;

                        Form1.IbqItens001.ParamByName('CFOP').AsString           := sCFOP;
                        Form1.IbqItens001.ParamByName('VIPI').AsFloat            := dValorIPI;
                        Form1.IbqItens001.ParamByName('CST_PIS_COFINS').AsString := sCSTPisCofins;
                        Form1.IbqItens001.ParamByName('ALIQ_PIS').AsFloat        := dAliqPIS;
                        Form1.IbqItens001.ParamByName('ALIQ_COFINS').AsFloat     := dAliqCOFINS;
                        Form1.IbqItens001.ParamByName('CST_IPI').AsString        := sCSTIPI;
                        Form1.IbqItens001.ParamByName('CST_ICMS').AsString       := sCSTICMS;


                        Form1.IbqItens001.ParamByName('VICMS').AsFloat           := dValorICMS;
                        Form1.IbqItens001.ParamByName('VBC').AsFloat             := dValorBCIcms;
                        Form1.IbqItens001.ParamByName('VBCST').AsFloat           := dValorBCIcmsST;
                        Form1.IbqItens001.ParamByName('VICMSST').AsFloat         := dValorIcmsST;
                        Form1.IbqItens001.ParamByName('XPED').AsString           := sXPED;
                        Form1.IbqItens001.ParamByName('NITEMPED').AsString       := sNItemPed;

                        //
                        Form1.IbqItens001.ExecSQL;
                        //
                      end;
                      //
                    except end;
                  end; // if (xmlNodeValue2('//ide/tpNF') = '1') then //
                  //
                end; // if (fqTrib<>0) and (fvUnCom<>0) then

              end; // for iNode := 0 to xNodeItens.length -1 do
              //
            except end;
            //
            if (xmlNodeValue2('//ide/tpNF') = '1') then // NF de saída // Sandro Silva 2019-11-03
            begin
              try
                //
                // Contas a Receber
                //
                xNodeItens := Form1.FXMLNFE.selectNodes('//dup');
                //
                // xmlNodeValue(xNodeItens.item[iNode].xml, '//vDup');
                //
                for iNode := 0 to xNodeItens.length -1 do
                begin
                  //
                  sDataVencimento := xmlNodeValue(xNodeItens.item[iNode].xml, '//dVenc');
                  sValorDuplicata := xmlNodeValue(xNodeItens.item[iNode].xml, '//vDup');
                  sNDup           := xmlNodeValue(xNodeItens.item[iNode].xml, '//nDup');
                  //
                  // <dup xmlns="http://www.portalfiscal.inf.br/nfe"><nDup>001</nDup><dVenc>2019-11-14</dVenc><vDup>349.00</vDup></dup>
                  //
                  // ShowMessage(sDataVencimento);
                  //
                  if Length(sDataVencimento) >= 10 then
                  begin
                    //
                    // Incluindo no contas a Receber
                    //
                    Form1.IbqReceber.ParamByName('HISTORICO').AsString     := 'Nota Fiscal: ' + Copy(sNumeroDaNota,1,9); // Sandro Silva 2019-10-31 Form1.IbqReceber.ParamByName('HISTORICO').AsString     := 'Nota Fiscal: ' + Copy(sNumeroDaNota,1,12);
                    //
                    if Length(sNDup) > 3 then
                    begin
                      Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Trim(sNDup);
                    end else
                    begin
                      Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,1,9)+Chr(64+StrToInt(sNDup)); // Sandro Silva 2019-10-31 Form1.IbqReceber.ParamByName('DOCUMENTO').AsString := Copy(sNumeroDaNota,2,9)+Chr(64+StrToInt(sNDup));
                    end;
                    //
                    // Conta vencida deve ir com 1
                    //
                    if (StrToDate(Copy(sDataVencimento,9,2)+'/'+Copy(sDataVencimento,6,2)+'/'+Copy(sDataVencimento,1,4)) < Date) then
                      sContaAtiva := '1'
                    else
                      sContaAtiva := '0';

                    //
                    Form1.IbqReceber.ParamByName('NUMERONF').AsString      := Copy(sNumeroDaNota,1,12);
                    Form1.IbqReceber.ParamByName('EMISSAO').AsDateTime     := StrToDate(sdtEmissao);
                    Form1.IbqReceber.ParamByName('VENCIMENTO').AsDateTime  := StrToDate(Copy(sDataVencimento,9,2)+'/'+Copy(sDataVencimento,6,2)+'/'+Copy(sDataVencimento,1,4));
                    Form1.IbqReceber.ParamByName('NOME').AsString          := sNomeDaEmpresa;
                    Form1.IbqReceber.ParamByName('VALOR_DUPL').AsFloat     := StrToFloat(StrTran(sValorDuplicata,'.',','));
                    Form1.IbqReceber.ParamByName('ATIVO').AsString         := sContaAtiva;
                    Form1.IbqReceber.ParamByName('VALOR_RECE').AsFloat     := 0.00; // Sandro Silva 2019-10-31
                    Form1.IbqReceber.ExecSQL;
                  end;
                  //
                end;
              except end;
            end; // if (xmlNodeValue2('//ide/tpNF') = '1') then //
            //
            // Importa Natureza de operacao na tabela ICM
            //
            try
              //
              Form1.ibQuery2.Close;
              Form1.ibQuery2.Sql.Clear;
              Form1.ibQuery2.Sql.Add('select NOME from ICM where NOME='+QuotedStr(Trim(sNatOp))+' ');
              Form1.ibQuery2.Open;
              //
              if Trim(Form1.IBQuery2.FieldByName('NOME').AsString) = '' then
              begin
                //
                Form1.IBQuery2.Close;
                Form1.IBQuery2.SQL.Text := 'insert into ICM (REGISTRO, CFOP, NOME) ' +
                'values (right(''0000000000''||gen_id(G_ICM, 1), 10), :CFOP, :NOME)';
                //
                Form1.IBQuery2.ParamByName('CFOP').AsString      := sCFOP;
                Form1.IBQuery2.ParamByName('NOME').AsString      := Copy(sNatOp,1,40);
                //
                // Base, % ICMS, Outras coisas dapra importar aqui
                //
                Form1.IBQuery2.ExecSQL;
                //
              end;
              //
            except end;
            //
            // Importa a NOTA FISCAL ELETRONICA
            //
            try

              sFrete12 := Trim(Form1.xmlNodeValue2('//transp/modFrete'));
              if sFrete12 = '0' then
                sFrete12 := '1'
              else
                if sFrete12 = '1' then
                  sFrete12 := '2'
                else
                  sFrete12 := '';
              //
              Form1.ibqVendas.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
              Form1.ibqVendas.ParamByName('EMISSAO').AsDateTime     := StrToDate(sdtEmissao);
              Form1.ibqVendas.ParamByName('MODELO').AsString        := sMod;
              Form1.ibqVendas.ParamByName('CLIENTE').AsString       := sNomeDaEmpresa;
              Form1.ibqVendas.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
              Form1.ibqVendas.ParamByName('NFEID').AsString         := Form1.xmlNodeValue2('//infProt/chNFe');
              Form1.ibqVendas.ParamByName('STATUS').AsString        := Copy(Form1.xmlNodeValue2('//infProt/xMotivo'),1,128);
              if stpNF = '0' then // Sandro Silva 2019-11-03
                Form1.ibqVendas.ParamByName('TOTAL').Clear
              else
                Form1.ibqVendas.ParamByName('TOTAL').AsFloat          := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vNF'), '.', ','), 0);
              Form1.ibqVendas.ParamByName('FRETE').AsFloat          := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vFrete'),'.',','), 0);
              Form1.ibqVendas.ParamByName('SEGURO').AsFloat         := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vSeg'),'.',','), 0);
              Form1.ibqVendas.ParamByName('DESPESAS').AsFloat       := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vOutro'),'.',','), 0);
              Form1.ibqVendas.ParamByName('DESCONTO').AsFloat       := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vDesc'),'.',','), 0);
              Form1.ibqVendas.ParamByName('BASEICM').AsFloat        := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vBC'), '.', ','), 0);
              Form1.ibqVendas.ParamByName('ICMS').AsFloat           := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vICMS'), '.', ','), 0);
              Form1.ibqVendas.ParamByName('BASESUBSTI').AsFloat     := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vBCST'), '.', ','), 0);
              Form1.ibqVendas.ParamByName('IPI').AsFloat            := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vIPI'), '.', ','), 0);
              if stpNF = '0' then // Sandro Silva 2019-11-03
                Form1.ibqVendas.ParamByName('MERCADORIA').Clear
              else
                Form1.ibqVendas.ParamByName('MERCADORIA').AsFloat     := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vProd'),'.',','), 0);
              Form1.ibqVendas.ParamByName('OPERACAO').AsString      := Copy(Form1.xmlNodeValue2('//ide/natOp'),1,40);
              Form1.ibqVendas.ParamByName('EMITIDA').AsString       := 'S';
              Form1.ibqVendas.ParamByName('VOLUMES').AsFloat        := StrToFloatDef(StrTran(Trim(Form1.xmlNodeValue2('//transp/vol/qVol')),'.',','), 0);
              Form1.ibqVendas.ParamByName('ESPECIE').AsString       := Copy(Trim(Form1.xmlNodeValue2('//transp/vol/esp')), 1, iTamanhoVendasEspecie);
              Form1.ibqVendas.ParamByName('MARCA').AsString         := Copy(Trim(Form1.xmlNodeValue2('//transp/vol/marca')), 1, iTamanhoVendasMarca);
              Form1.ibqVendas.ParamByName('FRETE12').AsString       := sFrete12;
              Form1.ibqVendas.ParamByName('SAIDAD').AsDateTime      := StrToDate(sdtEmissao);
              Form1.ibqVendas.ParamByName('DUPLICATAS').AsInteger   := Form1.FXMLNFE.selectNodes('//dup').length;
              Form1.ibqVendas.ParamByName('BASEISS').AsFloat        := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ISSQNtot/vBC'),'.',','), 0);
              Form1.ibqVendas.ParamByName('ICMSSUBSTI').AsFloat     := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ICMSTot/vST'),'.',','), 0);
              Form1.ibqVendas.ParamByName('ISS').AsFloat            := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ISSQNtot/vISS'),'.',','), 0);
              Form1.ibqVendas.ParamByName('SERVICOS').AsFloat       := StrToFloatDef(StrTran(Form1.xmlNodeValue2('//total/ISSQNtot/vServ'),'.',','), 0);
              Form1.ibqVendas.ParamByName('PESOBRUTO').AsFloat      := StrToFloatDef(StrTran(Trim(Form1.xmlNodeValue2('//transp/vol/pesoB')),'.',','), 0);
              Form1.ibqVendas.ParamByName('PESOLIQUI').AsFloat      := StrToFloatDef(StrTran(Trim(Form1.xmlNodeValue2('//transp/vol/pesoL')),'.',','), 0);
              Form1.ibqVendas.ParamByName('NFEPROTOCOLO').AsString  := Trim(Form1.xmlNodeValue2('//protNFe/infProt/nProt'));
              Form1.ibqVendas.ParamByName('COMPLEMENTO').AsString   := Trim(Form1.xmlNodeValue2('//infNFe/infCpl'));
              Form1.ibqVendas.ParamByName('NVOL').AsString          := Trim(Form1.xmlNodeValue2('//transp/vol/nVol'));
              if stpNF = '0' then // Sandro Silva 2019-11-03
                Form1.IbqVendas.ParamByName('COMPLEMENTO').AsString := 'ENTRADA ' + Form1.IbqVendas.ParamByName('COMPLEMENTO').AsString;
              //
              // Responsavel Técnico pela emissão da Nota
              //
//              if sRespTec <> '' then sRespTec       := Form1.xmlNodeValue2('//infRespTec/CNPJ');
              //
              Form1.ibqVendas.ExecSQL;
              //
            except
//              on e:exception do
//                ShowMessage(e.Message);
            end;
          end;
        end else
        begin
          //
          if ((scStat = '135') or (scStat = '136') or (scStat = '155')) and (Form1.xmlNodeValue2('//tpAmb')='1') then
          begin
            //
            try
              Form1.FXMLNFE.load(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
            except end;
            //
            sNumeroDaNota := snNF + sSerie;
            //
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('select REGISTRO from VENDAS where NUMERONF='+QuotedStr(sNumeroDaNota)+' ');
            Form1.ibQuery1.Open;
            //
            if Form1.ibQuery1.FieldByname('REGISTRO').AsString <> '' then
            begin
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('update VENDAS set NFEXML=:NFEXML, STATUS=:STATUS, EMITIDA=:EMITIDA, TOTAL=:TOTAL  where NUMERONF='+QuotedStr(sNumeroDaNota)+' ');
              //
              Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
              Form1.ibQuery1.ParamByName('STATUS').AsString        := 'NF-e cancelada';
              Form1.ibQuery1.ParamByName('EMITIDA').AsString       := 'X';
              Form1.ibQuery1.ParamByName('TOTAL').AsFloat          := 0;
              //
              Form1.ibQuery1.ExecSQL;
              //
            end else
            begin
              //
              sdtEmissao     := Form1.xmlNodeValue2('//dhRegEvento');
              sdtEmissao     := Copy(sDtEmissao,9,2)+'/'+Copy(sDtEmissao,6,2)+'/'+Copy(sdtEmissao,1,4);
              //
              Form1.ibQuery1.Close;
              Form1.ibQuery1.SQL.Clear;
              // Sandro Silva 2019-10-31  Form1.ibQuery1.SQL.Add('insert into VENDAS (REGISTRO, NUMERONF, EMISSAO, NFEXML, STATUS, EMITIDA, TOTAL) values (right(''0000000000''||gen_id(G_VENDAS, 1), 10), :NUMERONF, :EMISSAO, :NFEXML, :STATUS, :EMITIDA, :TOTAL)');
              Form1.ibQuery1.SQL.Add('insert into VENDAS (REGISTRO, MODELO, NUMERONF, EMISSAO, NFEXML, NFEID, STATUS, EMITIDA, TOTAL) values (right(''0000000000''||gen_id(G_VENDAS, 1), 10), :MODELO, :NUMERONF, :EMISSAO, :NFEXML, :NFEID, :STATUS, :EMITIDA, :TOTAL)');
              //
              Form1.ibQuery1.ParamByName('MODELO').AsString        := Form1.IBQuery3.FieldByName('MODELO').AsString; // Sandro Silva 2019-10-31
              Form1.ibQuery1.ParamByName('NUMERONF').AsString      := sNumeroDaNota;
              Form1.ibQuery1.ParamByName('EMISSAO').AsDateTime     := StrToDate(sdtEmissao);
              //
              Form1.ibQuery1.ParamByName('NFEXML').AsString        := Form1.FXMLNFE.xml;
              Form1.ibQuery1.ParamByName('NFEID').AsString         := Form1.IBQuery3.FieldByName('ID').AsString; // Sandro Silva 2019-10-31
              Form1.ibQuery1.ParamByName('STATUS').AsString        := 'NF-e cancelada';
              Form1.ibQuery1.ParamByName('EMITIDA').AsString       := 'X';
              Form1.ibQuery1.ParamByName('TOTAL').AsFloat          := 0;
              //
              Form1.ibQuery1.ExecSQL;
              //
            end;
            //
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
//  Button5.Left := (Screen.Width - ((840) + 60)) div 2;
//  Button3.Left := Button5.Left + Button5.Width + 20;
//  Button1.Left := Button3.Left + Button5.Width + 20;
//  Button7.Left := Button1.Left + Button5.Width + 20;
  //
  Image1.Top    := 100;
  Image1.Left   := 0;
//  Image1.Top    := (Screen.Height div 2) - (Image1.Height div 2);
//  Image1.Left   := (Form1.Width div 2) - 100;
  //
  Winexec('net start FirebirdGuardianDefaultInstance' , SW_HIDE );
  Label8.Caption := 'VAMOS CRIAR SEU NOVO'+chr(10)+'BANCO DE DADOS';
  sMensagemPadrao := 'Escolha uma das opções abaixo.';
  //
  try
    GetDir(0,sAtual);
  except end;
  //
  try
    //
    SmallIni := TIniFile.Create(sAtual+'\small.ini');
    sIP  := SmallIni.ReadString('Firebird','Server IP','');
    sURL := SmallIni.ReadString('Firebird','Server url','');
    //
    if (sIP+sURL='') then
    begin
      //
      sIP  := IdIPWatch1.LocalName;
      sURL := sAtual;
      //
      SmallIni.WriteString('Firebird','Server IP',sIP);
      SmallIni.WriteString('Firebird','Server URL',sURL);
      //
    end;
    //
    Url := sIP+':'+sURL+'\small.fdb';
    //
    SmallIni.WriteString('T','Origem','');
    SmallIni.Free;
    //
  except end;
  //
  if FileExists('small.fdb') then
  begin
    Close;
  end;
  //
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //
//  if Copy(TimeToStr(Time - tInicio),1,4)='00:0' then Label4.Visible := True;
  //
  if X <> 0 then
  begin
    //
//    Label4.Caption := pChar('Tempo decorrido           '+ TimeToStr(Time - tInicio)+chr(10)+
//                      'Total de arquivos             '+ IntToStr(X)+chr(10)+
//                      'Arquivos analizados       '+ IntToStr(I));
    //
//    Label4.Repaint;
    //
    // 10:10:10
    //
    Gauge1.Progress := I * 100 div X;
    Gauge1.Repaint;
    //
  end;
  //
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  FXMLNFE := CoDOMDocument.Create;

  {Sandro Silva 2019-10-25 inicio}
  CDSBANCOS := TClientDataSet.Create(Application);
  CDSBANCOS.FieldDefs.Add('DATA', ftDateTime);
  CDSBANCOS.FieldDefs.Add('BANCO', ftString, 2000);
  CDSBANCOS.CreateDataSet;
  CDSBANCOS.Open;
  {Sandro Silva 2019-10-25 fim}

  {Gaberiel Rogelin - 2019-11-01 - Início
  CDSPAGAMENT := TClientDataSet.Create(Application);
  CDSPAGAMENT.FieldDefs.Add('DATA',     ftDateTime);
  CDSPAGAMENT.FieldDefs.Add('PEDIDO',   ftString, 6);
  CDSPAGAMENT.FieldDefs.Add('CAIXA',    ftString, 3);
  CDSPAGAMENT.FieldDefs.Add('CLIFOR',   ftString, 60);
  CDSPAGAMENT.FieldDefs.Add('FORMA',    ftString, 30);
  CDSPAGAMENT.FieldDefs.Add('VALOR',    ftFloat);
  CDSPAGAMENT.FieldDefs.Add('CCF',      ftString, 6);
  CDSPAGAMENT.FieldDefs.Add('COO',      ftString, 6);
  CDSPAGAMENT.CreateDataSet;
  CDSPAGAMENT.Open;
  {Gaberiel Rogelin - 2019-11-01 - Fim}

end;

procedure TForm1.AdicionaNaListaImportacao(sCaminho: String; Data: TDate);
begin
  CDSBANCOS.Append;
  CDSBANCOS.FieldByName('BANCO').AsString  := sCaminho;
  CDSBANCOS.FieldByName('DATA').AsDateTime := Data;
  CDSBANCOS.Post;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  if Form1.Tag = 99 then
  begin
    //
    Label1.Caption := 'Parabéns!'+Chr(10)+chr(10)
    +'Seu banco de dados foi criado e configurado'+Chr(10)
    +'com sucesso está pronto para'+chr(10)
    +'ser utilizado.';
    Label1.Repaint;
    //
    Sleep(2000);
    //
  end;
  //
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  //
  try
    if IBTransaction1.Active then
    begin
      IBTransaction1.Commit;
      IbDatabase1.Close;
    end;
    //
    if Form1.Tag = 99 then
    begin
      //
      while RenameFile(PChar('small.fdb'), PChar('small'+Limpanumero(TimeToStr(Time))+'.fdb')) = False do
      begin
        Sleep(500);
      end;
      //
      Form1.Tag := 0;
      //
    end;
  except end;
  //
  Winexec('TASKKILL /F /IM "Small Commerce.exe"' , SW_HIDE );
  Winexec('TASKKILL /F /IM "firebird.exe"' , SW_HIDE );
  //
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  sData : String;
begin
  //
  //
  Button5.Enabled := False;
  Button3.Enabled := False;
  Button1.Enabled := False;
  //
  Form1.Repaint;
  //
  try
    //
    CopyFile('exemplo.fdb','small.fdb',True);
    //
    Label8.Caption := 'AGUARDE!';
    sMensagemPadrao := 'Criando Banco de Dados exemplo.';
    Label1.Caption  := sMensagemPadrao;
    Form1.Repaint;
    //
    Sleep(5000);
    //
    IBDatabase1.Close;
    IBDatabase1.Params.Clear;
    IbDatabase1.DatabaseName := url;
    IBDatabase1.Params.Add('USER_NAME=SYSDBA');
    IBDatabase1.Params.Add('PASSWORD=masterkey');
    IbDatabase1.Open;
    IBTransaction1.Active := True;
    //
    Form1.ibQuery1.DisableControls;
    Form1.ibQuery2.DisableControls;
    Form1.ibQuery3.DisableControls;
    Form1.IbqItens001.DisableControls;
    Form1.IbqVendas.DisableControls;
    Form1.IbqReceber.DisableControls;
    Form1.IbqClifor.DisableControls;
    Form1.IbqEstoque.DisableControls;
    Form1.IbqNFCe.DisableControls;
    Form1.IbqAlteraca.DisableControls;
    Form1.IBQPAGAMENT.DisableControls;
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
  Close;
  //
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  //
  Button5.Enabled := False;
  Button3.Enabled := False;
  Button1.Enabled := False;
  //
  Form1.Repaint;
  //
  CopyFile('padrao.fdb','small.fdb',True);
  Form1.Tag := 99;
  //
  Label8.Caption := 'AGUARDE!';
  sMensagemPadrao := 'Criando um novo Banco de Dados.';
  Label1.Caption  := sMensagemPadrao;
  Form1.Repaint;
  //
  Sleep(5000);
  //
  Close;
  //
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  f: TextFile;
  scStat, sID, sLinha, sSerie, sNumero, sModelo, sGen: String;
  Mais1ini : tInifile;
  SmallIni : tIniFile;
  iAnos : inTeger;
begin
  //
  Button5.Enabled := False;
  Button3.Enabled := False;
  Button1.Enabled := False;
  //
  Form1.Repaint;
  //
  Form1.Label1.Top       := 230;
  Form1.Label1.Font.Size := 12;
  //
  try
    //
    tInicio := Time;
    //
    sMensagemPadrao := 'Aguarde!'+Chr(10)+chr(10)+
                       'Procurando por Arquivos'+chr(10)+
                       'de banco de dados.';
    Label1.Caption  := sMensagemPadrao;
    Form1.Repaint;
    //
    Form1.Repaint;
    Mais1ini := TIniFile.Create(Form1.sAtual+'\nfe.ini');
    Form1.sCNPJ := GetCNPJCertificado(Trim(Mais1ini.ReadString('NFE','Certificado','')));
    Mais1ini.Free;
    //
    if not CPFCGC(Form1.sCNPJ) then
    begin
      Form1.sCNPJ := '';
    end;
    //
    if Trim(Form1.sCNPJ)='' then
    begin
      //
      if sAtual= 'C:\Projeto 2020\CONVERSOR' then Form1.sCNPJ := '07426598000124';
      //
      while Trim(Form1.sCNPJ)='' do
      begin
        //
        Form1.sCNPJ := LimpaNumero(InputBox('Informe o CNPJ válido: ','CNPJ:','')); // Sandro Silva 2019-10-23 sCNPJ := InputBox('Informe o CNPJ válido: ','CNPJ:','11318928000135');
        //
        if not CPFCGC(Form1.sCNPJ) then
        begin
          ShowMessage('CNPJ inválido.');
          Form1.sCNPJ := ''; // Sandro Silva 2019-10-23
        end;
        //
      end;
      //
    end;
    //
    Form1.sCNPJ := LimpaNumero(Form1.sCNPJ);
    //
    Label8.Caption := 'AGUARDE!';
    //
    // Sandro Silva 2019-10-25  ActiveControl := nil;
    //
    if CopyFile('padrao.fdb','small.fdb',True) then Form1.Tag := 99;
    //
    sMensagemPadrao := 'Estamos procurando Bancos de Dados com'+chr(10)+
                       'CNPJ: '+FormataCpfCgc(Form1.sCNPJ)+'.'+Chr(10)+Chr(10)+
                       'Aguarde, não desligue o computador.';
    Label1.Caption  := sMensagemPadrao;
    Form1.Repaint;
    //
    Screen.Cursor := crAppStart;
    Application.ProcessMessages;
//    rgBancos.Items.Clear;
//    rgBancos.Visible := False; // Sandro Silva 2019-10-25

    ActiveControl := nil; // Sandro Silva 2019-10-25

    DeleteFile('files.tmp');
    DeleteFile('files.txt');

    //Troca a página de códigos ativa para listar nomes acentuados corretamente
    ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C REG ADD HKCU\Console\%SystemRoot^%_system32_cmd.exe /v CodePage /t REG_DWORD /d 1252 /f | exit'), '', SW_HIDE);
    Sleep(1000);// Aguarda
    //if DirectoryExists('..\projeto_conversor') then
    //  ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir c:\xmldestinatario\*.fdb /s/b > files.tmp'), nil, SW_HIDE) // Busca FDB e GDB
    //else
      ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir c:\*.fdb /s/b > files.tmp'), nil, SW_HIDE); // Busca FDB e GDB
    //ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir c:\*.fdb, c:\*.gdb /s/b > files.tmp'), nil, SW_HIDE); // Busca FDB e GDB

    while RenameFile(PChar('files.tmp'), PChar('files.txt')) = False do
    begin
      Sleep(100);
      Application.ProcessMessages; // Para a aplicação não parecer travada Sandro Silva 2019-10-23
    end;

    sMensagemPadrao := 'Estamos trabalhando no seu novo Banco'+Chr(10)+
                       'de Dados. Vamos importar o cadastro'+chr(10)+
                       'de Clientes e Produtos.'+Chr(10)+Chr(10)+
                       'Aguarde, não desligue o computador.';

    Label1.Caption  := sMensagemPadrao;
    Form1.Repaint;

    //
    DeleteFile('files1.tmp');
    DeleteFile('files1.txt');
    //
    // Sandro Silva 2019-10-31  ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir c:\*.xml /S/B > files1.tmp'), nil, SW_HIDE);
    //if DirectoryExists('..\projeto_conversor') then
    //  ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir C:\xmldestinatario\*.xml /S/B > files1.tmp'), nil, SW_HIDE)
    //else
      ShellExecute(Application.Handle, 'runas', 'cmd.exe', PChar('/C chcp 1252 | chcp 1252 & dir c:\*.xml /S/B > files1.tmp'), nil, SW_HIDE);
    //
    X := 0;
    //
    AssignFile(F, 'files.txt');
    Reset(F);
    //
    while not Eof(F) Do
    begin
      ReadLn(F, sLinha);
      if (AnsiContainsText(sLinha, '\CLIPP.FDB') or // Compufour
          AnsiContainsText(sLinha, '\DADOS.FDB') or // Digisat
          AnsiContainsText(sLinha, '\BASESGMASTER.FDB') or // SGBR
          AnsiContainsText(sLinha, '\DATAGES.FDB') or // GDOOR
          AnsiContainsText(sLinha, '\DATAGES.GDB') // GDOOR
         )
        and (AnsiContainsText(sLinha, 'Recycle') = False) // desconsiderar lixeira do Windows
      then
      begin
        Inc(X);
      end;
    end;
    //
    Reset(F);
    I := 0;
    Gauge1.Progress := 0;
    Gauge1.Visible  := True;
    Timer1.Enabled  := True;
    //
    while not Eof(F) Do
    begin
      ReadLn(F, sLinha);

      if (AnsiContainsText(sLinha, '\CLIPP.FDB') or // Compufour
          AnsiContainsText(sLinha, '\DADOS.FDB') or // Digisat
          AnsiContainsText(sLinha, '\BASESGMASTER.FDB') or // SGBR
          AnsiContainsText(sLinha, '\DATAGES.FDB') or // GDOOR
          AnsiContainsText(sLinha, '\DATAGES.GDB') // GDOOR
         )
        and (AnsiContainsText(sLinha, 'Recycle') = False) // desconsiderar lixeira do Windows
      then
      begin
        //
        // Abre os bancos selecionados e identifica se o CNPJ do emitente é igual ao cnpj informado na instalação
        //
        try
          IBDatabase1.Close;
          IBDatabase1.DatabaseName := sLinha;
          IBDatabase1.Open;
          //
          if Pos('CLIPP.FDB', AnsiUpperCase(sLinha)) > 0 then
          begin
            IBQuery1.Close;
            IBQuery1.SQL.Text :=
              'select CNPJ ' +
              'from TB_EMITENTE ' +
              'where coalesce(CNPJ, '''') <> '''' ';
            IBQuery1.Open;
            if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
            begin
              //
              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select max(DATA) as DATA ' +
                'from ( ' +
                'select max(DT_CUPOM) as DATA ' +
                'from TB_CUPOM ' +
                'union ' +
                'select max(DT_EMISSAO) as DATA ' +
                'from TB_NFVENDA ' +
                ')';
              IBQuery1.Open;
              AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
              //
            end;
          end;

          if Pos('BASESGMASTER.FDB', AnsiUpperCase(sLinha)) > 0 then
          begin
            IBQuery1.Close;
            IBQuery1.SQL.Text :=
              'select CNPJ ' +
              'from TEMITENTE ' +
              'where coalesce(CNPJ, '''') <> '''' ';
            IBQuery1.Open;
            if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
            begin
              {Sandro Silva 2019-10-25 inicio}
              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select max(DATA) as DATA ' +
                'from ( ' +
                'select max(DATAEMISSAOECF) as DATA ' +
                'from TVENDAECF ' +
                'union ' +
                'select max(DATAEMISSAO) as DATA ' +
                'from TVENDANFCE ' +
                'union ' +
                'select max(DATAEMISSAO) as DATA ' +
                'from TVENDANFE ' +
                ')';
              IBQuery1.Open;
              AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
            end;
          end;

          if (Pos('DATAGES.FDB', AnsiUpperCase(sLinha)) > 0) or (Pos('DATAGES.GDB', AnsiUpperCase(sLinha)) > 0) then
          begin
            IBQuery1.Close;
            IBQuery1.SQL.Text :=
              'select CNPJ ' +
              'from EMITENTE ' +
              'where coalesce(CNPJ, '''') <> '''' ';
            IBQuery1.Open;
            if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
            begin
              {Sandro Silva 2019-10-25 inicio}
              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select max(DATA_EMISSAO) as DATA from VENDAS ' ;
              IBQuery1.Open;
              AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
            end;
          end;

          if (Pos('DADOS.FDB', AnsiUpperCase(sLinha)) > 0) then
          begin

            // tenta identificar a versão do sistema digisat pelo caminho

            if (Pos('\G4\', AnsiUpperCase(sLinha)) > 0) then
            begin
              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select CNPJ ' +
                'from EMITENTE ' +
                'where coalesce(CNPJ, '''') <> '''' ';
              IBQuery1.Open;
              if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
              begin
                {Sandro Silva 2019-10-25 inicio}
                IBQuery1.Close;
                IBQuery1.SQL.Text :=
                  'select max(data) ' +
                  'from ( ' +
                  'select max(DATA_HORA) as data ' +
                  'from VENDAS_NFCE ' +
                  'union ' +
                  'select cast(max(DATA_AUTORIZACAO) AS timestamp) as data ' +
                  'from VENDAS_NFE ' +
                  'union ' +
                  'select cast(max(DATA||'' ''||HORA) as timestamp) as data ' +
                  'from VENDAS_ECF ' +
                  'union ' +
                  'select cast(max(EMISSAO) as timestamp) as data ' +
                  'from VENDAS ' +
                  ')';
                IBQuery1.Open;
                AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
                //
              end;
            end
            else if (Pos('\G5\', AnsiUpperCase(sLinha)) > 0) then
            begin
              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select D.NUMERO as CNPJ ' +
                'from PESSOA P ' +
                'join DOCUMENTO D on D.PESSOAID = P.ID and upper(D.TIPO) = ''CNPJ'' ' +
                'where P.EMITENTEID is not null';
              IBQuery1.Open;
              if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
              begin
                {Sandro Silva 2019-10-25 inicio}
                IBQuery1.Close;
                IBQuery1.SQL.Text :=
                  'select max(DATAHORAEMISSAO) as DATA ' +
                  'from MOVIMENTACAO';
                IBQuery1.Open;
                AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
                //
              end;
            end
            else
            begin
               //Analisa a estrutura do banco para definir a versão do sistema digisat e validar o cnpj do emitente

              IBQuery1.Close;
              IBQuery1.SQL.Text :=
                'select F.RDB$RELATION_NAME as TABELA, F.RDB$FIELD_NAME as CAMPO ' +
                'from RDB$RELATION_FIELDS F ' +
                'join RDB$RELATIONS R on F.RDB$RELATION_NAME = R.RDB$RELATION_NAME ' +
                'and R.RDB$VIEW_BLR is null ' +
                'and (R.RDB$SYSTEM_FLAG is null or R.RDB$SYSTEM_FLAG = 0) ';
                //'and upper(F.RDB$FIELD_NAME) = ''CNPJ'' and upper(F.RDB$RELATION_NAME) = ''EMITENTE'' ';
              IBQuery1.Open;

              if IBQuery1.Locate('TABELA;CAMPO', VarArrayOf(['EMITENTE', 'CNPJ']), []) then //localizar tabela EMITENTE com campo PERFIL_SPEED  = G4
              begin
                IBQuery1.Close;
                IBQuery1.SQL.Text :=
                  'select CNPJ ' +
                  'from EMITENTE ' +
                  'where coalesce(CNPJ, '''') <> '''' ';
                IBQuery1.Open;
                if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
                begin

                  {Sandro Silva 2019-10-25 inicio}
                  IBQuery1.Close;
                  IBQuery1.SQL.Text :=
                    'select max(data) ' +
                    'from ( ' +
                    'select max(DATA_HORA) as data ' +
                    'from VENDAS_NFCE ' +
                    'union ' +
                    'select cast(max(DATA_AUTORIZACAO) AS timestamp) as data ' +
                    'from VENDAS_NFE ' +
                    'union ' +
                    'select cast(max(DATA||'' ''||HORA) as timestamp) as data ' +
                    'from VENDAS_ECF ' +
                    'union ' +
                    'select cast(max(EMISSAO) as timestamp) as data ' +
                    'from VENDAS ' +
                    ')';
                  IBQuery1.Open;
                  AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
                  //
                end;
              end
              else if IBQuery1.Locate('TABELA;CAMPO', VarArrayOf(['EMITENTE', 'RAMODEATIVIDADE']), []) then //localizar tabela EMITENTE com campo RAMODEATIVIDADE  = G5
              begin
                IBQuery1.Close;
                IBQuery1.SQL.Text :=
                  'select D.NUMERO as CNPJ ' +
                  'from PESSOA P ' +
                  'join DOCUMENTO D on D.PESSOAID = P.ID and upper(D.TIPO) = ''CNPJ'' ' +
                  'where P.EMITENTEID is not null';
                IBQuery1.Open;

                if (LimpaNumero(IBQuery1.FieldByName('CNPJ').AsString) = Form1.sCNPJ) and (Form1.sCNPJ <> '') then
                begin
                  //
                  IBQuery1.Close;
                  IBQuery1.SQL.Text :=
                    'select max(DATAHORAEMISSAO) as DATA ' +
                    'from MOVIMENTACAO';
                  IBQuery1.Open;
                  AdicionaNaListaImportacao(sLinha, StrToDateDef(FormatDateTime('dd/mm/yyyy', IBQuery1.FieldByName('DATA').AsDateTime), StrToDate('30/12/1899')));
                  //
                end;
              end;
            end;
          end;
          //
          IBQuery1.Close;
          IBDatabase1.Close;
          //
        except

        end;
        //
        Inc(I); // Sandro Silva 2019-10-25
        Application.ProcessMessages;
        //
      end; // Validação se é um banco para converter
    end; // while not Eof(F) Do
    //
    if Trim(CDSBANCOS.FieldByName('BANCO').AsString) <> '' then
    begin
      Label8.Caption := 'AGUARDE!';
      Label8.Repaint;
      ShellExecute(Application.Handle, 'open', PAnsiChar('ConversorSmall.exe'), PAnsiChar('"' + CDSBANCOS.FieldByName('BANCO').AsString + '"'), '', SW_HIDE);

      sMensagemPadrao := 'Estamos trabalhando no seu novo Banco'+Chr(10)+
                         'de Dados. Agora estamos importando'+Chr(10)+
                         'o seu cadastro de Clientes'+Chr(10)+
                         'e produtos.'+Chr(10)+Chr(10)+
                         'Aguarde, não desligue o computador.';
      Label1.Caption  := sMensagemPadrao;
      Form1.Repaint;
      //
      while ConsultaProcesso('ConversorSmall.exe') do
      begin
        Sleep(100);
        Application.ProcessMessages;
      end;
      //
    end;
    //
    CloseFile(F);
    //
    // Importar XML
    //
    begin
      //
      try
        //
        //
        Label8.Caption := 'AGUARDE!';
        ActiveControl := nil;
        //
        sMensagemPadrao := 'Estamos trabalhando no seu novo Banco de'+chr(10)+
                           'Dados, vamos importar seu cadastro de'+chr(10)+
                           'de Clientes, seu Estoque, as NF-e´s'+chr(10)+
                           'emitidas e as contas'+chr(10)+
                           'a Receber.'+Chr(10)+Chr(10)+
                           'Estamos separando os arquivos XML emitidos pelo'+chr(10)+
                           'CNPJ: '+FormataCpfCgc(Form1.sCNPJ)+'.'+Chr(10)+Chr(10)+
                           'Aguarde, não desligue o computador.';
        //
        Gauge1.Visible := False;
        Label1.Caption  := sMensagemPadrao;
        Form1.Repaint;
        //
        Screen.Cursor := crAppStart;
        Application.ProcessMessages;
        //
        IBDatabase1.Close;
        IBDatabase1.Params.Clear;
        IbDatabase1.DatabaseName := url;
        IBDatabase1.Params.Add('USER_NAME=SYSDBA');
        IBDatabase1.Params.Add('PASSWORD=masterkey');
        IbDatabase1.Open;
        IBTransaction1.Active := True;
        //
        Form1.ibQuery1.DisableControls;
        Form1.ibQuery2.DisableControls;
        Form1.ibQuery3.DisableControls;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index IND14NOME active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index IND4REFERENCIA active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index IND4DESCRICAO active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index IND15NUMERONF active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('CREATE INDEX IDX_CLIFOR_UPPERNOME ON CLIFOR COMPUTED BY (UPPER(NOME));');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index IDX_CLIFOR_UPPERNOME active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        // Este arquivo esta sendo criado acima
        //
        while RenameFile(PChar('files1.tmp'), PChar('files1.txt')) = False do
        begin
          Sleep(100);
          Application.ProcessMessages;
        end;
        {Sandro Silva 2019-10-25 fim}
        //
        AssignFile(F, 'files1.txt');
        Reset(F);
        //
        X := 0;
        I := 0;
        iAnos := 5;
        I := 0;
        Form1.sUltimaNotaImportada := 'XXXXXXXXXXYYY';
        //
        Form1.ibQuery1.Close;
        Form1.ibQuery1.SQL.Clear;
        Form1.ibQuery1.SQL.Add('create table IMPORTA (CAMINHO VARCHAR(512), DATA VARCHAR(4), MODELO VARCHAR(2), SERIE VARCHAR(9), NUMERONF VARCHAR(10), ID VARCHAR(44), CSTAT VARCHAR(3))');
        Form1.IBQuery1.ExecSQL;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('create descending index MAISRECENTES on IMPORTA(MODELO, SERIE, NUMERONF)');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        try
          Form1.ibQuery1.Close;
          Form1.ibQuery1.SQL.Clear;
          Form1.ibQuery1.SQL.Add('alter index MAISRECENTES active');
          Form1.ibQuery1.ExecSQL;
        except end;
        //
        IBTransaction1.Commit;
        //
        try
          // Sandro Silva 2019-10-31 inicio
          // Seleciona os municípios para importar o nome corretamente
          IBQMUNICIPIOS.Close;
          IBQMUNICIPIOS.SQL.Text := 'select * from MUNICIPIOS where CODIGO = :CODIGO';
          IBQMUNICIPIOS.Prepare;
          IBQMUNICIPIOS.DisableControls;
          // Sandro Silva 2019-10-31 fim
        except
        end;
        //
        Form1.IBQuery3.Close;
        Form1.IBQuery3.SQL.Clear;
        Form1.IBQuery3.SQL.Add('insert into IMPORTA (CAMINHO, DATA, MODELO, SERIE, NUMERONF, ID, CSTAT) values (:CAMINHO, :DATA, :MODELO, :SERIE, :NUMERONF, :ID, :CSTAT)');
        Form1.IBQuery3.Prepare;
        ActiveControl := nil;
        //
        while not Eof(F) Do
        begin
          //
          ReadLn(F, sLinha);
          //
          if (pos('\windows',LowerCase(sLinha))=0) and
             (pos('\templates\',LowerCase(sLinha))=0) and
             (pos('\microsoft',LowerCase(sLinha))=0) and
             (pos('\microsoft',LowerCase(sLinha))=0) and
             (pos('\winwxw\',LowerCase(sLinha))=0)
              and (AnsiContainsText(sLinha, 'Recycle') = False)
              and (AnsiContainsText(sLinha, 'samples') = False)
              and (AnsiContainsText(sLinha, '\Blocox\') = False)
              and (AnsiContainsText(sLinha, '\bemalog_') = False)
              and (AnsiContainsText(sLinha, '\bemaSATlog_') = False)
              and (AnsiContainsText(sLinha, '-ci-mde.xml') = False) // Manifesto DFe
              and (AnsiContainsText(sLinha, '-co-mde.xml') = False) // Manifesto DFe
              and (AnsiContainsText(sLinha, '-mdfe.xml') = False) // MDF-e
              and (AnsiContainsText(sLinha, '-enc.xml') = False)  // MDF-e
              and (AnsiContainsText(sLinha, '-inccond.xml') = False) // MDF-e
              and (AnsiContainsText(sLinha, '-env-dfe.xml') = False) // NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-ret-dfe.xml') = False) // NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-mandest-env.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-mandest-ret.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-pro-rec.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-rec.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-env-lot.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-env-sinc-ret.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '\Java\jdk') = False)// Instalação JAVA jdk
              and (AnsiContainsText(sLinha, '\Embarcadero\Studio') = False)// Arquivos Delphi
              and (AnsiContainsText(sLinha, '\Android\') = False)// Arquivos android
             then
          begin
            X := X + 1;
          end;
          //
        end;
        //
        I := 0;
        Gauge1.Progress := 0;
        Gauge1.Visible  := True;
        Timer1.Enabled  := True;
        //
        Reset(F);
        //
        while not Eof(F) Do
        begin
          //
          Application.ProcessMessages;
          ReadLn(F, sLinha);
          //
          if (pos('\windows',LowerCase(sLinha))=0) and
             (pos('\templates\',LowerCase(sLinha))=0) and
             (pos('\microsoft',LowerCase(sLinha))=0) and
             (pos('\microsoft',LowerCase(sLinha))=0) and
             (pos('\winwxw\',LowerCase(sLinha))=0)
              and (AnsiContainsText(sLinha, 'Recycle') = False)
              and (AnsiContainsText(sLinha, 'samples') = False)
              and (AnsiContainsText(sLinha, '\Blocox\') = False)
              and (AnsiContainsText(sLinha, '\bemalog_') = False)
              and (AnsiContainsText(sLinha, '\bemaSATlog_') = False)
              and (AnsiContainsText(sLinha, '-ci-mde.xml') = False) // Manifesto DFe
              and (AnsiContainsText(sLinha, '-co-mde.xml') = False) // Manifesto DFe
              and (AnsiContainsText(sLinha, '-mdfe.xml') = False) // MDF-e
              and (AnsiContainsText(sLinha, '-enc.xml') = False)  // MDF-e
              and (AnsiContainsText(sLinha, '-inccond.xml') = False) // MDF-e
              and (AnsiContainsText(sLinha, '-env-dfe.xml') = False) // NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-ret-dfe.xml') = False) // NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-mandest-env.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-mandest-ret.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-pro-rec.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-rec.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-env-lot.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '-env-sinc-ret.xml') = False)// NFC-e/NF-e
              and (AnsiContainsText(sLinha, '\Java\jdk') = False)// Instalação JAVA jdk
              and (AnsiContainsText(sLinha, '\Embarcadero\Studio') = False)// Arquivos Delphi
              and (AnsiContainsText(sLinha, '\Android\') = False)// Arquivos android
          then
          begin
            //
            I       := I + 1;
            //
            sID     := '';
            sModelo := '';
            sCStat  := '';
            //
            //
            try
              FXMLNFE.load(sLinha);
            except end;
            //
            try
              //
              sID    := xmlNodeValue2('//chNFe');
              scStat := xmlNodeValue2('//cStat');
              //
              if sID = '' then
                sId := LimpaNumero(xmlNodeValue2('//infCFe/@Id')); // S@t

              if Pos('CHCANC', AnsiUpperCase(FXMLNFE.xml)) > 0 then // Para SAT deve extrair a chave cancelada // Sandro Silva 2019-11-01
                sID :=  LimpaNumero(xmlNodeValue2('//infCFe/@chCanc'));
              //
            except end;
            try
              //
              if Length(sID) = 44 then
              begin
                //
                if (Pos(Form1.sCNPJ,sID) <> 0) then
                begin
                  sModelo := Copy(sID,21,2);
                  //
                  if (((sModelo = '55') or (sModelo = '65') or (sModelo = '59')) and (Form1.xmlNodeValue2('//tpAmb')='1'))
                    or ((sModelo = '59') and (Pos('INFCFE', AnsiUpperCase(FXMLNFE.xml)) > 0) and (Pos('VERSAO=', AnsiUpperCase(FXMLNFE.xml)) > 0) and (Pos('ID=', AnsiUpperCase(FXMLNFE.xml)) > 0)) // SAT cancelado não tem tpAmb no xml
                   then
                  begin
                    //
                    if Copy(sID,3,2) >= Copy(StrZero(Year(Date)-iAnos,4,0),3,2) then
                    begin
                      //
                      Application.ProcessMessages;
                      //
                      try

                        if Copy(sID,21,2) = '59' then // SAT
                        begin
                          sSerie  := Copy(sId, 23, 9); // núm. série sat
                          sNumero := Copy(sId, 32, 6);

                          // Sandro Silva 2019-10-31 inicio
                          // No xml do sat não existe a tag cstat
                          // identifica se está autorizado ou cancelado e atribui o mesmo código padrão de cstat definidos no manual da NF-e para manter compatibilidade de validação na sequência da conversão
                          if (Pos('INFCFE', AnsiUpperCase(FXMLNFE.xml)) > 0) and (Pos('VERSAO=', AnsiUpperCase(FXMLNFE.xml)) > 0) and (Pos('ID=', AnsiUpperCase(FXMLNFE.xml)) > 0) then // SAT autorizado e cancelamento
                          begin
                            scStat := '100'; // Autorizado
                            if Pos('CHCANC', AnsiUpperCase(FXMLNFE.xml)) > 0 then // Valida se está cancelado
                              scStat := '135'; // Cancelado
                          end;
                          // Sandro Silva 2019-10-31 fim
                        end
                        else
                        begin
                          sSerie  := Copy(sID,23,3); // núm. série NFe/NFCe
                          sNumero := Copy(sID,26,9);
                        end;
                        //
                        if (scStat = '100') or (scStat = '150') or (scStat = '136') or (scStat = '155') or (scStat = '135') then
                        begin
                          //
                          Form1.IBQuery3.ParamByName('CAMINHO').AsString   := Trim(Copy(sLinha,1,512));
                          //
                          // cUF - Código da UF do emitente do Documento Fiscal;
                          // AAMM - Ano e Mês de emissão da NF-e;
                          // CNPJ - CNPJ do emitente;
                          // mod - Modelo do Documento Fiscal;
                          // serie - Série do Documento Fiscal;
                          // nNF - Número do Documento Fiscal;
                          // tpEmis – forma de emissão da NF-e;
                          // cNF - Código Numérico que compõe a Chave de Acesso;
                          // cDV - Dígito Verificador da Chave de Acesso.
                          // ufaammxxxxxxxxxxxxxxmdsss..........
                          // 42190907426598000124550010000977381004640327-nfe
                          Form1.IBQuery3.ParamByName('DATA').AsString      := Copy(sID,3,4);
                          Form1.IBQuery3.ParamByName('MODELO').AsString    := sModelo;
                          Form1.IBQuery3.ParamByName('SERIE').AsString     := sSerie;
                          Form1.IBQuery3.ParamByName('NUMERONF').AsString  := sNumero;
                          Form1.IBQuery3.ParamByName('ID').AsString        := sID;
                          Form1.IBQuery3.ParamByName('CSTAT').AsString     := scStat;
                          Form1.IBQuery3.ExecSQL;
                          //
                        end;
                        //
                        II := II + 1;
                        //
                      except end;
                      //
                    end;
                  end;
                end;
              end;
            except end;
          end;
          //
        end;
        //
        CloseFile(F);
        //
        // Prepara os insert dentro da Query
        //
        Form1.IbqItens001.Close;
        Form1.IbqItens001.SQL.Clear;
        Form1.IbqItens001.SQL.Add('insert into ITENS001 ('
        +'REGISTRO'
        +',NUMERONF'
        +',CODIGO'
        +',DESCRICAO'
        +',QUANTIDADE'
        +',SINCRONIA'
        +',UNITARIO'
        +',TOTAL'
        +',XPED'
        +',NITEMPED'
        +',VICMS'
        +',VBC'
        +',VBCST'
        +',VICMSST'
        +',IPI'
        +',ICM'
        +',MEDIDA'
        +',BASE'
        +',CFOP'
        +',VIPI'
        +',CST_PIS_COFINS'
        +',ALIQ_PIS'
        +',ALIQ_COFINS'
        +',CST_IPI'
        +',CST_ICMS'
        +') values ('
        +'right(''0000000000''||gen_id(G_ITENS001,1),10)'
        +',:NUMERONF'
        +',:CODIGO'
        +',:DESCRICAO'
        +',:QUANTIDADE'
        +',:SINCRONIA'
        +',:UNITARIO'
        +',:TOTAL'
        +',:XPED'
        +',:NITEMPED'
        +',:VICMS'
        +',:VBC'
        +',:VBCST'
        +',:VICMSST'
        +',:IPI'
        +',:ICM'
        +',:MEDIDA'
        +',:BASE'
        +',:CFOP'
        +',:VIPI'
        +',:CST_PIS_COFINS'
        +',:ALIQ_PIS'
        +',:ALIQ_COFINS'
        +',:CST_IPI'
        +',:CST_ICMS'
        +')'
        );
        Form1.IbqItens001.Prepare;
        //
        Form1.ibqVendas.Close;
        Form1.ibqVendas.SQL.Clear;
        Form1.ibqVendas.SQL.Add('insert into VENDAS ('
        +'REGISTRO'
        +',NUMERONF'
        +',EMISSAO'
        +',MODELO'
        +',CLIENTE'
        +',NFEXML'
        +',NFEID'
        +',STATUS'
        +',TOTAL'
        +',FRETE'
        +',SEGURO'
        +',DESPESAS'
        +',DESCONTO'
        +',BASEICM'
        +',ICMS'
        +',BASESUBSTI'
        +',IPI'
        +',MERCADORIA'
        +',OPERACAO'
        +',EMITIDA'
        +',VOLUMES'
        +',ESPECIE'
        +',MARCA'
        +',FRETE12'
        +',SAIDAD'
        +',DUPLICATAS'
        +',BASEISS'
        +',ICMSSUBSTI'
        +',ISS'
        +',SERVICOS'
        +',PESOBRUTO'
        +',PESOLIQUI'
        +',NFEPROTOCOLO'
        +',COMPLEMENTO'
        +',NVOL'
        +') values ('
        +'right(''0000000000''||gen_id(G_VENDAS, 1), 10)'
        +',:NUMERONF'
        +',:EMISSAO'
        +',:MODELO'
        +',:CLIENTE'
        +',:NFEXML'
        +',:NFEID'
        +',:STATUS'
        +',:TOTAL'
        +',:FRETE'
        +',:SEGURO'
        +',:DESPESAS'
        +',:DESCONTO'
        +',:BASEICM'
        +',:ICMS'
        +',:BASESUBSTI'
        +',:IPI'
        +',:MERCADORIA'
        +',:OPERACAO'
        +',:EMITIDA'
        +',:VOLUMES'
        +',:ESPECIE'
        +',:MARCA'
        +',:FRETE12'
        +',:SAIDAD'
        +',:DUPLICATAS'
        +',:BASEISS'
        +',:ICMSSUBSTI'
        +',:ISS'
        +',:SERVICOS'
        +',:PESOBRUTO'
        +',:PESOLIQUI'
        +',:NFEPROTOCOLO'
        +',:COMPLEMENTO'
        +',:NVOL'
        +')'
        );
        Form1.ibqVendas.Prepare;
        //
        Form1.IbqReceber.Close;
        Form1.IbqReceber.SQL.Clear;
        Form1.IbqReceber.SQL.Add('insert into RECEBER ('
        +'REGISTRO'
        +',HISTORICO'
        +',DOCUMENTO'
        +',NOME'
        +',EMISSAO'
        +',VENCIMENTO'
        +',VALOR_DUPL'
        +',NUMERONF'
        +',ATIVO'
        +',VALOR_RECE'
        +') values ('
        +'right(''0000000000''||gen_id(G_RECEBER, 1), 10)'
        +',:HISTORICO'
        +',:DOCUMENTO'
        +',:NOME'
        +',:EMISSAO'
        +',:VENCIMENTO'
        +',:VALOR_DUPL'
        +',:NUMERONF'
        +',:ATIVO'
        +',:VALOR_RECE'
        +')'
        );
        Form1.IbqReceber.Prepare;
        //
        Form1.IbqClifor.Close;
        Form1.IbqClifor.SQL.Clear;
        Form1.IbqClifor.SQL.Add('insert into CLIFOR ('
        +'REGISTRO'
        +',CGC'
        +',NOME'
        +',IE'
        +',ENDERE'
        +',COMPLE'
        +',CIDADE'
        +',ESTADO'
        +',CEP'
        +',FONE'
        +',CADASTRO'
        +',EMAIL'
        +') values ('
        +'right(''0000000000''||gen_id(G_CLIFOR, 1), 10)'
        +',:CGC'
        +',:NOME'
        +',:IE'
        +',:ENDERE'
        +',:COMPLE'
        +',:CIDADE'
        +',:ESTADO'
        +',:CEP'
        +',:FONE'
        +',current_date'
        +',:EMAIL'
        +')'
        );
        Form1.IbqClifor.Prepare;
        //
        Form1.IbqEstoque.Close;
        Form1.IbqEstoque.Sql.Clear;
        Form1.IbqEstoque.SQL.Add('insert into ESTOQUE ('
        +'REGISTRO'
        +',CODIGO'
        +',REFERENCIA'
        +',DESCRICAO'
        +',MEDIDA'
        +',PRECO'
        +',CF'
        +',CODIGO_FCI'
        +',ULT_VENDA'
        +',CSOSN'
        +',CST'
        +',TIPO_ITEM'
        +',CST_PIS_COFINS_SAIDA'
        +',ALIQ_PIS_SAIDA'
        +',ALIQ_COFINS_SAIDA'
        +',PIVA'
        +',CFOP'
        +',IPI'
        +',CST_IPI'
        +',ENQ_IPI'
        +') values ('
        +':REGISTRO'
        +',:CODIGO'
        +',:REFERENCIA'
        +',:DESCRICAO'
        +',:MEDIDA'
        +',:PRECO'
        +',:CF'
        +',:CODIGO_FCI'
        +',:ULT_VENDA'
        +',:CSOSN'
        +',:CST'
        +',:TIPO_ITEM'
        +',:CST_PIS_COFINS_SAIDA'
        +',:ALIQ_PIS_SAIDA'
        +',:ALIQ_COFINS_SAIDA'
        +',:PIVA'
        +',:CFOP'
        +',:IPI'
        +',:CST_IPI'
        +',:ENQ_IPI'
        +')'
        );
        Form1.IbqEstoque.Prepare;
        //
        Form1.IbqNFCe.Close;
        Form1.IbqNFCe.SQL.Clear;
        Form1.IbqNFCe.SQL.Add('insert into NFCE ('
        +'REGISTRO'
        +',NUMERONF'
        +',STATUS'
        +',NFEID'
        +',NFEXML'
        +',DATA'
        +',CAIXA'
        +',MODELO'
        +',TOTAL'
        +') values ('                  
        +'right(''0000000000''||gen_id(G_NFCE,1),10)'
        +',:NUMERONF'
        +',:STATUS'
        +',:NFEID'
        +',:NFEXML'
        +',:DATA'
        +',:CAIXA'
        +',:MODELO'
        +',:TOTAL'
        +')'
        );
        Form1.IbqNFCe.Prepare;
        //
        Form1.IbqAlteraca.Close;
        Form1.IbqAlteraca.SQL.Clear;
        Form1.IbqAlteraca.SQL.Add('insert into ALTERACA ('
        +'REGISTRO'
        +',CODIGO'
        +',DESCRICAO'
        +',QUANTIDADE'
        +',MEDIDA'
        +',UNITARIO'
        +',TOTAL'
        +',DATA'
        +',TIPO'
        +',PEDIDO'
        +',ITEM'
        +',CLIFOR'
        +',CAIXA'
        +',VALORICM'
        +',ALIQUICM'
        +',CST_PIS_COFINS'
        +',DESCONTO'
        +',COO'
        +',CCF'
        +',CNPJ'
        +',REFERENCIA'
        +',HORA'
        +',CFOP'
        +',CST_ICMS'
        +',CSOSN'
        +') values ('
        +'right(''0000000000''||gen_id(G_ALTERACA,1),10)'
        +',:CODIGO'
        +',:DESCRICAO'
        +',:QUANTIDADE'
        +',:MEDIDA'
        +',:UNITARIO'
        +',:TOTAL'
        +',:DATA'
        +',:TIPO'
        +',:PEDIDO'
        +',:ITEM'
        +',:CLIFOR'
        +',:CAIXA'
        +',:VALORICM'
        +',:ALIQUICM'
        +',:CST_PIS_COFINS'
        +',:DESCONTO'
        +',:COO'
        +',:CCF'
        +',:CNPJ'
        +',:REFERENCIA'
        +',:HORA'
        +',:CFOP'
        +',:CST_ICMS'
        +',:CSOSN'
        +')'
        );
        Form1.IbqAlteraca.Prepare;
        //
        //
        Form1.IBQPAGAMENT.Close;
        Form1.IBQPAGAMENT.SQL.Text :=
        'insert into PAGAMENT (' +
        'REGISTRO' +
        ', DATA' +
        ', PEDIDO' +
        ', CAIXA' +
        ', CLIFOR' +
        ', FORMA' +
        ', VALOR' +
        ', CCF' +
        ', COO' +
        ', GNF' +
        ') values (' +
        'right(''0000000000''||gen_id(G_PAGAMENT,1),10)' +
        ', :DATA' +
        ', :PEDIDO' +
        ', :CAIXA' +
        ', :CLIFOR' +
        ', :FORMA' +
        ', :VALOR' +
        ', :CCF' +
        ', :COO' +
        ', :GNF' +
        ')';
        Form1.IBQPAGAMENT.Prepare;

        //
        sMensagemPadrao := 'Estamos trabalhando no seu novo banco de Dados,'+Chr(10)+
                           'encontramos '+IntToStr(II)+' arquivos xml.'+Chr(10)+Chr(10)+
                           'Agora estamos importando O cadastro de Clientes,'+chr(10)+
                           'cadastro de Produtos, NF-e´s'+Chr(10)+
                           'emitidas e as contas'+Chr(10)+
                           'a receber.'+Chr(10)+chr(10)+
                           'Aguarde, não desligue o computador.';
        Label1.Caption  := sMensagemPadrao;
        Form1.Repaint;
        //
        I := 0;
        X := II;
        //
        Gauge1.Visible  := True;
        Gauge1.Progress := 0;
        Timer1.Enabled  := True;
        Gauge1.Visible  := True;
        //
        Form1.sUltimaNotaImportada := 'XXXXXXXXXXYYY';
        //
        Form1.IBQuery3.Close;
        Form1.IBQuery3.SQL.Text := 'select * from IMPORTA order by MODELO, SERIE, NUMERONF desc, CSTAT';
        Form1.IBQuery3.Open;
        Form1.IBQuery3.First;
        //
        //
        while not Form1.IBQuery3.Eof do
        begin
          I := I + 1;
          ImportaXML(Form1.IBQuery3.FieldByname('CAMINHO').AsString);
          Application.ProcessMessages;
          Form1.IBQuery3.Next;
        end;
        //
        try
          //
          // IBTransaction1.Commit;
          //
          try
            //Form1.IBQuery3.Close;
            //Form1.IBQuery3.SQL.Text := 'drop table IMPORTA';
            //Form1.IBQuery3.ExecSQL;
          except end;
          //
          try
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('set generator G_BUILD to 999');
            Form1.ibQuery1.ExecSQL;
          except end;
          //
          try
            {Ajusta sequencial do número da NFC-e}
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('select cast(max(NUMERONF) as integer) as NUMERO from NFCE where MODELO = ''65'' '); // Sandro Silva 2019-11-01 Form1.ibQuery1.SQL.Add('select cast(max(NUMERONF) as integer) as NUMERO from NFCE');
            Form1.ibQuery1.Open;

            sGen := (Form1.ibQuery1.FieldByName('NUMERO').AsString);

            if sGen <> '' then
            begin
              Form1.ibQuery1.SQL.Clear;
              Form1.ibQuery1.SQL.Add('set generator G_NUMERONFCE to ' + sGen);
              Form1.ibQuery1.Close;
              Form1.ibQuery1.ExecSQL;
            end;
          except end;

          // Sandro Silva 2019-11-01 inicio
          try

            // Seleciona o maior número de SAT para cada caixa e acerta o generator
            Form1.ibQuery1.Close;
            Form1.ibQuery1.SQL.Clear;
            Form1.ibQuery1.SQL.Add('select cast(max(NUMERONF) as integer) as NUMERO, CAIXA from NFCE where MODELO = ''59'' group by CAIXA '); // Sandro Silva 2019-11-01 Form1.ibQuery1.SQL.Add('select cast(max(NUMERONF) as integer) as NUMERO from NFCE');
            Form1.ibQuery1.Open;

            while Form1.IBQuery1.Eof = False do
            begin
              try
                if IBQuery1.FieldByName('NUMERO').AsString <> '' then
                begin

                  //Identifica se existe no banco um generator para o caixa
                  Form1.ibQuery2.Close;
                  Form1.ibQuery2.SQL.Text :=
                    'select trim(RDB$GENERATOR_NAME) as GENERATOR_NAME ' +
                    'from RDB$GENERATORS ' +
                    'where RDB$GENERATOR_NAME = ' + QuotedStr('G_NUMEROCFESAT_' + Form1.ibQuery1.FieldByName('CAIXA').AsString);
                  Form1.ibQuery2.Open;

                  if Form1.ibQuery2.FieldByName('GENERATOR_NAME').AsString = '' then
                  begin
                    // Cria o generator se não existir
                    Form1.ibQuery2.Close;
                    Form1.ibQuery2.SQL.Text :=
                      'create sequence G_NUMEROCFESAT_' + Form1.ibQuery1.FieldByName('CAIXA').AsString;
                    Form1.ibQuery2.ExecSQL;
                  end;

                  //Acerta o generator com maior SAT do caixa
                  Form1.ibQuery2.Close;
                  Form1.ibQuery2.SQL.Text :=
                    'alter sequence G_NUMEROCFESAT_' + IBQuery1.FieldByName('CAIXA').AsString + ' restart with ' + IBQuery1.FieldByName('NUMERO').AsString;
                  Form1.ibQuery2.ExecSQL;

                end;
                  
              except
              end;
                  
              Form1.IBQuery1.Next;
            end;
          except
          end;
          // Sandro Silva 2019-11-01 fim

          //
          IBTransaction1.Commit;
          //
          IbDatabase1.Close;
          //
        except end;
        //
        try
          SmallIni := TIniFile.Create(sAtual+'\small.ini');
          SmallIni.WriteString('T','Tempo', pChar(TimeToStr(Time - tInicio)) );
          SmallIni.Free;
        except end;
        //
        Screen.Cursor := crDefault;
        //
      except
        on e:exception do
        begin
          ShowMessage('Não foi possível criar o arquivo small.fdb verifique:'+chr(10)
            +chr(10)+'1 - Verifique se existe a pasta '+sURL
            +chr(10)+'2 - Desative o seu antivirus durante a instalação'
            +chr(10)+'3 - Desative o Firewal do Windows durante a instalação'
            +chr(10)+'4 - Verifique outros programas conflitantes'+chr(10)+chr(10)+
            e.Message+chr(10)+'Erro: 3170');
        end;
      end;
      //
    end;
    //
    Screen.Cursor := crDefault;
    Close;
    //
  except
    on e:exception do
    begin
      ShowMessage('Não foi possível criar o arquivo small.fdb verifique:'+chr(10)
        +chr(10)+'1 - Verifique se existe a pasta '+sURL
        +chr(10)+'2 - Desative o seu antivirus durante a instalação'
        +chr(10)+'3 - Desative o Firewal do Windows durante a instalação'
        +chr(10)+'4 - Verifique outros programas conflitantes'+chr(10)+chr(10)+
        e.Message+chr(10)+'Erro: 3185');
    end;
  end;
  //
  Screen.Cursor := crDefault;
  Close;
  //
end;

procedure TForm1.Button5MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := 'Vamos criar um novo Banco de Dados'+chr(10)+'totalmente em branco.';
  Label1.Repaint;
end;

procedure TForm1.Button3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := 'Vamos criar um novo Banco de Dados'+chr(10)+'exemplo.';
  Label1.Repaint;
end;

procedure TForm1.Button1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := 'Se já existe um sistema instalado neste computador'+chr(10)+
                    'selecione esta opção para converter os dados.'+chr(10)+Chr(10)+

                    'Vamos trabalhar para converter seu cadastro'+chr(10)+
                    'de Clientes, Estoque, Contas a Receber'+chr(10)+
                    'e NF-e´s emitidas.';
  Label1.Repaint;
end;

procedure TForm1.Button7MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := 'Sair sem criar o Banco de Dados.';
  Label1.Repaint;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := sMensagemPadrao;
  Label1.Repaint;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  I : Integer;
begin
//  if Form1.Gauge1.Visible then
  begin
    try
      //
      I := Random(12);
      //
      if FileExists(Form1.sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp') then
      begin
        Form1.Image1.Picture.LoadFromFile(Form1.sAtual+'\inicial\fundo\_small_'+IntToStr(I)+'.bmp');
        Form1.Image1.Repaint;
      end;
      //
    except end;
  end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Caption := sMensagemPadrao;
  Label1.Repaint;

end;

function TForm1.NomeMunicipio(sCodigo: String): String;
begin
  Result := '';
  try
    IBQMUNICIPIOS.Close;
    IBQMUNICIPIOS.ParamByName('CODIGO').AsString := sCodigo;
    IBQMUNICIPIOS.Open;
    Result := IBQMUNICIPIOS.FieldByName('NOME').AsString;
  except
  end;

end;

procedure TForm1.SalvaClifor;
begin
  try
    Form1.IbqClifor.ParamByName('CGC').AsString      := ConverteCpfCgc(Trim(sCNPJDest));
    Form1.IbqClifor.ParamByName('NOME').AsString     := sNomeDaEmpresa;
    Form1.IbqClifor.ParamByName('IE').AsString       := Form1.xmlNodeValue2('//dest/IE');
    Form1.IbqClifor.ParamByName('ENDERE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML(( StringReplace(Trim(Form1.xmlNodeValue2('//dest/enderDest/xLgr')), ',', ' ', [rfReplaceAll])))+', '+Trim(Form1.xmlNodeValue2('//dest/enderDest/nro')))+Replicate(' ',40),1,40));
    Form1.IbqClifor.ParamByName('COMPLE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xBairro'))))), 1, iTamanhoCliforBairro));
    Form1.IbqClifor.ParamByName('CIDADE').AsString   := Form1.NomeMunicipio(Form1.xmlNodeValue2('//enderDest/cMun'));
    if Trim(Form1.IbqClifor.ParamByName('CIDADE').AsString) = '' then
      Form1.IbqClifor.ParamByName('CIDADE').AsString   := Trim(Copy(PrimeiraMaiuscula(CaracteresHTML((Trim(Form1.xmlNodeValue2('//dest/enderDest/xMun')))))+Replicate(' ',40),1,40));
    Form1.IbqClifor.ParamByName('ESTADO').AsString   := Form1.xmlNodeValue2('//dest/enderDest/UF');
    Form1.IbqClifor.ParamByName('CEP').AsString      := sCEP;
    if Copy(sFone, 1, 1) = '0' then                                                                                      
      sFone := Copy(sFone, 2, 14);
    if Length(sFone) < 10 then
      Form1.IbqClifor.ParamByName('FONE').AsString   := Trim(sFone)
    else
      Form1.IbqClifor.ParamByName('FONE').AsString   := '(0xx'+Copy(Trim(sFone),1,2)+')'+Copy(Trim(sFone),3,9);

    sEmailClifor := Copy(Trim(Form1.xmlNodeValue2('//enderEmit/email')), 1, iTamanhoCliforEmail);
    if sEmailClifor <> '' then
      Form1.IbqClifor.ParamByName('EMAIL').AsString  := sEmailClifor
    else
      Form1.IbqClifor.ParamByName('EMAIL').Clear;

    Form1.IbqClifor.ExecSQL;
  except
  
  end;
end;

end.







