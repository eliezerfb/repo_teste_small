{Unit de impressão genérica para Grids dos cadastros}
unit Unit14;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, ExtCtrls, Menus, IniFiles,
  StdCtrls, smallfunc_xe, Mask, DBCtrls,  SMALL_DBEdit, Shellapi, JPEG
  , IBQuery // Sandro Silva 2022-12-19
  ;

type
  TForm14 = class(TForm)
    Panel2: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FbQuebraLinha: Boolean;
    function RetornarQuebraLinhaHTML: String;
    function GetDetalheOS(sNumeroOS, sCampoTecnico : string; iColunas: integer): string;
  public
    property QuebraLinha: Boolean read FbQuebraLinha write FbQuebraLinha;
  end;

var
  Form14: TForm14;

implementation

uses
  Unit7, Unit16, Unit9, Mais, Unit39, Unit19, Unit24, Mais3
  //,Unit10
  , uRelatorioCatalogoProdudos, uFuncoesBancoDados;

{$R *.DFM}

procedure TForm14.Button1Click(Sender: TObject);
var
  iContador, iColunas, Pagina, Tamanho, I, J, Linha, Coluna: Integer;
  sGRUPO, sOp1, sOp2, sOp, sI: String;
  rRect: Trect;
  MyBookmark: TBookmark;
  fTotal: array [0..100] of Double; //
  rTotal: array [0..100] of Double; //
  Mais1Ini: TiniFile;
  F: TextFile;
  jCampos: Integer;
  bEntrei: Boolean;
  fRecebido, fReceber, fAtrasado: Double;
  bImprimir: boolean;
  sCor: String;

  BlobStream: TStream;
  jp, JP2: TJPEGImage;

  IBQCLIENTE: TIBQuery;
  sCampoTecnico : string;
  SmallIni : tIniFile;
