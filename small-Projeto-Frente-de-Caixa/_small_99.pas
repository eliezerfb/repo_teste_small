unit _Small_99;

interface

uses

  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls, SMALL_DBEdit, IniFiles,
  Unit2, ShellApi, Unit22
  {$IFDEF VER150}
  , IBQuery, IBDatabase
  {$ELSE}
  , IBX.IBQuery, IBX.IBDatabase
  {$ENDIF}
  , StrUtils
  , ufuncoesfrente // Sandro Silva 2018-07-03
  , usmallprint
  , tnPDF
  , Printers
  ;

const GERENCIAL_FORMA_01_DINHEIRO                                     = '01';
const GERENCIAL_FORMA_02_CHEQUE                                       = '02';
const GERENCIAL_FORMA_03_CARTAO_CREDITO                               = '03';
const GERENCIAL_FORMA_04_CARTAO_DEBITO                                = '04';
const GERENCIAL_FORMA_05_CREDITO_LOJA                                 = '05';
const GERENCIAL_FORMA_10_VALE_ALIMENTACAO                             = '10';
const GERENCIAL_FORMA_11_VALE_REFEICAO                                = '11';
const GERENCIAL_FORMA_12_VALE_PRESENTE                                = '12';
const GERENCIAL_FORMA_13_VALE_COMBUSTIVEL                             = '13';
const GERENCIAL_FORMA_16_DEPOSITO_BANCARIO                            = '16';
const GERENCIAL_FORMA_17_PAGAMENTO_INSTANTANEO                        = '17';
const GERENCIAL_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL      = '18'; //Transferência bancária, Carteira Digital
const GERENCIAL_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL = '19'; //Programa de fidelidade, Cashback, Crédito Virtual
const GERENCIAL_FORMA_99_OUTROS                                       = '99';

type
  TMobile = class(TComponent)
  private
    FVendaImportando: String;
  procedure SetVendaImportando(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property VendaImportando: String read FVendaImportando write SetVendaImportando;
  end;


type
   TFormaPagamento = record
     Forma: String;
     Valor: Double;
   end;

type
  TVenda99 = class // TVenda99 = class(TComponent)
    Formas: array of TFormaPagamento;
  private
    FTransaction: TIBTransaction;
    FPedido: String;
    FCaixa: String;
    FCliente: String;
    FCNPJCliente: String;
    //FfDescontoNoTotal: Currency;
    FaForma: array of TForma;
    FTroco: Currency;
    FMensagem: String;
    FTotal: Currency;
    FEmailCliente: String;
    FEnderecoCliente: String;
  procedure SetTransaction(const Value: TIBTransaction);
    procedure SetPedido(const Value: String);
    procedure SetCaixa(const Value: String);
    procedure SetCliente(const Value: String);
    procedure SetCNPJCliente(const Value: String);
    //procedure SetfDescontoNoTotal(const Value: Currency);
    procedure SetTroco(const Value: Currency);
    procedure SetMensagem(const Value: String);
    procedure SetEmailCliente(const Value: String);
    procedure SetEnderecoCliente(const Value: String);
  public
    constructor Create; // constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property IBTransaction: TIBTransaction read FTransaction write SetTransaction;
    property Pedido: String read FPedido write SetPedido;
    property Caixa: String read FCaixa write SetCaixa;
    property Cliente: String read FCliente write SetCliente;
    property CNPJCliente: String read FCNPJCliente write SetCNPJCliente;
    property EmailCliente: String read FEmailCliente write SetEmailCliente;
    property EnderecoCliente: String read FEnderecoCliente write SetEnderecoCliente;
    //property fDescontoNoTotal: Currency read FfDescontoNoTotal write SetfDescontoNoTotal;
    property Troco: Currency read FTroco write SetTroco;
    property Total: Currency read FTotal write FTotal;
    property Mensagem: String read FMensagem write SetMensagem;
    procedure AddForma(sForma: String; dValor: Currency);
    function FormasPagamento: String;
  end;


  function _ecf99_CodeErro(Pp1: Integer):Integer;
  function _ecf99_Inicializa(Pp1: String):Boolean;
  function _ecf99_Pagamento(Pp1: Boolean):Boolean;
  function _ecf99_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf99_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf99_SubTotal(Pp1: Boolean):Real;
  function _ecf99_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf99_Sangria(Pp1: Real):Boolean;
  function _ecf99_Suprimento(Pp1: Real):Boolean;
  function _ecf99_NovaAliquota(Pp1: String):Boolean;
  function _ecf99_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf99_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf99_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf99_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf99_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf99_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf99_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf99_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf99_LeituraX(pP1: Boolean):Boolean;
  function _ecf99_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf99_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf99_VersodoFirmware(pP1: Boolean): String;
  function _ecf99_NmerodeSrie(pP1: Boolean): String;
  function _ecf99_CGCIE(pP1: Boolean): String;
  function _ecf99_Cancelamentos(pP1: Boolean): String;
  function _ecf99_Descontos(pP1: Boolean): String;
  function _ecf99_ContadorSeqencial(pP1: Boolean): String;
  function _ecf99_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf99_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf99_NmdeRedues(pP1: Boolean): String;
  function _ecf99_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf99_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf99_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf99_NmdoCaixa(pP1: Boolean): String;
  function _ecf99_Nmdaloja(pP1: Boolean): String;
  function _ecf99_Moeda(pP1: Boolean): String;
  function _ecf99_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf99_Datadaultimareduo(pP1: Boolean): String;
  function _ecf99_Datadomovimento(pP1: Boolean): String;
  function _ecf99_Tipodaimpressora(pP1: Boolean): String;
  function _ecf99_StatusGaveta(Pp1: Boolean):String;
  function _ecf99_RetornaAliquotas(pP1: Boolean): String;
  function _ecf99_Vincula(pP1: String): Boolean;
  function _ecf99_FlagsDeISS(pP1: Boolean): String;
  function _ecf99_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf99_MudaMoeda(pP1: String): Boolean;
  function _ecf99_MostraDisplay(pP1: String): Boolean;
  function _ecf99_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf99_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf99_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean;
  function _ecf99_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf99_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf99_GrandeTotal(sP1: Boolean): String;
  function _ecf99_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf99_CupomAberto(sP1: Boolean): boolean;
  function _ecf99_FaltaPagamento(sP1: Boolean): boolean;
  function _ecf99_SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
  procedure _ecf99_RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double;
    iCupom: Integer; sCaixa: String);
  procedure _ecf99_RateioAcrescimo(dTotalVenda: Double; dAcrescimoTotal: Double;
    iCupom: Integer; sCaixa: String);
  function _ecf99_ImprimeVenda(Venda: TVenda99; IBTransaction: TIBTransaction;
    sPedido: String; sCaixa: String; sCNPJCliente: String; sNomeCliente: String;
    sEmailCliente: String; sEnderecoCliente: String): Boolean;
  function _ecf99_Visualiza_Venda(sPedido: String; sCaixa: String): Boolean;
  function _ecf99_ImprimirCupomDinamico(Venda: TVenda99; IBTransaction: TIBTransaction;
    sPedido: String; sCaixa: String; sCNPJCliente: String; sNomeCliente: String;
    sEmailCliente: String; sEnderecoCliente: String; Destino: TDestinoExtrato;
    sFileExport: String = ''): Boolean;

  procedure _ecf99_AcumulaFormaExtraNFCe(sOrdemExtra: String; dValor: Double;
      {Sandro Silva 2023-08-21 inicio
      var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
      var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
      var dvPag_YA03_99: Double);
      }
      var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
      var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
      var dvPag_YA03_16: Double; var dvPag_YA03_17: Double;
      var dvPag_YA03_18: Double; var dvPag_YA03_19: Double;
      var dvPag_YA03_99: Double
      );

var
  iCaracteres : Integer;
  Mobile_99: TMobile;
  aAcrescimoItem: array of Double; // 2016-01-08
  aDescontoItem: array of Double; // 2016-01-08
  iLarguraPapel: Integer;
  iMargemEsq: Integer;

implementation

uses Menus;

// ---------------------------------- //
// ---------------------------------- //
function _ecf99_CodeErro(Pp1: Integer):Integer;
begin
  Result := 0;
end;

//-------------------------------------------//
// Detecta qual a porta que                  //
// a impressora está conectada               //
// MATRICIAL MECAF / BEMATECH MP 2000 CI NF  //
//-------------------------------------------//
function _ecf99_Inicializa(Pp1: String):Boolean;
var
  iItem: Integer;
  Mais1ini: TIniFile;
begin
  //
  //Result := False;
  Application.Title := 'Aplicativo Gerencial'; // Sandro Silva 2023-06-23 Application.Title    := 'Aplicativo MEI';

  Mobile_99 := TMobile.Create(nil); // Sandro Silva 2016-08-25

  if (Form1.ibDataSet13.FieldByName('ESTADO').AsString = '') then
  begin
    Application.MessageBox(PChar('Acesse o Small e configure os dados do emitente ' + #13 +
                                 'e reinicie aplicação' + #13 + #13 +
                                 'Essa aplicação será fechada'),'Atenção', MB_ICONWARNING + MB_OK);
    FecharAplicacao(ExtractFileName(Application.ExeName));
    Abort;
  end;

  if DirectoryExists(ExtractFilePath(Application.ExeName) + 'VENDAS') = False then
    CreateDir(ExtractFilePath(Application.ExeName) + 'VENDAS');
  ForceDirectories(ExtractFilePath(Application.ExeName) + 'VENDAS');

  Form1.NFCe1.Caption := 'Gerencial'; // Sandro Silva 2023-06-23 'MEI';

  for iItem := 0 to Form1.NFCe1.Count - 1 do
  begin
    Form1.NFCe1.Items[iItem].Visible := False;
  end;

  Form1.ConfigurarNmerodoCaixa1.Visible         := True;
  Form1.GerenciadordeNFCe1.Visible              := True;
  Form1.RealatriosGerenciais1.Visible           := True;
  Form1.N19.Visible                             := True;
  Form1.ConfigurarImpressora1.Visible           := True;
  Form1.N16.Visible                             := True;
  Form1.ImportarvendasdoSmallMobile1.Visible    := True;
  Form1.LarguradoPapelA41.Visible               := True;
  Form1.LarguradoPapel76mm1.Visible             := True;
  Form1.ImprimirDANFCE1.Visible                 := True;

  {Sandro Silva 2020-10-14 inicio}
  Form1.NmerodoCredencimentodoPAFECF1.Visible        := False; // Sandro Silva 2017-08-04
  Form1.NmerodoCredencimentodaImpressoraECF1.Visible := False; // Sandro Silva 2017-08-04

  Mais1ini := TIniFile.Create('FRENTE.INI');
  if Mais1ini.ReadString('NFCE', 'Imprimir DANFCE', 'Sim')   = 'Sim' then
    Form1.ImprimirDANFCE1.Checked             := True
  else
    Form1.ImprimirDANFCE1.Checked             := False;
  if Mais1ini.ReadString('NFCE', 'Visualizar DANFCE', 'Não') = 'Sim' then
    Form1.VisualizarDANFCE1.Checked           := True
  else
    Form1.VisualizarDANFCE1.Checked           := False;
  Mais1ini.Free;
  {Sandro Silva 2020-10-14 fim}

  Form1.NFCenoperodo1.Caption                   := 'Documentos no período...'; // Sandro Silva 2020-08-24 Form1.NomeModeloDocumento('59') + ' no período...';  // Sandro Silva 2018-07-03  'CF-e-SAT no período'; // Sandro Silva 2018-06-04
  Form1.GerenciadordeNFCe1.Caption              := 'Gerenciador'; // Sandro Silva 2023-06-23 'Gerenciador de Vendas';
  Form1.ImprimirDANFCE1.Caption                 := 'Imprimir o Comprovante da Movimentação'; // Sandro Silva 2023-06-23 'Imprimir o Comprovante da Venda';
  //
  FormatSettings.DecimalSeparator := ',';
  FormatSettings.DateSeparator    := '/';
  //
  Result := True;
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// ------------------------------ //
function _ecf99_FechaCupom(Pp1: Boolean):Boolean;
begin
  //
  Result := True;
end;


// ------------------------------ //
// Formas de pagamento            //
// ------------------------------ //
function _ecf99_Pagamento(Pp1: Boolean):Boolean;
var
  dtEnvio: TDate; // Sandro Silva 2015-03-30 Data do envio. Usado para atualizar ALTERACA.DATA mantendo NFCE.DATA = ALTARACA.DATA.
  Venda: TVenda99;
  iTransacaoCartao: Integer;
  Mais1ini: TIniFile;
  dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13,
  dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19,
  dvPag_YA03_99: Double;
  sPdfMobile: String; // Sandro Silva 2020-10-08
