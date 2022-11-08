unit upafnfce;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs,
  IBQuery, DBClient, Db, IniFiles, StrUtils, DateUtils
  , IBDatabase
  , StdVCL
  , base64code
  ;

type

  TVersaoErPafNfce = (tPafNfceEr0100, tPafNfceEr0200);

  TRequisitosPafNfceBase = class
  private
    FIBTransaction: TIBTransaction;
  public
    function IdentificacaoDaEmpresaDesenvolvedora: String; virtual; abstract;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); virtual; abstract;
    property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
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
    function GeraXmlPafNfce(sArquivo: String; nroArquivo: String): String;
  public
    function IdentificacaoDaEmpresaDesenvolvedora: String; override;
    procedure VendasIdentificadaspeloCPFCNPJ(dtPeriodo: TDate;
      CnpjCpfCliente: String); override;
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
    'CNPJ: 07.426.598/0001-24' + #13 +
    'Razão Social: SMALLSOFT TECNOLOGIA EM INFORMÁTICA EIRELI' + #13 +
    'Endereço: Rua Getúlio Vargas, 673, Centro 89700-019 - Concórdia-SC' + #13 +
    'Telefone: 049 3425 5800' + #13 +
    'Contato: Ronei Ivo Weber' + #13 +
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
  IBQEmitente: TIBQuery;
  IBQuery: TIBQuery;
begin
  inherited;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transação não informada');
    Exit;
  end;

  IBQuery     := TIBQuery.Create(nil);
  IBQEmitente := TIBQuery.Create(nil);
  IBQEmitente.Transaction := FIBTransaction;
  IBQuery.Transaction     := FIBTransaction;

  try

    dtGeracao := Date;
    hrGeracao := Time;

    FileName := ExtractFilePath(Application.ExeName) + 'VENDAS_IDENTIFICADAS_PELO_CPF_CNPJ.TXT';

    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para gravação
    try
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
                  right('00000000000000' + LimpaNumero(IBQEmitente.FieldByName('CGC').AsString), 14) + // CNPJ
                  Copy(LimpaNumero(IBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Estadual
                  Copy(LimpaNumero(IBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Municipal
                  Copy(AnsiUpperCase(IBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Razão social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + '07426598000124', 14) + // CNPJ da Desenvolvedora
                  Copy('255422385' + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                  Copy('22842' + Replicate(' ', 14), 1, 14) + // Inscrição Municipal da Desenvolvedora
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
                   FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da geração do relatório
                   FormatDateTime('HHnnss', hrGeracao)  // hora da geração do relatório
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right('07426598000124', 14) + // CNPJ da Desenvolvedora
                 Copy('255422385' + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                 RightStr(Replicate('0', 6) + IntToStr(iZ), 6)  // Total de registros Z4
                 );

    except

    end;
    CloseFile(F);                                    // Fecha o arquivo

  finally
    IBQuery.EnableControls;

    if FileExists(FileName) then
      SmallMsg('O arquivo: '+FileName+' foi gravado na pasta: '+extractFilePath(FileName));
  end;
end;

{ TRequisitosPafNfce0200 }

function TRequisitosPafNfce0200.GeraXmlPafNfce(sArquivo,
  nroArquivo: String): String;
var
  sXml: String;
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

        if FileExists(ChangeFileExt(sarquivo, '.XML')) then
          SmallMsg('O arquivo: ' + ChangeFileExt(sarquivo, '.XML') + ' foi gravado na pasta: ' + ExtractFilePath(ChangeFileExt(sarquivo, '.XML')));

      except

      end;
    end;
  finally
    FreeAndNil(arquivo);
  end;
end;

function TRequisitosPafNfce0200.IdentificacaoDaEmpresaDesenvolvedora: String;
begin
  Result :=
    'a) Identificação da empresa desenvolvedora' + #13 +
    #13 +
    '1. CNPJ: 07.426.598/0001-24' + #13 +
    '2. Razão Social: SMALLSOFT TECNOLOGIA EM INFORMÁTICA EIRELI' + #13 +
    '3. Endereço: Rua Getúlio Vargas, 673, Centro 89700-019 - Concórdia-SC' + #13 +
    '4. Telefone: 049 3425 5800' + #13 +
    '5. Contato: Ronei Ivo Weber' + #13 +
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

procedure TRequisitosPafNfce0200.VendasIdentificadaspeloCPFCNPJ(
  dtPeriodo: TDate; CnpjCpfCliente: String);
var
  F: TextFile;
  iZ: Integer;
  dtGeracao: TDate;
  hrGeracao: TTime;
  FileName: String;
  IBQEmitente: TIBQuery;
  IBQuery: TIBQuery;
begin
  inherited;

  if FIBTransaction = nil then
  begin
    raise Exception.Create('Transação não informada');
    Exit;
  end;

  IBQuery     := TIBQuery.Create(nil);
  IBQEmitente := TIBQuery.Create(nil);
  IBQEmitente.Transaction := FIBTransaction;
  IBQuery.Transaction     := FIBTransaction;

  try

    dtGeracao := Date;
    hrGeracao := Time;

    FileName := ExtractFilePath(Application.ExeName) + 'VENDAS_IDENTIFICADAS_PELO_CPF_CNPJ.TXT';

    DeleteFile(FileName);
    AssignFile(F, FileName);
    Rewrite(F);                           // Abre para gravação
    try

      IBQEmitente.close;
      IBQEmitente.SQL.Text :=
        'select CGC, IE, IM, NOME ' +
        'from EMITENTE';
      IBQEmitente.Open;

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
                  right('00000000000000' + LimpaNumero(IBQEmitente.FieldByName('CGC').AsString), 14) + // CNPJ
                  Copy(LimpaNumero(IBQEmitente.FieldByName('IE').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Estadual
                  Copy(LimpaNumero(IBQEmitente.FieldByName('IM').AsString) + Replicate(' ', 14), 1, 14) + // Incrição Municipal
                  Copy(AnsiUpperCase(IBQEmitente.FieldByName('NOME').AsString) + Replicate(' ', 50), 1, 50) // Razão social
                  );

      Writeln(F,  'Z2' +                                                          // Tipo Z2
                  Right('00000000000000' + '07426598000124', 14) + // CNPJ da Desenvolvedora
                  Copy('255422385' + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
                  Copy('22842' + Replicate(' ', 14), 1, 14) + // Inscrição Municipal da Desenvolvedora
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
                   FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAI').AsDateTime) + // Data inicial da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', IBQuery.FieldByName('DATAF').AsDateTime) + // Data final da vendas ao CPF/CNPJ
                   FormatDateTime('yyyymmdd', dtGeracao) + // Data da geração do relatório
                   FormatDateTime('HHnnss', hrGeracao)  // hora da geração do relatório
                   );

        IBQuery.Next;
      end;

      Writeln(F, 'Z9' +                                                          // Tipo Z9
                 Right('07426598000124', 14) + // CNPJ da Desenvolvedora
                 Copy('255422385' + Replicate(' ', 14), 1, 14) + // Instrição Estadual da Desenvolvedora
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
    tPafNfceEr0200: FRequisitos := TRequisitosPafNfce0200.Create;
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

end.
