(*************************************************************************)
(* Converte uma venda para nova venda, conforme o novo modelo informado  *)
(* Inicialmente converte gerencial para NFC-e ou SAT                     *)
(* Também usado para casos de final SAT e ocorrer erro de schema do xml  *)
(* permite executar clique duplo no gerenciador e finalizar a venda sem  *)
(* abrir na tela a venda com erro                                        *)
(* Recupera dados da venda (Itens, cliente, vendedor, formas de pagaento) *)
(*************************************************************************)

unit uConverteDocumentoParaDocFiscal;

interface

uses
  SysUtils, Controls, StrUtils
  , IBDatabase, IBCustomDataSet, IBQuery
  , ufuncoesfrente
  , uclassetransacaocartao
  ;

type
  TDadosCliente = class
  private
    FCNPJCPF: String;
    FEmail: String;
    FNome: String;
  public
    property Email: String read FEmail write FEmail;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property Nome: String read FNome write FNome;
  end;

  TConverteVendaParaNovoDocFiscal = class 
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
    FConveniado: String;
    FVendedor: String;
    FDadosCliente: TDadosCliente;
    FDescontoNoTotal: Double;
    FValorTotalTEFPago: Real;
    FCaixaOld: String;
    FModeloOld: String;
    procedure SetNumeroGerencial(const Value: String);
  public
    constructor Create;
    destructor Destroy;
    function Converte: Boolean;
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
    property sConveniado: String read FConveniado write FConveniado;
    property sVendedor: String read FVendedor write FVendedor;
    property DescontoNoTotal: Double read FDescontoNoTotal write FDescontoNoTotal;
    property DadosCliente: TDadosCliente read FDadosCliente write FDadosCliente;
    property ValorTotalTEFPago: Real read FValorTotalTEFPago write FValorTotalTEFPago;
    property CaixaOld: String read FCaixaOld write FCaixaOld;
    property ModeloOld: String read FModeloOld write FModeloOld;

  end;

implementation

uses
  fiscal, DB, uSmallConsts;

{ TConverteVendaParaNovoDocFiscal }

constructor TConverteVendaParaNovoDocFiscal.Create;
begin
  FDadosCliente := TDadosCliente.Create;
end;

destructor TConverteVendaParaNovoDocFiscal.Destroy;
begin
  FDadosCliente.Free;
end;

function TConverteVendaParaNovoDocFiscal.Converte: Boolean;
// Converte venda gerencial em documento fiscal modelo 59 e 65
var
  IBQCONSULTA: TIBQuery;
  IBQPENDENCIA: TIBQuery;
  sDataOld: String;
  sCaixaOld: String;
  // Sandro Silva 2023-08-30 sModeloOld: String;
  sNovoNumero: String;
  dtDataNovo: TDate;
  sDAV: String;
  sTIPODAV: String;
  ModalidadeTransacao: TTipoModalidadeTransacao;
  FormasPagamento: TPagamentoPDV;
  sXmlOld: String;  // Sandro Silva 2023-08-25
  sCondicaoVenda: String;
  sGerencialOld: String;
  bPrecisarGerarNovoNumero: Boolean; // Sandro Silva 2023-08-29
