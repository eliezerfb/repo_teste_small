{
Alterações
Sandro Silva 2016-02-04
- Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
}
//
// Suporte
// Suporte ao desenvolvedor Skype: Epson - Suporte PEPS
// Epson - Suporte PEPS - Roberto 11 3956 6795 luismonegatto@epson.com.br
// Flavio Silva flaviosilva@epson.com.br
// Suporte Hardware
// Paulo Roberto Ramos 11 3956 6824 / 11 97233 1893 pramos@epson.com.br skype paulo_roberto_r
//
//
// Intervenções T800 F/T900 F
// interventweb:
//    login SOFTWAREHOUSE
//    senha SOFTWAREHOUSE
// DLL interfaceepson.dll versão 4.2
//http://www.epsonconnect.com.br:7000/scif09/webinterven/
//http://www.epsonconnect.com.br/scif09/webinterven

//
// Alterado 30/05/2007
//
unit _Small_15;

interface

uses

  Windows, Messages, SmallFunc_xe, Fiscal, SysUtils,Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Mask, Grids, DBGrids, DB, DBCtrls,
  SMALL_DBEdit, IniFiles, Unit2, Unit22, Unit7, ufuncaoMD5, ufuncoesfrente;
  //
  // EPSON
  //
  function EPSON_Serial_Abrir_Porta( Velocidade, Porta: Integer ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Serial_Fechar_Porta: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Serial_Obter_Estado_Com: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_RelatorioFiscal_Abrir_Dia: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Abrir_Cupom( CRZInicio, CRZFinal, TipoArquivo, NomeArquivo: PAnsiChar; Tamanho: Integer ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Vender_Item( Codigo, Descricao, Quantidade: PAnsiChar; PrecisaoQuantidade: Integer; Unidade, ValorUnitario: PAnsiChar; PrecisaoValorUnitario: Integer; Aliquota: PAnsiChar; NumeroLinhas: Integer ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Vender_Item_AD( pszCodigo:PAnsiChar; pszDescricao:PAnsiChar; pszQuantidade:PAnsiChar; dwCasasDecimaisQuantidade:Integer; pszUnidadeDeMedida:PAnsiChar; pszPrecoUnidade:PAnsiChar; dwCasasDecimaisPreco:Integer; pszAliquotas:PAnsiChar; dwLinhas:Integer; dwArredondaTrunca:Integer; dwFabricacaoPropria:Integer):Integer;StdCall; External 'InterfaceEpson.dll'; // Sandro Silva 2018-10-08 
  function EPSON_Fiscal_Pagamento( NrPagemento, ValorPagamento: PAnsiChar; CasasDecimais: Integer; Descricao01, descricao02: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Fechar_Cupom( CortaPapelAposRodape, ImprimirCupomAdicional: Boolean ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Fechar_CupomEx( TotalCupom: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Mensagem_Aplicacao(pszLinha01, pszLinha02: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Imprimir_Mensagem(pszLinha01, pszLinha02, pszLinha03, pszLinha04, pszLinha05, pszLinha06, pszLinha07, pszLinha08: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Imprimir_MensagemEX(pszLinhasTexto: PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll'; // Sandro Silva 2018-05-22
  function EPSON_Fiscal_Desconto_Acrescimo_Subtotal ( pszValor: PAnsiChar; dwCasasDecimais: DWORD; bDesconto, bPercentagem: Boolean): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Desconto_Acrescimo_Item(pszValor: PAnsiChar; dwCasasDecimais: dWord; bDesconto, bPercentagem: Boolean): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Config_Horario_Verao():Integer;StdCall; External 'InterfaceEpson.dll';
  //
  // 2015-08-19 function EPSON_Obter_Dados_MF_MFD( pszInicio, pszFinal : PAnsiChar; dwTipoEntrada, dwEspelhos, dwAtoCotepe, dwSintegra: DWORD; pszArquivoSaida: PAnsiChar): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Dados_MF_MFD(pszInicio:PAnsiChar; pszFinal:PAnsiChar; dwTipoEntrada:Integer; dwEspelhos:Integer; dwAtoCotepe:Integer; dwSintegra:Integer; pszArquivoSaida:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll';
  {Sandro Silva 2015-08-03 inicio
  function EPSON_Obter_Dados_Arquivos_MF_MFD( pszInicio:PAnsiChar; pszFim:PAnsiChar; dwTipoEntrada:Integer; dwEspelhos:Integer; dwAtoCOTEPE:Integer; dwSintegra:Integer;pszArquivoSaida:PAnsiChar; pszArquivoMF:PAnsiChar; pszArquivoMFD:PAnsiChar): Integer;StdCall; External 'InterfaceEpson.dll';
  function EPSON_Config_Habilita_EAD(bStatusHabilitaEAD:Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
  }
  function EPSON_Config_Habilita_EAD(bStatusHabilitaEAD:Boolean): Integer; StdCall; External 'InterfaceEpson.dll';
  function EPSON_Obter_Arquivos_Binarios(pszInicio:PAnsiChar; pszFinal:PAnsiChar; dwTipoEntrada:Integer; pszArquivoMF:PAnsiChar; pszArquivoMFD:PAnsiChar):Integer; StdCall; External 'InterfaceEpson.dll';
  function EPSON_Obter_Arquivo_Binario_MF(pszNomeArquivo: PAnsiChar):Integer; StdCall; External 'InterfaceEpson.dll';
  function EPSON_Obter_Arquivo_Binario_MFD(pszNomeArquivoMFD:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll';
  function EPSON_Config_Dados_PAFECF( pszDeveloperCNPJ:PAnsiChar; pszIE:PAnsiChar; pszIM:PAnsiChar; pszName:PAnsiChar; pszNomePAF:PAnsiChar; pszVersaoPAF:PAnsiChar; pszPAFMD5:PAnsiChar; pszVersaoER:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll';
  {Sandro Silva 2015-08-03 final}

  function EPSON_Obter_Tabela_Pagamentos(pszTabelaPagamentos:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll'; //2015-09-17
  function EPSON_Obter_Tabela_Relatorios_Gerenciais(pszTabelaRelatoriosGerenciais:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll'; //2015-09-17
  function EPSON_Obter_Tabela_Aliquotas( szAliquotas: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Dados_Ultima_RZ( szLastRZData: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';

  function EPSON_Obter_Data_Hora_Jornada( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Hora_Relogio( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Dados_Jornada( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Contadores( szContadores: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_GT( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Total_Cancelado( szCancelado: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Total_Descontos( szTotalDescontos: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Obter_SubTotal( szSubTotal: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_Fiscal_Cancelar_Cupom: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Cancelar_CupomEX():Integer;StdCall; External 'InterfaceEpson.dll'; // 2015-10-22
  function EPSON_Fiscal_Cancelar_Ultimo_Item: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Fiscal_Cancelar_Item ( pszNumeroItem: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_Obter_Mensagem_Erro(pszCodigoErro:PAnsiChar; pszMensagemErro:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll'; // Sandro Silva 2017-08-24   
  function EPSON_Obter_Estado_Impressora( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Estado_ImpressoraEX( szEstadoImpressora:PAnsiChar; szEstadoFiscal:PAnsiChar; szRetornoComando:PAnsiChar; szMsgErro:PAnsiChar):Integer;StdCall; External 'InterfaceEpson.dll';
  function EPSON_Obter_Cliche_Usuario( szUsuario: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Dados_Usuario ( szDadosUsuario: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_Obter_Numero_ECF_Loja( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Simbolo_Moeda( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Dados_Impressora( szDados: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Estado_Cupom( szEstado: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Estado_Horario_Verao(var Estado: Integer): Integer; stdcall; external 'InterfaceEpson.dll'; // Sandro Silva 2024-03-05 function EPSON_Obter_Estado_Horario_Verao( bEstado: pBoolean): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Obter_Codigo_Nacional_ECF(pszCodigoNacionalECF:PAnsiChar; pszNomeArquivo:PAnsiChar): Integer;StdCall; External 'InterfaceEpson.dll'; // Sandro Silva 2016-03-23
  //
  function EPSON_Config_Forma_Pagamento( bVinculado: Boolean; pszNumeroMeio, pszDescricao: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Config_Relatorio_Gerencial ( ReportDescription: AnsiString ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Config_Aliquota( pszTaxa: PAnsiChar; bTipoIss: Boolean ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_RelatorioFiscal_RZ( NovaData, NovaHora, HorarioVerao: PAnsiChar; ContadorCRZ: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_RelatorioFiscal_LeituraX: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_RelatorioFiscal_ReducaoZ( NovaData, NovaHora, HorarioVerao: PAnsiChar; ContadorCRZ: PAnsiChar ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_Impressora_Abrir_Gaveta: Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_RelatorioFiscal_Abrir_Jornada():Integer;StdCall; External 'InterfaceEpson.dll';
  //
  function EPSON_NaoFiscal_Sangria( pszValor: PAnsiChar; dwCasasDecimais: Integer): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Fundo_Troco( pszValor: PAnsiChar; dwCasasDecimais: Integer): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_RelatorioFiscal_Leitura_MF( pszInicio, pszFim: PAnsiChar; dwTipoImpressao: dWord; pszBuffer, pszArquivo: PAnsiChar; pdwTamanhoBuffer: pdWord; dwTamBuffer: dWord): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Fechar_Comprovante( bCortarPapel: Boolean ): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_NaoFiscal_Abrir_Relatorio_Gerencial(pszNumeroRelatorio: PAnsiChar): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Fechar_Relatorio_Gerencial( bCortarPapel: Boolean ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Imprimir_Linha(pszLinha: PAnsiChar): Integer; stdcall; external 'InterfaceEpson.dll';
  //
  function EPSON_NaoFiscal_Abrir_CCD(pszNumeroPagamento, pszValor: PAnsiChar; dwCasasDecimais: dWord; pszParcelas: PAnsiChar): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Fechar_CCD( bCortarPapel: Boolean ): Integer; stdcall; external 'InterfaceEpson.dll';
  function EPSON_NaoFiscal_Nova_Via_CCD: Integer; stdcall; external 'InterfaceEpson.dll';
  //

  //
  // EPSON
  //
  function _ecf15_Jornada_Aberta(pP1: Boolean): Boolean;
  function _ecf15_Abrir_Jornada: Boolean; // 2015-10-14
  function _ecf15_CodeErro(pP1: Integer; pP2: String):Integer;
  function _ecf15_Inicializa(Pp1: String):Boolean;
  function _ecf15_FechaCupom(Pp1: Boolean):Boolean;
  function _ecf15_Pagamento(Pp1: Boolean):Boolean;
  function _ecf15_CancelaUltimoItem(Pp1: Boolean):Boolean;
  function _ecf15_SubTotal(Pp1: Boolean):Real;
  function _ecf15_AbreGaveta(Pp1: Boolean):Boolean;
  function _ecf15_Sangria(Pp1: Real):Boolean;
  function _ecf15_Suprimento(Pp1: Real):Boolean;
  function _ecf15_NovaAliquota(Pp1: String):Boolean;
  function _ecf15_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
  function _ecf15_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
  function _ecf15_CancelaUltimoCupom(Pp1: Boolean):Boolean;
  function _ecf15_AbreNovoCupom(Pp1: Boolean):Boolean;
  function _ecf15_NumeroDoCupom(Pp1: Boolean):String;
  function _ecf15_CancelaItemN(pP1, pP2: String):Boolean;
  function _ecf15_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
  function _ecf15_ReducaoZ(pP1: Boolean):Boolean;
  function _ecf15_LeituraX(pP1: Boolean):Boolean;
  function _ecf15_RetornaVerao(pP1: Boolean):Boolean;
  function _ecf15_LigaDesLigaVerao(pP1: Boolean):Boolean;
  function _ecf15_VersodoFirmware(pP1: Boolean): String;
  function _ecf15_NmerodeSrie(pP1: Boolean): String;
  function _ecf15_CGCIE(pP1: Boolean): String;
  function _ecf15_Cancelamentos(pP1: Boolean): String;
  function _ecf15_Descontos(pP1: Boolean): String;
  function _ecf15_ContadorSeqencial(pP1: Boolean): String;
  function _ecf15_Nmdeoperaesnofiscais(pP1: Boolean): String;
  function _ecf15_NmdeCuponscancelados(pP1: Boolean): String;
  function _ecf15_NmdeRedues(pP1: Boolean): String;
  function _ecf15_Nmdeintervenestcnicas(pP1: Boolean): String;
  function _ecf15_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
  function _ecf15_Clichdoproprietrio(pP1: Boolean): String;
  function _ecf15_NmdoCaixa(pP1: Boolean): String;
  function _ecf15_Nmdaloja(pP1: Boolean): String;
  function _ecf15_Moeda(pP1: Boolean): String;
  function _ecf15_Dataehoradaimpressora(pP1: Boolean): String;
  function _ecf15_Datadaultimareduo(pP1: Boolean): String;
  function _ecf15_Datadomovimento(pP1: Boolean): String;
  function _ecf15_StatusGaveta(Pp1: Boolean):String;
  function _ecf15_RetornaAliquotas(pP1: Boolean): String;
  function _ecf15_Vincula(pP1: String): Boolean;
  function _ecf15_FlagsDeISS(pP1: Boolean): String;
  function _ecf15_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
  function _ecf15_MudaMoeda(pP1: String): Boolean;
  function _ecf15_MostraDisplay(pP1: String): Boolean;
  function _ecf15_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
  function _ecf15_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
  function _ecf15_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
  function _ecf15_FechaCupom2(sP1: Boolean): Boolean;
  function _ecf15_ImprimeCheque(rP1: Real; sP2: String): Boolean;
  function _ecf15_GrandeTotal(sP1: Boolean): String;
  function _ecf15_TotalizadoresDasAliquotas(sP1: Boolean): String;
  function _ecf15_CupomAberto(sP1: Boolean): boolean;
  function _ecf15_FaltaPagamento(sP1: Boolean): boolean;
  //
  // PAF
  //
  function _ecf15_Marca(sP1: Boolean): String;
  function _ecf15_Modelo(sP1: Boolean): String;
  function _ecf15_Tipodaimpressora(pP1: Boolean): String;
  function _ecf15_VersaoSB(pP1: Boolean): String; //
  function _ecf15_HoraIntalacaoSB(pP1: Boolean): String; //
  function _ecf15_DataIntalacaoSB(pP1: Boolean): String; //
  function _ecf15_ProgramaAplicativo(sP1: Boolean): boolean;
  function _ecf15_DadosDaUltimaReducao(pP1: Boolean): String; //
  function _ecf15_CodigoModeloEcf(pP1: Boolean): String; //

  //
  // Contadores
  //
  function _ecf15_GNF(Pp1: Boolean):String;
  function _ecf15_GRG(Pp1: Boolean):String;
  function _ecf15_CDC(Pp1: Boolean):String;
  function _ecf15_CCF(Pp1: Boolean):String;
  // 2015-09-15 function _ecf15_CER(Pp1: Boolean):String;
  function _ecf15_CER(sP1: String): String;
  function _ecf15_CRO(Pp1: Boolean):String;

  //
var
  sPrazo,
  sDinheiro,
  sCheque,
  sCartao,
  sExtra1,
  sExtra2,
  sExtra3,
  sExtra4,
  sExtra5,
  sExtra6,
  sExtra7,
  sExtra8  : String;


  iRetorno: Integer;
  Estado : String;
  ret1 : String;
  ret2 : String;
  ret3 : String;
  ret4 : String;
  ret5 : String;

implementation

uses StrUtils;

// ------------------------------ //
// Tratamento de erros da EPSON   //
// ------------------------------ //
function _ecf15_CodeErro(pP1: Integer; pP2: String):Integer;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..20] of AnsiChar;
  sErro : String;
begin
  //
  szDados := AnsiString(StringOfChar(' ', 20));
  EPSON_Obter_Estado_Impressora(PAnsiChar(szDados)); //2024-03-06 EPSON_Obter_Estado_Impressora(szDados);
  //
//  ShowMessage(sZDados);
// 000000001000c0810000
// 000000001001c0810000
// 000000000000c0800000
  //
  if Copy(sZDados,12,1)<>'0' then
  begin
    if Form1.Memo3.Visible then
    begin
      Form1.Panel2.Visible := True;
      Form1.Panel2.BringToFront;
    end;
  end else
  begin
    Form1.Panel2.Visible := False;
  end;
  //
  if (UpperCase(Copy(sZDados,17,4)) <> '0000') or (pP1 = 1) then
  begin
    // Retornos Essenciais (00)
    if UpperCase(Copy(sZDados,17,4)) = '0000' then sErro :='Resultado sem erro';
    if UpperCase(Copy(sZDados,17,4)) = '0001' then sErro :='Erro interno';
    if UpperCase(Copy(sZDados,17,4)) = '0002' then sErro :='Erro de iniciação do equipamento';
    if UpperCase(Copy(sZDados,17,4)) = '0003' then sErro :='Erro de processo interno';
    // Retornos sobre comandos genéricos (01)
    if UpperCase(Copy(sZDados,17,4)) = '0101' then sErro :='Comando inválido para o estado atual';
    if UpperCase(Copy(sZDados,17,4)) = '0102' then sErro :='Comando inválido para o documento atual';
    if UpperCase(Copy(sZDados,17,4)) = '0106' then sErro :='Comando aceito apenas fora de intervenção';
    if UpperCase(Copy(sZDados,17,4)) = '0107' then sErro :='Comando aceito apenas dentro de intervenção';
    if UpperCase(Copy(sZDados,17,4)) = '0108' then sErro :='Comando inválido durante processo de scan';
    if UpperCase(Copy(sZDados,17,4)) = '0109' then sErro :='Excesso de intervenções';
    // Retornos sobre Campos de Protocolo (02)
    if UpperCase(Copy(sZDados,17,4)) = '0201' then sErro :='Comando com frame inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0202' then sErro :='Comando inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0203' then sErro :='Campos em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0204' then sErro :='Campos em falta';
    if UpperCase(Copy(sZDados,17,4)) = '0205' then sErro :='Campo não opcional';
    if UpperCase(Copy(sZDados,17,4)) = '0206' then sErro :='Campo alfanumérico inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0207' then sErro :='Campo alfabético inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0208' then sErro :='Campo numérico inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0209' then sErro :='Campo binário inválido';
    if UpperCase(Copy(sZDados,17,4)) = '020A' then sErro :='Campo imprimível inválido';
    if UpperCase(Copy(sZDados,17,4)) = '020B' then sErro :='Campo hexadecimal inválido';
    if UpperCase(Copy(sZDados,17,4)) = '020C' then sErro :='Campo data inválido';
    if UpperCase(Copy(sZDados,17,4)) = '020D' then sErro :='Campo hora inválido';
    if UpperCase(Copy(sZDados,17,4)) = '020E' then sErro :='Campo com atributos de impressão inválidos';
    if UpperCase(Copy(sZDados,17,4)) = '020F' then sErro :='Campo booleano inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0210' then sErro :='Campo com tamanho inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0211' then sErro :='Extensão de comando inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0212' then sErro :='Código de barra não permitido';
    if UpperCase(Copy(sZDados,17,4)) = '0213' then sErro :='Atributos de impressão não permitidos';
    if UpperCase(Copy(sZDados,17,4)) = '0214' then sErro :='Atributos de impressão inválidos';
    if UpperCase(Copy(sZDados,17,4)) = '0215' then sErro :='Código de barras incorretamente definido';
    if UpperCase(Copy(sZDados,17,4)) = '0217' then sErro :='Comando invalido para a porta selecionada';
    // Retornos sobre Problemas de Hardware (03)
    if UpperCase(Copy(sZDados,17,4)) = '0301' then sErro :='Erro de hardware';
    if UpperCase(Copy(sZDados,17,4)) = '0302' then sErro :='Impressora não está pronta';
    if UpperCase(Copy(sZDados,17,4)) = '0303' then sErro :='Erro de Impressão';
    if UpperCase(Copy(sZDados,17,4)) = '0304' then sErro :='Falta de papel';
    if UpperCase(Copy(sZDados,17,4)) = '0306' then sErro :='Erro em carga ou expulsão do papel';
    if UpperCase(Copy(sZDados,17,4)) = '0307' then sErro :='Característica não suportada pela impressora';
    if UpperCase(Copy(sZDados,17,4)) = '0308' then sErro :='Erro de display';
    if UpperCase(Copy(sZDados,17,4)) = '0309' then sErro :='Seqüência de scan inválida';
    if UpperCase(Copy(sZDados,17,4)) = '030A' then sErro :='Número de área de recorte inválido';
    if UpperCase(Copy(sZDados,17,4)) = '030B' then sErro :='Scanner não preparado';
    if UpperCase(Copy(sZDados,17,4)) = '030C' then sErro :='Qualidade de Logotipo não suportada pela impressora';
    if UpperCase(Copy(sZDados,17,4)) = '030E' then sErro :='Erro de leitura do microcódigo';
    // Retornos de Iniciação (04)
    if UpperCase(Copy(sZDados,17,4)) = '0401' then sErro :='Número de série inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0402' then sErro :='Requer dados de fiscalização já configurados';
    // Retornos de Configuração (05)
    if UpperCase(Copy(sZDados,17,4)) = '0501' then sErro :='Data / Hora não configurada';
    if UpperCase(Copy(sZDados,17,4)) = '0502' then sErro :='Data inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0503' then sErro :='Data em intervalo inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0504' then sErro :='Nome operador inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0505' then sErro :='Número de caixa inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0508' then sErro :='Dados de Cabeçalho ou rodapé inválidos';
    if UpperCase(Copy(sZDados,17,4)) = '0509' then sErro :='Excesso de fiscalização';
    if UpperCase(Copy(sZDados,17,4)) = '050C' then sErro :='Número máximo de meios de pagamento já definidos';
    if UpperCase(Copy(sZDados,17,4)) = '050D' then sErro :='Meio de pagamento já definido';
    if UpperCase(Copy(sZDados,17,4)) = '050E' then sErro :='Meio de pagamento inválido';
    if UpperCase(Copy(sZDados,17,4)) = '050F' then sErro :='Descrição do meio de pagamento inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0510' then sErro :='Valor máximo de desconto inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0513' then sErro :='Logotipo do usuário inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0514' then sErro :='Seqüência de logotipo inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0515' then sErro :='Configuração de display inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0516' then sErro :='Dados do MICR inválidos';
    if UpperCase(Copy(sZDados,17,4)) = '0517' then sErro :='Campo de endereço inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0518' then sErro :='Nome da loja não definido';
    if UpperCase(Copy(sZDados,17,4)) = '0519' then sErro :='Dados fiscais não definidos';
    if UpperCase(Copy(sZDados,17,4)) = '051A' then sErro :='Número seqüencial do ECF inválido';
    if UpperCase(Copy(sZDados,17,4)) = '051B' then sErro :='Simbologia do GT inválida, devem ser todos diferentes';
    if UpperCase(Copy(sZDados,17,4)) = '051C' then sErro :='Número de CNPJ inválido';
    if UpperCase(Copy(sZDados,17,4)) = '051D' then sErro :='Senha de fiscalização inválida';
    if UpperCase(Copy(sZDados,17,4)) = '051E' then sErro :='Último documento deve ser uma redução Z';
    if UpperCase(Copy(sZDados,17,4)) = '051F' then sErro :='Símbolo da moeda igual ao atualmente cadastrado';
    if UpperCase(Copy(sZDados,17,4)) = '0520' then sErro :='Identificação da alíquota não cadastrada';
    if UpperCase(Copy(sZDados,17,4)) = '0521' then sErro :='Alíquota não cadastrada';
    // Retornos sobre Memória de Fita-detalhe(06)
    if UpperCase(Copy(sZDados,17,4)) = '0601' then sErro :='Memória de Fita-detalhe esgotada';
    if UpperCase(Copy(sZDados,17,4)) = '0605' then sErro :='Número de série invalido para a Memória de Fita-detalhe';
    if UpperCase(Copy(sZDados,17,4)) = '0606' then sErro :='Memória de Fita-detalhe não iniciada';
    if UpperCase(Copy(sZDados,17,4)) = '0607' then sErro :='Memória de Fita-detalhe não pode estar iniciada';
    if UpperCase(Copy(sZDados,17,4)) = '0608' then sErro :='Número de série da Memória de Fita-detalhe não confere';
    if UpperCase(Copy(sZDados,17,4)) = '0609' then sErro :='Erro Interno na Memória de Fita-detalhe';
    // Retornos sobre Jornada Fiscal (07)
    if UpperCase(Copy(sZDados,17,4)) = '0701' then sErro :='Valor inválido para o número do registro';
    if UpperCase(Copy(sZDados,17,4)) = '0702' then sErro :='Valor inválido para o número do item';
    if UpperCase(Copy(sZDados,17,4)) = '0703' then sErro :='Intervalo inválido para a leitura da MFD';
    if UpperCase(Copy(sZDados,17,4)) = '0704' then sErro :='Número de usuário inválido para MFD';
    // Retornos sobre Jornada Fiscal (08)
    if UpperCase(Copy(sZDados,17,4)) = '0801' then sErro :='Comando inválido com jornada fiscal fechada';
    if UpperCase(Copy(sZDados,17,4)) = '0802' then sErro :='Comando inválido com jornada fiscal aberta';
    if UpperCase(Copy(sZDados,17,4)) = '0803' then sErro :='Memória Fiscal esgotada';
    if UpperCase(Copy(sZDados,17,4)) = '0804' then sErro :='Jornada fiscal deve ser fechada';
    if UpperCase(Copy(sZDados,17,4)) = '0805' then sErro :='Não há meios de pagamento definidos';
    if UpperCase(Copy(sZDados,17,4)) = '0806' then sErro :='Excesso de meios de pagamento utilizados na jornada fiscal';
    if UpperCase(Copy(sZDados,17,4)) = '0807' then sErro :='Jornada fiscal sem movimento de vendas';
    if UpperCase(Copy(sZDados,17,4)) = '0808' then sErro :='Intervalo de jornada fiscal inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0809' then sErro :='Existem mais dados para serem lidos';
    if UpperCase(Copy(sZDados,17,4)) = '080A' then sErro :='Não existem mais dados para serem lidos';
    if UpperCase(Copy(sZDados,17,4)) = '080B' then sErro :='Não pode abrir jornada fiscal';
    if UpperCase(Copy(sZDados,17,4)) = '080C' then sErro :='Não pode fechar jornada fiscal';
    if UpperCase(Copy(sZDados,17,4)) = '080D' then sErro :='Limite máximo do período fiscal atingido (Redução Z pendente)';
    if UpperCase(Copy(sZDados,17,4)) = '080E' then sErro :='Limite máximo do período fiscal não atingido';
    if UpperCase(Copy(sZDados,17,4)) = '080F' then sErro :='Abertura da jornada fiscal não permitida';
    // Retornos sobre Transações Genéricas (09)
    if UpperCase(Copy(sZDados,17,4)) = '0901' then sErro :='Valor muito grande';
    if UpperCase(Copy(sZDados,17,4)) = '0902' then sErro :='Valor muito pequeno';
    if UpperCase(Copy(sZDados,17,4)) = '0903' then sErro :='Itens em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0904' then sErro :='Alíquotas em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0905' then sErro :='Desconto ou acréscimos em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0906' then sErro :='Meios de pagamento em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0907' then sErro :='Item não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0908' then sErro :='Meio de pagamento não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0909' then sErro :='Total nulo';
    if UpperCase(Copy(sZDados,17,4)) = '090C' then sErro :='Tipo de pagamento não definido';
    if UpperCase(Copy(sZDados,17,4)) = '090F' then sErro :='Alíquota não encontrada';
    if UpperCase(Copy(sZDados,17,4)) = '0910' then sErro :='Alíquota inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0911' then sErro :='Excesso de meios de pagamento com CDC';
    if UpperCase(Copy(sZDados,17,4)) = '0912' then sErro :='Meio de pagamento com CDC já emitido';
    if UpperCase(Copy(sZDados,17,4)) = '0913' then sErro :='Meio de pagamento com CDC ainda não emitido';
    if UpperCase(Copy(sZDados,17,4)) = '0914' then sErro :='Leitura da Memória Fiscal – intervalo CRZ inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0915' then sErro :='Leitura da Memória Fiscal – intervalo de data inválido';
    // Retornos sobre Cupom Fiscal (0A)
    if UpperCase(Copy(sZDados,17,4)) = '0A01' then sErro :='Operação não permitida após desconto / acréscimo';
    if UpperCase(Copy(sZDados,17,4)) = '0A02' then sErro :='Operação não permitida após registro de pagamentos';
    if UpperCase(Copy(sZDados,17,4)) = '0A03' then sErro :='Tipo de item inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A04' then sErro :='Linha de descrição em branco';
    if UpperCase(Copy(sZDados,17,4)) = '0A05' then sErro :='Quantidade muito pequena';
    if UpperCase(Copy(sZDados,17,4)) = '0A06' then sErro :='Quantidade muito grande';
    if UpperCase(Copy(sZDados,17,4)) = '0A07' then sErro :='Total do item com valor muito alto';
    if UpperCase(Copy(sZDados,17,4)) = '0A08' then sErro :='Operação não permitida antes do registro de pagamentos';
    if UpperCase(Copy(sZDados,17,4)) = '0A09' then sErro :='Registro de pagamento incompleto';
    if UpperCase(Copy(sZDados,17,4)) = '0A0A' then sErro :='Registro de pagamento finalizado';
    if UpperCase(Copy(sZDados,17,4)) = '0A0B' then sErro :='Valor pago inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A0C' then sErro :='Valor de desconto ou acréscimo não permitido';
    if UpperCase(Copy(sZDados,17,4)) = '0A0E' then sErro :='Valor não pode ser zero';
    if UpperCase(Copy(sZDados,17,4)) = '0A0F' then sErro :='Operação não permitida antes do registro de itens';
    if UpperCase(Copy(sZDados,17,4)) = '0A11' then sErro :='Cancelamento de desconto e acréscimo somente para item atual';
    if UpperCase(Copy(sZDados,17,4)) = '0A12' then sErro :='Não foi possível cancelar último Cupom Fiscal';
    if UpperCase(Copy(sZDados,17,4)) = '0A13' then sErro :='Último Cupom Fiscal não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0A14' then sErro :='Último Comprovante Não-Fiscal não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0A15' then sErro :='Cancelamento de CDC necessária';
    if UpperCase(Copy(sZDados,17,4)) = '0A16' then sErro :='Número de item em Cupom Fiscal inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A17' then sErro :='Operação somente permitida após subtotalização';
    if UpperCase(Copy(sZDados,17,4)) = '0A18' then sErro :='Operação somente permitida durante a venda de itens';
    if UpperCase(Copy(sZDados,17,4)) = '0A19' then sErro :='Operação não permitida em item com desconto ou acréscimo';
    if UpperCase(Copy(sZDados,17,4)) = '0A1A' then sErro :='Dígitos de quantidade inválidos';
    if UpperCase(Copy(sZDados,17,4)) = '0A1B' then sErro :='Dígitos de valor unitário inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A1C' then sErro :='Não há desconto ou acréscimo a cancelar';
    if UpperCase(Copy(sZDados,17,4)) = '0A1D' then sErro :='Não há item para cancelar';
    if UpperCase(Copy(sZDados,17,4)) = '0A1E' then sErro :='Desconto ou acréscimo somente no item atual';
    if UpperCase(Copy(sZDados,17,4)) = '0A1F' then sErro :='Desconto ou acréscimo já efetuado';
    if UpperCase(Copy(sZDados,17,4)) = '0A20' then sErro :='Desconto ou acréscimo nulo não permitido';
    if UpperCase(Copy(sZDados,17,4)) = '0A21' then sErro :='Valor unitário inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A22' then sErro :='Quantidade inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0A23' then sErro :='Código de item inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0A24' then sErro :='Descrição inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0A25' then sErro :='Operação de desconto ou acréscimo não permitida';
    if UpperCase(Copy(sZDados,17,4)) = '0A26' then sErro :='Mensagem promocional já impressa';
    if UpperCase(Copy(sZDados,17,4)) = '0A27' then sErro :='Linhas adicionais não podem ser impressas';
    if UpperCase(Copy(sZDados,17,4)) = '0A28' then sErro :='Dados do consumidor já impresso';
    if UpperCase(Copy(sZDados,17,4)) = '0A29' then sErro :='Dados do consumidor somente no fim do documento';
    if UpperCase(Copy(sZDados,17,4)) = '0A2A' then sErro :='Dados do consumidor somente no inicio do documento';
    if UpperCase(Copy(sZDados,17,4)) = '0A2B' then sErro :='Comando Inválido para o item';
    // Erros em operações não-fiscais (0E)
    if UpperCase(Copy(sZDados,17,4)) = '0E01' then sErro :='Número de linhas em documento excedido';
    if UpperCase(Copy(sZDados,17,4)) = '0E02' then sErro :='Número do relatório inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0E03' then sErro :='Operação não permitida após registro de itens';
    if UpperCase(Copy(sZDados,17,4)) = '0E04' then sErro :='Registro de valor nulo não permitido';
    if UpperCase(Copy(sZDados,17,4)) = '0E05' then sErro :='Não há desconto a cancelar';
    if UpperCase(Copy(sZDados,17,4)) = '0E06' then sErro :='Não há acréscimo a cancelar';
    if UpperCase(Copy(sZDados,17,4)) = '0E07' then sErro :='Operação somente permitida após subtotalização';
    if UpperCase(Copy(sZDados,17,4)) = '0E08' then sErro :='Operação somente permitida durante registro de itens';
    if UpperCase(Copy(sZDados,17,4)) = '0E09' then sErro :='Operação não-fiscal inválida';
    if UpperCase(Copy(sZDados,17,4)) = '0E0A' then sErro :='Último comprovante Não-Fiscal não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0E0B' then sErro :='Meio de pagamento não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0E0C' then sErro :='Não foi possível imprimir nova via';
    if UpperCase(Copy(sZDados,17,4)) = '0E0D' then sErro :='Não foi possível realizar reimpressão';
    if UpperCase(Copy(sZDados,17,4)) = '0E0E' then sErro :='Não foi possível imprimir nova parcela';
    if UpperCase(Copy(sZDados,17,4)) = '0E0F' then sErro :='Não há mais parcelas a imprimir';
    if UpperCase(Copy(sZDados,17,4)) = '0E10' then sErro :='Registro de item Não-Fiscal inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0E11' then sErro :='Desconto ou acréscimo já efetuado';
    if UpperCase(Copy(sZDados,17,4)) = '0E12' then sErro :='Valor de desconto ou acréscimo inválido';
    if UpperCase(Copy(sZDados,17,4)) = '0E13' then sErro :='Não foi possível cancelar o item';
    if UpperCase(Copy(sZDados,17,4)) = '0E14' then sErro :='Itens em excesso';
    if UpperCase(Copy(sZDados,17,4)) = '0E15' then sErro :='Operação Não-Fiscal não cadastrada';
    if UpperCase(Copy(sZDados,17,4)) = '0E16' then sErro :='Excesso de relatórios / operações não-fiscais cadastradas';
    if UpperCase(Copy(sZDados,17,4)) = '0E17' then sErro :='Relatório não encontrado';
    if UpperCase(Copy(sZDados,17,4)) = '0E18' then sErro :='Comando não permitido';
    if UpperCase(Copy(sZDados,17,4)) = '0E19' then sErro :='Comando não permitido em operações não-fiscais para movimento de monetário';
    if UpperCase(Copy(sZDados,17,4)) = '0E1A' then sErro :='Comando permitido apenas em operações não-fiscais para movimento de monetário';
    if UpperCase(Copy(sZDados,17,4)) = '0E1B' then sErro :='Número de parcelas inválido para a emissão de CCD';
    if UpperCase(Copy(sZDados,17,4)) = '0E1C' then sErro :='Operação não fiscal já cadastrada';
    if UpperCase(Copy(sZDados,17,4)) = '0E1D' then sErro :='Relatório gerencial já cadastrado';
    if UpperCase(Copy(sZDados,17,4)) = '0E1E' then sErro :='Relatório Gerencial Inválido';
    // Erros para impressão de cheque ou autenticação (30)
    if UpperCase(Copy(sZDados,17,4)) = '3001' then sErro :='Configuração de cheque não registrada';
    if UpperCase(Copy(sZDados,17,4)) = '3002' then sErro :='Configuração de cheque não encontrada';
    if UpperCase(Copy(sZDados,17,4)) = '3003' then sErro :='Valor do cheque já impresso';
    if UpperCase(Copy(sZDados,17,4)) = '3004' then sErro :='Nominal ao cheque já impresso';
    if UpperCase(Copy(sZDados,17,4)) = '3005' then sErro :='Linhas adicionais no cheque já impresso';
    if UpperCase(Copy(sZDados,17,4)) = '3006' then sErro :='Autenticação já impressa';
    if UpperCase(Copy(sZDados,17,4)) = '3007' then sErro :='Número máximo de autenticações já impresso';
    // Outros (FF)
    if UpperCase(Copy(sZDados,17,4)) = 'FFFF' then sErro :='Erro desconhecido';
    if UpperCase(Copy(sZDados,17,4)) <> '0102' then
    begin
      if AlltRim(sErro) <> '' then ShowMessage(sErro+chr(10)+Chr(10)+sZDados);
    end;
    //
    if UpperCase(Copy(sZDados,17,4)) = '080D' then
    begin
      // 2015-10-07_ecf15_ReducaoZ(True);
      // 2015-10-07 Form1.Demais('RZ'); // 2015-10-06
      {Sandro Silva 2015-10-07 inicio
      Form1.EmitirReducaoZ(Form1);// 2015-10-07 Deve emitir mesas aberta, fechar as aberta a mais de 1 dias antes ou logo após da redução Z
      Halt(1);
      }
      ShowMessage('Redução Z pendente');
    end;
    //
    Result := 99;
    //
    // Ok
    //
  end else Result := 0;
end;


// ----------------------------//
// Detecta qual a porta que    //
// a impressora está conectada //
// EPSON                       //
// --------------------------- //
function _ecf15_Inicializa(Pp1: String):Boolean;
var
  I : Integer;
  szDados: AnsiString; // 2024-03-06 sZDados: array[0..15] of AnsiChar;
  Mais1ini: tIniFile;
  iBPS: Integer;
  szTabelaRelatoriosGerenciais: AnsiString;
  szTabelaPagamentos: AnsiString;
  //Timer1: TTime;
  //Timer2: TTime;
  //Timer3: TTime;
  //Timer4: TTime;
  //Timer5: TTime;

  function FormaPagamentoExiste(sFormaPagamento: String): Boolean;
  var
    sForma: String;
    asTabelaRetornada: AnsiString;
  begin
    Result := False;
    asTabelaRetornada := szTabelaPagamentos;
    while Trim(asTabelaRetornada) <> '' do
    begin
      sForma := Copy(asTabelaRetornada, 1, 44);
      if Pos(sFormaPagamento, sForma) > 0 then
      begin
        Result := True;
        Break;
      end;
      asTabelaRetornada := StringReplace(asTabelaRetornada, sForma, '',[rfIgnoreCase]);
    end;
  end;

  function RelatGerencialExiste(sRelatorioGerencial: String): Boolean;
  var
    sRela: String;
    asTabelaRetornada: AnsiString;
  begin
    Result := False;
    asTabelaRetornada := szTabelaRelatoriosGerenciais;
    while Trim(asTabelaRetornada) <> '' do
    begin
      sRela := Copy(asTabelaRetornada, 1, 21);
      if Pos(sRelatorioGerencial, sRela) > 0 then
      begin
        Result := True;
        Break;
      end;
      asTabelaRetornada := StringReplace(asTabelaRetornada, sRela, '',[rfIgnoreCase]);
    end;
  end;
begin
  //
  //  CHDir('\\tsclient\c\Arquivos de Programas\SmallSoft\Small Commerce');
  //
  //Timer1 := Time;
  Result := True;
  //
  Mais1ini    := TIniFile.Create('frente.ini');
  iBPS        := Mais1Ini.ReadInteger('Frente de caixa','BPS',38400);
  if Mais1Ini.ReadInteger('Frente de caixa','BPS',0) = 0 then
    Mais1Ini.WriteInteger('Frente de caixa','BPS',38400);
  Mais1ini.Free;
  //
  // 9600,19200,38400,57600 e 115200
  //
  EPSON_Serial_Fechar_Porta();
  Sleep(100);
  EPSON_Serial_Abrir_Porta(iBPS,StrToInt(LimpaNumero(pP1)));
  Sleep(100);
  if Length(_ecf15_Dataehoradaimpressora(True)) <> 12 then
    iRetorno := 99
  else
    iREtorno := 0;

  //Timer2 := Time;

  //
  for I := 1 to 7 do
  begin
    if iRetorno <> 0 then
    begin
      Result := False;
//      ShowMessage('EPSON '+Chr(10)+'Testando COM'+StrZero(I,1,0));
      EPSON_Serial_Fechar_Porta();
      EPSON_Serial_Abrir_Porta(iBPS,I);
      if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
        EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(True);
      if Length(_ecf15_Dataehoradaimpressora(True)) <> 12 then
        iRetorno := 99
      else
        iREtorno := 0;

      if iRetorno = 0 then
        Form1.sPorta := 'COM'+StrZero(I,1,0);
    end;
    {Sandro Silva 2015-09-09 inicio
    if iRetorno = 0 then
      Result := True;
    }
    if iRetorno = 0 then
    begin
      Result := True;
      Break;
    end;
  end;

  //Timer3 := Time;
  //
  if Form22.Label6.Caption = 'Detectando porta de comunicação...' then
  begin
    //
    szDados := AnsiString(StringOfChar(' ', 15));
    EPSON_Obter_Data_Hora_Jornada(PAnsiChar(sZDados)); //2024-03-06 EPSON_Obter_Data_Hora_Jornada(sZDados);
    {Sandro Silva 2015-10-06 inicio
    if not _ecf15_Jornada_Aberta(True) then
      EPSON_RelatorioFiscal_Abrir_Dia();
    }
    if not _ecf15_Jornada_Aberta(True) then
    begin
      if EPSON_RelatorioFiscal_Abrir_Dia() = 0 then
      begin
        if Trim(Form1.sNumeroDeSerieDaImpressora) = '' then
        begin
          Form1.sNumeroDeSerieDaImpressora := Copy(AllTrim(_ecf15_NmerodeSrie(True)), 1, 20);
        end;
        Form1.Demais('LX');
      end;
    end;
    {Sandro Silva 2015-10-06 final}


    {Sandro Silva 2016-02-24 inicio}
    EPSON_Config_Habilita_EAD(False);
    {Sandro Silva 2016-02-24 final}

    //Timer4 := Time;

    //O buffer retornado na variável pszTabelaRelatoriosGerencias, é composto por 20 sequencias de 420 caracteres cada.
    //Cada sequência corresponderá a um dos 20 Relatórios Gerenciais possíveis de serem cadastradas no ECF,
    //totalizando 420 bytes a serem retornados
    szTabelaRelatoriosGerenciais := AnsiString(StringOfChar(' ', 421));
    EPSON_Obter_Tabela_Relatorios_Gerenciais(PAnsiChar(szTabelaRelatoriosGerenciais));

    //ShowMessage('Teste 1 ' + szTabelaRelatoriosGerenciais);

    //ShowMessage('teste 1 ' + _ecf15_NmdeRedues(True));

    szTabelaPagamentos := AnsiString(StringOfChar(' ', 881));
    EPSON_Obter_Tabela_Pagamentos(PAnsiChar(szTabelaPagamentos));
    //ShowMessage('Teste 1 ' + szTabelaPagamentos);

    //
    if FormaPagamentoExiste('Dinheiro') = False then
      EPSON_Config_Forma_Pagamento(False,'1','Dinheiro');
    if FormaPagamentoExiste('Cheque') = False then
      EPSON_Config_Forma_Pagamento(True,'2','Cheque');
    if FormaPagamentoExiste('Cartao') = False then
      EPSON_Config_Forma_Pagamento(True,'3','Cartao');
    if FormaPagamentoExiste('Prazo') = False then
      EPSON_Config_Forma_Pagamento(True,'4','Prazo');

    //
    if RelatGerencialExiste('IDENT DO PAF') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('IDENT DO PAF'))); // 2
    if RelatGerencialExiste('VENDA PRAZO') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('VENDA PRAZO'))); // 3 // 2015-07-31 EPSON_Config_Relatorio_Gerencial(PAnsiChar('TEF'));
    if RelatGerencialExiste('CARTAO TEF') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('CARTAO TEF'))); // 4
    if RelatGerencialExiste('MEIOS DE PAGTO') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('MEIOS DE PAGTO'))); // 5
    if RelatGerencialExiste('DAV Emitidos') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('DAV Emitidos'))); // 6
    if RelatGerencialExiste('Orçamento (DAV)') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('Orçamento (DAV)'))); // 7
    {Sandro Silva 2016-02-04 inicio
    if RelatGerencialExiste('CONF CONTA') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar('CONF CONTA'));
    }
    if RelatGerencialExiste('CONF CONTA CLI') = False then // 2016-02-04 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('CONF CONTA CLI'))); // 8
    {Sandro Silva 2016-02-04 final}
    {Sandro Silva 2016-02-11 inicio
    if RelatGerencialExiste('TRANSF CONTA') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar('TRANSF CONTA'));
    if RelatGerencialExiste('CONTAS ABERTAS') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar('CONTAS ABERTAS'));
    }
    if RelatGerencialExiste('TRANSF CONT CLI') = False then // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('TRANSF CONT CLI'))); // 9
    if RelatGerencialExiste('CONT CLI ABERTA') = False then // 2016-02-11 Fiscal de AL exigiu que o nome do relatório seja conforme er, podendo abreviar mas não suprimir por completo ou incluir texto
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('CONT CLI ABERTA'))); // 10
    {Sandro Silva 2016-02-11 final}
    if RelatGerencialExiste('CONF MESA') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('CONF MESA'))); // 11
    if RelatGerencialExiste('TRANSF MESA') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('TRANSF MESA'))); // 12
    if RelatGerencialExiste('MESAS ABERTAS') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('MESAS ABERTAS'))); // 13
    if RelatGerencialExiste('PARAM CONFIG') = False then
      EPSON_Config_Relatorio_Gerencial(PAnsiChar(AnsiString('PARAM CONFIG'))); // 14

    //Timer5 := Time;
    //

    //ShowMessage('Teste 1' + #13 + '1 ' + FormatDateTime('hh:nn:ss.zzz', Timer2 - Timer1)
    //                      + #13 + '2 ' + FormatDateTime('hh:nn:ss.zzz', Timer3 - Timer2)
    //                      + #13 + '3 ' + FormatDateTime('hh:nn:ss.zzz', Timer4 - Timer3)
    //                      + #13 + '4 ' + FormatDateTime('hh:nn:ss.zzz', Timer5 - Timer4));

  end;
  //
  //  EPSON_Config_Aliquota('500',True);
  //
  //  if Copy(DateToStr(Date),1,2)+Copy(DateToStr(Date),4,2)+Copy(DateToStr(Date),9,2) <> Copy(sZDados,1,4)+Copy(sZDados,7,8) then
  //    EPSON_RelatorioFiscal_Abrir_Dia();                    // Quando a data não é igual ao dia tem que abrir a Jornada No primeiro antes de abrir a jornada retornava  Ex: 01012000
  //
  // Ok Testado 10
  //

  //ShowMessage('Teste 01 CODIGO MODELO ECF ' + _ecf15_CodigoModeloEcf(True));
end;


// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido DESCONTO ou ACRESCIMO  //
// EPSON                          //
// ------------------------------ //
function _ecf15_FechaCupom(Pp1: Boolean):Boolean;
begin
  //
  if Form1.fTotal <> 0 then
  begin
    if Form1.fTotal >= Form1.ibDataSet25RECEBER.AsFloat then
    begin
      //2024-03-05 iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Subtotal(PAnsiChar(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,11,0)), 2, True, False); // Desconto
      iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Subtotal(PAnsiChar(AnsiString(StrZero((Form1.fTotal-Form1.ibDataSet25RECEBER.AsFloat)*100,11,0))), 2, True, False); // Desconto
    end else
    begin
      // 2024-03-05 iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Subtotal(PAnsiChar(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,11,0)), 2, False, False); // Acréscimo
      iRetorno := EPSON_Fiscal_Desconto_Acrescimo_Subtotal(PAnsiChar(AnsiString(StrZero((Form1.ibDataSet25RECEBER.AsFloat-Form1.fTotal)*100,11,0))), 2, False, False); // Acréscimo
    end;
  end
  else
    _ecf15_CancelaUltimoCupom(True);  // cupom em branco cancela
  Result := True;

  //_ecf15_codeErro(iRetorno,''); // Sandro Silva 2018-05-22

  {Sandro Silva 2015-09-18 inicio
  if Form1.fTotal <> 0 then
  begin
    if iRetorno <> 0 then
      Result := False;
  end;
  }
  //
  // Ok - Testado 10
  //
end;

// ------------------------------ //
// Fecha o cupom que está sendo   //
// emitido                        //
// EPSON                          //
// ------------------------------ //
function _ecf15_Pagamento(Pp1: Boolean):Boolean;
var
  //
  szTotal:Ansistring;//2024-03-05 szTotal: array[0..20] of AnsiChar;
  Mais1ini : TiniFile;
  //
begin
  szTotal := AnsiString(StringOfChar(' ', 20));
  //
  Mais1ini  := TIniFile.Create('frente.ini');
  //
  sDinheiro := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Dinheiro', 1),2,0);
  sCheque   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Cheque'  , 2),2,0);
  sCartao   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Cartao'  , 3),2,0);
  sPrazo    := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Prazo' , 4),2,0);
  sExtra1   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 1', 5),2,0);
  sExtra2   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 2', 6),2,0);
  sExtra3   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 3', 7),2,0);
  sExtra4   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 4', 8),2,0);
  sExtra5   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 5', 9),2,0);
  sExtra6   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 6',10),2,0);
  sExtra7   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 7',11),2,0);
  sExtra8   := StrZero(Mais1Ini.ReadInteger('Frente de caixa','Ordem forma extra 8',12),2,0);
  Mais1ini.Free; // Sandro Silva 2018-11-21 Memória
  //
  Sleep(300);
  //
  {2024-03-05
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sCheque)   ,PAnsiChar(StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sDinheiro) ,PAnsiChar(StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sCartao)   ,PAnsiChar(StrZero(Form1.ibDataSet25PAGAR.AsFloat      * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sPrazo)    ,PAnsiChar(StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra1)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR01.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra2)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR02.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra3)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR03.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra4)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR04.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra5)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR05.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra6)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR06.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra7)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR07.AsFloat    * 100,13,0)), 2, '', '' );
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(sExtra8)   ,PAnsiChar(StrZero(Form1.ibDataSet25VALOR08.AsFloat    * 100,13,0)), 2, '', '' );
  }
  if Form1.ibDataSet25ACUMULADO1.AsFloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sCheque))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25ACUMULADO2.AsFloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sDinheiro)) ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25ACUMULADO2.AsFloat * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25PAGAR.AsFloat      <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sCartao))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25PAGAR.AsFloat      * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25DIFERENCA_.Asfloat <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sPrazo))    ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR01.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra1))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR01.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR02.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra2))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR02.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR03.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra3))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR03.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR04.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra4))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR04.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR05.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra5))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR05.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR06.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra6))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR06.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR07.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra7))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR07.AsFloat    * 100,13,0))), 2, '', '' );
  if Form1.ibDataSet25VALOR08.AsFloat    <> 0 then iRetorno := EPSON_Fiscal_Pagamento(PAnsiChar(AnsiString(sExtra8))   ,PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25VALOR08.AsFloat    * 100,13,0))), 2, '', '' );

  //
  _ecf15_codeErro(iRetorno,'');

  {2024-03-05
  iRetorno := EPSON_Fiscal_Imprimir_Mensagem(
    PAnsiChar('MD5: '+Form1.sMD5DaLista),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*1)+1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*2)+1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*3)+1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*4)+1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*5)+1,55)),
    PAnsiChar(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*6)+1,55))
    );
    }
  iRetorno := EPSON_Fiscal_Imprimir_Mensagem(
    PAnsiChar(AnsiString('MD5: '+Form1.sMD5DaLista)),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*1)+1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*2)+1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*3)+1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*4)+1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*5)+1,55))),
    PAnsiChar(AnsiString(Copy(StrTran(Form1.sMensagemPromocional,chr(10),' - ')+Replicate(' ',640),(55*6)+1,55)))
    );


  //ShowMessage('Teste 1 impressão mensagem promocional ' + IntToStr(iRetorno));

  //_ecf15_codeErro(iRetorno,''); // Sandro Silva 2018-05-22

  iRetorno := EPSON_Fiscal_Fechar_Cupom( True, False );
  //

  //ShowMessage('Teste 1 depois de fechar ' + IntToStr(iRetorno));

  _ecf15_codeErro(iRetorno,'');
  iRetorno := EPSON_Fiscal_Fechar_CupomEx (PAnsiChar(szTotal));// 2024-03-05 iRetorno := EPSON_Fiscal_Fechar_CupomEx ( szTotal );
  Result := True;

  //Result := iRetorno = 0; // 2015-09-18
  //
  // Testado OK - 10
  //
