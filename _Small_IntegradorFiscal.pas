{
Unit contendo métodos para comunicação com integrador fiscal do Ceará
Autor: Sandro Luis da Silva
}
unit _Small_IntegradorFiscal;

interface

uses

  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, IniFiles, IBCustomDataSet, IBQuery, IBDatabase, StrUtils,
  smallfunc
  , ufuncoesfrente
  , Fiscal
  , umfe
  , ShellApi, StdCtrls;

const CHAVE_SERIAL_POS                   = 'Serial POS';
const CHAVE_VENDA_NO_CARTAO              = 'Venda no Cartao';
const CHAVE_CAMINHO_INTEGRADOR_FISCAL    = 'Caminho Integrador';
const CHAVE_CHAVE_ACESSO_VALIDADOR       = 'Chave Validador';
const CHAVE_CHAVE_REQUISICAO             = 'Chave Requisicao';
const CHAVE_ID_ADQUIRENTE                = 'ID Adquirente';

function QtdAdquirentes: Integer;
function AdquirentePadrao: String;
function ConfiguraCaminhoIntegradorFiscal: Boolean; // Sandro Silva 2018-07-03
function ConfiguraChaveAcessoValidadorFiscal: Boolean;
function ConfiguraChaveRequisicaoValidadorFiscal: Boolean;
function CodigoEstabelecimentoIntegradorFiscal: Boolean;
function ValorBaseICMSValidadorFiscal(sNumeroCupom: String; sCaixa: String): Double;
function EnviarPagamentoValidadorFiscal(sForma: String;
  dValorTotalVenda: Double; sNumeroCupom: String; sCaixa: String;
  bEnviandoPendentes: Boolean): Boolean;
function EnviarStatusPagamentoValidadorFiscal: Boolean;
function VerificarStatusValidadorFiscal(dValorPago: Double): Boolean;
function EnviarRespostaFiscalValidadorFiscal(DFeID: String): Boolean;
function GravarRespostaFiscalValidadorFiscal(dtData: TDate; sPedido: String;
  sCaixa: String; sForma: String; dValor: Double; idPagamento: String;
  idRespostaFiscal: String; sTransmitido: String; sTransacao: String;
  sNomeRede: String; sAutorizacao: String; sBandeira: String): Boolean;
function ExcluirIdentificadorVFPE(sPedido: String;
  sCaixa: String; sForma: String): Boolean;
function EnviarRespostaFiscalPendente(IBTransaction: TIBTransaction;
  sModelo: String; lblmsg: TLabel; sCaixa: String = ''; bTodasPendencias: Boolean = True): Integer;
function InicializaIntegradorFiscal(lblmsg: TLabel): Boolean;

implementation

uses udadospos;

function QtdAdquirentes: Integer;
var
  iSecao: Integer;
  iQtd: Integer;
  sl : TStringList;
  ini: TIniFile;
  sNomeSecao: String;
begin

  ini := TIniFile.Create(FRENTE_INI);
  sl := TStringList.Create;

  sl.Clear;
  ini.ReadSections(sl); //Conta o número de itens

  iQtd := 0;
  for iSecao := 0 to sl.Count - 1 do
  begin
    if AnsiContainsText(sl.Strings[iSecao], 'ADQUIRENTE') then
    begin
      sNomeSecao := sl.Strings[iSecao];
      Inc(iQtd);
    end;
  end;
  Result := iQtd;

  sl.Free;
  ini.Free;

end;

function AdquirentePadrao: String;
var
  iSecao: Integer;
  sl: TStringList;
  ini: TIniFile;
begin
  // Cria TIniFile e TStringList aqui porque não executa onShow igual as outras situações
  ini     := TIniFile.Create(FRENTE_INI);
  sl := TStringList.Create;

  sl.Clear;
  ini.ReadSections(sl); //conta o número de itens

  for iSecao := 0 to sl.Count - 1 do
  begin
    if AnsiContainsText(sl.Strings[iSecao], 'ADQUIRENTE') then
    begin
      if ini.ReadString(sl.Strings[iSecao], 'Padrao', 'Não') = 'Sim' then
        Result := ini.ReadString(sl.Strings[iSecao], 'Nome', '');
    end;
  end;
  sl.Free;
  ini.Free;
end;

function ConfiguraCaminhoIntegradorFiscal: Boolean; // Sandro Silva 2018-07-03
var
  sCaminho: String;
begin
  Result := False;
  try
    sCaminho := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, Form1.IntegradorCE.CaminhoIntegrador);
    if sCaminho = '' then
      sCaminho := 'c:\Integrador';
    sCaminho := Trim(Form1.Small_InputBox('Caminho de comunicação com Integrador Fiscal', 'Informe o caminho do diretório para comunição com Integrador Fiscal', sCaminho));
    if sCaminho <> '' then
    begin
      if DirectoryExists(sCaminho) then
      begin
        GravarParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CAMINHO_INTEGRADOR_FISCAL, sCaminho);
        Form1.IntegradorCE.CaminhoIntegrador := sCaminho;
      end
      else
        ShowMessage('Caminho não encontrado');
    end;
    Result := True;
  except
  end;
end;

function ConfiguraChaveAcessoValidadorFiscal: Boolean;
var
  sChaveAcessoValidador: String;
