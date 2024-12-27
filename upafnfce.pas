unit upafnfce;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  IBQuery, DBClient, Db, IniFiles, StrUtils, DateUtils
  , IBDatabase
  , IBCustomDataSet // Sandro Silva 2023-02-13
  , StdVCL
  , CAPICOM_TLB
  , spdNFCe
  ;

const PARAMETRO_PAFNFCE = 'PAFNFCE';
const NUMERO_ARQUIVO_REGISTROS_DO_PAF_NFCE = 'II';
const NUMERO_ARQUIVO_SAIDAS_IDENTIFICADAS_PELO_CPF_CNPJ = 'III';

type

  TVersaoErPafNfce = (tPafNfceEr0100, tPafNfceEr0200);

  TRequisitosPafNfceBase = class
  private
    FIBTransaction: TIBTransaction;
    FIBQEmitente: TIBQuery;
    FspdNFCe: TspdNFCe;
    FIBDataSet13: TIBDataSet;
    FIBDataSet4: TIBDataSet;
    FIBDataSet14: TIBDataSet;
    procedure SetIBTransaction(const Value: TIBTransaction);
  public
    constructor Create;
    function IdentificacaoDaEmpresaDesenvolvedora: String; virtual; abstract;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); virtual; abstract;
    procedure RequisitosDoPafNFCe(sAtualOnLine: String); virtual; abstract;
    property IBTransaction: TIBTransaction read FIBTransaction write SetIBTransaction;
    property IBQEmitente: TIBQuery read FIBQEmitente write FIBQEmitente;
    property IBDataSet4: TIBDataSet read FIBDataSet4 write FIBDataSet4;
    property IBDataSet13: TIBDataSet read FIBDataSet13 write FIBDataSet13;
    property IBDataSet14: TIBDataSet read FIBDataSet14 write FIBDataSet14;
    property spdNFCe: TspdNFCe read FspdNFCe write FspdNFCe;
  end;

  TRequisitosPafNfce0100 = class(TRequisitosPafNfceBase)
  private
  public
    function IdentificacaoDaEmpresaDesenvolvedora: String; override;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); override;
    procedure RequisitosDoPafNFCe(sAtualOnLine: String); override;      
  end;

  TRequisitosPafNfce0200 = class(TRequisitosPafNfceBase)
  private
    function GeraXmlPafNfce(sArquivo: String; nroArquivo: String): String;
    procedure ClassificaAliquotaSituacaoTributaria(var sAliquota: String;
      var sSituacaoTributaria: String);
  public
    function IdentificacaoDaEmpresaDesenvolvedora: String; override;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); override;
    procedure RequisitosDoPafNFCe(sAtualOnLine: String); override;
  end;

type
  TRequisitosPafNfce = class
  private
    FVersao: TVersaoErPafNfce;
    FRequisitos: TRequisitosPafNfceBase;
    FIBTransaction: TIBTransaction;
    FspdNFCe: TspdNFCe;
    FIBDataSet13: TIBDataSet;
    FIBDataSet4: TIBDataSet;
    FIBDataSet14: TIBDataSet;

    procedure setVersao(const Value: TVersaoErPafNfce);
  public
    constructor Create;
    destructor Destroy; override;
    property VersaoER: TVersaoErPafNfce read FVersao write setVersao;
    property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    function IdentificacaoDaEmpresaDesenvolvedora: String;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String);
    procedure RequisitosDoPafNFCe(sAtualOnLine: String);
    property spdNFCe: TspdNFCe read FspdNFCe write FspdNFCe; // Sandro Silva 2023-02-13
    property IBDataSet4: TIBDataSet read FIBDataSet4 write FIBDataSet4;
    property IBDataSet13: TIBDataSet read FIBDataSet13 write FIBDataSet13;
    property IBDataSet14: TIBDataSet read FIBDataSet14 write FIBDataSet14;
  end;

implementation

uses fiscal
  , unit7
  , ufuncoesfrente
  , SmallFunc_xe
//  , uassinaxmlpafnfce
  ;

{ TRequisitosPafNfce0100 }

function TRequisitosPafNfce0100.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result :=
    'a) Identifica��o da empresa desenvolvedora' + #13 +
    #13 +
    'CNPJ: ' + CNPJ_SOFTWARE_HOUSE_PAF + #13 +
    'Raz�o Social: ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + #13 +
    'Endere�o: Rua Get�lio Vargas, 673, Centro 89700-019 - Conc�rdia-SC' + #13 +
    'Telefone: 049 3425 5800' + #13 +
    'Contato: Alessio Mainardi' + #13 +
    #13 +
    'Identifica��o do PAF-NFC-e' + #13 +
    #13 +
    'Nome comercial do PAF-NFC-e: Small Commerce' + #13 +
    'Vers�o do PAF-NFC-e: ' + Build
end;

procedure TRequisitosPafNfce0100.RequisitosDoPafNFCe(sAtualOnLine: String);
begin
  // Implementar se precisar

  inherited;

end;

procedure TRequisitosPafNfce0100.VendasIdentificadaspeloCPFCNPJ(
  dtPeriodo: TDate; CnpjCpfCliente: String);
var
  F : TextFile;
  iZ: Integer;
  dtGeracao: TDate;
  hrGeracao: TTime;
  FileName: String;
  bGerando: Boolean;
  IBQuery: TIBQuery;
  dtIni: TDate;// Sandro Silva 2023-01-05
  dtFim: TDate;// Sandro Silva 2023-01-05
begin
  inherited;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transa��o n�o informada');
    Exit;
  end;

  bGerando := True;
    
  IBQuery     := TIBQuery.Create(nil);
  IBQuery.Transaction     := FIBTransaction;

  try

    dtGeracao := Date;
    hrGeracao := Time;

    FileName := ExtractFilePath(Application.ExeName) + 'VENDAS_IDENTIFICADAS_PELO_CPF_CNPJ.TXT';

    {Sandro Silva 2023-01-05 inicio}
    dtIni := StrToDate('01/' + FormatDateTime('mm/yyyy', dtPeriodo));
    dtFim := StrToDate(IntToStr(DaysInAMonth(YearOf(dtPeriodo), MonthOf(dtPeriodo))) + '/' + FormatDateTime('mm/yyyy', dtPeriodo));
    {Sandro Silva 2023-01-05 fim}

    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para grava��o
    try

      FIBQEmitente.close;
      FIBQEmitente.SQL.Text :=
        'select CGC, IE, IM, NOME ' +
        'from EMITENTE';
      FIBQEmitente.Open;

      IBQuery.Close;
      IBQuery.SQL.Text :=
        'select replace(replace(replace(A1.CNPJ, ''.'', ''''), ''-'', ''''), ''/'', '''') as CNPJ, sum(coalesce(A1.TOTAL, 0)) as TOTAL, min(A1.DATA) as DATAI, max(A1.DATA) as DATAF ' +
        'from ALTERACA A1 ' +
        'where coalesce(A1.CNPJ, '''') <> '''' ' +
        ' and A1.CNPJ <> ''..-'' ' +
        ' and A1.CNPJ <> ''.../-'' ' +
        ' and A1.TIPO = ''BALCAO'' ';
      if LimpaNumero(CnpjCpfCliente) <> '' then
        IBQuery.SQL.Add(' and A1.CNPJ = ' + QuotedStr(FormataCpfCgc(LimpaNumero(CnpjCpfCliente))));
      IBQuery.SQL.Add(
        ' and A1.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate('01/' + FormatDateTime('mm/yyyy', dtPeriodo)))) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(IntToStr(DaysInAMonth(YearOf(dtPeriodo), MonthOf(dtPeriodo))) + '/' + FormatDateTime('mm/yyyy', dtPeriodo)))) +
        ' group by replace(replace(replace(A1.CNPJ, ''.'', ''''), ''-'', ''''), ''/'', '''') ' +
        'order by DATAI ');
      IBQuery.Open;

      Writeln(F,  'Z1' +                                                          // Tipo Z1
                  right('00000000000000' + LimpaNumero(FIBQEmitente.FieldByName('CGC').AsString), 14) + // CNPJ
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incri��o Estadual
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incri��o Municipal
                  Copy(AnsiUpperCase(FIBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Raz�o social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                  Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instri��o Estadual da Desenvolvedora
                  Copy(IM_SOFTWARE_HOUSE_PAF + Replicate(' ', 14), 1, 14) + // Inscri��o Municipal da Desenvolvedora
                  // 2015-09-08 Copy('SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI' + Replicate(' ', 50), 1, 50) // Raz�o social da Desenvolvedora
                  Copy(AnsiUpperCase(Form1.sRazaoSocialSmallsoft) + Replicate(' ', 50), 1, 50) // Raz�o social da Desenvolvedora
                  );

      if PAFNFCe then
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(LimpaNumero(Build) + Replicate(' ', 10), 1, 10) // Vers�o do PAF-ECF
                    );
      end
      else
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy(StringReplace(NUMERO_LAUDO_PAF_ECF, 'Rn', '', [rfReplaceAll]) + Replicate(' ', 10), 1, 10) + // Laudo do PAF-ECF
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(Build + Replicate(' ', 10), 1, 10) // Vers�o do PAF-ECF
                    );
      end;
      iZ := 0;
      IBQuery.DisableControls;
      IBQuery.First;
      while IBQuery.Eof = False do
      begin
        Inc(iZ);

        Writeln(F, 'Z4' +                                                          // Tipo Z4
                   Right('00000000000000' + LimpaNumero(IBQuery.FieldByName('CNPJ').AsString), 14) + // CPF/CNPJ
                   Right('00000000000000' + LimpaNumero(FormatFloat('0.00', IBQuery.FieldByName('TOTAL').AsFloat)), 14) + // Totaliza��o Mensal
                   FormatDateTime('yyyymmdd', dtIni) + // Data inicial da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtFim) + // Data final da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da gera��o do relat�rio
                   FormatDateTime('HHnnss', hrGeracao)  // hora da gera��o do relat�rio
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                 Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instri��o Estadual da Desenvolvedora
                 RightStr(Replicate('0', 6) + IntToStr(iZ), 6)  // Total de registros Z4
                 );

    except

    end;
    CloseFile(F);                                    // Fecha o arquivo

    AssinaturaDigital(pChar(FileName));
    CHDir(Form1.sAtual);

    bGerando := False;

  finally
    IBQuery.EnableControls;

    if bGerando then // Falhou fechar e assinar arquivo
    begin
      CloseFile(F);                                    // Fecha o arquivo
      CHDir(Form1.sAtual);
    end;

    if FileExists(FileName) then
      SmallMsg('O arquivo: '+FileName+' foi gravado na pasta: '+extractFilePath(FileName));
  end;
end;

procedure TRequisitosPafNfce0200.ClassificaAliquotaSituacaoTributaria(
  var sAliquota, sSituacaoTributaria: String);