end;


// ------------------------------ //
// EPSON                          //
// cancela o último item do cupom //
// ------------------------------ //
function _ecf15_CancelaUltimoItem(Pp1: Boolean):Boolean;
begin
  EPSON_Fiscal_Cancelar_Ultimo_Item();
  Result := True;
  // Testado OK - 10
end;

// -------------------------------//
// EPSON                          //
// Cancela o último cupom emitido //
// -------------------------------//
function _ecf15_CancelaUltimoCupom(Pp1: Boolean):Boolean;
begin
  // 2015-10-22 iRetorno := EPSON_Fiscal_Cancelar_Cupom();
  iRetorno := EPSON_Fiscal_Cancelar_CupomEX();// cancela o último cupom fiscal. Caso existam Comprovantes de Crédito ou Débito relacionados a este cupom, os mesmos também serão cancelados.
  if iRetorno = 0 then Result := True else Result := False;
  // Testado OK - 10

  if Result = False then
    ShowMessage('Cancelamento não permitido'); // Sandro Silva 2018-10-18
end;

// -------------------------------//
// EPSON                          //
// Subtotal                       //
// -------------------------------//
function _ecf15_SubTotal(Pp1: Boolean):Real;
var
  szSubTotal: Ansistring;//2024-03-06 szSubTotal: array[0..20] of AnsiChar;
