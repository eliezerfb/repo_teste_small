unit uClassesIMendes;

interface

uses
  System.Generics.Collections, REST.Json.Types, SysUtils;

//Simulação
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

//Consulta Descrição
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

//Envio Tributação
type
  TProdutoTrib = class
  private
    FCodigo: string;
    FCodIMendes: string;
    FDescricao: string;
    FTipoCodigo: integer;
  published
    property Codigo: string read FCodigo write FCodigo;
    property CodIMendes: string read FCodIMendes write FCodIMendes;
    property Descricao: string read FDescricao write FDescricao;
    property TipoCodigo: integer read FTipoCodigo write FTipoCodigo;
  end;

  TCabecalhoTrib = class
  private
    FAmb: string;
    FCnae: string;
    FCnpj: string;
    FCodFaixa: string;
    FCrt: string;
    FUf: string;
    FRegimeTrib: string;
  published
    property Amb: string read FAmb write FAmb;
    property Cnae: string read FCnae write FCnae;
    property Cnpj: string read FCnpj write FCnpj;
    property CodFaixa: string read FCodFaixa write FCodFaixa;
    property Crt: string read FCrt write FCrt;
    property Uf: string read FUf write FUf;
    property RegimeTrib: string read FRegimeTrib write FRegimeTrib;
  end;

  TTributacaoIMendesDTO = class
  private
    FCabecalho: TCabecalhoTrib;
    [JSONName('produto')]
    FProduto: TArray<TProdutoTrib>;
    FUf: TArray<string>;
  published
    property Cabecalho: TCabecalhoTrib read FCabecalho;
    property Produto: TArray<TProdutoTrib> read FProduto write FProduto;
    property Uf: TArray<string> read FUf write FUf;
  public
    constructor Create;
    destructor Destroy; override;
  end;


