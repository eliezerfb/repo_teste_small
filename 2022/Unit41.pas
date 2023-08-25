// Unit de importação de OS/Orçamento
unit Unit41;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, SmallFunc, DB, IniFiles, Buttons, IBQuery
  , StrUtils;

type
  TForm41 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    Button3: TBitBtn;
    btnAvancar: TBitBtn;
    Button2: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure MaskEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure RadioButton1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MaskEdit2Exit(Sender: TObject);
    procedure MaskEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure ImportaCupom;
    procedure ImportaOrcamento;
    procedure ImportaOS;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form41: TForm41;
  sTipo : String;

implementation

uses Unit7, Mais, Unit12, Unit34, Unit13, Unit33, uFuncoesBancoDados;

{$R *.DFM}


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

procedure TForm41.FormActivate(Sender: TObject);
begin
  // N do caixa //
  if not (Form7.ibDataset15.State in ([dsEdit, dsInsert])) then
    Form7.ibDataset15.Edit;

  Image1.Picture := Form7.Image205.Picture;

  MaskEdit2.Visible := False;
  Label8.Visible    := False;
  Panel3.Visible := True;
  MaskEdit2.Text    := '001';

  sTipo := Form7.sModulo;
  if (Form7.sModulo = 'OS') then
  begin
    MaskEdit1.SetFocus;
    MaskEdit1.SelectAll;
  end else
  begin
    if Form7.sModulo = 'BALCAO' then
    begin
      try
        Form7.ibDataSet27.Close;
        Form7.ibDataSet27.SelectSQL.Clear;
        Form7.ibDataSet27.SelectSQL.Add(' Select * from ALTERACA '+
                                        ' Where DATA='+QuotedStr(DAteToStrInvertida(DATE))+
                                        ' Order by PEDIDO');
        Form7.ibDataSet27.Open;

        Form7.ibDataSet27.Last;
        MaskEdit1.Text := Form7.ibDataSet27PEDIDO.AsString;
        MaskEdit2.Text := Form7.ibDataSet27CAIXA.AsString;
      except
      end;

      MaskEdit2.Visible := True;
      Label8.Visible    := True;
      Panel3.Visible := True;
      MaskEdit1.SetFocus;
      MaskEdit1.SelectAll;
    end;

    if Form7.sModulo = 'ORCAMENTO' then
    begin
      Form7.ibDataSet37.Close;
      Form7.ibDataSet37.SelectSQL.Clear;
      Form7.ibDataSet37.SelectSQL.Add('select first 1 * from ORCAMENT order by PEDIDO desc');
      Form7.ibDataSet37.Open;

      MaskEdit1.Text := Form7.ibDataSet37PEDIDO.AsString;
      MaskEdit2.Visible := False;
      Label8.Visible    := False;
      Panel3.Visible := True;
      MaskEdit1.SetFocus;
      MaskEdit1.SelectAll;
    end;
  end;
end;

procedure TForm41.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm41.btnAvancarClick(Sender: TObject);
begin
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

  // Ordem de serviços
  if Form7.sModulo = 'OS' then
  begin
    ImportaOS;
  end;

  // Importar orçamento específico
  if Form7.sModulo = 'ORCAMENTO' then
  begin
    ImportaOrcamento;
  end;

  // Cupom Fiscal
  if Form7.sModulo = 'BALCAO' then
  begin
    ImportaCupom;
  end;

  Retributa(True);
  Form41.Close;

  //Mauricio Parizotto 2023-07-26
  Form7.ibDataSet16.EnableControls;
end;


procedure TForm41.MaskEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if MaskEdit2.CanFocus then
      MaskEdit2.SetFocus
    else
      btnAvancar.SetFocus;
  end;
end;

procedure TForm41.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm41.RadioButton1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnAvancar.setFocus;
end;

procedure TForm41.MaskEdit1Exit(Sender: TObject);
begin
  if Limpanumero(MaskEdit1.TExt) <> '' then
  begin
    if (Form7.sModulo = 'OS') or (Form7.sModulo = 'ORCAMENTO') then
      MaskEdit1.Text := StrZero(StrToInt(Limpanumero(MaskEdit1.TExt)),10,0)
    else
      MaskEdit1.Text := StrZero(StrToInt(Limpanumero(MaskEdit1.TExt)),6,0);
  end
  else
  MaskEdit1.Text := '0';
end;

procedure TForm41.FormShow(Sender: TObject);
begin
  if Panel3.Visible then
  begin
    MaskEdit1.SetFocus;
    MaskEdit1.SelectAll;
  end;