begin
  Result := False;
  try

    sChaveAcessoValidador := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, Form1.IntegradorCE.ChaveAcessoValidador);
    sChaveAcessoValidador := Trim(Form1.Small_InputBox('Chave de Acesso ao Validador', 'Informe Código de identificação do Estabelecimento junto a SEFAZ e ao módulo do Validador', sChaveAcessoValidador));
    if sChaveAcessoValidador <> '' then
    begin
    
      if (Trim(LerParametroIni(Form1.sArquivo, SECAO_59, 'Assinatura Associada', '')) <> '') and (sChaveAcessoValidador <> '') then
      begin
        if (Trim(LerParametroIni(Form1.sArquivo, SECAO_59, 'Assinatura Associada', '')) = sChaveAcessoValidador) then
        begin
          Application.MessageBox(PChar('Configure corretamente a Identificação do Estabelecimento Junto a SEFAZ ' + #13 + #13 +
                                       'Não deve ser igual a Assinatura Associada'), 'Atenção', MB_ICONWARNING + MB_OK);
          Exit;
        end;
      end;

      GravarParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_ACESSO_VALIDADOR, sChaveAcessoValidador);
      Form1.IntegradorCE.ChaveAcessoValidador := sChaveAcessoValidador;
    end;

    Result := True;
  except
  end;
end;

function ConfiguraChaveRequisicaoValidadorFiscal: Boolean;
var
  sChaveRequisicao: String;
begin
  Result := False;
  try
    sChaveRequisicao := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_REQUISICAO, Form1.IntegradorCE.ChaveRequisicao);
    sChaveRequisicao := Trim(Form1.Small_InputBox('Chave de Requisição', 'Informe a Chave de Requisição para integração com o Validador Fiscal. Ex.: 26359854-5698-1365-9856-965478231456', sChaveRequisicao));
    if sChaveRequisicao <> '' then
    begin
      GravarParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_CHAVE_REQUISICAO, sChaveRequisicao);
      Form1.IntegradorCE.ChaveRequisicao := sChaveRequisicao;
    end;

    Result := True;
  except
  end;
end;

function CodigoEstabelecimentoIntegradorFiscal: Boolean;
// Código do estabelecimento para usar com integrador fiscal
var
  sIdAdquirente: String;
begin
  Result := False;
  try
    sIdAdquirente := LerParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_ID_ADQUIRENTE, Form1.IntegradorCE.CodigoEstabelecimento);
    sIdAdquirente := Trim(Form1.Small_InputBox('Código do Estabelecimento/MerchantID', 'Informe Código do Estabelecimento/MerchantID fornecido pela Adquirente', sIdAdquirente));
    if sIdAdquirente <> '' then
    begin
      GravarParametroIni(FRENTE_INI, SECAO_MFE, CHAVE_ID_ADQUIRENTE, sIdAdquirente);
      Form1.IntegradorCE.CodigoEstabelecimento := sIdAdquirente;
    end;

    Result := True;
  except
  end;
end;

function ValorBaseICMSValidadorFiscal(sNumeroCupom,
  sCaixa: String): Double;
// Sandro Silva 2017-05-15 Calcula e retorna o valor da base de cálculo do ICMS para enviar ao integrador fiscal
var
  IBQALTERACA: TIBQuery;
  IBQDESCONTOITEM: TIBQuery;
  IBQDESCONTOCUPOM: TIBQuery;
  IBQACRESCIMOCUPOM: TIBQuery;
  IBQTOTALCUPOM: TIBQuery;
  dDescontoItem: Double;
  dRateioDescontoItem: Double;
  dRateioAcrescimoItem: Double;
