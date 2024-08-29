// unit desdobramento parcelas
unit uFrmParcelas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Mask, DBCtrls, SMALL_DBEdit, Unit7, smallfunc_xe,
  ExtCtrls, DB, ShellApi, IniFiles, Buttons, IBCustomDataSet, IBQuery, uFuncoesTEF,
  System.DateUtils;

type
    TFrmParcelas = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    SMALL_DBEdit1: TSMALL_DBEdit;
    DBGrid1: TDBGrid;
    Label7: TLabel;
    cboDocCobranca: TComboBox;
    Button4: TBitBtn;
    Panel9: TPanel;
    lbTotalParcelas: TLabel;
    chkConsultaImprimeDanfe: TCheckBox;
    edtQtdParc: TEdit;
    IBQINSTITUICAOFINANCEIRA: TIBQuery;
    IBQBANCOS: TIBQuery;
    chkFixarVencimento: TCheckBox;
    procedure SMALL_DBEdit1Exit(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMALL_DBEdit1Enter(Sender: TObject);
    procedure SMALL_DBEdit16KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label10MouseLeave(Sender: TObject);
    procedure Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure chkConsultaImprimeDanfeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtQtdParcEnter(Sender: TObject);
    procedure edtQtdParcExit(Sender: TObject);
    procedure edtQtdParcKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cboDocCobrancaEnter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkFixarVencimentoClick(Sender: TObject);
  private
    FRegistroBloqueado: Boolean;
    FnQtdeParc: Integer;
    FpnlTEF: TPanel;
    bConfPrazoFixo : boolean;
    iDiaVencimento : integer;
    { Private declarations }
    FIdentificadorPlanoContas: String; // Sandro Silva 2022-12-29
    procedure ExibeOpcoesPreencherColunas;
    procedure CarregacboDocCobranca;
    procedure GetBancosNFe(slBanco: TStringList);
    procedure GetInstituicaoFinanceira(slInstituicao: TStringList);
    function FormaDePagamentoEnvolveBancos(sForma: String): Boolean;
    function ValidarDesdobramentoParcela: Boolean;
    procedure ReparcelaValor(DataSet: TibDataSet; iParcelas: Integer;
      dTotalParcelar: Double);
    //procedure RateiaDiferencaParcelaEntreAsDemais(ModuloAtual: String);
    function TotalParcelasLancadas: Double;
    function ChamarTEF: Boolean;
    function TestarRegistroComTEF: Boolean;
    function RetornaTotalReceberCartao: Currency;
    procedure GerarParcelasCartao(AoDadosTransacao: TDadosTransacao);
    procedure AdicionarParcela;
    procedure ExibirMensagemTEF(AcTexto: String);
    procedure AjustaPanelTEF;
    function TestarRegistroPodeChamarTEF: Boolean;
    procedure GerarParcelasTEFInativadas(AbExibeMensagem: Boolean = False);
    procedure RefazerNumeroParcela;
    procedure GeraParcelarReceber(QtdParcelas : integer; sNumeroNF : string);
    procedure GeraParcelarPagar(QtdParcelas : integer; sNumeroNF : string);
    procedure GeraParcelarRenegociacao(QtdParcelas: integer);

  public
    { Public declarations }
    sConta : String;
    vlrRenegociacao : Double;
    nrRenegociacao : string;
    property IdentificadorPlanoContas: String read FIdentificadorPlanoContas write FIdentificadorPlanoContas; // Sandro Silva 2022-12-29
  	procedure SetPickListParaColuna;
    procedure RateiaDiferencaParcelaEntreAsDemais(ModuloAtual: String);

  end;

var
  FrmParcelas: TFrmParcelas;

implementation

uses Unit12, Mais, unit24, Unit19, Unit43, Unit25, Unit16, Unit22, uFuncoesBancoDados,
  uFuncoesRetaguarda, StrUtils, uDialogs, uRaterioDiferencaEntreParcelasReceber,
  uSmallConsts, uRetornaBuildEXE, uArquivosDAT;

{$R *.DFM}


procedure TFrmParcelas.SMALL_DBEdit1Exit(Sender: TObject);
Var
  I : Integer;
//  dDiferenca : Double;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

  {$Region'//// Vendas ////'}
  try
    if Form7.sModulo = 'VENDA' then
    begin
      try
        Form7.ibDataSet15.Edit;

        if Form7.ibDataSet15.Modified then
        begin
           Form7.ibDataSet15.Post;
           Form7.ibDataSet15.Edit;
        end;

        // Cria as duplicatas
        // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //
        {Mauricio Parizotto 2024-04-23
        I := 0;
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          I := I + 1;
          Form7.ibDataSet7.Next;
        end;
        }
        I := Form7.ibDataSet7.RecordCount;

        if I <> Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) then
        begin
          //Mauricio Parizotto 2024-04-23
          try
            Form7.ibDataSet7.DisableControls;
            GeraParcelarReceber(Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat),Form7.ibDataSet15NUMERONF.AsString);
          finally
            Form7.ibDataSet7.EnableControls;
          end;
          (*
          GerarParcelasTEFInativadas(True);

          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            Form7.ibDataSet7.Delete;
            Form7.ibDataSet7.First;
          end;

          for I := 1 to Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat) do
          begin
            Form7.ibDataSet7.Append;
            Form7.ibDataSet7NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;

            if Form7.sRPS <> 'S' then
            begin
              if Copy(Form7.ibDataSet15NUMERONF.AsString,10,3) = '002' then
              begin
                Form7.ibDataSet7DOCUMENTO.Value := 'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,2,8) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
              end else
              begin
                Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
              end;
            end else
            begin
              Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,1)+'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,3,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
            end;

            Form7.ibDataSet7VALOR_DUPL.AsFloat          := Arredonda((Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR) / Form7.ibDataSet15DUPLICATAS.AsFloat,2);;

            if Form7.sRPS <> 'S' then
            begin
              Form7.ibDataSet7HISTORICO.Value := 'NFE NAO AUTORIZADA';
            end else
            begin
              Form7.ibDataSet7HISTORICO.AsString := 'RPS número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9);
            end;

            Form7.ibDataSet7EMISSAO.asDateTime    := Form7.ibDataSet15EMISSAO.AsDateTime;
            Form7.ibDataSet7NOME.Value            := Form7.ibDataSet15CLIENTE.Value;
            Form7.ibDataSet7CONTA.AsString        := sConta;

            if I = 1 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
            if I = 2 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
            if I = 3 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
            if I > 3 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+
                ((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))
                 -StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));

            if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;

            if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
              Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;

            Form7.ibDataSet7.Post;
          end;

          // Valor quebrado
          dDiferenca := StrToFloat(FormatFloat('0.00', (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR))); // Sandro Silva 2023-11-20 dDiferenca := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - StrToFloat(FormatFloat('0.00', Form7.ibDataSet7VALOR_DUPL.AsFloat)))); // Sandro Silva 2023-11-20 dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
            Form7.ibDataSet7.Next;
          end;

          Form7.ibDataSet7.First;
          Form7.ibDataSet7.Edit;
          if dDiferenca <> 0 then
            Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(FormatFloat('0.00', Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca)); // Sandro Silva 2023-11-20 Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca;

          *)
        end
        {Sandro Silva 2023-11-09 inicio}
        else
        begin
          //ReparcelaValor
        end;
        {Sandro Silva 2023-11-09 fim}

        Form7.ibDataSet7.First;
      finally
        //Form7.ibDataSet7.EnableControls; // Sandro Silva 2023-11-20
      end;
    end;
  except
  end;

  {$Endregion}

  {$Region'//// Compras ////'}
  try
    if Form7.sModulo = 'COMPRA' then
    begin
      // PAGAR
      if Form7.ibDataSet24.Modified then
      begin
         Form7.ibDataSet24.Post;
         Form7.ibDataSet24.Edit;
      end;

      // Cria as duplicatas
      // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //
      I := 0;
      Form7.ibDataSet8.First;
      while not Form7.ibDataSet8.Eof do
      begin
        I := I + 1;
        Form7.ibDataSet8.Next;
      end;

      if I <> Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat) then
      begin
        //Mauricio Parizotto 2024-04-23
        GeraParcelarPagar(Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat),Form7.ibDataSet24NUMERONF.AsString);
        (*
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
        begin
          Form7.ibDataSet8.Delete;
          Form7.ibDataSet8.First;
        end;

        for I := 1 to Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat) do
        begin
          Form7.ibDataSet8.Append;
          Form7.ibDataSet8NUMERONF.AsString   := Form7.ibDataSet24NUMERONF.AsString;
          Form7.ibDataSet8DOCUMENTO.Value     := Copy(Form7.ibDataSet24NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
          Form7.ibDataSet8VALOR_DUPL.AsFloat  := Form7.ibDataSet24TOTAL.AsFloat / Form7.ibDataSet24DUPLICATAS.AsFloat;
          Form7.ibDataSet8VALOR_DUPL.AsFloat  := StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
          Form7.ibDataSet8HISTORICO.Value     := 'Nota Fiscal: '+Copy(Form7.ibDataSet24NUMERONF.AsString,1,9);
          Form7.ibDataSet8EMISSAO.asDateTime  := Form7.ibDataSet24EMISSAO.AsDateTime;
          Form7.ibDataSet8NOME.Value          := Form7.ibDataSet24FORNECEDOR.AsString;
          Form7.ibDataSet8CONTA.AsString      := sConta;
          if I = 1 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
          if I = 2 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
          if I = 3 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
          if I > 3 then
            Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+
              ((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))
               -StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));
          Form7.ibDataSet8.Post;
        end;

        // Valor quebrado
        dDiferenca := Form7.ibDataSet24TOTAL.AsFloat;
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
        begin
          dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
          Form7.ibDataSet8.Next;
        end;

        Form7.ibDataSet8.First;
        Form7.ibDataSet8.Edit;
        if dDiferenca <> 0 then
          Form7.ibDataSet8VALOR_DUPL.AsFloat := Form7.ibDataSet8VALOR_DUPL.AsFloat + ddiferenca;
        *)
      end;

      Form7.ibDataSet8.First;
    end;
  except
  end;
  {$Endregion}
end;

procedure TFrmParcelas.AdicionarParcela;
var
  nParcelaAtual: Integer;
begin
  nParcelaAtual := Form7.ibDataSet7.RecordCount + 1;

  Form7.ibDataSet7.Append;
  Form7.ibDataSet7NUMERONF.AsString := Form7.ibDataSet15NUMERONF.AsString;

  if Form7.sRPS <> 'S' then
  begin
    if Copy(Form7.ibDataSet15NUMERONF.AsString,10,3) = '002' then
    begin
      Form7.ibDataSet7DOCUMENTO.Value := 'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,2,8) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
    end else
    begin
      Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
    end;
  end else
  begin
    Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,1)+'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,3,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
  end;

  Form7.ibDataSet7VALOR_DUPL.AsFloat          := 0;

  if Form7.sRPS <> 'S' then
  begin
    Form7.ibDataSet7HISTORICO.Value := 'NFE NAO AUTORIZADA';
  end else
  begin
    Form7.ibDataSet7HISTORICO.AsString := 'RPS número: '+Copy(Form7.ibDataSet15NUMERONF.AsString,1,9);
  end;

  Form7.ibDataSet7EMISSAO.asDateTime    := Form7.ibDataSet15EMISSAO.AsDateTime;
  Form7.ibDataSet7NOME.Value            := Form7.ibDataSet15CLIENTE.Value;
  Form7.ibDataSet7CONTA.AsString        := sConta;
  Form7.ibDataSet7VENCIMENTO.AsDateTime := Date;
  if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
    Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;
  if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
    Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;

  Form7.ibDataSet7.Post;

  Form7.ibDataSet15.Edit;
  Form7.ibDataSet15DUPLICATAS.AsCurrency := nParcelaAtual;
  Form7.ibDataSet15.Post;
end;

procedure TFrmParcelas.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  dDiferenca : Double;
  MyBookmark: TBookmark;
  iRegistro, iDuplicatas: Integer;
