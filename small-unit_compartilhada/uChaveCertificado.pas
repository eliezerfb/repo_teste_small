unit uChaveCertificado;

interface

uses
  ACBrBase
  , ACBrOpenSSLUtils
  , System.SysUtils
  , System.Classes
  ;

  function ExtraiChavesCertificado(sRquivoPfx, sSenhaPfx, sArquivoKey, sArquivoPem : string; out erro : string) : boolean;

implementation

function ExtraiChavesCertificado(sRquivoPfx, sSenhaPfx, sArquivoKey, sArquivoPem : string; out erro : string) : boolean;
var
  ACBrOpenSSLUtils : TACBrOpenSSLUtils;
  wSL: TStringList;
begin
  Result := False;

  try
    try
      ACBrOpenSSLUtils := TACBrOpenSSLUtils.Create(nil);
      wSL := TStringList.Create;

      ACBrOpenSSLUtils.LoadPFXFromFile(sRquivoPfx, sSenhaPfx);

      // Salvando arquivo Chave Privada
      wSL.Text := ACBrOpenSSLUtils.PrivateKeyAsString;
      wSL.SaveToFile(sArquivoKey);

      // Salvando arquivo Certificado
      wSL.Text := ACBrOpenSSLUtils.CertificateAsString;
      wSL.SaveToFile(sArquivoPem);

      Result := True;
    finally
      FreeAndNil(ACBrOpenSSLUtils);
      FreeAndNil(wSL);
    end;
  except
    on e:exception do
    begin
      erro := e.Message;
    end;
  end;
end;

end.