begin

  sAliquota := '';
  if AllTrim(Form1.IBDataSet4.FieldByName('ST').AsString) <> '' then // Se o ST n�o estiver em branco   //
  begin                                    // Procurar na tabela de ICM para  //
    Form1.IBDataSet14.First;                         // saber qual a aliquota associada //
    while not Form1.IBDataSet14.EOF do
    begin
      if Form1.IBDataSet14.FieldByName('ST').AsString = Form1.IBDataSet4.FieldByName('ST').AsString then  // Pode ocorrer um erro    //
      begin                                           // se o estado do emitente //
        try                                             // N�o estiver cadastrado  //
          if Form1.IBDataSet14.FieldByName('ISS').AsFloat > 0 then
          begin
            sAliquota := StrZero(Form1.IBDataSet14.FieldByName('ISS').AsFloat * 100,4,0);
            sSituacaoTributaria := 'S';
          end else
          begin
            sAliquota := StrZero( (Form1.IBDataSet14.FieldByName(Form1.IBDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100) ,4,0);
            sSituacaoTributaria := 'T';
          end;
        except
          sAliquota  := '' end;
      end;
      Form1.IBDataSet14.Next;
    end;
  end else sSituacaoTributaria := 'T';

  if Form1.IBDataSet4.FieldByName('TIPO_ITEM').AsString = '09' then // 09-Servi�o
    sSituacaoTributaria := 'S';

  //
  if sAliquota = '' then // Se o sAliquota continuar em branco � porque n�o estava cadastrado //
  begin            // na tabela de ICM ou estava em branco                        //
    Form1.IBDataSet14.First;
    while not Form1.IBDataSet14.EOF do  // Procura pela opera��o padr�o venda � vista ou //
    begin                     // venda a prazo 512 ou 612 ou 5102 ou 6102      //
      if (AllTrim(Form1.IBDataSet14.FieldByName('CFOP').AsString) = '5102') or (AllTrim(Form1.IBDataSet14.FieldByName('CFOP').AsString) = '6102') then
      begin
        try
          sAliquota := StrZero( (Form1.IBDataSet14.FieldByName(Form1.IBDataSet13.FieldByName('ESTADO').AsString+'_').AsFloat * 100),4,0);
        except
          sAliquota  := ''
        end;
      end;
      Form1.IBDataSet14.Next;
    end;
  end;

  if Form1.IBDataSet4.FieldByname('ALIQUOTA_NFCE').AsString <> '' then // Sandro Silva 2019-03-12 if Form1.IBDataSet4.FieldByname('ALIQUOTA_NFCE').AsFloat > 0.00 then
  begin
    sAliquota := LimpaNumero(FormatFloat('00.00', Form1.IBDataSet4.FieldByName('ALIQUOTA_NFCE').AsFloat));

    if Form1.IBDataSet4.FieldByName('TIPO_ITEM').AsString = '09' then // 09-Servi�o
      sSituacaoTributaria := 'S'
    else
      sSituacaoTributaria := 'T';
  end
  else
  begin
    //
    if Copy(allTrim(Form1.IBDataSet4.FieldByName('ST').AsString),1,1) = 'I' then sSituacaoTributaria := 'I' else
      if Copy(allTrim(Form1.IBDataSet4.FieldByName('ST').AsString),1,1) = 'F' then sSituacaoTributaria := 'F' else
        if Copy(allTrim(Form1.IBDataSet4.FieldByName('ST').AsString),1,1) = 'N' then sSituacaoTributaria := 'N';
  end;

  //if (LimpaNumero(Form1.IBDataSet13.FieldByname('CRT').AsString) = '1') then Mauricio Parizotto 2024-08-15
  if (LimpaNumero(Form1.IBDataSet13.FieldByname('CRT').AsString) = '1')
    or (LimpaNumero(Form1.IBDataSet13.FieldByname('CRT').AsString) = '4') then
  begin // N�O � SIMPLES NACIONAL
    if Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString) <> '' then // Se existir CSOSN para NFC-e usa a configura��o
    begin
      if (RightStr(Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString), 3) = '102') or (RightStr(Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '103') or (RightStr(Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '300') then
        sSituacaoTributaria := 'I';
      if RightStr(Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '400' then
        sSituacaoTributaria := 'N';
      if RightStr(Trim(Form1.IBDataSet4.FieldByname('CSOSN_NFCE').AsString), 3)  = '500' then
        sSituacaoTributaria := 'F';
    end;
  end
  else
  begin
    if Length(LimpaNumero(Form1.IBDataSet4.FieldByname('CST_NFCE').AsString)) > 1 then
    begin
      if (RightStr('000' + Form1.IBDataSet4.FieldByname('CST_NFCE').AsString, 2) = '60') then
        sSituacaoTributaria := 'F';
      if RightStr('000' + Form1.IBDataSet4.FieldByname('CST_NFCE').AsString, 2) = '40' then
        sSituacaoTributaria := 'I';
      if RightStr('000' + Form1.IBDataSet4.FieldByname('CST_NFCE').AsString, 2) = '41' then
        sSituacaoTributaria := 'N';
    end;
  end;

  if (sSituacaoTributaria = 'I') or (sSituacaoTributaria = 'F') or (sSituacaoTributaria = 'N') then
    sAliquota := '0000';

end;

function TRequisitosPafNfce0200.GeraXmlPafNfce(sArquivo,
  nroArquivo: String): String;
begin

  FspdNFCe.GerarXMLMenuFiscal(nroArquivo, 'Banco de dados interno', 'PAF-NFC-e Interno', sArquivo, True, ChangeFileExt(sarquivo, '.XML'));

  if FileExists(ChangeFileExt(sarquivo, '.XML')) then
    SmallMsg('O arquivo: ' + ChangeFileExt(sarquivo, '.XML') + ' foi gravado na pasta: ' + ExtractFilePath(ChangeFileExt(sarquivo, '.XML')));

end;

function TRequisitosPafNfce0200.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result :=
    'a) Identifica��o da empresa desenvolvedora' + #13 +
    #13 +
    '1. CNPJ: ' + CNPJ_SOFTWARE_HOUSE_PAF + #13 +
    '2. Raz�o Social: ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + #13 +
    '3. Endere�o: Rua Get�lio Vargas, 673, Centro 89700-019 - Conc�rdia-SC' + #13 +
    '4. Telefone: 049 3425 5800' + #13 +
    '5. Contato: Alessio Mainardi' + #13 +
    #13 +
    'b) Identifica��o do PAF-NFC-e' + #13 +
    #13 +
    '1. Nome comercial do PAF-NFC-e: Small Commerce' + #13 +
    '2. Vers�o do PAF-NFC-e: ' + Build
    + #13 +
    #13 +
    'c) a informa��o relativa � arquitetura de implanta��o do sistema de gest�o,' + #13 +
    #13 +
    'c.2) Dados integralmente armazenados no estabelecimento,' + #13 +
    'em equipamento diverso do especificado em �c.1�: �Banco de dados interno�'  + #13 +
    #13 +
    'd) a informa��o relativa � arquitetura de implanta��o do PAF-NFC-e ' + #13 +
    #13 +
    'd.2) programa integralmente executado no estabelecimento,' + #13 +
    'em equipamento diverso do especificado em �d.1�: �PAF-NFC-e Interno�'

end;

procedure TRequisitosPafNfce0200.RequisitosDoPafNFCe(sAtualOnLine: String);
const SELECT_ECF =
  'select distinct R1.SERIE ' +
  ',(select first 1 R3.PDV from REDUCOES R3 where R3.SERIE = R1.SERIE and coalesce(R3.PDV, ''XX'') <> ''XX'' order by R3.REGISTRO desc) as PDV ' +
  ',(select first 1 R4.MODELOECF from REDUCOES R4 where R4.SERIE = R1.SERIE order by R4.REGISTRO desc) as MODELOECF ' +
  'from REDUCOES R1 ' +
  ' where R1.SMALL <> ''59'' and R1.SMALL <> ''65'' and R1.SMALL <> ''99'' ' +
  ' and coalesce(R1.SERIE, ''XX'') <> ''XX'' ' +
  ' and coalesce(R1.PDV, ''XX'') <> ''XX'' ' +
  ' group by R1.SERIE ' +
  'order by PDV';

  type
    TJ1 = record
      Tipo: String; // "J1"
      CNPJEmissor: String; // CNPJ do emissor do Documento Fiscal
      DataEmissao: TDate; // Data de emiss�o do documento fiscal
      SubTotal: Currency; // Valor total do documento, com duas casas decimais.
      DescontoSubTotal: Currency; // Valor do desconto ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
      IndicadorTipoDesconto: String; // Informar �V� para valor monet�rio ou �P� para percentual
      AcrescimoSubTotal: Currency; // Valor do acr�scimo ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
      IndicadorTipoAcrescimo: String; // Informar �V� para valor monet�rio ou �P� para percentual
      ValorTotalLiquido: Currency; // Valor total do Cupom Fiscal ap�s desconto/acr�scimo, com duas casas decimais.
      TipoDeEmissao: String; // Tipo de emiss�o do documento (<tpEmis>)
      CPFCNPJAdquirente: String; // CPF ou CNPJ do adquirente
      NumeroNF: String; // N�mero da Nota Fiscal, manual ou eletr�nica
      SerieNF: String; // S�rie da Nota Fiscal, manual ou eletr�nica
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletr�nica
      Evidencia: String; // Controlar se est� evidenciado
    end;

    TJ2 = record
      Tipo: String; // J2
      CNPJEmissor: String; // CNPJ do emissor do Documento Fiscal
      DataEmissao: TDate; // Data de emiss�o do documento fiscal
      NumeroItem: String; // N�mero do item registrado no documento
      CodigoProduto: String; // C�digo do produto ou servi�o registrado no documento.
      Descricao: String; // Descri��o do produto ou servi�o constante no Cupom Fiscal
      Quantidade: Double; // Quantidade comercializada, sem a separa��o das casas decimais
      Unidade: String; // Unidade de medida
      ValorUnitario: Currency; // Valor unit�rio do produto ou servi�o, sem a separa��o das casas decimais.
      DescontoItem: Currency; // Valor do desconto incidente sobre o valor do item, com duas casas decimais.
      AcrescimoItem: Currency; // Valor do acr�scimo incidente sobre o valor do item, com duas casas decimais.
      ValorTotalLiquido: Currency; // Valor total l�quido do item, com duas casas decimais.
      TotalizadorParcial: String; // C�digo do totalizador relativo ao produto ou servi�o conforme tabela abaixo.
      CasasDecimaisQuantidade: String; // Par�metro de n�mero de casas decimais da quantidade
      CasasDecimaisValorUnitario: String; // Par�metro de n�mero de casas decimais de valor unit�rio
      NumeroNF: String; // N�mero da Nota Fiscal, manual ou eletr�nica
      SerieNF: String; // S�rie da Nota Fiscal, manual ou eletr�nica
      ChaveAcesso: String; // Chave de Acesso da Nota Fiscal Eletr�nica
      Evidencia: String; // Controlar se est� evidenciado
    end;

    TA2 = record
      Data: TDate;
      CodigoForma: String;
      Forma: String;
      TipoDocumento: String;
      Valor: Double;
      CPFCNPJClienteTipo3: String;
      DocumentoTipo3: String;
      Evidencia: String;
    end;

var
  //
  Mais1Ini : TIniFile;
  NumRead, I : Integer;
  sTexto: String;
  Buf: array[1..524288] of Char;
  //
  sMensuracao, sUnd : String;
  F : TextFile;
  FNovo : file;
  sCodigo : String;
  sDataUltimaZ, sModelo_ECF, sSituacaoTributaria, sAliquota, sEvidenciaA2, sEvidenciaReducoes, sEvidencia, sEvidenciaDeExclusao : String;
  rDesconto, rAcrescimo : Real;
  dDescontoItem: Double; // 2015-09-19
  dItemCancelado: Double; // 2015-11-05
  sDescricaoItem: String; // 2015-09-19
  sTabela, sCancel : String;
  fQTD_CANCEL, fVAL_CANCEL : Real;
  sPDV, sStituacao : String;
  sDATASB: String;
  sAliqISSQN: String;
  IBQECF: TIBQuery;
  IBQALIQUOTASR05: TIBQuery;

  IBQVENDAS: TIBQuery;
  IBQCOMPRAS: TIBQuery;
  IBQFABRICA: TIBQuery;
  IBQBALCAO: TIBQuery;
  IBQRESERVA: TIBQuery;
  IBQR04: TIBQuery;

  sECFSerie: String;
  sDataPrimeiro: String;
  sHoraPrimeiro: String;
  sTipoDocumentoPAF: String;
  sEvidenciaP2: String;
  sEvidenciaR01: String;
  sEcfEvidenciado: String;
  sEvidenciaS2: String;
  sEvidenciaS2Ecf: String;
  sEvidenciaS3: String;
  dEstorno: Double;
  dEstornoCancelado: Double;
  sTipoAcrescimo: String;
  sTipoDesconto: String;
  sDescontoOuAcrescimo: String;
  bGerarRegistro: Boolean;
  dtImpressao: TDate;
  dtMicro: TDate;

  sChaveAcessoDocumento: String;
  sNumeroNF: String;
  sSerieNF: String;
  aJ1: array of TJ1;
  iJ1: Integer;
  bJ1: Boolean;
  iJ1Posicao: Integer;

  aJ2: array of TJ2;
  iJ2: Integer;
  bJ2: Boolean;
  iJ2Posicao: Integer;

  aA2: array of TA2;
  iA2: Integer;
  bA2: Boolean;
  iA2Posicao: Integer;

  dVenda: Double;
  dCompra: Double;
  dAltera: Double;
  dBalcao: Double;
  dRese: Double;
  dQtd: Double;
  sQtd: String;

  slArq: TStringList;
  sArqEstoqueAtual: String;

  sDataEmissaoRZR2: String;
  sHoraEmissaoRZR2: String;

  dA2Cancelado: Double;
  dA2CupomImporta: Double;
  dA2Reclassifica: Double;
  dA2Total: Double;
  dA2Descontar: Double;

  dD2Desconto: Double;
  dD2Total: Double;

  iD3Item: Integer;
  sD3Codigo: String;

  dS2Total: Double;
  sR05CasasQtd: String;
  dR04SubTotal: Currency;
  sS2Conta: String;
  sJ2Quantidade: String;
  sA2Forma: String;
  sMarcaE3: String;
  sModeloEcfE3: String;
  sNumeroSerieEcfE3: String;
  sTipoECFE3: String;
  sMarcaR01: String;
  sTipoECFR01: String;
  sModeloECFR01: String;
  sSequencialR01: String;
  sCRZR01: String;
  sMarcaE3Evidenciado: String;
  sModeloE3Evidenciado: String;
  sEmitenteEvidenciado: String;
  sCRZEvidenciadoR02: String;
  //CDSPRIMEIRAIMPRESSAO: TClientDataSet;
  sDadosItemE2: String;
  sHashItemE2: String;
  sA2FiltroCaixa: String;
  sMedidaD3: String;
  IBQuery5: TIBQuery;
  FileName: String;
  //

  function LimpaNomeForma(sForma: String): String;
  begin
    sForma := ConverteAcentos(Copy(sForma, 4, 25));
    Result := sForma;
    if AnsiContainsText(sForma, 'Dinheiro') then
      Result := 'Dinheiro';
    if AnsiContainsText(sForma, 'Prazo') then
      Result := 'Prazo';
    if AnsiContainsText(sForma, 'Cartao') and AnsiContainsText(sForma, 'Credito') then
      Result := 'Cartao Credito';
    if AnsiContainsText(sForma, 'Cartao') and AnsiContainsText(sForma, 'Debito') then
      Result := 'Cartao Debito';
  end;

  {
  procedure AdicionaImpressao(sSerieEcf: String; dtDataImpressao: TDate;
    sHoraImpressao: String);
  begin
    if sSerieEcf <> '' then
    begin
      CDSPRIMEIRAIMPRESSAO.Append;
      CDSPRIMEIRAIMPRESSAO.FieldByName('SERIEECF').AsString := sSerieEcf;
      CDSPRIMEIRAIMPRESSAO.FieldByName('DATA').AsDateTime   := dtDataImpressao;
      CDSPRIMEIRAIMPRESSAO.FieldByName('HORA').AsString     := sHoraImpressao;
      CDSPRIMEIRAIMPRESSAO.FieldByName('DATAHORA').AsString := FormatDateTime('dd/mm/yyyy', dtDataImpressao)+ ' ' + sHoraImpressao;
      CDSPRIMEIRAIMPRESSAO.Post;
    end;
  end;
  }

  procedure CarregaEstoqueDoDia(sData: String);
  // sData deve ser passado no formato dd/mm/yyyy
  var
    iEstoqueDia: Integer;
    I: Integer;
  begin
    ListaDeArquivos(slArq, pchar(Form1.sAtualOnLine + '\estoquedia\'), '*.dia');

    sArqEstoqueAtual := '';

    slArq.Sort;
    if slArq.Count > 0 then
    begin
      sData := FormatDateTime('yyyymmdd', StrToDate(sData));
      for iEstoqueDia := 0 to slArq.Count -1 do
      begin
        if slArq.Count > 1 then
        begin
          if AnsiUpperCase(ExtractFileName(slArq.Strings[iEstoqueDia])) = AnsiUpperCase(sData + '.dia') then
          begin
            sArqEstoqueAtual := ExtractFileName(slArq.Strings[iEstoqueDia]);
            Break;
          end;
        end
        else
          sArqEstoqueAtual := ExtractFileName(slArq.Strings[slArq.Count - 1]);
      end;
    end;

    if sArqEstoqueAtual <> '' then
    begin
      if FileExists(sAtualOnLine + '\estoquedia\' + sArqEstoqueAtual) then
      begin
        //
        AssignFile(FNovo, sAtualOnLine + '\estoquedia\' + sArqEstoqueAtual);
        Reset(FNovo, 1);
        sTexto := '';
        //
        for I := 1 to (Filesize(FNovo) div 524288) + 1 do
        begin
          BlockRead(FNovo, Buf, 524288, NumRead);
          sTexto := sTexto + Copy(Buf,1, NumRead);
        end;
        //
        CloseFile(FNovo);       // Fecha o arquivo
        //
      end;
    end;

  end;
begin
  inherited; 

  IBQECF          := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQVENDAS       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQCOMPRAS      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQFABRICA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQBALCAO       := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQRESERVA      := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQALIQUOTASR05 := CriaIBQuery(Form1.IBQuery5.Transaction);
  IBQR04          := CriaIBQuery(Form1.IBQuery5.Transaction);

  IBQR04.BufferChunks := 100;

  IBQuery5 := CriaIBQuery(FIBTransaction);

  try
    IBQuery5.Close;                         // saber qual a aliquota associada //
    IBQuery5.SQL.Text :=
      'select * from ICM where coalesce(ISS, 0) <> 0';
    IBQuery5.Open;
    //
    sAliqISSQN := '';
    while IBQuery5.Eof = False do
    begin
      if IBQuery5.FieldByName('ISS').AsFloat <> 0 then
      begin
        sAliqISSQN := Alltrim(StrZero(IBQuery5.FieldByName('ISS').AsFloat*100,4,0));
        Break;
      end;
      IBQuery5.Next;
    end;

    FileName := Form1.sPAstaDoExecutavel+'\REGISTROS_DO_PAF_NFC_e_' + FormatDateTime('yyyy-mm-dd-HH-nn-ss', Now) + '.TXT';

    //
    //
    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para grava��o
    //
    // Evid�ncia de exclusao de registros
    //
    // c) A exclus�o/inclus�o de dados no banco de dados dos arquivos eletr�nicos dever� ser evidenciada mediante a substitui��o de brancos pelo caractere �?� no campo:
    // c.1) �Raz�o Social� no caso do registro D1 constante no Anexo III;
    // c.2) �Raz�o Social� no caso do registro E1 constante no Anexo IV;
    // c.3) �Raz�o Social� no caso do registro P1 constante no Anexo V;
    // c.5) �Raz�o Social� no caso do registro C1 constante no Anexo IX;
    // c.4) �Denomina��o da empresa desenvolvedora� no caso do registro R01 constante no Anexo VI;
    // d) Para os registros evidenciados � vedada a elimina��o destas evid�ncias por menus ou rotinas autom�ticas do sistema.
    //
    sEvidenciaDeExclusao := '';
    //
    { ATIVAR quando houver homologa��o
    //if not HASHs('DEMAIS',False) then sEvidenciaDeExclusao := '?';
    //if not HASHs('REDUCOES',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('PAGAMENT',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ALTERACA',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('ESTOQUE',False)  then sEvidenciaDeExclusao := '?';
    if not HASHs('ORCAMENT',False) then sEvidenciaDeExclusao := '?';
    if not HASHs('NFCE',False)  then sEvidenciaDeExclusao    := '?';
    // Sandro Silva 2017-10-30 if not HASHs('VENDAS',False) then sEvidenciaDeExclusao := '?'; // Sandro Silva 2017-10-30
    // Sandro Silva 2017-10-30 if not HASHs('ITENS001',False)  then sEvidenciaDeExclusao := '?'; // Sandro Silva 2017-10-30
    //
    }
    if sEvidenciaDeExclusao = '?' then
    begin
      sEvidenciaDeExclusao := StrTran(Copy(Form1.ibDataSet13.FieldByName('NOME').AsString + replicate(' ', 50), 1, 50), ' ', '?');

      //if not HASHs('DEMAIS',False) then LogFrente('Teste 01: Evid�ncia Demais');
      //if not HASHs('REDUCOES',False) then LogFrente('Teste 01: Evid�ncia Reducoes');
      if not HASHs('PAGAMENT',False) then LogFrente('Teste 01: Evid�ncia Pagament');
      if not HASHs('ALTERACA',False) then LogFrente('Teste 01: Evid�ncia Alteraca');
      if not HASHs('ESTOQUE',False)  then LogFrente('Teste 01: Evid�ncia Estoque');
      if not HASHs('ORCAMENT',False) then LogFrente('Teste 01: Evid�ncia Orcament');
      if not HASHs('NFCE',False)     then LogFrente('Teste 01: Evid�ncia NFCE');


    end else
    begin
      sEvidenciaDeExclusao := Copy(Form1.ibDataSet13.FieldByName('NOME').AsString+replicate(' ', 50), 1, 50);
    end;

    {
    sEmitenteEvidenciado := '';
    if not AssinaRegistro('EMITENTE',Form1.ibDataSet13, False) then
      sEmitenteEvidenciado := '?';
    }
    //
    //
    Writeln(F, 'U1' +
               Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
               Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) +
               Copy(LimpaNumero(Form1.ibDataSet13.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) +
               sEvidenciaDeExclusao);
    //
    // A2
    //
    //Display('Aguarde...', 'Aguarde... Gerando arquivo �Registros do PAF-NFC-e� - A2');

    sA2FiltroCaixa := '';
    if Form1.bData = False then // Est� gerando na RZ
      sA2FiltroCaixa := ' and P.CAIXA = ' + QuotedStr(Form1.sCaixa) + ' ';

    IBQuery5.Close;
    IBQuery5.SQL.Text :=
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from PAGAMENT P ' +
      'join NFCE on NFCE.NUMERONF = P.PEDIDO and NFCE.CAIXA = P.CAIXA ' +
      'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      sA2FiltroCaixa +
      ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
      ' and P.FORMA not containing ''NF-e'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
      ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
      ' and P.REGISTRO is not null ' +
      ' union ' +
      'select distinct P.PEDIDO, P.CAIXA, P.DATA ' +
      'from PAGAMENT P ' +
      'where P.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
      ' and P.CAIXA is null ' +
      ' order by 2, 1 ';
    IBQuery5.Open;

    //
    while not IBQuery5.Eof do
    begin
      //
      // Tipo = 1   Cupom fiscal
      //
      // N�o agrupar para identificar evid�ncias
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSql.Text :=
        'select P.REGISTRO, P.PEDIDO, P.DATA, P.FORMA, P.VALOR, ''1'' as TIPODOCUMENTO ' +
        'from PAGAMENT P ' +
        'where P.PEDIDO = ' + QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString) +
        ' and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
        ' and P.FORMA not containing ''NF-e'' ' +
        ' and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
        ' and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
        ' and P.CAIXA = ' + QuotedStr(IBQuery5.FieldByName('CAIXA').AsString) + // dos cupons fiscais s� do caixa
        ' order by P.FORMA';
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      Form1.fTotal := 0;
      //
      //Acumula os valores das formas de pagamento e identifica se est� evidenciado
      while not Form1.ibDataSet99.Eof do
      begin

        Form1.ibDataSet27.Close;
        Form1.ibDataSet27.SelectSQL.Text :=
          'select * ' +
          'from ALTERACA ' +
          'where PEDIDO = ' + QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString) +
          ' and CAIXA = ' + QuotedStr(IBQuery5.FieldByName('CAIXA').AsString) + // dos cupons fiscais s� do caixa
          ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ' +
          ' and DESCRICAO <> ''Desconto'' ' +
          ' and DESCRICAO <> ''Acr�scimo'' ';
        Form1.ibDataSet27.Open;

        // Apenas de cupons n�o cancelados
        if (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (Form1.ibDataSet27.FieldByName('TIPO').AsString = 'LOKED') then
        begin

          bA2 := False;
          iA2Posicao := -1; 
          for iA2 := 0 to Length(aA2) - 1 do
          begin
            if (aA2[iA2].Data = Form1.ibDataSet99.FieldByName('DATA').AsDateTime)
              and (aA2[iA2].Forma = LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString))
              and (aA2[iA2].TipoDocumento = Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString) then
            begin
              bA2 := True;
              iA2Posicao := iA2;
            end;
          end;

          if bA2 = False then
          begin
            SetLength(aA2, Length(aA2) + 1);
            iA2Posicao := High(aA2);

            aA2[iA2Posicao].Data          := Form1.ibDataSet99.FieldByName('DATA').AsDateTime;
            aA2[iA2Posicao].TipoDocumento := Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString; // NF emitida Manualmente
            aA2[iA2Posicao].Forma         := LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString);
            aA2[iA2Posicao].CodigoForma   := Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 1, 2);
          end;
          aA2[iA2Posicao].Valor := aA2[iA2Posicao].Valor + Form1.ibDataSet99.FieldByName('VALOR').AsFloat;

          Form1.ibDataSet28.Close;
          Form1.ibDataSet28.SelectSQL.Text :=
            'select * ' +
            'from PAGAMENT ' +
            'where REGISTRO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('REGISTRO').AsString);
          Form1.ibDataSet28.Open;

          if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
            aA2[iA2Posicao].Evidencia := '?';

        end;

        Form1.ibDataSet99.Next;
        //
      end;
      //
      // Tipo = 3 Nota NF-e
      //
      // N�o agrupar para identificar evid�ncias
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSQL.Clear;
      Form1.ibDataSet99.SelectSql.Text :=
        'select P.REGISTRO, P.CLIFOR, P.PEDIDO, P.DATA, P.FORMA, P.VALOR, ''2'' as TIPODOCUMENTO ' +
        'from PAGAMENT P ' +
        'where P.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQuery5.FieldByName('DATA').AsDateTime)) +
        ' and P.PEDIDO = ' + QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString) +
        'and P.FORMA <> ''13 Troco'' and P.FORMA <> ''00 Total'' ' +
        'and P.FORMA containing ''NF-e'' ' +
        //'and P.FORMA containing ''NFC-e'' ' +
        'and coalesce(P.CLIFOR, ''X'') <> ''Sangria'' ' +
        'and coalesce(P.CLIFOR, ''X'') <> ''Suprimento'' ' +
        'and (coalesce(P.CAIXA, '''') = ''''  and coalesce(P.COO, '''') = '''')' +
        ' order by P.FORMA';
      Form1.ibDataSet99.Open;
      Form1.ibDataSet99.First;
      //
      Form1.fTotal := 0;
      //
      while not Form1.ibDataSet99.Eof do
      begin
        dA2Descontar := 0.00;

        // Localiza NF-e emitidas que podem duplicar o valor em PAGAMENT
        // Desconta cancelamentos, importa��o cupons, reclassifica��o
        // NF-e cancelada
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''cancelada'') ' +
          //' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.EMISSAO = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQuery5.FieldByName('DATA').AsDateTime)) +
          ' and COMPLEMENTO containing ''MD-5'' ' +
          ' and COMPLEMENTO containing ''' + PARAMETRO_PAFNFCE + ''' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2Cancelado := 0.00;
        while IBQECF.Eof = False do
        begin
          dA2Cancelado := dA2Cancelado + IBQECF.FieldByName('TOTAL').AsFloat;
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Cancelado));

        // Cupons Importados
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.XPED starting ''CF'' ' +  // Ex.: CF007502CX006
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          //' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.EMISSAO = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', IBQuery5.FieldByName('DATA').AsDateTime)) +
          ' and VENDAS.COMPLEMENTO containing ''MD-5'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2CupomImporta := 0.00;
        while IBQECF.Eof = False do
        begin
          dA2CupomImporta := dA2CupomImporta + IBQECF.FieldByName('TOTAL').AsFloat;
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2CupomImporta));

        // NF-e CFOP 5926 Reclassifica��o de estoque
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS001 on ITENS001.NUMERONF = VENDAS.NUMERONF and ITENS001.CFOP starting ''5926'' ' +
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          ' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.COMPLEMENTO containing ''MD-5'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;
        dA2Reclassifica := 0.00;
        while IBQECF.Eof = False do
        begin
          //ShowMessage('Teste 01 5926 ' + IBQECF.FieldByName('NUMERONF').AsString + ' ' + IBQECF.FieldByName('TOTAL').AsString);

          dA2Reclassifica := dA2Reclassifica + IBQECF.FieldByName('TOTAL').AsFloat;

          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Reclassifica));

        // NF-e Entrada CFOP 1926 Reclassifica��o de estoque
        IBQECF.Close;
        IBQECF.SQL.Text :=
          'select VENDAS.* ' +
          'from VENDAS ' +
          'join ITENS002 on ITENS002.NUMERONF = VENDAS.NUMERONF and VENDAS.CLIENTE = ITENS002.FORNECEDOR and ITENS002.CFOP starting ''1926'' ' +  
          'where VENDAS.MODELO = ''55'' ' +
          ' and coalesce(VENDAS.NFEID, '''') <> '''' ' +
          ' and (VENDAS.STATUS containing ''Autoriza'') ' +
          ' and VENDAS.EMISSAO between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and VENDAS.COMPLEMENTO containing ''ENTRADA'' ' +
          ' and VENDAS.CLIENTE = ' + QuotedStr(Form1.ibDataSet99.FieldByName('CLIFOR').AsString) +
          ' and right(substring(VENDAS.NUMERONF from 1 for 9), 6) = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' order by VENDAS.NUMERONF';
        IBQECF.Open;

        dA2Reclassifica := 0.00;
        while IBQECF.Eof = False do
        begin
          IBQCOMPRAS.Close;
          IBQCOMPRAS.SQL.Text :=
            'select * ' +
            'from COMPRAS ' +
            'where NUMERONF = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
            ' and FORNECEDOR = ' + QuotedStr(IBQECF.FieldByName('CLIENTE').AsString);
          IBQCOMPRAS.Open;

          //ShowMessage('Teste 01 1926 ' + IBQECF.FieldByName('NUMERONF').AsString + ' ' + IBQCOMPRAS.FieldByName('TOTAL').AsString);

          dA2Reclassifica := dA2Reclassifica + IBQCOMPRAS.FieldByName('TOTAL').AsFloat; 
          IBQECF.Next;
        end;
        dA2Descontar := dA2Descontar + StrToFloat(FormatFloat('0.00', dA2Reclassifica));

        bA2 := False;
        iA2Posicao := -1;
        for iA2 := 0 to Length(aA2) - 1 do
        begin
          if (aA2[iA2].Data = Form1.ibDataSet99.FieldByName('DATA').AsDateTime)
            and (aA2[iA2].Forma = LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString))
            and (aA2[iA2].TipoDocumento = Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString) then
          begin
            bA2 := True;
            iA2Posicao := iA2;
          end;
        end;

        if bA2 = False then
        begin
          SetLength(aA2, Length(aA2) + 1);
          iA2Posicao := High(aA2);

          aA2[iA2Posicao].Data          := Form1.ibDataSet99.FieldByName('DATA').AsDateTime;
          aA2[iA2Posicao].TipoDocumento := Form1.ibDataSet99.FieldByName('TIPODOCUMENTO').AsString; // NF emitida Manualmente
          aA2[iA2Posicao].Forma         := LimpaNomeForma(Form1.ibDataSet99.FieldByName('FORMA').AsString);
          aA2[iA2Posicao].CodigoForma   := Copy(Form1.ibDataSet99.FieldByName('FORMA').AsString, 1, 2);
        end;
        aA2[iA2Posicao].Valor := aA2[iA2Posicao].Valor + Form1.ibDataSet99.FieldByName('VALOR').AsFloat - dA2Descontar;

        if aA2[iA2Posicao].Valor < 0 then
          aA2[iA2Posicao].Valor := 0.00;

        Form1.ibDataSet28.Close;
        Form1.ibDataSet28.SelectSQL.Text :=
          'select * ' +
          'from PAGAMENT ' +
          'where REGISTRO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('REGISTRO').AsString);
        Form1.ibDataSet28.Open;

        if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
          aA2[iA2Posicao].Evidencia := '?';

        Form1.ibDataSet99.Next;
        //
      end;

      //
      IBQuery5.Next;
      //
    end;

    for iA2Posicao := 0 to Length(aA2) - 1 do
    begin
      if aA2[iA2Posicao].Valor > 0 then
      begin
        //
        { ATIVAR quando houver homologa��o
        // Valida se o registro evidenciado n�o entrou na soma da forma de pagamento
        Form1.ibDataSet28.Close;
        Form1.ibDataSet28.SelectSQL.Text :=
          'select * ' +
          'from PAGAMENT ' +
          'where DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', aA2[iA2Posicao].Data)) +
          ' and substring(FORMA from 1 for 2) = ' + QuotedStr(aA2[iA2Posicao].CodigoForma);
        Form1.ibDataSet28.Open;

        while Form1.ibDataSet28.Eof = False do
        begin
          if AssinaRegistro('PAGAMENT', Form1.ibDataSet28, False) = False then
            aA2[iA2Posicao].Evidencia := '?';
          Form1.ibDataSet28.Next;
        end;
        }

        sEvidenciaA2 := Copy(aA2[iA2Posicao].Forma + DupeString(' ', 25), 1, 25);
        if aA2[iA2Posicao].Evidencia = '?' then
          sEvidenciaA2 := StringReplace(sEvidenciaA2, ' ', '?', [rfReplaceAll]);
        Writeln(F, 'A2'
                      + FormatDateTime('yyyymmdd', aA2[iA2Posicao].Data)
                      + sEvidenciaA2
                      + aA2[iA2Posicao].TipoDocumento
                      + StrZero(aA2[iA2Posicao].Valor*100,12,0)
                      + Copy(aA2[iA2posicao].CPFCNPJClienteTipo3 + Replicate(' ', 14), 1, 14)
                      + Copy(aA2[iA2posicao].DocumentoTipo3 + Replicate(' ', 10), 1, 10)
                      );
      end;

    end; // for iA2Posicao := 0 to Length(aA2) - 1 do

    ///////////////// FIM A2 ////////////////////////
    /////////////////////////////////////////////////

    //

    Form1.ibDAtaSet4.Close;
    Form1.ibDAtaSet4.SelectSQL.Clear;
    Form1.ibDAtaSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
    Form1.ibDAtaSet4.Open;
    //
    Form1.ibDAtaSet4.First;
    while not Form1.ibDAtaSet4.EOF do
    begin
      //
      if not (Form1.ibDataSet4.FieldByName('ATIVO').AsString='1') then
      begin
        //
        ClassificaAliquotaSituacaoTributaria(sAliquota, sSituacaoTributaria);
        //
        sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('CODIGO').AsString, 14);
        if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
        begin
          sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
        end;
        //
        sUnd := Copy(Form1.ibDAtaSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);

        { ATIVAR quando houver homologa��o
        if not AssinaRegistro('ESTOQUE',Form1.ibDAtaSet4, False) then
        begin
          //LogFrente('P2 ' + sCodigo + ' ESTOQUE EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
          //LogFrente('31449 P2 ' + sCodigo + ' ESTOQUE EVIDENCIADO');
          sUnd := StrTran(sUnd,' ','?');
          sEvidenciaP2 := '?'; // Sandro Silva 2016-03-08 POLIMIG
        end;
        if Pos(sEmitenteEvidenciado, '?') > 0 then
        begin
          //LogFrente('P2 ' + sCodigo + ' EMITENTE EVIDENCIADO'); // Sandro Silva 2018-05-09 TESTE 01
          sUnd := StrTran(sUnd,' ','?');
        end;
        }
        //
        //
        Writeln(F, 'P2' +
                Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)
                + sCodigo
                + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7)
                + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)
                + Copy(Form1.ibDAtaSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)
                + sUnd
                + RightStr('T' + AllTrim(Form1.ibDAtaSet4.FieldByName('IAT').AsString), 1)
                + RightStr('T' + AllTrim(Form1.ibDAtaSet4.FieldByName('IPPT').AsString), 1)
                + RightStr('T' + sSituacaoTributaria, 1) 
                + sAliquota
                + StrZero(Form1.ibDAtaSet4.FieldByName('PRECO').AsFloat*100,12,0));
      end;
      //
      Form1.ibDAtaSet4.Next;
      //
    end;



    ///////////////////////////////////////////////

    //Display('Aguarde...', 'Aguarde... Gerando arquivo �Registros do PAF-NFC-e� - E2');

    //
    Form1.ibDAtaSet4.Close;
    Form1.ibDAtaSet4.SelectSQL.Clear;
    Form1.ibDAtaSet4.SelectSQL.Add('select * from ESTOQUE where coalesce(ATIVO,0)=0 order by CODIGO ');
    Form1.ibDAtaSet4.Open;
    //
    Form1.ibDAtaSet4.First;
    while not Form1.ibDAtaSet4.EOF do
    begin
      //
      if Form1.ibDataSet4.FieldByName('ST').AsString <> '005' then
      begin
        if not (Form1.ibDataSet4.FieldByName('ATIVO').AsString='1') then
        begin
          //
          if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.ibDAtaSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
          begin
            //
            //
            if Form1.ibDAtaSet4.FieldByName('QTD_ATUAL').AsFloat >= 0 then
              sMensuracao := '+'
            else
              sMensuracao := '-';
            //
            sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('CODIGO').AsString, 14);
            if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
            begin
              sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
            end;

            //
            sUnd := copy(Form1.ibDAtaSet4.FieldByName('MEDIDA').AsString + '      ', 1, 6);
            //sQtd := Copy(sTexto,Pos('['+sCodigo,sTexto+']')+16,10);  // Quantidade com sinal +/-
            sQtd := RightStr(StrTran(Strzero(Form1.ibDAtaSet4.FieldByName('QTD_ATUAL').AsFloat*1000,9,0),'-','0'), 9);

            if not AssinaRegistro('ESTOQUE',Form1.ibDAtaSet4, False) then
            begin
              sUnd := StrTran(sUnd,' ','?');
            end;

            //
            if Trim(Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString) <> '' then
            begin
              sCodigo := Right('00000000000000' + Form1.ibDAtaSet4.FieldByName('REFERENCIA').AsString, 14);
            end;

            Writeln(F, 'E2' +
                    Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14)     //CNPJ estabelecimento
                    + sCodigo                                                                                    //C�digo da mercadoria/servi�o
                    + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CEST').AsString) + Replicate(' ', 7), 1, 7) //CEST
                    + Copy(LimpaNumero(Form1.ibDAtaSet4.FieldByName('CF').AsString) + Replicate(' ', 8), 1, 8)   //NCM/SH
                    + Copy(Form1.ibDAtaSet4.FieldByName('DESCRICAO').AsString + Replicate(' ', 50), 1, 50)       //Descri��o mercadoria
                    + sUnd                                                                                       //Unidade de medida
                    + sMensuracao                                                                                //Mensura��o
                    + sQtd                                                                                       //Quantidade em estoque no momento da gera��o
                    + FormatDateTime('yyyymmdd', Date)                                                           //Data de emiss�o, que o arquivo foi solicitado
                    + FormatDateTime('yyyymmdd', Date)                                                           //Data da posi��o do estoque
                    );
          end; // if (Alltrim(Form1.sSuperCodigo) = '') or (Pos(Form1.ibDAtaSet4.FieldByName('CODIGO').AsString,Form1.sSuperCodigo)<> 0) then
        end; // if not (ibDataSet4ATIVO.AsString='1') then
      end; // if ibDataSet4ST.AsString <> '005' then
      //
      Form1.ibDAtaSet4.Next;
      //
    end; // while not Form1.ibDAtaSet4.EOF do


    /////////////////////////////////////// D2 e D3 INICIO

    //
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSQL.Clear;
    Form1.ibDataSet99.SelectSQL.Add('select PEDIDO, CAIXA, DATA, NUMERONF, COO, sum(TOTAL) as TOTAL, CLIFOR from ORCAMENT where DESCRICAO<>'+QuotedStr('Desconto')+' and DATA>='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker1.Date ))+ ' and DATA<='+QuotedStr( DateToStrInvertida(Form7.DateTimePicker2.Date ))+' and (TIPO = ''ORCAME'') group by PEDIDO, CAIXA, DATA, NUMERONF, COO, CLIFOR order by PEDIDO');
    Form1.ibDataSet99.Open;
    Form1.ibDataSet99.First;
    //
    Form1.ibDataSet37.DisableControls;
    //
    while not Form1.ibDataSet99.EOF do
    begin
      //

      Form1.ibDataSet37.Close;
      Form1.ibDataSet37.SelectSQL.Clear;
      Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where DESCRICAO = ''Desconto'' and PEDIDO='+QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString)+' ');
      Form1.ibDataSet37.Open;

      dD2Desconto := Form1.ibDataSet37.FieldByName('TOTAL').AsFloat;

      sEvidencia := ' ';
      { ATIVAR quando houver homologa��o
      Form1.ibDataSet37.Close;
      Form1.ibDataSet37.SelectSQL.Clear;
      Form1.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where PEDIDO='+QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString)+' ');
      Form1.ibDataSet37.Open;
      // Sandro Silva 2020-11-06  Form1.ibDataSet37.DisableControls;
      //
      sEvidencia := ' ';
      //
      while not Form1.ibDataSet37.Eof do
      begin
        if not AssinaRegistro('ORCAMENT', Form1.ibDataSet37, False) then
          sEvidencia := '?';
        Form1.ibDataSet37.Next;
      end;
      }
      //
      //
      // Sandro Silva 2020-12-14  if Alltrim(Form1.ibDataSet99.FieldByName('CAIXA').AsString) <> '' then
      begin
        Form1.ibDataSet2.Close;
        Form1.ibDataSet2.SelectSQL.Text :=
          'select * ' +// Sandro Silva 2018-02-08  'select CGC, NOME ' +
          'from CLIFOR ' +
          'where NOME = ' + QuotedStr(Trim(Form1.ibDataSet99.FieldByName('CLIFOR').AsString)) +
          ' and coalesce(CGC, '''') <> '''' ';
        Form1.ibDataSet2.Open;

        dD2Total := Form1.ibDataSet99.FieldByName('TOTAL').AsFloat - dD2Desconto;
        if dD2Total < 0 then
          dD2Total := 0;

        Writeln(F, 'D2' +
                   Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ estabelecimento
                   Right('0000000000000' + Form1.ibDataSet99.FieldByName('PEDIDO').AsString, 13) + // N�mero do DAV
                   FormatDateTime('YYYYMMDD', Form1.ibDataSet99.FieldByName('DATA').AsDateTime) + // Data do DAV
                   Copy('ORCAMENTO'+Replicate(' ',30),1,30) + // T�tulo
                   StrZero(dD2Total*100,8,0)+  // Valor total do DAV // Sandro Silva 2021-01-12 StrZero(Form1.ibDataSet99.FieldByName('TOTAL').AsFloat*100,8,0)+  // Valor total do DAV
                   Copy(Form1.ibDataSet99.FieldByName('CLIFOR').AsString + Replicate(' ',40), 1, 40)+ // Nome do cliente
                   Right('00000000000000' + LimpaNumero(Form1.ibDataSet2.FieldByName('CGC').AsString), 14) // CPF ou CNPJ do adquirente
                   );
      end;
      //
      Form1.ibDataSet99.Next;
      //
    end;
    //

    Form1.ibDataSet99.First;

    while not Form1.ibDataSet99.EOF do
    begin
      //
      //
      // Sandro Silva 2020-12-14  if Alltrim(Form1.ibDataSet99.FieldByName('CAIXA').AsString) <> '' then
      begin
        //
        // Desconto no total
        //
        //
        Form1.ibDataSet999.Close;
        Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
        Form1.ibDataSet999.SelectSql.Clear;
        Form1.ibDataSet999.SelectSQL.Text :=
          'select sum(TOTAL) as DESCONTO ' +
          'from ORCAMENT ' +
          'where PEDIDO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' and DESCRICAO = ''Desconto'' ' +
          ' and (TIPO = ''ORCAME'') ';
        Form1.ibDataSet999.Open;
        //
        //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
        //
        rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat;

        dD2Total := Form1.ibDataSet99.FieldByName('TOTAL').AsFloat - dD2Desconto;

        Form1.ibDataSet37.Close;
        Form1.ibDataSet37.SelectSQL.Clear;
        Form1.ibDataSet37.SelectSQL.Text :=
          'select * ' +
          'from ORCAMENT ' +
          'where PEDIDO = ' + QuotedStr(Form1.ibDataSet99.FieldByName('PEDIDO').AsString) +
          ' and coalesce(CODIGO, '''') <> '''' ' +
          ' and (TIPO = ''ORCAME'') ' +
          ' order by REGISTRO';
        Form1.ibDataSet37.Open;

        //
        iD3Item := 0; // Sandro Silva 2021-01-12
        while not Form1.ibDataSet37.Eof do
        begin
          sEvidencia := ' ';
          { ATIVAR quando houver homologa��o
          if not AssinaRegistro('ORCAMENT', Form1.ibDataSet37, False) then
            sEvidencia := '?';
          }
          //
          // Sandro Silva 2021-01-13  dDescontoItem := StrToFloat(FormatFloat('0.00', (Form1.ibDataSet37.FieldByName('UNITARIO').AsFloat / Form1.ibDataSet99.FieldByName('TOTAL').AsFloat) * Form1.ibDataSet37.FieldByName('TOTAL').AsFloat));
          dDescontoItem := StrToFloat(FormatFloat('0.00', (Form1.ibDataSet37.FieldByName('TOTAL').AsFloat / Form1.ibDataSet99.FieldByName('TOTAL').AsFloat) * rDesconto));

          sD3Codigo := Form1.ibDataSet37.FieldByName('CODIGO').AsString;

          Form1.ibDataSet4.Close;
          Form1.ibDataSet4.SelectSQL.Text :=
            'select * ' +
            'from ESTOQUE ' +
            'where CODIGO = ' + QuotedStr(Form1.ibDataSet37.FieldByName('CODIGO').AsString);
          Form1.ibDataSet4.Open;

          if Form1.ibDataSet4.FieldByName('REFERENCIA').AsString <> '' then
            sD3Codigo := Form1.ibDataSet4.FieldByName('REFERENCIA').AsString;

          { ATIVAR quando houver homologa��o
          if not AssinaRegistro('ESTOQUE', Form1.ibDataSet4, False) then
            sEvidencia := '?';
          }

          sMedidaD3 := Form1.ibDataSet37.FieldByName('MEDIDA').AsString;
          if Trim(sMedidaD3) = '' then
            sMedidaD3 := Form1.ibDataSet4.FieldByName('MEDIDA').AsString;
          ClassificaAliquotaSituacaoTributaria(sAliquota, sSituacaoTributaria);

          sDescricaoItem := Form1.ibDataSet37.FieldByName('DESCRICAO').AsString + DupeString(' ',100);
          { ATIVAR quando houver homologa��o
          if sEvidencia = '?' then
            sDescricaoItem := StringReplace(sDescricaoItem, ' ', '?', [rfReplaceAll]);
          }

          if Form1.ibDataSet37.FieldByName('DESCRICAO').AsString <> 'Descricao' then
            Inc(iD3Item);

          Writeln(F, 'D3' +
                     Right('0000000000000' + Form1.ibDataSet99.FieldByName('PEDIDO').AsString, 13) + // N�mero do DAV
                     FormatDateTime('YYYYMMDD', Form1.ibDataSet37.FieldByName('DATA').AsDateTime) + // Data do DAV
                     Right('000' + FormatFloat('000', iD3Item), 3) + // Numero do item 3 // Sandro Silva 2021-01-12 Right('000' + Form1.ibDataSet37.FieldByName('ITEM').AsString, 3) + // Numero do item 3
                     Right('00000000000000' + sD3Codigo, 14) + // Codigo do produto 14 // Sandro Silva 2021-01-12 Right('00000000000000' + Form1.ibDataSet37.FieldByName('CODIGO').AsString, 14) + // Codigo do produto 14
                     Copy(sDescricaoItem, 1, 100) + // Descricao 100
                     StrZero(Form1.ibDataSet37.FieldByName('QUANTIDADE').AsFloat*1000,7,0)+ // Quantidade 7
                     Copy(sMedidaD3+'   ',1,3)+ // Unidade 3
                     StrZero(Form1.ibDataSet37.FieldByName('UNITARIO').AsFloat*100,14,0)+ // valor unitario 14
                     sSituacaoTributaria + // Situacao tributaria 1
                     sAliquota + // Aliquita 4
                     'N' + // Indicador de cancelamento 1
                     '3'+ // Casas decimais da quantidade
                     '2' // Casas decimais de valor unit�rio
                     //StrZero(dDescontoItem*100,8,0)+ // Desconto sobre o item 8
                     //StrZero(0.00,8,0)+ // Acrescimo sobre o item 8
                     //StrZero((Form1.ibDataSet37.FieldByName('TOTAL').AsFloat - dDescontoItem) *100,14,0)+ //  Valor total liquido 14
                     //sSituacaoTributaria + // Situacao tributaria 1
                     //sAliquota + // Aliquita 4
                     //'N' + // Indicador de cancelamento 1
                     //'3'+ // Casas decimais da quantidade
                     //'2' // Casas decimais de valor unit�rio
                     );
          Form1.ibDataSet37.Next;
        end; // if Form1.ibDataSet37.EOF = False do

      end;
      //
      Form1.ibDataSet99.Next;
      //
    end;

    Form1.ibDataSet37.EnableControls; // Sandro Silva 2020-11-06

    /////////////////////////////////////// D2 e D3 FIM

    if (Pos('DAV',Form1.sConcomitante) = 0) then
    begin

      // Mesas abertas S2 e S3
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select PEDIDO, min(DATA) as DATA ' +
        'from ALTERACA ' +
        'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
        'group by PEDIDO ' +
        'order by PEDIDO';
      IBQECF.Open;

      while IBQECF.Eof = False do
      begin

        //N�o encontrei limite para listar mesas abertas if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////
          // S2
          /////////////////////

          //Display('Aguarde...', 'Aguarde... Gerando arquivo �Registros do PAF-NFC-e� - S2');

          // Seleciona as mesas com data de lan�amento no per�odo selecionado

          IBQuery5.Close;
          IBQuery5.SQL.Clear;
          IBQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL)as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA, max(coalesce(COO,'''')) as COO ' +
            'from ALTERACA ' +
            'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
            //  Deve ser criado um registro tipo S2 para cada mesa ou conta de cliente que se encontre aberta quando da gera��o do arquivo.
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('PEDIDO').AsString) + // Sandro Silva 2019-09-17 ER 02.06 UnoChapeco Lista os totais da mesa selecionada
            ' and DESCRICAO <> ''<CANCELADO>'' ' +
            'group by PEDIDO ' +
            'order by IDATAHORA ';
          IBQuery5.Open;
          //
          while not IBQuery5.Eof do
          begin
            //
            sEvidenciaS2Ecf := '';
            if AllTrim(IBQuery5.FieldByName('COO').AsString) <> '' then
            begin
              sStituacao := Right('000000000' + IBQuery5.FieldByName('COO').AsString, 9);
            end else
            begin
              sStituacao := Replicate(' ', 9); // Na ER o campo COO � alfanum�rico
            end;

            sEvidenciaS2 := '';
            { ATIVAR quando houver homologa��o
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString) +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
            Form1.ibDataSet27.Open;

            sEvidenciaS2 := '';
            while Form1.ibDataSet27.Eof = False do
            begin
              if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) or (sEvidenciaS2Ecf = '?') then
              begin
                sEvidenciaS2 := '??????????';
              end;
              Form1.ibDataSet27.Next;
            end;
            }

            dS2Total := 0.00;
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Text :=
             'select * ' +
             'from ALTERACA ' +
             'where PEDIDO = ' + QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString) +
             ' and coalesce(VENDEDOR, '''') <> ''<cancelado>'' ' +
             ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
            Form1.ibDataSet27.Open;

            while Form1.ibDataSet27.Eof = False do
            begin
              dS2Total := dS2Total + Form1.ibDataSet27.FieldByName('TOTAL').AsFloat;
              Form1.ibDataSet27.Next;
            end;

            sS2Conta := Copy(RightStr(IBQuery5.FieldByName('PEDIDO').AsString, 3) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);  // N�mero da mesa/Conta cliente
            if Copy(Form1.sConcomitante,1,2) = 'OS' then
              sS2Conta := Copy(Right(IBQuery5.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS2 + Replicate(' ', 10), 1, 13);   // Conta cliente OS

            if Pos(sEmitenteEvidenciado, '?') > 0 then
            begin
              sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]);  // Conta cliente OS
            end;

            Writeln(F,  'S2' +                                                          // Tipo S2
                        Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                        FormatDateTime('yyyymmdd', IBQuery5.FieldByName('IDATAHORA').AsDateTime) + // DD
                        FormatDateTime('HHnnss', IBQuery5.FieldByName('IDATAHORA').AsDateTime) + // HORA
                        sS2Conta +
                        StrZero(dS2Total * 100, 13, 0) +
                        sStituacao);
                        //
            IBQuery5.Next;
          end;

        end; // if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date)))

        IBQECF.Next;
      end;

      //Volta para a primeira mesa para lista os itens
      IBQECF.First;
      while IBQECF.Eof = False do
      begin

        //N�o encontrei limite para listar mesas abertas if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date))) then
        begin

          /////////////////////////
          // S3
          /////////////////////////
          //Display('Aguarde...', 'Aguarde... Gerando arquivo �Registros do PAF-NFC-e� - S3');

          IBQuery5.Close;
          IBQuery5.SQL.Clear;
          // somente no caso de Mesa ou Conta de Cliente com situa��o �aberta�, mesmo que ele tenha sido marcado para cancelamento.
          IBQuery5.SQL.Text :=
            'select PEDIDO, max(SEQUENCIALCONTACLIENTEOS) as SEQUENCIALCONTACLIENTEOS, sum(TOTAL) as VTOT, min(cast(DATA||'' ''||HORA as timestamp)) as IDATAHORA ' +
            'from ALTERACA ' +
            'where (TIPO = ''MESA'' or TIPO = ''DEKOL'') ' +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('PEDIDO').AsString) +
            ' and DESCRICAO<>''<CANCELADO>'' ' +
            'group by PEDIDO order by IDATAHORA ';
          IBQuery5.Open;
          //

          while not IBQuery5.Eof do
          begin
            //
            Form1.ibQuery6.Close;
            Form1.ibQuery6.SQL.Clear;
            Form1.ibQuery6.SQL.Add('select * from ALTERACA where PEDIDO='+QuotedStr(IBQuery5.FieldByName('PEDIDO').AsString)+' and DESCRICAO<>''<CANCELADO>'' and (TIPO = ''MESA'' or TIPO = ''DEKOL'' ) order by REGISTRO');
            Form1.ibQuery6.Open;
            //
            while not Form1.ibQuery6.Eof do
            begin
              sEvidenciaS3 := '';
              { ATIVAR quando houver homologa��o
              Form1.ibDataSet27.Close;
              Form1.ibDataSet27.SelectSQL.Text :=
               'select * ' +
               'from ALTERACA ' +
               'where PEDIDO = ' + QuotedStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString) +
               ' and ITEM = ' + QuotedStr(Form1.ibQuery6.FieldByName('ITEM').AsString) +
               ' and (TIPO = ''MESA'' or TIPO = ''DEKOL'') ';
              Form1.ibDataSet27.Open;

              sEvidenciaS3 := '';
              while Form1.ibDataSet27.Eof = False do
              begin
                if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
                begin
                  sEvidenciaS3 := '??????????';
                end;
                Form1.ibDataSet27.Next;
              end;
              }

              sCodigo := Form1.ibQuery6.FieldByName('CODIGO').AsString;
              if Trim(Form1.ibQuery6.FieldByName('REFERENCIA').AsString) <> '' then
              begin
                sCodigo := Right('00000000000000' + Form1.ibQuery6.FieldByName('REFERENCIA').AsString, 14);
              end;

              sS2Conta := Copy(RightStr(Form1.ibQuery6.FieldByName('PEDIDO').AsString, 3)+ sEvidenciaS3 + Replicate(' ', 10), 1, 13);  // N�mero da mesa/Conta cliente
              if Copy(Form1.sConcomitante,1,2) = 'OS' then
                sS2Conta := Copy(Right(Form1.ibQuery6.FieldByName('SEQUENCIALCONTACLIENTEOS').AsString, 10) + sEvidenciaS3 + Replicate(' ', 10), 1, 13);   // Conta cliente OS

              if Pos(sEmitenteEvidenciado, '?') > 0 then
              begin
                sS2Conta := StringReplace(sS2Conta, ' ', '?', [rfReplaceAll]); // Conta cliente OS
              end;

              Writeln(F,  'S3' +                                                          // Tipo S3
                          right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) +
                          FormatDateTime('yyyymmdd', IBQuery5.FieldByName('IDATAHORA').AsDateTime) + // Data de abertura
                          FormatDateTime('HHnnss', IBQuery5.FieldByName('IDATAHORA').AsDateTime)+ // Hora de abertura
                          sS2Conta +  // N�mero da Mesa/Conta de Cliente
                          Right('000000000'+sCodigo, 14)+ // C�digo do produto ou servi�o
                          Copy(Form1.ibQuery6.FieldByName('DESCRICAO').AsString+Replicate(' ',100),1,100)+ // Descri��o
                          StrZero(Form1.ibQuery6.FieldByName('QUANTIDADE').AsFloat*1000,7,0)+ // Quantidade
                          Copy(Form1.ibQuery6.FieldByName('MEDIDA').AsString+'   ',1,3)+ // Unidade de medida
                          StrZero(Form1.ibQuery6.FieldByName('UNITARIO').AsFloat*100,8,0)+ // Valor unit�rio
                          '3'+ // Casas decimais da quantidade
                          '2' // Casas decimais de valor unit�rio
                          );

              Form1.ibQuery6.Next;
            end;
            //
            IBQuery5.Next;
            //
          end;

        end; // if (IBQECF.FieldByName('DATA').AsDateTime >= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker1.Date))) and (IBQECF.FieldByName('DATA').AsDateTime <= StrToDate(FormatDateTime('dd/mm/yyyy', Form7.DateTimePicker2.Date)))

        IBQECF.Next;

      end; // mesas aberta

    end; // if (Copy(Form1.sConcomitante, 1, 2) <> 'OS') then

    //**********************
    //
    // J1 IN�CIO
    //

    try
      //
      //J1 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no per�odo
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, NFEXML, NFEID, NUMERONF ' +
        'from NFCE ' +
        'where MODELO = ''65'' ' +
        ' and ((coalesce(NFEID, '''') <> '''') or (coalesce(NFEXML, '''') containing ''Id="'') ) '  + // Sandro Silva 2021-01-15  ' and coalesce(NFEID, '''') <> '''' '  +
        ' and DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
        ' and (coalesce(NFEXML, '''') containing ''<tpAmb>1</tpAmb>'' or (coalesce(NFEXML, '''') containing ''<CNPJ>07426598000124</CNPJ>'' and coalesce(NFEXML, '''') containing ''<tpAmb>2</tpAmb>'')) ' + // Somente em produ��o ou emitente seja Smallsoft
        // Sandro Silva 2021-01-12  ' and (status containing ''Autorizad'' or status containing ''Cancelad'') ' +
        ' order by PDV, NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      //sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //

        //J1 Referente as NF-e: 65
        //ALTERACA.VALORICM = N�mero+Serie NF-e e ALTERACA.SERIE = ''
        Form1.IbDataSet100.Close;
        Form1.IbDataSet100.SelectSql.Clear;
        Form1.IbDataSet100.SelectSQL.Text :=
          'select sum(A1.TOTAL) as SUBTOTAL, A1.DATA, A1.PEDIDO, A1.VALORICM, A1.SERIE, A1.SUBSERIE, A1.CCF, max(coalesce(A1.CLIFOR, '''')) as CLIFOR, max(coalesce(A1.CNPJ, '''')) as CNPJ ' +
          'from ALTERACA A1 ' +
          'where (A1.TIPO = ''BALCAO'' or A1.TIPO = ''CANCEL'') ' +
          //' and coalesce(A1.SERIE, '''') = '''' and coalesce(A1.VALORICM, '''') <> '''' ' + // NF-e que foi registrada em cupom fiscal
          ' and A1.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
          ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
          ' and A1.PEDIDO = ' + QuotedStr(Trim(IBQECF.FieldByName('NUMERONF').AsString)) +
          ' and A1.DESCRICAO <> ''Desconto'' ' +
          ' and A1.DESCRICAO <> ''Acr�scimo'' ' +
          ' and coalesce(CODIGO, '''') <> '''' ' +  // 2015-11-05 N�o listar os descontos dos itens cancelados
          ' group by A1.DATA, A1.PEDIDO, A1.VALORICM, A1.SERIE, A1.SUBSERIE, A1.CCF ' +
          'order by DATA';
        Form1.IbDataSet100.Open;
        Form1.IbDataSet100.First;
        //
        // SmallMsg('Teste '+Form1.IbDataSet100.SelectSQL.Text);
        //
        while not Form1.IbDataSet100.Eof do
        begin

          try
            // Itens cancelados no cupom
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as CANCELADOS ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              //' and coalesce(SERIE, '''') = '''' and VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
              ' and DESCRICAO = ''<CANCELADO>'' ' +
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
            Form1.ibDataSet999.Open;

            dItemCancelado := Form1.ibDataSet999.FieldByName('CANCELADOS').AsFloat;

            //
            // Desconto no total do cupom
            //
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as DESCONTO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and DESCRICAO = ''Desconto'' ' +
              ' and coalesce(ITEM, '''') = '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet999.Open;
            //
            //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
            //
            rDesconto := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

            //
            // Desconto nos itens
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as DESCONTO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and (DESCRICAO = ''Desconto'' or (DESCRICAO = ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' + // 2015-11-06 Listar os descontos do cupom, mesmo quando cancelado o item ou o todo o cupom
              ' and coalesce(ITEM, '''') <> '''' ' + // Desconto no total do cupom
              ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet999.Open;

            dDescontoItem := Form1.ibDataSet999.FieldByName('DESCONTO').AsFloat * -1;

            //
            // Acr�scimo
            //
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
              'select sum(TOTAL) as ACRESCIMO ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and DESCRICAO = ' + QuotedStr('Acr�scimo') +
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet999.Open;
            //
            rAcrescimo := Form1.ibDataSet999.FieldByName('ACRESCIMO').AsFloat;
            //
            sEvidencia := ' ';
            { ATIVAR quando houver homologa��o
            Form1.ibDataSet27.Close;
            Form1.ibDataSet27.SelectSQL.Clear;
            Form1.ibDataSet27.SelectSQL.Text :=
              'select * ' +
              'from ALTERACA ' +
              'where PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
              ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ' +
              // Sandro Silva 2020-12-10  ' and TIPO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('TIPO').AsString);// Sandro Silva 2017-08-09 Separar NF manual
              ' and (TIPO = ''BALCAO'' or TIPO = ''LOKED'') ';
            Form1.ibDataSet27.Open;
            Form1.ibDataSet27.DisableControls;
            //
            sEvidencia := ' ';
            //
            Form1.ibDataSet27.First;
            while not Form1.ibDataSet27.Eof do
            begin
              if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
              begin
                //          SmallMsg('Registro: '+Form1.Form1.ibDataSet27.FieldByName('REGISTRO').AsString);
                sEvidencia := '?';
              end;
              Form1.ibDataSet27.Next;
            end;
            }

            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
            'select first 1 TIPO ' +
            'from ALTERACA A1 ' +
            'where A1.TIPO = ''BALCAO'' ' +
            //' and coalesce(A1.SERIE, '''') = '''' and A1.VALORICM = ' + IntToStr(Form1.IbDataSet100.FieldByName('VALORICM').AsInteger) + // NF-e que foi registrada em cupom fiscal
            ' and A1.DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.IbDataSet100.FieldByName('DATA').AsDateTime)) +
            ' and A1.CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and A1.PEDIDO = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
            ' and A1.DESCRICAO <> ''Desconto'' ' +
            ' and A1.DESCRICAO <> ''Acr�scimo'' ';
            Form1.ibDataSet999.Open;

            if Alltrim(Form1.ibDataSet999.FieldByName('TIPO').AsString) = 'BALCAO' then
              sCancel := 'N'
            else
              sCancel := 'S';

            sDescontoOuAcrescimo := ' ';
            sTipoAcrescimo       := ' ';
            if rAcrescimo > 0 then
            begin
              sTipoAcrescimo       := 'V';
              sDescontoOuAcrescimo := 'A';
            end;

            sTipoDesconto := ' ';
            if rDesconto > 0 then
            begin
              sTipoDesconto        := 'V';
              sDescontoOuAcrescimo := 'D';
            end;

            //
            if Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat = 0 then
              sCancel := 'S';
            //

            // Seleciona NFEID
            Form1.ibDataSet999.Close;
            Form1.ibDataSet999.SelectSql.Clear;
            Form1.ibDataSet999.SelectSQL.Text :=
            'select first 1 * ' +
            'from NFCE ' +
            'where NUMERONF = ' + QuotedStr(Form1.IbDataSet100.FieldByName('PEDIDO').AsString) +
            ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and MODELO = ''65'' ';
            Form1.ibDataSet999.Open;

            { ATIVAR quando houver homologa��o
            if not AssinaRegistro('NFCE',Form1.ibDataSet999, False) then
            begin
              //          SmallMsg('Registro: '+Form1.Form1.ibDataSet27.FieldByName('REGISTRO').AsString);
              sEvidencia := '?';
            end;
            }

            if IBQECF.FieldByName('NFEID').AsString <> '' then 
            begin
              sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
            end
            else
            begin
              sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//chNFe')) + DupeString(' ', 44), 1, 44);
              if Trim(sChaveAcessoDocumento) = '' then
                sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//infNFe/@Id')) + DupeString(' ', 44), 1, 44);
            end;
            sNumeroNF             := Copy(sChaveAcessoDocumento, 26, 9);
            sSerieNF              := Copy(sChaveAcessoDocumento, 23, 3);
            if Trim(sSerieNF) <> '' then
              sSerieNF := Copy(IntToStr(StrToInt(sSerieNF)) + '   ', 1, 3)
            else
              sSerieNF := '   ';

            bJ1 := False;
            iJ1Posicao := -1;
            for iJ1 := 0 to Length(aJ1) - 1 do
            begin
              if (aJ1[iJ1].NumeroNF = sNumeroNF)
                and (aJ1[iJ1].SerieNF = sSerieNF)
              then
              begin
                bJ1 := True;
                iJ1Posicao := iJ1;
              end;
            end;

            if bJ1 = False then
            begin
              SetLength(aJ1, Length(aJ1) + 1);
              iJ1Posicao := High(aJ1);

              aJ1[iJ1Posicao].Tipo                          := 'J1';
              aJ1[iJ1Posicao].CNPJEmissor                   := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
              aJ1[iJ1Posicao].DataEmissao                   := Form1.IbDataSet100.FieldByName('DATA').AsDateTime;
              aJ1[iJ1Posicao].DescontoSubTotal              := rDesconto;
              aJ1[iJ1Posicao].IndicadorTipoDesconto         := 'V';
              aJ1[iJ1Posicao].AcrescimoSubTotal             := rAcrescimo;
              aJ1[iJ1Posicao].IndicadorTipoAcrescimo        := 'V';
              aJ1[iJ1Posicao].CPFCNPJAdquirente             := LimpaNumero(Form1.IbDataSet100.FieldByName('CNPJ').AsString);
              aJ1[iJ1Posicao].NumeroNF                      := sNumeroNF;
              aJ1[iJ1Posicao].SerieNF                       := sSerieNF;
              aJ1[iJ1Posicao].ChaveAcesso                   := sChaveAcessoDocumento;
              aJ1[iJ1Posicao].TipoDeEmissao                 := Copy(sChaveAcessoDocumento, 35, 1);
            end;
            aJ1[iJ1Posicao].SubTotal          := aJ1[iJ1Posicao].SubTotal + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - dDescontoItem - dItemCancelado);
            aJ1[iJ1Posicao].ValorTotalLiquido := aJ1[iJ1Posicao].ValorTotalLiquido + (Form1.IbDataSet100.FieldByName('SUBTOTAL').AsFloat - rDesconto + rAcrescimo - dDescontoItem - dItemCancelado);
            aJ1[iJ1Posicao].Evidencia         := sEvidencia;

            if aJ1[iJ1Posicao].Evidencia = '?' then
              aJ1[iJ1Posicao].SerieNF := StringReplace(aJ1[iJ1Posicao].SerieNF, ' ', '?',[rfReplaceAll]);

          except
            SmallMsg('Erro ao criar registro J1 NFC-e');
          end;

          Form1.IbDataSet100.Next;
        end;
        //
        //sPDV := IBQECF.FieldByName('PDV').AsString;
        //
        //
        IBQECF.Next;
        //
      end;

      // Salvando J1 no arquivo
      for iJ1 := 0 to Length(aJ1) - 1 do
      begin
        try
          Writeln(F, 'J1' + // Tipo
                     Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                     FormatDateTime('yyyymmdd', aJ1[iJ1].DataEmissao) +           // Data de emiss�o do documento fiscal
                     StrZero(((aJ1[iJ1].SubTotal) * 100), 14, 0) +                // Valor total do documento, com duas casas decimais.
                     StrZero(((aJ1[iJ1].DescontoSubTotal) * 100), 13, 0) +        // Valor do desconto ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                     aJ1[iJ1].IndicadorTipoDesconto +                             // Informar �V� para valor monet�rio ou �P� para percentual
                     StrZero(((aJ1[iJ1].AcrescimoSubTotal) * 100), 13, 0) +       // Valor do acr�scimo ou Percentual aplicado sobre o valor do subtotal do documento, com duas casas decimais.
                     aJ1[iJ1].IndicadorTipoAcrescimo +                            // Informar �V� para valor monet�rio ou �P� para percentual
                     StrZero(((aJ1[iJ1].ValorTotalLiquido) * 100), 14, 0) +       // Valor total do Cupom Fiscal ap�s desconto/acr�scimo, com duas casas decimais.
                     aJ1[iJ1].TipoDeEmissao +                              // Tipo de emiss�o
                     Copy(aJ1[iJ1].ChaveAcesso + DupeString('0', 44), 1, 44) +    // Chave de Acesso da Nota Fiscal Eletr�nica
                     Right('0000000000' + aJ1[iJ1].NumeroNF, 10) +                // N�mero da Nota Fiscal, manual ou eletr�nica
                     aJ1[iJ1].SerieNF +                                           // S�rie da Nota Fiscal, manual ou eletr�nica
                     Right(Replicate('0',14) + aJ1[iJ1].CPFCNPJAdquirente, 14)    // CPF ou CNPJ do adquirente
                  );

        except
          SmallMsg('Erro ao criar registro J1');
        end;
      end;
    except
      SmallMsg('Erro ao criar registro J1');
    end;

    //
    // J1 FINAL
    //
    //**********************

    //**********************
    //
    // J2 IN�CIO
    //

    try
      //
      //sPDV := 'XXX';
      //

      //J2 Referente as NFC-e: 65
      // Seleciona os caixa que emitiram NFC-e no per�odo
      IBQECF.Close;
      IBQECF.SQL.Text :=
        'select distinct CAIXA as PDV, MODELO as MODELOECF, NFEID, NFEXML, NUMERONF ' +
        'from NFCE ' +
        'where (MODELO = ''65'') ' +
        ' and ((coalesce(NFEID, '''') <> '''') or (coalesce(NFEXML, '''') containing ''Id="'')) '  +
        ' and (DATA between  ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) + ') ' +
        ' and (coalesce(NFEXML, '''') containing ''<tpAmb>1</tpAmb>'' or (coalesce(NFEXML, '''') containing ''<CNPJ>07426598000124</CNPJ>'' and coalesce(NFEXML, '''') containing ''<tpAmb>2</tpAmb>'')) ' + // Somente em produ��o ou emitente seja Smallsoft
        ' and ((substring(coalesce(NFEID, '''') from 35 for 1) = ''9'') or (coalesce(NFEXML, '''') containing ''<tpEmis>9</tpEmis>'')) ' + // 9-tipo emiss�o em conting�ncia // Sandro Silva 2021-01-13 ' and substring(NFEID from 35 for 1) = ''9'' ' + // 9-tipo emiss�o em conting�ncia
        ' order by PDV, NUMERONF';
      IBQECF.Open;
      IBQECF.First;

      //
      //sPDV := 'XXX';
      //
      while not IBQECF.EOF do
      begin
        //
        begin
          //
          Form1.ibDataSet27.Close;
          Form1.ibDataSet27.SelectSql.Clear;
          Form1.ibDataSet27.SelectSQL.Text :=
            'select * ' +
            'from ALTERACA ' +
            'where DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker1.Date)) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form7.DateTimePicker2.Date)) +
            ' and CAIXA = ' + QuotedStr(Right('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) +
            ' and PEDIDO = ' + QuotedStr(IBQECF.FieldByName('NUMERONF').AsString) +
            ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
            ' and coalesce(SERIE, '''') = '''' ' +
            ' and coalesce(CODIGO, '''') <> '''' ' + // 2015-11-06 N�o exibir os cancelamentos dos descontos dos itens cancelados
            'order by DATA, CCF, ITEM';
          Form1.ibDataSet27.Open;
          Form1.ibDataSet27.First;
          //
          while not Form1.ibDataSet27.Eof do
          begin
            //
            try
              if (Alltrim(Form1.ibDataSet27.FieldByName('PEDIDO').AsString) <> '')
                and (Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> 'Desconto')
                and (Alltrim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) <> 'Acr�scimo') then
              begin
                //
                //
                if Pos('I', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                  sTabela := 'I'
                else
                  if Pos('F', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                    sTabela := 'F'
                  else
                    if Pos('N', Form1.ibDataSet27.FieldByName('ALIQUICM').AsString) > 0 then
                      sTabela := 'N'
                    else
                    begin
                      sTabela := LimpaNumero(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString);
                      if sTabela = '' then
                        sTabela := 'I'
                      else
                        sTabela := 'T' + Right('0000' + sTabela, 4);
                    end;

                if Copy(Form1.ibDataSet27.FieldByName('ALIQUICM').AsString,1,3) = 'ISS' then
                begin
                  sTabela := 'S' + sAliqISSQN;
                end;

                sTabela := Copy(sTabela + '       ', 1, 7);

                //
                sCancel := 'N';
                if (Pos('<CANCELADO>', Trim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString)) > 0) then
                begin
                  // Se o cupom foi cancelado o item deve ficar como "N"
                  // Se o item foi cancelado deve ficar como "S"
                  sCancel := 'S';
                end;

                sEvidencia := ' ';
                { ATIVAR quando houver homologa��o
                if not AssinaRegistro('ALTERACA',Form1.ibDataSet27, False) then
                  sEvidencia := '?';
                }

                // Desconto do item
                Form1.ibDataSet999.Close;
                Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                Form1.ibDataSet999.SelectSql.Clear;
                Form1.ibDataSet999.SelectSQL.Text :=
                  'select * ' +
                  'from ALTERACA ' +
                  'where PEDIDO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('PEDIDO').AsString) +
                  ' and (DESCRICAO = ''Desconto'' or (DESCRICAO containing ''<CANCELADO>'' and coalesce(CODIGO, '''') = '''')) ' +
                  ' and (TIPO = ''BALCAO'' or TIPO = ''CANCEL'') ' +
                  ' and ITEM = ' + QuotedStr(Form1.ibDataSet27.FieldByName('ITEM').AsString) + // Desconto do item
                  ' and DATA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Form1.ibDataSet27.FieldByName('DATA').AsDateTime)) +
                  ' and CAIXA = ' + QuotedStr(RightStr('000' + Trim(IBQECF.FieldByName('PDV').AsString), 3)) + ' ';
                Form1.ibDataSet999.Open;
                //
                //      SmallMsg('Teste: '+Form1.IbDataSet100.FieldByName('PEDIDO').AsString+' '+Form1.IbDataSet100.FieldByName('TIPO').AsString);
                //
                dDescontoItem := 0.00;
                if Abs(Form1.ibDataSet999.FieldByName('TOTAL').AsFloat) > 0.00 then
                  dDescontoItem := Form1.ibDataSet999.FieldByName('TOTAL').AsFloat * -1;

                { ATIVAR quando houver homologa��o
                if Form1.ibDataSet999.FieldByName('TOTAL').AsString <> '' then
                  if not AssinaRegistro('ALTERACA',Form1.ibDataSet999, False) then
                     sEvidencia := '?';
                }

                sDescricaoItem := Form1.ibDataSet27.FieldByName('DESCRICAO').AsString;

                if (Trim(Form1.ibDataSet27.FieldByName('DESCRICAO').AsString) = '<CANCELADO>') then
                begin
                  Form1.ibDataSet999.Close;
                  Form1.ibDataSet999.Transaction := Form1.IBTransaction1;
                  Form1.ibDataSet999.SelectSql.Clear;
                  Form1.ibDataSet999.SelectSQL.Text :=
                    'select DESCRICAO ' +
                    'from ESTOQUE ' +
                    'where CODIGO = ' + QuotedStr(Form1.ibDataSet27.FieldByName('CODIGO').AsString);
                  Form1.ibDataSet999.Open;
                  sDescricaoItem := Form1.ibDataSet999.FieldByName('DESCRICAO').AsString;
                end;
                //
                //
                { ATIVAR quando houver homologa��o
                if not AssinaRegistro('NFCE',IBQECF, False) then
                begin
                  sEvidencia := '?';
                end;
                }

                if IBQECF.FieldByName('NFEID').AsString <> '' then // Sandro Silva 2021-01-13
                begin
                  sChaveAcessoDocumento := Copy(IBQECF.FieldByName('NFEID').AsString + DupeString(' ', 44), 1, 44);
                end
                else
                begin
                  sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//chNFe')) + DupeString(' ', 44), 1, 44);
                  if Trim(sChaveAcessoDocumento) = '' then
                    sChaveAcessoDocumento := Copy(LimpaNumero(xmlNodeValue(IBQECF.FieldByName('NFEXML').AsString, '//infNFe/@Id')) + DupeString(' ', 44), 1, 44);
                end;
                sNumeroNF             := Copy(sChaveAcessoDocumento, 26, 9);
                sSerieNF              := Copy(sChaveAcessoDocumento, 23, 3);

                if Trim(sSerieNF) <> '' then
                  sSerieNF := Copy(IntToStr(StrToInt(sSerieNF)) + '   ', 1, 3)
                else
                  sSerieNF := '   ';

                if sEvidencia = '?' then
                  sSerieNF := StringReplace(sSerieNF, ' ', '?', [rfReplaceAll]);

                SetLength(aJ2, Length(aJ2) + 1);
                iJ2Posicao := High(aJ2);

                aJ2[iJ2Posicao].Tipo                       := 'J2';
                aJ2[iJ2Posicao].CNPJEmissor                := LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString);
                aJ2[iJ2Posicao].DataEmissao                := Form1.ibDataSet27.FieldByName('DATA').AsDateTime;
                aJ2[iJ2Posicao].NumeroItem                 := Form1.ibDataSet27.FieldByName('ITEM').AsString;
                aJ2[iJ2Posicao].CodigoProduto              := Form1.ibDataSet27.FieldByName('REFERENCIA').AsString;
                aJ2[iJ2Posicao].Descricao                  := sDescricaoItem;
                aJ2[iJ2Posicao].Quantidade                 := Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat;
                aJ2[iJ2Posicao].Unidade                    := Form1.ibDataSet27.FieldByName('MEDIDA').AsString;
                aJ2[iJ2Posicao].ValorUnitario              := Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat;
                aJ2[iJ2Posicao].DescontoItem               := dDescontoItem;
                aJ2[iJ2Posicao].AcrescimoItem              := 0.00;
                aJ2[iJ2Posicao].ValorTotalLiquido          := Form1.ibDataSet27.FieldByName('TOTAL').AsFloat - dDescontoItem;
                aJ2[iJ2Posicao].TotalizadorParcial         := sTabela;
                aJ2[iJ2Posicao].CasasDecimaisQuantidade    := '2';
                aJ2[iJ2Posicao].CasasDecimaisValorUnitario := '2';
                aJ2[iJ2Posicao].ChaveAcesso                := sChaveAcessoDocumento;
                aJ2[iJ2Posicao].NumeroNF                   := sNumeroNF;
                aJ2[iJ2Posicao].SerieNF                    := sSerieNF;
                aJ2[iJ2Posicao].Evidencia                  := sEvidencia;
              end;
            except
              SmallMsg('Erro ao criar registro J2 NFC-e');
            end;
            Form1.ibDataSet27.Next;
          end;
          //
          //
        end;
        //
        IBQECF.Next;
      end;

      // Salvando J2 no arquivo
      for iJ2 := 0 to Length(aJ2) - 1 do
      begin
        try
          sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 100), 7, 0);
          if AnsiUpperCase(aJ2[iJ2].Unidade) = 'KG' then
          begin
            sJ2Quantidade := StrZero(((aJ2[iJ2].Quantidade) * 1000), 7, 0);
            aJ2[iJ2].CasasDecimaisQuantidade    := '3';
          end;

          Writeln(F,  'J2' +                                                                                // J2
                       Right('00000000000000' + LimpaNumero(Form1.ibDataSet13.FieldByName('CGC').AsString), 14) + // CNPJ do emissor do Documento Fiscal
                       FormatDateTime('yyyymmdd', aJ2[iJ2].DataEmissao) +                                   // Data de emiss�o do documento fiscal
                       Right('000' + aJ2[iJ2].NumeroItem, 3) +                                              // N�mero do item registrado no documento
                       Right(DupeString('0', 14) + aJ2[iJ2].CodigoProduto, 14) +                            // C�digo do produto ou servi�o registrado no documento. 
                       Copy(aJ2[iJ2].Descricao + DupeString(' ', 100), 1, 100) +                            // Descri��o do produto ou servi�o constante no Cupom Fiscal
                       sJ2Quantidade + // StrZero(((aJ2[iJ2].Quantidade) * 100), 7, 0) +                                       // Quantidade comercializada, sem a separa��o das casas decimais
                       Copy(aJ2[iJ2].Unidade + Replicate(' ', 3), 1, 3) +                                   // Unidade de medida
                       StrZero(((aJ2[iJ2].ValorUnitario) * 100), 8, 0) +                                    // Valor unit�rio do produto ou servi�o, sem a separa��o das casas decimais.
                       StrZero(((aJ2[iJ2].DescontoItem) * 100), 8, 0) +                                     // Valor do desconto incidente sobre o valor do item, com duas casas decimais.
                       StrZero(((aJ2[iJ2].AcrescimoItem) * 100), 8, 0) +                                    // Valor do acr�scimo incidente sobre o valor do item, com duas casas decimais.
                       StrZero(((aJ2[iJ2].ValorTotalLiquido) * 100), 14, 0)+                                // Valor total l�quido do item, com duas casas decimais.
                       aJ2[iJ2].TotalizadorParcial +                                                        // C�digo do totalizador relativo ao produto ou servi�o conforme tabela abaixo.
                       aJ2[iJ2].CasasDecimaisQuantidade +                                                   // Par�metro de n�mero de casas decimais da quantidade
                       aJ2[iJ2].CasasDecimaisValorUnitario +                                                // Par�metro de n�mero de casas decimais de valor unit�rio
                       Right('0000000000' + aJ2[iJ2].NumeroNF, 10) +                                        // N�mero da Nota Fiscal, manual ou eletr�nica
                       Copy(aJ2[iJ2].SerieNF + '   ', 1, 3) +                                               // S�rie da Nota Fiscal, manual ou eletr�nica
                       Copy(aJ2[iJ2].ChaveAcesso + DupeString(' ', 44), 1, 44)                              // Chave de Acesso da Nota Fiscal Eletr�nica
                  );

        except
          SmallMsg('Erro ao criar registro J2');
        end;
      end;

      aJ1 := nil;
      aJ2 := nil; 

    except
      SmallMsg('Erro ao criar registro J2');
    end;

    //
    // J2 FINAL
    //
    //**********************

    aA2 := nil;

    //FreeAndNil(CDSPRIMEIRAIMPRESSAO);

    //Form1.OcultaPanelMensagem;

    CloseFile(F);                                    // Fecha o arquivo

    AssinaturaDigital(pChar(FileName));
    CHDir(Form1.sAtual);
    //

    Form1.ibDataSet88.Close;
    Form1.ibDataSet88.SelectSQL.Clear;
    Form1.ibDataSet88.SelectSQL.Add('select * from REDUCOES where SERIE='+QuotedStr(Form1.sNumeroDeSerieDaImpressora)+' order by DATA');
    Form1.ibDataSet88.Open;
    //
  finally
    Screen.Cursor             := crDefault;    // Cursor de Aguardo
    //
  end;
  FreeAndNil(IBQECF);
  FreeAndNil(IBQVENDAS);
  FreeAndNil(IBQCOMPRAS);
  FreeAndNil(IBQFABRICA);
  FreeAndNil(IBQBALCAO);
  FreeAndNil(IBQRESERVA);
  FreeAndNil(IBQALIQUOTASR05);
  FreeAndNil(IBQR04);

  FreeAndNil(IBQuery5);

  FreeAndNil(slArq);

  GeraXmlPafNfce(pChar(FileName), NUMERO_ARQUIVO_REGISTROS_DO_PAF_NFCE);

