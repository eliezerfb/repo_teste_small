unit uTransacionaPosOuTef;

interface

uses
  System.SysUtils
  , System.Classes
  , System.StrUtils
  , System.IniFiles
  , Winapi.Windows
  , Vcl.Forms
  , Vcl.Dialogs
  , Vcl.Controls
  , Data.DB
  , ufuncoesfrente
  , uclassetransacaocartao
  ;

procedure AcionaTEF(NomeDoTEF: String);

type
  TTransacaoComPosOuTef = class

  private
    FdTotalEmCartao: Currency; //Double;
    FFormasExtras: TPagamentoPDV;
    FdTotalTransacionado: Currency; //Double;
    FiContaCartao: Integer;
    FsCupomAutorizado: String;
    FbConfirmarTransacao: Boolean;
    FsCupomReduzidoAutorizado: String;
    FfDescontoNoPremio: real;
    function AplicaOpcaoPosEscolhida(NomePOS: String): Boolean;
  public
    constructor Create(AOwner: TComponent);
    function TransacionaPosOuTef: Boolean;
  end;

implementation

uses
   Smallfunc_XE
  , ufuncoesTef
  , unit10
  , uDialogs
  , uFuncoesPOS
  , ufrmOpcoesFechamentoComCartao
  , fiscal
  , usmall_elginpay_pos
  ;

procedure AcionaTEF(NomeDoTEF: String);
var
  Mais1Ini : TiniFile;
begin
  // Form10 devera devolver sDiretorio, sResp, sReq, sExec

  Mais1ini := TIniFile.Create('FRENTE.INI');
  Mais1Ini.WriteString('Frente de caixa', 'TEF USADO', NomeDoTEF);

  Form1.sDiretorioTEF := AllTrim(Mais1Ini.ReadString(NomeDoTEF, 'Pasta', 'XXXXXXXX'));
  Form1.sReqTef       := AllTrim(Mais1Ini.ReadString(NomeDoTEF, 'Req', 'REQ'));
  Form1.sRespTef      := AllTrim(Mais1Ini.ReadString(NomeDoTEF, 'Resp', 'RESP'));
  Form1.sExec      := AllTrim(Mais1Ini.ReadString(NomeDoTEF, 'Exec', 'XXX.XXX'));
  Mais1Ini.Free;
end;

{ TransacaoPosOuTef }

function TTransacaoComPosOuTef.AplicaOpcaoPosEscolhida(NomePOS: String): Boolean;
var
  bAutorizacao: Boolean;
