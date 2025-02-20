unit nfse.classe.search;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TProvedor = class
  private
    FChaveAcesso: string;
    FChaveAutorizacao: string;
    FCodigoMunicipio: Integer;
    FEmitenteCnpj: string;
    FEmitenteIE: string;
    FEmitenteRazaoSocial: string;
    FEmitenteSenha: string;
    FEmitenteUsuario: string;
    FFraseSecreta: string;
    FInscricaoMunicipal: string;
    FProducao: Boolean;
    FSalvarArquivoSoap: Boolean;
    FSenhaCertificado: string;
    FUF: string;
    FUrlCertificado: string;
    FPathLocal: string;
    FLayout: integer;
  published
    property ChaveAcesso: string read FChaveAcesso write FChaveAcesso;
    property ChaveAutorizacao: string read FChaveAutorizacao write FChaveAutorizacao;
    property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
    property EmitenteCnpj: string read FEmitenteCnpj write FEmitenteCnpj;
    property EmitenteIE: string read FEmitenteIE write FEmitenteIE;
    property EmitenteRazaoSocial: string read FEmitenteRazaoSocial write FEmitenteRazaoSocial;
    property EmitenteSenha: string read FEmitenteSenha write FEmitenteSenha;
    property EmitenteUsuario: string read FEmitenteUsuario write FEmitenteUsuario;
    property FraseSecreta: string read FFraseSecreta write FFraseSecreta;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property Producao: Boolean read FProducao write FProducao;
    property SalvarArquivoSoap: Boolean read FSalvarArquivoSoap write FSalvarArquivoSoap;
    property SenhaCertificado: string read FSenhaCertificado write FSenhaCertificado;
    property UF: string read FUF write FUF;
    property UrlCertificado: string read FUrlCertificado write FUrlCertificado;
    property PathLocal : string read FPathLocal write FPathLocal;
    property Layout : integer read FLayout write Flayout;

  end;

  TClasseSearch = class(TJsonDTO)
  private
    FCodigoVerificacao: string;
    FNumeroLote: string;
    FNumeroNfse: string;
    FNumeroRps: string;
    FOptanteSimplesNacional: Boolean;
    FProtocolo: string;
    FProvedor: TProvedor;
    FTipoRps: string;
    FSerieRps : string;
    FnfseId: integer;
    FattempNumber: integer;
    FIndependentNfse: boolean;
    Ftokenid: string;
    FsocketId: string;
    procedure SetsocketId(const Value: string);
    procedure Settokenid(const Value: string);
  published
    property IndependentNfse : boolean read FIndependentNfse write FIndependentNfse;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property NumeroLote: string read FNumeroLote write FNumeroLote;
    property NumeroNfse: string read FNumeroNfse write FNumeroNfse;
    property NumeroRps: string read FNumeroRps write FNumeroRps;
    property OptanteSimplesNacional: Boolean read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Provedor: TProvedor read FProvedor;
    property TipoRps: string read FTipoRps write FTipoRps;
    property SerieRps: string read FSerieRps write FSerieRps;
    property nfseId : integer read FnfseId write FnfseId;
    property attempNumber : integer read FattempNumber write FattempNumber;
    property tokenid : string read Ftokenid write Settokenid;
    property socketId : string read FsocketId write SetsocketId;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TRoot }

constructor TClasseSearch.Create;
begin
  inherited;
  FProvedor := TProvedor.Create;
end;

destructor TClasseSearch.Destroy;
begin
  FProvedor.Free;
  inherited;
end;

procedure TClasseSearch.SetsocketId(const Value: string);
begin
  FsocketId := Value;
end;

procedure TClasseSearch.Settokenid(const Value: string);
begin
  Ftokenid := Value;
end;

end.