begin
  szSubTotal := AnsiString(StringOfChar(' ', 20));

  EPSON_Fiscal_Obter_SubTotal(PAnsiChar(szSubTotal)); // 2024-03-06 EPSON_Fiscal_Obter_SubTotal(szSubTotal);
  Result := StrToFloat('0'+AllTrim(szSubTotal))/100;
  // Testado OK - 10
end;

// ------------------------------ //
// Abre um novo cupom fiscal      //
// EPSON                          //
// ------------------------------ //
function _ecf15_AbreNovoCupom(Pp1: Boolean):Boolean;
var
  //2024-03-05 sZDados : array[0..20] of AnsiChar;
  szDados: AnsiString;
begin
  szDados := AnsiString(StringOfChar(' ', 20));
  //
  iRetorno := EPSON_Fiscal_Abrir_Cupom(PAnsiChar(AnsiString(Form1.sCPF_CNPJ_Validado)),'','','',2); // 2024-03-05 iRetorno := EPSON_Fiscal_Abrir_Cupom(PAnsiChar(Form1.sCPF_CNPJ_Validado),'','','',2);
  EPSON_Obter_Estado_Impressora(PAnsiChar(szDados)); // 2024-03-05 EPSON_Obter_Estado_Impressora(szDados);
  {Sandro Silva 2015-10-08 inicio
  if iRetorno <> 0 then _ecf15_codeErro(iRetorno,'');
  Result := True;
  }
  Result := False;// Sandro Silva 2016-04-12
  if iRetorno <> 0 then
  begin
    _ecf15_codeErro(iRetorno,'');
    {Sandro Silva 2016-11-29 inicio}
    // Para conseguir continuar a venda se fechar e abrir o frente com um cupom aberto
    if _ecf15_CupomAberto(True) then
      Result := True;
    {Sandro Silva 2016-11-29 final}
  end
  else
    Result := True;
  {Sandro Silva 2015-10-08 final}
  //
  // Ok
  //