begin
  Result := 0.00;

  IBQALTERACA       := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOITEM   := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQDESCONTOCUPOM  := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQACRESCIMOCUPOM := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQTOTALCUPOM     := CriaIBQuery(Form1.ibDataSet27.Transaction);

  // Seleciona os itens vendidos
  IBQALTERACA.Close;
  IBQALTERACA.SQL.Text :=
    'select ' +
    'A.ITEM, A.CODIGO, A.DESCRICAO, A.QUANTIDADE, A.UNITARIO, ' +
    '(coalesce(A.TOTAL, 0) + coalesce(A.DESCONTO, 0)) as VL_ITEM, ' +
    'E.TIPO_ITEM ' +
    'from ALTERACA A ' +
    'left join ESTOQUE E on E.CODIGO = A.CODIGO ' +
    'where A.PEDIDO = ' + QuotedStr(sNumeroCupom) +
    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
    ' and A.CAIXA = ' + QuotedStr(sCaixa) +// Sandro Silva 2017-09-04  QuotedStr(Form1.sCaixa) +
    //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
    ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
     ' and A.DESCRICAO <> ''Desconto'' ' +
     ' and A.DESCRICAO <> ''Acréscimo'') ' +
    ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
    ' order by A.REGISTRO';
  IBQALTERACA.Open;

  // Seleciona os descontos concedidos específicos aos itens
  IBQDESCONTOITEM.Close;
  IBQDESCONTOITEM.SQL.Text :=
    'select A.CODIGO, A.ITEM, A.TOTAL as DESCONTO ' +
    'from ALTERACA A ' +
    'where A.PEDIDO = ' + QuotedStr(sNumeroCupom) +
    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
    ' and A.CAIXA = ' + QuotedStr(sCaixa) +
    //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
    ' and A.DESCRICAO = ''Desconto'' ' +
    ' and coalesce(A.ITEM, '''') <> '''' ' +
    ' order by A.ITEM'; // Que tenha número do item informado no campo ALTERACA.ITEM
  IBQDESCONTOITEM.Open;

  // Seleciona os descontos lançados para o cupom
  IBQDESCONTOCUPOM.Close;
  IBQDESCONTOCUPOM.SQL.Text :=
    'select sum(A.TOTAL) as DESCONTOCUPOM ' +
    'from ALTERACA A ' +
    'where A.PEDIDO = ' + QuotedStr(sNumeroCupom) +
    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
    ' and A.CAIXA = ' + QuotedStr(sCaixa) +
    //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
    ' and A.DESCRICAO = ''Desconto'' ' +
    ' and coalesce(A.ITEM, '''') = '''' ';
  IBQDESCONTOCUPOM.Open;

  // Seleciona os acréscimos lançados para o cupom
  IBQACRESCIMOCUPOM.Close;
  IBQACRESCIMOCUPOM.SQL.Text :=
    'select sum(A.TOTAL) as ACRESCIMOCUPOM ' +
    'from ALTERACA A ' +
    'where A.PEDIDO = ' + QuotedStr(sNumeroCupom) +
    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
    ' and A.CAIXA = ' + QuotedStr(sCaixa) +
    //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
    ' and A.DESCRICAO = ''Acréscimo'' ' +
    ' and coalesce(A.ITEM, '''') = '''' ';
  IBQACRESCIMOCUPOM.Open;

  // Seleciona o total do cupom
  IBQTOTALCUPOM.Close;
  IBQTOTALCUPOM.SQL.Text :=
    'select sum(A.TOTAL + coalesce(A.DESCONTO, 0)) as TOTALCUPOM ' +
    'from ALTERACA A ' +
    'where A.PEDIDO = ' + QuotedStr(sNumeroCupom) +
    ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
    ' and A.CAIXA = ' + QuotedStr(sCaixa) +
    //' and A.DATA = ' + QuotedStr(FormataDataSQL(dtData)) +
    ' and (A.DESCRICAO <> ''<CANCELADO>'') '  +
    ' and (A.DESCRICAO <> ''Desconto'') ' +
    ' and (A.DESCRICAO <> ''Acréscimo'') ';
  IBQTOTALCUPOM.Open;

  while IBQALTERACA.Eof = False do
  begin

      dDescontoItem := 0;
      if IBQDESCONTOITEM.Locate('ITEM', IBQALTERACA.FieldByName('ITEM').AsString, []) then
        dDescontoItem := IBQDESCONTOITEM.FieldByName('DESCONTO').AsFloat;

      dRateioDescontoItem := StrToFloat(StrZero((((IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat) +
                                                  dDescontoItem) / IBQTOTALCUPOM.FieldByName('TOTALCUPOM').AsFloat) * IBQDESCONTOCUPOM.FieldByName('DESCONTOCUPOM').AsFloat, 0, 2));

      dRateioAcrescimoItem := StrToFloat(StrZero((((IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat) +
                                                  dDescontoItem) / IBQTOTALCUPOM.FieldByName('TOTALCUPOM').AsFloat) * IBQACRESCIMOCUPOM.FieldByName('ACRESCIMOCUPOM').AsFloat, 0, 2));

      if Trim(IBQALTERACA.FieldByName('TIPO_ITEM').AsString) <> '09' then
      begin
        Result := Result + StrToFloat(FormatFloat('0.00', IBQALTERACA.FieldByName('QUANTIDADE').AsFloat * IBQALTERACA.FieldByName('UNITARIO').AsFloat))
                         + dRateioAcrescimoItem
                         - Abs(dRateioDescontoItem)
                         - Abs(dDescontoItem);
      end;

    IBQALTERACA.Next;
  end;

  FreeAndNil(IBQALTERACA);
  FreeAndNil(IBQDESCONTOITEM);
  FreeAndNil(IBQDESCONTOCUPOM);
  FreeAndNil(IBQACRESCIMOCUPOM);
  FreeAndNil(IBQTOTALCUPOM);
end;

function EnviarPagamentoValidadorFiscal(sForma: String;
  dValorTotalVenda: Double; sNumeroCupom, sCaixa: String;
  bEnviandoPendentes: Boolean): Boolean;
var
  sSerialPOS: String;
  sChaveRequisicao: String;
  sCodigoEstabelecimento: String;
  sFormaEnviar: String;
  sUltimoNSU: String;
