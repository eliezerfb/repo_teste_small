// Unit de importação de OS/Orçamento
unit Unit41;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, smallfunc_xe, DB, IniFiles, Buttons, IBQuery
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
    //procedure ImportaOrcamento;
    //procedure ImportaOS;
    //function BuscarOBSOrcamento(AcPedido: String): String;
    //function RetornarOBSOrcamento(AcPedido: String): String;
    { Private declarations }
  public
    //vOrcamentImportar : string;
    { Public declarations }
  end;

var
  Form41: TForm41;
  sTipo : String;

implementation

uses Unit7, Mais, Unit12, Unit34, Unit13, Unit33, uFuncoesBancoDados,
  uTransmiteNFSe, uImportaOrcamento, uDialogs;

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

  Image1.Picture := Form7.imgImprimir.Picture;

  MaskEdit2.Visible := False;
  Label8.Visible    := False;
  Panel3.Visible := True;
  MaskEdit2.Text    := '001';

  sTipo := Form7.sModulo;
  {
  if (Form7.sModulo = 'OS') then
  begin
    MaskEdit1.SetFocus;
    MaskEdit1.SelectAll;
  end else
  Mauricio Parizotto 2023-10-23}
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

    (*
    if Form7.sModulo = 'ORCAMENTO' then
    begin
      {Mauricio Parizotto 2023-08-23 Inicio}
      {
      Form7.ibDataSet37.Close;
      Form7.ibDataSet37.SelectSQL.Clear;
      Form7.ibDataSet37.SelectSQL.Add('select first 1 * from ORCAMENT order by PEDIDO desc');
      Form7.ibDataSet37.Open;

      MaskEdit1.Text := Form7.ibDataSet37PEDIDO.AsString;
      }

      if vOrcamentImportar <> '' then
      begin
        //Importação pela tela de Orçamentos
        MaskEdit1.Text := vOrcamentImportar;
        vOrcamentImportar := '';
      end else
      begin
        Form7.ibDataSet37.Close;
        Form7.ibDataSet37.SelectSQL.Clear;
        Form7.ibDataSet37.SelectSQL.Add('select first 1 * from ORCAMENT order by PEDIDO desc');
        Form7.ibDataSet37.Open;

        MaskEdit1.Text := Form7.ibDataSet37PEDIDO.AsString;
      end;
      {Mauricio Parizotto 2023-08-23 Fim}

      MaskEdit2.Visible := False;
      Label8.Visible    := False;
      Panel3.Visible := True;
      MaskEdit1.SetFocus;
      MaskEdit1.SelectAll;
    end;
    Mauricio Parizotto 2023-10-16 migrado para nova tela*)
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

  {
  // Ordem de serviços
  if Form7.sModulo = 'OS' then
  begin
    ImportaOS;
  end;
  Mauricio Parizotto 2023-10-20}

  // Importar orçamento específico
  if Form7.sModulo = 'ORCAMENTO' then
  begin
    //Maurcio Parizotto 2023-10-16 movido para uImportaOrcamento}
    //ImportaOrcamento;
    ImportaOrcamento(MaskEdit1.Text,sTipo);
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
    {
    if (Form7.sModulo = 'OS') or (Form7.sModulo = 'ORCAMENTO') then
      MaskEdit1.Text := StrZero(StrToInt(Limpanumero(MaskEdit1.TExt)),10,0)
    else
    Mauricio Parizotto 2023-10-20}
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
      //ShowMessage('Cupom fiscal não encontrado ou já importado.'); Mauricio Parizotto 2023-10-25
      MensagemSistema('Cupom fiscal não encontrado ou já importado.',msgAtencao);
      Exit;
    end;

    //Se for cupom fiscal verifica se tem o CFOP
    if IBQCupom.FieldByName('Modelo').AsString <> '99' then
    begin
      Form7.ibDataSet14.DisableControls;
      try
        Form7.ibDataSet14.Close;
        Form7.ibDataSet14.SelectSQL.Text := ' Select * '+
                                            ' From ICM '+
                                            ' Where ((SubString(TRIM(CFOP) from 1 for 1) = ''5'') '+
                                            '   or  (SubString(TRIM(CFOP) from 1 for 1) = ''6'') '+
                                            '   or (SubString(TRIM(CFOP) from 1 for 1) = ''7'')) '+
                                            ' Order by upper(NOME)';
        Form7.ibDataSet14.Open;

        if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
          Form7.ibDataSet14.Locate('CFOP','5929', [loPartialKey]);
        if Copy(Form7.ibDataSet14CFOP.AsString,2,3) <> '929' then
          Form7.ibDataSet14.Locate('CFOP','6929', [loPartialKey]);

        if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
        begin
          Form7.ibDataSet15OPERACAO.AsString := Form7.ibDataSet14NOME.AsString;
        end else
        begin
          //ShowMEssage('A importação do Cupom Fiscal só poderá ser concluída com o CFOP 5929 ou 6929'); Mauricio Parizotto 2023-10-25
          MensagemSistema('A importação do Cupom Fiscal só poderá ser concluída com o CFOP 5929 ou 6929',msgAtencao);
          Exit;
        end;
      finally
        Form7.ibDataSet14.EnableControls;
      end;
    end else
    begin
      //Cupom Gerencial
      if Pos('FINALIZADA', AnsiUpperCase(IBQCupom.FieldByName('StatusNFCE').AsString)) <> 1 then //Validando início do status permite importar cupons antigos MEI e novos gerenciais Sandro Silva 2023-08-23 if IBQCupom.FieldByName('StatusNFCE').AsString <> 'FINALIZADA' then
      begin
        //ShowMEssage('Cupom gerencial não finalizado.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('Cupom gerencial não finalizado.',msgAtencao);
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
          {
          ShowMessage('Não é possível efetuar a venda de '+IBQCupom.FieldByName('DESCRICAO').AsString+chr(10)
                      +'só tem ' + Form7.ibDataSet4QTD_ATUAL.AsString + ' no estoque');
          Mauricio Parizotto 2023-10-25}
          MensagemSistema('Não é possível efetuar a venda de '+IBQCupom.FieldByName('DESCRICAO').AsString+chr(10)
                          +'só tem ' + Form7.ibDataSet4QTD_ATUAL.AsString + ' no estoque',msgAtencao);
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
          {Dailon Parisotto (f-17688) 2024-04-05 Inicio

          if Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Desconto' then
            Form7.ibDataSet15DESCONTO.AsFloat := Form7.ibDataSet15DESCONTO.AsFloat + (IBQCupom.FieldByName('TOTAL').AsFloat * -1);
          }
          if (Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Desconto')
             or (Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Acréscimo') then
          begin
            Form7.ibDataSet15.Edit;
            if (Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Desconto') then
              Form7.ibDataSet15DESCONTO.AsFloat := Form7.ibDataSet15DESCONTO.AsFloat + (IBQCupom.FieldByName('TOTAL').AsFloat * -1);
            if (Alltrim(IBQCupom.FieldByName('DESCRICAO').AsString) = 'Acréscimo') then
              Form7.ibDataSet15DESPESAS.AsFloat := Form7.ibDataSet15DESPESAS.AsFloat + IBQCupom.FieldByName('TOTAL').AsFloat;
          {Dailon Parisotto (f-17688) 2024-04-05 fim}
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