begin
  // Campos extras no estoque //
  Button1.Enabled := False;
  iContador := 0;
  if (form7.sModulo = 'RECEBER') or (form7.sModulo = 'ESTOQUE') or (form7.sModulo = 'CLIENTES') or (form7.sModulo = 'FORNECED') then
    jCampos := 6
  else
    jCampos := 0;
  IBQCLIENTE := Form7.CriaIBQuery(Form7.IBDataSet2.Transaction); // Sandro Silva 2022-12-19

  Screen.Cursor             := crHourGlass;    // Cursor de Aguardo
  Form7.ArquivoAberto.DisableControls;
  MyBookmark := Form7.ArquivoAberto.GetBookmark;
  // -------- //
  // Zeresima //
  // -------- //
  for I := 0 to 100 do
    fTotal[I] := 0;
  for I := 0 to 100 do
    rTotal[I] := 0;
  sGRUPO := '';

  {$Region'//// Arquivo TXM ////'}
  if not Form1.bHtml1 then
  begin
    if (Form7.Caption = 'Catálogo de produtos') then
    begin
      {
       // DAILON 2023-08-04
       NESTE CASO QUANDO FOR TXT UTILIZA O GERADOR DE RELATORIO GENERICO.
       PARA HTML DEVIDO A NAO SER NA FORMA GRID (COLUNAS E LINHAS) FOGE DO PADRAO,
       PORTANTO IRA GERAR DE FORMA MANUAL MESMO EM HTML.
      }

      frmRelatorioCatalogoProduto := TfrmRelatorioCatalogoProduto.Create(nil);
      try
        frmRelatorioCatalogoProduto.DataBase    := Form7.IBDatabase1;
        frmRelatorioCatalogoProduto.DataSet     := Form7.ArquivoAberto;
        frmRelatorioCatalogoProduto.Usuario     := Usuario;
        frmRelatorioCatalogoProduto.TextoFiltro := AllTrim(TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True));
        frmRelatorioCatalogoProduto.Imprimir;
      finally
        FreeAndNil(frmRelatorioCatalogoProduto);
      end;
    end
    else
    begin
      // Em arquivo
      AssignFile(F,pChar(Senhas.UsuarioPub+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
      Rewrite(F);                  // Abre para gravação
      // Titulo //
      WriteLn(F,AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString)+' - '+Form7.Caption));
      WriteLn(F,' ');

      // Cabeçalho conforme o DisplaiLabel
      sOp1 := '';
      sOp2 := '';
      for I := 1 to Form7.iCampos + jCampos do
      begin
        if I <= Form7.iCampos then
        begin
          if Form7.ArquivoAberto.Fields[I-1].Visible = True then
          begin
            sOp2 := sOp2 + Replicate('-',Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).DisplayWidth)+ ' ';
            sOp1 := sOp1 +
                  Copy(
                       Form7.ArquivoAberto.Fields[I-1].DisplayLabel + Replicate(' ',Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).DisplayWidth
                   + 1)
                   , 1,
                    Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).DisplayWidth
                    )+' '; // Display Labels
          end;
        end else
        begin
          {$Region'//// Estoque ////'}
           if Form7.sModulo = 'ESTOQUE' then
           begin
             // 1 Parcela
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox4.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;
           
             // 2 Parcela
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox5.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;

             // 3 Parcela
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox6.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- ';  // Display Labels
             end;

             // QTD X PRECO
             if (I = Form7.iCampos + 4) then if Form39.CheckBox1.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Qtd X preço   '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;

             // QTD X CUSTO COMPRA
             if (I = Form7.iCampos + 5) then if Form39.CheckBox2.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Qtd X custo   '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;

             // QTD X CUSTO MEDIO
             if (I = Form7.iCampos + 6) then if Form39.CheckBox3.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Qtd X médio   '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;
           end;
           {$Endregion}

          {$Region'//// Clientes e Fornecedores ////'}
           if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
           begin
             // Recebido
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox4.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;
             // Receber
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox5.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;
             // Atrasado
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + Copy(Form39.CheckBox6.Caption,1,13)+' '; // Display Labels
               sOP2 := sOp2 + '------------- '; // Display Labels
             end;
           end;
          {$Endregion}

          {$Region'//// Receber ////'}
           if (Form7.sModulo = 'RECEBER') then
           begin
             // Endereco
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Endereço' + Replicate(' ',22)+' '; // Display Labels
               sOP2 := sOp2 + Replicate('-',30)+' '; // Display Labels
             end;

             // Cidade
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Cidade' + Replicate(' ',14)+' '; // Display Labels
               sOP2 := sOp2 + Replicate('-',20)+' '; // Display Labels
             end;

             // Telefone
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Telefone         '; // Display Labels
               sOP2 := sOp2 + Replicate('-',16)+' '; // Display Labels
             end;

             // Contato
             if (I = Form7.iCampos + 4) then if Form39.CheckBox7.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'Contato         '; // Display Labels
               sOP2 := sOp2 + Replicate('-',15)+' '; // Display Labels
             end;

             // WhatsApp
             if (I = Form7.iCampos + 5) then if Form39.CheckBox8.Checked then
             begin
               { Imprime o display Label no cabeçalho }
               sOP1 := sOp1 + 'WhatsApp       '; // Display Labels
               sOP2 := sOp2 + Replicate('-',16)+' '; // Display Labels
             end;
           end;
          {$Endregion}
        end;
      end;

      WriteLn(F,sOP1); // Linha de labels
      WriteLn(F,sOP2); // Linha pontilhada
      // Zeresima
      for I := 0 to 30 do fTotal[I] := 0;

      Form7.ArquivoAberto.First;             // Início do arquivo
      while (not Form7.ArquivoAberto.Eof) and (Form14.Caption <> 'Cancelar')  do   // Vai até o final do arquivo
      begin
        Application.ProcessMessages;
        // ----------------------------------------------------------- //
        // Calcula os valores do contas a receber se estiver abilitado //
        // ----------------------------------------------------------- //
        fRecebido := 0;
        fReceber  := 0;
        fAtrasado := 0;

        bImprimir := True;

        if Form7.sModulo = 'CLIENTES' then
          if Form7.ibDataSet2ATIVO.AsString='1' then
            bImprimir := False;
        if Form7.sModulo = 'ESTOQUE'  then
          if Form7.ibDataSet4ATIVO.AsString='1' then
            bImprimir := False;
        if Form7.sModulo = 'RECEBER'  then
          if Form7.ibDataSet7ATIVO.AsString='1' then
            bImprimir := False;

        // Divide em grupos
        if (form7.sModulo = 'ESTOQUE')  or (Form7.Caption = 'Cardápio') then
        begin
          if pos('order by upper(NOME)',Form7.ibDataSet4.SelectSQL.Text) <> 0 then
          begin
            if sGRUPO <> Form7.ibDataSet4NOME.AsString then
            begin
              WriteLn(F,''); // Linha de dados
              WriteLn(F,Form7.ibDataSet4NOME.AsString); // Linha de dados
              WriteLn(F,''); // Linha de dados
              sGRUPO := Form7.ibDataSet4NOME.AsString;
            end;
          end;
        end;

        // Divide o contas a receber por cliente
        if (form7.sModulo = 'RECEBER') then
        begin
          if pos('order by NOME',Form7.ibDataSet7.SelectSQL.Text) <> 0 then
          begin
            if sGRUPO <> Form7.ibDataSet7NOME.AsString then
            begin
              WriteLn(F,''); // Linha de dados
              WriteLn(F,Form7.ibDataSet7NOME.AsString); // Linha de dados
              WriteLn(F,''); // Linha de dados
              sGRUPO := Form7.ibDataSet7NOME.AsString;
            end;
          end;
        end;

        if bImprimir then
        begin
          if Form7.sModulo = 'CLIENTES' then
          begin
            if (Form39.CheckBox4.Checked = True) or (Form39.CheckBox5.Checked = True) or
                (Form39.CheckBox6.Checked = True) then
            begin
              Form7.IBDataSet99.Close;
              Form7.IBDataSet99.SelectSQL.Clear;
              Form7.IBDataSet99.SelectSQL.Add('select * from RECEBER where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+'  and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' ');
              Form7.IBDataSet99.Open;

              while not Form7.ibDataSet99.Eof do
              begin
                Application.ProcessMessages;
                if Form7.ibDataSet99.FieldByname('VALOR_RECE').AsFloat = 0 then
                begin
                  fReceber  := fReceber + Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat;
                  if Form7.ibDataSet99.FieldByname('VENCIMENTO').AsDateTime < Date then fAtrasado := fAtrasado + Form7.ibDataSet99.FieldByname('VALOR_DUPL').AsFloat;
                end;
                fRecebido := fRecebido + Form7.ibDataSet99.FieldByname('VALOR_RECE').AsFloat;
                Form7.ibDataSet99.Next;
              end;
            end;
          end;
          // ----------------------------------------------------------- //
          // Calcula os valores do contas a receber se estiver habilitado //
          // ----------------------------------------------------------- //
          sOP := '';

          for I := 1 to Form7.iCampos  + jCampos  do
          begin
            if I <= Form7.iCampos then
            begin
              if Form7.ArquivoAberto.Fields[I-1].Visible = True then
              begin
                if TipoCampoFloat(Form7.ArquivoAberto.Fields[I-1]) then // Sandro Silva 2024-04-29 if Form7.ArquivoAberto.Fields[I-1].DataType =  ftFloat then
                begin
                  // formata o preço e a quantidade
                  sI := '2';
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'INDEXADOR'  then sI := '4';
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOCOMPR' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOCOMPR.DisplayFormat))-6);
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOMEDIO' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOMEDIO.DisplayFormat))-6);
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'PRECO'      then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4PRECO.DisplayFormat))-6);
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_ATUAL'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);
                  if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_MINIM'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);
                  try
                    if StrToInt(sI) < 0 then sI := '0';
                  except sI := '0' end;
                
                  sOp := sOP   + Format('%'+IntToStr(Form7.ArquivoAberto.Fields[I-1].DisplayWidth)+'.'+sI+'n',[Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).AsFloat])+ ' ';
                  if Form7.ArquivoAberto.Fields[I-1].FieldName <> 'PRECO' then fTotal[I] :=  fTotal[I] + Form7.ArquivoAberto.Fields[I-1].AsFloat;
                end else
                  sOp  := sOP + Copy(Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).AsString+Replicate(' ',254),
                         1,Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).DisplayWidth) + ' ';
              end;
            end else
            begin
              {$Region'//// Estoque ////'}
              if Form7.sModulo = 'ESTOQUE' then
              begin
                // formata o preço e a quantidade
                sI := IntToStr(Length(AllTrim(Form7.ibDataSet4PRECO.DisplayFormat))-6);
                try
                  if StrToInt(sI) < 0 then sI := '0';
                except sI := '0' end;
                // 1 Parcela
                if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                begin
                  sOp := sOP   + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label1.Caption) / 100)+1) ]) + ' '
                end;
                // 2 Parcela
                if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                begin
                  sOp := sOP   + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label2.Caption) / 100)+1) ]) + ' '
                end;
                // 3 Parcela
                if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                begin
                  sOp := sOP   + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label3.Caption) / 100)+1) ]) + ' '
                end;
                // QTD X PRECO
                if (I = Form7.iCampos + 4) and (Form39.CheckBox1.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[Form7.ibDataSet4PRECO.AsFloat * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + ' ';
                  fTotal[I] := fTotal[I] + Form7.ibDataSet4PRECO.AsFloat * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                end;
                // QTD X CUSTO COMPRA
                if (I = Form7.iCampos + 5) and (Form39.CheckBox2.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + ' ';
                  fTotal[I] := fTotal[I] +  Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                end;
                // QTD X CUSTO MEDIO
                if (I = Form7.iCampos + 6) and (Form39.CheckBox3.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[Arredonda(Form7.ibDataSet4CUSTOMEDIO.AsFloat,StrToInt(form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + ' ';
                  fTotal[I] :=  fTotal[I] + Arredonda(Form7.ibDataSet4CUSTOMEDIO.AsFloat,StrToInt(form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                end;
              end;
              {$Endregion}

              {$Region'//// Clientes Fornecedores ////'}
              if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
              begin
                // Recebido
                if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[fRecebido]) + ' ';
                  fTotal[I] :=  fTotal[I] + fRecebido;
                end;
                // Receber
                if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[fReceber]) + ' ';
                  fTotal[I] :=  fTotal[I] + fReceber;
                end;
                // Atrasado
                if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                begin
                  sOp := sOP   + Format('%13.2n',[fAtrasado]) + ' ';
                  fTotal[I] :=  fTotal[I] +  fAtrasado;
                end;
              end;
              {$Endregion}

              {$Region'//// Receber ////'}
              if (Form7.sModulo = 'RECEBER') then
              begin
                // Procura pelo nome no cadastro de clientes //
                if (Form39.CheckBox4.Checked)
                  or (Form39.CheckBox5.Checked)
                  or (Form39.CheckBox6.Checked)
                  or (Form39.CheckBox7.Checked)
                  or (Form39.CheckBox8.Checked) then
                begin
                  Form7.ibDataSet2.Close;
                  Form7.ibDataSet2.Selectsql.Clear;
                  Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
                  Form7.ibDataSet2.Open;
                end;

                if Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString then
                begin
                  // Endereço
                  if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                  begin
                    sOp := sOP   + Copy(Form7.ibDataSet2ENDERE.AsString+Replicate(' ',30),1,30) + ' ';
                  end;

                  // Cidade
                  if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                  begin
                    sOp := sOP   + Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',30),1,20) + ' ';
                  end;

                  // Telefone
                  if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                  begin
                    sOp := sOP   + Copy(Form7.ibDataSet2FONE.AsString+Replicate(' ',30),1,16) + ' ';
                  end;

                  // Contato
                  if (I = Form7.iCampos + 4) and (Form39.CheckBox7.Checked) then
                  begin
                    sOp := sOP   + Copy(Form7.IBDataSet2CONTATO.AsString+Replicate(' ',30),1,15) + ' ';
                  end;

                  // WhatsApp
                  if (I = Form7.iCampos + 5) and (Form39.CheckBox8.Checked) then
                  begin
                    sOp := sOP   + Copy(Form7.IBDataSet2WHATSAPP.AsString+Replicate(' ',30),1,16) + ' ';
                  end;
                end;
              end;
              {$Endregion}
            end;
          end;

          WriteLn(F,sOP); // Linha de dados
        end;

        if bImprimir then
          iContador := iContador + 1;

        Form7.ArquivoAberto.Next;
      end;

      if (Form7.sModulo <> 'NOTA')
      and (Form7.sModulo <> 'CONFOS')
      and (Form7.sModulo <> 'CONFRECIBO')
      and (Form7.Caption <> 'Lista de preços')
      and (Form7.Caption <> 'Receitas')
      and (Form7.Caption <> 'Cardápio')
      and (Form7.sModulo <> 'VENDEDOR')
      then
      begin
        sOP    := '';
      
        for I := 1 to Form7.iCampos  + jCampos  do
        begin
          if I <= Form7.iCampos then
          begin
            if Form7.ArquivoAberto.Fields[I-1].Visible = True then
            begin
              // Imprime o total
              if (Pos('SALD',Form7.ArquivoAberto.Fields[I-1].Name) = 0) and (fTotal[I] <> 0) then
                sOP := sOP + Format('%'+IntToStr(Form7.ArquivoAberto.Fields[I-1].DisplayWidth)+'.2n',[fTotal[I]]) + ' '
              else
                sOP := sOP + Replicate(' ',Form7.ArquivoAberto.Fields[I-1].DisplayWidth)+' ';
            end;
          end else
          begin
            {$Region'//// Estoque ////'}
            if Form7.sModulo = 'ESTOQUE' then
            begin
              // 1 Parcela
              if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then sOP := sOP + Replicate(' ',14);
              // 2 Parcela
              if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then sOP := sOP + Replicate(' ',14);
              // 2 Parcela
              if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then sOP := sOP + Replicate(' ',14);
              // QTD X PRECO
              if (I = Form7.iCampos + 4) and (Form39.CheckBox1.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]]) + ' ' else sOP := sOP + Replicate(' ',14);
              // QTD X CUSTO COMPRA
              if (I = Form7.iCampos + 5) and (Form39.CheckBox2.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]]) + ' '  else sOP := sOP + Replicate(' ',14);
              // QTD X CUSTO MEDIO
              if (I = Form7.iCampos + 6) and (Form39.CheckBox3.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]])  + ' ' else sOP := sOP + Replicate(' ',14);
            end;
            {$Endregion}

            {$Region'//// Clientes Forncedores ////'}
            if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
            begin
              // Recebido
              if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]]) + ' ' else sOP := sOP + Replicate(' ',14);
              // Receber
              if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]]) + ' '  else sOP := sOP + Replicate(' ',14);
              // Atrasado
              if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                if fTotal[I] <> 0 then sOP := sOP + Format('%13.2n',[fTotal[I]])  + ' ' else sOP := sOP + Replicate(' ',14);
            end;
            {$Endregion}
          end;
        end;
      end else sOP := '';

      WriteLn(F,sOP2); // Linha tracejada
      WriteLn(F,sOP);  // Linha de totais

      WriteLn(F,'Número de registros: '+IntToStr(iContador));
      // Linha da data //
      WriteLn(F,Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
          + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
          + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time));
      // Condição do relatório
      WriteLn(F,AllTrim(TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True)));

      CloseFile(F);                                    // Fecha o arquivo
      if Form14.Caption <> 'Cancelar' then
      begin
        ShellExecute( 0, 'Open',pChar(Senhas.UsuarioPub+'.txt'),'','', SW_SHOWMAXIMIZED);
      end;
    end;
  end;
  {$Endregion}

  {$Region'//// Arquivo HTML ////'}
  if Form1.bHtml1 then
  begin
    CriaJpg('logotip.jpg');
    iColunas := 0;
    AssignFile(F,pChar(Senhas.UsuarioPub+'.HTM'));  
    Rewrite(F);                  // Abre para gravação
    Writeln(F,'<html]><head><title>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString)+' - '+Form7.Caption)+'</title></head>');
    // Titulo //
    WriteLn(F,'<body bgcolor="#FFFFFF" vlink="#FF0000" leftmargin="0"><center>');
    WriteLn(F,'<img src="logotip.jpg" alt="'+AllTrim(Form7.ibDataSet13NOME.AsString)+'">');
    WriteLn(F,'<br><font face="verdana" size=3 color=#000000><b>'+AnsiUpperCase(AllTrim(Form7.ibDataSet13NOME.AsString))+'</b></font>');
    WriteLn(F,'<br><font face="verdana" size=4 color=#000000><b>'+AllTrim(Form7.Caption)+'</b></font>');
    WriteLn(F,'<br>');              // Linha em branco
    WriteLn(F,'<br>');              // Linha em branco
    // Calcula a largura datamanho da ta bela

    // Cabeçalho conforme o DisplaiLabel
    if (Form7.Caption = 'Catálogo de produtos') or (Form7.Caption = 'Álbum de fotografias')  or (Form7.Caption = 'Cardápio') or (Form7.Caption = 'Receitas') then
    begin
      // Catálogo de produtos
      WriteLn(F,'<table border=0 cellspacing=0 cellpadding=4>');
    end else
    begin
      WriteLn(F,'<table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=4>');
      WriteLn(F,' <tr bgcolor=#' + Form1.sHtmlCor + '   align=left>');

      for I := 1 to Form7.iCampos + jCampos do
      begin
        if I <= Form7.iCampos then
        begin
          if Form7.ArquivoAberto.Fields[I-1].Visible = True then
          begin
            {Sandro Silva 2022-12-19 inicio}
            if Form7.sModulo = 'RECEBER' then
            begin
              if (Form7.ArquivoAberto.Fields[I-1].FieldName = 'NOME') and (Form1.DisponivelSomenteParaNos) then
              begin
                WriteLn(F,'        <th><font face="verdana" size=2>CNPJ/CPF</font></th>');
                iColunas := iColunas + 1;
              end;
            end;
            {Sandro Silva 2022-12-19 fim}
            WriteLn(F,'        <th><font face="verdana" size=2>'+Form7.ArquivoAberto.Fields[I-1].DisplayLabel+'</font></th>');
            iColunas := iColunas + 1;
          end;
        end else
        begin
          {$Region'//// Estoque ////'}
           if Form7.sModulo = 'ESTOQUE' then
           begin
             // 1 Parcela
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox4.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
             // 2 Parcela
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox5.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
             // 3 Parcela
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox6.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
             // QTD X PRECO
             if (I = Form7.iCampos + 4) then if Form39.CheckBox1.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>Qtd X preço</font></th>');
               iColunas := iColunas + 1;
             end;
             // QTD X CUSTO COMPRA
             if (I = Form7.iCampos + 5) then if Form39.CheckBox2.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>Qtd X custo</font></th>');
               iColunas := iColunas + 1;
             end;
             // QTD X CUSTO MEDIO
             if (I = Form7.iCampos + 6) then if Form39.CheckBox3.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>Qtd X médio</font></th>');
               iColunas := iColunas + 1;
             end;
           end;
          {$Endregion}

          {$Region'//// Clientes e Fornecedores ////'}
           if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
           begin
             // Recebido
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox4.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
             // Receber
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox5.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
             // Atrasado
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox6.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;
           end;
          {$Endregion}

          {$Region'//// Receber ////'}
           if (Form7.sModulo = 'RECEBER') then
           begin
             // Endereço
             if (I = Form7.iCampos + 1) then if Form39.CheckBox4.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox4.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;

             // Cidade
             if (I = Form7.iCampos + 2) then if Form39.CheckBox5.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox5.Caption,1,13) +'</font></th>');
               iColunas := iColunas + 1;
             end;

             // Telefone
             if (I = Form7.iCampos + 3) then if Form39.CheckBox6.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox6.Caption+Replicate(' ',15),1,15) +'</font></th>');
               iColunas := iColunas + 1;
             end;

             // Contato
             if (I = Form7.iCampos + 4) then if Form39.CheckBox7.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox7.Caption+Replicate(' ',15),1,15) +'</font></th>');
               iColunas := iColunas + 1;
             end;

             // WhatsApp
             if (I = Form7.iCampos + 5) then if Form39.CheckBox8.Checked then
             begin
               WriteLn(F,'        <th><font face="verdana" size=2>'+ Copy(Form39.CheckBox8.Caption+Replicate(' ',15),1,15) +'</font></th>');
               iColunas := iColunas + 1;
             end;
           end;
          {$Endregion}
        end;
      end;

      WriteLn(F,' </tr>');
    end;

    // Início do arquivo
    Form7.ArquivoAberto.First;
    while (not Form7.ArquivoAberto.Eof) and (Form14.Caption <> 'Cancelar') do   // Vai até o final do arquivo
    begin
      Application.ProcessMessages;

      if (Form7.Caption = 'Receitas') then
      begin
        Form7.ibDataSet99.Close;
        Form7.ibDataSet99.SelectSQL.Clear;
        Form7.IbDataSet99.SelectSQL.Add('select * from COMPOSTO where CODIGO='+QuotedStr(Form7.ibDataSet4CODIGO.AsString)+' ');
        Form7.IbDataSet99.Open;
      end;

      if (Form7.Caption = 'Receitas') and (Form7.IbDataSet99.FieldByname('CODIGO').AsString <> Form7.ibDataSet4CODIGO.AsString) then
      begin
        // Não Faz nada
        bImprimir := False;
      end else
      begin
        fRecebido := 0;
        fReceber  := 0;
        fAtrasado := 0;

        {$Region'//// Estoque ////'}
        if (form7.sModulo = 'ESTOQUE')  or (Form7.Caption = 'Cardápio') or (Form7.Caption = 'Receitas') then
        begin
          if pos('order by upper(NOME)',Form7.ibDataSet4.SelectSQL.Text) <> 0 then
          begin
            if sGRUPO <> Form7.ibDataSet4NOME.AsString then
            begin
              if FileExists(LimpaNome(Form7.ibDataSet4NOME.AsString)+'.BMP') then
              begin
                WriteLn(F,'    </tr>');
                WriteLn(F,'    <tr bgcolor=#FFFFFF>');
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' colspan='+StrZero(iColunas,3,0)+'>'+'<img src="'+LimpaNome(Form7.ibDataSet4NOME.AsString)+'.BMP'+'" alt="'+AllTrim(Form7.ibDataSet4NOME.AsString)+'">'+'<br></td>');
              end;

              WriteLn(F,'    </tr>');
              WriteLn(F,'    <tr bgcolor='+ Form1.sHtmlCor +'>');
              WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' colspan='+StrZero(iColunas,3,0)+'><font face="verdana" size=2 ><b>'+AllTrim(Form7.ibDataSet4NOME.AsString)+'<br></td>');
              sGRUPO := Form7.ibDataSet4NOME.AsString;
            end;
          end;
        end;
        {$Endregion}

        {$Region'//// Receber ////'}
        if (form7.sModulo = 'RECEBER') then
        begin
          if pos('order by NOME',Form7.ibDataSet7.SelectSQL.Text) <> 0 then
          begin
            if sGRUPO <> Form7.ibDataSet7NOME.AsString then
            begin
              if sGrupo <> '' then
              begin
                WriteLn(F,'    </tr>');
                WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+'>');
                for I := 1 to Form7.iCampos  + jCampos  do
                begin
                  if I <= Form7.iCampos then
                  begin
                    if Form7.ArquivoAberto.Fields[I-1].Visible = True then
                    begin
                      // Imprime o total
                      if (Pos('SALD',Form7.ArquivoAberto.Fields[I-1].Name) = 0) and (fTotal[I] - rTotal[I] <> 0) then
                          WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                              + Format('%13.'+sI+'n',[fTotal[I]-rTotal[I]]) + '<br></font></td>')
                      else
                          WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><br><font face="verdana" size=2></font></td>');

                      rTotal[I] := fTotal[I]
                    end;
                  end else
                  begin
                    if (Form7.sModulo = 'RECEBER') then
                    begin
                      if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then WriteLn(F,'        <td align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Endereço
                      if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then WriteLn(F,'        <td align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Cidade
                      if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then WriteLn(F,'        <td align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Telefone
                      if (I = Form7.iCampos + 4) and (Form39.CheckBox7.Checked) then WriteLn(F,'        <td align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Contato
                      if (I = Form7.iCampos + 5) and (Form39.CheckBox8.Checked) then WriteLn(F,'        <td align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // WhatsApp
                    end;
                  end;
                end;
              end;
              WriteLn(F,'    </tr>');
              WriteLn(F,'    <tr bgcolor=#FFFFFF>');
              WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' colspan='+StrZero(iColunas,3,0)+'><font face="verdana" size=2 ><b>'+AllTrim(Form7.ibDataSet7NOME.AsString)+'<br></td>');
              sGRUPO := Form7.ibDataSet7NOME.AsString;
            end;
          end;
        end;
        {$Endregion}

        bImprimir := True;

        if Form7.sModulo = 'CLIENTES' then
          if Form7.ibDataSet2ATIVO.AsString = '1' then
            bImprimir := False;
        if Form7.sModulo = 'ESTOQUE'  then
          if Form7.ibDataSet4ATIVO.AsString = '1' then
            bImprimir := False;
        if Form7.sModulo = 'RECEBER'  then
          if Form7.ibDataSet7ATIVO.AsString = '1' then
            bImprimir := False;

        if bImprimir then
        begin
          {$Region'//// Clientes ////'}
          if Form7.sModulo = 'CLIENTES' then
          begin
            if (Form39.CheckBox4.Checked = True) or (Form39.CheckBox5.Checked = True) or
                (Form39.CheckBox6.Checked = True) then
            begin
              Form7.IBDataSet100.Close;
              Form7.IBDataSet100.SelectSQL.Clear;
              Form7.IBDataSet100.SelectSQL.Add('select * from RECEBER where NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+'  and coalesce(HISTORICO,''XXX'')<>''NFE NAO AUTORIZADA'' ');
              Form7.IBDataSet100.Open;

              while not Form7.ibDataSet100.Eof do
              begin
                Application.ProcessMessages;
                if Form7.ibDataSet100.FieldByname('VALOR_RECE').AsFloat = 0 then
                begin
                  fReceber  := fReceber + Form7.ibDataSet100.FieldByname('VALOR_DUPL').AsFloat;
                  if Form7.ibDataSet100.FieldByname('VENCIMENTO').AsDateTime < Date then fAtrasado := fAtrasado + Form7.ibDataSet100.FieldByname('VALOR_DUPL').AsFloat;
                end;
                fRecebido := fRecebido + Form7.ibDataSet100.FieldByname('VALOR_RECE').AsFloat;
                Form7.ibDataSet100.Next;
              end;
            end;
          end;
          {$Endregion}

          // ----------------------------------------------------------- //
          // Calcula os valores do contas a receber se estiver abilitado //
          // ----------------------------------------------------------- //
          if (Form7.Caption = 'Catálogo de produtos') or (Form7.Caption = 'Álbum de fotografias') or (Form7.Caption = 'Cardápio')  or (Form7.Caption = 'Receitas') then
          begin
            {$Region'//// Estoque ////'}
            WriteLn(F,'<tr bgcolor=#FFFFFF>');
            WriteLn(F,' <td '+RetornarQuebraLinhaHTML+' vAlign=Center Height=200 Width=200>');
            begin
              if (Form7.Caption = 'Catálogo de produtos') or (Form7.Caption = 'Cardápio')  or (Form7.Caption = 'Receitas') then
              begin
                if Form7.ibDataset4FOTO.BlobSize <> 0 then
                begin
                  BlobStream:= Form7.ibDataset4.CreateBlobStream(Form7.ibDataset4FOTO,bmRead);
                  jp2 := TJPEGImage.Create;
                  try
                    jp2.LoadFromStream(BlobStream);
                    Form7.ImgProduto.Picture.Assign(jp2);
                  finally
                    BlobStream.Free;
                    jp2.Free;
                  end;
                end else
                  Form7.ImgProduto.Picture := Form7.ImgSemProduto.Picture;

                Form7.ImgProduto.Picture.SaveToFile('_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg');

                if Form7.ImgProduto.Picture.Width > Form7.ImgProduto.Picture.Height then
                begin
                  WriteLn(F,'<img src="'+'_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'+'" alt="'+AllTrim(Form7.ibDataSet4DESCRICAO.AsString)+'" width='+StrZero((Form7.ImgProduto.Picture.Width * (200 / Form7.ImgProduto.Picture.Width)),10,0)+' Height='+StrZero((Form7.ImgProduto.Picture.Height* (200 / Form7.ImgProduto.Picture.Width)),10,0)+'>');
                end else
                begin
                  WriteLn(F,'<img src="'+'_t_'+Form7.ibDataset4CODIGO.AsString+'.jpg'+'" alt="'+AllTrim(Form7.ibDataSet4DESCRICAO.AsString)+'" width='+StrZero((Form7.ImgProduto.Picture.Width * (200 / Form7.ImgProduto.Picture.Height)),10,0)+' Height='+StrZero((Form7.ImgProduto.Picture.Height* (200 / Form7.ImgProduto.Picture.Height)),10,0)+'>');
                end;
              end;

              if (Form7.Caption = 'Álbum de fotografias') then
              begin
                if Form7.ibDataset2FOTO.BlobSize <> 0 then
                begin
                  BlobStream:= Form7.ibDataset2.CreateBlobStream(Form7.ibDataset2FOTO,bmRead);
                  jp2 := TJPEGImage.Create;
                  try
                    jp2.LoadFromStream(BlobStream);
                    Form7.ImgProduto.Picture.Assign(jp2);
                  finally
                    BlobStream.Free;
                    jp2.Free;
                  end;
                end else Form7.ImgProduto.Picture := Form7.ImgSemProduto.Picture;

                Form7.ImgProduto.Picture.SaveToFile('_t_'+Form7.ibDataset2REGISTRO.AsString+'.jpg');

                if Form7.ImgProduto.Picture.Width > Form7.ImgProduto.Picture.Height then
                begin
                  WriteLn(F,'<img src="'+'_t_'+Form7.ibDataset2REGISTRO.AsString+'.jpg'+'" alt="'+AllTrim(Form7.ibDataSet2NOME.AsString)+'" width='+StrZero((Form7.ImgProduto.Picture.Width * (200 / Form7.ImgProduto.Picture.Width)),10,0)+' Height='+StrZero((Form7.ImgProduto.Picture.Height* (200 / Form7.ImgProduto.Picture.Width)),10,0)+'>');
                end else
                begin
                  WriteLn(F,'<img src="'+'_t_'+Form7.ibDataset2REGISTRO.AsString+'.jpg'+'" alt="'+AllTrim(Form7.ibDataSet2NOME.AsString)+'" width='+StrZero((Form7.ImgProduto.Picture.Width * (200 / Form7.ImgProduto.Picture.Height)),10,0)+' Height='+StrZero((Form7.ImgProduto.Picture.Height* (200 / Form7.ImgProduto.Picture.Height)),10,0)+'>');
                end;
              end;
            end;

            WriteLn(F,' </td>');
            WriteLn(F,' <td '+RetornarQuebraLinhaHTML+' vAlign=Center>');

            for I := 1 to Form7.iCampos + jCampos do
            begin
              if I <= Form7.iCampos then
              begin
                if Form7.ArquivoAberto.Fields[I-1].Visible = True then
                begin
                  if TipoCampoFloat(Form7.ArquivoAberto.Fields[I-1]) then // Sandro Silva 2024-04-29 if Form7.ArquivoAberto.Fields[I-1].DataType =  ftFloat then
                  begin
                    sI := '2';
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'INDEXADOR'  then sI := '4';
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOCOMPR' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOCOMPR.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOMEDIO' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOMEDIO.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'PRECO'      then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4PRECO.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_ATUAL'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_MINIM'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);

                    WriteLn(F,'    <font face="verdana" size=2>'+Form7.ArquivoAberto.Fields[I-1].DisplayLabel+': '+Format('%'+IntToStr(Form7.ArquivoAberto.Fields[I-1].DisplayWidth)+'.'+sI+'n',[Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).AsFloat])+'</font><br>');
                  end else
                  begin
                    WriteLn(F,'    <font face="verdana" size=2>'+Form7.ArquivoAberto.Fields[I-1].DisplayLabel+': '+Form7.ArquivoAberto.Fields[I-1].AsString +'</font><br>');
                  end;
                end;
              end;
            end;

            WriteLn(F,' </td>');

            // Ingredientes
            if (Form7.Caption = 'Receitas') then
            begin
              WriteLn(F,'  <td '+RetornarQuebraLinhaHTML+' width=100></td>');
              WriteLn(F,'  <td>');

              if Form7.Livrodereceitas1.Caption = 'Relatório de composição' then
              begin
                WriteLn(F,'   <br><b>Composição</b><br>');
              end else
              begin
                WriteLn(F,'   <br><b>Ingredientes</b><br>');
              end;

              while not Form7.IBDataSet99.Eof do
              begin
                WriteLn(F,'  <br>'+Form7.IBDataSet99.FieldByname('QUANTIDADE').AsString+'  '+Form7.IBDataSet99.FieldByname('DESCRICAO').AsString);
                Form7.IBDataSet99.Next;
              end;

              WriteLn(F,' </td>');
            end;

            WriteLn(F,'</tr>');
            {$Endregion}
          end else
          begin
            WriteLn(F,'    <tr bgcolor=#FFFFFF>');

            for I := 1 to Form7.iCampos  + jCampos  do
            begin
              if I <= Form7.iCampos then
              begin
                if Form7.ArquivoAberto.Fields[I-1].Visible = True then
                begin
                  if TipoCampoFloat(Form7.ArquivoAberto.Fields[I-1]) then // Sandro Silva 2024-04-29 if Form7.ArquivoAberto.Fields[I-1].DataType =  ftFloat then
                  begin
                    // formata o preço e a quantidade
                    sI := '2';
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'INDEXADOR'  then sI := '4';
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOCOMPR' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOCOMPR.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'CUSTOMEDIO' then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4CUSTOMEDIO.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'PRECO'      then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4PRECO.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_ATUAL'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);
                    if Form7.ArquivoAberto.Fields[I-1].FieldName = 'QTD_MINIM'  then sI := IntToStr(Length(AllTrim(Form7.ibDataSet4QTD_ATUAL.DisplayFormat))-6);
                    try
                      if StrToInt(sI) < 0 then sI := '0';
                    except sI := '0' end;
                    //
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right valign=top><font face="verdana" size=2>'+ Format('%'+IntToStr(Form7.ArquivoAberto.Fields[I-1].DisplayWidth)+'.'+sI+'n',[Form7.ArquivoAberto.FieldByName(Form7.ArquivoAberto.Fields[I-1].FieldName).AsFloat])+'<br></font></td>');
                    if Form7.ArquivoAberto.Fields[I-1].FieldName <> 'PRECO' then
                      fTotal[I] := fTotal[I] + Form7.ArquivoAberto.Fields[I-1].AsFloat;
                  end else
                  begin
                    if Form7.ArquivoAberto.Fields[I-1].DisplayWidth > 50 then
                      sCor := 'bgcolor=#'+Form1.sHtmlCor+' width=250' else sCor := '';
         
                    if (Form7.sModulo = 'RECEBER') then
                    begin
                      if (Form7.ArquivoAberto.Fields[I-1].DisplayName = 'Cliente') and (Form1.DisponivelSomenteParaNos) then
                      begin
                        IBQCLIENTE.Close;
                        IBQCLIENTE.SQL.Text :=
                          'select CGC ' +
                          'from CLIFOR ' +
                          'where NOME = ' + QuotedStr(Form7.ArquivoAberto.Fields[I-1].AsString);
                        IBQCLIENTE.Open;
                        WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=left valign=top '+sCor+'><font face="verdana" size=2>'+ IBQCLIENTE.FieldByName('CGC').AsString +'<br></font></td>');
                        WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=left valign=top '+sCor+'><font face="verdana" size=2>' + StrTran(Form7.ArquivoAberto.Fields[I - 1].AsString, Chr(10), '<br>') + '<br></font></td>');
                      end
                      else
                        WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=left valign=top '+sCor+'><font face="verdana" size=2>'+StrTran(Form7.ArquivoAberto.Fields[I-1].AsString,Chr(10),'<br>')+'<br></font></td>');
                    end
                    else
                    begin
                      if Form7.ArquivoAberto.Fields[I-1].DisplayName = 'e-mail' then
                        WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=left valign=top width=250><font face="verdana" size=2><a href="mailto:'+StrTran(AllTrim(Form7.ArquivoAberto.Fields[I-1].AsString),';',', ')+'">'+StrTran(AllTrim(Form7.ArquivoAberto.Fields[I-1].AsString),';',', ')+'<br></font></td>')
                      else
                        WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=left valign=top '+sCor+'><font face="verdana" size=2>'+StrTran(Form7.ArquivoAberto.Fields[I-1].AsString,Chr(10),'<br>')+'<br></font></td>');
                    end;
                    {Sandro Silva 2022-12-19 fim}
                  end;
                end;
              end else
              begin
                {$Region'//// Estoque ////'}
                if Form7.sModulo = 'ESTOQUE' then
                begin
                  // formata o preço e a quantidade
                  sI := IntToStr(Length(AllTrim(Form7.ibDataSet4PRECO.DisplayFormat))-6);
                  try
                    if StrToInt(sI) < 0 then sI := '0';
                  except sI := '0' end;
                  // 1 Parcela
                  if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label1.Caption) / 100)+1)]) + '<br></font></td>');
                  // 2 Parcela
                  if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label2.Caption) / 100)+1)]) + '<br></font></td>');
                  // 3 Parcela
                  if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * ((StrToFloat(Form39.Label3.Caption) / 100)+1)]) + '<br></font></td>');
                  // QTD X PRECO
                  if (I = Form7.iCampos + 4) and (Form39.CheckBox1.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Form7.ibDataSet4PRECO.AsFloat * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + '<br></font></td>');
                    fTotal[I] := fTotal[I] + Form7.ibDataSet4PRECO.AsFloat * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                  end;
                  // QTD X CUSTO COMPRA
                  if (I = Form7.iCampos + 5) and (Form39.CheckBox2.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + '<br></font></td>');
                    fTotal[I] := fTotal[I] +  Arredonda(Form7.ibDataSet4CUSTOCOMPR.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                  end;
                  // QTD X CUSTO MEDIO
                  if (I = Form7.iCampos + 6) and (Form39.CheckBox3.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.'+sI+'n',[Arredonda(Form7.ibDataSet4CUSTOMEDIO.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat]) + '<br></font></td>');
                    fTotal[I] :=  fTotal[I] + Arredonda(Form7.ibDataSet4CUSTOMEDIO.AsFloat,StrToInt(Form1.ConfPreco)) * Form7.ibDataSet4QTD_ATUAL.AsFloat;
                  end;
                end;
                {$Endregion}

                {$Region'//// Clientes e Fornecedores ////'}
                if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
                begin
                  // Recebido
                  if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.2n',[fRecebido]) + '<br></font></td>');
                    fTotal[I] :=  fTotal[I] + fRecebido;
                  end;
                  // Receber
                  if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.2n',[fReceber]) + '<br></font></td>');
                    fTotal[I] :=  fTotal[I] + fReceber;
                  end;
                  // Atrasado
                  if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><font face="verdana" size=2>'
                    + Format('%13.2n',[fAtrasado]) + '<br></font></td>');
                    fTotal[I] :=  fTotal[I] +  fAtrasado;
                  end;
                end;
                {$Endregion}

                {$Region'//// Receber ////'}
                if (Form7.sModulo = 'RECEBER') and
                  (
                    Form39.CheckBox4.Checked
                    or Form39.CheckBox5.Checked
                    or Form39.CheckBox6.Checked
                    or Form39.CheckBox7.Checked
                    or Form39.CheckBox8.Checked
                  ) then
                begin
                  // Procura pelo nome no cadastro de clientes //
                  if (Form39.CheckBox4.Checked)
                    or (Form39.CheckBox5.Checked)
                    or (Form39.CheckBox6.Checked)
                    or (Form39.CheckBox7.Checked)
                    or (Form39.CheckBox8.Checked) then
                  begin
                    if Form7.ibDataSet7NOME.AsString <> Form7.ibDataSet2NOME.AsString then
                    begin
                      Form7.ibDataSet2.Close;
                      Form7.ibDataSet2.Selectsql.Clear;
                      Form7.ibDataSet2.Selectsql.Add('select * from CLIFOR where NOME='+QuotedStr(Form7.ibDataSet7NOME.AsString)+' ');  //
                      Form7.ibDataSet2.Open;
                    end;
                  end;

                  if Form7.ibDataSet7NOME.AsString = Form7.ibDataSet2NOME.AsString then
                  begin
                    // Endereço
                    if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2>'
                      + Copy(Form7.ibDataSet2ENDERE.AsString + Replicate(' ',30),1,30) + '<br></font></td>');
                    end;

                    // Cidade
                    if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2>'
                      + Copy(Form7.ibDataSet2CIDADE.AsString+Replicate(' ',30),1,20) + '<br></font></td>');
                    end;

                    // Telefone
                    if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2>'
                      + Copy(Form7.ibDataSet2FONE.AsString+Replicate(' ',17),1,17) + '<br></font></td>');
                    end;

                    // Contato
                    if (I = Form7.iCampos + 3) and (Form39.CheckBox7.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2>'
                      + Copy(Form7.IBDataSet2CONTATO.AsString+Replicate(' ',17),1,17) + '<br></font></td>');
                    end;

                    // WhatsApp
                    if (I = Form7.iCampos + 3) and (Form39.CheckBox8.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2>'
                      + Copy(Form7.IBDataSet2WHATSAPP.AsString+Replicate(' ',17),1,17) + '<br></font></td>');
                    end;
                  end else
                  begin
                    // Endereço
                    if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2><br></font></td>');
                    end;

                    // Cidade
                    if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2><br></font></td>');
                    end;

                    // Telefone
                    if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2><br></font></td>');
                    end;

                    // Contato
                    if (I = Form7.iCampos + 4) and (Form39.CheckBox7.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2><br></font></td>');
                    end;

                    // WhatsApp
                    if (I = Form7.iCampos + 5) and (Form39.CheckBox8.Checked) then
                    begin
                      WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=Left><font face="verdana" size=2><br></font></td>');
                    end;
                  end;
                end;
              end;
              {$Endregion}
            end;

            WriteLn(F,'    </tr>');

            {$Region'//// Gera detalhe da linha ////'}
            //Mauricio Parizotto 2024-08-28
            if Form7.sModulo = 'OS' then
            begin
              if Form39.CheckBox4.Checked then
              begin
                if sCampoTecnico = '' then
                begin
                  try
                    SmallIni := TIniFile.Create(Form1.sAtual+'\LABELS.INI');
                    sCampoTecnico := SmallIni.ReadString('OS','Label34','Técnico');
                  finally
                    SmallIni.Free;
                  end;
                end;

                WriteLn(F,
                        GetDetalheOS(Form7.ArquivoAberto.FieldByName('NUMERO').AsString,
                                     sCampoTecnico,
                                     iColunas)
                        );
              end;
            end;
            {$Endregion}

          end;
        end;
      end;

      Form7.ArquivoAberto.Next;
      if bImprimir then iContador := iContador + 1;
    end;

    if (Form7.Caption = 'Catálogo de produtos') or (Form7.Caption = 'Álbum de fotografias') or (Form7.Caption = 'Cardápio')  or (Form7.Caption = 'Receitas') then
    begin
      // Catálogo de produtos
    end else
    begin
      // totaliza contas a receber quando esta somando por cliente
      if (form7.sModulo = 'RECEBER') then
      begin
        if pos('order by NOME',Form7.ibDataSet7.SelectSQL.Text) <> 0 then
        begin
          WriteLn(F,'    </tr>');
          WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+'>');
          for I := 1 to Form7.iCampos  + jCampos  do
          begin
            if I <= Form7.iCampos then
            begin
              if Form7.ArquivoAberto.Fields[I-1].Visible = True then
              begin
                // Imprime o total
                if (Pos('SALD',Form7.ArquivoAberto.Fields[I-1].Name) = 0) and (fTotal[I] - rTotal[I] <> 0) then
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                        + Format('%13.'+sI+'n',[fTotal[I]-rTotal[I]]) + '<br></font></td>')
                else
                    WriteLn(F,'        <td align=right><br><font face="verdana" size=2></font></td>');

                rTotal[I] := fTotal[I]
              end;
            end;
          end;
        end;
      end;

      // totaliza contas a receber quando esta somando por cliente
      if (Form7.sModulo <> 'NOTA')
        and (Form7.sModulo <> 'CONFOS')
        and (Form7.sModulo <> 'CONFRECIBO')
        and (Form7.Caption <> 'Lista de preços')
        and (Form7.sModulo <> 'VENDEDOR')
      then
      begin
        WriteLn(F,'    <tr bgcolor=#'+Form1.sHtmlCor+'>');
        sOP  := '';
        sI   := '2';

        for I := 1 to Form7.iCampos  + jCampos  do
        begin
          if I <= Form7.iCampos then
          begin
            if Form7.ArquivoAberto.Fields[I-1].Visible = True then
            begin

              if Form7.sModulo = 'ICM' then
              begin
                 // para o módulo ICM não totaliza as colunas
                 WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><br><font face="verdana" size=2></font></td>');
              end
              else
              begin
                // Imprime o total
                if (Pos('SALD',Form7.ArquivoAberto.Fields[I-1].Name) = 0) and (fTotal[I] <> 0) then
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                        + Format('%13.'+sI+'n',[fTotal[I]]) + '<br></font></td>')
                else
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><br><font face="verdana" size=2></font></td>');
                {Sandro Silva 2022-12-19 inicio}
                if Form7.sModulo = 'RECEBER' then
                begin
                  if (Form7.ArquivoAberto.Fields[I-1].FieldName = 'NOME') and (Form1.DisponivelSomenteParaNos) then
                  begin
                    WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right><br><font face="verdana" size=2></font></td>');
                  end;
                end;
                {Sandro Silva 2022-12-19 fim}
              end;
            end;
          end else
          begin
            if Form7.sModulo = 'ESTOQUE' then
            begin
              // 1 Parcela
              if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>');
              // 2 Parcela
              if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>');
              // 2 Parcela
              if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>');
              // QTD X PRECO
              if (I = Form7.iCampos + 4) and (Form39.CheckBox1.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
              // QTD X CUSTO COMPRA
              if (I = Form7.iCampos + 5) and (Form39.CheckBox2.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
              // QTD X CUSTO MEDIO
              if (I = Form7.iCampos + 6) and (Form39.CheckBox3.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
            end;

            if (Form7.sModulo = 'CLIENTES') or (Form7.sModulo = 'FORNECED') then
            begin
              // Recebido
              if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
              // Receber
              if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
              // Atrasado
              if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                if fTotal[I] = 0 then  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>') else
                  WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2>'
                  + Format('%13.'+sI+'n',[fTotal[i]]) + '<br></font></td>');
            end;

            if (Form7.sModulo = 'RECEBER') then
            begin
              if (I = Form7.iCampos + 1) and (Form39.CheckBox4.Checked) then
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Endereço
              if (I = Form7.iCampos + 2) and (Form39.CheckBox5.Checked) then
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Cidade
              if (I = Form7.iCampos + 3) and (Form39.CheckBox6.Checked) then
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Telefone
              if (I = Form7.iCampos + 4) and (Form39.CheckBox7.Checked) then
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // Contato
              if (I = Form7.iCampos + 5) and (Form39.CheckBox8.Checked) then
                WriteLn(F,'        <td '+RetornarQuebraLinhaHTML+' align=right bgcolor=#'+Form1.sHtmlCor+'><font face="verdana" size=2><br></font></td>'); // WhatsApp
            end;
          end;
        end;
      end;
    end;

    WriteLn(F,'</table>');
    // Linha da data //
    WriteLn(F,'<br><font face="verdana" size=1>Gerado em '+Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de '
        + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de '
        + Copy(DateTimeToStr(Date),7,4) + ' às ' + TimeToStr(Time)+'</font>');
    // Condição do relatório
    WriteLn(F,'<br><font face="verdana" size=1>'+TraduzSql('Listando '+Form7.swhere+' '+Form7.sOrderBy,True));
    //
    WriteLn(F,'<br><font face="verdana" size=1>Número de registros: '+IntToStr(iContador)+'</font>');
    WriteLn(F,'<br>');

    if (Alltrim(Form7.ibDataSet13HP.AsString) = '') then
    begin
      WriteLn(F,'<font face="verdana" size=1><center>Relatório gerado pelo sistema Smallsoft, <a href="http://www.smallsoft.com.br"> www.smallsoft.com.br</a><font>'); // Ok
    end else
    begin
      WriteLn(F,'<font face="verdana" size=1><center><a href="http://'+Form7.ibDataSet13HP.AsString+'">'+Form7.ibDataSet13HP.AsString+'</a><font>');
    end;

    if not Form1.bPDF then
      WriteLn(F,'<a href="http://www.smallsoft.com.br/meio_ambiente.htm"><center><font face="Webdings" size=5 color=#215E21>P<font face="Microsoft Sans Serif" size=1 color=#215E21> Antes de imprimir, pense no meio ambiente.</center></a>');

    WriteLn(F,'</center>');
    WriteLn(F,'</html>');
    CloseFile(F);                               
  end;
  {$Endregion}

  if IBQCLIENTE <> nil then
    FreeAndNil(IBQCLIENTE);

  Screen.Cursor   := crDefault;    // Cursor de Aguardo
  Form7.ArquivoAberto.GotoBookmark(MyBookmark);
  Form7.ArquivoAberto.EnableControls;
  Close;

  if Form14.Caption <> 'Cancelar' then
  begin
    AbreArquivoNoFormatoCerto(Senhas.UsuarioPub);
  end;
end;

procedure TForm14.Button3Click(Sender: TObject);
begin
  Form14.Caption := 'Cancelar';
  Close;
end;

procedure TForm14.FormActivate(Sender: TObject);
begin
  Form14.Image2.Picture := Form7.imgImprimir.Picture;
  Button1.Enabled := True;
  Form14.Caption := 'Assistente de relatórios';
  Form14.Left := Screen.Width - Form14.Width - Form9.Width -12;
  Form14.Top  := Form7.Top + 25;

  if FileExists(Form1.sAtual+'\LOGOTIP.BMP') then
    //Image1.Picture.LoadFromFile('LOGOTIP.BMP') Mauricio Parizotto 2023-12-05
    Image1.Picture.LoadFromFile(Form1.sAtual+'\LOGOTIP.BMP')
  else
    Image1.Picture := Form1.Image1.Picture;

  FbQuebraLinha := (Form7.sModulo = 'RECEBER') or (Form7.sModulo = 'PAGAR');
end;

function TForm14.RetornarQuebraLinhaHTML: String;
begin
  Result := EmptyStr;

  if FbQuebraLinha then
    Result := 'nowrap'
end;

procedure TForm14.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Form7.Caption = 'Lista de preços' then Form7.Caption := 'Controle de estoque';
  if Form7.Caption = 'Catálogo de produtos' then Form7.Caption := 'Controle de estoque';
  if Form7.Caption = 'Cardápio' then Form7.Caption := 'Controle de estoque';
  if Form7.Caption = 'Receitas' then Form7.Caption := 'Controle de estoque';
  if Form7.Caption = 'Álbum de fotografias' then Form7.Caption := 'Cadastro de clientes e fornecedores';

  FbQuebraLinha := False;

  Form9.Close;
  Form39.Close;
end;


procedure TForm14.FormCreate(Sender: TObject);
begin
  Image1.Picture.Bitmap.Height :=  90;
  Image1.Picture.Bitmap.Width  := 340;
  FbQuebraLinha := False;
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
  Form19.ShowModal;
end;


function TForm14.GetDetalheOS(sNumeroOS, sCampoTecnico : string; iColunas:integer):string; //Mauricio Parizotto 2024-08-28
var
  qryAux: TIBQuery;
  sItens : string;
begin
  Result := '';

  try
    qryAux := CriaIBQuery(Form7.IBTransaction1);

    qryAux.SQL.Text := ' Select '+
                       ' 	 CODIGO,'+
                       ' 	 DESCRICAO,'+
                       ' 	 QUANTIDADE,'+
                       ' 	 UNITARIO,'+
                       ' 	 TOTAL,'+
                       ' 	 '''' TECNICO'+
                       ' From ITENS001'+
                       ' Where NUMEROOS = '+QuotedStr(sNumeroOS)+
                       ' Union All'+
                       ' Select '+
                       ' 	 CODIGO,'+
                       ' 	 DESCRICAO,'+
                       ' 	 QUANTIDADE,'+
                       ' 	 UNITARIO,'+
                       '   TOTAL,'+
                       '   TECNICO'+
                       ' From ITENS003'+
                       ' Where NUMEROOS = '+QuotedStr(sNumeroOS);

    qryAux.Open;

    while not qryAux.Eof do
    begin
      sItens := sItens +
                '          <tr>'+#13#10+
                '             <td align=center>'+qryAux.FieldByName('CODIGO').AsString+'</td>'+#13#10+
                '             <td>'+qryAux.FieldByName('DESCRICAO').AsString+'</td>'+#13#10+
                '             <td>'+qryAux.FieldByName('TECNICO').AsString+'</td>'+#13#10+
                '             <td align=right>'+FormatFloat('#,##0.00', qryAux.FieldByName('QUANTIDADE').AsFloat)+'</td>'+#13#10+
                '             <td align=right>'+FormatFloat('#,##0.00', qryAux.FieldByName('UNITARIO').AsFloat)+'</td>'+#13#10+
                '             <td align=right>'+FormatFloat('#,##0.00', qryAux.FieldByName('TOTAL').AsFloat)+'</td>'+#13#10+
                '          </tr>'+#13#10;

      qryAux.Next;
    end;

  finally
    FreeAndNil(qryAux);
  end;

  if sItens <> '' then
  begin
    Result := ' <tr >'+#13#10+
              '    <td colspan="'+iColunas.ToString+'">'+#13#10+
              '       <table border=1 style="border-collapse:Collapse" cellspacing=0 cellpadding=3 width=100%> '+#13#10+
              '          <tr>'+#13#10+
              '             <td width="100">Codigo</td>'+#13#10+
              '             <td>Produto/Serviço</td>'+#13#10+
              '             <td width="150">'+ sCampoTecnico +'</td>'+#13#10+
              '             <td width="100">Qtd</td>'+#13#10+
              '             <td width="100">Unitário</td>'+#13#10+
              '             <td width="100">Total</td>'+#13#10+
              '          </tr>'+#13#10+
              sItens+
              '       </table>'+#13#10+
              '    </td>'+#13#10+
              ' </tr>'+#13#10
              ;
  end;

  //Separa com uma linha em branco
  Result := Result + '<tr> <td colspan="11"> <br> </td>';
end;

end.


