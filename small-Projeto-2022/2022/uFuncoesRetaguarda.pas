unit uFuncoesRetaguarda;

interface

uses
  SysUtils
  , Windows
  , StrUtils
  , Dialogs
  , Classes
  , Forms
  , Winsock
  , smallfunc_xe
  , IniFiles
  , Unit22
  , Unit3
  , Mais
  , Controls
  {$IFDEF VER150}
  , md5
  , IBCustomDataSet
  {$ELSE}
  , IdHashMessageDigest
  , IdGlobal
  , IBX.IBCustomDataSet
  {$ENDIF}
  , DBGrids
  , IBQuery
  , IBDatabase
  , DB
  , Variants
  , Grids
  , Graphics
  ;

  //type
  //  TmensagemSis = (msgInformacao,msgAtencao,msgErro);

  function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime; vFiltroAddV : string = ''): String;
  function SqlSelectGraficoVendas(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectGraficoVendasParciais(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectMovimentacaoItem(vProduto : string): String;
  function SqlEstoqueOrcamentos(AliasPadrao:Boolean=True): String; //Mauricio Parizotto 2023-10-16
  function UFDescricao(sCodigo: String): String;
  function UFSigla(sCodigo: String): String;
  function UFCodigo(sUF: String): String;
  procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure FiltraDataSet(DataSet: TDataSet; sFiltro: String = '');
  function xmlNodeValueToFloat(sXML, sNode: String;
    sDecimalSeparator: String = '.'): Double;
  function XmlValueToFloat(Value: String; SeparadorDecimalXml: String = '.'): Double;
  function FormatFloatXML(dValor: Double; iPrecisao: Integer = 2): String;
  function FormatXMLToFloat(sValor: String): Double;
  function TextoIdentificadorFinalidadeNFe(Value: String): String;
  procedure LogRetaguarda(sTexto: String);
  //function GetIP:string;
  function GetSenhaAdmin : Boolean;
  procedure GetBanderiasOperadorasNFe(slBandeira: TStringList);
  procedure GetFormasDePagamentoNFe(slForma: TStringList);
  function IdFormasDePagamentoNFe(sDescricaoForma: String): String;
  function CodigotBandNF(sBandeira: String): String;
  function ValidaFormadePagamentoDigitada(sForma: String; slFormas: TStringList): String;
  function IndexColumnFromName(DBGrid: TDBGrid; sNomeColuna: String): Integer;
  function FormaDePagamentoGeraCarneDuplicata(sForma: String): Boolean;
  function FormaDePagamentoEnvolveCartao(sForma: String): Boolean;
  function FormaDePagamentoGeraBoleto(sForma: String): Boolean;
  function GeraMD5(valor :string):string;
  function EstadoEmitente(Banco: TIBDatabase):string; //Mauricio Parizotto 2023-09-06
  function ProdutoComposto(IBTransaction: TIBTransaction; sCodigoProduto: String): Boolean;
  procedure FabricaComposto(const sCodigo: String; DataSetEstoque: TIBDataSet;
    dQtdMovimentada: Double; var bFabrica: Boolean; iHierarquia: Integer; var sModulo: String); // Sandro Silva 2023-11-06
  function CampoAlterado(Field: TField):Boolean; //Mauricio Parizotto 2023-09-06
  //procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao); //Mauricio Parizotto 2023-09-13


implementation

uses uFuncoesBancoDados;

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
            '   1 Ordem,'+
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
            ' 	Case'+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''BALCAO'') or (SUBSTRING(TIPO from 1 for 6) = ''VENDA'') then  999 '+
            ' 		Else 2'+
            '   End Ordem,'+
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
            '   999 Ordem,'+
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
            '   999 Ordem,'+
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
            '   999 Ordem,'+
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

            ' Order by 1,2,3'
            ;

end;

procedure FiltraDataSet(DataSet: TDataSet; sFiltro: String = '');
begin
  DataSet.Filter := sFiltro;
  DataSet.Filtered := (Trim(sFiltro) <> '');
end;

function xmlNodeValueToFloat(sXML, sNode: String;
  sDecimalSeparator: String = '.'): Double;
//Sandro Silva 2017-05-23 inicio
//Converte valor no xml para Float
//sDecimalSeparator: Deve ser ',' ou '.'
var
  sValor: String;
begin
  sValor := xmlNodeValue(sXML, sNode);
  if sDecimalSeparator = '.' then
  begin
   sValor := StringReplace(sValor, ',', '', [rfReplaceAll]);
   sValor := StringReplace(sValor, '.', ',', [rfReplaceAll]);
  end
  else
   sValor := StringReplace(sValor, '.', '', [rfReplaceAll]);

  Result := StrToFloatDef(sValor, 0);
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
  // essa rotina de log quando ativa pode afetar o desempenho do sistema
  // usar apenas para testes no desenvolvimento
  /////////
  //Exit; // Comentar essa linha para Ativar apenas quando precisar debugar algum teste. Descomentar a linha para Desativar depois de testar

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

{Mauricio Parizotto 2023-12-29
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
}

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
    if Application.MessageBox(PChar('Senha inválida. Deseja tentar novamente?'),
                              'Atenção', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = id_Yes then
    begin
      Result := GetSenhaAdmin;
    end;
  end;
end;

procedure GetBanderiasOperadorasNFe(slBandeira: TStringList);
begin
  slBandeira.Clear;
  {
  slBandeira.Add('01-Visa');
  slBandeira.Add('02-Mastercard');
  slBandeira.Add('03-American Express');
  slBandeira.Add('04-Sorocred');
  slBandeira.Add('05-Diners Club');
  slBandeira.Add('06-Elo');
  slBandeira.Add('07-Hipercard');
  slBandeira.Add('08-Aura');
  slBandeira.Add('09-Cabal');
  slBandeira.Add('10-Alelo');
  slBandeira.Add('11-Banes Card');
  slBandeira.Add('12-CalCard');
  slBandeira.Add('13-Credz');
  slBandeira.Add('14-Discover');
  slBandeira.Add('15-GoodCard');
  slBandeira.Add('16-GreenCard');
  slBandeira.Add('17-Hiper');
  slBandeira.Add('18-JcB');
  slBandeira.Add('19-Mais');
  slBandeira.Add('20-MaxVan');
  slBandeira.Add('21-Policard');
  slBandeira.Add('22-RedeCompras');
  slBandeira.Add('23-Sodexo');
  slBandeira.Add('24-ValeCard');
  slBandeira.Add('25-Verocheque');
  slBandeira.Add('26-VR');
  slBandeira.Add('27-Ticket');
  slBandeira.Add('99-Outros');
  }
  slBandeira.Add('Visa');
  slBandeira.Add('Mastercard');
  slBandeira.Add('American Express');
  slBandeira.Add('Sorocred');
  slBandeira.Add('Diners Club');
  slBandeira.Add('Elo');
  slBandeira.Add('Hipercard');
  slBandeira.Add('Aura');
  slBandeira.Add('Cabal');
  slBandeira.Add('Alelo');
  slBandeira.Add('Banes Card');
  slBandeira.Add('CalCard');
  slBandeira.Add('Credz');
  slBandeira.Add('Discover');
  slBandeira.Add('GoodCard');
  slBandeira.Add('GreenCard');
  slBandeira.Add('Hiper');
  slBandeira.Add('JcB');
  slBandeira.Add('Mais');
  slBandeira.Add('MaxVan');
  slBandeira.Add('Policard');
  slBandeira.Add('RedeCompras');
  slBandeira.Add('Sodexo');
  slBandeira.Add('ValeCard');
  slBandeira.Add('Verocheque');
  slBandeira.Add('VR');
  slBandeira.Add('Ticket');
  slBandeira.Add('Outros');

end;

procedure GetFormasDePagamentoNFe(slForma: TStringList);
begin

  slForma.Clear;
  {
  slForma.Add('Dinheiro');
  slForma.Add('Cheque');
  slForma.Add('Cartão de Crédito');
  slForma.Add('Cartão de Débito');
  slForma.Add('Crédito de Loja');
  slForma.Add('Vale Alimentação');
  slForma.Add('Vale Refeição');
  slForma.Add('Vale Presente');
  slForma.Add('Vale Combustível');
  slForma.Add('Duplicata Mercantil');
  slForma.Add('Boleto Bancário');
  slForma.Add('Depósito Bancário');
  slForma.Add('Pagamento Instantâneo (PIX)');
  slForma.Add('Transfer.bancária, Carteira Digital');
  slForma.Add('Progr.de fidelidade, Cashback, Crédito Virtual');
  slForma.Add('Outros');
  }
  slForma.Add('Dinheiro');
  slForma.Add('Cartão de Crédito');
  slForma.Add('Cartão de Débito');
  slForma.Add('Boleto Bancário');
  slForma.Add('Depósito Bancário');
  slForma.Add('Pagamento Instantâneo (PIX)');
  slForma.Add('Cheque');
  slForma.Add('Crédito de Loja');
  slForma.Add('Vale Alimentação');
  slForma.Add('Vale Refeição');
  slForma.Add('Vale Presente');
  slForma.Add('Vale Combustível');
  slForma.Add('Duplicata Mercantil');
  slForma.Add('Transfer.bancária, Carteira Digital');
  slForma.Add('Progr.de fidelidade, Cashback, Crédito Virtual');
  slForma.Add('Outros');

end;

function IdFormasDePagamentoNFe(sDescricaoForma: String): String;
begin
  Result := '99';
  if sDescricaoForma = 'Dinheiro' then
    Result := '01';
  if sDescricaoForma = 'Cheque' then
    Result := '02';
  if sDescricaoForma = 'Cartão de Crédito' then
    Result := '03';
  if sDescricaoForma = 'Cartão de Débito' then
    Result := '04';
  if sDescricaoForma = 'Crédito de Loja' then
    Result := '05';
  if sDescricaoForma = 'Vale Alimentação' then
    Result := '10';
  if sDescricaoForma = 'Vale Refeição' then
    Result := '11';
  if sDescricaoForma = 'Vale Presente' then
    Result := '12';
  if sDescricaoForma = 'Vale Combustível' then
    Result := '13';
  if sDescricaoForma = 'Duplicata Mercantil' then
    Result := '14';
  if sDescricaoForma = 'Boleto Bancário' then
    Result := '15';
  if sDescricaoForma = 'Depósito Bancário' then
    Result := '16';
  if sDescricaoForma = 'Pagamento Instantâneo (PIX)' then
    Result := '17';
  if sDescricaoForma = 'Transfer.bancária, Carteira Digital' then
    Result := '18';
  if sDescricaoForma = 'Progr.de fidelidade, Cashback, Crédito Virtual' then
    Result := '19';
end;

function CodigotBandNF(sBandeira: String): String;
begin
  sBandeira := AnsiUpperCase(sBandeira);
  Result := '99'; // Começa como outros
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

function FormaDePagamentoGeraCarneDuplicata(sForma: String): Boolean;
begin
  Result := (Pos('|' + IdFormasDePagamentoNFe(sForma) + '|', '||05|14|99|') > 0); // sem informar ou créditode Loja ou duplicata mercantil
end;

function FormaDePagamentoEnvolveCartao(sForma: String): Boolean;
begin
  Result := (Pos('|' + IdFormasDePagamentoNFe(sForma) + '|', '|03|04|') > 0); // envolvem instituição financeiras/credenciadoras
end;

function FormaDePagamentoGeraBoleto(sForma: String): Boolean;
var
  sIdForma: String;
begin
  // Pode ser que o usuário não informe a forma de pagamento na tela de desdobramento da parcelas da nota
  // Nesse caso deverá permitir gerar boleto destar parcelas
  if sForma = '' then
    sIdForma := ''
  else
    sIdForma := IdFormasDePagamentoNFe(sForma);
  // Sandro Silva 2023-10-06 Result := (Pos('|' + sIdForma + '|', '||14|15|') > 0); // sem informar, duplicata mercantil ou boleto
  Result := (Pos('|' + sIdForma + '|', '||14|15|99|') > 0); // sem informar, duplicata mercantil ou boleto
end;

function GeraMD5(valor :string):string;
{$IFDEF VER150}
{$ELSE}
var
  idmd5 : TIdHashMessageDigest5;
{$ENDIF}
begin
  {$IFDEF VER150}
  Result := MD5Print(MD5String(valor));
  {$ELSE}
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := LowerCase(idmd5.HashStringAsHex(valor,IndyTextEncoding_OSDefault));
  finally
    idmd5.Free;
  end;
  {$ENDIF}
end;

function EstadoEmitente(Banco: TIBDatabase):string; //Mauricio Parizotto 2023-09-06
var
  IBQUERY: TIBQuery;
  IBTRANSACTION: TIBTransaction;
begin
  Result := '';

  IBTRANSACTION := CriaIBTransaction(Banco);
  IBQUERY := CriaIBQuery(IBTRANSACTION);

  try
    try
      IBQUERY.Close;
      IBQUERY.SQL.Text := 'Select ESTADO From EMITENTE';
      IBQUERY.Open;

      Result := AllTrim(IBQUERY.FieldByName('ESTADO').AsString);
    finally
      IBTRANSACTION.Rollback;
      FreeAndNil(IBQUERY);
      FreeAndNil(IBTRANSACTION);
    end;
  except
  end;
end;

function ProdutoComposto(IBTransaction: TIBTransaction; sCodigoProduto: String): Boolean;
var
  IBQCOMPOSTO: TIBQuery;
begin
  // Retorna verdadeiro se o produto é composto
  Result := False;
  IBQCOMPOSTO := CriaIBQuery(IBTransaction);

  try

    IBQCOMPOSTO.Close;
    IBQCOMPOSTO.SQL.Clear;
    IBQCOMPOSTO.SQL.Text :=
      'select count(CODIGO) as CONTADOR ' +
      'from COMPOSTO C ' +
      'where coalesce(C.DESCRICAO, '''') <> '''' ' +
      ' and C.CODIGO = ' + QuotedStr(sCodigoProduto);
    IBQCOMPOSTO.Open;

    if IBQCOMPOSTO.FieldByName('CONTADOR').AsInteger > 0 then
      Result := True;
  finally
    FreeAndNil(IBQCOMPOSTO);
  end;

end;

procedure FabricaComposto(const sCodigo: String; DataSetEstoque: TIBDataSet;
  dQtdMovimentada: Double; var bFabrica: Boolean; iHierarquia: Integer;
  var sModulo: String); // Sandro Silva 2023-11-06
var
  IBQCOMPOSTO: TIBQuery;
  sModuloOld: String; // Sandro Silva 2023-12-05
begin

  //Faz a fabricação do produto composto

  IBQCOMPOSTO := CriaIBQuery(DataSetEstoque.Transaction);
  sModuloOld := sModulo;// Sandro Silva 2023-12-05
  try

    sModulo := 'ESTOQUE'; //Precisa para rotina de movimentação de estoque ser acionada

    //Seleciona a matérias-prima do produto
    IBQCOMPOSTO.Close;
    IBQCOMPOSTO.SQL.Clear;
    IBQCOMPOSTO.SQL.Text :=
      'select C.*, E.CODIGO as CODIGO_INSUMO ' +
      'from COMPOSTO C ' +
      'join ESTOQUE E on E.DESCRICAO = C.DESCRICAO ' +
      'where C.CODIGO = ' + QuotedStr(sCodigo);
    IBQCOMPOSTO.Open;

    if IBQCOMPOSTO.RecordCount > 0 then
    begin

      DataSetEstoque.Close;
      DataSetEstoque.SelectSQL.Clear;
      DataSetEstoque.SelectSQL.Add('select * from ESTOQUE');
      DataSetEstoque.Open;

      if DataSetEstoque.Locate('CODIGO', sCodigo, []) then
      begin

        LogRetaguarda(DupeString(' ', iHierarquia) + '>Início da composição do produto: ' + DataSetEstoque.FieldByName('CODIGO').AsString + ' - ' + DataSetEstoque.FieldByName('DESCRICAO').AsString);

        IBQCOMPOSTO.First;
        while not IBQCOMPOSTO.Eof do
        begin

          LogRetaguarda(DupeString(' ', iHierarquia) + 'Insumo do produto ' + IBQCOMPOSTO.FieldByName('CODIGO').AsString + ': ' + IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString + ' - ' + IBQCOMPOSTO.FieldByName('DESCRICAO').AsString + ' - Qtd ' + FormatFloat('0.00####', IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat));

          if (DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada)) < 0 then
            FabricaComposto(IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString, DataSetEstoque, Abs(DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada)), bFabrica, iHierarquia + 2, sModulo);

          // Localiza o produto materia-prima no estoque
          if DataSetEstoque.Locate('CODIGO', IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString, []) then
          begin

            // Desconta o estoque da matéria-prima
            DataSetEstoque.Edit;
            DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat := DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada);
            DataSetEstoque.Post;

          end;
          {Sandro Silva 2023-12-08 fim}

          IBQCOMPOSTO.Next;

        end;

        DataSetEstoque.Locate('CODIGO', sCodigo, []); // Localiza o produto final no estoque
        DataSetEstoque.Edit;
        DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat := DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat + dQtdMovimentada;  // Atribui a quantidade produzida ao estoque do produto para ficar disponível de ser baixado posteriormente

        LogRetaguarda(DupeString(' ', iHierarquia) + '<Fim da composição do produto ' + DataSetEstoque.FieldByName('CODIGO').AsString + ' - ' + DataSetEstoque.FieldByName('DESCRICAO').AsString);
      end;
    end;
  finally
    FreeAndNil(IBQCOMPOSTO);
    sModulo := sModuloOld;// Sandro Silva 2023-12-05
  end;
