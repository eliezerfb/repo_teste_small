{ *********************************************************************** }
{                                                                         }
{ Classe que faz o rateio do desconto do subtotal da venda para os itens  }
{ Autor: Sandro Silva                                                     }
{                                                                         }
{ Copyright (c) Smallsoft Tecnologia                                      }
{                                                                         }
{ Exemplo de uso:                                                         }
{ procedure TForm1.BitBtn1Click(Sender: TObject);                         }
{ var                                                                     }
{   Rateio: TRateioDescontoAlteraca;                                      }
{ begin                                                                   }
{   Rateio := TRateioDescontoAlteraca.Create(Application);                }
{   Rateio.IBDatabase  := IBDatabase1;                                    }
{   Rateio.DataInicial := DateTimePicker1.Date; //Início do período       }
{   Rateio.DataFinal   := DateTimePicker2.Date; //Final do período        }
{   Rateio.Iniciar;                                                       }
{   FreeAndNil(Rateio);                                                   }
{ end;                                                                    }
{                                                                         }
{ *********************************************************************** }


unit uclasserateioalteraca;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls,
  IBDatabase, DB, IBCustomDataSet, IBQuery, Dialogs;

type
  TItens = record
    Pedido: String;
    Caixa: String;
    Item: String;
    Acrescimo: Currency;
    Desconto: Currency;
    DescontoDoItem: Currency;
  end;

type
  TRateioDescontoAlteraca = class(TComponent)
  private
    FIBTLEITURA: TIBTransaction;
    FIBDatabase: TIBDatabase;
    FDataInicial: TDate;
    FDataFinal: TDate;
    FIBQCUPONS: TIBQuery;
    FIBQTOTAL: TIBQuery;
    FIBQITENS: TIBQuery;
    FIBTTEMP: TIBTransaction;
    FIBQTEMP: TIBQuery;
    FIBQACRESCIMO: TIBQuery;
    FTipo: String;
    procedure SetIBDatabase(const Value: TIBDatabase);
    procedure SetDataInicial(const Value: TDate);
    procedure SetDataFinal(const Value: TDate);
    procedure RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double;
      sCupom: String; sCaixa: String);
    procedure SetTipo(const Value: String);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy;
    property IBDatabase: TIBDatabase read FIBDatabase write SetIBDatabase;
    property DataInicial: TDate read FDataInicial write SetDataInicial;
    property DataFinal: TDate read FDataFinal write SetDataFinal;
    procedure Iniciar;
  end;

implementation

{ TRateioDescontoAlteraca }

uses smallfunc_xe;

constructor TRateioDescontoAlteraca.Create(AOwner: TComponent);
begin
  FIBDatabase    := TIBDatabase.Create(AOwner);
  FIBTLEITURA := TIBTransaction.Create(AOwner);

  FIBQCUPONS := TIBQuery.Create(Owner);
  FIBQCUPONS.Database     := FIBTLEITURA.DefaultDataBase;
  FIBQCUPONS.Transaction  := FIBTLEITURA;
  FIBQCUPONS.BufferChunks := 100;

  FIBQTOTAL := TIBQuery.Create(Owner);
  FIBQTOTAL.Database     := FIBTLEITURA.DefaultDataBase;
  FIBQTOTAL.Transaction  := FIBTLEITURA;
  FIBQTOTAL.BufferChunks := 100;

  FIBQITENS := TIBQuery.Create(Owner);
  FIBQITENS.Database     := FIBTLEITURA.DefaultDataBase;
  FIBQITENS.Transaction  := FIBTLEITURA;
  FIBQITENS.BufferChunks := 100;

  FIBQACRESCIMO := TIBQuery.Create(Owner);
  FIBQACRESCIMO.Database     := FIBTLEITURA.DefaultDataBase;
  FIBQACRESCIMO.Transaction  := FIBTLEITURA;
  FIBQACRESCIMO.BufferChunks := 100;

  FIBTTEMP := TIBTransaction.Create(AOwner);

  FIBQTEMP := TIBQuery.Create(Owner);
  FIBQTEMP.Database     := FIBTTEMP.DefaultDataBase;
  FIBQTEMP.Transaction  := FIBTTEMP;
  FIBQTEMP.BufferChunks := 100;

  inherited;
end;

destructor TRateioDescontoAlteraca.Destroy;
begin
  FreeAndNil(FIBQTEMP);
  FreeAndNil(FIBQITENS);
  FreeAndNil(FIBQCUPONS);
  FreeAndNil(FIBQTOTAL);
  FreeAndNil(FIBQACRESCIMO);
  FreeAndNil(FIBTLEITURA);
  FreeAndNil(FIBTTEMP);
  inherited;
end;

procedure TRateioDescontoAlteraca.RateioDesconto(dTotalVenda: Double; dDescontoTotal: Double; sCupom: String; sCaixa: String);
var
  dAcumuladoDesconto: Double;
  dDiferencaDesconto: Double;
  dAcumuladoAcrescimo: Double;
  dDiferencaAcrescimo: Double;
  iItem: Integer;
  aItens: array of TItens;
  dtotal: Currency;
  dAcrescimoTotal: Double;
begin
  dtotal := 0.00;
  dDescontoTotal := abs(dDescontoTotal);
  SetLength(aItens, 0);

  try

    // Verifica se tem acréscimo e desconto do total
    // No final será invertido o sinal no momento de atualizar o campo DESCONTO

    FIBQACRESCIMO.Close;
    FIBQACRESCIMO.SQL.Text :=
                              ' Select sum(TOTAL) as ACRESCIMO ' +
                              ' From ALTERACA ' +
                              ' Where DESCRICAO = ''Acréscimo'' ' +
                              '   and coalesce(ITEM, '''') = '''' ' +
                              '   and (TIPO = :TIPO or TIPO = ''LOKED'') ' +
                              '   and PEDIDO = :PEDIDO ' +
                              '   and CAIXA = :CAIXA ';
    FIBQACRESCIMO.ParamByName('PEDIDO').AsString := sCupom;
    FIBQACRESCIMO.ParamByName('CAIXA').AsString  := sCaixa;
    FIBQACRESCIMO.ParamByName('TIPO').AsString   := FTipo;
    FIBQACRESCIMO.Open;

    dAcrescimoTotal := FIBQACRESCIMO.FieldByName('ACRESCIMO').AsFloat;

    if (dDescontoTotal <> 0) or (dAcrescimoTotal <> 0) then // if dDescontoTotal > 0 then
    begin
      FIBQITENS.Close;
      FIBQITENS.SQL.Text :=
                          'select A.TOTAL, coalesce((select A1.TOTAL from ALTERACA A1 where (A1.TIPO = :TIPO or A1.TIPO = ''LOKED'') and A1.PEDIDO = A.PEDIDO and A1.ITEM = A.ITEM and A1.CAIXA = A.CAIXA and A1.DATA = A.DATA and A1.DESCRICAO = ''Desconto'' ), 0) as DESCONTOITEM ' +
                          ', A.ITEM ' +
                          'from ALTERACA A ' +
                          'where A.PEDIDO = :PEDIDO ' +
                          ' and A.CAIXA = :CAIXA ' +
                          ' and (A.TIPO = :TIPO or A.TIPO = ''LOKED'') ' + // ' and (A.TIPO = ''BALCAO'' or A.TIPO = ''LOKED'') ' +
                          ' and (A.DESCRICAO <> ''<CANCELADO>'' ' +
                          ' and A.DESCRICAO <> ''Desconto'' ' +
                          ' and A.DESCRICAO <> ''Acréscimo'') ' +
                          ' and coalesce(A.ITEM, '''') <> '''' '; // Que tenha número do item informado no campo ALTERACA.ITEM
      FIBQITENS.ParamByName('PEDIDO').AsString := sCupom;
      FIBQITENS.ParamByName('CAIXA').AsString  := sCaixa;
      FIBQITENS.ParamByName('TIPO').AsString   := FTipo;
      FIBQITENS.Open;

      dAcumuladoDesconto := 0.00;
      while FIBQITENS.Eof = False do
      begin
        SetLength(aItens, Length(aItens) + 1);
        iItem := Length(aItens) - 1;
        aItens[iItem].Pedido         := sCupom;
        aItens[iItem].Caixa          := sCaixa;
        aItens[iItem].Item           := FIBQITENS.FieldByName('ITEM').AsString;
        aItens[iItem].Acrescimo      := StrToFloat(StrZero(((dAcrescimoTotal / (dTotalVenda)) * (FIBQITENS.FieldByName('TOTAL').AsFloat - Abs(FIBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Acréscimo
        aItens[iItem].Desconto       := StrToFloat(StrZero(((dDescontoTotal / (dTotalVenda)) * (FIBQITENS.FieldByName('TOTAL').AsFloat - Abs(FIBQITENS.FieldByName('DESCONTOITEM').AsFloat))), 0, 2)); // REGRA DE TRÊS rateando o valor do Desconto
        aItens[iItem].DescontoDoItem := FIBQITENS.FieldByName('DESCONTOITEM').AsFloat;  // Mantem o valor negativo que está no banco referente ao desconto específico do item

        dAcumuladoAcrescimo := dAcumuladoAcrescimo + aItens[iItem].Acrescimo;
        dAcumuladoDesconto  := dAcumuladoDesconto + aItens[iItem].Desconto;

        FIBQITENS.Next;
      end;

      // Formata 2 casas decimais para evitar problema de dízima
      dDiferencaDesconto  := StrToCurr(FormatFloat('0.00', dAcumuladoDesconto - dDescontoTotal));
      dDiferencaAcrescimo := StrToCurr(FormatFloat('0.00', dAcumuladoAcrescimo - dAcrescimoTotal));

      // Acerta a diferença do desconto
      if dDiferencaDesconto <> 0 then
      begin
        for iItem := 0 to Length(aItens) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aItens[iItem].Desconto - dDiferencaDesconto)) >= 0 then
          begin
            aItens[iItem].Desconto := StrToCurr(FormatFloat('0.00', aItens[iItem].Desconto - dDiferencaDesconto));
            Break;
          end
          else
          begin
            dDiferencaDesconto := StrToCurr(FormatFloat('0.00', dDiferencaDesconto - aItens[iItem].Desconto));
            aItens[iItem].Desconto := 0.00;
          end;
          if dDiferencaDesconto = 0 then
            Break;
        end;
      end; // if dDiferenca <> 0 then

      // Acerta a diferença do acréscimo
      if dDiferencaAcrescimo <> 0 then
      begin
        for iItem := 0 to Length(aItens) - 1 do
        begin
          if StrToCurr(FormatFloat('0.00', aItens[iItem].Acrescimo - dDiferencaAcrescimo)) >= 0 then
          begin
            aItens[iItem].Acrescimo := StrToCurr(FormatFloat('0.00', aItens[iItem].Acrescimo - dDiferencaAcrescimo));
            Break;
          end
          else
          begin
            dDiferencaAcrescimo := StrToCurr(FormatFloat('0.00', dDiferencaAcrescimo - aItens[iItem].Acrescimo));
            aItens[iItem].Desconto := 0.00;
          end;
          if dDiferencaAcrescimo = 0 then
            Break;
        end;
      end; // if dDiferencaAcrescimo <> 0 then

      // depois que conferiu a soma do rateio com o valor rateado adiciona no desconto o valor de desconto específico do item

      // Zera o desconto rateado aos itens do cupom
      FIBQTEMP.Close;
      FIBQTEMP.SQL.Text :=
                          'update ALTERACA set ' +
                          'DESCONTO = 0.00 ' +
                          'where PEDIDO = :PEDIDO ' +
                          ' and CAIXA = :CAIXA ' +
                          'and (TIPO = :TIPO or TIPO = ''LOKED'') ';
      FIBQTEMP.ParamByName('PEDIDO').AsString  := sCupom;
      FIBQTEMP.ParamByName('CAIXA').AsString   := sCaixa;
      FIBQTEMP.ParamByName('TIPO').AsString    := FTipo;      

      try
        FIBQTEMP.ExecSQL;
        FIBQTEMP.Transaction.Commit;
      except
        FIBQTEMP.Transaction.Rollback;
      end;

      //seleciona os itens do cupom
      //update com transaction diferente passando valor negativo para desconto

      dtotal := 0.00;
      for iItem := 0 to Length(aItens) - 1 do
      begin

        FIBQTEMP.Close;
        FIBQTEMP.SQL.Text :=
                            'update ALTERACA set ' +
                            'DESCONTO = :DESCONTO ' +
                            'where PEDIDO = :PEDIDO ' +
                            ' and CAIXA = :CAIXA ' +
                            ' and ITEM = :ITEM ' +
                            ' and (TIPO = :TIPO or TIPO = ''LOKED'') ' +
                            ' and coalesce(CODIGO, '''') <> '''' '; // Não gravar campo desconto para os registros de desconto ou acréscimo // Sandro Silva 2020-06-01
        FIBQTEMP.ParamByName('DESCONTO').AsFloat := (aItens[iItem].Desconto * (-1)) + aItens[iItem].DescontoDoItem + aItens[iItem].Acrescimo; // Inverte o sinal. Grava o desconto rateado + o desconto específico do item // Sandro Silva 2020-06-01  FIBQTEMP.ParamByName('DESCONTO').AsFloat := aItens[iItem].Desconto * (-1)
        FIBQTEMP.ParamByName('PEDIDO').AsString  := aItens[iItem].Pedido;
        FIBQTEMP.ParamByName('CAIXA').AsString   := aItens[iItem].Caixa;
        FIBQTEMP.ParamByName('ITEM').AsString    := aItens[iItem].Item;
        FIBQTEMP.ParamByName('TIPO').AsString    := FTipo;
        dtotal := dtotal + FIBQTEMP.ParamByName('DESCONTO').AsFloat;

        try
          FIBQTEMP.ExecSQL;
          FIBQTEMP.Transaction.Commit;
        except
          FIBQTEMP.Transaction.Rollback;
        end;
      end;
    end;

  finally
    SetLength(aItens, 0);
    aItens := nil;
  end;
end;

procedure TRateioDescontoAlteraca.Iniciar;
var
  iFor: Integer;
begin
  for iFor := 1 to 2 do
  begin

    if iFor = 1 then
      FTipo := 'BALCAO' // Venda registradas em ECF/NFC-e/SAT
    else
      FTipo := 'VENDA'; // Vendas registradas em blocos de notas modelo 2D

    FIBQCUPONS.Close;
    FIBQCUPONS.SQL.Text :=
                          ' Select A.PEDIDO, A.CAIXA, ' +
                          '   (Select sum(coalesce(A1.TOTAL, 0)) '+
                          '     From ALTERACA A1 '+
                          '     Where (A1.TIPO = :TIPO or A1.TIPO = ''LOKED'') '+
                          '     and A1.PEDIDO = A.PEDIDO '+
                          '     and A1.CAIXA = A.CAIXA '+
                          '     and A1.DESCRICAO = ''Desconto'' '+
                          '     and coalesce(A1.ITEM, '''') = '''') as DESCONTO, ' +
                          '   (Select sum(coalesce(A2.TOTAL, 0)) '+
                          '     From ALTERACA A2 '+
                          '     Where (A2.TIPO = :TIPO or A2.TIPO = ''LOKED'') '+
                          '     and A2.PEDIDO = A.PEDIDO '+
                          '     and A2.CAIXA = A.CAIXA '+
                          '     and A2.DESCRICAO = ''Acréscimo'' '+
                          '     and coalesce(A2.ITEM, '''') = '''') as ACRESCIMO '+
                          //Mauricio Parizotto 2022-10-17 add bloco e remover o bloco de baixo para deixar mais rápido deve ser testado primeiro
                          {'   ,(Select sum(cast(A3.TOTAL as numeric(18,2)))  ' +
                          '     From ALTERACA A3 ' +
                          '     Where A3.PEDIDO = A.PEDIDO ' +
                          '     and A3.CAIXA = A.CAIXA ' +
                          '     and A3.DESCRICAO <> ''<CANCELADO>'' ' +
                          '     and A3.TIPO <> ''KOLNAC'' ' +
                          '     and (A3.TIPO = :TIPO or A3.TIPO = ''LOKED'') ' +
                          '     and Coalesce(A3.ITEM,''XX'') <> ''XX'') as TOTAL '+ }// Não somar item cancelado. Dead lock mantem item com TIPO=KOLNAC até que seja destravado e processaDo o cancelamento
                          ' From ALTERACA A ' +
                          ' Where (A.DESCRICAO = ''Desconto'' or A.DESCRICAO = ''Acréscimo'') ' +
                          '   and coalesce(A.ITEM, '''') = '''' ' +
                          '   and A.DATA between :INICIO and :FIM ' +
                          '   and (A.TIPO = :TIPO or A.TIPO = ''LOKED'') ' +
                          ' Group by A.PEDIDO, A.CAIXA';

    FIBQCUPONS.ParamByName('INICIO').AsDate := FDataInicial;
    FIBQCUPONS.ParamByName('FIM').AsDate    := FDataFinal;
    FIBQCUPONS.ParamByName('TIPO').AsString := FTipo;
    FIBQCUPONS.Open;

    while FIBQCUPONS.Eof = False do
    begin
      FIBQTOTAL.Close;
      FIBQTOTAL.SQL.Text :=
                            ' Select sum(cast(TOTAL as numeric(18,2))) as TOTAL ' +
                            ' From ALTERACA ' +
                            ' Where PEDIDO = :PEDIDO ' +
                            '   and CAIXA = :CAIXA ' +
                            '   and DESCRICAO <> ''<CANCELADO>'' ' +
                            '   and TIPO <> ''KOLNAC'' ' +
                            '   and (TIPO = :TIPO or TIPO = ''LOKED'') ' +
                            '   and Coalesce(ITEM,''XX'') <> ''XX'' '; // Não somar item cancelado. Dead lock mantem item com TIPO=KOLNAC até que seja destravado e processaDo o cancelamento
      FIBQTOTAL.ParamByName('PEDIDO').AsString := FIBQCUPONS.FieldByName('PEDIDO').AsString;
      FIBQTOTAL.ParamByName('CAIXA').AsString  := FIBQCUPONS.FieldByName('CAIXA').AsString;
      FIBQTOTAL.ParamByName('TIPO').AsString   := FTipo;
      FIBQTOTAL.Open;

      RateioDesconto(FIBQTOTAL.FieldByName('TOTAL').AsFloat,
                    //FIBQCUPONS.FieldByName('TOTAL').AsFloat, Mauricio Parizotto 2022-10-17   trocar pelo bloco direto, ver para add tbm o campo Acrescimo na função
                    FIBQCUPONS.FieldByName('DESCONTO').AsFloat,
                    FIBQCUPONS.FieldByName('PEDIDO').AsString,
                    FIBQCUPONS.FieldByName('CAIXA').AsString);

      FIBQCUPONS.Next;
    end;
  end;
end;

procedure TRateioDescontoAlteraca.SetDataFinal(const Value: TDate);
begin
  FDataFinal := Value;
end;

procedure TRateioDescontoAlteraca.SetDataInicial(const Value: TDate);
begin
  FDataInicial := Value;
end;

procedure TRateioDescontoAlteraca.SetIBDatabase(const Value: TIBDatabase);
begin
  FIBDatabase := Value;
  FIBTLEITURA.DefaultDatabase := FIBDatabase;
  FIBTTEMP.DefaultDatabase    := FIBDatabase;
end;

procedure TRateioDescontoAlteraca.SetTipo(const Value: String);
begin
  FTipo := Value;
end;

end.
