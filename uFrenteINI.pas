unit uFrenteINI;

interface

uses
  uArquivoDATINFPadrao, uFrenteSections;

type
  TFreteINI = class(TArquivoDATINFPadrao)
  private
    FoFrenteCaixa: TSectionFrentedeCaixa;
    FoOrcamento: TSectionOrcamento;
    function getFrentedeCaixa: TSectionFrentedeCaixa;
    function getOrcamento: TSectionOrcamento;
  public
    destructor Destroy; override;
    property FrentedeCaixa: TSectionFrentedeCaixa read getFrentedeCaixa;
    property Orcamento: TSectionOrcamento read getOrcamento;
  protected
    function NomeArquivo: String; override;
    procedure CarregarArquivo; override;    
  end;

implementation

uses TypInfo, SysUtils, IniFiles;

{ TFreteINI }

procedure TFreteINI.CarregarArquivo;
begin
  FoIni := TIniFile.Create('C:\Windows\' + NomeArquivo);
end;

destructor TFreteINI.Destroy;
begin
  FreeAndNil(FoFrenteCaixa);
  FreeAndNil(FoOrcamento);
  inherited;
end;

function TFreteINI.getFrentedeCaixa: TSectionFrentedeCaixa;
begin
  if not Assigned(FoFrenteCaixa) then
    FoFrenteCaixa := TSectionFrentedeCaixa.Create(FoIni);

  Result := FoFrenteCaixa;
end;

function TFreteINI.getOrcamento: TSectionOrcamento;
begin
  if not Assigned(FoOrcamento) then
    FoOrcamento := TSectionOrcamento.Create(FoIni);

  Result := FoOrcamento;
end;

function TFreteINI.NomeArquivo: String;
begin
  Result := 'FRENTE.INI';
end;

end.
