{ *********************************************************************** }
{ Interfaceamento da DLL de controle de uso de recursos dos módulos       }
{ Compatível com Delphi 7 ou superior                                     }
{                                                                         }
{ Carrega a dll e importa dinamicamente os métodos, estende-os para       }
{ serem acionados e liberado a dll da memória ao destruir o objeto        }
{                                                                         }
{ Autor: Sandro Luis da Silva                                             }
{ *********************************************************************** }

unit uClasseRecursos;

interface

uses
  Classes
  , Controls
  , SysUtils
  , Windows
  , Dialogs
  , IBDatabase
  , uTypesRecursos
  ;

const FDLLName = 'recursos.dll';

type
  TResourceModule = class(TComponent)
  private
    FhDLL: THandle;
    _LimiteRecurso: function(sRecurso : TRecursos): TDate; stdcall;
    _QuantidadeRecurso: function(sRecurso: TRecursos): integer; stdcall;
    FInicializada: Boolean;
    function CarregaDLL: Boolean;
    procedure Import(var Proc: pointer; Name: PAnsiChar);
    procedure Desinicializa;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Inicializa: Boolean;
    function Limite(idRecurso: TRecursos): TDate;
    function Quantidade(idRecurso: TRecursos): Integer;
    property Inicializada: Boolean read FInicializada;
  published

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Smallsoft', [TResourceModule]);
end;

{ TResourceModule }

function TResourceModule.CarregaDLL: Boolean;
begin
  Result := False;
  if FhDLL = 0 then
  begin

    try
      {$IFDEF VER150}
      FhDLL := LoadLibrary(PChar(FDLLName)); //carregando dll
      {$ELSE}
      FhDLL := LoadLibrary(PWideChar(FDLLName)); //carregando dll
      {$ENDIF}

      if FhDLL > 0 then
      begin

        //importando métodos dinamicamente
        Import(@_LimiteRecurso, 'LimiteRecurso');
        Import(@_QuantidadeRecurso, 'QuantidadeRecurso');

        Result := True;

      end
      else
        ShowMessage('Arquivo não encontrado '+ #13 + FDLLName);

    except
      on E: Exception do
      begin
        ShowMessage('Erro ao carregar método' + #13 +
                    FDLLName + #13 + E.Message);
      end;
    end;
    
  end;

end;

constructor TResourceModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TResourceModule.Desinicializa;
begin
  // Controla descarregamento da DLL
  if FhDLL <> 0 then
  begin

    try
      FreeLibrary(FhDLL); //descarregando dll

      FhDLL := 0;

      _LimiteRecurso     := nil;
      _QuantidadeRecurso := nil;
      
    except
    
    end;

  end;

end;

destructor TResourceModule.Destroy;
begin
  Desinicializa;
  inherited;
end;

procedure TResourceModule.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FhDLL, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar o método ' + Name + ' da biblioteca ' + FDLLName);
  end;
end;

function TResourceModule.Inicializa: Boolean;
begin
  Result := CarregaDLL;
  FInicializada := Result;
end;

function TResourceModule.Limite(idRecurso: TRecursos): TDate;
begin
  Result := StrToDate('01/01/1900');
  try
    Result := _LimiteRecurso(idRecurso);
  except

  end;
end;

function TResourceModule.Quantidade(idRecurso: TRecursos): Integer;
begin
  try
    Result := _QuantidadeRecurso(idRecurso);
  except

  end;
end;

end.