begin
  Result := True;

  sPdfMobile := '';
  if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
    sPdfMobile := Form1.sAtual + '\mobile\' + StringReplace(Form1.ClienteSmallMobile.sVendaImportando, TIPOMOBILE, '', [rfReplaceAll]) + '.pdf';

  try
    dtEnvio := Now;

    if Form1.ibDataSet25ACUMULADO3.AsFloat > 0 then
    begin // Troco
      //sCupomFiscalVinculado := sCupomFiscalVinculado + Copy('Acréscimo'+Replicate(' ',30),1,30)+ Format('%10.2n',[Form1.ibDataSet25ACUMULADO3.AsFloat])+chr(10);
      // Formas extras NÃO devem ser ajustadas como feito com Dinheiro e cheque.
      // Pode ser vale refeição, sai dinheiro do caixa e fica uma conta para receber da operadora. Mesma situação do cartão de débito/crédito
      // Emitente tira "dinheiro vivo" do caixa para ficar com uma dívida a receber

      if Form1.ibDataSet25ACUMULADO2.AsFloat = 0.00 then //Dinheiro
      begin

        if Form1.ibDataSet25VALOR01.AsFloat > 0 then
          Form1.ibDataSet25VALOR01.AsFloat := Form1.ibDataSet25VALOR01.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR02.AsFloat > 0 then
          Form1.ibDataSet25VALOR02.AsFloat := Form1.ibDataSet25VALOR02.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR03.AsFloat > 0 then
          Form1.ibDataSet25VALOR03.AsFloat := Form1.ibDataSet25VALOR03.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR04.AsFloat > 0 then
          Form1.ibDataSet25VALOR04.AsFloat := Form1.ibDataSet25VALOR04.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR05.AsFloat > 0 then
          Form1.ibDataSet25VALOR05.AsFloat := Form1.ibDataSet25VALOR05.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR06.AsFloat > 0 then
          Form1.ibDataSet25VALOR06.AsFloat := Form1.ibDataSet25VALOR06.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR07.AsFloat > 0 then
          Form1.ibDataSet25VALOR07.AsFloat := Form1.ibDataSet25VALOR07.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

        if Form1.ibDataSet25VALOR08.AsFloat > 0 then
          Form1.ibDataSet25VALOR08.AsFloat := Form1.ibDataSet25VALOR08.AsFloat - Form1.ibDataSet25ACUMULADO3.AsFloat;

      end; // if Form1.ibDataSet25ACUMULADO2.AsFloat = 0.00 then //Dinheiro

    end;

    try
      Form1.ibDataset150.Close;
      Form1.ibDataset150.SelectSql.Clear;
      Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('99')); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('99'));
      Form1.ibDataset150.Open;

      // Troca ALTERACA.DATA
      Form1.ibDataSet27.First;
      while Form1.ibDataSet27.Eof = False do
      begin

        try
          Form1.ibDataSet27.Edit;
          Form1.ibDataSet27.FieldByName('DATA').AsDateTime := dtEnvio;
          Form1.ibDataSet27.Post;
        except
        end;

        Form1.ibDataSet27.Next;
      end;

      // Troca PAGAMENT.DATA
      Form1.IBDataSet28.First;
      while Form1.IBDataSet28.Eof = False do
      begin

        try
          Form1.IBDataSet28.Edit;
          Form1.IBDataSet28.FieldByName('DATA').AsDateTime := dtEnvio;
          Form1.IBDataSet28.Post;
        except
        end;

        Form1.IBDataSet28.Next;
      end;

      // Troca RECEBER.EMISSAO
      Form1.ibDataSet7.First;
      while Form1.ibDataSet7.Eof = False do
      begin
        if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.icupom)+Copy(Form1.sCaixa, 1, 3)) then // Sandro Silva 2021-11-29 if (Form1.ibDataSet7.FieldByName('NUMERONF').AsString = StrZero(Form1.icupom,6,0)+Copy(Form1.sCaixa, 1, 3)) then
        begin

          try
            Form1.ibDataSet7.Edit;
            Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := FormataNumeroDoCupom(Form1.iCupom) + Copy(Form1.sCaixa, 1, 3); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('NUMERONF').AsString  := StrZero(Form1.iCupom, 6, 0) + Copy(Form1.sCaixa, 1, 3);
            Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + FormataNumeroDoCupom(Form1.icupom) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1); // Sandro Silva 2021-11-29 Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString := Form1.sCaixa + StrZero(Form1.iCupom, 6, 0) + RightStr(Form1.ibDataSet7.FieldByName('DOCUMENTO').AsString, 1);
            Form1.ibDataSet7.FieldByName('EMISSAO').AsDateTime := dtEnvio; // Sandro Silva 2016-04-27
            Form1.ibDataSet7.Post;
          except
          end;

        end;
        Form1.ibDataSet7.Next;
      end;

    except

    end;

    if (Form1.ClienteSmallMobile.sVendaImportando = '') then
    begin
      // Não retornar False se não imprimir ou enviar o email
      // False apenas se não conseguir gerar CF-e-SAT


        //_ecf99_Imprime_Venda(sLote);

    end
    else
    begin
      if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
      begin
        //if AnsiContainsText(sStatus, 'Autorizado') or AnsiContainsText(sStatus, 'NFC-e emitida') then
        begin
          {
          // Primeiro envia danfce para mobile
          try
            if DirectoryExists(Form1.sAtual + '\mobile') = False then
              ForceDirectories(Form1.sAtual + '\mobile');
            if sPdfMobile <> '' then
            begin

              Form1.spdNFCe1.ExportarDanfce(sLote, fNFe, _ecf65_ArquivoRTM, 1, sPdfMobile);

              _ecf99_Imprime_Venda(sLote,sPdfMobile);

              Sleep(1000);
              if FileExists(sPdfMobile) then
              begin
                // upload pdf
                UploadMobile(sPdfMobile);
                Sleep(1000);
                // Após upload exclui o arquivo
                DeleteFile(sPdfMobile);
              end;
            end;
          except
            on E: Exception do
            begin
              sLogErro := E.Message;
            end;
          end;
          }
        end;
      end; // Não é contingência
    end; // if (Form1.ClienteSmallMobile.sVendaImportando = '') then

    Venda := TVenda99.Create; // Venda := TVenda99.Create(nil);

    Venda.IBTransaction := Form1.ibDataSet27.Transaction;
    Venda.Pedido := FormataNumeroDoCupom(Form1.icupom);
    Venda.Caixa  := Form1.sCaixa;

    {Sandro Silva 2023-12-27 inicio}
    Venda.CNPJCliente     := Form2.Edit2.Text;
    Venda.Cliente         := Form2.Edit8.Text;
    Venda.EmailCliente    := Form2.Edit10.Text;
    Venda.EnderecoCliente := Form2.Edit1.Text + Chr(10) + Form2.Edit3.Text;
    {Sandro Silva 2023-12-27 fim}

    if Form1.ibDataSet25ACUMULADO2.AsFloat > 0 then
    begin
      //
      // Dinheiro
      //
      Venda.AddForma('Dinheiro', Form1.ibDataSet25ACUMULADO2.AsFloat);
      //
    end;
    //
    if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then
    begin
      //
      // Cheque
      //
      Venda.AddForma('Cheque', Form1.ibDataSet25ACUMULADO1.AsFloat);
    end;
    //
    if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then
    begin
      //
      // Prazo
      //
      Venda.AddForma('Prazo', Form1.ibDataSet25DIFERENCA_.AsFloat);
      //
    end;
    //
    // Mover para cima antes das outras formas, depois que Tecnospeed corrigir problema de gerar tag <card> em todas formas quando uma forma for cartão
    if Form1.fTEFPago                      > 0 then
    begin
      //
      // Cartão TEF ou POS
      //
      for iTransacaoCartao := 0 to Form1.TransacoesCartao.Transacoes.Count -1 do
      begin
        Venda.AddForma(Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].DebitoOuCredito, Form1.TransacoesCartao.Transacoes.Items[iTransacaoCartao].ValorPago);
      end;
      //
    end; // if Form1.fTEFPago                      > 0 then

    Mais1ini  := TIniFile.Create('FRENTE.INI');
    if Mais1Ini.ReadString(SECAO_65, CHAVE_FORMAS_CONFIGURADAS, 'Não') = 'Sim' then
    begin
      if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe1, Form1.ibDataSet25VALOR01.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe2, Form1.ibDataSet25VALOR02.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe3, Form1.ibDataSet25VALOR03.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe4, Form1.ibDataSet25VALOR04.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe5, Form1.ibDataSet25VALOR05.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe6, Form1.ibDataSet25VALOR06.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe7, Form1.ibDataSet25VALOR07.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then
      begin
        _ecf99_AcumulaFormaExtraNFCe(Form1.sOrdemExtraNFCe8, Form1.ibDataSet25VALOR08.AsFloat, dvPag_YA03_10, dvPag_YA03_11, dvPag_YA03_12, dvPag_YA03_13, dvPag_YA03_16, dvPag_YA03_17, dvPag_YA03_18, dvPag_YA03_19, dvPag_YA03_99);
      end;

      if dvPag_YA03_10 > 0 then
        Venda.AddForma('VALE ALIMENTACAO', dvPag_YA03_10); // 10=Vale Alimentação

      if dvPag_YA03_11 > 0 then
        Venda.AddForma('VALE REFEICAO', dvPag_YA03_11); // 11=Vale Refeição

      if dvPag_YA03_12 > 0 then
        Venda.AddForma('VALE PRESENTE', dvPag_YA03_12); // 12=Vale Presente

      if dvPag_YA03_13 > 0 then
        Venda.AddForma('VALE COMBUSTIVEL', dvPag_YA03_13); // 13=Vale Combustível

      if dvPag_YA03_16 > 0 then
        Venda.AddForma('DEPOSITO BANCARIO', dvPag_YA03_16); // 16=Deposito Bancario

      if dvPag_YA03_17 > 0 then
        Venda.AddForma('PAGAMENTO INSTANTANEO', dvPag_YA03_17); // 17=Pagamento Instantaneo

      if dvPag_YA03_18 > 0 then
        Venda.AddForma('TRANSF.BANCARIA CARTEIRA DIGITAL', dvPag_YA03_18); // 18=Transf.Bancaria Carteira Digital

      if dvPag_YA03_19 > 0 then
        Venda.AddForma('PROGR.FIDELIDADE CASHBACK CREDITO VIRTUAL', dvPag_YA03_19); // 19=Progr.Fidelidade Cashback Credito Virtual

      if dvPag_YA03_99 > 0 then
        Venda.AddForma('OUTROS', dvPag_YA03_99); // 99=Outros
    end
    else
    begin
      if (Form1.ibDataSet25VALOR01.AsFloat +
          Form1.ibDataSet25VALOR02.AsFloat +
          Form1.ibDataSet25VALOR03.AsFloat +
          Form1.ibDataSet25VALOR04.AsFloat +
          Form1.ibDataSet25VALOR05.AsFloat +
          Form1.ibDataSet25VALOR06.AsFloat +
          Form1.ibDataSet25VALOR07.AsFloat +
          Form1.ibDataSet25VALOR08.AsFloat) <> 0 then
      begin
        //
        Venda.AddForma('Outros',(Form1.ibDataSet25VALOR01.AsFloat +
                                 Form1.ibDataSet25VALOR02.AsFloat +
                                 Form1.ibDataSet25VALOR03.AsFloat +
                                 Form1.ibDataSet25VALOR04.AsFloat +
                                 Form1.ibDataSet25VALOR05.AsFloat +
                                 Form1.ibDataSet25VALOR06.AsFloat +
                                 Form1.ibDataSet25VALOR07.AsFloat +
                                 Form1.ibDataSet25VALOR08.AsFloat));
  //
      end;
    end;

    Venda.Troco := 0.00;
    if Form1.ibDataSet25ACUMULADO3.AsFloat > 0 then // Troco
    begin
      Venda.Troco := Form1.ibDataSet25ACUMULADO3.AsFloat;
    end;

    Venda.Mensagem := Form1.sMensagemPromocional;

    Mais1ini.Free;

    Form1.ibDataset150.Close;
    Form1.ibDataset150.SelectSql.Clear;
    Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('99')); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ' + QuotedStr('99'));
    Form1.ibDataset150.Open;

    Form1.ibDataset150.Edit;
    Form1.ibDataset150.FieldByName('STATUS').AsString := VENDA_GERENCIAL_FINALIZADA; // Fecha venda
    Form1.ibDataset150.FieldByName('DATA').AsDateTime := dtEnvio;
    Form1.ibDataset150.FieldByName('TOTAL').AsFloat   := Venda.Total - Venda.Troco; // Sandro Silva 2023-08-08 Form1.ibDataset150.FieldByName('TOTAL').AsFloat   := Venda.Total;
    Form1.ibDataset150.Post;

    if (Form1.ClienteSmallMobile.sVendaImportando = '') then
    begin
      // Não retornar False se não imprimir ou enviar o email
      // False apenas se não conseguir gerar CF-e-SAT
      if Form1.ImprimirDANFCE1.Checked then
       _ecf99_ImprimeVenda(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Venda.CNPJCliente, Venda.Cliente, Venda.EmailCliente, Venda.EnderecoCliente); // Sandro Silva 2023-12-27 _ecf99_ImprimeVenda(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Form2.Edit2.Text, Form2.Edit8.Text, Form2.Edit10.Text, Form2.Edit1.Text + Chr(10) + Form2.Edit3.Text);
    end
    else
    begin  // Importando MOBILE

      if Form1.ClienteSmallMobile.ImportandoMobile then // Sandro Silva 2022-08-08 if ImportandoMobile then
      begin
        //Primeiro envia extrato cf-e para mobile
        try
          if DirectoryExists(Form1.sAtual + '\mobile') = False then
            ForceDirectories(Form1.sAtual + '\mobile');

          if sPdfMobile <> '' then
          begin
            _ecf99_ImprimirCupomDinamico(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Venda.CNPJCliente, Venda.Cliente, Venda.EmailCliente, Venda.EnderecoCliente, toImage, sPdfMobile); // Sandro Silva 2023-12-28 _ecf99_ImprimirCupomDinamico(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Form2.Edit2.Text, Form2.Edit8.Text, Form2.Edit10.Text, Form2.Edit1.Text + Chr(10) + Form2.Edit3.Text, toImage, sPdfMobile);
            Sleep(1000);
            if FileExists(sPdfMobile) then
            begin
              // upload pdf
              Form1.ClienteSmallMobile.UploadMobile(sPdfMobile);
              // Após upload exclui o arquivo
              DeleteFile(sPdfMobile);
            end;
          end;
        except
          on E: Exception do
          begin
            //sLogErro := E.Message;
          end;
        end;

        try
          if Form1.ImprimirDANFCE1.Checked then
            _ecf99_ImprimeVenda(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Venda.CNPJCliente, Venda.Cliente, Venda.EmailCliente, Venda.EnderecoCliente); // Sandro Silva 2023-12-28 _ecf99_ImprimeVenda(Venda, nil, FormataNumeroDoCupom(Form1.icupom), Form1.sCaixa, Form2.Edit2.Text, Form2.Edit8.Text, Form2.Edit10.Text, Form2.Edit1.Text + Chr(10) + Form2.Edit3.Text);
        except
        end;

      end; // não é contingência if Pos(TIPOCONTINGENCIA, Form1.ClienteSmallMobile.sVendaImportando) = 0 then
    end;

    FreeAndNil(Venda);

  except

  end;
  Form1.OcultaPanelMensagem; // Sandro Silva 2018-08-31 Form1.Panel3.Visible  := False;
  //
  //DecodeTime((Time - tInicio), Hora, Min, Seg, cent);
  //Ativar para medir tempo Form1.Label_7.Hint := Form1.Label_7.Hint + #13 + 'Tempo de envio e impressão: '+' '+StrZero(Hora,2,0)+':'+StrZero(Min,2,0)+':'+StrZero(Seg,2,0)+':'+StrZero(cent,3,0)+' ';    // Sandro Silva 2018-04-24  Form1.Label_7.Hint := 'Tempo de envio e impressão: '+' '+StrZero(Hora,2,0)+':'+StrZero(Min,2,0)+':'+StrZero(Seg,2,0)+':'+StrZero(cent,3,0)+' ';

