unit ufuncoestef;

interface

uses
  Windows
  , Classes
  , Controls
  , ShellApi
  , FileCtrl
  , Forms
  , SysUtils
  , StrUtils
  , DB
  , IniFiles
  ;

procedure ValidaDiretorioTEF(sDirTef: String; sDirReq: String; sDirResp: String); // Sandro Silva 2020-08-20
function AtivaGeranciadorPadrao(p_diretorio, p_Req, p_Resp, p_Exec, NometefIni: String): Boolean;
function TEFMultiplosCartoes(bP1:Boolean): Boolean;
function CancelaTEFPendente(pP1, pP2, pP3, pP4, NomeTefIni: String): Boolean;
function FuncoesAdministrativas(pP1: Boolean): Boolean;
procedure TEFLimparPastaRetorno(sDiretorioResposta: String);
procedure TEFCancelarTransacoesDemaisCartoes(sPastaTEF: String;
  sPastaREQ: String; sPastaRESP: String); // Sandro Silva 2017-06-14
function CampoTEF(sArquivoTEF: String; sCampo: String): String;
function TEFImpressaoPendentePorTransacao(sCupom: String): Boolean;
procedure TEFAguardarRetornoStatus(sDiretorioResposta,
  sIdentificaTransacaoTEF: String);
function TEFTextoImpressaoCupomAutorizado(sCampo: String): String;
function TEFContaArquivos(sTipoComCaminho: String): Integer;
function TEFValorTotalAutorizado(): Currency;
function TEFValorTransacao(sArquivoTEF: String): Currency;
procedure TEFDeletarCopiasArquivos(FsDiretorio: String);
function TestarZPOSLiberado: Boolean;
function GetBinCartao(sArquivoTEF: String) : string;
function GetUltimosDigitosCartao(sArquivoTEF: String) : string;

implementation

uses
   SmallFunc_xe
  , ufuncoesfrente
  , fiscal
  , uclassetransacaocartao
  , unit10
//  , _Small_IntegradorFiscal
  , unit22
  , uajustaresolucao
  , uValidaRecursos
  , uTypesRecursos
  , uDialogs
  , Vcl.Dialogs
  ;
{Sandro Silva 2023-09-05 inicio
type
  TFormasExtras = class
  private
    FExtra1: Double;
    FExtra7: Double;
    FExtra4: Double;
    FExtra5: Double;
    FExtra6: Double;
    FExtra8: Double;
    FExtra2: Double;
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
  end;
}

