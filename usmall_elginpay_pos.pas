{
Unit para comunicação com dll POS ElginPAY
Autor: Sandro Luis da Silva
Compatível D7 e demais versões

Felipe Moreira, Suporte Elgin - 11 99956-0200 - felipe.moreira@elgin.com.br
Dados POS homologação
senha lojista 000000
senha técnica 314159
senha configurações 987654321

Exemplo delphi
https://github.com/ElginDeveloperCommunity/POS_Android_ElginPAY/tree/master/E1_Bridge/Exemplo_E1_Bridge_Windows
https://github.com/ElginDeveloperCommunity/POS_Android_ElginPAY/blob/master/E1_Bridge/Exemplo_E1_Bridge_Windows/Exemplo_E1_Brigde_Windows_Exemplo_Delphi.zip

documentação do json de retorno https://elgindevelopercommunity.github.io/group__g120.html
métodos da dll https://elgindevelopercommunity.github.io/group__g51.html#ga63a4ac74b8b9cdfd0bb8eafb3bfa750c

}
unit usmall_elginpay_pos;

interface

uses
  Classes, Windows, Dialogs, SysUtils, IniFiles, StrUtils
  , Smallfunc;

const OPERACAO_ADMINISTRATIVA = 0;
const NOME_POS_ONLINE_ELGIN   = 'POS ElginPay';

type
  TTipoConexaoPOS = (tcxPosOffLine, tcxPosOnlineElginPay);

