unit uArquivoDATINFPadrao;

interface

uses
  IniFiles, Forms, SysUtils;

type
  TArquivoDATINFPadrao = class
  private
  public
    constructor Create;
    destructor Destroy; override;
  protected
    FoIni: TIniFile;
    function NomeArquivo: String; virtual; abstract;
    procedure CarregarArquivo; virtual;
  end;

implementation

{ TArquivoDATINFPadrao }

procedure TArquivoDATINFPadrao.CarregarArquivo;
begin
  { Caso o arquivo não esteja na pasta raiz do EXE deve ser feito OVERRIDE
    deste método na classe filha e usar o mesmo comando abaixo, mas
    utilizando o caminho diferente.
    Fazendo isso automaticamente irá buscar no novo caminho.
  }
  FoIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + '\' + NomeArquivo);
end;

constructor TArquivoDATINFPadrao.Create;
begin
  CarregarArquivo;
end;

destructor TArquivoDATINFPadrao.Destroy;
begin
  FreeAndNil(FoIni);
  inherited;
end;

end.