procedure ValidaDiretorioTEF(sDirTef: String; sDirReq: String; sDirResp: String); // Sandro Silva 2020-08-20
begin
  // Cria as pastas de troca de mensagens com o TEF
  if DirectoryExists(sDirTef) = False then
    ForceDirectories(sDirTef);
  if DirectoryExists(sDirTef + '\' + sDirReq) = False then
    ForceDirectories(sDirTef + '\' + sDirReq);
  if DirectoryExists(sDirTef + '\' + sDirResp) = False then
    ForceDirectories(sDirTef + '\' + sDirResp);
end;

function AtivaGeranciadorPadrao(p_diretorio, p_Req, p_Resp, p_Exec, NometefIni: String): Boolean;
const MAX_TENTATIVA_ABRIR_TEF = 2;
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
    AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
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
      if iTentativa > MAX_TENTATIVA_ABRIR_TEF then
      begin
        Application.ProcessMessages;
        if Application.MessageBox(PChar('Não foi possível iniciar automaticamente o gerenciador padrão do TEF ' +  NomeTefIni + chr(10)+
                                        'Tentar iniciar novamente?'),
                                        'Operador', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = idNo then
        begin
          Application.MessageBox(PChar('Não foi possível iniciar automaticamente o gerenciador padrão do TEF ' + NomeTefIni + ' ' + p_diretorio),'Operador',mb_Ok + MB_ICONEXCLAMATION);
          Break;
        end;
      end;

      if FileExists(p_Exec) then
      begin
        if iTentativa > MAX_TENTATIVA_ABRIR_TEF then
          iTentativa := 1;

        if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then // Pos(TIPOMOBILE, sVendaImportando) > 0 then
        begin
          {Sandro Silva 2023-06-23 inicio
          Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar venda')
          }
          if Form1.sModeloECF_Reserva = '99' then
            Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar a movimentação')
          else
            Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar venda')
          {Sandro Silva 2023-06-23 fim}
        end
        else
        begin
          Application.ProcessMessages;
          Application.MessageBox(PChar('O gerenciador padrão do TEF ' + NomeTefIni + ' não está ativo'+chr(10)+'e será ativado automaticamente!' + Chr(10) + 'Tentativa ' + IntToStr(iTentativa) + ' de ' + IntToStr(MAX_TENTATIVA_ABRIR_TEF)),'Operador',mb_Ok + MB_ICONEXCLAMATION);
        end;

        try
          ChDir('c:\'+p_diretorio);
        except end;

        try

          ShellExecute(0, 'open', pChar(p_Exec), '', '', sw_normal);

        except end;
        //
        try
          CHDir(Form1.sAtual);
        except end;
        //
        Sleep(1000);
        //

        // TEF GetCard não elimina arquivos depois de processar
        DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\INTPOS.001')); // Sandro Silva 2020-05-29
        DeleteFile(pChar('c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP')); // Sandro Silva 2020-05-29


        AssignFile(F,'c:\'+p_diretorio+'\'+p_Req+'\IntPos.TMP');
        Rewrite(F);
        // ATV Verifica se o TEF está ativo
        WriteLn(F,'000-000 = ATV');                               // Header: Verifica se o gerenciador padrão está ativo.
        WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
        AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
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
      begin

        SmallMsgBox(PChar('O gerenciador padrão do TEF ' + NomeTefIni + ' não está ativo'+chr(10)+'e não foi possível ativá-lo automaticamente!'),'Operador',mb_Ok + MB_ICONEXCLAMATION);
        Form1.ClienteSmallMobile.EnviarLogParaMobile( // Sandro Silva 2022-08-08 EnviarLogParaMobile(
          Form1.ClienteSmallMobile.sLogRetornoMobile);
        Winexec('TASKKILL /F /IM frente.exe' , SW_HIDE ); Winexec('TASKKILL /F /IM nfce.exe' , SW_HIDE );
        FecharAplicacao(ExtractFileName(Application.ExeName));

      end;// if FileExists(p_Exec) then
      //
    end;// while not (FileExists('c:\'+p_diretorio+'\'+p_Resp+'\INTPOS.STS')) do

  end; // if FileExists(p_Exec) then
  //
  Hwnd := FindWindow ('TForm1', 'Programa Aplicativo Fiscal (PAF-ECF)');
  SetForegroundWindow(Hwnd);
  //
  Result := True;
  //
end;

// ---------------------------------------------- //
// Transferência Eletrônica de Fundos (TEF)       //
// Suporte Técnico Com - SevenPedv  (011)2531722  //
// Suporte do PinPad - VeriFone (011)8228733      //
// com Kiochi Matsuda                             //
// (0xx11)253-1722    1                            //
// ---------------------------------------------- //
function TEFMultiplosCartoes(bP1:Boolean): Boolean;
var
  I: Integer;
  F: TextFile;
  sBotaoOk, sCerto, sCerto1: String;
  bOk: Boolean;
  sMensagem: String;
  sCupom: String;
  //
  sCupom029,
  sCupom710,
  sCupom711,
  sCupom712,
  sCupom713,
  sCupom714,
  sCupom715: String;
  fDescontoNoPremio: Real;
  iContaCartao: Integer;
  dTotalEmCartao: Currency; // Double;
  dValorPagarCartao: Currency; // Double;
  dTotalTransacionado: Currency; // Double;
  //
  bIniciarTEF: Boolean; // Sandro Silva 2017-05-12
  bConfirmarTransacao: Boolean;
  sCupomReduzidoAutorizado: String;
  sCupomAutorizado: String;
  iTotalParcelas: Integer; // Sandro Silva 2017-08-28 Soma de todas as parcelas dos cartões usados
  dTotalTransacaoTEF: Double; // Sandro Silva 2017-08-29
  dValorDuplReceber: Currency; // Sandro Silva 2018-04-25
  ModalidadeTransacao: TTipoModalidadeTransacao; // Sandro Silva 2021-07-05
  sRespostaTef: String; // Para capturar linhas da resposta do tef
  FormasExtras: TPagamentoPDV; // Sandro Silva 2023-09-05 FormasExtras: TFormasExtras;
  nTEFElginPergunta: Integer;

  bTEFZPOS: Boolean;
  bTemElgin: Boolean;

  function TestarTEFSelecionado(AcNome: String): Boolean;
  var
    oFile: TIniFile;
  begin
    Result := False;
    oFile := TIniFile.Create('FRENTE.INI');
    try
      Result := (Pos(AnsiUpperCase(AcNome), AnsiUpperCase(oFile.ReadString('Frente de caixa','TEF USADO', EmptyStr))) > 0);
    finally
      FreeAndNil(oFile);
    end;
  end;

  procedure RecuperaValoresFormasExtras;
  begin
    // Quando transaciona mais que um cartão na mesma venda e informa valores nas formas extras,
    // esses valores da se perdem porque a rotina qua controla o que falta pagar joga a diferença do cartão para a forma dinheiro
    // Recupera os valores lançados nas formas extras
    Form1.ibDataSet25.FieldByName('VALOR01').AsFloat := FormasExtras.Extra1;
    Form1.ibDataSet25.FieldByName('VALOR02').AsFloat := FormasExtras.Extra2;
    Form1.ibDataSet25.FieldByName('VALOR03').AsFloat := FormasExtras.Extra3;
    Form1.ibDataSet25.FieldByName('VALOR04').AsFloat := FormasExtras.Extra4;
    Form1.ibDataSet25.FieldByName('VALOR05').AsFloat := FormasExtras.Extra5;
    Form1.ibDataSet25.FieldByName('VALOR06').AsFloat := FormasExtras.Extra6;
    Form1.ibDataSet25.FieldByName('VALOR07').AsFloat := FormasExtras.Extra7;
    Form1.ibDataSet25.FieldByName('VALOR08').AsFloat := FormasExtras.Extra8;
  end;
  {Sandro Silva 2023-10-24 inicio}
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
  {Sandro Silva 2023-10-24 fim}
  {Dailon Parisotto (f-17976) 2024-04-04 Inicio}
  function RetornoDoZPOS(AcCaminhoArq: String): Boolean;
  var
    slArq: TStringList;
  begin
    Result := False;

    slArq := TStringList.Create;
    try
      slArq.LoadFromFile(AcCaminhoArq);

      Result := (Pos('ZPOS', AnsiUpperCase(slArq.Text)) > 0);
    finally
      FreeAndNil(slArq)
    end;
  end;
  {Dailon Parisotto (f-17976) 2024-04-04 Fim}

begin
  //
  // Escolhe o TEF
  //
  Result := False; // Sandro Silva 2017-05-20
  bIniciarTEF := True;
  bTEFZPOS := False;

  {Sandro Silva 2023-08-21 inicio}
  FormasExtras := TPagamentoPDV.Create; // Sandro Silva 2023-09-05 FormasExtras := TFormasExtras.Create;// Sandro Silva 2023-08-21

  FormasExtras.Extra1 := Form1.ibDataSet25.FieldByName('VALOR01').AsFloat;
  FormasExtras.Extra2 := Form1.ibDataSet25.FieldByName('VALOR02').AsFloat;
  FormasExtras.Extra3 := Form1.ibDataSet25.FieldByName('VALOR03').AsFloat;
  FormasExtras.Extra4 := Form1.ibDataSet25.FieldByName('VALOR04').AsFloat;
  FormasExtras.Extra5 := Form1.ibDataSet25.FieldByName('VALOR05').AsFloat;
  FormasExtras.Extra6 := Form1.ibDataSet25.FieldByName('VALOR06').AsFloat;
  FormasExtras.Extra7 := Form1.ibDataSet25.FieldByName('VALOR07').AsFloat;
  FormasExtras.Extra8 := Form1.ibDataSet25.FieldByName('VALOR08').AsFloat;
  {Sandro Silva 2023-08-21 fim}

  dTotalEmCartao      := Form1.ibDataSet25.FieldByName('PAGAR').AsFloat;
  iContaCartao := 0;
  Form1.TransacoesCartao.Transacoes.Clear; // Sandro Silva 2017-08-29
  bConfirmarTransacao := False;

  dTotalTransacionado := TEFValorTotalAutorizado();

  sCupomReduzidoAutorizado := '';
  sCupomAutorizado         := '';

  iTotalParcelas := 0; // Sandro Silva 2017-08-28

  if dTotalTransacionado > 0 then
  begin
    sCupom710 := TEFTextoImpressaoCupomAutorizado('710-'); // Texto cupom reduzido
    if AllTrim(sCupom710) <> '' then
    begin
      sCupomReduzidoAutorizado := sCupomReduzidoAutorizado + Chr(10) + TEFTextoImpressaoCupomAutorizado('711-') + DupeString('-', 40); // Sandro Silva 2023-10-24 sCupomReduzidoAutorizado := sCupomReduzidoAutorizado + Chr(10) + TEFTextoImpressaoCupomAutorizado('711-') + '     ' + DupeString('-', 40);

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
      sCupomAutorizado := sCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('715-'); // Texto via estabelecimento // Sandro Silva 2023-10-24 sCupomAutorizado := sCupomAutorizado + chr(10) + chr(10) + chr(10) + TEFTextoImpressaoCupomAutorizado('715-'); // Texto via estabelecimento
    end else
    begin
      sCupomAutorizado := sCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('029-'); // Indica o status da confirmação da transação // Sandro Silva 2023-10-24 sCupomAutorizado := sCupomAutorizado + chr(10) + chr(10) + chr(10) + TEFTextoImpressaoCupomAutorizado('029-'); // Indica o status da confirmação da transação
    end;
    //
    if AllTrim(StrTran(sCupomAutorizado,chr(10),'')) = '' then
      sCupomAutorizado := '';
    {Sandro Silva 2023-10-24 inicio}
    if SuprimirLinhasEmBrancoDoComprovanteTEF then
    begin
      while AnsiContainsText(sCupomAutorizado, chr(10) + chr(10)) do
        sCupomAutorizado := StringReplace(sCupomAutorizado, chr(10) + chr(10), chr(10), [rfReplaceAll]);
    end;
    {Sandro Silva 2023-10-24 fim}

    Form1.fTEFPago := dTotalTransacionado; // Sandro Silva 2017-06-26
  end;// if dTotalTransacionado > 0 then

  if dTotalEmCartao = dTotalTransacionado then
  begin
    Result := True; // Sandro Silva 2017-06-23
  end
  else
  begin

    while dTotalTransacionado < dTotalEmCartao do // Enquanto não totalizar transações com valor devido
    begin

      dValorPagarCartao := dTotalEmCartao - dTotalTransacionado;

      if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes) then
      begin
        while True do
        begin
          Application.ProcessMessages; // Sandro Silva 2017-06-30
          dValorPagarCartao := StrToFloatDef(Form1.Small_InputBox(PAGAMENTO_EM_CARTAO,'Valor do ' + IntToStr(iContaCartao + 1) + 'º de ' + IntToStr(Form1.iNumeroMaximoDeCartoes) + ' cartões:', FormatFloat('0.00', dValorPagarCartao)), 0);

          dValorPagarCartao := StrToFloatDef(FormatFloat('0.00', dValorPagarCartao), 0); // Sandro Silva 2017-01-09 Arredonda para 2 casas o valor informado

          if dValorPagarCartao < 0 then
          begin
            Application.MessageBox(PChar('Valor inválido: ' + FormatFloat('0.00', dValorPagarCartao)), 'Atenção', MB_ICONWARNING + MB_OK);
            dValorPagarCartao := dTotalEmCartao - dTotalTransacionado;
          end
          else
          begin
            if Form1.bModoMultiplosCartoes then
            begin
              if dValorPagarCartao >= 0 then
                Break;
            end
            else
            begin

              if dValorPagarCartao <> dTotalEmCartao then
                Application.MessageBox(PChar(FormatFloat('0.00', dValorPagarCartao) + ' é diferente do valor (' + FormatFloat('0.00', dTotalEmCartao) + ') definido para forma de pagamento cartão' + #13 + #13 +
                                             'Acesse o Menu Configurações e ative o Modo Múltiplos Cartões para dividir o valor entre vários cartões'), 'Atenção', MB_ICONWARNING + MB_OK)
              else
                Break;

            end;
          end; // if dValorPagarCartao < 0 then
        end; // while True do
      end; // if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes) then

      if (dTotalEmCartao - (dTotalTransacionado + dValorPagarCartao)) < 0 then
      begin
        Application.MessageBox('Valor total da transação maior que o valor definido para a forma de pagamento cartão', 'Atenção', MB_ICONWARNING + MB_OK);
      end
      else // if (dTotalEmCartao - (dTotalTransacionado + dValorPagarCartao)) >= 0 then
      begin
        if dValorPagarCartao = 0 then
        begin
          //0 break
          Break;
        end
        else
        begin

          if bConfirmarTransacao then // Sandro Silva 2017-06-21
          begin // Confirma a transação do cartão anterior

            Form1.ExibePanelMensagem('Confirmando a transação do ' + IntToStr(iContaCartao) + 'º cartão', True); // Sandro Silva 2023-08-21 Form1.ExibePanelMensagem('Confirmando a transação do ' + IntToStr(iContaCartao) + 'º cartão'); // Sandro Silva 2017-06-22

            // Faz backup dos dados de autorização anterior
            CopyFile(pChar('c:\' + Form1.sDiretorio + '.RES'), pChar(DIRETORIO_BKP_TEF + '\' + Form1.sDiretorio + FormatFloat('00', TEFContaArquivos(DIRETORIO_BKP_TEF + '\' + Form1.sDiretorio +'*.BKP') + 1) + '.BKP'), False);

            // Confirmando a transação TEF
            AssignFile(F,Pchar('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.tmp'));
            Rewrite(F);
            WriteLn(F,'000-000 = CNF');                               // Header: Cartão 3c
            WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
            // WriteLn(F,'003-000 = '+ Form1.sValorTot);              // Identificação: Eu uso o número do cupom 10c
            WriteLn(F,'010-000 = '+ Form1.sNomeRede);                 // Nome da rede:
            WriteLn(F,'012-000 = '+ Form1.sTransaca);                 // Número da transação NSU:
            WriteLn(F,'027-000 = '+ Form1.sFinaliza);                 // Finalização:
            AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
            WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
            CloseFile(F);
            Sleep(1000);
            RenameFile(Pchar('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.tmp'),'c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
            Sleep(6000);

            Form1.OcultaPanelMensagem;

            //Precisa? TEFAguardarRetornoStatus() e validar .STS
          end;

          bConfirmarTransacao := False;

          fDescontoNoPremio := 0;
          //
          Form1.sDIRETORIO := '';
          Form10.TipoForm  := tfTEF; // Sandro Silva 2017-05-18
          {Sandro Silva 2022-06-24 inicio
          while AllTrim(Form1.sDIRETORIO) = '' do
            Form10.ShowModal;
          }
          while AllTrim(Form1.sDIRETORIO) = '' do
          begin
            if Form10.ListarTEFAtivos(True) = False then
            begin
              // Sandro Silva 2023-06-05
              Form10.ShowModal;                   //não conseguiu confirmar a transação, descontou do valor da venda seguinte
              //if Form10.ShowModal = mrCancel then
                Break;
            end;
          end;
          {Sandro Silva 2022-06-24 fim}

          {Sandro Silva 2023-06-14 inicio
          if Form1.UsaIntegradorFiscal() then
          begin

            Form1.IntegradorCE.SelecionarDadosAdquirente('FRENTE.INI', Form10.sNomeDoTEF, Form1.sUltimaAdquirenteUsada);
            bIniciarTEF := EnviarPagamentoValidadorFiscal('CARTAO TEF', Abs(dValorPagarCartao), FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, False);

          end;// if Form1.UsaIntegradorFiscal() then
          }

          //if Form10.ModalResult = mrCancel then
          //  bIniciarTEF := False;

          if bIniciarTEF then
          begin

            //
            // Escolhe a bandeira
            //
            if (Form1.ClienteSmallMobile.sVendaImportando = '') then
              Form1.Edit1.SetFocus;
            //
            // Ativa o gerenciador padão
            //
            AtivaGeranciadorPadrao(Form1.sDiretorio, Form1.sReq, Form1.sResp, Form1.sExec, '');
            //
            // Se não existe o arquivo INTPOS.STS na pasta RESP o gerenciador
            // não ativou atumaticamente e não esta ativo
            //
            if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
            begin

              if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then // Pos(TIPOMOBILE, Form1.ClienteSmallMobile.sVendaImportando) > 0 then
              begin
                {Sandro Silva 2023-06-23 inicio
                Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar venda')
                }
                if Form1.sModeloECF_Reserva = '99' then
                  Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar a movimentação')                
                else
                  Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar venda')
                {Sandro Silva 2023-06-23 fim}
              end
              else
              begin
                Application.ProcessMessages;
                Application.MessageBox('O gerenciador padrão do TEF não está ativo.','Operador',mb_Ok + MB_ICONEXCLAMATION);
              end;

              TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP); // Form1.TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP);
              DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
              DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');

              Result := False;

            end else
            begin

              //deletando quando reenviar nfce rejeitada
              //
              TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP); // Form1.TEFLimparPastaRetorno('c:\'+Form1.sDiretorio+'\'+Form1.sRESP);
              DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
              Sleep(100);
              // --------------------------------------------------------- //
              // CRT - Autorização para operação com cartão de crédito     //
              // --------------------------------------------------------- //
              AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP');
              Rewrite(F);
              //
              if (Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat <> 0) then  // and (UpperCase(sDIRETORIO) = 'TEF_DIAL')
              begin
                //
                //
                // Cheque 341029600100006505251087816289
                //
                //CHQ Pedido de autorização para transação por meio de cheque
                WriteLn(F,'000-000 = CHQ');
                WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat)]))));             // Valor Total: 12c
              end else
              begin
                // CRT Pedido de autorização para transação por meio de cartão

                {Dailon Parisotto (f-19886) 2024-07-19 Inicio

                WriteLn(F,'000-000 = CRT');                                                     // Header: Cartão 3c

                }

                nTEFElginPergunta := -1;
                bTemElgin := False;
                if (TestarTEFSelecionado('ELGIN')) then
                begin                               //      Cartão                        PIX
                  while (nTEFElginPergunta = -1) or ((nTEFElginPergunta <> 4) and (nTEFElginPergunta <> 12)) do
                    nTEFElginPergunta := MensagemSistemaPerguntaCustom('De que forma deseja finalizar o pagamento?', TMsgDlgType.mtConfirmation,[TMsgDlgBtn.mbAll,TMsgDlgBtn.mbRetry],['Cartão','PIX']);

                  bTemElgin := True;
                end;

                if (nTEFElginPergunta = 12) then
                  WriteLn(F,'000-000 = PIX')
                else
                  WriteLn(F,'000-000 = CRT');                                                     // Header: Cartão 3c
                {Dailon Parisotto (f-19886) 2024-07-19 Fim}
                WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(dValorPagarCartao)]))));             // Valor Total: 12c// Sandro Silva 2017-06-12  WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(Form1.ibDataSet25.FieldByName('PAGAR').AsFloat)]))));             // Valor Total: 12c
              end;
              //
              WriteLn(F,'004-000 = 0');             // Moeda: 0 - Real, 1 - Dolar americano
              WriteLn(F,'210-084 = SMALLSOF10');    // Nome da automação comercial (8 posições) + Capacidades da automação (1-preparada para tratar o desconto) + campo reservado, deve ser enviado 0
              AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
              WriteLn(F,'701-000 = SMALL COMMERCE,  ' + Copy(LimpaNumero(Form22.sBuild), 1, 4) + ', 0, 2'); // Nome Completo da Automação Comercial  //Sandro Silva 2015-05-11 WriteLn(F,'701-000 = SMALL COMMERCE,  2014, 0, 2'); // Nome Completo da Automação Comercial
              WriteLn(F,'701-034 = 4');             // Capacidades da automação
              WriteLn(F,'706-000 = 2');             // Capacidades da automação
              WriteLn(F,'716-000 = ' + AnsiUpperCase(ConverteAcentos(Form1.sRazaoSocialSmallsoft))); // Razão Social da Empresa Responsável Pela Automação Comercial  // 2015-09-08 WriteLn(F,'716-000 = SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI'); // Razão Social da Empresa Responsável Pela Automação Comercial
              //
              sCerto1 := StrTran(TimeToStr(Time),':','');
              //
              //    WriteLn(F,'777-777 = TESTE REDECARD');                                                       // Teste 11 da REDECARD
              //
              WriteLn(F,'999-999 = 0');                                                       // Trailer - REgistro Final, constante '0' .
              CloseFile(F);
              RenameFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP','c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
              // ---------------------------------------- //
              for I := 1 to 12000 do
              begin
                Application.ProcessMessages;
                if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
                  Sleep(10);
              end;
              //
              // teste anderson Center System
              //
              Form1.Top    := 0;
              Form1.Left   := 0;
              Form1.Width  := 1;
              Form1.Height := 1;

              ModalidadeTransacao := tModalidadeCartao; // Sandro Silva 2021-08-24
              //
              if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS')  then
              begin
                //
                while not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') do
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
                    if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
                    begin
                      //
                      AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
                      Reset(F);
                      //
                      while not eof(F) Do
                      begin
                        ReadLn(F,Form1.sLinha);
                        Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
                        if Copy(Form1.sLinha,1,7) = '001-000' then
                          sCerto := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));

                        if Copy(Form1.sLinha,1,3) = '999' then
                          bOk := False;
                      end;
                      //
                      CloseFile(F);
                      Sleep(100);
                      //
                      if sCerto <> sCerto1 then
                      begin
                        DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
                        bOk := True;
                        Sleep(1000);
                      end;

                    end; // if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
                    // ----------------------------- //
                    // Verifica se é o arquivo certo //
                    // ----------------------------- //
                  end; // while bOk do
                  ////////
                end;    // Teste // while not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') do
                /////////
                Form1.Repaint;
                //
                sMensagem := '';
                //
                if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
                begin
                  //
                  Form1.Top    := 0;
                  Form1.Left   := 0;
                  Form1.Width  := Screen.Width;
                  Form1.Height := Screen.Height;
                  //
                  // Backup do intpos.001
                  //
                  CopyFile(pChar('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001'),pChar('c:\'+Form1.sDiretorio+'.RES'), False); // bFailIfExists deve ser False para sobrescrever se existe

                  AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
                  Reset(F);
                  //
                  Form1.sParcelas   := '0'; // Sandro Silva 2016-07-26 SITEF não retorna quando Débito. Estava ficando as parcelas da transação anterior
                  Form1.sValorTot   := '';
                  Form1.sValorSaque := '';
                  Form1.sNomeRede   := '';
                  Form1.sTransaca   := '';
                  Form1.sAutoriza   := '';
                  Form1.sFinaliza   := '';
                  Form1.sLinha      := '';

                  //
                  sCupom          := '';
                  sCupom029       := '';
                  sCupom710       := '';
                  sCupom711       := '';
                  sCupom712       := '';
                  sCupom713       := '';
                  sCupom714       := '';
                  sCupom715       := '';

                  {Sandro Silva 2023-06-14 inicio
                  if Form1.UsaIntegradorFiscal then
                    Form1.IntegradorCE.TransacaoFinanceira.Resposta := '';
                  }

                  {Sandro Silva 2021-08-03 inicio
                  if LerParametroIni('FRENTE.INI', 'Frente de Caixa', 'Log BlocoX', '') = 'Sim' then
                    Sleep(6000); // Teste para poder capturar resposta do TEF e identificar caso do TEF GETPAY onde transação com cartão é classificada como carteira digital (só aconteceria se não houver texto "DEBIT " ou "CREDIT" na resposta do TEF, todos outros TEF retornar esses textos)
                  {Sandro Silva 2021-08-03 fim}

                  //
                  {Sandro Silva 2021-09-02 inicio}
                  sRespostaTef := ''; // Inicia vazia para capturar linhas da resposta do tef
                  {Sandro Silva 2021-09-02 fim}
                  //
                  bTEFZPOS := (RetornoDoZPOS('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001'));

                  if (not bTEFZPOS) or (TestarZPOSLiberado) then
                  begin
                    while not Eof(f) Do
                    begin
                      //
                      ReadLn(F,Form1.sLinha);

                      sRespostaTef := sRespostaTef + #13 + Form1.sLinha; // Sandro Silva 2021-09-03

                      {Sandro Silva 2023-06-14 inicio
                      if Form1.UsaIntegradorFiscal() then
                      begin
                        Form1.IntegradorCE.TransacaoFinanceira.Resposta := Form1.IntegradorCE.TransacaoFinanceira.Resposta + Form1.sLinha + #10;
                      end;
                      }

                      //
                      Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
                      if Copy(Form1.sLinha,1,7) = '003-000' then Form1.sValorTot   := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
                      if Copy(Form1.sLinha,1,7) = '200-000' then Form1.sValorSaque := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
                      if Copy(Form1.sLinha,1,7) = '010-000' then Form1.sNomeRede   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,7) = '009-000' then Form1.OkSim       := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca   := RightStr(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)), 11); // Sandro Silva 2021-07-02 if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,7) = '013-000' then Form1.sAutoriza   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)); // Sandro Silva 2018-07-03
                      if Copy(Form1.sLinha,1,7) = '027-000' then Form1.sFinaliza   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,7) = '017-000' then Form1.sTipoParc   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)); // 0: parcelado pelo Estabelecimento; 1: parcelado pela ADM.
                      if Copy(Form1.sLinha,1,7) = '018-000' then Form1.sParcelas   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,7) = '028-000' then sBotaoOk          := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                      if Copy(Form1.sLinha,1,4) = '029-'    then sCupom029         := sCupom029 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // Sandro Silva 2023-10-24 if Copy(Form1.sLinha,1,4) = '029-'    then sCupom029         := sCupom029 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10);
                      if Copy(Form1.sLinha,1,4) = '030-'    then sMensagem         := sMensagem + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','');

                      if Copy(Form1.sLinha,1,7) = '709-000' then
                      begin
                        fDescontoNoPremio := StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9))) / 100;
                        Form1.ibDataSet25.FieldByName('RECEBER').AsFloat    := Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - fDescontoNoPremio;
                        Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := dValorPagarCartao - Form1.fDescontoNoTotal - fDescontoNoPremio;// Sandro Silva 2017-06-12  Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := Form1.ibDataSet25.FieldByName('PAGAR').AsFloat - Form1.fDescontoNoTotal - fDescontoNoPremio;
                        RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                        //
                        Form1.ibDataSet27.Append; // Desconto
                        Form1.ibDataSet27.FieldByName('TIPO').AsString      := 'BALCAO';
                        Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := FormataNumeroDoCupom(Form1.icupom); // Sandro Silva 2021-11-29 StrZero(Form1.icupom,6,0);
                        Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Desconto'; // Desconto no cartão
                        Form1.ibDataSet27.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                        Form1.ibDataSet27.FieldByName('HORA').AsString      := Copy(Form1.sHoraDoCupom,7,2)+':'+Copy(Form1.sHoraDoCupom,9,2)+':'+Copy(Form1.sHoraDoCupom,11,2);
                        {Sandro Silva 2022-09-09 inicio}
                        if Form1.sModeloECF = '65' then
                          Form1.ibDataSet27.FieldByName('HORA').AsString      := FormatDateTime('HH:nn:ss', Time);
                        {Sandro Silva 2022-09-09 fim}
                        Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := 1;
                        Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat   := (Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - Form1.fTotal);
                        Form1.ibDataSet27.FieldByName('TOTAL').AsFloat      := TruncaDecimal(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat, Form1.iTrunca);
                        Form1.ibDataSet27.FieldByName('CAIXA').AsString     := Form1.sCaixa;
                        Form1.ibDataSet27.Post;

                        Form1.Memo1.Lines.Add('DESCONTO R$  '+Format('%10.2n',[Form1.fTotal - Form1.ibDataSet25.FieldByName('RECEBER').AsFloat]));
                      end;
                      //
                      if Copy(Form1.sLinha,1,7) = '210-081' then
                      begin
                        fDescontoNoPremio := Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)));
                        Form1.ibDataSet25.FieldByName('RECEBER').AsFloat    := Form1.fTotal - fDescontoNoPremio;
                        Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := dTotalTransacionado; // Sandro Silva 2017-06-12  StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9))); // acertar aqui quando puder lançar cartões diferentes
                        RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                        //
                        Form1.ibDataSet27.Append; // Desconto
                        Form1.ibDataSet27.FieldByName('TIPO').AsString      := 'BALCAO';
                        Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := FormataNumeroDoCupom(Form1.icupom); // Sandro Silva 2021-11-29 StrZero(Form1.icupom,6,0);
                        Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Desconto'; // Desconto no cartão
                        Form1.ibDataSet27.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                        Form1.ibDataSet27.FieldByName('HORA').AsString      := Copy(Form1.sHoraDoCupom,7,2)+':'+Copy(Form1.sHoraDoCupom,9,2)+':'+Copy(Form1.sHoraDoCupom,11,2);
                        {Sandro Silva 2022-09-09 inicio}
                        if Form1.sModeloECF = '65' then
                          Form1.ibDataSet27.FieldByName('HORA').AsString      := FormatDateTime('HH:nn:ss', Time);
                        {Sandro Silva 2022-09-09 fim}
                        Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := 1;
                        Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat   := (Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - Form1.fTotal);
                        Form1.ibDataSet27.FieldByName('TOTAL').AsFloat      := TruncaDecimal(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat, Form1.iTrunca);
                        Form1.ibDataSet27.FieldByName('CAIXA').AsString     := Form1.sCaixa;
                        Form1.ibDataSet27.Post;
                        //
                        Form1.Memo1.Lines.Add('DESCONTO R$  '+Format('%10.2n',[Form1.fTotal - Form1.ibDataSet25.FieldByName('RECEBER').AsFloat]));
                        //
                      end;
                      //
                      //
                      {Sandro Silva 2023-10-24 inicio
                      if Copy(Form1.sLinha,1,4) = '710-' then sCupom710 := sCupom710 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // qtd linhas cupom reduzido
                      if Copy(Form1.sLinha,1,4) = '711-' then sCupom711 := sCupom711 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // linhas cupom reduzido
                      if Copy(Form1.sLinha,1,4) = '712-' then sCupom712 := sCupom712 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // qtd linhas comprovante destinada ao Cliente
                      if Copy(Form1.sLinha,1,4) = '713-' then sCupom713 := sCupom713 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // linhas da via do Cliente,
                      if Copy(Form1.sLinha,1,4) = '714-' then sCupom714 := sCupom714 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // qtd linhas comprovante destinada ao Estabelecimento
                      if Copy(Form1.sLinha,1,4) = '715-' then sCupom715 := sCupom715 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10); // linhas da via do Estabelecimento
                      }
                      if Copy(Form1.sLinha,1,4) = '710-' then
                        sCupom710 := sCupom710 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // qtd linhas cupom reduzido
                      if Copy(Form1.sLinha,1,4) = '711-' then
                        sCupom711 := sCupom711 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // linhas cupom reduzido
                      if Copy(Form1.sLinha,1,4) = '712-' then
                        sCupom712 := sCupom712 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // qtd linhas comprovante destinada ao Cliente
                      if Copy(Form1.sLinha,1,4) = '713-' then
                        sCupom713 := sCupom713 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // linhas da via do Cliente,
                      if Copy(Form1.sLinha,1,4) = '714-' then
                        sCupom714 := sCupom714 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // qtd linhas comprovante destinada ao Estabelecimento
                      if Copy(Form1.sLinha,1,4) = '715-' then
                        sCupom715 := sCupom715 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // linhas da via do Estabelecimento
                      {Sandro Silva 2023-10-24 fim}
                      //                               //
                      // Venda com pagamento no CARTAO //
                      //                               //
                    end; // while not Eof(f) Do
                  end
                  else
                    sMensagem := 'Serial sem acesso à esse recurso. Entre em contato com sua revenda.';
                  //
                  CloseFile(F);
                  //
                  if Pos('PIX', AnsiUpperCase(sRespostaTef)) > 0 then
                  begin
                    Form1.sDebitoOuCredito := 'CREDITO';
                    ModalidadeTransacao := tModalidadePix;
                  end
                  else if Pos('CD_', AnsiUpperCase(sRespostaTef)) > 0 then
                  begin
                    Form1.sDebitoOuCredito := 'CREDITO';
                    ModalidadeTransacao := tModalidadeCarteiraDigital;
                  end
                  else if (Pos('DEBIT', AnsiUpperCase(ConverteAcentos(sRespostaTef))) > 0) then
                  begin
                    Form1.sDebitoOuCredito := 'DEBITO';
                    ModalidadeTransacao := tModalidadeCartao;
                  end
                  else
                  begin
                    Form1.sDebitoOuCredito := 'CREDITO';
                    ModalidadeTransacao := tModalidadeCartao;
                  end;
                  {Sandro Silva 2021-09-03 fim}

                  // Quais vias serão impressas conforme fluxo

                  // sCupom é o que vai ser impresso
                  if AllTrim(sCupom710) <> '' then
                  begin
                    Form1.sCupomTEFReduzido := Form1.sCupomTEFReduzido + Chr(10) + sCupom711 + DupeString('-', 40); // Sandro Silva 2023-10-24 Form1.sCupomTEFReduzido := Form1.sCupomTEFReduzido + Chr(10) + sCupom711 + '     ' + DupeString('-', 40); // Sandro Silva 2017-06-14
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

                  if Form1.sValorSaque <> '' then
                  begin
                    // Saque e troco no cartão
                    Form1.ibDataSet25.Edit;
                    Form1.bFlag2 := True; // TEFMultiplosCartoes(
                    Form1.ibDataSet25.FieldByName('ACUMULADO3').ReadOnly := False;
                    Form1.ibDataSet25.FieldByName('PAGAR').AsFloat       := Form1.ibDataSet25.FieldByName('PAGAR').AsFloat + (StrToInt(Limpanumero(Form1.sValorSaque)) / 100); // Acertar aqui quando aceitar mais de um cartão
                    Form1.ibDataSet25.FieldByName('ACUMULADO3').AsFloat  := (StrToInt(Limpanumero(Form1.sValorSaque)) / 100);
                    RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                    Form1.ibDataSet25.Post;
                    Form1.ibDataSet25.FieldByName('ACUMULADO3').ReadOnly := True;
                    Form1.bFlag2 := False; // TEFMultiplosCartoes(
                  end;
                  //
                  if (sMensagem = 'Cancelada pelo operador') and (Form1.OkSim='FF') then
                  begin
                    DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
                  end;
                  //
                  if allTrim(sMensagem) <> ''  then
                  begin
                    if AllTrim(sCupom) <> '' then
                    begin
                      if sBotaoOk = '0' then
                      begin
                        SmallMsgBox(pChar(sMensagem),'Operador',mb_Ok + MB_ICONEXCLAMATION);
                      end else
                      begin
                        Form1.ExibePanelMensagem(sMensagem);
                        //
                        // Simula 40 milissegundos
                        for I := 1 to 4 do //for I := 1 to 40 do
                        begin
                          Application.ProcessMessages;
                          Sleep(10); //Sleep(1);
                        end;
                      end;
                    end else
                    begin
                      for I := 1 to 200 do
                      begin
                        Application.ProcessMessages;
                        sleep(1);
                      end;
                      Form1.Repaint;
                      if allTrim(sMensagem) <> 'CHEQUE SEM RESTRICAO' then
                        SmallMsgBox(pChar(sMensagem),'Operador',mb_Ok + MB_ICONEXCLAMATION);
                      //
                    end;
                  end;
                end;
              end; // if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS')  then
              //
              if (Form1.sNomeRede <> '') and (sCupom <> '') then
              begin
                // Transação feita
                Inc(iContaCartao); // Sandro Silva 2017-07-24

                {Dailon Parisotto (f-19886) 2024-07-25 Inicio}
                if (bTemElgin) and (Form1.sCupomTEF <> EmptyStr) then
                  Form1.sCupomTEF := Form1.sCupomTEF + chr(10);
                if (bTemElgin) and (Form1.sCupomTEF = EmptyStr) then
                  Form1.sCupomTEF := chr(10) + Form1.sCupomTEF;
                {Dailon Parisotto (f-19886) 2024-07-25 Fim}
                Form1.sCupomTEF := Form1.sCupomTEF + sCupom + DupeString('-', 40); // Sandro Silva 2023-10-24 Form1.sCupomTEF := Form1.sCupomTEF + sCupom + '     ' + DupeString('-', 40); // Sandro Silva 2017-06-14

                if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não
                begin
                  if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Sandro Silva 2016-04-29
                  begin
                    if iContaCartao = 1 then // Quando for o primeiro cartão apaga todas as parcelas do cupom
                    begin
                      // Apaga as duplicatas anteriores
                      try
                        Form1.ibDataSet99.Close;
                        Form1.ibDataSet99.SelectSQL.Clear;
                        //
                        Form1.ibDataSet99.SelectSQL.Add('delete from RECEBER where NUMERONF='+QuotedStr(CupomComCaixaFormatado)+ ' and EMISSAO='+ QuotedStr(DateToStrInvertida(Date)) + ' ');
                        Form1.ibDataSet99.Open;
                      except
                        on E: Exception do
                        begin
                          SmallMsg('Erro! '+E.Message);
                        end;
                      end;
                    end;

                    Form1.TransacoesCartao.Transacoes.Adicionar(Form10.sNomeDoTEF,
                                                                Form1.sDebitoOuCredito,
                                                                dValorPagarCartao,
                                                                Form1.sNomeRede,
                                                                Form1.sTransaca,
                                                                Form1.sAutoriza,
                                                                '',
                                                                '',
                                                                Form1.IntegradorCE.TransacaoFinanceira.Tipo,
                                                                ModalidadeTransacao);

                    Form1.iParcelas := 1;

                    if (StrToIntDef(Trim(Form1.sTipoParc), 0) = 0) and (StrToIntDef(Trim(Form1.sParcelas), 0) > 1) then
                      Form1.iParcelas := StrtoIntDef(Trim(Form1.sParcelas), 0); // Se parcelado pelo estabecimento cria mais de uma parcela no CONTAS a RECEBER

                    dTotalTransacaoTEF := 0.00;
                    for I := 1 to Form1.iParcelas do
                    begin
                      try
                        dValorDuplReceber := StrToFloat(FormatFloat('0.00', (Int(((StrtoInt(Form1.sValorTot)/100)/Form1.iParcelas) * 100) / 100))); // Sandro Silva 2018-04-25
                        iTotalParcelas := iTotalParcelas + 1;// Sandro Silva 2017-08-28 Acumula as parcelas entre os diferentes cartões usados para gerar as parcelas na sequência

                        Form1.ibDataSet7.Append;
                        Form1.ibDataSet7.FieldByName('NOME').AsString         := Form1.sNomeRede;
                        Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' tran.' + Form1.sTransaca;
                        Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(iTotalParcelas);
                        Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := dValorDuplReceber;
                        Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := Date;
                        if AnsiContainsText(Form1.sDebitoOuCredito, 'CREDITO') then
                          Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoCredito * I)
                        else
                          Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoDebito * I);
                        Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form1.sNomeRede;
                        if ModalidadeTransacao in [tModalidadeCarteiraDigital, tModalidadePix] then
                        begin
                          if ModalidadeTransacao = tModalidadeCarteiraDigital then
                            Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRede + ' Cart.Digital', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                          if ModalidadeTransacao = tModalidadePix then
                            Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRede + ' Pagto.Instantaneo', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                          Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date;
                        end;
                        Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                        Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                        Form1.ibDataSet7.Post;
                        dTotalTransacaoTEF := dTotalTransacaoTEF + Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat; // Sandro Silva 2017-08-29
                      except
                      end;
                    end; // for I := 1 to Form1.iParcelas do

                    Form1.AjustarDiferencaParcelasCartao(dTotalTransacaoTEF, dValorPagarCartao, iTotalParcelas, Form1.iParcelas);

                  end; //
                end;
                //
                dTotalTransacionado    := dTotalTransacionado + (StrToIntDef(Form1.sValorTot, 0) / 100); // Sandro Silva 2017-06-12
                Form1.fTEFPago         := Form1.fTEFPago + dValorPagarCartao;
                Form1.fDescontoNoTotal := Form1.fDescontoNoTotal + fDescontoNoPremio;

                // Ajusta valor da diferença para receber em dinheiro
                if Form1.ibDataSet25.State in [dsEdit, dsInsert] = False then // Sandro Silva 2017-10-04
                  Form1.ibDataSet25.Edit; // Sandro Silva 2017-10-04
                Form1.ibDataSet25.FieldByName('PAGAR').AsFloat := dTotalTransacionado; // Sandro Silva 2017-06-14
                RecuperaValoresFormasExtras; // Sandro Silva 2023-08-21
                Result := True;
                //
              end else
              begin
                // Transação Não feita
                Result := False;
                DeleteFile(pChar(DIRETORIO_BKP_TEF+'\'+Form1.sDiretorio+IntToStr(iContaCartao + 1)+'.BKP'));
                // Apaga arquivo de bkp não autorizados quando 2 gerenciadores diferentes
                // Evitar que tente cancelar transação não confirmada. Ex.:  030-000 = Sitef fora do ar
                DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
                DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');
                DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.tmp');
                DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
                DeleteFile('c:\'+Form1.sDiretorio+'.res');
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

      if Form1.bModoMultiplosCartoes = False then
      begin
        Break;
      end;

      if (iContaCartao >= Form1.iNumeroMaximoDeCartoes) then
        Break;
      if (Form1.sModeloECF = '59') then
      begin
        // SAT permite apenas 10 grupos de meios de pagamento
        if iContaCartao >= 10 then
          Break;
      end;

    end; // while dTotalTransacionado < dTotalEmCartao do
  end; // if dTotalEmCartao = dTotalTransacionado then


  FreeAndNil(FormasExtras); // Sandro Silva 2023-08-21

  if Result = True then
  begin
    Form1.sCupomTEF := sCupomReduzidoAutorizado + Form1.sCupomTEFReduzido + sCupomAutorizado + Form1.sCupomTEF;

    // Ajuste para situação do TEF Elgin que pode ficar uma quebra linha no inicio.
    // Neste caso irá remover a quebra linha do inicio do arquivo caso exista.
    {Dailon Parisotto (f-19886) 2024-07-25 Inicio}
    if Pos(chr(10), Form1.sCupomTEF) = 1 then
      Form1.sCupomTEF := Copy(Form1.sCupomTEF, 2, Length(Form1.sCupomTEF));
    {Dailon Parisotto (f-19886) 2024-07-25 Fim}
  end;
  // ---------------------------------------------- //
  // Transferência Eletrônica de Fundos (TEF)       //
  // Suporte Técnico Com - SevenPedv  (011)2531722  //
  // Suporte do PinPad - VeriFone (011)8228733      //
  // com Kiochi Matsuda                             //
  // (0xx11)253-1722                                //
  // ---------------------------------------------- //
end;

function CancelaTEFPendente(pP1, pP2, pP3, pP4, NomeTefIni: String): Boolean;
var
  Mais1Ini: TIniFile;
  Y: Integer;
begin
  if Form1.sTef = 'Sim' then
  begin
    Result := True;
    //
    with Form1 do
    begin
      sREQ  := pP2;
      sRESP := pP3;
      //
      AtivaGeranciadorPadrao(pP1, pP2, pP3, pP4, NomeTefIni);
      //
      // backup do intpos.001
      if (FileExists(pChar('c:\'+pP1+'.res'))) and (not FileExists('c:\'+pP1+'\'+sRESP+'\INTPOS.001')) then
        CopyFile(pChar('c:\'+pP1+'.res'),pChar('c:\'+pP1+'\'+sRESP+'\INTPOS.001'), False);

      DeleteFile(pChar('c:\'+pP1+'.res'));
      //
      if FileExists('c:\'+pP1+'\'+sRESP+'\INTPOS.001') then
      begin
        //
        Result := True;
        AssignFile(F,Pchar('c:\'+pP1+'\'+sRESP+'\INTPOS.001'));
        Reset(F);
        //
        Form1.sValorTot := '';
        Form1.sNomeRede := '';
        Form1.sTransaca := '';
        Form1.sAutoriza := ''; // Sandro Silva 2018-07-03
        Form1.sIdentifi := '';
        //
        for Y := 1 to 500 do
        begin
          ReadLn(F,Form1.sLinha);
          Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
          if Copy(Form1.sLinha,1,7) = '003-000' then Form1.sValorTot := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
          if Copy(Form1.sLinha,1,7) = '010-000' then Form1.sNomeRede := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '001-000' then Form1.sIdentifi := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '013-000' then Form1.sAutoriza := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)); // Sandro Silva 2018-07-03
          if Copy(Form1.sLinha,1,7) = '027-000' then Form1.sFinaliza := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '009-000' then Form1.OkSim     := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
        end;
        //
        CloseFile(F);

        if (AllTrim(Form1.OkSim)='FF') then
        begin

          DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
          //
          // Cancelado pelo operador
          Form1.sValorTot := '';
          Form1.OkSim     := '';
          Form1.sNomeRede := '';
          Form1.sTransaca := '';
          Form1.sAutoriza := ''; // Sandro Silva 2018-07-03
          Form1.sFinaliza := '';
          Form1.sTipoParc := '';
          Form1.sParcelas := '';
        end else
        begin
          if (Form1.sNomeRede <> '') and (Form1.sTransaca <> '') then // Sandro Silva 2017-07-28
          begin
            if pP1 = 'CLIENT' then
            begin
              Mais1ini               := TIniFile.Create('FRENTE.INI');
              //
              if (Mais1Ini.ReadString('Frente de caixa','Queda','Sim') = 'Sim') then
              begin
                AssignFile(F,'c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                Rewrite(F);
                //NCN Não confirmação da venda e/ou da impressão.                
                WriteLn(F,'000-000 = NCN');                               // Header: Cartão 3c
                WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                //
                // WriteLn(F,'003-000 = '+ Form1.sValorTot);              // Identificação: Eu uso o número do cupom 10c
                //
                WriteLn(F,'010-000 = '+ Form1.sNomeRede);                 // Nome da rede:
                WriteLn(F,'012-000 = '+ Form1.sTransaca);                 // Número da transação NSU:
                WriteLn(F,'027-000 = '+ Form1.sFinaliza);                 // Finalização:
                AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
                CloseFile(F);
                RenameFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp','c:\'+pP1+'\'+sREQ+'\INTPOS.001');
                Sleep(10000);

                if AllTrim(Form1.sValorTot) = '' then
                begin
                  SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                     Chr(10)+
                                     // Chr(10)+'Rede: '+Form1.sNomeRede+
                                     Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
                end else
                begin
                  SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                     Chr(10)+
                                     // Chr(10)+'Rede: '+Form1.sNomeRede+
                                     Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
                end;

                DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.001');
                DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.STS');
                DeleteFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
              end else
              begin
                if Form1.sFinaliza <> '' then
                begin
                  DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.001');
                  DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.STS');
                  DeleteFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                  DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
                  //
                  AtivaGeranciadorPadrao(pP1, pP2, pP3, pP4, NomeTefIni);
                  Sleep(6000);
                  //
                  //Confirmando a transação TEF
                  AssignFile(F,'c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                  Rewrite(F);
                  WriteLn(F,'000-000 = CNF');                 // Header: Cartão 3c
                  WriteLn(F,'001-000 = '+ Form1.sIdentifi);   // Identificação: Eu uso a hora
                  WriteLn(F,'010-000 = '+ Form1.sNomeRede);   // Nome da rede:
                  WriteLn(F,'012-000 = '+ Form1.sTransaca);   // Número da transação NSU:
                  WriteLn(F,'027-000 = '+ Form1.sFinaliza);   // Finalização:
                  AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                  WriteLn(F,'999-999 = 0');                   // Trailer - REgistro Final, constante '0' .
                  CloseFile(F);
                  Sleep(1000);
                  RenameFile(Pchar('c:\'+pP1+'\'+sREQ+'\IntPos.tmp'),'c:\'+pP1+'\'+sREQ+'\INTPOS.001');
                  Sleep(5000);
                  //
                  // Demais('CC');
                  //
                  if Length(AllTrim(Form1.sTransaca)) < 9 then
                  begin
                    SmallMsgBox(pChar('Transação TEF efetuada. Favor reimprimir os cupons.'+
                                       Chr(10)+
                                       // Chr(10)+'Rede: '+Form1.sNomeRede+
                                       Chr(10)+'NSU: '+Form1.sTransaca),'Atenção',mb_Ok + MB_ICONERROR);
                  end else
                  begin
                    SmallMsgBox(pChar('Transação TEF efetuada. Favor reimprimir os cupons.'+
                                       Chr(10)+
                                       // Chr(10)+'Rede: '+Form1.sNomeRede+
                                       Chr(10)+'NSU: '+Form1.sTransaca+chr(10)+chr(13)+'OBS.: PARA REDE CIELO UTILIZAR OS 6 ULTIMOS DIGITOS DO NSU.'),'Atenção',mb_Ok + MB_ICONERROR);
                  end;
                  //
                end else
                begin
                  //
                  // Ronei TEF2011
                  //
                  AssignFile(F,'c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                  Rewrite(F);
                  //NCN Não confirmação da venda e/ou da impressão.                  
                  WriteLn(F,'000-000 = NCN');                               // Header: Cartão 3c
                  WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                  //
                  // WriteLn(F,'003-000 = '+ Form1.sValorTot);              // Identificação: Eu uso o número do cupom 10c
                  //
                  WriteLn(F,'010-000 = '+ Form1.sNomeRede);                 // Nome da rede:
                  WriteLn(F,'012-000 = '+ Form1.sTransaca);                 // Número da transação NSU:
                  WriteLn(F,'027-000 = '+ Form1.sFinaliza);                 // Finalização:
                  AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                  WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
                  CloseFile(F);
                  RenameFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp','c:\'+pP1+'\'+sREQ+'\INTPOS.001');
                  Sleep(10000);
                  //
                  // Ronei TEF2011
                  //
                  if AllTrim(Form1.sValorTot) = '' then
                  begin
                    //
                    // SmallMsg(Form1.OkSim);
                    //
                    SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                       Chr(10)+
                                       // Chr(10)+'Rede: '+Form1.sNomeRede+
                                       Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
                  end else
                  begin
                    SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                       Chr(10)+
                                       // Chr(10)+'Rede: '+Form1.sNomeRede+
                                       Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
                  end;
                  //
                  // Ronei TEF2011
                  //
                  //            Application.MessageBox(pChar('Erro na impressão do cupom TEF.'+Chr(10)+'A transação TEF não foi concluída. '),'Atenção',mb_Ok + MB_ICONERROR);
                  //
                  DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.001');
                  DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.STS');
                  DeleteFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
                  DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
                  //
                end;
              end;
              //
              Mais1ini.Free;
              //
            end else
            begin
              //
              // Ronei TEF2011
              //
              AssignFile(F,'c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
              Rewrite(F);
              WriteLn(F,'000-000 = NCN');                              // Header: Cartão 3c
              WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':','')); // Identificação: Eu uso a hora
              //
              // WriteLn(F,'003-000 = '+ Form1.sValorTot);             // Identificação: Eu uso o número do cupom 10c
              //
              WriteLn(F,'010-000 = '+ Form1.sNomeRede);                // Nome da rede:
              WriteLn(F,'012-000 = '+ Form1.sTransaca);                // Número da transação NSU:
              WriteLn(F,'027-000 = '+ Form1.sFinaliza);                // Finalização:
              AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
              WriteLn(F,'999-999 = 0');                                // Trailer - REgistro Final, constante '0' .
              CloseFile(F);
              RenameFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp','c:\'+pP1+'\'+sREQ+'\INTPOS.001');
              Sleep(10000);
              //
              // Ronei TEF2011
              //
              if AllTrim(Form1.sValorTot) = '' then
              begin
                //
                // SmallMsg(Form1.OkSim);
                //
                SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                  Chr(10)+
                                  // Chr(10)+'Rede: '+Form1.sNomeRede+
                                  Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
              end else
              begin
                SmallMsgBox(pChar('Última transação TEF não foi efetuada. Favor reter o cupom.'+
                                   Chr(10)+
                                   // Chr(10)+'Rede: '+Form1.sNomeRede+
                                   Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
              end;
              //
              // Ronei TEF2011
              //
              //            Application.MessageBox(pChar('Erro na impressão do cupom TEF.'+Chr(10)+'A transação TEF não foi concluída. '),'Atenção',mb_Ok + MB_ICONERROR);
              //
              DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.001');
              DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.STS');
              DeleteFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
              DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
              //
            end; // if pP1 = 'CLIENT' then
          end
          else
          begin

            // Não retornou número transação e nome da rede
            // Exclui arquivos
            DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.001');
            DeleteFile('c:\'+pP1+'\'+sRESP+'\INTPOS.STS');
            DeleteFile('c:\'+pP1+'\'+sREQ+'\IntPos.tmp');
            DeleteFile('c:\'+pP1+'\'+sREQ+'\INTPOS.001');
          end; // if (Form1.sNomeRede <> '') and (Form1.sTransaca <> '') then // Sandro Silva 2017-07-28
        end; // if (AllTrim(Form1.OkSim)='FF') then
      end; // if FileExists('c:\'+pP1+'\'+sRESP+'\INTPOS.001') then
    end;  // with Form1 do
    //

  end else Result := True;
  //
  Form1.Top    := 0;
  Form1.Left   := 0;
  Form1.Width  := Screen.Width;
  Form1.Height := Screen.Height;
  //
end;

function FuncoesAdministrativas(pP1: Boolean): Boolean;
var
  I : Integer;
  bSAir : Boolean;
  sCerto1,  sMensagem : String;
  //bRetornoComando: Boolean; //2015-10-06
begin
  Result := True; // Sandro Silva 2018-08-29
  //
  Form1.bNaoSaiComESC := True;
  //
  Form1.sDiretorio := '';
  Form10.TipoForm  := tfTEF; // Sandro Silva 2017-05-18
  if Form1.touch_F9.Visible then
  begin
    Form10.FuncoesAdmTEF    := True; // Sandro Silva 2017-11-07 Polimig
    Form10.pnBotoes.Visible := True; // Sandro Silva 2017-11-07 Polimig
    Form10.btnMais.Visible  := False; // Sandro Silva 2017-11-07 Polimig
    Form10.btnMenos.Visible := False; // Sandro Silva 2017-11-07 Polimig
    Form10.Button3.Caption  := 'Menu Fiscal'; // Sandro Silva 2017-11-07 Polimig
    Form10.Button3.Width    := AjustaLargura(120); // Sandro Silva 2021-09-21 Form10.Button3.Width   := 120; // Sandro Silva 2017-11-07 Polimig
    Form10.Button3.Left     := AjustaLargura(207) - AjustaLargura(45); // Sandro Silva 2021-09-21 Form10.Button3.Left    := 207 - 45; // Sandro Silva 2017-11-07 Polimig
  end;

  while AllTrim(Form1.sDIRETORIO) = '' do
  begin
    if Form10.ListarTEFAtivos(True) = False then
    begin
      Form10.ShowModal;
    end;
  end;

  Form10.btnMais.Visible  := True; // Sandro Silva 2017-11-07 Polimig
  Form10.btnMenos.Visible := True; // Sandro Silva 2017-11-07 Polimig
  Form10.Button3.Caption  := 'Ok'; // Sandro Silva 2017-11-07 Polimig
  Form10.Button3.Width    := AjustaLargura(75); // Sandro Silva 2021-09-21 Form10.Button3.Width   := 75; // Sandro Silva 2017-11-07 Polimig
  Form10.Button3.Left     := AjustaLargura(207); // Sandro Silva 2021-09-21 Form10.Button3.Left    := 207; // Sandro Silva 2017-11-07 Polimig

  Form10.pnBotoes.Visible := False; // Sandro Silva 2021-11-11

  if Form10.bMenuFiscal then
  begin
    if Form1.touch_F9.Visible then
      Form1.touch_F9Click(Form1.touch_F9);// Sandro Silva 2017-11-07 Polimig
  end
  else
  begin
  //
    with Form1 do
    begin
      //
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.STS');
      //
      AtivaGeranciadorPadrao(Form1.sDiretorio, Form1.sReq, Form1.sResp, Form1.sExec, '');
      //
      try
        //
        AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP');
        Rewrite(F);
        // ADM Permite o acionamento do Cliente para execução das funções administrativas.
        WriteLn(F,'000-000 = ADM');                               // Header: Funcoes Administrativas
        WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
        //
        WriteLn(F,'004-000 = 0');             // Moeda: 0 - Real, 1 - Dolar americano
        //    WriteLn(F,'210-084 = SMALLSOF10');    // Capacidades da automação
        AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
        WriteLn(F,'701-000 = SMALL COMMERCE,  ' + Copy(LimpaNumero(Form22.sBuild), 1, 4) + ', 0, 2'); // Nome Completo da Automação Comercial // 2015-09-08 WriteLn(F,'701-000 = SMALL COMMERCE,  2014, 0, 2'); // Nome Completo da Automação Comercial
        //    WriteLn(F,'701-034 = 4');             // Capacidades da automação
        WriteLn(F,'706-000 = 2');             // Capacidades da automação
        // 2015-09-08 WriteLn(F,'716-000 = SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI'); // Razão Social da Empresa Responsável Pela Automação Comercial
        WriteLn(F,'716-000 = ' + AnsiUpperCase(ConverteAcentos(Form1.sRazaoSocialSmallsoft))); // Razão Social da Empresa Responsável Pela Automação Comercial
        sCerto1 := StrTran(TimeToStr(Time),':','');
        //
        WriteLn(F,'999-999 = 0');                                 // Trailer - Registro Final, constante '0' .
        CloseFile(F);
        //
      except
        SmallMsg('O '+Form1.sDiretorio+ ' não está instalado.');
        Abort;
      end;
      //
      RenameFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP','c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
      //
      Form1.Top    := 0;
      Form1.Left   := 0;
      Form1.Width  := 1;
      Form1.Height := 1;
      Form1.Repaint;
      //
      for I := 0 to 4 do
      begin
        if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
          Sleep(1000);
      end;
      //
      while not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') do
      begin
        Sleep(10);
        Application.ProcessMessages;
        // ----------------------------- //
        // Verifica se é o arquivo certo //
        // ----------------------------- //
        if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
        begin
          Sleep(1000);
          AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
          Reset(F);
          for I := 1 to 5 do
          begin
            ReadLn(F,Form1.sLinha);
            Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
            if Copy(Form1.sLinha,1,7) = '001-000' then
            begin
              if AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)) <> sCerto1 then
              begin
                DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
                Sleep(1000);
              end;
            end;
          end;
          CloseFile(F);
        end;
        // ----------------------------- //
        // Verifica se é o arquivo certo //
        // ----------------------------- //
      end;
      //
      Form1.sParcelas := '0';
      Form1.sValorTot := '';
      Form1.sNomeRede := '';
      Form1.sTransaca := '';
      Form1.sAutoriza := ''; // Sandro Silva 2018-07-03
      Form1.sFinaliza := '';
      Form1.sLinha    := '';
      //
      Form1.sCupomTEFReduzido := ''; // Sandro Silva 2017-06-14
      Form1.sCupomTEF := ''; // ADM
      sMensagem       := '';
      Form1.OkSim     := '';
      //
      if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
      begin
        AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
        Reset(F);
        //
        for I := 1 to 500 do
        begin
          //
          Form1.sLinha := '';
          ReadLn(F,Form1.sLinha);
          Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
          //
          if Copy(Form1.sLinha,1,7) = '003-000' then Form1.sValorTot := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
          if Copy(Form1.sLinha,1,7) = '009-000' then Form1.OkSim     := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '010-000' then Form1.sNomeRede := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '013-000' then Form1.sAutoriza := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)); // Sandro Silva 2018-07-03
          if Copy(Form1.sLinha,1,7) = '027-000' then Form1.sFinaliza := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '017-000' then Form1.sTipoParc := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,7) = '018-000' then Form1.sParcelas := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
          if Copy(Form1.sLinha,1,4) = '029-'    then Form1.sCupomTef := Form1.sCupomTef + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10);
          if Copy(Form1.sLinha,1,4) = '030-'    then sMensagem := StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','');
          //                         //
          // Funcões Administrativas //
          //                         //
        end;
        //
        CloseFile(F);

        if (sMensagem = 'Cancelada pelo operador') and (AllTrim(Form1.OkSim)='FF') then
        begin
          DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');

          // Cancelado pelo operador
          Form1.sValorTot := '';
          Form1.OkSim     := '';
          Form1.sNomeRede := '';
          Form1.sTransaca := '';
          Form1.sAutoriza := ''; // Sandro Silva 2018-07-03
          Form1.sFinaliza := '';
          Form1.sTipoParc := '';
          Form1.sParcelas := '';
          Form1.sCupomTEF := ''; // ADM
          Form1.sCupomTEFReduzido := ''; // Sandro Silva 2017-06-14
          sMensagem       := '';
        end else
        begin
          Form1.Top    := 0;
          Form1.Left   := 0;
          Form1.Width  := Screen.Width;
          Form1.Height := Screen.Height;
          Form1.Repaint;
          //
          if AllTrim(Form1.sCupomTef) <> '' then
          begin
            Panel3.Font.Size := 10;
            //
            if Length(sMensagem) > 20 then
            begin
              Panel3.Font.Size := 10;
            end else
            begin
              Panel3.Font.Size := 14;
            end;
            //
            Form1.ExibePanelMensagem(sMensagem);

            for I := 1 to 100 do
            begin
              Application.ProcessMessages;
              sleep(1);
            end;
            //
          end else
          begin
            for I := 1 to 200 do
            begin
              if (I = 15) then
              begin
                Form1.Top    := 0;
                Form1.Left   := 0;
                Form1.Width  := Screen.Width;
                Form1.Height := Screen.Height;
                Form1.Repaint;
              end;
              Application.ProcessMessages;
              sleep(1);
            end;
          end;
          //
          if (allTrim(sMensagem) <> '') and (AllTrim(Form1.sCupomTef) = '')  then
          begin
            SmallMsgBox(pChar(sMensagem),'Operador',mb_Ok + MB_ICONEXCLAMATION);
          end;
          //
          if AllTrim(Form1.sCupomTef) <> '' then
          begin
            bChave := False;
            bSair  := False;
            try
              while (not bChave) and (not bSair) do
              begin
                Panel3.Repaint;
                Application.ProcessMessages;

                Sleep(100);
                //
                Form1.PDV_FechaCupom2(True);

                // Funcões Administrativas //
                // if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(True);   // Disable Keyboard & mouse
                //
                bChave := PDV_ImpressaoNaoSujeitoaoICMS(sCupomTef);
                //
                // sleep(1000);
                //
                if bChave then // 2015-10-06
                  Demais('RG');
                //
                if not bChave then
                begin
                  //
                  // 2015-09-08 if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(False);  // Enable  Keyboard & mouse
                  bButton := SmallMsgBox(pChar('Impressora não responde.'+Chr(10)
                                                +Chr(10)
                                                +'Tentar novamente?'+chr(10)
                                                +Chr(10)
                                                 ),'Atenção (Funções Administrativas)', mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
                  if bButton = IDYES then
                  begin
                    sleep(5000);
                    //
                    Form1.PDV_FechaCupom2(True);
                    //
                    Sleep(2000);
                  end;
                  if bButton <> IDYES then
                    bSair := True;
                end;
              end; // while (not bChave) and (not bSair) do
            finally
            end;

            AtivaGeranciadorPadrao(Form1.sDiretorio, Form1.sReq, Form1.sResp, Form1.sExec, '');
            //
            if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
            begin
              if AllTrim(Form1.OkSim) = '0' then // Ronei Mudei aqui
              begin
                AssignFile(F,'c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP');
                Rewrite(F);
                //
                if bChave = True then
                begin
                  //NCN Não confirmação da venda e/ou da impressão.
                  WriteLn(F,'000-000 = NCN'); // Alterei a orderm em na homologação do modular 2012
                  // WriteLn(F,'000-000 = CNF'); // Alterei a orderm em na homologação do modular 2012 // // FERNANDA Pediu para mandar CNF na homologação remota em 2 0 1 3
                end else
                begin
                  //Confirmando a transação TEF
                  WriteLn(F,'000-000 = CNF'); // Alterei a orderm em na homologação do modular 2012
                end;
                //
                Form1.Repaint;
                //
                WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                WriteLn(F,'010-000 = '+sNomeRede);                        // Nome da rede:
                WriteLn(F,'012-000 = '+sTransaca);                        // Número da transação NSU:
                WriteLn(F,'027-000 = '+sFinaliza);                        // Finalização:
                AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
                CloseFile(F);
                Sleep(100); // Sandro Silva 2017-06-14
                RenameFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.TMP','c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\INTPOS.001');
                Sleep(1000); // Sandro Silva 2017-06-22
                //
                if bChave = False then// Sandro Silva 2017-06-28  if not bChave = True then
                begin
                  Sleep(300);
                  // Alterei a mensagem e antes deve criar o arquivo na homologação do modular 2012

                  SmallMsgBox(pChar('Transação TEF não foi efetuada. Favor reter o cupom.'+
                                     Chr(10)+
                                     // Chr(10)+'Rede: '+Form1.sNomeRede+
                                     Chr(10)+'NSU: '+Form1.sTransaca),'Atenção!',mb_Ok + MB_ICONERROR);
                end;

              end; // if AllTrim(Form1.OkSim) = '0' then // Ronei Mudei aqui
              //
            end else
            begin
              SmallMsgBox('O gerenciador padrão do TEF não está ativo. Cod: 999 111','Operador',mb_Ok + MB_ICONEXCLAMATION);
            end;
            //
          end; // if AllTrim(Form1.sCupomTef) <> '' then
        end; //if (sMensagem = 'Cancelada pelo operador') and (AllTrim(Form1.OkSim)='FF') then
      end; // if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
      //
      Sleep(300);
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS');
      DeleteFile('c:\'+Form1.sDiretorio+'\'+Form1.sREQ+'\IntPos.tmp');

      Panel3.Visible  := False;
      Panel3.Caption  := '';
      lblMensagemAlerta.Caption := ''; // Sandro Silva 2017-04-04
      Form1.Repaint;
      Result := True;
      //
    end; // with Form1 do
    //
    Form1.Top    := 0;
    Form1.Left   := 0;
    Form1.Width  := Screen.Width;
    Form1.Height := Screen.Height;
    Form1.Repaint;
  end;
end;

procedure TEFLimparPastaRetorno(sDiretorioResposta: String);
begin
  DeleteFile(sDiretorioResposta+'\INTPOS.001');
  DeleteFile(sDiretorioResposta+'\INTPOS.STS');
end;

procedure TEFCancelarTransacoesDemaisCartoes(sPastaTEF: String;
  sPastaREQ: String; sPastaRESP: String); // Sandro Silva 2017-06-14
var
  slArquivos: TStringList;
  sDirAtual: String;
  i, Y: Integer;
  sArquivoTEF: String;
  sArquivoTEFCancelado: String; // Sandro Silva 2017-06-29
  F: TextFile;
  sValorTot1: String;
  sNomeRede1: String;
  sTransaca1: String;
  sIdentifi1: String;
  sFinaliza1: String;
  OkSim1: String;
  sMensagem: String;
  sLinha1: String;
  sNomeArquivo: String;
  sIdentificaTransacaoTEF: String;
  sCupom: String;

  sValorTotal003_000: String;
  sMoeda004_000: String;
  sRedeAdquirente010_000: String;
  sNSU012_000: String;
  sQtdeparcelas018_000: String;
  sDataComprovante022_000: String;
  sHoraComprovante023_000: String;
  sFinaliza027_000: String;
  sCapacidadesAutomacao706_000: String;
  sEmpresaAutomacao716_000: String;
  sVersaoInterface733_000: String;
  sNomeAutomacao735_000: String;
  sVersaoAutomacao736_000: String;
  sRegistroCertificacao738_000: String;
  sNSU012_000Cancelamento: String; // Sandro Silva 2017-07-05
  sFinaliza027_000Cancelamento: String; // Sandro Silva 2017-07-05

  bBkpProcessado: Boolean;
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  sCupom := '';
  try
    while True do
    begin
      ListaDeArquivos(slArquivos, DIRETORIO_BKP_TEF, sPastaTEF + '*.BKP');

      if slArquivos.Count < 1 then // Sandro Silva 2017-06-28
        Break;

      for I := 0 to slArquivos.Count -1 do
      begin
        sArquivoTEF := diretorio_bkp_tef + '\' + AllTrim(slArquivos[I]);
        //
        if AnsiContainsText(ExtractFileName(sArquivoTEF), sPastaTEF) then
        begin
          // Exemplo de nome de arquivo TEF_DIAL01.BKP, TEF_DIAL02.BKP
          // Último caractere do nome deve ser número maior ou igual a zero
          sNomeArquivo := StringReplace(AnsiUpperCase(ExtractFileName(sArquivoTEF)), '.BKP', '', [rfReplaceAll]);
          if StrToIntDef(Right(sNomeArquivo, 2), -1) >= 0 then
          begin // Apenas arquivos dos primeiros cartões, não do último

            Sleep(1000);// Sandro Silva 2017-06-23  Sleep(2000);
            DeleteFile('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.STS');

            sValorTot1 := '';
            sNomeRede1 := '';
            sTransaca1 := '';
            sIdentifi1 := '';
            OkSim1     := '';

            sValorTotal003_000           := '';
            sMoeda004_000                := '';
            sRedeAdquirente010_000       := '';
            sNSU012_000                  := '';
            sQtdeparcelas018_000         := '';
            sDataComprovante022_000      := '';
            sHoraComprovante023_000      := '';
            sFinaliza027_000             := ''; // Sandro Silva 2017-07-04
            sCapacidadesAutomacao706_000 := '';
            sEmpresaAutomacao716_000     := '';
            sVersaoInterface733_000      := '';
            sNomeAutomacao735_000        := '';
            sVersaoAutomacao736_000      := '';
            sRegistroCertificacao738_000 := '';

            AssignFile(F,Pchar(sArquivoTEF));
            Reset(F);

            for Y := 1 to 500 do
            begin
              ReadLn(F,sLinha1);
              sLinha1 := StrTran(sLinha1,chr(0),' ');
              if Copy(sLinha1,1,7) = '003-000' then sValorTot1 := StrTran(AllTrim(Copy(sLinha1,10,Length(sLinha1)-9)),',',''); //          if Copy(sLinha1,1,7) = '003-000' then Form1.sValorTot := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '010-000' then sNomeRede1 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '001-000' then sIdentifi1 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '012-000' then sTransaca1 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '027-000' then sFinaliza1 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '009-000' then OkSim1     := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));

              if Copy(sLinha1,1,7) = '003-000' then sValorTotal003_000      := StrTran(AllTrim(Copy(sLinha1,10,Length(sLinha1)-9)),',','');
              if Copy(sLinha1,1,7) = '004-000' then sMoeda004_000           := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '010-000' then sRedeAdquirente010_000  := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '012-000' then sNSU012_000             := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '018-000' then sQtdeparcelas018_000    := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '022-000' then sDataComprovante022_000 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '023-000' then sHoraComprovante023_000 := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
              if Copy(sLinha1,1,7) = '027-000' then sFinaliza027_000        := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
            end;
            //
            CloseFile(F);

            bBkpProcessado := False;

            // Identifica se tem retorno na pasta do tef e se é da transação que está tentando cancelar
            if FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
            begin
              bBkpProcessado := (CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '000-000') = 'CNC')
                            and (sNomeRede1 = CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '010-000'))                      // Nome Rede venda = Nome Rede cancelada
                            and (sNSU012_000 = CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '025-000'))                     // NSU venda = NSU original cancelado
                            and (CampoTEF(sArquivoTEF, '015-000') = CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '026-000'))// Data hora venda = data hora original cancelado
                            ;
            end;


            if bBkpProcessado = False then
            begin
              Form1.ExibePanelMensagem('Cancelando NSU: ' + sNSU012_000); // Sandro Silva 2017-06-23

              //tratar a impressão quando finaliza o cupom, se aberto ou imprimir em funcoes adm

              Application.MessageBox(PChar('Essa Transação será CANCELADA!!! ' + #13 + #13 +
                                           'Anote os dados para cancelamento!!! ' + #13 + #13 +
                                           StringReplace(StringReplace(CampoTEF(sArquivoTEF, '029-'), #10 + '    ' + #10, #10, [rfReplaceAll]), #10 + '  ' + #10, #10, [rfReplaceAll])),
                             PChar('Transação NSU: ' + sNSU012_000),
                             MB_ICONINFORMATION);



              sCapacidadesAutomacao706_000 := '2';
              sEmpresaAutomacao716_000     := AnsiUpperCase(ConverteAcentos(Form1.sRazaoSocialSmallsoft));
              sVersaoInterface733_000      := '210'; // 210 PAY&GO
              sNomeAutomacao735_000        := 'SMALL';
              sVersaoAutomacao736_000      := 'SMALL ' + Copy(LimpaNumero(Form22.sBuild), 1, 4);
              sRegistroCertificacao738_000 := '';

              sIdentificaTransacaoTEF := StrTran(TimeToStr(Time),':','');
              AssignFile(F,'c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.TMP');
              Rewrite(F);
              WriteLn(F,'000-000 = CNC');              // Header: Cartão 	Comando
              WriteLn(F,'001-000 = ' + sIdentificaTransacaoTEF); // Identificação: Eu uso a hora	Identificacao
              WriteLn(F,'003-000 = ' + sValorTot1);    //	Valor total
              WriteLn(F,'004-000 = ' + sMoeda004_000); //	Moeda
              WriteLn(F,'010-000 = ' + sRedeAdquirente010_000); // Rede Adquirente
              WriteLn(F,'012-000 = ' + sNSU012_000); //	NSU
              if sQtdeparcelas018_000 <> '' then
                WriteLn(F,'018-000 = ' + sQtdeparcelas018_000); // Qtde.parcelas
              WriteLn(F,'022-000 = ' + sDataComprovante022_000); //	Data no comprovante
              WriteLn(F,'023-000 = ' + sHoraComprovante023_000);	// Hora no comprovante
              AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
              WriteLn(F,'706-000 = ' + sCapacidadesAutomacao706_000); //	Capacidades da automação
              WriteLn(F,'716-000 = ' + sEmpresaAutomacao716_000); //	Empresa da Automação
              //WriteLn(F,'733-000 = ' + sVersaoInterface733_000) //	Versão da interface
              WriteLn(F,'735-000 = ' + sNomeAutomacao735_000); //	Nome da automação
              WriteLn(F,'736-000 = ' + sVersaoAutomacao736_000); //	Versão da automação
              //WriteLn(F,'738-000 = ' + sRegistroAutomacao738_000); //	Registro de certificação
              WriteLn(F,'999-999 =0'); //	Registro finalizador

              CloseFile(F);
              DeleteFile('c:\'+sPastaTEF+'\'+sPastaREQ+'\INTPOS.001');
              TEFLimparPastaRetorno('c:\'+sPastaTEF+'\'+sPastaRESP); // Form1.TEFLimparPastaRetorno('c:\'+sPastaTEF+'\'+sPastaRESP);
              Sleep(100); // Sandro Silva 2017-06-14
              RenameFile('c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.TMP','c:\'+sPastaTEF+'\'+sPastaREQ+'\INTPOS.001');

              for Y := 0 to 4 do
              begin
                if not FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
                  Sleep(1000);
              end;
              //
              while not FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') do
              begin
                Sleep(250); // Recomendação de fazer no máximo 4 vezes por segundo a verificação se o arquivo existe
                Application.ProcessMessages;
                // ----------------------------- //
                // Verifica se é o arquivo certo //
                // ----------------------------- //
                if FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
                begin
                  Sleep(250);// Sandro Silva 2017-06-23  Sleep(1000);
                  AssignFile(F,'c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001');
                  Reset(F);
                  for Y := 1 to 5 do
                  begin
                    ReadLn(F,sLinha1);
                    sLinha1 := StrTran(sLinha1,chr(0),' ');
                    if Copy(sLinha1,1,7) = '001-000' then
                    begin
                      if AllTrim(Copy(sLinha1,10,Length(sLinha1)-9)) <> sIdentificaTransacaoTEF then
                      begin
                        DeleteFile('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001');
                        Sleep(1000);
                      end;
                    end;
                  end;
                  CloseFile(F);
                end;
                // ----------------------------- //
                // Verifica se é o arquivo certo //
                // ----------------------------- //
              end;

            end;

            Form1.sParcelas := '0';
            sValorTot1 := '';
            sNomeRede1 := '';
            sTransaca1 := '';
            sFinaliza1 := '';
            sLinha1    := '';
            //

            sMensagem  := '';
            OkSim1     := '';
            sCupom     := '';
            //
            if FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
            begin
              AssignFile(F,'c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001');
              Reset(F);
              //
              for Y := 1 to 500 do
              begin
                sLinha1 := '';
                ReadLn(F,sLinha1);
                sLinha1 := StrTran(sLinha1,chr(0),' ');
                //
                if Copy(sLinha1,1,7) = '003-000' then sValorTot1      := StrTran(AllTrim(Copy(sLinha1,10,Length(sLinha1)-9)),',','');
                if Copy(sLinha1,1,7) = '009-000' then OKSim1          := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,7) = '010-000' then sNomeRede1      := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,7) = '012-000' then sTransaca1      := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,7) = '027-000' then sFinaliza1      := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,7) = '017-000' then Form1.sTipoParc := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,7) = '018-000' then Form1.sParcelas := AllTrim(Copy(sLinha1,10,Length(sLinha1)-9));
                if Copy(sLinha1,1,4) = '029-'    then sCupom          := StrTran(Copy(sLinha1,11,Length(sLinha1)-10),'"','') + chr(10);
                if Copy(sLinha1,1,4) = '030-'    then sMensagem       := StrTran(Copy(sLinha1,11,Length(sLinha1)-10),'"','');
                //                         //
                // Igual Funcões Administrativas //
                //                         //
              end;
              //
              CloseFile(F);
            end;

            if sMensagem <> '' then
              Form1.ExibePanelMensagem(sMensagem);

            if AllTrim(OKSim1) = '0' then // Ronei Mudei aqui
            begin

              if (AnsiUpperCase(CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '000-000')) = 'CNC')
                and (CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '001-000') = sIdentificaTransacaoTEF) then
              begin
                sArquivoTEFCancelado := 'c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001';

                if CampoTEF(sArquivoTEFCancelado, '009-000') = '0' then
                  sCupom := sCupom + CampoTEF(sArquivoTEFCancelado, '029-');

                if TEFImpressaoPendentePorTransacao(CampoTEF(sArquivoTEFCancelado, '029-')) then
                begin

                  CopyFile(pChar('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001'), pChar(sArquivoTEF), False); // Sandro Silva 2017-06-26
                  sArquivoTEFCancelado := StringReplace(sArquivoTEF, '.BKP', '.BKC', [rfReplaceAll]);
                  if FileExists(PChar(sArquivoTEFCancelado)) then
                    DeleteFile(PChar(sArquivoTEFCancelado));
                  if FileExists(PChar(sArquivoTEF)) then
                    RenameFile(PChar(sArquivoTEF), PChar(sArquivoTEFCancelado)); // Sandro Silva 2017-06-29

                  //
                  AssignFile(F,'c:\'+sPastaTef+'\'+sPastaREQ+'\IntPos.TMP');
                  Rewrite(F);
                  sIdentificaTransacaoTEF := StrTran(TimeToStr(Time),':','');
                  //
                  Form1.Repaint;
                  //
                  //Confirmando a transação TEF
                  WriteLn(F,'000-000 = CNF'); // Alterei a orderm em na homologação do modular 2012
                  WriteLn(F,'001-000 = '+sIdentificaTransacaoTEF);  // Identificação: Eu uso a hora WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
                  WriteLn(F,'010-000 = '+sNomeRede1);               // Nome da rede:
                  WriteLn(F,'012-000 = '+sTransaca1);               // Número da transação NSU:
                  WriteLn(F,'027-000 = '+sFinaliza1);               // Finalização:
                  AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                  WriteLn(F,'999-999 = 0');                         // Trailer - REgistro Final, constante '0' .
                  CloseFile(F);
                  Sleep(100); // Sandro Silva 2017-06-14
                  TEFLimparPastaRetorno('c:\'+sPastaTEF+'\'+sPastaRESP); //Form1.TEFLimparPastaRetorno('c:\'+sPastaTEF+'\'+sPastaRESP);
                  RenameFile('c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.TMP','c:\'+sPastaTEF+'\'+sPastaREQ+'\INTPOS.001');
                  Sleep(10000);

                  //Aguarda retorno de Status (INTPOS.STS) do TEF

                  TEFAguardarRetornoStatus('c:\'+sPastaTEF+'\'+sPastaRESP, sIdentificaTransacaoTEF); // Sandro Silva 2017-06-22//Form1.TEFAguardarRetornoStatus('c:\'+sPastaTEF+'\'+sPastaRESP, sIdentificaTransacaoTEF); // Sandro Silva 2017-06-22

                  DeleteFile(sArquivoTEF); // Sandro Silva 2017-07-04
                  DeleteFile(sArquivoTEFCancelado); // Sandro Silva 2017-07-04

                  SmallMsgBox(pChar('Nome da Rede: ' + sNomeRede1 + Chr(10) +
                                    'NSU: ' + sTransaca1 + Chr(10) +
                                    'Valor: ' + FormatFloat('0.00', StrToIntDef(sValorTot1, 0) / 100) + Chr(10) +
                                    'Cancelada'),'Atenção',mb_Ok + MB_ICONERROR); // Sandro Silva 2017-07-03  SmallMsgBox(pChar(Chr(10) + 'NSU: ' + sTransaca1 + Chr(10) + ' Cancelada'),'Atenção',mb_Ok + MB_ICONERROR);
                end
                else
                begin
                  // Falhou a impressão do cancelamento
                  // Enviar NCN
                  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31

                  AssignFile(F,'c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.tmp');
                  Rewrite(F);
                  //NCN Não confirmação da venda e/ou da impressão.                  
                  WriteLn(F,'000-000 = NCN');                              // Header: Cartão 3c
                  WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':','')); // Identificação: Eu uso a hora
                  //
                  // WriteLn(F,'003-000 = '+ Form1.sValorTot);             // Identificação: Eu uso o número do cupom 10c
                  //
                  WriteLn(F,'010-000 = '+ sNomeRede1);                // Nome da rede:
                  WriteLn(F,'012-000 = '+ sTransaca1);                // Número da transação NSU:
                  WriteLn(F,'027-000 = '+ sFinaliza1);                // Finalização:
                  AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
                  WriteLn(F,'999-999 = 0');                           // Trailer - REgistro Final, constante '0' .
                  CloseFile(F);
                  RenameFile('c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.tmp','c:\'+sPastaTEF+'\'+sPastaREQ+'\INTPOS.001');
                  Sleep(10000);

                  if FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
                  begin

                    if (CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '009-000') <> '0')
                      and (Trim(CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '009-000')) <> '') then
                    begin
                      SmallMsgBox(PChar(CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '030-000')), 'Atenção', MB_ICONWARNING);
                    end;

                  end;
                  
                end;
              end;
            end
            else
            begin
              // Transação não confirmada
              // Enviar NCN
              AssignFile(F,'c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.tmp');
              Rewrite(F);
              //NCN Não confirmação da venda e/ou da impressão.
              WriteLn(F,'000-000 = NCN');                              // Header: Cartão 3c
              WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':','')); // Identificação: Eu uso a hora
              //
              // WriteLn(F,'003-000 = '+ Form1.sValorTot);             // Identificação: Eu uso o número do cupom 10c
              //
              WriteLn(F,'010-000 = '+ sNomeRede1);     // Nome da rede:
              WriteLn(F,'012-000 = '+ sTransaca1);     // Número da transação NSU:
              WriteLn(F,'027-000 = '+ sFinaliza1);     // Finalização:
              AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
              WriteLn(F,'999-999 = 0');                // Trailer - REgistro Final, constante '0' .
              CloseFile(F);
              RenameFile('c:\'+sPastaTEF+'\'+sPastaREQ+'\IntPos.tmp','c:\'+sPastaTEF+'\'+sPastaREQ+'\INTPOS.001');
              Sleep(10000);

              if FileExists('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001') then
              begin
                if (CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '009-000') <> '0')
                  and (Trim(CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '009-000')) <> '') then
                begin

                  DeleteFile(sArquivoTEF); // Sandro Silva 2017-07-04
                  DeleteFile(sArquivoTEFCancelado); // Sandro Silva 2017-07-04

                  SmallMsgBox(PChar(CampoTEF('c:\'+sPastaTEF+'\'+sPastaRESP+'\INTPOS.001', '030-000')), 'Atenção', MB_ICONWARNING);
                end;
              end;

            end; // if AllTrim(OKSim1) = '0' then // Ronei Mudei aqui

            Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False; // Sandro Silva 2017-06-22

            Sleep(500); // Sandro Silva 2017-06-23  Sleep(1000); // Sandro Silva 2017-06-19
          end;
        end;
      end; // for I := 0 to slDownload.Count -1 do
    end; // while True do

    if sCupom = '' then
    begin
      // Não cancelou arquivos no loop acima
      // Carrega a impressão dos cancelamentos com impressão pendentes
      ListaDeArquivos(slArquivos, DIRETORIO_BKP_TEF, sPastaTEF + '*.BKC');

      for I := 0 to slArquivos.Count -1 do
      begin
        sArquivoTEFCancelado := diretorio_bkp_tef + '\' + AllTrim(slArquivos[I]);

        OKSim1 := '';
        if FileExists(sArquivoTEFCancelado) then
        begin
          OKSim1 := CampoTEF(sArquivoTEFCancelado, '009-000');
        end;

        if AllTrim(OKSim1) = '0' then // Ronei Mudei aqui
        begin
          if (AnsiUpperCase(CampoTEF(sArquivoTEFCancelado, '000-000')) = 'CNC') then
          begin
              sCupom := sCupom + CampoTEF(sArquivoTEFCancelado, '029-');
              Form1.sCupomTEFCancelado := Form1.sCupomTEFCancelado + sCupom;
          end;
        end;

        Form1.OcultaPanelMensagem;
      end;
    end;

    if Form1.sCupomTEFCancelado <> '' then
    begin
      // Aqui ainda não conectou o banco
      // Erro se validar cupom aberto
      //if PDV_CupomAberto = False then
      //begin
        // Não tem cupom aberto imprimir gerencial com validações de finalização, queda energia, etc...
      //end;
    end;
  finally
    FreeAndNil(slArquivos);
  end;

  ChDir(sDirAtual);

  Form1.OcultaPanelMensagem;
end;

function CampoTEF(sArquivoTEF: String; sCampo: String): String;
var
  F: TextFile;
  Y: Integer;
  sLinha1: String;
begin
  Result := '';
  if FileExists(sArquivoTEF) then
  begin
    try
      AssignFile(F,Pchar(sArquivoTEF));
      Reset(F);

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

      CloseFile(F);
    except
    end;
  end;
end;

function TEFImpressaoPendentePorTransacao(sCupom: String): Boolean;
// Faz a impressão dos comprovantes cancelamento pendentes de impressão se não tiver cupom aberto
var
  bChave: Boolean;
  bSair: Boolean;
begin
  Result := False;
  try

    if AllTrim(sCupom) <> '' then
    begin
      // Imprimir se cupom estiver fechado
      bChave := False;

      if Form1.PDV_CupomAberto = False then
      begin
        bSair  := False;
        try
          while (not bChave) and (not bSair) do
          begin
            Form1.Panel3.Repaint;
            Application.ProcessMessages;
            //
            Sleep(100);
            //
            Form1.PDV_FechaCupom2(True);
            //
            // if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(True);   // Disable Keyboard & mouse
            //
            bChave := Form1.PDV_ImpressaoNaoSujeitoaoICMS(SCupom);
            //
            // sleep(1000);
            //
            if bChave then // 2015-10-06
              Form1.Demais('RG');
            //
            if not bChave then
            begin
              //
              // 2015-09-08 if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(False);  // Enable  Keyboard & mouse
              Form1.bButton := SmallMsgBox(pChar('Impressora não responde.'+Chr(10)
                                            +Chr(10)
                                            +'Tentar novamente?'+chr(10)
                                            +Chr(10)
                                             ),'Atenção (Comprovantes cancelamento TEF)', mb_YesNo + mb_DefButton1 + MB_ICONWARNING);
              if Form1.bButton = IDYES then
              begin
                //
                // 2015-09-08 if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(True);   // Disable Keyboard & mouse
                Sleep(5000);
                //
                Form1.PDV_FechaCupom2(True);
                //
                Sleep(2000);
                //
              end;
              if Form1.bButton <> IDYES then
                bSair := True;
            end;
          end; // while (not bChave) and (not bSair) do
        finally
          //
          // 2015-09-08 if FunctionDetect('USER32.DLL','BlockInput',@xBlockInput) then xBlockInput(False);  // Enable  Keyboard & mouse
        end;
        //
      end; // if PDV_CupomAberto = False then

      if bChave then
      begin
        Result := True;
      end;
      // Fim Impressão cancelamento pendente
    end; // if AllTrim(SCupom) <> '' then
  except
  end;
end;

procedure TEFAguardarRetornoStatus(sDiretorioResposta: String;
  sIdentificaTransacaoTEF: String);
var
  Y: Integer;
  iTimeOut: Integer; // Sandro Silva 2017-06-28
  sLinha1: String;
  F: TextFile;
begin
  //Aguarda retorno de Status (INTPOS.STS) do TEF

  for Y := 0 to 4 do
  begin
    if not FileExists(sDiretorioResposta + '\INTPOS.STS') then
      Sleep(1000);
  end;
  //
  iTimeOut := 0;
  while not FileExists(sDiretorioResposta + '\INTPOS.STS') do
  begin
    Sleep(250); // Recomendação de fazer no máximo 4 vezes por segundo a verificação se o arquivo existe
    Application.ProcessMessages;
    // ----------------------------- //
    // Verifica se é o arquivo certo //
    // ----------------------------- //
    if FileExists(sDiretorioResposta + '\INTPOS.STS') then
    begin
      Sleep(1000);
      AssignFile(F, sDiretorioResposta + '\INTPOS.STS');
      Reset(F);
      for Y := 1 to 5 do
      begin
        ReadLn(F, sLinha1);
        sLinha1 := StrTran(sLinha1,chr(0),' ');
        if Copy(sLinha1,1,7) = '001-000' then
        begin
          if AllTrim(Copy(sLinha1,10,Length(sLinha1)-9)) <> sIdentificaTransacaoTEF then
          begin
            DeleteFile(sDiretorioResposta + '\INTPOS.STS');
            Sleep(1000);
          end;
        end;
        iTimeOut := Y;
      end;
      CloseFile(F);
    end;
    // ----------------------------- //
    // Verifica se é o arquivo certo //
    // ----------------------------- //
    Inc(iTimeOut);
    if (iTimeOut * 250) > 30000 then // Aguarda 1 min (60.000 milisegundos)
      Break;
  end;
end;

function TEFTextoImpressaoCupomAutorizado(sCampo: String): String;
var
  slArquivos: TStringList;
  sDirAtual: String;
  i: Integer;
  sArquivoTEF: String;
  sNomeArquivo: String;
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  Result := '';
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

function TEFContaArquivos(sTipoComCaminho: String): Integer;
var
  sDirAtual: String;
  S: TSearchREc;
  I: Integer;
begin
  GetDir(0, sDirAtual);
  Result := 0;
  try
    I := FindFirst( sTipoComCaminho, faAnyFile, S);

    while I = 0 do
    begin
      I := FindNext(S);
      Inc(Result);
    end;

    FindClose(S);
  except
  end;

  ChDir(sDirAtual);
end;

function TEFValorTotalAutorizado(): Currency;
var
  slArquivos: TStringList;
  sDirAtual: String;
  i: Integer;
  sArquivoTEF: String;
  sNomeArquivo: String;
  sNomeTEFAutorizacao: String;
  sDebitoOuCreditoAutorizado: String;
  bRespostaValidadosFiscal: Boolean;
  ModalidadeTransacao: TTipoModalidadeTransacao;
begin
  GetDir(0, sDirAtual);
  slArquivos := TStringList.Create;
  Result := 0.00;

  try
    ListaDeArquivos(slArquivos, DIRETORIO_BKP_TEF, '*.BKP');

    for I := 0 to slArquivos.Count -1 do
    begin
      sArquivoTEF := DIRETORIO_BKP_TEF + '\' + AllTrim(slArquivos[I]);

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
              Form1.TransacoesCartao.Transacoes.Adicionar(sNomeTEFAutorizacao,
                                                          Form1.sDebitoOuCredito,
                                                          TEFValorTransacao(sArquivoTEF),
                                                          CampoTEF(sArquivoTEF, '010-000'),
                                                          CampoTEF(sArquivoTEF, '012-000'),
                                                          CampoTEF(sArquivoTEF, '013-000'),
                                                          CampoTEF(sArquivoTEF, '010-000'),
                                                          '',
                                                          '',
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

function TEFValorTransacao(sArquivoTEF: String): Currency;
begin
  Result := (StrToIntDef(LimpaNumero(CampoTEF(sArquivoTEF, '003-000')), 0) / 100);
end;

procedure TEFDeletarCopiasArquivos(FsDiretorio: String);
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
        sTipo := '';
    end;
  finally
    FreeAndNil(slArquivos);
  end;

  ChDir(sDirAtual);
end;

function TestarZPOSLiberado: Boolean;
var
  dLimiteRecurso : Tdate;
begin
  Result := (RecursoLiberado(Form1.IBDatabase1,rcZPOS,dLimiteRecurso));
end;

function GetBinCartao(sArquivoTEF: String) : string;
var
  iPos : integer;
begin
  Result := '';

  iPos := Pos('740-000',sArquivoTEF);

  if iPos > 0 then
  begin
    Result := Copy(sArquivoTEF,iPos+10,6);
    Result := StringReplace(Result,'*','',[rfReplaceAll]);
  end;
end;

function GetUltimosDigitosCartao(sArquivoTEF: String) : string;
var
  iPos : integer;
begin
  Result := '';

  iPos := Pos('740-000',sArquivoTEF);

  if iPos > 0 then
  begin
    Result := Copy(sArquivoTEF,iPos+22,4);
    Result := StringReplace(Result,'*','',[rfReplaceAll]);
  end;
end;

end.
