unit Unit32;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, smallfunc_xe, Printers, ComCtrls, ShellApi, DB,
  IBCustomDataSet, IBQuery, uConectaBancoSmall;

type
  TForm32 = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    MaskEdit1: TMaskEdit;
    Button5: TButton;
    Button2: TButton;
    Button1: TButton;
    Label11: TLabel;
    DateTimePicker1: TDateTimePicker;
    IBQuery1: TIBQuery;
    IBQuery2: TIBQuery;
    IBQuery3: TIBQuery;
    IBQuery4: TIBQuery;
    IBQuery5: TIBQuery;
    IBQuery6: TIBQuery;
    CheckBox1: TCheckBox;
    cbMovGerencial: TCheckBox;
    qryGerencial: TIBQuery;
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DefinirVisibleGerencial;
    procedure CarregaDadosGerencial;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form32: TForm32;

implementation

uses Unit7, Mais, Unit20, Unit34, StrUtils, uDialogs, uRetornaSQLGerencialInventario;

{$R *.DFM}

procedure TForm32.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm32.CarregaDadosGerencial;
begin
  if cbMovGerencial.Checked then
    Exit;
    
  qryGerencial.Close;
  qryGerencial.SQL.Clear;
  qryGerencial.SQL.Add(TRetornaSQLGerencialInventario.New
                                                     .setData(DateTimePicker1.Date)
                                                     .getSQL);

  qryGerencial.Open;
end;

procedure TForm32.Button5Click(Sender: TObject);
var
  iLinha, iPagina, iTamanho : Integer;
  fTotal : Double;
  fVenda, fCompra, fAltera, fBalcao, fRese, nGerencial : Real;
  fCustoMedio: Real; // Sandro Silva 2023-03-01
  fCustoCompra: Real; // Sandro Silva 2023-03-02
