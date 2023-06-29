unit uUsuarioINF;

interface

uses
  uArquivoDATINFPadrao, uSectionGeralUsuarioINF, uSectionHTMLUsuarioINF;

type
  TUsuarioINF = class(TArquivoDATINFPadrao)
  private
    FcUsuario: string;
    FoGeral: TSectionGeralUsuario;
    FoHtml: TSectionHTMLUsuario;
    function getGeral: TSectionGeralUsuario;
    function getHtml: TSectionHTMLUsuario;
  public
    constructor Create(AcUsuario: String); overload;
    destructor Destroy; override;

    property Geral: TSectionGeralUsuario read getGeral;
    property Html: TSectionHTMLUsuario read getHtml;
  protected
    function NomeArquivo: String; override;  
  end;

implementation

uses
  SysUtils;

{ TUsuarioInf }

constructor TUsuarioINF.Create(AcUsuario: String);
begin
  FcUsuario := AcUsuario;
  // inherited Create tem que ficar depois de setar o usuario
  inherited Create;
end;

destructor TUsuarioINF.Destroy;
begin
  if Assigned(FoGeral) then
    FreeAndNil(FoGeral);

  inherited;
end;

function TUsuarioINF.getGeral: TSectionGeralUsuario;
begin
  if not Assigned(FoGeral) then
    FoGeral := TSectionGeralUsuario.Create(FoIni);

  Result := FoGeral;
end;

function TUsuarioINF.getHtml: TSectionHTMLUsuario;
begin
  if not Assigned(FoHtml) then
    FoHtml := TSectionHTMLUsuario.Create(FoIni);

  Result := FoHtml;
end;

function TUsuarioINF.NomeArquivo: String;
begin
  Result := FcUsuario + '.inf';
end;

end.