type
  TConfiguracaoConectaPOS = class
  private
    FPortaTransacao: Integer;
    FPortaStatus: Integer;
    FIP: String;
    FDLL: String;
    FAtivo: String;
    FNomePOS: String;
    procedure SetFAtivo(const Value: String);
  public
    property Ativo: String read FAtivo write SetFAtivo;
    property NomePOS: String read FNomePOS write FNomePOS;
    property DLL: String read FDLL write FDLL;
    property IP: String read FIP write FIP;
    property PortaTransacao: Integer read FPortaTransacao write FPortaTransacao;
    property PortaStatus: Integer read FPortaStatus write FPortaStatus;
    constructor Create;
    procedure SalvaConfiguracao;
    function NomeConfiguracaoPOS: String;
    procedure LeConfiguracaoPOS;
  end;

  TTransacaoPOSElginPay = class
  private
    FImprimirComprovanteVenda: Boolean;
    FTransacao: String;
    FTipoCartao: String;
    FParcelas: String;
    FAdministradora: String;
    FRede: String;
    FMensagemOperador: String;
    FRetorno: String;
    procedure SetMensagemOperador(const Value: String);
  public
    property TipoCartao: String read FTipoCartao write FTipoCartao;
    property Administradora: String read FAdministradora write FAdministradora;
    property Transacao: String read FTransacao write FTransacao;
    property Rede: String read FRede write FRede;
    property Parcelas: String read FParcelas write FParcelas;
    property MensagemOperador: String  read FMensagemOperador write SetMensagemOperador;
    property ImprimirComprovanteVenda: Boolean read FImprimirComprovanteVenda write FImprimirComprovanteVenda;
    property retornoJson: String read FRetorno write FRetorno;
    function ValorElementoElginPayFromJson(Json: String; Chave: String): String;
    procedure Clear;
  end;

  TSmallElginPayPos = class(TComponent)
  private
    //Chamadas usando stdcall
    _GetServer: function: PAnsiChar; stdcall;
    _SetServer: function(ipTerminal: AnsiString; portaTransacao, portaStatus: Integer): PAnsiChar; stdcall;
    _GetTimeout: function: PAnsiChar; stdcall;
    _SetTimeout: function(timeout:Integer): PAnsiChar; stdcall;
    _ConsultarStatus: function: PAnsiChar; stdcall;
    _ConsultarUltimaTransacao: function(pdv:AnsiString): PAnsiChar; stdcall;
    _ImprimirCupomSat: function(xml:AnsiString): PAnsiChar; stdcall;
    _ImprimirCupomSatCancelamento: function(xml, assQrCode:AnsiString): PAnsiChar; stdcall;
    _ImprimirCupomNfce: function(xml: AnsiString; indexcsc: Integer; csc: AnsiString): PAnsiChar; stdcall;
    _IniciaVenda: function(idTransacao: Integer; pdv, valorTotal: AnsiString): PAnsiChar; stdcall;
    _IniciaVendaDebito: function(idTransacao: Integer; pdv, valorTotal: AnsiString): PAnsiChar; stdcall;
    _IniciaVendaCredito: function(idTransacao: Integer; pdv, valorTotal: AnsiString;tipoFinanciamento, numParcelas: Integer): PAnsiChar; stdcall;
    _IniciaCancelamentoVenda: function(idTransacao: Integer; pdv, valorTotal, dataHora, nsu: AnsiString): PAnsiChar; stdcall;
    _IniciaOperacaoAdministrativa: function(idTransacao: Integer; pdv: AnsiString; operacao:Integer): PAnsiChar; stdcall;

    _SetSenha: function(senha: AnsiString; habilitada: Boolean): PAnsiChar; stdcall;
    _SetSenhaServer: function(senha: AnsiString; habilitada: Boolean): PAnsiChar; stdcall;

    FhDLL: THandle;
    FPortaStatus: Integer;
    FPortaTransacao: Integer;
    FIPTerminal: String;
    FConfiguracaoPOS: TConfiguracaoConectaPOS;
    FTransacao: TTransacaoPOSElginPay;
    FAtivado: Boolean;
    FUF: String;
    FModelo: String;
    FCNPJEmitente: String;
    //FUsandoTEF: Boolean;
    procedure Import(var Proc: pointer; Name: PAnsiChar);
    procedure CarregaDLL;
    // Sandro Silva 2022-05-10 function LeConfiguracaoPOS(NomePOS: String): TConfiguracaoConectaPOS;

    function SetServer(ipTerminal: AnsiString; portaTransacao: Integer;
      portaStatus: Integer): String;
    function IniciaVenda(idTransacao: Integer; PDV: AnsiString;
      Valor: Double): String;
    function IniciaCancelamentoVenda(idTransacao: Integer; pdv: AnsiString;
      valorTotal: Double; dataHora: AnsiString; nsu: AnsiString): String;
    function IniciaOperacaoAdministrativa(idTransacao: Integer; pdv:
      AnsiString; operacao: Integer): String;
    procedure ImprimirCupomNfce(xml: AnsiString; indexcsc: Integer; csc: AnsiString);
    procedure ImprimirCupomSat(xml: AnsiString);
    function getConfiguracaoPOS: TConfiguracaoConectaPOS;
    function IniciarTransacao: Boolean;
    procedure Inicializa;
    procedure Desinicializa;
  public
    property Configuracao: TConfiguracaoConectaPOS read FConfiguracaoPOS {getConfiguracaoPOS} write FConfiguracaoPOS;
    property Transacao: TTransacaoPOSElginPay read FTransacao write FTransacao;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Ativa(CNPJEmitente: String; UF: String; Modelo: String{;
      bUsandoTEF: Boolean});
    procedure Desativa;
    function PermiteUsarPOS: Boolean;
    function EfetuaPagamento(sCaixa: String;
      var dValorPagarCartao: Currency): Boolean;
    procedure ImpressaoComprovanteVenda(Xml: String);
    procedure FuncoesAdministrativas(sCaixa: String);
  end;

implementation

uses
  Math,
  ufuncoesfrente
  ;

{ TSmallElginPayPos }