end;

// -------------------------------- //
// Retorna o número do Cupom        //
// EPSON                            //
// -------------------------------- //
function _ecf15_NumeroDoCupom(Pp1: Boolean):String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores));// 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,1,6);
  //
  // Ok testado 10
  //
end;

// -------------------------- //
// Retorna o número do CCF    //
// -------------------------- //
function _ecf15_ccF(Pp1: Boolean):String;
var
  szContadores: AnsiString;// 2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores));//2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  {Sandro Silva 2015-08-18 inicio
  Result := Copy(szContadores,42,6);
  }
  Result := Copy(szContadores,43,6);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. GNF   //
// ------------------------------------------------------------------------- //
function _ecf15_gnf(Pp1: Boolean):String;
var
  szContadores: AnsiString;// 2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores));//2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );

  _ecf15_codeErro(iRetorno,'');
  {Sandro Silva 2015-08-18 inicio
  Result := Copy(szContadores,18,6);
  }
  Result := Copy(szContadores,19,6);
end;

// ------------------------------------------------------------------------- //
// Retorna o número de operações não fiscais executadas na impressora. CER   //
// ------------------------------------------------------------------------- //
(*{Sandro Silva 2015-09-15 inicio}
function _ecf15_CER(Pp1: Boolean):String;
var
  szContadores: array[0..100] of AnsiChar;
begin
  iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  {Sandro Silva 2015-08-18 inicio
  Result := Copy(szContadores,36,6);
  }

  //ShowMessage('Teste 1 ' + #13 +szContadores);

  Result := Copy(szContadores,37,6);
end;
*)
function _ecf15_CER(sP1: String): String;
var
  sIndice: String;
  sRela: String;
  //iRetorno: Integer;
  szTabelaRelatoriosGerenciais: AnsiString;
begin
  if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
  begin
    sIndice := '02'; // Identificação do PAF
  end else
  begin
    if Pos('Período Solicitado: de',sP1)<>0 then
    begin
      sIndice := '05'; // Meios de pagamento
    end else
    begin
      if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
      begin
        sIndice := '03'; // Venda a prazo
      end else
      begin
        if Pos('DAV EMITIDOS',sP1)<>0 then
        begin
          sIndice := '06'; // DAV Emitidos
        end else
        begin
          if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
          begin
            sIndice := '07'; // Orçamento (DAV)
          end else
          begin
            if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
            begin
              sIndice := '08'; // Conferencia de contas
            end else
            begin
              if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
              begin
                sIndice := '09'; // Transferencia entre contas
              end else
              begin
                if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                begin
                  sIndice := '10'; // Mesas Contas
                end else
                begin
                  if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                  begin
                    sIndice := '11'; // Conferencia de Mesas
                  end else
                  begin
                    if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                    begin
                      sIndice := '12' // Transferencia entre contas
                    end else
                    begin
                      if Pos('MESAS ABERTAS',sP1)<>0 then
                      begin
                        sIndice := '13' // Mesas abertas
                      end else
                      begin
                        if Pos('Parametros de Configuracao',sP1)<>0 then
                        begin
                          sIndice := '14' // Mesas abertas
                        end else
                        begin
                          sIndice := '04' // CARTAO TEF
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  szTabelaRelatoriosGerenciais := AnsiString(StringOfChar(' ', 421));
  //iRetorno :=
  EPSON_Obter_Tabela_Relatorios_Gerenciais (PAnsiChar(szTabelaRelatoriosGerenciais));

  //O buffer retornado na variável pszTabelaRelatoriosGerencias, é composto por 20 sequencias de 420 caracteres cada.
  //Cada sequência corresponderá a um dos 20 Relatórios Gerenciais possíveis de serem cadastradas no ECF,
  //totalizando 420 bytes a serem retornados
  Result := '0000';
  while Trim(szTabelaRelatoriosGerenciais) <> '' do
  begin
    sRela :=  Copy(szTabelaRelatoriosGerenciais, 1, 21);
    if Copy(sRela, 1, 2) = sIndice then
    begin
      Result := RightStr(sRela, 4);
      Break;
    end;
    szTabelaRelatoriosGerenciais := StringReplace(szTabelaRelatoriosGerenciais, sRela, '',[rfIgnoreCase]);
  end;
  //ShowMessage('Teste 1 ' + Result);
end;

// --------------------------------------- //
// Contador Geral de Relatorio Gerencial   //
// --------------------------------------- //
function _ecf15_GRG(Pp1: Boolean):String;
var
  szContadores: AnsiString;// 2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));
  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores));//2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );

  _ecf15_codeErro(iRetorno,'');
  {Sandro Silva 2015-08-18 inicio
  Result := Copy(szContadores,36,6);
  }
  Result := Copy(szContadores,37,6);  
end;

// -------------- //
// Contador CDC   //
// -------------- //
function _ecf15_CDC(Pp1: Boolean):String;
var
  szContadores: AnsiString;// 2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));
  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores));//2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );

  _ecf15_codeErro(iRetorno,'');
  {Sandro Silva 2015-08-18 inicio
  Result := Copy(szContadores,24,6);
  }
  Result := Copy(szContadores,25,6);
end;

// -------------- //
// CRO - Contador de Reinício de Operação   //
// -------------- //
function _ecf15_CRO(Pp1: Boolean):String;
begin
  Result := _ecf15_Nmdeintervenestcnicas(True);
end;

// ------------------------------ //
// Cancela um item N              //
// EPSON                          //
// ------------------------------ //
function _ecf15_CancelaItemN(pP1, pP2 : String):Boolean;
begin
  iRetorno := EPSON_Fiscal_Cancelar_Item (PAnsiChar(AnsiString(IntToStr(StrToInt(pP1))))); // 2024-03-05 iRetorno := EPSON_Fiscal_Cancelar_Item (PAnsiChar(IntToStr(StrToInt(pP1))));
  _ecf15_codeErro(iRetorno,'');
  if iRetorno = 0 then Result := True else Result := False;
  // ------------------------------------------------------------------ //
  // A variável iCancelaItenN deve ser incrementada quando a impressora //
  // considera não considera que o item já foi cancelado isso evita um  //
  // problema de cancelar um item na tela e no arquivo e na impressora  //
  // cancelar outro.                                                    //
  // ------------------------------------------------------------------ //
  //
  // Ok Testado 10
  //
end;

// -------------------------------- //
// Abre a gaveta                    //
// EPSON                            //
// -------------------------------- //
function _ecf15_AbreGaveta(Pp1: Boolean):Boolean;
begin
  EPSON_Impressora_Abrir_Gaveta();
  Result := True;
  //
  // Ok Testado 10
  //
