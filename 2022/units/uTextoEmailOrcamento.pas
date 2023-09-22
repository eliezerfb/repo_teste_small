unit uTextoEmailOrcamento;

interface

uses
  uITextoEmail, uSmallResourceString;

type
  TTextoEmailOrcamento = class(TInterfacedObject, ITextoEmail)
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

class function TTextoEmailOrcamento.New: ITextoEmail;
begin
  Result := Self.Create;
end;

function TTextoEmailOrcamento.setChaveAcesso(AcChaveAcesso: String): ITextoEmail;
begin
  Result := Self;
end;

function TTextoEmailOrcamento.setDataEmissao(AdData: TDateTime): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<DATAEMISSAO>', DateToStr(AdData), [rfReplaceAll]);
end;

function TTextoEmailOrcamento.setNumeroDocumento(AcNumeroDocumento: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := StringReplace(FcTexto, '<NUMERODOC>', AcNumeroDocumento, [rfReplaceAll]);
end;

function TTextoEmailOrcamento.RetornarTexto: String;
begin
  Result := FcTexto;
end;

constructor TTextoEmailOrcamento.Create;
begin
  FcTexto := _cMsgTextoEmailOrcamento;
end;

function TTextoEmailOrcamento.setDescrAnexo(AcDescr: String): ITextoEmail;
begin
  Result := Self;
end;

function TTextoEmailOrcamento.setPropaganda(AcPropaganda: String): ITextoEmail;
begin
  Result := Self;

  FcTexto := AcPropaganda + sLineBreak + sLineBreak + FcTexto;
end;

end.
