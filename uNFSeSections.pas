unit uNFSeSections;

interface

uses
  uSectionDATPadrao, uSmallEnumerados;

type
  TSectionNFSE = class(TSectionDATPadrao)
  private
    function getAmbiente: tAmbienteNFSe;
    procedure setAmbiente(const Value: tAmbienteNFSe);
  public
    function AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
    property Ambiente: tAmbienteNFSe read getAmbiente write setAmbiente;
  protected
    function Section: String; override;
  end;

  TSectionInformacoesObtidasNaPrefeitura = class(TSectionDATPadrao)
  private
    function getPadraoProvedor: String;
  public
    property PadraoProvedor: String read getPadraoProvedor;
  protected
    function Section: String; override;
  end;

type
  TSectionNFSE_BD = class(TSectionBD)
  private
    function getObsNaDescricao: Boolean;
    function getConfObsNaDescricao: string;
    procedure setObsNaDescricao(const Value: Boolean);
  public
    property ObsNaDescricao: Boolean read getObsNaDescricao write setObsNaDescricao;
    property ConfObsNaDescricao: string read getConfObsNaDescricao;
  protected
  end;

implementation

uses SysUtils, uSmallConsts;

{ TSectionNFEINI }

function TSectionNFSE.getAmbiente: tAmbienteNFSe;
begin
  Result := tAmbienteNFSe(FoIni.ReadInteger(Section, _cIdentNFSEAmbiente, Ord(tanfsHomologacao)));
end;

function TSectionNFSE.Section: String;
begin
  Result := _cSectionNFSE;
end;

procedure TSectionNFSE.setAmbiente(const Value: tAmbienteNFSe);
begin
  FoIni.WriteInteger(Section, _cIdentNFEAmbiente, Ord(Value));
end;

function TSectionNFSE.AmbienteToStr(AenAmbiente: tAmbienteNFSe): String;
begin
  Result := _cAmbienteHomologacao;
  if AenAmbiente = tanfsProducao then
    Result := _cAmbienteProducao;
end;

{ TSectionInformacoesObtidasNaPrefeitura }

function TSectionInformacoesObtidasNaPrefeitura.Section: String;
begin
  Result := _cSectionNFSE_InformacoesObtidasPrefeitura;
end;

function TSectionInformacoesObtidasNaPrefeitura.getPadraoProvedor: String;
begin
  Result := FoIni.ReadString(_cSectionNFSE_InformacoesObtidasPrefeitura, _cIdentiPadraoCidade, '');
end;

{ TSectionNFSE_BD }

function TSectionNFSE_BD.getConfObsNaDescricao: string;
begin
  Result := getValorBD(_cObsNaDescricaoNFSE);
end;

function TSectionNFSE_BD.getObsNaDescricao: Boolean;
begin
  Result := getValorBD(_cObsNaDescricaoNFSE) = '1';
end;

procedure TSectionNFSE_BD.setObsNaDescricao(const Value: Boolean);
var
  valorBD : string;
begin
  if Value then
    valorBD := '1'
  else
    valorBD := '0';

  setValorBD(_cObsNaDescricaoNFSE,
             'Gera observação junto com a descrição dos serviços',
             valorBD);

end;

end.
