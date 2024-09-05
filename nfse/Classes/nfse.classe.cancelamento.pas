unit nfse.classe.cancelamento;

interface

uses
  Pkg.Json.DTO, System.SysUtils;

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

  TNfseCancelamento = class(TJsonDTO)
  private
    FChaveNfse: String;
    FCodigo: string;
    FCodigoVerificacao: string;
    FMotivo: string;
    FNumeroLote: string;
    FNumeroNfse: string;
    FNumeroRPS: string;
    FOptanteSimplesNacional: Boolean;
    FProvedor: TProvedor;
    FSerieNfse: string;
    FValorNfse: string;
    FnfseId: integer;
    FIndependentNfse: boolean;
    Ftokenid: string;
    FsocketId: string;
    procedure SetsocketId(const Value: string);
    procedure Settokenid(const Value: string);
  published
    property IndependentNfse : boolean read FIndependentNfse write FIndependentNfse;
    property ChaveNfse: String read FChaveNfse write FChaveNfse;
    property Codigo: string read FCodigo write FCodigo;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property Motivo: string read FMotivo write FMotivo;
    property NumeroLote: string read FNumeroLote write FNumeroLote;
    property NumeroNfse: string read FNumeroNfse write FNumeroNfse;
    property NumeroRPS: string read FNumeroRPS write FNumeroRPS;
    property OptanteSimplesNacional: Boolean read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property Provedor: TProvedor read FProvedor;
    property SerieNfse: string read FSerieNfse write FSerieNfse;
    property ValorNfse: string read FValorNfse write FValorNfse;
    property tokenid : string read Ftokenid write Settokenid;
    property socketId : string read FsocketId write SetsocketId;

    property nfseId : integer read FnfseId write FnfseId;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TNfseCancelamento }

constructor TNfseCancelamento.Create;
begin
  inherited;
  FProvedor := TProvedor.Create;
end;

destructor TNfseCancelamento.Destroy;
begin
  FProvedor.Free;
  inherited;
end;


procedure TNfseCancelamento.SetsocketId(const Value: string);
begin
  FsocketId := Value;
end;

procedure TNfseCancelamento.Settokenid(const Value: string);
begin
  Ftokenid := Value;
end;

end.