begin
  try
    if Key = Chr(46) then
      Key := Chr(44);

    if (Key = Chr(VK_RETURN)) or (Key = Chr(VK_TAB) ) then // Sandro Silva 2023-11-13 if (Key = chr(13)) or (Key = Chr(9) ) then
    begin
      if dBgrid1.DataSource.DataSet.State in [dsInsert, dsEdit] then
      begin
        if TotalParcelasLancadas <> StrToFloat(FormatFloat('0.00', Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) then
        begin
          try
            RateiaDiferencaParcelaEntreAsDemais(Form7.sModulo);
          finally
          end;
        end;
      end;
      {Sandro Silva 2023-11-13 fim}

      if Form7.sModulo = 'COMPRA' then
      begin
        MyBookmark  := Form7.ibDataSet8.GetBookmark;
        if AllTrim(Form7.ibDataSet8DOCUMENTO.AsString) = '' then
          Button4.SetFocus
        else
        begin
          iRegistro   := Form7.ibDataSet8.Recno;
          dDiferenca  := Form7.ibDataSet24TOTAL.Value;
          iDuplicatas := Trunc(Form7.ibDataSet24DUPLICATAS.AsFloat);

          Form7.ibDataSet8.DisableControls;

          Form7.ibDataSet8.First;
          while not Form7.ibDataSet8.Eof do
          begin
            if Form7.ibDataSet8.Recno <= iRegistro then
            begin
              iDuplicatas := iDuplicatas - 1;
              dDiferenca := dDiferenca - Form7.ibDataSet8VALOR_DUPL.Value;
            end else
            begin
             Form7.ibDataSet8.Edit;
             Form7.ibDataSet8VALOR_DUPL.AsFloat := dDiferenca / iDuplicatas;
             Form7.ibDataSet8VALOR_DUPL.AsFloat := StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
            end;
            Form7.ibDataSet8.Next;
          end;

          dDiferenca  := Form7.ibDataSet24TOTAL.Value;
          Form7.ibDataSet8.First;
          while not Form7.ibDataSet8.Eof do
          begin
            dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
            Form7.ibDataSet8.Next;
          end;

          Form7.ibDataSet8.First;
          Form7.ibDataSet8.Edit;
          if dDiferenca <> 0 then
            Form7.ibDataSet8VALOR_DUPL.AsFloat := Form7.ibDataSet8VALOR_DUPL.AsFloat + dDiferenca;

          Form7.ibDataSet8.GotoBookmark(MyBookmark);
          Form7.ibDataSet8.FreeBookmark(MyBookmark);
          Form7.ibDataSet8.EnableControls;
        end;
      end;
    end;

    {Sandro Silva 2023-11-13 inicio}
    if Form7.sModulo = 'VENDA' then
    begin

      if (Key = Chr(VK_DOWN)) or (Key = Chr(VK_UP)) then
      begin
        if dBgrid1.SelectedField.FieldName = 'VALOR_DUPL' then
        begin
          if dBgrid1.DataSource.DataSet.State in [dsInsert, dsEdit] then
          begin
            dBgrid1.DataSource.DataSet.DisableControls; // Sandro Silva 2023-11-21
            dBgrid1.SelectedIndex := dBgrid1.SelectedIndex - 1;
            dBgrid1.SelectedIndex := dBgrid1.SelectedIndex + 1;
            dBgrid1.DataSource.DataSet.EnableControls; // Sandro Silva 2023-11-21
          end;
        end;
      end;

    end;
    {Sandro Silva 2023-11-13 fim}
  except

  end;
end;

procedure TFrmParcelas.SMALL_DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Key = VK_RETURN then
      Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP then
      Perform(Wm_NextDlgCtl,1,0);
    if Key = VK_DOWN then
      Perform(Wm_NextDlgCtl,0,0);
  except
  end;
end;

procedure TFrmParcelas.SMALL_DBEdit1Enter(Sender: TObject);
var
  Total : Real;
  bTemTEF: Boolean;
  cMensagem: String;
begin
  try
    bTemTEF := False;
    FnQtdeParc := Form7.ibDataSet15DUPLICATAS.AsInteger;

    {$Region'//// Vendas - Confere valor Total ////'}
    if Form7.sModulo = 'VENDA' then
    begin
      Total := 0;
      try
        Form7.ibDataSet7.DisableControls;
        Form7.ibDataSet7.First;

        while not Form7.ibDataSet7.Eof do
        begin
          Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;

          if (TestarTEFConfigurado) then
          begin
            if (not bTemTEF) then
              bTemTEF := (Trim(Form7.ibDataSet7AUTORIZACAOTRANSACAO.AsString) <> EmptyStr);
          end;

          Form7.ibDataSet7.Next;
        end;

        if (Abs(Total - (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) > 0.01) and (Total<>0) then
        begin
          cMensagem := 'O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.';
          if bTemTEF then
            cMensagem := cMensagem + sLineBreak + sLineBreak + 'As parcelas com transação TEF serão inativadas, verifique com a sua operadora para efetuar o cancelamento.';

          MensagemSistema(cMensagem, msgAtencao);

          if bTemTEF then
          begin
            GerarParcelasTEFInativadas;
          end;

          if Form7.ibDataSet7.RecordCount > 0 then
          begin
            try
              //Form7.ibDataSet7.DisableControls;
              ReparcelaValor(Form7.ibDataSet7, StrToInt(SMALL_DBEdit1.Text), Form7.ibDataSet15TOTAL.AsFloat);
            finally
              //Form7.ibDataSet7.EnableControls;
            end;
          end;
          {Sandro Silva 2023-11-09 fim}

          try
            //Form7.ibDataSet7.DisableControls;
            SMALL_DBEdit1Exit(Sender);
          finally
            //Form7.ibDataSet7.EnableControls;
          end;
        end;
      finally
        Form7.ibDataSet7.First;
        Form7.ibDataSet7.EnableControls; // Sandro Silva 2023-11-20
      end;
    end;
    {$Endregion}

    {$Region'//// Compras - Confere valor Total ////'}
    if Form7.sModulo = 'COMPRA' then
    begin
      Total := 0;
      Form7.ibDataSet8.First;
      while not Form7.ibDataSet8.Eof do
      begin
        Total := Total + Form7.ibDataSet8VALOR_DUPL.AsFloat;
        Form7.ibDataSet8.Next;
      end;

      if (Abs(Total - Form7.ibDataSet24TOTAL.AsFloat) > 0.01) and (Total<>0) then
      begin
        MensagemSistema('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.',msgAtencao);
        Form7.ibDataSet8.First;
        while not Form7.ibDataSet8.Eof do
          Form7.ibDataSet8.Delete;
        SMALL_DBEdit1Exit(Sender);
      end;
    end;
    {$Endregion}

    DbGrid1.Update;
  except
  end;
end;

procedure TFrmParcelas.GerarParcelasTEFInativadas(AbExibeMensagem: Boolean = False);
var
  nRecNo: Integer;
  qryCartao: TIBQuery;
  i: Integer;
  cCampos, cValores: String;
begin
  qryCartao := CriaIBQuery(Form7.IBTransaction1);
  try
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
      if TestarRegistroComTEF then
      begin
        if AbExibeMensagem then
        begin
          if uDialogs.MensagemSistemaPergunta('As parcelas com transação TEF serão inativadas, verifique com a sua operadora para efetuar o cancelamento.' + sLineBreak + sLineBreak +
                                              'Deseja continuar e alterar a quantidade de parcelas?', [mb_YesNo, mb_DefButton1]) = mrYes then
            AbExibeMensagem := False
          else
          begin
            SMALL_DBEdit1.Text := FnQtdeParc.ToString;
            Form7.ibDataSet15.Edit;
            Form7.ibDataSet15DUPLICATAS.AsInteger := FnQtdeParc;
            Form7.ibDataSet15.Post;
            Form7.ibDataSet15.Edit;
            Abort;
          end;
        end;

        cCampos := EmptyStr;
        cValores := EmptyStr;
        qryCartao.Close;
        qryCartao.SQL.Clear;
        for i := 0 to Pred(Form7.ibDataSet7.Fields.Count) do
        begin
          cCampos := cCampos + Form7.ibDataSet7.Fields[i].FieldName;
          if i <> Pred(Form7.ibDataSet7.Fields.Count) then
            cCampos := cCampos + ',';

          cValores := cValores + ':X' + Form7.ibDataSet7.Fields[i].FieldName;
          if i <> Pred(Form7.ibDataSet7.Fields.Count) then
            cValores := cValores + ',';
        end;
        qryCartao.SQL.Add('INSERT INTO RECEBER (');
        qryCartao.SQL.Add(cCampos);
        qryCartao.SQL.Add(') VALUES (');
        qryCartao.SQL.Add(cValores);
        qryCartao.SQL.Add(')');
        for i := 0 to Pred(Form7.ibDataSet7.Fields.Count) do
        begin
          if AnsiUpperCase(Form7.ibDataSet7.Fields[i].FieldName) <> 'ATIVO' then
          begin
            if AnsiUpperCase(Form7.ibDataSet7.Fields[i].FieldName) <> 'DOCUMENTO' then
              qryCartao.ParamByName('X'+Form7.ibDataSet7.Fields[i].FieldName).Value := Form7.ibDataSet7.Fields[i].Value
            else
              qryCartao.ParamByName('X'+Form7.ibDataSet7.Fields[i].FieldName).Value := EmptyStr;
          end
          else
            qryCartao.ParamByName('X'+Form7.ibDataSet7.Fields[i].FieldName).Value := 1;
        end;
        Form7.ibDataSet7.Delete;
        qryCartao.ExecSQL;

        Form7.ibDataSet7.First;
      end
      else
        Form7.ibDataSet7.Next;
    end;
  finally
    FreeAndNil(qryCartao);
  end;
end;

procedure TFrmParcelas.SMALL_DBEdit16KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    if Key = VK_RETURN then
      Perform(Wm_NextDlgCtl,0,0);
    if Key = VK_UP then
      Perform(Wm_NextDlgCtl,1,0);
    if Key = VK_DOWN then
      Perform(Wm_NextDlgCtl,0,0);
  except
  end;

end;

procedure TFrmParcelas.Label10MouseLeave(Sender: TObject);
begin
  with Sender as tLabel do
    Font.Style := [];
end;

procedure TFrmParcelas.Label10MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  with Sender as tLabel do
    Font.Style := [fsBold];
end;

procedure TFrmParcelas.AjustaPanelTEF;
begin
  FpnlTEF.Visible := False;
  FpnlTEF.Caption := EmptyStr;
  FpnlTEF.Color := Self.Color;
  FpnlTEF.Font.Size := 16;
  FpnlTEF.Font.Style := [fsBold];

  FpnlTEF.Top    := 0;
  FpnlTEF.Left   := 0;
  FpnlTEF.Width  := Self.Width;
  FpnlTEF.Height := Self.Height;

  FpnlTEF.Parent := Self;
  FpnlTEF.BringToFront;
end;

procedure TFrmParcelas.FormShow(Sender: TObject);
var
  Total: Real;
  I: Integer;
  Mais1Ini: tIniFile;

  ConfSistema : TArquivosDAT;
begin
  chkFixarVencimento.Visible := False;

  if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'CLIENTES') then
  begin
    //Carrega coniguraçõs do sistema
    try
      ConfSistema := TArquivosDAT.Create('',Form7.ibDataSet13.Transaction);
      chkFixarVencimento.Left    := 128;
      chkFixarVencimento.Visible := True;
      bConfPrazoFixo             := ConfSistema.BD.Outras.TipoPrazo = 'fixo';
      iDiaVencimento             := ConfSistema.BD.Outras.DiaVencimento;
      chkFixarVencimento.Checked := bConfPrazoFixo;
    finally
      FreeAndNil(ConfSistema);
    end;
  end;


  if Copy(Form7.ibDataSet14CFOP.AsString,2,3) = '929' then
  begin
    Total := 0;
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
       Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
       Form7.ibDataSet7.Next;
     end;

     if (Abs(Total - Form7.ibDataSet15TOTAL.AsFloat) > 0.01) then
     begin
       SMALL_DBEdit1.Enabled := True;
       DBGrid1.Enabled       := True;
     end else
     begin
       SMALL_DBEdit1.Enabled := False;
       DBGrid1.Enabled       := False;
     end;

     lbTotalParcelas.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
  end else
  begin
    DBGrid1.Enabled       := True;

    if Form7.sModulo <> 'CLIENTES' then
    begin
      SMALL_DBEdit1.Enabled := True;
      SMALL_DBEdit1.Visible := True;
      edtQtdParc.Visible    := False;
    end else
    begin
      edtQtdParc.Text := '1';
      edtQtdParc.Visible    := True;
      edtQtdParc.Left := SMALL_DBEdit1.Left;
      SMALL_DBEdit1.Visible := False;
    end;
  end;

  try
    if AnsiUpperCase(Form7.ibDataSet14INTEGRACAO.asString) = 'CAIXA' then
       Close;

    if Form7.sModulo <> 'CLIENTES' then
    begin
      if SMALL_DBEdit1.CanFocus then
      begin
        SMALL_DBEdit1.SetFocus;
        SMALL_DBEdit1.SelectAll;
      end;
    end else
    begin
      if edtQtdParc.CanFocus then
      begin
        edtQtdParc.SetFocus;
        edtQtdParc.SelectAll;
      end;
    end;

    if (AllTrim(Form7.ibDataSet14CONTA.AsString) = '') then
    begin
      Form7.ibDataSet12.First;

      if Form7.SModulo <> 'CLIENTES' then
      begin
        Form43.IdentificadorPlanoContas := FIdentificadorPlanoContas; // Sandro Silva 2022-12-29

        Form43.ShowModal; // OK
        sConta := Form7.ibDataSet12NOME.AsString;
        FIdentificadorPlanoContas := Form7.ibDataSet12IDENTIFICADOR.AsString;// Sandro Silva 2022-12-29
      end else
      begin
        sConta := '';
        FIdentificadorPlanoContas := '';// Sandro Silva 2022-12-29
      end;
    end else
    begin
      sConta := Form7.ibDataSet14CONTA.AsString;
    end;

    Panel9.Color  := Form19.Image9.Picture.BitMap.canvas.pixels[600,500];

    if (Form7.sModulo <> 'VENDA') and (Form7.sModulo <> 'COMPRA') and (Form7.sModulo <> 'CLIENTES') then
      Form7.sModulo := 'VENDA';

    chkConsultaImprimeDanfe.Visible := False;

    if Form7.SModulo = 'CLIENTES' then
    begin
      Form7.ibQuery1.Close;
      Form7.IBQuery1.SQL.Clear;
      Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=9 where coalesce(ATIVO,9)<>1 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString)+' and VALOR_RECE=0');
      Form7.IBQuery1.Open;

      chkConsultaImprimeDanfe.Visible := False;

      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do
        Form7.ibDataSet7.Fields[I-1].Visible := False;
      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;
      //lblTotal.Caption := Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat)]);
      lbTotalParcelas.Caption := Format('%12.2n',[(vlrRenegociacao)]);
      //SMALL_DBEdit1.DataSource := Form7.DataSource15;
      // ***********************************
      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      // ***********************************
      CarregacboDocCobranca;
      Label7.Visible      := True;

      dbGrid1.DataSource := Form7.DataSource7;

      {if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;  Mauricio Parizotto 2023-06-30 }
    end;

    if Form7.SModulo = 'VENDA' then // Ok
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
        chkConsultaImprimeDanfe.Checked := True
      else
        chkConsultaImprimeDanfe.Checked := False;
      Mais1Ini.Free;
      //
      Form7.ibDataSet7.EnableControls;
      for I := 1 to Form7.ibDataSet7.FieldCount do
        Form7.ibDataSet7.Fields[I-1].Visible := False;

      Form7.ibDataSet7DOCUMENTO.Visible  := True;
      Form7.ibDataSet7VENCIMENTO.Visible := True;
      Form7.ibDataSet7VALOR_DUPL.Visible := True;
      Form7.ibDataSet7PORTADOR.Visible   := True;

      {Sandro Silva 2023-06-16 inicio}
      FrmParcelas.Width  := 995;//1000;// 906; // Largura normal
      FrmParcelas.Height := 444; //500;

      lbTotalParcelas.Alignment := taLeftJustify;
      lbTotalParcelas.Left      := 5;
      Form7.ibDataSet7FORMADEPAGAMENTO.Visible     := True; // Sandro Silva 2023-06-16
      Form7.ibDataSet7AUTORIZACAOTRANSACAO.Visible := True; // Sandro Silva 2023-06-22
      Form7.ibDataSet7BANDEIRA.Visible             := True; // Sandro Silva 2023-06-22

      Form7.ibDataSet7VALOR_DUPL.DisplayWidth := 10;
      Form7.ibDataSet7FORMADEPAGAMENTO.Index  := 12;

      Form7.ibDataSet7PORTADOR.DisplayWidth := 20;
      Form7.ibDataSet7DOCUMENTO.DisplayWidth := 11;

      {Sandro Silva 2023-07-05 inicio}
      IBQBANCOS.Close;
      IBQBANCOS.SQL.Text :=
        'select NOME, INSTITUICAOFINANCEIRA ' +
        'from BANCOS ' +
        'order by NOME';
      IBQBANCOS.Open;

      IBQINSTITUICAOFINANCEIRA.Close;
      IBQINSTITUICAOFINANCEIRA.SQL.Text :=
        'select NOME ' +
        'from CLIFOR ' +
        'where CLIFOR in (''Credenciadora de cartão'', ''Instituição financeira'') ' +
        'order by NOME';
      IBQINSTITUICAOFINANCEIRA.Open;

      GetFormasDePagamentoNFe(Form7.slPickListFormaDePagamento);
      GetBanderiasOperadorasNFe(Form7.slPickListBandeira);
      Form7.slPickListBandeira.Add('');
      Form7.slPickListBandeira.Sorted := True;
      Form7.slPickListBandeira.Sort;
      GetBancosNFe(Form7.slPickListBanco);
      GetInstituicaoFinanceira(Form7.slPickListInstituicao);
      {Sandro Silva 2023-07-05 fim}

      {Sandro Silva 2023-06-16 fim}

      lbTotalParcelas.Caption := 'Total: ' + Format('%12.2n',[(Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)]);
      SMALL_DBEdit1.DataSource := Form7.DataSource15;

      // Preenche o combobox com os bancos *
      // configurados no controle bancário *
      CarregacboDocCobranca;

      Label7.Visible      := True;

      dbGrid1.DataSource := Form7.DataSource7;
      if Form7.ibDataSet15DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet15.Edit;
        Form7.ibDataSet15DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet15.Post;
      end;
    end;

    if Form7.SModulo = 'COMPRA' then
    begin
      cboDocCobranca.Visible := False;
      Label7.Visible    := False;

      Form7.ibDataSet8.EnableControls;
      for I := 1 to Form7.ibDataSet8.FieldCount do
        Form7.ibDataSet8.Fields[I-1].Visible := False;
      Form7.ibDataSet8DOCUMENTO.Visible  := True;
      Form7.ibDataSet8VENCIMENTO.Visible := True;
      Form7.ibDataSet8VALOR_DUPL.Visible := True;
      Form7.ibDataSet8PORTADOR.Visible   := True;

      lbTotalParcelas.Caption := Format('%12.2n',[Form7.ibDataSet24TOTAL.AsFloat]);
      SMALL_DBEdit1.DataSource := Form7.DataSource24;
      dbGrid1.DataSource := Form7.DataSource8;

      if Form7.ibDataSet24DUPLICATAS.AsFloat = 0 then
      begin
        Form7.ibDataSet24.Edit;
        Form7.ibDataSet24DUPLICATAS.AsFloat := 1;
        Form7.ibDataSet24.Post;
      end;
    end;

    if Form7.sModulo <> 'CLIENTES' then
    begin
      if SMALL_DBEdit1.CanFocus then
      begin
        SMALL_DBEdit1.SetFocus;
        SMALL_DBEdit1.SelectAll;
      end;

      SMALL_DBEdit1Exit(Sender);
    end else
    begin
      if edtQtdParc.CanFocus then
      begin
        edtQtdParc.SetFocus;
        edtQtdParc.SelectAll;
      end;

      edtQtdParcExit(Sender);
    end;
  except
  end;
  AjustaPanelTEF;

  Form7.ibDataSet7BANDEIRA.ReadOnly             := (Form7.sModulo = 'VENDA') and (Form7.ibDataSet15INDPRES.AsString = '1') and (TestarTEFConfigurado);
  Form7.ibDataSet7AUTORIZACAOTRANSACAO.ReadOnly := Form7.ibDataSet7BANDEIRA.ReadOnly;
