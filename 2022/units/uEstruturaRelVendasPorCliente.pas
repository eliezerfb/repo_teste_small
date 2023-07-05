unit uEstruturaRelVendasPorCliente;

interface

uses
  uIEstruturaRelVendasPorCliente, uIEstruturaTipoRelatorioPadrao, IBDatabase,
  Classes, SysUtils, SmallFunc;

type
  TEstruturaRelVendasPorCliente = class(TInterfacedObject, IEstruturaRelVendasPorCliente)
  private
    FbItemAItem: Boolean;
    FdDataIni: TDateTime;
    FdDataFim: TDateTime;
    FoDataBase: TIBDatabase;
    FlsOperacoes: TStrings;
    FoEstrutura: IEstruturaTipoRelatorioPadrao;
    constructor Create;
    function RetornarWhereNota: String;
    function RetornarWhereCupom: String;
  public
    destructor Destroy; override;
    class function New: IEstruturaRelVendasPorCliente;
    function setUsuario(AcUsuario: String): IEstruturaRelVendasPorCliente;
    function setDataBase(AoDataBase: TIBDatabase): IEstruturaRelVendasPorCliente;
    function setItemAItem(AbItemAItem: Boolean): IEstruturaRelVendasPorCliente;
    function setDataInicial(AdData: TDateTime): IEstruturaRelVendasPorCliente;
    function setDataFinal(AdData: TDateTime): IEstruturaRelVendasPorCliente;
    function setOperacoes(AslItens: TStrings): IEstruturaRelVendasPorCliente;
    function ImprimeNota(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
    function ImprimeCupom(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
    function Estrutura: IEstruturaTipoRelatorioPadrao;
  end;

implementation

uses
  uEstruturaTipoRelatorioPadrao, uEstruturaRelVendasPorClienteNota,
  uDadosVendasPorClienteFactory, uEstruturaRelVendasPorClienteCupom;

{ TEstruturaRelVendasPorCliente }

constructor TEstruturaRelVendasPorCliente.Create;
begin
  FoEstrutura := TEstruturaTipoRelatorioPadrao.New;
end;

function TEstruturaRelVendasPorCliente.Estrutura: IEstruturaTipoRelatorioPadrao;
begin
  Result := FoEstrutura;
end;

function TEstruturaRelVendasPorCliente.ImprimeNota(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  if not AbImprime then
    Exit;

  FoEstrutura.GerarImpressao(TEstruturaRelVendasPorClienteNota.New
                                                              .setDAO(TDadosVendasPorClienteFactory.New
                                                                                                   .RetornarDAONota(FbItemAItem)
                                                                                                   .setDataBase(FoDataBase)
                                                                                                   .setWhere(RetornarWhereNota)
                                                                                                   .CarregarDados
                                                                     )
                            );  
end;

function TEstruturaRelVendasPorCliente.ImprimeCupom(AbImprime: Boolean): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  if not AbImprime then
    Exit;

  FoEstrutura.GerarImpressao(TEstruturaRelVendasPorClienteCupom.New
                                                              .setDAO(TDadosVendasPorClienteFactory.New
                                                                                                   .RetornarDAOCupom(FbItemAItem)
                                                                                                   .setDataBase(FoDataBase)
                                                                                                   .setWhere(RetornarWhereCupom)
                                                                                                   .CarregarDados
                                                                     )
                            );
end;

function TEstruturaRelVendasPorCliente.RetornarWhereNota: String;
var
  i: Integer;
  AStr: TStringList;
  cOperacao: String;
begin
  AStr := TStringList.Create;
  try
    if (FdDataIni <= FdDataFim) then
      AStr.Add('(VENDAS.EMITIDA=''S'') AND (VENDAS.EMISSAO BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
    if Assigned(FlsOperacoes) and (FlsOperacoes.Count > 0) then
    begin
      AStr.Add('AND (');
      for i := 0 to Pred(FlsOperacoes.Count) do
      begin
        cOperacao := EmptyStr;
        if i > 0 then
          cOperacao := 'OR ';
        cOperacao := cOperacao + '(VENDAS.OPERACAO='+QuotedStr(FlsOperacoes[i])+')';

        AStr.Add(cOperacao);
      end;
      AStr.Add(')');
    end;
    Result := AStr.Text;
  finally
    FreeAndNil(AStr);
  end;
end;

function TEstruturaRelVendasPorCliente.RetornarWhereCupom: String;
var
  AStr: TStringList;
begin
  AStr := TStringList.Create;
  try
    if (FdDataIni <= FdDataFim) then
      AStr.Add('(ALTERACA.TIPO IN (''BALCAO'', ''VENDA'')) AND (ALTERACA.DATA BETWEEN ' + QuotedStr(DateToStrInvertida(FdDataIni)) + ' AND ' + QuotedStr(DateToStrInvertida(FdDataFim)) + ')');
    Result := AStr.Text;
  finally
    FreeAndNil(AStr);
  end;
end;

class function TEstruturaRelVendasPorCliente.New: IEstruturaRelVendasPorCliente;
begin
  Result := Self.Create;
end;

function TEstruturaRelVendasPorCliente.setDataBase(AoDataBase: TIBDatabase): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FoDataBase := AoDataBase;
end;

function TEstruturaRelVendasPorCliente.setDataFinal(AdData: TDateTime): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FdDataFim := AdData;
end;

function TEstruturaRelVendasPorCliente.setDataInicial(AdData: TDateTime): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FdDataIni := AdData;
end;

function TEstruturaRelVendasPorCliente.setItemAItem(AbItemAItem: Boolean): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FbItemAItem := AbItemAItem;
end;

function TEstruturaRelVendasPorCliente.setUsuario(AcUsuario: String): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FoEstrutura.setUsuario(AcUsuario);
end;

function TEstruturaRelVendasPorCliente.setOperacoes(AslItens: TStrings): IEstruturaRelVendasPorCliente;
begin
  Result := Self;

  FlsOperacoes := AslItens;
end;

destructor TEstruturaRelVendasPorCliente.Destroy;
begin
  FreeAndNil(FlsOperacoes);
  inherited;
end;

end.
