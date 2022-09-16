unit uFuncoesRetaguarda;

interface

function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String;
function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime): String;

implementation

uses
  SysUtils
  , SmallFunc
  ;

function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String; //Ficha 6237
begin
  Result :=
    'select CODIGO, SUM(vTOTAL) as TOTAL ' +
    ' from ' +
    ' (select ITENS001.CODIGO, sum(ITENS001.TOTAL)as vTOTAL ' +
    ' from ITENS001, VENDAS ' +
    ' where VENDAS.EMITIDA = ''S'' and VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) + ' and VENDAS.NUMERONF = ITENS001.NUMERONF ' +
    ' group by CODIGO ' +
    ' union ' +
    ' select ALTERACA.CODIGO, sum(ALTERACA.TOTAL)as vTOTAL'+
    ' from ALTERACA where (TIPO = ''BALCAO'') and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) + ' ' +
    ' group by CODIGO) ' +
    ' group by CODIGO order by TOTAL desc';
end;

function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime): String;
begin
  Result :=
    'select CLIENTE, sum(VTOTAL) as VTOTAL ' +
    ' from ( ' +
    ' select VENDAS.CLIENTE, sum(VENDAS.TOTAL) as VTOTAL ' +
    ' from VENDAS ' +
    ' where trim(coalesce(VENDAS.CLIENTE, '''')) <> '''' and VENDAS.EMITIDA = ''S'' and VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
    ' group by VENDAS.CLIENTE ' +
    ' union ' +
    ' select ALTERACA.CLIFOR as CLIENTE, sum(ALTERACA.TOTAL) as VTOTAL ' +
    ' from ALTERACA ' +
    ' where trim(coalesce(ALTERACA.CLIFOR, '''')) <> '''' and ALTERACA.TIPO = ''BALCAO'' and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
    ' group by ALTERACA.CLIFOR ' +
    ') ' + 
    'group by CLIENTE ' +
    'order by VTOTAL desc ';
end;

end.