end;

procedure TFrmParcelas.DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  OldBkMode : Integer;
  xRect : tREct;
begin
  try
    if Field.Name = 'ibDataSet7VENCIMENTO' then
    begin
      dbGrid1.Canvas.Brush.Color := clWhite;
      dbGrid1.Canvas.Font := dbGrid1.Font;
      if (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1) or (DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7) then
        DBGrid1.Canvas.Font.Color   := clRed
      else
        DBGrid1.Canvas.Font.Color   := clBlack;
      dbGrid1.Canvas.TextOut(Rect.Left+dbGrid1.Canvas.TextWidth('99/99/9999_'),Rect.Top+2,Copy(DiaDaSemana(Form7.ibDataSet7VENCIMENTO.AsDateTime),1,3) );
    end;

    dbGrid1.Canvas.Brush.Color := Form7.Panel7.Color;
    dbGrid1.Canvas.Pen.Color   := clRed;

    xRect.Left   := REct.Left;
    xRect.Top    := -1;
    xRect.Right  := Rect.Right;
    xRect.Bottom := Rect.Bottom - Rect.Top + 0;

    dbGrid1.Canvas.FillRect(xRect);

    OldBkMode := SetBkMode(Handle, TRANSPARENT);
    dbgrid1.Canvas.Font := dbgrid1.TitleFont;
    dbgrid1.Canvas.TextOut(Rect.Left + 2, 2, Trim(Field.DisplayLabel));
    dbgrid1.Canvas.Font.Color := clblack;
    SetBkMode(Handle, OldBkMode);
  except
  end;
end;

procedure TFrmParcelas.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  slFormas: TStringList;
  sForma: String;
  nIndiceAnt: Integer;