end;

// ------------------------------ //
// Cancela o último item          //
// ------------------------------ //
function _ecf99_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

function _ecf99_CancelaUltimoCupom(Pp1: Boolean):Boolean;
var
  IBQALTERACA: TIBQuery; // Sandro Silva 2023-11-01
begin
  IBQALTERACA := CriaIBQuery(Form1.ibDataSet27.Transaction);

  Result := False;
  //
  try
    //
    Form1.ibDataset150.Close;
    Form1.ibDataset150.SelectSql.Clear;
    Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(FormataNumeroDoCupom(Form1.iCupom)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa)); // Sandro Silva 2021-11-29 Form1.ibDataset150.SelectSQL.Add('select * from NFCE where NUMERONF='+QuotedStr(StrZero(Form1.iCupom,6,0)) + ' and CAIXA = ' + QuotedStr(Form1.sCaixa));
    Form1.ibDataset150.Open;
    //
    if Form1.ibDataset150.FieldByName('NUMERONF').AsString = FormataNumeroDoCupom(Form1.iCupom) then // Sandro Silva 2021-11-29 if Form1.ibDataset150.FieldByName('NUMERONF').AsString = StrZero(Form1.iCupom,6,0) then
    begin
      {Sandro Silva 2023-11-01 inicio
      //
      if Form1.ibDataSet150.FieldByName('STATUS').AsString <> VENDA_GERENCIAL_CANCELADA then
      begin
        try
          Form1.ibDataSet150.Edit;
          Form1.ibDataSet150.FieldByName('STATUS').AsString := VENDA_GERENCIAL_CANCELADA;
          Form1.ibDataSet150.FieldByName('NFEXML').Clear;
          Form1.IBDataSet150.FieldByName('TOTAL').Clear;
          Form1.ibDataSet150.Post;
          Result := True;
        except end;
      end;
      }
      IBQALTERACA.Close;
      IBQALTERACA.SQL.Text :=
        'select PEDIDO ' +
        'from ALTERACA ' +
        'where PEDIDO = :PEDIDO ' +
        ' and CAIXA = :CAIXA';
      IBQALTERACA.ParamByName('PEDIDO').AsString := FormataNumeroDoCupom(Form1.iCupom);
      IBQALTERACA.ParamByName('CAIXA').AsString  := Form1.sCaixa;
      IBQALTERACA.Open;
      if IBQALTERACA.FieldByName('PEDIDO').AsString = FormataNumeroDoCupom(Form1.iCupom) then
      begin
        if Form1.ibDataSet150.FieldByName('STATUS').AsString <> VENDA_GERENCIAL_CANCELADA then
        begin
          try
            Form1.ibDataSet150.Edit;
            Form1.ibDataSet150.FieldByName('STATUS').AsString := VENDA_GERENCIAL_CANCELADA;
            Form1.ibDataSet150.FieldByName('NFEXML').Clear;
            Form1.IBDataSet150.FieldByName('TOTAL').Clear;
            Form1.ibDataSet150.Post;
            Result := True;
          except end;
        end;
      end
      else
      begin
        // Não tem nenhum item lançado, considera cancelado para retorno, pode aproveitar o número na próxima abertura
        Result := True;
      end;
      {Sandro Silva 2023-11-01 fim}
    end;
  except end;
  FreeAndNil(IBQALTERACA); // Sandro Silva 2023-11-01
  Screen.Cursor            := crDefault;
end;

function _ecf99_SubTotal(Pp1: Boolean):Real;
begin
  Form1.fTotal := Form1.SubTotalAlteraca(Form1.sModeloECF, Form1.icupom, Form1.sCaixa, Form1.fTotal);
  Result := Form1.fTotal;
end;

// ------------------------------ //
// Abre um novo copom fiscal      //
// ------------------------------ //
function _ecf99_AbreNovoCupom(Pp1: Boolean):Boolean;
begin

  Form1.bCupomAberto := _ecf99_CupomAberto(True); // Sandro Silva 2018-08-01
  Result := True;

end;

// -------------------------------- //
// Retorna o número do Cupom        //
// -------------------------------- //
function _ecf99_NumeroDoCupom(Pp1: Boolean):String;
var
  Mais1Ini : tIniFile;
begin
  //
  try
    //
    Mais1ini  := TIniFile.Create('FRENTE.INI');
    //
    if _ecf99_CupomAberto(True) then
      Pp1 := False;
    //

    if pP1 then
    begin
      //
      while True do
      begin
        Result := FormataNumeroDoCupom(IncrementaGenerator('G_NUMEROCUPOMMEI', 1)); // Sandro Silva 2021-12-02 Result := StrZero(IncrementaGenerator('G_NUMEROCUPOMMEI', 1), 6, 0);
        Form1.ibQuery65.Close;
        Form1.ibQuery65.SQL.Text :=
          'select CAIXA, MODELO, REGISTRO, NUMERONF ' +
          'from NFCE ' +
          'where MODELO = ''99''' +
          ' and NUMERONF = ' + QuotedStr(Result);
        Form1.ibQuery65.Open;
        if Form1.ibQuery65.FieldByName('NUMERONF').AsString = '' then
        begin
          Break;
        end;
      end;

      //
      try
        //
        Form1.ibDataset150.Close;
        Form1.ibDataset150.SelectSql.Clear;
        Form1.ibDataset150.SelectSQL.Text :=
          'select * ' +
          'from NFCE ' +
          'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + // Sandro Silva 2021-12-02 'where NUMERONF=''000000'' ' +
          ' and CAIXA = ' + QuotedStr(Form1.sCaixa) +
          ' and MODELO = ' + QuotedStr('99');
        Form1.ibDataset150.Open;
        //
        Form1.IBDataSet150.Append;
        //SmallMsg('Teste 01 3844'); // Sandro Silva 2016-04-28

        Form1.IBDataSet150.FieldByName('NUMERONF').AsString := Result;
        Form1.IBDataSet150.FieldByName('DATA').AsDateTime   := Date;
        Form1.IBDataSet150.FieldByName('CAIXA').AsString    := Form1.sCaixa;
        Form1.IBDataSet150.FieldByName('MODELO').AsString   := '99';
        Form1.IBDataSet150.FieldByName('STATUS').AsString   := VENDA_GERENCIAL_ABERTA;

        Form1.IBDataSet150.Post;

        {Sandro Silva 2023-08-22 inicio
        Mais1Ini.WriteString('NFCE','CUPOM',Result);
        }
        GravaNumeroCupomFrenteINI(Result, '99'); // Sandro Silva 2023-08-22
        {Sandro Silva 2023-08-22 fim}

        //
      except end;
    end else
    begin
      {Sandro Silva 2023-08-22 inicio
      try
        Result := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM',FormataNumeroDoCupom(1))));
      except
        Result := '000000';
      end;
      }
      try
        Result := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('99', FormataNumeroDoCupom(1))));
      except
        Result := '000000';
      end;
      {Sandro Silva 2023-08-22 fim}
      //
    end;
    //
    Mais1Ini.Free;
    //
  except
    //
    Result := '000001';
    //
  end;
  //
  if StrToInt('0'+LimpaNumero(Result))=0 then
    Result := '000001';
  //

  Result := FormataNumeroDoCupom(StrToInt(Result)); // Sandro Silva 2021-12-01
end;

