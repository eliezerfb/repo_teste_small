unit uRetornaCaptionEmailPopUpDocs;

interface

uses
  uIRetornaCaptionEmailPopUpDocs, IBDatabase, SysUtils, smallfunc_xe, uEmail;

type
  TRetornaCaptionEmailPopUpDocs = class(TInterfacedObject, IRetornaCaptionEmailPopUpDocs)
  private
    FoDataBase: TIBDatabase;
    FcCodigoClifor: String;
    FcCodigoTranspor: String;
  public
    class function New: IRetornaCaptionEmailPopUpDocs;
    function setDataBase(AoDataBase: TIBDataBase): IRetornaCaptionEmailPopUpDocs;
    function setCodigoClifor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
    function setCodigoTranspor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
    function Retornar: String;
  end;

implementation

uses
  uRetornaEmailsPessoa, uEmail;

{ TRetornaCaptionEmailPopUpDocs }

class function TRetornaCaptionEmailPopUpDocs.New: IRetornaCaptionEmailPopUpDocs;
begin
  Result := Self.Create;
end;

function TRetornaCaptionEmailPopUpDocs.Retornar: String;
var
  cEmailCli, cEmailFor: String;
begin
  Result := EmptyStr;
  
  if FcCodigoClifor <> EmptyStr then
    cEmailCli := TRetornarEmailsPessoa.New
                                      .setDataBase(FoDataBase)
                                      .setCodigoCadastro(FcCodigoClifor)
                                      .setTabela('CLIFOR')
                                      .Retornar;

  if FcCodigoTranspor <> EmptyStr then
    cEmailFor := TRetornarEmailsPessoa.New
                                    .setDataBase(FoDataBase)
                                    .setCodigoCadastro(FcCodigoTranspor)
                                    .setTabela('TRANSPOR')
                                    .Retornar;
  if ValidaEmail(cEmailCli) then
    Result := '<' + cEmailCli + '>';
  if ValidaEmail(cEmailFor) then
  begin
    if Result <> EmptyStr then
      Result := Result + ';';
    Result := Result + '<' + cEmailFor + '>';
  end;
end;

function TRetornaCaptionEmailPopUpDocs.setCodigoClifor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
begin
  Result := Self;

  FcCodigoClifor := AcCodigoCad;
end;

function TRetornaCaptionEmailPopUpDocs.setCodigoTranspor(AcCodigoCad: String): IRetornaCaptionEmailPopUpDocs;
begin
  Result := Self;
  
  FcCodigoTranspor := AcCodigoCad;  
end;

function TRetornaCaptionEmailPopUpDocs.setDataBase(AoDataBase: TIBDataBase): IRetornaCaptionEmailPopUpDocs;
begin
  Result := Self;

  FoDataBase := AoDataBase;
end;

end.