end;

// -------------------------------- //
// Status da gaveta                 //
// EPSON                        //
//                                  //
// 000 Gaveta Fechada.              //
// 255 Gaveta Aberta.               //
// 128 Valor atribuido quando não   //
//     tem gaveta.                  //
// -------------------------------- //
function _ecf15_StatusGaveta(Pp1: Boolean):String;
var
  szDados: AnsiString;//2024-03-06 szDados: array[0..20] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 20));
  //
  Sleep(100); // Tem que dar um tempo
  EPSON_Obter_Estado_Impressora(PAnsiChar(szDados));
  //
  if Form1.iStatusGaveta = 0 then
  begin
    if Copy(szDados,8,4) = '0100' then Result := '000' else Result := '255';
  end else
  begin
    if Copy(szDados,8,4) = '0100' then Result := '255' else Result := '000';
  end;
  //
  // Ok Testado 10
  //
end;

// -------------------------------- //
// SAngria                          //
// EPSON                            //
// -------------------------------- //
function _ecf15_Sangria(Pp1: Real):Boolean;
begin
  iRetorno := EPSON_NaoFiscal_Sangria(PAnsiChar(AnsiString(StrZero(pP1*100,8,0))) , 2); // 2024-03-05 iRetorno := EPSON_NaoFiscal_Sangria( PAnsiChar(StrZero(pP1*100,8,0)) , 2);
  _ecf15_codeErro(iRetorno,'');
  Result := True;
  //
  // Ok Testado 10
  //
end;

// -------------------------------- //
// Suprimento                       //
// EPSON                            //
// -------------------------------- //
function _ecf15_Suprimento(Pp1: Real):Boolean;
begin
  iRetorno := EPSON_NaoFiscal_Fundo_Troco(PAnsiChar(AnsiString(StrZero(pP1*100,8,0))), 2); // 2024-03-05 iRetorno := EPSON_NaoFiscal_Fundo_Troco( PAnsiChar(StrZero(pP1*100,8,0)), 2);
  _ecf15_codeErro(iRetorno,'');
  Result := True;
  //
  // Ok Testado 10
  //
end;

// -------------------------------- //
// Nova Aliquota                    //
// EPSON                            //
// -------------------------------- //
function _ecf15_NovaAliquota(Pp1: String):Boolean;
begin
  //
  EPSON_Config_Aliquota(PAnsiChar(AnsiString(Pp1)),false); // 2024-03-05 EPSON_Config_Aliquota(PAnsiChar(Pp1),false);
  Result := True;
  //
  // Ok Testado 10
  //
end;

function _ecf15_LeituraDaMFD(pP1, pP2, pP3: String):Boolean;
//sMfd = '1': Por Data
//sMfd = '2': Por COO
var
  iEspelhos, iAtoCotepe : Integer;
  iRetorno: Integer;
  {
  sNomeBinario: String;
  sNomeBinarioMF: String;
  sNomeBinarioMFD: String;
  }
  sNomeBinario: AnsiString;
  sNomeBinarioMF: AnsiString;
  sNomeBinarioMFD: AnsiString;
  dwTipoEntrada: Integer; //2015-08-19
begin
  Screen.Cursor := crHourGlass; // Cursor normal

  {
  if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then
  begin

    sNomeBinarioMF  := '';
    sNomeBinarioMFD := '';

    if (Form7.sMfd = 'MFPERIODO') then
      sNomeBinarioMF  := pP1;
    if (Form7.sMfd = 'MFDPERIODO') then
      sNomeBinarioMFD := pP1;
    iRetorno := EPSON_Obter_Arquivos_Binarios(PChar(pP2), PChar(pP3), 0, PChar(sNomeBinarioMF), PChar(sNomeBinarioMFD));

    if iRetorno = 0 then
    begin
      Result := True;
      //
    end else
    begin
      _ecf15_codeErro(iRetorno,'');
      Result := False;
    end;

  end
  else
  }
  begin
    if (Form7.sMfd = '2') and (Form7.Label3.Caption = 'COO inicial:') then
    begin
      // Conforme orientação do suporte da Epson
      ShowMessage('Função não suportada pelo modelo de ECF utilizado.');
      Result := True;
    end
    else
    begin

      //
      if Form7.sMfd = '1' then iEspelhos  := 65535 else iEspelhos  := 0;
      if Form7.sMfd = '0' then iAtoCotepe := 1     else iAtocotepe := 2;
      //

      if (Form7.sMfd <> 'MFCOMPLETA') and (Form7.sMfd <> 'MFDCOMPLETA')
        and (Form7.sMfd <> 'MFPERIODO') and (Form7.sMfd <> 'MFDPERIODO') // Sandro Silva 2017-07-31
      then
      begin
        if Form7.Label3.Caption = 'Data inicial:' then
        begin
          //
          pP2   := StrTran(DateToStr(Form7.DateTimePicker1.Date),'/','');
          pP3   := StrTran(DateToStr(Form7.DateTimePicker2.Date),'/','');
          //
          //2024-03-05 iRetorno := EPSON_Obter_Dados_MF_MFD( PAnsiChar(pP2), PAnsiChar(pP3), 0, iEspelhos, iAtoCotepe, 0, 'c:\_EPS');
          iRetorno := EPSON_Obter_Dados_MF_MFD( PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), 0, iEspelhos, iAtoCotepe, 0, PAnsiChar(AnsiString('c:\_EPS')));
          //
        end else
        begin

          pP2   := Form7.MaskEdit1.Text;
          pP3   := Form7.MaskEdit2.Text;

          dwTipoEntrada := 1;
          if Form7.sMfd = '1' then
          begin
            dwTipoEntrada := 2;
            iEspelhos     := 255;
            iAtoCotepe    := 0;
          end;
          //2024-03-05 iRetorno := EPSON_Obter_Dados_MF_MFD(PAnsiChar(pP2), PAnsiChar(pP3), dwTipoEntrada, iEspelhos, iAtoCotepe, 0, 'c:\_EPS');
          iRetorno := EPSON_Obter_Dados_MF_MFD(PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), dwTipoEntrada, iEspelhos, iAtoCotepe, 0, PAnsiChar(AnsiString('c:\_EPS')));
        end;
        //
        if iRetorno = 0 then
        begin
          //
          if Form7.sMfd = '2' then
          begin
            CopyFile('c:\_EPS_CTP.txt',pchar(Form1.SaveDialog1.FileName), False);
          end else
          begin
            CopyFile('c:\_EPS_ESP.txt',pchar(Form1.SaveDialog1.FileName), False);
          end;

          ShowMessage('O arquivo '+AllTrim(Form1.SaveDialog1.FileName)+' foi gravado na pasta: '+Form1.sAtual);

          Result := True;
          //
        end else
        begin
          _ecf15_codeErro(iRetorno,'');
          Result := False;
        end;
        //
      end
      else
      begin
        DeleteFile(pchar(pP1));
        Sleep(10);
        //
        DeleteFile(pchar('c:\_EPS_ESP.txt'));
        Sleep(10);
        //

        if (Form7.sMfd = 'MFDCOMPLETA') then
        begin // MFD
          //iRetorno :=
          {2024-03-05
          EPSON_Config_Dados_PAFECF(PAnsiChar(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF)),
                                    PAnsiChar(LimpaNumero(IE_SOFTWARE_HOUSE_PAF)),
                                    PAnsiChar(IM_SOFTWARE_HOUSE_PAF),
                                    // 2015-09-08 PAnsiChar(Copy('Smallsoft Tecnologia em Informática EIRELI', 1, 40)),
                                    PAnsiChar(Copy(Form1.sRazaoSocialSmallsoft, 1, 40)),
                                    PAnsiChar('FRENTE.EXE'),
                                    PAnsiChar(Build),
                                    PAnsiChar(MD5File(PAnsiChar('FRENTE.EXE'))),
                                    PAnsiChar(VERSAO_ER_PAF_ECF));
          sNomeBinario    := Form1.SaveDialog1.FileName;
          sNomeBinarioMF  := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MF', [rfReplaceAll]);
          sNomeBinarioMFD := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MFD', [rfReplaceAll]);

          iRetorno := EPSON_Obter_Arquivo_Binario_MFD(PAnsiChar(sNomeBinarioMFD));
          }
          EPSON_Config_Dados_PAFECF(PAnsiChar(AnsiString(LimpaNumero(CNPJ_SOFTWARE_HOUSE_PAF))),
                                    PAnsiChar(AnsiString(LimpaNumero(IE_SOFTWARE_HOUSE_PAF))),
                                    PAnsiChar(AnsiString(IM_SOFTWARE_HOUSE_PAF)),
                                    // 2015-09-08 PAnsiChar(Copy('Smallsoft Tecnologia em Informática EIRELI', 1, 40)),
                                    PAnsiChar(AnsiString(Copy(Form1.sRazaoSocialSmallsoft, 1, 40))),
                                    PAnsiChar(AnsiString('FRENTE.EXE')),
                                    PAnsiChar(AnsiString(Build)),
                                    PAnsiChar(AnsiString(MD5File(PAnsiChar('FRENTE.EXE')))),
                                    PAnsiChar(AnsiString(VERSAO_ER_PAF_ECF)));
          sNomeBinario    := Form1.SaveDialog1.FileName;
          sNomeBinarioMF  := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MF', [rfReplaceAll]);
          sNomeBinarioMFD := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MFD', [rfReplaceAll]);

          iRetorno := EPSON_Obter_Arquivo_Binario_MFD(PAnsiChar(AnsiString(sNomeBinarioMFD)));

          if iRetorno = 0 then
          begin

            Result := True;
            //
          end else
          begin
            _ecf15_codeErro(iRetorno,'');
            Result := False;
          end;

          //
        end
        else
        begin // MF
          //iRetorno :=
          // Sandro Silva 2017-09-05  dwTipoEntrada := 1; // COO
          {Sandro Silva 2017-08-24 inicio
          if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then// Sandro Silva 2017-08-24  if (Form7.sMfd = 'MFPERIODO') and (Form7.sMfd = 'MFDPERIODO') then// Sandro Silva 2017-07-31
          begin
            dwTipoEntrada := 0; // Data
            if (Form7.sMfd = 'MFPERIODO') then
              iAtoCotepe := 1;
            if (Form7.sMfd = 'MFDPERIODO') then
              iAtoCotepe := 2;
          end;

          iRetorno := EPSON_Obter_Dados_MF_MFD( PAnsiChar(pP2), PAnsiChar(pP3), dwTipoEntrada, iEspelhos, iAtoCotepe, 0, PAnsiChar('c:\_EPS'));
          sNomeBinario    := Form1.SaveDialog1.FileName;
          sNomeBinarioMF  := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MF', [rfReplaceAll]);
          sNomeBinarioMFD := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MFD', [rfReplaceAll]);

          if (Form7.sMfd = 'MFDPERIODO') then
            iRetorno :=   EPSON_Obter_Arquivo_Binario_MFD(PAnsiChar(sNomeBinarioMFD))
          else // MFCOMPLETA ou MFPERIODO
            iRetorno :=   EPSON_Obter_Arquivo_Binario_MF(PAnsiChar(sNomeBinarioMF));
          }
          sNomeBinario    := Form1.SaveDialog1.FileName;
          sNomeBinarioMF  := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MF', [rfReplaceAll]);
          sNomeBinarioMFD := StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MFD', [rfReplaceAll]);

          if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then// Sandro Silva 2017-08-24  if (Form7.sMfd = 'MFPERIODO') and (Form7.sMfd = 'MFDPERIODO') then// Sandro Silva 2017-07-31
          begin
            // Sandro Silva 2017-08-24 Suporte EPSON - Pedro orientou que nenhum ECF EPSON gera binários por período

            //sNomeBinarioMF  := ExtractFilePath(sNomeBinarioMF) + 'LOG_DOWNLOADMF.MF'; // StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MF', [rfReplaceAll]);
            //sNomeBinarioMFD := ExtractFilePath(sNomeBinarioMF) + 'LOG_DOWNLOADMF.MFD'; // StringReplace(ExtractFilePath(Form1.SaveDialog1.FileName) + ExtractFileName(Form1.SaveDialog1.FileName), ExtractFileExt(Form1.SaveDialog1.FileName), '.MFD', [rfReplaceAll]);

            iRetorno := 1;
          end
          else
          begin
            iRetorno :=   EPSON_Obter_Arquivo_Binario_MF(PAnsiChar(AnsiString(sNomeBinarioMF))); // 2024-03-06 iRetorno :=   EPSON_Obter_Arquivo_Binario_MF(PAnsiChar(sNomeBinarioMF));
          end;
          {Sandro Silva 2017-08-24 final}


          if iRetorno = 0 then
          begin
            Result := True;
            //
          end else
          begin
            if (Form7.sMfd = 'MFPERIODO') or (Form7.sMfd = 'MFDPERIODO') then // Sandro Silva 2017-07-31
            begin

            end
            else
            begin
              _ecf15_codeErro(iRetorno,'');
            end;
            Result := False;
          end;

          //
        end;
      end;
    end;
  end;
  Screen.Cursor := crDefault; // Cursor normal
end;

function _ecf15_LeituraMemoriaFiscal(pP1, pP2: String):Boolean;
var
  iTamBuff: DWord;
  pszDados: AnsiString;// Sandro Silva 2024-03-05 array[0..1024] of AnsiChar;
begin
  //pszDados := AnsiString(StringOfChar(' ', 1024));
  if Form1.sTipo = 'c' then
  begin
    if Length(pP1) = 6 then
    begin
      //Sandro Silva 2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(Copy(pP1,1,4)+'20'+Copy(pP1,5,2)), PAnsiChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)), 1+4, pszDados,'teste.txt', @iTamBuff, 1024); // 3 Por data Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(AnsiString(Copy(pP1,1,4)+'20'+Copy(pP1,5,2))), PAnsiChar(AnsiString(Copy(pP2,1,4)+'20'+Copy(pP2,5,2))), 1+4, PAnsiChar(pszDados),'teste.txt', @iTamBuff, 1024); // 3 Por data Simplifcado 4 Imprimir
    end else
    begin
      // 2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(pP1), PAnsiChar(pP2), 0+4, pszDados,'teste.txt', @iTamBuff, 1024); // 3 Por intervalo de redz Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), 0+4, PAnsiChar(pszDados),'teste.txt', @iTamBuff, 1024); // 3 Por intervalo de redz Simplifcado 4 Imprimir
    end;
  end else
  begin
    if Length(pP1) = 6 then
    begin
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(Copy(pP1,1,4)+'20'+Copy(pP1,5,2)), PAnsiChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)), 3+4, pszDados,'teste.txt', @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(AnsiString(Copy(pP1,1,4)+'20'+Copy(pP1,5,2))), PAnsiChar(AnsiString(Copy(pP2,1,4)+'20'+Copy(pP2,5,2))), 3+4, PAnsiChar(pszDados),'teste.txt', @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
    end else
    begin
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(pP1), PAnsiChar(pP2), 2+4, pszDados,'teste.txt', @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), 2+4, PAnsiChar(pszDados), 'teste.txt', @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
    end;
  end;
  Result := True;
end;


// -------------------------------- //
// Venda do Item                    //
// EPSON                            //
// -------------------------------- //
function _ecf15_VendaDeItem(pP1, pP2, pP3, pP4, pP5, pP6, pP7, pP8: String):Boolean;
var
  bPadraoArrendondar: Boolean;
