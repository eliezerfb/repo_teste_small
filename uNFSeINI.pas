unit uNFSeINI;

interface

uses
  uArquivoDATINFPadrao, uSectionsNFSeINI
  , uSectionsInformacoesObtidasNaPrefeitura
  ;

type
  TNFSeINI = class(TArquivoDATINFPadrao)
  private
    FoNFSe: TSectionNFSEINI;
    FoInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeituraINI;
    function getNFSe: TSectionNFSEINI;
    function getInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeituraINI;
  public
    destructor Destroy; override;

    property NFSE: TSectionNFSEINI read getNFSe;
    property InformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeituraINI read getInformacoesObtidasNaPrefeitura;
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

function TNFSeINI.getNFSe: TSectionNFSEINI;
begin
  if not Assigned(FoNFSe) then
    FoNFSe := TSectionNFSEINI.Create(FoIni);

  Result := FoNFSe;
end;

function TNFSeINI.getInformacoesObtidasNaPrefeitura: TSectionInformacoesObtidasNaPrefeituraINI;
begin
  if not Assigned(FoInformacoesObtidasNaPrefeitura) then
    FoInformacoesObtidasNaPrefeitura := TSectionInformacoesObtidasNaPrefeituraINI.Create(FoIni);
  Result := FoInformacoesObtidasNaPrefeitura;
end;


function TNFSeINI.NomeArquivo: String;
begin
  Result := 'nfseConfig.ini';
end;

end.
