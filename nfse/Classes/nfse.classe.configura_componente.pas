unit nfse.classe.configura_componente;

interface
  Type
  TConfiguracaoProvedor = class
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
    FChaveAutorizacao: string;
    FChaveAcesso: String;
    FEmitenteInscricaoMunicipal : string;
    FLayout: integer;
    FMetodoEnvio: integer;
  published
    property CodigoMunicipio: Integer read FCodigoMunicipio write FCodigoMunicipio;
    property EmitenteCnpj: string read FEmitenteCnpj write FEmitenteCnpj;
    property EmitenteIE: string read FEmitenteIE write FEmitenteIE;
    property EmitenteInscricaoMunicipal: string read FEmitenteInscricaoMunicipal write FEmitenteInscricaoMunicipal;
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
    property ChaveAutorizacao: string read FChaveAutorizacao write FChaveAutorizacao;
    property Layout: integer read FLayout write FLayout;
    property MetodoEnvio : integer read FMetodoEnvio write FMetodoEnvio;
  end;

implementation

{ TConfiguracaoProvedor }


end.
