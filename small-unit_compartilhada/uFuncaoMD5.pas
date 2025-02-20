unit uFuncaoMD5;

interface

uses
  IdHashMessageDigest, IdGlobal, System.SysUtils, System.Classes;

  function MD5File(dirArquivo :string): string;
  function MD5String(valor: string): string;

implementation

function MD5String(valor :string):string;
var
  idmd5 : TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := LowerCase(idmd5.HashStringAsHex(valor,IndyTextEncoding_OSDefault));
  finally
    idmd5.Free;
  end;
end;

function MD5File(dirArquivo :string):string;
var
  idmd5 : TIdHashMessageDigest5;
  sfile : TFileStream;
begin
  if not FileExists(dirArquivo) then
  begin
    Result := MD5String('');
    Exit;
  end;

  idmd5 := TIdHashMessageDigest5.Create;
  sfile := TFileStream.Create(dirArquivo, fmOpenRead OR fmShareDenyWrite);

  try
    //result := LowerCase(idmd5.HashStreamAsHex(sfile));
    Result := idmd5.HashStreamAsHex(sfile);
  finally
    FreeAndNil(idmd5);
    FreeAndNil(sfile);
  end;
end;


end.