begin
  DBGridCopiarCampo((Sender as TDBGrid), Key, Shift); // Mauricio Parizotto 2023-12-26

  try
    if (Shift = [ssCtrl]) and (Key = VK_DELETE) then
      Key := 0;

    {Sandro Silva 2023-06-21 inicio}
    if TDBGrid(Sender).SelectedField.FieldName = 'FORMADEPAGAMENTO' then
    begin
      if (Key = VK_DOWN) or (Key = VK_UP) then
      begin
        slFormas := TStringList.Create;
        GetFormasDePagamentoNFe(slFormas);
        sForma := ValidaFormadePagamentoDigitada(TDBGrid(Sender).SelectedField.AsString, slFormas);
        if TDBGrid(Sender).SelectedField.AsString <> sForma then
        begin
          TDBGrid(Sender).DataSource.DataSet.Edit;
          TDBGrid(Sender).SelectedField.AsString := sForma;
        end;
        slFormas.Free;
      end;
    end;
    {Sandro Silva 2023-06-21 fim}

    if (Key = VK_RETURN) then
    begin
      if Key in [VK_RETURN, VK_TAB] then
      begin
        nIndiceAnt := DbGrid1.SelectedIndex;

        DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;

        while (dBgrid1.SelectedField.ReadOnly) do
        begin
          DbGrid1.SelectedIndex := DbGrid1.SelectedIndex  + 1;
          if (DbGrid1.SelectedIndex = Pred(DBGrid1.Columns.Count)) then
            Break;
        end;

        if (Pred(DBGrid1.Columns.Count) = DbGrid1.SelectedIndex) and ((nIndiceAnt = Pred(DBGrid1.Columns.Count)) or (dBgrid1.SelectedField.ReadOnly)) then
        begin
          DbGrid1.SelectedIndex := 0;

          dBgrid1.DataSource.DataSet.Next;
          if dBgrid1.DataSource.DataSet.EOF then
            Button4.SetFocus;
        end;
      end;

    end;

    {Sandro Silva 2023-11-13 inicio}
    if Form7.sModulo = 'VENDA' then
    begin
      if dBgrid1.SelectedField.FieldName = 'VALOR_DUPL' then
      begin
        if (Key = VK_DOWN) or (Key = VK_UP) then
        begin
          if Form7.ibDataSet7.State in [dsInsert, dsEdit] then
          begin
            Form7.ibDataSet7.Post; // Sandro Silva 2023-11-23

            if TotalParcelasLancadas <> StrToFloat(FormatFloat('0.00', Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) then
            begin
              RateiaDiferencaParcelaEntreAsDemais(Form7.sModulo);
            end;
          end;
        end;
      end;
    end;
    {Sandro Silva 2023-11-13 fim}
  except
  end;
end;

procedure TFrmParcelas.DBGrid1ColEnter(Sender: TObject);
begin
  try
    if (Form7.sModulo = 'VENDA') and (DbGrid1.SelectedIndex = 0) then
      DbGrid1.SelectedIndex := 1;

    SetPickListParaColuna;

    ExibeOpcoesPreencherColunas; // Sandro Silva 2023-06-19

    if (Form7.sModulo = 'VENDA') then
    begin
      Form7.ibDataSet7BANDEIRA.ReadOnly             := (Form7.sModulo = 'VENDA') and (Form7.ibDataSet15INDPRES.AsString = '1') and (TestarTEFConfigurado);
      Form7.ibDataSet7AUTORIZACAOTRANSACAO.ReadOnly := Form7.ibDataSet7BANDEIRA.ReadOnly;

      FRegistroBloqueado := False;
      if TestarRegistroComTEF then
      begin
        FRegistroBloqueado := True;
        TDBGrid(Sender).Options := TDBGrid(Sender).Options - [dgEditing];
      end
      else
        TDBGrid(Sender).Options := TDBGrid(Sender).Options + [dgEditing];
    end;
  except
  end;
end;

procedure TFrmParcelas.DBGrid1Enter(Sender: TObject);
begin
  DbGrid1.SelectedIndex := 1;
  Form7.ibDataSet7.Tag := ID_BLOQUEAR_APPEND_NO_GRID_DESDOBRAMENTO_PARCELAS; // Bloqueia fazer append/insert no dataset
end;

procedure TFrmParcelas.Button4Click(Sender: TObject);
begin

  if (Form7.sModulo = 'VENDA') and (not ChamarTEF) then
    Exit;
  if ValidarDesdobramentoParcela then
    Close;
end;

procedure TFrmParcelas.chkConsultaImprimeDanfeClick(Sender: TObject);
var
  Mais1ini : tInifile;
begin
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    if chkConsultaImprimeDanfe.Checked then
    begin
      Mais1Ini.WriteString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Sim');
    end else
    begin
      Mais1Ini.WriteString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não');
    end;
    Mais1Ini.Free;
  except
  end;
end;

procedure TFrmParcelas.chkFixarVencimentoClick(Sender: TObject);
begin
  if Form7.sModulo = 'VENDA' then
  begin
    if FrmParcelas.Active then
    begin
      try
        Form7.ibDataSet7.DisableControls;
        GeraParcelarReceber(Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat),Form7.ibDataSet15NUMERONF.AsString);
      finally
        Form7.ibDataSet7.EnableControls;
      end;
    end;
  end;

  if Form7.sModulo = 'CLIENTES' then
  begin
    try
      Form7.ibDataSet7.DisableControls;
      GeraParcelarRenegociacao( StrToIntDef(edtQtdParc.Text,1) );
    finally
      Form7.ibDataSet7.EnableControls;
    end;
  end;
end;

function TFrmParcelas.TestarRegistroComTEF: Boolean;
begin
  // Somente VENDA
  // Tem algum TEF configurado
  // Somente presencial
  // Não tem NUMERO AUTORIZACAO
  // FORMA DE PAGAMENTO FOR CARTÃO
  Result := (Form7.sModulo = 'VENDA')
            and (TestarTEFConfigurado)
            and (Form7.ibDataSet15INDPRES.AsString = '1')
            and (Trim(dBgrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) <> EmptyStr)
            and (FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString));
end;

function TFrmParcelas.TestarRegistroPodeChamarTEF: Boolean;
begin
  // Somente VENDA
  // Tem algum TEF configurado
  // Somente presencial
  // Não tem NUMERO AUTORIZACAO
  // FORMA DE PAGAMENTO FOR CARTÃO
  Result := (Form7.sModulo = 'VENDA')
            and (TestarTEFConfigurado)
            and (Form7.ibDataSet15INDPRES.AsString = '1')
            and (Trim(dBgrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) = EmptyStr)
            and (FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString));
end;

function TFrmParcelas.ChamarTEF: Boolean;
var
  I: Integer;
  oTEF: TFuncoesTEF;
  nTotalCartao: Currency;
  bAprovado: Boolean;
  bPodeTEF: Boolean;
begin
  Result := False;
  DBGrid1.DataSource.DataSet.First;

  DBGrid1.DataSource.DataSet.DisableControls;
  try
    bPodeTEF := False;
    while not DBGrid1.DataSource.DataSet.Eof do
    begin
      bPodeTEF := TestarRegistroPodeChamarTEF;
      if bPodeTEF then
        Break;
        // Seta True para deixar passar quando não permite TEF.
      DBGrid1.DataSource.DataSet.Next;
    end;
    if not bPodeTEF then
    begin
      Result := True;
      Exit;
    end;
  finally
    DBGrid1.DataSource.DataSet.EnableControls;
  end;

  try
    // Somar todos os registros com tipo cartão.
    nTotalCartao := RetornaTotalReceberCartao;
    // Se total menor ou igual a zero não faz nada
    if nTotalCartao <= 0 then
      Exit;

    oTEF := TFuncoesTEF.Create;
    try
      oTEF.IBDataBase := Form7.IBDatabase1;
      oTEF.CNPJ       := Form7.ibDataSet13CGC.AsString;
      oTEF.BuildEXE   := TRetornarBuildEXE.New
                                        .Retornar(True);
      // Fixo 1 no Commerce
      oTEF.QtdeCartoes := 1;
      oTEF.ValorCobrar := nTotalCartao;


      try
        ExibirMensagemTEF('Comunicando com o TEF...');
        bAprovado := oTEF.InciarTransacaoTEF(True);
        if not bAprovado then
        begin
          ExibirMensagemTEF(oTEF.DadosTransacao.Mensagem);
          Abort;
        end;
        ExibirMensagemTEF(oTEF.DadosTransacao.Mensagem);
        ExibirMensagemTEF('Atualizando contas, aguarde...');
        GerarParcelasCartao(oTEF.DadosTransacao);
        ExibirMensagemTEF('Confirmando transação TEF, aguarde...');
        oTEF.ConfirmaTransacao;
      finally
        FpnlTEF.Visible := False;
      end;

      Result := True;
    finally
      FreeAndNil(oTEF);
    end;
  except
    Abort;
  end;
end;

procedure TFrmParcelas.ExibirMensagemTEF(AcTexto: String);
begin
  Application.ProcessMessages;
  FpnlTEF.Caption := AcTexto;
  FpnlTEF.Visible := True;
  Application.ProcessMessages;
  Sleep(2000);
end;

procedure TFrmParcelas.GerarParcelasCartao(AoDadosTransacao: TDadosTransacao);
var
  i,x: Integer;
  nValorParc: Currency;
  nRestoParc: Currency;
  oDataSet: TIBDataSet;
  oDataSetTemp: TIBDataSet;
begin
  oDataSet := (dBgrid1.DataSource.DataSet as TIBDataSet);

  oDataSetTemp := CriaIDataSet(Form7.IBTransaction1);
  oDataSet.DisableControls;
  try
    oDataSetTemp.InsertSQL := oDataSet.InsertSQL;
    oDataSetTemp.DeleteSQL := oDataSet.DeleteSQL;
    oDataSetTemp.Close;
    oDataSetTemp.Database := oDataSet.Database;
    oDataSetTemp.Selectsql.Clear;
    oDataSetTemp.Selectsql.Text := oDataSet.SelectSQL.Text;
    oDataSetTemp.Open;

    oDataSet.First;

    while not oDataSet.Eof do
    begin
      if (FormaDePagamentoEnvolveCartao(oDataSet.FieldByName('FORMADEPAGAMENTO').AsString)) and (Trim(DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) = EmptyStr) then
      begin
        if oDataSetTemp.IsEmpty then
        begin
          // Deve inserir apenas um registro temporario de cartão, para assim
          // ser duplicado conforme as parcelas do TEF
          oDataSetTemp.Append;
          for I := 0 to Pred(oDataSet.Fields.Count) do
          begin
            if oDataSet.Fields[i].FieldName <> 'REGISTRO' then
              oDataSetTemp.FieldByName(oDataSet.Fields[i].FieldName).Value := oDataSet.Fields[i].Value
            else
              oDataSetTemp.FieldByName(oDataSet.Fields[i].FieldName).AsString := IntToStr(9999999000 + i); // Gera numero Temporario
          end;
          oDataSetTemp.Post;
        end;

        oDataSet.Delete;
        oDataSet.First;
      end else
        oDataSet.Next;
    end;

    oDataSetTemp.First;

    // DEBITO retorna como 0 parcelas
    if AoDadosTransacao.QtdeParcela <= 0 then
      AoDadosTransacao.QtdeParcela := 1;

    SMALL_DBEdit1.Text := AoDadosTransacao.QtdeParcela.ToString;
    // Vai gerar as parcelas
    for i := 1 to AoDadosTransacao.QtdeParcela do
    begin
      AdicionarParcela;

      nValorParc := StrToFloat(FormatFloat('0.00', AoDadosTransacao.TotalPago / AoDadosTransacao.QtdeParcela));

      nRestoParc := 0;

      if (i = 1) and ((nValorParc * AoDadosTransacao.QtdeParcela) <> AoDadosTransacao.TotalPago) then
        nRestoParc := AoDadosTransacao.TotalPago - (nValorParc * AoDadosTransacao.QtdeParcela);

      oDataSet.Edit;

      oDataSet.FieldByName('PORTADOR').AsString             := oDataSetTemp.FieldByName('PORTADOR').AsString;
      oDataSet.FieldByName('VENCIMENTO').AsDateTime         := IncMonth(Date, i);
      oDataSet.FieldByName('VALOR_DUPL').AsCurrency         := nValorParc + nRestoParc;
      oDataSet.FieldByName('BANDEIRA').AsString             := AoDadosTransacao.Bandeira;
      oDataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString := AoDadosTransacao.Autoriza;
      if (AoDadosTransacao.DebitoOuCredito = 'CREDITO') then
        oDataSet.FieldByName('FORMADEPAGAMENTO').AsString := 'Cartão de Crédito';
      if (AoDadosTransacao.DebitoOuCredito = 'DEBITO') then
        oDataSet.FieldByName('FORMADEPAGAMENTO').AsString := 'Cartão de Débito';
      if (AoDadosTransacao.DebitoOuCredito = 'PIX') then
        //oDataSet.FieldByName('FORMADEPAGAMENTO').AsString := 'Pagamento Instantâneo (PIX)'; Mauricio Parizotto 2024-07-10
        oDataSet.FieldByName('FORMADEPAGAMENTO').AsString := _FormaPixDinamico;
      oDataSet.Post;
    end;

    RefazerNumeroParcela;
  finally
    oDataSet.First;
    oDataSet.EnableControls;

    oDataSetTemp.First;
    while not oDataSetTemp.Eof do
    begin
      oDataSetTemp.Delete;
      oDataSetTemp.First;
    end;
    FreeAndNil(oDataSetTemp);
  end;
end;

procedure TFrmParcelas.RefazerNumeroParcela;
var
  nParcelaAtual: Integer;
begin
  dBgrid1.DataSource.DataSet.First;
  try
    nParcelaAtual := 0;
    while not dBgrid1.DataSource.DataSet.Eof do
    begin
      nParcelaAtual := nParcelaAtual + 1;

      Form7.ibDataSet7.Edit;
      if Form7.sRPS <> 'S' then
      begin
        if Copy(Form7.ibDataSet15NUMERONF.AsString,10,3) = '002' then
        begin
          Form7.ibDataSet7DOCUMENTO.Value := 'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,2,8) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
        end else
        begin
          Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
        end;
      end else
      begin
        Form7.ibDataSet7DOCUMENTO.Value := Copy(Form7.ibDataSet15NUMERONF.AsString,1,1)+'S'+Copy(Form7.ibDataSet15NUMERONF.AsString,3,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),nParcelaAtual,1);
      end;
      Form7.ibDataSet7.Post;

      dBgrid1.DataSource.DataSet.Next;
    end;
  finally
    dBgrid1.DataSource.DataSet.First;
  end;
end;

function TFrmParcelas.RetornaTotalReceberCartao: Currency;
var
  nRecNo: Integer;