procedure TSmallElginPayPos.CarregaDLL;
begin
  if FhDLL = 0 then
  begin

    try
      // FDLLName := FCaminhoDLL;

      {$IFDEF VER150}
      FhDLL := LoadLibrary(PChar(FConfiguracaoPOS.DLL));// FhDLL := LoadLibrary(PChar(FDLLName)); //carregando dll
      {$ELSE}
      FhDLL := LoadLibrary(PWideChar(FConfiguracaoPOS.DLL)); // FhDLL := LoadLibrary(PWideChar(FDLLName)); //carregando dll
      if FhDLL = 0 then
        FhDLL := SafeLoadLibrary(FConfiguracaoPOS.DLL); // FhDLL := SafeLoadLibrary(FDLLName);
      {$ENDIF}

      if FhDLL = 0 then
        RaiseLastOSError; //raise Exception.Create('Não foi possível carregar a biblioteca ' + FDLLName);

      //importando métodos dinamicamente

      Import(@_GetServer, 'GetServer');
      Import(@_SetServer, 'SetServer');
      Import(@_GetTimeout, 'GetTimeout');
      Import(@_SetTimeout, 'SetTimeout');
      Import(@_ConsultarStatus, 'ConsultarStatus');
      Import(@_ConsultarUltimaTransacao, 'ConsultarUltimaTransacao');
      Import(@_ImprimirCupomSat, 'ImprimirCupomSat');
      Import(@_ImprimirCupomSatCancelamento, 'ImprimirCupomSatCancelamento');
      Import(@_ImprimirCupomNfce, 'ImprimirCupomNfce');
      Import(@_IniciaVenda, 'IniciaVenda');
      Import(@_IniciaVendaDebito, 'IniciaVendaDebito');
      Import(@_IniciaVendaCredito, 'IniciaVendaCredito');
      Import(@_IniciaCancelamentoVenda, 'IniciaCancelamentoVenda');
      Import(@_IniciaOperacaoAdministrativa, 'IniciaOperacaoAdministrativa');

      Import(@_SetSenha, 'SetSenha');
      Import(@_SetSenhaServer, 'SetSenhaServer');

    except
      on E: Exception do
      begin
        ShowMessage('Erro ao carregar comandos POS ElginPay' + #13 +
                  FConfiguracaoPOS.DLL + #13 + E.Message); 
      end;
    end;
  end; // if FhDLL = 0 then

end;

constructor TSmallElginPayPos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfiguracaoPOS := TConfiguracaoConectaPOS.Create; // Sandro Silva 2022-05-10 FConfiguracaoPOS := LeConfiguracaoPOS(NOME_POS_ONLINE_ELGIN); // Sandro Silva 2022-05-10 FConfiguracaoPOS := TConfiguracaoConectaPOS.Create;
  FTransacao := TTransacaoPOSElginPay.Create;
end;

procedure TSmallElginPayPos.Desinicializa;
begin
  try
    FreeLibrary(FhDLL); //descarregando dll

    FhDLL := 0;

    _GetServer                    := nil;
    _SetServer                    := nil;
    _GetTimeout                   := nil;
    _SetTimeout                   := nil;
    _ConsultarStatus              := nil;
    _ConsultarUltimaTransacao     := nil;
    _ImprimirCupomSat             := nil;
    _ImprimirCupomSatCancelamento := nil;
    _ImprimirCupomNfce            := nil;
    _IniciaVenda                  := nil;
    _IniciaVendaDebito            := nil;
    _IniciaVendaCredito           := nil;
    _IniciaCancelamentoVenda      := nil;
    _IniciaOperacaoAdministrativa := nil;

    _SetSenha                     := nil;
    _SetSenhaServer               := nil;

  except
  end;

end;

destructor TSmallElginPayPos.Destroy;
begin
  FConfiguracaoPOS.Free;
  FTransacao.Free;

  Desinicializa;
  inherited;
end;

procedure TSmallElginPayPos.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FhDLL, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + FConfiguracaoPOS.DLL); // raise Exception.Create('Não foi possível carregar a função ' + Name + ' da biblioteca ' + FDLLName);
  end;
end;

procedure TSmallElginPayPos.ImpressaoComprovanteVenda(Xml: String);
var
  iDCsc: Integer;
  sCSC: String;
  ini: TIniFile;
begin
  {
  if FAtivado = False then
    Exit;
  }

  if IniciarTransacao = False then
    Exit; 

  ini := TIniFile.Create('FRENTE.INI');

  if Pos('<mod>65</mod>', xml) > 0 then
  begin
    iDCsc := StrToInt(Ini.ReadString('NFCE','ID Token NFCE','1'));
    sCSC := Ini.ReadString('NFCE','Número do Token NFCE','');
    ImprimirCupomNfce(xml, iDCsc, sCSC);

  end;

  if Pos('<mod>59</mod>', xml) > 0 then
  begin
    ImprimirCupomSat(xml);
  end;

  ini.Free;
end;

procedure TSmallElginPayPos.ImprimirCupomNfce(xml: AnsiString;
  indexcsc: Integer; csc: AnsiString);
begin
  _ImprimirCupomNfce(xml, indexcsc, csc);
end;

