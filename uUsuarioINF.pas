unit uUsuarioINF;

interface

uses
  uArquivoDATINFPadrao, uUsuarioSections;

type
  TUsuarioINF = class(TArquivoDATINFPadrao)
  private
    FcUsuario: string;
    FoGeral: TSectionGeral;
    FoHtml: TSectionHTML;
    FoOutros: TSectionOutros;
    function getGeral: TSectionGeral;
    function getHtml: TSectionHTML;
    function getOutros: TSectionOutros;
  public
    constructor Create(AcUsuario: String); overload;
    destructor Destroy; override;

    property Geral: TSectionGeral read getGeral;
    property Html: TSectionHTML read getHtml;
    property Outros: TSectionOutros read getOutros;
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

function TUsuarioINF.getGeral: TSectionGeral;
begin
  if not Assigned(FoGeral) then
    FoGeral := TSectionGeral.Create(FoIni);

  Result := FoGeral;
end;

function TUsuarioINF.getHtml: TSectionHTML;
begin
  if not Assigned(FoHtml) then
    FoHtml := TSectionHTML.Create(FoIni);

  Result := FoHtml;
end;

function TUsuarioINF.getOutros: TSectionOutros;
begin
  if not Assigned(FoOutros) then
    FoOutros := TSectionOutros.Create(FoIni);

  Result := FoOutros;
end;

function TUsuarioINF.NomeArquivo: String;
begin
  Result := FcUsuario + '.inf';
end;

end.
