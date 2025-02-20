unit uSistema;

interface

uses
  System.SysUtils;

type
  TSistema = class
  private
    class var Sistema: TSistema;

    FCertificadoDtVal : TDate;
    FCertificadoTipo : string;
    FTema : string;
    FSerial : string;

    function GetCertificadoDtVal: TDate;
    procedure SetCertificadoDtVal(const Value: TDate);
    function GetCertificadoTipo: string;
    procedure SetCertificadoTipo(const Value: string);
    function GetTema: string;
    procedure SetTema(const Value: string);
    function GetSerial: string;
    procedure SetSerial(const Value: string);
  published
    property CertificadoDtVal: TDate read GetCertificadoDtVal write SetCertificadoDtVal;
    property CertificadoTipo: string read GetCertificadoTipo write SetCertificadoTipo;
    property Tema: string read GetTema write SetTema;
    property Serial: string read GetSerial write SetSerial;
  public
    class function GetInstance: TSistema;
    class procedure Destroy;
  end;

implementation

{ TSistema }

class function TSistema.GetInstance: TSistema;
begin
  if not Assigned(Sistema) then
  begin
    Sistema := TSistema(inherited NewInstance);
  end;

  Result := Sistema;
end;

function TSistema.GetSerial: string;
begin
  if not Assigned(Sistema) then
  begin
    Sistema := TSistema(inherited NewInstance);
  end;

  Result := FSerial;
end;

function TSistema.GetTema: string;
begin
  if not Assigned(Sistema) then
  begin
    Sistema := TSistema(inherited NewInstance);
  end;

  Result := FTema;
end;

class procedure TSistema.destroy;
begin
  if Assigned(Sistema) then
  begin
    FreeAndNil(Sistema);
  end;
end;

procedure TSistema.SetCertificadoDtVal(const Value: TDate);
begin
  FCertificadoDtVal := Value;
end;

function TSistema.GetCertificadoDtVal: TDate;
begin
  Result := FCertificadoDtVal;
end;

function TSistema.GetCertificadoTipo: string;
begin
  Result := FCertificadoTipo;
end;

procedure TSistema.SetCertificadoTipo(const Value: string);
begin
  FCertificadoTipo := Value;
end;

procedure TSistema.SetSerial(const Value: string);
begin
  FSerial := Value;
end;

procedure TSistema.SetTema(const Value: string);
begin
  FTema := Value;
end;

end.
