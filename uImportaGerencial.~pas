unit uImportaGerencial;

interface

uses
  SysUtils, Controls, StrUtils
  , IBDatabase, IBCustomDataSet, IBQuery
  , ufuncoesfrente
  ;

type
  TImportaGerencial = class

  private
    FIBTransaction: TIBTransaction;
    FCaixa: String;
    FModeloDocumento: String;
    FNumeroGerencial: String;
    FIBDataSet27: TIBDataSet;
    FIBDataSet30: TIBDataSet;
    FIBDataset150: TIBDataSet;
    FIBDataSet7: TIBDataSet;
    FIBDataSet28: TIBDataSet;
    FNumeroNF: String;
    procedure SetNumeroGerencial(const Value: String);

  public
    function Importar: Boolean;
    property IBTransaction: TIBTransaction read FIBTransaction write FIBTransaction;
    property IBDataset150: TIBDataSet read FIBDataset150 write FIBDataset150;
    property IBDataSet27: TIBDataSet read FIBDataSet27 write FIBDataSet27;
    property IBDataSet28: TIBDataSet read FIBDataSet28 write FIBDataSet28;
    property IBDataSet7: TIBDataSet read FIBDataSet7 write FIBDataSet7;
    property IBDataSet30: TIBDataSet read FIBDataSet30 write FIBDataSet30; 
    property Caixa: String read FCaixa write FCaixa;
    property ModeloDocumento: String read FModeloDocumento write FModeloDocumento;
    property NumeroGerencial: String read FNumeroGerencial write SetNumeroGerencial;
    property NumeroNF: String read FNumeroNF;

  end;

implementation

uses
  fiscal;

{ TImportaGerencial }

function TImportaGerencial.Importar: Boolean;
var
  IBQCONSULTA: TIBQuery;
  IBQPENDENCIA: TIBQuery;
  sDataOld: String;
  sCaixaOld: String;
  sNovoNumero: String;
  dtDataNovo: TDate;
  sDAV: String;
  sTIPODAV: String;