// ------------------------------ //
// Cancela um item N              //
// ------------------------------ //
function _ecf99_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  //
  Result := True
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// -------------------------------- //
function _ecf99_AbreGaveta(Pp1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Status da gaveta                 //
// -------------------------------- //
function _ecf99_StatusGaveta(Pp1: Boolean):String;
begin
  Result := '255';
end;

// -------------------------------- //
// SAngria                          //
// -------------------------------- //
function _ecf99_Sangria(Pp1: Real):Boolean;
begin
  Result := _ecf99_SangriaSuprimento(Pp1, 'Sangria');
end;

// -------------------------------- //
// Suprimento                       //
// -------------------------------- //
function _ecf99_Suprimento(Pp1: Real):Boolean;
begin
  Result := _ecf99_SangriaSuprimento(Pp1, 'Suprimento');
end;

// -------------------------------- //
// REducao Z                        //
// -------------------------------- //
function _ecf99_NovaAliquota(Pp1: String):Boolean;
begin
  Result := False;
end;

function _ecf99_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
begin
  Result := True;
end;

function _ecf99_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
begin
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// -------------------------------- //
function _ecf99_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
begin
  //
  Result := True;
  Form1.fTotal := Form1.fTotal + TruncaDecimal((TruncaDecimal(Form1.ibDataSet27.FieldByName('TOTAL').AsFloat,Form1.iTrunca)),Form1.iTrunca);
  //
end;

// -------------------------------- //
// Reducao Z                        //
// -------------------------------- //
function _ecf99_ReducaoZ(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// -------------------------------- //
// Leitura X                        //
// -------------------------------- //
function _ecf99_LeituraX(pP1: Boolean):Boolean;
begin
  Result := True;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// ---------------------------------------------- //
function _ecf99_RetornaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// -------------------------------- //
function _ecf99_LigaDesLigaVerao(pP1: Boolean):Boolean;
begin
  Result := False;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// -------------------------------- //
function _ecf99_VersodoFirmware(pP1: Boolean): String;
begin
  Result := '000000';
end;

// -------------------------------- //
// Retorna o número de série        //
// -------------------------------- //
function _ecf99_NmerodeSrie(pP1: Boolean): String;
begin
  // Sandro Silva 2023-07-27 Result := 'MEI00000000000';
  Result := '99' + Copy(AnsiUpperCase(GetComputerNameFunc) + DupeString('0', 20), 1, 18);
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// -------------------------------- //
function _ecf99_CGCIE(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+Form1.ibDataSet13.FieldByname('IE').AsString;
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// --------------------------------- //
function _ecf99_Cancelamentos(pP1: Boolean): String;
begin
  Result := '0';
end;


// -------------------------------- //
// Retorna o valor de descontos     //
// -------------------------------- //
function _ecf99_Descontos(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// -------------------------------- //
function _ecf99_ContadorSeqencial(pP1: Boolean): String;
begin
  Result := '0';
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// -------------------------------- //
function _ecf99_Nmdeoperaesnofiscais(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf99_NmdeCuponscancelados(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf99_NmdeRedues(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf99_Nmdeintervenestcnicas(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf99_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
begin
  Result := '';
end;

function _ecf99_Clichdoproprietrio(pP1: Boolean): String;
begin
  Result := Form1.ibDataSet13.FieldByname('NOME').AsString+Chr(10)+
            Form1.ibDataSet13.FieldByname('CGC').AsString+Chr(10)+
            AllTrim(Form1.ibDataSet2.FieldByname('ENDERE').AsString)+' '+AllTrim(Form1.ibDataSet2.FieldByname('COMPLE').AsString)+Chr(10)+
            Form1.ibDataSet13.FieldByname('CEP').AsString+Form1.ibDataSet13.FieldByname('CIDADE').AsString+' - '+Form1.ibDataSet13.FieldByname('ESTADO').AsString+Chr(10);
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// ------------------------------------ //
function _ecf99_NmdoCaixa(pP1: Boolean): String;
begin
  //
  Result := Form1.GetNumeroCaixa('99', _ecf99_NmerodeSrie(True));
  //
end;

function _ecf99_Nmdaloja(pP1: Boolean): String;
begin
  Result := '999';
end;

function _ecf99_Moeda(pP1: Boolean): String;
begin
  Result := Copy(FormatSettings.CurrencyString,1,1);
end;

function _ecf99_Dataehoradaimpressora(pP1: Boolean): String;
begin
  //Result := FormatDateTime('ddmmyyyyHHnnss', Now); // StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  FormatSettings.ShortDateFormat := 'dd/mm/yy';   {Bug 2001 free}
  Result := StrTran(StrTran(Copy(DateToStr(Date),1,8)+TimeToStr(Time),'/',''),':','');
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';   {Bug 2001 free}
end;

function _ecf99_Datadaultimareduo(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf99_Datadomovimento(pP1: Boolean): String;
begin
  Result := '00/00/0000';
end;

function _ecf99_Tipodaimpressora(pP1: Boolean): String;
begin
  Result := 'MEI';
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf99_RetornaAliquotas(pP1: Boolean): String;
begin
  Result := Replicate('0',72);
end;

function _ecf99_Vincula(pP1: String): Boolean;
begin
  Result := False;
end;


function _ecf99_FlagsDeISS(pP1: Boolean): String;
begin
  Result := chr(0)+chr(0);
end;

function _ecf99_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf99_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf99_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf99_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
begin
  Result := True;
end;

function _ecf99_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
begin
  _ecf99_ImpressaoNaoSujeitoaoICMS(sP1);
  Result := True;
end;

function _ecf99_ImpressaoNaoSujeitoaoICMS(sP1: String; bPDF: Boolean = False; LarguraPapel: Integer = 640): Boolean;
begin
  Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF, LarguraPapel); // Sandro Silva 2018-11-20 Result := Form1.ImpressaoNaoSujeitoaoICMS(sP1, bPDF);
  //Result := True;
end;

function _ecf99_FechaCupom2(sP1: Boolean): Boolean;
begin
  Result := True;
end;

function _ecf99_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf99_GrandeTotal(sP1: Boolean): String;
begin
  Result := Replicate('0',18);
end;

function _ecf99_TotalizadoresDasAliquotas(sP1: Boolean): String;
begin
  Result := Replicate('0',438);
end;

function _ecf99_CupomAberto(sP1: Boolean): boolean;
var
  Mais1Ini : tIniFile;
  sCupom   : String;
begin
  //Result := False;// Sempre começa como falso. Verdadeiro somente se encontrar pendente
  {Sandro Silva 2023-08-22 inicio
  Mais1ini  := TIniFile.Create('FRENTE.INI');
  //
  try
    sCupom := FormataNumeroDoCupom(StrToInt(Mais1Ini.ReadString('NFCE','CUPOM',FormataNumeroDoCupom(1))));
  except
    sCupom := FormataNumeroDoCupom(0); // Sandro Silva 2021-12-02 sCupom := '000000';
  end;
  //
  Mais1Ini.Free;
  }
  try
    sCupom := FormataNumeroDoCupom(StrToInt(LeNumeroCupomFrenteINI('99', FormataNumeroDoCupom(1))));
  except
    sCupom := FormataNumeroDoCupom(0);
  end;
  {Sandro Silva 2023-08-22 fim}

  sCupom := FormataNumeroDoCupom(StrToInt(sCupom)); // Sandro Silva 2021-12-01
  //
  Form1.ibQuery65.Close;
  Form1.ibQuery65.SQL.Clear;
  Form1.ibQuery65.SQL.Text := 'select * from NFCE where NUMERONF='+QuotedStr(sCupom)+' and CAIXA = ' + QuotedStr(Form1.sCaixa) + ' and MODELO = ''99'' ';
  Form1.ibQuery65.Open;
  //
  // SmallMsg(Form1.ibQuery65.FieldByname('NUMERONF').AsString+chr(10)+sCupom);
  //
  if Form1.ibQuery65.FieldByname('NUMERONF').AsString=sCupom then
  begin
    if Form1.ibQuery65.FieldByname('STATUS').AsString = VENDA_GERENCIAL_ABERTA then
    begin
      Form1.icupom := StrToInt(sCupom);
      Result := True;
    end else
    begin
      Result := False;
    end;
  end else
  begin
    Result := False;
  end;
  //
  Form1.ibQuery65.Close;
  //             
end;

function _ecf99_FaltaPagamento(sP1: Boolean): boolean;
begin
  Result := False;
end;

function _ecf99_SangriaSuprimento(dValor: Double; sTipo: String): Boolean;
var
  sCupomFiscalVinculado: String;
begin
  // Sandro Silva 2015-03-30
  try

    sCupomFiscalVinculado := ' '+ Chr(10);
    Form1.ibQuery65.Close;
    Form1.ibQuery65.SQL.Clear;
    Form1.ibQuery65.SQL.Text := 'select NOME, CGC, IE, IM from EMITENTE';
    Form1.ibQuery65.Open;

    sCupomFiscalVinculado := sCupomFiscalVinculado +
      Copy(Form1.ibQuery65.FieldByName('NOME').AsString + Replicate(' ',40-13),1,40-13)+chr(10) +
      'CNPJ: '+ Form1.ibQuery65.FieldByname('CGC').AsString + Chr(10) +
      'IE: '+ Form1.ibQuery65.FieldByname('IE').AsString + Chr(10) +
      'IM: '+ Form1.ibQuery65.FieldByname('IM').AsString + Chr(10) +
      '-----------------------------------------------'+ Chr(10) +
      FormatDateTime('dd/mm/yyyy HH:nn:ss', Now) + ' Caixa: ' + StrZero(Form1.iCaixa, 3, 0) +  Chr(10)+
      'NÃO É DOCUMENTO FISCAL'+chr(10)+
      'COMPROVANTE NÃO FISCAL'+chr(10)+
      '-----------------------------------------------'+chr(10) +
      sTipo + ' R$ ' + Format('%8.2n',[dValor])+chr(10) +
      '-----------------------------------------------'+chr(10);
    // Sandro Silva 2018-03-22  sCupomFiscalVinculado := sCupomFiscalVinculado + 'Small Commerce - NFC-e ' + Chr(10) + Form22.sBuild + Chr(10);
    _ecf99_ImpressaoNaoSujeitoaoICMS(ConverteAcentos(sCupomFiscalVinculado));
    Form1.ibQuery65.Close;

  except

  end;
  Result := True;
end;

procedure _ecf99_RateioAcrescimo(dTotalVenda: Double; dAcrescimoTotal: Double;
  iCupom: Integer; sCaixa: String);
var
  IBQITENS: TIBQuery;
  dAcumulado: Double;
  dDiferenca: Double;
  iItem: Integer;
begin
  SetLength(aAcrescimoItem, 0);
  IBQITENS := CriaIBQuery(FORM1.ibDataSet27.Transaction);
  try
    if dAcrescimoTotal > 0 then
    begin
      IBQITENS.Close;
      IBQITENS.SQL.Text :=
        'select A.TOTAL, coalesce((select A1.TOTAL from ALTERACA A1 where A1.PEDIDO = A.PEDIDO and A1.ITEM = A.ITEM and A1.CAIXA = A.CAIXA and A1.DATA = A.DATA and A1.DESCRICAO = ''Desconto'' ), 0) as DESCONTOITEM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(icupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(icupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
        ' and A.DESCRICAO <> ''Desconto'' ' +
        ' and A.DESCRICAO <> ''Acréscimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
        ' order by ITEM'; // Mesma ordem que foram lançados Sandro Silva 2021-08-13
      IBQITENS.Open;

      dAcumulado := 0.00;
      while IBQITENS.Eof = False do
      begin
        SetLength(aAcrescimoItem, Length(aAcrescimoItem) + 1);
        aAcrescimoItem[Length(aAcrescimoItem) - 1] := StrToFloat(StrZero(((dAcrescimoTotal / dTotalVenda) * (IBQITENS.FieldByName('TOTAL').AsFloat - Abs(IBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Acréscimo

        dAcumulado := dAcumulado + aAcrescimoItem[Length(aAcrescimoItem) - 1];
        IBQITENS.Next;
      end;

      // Formata 2 casas decimais para evitar problema de dízima
      dDiferenca := StrToCurr(FormatFloat('0.00', dAcumulado - dAcrescimoTotal));

      if dDiferenca <> 0 then
      begin
        for iItem := 0 to Length(aAcrescimoItem) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aAcrescimoItem[iItem] - dDiferenca)) >= 0 then
          begin
            aAcrescimoItem[iItem] := StrToCurr(FormatFloat('0.00', aAcrescimoItem[iItem] - dDiferenca));
            Break;
          end
          else
          begin
            dDiferenca := StrToCurr(FormatFloat('0.00', dDiferenca - aAcrescimoItem[iItem]));
            aAcrescimoItem[iItem] := 0.00;
          end;
          if dDiferenca = 0 then
            Break;
        end;

      end; // if dDiferenca <> 0 then
      {Sandro Silva 2019-09-30 fim}
    end; // if dAcrescimoTotal > 0 then
  finally
    FreeAndNil(IBQITENS);
  end;
end;

procedure _ecf99_RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double;
  iCupom: Integer; sCaixa: String);
var
  IBQITENS: TIBQuery;
  dAcumulado: Double;
  dDiferenca: Double;
  iItem: Integer;
begin
  SetLength(aDescontoItem, 0);
  IBQITENS := CriaIBQuery(FORM1.ibDataSet27.Transaction);
  try
    if dDescontoTotal > 0 then
    begin
      IBQITENS.Close;
      IBQITENS.SQL.Text :=
        'select A.TOTAL, coalesce((select A1.TOTAL from ALTERACA A1 where A1.PEDIDO = A.PEDIDO and A1.ITEM = A.ITEM and A1.CAIXA = A.CAIXA and A1.DATA = A.DATA and A1.DESCRICAO = ''Desconto'' ), 0) as DESCONTOITEM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(FormataNumeroDoCupom(iCupom)) + // Sandro Silva 2021-11-29 'where A.PEDIDO = ' + QuotedStr(strZero(iCupom,6,0)) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
        ' and A.DESCRICAO <> ''Desconto'' ' +
        ' and A.DESCRICAO <> ''Acréscimo'') ' +
        ' and coalesce(A.ITEM, '''') <> '''' ' + // Que tenha número do item informado no campo ALTERACA.ITEM
        ' order by ITEM'; // Mesma ordem que foram lançados Sandro Silva 2021-08-13
      IBQITENS.Open;

      dAcumulado := 0.00;// Sandro Silva 2016-04-01
      while IBQITENS.Eof = False do
      begin
        SetLength(aDescontoItem, Length(aDescontoItem) + 1);
        aDescontoItem[Length(aDescontoItem) - 1] := StrToFloat(StrZero(((dDescontoTotal / (dTotalVenda)) * (IBQITENS.FieldByName('TOTAL').AsFloat - Abs(IBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Desconto
        dAcumulado := dAcumulado + aDescontoItem[Length(aDescontoItem) - 1];
        IBQITENS.Next;
      end;

      // Formata 2 casas decimais para evitar problema de dízima
      dDiferenca := StrToCurr(FormatFloat('0.00', dAcumulado - dDescontoTotal));

      if dDiferenca <> 0 then
      begin
        for iItem := 0 to Length(aDescontoItem) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aDescontoItem[iItem] - dDiferenca)) >= 0 then
          begin
            aDescontoItem[iItem] := StrToCurr(FormatFloat('0.00', aDescontoItem[iItem] - dDiferenca));
            Break;
          end
          else
          begin
            dDiferenca := StrToCurr(FormatFloat('0.00', dDiferenca - aDescontoItem[iItem]));
            aDescontoItem[iItem] := 0.00;
          end;
          if dDiferenca = 0 then
            Break;
        end;
      end; // if dDiferenca <> 0 then
      {Sandro Silva 2019-09-30 fim}
    end; // if dAcrescimoTotal > 0 then
  finally
    FreeAndNil(IBQITENS);
  end;
end;

function _ecf99_Visualiza_Venda(sPedido: String; sCaixa: String): Boolean;
var
  sFilePDF: String;
begin
  //
  Result := True;
  //
  try

    Form1.ExibePanelMensagem('Aguarde... Gerando movimentação em PDF'); // Sandro Silva 2018-08-01

    sFilePDF := 'Venda_' + sPedido + '_' + sCaixa;

    sFilePDF := ExtractFilePath(Application.ExeName) + 'VENDAS\' + sFilePDF + '.pdf';

    _ecf99_ImprimirCupomDinamico(nil, Form1.IBDataSet150.Transaction, sPedido, sCaixa, '', '', '', '', toImage, sFilePDF);

    Form1.OcultaPanelMensagem; 

    if FileExists(sFilePDF) then
      ShellExecute(Application.Handle, 'open', PChar(sFilePDF), '', '', SW_MAXIMIZE);

  except
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message + chr(10) + chr(10) + 'Ao visualizar a movimentação'), 'Atenção', mb_Ok + MB_ICONWARNING);
      Result := False;
    end;
  end;

end;

function _ecf99_ImprimirCupomDinamico(Venda: TVenda99; IBTransaction: TIBTransaction;
  sPedido: String; sCaixa: String; sCNPJCliente: String; sNomeCliente: String;
  sEmailCliente: String; sEnderecoCliente: String; Destino: TDestinoExtrato;
  sFileExport: String = ''): Boolean;
const PERCENTUAL_LARGURA_LOGO_X_LARGURA_PAPEL = 0.2721518987341772;
const LARGURA_REFERENCIA_PAPEL_BOBINA = 640; //639
var
  //Tipo: TTipoExtrato;
  //QRCodeBMP: TBitmap;
  IBQTOTAL: TIBQuery;
  IBQALTERACA: TIBQuery;
  IBQCLIFOR: TIBQuery;
  IBQESTOQUE: TIBQuery;
  IBQPAGAMENT: TIBQuery;

  bOk: Boolean;
  iItem: Integer;
  dAcrescimoTotal: Double;
  dDescontoTotalCupom: Double;
  fValorProdutos: Double;
  fDescontoDoItem, fDesconto, fTotalSemDesconto, dRateioAcrescimoItem, dvProd_I11, dTotalAcrescimo, dTotalServicos: Double;
  dTotalDescontoItem: Double; // Total de descontos do item, desconto concedido para o item + o rateio do desconto no subtotal da venda
  sCupomFiscalVinculado: String;
  sCodigoProduto: String;
  sMensagem: String;
  sStatusVenda: String;
  FTamanhoPapel: String;
  iMargemFormas: Integer;

  Logotipo: TBitmap;
  iPrimeiraLinhaPapel: Integer; // Posição onde pode ser impresso a primeira linha em cada página
  iLinha: Integer;
  iMargemRazaoSocial: Integer;
  iAlturaFonte: Integer;
  iLarguraFonte: Integer;
  sTracos: String;
  iNode: Integer;
  sCNPJCPFDestinatario: String;
  sItem: String;
  dDescSobreItem: Double;
  dDescRateioSubTotalItem: Double;
  dAcreRateioSubTotalItem: Double;
  dItemvDeducISSQN: Double;
  dItemvBCISSQN: Double;
  dTotalDescSobreItem: Double;
  dTotalBrutoItens: Double;
  dTotal: Double;
  dDescontoNoTotalCupom: Double;
  dAcrescimoNoTotalCupom: Double;

  Canvas: TCanvas;
  iLarguraFisica: Integer;
  iPixelsPerInch: Integer;
  iPageHeight: Integer;
  sFilePDF: String;
  Pagina: Array of TImage; // Imagem que receberá os textos e outras imagem
  iAlturaPDF: Integer;
  PDF: TPrintPDF;
  iPagina: Integer;
  sRazaoEmitente: String;
  iLinhasFinal: Integer;
  iPrinterPhysicalWidth: Integer; // Sandro Silva 2017-09-12

  sRetornoGeraPDF: String;
  function GetPrinterPhysicalWidth: Integer;
  begin
    Result := GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// Sandro Silva 2018-06-15  Result := GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH);
  end;

  function FormataChaveConsulta(sChaveConsulta: String): String;
  begin
    // Para facilitar a consulta, as 44 posições que compõem a chave de consulta deverão ser
    // divididas em 11 blocos de 4 posições cada, com 2 espaços entre cada bloco.
    // Obs.: Usando 2 espaços entre blocos o texto não cabe em 1 linha
    while sChaveConsulta <> '' do
    begin
      Result := Result + Copy(sChaveConsulta, 1, 4) + ' ';
      sChaveConsulta := StringReplace(sChaveConsulta, Copy(sChaveConsulta, 1, 4), '', []);
    end;

  end;

  function CriaPagina: TImage;
  var
    iPages: Integer;
    procedure NumerarPagina(Canvas: TCanvas; iNumero: Integer);
    begin
      Canvas.Font.Size := Canvas.Font.Size - 2;
      SetTextAlign(Canvas.Handle, TA_RIGHT);
      Canvas.TextOut(iLarguraPapel, iAlturaPDF - iAlturaFonte, 'Página ' + IntToStr(iNumero));
      SetTextAlign(Canvas.Handle, TA_LEFT);
      Canvas.Font.Size := Canvas.Font.Size + 2;
    end;
  begin
    try
      SetLength(Pagina, Length(Pagina) + 1);
      iPages := High(Pagina);
      Pagina[iPages]              := TImage.Create(Application);
      Pagina[iPages].Parent       := Application.MainForm;//  Form1;
      Pagina[iPages].Proportional := True;
      Pagina[iPages].Visible      := False;
      Pagina[iPages].Height       := iAlturaPDF;
      if iPages = 0 then
        Pagina[iPages].Top := 0
      else
        Pagina[iPages].Top := Pagina[iPages -1 ].BoundsRect.Bottom + 10;
      Pagina[iPages].Left                       := 0;
      Pagina[iPages].Width                      := iLarguraPapel;// Sandro Silva 2017-04-17  iLarguraFisica;
      Pagina[iPages].Canvas.Brush.Color         := clWhite;
      Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 * 2;// 14;
      Pagina[iPages].Canvas.Font.Style          := [fsBold];
      Pagina[iPages].Picture.Bitmap.PixelFormat := pf32bit; // 2015-05-15 pf24bit; // pf32bit; //2014-04-30
      Pagina[iPages].Picture.Bitmap.Height      := Pagina[iPages].Height;
      Pagina[iPages].Picture.Bitmap.Width       := Pagina[iPages].Width;
      Canvas := Pagina[iPages].Canvas;
      Canvas.Font.PixelsPerInch := 215; // Sandro Silva 2017-04-13  203;
      Canvas.Font.Size          := FONT_SIZE_DEFAULT; // Sandro Silva 2017-04-17 Acertar a fonte depois de Canvas.Font.PixelsPerInch, que deixa a fonte menor
      iMargemEsq          := 10;
      iLinha              := 50;
      iAlturaFonte        := Pagina[iPages].Canvas.TextHeight('Ég');// - 3; // Sandro Silva 2017-04-17 ; // Calcula a altura ocupada pelo texto, inclusive acentuados ou caracteres como "jgyqçp";
      iLarguraFonte       := Pagina[iPages].Canvas.TextWidth('W');
      iPrimeiraLinhaPapel := iLinha + iAlturaFonte;
      Pagina[iPages].Canvas.Font.Style          := [];
      Pagina[iPages].Canvas.Font.Name           := FONT_NAME_DEFAULT;
      Pagina[iPages].Canvas.Font.Size           := FONT_SIZE_DEFAULT; //14;

      if iPages > 0 then
        iLinha := iPrimeiraLinhaPapel;

      iPageHeight := Pagina[iPages].Height;

      // Numerando as páginas
      NumerarPagina(Pagina[iPages].Canvas, iPages + 1);
      Result := Pagina[iPages];
    except
      Result := nil
    end;
  end;

  function CanvasLinha(var iPosicao: Integer; mm: Double; iTopo: Integer): Integer;
  {Sandro Silva 2013-01-10 inicio
  Avança a posição verticar do Canvas para impressão}
  begin

    iPosicao := iPosicao + Round(mm);

    if Destino = toImage then
    begin
      if iPosicao + Trunc(mm / 3) > (iAlturaPDF - (iAlturaFonte * 2)) then
        CriaPagina;
    end
    else
    begin
      if iPosicao >= (iPageHeight - (iAlturaFonte * 2)) then // Controla avanço de páginas // Sandro Silva 2018-03-20  if iPosicao >= (Printer.PageHeight - (iAlturaFonte * 2)) then // Controla avanço de páginas
      begin
        Printer.NewPage;
        iPosicao := iTopo;
      end;
    end;
    Result := iPosicao;
  end;

  procedure PrinterTexto(iLinha: Integer; iColuna: Integer;
    Texto: String; Alinhamento: TAlinhamento = poLeft; FontName: String = FONT_NAME_DEFAULT);
  begin
    Canvas.Font.Name := FontName; // 2016-01-14

    case Alinhamento of
      poCenter:
        begin
          if Destino = toImage then
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2) + iMargemEsq // 2014-05-09
          else
            iColuna := Round((iLarguraPapel - iMargemEsq - Canvas.TextWidth(Texto)) / 2);
        end;
      poRight:
        begin
          iColuna := iLarguraPapel;
          SetTextAlign(Canvas.Handle, TA_RIGHT);
        end;
    end;

    Canvas.TextOut(iColuna, iLinha, Texto);

    SetTextAlign(Canvas.Handle, TA_LEFT);
  end;

  procedure PrinterTextoMemo(var iLinha: Integer; iColuna: Integer;
    const iLargura: Integer; Texto: String; Alinhamento: TAlinhamento = poLeft);
  var
    iMemoLine: Integer;
    sTextoLinha: String;
    reTexto: TMemo;
    slTexto: TStringList;
    sTextoOrig: String;
    sTexto: String;

    function sBreakApart(BaseString, BreakString: String; StringList: TStringList): TStringList;
    var
      EndOfCurrentString: Byte;
    begin
      repeat
        EndOfCurrentString := Pos(BreakString, BaseString);
        if EndOfCurrentString = 0 then
          StringList.Add(BaseString)
        else
          StringList.Add(Copy(BaseString, 1, EndOfCurrentString - 1));
        BaseString := Copy(BaseString, EndOfCurrentString + Length(BreakString), Length(BaseString) - EndOfCurrentString);

      until EndOfCurrentString = 0;
      Result := StringList;
    end;

    procedure CanvasTextOut;
    begin

      if Destino = toImage then
      begin
        if (iLinha + Canvas.TextHeight(sTextoLinha)) > iAlturaPDF then
          CriaPagina;
      end;

      case Alinhamento of
        poCenter:
          begin
            iColuna := Round((iLargura - Canvas.TextWidth(sTextoLinha)) / 2);
          end;
        poRight:
          begin
            iColuna := iLargura;
            SetTextAlign(Canvas.Handle, TA_RIGHT);
          end;
      end;

      Canvas.TextOut(iColuna, iLinha, Trim(sTextoLinha));

      SetTextAlign(Canvas.Handle, TA_LEFT);

    end;
  begin
    reTexto := TMemo.Create(nil);
    reTexto.Left       := -1000;
    reTexto.Top        := -1000;
    reTexto.Visible    := False;
    reTexto.Parent     := Application.MainForm; // Sandro Silva 2017-04-27  Screen.ActiveForm;
    reTexto.ParentFont := False;
    reTexto.Font       := Canvas.Font;
    reTexto.Width      := iLargura;
    reTexto.Repaint;

    slTexto    := TStringList.create;
    sTextoOrig := Texto;
    sTexto     := sTextoOrig;
    reTexto.Lines.Assign(sBreakApart(sTextoOrig, ' ', slTexto));

    sTextoOrig := StringReplace(sTextoOrig, #$D#$A, '', [rfReplaceAll]);
    while AnsiContainsText(sTextoOrig, '  ') do
      sTextoOrig := StringReplace(sTextoOrig, '  ', ' ', [rfReplaceAll]);
    iMemoLine := 0;
    while (sTextoOrig <> '') do
    begin
      sTexto := reTexto.Lines.Strings[iMemoLine] + ' ';
      if (Canvas.TextWidth(sTextoLinha + sTexto) <= iLargura) and (iMemoLine <= reTexto.Lines.Count) then
      begin
        sTextoLinha := StringReplace(sTextoLinha + sTexto, '  ', ' ', [rfReplaceAll]);
      end
      else
      begin
        sTextoOrig := StringReplace(StringReplace(sTextoOrig, StringReplace(sTextoLinha, '  ', ' ', [rfReplaceAll]), '', [rfIgnoreCase]), #$D#$A, '', [rfIgnoreCase]);

        CanvasTextOut;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

        sTextoLinha := sTexto + ' ';
      end;

      Inc(iMemoLine);

      if iMemoLine >= reTexto.Lines.Count then
        Break;

    end;

    if (Trim(sTextoOrig) <> '') then
    begin

      sTextoLinha := sTextoOrig;

      CanvasTextOut;

    end;

  end;

  procedure PrinterTraco(var iLinha: Integer; iColuna: Integer; iComprimento: Integer; Color: TColor = clBlack);
  begin
    Inc(iLinha, 10); // 2014-10-22
    Canvas.Pen.Color := Color;
    Canvas.MoveTo(iColuna, iLinha);
    Canvas.LineTo(iComprimento, iLinha);
  end;

  procedure Cabecalho;
  var
    iLogoheight: Integer;
  begin
    iLogoheight := 0;

    if FileExists('logofrente.bmp') then
    begin
      try
        iMargemRazaoSocial := iMargemEsq;
      except

      end;
    end;

    if Logotipo <> nil then
      FreeAndNil(Logotipo);

    //CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    PrinterTexto(iLinha, iMargemEsq, 'NAO E DOCUMENTO FISCAL', poLeft);//PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, 'NAO E DOCUMENTO FISCAL', poCenter);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
    CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

    sRazaoEmitente := Form1.ibDataSet13.FieldByName('NOME').AsString;
    //PrinterTexto(iLinha, iMargemEsq, sRazaoEmitente);
    PrinterTextoMemo(iLinha, iMargemEsq, iLarguraPapel - 5, sRazaoEmitente);

    //CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    if (iPrimeiraLinhaPapel + iLogoheight) > Canvas.PenPos.Y then
      CanvasLinha(iLinha, (((iPrimeiraLinhaPapel + iLogoheight) - Canvas.PenPos.Y) + iAlturaFonte), iPrimeiraLinhaPapel)
    else
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    PrinterTexto(iLinha, iMargemEsq, 'CNPJ ' + Form1.ibDataSet13.FieldByName('CGC').AsString, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    PrinterTexto(iLinha, iMargemEsq, 'Telefone: ' + Form1.ibDataSet13.FieldByName('TELEFO').AsString, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, Form1.ibDataSet13.FieldByName('ENDERECO').AsString, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    
    if Trim(Form1.ibDataSet13.FieldByName('COMPLE').AsString) <> '' then
    begin
      PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, Form1.ibDataSet13.FieldByName('COMPLE').AsString, poLeft);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    end;

    PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, Form1.ibDataSet13.FieldByName('MUNICIPIO').AsString + '-' + Form1.ibDataSet13.FieldByName('ESTADO').AsString, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
    CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

    PrinterTexto(iLinha, iMargemEsq, 'Data: ' + FormatDateTime('dd/mm/yyyy', IBQALTERACA.FieldByName('DATA').AsDateTime) + ' ' + Copy(IBQALTERACA.FieldByName('HORA').AsString, 1, 5), poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

    {Sandro Silva 2023-12-28 inicio
    PrinterTexto(iLinha, iMargemEsq, 'Status: ' + sStatusVenda, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    }
    PrinterTextoMemo(iLinha, iMargemRazaoSocial, iLarguraPapel - iMargemRazaoSocial - 5, 'Status: ' + sStatusVenda, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    {Sandro Silva 2023-12-28 fim}
    PrinterTexto(iLinha, iMargemEsq, 'Controle: ' + IBQALTERACA.FieldByName('PEDIDO').AsString, poLeft);
    PrinterTexto(iLinha, Canvas.PenPos.X + 120, ' Caixa: ' + IBQALTERACA.FieldByName('CAIXA').AsString, poLeft);
    CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
    Canvas.Font.Style := [];
  end;
begin
  //FCursor       := Screen.Cursor;
  //Screen.Cursor := crHourGlass;
  FTamanhoPapel := Form1.sTamanhoPapel;

  {Sandro Silva 2020-10-13 inicio}
  if Trim(FTamanhoPapel) = '' then
    FTamanhoPapel := '80';
  {Sandro Silva 2020-10-13 fim}

  iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA; // Inicia com valor padrão

  try
    try

      if Venda = nil then
      begin
        Venda := TVenda99.Create; // Venda := TVenda99.Create(nil);
        Venda.IBTransaction := IBTransaction;
        IBQPAGAMENT := CriaIBQuery(Venda.IBTransaction);

        Venda.Pedido := sPedido;
        Venda.Caixa  := sCaixa;
        Venda.Mensagem := Form1.sMensagemPromocional;

        IBQPAGAMENT.Close;
        IBQPAGAMENT.SQL.Text :=
          'select VENDEDOR, FORMA, VALOR ' +
          'from PAGAMENT ' +
          'where PEDIDO = :PEDIDO and CAIXA = :CAIXA ' +
          ' and FORMA not starting ''00'' ';
        IBQPAGAMENT.ParamByName('PEDIDO').AsString := sPedido;
        IBQPAGAMENT.ParamByName('CAIXA').AsString  := sCaixa;
        IBQPAGAMENT.Open;

        while IBQPAGAMENT.Eof = False do
        begin
          if (AnsiContainsText(Venda.Mensagem, 'Vendedor') = False) and (IBQPAGAMENT.FieldByName('VENDEDOR').AsString <> '') then
           Venda.Mensagem := Venda.Mensagem + Chr(10) + 'Vendedor: ' + IBQPAGAMENT.FieldByName('VENDEDOR').AsString;

          if Copy(IBQPAGAMENT.FieldByName('FORMA').AsString, 1, 2) = '13' then
            Venda.Troco := IBQPAGAMENT.FieldByName('VALOR').AsFloat
          else
            Venda.AddForma(Trim(Copy(IBQPAGAMENT.FieldByName('FORMA').AsString, 3, IBQPAGAMENT.FieldByName('FORMA').Size)), IBQPAGAMENT.FieldByName('VALOR').AsFloat);
          IBQPAGAMENT.Next;
        end;

      end;

      IBQTOTAL    := CriaIBQuery(Venda.IBTransaction);
      IBQALTERACA := CriaIBQuery(Venda.IBTransaction);
      IBQCLIFOR   := CriaIBQuery(Venda.IBTransaction);
      IBQESTOQUE  := CriaIBQuery(Venda.IBTransaction);

      //bOk     := False;

      IBQTOTAL.Close;
      IBQTOTAL.SQL.Text :=
        'select STATUS ' +
        'from NFCE ' +
        'where NUMERONF = :NUMERO and CAIXA = :CAIXA and MODELO = :MODELO';
      IBQTOTAL.ParamByName('NUMERO').AsString := sPedido;
      IBQTOTAL.ParamByName('CAIXA').AsString  := sCaixa;
      IBQTOTAL.ParamByName('MODELO').AsString := '99';
      IBQTOTAL.Open;

      sStatusVenda := IBQTOTAL.FieldByname('STATUS').AsString;


      //
      // TOTAL Sem o Desconto
      //
      IBQTOTAL.Close;
      IBQTOTAL.Sql.Clear;
      IBQTOTAL.SQL.Text :=
        'select sum(A.TOTAL) as TOTALCUPOM ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sPedido) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and (A.DESCRICAO <> ''<CANCELADO>'') '  +
        ' and (A.DESCRICAO <> ''Desconto'') ' +
        ' and (A.DESCRICAO <> ''Acréscimo'') ';
      IBQTOTAL.Open;

      fTotalSemDesconto := IBQTOTAL.FieldByname('TOTALCUPOM').AsFloat;

      IBQTOTAL.Close;
      IBQTOTAL.SQL.Text :=
        'select A.* ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sPedido) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DESCRICAO = ''Acréscimo'' ' +
        ' and coalesce(A.ITEM, '''') = '''' ';
      IBQTOTAL.Open;

      dAcrescimoTotal     := 0.00;
      while IBQTOTAL.Eof = False do
      begin
        dAcrescimoTotal := dAcrescimoTotal + IBQTOTAL.FieldByName('TOTAL').AsFloat;

        IBQTOTAL.Next;
      end;

      _ecf99_RateioAcrescimo(fTotalSemDesconto, dAcrescimoTotal, StrToInt(sPedido), sCaixa);

      // Seleciona os desconto lançados para a venda (não considera descontos atribuídos aos itens)
      IBQTOTAL.Close;
      IBQTOTAL.SQL.Clear;
      IBQTOTAL.SQL.Text :=
        'select A.* ' +
        'from ALTERACA A ' +
        'where A.PEDIDO = ' + QuotedStr(sPedido) +
        ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
        ' and A.CAIXA = ' + QuotedStr(sCaixa) +
        ' and A.DESCRICAO = ''Desconto'' ' +
        ' and coalesce(A.ITEM, '''') = '''' '; // Desconto no subtotal
        //'  and CAIXA||PEDIDO||ITEM NOT in (select P.CAIXA||P.PEDIDO||P.ITEM from PENDENCIA P where P.PEDIDO = ALTERACA.PEDIDO and P.CAIXA = ALTERACA.CAIXA and (P.TIPO = ''KOLNAC'' or P.TIPO = ''CANLOK'') )'; // Sandro Silva 2019-04-01
      IBQTOTAL.Open;

      dDescontoTotalCupom := 0.00; // 2015-12-10
      while IBQTOTAL.Eof = False do
      begin
        dDescontoTotalCupom := dDescontoTotalCupom + IBQTOTAL.FieldByName('TOTAL').AsFloat;

        IBQTOTAL.Next;
      end;
      dDescontoTotalCupom := Abs(dDescontoTotalCupom);

      _ecf99_RateioDesconto(fTotalSemDesconto, dDescontoTotalCupom, StrToInt(sPedido), sCaixa);

      //
      IBQALTERACA.Close;
      IBQALTERACA.SQL.Clear;
      IBQALTERACA.SQL.Text :=
        'select * ' +
        'from ALTERACA ' +
        'where CAIXA = ' + QuotedStr(sCaixa)+
        ' and PEDIDO = ' + QuotedStr(sPedido)+' ' +
        ' order by ITEM'; // Mesma ordem que foram lançados Sandro Silva 2021-08-13
      IBQALTERACA.Open;
      //
      //
      // Identificação do consumidor
      //
      //
      IBQCLIFOR.Close;
      IBQCLIFOR.SQL.Text := 'select * from CLIFOR where NOME='+QuotedStr(IBQALTERACA.FieldByName('CLIFOR').AsString)+' and trim(coalesce(NOME,'''')) <> '''' ';
      IBQCLIFOR.Open;
      //
      if LimpaNumero(IBQALTERACA.FieldByName('CNPJ').AsString) <> '' then
        sCNPJCliente     := FormataCpfCgc(LimpaNumero(IBQALTERACA.FieldByName('CNPJ').AsString)); // CNPJ do Destinatário
      if Trim(ConverteAcentos2(IBQALTERACA.FieldByName('CLIFOR').AsString)) <> '' then
        sNomeCliente     := Trim(ConverteAcentos2(IBQALTERACA.FieldByName('CLIFOR').AsString));

      if (IBQALTERACA.FieldByName('CLIFOR').AsString = IBQCLIFOR.FieldByName('NOME').AsString) and (Trim(IBQALTERACA.FieldByName('CLIFOR').AsString) <> '') then
      begin
        if (AllTrim(LimpaNumero(IBQCLIFOR.FieldByName('CGC').AsString)) <> '') then
        begin
          sCNPJCliente     := IBQCLIFOR.FieldByName('CGC').AsString; // CNPJ do Destinatário
          sNomeCliente     := Trim(ConverteAcentos2(IBQCLIFOR.FieldByName('NOME').AsString));
          sEmailCliente    := IBQCLIFOR.FieldByname('EMAIL').AsString;
          sEnderecoCliente := IBQCLIFOR.FieldByname('ENDERE').AsString;
          sEnderecoCliente := sEnderecoCliente + ' - ' + IBQCLIFOR.FieldByname('COMPLE').AsString;
          sEnderecoCliente := sEnderecoCliente + ' - ' + IBQCLIFOR.FieldByname('CIDADE').AsString + '-' + IBQCLIFOR.FieldByname('ESTADO').AsString  + ' ' + IBQCLIFOR.FieldByname('CEP').AsString;
        end;
      end;

      Canvas := TCanvas.Create;

      Printer.Title := 'Venda ' + IBQALTERACA.FieldByName('PEDIDO').AsString + ' Caixa: ' + IBQALTERACA.FieldByName('CAIXA').AsString;
      Printer.BeginDoc;

      Canvas := Printer.Canvas; // Sandro Silva 2017-09-12

      if Destino = toImage then
      begin
        iAlturaPDF     := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  3508; // Sandro Silva 2017-04-13  2350;
        iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;
        iPixelsPerInch := 600; // Sandro Silva 2017-04-11  103;
      end
      else
      begin
        // Sandro Silva 2017-09-12  iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA; // 2014-05-09 GetDeviceCaps(Printer.Canvas.Handle, PHYSICALWIDTH);
        iLarguraFisica := GetPrinterPhysicalWidth;

        if FTamanhoPapel <> '' then
        begin
          if FTamanhoPapel = '58' then
            iLarguraFisica := 384;
          if FTamanhoPapel = '76' then
            iLarguraFisica := 512;
          if FTamanhoPapel = '80' then
            iLarguraFisica := 576; //588;
          if FTamanhoPapel = 'A4' then
            iLarguraFisica := 4961;
        end;

        if (FTamanhoPapel <> 'A4') and (iLarguraFisica > LARGURA_REFERENCIA_PAPEL_BOBINA) then// Sandro Silva 2018-06-15  if GetPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
        begin
          iLarguraFisica := LARGURA_REFERENCIA_PAPEL_BOBINA;// 1678;
        end;

        iPixelsPerInch := 600; // Sandro Silva 2016-12-07
        iPageHeight  := Printer.PageHeight;  //nops xxxx 2448
      end;

      if Destino = toPrinter then
      begin
        Printer.Canvas.Font.Name          := FONT_NAME_DEFAULT;
        Printer.Canvas.Font.Size          := FONT_SIZE_DEFAULT;
        Printer.Canvas.Font.Style         := [fsBold];
        Printer.Canvas.Font.PixelsPerInch := iPixelsPerInch; // 2014-05-09
        Canvas.Font.PixelsPerInch         := iPixelsPerInch;// GetDeviceCaps(Printer.Canvas.Handle, LOGPIXELSX);
        iMargemEsq                        := 2;// Sandro Silva 2018-03-20  5;// 2015-05-07 0;
        iLinha                            := 50;
        iAlturaFonte                      := Printer.Canvas.TextHeight('Ég') - 1;// Sandro Silva 2017-04-18  Printer.Canvas.TextHeight('Ég') - 3; // Calcula a altura ocupada pelo texto;
        iLarguraFonte                     := Printer.Canvas.TextWidth('W');

        iPrinterPhysicalWidth := iLarguraFisica;// Sandro Silva 2018-06-15  GetPrinterPhysicalWidth; // Sandro Silva 2017-09-12

        if iPrinterPhysicalWidth > LARGURA_REFERENCIA_PAPEL_BOBINA then
          iLarguraPapel := 1678
        else
          if iPrinterPhysicalWidth > 464 then
          begin
            if iPrinterPhysicalWidth < 576 then // Sandro Silva 2018-06-15
              iLarguraPapel := 512
            else
              iLarguraPapel := iPrinterPhysicalWidth //512 - Sweda SI-300  // Sandro Silva 2018-06-13  576
          end
          else
            iLarguraPapel := iPrinterPhysicalWidth;// Sandro Silva 2018-06-14  GetDeviceCaps(Printer.Canvas.Handle, HORZRES);// Área de impressão descontando margens Sandro Silva 2016-12-07   Printer.PageWidth;

        Printer.Canvas.Font.Style := [];
        Printer.Canvas.Font.Name  := FONT_NAME_DEFAULT;
        Printer.Canvas.Font.Size  := FONT_SIZE_DEFAULT;

        iPrimeiraLinhaPapel       := 50 + iAlturaFonte;// Sandro Silva 2017-04-18  40 + iAlturaFonte;

        {Sandro Silva 2020-10-09 inicio}
        if (FTamanhoPapel = '58') or (FTamanhoPapel = '76') or (FTamanhoPapel = '80') then
        begin
          iPrimeiraLinhaPapel := iAlturaFonte;
          iLinha              := iPrimeiraLinhaPapel;
        end;
        {Sandro Silva 2020-10-10 fim}

      end
      else
      begin
        iLarguraPapel             := 588; // Sandro Silva 2017-04-18  576;// LARGURA_REFERENCIA_PAPEL_BOBINA; // Sandro Silva 2017-04-10
        CriaPagina; // Cria nova página no array
      end;

      sTracos := DupeString('_', Trunc(iLarguraPapel / Canvas.TextWidth('_')));

      Cabecalho;

      sCNPJCPFDestinatario := sCNPJCliente;

      if (sCNPJCPFDestinatario <> '') or (sNomeCliente <> '') then
      begin
        {Sandro Silva 2023-08-16 inicio
        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
        }

        if (sCNPJCPFDestinatario <> '') then // Ficha 4251 Sandro Silva 2018-10-01
        begin
          {Sandro Silva 2023-08-16 inicio}
          PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
          CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
          {Sandro Silva 2023-08-16 fim}

          sCNPJCPFDestinatario := FormataCpfCgc(sCNPJCPFDestinatario);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq) - 5, 'Cliente: ' + sCNPJCPFDestinatario);
        end;

        if (sNomeCliente <> '') then
        begin
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq) - 5, 'Nome: ' + sNomeCliente);
        end;

        if (sEnderecoCliente <> '') then
        begin
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq) - 5, 'Endereco: ' + sEnderecoCliente);
        end;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
      end;

      if (sCNPJCPFDestinatario = '') and (sNomeCliente = '') then // Sandro Silva 2023-08- if (sCNPJCPFDestinatario = '') then
      begin
        PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
        CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);
      end;

      if Destino = toImage then
      begin
        Canvas.Font.Size := FONT_SIZE_DEFAULT - 1; // 2016-01-19
        PrinterTexto(iLinha, iMargemEsq, 'CODIGO', poLeft, 'TAHOMA');
        PrinterTexto(iLinha, iMargemEsq + 100, 'DESCRICAO', poLeft, 'TAHOMA');
        PrinterTexto(iLinha, iMargemEsq + 240, 'UN', poLeft, 'TAHOMA');
        PrinterTexto(iLinha, iMargemEsq + 300, 'QTD', poLeft, 'TAHOMA');
        PrinterTexto(iLinha, iMargemEsq + 390, 'UNITARIO', poLeft, 'TAHOMA');
        PrinterTexto(iLinha, iMargemEsq, 'TOTAL', poRight, 'TAHOMA');

      end
      else
      begin
        Canvas.Font.Name := FONT_NAME_DEFAULT; //'Verdana';
        if FTamanhoPapel = 'A4' then
        begin
          PrinterTexto(iLinha, iMargemEsq, 'CODIGO', poLeft);
          PrinterTexto(iLinha, Canvas.PenPos.X + 20, 'DESCRICAO', poLeft);
          PrinterTexto(iLinha, Canvas.PenPos.X + 150, 'UN', poLeft);
          PrinterTexto(iLinha, Canvas.PenPos.X + 90, 'QTD', poLeft);
          PrinterTexto(iLinha, Canvas.PenPos.X + 70, 'UNITARIO', poLeft);
          PrinterTexto(iLinha, iMargemEsq , 'TOTAL', poRight);
        end
        else
        begin
          if FTamanhoPapel = '58' then
          begin
            PrinterTexto(iLinha, iMargemEsq, 'CODIGO', poLeft);
            PrinterTexto(iLinha, iMargemEsq + 100, 'DESCRICAO', poLeft);
            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
            PrinterTexto(iLinha, iMargemEsq, 'UN', poLeft);
            PrinterTexto(iLinha, iMargemEsq + 100, 'QTD', poLeft);
            PrinterTexto(iLinha, iMargemEsq + 190, 'UNITARIO', poLeft);
            PrinterTexto(iLinha, iMargemEsq , 'TOTAL', poRight);
          end
          else
          begin
            if FTamanhoPapel = '76' then
            begin
              PrinterTexto(iLinha, iMargemEsq, 'CODIGO', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 100, 'DESCRICAO', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 235, 'UN', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 275, 'QTD', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 340, 'UNITARIO', poLeft);
              PrinterTexto(iLinha, iMargemEsq , 'TOTAL', poRight);
            end
            else
            begin
              PrinterTexto(iLinha, iMargemEsq, 'CODIGO', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 100, 'DESCRICAO', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 240, 'UN', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 300, 'QTD', poLeft);
              PrinterTexto(iLinha, iMargemEsq + 390, 'UNITARIO', poLeft);
              PrinterTexto(iLinha, iMargemEsq , 'TOTAL', poRight);
            end;
          end;
        end;
      end;
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      Canvas.Font.Size := FONT_SIZE_DEFAULT;
      Canvas.Font.Name := FONT_NAME_DEFAULT;

      PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
      CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

      dTotalDescSobreItem := 0.00;
      dTotalBrutoItens    := 0.00;
      // Sandro Silva 2021-04-28 dTotalAcrescimo     := 0.00;
      dTotalServicos      := 0.00;
      fValorProdutos      := 0.00;
      // Sandro Silva 2021-04-28 fDesconto           := 0.00;
      dTotalDescontoItem := 0; // Sandro Silva 2021-04-28

      IBQESTOQUE.Close;
      IBQESTOQUE.SQL.Text :=
        'select * from ESTOQUE where CODIGO = :CODIGO';
      IBQESTOQUE.Prepare;

      iItem := 0;
      while not IBQALTERACA.Eof do
      begin
        //
        IBQESTOQUE.Close;
        IBQESTOQUE.ParamByName('CODIGO').AsString := IBQALTERACA.FieldByName('CODIGO').AsString;
        IBQESTOQUE.Open;
        //
        if (IBQALTERACA.FieldByName('TIPO').AsString = 'BALCAO') or (IBQALTERACA.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados Sandro Silva 2018-12-19
        begin
          if (Alltrim(IBQESTOQUE.FieldByName('CODIGO').AsString) = Alltrim(IBQALTERACA.FieldByName('CODIGO').AsString)) and (Alltrim(IBQESTOQUE.FieldByName('CODIGO').AsString) <> '') then // Ficha 4352. Descrição pode ser alterada durante a venda
          begin
            //
            iItem := iItem + 1;
            //
            // Dados do Produto Vendido

            sItem := IntToStr(iItem);
            if Length(Alltrim(IBQESTOQUE.FieldByname('REFERENCIA').AsString)) < 6 then
              sItem := sItem  + ' ' + IBQESTOQUE.FieldByname('CODIGO').AsString //Código do PRoduto ou Serviço
            else
              sItem := sItem  + ' ' + IBQESTOQUE.FieldByname('REFERENCIA').AsString; // Código de BARRAS

            sItem := sItem + ' ' + IBQALTERACA.FieldByName('DESCRICAO').AsString;

            if (iLinha + (iAlturaFonte * 3) >= iPageHeight) then
            begin
              CanvasLinha(iLinha, (iAlturaFonte * 3), iPrimeiraLinhaPapel);
            end;

            PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq) - 5, sItem);//  PrinterTexto(iLinha, iMargemEsq, sItem);

            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

            sItem := '';

            sItem := sItem + ' ' +
              Copy(ConverteAcentos2(IBQESTOQUE.FieldByname('MEDIDA').AsString) + Replicate(' ', 11), 1, 11) +
              Format('%10.2n',[IBQALTERACA.FieldByName('QUANTIDADE').AsFloat]) + 'X' +
              Format('%10.2n',[IBQALTERACA.FieldByName('UNITARIO').AsFloat]) + ' ' +
              Format('%10.2n',[IBQALTERACA.FieldByName('TOTAL').AsFloat]);

            PrinterTexto(iLinha, iMargemEsq, sItem, poRight);

            if (AnsiContainsText(IBQALTERACA.FieldByName('TIPODAV').AsString, 'MESA') = False) and (AnsiContainsText(IBQALTERACA.FieldByName('TIPODAV').AsString, 'DEKOL') = False) then  // Ficha 4496 Não passar para xml dados da Observação o item quando estiver usando mesas. Desnecessário e usa mais papel para impressão
            begin
              if Trim(IBQALTERACA.FieldByName('OBS').AsString) <> '' then
              begin
                CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
                PrinterTexto(iLinha, iMargemEsq, IBQALTERACA.FieldByName('OBS').AsString, poRight);
              end;
            end;
            //
            dvProd_I11 := StrToFloatDef(FormatFloat('##0.00', IBQALTERACA.FieldByname('TOTAL').AsFloat), 0); // Formata o total com 2 casas para usar no restante da rotina
            //
            // Desconto no item
            //
            IBQTOTAL.Close;
            IBQTOTAL.Sql.Clear;
            IBQTOTAL.SQL.Text := 'select sum(cast(TOTAL as numeric(18,2))) from ALTERACA where PEDIDO = ' + QuotedStr(sPedido) + ' and CAIXA = ' + quotedStr(sCaixa) + ' and ITEM = ' + QuotedStr(IBQALTERACA.FieldByName('ITEM').AsString) + ' and DESCRICAO = ''Desconto'' ';
            IBQTOTAL.Open;

            fDescontoDoItem := 0.00;
            if (IBQTOTAL.FieldByname('SUM').AsFloat * -1) > 0.00 then
              fDescontoDoItem := (IBQTOTAL.FieldByname('SUM').AsFloat * -1);

            dTotalDescontoItem := dTotalDescontoItem + fDescontoDoItem;
            if (fDescontoDoItem > 0) then
            begin
              // Desconto no ítem
              CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
              PrinterTexto(iLinha, iMargemEsq, Copy('Desconto (-)' + Replicate(' ', 30), 1, 30) + Format('%10.2n', [fDescontoDoItem]), poRight);
            end;

            if (IBQESTOQUE.FieldByName('TIPO_ITEM').AsString = '09') then // Serviço
            begin
              dTotalServicos   := dTotalServicos + dvProd_I11; //vBC_U02;
            end
            else
            begin // Produtos/Mercadorias
              fValorProdutos := fValorProdutos + dvProd_I11;
            end; // if Servico then

            CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);

          end;// if (Alltrim(IBQESTOQUE.FieldByName('CODIGO').AsString) = Alltrim(IBQALTERACA.FieldByName('CODIGO').AsString)) and (Alltrim(IBQESTOQUE.FieldByName('CODIGO').AsString) <> '') then
        end; // if (IBQALTERACA.FieldByName('TIPO').AsString = 'BALCAO') or (IBQALTERACA.FieldByName('TIPO').AsString = 'LOKED') then // Apenas os itens não cancelados

        IBQALTERACA.Next;

      end; // while not IBQALTERACA.Eof do

      {Sandro Silva 2020-10-15 inicio}
      fDesconto       := dDescontoTotalCupom;
      dTotalAcrescimo := dAcrescimoTotal;
      {Sandro Silva 2020-10-15 fim}

      //////////////////////////////////////////////////////////
      //
      // Fim Gerando Itens
      //
      //////////////////////////////////////////////////////////

      PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
      CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

      iMargemFormas := ((iLarguraPapel - iMargemEsq) div 3);
      //
      PrinterTexto(iLinha, iMargemFormas, 'Itens', poLeft);
      PrinterTexto(iLinha, iLarguraPapel, FormatFloat('000', iItem), poRight);
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTexto(iLinha, iMargemFormas, 'Sub Total', poLeft);
      PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n',[fValorProdutos + dTotalServicos - dTotalDescontoItem]), poRight);
      if fDesconto <> 0 then // Sandro Silva 2020-10-14 if dDescontoTotalCupom <> 0 then
      begin
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemFormas, 'Desconto (-)', poLeft);
        PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n',[fDesconto]), poRight); // Sandro Silva 2020-10-14 PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n',[dDescontoTotalCupom]), poRight);
      end;
      if dTotalAcrescimo <> 0 then
      begin
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemFormas, 'Acréscimo', poLeft);
        PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n', [dTotalAcrescimo]), poRight);
      end;
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTexto(iLinha, iMargemFormas, 'Total', poLeft);
      PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n',[fValorProdutos + dTotalServicos - fDesconto - dTotalDescontoItem + dTotalAcrescimo]), poRight); // Sandro Silva 2020-10-14 PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n',[fValorProdutos + dTotalServicos - dDescontoTotalCupom + dTotalAcrescimo]), poRight);

      //
      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);
      CanvasLinha(iLinha, iAlturaFonte div 4, iPrimeiraLinhaPapel);

      PrinterTexto(iLinha, iMargemFormas, 'Formas de pagamento', poLeft);

      if Length(Venda.Formas) > 0 then
      begin

        for iItem := 0 to Length(Venda.Formas) - 1 do
        begin
          CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
          PrinterTexto(iLinha, iMargemFormas, Venda.Formas[iItem].Forma , poLeft);
          PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n', [Venda.Formas[iItem].Valor]), poRight);
        end;

        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTexto(iLinha, iMargemFormas, 'Troco', poLeft);
        PrinterTexto(iLinha, iLarguraPapel, Format('%10.2n', [Venda.Troco]), poRight);

      end;

      CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
      PrinterTraco(iLinha, iMargemEsq, iLarguraPapel);

      //
      sMensagem := Venda.Mensagem;
      while StringReplace(sMensagem, Chr(10), '', [rfReplaceAll]) <> '' do
      begin
        if Pos(Chr(10), sMensagem) = 0 then
          sItem := Copy(sMensagem, 1, Length(sMensagem))
        else
          sItem := Copy(sMensagem, 1, Pos(Chr(10), sMensagem));
        CanvasLinha(iLinha, iAlturaFonte, iPrimeiraLinhaPapel);
        PrinterTextoMemo(iLinha, iMargemEsq, (iLarguraPapel - iMargemEsq) - 5, StringReplace(sItem, Chr(10), '', [rfReplaceAll]), poJustify); // PrinterTexto(iLinha, iMargemEsq, StringReplace(sItem, Chr(10), '', [rfReplaceAll]), poLeft);
        sMensagem := StringReplace(sMensagem, sItem, '', []);
      end;

      Result := True;
    except
      Result := False;
    end;

  finally
    if Destino = toImage then
    begin
      try

        Printer.Abort;

        try
          if sFileExport = '' then // 2015-06-30
          begin
            sFilePDF := 'Venda_' + IBQALTERACA.FieldByName('PEDIDO').AsString + '_' + IBQALTERACA.FieldByName('CAIXA').AsString;
          end;

          if DirectoryExists(ExtractFilePath(Application.ExeName) + 'VENDAS') = False then
            ForceDirectories(ExtractFilePath(Application.ExeName) + 'VENDAS');

          // Cria o PDF

          {Create TPrintPDF VCL}
          PDF := TPrintPDF.Create(nil);

          {Set Doc Info}
          PDF.TITLE       := ExtractFileName(sFilePDF);
          PDF.Creator     := 'Zucchetti - ' + ExtractFileName(Application.ExeName);// Sandro Silva 2022-12-02 Unochapeco
          PDF.Author      := ConverteAcentos2(Form1.ibDataSet13.FieldByName('NOME').AsString);
          PDF.Keywords    := 'MOVIMENTO';
          PDF.Producer    := 'Zucchetti - ' + ExtractFileName(Application.ExeName);// Sandro Silva 2022-12-02 Unochapeco
          {Set Filename to save}
          if sFileExport = '' then // 2015-06-30
            PDF.Subject     := ExtractFileName(sFilePDF)
          else
            PDF.Subject     := sFileExport;

          PDF.JPEGQuality := 100; //2015-05-15 50;

          {Use Compression: VCL Must compile with ZLIB comes with D3 above}
          PDF.Compress    := False; // Sandro Silva 2017-04-11  True;

          {Set Page Size}
          PDF.PageWidth   := iLarguraFisica;
          PDF.PageHeight  := ALTURA_PAGINA_PDF; // Sandro Silva 2017-04-17  2374;

          {Set Filename to save}
          if sFileExport = '' then // 2015-06-30
            PDF.FileName  := ExtractFilePath(Application.ExeName) + 'VENDAS\' + sFilePDF + '.pdf'
          else
            PDF.FileName  := sFileExport;

          {Start Printing...}
          PDF.BeginDoc;

          for iPagina := 0 to Length(Pagina) -1 do
          begin

            {Print Image}
            PDF.DrawJPEG(0, 0, Pagina[iPagina].Picture.Bitmap);

            if iPagina < Length(Pagina) -1 then
              {Add New Page}
              PDF.NewPage;
            FreeAndNil(Pagina[iPagina]);
          end;

          {End Printing}
          sRetornoGeraPDF := PDF.EndDoc;

          Sleep(500 * Length(Pagina) -1);
        except
          on E: Exception do
          begin
            sRetornoGeraPDF := PDF.FileName + ' já está aberto';
          end;
        end;

        {FREE TPrintPDF VCL}
        if PDF <> nil then
          FreeAndNil(PDF);

        Pagina := nil;

      finally

      end;
    end
    else
    begin
      Printer.EndDoc;
    end;

    if Printer.Printing then
      Printer.Abort;

  end;

  FreeAndNil(IBQTOTAL);
  FreeAndNil(IBQALTERACA);
  FreeAndNil(IBQCLIFOR);
  FreeAndNil(IBQESTOQUE);
  if IBQPAGAMENT <> nil then
    FreeAndNil(IBQPAGAMENT);