begin
  FNumeroNF := '';
  bPrecisarGerarNovoNumero := True;

  if FModeloOld = '' then
  begin
    if (FModeloDocumento <> '59') and (FModeloDocumento <> '65') then
      Exit;
  end;

  if FModeloOld = '' then
    FModeloOld := '99';

  if (FIBTransaction = nil) or
    (FIBDataSet27 = nil) or
    (FIBDataSet30 = nil) or
    (FIBDataset150 = nil) or
    (FIBDataSet7 = nil) or
    (FIBDataSet28 = nil) or
    (FIBDataSet25 = nil)
    then
    Exit;

  {Sandro Silva 2023-08-29 inicio}
  if ((FModeloOld = '59') and (FModeloDocumento = '59')) or ((FModeloOld = '65') and (FModeloDocumento = '65')) then // Sandro Silva 2023-09-05 if (FModeloOld = '59') and (FModeloDocumento = '59') then
    bPrecisarGerarNovoNumero := False;
  {Sandro Silva 2023-08-29 fim}

  FormasPagamento := TPagamentoPDV.Create;
  IBQCONSULTA := CriaIBQuery(FIBTransaction);
  try
    if FModeloOld = '99' then
      sCondicaoVenda := ' and coalesce(STATUS, '''') = ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' ';
    if FModeloOld = '65' then
      sCondicaoVenda := ' and (coalesce(STATUS, '''') not containing ''Autorizad'' and coalesce(STATUS, '''') not containing ''Cancel'' )';
    if FModeloOld = '59' then
      sCondicaoVenda := ' and (coalesce(STATUS, '''') not containing ''Emitido com sucesso'' and coalesce(STATUS, '''') not containing ''Cancel'' )';

    IBQCONSULTA.Close;
    IBQCONSULTA.SQL.Text :=
      // Sandro Silva 2023-08-25 'select NUMERONF, DATA, CAIXA, MODELO from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and MODELO = ''99'' and STATUS = ' + QuotedStr(VENDA_GERENCIAL_FINALIZADA) + ' ';
      'select NUMERONF, DATA, CAIXA, MODELO, NFEXML, GERENCIAL from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) +
      ' and MODELO = ' + QuotedStr(FModeloOld) + sCondicaoVenda;
    IBQCONSULTA.Open;

    if IBQCONSULTA.FieldByName('NUMERONF').AsString <> '' then
    begin

      sDataOld   := IBQCONSULTA.FieldByName('DATA').AsString;
      sCaixaOld  := IBQCONSULTA.FieldByName('CAIXA').AsString;
      FModeloOld := IBQCONSULTA.FieldByName('MODELO').AsString; // Sandro Silva 2023-08-30 sModeloOld := IBQCONSULTA.FieldByName('MODELO').AsString;
      sXmlOld    := IBQCONSULTA.FieldByName('NFEXML').AsString;
      sGerencialOld := IBQCONSULTA.FieldByName('GERENCIAL').AsString;// Sandro Silva 2023-08-25

      {Sandro Silva 2023-08-23 inicio
      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Clear;
      IBQCONSULTA.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and CAIXA = ' + QuotedStr(sCaixaOld) + ' and MODELO = ' + QuotedStr('99'));
      IBQCONSULTA.ExecSQL;
      }

      FIBDataset150.Close;
      {Mauricio Parizotto 2024-08-23
      FIBDataset150.SelectSql.Clear;
      FIBDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and CAIXA = ' + QuotedStr(sCaixaOld) + ' and MODELO = ' + QuotedStr(FModeloOld));
      }
      FIBDataset150.SelectSQL.Text := SQL_NFCE_ibd150 +
                                      ' Where NUMERONF = ' + QuotedStr(FNumeroGerencial) +
                                      ' and CAIXA = ' + QuotedStr(sCaixaOld) +
                                      ' and MODELO = ' + QuotedStr(FModeloOld);
      FIBDataset150.Open;

      {Sandro Silva 2023-08-29 inicio
      FIBDataset150.Delete;

      FIBDataset150.Close;
      FIBDataset150.SelectSql.Clear;
      FIBDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(FCaixa) + ' and MODELO = ' + QuotedStr(FModeloDocumento));
      FIBDataset150.Open;

      if FModeloDocumento = '65' then
        sNovoNumero := FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMERONFCE', 1));

      if FModeloDocumento = '59' then
        sNovoNumero := FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMEROCFESAT_' + FCaixa, 1));

      if sNovoNumero = '' then
      begin
        Exit;
      end;

      dtDataNovo := Date;
      FIBDataset150.Append;
      FIBDataset150.FieldByName('NUMERONF').AsString  := sNovoNumero;
      FIBDataset150.FieldByName('DATA').AsDateTime    := dtDataNovo;
      FIBDataset150.FieldByName('CAIXA').AsString     := FCaixa;
      FIBDataset150.FieldByName('MODELO').AsString    := FModeloDocumento;
      FIBDataset150.FieldByName('GERENCIAL').AsString := FNumeroGerencial;
      if (FModeloOld <> '59') and (FModeloOld <> '65') then // Sandro Silva 2023-08-28
      begin
        if sGerencialOld <> '' then
          FIBDataset150.FieldByName('GERENCIAL').AsString := sGerencialOld; // Sandro Silva 2023-08-25
      end;
      FIBDataset150.FieldByName('NFEXML').AsString    := sXmlOld;
      FIBDataset150.Post;
      }

      if bPrecisarGerarNovoNumero = False then
      begin
        sNovoNumero := FIBDataset150.FieldByName('NUMERONF').AsString;
        dtDataNovo  := FIBDataset150.FieldByName('DATA').AsDateTime
      end
      else
      begin
        FIBDataset150.Delete;

        FIBDataset150.Close;
        {Mauricio Parizotto 2024-08-23
        FIBDataset150.SelectSql.Clear;
        FIBDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(FCaixa) + ' and MODELO = ' + QuotedStr(FModeloDocumento));
        }
        FIBDataset150.SelectSQL.Text := SQL_NFCE_ibd150 +
                                        ' Where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) +
                                        '   and CAIXA = ' + QuotedStr(FCaixa) +
                                        '   and MODELO = ' + QuotedStr(FModeloDocumento);
        FIBDataset150.Open;

        if FModeloDocumento = '65' then
          sNovoNumero := FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMERONFCE', 1));

        if FModeloDocumento = '59' then
          sNovoNumero := FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMEROCFESAT_' + FCaixa, 1));
      end;

      if sNovoNumero = '' then
      begin
        Exit;
      end;

      if bPrecisarGerarNovoNumero then
      begin
        dtDataNovo := Date;
        FIBDataset150.Append;
        FIBDataset150.FieldByName('NUMERONF').AsString  := sNovoNumero;
        FIBDataset150.FieldByName('DATA').AsDateTime    := dtDataNovo;
        FIBDataset150.FieldByName('CAIXA').AsString     := FCaixa;
        FIBDataset150.FieldByName('MODELO').AsString    := FModeloDocumento;
        FIBDataset150.FieldByName('GERENCIAL').AsString := FNumeroGerencial;
        if (FModeloOld <> '59') and (FModeloOld <> '65') then // Sandro Silva 2023-08-28
        begin
          if sGerencialOld <> '' then
            FIBDataset150.FieldByName('GERENCIAL').AsString := sGerencialOld; // Sandro Silva 2023-08-25
        end;
        FIBDataset150.FieldByName('NFEXML').AsString    := sXmlOld;
        FIBDataset150.Post;
      end;
      {Sandro Silva 2023-08-29 fim}

      // Seleciona o desconto no total
      // Seleciona os desconto lançados para a venda (tanto nos itens qto no total do cupom)

      FIBDataSet27.Close;
      FIBDataSet27.SelectSQL.Clear;
      FIBDataSet27.SelectSQL.Text :=
        'select A.* ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(StrToIntDef(FNumeroGerencial, 0))) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(Form1.icupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixaOld) +
        ' and A.DESCRICAO = ''Desconto'' ' +
        ' and coalesce(A.ITEM, '''') = '''' ';
      FIBDataSet27.Open;

      FDescontoNoTotal := 0.00; // 2015-12-10
      while FIBDataSet27.Eof = False do
      begin

        if (Trim(FIBDataSet27.FieldByName('DESCRICAO').AsString) = 'Desconto') and (Trim(FIBDataSet27.FieldByName('ITEM').AsString) = '') then
        begin // Corrigir casos que ao entrar em contingência zerou Form1.fDescontoNoTotal, gerando xml com ICMSTot/vDesc zerado e ICMSTot/vNF com valor diferente da soma dos detPag/vPag
          FDescontoNoTotal := FIBDataSet27.FieldByName('TOTAL').AsFloat * -1;
        end;

        FIBDataSet27.Next;
      end;

///////////////////////
      if bPrecisarGerarNovoNumero then
      begin

        //Seleciona novamente o itens para alterar o número do pedido para o número do CFe
        FIBDataSet27.Close;
        FIBDataSet27.SelectSQL.Text :=
          'select * from ALTERACA where CAIXA = ' + QuotedStr(sCaixaOld) + ' and PEDIDO = ' + QuotedStr(FNumeroGerencial) +
          ' and COO is null'; // Apenas os itens da venda atual. Para separar de vendas anteriores com mesmo número do caixa
        FIBDataSet27.Open;

        sDAV     := '';
        sTIPODAV := '';
        //sAlteracaPedidoOld := FIBDataSet27.FieldByName('PEDIDO').AsString;

        {Sandro Silva 2023-08-25 inicio
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
        }
        AtualizaNumeroPedidoTabelaPendencia(FIBTransaction, sCaixaOld, FNumeroGerencial, sNovoNumero, FCaixa);
        {Sandro Silva 2023-08-25 fim}
        FIBDataSet27.First; // Sandro Silva 2023-08-29
        while FIBDataSet27.Eof = False do
        begin
          if FDadosCliente.Nome = '' then
            FDadosCliente.Nome    := FIBDataSet27.FieldByName('CLIFOR').AsString;
          if FDadosCliente.CNPJCPF = '' then
            FDadosCliente.CNPJCPF := FIBDataSet27.FieldByName('CNPJ').AsString;

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
        {Mauricio Parizotto 2024-06-18 Inicio}
        //PIX
        Form1.sTipoPix := '';
        Form1.AtualizaDocumentoTransItau(FIBDataSet27.Transaction, sCaixaOld, FNumeroGerencial, FCaixa, sNovoNumero);
        if GetAutorizacaoItau(sNovoNumero, FCaixa, FIBDataSet27.Transaction, Form1.sCodigoAutorizacaoPIX, Form1.sCNPJInstituicaoPIX ) then
          Form1.sTipoPix := _PixDinamico;
        {Mauricio Parizotto 2024-06-18 Fim}


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
              FIBDataSet7.FieldByName('HISTORICO').AsString := StringReplace(FIBDataSet7.FieldByName('HISTORICO').AsString, 'trans.', 'tran.', [rfReplaceAll]);
              FIBDataSet7.FieldByName('HISTORICO').AsString := StringReplace(FIBDataSet7.FieldByName('HISTORICO').AsString, 'caixa ', 'Caixa: ', [rfReplaceAll]);
              FIBDataSet7.FieldByName('HISTORICO').AsString := StringReplace(FIBDataSet7.FieldByName('HISTORICO').AsString, 'Caixa: ' + sCaixaOld, 'Caixa: ' + FCaixa, [rfReplaceAll]);
              FIBDataSet7.FieldByName('DOCUMENTO').AsString := FCaixa + sNovoNumero + RightStr(FIBDataSet7.FieldByName('DOCUMENTO').AsString, 1);
              FIBDataSet7.FieldByName('EMISSAO').AsDateTime := dtDataNovo;
              FIBDataSet7.Post;
            except
            end;
          end;
          FIBDataSet7.Next;
        end;
      end; // Sandro Silva 2023-08-29 if bPrecisarGerarNovoNumero then

      FIBDataSet25.Append; // para distribuir os valores pago e gerar o xml

      FormasPagamento.Clear;
      FValorTotalTEFPago := 0.00;

      // Atualiza dados da tabela PAGAMENT e trás FORMASPAGAMENTO carregada com os dados
      AtualizaDadosPagament(FIBDataSet28, FModeloDocumento, sCaixaOld, FNumeroGerencial, FCaixa, sNovoNumero, dtDataNovo,
        FConveniado, FVendedor, FormasPagamento, FValorTotalTEFPago, FTransacoesCartao, ModalidadeTransacao);
      {Sandro Silva 2023-08-25 fim}

      FIBDataSet25.FieldByName('RECEBER').AsFloat    := FormasPagamento.TotalReceber;
      FIBDataSet25.FieldByName('ACUMULADO1').AsFloat := FormasPagamento.Cheque;
      FIBDataSet25.FieldByName('ACUMULADO2').AsFloat := FormasPagamento.Dinheiro;
      FIBDataSet25.FieldByName('PAGAR').AsFloat      := FormasPagamento.Cartao;
      FIBDataSet25.FieldByName('DIFERENCA_').AsFloat := FormasPagamento.Prazo;
      FIBDataSet25.FieldByName('VALOR01').AsFloat    := FormasPagamento.Extra1;
      FIBDataSet25.FieldByName('VALOR02').AsFloat    := FormasPagamento.Extra2;
      FIBDataSet25.FieldByName('VALOR03').AsFloat    := FormasPagamento.Extra3;
      FIBDataSet25.FieldByName('VALOR04').AsFloat    := FormasPagamento.Extra4;
      FIBDataSet25.FieldByName('VALOR05').AsFloat    := FormasPagamento.Extra5;
      FIBDataSet25.FieldByName('VALOR06').AsFloat    := FormasPagamento.Extra6;
      FIBDataSet25.FieldByName('VALOR07').AsFloat    := FormasPagamento.Extra7;
      FIBDataSet25.FieldByName('VALOR08').AsFloat    := FormasPagamento.Extra8;

      //AtualizaDadosTransacaoEletronica(FIBDataSet28.Transaction, FNumeroGerencial, sCaixaOld, sModeloOld, dtDataNovo, sNovoNumero, FCaixa, FModeloDocumento);

      Result := True;

      FNumeroNF := sNovoNumero;
    end;
  except

  end;
  if FNumeroNF = '' then
    Result := False;

  if Result = False then
  begin
    if FibDataSet27.Transaction.Active then
      FibDataSet27.Transaction.Rollback;

    if FibDataSet28.Transaction.Active then
      FibDataSet28.Transaction.Rollback;
  end;
  FreeAndNil(FormasPagamento);
  FreeAndNil(IBQCONSULTA);

end;

procedure TConverteVendaParaNovoDocFiscal.SetNumeroGerencial(const Value: String);
begin
  FNumeroGerencial := FormataNumeroDoCupom(StrToIntDef(Value, 0));
end;

end.