begin
  if not VerificaSeTemImpressora() then
  begin
    //ShowMessage('Não há impressora instalada no windows!'); Mauricio Parizotto 2023-10-25
    MensagemSistema('Não há impressora instalada no windows!',msgAtencao);
    Screen.Cursor             := crDefault;    // Cursor de Aguardo
    Abort;
  end;
  
  Printer.Canvas.Pen.Width  := 1;             // Largura da linha  //
  Printer.Canvas.Font.Name  := 'Courier New'; // Tipo da fonte     //
  Printer.Canvas.Font.Size  := 8;             // Cor da fonte      //
  Printer.Canvas.Font.Color := ClBlack;
  iTamanho := Printer.Canvas.TextWidth('a') * 3;   // Tamanho que cada caractere ocupa na impressão em pontos
  Printer.Title := 'Inventário';                   // Este título é visto no spoool da impressora
  Printer.BeginDoc;                                // Inicia o documento de impressão
  //
  iLinha  := 254;        // Zerezima
  iPagina :=   2;
  fTotal  :=   0;
  //
  ibQuery1.Close;
  ibQuery1.Sql.Clear;
  ibQuery1.SQL.Add('select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD_VENDA from ITENS001, VENDAS where VENDAS.EMITIDA=''S'' and VENDAS.EMISSAO > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and VENDAS.NUMERONF=ITENS001.NUMERONF and VENDAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%'')) group by DESCRICAO');
  ibQuery1.Open;
  //
  ibQuery2.Close;
  ibQuery2.Sql.Clear;
  ibQuery2.SQL.Add('select ITENS002.DESCRICAO, sum(ITENS002.QUANTIDADE)as vQTD_COMPRA from ITENS002, COMPRAS where COMPRAS.EMISSAO > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+ ' and COMPRAS.NUMERONF=ITENS002.NUMERONF and ITENS002.FORNECEDOR=COMPRAS.FORNECEDOR and COMPRAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%'')) group by DESCRICAO');
  ibQuery2.Open;
  //
  ibQuery3.Close;
  ibQuery3.Sql.Clear;
  ibQuery3.SQL.Add('select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD_ALTERA from ALTERACA where ALTERACA.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and TIPO<>'+QuotedStr('BALCAO')+' and TIPO<>'+QuotedStr('VENDA')+' and TIPO<>'+QuotedStr('CANCEL')+' group by DESCRICAO');
  ibQuery3.Open;
  //
  ibQuery5.Close;
  ibQuery5.Sql.Clear;
  ibQuery5.SQL.Add('select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD_BALCAO from ALTERACA where ALTERACA.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') and coalesce(VALORICM, 0) = 0 group by DESCRICAO');
  ibQuery5.Open;
  //
  ibQuery6.Close;
  ibQuery6.Sql.Clear;
  ibQuery6.SQL.Add('select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD_RESE from ITENS001, OS where OS.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and  coalesce(ITENS001.NUMERONF,'+QuotedStr('')+')='+QuotedStr('')+'and OS.NUMERO=ITENS001.NUMEROOS group by DESCRICAO');
  ibQuery6.Open;
  //
  CarregaDadosGerencial;
  //
  ibQuery4.Close;
  ibQuery4.Sql.Clear;
  ibQuery4.SQL.Add('select * from ESTOQUE order by DESCRICAO');
  ibQuery4.Open;
  //
  ibQuery4.First;
  ibQuery4.DisableControls;
  Screen.Cursor := crHourGlass;
  //
  While not ibQuery4.Eof do
  begin
    //
    if iLinha > ( Printer.PageHeight / iTamanho - 8 ) then // é final da pagina
    begin
      if iLinha <> 254 then
      begin
        Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,Replicate(' ',91-3)+'Transporte.:'+ Format('%16.2n',[fTotal]));  // Transporte
        Printer.NewPage;                                   // Eject
      end;
      //
      iLinha := 1;                                         // Inicializa a Linha
      //
      Printer.Canvas.TextOut(iTamanho div 3,iLinha * iTamanho, Copy(AnsiUpperCase(Form7.ibDataSet13NOME.AsString)+Replicate(' ',30),1,30) +
                Replicate(' ',19)    +
                'REGISTRO DE INVENTÁRIO ' +
                Replicate(' ',19)    +
                'Livro.: '+ StrZero(StrToInt(AllTrim('0'+MaskEdit1.Text)),4,0) +
                '   Folha.: ' +
                StrZero(iPagina,3,0));

      iLinha := iLinha + 1;                           // Incrementa a Linha
      Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,'INSC. ESTADUAL.:'      +
                Form7.ibDataSet13IE.AsString      +
                Replicate(' ',10)       +
                'CNPJ(MF):'             +
                Form7.ibDataSet13CGC.AsString     +
                Replicate(' ',10)       +
                'Estoque existente em ' +
                DateToStr(DateTimePicker1.Date));
      iLinha := iLinha + 2;                           // Incrementa a Linha
      Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,'CF             DESCRIÇÃO DO ARTIGO'+Replicate(' ',24)+'     QUANTIDADE   UNIDADE     CUSTO UNITÁRIO    CUSTO TOTAL');
      iLinha := iLinha + 1;                           // Incrementa a Linha
      Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,Replicate(' ',86)+'De transporte:'+ Format('%16.2n',[fTotal]));                       // Linha em branco
      //
      iPagina := iPagina + 1;
      iLinha  := 6;
      //
    end;
    //
    if (ibQuery4.FieldByName('TIPO_ITEM').AsString <> '07') and ((Pos('CONSUMO',UpperCase(ibQuery4.FieldByName('NOME').AsString)) = 0)) then
    begin
      //
      fVenda  := 0;
      fCompra := 0;
      fAltera := 0;
      fBalcao := 0;
      fRese   := 0;
      nGerencial := 0;
      //
      if ibQuery1.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fVenda         := ibQuery1.FieldByName('vQTD_VENDA').AsFloat;
      if ibQuery2.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fCompra        := ibQuery2.FieldByName('vQTD_COMPRA').AsFloat;
      if ibQuery3.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fAltera        := ibQuery3.FieldByName('vQTD_ALTERA').AsFloat;
      if ibQuery5.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fBalcao        := ibQuery5.FieldByName('vQTD_BALCAO').AsFloat;
      if ibQuery6.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fRese          := ibQuery6.FieldByName('vQTD_RESE').AsFloat;
      if not cbMovGerencial.Checked then
      begin
        if qryGerencial.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then
          nGerencial := qryGerencial.FieldByName('vQTD_GERENCIAL').AsFloat;
      end;
      
      if  ((
                  ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                     - fCompra
                     + fVenda
                     + fBalcao
                     + fRese
                     - fAltera
                     + nGerencial
            )
            > 0 ) or (CheckBox1.Checked) then
      begin                   

        // --------------------------- //
        // Pelo custo da última compra //
        // --------------------------- //
        if RadioButton1.Checked then
        begin
          {Sandro Silva 2023-03-02 inicio}
          fCustoCompra := ibQuery4.FieldByName('CUSTOCOMPR').AsFloat;
          if AnsiContainsText(ibQuery4.FieldByName('CUSTOCOMPR').AsString, 'INF') then
            fCustoCompra := 0.00;
          {Sandro Silva 2023-03-02 fim}

          Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,

                     Copy(ibQuery4.FieldByName('CODIGO').AsString+'          ',1,10)                                         +  // CF
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('DESCRICAO').AsString + Replicate(' ',50),1,43)        +  // Descricao
                     Replicate(' ',5) + Format('%8.2n',[

                     ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                     - fCompra
                     + fVenda
                     + fBalcao
                     + fRese
                     - fAltera
                     + nGerencial


                     ])                      +  // Quantidade
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('MEDIDA').AsString+'   ',1,3)             +  // Medida
                     Replicate(' ',4)+ Format('%14.2n',[fCustoCompra]) +  // Custocompr
                     Replicate(' ',3) + Format('%16.2n',[Arredonda(fCustoCompra, StrToInt(Form1.ConfPreco))      // Qtd * CUSTOATUAL
                                                         * (
                                                           ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                           - fCompra
                                                           + fVenda
                                                           + fBalcao
                                                           + fRese
                                                           - fAltera
                                                           )
                                                         ]));
          fTotal  := fTotal + (
                               ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                               - fCompra
                               + fVenda
                               + fBalcao
                               + fRese
                               - fAltera
                               + nGerencial
                              ) * Arredonda(fCustoCompra, StrToInt(Form1.ConfPreco));
        end;
        // ---------------- //
        // Pelo custo médio //
        // ---------------- //
        if RadioButton2.Checked then
        begin
          fCustoMedio := ibQuery4.FieldByName('CUSTOMEDIO').AsFloat;
          if AnsiContainsText(ibQuery4.FieldByName('CUSTOMEDIO').AsString, 'INF') then
            fCustoMedio := 0.00;

          Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,

                     Copy(ibQuery4.FieldByName('CODIGO').AsString+'          ',1,10)                                         +  // CF
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('DESCRICAO').AsString + Replicate(' ',50),1,43)        +  // Descricao
                     Replicate(' ',5) + Format('%8.2n',[
                                                       ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                       - fCompra
                                                       + fVenda
                                                       + fBalcao
                                                       + fRese
                                                       - fAltera
                                                       + nGerencial
                                                       ])                      +  // Quantidade
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('MEDIDA').AsString+'   ',1,3)             +  // Medida
                     Replicate(' ',4)+ Format('%14.2n',[fCustoMedio]) +  // Custocompr
                     Replicate(' ',3) + Format('%16.2n',[Arredonda(fCustoMedio, StrToInt(Form1.ConfPreco))      // Qtd * CUSTOATUAL
                                     * (

                                         ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                         - fCompra
                                         + fVenda
                                         + fBalcao
                                         + fRese
                                         - fAltera
                                         + nGerencial

                                     )]));
          fTotal  :=  fTotal + (ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                         - fCompra
                                         + fVenda
                                         + fBalcao
                                         + fRese
                                         - fAltera
                                         + nGerencial) * Arredonda(fCustoMedio, StrToInt(Form1.ConfPreco));
        end;
        iLinha := iLinha + 1;
      end;
    end;
    //
    ibQuery4.Next;
    //
  end;
  ibQuery4.EnableControls;
  // ----------------- //
  // Totalização final //
  // ----------------- //
  if iLinha <> 254 then
      Printer.Canvas.TextOut(iTamanho div 3, iLinha * iTamanho,
                Replicate(' ',87)   +         //-------------//
                'Total......: '   +           // Total Final //
                 Format('%16.2n',[fTotal]));  //-------------//
  Printer.EndDoc;
  Screen.Cursor := crDefault;
  Close;
