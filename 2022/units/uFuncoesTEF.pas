unit uFuncoesTEF;

interface

uses
  Vcl.Forms, WinApi.Windows, uDialogs, WinApi.ShellAPI, System.IniFiles,
  uclassetransacaocartao, System.StrUtils, Vcl.Controls, System.Classes,
  System.SysUtils, uSelecionaTEF;

type
  TPagamentoPDV = class
  private
    FExtra4: Double;
    FExtra7: Double;
    FExtra6: Double;
    FExtra5: Double;
    FExtra1: Double;
    FExtra2: Double;
    FExtra8: Double;
    FExtra3: Double;
  public
    property Extra1: Double read FExtra1 write FExtra1;
    property Extra2: Double read FExtra2 write FExtra2;
    property Extra3: Double read FExtra3 write FExtra3;
    property Extra4: Double read FExtra4 write FExtra4;
    property Extra5: Double read FExtra5 write FExtra5;
    property Extra6: Double read FExtra6 write FExtra6;
    property Extra7: Double read FExtra7 write FExtra7;
    property Extra8: Double read FExtra8 write FExtra8;
    procedure Clear;
  end;

type
  TValoresTransacao = class
  private
    FnValor01: Double;
    FnValor02: Double;
    FnValor03: Double;
    FnValor06: Double;
    FnValor04: Double;
    FnValor05: Double;
    FnValor08: Double;
    FnValor07: Double;
    FnPagar: Double;
    FnReceber: Double;
    FnAcumulado1: Double;
    FcCupomTEFReduzido: String;
    FnAcumulado3: Double;
    FcCupomTEF: String;
    FnDiasCartaoCredito: Integer;
    FnDiasCartaoDebito: Integer;
  public
    constructor Create;
    property Valor01: Double read FnValor01 write FnValor01;
    property Valor02: Double read FnValor02 write FnValor02;
    property Valor03: Double read FnValor03 write FnValor03;
    property Valor04: Double read FnValor04 write FnValor04;
    property Valor05: Double read FnValor05 write FnValor05;
    property Valor06: Double read FnValor06 write FnValor06;
    property Valor07: Double read FnValor07 write FnValor07;
    property Valor08: Double read FnValor08 write FnValor08;
    property Pagar: Double read FnPagar write FnPagar;
    property Receber: Double read FnReceber write FnReceber;
    property Acumulado1: Double read FnAcumulado1 write FnAcumulado1;
    property Acumulado3: Double read FnAcumulado3 write FnAcumulado3;
    property CupomTEFReduzido: String read FcCupomTEFReduzido write FcCupomTEFReduzido;
    property CupomTEF: String read FcCupomTEF write FcCupomTEF;
    property DiasCartaoCredito: Integer read FnDiasCartaoCredito write FnDiasCartaoCredito;
    property DiasCartaoDebito: Integer read FnDiasCartaoDebito write FnDiasCartaoDebito;
    procedure Clear;
  end;

type
  TDadosTransacao = class
  private
    FnTotalPago: Currency;
    FnQtdeParcela: Integer;
    FnValorTot: String;
    FnValorSaque: String;
    FcNomeRede: String;
    FcTransaca: String;
    FcAutoriza: String;
    FcFinaliza: String;
    FcOkSim: String;
    FcTipoParc: String;
    FcMensagem: String;
    FcBandeira: String;
    FcDebitoOuCredito: String;
  public
    constructor Create;
    property TotalPago: Currency read FnTotalPago write FnTotalPago;
    property QtdeParcela: Integer read FnQtdeParcela write FnQtdeParcela;
    property ValorTot: String read FnValorTot write FnValorTot;
    property ValorSaque: String read FnValorSaque write FnValorSaque;
    property NomeRede: String read FcNomeRede write FcNomeRede;
    property Transaca: String read FcTransaca write FcTransaca;
    property Autoriza: String read FcAutoriza write FcAutoriza;
    property Finaliza: String read FcFinaliza write FcFinaliza;
    property OkSim: String read FcOkSim write FcOkSim;
    property TipoParc: String read FcTipoParc write FcTipoParc;
    property Mensagem: String read FcMensagem write FcMensagem;
    property Bandeira: String read FcBandeira write FcBandeira;
    property DebitoOuCredito: String read FcDebitoOuCredito write FcDebitoOuCredito;
  end;

type
  TFuncoesTEF = class
  private
    FcCNPJ: String;
    FoDadosTransacao: TDadosTransacao; // Valores apos processamento da transacao
    FoValoresTransacao: TValoresTransacao; // ibDataSet25
    FoTransacoesCartao: TTransacaoFinanceira;
    FoTEFSelecionado: TConfigTEF;
    FnQtdeCartoes: Integer;
    FcBuildEXE: String;
    FnValorCobrar: Currency;


    procedure AdicionaCNPJRequisicaoTEF(var tfFile: TextFile; AcCNPJ: String);
    function LerParametroIni(sArquivo, sSecao, sParametro,
      sValorDefault: String): String;
    function RetornarTEFUsado: String;
    procedure ValidaDiretorioTEF(sDirTef, sDirReq, sDirResp: String);
    function TEFValorTotalAutorizado: Currency;
    function TEFTextoImpressaoCupomAutorizado(sCampo: String): String;
    function SuprimirLinhasEmBrancoDoComprovanteTEF: Boolean;
    procedure TEFLimparPastaRetorno(sDiretorioResposta: String);
    procedure ListaDeArquivos(var Lista: TStringList; sAtual: String; sExtensao: String = '*.txt');
    function CampoTEF(sArquivoTEF, sCampo: String): String;
    function TEFValorTransacao(sArquivoTEF: String): Currency;
    procedure TEFDeletarCopiasArquivos;
  public
    constructor Create;
    destructor Destroy; override;
    function AtivaGeranciadorPadrao(p_diretorio, p_Req, p_Resp, p_Exec, NometefIni, AcCNPJ: String): Boolean;
    function InciarTransacaoTEF(bP1: Boolean): Boolean;
    procedure ConfirmaTransacao;

    property CNPJ: String read FcCNPJ write FcCNPJ;
    property BuildEXE: String read FcBuildEXE write FcBuildEXE;
    property ValoresTransacao: TValoresTransacao read FoValoresTransacao;
    property DadosTransacao: TDadosTransacao read FoDadosTransacao;
    property QtdeCartoes: Integer read FnQtdeCartoes write FnQtdeCartoes;
    property ValorCobrar: Currency read FnValorCobrar write FnValorCobrar;
  end;

implementation

uses
  SmallFunc_xe, uSmallConsts;