begin
  Result := 0;

  nRecNo := DBGrid1.DataSource.DataSet.RecNo;
  DBGrid1.DataSource.DataSet.DisableControls;
  try
    DBGrid1.DataSource.DataSet.First;

    while not DBGrid1.DataSource.DataSet.Eof do
    begin
      if (FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString)) and (Trim(DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) = EmptyStr) then
        Result := Result + dBgrid1.DataSource.DataSet.FieldByName('VALOR_DUPL').AsCurrency;

      DBGrid1.DataSource.DataSet.Next;
    end;
  finally
    DBGrid1.DataSource.DataSet.RecNo := nRecNo;
    DBGrid1.DataSource.DataSet.EnableControls;
  end;
end;

procedure TFrmParcelas.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Mais1Ini : tIniFile;
  bButton : Integer;
  F : TextFile;
  I : Integer;
  //sSenhaX, sSenha : String;
  ftotal1 : Real;
  Total : Real;
  ConsultaImprimeDanfe : Boolean;
begin
  {$Region'//// Vendas ////'}
  if Form7.sModulo = 'VENDA' then
  begin
    Total := 0;
    Form7.ibDataSet7.First;
    while not Form7.ibDataSet7.Eof do
    begin
      Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
      Form7.ibDataSet7.Next;
    end;

    if (Abs(Total - (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) > 0.01) and (Total<>0) then
    begin
      //ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.'); Mauricio Parizotto 2023-10-25
      MensagemSistema('O total das parcelas diverge do valor total'+Chr(10)+'da nota. As parcelas serão recalculadas.',msgAtencao);

      SMALL_DBEdit1.SetFocus;
      Abort;
    end;

    {Sandro Silva 2023-06-16 inicio}
    // Limpa picklist das formas de pagamento a receber
    for i := 0 to DBGrid1.Columns.Count -1 do
    begin
      DBGrid1.Columns[i].PickList.Clear;
    end;

    Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_BOLETO;
    //Form7.ibDataSet7.DisableControls; Mauricio Parizotto 2024-04-23
    {Sandro Silva 2023-06-16 fim}
  end;
  {$Endregion}

  {$Region'//// Clientes ////'}
  try
    Close;
    if Form7.sModulo = 'CLIENTES' then
    begin
      // ACORDO
      Form7.sTextoDoAcordo := 'TERMO DE RENEGOCIAÇÃO DE DÍVIDA '+Form7.ibDataSet15NUMERONF.AsString+chr(13)+chr(10)+chr(13)+chr(10)+
                              'Na presente data ('+DateToStr(Date)+') é regido o acordo de novação de dívida entre a empresa ('+Form7.ibDataSet13NOME.AsString+') '+
                              'sendo assim pessoa jurídica de direito privado, inscrita no CNPJ ('+Form7.ibDataSet13CGC.AsString+'), com sede em ('+
                              Form7.ibDataSet13MUNICIPIO.AsString +', '+ Form7.ibDataSet13ESTADO.AsString +'). '+
                              'Do outro lado o devedor ('+Form7.ibDataset2NOME.AsString+'), portador do CPF/CNPJ ('+Form7.ibDataset2CGC.AsString+
                              '), residente e domiciliado em ('+Form7.ibDataset2CIDADE.AsString+'-'+Form7.ibDataSet2ESTADO.AsString +'). '+
                              'O Devedor declara e se confessa devedor, nesta data, da importância de R$ '+
                              AllTrim(Format('%12.'+Form1.ConfCasas+'n',[Form7.ibDataSet15TOTAL.AsFloat]))+' ('+AllTrim(Extenso(Form7.ibDataSet15TOTAL.AsFloat))+'). '+
                              'Referente a parcelas anteriormente acordadas em aberto conforme tabelas abaixo:'+chr(13)+chr(10)+chr(13)+chr(10)+
                              Form7.sTextoDoAcordo+chr(13)+chr(10)+
                              'Afim da regularização do débito ambas as partes decidem celebrar o seguinte acordo. '+
                              'O Credor, pretendendo reaver o seu crédito, compromete-se a parcelar o valor desta dívida, '+
                              'devidamente corrigido com a respectiva atualização, a contar do vencimento combinado entre '+
                              'ambos, o devedor, por sua vez, aceita a presente novação, obrigando-se a efetuar os pagamentos '+
                              'nas condições e formas descritas neste documento. '+chr(13)+chr(10)+
                              'O Devedor pagará ao Credor ('+Form7.ibDataSet15DUPLICATAS.AsString+') parcela(s) conforme tabela abaixo. '+chr(13)+chr(10)+chr(13)+chr(10)+
                              'Parcela    Vencimento   Valor R$'+chr(13)+chr(10)+
                              '---------- ------------ -------------'+chr(13)+chr(10);

      // Zeresima
      fTotal1 := 0;

      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        Form7.sTextoDoAcordo := Form7.sTextoDoAcordo + Copy(Form7.ibDataSet7DOCUMENTO.AsString+Replicate(' ',10),1,10) +' '+DateTimeToStr(Form7.ibDataSet7VENCIMENTO.AsDateTime)+' '+Format('%15.2n',[Form7.ibDataSet7VALOR_DUPL.AsFloat])+chr(13)+chr(10);
        ftotal1 := fTotal1 + Form7.ibDataSet7VALOR_DUPL.AsFloat;
        Form7.ibDataSet7.Next;
      end;

      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
                              '                        -------------'+chr(13)+chr(10)+
                              '                      '+Format('%15.2n',[ftotal1])+chr(13)+chr(10);

      Form7.sTextoDoAcordo := Form7.sTextoDoAcordo +
      chr(13)+chr(10)+
      'O Devedor efetuará o pagamento na data de vencimento de cada parcela conforme combinado entre ambas as partes. '+
      'Estando ciente o devedor que no caso de inadimplemento de uma ou mais parcelas, terá o devedor seu nome inscrito no Serviço de Proteção ao Crédito. '+
      'Este termo de renegociação de dívida passa a valer a partir da comprovação do pagamento da primeira parcela. A divida total sera considerada quitada mediante o pagamento pontual de todas as parcelas. '+
      'Fica eleito o foro da cidade de '+Form7.ibDataSet13MUNICIPIO.AsString +', '+ Form7.ibDataSet13ESTADO.AsString +' para dirimir dúvidas a respeito do presente Termo de Renegociação de Dívida, renunciando qualquer outro foro por mais especial e privilegiado que seja. '+
      'E por se acharem justo e pactuados, conforme os termos e condições aqui estabelecidas, firmam o presente Termo de Renegociação de Dívida em duas vias de igual teor.'+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      Trim(Form7.ibDataSet13MUNICIPIO.AsString)+', '+Copy(DateTimeToStr(Date),1,2)+' de ' + Trim(MesExtenso( StrToInt(Copy(DateTimeToStr(Date),4,2)))) + ' de ' + Copy(DateTimeToStr(Date),7,4)+chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      Form7.ibDataSet13NOME.AsString+chr(13)+chr(10)+
      Form7.ibDataSet13CGC.AsString+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      Form7.ibDataset2NOME.AsString+chr(13)+chr(10)+
      Form7.ibDataset2CGC.AsString+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+chr(13)+chr(10)+
      //
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      'TESTEMUNHA COM CPF'+chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      chr(13)+chr(10)+
      '---------------------------------------------------------'+chr(13)+chr(10)+
      'TESTEMUNHA COM CPF';

      AssignFile(F,pchar('ACORDO'+Form7.ibDataSet15NUMERONF.AsString+'.txt'));  // Direciona o arquivo F para EXPORTA.TXT
      Rewrite(F);                  // Abre para gravação
      WriteLn(F,Form7.sTextoDoAcordo);
      CloseFile(F); // Fecha o arquivo
      ShellExecute( 0, 'Open',pchar('ACORDO'+Form7.ibDataSet15NUMERONF.AsString+'.txt'),'','', SW_SHOWMAXIMIZED);

      bButton := Application.MessageBox(Pchar('Confirma a renegociação?'),'Atenção', mb_YesNo + mb_DefButton2 + MB_ICONQUESTION);

      if bButton = IDYES then
      begin
        //if AnsiUpperCase(sSenha) = AnsiUpperCase(Senha2) then
        if GetSenhaAdmin then
        begin
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set PORTADOR='+QuotedStr('ACORDO '+Form7.ibDataSet15NUMERONF.AsString)+' where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=1 where coalesce(ATIVO,0)=9 and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.IBDataSet2.Edit;
          Form7.IBDataSet2MOSTRAR.AsFloat := 0;
        end else
        begin
          // Volta tudo
          Form7.ibQuery1.Close;
          Form7.IBQuery1.SQL.Clear;
          Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
          Form7.IBQuery1.Open;

          Form7.ibDataSet7.First;
          while not Form7.ibDataSet7.Eof do
          begin
            Form7.ibDataSet7.Delete;
            Form7.ibDataSet7.First;
          end;
        end;
      end else
      begin
        // Volta tudo
        Form7.ibQuery1.Close;
        Form7.IBQuery1.SQL.Clear;
        Form7.IBQuery1.SQL.Add('update RECEBER set ATIVO=0 where coalesce(ATIVO,0)=9  and NOME='+QuotedStr(Form7.IBDataSet2NOME.AsString));
        Form7.IBQuery1.Open;

        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;
      end;
    end;

    if Form7.sModulo = 'VENDA' then
    begin
      Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
      if Mais1Ini.ReadString('Nota Fiscal','Transmitir Consultar Imprimir Nf-e no final','Não') = 'Sim' then
        ConsultaImprimeDanfe := True
      else
        ConsultaImprimeDanfe := False;
      Mais1Ini.Free;

      if ConsultaImprimeDanfe then
      begin
        Form7.bProximas := True;
        Form7.N6EnviarNFeConsultareImprimirDANFE1Click(Sender);
        Form7.bProximas := False;
      end;

      if (Pos('<nfeProc',Form7.ibDataSet15NFEXML.AsString) <> 0) or (ConsultaImprimeDanfe = False) then
      begin
        if (cboDocCobranca.Text <> '<Não imprimir documento>') and (AllTrim(cboDocCobranca.Text) <> '') then
        begin
          if cboDocCobranca.Text <> '<Imprimir Duplicata>' then
          begin
            if cboDocCobranca.Text <> '<Imprimir Carnê>' then
            begin
              {Sandro Silva 2023-06-20 inicio
              Form1.sEscolhido       := Form18.ComboBox1.Text;
              Form25.btnEnviaEmailTodos.Visible := True; // Sandro Silva 2022-12-23 Form25.Button8.Visible := True;
              Form25.ShowModal;
              Form25.btnEnviaEmailTodos.Visible := False; // Sandro Silva 2022-12-23 Form25.Button8.Visible := False;
              }
              try
                {Sandro Silva 2023-07-12 inicio
                Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_BOLETO;
                Form7.ibDataSet7.DisableControls;
                {Sandro Silva 2023-07-12 fim}

                //Posiciona na primeira parcela do desdobramento
                Form7.ibDataSet7.First; // Sandro Silva 2023-07-20

                if Form7.ibDataSet7VALOR_DUPL.AsString <> '' then
                begin
                  Form1.sEscolhido       := cboDocCobranca.Text;
                  Form1.sBancoBoleto     := Trim(StringReplace(cboDocCobranca.Text, 'Boleto de cobrança do', '', [rfReplaceAll]));
                  Form25.btnEnviaEmailTodos.Visible := True;
                  Form25.ShowModal;
                  Form25.btnEnviaEmailTodos.Visible := False;
                end;

              finally
                Form7.ibDataSet7.EnableControls;
                Form7.ibDataSet7.Tag := 0;
              end;

              Form25.btnEnviaEmailTodos.Visible := False; // Sandro Silva 2022-12-23 Form25.Button8.Visible := False;
              {Sandro Silva 2023-06-20 fim}
            end else
            begin

              Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_CARNE_DUPLICATA;

              Form7.Close;
              Form7.Show;

              {Sandro Silva 2023-10-06 inicio
              ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'2'), '', SW_SHOW);
              }
              if Trim(Form7.ibDataSet7DOCUMENTO.AsString) = '' then
                MensagemSistema('Para emissão de Carnês ou Duplicatas o desdobramento das contas deverá conter ao menos uma das seguintes formas: ' + #13 +
                                '- Sem informar forma ' + #13 +
                                '- Crédito loja ' + #13 +
                                '- Duplicata Mercantil ' + #13 +
                                '- Outros')
              else
                ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'2'), '', SW_SHOW);
              {Sandro Silva 2023-10-06 fim}
            end;
          end else
          begin
            Form7.ibDataSet7.Tag := ID_FILTRAR_FORMAS_GERAM_CARNE_DUPLICATA;
            Form7.Close;
            Form7.Show;
            {Sandro Silva 2023-10-06 inicio
            ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'1'), '', SW_SHOW);
            }
            if Trim(Form7.ibDataSet7DOCUMENTO.AsString) = '' then
              MensagemSistema('Para emissão de Carnês ou Duplicatas o desdobramento das contas deverá conter ao menos uma das seguintes formas: ' + #13 +
                              '- Sem informar forma ' + #13 +
                              '- Crédito loja ' + #13 +
                              '- Duplicata Mercantil ' + #13 +
                              '- Outros')
            else
              ShellExecute( 0, 'Open', 'smalldupl.exe',pChar(Form7.ibDataSet7DOCUMENTO.AsString+' '+'1'), '', SW_SHOW);
            {Sandro Silva 2023-10-06 fim}
          end;
        end;
      end;
    end;
    {Sandro Silva 2023-07-12 inicio}
    Form7.ibDataSet7VALOR_DUPL.DisplayWidth := 14;
    FrmParcelas.Width  := 600; // Largura normal
    FrmParcelas.Height := 421; // Altura normal
    lbTotalParcelas.Alignment := taRightJustify;
    lbTotalParcelas.Left      := 239;
    Form7.ibDataSet7FORMADEPAGAMENTO.Visible := False; // Sandro Silva 2023-06-16
    Form7.ibDataSet7PORTADOR.Index := 12;
    Form7.ibDataSet7PORTADOR.DisplayWidth  := 33;
    Form7.ibDataSet7DOCUMENTO.DisplayWidth := 12;
    Form7.ibDataSet7.Tag := 0; // Sandro Silva 2023-07-18
    Form1.sBancoBoleto     := ''; // Sandro Silva 2023-07-18
    {Sandro Silva 2023-07-12 fim}

    Form7.ibDataSet7BANDEIRA.ReadOnly             := (Form7.sModulo = 'VENDA') and (Form7.ibDataSet15INDPRES.AsString = '1') and (TestarTEFConfigurado);
    Form7.ibDataSet7AUTORIZACAOTRANSACAO.ReadOnly := Form7.ibDataSet7BANDEIRA.ReadOnly;
  except
  end;
  {$Endregion}
