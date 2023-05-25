unit uCriptografia;

interface

uses
(*
    {$IF CompilerVersion >= 17.0}
      System.SysUtils
    {$ELSE}
      SysUtils
    {$IFEND}
*)
  {$IFDEF VER150}
      SysUtils  
  {$ELSE}
      System.SysUtils  
  {$ENDIF}
  , LbCipher
  , LbClass;

function SmallDecrypt(sChave,sValor:string):string;
function SmallEncrypt(sChave,sValor:string):string;

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

function SmallEncrypt(sChave,sValor:string):string;
var
  LbBlowfish : TLbBlowfish;
begin
  Result := '';

  try
    try
      LbBlowfish := TLbBlowfish.Create(nil);

      LbBlowfish.GenerateKey(sChave);
      Result := LbBlowfish.EncryptString(sValor);
    finally
      FreeAndNil(LbBlowfish);
    end;
  except
    Result := '';
  end;
end;

end.