end;

procedure TForm32.MaskEdit1Exit(Sender: TObject);
begin
  if Limpanumero(MaskEdit1.Text) = '' then MaskEdit1.Text := '1';
end;

procedure TForm32.FormShow(Sender: TObject);
begin
  Image1.Picture := Form7.imgImprimir.Picture;

  DefinirVisibleGerencial;  
end;

procedure TForm32.DefinirVisibleGerencial;
var
  qryDados: TIBQuery;
begin
  qryDados := CriaIBQuery(Form7.IBTransaction1);
  try
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('SELECT');
    qryDados.SQL.Add('COUNT(NFCE.REGISTRO) AS QTDE');
    qryDados.SQL.Add('FROM NFCE');
    qryDados.SQL.Add('WHERE');
    qryDados.SQL.Add('(NFCE.MODELO=''99'')');
    qryDados.Open;

    cbMovGerencial.Visible := qryDados.FieldByName('QTDE').AsInteger > 0;
    cbMovGerencial.Checked := False;

    CheckBox1.Top := 216;
    cbMovGerencial.Top := 240;

    if not cbMovGerencial.Visible then
      CheckBox1.Top := CheckBox1.Top + 17;
  finally
    FreeAndNil(qryDados);
  end;
end;

procedure TForm32.Button1Click(Sender: TObject);
var
  iLinha, iPagina : Integer;
  fTotal : Double;
  F : TextFile;
  fVenda, fCompra, fAltera, fBalcao, fRese, nGerencial : Real;
  fCustoMedio: Real; // Sandro Silva 2023-03-01
  fCustoCompra: Real; // Sandro Silva 2023-03-02
