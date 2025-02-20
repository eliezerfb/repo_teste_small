unit uFrmIntegracaoIMendes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.StdCtrls, Vcl.Buttons, shellapi, IBX.IBQuery,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, REST.JSON, System.Threading, uArquivosDAT,
  uImendes, uIEstruturaTipoRelatorioPadrao;

type
  TFrmIntegracaoIMendes = class(TFrmPadrao)
    pgcImendes: TPageControl;
    tbsSaneamento: TTabSheet;
    tbsSimulacao: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Label6: TLabel;
    Image1: TImage;
    Image2: TImage;
    chkConsultaIPI: TCheckBox;
    lblFaixaFat: TLabel;
    lbl2FaixaFat: TLabel;
    cboFaixaFat: TComboBox;
    btnSanear: TBitBtn;
    btnSincronizar: TBitBtn;
    btnOK: TBitBtn;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Panel2: TPanel;
    btnSimulador: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    btnsOK: TBitBtn;
    btnGeraSimulacao: TBitBtn;
    SaveDialog: TSaveDialog;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSimuladorClick(Sender: TObject);
    procedure btnGeraSimulacaoClick(Sender: TObject);
    procedure btnSanearClick(Sender: TObject);
    procedure btnSincronizarClick(Sender: TObject);
  private
    function GetArquivoSimulacao(out ProdsSemICMS : string): string;
    procedure RelatorioSaneamento(sFiltro: string);
    procedure RelatorioAlterados(sFiltro: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIntegracaoIMendes: TFrmIntegracaoIMendes;

implementation

{$R *.dfm}

uses unit7, uFuncoesBancoDados, uClassesIMendes, smallfunc_xe,
  uFrmTelaProcessamento, uDialogs, uFuncoesRetaguarda, uValidaRecursos,
  uTypesRecursos, MAIS, uSistema, uFrmSaneamentoIMendes, uEstruturaRelGenerico,
  uSmallConsts;

procedure TFrmIntegracaoIMendes.btnSimuladorClick(Sender: TObject);
begin
  ShellExecute(0, 'Open',pChar('https://smallsoft.com.br/contador/click.php?id=imendes2024')
               ,'', '', SW_SHOWMAXIMIZED);
end;

procedure TFrmIntegracaoIMendes.btnGeraSimulacaoClick(Sender: TObject);
var
  DirArquivo, sArquivoSimulacao : string;
begin
  if SaveDialog.Execute then
  begin
    DirArquivo := SaveDialog.FileName;

    MostraTelaProcessamento('Processando informações...');

    TTask.Run(
    procedure()
    var
      sArquivoSimulacao, ProdsSemICMS : string;
      Arquivo : TStringList;
    begin
      try
        sArquivoSimulacao := GetArquivoSimulacao(ProdsSemICMS);
      except
      end;

      TThread.Synchronize(TThread.CurrentThread,
      procedure()
      begin
        FechaTelaProcessamento;

        try
          Arquivo := TStringList.Create;
          Arquivo.Text := sArquivoSimulacao;
          Arquivo.SaveToFile(DirArquivo);
          MensagemSistema('Arquivo gerado com sucesso!');

          if ProdsSemICMS <> '' then
          begin
            Arquivo.Clear;
            Arquivo.Text := 'Produtos sem alíquota de ICMS configurado:'+#13#10+
                            ProdsSemICMS;
            Arquivo.SaveToFile(ExtractFilePath(DirArquivo)+'LogImendes.txt'  );

            ShellExecute( 0, 'Open', pchar(ExtractFilePath(DirArquivo)+'LogImendes.txt'),'', '', SW_SHOW);

          end;

          if FileExists('C:\CadastroIMendes\CadastroIMendes.exe') then
          begin
            ShellExecute( 0, 'Open', 'C:\CadastroIMendes\CadastroIMendes.exe',
                         pchar('"'+DirArquivo+'"'), '', SW_SHOW);
          end;
        finally
          FreeAndNil(Arquivo);
        end;
      end);
    end);
  end;
end;

procedure TFrmIntegracaoIMendes.btnOKClick(Sender: TObject);
var
  ConfSistema : TArquivosDAT;
begin
  TSistema.GetInstance.ConsultarIPIImendes := chkConsultaIPI.Checked;

  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
    ConfSistema.BD.IMendes.ConsultarIPI     := chkConsultaIPI.Checked;
    ConfSistema.BD.IMendes.FaixaFaturamento := copy(cboFaixaFat.Text,1,2);
  finally
    FreeAndNil(ConfSistema);
  end;

  Close;
end;

procedure TFrmIntegracaoIMendes.btnSanearClick(Sender: TObject);
var
  sFiltro : string;
  vQtdConexoes : integer;
begin
  if not TSistema.GetInstance.ModuloImendes then
  begin
    Form1.MensagemRecursoIndisponivel('Integração IMendes não está disponível para esta licença');
    Exit;
  end;


  vQtdConexoes := ExecutaComandoEscalar(Form1.ibDataSet200.Transaction.DefaultDatabase,
                                        'Select Count(*) From MON$ATTACHMENTS');

  if vQtdConexoes > 1 then
  begin
    MensagemSistema('Não foi possível iniciar o saneamento. Existem outros usuários com o sistema aberto.'+#13#10+
                    'Feche o sistema em todos os computadores e tente novamente.'
                    ,msgAtencao);

    Exit;
  end;

  TSistema.GetInstance.ConsultarIPIImendes := chkConsultaIPI.Checked;

  if GetFiltroSaneamento(sFiltro) then
  begin
    MostraTelaProcessamento('Saneando tributação dos produtos');

    TTask.Run(
    procedure()
    var
      bRealizada : boolean;
      sMensgem : string;
      DataIni, DataFim : TDateTime;
    begin
      DataIni := now;

      bRealizada := GetTributacaoEstoque(Form7.ibDataSet4,sFiltro,sMensgem);

      TThread.Synchronize(TThread.CurrentThread,
      procedure()
      begin
        FechaTelaProcessamento();

        DataFim := now;

        if bRealizada then
        begin
          MensagemSistema('Saneamento realizado com sucesso!');
          Commitatudo(True);
          AgendaCommit(False);
          AbreArquivos(False);

          //Relatório
          RelatorioSaneamento(' Where DATA_STATUS_TRIBUTACAO between '+
                              QuotedStr(FormatDateTime('yyyy-mm-dd HH:mm:ss',DataIni))+
                              '   and '+
                              QuotedStr(FormatDateTime('yyyy-mm-dd HH:mm:ss',DataFim))
                              );
        end else
        begin
          MensagemSistema(sMensgem,msgAtencao);
        end;
      end);
    end);
  end;
end;

procedure TFrmIntegracaoIMendes.btnSincronizarClick(Sender: TObject);
begin
  if not TSistema.GetInstance.ModuloImendes then
  begin
    Form1.MensagemRecursoIndisponivel('Integração IMendes não está disponível para esta licença');
    Exit;
  end;

  if MensagemSistemaPergunta('Essa rotina irá consultar alterações tributárias nos produtos já saneados e verificar se as pendências foram analisadas.' + sLineBreak +
                             'Deseja prosseguir?', [mb_YesNo, mb_DefButton1]) <> mrYes then
    Exit;



  MostraTelaProcessamento('Consultando alterações');

  TTask.Run(
  procedure()
  var
    bRealizada : boolean;
    sFiltro, sMensagem, sEstoqueIDs : string;
    DataIni, DataFim : TDateTime;
  begin
    bRealizada := False;
    DataIni    := now;

    //Devolvidos
    if GetProdutosDevolvidos(LimpaNumero(Form7.ibDataSet13CGC.AsString),
                             sMensagem,
                             Form7.IBTransaction1) then
    begin
      bRealizada := True;
    end;

    //Pendentes
    if GetProdutosPendentes(LimpaNumero(Form7.ibDataSet13CGC.AsString),
                            Form7.ibDataSet13ESTADO.AsString,
                            sFiltro,
                            sMensagem) then
    begin
      AtualizaStatusProc('Saneando tributação dos produtos', '');

      if GetTributacaoEstoque(Form7.ibDataSet4,
                              sFiltro,
                              sMensagem) then
      begin
        bRealizada := True;
      end;
    end;

    TThread.Synchronize(TThread.CurrentThread,
    procedure()
    begin
      FechaTelaProcessamento();

      if bRealizada then
      begin
        MensagemSistema('Saneamento realizado com sucesso!');
        Commitatudo(True);
        AgendaCommit(False);
        AbreArquivos(False);

        //Relatório
        DataFim := now;
        RelatorioAlterados(' Where DATA_STATUS_TRIBUTACAO between '+
                           QuotedStr(FormatDateTime('yyyy-mm-dd HH:mm:ss',DataIni))+
                           '   and '+
                           QuotedStr(FormatDateTime('yyyy-mm-dd HH:mm:ss',DataFim))
                           );
      end else
      begin
        MensagemSistema(sMensagem,msgAtencao);
      end;
    end);
  end);
end;

procedure TFrmIntegracaoIMendes.FormCreate(Sender: TObject);
var
  ConfSistema : TArquivosDAT;
  I : integer;
  bConfFaixa : boolean;
begin
  pgcImendes.ActivePage  := tbsSaneamento;

  try
    ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
    chkConsultaIPI.Checked := ConfSistema.BD.IMendes.ConsultarIPI;

    for I := 0 to cboFaixaFat.Items.Count -1 do
    begin
      if Copy(cboFaixaFat.Items[I],1,2) = ConfSistema.BD.IMendes.FaixaFaturamento then
      begin
        cboFaixaFat.ItemIndex := I;
        Break;
      end;
    end;
  finally
    FreeAndNil(ConfSistema);
  end;

  bConfFaixa := StrToIntDef(Form7.ibDataSet13CRT.AsString,0) in [2,3];

  lblFaixaFat.Visible  := bConfFaixa;
  lbl2FaixaFat.Visible := bConfFaixa;
  cboFaixaFat.Visible  := bConfFaixa;

end;

function TFrmIntegracaoIMendes.GetArquivoSimulacao(out ProdsSemICMS : string):string; //Mauricio Parizotto 2024-09-25
var
  qryAux: TIBQuery;
  SimuladorDTO : TRootSimuladorDTO;
  ProdutoArray : TArray<TProdutoSimulacao>;
  i : integer;
  CST_CSOSN : string;
  IVA : Double;
begin
  Result := '';

  try
    SimuladorDTO := TRootSimuladorDTO.Create;

    //Cabeçalho
    try
      qryAux := CriaIBQuery(Form7.IBTransaction1);
      qryAux.SQL.Text := ' Select'+
                         '   CGC,'+
                         '   ESTADO,'+
                         '   CRT'+
                         ' From EMITENTE';
      qryAux.Open;

      SimuladorDTO.Cabecalho.Cnpj       := LimpaNumero(qryAux.FieldByName('CGC').AsString);
      SimuladorDTO.Cabecalho.Uf         := qryAux.FieldByName('ESTADO').AsString;
      SimuladorDTO.Cabecalho.Crt        := StrToIntDef(qryAux.FieldByName('CRT').AsString,0);
      SimuladorDTO.Cabecalho.TpConsulta := 2;
      SimuladorDTO.Cabecalho.Versao     := '2.0';
      SimuladorDTO.Cabecalho.Hash       := 'SIMULADOR';
    finally
      FreeAndNil(qryAux);
    end;

    //Produtos
    try
      qryAux := CriaIBQuery(Form7.IBTransaction1);
      qryAux.SQL.Text := ' Select '+
                         '   E.IDESTOQUE,'+
                         ' 	 E.CODIGO,'+
                         ' 	 E.REFERENCIA,'+
                         ' 	 DESCRICAO,'+
                         ' 	 E.CF,'+
                         ' 	 E.PRECO,'+
                         ' 	 E.IPI,'+
                         '   E.NATUREZA_RECEITA,'+
                         ' 	 E.CST_PIS_COFINS_ENTRADA,'+
                         ' 	 E.CST_PIS_COFINS_SAIDA,'+
                         ' 	 E.CST,'+
                         ' 	 E.CSOSN,'+
                         '   Coalesce(E.ALIQUOTA_NFCE, Coalesce(I.'+SimuladorDTO.Cabecalho.Uf+'_ ,0) ) ICMS, '+
                         '   100 - Coalesce(I.BASE,100.00) ICMS_RED'+
                         ' From ESTOQUE E'+
                         '   Left Join ICM I on I.ST = E.ST'+
                         ' Where COALESCE(E.TIPO_ITEM,''00'') <> ''09'''+ // <> Serviço
                         '   and COALESCE(ATIVO,0) = 0 ';
      qryAux.Open;

      while not qryAux.Eof do
      begin
        i := Length(ProdutoArray);
        SetLength(ProdutoArray, i +1);
        ProdutoArray[i] := TProdutoSimulacao.Create;

        if (SimuladorDTO.Cabecalho.Crt = 1) or (SimuladorDTO.Cabecalho.Crt = 4) then
          CST_CSOSN := qryAux.FieldByName('CSOSN').AsString
        else
          CST_CSOSN := qryAux.FieldByName('CST').AsString;

        //IVA
        IVA := GetIVAProduto(qryAux.FieldByName('IDESTOQUE').AsInteger,
                             SimuladorDTO.Cabecalho.Uf,
                             Form7.IBTransaction1);
        if IVA > 1 then
          IVA := (IVA - 1) * 100
        else
          IVA := 0;

        ProdutoArray[i].CodigoInterno                  := qryAux.FieldByName('CODIGO').AsString;
        ProdutoArray[i].Descricao                      := qryAux.FieldByName('DESCRICAO').AsString;
        ProdutoArray[i].Ean                            := qryAux.FieldByName('REFERENCIA').AsString;
        ProdutoArray[i].CSTCSOSN                       := CST_CSOSN;
        ProdutoArray[i].CSTPISCOFINSEntrada            := qryAux.FieldByName('CST_PIS_COFINS_ENTRADA').AsString;
        ProdutoArray[i].CSTPISCOFINSSaida              := qryAux.FieldByName('CST_PIS_COFINS_SAIDA').AsString;
        ProdutoArray[i].NaturezaReceitaIsentaPISCOFINS := qryAux.FieldByName('NATUREZA_RECEITA').AsString;
        ProdutoArray[i].Ncm                            := qryAux.FieldByName('CF').AsString;
        ProdutoArray[i].PICMS                          := qryAux.FieldByName('ICMS').AsFloat;
        ProdutoArray[i].PIPI                           := qryAux.FieldByName('IPI').AsFloat;
        ProdutoArray[i].PMVAST                         := IVA;
        ProdutoArray[i].PRedBCICMS                     := qryAux.FieldByName('ICMS_RED').AsFloat;
        ProdutoArray[i].VVenda                         := qryAux.FieldByName('PRECO').AsFloat;

        if ProdutoArray[i].PICMS = 0 then
          ProdsSemICMS := ProdsSemICMS+ #13#10 + ProdutoArray[i].CodigoInterno +' - '+ProdutoArray[i].Descricao;

        qryAux.Next;
      end;
    finally
      FreeAndNil(qryAux);
    end;

    SimuladorDTO.Produto := ProdutoArray;

    Result := TJson.ObjectToJsonString(SimuladorDTO);

  finally
    FreeAndNil(SimuladorDTO);

    for I := Low(ProdutoArray) to High(ProdutoArray) do
    begin
      FreeAndNil(ProdutoArray[i]);
    end;

    SetLength(ProdutoArray,0);
  end;
end;

procedure TFrmIntegracaoIMendes.RelatorioSaneamento(sFiltro:string);
var
  sSql, sSql2, sSql3 : string;
begin
  sSql := ' Select '+
          '  	STATUS_TRIBUTACAO "Status",'+
          '  	Count(*)  "Quantidade"	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO in ('+QuotedStr(_cStatusImendesPendente)+','+QuotedStr(_cStatusImendesConsultado)+') '+
          ' Group By STATUS_TRIBUTACAO';

  sSql2 :=' Select '+
          ' 	CODIGO "Código",'+
          ' 	REFERENCIA "Código Barras",'+
          ' 	DESCRICAO "Descrição" 	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesConsultado);

  sSql3 :=' Select '+
          ' 	CODIGO "Código",'+
          ' 	REFERENCIA "Código Barras",'+
          ' 	DESCRICAO "Descrição" 	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesPendente);

  TEstruturaRelGenerico.New
                       .setUsuario(Usuario)
                       .SetDataBase(Form7.IBDatabase1)
                       .Estrutura
                       .GerarImpressaoTitCabecalho('Relatório de Saneamento')
                       .ImprimeQuery(sSql,'Totalizadores')
                       .ImprimeQuery(sSql2,'Produtos Consultados')
                       .ImprimeQuery(sSql3,'Produtos Pendentes')
                       .Imprimir;

end;

procedure TFrmIntegracaoIMendes.RelatorioAlterados(sFiltro:string);
var
  sSql, sSql2, sSql3 : string;
begin
  sSql := ' Select '+
          '  	STATUS_TRIBUTACAO "Status",'+
          '  	Count(*)  "Quantidade"	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO in ('+QuotedStr(_cStatusImendesRejeitado)+','+QuotedStr(_cStatusImendesConsultado)+') '+
          ' Group By STATUS_TRIBUTACAO';

  sSql2 :=' Select '+
          ' 	CODIGO "Código",'+
          ' 	REFERENCIA "Código Barras",'+
          ' 	DESCRICAO "Descrição" 	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesConsultado);

  sSql3 :=' Select '+
          ' 	CODIGO "Código",'+
          ' 	REFERENCIA "Código Barras",'+
          ' 	DESCRICAO "Descrição" 	'+
          ' From ESTOQUE'+
          sFiltro+
          ' and STATUS_TRIBUTACAO = '+QuotedStr(_cStatusImendesRejeitado);

  TEstruturaRelGenerico.New
                       .setUsuario(Usuario)
                       .SetDataBase(Form7.IBDatabase1)
                       .Estrutura
                       .GerarImpressaoTitCabecalho('Relatório de alterações')
                       .ImprimeQuery(sSql,'Totalizadores')
                       .ImprimeQuery(sSql2,'Produtos Consultados')
                       .ImprimeQuery(sSql3,'Produtos com Informações Insuficientes')
                       .Imprimir;

end;


end.