procedure TFuncoesTEF.ValidaDiretorioTEF(sDirTef: String; sDirReq: String; sDirResp: String);
begin
  // Cria as pastas de troca de mensagens com o TEF
  if DirectoryExists(sDirTef) = False then
    ForceDirectories(sDirTef);
  if DirectoryExists(sDirTef + '\' + sDirReq) = False then
    ForceDirectories(sDirTef + '\' + sDirReq);
  if DirectoryExists(sDirTef + '\' + sDirResp) = False then
    ForceDirectories(sDirTef + '\' + sDirResp);
end;

procedure TFuncoesTEF.AdicionaCNPJRequisicaoTEF(var tfFile: TextFile; AcCNPJ: String);
begin
  if AnsiUpperCase(RetornarTEFUsado) = 'SITEF' then
    WriteLn(tfFile, '565-008 = 1=' + LimpaNumero(AcCNPJ) + ';2=07426598000124'); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comerciala
end;

function TFuncoesTEF.AtivaGeranciadorPadrao(p_diretorio, p_Req, p_Resp, p_Exec, NometefIni, AcCNPJ: String): Boolean;
const _nMAX_TENTATIVA_ABRIR_TEF = 2;
var
  Hwnd: THandle;
  F : TextFile;
  I : Integer;
  iTentativa: Integer;// Sandro Silva 2021-08-27
begin

  ValidaDiretorioTEF('c:\'+p_diretorio, p_Req, p_Resp);

  //
  while FileExists('c:\'+p_diretorio+'\'+p_Resp+'\IntPos.sts') do
  begin
    DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Resp+'\IntPos.sts'));
    Sleep(10);
  end;
  //
  //
  if FileExists(p_Exec) then
  begin
    //
    // ---------------------------------------- //
    // Ao criar este arquivo o sistema verifica //
    //  se o gerenciador padrão está ativo.     //
    // ---------------------------------------- //
    // O arquivo INTPOS.001 deve ser criado no  //
    // diretório \'+sDiretorio+'\'+sREQ+'\      //
    // respostas em                             //
    // diretório \'+sDiretorio+'\'+sRESP+'\     //
    // ---------------------------------------- //
    //

    // TEF GetCard não elimina arquivos depois de processar
    DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\INTPOS.001')); // Sandro Silva 2020-05-29
    DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP')); // Sandro Silva 2020-05-29

    AssignFile(F,'c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP');
    // ATV Verifica se o TEF está ativo
    Rewrite(F);
    WriteLn(F,'000-000 = ATV');                               // Header: Verifica se o gerenciador padrão está ativo.
    WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
    AdicionaCNPJRequisicaoTEF(F, AcCNPJ); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
    WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
    CloseFile(F);

    RenameFile('c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP','c:\'+p_diretorio+'\'+p_Req+'\INTPOS.001');

    //
    for I := 0 to 450 do
    begin
      Application.ProcessMessages;
      if not (FileExists('c:\'+p_diretorio+'\'+p_Resp+'\INTPOS.STS')) then
        Sleep(10);
    end;

    iTentativa := 0; // Sandro Silva 2021-08-27
    //
    while not (FileExists('c:\'+p_diretorio+'\'+p_Resp+'\INTPOS.STS')) do
    begin
      //Ficha 5379
      Inc(iTentativa);
      if iTentativa > _nMAX_TENTATIVA_ABRIR_TEF then
      begin
        Application.ProcessMessages;
        if uDialogs.MensagemSistemaPergunta('Não foi possível iniciar automaticamente o gerenciador padrão do TEF ' +  NomeTefIni + chr(10)+ 'Tentar iniciar novamente?', [MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1]) = idNo then
        begin
          uDialogs.MensagemSistema('Não foi possível iniciar automaticamente o gerenciador padrão do TEF ' + NomeTefIni + ' ' + p_diretorio, msgAtencao);
          Break;
        end;
      end;

      if FileExists(p_Exec) then
      begin
        if iTentativa > _nMAX_TENTATIVA_ABRIR_TEF then
          iTentativa := 1;

        Application.ProcessMessages;
        uDialogs.MensagemSistema('O gerenciador padrão do TEF ' + NomeTefIni + ' não está ativo'+chr(10)+'e será ativado automaticamente!' + Chr(10) + 'Tentativa ' + IntToStr(iTentativa) + ' de ' + IntToStr(_nMAX_TENTATIVA_ABRIR_TEF), msgAtencao);

        try
          ChDir('c:\'+p_diretorio);
        except end;

        try

          ShellExecute(0, 'open', pChar(p_Exec), '', '', sw_normal);

        except end;

        Sleep(1000);

        // TEF GetCard não elimina arquivos depois de processar
        DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\INTPOS.001')); // Sandro Silva 2020-05-29
        DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP')); // Sandro Silva 2020-05-29


        AssignFile(F,'c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP');
        Rewrite(F);
        // ATV Verifica se o TEF está ativo
        WriteLn(F,'000-000 = ATV');                               // Header: Verifica se o gerenciador padrão está ativo.
        WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
        AdicionaCNPJRequisicaoTEF(F, AcCNPJ); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
        WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
        CloseFile(F);

        RenameFile('c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP','c:\'+p_diretorio+'\'+p_Req+'\INTPOS.001');
        //
        for I := 0 to 20 do
        begin
          if not ((FileExists('c:\'+p_diretorio+'\'+p_Resp+'\INTPOS.STS'))) then
          begin
            Sleep(1000);
          end;
        end;
        //
      end else
        SmallMsgBox(PChar('O gerenciador padrão do TEF ' + NomeTefIni + ' não está ativo'+chr(10)+'e não foi possível ativá-lo automaticamente!'),'Operador',mb_Ok + MB_ICONEXCLAMATION);
    end;

  end;
  Result := True;
end;

constructor TFuncoesTEF.Create;
begin
  FoValoresTransacao := TValoresTransacao.Create;
  FoTransacoesCartao := TTransacaoFinanceira.Create(nil);
  FoDadosTransacao := TDadosTransacao.Create;

  FnQtdeCartoes := 1; // Valor padrão para o commerce.
end;

destructor TFuncoesTEF.Destroy;
begin
  FreeAndNil(FoValoresTransacao);
  FreeAndNil(FoTransacoesCartao);
  FreeAndNil(FoDadosTransacao);
  if Assigned(FoTEFSelecionado) then
    FreeAndNil(FoTEFSelecionado);
  inherited;
end;

function TFuncoesTEF.LerParametroIni(sArquivo: String; sSecao: String; sParametro: String; sValorDefault: String): String;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(sArquivo);

  Result := Trim(ini.ReadString(sSecao, sParametro, sValorDefault));
  Ini.Free;

end;

function TFuncoesTEF.RetornarTEFUsado: String;
// Sandro Silva 2019-08-13 Retorno o Nome do tef usado
begin
  Result := LerParametroIni('FRENTE.INI', 'Frente de caixa', 'TEF USADO', 'TEF_DISC');
end;

function TFuncoesTEF.InciarTransacaoTEF(bP1:Boolean): Boolean;
var
  I: Integer;
  F: TextFile;
  sBotaoOk, sCerto, sCerto1: String;
  bOk: Boolean;
  sMensagem: String;
  sCupom: String;

  sCupom029,
  sCupom710,
  sCupom711,
  sCupom712,
  sCupom713,
  sCupom714,
  sCupom715: String;
  fDescontoNoPremio: Real;
  iContaCartao: Integer;
  dTotalEmCartao: Currency;
  dValorPagarCartao: Currency;
  dTotalTransacionado: Currency;

  bIniciarTEF: Boolean;
  bConfirmarTransacao: Boolean;
  sCupomReduzidoAutorizado: String;
  sCupomAutorizado: String;
  iTotalParcelas: Integer;
  dTotalTransacaoTEF: Double;
  dValorDuplReceber: Currency;
  ModalidadeTransacao: TTipoModalidadeTransacao;
  sRespostaTef: String;
  FormasExtras: TPagamentoPDV;


  cCaminhoTEF: String;
  cLinha: String;
  nParcelas: Integer;


  procedure RecuperaValoresFormasExtras;
  begin
    // Quando transaciona mais que um cartão na mesma venda e informa valores nas formas extras,
    // esses valores da se perdem porque a rotina qua controla o que falta pagar joga a diferença do cartão para a forma dinheiro
    // Recupera os valores lançados nas formas extras
    FoValoresTransacao.Valor01 := FormasExtras.Extra1;
    FoValoresTransacao.Valor02 := FormasExtras.Extra2;
    FoValoresTransacao.Valor03 := FormasExtras.Extra3;
    FoValoresTransacao.Valor04 := FormasExtras.Extra4;
    FoValoresTransacao.Valor05 := FormasExtras.Extra5;
    FoValoresTransacao.Valor06 := FormasExtras.Extra6;
    FoValoresTransacao.Valor07 := FormasExtras.Extra7;
    FoValoresTransacao.Valor08 := FormasExtras.Extra8;
  end;

  function DesconsideraLinhasEmBranco(Texto: String): String;
  begin
    Result := Texto;
    if SuprimirLinhasEmBrancoDoComprovanteTEF then
    begin
      if StringReplace(Result, ' ', '', [rfReplaceAll]) <> '""' then
        Result := StrTran(Result, '"', '') + Chr(10)
      else
        Result := '';
    end
    else
      Result := StrTran(Result, '"', '') + Chr(10);
  end;
begin
  Result := False;
  bIniciarTEF := True;

  FormasExtras := TPagamentoPDV.Create;

  FormasExtras.Extra1 := FoValoresTransacao.Valor01;
  FormasExtras.Extra2 := FoValoresTransacao.Valor02;
  FormasExtras.Extra3 := FoValoresTransacao.Valor03;
  FormasExtras.Extra4 := FoValoresTransacao.Valor04;
  FormasExtras.Extra5 := FoValoresTransacao.Valor05;
  FormasExtras.Extra6 := FoValoresTransacao.Valor06;
  FormasExtras.Extra7 := FoValoresTransacao.Valor07;
  FormasExtras.Extra8 := FoValoresTransacao.Valor08;


  dTotalEmCartao           := FnValorCobrar;
  FoValoresTransacao.Pagar := FnValorCobrar;

  iContaCartao := 0;
  FoTransacoesCartao.Transacoes.Clear;
  bConfirmarTransacao := False;

  dTotalTransacionado := TEFValorTotalAutorizado();

  sCupomReduzidoAutorizado := '';
  sCupomAutorizado         := '';

  iTotalParcelas := 0;

  if dTotalTransacionado > 0 then
  begin
    sCupom710 := TEFTextoImpressaoCupomAutorizado('710-');
    if AllTrim(sCupom710) <> '' then
    begin
      sCupomReduzidoAutorizado := sCupomReduzidoAutorizado + Chr(10) + TEFTextoImpressaoCupomAutorizado('711-') + DupeString('-', 40);
    end
    else
    begin
      sCupom712 := TEFTextoImpressaoCupomAutorizado('712-'); // Quantidade linhas via cliente
      if AllTrim(sCupom712) <> '' then
        sCupomAutorizado := TEFTextoImpressaoCupomAutorizado('713'); // Texto via cliente
    end;
    //
    sCupom714 := TEFTextoImpressaoCupomAutorizado('714-'); // Quantidade linhas via estabelecimento
    if AllTrim(sCupom714) <> '' then
    begin
      sCupomAutorizado := sCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('715-'); // Texto via estabelecimento
    end else
    begin
      sCupomAutorizado := sCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('029-'); // Indica o status da confirmação da transação
    end;
    //
    if AllTrim(StrTran(sCupomAutorizado,chr(10),'')) = '' then
      sCupomAutorizado := '';

    if SuprimirLinhasEmBrancoDoComprovanteTEF then
    begin
      while AnsiContainsText(sCupomAutorizado, chr(10) + chr(10)) do
        sCupomAutorizado := StringReplace(sCupomAutorizado, chr(10) + chr(10), chr(10), [rfReplaceAll]);
    end;

    FoDadosTransacao.TotalPago := dTotalTransacionado; // Sandro Silva 2017-06-26
  end;

  Result := (dTotalEmCartao = dTotalTransacionado);
  try
    if not Result then
    begin

      while dTotalTransacionado < dTotalEmCartao do // Enquanto não totalizar transações com valor devido
      begin

        dValorPagarCartao := dTotalEmCartao - dTotalTransacionado;

        if (dTotalEmCartao - (dTotalTransacionado + dValorPagarCartao)) < 0 then
        begin
          Application.MessageBox('Valor total da transação maior que o valor definido para a forma de pagamento cartão', 'Atenção', MB_ICONWARNING + MB_OK);
        end
        else
        begin
          if dValorPagarCartao = 0 then
            Break
          else
          begin
            fDescontoNoPremio := 0;

            frmSelecionaTEF := TfrmSelecionaTEF.Create(nil);
            try
              while (not Assigned(FoTEFSelecionado))
                    or (FoTEFSelecionado.Nome = EmptyStr)
                    or (FoTEFSelecionado.Caminho = EmptyStr) do
              begin
                frmSelecionaTEF.ChamarTela;

                FoTEFSelecionado := frmSelecionaTEF.ConfigTEFSelecionado;

                if (not Assigned(FoTEFSelecionado))
                   or (FoTEFSelecionado.Nome = EmptyStr)
                   or (FoTEFSelecionado.Caminho = EmptyStr) then
                  raise Exception.Create('Nenhum TEF válido foi selecionado.');
                cCaminhoTEF := FoTEFSelecionado.Caminho;
              end;
            finally
              FreeAndNil(frmSelecionaTEF);
            end;

            if bIniciarTEF then
            begin

              //
              // Escolhe a bandeira
              //
              // Ativa o gerenciador padão
              //
              AtivaGeranciadorPadrao(cCaminhoTEF, FoTEFSelecionado.Req, FoTEFSelecionado.Resp, FoTEFSelecionado.Exec, EmptyStr, FcCNPJ);
              //
              // Se não existe o arquivo INTPOS.STS na pasta RESP o gerenciador
              // não ativou atumaticamente e não esta ativo
              //
              if not FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS') then
              begin
                Application.ProcessMessages;
                Application.MessageBox('O gerenciador padrão do TEF não está ativo.','Operador',mb_Ok + MB_ICONEXCLAMATION);

                TEFLimparPastaRetorno('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp); // Form1.TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP);
                DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001'));
                DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS'));

                Result := False;
                Abort;
              end else
              begin

                //deletando quando reenviar nfce rejeitada
                //
                TEFLimparPastaRetorno('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp); // Form1.TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP);
                DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001'));
                Sleep(100);
                // --------------------------------------------------------- //
                // CRT - Autorização para operação com cartão de crédito     //
                // --------------------------------------------------------- //
                AssignFile(F,'c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\IntPos.TMP');
                Rewrite(F);
                //
                if (FoValoresTransacao.Acumulado1 <> 0) then  // and (UpperCase(sDIRETORIO) = 'TEF_DIAL')
                begin
                  //
                  //
                  // Cheque 341029600100006505251087816289
                  //
                  //CHQ Pedido de autorização para transação por meio de cheque
                  WriteLn(F,'000-000 = CHQ');
                  WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                  WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(FoValoresTransacao.Acumulado1)]))));             // Valor Total: 12c
                end else
                begin
                  // CRT Pedido de autorização para transação por meio de cartão
                  WriteLn(F,'000-000 = CRT');                                                     // Header: Cartão 3c
                  WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                  WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(dValorPagarCartao)]))));             // Valor Total: 12c// Sandro Silva 2017-06-12  WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(Form1.ibDataSet25.FieldByName('PAGAR').AsFloat)]))));             // Valor Total: 12c
                end;
                //
                WriteLn(F,'004-000 = 0');             // Moeda: 0 - Real, 1 - Dolar americano
                WriteLn(F,'210-084 = SMALLSOF10');    // Nome da automação comercial (8 posições) + Capacidades da automação (1-preparada para tratar o desconto) + campo reservado, deve ser enviado 0
                AdicionaCNPJRequisicaoTEF(F, FcCNPJ); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                WriteLn(F,'701-000 = SMALL COMMERCE,  ' + Copy(LimpaNumero(FcBuildEXE), 1, 4) + ', 0, 2'); // Nome Completo da Automação Comercial  //Sandro Silva 2015-05-11 WriteLn(F,'701-000 = SMALL COMMERCE,  2014, 0, 2'); // Nome Completo da Automação Comercial
                WriteLn(F,'701-034 = 4');             // Capacidades da automação
                WriteLn(F,'706-000 = 2');             // Capacidades da automação
                WriteLn(F,'716-000 = ' + AnsiUpperCase(ConverteAcentos(RAZAO_SOCIAL_SOFTWARE_HOUSE_PAF))); // Razão Social da Empresa Responsável Pela Automação Comercial  // 2015-09-08 WriteLn(F,'716-000 = SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI'); // Razão Social da Empresa Responsável Pela Automação Comercial
                //
                sCerto1 := StrTran(TimeToStr(Time),':','');
                //
                //    WriteLn(F,'777-777 = TESTE REDECARD');                                                       // Teste 11 da REDECARD
                //
                WriteLn(F,'999-999 = 0');                                                       // Trailer - REgistro Final, constante '0' .
                CloseFile(F);
                RenameFile('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\IntPos.TMP','c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001');
                // ---------------------------------------- //
                for I := 1 to 12000 do
                begin
                  Application.ProcessMessages;
                  if not FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS') then
                    Sleep(10);
                end;

                ModalidadeTransacao := tModalidadeCartao; // Sandro Silva 2021-08-24
                //
                if FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS')  then
                begin
                  //
                  while not FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001') do
                  begin
                    //
                    bOk := True;
                    while bOk do
                    begin
                      Application.ProcessMessages;
                      Sleep(100);
                      // ----------------------------- //
                      // Verifica se é o arquivo certo //
                      // ----------------------------- //
                      if FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001') then
                      begin
                        //
                        AssignFile(F,'c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001');
                        Reset(F);
                        //
                        try
                          while not eof(F) Do
                          begin
                            ReadLn(F,cLinha);
                            cLinha := StrTran(cLinha,chr(0),' ');
                            if Copy(cLinha,1,7) = '001-000' then
                              sCerto := AllTrim(Copy(cLinha,10,Length(cLinha)-9));

                            if Copy(cLinha,1,3) = '999' then
                              bOk := False;
                          end;
                        finally
                          cLinha := EmptyStr;
                        end;
                        //
                        CloseFile(F);
                        Sleep(100);
                        //
                        if sCerto <> sCerto1 then
                        begin
                          DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001'));
                          bOk := True;
                          Sleep(1000);
                        end;

                      end;
                    end;
                  end;
                  //
                  sMensagem := '';
                  //
                  if FileExists('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001') then
                  begin
                    //
                    // Backup do intpos.001
                    //
                    CopyFile(pChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001'),pChar('c:\'+cCaminhoTEF+'.RES'), False); // bFailIfExists deve ser False para sobrescrever se existe

                    AssignFile(F,'c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001');
                    Reset(F);
                    //
                    FoDadosTransacao.FnQtdeParcela   := 0; // Sandro Silva 2016-07-26 SITEF não retorna quando Débito. Estava ficando as parcelas da transação anterior
                    FoDadosTransacao.ValorTot   := EmptyStr;
                    FoDadosTransacao.ValorSaque := EmptyStr;
                    FoDadosTransacao.NomeRede   := EmptyStr;
                    FoDadosTransacao.Transaca   := EmptyStr;
                    FoDadosTransacao.Autoriza   := EmptyStr;
                    FoDadosTransacao.Finaliza   := EmptyStr;

                    //
                    sCupom          := EmptyStr;
                    sCupom029       := EmptyStr;
                    sCupom710       := EmptyStr;
                    sCupom711       := EmptyStr;
                    sCupom712       := EmptyStr;
                    sCupom713       := EmptyStr;
                    sCupom714       := EmptyStr;
                    sCupom715       := EmptyStr;

                    sRespostaTef := EmptyStr; // Inicia vazia para capturar linhas da resposta do tef

                    while not Eof(f) Do
                    begin
                      ReadLn(F,cLinha);

                      sRespostaTef := sRespostaTef + #13 + cLinha; // Sandro Silva 2021-09-03

                      cLinha := StrTran(cLinha, chr(0),' ');
                      if Copy(cLinha,1,7) = '003-000' then
                        FoDadosTransacao.ValorTot  := StrTran(AllTrim(Copy(cLinha,10,Length(cLinha)-9)),',','');
                      if Copy(cLinha,1,7) = '200-000' then
                        FoDadosTransacao.ValorSaque := StrTran(AllTrim(Copy(cLinha,10,Length(cLinha)-9)),',','');
                      if Copy(cLinha,1,7) = '010-000' then
                        FoDadosTransacao.NomeRede   := AllTrim(Copy(cLinha,10,Length(cLinha)-9));
                      if Copy(cLinha,1,7) = '009-000' then
                        FoDadosTransacao.OkSim       := AllTrim(Copy(cLinha,10,Length(cLinha)-9));
                      if Copy(cLinha,1,7) = '012-000' then
                        FoDadosTransacao.Transaca   := RightStr(AllTrim(Copy(cLinha,10,Length(cLinha)-9)), 11); // Sandro Silva 2021-07-02 if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(cLinha,1,7) = '013-000' then
                        FoDadosTransacao.Autoriza   := AllTrim(Copy(cLinha,10,Length(cLinha)-9)); // Sandro Silva 2018-07-03
                      if Copy(cLinha,1,7) = '027-000' then
                        FoDadosTransacao.Finaliza   := AllTrim(Copy(cLinha,10,Length(cLinha)-9));
                      if Copy(cLinha,1,7) = '017-000' then
                        FoDadosTransacao.TipoParc   := AllTrim(Copy(cLinha,10,Length(cLinha)-9)); // 0: parcelado pelo Estabelecimento; 1: parcelado pela ADM.
                      if Copy(cLinha,1,7) = '018-000' then
                        FoDadosTransacao.QtdeParcela   := StrToInt(AllTrim(Copy(cLinha,10,Length(cLinha)-9)));
                      if Copy(cLinha,1,7) = '028-000' then
                        sBotaoOk          := AllTrim(Copy(cLinha,10,Length(cLinha)-9));
                      if Copy(cLinha,1,4) = '029-'    then
                        sCupom029         := sCupom029 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // Sandro Silva 2023-10-24 if Copy(Form1.sLinha,1,4) = '029-'    then sCupom029         := sCupom029 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10);
                      if Copy(cLinha,1,4) = '030-'    then
                        sMensagem         := sMensagem + StrTran(Copy(cLinha,11,Length(cLinha)-10),'"','');
                      if Copy(cLinha,1,7) = '040-000' then
                        FoDadosTransacao.Bandeira := StrTran(Copy(cLinha,11,Length(cLinha)-10),'"','');
                      if Copy(cLinha,1,7) = '709-000' then
                      begin
                        //
                        fDescontoNoPremio := StrToFloat(AllTrim(Copy(cLinha,10,Length(cLinha)-9))) / 100;

                        FoValoresTransacao.Receber := FoValoresTransacao.Receber - fDescontoNoPremio;
                        FoValoresTransacao.Pagar   := dValorPagarCartao - fDescontoNoPremio;
                        RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                      end;

                      if Copy(cLinha,1,7) = '210-081' then
                      begin
                        fDescontoNoPremio := FoValoresTransacao.Receber - StrToFloat(AllTrim(Copy(cLinha,10,Length(cLinha)-9)));
                        FoValoresTransacao.Receber    := FnValorCobrar - fDescontoNoPremio;
                        FoValoresTransacao.Pagar      := dTotalTransacionado; // Sandro Silva 2017-06-12  StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9))); // acertar aqui quando puder lançar cartões diferentes
                        RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                      end;

                      if Copy(cLinha,1,4) = '710-' then
                        sCupom710 := sCupom710 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // qtd linhas cupom reduzido
                      if Copy(cLinha,1,4) = '711-' then
                        sCupom711 := sCupom711 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // linhas cupom reduzido
                      if Copy(cLinha,1,4) = '712-' then
                        sCupom712 := sCupom712 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // qtd linhas comprovante destinada ao Cliente
                      if Copy(cLinha,1,4) = '713-' then
                        sCupom713 := sCupom713 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // linhas da via do Cliente,
                      if Copy(cLinha,1,4) = '714-' then
                        sCupom714 := sCupom714 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // qtd linhas comprovante destinada ao Estabelecimento
                      if Copy(cLinha,1,4) = '715-' then
                        sCupom715 := sCupom715 + DesconsideraLinhasEmBranco(Copy(cLinha,11,Length(cLinha)-10)); // linhas da via do Estabelecimento
                      {Sandro Silva 2023-10-24 fim}
                      //                               //
                      // Venda com pagamento no CARTAO //
                      //                               //
                    end; // while not Eof(f) Do
                    //
                    CloseFile(F);
                    //
                    if Pos('PIX', AnsiUpperCase(sRespostaTef)) > 0 then
                    begin
                      FoDadosTransacao.DebitoOuCredito := 'CREDITO';
                      ModalidadeTransacao := tModalidadePix;
                    end
                    else if Pos('CD_', AnsiUpperCase(sRespostaTef)) > 0 then
                    begin
                      FoDadosTransacao.DebitoOuCredito := 'CREDITO';
                      ModalidadeTransacao := tModalidadeCarteiraDigital;
                    end
                    else if (Pos('DEBIT', AnsiUpperCase(ConverteAcentos(sRespostaTef))) > 0) then
                    begin
                      FoDadosTransacao.DebitoOuCredito := 'DEBITO';
                      ModalidadeTransacao := tModalidadeCartao;
                    end
                    else
                    begin
                      FoDadosTransacao.DebitoOuCredito := 'CREDITO';
                      ModalidadeTransacao := tModalidadeCartao;
                    end;

                    //
                    // Quais vias serão impressas conforme fluxo
                    //

                    //
                    // sCupom é o que vai ser impresso
                    //
                    if AllTrim(sCupom710) <> '' then
                    begin
                      FoValoresTransacao.CupomTEFReduzido := FoValoresTransacao.CupomTEFReduzido + Chr(10) + sCupom711 + DupeString('-', 40); // Sandro Silva 2023-10-24 Form1.sCupomTEFReduzido := Form1.sCupomTEFReduzido + Chr(10) + sCupom711 + '     ' + DupeString('-', 40); // Sandro Silva 2017-06-14
                    end else
                    begin
                      if AllTrim(sCupom712) <> '' then
                        sCupom := sCupom713; // else sCupom := sCupom + chr(10) + chr(10) + chr(10) + chr(10) + chr(10) +  sCupom029;
                    end;
                    //
                    if AllTrim(sCupom714) <> '' then
                    begin
                      sCupom := sCupom + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + sCupom715; // Sandro Silva 2023-10-24 sCupom := sCupom + chr(10) + chr(10) + chr(10) + sCupom715;
                    end else
                    begin
                      sCupom := sCupom + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + sCupom029; // Sandro Silva 2023-10-24 sCupom := sCupom + chr(10) + chr(10) + chr(10) + sCupom029;
                    end;
                    //
                    if AllTrim(StrTran(sCupom,chr(10),'')) = '' then
                      sCupom := '';
                    //
                    //  SmallMsg(sCupom);
                    //
                    if FoDadosTransacao.ValorSaque <> '' then
                    begin
                      //
                      // Saque e troco no cartão
                      //
                      FoValoresTransacao.Acumulado3 := (StrToInt(Limpanumero(FoDadosTransacao.ValorSaque)) / 100);
                      FoValoresTransacao.Pagar       := FoValoresTransacao.Pagar + (StrToInt(Limpanumero(FoDadosTransacao.ValorSaque)) / 100);
                      RecuperaValoresFormasExtras;
                      //
                    end;
                    //
                    if (sMensagem = 'Cancelada pelo operador') and (FoDadosTransacao.OkSim='FF') then
                    begin
                      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001'));
                    end;
                    //
                    if allTrim(sMensagem) <> ''  then
                    begin
                      //
                      if AllTrim(sCupom) <> '' then
                      begin
                        //
                        if sBotaoOk = '0' then
                        begin
                          FoDadosTransacao.Mensagem := sMensagem;
                        end else
                        begin
                          FoDadosTransacao.Mensagem := sMensagem;

                          for I := 1 to 4 do //for I := 1 to 40 do
                          begin
                            Application.ProcessMessages;
                            Sleep(10);
                          end;
                          //
                        end;
                        //
                      end else
                      begin
                        //
                        for I := 1 to 200 do
                        begin
                          Application.ProcessMessages;
                          sleep(1);
                        end;
                        if allTrim(sMensagem) <> 'CHEQUE SEM RESTRICAO' then
                          FoDadosTransacao.Mensagem := sMensagem;
                      end;
                      if sBotaoOk = '0' then
                        Break;
                      if Pos('O CANCELADA', FoDadosTransacao.Mensagem) > 0 then
                        Break;
                      //
                    end;
                    //
                  end;
                end;

                if (FoDadosTransacao.NomeRede <> EmptyStr) and (sCupom <> EmptyStr) then
                begin
                  // Transação feita
                  //
                  //
                  Inc(iContaCartao); // Sandro Silva 2017-07-24

                  FoValoresTransacao.CupomTEF := FoValoresTransacao.CupomTEF + sCupom + DupeString('-', 40);

                  //
                  if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não
                  begin
                    FoTransacoesCartao.Transacoes.Adicionar(FoTEFSelecionado.Nome, FoDadosTransacao.DebitoOuCredito, dValorPagarCartao, FoDadosTransacao.NomeRede, FoDadosTransacao.Transaca, FoDadosTransacao.Autoriza, EmptyStr, ModalidadeTransacao);

                    nParcelas := 1;
                    //if (StrToInt('0'+AllTrim(Form1.sTipoParc)) = 0) and (StrToInt('0'+AllTrim(Form1.sParcelas)) > 1) then
                    //  Form1.iParcelas := StrtoInt('0'+AllTrim(Form1.sParcelas)); // Se parcelado pelo estabecimento cria

                    if (StrToIntDef(Trim(FoDadosTransacao.TipoParc), 0) = 0) and (FoDadosTransacao.QtdeParcela > 1) then
                      nParcelas := StrtoIntDef(Trim(FoDadosTransacao.TipoParc), 0); // Se parcelado pelo estabecimento cria mais de uma parcela no CONTAS a RECEBER
                    //
                    dTotalTransacaoTEF := 0.00;
                    for I := 1 to nParcelas do
                    begin
                      try
                        dValorDuplReceber := StrToFloat(FormatFloat('0.00', (Int(((StrtoInt(FoDadosTransacao.ValorTot)/100)/nParcelas) * 100) / 100))); // Sandro Silva 2018-04-25
                        iTotalParcelas := iTotalParcelas + 1;// Sandro Silva 2017-08-28 Acumula as parcelas entre os diferentes cartões usados para gerar as parcelas na sequência
                        dTotalTransacaoTEF := dTotalTransacaoTEF + dValorDuplReceber; // Sandro Silva 2017-08-29
                      except
                      end;
                    end; // for I := 1 to Form1.iParcelas do

                  end;
                  //
                  dTotalTransacionado        := dTotalTransacionado + (StrToIntDef(FoDadosTransacao.ValorTot, 0) / 100); // Sandro Silva 2017-06-12
                  FoDadosTransacao.TotalPago := FoDadosTransacao.TotalPago + dValorPagarCartao;

                  FoValoresTransacao.Pagar := dTotalTransacionado; // Sandro Silva 2017-06-14
                  RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                  Result := True;
                  //
                end else
                begin
                  // Transação Não feita
                  Result := False;
                  DeleteFile(pChar(DIRETORIO_BKP_TEF+'\'+cCaminhoTEF+IntToStr(iContaCartao + 1)+'.BKP'));
                  // Apaga arquivo de bkp não autorizados quando 2 gerenciadores diferentes
                  // Evitar que tente cancelar transação não confirmada. Ex.:  030-000 = Sitef fora do ar
                  DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001'));
                  DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS'));
                  DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\IntPos.tmp'));
                  DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001'));
                  DeleteFile(PWideChar('c:\'+cCaminhoTEF+'.res'));
                end; // if (Form1.sNomeRede <> '') and (sCupom <> '') then

                if Result then
                begin
                  if dTotalEmCartao - dTotalTransacionado > 0 then
                  begin
                    // Ainda há valor para transacionar com outros cartões

                    //Marcar para confirmar antes do próximo valor ser transacionado
                    bConfirmarTransacao := True;
                    //
                    // 2015-10-08 Sleep deixa muito tempo de intervalo entre a hora impressa e a DEMAIS.HORA Demais('CC');
                    //
                  end;
                end;
                //
              end; // if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
            end; // if bIniciarTEF then
          end; // if dValorPagarCartao = 0 then
        end; // if dTotalEmCartao < dTotalTransacionado then

      end; // while dTotalTransacionado < dTotalEmCartao do
    end; // if dTotalEmCartao = dTotalTransacionado then
  finally
    if cCaminhoTEF <> EmptyStr then
    begin
      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.001'));
      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS'));
      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\IntPos.tmp'));
      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'\'+FoTEFSelecionado.Req+'\INTPOS.001'));
      DeleteFile(PWideChar('c:\'+cCaminhoTEF+'.res'));
    end;
    FreeAndNil(FormasExtras); // Sandro Silva 2023-08-21
  end;

  if Result = True then
  begin
    FoValoresTransacao.CupomTEF := sCupomReduzidoAutorizado + FoValoresTransacao.CupomTEFReduzido + sCupomAutorizado + FoValoresTransacao.CupomTEF;
  end;
  // ---------------------------------------------- //
  // Transferência Eletrônica de Fundos (TEF)       //
  // Suporte Técnico Com - SevenPedv  (011)2531722  //
  // Suporte do PinPad - VeriFone (011)8228733      //
  // com Kiochi Matsuda                             //
  // (0xx11)253-1722                                //
  // ---------------------------------------------- //
end;

{ TValoresTransacao }

procedure TValoresTransacao.Clear;
begin
  FnValor01 := 0;
  FnValor02 := 0;
  FnValor03 := 0;
  FnValor04 := 0;
  FnValor05 := 0;
  FnValor06 := 0;
  FnValor07 := 0;
  FnValor08 := 0;
end;

constructor TValoresTransacao.Create;
begin
  Self.Clear;
end;

function TFuncoesTEF.TEFValorTotalAutorizado: Currency; // Sandro Silva 2017-06-14
var
  slArquivos: TStringList;
  sDirAtual: String;
  i: Integer;
  sArquivoTEF: String;
  sNomeArquivo: String;
  sNomeTEFAutorizacao: String;
  sDebitoOuCreditoAutorizado: String;
  bRespostaValidadosFiscal: Boolean; // Sandro Silva 2018-07-03
  ModalidadeTransacao: TTipoModalidadeTransacao; // Sandro Silva 2021-07-05
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  Result := 0.00;

  try
    ListaDeArquivos(slArquivos, DIRETORIO_BKP_TEF, '*.BKP');

    for I := 0 to slArquivos.Count -1 do
    begin
      sArquivoTEF := DIRETORIO_BKP_TEF + '\' + AllTrim(slArquivos[I]);
      //
      // Exemplo de nome de arquivo TEF_DIAL1.BKP, TEF_DIAL2.BKP
      // Último caractere do nome deve ser número maior ou igual a zero
      sNomeArquivo := StringReplace(AnsiUpperCase(ExtractFileName(sArquivoTEF)), '.BKP', '', [rfReplaceAll]);

      sNomeTEFAutorizacao := Copy(sNomeArquivo, 1, Length(sNomeArquivo) - Length(IntToStr(I)));

      sDebitoOuCreditoAutorizado := 'CREDITO';
      ModalidadeTransacao := tModalidadeCarteiraDigital; // Sandro Silva 2021-07-05
      with TStringList.Create do
      begin
        LoadFromFile(sArquivoTEF);
        if AnsiContainsText(AnsiUpperCase(ConverteAcentos(Text)), ' DEBIT') then // Sandro Silva 2021-08-03 if AnsiContainsText(AnsiUpperCase(Text), ' DEBIT') then
        begin
          sDebitoOuCreditoAutorizado := 'DEBITO';
          ModalidadeTransacao := tModalidadeCartao; // Sandro Silva 2021-07-05
        end;

        if AnsiContainsText(AnsiUpperCase(ConverteAcentos(Text)), ' CREDIT') then // Sandro Silva 2021-08-03 if AnsiContainsText(AnsiUpperCase(Text), ' CREDIT') then
        begin
          ModalidadeTransacao := tModalidadeCartao; // Sandro Silva 2021-07-05
        end;

        if AnsiContainsText(AnsiUpperCase(Text), 'PIX ') then
        begin
          ModalidadeTransacao := tModalidadePix; // Sandro Silva 2021-07-05
        end;

        Free;
      end;

      if StrToIntDef(Right(sNomeArquivo, Length(IntToStr(I))), -1) >= 0 then
      begin // Apenas arquivos dos primeiros cartões, não do último
        if AnsiUpperCase(CampoTEF(sArquivoTEF, '000-000')) = 'CRT' then
        begin
          if CampoTEF(sArquivoTEF, '009-000') = '0' then
          begin
            bRespostaValidadosFiscal := True;

            if bRespostaValidadosFiscal then
            begin
              Result := Result + TEFValorTransacao(sArquivoTEF);
              FoTransacoesCartao.Transacoes.Adicionar(sNomeTEFAutorizacao,
                                                      FoDadosTransacao.DebitoOuCredito,
                                                      TEFValorTransacao(sArquivoTEF),
                                                      CampoTEF(sArquivoTEF, '010-000'),
                                                      CampoTEF(sArquivoTEF, '012-000'),
                                                      CampoTEF(sArquivoTEF, '013-000'),
                                                      CampoTEF(sArquivoTEF,'010-000'),
                                                      ModalidadeTransacao);
            end;

          end;
        end;
      end;
    end;
  finally
    FreeAndNil(slArquivos);
  end;

  ChDir(sDirAtual);
end;

function TFuncoesTEF.TEFValorTransacao(sArquivoTEF: String): Currency;
begin
  Result := (StrToIntDef(LimpaNumero(CampoTEF(sArquivoTEF, '003-000')), 0) / 100);
end;

function TFuncoesTEF.CampoTEF(sArquivoTEF: String; sCampo: String): String;
var
  F: TextFile;
  Y: Integer;
  sLinha1: String;
begin
  Result := EmptyStr;
  if FileExists(sArquivoTEF) then
  begin
    try
      AssignFile(F,Pchar(sArquivoTEF));
      Reset(F);
      //
      for Y := 1 to 500 do
      begin
        ReadLn(F,sLinha1);
        sLinha1 := StrTran(sLinha1,chr(0),' ');
        if Copy(sLinha1, 1, Length(sCampo)) = sCampo then
        begin
          if Result <> '' then
            Result := Result + #10;
          Result := Result + StringReplace(Trim(Copy(sLinha1, 10, Length(sLinha1)-9)), '"', '', [rfReplaceAll]);
        end;
      end;
      //
      CloseFile(F);
    except
    end;
  end;
end;

procedure TFuncoesTEF.ConfirmaTransacao;
var
  F: TextFile;
begin
  AssignFile(F, ('c:\'+FoTEFSelecionado.Caminho+'\'+FoTEFSelecionado.Req+'\IntPos.tmp'));
  Rewrite(F);
  WriteLn(F,'000-000 = CNF');                               // Header: Cartão 3c
  WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
  // WriteLn(F,'003-000 = '+ Form1.sValorTot);              // Identificação: Eu uso o número do cupom 10c
  WriteLn(F,'010-000 = '+ FoDadosTransacao.NomeRede);       // Nome da rede:
  WriteLn(F,'012-000 = '+ FoDadosTransacao.Transaca);       // Número da transação NSU:
  WriteLn(F,'027-000 = '+ FoDadosTransacao.Finaliza);       // Finalização:
  AdicionaCNPJRequisicaoTEF(F, FcCNPJ);                     // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
  WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
  CloseFile(F);
  Sleep(1000);
  RenameFile('c:\'+FoTEFSelecionado.Caminho+'\'+FoTEFSelecionado.Req+'\IntPos.tmp',
             'c:\'+FoTEFSelecionado.Caminho+'\'+FoTEFSelecionado.Req+'\INTPOS.001');
  Sleep(6000);

  if FileExists('c:\'+FoTEFSelecionado.Caminho+'\'+FoTEFSelecionado.Resp+'\INTPOS.STS') then
    TEFDeletarCopiasArquivos;
end;

procedure TFuncoesTEF.TEFDeletarCopiasArquivos;
var
  slArquivos: TStringList;
  sDirAtual: String;
  i: Integer;
  sArquivo: String;
  sTipo: String;
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  try
    sTipo := '*.BKP';
    while sTipo <> '' do
    begin
      slArquivos.Clear;
      ListaDeArquivos(slArquivos, diretorio_bkp_tef, sTipo);

      for I := 0 to slArquivos.Count -1 do
      begin
        sArquivo := diretorio_bkp_tef + '\' + AllTrim(slArquivos[I]);

        DeleteFile(PChar(sArquivo));
      end;
      if sTipo = '*.BKP' then
        sTipo := '*.BKC'
      else
        sTipo := EmptyStr;
    end;
  finally
    FreeAndNil(slArquivos);
  end;

  ChDir(sDirAtual);
end;

function TFuncoesTEF.TEFTextoImpressaoCupomAutorizado(sCampo: String): String;
var
  slArquivos: TStringList;
  sDirAtual: String;
  i: Integer;
  sArquivoTEF: String;
  sNomeArquivo: String;
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  Result := EmptyStr;
  try
    ListaDeArquivos(slArquivos, DIRETORIO_BKP_TEF, '*.BKP');

    for I := 0 to slArquivos.Count -1 do
    begin
      sArquivoTEF := DIRETORIO_BKP_TEF + '\' + AllTrim(slArquivos[I]);
      //
      // Exemplo de nome de arquivo TEF_DIAL1.BKP, TEF_DIAL2.BKP
      // Último caractere do nome deve ser número maior ou igual a zero
      sNomeArquivo := StringReplace(AnsiUpperCase(ExtractFileName(sArquivoTEF)), '.BKP', '', [rfReplaceAll]);
      if StrToIntDef(Right(sNomeArquivo, 1), -1) >= 0 then
      begin // Apenas arquivos dos primeiros cartões, não do último
        if AnsiUpperCase(CampoTEF(sArquivoTEF, '000-000')) = 'CRT' then
        begin
          if CampoTEF(sArquivoTEF, '009-000') = '0' then
          begin
            if SuprimirLinhasEmBrancoDoComprovanteTEF then
            begin
              if Trim(CampoTEF(sArquivoTEF, sCampo)) <> '' then
                Result := Result + Trim(CampoTEF(sArquivoTEF, sCampo));
            end
            else
              Result := Result + Trim(CampoTEF(sArquivoTEF, sCampo));
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(slArquivos);
  end;

  ChDir(sDirAtual);
end;

function TFuncoesTEF.SuprimirLinhasEmBrancoDoComprovanteTEF: Boolean;
begin
  Result := True;
  //LerParametroIni(FRENTE_INI, SECAO_FRENTE_CAIXA, CHAVE_INI_SUPRIMIR_LINHAS_EM_BRANCO_DO_COMPROVANTE_TEF, _cNao) = _cSim;
end;

{ TDadosTransacao }

constructor TDadosTransacao.Create;
begin
  FnTotalPago := 0;
end;

procedure TFuncoesTEF.TEFLimparPastaRetorno(sDiretorioResposta: String);
begin
  DeleteFile(sDiretorioResposta+'\INTPOS.001');
  DeleteFile(sDiretorioResposta+'\INTPOS.STS');
end;

procedure TFuncoesTEF.ListaDeArquivos(var Lista: TStringList; sAtual: String; sExtensao: String = '*.txt');
var
  S : TSearchREc;
  I : Integer;
begin
  Lista.Clear;
  //
  I := FindFirst( sAtual + '\' + Trim(sExtensao), faAnyFile, S); // Sandro Silva 2024-01-22 I := FindFirst( PansiChar(sAtual + '\' + Trim(sExtensao)), faAnyFile, S);
  //
  while I = 0 do
  begin
    Lista.Add(S.Name);
    I := FindNext(S);
  end;
  //
  FindClose(S);
  //
end;

{ TPagamentoPDV }

procedure TPagamentoPDV.Clear;
begin
  FExtra4 := 0;
  FExtra7 := 0;
  FExtra6 := 0;
  FExtra5 := 0;
  FExtra1 := 0;
  FExtra2 := 0;
  FExtra8 := 0;
  FExtra3 := 0;
end;

end.
