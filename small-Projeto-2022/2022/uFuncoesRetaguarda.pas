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
  , uSmallEnumerados;

  function Get_SQL_CliforAddress(AOnlyMainAddress: Boolean = False;
    AFilter: String = ''): String;
  function SqlSelectCurvaAbcEstoque(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectCurvaAbcClientes(dtInicio: TDateTime; dtFinal: TDateTime; vFiltroAddV : string = ''): String;
  function SqlSelectGraficoVendas(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectGraficoVendasParciais(dtInicio: TDateTime; dtFinal: TDateTime): String;
  function SqlSelectMovimentacaoItem(vProduto : string): String;
  function SqlEstoqueOrcamentos(AliasPadrao:Boolean=True): String; //Mauricio Parizotto 2023-10-16
  //function SqlFiltroNFCEAutorizado(AliasTabela:string): String; //Mauricio Parizotto 2024-12-17 2025-01-17
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
//  function GeraMD5(valor :string):string;
  function EstadoEmitente(Banco: TIBDatabase):string; //Mauricio Parizotto 2023-09-06
  function ProdutoComposto(IBTransaction: TIBTransaction; sCodigoProduto: String): Boolean;
  procedure FabricaComposto(const sCodigo: String; DataSetEstoque: TIBDataSet;
    dQtdMovimentada: Double; var bFabrica: Boolean; iHierarquia: Integer; var sModulo: String); // Sandro Silva 2023-11-06
  function ProdutoTemComposicaoCircular(sCodigo: String;
    IBTRANSACTION: TIBTransaction): Boolean;
  function ComposicaoCircular(const sCodigo: String;
    IBTRANSACTION: TIBTransaction; slCompostoPai: TStringList): Boolean;
  function CampoAlterado(Field: TField):Boolean; //Mauricio Parizotto 2023-09-06
  function GetFatorConversaoItemCompra(CodRegItem:string; valPadrao: Double; Transaction: TIBTransaction):Double; //Mauricio Parizotto 2024-02-19
  function GetIVAProduto(IDESTOQUE : integer; UF : string; Transaction: TIBTransaction):Double; //Mauricio Parizotto 2024-09-11
  function ExtrairConfiguracao(sTexto: String; sSigla: String): String; // Mauricio Parizotto 2024-10-01
  function CodigoPlanoContaToTipo(AConta: String): TTipoPlanoConta;
  function TipoPlanoContaToText(ATipoPlanoConta: TTipoPlanoConta): String;
  function TipoPlanoContaToStr(ATipoPlanoConta: TTipoPlanoConta): String;
  function RecordExists(AConnection: TIBDatabase; ATableName,
    AFieldName: String; AKeyField: TField; AValue: String): Boolean;
  function TipoEnderecoToString(const t: TTipoEndereco): string;
  function TipoEnderecoToStrText(const t: TTipoEndereco): string;
  function StrToTipoEndereco(out ok: boolean; const s: string): TTipoEndereco;
  function StrTextTipoEndereco(out ok: boolean; const s: string): TTipoEndereco;
  function GetTmpCharacterSet(AFieldName: String): String;

  (*
    TODO: retirado do ACBr, ao utilizar o componente essas duas fun��es
    (StrToEnumerado e EnumeradoToStr) devem ser removidas daqui
  *)
  function StrToEnumerado(out ok: boolean; const s: string; const AString:
    array of string; const AEnumerados: array of variant): variant;
  function EnumeradoToStr(const t: variant; const AString:
    array of string; const AEnumerados: array of variant): variant;

implementation

uses uFuncoesBancoDados, uSmallConsts, Mais3;

type
  TModulosSmall = (tmNenhum, tmNao, tmEstoque, tmICM, tmReceber);

function Get_SQL_CliforAddress(AOnlyMainAddress: Boolean;
  AFilter: String): String;
begin
  const SQL_CLIFOR_ADDRESS = 'SELECT * FROM ( '+
    'SELECT '+
      ENDERECO_PRINCIPAL_ENTREGA.ToString()+' IDENDERECO, '+
      'IDCLIFOR, '+
      '  (COALESCE(NULLIF(ENDERE, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(COMPLE, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(CIDADE, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(ESTADO, '+QuotedStr('')+'), '+QuotedStr('')+')) AS FULL_ADDRESS, '+
      ' ENDERE ENDERECO, '+
      ' '+QuotedStr('')+' NUMERO, '+
      ' COMPLE BAIRRO, '+
      ' CIDADE, '+
      ' ESTADO, '+
      ' municipios.CODIGO municipios_codigo, '+
      ' CEP, '+
      ' FONE TELEFONE, '+
      ' 1 MAIN_ADDRESS '+
    'FROM CLIFOR '+
    ' left join municipios on Upper(municipios.nome) = Upper(CLIFOR.CIDADE) and '+
        'Upper(municipios.UF) = Upper(CLIFOR.estado) '+

    ' where IDCLIFOR = :IDCLIFOR '+

    ' UNION ALL '+

    ' SELECT '+
      ' IDENDERECO, '+
      ' IDCLIFOR, '+
      ' (COALESCE(NULLIF(ENDERECO, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(NUMERO, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(BAIRRO, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(CIDADE, '+QuotedStr('')+')|| '+QuotedStr(', ')+', '+QuotedStr('')+') || '+
      '  COALESCE(NULLIF(ESTADO, '+QuotedStr('')+'), '+QuotedStr('')+')) AS FULL_ADDRESS,  '+
      ' ENDERECO, '+
      ' NUMERO, '+
      ' BAIRRO, '+
      ' CIDADE, '+
      ' ESTADO, '+
      ' municipios.CODIGO municipios_codigo, '+
      ' CEP, '+
      ' TELEFONE, '+
      ' 0 MAIN_ADDRESS '+
   ' FROM CLIFORENDERECOS '+
   ' left join municipios on Upper(municipios.nome) = Upper(cliforenderecos.cidade) and '+
        'upper(municipios.UF) = Upper(cliforenderecos.estado) '+
   ' where IDCLIFOR = :IDCLIFOR'+
  ' ) '+
  ' WHERE '+
  ' NOT(COALESCE(FULL_ADDRESS, '+QuotedStr('')+') = '+QuotedStr('')+') '+
  ' %s %s '+
  ' order by '+
  'IDENDERECO';

  var SqlOnlyMainAddress := '';
  if AOnlyMainAddress then
    SqlOnlyMainAddress := ' and IDENDERECO = '+
      ENDERECO_PRINCIPAL_ENTREGA.ToString();

  Result := Format(SQL_CLIFOR_ADDRESS, [SqlOnlyMainAddress, AFilter]);

end;

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
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''ALTERA'') then ''Altera��o na ficha do item'''+
            ' 		When (SUBSTRING(TIPO from 1 for 6) = ''FABRIC'') then ''Altera��o na composi��o do item''	'+
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
            ' 	and Coalesce(VALORICM,0) = 0 '+ // Se n�o for 0 � para outra coisa
            ' Union All	'+

            //Servi�os 
            ' Select '+
            ' 	V.EMISSAO DATA,'+
            '   999 Ordem,'+
            ' 	V.NUMERONF DOCUMENTO,'+
            ' 	''Sa�da para ''||V.CLIENTE HISTORICO,'+
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
            ' 	''Sa�da para ''||CLIENTE HISTORICO,'+
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

function GetSenhaAdmin : Boolean;
var
  Mais1Ini : tIniFile;
  sSenhaX, sSenha, sSenhaAdm : string;
  I : integer;
begin
  Result := False;

  Form22.Show;
  Form22.lblMsgCarregamento.Caption := '';
  Form22.lblMsgCarregamento.Repaint;
  //Mauricio Parizotto 2024-07-26
//  Senhas2.ShowModal;
  Senhas.iTpApresentacao := 3;
  Senhas.ShowModal;
  Form22.Close;
//  Senha2:=Senhas2.SenhaPub2;
  sSenhaAdm := Senhas.SenhaAdmPub;
  Senhas.SenhaAdmPub := '';
  Mais1ini := TIniFile.Create(Form1.sAtual+'\EST0QUE.DAT');
  sSenhaX := Mais1Ini.ReadString('Administrador','Chave','15706143431572013809150491382314104');
  sSenha := '';
  // ----------------------------- //
  // F�rmula para ler a nova senha //
  // ----------------------------- //
  for I := 1 to (Length(sSenhaX) div 5) do
    sSenha := Chr((StrToInt(
                  Copy(sSenhaX,(I*5)-4,5)
                  )+((Length(sSenhaX) div 5)-I+1)*7) div 137) + sSenha;
  // ----------------------------- //

  Result := AnsiUpperCase(sSenha) = AnsiUpperCase(sSenhaAdm);

  if Result = False then
  begin
    if Application.MessageBox(PChar('Senha inv�lida. Deseja tentar novamente?'),
                              'Aten��o', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON1) = id_Yes then
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

  slForma.Add('Dinheiro');
  slForma.Add('Cart�o de Cr�dito');
  slForma.Add('Cart�o de D�bito');
  slForma.Add('Boleto Banc�rio');
  slForma.Add('Dep�sito Banc�rio');
  {Mauricio Parizotto 204-07-10 Inicio}
  //slForma.Add('Pagamento Instant�neo (PIX)');
  slForma.Add(_FormaPixEstatico);
  slForma.Add(_FormaPixDinamico);
  {Mauricio Parizotto 204-07-10 Fim}
  slForma.Add('Cheque');
  slForma.Add('Cr�dito de Loja');
  slForma.Add('Vale Alimenta��o');
  slForma.Add('Vale Refei��o');
  slForma.Add('Vale Presente');
  slForma.Add('Vale Combust�vel');
  slForma.Add('Duplicata Mercantil');
  slForma.Add('Transfer.banc�ria, Carteira Digital');
  slForma.Add('Progr.de fidelidade, Cashback, Cr�dito Virtual');
  slForma.Add('Outros');

end;

function IdFormasDePagamentoNFe(sDescricaoForma: String): String;
begin
  Result := '99';
  if sDescricaoForma = 'Dinheiro' then
    Result := '01';
  if sDescricaoForma = 'Cheque' then
    Result := '02';
  if sDescricaoForma = 'Cart�o de Cr�dito' then
    Result := '03';
  if sDescricaoForma = 'Cart�o de D�bito' then
    Result := '04';
  if sDescricaoForma = 'Cr�dito de Loja' then
    Result := '05';
  if sDescricaoForma = 'Vale Alimenta��o' then
    Result := '10';
  if sDescricaoForma = 'Vale Refei��o' then
    Result := '11';
  if sDescricaoForma = 'Vale Presente' then
    Result := '12';
  if sDescricaoForma = 'Vale Combust�vel' then
    Result := '13';
  if sDescricaoForma = 'Duplicata Mercantil' then
    Result := '14';
  if sDescricaoForma = 'Boleto Banc�rio' then
    Result := '15';
  if sDescricaoForma = 'Dep�sito Banc�rio' then
    Result := '16';
  {Mauricio Parizotto 204-07-10 Inicio}
  //if sDescricaoForma = 'Pagamento Instant�neo (PIX)' then
  //  Result := '17';
  if sDescricaoForma = _FormaPixDinamico then
    Result := '17';
  if sDescricaoForma = _FormaPixEstatico then
    Result := '20';
  {Mauricio Parizotto 204-07-10 Fim}
  if sDescricaoForma = 'Transfer.banc�ria, Carteira Digital' then
    Result := '18';
  if sDescricaoForma = 'Progr.de fidelidade, Cashback, Cr�dito Virtual' then
    Result := '19';
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

function FormaDePagamentoGeraCarneDuplicata(sForma: String): Boolean;
begin
  Result := (Pos('|' + IdFormasDePagamentoNFe(sForma) + '|', '||05|14|99|') > 0); // sem informar ou cr�ditode Loja ou duplicata mercantil
end;

function FormaDePagamentoEnvolveCartao(sForma: String): Boolean;
begin
  // envolvem institui��o financeiras/credenciadoras
  Result := (Pos('|' + IdFormasDePagamentoNFe(sForma) + '|', '|03|04|') > 0);
end;

function FormaDePagamentoGeraBoleto(sForma: String): Boolean;
var
  sIdForma: String;
begin
  // Pode ser que o usu�rio n�o informe a forma de pagamento na tela de desdobramento da parcelas da nota
  // Nesse caso dever� permitir gerar boleto destar parcelas
  if sForma = '' then
    sIdForma := ''
  else
    sIdForma := IdFormasDePagamentoNFe(sForma);
  // Sandro Silva 2023-10-06 Result := (Pos('|' + sIdForma + '|', '||14|15|') > 0); // sem informar, duplicata mercantil ou boleto
  Result := (Pos('|' + sIdForma + '|', '||14|15|99|') > 0); // sem informar, duplicata mercantil ou boleto
end;

(*
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
Mauricio Parizotto 2024-01-24*)

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
  // Retorna verdadeiro se o produto � composto
  Result := False;
  IBQCOMPOSTO := CriaIBQuery(IBTransaction);

  try
    IBQCOMPOSTO.Close;
    IBQCOMPOSTO.SQL.Clear;
    IBQCOMPOSTO.SQL.Text :=
                            ' Select count(CODIGO) as CONTADOR ' +
                            ' From COMPOSTO C ' +
                            ' Where coalesce(C.DESCRICAO, '''') <> '''' ' +
                            '   and C.CODIGO = ' + QuotedStr(sCodigoProduto);
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

  //Faz a fabrica��o do produto composto

  IBQCOMPOSTO := CriaIBQuery(DataSetEstoque.Transaction);
  sModuloOld := sModulo;// Sandro Silva 2023-12-05
  try

    sModulo := 'ESTOQUE'; //Precisa para rotina de movimenta��o de estoque ser acionada

    //Seleciona a mat�rias-prima do produto
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

        //LogRetaguarda(DupeString(' ', iHierarquia) + '>In�cio da composi��o do produto: ' + DataSetEstoque.FieldByName('CODIGO').AsString + ' - ' + DataSetEstoque.FieldByName('DESCRICAO').AsString);

        IBQCOMPOSTO.First;
        while not IBQCOMPOSTO.Eof do
        begin

          //LogRetaguarda(DupeString(' ', iHierarquia) + 'Insumo do produto ' + IBQCOMPOSTO.FieldByName('CODIGO').AsString + ': ' + IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString + ' - ' + IBQCOMPOSTO.FieldByName('DESCRICAO').AsString + ' - Qtd ' + FormatFloat('0.00####', IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat));

          if (DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada)) < 0 then
            FabricaComposto(IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString, DataSetEstoque, Abs(DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada)), bFabrica, iHierarquia + 2, sModulo);

          // Localiza o produto materia-prima no estoque
          if DataSetEstoque.Locate('CODIGO', IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString, []) then
          begin

            // Desconta o estoque da mat�ria-prima
            DataSetEstoque.Edit;
            DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat := DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat - (IBQCOMPOSTO.FieldByName('QUANTIDADE').AsFloat * dQtdMovimentada);
            DataSetEstoque.Post;

          end;
          {Sandro Silva 2023-12-08 fim}

          IBQCOMPOSTO.Next;

        end;

        DataSetEstoque.Locate('CODIGO', sCodigo, []); // Localiza o produto final no estoque
        DataSetEstoque.Edit;
        DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat := DataSetEstoque.FieldByName('QTD_ATUAL').AsFloat + dQtdMovimentada;  // Atribui a quantidade produzida ao estoque do produto para ficar dispon�vel de ser baixado posteriormente

        //LogRetaguarda(DupeString(' ', iHierarquia) + '<Fim da composi��o do produto ' + DataSetEstoque.FieldByName('CODIGO').AsString + ' - ' + DataSetEstoque.FieldByName('DESCRICAO').AsString);
      end;
    end;
  finally
    FreeAndNil(IBQCOMPOSTO);
    sModulo := sModuloOld;// Sandro Silva 2023-12-05
  end;
end;

function ProdutoTemComposicaoCircular(sCodigo: String;
  IBTRANSACTION: TIBTransaction): Boolean;
var
  slCompostoPai: TStringList;
begin
  slCompostoPai := TStringList.Create;
  Result := ComposicaoCircular(sCodigo, IBTRANSACTION, slCompostoPai);
  FreeAndNil(slCompostoPai);
end;

function ComposicaoCircular(const sCodigo: String;
  IBTRANSACTION: TIBTransaction; slCompostoPai: TStringList): Boolean;
var
  IBQCOMPOSTO: TIBQuery;
  IBQESTOQUE: TIBQuery;
  function ValidaSeInsumoEhComposto(sCodigo: String): Boolean;
  var
    iCodigo: Integer;
  begin
    Result := False;
    for iCodigo := 0 to slCompostoPai.Count - 1 do
    begin
      if sCodigo = slCompostoPai.Strings[iCodigo] then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
begin
  Result := False;

  //Faz a fabrica��o do produto composto

  IBQCOMPOSTO := CriaIBQuery(IBTRANSACTION);
  IBQESTOQUE  := CriaIBQuery(IBTRANSACTION);
  try

    //Seleciona a mat rias-prima do produto
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

      slCompostoPai.Add(sCodigo);

      IBQESTOQUE.Close;
      IBQESTOQUE.SQL.Text :=
        'select * ' +
        'from ESTOQUE ' +
        'where CODIGO = :CODIGO ';
      IBQESTOQUE.ParamByName('CODIGO').AsString := sCodigo;
      IBQESTOQUE.Open;

      if IBQESTOQUE.Locate('CODIGO', sCodigo, []) then
      begin

        //LogRetaguarda(DupeString(' ', iHierarquia) + '>In�cio da composi��o do produto: ' + IBQESTOQUE.FieldByName('CODIGO').AsString + ' - ' + IBQESTOQUE.FieldByName('DESCRICAO').AsString);

        IBQCOMPOSTO.First;
        while not IBQCOMPOSTO.Eof do
        begin

          if ValidaSeInsumoEhComposto(IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString) then
          begin
            Result := True;
            Break;
          end;

          Result := ComposicaoCircular(IBQCOMPOSTO.FieldByName('CODIGO_INSUMO').AsString, IBTRANSACTION, slCompostoPai);

          if Result then
            Break;

          IBQCOMPOSTO.Next;

        end;

      end;
    end;
  finally
    FreeAndNil(IBQCOMPOSTO);
    FreeAndNil(IBQESTOQUE);
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
    msgInformacao:  Application.MessageBox(pChar(Mensagem), 'Informa��o', mb_Ok + MB_ICONINFORMATION);
    msgAtencao:     Application.MessageBox(pChar(Mensagem), 'Aten��o', mb_Ok + MB_ICONWARNING);
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
    sqlCampos    := '     ORCAMENTS.PEDIDO as "Or�amento" ' +
                    '    , ORCAMENTS.DATA as "Data" ' +
                    '    , ORCAMENTS.CLIFOR as "Cliente" ' +
                    '    , ORCAMENTS.VENDEDOR as "Vendedor" ' +
                    '    , TOTALBRUTO as "Total bruto" ' +
                    '    , DESCONTO as "Desconto" ' +
                    '    , (TOTALBRUTO - DESCONTO) as "Total l�quido" ' +
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
            '      , cast(list(distinct coalesce(ORCAMENT.VENDEDOR, '''')) as varchar(5000)) as VENDEDOR' +   /// ???? Por que est� seleciolando a lista de vendedores do or�amento se n�o usa essa lista retornada?
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
  if sCodigo = '11' then Result := 'Rond�nia';
  if sCodigo = '12' then Result := 'Acre';
  if sCodigo = '13' then Result := 'Amazonas';
  if sCodigo = '14' then Result := 'Roraima';
  if sCodigo = '15' then Result := 'Par�';
  if sCodigo = '16' then Result := 'Amap�';
  if sCodigo = '17' then Result := 'Tocantins';

  //Nordeste
  if sCodigo = '21' then Result := 'Maranh�o';
  if sCodigo = '22' then Result := 'Piau�';
  if sCodigo = '23' then Result := 'Cear�';
  if sCodigo = '24' then Result := 'Rio Grande do Norte';
  if sCodigo = '25' then Result := 'Para�ba';
  if sCodigo = '26' then Result := 'Pernambuco';
  if sCodigo = '27' then Result := 'Alagoas';
  if sCodigo = '28' then Result := 'Sergipe';
  if sCodigo = '29' then Result := 'Bahia';

  //Sudeste
  if sCodigo = '31' then Result := 'Minas Gerais';
  if sCodigo = '32' then Result := 'Esp�rito Santo';
  if sCodigo = '33' then Result := 'Rio de Janeiro';
  if sCodigo = '35' then Result := 'S�o Paulo';

  //Sul
  if sCodigo = '41' then Result := 'Paran�';
  if sCodigo = '42' then Result := 'Santa Catarina';
  if sCodigo = '43' then Result := 'Rio Grande do Sul';

  //Centro' then Result := 'oeste
  if sCodigo = '50' then Result := 'Mato Grosso do Sul';
  if sCodigo = '51' then Result := 'Mato Grosso';
  if sCodigo = '52' then Result := 'Goi�s';
  if sCodigo = '53' then Result := 'Distrito Federal';

  if sCodigo = '99' then
    Result := 'Exterior';
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

  if sCodigo = '99' then
    Exit('EX');
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

  if sUF = 'EX' then
    Result := '99';
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

  (Sender as TDBGrid).Canvas.Font.Style := [];

  if gdSelected in State then // Se a coluna estiver selecionada deixa a fonte branca para ter contraste
    (Sender as TDBGrid).Canvas.Font.Color := clWhite;
end;

function GetFatorConversaoItemCompra(CodRegItem:string; valPadrao: Double; Transaction: TIBTransaction):Double; //Mauricio Parizotto 2024-02-19
begin
  Result := 1;

  try
    Result := ExecutaComandoEscalar(Transaction,
                                    ' Select '+
                                    ' 	Case'+
                                    ' 		When Coalesce(QUANTIDADE,1) / Coalesce(QTD_ORIGINAL,1) = 1 then Coalesce(E.FATORC,1)'+
                                    ' 		Else Coalesce(QUANTIDADE,1) / Coalesce(QTD_ORIGINAL,1)'+
                                    ' 	End FATORC	'+
                                    ' From ITENS002 I'+
                                    ' 	Left Join ESTOQUE E on E.DESCRICAO = I.DESCRICAO'+
                                    ' Where I.REGISTRO = '+QuotedStr(CodRegItem)
                                    ,FloatToStr(valPadrao) );
  except
  end;

end;


function GetIVAProduto(IDESTOQUE : integer; UF : string; Transaction: TIBTransaction):Double; //Mauricio Parizotto 2024-09-11
begin
  Result := 0;

  //Sandro Silva 2024-09-23 evitar erro com cliente do exterior if UF <> '' then
  if (UF <> '') and (AnsiUpperCase(UF) <> 'EX') then
  begin
    try
      Result := ExecutaComandoEscalar(Transaction,
                                      ' Select'+
                                      '   Case'+
                                      '     When Coalesce(I.'+UF+'_,0) > 0 then Coalesce(I.'+UF+'_,0)'+
                                      '     Else Coalesce(E.PIVA,0)'+
                                      '  End'+
                                      ' From ESTOQUE E'+
                                      '   Left Join ESTOQUEIVA I on I.IDESTOQUE = E.IDESTOQUE'+
                                      ' Where E.IDESTOQUE = '+IDESTOQUE.ToString
                                      );
    except
    end;
  end else
  begin
    try
      Result := ExecutaComandoEscalar(Transaction,
                                      ' Select'+
                                      '   Coalesce(E.PIVA,0)'+
                                      ' From ESTOQUE E'+
                                      ' Where E.IDESTOQUE = '+IDESTOQUE.ToString
                                      );
    except
    end;
  end;
end;

function ExtrairConfiguracao(sTexto: String; sSigla: String): String;
{Sandro Silva 2012-01-11 inicio
Extrai configura��o existente no texto.
Quando existir mais de uma configura��o dever�o estar separadas por ponto e v�rgula(;)
Inicialmente usado para configura��o D101-Indicador da Natureza do Frete Contratado e
D101-C�digo da Base de C�lculo do Cr�dito}
var
  iConfig: Integer;
begin
  with TStringList.Create do
  begin
    Delimiter := ';';
    DelimitedText := AnsiUpperCase(sTexto);

    for iConfig := 0 to Count - 1 do
    begin
      if Pos(sSigla, Strings[iConfig]) > 0 then
      begin
        Result := LimpaNumero(Strings[iConfig]);
        Break;
      end;
    end;
    Free;
  end;
end;

function CodigoPlanoContaToTipo(AConta: String): TTipoPlanoConta;
begin
  AConta := Trim(AConta);

  var PrefixoConta := Copy(AConta, 1, 1);

  if PrefixoConta = '1' then
    Exit(tpcReceita);

  if PrefixoConta = '3' then
    Exit(tpcDespesa);

  if PrefixoConta = '5' then
    Exit(tpcBanco);

  if PrefixoConta = '7' then
    Exit(tpcRetirada);

  Exit(tpcNenhum);
end;

function TipoPlanoContaToText(ATipoPlanoConta: TTipoPlanoConta): String;
begin
  Result := '';

  if ATipoPlanoConta = tpcNenhum then
    Exit('');

  if ATipoPlanoConta = tpcReceita then
    Exit('Receita');

  if ATipoPlanoConta = tpcDespesa then
    Exit('Despesa');

  if ATipoPlanoConta = tpcBanco then
    Exit('Banco');

  if ATipoPlanoConta = tpcRetirada then
    Exit('Retiradas');
end;

function TipoPlanoContaToStr(ATipoPlanoConta: TTipoPlanoConta): String;
begin
  Result := '';

  if ATipoPlanoConta = tpcNenhum then
    Exit('');

  if ATipoPlanoConta = tpcReceita then
    Exit('1');

  if ATipoPlanoConta = tpcDespesa then
    Exit('3');

  if ATipoPlanoConta = tpcBanco then
    Exit('5');

  if ATipoPlanoConta = tpcRetirada then
    Exit('7');
end;


function RecordExists(AConnection: TIBDatabase; ATableName, AFieldName: String;
  AKeyField: TField; AValue: String): Boolean;
begin
  const SQL = 'SELECT 1 AS RecordExists '+
    'FROM RDB$DATABASE WHERE EXISTS '+
    '('+
        'SELECT 1 FROM %s WHERE not(%s = :key) and Trim(Upper(%s)) = Trim(Upper(:value))'+
    ') ';

  var Query := TIBQuery.Create(nil);
  try
    Query.Database := AConnection;
    Query.SQL.Text :=
      Format(SQL, [ATableName, AKeyField.FieldName, AFieldName]);

    Query.ParamByName('key').AsString := AKeyField.AsString;
    Query.ParamByName('value').Value := AValue;

    Query.Open();

    Result := Query.FieldByName('RecordExists').AsInteger = 1;
  finally
    Query.Free;
  end;
end;

function TipoEnderecoToString(const t: TTipoEndereco): string;
begin
  result := EnumeradoToStr(t, ['0', '1', '2', '3'],
                              [tePrincipal, teEntrega, teRetirada, teCobranca]);
end;

function TipoEnderecoToStrText(const t: TTipoEndereco): string;
begin
  result := EnumeradoToStr(t, ['Principal', 'Entrega', 'Retirada', 'Cobran�a'],
                              [tePrincipal, teEntrega, teRetirada, teCobranca]);
end;

function StrTextTipoEndereco(out ok: boolean; const s: string): TTipoEndereco;
begin
  result := StrToEnumerado(ok, s, ['Principal', 'Entrega', 'Retirada', 'Cobran�a'],
                                  [tePrincipal, teEntrega, teRetirada, teCobranca]);
end;

function StrToTipoEndereco(out ok: boolean; const s: string): TTipoEndereco;
begin
  result := StrToEnumerado(ok, s, ['0', '1', '2', '3'],
                                  [tePrincipal, teEntrega, teRetirada, teCobranca]);
end;


function StrToEnumerado(out ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];
  ok := result <> -1;
  if not ok then
    result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';
  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

function GetTmpCharacterSet(AFieldName: String): String;
begin
  Exit(Format('cast(%s as VARCHAR(60) CHARACTER SET WIN1252)', [AFieldName]));
end;


end.



