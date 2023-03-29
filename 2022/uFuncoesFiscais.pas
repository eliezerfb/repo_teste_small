unit uFuncoesFiscais;

interface

uses
  SysUtils
  , Classes
  , Forms
  , Controls
  , Windows
  , DB
  , IBQuery
  , IBDatabase
  , unit7
;


function CampoICMporNatureza(vCampo,vNatureza : string; Transacao : TIBTransaction) : string;

implementation

function CampoICMporNatureza(vCampo,vNatureza : string;  Transacao : TIBTransaction) : string;
var
  vSQL : string;
  IBQTemp: TIBQuery;
begin
  Result := '';

  vSQL := ' Select '+vCampo+
          ' From ICM '+
          ' Where NOME = '+QuotedStr(vNatureza);

  IBQTemp := Form7.CriaIBQuery(Transacao);

  try
    IBQTemp.SQL.Text := vSQL;
    IBQTemp.Open;
    Result := IBQTemp.fieldbyname(vCampo).AsString;
  except
  end;

  FreeAndNil(IBQTemp);
end;

end.
