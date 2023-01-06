unit upafnfce;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  IBQuery, DBClient, Db, IniFiles, StrUtils, DateUtils
  , IBDatabase
  , StdVCL
  , base64code
  , CAPICOM_TLB
  ;

type

  TVersaoErPafNfce = (tPafNfceEr0100, tPafNfceEr0200);

  TRequisitosPafNfceBase = class
  private
    FIBTransaction: TIBTransaction;
    FCertificadoSubjectName: String;
    FIBQEmitente: TIBQuery;
    procedure SetFCertificadoSubjectName(const Value: String);
    procedure SetIBTransaction(const Value: TIBTransaction);
  public
    constructor Create;
    function IdentificacaoDaEmpresaDesenvolvedora: String; virtual; abstract;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); virtual; abstract;
    property IBTransaction: TIBTransaction read FIBTransaction write SetIBTransaction;
    property CertificadoSubjectName: String read FCertificadoSubjectName write SetFCertificadoSubjectName;
    property IBQEmitente: TIBQuery read FIBQEmitente write FIBQEmitente;
  end;

  TRequisitosPafNfce0100 = class(TRequisitosPafNfceBase)
  private
  public
    function IdentificacaoDaEmpresaDesenvolvedora: String; override;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); override;
  end;

  TRequisitosPafNfce0200 = class(TRequisitosPafNfceBase)
  private
    FCertificado: ICertificate2;
    function GeraXmlPafNfce(sArquivo: String; nroArquivo: String): String;
    procedure SetCertificado(const Value: ICertificate2);
    procedure MensagemAlertaCertificado;
    function GetCertificado(bPermitirSelecionar: Boolean): ICertificate2;// Sandro Silva 2018-02-06  function GetCertificado: ICertificate2;
  public
    //  property Certificado: ICertificate2 read FCertificado write SetCertificado; // Sandro Silva 2018-02-06 FCertificado;


    function IdentificacaoDaEmpresaDesenvolvedora: String; override;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); override;
    function AssinaturaDigitalPafNFCe(sArquivo: String): String;
  end;

type
  TRequisitosPafNfce = class
  private
    FVersao: TVersaoErPafNfce;
    FRequisitos: TRequisitosPafNfceBase;
    FIBTransaction: TIBTransaction;
    procedure setVersao(const Value: TVersaoErPafNfce);

  public
    constructor Create;
    destructor Destroy; override;
    property VersaoER: TVersaoErPafNfce read FVersao write setVersao;
    property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    function IdentificacaoDaEmpresaDesenvolvedora: String;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String);
  end;

implementation

uses fiscal
  , unit7
  , ufuncoesfrente
  , SmallFunc
  , uassinaxmlpafnfce
  ;

{ TRequisitosPafNfce0100 }

function TRequisitosPafNfce0100.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result :=
  'a) Identificação da empresa desenvolvedora' + #13 +
    #13 +
    'CNPJ: ' + CNPJ_SOFTWARE_HOUSE_PAF + #13 +
    'Razão Social: ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + #13 +
    'Endereço: Rua Getúlio Vargas, 673, Centro 89700-019 - Concórdia-SC' + #13 +
    'Telefone: 049 3425 5800' + #13 +
    'Contato: Alessio Mainardi' + #13 +
    #13 +
    'Identificação do PAF-NFC-e' + #13 +
    #13 +
    'Nome comercial do PAF-NFC-e: Small Commerce' + #13 +
    'Versão do PAF-NFC-e: ' + Build
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
//  IBQEmitente: TIBQuery;
  IBQuery: TIBQuery;
  dtIni: TDate;// Sandro Silva 2023-01-05
  dtFim: TDate;// Sandro Silva 2023-01-05
begin
  inherited;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transação não informada');
    Exit;
  end;

  IBQuery     := TIBQuery.Create(nil);