end;

procedure TForm41.MaskEdit2Exit(Sender: TObject);
begin
  if Limpanumero(MaskEdit2.TExt) <> '' then
    MaskEdit2.Text := StrZero(StrToInt(Limpanumero(MaskEdit2.TExt)),3,0) else MaskEdit2.Text := '001';
end;

procedure TForm41.ImportaOS;
var
  iB : Integer;
begin
  Form7.ibDataSet3.Close;
  Form7.ibDataSet3.SelectSQL.Clear;
  Form7.ibDataSet3.SelectSQL.Add(' Select * from OS '+
                                 ' Where NUMERO='+QuotedStr(MaskEdit1.Text)+' ');
  Form7.ibDataSet3.Open;
  Form7.ibDataSet3.First;

  Form7.ibDataSet3.DisableControls;
  if (Form7.ibDataSet3NUMERO.AsString = MaskEdit1.Text) and (Form7.ibDataSet3SITUACAO.AsString<>'Fechada') then
  begin
    Form7.ibDataSet2.Close;
    Form7.ibDataSet2.Selectsql.Clear;
    Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet3CLIENTE.AsString)+' ');  //
    Form7.ibDataSet2.Open;

    Form7.ibDataSet15.EnableControls;
    Form7.ibDataSet15CLIENTE.AsString     := Form7.ibDataSet2.fieldByName('NOME').AsString;
    Form7.ibDataSet15FRETE.AsFloat        := Form7.ibDataSet3TOTAL_FRET.AsFloat;
    Form7.ibDataSet15DESCONTO.AsFloat     := Form7.ibDataSet3DESCONTO.AsFloat;
    Form7.ibDataSet15COMPLEMENTO.AsString := 'NF REFERENTE A OS: '+MaskEdit1.Text;

    Form7.ibDataSet15.Post;
    Form7.ibDataSet15.Edit;

    Form7.ibQuery1.Close;
    Form7.ibQuery1.SQL.Clear;
    Form7.ibQuery1.SQL.Add(' Select * from ITENS003 '+
                           ' Where NUMEROOS='+QuotedStr(Form7.ibDataSet3NUMERO.AsString)+
                           ' Order by REGISTRO');
    Form7.ibQuery1.Open;

    if Form7.ibQuery1.FieldByname('NUMEROOS').AsString = Form7.ibDataSet3NUMERO.AsString then
    begin
      if Form7.sRPS = 'S' then
      begin
        iB := IDYES;
      end else
      begin
        iB := Application.MessageBox(Pchar('Importar os serviços desta OS?'
                                + chr(10)
                                + Chr(10))
                                ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING);
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
          Form7.ibDataSet35.Next;
        end;

        Form7.ibDataSet3.Edit;
        Form7.ibDataSet3SITUACAO.AsString   := 'Fechada';
        Form7.ibDataSet3DATA_ENT.AsDateTime := Date;
        Form7.ibDataSet3HORA_ENT.AsString   := TimeToStr(Time);
        Form7.ibDataSet3NF.AsString         := Form7.ibDataSet15NUMERONF.AsString;
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
              if Form7.ibDataSet16SINCRONIA.AsFloat = Form7.ibDataSet16QUANTIDADE.AsFloat then    // Resolvi este problema as 4 da madrugada no NoteBook em casa
              begin
                // ShowMessage('Teste volta ao estoque '+Form7.ibDataSet16QUANTIDADE.AsString +' '+Form7.ibDataSet16DESCRICAO.AsString);
                try
                  Form7.ibDataSet4.Edit;
                  Form7.ibDataSet4QTD_ATUAL.AsFloat := Form7.ibDataSet4QTD_ATUAL.AsFloat
                                                 + Form7.ibDataSet16QUANTIDADE.AsFloat;
                  Form7.ibDataSet4ULT_VENDA.AsDateTime := Form7.ibDataSet15EMISSAO.AsDateTime;
                  Form7.ibDataSet4.Post;

                  Form7.ibDataSet16.Edit;                                                     //
                  Form7.ibDataSet16SINCRONIA.AsFloat := 0;                                    // Resolvi este problema as 4 da madrugada no NoteBook em casa
                except end;
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
    ShowMessage('Ordem de serviço já importada ou inexistente.');
  end;

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
  Form41.Close;

end;


procedure TForm41.ImportaOrcamento;
var
  iDupl, I, iB : Integer;
  sReg, sEstado : String;
  sRegistro1, sModuloREs, sPortador, sValor, sVencimento : STring;