begin
  // ---------------------------- //
  // pP1 -> Código     13 dígitos //
  // pP2 -> Descricão  29 dígitos //
  // pP3 -> ST          2 dígitos //
  // pP4 -> Quantidade  7 dígitos //
  // pP5 -> Unitário    7 dígitos //
  // pP6 -> Medida      2 dígitos //
  // ---------------------------- //
  if (Copy(pP3,1,1) <> 'I') and (Copy(pP3,1,1) <> 'F') and (Copy(pP3,1,1) <> 'N') then
  begin

    {Sandro Silva 2018-05-07 inicio
    if Form1.bISS then pP3 := 'Sa' else pP3 := 'T'+Chr(96+StrToInt(pP3));
    // Sandro Silva 2017-02-16  if Form1.ibDataSet4.FieldByname('ST').AsString = 'SVC' then
    if Form1.ibDataSet4.FieldByname('TIPO_ITEM').AsString = '09' then
    begin
      pP3 := 'Sa';
    end;
    }

    if (AnsiContainsText(Form1.sModeloFabricante, 'T800') = False) and (AnsiContainsText(Form1.sModeloFabricante, 'T900') = False) then
    begin  // ECF convênio 85/01

      if Form1.bISS then pP3 := 'Sa' else pP3 := 'T'+Chr(96+StrToInt(pP3));

      if Form1.ibDataSet4.FieldByname('TIPO_ITEM').AsString = '09' then
      begin
        pP3 := 'Sa';
      end;

    end
    else
    begin // ECF convênio 09/09
      if Form1.bISS then
      begin
        pP3 := 'S' + Chr(96 + StrToInt(Form1.sOrdemAliquotaISS))
      end
      else
      begin
        pP3 := 'T'+Chr(96+StrToInt(pP3));
      end;
    end; // if (AnsiContainsText(Form1.sModeloFabricante, 'T800') = False) and (AnsiContainsText(Form1.sModeloFabricante, 'T900') = False) then
    {Sandro Silva 2018-05- fim}
  end; // if (Copy(pP3,1,1) <> 'I') and (Copy(pP3,1,1) <> 'F') and (Copy(pP3,1,1) <> 'N') then
  //
  // Quando for ISS não pode ser T tem que ser S
  //
  if Copy(pP3,1,1) = 'I' then pP3 := 'I';     // isenção
  if Copy(pP3,1,1) = 'F' then pP3 := 'F';     // não incidência
  if Copy(pP3,1,1) = 'N' then pP3 := 'N';     // Substituição
  //
  pP5 := Copy('000',1,3 - StrToInt(Form1.ConfPreco)) + pP5;
  //
{
  if StrToInt(Form1.ConfPreco) = 3 then
  begin
    pP5 := '0'+copy(pP5,1,6);
    pP4 := copy(pP4,2,6)+'0';
  end;
  //
  // ShowMessage(PAnsiChar(Copy(pP4,1,7)));
  //
  iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(pP5), 2,PAnsiChar(pP3), 2);
}
  {Sandro Silva 2018-10-08 inicio
  if StrToInt(Form1.ConfPreco) = 3 then
  begin
     iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(StrZero(Form1.ibDataSet4PRECO.AsFloat*1000,7,0)) , 3,PAnsiChar(pP3), 2);
  end else
  begin
    iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(pP5), 2,PAnsiChar(pP3), 2);
  end;
  }
  bPadraoArrendondar := LerParametroIni('frente.ini', 'Frente de caixa', 'Epson Truncar Item', 'Não') = 'Não'; // Configuração "Não" arredonda; "Sim" trunca

  // ECF do convênio 85/01 não permitem uso do método EPSON_Fiscal_Vender_Item_AD() para vender serviço
  // Para ECF do convênio 85/01 o arredondamento é configurado durante a lacração
  if (AnsiContainsText(Form1.sModeloFabricante, 'T800') = False) and (AnsiContainsText(Form1.sModeloFabricante, 'T900') = False) then
    bPadraoArrendondar := False;

  if bPadraoArrendondar = False {LerParametroIni('frente.ini', 'Frente de caixa', 'Epson Truncar Item', 'Não') = 'Sim'} then  //Resolver problema da TM-T900F que não permite configurar truncamento ou arredondamento para o total do item
  begin

    // Para ECF do convênio 85/01 EPSON_Fiscal_Vender_Item() vai vender conforme feito a lacração (arredondando ou truncando)
    // Para ECF do convênio 09/09 EPSON_Fiscal_Vender_Item() vai sempre truncar

    // Para ECF do convênio 85/01 deve sempre usar o método EPSON_Fiscal_Vender_Item()

    if StrToInt(Form1.ConfPreco) = 3 then
    begin
       // 2024-03-05 iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(StrZero(Form1.ibDataSet4PRECO.AsFloat*1000,7,0)) , 3,PAnsiChar(pP3), 2);
       iRetorno := EPSON_Fiscal_Vender_Item(PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Copy(pP4,1,7))), 3, PAnsiChar(AnsiString(pP6)), PAnsiChar(AnsiString(StrZero(Form1.ibDataSet4PRECO.AsFloat*1000,7,0))) , 3,PAnsiChar(AnsiString(pP3)), 2);
    end else
    begin
      //2024-03-05 iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(pP5), 2,PAnsiChar(pP3), 2);
      iRetorno := EPSON_Fiscal_Vender_Item( PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Copy(pP4,1,7))), 3, PAnsiChar(AnsiString(pP6)), PAnsiChar(AnsiString(pP5)), 2,PAnsiChar(AnsiString(pP3)), 2);
    end;

  end
  else
  begin
    {Sandro Silva 2018-10-10 inicio
    if pP3 = 'Sa' then
      pP3 := 'S' + Chr(96 + StrToInt(Form1.sOrdemAliquotaISS));
    {Sandro Silva 2018-10-10 fim}

    // EPSON_Fiscal_Vender_Item_AD() permite informar se deve truncar ou arredondar o total do item  (dwArredondaTrunca: 1 – Trunca. 2 - Arredonda.)
    // Não conseguimos vender serviço usando este método
    // Definido para sempre vender arredondando. Parâmetro dwArredondaTrunca = 2
    if StrToInt(Form1.ConfPreco) = 3 then
    begin
      //2024-03-05 iRetorno := EPSON_Fiscal_Vender_Item_AD( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(StrZero(Form1.ibDataSet4PRECO.AsFloat*1000,7,0)), 3, PAnsiChar(pP3), 2, 2, 2);
      iRetorno := EPSON_Fiscal_Vender_Item_AD( PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Copy(pP4,1,7))), 3, PAnsiChar(AnsiString(pP6)), PAnsiChar(AnsiString(StrZero(Form1.ibDataSet4PRECO.AsFloat*1000,7,0))), 3, PAnsiChar(AnsiString(pP3)), 2, 2, 2);
    end else
    begin
      //2024-03-05 iRetorno := EPSON_Fiscal_Vender_Item_AD( PAnsiChar(pP1), PAnsiChar(pP2), PAnsiChar(Copy(pP4,1,7)), 3, PAnsiChar(pP6), PAnsiChar(pP5), 2,PAnsiChar(pP3), 2, 2, 2);
      iRetorno := EPSON_Fiscal_Vender_Item_AD( PAnsiChar(AnsiString(pP1)), PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(Copy(pP4,1,7))), 3, PAnsiChar(AnsiString(pP6)), PAnsiChar(AnsiString(pP5)), 2,PAnsiChar(AnsiString(pP3)), 2, 2, 2);
    end;
  end;
  {Sandro Silva 2018-10-08 fim}


  //
  _ecf15_codeErro(iRetorno,'');
  //
  REsult := True;
  //
  {2024-03-05
  if (StrToInt(pP8) <> 0) then EPSON_Fiscal_Desconto_Acrescimo_Item( PAnsiChar(pP8), 2, True, False);
  if (StrToInt(pP7) <> 0) then EPSON_Fiscal_Desconto_Acrescimo_Item( PAnsiChar(pP7), 2, True, True);
  }
  if (StrToInt(pP8) <> 0) then EPSON_Fiscal_Desconto_Acrescimo_Item( PAnsiChar(AnsiString(pP8)), 2, True, False);
  if (StrToInt(pP7) <> 0) then EPSON_Fiscal_Desconto_Acrescimo_Item( PAnsiChar(AnsiString(pP7)), 2, True, True);
  //
end;

// -------------------------------- //
// Reducao Z                        //
// EPSON                            //
// -------------------------------- //
function _ecf15_ReducaoZ(pP1: Boolean):Boolean;
var
  //2024-03-05 szCRZ: array[0..5] of AnsiChar;
  szCRZ: AnsiString;
begin
  szCRZ := AnsiString(StringOfChar(' ', 5));
  //
//  iRetorno := EPSON_RelatorioFiscal_ReducaoZ(PAnsiChar(DateToStr(Date)),PAnsiChar(TimeToStr(Time)),'',szCRZ );
  iRetorno := EPSON_RelatorioFiscal_RZ('','','', PAnsiChar(szCRZ)); //2024-03-05 iRetorno := EPSON_RelatorioFiscal_RZ('','','',szCRZ );
  _ecf15_codeErro(iRetorno,'');
  Result := True;
  //
end;

// -------------------------------- //
// Leitura X                        //
// EPSON                            //
// -------------------------------- //
function _ecf15_LeituraX(pP1: Boolean):Boolean;
begin
  iRetorno := EPSON_RelatorioFiscal_LeituraX();
  _ecf15_codeErro(iRetorno,'');
  // 2015-10-08 Result := True;
  if iRetorno = 0 then
    Result := True
  else
    Result := False;
end;

// ---------------------------------------------- //
// Retorna se o horario de verão está selecionado //
// EPSON                                          //
// ---------------------------------------------- //
function _ecf15_RetornaVerao(pP1: Boolean):Boolean;
var
  Estado: Integer; //Sandro Silva 2024-03-05 bEstado: Boolean;
begin
  Estado := 0;
  EPSON_Obter_Estado_Horario_Verao(Estado); // Sandro Silva 2024-03-05 EPSON_Obter_Estado_Horario_Verao(@bEstado);
  Result := (Estado = 1);
end;

// -------------------------------- //
// Liga ou desliga horário de verao //
// EPSON                            //
// -------------------------------- //
function _ecf15_LigaDesLigaVerao(pP1: Boolean):Boolean;
{
var
  bEstado: Boolean;
  szCRZ: array[0..5] of AnsiChar;
}
begin
  EPSON_Config_Horario_Verao();
  {
  EPSON_Obter_Estado_Horario_Verao(@bEstado);
  Result := bEstado;
  if Result then EPSON_RelatorioFiscal_ReducaoZ('','','0',szCRZ )
    else EPSON_RelatorioFiscal_ReducaoZ('','','1',szCRZ );
  }
  Result := True;
end;

// -------------------------------- //
// Retorna a versão do firmware     //
// EPSON                            //
// -------------------------------- //
function _ecf15_VersodoFirmware(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-05 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  //
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := Copy(AllTrim(szDados),100,8);
   _ecf15_codeErro(iRetorno,Estado);
  //
end;

// -------------------------------- //
// Retorna o número de série        //
// EPSON                            //
// -------------------------------- //
function _ecf15_NmerodeSrie(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-05 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  //
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := Copy(AllTrim(szDados),0,20);
   _ecf15_codeErro(iRetorno,Estado);
  //
end;

// -------------------------------- //
// Retorna o CGC e IE               //
// EPSON                            //
// -------------------------------- //
function _ecf15_CGCIE(pP1: Boolean): String;
var
  szDadosUsuario: AnsiString;//2024-03-06 szDadosUsuario: array[0..50] of AnsiChar;
begin
  szDadosUsuario := AnsiString(StringOfChar(' ', 50));
  EPSON_Obter_Dados_Usuario (PAnsiChar(szDadosUsuario)); // 2024-03-06 EPSON_Obter_Dados_Usuario ( szDadosUsuario );
  Result := szDadosUsuario;
end;

// --------------------------------- //
// Retorna o número de cancelamentos //
// EPSON                             //
// --------------------------------- //
function _ecf15_Cancelamentos(pP1: Boolean): String;
var
  szCancelado: AnsiString;//2024-03-06 szCancelado: array[0..51] of AnsiChar;
begin
  szCancelado := AnsiString(StringOfChar(' ', 51));

  iRetorno := EPSON_Obter_Total_Cancelado(PAnsiChar(szCancelado));// 2024-03-05 iRetorno := EPSON_Obter_Total_Cancelado( szCancelado );
  _ecf15_codeErro(iRetorno,'');
//000000000000000090000000000000000000000000000000000
  Result := Copy(szCancelado,1,17);
end;

// -------------------------------- //
// Retorna o valor de descontos     //
// EPSON                            //
// -------------------------------- //
function _ecf15_Descontos(pP1: Boolean): String;
var
  szTotalDescontos: AnsiString;//2024-03-06 szTotalDescontos: array[0..51] of AnsiChar;
begin
  szTotalDescontos := AnsiString(StringOfChar(' ', 51));

  iRetorno := EPSON_Obter_Total_Descontos(PAnsiChar(szTotalDescontos)); // 2024-03-06 iRetorno := EPSON_Obter_Total_Descontos( szTotalDescontos );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szTotalDescontos,1,17);
end;

// -------------------------------- //
// Retorna o contados sequencial    //
// EPSON                            //
// -------------------------------- //
function _ecf15_ContadorSeqencial(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,1,6);
end;

// -------------------------------- //
// Retorna o número de operações    //
// não fiscais acumuladas           //
// EPSON                            //
// -------------------------------- //
function _ecf15_Nmdeoperaesnofiscais(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,31,6);
end;

function _ecf15_NmdeCuponscancelados(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,49,6);
end;

function _ecf15_NmdeRedues(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,7,6);
end;

function _ecf15_Nmdeintervenestcnicas(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,13,6);
end;

function _ecf15_Nmdesubstituiesdeproprietrio(pP1: Boolean): String;
var
  szContadores: AnsiString;//2024-03-06 szContadores: array[0..100] of AnsiChar;
begin
  szContadores := AnsiString(StringOfChar(' ', 100));

  iRetorno := EPSON_Obter_Contadores(PAnsiChar(szContadores)); // 2024-03-06 iRetorno := EPSON_Obter_Contadores( szContadores );
  _ecf15_codeErro(iRetorno,'');
  Result := Copy(szContadores,13,6);
end;

function _ecf15_Clichdoproprietrio(pP1: Boolean): String;
var
  szUsuario: AnsiString;//2024-03-06 szUsuario: array[0..160] of AnsiChar;
begin
  szUsuario := AnsiString(StringOfChar(' ', 160));
  iRetorno := EPSON_Obter_Cliche_Usuario(PAnsiChar(szUsuario));//2024-03-06 EPSON_Obter_Cliche_Usuario( szUsuario );
  Result := szUsuario;
end;

// ------------------------------------ //
// Importante retornar apenas 3 dígitos //
// Ex: 001                              //
// EPSON                                //
// ------------------------------------ //
function _ecf15_NmdoCaixa(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..10] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 10));
  EPSON_Obter_Numero_ECF_Loja(PAnsiChar(szDados));//2024-03-06 EPSON_Obter_Numero_ECF_Loja(szDados);
  Result := Copy(sZDados,1,3);
end;

function _ecf15_Nmdaloja(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..10] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 10));
  EPSON_Obter_Numero_ECF_Loja(PansiChar(szDados)); // 2024-03-06 EPSON_Obter_Numero_ECF_Loja(szDados);
  Result := Copy(sZDados,4,4);
end;

function _ecf15_Moeda(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..10] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 5));

  EPSON_Obter_Simbolo_Moeda(PAnsiChar(szDados));//2024-03-06 EPSON_Obter_Simbolo_Moeda(szDados);
  Result := Copy(AllTrim(szDados),1,1);
end;

// ----------------------------------------- //
// Dia + Mês + Ano + Hora + Minuto + Segundo //
// Ex: 26091976200000                        //
// ----------------------------------------- //
function _ecf15_Dataehoradaimpressora(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados: array[0..15] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 15));
  EPSON_Obter_Hora_Relogio(PAnsiCHar(sZDados));// 2024-03-06 EPSON_Obter_Hora_Relogio(sZDados);
  Result := Copy(sZDados,1,4)+Copy(sZDados,7,8);        // Retorna o ano com 4 digitos no sistema assume 2 Ex: 310507