end;

function _ecf99_ImprimeVenda(Venda: TVenda99; IBTransaction: TIBTransaction;
  sPedido: String; sCaixa: String; sCNPJCliente: String; sNomeCliente: String;
  sEmailCliente: String; sEnderecoCliente: String): Boolean;
begin

  Result := False;

  if Printer.Printers.Count > 0 then // Sandro Silva 2018-06-13
  begin
    Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
    if Trim(Form1.sImpressoraDestino) <> '' then
    begin
      try
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraDestino);
      except
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
      end;
    end;
    try
      Result := _ecf99_ImprimirCupomDinamico(Venda, IBTransaction, sPedido, sCaixa, sCNPJCliente, sNomeCliente, sEmailCliente, sEnderecoCliente, toPrinter);
      if Trim(Form1.sImpressoraDestino) <> '' then
        Printer.PrinterIndex := Printer.Printers.IndexOf(Form1.sImpressoraPadraoWindows);
    except
      Screen.Cursor := crDefault;
    end;
  end
  else
    ShowMessage('Instale uma impressora no Windows');

  ChDir(Form1.sAtual);

  Form1.OcultaPanelMensagem;

end;

procedure _ecf99_AcumulaFormaExtraNFCe(sOrdemExtra: String; dValor: Double;
{Sandro Silva 2023-08-21 inicio
    var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
    var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
    var dvPag_YA03_99: Double);
begin
  if sOrdemExtra = '10' then
    dvPag_YA03_10 := dvPag_YA03_10 + dValor;

  if sOrdemExtra = '11' then
    dvPag_YA03_11 := dvPag_YA03_11 + dValor;

  if sOrdemExtra = '12' then
    dvPag_YA03_12 := dvPag_YA03_12 + dValor;

  if sOrdemExtra = '13' then
    dvPag_YA03_13 := dvPag_YA03_13 + dValor;

  if sOrdemExtra = '99' then
    dvPag_YA03_99 := dvPag_YA03_99 + dValor;
}
  var dvPag_YA03_10: Double; var dvPag_YA03_11: Double;
  var dvPag_YA03_12: Double; var dvPag_YA03_13: Double;
  var dvPag_YA03_16: Double; var dvPag_YA03_17: Double;
  var dvPag_YA03_18: Double; var dvPag_YA03_19: Double;
  var dvPag_YA03_99: Double);