begin

  sForma := AnsiUpperCase(sForma);
  Form1.IntegradorCE.UsandoSimuladorPOS := False; // Sandro Silva 2017-09-21
  if AnsiContainsText(sForma, 'TEF') then
  begin
    sFormaEnviar           := '03 Cartao';
    sChaveRequisicao       := Form1.IntegradorCE.ChaveRequisicao;
    sCodigoEstabelecimento := Form1.IntegradorCE.CodigoEstabelecimento;
    sSerialPOS := 'TEF'; // Roteiro de processamento com Internet e utilizando TEF: Enviar dados do pagamento ao Validador Fiscal, no “serialpos” deverá ir a palavra “TEF”
  end
  else if AnsiContainsText(sForma, 'POS') then     //POS
  begin
    {
    if (LerParametroIni('arquivoauxiliarcriptografadopafecfsmallsoft.ini', 'SAT-CFe', 'Assinatura Associada', '') = 'CODIGO DE VINCULACAO AC DO MFE-CFE') // MFE ELGIN
      or (LerParametroIni('arquivoauxiliarcriptografadopafecfsmallsoft.ini', 'SAT-CFe', 'Assinatura Associada', '') = 'SGR-SAT SISTEMA DE GESTAO E RETAGUARDA DO SAT') // MFE TANCA/BEMATECH
    then
    }
    if UsaKitDesenvolvimentoSAT then
    begin
      Form1.IntegradorCE.UsandoSimuladorPOS := True; // Sandro Silva 2017-09-21
      if bEnviandoPendentes then
      begin
        Form1.IntegradorCE.SerialPOS        := FormatDateTime('HHMMSS', Time);
      end
      else
      begin
        sUltimoNSU := '';
        if Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count > 0 then
        begin
          sUltimoNSU := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NSU;
        end;

        if (Form1.IntegradorCE.UltimoidPagamento = '') or ((sUltimoNSU <> '')) then
          Form1.IntegradorCE.SerialPOS      := FormatDateTime('HHMMSS', Time);

      end;
    end;
    sFormaEnviar           := '03 Cartao';
    sSerialPOS             := Form1.IntegradorCE.SerialPOS;
    sChaveRequisicao       := Form1.IntegradorCE.ChaveRequisicao;
    sCodigoEstabelecimento := Form1.IntegradorCE.CodigoEstabelecimento;
  end
  else
  begin   // Dinheiro, Cheque, Prazo
    sFormaEnviar           := sForma;
    sSerialPOS             := FormatDateTime('HHMM', Time);
    sChaveRequisicao       := Form1.IntegradorCE.CriarChaveRequisicao;
    sCodigoEstabelecimento := FormatDateTime('HHMM', Time);
  end;

  Form1.ExibePanelMensagem('Enviando informações do pagamento com cartão ao Integrador Fiscal: ' + sCaixa + '-' + sNumeroCupom);

  Form1.IntegradorCE.EnviarPagamento(sChaveRequisicao, sCodigoEstabelecimento, sFormaEnviar, sSerialPOS, Abs(ValorBaseICMSValidadorFiscal(sNumeroCupom, sCaixa)), Abs(dValorTotalVenda), 'true', 'false', 'BRL', 'false', sCaixa); // TEF

  Result := (Form1.IntegradorCE.UltimoidPagamento <> '');
  if Form1.IntegradorCE.UltimoidPagamento = '' then
  begin

    try
      if bEnviandoPendentes then // Sandro Silva 2020-09-11 if Form22.Active = False then
      begin
        Form1.ExibePanelMensagem(Form1.IntegradorCE.MensagemRetorno);
        if bEnviandoPendentes = False then // Sandro Silva 2020-09-01
          Sleep(1500);
      end;
    except

    end;

  end;
  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;

  Application.ProcessMessages; // Sandro Silva 2018-10-16 
end;

function EnviarStatusPagamentoValidadorFiscal: Boolean;
begin
  Result := True;

  Form1.ExibePanelMensagem('Enviando status de pagamento ao Integrador Fiscal');

  if Form1.IntegradorCE.idPagamentoTransmitido(Form1.IntegradorCE.UltimoidPagamento) = 'S' then
  begin
    Form1.IntegradorCE.EnviarStatusPagamento(Form1.IntegradorCE.TransacaoFinanceira.CodigoAutorizacao, // GetLinha('013-000'),                                                                            //CodigoAutorizacao
                                            Form1.IntegradorCE.TransacaoFinanceira.Bin, // IfThen(LimpaNumero(Form1.IntegradorCE.TransacaoFinanceira.GetLinha('010-004')) = '',  '0000',  Form1.IntegradorCE.TransacaoFinanceira.GetLinha('010-004')), //Bin,   // Sandro Silva 2017-05-22  '****',
                                            Form1.IntegradorCE.TransacaoFinanceira.DonoCartao, // IfThen(Form1.IntegradorCE.TransacaoFinanceira.GetLinha('210-027') = '',  '****',  Form1.IntegradorCE.TransacaoFinanceira.GetLinha('210-027')),          //DonoCartao,
                                            Form1.IntegradorCE.TransacaoFinanceira.DataExpiracao, // IfThen(LimpaNumero(Form1.IntegradorCE.TransacaoFinanceira.GetLinha('300-001')) = '',  '0000',  Form1.IntegradorCE.TransacaoFinanceira.GetLinha('741-000')),  //DataExpiracao,
                                            Form1.IntegradorCE.TransacaoFinanceira.InstituicaoFinanceira, // Form1.IntegradorCE.TransacaoFinanceira.GetLinha('010-000'),                                                                            //InstituicaoFinanceira,
                                            Form1.IntegradorCE.TransacaoFinanceira.Parcelas, // IfThen(StrToIntDef(Form1.IntegradorCE.TransacaoFinanceira.GetLinha('018-000'), 0) = 0, '1', Form1.IntegradorCE.TransacaoFinanceira.GetLinha('018-000')),//Parcelas,
                                            Form1.IntegradorCE.TransacaoFinanceira.CodigoPagamento, // Form1.IntegradorCE.TransacaoFinanceira.GetLinha('012-000'),                                                                            //CodigoPagamento,
                                            Form1.IntegradorCE.TransacaoFinanceira.ValorPagamento, // FloatToStr(StrToIntDef(Form1.IntegradorCE.TransacaoFinanceira.GetLinha('003-000'), 0) / 100),                                          //ValorPagamento,
                                            Form1.IntegradorCE.UltimoidPagamento,                                                                                        //IdFila,
                                            Form1.IntegradorCE.TransacaoFinanceira.Tipo, // Form1.IntegradorCE.TransacaoFinanceira.GetLinha('040-000'),                                                                            //Tipo,
                                            Form1.IntegradorCE.TransacaoFinanceira.UltimosQuatroDigitos // '****'                                                                                                              //UltimosQuatroDigitos
                                            );
    Sleep(500);
  end;

  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.idFila            := Form1.IntegradorCE.UltimoidPagamento;
  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao := Form1.IntegradorCE.TransacaoFinanceira.CodigoAutorizacao;     //Form1.IntegradorCE.TransacaoFinanceira.GetLinha('013-000');
  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu               := Form1.IntegradorCE.TransacaoFinanceira.CodigoPagamento;       //Form1.IntegradorCE.TransacaoFinanceira.GetLinha('012-000');
  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao := Form1.IntegradorCE.TransacaoFinanceira.CodigoAutorizacao;     //Form1.IntegradorCE.TransacaoFinanceira.GetLinha('013-000');
  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira          := Form1.IntegradorCE.TransacaoFinanceira.Tipo;                  //Form1.IntegradorCE.TransacaoFinanceira.GetLinha('040-000');
  Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente        := Form1.IntegradorCE.TransacaoFinanceira.InstituicaoFinanceira; //Form1.IntegradorCE.TransacaoFinanceira.GetLinha('010-000');

  Form1.OcultaPanelMensagem; 
