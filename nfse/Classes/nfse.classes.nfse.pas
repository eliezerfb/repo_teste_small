unit nfse.classes.nfse;

interface

uses
  Pkg.Json.DTO,
  REST.Json.Types,
  System.Generics.Collections,
  nfse.classes.naturezaoperacao,
  nfse.classes.regimeespecialtributacao,
  nfse.classes.tomador.tipo,
  nfse.classes.servico.situacaotributaria,
  nfse.classes.servico.responsavelretencao,
  nfse.classes.servico.exigibilidadeiss,
  nfse.classes.servico.tipounidade;

type

  TItensServico = class
  private
    FCodigo: string;
    FDescricao: string;
    FQuantidade: Integer;
    FTipoUnidade: TTipoUnidade;
    FValorUnitario: Double;
  published
    property Codigo: string read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property TipoUnidade: TTipoUnidade read FTipoUnidade write FTipoUnidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
  end;

  TServicos = class(TJsonDTO)
  private
    FAliquota: Currency;
    FAliquotaCofins: Currency;
    FAliquotaPis: Currency;
    FBaseCalculo: Currency;
    FCNAE: string;
    FCodigoMunicipio: Integer;
    FDescontoCondicionado: Currency;
    FDescontoIncondicionado: Currency;
    FDiscriminacao: string;
    FExigibilidadeISS: TExigibilidadeIss;
    FIssRetido: TIssRetido;
    [JSONName('ItensServico'), JSONMarshalled(False)]
    FItensServicoArray: TArray<TItensServico>;
    [GenericListReflect]
    FItensServico: TObjectList<TItensServico>;
    FOutrasRetencoes: Currency;
    FResponsavelRetencao: TResponsavelRetencao;
    FUFPrestacao: string;
    FValorCofins: Currency;
    FValorCsll: Currency;
    FValorDeducoes: Currency;
    FValorInss: Currency;
    FValorIr: Currency;
    FValorIss: Currency;
    FValorIssRetido: Currency;
    FValorLiquido: Currency;
    FValorPis: Currency;
    FValorServicos: Currency;
    FCodigoTributacaoMunicipio : string;
    FItemListaServico : string;
    FCodigoSiafi: string;
    FCodigoSedetec: string;
    function GetItensServico: TObjectList<TItensServico>;
  protected
    function GetAsJson: string; override;
  published
    property Aliquota: Currency read FAliquota write FAliquota;
    property AliquotaCofins: Currency read FAliquotaCofins write FAliquotaCofins;
    property AliquotaPis: Currency read FAliquotaPis write FAliquotaPis;
    property BaseCalculo: Currency read FBaseCalculo write FBaseCalculo;
    property CNAE: string read FCNAE write FCNAE;
    property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
    property DescontoCondicionado: Currency read FDescontoCondicionado write FDescontoCondicionado;
    property DescontoIncondicionado: Currency read FDescontoIncondicionado write FDescontoIncondicionado;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property ExigibilidadeISS: TExigibilidadeIss read FExigibilidadeISS write FExigibilidadeISS;
    property IssRetido: TIssRetido read FIssRetido write FIssRetido;
    property ItensServico: TObjectList<TItensServico> read GetItensServico;
    property OutrasRetencoes: Currency read FOutrasRetencoes write FOutrasRetencoes;
    property ResponsavelRetencao: TResponsavelRetencao read FResponsavelRetencao write FResponsavelRetencao;
    property UFPrestacao: string read FUFPrestacao write FUFPrestacao;
    property ValorCofins: Currency read FValorCofins write FValorCofins;
    property ValorCsll: Currency read FValorCsll write FValorCsll;
    property ValorDeducoes: Currency read FValorDeducoes write FValorDeducoes;
    property ValorInss: Currency read FValorInss write FValorInss;
    property ValorIr: Currency read FValorIr write FValorIr;
    property ValorIss: Currency read FValorIss write FValorIss;
    property ValorIssRetido: Currency read FValorIssRetido write FValorIssRetido;
    property ValorLiquido: Currency read FValorLiquido write FValorLiquido;
    property ValorPis: Currency read FValorPis write FValorPis;
    property ValorServicos: Currency read FValorServicos write FValorServicos;
    property CodigoTributacaoMunicipio : string read FCodigoTributacaoMunicipio write FCodigoTributacaoMunicipio;
    property ItemListaServico : string read FItemListaServico write FItemListaServico;
    property CodigoSiafi : string read  FCodigoSiafi write FCodigoSiafi;
    property CodigoSedetec : string read FCodigoSedetec write FCodigoSedetec;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TEndereco = class
  private
    FBairro: string;
    FCEP: string;
    FCodigoCidade: string;
    FComplemento: string;
    FLogradouro: string;
    FNumero: string;
    FTipoLogradouro: string;
    FUF: string;
    FCidade : string;
    FCodigoSiafi: string;
    FCodigoSedetec: string;
  published
    property Bairro: string read FBairro write FBairro;
    property CEP: string read FCEP write FCEP;
    property CodigoCidade: string read FCodigoCidade write FCodigoCidade;
    property Complemento: string read FComplemento write FComplemento;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property TipoLogradouro: string read FTipoLogradouro write FTipoLogradouro;
    property UF: string read FUF write FUF;
    property Cidade: string read FCidade write FCidade;
    property CodigoSiafi : string read  FCodigoSiafi write FCodigoSiafi;
    property CodigoSedetec : string read FCodigoSedetec write FCodigoSedetec;
  end;

  TTomador = class
  private
    FCpfCnpj: string;
    FEmail: string;
    FEndereco: TEndereco;
    FFantasia: string;
    FInscricaoEstadual: string;
    FInscricaoMunicipal: string;
    FRazaoSocial: string;
    FTelefone: string;
    FTipo: TTipoTomador;
  published
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Email: string read FEmail write FEmail;
    property Endereco: TEndereco read FEndereco;
    property Fantasia: string read FFantasia write FFantasia;
    property InscricaoEstadual: string read FInscricaoEstadual write FInscricaoEstadual;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Telefone: string read FTelefone write FTelefone;
    property Tipo: TTipoTomador read FTipo write FTipo;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TPrestador = class
  private
    FCNPJ: string;
    FEmail: string;
    FEndereco: TEndereco;
    FFantasia: string;
    FFone: string;
    FInscricaoMunicipal: string;
    FRazaoSocial: string;
  published
    property CNPJ: string read FCNPJ write FCNPJ;
    property Email: string read FEmail write FEmail;
    property Endereco: TEndereco read FEndereco;
    property Fantasia: string read FFantasia write FFantasia;
    property Fone: string read FFone write FFone;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TProvedor = class
  private
    FCodigoMunicipio: Integer;
    FEmitenteCnpj: string;
    FEmitenteIE: string;
    FEmitenteRazaoSocial: string;
    FEmitenteSenha: string;
    FEmitenteUsuario: string;
    FProducao: Boolean;
    FSenhaCertificado: string;
    FUF: string;
    FUrlCertificado: string;
    FPathLocal : string;
    FSalvarArquivoSoap: boolean;
    FFraseSecreta: String;
    FChaveAutorizacao: String;
    FChaveAcesso: String;
    FLayout: integer;
    FMetodoEnvio: integer;

  published
    property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
    property EmitenteCnpj: string read FEmitenteCnpj write FEmitenteCnpj;
    property EmitenteIE: string read FEmitenteIE write FEmitenteIE;
    property EmitenteRazaoSocial: string read FEmitenteRazaoSocial write FEmitenteRazaoSocial;
    property EmitenteSenha: string read FEmitenteSenha write FEmitenteSenha;
    property EmitenteUsuario: string read FEmitenteUsuario write FEmitenteUsuario;
    property Producao: Boolean read FProducao write FProducao;
    property SenhaCertificado: string read FSenhaCertificado write FSenhaCertificado;
    property UF: string read FUF write FUF;
    property UrlCertificado: string read FUrlCertificado write FUrlCertificado;
    property PathLocal : string read FPathLocal  write FPathLocal;
    property SalvarArquivoSoap : boolean read FSalvarArquivoSoap write FSalvarArquivoSoap;
    property FraseSecreta: String read FFraseSecreta write FFraseSecreta;
    property ChaveAcesso: String read FChaveAcesso write FChaveAcesso;
    property ChaveAutorizacao: String read FChaveAutorizacao write FChaveAutorizacao;
    property Layout : integer read FLayout write Flayout;
    property MetodoEnvio : integer read FMetodoEnvio write FMetodoEnvio;
  end;
  TCancelamento = class
    private
    FCodigo: string;
    FMotivo: string;
    FCodigoVerificacao: string;
    FNumeroLote: string;
    FSerieNfse: string;
    FNumeroRps: string;
    FValorNfse: string;
    FChaveNfse: string;

    published
      property Codigo : string read FCodigo write FCodigo;
      property Motivo : string read FMotivo write FMotivo;
      property NumeroLote : string read FNumeroLote write FNumeroLote;
      property CodigoVerificacao : string read FCodigoVerificacao write FCodigoVerificacao;
      property SerieNfse : string read FSerieNfse write FSerieNfse;
      property NumeroRps : string read FNumeroRps write FNumeroRps;
      property ValorNfse : string read FValorNfse write FValorNfse;
      property ChaveNfse : string read FChaveNfse write FChaveNfse;
  end;

  TNFSe = class(TJsonDTO)
  private
    FnfseId: integer;
    FChaveNFSe: Integer;
    [SuppressZero]
    FDataEmissao: TDateTime;
    FIncentivadorCultural: Boolean;
    FNaturezaOperacao: TNaturezaOperacao;
    FRegimeEspecialTributacao: TRegimeEspecialTributacao;
    FNumero: string;
    FNumeroLote: string;
    FOptanteSimplesNacional: Boolean;
    FPrestador: TPrestador;
    FProvedor: TProvedor;
    FSerie: string;
    FServicos: TServicos;
    FTomador: TTomador;
    FIndependentNfse: boolean;
    Ftokenid: string;
    FsocketId: string;
    procedure SetsocketId(const Value: string);
    procedure Settokenid(const Value: string);
  published
    property IndependentNfse : boolean read FIndependentNfse write FIndependentNfse;
    property nfseId : integer read FnfseId write FnfseId;
    property ChaveNFSe: Integer read FChaveNFSe write FChaveNFSe;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property IncentivadorCultural: Boolean read FIncentivadorCultural write FIncentivadorCultural;
    property NaturezaOperacao: TNaturezaOperacao read FNaturezaOperacao write FNaturezaOperacao;
    property Numero: string read FNumero write FNumero;
    property NumeroLote: string read FNumeroLote write FNumeroLote;
    property OptanteSimplesNacional: Boolean read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property Prestador: TPrestador read FPrestador;
    property Provedor: TProvedor read FProvedor;
    property Serie: string read FSerie write FSerie;
    property Servicos: TServicos read FServicos;
    property Tomador: TTomador read FTomador;
    property RegimeEspecialTributacao: TRegimeEspecialTributacao read FRegimeEspecialTributacao write FRegimeEspecialTributacao;
    property tokenid : string read Ftokenid write Settokenid;
    property socketId : string read FsocketId write SetsocketId;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TServicos }

