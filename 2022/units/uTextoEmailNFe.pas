unit uTextoEmailNFe;

interface

uses
  uITextoEmail, uSmallResourceString;

type
  TTextoEmailNFe = class(TInterfacedObject, ITextoEmail)
  private
    FcTexto: String;
    constructor Create;
  public
    class function New: ITextoEmail;
    function setDescrAnexo(AcDescr: String): ITextoEmail;
    function setDataEmissao(AdData: TDateTime): ITextoEmail;
    function setNumeroDocumento(AcNumeroDocumento: String): ITextoEmail;
    function setChaveAcesso(AcChaveAcesso: String): ITextoEmail;
    function setPropaganda(AcPropaganda: String): ITextoEmail;
    function RetornarTexto: String;
  end;

implementation

uses SysUtils;

{ TTextoEmailNFe }

class function TTextoEmailNFe.New: ITextoEmail;
begin
  Result := Self.Create;
end;

function TTextoEmailNFe.setChaveAcesso(AcChaveAcesso: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<CHAVEACESSO>', AcChaveAcesso, [rfReplaceAll]);
end;

function TTextoEmailNFe.setDataEmissao(AdData: TDateTime): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<DATAEMISSAO>', DateToStr(AdData), [rfReplaceAll]);
end;

function TTextoEmailNFe.setNumeroDocumento(AcNumeroDocumento: String): ITextoEmail;
begin
  Result := Self;

  if Pos('/', AcNumeroDocumento) <= 0 then
    AcNumeroDocumento := Copy(AcNumeroDocumento, 1, Length(AcNumeroDocumento)-3) + '/' + Copy(AcNumeroDocumento, Length(AcNumeroDocumento)-2, 3);

  FcTexto := StringReplace(FcTexto, '<NUMERODOC>', AcNumeroDocumento, [rfReplaceAll]);
end;

function TTextoEmailNFe.RetornarTexto: String;
begin
  Result := StringReplace(FcTexto, '<DESCRDOC>', 'NF-e', [rfReplaceAll]);
end;

constructor TTextoEmailNFe.Create;
begin
  FcTexto := _cMsgTextoEmailDoc;
end;

function TTextoEmailNFe.setDescrAnexo(AcDescr: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<DESCREXTANEXO>', AcDescr, [rfReplaceAll]);
end;

function TTextoEmailNFe.setPropaganda(AcPropaganda: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := AcPropaganda + sLineBreak + sLineBreak + FcTexto;
end;

end.