begin
  FNumeroNF := '';
  if (FModeloDocumento <> '59') and (FModeloDocumento <> '65') then
    Exit;

  if (FIBTransaction = nil) or
    (FIBDataSet27 = nil) or
    (FIBDataSet30 = nil) or
    (FIBDataset150 = nil) or
    (FIBDataSet7 = nil) or
    (FIBDataSet28 = nil) then
    Exit;

  IBQCONSULTA := CriaIBQuery(FIBTransaction);
  try
    IBQCONSULTA.Close;
    IBQCONSULTA.SQL.Text :=
      'select DATA, CAIXA from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and MODELO = ' + QuotedStr('99');
    IBQCONSULTA.Open;

    if IBQCONSULTA.FieldByName('DATA').AsString <> '' then
    begin

      sDataOld  := IBQCONSULTA.FieldByName('DATA').AsString;
      sCaixaOld := IBQCONSULTA.FieldByName('CAIXA').AsString;

      IBQCONSULTA.Close;
      IBQCONSULTA.SQL.Clear;
      IBQCONSULTA.SQL.Add('delete from NFCE where NUMERONF = ' + QuotedStr(FNumeroGerencial) + ' and CAIXA = ' + QuotedStr(sCaixaOld) + ' and MODELO = ' + QuotedStr('99'));
      IBQCONSULTA.ExecSQL;

      FIBDataset150.Close;
      FIBDataset150.SelectSql.Clear;
      FIBDataset150.SelectSQL.Add('select * from NFCE where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(0)) + ' and CAIXA = ' + QuotedStr(FCaixa) + ' and MODELO = ' + QuotedStr(FModeloDocumento));
      FIBDataset150.Open;

      if FModeloDocumento = '65' then
        sNovoNumero :=  FormataNumeroDoCupom(IncGeneratorToInt(FIBTransaction.DefaultDatabase, 'G_NUMERONFCE', 1));

      dtDataNovo := Date;
      FIBDataset150.Append;
      FIBDataset150.FieldByName('NUMERONF').AsString  := sNovoNumero;
      FIBDataset150.FieldByName('DATA').AsDateTime    := dtDataNovo;
      FIBDataset150.FieldByName('CAIXA').AsString     := FCaixa;
      FIBDataset150.FieldByName('MODELO').AsString    := FModeloDocumento;
      FIBDataset150.FieldByName('GERENCIAL').AsString := FNumeroGerencial;
      FIBDataset150.Post;

      //Seleciona novamente o itens para alterar o número do pedido para o número do CFe
      FIBDataSet27.Close;
      FIBDataSet27.SelectSQL.Text :=
        'select * from ALTERACA where CAIXA = ' + QuotedStr(sCaixaOld) + ' and PEDIDO = ' + QuotedStr(FNumeroGerencial) +
        ' and COO is null'; // Apenas os itens da venda atual. Para separar de vendas anteriores com mesmo número do caixa
      FIBDataSet27.Open;

      sDAV     := '';
      sTIPODAV := '';
      //sAlteracaPedidoOld := FIBDataSet27.FieldByName('PEDIDO').AsString;

      {
      if Form1.sOrcame <> '' then
      begin
        sDAV     := Form1.sOrcame;
        sTIPODAV := 'ORÇAMENTO';
      end;

      if Form1.sOs <> '' then
      begin
        sDAV     := Form1.sOs;
        sTIPODAV := 'OS';
      end;
      }

      IBQPENDENCIA := CriaIBQuery(FIBTransaction);
      try
        IBQPENDENCIA.Close;
        IBQPENDENCIA.SQL.Text :=
          'update PENDENCIA set ' +
          'PEDIDO = ' + QuotedStr(sNovoNumero) +
          ', CAIXA = ' + QuotedStr(FCaixa) +
          ' where PEDIDO = ' + QuotedStr(FNumeroGerencial) +
          ' and CAIXA = ' + QuotedStr(sCaixaOld);
        IBQPENDENCIA.ExecSQL;
      except

      end;
      FreeAndNil(IBQPENDENCIA);

      while FIBDataSet27.Eof = False do
      begin

        if (sDAV = '')
          and (FIBDataSet27.FieldByName('DAV').AsString <> '')
          and (FIBDataSet27.FieldByName('TIPODAV').AsString <> '') then
        begin
          // Identifica o primeiro DAV que encontrar nos itens da venda
          sDAV     := FIBDataSet27.FieldByName('DAV').AsString;
          sTIPODAV := FIBDataSet27.FieldByName('TIPODAV').AsString;
        end;

        if (FIBDataSet27.FieldByName('CAIXA').AsString = sCaixaOld)
          and (FIBDataSet27.FieldByName('PEDIDO').AsString = FNumeroGerencial) then
        begin
          //
          // NFC-e não grava COO e CCF para os descontos e acréscimos
          //
          if (FIBDataSet27.FieldByName('COO').AsString = '') and (FIBDataSet27.FieldByName('CCF').AsString = '') then // Não atualizar número do CF-e em vendas antigas de ECF
          begin

            try
              // Produtos com controle de número de série
                if (FIBDataSet27.FieldByName('CODIGO').AsString <> '') and
                  ((FIBDataSet27.FieldByName('TIPO').AsString = 'BALCAO') or (FIBDataSet27.FieldByName('TIPO').AsString = 'LOKED')) then
                begin
                  // Seleciona o produto na tabela SERIE, com a data e o número temporário da venda, para atualizar com a data e o número do CF-e gerados pelo SAT
                  FIBDataSet30.Close;
                  FIBDataSet30.SelectSQL.Clear;
                  FIBDataSet30.Selectsql.Text :=
                    'select * from SERIE ' +
                    ' where CODIGO = ' + QuotedStr(FIBDataSet27.FieldByName('CODIGO').AsString) +
                    ' and NFVENDA = ' + QuotedStr(FNumeroGerencial) +
                    ' and DATVENDA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', FIBDataSet27.FieldByName('DATA').AsDateTime));
                  FIBDataSet30.Open;

                  while FIBDataSet30.Eof = False do
                  begin
                    if (FIBDataSet30.FieldByName('CODIGO').AsString <> '') and (FIBDataSet30.FieldByName('CODIGO').AsString = FIBDataSet27.FieldByName('CODIGO').AsString) then
                    begin
                      FIBDataSet30.Edit;
                      FIBDataSet30.FieldByName('NFVENDA').AsString  := sNovoNumero;
                      try
                        FIBDataSet30.FieldByName('VALVENDA').AsFloat  := FIBDataSet27.FieldByName('UNITARIO').AsFloat;
                        FIBDataSet30.FieldByName('DATVENDA').AsFloat  := dtDataNovo;
                        FIBDataSet30.Post; // Sandro Silva 2018-12-07
                      except
                      end;
                    end;
                    FIBDataSet30.Next;
                  end;
                end;
            except

            end;

            try
              FIBDataSet27.Edit;
              FIBDataSet27.FieldByName('PEDIDO').AsString := sNovoNumero;
              FIBDataSet27.FieldByName('CAIXA').AsString  := FCaixa;
              FIBDataSet27.FieldByName('DATA').AsDateTime := dtDataNovo;
              FIBDataSet27.Post;
            except
            
            end;

          end; // if (FIBDataSet27.FieldByName('DATA').AsDateTime >= StrToDate(sDataOld))

        end; // if (FIBDataSet27.FieldByName('CAIXA').AsString = Form1.sCaixa)

        FIBDataSet27.Next;
      end; // while

      Form1.AtualizaDetalhe(FIBDataSet27.Transaction, sTIPODAV, sDAV, sCaixaOld, FCaixa, sNovoNumero, 'Fechada');

      // Seleciona novamente os dados para usar na sequência da venda
      FIBDataSet27.Close;
      FIBDataSet27.SelectSQL.Text :=
        'select * from ALTERACA where CAIXA = ' + QuotedStr(FCaixa) + ' and PEDIDO = ' + QuotedStr(sNovoNumero);
      FIBDataSet27.Open;
      FIBDataSet27.Last;

      //Pagament
      FIBDataSet28.Close;
      FIBDataSet28.SelectSQL.Text :=
        'select * from PAGAMENT where CAIXA = ' + QuotedStr(sCaixaOld) + ' and PEDIDO = ' + QuotedStr(FNumeroGerencial);
      FIBDataSet28.Open;
      FIBDataSet28.First;
      while FIBDataSet28.Eof = False do
      begin
        if (FIBDataSet28.FieldByName('CAIXA').AsString = sCaixaOld)
          and (FIBDataSet28.FieldByName('PEDIDO').AsString = FNumeroGerencial) then
        begin
          try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
            FIBDataSet28.Edit;
            FIBDataSet28.FieldByName('PEDIDO').AsString := sNovoNumero;
            FIBDataSet28.FieldByName('CAIXA').AsString  :=  FCaixa;
            FIBDataSet28.FieldByName('DATA').AsDateTime := dtDataNovo;
            FIBDataSet28.Post;
          except
          end;
        end;
        FIBDataSet28.Next;
      end;

      // Receber
      FIBDataSet7.Close;
      FIBDataSet7.SelectSQL.Text :=
        'select * ' +
        'from RECEBER ' +
        'where NUMERONF = ' + QuotedStr(FormataNumeroDoCupom(StrToInt(FNumeroGerencial)) + RightStr(sCaixaOld, 3)) +
        ' order by REGISTRO';
      FIBDataSet7.Open;

      FIBDataSet7.First;
      while FIBDataSet7.Eof = False do
      begin
        if (FIBDataSet7.FieldByName('NUMERONF').AsString = FNumeroGerencial + Copy(sCaixaOld, 1, 3)) then
        begin
          try // Sandro Silva 2018-12-07 Evitar erro quando atualiza dados
            FIBDataSet7.Edit;
            FIBDataSet7.FieldByName('NUMERONF').AsString  := sNovoNumero + Copy(FCaixa, 1, 3);
            FIBDataSet7.FieldByName('HISTORICO').AsString := StringReplace(FIBDataSet7.FieldByName('HISTORICO').AsString, FNumeroGerencial, FormataNumeroDoCupom(StrToInt(sNovoNumero)), [rfReplaceAll]);
            FIBDataSet7.FieldByName('DOCUMENTO').AsString := FCaixa + sNovoNumero + RightStr(FIBDataSet7.FieldByName('DOCUMENTO').AsString, 1);
            FIBDataSet7.FieldByName('EMISSAO').AsDateTime := dtDataNovo;
            FIBDataSet7.Post;
          except
          end;
        end;
        FIBDataSet7.Next;
      end;

      Result := True;

      FNumeroNF := sNovoNumero;
    end;
  except

  end;
  if FNumeroNF = '' then
    Result := False;
end;

procedure TImportaGerencial.SetNumeroGerencial(const Value: String);
begin
  FNumeroGerencial := FormataNumeroDoCupom(StrToIntDef(Value, 0));
end;

end.
