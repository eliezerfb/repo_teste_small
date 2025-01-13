unit uFuncoesPOS;

interface

uses
  Forms
  , SysUtils
  , StrUtils
  , Controls
  , Windows
  , DB
  , uclassetransacaocartao
  ;

type
  TTipoConexaoPOS = (tcxPosOffLine, tcxPosOnlineElginPay);

function TransacaoComPoS(TipoConexaoPOS: TTipoConexaoPOS): Boolean;

implementation

uses
  fiscal
  , ufuncoesfrente
  , unit10
  , usmall_elginpay_pos
  , SmallFunc_xe
  ;

function TransacaoComPoS(TipoConexaoPOS: TTipoConexaoPOS): Boolean;
var
  bPoSok: Boolean;
  iParcelas: Integer;
  iContaCartao: Integer;
  dTotalTransacaoPOS: Currency; // Double;
  dTotalEmCartao: Currency; // Double;
  dValorPagarCartao: Currency; // Double;
  dTotalTransacionado: Currency; // Double;
  iTotalParcelas: Integer; // Sandro Silva 2017-08-28 Soma de todas as parcelas dos cartões usados
  ModalidadeTransacao: TTipoModalidadeTransacao; // Sandro Silva 2021-07-05
  FormasExtras: TPagamentoPDV; // Sandro Silva 2023-09-05 FormasExtras: TFormasExtras;
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
begin
  // Usando PoS para transação com cartão
  Result := False;

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
  dTotalTransacionado := 0.00;
  iContaCartao        := 0;
  Form1.TransacoesCartao.Transacoes.Clear;
  iTotalParcelas := 0;
  
  ModalidadeTransacao := tModalidadeCartao;

  while dTotalTransacionado < dTotalEmCartao do // Enquanto não totalizar transações com valor devido
  begin
    if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Sandro Silva 2016-04-29
    begin
      dValorPagarCartao := dTotalEmCartao - dTotalTransacionado;

      if (Form1.iNumeroMaximoDeCartoes > 1) and (Form1.bModoMultiplosCartoes)
        and (Form1.ClienteSmallMobile.sVendaImportando = '')
      then
      begin
        while True do
        begin
          Application.ProcessMessages;

          dValorPagarCartao := StrToFloatDef(Form1.Small_InputBox(PAGAMENTO_EM_CARTAO,'Informe o valor para pagamento com o ' + IntToStr(iContaCartao + 1) + 'º de ' + IntToStr(Form1.iNumeroMaximoDeCartoes) + ' cartões:', FormatFloat('0.00', dValorPagarCartao)), 0);

          dValorPagarCartao := StrToFloatDef(FormatFloat('0.00', dValorPagarCartao), 0);

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
              begin
                Break;
              end;
            end else
            begin
              if dValorPagarCartao <> dTotalEmCartao then
              begin
                Application.MessageBox(PChar(FormatFloat('0.00', dValorPagarCartao) + ' é diferente do valor (' + FormatFloat('0.00', dTotalEmCartao) + ') definido para forma de pagamento cartão' + #13 + #13 +
                                             'Acesse o Menu Configurações e ative o Modo Múltiplos Cartões para dividir o valor entre vários cartões'), 'Atenção', MB_ICONWARNING + MB_OK)
              end else
              begin
                Break;
              end;
            end;
          end;
        end;
      end;
    end
    else
    begin
      dValorPagarCartao := dTotalEmCartao;
    end;

    if (dTotalEmCartao - (dTotalTransacionado + dValorPagarCartao)) < 0 then
    begin
      Application.MessageBox('Valor total da transação maior que o valor definido para a forma de pagamento cartão', 'Atenção', MB_ICONWARNING + MB_OK);
    end else
    begin
      if dValorPagarCartao = 0 then
      begin
        Break;
      end
      else
      begin
        bPoSok := True;

        if (dValorPagarCartao <> 0)  then // Cartão sim - cheque não
        begin
          if bPoSOk then
          begin
            // Só deve entrar aqui se não usar integrador fiscal ou integrador fiscal retornar True
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

                  if AnsiContainsText(Form1.PosElginPay.Transacao.TipoCartao, 'CARTAO_DEBITO') then
                    Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' DEBITO'
                  else
                    Form10.sNomeDoTEF := Form1.PosElginPay.Transacao.Rede + ' CREDITO';
                  Form1.sTransaca   := Form1.PosElginPay.Transacao.Transacao;
                  Form1.sAutoriza   := IfThen(Form1.UsaIntegradorFiscal(), Form1.sTransaca, '');
                  Form1.sNomeRede   := Form1.PosElginPay.Transacao.Rede;

                  Form1.sTipoParc   := '0';// Considera sempre parcelado pelo estabelecimento poderia validar com AnsiContainsText(ValorElementoElginPayFromJson(sResposta, '"tipoFinanciamento":'), 'ESTABELECIMENTO')
                  Form1.sParcelas   := Form1.PosElginPay.Transacao.Parcelas;
                  if Form1.sParcelas = '0' then
                    Form1.sParcelas := '1';
                end
                else
                  SmallMessageBox(Form1.PosElginPay.Transacao.MensagemOperador, 'Atenção', MB_OK + MB_ICONWARNING);

                Form1.ExibePanelMensagem(Form1.PosElginPay.Transacao.MensagemOperador, True);
              end
              else
              begin
                Form1.ExibePanelMensagem('Selecionando Bandeira do cartão', True);

                Form10.ShowModal;
                {Sandro Silva 2023-06-14 inicio}
                if Form10.ModalResult <> mrOk then
                  bPosOk := False;
                {Sandro Silva 2023-06-14 fim}

                if Form1.sIdentificaPOS = 'Sim' then
                begin
                  if Trim(Form1.sNomeRede) = '' then
                  begin
                    bPoSok := False;
                    SmallMessageBox(PChar('Acesse F10-Menu/Configurações/Cartões de débito e crédtio (POS)' + #13 + #13 +
                      'Cadastre os Cartões de Crédito e Débito (POS) com a bandeira' + #13 + #13 +
                      'Exemplo:' + #13 +
                      ' VISA DEBITO' + #13 +
                      ' VISA CREDITO' + #13 +
                      ' MASTERCARD DEBITO' + #13 +
                      ' MASTERCARD CREDITO')
                      , 'Atenção', MB_OK + MB_ICONWARNING);
                  end;
                end;
                
              end;
            end;
          end;// if bPoSOk then // Sandro Silva 2018-07-03

          if bPoSok then
          begin
            if (Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0) then // Sandro Silva 2016-04-29
            begin
              if (iContaCartao + 1) = 1 then // Quando for o primeiro cartão apaga todas as parcelas do cupom
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

              //Ficha 3403
              dTotalTransacaoPOS := 0;
              for iParcelas := 1 to StrToIntDef(Form1.sParcelas, 1) do
              begin
                try
                  iTotalParcelas := iTotalParcelas + 1;// Sandro Silva 2017-08-28 Acumula as parcelas entre os diferentes cartões usados para gerar as parcelas na sequência
                  Form1.ibDataSet7.Append;
                  Form1.ibDataSet7.FieldByName('NOME').AsString         := StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO','');
                  if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
                    Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'Cartão, Caixa: ' + Form1.sCaixa + ' Aut.' + Form1.sTransaca
                  else
                    Form1.ibDataSet7.FieldByName('HISTORICO').AsString    := 'VENDA NO CARTAO: ' + IntToStr(iContaCartao + 1) + 'º CARTAO';
                  Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString    := FormataReceberDocumento(iTotalParcelas); // documento
                  Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat    := StrToFloat(FormatFloat('0.00', (Int((dValorPagarCartao / StrToIntDef(Form1.sParcelas, 1)) * 100) / 100)));// Truncando 2 casas decimais
                  Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime    := StrToDate(Form1.sDataDoCupom); 
                  if AnsiContainsText(Form10.sNomedoTef, 'CREDITO') then
                    Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoCredito * iParcelas) // Ficha 5659 Sandro Silva 2022-02-04 Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + Form1.iDiasCartaoCredito
                  else
                    Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + (Form1.iDiasCartaoDebito * iParcelas); // Ficha 5659 Sandro Silva 2022-02-04 Form1.ibDataSet7.FieldByName('VENCIMENTO').AsDateTime := Date + Form1.iDiasCartaoDebito;
                  Form1.ibDataSet7.FieldByName('PORTADOR').AsString     := Form10.sNomeDoTEF;
                  Form1.ibDataSet7.FieldByName('VALOR_RECE').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                  Form1.ibDataSet7.FieldByName('VALOR_JURO').AsFloat    := 0; // Sandro Silva 2016-06-21 Deixar nulo não exibe as contas em "Exibir> A vencer"
                  Form1.ibDataSet7.Post;
                  dTotalTransacaoPOS := dTotalTransacaoPOS + Form1.ibDataSet7.FieldByName('VALOR_DUPL').AsFloat; // Sandro Silva 2017-08-28
                except
                end;
              end;

              Form1.AjustarDiferencaParcelasCartao(dTotalTransacaoPOS, dValorPagarCartao, iTotalParcelas, StrToIntDef(Form1.sParcelas, 1));
            end;

            Inc(iContaCartao);
          end;
        end;

        Form1.ExibePanelMensagem('', True);
        
        if bPoSok then
        begin
          Form1.TransacoesCartao.Transacoes.Adicionar(Form1.sNomeRede,
                                                      IfThen(Pos('DEBITO', ConverteAcentos(AnsiUpperCase(Form10.sNomeDoTEF))) > 0, 'DEBITO', 'CREDITO'),
                                                      dValorPagarCartao,
                                                      Form10.sNomeAdquirente,
                                                      Form1.sTransaca,
                                                      Form1.sAutoriza,
                                                      StrTran(StrTran(Form10.sNomeDoTEF,'DEBITO',''),'CREDITO',''),
                                                      '',
                                                      '',
                                                      ModalidadeTransacao);

          dTotalTransacionado := dTotalTransacionado + dValorPagarCartao; // Sandro Silva 2017-06-16
          Form1.fTEFPago      := Form1.fTEFPago + dValorPagarCartao;
          if Form1.ibDataSet25.State in [dsEdit, dsInsert] = False then
            Form1.ibDataSet25.Edit;
          Form1.ibDataSet25.FieldByName('PAGAR').AsFloat := dTotalTransacionado; // Sandro Silva 2017-06-16
          RecuperaValoresFormasExtras; // Sandro Silva 2023-09-05
        end;
      end;
    end;

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
  end;

end;

end.