end;

function VerificarStatusValidadorFiscal(
  dValorPago: Double): Boolean;
var
  itentativa: Integer;
begin
  Result := False; // Começa falso

  while True do
  begin

    Form1.ExibePanelMensagem('Verificando Status do Integrador Fiscal'); // Sandro Silva 2018-07-03

    if Trim(Form1.sTransaca) = '' then
    begin
      Break;
    end
    else
    begin
      iTentativa := 1;
      while iTentativa < 4 do
      begin
        Form1.IntegradorCE.VerificarStatusValidador(Form1.IntegradorCE.UltimoidPagamento);    
        if xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoAutorizacao') <> '' then
          Break;
        Sleep(3000);
        Inc(iTentativa);
      end;

      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.idFila            := Form1.IntegradorCE.UltimoidPagamento;
      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao := xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoAutorizacao');
      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu               := xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoPagamento');
      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao := xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoAutorizacao'); // Sandro Silva 2017-05-16  xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//NumerodeAprovacao');
      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira          := xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//Tipo'); // Sandro Silva 2018-07-03 xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//Bandeira');
      Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente        := xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//InstituicaoFinanceira');

      if (xmlNodeXML(Form1.IntegradorCE.MensagemRetorno, '//Resposta') = '')
        or (AnsiContainsText(xmlNodeXML(Form1.IntegradorCE.MensagemRetorno, '//CodigoAutorizacao'), 'queue item')) // <CodigoAutorizacao>queue item 84381004 not complete</CodigoAutorizacao>
         then
      begin
        // Integrador não respondeu os dados do pagamento
        // Solicitar digitação
        FDadosPOS.ShowModal;

        if FDadosPOS.ModalResult = mrOK then
        begin
          if (Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao <> '')
            and (Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu <> '')
            and (Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao <> '')
            and (Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira <> '')
            and (Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente <> '') then
          begin
            Result := True;
            Break;
          end;
        end;
      end
      else
      begin
        Result := (xmlNodeValueToFloat(Form1.IntegradorCE.MensagemRetorno, '//ValorPagamento') = dValorPago); // Valor inforrmado no pagamento deve ser o mesmo retornado
        Break;
      end;
    end;
  end; // while True do
  Form1.OcultaPanelMensagem;
end;

function EnviarRespostaFiscalValidadorFiscal(DFeID: String{;
  Nsu: String; NumerodeAprovacao: String; Bandeira: String;
  Adquirente: String}): Boolean;
var
  iForma: Integer;
begin
  Form1.ExibePanelMensagem('Enviando resposta fiscal ao Integrador Fiscal');

  for iForma := 0 to Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count - 1 do
  begin
    if Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[iForma].Transmitido = 'S' then
    begin
      Form1.IntegradorCE.EnviarRespostaFiscal(Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[iForma].idPagamento, LimpaNumero(DFeID));
    end;
  end;

  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;
  Result := True;
end;

function GravarRespostaFiscalValidadorFiscal(dtData: TDate; sPedido,
  sCaixa, sForma: String; dValor: Double; idPagamento, idRespostaFiscal,
  sTransmitido, sTransacao, sNomeRede, sAutorizacao, sBandeira: String): Boolean;
var
  IBQVFPE: TIBQuery;
  sRegistro: String;
  iForma: Integer;