//  IBQEmitente := TIBQuery.Create(nil);
 // IBQEmitente.Transaction := FIBTransaction;
  IBQuery.Transaction     := FIBTransaction;

  try

    bGerando := True;

    dtGeracao := Date;
    hrGeracao := Time;

    FileName := ExtractFilePath(Application.ExeName) + 'VENDAS_IDENTIFICADAS_PELO_CPF_CNPJ.TXT';

    {Sandro Silva 2023-01-05 inicio}
    dtIni := StrToDate('01/' + FormatDateTime('mm/yyyy', dtPeriodo));
    dtFim := StrToDate(IntToStr(DaysInAMonth(YearOf(dtPeriodo), MonthOf(dtPeriodo))) + '/' + FormatDateTime('mm/yyyy', dtPeriodo));
    {Sandro Silva 2023-01-05 fim}

    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para gravação
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
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Estadual
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Municipal
                  Copy(AnsiUpperCase(FIBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Razão social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                  Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                  Copy(IM_SOFTWARE_HOUSE_PAF + Replicate(' ', 14), 1, 14) + // Inscrição Municipal da Desenvolvedora
                  // 2015-09-08 Copy('SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI' + Replicate(' ', 50), 1, 50) // Razão social da Desenvolvedora
                  Copy(AnsiUpperCase(Form1.sRazaoSocialSmallsoft) + Replicate(' ', 50), 1, 50) // Razão social da Desenvolvedora
                  );

      if PAFNFCe then
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(LimpaNumero(Build) + Replicate(' ', 10), 1, 10) // Versão do PAF-ECF
                    );
      end
      else
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy(StringReplace(NUMERO_LAUDO_PAF_ECF, 'Rn', '', [rfReplaceAll]) + Replicate(' ', 10), 1, 10) + // Laudo do PAF-ECF
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(Build + Replicate(' ', 10), 1, 10) // Versão do PAF-ECF
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
                   Right('00000000000000' + LimpaNumero(FormatFloat('0.00', IBQuery.FieldByName('TOTAL').AsFloat)), 14) + // Totalização Mensal
                   FormatDateTime('yyyymmdd', dtIni) + // Data inicial da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtFim) + // Data final da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da geração do relatório
                   FormatDateTime('HHnnss', hrGeracao)  // hora da geração do relatório
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                 Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
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

{ TRequisitosPafNfce0200 }

function TRequisitosPafNfce0200.AssinaturaDigitalPafNFCe(
  sArquivo: String): String;
// Assina XML de requisitos do PAF-NFCe
var
  IBQEmitente: TIBQuery;
begin
  IBQEmitente := TIBQuery.Create(nil);
  IBQEmitente.Transaction := FIBTransaction;
  IBQEmitente.Close;
  IBQEmitente.SQL.Text :=
    'select CGC ' +
    'from EMITENTE ';
  IBQEmitente.Open;

  GetCertificado(True);

  Result := AssinarMSXMLPafNfce(sArquivo, LimpaNumero(IBQEmitente.FieldByName('CGC').AsString), FCertificado, '""');

end;

function TRequisitosPafNfce0200.GeraXmlPafNfce(sArquivo,
  nroArquivo: String): String;
var
//  sXml: String;
  arquivo: TArquivo;
begin
  arquivo := TArquivo.Create;
  try
    try
      arquivo.LerArquivo(sArquivo, False);
      Result :=
        PAF_NFC_E_ESPECIFICACAO_XML +
        '<menuFiscal xmlns="http://www.sef.sc.gov.br/nfce">' +
        '<arquivo nroArquivo="' + nroArquivo + '" data="' + FormatDateTime('ddmmyyyy', Date) + '" hora="' + FormatDateTime('HHnnss', Time) + '" ArqBD="Banco de dados interno" arqSist="PAF-NFC-e Interno">' +
          '<![CDATA[' + Base64Encode(arquivo.Texto) + ']]></arquivo>' +
        '<Signature />' +
        '</menuFiscal>';

    except

    end;
    if Result <> '' then
    begin
      try
        arquivo.Texto := Result;
        arquivo.SalvarArquivo(ChangeFileExt(sarquivo, '.XML'));

        AssinaturaDigitalPafNFCe(arquivo.Texto);

        if FileExists(ChangeFileExt(sarquivo, '.XML')) then
          SmallMsg('O arquivo: ' + ChangeFileExt(sarquivo, '.XML') + ' foi gravado na pasta: ' + ExtractFilePath(ChangeFileExt(sarquivo, '.XML')));

      except

      end;
    end;
  finally
    FreeAndNil(arquivo);
  end;
end;

function TRequisitosPafNfce0200.GetCertificado(
  bPermitirSelecionar: Boolean): ICertificate2;
var
  Store: IStore3;
  CertsLista: ICertificates2;
  CertsSelecionado: ICertificates2;
  CertDados: ICertificate;
  iCert: Integer;
  bAchou: Boolean;
