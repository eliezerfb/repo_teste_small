unit ubematechbemaficlass;

interface

uses
  Windows, Messages
  {$IFDEF VER150}// – Delphi 7
  //, SmallFunc
  {$ELSE}
  , smallfunc_xe
  {$ENDIF}
  , SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls
  , ExtCtrls, Mask, Grids, StrUtils;

const BEMAMFD2_DLL_NAME = 'BEMAMFD2.DLL';
const BEMAFI_DLL_NAME_02 = 'BEMAFI32.DLL';  // usar const para compatibilizar loadlibrary com D7 e XE

type
  TBemaMFD = class(TComponent)
  private
    //FDllName: String;
    FDLLHandle: THandle;
    //function BemaGeraRegistrosTipoE( cArqMFD: string; cArqTXT: string; cDataInicial: string; cDataFinal: string; cRazao: string; cEndereco: string; cPAR1: string; cCMD: string; cPAR2: string; cPAR3: string; cPAR4: string; cPAR5: string; cPAR6: string; cPAR7: string; cPAR8: string; cPAR9: string; cPAR10: string; cPAR11: string; cPAR12: string; cPAR13: string; cPAR14: string ): Integer; StdCall; External 'BemaMFD2.dll';
    _BemaGeraRegistrosTipoE: function(cArqMFD: PAnsiChar; cArqTXT: PAnsiChar; cDataInicial: PAnsiChar; cDataFinal: PAnsiChar; cRazao: PAnsiChar; cEndereco: PAnsiChar; cPAR1: PAnsiChar; cCMD: PAnsiChar; cPAR2: PAnsiChar; cPAR3: PAnsiChar; cPAR4: PAnsiChar; cPAR5: PAnsiChar; cPAR6: PAnsiChar; cPAR7: PAnsiChar; cPAR8: PAnsiChar; cPAR9: PAnsiChar; cPAR10: PAnsiChar; cPAR11: PAnsiChar; cPAR12: PAnsiChar; cPAR13: PAnsiChar; cPAR14: PAnsiChar): Integer; StdCall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DLL: THandle read FDLLHandle write FDLLHandle;
    procedure CarregaDLL;
    procedure FinalizaDLL;
    procedure Import(var Proc: pointer; Name: PAnsiChar);

  end;