end;

procedure TRequisitosPafNfce0200.VendasIdentificadaspeloCPFCNPJ(
  dtPeriodo: TDate; CnpjCpfCliente: String);
var
  F: TextFile;
  iZ: Integer;
  dtGeracao: TDate;
  hrGeracao: TTime;
  FileName: String;
//  IBQEmitente: TIBQuery;
  IBQuery: TIBQuery;
  dtIni: TDate;// Sandro Silva 2023-01-05
  dtFim: TDate;// Sandro Silva 2023-01-05
begin
  inherited;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transa��o n�o informada');
    Exit;
  end;

  IBQuery     := TIBQuery.Create(nil);
//  IBQEmitente := TIBQuery.Create(nil);
//  IBQEmitente.Transaction := FIBTransaction;
  IBQuery.Transaction     := FIBTransaction;

  try

    dtGeracao := Date;
    hrGeracao := Time;

    {Sandro Silva 2023-01-05 inicio}
    dtIni := StrToDate('01/' + FormatDateTime('mm/yyyy', dtPeriodo));
    dtFim := StrToDate(IntToStr(DaysInAMonth(YearOf(dtPeriodo), MonthOf(dtPeriodo))) + '/' + FormatDateTime('mm/yyyy', dtPeriodo));
    {Sandro Silva 2023-01-05 fim}

    FileName := ExtractFilePath(Application.ExeName) + 'VENDAS_IDENTIFICADAS_PELO_CPF_CNPJ.TXT';

    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para grava��o
    try

      FIBQEmitente.close;
      FIBQEmitente.SQL.Text :=
        'select CGC, IE, IM, NOME ' +
        'from EMITENTE';
      FIBQEmitente.Open;

      IBQuery.Close;
      IBQuery.SQL.Text :=
        'select replace(replace(replace(A1.CNPJ, ''.'', ''''), ''-'', ''''), ''/'', '''') as CNPJ, sum(coalesce(A1.TOTAL, 0)) as TOTAL, min(A1.DATA) as DATAI, max(A1.DATA) as DATAF ' +
        'from ALTERACA A1 ' +
        'where coalesce(A1.CNPJ, '''') <> '''' ' +
        ' and A1.CNPJ <> ''..-'' ' +
        ' and A1.CNPJ <> ''.../-'' ' +
        ' and A1.TIPO = ''BALCAO'' ';
      if LimpaNumero(CnpjCpfCliente) <> '' then
        IBQuery.SQL.Add(' and A1.CNPJ = ' + QuotedStr(FormataCpfCgc(LimpaNumero(CnpjCpfCliente))));
      IBQuery.SQL.Add(
        ' and A1.DATA between ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate('01/' + FormatDateTime('mm/yyyy', dtPeriodo)))) + ' and ' + QuotedStr(FormatDateTime('yyyy-mm-dd', StrToDate(IntToStr(DaysInAMonth(YearOf(dtPeriodo), MonthOf(dtPeriodo))) + '/' + FormatDateTime('mm/yyyy', dtPeriodo)))) +
        ' group by replace(replace(replace(A1.CNPJ, ''.'', ''''), ''-'', ''''), ''/'', '''') ' +
        'order by DATAI ');
      IBQuery.Open;

      Writeln(F,  'Z1' +                                                          // Tipo Z1
                  right('00000000000000' + LimpaNumero(FIBQEmitente.FieldByName('CGC').AsString), 14) + // CNPJ
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incri��o Estadual
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incri��o Municipal
                  Copy(AnsiUpperCase(FIBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Raz�o social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                  Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instri��o Estadual da Desenvolvedora
                  Copy(IM_SOFTWARE_HOUSE_PAF + Replicate(' ', 14), 1, 14) + // Inscri��o Municipal da Desenvolvedora
                  // 2015-09-08 Copy('SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI' + Replicate(' ', 50), 1, 50) // Raz�o social da Desenvolvedora
                  Copy(AnsiUpperCase(Form1.sRazaoSocialSmallsoft) + Replicate(' ', 50), 1, 50) // Raz�o social da Desenvolvedora
                  );

      if PAFNFCe then
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(LimpaNumero(Build) + Replicate(' ', 10), 1, 10) // Vers�o do PAF-ECF
                    );
      end
      else
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy(StringReplace(NUMERO_LAUDO_PAF_ECF, 'Rn', '', [rfReplaceAll]) + Replicate(' ', 10), 1, 10) + // Laudo do PAF-ECF
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(Build + Replicate(' ', 10), 1, 10) // Vers�o do PAF-ECF
                    );
      end;
      iZ := 0;
      IBQuery.DisableControls;
      IBQuery.First;
      while IBQuery.Eof = False do
      begin
        Inc(iZ);

        Writeln(F, 'Z4' +                                                          // Tipo Z4
                   Right('00000000000000' + LimpaNumero(IBQuery.FieldByName('CNPJ').AsString), 14) + // CPF/CNPJ
                   Right('00000000000000' + LimpaNumero(FormatFloat('0.00', IBQuery.FieldByName('TOTAL').AsFloat)), 14) + // Totaliza��o Mensal
                   FormatDateTime('yyyymmdd', dtIni) + // Data inicial da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtFim) + // Data final da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da gera��o do relat�rio
                   FormatDateTime('HHnnss', hrGeracao)  // hora da gera��o do relat�rio
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                 Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instri��o Estadual da Desenvolvedora
                 RightStr(Replicate('0', 6) + IntToStr(iZ), 6)  // Total de registros Z4
                 );

    except

    end;
    CloseFile(F);                                    // Fecha o arquivo

    AssinaturaDigital(pChar(FileName));
    CHDir(Form1.sAtual);

    GeraXmlPafNfce(pChar(FileName), NUMERO_ARQUIVO_SAIDAS_IDENTIFICADAS_PELO_CPF_CNPJ);
  finally
    IBQuery.EnableControls;
  end;

