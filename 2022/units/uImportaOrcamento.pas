unit uImportaOrcamento;

interface

uses
  SysUtils
  , StrUtils
  , StdCtrls
  , smallfunc_xe
  , uFuncoesBancoDados
  , Dialogs
  , DB
  , Windows
  , Forms
  , IBQuery
  ;

  procedure ImportaOrcamento(NumeroOrcamento:string; sTipo : String);
  function RetornarOBSOrcamento(AcPedido: String): String;
  function BuscarOBSOrcamento(AcPedido: String): String;
  function Grade(sP1: Real):Boolean;

implementation

uses Unit7
    , Unit12
    , Mais
    , Unit13
    , uDialogs
    , uFuncoesRetaguarda;

procedure ImportaOrcamento(NumeroOrcamento:string; sTipo : String);
var
  iDupl, I, iB : Integer;
  sReg, sEstado : String;
  sRegistro1, sModuloREs, sPortador, sValor, sVencimento : STring;
  ProdComposto : Boolean;
begin
  // N do caixa
  if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset15.Edit;


  // Localiza a operacao
  if AllTrim(Form7.ibDataSet15OPERACAO.AsString) = '' then
  begin
    Form7.ibDataSet14.Append;
    Form7.ibDataSet14.DisableControls;
    Form7.ibDataSet14.Locate('INTEGRACAO','RECEBER',[loCaseInsensitive, loPartialKey]);
    if (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '5'+Copy(Form1.ConfCFOP,2,3)) and (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '6'+Copy(Form1.ConfCFOP,2,3)) then
    begin
      Form7.ibDataSet14.First;
      while (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '5'+copy(Form1.ConfCFOP,2,3)) and (Copy(Form7.ibDataSet14CFOP.AsString,1,4) <> '6'+Copy(Form1.ConfCFOP,2,3)) and
       (not Form7.ibDataSet14.EOF) do Form7.ibDataSet14.Next;
    end;

    Form7.ibDataSet14.EnableControls;
    Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
  end;


  sReg := Form7.ibDataSet14REGISTRO.AsString;

  Form7.ibDataSet37.Close;
  Form7.ibDataSet37.SelectSQL.Text := ' Select * from ORCAMENT'+
                                      ' Where PEDIDO='+QuotedStr(NumeroOrcamento)+
                                      '   and coalesce(NUMERONF,'''') = '''' '+   //Mauricio Parizotto 2023-10-16
                                      ' Order by REGISTRO';
  Form7.ibDataSet37.Open;
  Form7.ibDataSet37.First;

  iDupl     := 0;
  sPortador := '';

  if not (Form7.ibDataSet37.IsEmpty) then
  begin
    while not Form7.ibDataSet37.Eof do
    begin
      //if (Alltrim(Form7.ibDataSet37.FieldByname('NUMERONF').AsString) = '') then Mauricio Parizotto 2023-10-16
      begin
        Form7.IbDataSet37.Edit;
        Form7.IbDataSet37.FieldByname('NUMERONF').AsString := Form7.ibDataSet15NUMERONF.AsString;
        Form7.IbDataSet37.Post;

        if Copy(Form7.IbDataSet37DESCRICAO.AsString,1,3) = '<b>' then
        begin
          sPortador := sPortador + ' ' + Copy(Form7.IbDataSet37DESCRICAO.AsString+'   ',Pos('<b>',Form7.IbDataSet37DESCRICAO.AsString)+3,Pos('</b>',Form7.IbDataSet37DESCRICAO.AsString)-Pos('<b>',Form7.IbDataSet37DESCRICAO.AsString)-3);
        end else
        begin
          if Copy(Form7.IbDataSet37DESCRICAO.AsString,1,3) = '<c>' then
          begin
            sPortador := Copy(Form7.IbDataSet37DESCRICAO.AsString+'   ',Pos('<c>',Form7.IbDataSet37DESCRICAO.AsString)+3,Pos('</c>',Form7.IbDataSet37DESCRICAO.AsString)-Pos('<c>',Form7.IbDataSet37DESCRICAO.AsString)-3);
          end else
          begin
            if Copy(Form7.IbDataSet37DESCRICAO.AsString,1,3) = '<f>' then
            begin
              Form7.ibDataSet15FRETE.AsFloat    := StrToFloat(StrTran(Copy(Form7.IbDataSet37DESCRICAO.AsString+'   ',Pos('<f>',Form7.IbDataSet37DESCRICAO.AsString)+3,Pos('</f>',Form7.IbDataSet37DESCRICAO.AsString)-Pos('<f>',Form7.IbDataSet37DESCRICAO.AsString)-3),'.',','));
              Form7.ibDataSet15FRETE12.AsString := Copy(Form7.IbDataSet37DESCRICAO.AsString+'   ',Pos('<m>',Form7.IbDataSet37DESCRICAO.AsString)+3,Pos('</m>',Form7.IbDataSet37DESCRICAO.AsString)-Pos('<m>',Form7.IbDataSet37DESCRICAO.AsString)-3);

              if Form7.ibDataSet15FRETE12.AsString = '0' then Form12.Edit1.Text := '0-Emitente' else
                if Form7.ibDataSet15FRETE12.AsString = '1' then Form12.Edit1.Text := '1-Destinatário' else
                  if Form7.ibDataSet15FRETE12.AsString = '2' then Form12.Edit1.Text := '2-Terceiros' else
                    if Form7.ibDataSet15FRETE12.AsString = '9' then Form12.Edit1.Text := '9-Sem frete' else Form12.Edit1.Text := '';
            end else
            begin
              if Copy(Form7.IbDataSet37DESCRICAO.AsString,1,3) = '<d>' then
              begin
                sValor      := StrTran(Copy(Form7.IbDataSet37DESCRICAO.AsString+'   ',Pos('<v>',Form7.IbDataSet37DESCRICAO.AsString)+3,Pos('</v>',Form7.IbDataSet37DESCRICAO.AsString)-Pos('<v>',Form7.IbDataSet37DESCRICAO.AsString)-3),'.',',');
                sVencimento := Copy(Form7.IbDataSet37DESCRICAO.AsString,12,2)+'/'+Copy(Form7.IbDataSet37DESCRICAO.AsString,9,2)+'/'+Copy(Form7.IbDataSet37DESCRICAO.AsString,4,4);

                iDupl := iDupl + 1;

                Form7.ibDataSet7.Append;

                Form7.ibDataSet7NUMERONF.AsString     := Form7.ibDataSet15NUMERONF.AsString;
                Form7.ibDataSet7DOCUMENTO.AsString    := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9) + chr(64+iDupl);

                Form7.ibDataSet7VALOR_DUPL.AsFloat    := StrToFloat(sValor);
                Form7.ibDataSet7HISTORICO.AsString    := 'Nota Fiscal: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9);
                Form7.ibDataSet7EMISSAO.asDateTime    := Form7.ibDataSet15EMISSAO.AsDateTime;
                Form7.ibDataSet7NOME.AsString         := Form7.ibDataSet15CLIENTE.AsString;
                Form7.ibDataSet7PORTADOR.AsString     := sPortador;

                Form7.ibDataSet7CONTA.AsString        := Form7.ibDataSet14CONTA.AsString;
                Form7.ibDataSet7VENCIMENTO.AsDateTime := StrToDate(sVencimento); // Data de vencimento

                Form7.ibDataSet15DUPLICATAS.AsFloat   := iDupl;

                Form7.ibDataSet7.Post;
              end else
              begin
                if AllTrim(Form7.IbDataSet37DESCRICAO.AsString) = 'Desconto' then
                begin
                  Form7.ibDataSet15DESCONTO.AsFloat := Form7.ibDataSet37TOTAL.AsFloat;
                end else
                begin
                  Form7.ibDataSet4.Close;
                  Form7.ibDataSet4.Selectsql.Clear;
                  Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(Form7.ibDataSet37DESCRICAO.AsString)+' ');
                  Form7.ibDataSet4.Open;

                  if (Form7.IbDataSet37DESCRICAO.AsString = Form7.ibDataSet4DESCRICAO.AsString)  and (AllTrim(Form7.IbDataSet37DESCRICAO.AsString) <> '') then
                  begin
                    ProdComposto := ProdutoComposto(Form7.ibDataSet4.Transaction,
                                    Form7.ibDataSet4CODIGO.AsString);

                    //if (Form1.ConfNegat = 'Não') and (Form7.ibDataSet4QTD_ATUAL.AsFloat < Form7.IbDataSet37QUANTIDADE.AsFloat) and ((sTipo <> 'BALCAO') and (sTipo <> 'VENDA')) then Mauricio Parizotto 2024-02-05
                    if ((Form1.ConfNegat = 'Não') and (Form7.ibDataSet4QTD_ATUAL.AsFloat < Form7.IbDataSet37QUANTIDADE.AsFloat) and ((sTipo <> 'BALCAO') and (sTipo <> 'VENDA')) and (not ProdComposto)) //Sem composição
                      or ((not Form1.ConfPermitFabricarSemQtd) and (Form7.ibDataSet4QTD_ATUAL.AsFloat < Form7.IbDataSet37QUANTIDADE.AsFloat) and ((sTipo <> 'BALCAO') and (sTipo <> 'VENDA')) and (ProdComposto)) //Com composição
                    then
                    begin
                      MensagemSistema('Não é possível efetuar a venda de '+Form7.IbDataSet37DESCRICAO.AsString+chr(10)
                                      +'só tem ' + Form7.ibDataSet4QTD_ATUAL.AsString + ' no estoque'
                                      ,msgAtencao);
                    end else
                    begin
                      Form7.ibDataSet15COMPLEMENTO.AsString := RetornarOBSOrcamento(Form7.ibDataSet37PEDIDO.AsString);
                      
                      if (AllTrim(Form7.ibDataSet15CLIENTE.AsString) = '') and (AllTrim(Form7.ibDataSet37CLIFOR.AsString) <> '') then
                      begin
                        if AllTrim(Form7.ibDataSet37VENDEDOR.AsString) <> '<Nome do Vendedor>' then Form7.ibDataSet15VENDEDOR.AsString  := Form7.IbDataSet37VENDEDOR.AsString;
                        Form7.ibDataSet15CLIENTE.AsString     := Form7.IbDataSet37CLIFOR.AsString;
                          
                        Form7.ibDataSet2.Close;
                        Form7.ibDataSet2.Selectsql.Clear;
                        Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');  //
                        Form7.ibDataSet2.Open;

                        // CFOP Dinamico
                        if UpperCase(Copy(Form7.ibDataSet2IE.AsString,1,2)) = 'PR' then // Quando é produtor rural não precisa ter CGC
                        begin
                          sEstado := Form7.ibDataSet2ESTADO.AsString;
                          if AllTrim(Form7.ibDataSet2CGC.AsString) = '' then sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString); // Quando é produtor rural tem que ter CPF
                        end else
                        begin
                          if AllTrim((Limpanumero(Form7.ibDataSet2IE.AsString))) <> '' then sEstado := Form7.ibDataSet2ESTADO.AsString else sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
                          if not CpfCgc(LimpaNumero(Form7.ibDataSet2CGC.AsString)) then sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
                          if Length(AllTrim(Form7.ibDataSet2CGC.AsString)) < 18 then sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
                        end;

                        // Se o ST do produto for <> de zero pode
                        // ser que este produto tenha uma aliquota
                        // reduzida, ou tributado de ISS
                        if AllTrim(Form7.ibDataSet4ST.Value) <> '' then       // Quando alterar esta rotina alterar também retributa Ok 1 Abril
                        begin
                          if Form7.sRPS <> 'S' then
                          begin
                            sReg := Form7.ibDataSet14REGISTRO.AsString;
                            Form7.ibDataSet14.DisableControls;
                            Form7.ibDataSet14.Close;
                            Form7.ibDataSet14.SelectSQL.Clear;
                            Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(SubString(CFOP from 1 for 1),''X'') = ''X'' order by upper(NOME)');
                            Form7.ibDataSet14.Open;
                            if not Form7.ibDataSet14.Locate('ST',Form7.ibDataSet4ST.AsString,[loCaseInsensitive, loPartialKey]) then Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
                            Form7.ibDataSet14.EnableControls;
                          end;
                        end else
                        begin
                          if Form7.sRPS <> 'S' then
                          begin
                            Form7.ibDataSet14.DisableControls;
                            Form7.ibDataSet14.Close;
                            Form7.ibDataSet14.SelectSQL.Clear;
                            Form7.ibDataSet14.SelectSQL.Add('select * from ICM where SubString(CFOP from 1 for 1) = ''5'' or  SubString(CFOP from 1 for 1) = ''6'' or SubString(CFOP from 1 for 1) = ''7''  or Coalesce(SubString(CFOP from 1 for 1),''X'') = ''X'' order by upper(NOME)');
                            Form7.ibDataSet14.Open;
                            Form7.ibDataSet14.Locate('NOME',Form7.ibDataSet15OPERACAO.AsString,[]);
                            Form7.ibDataSet14.EnableControls;
                          end;
                        end;

                        if Pos('1'+sEstado+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX2') = 0 then
                          sEstado := 'MG';

                        // CFOP Dinamico
                        if (Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '107') and (Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '108') then // Esta faixa não muda dentro e fora do estado DOUGLAS - Electra - Sara Suporte
                        begin
                          if (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '5') or (Copy(Form7.ibDataSet14CFOP.AsString,1,1) = '6') then
                          begin
                            Form7.ibDataSet14.Edit;
                            if (sEstado = UpperCase(Form7.ibDataSet13ESTADO.AsString)) or (AllTrim(Form7.ibDataSet2ESTADO.AsString)='') then Form7.ibDataSet14CFOP.AsString := '5'+copy(Form7.ibDataSet14CFOP.AsString,2,5) else Form7.ibDataSet14CFOP.AsString := '6'+copy(Form7.ibDataSet14CFOP.AsString,2,5); // Ok
                            Form7.ibDataSet14.Post;
                          end;
                        end;
                      end;

                      if Form7.ibDataSet4TIPO_ITEM.AsString = '09' then
                      begin
                        // Serviços
                        if Form7.sRPS = 'S' then
                        begin
                          iB := IDYES;
                        end else
                        begin
                          iB := Application.MessageBox(Pchar('Importar serviço deste orçamento?'
                                                  + chr(10)
                                                  + Chr(10))
                                                  ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
                        end;
                        
                        if iB = IDYES then
                        begin
                          if (AllTrim(Form7.ibDataSet35REGISTRO.AsString) <> '') and (AllTrim(Form7.ibDataSet35DESCRICAO.AsString) = '') then
                          begin
                            Form7.ibDataSet35.Edit;
                          end else
                          begin
                            Form7.ibDataSet35.Append;
                          end;

                          Form7.ibDataSet35CODIGO.AsString    := Form7.ibDataSet4CODIGO.AsString;
                          Form7.ibDataSet35DESCRICAO.AsString := Form7.IbDataSet37DESCRICAO.AsString;
                          Form7.ibDataSet35QUANTIDADE.AsFloat := Form7.IbDataSet37QUANTIDADE.AsFloat;
                          Form7.ibDataSet35UNITARIO.AsFloat   := Form7.IbDataSet37UNITARIO.AsFloat;
                          {Sandro Silva 2022-09-21 inicio}
                          //Ficha 6253
                          // Quando está importando para NF-e deve selecionar a primeria alíquota de ISS configurada
                          Form7.SelecionaAliquotaIss(Form7.IBQALIQUOTAISS, IfThen(Form7.sRPS = 'S', Form7.ibDataSet15OPERACAO.AsString, '')); // Seleciona a Alíquota de ISS configurada
                          Form7.ibDataSet35ISS.AsFloat        := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBQALIQUOTAISS.FieldByname('ISS').AsFloat / 100 * Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat / 100);
                          Form7.ibDataSet35BASEISS.AsFloat    := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat / 100);

                          {Sandro Silva 2022-09-21 fim}

                          {Sandro Silva 2023-01-06 inicio}
                          Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Value := Form7.ibDataSet4IDENTIFICADORPLANOCONTAS.Value;
                          if Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.AsString = '' then
                            Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Clear;
                          {Sandro Silva 2023-01-06 fim}

                          Form7.ibDataSet35.Post;
                        end;
                      end else
                      begin
                        // Produtos
                        if Form7.sRPS <> 'S' then
                        begin
                          if (AllTrim(Form7.ibDataSet16REGISTRO.AsString) <> '') and (AllTrim(Form7.ibDataSet16DESCRICAO.AsString) = '') then
                          begin
                            Form7.ibDataSet16.Edit;
                          end else
                          begin
                            Form7.ibDataSet16.Append;
                          end;

                          Form7.ibDataSet16CODIGO.AsString    := Form7.ibDataSet4CODIGO.AsString;
                          Form7.ibDataSet16ST.AsString        := Form7.ibDataSet4ST.AsString;
                          Form7.ibDataSet16PESO.AsFloat       := Form7.ibDataSet4PESO.AsFloat;
                          Form7.ibDataSet16CUSTO.AsFloat      := Form7.ibDataSet4CUSTOCOMPR.AsFloat;
                          Form7.ibDataSet16LISTA.AsFloat      := Form7.ibDataSet4PRECO.AsFloat;
                          Form7.ibDataSet16MEDIDA.AsString    := Form7.ibDataSet4MEDIDA.AsString;

                          // Acerta os tributos e o CFOP
                          Form1.bFlag := True;
                          Form7.sModulo := 'VENDA';
                          Form7.ibDataSet16DESCRICAO.AsString := Form7.IbDataSet37DESCRICAO.AsString;

                          {Sandro Silva 2023-01-06 inicio}
                          Form7.ibDataSet16IDENTIFICADORPLANOCONTAS.Value := Form7.ibDataSet4IDENTIFICADORPLANOCONTAS.Value;
                          if Form7.ibDataSet16IDENTIFICADORPLANOCONTAS.AsString = '' then
                            Form7.ibDataSet16IDENTIFICADORPLANOCONTAS.Clear;
                          {Sandro Silva 2023-01-06 fim}

                          Form7.sModulo := 'ORCAMENTO';
                          Form1.bFlag := False;

                          Form7.ibDataSet16.Edit;
                          Form7.ibDataSet16QUANTIDADE.AsFloat := Form7.IbDataSet37QUANTIDADE.AsFloat;
                          Form7.ibDataSet16.Edit;
                          Form7.ibDataSet16UNITARIO.AsFloat   := Form7.IbDataSet37UNITARIO.AsFloat;
                          Form7.ibDataSet16IPI.AsFloat        := Form7.ibDataSet4IPI.AsFloat;

                          // Grade
                          Grade(Form7.IbDataSet37QUANTIDADE.AsFloat);

                          // Comentário do produto
                          for I := 1 to 9 do
                          begin
                            if (Pos('<Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString) <> 0) and (Pos('</Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString) > Pos('<Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString)) then
                            begin
                              // Mostra como comentário
                              sModuloREs := Form7.sMoDulo;
                              Form7.sMoDulo := 'Não';

                              Form7.ibDataSet16.Post;

                              sRegistro1 := Form7.ibDataSet16REGISTRO.AsString;

                              Form7.ibDataSet16.Append;
                              Form1.bFlag := False;
                              Form7.ibDataSet16DESCRICAO.AsString := Copy(Form7.ibDataSet4TAGS_.AsString,Pos('<Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString)+6,(Pos('</Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString)-Pos('<Obs'+IntToStr(I)+'>',Form7.ibDataSet4TAGS_.AsString))-6);
                              Form7.ibDataSet16.Post;

                              Form7.ibDataSet16.Locate('REGISTRO',sRegistro1,[]);

                              Form7.ibDataSet16.Edit;
                              Form7.sMoDulo := sModuloRes;
                            end;
                          end;
                        end else
                        begin
                          if Form7.IbDataSet37.FieldByname('NUMERONF').AsString = Form7.ibDataSet15NUMERONF.AsString then
                          begin
                            Form7.IbDataSet37.Edit;
                            Form7.IbDataSet37.FieldByname('NUMERONF').AsString := '';
                            Form7.IbDataSet37.Post;
                          end;
                        end;
                      end;
                    end;
                  end else
                  begin
                    Form7.ibDataSet16.Append;
                    Form7.ibDataSet16DESCRICAO.AsString := Form7.IbDataSet37DESCRICAO.AsString;
                  end;
                end;
              end;

              Form7.ibDataSet14.Locate('REGISTRO',sReg,[]);
            end;
          end;
        end;
      end;

      Form7.ibDataSet37.Next;
    end;
  end else
  begin
    //ShowMessage('Orçamento já importado ou inexistente.'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Orçamento já importado ou inexistente.',msgAtencao);
  end;

end;

function RetornarOBSOrcamento(AcPedido: String): String;
var
  cOBSOrcament: string;
begin
  // Não informar observação do ICM, pois ira dar problema na tela de Nota ao trocar a Natureza da Operação 
  Result := 'NF REFERENTE AO ORÇAMENTO: ' + AcPedido + '.';
  cOBSOrcament := BuscarOBSOrcamento(AcPedido);

  if cOBSOrcament <> EmptyStr then
    Result := Result + sLineBreak + cOBSOrcament;
end;

function BuscarOBSOrcamento(AcPedido: String): String;
var
  qryOBS: TIBQuery;
begin
  Result := EmptyStr;

  qryOBS := CriaIBQuery(Form7.ibDataSet15.Transaction);
  try
    qryOBS.Close;
    qryOBS.SQL.Clear;
    qryOBS.SQL.Add('SELECT');
    qryOBS.SQL.Add('OBS');
    qryOBS.SQL.Add('FROM ORCAMENTOBS');
    qryOBS.SQL.Add('WHERE (PEDIDO=' + QuotedStr(AcPedido) + ')');
    qryOBS.Open;

    if (not qryOBS.IsEmpty) then
      Result := qryOBS.FieldByName('OBS').AsString;
  finally
    FreeAndNil(qryOBS);
  end;
end;

function Grade(sP1: Real):Boolean;
var
  sRegistro1 : String;
begin
  // Grade
  Form7.ibDataSet10.Close;
  Form7.ibDataSet10.SelectSQL.Clear;
  // Sandro Silva 2023-08-17 Form7.ibDataSet10.Selectsql.Add('select * from GRADE where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' order by CODIGO, COR, TAMANHO');
  Form7.ibDataSet10.Selectsql.Add('select * from GRADE where coalesce(CODIGO, '''') <> '''' and  CODIGO = ' + QuotedStr(Form7.ibDataSet4CODIGO.AsString) + ' order by CODIGO, COR, TAMANHO');
  Form7.ibDataSet10.Open;
  Form7.ibDataSet10.First;

  // Sandro Silva 2023-08-17  if Form7.ibDataSet4CODIGO.AsString = Form7.ibDataSet10CODIGO.AsString then
  // Valida se o código encontrado é o mesmo que foi pesquisado e o encontrado não pode ser vazio. Identificado em banco de cliente, a tabela GRADE contendo registros e todos com campo CODIGO vazio
  if (Form7.ibDataSet4CODIGO.AsString = Form7.ibDataSet10CODIGO.AsString) and (Trim(Form7.ibDataSet10CODIGO.AsString) <> '') then
  begin
    // Cadastro do item na VENDA quantidade geralemtne = 1
    Form1.rReserva := sp1;
    Form7.sModulo := 'VENDA';
    Form13.Label1.Caption := 'Importando com grade';
    Form13.ShowModal;  // Importar

    // Mostra como comentário
    Form7.ibDataSet16.Post;

    sRegistro1 := Form7.ibDataSet16REGISTRO.AsString;

    Form7.ibDataSet16.Append;
    Form7.ibDataSet16DESCRICAO.AsString := Form1.sGrade;
    Form7.ibDataSet16.Post;

    Form7.ibDataSet16.Locate('REGISTRO',sRegistro1,[]);

    Form7.ibDataSet16.Edit;
  end;

  Result := True;
end;

end.
