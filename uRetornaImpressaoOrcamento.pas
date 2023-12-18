unit uRetornaImpressaoOrcamento;

interface

uses
  uIRetornaImpressaoOrcamento, IBQuery, IBDataBase, uConectaBancoSmall, Classes,
  {$IFDEF VER150}
  SmallFunc
  {$ELSE}
  smallfunc_xe
  {$ENDIF}
  ;

type
  TRetornaImpressaoOrcamento = class(TInterfacedObject, IRetornaImpressaoOrcamento)
  private
    FcNumeroOrcamento: String;
    FoTransaction: TIBTransaction;
    FlsImpressao: TStringList;
    FQryEmitente: TIBQuery;
    FQryOrcamento: TIBQuery;
    FQryItens: TIBQuery;
    FnDecimaisQtde: Integer;
    FnDecimaisPreco: Integer;
    constructor Create;
    procedure CarregarCabecalho;
    procedure CarregarItens;
    procedure CarregarEmitente;
  public
    destructor Destroy; override;
    class function New: IRetornaImpressaoOrcamento;
    function SetDecimais(AnQtde, AnPreco: Integer): IRetornaImpressaoOrcamento;
    function SetTransaction(AoTransaction: TIBTransaction): IRetornaImpressaoOrcamento;
    function SetNumeroOrcamento(AcNumeroOrcamento: String): IRetornaImpressaoOrcamento;
    function CarregaDados: IRetornaImpressaoOrcamento;
    function MontarHTML: IRetornaImpressaoOrcamento;
    function MontarTXT: IRetornaImpressaoOrcamento;
    function RetornarTexto: String;
  end;

implementation

uses SysUtils;

{ TRetornaImpressaoOrcamento }

class function TRetornaImpressaoOrcamento.New: IRetornaImpressaoOrcamento;
begin
  Result := Self.Create;
end;

function TRetornaImpressaoOrcamento.RetornarTexto: String;
begin
  if Trim(FlsImpressao.Text) <> EmptyStr then
    Result := FlsImpressao.Text;
end;

function TRetornaImpressaoOrcamento.MontarHTML: IRetornaImpressaoOrcamento;
var
  nTotal, nDesconto: Double;
  cCodigo: String;