type
  TBemaFI = class(TComponent)
  private
    //FDllName: String;
    FDLLHandle: THandle;
    FLoad: Boolean;
    //--------------------------------------------------------------------------//
    // Módulo para Impressora Bematech                                          //
    // Utiliza a nova dll da Bematech                                           //
    // 13/02/2003                                                               //
    // Alterado p/versão 2006 07/01/2005 - RONEI                                //
    //--------------------------------------------------------------------------//
    // Declaração das Funções da nova DLL BEMAFI32.DLL                          //
    // 0800 -  644 2362                                                         //
    //--------------------------------------------------------------------------//

    //function Bematech_FI_ProgramaIdAplicativoMFD(IDAplicativo: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ProgramaIdAplicativoMFD: function(IDAplicativo: AnsiString): Integer; StdCall; // _Bematech_FI_ProgramaIdAplicativoMFD: function(IDAplicativo: PAnsiChar): Integer; StdCall;

    //function Bematech_FI_AlteraSimboloMoeda(SimboloMoeda: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AlteraSimboloMoeda: function(SimboloMoeda: AnsiString): Integer; StdCall; // _Bematech_FI_AlteraSimboloMoeda: function(SimboloMoeda: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ProgramaAliquota(Aliquota: String; ICMS_ISS: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ProgramaAliquota: function(Aliquota: AnsiString; ICMS_ISS: Integer): Integer; StdCall; // _Bematech_FI_ProgramaAliquota: function(Aliquota: PAnsiChar; ICMS_ISS: Integer): Integer; StdCall;
    //function Bematech_FI_ProgramaHorarioVerao: Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ProgramaHorarioVerao: function(): Integer; StdCall;
    //function Bematech_FI_NomeiaDepartamento(Indice: Integer; Departamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NomeiaDepartamento: function(Indice: Integer; Departamento: AnsiString): Integer; StdCall; // _Bematech_FI_NomeiaDepartamento: function(Indice: Integer; Departamento: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms: function(Indice: Integer; Totalizador: AnsiString): Integer; StdCall; // _Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms: function(Indice: Integer; Totalizador: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ProgramaArredondamento:Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ProgramaArredondamento: function():Integer; StdCall;
    //function Bematech_FI_ProgramaTruncamento:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ProgramaTruncamento';
    _Bematech_FI_ProgramaTruncamento: function(): Integer; StdCall;
    //function Bematech_FI_LinhasEntreCupons(Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LinhasEntreCupons: function(Linhas: Integer): Integer; StdCall;
    //function Bematech_FI_EspacoEntreLinhas(Dots: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_EspacoEntreLinhas: function(Dots: Integer): Integer; StdCall;
    //function Bematech_FI_ForcaImpactoAgulhas(ForcaImpacto: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ForcaImpactoAgulhas: function(ForcaImpacto: Integer): Integer; StdCall;

    // Funções do Cupom Fiscal /////////////////////////////////////////////////////

    //function Bematech_FI_AbreCupom(CGC_CPF: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AbreCupom: function(CGC_CPF: AnsiString): Integer; StdCall; // _Bematech_FI_AbreCupom: function(CGC_CPF: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VendeItem(Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VendeItem: function(Codigo: AnsiString; Descricao: AnsiString; Aliquota: AnsiString; TipoQuantidade: AnsiString; Quantidade: AnsiString; CasasDecimais: Integer; ValorUnitario: AnsiString; TipoDesconto: AnsiString; Desconto: AnsiString): Integer; StdCall; // _Bematech_FI_VendeItem: function(Codigo: PAnsiChar; Descricao: PAnsiChar; Aliquota: PAnsiChar; TipoQuantidade: PAnsiChar; Quantidade: PAnsiChar; CasasDecimais: Integer; ValorUnitario: PAnsiChar; TipoDesconto: PAnsiChar; Desconto: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VendeItemDepartamento(Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VendeItemDepartamento: function(Codigo: AnsiString; Descricao: AnsiString; Aliquota: AnsiString; ValorUnitario: AnsiString; Quantidade: AnsiString; Acrescimo: AnsiString; Desconto: AnsiString; IndiceDepartamento: AnsiString; UnidadeMedida: AnsiString): Integer; StdCall; // _Bematech_FI_VendeItemDepartamento: function(Codigo: PAnsiChar; Descricao: PAnsiChar; Aliquota: PAnsiChar; ValorUnitario: PAnsiChar; Quantidade: PAnsiChar; Acrescimo: PAnsiChar; Desconto: PAnsiChar; IndiceDepartamento: PAnsiChar; UnidadeMedida: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_CancelaItemAnterior: Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_CancelaItemAnterior: function: Integer; StdCall;
    //function Bematech_FI_CancelaItemGenerico(NumeroItem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_CancelaItemGenerico: function(NumeroItem: AnsiString): Integer; StdCall; //     _Bematech_FI_CancelaItemGenerico: function(NumeroItem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_CancelaCupom: Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_CancelaCupom: function(): Integer; StdCall;
    //function Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD(FormaPagamento: String; Valor: String; COOCupom: String; COOCDC: String; CPF: String; Nome: String; Endereco: String): Integer; StdCall; External 'BEMAFI32.DLL'; //2015-10-22 Cancelar vinculados
    _Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD: function(FormaPagamento: AnsiString; Valor: AnsiString; COOCupom: AnsiString; COOCDC: AnsiString; CPF: AnsiString; Nome: AnsiString; Endereco: AnsiString): Integer;  //_Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD: function(FormaPagamento: PAnsiChar; Valor: PAnsiChar; COOCupom: PAnsiChar; COOCDC: PAnsiChar; CPF: PAnsiChar; Nome: PAnsiChar; Endereco: PAnsiChar): Integer; StdCall; //2015-10-22 Cancelar vinculados
    //function Bematech_FI_EstornoNaoFiscalVinculadoMFD(CPF: String; Nome: String; Endereco: String): Integer; StdCall; External 'BEMAFI32.DLL'; //2017-0725 Cancelar vinculados
    _Bematech_FI_EstornoNaoFiscalVinculadoMFD: function(CPF: AnsiString; Nome: AnsiString; Endereco: AnsiString): Integer; StdCall; //_Bematech_FI_EstornoNaoFiscalVinculadoMFD: function(CPF: PAnsiChar; Nome: PAnsiChar; Endereco: PAnsiChar): Integer; StdCall; //2017-0725 Cancelar vinculados

    //function Bematech_FI_FechaCupomResumido(FormaPagamento: String; Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FechaCupomResumido: function(FormaPagamento: AnsiString; Mensagem: AnsiString): Integer; StdCall; // _Bematech_FI_FechaCupomResumido: function(FormaPagamento: PAnsiChar; Mensagem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_FechaCupom(FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FechaCupom: function(FormaPagamento: AnsiString; AcrescimoDesconto: AnsiString; TipoAcrescimoDesconto: AnsiString; ValorAcrescimoDesconto: AnsiString; ValorPago: AnsiString; Mensagem: AnsiString): Integer; StdCall; // _Bematech_FI_FechaCupom: function(FormaPagamento: PAnsiChar; AcrescimoDesconto: PAnsiChar; TipoAcrescimoDesconto: PAnsiChar; ValorAcrescimoDesconto: PAnsiChar; ValorPago: PAnsiChar; Mensagem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ResetaImpressora:Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ResetaImpressora: function:Integer; StdCall; // _Bematech_FI_ResetaImpressora: function:Integer; StdCall;

    //function Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_IniciaFechamentoCupom: function(AcrescimoDesconto: AnsiString; TipoAcrescimoDesconto: AnsiString; ValorAcrescimoDesconto: AnsiString): Integer; StdCall; // _Bematech_FI_IniciaFechamentoCupom: function(AcrescimoDesconto: PAnsiChar; TipoAcrescimoDesconto: PAnsiChar; ValorAcrescimoDesconto: PAnsiChar): Integer; StdCall;

    //function Bematech_FI_EfetuaFormaPagamento(FormaPagamento: String; ValorFormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_EfetuaFormaPagamento: function(FormaPagamento: AnsiString; ValorFormaPagamento: AnsiString): Integer; StdCall; //_Bematech_FI_EfetuaFormaPagamento: function(FormaPagamento: PAnsiChar; ValorFormaPagamento: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_EfetuaFormaPagamentoDescricaoForma(FormaPagamento: string; ValorFormaPagamento: string; DescricaoFormaPagto: string ): integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_EfetuaFormaPagamentoDescricaoForma: function(FormaPagamento: AnsiString; ValorFormaPagamento: AnsiString; DescricaoFormaPagto: AnsiString): Integer; StdCall; // _Bematech_FI_EfetuaFormaPagamentoDescricaoForma: function(FormaPagamento: PAnsiChar; ValorFormaPagamento: PAnsiChar; DescricaoFormaPagto: PAnsiChar): integer; StdCall;
    //function Bematech_FI_TerminaFechamentoCupom(Mensagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_TerminaFechamentoCupom: function(Mensagem: AnsiString): Integer; StdCall; // _Bematech_FI_TerminaFechamentoCupom: function(Mensagem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_EstornoFormasPagamento(FormaOrigem: String; FormaDestino: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_EstornoFormasPagamento: function(FormaOrigem: AnsiString; FormaDestino: AnsiString; Valor: AnsiString): Integer; StdCall; // _Bematech_FI_EstornoFormasPagamento: function(FormaOrigem: PAnsiChar; FormaDestino: PAnsiChar; Valor: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_UsaUnidadeMedida(UnidadeMedida: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_UsaUnidadeMedida: function(UnidadeMedida: AnsiString): Integer; StdCall; // _Bematech_FI_UsaUnidadeMedida: function(UnidadeMedida: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_AumentaDescricaoItem(Descricao: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AumentaDescricaoItem: function(Descricao: AnsiString): Integer; StdCall; // _Bematech_FI_AumentaDescricaoItem: function(Descricao: PAnsiChar): Integer; StdCall;

    // Funções dos Relatórios Fiscais //////////////////////////////////////////////

    //function Bematech_FI_LeituraX:Integer; StdCall; External 'BEMAFI32.DLL' ;
    _Bematech_FI_LeituraX: function(): Integer; StdCall;
    //function Bematech_FI_ReducaoZ(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ReducaoZ: function(Data: AnsiString; Hora: AnsiString): Integer; StdCall; // _Bematech_FI_ReducaoZ: function(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_RelatorioGerencial(Texto: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_RelatorioGerencial: function(Texto: AnsiString): Integer; StdCall; // _Bematech_FI_RelatorioGerencial: function(Texto: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_UsaRelatorioGerencialMFD(Texto: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_UsaRelatorioGerencialMFD: function(Texto: AnsiString): Integer; StdCall; // _Bematech_FI_UsaRelatorioGerencialMFD: function(Texto: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_FechaRelatorioGerencial:Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FechaRelatorioGerencial: function():Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalData: function(DataInicial: AnsiString; DataFinal: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalData: function(DataInicial: PAnsiChar; DataFinal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalReducao(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalReducao: function(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalReducao: function(ReducaoInicial: PAnsiChar; ReducaoFinal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalSerialData(DataInicial: String; DataFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalSerialData: function(DataInicial: AnsiString; DataFinal: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalSerialData: function(DataInicial: PAnsiChar; DataFinal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalSerialReducao(ReducaoInicial: String; ReducaoFinal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalSerialReducao: function(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalSerialReducao: function(ReducaoInicial: PAnsiChar; ReducaoFinal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_DownloadMFD(sArquivo:String; sTipo:String; DataInicial: String; DataFinal: String; sUsuario: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DownloadMFD: function(sArquivo: AnsiString; sTipo: AnsiString; DataInicial: AnsiString; DataFinal: AnsiString; sUsuario: AnsiString): Integer; StdCall; // _Bematech_FI_DownloadMFD: function(sArquivo: PAnsiChar; sTipo: PAnsiChar; DataInicial: PAnsiChar; DataFinal: PAnsiChar; sUsuario: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_FormatoDadosMFD( ArquivoOrigem: String; ArquivoDestino: String; TipoFormato: String; TipoDownload: String; ParametroInicial: String; ParametroFinal: String; UsuarioECF: String ): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FormatoDadosMFD: function(ArquivoOrigem: AnsiString; ArquivoDestino: AnsiString; TipoFormato: AnsiString; TipoDownload: AnsiString; ParametroInicial: AnsiString; ParametroFinal: AnsiString; UsuarioECF: AnsiString): Integer; StdCall; // _Bematech_FI_FormatoDadosMFD: function(ArquivoOrigem: PAnsiChar; ArquivoDestino: PAnsiChar; TipoFormato: PAnsiChar; TipoDownload: PAnsiChar; ParametroInicial: PAnsiChar; ParametroFinal: PAnsiChar; UsuarioECF: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ArquivoMFD( cNomeArquivoOrigem: String; cDadoInicial: String; cDadoFinal: String; cTipoDownload: String; cUsuario: String; iTipoGeracao: integer; cChavePublica: String; cChavePrivada: String; iUnicoArquivo: integer ): Integer;  StdCall; External'BEMAFI32.DLL';
    _Bematech_FI_ArquivoMFD: function(cNomeArquivoOrigem: AnsiString; cDadoInicial: AnsiString; cDadoFinal: AnsiString; cTipoDownload: AnsiString; cUsuario: AnsiString; iTipoGeracao: Integer; cChavePublica: AnsiString; cChavePrivada: AnsiString; iUnicoArquivo: Integer ): Integer; StdCall; // _Bematech_FI_ArquivoMFD: function(cNomeArquivoOrigem: PAnsiChar; cDadoInicial: PAnsiChar; cDadoFinal: PAnsiChar; cTipoDownload: PAnsiChar; cUsuario: PAnsiChar; iTipoGeracao: Integer; cChavePublica: PAnsiChar; cChavePrivada: PAnsiChar; iUnicoArquivo: Integer ): Integer; StdCall;
    //function Bematech_FI_DownloadMF( Arquivo: String ): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DownloadMF: function(Arquivo: AnsiString): Integer; StdCall; // _Bematech_FI_DownloadMF: function(Arquivo: PAnsiChar): Integer; StdCall;


    //
    // Novas leituras MFD
    //
    //function Bematech_FI_LeituraMemoriaFiscalDataMFD(DataInicial, DataFinal, FlagLeitura : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalDataMFD: function(DataInicial: AnsiString; DataFinal: AnsiString; FlagLeitura: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalDataMFD: function(DataInicial: PAnsiChar; DataFinal: PAnsiChar; FlagLeitura: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalReducaoMFD: function(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString; FlagLeitura: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalReducaoMFD: function(ReducaoInicial: PAnsiChar; ReducaoFinal: PAnsiChar; FlagLeitura: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(DataInicial, DataFinal, FlagLeitura : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalSerialDataMFD: function(DataInicial: AnsiString; DataFinal: AnsiString; FlagLeitura: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalSerialDataMFD: function(DataInicial: PAnsiChar; DataFinal: PAnsiChar; FlagLeitura: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(ReducaoInicial, ReducaoFinal, FlagLeitura : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD: function(ReducaoInicial: AnsiString; ReducaoFinal: AnsiString; FlagLeitura: AnsiString): Integer; StdCall; // _Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD: function(ReducaoInicial: PAnsiChar; ReducaoFinal: PAnsiChar; FlagLeitura: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_GeraRegistrosCAT52MFD(cArquivo,cData: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_GeraRegistrosCAT52MFD: function(cArquivo: AnsiString; cData: AnsiString): Integer; StdCall; // _Bematech_FI_GeraRegistrosCAT52MFD: function(cArquivo: PAnsiChar; cData: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_GeraRegistrosCAT52MFDEx( cArquivo, cData, cArqDestino: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_GeraRegistrosCAT52MFDEx: function(cArquivo: AnsiString; cData: AnsiString; cArqDestino: AnsiString): Integer; StdCall; // _Bematech_FI_GeraRegistrosCAT52MFDEx: function(cArquivo: PAnsiChar; cData: PAnsiChar; cArqDestino: PAnsiChar): Integer; StdCall;
    //

    // Funções das Operações Não Fiscais ///////////////////////////////////////////

    //function Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador: String; Valor: String; FormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_RecebimentoNaoFiscal: function(IndiceTotalizador: AnsiString; Valor: AnsiString; FormaPagamento: AnsiString): Integer; StdCall; // _Bematech_FI_RecebimentoNaoFiscal: function(IndiceTotalizador: PAnsiChar; Valor: PAnsiChar; FormaPagamento: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: String; Valor: String; NumeroCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AbreComprovanteNaoFiscalVinculado: function(FormaPagamento: AnsiString; Valor: AnsiString; NumeroCupom: AnsiString): Integer; StdCall; // _Bematech_FI_AbreComprovanteNaoFiscalVinculado: function(FormaPagamento: PAnsiChar; Valor: PAnsiChar; NumeroCupom: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_UsaComprovanteNaoFiscalVinculado(Texto: String): Integer; StdCall; External 'BEMAFI32.DLL'
    _Bematech_FI_UsaComprovanteNaoFiscalVinculado: function(Texto: AnsiString): Integer; StdCall; // _Bematech_FI_UsaComprovanteNaoFiscalVinculado: function(Texto: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_FechaComprovanteNaoFiscalVinculado:Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FechaComprovanteNaoFiscalVinculado: function():Integer; StdCall;
    //function Bematech_FI_Sangria(Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_Sangria: function(Valor: AnsiString): Integer; StdCall; // _Bematech_FI_Sangria: function(Valor: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_Suprimento(Valor: String; FormaPagamento: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_Suprimento: function(Valor: AnsiString; FormaPagamento: AnsiString): Integer; StdCall; // _Bematech_FI_Suprimento: function(Valor: PAnsiChar; FormaPagamento: PAnsiChar): Integer; StdCall;

    // Funções de Informações da Impressora ////////////////////////////////////////

    //function Bematech_FI_NumeroSerie(NumeroSerie: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroSerie: function(NumeroSerie: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroSerie: function(NumeroSerie: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroSerieMFD(NumeroSerie: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroSerieMFD: function(NumeroSerie: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroSerieMFD: function(NumeroSerie: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_SubTotal(SubTotal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_SubTotal: function(SubTotal: AnsiString): Integer; StdCall; // _Bematech_FI_SubTotal: function(SubTotal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroCupom(NumeroCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroCupom: function(NumeroCupom: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroCupom: function(NumeroCupom: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_LeituraXSerial: Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_LeituraXSerial: function(): Integer; StdCall;
    //function Bematech_FI_VersaoFirmware(VersaoFirmware: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VersaoFirmware: function(VersaoFirmware: AnsiString): Integer; StdCall; // _Bematech_FI_VersaoFirmware: function(VersaoFirmware: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_CGC_IE(CGC: String; IE: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_CGC_IE: function(CGC: AnsiString; IE: AnsiString): Integer; StdCall; // _Bematech_FI_CGC_IE: function(CGC: PAnsiChar; IE: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_GrandeTotal(GrandeTotal: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_GrandeTotal: function(GrandeTotal: AnsiString): Integer; StdCall; // _Bematech_FI_GrandeTotal: function(GrandeTotal: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_Cancelamentos(ValorCancelamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_Cancelamentos: function(ValorCancelamentos: AnsiString): Integer; StdCall; // _Bematech_FI_Cancelamentos: function(ValorCancelamentos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_Descontos(ValorDescontos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_Descontos: function(ValorDescontos: AnsiString): Integer; StdCall; // _Bematech_FI_Descontos: function(ValorDescontos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroOperacoesNaoFiscais(NumeroOperacoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroOperacoesNaoFiscais: function(NumeroOperacoes: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroOperacoesNaoFiscais: function(NumeroOperacoes: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroCuponsCancelados(NumeroCancelamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroCuponsCancelados: function(NumeroCancelamentos: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroCuponsCancelados: function(NumeroCancelamentos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroIntervencoes(NumeroIntervencoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroIntervencoes: function(NumeroIntervencoes: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroIntervencoes: function(NumeroIntervencoes: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroReducoes(NumeroReducoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroReducoes: function(NumeroReducoes: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroReducoes: function(NumeroReducoes: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroSubstituicoesProprietario(NumeroSubstituicoes: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroSubstituicoesProprietario: function(NumeroSubstituicoes: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroSubstituicoesProprietario: function(NumeroSubstituicoes: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_UltimoItemVendido(NumeroItem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_UltimoItemVendido: function(NumeroItem: AnsiString): Integer; StdCall; // _Bematech_FI_UltimoItemVendido: function(NumeroItem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ClicheProprietario(Cliche: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ClicheProprietario: function(Cliche: AnsiString): Integer; StdCall; // _Bematech_FI_ClicheProprietario: function(Cliche: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroCaixa(NumeroCaixa: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroCaixa: function(NumeroCaixa: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroCaixa: function(NumeroCaixa: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_NumeroLoja(NumeroLoja: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NumeroLoja: function(NumeroLoja: AnsiString): Integer; StdCall; // _Bematech_FI_NumeroLoja: function(NumeroLoja: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_SimboloMoeda(SimboloMoeda: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_SimboloMoeda: function(SimboloMoeda: AnsiString): Integer; StdCall; // _Bematech_FI_SimboloMoeda: function(SimboloMoeda: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_MinutosLigada(Minutos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_MinutosLigada: function(Minutos: AnsiString): Integer; StdCall; // _Bematech_FI_MinutosLigada: function(Minutos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_MinutosImprimindo(Minutos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_MinutosImprimindo: function(Minutos: AnsiString): Integer; StdCall; // _Bematech_FI_MinutosImprimindo: function(Minutos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaModoOperacao(Modo: string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaModoOperacao: function(Modo: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaModoOperacao: function(Modo: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaEpromConectada(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaEpromConectada: function(Flag: AnsiString): Integer; StdCall;// _Bematech_FI_VerificaEpromConectada: function(Flag: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_FlagsFiscais(Var Flag: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_FlagsFiscais: function(var Flag: Integer): Integer; StdCall;
    //function Bematech_FI_ValorPagoUltimoCupom(ValorCupom: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ValorPagoUltimoCupom: function(ValorCupom: AnsiString): Integer; StdCall; // _Bematech_FI_ValorPagoUltimoCupom: function(ValorCupom: String): Integer; StdCall;
    //function Bematech_FI_DataHoraImpressora(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DataHoraImpressora: function(Data: AnsiString; Hora: AnsiString): Integer; StdCall; // _Bematech_FI_DataHoraImpressora: function(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall;

    //Convênio 0909 Início
    //function Bematech_FI_VendaLiquida(Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VendaLiquida: function(Valor: AnsiString): Integer; StdCall; // _Bematech_FI_VendaLiquida: function(Valor: PAnsiChar): Integer; StdCall;
    //Convênio 0909 Fim

    //
    // Contadores
    //
    //function Bematech_FI_ContadoresTotalizadoresNaoFiscais(Contadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ContadoresTotalizadoresNaoFiscais: function(Contadores: AnsiString): Integer; StdCall; // _Bematech_FI_ContadoresTotalizadoresNaoFiscais: function(Contadores: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ContadorCupomFiscalMFD(CuponsEmitidos : String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ContadorCupomFiscalMFD: function(CuponsEmitidos: AnsiString): Integer; StdCall; // _Bematech_FI_ContadorCupomFiscalMFD: function(CuponsEmitidos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ContadorRelatoriosGerenciaisMFD (Relatorios : String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ContadorRelatoriosGerenciaisMFD: function(Relatorios: AnsiString): Integer; StdCall; // _Bematech_FI_ContadorRelatoriosGerenciaisMFD: function(Relatorios: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ContadorComprovantesCreditoMFD(Comprovantes : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ContadorComprovantesCreditoMFD: function(Comprovantes: AnsiString): Integer; StdCall; // _Bematech_FI_ContadorComprovantesCreditoMFD: function(Comprovantes: PAnsiChar): Integer; StdCall;
    //

    //function Bematech_FI_VerificaTotalizadoresNaoFiscais(Totalizadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaTotalizadoresNaoFiscais: function(Totalizadores: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaTotalizadoresNaoFiscais: function(Totalizadores: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_DataHoraReducao(Data: String; Hora: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DataHoraReducao: function(Data: AnsiString; Hora: AnsiString): Integer; StdCall; // _Bematech_FI_DataHoraReducao: function(Data: PAnsiChar; Hora: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_DataMovimento(Data: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DataMovimento: function(Data: AnsiString): Integer; StdCall; //_Bematech_FI_DataMovimento: function(Data: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaTruncamento(Flag: string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaTruncamento: function(Flag: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaTruncamento: function(Flag: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_Acrescimos(ValorAcrescimos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_Acrescimos: function(ValorAcrescimos: AnsiString): Integer; StdCall; // _Bematech_FI_Acrescimos: function(ValorAcrescimos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ContadorBilhetePassagem(ContadorPassagem: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ContadorBilhetePassagem: function(ContadorPassagem: AnsiString): Integer; StdCall; // _Bematech_FI_ContadorBilhetePassagem: function(ContadorPassagem: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaAliquotasIss(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaAliquotasIss: function(Flag: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaAliquotasIss: function(Flag: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaFormasPagamento(Formas: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaFormasPagamento: function(Formas: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaFormasPagamento: function(Formas: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaRecebimentoNaoFiscal(Recebimentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaRecebimentoNaoFiscal: function(Recebimentos: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaRecebimentoNaoFiscal: function(Recebimentos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaDepartamentos(Departamentos: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaDepartamentos: function(Departamentos: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaDepartamentos: function(Departamentos: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaTipoImpressora(Var TipoImpressora: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaTipoImpressora: function(var TipoImpressora: Integer): Integer; StdCall;
    //function Bematech_FI_VerificaTotalizadoresParciais(Totalizadores: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaTotalizadoresParciais: function(Totalizadores: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaTotalizadoresParciais: function(Totalizadores: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_RetornoAliquotas(Aliquotas: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_RetornoAliquotas: function(Aliquotas: AnsiString): Integer; StdCall; //_Bematech_FI_RetornoAliquotas: function(Aliquotas: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaEstadoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaEstadoImpressora: function(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall;
    //function Bematech_FI_DadosUltimaReducao(DadosReducao: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DadosUltimaReducao: function(DadosReducao: AnsiString): Integer; StdCall; // _Bematech_FI_DadosUltimaReducao: function(DadosReducao: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_MonitoramentoPapel(Var Linhas: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_MonitoramentoPapel: function(var Linhas: Integer): Integer; StdCall;
    //function Bematech_FI_VerificaIndiceAliquotasIss(Flag: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaIndiceAliquotasIss: function(Flag: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaIndiceAliquotasIss: function(Flag: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_ValorFormaPagamento(FormaPagamento: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ValorFormaPagamento: function(FormaPagamento: AnsiString; Valor: String): Integer; StdCall; // _Bematech_FI_ValorFormaPagamento: function(FormaPagamento: PAnsiChar; Valor: String): Integer; StdCall;
    //function Bematech_FI_ValorTotalizadorNaoFiscal(Totalizador: String; Valor: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ValorTotalizadorNaoFiscal: function(Totalizador: AnsiString; Valor: AnsiString): Integer; StdCall; // _Bematech_FI_ValorTotalizadorNaoFiscal: function(Totalizador: PAnsiChar; Valor: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_MarcaModeloTipoImpressoraMFD(Marca, Modelo, Tipo : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_MarcaModeloTipoImpressoraMFD: function(Marca: AnsiString; Modelo: AnsiString; Tipo: AnsiString): Integer; StdCall; //_Bematech_FI_MarcaModeloTipoImpressoraMFD: function(Marca: PAnsiChar; Modelo: PAnsiChar; Tipo: PAnsiChar): Integer; StdCall;

    // Funções de Autenticação e Gaveta de Dinheiro ////////////////////////////////

    //function Bematech_FI_Autenticacao:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_Autenticacao';
    _Bematech_FI_Autenticacao: function():Integer; StdCall;
    //function Bematech_FI_ProgramaCaracterAutenticacao(Parametros: String): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ProgramaCaracterAutenticacao: function(Parametros: AnsiString): Integer; StdCall; // _Bematech_FI_ProgramaCaracterAutenticacao: function(Parametros: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_AcionaGaveta:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_AcionaGaveta';
    _Bematech_FI_AcionaGaveta: function():Integer; StdCall;
    //function Bematech_FI_VerificaEstadoGaveta(Var EstadoGaveta: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaEstadoGaveta: function(var EstadoGaveta: Integer): Integer; StdCall;

    // Outras Funções //////////////////////////////////////////////////////////////

    //function Bematech_FI_AbrePortaSerial:Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AbrePortaSerial: function():Integer; StdCall;
    //function Bematech_FI_AbrePorta(numero: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AbrePorta: function(numero: Integer): Integer; StdCall;

    //function Bematech_FI_RetornoImpressora(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_RetornoImpressora: function(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer; StdCall;
    //function Bematech_FI_FechaPortaSerial:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechaPortaSerial';
    _Bematech_FI_FechaPortaSerial: function(): Integer; StdCall;
    //function Bematech_FI_MapaResumo:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_MapaResumo';
    _Bematech_FI_MapaResumo: function(): Integer; StdCall;
    //function Bematech_FI_AberturaDoDia( ValorCompra: string; FormaPagamento: string ): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AberturaDoDia: function(ValorCompra: AnsiString; FormaPagamento: AnsiString ): Integer; StdCall; // _Bematech_FI_AberturaDoDia: function(ValorCompra: PAnsiChar; FormaPagamento: PAnsiChar ): Integer; StdCall;
    //function Bematech_FI_FechamentoDoDia:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_FechamentoDoDia';
    _Bematech_FI_FechamentoDoDia: function: Integer; StdCall;
    //function Bematech_FI_ImprimeConfiguracoesImpressora:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeConfiguracoesImpressora';
    _Bematech_FI_ImprimeConfiguracoesImpressora: function(): Integer; StdCall;
    //function Bematech_FI_ImprimeDepartamentos:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_ImprimeDepartamentos';
    _Bematech_FI_ImprimeDepartamentos: function(): Integer; StdCall;
    //function Bematech_FI_RelatorioTipo60Analitico:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Analitico';
    _Bematech_FI_RelatorioTipo60Analitico: function():Integer; StdCall;
    //function Bematech_FI_RelatorioTipo60Mestre:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_RelatorioTipo60Mestre';
    _Bematech_FI_RelatorioTipo60Mestre: function(): Integer; StdCall;
    //function Bematech_FI_VerificaImpressoraLigada:Integer; StdCall; External 'BEMAFI32.DLL' Name 'Bematech_FI_VerificaImpressoraLigada';
    _Bematech_FI_VerificaImpressoraLigada: function(): Integer; StdCall;
    //function Bematech_FI_ImprimeCheque( Banco: String; Valor: String; Favorecido: String; Cidade: String; Data: String; Mensagem: String ): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_ImprimeCheque: function(Banco: AnsiString; Valor: AnsiString; Favorecido: AnsiString; Cidade: AnsiString; Data: AnsiString; Mensagem: AnsiString): Integer; StdCall; // _Bematech_FI_ImprimeCheque: function(Banco: PAnsiChar; Valor: PAnsiChar; Favorecido: PAnsiChar; Cidade: PAnsiChar; Data: PAnsiChar; Mensagem: PAnsiChar ): Integer; StdCall;
    //function Bematech_FI_SegundaViaNaoFiscalVinculadoMFD(): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_SegundaViaNaoFiscalVinculadoMFD: function(): Integer; StdCall;
    //function Bematech_FI_DadosUltimaReducaoMFD(DadosReducao : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_DadosUltimaReducaoMFD: function(DadosReducao: AnsiString): Integer; StdCall; // _Bematech_FI_DadosUltimaReducaoMFD: function(DadosReducao: PAnsiChar): Integer; StdCall;
    //
    //function Bematech_FI_NomeiaRelatorioGerencialMFD (Indice, Descricao : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_NomeiaRelatorioGerencialMFD: function(Indice: Integer; Descricao: AnsiString): Integer; StdCall; // _Bematech_FI_NomeiaRelatorioGerencialMFD: function(Indice: PAnsiChar; Descricao: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_AbreRelatorioGerencialMFD(Indice : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_AbreRelatorioGerencialMFD: function(Indice: AnsiString): Integer; StdCall; // _Bematech_FI_AbreRelatorioGerencialMFD: function(Indice: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_VerificaRelatorioGerencialMFD(Relatorios : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_VerificaRelatorioGerencialMFD: function(Relatorios: AnsiString): Integer; StdCall; // _Bematech_FI_VerificaRelatorioGerencialMFD: function(Relatorios: PAnsiChar): Integer; StdCall;

    {Sandro Silva 2016-03-01 inicio}
    //function Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(FlagRetorno : string): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD: function(FlagRetorno: AnsiString): Integer; StdCall; // _Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD: function(FlagRetorno: PAnsiChar): Integer; StdCall;
    //function Bematech_FI_RetornoImpressoraMFD(Var ACK: Integer; Var ST1: Integer; Var ST2: Integer; Var ST3: Integer ): Integer; StdCall; External 'BEMAFI32.DLL';
    _Bematech_FI_RetornoImpressoraMFD: function(var ACK: Integer; var ST1: Integer; var ST2: Integer; var ST3: Integer): Integer; StdCall;
    {Sandro Silva 2016-03-01 final}
    //procedure Import(var Proc: pointer; Name: PAnsiChar);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Load: Boolean read FLoad;
    property DLL: THandle read FDLLHandle write FDLLHandle;
    function CarregaDLL: Boolean;
    procedure FinalizaDLL;
    procedure Import(var Proc: pointer; Name: PAnsiChar);
    procedure SleepEntreMetodos;
    function Bematech_FI_ProgramaIdAplicativoMFD(sIDAplicativo: String): Integer;
    function Bematech_FI_AlteraSimboloMoeda(SimboloMoeda: String): Integer;
    function Bematech_FI_ProgramaAliquota(Aliquota: String; ICMS_ISS: Integer): Integer;
    function Bematech_FI_ProgramaHorarioVerao: Integer;
    function Bematech_FI_NomeiaDepartamento(Indice: Integer; Departamento: String): Integer;
    function Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice: Integer; Totalizador: String): Integer;
    function Bematech_FI_ProgramaArredondamento: Integer;
    function Bematech_FI_ProgramaTruncamento: Integer;
    function Bematech_FI_LinhasEntreCupons(Linhas: Integer): Integer;
    function Bematech_FI_EspacoEntreLinhas(Dots: Integer): Integer;
    function Bematech_FI_ForcaImpactoAgulhas(ForcaImpacto: Integer): Integer;
    function Bematech_FI_AbreCupom(CGC_CPF: String): Integer;
    function Bematech_FI_VendeItem(Codigo: String; Descricao: String; Aliquota: String; TipoQuantidade: String; Quantidade: String; CasasDecimais: Integer; ValorUnitario: String; TipoDesconto: String; Desconto: String): Integer;
    function Bematech_FI_VendeItemDepartamento(Codigo: String; Descricao: String; Aliquota: String; ValorUnitario: String; Quantidade: String; Acrescimo: String; Desconto: String; IndiceDepartamento: String; UnidadeMedida: String): Integer;
    function Bematech_FI_CancelaItemAnterior: Integer;
    function Bematech_FI_CancelaItemGenerico(NumeroItem: String): Integer;
    function Bematech_FI_CancelaCupom: Integer;
    function Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD(FormaPagamento: String; Valor: String; COOCupom: String; COOCDC: String; CPF: String; Nome: String; Endereco: String): Integer;
    function Bematech_FI_EstornoNaoFiscalVinculadoMFD(CPF: String; Nome: String; Endereco: String): Integer;
    function Bematech_FI_FechaCupomResumido(FormaPagamento: String; Mensagem: String): Integer;
    function Bematech_FI_FechaCupom(FormaPagamento: String; AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String; ValorPago: String; Mensagem: String): Integer;
    function Bematech_FI_ResetaImpressora: Integer;
    function Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto: String; TipoAcrescimoDesconto: String; ValorAcrescimoDesconto: String): Integer;
    function Bematech_FI_EfetuaFormaPagamento(FormaPagamento: String; ValorFormaPagamento: String): Integer;
    function Bematech_FI_EfetuaFormaPagamentoDescricaoForma(FormaPagamento: String; ValorFormaPagamento: String; DescricaoFormaPagto: String): Integer;
    function Bematech_FI_TerminaFechamentoCupom(Mensagem: String): Integer;
    function Bematech_FI_EstornoFormasPagamento(FormaOrigem: String; FormaDestino: String; Valor: String): Integer;
    function Bematech_FI_UsaUnidadeMedida(UnidadeMedida: String): Integer;
    function Bematech_FI_AumentaDescricaoItem(Descricao: String): Integer;
    function Bematech_FI_LeituraX: Integer;
    function Bematech_FI_ReducaoZ(Data: String; Hora: String): Integer;
    function Bematech_FI_RelatorioGerencial(Texto: String): Integer;
    function Bematech_FI_UsaRelatorioGerencialMFD(Texto: String): Integer;
    function Bematech_FI_FechaRelatorioGerencial: Integer;
    function Bematech_FI_LeituraMemoriaFiscalData(DataInicial: String; DataFinal: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalReducao(ReducaoInicial: String; ReducaoFinal: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalSerialData(DataInicial: String; DataFinal: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalSerialReducao(ReducaoInicial: String; ReducaoFinal: String): Integer;
    function Bematech_FI_DownloadMFD(sArquivo: String; sTipo: String; DataInicial: String; DataFinal: String; sUsuario: String): Integer;
    function Bematech_FI_FormatoDadosMFD(ArquivoOrigem: String; ArquivoDestino: String; TipoFormato: String; TipoDownload: String; ParametroInicial: String; ParametroFinal: String; UsuarioECF: String): Integer;
    function Bematech_FI_ArquivoMFD(cNomeArquivoOrigem: String; cDadoInicial: String; cDadoFinal: String; cTipoDownload: String; cUsuario: String; iTipoGeracao: Integer; cChavePublica: String; cChavePrivada: String; iUnicoArquivo: Integer): Integer;
    function Bematech_FI_DownloadMF(Arquivo: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalDataMFD(DataInicial: String; DataFinal: String; FlagLeitura: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial: String; ReducaoFinal: String; FlagLeitura: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(DataInicial: String; DataFinal: String; FlagLeitura: String): Integer;
    function Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(ReducaoInicial: String; ReducaoFinal: String; FlagLeitura: String): Integer;
    function Bematech_FI_GeraRegistrosCAT52MFD(cArquivo: String; cData: String): Integer;
    function Bematech_FI_GeraRegistrosCAT52MFDEx(cArquivo: String; cData: String; cArqDestino: String): Integer;
    function Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador: String; Valor: String; FormaPagamento: String): Integer;
    function Bematech_FI_AbreComprovanteNaoFiscalVinculado(FormaPagamento: String; Valor: String; NumeroCupom: String): Integer;
    function Bematech_FI_UsaComprovanteNaoFiscalVinculado(Texto: String): Integer;
    function Bematech_FI_FechaComprovanteNaoFiscalVinculado: Integer;
    function Bematech_FI_Sangria(Valor: String): Integer;
    function Bematech_FI_Suprimento(Valor: String; FormaPagamento: String): Integer;
    function Bematech_FI_NumeroSerie(var NumeroSerie: String): Integer;
    function Bematech_FI_NumeroSerieMFD(var NumeroSerie: String): Integer;
    function Bematech_FI_SubTotal(var SubTotal: String): Integer;
    function Bematech_FI_NumeroCupom(var NumeroCupom: String): Integer;
    function Bematech_FI_LeituraXSerial: Integer;
    function Bematech_FI_VersaoFirmware(var VersaoFirmware: String): Integer;
    function Bematech_FI_CGC_IE(var CGC: String; var IE: String): Integer;
    function Bematech_FI_GrandeTotal(var GrandeTotal: String): Integer;
    function Bematech_FI_Cancelamentos(var ValorCancelamentos: String): Integer;
    function Bematech_FI_Descontos(var ValorDescontos: String): Integer;
    function Bematech_FI_NumeroOperacoesNaoFiscais(var NumeroOperacoes: String): Integer;
    function Bematech_FI_NumeroIntervencoes(var NumeroIntervencoes: String): Integer;
    function Bematech_FI_NumeroReducoes(var NumeroReducoes: String): Integer;
    function Bematech_FI_NumeroSubstituicoesProprietario(var NumeroSubstituicoes: String): Integer;
    function Bematech_FI_UltimoItemVendido(var NumeroItem: String): Integer;
    function Bematech_FI_ClicheProprietario(Cliche: String): Integer;
    function Bematech_FI_NumeroCaixa(var NumeroCaixa: String): Integer;
    function Bematech_FI_NumeroLoja(var NumeroLoja: String): Integer;
    function Bematech_FI_SimboloMoeda(var SimboloMoeda: String): Integer;
    function Bematech_FI_MinutosLigada(var Minutos: String): Integer;
    function Bematech_FI_MinutosImprimindo(var Minutos: String): Integer;
    function Bematech_FI_VerificaModoOperacao(var Modo: String): Integer;
    function Bematech_FI_VerificaEpromConectada(var Flag: String): Integer;
    function Bematech_FI_FlagsFiscais(var Flag: Integer): Integer;
    function Bematech_FI_ValorPagoUltimoCupom(var ValorCupom: String): Integer;
    function Bematech_FI_DataHoraImpressora(var Data: String; var Hora: String): Integer;
    function Bematech_FI_VendaLiquida(Valor: String): Integer;
    function Bematech_FI_ContadoresTotalizadoresNaoFiscais(var Contadores: String): Integer;
    function Bematech_FI_ContadorCupomFiscalMFD(var CuponsEmitidos: String): Integer;
    function Bematech_FI_ContadorRelatoriosGerenciaisMFD(var Relatorios: String): Integer;
    function Bematech_FI_ContadorComprovantesCreditoMFD(var Comprovantes: String): Integer;
    function Bematech_FI_VerificaTotalizadoresNaoFiscais(var Totalizadores: String): Integer;
    function Bematech_FI_DataHoraReducao(var Data: String; var Hora: String): Integer;
    function Bematech_FI_DataMovimento(var Data: String): Integer;
    function Bematech_FI_VerificaTruncamento(var Flag: String): Integer;
    function Bematech_FI_Acrescimos(var ValorAcrescimos: String): Integer;
    function Bematech_FI_ContadorBilhetePassagem(var ContadorPassagem: String): Integer;
    function Bematech_FI_VerificaAliquotasIss(var Flag: String): Integer;
    function Bematech_FI_VerificaFormasPagamento(var Formas: String): Integer;
    function Bematech_FI_VerificaRecebimentoNaoFiscal(var Recebimentos: String): Integer;
    function Bematech_FI_VerificaDepartamentos(var Departamentos: String): Integer;
    function Bematech_FI_VerificaTipoImpressora(var TipoImpressora: Integer): Integer;
    function Bematech_FI_VerificaTotalizadoresParciais(var Totalizadores: String): Integer;
    function Bematech_FI_RetornoAliquotas(var Aliquotas: String): Integer;
    function Bematech_FI_VerificaEstadoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer;
    function Bematech_FI_DadosUltimaReducao(var DadosReducao: String): Integer;
    function Bematech_FI_MonitoramentoPapel(var Linhas: Integer): Integer;
    function Bematech_FI_VerificaIndiceAliquotasIss(var Flag: String): Integer;
    function Bematech_FI_ValorFormaPagamento(var FormaPagamento: String; var Valor: String): Integer;
    function Bematech_FI_ValorTotalizadorNaoFiscal(var Totalizador: String; var Valor: String): Integer;
    function Bematech_FI_MarcaModeloTipoImpressoraMFD(var Marca: String; var Modelo: String; var Tipo: String): Integer;
    function Bematech_FI_Autenticacao: Integer;
    function Bematech_FI_ProgramaCaracterAutenticacao(Parametros: String): Integer;
    function Bematech_FI_AcionaGaveta: Integer;
    function Bematech_FI_VerificaEstadoGaveta(var EstadoGaveta: Integer): Integer;
    function Bematech_FI_AbrePortaSerial: Integer;
    function Bematech_FI_AbrePorta(numero: Integer): Integer;
    function Bematech_FI_RetornoImpressora(var ACK: Integer; var ST1: Integer; var ST2: Integer): Integer;
    function Bematech_FI_FechaPortaSerial: Integer;
    function Bematech_FI_MapaResumo: Integer;
    function Bematech_FI_AberturaDoDia(var ValorCompra: String; var FormaPagamento: String): Integer;
    function Bematech_FI_FechamentoDoDia: Integer;
    function Bematech_FI_ImprimeConfiguracoesImpressora: Integer;
    function Bematech_FI_ImprimeDepartamentos: Integer;
    function Bematech_FI_RelatorioTipo60Analitico: Integer;
    function Bematech_FI_RelatorioTipo60Mestre: Integer;
    function Bematech_FI_VerificaImpressoraLigada: Integer;
    function Bematech_FI_ImprimeCheque(Banco: String; Valor: String; Favorecido: String; Cidade: String; Data: String; Mensagem: String): Integer;
    function Bematech_FI_SegundaViaNaoFiscalVinculadoMFD: Integer;
    function Bematech_FI_DadosUltimaReducaoMFD(var DadosReducao: String): Integer;
    function Bematech_FI_NomeiaRelatorioGerencialMFD(Indice: Integer; Descricao: String): Integer;
    function Bematech_FI_AbreRelatorioGerencialMFD(Indice: String): Integer;
    function Bematech_FI_VerificaRelatorioGerencialMFD(var Relatorios: String): Integer;
    function Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(FlagRetorno: String): Integer;
    function Bematech_FI_RetornoImpressoraMFD(var ACK: Integer; var ST1: Integer; var ST2: Integer; var ST3: Integer): Integer;
  published

  end;

  //

implementation

{ TBemaFI }

function TBemaFI.Bematech_FI_AlteraSimboloMoeda(
  SimboloMoeda: String): Integer;
//var
//  asSimboloMoeda: AnsiString;
begin
//  asSimboloMoeda := AnsiString(StringOfChar(#0, 2));
  Result := _Bematech_FI_AlteraSimboloMoeda(AnsiString(SimboloMoeda));
end;

function TBemaFI.Bematech_FI_ProgramaAliquota(Aliquota: String;
  ICMS_ISS: Integer): Integer;
//var
//  asAliquota: AnsiString;
begin
  //asAliquota := AnsiString(StringOf(#0, 4));
  //asAliquota := AnsiString(Aliquota);
  Result := _Bematech_FI_ProgramaAliquota(AnsiString(Aliquota), ICMS_ISS);
end;

function TBemaFI.Bematech_FI_ProgramaHorarioVerao: Integer;
begin
  Result := _Bematech_FI_ProgramaHorarioVerao;
end;

function TBemaFI.Bematech_FI_NomeiaDepartamento(Indice: Integer; Departamento: String): Integer;
begin
  Result := _Bematech_FI_NomeiaDepartamento(Indice, AnsiString(Departamento));
end;

function TBemaFI.Bematech_FI_ProgramaIdAplicativoMFD(
  sIDAplicativo: String): Integer;
//var
//  IDAplicativo: AnsiString;
begin
  //IDAplicativo := AnsiString(StringOfChar(#0, 84));
  //IDAplicativo := AnsiString(sIDAplicativo);
  Result := _Bematech_FI_ProgramaIdAplicativoMFD(AnsiString(sIDAplicativo));
end;

function TBemaFI.CarregaDLL: Boolean;
begin
  Result := False;
  try
    //ShowMessage(DLLName);  // 2015-06-16

    FDLLHandle     := LoadLibraryA(PAnsiChar(BEMAFI_DLL_NAME_02)); //carregando dll
    if FDLLHandle = 0 then
      raise Exception.Create('Não foi possível carregar a biblioteca ' + BEMAFI_DLL_NAME_02);

    //importando métodos dinamicamente
    Import(@_Bematech_FI_ProgramaIdAplicativoMFD, 'Bematech_FI_ProgramaIdAplicativoMFD');
    Import(@_Bematech_FI_AlteraSimboloMoeda, 'Bematech_FI_AlteraSimboloMoeda');
    Import(@_Bematech_FI_ProgramaAliquota, 'Bematech_FI_ProgramaAliquota');
    Import(@_Bematech_FI_ProgramaHorarioVerao, 'Bematech_FI_ProgramaHorarioVerao');
    Import(@_Bematech_FI_NomeiaDepartamento, 'Bematech_FI_NomeiaDepartamento');
    Import(@_Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms, 'Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms');
    Import(@_Bematech_FI_ProgramaArredondamento, 'Bematech_FI_ProgramaArredondamento');
    Import(@_Bematech_FI_ProgramaTruncamento, 'Bematech_FI_ProgramaTruncamento');
    Import(@_Bematech_FI_LinhasEntreCupons, 'Bematech_FI_LinhasEntreCupons');
    Import(@_Bematech_FI_EspacoEntreLinhas, 'Bematech_FI_EspacoEntreLinhas');
    Import(@_Bematech_FI_ForcaImpactoAgulhas, 'Bematech_FI_ForcaImpactoAgulhas');
    Import(@_Bematech_FI_AbreCupom, 'Bematech_FI_AbreCupom');
    Import(@_Bematech_FI_VendeItem, 'Bematech_FI_VendeItem');
    Import(@_Bematech_FI_VendeItemDepartamento, 'Bematech_FI_VendeItemDepartamento');
    Import(@_Bematech_FI_CancelaItemAnterior, 'Bematech_FI_CancelaItemAnterior');
    Import(@_Bematech_FI_CancelaItemGenerico, 'Bematech_FI_CancelaItemGenerico');
    Import(@_Bematech_FI_CancelaCupom, 'Bematech_FI_CancelaCupom');
    Import(@_Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD, 'Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD');
    Import(@_Bematech_FI_EstornoNaoFiscalVinculadoMFD, 'Bematech_FI_EstornoNaoFiscalVinculadoMFD');
    Import(@_Bematech_FI_FechaCupomResumido, 'Bematech_FI_FechaCupomResumido');
    Import(@_Bematech_FI_FechaCupom, 'Bematech_FI_FechaCupom');
    Import(@_Bematech_FI_ResetaImpressora, 'Bematech_FI_ResetaImpressora');
    Import(@_Bematech_FI_IniciaFechamentoCupom, 'Bematech_FI_IniciaFechamentoCupom');
    Import(@_Bematech_FI_EfetuaFormaPagamento, 'Bematech_FI_EfetuaFormaPagamento');
    Import(@_Bematech_FI_EfetuaFormaPagamentoDescricaoForma, 'Bematech_FI_EfetuaFormaPagamentoDescricaoForma');
    Import(@_Bematech_FI_TerminaFechamentoCupom, 'Bematech_FI_TerminaFechamentoCupom');
    Import(@_Bematech_FI_EstornoFormasPagamento, 'Bematech_FI_EstornoFormasPagamento');
    Import(@_Bematech_FI_UsaUnidadeMedida, 'Bematech_FI_UsaUnidadeMedida');
    Import(@_Bematech_FI_AumentaDescricaoItem, 'Bematech_FI_AumentaDescricaoItem');
    Import(@_Bematech_FI_LeituraX, 'Bematech_FI_LeituraX');
    Import(@_Bematech_FI_ReducaoZ, 'Bematech_FI_ReducaoZ');
    Import(@_Bematech_FI_RelatorioGerencial, 'Bematech_FI_RelatorioGerencial');
    Import(@_Bematech_FI_UsaRelatorioGerencialMFD, 'Bematech_FI_UsaRelatorioGerencialMFD');
    Import(@_Bematech_FI_FechaRelatorioGerencial, 'Bematech_FI_FechaRelatorioGerencial');
    Import(@_Bematech_FI_LeituraMemoriaFiscalData, 'Bematech_FI_LeituraMemoriaFiscalData');
    Import(@_Bematech_FI_LeituraMemoriaFiscalReducao, 'Bematech_FI_LeituraMemoriaFiscalReducao');
    Import(@_Bematech_FI_LeituraMemoriaFiscalSerialData, 'Bematech_FI_LeituraMemoriaFiscalSerialData');
    Import(@_Bematech_FI_LeituraMemoriaFiscalSerialReducao, 'Bematech_FI_LeituraMemoriaFiscalSerialReducao');
    Import(@_Bematech_FI_DownloadMFD, 'Bematech_FI_DownloadMFD');
    Import(@_Bematech_FI_FormatoDadosMFD, 'Bematech_FI_FormatoDadosMFD');
    Import(@_Bematech_FI_ArquivoMFD, 'Bematech_FI_ArquivoMFD');
    Import(@_Bematech_FI_DownloadMF, 'Bematech_FI_DownloadMF');
    Import(@_Bematech_FI_LeituraMemoriaFiscalDataMFD, 'Bematech_FI_LeituraMemoriaFiscalDataMFD');
    Import(@_Bematech_FI_LeituraMemoriaFiscalReducaoMFD, 'Bematech_FI_LeituraMemoriaFiscalReducaoMFD');
    Import(@_Bematech_FI_LeituraMemoriaFiscalSerialDataMFD, 'Bematech_FI_LeituraMemoriaFiscalSerialDataMFD');
    Import(@_Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD, 'Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD');
    Import(@_Bematech_FI_GeraRegistrosCAT52MFD, 'Bematech_FI_GeraRegistrosCAT52MFD');
    Import(@_Bematech_FI_GeraRegistrosCAT52MFDEx, 'Bematech_FI_GeraRegistrosCAT52MFDEx');
    Import(@_Bematech_FI_RecebimentoNaoFiscal, 'Bematech_FI_RecebimentoNaoFiscal');
    Import(@_Bematech_FI_AbreComprovanteNaoFiscalVinculado, 'Bematech_FI_AbreComprovanteNaoFiscalVinculado');
    Import(@_Bematech_FI_UsaComprovanteNaoFiscalVinculado, 'Bematech_FI_UsaComprovanteNaoFiscalVinculado');
    Import(@_Bematech_FI_FechaComprovanteNaoFiscalVinculado, 'Bematech_FI_FechaComprovanteNaoFiscalVinculado');
    Import(@_Bematech_FI_Sangria, 'Bematech_FI_Sangria');
    Import(@_Bematech_FI_Suprimento, 'Bematech_FI_Suprimento');
    Import(@_Bematech_FI_NumeroSerie, 'Bematech_FI_NumeroSerie');
    Import(@_Bematech_FI_NumeroSerieMFD, 'Bematech_FI_NumeroSerieMFD');
    Import(@_Bematech_FI_SubTotal, 'Bematech_FI_SubTotal');
    Import(@_Bematech_FI_NumeroCupom, 'Bematech_FI_NumeroCupom');
    Import(@_Bematech_FI_LeituraXSerial, 'Bematech_FI_LeituraXSerial');
    Import(@_Bematech_FI_VersaoFirmware, 'Bematech_FI_VersaoFirmware');
    Import(@_Bematech_FI_CGC_IE, 'Bematech_FI_CGC_IE');
    Import(@_Bematech_FI_GrandeTotal, 'Bematech_FI_GrandeTotal');
    Import(@_Bematech_FI_Cancelamentos, 'Bematech_FI_Cancelamentos');
    Import(@_Bematech_FI_Descontos, 'Bematech_FI_Descontos');
    Import(@_Bematech_FI_NumeroOperacoesNaoFiscais, 'Bematech_FI_NumeroOperacoesNaoFiscais');
    Import(@_Bematech_FI_NumeroCuponsCancelados, 'Bematech_FI_NumeroCuponsCancelados');
    Import(@_Bematech_FI_NumeroIntervencoes, 'Bematech_FI_NumeroIntervencoes');
    Import(@_Bematech_FI_NumeroReducoes, 'Bematech_FI_NumeroReducoes');
    Import(@_Bematech_FI_NumeroSubstituicoesProprietario, 'Bematech_FI_NumeroSubstituicoesProprietario');
    Import(@_Bematech_FI_UltimoItemVendido, 'Bematech_FI_UltimoItemVendido');
    Import(@_Bematech_FI_ClicheProprietario, 'Bematech_FI_ClicheProprietario');
    Import(@_Bematech_FI_NumeroCaixa, 'Bematech_FI_NumeroCaixa');
    Import(@_Bematech_FI_NumeroLoja, 'Bematech_FI_NumeroLoja');
    Import(@_Bematech_FI_SimboloMoeda, 'Bematech_FI_SimboloMoeda');
    Import(@_Bematech_FI_MinutosLigada, 'Bematech_FI_MinutosLigada');
    Import(@_Bematech_FI_MinutosImprimindo, 'Bematech_FI_MinutosImprimindo');
    Import(@_Bematech_FI_VerificaModoOperacao, 'Bematech_FI_VerificaModoOperacao');
    Import(@_Bematech_FI_VerificaEpromConectada, 'Bematech_FI_VerificaEpromConectada');
    Import(@_Bematech_FI_FlagsFiscais, 'Bematech_FI_FlagsFiscais');
    Import(@_Bematech_FI_ValorPagoUltimoCupom, 'Bematech_FI_ValorPagoUltimoCupom');
    Import(@_Bematech_FI_DataHoraImpressora, 'Bematech_FI_DataHoraImpressora');
    Import(@_Bematech_FI_VendaLiquida, 'Bematech_FI_VendaLiquida');
    Import(@_Bematech_FI_ContadoresTotalizadoresNaoFiscais, 'Bematech_FI_ContadoresTotalizadoresNaoFiscais');
    Import(@_Bematech_FI_ContadorCupomFiscalMFD, 'Bematech_FI_ContadorCupomFiscalMFD');
    Import(@_Bematech_FI_ContadorRelatoriosGerenciaisMFD, 'Bematech_FI_ContadorRelatoriosGerenciaisMFD');
    Import(@_Bematech_FI_ContadorComprovantesCreditoMFD, 'Bematech_FI_ContadorComprovantesCreditoMFD');
    Import(@_Bematech_FI_VerificaTotalizadoresNaoFiscais, 'Bematech_FI_VerificaTotalizadoresNaoFiscais');
    Import(@_Bematech_FI_DataHoraReducao, 'Bematech_FI_DataHoraReducao');
    Import(@_Bematech_FI_DataMovimento, 'Bematech_FI_DataMovimento');
    Import(@_Bematech_FI_VerificaTruncamento, 'Bematech_FI_VerificaTruncamento');
    Import(@_Bematech_FI_Acrescimos, 'Bematech_FI_Acrescimos');
    Import(@_Bematech_FI_ContadorBilhetePassagem, 'Bematech_FI_ContadorBilhetePassagem');
    Import(@_Bematech_FI_VerificaAliquotasIss, 'Bematech_FI_VerificaAliquotasIss');
    Import(@_Bematech_FI_VerificaFormasPagamento, 'Bematech_FI_VerificaFormasPagamento');
    Import(@_Bematech_FI_VerificaRecebimentoNaoFiscal, 'Bematech_FI_VerificaRecebimentoNaoFiscal');
    Import(@_Bematech_FI_VerificaDepartamentos, 'Bematech_FI_VerificaDepartamentos');
    Import(@_Bematech_FI_VerificaTipoImpressora, 'Bematech_FI_VerificaTipoImpressora');
    Import(@_Bematech_FI_VerificaTotalizadoresParciais, 'Bematech_FI_VerificaTotalizadoresParciais');
    Import(@_Bematech_FI_RetornoAliquotas, 'Bematech_FI_RetornoAliquotas');
    Import(@_Bematech_FI_VerificaEstadoImpressora, 'Bematech_FI_VerificaEstadoImpressora');
    Import(@_Bematech_FI_DadosUltimaReducao, 'Bematech_FI_DadosUltimaReducao');
    Import(@_Bematech_FI_MonitoramentoPapel, 'Bematech_FI_MonitoramentoPapel');
    Import(@_Bematech_FI_VerificaIndiceAliquotasIss, 'Bematech_FI_VerificaIndiceAliquotasIss');
    Import(@_Bematech_FI_ValorFormaPagamento, 'Bematech_FI_ValorFormaPagamento');
    Import(@_Bematech_FI_ValorTotalizadorNaoFiscal, 'Bematech_FI_ValorTotalizadorNaoFiscal');
    Import(@_Bematech_FI_MarcaModeloTipoImpressoraMFD, 'Bematech_FI_MarcaModeloTipoImpressoraMFD');
    Import(@_Bematech_FI_Autenticacao, 'Bematech_FI_Autenticacao');
    Import(@_Bematech_FI_ProgramaCaracterAutenticacao, 'Bematech_FI_ProgramaCaracterAutenticacao');
    Import(@_Bematech_FI_AcionaGaveta, 'Bematech_FI_AcionaGaveta');
    Import(@_Bematech_FI_VerificaEstadoGaveta, 'Bematech_FI_VerificaEstadoGaveta');
    Import(@_Bematech_FI_AbrePortaSerial, 'Bematech_FI_AbrePortaSerial');
    Import(@_Bematech_FI_AbrePorta, 'Bematech_FI_AbrePorta');
    Import(@_Bematech_FI_RetornoImpressora, 'Bematech_FI_RetornoImpressora');
    Import(@_Bematech_FI_FechaPortaSerial, 'Bematech_FI_FechaPortaSerial');
    Import(@_Bematech_FI_MapaResumo, 'Bematech_FI_MapaResumo');
    Import(@_Bematech_FI_AberturaDoDia, 'Bematech_FI_AberturaDoDia');
    Import(@_Bematech_FI_FechamentoDoDia, 'Bematech_FI_FechamentoDoDia');
    Import(@_Bematech_FI_ImprimeConfiguracoesImpressora, 'Bematech_FI_ImprimeConfiguracoesImpressora');
    Import(@_Bematech_FI_ImprimeDepartamentos, 'Bematech_FI_ImprimeDepartamentos');
    Import(@_Bematech_FI_RelatorioTipo60Analitico, 'Bematech_FI_RelatorioTipo60Analitico');
    Import(@_Bematech_FI_RelatorioTipo60Mestre, 'Bematech_FI_RelatorioTipo60Mestre');
    Import(@_Bematech_FI_VerificaImpressoraLigada, 'Bematech_FI_VerificaImpressoraLigada');
    Import(@_Bematech_FI_ImprimeCheque, 'Bematech_FI_ImprimeCheque');
    Import(@_Bematech_FI_SegundaViaNaoFiscalVinculadoMFD, 'Bematech_FI_SegundaViaNaoFiscalVinculadoMFD');
    Import(@_Bematech_FI_DadosUltimaReducaoMFD, 'Bematech_FI_DadosUltimaReducaoMFD');
    Import(@_Bematech_FI_NomeiaRelatorioGerencialMFD, 'Bematech_FI_NomeiaRelatorioGerencialMFD');
    Import(@_Bematech_FI_AbreRelatorioGerencialMFD, 'Bematech_FI_AbreRelatorioGerencialMFD');
    Import(@_Bematech_FI_VerificaRelatorioGerencialMFD, 'Bematech_FI_VerificaRelatorioGerencialMFD');
    Import(@_Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD, 'Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD');
    Import(@_Bematech_FI_RetornoImpressoraMFD, 'Bematech_FI_RetornoImpressoraMFD');

    Result := True;

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar comandos Bematech' + #13 + E.Message);
    end;
  end;

end;

constructor TBemaFI.Create(AOwner: TComponent);
begin
  inherited;

  //FDllName := 'BemaFI32.dll';

  FLoad := CarregaDLL;
end;

destructor TBemaFI.Destroy;
begin
  FinalizaDLL;
  inherited;
end;

procedure TBemaFI.FinalizaDLL;
begin
  _Bematech_FI_ProgramaIdAplicativoMFD := nil;
  _Bematech_FI_AlteraSimboloMoeda := nil;
  _Bematech_FI_ProgramaAliquota := nil;
  _Bematech_FI_ProgramaHorarioVerao := nil;
  _Bematech_FI_NomeiaDepartamento := nil;
  _Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms := nil;
  _Bematech_FI_ProgramaArredondamento := nil;
  _Bematech_FI_ProgramaTruncamento := nil;
  _Bematech_FI_LinhasEntreCupons := nil;
  _Bematech_FI_EspacoEntreLinhas := nil;
  _Bematech_FI_ForcaImpactoAgulhas := nil;
  _Bematech_FI_AbreCupom := nil;
  _Bematech_FI_VendeItem := nil;
  _Bematech_FI_VendeItemDepartamento := nil;
  _Bematech_FI_CancelaItemAnterior := nil;
  _Bematech_FI_CancelaItemGenerico := nil;
  _Bematech_FI_CancelaCupom := nil;
  _Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD := nil;
  _Bematech_FI_EstornoNaoFiscalVinculadoMFD := nil;
  _Bematech_FI_FechaCupomResumido := nil;
  _Bematech_FI_FechaCupom := nil;
  _Bematech_FI_ResetaImpressora := nil;
  _Bematech_FI_IniciaFechamentoCupom := nil;
  _Bematech_FI_EfetuaFormaPagamento := nil;
  _Bematech_FI_EfetuaFormaPagamentoDescricaoForma := nil;
  _Bematech_FI_TerminaFechamentoCupom := nil;
  _Bematech_FI_EstornoFormasPagamento := nil;
  _Bematech_FI_UsaUnidadeMedida := nil;
  _Bematech_FI_AumentaDescricaoItem := nil;
  _Bematech_FI_LeituraX := nil;
  _Bematech_FI_ReducaoZ := nil;
  _Bematech_FI_RelatorioGerencial := nil;
  _Bematech_FI_UsaRelatorioGerencialMFD := nil;
  _Bematech_FI_FechaRelatorioGerencial := nil;
  _Bematech_FI_LeituraMemoriaFiscalData := nil;
  _Bematech_FI_LeituraMemoriaFiscalReducao := nil;
  _Bematech_FI_LeituraMemoriaFiscalSerialData := nil;
  _Bematech_FI_LeituraMemoriaFiscalSerialReducao := nil;
  _Bematech_FI_DownloadMFD := nil;
  _Bematech_FI_FormatoDadosMFD := nil;
  _Bematech_FI_ArquivoMFD := nil;
  _Bematech_FI_DownloadMF := nil;
  _Bematech_FI_LeituraMemoriaFiscalDataMFD := nil;
  _Bematech_FI_LeituraMemoriaFiscalReducaoMFD := nil;
  _Bematech_FI_LeituraMemoriaFiscalSerialDataMFD := nil;
  _Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD := nil;
  _Bematech_FI_GeraRegistrosCAT52MFD := nil;
  _Bematech_FI_GeraRegistrosCAT52MFDEx := nil;
  _Bematech_FI_RecebimentoNaoFiscal := nil;
  _Bematech_FI_AbreComprovanteNaoFiscalVinculado := nil;
  _Bematech_FI_UsaComprovanteNaoFiscalVinculado := nil;
  _Bematech_FI_FechaComprovanteNaoFiscalVinculado := nil;
  _Bematech_FI_Sangria := nil;
  _Bematech_FI_Suprimento := nil;
  _Bematech_FI_NumeroSerie := nil;
  _Bematech_FI_NumeroSerieMFD := nil;
  _Bematech_FI_SubTotal := nil;
  _Bematech_FI_NumeroCupom := nil;
  _Bematech_FI_LeituraXSerial := nil;
  _Bematech_FI_VersaoFirmware := nil;
  _Bematech_FI_CGC_IE := nil;
  _Bematech_FI_GrandeTotal := nil;
  _Bematech_FI_Cancelamentos := nil;
  _Bematech_FI_Descontos := nil;
  _Bematech_FI_NumeroOperacoesNaoFiscais := nil;
  _Bematech_FI_NumeroCuponsCancelados := nil;
  _Bematech_FI_NumeroIntervencoes := nil;
  _Bematech_FI_NumeroReducoes := nil;
  _Bematech_FI_NumeroSubstituicoesProprietario := nil;
  _Bematech_FI_UltimoItemVendido := nil;
  _Bematech_FI_ClicheProprietario := nil;
  _Bematech_FI_NumeroCaixa := nil;
  _Bematech_FI_NumeroLoja := nil;
  _Bematech_FI_SimboloMoeda := nil;
  _Bematech_FI_MinutosLigada := nil;
  _Bematech_FI_MinutosImprimindo := nil;
  _Bematech_FI_VerificaModoOperacao := nil;
  _Bematech_FI_VerificaEpromConectada := nil;
  _Bematech_FI_FlagsFiscais := nil;
  _Bematech_FI_ValorPagoUltimoCupom := nil;
  _Bematech_FI_DataHoraImpressora := nil;
  _Bematech_FI_VendaLiquida := nil;
  _Bematech_FI_ContadoresTotalizadoresNaoFiscais := nil;
  _Bematech_FI_ContadorCupomFiscalMFD := nil;
  _Bematech_FI_ContadorRelatoriosGerenciaisMFD := nil;
  _Bematech_FI_ContadorComprovantesCreditoMFD := nil;
  _Bematech_FI_VerificaTotalizadoresNaoFiscais := nil;
  _Bematech_FI_DataHoraReducao := nil;
  _Bematech_FI_DataMovimento := nil;
  _Bematech_FI_VerificaTruncamento := nil;
  _Bematech_FI_Acrescimos := nil;
  _Bematech_FI_ContadorBilhetePassagem := nil;
  _Bematech_FI_VerificaAliquotasIss := nil;
  _Bematech_FI_VerificaFormasPagamento := nil;
  _Bematech_FI_VerificaRecebimentoNaoFiscal := nil;
  _Bematech_FI_VerificaDepartamentos := nil;
  _Bematech_FI_VerificaTipoImpressora := nil;
  _Bematech_FI_VerificaTotalizadoresParciais := nil;
  _Bematech_FI_RetornoAliquotas := nil;
  _Bematech_FI_VerificaEstadoImpressora := nil;
  _Bematech_FI_DadosUltimaReducao := nil;
  _Bematech_FI_MonitoramentoPapel := nil;
  _Bematech_FI_VerificaIndiceAliquotasIss := nil;
  _Bematech_FI_ValorFormaPagamento := nil;
  _Bematech_FI_ValorTotalizadorNaoFiscal := nil;
  _Bematech_FI_MarcaModeloTipoImpressoraMFD := nil;
  _Bematech_FI_Autenticacao := nil;
  _Bematech_FI_ProgramaCaracterAutenticacao := nil;
  _Bematech_FI_AcionaGaveta := nil;
  _Bematech_FI_VerificaEstadoGaveta := nil;
  _Bematech_FI_AbrePortaSerial := nil;
  _Bematech_FI_AbrePorta := nil;
  _Bematech_FI_RetornoImpressora := nil;
  _Bematech_FI_FechaPortaSerial := nil;
  _Bematech_FI_MapaResumo := nil;
  _Bematech_FI_AberturaDoDia := nil;
  _Bematech_FI_FechamentoDoDia := nil;
  _Bematech_FI_ImprimeConfiguracoesImpressora := nil;
  _Bematech_FI_ImprimeDepartamentos := nil;
  _Bematech_FI_RelatorioTipo60Analitico := nil;
  _Bematech_FI_RelatorioTipo60Mestre := nil;
  _Bematech_FI_VerificaImpressoraLigada := nil;
  _Bematech_FI_ImprimeCheque := nil;
  _Bematech_FI_SegundaViaNaoFiscalVinculadoMFD := nil;
  _Bematech_FI_DadosUltimaReducaoMFD := nil;
  _Bematech_FI_NomeiaRelatorioGerencialMFD := nil;
  _Bematech_FI_AbreRelatorioGerencialMFD := nil;
  _Bematech_FI_VerificaRelatorioGerencialMFD := nil;
  _Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD := nil;
  _Bematech_FI_RetornoImpressoraMFD := nil;
end;

procedure TBemaFI.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FDLLHandle, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + BEMAFI_DLL_NAME_02);
  end;
end;

procedure TBemaFI.SleepEntreMetodos;
begin
  //if AnsiContainsText(Form1.sModeloFabricante, '4200 TH') then
    Sleep(200);
end;

{ TBemaMFD }

procedure TBemaMFD.CarregaDLL;
begin
  try
    //ShowMessage(DLLName);  // 2015-06-16

    FDLLHandle     := LoadLibraryA(PAnsiChar(BEMAMFD2_DLL_NAME)); //carregando dll
    if FDLLHandle = 0 then
      raise Exception.Create('Não foi possível carregar a biblioteca ' + BEMAMFD2_DLL_NAME);

    //importando métodos dinamicamente
    Import(@_BemaGeraRegistrosTipoE, 'BemaGeraRegistrosTipoE');

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar comandos Bematech' + #13 + E.Message);
    end;
  end;

end;

constructor TBemaMFD.Create(AOwner: TComponent);
begin
  inherited;
  //FDllName := 'BEMAMFD2.DLL';
  CarregaDLL;
end;

destructor TBemaMFD.Destroy;
begin
  FinalizaDLL;
  inherited;
end;

procedure TBemaMFD.FinalizaDLL;
begin
  _BemaGeraRegistrosTipoE := nil;
end;

procedure TBemaMFD.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FDLLHandle, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + BEMAMFD2_DLL_NAME);
  end;

end;

function TBemaFI.Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(
  Indice: Integer; Totalizador: String): Integer;
begin
  Result := _Bematech_FI_NomeiaTotalizadorNaoSujeitoIcms(Indice, AnsiString(Totalizador)); 
end;

function TBemaFI.Bematech_FI_ProgramaArredondamento: Integer;
begin
  Result := _Bematech_FI_ProgramaArredondamento;
end;

function TBemaFI.Bematech_FI_ProgramaTruncamento: Integer;
begin
  Result := _Bematech_FI_ProgramaTruncamento; 
end;

function TBemaFI.Bematech_FI_LinhasEntreCupons(Linhas: Integer): Integer;
begin
  Result := _Bematech_FI_LinhasEntreCupons(Linhas); 
end;

function TBemaFI.Bematech_FI_EspacoEntreLinhas(Dots: Integer): Integer;
begin
  Result := _Bematech_FI_EspacoEntreLinhas(Dots); 
end;

function TBemaFI.Bematech_FI_ForcaImpactoAgulhas(
  ForcaImpacto: Integer): Integer;
begin
  Result := _Bematech_FI_ForcaImpactoAgulhas(ForcaImpacto);
end;

function TBemaFI.Bematech_FI_AbreCupom(CGC_CPF: String): Integer;
begin
  Result := _Bematech_FI_AbreCupom(AnsiString(CGC_CPF)); 
end;

function TBemaFI.Bematech_FI_VendeItem(Codigo, Descricao, Aliquota,
  TipoQuantidade, Quantidade: String; CasasDecimais: Integer;
  ValorUnitario, TipoDesconto, Desconto: String): Integer;
begin
  Result := _Bematech_FI_VendeItem(AnsiString(Codigo), AnsiString(Descricao), AnsiString(Aliquota), AnsiString(TipoQuantidade), AnsiString(Quantidade), CasasDecimais, AnsiString(ValorUnitario), AnsiString(TipoDesconto), AnsiString(Desconto));
end;

function TBemaFI.Bematech_FI_VendeItemDepartamento(Codigo, Descricao,
  Aliquota, ValorUnitario, Quantidade, Acrescimo, Desconto,
  IndiceDepartamento, UnidadeMedida: String): Integer;
begin
  Result :=_Bematech_FI_VendeItemDepartamento(AnsiString(Codigo), AnsiString(Descricao), AnsiString(Aliquota), AnsiString(ValorUnitario), AnsiString(Quantidade), AnsiString(Acrescimo), AnsiString(Desconto), AnsiString(IndiceDepartamento), AnsiString(UnidadeMedida));
end;

function TBemaFI.Bematech_FI_CancelaItemAnterior: Integer;
begin
  Result := _Bematech_FI_CancelaItemAnterior;
end;

function TBemaFI.Bematech_FI_CancelaItemGenerico(
  NumeroItem: String): Integer;
begin
  Result := _Bematech_FI_CancelaItemGenerico(AnsiString(NumeroItem)); 
end;

function TBemaFI.Bematech_FI_CancelaCupom: Integer;
begin
  Result := _Bematech_FI_CancelaCupom;
end;

function TBemaFI.Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD(
  FormaPagamento, Valor, COOCupom, COOCDC, CPF, Nome,
  Endereco: String): Integer;
begin
  Result := _Bematech_FI_EstornoNaoFiscalVinculadoPosteriorMFD(AnsiString(FormaPagamento), AnsiString(Valor), AnsiString(COOCupom), AnsiString(COOCDC), AnsiString(CPF), AnsiString(Nome), AnsiString(Endereco));
end;

function TBemaFI.Bematech_FI_EstornoNaoFiscalVinculadoMFD(CPF, Nome,
  Endereco: String): Integer;
begin
  Result := _Bematech_FI_EstornoNaoFiscalVinculadoMFD(AnsiString(CPF), AnsiString(Nome), AnsiString(Endereco));
end;

function TBemaFI.Bematech_FI_FechaCupomResumido(FormaPagamento,
  Mensagem: String): Integer;
begin
  Result := _Bematech_FI_FechaCupomResumido(AnsiString(FormaPagamento), AnsiString(Mensagem));
end;

function TBemaFI.Bematech_FI_FechaCupom(FormaPagamento, AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto, ValorPago,
  Mensagem: String): Integer;
begin
  Result := _Bematech_FI_FechaCupom(AnsiString(FormaPagamento), AnsiString(AcrescimoDesconto), AnsiString(TipoAcrescimoDesconto), AnsiString(ValorAcrescimoDesconto), AnsiString(ValorPago), AnsiString(Mensagem)); 
end;

function TBemaFI.Bematech_FI_ResetaImpressora: Integer;
begin
  Result := _Bematech_FI_ResetaImpressora;
end;

function TBemaFI.Bematech_FI_IniciaFechamentoCupom(AcrescimoDesconto,
  TipoAcrescimoDesconto, ValorAcrescimoDesconto: String): Integer;
begin
  Result := _Bematech_FI_IniciaFechamentoCupom(AnsiString(AcrescimoDesconto), AnsiString(TipoAcrescimoDesconto), AnsiString(ValorAcrescimoDesconto)); 
end;

function TBemaFI.Bematech_FI_EfetuaFormaPagamento(FormaPagamento,
  ValorFormaPagamento: String): Integer;
begin
  Result := _Bematech_FI_EfetuaFormaPagamento(AnsiString(FormaPagamento), AnsiString(ValorFormaPagamento)); 
end;

function TBemaFI.Bematech_FI_EfetuaFormaPagamentoDescricaoForma(
  FormaPagamento, ValorFormaPagamento,
  DescricaoFormaPagto: String): Integer;
begin
  Result := _Bematech_FI_EfetuaFormaPagamentoDescricaoForma(AnsiString(FormaPagamento), AnsiString(ValorFormaPagamento), AnsiString(DescricaoFormaPagto)); 
end;

function TBemaFI.Bematech_FI_TerminaFechamentoCupom(
  Mensagem: String): Integer;
begin
  Result := _Bematech_FI_TerminaFechamentoCupom(AnsiString(Mensagem)); 
end;

function TBemaFI.Bematech_FI_EstornoFormasPagamento(FormaOrigem,
  FormaDestino, Valor: String): Integer;
begin
  Result := _Bematech_FI_EstornoFormasPagamento(AnsiString(FormaOrigem), AnsiString(FormaDestino), AnsiString(Valor)); 
end;

function TBemaFI.Bematech_FI_UsaUnidadeMedida(
  UnidadeMedida: String): Integer;
begin
  Result := _Bematech_FI_UsaUnidadeMedida(AnsiString(UnidadeMedida)); 
end;

function TBemaFI.Bematech_FI_AumentaDescricaoItem(
  Descricao: String): Integer;
begin
  Result := _Bematech_FI_AumentaDescricaoItem(AnsiString(Descricao)); 
end;

function TBemaFI.Bematech_FI_LeituraX: Integer;
begin
  Result := _Bematech_FI_LeituraX;
end;

function TBemaFI.Bematech_FI_ReducaoZ(Data, Hora: String): Integer;
begin
  Result := _Bematech_FI_ReducaoZ(AnsiString(Data), AnsiString(Hora));
end;

function TBemaFI.Bematech_FI_RelatorioGerencial(Texto: String): Integer;
begin
  Result := _Bematech_FI_RelatorioGerencial(AnsiString(Texto)); 
end;

function TBemaFI.Bematech_FI_UsaRelatorioGerencialMFD(
  Texto: String): Integer;
begin
  Result := _Bematech_FI_UsaRelatorioGerencialMFD(AnsiString(Texto));
end;

function TBemaFI.Bematech_FI_FechaRelatorioGerencial: Integer;
begin
  Result := _Bematech_FI_FechaRelatorioGerencial;
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalData(AnsiString(DataInicial), AnsiString(DataFinal)); 
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalReducao(ReducaoInicial,
  ReducaoFinal: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalReducao(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal));
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalSerialData(DataInicial,
  DataFinal: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalSerialData(AnsiString(DataInicial), AnsiString(DataFinal)); 
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalSerialReducao(
  ReducaoInicial, ReducaoFinal: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalSerialReducao(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal));
end;

function TBemaFI.Bematech_FI_DownloadMFD(sArquivo, sTipo, DataInicial,
  DataFinal, sUsuario: String): Integer;
begin
  Result := _Bematech_FI_DownloadMFD(AnsiString(sArquivo), AnsiString(sTipo), AnsiString(DataInicial), AnsiString(DataFinal), AnsiString(sUsuario)); 
end;

function TBemaFI.Bematech_FI_FormatoDadosMFD(ArquivoOrigem, ArquivoDestino,
  TipoFormato, TipoDownload, ParametroInicial, ParametroFinal,
  UsuarioECF: String): Integer;
begin
  Result := _Bematech_FI_FormatoDadosMFD(AnsiString(ArquivoOrigem), AnsiString(ArquivoDestino), AnsiString(TipoFormato), AnsiString(TipoDownload), AnsiString(ParametroInicial), AnsiString(ParametroFinal), AnsiString(UsuarioECF)); 
end;

function TBemaFI.Bematech_FI_ArquivoMFD(cNomeArquivoOrigem, cDadoInicial,
  cDadoFinal, cTipoDownload, cUsuario: String; iTipoGeracao: Integer;
  cChavePublica, cChavePrivada: String; iUnicoArquivo: Integer): Integer;
begin
  Result := _Bematech_FI_ArquivoMFD(AnsiString(cNomeArquivoOrigem), AnsiString(cDadoInicial), AnsiString(cDadoFinal), AnsiString(cTipoDownload), AnsiString(cUsuario), iTipoGeracao, AnsiString(cChavePublica), AnsiString(cChavePrivada), iUnicoArquivo); 
end;

function TBemaFI.Bematech_FI_DownloadMF(Arquivo: String): Integer;
var
  asArquivo: AnsiString;
begin
  asArquivo := AnsiString(Arquivo);
  Result := _Bematech_FI_DownloadMF(Arquivo); // Result := _Bematech_FI_DownloadMF(AnsiString(Arquivo));
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalDataMFD(DataInicial,
  DataFinal, FlagLeitura: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalDataMFD(AnsiString(DataInicial), AnsiString(DataFinal), AnsiString(FlagLeitura)); 
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalReducaoMFD(ReducaoInicial,
  ReducaoFinal, FlagLeitura: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalReducaoMFD(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal), AnsiString(FlagLeitura));
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(DataInicial,
  DataFinal, FlagLeitura: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalSerialDataMFD(AnsiString(DataInicial), AnsiString(DataFinal), AnsiString(FlagLeitura)); 
end;

function TBemaFI.Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(
  ReducaoInicial, ReducaoFinal, FlagLeitura: String): Integer;
begin
  Result := _Bematech_FI_LeituraMemoriaFiscalSerialReducaoMFD(AnsiString(ReducaoInicial), AnsiString(ReducaoFinal), AnsiString(FlagLeitura)); 
end;

function TBemaFI.Bematech_FI_GeraRegistrosCAT52MFD(cArquivo,
  cData: String): Integer;
begin
  Result := _Bematech_FI_GeraRegistrosCAT52MFD(AnsiString(cArquivo), AnsiString(cData)); 
end;

function TBemaFI.Bematech_FI_GeraRegistrosCAT52MFDEx(cArquivo, cData,
  cArqDestino: String): Integer;
begin
  Result := _Bematech_FI_GeraRegistrosCAT52MFDEx(AnsiString(cArquivo), AnsiString(cData), AnsiString(cArqDestino)); 
end;

function TBemaFI.Bematech_FI_RecebimentoNaoFiscal(IndiceTotalizador, Valor,
  FormaPagamento: String): Integer;
begin
  Result := _Bematech_FI_RecebimentoNaoFiscal(AnsiString(IndiceTotalizador), AnsiString(Valor), AnsiString(FormaPagamento)); 
end;

function TBemaFI.Bematech_FI_AbreComprovanteNaoFiscalVinculado(
  FormaPagamento, Valor, NumeroCupom: String): Integer;
begin
  Result := _Bematech_FI_AbreComprovanteNaoFiscalVinculado(AnsiString(FormaPagamento), AnsiString(Valor), AnsiString(NumeroCupom)); 
end;

function TBemaFI.Bematech_FI_UsaComprovanteNaoFiscalVinculado(
  Texto: String): Integer;
begin
  Result := _Bematech_FI_UsaComprovanteNaoFiscalVinculado(AnsiString(Texto)); 
end;

function TBemaFI.Bematech_FI_FechaComprovanteNaoFiscalVinculado: Integer;
begin
  Result := _Bematech_FI_FechaComprovanteNaoFiscalVinculado;
end;

function TBemaFI.Bematech_FI_Sangria(Valor: String): Integer;
begin
  Result := _Bematech_FI_Sangria(AnsiString(Valor)); 
end;

function TBemaFI.Bematech_FI_Suprimento(Valor,
  FormaPagamento: String): Integer;
begin
  Result := _Bematech_FI_Suprimento(AnsiString(Valor), AnsiString(FormaPagamento));
end;

function TBemaFI.Bematech_FI_NumeroSerie(var NumeroSerie: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 20));
  Result := _Bematech_FI_NumeroSerie(asInfo);
  NumeroSerie := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroSerieMFD(
  var NumeroSerie: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 20));
  Result := _Bematech_FI_NumeroSerieMFD(asInfo);
  NumeroSerie := String(asInfo);
end;

function TBemaFI.Bematech_FI_SubTotal(var SubTotal: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_SubTotal(asInfo);
  SubTotal := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroCupom(var NumeroCupom: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_NumeroCupom(asInfo);
  NumeroCupom := String(asInfo);
end;

function TBemaFI.Bematech_FI_LeituraXSerial: Integer;
begin
  Result := _Bematech_FI_LeituraXSerial;
end;

function TBemaFI.Bematech_FI_VersaoFirmware(
  var VersaoFirmware: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_VersaoFirmware(asinfo);
  VersaoFirmware := String(asInfo);
end;

function TBemaFI.Bematech_FI_CGC_IE(var CGC: String; var IE: String): Integer;
var
  asCGC: AnsiString;
  asIE: AnsiString;
begin
  asCGC := AnsiString(StringOfChar(#0, 18));
  asIE  := AnsiString(StringOfChar(#0, 15));

  Result := _Bematech_FI_CGC_IE(asCGC, asIE);
  CGC := String(asCGC);
  IE  := String(asIE);
end;

function TBemaFI.Bematech_FI_GrandeTotal(var GrandeTotal: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 18));
  Result := _Bematech_FI_GrandeTotal(asInfo);
  GrandeTotal := String(asInfo);
end;

function TBemaFI.Bematech_FI_Cancelamentos(
  var ValorCancelamentos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_Cancelamentos(asInfo);
  ValorCancelamentos := String(asInfo);
end;

function TBemaFI.Bematech_FI_Descontos(
  var ValorDescontos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 15));
  Result := _Bematech_FI_Descontos(asInfo);
  ValorDescontos := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroOperacoesNaoFiscais(
  var NumeroOperacoes: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_NumeroOperacoesNaoFiscais(asInfo);
  NumeroOperacoes := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroIntervencoes(
  var NumeroIntervencoes: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_NumeroIntervencoes(asInfo);
  NumeroIntervencoes := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroReducoes(
  var NumeroReducoes: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_NumeroReducoes(asInfo);
  NumeroReducoes := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroSubstituicoesProprietario(
  var NumeroSubstituicoes: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 5));
  Result := _Bematech_FI_NumeroSubstituicoesProprietario(asInfo);
  NumeroSubstituicoes := String(asInfo);
end;

function TBemaFI.Bematech_FI_UltimoItemVendido(
  var NumeroItem: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_UltimoItemVendido(asInfo);
  NumeroItem := String(asInfo);
end;

function TBemaFI.Bematech_FI_ClicheProprietario(Cliche: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 186));
  Result := _Bematech_FI_ClicheProprietario(asInfo);
  Cliche := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroCaixa(var NumeroCaixa: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_NumeroCaixa(asInfo);
  NumeroCaixa := String(asInfo);
end;

function TBemaFI.Bematech_FI_NumeroLoja(var NumeroLoja: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_NumeroLoja(asInfo);
  NumeroLoja := String(asInfo);
end;

function TBemaFI.Bematech_FI_SimboloMoeda(
  var SimboloMoeda: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 2));
  Result := _Bematech_FI_SimboloMoeda(asInfo);
  SimboloMoeda := String(asInfo);
end;

function TBemaFI.Bematech_FI_MinutosLigada(var Minutos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_MinutosLigada(asInfo);
  Minutos := String(asInfo);
end;

function TBemaFI.Bematech_FI_MinutosImprimindo(var Minutos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 4));
  Result := _Bematech_FI_MinutosImprimindo(asInfo);
  Minutos := String(Minutos);
end;

function TBemaFI.Bematech_FI_VerificaModoOperacao(
  var Modo: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 1));
  Result := _Bematech_FI_VerificaModoOperacao(asInfo);
  Modo := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaEpromConectada(
  var Flag: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 1));
  Result := _Bematech_FI_VerificaEpromConectada(asInfo);
  Flag := asInfo;
end;

function TBemaFI.Bematech_FI_FlagsFiscais(var Flag: Integer): Integer;
begin
  Result := _Bematech_FI_FlagsFiscais(Flag);
end;

function TBemaFI.Bematech_FI_ValorPagoUltimoCupom(
  var ValorCupom: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_ValorPagoUltimoCupom(asInfo);
  ValorCupom := String(ValorCupom);
end;

function TBemaFI.Bematech_FI_DataHoraImpressora(var Data,
  Hora: String): Integer;
var
  asData: AnsiString;
  asHora: AnsiString;
begin
  asData := AnsiString(StringOfChar(#0, 6));
  asHora := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_DataHoraImpressora(asData, asHora);
  Data := String(asData);
  Hora := String(asHora);
end;

function TBemaFI.Bematech_FI_VendaLiquida(Valor: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_VendaLiquida(asInfo);
  Valor := String(Valor);
end;

function TBemaFI.Bematech_FI_ContadoresTotalizadoresNaoFiscais(
  var Contadores: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 44));
  Result := _Bematech_FI_ContadoresTotalizadoresNaoFiscais(asInfo);
  Contadores := String(asInfo);
end;

function TBemaFI.Bematech_FI_ContadorCupomFiscalMFD(
  var CuponsEmitidos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_ContadorCupomFiscalMFD(asInfo);
  CuponsEmitidos := String(CuponsEmitidos);
end;

function TBemaFI.Bematech_FI_ContadorRelatoriosGerenciaisMFD(
  var Relatorios: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 7));
  Result := _Bematech_FI_ContadorRelatoriosGerenciaisMFD(asInfo);
  Relatorios := String(asInfo);
end;

function TBemaFI.Bematech_FI_ContadorComprovantesCreditoMFD(
  var Comprovantes: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 5));
  Result := _Bematech_FI_ContadorComprovantesCreditoMFD(asInfo);
  Comprovantes := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaTotalizadoresNaoFiscais(
  var Totalizadores: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 180));
  Result := _Bematech_FI_VerificaTotalizadoresNaoFiscais(asInfo);
  Totalizadores := String(asInfo);
end;

function TBemaFI.Bematech_FI_DataHoraReducao(var Data,
  Hora: String): Integer;
var
  asData: AnsiString;
  asHora: AnsiString;
begin
  {
  asData := AnsiString(StringOfChar(#0, 6));
  asHora := AnsiString(StringOfChar(#0, 6));
  }
  asData := AnsiString(Data);
  asHora := AnsiString(hora);
  Result := _Bematech_FI_DataHoraReducao(asData, asHora);
  Data := String(asData);
  Hora := String(asHora);
end;

function TBemaFI.Bematech_FI_DataMovimento(var Data: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_DataMovimento(asInfo);
  asInfo := String(Data);
end;

function TBemaFI.Bematech_FI_VerificaTruncamento(
  var Flag: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 1));
  Result := _Bematech_FI_VerificaTruncamento(asInfo);
  Flag := String(asInfo);
end;

function TBemaFI.Bematech_FI_Acrescimos(
  var ValorAcrescimos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_Acrescimos(asInfo);
  ValorAcrescimos := String(asInfo);
end;

function TBemaFI.Bematech_FI_ContadorBilhetePassagem(
  var ContadorPassagem: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 6));
  Result := _Bematech_FI_ContadorBilhetePassagem(asInfo);
  ContadorPassagem := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaAliquotasIss(
  var Flag: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 79));
  Result := _Bematech_FI_VerificaAliquotasIss(asInfo);
  Flag := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaFormasPagamento(
  var Formas: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 3016));
  Result := _Bematech_FI_VerificaFormasPagamento(asInfo);
  Formas := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaRecebimentoNaoFiscal(
  var Recebimentos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 2021));
  Result := _Bematech_FI_VerificaRecebimentoNaoFiscal(asInfo);
  Recebimentos := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaDepartamentos(
  var Departamentos: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 2021));
  Result := _Bematech_FI_VerificaDepartamentos(Departamentos);
end;

function TBemaFI.Bematech_FI_VerificaTipoImpressora(
  var TipoImpressora: Integer): Integer;
begin
  Result := _Bematech_FI_VerificaTipoImpressora(TipoImpressora);
end;

function TBemaFI.Bematech_FI_VerificaTotalizadoresParciais(
  var Totalizadores: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 445));
  Result := _Bematech_FI_VerificaTotalizadoresParciais(asInfo);
  Totalizadores := String(asInfo);
end;

function TBemaFI.Bematech_FI_RetornoAliquotas(var Aliquotas: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar('0', 79));
  Result := _Bematech_FI_RetornoAliquotas(asInfo);
  Aliquotas := String(asInfo);
end;

function TBemaFI.Bematech_FI_VerificaEstadoImpressora(var ACK, ST1,
  ST2: Integer): Integer;
begin
  Result := _Bematech_FI_VerificaEstadoImpressora(ACK, ST1, ST2);
end;

function TBemaFI.Bematech_FI_DadosUltimaReducao(
  var DadosReducao: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 631));
  Result := _Bematech_FI_DadosUltimaReducao(asInfo);
  DadosReducao := String(asInfo);
end;

function TBemaFI.Bematech_FI_MonitoramentoPapel(
  var Linhas: Integer): Integer;
begin
  Result := _Bematech_FI_MonitoramentoPapel(Linhas);
end;

function TBemaFI.Bematech_FI_VerificaIndiceAliquotasIss(
  var Flag: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar('0', 48));
  Result := _Bematech_FI_VerificaIndiceAliquotasIss(asInfo);
  Flag := String(asInfo);
end;

function TBemaFI.Bematech_FI_ValorFormaPagamento(var FormaPagamento,
  Valor: String): Integer;
var
  asForma: AnsiString;
  asValor: AnsiString;
begin
  asForma := AnsiString(StringOfChar(#0, 16));
  asValor := AnsiString(StringOfChar(#0, 14));
  Result := _Bematech_FI_ValorFormaPagamento(asForma, asValor);
  FormaPagamento := String(asForma);
  Valor          := String(asValor);
end;

function TBemaFI.Bematech_FI_ValorTotalizadorNaoFiscal(var Totalizador,
  Valor: String): Integer;
var
  asTotal: AnsiString;
  asValor: AnsiString;
begin
  asTotal := AnsiString(StringOfChar(#0, 19));
  asValor := AnsiString(StringOfChar(#0, 15));
  Result := _Bematech_FI_ValorTotalizadorNaoFiscal(asTotal, asValor);
  Totalizador := String(asTotal);
  Valor := String(asValor);
end;

function TBemaFI.Bematech_FI_MarcaModeloTipoImpressoraMFD(var Marca,
  Modelo, Tipo: String): Integer;
var
  asMarca: AnsiString;
  asModelo: AnsiString;
  asTipo: AnsiString;
begin
  {
  asMarca := AnsiString(StringOfChar(#0, 15));
  asModelo := AnsiString(StringOfChar(#0, 20));
  asTipo := AnsiString(StringOfChar(#0, 7));
  }
  asMarca := AnsiString(Marca);
  asModelo := AnsiString(Modelo);
  asTipo := AnsiString(Tipo);
  Result := _Bematech_FI_MarcaModeloTipoImpressoraMFD(asMarca, asModelo, asTipo);
  Marca  := String(asMarca);
  Modelo := String(asModelo);
  Tipo   := String(asTipo);
end;

function TBemaFI.Bematech_FI_Autenticacao: Integer;
begin
  Result := _Bematech_FI_Autenticacao;
end;

function TBemaFI.Bematech_FI_ProgramaCaracterAutenticacao(
  Parametros: String): Integer;
begin
  Result := 1; //_Bematech_FI_ProgramaCaracterAutenticacao(Parametros);
end;

function TBemaFI.Bematech_FI_AcionaGaveta: Integer;
begin
  Result := _Bematech_FI_AcionaGaveta;
end;

function TBemaFI.Bematech_FI_VerificaEstadoGaveta(
  var EstadoGaveta: Integer): Integer;
begin
  Result := _Bematech_FI_VerificaEstadoGaveta(EstadoGaveta);
end;

function TBemaFI.Bematech_FI_AbrePortaSerial: Integer;
begin
  Result := _Bematech_FI_AbrePortaSerial;
end;

function TBemaFI.Bematech_FI_AbrePorta(numero: Integer): Integer;
begin
  Result := _Bematech_FI_AbrePorta(numero); 
end;

function TBemaFI.Bematech_FI_RetornoImpressora(var ACK, ST1,
  ST2: Integer): Integer;
begin
  Result := _Bematech_FI_RetornoImpressora(ACK, ST1, ST2);
end;

function TBemaFI.Bematech_FI_FechaPortaSerial: Integer;
begin
  Result := _Bematech_FI_FechaPortaSerial; 
end;

function TBemaFI.Bematech_FI_MapaResumo: Integer;
begin
  Result := _Bematech_FI_MapaResumo;
end;

function TBemaFI.Bematech_FI_AberturaDoDia(var ValorCompra,
  FormaPagamento: String): Integer;
var
  asValor: AnsiString;
  asForma: AnsiString;
begin
  asValor := AnsiString(StringOfChar(#0, 14));
  asForma := AnsiString(StringOfChar(#0, 16));
  Result := _Bematech_FI_AberturaDoDia(asValor, asForma);
  FormaPagamento := String(asForma);
  ValorCompra    := String(asValor);
end;

function TBemaFI.Bematech_FI_FechamentoDoDia: Integer;
begin
  Result := _Bematech_FI_FechamentoDoDia; 
end;

function TBemaFI.Bematech_FI_ImprimeConfiguracoesImpressora: Integer;
begin
  Result := _Bematech_FI_ImprimeConfiguracoesImpressora; 
end;

function TBemaFI.Bematech_FI_ImprimeDepartamentos: Integer;
begin
  Result := _Bematech_FI_ImprimeDepartamentos; 
end;

function TBemaFI.Bematech_FI_RelatorioTipo60Analitico: Integer;
begin
   Result := _Bematech_FI_RelatorioTipo60Analitico; 
end;

function TBemaFI.Bematech_FI_RelatorioTipo60Mestre: Integer;
begin
  Result := _Bematech_FI_RelatorioTipo60Mestre;
end;

function TBemaFI.Bematech_FI_VerificaImpressoraLigada: Integer;
begin
  Result := _Bematech_FI_VerificaImpressoraLigada;
end;

function TBemaFI.Bematech_FI_ImprimeCheque(Banco, Valor, Favorecido,
  Cidade, Data, Mensagem: String): Integer;
begin
  Result := _Bematech_FI_ImprimeCheque(AnsiString(Banco), AnsiString(Valor), AnsiString(Favorecido), AnsiString(Cidade), AnsiString(Data), AnsiString(Mensagem)); 
end;

function TBemaFI.Bematech_FI_SegundaViaNaoFiscalVinculadoMFD: Integer;
begin
  Result := _Bematech_FI_SegundaViaNaoFiscalVinculadoMFD;
end;

function TBemaFI.Bematech_FI_DadosUltimaReducaoMFD(
  var DadosReducao: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 1278));
  Result := _Bematech_FI_DadosUltimaReducaoMFD(asInfo);
  DadosReducao := String(asInfo);
end;

function TBemaFI.Bematech_FI_NomeiaRelatorioGerencialMFD(Indice: Integer;
  Descricao: String): Integer;
begin
  Result := _Bematech_FI_NomeiaRelatorioGerencialMFD(Indice, AnsiString(Descricao));
end;

function TBemaFI.Bematech_FI_AbreRelatorioGerencialMFD(
  Indice: String): Integer;
begin
  Result := _Bematech_FI_AbreRelatorioGerencialMFD(AnsiString(Indice));
end;

function TBemaFI.Bematech_FI_VerificaRelatorioGerencialMFD(
  var Relatorios: String): Integer;
var
  asInfo: AnsiString;
begin
  asInfo := AnsiString(StringOfChar(#0, 659));
  Result := _Bematech_FI_VerificaRelatorioGerencialMFD(asInfo);
  Relatorios := String(asInfo);
end;

function TBemaFI.Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(
  FlagRetorno: String): Integer;
begin
  Result := _Bematech_FI_HabilitaDesabilitaRetornoEstendidoMFD(AnsiString(FlagRetorno));
end;

function TBemaFI.Bematech_FI_RetornoImpressoraMFD(var ACK, ST1, ST2,
  ST3: Integer): Integer;
begin
  Result := _Bematech_FI_RetornoImpressoraMFD(ACK, ST1, ST2, ST3);
end;

end.
