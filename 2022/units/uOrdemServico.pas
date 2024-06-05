unit uOrdemServico;

interface

uses
  Winapi.ShellAPI, Winapi.Windows, uArquivosDAT, System.Classes, SysUtils;

  procedure ImprimeOrdemServico;
  procedure ImprimeReciboOrdemServico; //Mauricio Parizotto 2024-05-10
  function MontarArquivoTXT_OS : string;
  function MontarArquivoReciboTXT_OS(ObsRecibo:string): string;

implementation

uses
   smallfunc_xe
  , Unit7
  , Unit30
  , Mais
  , uTypesImpressao
  , MAIS3
  , uImprimeNaImpressoraDoWindows;


procedure ImprimeOrdemServico;
var
  F: TextFile;
  fTotal1, fTotal2: Real;
  sArquivo : String;

  TipoImpressao : TImpressao;
  ConfSistema : TArquivosDAT;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString)); 
  Form7.ibDataSet2.Open;

  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
    TipoImpressao := StrToTimp(ConfSistema.BD.Impressora.ImpressoraOS);
  finally
    FreeAndNil(ConfSistema);
  end;

  if (TipoImpressao = impHTML) or (TipoImpressao = impPDF) then
  begin
    {$Region'//// Cria Arquivo HTML ////'}
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
    Writeln(F,'  <td   width=80  align=Right><font face="Microsoft Sans Serif" size=1 ><b>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet3DESCONTO.AsFloat])+'</td>'); // Desconto
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
    {$Endregion}
  end;

  if TipoImpressao = impTXT then
  begin
    sArquivo := 'OS_'+Form7.ibDataSet3NUMERO.AsString;

    AssignFile(F,pChar(sArquivo+'.txt'));
    Rewrite(F);

    Writeln(F,MontarArquivoTXT_OS);

    CloseFile(F);
  end;

  if TipoImpressao = impWindows then
  begin
    ImprimeNaImpressoraDoWindows(MontarArquivoTXT_OS);
  end;

  {$Region'//// Abre Arquivo ///'}
  {Mauricio Parizotto 2024-05-10 Inicio}

  if TipoImpressao = impHTML then
  begin
    ShellExecute( 0, 'Open',pChar(pChar(sArquivo)+'.HTM'),'', '', SW_SHOWMAXIMIZED);
  end;

  if TipoImpressao = impPDF then
  begin
    HtmlParaPdf(pChar(sArquivo));
    ShellExecute( 0, 'Open',pChar(pChar(sArquivo)+'.pdf'),'', '', SW_SHOWMAXIMIZED);
  end;

  //Mauricio Parizotto 2024-05-21
  if TipoImpressao = impTXT then
  begin
    ShellExecute( 0, 'Open',pChar(pChar(sArquivo)+'.txt'),'', '', SW_SHOWMAXIMIZED);
  end;

  {Mauricio Parizotto 2024-05-10 Fim}
  {$Endregion}
end;


procedure ImprimeReciboOrdemServico;
var
  F: TextFile;
  ObservacaoRecibo : string;
  ConfSistema : TArquivosDAT;
  TipoImpressao : TImpressao;
begin
  Form7.ibDataSet2.Close;
  Form7.ibDataSet2.Selectsql.Clear;
  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString));
  Form7.ibDataSet2.Open;

  {Mauricio Parizotto 2023-11-21 Inicio}
  try
    // Sandro Silva 2024-04-24 ConfSistema := TArquivosDAT.Create(Usuario,ibDataSet3.Transaction);
    ConfSistema := TArquivosDAT.Create(Usuario,Form7.ibDataSet13.Transaction);
    ObservacaoRecibo := ConfSistema.BD.OS.ObservacaoReciboOS;
    TipoImpressao    := StrToTimp(ConfSistema.BD.Impressora.ImpressoraOS); // Mauricio Parizotto 2024-05-10
  finally
    FreeAndNil(ConfSistema);
  end;

  if (TipoImpressao = impHTML) or (TipoImpressao = impPDF) then
  begin
    {$Region'//// Cria Arquivo HTML ////'}
    CriaJpg('logotip.jpg');
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - RECIBO DE ENTREGA</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<table  border=1  cellspacing=1 cellpadding=5 Width=600 style="border-collapse: collapse"  >');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td  >');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=600>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <P><font face="Microsoft Sans Serif" size=1> '+Form7.ibDataSet13NOME.AsString);
    WriteLn(F,'   <BR>CNPJ: '+Form7.ibDataSet13CGC.AsString+' IE: '+Form7.ibDataSet13IE.AsString);
    WriteLn(F,'   <BR>' + AllTrim(Form7.ibDataSet13ENDERECO.AsString) + ' - ' + AllTrim(Form7.ibDataSet13COMPLE.AsString));
    WriteLn(F,'   <BR>' + AllTrim(Form7.ibDataSet13CEP.AsString) + ' ' + AllTrim(Form7.ibDataSet13MUNICIPIO.AsString) + ' - ' + AllTrim(UpperCase(Form7.ibDataSet13ESTADO.AsString)) );
    WriteLn(F,'   <BR>Telefone: ' + AllTrim(Form7.ibDataSet13TELEFO.AsString));
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'<table>');
    WriteLn(F,'<table  border=0 cellspacing=0 cellpadding=0 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <center><font face="Microsoft Sans Serif" size=4><b>RECIBO DE ENTREGA - OS '+Form7.ibDataSet3NUMERO.AsString+'</b></center>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Cliente: <b>'+Form7.ibDataSet2NOME.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Contato: <b>'+AllTrim(Form7.ibDataSet2CONTATO.AsString)+'</b> Telefone: <b>'+AllTrim(Form7.ibDataSet2FONE.AsString)+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Endereço: <b>'+AllTrim(Form7.ibDataSet2ENDERE.AsString)+' - '+ AllTrim(Form7.ibDataSet2COMPLE.AsString)+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Cidade: <b>'+Form7.ibDataSet2CEP.AsString + ' ' + AllTrim(Form7.ibDataSet2CIDADE.AsString) + ' ' + AllTrim(Form7.ibDataSet2ESTADO.AsString)+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Atendente: <b>'+Form7.ibDataSet3TECNICO.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Data da entrada: <b>'+Form7.ibDataSet3DATA.AsString+' '+Form7.ibDataSet3HORA.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Agendado para: <b>'+Form7.ibDataSet3DATA_PRO.AsString+' '+Form7.ibDataSet3HORA_PRO.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>Tempo estimado: <b>'+Form7.ibDataSet3TEMPO.AsString+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');

    WriteLn(F,'       <font face="Microsoft Sans Serif" size=2>'+Form30.Label14.Caption+': <b>'+Form7.ibDataSet3DESCRICAO.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>'+Form30.Label15.Caption+': <b>'+Form7.ibDataSet3IDENTIFI1.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>'+Form30.Label16.Caption+': <b>'+Form7.ibDataSet3IDENTIFI2.AsString+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'       <font face="Microsoft Sans Serif" size=2>'+Form30.Label17.Caption+': <b>'+Form7.ibDataSet3IDENTIFI3.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>'+Form30.Label18.Caption+': <b>'+Form7.ibDataSet3IDENTIFI4.AsString+'</b>');
    WriteLn(F,'   <br><font face="Microsoft Sans Serif" size=2>'+Form30.Label30.Caption+': <b>'+Form7.ibDataSet3GARANTIA.AsString+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    //WriteLn(F,'    <font face="Microsoft Sans Serif" size=2>'+Form30.Label19.Caption+': <b>'+Form7.ibDataSet3PROBLEMA.AsString+'</b>'); Mauricio Parizotto 2023-11-23
    WriteLn(F,'    <font face="Microsoft Sans Serif" size=2>'+Form30.Label19.Caption+': <b>'+QuebraLinhaHtml(Form7.ibDataSet3PROBLEMA.AsString)+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');
    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    //WriteLn(F,'    <font face="Microsoft Sans Serif" size=2>Observação: <b>'+Form7.ibDataSet3OBSERVACAO.AsString+'</b>');  Mauricio Parizotto 2023-11-23
    WriteLn(F,'    <font face="Microsoft Sans Serif" size=2>Observação: <b>'+QuebraLinhaHtml(Form7.ibDataSet3OBSERVACAO.AsString)+'</b>');
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    {Mauricio Parizotto 2023-11-21 Inicio}
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF>');
    WriteLn(F,'    <font face="Microsoft Sans Serif" size=2>'+QuebraLinhaHtml(ObservacaoRecibo));
    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    {Mauricio Parizotto 2023-11-21 Inicio}
    WriteLn(F,'</table>');

    WriteLn(F,'<table  border=0 cellspacing=1 cellpadding=5 Width=100%>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF width=50%>');

    WriteLn(F,'  </td>');
    WriteLn(F,'  <td   bgcolor=#FFFFFF width=50%>');
    WriteLn(F,'   <br><br><br><center><font face="Microsoft Sans Serif" size=2>______________________________________</b>');
    WriteLn(F,'   <br><center><font face="Microsoft Sans Serif" size=2>Assinatura do atendente</b>');

    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    WriteLn(F,'  </td>');
    WriteLn(F,' </tr>');
    WriteLn(F,'</table>');

    WriteLn(F,'<center><font face="Microsoft Sans Serif" size=1></b>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');
    WriteLn(F,'<font face="Microsoft Sans Serif" size=1><center>pelo sistema Small Commerce, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a></font></center>');
    WriteLn(F,'</html>');
    CloseFile(F);
    {$Endregion}
  end;

  if TipoImpressao = impTXT then
  begin
    AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));
    Rewrite(F);

    Writeln(F,MontarArquivoReciboTXT_OS(ObservacaoRecibo));

    CloseFile(F);
  end;

  if TipoImpressao = impWindows then
  begin
    ImprimeNaImpressoraDoWindows(MontarArquivoReciboTXT_OS(ObservacaoRecibo));
  end;

  {$Region'//// Abre Arquivo ///'}
  {Mauricio Parizotto 2024-05-10 Inicio}

  if TipoImpressao = impHTML then
  begin
    ShellExecute( 0, 'Open',pChar(pChar(Senhas.UsuarioPub)+'.HTM'),'', '', SW_SHOWMAXIMIZED);
  end;

  if TipoImpressao = impPDF then
  begin
    HtmlParaPdf(pChar(Senhas.UsuarioPub));
    ShellExecute( 0, 'Open',pChar(pChar(Senhas.UsuarioPub)+'.pdf'),'', '', SW_SHOWMAXIMIZED);
  end;

  //Mauricio Parizotto 2024-05-21
  if TipoImpressao = impTXT then
  begin
    ShellExecute( 0, 'Open',pChar(pChar(Senhas.UsuarioPub)+'.txt'),'', '', SW_SHOWMAXIMIZED);
  end;

  {Mauricio Parizotto 2024-05-10 Fim}
  {$Endregion}

end;


function MontarArquivoTXT_OS: string;
var
  FlsImpressao: TStringList;
  sCodigo : string;

  fTotalPecas, fTotalServico, fFrete, fDesconto, fTotal : Real;
begin
  Result := '';

  fTotalPecas     := 0;
  fTotalServico   := 0;
  fFrete          := 0;
  fDesconto       := 0;
  fTotal          := 0;

  try
    FlsImpressao := TStringList.Create;

    FlsImpressao.Add('DOCUMENTO AUXILIAR DE VENDA (DAV) - OS');
    FlsImpressao.Add('NÃO É DOCUMENTO FISCAL');
    FlsImpressao.Add('NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE');
    FlsImpressao.Add('MERCADORIA - NÃO COMPROVA PAGAMENTO');

    FlsImpressao.Add('------------------------------------------------');
    FlsImpressao.Add(Copy('Emitente: '+ AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
    FlsImpressao.Add('CNPJ: '+ Form7.ibDataSet13CGC.AsString);
    FlsImpressao.Add(Copy(Form7.ibDataSet13ENDERECO.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet13CEP.AsString+' - '+Form7.ibDataSet13MUNICIPIO.AsString+', '+Form7.ibDataSet13ESTADO.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet13COMPLE.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy('Telefone: '+ Form7.ibDataSet13TELEFO.AsString + Replicate(' ',45),1,45));

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add(Copy('Destinatário: ' + AllTrim(Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
    FlsImpressao.Add('CNPJ: '+ Form7.ibDataSet2CGC.AsString);
    FlsImpressao.Add(Copy(Form7.ibDataSet2ENDERE.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet2CEP.AsString+' - '+Form7.ibDataSet2CIDADE.AsString+', '+Form7.ibDataSet2ESTADO.AsString + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet2COMPLE.AsString +  Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy('Telefone: '+Form7.ibDataSet2FONE.AsString + Replicate(' ',45),1,45));

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add('Número da OS: '+ Form7.ibDataSet3NUMERO.AsString);
    FlsImpressao.Add('Número do Documento Fiscal: '+Form7.ibDataSet3NF.AsString);
    FlsImpressao.Add('Data: '+DateToStr(Date)+' '+TimeToStr(Time));
    FlsImpressao.Add('Situação: '+Form7.ibDataSet3SITUACAO.AsString);
    FlsImpressao.Add('Atendente: '+Form7.ibDataSet3TECNICO.AsString);

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label14.Caption+': '+Form7.ibDataSet3DESCRICAO.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label15.Caption+': '+Form7.ibDataSet3IDENTIFI1.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label16.Caption+': '+Form7.ibDataSet3IDENTIFI2.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label17.Caption+': '+Form7.ibDataSet3IDENTIFI3.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label18.Caption+': '+Form7.ibDataSet3IDENTIFI4.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label30.Caption+': '+Form7.ibDataSet3GARANTIA.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label19.Caption+': '+Form7.ibDataSet3PROBLEMA.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha('Observação: '+Form7.ibDataSet3OBSERVACAO.AsString,'',47));

    FlsImpressao.Add('--------------------Peças----------------------');
    FlsImpressao.Add('CODIGO   DESCRICAO   QTD    UNITARIO      TOTAL');
    FlsImpressao.Add('-----------------------------------------------');

    {$Region'//// Peças ////'}
    Form7.ibDataSet16.First;
    while not Form7.ibDataSet16.Eof do
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Clear;
      Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString));
      Form7.ibDataSet4.Open;

      if (Form7.ibDataSet16DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString)
        and (Trim(Form7.ibDataSet16CODIGO.AsString) <> '') then
      begin
        if (Length(AllTrim(Form7.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 13)
          or (Length(AllTrim(Form7.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 14)
          or (Length(AllTrim(Form7.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 12)
          or (Length(AllTrim(Form7.ibDataSet4.FieldByName('REFERENCIA').AsString)) = 8)
        then
          sCodigo := Copy( Form7.ibDataSet4.FieldByName('REFERENCIA').AsString+Replicate(' ',14),1,14)
        else
          sCodigo := StrZero(StrToIntDef(Form7.ibDataSet4.FieldByName('CODIGO').AsString,0),14,0);


        FlsImpressao.Add(sCodigo + ' ' + Copy(Form7.ibDataSet16.FieldByName('DESCRICAO').AsString+Replicate(' ',32),1,32)+chr(10)+
                         '               '+Format('%10.2n',[Form7.ibDataSet16.FieldByName('QUANTIDADE').AsFloat])+'X'+
                         Format('%10.2n',[Form7.ibDataSet16.FieldByName('UNITARIO').AsFloat])+' '+
                         Format('%10.2n',[Form7.ibDataSet16.FieldByName('TOTAL').AsFloat])
                         );
      end else
      begin
        FlsImpressao.Add(DescricaoComQuebraLinha(Form7.ibDataSet16DESCRICAO.AsString,'',47));
      end;

      fTotalPecas := fTotalPecas + Form7.ibDataSet16TOTAL.AsFloat;
      Form7.ibDataSet16.Next;
    end;
    {$Endregion}

    FlsImpressao.Add('-------------------Serviços--------------------');
    FlsImpressao.Add('TECNICO  DESCRICAO   QTD    UNITARIO      TOTAL');
    FlsImpressao.Add('-----------------------------------------------');

    {$Region'//// Serviços ////'}
    Form7.ibDataSet35.First;
    while not Form7.ibDataSet35.Eof do
    begin
      if Form7.ibDataSet35QUANTIDADE.AsFloat <> 0 then
      begin
        sCodigo := Copy(Form7.ibDataSet35TECNICO.AsString+Replicate(' ',8),1,8);

        FlsImpressao.Add(sCodigo + ' ' + Copy(Form7.ibDataSet35.FieldByName('DESCRICAO').AsString+Replicate(' ',38),1,38)+chr(10)+
                         '               '+Format('%10.2n',[Form7.ibDataSet35.FieldByName('QUANTIDADE').AsFloat])+'X'+
                         Format('%10.2n',[Form7.ibDataSet35.FieldByName('UNITARIO').AsFloat])+' '+
                         Format('%10.2n',[Form7.ibDataSet35.FieldByName('TOTAL').AsFloat])
                         );
      end else
      begin
        FlsImpressao.Add(DescricaoComQuebraLinha(Form7.ibDataSet16DESCRICAO.AsString,'',48));
      end;

      fTotalServico := fTotalServico + Form7.ibDataSet35TOTAL.AsFloat;
      Form7.ibDataSet35.Next;
    end;
    {$Endregion}

    fFrete    := Form7.ibDataSet3TOTAL_FRET.AsFloat;
    fDesconto := Form7.ibDataSet3DESCONTO.AsFloat;
    fTotal    := fTotalPecas+fTotalServico+fFrete-fDesconto;

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add('Total de Peças                       '+Format('%10.2n',[fTotalPecas]));
    FlsImpressao.Add('Total de Serviços                    '+Format('%10.2n',[fTotalServico]));
    FlsImpressao.Add('FRETE                                '+Format('%10.2n',[fFrete]));
    FlsImpressao.Add('DESCONTO                             '+Format('%10.2n',[fDesconto]));
    FlsImpressao.Add('TOTAL                                '+Format('%10.2n',[fTotal]));
    FlsImpressao.Add('');
    FlsImpressao.Add('');
    FlsImpressao.Add('_______________________________________________');
    FlsImpressao.Add('             Assinatura do cliente             ');
    FlsImpressao.Add('Autorizo a execução desta ordem de serviço   ');
    FlsImpressao.Add('');
    FlsImpressao.Add('E vedada a autenticacao deste documento');

    Result := FlsImpressao.Text;

  finally
    FreeAndNil(FlsImpressao);
  end;
end;


function MontarArquivoReciboTXT_OS(ObsRecibo:string): string;
var
  FlsImpressao: TStringList;
  sCodigo : string;
begin
  Result := '';

  try
    FlsImpressao := TStringList.Create;

    FlsImpressao.Add('RECIBO DE ENTREGA');
    FlsImpressao.Add('NÃO É DOCUMENTO FISCAL');
    FlsImpressao.Add('NÃO É VÁLIDO COMO RECIBO E COMO GARANTIA DE');
    FlsImpressao.Add('MERCADORIA - NÃO COMPROVA PAGAMENTO');

    FlsImpressao.Add('------------------------------------------------');
    FlsImpressao.Add(Copy('Emitente: '+ AllTrim(Copy(Form7.ibDataSet13NOME.AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
    FlsImpressao.Add('CNPJ: '+ Form7.ibDataSet13CGC.AsString);
    FlsImpressao.Add(Copy(Form7.ibDataSet13ENDERECO.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet13CEP.AsString+' - '+Form7.ibDataSet13MUNICIPIO.AsString+', '+Form7.ibDataSet13ESTADO.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet13COMPLE.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy('Telefone: '+ Form7.ibDataSet13TELEFO.AsString + Replicate(' ',45),1,45));

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add(Copy('Destinatário: ' + AllTrim(Copy(Form7.ibDataSet2NOME.AsString+Replicate(' ',35),1,35)) + Replicate(' ',45),1,45));
    FlsImpressao.Add('CNPJ: '+ Form7.ibDataSet2CGC.AsString);
    FlsImpressao.Add(Copy(Form7.ibDataSet2ENDERE.AsString  + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet2CEP.AsString+' - '+Form7.ibDataSet2CIDADE.AsString+', '+Form7.ibDataSet2ESTADO.AsString + Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy(Form7.ibDataSet2COMPLE.AsString +  Replicate(' ',45),1,45));
    FlsImpressao.Add(Copy('Telefone: '+Form7.ibDataSet2FONE.AsString + Replicate(' ',45),1,45));

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add('Número da OS: '+ Form7.ibDataSet3NUMERO.AsString);
    FlsImpressao.Add('Data da entrada: '+Form7.ibDataSet3DATA.AsString+' '+Form7.ibDataSet3HORA.AsString);
    FlsImpressao.Add('Situação: '+Form7.ibDataSet3SITUACAO.AsString);
    FlsImpressao.Add('Atendente: '+Form7.ibDataSet3TECNICO.AsString);

    FlsImpressao.Add('-----------------------------------------------');
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label14.Caption+': '+Form7.ibDataSet3DESCRICAO.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label15.Caption+': '+Form7.ibDataSet3IDENTIFI1.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label16.Caption+': '+Form7.ibDataSet3IDENTIFI2.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label17.Caption+': '+Form7.ibDataSet3IDENTIFI3.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label18.Caption+': '+Form7.ibDataSet3IDENTIFI4.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label30.Caption+': '+Form7.ibDataSet3GARANTIA.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha(Form30.Label19.Caption+': '+Form7.ibDataSet3PROBLEMA.AsString,'',47));
    FlsImpressao.Add(DescricaoComQuebraLinha('Observação: '+Form7.ibDataSet3OBSERVACAO.AsString,'',47));
    if Trim(ObsRecibo) <> '' then
      FlsImpressao.Add(DescricaoComQuebraLinha(ObsRecibo,'',47));
    FlsImpressao.Add('');
    FlsImpressao.Add('');
    FlsImpressao.Add('');
    FlsImpressao.Add('_______________________________________________');
    FlsImpressao.Add('            Assinatura do atendente            ');
    FlsImpressao.Add('');
    FlsImpressao.Add('');

    Result := FlsImpressao.Text;

  finally
    FreeAndNil(FlsImpressao);
  end;
end;


end.