begin
  Result := True;
  if AnsiContainsText(AnsiUpperCase(ConverteAcentos(sForma)), 'CARTAO') then // Sandro Silva 2017-06-30
  begin

    IBQVFPE := CriaIBQuery(Form1.ibDataSet28.Transaction);

    if (Trim(idPagamento) = '') and (Trim(idRespostaFiscal) <> '') then // Não passou idPagamento, mas tem idRespostaFiscal
    begin
      for iForma := 0 to Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1 do
      begin
        if Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[iForma].RespostaFiscal.idRespostaFiscal = idRespostaFiscal then
        begin
          idPagamento := Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[iForma].idPagamento;
          Break;
        end;
      end;
    end;

    try
      IBQVFPE.Close;
      IBQVFPE.SQL.Text :=
        'insert into VFPE (REGISTRO, DATA, PEDIDO, CAIXA, FORMA, VALOR, IDPAGAMENTO, IDRESPOSTAFISCAL, TRANSMITIDO, TRANSACAO, NOMEREDE, AUTORIZACAO, BANDEIRA) ' +
        ' values (:REGISTRO, :DATA, :PEDIDO, :CAIXA, :FORMA, :VALOR, :IDPAGAMENTO, :IDRESPOSTAFISCAL, :TRANSMITIDO, :TRANSACAO, :NOMEREDE, :AUTORIZACAO, :BANDEIRA)';
      sRegistro := FormatFloat('0000000000', IncrementaGenerator('G_VFPE', 1));
      IBQVFPE.ParamByName('REGISTRO').AsString         := sRegistro;
      IBQVFPE.ParamByName('DATA').AsDate               := dtData;
      IBQVFPE.ParamByName('PEDIDO').AsString           := sPedido;
      IBQVFPE.ParamByName('CAIXA').AsString            := sCaixa;
      IBQVFPE.ParamByName('FORMA').AsString            := sForma;
      IBQVFPE.ParamByName('VALOR').AsFloat             := dValor;
      IBQVFPE.ParamByName('IDPAGAMENTO').AsString      := idPagamento;
      IBQVFPE.ParamByName('IDRESPOSTAFISCAL').AsString := idRespostaFiscal;
      IBQVFPE.ParamByName('TRANSMITIDO').AsString      := sTransmitido;
      if (Length(LimpaNumero(idRespostaFiscal)) <> Length(idRespostaFiscal)) or (LimpaNumero(idRespostaFiscal) = '') then
      begin
        IBQVFPE.ParamByName('IDRESPOSTAFISCAL').AsString := '';
        IBQVFPE.ParamByName('TRANSMITIDO').AsString      := 'N';
      end;
      IBQVFPE.ParamByName('TRANSACAO').AsString        := Copy(sTransacao, 1, TamanhoCampo(IBQVFPE.Transaction, 'VFPE', 'TRANSACAO'));
      IBQVFPE.ParamByName('NOMEREDE').AsString         := Copy(sNomeRede, 1, TamanhoCampo(IBQVFPE.Transaction, 'VFPE', 'NOMEREDE'));
      IBQVFPE.ParamByName('AUTORIZACAO').AsString      := Copy(sAutorizacao, 1, TamanhoCampo(IBQVFPE.Transaction, 'VFPE', 'AUTORIZACAO'));
      IBQVFPE.ParamByName('BANDEIRA').AsString         := Copy(sBandeira, 1, TamanhoCampo(IBQVFPE.Transaction, 'VFPE', 'BANDEIRA'));
      IBQVFPE.ExecSQL;
    except
    end;

    FreeAndNil(IBQVFPE);
  end;
end;

function ExcluirIdentificadorVFPE(sPedido, sCaixa,
  sForma: String): Boolean;
var
  IBQVFPE: TIBQuery;
begin
  Result := True;

  IBQVFPE := CriaIBQuery(Form1.ibDataSet28.Transaction);

  try
    IBQVFPE.Close;
    IBQVFPE.SQL.Text :=
      'delete from VFPE ' +
      'where PEDIDO = ' + QuotedStr(sPedido) +
      ' and CAIXA = ' + QuotedStr(sCaixa) +
      ' and FORMA = ' + QuotedStr(sForma);
    IBQVFPE.ExecSQL;
  except
  end;

  FreeAndNil(IBQVFPE);
end;

function EnviarRespostaFiscalPendente(IBTransaction: TIBTransaction;
  sModelo: String; lblmsg: TLabel; sCaixa: String = ''; bTodasPendencias: Boolean = True): Integer;
// Sandro Silva 2017-09-01 Transmite
var
  IBQVFPE: TIBQuery;
  IBQSALVAR: TIBQuery;
  sIDPagamento: String;
  sidRespostaFiscal: String;
  iProcessado: Integer;
  iTransmitido: Integer;
  sFiltroPeriodo: String;
  iTotalPendentes: Integer; // Sandro Silva 2020-09-18
