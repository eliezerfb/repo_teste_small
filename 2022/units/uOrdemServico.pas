unit uOrdemServico;

interface

  procedure ImprimeOrdemServico;

implementation

uses
  SysUtils
  , SmallFunc
  , Unit7
  , Unit30
  , Mais
  ;


procedure ImprimeOrdemServico;
var
  F: TextFile;
  fTotal1, fTotal2: Real;
  sArquivo : String;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString)); 
  Form7.ibDataSet2.Open;
  
  begin
    CriaJpg('logotip.jpg');

    sArquivo := 'OS_'+Form7.ibDataSet3NUMERO.AsString;

    AssignFile(F,pChar(sArquivo+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);

    Writeln(F,'<html><head><title>OS '+Form7.ibDataSet3NUMERO.AsString+'</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');

    WriteLn(F,'<table border=1 cellspacing=1 cellpadding=10 Width=640 style="border-collapse: collapse" >');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td  >');
    WriteLn(F,'<table border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>Data: <b>'+Form7.ibDataSet3.FieldByname('DATA').AsString+' '+TimeToStr(Time)+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>Atendente: <b>'+Form7.ibDataSet3TECNICO.AsString+'</b>');
    WriteLn(F,'   <br>Telefone: <b>' + AllTrim(Form7.ibDataSet13TELEFO.AsString));
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'<table>');
    WriteLn(F,'<table  border=0 cellspacing=0 cellpadding=0 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <center><font face="Microsoft Sans Serif" size=2><b>DOCUMENTO AUXILIAR DE VENDA - OS</b></center>');
    WriteLn(F,'   <center><font face="Microsoft Sans Serif" size=2><b>NÃO É DOCUMENTO FISCAL - NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE</b></center>');
    WriteLn(F,'   <center><font face="Microsoft Sans Serif" size=2><b>MERCADORIA - NÃO COMPROVA PAGAMENTO</b></center>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'<table>');

    WriteLn(F,'<br>');

    WriteLn(F,'<table border=1 cellspacing=1 cellpadding=5 Width=100% style="border-collapse: collapse">');
    WriteLn(F,' <tr  height=25>');
    WriteLn(F,'  <td '+{nowrap}' colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Microsoft Sans Serif" size=1><center>Identificação do Estabelecimento Emitente</center></td>');
    WriteLn(F,' </tr>');
    WriteLn(F,' <tr  height=25>');
    WriteLn(F,'  <td   '+{nowrap}'   colspan=3><font face="Microsoft Sans Serif" size=1>Denominação:  <b>'+AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35))+'</b>'+
    '<br>'+
    Form7.ibDataSet13.FieldByname('ENDERECO').AsString+'<br>'+
    Form7.ibDataSet13.FieldByname('CEP').AsString+' - '+Form7.ibDataSet13.FieldByname('MUNICIPIO').AsString+', '+Form7.ibDataSet13.FieldByname('ESTADO').AsString+'<br>'+
    Form7.ibDataSet13.FieldByname('COMPLE').AsString+'<br>'+
    'Telefone: '+Form7.ibDataSet13.FieldByname('TELEFO').AsString+'<br></td>');
    WriteLn(F,'  <td '+{nowrap}' colspan=1 vAlign=Top width=50%><font face="Microsoft Sans Serif" size=1>CNPJ:  <b>'+Form7.ibDataSet13CGC.AsString+'</b></td>');
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr height=25>');
    WriteLn(F,'  <td '+{nowrap}' colspan=4 bgcolor=#FFFFFF vAlign=Top><font face="Microsoft Sans Serif" size=1><center>Identificação do Destinatário</center></td>');
    WriteLn(F,' </tr height=25>');
    WriteLn(F,' <tr>');

    WriteLn(F,'  <td '+{nowrap}' colspan=3><font face="Microsoft Sans Serif" size=1>Denominação:  <b>'+AllTrim(Copy(Form7.ibDataSet2.FieldByname('NOME').AsString+Replicate(' ',35),1,35))+'</b>');
    WriteLn(F,'<br>'+
    Form7.ibDataSet2.FieldByname('ENDERE').AsString+'<br>'+
    Form7.ibDataSet2.FieldByname('CEP').AsString+' - '+Form7.ibDataSet2.FieldByname('CIDADE').AsString+', '+Form7.ibDataSet2.FieldByname('ESTADO').AsString+'<br>'+
    Form7.ibDataSet2.FieldByname('COMPLE').AsString+'<br>'+
    'Telefone: '+Form7.ibDataSet2.FieldByname('FONE').AsString+'<br>'+'</td>');
    WriteLn(F,'  <td '+{nowrap}' colspan=1 vAlign=Top width=50%><font face="Microsoft Sans Serif" size=1>CNPJ:  <b>'+Form7.ibDataSet2.FieldByname('CGC').AsString+'</b></td>');
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr height=25>');
    WriteLn(F,'  <td '+{nowrap}' colspan=3 bgcolor=#FFFFFF><font face="Microsoft Sans Serif" size=1>Número do Documento: '+Form7.ibDataSet3NUMERO.AsString+'</b></center></td>');
    WriteLn(F,'  <td '+{nowrap}' colspan=3 bgcolor=#FFFFFF width=50%><font face="Microsoft Sans Serif" size=1>Número do Documento Fiscal: '+Form7.ibDataSet3NF.AsString+'</b></center></td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    // Dados da OS
    WriteLn(F,'<table border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'       <font face="Microsoft Sans Serif" size=1>'+Form30.Label14.Caption+': <b>'+Form7.ibDataSet3DESCRICAO.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>'+Form30.Label15.Caption+': <b>'+Form7.ibDataSet3IDENTIFI1.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>'+Form30.Label16.Caption+': <b>'+Form7.ibDataSet3IDENTIFI2.AsString+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'       <font face="Microsoft Sans Serif" size=1>'+Form30.Label17.Caption+': <b>'+Form7.ibDataSet3IDENTIFI3.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>'+Form30.Label18.Caption+': <b>'+Form7.ibDataSet3IDENTIFI4.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=1>'+Form30.Label30.Caption+': <b>'+Form7.ibDataSet3GARANTIA.AsString+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF vAlign=TOP>');
    WriteLn(F,'    <font face="Microsoft Sans Serif" size=1>'+Form30.Label19.Caption+':<br>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF vAlign=TOP>');
    WriteLn(F,'    <font face="Microsoft Sans Serif" size=1><b>'+StrTran(Form7.ibDataSet3PROBLEMA.AsString,chr(10),'<br>')+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    // Peças
    WriteLn(F,'<font face="Microsoft Sans Serif" size=1><b><br>Peças:</b><br>');
    WriteLn(F,'<table  border=1  cellspacing=1 cellpadding=2 style="border-collapse: collapse"  >');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=50><font face="Microsoft Sans Serif" size=1>Código</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Cód de barras</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=270><font face="Microsoft Sans Serif" size=1>Descrição</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Unitário</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Total</td>');
    WriteLn(F,' </tr>');

    fTotal1 := 0;

    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.Eof do // Disable
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString));
      Form7.ibDataSet4.Open;

      if Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
      begin
        WriteLn(F,' <tr>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16CODIGO.AsString+'</td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet4REFERENCIA.AsString+'</td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>');
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>'); // Valor
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat])+'</td>'); // Valor
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16TOTAL.AsFloat])+'</td>'); // Valor
        WriteLn(F,' </tr>');

        fTotal1 := fTotal1 + Form7.ibDataSet16TOTAL.AsFloat;
      end else
      begin
        if Alltrim(Form7.ibDataSet16DESCRICAO.AsString) <> '' then
        begin
          WriteLn(F,' <tr>');
          Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
          Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
          Writeln(F,'  <td   '+{nowrap}'   colspan=5 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'&nbsp</td>');
          WriteLn(F,' </tr>');
        end;
      end;

      Form7.ibDataSet16.Next;
    end;

    WriteLn(F,' <tr>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td   align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[fTotal1])+'</td>'); // Valor
    WriteLn(F,' </tr>');

    Form7.ibDataSet16.EnableControls;
    WriteLn(F,'</table>');

    // Serviços
    WriteLn(F,'<font face="Microsoft Sans Serif" size=1><b><br>Serviços:</b><br>');
    WriteLn(F,'<table  border=1  cellspacing=1 cellpadding=2 style="border-collapse: collapse"  >');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=270><font face="Microsoft Sans Serif" size=1>Descrição</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=140><font face="Microsoft Sans Serif" size=1>'+Form30.Label34.Caption+'</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Unitário</td>');
    WriteLn(F,'  <td   bgcolor=#'+Form1.sHtmlCor+' width=80><font face="Microsoft Sans Serif" size=1>Total</td>');
    WriteLn(F,' </tr>');

    fTotal2 := 0;

    Form7.ibDataSet35.DisableControls;
    Form7.ibDataSet35.First;
    while not Form7.ibDataSet35.Eof do
    begin
      if Form7.ibDataSet35QUANTIDADE.AsFloat <> 0 then
      begin
        WriteLn(F,' <tr>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'</td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35TECNICO.AsString+'</td>');
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35QUANTIDADE.AsFloat])+'</td>'); // Valor
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35UNITARIO.AsFloat])+'</td>'); // Valor
        Writeln(F,'  <td   align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat])+'</td>'); // Valor
        WriteLn(F,' </tr>');
      end else
      begin
        WriteLn(F,' <tr>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'</td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
        Writeln(F,'  <td   bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>');
        WriteLn(F,' </tr>');
      end;

      fTotal2 := fTotal2 + Form7.ibDataSet35TOTAL.AsFloat;

      Form7.ibDataSet35.Next;
    end;

    Form7.ibDataSet35.EnableControls;
    
    WriteLn(F,' <tr>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td  ></td>');
    Writeln(F,'  <td   align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1 >'+Format('%12.'+Form1.ConfPreco+'n',[fTotal2])+'</td>'); // Valor
    WriteLn(F,' </tr>');
    WriteLn(F,'</table><br>');
    
    // Fim de serviços
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=0 style="border-collapse: collapse"  >');
    WriteLn(F,' <tr>');

    // Observação
    WriteLn(F,'  <td   bgcolor=#FFFFFF vAlign=Top>');
    WriteLn(F,'   <font face="Microsoft Sans Serif" size=1>Observação: <b>'+Form7.ibDataSet3OBSERVACAO.AsString+'<b>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td  >');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=2 style="border-collapse: collapse"  >');

    // TOTAIS
    WriteLn(F,' <tr>');
    Writeln(F,'  <td   width=590 align=Right><font face="Microsoft Sans Serif" size=1 >Total de peças R$:</td>');
    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3TOTAL_PECA.AsFloat])+'</td>'); // total de peças
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr>');
    Writeln(F,'  <td   width=590 align=Right><font face="Microsoft Sans Serif" size=1 >Total de serviços R$:</td>');
    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3TOTAL_SERV.AsFloat])+'</td>'); // total serviços
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr>');
    Writeln(F,'  <td   width=590 align=Right><font face="Microsoft Sans Serif" size=1 >'+Form30.Label10.Caption+' R$:</td>');

    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3TOTAL_FRET.AsFloat])+'</td>'); // Frete
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr>');
    Writeln(F,'  <td   width=590 align=Right><font face="Microsoft Sans Serif" size=1 >Desconto R$:</td>');
    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3DESCONTO.AsFloat])+'</td>'); // Frete
    WriteLn(F,' </tr>');

    WriteLn(F,' <tr>');
    Writeln(F,'  <td   width=590 align=Right><font face="Microsoft Sans Serif" size=1 >Total R$:</td>');
    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3TOTAL_OS.AsFloat])+'</td>'); // total da OS
    WriteLn(F,' </tr>');

    WriteLn(F,'</table>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    // Fim dos totais
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF vAlign=Top>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF width=50% vAlign=Bot>');
    WriteLn(F,'   <br><br><center><font face="Microsoft Sans Serif" size=2>______________________________________</b>');
    WriteLn(F,'   <br><center><font face="Microsoft Sans Serif" size=1>Assinatura do cliente</b>');
    WriteLn(F,'   <br><center><font face="Microsoft Sans Serif" size=1>Autorizo a execução desta ordem de serviços</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>É vedada a autenticação deste documento</font></center><br>');

    WriteLn(F,'<br><font size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
        + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
        + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');

    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;
    
    CloseFile(F);

    AbreArquivoNoFormatoCerto(pChar(sArquivo));
  end;
end;


end.
