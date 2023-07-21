unit uImportaGerencial;

interface

uses
  SysUtils, Controls, StrUtils
  , IBDatabase, IBCustomDataSet, IBQuery
  , ufuncoesfrente
  , uclassetransacaocartao
  ;

type
  TImportaGerencial = class 
  private
    FIBTransaction: TIBTransaction;
    FCaixa: String;
    FModeloDocumento: String;
    FNumeroGerencial: String;
    FIBDataSet27: TIBDataSet;
    FIBDataSet30: TIBDataSet;
    FIBDataset150: TIBDataSet;
    FIBDataSet7: TIBDataSet;
    FIBDataSet28: TIBDataSet;
    FNumeroNF: String;
    FIBDataSet25: TIBDataSet;
    FTransacoesCartao: TTransacaoFinanceira;
    FNomeDoTEF: String;
    FDebitoOuCredito: String;
    procedure SetNumeroGerencial(const Value: String);  
  public
    function Importar: Boolean;
    property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    property IBDataset150: TIBDataSet read FIBDataset150 write FIBDataset150;
    property IBDataSet27: TIBDataSet read FIBDataSet27 write FIBDataSet27;
    property IBDataSet28: TIBDataSet read FIBDataSet28 write FIBDataSet28;
    property IBDataSet7: TIBDataSet read FIBDataSet7 write FIBDataSet7;
    property IBDataSet30: TIBDataSet read FIBDataSet30 write FIBDataSet30;
    property IBDataSet25: TIBDataSet read FIBDataSet25 write FIBDataSet25;
    property TransacoesCartao: TTransacaoFinanceira read FTransacoesCartao write FTransacoesCartao;
    property NomeDoTEF: String read FNomeDoTEF write FNomeDoTEF;
    property DebitoOuCredito: String read FDebitoOuCredito write FDebitoOuCredito;
    property Caixa: String read FCaixa write FCaixa;
    property ModeloDocumento: String read FModeloDocumento write FModeloDocumento;
    property NumeroGerencial: String read FNumeroGerencial write SetNumeroGerencial;
    property NumeroNF: String read FNumeroNF;

  end;

implementation

uses
  fiscal;

{ TImportaGerencial }

function TImportaGerencial.Importar: Boolean;
var
  IBQCONSULTA: TIBQuery;
  IBQPENDENCIA: TIBQuery;
  sDataOld: String;
  sCaixaOld: String;
  sNovoNumero: String;
  dtDataNovo: TDate;
  sDAV: String;
  sTIPODAV: String;