function TSmallElginPayPos.IniciaCancelamentoVenda(idTransacao: Integer;
  pdv: AnsiString; valorTotal: Double; dataHora, nsu: AnsiString): String;
{
Inicia um cancelamento de venda.
Parâmetros
    idTransacao	- Código númerico gerenciado pelo PDV para identificar uma transação. Valor entre 0 e 999999.
    pdv	- Código identificador do PDV. Valor alfanumérico.
    valorTotal	- Valor total da venda em centavos, ex: 100 para venda de R$1,00
    dataHora	- Data e hora da transação no formato dd/MM/yyyy HH:mm:ss ou dd/MM/yyyy.
    Este valor é retornado no JSON das vendas na chave dataHoraTransacao.
    nsu	- nsu da transação que é retornado no JSON das vendas na chave nsuLocal.
Retorna
    String no formato Json com os dados da transação; Consulte a sessão retorno para ter um exemplo de um json de saída e todos os dados.
}
var
  sValorTotal: String;
begin
  sValorTotal := FloatToStr(valorTotal * 100);
  if Pos(',', sValorTotal) > 0 then
    sValorTotal := Copy(sValorTotal, 1, Pos(',', sValorTotal) - 1);
  Result := _IniciaCancelamentoVenda(idTransacao, pdv, AnsiString(svalorTotal), dataHora, nsu);
end;

procedure TSmallElginPayPos.Inicializa;
begin
  CarregaDLL;
end;

function TSmallElginPayPos.IniciaOperacaoAdministrativa(
  idTransacao: Integer; pdv: AnsiString; operacao: Integer): String;
{
Inicia uma operação administrativa.
Parâmetros
    idTransacao	- Código númerico gerenciado pelo PDV para identificar uma transação. Valor entre 0 e 999999.
    pdv	- Código identificador do PDV. Valor alfanumérico.
    operacao	- Informa a operação a ser realizada. Operações disponiveis são:
        Operação administrativa = 0
        Operação de instalação = 1
        Operação de configuração = 2
        Operação de manutenção = 3
        Teste de comunicação = 4
        Operação de reimpressão de comprovante = 5
Retorna
    String no formato Json com os dados da transação; Consulte a sessão retorno para ter um exemplo de um json de saída e todos os dados.
}
begin
  Result := _IniciaOperacaoAdministrativa(idTransacao, pdv, operacao);
end;

function TSmallElginPayPos.IniciaVenda(idTransacao: Integer;
  PDV: AnsiString; Valor: Double): String;
{
Inicia um operação de venda.
O tipo da operação será definido pelo operador como débito ou crédito.
Parâmetros
    idTransacao	- Código númerico gerenciado pelo PDV para identificar uma transação. Valor entre 0 e 999999.
    pdv	- Código identificador do PDV. Valor alfanumérico.
    valorTotal	- Valor total da venda em centavos, ex: 100 para venda de R$1,00
Retorna
    String no formato Json com os dados da transação; Consulte a sessão retorno para ter um exemplo de um json de saída e todos os dados.
}
var
  sValor: String;
begin
  sValor := FloatToStr(Valor * 100);
  if Pos(',', sValor) > 0 then
    sValor := Copy(sValor, 1, Pos(',', sValor) - 1);
  Result := _IniciaVenda(idTransacao, PDV, AnsiString(sValor));
end;
{// Sandro Silva 2022-05-10
function TSmallElginPayPos.LeConfiguracaoPOS(NomePOS: String): TConfiguracaoConectaPOS;
var
  sNomeSecao: String;
  iniPOS: TIniFile;
begin
  Result := TConfiguracaoConectaPOS.Create;

  iniPOS := TIniFile.Create('FRENTE.INI');

  sNomeSecao := FConfiguracaoPOS.NomeConfiguracaoPOS();
  if sNomeSecao = '' then
  begin
    sNomeSecao := NOME_POS_ONLINE_ELGIN;
  end;
  Result.Ativo          := iniPOS.ReadString(sNomeSecao, 'Ativo', 'Não');
  Result.NomePOS        := iniPOS.ReadString(sNomeSecao, 'Nome', '');
  Result.DLL            := iniPOS.ReadString(sNomeSecao, 'DLL', '');
  Result.IP             := iniPOS.ReadString(sNomeSecao, 'IP', '');
  Result.PortaTransacao := iniPOS.ReadInteger(sNomeSecao, 'PORTA TRANSACAO', 3000);
  Result.PortaStatus    := iniPOS.ReadInteger(sNomeSecao, 'PORTA STATUS', 3001);

  iniPOS.Free;

end;
}