//Retorno Tributação
type
  TIpi = class
  private
    FAliqIPI: Double;
    FCodenq: string;
    FCstEnt: string;
    FCstSai: string;
    FEx: string;
  published
    property AliqIPI: Double read FAliqIPI write FAliqIPI;
    property Codenq: string read FCodenq write FCodenq;
    property CstEnt: string read FCstEnt write FCstEnt;
    property CstSai: string read FCstSai write FCstSai;
    property Ex: string read FEx write FEx;
  end;

  TPiscofins = class
  private
    FAliqCOFINS: Double;
    FAliqPIS: Double;
    FAmpLegal: string;
    FCstEnt: string;
    FCstSai: string;
    FDtVigFin: string;
    FNri: string;
  published
    property AliqCOFINS: Double read FAliqCOFINS write FAliqCOFINS;
    property AliqPIS: Double read FAliqPIS write FAliqPIS;
    property AmpLegal: string read FAmpLegal write FAmpLegal;
    property CstEnt: string read FCstEnt write FCstEnt;
    property CstSai: string read FCstSai write FCstSai;
    property DtVigFin: string read FDtVigFin write FDtVigFin;
    property Nri: string read FNri write FNri;
  end;

  TRegra = class
  private
    FAliqicms: Double;
    FAliqicmsst: Double;
    FAmpLegal: string;
    FAntecipado: string;
    FCfopCompra: Integer;
    FCfopVenda: Integer;
    FCodBenef: string;
    FCodigo: Integer;
    FCsosn: string;
    FCst: string;
    FDesonerado: string;
    [JSONName('estd_finalidade')]
    FEstdFinalidade: string;
    FExcecao: Integer;
    FFcp: Double;
    FIcmsdeson: Double;
    FIndicDeduzDesonerado: string;
    FIva: Double;
    FPDifer: Double;
    FPICMSEfet: Double;
    FPICMSPDV: Double;
    FPRedBCEfet: Double;
    FPercIsencao: Double;
    FReducaobcicms: Double;
    FReducaobcicmsst: Double;
    FSimbPDV: string;
    FUf: string;
  published
    property Aliqicms: Double read FAliqicms write FAliqicms;
    property Aliqicmsst: Double read FAliqicmsst write FAliqicmsst;
    property AmpLegal: string read FAmpLegal write FAmpLegal;
    property Antecipado: string read FAntecipado write FAntecipado;
    property CfopCompra: Integer read FCfopCompra write FCfopCompra;
    property CfopVenda: Integer read FCfopVenda write FCfopVenda;
    property CodBenef: string read FCodBenef write FCodBenef;
    property Codigo: Integer read FCodigo write FCodigo;
    property Csosn: string read FCsosn write FCsosn;
    property Cst: string read FCst write FCst;
    property Desonerado: string read FDesonerado write FDesonerado;
    property EstdFinalidade: string read FEstdFinalidade write FEstdFinalidade;
    property Excecao: Integer read FExcecao write FExcecao;
    property Fcp: Double read FFcp write FFcp;
    property Icmsdeson: Double read FIcmsdeson write FIcmsdeson;
    property IndicDeduzDesonerado: string read FIndicDeduzDesonerado write FIndicDeduzDesonerado;
    property Iva: Double read FIva write FIva;
    property PDifer: Double read FPDifer write FPDifer;
    property PICMSEfet: Double read FPICMSEfet write FPICMSEfet;
    property PICMSPDV: Double read FPICMSPDV write FPICMSPDV;
    property PRedBCEfet: Double read FPRedBCEfet write FPRedBCEfet;
    property PercIsencao: Double read FPercIsencao write FPercIsencao;
    property Reducaobcicms: Double read FReducaobcicms write FReducaobcicms;
    property Reducaobcicmsst: Double read FReducaobcicmsst write FReducaobcicmsst;
    property SimbPDV: string read FSimbPDV write FSimbPDV;
    property Uf: string read FUf write FUf;
  end;

  TGrupo = class
  private
    FCest: string;
    FCodanp: string;
    FCodigo: Integer;
    FIpi: TIpi;
    FLista: string;
    [SuppressZero]
    FNcm: string;
    FPiscofins: TPiscofins;
    FTipo: string;
    FRegra: TArray<TRegra>;
    FCodIMendes: TArray<string>;
    FProduto: TArray<string>;
  published
    property Cest: string read FCest write FCest;
    property Codanp: string read FCodanp write FCodanp;
    property Codigo: Integer read FCodigo write FCodigo;
    property Ipi: TIpi read FIpi;
    property Lista: string read FLista write FLista;
    property Ncm: string read FNcm write FNcm;
    property Piscofins: TPiscofins read FPiscofins;
    property Tipo: string read FTipo write FTipo;
    property Regra: TArray<TRegra> read FRegra write FRegra;
    property CodIMendes: TArray<string> read FCodIMendes write FCodIMendes;
    property Produto: TArray<string> read FProduto write FProduto;
  public
    destructor Destroy; override;
  end;

  TRetCabecalhoTrib = class
  private
    FAmb: Integer;
    FCnae: string;
    FCnpj: string;
    FCodFaixa: Integer;
    FCrt: Integer;
    FMensagem: string;
    FProdEnv: Integer;
    FProdRet: Integer;
    FTransacao: string;
    FVersao: string;
  published
    property Amb: Integer read FAmb write FAmb;
    property Cnae: string read FCnae write FCnae;
    property Cnpj: string read FCnpj write FCnpj;
    property CodFaixa: Integer read FCodFaixa write FCodFaixa;
    property Crt: Integer read FCrt write FCrt;
    property Mensagem: string read FMensagem write FMensagem;
    property ProdEnv: Integer read FProdEnv write FProdEnv;
    property ProdRet: Integer read FProdRet write FProdRet;
    property Transacao: string read FTransacao write FTransacao;
    property Versao: string read FVersao write FVersao;
  end;

  TRetTributacaoIMendesDTO = class
  private
    [JSONName('cabecalho')]
    FCabecalho: TRetCabecalhoTrib;
    [JSONName('grupo'), JSONMarshalled(False)]
    FGrupo: TArray<TGrupo>;
  published
    property Cabecalho: TRetCabecalhoTrib read FCabecalho;
    property Grupo: TArray<TGrupo> read FGrupo write FGrupo;
  public
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

{ TRetTributacaoIMendesDTO }

destructor TRetTributacaoIMendesDTO.Destroy;
begin
  FreeAndNil(FCabecalho);
  inherited;
end;

{ TGrupo }

destructor TGrupo.Destroy;
begin
  FreeAndNil(FIpi);
  FreeAndNil(FPiscofins);

  inherited;
end;

end.




