unit uTypesImpressao;

interface

type
  TImpressao = (
               impHTML,
               impPDF,
               impTXT,
               impWindows
               );


  function StrToTImp(value:string): Timpressao;

implementation

uses uSmallConsts;

function StrToTImp(value:string): Timpressao;
begin
  if value = 'HTML' then
    Result := impHTML;

  if value = 'PDF' then
    Result := impPDF;

  if value = 'TXT' then
    Result := impTXT;

  if value = _cImpressoraPadrao then
    Result := impWindows;
end;

end.
