unit uArquivosDAT;

interface

{                                Orienta��es                                }
{
  - Utilize sempre property para novos objetos de arquivo apenas como
    somente leitura (READ) e com o m�todo GET conforme exemplos.
  - Ao implementar um novo objeto de arquivo deve dar FreeAndNil na
    variavel privada no m�todo DestuirObjetos.
  - Os objetos de cada arquivo s�o criados somente quando utilizados.
  - O caminho padr�o para criar os arquivos � na pasta raiz do EXE.
    Caso seja diferente, vide orienta��o Unit uArquivoDATINFPadrao
    no m�todo CarregarArquivo.
  - Em caso de uso global na aplica��o ser� necess�rio em alguns momentos
    chamar o m�todo RecarregarArquivos para assim recarregar os arquivos.
    Esse met�do ir� destruir todos os objetos de arquivo.
  - Caso o objeto de arquivo necessite algum dado externo para ser criado
    use o exemplo do objeto Usuario.
}

uses
  uEstoqueDAT, uSmallComINF, uUsuarioINF, uFrenteINI, uNFeINI, uNFSeINI
  , uConfSisBD
  , IbdataBase
  ;

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
    FoBD: TConfBD; //Mauricio Parizotto 2023-11-20
    FoTRANSACTION: TIBTransaction; // Mauricio Parizotto 2023-11-20
    function getEstoque: TEstoqueDAT;
    function getSmallCom: TSmallComINF;
    function getUsuario: TUsuarioINF;
    procedure DestruirObjetos;
    function getFrente: TFreteINI;
    function getNFeIni: TNFeINI;
    function getNFSeIni: TNFSeINI;
    function getConfBD: TConfBD; //Mauricio Parizotto 2023-11-20
  public
    //constructor Create(AcUsuario: String);  //Mauricio Parizotto 2023-11-20
    constructor Create(AcUsuario: String; ConTransaction : TIBTransaction = nil);
    destructor Destroy; override;
    procedure RecarregarArquivos;

    property Estoque: TEstoqueDAT read getEstoque;
    property SmallCom: TSmallComINF read getSmallCom;
    property Usuario: TUsuarioINF read getUsuario;
    property Frente: TFreteINI read getFrente;
    property NFe: TNFeINI read getNFeIni;
    property NFSe: TNFSeINI read getNFSeIni;
    property BD: TConfBD read getConfBD; //Mauricio Parizotto 2023-11-20
    property Transaction: TIBTransaction read FoTRANSACTION;
  end;

implementation

uses SysUtils;

{ TArquivosIni }

//constructor TArquivosDAT.Create(AcUsuario: String); //Mauricio Parizotto 2023-11-20
constructor TArquivosDAT.Create(AcUsuario: String; ConTransaction : TIBTransaction = nil);
begin
  FcUsuario := AcUsuario;
  FoTRANSACTION := ConTransaction; //Mauricio Parizotto 2023-11-20
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
  if Assigned(FoBD) then //Mauricio Parizotto 2023-11-20
    FreeAndNil(FoBD);
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

function TArquivosDAT.getConfBD: TConfBD;
begin
  if not Assigned(FoBD) then
    FoBD := TConfBD.Create(Transaction);

  Result := FoBD;
end;

end.