begin
  //
  DeleteFile(pChar(Form1.sAtual+'\INVENTARIO.TXT'));   // Apaga o arquivo anterior
  AssignFile(F,pChar(Form1.sAtual+'\INVENTARIO.TXT'));
  //
  Rewrite(F);           // Abre para gravação
  //
  iLinha  := 254;
  iPagina :=   2;
  fTotal  :=   0;
  //
  ibQuery1.Close;
  ibQuery1.Sql.Clear;
  ibQuery1.SQL.Add('select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD_VENDA from ITENS001, VENDAS where VENDAS.EMITIDA=''S'' and VENDAS.EMISSAO > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and VENDAS.NUMERONF=ITENS001.NUMERONF and VENDAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%'')) group by DESCRICAO');
  ibQuery1.Open;
  //
  ibQuery2.Close;
  ibQuery2.Sql.Clear;
  ibQuery2.SQL.Add('select ITENS002.DESCRICAO, sum(ITENS002.QUANTIDADE)as vQTD_COMPRA from ITENS002, COMPRAS where COMPRAS.EMISSAO > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+ ' and COMPRAS.NUMERONF=ITENS002.NUMERONF and ITENS002.FORNECEDOR=COMPRAS.FORNECEDOR and COMPRAS.OPERACAO not in (select ICM.NOME from ICM where ICM.INTEGRACAO like(''%=%'')) group by DESCRICAO');
  ibQuery2.Open;
  //
  ibQuery3.Close;
  ibQuery3.Sql.Clear;
  ibQuery3.SQL.Add('select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD_ALTERA from ALTERACA where ALTERACA.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and TIPO<>'+QuotedStr('BALCAO')+' and TIPO<>'+QuotedStr('VENDA')+' and TIPO<>'+QuotedStr('CANCEL')+' group by DESCRICAO');
  ibQuery3.Open;
  //
  ibQuery5.Close;
  ibQuery5.Sql.Clear;
  ibQuery5.SQL.Add('select ALTERACA.DESCRICAO, sum(ALTERACA.QUANTIDADE)as vQTD_BALCAO from ALTERACA where ALTERACA.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and (TIPO='+QuotedStr('BALCAO')+' or TIPO='+QuotedStr('VENDA')+') and coalesce(VALORICM, 0) = 0 group by DESCRICAO');
  ibQuery5.Open;
  //
  ibQuery6.Close;
  ibQuery6.Sql.Clear;
  ibQuery6.SQL.Add('select ITENS001.DESCRICAO, sum(ITENS001.QUANTIDADE)as vQTD_RESE from ITENS001, OS where OS.DATA > '+QuotedStr(DateToStrInvertida(DateTimePicker1.Date))+' and  coalesce(ITENS001.NUMERONF,'+QuotedStr('')+')='+QuotedStr('')+'and OS.NUMERO=ITENS001.NUMEROOS group by DESCRICAO');
  ibQuery6.Open;
  //
  CarregaDadosGerencial;
  //
  ibQuery4.Close;
  ibQuery4.Sql.Clear;
  ibQuery4.SQL.Add('select * from ESTOQUE order by DESCRICAO');
  ibQuery4.Open;
  //
  ibQuery4.First;
  ibQuery4.DisableControls;
  Screen.Cursor := crHourGlass;
  //
  while not ibQuery4.Eof do
  begin
    //
    if iLinha > 66 then // é final da pagina
    begin
      if iLinha <> 254 then
      begin
        Writeln(F,Replicate(' ',1));  // Transporte
        Writeln(F,Replicate(' ',87-3)+'Transporte.:'+ Format('%16.2n',[fTotal]));  // Transporte
        Writeln(F,Replicate(' ',1));  // Transporte
      end;
      //
      Writeln(F,Copy(AnsiUpperCase(Form7.ibDataSet13NOME.AsString)+Replicate(' ',30),1,30) +
                Replicate(' ',19)    +
                'REGISTRO DE INVENTÁRIO ' +
                Replicate(' ',19)    +
                'Livro.: '+ StrZero(StrToInt(AllTrim('0'+MaskEdit1.Text)),4,0) +
                '   Folha.: ' +
                StrZero(iPagina,3,0));
      Writeln(F,'INSC. ESTADUAL.:'      +
                Form7.ibDataSet13IE.AsString      +
                Replicate(' ',10)       +
                'CNPJ(MF):'             +
                Form7.ibDataSet13CGC.AsString     +
                Replicate(' ',10)       +
                'Estoque existente em ' +
                DateToStr(DateTimePicker1.Date));
      Writeln(F,'CÓDIGO         DESCRIÇÃO DO ARTIGO'+Replicate(' ',24)+'     QUANTIDADE   UNIDADE     CUSTO UNITÁRIO   CUSTO TOTAL');

      Writeln(F,Replicate(' ',1));  // Transporte
      Writeln(F,Replicate(' ',87)+'De Transporte:'+ Format('%16.2n',[fTotal]));  // Transporte
      Writeln(F,Replicate(' ',1));  // Transporte

      //
      iPagina := iPagina + 1;
      iLinha  := 6;
      //
    end;
    //
    if (ibQuery4.FieldByName('TIPO_ITEM').AsString <> '07') and ((Pos('CONSUMO',UpperCase(ibQuery4.FieldByName('NOME').AsString)) = 0)) then
    begin
      //
      // --------------------------- //
      // Pelo custo da última compra //
      // --------------------------- //
      //
      fVenda  := 0;
      fCompra := 0;
      fAltera := 0;
      fBalcao := 0;
      fRese   := 0;
      nGerencial := 0;
      //
      if ibQuery1.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fVenda  := ibQuery1.FieldByName('vQTD_VENDA').AsFloat;
      if ibQuery2.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fCompra := ibQuery2.FieldByName('vQTD_COMPRA').AsFloat;
      if ibQuery3.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fAltera := ibQuery3.FieldByName('vQTD_ALTERA').AsFloat;
      if ibQuery5.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fBalcao := ibQuery5.FieldByName('vQTD_BALCAO').AsFloat;
      if ibQuery6.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then fRese   := ibQuery6.FieldByName('vQTD_RESE').AsFloat;
      if not cbMovGerencial.Checked then
      begin
        if qryGerencial.Locate('DESCRICAO',ibQuery4.FieldByName('DESCRICAO').AsString,[]) then
          nGerencial := qryGerencial.FieldByName('vQTD_GERENCIAL').AsFloat;
      end;
      // Formula para calcular a quantidade do dia é a mesma do sintegra
      if  ((
                  ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                     - fCompra
                     + fVenda
                     + fBalcao
                     + fRese
                     - fAltera
                     + nGerencial
            )
            > 0 ) or (CheckBox1.Checked) then
      begin
        if RadioButton1.Checked then
        begin
          {Sandro Silva 2023-03-02 inicio}
          fCustoCompra := ibQuery4.FieldByName('CUSTOCOMPR').AsFloat;
          if AnsiContainsText(ibQuery4.FieldByName('CUSTOCOMPR').AsString, 'INF') then
            fCustoCompra := 0.00;
          {Sandro Silva 2023-03-02 fim}

          Writeln(F,
                     Copy(ibQuery4.FieldByName('CODIGO').AsString+'          ',1,10)                                         +  // CF
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('DESCRICAO').AsString + Replicate(' ',50),1,43)        +  // Descricao
                     Replicate(' ',5) + Format('%8.2n',[
                                                         ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                         - fCompra
                                                         + fVenda
                                                         + fBalcao
                                                         + fRese
                                                         - fAltera
                                                         + nGerencial
                                                       ])                      +  // Quantidade

                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('MEDIDA').AsString+'   ',1,3)             +  // Medida
                     Replicate(' ',4)+ Format('%14.2n',[fCustoCompra]) +  // Custocompr
                     Replicate(' ',3) + Format('%16.2n',[Arredonda(fCustoCompra, StrToInt(Form1.ConfPreco))      // Qtd * CUSTOATUAL
                                                         * (
                                                           ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                           - fCompra
                                                           + fVenda
                                                           + fBalcao
                                                           + fRese
                                                           - fAltera
                                                           + nGerencial
                                                           )
                                                        ]));
          fTotal  :=  fTotal + (
                                 ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                 - fCompra
                                 + fVenda
                                 + fBalcao
                                 + fRese
                                 - fAltera
                                 + nGerencial
                               ) * Arredonda(fCustoCompra,StrToInt(Form1.ConfPreco));
        end;
        // ---------------- //
        // Pelo custo médio //
        // ---------------- //
        if RadioButton2.Checked then
        begin

          {Sandro Silva 2023-03-01 inicio}
          fCustoMedio := ibQuery4.FieldByName('CUSTOMEDIO').AsFloat;
          if AnsiContainsText(ibQuery4.FieldByName('CUSTOMEDIO').AsString, 'INF') then
            fCustoMedio := 0.00;
          {Sandro Silva 2023-03-01 fim}

          Writeln(F,
                     Copy(ibQuery4.FieldByName('CODIGO').AsString+'          ',1,10)                               +  // CF
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('DESCRICAO').AsString + Replicate(' ',50),1,43)  +  // Descricao
                     Replicate(' ',5) + Format('%8.2n',[
                                                         ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                         - fCompra
                                                         + fVenda
                                                         + fBalcao
                                                         + fRese
                                                         - fAltera
                                                         + nGerencial
                                                       ])                                                   +  // Quantidade
                     Replicate(' ',5) + Copy(ibQuery4.FieldByName('MEDIDA').AsString+'   ',1,3)             +  // Medida
                     Replicate(' ',4)+ Format('%14.2n',[fCustoMedio]) +  // Custocompr
                     Replicate(' ',3) + Format('%16.2n',[
                                                         Arredonda(fCustoMedio, StrToInt(Form1.ConfPreco))     // Qtd * CUSTOATUAL
                                                         * (
                                                            ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                                                            - fCompra
                                                            + fVenda
                                                            + fBalcao
                                                            + fRese
                                                            - fAltera
                                                            + nGerencial
                                                            )
                                                        ]
                                                        ));
          fTotal  := fTotal + (
                               ibQuery4.FieldByName('QTD_ATUAL').AsFloat
                               - fCompra
                               + fVenda
                               + fBalcao
                               + fRese
                               - fAltera
                               + nGerencial
                              ) * Arredonda(fCustoMedio, StrToInt(Form1.ConfPreco));
        end;
        iLinha := iLinha + 1;
      end;
    end;
    //
    ibQuery4.Next;
    //
  end;
  //
  ibQuery4.EnableControls;
  // ----------------- //
  // Totalização final //
  // ----------------- //
  if iLinha <> 254 then
      Writeln(F,Replicate(' ',1));
      Writeln(F,
                Replicate(' ',87)   +         //-------------//
                'Total......: '   +         // Total Final //
                 Format('%16.2n',[fTotal]));  //-------------//
  CloseFile(F);  // Fecha o arquivo
  //
  if FileExists(Form1.sAtual+'\INVENTARIO.TXT') then ShellExecute( 0, 'Open','notepad.exe',PChar('INVENTARIO.TXT'), '', SW_SHOW);
  //
  Screen.Cursor := crDefault;
  Close;
end;

procedure TForm32.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Date;
end;

end.