function TSmallElginPayPos.EfetuaPagamento(sCaixa: String;
  var dValorPagarCartao: Currency): Boolean;
var
  sResposta: String;
begin

  Result := False;

  if IniciarTransacao = False then
    Exit;

  try
    try

      sResposta := SetServer(FConfiguracaoPOS.IP, FConfiguracaoPOS.PortaTransacao, FConfiguracaoPOS.PortaStatus);
      if AnsiContainsText(sResposta, '"Sucesso"') = False then
      begin
        FTransacao.MensagemOperador := UTF8Decode(FTransacao.ValorElementoElginPayFromJson(sResposta, 'e1_bridge_msg'));
        if FTransacao.MensagemOperador = '' then
          FTransacao.MensagemOperador := sResposta;
        Exit;
      end;

      sResposta := IniciaVenda(StrToInt(FormatDateTime('HHnnss', Time)), sCaixa, dValorPagarCartao);
      FTransacao.retornoJson := sResposta;
      if AnsiContainsText(sResposta, '"Sucesso"') = False then
      begin
        FTransacao.MensagemOperador := UTF8Decode(FTransacao.ValorElementoElginPayFromJson(sResposta, 'e1_bridge_msg'));
      end
      else
      begin
        FTransacao.MensagemOperador := FTransacao.ValorElementoElginPayFromJson(sResposta, 'mensagemResultado');
      end;

      if FTransacao.MensagemOperador = 'Transacao autorizada' then
      begin

        FTransacao.TipoCartao               := FTransacao.ValorElementoElginPayFromJson(sResposta, 'tipoCartao');
        FTransacao.Administradora           := FTransacao.ValorElementoElginPayFromJson(sResposta, 'nomeCartao');
        FTransacao.Transacao                := FTransacao.ValorElementoElginPayFromJson(sResposta, 'codigoAutorizacao');
        FTransacao.Rede                     := FTransacao.ValorElementoElginPayFromJson(sResposta, 'nomeCartao');
        FTransacao.Parcelas                 := FTransacao.ValorElementoElginPayFromJson(sResposta, 'numeroParcelas');
        FTransacao.ImprimirComprovanteVenda := StrToBool(FTransacao.ValorElementoElginPayFromJson(sResposta, 'e1_cupom_fiscal'));

        Result := True;
      end;
      
    except
      FTransacao.MensagemOperador := 'Não foi possível comunicar com ' + FConfiguracaoPOS.NomePOS;
    end;
    
  finally

  end;

end;

function TSmallElginPayPos.SetServer(ipTerminal: AnsiString;
  portaTransacao, portaStatus: Integer): String;
{
Configura servidor onde serão processadas as transações.

Parâmetros
    ipTerminal	- IP do terminal SmartPOS onde o APP E1_Bridge esta em execução. Exemplo: 192.168.0.10
    portaTransacao	- Identificação da porta de comunicação. A porta padrão é 3000
    O valor deve ser entre 0 e 65535, onde 0 será para definir com o valor padrão de 3000.
    portaStatus	- Identificação da porta onde serão obtido o status das transações. A porta padrão é 3001
    O valor deve ser entre 0 e 65535, onde 0 será para definir com o valor padrão de 3001.

Retorna
    string no formato json
}
begin
  FIPTerminal     := ipTerminal;
  FPortaTransacao := portaTransacao;
  FPortaStatus    := portaStatus;

  try
    Result := _SetServer(FIPTerminal, FPortaTransacao, FPortaStatus);
  except
    Result := 'Não foi possível comunicar com ' + FConfiguracaoPOS.NomePOS;
  end;

end;

procedure TSmallElginPayPos.FuncoesAdministrativas(sCaixa: String);
begin

  if IniciarTransacao = False then
    Exit;

  try
    FTransacao.retornoJson := IniciaOperacaoAdministrativa(StrToInt(FormatDateTime('HHnnss', Time)), sCaixa, OPERACAO_ADMINISTRATIVA);
    FTransacao.MensagemOperador := FTransacao.ValorElementoElginPayFromJson(FTransacao.retornoJson, 'operacao') + ': ' + FTransacao.ValorElementoElginPayFromJson(FTransacao.retornoJson, 'mensagemResultado');
  except
    FTransacao.MensagemOperador := 'Não foi possível comunicar com ' + FConfiguracaoPOS.NomePOS;
  end;

end;