end;

{ TRequisitosPafNfce }

constructor TRequisitosPafNfce.Create;
begin
  inherited;
  Form1.bOcultarMensagemArquivoAssinado := True;
end;

destructor TRequisitosPafNfce.Destroy;
begin
  Form1.bOcultarMensagemArquivoAssinado := False;
  FreeAndNil(FRequisitos);
  inherited;
end;

function TRequisitosPafNfce.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result := FRequisitos.IdentificacaoDaEmpresaDesenvolvedora;
end;

procedure TRequisitosPafNfce.RequisitosDoPafNFCe(sAtualOnLine: String);
begin
  FRequisitos.spdNFCe := FspdNFCe; // Sandro Silva 2023-02-13
  FRequisitos.RequisitosDoPafNFCe(sAtualOnLine);
end;

procedure TRequisitosPafNfce.setVersao(const Value: TVersaoErPafNfce);
begin
  FVersao := Value;
  case FVersao of
    tPafNfceEr0100: FRequisitos := TRequisitosPafNfce0100.Create;
    tPafNfceEr0200: FRequisitos := TRequisitosPafNfce0200.Create;
  else
    FRequisitos := TRequisitosPafNfce0200.Create;
  end;

  FRequisitos.IBTransaction := IBTransaction;
end;

procedure TRequisitosPafNfce.VendasIdentificadaspeloCPFCNPJ(
  dtPeriodo: TDate; CnpjCpfCliente: String);
begin
  FRequisitos.spdNFCe := FspdNFCe; // Sandro Silva 2023-02-13
  FRequisitos.VendasIdentificadaspeloCPFCNPJ(dtPeriodo, CnpjCpfCliente);
end;

{ TRequisitosPafNfceBase }

constructor TRequisitosPafNfceBase.Create;
begin
  FIBQEmitente := TIBQuery.Create(nil);
end;

procedure TRequisitosPafNfceBase.SetIBTransaction(
  const Value: TIBTransaction);
begin
  FIBTransaction := Value;
  FIBQEmitente.Transaction := FIBTransaction;
end;

end.