constructor TServicos.Create;
begin
  inherited;
end;

destructor TServicos.Destroy;
begin
  FItensServico.Free;
  inherited;
end;

function TServicos.GetAsJson: string;
begin
  RefreshArray<TItensServico>(FItensServico, FItensServicoArray);
  Result := inherited;
end;

function TServicos.GetItensServico: TObjectList<TItensServico>;
begin
  Result := ObjectList<TItensServico>(FItensServico, FItensServicoArray);
end;

{ TTomador }

constructor TTomador.Create;
begin
  inherited;
  FEndereco := TEndereco.Create;
end;

destructor TTomador.Destroy;
begin
  FEndereco.Free;
  inherited;
end;

{ TPrestador }

constructor TPrestador.Create;
begin
  inherited;
  FEndereco := TEndereco.Create;
end;

destructor TPrestador.Destroy;
begin
  FEndereco.Free;
  inherited;
end;

{ TRoot }

constructor TNFSe.Create;
begin
  inherited;
  FProvedor := TProvedor.Create;
  FPrestador := TPrestador.Create;
  FTomador := TTomador.Create;
  FServicos := TServicos.Create;
end;

destructor TNFSe.Destroy;
begin
  FProvedor.Free;
  FPrestador.Free;
  FTomador.Free;
  FServicos.Free;
  inherited;
end;

procedure TNFSe.SetsocketId(const Value: string);
begin
  FsocketId := Value;
end;

procedure TNFSe.Settokenid(const Value: string);
begin
  Ftokenid := Value;
end;

end.

