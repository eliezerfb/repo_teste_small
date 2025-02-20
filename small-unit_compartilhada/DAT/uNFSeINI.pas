unit uNFSeINI;

interface

uses
  uArquivoDATINFPadrao
  , uNFSeSections
  ;

type
  TNFSeINI = class(TArquivoDATINFPadrao)
  private
    FoNFSe: TSectionNFSE;
    FoInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeitura;
    function getNFSe: TSectionNFSE;
    function getInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeitura;
  public
    destructor Destroy; override;

    property NFSE: TSectionNFSE read getNFSe;
    property InformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeitura read getInformacoesObtidasNaPrefeitura;
  protected
    function NomeArquivo: String; override;
  end;

implementation

uses TypInfo, SysUtils, IniFiles;

{ TNFSeINI }

destructor TNFSeINI.Destroy;
begin
  FreeAndNil(FoNFSe);
  FreeAndNil(FoInformacoesObtidasNaPrefeitura);
  inherited;
end;

function TNFSeINI.getNFSe: TSectionNFSE;
begin
  if not Assigned(FoNFSe) then
    FoNFSe := TSectionNFSE.Create(FoIni);

  Result := FoNFSe;
end;

function TNFSeINI.getInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeitura;
begin
  if not Assigned(FoInformacoesObtidasNaPrefeitura) then
    FoInformacoesObtidasNaPrefeitura := TSectionInformacoesObtidasNaPrefeitura.Create(FoIni);
  Result := FoInformacoesObtidasNaPrefeitura;
end;


function TNFSeINI.NomeArquivo: String;
begin
  Result := 'nfseConfig.ini';
end;

end.
