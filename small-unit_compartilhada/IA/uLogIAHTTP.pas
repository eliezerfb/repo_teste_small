unit uLogIAHTTP;

interface

uses
  uILogIA, uLogIA;

type
  TLogIAHTTP = class(TLogIA)
  private
    constructor Create;
  public
    class function New: ILogIA;
    function setNomeUsuario(AcNome: String): ILogIA;
    function setNomeIA(AcNome: String): ILogIA;
    function Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA; override;
  end;

implementation

{ TLogIAHTTP }

{
*******************NECESSÁRIO IMPLEMENTAR**********************
}

constructor TLogIAHTTP.Create;
begin

end;

class function TLogIAHTTP.New: ILogIA;
begin
  Result := Self.Create;
end;

function TLogIAHTTP.Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA;
begin
  Result := Self;
end;

function TLogIAHTTP.setNomeIA(AcNome: String): ILogIA;
begin
  Result := Self;
end;

function TLogIAHTTP.setNomeUsuario(AcNome: String): ILogIA;
begin
  Result := Self;
end;

end.