begin
  //  Form10.sNomeDoTEF := NomePOS;
  bAutorizacao := False;
  Form1.sTransacaPOS := ''; // Sandro Silva 2024-12-05 Form1.sTransaca := '';
  Form1.sAutoriza := '';
  // Sandro Silva 2024-12-05 Form1.sNomeRede := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(NomePOS)), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
  Form1.sNomeRedeTransacionada := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(NomePOS)), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
  Form1.sTipoParc := '0';
  Form1.sParcelas := '1';

  if (Form1.sIdentificaPOS = 'Sim') then
  begin
    Form1.sTransacaPOS := ''; // Sandro Silva 2025-12-05 Form1.sTransaca := '';
    if (Form1.sModeloECF = '65') or (Form1.sModeloECF = '59') or (Form1.sModeloECF = '99')// NFC-e/SAT/MEI
      then // Número de autorização apenas quando NFC-e
    begin

      while (Trim(Form1.sTransacaPOS) = '') do // Sandro Silva 2024-12-05 while (Trim(Form1.sTransaca) = '') do
      begin
        //Sandro Silva 2024-12-05 Form1.sTransaca := Form1.Small_InputBox('AUTORIZAÇÃO','Informe o número da AUTORIZAÇÃO para operação com POS:', Form1.sTransaca);
        Form1.sTransacaPOS := Form1.Small_InputBox('AUTORIZAÇÃO','Informe o número da AUTORIZAÇÃO para operação com POS:', Form1.sTransacaPOS);

        if (Trim(Form1.sTransacaPOS) <> '') or (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE') then // Sandro Silva 2024-12-05 if (Trim(Form1.sTransaca) <> '') or (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) <> 'CE') then
        begin
          bAutorizacao := True;
          Break;
        end
        else
        begin
          if (AnsiUpperCase(Form1.ibDataSet13.FieldByName('ESTADO').AsString) = 'CE') then
          begin
            if Form1.TransacoesCartao.Transacoes.Count = 0 then
              SmallMsg('O Número da Autorização é necessária para forma de pagamento cartão' + #13 + #13 + 'Solicite outro cartão ' + #13 + #13 + 'ou informe 0,00 no valor de pagamento para finalizar em outra forma')
            else
              SmallMsg('O Número da Autorização é necessária para forma de pagamento cartão' + #13 + #13 + 'Solicite outro cartão ' + #13 + #13 + 'ou informe 0,00 no valor de pagamento para finalizar o valor restante em dinheiro');
            Break;
          end;
        end;

      end;

    end; //
    Form1.sAutoriza := Form1.sTransacaPOS; // Sandro Silva 2024-12-06 inicio Form1.sAutoriza := Form1.sTransaca;

    if bAutorizacao then
    begin
      //Remove acentuação, espaços e texto "DEBITO" e "CREDITO"
      // Sandro Silva 2024-12-05 Form1.sNomeRede := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(NomePOS)), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
      Form1.sNomeRedeTransacionada := Trim(StringReplace(StringReplace(AnsiUpperCase(ConverteAcentos(NomePOS)), 'CREDITO', '', [rfReplaceAll]), 'DEBITO', '', [rfReplaceAll]));
      Form1.sTipoParc := '0';
      Form1.sParcelas := '1';

      while True do
      begin
        Form1.sParcelas := Trim(Form1.Small_InputBox(PARCELAS_EM_CARTAO, 'Informe o número de PARCELAS para operação com POS:', Form1.sParcelas));

        if StrToIntDef(Form1.sParcelas, 0) > 62 then
        begin
          if Application.MessageBox(PChar('Número de PARCELAS acima do padrão' + #13 +  #13 +
                                          'Confirma ' + FormatFloat(',0', StrToIntDef(Form1.sParcelas, 0)) + ' parcelas?' + #13 + #13),
                                    'Alerta',
                                    MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = IDNO then // MB_DEFBUTTON2 para evitar que o usuário avance com Enter sem querer quando não deveria. Caso que informou o número da autorização para o número de parcelas e gerou mais de 100 mil registros no RECEBER
            Form1.sParcelas := '';
        end;

        try
          // Previnir casos onde é digitado outro número ao invés do número das parcelas, causando exception. Situação ocorreu e gerou mais de 100 mil registros no RECEBER
          Form1.sParcelas := IntToStr(StrToIntDef(Form1.sParcelas, 0));
        except
          on E: Exception do
          begin
            Application.MessageBox(PChar('Número de parcelas informado é inválido: ' + Form1.sParcelas), 'Atenção', MB_OK + MB_ICONWARNING);
            Form1.sParcelas := '';
          end;
        end;

        if (Form1.sParcelas = LimpaNumero(Form1.sParcelas)) and (StrToIntDef(Form1.sParcelas, 0) > 0) then
          Break;
      end;
    end;
  end;
  Result := bAutorizacao;
end;

constructor TTransacaoComPosOuTef.Create(AOwner: TComponent);
begin
  FdTotalTransacionado := 0.00;
  FdTotalEmCartao      := 0.00;
  FiContaCartao := 0;
  FbConfirmarTransacao := False;

  FsCupomReduzidoAutorizado := '';
  FsCupomAutorizado         := '';
end;

function TTransacaoComPosOuTef.TransacionaPosOuTef: Boolean;
var
  dValorPagarCartao: Currency;
  TipoTransacao: TTipoTransacaoTefPos;

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
    Form1.ibDataSet25.FieldByName('VALOR01').AsFloat := FFormasExtras.Extra1;
    Form1.ibDataSet25.FieldByName('VALOR02').AsFloat := FFormasExtras.Extra2;
    Form1.ibDataSet25.FieldByName('VALOR03').AsFloat := FFormasExtras.Extra3;
    Form1.ibDataSet25.FieldByName('VALOR04').AsFloat := FFormasExtras.Extra4;
    Form1.ibDataSet25.FieldByName('VALOR05').AsFloat := FFormasExtras.Extra5;
    Form1.ibDataSet25.FieldByName('VALOR06').AsFloat := FFormasExtras.Extra6;
    Form1.ibDataSet25.FieldByName('VALOR07').AsFloat := FFormasExtras.Extra7;
    Form1.ibDataSet25.FieldByName('VALOR08').AsFloat := FFormasExtras.Extra8;
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

  procedure ConfirmaTransacaoTefAnterior;
  var
    F: TextFile;
  begin
    if FbConfirmarTransacao then
    begin // Confirma a transação do cartão anterior

      Form1.ExibePanelMensagem('Confirmando a transação do ' + IntToStr(FiContaCartao) + 'º cartão', True);

      // Faz backup dos dados de autorização anterior
      CopyFile(pChar('c:\' + Form1.sDiretorioTEF + '.RES'), pChar(DIRETORIO_BKP_TEF + '\' + Form1.sDiretorioTEF + FormatFloat('00', TEFContaArquivos(DIRETORIO_BKP_TEF + '\' + Form1.sDiretorioTEF +'*.BKP') + 1) + '.BKP'), False);

      {Sandro Silva 2024-12-06 inicio
      // Confirmando a transação TEF
      AssignFile(F,Pchar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.tmp'));
      Rewrite(F);
      WriteLn(F,'000-000 = CNF');                               // Header: Cartão 3c
      WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
      WriteLn(F,'010-000 = '+ Form1.sNomeRede);                 // Nome da rede:
      WriteLn(F,'012-000 = '+ Form1.sTransaca);                 // Número da transação NSU:
      WriteLn(F,'027-000 = '+ Form1.sFinaliza);                 // Finalização:
      AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13);          // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
      WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
      CloseFile(F);
      Sleep(1000);
      RenameFile(Pchar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.tmp'),'c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001');
      Sleep(6000);
      }
      // Confirmando a transação TEF
      AssignFile(F,Pchar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.tmp'));
      Rewrite(F);
      WriteLn(F,'000-000 = CNF');                               // Header: Cartão 3c
      WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
      WriteLn(F,'010-000 = '+ Form1.sNomeRedeParaTransacoesTEF);// Nome da rede:
      WriteLn(F,'012-000 = '+ Form1.sTransacaTEF);                 // Número da transação NSU:
      WriteLn(F,'027-000 = '+ Form1.sFinaliza);                 // Finalização:
      AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13);          // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
      WriteLn(F,'999-999 = 0');                                 // Trailer - REgistro Final, constante '0' .
      CloseFile(F);
      Sleep(1000);
      RenameFile(Pchar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.tmp'),'c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001');
      Sleep(2000);
      {Sandro Silva 2024-12-06 fim}

      Form1.OcultaPanelMensagem;

      //Precisa? TEFAguardarRetornoStatus() e validar .STS
      if FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS') then // Sandro Silva 2017-06-22
        TEFDeletarCopiasArquivos(DIRETORIO_BKP_TEF); // Sandro Silva 2017-06-30

    // 2024-11-28 end;
      FbConfirmarTransacao := False;

      FfDescontoNoPremio := 0;

      //Sandro Silva 2024-12-05 Form1.sDIRETORIO := '';
    end;
  end;

  function TransacionaComTEF: Boolean;
  var
    I: Integer;
    F: TextFile;
    sBotaoOk, sCerto, sCerto1: String;
    iParcelas: Integer;
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
    nTEFElginPergunta: Integer;
    sRespostaTef: String; // Para capturar linhas da resposta do tef
    ModalidadeTransacao: TTipoModalidadeTransacao;
    bTemElgin: Boolean;
    dTotalTransacaoTEF: Currency; //Double;
    dValorDuplReceber: Currency;
    bTEFZPOS: Boolean;
    iTotalParcelas: Integer;
  begin
    Result := False;
    bTEFZPOS := False;

    //FiContaCartao := 0;

    if FdTotalTransacionado > 0 then
    begin
      sCupom710 := TEFTextoImpressaoCupomAutorizado('710-'); // Texto cupom reduzido
      if AllTrim(sCupom710) <> '' then
      begin
        FsCupomReduzidoAutorizado := FsCupomReduzidoAutorizado + Chr(10) + TEFTextoImpressaoCupomAutorizado('711-') + DupeString('-', 40);

      end
      else
      begin
        sCupom712 := TEFTextoImpressaoCupomAutorizado('712-'); // Quantidade linhas via cliente
        if AllTrim(sCupom712) <> '' then
          FsCupomAutorizado := TEFTextoImpressaoCupomAutorizado('713'); // Texto via cliente
      end;

      sCupom714 := TEFTextoImpressaoCupomAutorizado('714-'); // Quantidade linhas via estabelecimento
      if AllTrim(sCupom714) <> '' then
      begin
        FsCupomAutorizado := FsCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('715-'); // Texto via estabelecimento
      end else
      begin
        FsCupomAutorizado := FsCupomAutorizado + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + TEFTextoImpressaoCupomAutorizado('029-'); // Indica o status da confirmação da transação
      end;

      if AllTrim(StrTran(FsCupomAutorizado,chr(10),'')) = '' then
        FsCupomAutorizado := '';

      if SuprimirLinhasEmBrancoDoComprovanteTEF then
      begin
        while AnsiContainsText(FsCupomAutorizado, chr(10) + chr(10)) do
          FsCupomAutorizado := StringReplace(FsCupomAutorizado, chr(10) + chr(10), chr(10), [rfReplaceAll]);
      end;

      Form1.fTEFPago := FdTotalTransacionado;
    end;// if dTotalTransacionado > 0 then

    if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes) then
    begin
      while True do
      begin
        Application.ProcessMessages;
        dValorPagarCartao := StrToFloatDef(Form1.Small_InputBox(PAGAMENTO_EM_CARTAO,'Valor do ' + IntToStr(FiContaCartao + 1) + 'º de ' + IntToStr(Form1.iNumeroMaximoDeCartoes) + ' cartões:', FormatFloat('0.00', dValorPagarCartao)), 0);

        dValorPagarCartao := StrToFloatDef(FormatFloat('0.00', dValorPagarCartao), 0); // Arredonda para 2 casas o valor informado

        if dValorPagarCartao < 0 then
        begin
          Application.MessageBox(PChar('Valor inválido: ' + FormatFloat('0.00', dValorPagarCartao)), 'Atenção', MB_ICONWARNING + MB_OK);
          dValorPagarCartao := FdTotalEmCartao - FdTotalTransacionado;
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

            if dValorPagarCartao <> FdTotalEmCartao then
              Application.MessageBox(PChar(FormatFloat('0.00', dValorPagarCartao) + ' é diferente do valor (' + FormatFloat('0.00', FdTotalEmCartao) + ') definido para forma de pagamento cartão' + #13 + #13 +
                                           'Acesse o Menu Configurações e ative o Modo Múltiplos Cartões para dividir o valor entre vários cartões'), 'Atenção', MB_ICONWARNING + MB_OK)
            else
              Break;

          end;
        end; // if dValorPagarCartao < 0 then
      end; // while True do
    end; // if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes) then

    if (FdTotalEmCartao - (FdTotalTransacionado + dValorPagarCartao)) < 0 then
    begin
      Application.MessageBox('Valor total da transação maior que o valor definido para a forma de pagamento cartão', 'Atenção', MB_ICONWARNING + MB_OK);
    end
    else // if (dTotalEmCartao - (dTotalTransacionado + dValorPagarCartao)) >= 0 then
    begin
      if dValorPagarCartao = 0 then
      begin
        //0 break
        //2024-11-08 Break;
        Exit;
      end
      else
      begin

        // 2024-12-05 FbConfirmarTransacao := False;
        if FbConfirmarTransacao then
          ConfirmaTransacaoTefAnterior;

        FfDescontoNoPremio := 0;

        //if Form1.bIniciarTEF then
        begin

          // Escolhe a bandeira
          if (Form1.ClienteSmallMobile.sVendaImportando = '') then
            Form1.Edit1.SetFocus;

          // Ativa o gerenciador padão
          AtivaGeranciadorPadrao(Form1.sDiretorioTEF, Form1.sReqTef, Form1.sRespTef, Form1.sExec, '');

          // Se não existe o arquivo INTPOS.STS na pasta RESP o gerenciador
          // não ativou atumaticamente e não esta ativo
          if not FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS') then
          begin

            if Form1.ClienteSmallMobile.ImportandoMobile then
            begin
              if Form1.sModeloECF_Reserva = '99' then
                Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar a movimentação')
              else
                Form1.ClienteSmallMobile.LogRetornoMobile('Altere a configuração do ' + ExtractFileName(Application.ExeName) + ' para trabalhar com PoS' + #13 + 'Não é possível efetuar venda')
            end
            else
            begin
              Application.ProcessMessages;
              Application.MessageBox('O gerenciador padrão do TEF não está ativo.','Operador',mb_Ok + MB_ICONEXCLAMATION);
            end;

            TEFLimparPastaRetorno('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef);
            DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001'));
            DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS'));

            Result := False;

          end else
          begin

            //deletando quando reenviar nfce rejeitada
            TEFLimparPastaRetorno('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef);
            DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001'));
            Sleep(100);
            // --------------------------------------------------------- //
            // CRT - Autorização para operação com cartão de crédito     //
            // --------------------------------------------------------- //
            AssignFile(F,'c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.TMP');
            Rewrite(F);

            if (Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat <> 0) then
            begin

              // Cheque 341029600100006505251087816289
              //CHQ Pedido de autorização para transação por meio de cheque
              WriteLn(F,'000-000 = CHQ');
              WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
              WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(Form1.ibDataSet25.FieldByname('ACUMULADO1').AsFloat)]))));             // Valor Total: 12c
            end else
            begin
              // CRT Pedido de autorização para transação por meio de cartão

              nTEFElginPergunta := -1;
              bTemElgin := False;
              if (TestarTEFSelecionado('ELGIN')) then
              begin                               //      Cartão                        PIX
                while (nTEFElginPergunta = -1) or ((nTEFElginPergunta <> 4) and (nTEFElginPergunta <> 12)) do
                  nTEFElginPergunta := MensagemSistemaPerguntaCustom('De que forma deseja finalizar o pagamento?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbAll, TMsgDlgBtn.mbRetry], ['Cartão','PIX']);

                bTemElgin := True;
              end;

              if (nTEFElginPergunta = 12) then
                WriteLn(F,'000-000 = PIX')
              else
                WriteLn(F,'000-000 = CRT');                                                     // Header: Cartão 3c

              WriteLn(F,'001-000 = '+StrTran(TimeToStr(Time),':',''));  // Identificação: Eu uso a hora
              WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(dValorPagarCartao)]))));             // Valor Total: 12c// Sandro Silva 2017-06-12  WriteLn(F,'003-000 = '+AllTrim(LimpaNumero(Format('%9.2n',[Abs(Form1.ibDataSet25.FieldByName('PAGAR').AsFloat)]))));             // Valor Total: 12c
            end;

            WriteLn(F,'004-000 = 0');             // Moeda: 0 - Real, 1 - Dolar americano
            WriteLn(F,'210-084 = SMALLSOF10');    // Nome da automação comercial (8 posições) + Capacidades da automação (1-preparada para tratar o desconto) + campo reservado, deve ser enviado 0
            AdicionaCNPJRequisicaoTEF(F, Form1.ibDataSet13); // ENVIO DE INFORMAÇÕES LIVRES 1-CNPJ do Estabelecimento Comercial; 2-CNPJ da Empresa de Automação Comercial // Sandro Silva 2019-08-13
            WriteLn(F,'701-000 = SMALL COMMERCE,  ' + Copy(LimpaNumero(Build), 1, 4) + ', 0, 2'); // Nome Completo da Automação Comercial  //Sandro Silva 2015-05-11 WriteLn(F,'701-000 = SMALL COMMERCE,  2014, 0, 2'); // Nome Completo da Automação Comercial
            WriteLn(F,'701-034 = 4');             // Capacidades da automação
            WriteLn(F,'706-000 = 2');             // Capacidades da automação
            WriteLn(F,'716-000 = ' + AnsiUpperCase(ConverteAcentos(Form1.sRazaoSocialSmallsoft))); // Razão Social da Empresa Responsável Pela Automação Comercial  // 2015-09-08 WriteLn(F,'716-000 = SMALLSOFT TECNOLOGIA EM INFORMATICA EIRELI'); // Razão Social da Empresa Responsável Pela Automação Comercial

            sCerto1 := StrTran(TimeToStr(Time),':','');

            //    WriteLn(F,'777-777 = TESTE REDECARD');                                                       // Teste 11 da REDECARD

            WriteLn(F,'999-999 = 0');                                                       // Trailer - REgistro Final, constante '0' .
            CloseFile(F);
            RenameFile('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.TMP','c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001');
            // ---------------------------------------- //
            {Sandro Silva (smal-778) 2024-11-28 inicio
            for I := 1 to 12000 do
            begin
              Application.ProcessMessages;
              if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
                Sleep(10);
            end;
            }
            for I := 1 to 12000 do
            begin
              Application.ProcessMessages;
              if not FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS') then
                Sleep(10)
              else
                Break;
            end;
            {Sandro Silva (smal-778) 2024-11-28 fim}

            // teste anderson Center System
            Form1.Top    := 0;
            Form1.Left   := 0;
            Form1.Width  := 1;
            Form1.Height := 1;

            ModalidadeTransacao := tModalidadeCartaoTEF; // Sandro Silva 2024-11-27 tModalidadeCartao;

            if FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS')  then
            begin

              while not FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001') do
              begin

                bOk := True;
                while bOk do
                begin
                  Application.ProcessMessages;
                  Sleep(100);
                  // ----------------------------- //
                  // Verifica se é o arquivo certo //
                  // ----------------------------- //
                  if FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001') then
                  begin

                    AssignFile(F,'c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001');
                    Reset(F);

                    while not eof(F) Do
                    begin
                      ReadLn(F,Form1.sLinha);
                      Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
                      if Copy(Form1.sLinha,1,7) = '001-000' then
                        sCerto := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));

                      if Copy(Form1.sLinha,1,3) = '999' then
                        bOk := False;
                    end;

                    CloseFile(F);
                    Sleep(100);

                    if sCerto <> sCerto1 then // Valida se está processando o arquivo de retorno esperado
                    begin
                      DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001'));
                      bOk := True;
                      Sleep(1000);
                    end;

                  end; // if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') then
                  // ----------------------------- //
                  // Verifica se é o arquivo certo //
                  // ----------------------------- //
                end; // while bOk do

              end;    // Teste // while not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.001') do

              Form1.Repaint;

              sMensagem := '';

              if FileExists('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001') then
              begin

                Form1.Top    := 0;
                Form1.Left   := 0;
                Form1.Width  := Screen.Width;
                Form1.Height := Screen.Height;

                // Backup do intpos.001
                CopyFile(pChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001'),pChar('c:\'+Form1.sDiretorioTEF+'.RES'), False); // bFailIfExists deve ser False para sobrescrever se existe

                AssignFile(F,'c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001');
                Reset(F);

                Form1.sParcelas   := '0';
                Form1.sValorTot   := '';
                Form1.sValorSaque := '';
                Form1.sNomeRedeParaTransacoesTEF := ''; // Sandro Silva 2024-12-05 Form1.sNomeRede   := '';
                Form1.sNomeRedeTransacionada     := '';
                Form1.sTransacaTEF   := ''; // Sandro Silva 2024-12-06 Form1.sTransaca   := '';
                Form1.sTransacaPOS   := '';
                Form1.sAutoriza   := '';
                Form1.sFinaliza   := '';
                Form1.sLinha      := '';

                sCupom          := '';
                sCupom029       := '';
                sCupom710       := '';
                sCupom711       := '';
                sCupom712       := '';
                sCupom713       := '';
                sCupom714       := '';
                sCupom715       := '';

                sRespostaTef := ''; // Inicia vazia para capturar linhas da resposta do tef

                bTEFZPOS := (RetornoDoZPOS('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001'));

                if (not bTEFZPOS) or (TestarZPOSLiberado(Form1.IBDatabase1)) then // Sandro Silva (smal-778) 2024-11-19 if (not bTEFZPOS) or (TestarZPOSLiberado) then
                begin
                  while not Eof(f) Do
                  begin

                    ReadLn(F,Form1.sLinha);

                    sRespostaTef := sRespostaTef + #13 + Form1.sLinha;

                    Form1.sLinha := StrTran(Form1.sLinha,chr(0),' ');
                    if Copy(Form1.sLinha,1,7) = '003-000' then Form1.sValorTot   := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
                    if Copy(Form1.sLinha,1,7) = '200-000' then Form1.sValorSaque := StrTran(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)),',','');
                    if Copy(Form1.sLinha,1,7) = '010-000' then Form1.sNomeRedeParaTransacoesTEF   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));//Sandro Silva 2024-12-05 if Copy(Form1.sLinha,1,7) = '010-000' then Form1.sNomeRede   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,7) = '009-000' then Form1.OkSim       := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransacaTEF:= RightStr(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)), 11); //Sandro Silva 2024-12-06 if Copy(Form1.sLinha,1,7) = '012-000' then Form1.sTransaca   := RightStr(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)), 11);
                    if Copy(Form1.sLinha,1,7) = '013-000' then Form1.sAutoriza   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,7) = '027-000' then Form1.sFinaliza   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,7) = '017-000' then Form1.sTipoParc   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)); // 0: parcelado pelo Estabelecimento; 1: parcelado pela ADM.
                    if Copy(Form1.sLinha,1,7) = '018-000' then Form1.sParcelas   := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,7) = '028-000' then sBotaoOk          := AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9));
                    if Copy(Form1.sLinha,1,4) = '029-'    then sCupom029         := sCupom029 + DesconsideraLinhasEmBranco(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10)); // Sandro Silva 2023-10-24 if Copy(Form1.sLinha,1,4) = '029-'    then sCupom029         := sCupom029 + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','') + chr(10);
                    if Copy(Form1.sLinha,1,4) = '030-'    then sMensagem         := sMensagem + StrTran(Copy(Form1.sLinha,11,Length(Form1.sLinha)-10),'"','');

                    if Copy(Form1.sLinha,1,7) = '709-000' then
                    begin

                      FfDescontoNoPremio := StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9))) / 100;
                      Form1.ibDataSet25.FieldByName('RECEBER').AsFloat    := Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - FfDescontoNoPremio;
                      Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := dValorPagarCartao - Form1.fDescontoNoTotal - FfDescontoNoPremio;
                      RecuperaValoresFormasExtras;

                      Form1.ibDataSet27.Append; // Desconto
                      Form1.ibDataSet27.FieldByName('TIPO').AsString      := 'BALCAO';
                      Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := FormataNumeroDoCupom(Form1.icupom);
                      Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Desconto'; // Desconto no cartão
                      Form1.ibDataSet27.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                      Form1.ibDataSet27.FieldByName('HORA').AsString      := Copy(Form1.sHoraDoCupom,7,2)+':'+Copy(Form1.sHoraDoCupom,9,2)+':'+Copy(Form1.sHoraDoCupom,11,2);
                      if Form1.sModeloECF = '65' then
                        Form1.ibDataSet27.FieldByName('HORA').AsString      := FormatDateTime('HH:nn:ss', Time);
                      Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := 1;
                      Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat   := (Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - Form1.fTotal);
                      Form1.ibDataSet27.FieldByName('TOTAL').AsFloat      := TruncaDecimal(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat, Form1.iTrunca);
                      Form1.ibDataSet27.FieldByName('CAIXA').AsString     := Form1.sCaixa;
                      Form1.ibDataSet27.Post;

                      Form1.Memo1.Lines.Add('DESCONTO R$  '+Format('%10.2n',[Form1.fTotal - Form1.ibDataSet25.FieldByName('RECEBER').AsFloat]));
                    end;

                    if Copy(Form1.sLinha,1,7) = '210-081' then
                    begin

                      FfDescontoNoPremio := Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - StrToFloat(AllTrim(Copy(Form1.sLinha,10,Length(Form1.sLinha)-9)));
                      Form1.ibDataSet25.FieldByName('RECEBER').AsFloat    := Form1.fTotal - FfDescontoNoPremio;
                      Form1.ibDataSet25.FieldByName('PAGAR').AsFloat      := FdTotalTransacionado;
                      RecuperaValoresFormasExtras;

                      Form1.ibDataSet27.Append; // Desconto
                      Form1.ibDataSet27.FieldByName('TIPO').AsString      := 'BALCAO';
                      Form1.ibDataSet27.FieldByName('PEDIDO').AsString    := FormataNumeroDoCupom(Form1.icupom);
                      Form1.ibDataSet27.FieldByName('DESCRICAO').AsString := 'Desconto'; // Desconto no cartão
                      Form1.ibDataSet27.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                      Form1.ibDataSet27.FieldByName('HORA').AsString      := Copy(Form1.sHoraDoCupom,7,2)+':'+Copy(Form1.sHoraDoCupom,9,2)+':'+Copy(Form1.sHoraDoCupom,11,2);

                      if Form1.sModeloECF = '65' then
                        Form1.ibDataSet27.FieldByName('HORA').AsString      := FormatDateTime('HH:nn:ss', Time);

                      Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat := 1;
                      Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat   := (Form1.ibDataSet25.FieldByName('RECEBER').AsFloat - Form1.fTotal);
                      Form1.ibDataSet27.FieldByName('TOTAL').AsFloat      := TruncaDecimal(Form1.ibDataSet27.FieldByName('QUANTIDADE').AsFloat * Form1.ibDataSet27.FieldByName('UNITARIO').AsFloat, Form1.iTrunca);
                      Form1.ibDataSet27.FieldByName('CAIXA').AsString     := Form1.sCaixa;
                      Form1.ibDataSet27.Post;

                      Form1.Memo1.Lines.Add('DESCONTO R$  '+Format('%10.2n',[Form1.fTotal - Form1.ibDataSet25.FieldByName('RECEBER').AsFloat]));

                    end;

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

                    // Venda com pagamento no CARTAO //

                  end; // while not Eof(f) Do

                  Form1.sNomeRedeTransacionada   := Form1.sNomeRedeParaTransacoesTEF;

                end
                else
                  sMensagem := 'Serial sem acesso à esse recurso. Entre em contato com sua revenda.';

                CloseFile(F);

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
                  ModalidadeTransacao := tModalidadeCartaoTEF; // Sandro Silva 2024-11-27 tModalidadeCartao;
                end
                else
                begin
                  Form1.sDebitoOuCredito := 'CREDITO';
                  ModalidadeTransacao := tModalidadeCartaoTEF; // Sandro Silva 2024-11-27 tModalidadeCartao;
                end;

                // Quais vias serão impressas conforme fluxo

                // sCupom é o que vai ser impresso

                if AllTrim(sCupom710) <> '' then
                begin
                  Form1.sCupomTEFReduzido := Form1.sCupomTEFReduzido + Chr(10) + sCupom711 + DupeString('-', 40);
                end else
                begin
                  if AllTrim(sCupom712) <> '' then
                    sCupom := sCupom713;
                end;

                if AllTrim(sCupom714) <> '' then
                begin
                  sCupom := sCupom + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + sCupom715;
                end else
                begin
                  sCupom := sCupom + IfThen(SuprimirLinhasEmBrancoDoComprovanteTEF, Chr(10), chr(10) + chr(10) + chr(10)) + sCupom029;
                end;

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
                  RecuperaValoresFormasExtras;
                  Form1.ibDataSet25.Post;
                  Form1.ibDataSet25.FieldByName('ACUMULADO3').ReadOnly := True;
                  Form1.bFlag2 := False; // TEFMultiplosCartoes(

                end;

                if (sMensagem = 'Cancelada pelo operador') and (Form1.OkSim='FF') then
                begin
                  DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001'));
                end;

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
                      Sleep(1);
                    end;
                    Form1.Repaint;
                    if allTrim(sMensagem) <> 'CHEQUE SEM RESTRICAO' then
                      SmallMsgBox(pChar(sMensagem),'Operador',mb_Ok + MB_ICONEXCLAMATION);

                  end;

                end;

              end;
            end; // if FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS')  then

            if (Form1.sNomeRedeParaTransacoesTEF <> '') and (sCupom <> '') then // Sandro Silva 2024-12-05 if (Form1.sNomeRede <> '') and (sCupom <> '') then
            begin
              // Transação feita
              Inc(FiContaCartao);

              FbConfirmarTransacao := True;

              {Dailon Parisotto (f-19886) 2024-07-25 Inicio}
              if (bTemElgin) and (Form1.sCupomTEF <> EmptyStr) then
                Form1.sCupomTEF := Form1.sCupomTEF + chr(10);
              if (bTemElgin) and (Form1.sCupomTEF = EmptyStr) then
                Form1.sCupomTEF := chr(10) + Form1.sCupomTEF;
              {Dailon Parisotto (f-19886) 2024-07-25 Fim}
              Form1.sCupomTEF := Form1.sCupomTEF + sCupom + DupeString('-', 40);

              if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não
              begin
                if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then
                begin
                  if FiContaCartao = 1 then // Quando for o primeiro cartão apaga todas as parcelas do cupom
                  begin

                    // Apaga as duplicatas anteriores
                    try
                      //
                      Form1.ibDataSet99.Close;
                      Form1.ibDataSet99.SelectSQL.Clear;
                      Form1.ibDataSet99.SelectSQL.Add('delete from RECEBER where NUMERONF='+QuotedStr(CupomComCaixaFormatado)+ ' and EMISSAO='+ QuotedStr(DateToStrInvertida(Date)) + ' ');
                      Form1.ibDataSet99.Open;
                    except
                      on E: Exception do
                      begin
                        SmallMsg('Erro! '+E.Message);
                      end;
                    end;
                  end;

                  //Sandro Silva 2024-12-05 Form1.TransacoesCartao.Transacoes.Adicionar(Form10.sNomeDoTEF, Form1.sDebitoOuCredito, dValorPagarCartao, Form1.sNomeRede, Form1.sTransaca, Form1.sAutoriza, Form1.IntegradorCE.TransacaoFinanceira.Tipo, ModalidadeTransacao);
                  Form1.TransacoesCartao.Transacoes.Adicionar(Form10.sNomeDoTEF, Form1.sDebitoOuCredito, dValorPagarCartao, Form1.sNomeRedeParaTransacoesTEF, Form1.sTransacaTEF, Form1.sAutoriza, Form1.IntegradorCE.TransacaoFinanceira.Tipo, ModalidadeTransacao);

                  iParcelas := 1;

                  if (StrToIntDef(Trim(Form1.sTipoParc), 0) = 0) and (StrToIntDef(Trim(Form1.sParcelas), 0) > 1) then
                    iParcelas := StrtoIntDef(Trim(Form1.sParcelas), 0); // Se parcelado pelo estabecimento cria mais de uma parcela no CONTAS a RECEBER

                  dTotalTransacaoTEF := 0.00;
                  for I := 1 to iParcelas do
                  begin
                    try
                      dValorDuplReceber := StrToFloat(FormatFloat('0.00', (Int(((StrtoInt(Form1.sValorTot) / 100) /iParcelas) * 100) / 100))); // Sandro Silva 2018-04-25
                      iTotalParcelas := iTotalParcelas + 1;

                      Form1.ibDataSet7.Append;
                      Form1.ibDataSet7.FieldByName('NOME').AsString         := Form1.sNomeRedeParaTransacoesTEF; // Sandro Silva 2024-12-05 Form1.ibDataSet7.FieldByName('NOME').AsString         := Form1.sNomeRede;
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' tran.' + Form1.sTransacaTEF; // Sandro Silva 2024-12-06 Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' tran.' + Form1.sTransaca;
                      Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(iTotalParcelas);
                      Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := dValorDuplReceber;
                      Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := Date;
                      if AnsiContainsText(Form1.sDebitoOuCredito, 'CREDITO') then
                        Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoCredito * I)
                      else
                        Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoDebito * I);
                      Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form1.sNomeRedeParaTransacoesTEF; // Sandro Silva 2024-12-05 Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form1.sNomeRede;
                      if ModalidadeTransacao in [tModalidadeCarteiraDigital, tModalidadePix] then
                      begin
                        {Sandro Silva 2024-12-05 inicio
                        if ModalidadeTransacao = tModalidadeCarteiraDigital then
                          Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRede + ' Cart.Digital', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                        if ModalidadeTransacao = tModalidadePix then
                          Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRede + ' Pagto.Instantaneo', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                        }
                        if ModalidadeTransacao = tModalidadeCarteiraDigital then
                          Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRedeParaTransacoesTEF + ' Cart.Digital', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                        if ModalidadeTransacao = tModalidadePix then
                          Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Copy(Form1.sNomeRedeParaTransacoesTEF + ' Pagto.Instantaneo', 1, Form1.ibDataSet7.FieldByName('PORTADOR').Size);
                        {Sandro Silva 2024-12-05 fim}
                        Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date;
                      end;
                      Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0;
                      Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0;
                      Form1.ibDataSet7.Post;
                      dTotalTransacaoTEF := dTotalTransacaoTEF + Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat; // Sandro Silva 2017-08-29
                    except
                    end;
                  end; // for I := 1 to iParcelas do

                  Form1.AjustarDiferencaParcelasCartao(dTotalTransacaoTEF, dValorPagarCartao, iTotalParcelas, iParcelas);

                end; //
              end;

              FdTotalTransacionado   := FdTotalTransacionado + StrToFloat(FormatFloat('0.00', (StrToIntDef(Form1.sValorTot, 0) / 100))); // Sandro Silva 2017-06-12
              Form1.fTEFPago         := Form1.fTEFPago + dValorPagarCartao;
              Form1.fDescontoNoTotal := Form1.fDescontoNoTotal + FfDescontoNoPremio;

              // Ajusta valor da diferença para receber em dinheiro
              if Form1.ibDataSet25.State in [dsEdit, dsInsert] = False then
                Form1.ibDataSet25.Edit;
              Form1.ibDataSet25.FieldByName('PAGAR').AsFloat := FdTotalTransacionado;
              RecuperaValoresFormasExtras;
              Result := True;

            end else
            begin
              // Transação Não feita
              Result := False;
              DeleteFile(pChar(DIRETORIO_BKP_TEF+'\'+Form1.sDiretorioTEF+IntToStr(FiContaCartao + 1)+'.BKP'));
              // Apaga arquivo de bkp não autorizados quando 2 gerenciadores diferentes
              // Evitar que tente cancelar transação não confirmada. Ex.:  030-000 = Sitef fora do ar
              DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.001'));
              DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sRespTef+'\INTPOS.STS'));
              DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\IntPos.tmp'));
              DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'\'+Form1.sReqTef+'\INTPOS.001'));
              DeleteFile(PChar('c:\'+Form1.sDiretorioTEF+'.res'));
            end; // if (Form1.sNomeRede <> '') and (sCupom <> '') then

            if Result then
            begin
              if FdTotalEmCartao - FdTotalTransacionado > 0 then
              begin
                // Ainda há valor para transacionar com outros cartões

                //Marcar para confirmar antes do próximo valor ser transacionado
                FbConfirmarTransacao := True;

                // 2015-10-08 Sleep deixa muito tempo de intervalo entre a hora impressa e a DEMAIS.HORA Demais('CC');

              end;
            end;
            //
          end; // if not FileExists('c:\'+Form1.sDiretorio+'\'+Form1.sRESP+'\INTPOS.STS') then
        end; // if bIniciarTEF then
      end; // if dValorPagarCartao = 0 then
    end; // if dTotalEmCartao < dTotalTransacionado then

    if Result = True then
    begin
      Form1.sCupomTEF := FsCupomReduzidoAutorizado + Form1.sCupomTEFReduzido + FsCupomAutorizado + Form1.sCupomTEF;
      (*Sandro Silva 2024-12-06
      // Ajuste para situação do TEF Elgin que pode ficar uma quebra linha no inicio.
      // Neste caso irá remover a quebra linha do inicio do arquivo caso exista.
      {Dailon Parisotto (f-19886) 2024-07-25 Inicio}
      if Pos(chr(10), Form1.sCupomTEF) = 1 then
        Form1.sCupomTEF := Copy(Form1.sCupomTEF, 2, Length(Form1.sCupomTEF));
      {Dailon Parisotto (f-19886) 2024-07-25 Fim}
      *)
    end;
    // ---------------------------------------------- //
    // Transferência Eletrônica de Fundos (TEF)       //
    // Suporte Técnico Com - SevenPedv  (011)2531722  //
    // Suporte do PinPad - VeriFone (011)8228733      //
    // com Kiochi Matsuda                             //
    // (0xx11)253-1722                                //
    // ---------------------------------------------- //
  end;

  function TransacaoComPoS(TipoConexaoPOS: TTipoConexaoPOS): Boolean;
  var
    bPoSok: Boolean;
    iParcelas: Integer;
    dTotalTransacaoPOS: Currency;
    iTotalParcelas: Integer;
    ModalidadeTransacao: TTipoModalidadeTransacao;
  begin
    // Usando PoS para transação com cartão

    Result := False;

    //FiContaCartao        := 0;

    ModalidadeTransacao := tModalidadeCartaoPOS; // Sandro Silva 2024-11-27 tModalidadeCartao;

    //while FdTotalTransacionado < FdTotalEmCartao do // Enquanto não totalizar transações com valor devido
    //begin

      if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then
      begin
        dValorPagarCartao := FdTotalEmCartao - FdTotalTransacionado;

        if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes)
          and (Form1.ClienteSmallMobile.sVendaImportando = '')
        then
        begin

          while True do
          begin
            Application.ProcessMessages;
            dValorPagarCartao := StrToFloatDef(Form1.Small_InputBox(PAGAMENTO_EM_CARTAO,'Informe o valor para pagamento com o ' + IntToStr(FiContaCartao + 1) + 'º de ' + IntToStr(Form1.iNumeroMaximoDeCartoes) + ' cartões:', FormatFloat('0.00', dValorPagarCartao)), 0);

            dValorPagarCartao := StrToFloatDef(FormatFloat('0.00', dValorPagarCartao), 0);

            if dValorPagarCartao < 0 then
            begin
              Application.MessageBox(PChar('Valor inválido: ' + FormatFloat('0.00', dValorPagarCartao)), 'Atenção', MB_ICONWARNING + MB_OK);
              dValorPagarCartao := FdTotalEmCartao - FdTotalTransacionado;
            end
            else
            begin
              if Form1.bModoMultiplosCartoes then
              begin
                if dValorPagarCartao >= 0 then
                begin
                  Break;
                end;
              end
              else
              begin

                if dValorPagarCartao <> FdTotalEmCartao then
                begin
                  Application.MessageBox(PChar(FormatFloat('0.00', dValorPagarCartao) + ' é diferente do valor (' + FormatFloat('0.00', FdTotalEmCartao) + ') definido para forma de pagamento cartão' + #13 + #13 +
                                               'Acesse o Menu Configurações e ative o Modo Múltiplos Cartões para dividir o valor entre vários cartões'), 'Atenção', MB_ICONWARNING + MB_OK)
                end
                else
                begin
                  Break;
                end;
              end;
            end; // if dValorPagarCartao < 0 then
          end; // while True do

        end; // if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes) then

      end
      else
      begin
        dValorPagarCartao := FdTotalEmCartao;
      end; // if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Sandro Silva 2016-04-29

      if (FdTotalEmCartao - (FdTotalTransacionado + dValorPagarCartao)) < 0 then
      begin
        Application.MessageBox('Valor total da transação maior que o valor definido para a forma de pagamento cartão', 'Atenção', MB_ICONWARNING + MB_OK);
      end
      else // if (FdTotalEmCartao - (FdTotalTransacionado + dValorPagarCartao)) >= 0 then
      begin
        if dValorPagarCartao = 0 then
        begin
          //2024-11-08 Break;
          Exit;
        end
        else
        begin

          bPoSok := True;

          if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não
          begin
            //
            if bPoSOk then
            begin
              //
              // Só deve entrar aqui se não usar integrador fiscal ou integrador fiscal retornar True
              //
              if (Form1.ClienteSmallMobile.sVendaImportando = '') then
              begin
                Form10.TipoForm := tfPOS;
                if Form1.PosElginPay.PermiteUsarPOS then
                  if (Form1.PosElginPay.Configuracao.NomePOS = NOME_POS_ONLINE_ELGIN) and (Form1.PosElginPay.Configuracao.Ativo = 'Sim') then
                    TipoConexaoPOS := tcxPosOnlineElginPay;

                if TipoConexaoPOS = tcxPosOnlineElginPay then
                begin
                  Form1.ExibePanelMensagem('Aguardando pagamento no POS', True);

                  bPoSok := Form1.PosElginPay.EfetuaPagamento(Form1.sCaixa, dValorPagarCartao);

                  if bPoSok then
                  begin
                    {Sandro Silva 2024-12-06 inicio
                    if AnsiContainsText(Form1.PosElginPay.Transacao.TipoCartao, 'CARTAO_DEBITO') then
                      Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' DEBITO'
                    else
                      Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' CREDITO';
                    Form1.sTransaca   := Form1.PosElginPay.Transacao.Transacao;
                    Form1.sAutoriza   := IfThen(Form1.UsaIntegradorFiscal(), Form1.sTransaca, '');
                    Form1.sNomeRede   := Form1.PosElginPay.Transacao.Rede;
                    Form1.sNomeRedeTransacionada     := Form1.PosElginPay.Transacao.Rede;

                    Form1.sTipoParc   := '0';// Considera sempre parcelado pelo estabelecimento poderia validar com AnsiContainsText(ValorElementoElginPayFromJson(sResposta, '"tipoFinanciamento":'), 'ESTABELECIMENTO')
                    Form1.sParcelas   := Form1.PosElginPay.Transacao.Parcelas;
                    if Form1.sParcelas = '0' then
                      Form1.sParcelas := '1';
                    }
                    if AnsiContainsText(Form1.PosElginPay.Transacao.TipoCartao, 'CARTAO_DEBITO') then
                      Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' DEBITO'
                    else
                      Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' CREDITO';
                    Form1.sTransacaTEF  := Form1.PosElginPay.Transacao.Transacao;
                    Form1.sAutoriza     := IfThen(Form1.UsaIntegradorFiscal(), Form1.sTransacaTEF, '');
                    Form1.sNomeRedeParaTransacoesTEF := Form1.PosElginPay.Transacao.Rede;
                    Form1.sNomeRedeTransacionada     := Form1.PosElginPay.Transacao.Rede;

                    Form1.sTipoParc   := '0';// Considera sempre parcelado pelo estabelecimento poderia validar com AnsiContainsText(ValorElementoElginPayFromJson(sResposta, '"tipoFinanciamento":'), 'ESTABELECIMENTO')
                    Form1.sParcelas   := Form1.PosElginPay.Transacao.Parcelas;
                    if Form1.sParcelas = '0' then
                      Form1.sParcelas := '1';
                    {Sandro Silva 2024-12-06 fim}


                  end
                  else
                    SmallMessageBox(Form1.PosElginPay.Transacao.MensagemOperador, 'Atenção', MB_OK + MB_ICONWARNING);

                  Form1.ExibePanelMensagem(Form1.PosElginPay.Transacao.MensagemOperador, True);

                end
                else
                begin
                  {
                  Form1.ExibePanelMensagem('Selecionando Bandeira do cartão', True);

                  Form10.ShowModal;
                  if Form10.ModalResult <> mrOk then
                    bPosOk := False;
                  }

                  if not(AplicaOpcaoPosEscolhida(Form1.sNomeRedeTransacionada)) then // Sandro Silva 2024-12-05 if not(AplicaOpcaoPosEscolhida(Form1.sNomeRede)) then
                  begin
                    bPoSok := False;
                  end;

                end;
              end;

            end;// if bPoSOk then // Sandro Silva 2018-07-03

            if bPoSok then
            begin
              if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then
              begin
                if (FiContaCartao + 1) = 1 then // Quando for o primeiro cartão apaga todas as parcelas do cupom
                begin
                  // Apaga as duplicatas anteriores
                  try
                    Form1.ibDataSet99.Close;
                    Form1.ibDataSet99.SelectSQL.Clear;
                    Form1.ibDataSet99.SelectSQL.Add('delete from RECEBER where NUMERONF='+QuotedStr(CupomComCaixaFormatado)+ ' and EMISSAO='+ QuotedStr(DateToStrInvertida(Date)) + ' ');
                    Form1.ibDataSet99.Open;
                  except
                    on E: Exception do
                    begin
                      SmallMsg('Erro! '+E.Message);
                    end;
                  end;
                end;

                //Ficha 3403
                dTotalTransacaoPOS := 0;
                for iParcelas := 1 to StrToIntDef(Form1.sParcelas, 1) do
                begin
                  {Sandro Silva 2024-12-06 inicio
                  try
                    iTotalParcelas := iTotalParcelas + 1;// Sandro Silva 2017-08-28 Acumula as parcelas entre os diferentes cartões usados para gerar as parcelas na sequência
                    Form1.ibDataSet7.Append;
                    Form1.ibDataSet7.FieldByName('NOME').AsString         := StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO','');
                    if Form1.ClienteSmallMobile.ImportandoMobile then
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' Aut.' + Form1.sTransaca
                    else
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := PREFIXO_HISTORICO_TRANSACAO_POS + ': ' + IntToStr(FiContaCartao + 1) + 'º CARTAO'; // Sandro Silva (smal-778) 2024-11-25 Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'VENDA NO CARTAO: ' + IntToStr(FiContaCartao + 1) + 'º CARTAO';
                    Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(iTotalParcelas); // documento
                    Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := StrToFloat(FormatFloat('0.00', (Int((dValorPagarCartao / StrToIntDef(Form1.sParcelas, 1)) * 100) / 100)));// Truncando 2 casas decimais
                    Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                    if AnsiContainsText(Form10.sNomedoTef, 'CREDITO') then
                      Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoCredito * iParcelas)
                    else
                      Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoDebito * iParcelas);
                    Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form10.sNomeDoTEF;
                    Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0.00; // Deixar nulo não exibe as contas em "Exibir> A vencer"
                    Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0.00; // Deixar nulo não exibe as contas em "Exibir> A vencer"
                    Form1.ibDataSet7.Post;
                    dTotalTransacaoPOS := dTotalTransacaoPOS + Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat;
                  except
                  end;
                  }
                  try
                    iTotalParcelas := iTotalParcelas + 1;// Sandro Silva 2017-08-28 Acumula as parcelas entre os diferentes cartões usados para gerar as parcelas na sequência
                    Form1.ibDataSet7.Append;
                    Form1.ibDataSet7.FieldByName('NOME').AsString         := StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO','');
                    if Form1.ClienteSmallMobile.ImportandoMobile then
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' Aut.' + Form1.sTransacaPOS
                    else
                      Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := PREFIXO_HISTORICO_TRANSACAO_POS + ': ' + IntToStr(FiContaCartao + 1) + 'º CARTAO'; // Sandro Silva (smal-778) 2024-11-25 Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'VENDA NO CARTAO: ' + IntToStr(FiContaCartao + 1) + 'º CARTAO';
                    Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(iTotalParcelas); // documento
                    Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := StrToFloat(FormatFloat('0.00', (Int((dValorPagarCartao / StrToIntDef(Form1.sParcelas, 1)) * 100) / 100)));// Truncando 2 casas decimais
                    Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                    if AnsiContainsText(Form10.sNomedoTef, 'CREDITO') then
                      Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoCredito * iParcelas)
                    else
                      Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoDebito * iParcelas);
                    Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form10.sNomeDoTEF;
                    Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0.00; // Deixar nulo não exibe as contas em "Exibir> A vencer"
                    Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0.00; // Deixar nulo não exibe as contas em "Exibir> A vencer"
                    Form1.ibDataSet7.Post;
                    dTotalTransacaoPOS := dTotalTransacaoPOS + Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat;
                  except
                  end;
                  {Sandro Silva 2024-12-06 fim}

                end;// for iParcelas := 1 to StrToIntDef(Form1.sParcelas, 1) do

                Form1.AjustarDiferencaParcelasCartao(dTotalTransacaoPOS, dValorPagarCartao, iTotalParcelas, StrToIntDef(Form1.sParcelas, 1));

              end; // if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Sandro Silva 2016-04-29
              Inc(FiContaCartao);

            end; //if bPoSok then

          end; // if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não

          Form1.ExibePanelMensagem('', True);

          if bPoSok then
          begin
            //Sandro Silva 2024-12-05 Form1.TransacoesCartao.Transacoes.Adicionar(Form1.sNomeRede, IfThen(Pos('DEBITO', ConverteAcentos(AnsiUpperCase(Form10.sNomeDoTEF))) > 0, 'DEBITO', 'CREDITO'), dValorPagarCartao, Form10.sNomeAdquirente, Form1.sTransaca, Form1.sAutoriza, StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO',''), ModalidadeTransacao);
            Form1.TransacoesCartao.Transacoes.Adicionar(Form1.sNomeRedeTransacionada, IfThen(Pos('DEBITO', ConverteAcentos(AnsiUpperCase(Form10.sNomeDoTEF))) > 0, 'DEBITO', 'CREDITO'), dValorPagarCartao, Form10.sNomeAdquirente, Form1.sTransacaPOS, Form1.sAutoriza, StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO',''), ModalidadeTransacao);

            FdTotalTransacionado := FdTotalTransacionado + dValorPagarCartao;
            Form1.fTEFPago      := Form1.fTEFPago + dValorPagarCartao;
            if Form1.ibDataSet25.State in [dsEdit, dsInsert] = False then
              Form1.ibDataSet25.Edit;
            Form1.ibDataSet25.FieldByName('PAGAR').AsFloat := FdTotalTransacionado;
            RecuperaValoresFormasExtras;
          end;

        end;// if dValorPagarCartao = 0 then
      end; // if (FdTotalEmCartao - (FdTotalTransacionado + dValorPagarCartao)) < 0 then

      {
      if Form1.bModoMultiplosCartoes = False then
      begin
        Break;
      end;

      if (FiContaCartao >= Form1.iNumeroMaximoDeCartoes) then
        Break;

      if (Form1.sModeloECF = '59') then
      begin
        // SAT permite apenas 10 grupos de meios de pagamento
        if FiContaCartao >= 10 then
          Break;
      end;
      }
    //end; // while FdTotalTransacionado < FdTotalEmCartao do

  end;

  procedure DeletaTrasacaoPosDoReceber;
  begin
    Form1.ibDataSet7.First;
    while Form1.ibDataSet7.Eof = False do
    begin
      if AnsiContainsText(Form1.ibDataSet7.FieldByName('HISTORICO').AsString, PREFIXO_HISTORICO_TRANSACAO_POS) then
        Form1.ibDataSet7.Delete
      else
        Form1.ibDataSet7.Next;
    end;
  end;
begin
  Result := False;

  FFormasExtras := TPagamentoPDV.Create;

  FFormasExtras.Extra1 := Form1.ibDataSet25.FieldByName('VALOR01').AsFloat;
  FFormasExtras.Extra2 := Form1.ibDataSet25.FieldByName('VALOR02').AsFloat;
  FFormasExtras.Extra3 := Form1.ibDataSet25.FieldByName('VALOR03').AsFloat;
  FFormasExtras.Extra4 := Form1.ibDataSet25.FieldByName('VALOR04').AsFloat;
  FFormasExtras.Extra5 := Form1.ibDataSet25.FieldByName('VALOR05').AsFloat;
  FFormasExtras.Extra6 := Form1.ibDataSet25.FieldByName('VALOR06').AsFloat;
  FFormasExtras.Extra7 := Form1.ibDataSet25.FieldByName('VALOR07').AsFloat;
  FFormasExtras.Extra8 := Form1.ibDataSet25.FieldByName('VALOR08').AsFloat;
  //FdTotalEmCartao      := Form1.ibDataSet25.FieldByName('PAGAR').AsFloat;

  //FdTotalTransacionado := TEFValorTotalAutorizado();

  FdTotalEmCartao := Form1.ibDataSet25.FieldByName('PAGAR').AsFloat;
  //FiContaCartao   := 0;
  Form1.TransacoesCartao.Transacoes.Clear;
  //bConfirmarTransacao := False;

  Form1.fTEFPago := TEFValorTotalAutorizado();
  FdTotalTransacionado := Form1.fTEFPago; // TEFValorTotalAutorizado();
  FiContaCartao   := Form1.TransacoesCartao.Transacoes.Count;

  DeletaTrasacaoPosDoReceber;

  //2024-11-29 FsCupomReduzidoAutorizado := '';
  FsCupomAutorizado         := '';

  //iTotalParcelas := 0;

  if FdTotalEmCartao = FdTotalTransacionado then
  begin
    Result := True;
  end
  else
  begin

    TipoTransacao := TTipoTransacaoTefPos.Create;

    while FdTotalTransacionado < FdTotalEmCartao do // Enquanto não totalizar transações com valor devido
    begin

      dValorPagarCartao := FdTotalEmCartao - FdTotalTransacionado;

      //2024-12-05      ConfirmaTransacaoTefAnterior;

      Form1.ExibePanelMensagem('', True);

      {
      if TFrmOpcoesFechamentoComCartao.CriaForm(TipoTransacao) = mrCancel then
       Break;
      }
      if TFrmOpcoesFechamentoComCartao.CriaForm(TipoTransacao) = mrCancel then
      begin
        Result := False;
        Break;
      end;

      case TipoTransacao.Tipo of
        tpTEF:
        begin
          FsCupomReduzidoAutorizado := ''; //2024-11-29
          Form1.sCupomTEFReduzido := '';// 2024-12-06
          Result := TransacionaComTEF;
        end;

        tpPOS:
        begin

          if (Form1.sIdentificaPOS = 'Sim') and (Trim(Form1.sNomeRedeTransacionada) = '') then // Sandro Silva 2024-12-05 if (Form1.sIdentificaPOS = 'Sim') and (Trim(Form1.sNomeRede) = '') then
          begin
            SmallMessageBox(PChar('Acesse F10-Menu/Configurações/Cartões de débito e crédtio (POS)' + #13 + #13 +
              'Cadastre os Cartões de Crédito e Débito (POS) com a bandeira' + #13 + #13 +
              'Exemplo:' + #13 +
              ' VISA DEBITO' + #13 +
              ' VISA CREDITO' + #13 +
              ' MASTERCARD DEBITO' + #13 +
              ' MASTERCARD CREDITO')
              , 'Atenção', MB_OK + MB_ICONWARNING);
          end
          else
            Result := TransacaoComPoS(tcxPosOffLine);
        end;
        tpNone:
        begin
          Result := False;
        end;
      end;

      //if FdTotalTransacionado = FdTotalEmCartao then
      //  Result := True;

      if Form1.bModoMultiplosCartoes = False then
      begin
        Break;
      end;

      if (FiContaCartao >= Form1.iNumeroMaximoDeCartoes) then
        Break;
      if (Form1.sModeloECF = '59') then
      begin
        // SAT permite apenas 10 grupos de meios de pagamento
        if FiContaCartao >= 10 then
          Break;
      end;

    end; // while FdTotalTransacionado < FdTotalEmCartao do
  end; // if FdTotalEmCartao = FdTotalTransacionado then

  FreeAndNil(FFormasExtras);

  if FdTotalEmCartao = FdTotalTransacionado then
  begin
    Result := True;
  end;
end;

end.