end;

function _ecf15_Datadaultimareduo(pP1: Boolean): String;
{
var
  sZDados: array[0..70] of AnsiChar;
begin
  EPSON_Obter_Dados_Jornada(sZDados);
  Result := Copy(sZDados,40,6); // Retorna o número da última RZ
}
var
  sDadosUltimaZ: String;
begin
  Result := '00/00/2000';
  try
    sDadosUltimaZ := _ecf15_DadosDaUltimaReducao(True);
    Result := FormatDateTime('dd/mm/yyyy', StrToDate(Copy(sDadosUltimaZ, 1, 2) + '/' + Copy(sDadosUltimaZ, 3, 2) + '/' + Copy(sDadosUltimaZ, 5, 2)));
  except
    Result := '00/00/2000';
  end;
end;

function _ecf15_Datadomovimento(pP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados: array[0..15] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 15));
  EPSON_Obter_Data_Hora_Jornada(PansiChar(sZDados)); // 2024-03-06 EPSON_Obter_Data_Hora_Jornada(sZDados);
  Result := Copy(sZDados,1,4)+Copy(sZDados,7,8);        // Retorna o ano com 4 digitos no sistema assume 2 Ex: 310507
end;

// Deve retornar uma String com:                                          //
// Os 2 primeiros dígitos são o número de aliquotas gravadas: Ex 16       //
// os póximos de 4 em 4 são as aliquotas Ex: 1800                         //
// Ex: 161800120005000000000000000000000000000000000000000000000000000000 //
function _ecf15_RetornaAliquotas(pP1: Boolean): String;
var
  szAliquotas: AnsiString;//2024-03-06 sZAliquotas: array[0..553] of AnsiChar;
  I : Integer;
begin
  szAliquotas := AnsiString(StringOfChar(' ', 553));
  //
  iRetorno := EPSON_Obter_Tabela_Aliquotas(PAnsiChar(sZaliquotas)); // 2024-03-06 iRetorno := EPSON_Obter_Tabela_Aliquotas( sZaliquotas );

  //ShowMessage(sZAliquotas);

  Result := '16';
  for I := 1 to (Length(sZaliquotas) div 23) do
  begin
    Result := Result + Copy(sZaliquotas,3+(I*23)-23,4);
  end;
  //
  Result := Strtran(Copy(Result + '0000000000000000000000000000000000000000000000000000000000000000',1,66),' ','0');
  _ecf15_codeErro(iRetorno,'');
  //
end;

function _ecf15_Vincula(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf15_FlagsDeISS(pP1: Boolean): String;
begin
  Result := Chr(0)+chr(0);
end;

function _ecf15_FechaPortaDeComunicacao(pP1: Boolean): Boolean;
begin
  iRetorno := EPSON_Serial_Fechar_Porta();
  Result := True;
end;

function _ecf15_MudaMoeda(pP1: String): Boolean;
begin
  Result := True;
end;

function _ecf15_MostraDisplay(pP1: String): Boolean;
begin
  Result := True;
end;


function _ecf15_leituraMemoriaFiscalEmDisco(pP1, pP2, pP3: String): Boolean;
var
  iTamBuff: DWord;
  //2024-03-05 pszDados: array[0..1024] of AnsiChar;
  pszDados: AnsiString;
begin

  pszDados := AnsiString(StringOfChar(' ', 1024));
  if Form1.sTipo = 'c' then
  begin
    if Length(pP2) = 6 then
    begin
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)), PAnsiChar(Copy(pP3,1,4)+'20'+Copy(pP3,5,2)), 1+16, pszDados,PAnsiChar(pP1), @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(AnsiString(Copy(pP2,1,4)+'20'+Copy(pP2,5,2))), PAnsiChar(AnsiString(Copy(pP3,1,4)+'20'+Copy(pP3,5,2))), 1+16, PAnsiChar(pszDados), PAnsiChar(AnsiString(pP1)), @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
    end else
    begin
      if StrToInt(pP3) > StrToInt(_ecf15_NmdeRedues(True)) then pP3 := StrZero(StrToInt(_ecf15_NmdeRedues(True)),4,0);
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(pP2), PAnsiChar(pP3), 0+16, pszDados,PAnsiChar(pP1), @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF(PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), 0+16, PansiChar(pszDados), PAnsiChar(AnsiString(pP1)), @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
    end;
  end else
  begin
    if Length(pP2) = 6 then
    begin
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(Copy(pP2,1,4)+'20'+Copy(pP2,5,2)), PAnsiChar(Copy(pP3,1,4)+'20'+Copy(pP3,5,2)), 3+16, pszDados,PAnsiChar(pP1), @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF(PAnsiChar(AnsiString(Copy(pP2,1,4)+'20'+Copy(pP2,5,2))), PAnsiChar(AnsiString(Copy(pP3,1,4)+'20'+Copy(pP3,5,2))), 3+16, PAnsiChar(pszDados),PAnsiChar(AnsiString(pP1)), @iTamBuff, 1024 ); // 3 Por data Simplifcado 4 Imprimir
    end else
    begin
      if StrToInt(pP3) > StrToInt(_ecf15_NmdeRedues(True)) then pP3 := StrZero(StrToInt(_ecf15_NmdeRedues(True)),4,0);
      //2024-03-05 iRetorno := EPSON_RelatorioFiscal_Leitura_MF( PAnsiChar(pP2), PAnsiChar(pP3), 2+16, pszDados,PAnsiChar(pP1), @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
      iRetorno := EPSON_RelatorioFiscal_Leitura_MF(PAnsiChar(AnsiString(pP2)), PAnsiChar(AnsiString(pP3)), 2+16, PAnsiChar(pszDados), PAnsiChar(AnsiString(pP1)), @iTamBuff, 1024 ); // 3 Por intervalo de redz Simplifcado 4 Imprimir
    end;
  end;
  _ecf15_codeErro(iRetorno,'');
  Result := True;
  //
  // Ok Teste 10
  //
end;

function _ecf15_CupomNaoFiscalVinculado(sP1: String; iP2: Integer ): Boolean;
var
  J, I : Integer;
begin
  Result := False; // Sandro Silva 2016-04-12
  //
  begin
    //
    Sleep(500);
    //
    {2024-03-05
    if Form1.ibDataSet25PAGAR.AsFloat >      0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(Copy(sCartao ,2,1)), PAnsiChar(StrZero(Form1.ibDataSet25PAGAR.AsFloat        * 100,13,0)),2,'1'); // Cartao
    if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(Copy(sPrazo  ,2,1)), PAnsiChar(StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat   * 100,13,0)),2,'1'); // A prazo
    if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(Copy(sCheque ,2,1)), PAnsiChar(StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat   * 100,13,0)),2,'1'); // Cheque
    }
    if Form1.ibDataSet25PAGAR.AsFloat >      0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(AnsiString(Copy(sCartao ,2,1))), PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25PAGAR.AsFloat        * 100,13,0))),2,'1'); // Cartao
    if Form1.ibDataSet25DIFERENCA_.AsFloat > 0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(AnsiString(Copy(sPrazo  ,2,1))), PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25DIFERENCA_.AsFloat   * 100,13,0))),2,'1'); // A prazo
    if Form1.ibDataSet25ACUMULADO1.AsFloat > 0 then iRetorno := EPSON_NaoFiscal_Abrir_CCD(PAnsiChar(AnsiString(Copy(sCheque ,2,1))), PAnsiChar(AnsiString(StrZero(Form1.ibDataSet25ACUMULADO1.AsFloat   * 100,13,0))),2,'1'); // Cheque

    //
    J := 1;
    for I := 1 to Length(sP1) do
    begin
      if iRetorno = 0 then
      begin
        if (Copy(sP1,I,1) = Chr(10)) or (I-J>=55) then // Linha pode ter no maximo 55 caracteres;
        begin
          iRetorno := EPSON_NaoFiscal_Imprimir_Linha (PAnsiChar(AnsiString(Copy(sP1,J,I-J)))); // 2024-03-05 iRetorno := EPSON_NaoFiscal_Imprimir_Linha (PAnsiChar(Copy(sP1,J,I-J)));
          J := I + 1;
        end;
      end;
    end;
    //
    if iRetorno = 0 then iRetorno:= EPSON_NaoFiscal_Fechar_CCD(True);

    if iRetorno = 0 then
      Result := True;
    //
  end;
  //
end;

function _ecf15_ImpressaoNaoSujeitoaoICMS(sP1: String): Boolean;
var
  I, iI : Integer;
  sLinha : String;
begin
  //
  begin
    //
    if Pos('IDENTIFICAÇÃO DO PAF-ECF',sP1)<>0 then
    begin
      iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('2'); // Identificação do PAF
    end else
    begin
      if Pos('Período Solicitado: de',sP1)<>0 then
      begin
        iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('5'); // Meios de pagamento
      end else
      begin
        if (Pos('Documento: ',sP1)<>0) or (Pos(TITULO_PARCELAS_CARNE_RESUMIDO, sP1) > 0) then  // Sandro Silva 2018-04-29  if Pos('Documento: ',sP1)<>0 then
        begin
          iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('3'); // Venda a prazo
        end else
        begin
          if Pos('DAV EMITIDOS',sP1)<>0 then
          begin
            iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('6'); // DAV Emitidos
          end else
          begin
            if Pos('AUXILIAR DE VENDA (DAV) - OR',sP1)<>0 then
            begin
              iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('7'); // Orçamento (DAV)
            end else
            begin
              if Pos('CONFERENCIA DE CONTA',sP1)<>0 then
              begin
                iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('8'); // Conferencia de contas
              end else
              begin
                if Pos('TRANSFERENCIAS ENTRE CONTA',sP1)<>0 then
                begin
                  iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('9'); // Transferencia entre contas
                end else
                begin
                  // Sandro Silva 2016-02-04 POLIMIG  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0) or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0) or (Pos('NENHUMA',sP1)<>0) then
                  if (Pos('CONTAS DE CLIENTES ABERTAS',sP1)<>0)
                    or (Pos('CONTAS DE CLIENTES OS ABERTAS',sP1)<>0)
                    or ((Pos('NENHUMA',sP1)<>0) and (Pos('CONTA DE CLIENTE',sP1)<>0)) then
                  begin
                    iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('10'); // Mesas Contas
                  end else
                  begin
                    if Pos('CONFERENCIA DE MESA',sP1)<>0 then
                    begin
                      iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('11'); // Conferencia de Mesas
                    end else
                    begin
                      if Pos('TRANSFERENCIAS ENTRE MESA',sP1)<>0 then
                      begin
                        iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('12'); // Transferencia entre contas
                      end else
                      begin
                        // Sandro Silva 2016-02-04 POLIMIG  if Pos('MESAS ABERTAS',sP1)<>0 then
                        if (Pos('MESAS ABERTAS',sP1)<>0) or
                         (Pos('NENHUMA MESA',sP1)<>0) then
                        begin
                          iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('13'); // Mesas abertas
                        end else
                        begin
                          if Pos('Parametros de Configuracao',sP1)<>0 then
                          begin
                            iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('14'); // Mesas abertas
                          end else
                          begin
                            iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('4'); // CARTAO TEF
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    //
    // iRetorno := EPSON_NaoFiscal_Abrir_Relatorio_Gerencial('1');
    //
    for iI := 1 to 1 do
    begin
      //
      sLinha := '';
      //
      for I := 1 to Length(sP1) do
      begin
        //
        if iRetorno = 0 then
        begin
          if (Copy(sP1,I,1) = chr(10)) or ( Length(sLinha) >=55 ) then // Linha pode ter no maximo 55 caracteres;
          begin
            //
            if (Copy(sP1,I,1) <> chr(10)) then sLinha := sLinha+Copy(sP1,I,1);
            //
            if sLinha = '' then sLinha := ' ';
            iRetorno  := EPSON_NaoFiscal_Imprimir_Linha(PAnsiChar(AnsiString(sLinha))); //2024-03-05 iRetorno  := EPSON_NaoFiscal_Imprimir_Linha(PAnsiChar(sLinha));
            sLinha    := '';
            //
          end else
          begin
            //
            sLinha := sLinha+Copy(sP1,I,1);
            //
          end;
        end;
      end;
      //
      for I := 1 to 3 do if iRetorno = 0 then iRetorno := EPSON_NaoFiscal_Imprimir_Linha(PAnsiChar(AnsiString('           '))); // 2024-03-05 for I := 1 to 3 do if iRetorno = 0 then iRetorno := EPSON_NaoFiscal_Imprimir_Linha(PAnsiChar('           '));
      //
    end;
    //
    if iRetorno = 0 then iRetorno:= EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(True);
    if iRetorno = 0 then Result := True else Result := False;
    //
  end;
  //
end;

function _ecf15_FechaCupom2(sP1: Boolean): Boolean;
begin
  EPSON_NaoFiscal_Fechar_Comprovante(True);
  EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(True);
  {
  Testando roteiro TEF, desligar a impressora durante impressão do cupom, com venda no cartão dédito,
  devendo continuar a impressão, fechando o cupom e imprimindo o comprovante do cartão
  if _ecf15_CupomAberto(True) then
    //ShowMessage('Teste 1 Cupom aberto');
  if EPSON_NaoFiscal_Fechar_Comprovante(True) = 1 then
  begin
    //ShowMessage('Teste 1 Falhou fechar não fiscal');
    //ShowMessage('Teste 1 Fechando gerencial ' + IntToStr(EPSON_NaoFiscal_Fechar_Relatorio_Gerencial(True)));
  end;
  }
  Result := True;
end;

function _ecf15_ImprimeCheque(rP1: Real; sP2: String): Boolean;
begin
  Result := False;
end;

function _ecf15_GrandeTotal(sP1: Boolean): String;
var
  szDados: AnsiString;// 2024-03-06 szDados: array[0..20] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 20));
  EPSON_Obter_GT(PAnsiChar(szDados)); // 2024-03-06 EPSON_Obter_GT(szDados);
  Result := sZDados;
end;

function _ecf15_TotalizadoresDasAliquotas(sP1: Boolean): String;
var
  szAliquotas: AnsiString;//2024-03-06 sZAliquotas: array[0..553] of AnsiChar;
  I : Integer;
  sNN, sFF, sII : String;
begin
  szAliquotas := AnsiString(StringOfChar(' ', 553));
  //
  Result := '';
  sII    := '00000000000000';
  SFF    := '00000000000000';
  sNN    := '00000000000000';
  //
  iRetorno := EPSON_Obter_Tabela_Aliquotas(PAnsiChar(sZaliquotas)); // 2024-03-06 iRetorno := EPSON_Obter_Tabela_Aliquotas( sZaliquotas );
  //
  //
  for I := 1 to 19 do
  begin
    if Copy(sZaliquotas+Replicate('0',640),1+(I*23)-23,2) = 'I ' then sII := Right(Copy(sZaliquotas+Replicate('0',640),7+(I*23)-23,23-6),14) else
      if Copy(sZaliquotas+Replicate('0',640),1+(I*23)-23,2) = 'F ' then sFF := Right(Copy(sZaliquotas+Replicate('0',640),7+(I*23)-23,23-6),14) else
        if Copy(sZaliquotas+Replicate('0',640),1+(I*23)-23,2) = 'N ' then sNN := Right(Copy(sZaliquotas+Replicate('0',640),7+(I*23)-23,23-6),14) else Result := Result + Right(Copy(sZaliquotas+Replicate('0',640),7+(I*23)-23,23-6),14);

//ShowMessage(Copy(sZaliquotas,1,200)+chr(10)+ Right(Copy(sZaliquotas+Replicate('0',640),7+(I*23)-23,23-6),14));

  end;
  //
  Result := Result + sII + sNN + SFF;
  //
