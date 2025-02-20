unit uTextoEmailCCe;

interface

uses
  uITextoEmail, uSmallResourceString;

type
  TTextoEmailCCe = class(TInterfacedObject, ITextoEmail)
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

class function TTextoEmailCCe.New: ITextoEmail;
begin
  Result := Self.Create;
end;

function TTextoEmailCCe.setChaveAcesso(AcChaveAcesso: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<CHAVEACESSO>', AcChaveAcesso, [rfReplaceAll]);
end;

function TTextoEmailCCe.setDataEmissao(AdData: TDateTime): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<DATAEMISSAO>', DateToStr(AdData), [rfReplaceAll]);
end;

function TTextoEmailCCe.setNumeroDocumento(AcNumeroDocumento: String): ITextoEmail;
begin
  Result := Self;

  if Pos('/', AcNumeroDocumento) <= 0 then
    AcNumeroDocumento := Copy(AcNumeroDocumento, 1, Length(AcNumeroDocumento)-3) + '/' + Copy(AcNumeroDocumento, Length(AcNumeroDocumento)-2, 3);

  FcTexto := StringReplace(FcTexto, '<NUMERODOC>', AcNumeroDocumento, [rfReplaceAll]);
end;

function TTextoEmailCCe.RetornarTexto: String;
begin
  Result := StringReplace(FcTexto, '<DESCRDOC>', 'Carta de Correção Eletrônica da sua NF-e', [rfReplaceAll]);
end;

constructor TTextoEmailCCe.Create;
begin
  FcTexto := _cMsgTextoEmailDoc;
end;

function TTextoEmailCCe.setDescrAnexo(AcDescr: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<DESCREXTANEXO>', AcDescr, [rfReplaceAll]);
end;

function TTextoEmailCCe.setPropaganda(AcPropaganda: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := AcPropaganda + sLineBreak + sLineBreak + FcTexto;
end;

end.