begin
  Store := CoStore.Create;
  Store.Open(CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED);

  bAchou := False;

  if FCertificadoSubjectName = '' then
  begin
    if bPermitirSelecionar then // Sandro Silva 2018-02-06 
    begin

      MensagemAlertaCertificado;

      try
        CertsLista := Store.Certificates as ICertificates2;
        CertsSelecionado := CertsLista.Select('Certificado(s) Digital(is) disponível(is)', #13 + 'Selecione o Certificado Digital para uso no aplicativo PAF' + #13 + #13, False);
        if not (CertsSelecionado.Count = 0) then
        begin
          CertDados := IInterface(CertsSelecionado.Item[1]) as ICertificate2;
          FCertificadoSubjectName := CertDados.SubjectName;
          bAchou := True;
        end;
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar('Não foi possível selecionar o certificado digital' + #13 + E.Message), 'Atenção', MB_ICONWARNING + MB_OK);
        end;
      end;
    end;
  end
  else
  begin
    try
      CertsLista := Store.Certificates as ICertificates2;
      for iCert := 1 to CertsLista.Count do
      begin
        CertDados := ICertificate2(IInterface(CertsLista.Item[iCert]));
        if AnsiContainsText(CertDados.SubjectName, Copy(FCertificadoSubjectName, 1, Pos(',', FCertificadoSubjectName))) then // Sandro Silva 2022-11-17 if CertDados.SubjectName = FCertificadoSubjectName then
        begin
          bAchou := True;
          Break;
        end;
      end;
    except

    end;
  end;
  Result := CertDados as ICertificate2;

  if bAChou = False then
    Result := nil;

  FCertificado := Result;

  {Sandro Silva 2019-06-19 inicio}
  if CertsLista <> nil then
    CertsLista := nil;

  if CertsSelecionado <> nil then
    CertsSelecionado := nil;

  // causa exception "Privileged instruction" Store.Close; // Sandro Silva 2018-08-30
  Store := nil;// Sandro Silva 2018-08-30

end;

function TRequisitosPafNfce0200.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result :=
    'a) Identificação da empresa desenvolvedora' + #13 +
    #13 +
    '1. CNPJ: ' + CNPJ_SOFTWARE_HOUSE_PAF + #13 +
    '2. Razão Social: ' + RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF + #13 +
    '3. Endereço: Rua Getúlio Vargas, 673, Centro 89700-019 - Concórdia-SC' + #13 +
    '4. Telefone: 049 3425 5800' + #13 +
    '5. Contato: Alessio Mainardi' + #13 +
    #13 +
    'b) Identificação do PAF-NFC-e' + #13 +
    #13 +
    '1. Nome comercial do PAF-NFC-e: Small Commerce' + #13 +
    '2. Versão do PAF-NFC-e: ' + Build
    + #13 +
    #13 +
    'c) a informação relativa à arquitetura de implantação do sistema de gestão,' + #13 +
    #13 +
    'c.2) Dados integralmente armazenados no estabelecimento,' + #13 +
    'em equipamento diverso do especificado em “c.1”: “Banco de dados interno”'  + #13 +
    #13 +
    'd) a informação relativa à arquitetura de implantação do PAF-NFC-e ' + #13 +
    #13 +
    'd.2) programa integralmente executado no estabelecimento,' + #13 +
    'em equipamento diverso do especificado em “d.1”: “PAF-NFC-e Interno”'

end;

procedure TRequisitosPafNfce0200.MensagemAlertaCertificado;
begin
  Application.MessageBox(PChar(
                               'Selecione um certificado digital para ser usado com o PAF' + #13 + #13 +
                               'O certificado digital é necessário para assinar os arquivos XML gerados '
                                +chr(10)+ ''
                                +chr(10)+'1 - Verifique se o seu certificado está instalado'
                                +chr(10)+'2 - Verifique se o seu certificado está selecionado'
                                +chr(10)+'3 - Seu certificado pode estar vencido'
                                +chr(10)+'4 - Seu certificado pode ser inválido'
                                +chr(10)
                                +chr(10)+'Certificados recomendados' // Sandro Silva 2022-12-02 Unochapeco +chr(10)+'Certificados recomendados pela Smallsoft®'
                                +chr(10)+''
                                +chr(10)+'1. Certificados SERASA'
                                +chr(10)+'    * A1'
                                +chr(10)+'    * SmartCard'
                                +chr(10)+'    * E-CNPJ'
                                +chr(10)+'2. Certificados Certisign A1 e A3'
                                +chr(10)+'3. Certificados dos Correios A1 e A3'
                                +chr(10)+'4. Certificados A3 PRONOVA ACOS5'
                                +chr(10)
                                +chr(10)+'Selecione um certificado acessando'
                                +chr(10)+'F10 Menu Gerencial/NFC-e/Selecionar certificado digital'
                                +chr(10)
                                +chr(10)
                                +chr(10)
                                +'OBS: Não ligue para o suporte técnico da Zucchetti® por este motivo.'), // Sandro Silva 2022-12-02 Unochapeco +'OBS: Não ligue para o suporte técnico da Smallsoft® por este motivo.'),
                                    'Atenção', MB_ICONWARNING + MB_OK);
end;

procedure TRequisitosPafNfce0200.SetCertificado(
  const Value: ICertificate2);
begin
  FCertificado := Value;
  if Value <> nil then
    FCertificadoSubjectName := Value.SubjectName;

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
    raise Exception.Create('Transação não informada');
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
    Rewrite(F);                           // Abre para gravação
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
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Estadual
                  Copy(LimpaNumero(FIBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Municipal
                  Copy(AnsiUpperCase(FIBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Razão social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                  Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                  Copy(IM_SOFTWARE_HOUSE_PAF + Replicate(' ', 14), 1, 14) + // Inscrição Municipal da Desenvolvedora
                  // 2015-09-08 Copy('SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI' + Replicate(' ', 50), 1, 50) // Razão social da Desenvolvedora
                  Copy(AnsiUpperCase(Form1.sRazaoSocialSmallsoft) + Replicate(' ', 50), 1, 50) // Razão social da Desenvolvedora
                  );

      if PAFNFCe then
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(LimpaNumero(Build) + Replicate(' ', 10), 1, 10) // Versão do PAF-ECF
                    );
      end
      else
      begin
        Writeln(F,  'Z3' +                                                          // Tipo Z3
                    Copy(StringReplace(NUMERO_LAUDO_PAF_ECF, 'Rn', '', [rfReplaceAll]) + Replicate(' ', 10), 1, 10) + // Laudo do PAF-ECF
                    Copy('SMALL COMMERCE' + Replicate(' ', 50), 1, 50) + // Nome do PAF-ECF
                    Copy(Build + Replicate(' ', 10), 1, 10) // Versão do PAF-ECF
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
                   Right('00000000000000' + LimpaNumero(FormatFloat('0.00', IBQuery.FieldByName('TOTAL').AsFloat)), 14) + // Totalização Mensal
                   FormatDateTime('yyyymmdd', dtIni) + // Data inicial da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtFim) + // Data final da vendas ao CPF/CNPJ // Sandro Silva 2023-01-05 FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da geração do relatório
                   FormatDateTime('HHnnss', hrGeracao)  // hora da geração do relatório
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF), 14) + // CNPJ da Desenvolvedora
                 Copy(LimpaNumero(IE_SOFTWARE_HOUSE_PAF) + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                 RightStr(Replicate('0', 6) + IntToStr(iZ), 6)  // Total de registros Z4
                 );

    except

    end;
    CloseFile(F);                                    // Fecha o arquivo

    GeraXmlPafNfce(pChar(FileName), 'III');
  finally
    IBQuery.EnableControls;
  end;

end;

{ TRequisitosPafNfce }

constructor TRequisitosPafNfce.Create;
begin
  inherited;

end;

destructor TRequisitosPafNfce.Destroy;
begin

  FreeAndNil(FRequisitos);
  inherited;
end;

function TRequisitosPafNfce.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result := FRequisitos.IdentificacaoDaEmpresaDesenvolvedora;
end;

procedure TRequisitosPafNfce.setVersao(const Value: TVersaoErPafNfce);
begin
  FVersao := Value;
  case FVersao of
    tPafNfceEr0100: FRequisitos := TRequisitosPafNfce0100.Create;
    tPafNfceEr0200:
    begin
      FRequisitos := TRequisitosPafNfce0200.Create;
      FRequisitos.CertificadoSubjectName := LerParametroIni(FRENTE_INI, SECAO_65, CHAVE_CERTIFICADO_DIGITAL, '');
    end;
  else
    FRequisitos := TRequisitosPafNfce0100.Create;
  end;

  FRequisitos.IBTransaction := IBTransaction;
end;

procedure TRequisitosPafNfce.VendasIdentificadaspeloCPFCNPJ(
  dtPeriodo: TDate; CnpjCpfCliente: String);
begin
  FRequisitos.VendasIdentificadaspeloCPFCNPJ(dtPeriodo, CnpjCpfCliente);
end;

{ TRequisitosPafNfceBase }

constructor TRequisitosPafNfceBase.Create;
begin
  FIBQEmitente := TIBQuery.Create(nil);
end;

procedure TRequisitosPafNfceBase.SetFCertificadoSubjectName(
  const Value: String);
begin
  FCertificadoSubjectName := Value;
end;

procedure TRequisitosPafNfceBase.SetIBTransaction(
  const Value: TIBTransaction);
begin
  FIBTransaction := Value;
  FIBQEmitente.Transaction := FIBTransaction;
end;

end.
