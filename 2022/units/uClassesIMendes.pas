unit uClassesIMendes;

interface

uses
  System.Generics.Collections, REST.Json.Types, SysUtils;

type
  TProdutoSimulacao = class
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
    FProduto: TArray<TProdutoSimulacao>;
  published
    property Cabecalho: TCabecalho read FCabecalho;
    property Produto: TArray<TProdutoSimulacao> read FProduto write FProduto;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TConsultaProdDesc = class
  private
    FDados: string;
    FNomeServico: string;
  published
    property Dados: string read FDados write FDados;
    property NomeServico: string read FNomeServico write FNomeServico;
  end;

type
  TProdutoImendes = class
  private
    FCest: string;
    FDescricao: string;
    FDescricaoGrupo: string;
    FEan: string;
    FId: string;
    FNcm: string;
  published
    property Cest: string read FCest write FCest;
    property Descricao: string read FDescricao write FDescricao;
    property DescricaoGrupo: string read FDescricaoGrupo write FDescricaoGrupo;
    property Ean: string read FEan write FEan;
    property Id: string read FId write FId;
    property Ncm: string read FNcm write FNcm;
  end;

  TCabecalhoProdDesc = class
  private
    FCNPJ: string;
    FMensagem: string;
    FProdutosRetornados: Integer;
  published
    property CNPJ: string read FCNPJ write FCNPJ;
    property Mensagem: string read FMensagem write FMensagem;
    property ProdutosRetornados: Integer read FProdutosRetornados write FProdutosRetornados;
  end;

  TRetConsultaProdDesc = class
  private
    FCabecalho: TCabecalhoProdDesc;
    [JSONName('produto'), JSONMarshalled(False)]
    FProduto: TArray<TProdutoImendes>;
  published
    property Cabecalho: TCabecalhoProdDesc read FCabecalho write FCabecalho;
    property Produto: TArray<TProdutoImendes> read FProduto write FProduto;
  public
    constructor Create;
    destructor Destroy; override;
  end;


type
  TProdutoTrib = class
  private
    FCod: string;
    FCodIMendes: string;
    FDescricao: string;
    FEan: string;
    FId: string;
  published
    property Cod: string read FCod write FCod;
    property CodIMendes: string read FCodIMendes write FCodIMendes;
    property Descricao: string read FDescricao write FDescricao;
    property Ean: string read FEan write FEan;
    property Id: string read FId write FId;
  end;

  TCabecalhoTrib = class
  private
    FAmb: string;
    FCnae: string;
    FCnpj: string;
    FCodFaixa: string;
    FCrt: string;
    FUf: string;
    FVer: string;
  published
    property Amb: string read FAmb write FAmb;
    property Cnae: string read FCnae write FCnae;
    property Cnpj: string read FCnpj write FCnpj;
    property CodFaixa: string read FCodFaixa write FCodFaixa;
    property Crt: string read FCrt write FCrt;
    property Uf: string read FUf write FUf;
    property Ver: string read FVer write FVer;
  end;

  TTributacaoIMendesDTO = class
  private
    FCabecalho: TCabecalhoTrib;
    [JSONName('produto'), JSONMarshalled(False)]
    FProduto: TArray<TProdutoTrib>;
  published
    property Cabecalho: TCabecalhoTrib read FCabecalho;
    property Produto: TArray<TProdutoTrib> read FProduto write FProduto;
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


{ TRetConsultaProdDesc }

constructor TRetConsultaProdDesc.Create;
begin
  FCabecalho := TCabecalhoProdDesc.Create;
end;

destructor TRetConsultaProdDesc.Destroy;
begin
  FreeAndNil(FCabecalho);
  inherited;
end;

{ TTributacaoIMendesDTO }

constructor TTributacaoIMendesDTO.Create;
begin
  FCabecalho := TCabecalhoTrib.Create;
end;

destructor TTributacaoIMendesDTO.Destroy;
begin
  FreeAndNil(FCabecalho);
  inherited;
end;

end.