end;

procedure TFrmParcelas.ExibeOpcoesPreencherColunas;
begin
  if (FRegistroBloqueado) or (DBGrid1.DataSource.DataSet.FieldByName(DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName).ReadOnly) then
    Exit;

  if (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'BANDEIRA')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'PORTADOR')
     or
     (DbGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'AUTORIZACAOTRANSACAO')
     then
  begin
    if (DbGrid1.Columns[DbGrid1.SelectedIndex].PickList.Count > 0) then
    begin
      keybd_event(VK_F2,0,0,0);
      keybd_event(VK_F2,0,KEYEVENTF_KEYUP,0);
      keybd_event(VK_MENU,0,0,0);
      keybd_event(VK_DOWN,0,0,0);
      keybd_event(VK_DOWN,0,KEYEVENTF_KEYUP,0);
      keybd_event(VK_MENU,0,KEYEVENTF_KEYUP,0);
    end;
  end;
end;

procedure TFrmParcelas.edtQtdParcEnter(Sender: TObject);
var
  Total : Real;
begin
  try
    if Form7.sModulo = 'CLIENTES' then // Ok
    begin
      Total := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        Total := Total + Form7.ibDataSet7VALOR_DUPL.AsFloat;
        Form7.ibDataSet7.Next;
      end;

      if (Abs(Total - vlrRenegociacao) > 0.01) and (Total<>0) then
      begin
        //ShowMessage('O total das parcelas diverge do valor total'+Chr(10)+'da renegociação. As parcelas serão recalculadas.'); Mauricio Parizotto 2023-10-25
        MensagemSistema('O total das parcelas diverge do valor total'+Chr(10)+'da renegociação. As parcelas serão recalculadas.');

        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;

        edtQtdParcExit(Sender);
      end;
    end;

    DbGrid1.Update;
  except
  end;
end;

procedure TFrmParcelas.edtQtdParcExit(Sender: TObject);
Var
  I : Integer;
  dDiferenca : Double;
  QtdParc : integer;
begin
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

  QtdParc := StrToIntDef(edtQtdParc.Text,1);

  try
    if Form7.sModulo = 'CLIENTES' then
    begin
      // Cria as duplicatas
      // Número das duplicatas de A - Z, ou sejá no máximo 24 duplicatas //

      I := 0;
      Form7.ibDataSet7.First;
      while not Form7.ibDataSet7.Eof do
      begin
        I := I + 1;
        Form7.ibDataSet7.Next;
      end;

      if I <> QtdParc then
      begin
        GeraParcelarRenegociacao(QtdParc);
        {Mauricio Parizotto 2024-04-24
        Form7.ibDataSet7.First;
        while not Form7.ibDataSet7.Eof do
        begin
          Form7.ibDataSet7.Delete;
          Form7.ibDataSet7.First;
        end;

        for I := 1 to QtdParc do
        begin
          Form7.ibDataSet7.Append;
          Form7.ibDataSet7NUMERONF.AsString                          := nrRenegociacao;
          Form7.ibDataSet7DOCUMENTO.Value                            := 'RE'+Right(nrRenegociacao,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
          Form7.ibDataSet7VALOR_DUPL.AsFloat                         := Arredonda((vlrRenegociacao) / QtdParc,2);
          Form7.ibDataSet7HISTORICO.Value                            := 'CODIGO DO ACORDO '+nrRenegociacao;
          Form7.ibDataSet7EMISSAO.asDateTime                         := Date;
          Form7.ibDataSet7NOME.Value                                 := Form7.ibDataSet2NOME.Value;
          Form7.ibDataSet7CONTA.AsString                             := sConta;

          if I = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
          if I = 2 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
          if I = 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
          if I > 3 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))-StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));

          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;

          if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
            Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;
          end;

          Form7.ibDataSet7.Post;
        end;

        // Valor quebrado
        //dDiferenca := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
        dDiferenca := (vlrRenegociacao - Form1.fRetencaoIR);
        Form7.ibDataSet7.First;

        while not Form7.ibDataSet7.Eof do
        begin
          dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
          Form7.ibDataSet7.Next;
        end;

        Form7.ibDataSet7.First;
        Form7.ibDataSet7.Edit;
        if dDiferenca <> 0 then
          Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + dDiferenca;
        }
      end;
    end;

    Form7.ibDataSet7.First;
  except
  end;
end;

procedure TFrmParcelas.DBGrid1ColExit(Sender: TObject);
var
  iRecno: Integer;
  sForma: String;
  sPortador: String;
  sAutorizacao: String;
  sBandeira: String;

  ano, mes, dia : string;
  DataVencimento, DataVencimentoAnt : TdateTime;
begin
  if (Form7.ibDataSet7FORMADEPAGAMENTO.Visible) and (Form7.sModulo = 'VENDA') then
  begin
    {$Region'//// Seta forma de pagamento ////'}
    if DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO' then
    begin
      DBGrid1.DataSource.DataSet.DisableControls;

      try
        iRecno := DBGrid1.DataSource.DataSet.RecNo;
        sForma := ValidaFormadePagamentoDigitada(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString, TStringList(DBGrid1.Columns[DBGrid1.SelectedIndex].PickList));

        if DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString <> sForma then
        begin
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
        end;

        if sForma <> '' then
        begin
          while DBGrid1.DataSource.DataSet.Eof = False do
          begin
            if DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString = '' then
            begin
              DBGrid1.DataSource.DataSet.Edit;
              DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
            end;

            DBGrid1.DataSource.DataSet.Next;
          end;

          DBGrid1.DataSource.DataSet.RecNo := iRecno;
        end
        else
        begin
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := '';
        end;
      finally
        DBGrid1.DataSource.DataSet.EnableControls;
      end;
    end;
    {$Endregion}

    {$Region'//// Seta portador, bandeira... ////'}

    //Ao preencher o campo Portador, Autorização e Bandeira deve aplicar para as demais parcelas que possuem
    //a mesma forma de pagamento e o campo Portador=EM CARTEIRA ou em branco e Autorização e Bandeira em branco

    if (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'PORTADOR') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'AUTORIZACAOTRANSACAO') or
       (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'BANDEIRA')
     then
    begin
      DBGrid1.DataSource.DataSet.DisableControls;
      try
        iRecno       := DBGrid1.DataSource.DataSet.RecNo;
        sPortador    := DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString;
        sForma       := DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString;
        sAutorizacao := DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString;
        sBandeira    := DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString;

        while DBGrid1.DataSource.DataSet.Eof = False do
        begin
          if (DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString = sForma)
            and ((DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString = 'EM CARTEIRA') or (Trim(DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString) = '') or (DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString = sPortador))
            then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString := sPortador;

            if (DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString = '') then
              DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString := sAutorizacao;

            if (DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString = '') then
              DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString := sBandeira;
          end;
          DBGrid1.DataSource.DataSet.Next;
        end;

        DBGrid1.DataSource.DataSet.RecNo := iRecno;

      finally
        DBGrid1.DataSource.DataSet.EnableControls;
      end;
    end;
    {$Endregion}
  end;

  {$Region'//// Seta data de vencimento ////'}
  //Mauricio Parizotto 2024-04-23
  if (Form7.sModulo = 'VENDA') or (Form7.sModulo = 'CLIENTES') then
  begin
    DataVencimento    := Form7.ibDataSet7VENCIMENTO.AsDateTime;
    DataVencimentoAnt := Form7.ibDataSet7VENCIMENTO.OldValue;

    if (chkFixarVencimento.Checked)
      and (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'VENCIMENTO')
      and (DataVencimentoAnt <> DataVencimento) then
    begin
      dia            := FormatDateTime('dd',Form7.ibDataSet7VENCIMENTO.AsDateTime);
      iRecno         := DBGrid1.DataSource.DataSet.RecNo;

      try
        Form7.ibDataSet7.DisableControls;

        DBGrid1.DataSource.DataSet.Next;

        while DBGrid1.DataSource.DataSet.Eof = False do
        begin
          DBGrid1.DataSource.DataSet.Edit;

          DataVencimento := IncMonth(DataVencimento,1);

          ano := FormatDateTime('yyyy',DataVencimento);
          mes := FormatDateTime('mm',DataVencimento);
          TryStrToDate(dia+'/'+mes+'/'+ano,DataVencimento);

          Form7.ibDataSet7VENCIMENTO.AsDateTime := DataVencimento;

          DBGrid1.DataSource.DataSet.Next;
        end;

        DBGrid1.DataSource.DataSet.RecNo := iRecno;
      finally
         Form7.ibDataSet7.EnableControls;
      end;
    end;
  end;
  {$Endregion}

  {Sandro Silva 2023-11-23 inicio}
  if (DBGrid1.Columns[DBGrid1.SelectedIndex].FieldName = 'VALOR_DUPL') then
  begin
    if DBGrid1.DataSource.DataSet.State in [dsEdit, dsInsert] then
    begin
      DBGrid1.DataSource.DataSet.Post;

      if TotalParcelasLancadas <> StrToFloat(FormatFloat('0.00', Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) then
      begin
        RateiaDiferencaParcelaEntreAsDemais(Form7.sModulo);
      end;
    end;
  end;
  {Sandro Silva 2023-11-23 fim}
end;

procedure TFrmParcelas.DBGrid1CellClick(Column: TColumn);
begin
  {Sandro Silva 2023-11-13 inicio}
  if Form7.sModulo = 'VENDA' then
  begin
    if Column.FieldName = 'VALOR_DUPL' then
    begin
      {Sandro Silva 2023-11-21 inicio}
      if Column.Field.DataSet.State in [dsEdit, dsInsert] then
        Column.Field.DataSet.Post;
      {Sandro Silva 2023-11-21 fim}
      if TotalParcelasLancadas <> StrToFloat(FormatFloat('0.00', Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)) then
      begin
        RateiaDiferencaParcelaEntreAsDemais(Form7.sModulo);
      end;
    end;
  end;
  {Sandro Silva 2023-11-13 fim}
  ExibeOpcoesPreencherColunas;
end;

procedure TFrmParcelas.CarregacboDocCobranca;
var
  Mais1Ini: tIniFile;
  sSecoes:  TStrings;
  J: Integer;
  sBancoIni: String;
begin
  // ***********************************
  // Preenche o combobox com os bancos *
  // configurados no controle bancário *
  // ***********************************
  cboDocCobranca.Items.Clear;
  cboDocCobranca.Items.Add('<Não imprimir documento>');

  sSecoes := TStringList.Create;
  try
    Mais1ini := TIniFile.Create(Form1.sAtual+'\smallcom.inf');
    Mais1Ini.ReadSections(sSecoes);

    for J := 0 to (sSecoes.Count - 1) do
    begin
      if (Mais1Ini.ReadString(sSecoes[J],'CNAB400','Não') = 'Sim') or (Mais1Ini.ReadString(sSecoes[J],'CNAB240','Não') = 'Sim') then
      begin
        //cboDocCobranca.Items.Add(sSecoes[J]);  Mauricio Parizotto 2023-06-19

        sBancoIni := trim(StringReplace(sSecoes[J],'Boleto de cobrança do ','',[rfReplaceAll]));

        if ExecutaComandoEscalar(Form7.IBDatabase1,
                                 ' Select Count(*) From BANCOS '+
                                 ' Where NOME = '+QuotedStr(sBancoIni)) > 0 then
        begin
          cboDocCobranca.Items.Add(sSecoes[J]);
        end;
      end;
    end;

    Mais1Ini.Free;
  except
  end;

  cboDocCobranca.Items.Add('<Imprimir Duplicata>');
  cboDocCobranca.Items.Add('<Imprimir Carnê>');

  cboDocCobranca.Visible   := True;
  cboDocCobranca.ItemIndex := 0;

  sSecoes.Free;
end;

procedure TFrmParcelas.GetBancosNFe(slBanco: TStringList);
begin
  slBanco.Clear;
  IBQBANCOS.First;
  while IBQBANCOS.Eof = False do
  begin
    slBanco.Add(IBQBANCOS.FieldByName('NOME').AsString);
    IBQBANCOS.Next;
  end; // while IBQ.Eof = False do

end;

procedure TFrmParcelas.GetInstituicaoFinanceira(slInstituicao: TStringList);
begin
  slInstituicao.Clear;
  IBQINSTITUICAOFINANCEIRA.First;
  while IBQINSTITUICAOFINANCEIRA.Eof = False do
  begin
    slInstituicao.Add(IBQINSTITUICAOFINANCEIRA.FieldByName('NOME').AsString);
    IBQINSTITUICAOFINANCEIRA.Next;
  end;
end;

procedure TFrmParcelas.SetPickListParaColuna;
const
  iDropDownRows = 20;
begin
  if Form7.sModulo = 'VENDA' then
  begin

    if Form7.ibDataSet7BANDEIRA.Visible then
    begin
      if DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'BANDEIRA' then
      begin
        DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList.Clear;

        if FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        begin
          DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList     := Form7.slPickListBandeira;
          DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].DropDownRows := iDropDownRows; // Sandro Silva 2023-11-20
        end;

      end;
    end;


    if Form7.ibDataSet7FORMADEPAGAMENTO.Visible then
    begin
      if DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName = 'FORMADEPAGAMENTO' then
      begin
        DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].PickList     := Form7.slPickListFormaDePagamento;
        DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].DropDownRows := iDropDownRows; // Sandro Silva 2023-11-20
      end;
    end;

    //Mauricio Parizotto 2024-01-24
    if DBGrid1.SelectedField <> nil then
    begin
      if DBGrid1.SelectedField.FieldName = 'PORTADOR' then
      begin
        DBGrid1.Columns[DBGrid1.SelectedIndex].PickList.Clear;
        if FormaDePagamentoEnvolveBancos(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        begin
          DBGrid1.Columns[DBGrid1.SelectedIndex].PickList := Form7.slPickListBanco;
          DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].DropDownRows := iDropDownRows; // Sandro Silva 2023-11-20
        end;

        if FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        begin
          DBGrid1.Columns[DBGrid1.SelectedIndex].PickList := Form7.slPickListInstituicao;
          DBGrid1.Columns[IndexColumnFromName(DBGrid1, DBGrid1.Columns[DbGrid1.SelectedIndex].FieldName)].DropDownRows := iDropDownRows; // Sandro Silva 2023-11-20
        end;
      end
    end;
  end;
