unit uRecursosSistema;

interface

uses
{$IFDEF VER150}
  classes;
{$ELSE}
  System.Generics.Collections, REST.Json.Types;
{$M+}

{$ENDIF}

type
  TRecursos = class
  private
    FAnvisa: TDateTime;
    FBancos: TDateTime;
    FCaixa: TDateTime;
    FComandas: TDateTime;
    FContasPagar: TDateTime;
    FContasReceber: TDateTime;
    FEtiquetas: TDateTime;
    FIndicadores: TDateTime;
    FLimiteUso: TDateTime;
    FMDFE: TDateTime;
    FMKP: TDateTime;
    FMobile: TDateTime;
    FOS: TDateTime;
    FOrcamento: TDateTime;
    FQtdNFCE: Integer;
    FQtdNFE: Integer;
    FSintegra: TDateTime;
    FSped: TDateTime;
    FSpedPisCofins: TDateTime;
    FInventarioP7: TDateTime;
    FZPOS: TDateTime;
    FIntegracaoItau: TDateTime;
  published
    property Anvisa: TDateTime read FAnvisa write FAnvisa;
    property Bancos: TDateTime read FBancos write FBancos;
    property Caixa: TDateTime read FCaixa write FCaixa;
    property Comandas: TDateTime read FComandas write FComandas;
    property ContasPagar: TDateTime read FContasPagar write FContasPagar;
    property ContasReceber: TDateTime read FContasReceber write FContasReceber;
    property Etiquetas: TDateTime read FEtiquetas write FEtiquetas;
    property Indicadores: TDateTime read FIndicadores write FIndicadores;
    property LimiteUso: TDateTime read FLimiteUso write FLimiteUso;
    property MDFE: TDateTime read FMDFE write FMDFE;
    property MKP: TDateTime read FMKP write FMKP;
    property Mobile: TDateTime read FMobile write FMobile;
    property OS: TDateTime read FOS write FOS;
    property Orcamento: TDateTime read FOrcamento write FOrcamento;
    property QtdNFCE: Integer read FQtdNFCE write FQtdNFCE;
    property QtdNFE: Integer read FQtdNFE write FQtdNFE;
    property Sintegra: TDateTime read FSintegra write FSintegra;
    property Sped: TDateTime read FSped write FSped;
    property SpedPisCofins: TDateTime read FSpedPisCofins write FSpedPisCofins;
    property InventarioP7: TDateTime read FInventarioP7 write FInventarioP7;
    property ZPOS: TDateTime read FZPOS write FZPOS;
    property IntegracaoItau: TDateTime read FIntegracaoItau write FIntegracaoItau;
  end;
  
  TRecursosSistema = class
  private
    FCNPJ: string;
    FProduto: string;
    FRecursos: TRecursos;
    FSerial: string;
    FTipoCliente: string;
    FPlano: string;
    FUsuarios: Integer;
  published
    property CNPJ: string read FCNPJ write FCNPJ;
    property Produto: string read FProduto write FProduto;
    property Recursos: TRecursos read FRecursos;
    property Serial: string read FSerial write FSerial;
    property TipoCliente: string read FTipoCliente write FTipoCliente;
    property Plano: string read FPlano write FPlano;
    property Usuarios: Integer read FUsuarios write FUsuarios;
  public
    constructor Create;
    destructor Destroy; override;
  end;
  
implementation

{ TRoot }

constructor TRecursosSistema.Create;
begin
  inherited;
  FRecursos := TRecursos.Create;
end;

destructor TRecursosSistema.Destroy;
begin
  FRecursos.Free;
  inherited;
end;

end.
