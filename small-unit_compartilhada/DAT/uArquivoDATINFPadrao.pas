unit uArquivoDATINFPadrao;

interface

uses
  IniFiles
  , Forms
  , SysUtils
  , IbQuery
  , IBDatabase
  ;

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

//Mauricio Parizotto 2023-11-20  
type
  TConfiguracoesSistemaBD = class
  private
    FoTRANSACTION: TIBTransaction;
  public
    property Transaction: TIBTransaction read FoTRANSACTION;
    constructor Create(IBTRANSACTION: TIBTransaction);
    destructor Destroy; override;
  protected
  end;

implementation

{ TArquivoDATINFPadrao }

procedure TArquivoDATINFPadrao.CarregarArquivo;
begin
  { Caso o arquivo n�o esteja na pasta raiz do EXE deve ser feito OVERRIDE
    deste m�todo na classe filha e usar o mesmo comando abaixo, mas
    utilizando o caminho diferente.
    Fazendo isso automaticamente ir� buscar no novo caminho.
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

{ TArquivoDATINF_BD }


constructor TConfiguracoesSistemaBD.Create(IBTRANSACTION: TIBTransaction);
begin
  FoTRANSACTION := IBTRANSACTION;
end;

destructor TConfiguracoesSistemaBD.Destroy;
begin
  inherited;
end;

end.
