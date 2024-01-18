unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, DB, IBCustomDataSet, SmallFunc_xe,
  Buttons, IBQuery, StrUtils;

type
  TForm14 = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Button1: TBitBtn;
    ibDataSet027: TIBDataSet;
    ibDataSet027DESCRICAO: TStringField;
    ibDataSet027QUANTIDADE: TFloatField;
    ibDataSet027TOTAL: TFloatField;
    ibDataSet027DATA: TDateField;
    ibDataSet027PEDIDO: TStringField;
    ibDataSet027ALIQUICM: TStringField;
    ibDataSet027REGISTRO: TIBStringField;
    ibDataSet027CST_ICMS: TIBStringField;
    ibDataSet027CST_PIS_COFINS: TIBStringField;
    ibDataSet027ALIQ_PIS: TIBBCDField;
    ibDataSet027ALIQ_COFINS: TIBBCDField;
    DataSource027: TDataSource;
    ibDataSet027CNPJ: TIBStringField;
    ibDataSet027SERIE: TIBStringField;
    ibDataSet027SUBSERIE: TIBStringField;
    ibDataSet027CFOP: TIBStringField;
    ibDataSet027TIPO: TIBStringField;
    ibDataSet027CODIGO: TIBStringField;
    DBGrid2: TDBGrid;
    IBDataSet1: TIBDataSet;
    DataSource1: TDataSource;
    ibDataSet027UNITARIO: TFloatField;
    ibDataSet027MEDIDA: TIBStringField;
    ibDataSet027ITEM: TIBStringField;
    IBQPESQUISA: TIBQuery;
    ibDataSet027CSOSN: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ibDataSet027BeforeInsert(DataSet: TDataSet);
    procedure ibDataSet027NewRecord(DataSet: TDataSet);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ibDataSet027TOTALChange(Sender: TField);
    procedure ibDataSet027QUANTIDADEChange(Sender: TField);
    procedure ibDataSet027AfterPost(DataSet: TDataSet);
    procedure ibDataSet027AfterInsert(DataSet: TDataSet);
    procedure ibDataSet027BeforeDelete(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ibDataSet027BeforePost(DataSet: TDataSet);
    procedure ibDataSet027UNITARIOChange(Sender: TField);
  private
    procedure ExcluirLinhasSemProduto;
    { Private declarations }
  public
    sPedido,
    sSerie,
    sSubSerie,
    sCFOP,
    sCNPJ : String;
    dData : tDateTime;
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation

uses fiscal, ufuncoesfrente;

{$R *.dfm}

procedure TForm14.Button1Click(Sender: TObject);
begin
  try
    //
    if Application.MessageBox(Pchar('Tem certeza que as informações digitadas estão corretas?'+ chr(10)
                                   +'Elas não poderão ser alteradas depois que forem processadas.'+ chr(10)
                                   + chr(10)
                                   +'Se estiver em dúvida clique no botão <Não>.'
                                   + Chr(10))
                                   ,'Atenção',mb_YesNo + mb_DefButton2 + MB_ICONWARNING) = IDYES then
    begin

      // Validar se as notas já foram lançadas anteriormente

      ibDataSet027.DisableControls;

      ExcluirLinhasSemProduto;

      ibDataSet027.First;
      //
      while not ibDataSet027.Eof do // disable
      begin

        IBQPESQUISA.Close;
        IBQPESQUISA.SQL.Text :=
          'select DATA, HORA ' +
          'from ALTERACA ' +
          'where TIPO = ''VENDA'' ' +
          ' and PEDIDO = ' + QuotedStr(RightStr('000000' + ibDataSet027.FieldByName('PEDIDO').AsString, 6)) +
          ' and SERIE = ' + QuotedStr(ibDataSet027.FieldByName('SERIE').AsString) +
          ' and coalesce(SUBSERIE, '''') = ' + QuotedStr(ibDataSet027.FieldByName('SUBSERIE').AsString) +
          ' and DATA <> ' + QuotedStr(FormatDateTime('yyyy-mm-dd', ibDataSet027.FieldByName('DATA').AsDateTime));
        IBQPESQUISA.Open;
        if IBQPESQUISA.FieldByName('DATA').AsString <> '' then
        begin
          if Application.MessageBox(PChar('Nota Fiscal Modelo 02 já lançada em ' + FormatDateTime('dd/mm/yyyy', IBQPESQUISA.FieldByName('DATA').AsDateTime) + ' ' + IBQPESQUISA.FieldByName('HORA').AsString + #13 +
                                          'Série: ' + ibDataSet027.FieldByName('SERIE').AsString  + #13 +
                                          'Subsérie: ' + ibDataSet027.FieldByName('SUBSERIE').AsString + #13 +
                                          'Número: ' + RightStr('000000' + ibDataSet027.FieldByName('PEDIDO').AsString, 6) + #13 + #13 +
                                          'Isso poderá gerar problemas na validação do SPED FISCAL ou SINTEGRA' + #13 + #13 +
                                          'Deseja corrigir?'), 'Atenção! Nota Fiscal duplicada', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES then
          begin
            DBGrid1.SetFocus;
            Abort;
          end;
        end;
      
        ibDataSet027.Next;
      end;

      //
      ibDataSet1.First;
      while not ibDataSet1.Eof do // disable
      begin
        //
        Form1.ibDataSet28.Append;
        //
        Form1.ibDataSet28.FieldByName('DATA').AsDateTime    := Date;
        Form1.ibDataSet28.FieldByName('PEDIDO').AsString    := ibDataSet1.FieldByName('NF').AsString;
        Form1.ibDataSet28.FieldByName('FORMA').AsString     := '02 Dinheiro NF-e';
        Form1.ibDataSet28.FieldByName('VALOR').Asfloat      := ibDataSet1.FieldByName('TOTAL').AsFloat;
        Form1.ibDataSet28.FieldByName('HORA').AsString      := FormatDateTime('HH:nn:ss', Time); // Sandro Silva 2018-11-30
        //
        Form1.ibDataSet28.Post;
        //
        ibDataSet1.Next;
      end;
      //
      ibDataSet027.First;
      //
      while not ibDataSet027.Eof do // disable
      begin
        //
        try
          //
          if AllTrim(ibDataSet027CODIGO.AsString)<>'' then
          begin
            //
            Form1.ibDataSet4.Close;
            Form1.ibDataSet4.SelectSQL.Clear;
            Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(ibDataSet027CODIGO.AsString)+' ');
            Form1.ibDataSet4.Open;
            //
            if Form1.ibDataSet4CODIGO.AsString = ibDataSet027CODIGO.AsString then
            begin
              Form1.ibDataSet4.Edit;
              Form1.ibDataSet4QTD_ATUAL.AsFloat    := Form1.ibDataSet4QTD_ATUAL.AsFloat - ibDataSet027QUANTIDADE.AsFloat; // Mantem a sincronia
              Form1.ibDataSet4ULT_VENDA.AsDateTime := ibDataSet027DATA.AsDateTime; // Mantem a sincronia
              Form1.ibDataSet4.Post;
            end;
            //
            ibDataSet027.Edit;
            ibDataSet027TIPO.AsString  := 'VENDA'; // Resolvi este problema baseado no sincronia
            //
          end;
          //
        except end;

        try
          if (ibDataSet027.State in [dsInsert, dsEdit]) = False then
            ibDataSet027.Edit;
          // Assina o registro referente a NF modelo 02
          AssinaRegistro('ALTERACA', ibDataSet027, True);
        except
        end;

        //
        ibDataSet027.Next;
        //
      end;
      //
      Commitatudo(True); // Form14.Button1Click()
      Close;
      //
    end;
    //
  finally
    ibDataSet027.EnableControls;
  end;
end;

procedure TForm14.FormActivate(Sender: TObject);
var
  Cursor: TCursor;
begin
  Cursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    //
    //
    ibDataSet1.Close;
    ibDataSet1.SelectSQL.Clear;
    ibDataSet1.Selectsql.Add('select DATA as "Data", PEDIDO as "NF", sum(TOTAL) as "Total", count(REGISTRO) as "Itens" from ALTERACA where TIPO=''LOKED'' and SERIE<>'''' group by DATA, SERIE, SUBSERIE, PEDIDO order by PEDIDO');
    ibDataSet1.Open;
    //
    ibDataSet027.Close;
    ibDataSet027.SelectSQL.Clear;
    ibDataSet027.Selectsql.Add('select * from ALTERACA where TIPO=''LOKED'' and SERIE<>'''' order by DATA, SERIE, SUBSERIE, PEDIDO, ITEM');
    ibDataSet027.Open;
    //
    ibDataSet027.Last;
    //
    Form14.sPedido    := ibDataSet027.FieldByName('PEDIDO').AsString;
    Form14.sSerie     := ibDataSet027.FieldByName('SERIE').AsString;
    Form14.sSubSerie  := ibDataSet027.FieldByName('SUBSERIE').AsString;
    Form14.sCFOP      := ibDataSet027.FieldByName('CFOP').AsString;
    Form14.sCNPJ      := ibDataSet027.FieldByName('CNPJ').AsString;
    //
    if ibDataSet027.FieldByName('DATA').AsString <> '' then
    begin
      Form14.dData      := ibDataSet027.FieldByName('DATA').AsDateTime;
    end else
    begin
      Form14.dData      := Date;
    end;
    //
  finally
    Screen.Cursor := Cursor;
  end;
end;

procedure TForm14.ibDataSet027BeforeInsert(DataSet: TDataSet);
begin
  //
  try
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSql.Clear;
    Form1.ibDataset99.SelectSql.Add('select gen_id(G_ALTERACA,1) from rdb$database');
    Form1.ibDataset99.Open;
    Form1.sProximo027 := StrZero(StrToInt(Form1.ibDataSet99.FieldByname('GEN_ID').AsString),10,0);
    Form1.ibDataset99.Close;
    //
    try
      Form1.ibDataSet99.Close;
      Form1.ibDataSet99.SelectSql.Clear;
      Form1.ibDataset99.SelectSql.Add('select gen_id(G_HASH_ALTERACA,1) from rdb$database');
      Form1.ibDataset99.Open;
      HasHs('ALTERACA', True); // Sandro Silva 2016-02-26
    except end;
    //
  except end;
  //
end;

procedure TForm14.ibDataSet027NewRecord(DataSet: TDataSet);
begin
  ibDataSet027.FieldByName('REGISTRO').AsString := Form1.sProximo027;
  ibDataSet027.FieldByName('CFOP').AsString     := '5102';
  ibDataSet027.FieldByName('TIPO').AsString     := 'LOKED';
  //
  ibDataSet027.FieldByName('DATA').AsDateTime   := Form14.dData;
  ibDataSet027.FieldByName('PEDIDO').AsString   := Form14.sPedido;
  ibDataSet027.FieldByName('SERIE').AsString    := Form14.sSerie;
  ibDataSet027.FieldByName('SUBSERIE').AsString := Form14.sSubSerie;
  ibDataSet027.FieldByName('CFOP').AsString     := Form14.sCFOP;
  ibDataSet027.FieldByName('CNPJ').AsString     := Form14.sCNPJ;
  //
end;

procedure TForm14.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I : Integer;
begin
  //
  if Key = VK_ESCAPE then
  begin
    Close;
  end;
  //
  if (Key = VK_RETURN) or (Key = VK_TAB) or (Key = VK_DOWN) or (Key = VK_UP) then
  begin
    //
    ibDataSet027.Edit;
    ibDataSet027.UpdateRecord;
    ibDataSet027.FieldByName('PEDIDO').AsString := FormataNumeroDoCupom(StrToInt(LimpaNumero('0'+ibDataSet027.FieldByName('PEDIDO').AsString))); // Sandro Silva 2021-12-01 ibDataSet027.FieldByName('PEDIDO').AsString := StrZero(StrToInt(LimpaNumero('0'+ibDataSet027.FieldByName('PEDIDO').AsString)),6,0);
    //
    if DbGrid1.SelectedIndex = 4 then
    begin
      //
      ibDataSet027.Edit;
      ibDataSet027.UpdateRecord;
      //
      if Alltrim(ibDataSet027DESCRICAO.AsString) <> '' then
      begin
        if (Length(Alltrim(ibDataSet027DESCRICAO.AsString)) <= 5) and (LimpaNumero(Alltrim(ibDataSet027DESCRICAO.AsString))<>'') then
        begin
          //
          // Procura por código
          //
          if Strzero(StrToInt(LimpaNumero('0'+ibDataSet027DESCRICAO.AsString)),5,0) <> '00000' then
          begin
            //
            Form1.ibDAtaSet4.Close;
            Form1.ibDataSet4.SelectSQL.Clear;
            Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where CODIGO='+QuotedStr(Strzero(StrToInt(LimpaNumero('0'+ibDataSet027DESCRICAO.AsString)),5,0))+' ');
            Form1.ibDAtaSet4.Open;
            //
            if Form1.ibDataSet4.FieldByName('CODIGO').AsString = Strzero(StrToInt(LimpaNumero('0'+ibDataSet027DESCRICAO.AsString)),5,0) then
            begin
              ibDataSet027.Edit;
              ibDataSet027.FieldByName('DESCRICAO').AsString := Form1.ibDataSet4.FieldByName('DESCRICAO').AsString;
              ibDataSet027.FieldByName('CODIGO').AsString    := Form1.ibDataSet4.FieldByName('CODIGO').AsString;
              ibDataSet027.FieldByName('UNITARIO').AsFloat   := Form1.ibDataSet4.FieldByName('PRECO').AsFloat;// Sandro Silva 2017-11-09 Polimig
              ibDataSet027.FieldByName('REFERENCIA').Clear;
              if tRIM(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString) <> '' then
                ibDataSet027.FieldByName('REFERENCIA').AsString    := Form1.ibDataSet4.FieldByName('REFERENCIA').AsString;

            end else
            begin
              ibDataSet027.FieldByName('DESCRICAO').AsString := '';
              ibDataSet027.FieldByName('CODIGO').AsString    := '';
              ShowMessage('Produto não cadastrado.');
            end;
            //
          end;
        end else
        begin
          //
          // Procura pela descrição
          //
          Form1.ibDAtaSet4.Close;
          Form1.ibDataSet4.SelectSQL.Clear;
          Form1.ibDataSet4.SelectSQL.Add('select * from ESTOQUE where DESCRICAO='+QuotedStr(ibDataSet027DESCRICAO.AsString)+' ');
          Form1.ibDAtaSet4.Open;
          //
          if Form1.ibDataSet4.FieldByName('DESCRICAO').AsString = ibDataSet027DESCRICAO.AsString then
          begin
            ibDataSet027.Edit;
            ibDataSet027.FieldByName('DESCRICAO').AsString := Form1.ibDataSet4.FieldByName('DESCRICAO').AsString;
            ibDataSet027.FieldByName('CODIGO').AsString    := Form1.ibDataSet4.FieldByName('CODIGO').AsString;
            ibDataSet027.FieldByName('UNITARIO').AsFloat   := Form1.ibDataSet4.FieldByName('PRECO').AsFloat;// Sandro Silva 2017-11-09 Polimig
            ibDataSet027.FieldByName('REFERENCIA').Clear;
            if tRIM(Form1.ibDataSet4.FieldByName('REFERENCIA').AsString) <> '' then
              ibDataSet027.FieldByName('REFERENCIA').AsString    := Form1.ibDataSet4.FieldByName('REFERENCIA').AsString;
          end else
          begin
            ibDataSet027.FieldByName('DESCRICAO').AsString := '';
            ibDataSet027.FieldByName('CODIGO').AsString    := '';
            ShowMessage('Produto não cadastrado.');
          end;
          //
        end;
        //
        DBGrid1.Update;
        //
      end;
    end;
    //
  end;
  //
  if KEY = VK_RETURN then
  begin
    //
    I := DbGrid1.SelectedIndex;
    DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
    //
    if I = DbGrid1.SelectedIndex then
    begin
      DbGrid1.SelectedIndex := 0;
      ibDAtaSet027.Next;
      if ibDataSet027.EOF then
        ibDataSet027.Append;
    end;
  end;
  //
  {Sandro Silva 2015-10-22 inicio}
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
  begin
    // Para não gerar "evidências (?) no relatório Registros do PAF"  
    try
      if ibDataSet027.FieldByName('CODIGO').AsString = '' then
      begin
        ExcluirLinhasSemProduto
      end
      else
        ibDataSet027.Delete;
    except
    end;
    Key := 0;
  end;
  {Sandro Silva 2015-10-22 final}
end;

procedure TForm14.ibDataSet027TOTALChange(Sender: TField);
begin
  {Sandro Silva 2017-11-09 inicio Polimig
  // movido para unitario
  if ibDataSet027TOTAL.AsFloat < 0 then
  begin
    ibDataSet027TOTAL.AsFloat := 0;
    ibDataSet027UNITARIO.AsFloat := 0;
  end;
  //
  // Sandro Silva 2017-11-09 Polimig  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027TOTAL.AsFloat > 0) then ibDataSet027UNITARIO.AsFloat := ibDataSet027TOTAL.AsFloat / ibDataSet027QUANTIDADE.AsFloat;
  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027UNITARIO.AsFloat > 0) then
    ibDataSet027TOTAL.AsFloat := StrToFloat(FormatFloat('0.00', (ibDataSet027UNITARIO.AsFloat * ibDataSet027QUANTIDADE.AsFloat)));
  //
  }
end;

procedure TForm14.ibDataSet027QUANTIDADEChange(Sender: TField);
begin
  //
  if ibDataSet027QUANTIDADE.AsFloat < 0 then ibDataSet027QUANTIDADE.AsFloat := 0;
  // Sandro Silva 2017-11-09 Polimig  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027TOTAL.AsFloat > 0) then ibDataSet027UNITARIO.AsFloat := ibDataSet027TOTAL.AsFloat / ibDataSet027QUANTIDADE.AsFloat;
  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027UNITARIO.AsFloat > 0) then
    ibDataSet027TOTAL.AsFloat := StrToFloat(FormatFloat('0.00', (ibDataSet027UNITARIO.AsFloat * ibDataSet027QUANTIDADE.AsFloat)));
  //
end;

procedure TForm14.ibDataSet027AfterPost(DataSet: TDataSet);
var
  sOp : String;
begin
  //
  Form14.sPedido    := ibDataSet027.FieldByName('PEDIDO').AsString;
  Form14.sSerie     := ibDataSet027.FieldByName('SERIE').AsString;
  Form14.sSubSerie  := ibDataSet027.FieldByName('SUBSERIE').AsString;
  Form14.sCFOP      := ibDataSet027.FieldByName('CFOP').AsString;
  Form14.sCNPJ      := ibDataSet027.FieldByName('CNPJ').AsString;
  Form14.dData      := ibDataSet027.FieldByName('DATA').AsDateTime;
  //
  sOp := '';
  //
  if AllTrim(Form1.ibDataSet4.FieldByname('ST').AsString) <> '' then // Se o ST não estiver em branco   //
  begin                                    // Procurar na tabela de ICM para  //
    //
    Form1.IbDataSet14.Close;                         // saber qual a aliquota associada //
    Form1.IbDataSet14.SelectSQL.Clear;
    Form1.IbDataSet14.SelectSQL.Add('select * from ICM where ST='+QuotedStr(Form1.ibDataSet4.FieldByname('ST').AsString));
    Form1.IbDataSet14.Open;
    //
    if Form1.IbDataSet14.FieldByname('ST').AsString = Form1.ibDataSet4.FieldByname('ST').AsString then  // Pode ocorrer um erro    //
    begin                                             // se o estado do emitente //
      try                                             // Não estiver cadastrado  //
        sOP := StrZero( (Form1.IbDataSet14.FieldByname(Form1.ibDataSet13.FieldByname('ESTADO').AsString+'_').AsFloat * 100) / 100 * Form1.IbDataSet14.FieldByname('BASE').AsFloat ,4,0);
      except sOP  := '' end;
    end;
  end;
  //
  if sOP = '' then // Se o sOP continuar em branco é porque não estava cadastrado //
  begin            // na tabela de ICM ou estava em branco                        //
    //
    Form1.IbDataSet14.Close;                         // saber qual a aliquota associada //
    Form1.IbDataSet14.SelectSQL.Clear;
    Form1.IbDataSet14.SelectSQL.Add('select * from ICM where CFOP='+QuotedStr('5102')+' or CFOP='+QuotedStr('6102')+'');
    Form1.IbDataSet14.Open;
    //
    if (AllTrim(Form1.IbDataSet14.FieldByName('CFOP').AsString) = '5102') or (AllTrim(Form1.ibDataSet14.FieldByName('CFOP').AsString) = '6102') then
    begin
      try
        sOP := StrZero( (Form1.IbDataSet14.FieldByname(Form1.ibDataSet13.FieldByname('ESTADO').AsString+'_').AsFloat * 100) / 100 * Form1.IbDataSet14.FieldByname('BASE').AsFloat ,4,0);
      except sOP  := '' end;
    end;
    //
  end;
  //
  // Grava a ALIQUICM no ALTERACA
  //
  try
    //
    if ibDataSet027.FieldByname('DESCRICAO').AsString = Form1.ibDataSet4.FieldByname('DESCRICAO').AsString then
    begin
      if Form1.ibDataSet14.FieldByName('BASEISS').AsFloat = 100 then ibDataSet027.FieldByName('ALIQUICM').AsString := 'ISS'; // Isso é pra serviço cadastrado
      //
      ibDataSet027.Edit;
      ibDataSet027.FieldByName('ALIQUICM').AsString := sOP;
      //
      if Copy(allTrim(Form1.ibDataSet4.FieldByname('ST').AsString),1,1) = 'I' then ibDataSet027.FieldByName('ALIQUICM').AsString := 'I';
      if Copy(allTrim(Form1.ibDataSet4.FieldByname('ST').AsString),1,1) = 'F' then ibDataSet027.FieldByName('ALIQUICM').AsString := 'F';
      if Copy(allTrim(Form1.ibDataSet4.FieldByname('ST').AsString),1,1) = 'N' then ibDataSet027.FieldByName('ALIQUICM').AsString := 'N';
      //
      try
        ibDataSet027.FieldByName('MEDIDA').AsString              := Form1.ibDataSet4.FieldByName('MEDIDA').AsString;
        ibDataSet027.FieldByName('CST_ICMS').AsString            := Form1.ibDataSet4.FieldByName('CST').AsString;
        ibDataSet027.FieldByName('CST_PIS_COFINS').AsString      := Form1.ibDataSet4.FieldByName('CST_PIS_COFINS_SAIDA').AsString;
        ibDataSet027.FieldByName('ALIQ_PIS').AsFloat             := Form1.ibDataSet4.FieldByName('ALIQ_PIS_SAIDA').AsFloat;
        ibDataSet027.FieldByName('ALIQ_COFINS').AsFloat          := Form1.ibDataSet4.FieldByName('ALIQ_COFINS_SAIDA').AsFloat;
      except
        ShowMessage('Erro ao gravar PIS/COFINS');
      end;
    end;
    //
  except end;
  //
  {Sandro Silva 2015-10-27 inicio
  ibDataSet1.Close;
  ibDataSet1.SelectSQL.Clear;
  ibDataSet1.Selectsql.Add('select DATA as "Data", PEDIDO as "NF", sum(TOTAL) as "Total", count(REGISTRO) as "Itens" from ALTERACA where TIPO=''LOKED'' and SERIE<>'''' group by DATA, SERIE, SUBSERIE, PEDIDO order by PEDIDO');
  ibDataSet1.Open;
  }
  ibDataSet1.Close;
  ibDataSet1.SelectSQL.Clear;
  ibDataSet1.SelectSQL.Text :=
    'select DATA as "Data", PEDIDO as "NF", sum(TOTAL) as "Total", count(REGISTRO) as "Itens" ' +
    'from ALTERACA ' +
    'where TIPO = ''LOKED'' ' +
    ' and SERIE <> '''' ' +
    ' and coalesce(CODIGO, '''') <> '''' ' +
    'group by DATA, SERIE, SUBSERIE, PEDIDO ' +
    'order by PEDIDO';
  ibDataSet1.Open;
  {Sandro Silva 2015-10-27 final}
  //
  try
    if ibDataSet027.State in [dsInsert, dsEdit] then // 2015-05-12 Apenas quando em edição
      ibDataSet027.FieldByName('ITEM').AsString := StrZero(StrToIntDef(ibDataSet1.FieldByname('Itens').AsString, 0), 6, 0);
  except end;
  //
  dbGrid2.Update;
  //
end;

procedure TForm14.ibDataSet027AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('CAIXA').AsString := Form1.sCaixa;
end;

procedure TForm14.ibDataSet027BeforeDelete(DataSet: TDataSet);
begin
  try
    Form1.ibDataSet99.Close;
    Form1.ibDataSet99.SelectSql.Clear;
    Form1.ibDataset99.SelectSql.Add('select gen_id(G_HASH_ALTERACA,-1) from rdb$database');
    Form1.ibDataset99.Open;
    HasHs('ALTERACA', True); // Sandro Silva 2016-02-26    
  except end;
end;

procedure TForm14.ExcluirLinhasSemProduto;
// Para não gerar "evidências (?) no relatório Registros do PAF"
var
  iRecno: Integer;
begin
  {Sandro Silva 2015-08-10 inicio}
  //Primeiro exclui as linhas criadas sem um produto preenchido
  if ibDataSet027.Active then
  begin
    iRecno := ibDataSet027.RecNo;
    ibDataSet027.First;
    //
    while ibDataSet027.Eof = False do // disable
    begin
      if (ibDataSet027.FieldByName('CODIGO').AsString = '') then
      begin
        try
          ibDataSet027.Delete;
        except

        end;
      end
      else
        ibDataSet027.Next;
    end;
    {Sandro Silva 2015-08-10 final}

    try
      ibDataSet027.Last;
      if ibDataSet027.RecordCount < iRecno then
        ibDataSet027.RecNo := iRecno - 1
      else
        ibDataSet027.RecNo := iRecno;
    except
    end;
  end;
end;

procedure TForm14.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ExcluirLinhasSemProduto; // Para não gerar "evidências (?) no relatório Registros do PAF"
end;

procedure TForm14.ibDataSet027BeforePost(DataSet: TDataSet);
begin
  AssinaRegistro('ALTERACA',DataSet, True); // Sandro Silva 2016-02-26 
end;

procedure TForm14.ibDataSet027UNITARIOChange(Sender: TField);
begin
  if ibDataSet027UNITARIO.AsFloat < 0 then
  begin
    ibDataSet027TOTAL.AsFloat := 0;
    ibDataSet027UNITARIO.AsFloat := 0;
  end;
  //
  // Sandro Silva 2017-11-09 Polimig  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027TOTAL.AsFloat > 0) then ibDataSet027UNITARIO.AsFloat := ibDataSet027TOTAL.AsFloat / ibDataSet027QUANTIDADE.AsFloat;
  if (ibDataSet027QUANTIDADE.AsFloat > 0) and (ibDataSet027UNITARIO.AsFloat > 0) then
    ibDataSet027TOTAL.AsFloat := StrToFloat(FormatFloat('0.00', (ibDataSet027UNITARIO.AsFloat * ibDataSet027QUANTIDADE.AsFloat)));
  //  
end;

end.



