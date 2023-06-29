unit uFuncoesRetaguarda;

interface
uses
  SysUtils
  , StrUtils
  , Classes
  , Forms
  , Winsock
  , DBGrids
  , SmallFunc
  ;

function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String;
function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime; vFiltroAddV : string = ''): String;
function SqlSelectGraficoVendas(dtInicio: TDateTime; dtFinal: TDateTime): String;
function SqlSelectGraficoVendasParciais(dtInicio: TDateTime; dtFinal: TDateTime): String;
function XmlValueToFloat(Value: String;
  SeparadorDecimalXml: String = '.'): Double;
function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
function FormatXMLToFloat(sValor: String): Double;
function TextoIdentificadorFinalidadeNFe(Value: String): String;
procedure LogRetaguarda(sTexto: String);
function GetIP: String;
procedure GetBanderiasOperadorasNFe(slForma: TStringList);
procedure GetFormasDePagamentoNFe(slForma: TStringList);
function CodigotBandNF(sBandeira: String): String;
function ValidaFormadePagamentoDigitada(sForma: String; slFormas: TStringList): String;
function IndexColumnFromName(DBGrid: TDBGrid; sNomeColuna: String): Integer;

implementation

function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String; //Ficha 6237
begin
  // Como ratear VENDA.DESCONTO, VENDAS.OUTRAS, VENDA.SEGURO, VENDAS.FRETE (ST, FCP?) nos ITENS001
  // Como ratear DESCONTO e ACR�SCIMO nos itens do cupom (desconto do item + desconto no subtotal)  
  Result :=
    'select CODIGO, SUM(vTOTAL) as TOTAL ' +
    ' from ' +
    ' (select ITENS001.CODIGO, sum(ITENS001.TOTAL) as vTOTAL ' +
    ' from ITENS001, VENDAS ' +
    ' where VENDAS.EMITIDA = ''S'' and VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) + ' and VENDAS.NUMERONF = ITENS001.NUMERONF ' +
    ' group by ITENS001.CODIGO ' +
    ' union ' +
    ' select ALTERACA.CODIGO, sum(ALTERACA.TOTAL)as vTOTAL '+
    // Sandro Silva 2022-09-19 ' from ALTERACA where ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) + ' ' +
    ' from ALTERACA ' +
    ' left join NFCE on NFCE.NUMERONF = ALTERACA.PEDIDO and NFCE.CAIXA = ALTERACA.CAIXA ' +
    ' where (NFCE.CAIXA is null or (NFCE.CAIXA is not null and (NFCE.STATUS containing ''autorizad'') or (NFCE.STATUS containing ''Finalizada''))  ) ' +
    ' and ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) ' +
    ' and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
    ' group by ALTERACA.CODIGO) ' +
    ' group by CODIGO order by TOTAL desc';
end;

function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime; vFiltroAddV : string = ''): String;
begin
  Result := ' Select CLIENTE, sum(VTOTAL) as VTOTAL ' +
            ' From ( ' +
            '   Select VENDAS.CLIENTE, sum(VENDAS.TOTAL) as VTOTAL ' +
            '   From VENDAS ' +
            '   Where trim(coalesce(VENDAS.CLIENTE, '''')) <> '''' ' +
            '     and VENDAS.EMITIDA = ''S'' ' +
            '     and VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
            vFiltroAddV+ //Mauricio Parizotto 2023-05-24
            '   Group by VENDAS.CLIENTE ' +
            '   union ' +
            '   Select ALTERACA.CLIFOR as CLIENTE, sum(ALTERACA.TOTAL) as VTOTAL ' +
            '   From ALTERACA ' +
            // Sandro Silva 2022-09-19 ' where trim(coalesce(ALTERACA.CLIFOR, '''')) <> '''' and ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + ' and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
            '     left join NFCE on NFCE.NUMERONF = ALTERACA.PEDIDO and NFCE.CAIXA = ALTERACA.CAIXA ' +
            '   Where (NFCE.CAIXA is null or (NFCE.CAIXA is not null and (NFCE.STATUS containing ''autorizad'') or (NFCE.STATUS containing ''Finalizada''))  ) ' +
            '     and trim(coalesce(ALTERACA.CLIFOR, '''')) <> '''' ' +
            '     and ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) ' +
            '     and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
            '   Group by ALTERACA.CLIFOR ' +
            ' ) ' +
            ' Group by CLIENTE ' +
            ' Order by VTOTAL desc ';
end;