begin
  Result := Self;

  nTotal := 0;
  nDesconto := 0;

  FlsImpressao.Add('<html><head><title>Orçamento '+FcNumeroOrcamento+'</title></head>');
  FlsImpressao.Add('<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');

  FlsImpressao.Add('<table border=1 cellspacing=1 cellpadding=5 Width=650 style="border-collapse: collapse"  bordercolor=#000000>');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td>');
  FlsImpressao.Add('<table border=0 cellspacing=1 cellpadding=5 Width=640>');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF>');
  FlsImpressao.Add('   <img src="logotip.jpg" alt="'+AllTrim(FQryEmitente.FieldByname('NOMEEMIT').AsString)+'">');
  FlsImpressao.Add('  </td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF>');
  FlsImpressao.Add('   <br><font face="Arial" size=1>Data: <b>'+FQryOrcamento.FieldByname('DATA').AsString+' '+TimeToStr(Time)+'</b>');
  FlsImpressao.Add('   <br><font face="Arial" size=1>Vendedor: <b>'+FQryOrcamento.FieldByname('VENDEDOR').AsString+'</b>');
  FlsImpressao.Add('   <br>Telefone: <b>' + AllTrim(FQryEmitente.FieldByname('TELEFONEEMIT').AsString));

  FlsImpressao.Add('  </td>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('<table>');
  FlsImpressao.Add('<table border=0 cellspacing=0 cellpadding=0 Width=100%>');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF>');
  FlsImpressao.Add('   <center><font face="Arial" size=2><b>DOCUMENTO AUXILIAR DE VENDA - ORÇAMENTO</b></center>');
  FlsImpressao.Add('   <center><font face="Arial" size=2><b>NÃO É DOCUMENTO FISCAL - NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE</b></center>');
  FlsImpressao.Add('   <center><font face="Arial" size=2><b>MERCADORIA - NÃO COMPROVA PAGAMENTO</b></center>');
  FlsImpressao.Add('  </td>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('<table>');

  FlsImpressao.Add('<table border=1 cellspacing=1 cellpadding=5 Width=640 style="border-collapse: collapse"  bordercolor=#000000>');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td nowrap colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Arial" size=1><center>Identificação do Estabelecimento Emitente</center></td>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add(' <tr >');
  FlsImpressao.Add('  <td nowrap colspan=3><font face="Arial" size=1>Denominação:  <b>'+AllTrim(Copy(FQryEmitente.FieldByname('NOMEEMIT').AsString+Replicate(' ',35),1,35))+'</b>'+
    '<br>'+
    FQryEmitente.FieldByname('ENDERECOEMIT').AsString+'<br>'+
    FQryEmitente.FieldByname('CEPEMIT').AsString+' - '+FQryEmitente.FieldByname('MUNICIPIOEMIT').AsString+', '+FQryEmitente.FieldByname('ESTADOEMIT').AsString+'<br>'+
    FQryEmitente.FieldByname('COMPLEEMIT').AsString+'<br>'+
    'Telefone: '+FQryEmitente.FieldByname('TELEFONEEMIT').AsString+'<br></td>');

  FlsImpressao.Add('  <td nowrap colspan=1 vAlign=Top><font face="Arial" size=1>CNPJ/CPF:  <b>'+FQryEmitente.FieldByname('CGCEMIT').AsString+'</b></td>');
  FlsImpressao.Add(' </tr>');

  FlsImpressao.Add(' <tr >');
  FlsImpressao.Add('  <td nowrap colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Arial" size=1><center>Identificação do Destinatário</center></td>');
  FlsImpressao.Add(' </tr >');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td nowrap colspan=3><font face="Arial" size=1>Denominação:  <b>'+AllTrim(Copy(FQryOrcamento.FieldByname('NOME').AsString+Replicate(' ',35),1,35))+'</b>');
  FlsImpressao.Add('<br>'+
    FQryOrcamento.FieldByname('ENDERE').AsString+'<br>'+
    FQryOrcamento.FieldByname('CEP').AsString+' - '+FQryOrcamento.FieldByname('CIDADE').AsString+', '+FQryOrcamento.FieldByname('ESTADO').AsString+'<br>'+
    FQryOrcamento.FieldByname('COMPLE').AsString+'<br>'+
    'Telefone: '+FQryOrcamento.FieldByname('FONE').AsString+'<br>'+'</td>');
  FlsImpressao.Add('  <td nowrap colspan=1 vAlign=Top><font face="Arial" size=1>CNPJ/CPF:  <b>'+FQryOrcamento.FieldByname('CGC').AsString+'</b></td>');
  FlsImpressao.Add(' </tr>');

  FlsImpressao.Add(' <tr >');
  FlsImpressao.Add('  <td nowrap colspan=2 bgcolor=#FFFFFF width=300><font face="Arial" size=1>Número do Orçamento: <b>'+FcNumeroOrcamento+'</b></td>');
  FlsImpressao.Add('  <td nowrap colspan=2 bgcolor=#FFFFFF width=300><font face="Arial" size=1>Número do Documento Fiscal: <b>'+FQryOrcamento.FieldByname('NUMERONF').AsString+'</b></td>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('</table>');

  FlsImpressao.Add(' <br>');

  FlsImpressao.Add('<table border=1 cellspacing=1 cellpadding=5 Width=640 style="border-collapse: collapse"  bordercolor=#000000>');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Código</td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=370><font face="Arial" size=1>Descrição</td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=70><font face="Arial" size=1>Quantidade</td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=50><font face="Arial" size=1>Und</td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Unitário</td>');
  FlsImpressao.Add('  <td bgcolor=#FFFFFF width=80><font face="Arial" size=1>Total</td>');
  FlsImpressao.Add(' </tr>');

  while not FQryItens.EOF do
  begin
    if FQryItens.FieldByName('DESCRICAO').AsString <> 'Desconto' then
    begin
      if (FQryItens.FieldByName('DESCRICAO_EST').AsString = FQryItens.FieldByName('DESCRICAO').AsString) and (Alltrim(FQryItens.FieldByName('CODIGO').AsString) <> EmptyStr) then
      begin
        if AllTrim(FQryItens.FieldByName('REFERENCIA').AsString) = EmptyStr then
          cCodigo := StrZero(StrToInt(AllTrim(FQryItens.FieldByName('CODIGO').AsString)),13,0)
        else
          cCodigo := Copy(FQryItens.FieldByName('REFERENCIA').AsString+replicate(' ',13),1,13);

        FlsImpressao.Add(' <tr>');
        FlsImpressao.Add('  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+cCodigo+'</td>');
        FlsImpressao.Add('  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+FQryItens.FieldByName('DESCRICAO').AsString+'</td>');
        FlsImpressao.Add('  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%7.'+ IntToStr(FnDecimaisQtde)+'n',[FQryItens.FieldByName('QUANTIDADE').AsFloat])+'</td>'); // Quantidade
        FlsImpressao.Add('  <td bgcolor=#FFFFFFFF><font face="Arial" size=1>'+FQryItens.FieldByname('MEDIDA').AsString+'</td>');
        FlsImpressao.Add('  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%12.'+IntToStr(FnDecimaisPreco)+'n',[FQryItens.FieldByName('UNITARIO').AsFloat])+'</td>'); // Valor
        FlsImpressao.Add('  <td align=Right bgcolor=#FFFFFFFF><font face="Arial" size=1 >'+Format('%12.'+IntToStr(FnDecimaisPreco)+'n',[FQryItens.FieldByName('TOTAL').AsFloat])+'</td>'); // Valor
        FlsImpressao.Add(' </tr>');

        nTotal := nTotal + FQryItens.FieldByName('TOTAL').AsFloat;
      end else
      begin
        if Alltrim(FQryItens.FieldByName('DESCRICAO').AsString) <> EmptyStr then
        begin
          if UpperCase(FQryItens.FieldByName('DESCRICAO').AsString) <> 'DESCONTO' then
          begin
            FlsImpressao.Add(' <tr>');
            FlsImpressao.Add('  <td bgcolor=#FFFFFFFF><font face="Arial" size=1></td>');
            FlsImpressao.Add('  <td  nowrap colspan=5 bgcolor=#FFFFFFFF><font face="Arial" size=1>'+FQryItens.FieldByName('DESCRICAO').AsString+'</td>');
            FlsImpressao.Add(' </tr>');
          end;
        end;
      end;
    end
    else
      nDesconto := nDesconto + FQryItens.FieldByName('TOTAL').AsFloat;
    FQryItens.Next;
  end;
  nTotal := nTotal - nDesconto;
  FlsImpressao.Add('</table>');
  FlsImpressao.Add('<br>');

  FlsImpressao.Add('<table border=0 cellspacing=1 cellpadding=1 Width=640>');
  FlsImpressao.Add(' <tr>');
  if AllTrim(FQryOrcamento.FieldByName('OBS').AsString) <> EmptyStr then
  begin
    FlsImpressao.Add('  <td bgcolor=#FFFFFF vAlign=Top align=Left width=500><font face="Arial" size=1><b>Observação</b><br>');
    FlsImpressao.Add('  <bgcolor=#FFFFFF  vAlign=Top align=Left width=500><font face="Arial" size=1>' + FQryOrcamento.FieldByName('OBS').AsString + '</td>');
  end;
  FlsImpressao.Add('  <td bordercolor=#FFFFFF vAlign=Top align=Right><font face="Arial" size=1><b>Desconto R$: ' + Format('%12.' + IntToStr(FnDecimaisPreco) + 'n', [nDesconto]) + '<br><br>Total R$: ' + Format('%12.' + IntToStr(FnDecimaisPreco) + 'n', [nTotal]) + '</td></b>'); // Valor  
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('</table>');
  
  FlsImpressao.Add('<table border=0 cellspacing=1 cellpadding=2 Width=100%');
  FlsImpressao.Add(' <tr>');
  FlsImpressao.Add('  <br><font face="Arial" size=1><center>É vedada a autenticação deste documento</center>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('</table>');

  FlsImpressao.Add('</table>');
  FlsImpressao.Add('  </td>');
  FlsImpressao.Add(' </tr>');
  FlsImpressao.Add('</table>');

  if (Alltrim(FQryEmitente.FieldByname('HP').AsString) = EmptyStr) then
  begin
    FlsImpressao.Add('<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
  end else
  begin
    FlsImpressao.Add('<font face="verdana" size=1><center><a href="http://'+FQryEmitente.FieldByname('HP').AsString+'">'+FQryEmitente.FieldByname('HP').AsString+'</a><font>');
  end;

  FlsImpressao.Add('</html>');
end;

function TRetornaImpressaoOrcamento.MontarTXT: IRetornaImpressaoOrcamento;
var
  nTotal, nDesconto: Double;
  cCodigo: String;
  cObs: String;
begin
  Result := Self;

  nTotal := 0;
  nDesconto := 0;
  
  FlsImpressao.Add('DOCUMENTO AUXILIAR DE VENDA (DAV) - ORCAMENTO');
  FlsImpressao.Add('NÃO É DOCUMENTO FISCAL');
  FlsImpressao.Add('NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE');
  FlsImpressao.Add('MERCADORIA - NÃO COMPROVA PAGAMENTO');
  FlsImpressao.Add('------------------------------------------------');
  FlsImpressao.Add(Copy('Emitente: '+ AllTrim(Copy(FQryEmitente.FieldByname('NOMEEMIT').AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
  FlsImpressao.Add('CNPJ: '+ FQryEmitente.FieldByname('CGCEMIT').AsString);

  FlsImpressao.Add(Copy(FQryEmitente.FieldByname('ENDERECOEMIT').AsString  + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy(FQryEmitente.FieldByname('CEPEMIT').AsString+' - '+FQryEmitente.FieldByname('MUNICIPIOEMIT').AsString+', '+FQryEmitente.FieldByname('ESTADOEMIT').AsString  + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy(FQryEmitente.FieldByname('COMPLEEMIT').AsString  + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy('Vendedor: '+ FQryOrcamento.FieldByname('VENDEDOR').AsString + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy('Telefone: '+ FQryEmitente.FieldByname('TELEFONEEMIT').AsString + Replicate(' ',45),1,45));
  FlsImpressao.Add('-----------------------------------------------');
  FlsImpressao.Add(Copy('Destinatário: ' + AllTrim(Copy(FQryOrcamento.FieldByname('NOME').AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
  FlsImpressao.Add('CNPJ: '+ FQryOrcamento.FieldByname('CGC').AsString);
  FlsImpressao.Add(Copy(FQryOrcamento.FieldByname('ENDERE').AsString  + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy(FQryOrcamento.FieldByname('CEP').AsString+' - '+FQryOrcamento.FieldByname('CIDADE').AsString+', '+FQryOrcamento.FieldByname('ESTADO').AsString + Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy(FQryOrcamento.FieldByname('COMPLE').AsString +  Replicate(' ',45),1,45));
  FlsImpressao.Add(Copy('Telefone: '+FQryOrcamento.FieldByname('FONE').AsString + Replicate(' ',45),1,45));
  FlsImpressao.Add('-----------------------------------------------');
  FlsImpressao.Add('Número do Orçamento: '+ FcNumeroOrcamento);
  FlsImpressao.Add('Número do Documento Fiscal: '+FQryOrcamento.FieldByname('NUMERONF').AsString);
  FlsImpressao.Add('Data: '+DateToStr(Date)+' '+TimeToStr(Time));

  FlsImpressao.Add('-----------------------------------------------');
  FlsImpressao.Add('CÓDIGO        DESCRIÇÃO                         ');
  FlsImpressao.Add('QTD         UNITARIO  TOTAL');
  FlsImpressao.Add('------------------------------------------------');;

  FQryItens.First;
  while not FQryItens.Eof do
  begin
    if UpperCase(AllTrim(FQryItens.FieldByName('DESCRICAO').AsString))  = 'DESCONTO' then
      nDesconto := nDesconto + FQryItens.FieldByname('TOTAL').AsFloat
    else
    begin
      if Alltrim(FQryItens.FieldByName('DESCRICAO').AsString) <> EmptyStr then
      begin
        if AllTrim(FQryItens.FieldByName('DESCRICAO_EST').AsString) = Alltrim(FQryItens.FieldByName('DESCRICAO').AsString) then
        begin
          //
          if (Length(AllTrim(FQryItens.FieldByname('REFERENCIA').AsString)) in [8, 13, 14]) then
            cCodigo := FQryItens.FieldByname('REFERENCIA').AsString
          else
            cCodigo := StrZero(StrToInt('0'+FQryItens.FieldByname('CODIGO').AsString),14,0);

          FlsImpressao.Add(cCodigo + ' ' + Copy(FQryItens.FieldByname('DESCRICAO').AsString+Replicate(' ',30),1,30));
          FlsImpressao.Add(Format('%10.2n',[FQryItens.FieldByname('QUANTIDADE').AsFloat])+'X'+Format('%10.2n',[FQryItens.FieldByname('UNITARIO').AsFloat])+' '+ Format('%10.2n',[FQryItens.FieldByname('TOTAL').AsFloat]));

          nTotal := nTotal +  FQryItens.FieldByname('TOTAL').AsFloat;
          
        end else
        begin
          // Divide o texto da observação em 2 partes para imprimir sem cortar
          {Mauricio Parizotto 2023-12-18
          FlsImpressao.Add('               ' + Copy(FQryItens.FieldByname('DESCRICAO').AsString+Replicate(' ',30),1,30));
          if Copy(FQryItens.FieldByname('DESCRICAO').AsString, 31, 15) <> EmptyStr then
            FlsImpressao.Add('               ' + Copy(Copy(FQryItens.FieldByname('DESCRICAO').AsString, 31, 15)+Replicate(' ',30),1,30));
          }
          FlsImpressao.Add(DescricaoComQuebraLinha(FQryItens.FieldByname('DESCRICAO').AsString,'               ',30)) ;
        end;
      end;
    end;
    FQryItens.Next;
  end;

  FlsImpressao.Add('------------------------------------------------');
  FlsImpressao.Add('SUB TOTAL                           '+Format('%10.2n',[nTotal]));
  FlsImpressao.Add('DESCONTO                            '+Format('%10.2n',[nDesconto]));
  FlsImpressao.Add('TOTAL                               '+Format('%10.2n',[nTotal-nDesconto]));

  if AllTrim(FQryOrcamento.FieldByname('OBS').AsString) <> EmptyStr then
  begin
    cObs := FQryOrcamento.FieldByname('OBS').AsString;
    FlsImpressao.Add(EmptyStr);
    FlsImpressao.Add('OBSERVAÇÃO');
    while Length(cObs) > 0 do
    begin
      FlsImpressao.Add(Copy(cObs,1,45));
      cObs := Copy(cObs, 46, Length(cObs));
    end;
    FlsImpressao.Add(EmptyStr);
  end;

  FlsImpressao.Add('É vedada a autenticação deste documento');
  FlsImpressao.Add(EmptyStr);
  FlsImpressao.Add(EmptyStr);
  FlsImpressao.Add(EmptyStr);
  FlsImpressao.Add(EmptyStr);
  FlsImpressao.Add(EmptyStr);        
end;

constructor TRetornaImpressaoOrcamento.Create;
begin
  FlsImpressao := TStringList.Create;

  FnDecimaisQtde  := 2;
  FnDecimaisPreco := 2;
end;

destructor TRetornaImpressaoOrcamento.Destroy;
begin
  FreeAndNil(FlsImpressao);
  FreeAndNil(FQryEmitente);
  FreeAndNil(FQryOrcamento);
  FreeAndNil(FQryItens);
  inherited;
end;

function TRetornaImpressaoOrcamento.SetTransaction(
  AoTransaction: TIBTransaction): IRetornaImpressaoOrcamento;
begin
  Result := Self;
  FoTransaction := AoTransaction;
  
  FQryEmitente := CriaIBQuery(FoTransaction);
  FQryOrcamento := CriaIBQuery(FoTransaction);
  FQryItens := CriaIBQuery(FoTransaction);

end;

function TRetornaImpressaoOrcamento.CarregaDados: IRetornaImpressaoOrcamento;
begin
  Result := Self;

  CarregarEmitente;
  CarregarCabecalho;
  CarregarItens;  
end;

procedure TRetornaImpressaoOrcamento.CarregarEmitente;
begin
  FQryEmitente.Close;
  FQryEmitente.SQL.Clear;

  FQryEmitente.SQL.Add('SELECT FIRST 1');
  FQryEmitente.SQL.Add('    EMITENTE.NOME AS NOMEEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.TELEFO AS TELEFONEEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.ENDERECO AS ENDERECOEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.CEP AS CEPEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.MUNICIPIO AS MUNICIPIOEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.ESTADO AS ESTADOEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.COMPLE AS COMPLEEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.CGC AS CGCEMIT');
  FQryEmitente.SQL.Add('    , EMITENTE.HP');
  FQryEmitente.SQL.Add('FROM EMITENTE');
  FQryEmitente.Open;
  
  FQryEmitente.First;
end;

procedure TRetornaImpressaoOrcamento.CarregarCabecalho;
begin
  FQryOrcamento.Close;
  FQryOrcamento.SQL.Clear;

  FQryOrcamento.SQL.Add('SELECT DISTINCT');
  FQryOrcamento.SQL.Add('    ORCAMENT.PEDIDO');
  FQryOrcamento.SQL.Add('    , ORCAMENT.DATA');
  FQryOrcamento.SQL.Add('    , ORCAMENT.NUMERONF');
  FQryOrcamento.SQL.Add('    , CLIFOR.NOME');
  FQryOrcamento.SQL.Add('    , CLIFOR.ENDERE');
  FQryOrcamento.SQL.Add('    , CLIFOR.CEP');
  FQryOrcamento.SQL.Add('    , CLIFOR.CIDADE');
  FQryOrcamento.SQL.Add('    , CLIFOR.ESTADO');
  FQryOrcamento.SQL.Add('    , CLIFOR.COMPLE');
  FQryOrcamento.SQL.Add('    , CLIFOR.FONE');
  FQryOrcamento.SQL.Add('    , CLIFOR.CGC');
  FQryOrcamento.SQL.Add('    , VENDEDOR.NOME AS VENDEDOR');
  FQryOrcamento.SQL.Add('    , ORCAMENTOBS.OBS AS OBS');
  FQryOrcamento.SQL.Add('FROM ORCAMENT');
  FQryOrcamento.SQL.Add('LEFT JOIN CLIFOR ON');
  FQryOrcamento.SQL.Add('    (CLIFOR.NOME=ORCAMENT.CLIFOR)');
  FQryOrcamento.SQL.Add('LEFT JOIN VENDEDOR ON');
  FQryOrcamento.SQL.Add('    (VENDEDOR.NOME=ORCAMENT.VENDEDOR)');
  FQryOrcamento.SQL.Add('LEFT JOIN ORCAMENTOBS ON');
  FQryOrcamento.SQL.Add('    (ORCAMENTOBS.PEDIDO=ORCAMENT.PEDIDO)');
  FQryOrcamento.SQL.Add('WHERE (ORCAMENT.PEDIDO=:XORCAMENT)');
  FQryOrcamento.SQL.Add(' AND (ORCAMENT.DESCRICAO <> ' + QuotedStr('Desconto') + ')');
  FQryOrcamento.ParamByName('XORCAMENT').AsString := FcNumeroOrcamento;
  FQryOrcamento.Open;
  
  FQryOrcamento.First;
end;

procedure TRetornaImpressaoOrcamento.CarregarItens;
begin
  FQryItens.Close;
  FQryItens.SQL.Clear;

  FQryItens.SQL.Add('SELECT');
  FQryItens.SQL.Add('    ORCAMENT.CODIGO');
  FQryItens.SQL.Add('    , ESTOQUE.CODIGO AS CODIGO_EST');
  FQryItens.SQL.Add('    , ESTOQUE.REFERENCIA');
  FQryItens.SQL.Add('    , ESTOQUE.MEDIDA');
  FQryItens.SQL.Add('    , ORCAMENT.DESCRICAO');
  FQryItens.SQL.Add('    , ESTOQUE.DESCRICAO AS DESCRICAO_EST');
  FQryItens.SQL.Add('    , ORCAMENT.QUANTIDADE');
  FQryItens.SQL.Add('    , ORCAMENT.UNITARIO');
  FQryItens.SQL.Add('    , ORCAMENT.TOTAL');
  FQryItens.SQL.Add('FROM ORCAMENT');
  FQryItens.SQL.Add('LEFT JOIN ESTOQUE ON');
  FQryItens.SQL.Add('    (ESTOQUE.CODIGO=ORCAMENT.CODIGO)');
  FQryItens.SQL.Add('WHERE (ORCAMENT.PEDIDO=:XORCAMENT)');
  FQryItens.ParamByName('XORCAMENT').AsString := FcNumeroOrcamento;
  FQryItens.Open;

  FQryItens.First;
end;

function TRetornaImpressaoOrcamento.SetNumeroOrcamento(
  AcNumeroOrcamento: String): IRetornaImpressaoOrcamento;
begin
  Result := Self;
  
  FcNumeroOrcamento := AcNumeroOrcamento;
end;

function TRetornaImpressaoOrcamento.SetDecimais(AnQtde, AnPreco: Integer): IRetornaImpressaoOrcamento;
begin
  Result := Self;
  
  FnDecimaisQtde := AnQtde;
  FnDecimaisPreco := AnPreco;
end;

end.