function TSmallElginPayPos.getConfiguracaoPOS: TConfiguracaoConectaPOS;
begin
  FConfiguracaoPOS.LeConfiguracaoPOS; // Sandro Silva 2022-05-10 FConfiguracaoPOS := LeConfiguracaoPOS(NOME_POS_ONLINE_ELGIN);
  Result := FConfiguracaoPOS;
end;

procedure TSmallElginPayPos.Desativa;
begin
  FAtivado := False;
  Desinicializa;
end;

function TSmallElginPayPos.PermiteUsarPOS: Boolean;
begin

  Result := True;

  if (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> CNPJ_SOFTWARE_HOUSE_PAF) // Smallsoft
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '11.111.111/1111-11') // emulador
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '09.450.031/0001-19') // integradand CE
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '61.099.008/0001-41') // Dimep
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '53.485.215/0001-06') // SWEDA
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '88.979.042/0001-67') // URANO
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '10.261.693/0001-20') // NITERE
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '45.170.289/0001-25') // DARUMA
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '14.200.166/0001-66') // ELGIN
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '82.373.077/0001-71') // BEMATECH
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '03.654.119/0001-76') // GERTEC/EPSON
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '05.761.098/0001-13') // KRYPTUS
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '08.238.299/0001-29') // CONTROLID
  and (FormataCpfCgc(LimpaNumero(FCNPJEmitente)) <> '08.723.218/0001-86') // TANCA
  then
    Result := False;

  //if (AnsiUpperCase(FUF) = '') or (AnsiUpperCase(FUF) = 'CE') then
  //  Result := False;

  if ((FModelo <> '59') and (FModelo <> '65') and (FModelo <> '99')) then
    Result := False;

  ///if FUsandoTEF then
  if Trim(LerParametroIni('FRENTE.INI', 'Frente de caixa', 'TEM TEF', '')) = 'Sim' then
    Result := False;

  if (FileExists(FConfiguracaoPOS.DLL) = False) and (FConfiguracaoPOS.DLL <> '') then
    Result := False;
    
end;

procedure TSmallElginPayPos.Ativa(CNPJEmitente: String; UF: String;
  Modelo: String{; bUsandoTEF: Boolean});
begin
  FUF           := UF;
  FModelo       := Modelo;
  FCNPJEmitente := LimpaNumero(CNPJEmitente);
  //FUsandoTEF    := bUsandoTEF;

  if PermiteUsarPOS = False then
    Exit;

  if FAtivado = False then
  begin
    FConfiguracaoPOS := getConfiguracaoPOS;
    if FConfiguracaoPOS.Ativo <> 'Sim' then
      Exit;
    Inicializa;
    FAtivado := True;
  end;
end;

procedure TSmallElginPayPos.ImprimirCupomSat(xml: AnsiString);
begin
  _ImprimirCupomSat(xml);
end;

function TSmallElginPayPos.IniciarTransacao: Boolean;
begin
  Result := False;
  
  FTransacao.Clear;

  FConfiguracaoPOS.LeConfiguracaoPOS; // Sandro Silva 2022-05-10 FConfiguracaoPOS := LeConfiguracaoPOS(NOME_POS_ONLINE_ELGIN); // Lê as configurações para conectar no POS

  if (FConfiguracaoPOS.Ativo <> 'Sim') or (FAtivado = False) then
  begin
    FTransacao.MensagemOperador := 'POS não está conectado';
    Exit;
  end;

  Result := True;

end;

{ TTransacaoPOSElginPay }

procedure TTransacaoPOSElginPay.Clear;
begin
  // Limpa parâmetros
  FTipoCartao               := '';
  FAdministradora           := '';
  FTransacao                := '';
  FRede                     := '';
  FParcelas                 := '';
  FMensagemOperador         := '';
  FRetorno                  := '';
  FImprimirComprovanteVenda := False;

end;

procedure TTransacaoPOSElginPay.SetMensagemOperador(const Value: String);
begin
  FMensagemOperador := StringReplace(Value, '\r', ' ', [rfReplaceAll]);
end;

function TTransacaoPOSElginPay.ValorElementoElginPayFromJson(Json,
  Chave: String): String;
var
  sTexto: String;
  iPos: Integer;
  iCaractere: Integer;
