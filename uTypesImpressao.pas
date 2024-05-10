unit uTypesImpressao;

interface

type
  TImpressao = (
               impHTML,
               impPDF,
               impTXT
               );


  function StrToTImp(value:string): Timpressao;

implementation

function StrToTImp(value:string): Timpressao;
begin
  if value = 'HTML' then
    Result := impHTML;

  if value = 'PDF' then
    Result := impPDF;

  if value = 'TXT' then
    Result := impTXT;
end;

end.
