unit uImportaOrdemServico;

interface

uses
  SysUtils
  , StrUtils
  , StdCtrls
  , SmallFunc
  , uFuncoesBancoDados
  , Dialogs
  , DB
  , Windows
  , Forms
  , IBQuery
  ;

  procedure ImportaOS(NumeroOS:string);

implementation

uses Unit7
    , uTransmiteNFSe
    , Unit12
    , Mais
    , uDialogs;

procedure FinalizaImportacaoOS;
begin
  Form7.sModulo := 'VENDA';
  Form7.ibDataSet16.Edit;
  Form7.ibDataSet16.Post;
  Form7.sModulo := 'OS';
  Form7.ibDataSet16.Edit;

  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet16.MoveBy(-1);
  Form7.ibDataSet16.MoveBy(1);
  Form12.DBGrid1.Update;
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
end;

procedure ImportaOS(NumeroOS:string);
var
  iB : Integer;
  campoDocumento : string;
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

  Form7.ibDataSet3.Close;
  Form7.ibDataSet3.SelectSQL.Text := ' Select *'+
                                     ' From OS '+
                                     ' Where NUMERO='+QuotedStr(NumeroOS);
  Form7.ibDataSet3.Open;
  Form7.ibDataSet3.First;

  //Mauricio Parizotto 2023-12-26
  if Form7.sRPS = 'N' then
    campoDocumento := 'NF'
  else
    campoDocumento := 'NFSE';

  Form7.ibDataSet3.DisableControls;
  //if (Form7.ibDataSet3NUMERO.AsString = NumeroOS) and (Form7.ibDataSet3SITUACAO.AsString<>'Fechada') then Mauricio Parizotto 2023-12-26
  if Form7.ibDataSet3.FieldByName(campoDocumento).AsString = '' then
  begin
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Text := ' Select * '+
                                       ' From CLIFOR'+
                                       ' Where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString);
    Form7.ibDataSet2.Open;

    Form7.ibQuery1.Close;
    Form7.ibQuery1.SQL.Text := ' Select * '+
                               ' From ITENS003 '+
                               ' Where NUMEROOS='+QuotedStr(Form7.ibDataSet3NUMERO.AsString)+
                               ' Order by REGISTRO';
    Form7.ibQuery1.Open;

    //Mauricio Parizotto 2023-12-28
    //Verfica se serviços já foram importado na nota fiscal
    if (Form7.sRPS = 'S') and (Form7.ibQuery1.FieldByName('NUMERONF').AssTring <> '') then
    begin
      MensagemSistema('Serviços já foram importados para Nota Fiscal: '+Form7.ibQuery1.FieldByName('NUMERONF').AssTring);
      FinalizaImportacaoOS;
      Exit;
    end;

    Form7.ibDataSet15.EnableControls;
    Form7.ibDataSet15CLIENTE.AsString     := Form7.ibDataSet2.fieldByName('NOME').AsString;
    Form7.ibDataSet15FRETE.AsFloat        := Form7.ibDataSet3TOTAL_FRET.AsFloat;
    Form7.ibDataSet15DESCONTO.AsFloat     := Form7.ibDataSet3DESCONTO.AsFloat;
    Form7.ibDataSet15COMPLEMENTO.AsString := 'NF REFERENTE A OS: '+NumeroOS;

    Form7.ibDataSet15.Post;
    Form7.ibDataSet15.Edit;

    if Form7.ibQuery1.FieldByname('NUMEROOS').AsString = Form7.ibDataSet3NUMERO.AsString then
    begin
      if Form7.sRPS = 'S' then
      begin
        iB := IDYES;
      end else
      begin
        //Mauricio Parizotto 2023-12-28
        {
        iB := Application.MessageBox(Pchar('Importar os serviços desta OS?'
                                + chr(10)
                                + Chr(10))
                                ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
        }

        //Verfica se serviços já foram importado na nota de serviço
        if Form7.ibQuery1.FieldByName('NUMERONF').AsString <> '' then
        begin
          iB := IDNO;
        end else
        begin
          iB := Application.MessageBox(Pchar('Importar os serviços desta OS?'
                                  + chr(10)
                                  + Chr(10))
                                  ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
        end;
      end;

      if iB = IDYES then
      begin
        // Serviços
        Form7.ibDataSet35.Close;
        Form7.ibDataSet35.SelectSQL.Clear;
        Form7.ibDataSet35.SelectSQL.Add('select * from ITENS003 where NUMEROOS='+QuotedStr(Form7.ibDataSet3NUMERO.AsString)+' order by REGISTRO');
        Form7.ibDataSet35.Open;
        Form7.ibDataSet35.First;

        // Serviços
        while not (Form7.ibDataSet35.EOF) do
        begin
          if AllTrim(Form7.ibDataSet35.FieldByname('NUMERONF').AsString) = '' then
          begin
            Form7.ibDataSet35.Edit;
            Form7.ibDataSet35NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;

            {Sandro Silva 2022-09-21 inicio}
            //Ficha 6253
            // Quando está importando para NF-e deve selecionar a primeria alíquota de ISS configurada
            Form7.SelecionaAliquotaIss(Form7.IBQALIQUOTAISS, IfThen(Form7.sRPS = 'S', Form7.ibDataSet15OPERACAO.AsString, '')); // Seleciona a Alíquota de ISS configurada
            {Sandro Silva 2023-10-02 inicio
            Form7.ibDataSet35ISS.AsFloat        := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBQALIQUOTAISS.FieldByname('ISS').AsFloat / 100 * Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat / 100);
            Form7.ibDataSet35BASEISS.AsFloat    := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat / 100);
            }
            Form7.ibDataSet35ISS.AsFloat        := Form7.Formata2CasasDecimais(CalculaValorISS(Form7.oArqConfiguracao.NFSe.InformacoesObtidasNaPrefeitura.PadraoProvedor, Form7.ibDataSet35TOTAL.AsFloat, Form7.IBQALIQUOTAISS.FieldByname('ISS').AsFloat, Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat));
            Form7.ibDataSet35BASEISS.AsFloat    := Form7.Formata2CasasDecimais(Form7.ibDataSet35TOTAL.AsFloat * Form7.IBQALIQUOTAISS.FieldByname('BASEISS').AsFloat / 100);
            {Sandro Silva 2023-10-02 fim}
            {Sandro Silva 2022-09-21 fim}

            {Sandro Silva 2023-01-06 inicio}
            Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Value := Form7.ibDataSet4IDENTIFICADORPLANOCONTAS.Value;
            if Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.AsString = '' then
              Form7.ibDataSet35IDENTIFICADORPLANOCONTAS.Clear;
            {Sandro Silva 2023-01-06 fim}

            Form7.ibDataSet35.Post;
          end;
          Form7.ibDataSet35.Next;
        end;

        Form7.ibDataSet3.Edit;
        Form7.ibDataSet3SITUACAO.AsString   := 'Fechada';
        Form7.ibDataSet3DATA_ENT.AsDateTime := Date;
        Form7.ibDataSet3HORA_ENT.AsString   := TimeToStr(Time);
        //Form7.ibDataSet3NF.AsString         := Form7.ibDataSet15NUMERONF.AsString; Mauricio Parizotto 2023-12-26
        Form7.ibDataSet3.FieldByName(campoDocumento).AsString := Form7.ibDataSet15NUMERONF.AsString;
        Form7.ibDataSet3.Post;
      end;
    end;

    // Peças
    if Form7.sRPS <> 'S' then
    begin
      Form7.ibDataSet16.Close;
      Form7.ibDataSet16.SelectSQL.Clear;
      Form7.ibDataSet16.SelectSQL.Add(' Select * from ITENS001 '+
                                      ' Where NUMEROOS='+QuotedStr(Form7.ibDataSet3NUMERO.AsString)+' ');
      Form7.ibDataSet16.Open;
      Form7.ibDataSet16.First;

      while not Form7.ibDataSet16.Eof do
      begin
        if (AllTrim(Form7.ibDataSet16.FieldByname('NUMERONF').AsString) = '') then
        begin
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;
          Form7.ibDataSet16.Post;

          if AllTrim(Form7.ibDataSet16CODIGO.AsString) <> '' then
          begin
            Form7.ibDataSet4.Close;
            Form7.ibDataSet4.Selectsql.Clear;
            Form7.ibDataSet4.Selectsql.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Form7.ibDataSet16CODIGO.AsString)+' ');
            Form7.ibDataSet4.Open;

            if Form7.ibDataSet16CODIGO.AsString = Form7.ibDataSet4CODIGO.AsString then
            begin
              if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then
              begin
                try
                  Form7.ibDataSet4.Edit;
                  Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat
                                                 + Form7.ibDataSet16QUANTIDADE.AsFloat;
                  Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                  Form7.ibDataSet4.Post;

                  Form7.ibDataSet16.Edit;
                  Form7.ibDataSet16SINCRONIA.AsFloat := 0;
                except
                end;
              end;
            end;
          end;
        end;

        Form7.ibDataSet16.Next;
      end;

      Form7.ibDataSet3.Edit;
      Form7.ibDataSet3SITUACAO.AsString   := 'Fechada';
      Form7.ibDataSet3DATA_ENT.AsDateTime := Date;
      Form7.ibDataSet3HORA_ENT.AsString   := TimeToStr(Time);
      Form7.ibDataSet3NF.AsString         := Form7.ibDataSet15NUMERONF.AsString;
      Form7.ibDataSet3.Post;
    end;
  end else
  begin
    //ShowMessage('Ordem de serviço já importada ou inexistente.');
    MensagemSistema('Ordem de serviço já importada ou inexistente.');
  end;

  //Mauricio Parizotto 2023-12-28
  FinalizaImportacaoOS;
  {
  Form7.sModulo := 'VENDA';
  Form7.ibDataSet16.Edit;
  Form7.ibDataSet16.Post;
  Form7.sModulo := 'OS';
  Form7.ibDataSet16.Edit;

  Form7.ibDataSet16.EnableControls;
  Form7.ibDataSet16.MoveBy(-1);
  Form7.ibDataSet16.MoveBy(1);
  Form12.DBGrid1.Update;
  Form7.ibDataSet15MERCADORIAChange(Form7.ibDataSet15MERCADORIA);
  }
end;

end.
