unit uLogIA;

interface

uses
  uILogIA;

type
  TLogIA = class(TInterfacedObject, ILogIA)
  private
  public
    class function New: ILogIA;
    function setNomeUsuario(AcNome: String): ILogIA;
    function setNomeIA(AcNome: String): ILogIA;
    function Salvar(AenTipoUsuario: TTipoUsuario; AcTexto: String): ILogIA; virtual; abstract;
  protected
    FcNomeUsuario: String;
    FcNomeIA: String;
  end;

implementation

{ TLogIA }

class function TLogIA.New: ILogIA;
begin
  Result := Self.Create;
end;

function TLogIA.setNomeIA(AcNome: String): ILogIA;
begin
  Result := Self;

  FcNomeIA := AcNome;
end;

function TLogIA.setNomeUsuario(AcNome: String): ILogIA;
begin
  Result := Self;

  FcNomeUsuario := AcNome;
end;

end.
