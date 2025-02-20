unit uFrenteINI;

interface

uses
  uArquivoDATINFPadrao, uSectionFrentedeCaixaINI;

type
  TFreteINI = class(TArquivoDATINFPadrao)
  private
    FoFrenteCaixa: TSectionFrentedeCaixa;
    function getFrentedeCaixa: TSectionFrentedeCaixa;
  public
    destructor Destroy; override;
    property FrentedeCaixa: TSectionFrentedeCaixa read getFrentedeCaixa;    
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
  inherited;
end;

function TFreteINI.getFrentedeCaixa: TSectionFrentedeCaixa;
begin
  if not Assigned(FoFrenteCaixa) then
    FoFrenteCaixa := TSectionFrentedeCaixa.Create(FoIni);

  Result := FoFrenteCaixa;
end;

function TFreteINI.NomeArquivo: String;
begin
  Result := 'FRENTE.INI';
end;

end.