begin
  if sOrdemExtra = GERENCIAL_FORMA_10_VALE_ALIMENTACAO then
    dvPag_YA03_10 := dvPag_YA03_10 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_11_VALE_REFEICAO then
    dvPag_YA03_11 := dvPag_YA03_11 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_12_VALE_PRESENTE then
    dvPag_YA03_12 := dvPag_YA03_12 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_13_VALE_COMBUSTIVEL then
    dvPag_YA03_13 := dvPag_YA03_13 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_16_DEPOSITO_BANCARIO then
    dvPag_YA03_16 := dvPag_YA03_16 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_17_PAGAMENTO_INSTANTANEO then
    dvPag_YA03_17 := dvPag_YA03_17 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_18_TRANSFERENCIA_BANCARIA_CARTEIRA_DIGITAL then
    dvPag_YA03_18 := dvPag_YA03_18 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_19_PROGRAMA_FIDELIDADE_CASHBACK_CREDITO_VIRTUAL then
    dvPag_YA03_19 := dvPag_YA03_19 + dValor;

  if sOrdemExtra = GERENCIAL_FORMA_99_OUTROS then
    dvPag_YA03_99 := dvPag_YA03_99 + dValor;
{Sandro Silva 2023-08-21 fim}
end;

{ TMobile }