end;

function _ecf15_CupomAberto(sP1: Boolean): boolean;
var
  szEstado: AnsiString;//2024-03-06 szEstado: array[0..60] of AnsiChar;
begin
  szEstado := AnsiString(StringOfChar(' ', 57));
  EPSON_Obter_Estado_Cupom(PAnsiChar(szEstado)); // 2024-03-06 EPSON_Obter_Estado_Cupom(szEstado);
  if Copy(szEstado, 1, 2) = '01' then
    Result := True
  else
    Result := False;
end;

function _ecf15_FaltaPagamento(sP1: Boolean): boolean;
var
  szEstado: AnsiString;//2024-03-06 szEstado: array[0..60] of AnsiChar;
begin
  szEstado := AnsiString(StringOfChar(' ', 57));
  EPSON_Obter_Estado_Cupom(PAnsiChar(szEstado)); // 2024-03-06 EPSON_Obter_Estado_Cupom(szEstado);
  if Copy(szEstado, 56, 1) = '3'
    then Result := True
  else
    Result := False;
end;

//
// PAF
//

function _ecf15_Marca(sP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := Alltrim(Copy(szDados,41,20));
  //
  // Ok
  //
end;

function _ecf15_Modelo(sP1: Boolean): String;
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := AllTrim(Copy(szDados,61,20));
  //
  // Ok
  //
end;

function _ecf15_Tipodaimpressora(pP1: Boolean): String; //
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := AllTrim(Copy(szDados,81,20));
  //
  // Ok
  //
end;

function _ecf15_VersaoSB(pP1: Boolean): String; //
var
  szDados: AnsiString;//2024-03-06 sZDados : array[0..110] of AnsiChar;
begin
  szDados := AnsiString(StringOfChar(' ', 110));
  iRetorno := EPSON_Obter_Dados_Impressora(PAnsiChar(szDados)); // 2024-03-06 iRetorno := EPSON_Obter_Dados_Impressora(szDados);
  Result   := AllTrim(Copy(szDados,101,8));
  //
  // Ok
  //
end;

function _ecf15_HoraIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '000123';
end;

function _ecf15_DataIntalacaoSB(pP1: Boolean): String; //
begin
  Result := '01012000';
end;

function _ecf15_ProgramaAplicativo(sP1: Boolean): boolean;
begin
  Result := True;
end;

function _ecf15_Jornada_Aberta(pP1: Boolean): Boolean;
var
  // 2015-10-14 sZDados: array[0..70] of AnsiChar;
  sZDados: AnsiString;
  sDataJornada: String;
  sDataFinalJornada: String;
begin
  // 2015-10-14   EPSON_Obter_Dados_Jornada(sZDados);
  sZDados := AnsiString(StringOfChar(' ', 68)); // 2015-10-14
  EPSON_Obter_Dados_Jornada(PAnsiChar(AnsiString(sZDados))); //2024-03-06 EPSON_Obter_Dados_Jornada(PAnsiChar(sZDados));
  // 2015-10-07 if Copy(sZDados,65,1) = '1' then Result := True else Result := False;
  {Sandro Silva 2017-07-04 inicio
  if Copy(sZDados,65,1) = '1' then
  begin
    // 2015-10-14 Mesmo com jornada aberta exibe está mensagem. O certo é validar o erro retornado pelo ECF ShowMessage('Redução Z pendente');
    Result := True;
  end
  else
    Result := False;
  }
  sDataJornada      := Copy(sZDados, 1, 2) + '/' + Copy(sZDados, 3, 2) + '/' + Copy(sZDados, 5, 4);
  sDataFinalJornada := Copy(sZDados, 15, 2) + '/' + Copy(sZDados, 17, 2) + '/' + Copy(sZDados, 19, 4);// Sandro Silva 2017-08-24
  //ShowMessage('Dados da jornada' + #13 + sZDados);
  if Trim(Copy(sZDados, 15, 8)) <> '' then
  begin
    // Sandro Silva 2017-09-27  if (sDataJornada = sDataFinalJornada) and (sDataFinalJornada = FormatDateTime('dd/mm/yyyy', Date)) then // Sandro Silva 2017-08-24
    if (sDataJornada = sDataFinalJornada) and (sDataFinalJornada = FormatDateTime('dd/mm/yyyy', Date)) and (Copy(sZDados, 65, 1) = '0') then // Sandro Silva 2017-08-24
      ShowMessage('Redução Z já emitida: ' + Copy(sZDados, 15, 2) + '/' + Copy(sZDados, 17, 2) + '/' + Copy(sZDados, 19, 4));
  end;

  if Copy(sZDados, 66, 1) = '1' then
  begin
    ShowMessage('Redução Z pendente: ' + sDataJornada);
    Result := True;
  end
  else
    Result := False;
{Sandro Silva 2017-07-04 final}
end;

function _ecf15_Abrir_Jornada: Boolean;
{Sandro Silva 2015-10-14 inicio
Abre a jornada fiscal. Necessário quando a RZ é emitida no dia seguinte que a jornada foi aberta}
begin
  Result := EPSON_RelatorioFiscal_Abrir_Jornada() = 0;
end;

function _ecf15_DadosDaUltimaReducao(pP1: Boolean): String; //
var
  I : Integer;
  sRetorno : String;
  sTotal, sI, sN, sS : STring;
begin
  //
  sRetorno := Replicate(' ',1167);
  //
  EPSON_Obter_Dados_Ultima_RZ(PAnsiChar(AnsiString(sRetorno))); //2024-05-06 EPSON_Obter_Dados_Ultima_RZ(PAnsiChar(sRetorno));

  {Sandro Silva 2016-11-29 inicio}
  // Se fizer RZ do dia anterior, abrir cupom, não lançar item, fechar e abrir o frente
  // EPSON_Obter_Dados_Ultima_RZ() retorna apenas espaços impedindo de usar o frente
  if LimpaNumero(sRetorno) = '' then
  begin
    if _ecf15_CupomAberto(True) then
    begin
      Form1.icupom := StrToIntDef(_ecf15_NumeroDoCupom(True), 0);
      Form1.Button4Click(Form1.Button4);
    end;
    EPSON_Obter_Dados_Ultima_RZ(PAnsiChar(AnsiString(sRetorno))); //2024-03-06 EPSON_Obter_Dados_Ultima_RZ(PAnsiChar(sRetorno));
  end;
  {Sandro Silva 2016-11-29 final}
  {2024-03-06
  //
  // 1	,	8   : Data de Emissão da Redução Z
  // 9	,	6   : Hora de Emissão da Redução Z
  // 15	,	6 : COO Inicial (Abertura da Jornada Fiscal)
  // 21	,	6 : COO Final (Redução Z)
  // 27	,	6 : CRZ
  // 33	,	6 : CRO
  // 39	,	6 : GNF
  // 45	,	6 : CDC
  // 51	,	6 : NFC
  // 57	,	6 : GRG
  // 63	,	6 : CCF
  // 69	,	6 : CFC
  // 75	,	6 : CFD
  // 81	,	6 : NCN
  // 87	,	18 : Totalizador Geral
  // 105	,	17 : Cancelamento ICMS
  // 122	,	17 : Cancelamento ISSQN
  // 139	,	17 : Cancelamento Não-Fiscal
  // 156	,	17 : Desconto ICMS
  // 173	,	17 : Desconto ISSQN
  // 190	,	17 : Desconto Não-Fiscal
  // 207	,	17 : Acréscimo ICMS
  // 224	,	17 : Acréscimo ISSQN
  // 241	,	17 : Acréscimo Não-Fiscal
  // 259	,	125 : Tributos (ICMS, ISSQN, F, I, N, FS, IS, NS);

  // 259, 15
  // 274
  // 289
  // 304
  // 319
  // 334
  // 349
  // 379



  // 384	,	408 : Totalizadores Parciais Tributados
  // 792	,	13 : Sangria
  // 805	,	13 : Fundo de Troco
  // 818	,	340 : Totalizadores Não Fiscais sendo que os 4 últimos bytes de cada totalizador refere-se ao CON (Contador de Totalizadores Não-Fiscais).
  // 1158	,	2 : Número de Alíquotas cadastradas.
  // 1160	,	8 : Data do Movimento.
  //
  sTotal := '';
  for I := 1 to 16 do
  begin
    if I <= StrToInt(Copy(sRetorno,1158,2)) then // Número de Alíquotas cadastradas.
    begin
      sTotal := sTotal + StrZero(StrToInt(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17)),14,0);
    end else
    begin
      sTotal := sTotal + Replicate('0',14);
      if I <= StrToInt(Copy(sRetorno,1158,2))+2 then // Número de Alíquotas cadastradas + 2 = isenção de ICMS
      begin
        sI := StrZero(StrToInt(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17)),14,0);
      end;
      if I <= StrToInt(Copy(sRetorno,1158,2))+3 then // Número de Alíquotas cadastradas + 3 = não incidência de ICMS
      begin
        sN := StrZero(StrToInt(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17)),14,0);
      end;
      if I <= StrToInt(Copy(sRetorno,1158,2))+1 then // Número de Alíquotas cadastradas + 1 = substituição tributária de ICMS
      begin
        sS := StrZero(StrToInt(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17)),14,0);
      end;
    end;
  end;
  //
  //  ShowMessage(sRetorno);
  //

  Result := Copy(Copy(sRetorno,1160,8),1,4) + Copy(Copy(sRetorno,1160,8),7,2) + //   1,  6 Data
            Copy(sRetorno,21,6)                                               + //   7,  6 COO
            Copy(sRetorno,87,18)                                              + //  13, 18 GT
            Copy(Copy(sRetorno,27,6),3,4)                                     + //  31,  4 CRZ
            Copy(Form1.sAliquotas,3,64)+ //  35, 64 Aliquotas
            sTotal + //   Copy(sRetorno, 118,224)+ //  99,224 Totalizadores das aliquotas
            Strzero(StrToInt(_ecf15_Nmdeintervenestcnicas(True)),4,0) + // 323,  4 Contador de reinício de operação
            //
            Strzero(StrToInt(Copy(sRetorno, 105, 17)),14,0) + // 327, 14 Totalizador de cancelamentos em ICMS
            Strzero(StrToInt(Copy(sRetorno, 156, 17)),14,0) + // 341, 14 Totalizador de descontos em ICMS
            //
            sI+ // 355, 14 Totalizador de isenção de ICMS
            sN+ // 369, 14 Totalizador de não incidência de ICMS
            sS+ // 383, 14 Totalizador de substituição tributária de ICMS
            '';
  }
  //
  // 1	,	8   : Data de Emissão da Redução Z
  // 9	,	6   : Hora de Emissão da Redução Z
  // 15	,	6 : COO Inicial (Abertura da Jornada Fiscal)
  // 21	,	6 : COO Final (Redução Z)
  // 27	,	6 : CRZ
  // 33	,	6 : CRO
  // 39	,	6 : GNF
  // 45	,	6 : CDC
  // 51	,	6 : NFC
  // 57	,	6 : GRG
  // 63	,	6 : CCF
  // 69	,	6 : CFC
  // 75	,	6 : CFD
  // 81	,	6 : NCN
  // 87	,	18 : Totalizador Geral
  // 105	,	17 : Cancelamento ICMS
  // 122	,	17 : Cancelamento ISSQN
  // 139	,	17 : Cancelamento Não-Fiscal
  // 156	,	17 : Desconto ICMS
  // 173	,	17 : Desconto ISSQN
  // 190	,	17 : Desconto Não-Fiscal
  // 207	,	17 : Acréscimo ICMS
  // 224	,	17 : Acréscimo ISSQN
  // 241	,	17 : Acréscimo Não-Fiscal
  // 259	,	125 : Tributos (ICMS, ISSQN, F, I, N, FS, IS, NS);

  // 259, 15
  // 274
  // 289
  // 304
  // 319
  // 334
  // 349
  // 379



  // 384	,	408 : Totalizadores Parciais Tributados
  // 792	,	13 : Sangria
  // 805	,	13 : Fundo de Troco
  // 818	,	340 : Totalizadores Não Fiscais sendo que os 4 últimos bytes de cada totalizador refere-se ao CON (Contador de Totalizadores Não-Fiscais).
  // 1158	,	2 : Número de Alíquotas cadastradas.
  // 1160	,	8 : Data do Movimento.
  //
  sTotal := '';
  for I := 1 to 16 do
  begin
    if I <= StrToIntDef(Copy(sRetorno,1158,2), 0) then // Número de Alíquotas cadastradas.
    begin
      sTotal := sTotal + StrZero(StrToIntDef(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17), 0),14,0);
    end else
    begin
      sTotal := sTotal + Replicate('0',14);
      if I <= StrToIntDef(Copy(sRetorno,1158,2), 0)+2 then // Número de Alíquotas cadastradas + 2 = isenção de ICMS
      begin
        sI := StrZero(StrToIntDef(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17), 0),14,0);
      end;
      if I <= StrToIntDef(Copy(sRetorno,1158,2), 0)+3 then // Número de Alíquotas cadastradas + 3 = não incidência de ICMS
      begin
        sN := StrZero(StrToIntDef(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17), 0),14,0);
      end;
      if I <= StrToIntDef(Copy(sRetorno,1158,2), 0)+1 then // Número de Alíquotas cadastradas + 1 = substituição tributária de ICMS
      begin
        sS := StrZero(StrToIntDef(Copy(Copy(sRetorno,384	, 408),(I*17)-17+1,17), 0),14,0);
      end;
    end;
  end;
  //
//  ShowMessage(sRetorno);
  //

  Result := Copy(Copy(sRetorno,1160,8),1,4) + Copy(Copy(sRetorno,1160,8),7,2) + //   1,  6 Data
            Copy(sRetorno,21,6)                                               + //   7,  6 COO
            Copy(sRetorno,87,18)                                              + //  13, 18 GT
            Copy(Copy(sRetorno,27,6),3,4)                                     + //  31,  4 CRZ
            Copy(Form1.sAliquotas,3,64)+ //  35, 64 Aliquotas
            sTotal + //   Copy(sRetorno, 118,224)+ //  99,224 Totalizadores das aliquotas
            Strzero(StrToIntDef(_ecf15_Nmdeintervenestcnicas(True), 0),4,0) + // 323,  4 Contador de reinício de operação
            //
            Strzero(StrToIntDef(Copy(sRetorno, 105, 17), 0),14,0) + // 327, 14 Totalizador de cancelamentos em ICMS
            Strzero(StrToIntDef(Copy(sRetorno, 156, 17), 0),14,0) + // 341, 14 Totalizador de descontos em ICMS
            //
            sI+ // 355, 14 Totalizador de isenção de ICMS
            sN+ // 369, 14 Totalizador de não incidência de ICMS
            sS+ // 383, 14 Totalizador de substituição tributária de ICMS
            '';
  //
  // Ok Testado
  //
end;

//
// Retorna o Código do Modelo do ECF Conf Tabela Nacional de Identificação do ECF
//
function _ecf15_CodigoModeloEcf(pP1: Boolean): String; //
var
  {2024-03-06
  szCodigoNacionalECF: array[0..7] of AnsiChar;
  szNomeArquivo: array[0..33] of AnsiChar;
  }
  szCodigoNacionalECF: AnsiString;
  szNomeArquivo: AnsiString;
begin
  szCodigoNacionalECF := AnsiString(StringOfChar(' ', 6));
  szNomeArquivo := AnsiString(StringOfChar(' ', 32));

  Result := '150401';
  try
    EPSON_Obter_Codigo_Nacional_ECF (PAnsiChar(AnsiString(szCodigoNacionalECF)), PAnsiChar(AnsiString(szNomeArquivo))); // 2024-03-06 EPSON_Obter_Codigo_Nacional_ECF (szCodigoNacionalECF , szNomeArquivo);
    Result := LimpaNumero(szCodigoNacionalECF);
  except
  end;
end;

end.