end;

function TFrmParcelas.FormaDePagamentoEnvolveBancos(sForma: String): Boolean;
begin
  //Result := (Pos('|' + IdFormasDePagamentoNFe(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) + '|', '|02|16|17|18|') > 0); /// envolvem bancos Mauricio Parizotto 2024-07-10
  Result := (Pos('|' + IdFormasDePagamentoNFe(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) + '|', '|02|16|17|20|18|') > 0); /// envolvem bancos
end;

function TFrmParcelas.ValidarDesdobramentoParcela: Boolean;
var
  slFormas: TStringList;
  sForma: String;
  iRecno: Integer;
  sMensagem: String;
  iRecnoFormaErrada: Integer;
  sColunaPosicionar: String;
begin
  Result := True;
  if Form7.sModulo = 'VENDA' then
  begin
    slFormas := TStringList.Create;
    iRecnoFormaErrada := -1;
    try
      DBGrid1.DataSource.DataSet.DisableControls;
      sMensagem := '';
      GetFormasDePagamentoNFe(slFormas);

      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'FORMADEPAGAMENTO')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'BANDEIRA')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'PORTADOR')].ReadOnly := False;
      DbGrid1.Columns[IndexColumnFromName(DBGrid1, 'AUTORIZACAOTRANSACAO')].ReadOnly := False;


      iRecno := DBGrid1.DataSource.DataSet.RecNo;
      DBGrid1.DataSource.DataSet.First;
      while DBGrid1.DataSource.DataSet.Eof = False do
      begin
        //Mauricio Parizotto 2024-02-27
        if (DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString = '' )
          and (AnsiContainsText(cboDocCobranca.Text,'Boleto de cobrança'))then
        begin
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := _cFormaPgtoBoleto;
        end;

        sForma := ValidaFormadePagamentoDigitada(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString, slFormas);
        if (sForma <> DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then
        begin
          if sForma = '' then
          begin
            sMensagem := 'Forma de pagamento incorreta informada';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'FORMADEPAGAMENTO';
          end;
          DBGrid1.DataSource.DataSet.Edit;
          DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString := sForma;
        end;

        if FormaDePagamentoEnvolveBancos(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then // envolvem bancos
        begin
          IBQBANCOS.First;
          if IBQBANCOS.Locate('NOME', DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString, []) then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('INSTITUICAOFINANCEIRA').AsString := IBQBANCOS.FieldByName('INSTITUICAOFINANCEIRA').AsString;
          end;
        end;

        if FormaDePagamentoEnvolveCartao(DBGrid1.DataSource.DataSet.FieldByName('FORMADEPAGAMENTO').AsString) then // envolvem instituição financeiras/credenciadoras
        begin
          if IBQINSTITUICAOFINANCEIRA.Locate('NOME', DBGrid1.DataSource.DataSet.FieldByName('PORTADOR').AsString, []) then
          begin
            DBGrid1.DataSource.DataSet.Edit;
            DBGrid1.DataSource.DataSet.FieldByName('INSTITUICAOFINANCEIRA').AsString := IBQINSTITUICAOFINANCEIRA.FieldByName('NOME').AsString;

          end;

          if (Trim(DBGrid1.DataSource.DataSet.FieldByName('BANDEIRA').AsString) = '')
            and (not TestarRegistroPodeChamarTEF)then
          begin
            sMensagem := 'Informe a bandeira do cartão de crédito/débito';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'BANDEIRA';
          end;

          if (Trim(DBGrid1.DataSource.DataSet.FieldByName('AUTORIZACAOTRANSACAO').AsString) = '')
            and (not TestarRegistroPodeChamarTEF) then
          begin
            sMensagem := 'Informe o número da autorização do cartão de crédito/débito';
            iRecnoFormaErrada := DBGrid1.DataSource.DataSet.Recno;
            sColunaPosicionar := 'AUTORIZACAOTRANSACAO';
          end;

        end;

        DBGrid1.DataSource.DataSet.Next;
      end;

      DBGrid1.DataSource.DataSet.Recno := iRecno;

    finally
      slFormas.Free;
      DBGrid1.DataSource.DataSet.EnableControls;

      if sMensagem <> '' then
      begin
        Result := False;
        DBGrid1.SetFocus;
        if iRecnoFormaErrada <> -1 then
        begin
          DBGrid1.DataSource.DataSet.Recno := iRecnoFormaErrada;
          DBGrid1.SelectedIndex := IndexColumnFromName(DBGrid1, sColunaPosicionar);
        end;

        //ShowMessage(sMensagem); Mauricio Parizotto 2023-10-25
        MensagemSistema(sMensagem);
      end;
    end;
  end;
end;

procedure TFrmParcelas.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ValidarDesdobramentoParcela = False then
    Abort;
end;

procedure TFrmParcelas.FormCreate(Sender: TObject);
begin
  FpnlTEF := TPanel.Create(nil);
end;

procedure TFrmParcelas.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FpnlTEF);
end;

procedure TFrmParcelas.cboDocCobrancaEnter(Sender: TObject);
begin
  if Form7.sModulo = 'VENDA' then
  begin
    DBGrid1.DataSource.DataSet.First;
    DBGrid1.SelectedIndex := IndexColumnFromName(DBGrid1, 'VENCIMENTO');
  end;
end;

procedure TFrmParcelas.DBGrid1Exit(Sender: TObject);
begin
  Form7.ibDataSet7.Tag := 0; // Permiter fazer append/insert no dataset
end;

procedure TFrmParcelas.edtQtdParcKeyPress(Sender: TObject; var Key: Char);
begin
  ValidaValor(Sender,Key,'I');
end;

procedure TFrmParcelas.ReparcelaValor(DataSet: TibDataSet; iParcelas: Integer;
  dTotalParcelar: Double);
var
  dTotal: Double;
  aParcelas: array of Double;
begin
  // Quando o total da nota de venda é alterado, essa rotina irá reparcelar o novo valor com base no valor que cada parcela possui
  // Se lançar novos itens na nota, ou mudar o valor dos itens, o total da nota será alterado
  // Ex.:
  // Total antigo da nota: R$100,00
  // Parcela 1: R$75,00
  // Parcela 2: R$25,00
  //
  // Novo Total da nota: R$120,00
  // Parcela 1: R$90,00
  // Parcela 2: R$30,00

  {Sandro Silva 2023-11-23 inicio
  //TotalizaParcelas
  dTotal := 0.00;
  dTotalParcelar := StrToFloat(FormatFloat('0.00', dTotalParcelar)); // Sandro Silva 2023-11-20
  DataSet.First;
  while DataSet.Eof = False do
  begin
    dTotal := dTotal + StrToFloat(FormatFloat('0.00', DataSet.FieldByName('VALOR_DUPL').AsFloat));
    DataSet.Next;
  end;
  }
  //TotalizaParcelas
  dTotal := TotalParcelasLancadas;
  dTotalParcelar := StrToFloat(FormatFloat('0.00', dTotalParcelar)); // Sandro Silva 2023-11-20
  {Sandro Silva 2023-11-23 fim}


  //Identifica a proporção de cada parcela no total
  SetLength(aParcelas, 0);
  DataSet.First;
  while DataSet.Eof = False do
  begin
    SetLength(aParcelas, Length(aParcelas) + 1);
    aParcelas[High(aParcelas)] := StrToFloat(FormatFloat('0.00', DataSet.FieldByName('VALOR_DUPL').AsFloat)) / dTotal;
    DataSet.Next;
  end;

  //Reparcela o total da nota
  dTotal := 0.00;
  DataSet.First;
  while DataSet.Eof = False do
  begin
    DataSet.Edit;
    DataSet.FieldByName('VALOR_DUPL').AsFloat := StrToFloat(FormatFloat('0.00', dTotalParcelar * aParcelas[DataSet.Recno - 1]));
    dTotal := dTotal + StrToFloat(FormatFloat('0.00', DataSet.FieldByName('VALOR_DUPL').AsFloat));
    DataSet.Next;
  end;

  DataSet.First;
  DataSet.Edit;
  DataSet.FieldByName('VALOR_DUPL').AsFloat := StrToFloat(FormatFloat('0.00', DataSet.FieldByName('VALOR_DUPL').AsFloat + (dTotalParcelar - dTotal)));
  DataSet.Post;
end;

procedure TFrmParcelas.RateiaDiferencaParcelaEntreAsDemais(ModuloAtual: String);
var
  Parcelas: TRateioDiferencaEntreParcelasReceber;
begin
  Parcelas := TRateioDiferencaEntreParcelasReceber.Create;
  Parcelas.RateiaDiferenca(Form7.ibDataSet15, Form7.ibDataSet7, Form7.sModulo, Form1.fRetencaoIR, Form7.ibDataSet15TOTAL.AsFloat, Trunc(Form7.ibDataSet15DUPLICATAS.AsFloat));
  FreeAndNil(Parcelas);
end;

function TFrmParcelas.TotalParcelasLancadas: Double;
var
  //iRecno: Integer;
  Parcelas: TRateioDiferencaEntreParcelasReceber;
begin
  Result := 0.00;
  if Form7.sModulo <> 'VENDA' then
    Exit;
  //iRecno := DBGrid1.DataSource.DataSet.Recno;
  {
  Result := 0.00;
  DBGrid1.DataSource.DataSet.First;
  while DBGrid1.DataSource.DataSet.Eof = False do
  begin
    Result := Result + DBGrid1.DataSource.DataSet.FieldByName('VALOR_DUPL').AsFloat;
    DBGrid1.DataSource.DataSet.Next;
  end;
  DBGrid1.DataSource.DataSet.RecNo := iRecno;
  }

  Parcelas := TRateioDiferencaEntreParcelasReceber.Create;
  Result := Parcelas.TotalParcelasLancadas(Form7.ibDataSet7);
  FreeAndNil(Parcelas);

end;

procedure TFrmParcelas.GeraParcelarReceber(QtdParcelas : integer; sNumeroNF : string);
var
  I : integer;
  dDiferenca : Double;
  ano, mes, dia : string;
  DataVencimento : TdateTime;
begin
  GerarParcelasTEFInativadas(True);

  Form7.ibDataSet7.First;

  {$Region'//// Data de vencimento ////'}
  if bConfPrazoFixo then
  begin
    ano := FormatDateTime('yyyy',now);
    mes := FormatDateTime('mm',now);
    dia := Format('%2.2d',[iDiaVencimento]);

    try
      DataVencimento := StrToDate(dia+'/'+mes+'/'+ano);
    except
      //Se der erro pega o último dia do mês
      DataVencimento := StrToDateDef(Format('%2.2d',[DaysInMonth(now)])+'/'+mes+'/'+ano,now);
    end;
  end else
  begin
    try
      if chkFixarVencimento.Checked then
      begin
        dia := FormatDateTime('dd',Form7.ibDataSet7VENCIMENTO.AsDateTime);
        DataVencimento := IncMonth(Form7.ibDataSet7VENCIMENTO.AsDateTime,-1);
      end;
    except
      DataVencimento := now;
    end;
  end;
  {$Endregion}

  {$Region'//// Excluir as parcelas atuais ////'}
  while not Form7.ibDataSet7.Eof do
  begin
    Form7.ibDataSet7.Delete;
    Form7.ibDataSet7.First;
  end;
  {$Endregion}

  {$Region'//// Cria as parcelas ////'}
  for I := 1 to QtdParcelas do
  begin
    Form7.ibDataSet7.Append;
    Form7.ibDataSet7NUMERONF.AsString := sNumeroNF;

    if Form7.sRPS <> 'S' then
    begin
      if Copy(sNumeroNF,10,3) = '002' then
      begin
        Form7.ibDataSet7DOCUMENTO.Value := 'S'+Copy(sNumeroNF,2,8) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
      end else
      begin
        Form7.ibDataSet7DOCUMENTO.Value := Copy(sNumeroNF,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
      end;
    end else
    begin
      Form7.ibDataSet7DOCUMENTO.Value := Copy(sNumeroNF,1,1)+'S'+Copy(sNumeroNF,3,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
    end;

    Form7.ibDataSet7VALOR_DUPL.AsFloat          := Arredonda((Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR) / QtdParcelas,2);;

    if Form7.sRPS <> 'S' then
    begin
      Form7.ibDataSet7HISTORICO.Value := 'NFE NAO AUTORIZADA';
    end else
    begin
      Form7.ibDataSet7HISTORICO.AsString := 'RPS número: '+Copy(sNumeroNF,1,9);
    end;

    Form7.ibDataSet7EMISSAO.asDateTime    := Form7.ibDataSet15EMISSAO.AsDateTime;
    Form7.ibDataSet7NOME.Value            := Form7.ibDataSet15CLIENTE.Value;
    Form7.ibDataSet7CONTA.AsString        := sConta;

    if chkFixarVencimento.Checked then
    begin
      DataVencimento := IncMonth(DataVencimento,1);

      ano := FormatDateTime('yyyy',DataVencimento);
      mes := FormatDateTime('mm',DataVencimento);
      TryStrToDate(dia+'/'+mes+'/'+ano,DataVencimento);

      Form7.ibDataSet7VENCIMENTO.AsDateTime := DataVencimento;
    end else
    begin
      if I = 1 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
      if I = 2 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
      if I = 3 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
      if I > 3 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet15EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+
          ((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))
           -StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));

      if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;

      if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;
    end;

    Form7.ibDataSet7.Post;
  end;
  {$Endregion}

  // Valor quebrado
  dDiferenca := StrToFloat(FormatFloat('0.00', (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR)));
  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    dDiferenca := StrToFloat(FormatFloat('0.00', dDiferenca - StrToFloat(FormatFloat('0.00', Form7.ibDataSet7VALOR_DUPL.AsFloat))));
    Form7.ibDataSet7.Next;
  end;

  Form7.ibDataSet7.First;
  Form7.ibDataSet7.Edit;
  if dDiferenca <> 0 then
    Form7.ibDataSet7VALOR_DUPL.AsFloat := StrToFloat(FormatFloat('0.00', Form7.ibDataSet7VALOR_DUPL.AsFloat + ddiferenca));
end;

procedure TFrmParcelas.GeraParcelarPagar(QtdParcelas : integer; sNumeroNF : string);
var
  I : integer;
  dDiferenca : Double;
begin
  Form7.ibDataSet8.First;

  {$Region'//// Excluir as parcelas atuais ////'}
  while not Form7.ibDataSet8.Eof do
  begin
    Form7.ibDataSet8.Delete;
    Form7.ibDataSet8.First;
  end;
  {$Endregion}

  {$Region'//// Cria as parcelas ////'}
  for I := 1 to QtdParcelas do
  begin
    Form7.ibDataSet8.Append;
    Form7.ibDataSet8NUMERONF.AsString   := sNumeroNF;
    Form7.ibDataSet8DOCUMENTO.Value     := Copy(sNumeroNF,1,9) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
    Form7.ibDataSet8VALOR_DUPL.AsFloat  := Form7.ibDataSet24TOTAL.AsFloat / Form7.ibDataSet24DUPLICATAS.AsFloat;
    Form7.ibDataSet8VALOR_DUPL.AsFloat  := StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
    Form7.ibDataSet8HISTORICO.Value     := 'Nota Fiscal: '+Copy(sNumeroNF,1,9);
    Form7.ibDataSet8EMISSAO.asDateTime  := Form7.ibDataSet24EMISSAO.AsDateTime;
    Form7.ibDataSet8NOME.Value          := Form7.ibDataSet24FORNECEDOR.AsString;
    Form7.ibDataSet8CONTA.AsString      := sConta;
    if I = 1 then
      Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
    if I = 2 then
      Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
    if I = 3 then
      Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
    if I > 3 then
      Form7.ibDataSet8VENCIMENTO.AsDateTime := SomaDias(Form7.ibDataSet24EMISSAO.AsDateTime,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+
        ((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))
         -StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));
    Form7.ibDataSet8.Post;
  end;
  {$Endregion}

  // Valor quebrado
  dDiferenca := Form7.ibDataSet24TOTAL.AsFloat;
  Form7.ibDataSet8.First;
  while not Form7.ibDataSet8.Eof do
  begin
    dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet8VALOR_DUPL.AsFloat]));
    Form7.ibDataSet8.Next;
  end;

  Form7.ibDataSet8.First;
  Form7.ibDataSet8.Edit;
  if dDiferenca <> 0 then
    Form7.ibDataSet8VALOR_DUPL.AsFloat := Form7.ibDataSet8VALOR_DUPL.AsFloat + ddiferenca;