constructor TMobile.Create;
begin
  inherited;
  FVendaImportando := '';
end;

destructor TMobile.Destroy;
begin
  inherited;
end;

procedure TMobile.SetVendaImportando(const Value: String);
begin
  FVendaImportando := Value;
end;

{ TVenda99 }

constructor TVenda99.Create; // constructor TVenda99.Create(AOwner: TComponent);
begin
  inherited;
  SetLength(Formas, 0);
end;

destructor TVenda99.Destroy;
begin

  inherited;
end;

procedure TVenda99.AddForma(sForma: String; dValor: Currency);
var
  i: Integer;
begin
  //i := Length(FaForma) + 1;
  //SetLength(FaForma, i);
  SetLength(FaForma, Length(FaForma) + 1);
  I := High(FaForma);
  FaForma[i] := TForma.Create;
  FaForma[i].Forma := sForma;
  FaForma[i].Valor := dValor;
  FTotal := FTotal + dValor;

  i := Length(Formas) +1;
  SetLength(Formas, i);
  Formas[i - 1].Forma := sForma;
  Formas[i - 1].Valor := dValor;
end;

procedure TVenda99.SetCaixa(const Value: String);
begin
  FCaixa := Value;
end;

procedure TVenda99.SetCliente(const Value: String);
begin
  FCliente := Value;
end;

procedure TVenda99.SetCNPJCliente(const Value: String);
begin
  FCNPJCliente := Value;
end;
{
procedure TVenda99.SetfDescontoNoTotal(const Value: Currency);
begin
  FfDescontoNoTotal := Value;
end;
}
procedure TVenda99.SetPedido(const Value: String);
begin
  FPedido := Value;
end;

procedure TVenda99.SetTransaction(const Value: TIBTransaction);
begin
  FTransaction := Value;
end;

procedure TVenda99.SetTroco(const Value: Currency);
begin
  FTroco := Value;
end;

procedure TVenda99.SetMensagem(const Value: String);
begin
  FMensagem := Value;
end;

function TVenda99.FormasPagamento: String;
var
  i: Integer;
begin
  for i := 0 to High(FaForma) do
  begin
    Result := Result  +
     Copy(FaForma[i].Forma + Replicate(' ',35),1,35)+ Format('%10.2n',[FaForma[i].Valor])+chr(10);
  end;
end;

procedure TVenda99.SetEmailCliente(const Value: String);
begin
  FEmailCliente := Value;
end;

procedure TVenda99.SetEnderecoCliente(const Value: String);
begin
  FEnderecoCliente := Value;
end;

end.