begin
  IBQVFPE   := CriaIBQuery(IBTransaction); // Sandro Silva 2020-09-11 IBQVFPE   := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQSALVAR := CriaIBQuery(IBTransaction); // Sandro Silva 2020-09-11 IBQSALVAR := CriaIBQuery(Form1.ibDataSet27.Transaction);
  IBQVFPE.DisableControls; // Sandro Silva 2020-09-18
  IBQSALVAR.DisableControls; // Sandro Silva 2020-09-18  
  iProcessado  := 0;
  iTransmitido := 0;

  lblmsg.Caption := 'Aguarde! Enviando resposta fiscal pendente ao Integrador Fiscal';
  lblmsg.Repaint;

  sFiltroPeriodo := '';
  if bTodasPendencias = False then
  begin
    sFiltroPeriodo := ' and V.DATA between current_date - 2 and current_date ';
  end;

  try
    IBQVFPE.Close;
    IBQVFPE.SQL.Text :=
      'select V.REGISTRO, V.PEDIDO, V.CAIXA, V.IDPAGAMENTO, V.VALOR, V.NOMEREDE, V.IDRESPOSTAFISCAL, V.TRANSACAO, V.AUTORIZACAO, V.BANDEIRA ' +
      ', N.NFEID ' +
      'from VFPE V ' +
      'join NFCE N on N.NUMERONF = V.PEDIDO and N.CAIXA = V.CAIXA and (N.MODELO = ''59'' or N.MODELO = ''65'') ' + // Sandro Silva 2018-07-03  'join NFCE N on N.NUMERONF = V.PEDIDO and N.CAIXA = V.CAIXA and N.MODELO = ''59'' ' +
      'where V.TRANSMITIDO = ''N'' ' +
      ' and coalesce(V.TRANSACAO, '''') <> '''' ' +
      ' and coalesce(V.NOMEREDE, '''') <> '''' ' +
      ' and V.CAIXA = ' + QuotedStr(sCaixa) + // Sandro Silva 2020-09-18  
      sFiltroPeriodo + // Sandro Silva 2020-09-18
      ' order by V.REGISTRO';
    IBQVFPE.Open;

    while IBQVFPE.Eof = False do
    begin

      lblmsg.Caption := 'Aguarde! Enviando resposta fiscal pendente ao Integrador Fiscal: ' + IBQVFPE.FieldByName('PEDIDO').AsString + '-' + IBQVFPE.FieldByName('CAIXA').AsString + ' ' + IBQVFPE.FieldByName('TRANSACAO').AsString;
      lblmsg.Repaint;

      Form1.Display('Aguarde! Enviando Dados ao Integrador Fiscal', 'Enviando resposta fiscal pendente ao Integrador Fiscal: ' + IBQVFPE.FieldByName('PEDIDO').AsString + '-' + IBQVFPE.FieldByName('CAIXA').AsString + ' ' + IBQVFPE.FieldByName('TRANSACAO').AsString);

      Inc(iProcessado);

      Form1.IntegradorCE.EnviarFormaPagamento.Clear;

      Form1.IntegradorCE.SelecionarDadosAdquirente('FRENTE.INI', IBQVFPE.FieldByName('NOMEREDE').AsString, Form1.sUltimaAdquirenteUsada); // Sandro Silva 2018-07-03  _ecf59_SelecionarDadosAdquirente(IBQVFPE.FieldByName('NOMEREDE').AsString);

      // Envia pagamento e obtem o novo idPagamento
      EnviarPagamentoValidadorFiscal(IfThen(Form1.sTef = 'Sim', 'CARTAO TEF', 'CARTAO POS'), IBQVFPE.FieldByName('VALOR').AsFloat, IBQVFPE.FieldByName('PEDIDO').AsString, IBQVFPE.FieldByName('CAIXA').AsString, True);

      //RespostaFiscal
      if (Trim(Form1.IntegradorCE.XMLResposta) <> '')
        and (AnsiContainsText(Form1.IntegradorCE.XMLResposta, '<StatusPagamento>EnviadoAoValidador</StatusPagamento>')) // Conseguiu enviar ao Integrador Fiscal
        and (AnsiContainsText(Form1.IntegradorCE.XMLResposta, '<Codigo>EE</Codigo>') = False)
        and (AnsiContainsText(Form1.IntegradorCE.XMLResposta, '<StatusPagamento>SalvoEmArmazenamentoLocal</StatusPagamento>') = False)
        and (AnsiContainsText(Form1.IntegradorCE.MensagemRetorno, 'queue item ' + Form1.IntegradorCE.UltimoidPagamento + ' not complete') = False) then// if AnsiContainsText(Form1.IntegradorCE.MensagemRetorno, 'queue item ' + Form1.IntegradorCE.idPagamento + ' not complete') = False then
      begin
        // Integrador respondeu

        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.idFila            := Form1.IntegradorCE.UltimoidPagamento;
        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.CodigoAutorizacao := Form1.IntegradorCE.UltimoidPagamento;
        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Nsu               := IBQVFPE.FieldByName('TRANSACAO').AsString; // xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoPagamento');
        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao := IBQVFPE.FieldByName('AUTORIZACAO').AsString; // xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//CodigoAutorizacao');// Sandro Silva 2017-05-16  xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//NumerodeAprovacao');
        if Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao = '' then
          Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.NumerodeAprovacao := IBQVFPE.FieldByName('TRANSACAO').AsString;
        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Bandeira          := IBQVFPE.FieldByName('BANDEIRA').AsString;; // xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//Bandeira');
        Form1.IntegradorCE.EnviarFormaPagamento.Formas.Items[Form1.IntegradorCE.EnviarFormaPagamento.Formas.Count -1].RespostaFiscal.Adquirente        := IBQVFPE.FieldByName('NOMEREDE').AsString; // xmlNodeValue(Form1.IntegradorCE.MensagemRetorno, '//InstituicaoFinanceira');
        {Sandro Silva 2018-07-03 fim}


        if Form1.IntegradorCE.UltimoidPagamento <> '' then
        begin
          sIdPagamento      := Form1.IntegradorCE.UltimoidPagamento;

          sidRespostaFiscal := Form1.IntegradorCE.EnviarRespostaFiscal(Form1.IntegradorCE.UltimoidPagamento, IBQVFPE.FieldByName('NFEID').AsString);

          if Trim(sidRespostaFiscal) <> '' then
          begin
            if IBQVFPE.FieldByName('IDRESPOSTAFISCAL').Size >= Length(Trim(sidRespostaFiscal)) then
            begin
              try
                IBQSALVAR.Close;
                IBQSALVAR.SQL.Text :=
                  'update VFPE set ' +
                  'IDPAGAMENTO = ' + QuotedStr(sIDPagamento) +
                  ', IDRESPOSTAFISCAL =  ' + QuotedStr(Trim(sidRespostaFiscal)) +
                  ', TRANSMITIDO = ''S'' ' +
                  ' where REGISTRO = ' + QuotedStr(IBQVFPE.FieldByName('REGISTRO').AsString);
                  IBQSALVAR.ExecSQL;
                  Inc(iTransmitido);
              except

              end;
            end;
          end;

        end;
      end
      else
      begin
        // Não conseguiu transmitir pagamento. Salva novo idPagamento local gerado
        if (AnsiContainsText(Form1.IntegradorCE.XMLResposta, '<StatusPagamento>SalvoEmArmazenamentoLocal</StatusPagamento>')) then
        begin
            if IBQVFPE.FieldByName('IDPAGAMENTO').AsString <> Trim(Form1.IntegradorCE.UltimoidPagamento) then
            begin
              try
                IBQSALVAR.Close;
                IBQSALVAR.SQL.Text :=
                  'update VFPE set ' +
                  'IDPAGAMENTO = ' + QuotedStr(Trim(Form1.IntegradorCE.UltimoidPagamento)) +
                  ' where REGISTRO = ' + QuotedStr(IBQVFPE.FieldByName('REGISTRO').AsString);
                  IBQSALVAR.ExecSQL;
                  Inc(iTransmitido);
              except

              end;
            end;
        end;
      end;
      IBQVFPE.Next;
    end; // while IBQ.Eof = False do

  except

  end;

  {Sandro Silva 2020-09-18 inicio}
  Result := iProcessado - iTransmitido;
  iTotalPendentes := 0;
  if bTodasPendencias = False then
  begin
    // Conta os pendentes, em qualquer período, para alertar se existirem
    IBQVFPE.Close;
    IBQVFPE.SQL.Text :=
      'select count(V.REGISTRO) as QTDPENDENTES ' +
      'from VFPE V ' +
      'join NFCE N on N.NUMERONF = V.PEDIDO and N.CAIXA = V.CAIXA ' + 
      'where V.TRANSMITIDO = ''N'' ' +
      ' and coalesce(V.TRANSACAO, '''') <> '''' ' +
      ' and coalesce(V.NOMEREDE, '''') <> '''' ';
    IBQVFPE.Open;

    iTotalPendentes := IBQVFPE.FieldByName('QTDPENDENTES').AsInteger;

  end;

  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible := False;

  if (Result > 0) or (iTotalPendentes > 0) then // Sandro Silva 2020-09-18 if Result > 0 then
  begin
    if lblmsg <> nil then
    begin
      lblmsg.Caption := 'Atenção! Confirmação de Pagamentos com Cartão não foram enviados para SEFAZ';

      lblmsg.Repaint;
      Application.ProcessMessages; // Sandro Silva 2018-10-16
      Sleep(5000);

      lblmsg.Caption := 'Faça o envio em F10-Menu/';
      if sModelo = '65' then
        lblmsg.Caption := lblmsg.Caption + 'NFC-e/';
      if sModelo = '59' then
        lblmsg.Caption := lblmsg.Caption + 'MFE/';
      lblmsg.Caption := lblmsg.Caption + 'Integrador Fiscal MFE/Enviar Dados Pendentes dos Pagamentos com Cartão...';
      lblmsg.Repaint;
      Application.ProcessMessages; // Sandro Silva 2018-10-16
      Sleep(5000); 
      {Sandro Silva 2020-09-18 fim}

    end;
    {Sandro Silva 2020-09-11 inicio}
  end;

  {Sandro Silva 2020-09-18 inicio}
  FreeAndNil(IBQVFPE);
  FreeAndNil(IBQSALVAR);
  {Sandro Silva 2020-09-18 fim}