end;

function CampoAlterado(Field: TField):Boolean; //Mauricio Parizotto 2023-09-06
var
  ValorAntes, ValorDepois : string;
begin
  Result := False;

  try
    if Field.OldValue = null then
      ValorAntes := ''
    else
      ValorAntes := Field.OldValue;

    if Field.Value = null then
      ValorDepois := ''
    else
      ValorDepois := Field.Value;

    Result := ValorAntes <> ValorDepois;
  except
  end;
end;

{
procedure MensagemSistema(Mensagem:string; Tipo : TmensagemSis = msgInformacao);
begin
  case Tipo of
    msgInformacao:  Application.MessageBox(pChar(Mensagem), 'Informação', mb_Ok + MB_ICONINFORMATION);
    msgAtencao:     Application.MessageBox(pChar(Mensagem), 'Atenção', mb_Ok + MB_ICONWARNING);
    msgErro:        Application.MessageBox(pChar(Mensagem), 'Erro', mb_Ok + MB_ICONERROR);
  end;
end;
Mauricio Parizotto 2023-10-24}


function SqlEstoqueOrcamentos(AliasPadrao:Boolean=True): String; //Mauricio Parizotto 2023-10-16
var
  sqlCampos : string;
begin
  if AliasPadrao then
  begin
    sqlCampos    := '     ORCAMENTS.PEDIDO as "Orçamento" ' +
                    '    , ORCAMENTS.DATA as "Data" ' +
                    '    , ORCAMENTS.CLIFOR as "Cliente" ' +
                    '    , ORCAMENTS.VENDEDOR as "Vendedor" ' +
                    '    , TOTALBRUTO as "Total bruto" ' +
                    '    , DESCONTO as "Desconto" ' +
                    '    , (TOTALBRUTO - DESCONTO) as "Total líquido" ' +
                    '    , ORCAMENTS.NUMERONF as "Doc. Fiscal" ' +
                    '    , ORCAMENTS.PEDIDO as "Registro" ';

  end else
  begin
    sqlCampos    := '     ORCAMENTS.PEDIDO ' +
                    '    , ORCAMENTS.DATA' +
                    '    , ORCAMENTS.CLIFOR' +
                    '    , ORCAMENTS.VENDEDOR' +
                    '    , TOTALBRUTO' +
                    '    , DESCONTO' +
                    '    , (TOTALBRUTO - DESCONTO) TOTALLIQUIDO ' +
                    '    , ORCAMENTS.NUMERONF' +
                    '    , ORCAMENTS.PEDIDO REGISTRO';
  end;

  Result :=
            ' WITH ORCAMENTS AS ( ' +
            '  Select Q.PEDIDO ' +
            '    , Q.DATA ' +
            '    , Q.NUMERONF ' +
            '    , Q.CLIFOR ' +
            '    , O2.VENDEDOR ' +
            '    , Q.TOTALBRUTO ' +
            '    , Q.DESCONTO ' +
            '  From ' +
            '  ( ' +
            '   SELECT ' +
            '      ORCAMENT.PEDIDO ' +
            '      , MIN(ORCAMENT.DATA) AS DATA ' +
            '      , max(ORCAMENT.NUMERONF) as NUMERONF ' +
            '      , max(ORCAMENT.CLIFOR) as CLIFOR ' +
            '      , cast(list(distinct coalesce(ORCAMENT.VENDEDOR, '''')) as varchar(5000)) as VENDEDOR' +
            '      , SUM(CASE WHEN ORCAMENT.DESCRICAO <> ' + QuotedStr('Desconto') + ' THEN ORCAMENT.TOTAL ELSE 0 END) AS TOTALBRUTO ' +
            '      , SUM(CASE WHEN ORCAMENT.DESCRICAO  = ' + QuotedStr('Desconto') + ' THEN ORCAMENT.TOTAL ELSE 0 END) AS DESCONTO ' +
            '      , max(ORCAMENT.REGISTRO) as REGISTRO ' +      
            '   FROM ORCAMENT ' +
            '   GROUP BY ORCAMENT.PEDIDO ' + //, ORCAMENT.CLIFOR, ORCAMENT.VENDEDOR ' +
            '  ) Q ' +
            '    left join ORCAMENT O2 on O2.REGISTRO = Q.REGISTRO ' +
            ' ) ' +
            ' SELECT ' +
            sqlCampos+
            ' FROM ORCAMENTS '
            ;
end;

function UFDescricao(sCodigo: String): String;
begin
  Result := '';
  //Norte
  if sCodigo = '11' then Result := 'Rondônia';
  if sCodigo = '12' then Result := 'Acre';
  if sCodigo = '13' then Result := 'Amazonas';
  if sCodigo = '14' then Result := 'Roraima';
  if sCodigo = '15' then Result := 'Pará';
  if sCodigo = '16' then Result := 'Amapá';
  if sCodigo = '17' then Result := 'Tocantins';

  //Nordeste
  if sCodigo = '21' then Result := 'Maranhão';
  if sCodigo = '22' then Result := 'Piauí';
  if sCodigo = '23' then Result := 'Ceará';
  if sCodigo = '24' then Result := 'Rio Grande do Norte';
  if sCodigo = '25' then Result := 'Paraíba';
  if sCodigo = '26' then Result := 'Pernambuco';
  if sCodigo = '27' then Result := 'Alagoas';
  if sCodigo = '28' then Result := 'Sergipe';
  if sCodigo = '29' then Result := 'Bahia';

  //Sudeste
  if sCodigo = '31' then Result := 'Minas Gerais';
  if sCodigo = '32' then Result := 'Espírito Santo';
  if sCodigo = '33' then Result := 'Rio de Janeiro';
  if sCodigo = '35' then Result := 'São Paulo';

  //Sul
  if sCodigo = '41' then Result := 'Paraná';
  if sCodigo = '42' then Result := 'Santa Catarina';
  if sCodigo = '43' then Result := 'Rio Grande do Sul';

  //Centro' then Result := 'oeste
  if sCodigo = '50' then Result := 'Mato Grosso do Sul';
  if sCodigo = '51' then Result := 'Mato Grosso';
  if sCodigo = '52' then Result := 'Goiás';
  if sCodigo = '53' then Result := 'Distrito Federal';
end;

function UFSigla(sCodigo: String): String;
begin
  Result := '';
  //Norte
  if sCodigo = '11' then Result := 'RO';
  if sCodigo = '12' then Result := 'AC';
  if sCodigo = '13' then Result := 'AM';
  if sCodigo = '14' then Result := 'RR';
  if sCodigo = '15' then Result := 'PA';
  if sCodigo = '16' then Result := 'AM';
  if sCodigo = '17' then Result := 'TO';

  //Nordeste
  if sCodigo = '21' then Result := 'MA';
  if sCodigo = '22' then Result := 'PI';
  if sCodigo = '23' then Result := 'CE';
  if sCodigo = '24' then Result := 'RN';
  if sCodigo = '25' then Result := 'PB';
  if sCodigo = '26' then Result := 'PE';
  if sCodigo = '27' then Result := 'AL';
  if sCodigo = '28' then Result := 'SE';
  if sCodigo = '29' then Result := 'BA';

  //Sudeste
  if sCodigo = '31' then Result := 'MG';
  if sCodigo = '32' then Result := 'ES';
  if sCodigo = '33' then Result := 'RJ';
  if sCodigo = '35' then Result := 'SP';

  //Sul
  if sCodigo = '41' then Result := 'PR';
  if sCodigo = '42' then Result := 'SC';
  if sCodigo = '43' then Result := 'RS';

  //Centro' then Result := 'oeste
  if sCodigo = '50' then Result := 'MS';
  if sCodigo = '51' then Result := 'MT';
  if sCodigo = '52' then Result := 'GO';
  if sCodigo = '53' then Result := 'DF';
end;

function UFCodigo(sUF: String): String;
begin
  Result := '';
  //Norte
  if sUF = 'RO' then Result := '11';
  if sUF = 'AC' then Result := '12';
  if sUF = 'AM' then Result := '13';
  if sUF = 'RR' then Result := '14';
  if sUF = 'PA' then Result := '15';
  if sUF = 'AM' then Result := '16';
  if sUF = 'TO' then Result := '17';

  //Nordeste
  if sUF = 'MA' then Result := '21';
  if sUF = 'PI' then Result := '22';
  if sUF = 'CE' then Result := '23';
  if sUF = 'RN' then Result := '24';
  if sUF = 'PB' then Result := '25';
  if sUF = 'PE' then Result := '26';
  if sUF = 'AL' then Result := '27';
  if sUF = 'SE' then Result := '28';
  if sUF = 'BA' then Result := '29';

  //Sudeste
  if sUF = 'MG' then Result := '31';
  if sUF = 'ES' then Result := '32';
  if sUF = 'RJ' then Result := '33';
  if sUF = 'SP' then Result := '35';

  //Sul
  if sUF = 'PR' then Result := '41';
  if sUF = 'SC' then Result := '42';
  if sUF = 'RS' then Result := '43';

  //Centro' then Result := 'oeste
  if sUF = 'MS' then Result := '50';
  if sUF = 'MT' then Result := '51';
  if sUF = 'GO' then Result := '52';
  if sUF = 'DF' then Result := '53';
end;

procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBkMode: Integer;
  xRect: TRect;
begin
  (Sender as TDBGrid).Canvas.Pen.Color   := clBlack;
  (Sender as TDBGrid).Canvas.Brush.Color := clBtnFace;// clBlack;
  //
  xRect.Left   := Rect.Left;
  xRect.Top    := -1;
  xRect.Right  := Rect.Right;
  xRect.Bottom := Rect.Bottom - Rect.Top;// + 1;
  (Sender as TDBGrid).Canvas.FillRect(xRect);
  xRect.Bottom := Rect.Bottom - Rect.Top;// + 2;

  OldBkMode := SetBkMode((Sender as TDBGrid).Handle, TRANSPARENT);
  (Sender as TDBGrid).Canvas.Font.Style := [];
  //(Sender as TDBGrid).Canvas.Font.Size := (Sender as TDBGrid).Columns[Column.Index].Title.Font.Size;
  if (fsBold in (Sender as TDBGrid).Columns[Column.Index].Title.Font.Style) then
    (Sender as TDBGrid).Canvas.Font.Style := [fsBold];
  (Sender as TDBGrid).Canvas.Font.Color  := clblack;
  (Sender as TDBGrid).Canvas.Brush.Color := clBtnFace;
  (Sender as  TDBGrid).Canvas.TextOut(Rect.Left + 2, 2, Trim(Column.Title.Caption));
  (Sender as TDBGrid).Canvas.Font.Color  := clblack;
  SetBkMode((Sender as TDBGrid).Canvas.Handle, OldBkMode);

  ///////////
  (Sender as TDBGrid).Canvas.Font.Style := [];

  if gdSelected in State then // Se a coluna estiver selecionada deixa a fonte branca para ter contraste
    (Sender as TDBGrid).Canvas.Font.Color := clWhite;
end;

end.