begin
  sReg := Form7.ibDataSet14REGISTRO.AsString;

  Form7.ibDataSet37.Close;
  Form7.ibDataSet37.SelectSQL.Text := ' Select * from ORCAMENT'+
                                      ' Where PEDIDO='+QuotedStr(MaskEdit1.Text)+
                                      ' Order by REGISTRO';
  Form7.ibDataSet37.Open;
  Form7.ibDataSet37.First;

  iDupl     := 0;
  sPortador := '';

  if Form7.ibDataSet37PEDIDO.AsString = MaskEdit1.Text then
  begin
    while not Form7.ibDataSet37.Eof do
    begin
      if (Alltrim(Form7.ibDataSet37.FieldByname('NUMERONF').AsString) = '') then
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

                {Sandro Silva 2023-01-02 inicio}
                if Form1.DisponivelSomenteParaNos then
                  Form7.ibDataSet7DOCUMENTO.AsString  := Form7.ObtemNumeroDocumentoReceber(Form7.ibDataSet7NUMERONF.AsString, Form7.sRPS, iDupl);
                {Sandro Silva 2023-01-02 fim}

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
                    if (Form1.ConfNegat = 'Não') and (Form7.ibDataSet4QTD_ATUAL.AsFloat < Form7.IbDataSet37QUANTIDADE.AsFloat) and ((sTipo <> 'BALCAO') and (sTipo <> 'VENDA')) then
                    begin
                      ShowMessage('Não é possível efetuar a venda de '+Form7.IbDataSet37DESCRICAO.AsString+chr(10)
                      +'só tem ' + Form7.ibDataSet4QTD_ATUAL.AsString + ' no estoque');
                    end else
                    begin
                      if (AllTrim(Form7.ibDataSet15CLIENTE.AsString) = '') and (AllTrim(Form7.ibDataSet37CLIFOR.AsString) <> '') then
                      begin
                        if AllTrim(Form7.ibDataSet37VENDEDOR.AsString) <> '<Nome do Vendedor>' then Form7.ibDataSet15VENDEDOR.AsString  := Form7.IbDataSet37VENDEDOR.AsString;
                        Form7.ibDataSet15CLIENTE.AsString     := Form7.IbDataSet37CLIFOR.AsString;
                        Form7.ibDataSet15COMPLEMENTO.AsString := 'NF REFERENTE AO ORÇAMENTO: '+MaskEdit1.Text;

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
    ShowMessage('Orçamento já importado ou inexistente.');
  end;
end;


procedure TForm41.ImportaCupom;
var
  sReg, sEstado : String;
  I : Integer;

  IBQCupom: TIBQuery;
