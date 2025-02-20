unit uAssinaturaDigital;

interface

uses
  uIAssinaturaDigital, LbRSA, LbAsym, uFuncaoMD5, System.Classes;

type
  TAssinaturaDigital = class(TInterfacedObject, IAssinaturaDigital)
  private
    function RetornarAssinatura(AcTexto: String): String;
  public
    class function New: IAssinaturaDigital;
    function AssinarTexto(AcTexto: String): String;
    function AssinarArquivo(AcCaminhoArquivo: String): String;
  end;

implementation

uses TypInfo, uSmallConsts, SysUtils;

{ TAssinaturaDigital }

function TAssinaturaDigital.AssinarArquivo(AcCaminhoArquivo: String): String;
var
  oArq: TextFile;
  slArquivo: TStringList;
begin
  slArquivo := TStringList.Create;
  try
    slArquivo.LoadFromFile(AcCaminhoArquivo);
    Result := RetornarAssinatura(MD5String(slArquivo.Text));
    try
      AssignFile(oArq, AcCaminhoArquivo);
      Append(oArq);
      Writeln(oArq,'EAD'+Result);
      CloseFile(oArq);
    except
    end;
  finally
    FreeAndNil(slArquivo);
  end;
end;

function TAssinaturaDigital.AssinarTexto(AcTexto: String): String;
begin
  Result := AcTexto + RetornarAssinatura(MD5String(AcTexto));
end;

class function TAssinaturaDigital.New: IAssinaturaDigital;
begin
  Result := Self.Create;
end;

function TAssinaturaDigital.RetornarAssinatura(AcTexto: String): String;
var
  cHashArq: string;
  oLbRSASSA1: TLbRSASSA;
begin
  oLbRSASSA1 := TLbRSASSA.Create(nil);
  try
    oLbRSASSA1.HashMethod := hmMD5;
    oLbRSASSA1.KeySize := aks1024;

    oLbRSASSA1.PrivateKey.ExponentAsString :=  _cPrivateKeyExponent;
    oLbRSASSA1.PrivateKey.ModulusAsString := _cPrivateKeyModulus;

    oLbRSASSA1.SignString(cHashArq);
    Result := oLbRSASSA1.Signature.IntStr;
  finally
    FreeAndNil(oLbRSASSA1);
  end;
end;

end.
