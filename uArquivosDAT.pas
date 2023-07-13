unit uArquivosDAT;

interface

{                                Orientações                                }
{
  - Utilize sempre property para novos objetos de arquivo apenas como
    somente leitura (READ) e com o método GET conforme exemplos.
  - Ao implementar um novo objeto de arquivo deve dar FreeAndNil na
    variavel privada no método DestuirObjetos.
  - Os objetos de cada arquivo são criados somente quando utilizados.
  - O caminho padrão para criar os arquivos é na pasta raiz do EXE.
    Caso seja diferente, vide orientação Unit uArquivoDATINFPadrao
    no método CarregarArquivo.
  - Em caso de uso global na aplicação será necessário em alguns momentos
    chamar o método RecarregarArquivos para assim recarregar os arquivos.
    Esse metódo irá destruir todos os objetos de arquivo.
  - Caso o objeto de arquivo necessite algum dado externo para ser criado
    use o exemplo do objeto Usuario.
}

uses
  uEstoqueDAT, uSmallComINF, uUsuarioINF, uFrenteINI, uNFeINI, uNFSeINI;

type
  TArquivosDAT = class
  private
    FcUsuario: String;
    FoEstoque: TEstoqueDAT;
    FoSmallCom: TSmallComINF;
    FoUsuario: TUsuarioINF;
    FoFrente: TFreteINI;
    FoNFe: TNFeINI;
    FoNFSe: TNFSeINI;
    function getEstoque: TEstoqueDAT;
    function getSmallCom: TSmallComINF;
    function getUsuario: TUsuarioINF;
    procedure DestruirObjetos;
    function getFrente: TFreteINI;
    function getNFeIni: TNFeINI;
    function getNFSeIni: TNFSeINI;
  public
    constructor Create(AcUsuario: String);
    destructor Destroy; override;
    procedure RecarregarArquivos;

    property Estoque: TEstoqueDAT read getEstoque;
    property SmallCom: TSmallComINF read getSmallCom;
    property Usuario: TUsuarioINF read getUsuario;
    property Frente: TFreteINI read getFrente;
    property NFe: TNFeINI read getNFeIni;
    property NFSe: TNFSeINI read getNFSeIni;
  end;

implementation

uses SysUtils;

{ TArquivosIni }

constructor TArquivosDAT.Create(AcUsuario: String);
begin
  FcUsuario := AcUsuario;
end;

destructor TArquivosDAT.Destroy;
begin
  DestruirObjetos;
    
  inherited;
end;

function TArquivosDAT.getEstoque: TEstoqueDAT;
begin
  if not Assigned(FoEstoque) then
    FoEstoque := TEstoqueDAT.Create;

  Result := FoEstoque;
end;

function TArquivosDAT.getSmallCom: TSmallComINF;
begin
  if not Assigned(FoSmallCom) then
    FoSmallCom := TSmallComINF.Create;

  Result := FoSmallCom;
end;

function TArquivosDAT.getUsuario: TUsuarioINF;
begin
  if not Assigned(FoUsuario) then
    FoUsuario := TUsuarioINF.Create(FcUsuario);

  Result := FoUsuario;
end;

procedure TArquivosDAT.RecarregarArquivos;
begin
  DestruirObjetos;
end;

procedure TArquivosDAT.DestruirObjetos;
begin
  if Assigned(FoEstoque) then
    FreeAndNil(FoEstoque);
  if Assigned(FoSmallCom) then
    FreeAndNil(FoSmallCom);
  if Assigned(FoUsuario) then
    FreeAndNil(FoUsuario);
  if Assigned(FoFrente) then
    FreeAndNil(FoFrente);
  if Assigned(FoNFe) then
    FreeAndNil(FoNFe);
  if Assigned(FoNFSe) then
    FreeAndNil(FoNFSe);
end;

function TArquivosDAT.getFrente: TFreteINI;
begin
  if not Assigned(FoFrente) then
    FoFrente := TFreteINI.Create;

  Result := FoFrente;
end;

function TArquivosDAT.getNFeIni: TNFeINI;
begin
  if not Assigned(FoNFe) then
    FoNFe := TNFeINI.Create;

  Result := FoNFe;
end;

function TArquivosDAT.getNFSeIni: TNFSeINI;
begin
  if not Assigned(FoNFSe) then
    FoNFSe := TNFSeINI.Create;

  Result := FoNFSe;
end;

end.