end;

function InicializaIntegradorFiscal(lblmsg: TLabel): Boolean;
//Inicializa o integrador fiscal
var
  iSleep: Integer;
begin
  Result := True;
  try

    if lblmsg <> nil then
    begin
      lblmsg.Caption := 'Verificando se o Integrador Fiscal está em execução';
      lblmsg.Repaint;
    end;

    // Abre o Integrador se estiver executando o frente no mesmo pc que o integrador
    if ConsultaProcesso('Integrador.exe') = False then // Sandro Silva 2017-03-24
    begin
      if lblmsg <> nil then
      begin
        lblmsg.Caption := 'Aguardando o Integrador Fiscal Iniciar';
        lblmsg.Repaint;
      end;

      if FileExists(PChar('c:\Program Files (x86)\Integrador\Integrador.exe')) then
      begin
        ShellExecute(Application.Handle, 'runas', PChar('c:\Program Files (x86)\Integrador\Integrador.exe'), nil, nil, SW_SHOWNORMAL); // Sandro Silva 2019-07-16  WinExec(PChar('c:\Program Files (x86)\Integrador\Integrador.exe'), SW_NORMAL);
        //Sleep(10000);
        for iSleep := 10 Downto 1 do
        begin
          if lblmsg <> nil then
          begin
            lblmsg.Caption := 'Aguardando o Integrador Fiscal Iniciar... ';
            lblmsg.Repaint;
          end;

          Sleep(100); // Sleep(1000);
        end;
        Application.BringToFront;
      end;

      if ConsultaProcesso('Integrador.exe') = False then
      begin
        Application.MessageBox(PChar('O Integrador Fiscal não está aberto' + #13 + #13 +
                                     'Abra o Integrador Fiscal e reinicie o ' + ExtractFileName(Application.ExeName)), 'Atenção', MB_ICONWARNING + MB_OK); // Sandro Silva 2019-05-27 'Abra o Integrador Fiscal e reinicie o NFCE.EXE'), 'Atenção', MB_ICONWARNING + MB_OK);

        FecharAplicacao(ExtractFileName(Application.ExeName));
        Result := False;// Sandro Silva 2020-09-11  Abort;
        Exit;

      end;

    end;

  finally

  end;
end;

end.
