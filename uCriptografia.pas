unit uCriptografia;

interface

uses
  System.SysUtils
  , LbCipher
  , LbClass;

function SmallDecrypt(sChave,sValor:string):string;

implementation

function SmallDecrypt(sChave,sValor:string):string;
var
  LbBlowfish : TLbBlowfish;
begin
  Result := '';

  try
    try
      LbBlowfish := TLbBlowfish.Create(nil);

      LbBlowfish.GenerateKey(sChave);
      Result := LbBlowfish.DecryptString(sValor);
    finally
      FreeAndNil(LbBlowfish);
    end;
  except
    Result := '';
  end;
end;

end.