begin
  sTexto := Json;
  Chave  := '"' + Chave + '":';
  iPos := Pos(Chave, sTexto);
  if iPos > 0 then
  begin

    sTexto := Copy(sTexto, iPos + Length(Chave), Length(sTexto));
    Result := '';
    for iCaractere := 1 to length(sTexto) do
    begin
      Result := Result + Copy(sTexto, iCaractere, 1);
      if (RightStr(Result, 2) = ',"') or (RightStr(Result, 2) = '"}') then // concatena até os últimos 2 caracteres serem ," ou "}
      begin
        Result := Copy(Result, 1, length(Result) - 2);
        Break;
      end;
    end;
  end;
  Result := StringReplace(Result, '"', '', [rfReplaceAll]);

end;

{ TConfiguracaoConectaPOS }

constructor TConfiguracaoConectaPOS.Create;
begin
  inherited;
  FNomePOS        := NOME_POS_ONLINE_ELGIN;
  FAtivo          := 'Não';
  FPortaTransacao := 3000;
  FPortaStatus    := 3001;
  LeConfiguracaoPOS; // Sandro Silva 2022-05-10
  
end;

procedure TConfiguracaoConectaPOS.LeConfiguracaoPOS;
var
  sNomeSecao: String;
  iniPOS: TIniFile;
begin
  iniPOS := TIniFile.Create('FRENTE.INI');

  sNomeSecao := NomeConfiguracaoPOS();
  if sNomeSecao = '' then
  begin
    sNomeSecao := NOME_POS_ONLINE_ELGIN;
  end;
  FAtivo          := iniPOS.ReadString(sNomeSecao, 'Ativo', 'Não');
  FNomePOS        := iniPOS.ReadString(sNomeSecao, 'Nome', '');
  FDLL            := iniPOS.ReadString(sNomeSecao, 'DLL', '');
  FIP             := iniPOS.ReadString(sNomeSecao, 'IP', '');
  FPortaTransacao := iniPOS.ReadInteger(sNomeSecao, 'PORTA TRANSACAO', 3000);
  FPortaStatus    := iniPOS.ReadInteger(sNomeSecao, 'PORTA STATUS', 3001);

  iniPOS.Free;

end;

function TConfiguracaoConectaPOS.NomeConfiguracaoPOS: String;
var
  iSecao: Integer;
  iniPOS: TIniFile;
  slSessions : TStringList;
begin
  iniPOS := TIniFile.Create('FRENTE.INI');
  slSessions := TStringList.Create;
  Result := '';
  try
    slSessions.Clear;
    iniPOS.ReadSections(slSessions); //Conta o número de itens

    for iSecao := 0 to slSessions.Count - 1 do
    begin
      if Pos(AnsiUpperCase(NOME_POS_ONLINE_ELGIN), AnsiUpperCase(slSessions.Strings[iSecao])) > 0 then
      begin
        Result := slSessions.Strings[iSecao];
        Break;
      end;
    end;
  except

  end;

  iniPOS.Free;
  FreeAndNil(slSessions);

end;

procedure TConfiguracaoConectaPOS.SalvaConfiguracao;
var
  sNomeSecao: String;
  iniPOS: TIniFile;
begin
  iniPOS := TIniFile.Create('FRENTE.INI');

  sNomeSecao := NomeConfiguracaoPOS();
  if sNomeSecao = '' then
  begin
    sNomeSecao := NOME_POS_ONLINE_ELGIN;
  end;

  if (FAtivo <> 'Sim') and (FAtivo <> 'Não') then
    FAtivo := 'Não';

  iniPOS.WriteString(sNomeSecao, 'Nome', NOME_POS_ONLINE_ELGIN);
  iniPOS.WriteString(sNomeSecao, 'Ativo', FAtivo);
  iniPOS.WriteString(sNomeSecao, 'DLL', FDLL);
  iniPOS.WriteString(sNomeSecao, 'IP', FIP);
  iniPOS.WriteInteger(sNomeSecao, 'PORTA TRANSACAO', FPortaTransacao);
  iniPOS.WriteInteger(sNomeSecao, 'PORTA STATUS', FPortaStatus);

  iniPOS.Free;
end;

procedure TConfiguracaoConectaPOS.SetFAtivo(const Value: String);
begin
//  FAtivo := Value;
  FAtivo := IfThen(AnsiUpperCase(Copy(Value, 1, 1)) = 'S', 'Sim', 'Não')
end;

end.