function SqlSelectGraficoVendas(dtInicio: TDateTime; dtFinal: TDateTime): String;  // Ficha 6246
begin
  // D�vida com rela��o do ao total retornado nesse Select comparado ao da fun��o SqlSelectCurvaAbcClientes (soma o campo VENDAS.TOTAL)
  // SqlSelectGraficoVendasParciais (soma (VENDAS.MERCADORIA + VENDAS.SERVICOS - VENDAS.DESCONTO))
  // Onde influenciaria se SqlSelectGraficoVendasParciais tamb�m somasse a coluna VENDAS.TOTAL?
  Result :=
    'select sum(TOT) as TOT ' +
    'from ( ' +
    ' select sum(VENDAS.MERCADORIA + VENDAS.SERVICOS - VENDAS.DESCONTO) as TOT ' +
    ' from VENDAS, ICM ' +
    ' where EMITIDA = ''S'' ' +
    ' and VENDAS.EMISSAO between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) + ' and ICM.NOME=VENDAS.OPERACAO and ICM.INTEGRACAO<>'''' ' +
    ' union ' +
    // Sandro Silva 2022-09-19 'select sum(ALTERACA.TOTAL) as TOT from ALTERACA where ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
    ' select sum(ALTERACA.TOTAL) as TOT ' +
    ' from ALTERACA ' +
    ' left join NFCE on NFCE.NUMERONF = ALTERACA.PEDIDO and NFCE.CAIXA = ALTERACA.CAIXA ' +
    ' where (NFCE.CAIXA is null or (NFCE.CAIXA is not null and (NFCE.STATUS containing ''autorizad'') or (NFCE.STATUS containing ''Finalizada''))  ) ' +
    ' and ((ALTERACA.TIPO = ''BALCAO'') or (ALTERACA.TIPO = ''VENDA'')) ' +
    ' and ALTERACA.DATA between ' + QuotedStr(DateToStrInvertida(dtInicio)) + '  and ' + QuotedStr(DateToStrInvertida(dtFinal)) +
    ' )';
end;

function SqlSelectGraficoVendasParciais(dtInicio: TDateTime; dtFinal: TDateTime): String;  // Ficha 6246
begin
  Result := SqlSelectGraficoVendas(dtInicio, dtFinal);
end;

function XmlValueToFloat(Value: String;
  SeparadorDecimalXml: String = '.'): Double;
// Sandro Silva 2023-05-17
// Converte valor float de tags xml para Float
begin
  if SeparadorDecimalXml = ',' then
    Value := StringReplace(Value, '.', '', [rfReplaceAll]);// Elimina os pontos

  if SeparadorDecimalXml = '.' then
  begin
    Value := StringReplace(Value, ',', '', [rfReplaceAll]); // Elimina a v�rgula
    Value := StringReplace(Value, '.', ',', [rfReplaceAll]); // Troca o ponto pela v�rgula
  end;

  Result := StrToFloatDef(Value, 0.00);
end;

function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
// Sandro Silva 2015-12-10 Formata valor float com 2 casas decimais para usar nos elementos do xml da nfce
// Par�metros:
// dValor: Valor a ser formatado
// iPrecisao: Quantidade de casas decimais resultante no valor formatado. Por default formata com 2 casas. Ex.: 2 = 0,00; 3 = 0,000
var
  sMascara: String;
begin
  sMascara := '##0.' + DupeString('0', iPrecisao);
  Result := StrTran(Alltrim(FormatFloat(sMascara, dValor)), ',', '.'); // Quantidade Comercializada do Item
end;

function FormatXMLToFloat(sValor: String): Double;
begin
  Result := StrToFloatDef(StringReplace(sValor, '.', ',', [rfReplaceAll]), 0);
end;

function TextoIdentificadorFinalidadeNFe(Value: String): String;
// Retorna o texto identificador do tipo de finalidade da NF-e
begin
  if (LimpaNumero(Value) = '1') then
  begin
    Result := '1-Normal';
  end else
  begin
    if (LimpaNumero(Value) = '2') then
    begin
      Result := '2-Complementar';
    end else
    begin
      if (LimpaNumero(Value) = '3') then
      begin
        Result := '3-de Ajuste';
      end else
      begin
        if (LimpaNumero(Value) = '4') then
        begin
          Result := '4-Devolu��o de mercadoria';
        end else
        begin
          Result := '1-Normal';
        end;
      end;
    end;
  end;

end;

procedure LogRetaguarda(sTexto: String);
var
  sl: TStringList;
  sNomeLog: String;
  sDirAtual: String;
begin
  /////////
  Exit; // Comentar essa linha para Ativar apenas quando precisar debugar algum teste. Descomentar a linha para Desativar depois de testar

  GetDir(0, sDirAtual);
  ////////

  sl := TStringList.Create;
  try
    sNomeLog := '\log\LogRetaguarda_' + FormatDateTime('yyyy-mm-dd', Date) + '.txt';
    if FileExists(ExtractFileDir(Application.ExeName) + sNomeLog) then
      sl.LoadFromFile(ExtractFileDir(Application.ExeName) + sNomeLog);
    sl.Add(FormatDateTime('dd/mm/yyyy HH:nn:ss.zzzz', Now) + ' - ' + sTexto);
    sl.SaveToFile(ExtractFileDir(Application.ExeName) + sNomeLog);
  except
  end;
  FreeAndNil(sl);
  ChDir(sDirAtual); // Para voltar
end;

function GetIP:string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));
  with HostEnt^  do
  begin
    Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]),Byte(h_addr^[1]),Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;

procedure GetBanderiasOperadorasNFe(slForma: TStringList);
begin

  slForma.Clear;
  slForma.Add('01-Visa');
  slForma.Add('02-Mastercard');
  slForma.Add('03-American Express');
  slForma.Add('04-Sorocred');
  slForma.Add('05-Diners Club');
  slForma.Add('06-Elo');
  slForma.Add('07-Hipercard');
  slForma.Add('08-Aura');
  slForma.Add('09-Cabal');
  slForma.Add('10-Alelo');
  slForma.Add('11-Banes Card');
  slForma.Add('12-CalCard');
  slForma.Add('13-Credz');
  slForma.Add('14-Discover');
  slForma.Add('15-GoodCard');
  slForma.Add('16-GreenCard');
  slForma.Add('17-Hiper');
  slForma.Add('18-JcB');
  slForma.Add('19-Mais');
  slForma.Add('20-MaxVan');
  slForma.Add('21-Policard');
  slForma.Add('22-RedeCompras');
  slForma.Add('23-Sodexo');
  slForma.Add('24-ValeCard');
  slForma.Add('25-Verocheque');
  slForma.Add('26-VR');
  slForma.Add('27-Ticket');
  slForma.Add('99-Outros');
end;

procedure GetFormasDePagamentoNFe(slForma: TStringList);
begin

  slForma.Clear;
  slForma.Add('01-Dinheiro');
  slForma.Add('02-Cheque');
  slForma.Add('03-Cart�o de Cr�dito');
  slForma.Add('04-Cart�o de D�bito');
  slForma.Add('05-Cr�dito de Loja');
  slForma.Add('10-Vale Alimenta��o');
  slForma.Add('11-Vale Refei��o');
  slForma.Add('12-Vale Presente');
  slForma.Add('13-Vale Combust�vel');
  slForma.Add('14-Duplicata Mercantil');
  slForma.Add('15-Boleto Banc�rio');
  slForma.Add('16-Dep�sito Banc�rio');
  slForma.Add('17-Pagamento Instant�neo (PIX)');
  slForma.Add('18-Transfer.banc�ria, Carteira Digital');
  slForma.Add('19-Progr.de fidelidade, Cashback, Cr�dito Virtual');
  slForma.Add('99-Outros');

end;

function CodigotBandNF(sBandeira: String): String;
begin
  sBandeira := AnsiUpperCase(sBandeira);
  Result := '99'; // Come�a como outros
  if Pos('VISA', sBandeira) > 0 then
    Result := '01';
  if Pos('MASTERCARD', sBandeira) > 0 then
    Result := '02';
  if Pos('AMERICAN EXPRESS', sBandeira) > 0 then
    Result := '03';
  if Pos('SOROCRED', sBandeira) > 0 then
    Result := '04';
  if Pos('DINERS', sBandeira) > 0 then
    Result := '05';
  if Pos('ELO', sBandeira) > 0 then
    Result := '06';
  if Pos('HIPERCARD', sBandeira) > 0 then
    Result := '07';
  if Pos('AURA', sBandeira) > 0 then
    Result := '08';
  if Pos('CABAL', sBandeira) > 0 then
    Result := '09';
  if Pos('ALELO', sBandeira) > 0 then
    Result := '10';
  if Pos('BANES CARD', sBandeira) > 0 then
    Result := '11';
  if Pos('CALCARD', sBandeira) > 0 then
    Result := '12';
  if Pos('CREDZ', sBandeira) > 0 then
    Result := '13';
  if Pos('DISCOVER', sBandeira) > 0 then
    Result := '14';
  if Pos('GOODCARD', sBandeira) > 0 then
    Result := '15';
  if Pos('GREENCARD', sBandeira) > 0 then
    Result := '16';
  if (Pos('HIPER', sBandeira) > 0) and (Pos('HIPERCARD', sBandeira) = 0) then
    Result := '17';
  if Pos('JCB', sBandeira) > 0 then
    Result := '18';
  if Pos('MAIS', sBandeira) > 0 then
    Result := '19';
  if Pos('MAXVAN', sBandeira) > 0 then
    Result := '20';
  if Pos('POLICARD', sBandeira) > 0 then
    Result := '21';
  if Pos('REDECOMPRAS', sBandeira) > 0 then
    Result := '22';
  if Pos('SODEXO', sBandeira) > 0 then
    Result := '23';
  if Pos('VALECARD', sBandeira) > 0 then
    Result := '24';
  if Pos('VEROCHEQUE', sBandeira) > 0 then
    Result := '25';
  if Pos('VR', sBandeira) > 0 then
    Result := '26';
  if Pos('TICKET', sBandeira) > 0 then
    Result := '27';

end;

function ValidaFormadePagamentoDigitada(sForma: String; slFormas: TStringList): String;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to slFormas.Count -1 do
  begin
    if sForma <> '' then
    begin
      if Copy(slFormas.Strings[i], 1, Length(sForma)) = sForma then
      begin
        Result := slFormas.Strings[i];
        Break;
      end;
    end;
  end;
end;

function IndexColumnFromName(DBGrid: TDBGrid; sNomeColuna: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to DBGrid.Columns.Count - 1 do
  begin
    if AnsiUpperCase(DBGrid.Columns[i].FieldName) = AnsiUpperCase(sNomeColuna) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

end.



