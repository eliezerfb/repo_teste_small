unit uSectionsInformacoesObtidasNaPrefeitura;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionInformacoesObtidasNaPrefeituraINI = class(TSectionDATPadrao)
  private
    function getPadraoProvedor: String;
  public
    property PadraoProvedor: String read getPadraoProvedor;
  protected
    function Section: String; override;
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionNFEINI }

function TSectionInformacoesObtidasNaPrefeituraINI.Section: String;
begin
  Result := _cSectionNFSE_InformacoesObtidasPrefeitura;
end;

function TSectionInformacoesObtidasNaPrefeituraINI.getPadraoProvedor: String;
begin
  Result := FoIni.ReadString(_cSectionNFSE_InformacoesObtidasPrefeitura, _cIdentiPadraoCidade, '');
end;

end.