begin
  FNumeroNF := '';
  if (FModeloDocumento <> '59') and (FModeloDocumento <> '65') then
    Exit;

  if (FIBTransaction = nil) or
    (FIBDataSet27 = nil) or
    (FIBDataSet30 = nil) or
    (FIBDataset150 = nil) or
    (FIBDataSet7 = nil) or
    (FIBDataSet28 = nil) or
    (FIBDataSet25 = nil)
    then
    Exit;

  IBQCONSULTA := CriaIBQuery(FIBTransaction);
  try
    IBQCONSULTA.Close;
    IBQCONSULTA.SQL.Text :=
      'select DATA, CAIXA from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and MODELO = ' + QuotedStr('99');
    IBQCONSULTA.Open;

    if IBQCONSULTA.FieldByName('DATA').AsString <> '' then
    begin

      sDataOld  := IBQCONSULTA.FieldByName('DATA').AsString;
      sCaixaOld := IBQCONSULTA.FieldByName('CAIXA').AsString;

      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Clear;
      IBQCONSULTA.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and CAIXA = ' + QuotedStr(sCaixaOld) + ' and MODELO = ' + QuotedStr('99'));
      IBQCONSULTA.ExecSQL;

      FIBDataset150.Close;
      FIBDataset150.SelectSql.Clear;
      FIBDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(FCaixa) + ' and MODELO = ' + QuotedStr(FModeloDocumento));
      FIBDataset150.Open;

      if FModeloDocumento = '65' then
        sNovoNumero :=  FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMERONFCE', 1));

      dtDataNovo := Date;
      FIBDataset150.Append;
      FIBDataset150.FieldByName('NUMERONF').AsString  := sNovoNumero;
      FIBDataset150.FieldByName('DATA').AsDateTime    := dtDataNovo;
      FIBDataset150.FieldByName('CAIXA').AsString     := FCaixa;
      FIBDataset150.FieldByName('MODELO').AsString    := FModeloDocumento;
      FIBDataset150.FieldByName('GERENCIAL').AsString := FNumeroGerencial;
      FIBDataset150.Post;

      //Seleciona novamente o itens para alterar o número do pedido para o número do CFe
      FIBDataSet27.Close;
      FIBDataSet27.SelectSQL.Text :=
        'select * from ALTERACA where CAIXA = ' + QuotedStr(sCaixaOld) + ' and PEDIDO = ' + QuotedStr(FNumeroGerencial) +
        ' and COO is null'; // Apenas os itens da venda atual. Para separar de vendas anteriores com mesmo número do caixa
      FIBDataSet27.Open;

      sDAV     := '';
      sTIPODAV := '';
      //sAlteracaPedidoOld := FIBDataSet27.FieldByName('PEDIDO').AsString;

      {
      if Form1.sOrcame <> '' then
      begin
        sDAV     := Form1.sOrcame;
        sTIPODAV := 'ORÇAMENTO';
      end;

      if Form1.sOs <> '' then
      begin
        sDAV     := Form1.sOs;
        sTIPODAV := 'OS';
      end;
      }

      IBQPENDENCIA := CriaIBQuery(FIBTransaction);
      try
        IBQPENDENCIA.Close;
        IBQPENDENCIA.SQL.Text :=
          'update PENDENCIA set ' +
          'PEDIDO = ' + QuotedStr(sNovoNumero) +
          ', CAIXA = ' + QuotedStr(FCaixa) +
          ' where PEDIDO = ' + QuotedStr(FNumeroGerencial) +
          ' and CAIXA = ' + QuotedStr(sCaixaOld);
        IBQPENDENCIA.ExecSQL;
      except

      end;
      FreeAndNil(IBQPENDENCIA);

      while FIBDataSet27.Eof = False do
      begin

        if (sDAV = '')
          and (FIBDataSet27.FieldByName('DAV').AsString <> '')
          and (FIBDataSet27.FieldByName('TIPODAV').AsString <> '') then
        begin
          // Identifica o primeiro DAV que encontrar nos itens da venda
          sDAV     := FIBDataSet27.FieldByName('DAV').AsString;
          sTIPODAV := FIBDataSet27.FieldByName('TIPODAV').AsString;
        end;

        if (FIBDataSet27.FieldByName('CAIXA').AsString = sCaixaOld)
          and (FIBDataSet27.FieldByName('PEDIDO').AsString = FNumeroGerencial) then
        begin
          //
          // NFC-e não grava COO e CCF para os descontos e acréscimos
          //
          if (FIBDataSet27.FieldByName('COO').AsString = '') and (FIBDataSet27.FieldByName('CCF').AsString = '') then // Não atualizar número do CF-e em vendas antigas de ECF
          begin

            try
              // Produtos com controle de número de série
                if (FIBDataSet27.FieldByName('CODIGO').AsString <> '') and
                  ((FIBDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (FIBDataSet27.FieldByName('TIPO').AsString = 'LOKED')) then
                begin
                  // Seleciona o produto na tabela SERIE, com a data e o número temporário da venda, para atualizar com a data e o número do CF-e gerados pelo SAT
                  FIBDataSet30.Close;
                  FIBDataSet30.SelectSQL.Clear;
                  FIBDataSet30.Selectsql.Text :=
                    'select * from SERIE ' +
                    ' where CODIGO = ' + QuotedStr(FIBDataSet27.FieldByName('CODIGO').AsString) +
                    ' and NFVENDA = ' + QuotedStr(FNumeroGerencial) +
                    ' and DATVENDA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FIBDataSet27.FieldByName('DATA').AsDateTime));
                  FIBDataSet30.Open;

                  while FIBDataSet30.Eof = False do
                  begin
                    if (FIBDataSet30.FieldByName('CODIGO').AsString <> '') and (FIBDataSet30.FieldByName('CODIGO').AsString = FIBDataSet27.FieldByName('CODIGO').AsString) then
                    begin
                      FIBDataSet30.Edit;
                      FIBDataSet30.FieldByName('NFVENDA').AsString  := sNovoNumero;
                      try
                        FIBDataSet30.FieldByName('VALVENDA').AsFloat  := FIBDataSet27.FieldByName('UNITARIO').AsFloat;
                        FIBDataSet30.FieldByName('DATVENDA').AsFloat  := dtDataNovo;
                        FIBDataSet30.Post; // Sandro Silva 2018-12-07
                      except
                      end;
                    end;
                    FIBDataSet30.Next;
                  end;
                end;
            except

            end;

            try
              FIBDataSet27.Edit;
              FIBDataSet27.FieldByName('PEDIDO').AsString := sNovoNumero;
              FIBDataSet27.FieldByName('CAIXA').AsString  := FCaixa;
              FIBDataSet27.FieldByName('DATA').AsDateTime := dtDataNovo;
              FIBDataSet27.Post;
            except
            
            end;

          end; // if (FIBDataSet27.FieldByName('DATA').AsDateTime >= StrToDate(sDataOld))

        end; // if (FIBDataSet27.FieldByName('CAIXA').AsString = Form1.sCaixa)

        FIBDataSet27.Next;
      end; // while

      Form1.AtualizaDetalhe(FIBDataSet27.Transaction, sTIPODAV, sDAV, sCaixaOld, FCaixa, sNovoNumero, 'Fechada');

      // Seleciona novamente os dados para usar na sequência da venda
      FIBDataSet27.Close;
      FIBDataSet27.SelectSQL.Text :=
        'select * from ALTERACA where CAIXA = ' + QuotedStr(FCaixa) + ' and PEDIDO = ' + QuotedStr(sNovoNumero);
      FIBDataSet27.Open;
      FIBDataSet27.Last;

      // Receber
      FIBDataSet7.Close;
      FIBDataSet7.SelectSQL.Text :=
        'select * ' +
        'from RECEBER ' +
        'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(StrToInt(FNumeroGerencial)) + RightStr(sCaixaOld, 3)) +
        ' order by REGISTRO';
      FIBDataSet7.Open;

      FIBDataSet7.First;
      while FIBDataSet7.Eof = False do
      begin
        if (FIBDataSet7.FieldByName('NUMERONF').AsString = FNumeroGerencial + Copy(sCaixaOld, 1, 3)) then
        begin
          try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
            FIBDataSet7.Edit;
            FIBDataSet7.FieldByName('NUMERONF').AsString  := sNovoNumero + Copy(FCaixa, 1, 3);
            FIBDataSet7.FieldByName('HISTORICO').AsString := StringReplace(FIBDataSet7.FieldByName('HISTORICO').AsString, FNumeroGerencial, FormataNumeroDoCupom(StrToInt(sNovoNumero)), [rfReplaceAll]);
            FIBDataSet7.FieldByName('DOCUMENTO').AsString := FCaixa + sNovoNumero + RightStr(FIBDataSet7.FieldByName('DOCUMENTO').AsString, 1);
            FIBDataSet7.FieldByName('EMISSAO').AsDateTime := dtDataNovo;
            FIBDataSet7.Post;
          except
          end;
        end;
        FIBDataSet7.Next;
      end;                     

      FIBDataSet25.Append; // para distribuir os valores pago e gerar o xml

      //Pagament
      FIBDataSet28.Close;
      FIBDataSet28.SelectSQL.Text :=
        'select * from PAGAMENT where CAIXA = ' + QuotedStr(sCaixaOld) + ' and PEDIDO = ' + QuotedStr(FNumeroGerencial);
      FIBDataSet28.Open;
      FIBDataSet28.First;
      while FIBDataSet28.Eof = False do
      begin
        if (FIBDataSet28.FieldByName('CAIXA').AsString = sCaixaOld)
          and (FIBDataSet28.FieldByName('PEDIDO').AsString = FNumeroGerencial) then
        begin
          try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
            FIBDataSet28.Edit;
            FIBDataSet28.FieldByName('PEDIDO').AsString := sNovoNumero;
            FIBDataSet28.FieldByName('CAIXA').AsString  := FCaixa;
            FIBDataSet28.FieldByName('DATA').AsDateTime := dtDataNovo;
            FIBDataSet28.Post;
          except
          end;
        end;

      // faz inverso que dataset25 faz gravando em ibdataset28 na rotina de fechamento de venda (F3/F7/F9)

/////////////////////////////////////////////////////////////////////////////////////
        if Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '00' then // Total a receber
          FIBDataSet25.FieldByName('RECEBER').AsFloat := StrToFloat(FormatFloat('0.00', FIBDataSet28.FieldByName('VALOR').AsFloat * -1));

        if Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '01' then // Cheque
          FIBDataSet25.FieldByName('ACUMULADO1').AsFloat := FIBDataSet28.FieldByName('VALOR').AsFloat;

        if Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '02' then // Dinheiro
        begin
          FIBDataSet25.FieldByName('ACUMULADO2').AsFloat := FIBDataSet28.FieldByName('VALOR').AsFloat;
        end;
        {
        if (Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '03') or // Cartão
          (Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '17') or // Pagto Instantâneo
          (Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '18') then // Carteira digital
        begin

          if (Copy(FIBDataSet28.FieldByName('FORMA').AsString, 1, 2) = '03') then
          begin

            FIBDATASET7.First;
            while FIBDATASET7.Eof = False do
            begin
              if FIBDATASET7.FieldByName('VALOR_DUPL').AsFloat = FIBDataSet28.FieldByName('VALOR').AsFloat then
              begin
                if AnsiContainsText(ConverteAcentosXML(FIBDATASET7.FieldByName('HISTORICO').AsString), 'CARTAO') then
                  FNomeDoTEF := ConverteAcentosXML(AnsiUpperCase(StringReplace(FIBDataSet28.FieldByName('FORMA').AsString, '03 Cartao ', '', [rfReplaceAll])));

              end;
              FIBDATASET7.Next;
            end;  

            FTransacoesCartao.Transacoes.Adicionar(
          end;

                if (FIBDataSet25.FieldByName('PAGAR').AsFloat <> 0) then // Cartao
                begin

                  try
                    for iTransacaoCartao := 0 to FTransacoesCartao.Transacoes.Count -1 do  // Um registro para cada transação com cartão
                    begin
                      try
                        if Pos('CREDITO', FNomeDoTEF) <> 0 then
                          FDebitoOuCredito := 'CREDITO';
                        if Pos('DEBITO', FNomeDoTEF) <> 0 then
                          FDebitoOuCredito := 'DEBITO';
                        if Trim(FDebitoOuCredito) = '' then
                          FDebitoOuCredito := 'DEBITO';

                        FIBDataSet28.Append;
                        FIBDataSet28.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                        FIBDataSet28.FieldByName('COO').AsString       := FormataNumeroDoCupom(iCOO);
                        FIBDataSet28.FieldByName('CCF').AsString       := FormataNumeroDoCupom(iCCF);
                        FIBDataSet28.FieldByName('PEDIDO').AsString    := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                        FIBDataSet28.FieldByName('GNF').AsString       := FormataNumeroDoCupom(iGnf);
                        FIBDataSet28.FieldByName('CAIXA').AsString     := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                        FIBDataSet28.FieldByName('CLIFOR').AsString    := sConveniado;
                        FIBDataSet28.FieldByName('VENDEDOR').AsString  := sVendedor;
                        FIBDataSet28.FieldByName('FORMA').AsString     := '03 Cartao ' + FTransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito;

                        if FTransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadeCarteiraDigital then
                          FIBDataSet28.FieldByName('FORMA').AsString     := '18 Carteira Digital';
                        if FTransacoesCartao.Transacoes.Items[iTransacaoCartao].Modalidade = tModalidadePix then
                          FIBDataSet28.FieldByName('FORMA').AsString     := '17 Pagto Instantaneo';

                        FIBDataSet28.FieldByName('VALOR').AsFloat      := StrToFloat(FormatFloat('0.00', FTransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago));
                        FIBDataSet28.FieldByName('HORA').AsString      := Form1.ibDataSet27.FieldByName('HORA').AsString;
                        FIBDataSet28.Post;

                      except
                      end;
                    end; // for iTransacaoCartao := 0 to FTransacoesCartao.Transacoes.Count -1 do



                  except

                  end;
                end; // Fim Cartão
        end;
                //
                if (FIBDataSet25.FieldByName('DIFERENCA_').AsFloat <> 0) then // Prazo
                begin
                  //
                  try
                    sFormaPrazo := '04 A prazo';
                    if Form1.sModeloECF = '65' then
                      sFormaPrazo := '04 A prazo NFC-e';

                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString       := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString       := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString       := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString       := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString    := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('GNF').AsString       := FormataNumeroDoCupom(iGnf); // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('GNF').AsString       := StrZero(iGnf, 6, 0);
                    FIBDataSet28.FieldByName('CAIXA').AsString     := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString    := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString  := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString     := sFormaPrazo;
                    FIBDataSet28.FieldByName('VALOR').AsFloat      := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('DIFERENCA_').AsFloat));// Sandro Silva 2016-09-05  FIBDataSet25.FieldByName('DIFERENCA_').Asfloat;
                    FIBDataSet28.FieldByName('HORA').AsString      := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;
                end;
                //
                if (FIBDataSet25.FieldByName('VALOR01').AsFloat <> 0) then // Extra 1
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime    := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString       := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString       := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString       := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString       := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString    := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString     := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString    := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString  := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString     := '05 ' + AllTrim(Form2.Label18.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat      := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR01').AsFloat)); // Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('VALOR01').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString      := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('1', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR01').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('1', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR01').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR02').AsFloat <> 0) then // Extra 2
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '06 ' + AllTrim(Form2.Label19.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR02').AsFloat));// Sandro Silva 2016-09-05  FIBDataSet25.FieldByName('VALOR02').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('2', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR02').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('2', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR02').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR03').AsFloat <> 0) then // Extra 3
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '07 ' + AllTrim(Form2.Label20.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR03').AsFloat)); // Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('VALOR03').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('3', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR03').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('3', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR03').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR04').AsFloat <> 0) then // Extra 4
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '08 ' + AllTrim(Form2.Label21.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR04').AsFloat)); // Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('VALOR04').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('4', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR04').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('4', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR04').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR05').AsFloat <> 0) then // Extra 5
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '09 ' + AllTrim(Form2.Label22.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR05').AsFloat));// Sandro Silva 2016-09-05  FIBDataSet25.FieldByName('VALOR05').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('5', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR05').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('5', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR05').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR06').AsFloat <> 0) then // Extra 6
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '10 ' + AllTrim(Form2.Label23.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR06').AsFloat)); // Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('VALOR06').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('6', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR06').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('6', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR06').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR07').AsFloat <> 0) then // Extra 7
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '11 ' + AllTrim(Form2.Label24.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR07').AsFloat));// Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('VALOR07').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('7', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR07').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('7', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR07').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;
                //
                if (FIBDataSet25.FieldByName('VALOR08').AsFloat <> 0) then // Extra 8
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '12 ' + AllTrim(Form2.Label25.Caption);
                    FIBDataSet28.FieldByName('VALOR').AsFloat     := StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('VALOR08').AsFloat));// Sandro Silva 2016-09-05  FIBDataSet25.FieldByName('VALOR08').AsFloat;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;

                  try
                    FormaExtraLancaReceber('8', sCaixa, FormataNumeroDoCupom(iCOO), FIBDataSet25.FieldByName('VALOR08').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30); // Sandro Silva 2021-12-02 FormaExtraLancaReceber('8', sCaixa, StrZero(iCOO, 6, 0), FIBDataSet25.FieldByName('VALOR08').AsFloat, StrToDate(Form1.sDataDoCupom), StrToDate(Form1.sDataDoCupom) + 30);
                  except
                  end;

                end;

                // Sempre cria Troco
                begin
                  //
                  try
                    FIBDataSet28.Append;
                    //
                    FIBDataSet28.FieldByName('DATA').AsDateTime   := StrToDate(Form1.sDataDoCupom);
                    FIBDataSet28.FieldByName('COO').AsString      := FormataNumeroDoCupom(iCOO); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('COO').AsString      := StrZero(iCOO, 6, 0); //
                    FIBDataSet28.FieldByName('CCF').AsString      := FormataNumeroDoCupom(iCCF); // // Sandro Silva 2021-12-02 FIBDataSet28.FieldByName('CCF').AsString      := StrZero(iCCF, 6, 0); //
                    FIBDataSet28.FieldByName('PEDIDO').AsString   := Form1.ibDataSet27.FieldByName('PEDIDO').AsString;
                    FIBDataSet28.FieldByName('CAIXA').AsString    := Form1.ibDataSet27.FieldByName('CAIXA').AsString;
                    FIBDataSet28.FieldByName('CLIFOR').AsString   := sConveniado;
                    FIBDataSet28.FieldByName('VENDEDOR').AsString := sVendedor;
                    FIBDataSet28.FieldByName('FORMA').AsString    := '13 Troco';
                    if FIBDataSet25.FieldByName('ACUMULADO3').AsFloat <> 0 then
                      FIBDataSet28.FieldByName('VALOR').AsFloat    := StrToFloat(FormatFloat('0.00', Abs(FIBDataSet25.FieldByName('ACUMULADO3').AsFloat)));// Sandro Silva 2017-05-20  StrToFloat(FormatFloat('0.00', FIBDataSet25.FieldByName('ACUMULADO3').AsFloat * -1));// Sandro Silva 2016-09-05 FIBDataSet25.FieldByName('ACUMULADO3').AsFloat * -1;
                    FIBDataSet28.FieldByName('HORA').AsString     := Form1.ibDataSet27.FieldByName('HORA').AsString; // Sandro Silva 2018-11-30
                    //
                    FIBDataSet28.Post;
                    //
                  except
                  end;
                end;
}


/////////////////////////////////////////////////////////////////////////////////////
        FIBDataSet28.Next;
      end;



      Result := True;

      FNumeroNF := sNovoNumero;
    end;
  except

  end;
  if FNumeroNF = '' then
    Result := False;
end;

procedure TImportaGerencial.SetNumeroGerencial(const Value: String);
begin
  FNumeroGerencial := FormataNumeroDoCupom(StrToIntDef(Value, 0));
end;

end.
