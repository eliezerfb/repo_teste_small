unit uUsuarioINF;

interface

uses
  uArquivoDATINFPadrao, uSectionGeralUsuarioINF, uSectionHTMLUsuarioINF,
  uSectionOutrosUsuarioINF;

type
  TUsuarioINF = class(TArquivoDATINFPadrao)
  private
    FcUsuario: string;
    FoGeral: TSectionGeralUsuario;
    FoHtml: TSectionHTMLUsuario;
    FoOutros: TSectionOutrosUsuario;
    function getGeral: TSectionGeralUsuario;
    function getHtml: TSectionHTMLUsuario;
    function getOutros: TSectionOutrosUsuario;
  public
    constructor Create(AcUsuario: String); overload;
    destructor Destroy; override;

    property Geral: TSectionGeralUsuario read getGeral;
    property Html: TSectionHTMLUsuario read getHtml;
    property Outros: TSectionOutrosUsuario read getOutros;
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
  if Assigned(FoHtml) then
    FreeAndNil(FoHtml);
  if Assigned(FoOutros) then
    FreeAndNil(FoOutros);
    
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

function TUsuarioINF.getOutros: TSectionOutrosUsuario;
begin
  if not Assigned(FoOutros) then
    FoOutros := TSectionOutrosUsuario.Create(FoIni);

  Result := FoOutros;
end;

function TUsuarioINF.NomeArquivo: String;
begin
  Result := FcUsuario + '.inf';
end;

end.
