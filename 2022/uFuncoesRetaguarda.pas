unit uFuncoesRetaguarda;

interface

  function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime; vFiltroAddV : string = ''): String;
  function SqlSelectGraficoVendas(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectGraficoVendasParciais(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectMovimentacaoItem(vProduto : string): String;
  function XmlValueToFloat(Value: String; SeparadorDecimalXml: String = '.'): Double;
  function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
  function FormatXMLToFloat(sValor: String): Double;
  function TextoIdentificadorFinalidadeNFe(Value: String): String;
  procedure LogRetaguarda(sTexto: String);
  function GetIP:string;
  function GetSenhaAdmin : Boolean;

implementation

uses
  SysUtils
  , Windows
  , StrUtils
  , Dialogs
  , Classes
  , Forms
  , Winsock
  , SmallFunc
  , IniFiles
  , Unit22
  , Unit3
  , Mais
  , Controls
  ;

type
  TModulosSmall = (tmNenhum, tmNao, tmEstoque, tmICM, tmReceber);

function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String; //Ficha 6237
begin
  // Como ratear VENDA.DESCONTO, VENDAS.OUTRAS, VENDA.SEGURO, VENDAS.FRETE (ST, FCP?) nos ITENS001
  // Como ratear DESCONTO e ACRÉSCIMO nos itens do cupom (desconto do item + desconto no subtotal)  
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
  // Dúvida com relação do ao total retornado nesse Select comparado ao da função SqlSelectCurvaAbcClientes (soma o campo VENDAS.TOTAL)
  // SqlSelectGraficoVendasParciais (soma (VENDAS.MERCADORIA + VENDAS.SERVICOS - VENDAS.DESCONTO))
  // Onde influenciaria se SqlSelectGraficoVendasParciais também somasse a coluna VENDAS.TOTAL?
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


function SqlSelectMovimentacaoItem(vProduto : string): String;
begin
  Result := //Compra
            ' Select '+
            ' 	C.EMISSAO DATA,'+
            ' 	C.NUMERONF DOCUMENTO,'+
            ' 	''Entrada de ''||C.FORNECEDOR HISTORICO,'+
            ' 	I.QUANTIDADE,'+
            ' 	I.TOTAL VALOR'+
            ' From ITENS002 I'+
            ' 	Inner Join COMPRAS C on C.NUMERONF = I.NUMERONF and C.FORNECEDOR = I.FORNECEDOR'+
            ' 	Left Join ICM T on T.NOME = C.OPERACAO'+
            ' Where DESCRICAO='+QuotedStr(vProduto)+
            ' 	and coalesce(T.INTEGRACAO,'''') not like ''%=%'''+
            ' Union All'+

            //Venda
            ' Select '+
            ' 	DATA DATA,'+
            ' 	''000''||PEDIDO||''000'' DOCUMENTO,		'+
            ' 	Case'+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''BALCAO'') then'+
            ' 			case'+
            ' 				when (COALESCE(CLIFOR,'''') <> '''' )  then ''Venda para ''||CLIFOR'+
            ' 				else ''Venda direta ao consumidor CF ''||PEDIDO		'+
            ' 			end'+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''VENDA'') then'+
            ' 			case'+
            ' 				when (COALESCE(CLIFOR,'''') <> '''' )  then ''NF venda modelo 2 para ''||CLIFOR'+
            ' 				else ''NF venda Modelo 2 N: ''||PEDIDO		'+
            ' 			end'+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''ALTERA'') then ''Alteração na ficha do item'''+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''FABRIC'') then ''Alteração na composição do item''	'+
            ' 	End HISTORICO,'+
            ' 	Case'+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''BALCAO'') or (SUBSTRING(TIPO from 1 for 6) = ''VENDA'') then  QUANTIDADE * -1'+
            ' 		Else QUANTIDADE'+
            ' 	End QUANTIDADE,'+
            ' 	TOTAL VALOR'+
            ' From ALTERACA '+
            ' Where DESCRICAO='+QuotedStr(vProduto)+
            ' 	and TIPO <> ''ORCAME'' '+
            ' 	and TIPO <> ''KIT'' '+
            ' 	and TIPO <> ''CANCEL'' '+
            ' 	and Coalesce(VALORICM,0) = 0 '+ // Se não for 0 é para outra coisa
            ' Union All	'+

            //Serviços 
            ' Select '+
            ' 	V.EMISSAO DATA,'+
            ' 	V.NUMERONF DOCUMENTO,'+
            ' 	''Saída para ''||V.CLIENTE HISTORICO,'+
            ' 	I.QUANTIDADE * -1 QUANTIDADE,'+
            ' 	I.TOTAL VALOR'+
            ' From ITENS003 I'+
            ' 	Inner Join VENDAS V on V.NUMERONF = I.NUMERONF'+
            ' Where DESCRICAO='+QuotedStr(vProduto)+
            '   and V.EMITIDA=''S'' '+
            ' Union All	'+

            //OS
            ' Select '+
            ' 	CURRENT_DATE DATA,'+
            ' 	RIGHT(''00000000''|| I.NUMEROOS, 9) ||''000'' DOCUMENTO,'+
            ' 	''Reservado na OS aberta'' HISTORICO,'+
            ' 	I.QUANTIDADE * -1 QUANTIDADE,'+
            ' 	I.TOTAL VALOR'+
            ' From ITENS001 I	'+
            ' Where DESCRICAO='+QuotedStr(vProduto)+
            ' 	and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)'+
            ' 	and coalesce(NUMERONF,'''') = '''''+
            ' Union All	'+
            
            //Venda
            ' Select '+
            ' 	V.EMISSAO DATA,'+
            ' 	V.NUMERONF DOCUMENTO,'+
            ' 	''Saída para ''||CLIENTE HISTORICO,'+
            ' 	I.QUANTIDADE * -1 QUANTIDADE,'+
            ' 	I.TOTAL VALOR'+
            ' From ITENS001 I'+
            ' 	Inner Join VENDAS V on V.NUMERONF = I.NUMERONF'+
            ' 	Left Join ICM T on T.NOME = V.OPERACAO'+
            ' Where DESCRICAO='+QuotedStr(vProduto)+
            ' 	and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)'+
            ' 	and V.EMITIDA=''S'''+
            ' 	and coalesce(T.INTEGRACAO,'''') not like ''%=%'''+

            ' Order by 1,2'
            ;

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
    Value := StringReplace(Value, ',', '', [rfReplaceAll]); // Elimina a vírgula
    Value := StringReplace(Value, '.', ',', [rfReplaceAll]); // Troca o ponto pela vírgula
  end;

  Result := StrToFloatDef(Value, 0.00);
end;

function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
// Sandro Silva 2015-12-10 Formata valor float com 2 casas decimais para usar nos elementos do xml da nfce
// Parâmetros:
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
          Result := '4-Devolução de mercadoria';
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

function GetSenhaAdmin : Boolean;
var
  Mais1Ini : tIniFile;
  sSenhaX, sSenha : string;
  I : integer;
begin
  Result := False;

  Form22.Show;
  Form22.Label6.Caption := '';
  Form22.Label6.Width   := Screen.Width;
  Form22.Label6.Repaint;
  Senhas2.ShowModal;
  Form22.Close;
  Senha2:=Senhas2.SenhaPub2;
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  sSenha := '';
  // ----------------------------- //
  // Fórmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //

  Result := AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2);

  if Result = False then
  begin
    if Application.MessageBox(PansiChar('Senha inválida. Deseja tentar novamente?'),
                              'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = id_Yes then
    begin
      Result := GetSenhaAdmin;
    end;
  end;
end;

end.