begin
  sReg := Form7.ibDataSet14REGISTRO.AsString;

  IBQCupom := Form7.CriaIBQuery(Form7.ibDataSet13.Transaction);

  try
    IBQCupom.Close;
    //Form7.IbDataSet27.SelectSQL.Clear;
    //Form7.IbDataSet27.SelectSQL.Add('Select * from ALTERACA where PEDIDO='+QuotedStr(MaskEdit1.Text)+' and CAIXA='+QuotedStr(MaskEdit2.Text)+' and coalesce(VALORICM,''0'')=''0'' ');
    IBQCupom.SQL.Text := ' Select '+
                         '   A.*,'+
                         '   Coalesce(N.MODELO,'''') Modelo, '+
                         '   UPPER(N.STATUS) StatusNFCE'+
                         ' From ALTERACA A'+
                         '   	Left Join NFCE N on N.NUMERONF = A.PEDIDO and N.CAIXA = A.CAIXA'+ // Precisa ser Left Join pois vendas de ECF não tem na tabela NFCE
                         ' Where A.PEDIDO='+QuotedStr(MaskEdit1.Text)+
                         '   and A.CAIXA='+QuotedStr(MaskEdit2.Text)+
                         '   and coalesce(A.VALORICM,''0'')=''0'' ';

    IBQCupom.Open;
    IBQCupom.First;
    Form7.ibDataSet16.Edit;

    //Se não encontrar
    if IBQCupom.IsEmpty then
    begin
      ShowMessage('Cupom fiscal não encontrado ou já importado.');
      Exit;
    end;

    //Se for cupom fiscal verifica se tem o CFOP
    if IBQCupom.FieldByName('Modelo').AsString <> '99' then
    begin
      Form7.ibDataSet14.DisableControls;
      Form7.ibDataSet14.Close;
      Form7.ibDataSet14.SelectSQL.Text := ' Select * '+
                                          ' From ICM '+
                                          ' Where SubString(CFOP from 1 for 1) = ''5'' '+
                                          '   or  SubString(CFOP from 1 for 1) = ''6'' '+
                                          '   or SubString(CFOP from 1 for 1) = ''7'' '+
                                          ' Order by upper(NOME)';
      Form7.ibDataSet14.Open;
      Form7.ibDataSet14.EnableControls;

      if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
        Form7.ibDataSet14.Locate('CFOP','5929',[]);
      if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
        Form7.ibDataSet14.Locate('CFOP','6929',[]);

      if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
      begin
        Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
      end else
      begin
        ShowMEssage('A importação do Cupom Fiscal só poderá ser concluída com o CFOP 5929 ou 6929');
        Exit;
      end;
    end else
    begin
      //Cupom Gerencial
      if Pos('FINALIZADA', AnsiUpperCase(IBQCupom.FieldByName('StatusNFCE').AsString)) <> 1 then //Validando início do status permite importar cupons antigos MEI e novos gerenciais Sandro Silva 2023-08-23 if IBQCupom.FieldByName('StatusNFCE').AsString <> 'FINALIZADA' then
      begin
        ShowMEssage('Cupom gerencial não finalizado.');
        Exit;
      end;
    end;

    while not IBQCupom.Eof do
    begin
      Form7.ibDataSet4.Close;
      Form7.ibDataSet4.Selectsql.Text := ' Select * '+
                                         ' From ESTOQUE '+
                                         ' Where DESCRICAO='+QuotedStr(IBQCupom.fieldbyName('DESCRICAO').AsString);
      Form7.ibDataSet4.Open;

      if (IBQCupom.FieldByName('DESCRICAO').AsString = Form7.ibDataSet4DESCRICAO.AsString)
        and (AllTrim(IBQCupom.FieldByName('DESCRICAO').AsString) <> '') then
      begin
        if (Form1.ConfNegat = 'Não') and (Form7.ibDataSet4QTD_ATUAL.AsFloat < IBQCupom.FieldByName('QUANTIDADE').AsFloat) and ((sTipo <> 'BALCAO') and (sTipo <> 'VENDA')) then
        begin
          ShowMessage('Não é possível efetuar a venda de '+IBQCupom.FieldByName('DESCRICAO').AsString+chr(10)
                      +'só tem ' + Form7.ibDataSet4QTD_ATUAL.AsString + ' no estoque');
        end else
        begin
          if (AllTrim(Form7.ibDataSet15CLIENTE.AsString) = '')
            and (AllTrim(IBQCupom.FieldByName('CLIFOR').AsString) <> '') then
          begin
            Form7.ibDataSet15VENDEDOR.AsString  := IBQCupom.FieldByName('VENDEDOR').AsString;
            Form7.ibDataSet15CLIENTE.AsString   := IBQCupom.FieldByName('CLIFOR').AsString;

            Form7.ibDataSet2.Close;
            Form7.ibDataSet2.Selectsql.Clear;
            Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet15CLIENTE.AsString)+' ');
            Form7.ibDataSet2.Open;

            // CFOP Dinamico
            if UpperCase(Copy(Form7.ibDataSet2IE.AsString,1,2)) = 'PR' then // Quando é produtor rural não precisa ter CGC
            begin
              sEstado := Form7.ibDataSet2ESTADO.AsString;
              if AllTrim(Form7.ibDataSet2CGC.AsString) = '' then
                sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString); // Quando é produtor rural tem que ter CPF
            end else
            begin
              if AllTrim((Limpanumero(Form7.ibDataSet2IE.AsString))) <> '' then
                sEstado := Form7.ibDataSet2ESTADO.AsString
              else
                sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);

              if not CpfCgc(LimpaNumero(Form7.ibDataSet2CGC.AsString)) then
                sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
              
              if Length(AllTrim(Form7.ibDataSet2CGC.AsString)) < 18 then
                sEstado := UpperCase(Form7.ibDataSet13ESTADO.AsString);
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

            if Pos('1'+sEstado+'2','1AC21AL21AM21AP21BA21CE21DF21ES21GO21MA21MG21MS21MT21PA21PB21PE21PI21PR21RJ21RN21RO21RR21RS21SC21SE21SP21TO21EX2') = 0 then sEstado := 'MG';

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

          Form7.ibDataSet16XPED.AsString      := 'CF'+ Copy(AllTrim(MaskEdit1.Text)+'000000',1,6) +'CX'+Copy(AllTrim(MaskEdit2.Text)+'000',1,3);

          // Acerta os tributos e o CFOP
          Form1.bFlag := True;
          Form7.sModulo := 'VENDA';
          Form7.ibDataSet16DESCRICAO.AsString := IBQCupom.FieldByName('DESCRICAO').AsString;
          Form7.sModulo := 'BALCAO';
          Form1.bFlag := False;

          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16QUANTIDADE.AsFloat := IBQCupom.FieldByName('QUANTIDADE').AsFloat;
          Form7.ibDataSet16.Edit;
          Form7.ibDataSet16UNITARIO.AsFloat   := IBQCupom.FieldByName('UNITARIO').AsFloat;
          Form7.ibDataSet16TOTAL.AsFloat      := Arredonda((IBQCupom.FieldByName('UNITARIO').AsFloat * IBQCupom.FieldByName('QUANTIDADE').AsFloat),StrToInt(Form1.ConfPreco));
          Form7.ibDataSet16IPI.AsFloat        := Form7.ibDataSet4IPI.AsFloat;

          Grade(IBQCupom.FieldByName('QUANTIDADE').AsFloat);

          {Form7.IbDataSet27.Edit;
          Form7.IbDataSet27.FieldByname('VALORICM').AsFloat := StrToFloat(Form7.ibDataSet15NUMERONF.AsString);
          Form7.IbDataSet27.Post;}

          ExecutaComando(' Update ALTERACA set VALORICM = '+ FloatToStr(StrToFloatDef(Form7.ibDataSet15NUMERONF.AsString,0))+
                         ' Where REGISTRO = '+QuotedStr(IBQCupom.FieldByName('REGISTRO').AsString ),
                         Form7.ibDataSet13.Transaction);
        
          // Nao volta mais a quantidade no estoque, agora as notas com CFOP 5929 e 6929 não dao mais baixa no estoque a nova regra é essa
        end;
      end else
      begin
        if Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) <> '<CANCELADO>' then
        begin
          if Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Desconto' then
          begin
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15DESCONTO.AsFloat := Form7.ibDataSet15DESCONTO.AsFloat + (IBQCupom.FieldByName('TOTAL').AsFloat * -1);
          end else
          begin
            try
              Form7.ibDataSet35.Append;
              Form7.ibDataSet35DESCRICAO.AsString := IBQCupom.FieldByName('DESCRICAO').AsString;
              Form7.ibDataSet35QUANTIDADE.AsFloat := IBQCupom.FieldByName('QUANTIDADE').AsFloat;
              Form7.ibDataSet35.Edit;
              Form7.ibDataSet35UNITARIO.AsFloat   := IBQCupom.FieldByName('UNITARIO').AsFloat;
              Form7.ibDataSet35TOTAL.AsFloat      := Arredonda((IBQCupom.FieldByName('UNITARIO').AsFloat * IBQCupom.FieldByName('QUANTIDADE').AsFloat),StrToInt(Form1.ConfPreco));
              Form7.ibDataSet35.Post;
            except end;
          end;
        end;
      end;
      IBQCupom.Next;
    end;

    Form7.ibDataSet7.DisableControls;
    Form7.IbDataSet7.Close;
    Form7.IbDataSet7.SelectSQL.Text := ' Select * from RECEBER '+
                                       ' Where substring(DOCUMENTO from 1 for 9)='+QuotedStr(AllTrim(MaskEdit2.Text)+Copy(MaskEdit1.Text,1,6));
    Form7.IbDataSet7.Open;
    Form7.IbDataSet7.First;

    while not Form7.IbDataSet7.Eof do
    begin
      Form7.ibDataSet7.Edit;
      Form7.ibDataSet7NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;
      Form7.ibDataSet7.Post;
      Form7.ibDataSet7.Next;
    end;

    Form7.IbDataSet7.Close;
    Form7.IbDataSet7.SelectSQL.Text := ' Select * from RECEBER '+
                                       ' Where NUMERONF = ' + QuotedStr(Form7.ibDataSet15NUMERONF.AsString);
    Form7.IbDataSet7.Open;
    Form7.IbDataSet7.First;

    I := 0;

    while not Form7.IbDataSet7.Eof do
    begin
      I := I + 1;
      Form7.ibDataSet7.Next;
    end;

    if I <> 0 then
      Form7.ibDataSet15DUPLICATAS.AsFloat := I;

    Form7.ibDataSet7.EnableControls;
  finally
    FreeAndNil(IBQCupom);
  end;
end;


procedure TForm41.MaskEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnAvancar.SetFocus;
end;

end.






