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

function NFeFinalidadeDevolucao(sFinnfe: String): Boolean;
function ProdutoOrigemImportado(sOrigem: String): Boolean;
function CampoICMporNatureza(vCampo,vNatureza : string; Transacao : TIBTransaction) : string;
function RetornaValorSQL(vSQL : string;  Transacao : TIBTransaction) : variant;

implementation

function NFeFinalidadeDevolucao(sFinnfe: String): Boolean;
begin
  Result := sFinnfe = '4';
end;

function ProdutoOrigemImportado(sOrigem: String): Boolean;
begin
  Result := False;
  if (Copy(Form7.ibDataSet4CST.AsString,1,1) = '1') //1 - Estrangeira - Importação direta, exceto a indicada no código 6
  or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '2') //2 - Estrangeira - Adquirida no mercado interno, exceto a indicada no código 7
  or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '3') //3 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 40% (quarenta por cento) e inferior ou igual a 70% (setenta por cento)
  or (Copy(Form7.ibDataSet4CST.AsString,1,1) = '8') //8 - Nacional, mercadoria ou bem com Conteúdo de Importação superior a 70% (setenta por cento) 
   then // Produto importado
    Result := True;
end;

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


function RetornaValorSQL(vSQL : string;  Transacao : TIBTransaction) : variant;
var
  IBQTemp: TIBQuery;
begin
  IBQTemp := Form7.CriaIBQuery(Transacao);

  try
    IBQTemp.SQL.Text := vSQL;
    IBQTemp.Open;
    Result := IBQTemp.Fields[0].AsVariant;
  except
  end;

  FreeAndNil(IBQTemp);
end;


end.
