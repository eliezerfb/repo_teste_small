unit uVisualizaCadastro;

interface

uses
  SysUtils
  , Controls
  , Forms
  , smallfunc_xe
  , DB
  , IBCustomDataSet
  , IBQuery
  ;

  procedure GeraVisualizacaoFichaCadastro;

implementation

uses
  Unit7
  , Mais3
//  , Unit10
  , Unit38
  , Mais
  , uFuncoesBancoDados
  , uFuncoesRetaguarda
  ;

procedure GeraVisualizacaoFichaCadastro;
var
  F: TextFile;
  I, J: Integer;
  sA : sTring;
  fTotal1, fTotal, vQtdInicial : Double;
  dInicio, dFinal : TdateTime;
  vGrade    : array [0..19,0..19] of String; // Cria uma matriz com 100 elementos
  vCompra   : array [0..19,0..19] of String; // Cria uma matriz com 100 elementos
  bChave    : Boolean;
  iCamposVisualizar: Integer;
  vDescricaoProduto : string;

  IBQProdutoComp: TIBQuery; // Mauricio Parizotto 2023-08-07
  sNumeroNF: String; // Sandro Silva 2023-09-26  
begin
  // Não exporta se o cliente estiver em branco
  if (Form7.sModulo = 'ESTOQUE') and (AllTrim(Form7.ibDataSet4DESCRICAO.AsString) = '') then Abort;
  if (Form7.sModulo = 'CLIENTES') and (AllTrim(Form7.ibDataSet2NOME.AsString) = '') then Abort;
  if (Form7.sModulo = 'FORNECED') and (AllTrim(Form7.ibDataSet2NOME.AsString) = '') then Abort;
 
  Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
 
  try
    if (Form7.sModulo = 'PAGAR') then
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet8NOME.AsString)+' ');  //
      Form7.ibDataSet2.Open;
    end;
    
    if (Form7.sModulo = 'RECEBER') then
    begin
      Form7.ibDataSet2.Close;
      Form7.ibDataSet2.Selectsql.Clear;
      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet7NOME.AsString)+' ');  //
      Form7.ibDataSet2.Open;
    end;
    
    if Form7.ArquivoAberto.Modified then
    begin
      Form7.ArquivoAberto.Edit;
      Form7.ArquivoAberto.Post;
      Form7.ArquivoAberto.Edit;
    end;
    
    //Form7.iFoco := 0;

    Form7.ArquivoAberto.DisableControls;
    Form7.ibDataSet27.DisableControls;
    Form7.ibDataSet26.DisableControls;
    Form7.ibDataSet24.DisableControls;

    //LogRetaguarda('ibDataSet24.DisableControls; 83'); // Sandro Silva 2023-11-27

    Form7.ibDataSet23.DisableControls;
    //LogRetaguarda('uvisualizacadastro ibDataSet23.DisableControls 86'); // Sandro Silva 2023-12-04
    Form7.ibDataSet28.DisableControls;
    Form7.ibDataSet16.DisableControls;
    Form7.ibDataSet15.DisableControls;
    Form7.ibDataSet10.DisableControls;
    Form7.ibDataSet1.DisableControls;
    Form7.ibDataSet8.DisableControls;
    Form7.ibDataSet7.DisableControls;
 
    CriaJpg('logotip.jpg');
 
    Deletefile(pChar(Senhas.UsuarioPub+'.HTM'));
 
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  // Direciona o arquivo F para EXPORTA.TXT
    Rewrite(F);
    Writeln(F,'<html><head><title>'+AllTrim(Form7.ibDataSet13NOME.AsString) + ' - '+Form7.sModulo+'</title></head>');
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font face="Microsoft Sans Serif" size=2><b>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString))+'</b></font>');
    WriteLn(F,'<br><font face="Microsoft Sans Serif" size=2><b>'+AnsiUpperCase(Form7.Caption)+'</b></font>');
    //    WriteLn(F,'<table border=0 cellpadding=10 cellspacing=0><tr><td>');
    WriteLn(F,'<table border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4>');
    WriteLn(F,' <tr>');
    WriteLn(F,'  <td>');
    
    // Exportar
    if {(Form10.Visible) or} (DateToStr(Form38.DateTimePicker1.Date) = '31/12/1899') then
    begin
      dInicio := StrToDate('31/12/1899');
      dFinal  := StrToDate('30/12/2899');
    end else
    begin
      dInicio :=  Form38.DateTimePicker1.Date;
      dFinal  :=  Form38.DateTimePicker2.Date;
      dInicio := StrToDate(DateToStr(dInicio));
      dFinal  := StrToDate(DateToStr(dFinal ));
    end;

    if (Form7.sModulo = 'KARDEX') then
      Form7.IBDataSet4.First;

    bChave := True;

    while bChave do
    begin
      Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
 
      if (Form7.sModulo <> 'KARDEX') then
      begin
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');

        {Sandro Silva 2023-07-03 inicio} 
        iCamposVisualizar := Form7.iCampos;
        {
        if Form7.sModulo = 'ICM' then
          iCamposVisualizar := 46; // Não dá para usar Form7.iCampos porque está definido 5 campos, aumentar pode afetar em outras rotinas. Altera aqui para ficar isolado
        Mauricio Parizotto 2023-12-11}
        {Sandro Silva 2023-07-03 fim}
        for I := 1 to iCamposVisualizar do // Sandro Silva 2023-07-03 for I := 1 to Form7.iCampos do
        begin
          if AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel) <> '...' then
          begin
            if (UpperCase(AllTrim(Form7.TabelaAberta.Fields[I-1].Name)) <> 'IBDATASET2CONTATOS') then
            begin
              if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4QTD_ATUAL') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4QTD_MINIM') then
              begin
                sA := Format('%10.'+Form1.ConfCasas+'n',[Form7.TabelaAberta.Fields[I-1].AsFloat]);
              end else
              begin
                if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4PRECO') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4CUSTOCOMPR') or (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4CUSTOMEDIO') then
                begin
                  sA := Format('%10.'+Form1.ConfPreco+'n',[Form7.TabelaAberta.Fields[I-1].AsFloat])
                end else
                begin
                  if (Form7.TabelaAberta.Fields[I-1].Name = 'ibDataSet4INDEXADOR') then
                  begin
                    sA := Format('%10.4n',[Form7.TabelaAberta.Fields[I-1].AsFloat])
                  end else
                  begin
                    case Form7.TabelaAberta.Fields[I-1].DataType of
                      ftString:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                      //Mauricio Parizotto 2023-07-26 Migração Alexandria
                      ftWideString:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                      ftFloat, ftBCD:
                        sA := Format('%10.2n',[Form7.TabelaAberta.Fields[I-1].AsFloat]);
                      ftDatetime, ftDate:
                        sA := Form7.TabelaAberta.Fields[I-1].AsSTring;
                    else
                      sA := '';
                    end;
                    {Sandro Silva 2023-07-04 fim}
                  end;
                end;
              end;
              
              WriteLn(F,' <tr>');
              Writeln(F,'  <td width=120 align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.TabelaAberta.Fields[I-1].DisplayLabel)+':</td>');
              Writeln(F,'  <td width=300 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+sA+'</td>');
              Writeln(F,' </tr>');
            end;
          end;
        end;
      end;
      
      if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') then
      begin
        WriteLn(F,' <tr>');
        Writeln(F,'  <td width=120 align=Right valign=top bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Contatos:</td>');
        Writeln(F,'  <td width=300 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>');
        Writeln(F,StrTran(Form7.ibDataSet2CONTATOS.AsString,Char(10),'<br>')+'<br>');
        Writeln(F,'  </td>');
        Writeln(F,' </tr>');
      end;
      
      Writeln(F,'</table><p><p>');
      
      if Form7.sModulo = 'RECEBER' then
      begin
        if not ((Form7.sModulo = 'RECEBER')  and (AllTrim(Form7.ibDataSet7NOME.AsString) = '')) then
        begin
          WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
          for I := 1 to 23 do
          begin
            if Form7.ibDataSet2.Fields[I-1].DataType = ftString   then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            //Mauricio Parizotto 2023-07-26 Migração Alexandria
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftWideString then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else if TipoCampoFloat(Form7.ibDataSet2.Fields[I-1]) then // Sandro Silva 2024-04-29 else if Form7.ibDataSet2.Fields[I-1].DataType = ftFloat then
              sA := Format('%10.2n',[Form7.ibDataSet2.Fields[I-1].AsFloat])
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftDatetime then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else if Form7.ibDataSet2.Fields[I-1].DataType = ftDate then
              sA := Form7.ibDataSet2.Fields[I-1].AsSTring
            else
              sA := '';
            
            WriteLn(F,' <tr>');
            Writeln(F,'  <td width=150 align=Right bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.ibDataSet2.Fields[I-1].DisplayLabel)+':</td>');
            Writeln(F,'  <td width=450 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+sA+'</td>');
            Writeln(F,' </tr><p>');
          end;
          WriteLn(F,'</table>');
        end;
      end;

      if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR') then
      begin
        if (Form7.sModulo = 'RECEBER') then
        begin
          Form7.ibDataSet2.Close;
          Form7.ibDataSet2.Selectsql.Clear;
          Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(form7.ibDataSet7NOME.AsString)+' ');  //
          Form7.ibDataSet2.Open;
        end;
        
        if not ((Form7.sModulo = 'RECEBER') and (Form7.sModulo = 'PAGAR') and (AllTrim(Form7.ibDataSet7NOME.AsString) = '')) then
        begin
          fTotal := 0;
          
          // HISTÓRICO DAS VENDAS
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSQL.Clear;
          Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMITIDA=''S'' order by EMISSAO, REGISTRO');
          Form7.ibDataSet15.Open;
          
          if not Form7.ibDataSet15.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DAS VENDAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            while not (Form7.ibDataSet15.EOF) do
            begin
              if (Form7.ibDataSet15EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet15EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet16.Close;
                Form7.ibDataSet16.SelectSQL.Clear;
                Form7.ibDataSet16.SelectSQL.Add('select * from ITENS001 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'  and coalesce(QUANTIDADE,0) = coalesce(SINCRONIA,0)');
                Form7.ibDataSet16.Open;
                Form7.ibDataSet16.First;
                
                while not (Form7.ibDataSet16.EOF) do
                begin
                  if Form7.ibDataSet16QUANTIDADE.AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet15NUMERONF.AsString,10,3)+'</td>'+  // Doc
                            //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet16QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>'); // Valor
                    WriteLn(F,' </tr>');
                    fTotal := fTotal + Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat;
                  end else
                  begin
                    // Descrição no corpo da NF
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Data
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Doc
                            //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
                            '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>'+  // Descricao
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                            '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
                    WriteLn(F,' </tr>');
                  end;
                  Form7.ibDataSet16.Next;
                end;
              end;
              Form7.ibDataSet15.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // HISTÓRICO DOS SERVICOS          
          Form7.ibDataSet15.Close;
          Form7.ibDataSet15.SelectSQL.Clear;
          Form7.ibDataSet15.SelectSQL.Add('select * from VENDAS where CLIENTE='+QuotedStr(Form7.ibDataSet2NOME.AsString)+' and EMITIDA=''S'' ORDER BY EMISSAO, REGISTRO');
          Form7.ibDataSet15.Open;
          
          if not Form7.ibDataSet15.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DOS SERVIÇOS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>NF</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>OS</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
            WriteLn(F,' </tr>');
            
            fTotal := 0;
            
            while not (Form7.ibDataSet15.EOF) do
            begin
              if (Form7.ibDataSet15EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet15EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet35.Close;
                Form7.ibDataSet35.SelectSQL.Clear;
                Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMERONF='+QuotedStr(Form7.ibDataSet15NUMERONF.AsString)+'');
                Form7.ibDataSet35.Open;
                Form7.ibDataSet35.First;

                {Sandro Silva 2023-09-26 inicio}
                sNumeroNF := '';
                if Form7.ibDataSet15.FieldByName('MODELO').AsString = 'SV' then
                    sNumeroNF := Form7.ibDAtaSet15.FieldByName('NFEPROTOCOLO').AsString;
                if Trim(sNumeroNF) = '' then
                  sNumeroNF := Form7.ibDataSet15.FieldByName('NUMERONF').AsString;
                {Sandro Silva 2023-09-26 fim}
                while not (Form7.ibDataSet35.EOF) do
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet15EMISSAO.AsDateTime)      +'</td>'+  // Data
                          // Sandro Silva 2023-09-26 '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+ ifThen(Form7.ibDataSet15.FieldByName('MODELO').AsString = 'SV', ifThen(Form7.ibDAtaSet15.FieldByName('NFEPROTOCOLO').AsString <> '', Form7.ibDAtaSet15.FieldByName('NFEPROTOCOLO').AsString, Form7.ibDataSet15.FieldByName('NUMERONF').AsString), Form7.ibDataSet15.FieldByName('NUMERONF').AsString)+'</td>'+  // Doc    // Sandro Silva 2023-09-26 '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDAtaSet15NFEPROTOCOLO.AsString+'</td>'+  // Doc
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+ sNumeroNF +'</td>'+  // Doc    // Sandro Silva 2023-09-26 '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDAtaSet15NFEPROTOCOLO.AsString+'</td>'+  // Doc
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Copy(Form7.ibDataSet35NUMEROOS.AsString,1,10) + Replicate(' ', 10),1,10)    +'</td>'+  // Doc  // Sandro Silva 2023-09-26 '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Copy(Form7.ibDataSet35NUMEROOS.AsString,1,10)+Replicate(' ',8),1,8)    +'</td>'+  // Doc
                          //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'</td>'+  // Descricao
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35TOTAL.AsFloat])+'</td>'); // Valor
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + Form7.ibDataSet35TOTAL.AsFloat;
                  Form7.ibDataSet35.Next;
                end;
              end;
              Form7.ibDataSet15.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // vendas no balcão
          Form7.ibDataSet27.Close;
          Form7.ibDataSet27.SelectSQL.Clear;
          Form7.ibDataSet27.SelectSQL.Add('select * from ALTERACA where (CLIFOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet27.SelectSQL.Add('and (DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') and (DATA>='+QuotedStr(DateToStrInvertida(dInicio))+')');
          Form7.ibDataSet27.SelectSQL.Add('and ((TIPO='+QuotedStr('BALCAO')+') or (TIPO='+QuotedStr('VENDA')+'))');
          Form7.ibDataSet27.SelectSQL.Add('ORDER BY DATA, PEDIDO');
          Form7.ibDataSet27.Open;
          
          if not Form7.ibDataSet27.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>VENDAS NO BALCÃO</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');

            fTotal := 0;

            while not Form7.ibDataSet27.EOF do
            begin
              WriteLn(F,' <tr>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet27DATA.AsDateTime)+'</td>');  // Data
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27PEDIDO.AsString+'</td>'); // Doc
              //Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet27DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao Mauricio Parizotto 2023-12-19
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet27DESCRICAO.AsString+'</td>'); // Descricao
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Quantidade
              Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet27UNITARIO.AsFloat* Form7.ibDataSet27QUANTIDADE.AsFloat])+'</td>'); // Valor
              WriteLn(F,' </tr>');
              fTotal := fTotal + Form7.ibDataSet27UNITARIO.AsFloat * Form7.ibDataSet27QUANTIDADE.AsFloat;
              
              Form7.ibDataSet27.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;

          // Orçamentos
          Form7.ibDataSet37.Close;
          Form7.ibDataSet37.SelectSQL.Clear;
          Form7.ibDataSet37.SelectSQL.Add('select * from ORCAMENT where (CLIFOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet37.SelectSQL.Add('and (DATA<='+QuotedStr(DateToStrInvertida(dFinal))+') and (DATA>='+QuotedStr(DateToStrInvertida(dInicio))+') and (coalesce(VALORICM,0)=0)');
          Form7.ibDataSet37.Open;
          
          if not Form7.ibDataSet37.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>ORÇAMENTOS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Orçamento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            fTotal := 0;
                        
            while not Form7.ibDataSet37.EOF do
            begin
              if Form7.ibDataSet37QUANTIDADE.AsFloat <> 0 then
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet37DATA.AsDateTime)+'</td>');  // Data
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37PEDIDO.AsString+'</td>'); // Doc
                //Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet37DESCRICAO.AsString+Replicate(' ',40),1,40)+'</td>'); // Descricao Mauricio Parizotto 2023-12-19
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37DESCRICAO.AsString+'</td>'); // Descricao
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet37QUANTIDADE.AsFloat])+'</td>'); // Quantidade
                Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet37UNITARIO.AsFloat* Form7.ibDataSet37QUANTIDADE.AsFloat])+'</td>'); // Valor
                WriteLn(F,' </tr>');
                fTotal := fTotal + Form7.ibDataSet37UNITARIO.AsFloat * Form7.ibDataSet37QUANTIDADE.AsFloat;
              end else
              begin
                WriteLn(F,' <tr>');
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet37DATA.AsDateTime)+'</td>');  // Data
                Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37PEDIDO.AsString+'</td>'); // Doc
                Writeln(F,'  <td  '+{nowrap}' colspan=3 bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet37DESCRICAO.AsString+'</td>'); // Descricao
                WriteLn(F,' </tr>');
              end;
              
              Form7.ibDataSet37.Next;              
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // CONTAS A RECEBER
          if not (Form1.iReduzida = 1) then
          begin
            if Form1.imgContaReceber.Visible then
            begin
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              Form7.ibDataSet99.SelectSQL.Add('select * from RECEBER where (NOME='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
              Form7.ibDataSet99.SelectSQL.Add('and (coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'') and (coalesce(ATIVO,9)<>1)');
              Form7.ibDataSet99.SelectSQL.Add('ORDER BY VENCIMENTO, DOCUMENTO');
              Form7.ibDataSet99.Open;
              
              if not Form7.ibDataSet99.Eof then
              begin
                // Contas a receber esta liberada
                fTotal  := 0;
                fTotal1 := 0;
                
                Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>CONTAS A RECEBER</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor Atual</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                
                while not Form7.ibDataSet99.Eof do
                begin
                  if Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat = 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_DUPL').AsFloat])+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_JURO').AsFloat])+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByName('VALOR_DUPL').AsFloat;
                    fTotal1 := fTotal1 + Form7.ibDataSet99.FieldByName('VALOR_JURO').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // Totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal1])+'</td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
                fTotal  := 0;
                
                // CONTAS JA RECEBIDAS
                Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>CONTAS JÁ RECEBIDAS</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor recebido</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Recebido em</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not Form7.ibDataSet99.Eof do
                begin
                  if Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet99.FieldByName('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat])+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByName('RECEBIMENT').AsDateTime)+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByName('VALOR_RECE').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // Totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
              end;
            end;
          end;
          
          // COMPRAS
          fTotal := 0;
          
          // HISTÓRICO DAS COMPRAS
          Form7.ibDataSet24.Close;
          Form7.ibDataSet24.SelectSQL.Clear;
          Form7.ibDataSet24.SelectSQL.Add('select * from COMPRAS where (FORNECEDOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
          Form7.ibDataSet24.Open;
          
          if not Form7.ibDataSet24.Eof then
          begin
            Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>HISTÓRICO DAS COMPRAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
            WriteLn(F,' </tr>');
            
            while not (Form7.ibDataSet24.EOF) do
            begin
              if (Form7.ibDataSet24EMISSAO.AsDateTime <= dFinal) and (Form7.ibDataSet24EMISSAO.AsDateTime >= dInicio) then
              begin
                Form7.ibDataSet23.Close;
                Form7.ibDataSet23.SelectSQL.Clear;
                Form7.ibDataSet23.SelectSQL.Add('select * from ITENS002 where NUMERONF='+QuotedStr(Form7.ibDataSet24NUMERONF.AsString)+' and FORNECEDOR='+QuotedStr(Form7.ibDataSet2NOME.AsString)+'');
                Form7.ibDataSet23.Open;
                Form7.ibDataSet23.First;
                
                while not (Form7.ibDataSet23.EOF) do
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.ibDataSet24EMISSAO.AsDateTime)      +'</td>'+  // Data
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9)+'/'+Copy(Form7.ibDataSet24NUMERONF.AsString,10,3)+'</td>'+  // Doc
                          //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
                          '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet23DESCRICAO.AsString+'</td>'+  // Descricao
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n',[Form7.ibDataSet23QUANTIDADE.AsFloat])            +'</td>'+  // Quantidade
                          '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat])+'</td>'); // Valor
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat;
                  Form7.ibDataSet23.Next;
                end;
              end;
              Form7.ibDataSet24.Next;
            end;
            
            // totalizador
            WriteLn(F,' <tr>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
            WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
            WriteLn(F,'</table>');
          end;
          
          // Contas a Pagar
          if not (Form1.iReduzida = 1) then
          begin
            if Form1.imgContaPagar.Visible then
            begin
              // Contas a pagar esta liberada
              Form7.ibDataSet99.Close;
              Form7.ibDataSet99.SelectSQL.Clear;
              Form7.ibDataSet99.SelectSQL.Add('select * from PAGAR where (NOME='+QuotedStr(Form7.ibDataSet2NOME.AsString)+')');
              Form7.ibDataSet99.SelectSQL.Add('ORDER BY VENCIMENTO, DOCUMENTO');
              Form7.ibDataSet99.Open;
              
              if not Form7.IBDataSet99.Eof then
              begin
                fTotal := 0;
                Writeln(F,'<p><font face="Verdana" size=2><b>CONTAS A PAGAR</b>');
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Valor</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not (Form7.ibDataSet99.Eof) do
                begin
                  if Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat = 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByName('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat])+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
                
                // contas Pagas          
                fTotal := 0;
                Writeln(F,'<p><font face="Verdana" size=2><b>CONTAS PAGAS</b>');          
                WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Documento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Histórico</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Vencimento</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Valor pago</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Verdana" size=1>Pago em</td>');
                WriteLn(F,' </tr>');
                
                Form7.ibDataSet99.First;
                while not (Form7.ibDataSet99.Eof) do
                begin
                  if Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat <> 0 then
                  begin
                    WriteLn(F,' <tr>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('DOCUMENTO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Form7.ibDataSet99.FieldByname('HISTORICO').AsString+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('VENCIMENTO').AsDateTime)+'</td>');
                    Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+Format('%10.2n',[Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat])+'</td>');
                    Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Verdana" size=1>'+DateTimeToStr(Form7.ibDataSet99.FieldByname('PAGAMENTO').AsDateTime)+'</td>');
                    WriteLn(F,' </tr>');
                    fTotal  := fTotal  + Form7.ibDataSet99.FieldByname('VALOR_PAGO').AsFloat;
                  end;
                  Form7.ibDataSet99.Next;
                end;
                
                // totalizador
                WriteLn(F,' <tr>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
                WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
                WriteLn(F,' </tr>');
                WriteLn(F,'</table>');
              end;
            end;
          end;
        end;
      end;

      if ((Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'KARDEX')) and (Form7.ibDataSet4DESCRICAO.AsString <> '') then
      begin
        vDescricaoProduto := Form7.ibDataSet4DESCRICAO.AsString; //Mauricio Parizotto 2023-08-22

        if Form7.sModulo <> 'KARDEX' then
        begin
          //vDescricaoProduto := Form7.ibDataSet4DESCRICAO.AsString; //Mauricio Parizotto 2023-08-04

          Form7.ibDataSet10.Close;
          Form7.ibDataSet10.SelectSQL.Clear;
          Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+
                                          ' order by CODIGO, COR, TAMANHO');
          Form7.ibDataSet10.Open;
          Form7.ibDataSet10.First;

          
          if Form7.ibDataSet4CODIGO.AsString = Form7.ibDataSet10CODIGO.AsString then
          begin
            for I := 0 to 19 do for J := 0 to 19 do vGrade[I,J] := '';
            for I := 0 to 19 do for J := 0 to 19 do vCompra[I,J] := '';
            
            while (Form7.ibDataSet10CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString) and not (Form7.ibDataSet10.EOF) do
            begin
              if AllTrim(Form7.ibDataSet10QTD.AsString) <> '' then
              begin
                if StrToInt(Form7.ibDataSet10COR.AsString) + strtoInt(Form7.ibDataSet10TAMANHO.AsString) <> 0 then
                begin
                  vGrade[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10QTD.AsString;
                  vCompra[StrToInt(Form7.ibDataSet10COR.AsString),strtoInt(Form7.ibDataSet10TAMANHO.AsString)] := Form7.ibDataSet10ENTRADAS.AsString;
                end;
              end;
              Form7.ibDataSet10.Next;
            end;
            
            WriteLn(F,'  </td><td vAlign=TOP>');
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE DAS ENTRADAS</b>');
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vCompra[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </table>');
            
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE DAS SAÍDAS</b>');
                
            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vCompra[I,J])) - StrToFloat(LimpaNumeroDeixandoAVirgula(vGrade[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </table>');
            
            Writeln(F,'   <p><font face="Microsoft Sans Serif" size=2><b>GRADE EM ESTOQUE</b>');

            WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            for J := 0 to 19 do
            begin
              for I := 0 to 19 do
              begin
                if (I=0) and (J=0) then WriteLn(F,'   <tr><td bgcolor=#'+Form1.sHtmlCor+' align=Right></td>');
                if vGrade[I,J] <> '' then
                begin
                  if I = 0 then WriteLn(F,'   </tr><tr>');
                  if (I = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>') else
                     if (J = 0) then WriteLn(F,'    <td bgcolor=#'+Form1.sHtmlCor+' align=center width=70><font face="Microsoft Sans Serif" size=1>'+vGrade[I,J]+'</td>')
                   else WriteLn(F,'    <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Abs(StrToFloat(LimpaNumeroDeixandoAVirgula(vGrade[I,J])))])+'</td>');
                end;
              end;
            end;
            
            WriteLn(F,'   </tr></table></td>');
            WriteLn(F,'    </tr>');
            WriteLn(F,'   </table></td>');
          end;


          try
            IBQProdutoComp := Form7.CriaIBQuery(Form7.ibDataSet4.Transaction);
            IBQProdutoComp.Close;
            IBQProdutoComp.SQL.Text := ' Select'+
                                       '   C.DESCRICAO,'+
                                       '   C.QUANTIDADE,'+
                                       '   E.CODIGO,'+
                                       '   E.CUSTOCOMPR'+
                                       ' From COMPOSTO C'+
                                       '   Left Join ESTOQUE E on E.DESCRICAO = C.DESCRICAO'+
                                       ' Where C.CODIGO = '+QuotedStr(Form7.ibDataSet4CODIGO.AsString);
            IBQProdutoComp.Open;
          
            //if Form7.ibDataSet28CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            if not IBQProdutoComp.IsEmpty then
            begin
              Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>COMPOSIÇÃO DO PRODUTO</b>');
              WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
            
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Código</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Custo</td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Custo X Qtd</td>');
              WriteLn(F,' </tr>');

              fTotal := 0;
            
              IBQProdutoComp.First;
              while not IBQProdutoComp.Eof do
              begin
                if not IBQProdutoComp.IsEmpty then
                begin
                  WriteLn(F,' <tr>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+IBQProdutoComp.FieldByName('CODIGO').Asstring +'</td>');
                  Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+IBQProdutoComp.FieldByName('DESCRICAO').AsString+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat])+'</td>');
                  Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat * IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat])+'</td>');
                  WriteLn(F,' </tr>');
                  fTotal := fTotal + (IBQProdutoComp.FieldByName('CUSTOCOMPR').AsFloat * IBQProdutoComp.FieldByName('QUANTIDADE').AsFloat);
                end;

                IBQProdutoComp.Next;
              end;

              // Totalizador
              WriteLn(F,' <tr>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
              WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
              WriteLn(F,' </tr>');
              WriteLn(F,'</table>');
            end;

          finally
            FreeAndNil(IBQProdutoComp);
          end;

          {Mauricio Parizotto 2023-08-07 Fim}
          
          // Imprime o arquivo em ordem de data          
          Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>MOVIMENTAÇÃO DO ITEM</b>');
        end else
        begin
          Writeln(F,'<table width=590 border=0 bgcolor=#FFFFFFFF cellspacing=1 cellpadding=4><tr>');
          Writeln(F,'<td><font face="Microsoft Sans Serif" size=2><b>'+Form7.ibDataSet4CODIGO.AsString +' - '+ Form7.ibDataSet4DESCRICAO.AsString +'</b>');
          Writeln(F,'</tr></table>');
        end;
  
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Documento</td>');
        WriteLn(F,'  <td Width=300 bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Valor</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Saldo do Estoque</td>');
        WriteLn(F,' </tr>');

        //Mauricio Parizotto 2023-07-17

        //Calcula quantidade inicial
        try
          vQtdInicial := ExecutaComandoEscalar(Form7.IBDatabase1,
                                               ' Select Coalesce(sum(quantidade),0) '+
                                               //' From ('+SqlSelectMovimentacaoItem(Form7.ibDataSet4DESCRICAO.AsString)+') A'); Mauricio Parizotto 2023-08-04
                                               ' From ('+SqlSelectMovimentacaoItem(vDescricaoProduto)+') A');


          vQtdInicial := Form7.ibDataSet4QTD_ATUAL.AsFloat - vQtdInicial;

          Form7.ibDataSet4.Edit;
          Form7.ibDataSet4QTD_INICIO.AsFloat := vQtdInicial;
          Form7.ibDataSet4.Post;
        except
          vQtdInicial := 0;
        end;

        Form7.IBDataSet97.Close;
        //Form7.IBDataSet97.SelectSQL.Text := SqlSelectMovimentacaoItem(Form7.ibDataSet4DESCRICAO.AsString);  Mauricio Parizotto 2023-08-04
        Form7.IBDataSet97.SelectSQL.Text := SqlSelectMovimentacaoItem(vDescricaoProduto);
        Form7.IBDataSet97.DisableControls;
        Form7.IBDataSet97.Open;


        fTotal := vQtdInicial;

        while not Form7.IBDataSet97.EOF do
        begin
          fTotal := fTotal + Form7.IBDataSet97.FieldByName('QUANTIDADE').AsFloat;
          if Form7.IBDataSet97.FieldByName('HISTORICO').AsString <> 'Quantidade inicial' then
          begin
            WriteLn(F,' <tr>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateTimeToStr(Form7.IBDataSet97.FieldByName('DATA').AsDateTime)+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.IBDataSet97.FieldByname('DOCUMENTO').AsString,1,9)+'/'+Copy(Form7.IBDataSet97.FieldByname('DOCUMENTO').AsString,10,3)+'</td>');
            Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.IBDataSet97.FieldByName('HISTORICO').AsString+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.IBDataSet97.FieldByName('VALOR').AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[Form7.IBDataSet97.FieldByName('QUANTIDADE').AsFloat])+'</td>');
            Writeln(F,'  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[fTotal])+'</td>');
            WriteLn(F,' </tr>');
          end;
          Form7.IBDataSet97.Next;
        end;

        // Totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfCasas+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');


        Form7.IBDataSet97.EnableControls;
      end;

      // Fecha o arquivo
      if Form7.sModulo = 'CONTAS' then
      begin
        Screen.Cursor             := crHourGlass;              // Cursor de Aguardo
        Writeln(F,Form7.ibDataSet12NOME.AsString);
        if Form7.dbGrid1.SelectedField.FieldName = 'CONTA' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'NOME' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'SALDO' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TODOS OS LANÇAMENTOS NA CONTA</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'DIA' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO DIA '+DateToStr(Form38.MonthCalendar1.Date)+'</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'MES' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO MÊS '+IntToStr(Month(Form38.MonthCalendar1.Date))+'/'+IntToStr(Year(Form38.MonthCalendar1.Date))+'</b>');
        if Form7.dbGrid1.SelectedField.FieldName = 'ANO' then Writeln(F,'<p><font face="Microsoft Sans Serif" size=2><b>TOTAL DO ANO DE '+IntToStr(Year(Form38.MonthCalendar1.Date))+'</b>');

        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Data</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Histórico</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Entrada</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Saída</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet1.First;
        
        fTotal  := 0; fTotal1 := 0;
        
        while not Form7.ibDataSet1.EOF do
        begin
          if Form7.ibDataSet12NOME.AsString = Form7.ibDataSet1NOME.AsString then
          begin
            if
            (((Form7.dbGrid1.SelectedField.FieldName = 'DIA') and (Form7.ibDataSet1DATA.AsDateTime = Form38.MonthCalendar1.Date)))
            or
            (((Form7.dbGrid1.SelectedField.FieldName = 'MES') and (Month(Form7.ibDataSet1DATA.AsDateTime) = Month(Form38.MonthCalendar1.Date)))
                   and (Year(Form7.ibDataSet1DATA.AsDateTime) = Year(Date)))
            or
            (((Form7.dbGrid1.SelectedField.FieldName = 'ANO') and (Year(Form7.ibDataSet1DATA.AsDateTime) = Year(Form38.MonthCalendar1.Date))))
            or
            (Form7.dbGrid1.SelectedField.FieldName = 'CONTA')
            or
            (Form7.dbGrid1.SelectedField.FieldName = 'NOME') then
            begin
              WriteLn(F,' <tr>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+DateToStr(Form7.ibDataSet1DATA.AsDateTime)+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+AllTrim(Form7.ibDataSet1HISTORICO.AsString)+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[Form7.ibDataSet1ENTRADA.AsFloat])+'</td>');
              Writeln(F,'  <td bgcolor=#FFFFFFFF align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[Form7.ibDataSet1SAIDA.AsFloat])+'</td>');
              WriteLn(F,' </tr>');
              fTotal  := fTotal + Form7.ibDataSet1ENTRADA.AsFloat;
              fTotal1 := fTotal1 + Form7.ibDataSet1SAIDA.AsFloat;
            end;
          end;
          
          Form7.ibDataSet1.Next;
        end;
        
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal])+'</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Microsoft Sans Serif" size=1>'+Format('%12.2n',[fTotal1])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
        
        Screen.Cursor := crDefault; // Cursor normal
        Form7.sModulo := 'CONTAS';
        Form7.DBGrid1.Repaint;
      end;
      
      if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'OS') then
      begin
        fTotal := 0;
        
        // Descrição dos itens
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos itens</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Unitário</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet16.First;
        
        while not (Form7.ibDataSet16.EOF) do
        begin
          if Form7.ibDataSet16QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+ Mauricio Parizotto 2023-12-19
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet16QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat]  ) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet16UNITARIO.AsFloat * Form7.ibDataSet16QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            //Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet16DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet16DESCRICAO.AsString+'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          Form7.ibDataSet16.Next;
        end;
        
        // totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table><br>');
        
        fTotal := 0;
        
        // Descrição dos serviços
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos serviços</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>'+ Form7.ibDataSet35TECNICO.DisplayLabel +'</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet35.First;
        
        while not (Form7.ibDataSet35.EOF) do
        begin
          if Form7.ibDataSet35QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+ // Mauricio Parizotto 2023-12-19
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'</td>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35TECNICO.AsString+Replicate(' ',20),1,20)                       +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet35QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet35UNITARIO.AsFloat * Form7.ibDataSet35QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet35UNITARIO.AsFloat * Form7.ibDataSet35QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            //Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet35DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet35DESCRICAO.AsString+'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          
          Form7.ibDataSet35.Next;
        end;
        
        // totalizador
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table>');
      end;
      
      if (Form7.sModulo = 'COMPRA') then
      begin
        fTotal := 0;
        
        // Descrição dos itens
        WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Código</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Descrição dos itens</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Quantidade</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Unitário</td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'><font face="Microsoft Sans Serif" size=1>Total</td>');
        WriteLn(F,' </tr>');
        
        Form7.ibDataSet23.First;
        
        while not (Form7.ibDataSet23.EOF) do
        begin
          if Form7.ibDataSet23QUANTIDADE.AsFloat <> 0 then
          begin
            WriteLn(F,' <tr>'+
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>' + Form7.ibDataSet23CODIGO.AsString + '</td>'+
                    //'  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35)                     +'</td>'+ Mauricio Parizotto 2023-12-19
                    '  <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet23DESCRICAO.AsString+'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%8.'+Form1.ConfCasas+'n', [Form7.ibDataSet23QUANTIDADE.AsFloat]) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat]  ) +'</td>'+
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat])+'</td>');
            WriteLn(F,' </tr>');
            fTotal := fTotal + Form7.ibDataSet23UNITARIO.AsFloat * Form7.ibDataSet23QUANTIDADE.AsFloat;
          end else
          begin
            // Descrição no corpo da NF
            WriteLn(F,' <tr>');
            //Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Copy(Form7.ibDataSet23DESCRICAO.AsString+Replicate(' ',35),1,35) +'</td>'+  // Descricao Mauricio Parizotto 2023-12-19
            Writeln(F,' <td bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1>'+Form7.ibDataSet23DESCRICAO.AsString+'</td>'+  // Descricao
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'+  // Quantidade
                    '  <td align=Right bgcolor=#FFFFFFFF><font face="Microsoft Sans Serif" size=1></td>'); // Valor
            WriteLn(F,' </tr>');
          end;
          Form7.ibDataSet23.Next;
        end;

        // totalizador        
        WriteLn(F,' <tr>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+'></td>');
        WriteLn(F,'  <td bgcolor=#'+Form1.sHtmlCor+' align=Right><font face="Verdana" size=1>'+Format('%12.'+Form1.ConfPreco+'n',[fTotal])+'</td>');
        WriteLn(F,' </tr>');
        WriteLn(F,'</table><br>');
      end;
      
      if (Form7.sModulo = 'KARDEX') then
      begin
        Form7.IBDataSet4.Next;
        if Form7.ibDataSet4.Eof then bChave := False;
      end else
      begin
        bChave := False;
      end;
    end;
    
    if dInicio <> StrToDate('31/12/1899') then if (Form7.sModulo <> 'ESTOQUE') and (Form7.sModulo <> 'KARDEX') then Writeln(F,'<center><font face="Microsoft Sans Serif" size=1><br>Período analisado, de ' + DateTimeToStr(dInicio) + ' até ' + DateTimeToStr(dFinal)+'<br></center>');
    WriteLn(F,'</center><center><br><font face="Microsoft Sans Serif" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
    + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
    + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font><br></center>');

    // WWW
    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;

    if not Form1.bPDF then WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');
    WriteLn(F,'</html>');

    CloseFile(F);
  except
    CloseFile(F);
  end;
  
  try
    Form7.ArquivoAberto.EnableControls;
    Form7.ibDataSet4.EnableControls;
    Form7.ibDataSet27.EnableControls;
    Form7.ibDataSet26.EnableControls;
    Form7.ibDataSet24.EnableControls;
    Form7.ibDataSet23.EnableControls;
    Form7.ibDataSet28.EnableControls;
    Form7.ibDataSet16.EnableControls;
    Form7.ibDataSet15.EnableControls;
    Form7.ibDataSet10.EnableControls;
    Form7.ibDataSet1.EnableControls;
    Form7.ibDataSet8.EnableControls;
    Form7.ibDataSet7.EnableControls;
  except 
  end;
  
  if ((Form7.sModulo = 'ESTOQUE') or (Form7.sModulo = 'KARDEX')) then
  begin
    {Mauricio Parizotto 2024-08-06 Inicio * estáva bugando a tela caso aberta
    Form7.sModulo := 'ESTOQUE'; // Mauricio Parizotto 2024-01-25
    Form7.Close;
    Form7.Show;
    }

    if (Form7.sModulo = 'KARDEX') then
    begin
      Form7.sModulo := 'ESTOQUE';
      Form7.Close;
      Form7.Show;
    end;

    Form7.sModulo := 'ESTOQUE';

    {Mauricio Parizotto 2024-08-06 Fim}
    
    try
      Form7.ibDataSet28.Open;
      Form7.ibDataSet4.EnableControls;
    except
    end;
  end;
  
  AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
  
  Screen.Cursor             := crDefault;
end;

end.
