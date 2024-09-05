unit nfse.classe.retorno;

interface

uses
  Pkg.Json.DTO;


type
  TNFSeRetorno = class(TJsonDTO)
  private
    FCancelada: Boolean;
    FCodigoVerificacao: string;
    FCorrecao: string;
    FData: TDateTime;
    FMensagem: string;
    FNumero: string;
    FProtocolo: string;
    FSituacao: integer;
    FTipoEnvio: Integer;
    FUrl: string;
    FMensagemCompleta : string;
    FNumero_origem: string;
    FSucesso : boolean;
    FnfseId: integer;
    FconsultType: string;
    FattempNumber: integer;
    FChave: string;
    FException: string;
    procedure SetChave(const Value: string);

  published
    property Protocolo: string read FProtocolo write FProtocolo;
    property Mensagem: string read FMensagem write FMensagem;
    property Correcao: string read FCorrecao write FCorrecao;
    property Situacao: integer read FSituacao write FSituacao;
    property Numero: string read FNumero write FNumero;
    property Numero_origem : string read FNumero_origem write FNumero_origem;
    property Url: string read FUrl write FUrl;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property Cancelada: Boolean read FCancelada write FCancelada;
    property Data: TDateTime read FData write FData;
    property TipoEnvio: Integer read FTipoEnvio write FTipoEnvio;
    property MensagemCompleta : string read FMensagemCompleta write FMensagemCompleta;
    property Sucesso : boolean read FSucesso write FSucesso;
    property nfseId  : integer read FnfseId write FnfseId;
    property consultType : string read FconsultType write FconsultType;
    property attempNumber : integer read FattempNumber write FattempNumber;
    property Chave : string read FChave write SetChave;
    property Exception : string read FException write FException;
  end;


implementation


{ TNFSeRetorno }



{ TNFSeRetorno }

procedure TNFSeRetorno.SetChave(const Value: string);
begin
  FChave := Value;
end;

{ TNFSeRetorno }


end.
