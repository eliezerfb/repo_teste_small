unit uClassesIMendes;

interface

uses
  System.Generics.Collections, REST.Json.Types, SysUtils;

type
  TProduto = class
  private
    FCSTCSOSN: string;
    FCSTPISCOFINSEntrada: string;
    FCSTPISCOFINSSaida: string;
    FCodigoInterno: string;
    FDescricao: string;
    FEan: string;
    FNaturezaReceitaIsentaPISCOFINS: string;
    FNcm: string;
    FPICMS: Double;
    FPIPI: Double;
    FPMVAST: Double;
    FPRedBCICMS: Double;
    //FVPautaST: Double; Não usamos
    FVVenda: Double;
  published
    property CSTCSOSN: string read FCSTCSOSN write FCSTCSOSN;
    property CSTPISCOFINSEntrada: string read FCSTPISCOFINSEntrada write FCSTPISCOFINSEntrada;
    property CSTPISCOFINSSaida: string read FCSTPISCOFINSSaida write FCSTPISCOFINSSaida;
    property CodigoInterno: string read FCodigoInterno write FCodigoInterno;
    property Descricao: string read FDescricao write FDescricao;
    property Ean: string read FEan write FEan;
    property NaturezaReceitaIsentaPISCOFINS: string read FNaturezaReceitaIsentaPISCOFINS write FNaturezaReceitaIsentaPISCOFINS;
    property Ncm: string read FNcm write FNcm;
    property PICMS: Double read FPICMS write FPICMS;
    property PIPI: Double read FPIPI write FPIPI;
    property PMVAST: Double read FPMVAST write FPMVAST;
    property PRedBCICMS: Double read FPRedBCICMS write FPRedBCICMS;
    //property VPautaST: Double read FVPautaST write FVPautaST; Não usamos
    property VVenda: Double read FVVenda write FVVenda;
  end;

  TCabecalho = class
  private
    FCnpj: string;
    FCrt: Integer;
    FHash: string;
    FTpConsulta: Integer;
    FUf: string;
    FVersao: string;
  published
    property Cnpj: string read FCnpj write FCnpj;
    property Crt: Integer read FCrt write FCrt;
    property Hash: string read FHash write FHash;
    property TpConsulta: Integer read FTpConsulta write FTpConsulta;
    property Uf: string read FUf write FUf;
    property Versao: string read FVersao write FVersao;
  end;

  TRootSimuladorDTO = class
  private
    FCabecalho: TCabecalho;
    [JSONName('produto')]
    FProduto: TArray<TProduto>;
  published
    property Cabecalho: TCabecalho read FCabecalho;
    property Produto: TArray<TProduto> read FProduto write FProduto;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TRoot }

constructor TRootSimuladorDTO.Create;
begin
  inherited;
  FCabecalho := TCabecalho.Create;
end;

destructor TRootSimuladorDTO.Destroy;
begin
  FreeAndNil(FCabecalho);
  inherited;
end;



end.



[JSONName('produto'), JSONMarshalled(False)]
