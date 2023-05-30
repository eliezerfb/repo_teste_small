{ *********************************************************************** }
{ Interfaceamento da DLL de controle de uso de recursos dos módulos       }
{ Compatível com Delphi 7 ou superior                                     }
{                                                                         }
{ Carrega a dll e importa dinamicamente os métodos, estende-os para       }
{ serem acionados e liberado a dll da memória ao destruir o objeto        }
{                                                                         }
{ Autor: Sandro Luis da Silva                                             }
{ *********************************************************************** }

unit uClasseDllRecursos;

interface

uses
  Classes
  , Controls
  , SysUtils
  , Windows
  , Dialogs
  , IBDatabase
  , IniFiles
  , uTypesRecursos
  ;

const FDLLName = 'recursos.dll';

type
  TRecursosLicenca = class//class(TComponent)
  private
    FhDLL: THandle;

    _SerialSistema: function: AnsiString; stdcall;
    _LimiteUsuarios: function: Integer; stdcall;
    _LimiteRecurso: function(sRecurso : TRecursos): TDate; stdcall;
    _QuantidadeRecurso: function(sRecurso: TRecursos): integer; stdcall;
    FInicializada: Boolean;
    function CarregaDLL: Boolean;
    procedure Import(var Proc: pointer; Name: PAnsiChar);
    procedure Desinicializa;
  protected
  public
    constructor Create; // Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Inicializa: Boolean;
    function SerialSistema: String;
    function LimiteUsuarios: Integer;
    function DtLimiteUso(idRecurso: TRecursos): TDate;
    function Quantidade(idRecurso: TRecursos): Integer;
    property Inicializada: Boolean read FInicializada;
  published

  end;

//procedure Register;

implementation

{
procedure Register;
begin
  RegisterComponents('Smallsoft', [TRecursosLicenca]);
end;
}

{ TRecursosLicenca }

function TRecursosLicenca.CarregaDLL: Boolean;
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
        Import(@_SerialSistema, 'SerialSistema');
        Import(@_LimiteUsuarios, 'LimiteUsuarios');
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

constructor TRecursosLicenca.Create; //Create(AOwner: TComponent);
begin
  inherited;// Create; //Create(AOwner);
end;

procedure TRecursosLicenca.Desinicializa;
begin
  // Controla descarregamento da DLL
  if FhDLL <> 0 then
  begin

    try
      FreeLibrary(FhDLL); //descarregando dll

      FhDLL := 0;
      FInicializada := False;

      _SerialSistema     := nil;
      _LimiteUsuarios    := nil;
      _LimiteRecurso     := nil;
      _QuantidadeRecurso := nil;    
      
    except
    
    end;

  end;

end;

destructor TRecursosLicenca.Destroy;
begin
//  Desinicializa;
  inherited;
end;

procedure TRecursosLicenca.Import(var Proc: pointer; Name: PAnsiChar);
begin
  if not Assigned(Proc) then
  begin
    Proc := GetProcAddress(FhDLL, PAnsiChar(Name));
    if Proc = nil then
      raise Exception.Create('Não foi possível carregar o método ' + Name + ' da biblioteca ' + FDLLName);
  end;
end;

function TRecursosLicenca.Inicializa: Boolean;
begin
  Result := CarregaDLL;
  FInicializada := Result;
end;

function TRecursosLicenca.DtLimiteUso(idRecurso: TRecursos): TDate;
begin
  Result := StrToDate('01/01/1900');
  try
    Result := _LimiteRecurso(idRecurso);
  except

  end;
end;

function TRecursosLicenca.Quantidade(idRecurso: TRecursos): Integer;
begin
  try
    Result := _QuantidadeRecurso(idRecurso);
  except

  end;
end;

function TRecursosLicenca.LimiteUsuarios: Integer;
begin

  try
    Result := _LimiteUsuarios;
  except
    Result := 1;
  end;
end;

function TRecursosLicenca.SerialSistema: String;
var
  Ini: TIniFile;
begin
  try
    Result := String(_SerialSistema);
  except
    on E: Exception do
    begin
      Result := '';

      Ini := TIniFile.Create('WIND0WS.L0G');
      try

        // Versão 2020 em diante
        if Ini.SectionExists('LICENCA') then
          Result  := Ini.ReadString('LICENCA','Ser','');

      except

      end;
      Ini.Free;

    end;
  end;
end;

end.
