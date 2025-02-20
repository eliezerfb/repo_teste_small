unit uLogIAArquivo;

interface

uses
  uILogIA, uLogIA, System.SysUtils, System.Classes, Vcl.Forms, System.DateUtils;

type
  TLogIAArquivo = class(TLogIA)
  private
    constructor Create;
    procedure CriarEstruturaPastas;
    function RetornarNomeArquivo: String;
  public
    class function New: ILogIA;
    function setNomeUsuario(AcNome: String): ILogIA;
    function setNomeIA(AcNome: String): ILogIA;
    function Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA; override;
  end;

implementation

const
  _cCaminhoPadrao = '\LogIA\';

{ TLogIAArquivo }

constructor TLogIAArquivo.Create;
begin
  FcNomeUsuario := 'Você';
  FcNomeIA      := 'IA';

  CriarEstruturaPastas;
end;

procedure TLogIAArquivo.CriarEstruturaPastas;
begin
  if not DirectoryExists(ExtractFilePath(Application.ExeName) + '\LogIA') then
    CreateDir(ExtractFilePath(Application.ExeName) + '\LogIA');
end;

class function TLogIAArquivo.New: ILogIA;
begin
  Result := Self.Create;
end;

function TLogIAArquivo.Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA;
var
  cUsuario: String;
  lsLog: TStringList;
begin
  Result := Self;

  if AenTipoUsuario = tuUsuario then
    cUsuario := FcNomeUsuario
  else
    cUsuario := FcNomeIA;

  lsLog := TStringList.Create;
  try
    if FileExists(ExtractFilePath(Application.ExeName) + _cCaminhoPadrao + RetornarNomeArquivo) then
      lsLog.LoadFromFile(ExtractFilePath(Application.ExeName) + _cCaminhoPadrao + RetornarNomeArquivo);

    lsLog.Add(DateToStr(Date) + ' ' + TimeToStr(Time) + ' - ' + cUsuario);
    lsLog.Add(AcTexto);
    lsLog.Add(EmptyStr);

    lsLog.SaveToFile(ExtractFilePath(Application.ExeName) + _cCaminhoPadrao + RetornarNomeArquivo);
  finally
    FreeAndNil(lsLog);
  end;
end;

function TLogIAArquivo.setNomeIA(AcNome: String): ILogIA;
begin
  Result := Self;

  FcNomeIA := AcNome;
end;

function TLogIAArquivo.setNomeUsuario(AcNome: String): ILogIA;
begin
  Result := Self;

  FcNomeUsuario := AcNome;
end;

function TLogIAArquivo.RetornarNomeArquivo: String;
begin
  Result := Copy(DateToStr(Date),7,4) + Copy(DateToStr(Date),4,2) + Copy(DateToStr(Date),1,2) + '.txt';
end;

end.