end;


procedure TFrmParcelas.GeraParcelarRenegociacao(QtdParcelas : integer);
var
  I : integer;
  dDiferenca : Double;

  ano, mes, dia : string;
  DataVencimento : TdateTime;
begin
  {$Region'//// Data de vencimento ////'}
  if bConfPrazoFixo then
  begin
    ano := FormatDateTime('yyyy',now);
    mes := FormatDateTime('mm',now);
    dia := Format('%2.2d',[iDiaVencimento]);

    try
      DataVencimento := StrToDate(dia+'/'+mes+'/'+ano);
    except
      //Se der erro pega o último dia do mês
      DataVencimento := StrToDateDef(Format('%2.2d',[DaysInMonth(now)])+'/'+mes+'/'+ano,now);
    end;
  end else
  begin
    try
      if chkFixarVencimento.Checked then
      begin
        dia := FormatDateTime('dd',Form7.ibDataSet7VENCIMENTO.AsDateTime);
        DataVencimento := IncMonth(Form7.ibDataSet7VENCIMENTO.AsDateTime,-1);
      end;
    except
      DataVencimento := now;
    end;
  end;
  {$Endregion}

  Form7.ibDataSet7.First;
  while not Form7.ibDataSet7.Eof do
  begin
    Form7.ibDataSet7.Delete;
    Form7.ibDataSet7.First;
  end;

  for I := 1 to QtdParcelas do
  begin
    Form7.ibDataSet7.Append;
    Form7.ibDataSet7NUMERONF.AsString                          := nrRenegociacao;
    Form7.ibDataSet7DOCUMENTO.Value                            := 'RE'+Right(nrRenegociacao,7) + Copy('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'+replicate('_',1000),I,1);
    Form7.ibDataSet7VALOR_DUPL.AsFloat                         := Arredonda((vlrRenegociacao) / QtdParcelas,2);
    Form7.ibDataSet7HISTORICO.Value                            := 'CODIGO DO ACORDO '+nrRenegociacao;
    Form7.ibDataSet7EMISSAO.asDateTime                         := Date;
    Form7.ibDataSet7NOME.Value                                 := Form7.ibDataSet2NOME.Value;
    Form7.ibDataSet7CONTA.AsString                             := sConta;

    if chkFixarVencimento.Checked then
    begin
      DataVencimento := IncMonth(DataVencimento,1);

      ano := FormatDateTime('yyyy',DataVencimento);
      mes := FormatDateTime('mm',DataVencimento);
      TryStrToDate(dia+'/'+mes+'/'+ano,DataVencimento);

      Form7.ibDataSet7VENCIMENTO.AsDateTime := DataVencimento;
    end else
    begin
      if I = 1 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoA.Text)));
      if I = 2 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)));
      if I = 3 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text)));
      if I > 3 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := SomaDias(Date,StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))+((StrToInt(AllTrim(Form19.edtDiasPrazoC.Text))-StrToInt(AllTrim(Form19.edtDiasPrazoB.Text)))*(I-3)));

      if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 1 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime + 1;

      if DayOfWeek(Form7.ibDataSet7VENCIMENTO.AsDateTime) = 7 then
        Form7.ibDataSet7VENCIMENTO.AsDateTime := Form7.ibDataSet7VENCIMENTO.AsDateTime - 1;
    end;

    Form7.ibDataSet7.Post;
  end;

  // Valor quebrado
  //dDiferenca := (Form7.ibDataSet15TOTAL.AsFloat - Form1.fRetencaoIR);
  dDiferenca := (vlrRenegociacao - Form1.fRetencaoIR);
  Form7.ibDataSet7.First;

  while not Form7.ibDataSet7.Eof do
  begin
    dDiferenca := dDiferenca - StrToFloat(Format('%8.2f',[Form7.ibDataSet7VALOR_DUPL.AsFloat]));
    Form7.ibDataSet7.Next;
  end;

  Form7.ibDataSet7.First;
  Form7.ibDataSet7.Edit;
  if dDiferenca <> 0 then
    Form7.ibDataSet7VALOR_DUPL.AsFloat := Form7.ibDataSet7VALOR_DUPL.AsFloat + dDiferenca;
end;


end.
